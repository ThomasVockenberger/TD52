/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: Gen2_ref
 * File: Gen2_ref_private.h
 * Author: 105055527
 * Last modified by: kelleto00
 * Created: Wed Apr 16 13:02:53 2008
 * Last modified: Wed Oct 09 10:01:33 2024
 * Model Version: 4.14.00.04
 * Description: V4.10.00.01, 01-09-2020 Keller, Ke Estimator, additive LS factor, Ptraj SpeedCtrl, LVRT Freeze HLCi
   V4.10.00.01, 02-10-2020 Keller, bugfix HLCi p2srefLX init, BDC_lib: change Inf to 1e7
   V4.10.00.01, 13-11-2020 Keller, bugfix LXcorr T2s/ZZP, LSLff damping, dbgOut for Leanox WG compensation
   V4.10.00.01, 27-01-2021 Keller, Lx WGV compensation: no reset in island mode, addition before skipfire compensation
   V4.10.00.01, 02-02-2021 Keller, initialization lambda estimation with rLam_Start
   V4.11.00.01, 28-05-2021 Keller, Gas Quality Change (GQC) Improvements, LHV estimator output
   V4.11.00.01, 05-11-2021 Keller, Bugfix BDC: worksplit offset, optionally Nset instead of Nnom, rN_Eng_LRskipF
   V4.12.00.01, 10-02-2021 Keller, SpeedCtrl2.0 TU Wien: Disturbance Estimator, LQR incl. droop & leanox
   V4.12.00.02, 23-05-2022 Arnold, Leanox point C in low load
   V4.12.00.02, 09-06-2022 Kafka, add external skip fire input for isolated and grid parallel operation
   V4.12.00.03, 15-09-2022 Keller, add power trajectory to HLCi for extended LQR (Droop setpoint)
   V4.12.00.04, 12-10-2022 Keller, add gas flow comp. factor for rejections
   V4.12.00.05, 13-10-2022 Keller, power filter for static skipfire in island mode
   V4.12.00.06, 15-11-2022 Keller, Ke adaptation with disturbance observer
   V4.13.00.01, 15-11-2022 Keller, FDC: R_mix output, HLCi: R_mix for Ke
   V4.13.00.02, 10-07-2023 Keller, interpolation of LHV, rho_gas and Lmin
   V4.13.00.03, 10-07-2023 Keller, load dependent gas dosage delay
   V4.13.00.04, 11-09-2023 Keller, D-part FSM, bugfix dPTV ramp
   V4.13.00.05, 27-02-2024 Keller, Filter outputs without bSS
   V4.13.00.06, 10-04-2024 Keller, bugfix leanox manual mode with bSepEmisCtrl
   V4.14.00.01, 01-07-2024 Keller, iNskip_LRfor Ke calculation
   V4.14.00.02, 17-09-2024 Keller, Use actual speed for observer disturbance dg (Gen2_ref/HLC_Island (HLC_Island_ref)/iLQR_SF/Ref LQR)
   V4.14.00.03, 30-09-2024 Keller, LR gas flow compensation possible without actuator saturation
   V4.14.00.04, 02-10-2024 Keller, Limit derivative power setpoint for FSM
 * modified Comment:
 ********************************************************************
 * Header for program Gen2_ref
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_Gen2_ref_private_h_
#define RTW_HEADER_Gen2_ref_private_h_
#include "rtwtypes.h"
#include "zero_crossing_types.h"
#include "Gen2_ref.h"
#include <bur/plctypes.h>
#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

#ifndef AST_ROUND
#define AST_ROUND(x)                   ((x)>=0?(long long)((x)+0.5):(long long)((x)-0.5))
#endif

extern real_T rt_roundd_snf(real_T u, struct Gen2* inst);
extern real_T rt_powd_snf(real_T u0, real_T u1, struct Gen2* inst);
void BINARYSEARCH_real_T(uint32_T *piLeft, uint32_T *piRght, real_T u, const
  real_T *pData, uint32_T iHi, struct Gen2* inst);
void LookUp_real_T_real_T(real_T *pY, const real_T *pYData, real_T u, const
  real_T *pUData, uint32_T iHi, struct Gen2* inst);
