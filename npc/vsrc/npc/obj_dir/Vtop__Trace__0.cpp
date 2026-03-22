// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


void Vtop___024root__trace_chg_0_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtop___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_0\n"); );
    // Body
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vtop___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtop___024root__trace_chg_0_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_0_sub_0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgIData(oldp+0,(vlSelfRef.top__DOT__imm),32);
        bufp->chgCData(oldp+1,(vlSelfRef.top__DOT__rd),5);
        bufp->chgCData(oldp+2,(vlSelfRef.top__DOT__rs1),5);
        bufp->chgCData(oldp+3,(vlSelfRef.top__DOT__rs2),5);
        bufp->chgCData(oldp+4,(vlSelfRef.top__DOT__shamt),5);
        bufp->chgIData(oldp+5,(vlSelfRef.top__DOT__inst_inst_decode__DOT__immI),32);
    }
    if (VL_UNLIKELY(((vlSelfRef.__Vm_traceActivity[1U] 
                      | vlSelfRef.__Vm_traceActivity[2U])))) {
        bufp->chgBit(oldp+6,(vlSelfRef.top__DOT__jmp_set));
        bufp->chgIData(oldp+7,(vlSelfRef.top__DOT__setbits),32);
        bufp->chgIData(oldp+8,(vlSelfRef.top__DOT__inst_gpr__DOT__rdata1),32);
        bufp->chgIData(oldp+9,(vlSelfRef.top__DOT__inst_gpr__DOT__rdata2),32);
        bufp->chgIData(oldp+10,(vlSelfRef.top__DOT__rd_wdata),32);
        bufp->chgBit(oldp+11,(vlSelfRef.top__DOT__reg_wen));
        bufp->chgBit(oldp+12,(vlSelfRef.top__DOT__mem_wen));
        bufp->chgIData(oldp+13,(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr),32);
        bufp->chgIData(oldp+14,(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr),32);
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[2U]))) {
        bufp->chgIData(oldp+15,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[0]),32);
        bufp->chgIData(oldp+16,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[1]),32);
        bufp->chgIData(oldp+17,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[2]),32);
        bufp->chgIData(oldp+18,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[3]),32);
        bufp->chgIData(oldp+19,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[4]),32);
        bufp->chgIData(oldp+20,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[5]),32);
        bufp->chgIData(oldp+21,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[6]),32);
        bufp->chgIData(oldp+22,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[7]),32);
        bufp->chgIData(oldp+23,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[8]),32);
        bufp->chgIData(oldp+24,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[9]),32);
        bufp->chgIData(oldp+25,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[10]),32);
        bufp->chgIData(oldp+26,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[11]),32);
        bufp->chgIData(oldp+27,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[12]),32);
        bufp->chgIData(oldp+28,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[13]),32);
        bufp->chgIData(oldp+29,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[14]),32);
        bufp->chgIData(oldp+30,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[15]),32);
        bufp->chgIData(oldp+31,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[16]),32);
        bufp->chgIData(oldp+32,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[17]),32);
        bufp->chgIData(oldp+33,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[18]),32);
        bufp->chgIData(oldp+34,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[19]),32);
        bufp->chgIData(oldp+35,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[20]),32);
        bufp->chgIData(oldp+36,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[21]),32);
        bufp->chgIData(oldp+37,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[22]),32);
        bufp->chgIData(oldp+38,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[23]),32);
        bufp->chgIData(oldp+39,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[24]),32);
        bufp->chgIData(oldp+40,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[25]),32);
        bufp->chgIData(oldp+41,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[26]),32);
        bufp->chgIData(oldp+42,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[27]),32);
        bufp->chgIData(oldp+43,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[28]),32);
        bufp->chgIData(oldp+44,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[29]),32);
        bufp->chgIData(oldp+45,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[30]),32);
        bufp->chgIData(oldp+46,(vlSelfRef.top__DOT__inst_gpr__DOT__rf[31]),32);
        bufp->chgIData(oldp+47,(vlSelfRef.top__DOT__inst_pc__DOT__pc_cnt),32);
    }
    bufp->chgBit(oldp+48,(vlSelfRef.clk));
    bufp->chgBit(oldp+49,(vlSelfRef.rst));
    bufp->chgIData(oldp+50,(vlSelfRef.inst),32);
    bufp->chgIData(oldp+51,(vlSelfRef.pc),32);
    bufp->chgCData(oldp+52,((vlSelfRef.inst >> 0x00000019U)),7);
    bufp->chgCData(oldp+53,((0x0000007fU & vlSelfRef.inst)),7);
    bufp->chgCData(oldp+54,((7U & (vlSelfRef.inst >> 0x0000000cU))),3);
    bufp->chgIData(oldp+55,((0xfffff000U & vlSelfRef.inst)),32);
    bufp->chgIData(oldp+56,((((- (IData)((vlSelfRef.inst 
                                          >> 0x0000001fU))) 
                              << 0x0000000dU) | (((
                                                   (2U 
                                                    & (vlSelfRef.inst 
                                                       >> 0x0000001eU)) 
                                                   | (1U 
                                                      & (vlSelfRef.inst 
                                                         >> 7U))) 
                                                  << 0x0000000bU) 
                                                 | ((0x000007e0U 
                                                     & (vlSelfRef.inst 
                                                        >> 0x00000014U)) 
                                                    | (0x0000001eU 
                                                       & (vlSelfRef.inst 
                                                          >> 7U)))))),32);
    bufp->chgIData(oldp+57,((((- (IData)((vlSelfRef.inst 
                                          >> 0x0000001fU))) 
                              << 0x0000000cU) | ((0x00000fe0U 
                                                  & (vlSelfRef.inst 
                                                     >> 0x00000014U)) 
                                                 | (0x0000001fU 
                                                    & (vlSelfRef.inst 
                                                       >> 7U))))),32);
    bufp->chgIData(oldp+58,(((((0x00000ffeU & ((- (IData)(
                                                          (vlSelfRef.inst 
                                                           >> 0x0000001fU))) 
                                               << 1U)) 
                               | (vlSelfRef.inst >> 0x0000001fU)) 
                              << 0x00000014U) | (((
                                                   (0x000001feU 
                                                    & (vlSelfRef.inst 
                                                       >> 0x0000000bU)) 
                                                   | (1U 
                                                      & (vlSelfRef.inst 
                                                         >> 0x00000014U))) 
                                                  << 0x0000000bU) 
                                                 | (0x000007feU 
                                                    & (vlSelfRef.inst 
                                                       >> 0x00000014U))))),32);
}

void Vtop___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_cleanup\n"); );
    // Body
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
}
