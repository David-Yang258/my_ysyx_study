#include "verilated.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "Vtop.h"

#include "../include/memory.h"
#include "sdb/sdb.h"

#include "../build/obj_dir/Vtop___024root.h"
#include "../include/utils.h"
#include "../include/debug.h"

#define MAX_LINE_LEN 256
#define MEMORY_SIZE (-1)

static bool ebreak_stop = 0;

static char *mem_file = NULL;
static size_t mem_words = 0;
static char *elf_file = NULL;
static char img_arr[256] = {};
char *img_file = img_arr;
char *diff_so_file = NULL;

Vtop *top = NULL;


extern "C" void ebreak(){
	npc_state.state = NPC_END;
	npc_state.halt_pc = top->pc;
	npc_state.halt_ret = top->rootp->top__DOT__inst_gpr__DOT__rf[10];
	ebreak_stop = 1;
}
extern "C" void assert_abort(){
	printf("Assert failed!\n");
	npc_state.state = NPC_ABORT;
	npc_state.halt_pc = top->pc;
	npc_state.halt_ret = top->rootp->top__DOT__inst_gpr__DOT__rf[10];
}
extern "C" void ecall(){
	printf("ECALL!\n");
	printf("npc mcause: %x\n", top->rootp->top__DOT__inst_csr__DOT__mcause);
	printf("npc mtvec: %x\n", top->rootp->top__DOT__inst_csr__DOT__mtvec);
	printf("npc mepc: %x\n", top->rootp->top__DOT__inst_csr__DOT__mepc);
}

int parse_hex_line(const char *filename, uint32_t *memory, size_t mem_size);
uint32_t pmem_init(const char* filename, uint32_t size_bytes, uint32_t** memory, size_t*mem_words);

extern "C" int pmem_read(int raddr);
extern "C" void pmem_write(int waddr, int wdata, char wmask, int clk);

long long get_us();

void init_sdb();
void sdb_set_batch_mode();
void sdb_mainloop();
void interpret_elf(const char*);


int main(int argc, char* argv[]){
	VerilatedContext* contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	top = new Vtop{contextp};
	
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

	top->clk  = 0;
	top->rootp->top__DOT__inst_pc__DOT__pc_cnt = 0x80000000;
	top->eval();

	printf("Entered main\n");
		init_sdb();
		sdb_mainloop();
		if (ebreak_stop){
			printf("Simulation stop due to ebreak\n");
		}
	top->final();
	delete top;
	delete contextp;
	if(npc_state.state != NPC_END || (npc_state.state == NPC_END && npc_state.halt_ret != 0)) return -1;
	else return 0;
}
