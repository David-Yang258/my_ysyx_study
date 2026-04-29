#include "../../include/isa/isa-def.h"
#include "../../include/rv32im.h"
#include "Vtop.h"
#include "../../build/obj_dir/Vtop___024root.h"
#include "../../include/debug.h"

extern Vtop* top;

bool isa_difftest_checkregs(CPU_state *ref_r, vaddr_t pc){
	int cpu_reg_num = ARRLEN(ref_r->gpr);
	uint32_t diff_pc = top->pc;
	if(diff_pc != ref_r->pc) {
		printf("npc and ref have different pc!\n");
		printf("npc pc is %x\n", top->rootp->top__DOT__lsu_wbu_pc);
		printf("ref pc is %x\n", ref_r->pc);
		return false;
	}
	for(int i = 0;i<cpu_reg_num;i++){
		if(ref_r->gpr[i] != top->rootp->top__DOT__inst_gpr__DOT__rf[i]){
			 Log("%s Reg content is different after executing instruction at pc ="       FMT_WORD
                        ", right = " FMT_WORD ", wrong = " FMT_WORD ", diff = "
                        FMT_WORD, ANSI_FMT("DIFFTEST ERROR!", ANSI_FG_RED),pc, ref_r->gpr[i], top->rootp->top__DOT__inst_gpr__DOT__rf[i], ref_r->gpr[i] ^ top->rootp->top__DOT__inst_gpr__DOT__rf[i]);
                return false;
		}
	}
	return true;
}

