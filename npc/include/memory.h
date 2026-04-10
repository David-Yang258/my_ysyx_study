#ifndef __MEMORY_H__
#define __MEMORY_H__

#include "rv32im.h"

extern uint32_t *memory;

int parse_hex_line(const char *filename, uint32_t *memory, size_t mem_size);
uint32_t pmem_init(const char*, uint32_t, uint32_t**, size_t);
extern "C" int pmem_read(int);
extern "C" void pmem_write(int, int, char, int);

#endif
