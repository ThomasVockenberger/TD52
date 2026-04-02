/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: G2Fdiag
 * File: G2Fdiag.c
 * Author: 106003773
 * Created: Wed Apr 20 16:09:39 2016
 ********************************************************************
 * Implementation of program G2Fdiag
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "G2Fdiag.h"
#include "G2Fdiag_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */
struct BlockIO_G2Fdiag G2Fdiag_B;

/* Block states (auto storage) */
struct D_Work_G2Fdiag G2Fdiag_DWork;

/* External inputs (root inport signals with auto storage) */
ExternalInputs_G2Fdiag G2Fdiag_U;

/* External outputs (root outports fed by signals with auto storage) */
ExternalOutputs_G2Fdiag G2Fdiag_Y;

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/*
 * Initial conditions for atomic system:
 *    '<S7>/TOF'
 *    '<S11>/TOF'
 *    '<S12>/TOF'
 */
void G2Fdiag_TOF_Init(rtDW_TOF_G2Fdiag *localDW, struct fGEN2diag* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S16>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
  localDW->DiscreteTimeIntegrator_PrevRese = 2;
}

/*
 * Output and update for atomic system:
 *    '<S7>/TOF'
 *    '<S11>/TOF'
 *    '<S12>/TOF'
 */
void G2Fdiag_TOF(boolean_T rtu_IN, real_T rtu_PT, rtB_TOF_G2Fdiag *localB,
                 rtDW_TOF_G2Fdiag *localDW, struct fGEN2diag* inst)
{
  real_T rtb_Switch_f;

  /* Switch: '<S16>/Switch' incorporates:
   *  Constant: '<S16>/Constant1'
   */
  if (rtu_IN) {
    rtb_Switch_f = 0.0;
  } else {
    rtb_Switch_f = rtu_PT;
  }

  /* End of Switch: '<S16>/Switch' */

  /* DiscreteIntegrator: '<S16>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_f;
  }

  if (rtu_IN && (localDW->DiscreteTimeIntegrator_PrevRese <= 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_f;
  }

  /* Logic: '<S16>/Logical Operator1' incorporates:
   *  DiscreteIntegrator: '<S16>/Discrete-Time Integrator'
   *  RelationalOperator: '<S16>/Relational Operator'
   */
  localB->LogicalOperator1 = !(localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Update for DiscreteIntegrator: '<S16>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S17>/Conversion'
   *  Logic: '<S16>/Logical Operator5'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  localDW->DiscreteTimeIntegrator_DSTATE += 0.01 * (real_T)!rtu_IN;
  if (rtu_IN) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S16>/Discrete-Time Integrator' */
}

/*
 * Output and update for atomic system:
 *    '<S8>/TON'
 *    '<S9>/TON'
 *    '<S10>/TON'
 *    '<S13>/TON'
 *    '<S13>/TON1'
 *    '<S14>/TON'
 *    '<S15>/TON'
 */
void G2Fdiag_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_G2Fdiag *localB,
                 rtDW_TON_G2Fdiag *localDW, struct fGEN2diag* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2_kx;
  boolean_T rtb_RelationalOperator_f;

  /* Logic: '<S20>/Logical Operator2' */
  rtb_LogicalOperator2_kx = !rtu_IN;

  /* DiscreteIntegrator: '<S20>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_kx || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S20>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S20>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_f = (localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Logic: '<S20>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_f && rtu_IN);

  /* Update for DiscreteIntegrator: '<S20>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S29>/Conversion'
   *  Logic: '<S20>/Logical Operator'
   *  Logic: '<S20>/Logical Operator1'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (real32_T)
    ((!rtb_RelationalOperator_f) && rtu_IN) * 0.01F;
  if (rtb_LogicalOperator2_kx) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S20>/Discrete-Time Integrator' */
}

/*
 * Output and update for enable system:
 *    '<S68>/Enabled Subsystem'
 *    '<S68>/Enabled Subsystem1'
 *    '<S69>/Enabled Subsystem'
 *    '<S69>/Enabled Subsystem1'
 */
void G2Fdiag_EnabledSubsystem(boolean_T rtu_0, real_T rtu_1, real_T *rty_Out1, struct fGEN2diag* inst)
{
  /* Outputs for Enabled SubSystem: '<S68>/Enabled Subsystem' incorporates:
   *  EnablePort: '<S78>/Enable'
   */
  if (rtu_0) {
    /* Inport: '<S78>/In1' */
    *rty_Out1 = rtu_1;
  }

  /* End of Outputs for SubSystem: '<S68>/Enabled Subsystem' */
}

/*
 * Initial conditions for atomic system:
 *    '<S6>/TP'
 *    '<S6>/TP1'
 */
void G2Fdiag_TP_Init(rtDW_TP_G2Fdiag *localDW, struct fGEN2diag* inst)
{
  /* InitializeConditions for UnitDelay: '<S68>/Unit Delay2' */
  localDW->UnitDelay2_DSTATE = TRUE;
}

/*
 * Output and update for atomic system:
 *    '<S6>/TP'
 *    '<S6>/TP1'
 */
void G2Fdiag_TP(boolean_T rtu_IN, real_T rtu_PT, rtB_TP_G2Fdiag *localB,
                rtDW_TP_G2Fdiag *localDW, struct fGEN2diag* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator3_bg;
  real_T rtb_Switch2;
  real_T rtb_UkYk1;
  real_T rtb_Yk1;

  /* Product: '<S80>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S80>/sample time'
   *
   * About '<S80>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2 = 0.01;

  /* UnitDelay: '<S80>/Delay Input2' */
  rtb_Yk1 = localDW->DelayInput2_DSTATE;

  /* Logic: '<S68>/Logical Operator3' incorporates:
   *  Logic: '<S68>/Logical Operator2'
   *  UnitDelay: '<S68>/Unit Delay2'
   */
  rtb_LogicalOperator3_bg = ((!rtu_IN) && localDW->UnitDelay2_DSTATE);

  /* Outputs for Enabled SubSystem: '<S68>/Enabled Subsystem' */

  /* Constant: '<S68>/Constant10' */
  G2Fdiag_EnabledSubsystem(rtb_LogicalOperator3_bg, 0.0, &localB->Merge, inst);

  /* End of Outputs for SubSystem: '<S68>/Enabled Subsystem' */

  /* Outputs for Enabled SubSystem: '<S68>/Enabled Subsystem1' */
  G2Fdiag_EnabledSubsystem(rtu_IN, rtu_PT, &localB->Merge, inst);

  /* End of Outputs for SubSystem: '<S68>/Enabled Subsystem1' */

  /* Sum: '<S80>/Difference Inputs1' */
  rtb_UkYk1 = localB->Merge - rtb_Yk1;

  /* Switch: '<S81>/Switch2' incorporates:
   *  RelationalOperator: '<S81>/LowerRelop1'
   */
  if (!(rtb_UkYk1 > 0.01)) {
    /* Switch: '<S81>/Switch' incorporates:
     *  RelationalOperator: '<S81>/UpperRelop'
     */
    if (rtb_UkYk1 < -99.990000000000009) {
      rtb_Switch2 = -99.990000000000009;
    } else {
      rtb_Switch2 = rtb_UkYk1;
    }

    /* End of Switch: '<S81>/Switch' */
  }

  /* End of Switch: '<S81>/Switch2' */

  /* Sum: '<S80>/Difference Inputs2' */
  rtb_Switch2 += rtb_Yk1;

  /* Logic: '<S68>/Logical Operator1' incorporates:
   *  Constant: '<S77>/Constant'
   *  RelationalOperator: '<S68>/Relational Operator1'
   *  RelationalOperator: '<S77>/Compare'
   */
  localB->LogicalOperator1 = ((rtb_Switch2 > 0.0) && (rtb_Switch2 < rtu_PT));

  /* Update for UnitDelay: '<S80>/Delay Input2' */
  localDW->DelayInput2_DSTATE = rtb_Switch2;

  /* Update for UnitDelay: '<S68>/Unit Delay2' incorporates:
   *  RelationalOperator: '<S68>/Relational Operator3'
   */
  localDW->UnitDelay2_DSTATE = (rtb_Switch2 >= rtu_PT);
}

