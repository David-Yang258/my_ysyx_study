// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"

extern "C" void ebreak();

void Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_decode__DOT__ebreak_TOP() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_decode__DOT__ebreak_TOP\n"); );
    // Body
    ebreak();
}

extern "C" void pmem_write(int waddr, int wdata, char wmask, svBit clk);

void Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(IData/*31:0*/ waddr, IData/*31:0*/ wdata, CData/*7:0*/ wmask, CData/*0:0*/ clk) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP\n"); );
    // Body
    int waddr__Vcvt;
    waddr__Vcvt = waddr;
    int wdata__Vcvt;
    wdata__Vcvt = wdata;
    char wmask__Vcvt;
    wmask__Vcvt = wmask;
    svBit clk__Vcvt;
    clk__Vcvt = clk;
    pmem_write(waddr__Vcvt, wdata__Vcvt, wmask__Vcvt, clk__Vcvt);
}

extern "C" int pmem_read(int raddr);

void Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_read_TOP(IData/*31:0*/ raddr, IData/*31:0*/ &pmem_read__Vfuncrtn) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_read_TOP\n"); );
    // Body
    int raddr__Vcvt;
    raddr__Vcvt = raddr;
    int pmem_read__Vfuncrtn__Vcvt;
    pmem_read__Vfuncrtn__Vcvt = pmem_read(raddr__Vcvt);
    pmem_read__Vfuncrtn = (pmem_read__Vfuncrtn__Vcvt);
}

void Vtop___024root___eval_triggers_vec__ico(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_triggers_vec__ico\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VicoTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VicoTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VicoFirstIteration)));
}

