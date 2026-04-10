#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "../../include/memory.h"
#include "../../include/trace.h"
#include "Vtop.h"


#define MAX_LINE_LEN 256

uint32_t *memory = NULL;
extern Vtop*top;

long long get_us();
void pmem_read_display(paddr_t, int);
void pmem_written_display(paddr_t, int, word_t);

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

uint32_t pmem_init(const char* filename, uint32_t size_bytes, uint32_t** memory, size_t*mem_words){
	*mem_words = size_bytes / 4; //word count
							   
	*memory = (uint32_t*)calloc(*mem_words, sizeof(uint32_t));
   	if(!*memory){
   		printf("Failed to calloc memory\n");
   		return -1;
   	 }
   	
   	 if(filename){
   	 	if(parse_hex_line(filename, *memory, size_bytes) != 0){
   	 		printf("Failed to load hex file\n");
			free(*memory);
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
	//printf("addr %x read: %x\n",word_addr, memory[word_addr]);
#ifdef MTRACE_COND
	if(raddr != top->pc) pmem_read_display(raddr, memory[word_addr]);
#endif
	return (int)memory[word_addr];

}
extern "C" void pmem_write(int waddr, int wdata, char wmask, int clk){
	//if(clk == 1) return;
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
	//if(waddr == 0x87000000) {putchar(char2put);return;}
#ifdef MTRACE_COND
	pmem_written_display(waddr, 4, current);
#endif
	memory[word_addr] = current;
	//printf("addr %x written: %x\n", word_addr, memory[word_addr]);
}

void pmem_release(){
	if(memory != NULL) free(memory);
}

