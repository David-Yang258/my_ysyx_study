#include <common.h>
#include <elf.h>
#define INST_BUF_NUM 16 

typedef struct {
	word_t pc;
	uint32_t inst;
} Inst;

typedef struct{
	Inst iringbuf[INST_BUF_NUM];
	uint32_t front;
	uint32_t rear;
	uint32_t size;
} Iringbuf;

Iringbuf MYIRINGBUF;

void init_iring(Iringbuf *ir){
	ir->front = 0;
	ir->rear  = 0;
	ir->size  = 0;
}

bool is_empty(Iringbuf *ir){
	return ir->front == ir->rear;
}

bool is_full(Iringbuf *ir){
	return (ir->rear + 1) % INST_BUF_NUM == ir->front;
}

bool enbuf(Iringbuf *ir, word_t pc, uint32_t inst){
	if(is_full(ir)) return false;
	ir->iringbuf[ir->rear].pc   = pc;
    ir->iringbuf[ir->rear].inst = inst;	
	ir->rear = (ir->rear + 1) % INST_BUF_NUM;
	ir->size++;
	return true;
}

bool debuf(Iringbuf *ir){
	if (is_empty(ir)) return false;
	ir->front = (ir->front + 1) % INST_BUF_NUM;
	ir->size--;
	return true;
}

bool trace_inst2ringbuf(word_t pc, uint32_t inst){
	static bool init_flag = 0;
	if(!init_flag){
		init_iring(&MYIRINGBUF);
		init_flag = 1;
	}
	if(is_full(&MYIRINGBUF)){
		debuf(&MYIRINGBUF);
		return enbuf(&MYIRINGBUF, pc, inst);
	}
	else return enbuf(&MYIRINGBUF, pc, inst);
}

void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

void iringbuf_display(){
	char buf[256];
	char *p;
	uint32_t ptr = MYIRINGBUF.front;
	while(ptr != MYIRINGBUF.rear){
		p = buf;
		p += sprintf(buf, "%s" FMT_WORD ": %08x ", 
				(ptr == ((MYIRINGBUF.rear + INST_BUF_NUM -1) % INST_BUF_NUM)) ? " --->" : "     ",
				MYIRINGBUF.iringbuf[ptr].pc,
				MYIRINGBUF.iringbuf[ptr].inst);
		disassemble(p, buf+sizeof(buf) - p,
			   		MYIRINGBUF.iringbuf[ptr].pc,
			   		(uint8_t *)&MYIRINGBUF.iringbuf[ptr].inst,
					4);
		puts(buf);
		ptr = (ptr + 1) %INST_BUF_NUM;
	}
}

void pmem_read_display(paddr_t addr, int len){
	printf("pmem read at " FMT_PADDR " len=%d\n",addr, len);	
}

void pmem_written_display(paddr_t addr, int len, word_t data){
	printf("pmem written at " FMT_PADDR " len=%d, data=" FMT_WORD "\n",
			addr, len, data);	
}

typedef struct{
	char *sym_name;
	Elf32_Addr sym_addr;
	int sym_size;
}symbol_t;

static uint32_t call_depth;
extern symbol_t* symbol_tbl;
char* find_func_name(symbol_t *, Elf32_Addr);

void trace_func_call(paddr_t pc, paddr_t target_func_addr){
	if(symbol_tbl == NULL) return;
	++call_depth;
		
	char *func_name = find_func_name(symbol_tbl, target_func_addr);
    printf(FMT_PADDR ": %*scall [%s@" FMT_PADDR "]\n",
			pc,
			(call_depth)*2, "",
			func_name,
			target_func_addr
			);	
}

void trace_func_ret(paddr_t pc){
	char *func_name = find_func_name(symbol_tbl, pc);
	printf(FMT_PADDR ": %*sret [%s]\n",
			pc,
		  	(call_depth)*2, "",
			func_name
			);
	--call_depth;
}

void etrace(const char *iname, vaddr_t mepc, word_t mcause, word_t gpr, word_t mtvec){
#ifdef ETRACE_COND
	printf("etrace fname: %s, mepc = " FMT_WORD ", mcause = " FMT_WORD ", gpr(a5/a7) = " FMT_WORD ", mtvec = " FMT_WORD "\n", iname, mepc, mcause, gpr, mtvec);
#endif
}
