/***************************************************************************************
* Copyright (c) 2014-2024 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <isa.h>
#include "local-include/reg.h"

const char *regs[] = {
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6","pc"
};

void isa_reg_display() {
	int i, cnt;
#ifndef CONFIG_RVE
	for(i = 0,cnt=1;i<sizeof(regs)/sizeof(regs[0]);i++,cnt++) {
		if(i == 32) printf("%s : %x   \n",regs[i], cpu.pc);
		else printf("%s : %x   ",regs[i], cpu.gpr[check_reg_idx(i)]);
		if(cnt % 4 == 0) printf("\n");
	}
#endif
#ifdef CONFIG_RVE
	for(i = 0,cnt=1;i<16;i++,cnt++) {
		if(i == 16) printf("pc : %x   \n", cpu.pc);
		else printf("%s : %x   ",regs[i], cpu.gpr[check_reg_idx(i)]);
		if(cnt % 4 == 0) printf("\n");
	}
#endif
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
  if(*success == 1 && cnt != 32) return cpu.gpr[check_reg_idx(cnt)];
  else if(*success) return cpu.pc;
  else return 0;
}
