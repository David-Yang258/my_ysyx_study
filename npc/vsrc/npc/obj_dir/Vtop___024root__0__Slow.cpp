// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"

VL_ATTR_COLD void Vtop___024root___eval_static(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_static\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
}

VL_ATTR_COLD void Vtop___024root___eval_initial(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_initial\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtop___024root___eval_final(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_final\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtop___024root___eval_phase__stl(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_settle(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_settle\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("top.v", 1, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 100 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vtop___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD void Vtop___024root___eval_triggers_vec__stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_triggers_vec__stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
}

VL_ATTR_COLD bool Vtop___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vtop___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vtop___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_anySet__stl\n"); );
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

void Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_decode__DOT__ebreak_TOP();
void Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_read_TOP(IData/*31:0*/ raddr, IData/*31:0*/ &pmem_read__Vfuncrtn);
void Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_exec__DOT__pmem_write_TOP(IData/*31:0*/ waddr, IData/*31:0*/ wdata, CData/*7:0*/ wmask, CData/*0:0*/ clk);

VL_ATTR_COLD void Vtop___024root___stl_sequent__TOP__0(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___stl_sequent__TOP__0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((0x00100073U == vlSelfRef.inst)) {
        Vtop___024root____Vdpiimwrap_top__DOT__inst_inst_decode__DOT__ebreak_TOP();
    }
    vlSelfRef.pc = vlSelfRef.top__DOT__inst_pc__DOT__pc_cnt;
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

VL_ATTR_COLD void Vtop___024root____Vm_traceActivitySetAll(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
        Vtop___024root___stl_sequent__TOP__0(vlSelf);
        Vtop___024root____Vm_traceActivitySetAll(vlSelf);
    }
}

VL_ATTR_COLD bool Vtop___024root___eval_phase__stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtop___024root___eval_triggers_vec__stl(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtop___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vtop___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        Vtop___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

bool Vtop___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(Vtop___024root___trigger_anySet__ico(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

bool Vtop___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vtop___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtop___024root____Vm_traceActivitySetAll(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root____Vm_traceActivitySetAll\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
}

VL_ATTR_COLD void Vtop___024root___ctor_var_reset(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ctor_var_reset\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->rst = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18209466448985614591ull);
    vlSelf->inst = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 9812503827101699671ull);
    vlSelf->pc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4211327832146562899ull);
    vlSelf->top__DOT__jmp_set = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12234344222384834316ull);
    vlSelf->top__DOT__setbits = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3878485762332770790ull);
    vlSelf->top__DOT__imm = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 18445623346312568628ull);
    vlSelf->top__DOT__rd = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 3328450216708286131ull);
    vlSelf->top__DOT__rs1 = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 13712195198600804357ull);
    vlSelf->top__DOT__rs2 = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 4635751753440128890ull);
    vlSelf->top__DOT__shamt = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 16562684517569586807ull);
    vlSelf->top__DOT__rd_wdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 6403591884432477510ull);
    vlSelf->top__DOT__reg_wen = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15868204134535992317ull);
    vlSelf->top__DOT__mem_wen = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17082788271205367820ull);
    vlSelf->top__DOT__inst_pc__DOT__pc_cnt = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 10728358829104090588ull);
    vlSelf->top__DOT__inst_inst_decode__DOT__immI = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3363153728316006993ull);
    vlSelf->top__DOT__inst_inst_exec__DOT__mem_raddr = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16314360686625547577ull);
    vlSelf->top__DOT__inst_inst_exec__DOT__mem_waddr = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 5239739341742022761ull);
    vlSelf->top__DOT__inst_gpr__DOT__rdata1 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3156945183403003168ull);
    vlSelf->top__DOT__inst_gpr__DOT__rdata2 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14810016150314039020ull);
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->top__DOT__inst_gpr__DOT__rf[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17451131620846808802ull);
    }
    vlSelf->__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__1__Vfuncout = 0;
    vlSelf->__Vfunc_top__DOT__inst_inst_exec__DOT__pmem_read__3__Vfuncout = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VicoTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 3; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
