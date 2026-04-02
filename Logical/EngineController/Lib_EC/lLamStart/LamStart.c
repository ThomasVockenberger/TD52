/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LamStart
 * File: LamStart.c
 * Author: 105055527
 * Created: Thu May 18 17:26:11 2017
 ********************************************************************
 * Implementation of program LamStart
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "LamStart.h"
#include "LamStart_private.h"

/*  Defines */
#define LamStart_POS_ZCSIG             ((uint8_T)1U)
#define LamStart_UNINITIALIZED_ZCSIG   ((uint8_T)3U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_real32_T */
void BINARYSEARCH_real32_T(uint32_T *piLeft, uint32_T *piRght, real32_T u, const
  real32_T *pData, uint32_T iHi, struct fLamStart* inst)
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
  const real32_T *pUData, uint32_T iHi, struct fLamStart* inst)
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
      den = den - pUData[iLeft];
      num = u;
      num = num - pUData[iLeft];
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

/* Model step function */
void LamStart_step(struct BlockIO_LamStart *LamStart_B, struct D_Work_LamStart *LamStart_DWork,
                   struct PrevZCSigStates_LamStart *LamStart_PrevZCSigState,
                   ExternalOutputs_LamStart *LamStart_Y, struct fLamStart* inst)
{
  /* local block i/o variables */
  real32_T rtb_LookupTableDynamic;
  real32_T rtb_TmpSignalConversionAtLookup[2];
  real32_T rtb_TmpSignalConversionAtLook_b[2];
  real32_T rtb_rLowerOilTemp;
  real32_T rtb_rLamLoLim_N_y[3];
  real32_T rtb_rLamLoLim_N_x[3];
  real32_T rtb_rN_Eng_h;
  real32_T rtb_LookupTableDynamic1;
  real32_T rtb_rT_EO;
  boolean_T rtb_LogicalOperator2;
  boolean_T didZcEventOccur;
  real32_T rtb_rHigherOilTemp;
  real32_T rtb_Abs1;
  real32_T rtb_Product;
  real32_T rtb_UkYk1;
  boolean_T rtb_Switch1;
  boolean_T rtb_RelationalOperator;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  LamStart_B->BusInput2 = inst->Perm;

  /* Abs: '<S6>/Abs1' incorporates:
   *  BusSelector: '<S6>/Bus Selector7'
   */
  rtb_Abs1 = (real32_T)fabs(LamStart_B->BusInput2.rLamSlewRate);

  /* Product: '<S9>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S9>/sample time'
   *
   * About '<S9>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_rHigherOilTemp = rtb_Abs1 * 0.01F;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  LamStart_B->BusInput1 = inst->Para;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  LamStart_B->BusInput = inst->IN;

  /* BusSelector: '<Root>/Bus Selector3' */
  rtb_rLowerOilTemp = LamStart_B->BusInput.rN_Eng;

  /* BusSelector: '<Root>/Bus Selector13' */
  rtb_rLamLoLim_N_y[0] = LamStart_B->BusInput2.refPoint_Lam_N_Offs_x[0];
  rtb_rLamLoLim_N_y[1] = LamStart_B->BusInput2.refPoint_Lam_N_Offs_x[1];
  rtb_rLamLoLim_N_y[2] = LamStart_B->BusInput2.refPoint_Lam_N_Offs_x[2];
  rtb_rLamLoLim_N_x[0] = LamStart_B->BusInput2.refPoint_Lam_N_Offs_y[0];
  rtb_rLamLoLim_N_x[1] = LamStart_B->BusInput2.refPoint_Lam_N_Offs_y[1];
  rtb_rLamLoLim_N_x[2] = LamStart_B->BusInput2.refPoint_Lam_N_Offs_y[2];

  /* Dynamic Look-Up Table Block: '<Root>/Lookup Table Dynamic2'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_rT_EO), rtb_rLamLoLim_N_x, rtb_rLowerOilTemp,
    rtb_rLamLoLim_N_y, 2U, inst);

  /* Product: '<Root>/Product' */
  rtb_Product = LamStart_B->BusInput1.rLam_Start_Offs * rtb_rT_EO;

  /* Switch: '<S7>/Switch3' incorporates:
   *  Constant: '<S6>/Constant2'
   *  Constant: '<S6>/Constant4'
   *  Gain: '<S6>/Gain1'
   *  RelationalOperator: '<S7>/groesser '
   *  RelationalOperator: '<S7>/kleiner'
   *  Switch: '<S7>/Switch1'
   *  Switch: '<S7>/Switch2'
   *  UnitDelay: '<S7>/Unit Delay2'
   */
  if (LamStart_B->BusInput.bReset) {
    rtb_Switch1 = FALSE;
  } else if (LamStart_B->BusInput.rN_Eng < 10.0F) {
    /* Switch: '<S7>/Switch1' incorporates:
     *  Constant: '<S7>/FALSE'
     */
    rtb_Switch1 = FALSE;
  } else if (LamStart_B->BusInput.rN_Eng > 0.995F *
             LamStart_B->BusInput1.rN_EngNom) {
    /* Switch: '<S7>/Switch2' incorporates:
     *  Constant: '<S7>/TRUE'
     *  Switch: '<S7>/Switch1'
     */
    rtb_Switch1 = TRUE;
  } else {
    rtb_Switch1 = LamStart_DWork->UnitDelay2_DSTATE;
  }

  /* End of Switch: '<S7>/Switch3' */

  /* Outputs for Atomic SubSystem: '<S6>/TON' */
  /* Logic: '<S8>/Logical Operator2' */
  rtb_LogicalOperator2 = !rtb_Switch1;

  /* DiscreteIntegrator: '<S8>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2 || (LamStart_DWork->DiscreteTimeIntegrator_PrevRese
       != 0)) {
    LamStart_DWork->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S8>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S8>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator = (LamStart_DWork->DiscreteTimeIntegrator_DSTATE >=
    LamStart_B->BusInput2.rTi_idle);

  /* Update for DiscreteIntegrator: '<S8>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S10>/Conversion'
   *  Logic: '<S8>/Logical Operator'
   *  Logic: '<S8>/Logical Operator1'
   */
  LamStart_DWork->DiscreteTimeIntegrator_DSTATE += (real32_T)
    ((!rtb_RelationalOperator) && rtb_Switch1) * 0.01F;
  if (rtb_LogicalOperator2) {
    LamStart_DWork->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    LamStart_DWork->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S8>/Discrete-Time Integrator' */

  /* Logic: '<S6>/Logical Operator' incorporates:
   *  Logic: '<S6>/Logical Operator1'
   *  Logic: '<S8>/Logical Operator3'
   */
  rtb_RelationalOperator = !((rtb_RelationalOperator && rtb_Switch1) ||
    LamStart_B->BusInput.bGCB_ON);

  /* End of Outputs for SubSystem: '<S6>/TON' */

  /* Delay: '<S9>/Delay' */
  didZcEventOccur = (((LamStart_PrevZCSigState->Delay_Reset_ZCE ==
                       LamStart_POS_ZCSIG) != rtb_RelationalOperator) &&
                     (LamStart_PrevZCSigState->Delay_Reset_ZCE !=
                      LamStart_UNINITIALIZED_ZCSIG));
  LamStart_PrevZCSigState->Delay_Reset_ZCE = (uint8_T)rtb_RelationalOperator;
  if (rtb_RelationalOperator || didZcEventOccur) {
    LamStart_DWork->icLoad = 1U;
  }

  if (LamStart_DWork->icLoad != 0) {
    LamStart_DWork->Delay_DSTATE = rtb_Product;
  }

  rtb_rT_EO = LamStart_DWork->Delay_DSTATE;

  /* End of Delay: '<S9>/Delay' */

  /* Switch: '<S9>/etaVolConst' incorporates:
   *  Constant: '<S6>/Constant6'
   */
  if (rtb_RelationalOperator) {
    rtb_UkYk1 = rtb_Product;
  } else {
    rtb_UkYk1 = 0.0F;
  }

  /* End of Switch: '<S9>/etaVolConst' */

  /* Sum: '<S9>/Difference Inputs1' */
  rtb_UkYk1 -= rtb_rT_EO;

  /* Switch: '<S11>/Switch2' incorporates:
   *  RelationalOperator: '<S11>/LowerRelop1'
   */
  if (!(rtb_UkYk1 > rtb_rHigherOilTemp)) {
    /* Product: '<S9>/delta fall limit' incorporates:
     *  Gain: '<S6>/Gain'
     */
    rtb_Abs1 = -rtb_Abs1 * 0.01F;

    /* Switch: '<S11>/Switch' incorporates:
     *  RelationalOperator: '<S11>/UpperRelop'
     */
    if (rtb_UkYk1 < rtb_Abs1) {
      rtb_rHigherOilTemp = rtb_Abs1;
    } else {
      rtb_rHigherOilTemp = rtb_UkYk1;
    }

    /* End of Switch: '<S11>/Switch' */
  }

  /* End of Switch: '<S11>/Switch2' */

  /* Sum: '<S9>/Difference Inputs2' */
  rtb_Abs1 = rtb_rHigherOilTemp + rtb_rT_EO;

  /* BusSelector: '<Root>/Bus Selector11' */
  rtb_rT_EO = LamStart_B->BusInput.rT_EO;

  /* BusSelector: '<Root>/Bus Selector10' */
  rtb_rLowerOilTemp = LamStart_B->BusInput2.rLowerOilTemp;
  rtb_rN_Eng_h = LamStart_B->BusInput2.rLowerOilLambda;
  rtb_LookupTableDynamic1 = LamStart_B->BusInput2.rHigherOilLambda;

  /* SignalConversion: '<Root>/TmpSignal ConversionAtLookup Table Dynamic1Inport2' incorporates:
   *  BusSelector: '<Root>/Bus Selector10'
   */
  rtb_TmpSignalConversionAtLookup[0] = rtb_rLowerOilTemp;
  rtb_TmpSignalConversionAtLookup[1] = LamStart_B->BusInput2.rHigherOilTemp;

  /* SignalConversion: '<Root>/TmpSignal ConversionAtLookup Table Dynamic1Inport3' */
  rtb_TmpSignalConversionAtLook_b[0] = rtb_rN_Eng_h;
  rtb_TmpSignalConversionAtLook_b[1] = rtb_LookupTableDynamic1;

  /* Dynamic Look-Up Table Block: '<Root>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic1),
    rtb_TmpSignalConversionAtLook_b, rtb_rT_EO, rtb_TmpSignalConversionAtLookup,
    1U, inst);

  /* Sum: '<Root>/Add' */
  rtb_UkYk1 = rtb_LookupTableDynamic1 - rtb_Abs1;

  /* BusSelector: '<Root>/Bus Selector5' */
  rtb_rN_Eng_h = LamStart_B->BusInput.rN_Eng;

  /* BusSelector: '<Root>/Bus Selector8' */
  rtb_rLamLoLim_N_x[0] = LamStart_B->BusInput2.rLamLoLim_N_x[0];
  rtb_rLamLoLim_N_x[1] = LamStart_B->BusInput2.rLamLoLim_N_x[1];
  rtb_rLamLoLim_N_x[2] = LamStart_B->BusInput2.rLamLoLim_N_x[2];
  rtb_rLamLoLim_N_y[0] = LamStart_B->BusInput2.rLamLoLim_N_y[0];
  rtb_rLamLoLim_N_y[1] = LamStart_B->BusInput2.rLamLoLim_N_y[1];
  rtb_rLamLoLim_N_y[2] = LamStart_B->BusInput2.rLamLoLim_N_y[2];

  /* Dynamic Look-Up Table Block: '<Root>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic), rtb_rLamLoLim_N_y,
    rtb_rN_Eng_h, rtb_rLamLoLim_N_x, 2U, inst);

  /* Switch: '<S5>/Switch2' incorporates:
   *  Constant: '<Root>/Constant5'
   *  RelationalOperator: '<S5>/LowerRelop1'
   *  RelationalOperator: '<S5>/UpperRelop'
   *  Switch: '<S5>/Switch'
   */
  if (rtb_UkYk1 > 3.0F) {
    /* Outport: '<Root>/rLambda_start_idle' */
    LamStart_Y->rLambda_start_idle = 3.0F;
  } else if (rtb_UkYk1 < rtb_LookupTableDynamic) {
    /* Switch: '<S5>/Switch' incorporates:
     *  Outport: '<Root>/rLambda_start_idle'
     */
    LamStart_Y->rLambda_start_idle = rtb_LookupTableDynamic;
  } else {
    /* Outport: '<Root>/rLambda_start_idle' incorporates:
     *  Switch: '<S5>/Switch'
     */
    LamStart_Y->rLambda_start_idle = rtb_UkYk1;
  }

  /* End of Switch: '<S5>/Switch2' */

  /* Outport: '<Root>/dbg' incorporates:
   *  BusCreator: '<Root>/BusConversion_InsertedFor_dbg_at_inport_0'
   */
  LamStart_Y->dbg.rLambda_start = rtb_Abs1;
  LamStart_Y->dbg.rLambda_idle = rtb_LookupTableDynamic1;
  LamStart_Y->dbg.rLambda_start_raw = rtb_Product;
  LamStart_Y->dbg.rLamLim = rtb_LookupTableDynamic;

  /* BusCreator: '<Root>/BusConversion_InsertedFor_Bus Output1_at_inport_0' */
  LamStart_B->BusConversion_InsertedFor_BusOu.rLambda_start = rtb_Abs1;
  LamStart_B->BusConversion_InsertedFor_BusOu.rLambda_idle =
    rtb_LookupTableDynamic1;
  LamStart_B->BusConversion_InsertedFor_BusOu.rLambda_start_raw = rtb_Product;
  LamStart_B->BusConversion_InsertedFor_BusOu.rLamLim = rtb_LookupTableDynamic;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->dbg = LamStart_B->BusConversion_InsertedFor_BusOu;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->rLambda_start_idle = LamStart_Y->rLambda_start_idle;

  /* UnitDelay: '<S4>/Unit Delay' */
  LamStart_B->UnitDelay = LamStart_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Version = LamStart_B->UnitDelay;

  /* Update for UnitDelay: '<S7>/Unit Delay2' */
  LamStart_DWork->UnitDelay2_DSTATE = rtb_Switch1;

  /* Update for Delay: '<S9>/Delay' */
  LamStart_DWork->icLoad = 0U;
  LamStart_DWork->Delay_DSTATE = rtb_Abs1;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  LamStart_DWork->UnitDelay_DSTATE = 1000U;
}

/* Model initialize function */
void LamStart_initialize(struct D_Work_LamStart *LamStart_DWork,
  struct PrevZCSigStates_LamStart *LamStart_PrevZCSigState, struct fLamStart* inst)
{
  LamStart_PrevZCSigState->Delay_Reset_ZCE = UNINITIALIZED_ZCSIG;

  /* InitializeConditions for Delay: '<S9>/Delay' */
  LamStart_DWork->icLoad = 1U;
}

/* Model terminate function */
void LamStart_terminate(struct fLamStart* inst)
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
