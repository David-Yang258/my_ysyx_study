#include "../../include/paddr.h"
#include <string.h>

static uint8_t *pmem = NULL;
extern uint32_t *memory;
extern uint32_t mem_words;

void init_mem(){
#if defined (CONFIG_PMEM_MALLOC)
	pmem = (uint8_t*)memory + CONFIG_MBASE;
	assert(pmem);
#endif
}

uint8_t* guest_to_host(paddr_t paddr) {return pmem + paddr - CONFIG_MBASE;}