void LookUp_real_T_real_T_SAT(real_T *pY, const real_T *pYData, real_T u, const
  real_T *pUData, uint32_T iHi, struct Gen2* inst);
void LookUp_real_Treal32_T_K4km1JJi(real_T *pY, const real32_T *pYData, real_T
  u, const real_T *pUData, uint32_T iHi, struct Gen2* inst);
void BINARYSEARCH_real32_Treal_T(uint32_T *piLeft, uint32_T *piRght, real32_T u,
  const real_T *pData, uint32_T iHi, struct Gen2* inst);
void LookUp_real_T_real32_Treal_T(real_T *pY, const real_T *pYData, real32_T u,
  const real_T *pUData, uint32_T iHi, struct Gen2* inst);
extern real_T look1_binlxpw(real_T u0, const real_T bp0[], const real_T table[],
  uint32_T maxIndex, struct Gen2* inst);
extern void Gen2_ref_Filter1_Init(rtDW_Filter1_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_Filter1(real_T rtu_in, real_T rtu_T_filt, plcbit
  rtu_reset, rtB_Filter1_Gen2_ref *localB, rtDW_Filter1_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_TON_1(plcbit rtu_IN, real_T rtu_PT, rtB_TON_1_Gen2_ref
  *localB, rtDW_TON_1_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_Filter3_Init(real_T rtu_x0, rtDW_Filter3_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_Filter3(real_T rtu_in, real_T rtu_T_filt, real_T rtu_x0,
  plcbit rtu_reset, rtB_Filter3_Gen2_ref *localB, rtDW_Filter3_Gen2_ref
  *localDW, struct Gen2* inst);
extern void Gen2_ref_MATLABFunction_Init(rtDW_MATLABFunction_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_MATLABFunction(real_T rtu_u, real_T rtu_u_deact, real_T
  rtu_u_act, rtB_MATLABFunction_Gen2_ref *localB, rtDW_MATLABFunction_Gen2_ref
  *localDW, struct Gen2* inst);
extern void Gen2_ref_enginemassflow(real_T rtu_p_2s, real_T rtu_T_2s, real_T
  rtu_n_e, real_T rtu_eta_V, real_T rtu_V_d, rtB_enginemassflow_Gen2_ref *localB, struct Gen2* inst);
extern void Gen2_ref_IntegerZOH(real_T rtu_u, int16_T rtu_i,
  rtB_IntegerZOH_Gen2_ref *localB, rtDW_IntegerZOH_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_lam2cg1(real_T rtu_lam, real_T rtu_AFRs,
  rtB_lam2cg1_Gen2_ref *localB, struct Gen2* inst);
extern void Gen2_ref_enginemassflow2(real_T rtu_p_2s, real_T rtu_T_2s, real_T
  rtu_n_e, real_T rtu_eta_V, real_T rtu_V_d, rtB_enginemassflow2_Gen2_ref
  *localB, struct Gen2* inst);
extern void Gen2_ref_Inverse_Linearization4(real_T rtu_rPos_TV_u, const
  tGen2Parameter *rtu_rPos_TV_u_f, rtB_Inverse_Linearization4_Gen2 *localB, struct Gen2* inst);
extern void Gen2_ref_N_TC_HP_filt_Init(rtDW_N_TC_HP_filt_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_N_TC_HP_filt(real_T rtu_in, real_T rtu_T_filt, plcbit
  rtu_reset, rtB_N_TC_HP_filt_Gen2_ref *localB, rtDW_N_TC_HP_filt_Gen2_ref
  *localDW, struct Gen2* inst);
extern void Gen2_ref_Mg(real_T rtu_rhoGas, rtB_Mg_Gen2_ref *localB, struct Gen2* inst);
extern void Gen2_ref_lam2cg1_a(real_T rtu_lam, real_T rtu_Lmin,
  rtB_lam2cg1_Gen2_ref_i *localB, struct Gen2* inst);
extern void Gen2_ref_FILTERnodelay(real_T rtu_u, real_T rtu_T, real_T rtu_Ts,
  plcbit rtu_reset, rtB_FILTERnodelay_Gen2_ref *localB,
  rtDW_FILTERnodelay_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_undOrderFilter_Init(rtDW_undOrderFilter_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_undOrderFilter(real_T rtu_in, real_T rtu_omega, real_T
  rtu_d, plcbit rtu_reset, rtB_undOrderFilter_Gen2_ref *localB,
  rtDW_undOrderFilter_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_undOrderFilter3_Init(rtDW_undOrderFilter3_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_undOrderFilter3(real_T rtu_in, real_T rtu_omega, real_T
  rtu_d, plcbit rtu_reset, rtB_undOrderFilter3_Gen2_ref *localB,
  rtDW_undOrderFilter3_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_TOF_Init(rtDW_TOF_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_TOF(plcbit rtu_IN, real_T rtu_PT, rtB_TOF_Gen2_ref
  *localB, rtDW_TOF_Gen2_ref *localDW, struct Gen2* inst);
extern void upointinterpolationwithextrapol(real_T rtu_x, const real_T rtu_xDat
  [2], const real_T rtu_yDat[2], rtB_upointinterpolationwithextr *localB, struct Gen2* inst);
extern void Gen2_ref_MATLABFunction_g(plcbit rtu_reset, real_T rtu_u0,
  plcbit rtu_LvrtFlg, real_T rtu_Y0Lvrt, rtB_MATLABFunction_Gen2_ref_k
  *localB, rtDW_MATLABFunction_Gen2_ref_f *localDW, struct Gen2* inst);
extern void Gen2_ref_MATLABFunction1(real_T rtu_LamIn, plcbit rtu_LvrtFlg,
  rtB_MATLABFunction1_Gen2_ref *localB, rtDW_MATLABFunction1_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_Pd_filt_Init(rtDW_Pd_filt_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_Pd_filt(real_T rtu_in, real_T rtu_T_filt, real_T rtu_x0,
  plcbit rtu_reset, rtB_Pd_filt_Gen2_ref *localB, rtDW_Pd_filt_Gen2_ref
  *localDW, struct Gen2* inst);
extern void Gen2_ref_TP_Init(rtDW_TP_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_TP(plcbit rtu_IN, real_T rtu_PT, rtB_TP_Gen2_ref *localB,
  rtDW_TP_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_TOF_p_Init(rtDW_TOF_Gen2_ref_f *localDW, struct Gen2* inst);
extern void Gen2_ref_TOF_c(plcbit rtu_IN, real32_T rtu_PT, rtB_TOF_Gen2_ref_j
  *localB, rtDW_TOF_Gen2_ref_f *localDW, struct Gen2* inst);
extern void Gen2_ref_TP_ActSat_CBV_Init(rtDW_TP_ActSat_CBV_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_TP_ActSat_CBV(plcbit rtu_IN, real_T rtu_PT,
  rtB_TP_ActSat_CBV_Gen2_ref *localB, rtDW_TP_ActSat_CBV_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_MATLABFunction_n(real_T rtu_u, real_T rtu_eps,
  rtB_MATLABFunction_Gen2_ref_o *localB, rtDW_MATLABFunction_Gen2_ref_k *localDW, struct Gen2* inst);
extern void Gen2_ref_Filter_Init(rtDW_Filter_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_Filter(real_T rtu_in, real_T rtu_x0, plcbit rtu_reset,
  rtB_Filter_Gen2_ref *localB, const rtC_Filter_Gen2_ref *localC,
  rtDW_Filter_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_KeMapUpdate(real_T rtu_in, plcbit rtu_reset, real_T
  rtu_Ke_map, plcbit rtu_resetTrans, plcbit rtu_resetTrans_f, const
  tGen2Parameter *rtu_para, rtB_KeMapUpdate_Gen2_ref *localB,
  rtDW_KeMapUpdate_Gen2_ref *localDW, struct Gen2* inst);
extern void Gen2_ref_MATLABFunction1_m(const real_T rtu_x_ref[13], const real_T
  rtu_y_ref[13], real_T rtu_epsilon, real_T rtu_x_f, real_T rtu_y_act, plcbit
  rtu_reset, plcbit rtu_issteady, rtB_MATLABFunction1_Gen2_ref_h *localB,
  rtDW_MATLABFunction1_Gen2_ref_c *localDW, struct Gen2* inst);

#endif                                 /* RTW_HEADER_Gen2_ref_private_h_ */
