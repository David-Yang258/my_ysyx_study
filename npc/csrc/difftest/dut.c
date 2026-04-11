#include "../../include/isa/isa-def.h"
#include "../../include/rv32im.h"
#include "../../include/debug.h"
#include "../../include/cpu/cpu.h"


bool isa_difftest_checkregs(CPU_state *ref_r, vaddr_t pc){
	int cpu_reg_num = ARRLEN(ref_r->gpr);
	if(DTOP_PC != ref_r->pc) {
		printf("npc pc is %x\n", DTOP_PC);
		printf("ref pc is %x\n", ref_r->pc);
		return false;
	}
	for(int i = 0;i<cpu_reg_num;i++){
		if(ref_r->gpr[i] != DTOP_RF[i]){
			 Log("%s Reg content is different after executing instruction at pc ="       FMT_WORD
                        ", right = " FMT_WORD ", wrong = " FMT_WORD ", diff = "
                        FMT_WORD, ANSI_FMT("DIFFTEST ERROR!", ANSI_FG_RED),pc, ref_r->gpr[i], DTOP_RF[i], ref_r->gpr[i] ^ DTOP_RF[i]);
                return false;
		}
	}
	return true;
}

