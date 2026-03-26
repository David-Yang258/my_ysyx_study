#include "../../include/paddr.h"

static uint8_t *pmem = NULL;

void init_mem(){
#if defined (CONFIG_PMEM_MALLOC)
	pmem = malloc(CONFIG_MSIZE);
	assert(pmem);
#endif
}

uint8_t* guest_to_host(paddr_t paddr) {return pmem + paddr - CONFIG_MBASE;}
