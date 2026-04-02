/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_SS
 * File: AC_SS.c
 * Author: 105055527
 * Created: Thu May 19 13:50:06 2016
 ********************************************************************
 * Implementation of program AC_SS
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V5.0
 * (ERT based)
 ********************************************************************/
#include "AC_SS.h"
#include "AC_SS_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/*
 * Initial conditions for atomic system:
 *    '<S13>/Filter'
 *    '<S19>/Filter'
 *    '<S25>/Filter'
 *    '<S31>/Filter'
 *    '<S37>/Filter'
 *    '<S43>/Filter'
 *    '<S49>/Filter'
 *    '<S55>/Filter'
 */
void AC_SS_Filter_Init(real32_T rtu_x0, rtDW_Filter_AC_SS *localDW, struct SS* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S14>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
}

/*
 * Output and update for atomic system:
 *    '<S13>/Filter'
 *    '<S19>/Filter'
 *    '<S25>/Filter'
 *    '<S31>/Filter'
 *    '<S37>/Filter'
 *    '<S43>/Filter'
 *    '<S49>/Filter'
 *    '<S55>/Filter'
 */
void AC_SS_Filter(real32_T rtu_in, real32_T rtu_T_filt, boolean_T rtu_reset,
                  real32_T rtu_x0, rtB_Filter_AC_SS *localB, rtDW_Filter_AC_SS
                  *localDW, struct SS* inst)
{
  /* local block i/o variables */
  real32_T rtb_Divide4;
  real32_T tmp;

  /* Switch: '<S15>/Switch' incorporates:
   *  Abs: '<S15>/Abs'
   *  RelationalOperator: '<S15>/Relational Operator'
   */
  if (2.22044605E-16F >= (real32_T)fabs(rtu_T_filt)) {
    tmp = 2.22044605E-16F;
  } else {
    tmp = rtu_T_filt;
  }

  /* End of Switch: '<S15>/Switch' */

  /* Product: '<S14>/Divide4' incorporates:
   *  Sum: '<S14>/Sum4'
   */
  rtb_Divide4 = (rtu_in - localDW->DiscreteTimeIntegrator_DSTATE) / tmp;

  /* DiscreteIntegrator: '<S14>/Discrete-Time Integrator' */
  if (rtu_reset || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  localB->DiscreteTimeIntegrator = 0.005F * rtb_Divide4 +
    localDW->DiscreteTimeIntegrator_DSTATE;

  /* End of DiscreteIntegrator: '<S14>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S14>/Discrete-Time Integrator' */
  if (!rtu_reset) {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.005F * rtb_Divide4 +
      localB->DiscreteTimeIntegrator;
  }

  if (rtu_reset) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S14>/Discrete-Time Integrator' */
}

/* Model step function */
void AC_SS_step(struct BlockIO_AC_SS *AC_SS_B, struct D_Work_AC_SS *AC_SS_DWork,
                ExternalOutputs_AC_SS *AC_SS_Y, struct SS* inst)
{
  /* local block i/o variables */
  real32_T rtb_rAct;
  real32_T rtb_rTi_Filt;
  real32_T rtb_rAct_h;
  real32_T rtb_rTi_Filt_h;
  real32_T rtb_rAct_hj;
  real32_T rtb_rTi_Filt_l;
  real32_T rtb_rAct_g;
  real32_T rtb_rTi_Filt_j;
  real32_T rtb_rAct_n;
  real32_T rtb_rTi_Filt_e;
  real32_T rtb_rAct_b;
  real32_T rtb_rTi_Filt_i;
  real32_T rtb_rAct_d;
  real32_T rtb_rTi_Filt_k;
  real32_T rtb_rAct_i;
  real32_T rtb_rTi_Filt_m;
  boolean_T rtb_bReset;
  real32_T rtb_Abs;
  boolean_T rtb_RelationalOperator5;
  boolean_T rtb_RelationalOperator1;
  boolean_T rtb_RelationalOperator5_n;
  boolean_T rtb_RelationalOperator1_m;
  boolean_T rtb_RelationalOperator5_p;
  boolean_T rtb_RelationalOperator1_a;
  boolean_T rtb_RelationalOperator5_b;
  boolean_T rtb_RelationalOperator1_d;
  boolean_T rtb_RelationalOperator5_j;
  boolean_T rtb_RelationalOperator1_am;
  boolean_T rtb_RelationalOperator5_j2;
  boolean_T rtb_RelationalOperator1_p;
  boolean_T rtb_RelationalOperator5_e;
  boolean_T rtb_RelationalOperator1_n;
  boolean_T rtb_RelationalOperator5_m;
  boolean_T tmp[8];
  uint8_T tmp_0;
  int32_T i;
  boolean_T tmp_1[8];

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  AC_SS_B->BusInput = inst->in;

  /* BusSelector: '<S2>/Bus Selector2' */
  rtb_bReset = AC_SS_B->BusInput.bReset;

  /* BusSelector: '<S7>/Bus Selector' */
  rtb_rAct = AC_SS_B->BusInput.P2s.rAct;
  rtb_rTi_Filt = AC_SS_B->BusInput.P2s.rTi_Filt;

  /* Sum: '<S36>/Add3' */
  rtb_Abs = AC_SS_B->BusInput.P2s.rSet - rtb_rAct;

  /* Abs: '<S36>/Abs3' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S36>/Relational Operator5' */
  rtb_RelationalOperator5 = (rtb_Abs <= AC_SS_B->BusInput.P2s.rAbsLim);

  /* Outputs for Atomic SubSystem: '<S37>/Filter' */
  AC_SS_Filter(rtb_rAct, rtb_rTi_Filt, rtb_bReset, AC_SS_ConstB.Constant,
               &AC_SS_B->Filter, &AC_SS_DWork->Filter, inst);

  /* End of Outputs for SubSystem: '<S37>/Filter' */

  /* Sum: '<S37>/Add' */
  rtb_Abs = rtb_rAct - AC_SS_B->Filter.DiscreteTimeIntegrator;

  /* Abs: '<S37>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S37>/Relational Operator1' */
  rtb_RelationalOperator1 = (rtb_Abs <= AC_SS_B->BusInput.P2s.rRelLim);

  /* BusSelector: '<S9>/Bus Selector' */
  rtb_rAct_h = AC_SS_B->BusInput.T2s.rAct;
  rtb_rTi_Filt_h = AC_SS_B->BusInput.T2s.rTi_Filt;

  /* Sum: '<S48>/Add3' */
  rtb_Abs = AC_SS_B->BusInput.T2s.rSet - rtb_rAct_h;

  /* Abs: '<S48>/Abs3' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S48>/Relational Operator5' */
  rtb_RelationalOperator5_n = (rtb_Abs <= AC_SS_B->BusInput.T2s.rAbsLim);

  /* Outputs for Atomic SubSystem: '<S49>/Filter' */
  AC_SS_Filter(rtb_rAct_h, rtb_rTi_Filt_h, rtb_bReset, AC_SS_ConstB.Constant_d,
               &AC_SS_B->Filter_n, &AC_SS_DWork->Filter_n, inst);

  /* End of Outputs for SubSystem: '<S49>/Filter' */

  /* Sum: '<S49>/Add' */
  rtb_Abs = rtb_rAct_h - AC_SS_B->Filter_n.DiscreteTimeIntegrator;

  /* Abs: '<S49>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S49>/Relational Operator1' */
  rtb_RelationalOperator1_m = (rtb_Abs <= AC_SS_B->BusInput.T2s.rRelLim);

  /* BusSelector: '<S10>/Bus Selector' */
  rtb_rAct_hj = AC_SS_B->BusInput.T_EG.rAct;
  rtb_rTi_Filt_l = AC_SS_B->BusInput.T_EG.rTi_Filt;

  /* Sum: '<S54>/Add3' */
  rtb_Abs = AC_SS_B->BusInput.T_EG.rSet - rtb_rAct_hj;

  /* Abs: '<S54>/Abs3' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S54>/Relational Operator5' */
  rtb_RelationalOperator5_p = (rtb_Abs <= AC_SS_B->BusInput.T_EG.rAbsLim);

  /* Outputs for Atomic SubSystem: '<S55>/Filter' */
  AC_SS_Filter(rtb_rAct_hj, rtb_rTi_Filt_l, rtb_bReset, AC_SS_ConstB.Constant_j,
               &AC_SS_B->Filter_c, &AC_SS_DWork->Filter_c, inst);

  /* End of Outputs for SubSystem: '<S55>/Filter' */

  /* Sum: '<S55>/Add' */
  rtb_Abs = rtb_rAct_hj - AC_SS_B->Filter_c.DiscreteTimeIntegrator;

  /* Abs: '<S55>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S55>/Relational Operator1' */
  rtb_RelationalOperator1_a = (rtb_Abs <= AC_SS_B->BusInput.T_EG.rRelLim);

  /* BusSelector: '<S6>/Bus Selector' */
  rtb_rAct_g = AC_SS_B->BusInput.P_Norm.rAct;
  rtb_rTi_Filt_j = AC_SS_B->BusInput.P_Norm.rTi_Filt;

  /* Sum: '<S30>/Add3' */
  rtb_Abs = AC_SS_B->BusInput.P_Norm.rSet - rtb_rAct_g;

  /* Abs: '<S30>/Abs3' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S30>/Relational Operator5' */
  rtb_RelationalOperator5_b = (rtb_Abs <= AC_SS_B->BusInput.P_Norm.rAbsLim);

  /* Outputs for Atomic SubSystem: '<S31>/Filter' */
  AC_SS_Filter(rtb_rAct_g, rtb_rTi_Filt_j, rtb_bReset, AC_SS_ConstB.Constant_h,
               &AC_SS_B->Filter_h, &AC_SS_DWork->Filter_h, inst);

  /* End of Outputs for SubSystem: '<S31>/Filter' */

  /* Sum: '<S31>/Add' */
  rtb_Abs = rtb_rAct_g - AC_SS_B->Filter_h.DiscreteTimeIntegrator;

  /* Abs: '<S31>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S31>/Relational Operator1' */
  rtb_RelationalOperator1_d = (rtb_Abs <= AC_SS_B->BusInput.P_Norm.rRelLim);

  /* BusSelector: '<S4>/Bus Selector' */
  rtb_rAct_n = AC_SS_B->BusInput.Lam.rAct;
  rtb_rTi_Filt_e = AC_SS_B->BusInput.Lam.rTi_Filt;

  /* Sum: '<S18>/Add3' */
  rtb_Abs = AC_SS_B->BusInput.Lam.rSet - rtb_rAct_n;

  /* Abs: '<S18>/Abs3' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S18>/Relational Operator5' */
  rtb_RelationalOperator5_j = (rtb_Abs <= AC_SS_B->BusInput.Lam.rAbsLim);

  /* Outputs for Atomic SubSystem: '<S19>/Filter' */
  AC_SS_Filter(rtb_rAct_n, rtb_rTi_Filt_e, rtb_bReset, AC_SS_ConstB.Constant_g,
               &AC_SS_B->Filter_a, &AC_SS_DWork->Filter_a, inst);

  /* End of Outputs for SubSystem: '<S19>/Filter' */

  /* Sum: '<S19>/Add' */
  rtb_Abs = rtb_rAct_n - AC_SS_B->Filter_a.DiscreteTimeIntegrator;

  /* Abs: '<S19>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S19>/Relational Operator1' */
  rtb_RelationalOperator1_am = (rtb_Abs <= AC_SS_B->BusInput.Lam.rRelLim);

  /* BusSelector: '<S5>/Bus Selector' */
  rtb_rAct_b = AC_SS_B->BusInput.N_Norm.rAct;
  rtb_rTi_Filt_i = AC_SS_B->BusInput.N_Norm.rTi_Filt;

  /* Sum: '<S24>/Add3' */
  rtb_Abs = AC_SS_B->BusInput.N_Norm.rSet - rtb_rAct_b;

  /* Abs: '<S24>/Abs3' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S24>/Relational Operator5' */
  rtb_RelationalOperator5_j2 = (rtb_Abs <= AC_SS_B->BusInput.N_Norm.rAbsLim);

  /* Outputs for Atomic SubSystem: '<S25>/Filter' */
  AC_SS_Filter(rtb_rAct_b, rtb_rTi_Filt_i, rtb_bReset, AC_SS_ConstB.Constant_hq,
               &AC_SS_B->Filter_e, &AC_SS_DWork->Filter_e, inst);

  /* End of Outputs for SubSystem: '<S25>/Filter' */

  /* Sum: '<S25>/Add' */
  rtb_Abs = rtb_rAct_b - AC_SS_B->Filter_e.DiscreteTimeIntegrator;

  /* Abs: '<S25>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S25>/Relational Operator1' */
  rtb_RelationalOperator1_p = (rtb_Abs <= AC_SS_B->BusInput.N_Norm.rRelLim);

  /* BusSelector: '<S8>/Bus Selector' */
  rtb_rAct_d = AC_SS_B->BusInput.P_d_Norm.rAct;
  rtb_rTi_Filt_k = AC_SS_B->BusInput.P_d_Norm.rTi_Filt;

  /* Sum: '<S42>/Add3' */
  rtb_Abs = AC_SS_B->BusInput.P_d_Norm.rSet - rtb_rAct_d;

  /* Abs: '<S42>/Abs3' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S42>/Relational Operator5' */
  rtb_RelationalOperator5_e = (rtb_Abs <= AC_SS_B->BusInput.P_d_Norm.rAbsLim);

  /* Outputs for Atomic SubSystem: '<S43>/Filter' */
  AC_SS_Filter(rtb_rAct_d, rtb_rTi_Filt_k, rtb_bReset, AC_SS_ConstB.Constant_b,
               &AC_SS_B->Filter_f, &AC_SS_DWork->Filter_f, inst);

  /* End of Outputs for SubSystem: '<S43>/Filter' */

  /* Sum: '<S43>/Add' */
  rtb_Abs = rtb_rAct_d - AC_SS_B->Filter_f.DiscreteTimeIntegrator;

  /* Abs: '<S43>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S43>/Relational Operator1' */
  rtb_RelationalOperator1_n = (rtb_Abs <= AC_SS_B->BusInput.P_d_Norm.rRelLim);

  /* BusSelector: '<S3>/Bus Selector' */
  rtb_rAct_i = AC_SS_B->BusInput.IP.rAct;
  rtb_rTi_Filt_m = AC_SS_B->BusInput.IP.rTi_Filt;

  /* Sum: '<S12>/Add3' */
  rtb_Abs = AC_SS_B->BusInput.IP.rSet - rtb_rAct_i;

  /* Abs: '<S12>/Abs3' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* RelationalOperator: '<S12>/Relational Operator5' */
  rtb_RelationalOperator5_m = (rtb_Abs <= AC_SS_B->BusInput.IP.rAbsLim);

  /* Outputs for Atomic SubSystem: '<S13>/Filter' */
  AC_SS_Filter(rtb_rAct_i, rtb_rTi_Filt_m, rtb_bReset, AC_SS_ConstB.Constant_f,
               &AC_SS_B->Filter_o, &AC_SS_DWork->Filter_o, inst);

  /* End of Outputs for SubSystem: '<S13>/Filter' */

  /* Sum: '<S13>/Add' */
  rtb_Abs = rtb_rAct_i - AC_SS_B->Filter_o.DiscreteTimeIntegrator;

  /* Abs: '<S13>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Abs);

  /* BusCreator: '<S2>/Bus Creator1' incorporates:
   *  BusCreator: '<S10>/Bus Creator2'
   *  BusCreator: '<S3>/Bus Creator2'
   *  BusCreator: '<S4>/Bus Creator2'
   *  BusCreator: '<S5>/Bus Creator2'
   *  BusCreator: '<S6>/Bus Creator2'
   *  BusCreator: '<S7>/Bus Creator2'
   *  BusCreator: '<S8>/Bus Creator2'
   *  BusCreator: '<S9>/Bus Creator2'
   *  RelationalOperator: '<S13>/Relational Operator1'
   */
  AC_SS_Y->dbg.P2s.bAbs = rtb_RelationalOperator5;
  AC_SS_Y->dbg.P2s.bRel = rtb_RelationalOperator1;
  AC_SS_Y->dbg.T2s.bAbs = rtb_RelationalOperator5_n;
  AC_SS_Y->dbg.T2s.bRel = rtb_RelationalOperator1_m;
  AC_SS_Y->dbg.T_EG.bAbs = rtb_RelationalOperator5_p;
  AC_SS_Y->dbg.T_EG.bRel = rtb_RelationalOperator1_a;
  AC_SS_Y->dbg.P_Norm.bAbs = rtb_RelationalOperator5_b;
  AC_SS_Y->dbg.P_Norm.bRel = rtb_RelationalOperator1_d;
  AC_SS_Y->dbg.Lam.bAbs = rtb_RelationalOperator5_j;
  AC_SS_Y->dbg.Lam.bRel = rtb_RelationalOperator1_am;
  AC_SS_Y->dbg.N_Norm.bAbs = rtb_RelationalOperator5_j2;
  AC_SS_Y->dbg.N_Norm.bRel = rtb_RelationalOperator1_p;
  AC_SS_Y->dbg.P_d_Norm.bAbs = rtb_RelationalOperator5_e;
  AC_SS_Y->dbg.P_d_Norm.bRel = rtb_RelationalOperator1_n;
  AC_SS_Y->dbg.IP.bAbs = rtb_RelationalOperator5_m;
  AC_SS_Y->dbg.IP.bRel = (rtb_Abs <= AC_SS_B->BusInput.IP.rRelLim);

  /* SignalConversion: '<S2>/TmpSignal ConversionAtGainInport1' incorporates:
   *  BusSelector: '<S2>/Bus Selector'
   */
  tmp[0] = AC_SS_Y->dbg.P2s.bAbs;
  tmp[1] = AC_SS_Y->dbg.T2s.bAbs;
  tmp[2] = AC_SS_Y->dbg.T_EG.bAbs;
  tmp[3] = AC_SS_Y->dbg.P_Norm.bAbs;
  tmp[4] = AC_SS_Y->dbg.Lam.bAbs;
  tmp[5] = AC_SS_Y->dbg.N_Norm.bAbs;
  tmp[6] = AC_SS_Y->dbg.P_d_Norm.bAbs;
  tmp[7] = AC_SS_Y->dbg.IP.bAbs;

  /* Gain: '<S2>/Gain' */
  tmp_0 = 0U;
  for (i = 0; i < 8; i++) {
    tmp_0 = (uint8_T)((uint32_T)tmp_0 + (uint32_T)(tmp[i] ?
      AC_SS_ConstP.pooled4[i] : 0));
  }

  /* Outport: '<Root>/iAbs' incorporates:
   *  Gain: '<S2>/Gain'
   */
  AC_SS_Y->iAbs = tmp_0;

  /* SignalConversion: '<S2>/TmpSignal ConversionAtGain1Inport1' incorporates:
   *  BusSelector: '<S2>/Bus Selector1'
   */
  tmp_1[0] = AC_SS_Y->dbg.P2s.bRel;
  tmp_1[1] = AC_SS_Y->dbg.T2s.bRel;
  tmp_1[2] = AC_SS_Y->dbg.T_EG.bRel;
  tmp_1[3] = AC_SS_Y->dbg.P_Norm.bRel;
  tmp_1[4] = AC_SS_Y->dbg.Lam.bRel;
  tmp_1[5] = AC_SS_Y->dbg.N_Norm.bRel;
  tmp_1[6] = AC_SS_Y->dbg.P_d_Norm.bRel;
  tmp_1[7] = AC_SS_Y->dbg.IP.bRel;

  /* Gain: '<S2>/Gain1' */
  tmp_0 = 0U;
  for (i = 0; i < 8; i++) {
    tmp_0 = (uint8_T)((uint32_T)tmp_0 + (uint32_T)(tmp_1[i] ?
      AC_SS_ConstP.pooled4[i] : 0));
  }

  /* Outport: '<Root>/iRel' incorporates:
   *  Gain: '<S2>/Gain1'
   */
  AC_SS_Y->iRel = tmp_0;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->dbg = AC_SS_Y->dbg;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->iAbs = AC_SS_Y->iAbs;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->iRel = AC_SS_Y->iRel;
}

/* Model initialize function */
void AC_SS_initialize(struct D_Work_AC_SS *AC_SS_DWork, struct SS* inst)
{
  /* InitializeConditions for Atomic SubSystem: '<S37>/Filter' */
  AC_SS_Filter_Init(AC_SS_ConstB.Constant, &AC_SS_DWork->Filter, inst);

  /* End of InitializeConditions for SubSystem: '<S37>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S49>/Filter' */
  AC_SS_Filter_Init(AC_SS_ConstB.Constant_d, &AC_SS_DWork->Filter_n, inst);

  /* End of InitializeConditions for SubSystem: '<S49>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S55>/Filter' */
  AC_SS_Filter_Init(AC_SS_ConstB.Constant_j, &AC_SS_DWork->Filter_c, inst);

  /* End of InitializeConditions for SubSystem: '<S55>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S31>/Filter' */
  AC_SS_Filter_Init(AC_SS_ConstB.Constant_h, &AC_SS_DWork->Filter_h, inst);

  /* End of InitializeConditions for SubSystem: '<S31>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S19>/Filter' */
  AC_SS_Filter_Init(AC_SS_ConstB.Constant_g, &AC_SS_DWork->Filter_a, inst);

  /* End of InitializeConditions for SubSystem: '<S19>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S25>/Filter' */
  AC_SS_Filter_Init(AC_SS_ConstB.Constant_hq, &AC_SS_DWork->Filter_e, inst);

  /* End of InitializeConditions for SubSystem: '<S25>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S43>/Filter' */
  AC_SS_Filter_Init(AC_SS_ConstB.Constant_b, &AC_SS_DWork->Filter_f, inst);

  /* End of InitializeConditions for SubSystem: '<S43>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S13>/Filter' */
  AC_SS_Filter_Init(AC_SS_ConstB.Constant_f, &AC_SS_DWork->Filter_o, inst);

  /* End of InitializeConditions for SubSystem: '<S13>/Filter' */
}

/* Model terminate function */
void AC_SS_terminate(struct SS* inst)
{
  /* (no terminate code required) */
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 8.0 (R2012b)20-Jul-2012                                             *
 * Simulink 8.0 (R2012b)20-Jul-2012                                           *
 * Simulink Coder 8.3 (R2012b)20-Jul-2012                                     *
 * Embedded Coder 6.3 (R2012b)20-Jul-2012                                     *
 * Stateflow 8.0 (R2012b)20-Jul-2012                                          *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
