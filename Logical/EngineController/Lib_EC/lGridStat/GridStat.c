/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: GridStat
 * File: GridStat.c
 * Author: 105055527
 * Last modified by: cadm_kafkama00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Tue Nov 26 15:54:38 2024
 * Model Version: 2.02
 * Description: Detection Algorithm for grid connection.

   HISTORY:
   V1.00  24.07.2020 Keller   created
   V1.01  07.08.2020 Huber  included function block from simulation
   V1.02  29.04.2021 Denk   VectorShift and LVRT function added
   V1.03  31.01.2022 Keller  add input for GCB_On

   V2.00  10.08.2023 Walch  Revision of parametrization, sensitivity and FRT selectivity
   V2.01  22.11.2023 Walch  Include grid observer
   10.01.2024 Walch  Include TP LVRT hold time for weak LVRT blocking
   V2.02  25.11.2024 Walch  Update grid observer for SS mains parallel vs. island plausibility check
 * modified Comment:
 ********************************************************************
 * Implementation of program GridStat
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#include "GridStat.h"
#include "GridStat_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/* Forward declaration for local functions */
static real32_T GridStat_mean(const real32_T x[5], struct fGridStat* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/
int32_T div_nde_s32_floor(int32_T numerator, int32_T denominator, struct fGridStat* inst)
{
  return (((numerator < 0) != (denominator < 0)) && (numerator % denominator !=
           0) ? -1 : 0) + numerator / denominator;
}

/*
 * System initialize for atomic system:
 *    '<S4>/TofLvrtWeakBlk1'
 *    '<S2>/TofMcbFb'
 *    '<S2>/TofReset'
 *    '<S8>/TofAfterFRT'
 *    '<S8>/TofLvrtWeakBlk2'
 */
void GridStat_TofLvrtWeakBlk1_Init(rtDW_TofLvrtWeakBlk1_GridStat *localDW, struct fGridStat* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S12>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_PrevRese = 2;
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S4>/TofLvrtWeakBlk1'
 *    '<S2>/TofMcbFb'
 *    '<S2>/TofReset'
 *    '<S8>/TofAfterFRT'
 *    '<S8>/TofLvrtWeakBlk2'
 */
void GridStat_TofLvrtWeakBlk1(boolean_T rtu_IN, real32_T rtu_PT,
  rtB_TofLvrtWeakBlk1_GridStat *localB, rtDW_TofLvrtWeakBlk1_GridStat *localDW, struct fGridStat* inst)
{
  real32_T rtb_Switch_l;

  /* Switch: '<S12>/Switch' incorporates:
   *  Constant: '<S12>/Constant1'
   */
  if (rtu_IN) {
    rtb_Switch_l = 0.0F;
  } else {
    rtb_Switch_l = rtu_PT;
  }

  /* End of Switch: '<S12>/Switch' */

  /* DiscreteIntegrator: '<S12>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_l;
  }

  if (rtu_IN && (localDW->DiscreteTimeIntegrator_PrevRese <= 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_l;
  }

  /* Logic: '<S12>/Logical Operator1' incorporates:
   *  DiscreteIntegrator: '<S12>/Discrete-Time Integrator'
   *  RelationalOperator: '<S12>/Relational Operator'
   */
  localB->LogicalOperator1 = (localDW->DiscreteTimeIntegrator_DSTATE < rtu_PT);

  /* Update for DiscreteIntegrator: '<S12>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S20>/Conversion'
   *  Logic: '<S12>/Logical Operator5'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  localDW->DiscreteTimeIntegrator_DSTATE += 0.01F * (real32_T)!rtu_IN;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtu_IN;
}

/*
 * System initialize for atomic system:
 *    '<S4>/TpDetNabsProtTrigger'
 *    '<S4>/TpLvrtBlockHold1'
 *    '<S4>/TpLvrtTrigHold1'
 *    '<S4>/TpNabsTrigger'
 *    '<S4>/TpProtTrigger'
 *    '<S8>/TP_PU_trigger'
 *    '<S8>/TpDetVPNTrigger'
 *    '<S8>/TpLvrtBlockHold2'
 *    '<S8>/TpLvrtTrigHold2'
 *    '<S8>/TpNTrigger'
 *    ...
 */
void GridS_TpDetNabsProtTrigger_Init(rtDW_TpDetNabsProtTrigger_GridS *localDW, struct fGridStat* inst)
{
  /* InitializeConditions for UnitDelay: '<S13>/Unit Delay2' */
  localDW->UnitDelay2_DSTATE = true;
}

/*
 * Output and update for atomic system:
 *    '<S4>/TpDetNabsProtTrigger'
 *    '<S4>/TpLvrtBlockHold1'
 *    '<S4>/TpLvrtTrigHold1'
 *    '<S4>/TpNabsTrigger'
 *    '<S4>/TpProtTrigger'
 *    '<S8>/TP_PU_trigger'
 *    '<S8>/TpDetVPNTrigger'
 *    '<S8>/TpLvrtBlockHold2'
 *    '<S8>/TpLvrtTrigHold2'
 *    '<S8>/TpNTrigger'
 *    ...
 */
void GridStat_TpDetNabsProtTrigger(boolean_T rtu_IN, real32_T rtu_PT,
  rtB_TpDetNabsProtTrigger_GridSt *localB, rtDW_TpDetNabsProtTrigger_GridS
  *localDW, struct fGridStat* inst)
{
  real32_T rtb_Switch2;
  real32_T rtb_UkYk1;

  /* Product: '<S24>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S24>/sample time'
   *
   * About '<S24>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2 = 0.01F;

  /* Outputs for Enabled SubSystem: '<S13>/Enabled Subsystem' incorporates:
   *  EnablePort: '<S22>/Enable'
   */
  /* Logic: '<S13>/Logical Operator3' incorporates:
   *  Logic: '<S13>/Logical Operator2'
   *  UnitDelay: '<S13>/Unit Delay2'
   */
  if ((!rtu_IN) && localDW->UnitDelay2_DSTATE) {
    /* Merge: '<S13>/Merge' incorporates:
     *  Constant: '<S13>/Constant10'
     *  Inport: '<S22>/In1'
     */
    localB->Merge = 0.0F;
  }

  /* End of Logic: '<S13>/Logical Operator3' */
  /* End of Outputs for SubSystem: '<S13>/Enabled Subsystem' */

  /* Outputs for Enabled SubSystem: '<S13>/Enabled Subsystem1' incorporates:
   *  EnablePort: '<S23>/Enable'
   */
  if (rtu_IN) {
    /* Merge: '<S13>/Merge' incorporates:
     *  Inport: '<S23>/In1'
     */
    localB->Merge = rtu_PT;
  }

  /* End of Outputs for SubSystem: '<S13>/Enabled Subsystem1' */

  /* Sum: '<S24>/Difference Inputs1' incorporates:
   *  UnitDelay: '<S24>/Delay Input2'
   */
  rtb_UkYk1 = localB->Merge - localDW->DelayInput2_DSTATE;

  /* Switch: '<S25>/Switch2' incorporates:
   *  RelationalOperator: '<S25>/LowerRelop1'
   */
  if (rtb_UkYk1 <= 0.01F) {
    /* Product: '<S24>/delta fall limit' incorporates:
     *  Constant: '<S13>/Constant9'
     *  SampleTimeMath: '<S24>/sample time'
     *
     * About '<S24>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch2 = -99.99F;

    /* Switch: '<S25>/Switch' incorporates:
     *  RelationalOperator: '<S25>/UpperRelop'
     */
    if (rtb_UkYk1 >= -99.99F) {
      rtb_Switch2 = rtb_UkYk1;
    }

    /* End of Switch: '<S25>/Switch' */
  }

  /* End of Switch: '<S25>/Switch2' */

  /* Sum: '<S24>/Difference Inputs2' incorporates:
   *  UnitDelay: '<S24>/Delay Input2'
   */
  rtb_UkYk1 = rtb_Switch2 + localDW->DelayInput2_DSTATE;

  /* Logic: '<S13>/Logical Operator1' incorporates:
   *  Constant: '<S21>/Constant'
   *  RelationalOperator: '<S13>/Relational Operator1'
   *  RelationalOperator: '<S21>/Compare'
   */
  localB->LogicalOperator1 = ((rtb_UkYk1 > 0.0F) && (rtb_UkYk1 < rtu_PT));

  /* Update for UnitDelay: '<S13>/Unit Delay2' incorporates:
   *  RelationalOperator: '<S13>/Relational Operator3'
   */
  localDW->UnitDelay2_DSTATE = (rtb_UkYk1 >= rtu_PT);

  /* Update for UnitDelay: '<S24>/Delay Input2' */
  localDW->DelayInput2_DSTATE = rtb_UkYk1;
}

/* Function for MATLAB Function: '<S5>/Grid Observer' */
static real32_T GridStat_mean(const real32_T x[5], struct fGridStat* inst)
{
  return ((((x[0] + x[1]) + x[2]) + x[3]) + x[4]) / 5.0F;
}

/* Model step function */
void GridStat_step(RT_MODEL_GridStat *const GridStat_M, struct fGridStat* inst)
{
  struct BlockIO_GridStat *GridStat_B = GridStat_M->blockIO;
  struct D_Work_GridStat *GridStat_DWork = GridStat_M->dwork;
  struct PrevZCSigStates_GridStat *GridStat_PrevZCSigState = GridStat_M->prevZCSigState;
  ExternalOutputs_GridStat *GridStat_Y = (ExternalOutputs_GridStat *)
    GridStat_M->outputs;
  real_T rtb_Switch;
  real_T u0;
  int32_T i;
  int32_T tmp;
  real32_T rtb_Divide4_h;
  real32_T rtb_Product5;
  real32_T rtb_Product6;
  real32_T rtb_Product6_c;
  real32_T rtb_Saturation;
  int16_T rtb_Saturation2;
  int16_T tmp_0;
  boolean_T rtb_AND;
  boolean_T rtb_LogicalOperator3;
  boolean_T rtb_LogicalOperator_b;
  boolean_T rtb_LogicalOperator_i;
  boolean_T rtb_RelationalOperator;
  boolean_T rtb_RelationalOperator3;
  boolean_T rtb_RelationalOperator3_dy;
  boolean_T rtb_RelationalOperator_b;
  boolean_T rtb_Switch6;
  boolean_T rtb_trigger_LVRT_l;
  boolean_T rtb_trigger_N;
  boolean_T rtb_trigger_P;
  boolean_T rtb_trigger_PU;
  boolean_T rtb_trigger_U;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  GridStat_B->BusInput = inst->Para;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  GridStat_B->BusInput2 = inst->In;

  /* Logic: '<S2>/AND' */
  rtb_AND = (GridStat_B->BusInput2.bGCB_On && GridStat_B->BusInput2.bMCB_On);

  /* Outputs for Atomic SubSystem: '<S2>/TofMcbFb' */
  GridStat_TofLvrtWeakBlk1(rtb_AND, GridStat_B->BusInput.rTi_Tof_MCBfb,
    &GridStat_B->TofMcbFb, &GridStat_DWork->TofMcbFb, inst);

  /* End of Outputs for SubSystem: '<S2>/TofMcbFb' */

  /* Saturate: '<S4>/Saturation5' */
  if (GridStat_B->BusInput.rN_Nom >= 1.0F) {
    rtb_Saturation = GridStat_B->BusInput.rN_Nom;
  } else {
    rtb_Saturation = 1.0F;
  }

  /* End of Saturate: '<S4>/Saturation5' */

  /* RelationalOperator: '<S4>/Relational Operator' incorporates:
   *  Abs: '<S4>/Abs'
   *  Abs: '<S4>/Abs1'
   *  Product: '<S4>/Product4'
   *  Sum: '<S4>/Sum'
   */
  rtb_RelationalOperator = ((real32_T)fabs(GridStat_B->BusInput2.rN_engAct -
    rtb_Saturation) > (real32_T)fabs(rtb_Saturation *
    GridStat_B->BusInput.rThrs_DeltaN_norm));

  /* Outputs for Atomic SubSystem: '<S4>/TpNabsTrigger' */
  /* SignalConversion generated from: '<S4>/Bus Selector2' */
  GridStat_TpDetNabsProtTrigger(rtb_RelationalOperator,
    GridStat_B->BusInput.rTi_Tp_DetectActive, &GridStat_B->TpNabsTrigger,
    &GridStat_DWork->TpNabsTrigger, inst);

  /* End of Outputs for SubSystem: '<S4>/TpNabsTrigger' */

  /* Gain: '<S4>/rpm2omega' */
  rtb_Saturation = 0.104719758F * GridStat_B->BusInput2.rN_engAct;

  /* Outputs for Atomic SubSystem: '<S4>/Speed_filter' */
  /* Logic: '<S11>/Logical Operator' incorporates:
   *  Constant: '<S11>/Constant'
   *  Logic: '<S11>/Logical Operator1'
   *  RelationalOperator: '<S11>/Relational Operator'
   */
  rtb_LogicalOperator_i = (GridStat_B->BusInput2.bReset ||
    (GridStat_B->BusInput.rTi_Filt_speed <= 0.0F));

  /* DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  if (GridStat_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    GridStat_DWork->DiscreteTimeIntegrator_DSTATE_j = rtb_Saturation;
  }

  if (rtb_LogicalOperator_i || (GridStat_DWork->DiscreteTimeIntegrator_PrevRese
       != 0)) {
    GridStat_DWork->DiscreteTimeIntegrator_DSTATE_j = rtb_Saturation;
  }

  /* Switch: '<S18>/Switch' incorporates:
   *  Abs: '<S18>/Abs'
   *  RelationalOperator: '<S18>/Relational Operator'
   */
  if (2.22044605E-16F >= (real32_T)fabs(GridStat_B->BusInput.rTi_Filt_speed)) {
    rtb_Product5 = 2.22044605E-16F;
  } else {
    rtb_Product5 = GridStat_B->BusInput.rTi_Filt_speed;
  }

  /* End of Switch: '<S18>/Switch' */

  /* Product: '<S11>/Divide4' incorporates:
   *  DiscreteIntegrator: '<S11>/Discrete-Time Integrator'
   *  Sum: '<S11>/Sum4'
   */
  rtb_Divide4_h = (rtb_Saturation -
                   GridStat_DWork->DiscreteTimeIntegrator_DSTATE_j) /
    rtb_Product5;

  /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  GridStat_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;
  GridStat_DWork->DiscreteTimeIntegrator_DSTATE_j += 0.01F * rtb_Divide4_h;
  GridStat_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)
    rtb_LogicalOperator_i;

  /* End of Outputs for SubSystem: '<S4>/Speed_filter' */

  /* Gain: '<S4>/W2kW' */
  rtb_Product6 = 1000.0F * GridStat_B->BusInput.rP_Nom;

  /* Outputs for Atomic SubSystem: '<S4>/Speed_filter' */
  /* Switch: '<S11>/Switch1' incorporates:
   *  Constant: '<S11>/Constant'
   */
  if (rtb_LogicalOperator_i) {
    rtb_Divide4_h = 0.0F;
  }

  /* End of Switch: '<S11>/Switch1' */
  /* End of Outputs for SubSystem: '<S4>/Speed_filter' */

  /* Saturate: '<S4>/Saturation' */
  if (rtb_Product6 < 1.0F) {
    rtb_Product6 = 1.0F;
  }

  /* End of Saturate: '<S4>/Saturation' */

  /* Product: '<S4>/Product2' incorporates:
   *  Product: '<S4>/Product1'
   */
  rtb_Saturation = rtb_Saturation * rtb_Divide4_h *
    GridStat_B->BusInput.rJ_Engine / rtb_Product6;

  /* RelationalOperator: '<S4>/Relational Operator2' */
  rtb_LogicalOperator_i = (rtb_Saturation >
    GridStat_B->BusInput.rProt_Norm_limit);

  /* Outputs for Atomic SubSystem: '<S4>/TpProtTrigger' */
  /* SignalConversion generated from: '<S4>/Bus Selector2' */
  GridStat_TpDetNabsProtTrigger(rtb_LogicalOperator_i,
    GridStat_B->BusInput.rTi_Tp_DetectActive, &GridStat_B->TpProtTrigger,
    &GridStat_DWork->TpProtTrigger, inst);

  /* End of Outputs for SubSystem: '<S4>/TpProtTrigger' */

  /* RelationalOperator: '<S4>/Relational Operator3' */
  rtb_RelationalOperator3 = (GridStat_B->BusInput2.rU_norm <=
    GridStat_B->BusInput.rThrs_LVRT_norm);

  /* Saturate: '<S4>/Saturation1' */
  if (GridStat_B->BusInput.rTi_sampleRate >= 0.001F) {
    /* Saturate: '<S8>/Saturation' incorporates:
     *  Saturate: '<S8>/Saturation1'
     */
    rtb_Divide4_h = GridStat_B->BusInput.rTi_sampleRate;
  } else {
    /* Saturate: '<S8>/Saturation' incorporates:
     *  Saturate: '<S8>/Saturation1'
     */
    rtb_Divide4_h = 0.001F;
  }

  /* Saturate: '<S4>/Saturation4' incorporates:
   *  DataTypeConversion: '<S4>/Cast1'
   */
  if (GridStat_B->BusInput.iSamples_Tp_LVRT_hold > 10000.0F) {
    rtb_Product5 = 10000.0F;
  } else if (GridStat_B->BusInput.iSamples_Tp_LVRT_hold < 1.0F) {
    rtb_Product5 = 1.0F;
  } else {
    rtb_Product5 = GridStat_B->BusInput.iSamples_Tp_LVRT_hold;
  }

  /* End of Saturate: '<S4>/Saturation4' */

  /* Product: '<S4>/Product6' incorporates:
   *  Saturate: '<S4>/Saturation1'
   */
  rtb_Product6 = rtb_Divide4_h * rtb_Product5;

  /* Outputs for Atomic SubSystem: '<S4>/TpLvrtBlockHold1' */
  /* Logic: '<S4>/Logical Operator2' */
  GridStat_TpDetNabsProtTrigger((rtb_RelationalOperator3 ||
    GridStat_B->BusInput2.bLVRT), rtb_Product6, &GridStat_B->TpLvrtBlockHold1,
    &GridStat_DWork->TpLvrtBlockHold1, inst);

  /* End of Outputs for SubSystem: '<S4>/TpLvrtBlockHold1' */

  /* Saturate: '<S4>/Saturation2' incorporates:
   *  Constant: '<S4>/Constant1'
   *  DataTypeConversion: '<S4>/Cast'
   *  Sum: '<S4>/Sum3'
   */
  if (10.0F - (real32_T)GridStat_B->BusInput.iSensitivity_WeakBlocking > 10.0F)
  {
    rtb_Product5 = 10.0F;
  } else if (10.0F - (real32_T)GridStat_B->BusInput.iSensitivity_WeakBlocking <
             1.0F) {
    rtb_Product5 = 1.0F;
  } else {
    rtb_Product5 = 10.0F - (real32_T)
      GridStat_B->BusInput.iSensitivity_WeakBlocking;
  }

  /* End of Saturate: '<S4>/Saturation2' */

  /* Outputs for Atomic SubSystem: '<S4>/TofLvrtWeakBlk1' */
  /* Product: '<S4>/Product7' incorporates:
   *  Saturate: '<S4>/Saturation1'
   */
  GridStat_TofLvrtWeakBlk1(rtb_RelationalOperator3, rtb_Product5 * rtb_Divide4_h,
    &GridStat_B->TofLvrtWeakBlk1, &GridStat_DWork->TofLvrtWeakBlk1, inst);

  /* End of Outputs for SubSystem: '<S4>/TofLvrtWeakBlk1' */

  /* Outputs for Atomic SubSystem: '<S4>/TpLvrtTrigHold1' */
  GridStat_TpDetNabsProtTrigger(GridStat_B->BusInput2.bLVRT, rtb_Product6,
    &GridStat_B->TpLvrtTrigHold1, &GridStat_DWork->TpLvrtTrigHold1, inst);

  /* End of Outputs for SubSystem: '<S4>/TpLvrtTrigHold1' */

  /* Switch: '<S4>/Switch1' incorporates:
   *  Constant: '<S4>/Constant'
   *  Logic: '<S4>/Logical Operator1'
   *  Logic: '<S4>/Logical Operator11'
   *  Logic: '<S4>/Logical Operator3'
   *  Logic: '<S4>/NOT2'
   *  Switch: '<S4>/Switch5'
   */
  if (rtb_RelationalOperator && (GridStat_B->BusInput.bN_BypassFRTBlocking &&
       GridStat_B->BusInput.bN_BypassFRTBlocking_speedAbs)) {
    rtb_RelationalOperator3 = false;
  } else if ((!GridStat_B->BusInput.bWeakFRTBlocking) ||
             (!GridStat_B->BusInput.bWeakFRTBlocking_speedAbs)) {
    /* Switch: '<S4>/Switch5' */
    rtb_RelationalOperator3 = GridStat_B->TpLvrtBlockHold1.LogicalOperator1;
  } else {
    /* Switch: '<S4>/Switch5' incorporates:
     *  Logic: '<S4>/Logical Operator9'
     */
    rtb_RelationalOperator3 = (GridStat_B->TofLvrtWeakBlk1.LogicalOperator1 &&
      GridStat_B->TpLvrtTrigHold1.LogicalOperator1);
  }

  /* End of Switch: '<S4>/Switch1' */

  /* Logic: '<S4>/NOT' */
  rtb_Switch6 = !rtb_RelationalOperator3;

  /* Switch: '<S4>/Switch4' incorporates:
   *  Saturate: '<S4>/Saturation1'
   */
  if (rtb_Switch6) {
    rtb_Product6 = GridStat_B->BusInput.rTi_Tp_DetectActive;
  } else {
    rtb_Product6 = rtb_Divide4_h;
  }

  /* End of Switch: '<S4>/Switch4' */

  /* Outputs for Atomic SubSystem: '<S4>/TpDetNabsProtTrigger' */
  /* Logic: '<S4>/Logical Operator4' incorporates:
   *  Logic: '<S4>/Logical Operator'
   */
  GridStat_TpDetNabsProtTrigger(((GridStat_B->TpNabsTrigger.LogicalOperator1 ||
    GridStat_B->TpProtTrigger.LogicalOperator1) && rtb_Switch6), rtb_Product6,
    &GridStat_B->TpDetNabsProtTrigger, &GridStat_DWork->TpDetNabsProtTrigger, inst);

  /* End of Outputs for SubSystem: '<S4>/TpDetNabsProtTrigger' */

  /* Saturate: '<S8>/Saturation2' */
  if (GridStat_B->BusInput.iSamples_derivative_PU > 10) {
    rtb_Saturation2 = 10;
  } else if (GridStat_B->BusInput.iSamples_derivative_PU < 1) {
    rtb_Saturation2 = 1;
  } else {
    rtb_Saturation2 = GridStat_B->BusInput.iSamples_derivative_PU;
  }

  /* End of Saturate: '<S8>/Saturation2' */

  /* Product: '<S8>/Product' */
  rtb_Product6 = (real32_T)rtb_Saturation2 * rtb_Divide4_h;

  /* RelationalOperator: '<S8>/Relational Operator3' */
  rtb_RelationalOperator3_dy = (GridStat_B->BusInput2.rU_norm <=
    GridStat_B->BusInput.rThrs_LVRT_norm);

  /* Saturate: '<S8>/Saturation7' incorporates:
   *  Constant: '<S8>/Constant1'
   *  DataTypeConversion: '<S8>/Cast'
   *  Sum: '<S8>/Sum3'
   */
  if (10.0F - (real32_T)GridStat_B->BusInput.iSensitivity_WeakBlocking > 10.0F)
  {
    rtb_Product5 = 10.0F;
  } else if (10.0F - (real32_T)GridStat_B->BusInput.iSensitivity_WeakBlocking <
             1.0F) {
    rtb_Product5 = 1.0F;
  } else {
    rtb_Product5 = 10.0F - (real32_T)
      GridStat_B->BusInput.iSensitivity_WeakBlocking;
  }

  /* End of Saturate: '<S8>/Saturation7' */

  /* Outputs for Atomic SubSystem: '<S8>/TofLvrtWeakBlk2' */
  /* Product: '<S8>/Product7' */
  GridStat_TofLvrtWeakBlk1(rtb_RelationalOperator3_dy, rtb_Product5 *
    rtb_Divide4_h, &GridStat_B->TofLvrtWeakBlk2,
    &GridStat_DWork->TofLvrtWeakBlk2, inst);

  /* End of Outputs for SubSystem: '<S8>/TofLvrtWeakBlk2' */

  /* Saturate: '<S8>/Saturation4' */
  if (GridStat_B->BusInput.iSamples_Tp_LVRT_hold > 10000) {
    tmp_0 = 10000;
  } else if (GridStat_B->BusInput.iSamples_Tp_LVRT_hold < 1) {
    tmp_0 = 1;
  } else {
    tmp_0 = GridStat_B->BusInput.iSamples_Tp_LVRT_hold;
  }

  /* End of Saturate: '<S8>/Saturation4' */

  /* Product: '<S8>/Product6' */
  rtb_Product6_c = rtb_Divide4_h * (real32_T)tmp_0;

  /* Outputs for Atomic SubSystem: '<S8>/TpLvrtTrigHold2' */
  GridStat_TpDetNabsProtTrigger(GridStat_B->BusInput2.bLVRT, rtb_Product6_c,
    &GridStat_B->TpLvrtTrigHold2, &GridStat_DWork->TpLvrtTrigHold2, inst);

  /* End of Outputs for SubSystem: '<S8>/TpLvrtTrigHold2' */

  /* Logic: '<S8>/Logical Operator9' */
  rtb_trigger_LVRT_l = (GridStat_B->TofLvrtWeakBlk2.LogicalOperator1 &&
                        GridStat_B->TpLvrtTrigHold2.LogicalOperator1);

  /* Saturate: '<S8>/Saturation6' */
  if (GridStat_B->BusInput.iSamples_Tof_U_norm_FRTBlock > 1000) {
    tmp_0 = 1000;
  } else if (GridStat_B->BusInput.iSamples_Tof_U_norm_FRTBlock < 1) {
    tmp_0 = 1;
  } else {
    tmp_0 = GridStat_B->BusInput.iSamples_Tof_U_norm_FRTBlock;
  }

  /* End of Saturate: '<S8>/Saturation6' */

  /* Outputs for Atomic SubSystem: '<S8>/TofAfterFRT' */
  /* Product: '<S8>/Product8' */
  GridStat_TofLvrtWeakBlk1(rtb_trigger_LVRT_l, (real32_T)tmp_0 * rtb_Divide4_h,
    &GridStat_B->TofAfterFRT, &GridStat_DWork->TofAfterFRT, inst);

  /* End of Outputs for SubSystem: '<S8>/TofAfterFRT' */

  /* Switch: '<S8>/Switch7' incorporates:
   *  Logic: '<S8>/NOT3'
   */
  if (!GridStat_B->TofAfterFRT.LogicalOperator1) {
    rtb_Product5 = GridStat_B->BusInput.rThrs_U_norm;
  } else {
    rtb_Product5 = GridStat_B->BusInput.rThrs_U_norm_FRTBlock;
  }

  /* End of Switch: '<S8>/Switch7' */

  /* RelationalOperator: '<S8>/Relational Operator' incorporates:
   *  Abs: '<S8>/Abs'
   *  Product: '<S8>/Product1'
   *  S-Function (sfix_udelay): '<S8>/Tapped Delay'
   *  Selector: '<S8>/Selector'
   *  Sum: '<S8>/Sum'
   */
  rtb_trigger_U = ((real32_T)fabs(GridStat_DWork->TappedDelay_X[rtb_Saturation2
    - 1] - GridStat_B->BusInput2.rU_norm) / rtb_Product6 >= rtb_Product5);

  /* Saturate: '<S8>/Saturation3' */
  if (GridStat_B->BusInput.iSamples_Tp_detect_VPN > 1000) {
    tmp_0 = 1000;
  } else if (GridStat_B->BusInput.iSamples_Tp_detect_VPN < 1) {
    tmp_0 = 1;
  } else {
    tmp_0 = GridStat_B->BusInput.iSamples_Tp_detect_VPN;
  }

  /* End of Saturate: '<S8>/Saturation3' */

  /* Product: '<S8>/Product5' */
  rtb_Product5 = (real32_T)tmp_0 * rtb_Divide4_h;

  /* Outputs for Atomic SubSystem: '<S8>/TpUTrigger' */
  GridStat_TpDetNabsProtTrigger(rtb_trigger_U, rtb_Product5,
    &GridStat_B->TpUTrigger, &GridStat_DWork->TpUTrigger, inst);

  /* End of Outputs for SubSystem: '<S8>/TpUTrigger' */

  /* RelationalOperator: '<S8>/Relational Operator1' incorporates:
   *  Abs: '<S8>/Abs1'
   *  Product: '<S8>/Product2'
   *  S-Function (sfix_udelay): '<S8>/Tapped Delay1'
   *  Selector: '<S8>/Selector'
   *  Selector: '<S8>/Selector1'
   *  Sum: '<S8>/Sum1'
   */
  rtb_trigger_P = ((real32_T)fabs(GridStat_DWork->TappedDelay1_X[rtb_Saturation2
    - 1] - GridStat_B->BusInput2.rP_norm) / rtb_Product6 >=
                   GridStat_B->BusInput.rThrs_P_norm);

  /* Outputs for Atomic SubSystem: '<S8>/TpPTrigger' */
  GridStat_TpDetNabsProtTrigger(rtb_trigger_P, rtb_Product5,
    &GridStat_B->TpPTrigger, &GridStat_DWork->TpPTrigger, inst);

  /* End of Outputs for SubSystem: '<S8>/TpPTrigger' */

  /* Switch: '<S8>/Switch1' incorporates:
   *  Logic: '<S8>/Logical Operator5'
   *  Logic: '<S8>/Logical Operator6'
   *  Switch: '<S8>/Switch'
   */
  if (GridStat_B->BusInput.bLimitedTriggerTime) {
    rtb_RelationalOperator_b = GridStat_B->TpUTrigger.LogicalOperator1;
    rtb_LogicalOperator3 = GridStat_B->TpPTrigger.LogicalOperator1;
  } else {
    rtb_RelationalOperator_b = (GridStat_B->TpUTrigger.LogicalOperator1 ||
      rtb_trigger_U);
    rtb_LogicalOperator3 = (GridStat_B->TpPTrigger.LogicalOperator1 ||
      rtb_trigger_P);
  }

  /* End of Switch: '<S8>/Switch1' */

  /* Logic: '<S8>/Logical Operator' */
  rtb_trigger_PU = (rtb_RelationalOperator_b && rtb_LogicalOperator3);

  /* Outputs for Atomic SubSystem: '<S8>/TP_PU_trigger' */
  GridStat_TpDetNabsProtTrigger(rtb_trigger_PU, rtb_Product5,
    &GridStat_B->TP_PU_trigger, &GridStat_DWork->TP_PU_trigger, inst);

  /* End of Outputs for SubSystem: '<S8>/TP_PU_trigger' */

  /* Saturate: '<S8>/Saturation5' */
  if (GridStat_B->BusInput.iSamples_derivative_N > 10) {
    rtb_Saturation2 = 10;
  } else if (GridStat_B->BusInput.iSamples_derivative_N < 1) {
    rtb_Saturation2 = 1;
  } else {
    rtb_Saturation2 = GridStat_B->BusInput.iSamples_derivative_N;
  }

  /* End of Saturate: '<S8>/Saturation5' */

  /* RelationalOperator: '<S8>/Relational Operator2' incorporates:
   *  Abs: '<S8>/Abs2'
   *  Product: '<S8>/Product3'
   *  Product: '<S8>/Product4'
   *  S-Function (sfix_udelay): '<S8>/Tapped Delay2'
   *  Selector: '<S8>/Selector2'
   *  Sum: '<S8>/Sum2'
   */
  rtb_trigger_N = (GridStat_B->BusInput.rThrs_N_eng <= 1.0F / (rtb_Divide4_h *
    (real32_T)rtb_Saturation2) * (real32_T)fabs(GridStat_DWork->
    TappedDelay2_X[rtb_Saturation2 - 1] - GridStat_B->BusInput2.rN_engAct));

  /* Outputs for Atomic SubSystem: '<S8>/TpNTrigger' */
  GridStat_TpDetNabsProtTrigger(rtb_trigger_N, rtb_Product5,
    &GridStat_B->TpNTrigger, &GridStat_DWork->TpNTrigger, inst);

  /* End of Outputs for SubSystem: '<S8>/TpNTrigger' */

  /* Outputs for Atomic SubSystem: '<S8>/TpLvrtBlockHold2' */
  /* Logic: '<S8>/Logical Operator2' */
  GridStat_TpDetNabsProtTrigger((rtb_RelationalOperator3_dy ||
    GridStat_B->BusInput2.bLVRT), rtb_Product6_c, &GridStat_B->TpLvrtBlockHold2,
    &GridStat_DWork->TpLvrtBlockHold2, inst);

  /* End of Outputs for SubSystem: '<S8>/TpLvrtBlockHold2' */

  /* Switch: '<S8>/Switch6' incorporates:
   *  Constant: '<S8>/Constant'
   *  Logic: '<S8>/Logical Operator10'
   *  Logic: '<S8>/Logical Operator11'
   *  Logic: '<S8>/Logical Operator12'
   *  Logic: '<S8>/NOT2'
   *  Switch: '<S8>/Switch5'
   */
  if (rtb_RelationalOperator && (GridStat_B->BusInput.bN_BypassFRTBlocking &&
       GridStat_B->BusInput.bN_BypassFRTBlocking_VPN)) {
    rtb_Switch6 = false;
  } else if ((!GridStat_B->BusInput.bWeakFRTBlocking) ||
             (!GridStat_B->BusInput.bWeakFRTBlocking_VPN)) {
    /* Switch: '<S8>/Switch5' */
    rtb_Switch6 = GridStat_B->TpLvrtBlockHold2.LogicalOperator1;
  } else {
    rtb_Switch6 = rtb_trigger_LVRT_l;
  }

  /* End of Switch: '<S8>/Switch6' */

  /* Logic: '<S8>/NOT' */
  rtb_trigger_LVRT_l = !rtb_Switch6;

  /* Switch: '<S8>/Switch2' incorporates:
   *  Logic: '<S8>/Logical Operator7'
   */
  if (GridStat_B->BusInput.bLimitedTriggerTime) {
    rtb_RelationalOperator_b = GridStat_B->TP_PU_trigger.LogicalOperator1;
  } else {
    rtb_RelationalOperator_b = (GridStat_B->TP_PU_trigger.LogicalOperator1 ||
      rtb_trigger_PU);
  }

  /* End of Switch: '<S8>/Switch2' */

  /* Switch: '<S8>/Switch3' incorporates:
   *  Logic: '<S8>/Logical Operator8'
   *  Logic: '<S8>/NOT1'
   */
  if (!GridStat_B->BusInput.bLimitedTriggerTime) {
    rtb_LogicalOperator3 = (rtb_trigger_N ||
      GridStat_B->TpNTrigger.LogicalOperator1);
  } else {
    rtb_LogicalOperator3 = GridStat_B->TpNTrigger.LogicalOperator1;
  }

  /* End of Switch: '<S8>/Switch3' */

  /* Switch: '<S8>/Switch4' */
  if (rtb_trigger_LVRT_l) {
    rtb_Divide4_h = GridStat_B->BusInput.rTi_Tp_DetectActive;
  }

  /* End of Switch: '<S8>/Switch4' */

  /* Outputs for Atomic SubSystem: '<S8>/TpDetVPNTrigger' */
  /* Logic: '<S8>/Logical Operator4' incorporates:
   *  Logic: '<S8>/Logical Operator1'
   *  Logic: '<S8>/Logical Operator3'
   */
  GridStat_TpDetNabsProtTrigger((((rtb_RelationalOperator_b &&
    rtb_LogicalOperator3) || GridStat_B->BusInput2.bVectorShift) &&
    rtb_trigger_LVRT_l), rtb_Divide4_h, &GridStat_B->TpDetVPNTrigger,
    &GridStat_DWork->TpDetVPNTrigger, inst);

  /* End of Outputs for SubSystem: '<S8>/TpDetVPNTrigger' */

  /* MATLAB Function: '<S5>/Grid Observer' */
  /* MATLAB Function 'detection + correction: transition to Island/Smooth Detection/Grid Observer': '<S52>:1' */
  /* '<S52>:1:2' */
  tmp = 10 - GridStat_B->BusInput.iSensitivity_SmoothDetection;
  if (10 - GridStat_B->BusInput.iSensitivity_SmoothDetection > 32767) {
    tmp = 32767;
  }

  if ((!GridStat_DWork->U_past_not_empty) || GridStat_B->BusInput2.bReset) {
    GridStat_DWork->ctr_U = 0;
    for (i = 0; i < 1000; i++) {
      GridStat_DWork->U_past[i] = GridStat_B->BusInput2.rU_norm;
    }

    GridStat_DWork->U_past_not_empty = true;
  }

  i = GridStat_DWork->ctr_U + 1;
  if (GridStat_DWork->ctr_U + 1 > 32767) {
    i = 32767;
  }

  GridStat_DWork->U_past[i - 1] = GridStat_B->BusInput2.rU_norm;
  rtb_Divide4_h = 0.0F;
  for (rtb_Saturation2 = 0; rtb_Saturation2 < 1000; rtb_Saturation2++) {
    i = GridStat_DWork->ctr_U - rtb_Saturation2;
    if (i < -32768) {
      i = -32768;
    }

    i = (int16_T)((int16_T)i - (int16_T)((int16_T)div_nde_s32_floor((int16_T)i,
      1000, inst) * 1000)) + 1;
    if (i > 32767) {
      i = 32767;
    }

    rtb_Divide4_h += GridStat_DWork->U_past[i - 1];
  }

  rtb_Divide4_h /= 1000.0F;
  i = GridStat_DWork->ctr_U + 1;
  if (GridStat_DWork->ctr_U + 1 > 32767) {
    i = 32767;
  }

  GridStat_DWork->ctr_U = (int16_T)i;
  if (GridStat_DWork->ctr_U >= 1000) {
    GridStat_DWork->ctr_U = 0;
  }

  if ((!GridStat_DWork->err_past_not_empty) || GridStat_B->BusInput2.bReset) {
    GridStat_DWork->ctr_err = 0;
    GridStat_DWork->ctr_acterr = 0;
    GridStat_DWork->ctr_release = 0;
    for (i = 0; i < 1000; i++) {
      GridStat_DWork->err_past[i] = 0.0F;
    }

    GridStat_DWork->err_past_not_empty = true;
    GridStat_DWork->err_min = 1.0E+6F;
    GridStat_DWork->err_act = 0.0F;
    GridStat_DWork->err_max = 0.0F;
    GridStat_DWork->flag_window = true;
    for (i = 0; i < 5; i++) {
      GridStat_DWork->err_act_temp[i] = 0.0F;
    }
  }

  i = GridStat_DWork->ctr_err + 1;
  if (GridStat_DWork->ctr_err + 1 > 32767) {
    i = 32767;
  }

  if (1.0F >= GridStat_B->BusInput.rN_Nom) {
    rtb_Product5 = 1.0F;
  } else {
    rtb_Product5 = GridStat_B->BusInput.rN_Nom;
  }

  GridStat_DWork->err_past[i - 1] = (real32_T)fabs
    (GridStat_B->BusInput2.rN_engAct / rtb_Product5 - 1.0F);
  rtb_Product6 = GridStat_DWork->err_past[0];
  for (i = 0; i < 999; i++) {
    rtb_Product6 += GridStat_DWork->err_past[i + 1];
  }

  rtb_trigger_LVRT_l = true;
  if (GridStat_DWork->ctr_release < 6000) {
    i = GridStat_DWork->ctr_release + 1;
    if (GridStat_DWork->ctr_release + 1 > 32767) {
      i = 32767;
    }

    GridStat_DWork->ctr_release = (int16_T)i;
    rtb_trigger_LVRT_l = false;
  }

  if (GridStat_DWork->flag_window && rtb_trigger_LVRT_l) {
    i = GridStat_DWork->ctr_acterr + 1;
    if (GridStat_DWork->ctr_acterr + 1 > 32767) {
      i = 32767;
    }

    GridStat_DWork->err_act_temp[i - 1] = rtb_Product6 / 1000.0F;
    i = GridStat_DWork->ctr_acterr + 1;
    if (GridStat_DWork->ctr_acterr + 1 > 32767) {
      i = 32767;
    }

    GridStat_DWork->ctr_acterr = (int16_T)i;
    GridStat_DWork->flag_window = false;
  }

  rtb_Product6 = GridStat_DWork->err_act_temp[0];
  rtb_Product6_c = GridStat_mean(GridStat_DWork->err_act_temp, inst);
  rtb_Product5 = GridStat_DWork->err_act_temp[0];
  if (GridStat_DWork->err_act_temp[0] < GridStat_DWork->err_act_temp[1]) {
    rtb_Product6 = GridStat_DWork->err_act_temp[1];
  }

  if (GridStat_DWork->err_act_temp[0] > GridStat_DWork->err_act_temp[1]) {
    rtb_Product5 = GridStat_DWork->err_act_temp[1];
  }

  if (rtb_Product6 < GridStat_DWork->err_act_temp[2]) {
    rtb_Product6 = GridStat_DWork->err_act_temp[2];
  }

  if (rtb_Product5 > GridStat_DWork->err_act_temp[2]) {
    rtb_Product5 = GridStat_DWork->err_act_temp[2];
  }

  if (rtb_Product6 < GridStat_DWork->err_act_temp[3]) {
    rtb_Product6 = GridStat_DWork->err_act_temp[3];
  }

  if (rtb_Product5 > GridStat_DWork->err_act_temp[3]) {
    rtb_Product5 = GridStat_DWork->err_act_temp[3];
  }

  if (rtb_Product6 < GridStat_DWork->err_act_temp[4]) {
    rtb_Product6 = GridStat_DWork->err_act_temp[4];
  }

  if (rtb_Product5 > GridStat_DWork->err_act_temp[4]) {
    rtb_Product5 = GridStat_DWork->err_act_temp[4];
  }

  if (((real32_T)fabs(rtb_Product6 - rtb_Product6_c) < rtb_Product6_c) &&
      ((real32_T)fabs(rtb_Product6_c - rtb_Product5) < rtb_Product6_c)) {
    GridStat_DWork->err_act = GridStat_mean(GridStat_DWork->err_act_temp, inst);
  }

  if ((GridStat_DWork->err_act < GridStat_DWork->err_min) &&
      (GridStat_DWork->err_act > 1.0E-8F)) {
    GridStat_DWork->err_min = GridStat_DWork->err_act;
  }

  if (GridStat_DWork->err_act > GridStat_DWork->err_max) {
    GridStat_DWork->err_max = GridStat_DWork->err_act;
  }

  if (GridStat_DWork->ctr_acterr > 4) {
    GridStat_DWork->ctr_acterr = 0;
  }

  i = GridStat_DWork->ctr_err + 1;
  if (GridStat_DWork->ctr_err + 1 > 32767) {
    i = 32767;
  }

  GridStat_DWork->ctr_err = (int16_T)i;
  if (GridStat_DWork->ctr_err >= 1000) {
    GridStat_DWork->ctr_err = 0;
    GridStat_DWork->flag_window = true;
  }

  if ((!GridStat_DWork->err_past_Q_not_empty) || GridStat_B->BusInput2.bReset) {
    GridStat_DWork->ctr_err_Q = 0;
    GridStat_DWork->ctr_acterr_Q = 0;
    GridStat_DWork->ctr_release_Q = 0;
    for (i = 0; i < 1000; i++) {
      GridStat_DWork->err_past_Q[i] = 0.0F;
    }

    GridStat_DWork->err_past_Q_not_empty = true;
    GridStat_DWork->err_min_Q = 1.0E+6F;
    GridStat_DWork->err_act_Q = 0.0F;
    GridStat_DWork->err_max_Q = 0.0F;
    GridStat_DWork->flag_window_Q = true;
    for (i = 0; i < 5; i++) {
      GridStat_DWork->err_act_temp_Q[i] = 0.0F;
    }
  }

  i = GridStat_DWork->ctr_err_Q + 1;
  if (GridStat_DWork->ctr_err_Q + 1 > 32767) {
    i = 32767;
  }

  GridStat_DWork->err_past_Q[i - 1] = (real32_T)fabs
    (GridStat_B->BusInput2.rU_norm - rtb_Divide4_h);
  rtb_Divide4_h = GridStat_DWork->err_past_Q[0];
  for (i = 0; i < 999; i++) {
    rtb_Divide4_h += GridStat_DWork->err_past_Q[i + 1];
  }

  rtb_trigger_LVRT_l = true;
  if (GridStat_DWork->ctr_release_Q < 6000) {
    i = GridStat_DWork->ctr_release_Q + 1;
    if (GridStat_DWork->ctr_release_Q + 1 > 32767) {
      i = 32767;
    }

    GridStat_DWork->ctr_release_Q = (int16_T)i;
    rtb_trigger_LVRT_l = false;
  }

  if (GridStat_DWork->flag_window_Q && rtb_trigger_LVRT_l) {
    i = GridStat_DWork->ctr_acterr_Q + 1;
    if (GridStat_DWork->ctr_acterr_Q + 1 > 32767) {
      i = 32767;
    }

    GridStat_DWork->err_act_temp_Q[i - 1] = rtb_Divide4_h / 1000.0F;
    i = GridStat_DWork->ctr_acterr_Q + 1;
    if (GridStat_DWork->ctr_acterr_Q + 1 > 32767) {
      i = 32767;
    }

    GridStat_DWork->ctr_acterr_Q = (int16_T)i;
    GridStat_DWork->flag_window_Q = false;
  }

  rtb_Divide4_h = GridStat_DWork->err_act_temp_Q[0];
  rtb_Product6 = GridStat_mean(GridStat_DWork->err_act_temp_Q, inst);
  rtb_Product6_c = GridStat_DWork->err_act_temp_Q[0];
  if (GridStat_DWork->err_act_temp_Q[0] < GridStat_DWork->err_act_temp_Q[1]) {
    rtb_Divide4_h = GridStat_DWork->err_act_temp_Q[1];
  }

  if (GridStat_DWork->err_act_temp_Q[0] > GridStat_DWork->err_act_temp_Q[1]) {
    rtb_Product6_c = GridStat_DWork->err_act_temp_Q[1];
  }

  if (rtb_Divide4_h < GridStat_DWork->err_act_temp_Q[2]) {
    rtb_Divide4_h = GridStat_DWork->err_act_temp_Q[2];
  }

  if (rtb_Product6_c > GridStat_DWork->err_act_temp_Q[2]) {
    rtb_Product6_c = GridStat_DWork->err_act_temp_Q[2];
  }

  if (rtb_Divide4_h < GridStat_DWork->err_act_temp_Q[3]) {
    rtb_Divide4_h = GridStat_DWork->err_act_temp_Q[3];
  }

  if (rtb_Product6_c > GridStat_DWork->err_act_temp_Q[3]) {
    rtb_Product6_c = GridStat_DWork->err_act_temp_Q[3];
  }

  if (rtb_Divide4_h < GridStat_DWork->err_act_temp_Q[4]) {
    rtb_Divide4_h = GridStat_DWork->err_act_temp_Q[4];
  }

  if (rtb_Product6_c > GridStat_DWork->err_act_temp_Q[4]) {
    rtb_Product6_c = GridStat_DWork->err_act_temp_Q[4];
  }

  if (((real32_T)fabs(rtb_Divide4_h - rtb_Product6) < rtb_Product6) &&
      ((real32_T)fabs(rtb_Product6 - rtb_Product6_c) < rtb_Product6)) {
    GridStat_DWork->err_act_Q = GridStat_mean(GridStat_DWork->err_act_temp_Q, inst);
  }

  if ((GridStat_DWork->err_act_Q < GridStat_DWork->err_min_Q) &&
      (GridStat_DWork->err_act_Q > 1.0E-8F)) {
    GridStat_DWork->err_min_Q = GridStat_DWork->err_act_Q;
  }

  if (GridStat_DWork->err_act_Q > GridStat_DWork->err_max_Q) {
    GridStat_DWork->err_max_Q = GridStat_DWork->err_act_Q;
  }

  if (GridStat_DWork->ctr_acterr_Q > 4) {
    GridStat_DWork->ctr_acterr_Q = 0;
  }

  i = GridStat_DWork->ctr_err_Q + 1;
  if (GridStat_DWork->ctr_err_Q + 1 > 32767) {
    i = 32767;
  }

  GridStat_DWork->ctr_err_Q = (int16_T)i;
  if (GridStat_DWork->ctr_err_Q >= 1000) {
    GridStat_DWork->ctr_err_Q = 0;
    GridStat_DWork->flag_window_Q = true;
  }

  rtb_RelationalOperator_b = false;
  rtb_Divide4_h = (real32_T)(int16_T)tmp / 2.0F;
  if ((int16_T)tmp == 0) {
    rtb_Divide4_h = 0.25F;
  }

  if (1.0E-8F >= GridStat_DWork->err_min) {
    rtb_Product5 = 1.0E-8F;
  } else {
    rtb_Product5 = GridStat_DWork->err_min;
  }

  if (GridStat_DWork->err_act / rtb_Product5 > rtb_Divide4_h * 15.0F) {
    rtb_RelationalOperator_b = true;
  } else {
    if (1.0E-8F >= GridStat_DWork->err_min_Q) {
      rtb_Product5 = 1.0E-8F;
    } else {
      rtb_Product5 = GridStat_DWork->err_min_Q;
    }

    if (GridStat_DWork->err_act_Q / rtb_Product5 > rtb_Divide4_h * 3.5F) {
      rtb_RelationalOperator_b = true;
    }
  }

  /* MultiPortSwitch: '<S2>/Multiport Switch' incorporates:
   *  Logic: '<S2>/Logical Operator'
   *  Logic: '<S2>/Logical Operator1'
   */
  /* '<S52>:1:2' */
  switch (GridStat_B->BusInput.iDetectMode) {
   case 1:
    rtb_trigger_LVRT_l = GridStat_B->TpDetNabsProtTrigger.LogicalOperator1;
    break;

   case 2:
    rtb_trigger_LVRT_l = GridStat_B->TpDetVPNTrigger.LogicalOperator1;
    break;

   default:
    rtb_trigger_LVRT_l = (GridStat_B->TpDetNabsProtTrigger.LogicalOperator1 ||
                          GridStat_B->TpDetVPNTrigger.LogicalOperator1 ||
                          (GridStat_B->BusInput.bEnable_SmoothDetection &&
      rtb_RelationalOperator_b));
    break;
  }

  /* End of MultiPortSwitch: '<S2>/Multiport Switch' */

  /* Logic: '<S2>/Logical Operator3' incorporates:
   *  Logic: '<S2>/Logical Operator5'
   */
  rtb_LogicalOperator3 = ((rtb_AND || GridStat_B->TofMcbFb.LogicalOperator1) &&
    GridStat_B->BusInput.bEnable && rtb_trigger_LVRT_l);

  /* Outputs for Atomic SubSystem: '<S2>/TofReset' */
  GridStat_TofLvrtWeakBlk1(rtb_LogicalOperator3,
    GridStat_B->BusInput.rTi_Filt_factorNoffsetCorr, &GridStat_B->TofReset,
    &GridStat_DWork->TofReset, inst);

  /* End of Outputs for SubSystem: '<S2>/TofReset' */

  /* Outputs for Atomic SubSystem: '<S2>/Filter' */
  /* RelationalOperator: '<S3>/Relational Operator' incorporates:
   *  Constant: '<S3>/Constant'
   */
  rtb_trigger_LVRT_l = (GridStat_B->BusInput.rTi_Filt_factorNoffsetCorr > 0.0F);

  /* Logic: '<S3>/Logical Operator' incorporates:
   *  Logic: '<S3>/Logical Operator1'
   */
  rtb_LogicalOperator_b = (GridStat_B->TofReset.LogicalOperator1 ||
    (!rtb_trigger_LVRT_l));

  /* DiscreteIntegrator: '<S3>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator_b || (GridStat_DWork->DiscreteTimeIntegrator_PrevRe_g
       != 0)) {
    GridStat_DWork->DiscreteTimeIntegrator_DSTATE = 0.0;
  }

  /* Switch: '<S3>/Switch' incorporates:
   *  Constant: '<S2>/Constant12'
   *  DiscreteIntegrator: '<S3>/Discrete-Time Integrator'
   */
  if (rtb_trigger_LVRT_l) {
    rtb_Switch = GridStat_DWork->DiscreteTimeIntegrator_DSTATE;
  } else {
    rtb_Switch = 1.0;
  }

  /* End of Switch: '<S3>/Switch' */

  /* Switch: '<S9>/Switch' incorporates:
   *  Abs: '<S9>/Abs'
   *  RelationalOperator: '<S9>/Relational Operator'
   */
  if (2.22044605E-16F >= (real32_T)fabs
      (GridStat_B->BusInput.rTi_Filt_factorNoffsetCorr)) {
    rtb_Product5 = 2.22044605E-16F;
  } else {
    rtb_Product5 = GridStat_B->BusInput.rTi_Filt_factorNoffsetCorr;
  }

  /* End of Switch: '<S9>/Switch' */

  /* Update for DiscreteIntegrator: '<S3>/Discrete-Time Integrator' incorporates:
   *  Constant: '<S2>/Constant12'
   *  Product: '<S3>/Divide4'
   *  Sum: '<S3>/Sum4'
   */
  GridStat_DWork->DiscreteTimeIntegrator_DSTATE += (1.0 -
    GridStat_DWork->DiscreteTimeIntegrator_DSTATE) / rtb_Product5 * 0.01;
  GridStat_DWork->DiscreteTimeIntegrator_PrevRe_g = (int8_T)
    rtb_LogicalOperator_b;

  /* End of Outputs for SubSystem: '<S2>/Filter' */

  /* Logic: '<S2>/Logical Operator4' */
  rtb_trigger_LVRT_l = !rtb_AND;

  /* Delay: '<S2>/IslandDetected' */
  GridStat_DWork->icLoad = ((((GridStat_PrevZCSigState->IslandDetected_Reset_ZCE
    == 1) != (int32_T)GridStat_B->BusInput2.bReset) &&
    (GridStat_PrevZCSigState->IslandDetected_Reset_ZCE != 3)) ||
    GridStat_B->BusInput2.bReset || GridStat_DWork->icLoad);
  GridStat_PrevZCSigState->IslandDetected_Reset_ZCE =
    GridStat_B->BusInput2.bReset;
  GridStat_DWork->IslandDetected_DSTATE = ((!GridStat_DWork->icLoad) &&
    GridStat_DWork->IslandDetected_DSTATE);

  /* Switch: '<S2>/Switch1' incorporates:
   *  Delay: '<S2>/IslandDetected'
   *  Logic: '<S2>/Logical Operator6'
   */
  if (rtb_trigger_LVRT_l || rtb_LogicalOperator3) {
    rtb_AND = rtb_LogicalOperator3;
  } else {
    rtb_AND = GridStat_DWork->IslandDetected_DSTATE;
  }

  /* End of Switch: '<S2>/Switch1' */

  /* Logic: '<Root>/Logical Operator' incorporates:
   *  Logic: '<S2>/Logical Operator2'
   */
  GridStat_Y->Out.bGridStatus = ((!rtb_trigger_LVRT_l) && (!rtb_AND));

  /* Product: '<S2>/Product' */
  u0 = rtb_Switch * GridStat_B->BusInput2.rN_F_Offset_Norm;

  /* MinMax: '<S2>/MinMax1' */
  if (u0 <= GridStat_B->BusInput2.rN_F_Offset_Norm) {
    /* BusCreator: '<Root>/Bus Creator1' incorporates:
     *  DataTypeConversion: '<Root>/Data Type Conversion1'
     *  Outport: '<Root>/Out'
     */
    GridStat_Y->Out.rN_F_Offset_Norm_corr = (real32_T)u0;
  } else {
    /* BusCreator: '<Root>/Bus Creator1' incorporates:
     *  Outport: '<Root>/Out'
     */
    GridStat_Y->Out.rN_F_Offset_Norm_corr =
      GridStat_B->BusInput2.rN_F_Offset_Norm;
  }

  /* End of MinMax: '<S2>/MinMax1' */

  /* BusCreator generated from: '<Root>/dbg' incorporates:
   *  DataTypeConversion: '<S2>/Data Type Conversion1'
   *  MATLAB Function: '<S5>/Grid Observer'
   *  Outport: '<Root>/dbg'
   */
  GridStat_Y->dbg.rProt_norm = rtb_Saturation;
  GridStat_Y->dbg.bDetSpeedRise =
    GridStat_B->TpDetNabsProtTrigger.LogicalOperator1;
  GridStat_Y->dbg.bDetIslandVPN = GridStat_B->TpDetVPNTrigger.LogicalOperator1;
  GridStat_Y->dbg.trigger_Nabs = rtb_RelationalOperator;
  GridStat_Y->dbg.trigger_Prot = rtb_LogicalOperator_i;
  GridStat_Y->dbg.trigger_PU = rtb_trigger_PU;
  GridStat_Y->dbg.trigger_N = rtb_trigger_N;
  GridStat_Y->dbg.trigger_U = rtb_trigger_U;
  GridStat_Y->dbg.trigger_P = rtb_trigger_P;
  GridStat_Y->dbg.trigger_VS = GridStat_B->BusInput2.bVectorShift;
  GridStat_Y->dbg.block_LVRT_VPN = rtb_Switch6;
  GridStat_Y->dbg.trigger_LVRT_NoDelay = rtb_RelationalOperator3_dy;
  GridStat_Y->dbg.rCorrFac_rN_set_Norm = (real32_T)rtb_Switch;
  GridStat_Y->dbg.block_LVRT_speedAbs = rtb_RelationalOperator3;
  GridStat_Y->dbg.bDetGridObserver = rtb_RelationalOperator_b;
  for (i = 0; i < 9; i++) {
    GridStat_Y->dbg.ru_obs[i] = 0.0F;
    GridStat_Y->dbg.ru_obs_strong[i] = 0.0F;
    GridStat_Y->dbg.ru_obs3[i] = 0.0F;
  }

  GridStat_Y->dbg.ry_obs[0] = 0.0F;
  GridStat_Y->dbg.ry_obs[1] = 0.0F;
  for (i = 0; i < 5; i++) {
    GridStat_Y->dbg.rx_obs[i] = 0.0F;
    GridStat_Y->dbg.rx_obs_strong[i] = 0.0F;
    GridStat_Y->dbg.rx_obs3[i] = 0.0F;
    GridStat_Y->dbg.rcorr[i] = 0.0F;
    GridStat_Y->dbg.rcorr_strong[i] = 0.0F;
    GridStat_Y->dbg.rcorr3[i] = 0.0F;
  }

  /* End of BusCreator generated from: '<Root>/dbg' */

  /* S-Function (bur_bus_out): '<Root>/Bus Output' incorporates:
   *  Outport: '<Root>/Out'
   */
  inst->Out = GridStat_Y->Out;

  /* BusCreator generated from: '<Root>/Bus Output1' incorporates:
   *  DataTypeConversion: '<S2>/Data Type Conversion1'
   *  MATLAB Function: '<S5>/Grid Observer'
   */
  GridStat_B->BusConversion_InsertedFor_BusOu.rProt_norm = rtb_Saturation;
  GridStat_B->BusConversion_InsertedFor_BusOu.bDetSpeedRise =
    GridStat_B->TpDetNabsProtTrigger.LogicalOperator1;
  GridStat_B->BusConversion_InsertedFor_BusOu.bDetIslandVPN =
    GridStat_B->TpDetVPNTrigger.LogicalOperator1;
  GridStat_B->BusConversion_InsertedFor_BusOu.trigger_Nabs =
    rtb_RelationalOperator;
  GridStat_B->BusConversion_InsertedFor_BusOu.trigger_Prot =
    rtb_LogicalOperator_i;
  GridStat_B->BusConversion_InsertedFor_BusOu.trigger_PU = rtb_trigger_PU;
  GridStat_B->BusConversion_InsertedFor_BusOu.trigger_N = rtb_trigger_N;
  GridStat_B->BusConversion_InsertedFor_BusOu.trigger_U = rtb_trigger_U;
  GridStat_B->BusConversion_InsertedFor_BusOu.trigger_P = rtb_trigger_P;
  GridStat_B->BusConversion_InsertedFor_BusOu.trigger_VS =
    GridStat_B->BusInput2.bVectorShift;
  GridStat_B->BusConversion_InsertedFor_BusOu.block_LVRT_VPN = rtb_Switch6;
  GridStat_B->BusConversion_InsertedFor_BusOu.trigger_LVRT_NoDelay =
    rtb_RelationalOperator3_dy;
  GridStat_B->BusConversion_InsertedFor_BusOu.rCorrFac_rN_set_Norm = (real32_T)
    rtb_Switch;
  GridStat_B->BusConversion_InsertedFor_BusOu.block_LVRT_speedAbs =
    rtb_RelationalOperator3;
  GridStat_B->BusConversion_InsertedFor_BusOu.bDetGridObserver =
    rtb_RelationalOperator_b;
  for (i = 0; i < 9; i++) {
    GridStat_B->BusConversion_InsertedFor_BusOu.ru_obs[i] = 0.0F;
    GridStat_B->BusConversion_InsertedFor_BusOu.ru_obs_strong[i] = 0.0F;
    GridStat_B->BusConversion_InsertedFor_BusOu.ru_obs3[i] = 0.0F;
  }

  GridStat_B->BusConversion_InsertedFor_BusOu.ry_obs[0] = 0.0F;
  GridStat_B->BusConversion_InsertedFor_BusOu.ry_obs[1] = 0.0F;
  for (i = 0; i < 5; i++) {
    GridStat_B->BusConversion_InsertedFor_BusOu.rx_obs[i] = 0.0F;
    GridStat_B->BusConversion_InsertedFor_BusOu.rx_obs_strong[i] = 0.0F;
    GridStat_B->BusConversion_InsertedFor_BusOu.rx_obs3[i] = 0.0F;
    GridStat_B->BusConversion_InsertedFor_BusOu.rcorr[i] = 0.0F;
    GridStat_B->BusConversion_InsertedFor_BusOu.rcorr_strong[i] = 0.0F;
    GridStat_B->BusConversion_InsertedFor_BusOu.rcorr3[i] = 0.0F;
  }

  /* End of BusCreator generated from: '<Root>/Bus Output1' */

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Dbg = GridStat_B->BusConversion_InsertedFor_BusOu;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  GridStat_B->BusInput1 = inst->Perm;

  /* UnitDelay: '<S1>/Unit Delay' */
  GridStat_B->UnitDelay = GridStat_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Bus Output2' */
  inst->Version = GridStat_B->UnitDelay;
  for (i = 0; i < 9; i++) {
    /* Update for S-Function (sfix_udelay): '<S8>/Tapped Delay' */
    GridStat_DWork->TappedDelay_X[9 - i] = GridStat_DWork->TappedDelay_X[8 - i];

    /* Update for S-Function (sfix_udelay): '<S8>/Tapped Delay1' */
    GridStat_DWork->TappedDelay1_X[9 - i] = GridStat_DWork->TappedDelay1_X[8 - i];

    /* Update for S-Function (sfix_udelay): '<S8>/Tapped Delay2' */
    GridStat_DWork->TappedDelay2_X[9 - i] = GridStat_DWork->TappedDelay2_X[8 - i];

    /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay' */
    GridStat_DWork->TappedDelay_X_l[9 - i] = GridStat_DWork->TappedDelay_X_l[8 -
      i];

    /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay2' */
    GridStat_DWork->TappedDelay2_X_b[9 - i] = GridStat_DWork->TappedDelay2_X_b[8
      - i];

    /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay3' */
    GridStat_DWork->TappedDelay3_X[9 - i] = GridStat_DWork->TappedDelay3_X[8 - i];

    /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay5' */
    GridStat_DWork->TappedDelay5_X[9 - i] = GridStat_DWork->TappedDelay5_X[8 - i];

    /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay4' */
    GridStat_DWork->TappedDelay4_X[9 - i] = GridStat_DWork->TappedDelay4_X[8 - i];

    /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay1' */
    GridStat_DWork->TappedDelay1_X_m[9 - i] = GridStat_DWork->TappedDelay1_X_m[8
      - i];
  }

  /* Update for S-Function (sfix_udelay): '<S8>/Tapped Delay' */
  GridStat_DWork->TappedDelay_X[0] = GridStat_B->BusInput2.rU_norm;

  /* Update for S-Function (sfix_udelay): '<S8>/Tapped Delay1' */
  GridStat_DWork->TappedDelay1_X[0] = GridStat_B->BusInput2.rP_norm;

  /* Update for S-Function (sfix_udelay): '<S8>/Tapped Delay2' */
  GridStat_DWork->TappedDelay2_X[0] = GridStat_B->BusInput2.rN_engAct;

  /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay' */
  GridStat_DWork->TappedDelay_X_l[0] = GridStat_B->BusInput2.rp2s_norm;

  /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay2' */
  GridStat_DWork->TappedDelay2_X_b[0] = GridStat_B->BusInput2.rP_norm;

  /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay3' */
  GridStat_DWork->TappedDelay3_X[0] = GridStat_B->BusInput2.rN_engAct;

  /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay5' */
  GridStat_DWork->TappedDelay5_X[0] = GridStat_B->BusInput2.rQ_norm;

  /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay4' */
  GridStat_DWork->TappedDelay4_X[0] = GridStat_B->BusInput2.rU_norm;

  /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay1' */
  GridStat_DWork->TappedDelay1_X_m[0] = GridStat_B->BusInput2.rUexc_norm;

  /* Update for Delay: '<S2>/IslandDetected' */
  GridStat_DWork->icLoad = false;
  GridStat_DWork->IslandDetected_DSTATE = rtb_AND;

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  GridStat_DWork->UnitDelay_DSTATE = 202U;
}

/* Model initialize function */
void GridStat_initialize(RT_MODEL_GridStat *const GridStat_M, struct fGridStat* inst)
{
  struct D_Work_GridStat *GridStat_DWork = GridStat_M->dwork;
  struct PrevZCSigStates_GridStat *GridStat_PrevZCSigState = GridStat_M->prevZCSigState;
  GridStat_PrevZCSigState->IslandDetected_Reset_ZCE = UNINITIALIZED_ZCSIG;

  /* InitializeConditions for Delay: '<S2>/IslandDetected' */
  GridStat_DWork->icLoad = true;

  /* SystemInitialize for Atomic SubSystem: '<S2>/TofMcbFb' */
  GridStat_TofLvrtWeakBlk1_Init(&GridStat_DWork->TofMcbFb, inst);

  /* End of SystemInitialize for SubSystem: '<S2>/TofMcbFb' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/TpNabsTrigger' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpNabsTrigger, inst);

  /* End of SystemInitialize for SubSystem: '<S4>/TpNabsTrigger' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/Speed_filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  GridStat_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* End of SystemInitialize for SubSystem: '<S4>/Speed_filter' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/TpProtTrigger' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpProtTrigger, inst);

  /* End of SystemInitialize for SubSystem: '<S4>/TpProtTrigger' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/TpLvrtBlockHold1' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpLvrtBlockHold1, inst);

  /* End of SystemInitialize for SubSystem: '<S4>/TpLvrtBlockHold1' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/TofLvrtWeakBlk1' */
  GridStat_TofLvrtWeakBlk1_Init(&GridStat_DWork->TofLvrtWeakBlk1, inst);

  /* End of SystemInitialize for SubSystem: '<S4>/TofLvrtWeakBlk1' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/TpLvrtTrigHold1' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpLvrtTrigHold1, inst);

  /* End of SystemInitialize for SubSystem: '<S4>/TpLvrtTrigHold1' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/TpDetNabsProtTrigger' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpDetNabsProtTrigger, inst);

  /* End of SystemInitialize for SubSystem: '<S4>/TpDetNabsProtTrigger' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TofLvrtWeakBlk2' */
  GridStat_TofLvrtWeakBlk1_Init(&GridStat_DWork->TofLvrtWeakBlk2, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TofLvrtWeakBlk2' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TpLvrtTrigHold2' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpLvrtTrigHold2, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TpLvrtTrigHold2' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TofAfterFRT' */
  GridStat_TofLvrtWeakBlk1_Init(&GridStat_DWork->TofAfterFRT, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TofAfterFRT' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TpUTrigger' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpUTrigger, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TpUTrigger' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TpPTrigger' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpPTrigger, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TpPTrigger' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TP_PU_trigger' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TP_PU_trigger, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TP_PU_trigger' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TpNTrigger' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpNTrigger, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TpNTrigger' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TpLvrtBlockHold2' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpLvrtBlockHold2, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TpLvrtBlockHold2' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/TpDetVPNTrigger' */
  GridS_TpDetNabsProtTrigger_Init(&GridStat_DWork->TpDetVPNTrigger, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/TpDetVPNTrigger' */

  /* SystemInitialize for Atomic SubSystem: '<S2>/TofReset' */
  GridStat_TofLvrtWeakBlk1_Init(&GridStat_DWork->TofReset, inst);

  /* End of SystemInitialize for SubSystem: '<S2>/TofReset' */
}

/* Model terminate function */
void GridStat_terminate(RT_MODEL_GridStat *const GridStat_M, struct fGridStat* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(GridStat_M);
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.11 (R2021b)14-May-2021                                            *
 * Simulink 10.4 (R2021b)14-May-2021                                          *
 * Simulink Coder 9.6 (R2021b)14-May-2021                                     *
 * Embedded Coder 7.7 (R2021b)14-May-2021                                     *
 * Stateflow 10.5 (R2021b)14-May-2021                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
