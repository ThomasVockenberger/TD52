/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: TrStRed
 * File: TrStRed.c
 * Author: 105055527
 * Last modified by: maranen00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Mon Dec 06 12:59:10 2021
 * Model Version: 0.3.0
 * Description: Thermal reactor start time reduction function

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.1.0 18.05.2021 Maran   TrStRed function first draft
   V0.1.1 27.05.2021 Maran   added limitation based on cyl. EG max temp. above setpoint
   V0.1.2 02.08.2021 Maran   added half load factor for function limit range
   V0.2.0 15.11.2021 Maran   added saturation limits to control error for the closed loop integrator (PERM parameters)
   V0.3.0 06.12.2021 Maran   removed unused logic in controller block; added filtered value of monitoring variables in debug interface
 ********************************************************************
 * Implementation of program TrStRed
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.1
 * (ERT based)
 ********************************************************************/

#include "TrStRed.h"
#include "TrStRed_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_real32_T */
void BINARYSEARCH_real32_T(uint32_T *piLeft, uint32_T *piRght, real32_T u, const
  real32_T *pData, uint32_T iHi, struct fTrStRed* inst)
{
  /* Find the location of current input value in the data table. */
  *piLeft = 0U;
  *piRght = iHi;
  if (u <= pData[0] ) {
    /* Less than or equal to the smallest point in the table. */
    *piRght = 0U;
  } else if (u >= pData[iHi] ) {
    /* Greater than or equal to the largest point in the table. */
    *piLeft = iHi;
  } else {
    uint32_T i;

    /* Do a binary search. */
    while (( *piRght - *piLeft ) > 1U ) {
      /* Get the average of the left and right indices using to Floor rounding. */
      i = (*piLeft + *piRght) >> 1;

      /* Move either the right index or the left index so that */
      /*  LeftDataPoint <= CurrentValue < RightDataPoint */
      if (u < pData[i] ) {
        *piRght = i;
      } else {
        *piLeft = i;
      }
    }
  }
}

/* Lookup Utility LookUp_real32_T_real32_T */
void LookUp_real32_T_real32_T(real32_T *pY, const real32_T *pYData, real32_T u,
  const real32_T *pUData, uint32_T iHi, struct fTrStRed* inst)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_real32_T( &(iLeft), &(iRght), u, pUData, iHi, inst);

  {
    real32_T lambda;
    if (pUData[iRght] > pUData[iLeft] ) {
      real32_T num;
      real32_T den;
      den = pUData[iRght];
      den -= pUData[iLeft];
      num = u;
      num -= pUData[iLeft];
      lambda = num / den;
    } else {
      lambda = 0.0F;
    }

    {
      real32_T yLeftCast;
      real32_T yRghtCast;
      yLeftCast = pYData[iLeft];
      yRghtCast = pYData[iRght];
      yLeftCast += lambda * ( yRghtCast - yLeftCast );
      (*pY) = yLeftCast;
    }
  }
}

/*
 * System initialize for atomic system:
 *    '<S6>/Filter'
 *    '<S6>/Filter1'
 */