/* Model step function */
void G2Fdiag_step(struct fGEN2diag* inst)
{
  /* local block i/o variables */
  real_T rtb_DataTypeConversion3;
  real_T rtb_DataTypeConversion1;
  real_T rtb_DataTypeConversion3_j;
  real_T rtb_DataTypeConversion2;
  real_T rtb_DataTypeConversion2_i;
  real32_T rtb_MonitoringDelay;
  real32_T rtb_MonitoringDelay_d;
  real32_T rtb_MonitoringDelay_h;
  real32_T rtb_MonitoringDelay_g;
  real32_T rtb_MonitoringDelay_p;
  real32_T rtb_TexhSettledTConstLP;
  real32_T rtb_TexhSettledMaxTD;
  boolean_T rtb_LEANOXErrorFiltReset;
  boolean_T rtb_RelationalOperator1;
  boolean_T rtb_bExt_dist;
  boolean_T rtb_WGM_reset;
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_bVltg_reset;
  boolean_T rtb_LogicalOperator2_k;
  boolean_T rtb_LogicalOperator2_d;
  boolean_T rtb_bGasMixing_reset;
  boolean_T rtb_LogicalOperator2_b;
  boolean_T rtb_bPTransDetReset;
  boolean_T rtb_LogicalOperator4;
  boolean_T rtb_LogicalOperator3_b;
  boolean_T rtb_bTexhSettled_reset;
  boolean_T rtb_Texh_avg_settled;
  boolean_T rtb_lambdaFault;
  boolean_T rtb_RelationalOperator1_m;
  boolean_T rtb_LogicalOperator_h;
  boolean_T rtb_LogicalOperator1_h;
  boolean_T rtb_RelationalOperator3;
  real_T N_plausible;
  real32_T rtb_LambdaCmd;
  real32_T rtb_LEANOXErrorTconst;
  real32_T rtb_Sum;
  real32_T rtb_DiscreteTimeIntegrator_j;
  real32_T rtb_WGM_Tconst;
  boolean_T rtb_LogicalOperator1_ie;
  real32_T rtb_DiscreteTimeIntegrator_go;
  real32_T rtb_Vltg_Tconst;
  real32_T rtb_DiscreteTimeIntegrator_hq;
  real32_T rtb_DiscreteTimeIntegrator_p;
  real32_T rtb_DiscreteTimeIntegrator_k;
  real32_T rtb_GasMixingTconstLP;
  boolean_T rtb_Compare;
  boolean_T rtb_Compare_h;
  boolean_T rtb_Compare_c;
  boolean_T rtb_Compare_e;
  boolean_T rtb_LogicalOperator1_l;
  real32_T rtb_GasMixingTconstHP;
  boolean_T rtb_LogicalOperator1_i;
  real32_T rtb_DiscreteTimeIntegrator;
  real32_T rtb_HP_filtered;
  real32_T rtb_DiscreteTimeIntegrator_i;
  boolean_T rtb_LogicalOperator1_du;
  boolean_T rtb_Switch;
  boolean_T rtb_LogicalOperator2_l;
  boolean_T rtb_LogicalOperator5_d;
  real32_T rtb_TconstPsetStat;
  real32_T rtb_TexhSettledTConstHP;
  boolean_T rtb_LogicalOperator1_ld;
  real32_T rtb_TConstLP;
  int32_T rtb_NCyl;
  boolean_T rtb_bFault_b;
  boolean_T rtb_Switch_o;
  int16_T rtb_TmpSignalConversionAtSumofE[12];
  int32_T i;
  real32_T rtb_Sum1;
  real32_T rtb_Product;
  boolean_T rtb_lambdaFaultTOF;
  real32_T rtb_Sum4;
  real32_T rtb_lambdaEst_HP;
  real32_T rtb_lambda_ss;
  real32_T rtb_u_mean;
  real32_T rtb_Product1;
  real32_T rtb_DiscreteTimeIntegrator_m;
  real32_T rtb_Product2;
  boolean_T rtb_Uk1_od;
  boolean_T rtb_LogicalOperator1_f;
  real32_T rtb_Saturation_c2;
  real32_T rtb_Saturation_mc;
  real32_T rtb_Gain1_idx;
  real32_T rtb_Sum_o_idx;
  real32_T rtb_DiscreteTimeIntegrator_g_id;
  real32_T rtb_DiscreteTimeIntegrator_b_id;
  real32_T rtb_DiscreteTimeIntegrator_b__0;
  real32_T rtb_DiscreteTimeIntegrator_b__1;
  real32_T rtb_DiscreteTimeIntegrator_g__0;
  real32_T rtb_DiscreteTimeIntegrator_g__1;
  real32_T rtb_DiscreteTimeIntegrator_gp_i;
  real32_T rtb_DiscreteTimeIntegrator_gp_0;
  real32_T rtb_DiscreteTimeIntegrator_gp_1;
  real32_T rtb_DiscreteTimeIntegrator_ht_i;
  real32_T rtb_DiscreteTimeIntegrator_ht_0;
  real32_T rtb_DiscreteTimeIntegrator_ht_1;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  G2Fdiag_B.BusInput1 = inst->In;

  /* BusSelector: '<S3>/Bus Selector1' */
  rtb_LambdaCmd = G2Fdiag_B.BusInput1.LambdaCmd;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  G2Fdiag_B.BusInput = inst->Para;

  /* BusSelector: '<S5>/Bus Selector7' */
  rtb_LEANOXErrorTconst = G2Fdiag_B.BusInput.LEANOXErrorTconst;
  rtb_MonitoringDelay = G2Fdiag_B.BusInput.MonitoringDelay;

  /* BusSelector: '<S5>/Bus Selector6' */
  rtb_LEANOXErrorFiltReset = G2Fdiag_B.BusInput1.LEANOXErrorFiltReset;

  /* Sum: '<S10>/Sum' */
  rtb_Sum = G2Fdiag_B.BusInput1.p2sCmd - G2Fdiag_B.BusInput1.p2s;

  /* DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOADI != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE = rtb_Sum;
  }

  if (rtb_LEANOXErrorFiltReset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRese
       != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE = rtb_Sum;
  }

  rtb_DiscreteTimeIntegrator_j = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE;

  /* RelationalOperator: '<S10>/Relational Operator1' incorporates:
   *  Abs: '<S10>/Abs'
   *  DiscreteIntegrator: '<S36>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator1 = (G2Fdiag_B.BusInput.LEANOXErrorThrsh >= (real32_T)
    fabs(G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE));

  /* Outputs for Atomic SubSystem: '<S10>/TON' */
  G2Fdiag_TON(rtb_RelationalOperator1, rtb_MonitoringDelay, &G2Fdiag_B.TON,
              &G2Fdiag_DWork.TON, inst);

  /* End of Outputs for SubSystem: '<S10>/TON' */

  /* BusSelector: '<S5>/Bus Selector4' */
  rtb_bExt_dist = G2Fdiag_B.BusInput1.bExt_dist;

  /* DataTypeConversion: '<S7>/Data Type Conversion3' incorporates:
   *  BusSelector: '<S5>/Bus Selector5'
   */
  rtb_DataTypeConversion3 = G2Fdiag_B.BusInput.MonitoringDelay;

  /* Outputs for Atomic SubSystem: '<S7>/TOF' */
  G2Fdiag_TOF(rtb_bExt_dist, rtb_DataTypeConversion3, &G2Fdiag_B.TOF,
              &G2Fdiag_DWork.TOF, inst);

  /* End of Outputs for SubSystem: '<S7>/TOF' */

  /* Logic: '<S7>/Logical Operator1' */
  rtb_LogicalOperator1_ie = !G2Fdiag_B.TOF.LogicalOperator1;

  /* BusSelector: '<S5>/Bus Selector10' */
  rtb_WGM_Tconst = G2Fdiag_B.BusInput.WGM_Tconst;
  rtb_MonitoringDelay_d = G2Fdiag_B.BusInput.MonitoringDelay;

  /* BusSelector: '<S5>/Bus Selector9' */
  rtb_WGM_reset = G2Fdiag_B.BusInput1.WGM_reset;

  /* DiscreteIntegrator: '<S64>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_c != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_k =
      G2Fdiag_B.BusInput1.posWG_norm;
  }

  if (rtb_WGM_reset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_e != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_k =
      G2Fdiag_B.BusInput1.posWG_norm;
  }

  rtb_DiscreteTimeIntegrator_go = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_k;

  /* Logic: '<S15>/Logical Operator2' incorporates:
   *  Abs: '<S15>/Abs'
   *  DiscreteIntegrator: '<S64>/Discrete-Time Integrator'
   *  RelationalOperator: '<S15>/Relational Operator1'
   *  Sum: '<S15>/Add'
   */
  rtb_LogicalOperator2 = !(G2Fdiag_B.BusInput.WGM_FaultThrsh <= (real32_T)fabs
    (G2Fdiag_B.BusInput1.posWG_norm -
     G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_k));

  /* Outputs for Atomic SubSystem: '<S15>/TON' */
  G2Fdiag_TON(rtb_LogicalOperator2, rtb_MonitoringDelay_d, &G2Fdiag_B.TON_n,
              &G2Fdiag_DWork.TON_n, inst);

  /* End of Outputs for SubSystem: '<S15>/TON' */

  /* BusSelector: '<S5>/Bus Selector1' */
  rtb_Vltg_Tconst = G2Fdiag_B.BusInput.Vltg_Tconst;
  rtb_MonitoringDelay_h = G2Fdiag_B.BusInput.MonitoringDelay;

  /* BusSelector: '<S5>/Bus Selector2' */
  rtb_bVltg_reset = G2Fdiag_B.BusInput1.bVltg_reset;

  /* DiscreteIntegrator: '<S60>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_b != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_h =
      G2Fdiag_B.BusInput1.U_L1L2_norm;
  }

  if (rtb_bVltg_reset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_j != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_h =
      G2Fdiag_B.BusInput1.U_L1L2_norm;
  }

  rtb_DiscreteTimeIntegrator_hq = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_h;

  /* DiscreteIntegrator: '<S61>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_g != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_c =
      G2Fdiag_B.BusInput1.U_L2L3_norm;
  }

  if (rtb_bVltg_reset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_f != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_c =
      G2Fdiag_B.BusInput1.U_L2L3_norm;
  }

  rtb_DiscreteTimeIntegrator_p = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_c;

  /* DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_p != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_p =
      G2Fdiag_B.BusInput1.U_L3L1_norm;
  }

  if (rtb_bVltg_reset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_p != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_p =
      G2Fdiag_B.BusInput1.U_L3L1_norm;
  }

  rtb_DiscreteTimeIntegrator_k = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_p;

  /* Logic: '<S14>/Logical Operator2' incorporates:
   *  Abs: '<S56>/Abs'
   *  Abs: '<S57>/Abs'
   *  Abs: '<S58>/Abs'
   *  DiscreteIntegrator: '<S60>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S61>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S62>/Discrete-Time Integrator'
   *  Logic: '<S14>/Logical Operator1'
   *  RelationalOperator: '<S56>/Relational Operator1'
   *  RelationalOperator: '<S57>/Relational Operator1'
   *  RelationalOperator: '<S58>/Relational Operator1'
   *  Sum: '<S56>/Add'
   *  Sum: '<S57>/Add'
   *  Sum: '<S58>/Add'
   */
  rtb_LogicalOperator2_k = !((G2Fdiag_B.BusInput.Vltg_FaultThrsh <= (real32_T)
    fabs(G2Fdiag_B.BusInput1.U_L1L2_norm -
         G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_h)) ||
    (G2Fdiag_B.BusInput.Vltg_FaultThrsh <= (real32_T)fabs
     (G2Fdiag_B.BusInput1.U_L2L3_norm -
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_c)) ||
    (G2Fdiag_B.BusInput.Vltg_FaultThrsh <= (real32_T)fabs
     (G2Fdiag_B.BusInput1.U_L3L1_norm -
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_p)));

  /* Outputs for Atomic SubSystem: '<S14>/TON' */
  G2Fdiag_TON(rtb_LogicalOperator2_k, rtb_MonitoringDelay_h, &G2Fdiag_B.TON_i,
              &G2Fdiag_DWork.TON_i, inst);

  /* End of Outputs for SubSystem: '<S14>/TON' */

  /* RelationalOperator: '<S28>/Compare' incorporates:
   *  Constant: '<S28>/Constant'
   */
  rtb_Compare = G2Fdiag_B.BusInput1.bMCBON;

  /* RelationalOperator: '<S27>/Compare' incorporates:
   *  Constant: '<S27>/Constant'
   */
  rtb_Compare_h = !G2Fdiag_B.BusInput1.bMCBON;

  /* RelationalOperator: '<S24>/Compare' incorporates:
   *  Constant: '<S24>/Constant'
   */
  rtb_Compare_c = G2Fdiag_B.BusInput1.bGCBON;

  /* RelationalOperator: '<S23>/Compare' incorporates:
   *  Constant: '<S23>/Constant'
   */
  rtb_Compare_e = !G2Fdiag_B.BusInput1.bGCBON;

  /* Logic: '<S8>/Logical Operator2' incorporates:
   *  Constant: '<S24>/Constant'
   *  Constant: '<S28>/Constant'
   *  Logic: '<S18>/Logical Operator'
   *  Logic: '<S19>/Logical Operator'
   *  Logic: '<S8>/Logical Operator3'
   *  RelationalOperator: '<S21>/FixPt Relational Operator'
   *  RelationalOperator: '<S22>/FixPt Relational Operator'
   *  RelationalOperator: '<S24>/Compare'
   *  RelationalOperator: '<S25>/FixPt Relational Operator'
   *  RelationalOperator: '<S26>/FixPt Relational Operator'
   *  RelationalOperator: '<S28>/Compare'
   *  UnitDelay: '<S21>/Delay Input1'
   *  UnitDelay: '<S22>/Delay Input1'
   *  UnitDelay: '<S25>/Delay Input1'
   *  UnitDelay: '<S26>/Delay Input1'
   */
  rtb_LogicalOperator2_d = !(((int32_T)G2Fdiag_B.BusInput1.bMCBON > (int32_T)
    G2Fdiag_DWork.DelayInput1_DSTATE) || ((int32_T)rtb_Compare_h > (int32_T)
    G2Fdiag_DWork.DelayInput1_DSTATE_e) || (((int32_T)G2Fdiag_B.BusInput1.bGCBON
    > (int32_T)G2Fdiag_DWork.DelayInput1_DSTATE_m) || ((int32_T)rtb_Compare_e >
                               (int32_T)G2Fdiag_DWork.DelayInput1_DSTATE_l)));

  /* BusSelector: '<S5>/Bus Selector12' */
  rtb_MonitoringDelay_g = G2Fdiag_B.BusInput.MonitoringDelay;

  /* Outputs for Atomic SubSystem: '<S8>/TON' */
  G2Fdiag_TON(rtb_LogicalOperator2_d, rtb_MonitoringDelay_g, &G2Fdiag_B.TON_k,
              &G2Fdiag_DWork.TON_k, inst);

  /* End of Outputs for SubSystem: '<S8>/TON' */

  /* Logic: '<S8>/Logical Operator1' */
  rtb_LogicalOperator1_l = (G2Fdiag_B.BusInput1.bMCBON &&
    G2Fdiag_B.BusInput1.bGCBON);

  /* Outputs for Atomic SubSystem: '<S5>/Min Load Detection' */
  /* DataTypeConversion: '<S11>/Data Type Conversion2' */
  rtb_DataTypeConversion2_i = G2Fdiag_B.BusInput.MonitoringDelay;

  /* RelationalOperator: '<S11>/Relational Operator3' */
  rtb_RelationalOperator3 = (G2Fdiag_B.BusInput1.Pset_norm <
    G2Fdiag_B.BusInput.TrshLoad);

  /* Outputs for Atomic SubSystem: '<S11>/TOF' */
  G2Fdiag_TOF(rtb_RelationalOperator3, rtb_DataTypeConversion2_i,
              &G2Fdiag_B.TOF_h, &G2Fdiag_DWork.TOF_h, inst);

  /* End of Outputs for SubSystem: '<S11>/TOF' */

  /* Logic: '<S11>/Logical Operator1' */
  rtb_LogicalOperator1_du = !G2Fdiag_B.TOF_h.LogicalOperator1;

  /* End of Outputs for SubSystem: '<S5>/Min Load Detection' */

  /* BusSelector: '<S5>/Bus Selector19' */
  rtb_GasMixingTconstLP = G2Fdiag_B.BusInput.GasMixingTconstLP;
  rtb_GasMixingTconstHP = G2Fdiag_B.BusInput.GasMixingTconstHP;
  rtb_MonitoringDelay_p = G2Fdiag_B.BusInput.MonitoringDelay;

  /* Logic: '<S9>/Logical Operator1' */
  rtb_LogicalOperator1_i = !G2Fdiag_B.BusInput.bGasMixingEnDet;

  /* BusSelector: '<S5>/Bus Selector18' */
  rtb_bGasMixing_reset = G2Fdiag_B.BusInput1.bGasMixing_reset;

  /* DiscreteIntegrator: '<S31>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_o != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_e =
      G2Fdiag_B.BusInput1.rGasMixing_Ratio;
  }

  if (rtb_bGasMixing_reset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_jm !=
       0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_e =
      G2Fdiag_B.BusInput1.rGasMixing_Ratio;
  }

  rtb_DiscreteTimeIntegrator = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_e;

  /* DiscreteIntegrator: '<S34>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S31>/Discrete-Time Integrator'
   */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_cl != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_hv =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_e;
  }

  if (rtb_bGasMixing_reset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_n !=
       0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_hv =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_e;
  }

  rtb_HP_filtered = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_hv;

  /* Abs: '<S32>/Abs' incorporates:
   *  DiscreteIntegrator: '<S31>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S34>/Discrete-Time Integrator'
   *  Sum: '<S32>/Add'
   */
  rtb_DiscreteTimeIntegrator_i = (real32_T)fabs
    (G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_e -
     G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_hv);

  /* Logic: '<S9>/Logical Operator2' incorporates:
   *  RelationalOperator: '<S32>/Relational Operator1'
   */
  rtb_LogicalOperator2_b = !(G2Fdiag_B.BusInput.GasMixingThrsh <=
    rtb_DiscreteTimeIntegrator_i);

  /* Outputs for Atomic SubSystem: '<S9>/TON' */
  G2Fdiag_TON(rtb_LogicalOperator2_b, rtb_MonitoringDelay_p, &G2Fdiag_B.TON_j,
              &G2Fdiag_DWork.TON_j, inst);

  /* End of Outputs for SubSystem: '<S9>/TON' */

  /* Switch: '<S9>/Switch' incorporates:
   *  Constant: '<S9>/Constant'
   */
  if (rtb_LogicalOperator1_i) {
    rtb_Switch = TRUE;
  } else {
    rtb_Switch = G2Fdiag_B.TON_j.LogicalOperator3;
  }

  /* End of Switch: '<S9>/Switch' */

  /* Logic: '<S5>/Logical Operator4' */
  rtb_LogicalOperator2_l = (rtb_LogicalOperator1_ie &&
    G2Fdiag_B.TON_n.LogicalOperator3 && G2Fdiag_B.TON_i.LogicalOperator3 &&
    G2Fdiag_B.TON_k.LogicalOperator3 && rtb_LogicalOperator1_l &&
    rtb_LogicalOperator1_du && rtb_Switch);

  /* Logic: '<S5>/Logical Operator5' */
  rtb_LogicalOperator5_d = (G2Fdiag_B.BusInput1.bAllowDetInTrans &&
    G2Fdiag_B.TON.LogicalOperator3 && rtb_LogicalOperator2_l);

  /* BusSelector: '<S5>/Bus Selector8' */
  rtb_bPTransDetReset = G2Fdiag_B.BusInput1.bPTransDetReset;

  /* BusSelector: '<S5>/Bus Selector3' */
  rtb_TconstPsetStat = G2Fdiag_B.BusInput.TconstPsetStat;

  /* Outputs for Atomic SubSystem: '<S5>/Power ramp detection' */
  /* DiscreteIntegrator: '<S41>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_gt != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_i =
      G2Fdiag_B.BusInput1.Pset_norm;
  }

  if (rtb_bPTransDetReset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_ah != 0))
  {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_i =
      G2Fdiag_B.BusInput1.Pset_norm;
  }

  rtb_DiscreteTimeIntegrator_m = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_i;

  /* DataTypeConversion: '<S12>/Data Type Conversion2' */
  rtb_DataTypeConversion2 = G2Fdiag_B.BusInput.MonitoringDelay;

  /* Logic: '<S12>/Logical Operator' incorporates:
   *  Abs: '<S12>/Abs1'
   *  Abs: '<S12>/Abs2'
   *  DiscreteIntegrator: '<S41>/Discrete-Time Integrator'
   *  RelationalOperator: '<S12>/Relational Operator1'
   *  RelationalOperator: '<S12>/Relational Operator2'
   *  Sum: '<S12>/Add1'
   *  Sum: '<S12>/Add2'
   */
  rtb_LogicalOperator_h = ((G2Fdiag_B.BusInput.TrshPsetStat <= (real32_T)fabs
    (G2Fdiag_B.BusInput1.Pset_norm -
     G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_i)) || ((real32_T)fabs
    (G2Fdiag_B.BusInput1.Pset_norm - G2Fdiag_B.BusInput1.Pset_WR_norm) >
    G2Fdiag_B.BusInput.TrshPsetDev));

  /* Outputs for Atomic SubSystem: '<S12>/TOF' */
  G2Fdiag_TOF(rtb_LogicalOperator_h, rtb_DataTypeConversion2, &G2Fdiag_B.TOF_o,
              &G2Fdiag_DWork.TOF_o, inst);

  /* End of Outputs for SubSystem: '<S12>/TOF' */

  /* Logic: '<S12>/Logical Operator1' */
  rtb_LogicalOperator1_h = !G2Fdiag_B.TOF_o.LogicalOperator1;

  /* Update for DiscreteIntegrator: '<S41>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_gt = 0U;

  /* Saturate: '<S41>/Saturation' */
  if (!(rtb_TconstPsetStat >= 0.01F)) {
    rtb_TconstPsetStat = 0.01F;
  }

  /* Update for DiscreteIntegrator: '<S41>/Discrete-Time Integrator' incorporates:
   *  Product: '<S41>/Divide'
   *  Saturate: '<S41>/Saturation'
   *  Sum: '<S41>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_i +=
    (G2Fdiag_B.BusInput1.Pset_norm - rtb_DiscreteTimeIntegrator_m) /
    rtb_TconstPsetStat * 0.01F;
  if (rtb_bPTransDetReset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_ah = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_ah = 0;
  }

  /* End of Outputs for SubSystem: '<S5>/Power ramp detection' */

  /* BusSelector: '<S5>/Bus Selector17' */
  rtb_TexhSettledTConstLP = G2Fdiag_B.BusInput.TexhSettledTConstLP;
  rtb_TexhSettledTConstHP = G2Fdiag_B.BusInput.TexhSettledTConstHP;
  rtb_TexhSettledMaxTD = G2Fdiag_B.BusInput.TexhSettledMaxTD;

  /* Outputs for Atomic SubSystem: '<S13>/TON1' */
  G2Fdiag_TON(rtb_LogicalOperator1_h, rtb_TexhSettledMaxTD, &G2Fdiag_B.TON1,
              &G2Fdiag_DWork.TON1, inst);

  /* End of Outputs for SubSystem: '<S13>/TON1' */

  /* Switch: '<S13>/Switch' incorporates:
   *  Delay: '<S13>/Delay'
   */
  if (G2Fdiag_B.TON1.LogicalOperator3) {
    rtb_Switch_o = G2Fdiag_B.TON1.LogicalOperator3;
  } else {
    rtb_Switch_o = G2Fdiag_DWork.Delay_DSTATE;
  }

  /* End of Switch: '<S13>/Switch' */

  /* Switch: '<S5>/Switch' */
  if (G2Fdiag_B.BusInput1.bAllowDetInTrans) {
    rtb_LogicalOperator1_i = rtb_LogicalOperator1_h;
  } else {
    rtb_LogicalOperator1_i = rtb_Switch_o;
  }

  /* End of Switch: '<S5>/Switch' */

  /* Logic: '<S5>/Logical Operator1' incorporates:
   *  Logic: '<S5>/Logical Operator3'
   *  Logic: '<S5>/Logical Operator6'
   */
  rtb_LogicalOperator1_ld = (rtb_LogicalOperator5_d || (rtb_LogicalOperator2_l &&
    rtb_LogicalOperator1_i) || G2Fdiag_B.BusInput1.Man_Cond_On);

  /* Logic: '<S3>/Logical Operator4' incorporates:
   *  Logic: '<S3>/Logical Operator2'
   */
  rtb_LogicalOperator4 = ((!rtb_LogicalOperator1_ld) ||
    G2Fdiag_B.BusInput1.Reset);

  /* Logic: '<S5>/Logical Operator2' */
  rtb_LogicalOperator2_l = (rtb_LogicalOperator2_l &&
    G2Fdiag_B.TON.LogicalOperator3);

  /* Logic: '<S3>/Logical Operator3' incorporates:
   *  Logic: '<S3>/Logical Operator1'
   */
  rtb_LogicalOperator3_b = (G2Fdiag_B.BusInput1.Reset ||
    (!rtb_LogicalOperator2_l));

  /* BusSelector: '<S3>/Bus Selector2' */
  rtb_TConstLP = G2Fdiag_B.BusInput.TConstLP;
  rtb_DiscreteTimeIntegrator_m = G2Fdiag_B.BusInput.TConstHP;
  rtb_NCyl = G2Fdiag_B.BusInput.NCyl;

  /* Outputs for Atomic SubSystem: '<S3>/Fault Detection' */
  /* DataTypeConversion: '<S6>/Data Type Conversion1' */
  rtb_DataTypeConversion1 = G2Fdiag_B.BusInput.TPulseLambdaFault;

  /* DataTypeConversion: '<S6>/Data Type Conversion3' */
  rtb_DataTypeConversion3_j = G2Fdiag_B.BusInput.TPulseLambdaFault;

  /* UnitDelay: '<S66>/Delay Input1' */
  rtb_Uk1_od = G2Fdiag_DWork.DelayInput1_DSTATE_p;

  /* Product: '<S6>/Product' */
  rtb_Product = G2Fdiag_B.BusInput.FaultThrshLambda *
    G2Fdiag_B.BusInput.ThrshScale;

  /* Inport: '<S6>/Lambda_ss' */
  rtb_lambda_ss = G2Fdiag_B.BusInput1.Lambda_ss;

  /* Product: '<S6>/Product2' */
  rtb_Product2 = G2Fdiag_B.BusInput.ITPmeanScaling *
    G2Fdiag_B.BusInput1.rITPmean;

  /* DiscreteIntegrator: '<S74>/Discrete-Time Integrator' incorporates:
   *  Inport: '<S6>/Lambda_ss'
   */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_pk != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[0] = rtb_LambdaCmd;
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[1] =
      G2Fdiag_B.BusInput1.Lambda_ss;
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[2] = rtb_Product2;
  }

  if (rtb_LogicalOperator4 || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_d !=
       0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[0] = rtb_LambdaCmd;
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[1] =
      G2Fdiag_B.BusInput1.Lambda_ss;
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[2] = rtb_Product2;
  }

  rtb_DiscreteTimeIntegrator_b_id =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[0];
  rtb_DiscreteTimeIntegrator_b__0 =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[1];
  rtb_DiscreteTimeIntegrator_b__1 =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[2];

  /* DiscreteIntegrator: '<S87>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S74>/Discrete-Time Integrator'
   */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_c0 != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[0] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[0];
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[1] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[1];
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[2] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[2];
  }

  if (rtb_LogicalOperator4 || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_do !=
       0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[0] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[0];
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[1] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[1];
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[2] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[2];
  }

  rtb_DiscreteTimeIntegrator_g_id =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[0];
  rtb_DiscreteTimeIntegrator_g__0 =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[1];
  rtb_DiscreteTimeIntegrator_g__1 =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[2];

  /* Gain: '<S6>/Gain1' incorporates:
   *  DiscreteIntegrator: '<S74>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S87>/Discrete-Time Integrator'
   *  Sum: '<S72>/Add'
   */
  rtb_Gain1_idx = -(G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[0] -
                    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[0]);
  rtb_TconstPsetStat = -(G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[2] -
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[2]);

  /* Saturate: '<S6>/Saturation' */
  if (!(rtb_TconstPsetStat >= 0.0F)) {
    rtb_TconstPsetStat = 0.0F;
  }

  /* Sum: '<S6>/Sum4' incorporates:
   *  Saturate: '<S6>/Saturation'
   */
  rtb_Sum4 = rtb_Gain1_idx - rtb_TconstPsetStat;

  /* Switch: '<S6>/Switch' incorporates:
   *  Constant: '<S6>/Constant'
   *  DiscreteIntegrator: '<S74>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S87>/Discrete-Time Integrator'
   *  Gain: '<S6>/Gain1'
   *  Sum: '<S72>/Add'
   */
  if (G2Fdiag_B.BusInput1.bAllowDetInTrans) {
    rtb_lambdaEst_HP = -(G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[1] -
                         G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[1]);
  } else {
    rtb_lambdaEst_HP = 0.0F;
  }

  /* End of Switch: '<S6>/Switch' */

  /* Sum: '<S6>/Sum1' */
  rtb_Sum1 = rtb_Sum4 - rtb_lambdaEst_HP;

  /* RelationalOperator: '<S6>/Relational Operator3' */
  rtb_lambdaFault = (rtb_Product <= rtb_Sum1);

  /* Outputs for Atomic SubSystem: '<S6>/TP' */
  G2Fdiag_TP(rtb_lambdaFault, rtb_DataTypeConversion3_j, &G2Fdiag_B.TP,
             &G2Fdiag_DWork.TP, inst);

  /* End of Outputs for SubSystem: '<S6>/TP' */

  /* Logic: '<S6>/Logical Operator' */
  rtb_lambdaFaultTOF = (rtb_lambdaFault || G2Fdiag_B.TP.LogicalOperator1);

  /* RelationalOperator: '<S66>/FixPt Relational Operator' */
  rtb_LogicalOperator1_i = ((int32_T)rtb_lambdaFaultTOF > (int32_T)rtb_Uk1_od);

  /* UnitDelay: '<S67>/Delay Input1' */
  rtb_Uk1_od = G2Fdiag_DWork.DelayInput1_DSTATE_p3;

  /* DiscreteIntegrator: '<S75>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_j != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[0] = rtb_LambdaCmd;
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[1] = rtb_lambda_ss;
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[2] = rtb_Product2;
  }

  if (rtb_LogicalOperator3_b || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_m
       != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[0] = rtb_LambdaCmd;
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[1] = rtb_lambda_ss;
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[2] = rtb_Product2;
  }

  rtb_DiscreteTimeIntegrator_gp_i =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[0];
  rtb_DiscreteTimeIntegrator_gp_0 =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[1];
  rtb_DiscreteTimeIntegrator_gp_1 =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[2];

  /* DiscreteIntegrator: '<S88>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S75>/Discrete-Time Integrator'
   */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_e != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[0] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[0];
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[1] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[1];
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[2] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[2];
  }

  if (rtb_LogicalOperator3_b || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_a
       != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[0] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[0];
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[1] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[1];
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[2] =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[2];
  }

  rtb_DiscreteTimeIntegrator_ht_i =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[0];
  rtb_DiscreteTimeIntegrator_ht_0 =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[1];
  rtb_DiscreteTimeIntegrator_ht_1 =
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[2];

  /* Gain: '<S6>/Gain2' incorporates:
   *  DiscreteIntegrator: '<S75>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S88>/Discrete-Time Integrator'
   *  Sum: '<S73>/Add'
   */
  rtb_Sum_o_idx = -(G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[2] -
                    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[2]);

  /* Saturate: '<S6>/Saturation2' */
  if (!(rtb_Sum_o_idx >= 0.0F)) {
    rtb_Sum_o_idx = 0.0F;
  }

  /* RelationalOperator: '<S6>/Relational Operator1' incorporates:
   *  DiscreteIntegrator: '<S75>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S88>/Discrete-Time Integrator'
   *  Gain: '<S6>/Gain2'
   *  Saturate: '<S6>/Saturation2'
   *  Sum: '<S6>/Sum2'
   *  Sum: '<S6>/Sum3'
   *  Sum: '<S73>/Add'
   */
  rtb_RelationalOperator1_m = (rtb_Product <=
    (-(G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[0] -
       G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[0]) - rtb_Sum_o_idx) -
    (-(G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[1] -
       G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[1])));

  /* Outputs for Atomic SubSystem: '<S6>/TP1' */
  G2Fdiag_TP(rtb_RelationalOperator1_m, rtb_DataTypeConversion1, &G2Fdiag_B.TP1,
             &G2Fdiag_DWork.TP1, inst);

  /* End of Outputs for SubSystem: '<S6>/TP1' */

  /* Logic: '<S6>/Logical Operator1' */
  rtb_LogicalOperator1_f = (rtb_RelationalOperator1_m ||
    G2Fdiag_B.TP1.LogicalOperator1);

  /* Product: '<S6>/Product1' */
  rtb_Product1 = G2Fdiag_B.BusInput.ThrshScale *
    G2Fdiag_B.BusInput.DeltaTexhAllowed;

  /* Saturate: '<S6>/Saturation1' */
  if (rtb_NCyl >= 24) {
    rtb_NCyl = 24;
  } else {
    if (rtb_NCyl <= 1) {
      rtb_NCyl = 1;
    }
  }

  /* End of Saturate: '<S6>/Saturation1' */

  /* MATLAB Function: '<S6>/vector to scalar (mean, etc.)' */
  /* MATLAB Function 'GEN2_Friction_Detection/Fault Detection/vector to scalar (mean, etc.)': '<S76>:1' */
  /* '<S76>:1:4' */
  rtb_TconstPsetStat = 0.0F;

  /* '<S76>:1:6' */
  rtb_Sum_o_idx = 0.0F;

  /* '<S76>:1:8' */
  N_plausible = 0.0;

  /* '<S76>:1:10' */
  for (i = 0; i + 1 <= rtb_NCyl; i++) {
    /* '<S76>:1:10' */
    /* '<S76>:1:11' */
    /*  check if temperature is plausible (not sensor fault) */
    if ((G2Fdiag_B.BusInput1.Texh[i] > G2Fdiag_B.BusInput.TexhPlausibleMin) &&
        (G2Fdiag_B.BusInput1.Texh[i] < G2Fdiag_B.BusInput.TexhPlausibleMax)) {
      /* '<S76>:1:14' */
      /* '<S76>:1:15' */
      rtb_TconstPsetStat += G2Fdiag_B.BusInput1.Texh[i];
      if (rtb_Sum_o_idx == 0.0F) {
        /* '<S76>:1:17' */
        /*  first iteration */
        /* '<S76>:1:18' */
        rtb_Sum_o_idx = G2Fdiag_B.BusInput1.Texh[i];
      } else {
        if (G2Fdiag_B.BusInput1.Texh[i] < rtb_Sum_o_idx) {
          /* '<S76>:1:20' */
          /* '<S76>:1:21' */
          rtb_Sum_o_idx = G2Fdiag_B.BusInput1.Texh[i];
        }
      }

      /* '<S76>:1:25' */
      N_plausible++;
    }
  }

  if (N_plausible > 0.0) {
    /* '<S76>:1:29' */
    /* '<S76>:1:30' */
    rtb_u_mean = rtb_TconstPsetStat / (real32_T)N_plausible;
  } else {
    /*  no plausible signal found */
    /* '<S76>:1:32' */
    rtb_u_mean = 0.0F;
  }

  if (rtb_Sum_o_idx == 0.0F) {
    /* '<S76>:1:35' */
    /*  no plausible signal found */
    /* '<S76>:1:36' */
    rtb_Sum_o_idx = 0.0F;
  } else {
    /* '<S76>:1:38' */
  }

  /* End of MATLAB Function: '<S6>/vector to scalar (mean, etc.)' */

  /* MATLAB Function: '<S6>/detection logic' */
  /* MATLAB Function 'GEN2_Friction_Detection/Fault Detection/detection logic': '<S70>:1' */
  if (!G2Fdiag_DWork.Texh_scalar_1_not_empty_d) {
    /* '<S70>:1:7' */
    /* '<S70>:1:8' */
    G2Fdiag_DWork.Texh_scalar_1_f = rtb_u_mean;
    G2Fdiag_DWork.Texh_scalar_1_not_empty_d = TRUE;

    /* '<S70>:1:9' */
    G2Fdiag_DWork.Texh_min_1_p = rtb_Sum_o_idx;
  }

  if (rtb_LogicalOperator1_i) {
    /* '<S70>:1:13' */
    /*  save the temperature when the lambda fault is detected */
    /* '<S70>:1:15' */
    G2Fdiag_DWork.Texh_scalar_1_f = rtb_u_mean;

    /* '<S70>:1:16' */
    G2Fdiag_DWork.Texh_min_1_p = rtb_Sum_o_idx;
  }

  if (rtb_lambdaFaultTOF) {
    /* '<S70>:1:19' */
    /*  once a certain temperature rise is detected do further */
    /*  evaluation */
    if (G2Fdiag_DWork.Texh_scalar_1_f + rtb_Product1 < rtb_u_mean) {
      /* '<S70>:1:25' */
      if (G2Fdiag_DWork.Texh_min_1_p - rtb_Product1 < rtb_Sum_o_idx) {
        /* '<S70>:1:26' */
        /*  only detect a fault if the minimum temperature has not fallen */
        /*  -> distinguish from misfire! */
        /* '<S70>:1:29' */
        rtb_bFault_b = TRUE;
      } else {
        /* '<S70>:1:31' */
        rtb_bFault_b = FALSE;
      }
    } else {
      /* '<S70>:1:34' */
      rtb_bFault_b = FALSE;
    }
  } else {
    /* '<S70>:1:37' */
    rtb_bFault_b = FALSE;
  }

  /* End of MATLAB Function: '<S6>/detection logic' */

  /* MATLAB Function: '<S6>/detection logic1' incorporates:
   *  RelationalOperator: '<S67>/FixPt Relational Operator'
   */
  /* MATLAB Function 'GEN2_Friction_Detection/Fault Detection/detection logic1': '<S71>:1' */
  if (!G2Fdiag_DWork.Texh_scalar_1_not_empty) {
    /* '<S71>:1:7' */
    /* '<S71>:1:8' */
    G2Fdiag_DWork.Texh_scalar_1 = rtb_u_mean;
    G2Fdiag_DWork.Texh_scalar_1_not_empty = TRUE;

    /* '<S71>:1:9' */
    G2Fdiag_DWork.Texh_min_1 = rtb_Sum_o_idx;
  }

  if ((int32_T)rtb_LogicalOperator1_f > (int32_T)rtb_Uk1_od) {
    /* '<S71>:1:13' */
    /*  save the temperature when the lambda fault is detected */
    /* '<S71>:1:15' */
    G2Fdiag_DWork.Texh_scalar_1 = rtb_u_mean;

    /* '<S71>:1:16' */
    G2Fdiag_DWork.Texh_min_1 = rtb_Sum_o_idx;
  }

  if (rtb_LogicalOperator1_f) {
    /* '<S71>:1:19' */
    /*  once a certain temperature rise is detected do further */
    /*  evaluation */
    if (G2Fdiag_DWork.Texh_scalar_1 + rtb_Product1 < rtb_u_mean) {
      /* '<S71>:1:25' */
      if (G2Fdiag_DWork.Texh_min_1 - rtb_Product1 < rtb_Sum_o_idx) {
        /* '<S71>:1:26' */
        /*  only detect a fault if the minimum temperature has not fallen */
        /*  -> distinguish from misfire! */
        /* '<S71>:1:29' */
        rtb_LogicalOperator1_i = TRUE;
      } else {
        /* '<S71>:1:31' */
        rtb_LogicalOperator1_i = FALSE;
      }
    } else {
      /* '<S71>:1:34' */
      rtb_LogicalOperator1_i = FALSE;
    }
  } else {
    /* '<S71>:1:37' */
    rtb_LogicalOperator1_i = FALSE;
  }

  /* End of MATLAB Function: '<S6>/detection logic1' */

  /* Saturate: '<S87>/Saturation' incorporates:
   *  Saturate: '<S88>/Saturation'
   */
  if (rtb_DiscreteTimeIntegrator_m >= 0.01F) {
    rtb_Saturation_c2 = rtb_DiscreteTimeIntegrator_m;
  } else {
    rtb_Saturation_c2 = 0.01F;
    rtb_DiscreteTimeIntegrator_m = 0.01F;
  }

  /* End of Saturate: '<S87>/Saturation' */

  /* Saturate: '<S74>/Saturation' incorporates:
   *  Saturate: '<S75>/Saturation'
   */
  if (rtb_TConstLP >= 0.01F) {
    rtb_Saturation_mc = rtb_TConstLP;
    rtb_TconstPsetStat = rtb_TConstLP;
  } else {
    rtb_Saturation_mc = 0.01F;
    rtb_TconstPsetStat = 0.01F;
  }

  /* End of Saturate: '<S74>/Saturation' */

  /* Update for UnitDelay: '<S66>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE_p = rtb_lambdaFaultTOF;

  /* Update for DiscreteIntegrator: '<S74>/Discrete-Time Integrator' incorporates:
   *  Product: '<S74>/Divide'
   *  Sum: '<S74>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_pk = 0U;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[0] += (rtb_LambdaCmd -
    rtb_DiscreteTimeIntegrator_b_id) / rtb_Saturation_mc * 0.01F;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[1] += (rtb_lambda_ss -
    rtb_DiscreteTimeIntegrator_b__0) / rtb_Saturation_mc * 0.01F;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_o[2] += (rtb_Product2 -
    rtb_DiscreteTimeIntegrator_b__1) / rtb_Saturation_mc * 0.01F;
  if (rtb_LogicalOperator4) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_d = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_d = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S74>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S87>/Discrete-Time Integrator' incorporates:
   *  Product: '<S87>/Divide'
   *  Sum: '<S87>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_c0 = 0U;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[0] +=
    (rtb_DiscreteTimeIntegrator_b_id - rtb_DiscreteTimeIntegrator_g_id) /
    rtb_Saturation_c2 * 0.01F;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[1] +=
    (rtb_DiscreteTimeIntegrator_b__0 - rtb_DiscreteTimeIntegrator_g__0) /
    rtb_Saturation_c2 * 0.01F;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_jn[2] +=
    (rtb_DiscreteTimeIntegrator_b__1 - rtb_DiscreteTimeIntegrator_g__1) /
    rtb_Saturation_c2 * 0.01F;
  if (rtb_LogicalOperator4) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_do = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_do = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S87>/Discrete-Time Integrator' */

  /* Update for UnitDelay: '<S67>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE_p3 = rtb_LogicalOperator1_f;

  /* Update for DiscreteIntegrator: '<S75>/Discrete-Time Integrator' incorporates:
   *  Product: '<S75>/Divide'
   *  Sum: '<S75>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_j = 0U;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[0] += (rtb_LambdaCmd -
    rtb_DiscreteTimeIntegrator_gp_i) / rtb_TconstPsetStat * 0.01F;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[1] += (rtb_lambda_ss -
    rtb_DiscreteTimeIntegrator_gp_0) / rtb_TconstPsetStat * 0.01F;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_a[2] += (rtb_Product2 -
    rtb_DiscreteTimeIntegrator_gp_1) / rtb_TconstPsetStat * 0.01F;
  if (rtb_LogicalOperator3_b) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_m = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_m = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S75>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S88>/Discrete-Time Integrator' incorporates:
   *  Product: '<S88>/Divide'
   *  Sum: '<S88>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_e = 0U;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[0] +=
    (rtb_DiscreteTimeIntegrator_gp_i - rtb_DiscreteTimeIntegrator_ht_i) /
    rtb_DiscreteTimeIntegrator_m * 0.01F;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[1] +=
    (rtb_DiscreteTimeIntegrator_gp_0 - rtb_DiscreteTimeIntegrator_ht_0) /
    rtb_DiscreteTimeIntegrator_m * 0.01F;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_d[2] +=
    (rtb_DiscreteTimeIntegrator_gp_1 - rtb_DiscreteTimeIntegrator_ht_1) /
    rtb_DiscreteTimeIntegrator_m * 0.01F;
  if (rtb_LogicalOperator3_b) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_a = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_a = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S88>/Discrete-Time Integrator' */
  /* End of Outputs for SubSystem: '<S3>/Fault Detection' */

  /* BusCreator: '<S3>/Bus Creator1' incorporates:
   *  Logic: '<S3>/Logical Operator'
   *  Logic: '<S3>/Logical Operator5'
   *  Logic: '<S3>/Logical Operator6'
   *  Logic: '<S5>/Logical Operator7'
   *  Logic: '<S5>/Logical Operator8'
   */
  G2Fdiag_Y.OUT.FrictionFault = (rtb_bFault_b && rtb_LogicalOperator1_ld);
  G2Fdiag_Y.OUT.FrictionFaultInTransient = (rtb_LogicalOperator1_i &&
    (!G2Fdiag_B.BusInput1.bAllowDetInTrans) && (rtb_LogicalOperator2_l &&
    (!rtb_Switch_o)) && G2Fdiag_B.BusInput1.bFileOnlyInTrans);

  /* SignalConversion: '<S5>/TmpSignal ConversionAtSum of ElementsInport1' incorporates:
   *  Product: '<S5>/Product'
   *  Product: '<S5>/Product1'
   *  Product: '<S5>/Product10'
   *  Product: '<S5>/Product11'
   *  Product: '<S5>/Product2'
   *  Product: '<S5>/Product3'
   *  Product: '<S5>/Product4'
   *  Product: '<S5>/Product5'
   *  Product: '<S5>/Product6'
   *  Product: '<S5>/Product7'
   *  Product: '<S5>/Product8'
   *  Product: '<S5>/Product9'
   */
  rtb_TmpSignalConversionAtSumofE[0] = (int16_T)rtb_LogicalOperator1_ld;
  rtb_TmpSignalConversionAtSumofE[1] = (int16_T)((int32_T)rtb_LogicalOperator5_d
    << 1);
  rtb_TmpSignalConversionAtSumofE[2] = (int16_T)((int32_T)
    G2Fdiag_B.TON.LogicalOperator3 << 2);
  rtb_TmpSignalConversionAtSumofE[3] = (int16_T)((int32_T)
    G2Fdiag_B.TON_n.LogicalOperator3 << 3);
  rtb_TmpSignalConversionAtSumofE[4] = (int16_T)((int32_T)rtb_LogicalOperator1_h
    << 4);
  rtb_TmpSignalConversionAtSumofE[5] = (int16_T)((int32_T)
    rtb_LogicalOperator1_ie << 5);
  rtb_TmpSignalConversionAtSumofE[6] = (int16_T)((int32_T)
    G2Fdiag_B.TON_i.LogicalOperator3 << 6);
  rtb_TmpSignalConversionAtSumofE[7] = (int16_T)((int32_T)
    G2Fdiag_B.TON_k.LogicalOperator3 << 7);
  rtb_TmpSignalConversionAtSumofE[8] = (int16_T)((int32_T)rtb_LogicalOperator1_l
    << 8);
  rtb_TmpSignalConversionAtSumofE[9] = (int16_T)((int32_T)
    rtb_LogicalOperator1_du << 9);
  rtb_TmpSignalConversionAtSumofE[10] = (int16_T)((int32_T)rtb_Switch_o << 10);
  rtb_TmpSignalConversionAtSumofE[11] = (int16_T)((int32_T)rtb_Switch << 11);

  /* Sum: '<S5>/Sum of Elements' incorporates:
   *  Product: '<S5>/Product'
   */
  rtb_NCyl = (int16_T)rtb_LogicalOperator1_ld;
  for (i = 0; i < 11; i++) {
    rtb_NCyl += rtb_TmpSignalConversionAtSumofE[i + 1];
  }

  /* End of Sum: '<S5>/Sum of Elements' */

  /* BusCreator: '<S3>/Bus Creator' incorporates:
   *  BusCreator: '<S5>/Bus Creator1'
   *  Gain: '<S10>/Gain'
   */
  G2Fdiag_Y.dbg.LambdaCmd = rtb_LambdaCmd;
  G2Fdiag_Y.dbg.y_f = rtb_DiscreteTimeIntegrator_g_id;
  G2Fdiag_Y.dbg.Residual = rtb_Sum1;
  G2Fdiag_Y.dbg.Thrsh = rtb_Product;
  G2Fdiag_Y.dbg.DiagActive = rtb_LogicalOperator1_ld;
  G2Fdiag_Y.dbg.FaultLambdaOnly = rtb_lambdaFaultTOF;
  G2Fdiag_Y.dbg.ResLambdaOnly = rtb_Gain1_idx;
  G2Fdiag_Y.dbg.ResLambdaITP = rtb_Sum4;
  G2Fdiag_Y.dbg.ResLambdaEst = rtb_lambdaEst_HP;
  G2Fdiag_Y.dbg.LambdaEst = rtb_lambda_ss;
  G2Fdiag_Y.dbg.LEANOXErr = -rtb_DiscreteTimeIntegrator_j;
  G2Fdiag_Y.dbg.TexhAvg = rtb_u_mean;
  G2Fdiag_Y.dbg.TexhMin = rtb_Sum_o_idx;
  G2Fdiag_Y.dbg.GasMixing_RatioHP = rtb_DiscreteTimeIntegrator_i;
  G2Fdiag_Y.dbg.DeltaTexhAllowed = rtb_Product1;
  G2Fdiag_Y.dbg.tDiagActiveBus.DiagOn = rtb_LogicalOperator1_ld;
  G2Fdiag_Y.dbg.tDiagActiveBus.DiagOnInTransient = rtb_LogicalOperator5_d;
  G2Fdiag_Y.dbg.tDiagActiveBus.LEANOXErrSettled = G2Fdiag_B.TON.LogicalOperator3;
  G2Fdiag_Y.dbg.tDiagActiveBus.NoTooStrongWGMove =
    G2Fdiag_B.TON_n.LogicalOperator3;
  G2Fdiag_Y.dbg.tDiagActiveBus.NoTransient = rtb_LogicalOperator1_h;
  G2Fdiag_Y.dbg.tDiagActiveBus.NoExtDist = rtb_LogicalOperator1_ie;
  G2Fdiag_Y.dbg.tDiagActiveBus.NoVoltTrans = G2Fdiag_B.TON_i.LogicalOperator3;
  G2Fdiag_Y.dbg.tDiagActiveBus.GCBMCBsettled = G2Fdiag_B.TON_k.LogicalOperator3;
  G2Fdiag_Y.dbg.tDiagActiveBus.GridP = rtb_LogicalOperator1_l;
  G2Fdiag_Y.dbg.tDiagActiveBus.DiagBitmask = rtb_NCyl;
  G2Fdiag_Y.dbg.tDiagActiveBus.NoMinLoad = rtb_LogicalOperator1_du;
  G2Fdiag_Y.dbg.tDiagActiveBus.TexhSettledAfterRamp = rtb_Switch_o;
  G2Fdiag_Y.dbg.tDiagActiveBus.NoGasMixingTrans = rtb_Switch;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Out = G2Fdiag_Y.OUT;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->dbgOut = G2Fdiag_Y.dbg;

  /* BusSelector: '<S5>/Bus Selector16' */
  rtb_bTexhSettled_reset = G2Fdiag_B.BusInput1.bTexhSettled_reset;

  /* Sum: '<S31>/Sum' */
  rtb_Sum_o_idx = G2Fdiag_B.BusInput1.rGasMixing_Ratio -
    rtb_DiscreteTimeIntegrator;

  /* DiscreteIntegrator: '<S48>/Discrete-Time Integrator' */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_ps != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_j = rtb_u_mean;
  }

  if (rtb_bTexhSettled_reset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_ji
       != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_j = rtb_u_mean;
  }

  rtb_Sum1 = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_j;

  /* DiscreteIntegrator: '<S54>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S48>/Discrete-Time Integrator'
   */
  if (G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_h != 0) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_n =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_j;
  }

  if (rtb_bTexhSettled_reset || (G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_nv
       != 0)) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_n =
      G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_j;
  }

  rtb_DiscreteTimeIntegrator_i = G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_n;

  /* RelationalOperator: '<S50>/Compare' incorporates:
   *  Constant: '<S50>/Constant'
   */
  rtb_bFault_b = !rtb_LogicalOperator1_h;

  /* RelationalOperator: '<S43>/FixPt Relational Operator' incorporates:
   *  UnitDelay: '<S43>/Delay Input1'
   */
  rtb_LogicalOperator1_i = ((int32_T)rtb_bFault_b > (int32_T)
    G2Fdiag_DWork.DelayInput1_DSTATE_i);

  /* RelationalOperator: '<S51>/Compare' incorporates:
   *  Constant: '<S51>/Constant'
   */
  rtb_Switch = rtb_LogicalOperator1_h;

  /* RelationalOperator: '<S44>/FixPt Relational Operator' incorporates:
   *  Constant: '<S51>/Constant'
   *  RelationalOperator: '<S51>/Compare'
   *  UnitDelay: '<S44>/Delay Input1'
   */
  rtb_Uk1_od = ((int32_T)rtb_LogicalOperator1_h > (int32_T)
                G2Fdiag_DWork.DelayInput1_DSTATE_n);

  /* RelationalOperator: '<S13>/Relational Operator1' incorporates:
   *  Abs: '<S13>/Abs1'
   *  DiscreteIntegrator: '<S48>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S54>/Discrete-Time Integrator'
   *  Sum: '<S49>/Add'
   */
  rtb_Texh_avg_settled = (G2Fdiag_B.BusInput.TexhSettledThrsh >= (real32_T)fabs
    (G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_j -
     G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_n));

  /* Outputs for Atomic SubSystem: '<S13>/TON' */
  G2Fdiag_TON(rtb_Texh_avg_settled, rtb_TexhSettledTConstLP, &G2Fdiag_B.TON_e,
              &G2Fdiag_DWork.TON_e, inst);

  /* End of Outputs for SubSystem: '<S13>/TON' */

  /* MATLAB Function: '<S13>/MATLAB Function' */
  /* MATLAB Function 'GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/MATLAB Function': '<S45>:1' */
  if (rtb_Uk1_od) {
    /* '<S45>:1:12' */
    /* '<S45>:1:13' */
    G2Fdiag_DWork.bSettlingPhase = TRUE;
  }

  if (G2Fdiag_DWork.bSettlingPhase && G2Fdiag_B.TON_e.LogicalOperator3) {
    /* '<S45>:1:16' */
    /* '<S45>:1:17' */
    G2Fdiag_DWork.TexhSettledAfterRamp_persistent = TRUE;
  }

  if (rtb_LogicalOperator1_i) {
    /* '<S45>:1:20' */
    /* '<S45>:1:21' */
    G2Fdiag_DWork.TexhSettledAfterRamp_persistent = FALSE;

    /* '<S45>:1:22' */
    G2Fdiag_DWork.bSettlingPhase = FALSE;
  }

  /* '<S45>:1:26' */
  rtb_LogicalOperator1_i = G2Fdiag_DWork.TexhSettledAfterRamp_persistent;

  /* out = [TexhSettledAfterRamp bSettlingPhase]; */
  if (G2Fdiag_DWork.TexhSettledAfterRamp_persistent) {
    /* '<S45>:1:26' */
    /* '<S45>:1:32' */
    G2Fdiag_DWork.bSettlingPhase = FALSE;
  }

  /* End of MATLAB Function: '<S13>/MATLAB Function' */

  /* Saturate: '<S48>/Saturation' */
  if (rtb_TexhSettledTConstLP >= 0.01F) {
    rtb_Product1 = rtb_TexhSettledTConstLP;
  } else {
    rtb_Product1 = 0.01F;
  }

  /* End of Saturate: '<S48>/Saturation' */

  /* Sum: '<S60>/Sum' */
  rtb_lambda_ss = G2Fdiag_B.BusInput1.U_L1L2_norm -
    rtb_DiscreteTimeIntegrator_hq;

  /* Sum: '<S61>/Sum' */
  rtb_Saturation_c2 = G2Fdiag_B.BusInput1.U_L2L3_norm -
    rtb_DiscreteTimeIntegrator_p;

  /* Sum: '<S62>/Sum' */
  rtb_TConstLP = G2Fdiag_B.BusInput1.U_L3L1_norm - rtb_DiscreteTimeIntegrator_k;

  /* Sum: '<S64>/Sum' */
  rtb_DiscreteTimeIntegrator_m = G2Fdiag_B.BusInput1.posWG_norm -
    rtb_DiscreteTimeIntegrator_go;

  /* UnitDelay: '<S4>/Unit Delay' */
  G2Fdiag_B.UnitDelay = G2Fdiag_DWork.UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output8' */
  inst->Info = G2Fdiag_B.UnitDelay;

  /* Update for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Saturate: '<S36>/Saturation' */
  if (!(rtb_LEANOXErrorTconst >= 0.01F)) {
    rtb_LEANOXErrorTconst = 0.01F;
  }

  /* End of Saturate: '<S36>/Saturation' */

  /* Update for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' incorporates:
   *  Product: '<S36>/Divide'
   *  Sum: '<S36>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE += (rtb_Sum -
    rtb_DiscreteTimeIntegrator_j) / rtb_LEANOXErrorTconst * 0.01F;
  if (rtb_LEANOXErrorFiltReset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* Update for DiscreteIntegrator: '<S64>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_c = 0U;

  /* Saturate: '<S64>/Saturation' */
  if (!(rtb_WGM_Tconst >= 0.01F)) {
    rtb_WGM_Tconst = 0.01F;
  }

  /* End of Saturate: '<S64>/Saturation' */

  /* Update for DiscreteIntegrator: '<S64>/Discrete-Time Integrator' incorporates:
   *  Product: '<S64>/Divide'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_k += rtb_DiscreteTimeIntegrator_m /
    rtb_WGM_Tconst * 0.01F;
  if (rtb_WGM_reset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_e = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_e = 0;
  }

  /* Update for DiscreteIntegrator: '<S60>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_b = 0U;

  /* Saturate: '<S60>/Saturation' */
  if (rtb_Vltg_Tconst >= 0.01F) {
    rtb_TconstPsetStat = rtb_Vltg_Tconst;
  } else {
    rtb_TconstPsetStat = 0.01F;
  }

  /* End of Saturate: '<S60>/Saturation' */

  /* Update for DiscreteIntegrator: '<S60>/Discrete-Time Integrator' incorporates:
   *  Product: '<S60>/Divide'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_h += rtb_lambda_ss /
    rtb_TconstPsetStat * 0.01F;
  if (rtb_bVltg_reset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_j = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_j = 0;
  }

  /* Update for DiscreteIntegrator: '<S61>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_g = 0U;

  /* Saturate: '<S61>/Saturation' */
  if (rtb_Vltg_Tconst >= 0.01F) {
    rtb_TconstPsetStat = rtb_Vltg_Tconst;
  } else {
    rtb_TconstPsetStat = 0.01F;
  }

  /* End of Saturate: '<S61>/Saturation' */

  /* Update for DiscreteIntegrator: '<S61>/Discrete-Time Integrator' incorporates:
   *  Product: '<S61>/Divide'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_c += rtb_Saturation_c2 /
    rtb_TconstPsetStat * 0.01F;
  if (rtb_bVltg_reset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_f = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_f = 0;
  }

  /* Update for DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_p = 0U;

  /* Saturate: '<S62>/Saturation' */
  if (!(rtb_Vltg_Tconst >= 0.01F)) {
    rtb_Vltg_Tconst = 0.01F;
  }

  /* End of Saturate: '<S62>/Saturation' */

  /* Update for DiscreteIntegrator: '<S62>/Discrete-Time Integrator' incorporates:
   *  Product: '<S62>/Divide'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_p += rtb_TConstLP /
    rtb_Vltg_Tconst * 0.01F;
  if (rtb_bVltg_reset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_p = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_p = 0;
  }

  /* Update for UnitDelay: '<S26>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE = rtb_Compare;

  /* Update for UnitDelay: '<S25>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE_e = rtb_Compare_h;

  /* Update for UnitDelay: '<S22>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE_m = rtb_Compare_c;

  /* Update for UnitDelay: '<S21>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE_l = rtb_Compare_e;

  /* Update for DiscreteIntegrator: '<S31>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_o = 0U;

  /* Saturate: '<S31>/Saturation' */
  if (!(rtb_GasMixingTconstLP >= 0.01F)) {
    rtb_GasMixingTconstLP = 0.01F;
  }

  /* End of Saturate: '<S31>/Saturation' */

  /* Update for DiscreteIntegrator: '<S31>/Discrete-Time Integrator' incorporates:
   *  Product: '<S31>/Divide'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_e += rtb_Sum_o_idx /
    rtb_GasMixingTconstLP * 0.01F;
  if (rtb_bGasMixing_reset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_jm = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_jm = 0;
  }

  /* Update for DiscreteIntegrator: '<S34>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_cl = 0U;

  /* Saturate: '<S34>/Saturation' */
  if (!(rtb_GasMixingTconstHP >= 0.01F)) {
    rtb_GasMixingTconstHP = 0.01F;
  }

  /* End of Saturate: '<S34>/Saturation' */

  /* Update for DiscreteIntegrator: '<S34>/Discrete-Time Integrator' incorporates:
   *  Product: '<S34>/Divide'
   *  Sum: '<S34>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTAT_hv += (rtb_DiscreteTimeIntegrator -
    rtb_HP_filtered) / rtb_GasMixingTconstHP * 0.01F;
  if (rtb_bGasMixing_reset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_n = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevRe_n = 0;
  }

  /* Update for Delay: '<S13>/Delay' */
  G2Fdiag_DWork.Delay_DSTATE = rtb_LogicalOperator1_i;

  /* Update for DiscreteIntegrator: '<S48>/Discrete-Time Integrator' incorporates:
   *  Product: '<S48>/Divide'
   *  Sum: '<S48>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_ps = 0U;
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_j += (rtb_u_mean - rtb_Sum1) /
    rtb_Product1 * 0.01F;
  if (rtb_bTexhSettled_reset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_ji = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_ji = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S48>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S54>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_h = 0U;

  /* Saturate: '<S54>/Saturation' */
  if (!(rtb_TexhSettledTConstHP >= 0.01F)) {
    rtb_TexhSettledTConstHP = 0.01F;
  }

  /* End of Saturate: '<S54>/Saturation' */

  /* Update for DiscreteIntegrator: '<S54>/Discrete-Time Integrator' incorporates:
   *  Product: '<S54>/Divide'
   *  Sum: '<S54>/Sum'
   */
  G2Fdiag_DWork.DiscreteTimeIntegrator_DSTATE_n += (rtb_Sum1 -
    rtb_DiscreteTimeIntegrator_i) / rtb_TexhSettledTConstHP * 0.01F;
  if (rtb_bTexhSettled_reset) {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_nv = 1;
  } else {
    G2Fdiag_DWork.DiscreteTimeIntegrator_PrevR_nv = 0;
  }

  /* Update for UnitDelay: '<S43>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE_i = rtb_bFault_b;

  /* Update for UnitDelay: '<S44>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE_n = rtb_Switch;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  G2Fdiag_DWork.UnitDelay_DSTATE = 41U;
}

/* Model initialize function */
void G2Fdiag_initialize(struct fGEN2diag* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S7>/TOF' */
  G2Fdiag_TOF_Init(&G2Fdiag_DWork.TOF, inst);

  /* End of InitializeConditions for SubSystem: '<S7>/TOF' */

  /* InitializeConditions for DiscreteIntegrator: '<S64>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_c = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S60>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_b = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S61>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_g = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_p = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S5>/Min Load Detection' */

  /* InitializeConditions for Atomic SubSystem: '<S11>/TOF' */
  G2Fdiag_TOF_Init(&G2Fdiag_DWork.TOF_h, inst);

  /* End of InitializeConditions for SubSystem: '<S11>/TOF' */

  /* End of InitializeConditions for SubSystem: '<S5>/Min Load Detection' */

  /* InitializeConditions for DiscreteIntegrator: '<S31>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_o = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S34>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_cl = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S5>/Power ramp detection' */
  /* InitializeConditions for DiscreteIntegrator: '<S41>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_gt = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S12>/TOF' */
  G2Fdiag_TOF_Init(&G2Fdiag_DWork.TOF_o, inst);

  /* End of InitializeConditions for SubSystem: '<S12>/TOF' */

  /* End of InitializeConditions for SubSystem: '<S5>/Power ramp detection' */

  /* InitializeConditions for Atomic SubSystem: '<S3>/Fault Detection' */
  /* InitializeConditions for DiscreteIntegrator: '<S74>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_pk = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S87>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_c0 = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S6>/TP' */
  G2Fdiag_TP_Init(&G2Fdiag_DWork.TP, inst);

  /* End of InitializeConditions for SubSystem: '<S6>/TP' */

  /* InitializeConditions for DiscreteIntegrator: '<S75>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_j = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S88>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_e = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S6>/TP1' */
  G2Fdiag_TP_Init(&G2Fdiag_DWork.TP1, inst);

  /* End of InitializeConditions for SubSystem: '<S6>/TP1' */

  /* End of InitializeConditions for SubSystem: '<S3>/Fault Detection' */

  /* InitializeConditions for DiscreteIntegrator: '<S48>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LO_ps = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S54>/Discrete-Time Integrator' */
  G2Fdiag_DWork.DiscreteTimeIntegrator_IC_LOA_h = 1U;

  /* InitializeConditions for UnitDelay: '<S44>/Delay Input1' */
  G2Fdiag_DWork.DelayInput1_DSTATE_n = TRUE;
}

/* Model terminate function */
void G2Fdiag_terminate(struct fGEN2diag* inst)
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
