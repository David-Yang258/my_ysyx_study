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
	//top->inst = pmem_read(top->pc);	
	//printf("IFU: mem_rcmd = %x\n", top->rootp->top__DOT__ifu_mem_rcmd);
	//printf("IFU: ifu_state = %x\n", top->rootp->top__DOT__inst_ifu__DOT__ifu_state);
	//printf("IFU: need2fetch = %x\n", top->rootp->top__DOT__inst_ifu__DOT__need2fetch);
	//printf("IFU: jmp_set = %x\n", top->rootp->top__DOT__jmp_set);
	//printf("IFU: ifu_valid = %x\n", top->rootp->top__DOT__ifu_valid);
	//printf("EXU: jal = %x\n", top->rootp->top__DOT__jal);
	//printf("LSU: lsu_valid = %x\n", top->rootp->top__DOT__inst_lsu__DOT__o_valid);
	//printf("IFU: pc   = %x\n", top->pc);
	//printf("IFU: inst = %x\n", top->inst);
#ifdef ITRACE_COND
	trace_inst2ringbuf(top->pc, top->inst);
#endif
#ifdef FTRACE_COND
	if(top->inst == 0x00008067)trace_func_ret(top->pc);
#endif
	do{
#ifdef DEBUGING
		printf("IFU: ifu_state = %x\n", top->rootp->top__DOT__inst_ifu__DOT__ifu_state);
		printf("LSU: lsu_wpcl= %x\n", top->rootp->top__DOT__lsu_wcpl);
		printf("LSU: lsu_rpcl= %x\n", top->rootp->top__DOT__lsu_rcpl);
		printf("LSU: lsu_mem_we_qst = %x\n",top->rootp->top__DOT__lsu_mem_we_qst);
		printf("LSU: lsu_mem_re_qst = %x\n",top->rootp->top__DOT__lsu_mem_re_qst);
		printf("MEM: mem_ready = %x\n", top->rootp->top__DOT__mem_ready);
		printf("MEM: lsu_mem_raddr = %x\n",top->rootp->top__DOT__lsu_mem_raddr);
		printf("MEM: lsu_mem_rdata = %x\n",top->rootp->top__DOT__lsu_mem_rdata);
		printf("MEM: lsu_mem_waddr = %x\n",top->rootp->top__DOT__lsu_mem_waddr);
		printf("MEM: lsu_mem_wdata = %x\n",top->rootp->top__DOT__lsu_mem_wdata);
		//printf("REG: final_reg_we = %x\n",top->rootp->top__DOT__final_reg_we);
		//printf("REG: final_rd_wdata = %x\n",top->rootp->top__DOT__final_rd_wdata);
		printf("WBU: wbu_ready = %x\n", top->rootp->top__DOT__wbu_ready);
		printf("WBU: wb_sel = %x\n", top->rootp->top__DOT__wb_sel);
		printf("\n");
#endif
		top->clk = !top->clk;
		top->eval();
		top->clk = !top->clk;
		top->eval();
	}while(top->o_ifu_state != 3);
	//top->eval();
	//top->clk = !top->clk;
	//top->eval();
	//top->clk = !top->clk;
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
		difftest_step(old_pc, cpu.pc);
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
