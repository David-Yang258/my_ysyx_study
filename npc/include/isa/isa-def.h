#ifndef __ISA_RISCV_H__
#define __ISA_RISCV_H__

#include "../macro.h"
#include "../rv32im.h"
#include "../utils.h"

typedef struct {
	word_t gpr[16];
	vaddr_t pc;
} CPU_state;


#endif
