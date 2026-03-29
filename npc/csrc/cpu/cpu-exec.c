#include "../../include/cpu/cpu.h"
#include "Vtop.h" 
#include "../../include/utils.h"
#include "../../include/debug.h"
#include "../../include/trace.h"
#include "../../include/isa/isa-def.h"
#include "../../include/config.h"
#include "../../build/obj_dir/Vtop___024root.h"
#include "../../include/paddr.h"

#define MAX_INST_TO_PRINT 20
#define NR_GPR 16


extern Vtop* top;
static word_t old_pc = 0;

extern "C" int pmem_read(int);
void isa_reg_display();
word_t ReEvalWPs();
bool trace_inst2ringbuf(word_t, uint32_t);
void iringbuf_display();
void trace_func_ret(paddr_t);
void difftest_step(vaddr_t, vaddr_t);

CPU_state cpu = {};

void init_diff_cpu(){
	cpu.pc = RESET_VECTOR;
	for (int i = 0;i<NR_GPR;i++){
		cpu.gpr[i] = 0;
	}
}

static void exec_once(){
	if(top->clk != 0) top->clk = 0;
	old_pc = top->pc;
	top->inst = pmem_read(top->pc);	
#ifdef ITRACE_COND
	trace_inst2ringbuf(top->pc, top->inst);
#endif
#ifdef FTRACE_COND
	if(top->inst == 0x00008067)trace_func_ret(top->pc);
#endif
	top->eval();
	top->clk = !top->clk;
	top->eval();
	top->clk = !top->clk;
	cpu.pc = top->pc;
	for(int i = 0;i < NR_GPR;i++){
		cpu.gpr[i] = top->rootp->top__DOT__inst_gpr__DOT__rf[i];
	}
	if(ReEvalWPs()) npc_state.state = NPC_STOP;
}

static void execute(uint64_t n){
	for (;n>0; n--){
		exec_once();
		//IFDEF(CONFIG_DIFFTEST,difftest_step(old_pc, cpu.pc));
		//difftest_step(old_pc, cpu.pc);
		if(npc_state.state != NPC_RUNNING) break;
	}
}

void cpu_exec(uint64_t n){
	switch(npc_state.state){
		case NPC_END: case NPC_ABORT: case NPC_QUIT:
			printf("Program execution has ended. To restart, exit NPC and run again\n");
		return;
		default: npc_state.state = NPC_RUNNING;	
	}

	execute(n);

	switch(npc_state.state){
		case NPC_RUNNING: npc_state.state = NPC_STOP;break;
		
		case NPC_END: case NPC_ABORT:
		Log("npc: %s at pc = " FMT_WORD,
            (npc_state.state == NPC_ABORT ? ANSI_FMT("ABORT", ANSI_FG_RED) :
             (npc_state.halt_ret == 0 ? ANSI_FMT("HIT GOOD TRAP", ANSI_FG_GREEN) :
              ANSI_FMT("HIT BAD TRAP", ANSI_FG_RED))),
            npc_state.halt_pc);
		if(npc_state.halt_ret != 0) iringbuf_display();
		if(npc_state.state == NPC_ABORT) iringbuf_display(); 
		case NPC_QUIT: ;
	}
}
void assert_fail_msg(){
	isa_reg_display();
}
