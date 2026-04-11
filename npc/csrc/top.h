#ifndef __TOP_H__
#define __TOP_H__
#include "../include/ifsoc.h"

#ifdef SOC
#define TOP_HEADER "VysyxSoCFull.h"
#define PIN_HEADER "../build/obj_dir/VysyxSoCFull___024root.h"
#define TOP_TYPE   VysyxSoCFull
#define DTOP_PC top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__pc
#define DTOP_INST top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__instruction
#define DTOP_RF top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ysyx_26030090_gpr__DOT__rf
#define DTOP_IFU_STATE top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ysyx_26030090_ifu__DOT__ifu_state
#define DTOP_MCAUSE top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ysyx_26030090_csr__DOT__mcause
#define DTOP_MEPC top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ysyx_26030090_csr__DOT__mepc
#define DTOP_MTVEC top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ysyx_26030090_csr__DOT__mtvec
   
#else
#define TOP_HEADER "Vysyx_26030090.h"
#define PIN_HEADER "../build/obj_dir/Vysyx_26030090___024root.h"
#define TOP_TYPE   Vysyx_26030090
#define DTOP_PC top->rootp->ysyx___DOT__pc
#define DTOP_INST top->rootp->ysyx___DOT__instruction
#define DTOP_RF top->rootp->ysyx_26030090__DOT__ysyx_26030090_gpr__DOT__rf
#define DTOP_IFU_STATE top->rootp->ysyx___DOT__ysyx_26030090_ifu__DOT__ifu_state
#define DTOP_MCAUSE top->rootp->ysyx_26030090__DOT__ysyx_26030090_csr__DOT__mcause
#define DTOP_MTVEC top->rootp->ysyx_26030090__DOT__ysyx_26030090_csr__DOT__mtvec
#define DTOP_MEPC top->rootp->ysyx_26030090__DOT__ysyx_26030090_csr__DOT__mepc

#endif

#include TOP_HEADER
#include PIN_HEADER

#endif
