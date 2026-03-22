// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated.h"


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    CData/*0:0*/ top__DOT__jmp_set;
    CData/*4:0*/ top__DOT__rd;
    CData/*4:0*/ top__DOT__rs1;
    CData/*4:0*/ top__DOT__rs2;
    CData/*4:0*/ top__DOT__shamt;
    CData/*0:0*/ top__DOT__reg_wen;
    CData/*0:0*/ top__DOT__mem_wen;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VstlPhaseResult;
    CData/*0:0*/ __VicoFirstIteration;
    CData/*0:0*/ __VicoPhaseResult;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    VL_IN(inst,31,0);
    VL_OUT(pc,31,0);
    IData/*31:0*/ top__DOT__setbits;
    IData/*31:0*/ top__DOT__imm;
    IData/*31:0*/ top__DOT__rd_wdata;
    IData/*31:0*/ top__DOT__inst_pc__DOT__pc_cnt;
    IData/*31:0*/ top__DOT__inst_inst_decode__DOT__immI;
    IData/*31:0*/ top__DOT__inst_inst_exec__DOT__mem_raddr;
    IData/*31:0*/ top__DOT__inst_inst_exec__DOT__mem_waddr;
    IData/*31:0*/ top__DOT__inst_gpr__DOT__rdata1;
    IData/*31:0*/ top__DOT__inst_gpr__DOT__rdata2;
    IData/*31:0*/ __Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__1__Vfuncout;
    IData/*31:0*/ __Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__3__Vfuncout;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 32> top__DOT__inst_gpr__DOT__rf;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VicoTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    VlUnpacked<CData/*0:0*/, 3> __Vm_traceActivity;

    // INTERNAL VARIABLES
    Vtop__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* namep);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
