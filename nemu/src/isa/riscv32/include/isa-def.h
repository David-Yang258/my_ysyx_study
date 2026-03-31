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

#ifndef __ISA_RISCV_H__
#define __ISA_RISCV_H__

#include <common.h>

typedef struct{
  word_t 	mcause; 	//M Abnormality cause
  vaddr_t 	mepc; 		//M Abnormality pc
  word_t 	mstatus; 	//M mode status
  word_t 	mtvec; 		//M mode trap vector
  word_t 	mie; 		//M mode interrupt ena
  word_t 	mip; 		//M mode interrupt hang up
  word_t    mvendorid;  //M mode vendor id
  word_t    marchid; 	//M mode arch id
} MUXDEF(CONFIG_RV64, riscv64_CSRs, riscv32_CSRs);

typedef struct {
  word_t gpr[MUXDEF(CONFIG_RVE, 16, 32)];
  vaddr_t pc;
  MUXDEF(CONFIG_RV64, riscv64_CSRs, riscv32_CSRs) csr;
} MUXDEF(CONFIG_RV64, riscv64_CPU_state, riscv32_CPU_state);

// decode
typedef struct {
  uint32_t inst;
} MUXDEF(CONFIG_RV64, riscv64_ISADecodeInfo, riscv32_ISADecodeInfo);


#define isa_mmu_check(vaddr, len, type) (MMU_DIRECT)

#endif
