#include <verilated.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>
#include <string.h>

#include "../include/memory.h"
#include "sdb/sdb.h"

#include "../include/utils.h"
#include "../include/debug.h"

#include "top.h"

#include "verilated_vcd_c.h"
#include "VysyxSoCFull.h"

#define MAX_LINE_LEN 256
#define MEMORY_SIZE (-1)

static bool ebreak_stop = 0;

static char *mem_file = NULL;
static size_t mem_words = 0;
static char *elf_file = NULL;
static char img_arr[256] = {};
char *img_file = img_arr;
char *diff_so_file = NULL;

VerilatedContext *contextp = NULL;

VysyxSoCFull *top = NULL;

VerilatedVcdC *tfp = NULL;


extern "C" void ebreak(){
	npc_state.state = NPC_END;
	npc_state.halt_pc = DTOP_PC;
	npc_state.halt_ret = DTOP_RF[10];
	ebreak_stop = 1;
}
extern "C" void assert_abort(){
	printf("Assert failed!\n");
	npc_state.state = NPC_ABORT;
	npc_state.halt_pc = DTOP_PC;
	npc_state.halt_ret = DTOP_RF[10];
}
extern "C" void ecall(){
	printf("ECALL!\n");
	printf("npc mcause: %x\n", DTOP_MCAUSE);
	printf("npc mtvec: %x\n", DTOP_MTVEC);
	printf("npc mepc: %x\n", DTOP_MEPC);
}

extern "C" void uart_printf(int wdata, int clock){
	int wdata1 = wdata;
	int char2put = wdata1 & 0xFF; 
	putchar(char2put);
}

extern "C" void flash_read(int32_t addr, int32_t *data) { assert(0); }
extern "C" void mrom_read(int32_t addr, int32_t *data) {
	*data = pmem_read(addr);
	//printf("addr = %x\n", addr);
	//printf("data_addr = %p\n",data);	
}

int parse_hex_line(const char *filename, uint32_t *memory, size_t mem_size);
uint32_t pmem_init(const char* filename, uint32_t size_bytes, uint32_t** memory, size_t*mem_words);

extern "C" int pmem_read(int raddr);
extern "C" void pmem_write(int waddr, int wdata, char wmask, int clock);

long long get_us();

void init_sdb();
void sdb_set_batch_mode();
void sdb_mainloop();
void interpret_elf(const char*);


int main(int argc, char* argv[]){
	Verilated::commandArgs(argc, argv);
	contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	top = new TOP_TYPE{contextp};

	tfp = new VerilatedVcdC;
	contextp->traceEverOn(true);
	top->trace(tfp,0);
	tfp->open("wave.vcd");

	for(int i = 1;i < argc; i++){
		if(strcmp(argv[i], "--img") == 0 && i+1 < argc){
			mem_file = argv[++i];	
			strcpy(img_file, mem_file);
			printf("%s\n",mem_file);
		}
		if(strcmp(argv[i], "-b") == 0){
			sdb_set_batch_mode();	
		}
		if(strcmp(argv[i], "-e") == 0 && i+1 < argc){
			elf_file = argv[++i];
			interpret_elf(elf_file);
		}
		if(strcmp(argv[i], "-d") == 0 && i+1 < argc){
			diff_so_file = argv[++i];
			if(diff_so_file != NULL){
				Log("Diff_so_file %s loaded\n",diff_so_file);
			}
		}
		else if (strcmp(argv[i], "--help")==0){
			printf("Usage: %s [options]\n", argv[0]);
			printf("   --img FILE 	Load image file\n");
			return 0;
		}
	}

	pmem_init(mem_file,MEMORY_SIZE,&memory, &mem_words);

	top->clock= 0;
	top->reset= 1;
	top->eval();

	top->clock= 1;
	top->eval();

	top->clock= 0;
	top->reset=0;
	top->eval();

	printf("pc = %x\n", DTOP_PC);

	while(DTOP_IFU_STATE != 3){
		top->clock = 1;
		top->eval();
		printf("clk: %d\n",top->clock);
		top->clock = 0;
		top->eval();
		printf("clk: %d\n",top->clock);
		printf("rst: %d\n",top->reset);
#ifdef DEBUGING
		printf("IFU: ifu_state = %x\n", DTOP_IFU_STATE);
		printf("LSU: lsu_state = %x\n", top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ysyx_26030090_lsu__DOT__mem_state);
		printf("LSU: lsu_arvalid = %x\n",top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__lsu_arvalid);
        printf("IFU: ifu_arvalid = %x\n",top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ifu_arvalid);
		printf("IFU: ifu_rvalid = %x\n", top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ysyx_26030090_bridge__DOT__l_rvalid);
#endif
	}

	printf("Entered main\n");
		init_sdb();
		sdb_mainloop();
		if (ebreak_stop){
			printf("Simulation stop due to ebreak\n");
		}
	top->final();
	tfp->close();
	delete top;
	delete contextp;
	if(npc_state.state != NPC_END || (npc_state.state == NPC_END && npc_state.halt_ret != 0)) return -1;
	else return 0;
}