void TrStRed_Filter_Init(rtDW_Filter_TrStRed *localDW, struct fTrStRed* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S6>/Filter'
 *    '<S6>/Filter1'
 */
void TrStRed_Filter(real32_T rtu_in, real32_T rtu_T_filt, boolean_T rtu_reset,
                    rtB_Filter_TrStRed *localB, rtDW_Filter_TrStRed *localDW, struct fTrStRed* inst)
{
  boolean_T rtb_RelationalOperator_bj;
  boolean_T rtb_LogicalOperator_f;
  real32_T tmp;

  /* RelationalOperator: '<S17>/Relational Operator' incorporates:
   *  Constant: '<S17>/Constant'
   */
  rtb_RelationalOperator_bj = (rtu_T_filt > 0.0F);

  /* Logic: '<S17>/Logical Operator' incorporates:
   *  Logic: '<S17>/Logical Operator1'
   */
  rtb_LogicalOperator_f = (rtu_reset || (!rtb_RelationalOperator_bj));

  /* DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  if (rtb_LogicalOperator_f || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  /* Switch: '<S17>/Switch' incorporates:
   *  DiscreteIntegrator: '<S17>/Discrete-Time Integrator'
   */
  if (rtb_RelationalOperator_bj) {
    localB->Switch = localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    localB->Switch = rtu_in;
  }

  /* End of Switch: '<S17>/Switch' */

  /* Update for DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Switch: '<S28>/Switch' incorporates:
   *  Abs: '<S28>/Abs'
   *  RelationalOperator: '<S28>/Relational Operator'
   */
  if (2.22044605E-16F >= (real32_T)fabs(rtu_T_filt)) {
    tmp = 2.22044605E-16F;
  } else {
    tmp = rtu_T_filt;
  }

  /* End of Switch: '<S28>/Switch' */

  /* Update for DiscreteIntegrator: '<S17>/Discrete-Time Integrator' incorporates:
   *  Product: '<S17>/Divide4'
   *  Sum: '<S17>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (rtu_in -
    localDW->DiscreteTimeIntegrator_DSTATE) / tmp * 0.01F;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator_f;
}

/*
 * Output and update for atomic system:
 *    '<S8>/TON'
 *    '<S10>/TON'
 */
void TrStRed_TON(boolean_T rtu_IN, uint16_T rtu_PT, rtB_TON_TrStRed *localB,
                 rtDW_TON_TrStRed *localDW, struct fTrStRed* inst)
{
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_RelationalOperator_a;
  uint32_T tmp;

  /* Logic: '<S34>/Logical Operator2' */
  rtb_LogicalOperator2 = !rtu_IN;

  /* DiscreteIntegrator: '<S34>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2 || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = 0U;
  }

  /* RelationalOperator: '<S34>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S34>/Discrete-Time Integrator'
   */
  tmp = localDW->DiscreteTimeIntegrator_DSTATE * 41943U;
  rtb_RelationalOperator_a = (((tmp & 32U) != 0U) + (tmp >> 6) >= ((uint32_T)
    rtu_PT << 16));

  /* Logic: '<S34>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_a && rtu_IN);

  /* Update for DiscreteIntegrator: '<S34>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S34>/Logical Operator'
   *  Logic: '<S34>/Logical Operator1'
   */
  localDW->DiscreteTimeIntegrator_DSTATE = (uint16_T)((uint32_T)
    ((!rtb_RelationalOperator_a) && rtu_IN) +
    localDW->DiscreteTimeIntegrator_DSTATE);
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator2;
}

/* Model step function */
void TrStRed_step(RT_MODEL_TrStRed *const TrStRed_M, struct fTrStRed* inst)
{
  struct BlockIO_TrStRed *TrStRed_B = ((struct BlockIO_TrStRed *) TrStRed_M->blockIO);
  struct D_Work_TrStRed *TrStRed_DWork = ((struct D_Work_TrStRed *) TrStRed_M->dwork);
  struct PrevZCSigStates_TrStRed *TrStRed_PrevZCSigState = ((struct PrevZCSigStates_TrStRed *)
    TrStRed_M->prevZCSigState);
  ExternalOutputs_TrStRed *TrStRed_Y = (ExternalOutputs_TrStRed *)
    TrStRed_M->outputs;
  int32_T rowIdx;
  real32_T rtb_Switch2;
  real32_T rtb_Switch2_e;
  real32_T rtb_Subtract5;
  real32_T rtb_Product;
  real32_T rtb_Saturation1;
  real32_T rtb_Product1;
  boolean_T rtb_RelationalOperator_c;
  boolean_T rtb_LowerRelop1_c;
  real32_T rtb_DiscreteTimeIntegrator;
  real32_T rtb_Subtract;
  real32_T rtb_TmpSignalConversionAtLookup[2];
  real32_T rtb_TmpSignalConversionAtLook_f[2];
  boolean_T rtb_Logic_b_idx_0;
  boolean_T rtb_Logic_idx_0;
  boolean_T rtb_Logic_e_idx_0;
  real32_T u0;
  real32_T u0_0;
  real32_T u0_1;
  real32_T u0_2;
  uint32_T rtb_Logic_idx_0_tmp;
  boolean_T rtb_Logic_idx_0_tmp_0;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  TrStRed_B->BusInput1 = inst->Perm;

  /* Product: '<S20>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S20>/sample time'
   *  Switch: '<S4>/Environment Switch'
   *
   * About '<S20>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2 = TrStRed_B->BusInput1.rCA_RateLimit * 0.01F;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  TrStRed_B->BusInput2 = inst->In;

  /* Switch: '<S2>/Environment Switch' */
  rtb_Product1 = TrStRed_B->BusInput2.rP_Set_Norm;

  /* Outputs for Atomic SubSystem: '<S8>/TON' */
  /* Logic: '<S8>/Logical Operator' incorporates:
   *  Abs: '<S8>/Abs'
   *  RelationalOperator: '<S8>/Relational Operator'
   *  Sum: '<S8>/Sum'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S4>/Environment Switch'
   */
  TrStRed_TON(TrStRed_B->BusInput2.bTrStRed_active && ((real32_T)fabs
    (TrStRed_B->BusInput2.rP_Norm - rtb_Product1) <=
    TrStRed_B->BusInput1.rP_diffThres_Steady),
              TrStRed_B->BusInput1.iTimerDelay_Steady, &TrStRed_B->TON,
              &TrStRed_DWork->TON, inst);

  /* End of Outputs for SubSystem: '<S8>/TON' */

  /* CombinatorialLogic: '<S37>/Logic' incorporates:
   *  CombinatorialLogic: '<S36>/Logic'
   *  Logic: '<S9>/Logical Operator2'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_Logic_idx_0_tmp = (uint32_T)(TrStRed_B->BusInput2.bTrStRed_active &&
    TrStRed_B->TON.LogicalOperator3) << 1;

  /* Logic: '<S9>/NOT1' incorporates:
   *  Logic: '<S6>/Logical Operator'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_Logic_idx_0_tmp_0 = !TrStRed_B->BusInput2.bTrStRed_active;

  /* CombinatorialLogic: '<S37>/Logic' incorporates:
   *  Logic: '<S9>/NOT1'
   *  Memory: '<S37>/Memory'
   */
  rtb_Logic_idx_0 = TrStRed_ConstP.pooled10[((rtb_Logic_idx_0_tmp +
    rtb_Logic_idx_0_tmp_0) << 1) + TrStRed_DWork->Memory_PreviousInput];

  /* CombinatorialLogic: '<S36>/Logic' incorporates:
   *  Memory: '<S36>/Memory'
   *  Switch: '<S2>/Environment Switch'
   */
  rowIdx = (int32_T)(((rtb_Logic_idx_0_tmp + TrStRed_B->BusInput2.bCycleReset) <<
                      1) + TrStRed_DWork->Memory_PreviousInput_o);
  rtb_Logic_b_idx_0 = TrStRed_ConstP.pooled10[(uint32_T)rowIdx];

  /* Outputs for Atomic SubSystem: '<S10>/TON' */
  /* Switch: '<S2>/Environment Switch' incorporates:
   *  Switch: '<S4>/Environment Switch'
   */
  TrStRed_TON(TrStRed_B->BusInput2.bThR_RelGas, TrStRed_B->BusInput1.iStopTimer,
              &TrStRed_B->TON_k, &TrStRed_DWork->TON_k, inst);

  /* End of Outputs for SubSystem: '<S10>/TON' */

  /* CombinatorialLogic: '<S38>/Logic' incorporates:
   *  CombinatorialLogic: '<S36>/Logic'
   *  Logic: '<S10>/Logical Operator'
   *  Memory: '<S38>/Memory'
   *  Switch: '<S2>/Environment Switch'
   */
  rowIdx = (int32_T)(((((uint32_T)(TrStRed_ConstP.pooled10[(uint32_T)rowIdx] &&
    TrStRed_B->TON_k.LogicalOperator3) << 1) + TrStRed_B->BusInput2.bCycleReset)
                      << 1) + TrStRed_DWork->Memory_PreviousInput_l);
  rtb_Logic_e_idx_0 = TrStRed_ConstP.pooled10[(uint32_T)rowIdx];

  /* Logic: '<Root>/NOT8' incorporates:
   *  CombinatorialLogic: '<S38>/Logic'
   *  Logic: '<Root>/NOT1'
   */
  rtb_LowerRelop1_c = ((!rtb_Logic_idx_0) || TrStRed_ConstP.pooled10[(uint32_T)
                       rowIdx]);

  /* Logic: '<Root>/NOT6' incorporates:
   *  Logic: '<Root>/Logical Operator1'
   *  Logic: '<Root>/NOT7'
   *  Switch: '<S2>/Environment Switch'
   *  UnitDelay: '<Root>/Unit Delay'
   */
  rtb_RelationalOperator_c = ((TrStRed_DWork->UnitDelay_DSTATE_j &&
    rtb_LowerRelop1_c) || TrStRed_B->BusInput2.bReset || (!rtb_Logic_b_idx_0));

  /* DiscreteIntegrator: '<S1>/Discrete-Time Integrator' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  if (TrStRed_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    TrStRed_DWork->ITCtrUi = TrStRed_B->BusInput2.rCA_Ign_UpLim;
  }

  if (rtb_RelationalOperator_c ||
      (TrStRed_DWork->DiscreteTimeIntegrator_PrevRese != 0)) {
    TrStRed_DWork->ITCtrUi = TrStRed_B->BusInput2.rCA_Ign_UpLim;
  }

  rtb_DiscreteTimeIntegrator = TrStRed_DWork->ITCtrUi;

  /* Product: '<S21>/delta rise limit' incorporates:
   *  Gain: '<S6>/Gain1'
   *  SampleTimeMath: '<S21>/sample time'
   *  Switch: '<S4>/Environment Switch'
   *
   * About '<S21>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_e = 100.0F * TrStRed_B->BusInput1.rCA_RateLimit * 0.01F;

  /* Gain: '<S6>/misfire_Lim [%]' incorporates:
   *  Switch: '<S4>/Environment Switch'
   */
  rtb_Product = 100.0F * TrStRed_B->BusInput1.rMisfire_Lim;

  /* Sum: '<S6>/Subtract5' incorporates:
   *  Gain: '<S6>/misfire [%]'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_Subtract5 = rtb_Product - 100.0F * TrStRed_B->BusInput2.rMisfire_level;

  /* Switch: '<S13>/Switch' incorporates:
   *  Abs: '<S13>/Abs'
   *  RelationalOperator: '<S13>/Relational Operator'
   */
  if (0.1F >= (real32_T)fabs(rtb_Product)) {
    rtb_Product = 0.1F;
  }

  /* End of Switch: '<S13>/Switch' */

  /* Product: '<S6>/Divide3' */
  rtb_Product = rtb_Subtract5 / rtb_Product;

  /* Saturate: '<S6>/Saturation3' */
  if (rtb_Product > 1.0F) {
    rtb_Product = 1.0F;
  } else {
    if (rtb_Product < 0.0F) {
      rtb_Product = 0.0F;
    }
  }

  /* End of Saturate: '<S6>/Saturation3' */

  /* Outputs for Atomic SubSystem: '<S6>/Filter1' */
  /* Switch: '<S2>/Environment Switch' incorporates:
   *  Switch: '<S4>/Environment Switch'
   */
  TrStRed_Filter(TrStRed_B->BusInput2.rIgnVolt_Max,
                 TrStRed_B->BusInput1.rFiltConst_IgnVolt, rtb_Logic_idx_0_tmp_0,
                 &TrStRed_B->Filter1, &TrStRed_DWork->Filter1, inst);

  /* End of Outputs for SubSystem: '<S6>/Filter1' */

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  TrStRed_B->BusInput = inst->Para;

  /* Outputs for Atomic SubSystem: '<S6>/Filter' */
  /* Switch: '<S2>/Environment Switch' incorporates:
   *  Switch: '<S4>/Environment Switch'
   */
  TrStRed_Filter(TrStRed_B->BusInput2.rPr_Leanox_Dev,
                 TrStRed_B->BusInput1.rFiltConst_LxDev, rtb_Logic_idx_0_tmp_0,
                 &TrStRed_B->Filter, &TrStRed_DWork->Filter, inst);

  /* End of Outputs for SubSystem: '<S6>/Filter' */

  /* Gain: '<S6>/Gain' incorporates:
   *  Switch: '<S4>/Environment Switch'
   */
  rtb_Saturation1 = 0.5F * TrStRed_B->BusInput1.rPr_LxDev_Lim;

  /* Switch: '<S14>/Switch' incorporates:
   *  Abs: '<S14>/Abs'
   *  RelationalOperator: '<S14>/Relational Operator'
   */
  if (0.1F >= (real32_T)fabs(rtb_Saturation1)) {
    rtb_Saturation1 = 0.1F;
  }

  /* End of Switch: '<S14>/Switch' */

  /* Product: '<S6>/Divide4' incorporates:
   *  Sum: '<S6>/Subtract6'
   *  Switch: '<S4>/Environment Switch'
   */
  u0 = (TrStRed_B->BusInput1.rPr_LxDev_Lim - TrStRed_B->Filter.Switch) /
    rtb_Saturation1;

  /* Sum: '<S6>/Subtract4' incorporates:
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S4>/Environment Switch'
   */
  rtb_Saturation1 = TrStRed_B->BusInput2.rT_EG_MaxLimit -
    TrStRed_B->BusInput1.rT_EG_Max_LimOffset;

  /* Sum: '<S6>/Subtract1' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_Subtract5 = rtb_Saturation1 - TrStRed_B->BusInput2.rT_EG_CylMax;

  /* MinMax: '<S6>/Max' */
  if (rtb_Subtract5 <= 0.0F) {
    rtb_Subtract5 = 0.0F;
  }

  /* End of MinMax: '<S6>/Max' */

  /* Sum: '<Root>/Subtract' incorporates:
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S3>/Environment Switch'
   */
  rtb_Subtract = TrStRed_B->BusInput2.rT_EG_MaxLimit -
    TrStRed_B->BusInput.rT_EG_Max_LimMarg;

  /* Sum: '<S6>/Subtract3' */
  rtb_Saturation1 -= rtb_Subtract;

  /* MinMax: '<S6>/Max1' */
  if (rtb_Saturation1 <= 0.0F) {
    rtb_Saturation1 = 0.0F;
  }

  /* End of MinMax: '<S6>/Max1' */

  /* Switch: '<S12>/Switch' incorporates:
   *  Abs: '<S12>/Abs'
   *  RelationalOperator: '<S12>/Relational Operator'
   */
  if (0.1F >= rtb_Saturation1) {
    rtb_Saturation1 = 0.1F;
  }

  /* End of Switch: '<S12>/Switch' */

  /* Product: '<S6>/Divide1' */
  rtb_Saturation1 = rtb_Subtract5 / rtb_Saturation1;

  /* Saturate: '<S6>/Saturation1' */
  if (rtb_Saturation1 > 1.0F) {
    rtb_Saturation1 = 1.0F;
  }

  /* End of Saturate: '<S6>/Saturation1' */

  /* Abs: '<S16>/Abs' incorporates:
   *  Switch: '<S4>/Environment Switch'
   */
  rtb_Subtract5 = (real32_T)fabs(TrStRed_B->BusInput1.rT_EGbTC_LimMarg);

  /* Switch: '<S16>/Switch' incorporates:
   *  RelationalOperator: '<S16>/Relational Operator'
   *  Switch: '<S4>/Environment Switch'
   */
  if (0.1F >= rtb_Subtract5) {
    rtb_Subtract5 = 0.1F;
  } else {
    rtb_Subtract5 = TrStRed_B->BusInput1.rT_EGbTC_LimMarg;
  }

  /* End of Switch: '<S16>/Switch' */

  /* Switch: '<S11>/Switch' incorporates:
   *  Abs: '<S11>/Abs'
   *  RelationalOperator: '<S11>/Relational Operator'
   *  Switch: '<S4>/Environment Switch'
   */
  if (0.1F >= (real32_T)fabs(TrStRed_B->BusInput1.rIgnVolt_LimMarg)) {
    u0_1 = 0.1F;
  } else {
    u0_1 = TrStRed_B->BusInput1.rIgnVolt_LimMarg;
  }

  /* End of Switch: '<S11>/Switch' */

  /* Product: '<S6>/Divide' incorporates:
   *  Sum: '<S6>/Subtract2'
   *  Sum: '<S6>/Sum'
   *  Switch: '<S3>/Environment Switch'
   *  Switch: '<S4>/Environment Switch'
   */
  u0_0 = ((TrStRed_B->BusInput.rIgnVoltMax_Lim +
           TrStRed_B->BusInput1.rIgnVolt_LimMarg) - TrStRed_B->Filter1.Switch) /
    u0_1;

  /* Switch: '<S15>/Switch' incorporates:
   *  Abs: '<S15>/Abs'
   *  RelationalOperator: '<S15>/Relational Operator'
   *  Switch: '<S4>/Environment Switch'
   */
  if (0.1F >= (real32_T)fabs(TrStRed_B->BusInput1.rT_EG_Avg_LimMarg)) {
    u0_1 = 0.1F;
  } else {
    u0_1 = TrStRed_B->BusInput1.rT_EG_Avg_LimMarg;
  }

  /* End of Switch: '<S15>/Switch' */

  /* Product: '<S6>/Divide5' incorporates:
   *  Sum: '<S6>/Subtract7'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S3>/Environment Switch'
   */
  u0_1 = (TrStRed_B->BusInput.rT_EG_Avg_HiLim -
          TrStRed_B->BusInput2.rT_EG_CylAvg) / u0_1;

  /* Product: '<S6>/Divide6' incorporates:
   *  Sum: '<S6>/Subtract8'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S3>/Environment Switch'
   */
  u0_2 = (TrStRed_B->BusInput.rT_EGbTC_HiLim - TrStRed_B->BusInput2.rT_EGbTC) /
    rtb_Subtract5;

  /* Saturate: '<S6>/Saturation' */
  if (u0_0 > 1.0F) {
    u0_0 = 1.0F;
  } else {
    if (u0_0 < 0.0F) {
      u0_0 = 0.0F;
    }
  }

  /* End of Saturate: '<S6>/Saturation' */

  /* Saturate: '<S6>/Saturation6' */
  if (u0 > 1.0F) {
    u0 = 1.0F;
  } else {
    if (u0 < 0.0F) {
      u0 = 0.0F;
    }
  }

  /* End of Saturate: '<S6>/Saturation6' */

  /* Saturate: '<S6>/Saturation8' */
  if (u0_1 > 1.0F) {
    u0_1 = 1.0F;
  } else {
    if (u0_1 < 0.0F) {
      u0_1 = 0.0F;
    }
  }

  /* End of Saturate: '<S6>/Saturation8' */

  /* Saturate: '<S6>/Saturation10' */
  if (u0_2 > 1.0F) {
    u0_2 = 1.0F;
  } else {
    if (u0_2 < 0.0F) {
      u0_2 = 0.0F;
    }
  }

  /* End of Saturate: '<S6>/Saturation10' */

  /* Product: '<S6>/Product' */
  rtb_Product = rtb_Product * u0_0 * u0 * u0_1 * rtb_Saturation1 * u0_2;

  /* Product: '<S6>/Product2' incorporates:
   *  Switch: '<S3>/Environment Switch'
   */
  rtb_Product *= TrStRed_B->BusInput.rCA_TrStRed_LowLimit;

  /* Delay: '<S21>/Delay' */
  if ((((TrStRed_PrevZCSigState->Delay_Reset_ZCE == 1) != (int32_T)
        rtb_RelationalOperator_c) && (TrStRed_PrevZCSigState->Delay_Reset_ZCE !=
        3)) || rtb_RelationalOperator_c) {
    TrStRed_DWork->icLoad = 1U;
  }

  TrStRed_PrevZCSigState->Delay_Reset_ZCE = rtb_RelationalOperator_c;
  if (TrStRed_DWork->icLoad != 0) {
    TrStRed_DWork->Delay_DSTATE = rtb_Product;
  }

  /* Sum: '<S21>/Difference Inputs1' incorporates:
   *  Delay: '<S21>/Delay'
   *  Switch: '<S21>/etaVolConst'
   */
  rtb_Product -= TrStRed_DWork->Delay_DSTATE;

  /* Switch: '<S33>/Switch2' incorporates:
   *  RelationalOperator: '<S33>/LowerRelop1'
   */
  if (rtb_Product <= rtb_Switch2_e) {
    /* Product: '<S21>/delta fall limit' incorporates:
     *  Product: '<S6>/Product3'
     *  SampleTimeMath: '<S21>/sample time'
     *  Switch: '<S4>/Environment Switch'
     *  UnaryMinus: '<S6>/Unary Minus1'
     *
     * About '<S21>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch2_e = -(TrStRed_B->BusInput1.rCA_RateLimit *
                      TrStRed_B->BusInput1.rLimitsReleaseFactor) * 0.01F;

    /* Switch: '<S33>/Switch' incorporates:
     *  RelationalOperator: '<S33>/UpperRelop'
     */
    if (rtb_Product >= rtb_Switch2_e) {
      rtb_Switch2_e = rtb_Product;
    }

    /* End of Switch: '<S33>/Switch' */
  }

  /* End of Switch: '<S33>/Switch2' */

  /* Sum: '<S21>/Difference Inputs2' incorporates:
   *  Delay: '<S21>/Delay'
   */
  rtb_Switch2_e += TrStRed_DWork->Delay_DSTATE;

  /* SignalConversion generated from: '<S6>/Lookup Table Dynamic' incorporates:
   *  Constant: '<S6>/Constant2'
   *  Constant: '<S6>/Constant3'
   */
  rtb_TmpSignalConversionAtLookup[0] = 0.5F;
  rtb_TmpSignalConversionAtLookup[1] = 0.9F;

  /* SignalConversion generated from: '<S6>/Lookup Table Dynamic' incorporates:
   *  Constant: '<S6>/Constant4'
   *  Switch: '<S3>/Environment Switch'
   */
  rtb_TmpSignalConversionAtLook_f[0] =
    TrStRed_B->BusInput.rGain_TrStRed_halfLoadLim;
  rtb_TmpSignalConversionAtLook_f[1] = 1.0F;

  /* S-Function (sfix_look1_dyn): '<S6>/Lookup Table Dynamic' */
  /* Dynamic Look-Up Table Block: '<S6>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Subtract5), &rtb_TmpSignalConversionAtLook_f[0],
    rtb_Product1, &rtb_TmpSignalConversionAtLookup[0], 1U, inst);

  /* Product: '<S6>/Product1' */
  rtb_Product1 = rtb_Switch2_e * rtb_Subtract5;

  /* Switch: '<S19>/Switch2' incorporates:
   *  DiscreteIntegrator: '<S1>/Discrete-Time Integrator'
   *  RelationalOperator: '<S19>/LowerRelop1'
   *  RelationalOperator: '<S19>/UpperRelop'
   *  Switch: '<S19>/Switch'
   *  Switch: '<S2>/Environment Switch'
   */
  if (TrStRed_DWork->ITCtrUi > TrStRed_B->BusInput2.rCA_Ign_UpLim) {
    rtb_Subtract5 = TrStRed_B->BusInput2.rCA_Ign_UpLim;
  } else if (TrStRed_DWork->ITCtrUi < rtb_Product1) {
    /* Switch: '<S19>/Switch' */
    rtb_Subtract5 = rtb_Product1;
  } else {
    rtb_Subtract5 = TrStRed_DWork->ITCtrUi;
  }

  /* End of Switch: '<S19>/Switch2' */

  /* Switch: '<S6>/Switch1' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  if (rtb_LowerRelop1_c) {
    rtb_Product = TrStRed_B->BusInput2.rCA_Ign_UpLim;
  } else {
    rtb_Product = rtb_Subtract5;
  }

  /* End of Switch: '<S6>/Switch1' */

  /* Delay: '<S20>/Delay' */
  if ((((TrStRed_PrevZCSigState->Delay_Reset_ZCE_l == 1) != (int32_T)
        rtb_RelationalOperator_c) && (TrStRed_PrevZCSigState->Delay_Reset_ZCE_l
        != 3)) || rtb_RelationalOperator_c) {
    TrStRed_DWork->icLoad_l = 1U;
  }

  TrStRed_PrevZCSigState->Delay_Reset_ZCE_l = rtb_RelationalOperator_c;
  if (TrStRed_DWork->icLoad_l != 0) {
    TrStRed_DWork->Delay_DSTATE_b = rtb_Product;
  }

  /* Sum: '<S20>/Difference Inputs1' incorporates:
   *  Delay: '<S20>/Delay'
   *  Switch: '<S20>/etaVolConst'
   */
  rtb_Product -= TrStRed_DWork->Delay_DSTATE_b;

  /* Switch: '<S32>/Switch2' incorporates:
   *  RelationalOperator: '<S32>/LowerRelop1'
   */
  if (rtb_Product <= rtb_Switch2) {
    /* Product: '<S20>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S20>/sample time'
     *  Switch: '<S4>/Environment Switch'
     *  UnaryMinus: '<S6>/Unary Minus'
     *
     * About '<S20>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch2 = -TrStRed_B->BusInput1.rCA_RateLimit * 0.01F;

    /* Switch: '<S32>/Switch' incorporates:
     *  RelationalOperator: '<S32>/UpperRelop'
     */
    if (rtb_Product >= rtb_Switch2) {
      rtb_Switch2 = rtb_Product;
    }

    /* End of Switch: '<S32>/Switch' */
  }

  /* End of Switch: '<S32>/Switch2' */

  /* Sum: '<S20>/Difference Inputs2' incorporates:
   *  Delay: '<S20>/Delay'
   */
  rtb_Switch2 += TrStRed_DWork->Delay_DSTATE_b;

  /* BusCreator: '<Root>/Bus Creator1' incorporates:
   *  CombinatorialLogic: '<S38>/Logic'
   *  Outport: '<Root>/Out'
   */
  TrStRed_Y->Out.rCA_IP_Lim = rtb_Switch2;
  TrStRed_Y->Out.bCycleStarted = rtb_Logic_b_idx_0;
  TrStRed_Y->Out.bCycleCompleted = TrStRed_ConstP.pooled10[(uint32_T)rowIdx];
  TrStRed_Y->Out.bTrStRed_Stop = rtb_RelationalOperator_c;

  /* Sum: '<Root>/Subtract1' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_Subtract -= TrStRed_B->BusInput2.rT_EG_CylMax;

  /* Switch: '<S7>/Switch2' incorporates:
   *  RelationalOperator: '<S7>/LowerRelop1'
   *  RelationalOperator: '<S7>/UpperRelop'
   *  Switch: '<S4>/Environment Switch'
   *  Switch: '<S7>/Switch'
   */
  if (rtb_Subtract > TrStRed_B->BusInput1.rT_CtrlError_UpLim) {
    rtb_Subtract = TrStRed_B->BusInput1.rT_CtrlError_UpLim;
  } else {
    if (rtb_Subtract < TrStRed_B->BusInput1.rT_CtrlError_LowLim) {
      /* Switch: '<S7>/Switch' */
      rtb_Subtract = TrStRed_B->BusInput1.rT_CtrlError_LowLim;
    }
  }

  /* End of Switch: '<S7>/Switch2' */

  /* BusCreator: '<Root>/Bus Creator4' incorporates:
   *  DiscreteIntegrator: '<S1>/Discrete-Time Integrator'
   *  Outport: '<Root>/dbg'
   *  RelationalOperator: '<S6>/Relational Operator'
   */
  TrStRed_Y->dbg.bInternalLimitAct = (TrStRed_DWork->ITCtrUi != rtb_Subtract5);

  /* UnitDelay: '<S1>/Unit Delay1' */
  rtb_Subtract5 = TrStRed_DWork->UnitDelay1_DSTATE;

  /* Sum: '<S1>/Subtract1' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_Subtract5 = TrStRed_B->BusInput2.rCA_IgnP_relAw - rtb_Subtract5;

  /* Product: '<S1>/Product3' incorporates:
   *  Switch: '<S4>/Environment Switch'
   */
  rtb_Subtract5 *= TrStRed_B->BusInput1.rCtrl_kAw;

  /* Sum: '<S1>/Sum' incorporates:
   *  Gain: '<Root>/Gain'
   */
  rtb_Subtract5 += -rtb_Subtract;

  /* Product: '<S1>/Product1' incorporates:
   *  Switch: '<S4>/Environment Switch'
   */
  rtb_Product = TrStRed_B->BusInput1.rCtrl_ki * rtb_Subtract5;

  /* BusCreator: '<Root>/Bus Creator4' incorporates:
   *  DiscreteIntegrator: '<S1>/Discrete-Time Integrator'
   *  Outport: '<Root>/dbg'
   */
  TrStRed_Y->dbg.rT_CtrlError = rtb_Subtract;
  TrStRed_Y->dbg.rCA_IP_Lim_preSat = TrStRed_DWork->ITCtrUi;
  TrStRed_Y->dbg.rCtrl_Int_InputPreGain = rtb_Subtract5;
  TrStRed_Y->dbg.rPr_Leanox_Dev_filt = TrStRed_B->Filter.Switch;
  TrStRed_Y->dbg.rIgnVolt_Max_filt = TrStRed_B->Filter1.Switch;
  TrStRed_Y->dbg.rCtrl_IntegrInput = rtb_Product;
  TrStRed_Y->dbg.bSteadyState = TrStRed_B->TON.LogicalOperator3;
  TrStRed_Y->dbg.rCA_LowLimit_Act = rtb_Product1;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' incorporates:
   *  Outport: '<Root>/Out'
   */
  inst->Out = TrStRed_Y->Out;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' incorporates:
   *  Outport: '<Root>/dbg'
   */
  inst->Dbg = TrStRed_Y->dbg;

  /* Bias: '<Root>/Bias' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_Subtract5 = TrStRed_B->BusInput2.rCA_Ign_UpLim + -0.01F;

  /* UnitDelay: '<S5>/Unit Delay' */
  TrStRed_B->UnitDelay = TrStRed_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->Version = TrStRed_B->UnitDelay;

  /* Update for Memory: '<S37>/Memory' */
  TrStRed_DWork->Memory_PreviousInput = rtb_Logic_idx_0;

  /* Update for Memory: '<S36>/Memory' */
  TrStRed_DWork->Memory_PreviousInput_o = rtb_Logic_b_idx_0;

  /* Update for Memory: '<S38>/Memory' */
  TrStRed_DWork->Memory_PreviousInput_l = rtb_Logic_e_idx_0;

  /* Update for UnitDelay: '<Root>/Unit Delay' incorporates:
   *  RelationalOperator: '<Root>/Relational Operator'
   */
  TrStRed_DWork->UnitDelay_DSTATE_j = (rtb_Switch2 >= rtb_Subtract5);

  /* Update for DiscreteIntegrator: '<S1>/Discrete-Time Integrator' */
  TrStRed_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;
  TrStRed_DWork->ITCtrUi += 0.01F * rtb_Product;
  TrStRed_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)
    rtb_RelationalOperator_c;

  /* Update for Delay: '<S21>/Delay' */
  TrStRed_DWork->icLoad = 0U;
  TrStRed_DWork->Delay_DSTATE = rtb_Switch2_e;

  /* Update for Delay: '<S20>/Delay' */
  TrStRed_DWork->icLoad_l = 0U;
  TrStRed_DWork->Delay_DSTATE_b = rtb_Switch2;

  /* Update for UnitDelay: '<S1>/Unit Delay1' */
  TrStRed_DWork->UnitDelay1_DSTATE = rtb_DiscreteTimeIntegrator;

  /* Update for UnitDelay: '<S5>/Unit Delay' */
  TrStRed_DWork->UnitDelay_DSTATE = 30U;
}

/* Model initialize function */
void TrStRed_initialize(RT_MODEL_TrStRed *const TrStRed_M, struct fTrStRed* inst)
{
  struct D_Work_TrStRed *TrStRed_DWork = ((struct D_Work_TrStRed *) TrStRed_M->dwork);
  struct PrevZCSigStates_TrStRed *TrStRed_PrevZCSigState = ((struct PrevZCSigStates_TrStRed *)
    TrStRed_M->prevZCSigState);
  TrStRed_PrevZCSigState->Delay_Reset_ZCE = UNINITIALIZED_ZCSIG;
  TrStRed_PrevZCSigState->Delay_Reset_ZCE_l = UNINITIALIZED_ZCSIG;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Discrete-Time Integrator' */
  TrStRed_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* InitializeConditions for Delay: '<S21>/Delay' */
  TrStRed_DWork->icLoad = 1U;

  /* InitializeConditions for Delay: '<S20>/Delay' */
  TrStRed_DWork->icLoad_l = 1U;

  /* SystemInitialize for Atomic SubSystem: '<S6>/Filter1' */
  TrStRed_Filter_Init(&TrStRed_DWork->Filter1, inst);

  /* End of SystemInitialize for SubSystem: '<S6>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S6>/Filter' */
  TrStRed_Filter_Init(&TrStRed_DWork->Filter, inst);

  /* End of SystemInitialize for SubSystem: '<S6>/Filter' */
}

/* Model terminate function */
void TrStRed_terminate(RT_MODEL_TrStRed *const TrStRed_M, struct fTrStRed* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(TrStRed_M);
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.8 (R2020a)18-Nov-2019                                             *
 * Simulink 10.1 (R2020a)18-Nov-2019                                          *
 * Simulink Coder 9.3 (R2020a)18-Nov-2019                                     *
 * Embedded Coder 7.4 (R2020a)18-Nov-2019                                     *
 * Stateflow 10.2 (R2020a)18-Nov-2019                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