bool Vtop___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_anySet__ico\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vtop___024root___ico_sequent__TOP__0(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ico_sequent__TOP__0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((0x00100073U == vlSelfRef.inst)) {
        Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_decode__DOT__ebreak_TOP();
    }
    vlSelfRef.top__DOT__inst_inst_decode__DOT__immI 
        = (((- (IData)((vlSelfRef.inst >> 0x0000001fU))) 
            << 0x0000000cU) | (vlSelfRef.inst >> 0x00000014U));
    if (((((((((0x0018U == (0x03f8U & ((0x000003f8U 
                                        & (vlSelfRef.inst 
                                           << 3U)) 
                                       | (7U & (vlSelfRef.inst 
                                                >> 0x0000000cU))))) 
               | (0x0098U == (0x03f9U & ((0x000003f8U 
                                          & (vlSelfRef.inst 
                                             << 3U)) 
                                         | (7U & (vlSelfRef.inst 
                                                  >> 0x0000000cU)))))) 
              | (0x009bU == ((0x000003f8U & (vlSelfRef.inst 
                                             << 3U)) 
                             | (7U & (vlSelfRef.inst 
                                      >> 0x0000000cU))))) 
             | (0x0338U == ((0x000003f8U & (vlSelfRef.inst 
                                            << 3U)) 
                            | (7U & (vlSelfRef.inst 
                                     >> 0x0000000cU))))) 
            | (0x0318U == (0x03f8U & ((0x000003f8U 
                                       & (vlSelfRef.inst 
                                          << 3U)) | 
                                      (7U & (vlSelfRef.inst 
                                             >> 0x0000000cU)))))) 
           | (0x00b8U == (0x02f8U & ((0x000003f8U & 
                                      (vlSelfRef.inst 
                                       << 3U)) | (7U 
                                                  & (vlSelfRef.inst 
                                                     >> 0x0000000cU)))))) 
          | (0x0118U == (0x03f8U & ((0x000003f8U & 
                                     (vlSelfRef.inst 
                                      << 3U)) | (7U 
                                                 & (vlSelfRef.inst 
                                                    >> 0x0000000cU)))))) 
         | (0x0099U == (0x03fbU & ((0x000003f8U & (vlSelfRef.inst 
                                                   << 3U)) 
                                   | (7U & (vlSelfRef.inst 
                                            >> 0x0000000cU))))))) {
        if ((0x0018U != (0x03f8U & ((0x000003f8U & 
                                     (vlSelfRef.inst 
                                      << 3U)) | (7U 
                                                 & (vlSelfRef.inst 
                                                    >> 0x0000000cU)))))) {
            if ((0x0098U != (0x03f9U & ((0x000003f8U 
                                         & (vlSelfRef.inst 
                                            << 3U)) 
                                        | (7U & (vlSelfRef.inst 
                                                 >> 0x0000000cU)))))) {
                if ((0x009bU != ((0x000003f8U & (vlSelfRef.inst 
                                                 << 3U)) 
                                 | (7U & (vlSelfRef.inst 
                                          >> 0x0000000cU))))) {
                    if ((0x0338U != ((0x000003f8U & 
                                      (vlSelfRef.inst 
                                       << 3U)) | (7U 
                                                  & (vlSelfRef.inst 
                                                     >> 0x0000000cU))))) {
                        if ((0x0318U != (0x03f8U & 
                                         ((0x000003f8U 
                                           & (vlSelfRef.inst 
                                              << 3U)) 
                                          | (7U & (vlSelfRef.inst 
                                                   >> 0x0000000cU)))))) {
                            if ((0x00b8U != (0x02f8U 
                                             & ((0x000003f8U 
                                                 & (vlSelfRef.inst 
                                                    << 3U)) 
                                                | (7U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x0000000cU)))))) {
                                if ((0x0118U != (0x03f8U 
                                                 & ((0x000003f8U 
                                                     & (vlSelfRef.inst 
                                                        << 3U)) 
                                                    | (7U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x0000000cU)))))) {
                                    vlSelfRef.top__DOT__shamt 
                                        = (0x0000001fU 
                                           & (vlSelfRef.inst 
                                              >> 0x14U));
                                }
                            }
                        }
                        if ((0x0318U == (0x03f8U & 
                                         ((0x000003f8U 
                                           & (vlSelfRef.inst 
                                              << 3U)) 
                                          | (7U & (vlSelfRef.inst 
                                                   >> 0x0000000cU)))))) {
                            vlSelfRef.top__DOT__rs2 
                                = (0x0000001fU & (vlSelfRef.inst 
                                                  >> 0x14U));
                        } else if ((0x00b8U != (0x02f8U 
                                                & ((0x000003f8U 
                                                    & (vlSelfRef.inst 
                                                       << 3U)) 
                                                   | (7U 
                                                      & (vlSelfRef.inst 
                                                         >> 0x0000000cU)))))) {
                            if ((0x0118U == (0x03f8U 
                                             & ((0x000003f8U 
                                                 & (vlSelfRef.inst 
                                                    << 3U)) 
                                                | (7U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x0000000cU)))))) {
                                vlSelfRef.top__DOT__rs2 
                                    = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x14U));
                            }
                        }
                    }
                }
            }
        }
        if ((0x0018U == (0x03f8U & ((0x000003f8U & 
                                     (vlSelfRef.inst 
                                      << 3U)) | (7U 
                                                 & (vlSelfRef.inst 
                                                    >> 0x0000000cU)))))) {
            vlSelfRef.top__DOT__rd = (0x0000001fU & 
                                      (vlSelfRef.inst 
                                       >> 7U));
            vlSelfRef.top__DOT__rs1 = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x0fU));
            vlSelfRef.top__DOT__imm = vlSelfRef.top__DOT__inst_inst_decode__DOT__immI;
        } else if ((0x0098U == (0x03f9U & ((0x000003f8U 
                                            & (vlSelfRef.inst 
                                               << 3U)) 
                                           | (7U & 
                                              (vlSelfRef.inst 
                                               >> 0x0000000cU)))))) {
            vlSelfRef.top__DOT__rd = (0x0000001fU & 
                                      (vlSelfRef.inst 
                                       >> 7U));
            vlSelfRef.top__DOT__rs1 = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x0fU));
            vlSelfRef.top__DOT__imm = vlSelfRef.top__DOT__inst_inst_decode__DOT__immI;
        } else if ((0x009bU == ((0x000003f8U & (vlSelfRef.inst 
                                                << 3U)) 
                                | (7U & (vlSelfRef.inst 
                                         >> 0x0000000cU))))) {
            vlSelfRef.top__DOT__rd = (0x0000001fU & 
                                      (vlSelfRef.inst 
                                       >> 7U));
            vlSelfRef.top__DOT__rs1 = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x0fU));
            vlSelfRef.top__DOT__imm = vlSelfRef.top__DOT__inst_inst_decode__DOT__immI;
        } else if ((0x0338U == ((0x000003f8U & (vlSelfRef.inst 
                                                << 3U)) 
                                | (7U & (vlSelfRef.inst 
                                         >> 0x0000000cU))))) {
            vlSelfRef.top__DOT__rd = (0x0000001fU & 
                                      (vlSelfRef.inst 
                                       >> 7U));
            vlSelfRef.top__DOT__rs1 = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x0fU));
            vlSelfRef.top__DOT__imm = vlSelfRef.top__DOT__inst_inst_decode__DOT__immI;
        } else {
            if ((0x0318U != (0x03f8U & ((0x000003f8U 
                                         & (vlSelfRef.inst 
                                            << 3U)) 
                                        | (7U & (vlSelfRef.inst 
                                                 >> 0x0000000cU)))))) {
                if ((0x00b8U == (0x02f8U & ((0x000003f8U 
                                             & (vlSelfRef.inst 
                                                << 3U)) 
                                            | (7U & 
                                               (vlSelfRef.inst 
                                                >> 0x0000000cU)))))) {
                    vlSelfRef.top__DOT__rd = (0x0000001fU 
                                              & (vlSelfRef.inst 
                                                 >> 7U));
                } else if ((0x0118U != (0x03f8U & (
                                                   (0x000003f8U 
                                                    & (vlSelfRef.inst 
                                                       << 3U)) 
                                                   | (7U 
                                                      & (vlSelfRef.inst 
                                                         >> 0x0000000cU)))))) {
                    vlSelfRef.top__DOT__rd = (0x0000001fU 
                                              & (vlSelfRef.inst 
                                                 >> 7U));
                }
            }
            if ((0x0318U == (0x03f8U & ((0x000003f8U 
                                         & (vlSelfRef.inst 
                                            << 3U)) 
                                        | (7U & (vlSelfRef.inst 
                                                 >> 0x0000000cU)))))) {
                vlSelfRef.top__DOT__rs1 = (0x0000001fU 
                                           & (vlSelfRef.inst 
                                              >> 0x0fU));
                vlSelfRef.top__DOT__imm = (((- (IData)(
                                                       (vlSelfRef.inst 
                                                        >> 0x0000001fU))) 
                                            << 0x0000000dU) 
                                           | ((((2U 
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
                                                       >> 7U)))));
            } else {
                if ((0x00b8U != (0x02f8U & ((0x000003f8U 
                                             & (vlSelfRef.inst 
                                                << 3U)) 
                                            | (7U & 
                                               (vlSelfRef.inst 
                                                >> 0x0000000cU)))))) {
                    vlSelfRef.top__DOT__rs1 = (0x0000001fU 
                                               & ((0x0118U 
                                                   == 
                                                   (0x03f8U 
                                                    & ((0x000003f8U 
                                                        & (vlSelfRef.inst 
                                                           << 3U)) 
                                                       | (7U 
                                                          & (vlSelfRef.inst 
                                                             >> 0x0000000cU)))))
                                                   ? 
                                                  (vlSelfRef.inst 
                                                   >> 0x0fU)
                                                   : 
                                                  (vlSelfRef.inst 
                                                   >> 0x0fU)));
                }
                if ((0x00b8U == (0x02f8U & ((0x000003f8U 
                                             & (vlSelfRef.inst 
                                                << 3U)) 
                                            | (7U & 
                                               (vlSelfRef.inst 
                                                >> 0x0000000cU)))))) {
                    vlSelfRef.top__DOT__imm = (0xfffff000U 
                                               & vlSelfRef.inst);
                } else if ((0x0118U == (0x03f8U & (
                                                   (0x000003f8U 
                                                    & (vlSelfRef.inst 
                                                       << 3U)) 
                                                   | (7U 
                                                      & (vlSelfRef.inst 
                                                         >> 0x0000000cU)))))) {
                    vlSelfRef.top__DOT__imm = (((- (IData)(
                                                           (vlSelfRef.inst 
                                                            >> 0x0000001fU))) 
                                                << 0x0000000cU) 
                                               | ((0x00000fe0U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x00000014U)) 
                                                  | (0x0000001fU 
                                                     & (vlSelfRef.inst 
                                                        >> 7U))));
                }
            }
        }
    } else {
        if ((0x0198U == (0x03f8U & ((0x000003f8U & 
                                     (vlSelfRef.inst 
                                      << 3U)) | (7U 
                                                 & (vlSelfRef.inst 
                                                    >> 0x0000000cU)))))) {
            vlSelfRef.top__DOT__rd = (0x0000001fU & 
                                      (vlSelfRef.inst 
                                       >> 7U));
            vlSelfRef.top__DOT__rs2 = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x14U));
            vlSelfRef.top__DOT__rs1 = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x0fU));
        } else if ((0x0378U == (0x03f8U & ((0x000003f8U 
                                            & (vlSelfRef.inst 
                                               << 3U)) 
                                           | (7U & 
                                              (vlSelfRef.inst 
                                               >> 0x0000000cU)))))) {
            vlSelfRef.top__DOT__rs2 = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x14U));
            vlSelfRef.top__DOT__rs1 = (0x0000001fU 
                                       & (vlSelfRef.inst 
                                          >> 0x0fU));
        }
        if ((0x0198U != (0x03f8U & ((0x000003f8U & 
                                     (vlSelfRef.inst 
                                      << 3U)) | (7U 
                                                 & (vlSelfRef.inst 
                                                    >> 0x0000000cU)))))) {
            if ((0x0378U == (0x03f8U & ((0x000003f8U 
                                         & (vlSelfRef.inst 
                                            << 3U)) 
                                        | (7U & (vlSelfRef.inst 
                                                 >> 0x0000000cU)))))) {
                vlSelfRef.top__DOT__imm = ((((0x00000ffeU 
                                              & ((- (IData)(
                                                            (vlSelfRef.inst 
                                                             >> 0x0000001fU))) 
                                                 << 1U)) 
                                             | (vlSelfRef.inst 
                                                >> 0x0000001fU)) 
                                            << 0x00000014U) 
                                           | ((((0x000001feU 
                                                 & (vlSelfRef.inst 
                                                    >> 0x0000000bU)) 
                                                | (1U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x00000014U))) 
                                               << 0x0000000bU) 
                                              | (0x000007feU 
                                                 & (vlSelfRef.inst 
                                                    >> 0x00000014U))));
            }
        }
    }
    vlSelfRef.top__DOT__inst_gpr__DOT__rdata2 = ((0U 
                                                  == (IData)(vlSelfRef.top__DOT__rs2))
                                                  ? 0U
                                                  : vlSelfRef.top__DOT__inst_gpr__DOT__rf
                                                 [vlSelfRef.top__DOT__rs2]);
    vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 = ((0U 
                                                  == (IData)(vlSelfRef.top__DOT__rs1))
                                                  ? 0U
                                                  : vlSelfRef.top__DOT__inst_gpr__DOT__rf
                                                 [vlSelfRef.top__DOT__rs1]);
    vlSelfRef.top__DOT__mem_wen = 0U;
    vlSelfRef.top__DOT__reg_wen = 0U;
    vlSelfRef.top__DOT__jmp_set = 0U;
    vlSelfRef.top__DOT__rd_wdata = 0U;
    vlSelfRef.top__DOT__setbits = 0U;
    if (((((((((0x00000013U == (0x0001c07fU & ((0x0001c000U 
                                                & (vlSelfRef.inst 
                                                   << 2U)) 
                                               | ((0x00003f80U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x00000012U)) 
                                                  | (0x0000007fU 
                                                     & vlSelfRef.inst))))) 
               | (0x00000067U == (0x0001c07fU & ((0x0001c000U 
                                                  & (vlSelfRef.inst 
                                                     << 2U)) 
                                                 | ((0x00003f80U 
                                                     & (vlSelfRef.inst 
                                                        >> 0x00000012U)) 
                                                    | (0x0000007fU 
                                                       & vlSelfRef.inst)))))) 
              | (0x00000033U == ((0x0001c000U & (vlSelfRef.inst 
                                                 << 2U)) 
                                 | ((0x00003f80U & 
                                     (vlSelfRef.inst 
                                      >> 0x00000012U)) 
                                    | (0x0000007fU 
                                       & vlSelfRef.inst))))) 
             | (0x00000037U == (0x0000007fU & ((0x0001c000U 
                                                & (vlSelfRef.inst 
                                                   << 2U)) 
                                               | ((0x00003f80U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x00000012U)) 
                                                  | (0x0000007fU 
                                                     & vlSelfRef.inst)))))) 
            | (0x00008003U == (0x0001c07fU & ((0x0001c000U 
                                               & (vlSelfRef.inst 
                                                  << 2U)) 
                                              | ((0x00003f80U 
                                                  & (vlSelfRef.inst 
                                                     >> 0x00000012U)) 
                                                 | (0x0000007fU 
                                                    & vlSelfRef.inst)))))) 
           | (0x00008023U == (0x0001c07fU & ((0x0001c000U 
                                              & (vlSelfRef.inst 
                                                 << 2U)) 
                                             | ((0x00003f80U 
                                                 & (vlSelfRef.inst 
                                                    >> 0x00000012U)) 
                                                | (0x0000007fU 
                                                   & vlSelfRef.inst)))))) 
          | (0x00010003U == (0x0001c07fU & ((0x0001c000U 
                                             & (vlSelfRef.inst 
                                                << 2U)) 
                                            | ((0x00003f80U 
                                                & (vlSelfRef.inst 
                                                   >> 0x00000012U)) 
                                               | (0x0000007fU 
                                                  & vlSelfRef.inst)))))) 
         | (0x00000023U == (0x0001c07fU & ((0x0001c000U 
                                            & (vlSelfRef.inst 
                                               << 2U)) 
                                           | ((0x00003f80U 
                                               & (vlSelfRef.inst 
                                                  >> 0x00000012U)) 
                                              | (0x0000007fU 
                                                 & vlSelfRef.inst))))))) {
        if ((0x00000013U == (0x0001c07fU & ((0x0001c000U 
                                             & (vlSelfRef.inst 
                                                << 2U)) 
                                            | ((0x00003f80U 
                                                & (vlSelfRef.inst 
                                                   >> 0x00000012U)) 
                                               | (0x0000007fU 
                                                  & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__rd_wdata = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                                            + vlSelfRef.top__DOT__imm);
            vlSelfRef.top__DOT__reg_wen = 1U;
        } else if ((0x00000067U == (0x0001c07fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__rd_wdata = ((IData)(4U) 
                                            + vlSelfRef.pc);
            vlSelfRef.top__DOT__jmp_set = 1U;
            vlSelfRef.top__DOT__setbits = (vlSelfRef.top__DOT__imm 
                                           + vlSelfRef.top__DOT__inst_gpr__DOT__rdata1);
            vlSelfRef.top__DOT__reg_wen = 1U;
        } else if ((0x00000033U == ((0x0001c000U & 
                                     (vlSelfRef.inst 
                                      << 2U)) | ((0x00003f80U 
                                                  & (vlSelfRef.inst 
                                                     >> 0x00000012U)) 
                                                 | (0x0000007fU 
                                                    & vlSelfRef.inst))))) {
            vlSelfRef.top__DOT__rd_wdata = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                                            + vlSelfRef.top__DOT__inst_gpr__DOT__rdata2);
            vlSelfRef.top__DOT__reg_wen = 1U;
        } else if ((0x00000037U == (0x0000007fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__rd_wdata = vlSelfRef.top__DOT__imm;
            vlSelfRef.top__DOT__reg_wen = 1U;
        } else if ((0x00008003U == (0x0001c07fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr 
                = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                   + vlSelfRef.top__DOT__imm);
            Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_read_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr, vlSelfRef.__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__1__Vfuncout);
            vlSelfRef.top__DOT__reg_wen = 1U;
            vlSelfRef.top__DOT__rd_wdata = vlSelfRef.__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__1__Vfuncout;
        } else if ((0x00008023U == (0x0001c07fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(
                                                                                (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                                                                                + vlSelfRef.top__DOT__imm), vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 0x0fU, (IData)(vlSelfRef.clk));
            vlSelfRef.top__DOT__mem_wen = 1U;
        } else if ((0x00010003U == (0x0001c07fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr 
                = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                   + vlSelfRef.top__DOT__imm);
            Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_read_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr, vlSelfRef.__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__3__Vfuncout);
            vlSelfRef.top__DOT__reg_wen = 1U;
            vlSelfRef.top__DOT__rd_wdata = vlSelfRef.__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__3__Vfuncout;
            vlSelfRef.top__DOT__rd_wdata = ((2U & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr)
                                             ? ((1U 
                                                 & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr)
                                                 ? 
                                                (0x000000ffU 
                                                 & VL_SHIFTR_III(32,32,32, vlSelfRef.top__DOT__rd_wdata, 0x00000018U))
                                                 : 
                                                (0x000000ffU 
                                                 & VL_SHIFTR_III(32,32,32, vlSelfRef.top__DOT__rd_wdata, 0x00000010U)))
                                             : ((1U 
                                                 & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr)
                                                 ? 
                                                (0x000000ffU 
                                                 & VL_SHIFTR_III(32,32,32, vlSelfRef.top__DOT__rd_wdata, 8U))
                                                 : 
                                                (0x000000ffU 
                                                 & vlSelfRef.top__DOT__rd_wdata)));
        } else {
            vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr 
                = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                   + vlSelfRef.top__DOT__imm);
            if ((2U & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr)) {
                if ((1U & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr)) {
                    Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr, 
                                                                                VL_SHIFTL_III(32,32,32, vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 0x00000018U), 8U, (IData)(vlSelfRef.clk));
                } else {
                    Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr, 
                                                                                VL_SHIFTL_III(32,32,32, vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 0x00000010U), 4U, (IData)(vlSelfRef.clk));
                }
            } else if ((1U & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr)) {
                Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr, 
                                                                                VL_SHIFTL_III(32,32,32, vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 8U), 2U, (IData)(vlSelfRef.clk));
            } else {
                Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr, vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 1U, (IData)(vlSelfRef.clk));
            }
            vlSelfRef.top__DOT__mem_wen = 1U;
        }
    }
}

void Vtop___024root___eval_ico(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_ico\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VicoTriggered[0U])) {
        Vtop___024root___ico_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vtop___024root___eval_phase__ico(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__ico\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VicoExecute;
    // Body
    Vtop___024root___eval_triggers_vec__ico(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtop___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
    }
#endif
    __VicoExecute = Vtop___024root___trigger_anySet__ico(vlSelfRef.__VicoTriggered);
    if (__VicoExecute) {
        Vtop___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vtop___024root___eval_triggers_vec__act(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_triggers_vec__act\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    ((IData)(vlSelfRef.clk) 
                                                     & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0)))));
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
}

bool Vtop___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VdlyVal__top__DOT__inst_gpr__DOT__rf__v0;
    __VdlyVal__top__DOT__inst_gpr__DOT__rf__v0 = 0;
    CData/*4:0*/ __VdlyDim0__top__DOT__inst_gpr__DOT__rf__v0;
    __VdlyDim0__top__DOT__inst_gpr__DOT__rf__v0 = 0;
    CData/*0:0*/ __VdlySet__top__DOT__inst_gpr__DOT__rf__v0;
    __VdlySet__top__DOT__inst_gpr__DOT__rf__v0 = 0;
    // Body
    __VdlySet__top__DOT__inst_gpr__DOT__rf__v0 = 0U;
    vlSelfRef.top__DOT__inst_pc__DOT__pc_cnt = ((IData)(vlSelfRef.rst)
                                                 ? 0x80000000U
                                                 : 
                                                ((IData)(vlSelfRef.top__DOT__jmp_set)
                                                  ? vlSelfRef.top__DOT__setbits
                                                  : 
                                                 ((IData)(4U) 
                                                  + vlSelfRef.top__DOT__inst_pc__DOT__pc_cnt)));
    if (vlSelfRef.top__DOT__reg_wen) {
        __VdlyVal__top__DOT__inst_gpr__DOT__rf__v0 
            = vlSelfRef.top__DOT__rd_wdata;
        __VdlyDim0__top__DOT__inst_gpr__DOT__rf__v0 
            = vlSelfRef.top__DOT__rd;
        __VdlySet__top__DOT__inst_gpr__DOT__rf__v0 = 1U;
    }
    if (__VdlySet__top__DOT__inst_gpr__DOT__rf__v0) {
        vlSelfRef.top__DOT__inst_gpr__DOT__rf[__VdlyDim0__top__DOT__inst_gpr__DOT__rf__v0] 
            = __VdlyVal__top__DOT__inst_gpr__DOT__rf__v0;
    }
    vlSelfRef.pc = vlSelfRef.top__DOT__inst_pc__DOT__pc_cnt;
    vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 = ((0U 
                                                  == (IData)(vlSelfRef.top__DOT__rs1))
                                                  ? 0U
                                                  : vlSelfRef.top__DOT__inst_gpr__DOT__rf
                                                 [vlSelfRef.top__DOT__rs1]);
    vlSelfRef.top__DOT__inst_gpr__DOT__rdata2 = ((0U 
                                                  == (IData)(vlSelfRef.top__DOT__rs2))
                                                  ? 0U
                                                  : vlSelfRef.top__DOT__inst_gpr__DOT__rf
                                                 [vlSelfRef.top__DOT__rs2]);
    vlSelfRef.top__DOT__mem_wen = 0U;
    vlSelfRef.top__DOT__reg_wen = 0U;
    vlSelfRef.top__DOT__jmp_set = 0U;
    vlSelfRef.top__DOT__rd_wdata = 0U;
    vlSelfRef.top__DOT__setbits = 0U;
    if (((((((((0x00000013U == (0x0001c07fU & ((0x0001c000U 
                                                & (vlSelfRef.inst 
                                                   << 2U)) 
                                               | ((0x00003f80U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x00000012U)) 
                                                  | (0x0000007fU 
                                                     & vlSelfRef.inst))))) 
               | (0x00000067U == (0x0001c07fU & ((0x0001c000U 
                                                  & (vlSelfRef.inst 
                                                     << 2U)) 
                                                 | ((0x00003f80U 
                                                     & (vlSelfRef.inst 
                                                        >> 0x00000012U)) 
                                                    | (0x0000007fU 
                                                       & vlSelfRef.inst)))))) 
              | (0x00000033U == ((0x0001c000U & (vlSelfRef.inst 
                                                 << 2U)) 
                                 | ((0x00003f80U & 
                                     (vlSelfRef.inst 
                                      >> 0x00000012U)) 
                                    | (0x0000007fU 
                                       & vlSelfRef.inst))))) 
             | (0x00000037U == (0x0000007fU & ((0x0001c000U 
                                                & (vlSelfRef.inst 
                                                   << 2U)) 
                                               | ((0x00003f80U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x00000012U)) 
                                                  | (0x0000007fU 
                                                     & vlSelfRef.inst)))))) 
            | (0x00008003U == (0x0001c07fU & ((0x0001c000U 
                                               & (vlSelfRef.inst 
                                                  << 2U)) 
                                              | ((0x00003f80U 
                                                  & (vlSelfRef.inst 
                                                     >> 0x00000012U)) 
                                                 | (0x0000007fU 
                                                    & vlSelfRef.inst)))))) 
           | (0x00008023U == (0x0001c07fU & ((0x0001c000U 
                                              & (vlSelfRef.inst 
                                                 << 2U)) 
                                             | ((0x00003f80U 
                                                 & (vlSelfRef.inst 
                                                    >> 0x00000012U)) 
                                                | (0x0000007fU 
                                                   & vlSelfRef.inst)))))) 
          | (0x00010003U == (0x0001c07fU & ((0x0001c000U 
                                             & (vlSelfRef.inst 
                                                << 2U)) 
                                            | ((0x00003f80U 
                                                & (vlSelfRef.inst 
                                                   >> 0x00000012U)) 
                                               | (0x0000007fU 
                                                  & vlSelfRef.inst)))))) 
         | (0x00000023U == (0x0001c07fU & ((0x0001c000U 
                                            & (vlSelfRef.inst 
                                               << 2U)) 
                                           | ((0x00003f80U 
                                               & (vlSelfRef.inst 
                                                  >> 0x00000012U)) 
                                              | (0x0000007fU 
                                                 & vlSelfRef.inst))))))) {
        if ((0x00000013U == (0x0001c07fU & ((0x0001c000U 
                                             & (vlSelfRef.inst 
                                                << 2U)) 
                                            | ((0x00003f80U 
                                                & (vlSelfRef.inst 
                                                   >> 0x00000012U)) 
                                               | (0x0000007fU 
                                                  & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__rd_wdata = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                                            + vlSelfRef.top__DOT__imm);
            vlSelfRef.top__DOT__reg_wen = 1U;
        } else if ((0x00000067U == (0x0001c07fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__rd_wdata = ((IData)(4U) 
                                            + vlSelfRef.pc);
            vlSelfRef.top__DOT__jmp_set = 1U;
            vlSelfRef.top__DOT__setbits = (vlSelfRef.top__DOT__imm 
                                           + vlSelfRef.top__DOT__inst_gpr__DOT__rdata1);
            vlSelfRef.top__DOT__reg_wen = 1U;
        } else if ((0x00000033U == ((0x0001c000U & 
                                     (vlSelfRef.inst 
                                      << 2U)) | ((0x00003f80U 
                                                  & (vlSelfRef.inst 
                                                     >> 0x00000012U)) 
                                                 | (0x0000007fU 
                                                    & vlSelfRef.inst))))) {
            vlSelfRef.top__DOT__rd_wdata = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                                            + vlSelfRef.top__DOT__inst_gpr__DOT__rdata2);
            vlSelfRef.top__DOT__reg_wen = 1U;
        } else if ((0x00000037U == (0x0000007fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__rd_wdata = vlSelfRef.top__DOT__imm;
            vlSelfRef.top__DOT__reg_wen = 1U;
        } else if ((0x00008003U == (0x0001c07fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr 
                = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                   + vlSelfRef.top__DOT__imm);
            Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_read_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr, vlSelfRef.__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__1__Vfuncout);
            vlSelfRef.top__DOT__reg_wen = 1U;
            vlSelfRef.top__DOT__rd_wdata = vlSelfRef.__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__1__Vfuncout;
        } else if ((0x00008023U == (0x0001c07fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(
                                                                                (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                                                                                + vlSelfRef.top__DOT__imm), vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 0x0fU, (IData)(vlSelfRef.clk));
            vlSelfRef.top__DOT__mem_wen = 1U;
        } else if ((0x00010003U == (0x0001c07fU & (
                                                   (0x0001c000U 
                                                    & (vlSelfRef.inst 
                                                       << 2U)) 
                                                   | ((0x00003f80U 
                                                       & (vlSelfRef.inst 
                                                          >> 0x00000012U)) 
                                                      | (0x0000007fU 
                                                         & vlSelfRef.inst)))))) {
            vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr 
                = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                   + vlSelfRef.top__DOT__imm);
            Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_read_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr, vlSelfRef.__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__3__Vfuncout);
            vlSelfRef.top__DOT__reg_wen = 1U;
            vlSelfRef.top__DOT__rd_wdata = vlSelfRef.__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__3__Vfuncout;
            vlSelfRef.top__DOT__rd_wdata = ((2U & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr)
                                             ? ((1U 
                                                 & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr)
                                                 ? 
                                                (0x000000ffU 
                                                 & VL_SHIFTR_III(32,32,32, vlSelfRef.top__DOT__rd_wdata, 0x00000018U))
                                                 : 
                                                (0x000000ffU 
                                                 & VL_SHIFTR_III(32,32,32, vlSelfRef.top__DOT__rd_wdata, 0x00000010U)))
                                             : ((1U 
                                                 & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_raddr)
                                                 ? 
                                                (0x000000ffU 
                                                 & VL_SHIFTR_III(32,32,32, vlSelfRef.top__DOT__rd_wdata, 8U))
                                                 : 
                                                (0x000000ffU 
                                                 & vlSelfRef.top__DOT__rd_wdata)));
        } else {
            vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr 
                = (vlSelfRef.top__DOT__inst_gpr__DOT__rdata1 
                   + vlSelfRef.top__DOT__imm);
            if ((2U & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr)) {
                if ((1U & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr)) {
                    Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr, 
                                                                                VL_SHIFTL_III(32,32,32, vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 0x00000018U), 8U, (IData)(vlSelfRef.clk));
                } else {
                    Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr, 
                                                                                VL_SHIFTL_III(32,32,32, vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 0x00000010U), 4U, (IData)(vlSelfRef.clk));
                }
            } else if ((1U & vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr)) {
                Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr, 
                                                                                VL_SHIFTL_III(32,32,32, vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 8U), 2U, (IData)(vlSelfRef.clk));
            } else {
                Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(vlSelfRef.top__DOT__inst_inst_exec__DOT__mem_waddr, vlSelfRef.top__DOT__inst_gpr__DOT__rdata2, 1U, (IData)(vlSelfRef.clk));
            }
            vlSelfRef.top__DOT__mem_wen = 1U;
        }
    }
}

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
    }
}

void Vtop___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vtop___024root___eval_phase__act(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__act\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtop___024root___eval_triggers_vec__act(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtop___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vtop___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    return (0U);
}

void Vtop___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vtop___024root___eval_phase__nba(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__nba\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vtop___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vtop___024root___eval_nba(vlSelf);
        Vtop___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VicoIterCount = 0U;
    vlSelfRef.__VicoFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VicoIterCount)))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
#endif
            VL_FATAL_MT("top.v", 1, "", "DIDNOTCONVERGE: Input combinational region did not converge after '--converge-limit' of 100 tries");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        vlSelfRef.__VicoPhaseResult = Vtop___024root___eval_phase__ico(vlSelf);
        vlSelfRef.__VicoFirstIteration = 0U;
    } while (vlSelfRef.__VicoPhaseResult);
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("top.v", 1, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 100 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00000064U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                VL_FATAL_MT("top.v", 1, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 100 tries");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactPhaseResult = Vtop___024root___eval_phase__act(vlSelf);
        } while (vlSelfRef.__VactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vtop___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");
    }
    if (VL_UNLIKELY(((vlSelfRef.rst & 0xfeU)))) {
        Verilated::overWidthError("rst");
    }
}
#endif  // VL_DEBUG
