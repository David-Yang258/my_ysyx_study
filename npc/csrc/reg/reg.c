#include "../../include/rv32im.h"
#include "../../include/debug.h"
#include "../../include/cpu/cpu.h"
const char *regs[] = {
    "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
    "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
    "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
    "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6","pc"
  };

void isa_reg_display() {
  int i, cnt;
  for(i = 0,cnt=1;i<sizeof(regs)/sizeof(regs[0]);i++,cnt++) {
	  if(i == 32) printf("%s : %x   \n",regs[i], DTOP_PC);
	  else printf("%s : %x   ",regs[i], DTOP_RF[i]);
	  if(cnt % 4 == 0) printf("\n");
  }
}

word_t isa_reg_str2val(const char *s, bool *success) {
    if(success == NULL) panic("INVALID ptr to call!\n");
    int cnt = 0;
    *success = 0;
    while(cnt < sizeof(regs)/sizeof(regs[0])){
      //printf("%s, %s", s, regs[check_reg_idx(cnt)]);
      if(!strcmp(s, regs[cnt])) {
          *success = 1;
          break;
      }
      cnt++;
    }
    if(*success == 1 && cnt != 32) return DTOP_RF[cnt];
    else if(*success) return DTOP_PC;
    else return 0;
}
