#include "verilated.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include <ctime>
#include <chrono>
#include <sys/time.h>
#include "Vtop.h"
#include "verilated_vcd_c.h"

#include "obj_dir/Vtop___024root.h"

#define MAX_LINE_LEN 256
#define MEMORY_SIZE (-1)

static bool ebreak_stop = 0;

const char* mem_file = NULL;
static uint32_t *memory = NULL;
static size_t mem_words = 0;



extern "C" void ebreak(){
	ebreak_stop = 1;
}
int parse_hex_line(const char *filename, uint32_t *memory, size_t mem_size);
uint32_t pmem_init(const char* filename, uint32_t size_bytes);

extern "C" int pmem_read(int raddr);
extern "C" void pmem_write(int waddr, int wdata, char wmask, int clk);

long long get_us();


int main(int argc, char* argv[]){
	VerilatedContext* contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	Vtop* top = new Vtop{contextp};
	
	VerilatedVcdC* tfp = new VerilatedVcdC;
	contextp->traceEverOn(true);
	top->trace(tfp,10);
	tfp->open("./obj_dir/wave.vcd");

	for(int i = 1;i < argc; i++){
		if(strcmp(argv[i], "--img") == 0 && i+1 < argc){
			mem_file = argv[++i];	
			printf("%s\n",mem_file);
		}
		else if (strcmp(argv[i], "--help")==0){
			printf("Usage: %s [options]\n", argv[0]);
			printf("   --img FILE 	Load image file\n");
			return 0;
		}
	}

	pmem_init(mem_file,MEMORY_SIZE);

	int count = 0;
	top->clk  = 0;
	top->rootp->top__DOT__inst_pc__DOT__pc_cnt = 0x80000000;

	printf("Entered main\n");
	while (!contextp->gotFinish()) {

		if(top->clk) {
			top->inst = pmem_read(top->pc);
			//printf("PC: %x\n", top->pc);
			//printf("Inst: %x\n", top->inst);
		}
		
		top->eval();
/*
		if(top->clk){
			int cnt = 1;
			for(int i = 0;i < 16;i++){
				printf("x%d: %x\t", i, top->rootp->top__DOT__inst_gpr__DOT__rf[i]);
				if(cnt == 4) {
					printf("\n");
					cnt = 0;
				}	
				cnt++;
			}
		}
		printf("\n");
		*/

		tfp->dump(contextp->time());
		top->clk = !top->clk;
		count++;
		contextp->timeInc(1);
		if (ebreak_stop){
			printf("Simulation stop due to ebreak\n");
			break;
		}
	}
	top->final();
	delete top;
	tfp->close();
	delete contextp;
	if(top->rootp->top__DOT__inst_gpr__DOT__rf[10] == 0){
		printf("\033[32mHIT GOOD TRAP\033[0m\n");
		exit(0);
	}
	else {
		printf("\033[31mHIT BAD TRAP\033[0m\n");
		exit(1);
	}
	return 0;
}

int parse_hex_line(const char *filename, uint32_t *memory, size_t mem_size){
	FILE *fp = fopen(filename, "r");
	if(!fp){
		printf("FILE NOT FOUND: %s\n", filename);
		return -1;
	}

	char line[MAX_LINE_LEN];
	int  line_num = 0;

	while(fgets(line, sizeof(line), fp)){
		line_num++;

		if(line[0] == '\n' || line[0] == '\r') continue;	
	
		uint32_t addr;
		char *token = strtok(line, ":");
		if(!token) continue;

		if(sscanf(token, "%x", &addr) != 1){
			printf("Address %s extraction failed on line %d\n",token,line_num);
			continue;
		}

		token = strtok(NULL, " ");

		int word_cnt = 0;
		while(token){
			if(token[0] == '/' || token[0] == '#') break;

			uint32_t data;
			if(sscanf(token, "%x", &data) == 1){
				if((addr + word_cnt) * 4 < mem_size){
					memory[(addr + word_cnt)] = data;
				}
				word_cnt++;
			}
			token = strtok(NULL, " ");
		}
		
	}
	fclose(fp);
	return 0;
}



uint32_t pmem_init(const char* filename, uint32_t size_bytes){
	mem_words = size_bytes / 4;//word count
	
	memory = (uint32_t*)calloc(mem_words, sizeof(uint32_t));
	if(!memory){
		printf("Failed to calloc memory\n");
		return -1;
	}

	if(filename){
		if(parse_hex_line(filename, memory, size_bytes) != 0){
			printf("Failed to load hex file\n");
		}
	}
	return 0;
}
extern "C" int pmem_read(int raddr){
	//printf("raddr: %x\n", raddr);
	static uint64_t this_us;
	if(raddr == 0xa0000048){
		this_us = get_us();
		return (uint32_t)(this_us & 0xFFFFFFFF);
	}
	if(raddr == 0xa000004c){
		return (uint32_t)((this_us >> 32) & 0xFFFFFFFF);
	}

	uint32_t aligned_addr = raddr & ~0x3u;
	uint32_t word_addr = aligned_addr / 4;
	//printf("addr %x read: %x\n", word_addr, memory[word_addr]);
	return (int)memory[word_addr];
}


extern "C" void pmem_write(int waddr, int wdata, char wmask, int clk){
	if(clk == 1) return;
	//printf("waddr: %x\n", waddr);
	uint32_t aligned_addr = waddr & ~0x3u;
	uint32_t word_addr = aligned_addr / 4;

	uint32_t current = memory[word_addr];
	int char2put;
	uint8_t *byte_write = (uint8_t*)&current;
	for(int i=0;i<4;i++){
		if(wmask & (1<<i)){
			byte_write[i] = (wdata >> (i * 8)) & 0xFF;
			char2put = byte_write[i];
		}	
	}
	if(waddr == 0x10000000) {putchar(char2put);return;}
	memory[word_addr] = current;
	//printf("addr %x written: %x\n", word_addr, memory[word_addr]);	
}

long long get_us(){
	static struct timeval start;
	static int first = 1;
	struct timeval now;

	gettimeofday(&now, NULL);

	if(first){
		start = now;
		first = 0;
		return 0;
	}
	return (now.tv_sec - start.tv_sec) * 1000000LL + (now.tv_usec - start.tv_usec);
}
