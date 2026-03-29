#ifndef __PADDR_H__
#define __PADDR_H__

#include "rv32im.h"
#include <assert.h>

#define CONFIG_MBASE 0x80000000
#define CONFIG_MSIZE 0x8000000
#define CONFIG_PC_RESET_OFFSET 0

#define PMEM_LEFT  ((paddr_t)CONFIG_MBASE)
#define PMEM_RIGHT ((paddr_t)CONFIG_MBASE + CONFIG_MSIZE -1)
#define RESET_VECTOR (PMEM_LEFT + CONFIG_PC_RESET_OFFSET)

#define CONFIG_PMEM_MALLOC

uint8_t* guest_to_host(paddr_t paddr);

#endif

