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

#define FLASH_BASE 0x30000000
#define FLASH_SIZE 0x10000000
//#define wave

static bool ebreak_stop = 0;

static char *mem_file = NULL;
static size_t mem_words = 0;
static char *elf_file = NULL;
static char img_arr[256] = {};
char *img_file = img_arr;
char *diff_so_file = NULL;
uint8_t *flash = NULL;

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

extern "C" void flash_read(int32_t addr, int32_t *data) { 
	if(addr > 0x10000000) assert(0);
	assert((addr & 0x3u) == 0);
	int32_t biased_addr = addr + 0x30000000;
	*data = pmem_read(biased_addr);
	/*
	*data = (int32_t)(
			(flash[addr + 0] << 24 ) |
			(flash[addr + 1] << 16 ) |
			(flash[addr + 2] << 8  ) |
			(flash[addr + 3] << 0  ) 
			);
	*/
	//printf("flash read data: %x\n", *data);
}
extern "C" void mrom_read(int32_t addr, int32_t *data) {
	*data = pmem_read(addr);
}

void load_binary(const char* filename, uint8_t* memory, uint32_t offset){
    printf("Opening: %s\n", filename);
    
    FILE* fp = fopen(filename, "rb");
    if (!fp) {
        printf("Error: Cannot open %s\n", filename);
        perror("fopen");  // 打印系统错误
        assert(0);
        return;
    }
    printf("File opened successfully\n");
    
    // 获取文件大小
    fseek(fp, 0, SEEK_END);
    size_t size = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    printf("File size: %zu bytes (0x%zX)\n", size, size);
    
    if (size == 0) {
        printf("ERROR: File is empty!\n");
        fclose(fp);
        return;
    }
    
    // 读取前检查memory地址
    printf("Writing to flash[0x%X]\n", offset);
    printf("memory pointer: %p\n", memory);
    printf("memory+offset: %p\n", memory + offset);
    
    // 读取
    size_t bytes_read = fread(memory + offset, 1, size, fp);
    printf("fread returned: %zu\n", bytes_read);
    
    if (bytes_read != size) {
        printf("ERROR: fread failed! Expected %zu, got %zu\n", size, bytes_read);
        perror("fread");
    }
    
    fclose(fp);
    
    // 立即验证
    printf("First 16 bytes after load:\n");
    for (int i = 0; i < 16; i++) {
        printf("%02X ", memory[offset + i]);
    }
    printf("\n");
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

	//flash init
	flash = (uint8_t *)malloc(FLASH_SIZE);
	if(flash == NULL) {
		return -1;
	}
	memset(flash, 0x1F, FLASH_SIZE);
	printf("flash[0x1000] before: 0x%02X\n", flash[0x1000]);

	load_binary("/home/daviyang3182/ysyx/ysyx-workbench/am-kernels/tests/soc-tests/tests/soc-uart.bin", flash, 0x000);

	printf("flash[0x1000] after: 0x%02X\n", flash[0x1000]);

	// 手动写一下测试
	flash[0x1000] = 0x42;
	printf("manual write: 0x%02X\n", flash[0x1000]);

	pmem_init(mem_file,MEMORY_SIZE,&memory, &mem_words);

	top->clock= 0;
	top->reset= 1;
	top->eval();
	for(int i = 0; i < 100; i++){
		top->clock = 1;
		top->eval();
		top->clock = 0;
		top->eval();
	}

#ifdef wave
	tfp->dump(contextp->time());
	contextp->timeInc(1);
#endif
	top->clock= 1;
	top->eval();

#ifdef wave
	tfp->dump(contextp->time());
	contextp->timeInc(1);
#endif
	top->clock= 0;
	top->reset=0;
	top->eval();

#ifdef wave
	tfp->dump(contextp->time());
	contextp->timeInc(1);
#endif

	while(top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu_reset_chain__DOT__output_chain__DOT__sync_0 != 1){
		top->clock = !top->clock;
		top->eval();	
	}
	while(DTOP_IFU_STATE != 3){
		top->clock = 1;
		top->eval();

#ifdef wave
	tfp->dump(contextp->time());
	contextp->timeInc(1);
#endif
		top->clock = 0;
		top->eval();

#ifdef wave
	tfp->dump(contextp->time());
	contextp->timeInc(1);
#endif

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
	free(flash);
	delete top;
	delete contextp;
	if(npc_state.state != NPC_END || (npc_state.state == NPC_END && npc_state.halt_ret != 0)) return -1;
	else return 0;
}
