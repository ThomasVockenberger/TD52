/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: UDC
 * File: UDC.c
 * Author: 105055527
 * Created: Thu Mar 02 16:51:06 2017
 ********************************************************************
 * Implementation of program UDC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "UDC.h"
#include "UDC_private.h"

/*  Defines */
#define UDC_POS_ZCSIG                  ((uint8_T)1U)
#define UDC_UNINITIALIZED_ZCSIG        ((uint8_T)3U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */
struct BlockIO_UDC UDC_B;

/* Block states (auto storage) */
struct D_Work_UDC UDC_DWork;

/* Previous zero-crossings (trigger) states */
struct PrevZCSigStates_UDC UDC_PrevZCSigState;

/* External inputs (root inport signals with auto storage) */
ExternalInputs_UDC UDC_U;

/* External outputs (root outports fed by signals with auto storage) */
ExternalOutputs_UDC UDC_Y;

/* Real-time model */
RT_MODEL_UDC UDC_M_;
RT_MODEL_UDC *const UDC_M = &UDC_M_;

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_real32_T */
void BINARYSEARCH_real32_T(uint32_T *piLeft, uint32_T *piRght, real32_T u, const
  real32_T *pData, uint32_T iHi, struct fUDC* inst)
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
  const real32_T *pUData, uint32_T iHi, struct fUDC* inst)
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

/* Lookup Binary Search Utility BINARYSEARCH_real32_Treal_T */
void BINARYSEARCH_real32_Treal_T(uint32_T *piLeft, uint32_T *piRght, real32_T u,
  const real_T *pData, uint32_T iHi, struct fUDC* inst)
{
  real_T uCast;

  /* cast current input to the data type/scaling of the table data */
  uCast = u;

  /* Find the location of current input value in the data table. */
  *piLeft = 0U;
  *piRght = iHi;
  if (uCast < pData[0] ) {
    /* Less than the smallest point in the table. */
    *piRght = 0U;
  } else if (uCast >= pData[iHi] ) {
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
      if (uCast < pData[i] ) {
        *piRght = i;
      } else {
        *piLeft = i;
      }
    }
  }
}

/* Lookup Utility LookUp_real32_T_real32_Treal_T */
void LookUp_real32_T_real32_Treal_T(real32_T *pY, const real32_T *pYData,
  real32_T u, const real_T *pUData, uint32_T iHi, struct fUDC* inst)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_real32_Treal_T( &(iLeft), &(iRght), u, pUData, iHi, inst);

  {
    real_T lambda;
    if (pUData[iRght] > pUData[iLeft] ) {
      real_T num;
      real_T den;
      den = pUData[iRght];
      den = den - pUData[iLeft];
      num = u;
      num = num - pUData[iLeft];
      lambda = num / den;
    } else {
      lambda = 0.0;
    }

    {
      real_T yLeftCast;
      real_T yRghtCast;
      yLeftCast = pYData[iLeft];
      yRghtCast = pYData[iRght];
      yLeftCast += lambda * ( yRghtCast - yLeftCast );
      (*pY) = (real32_T)yLeftCast;
    }
  }
}

uint32_T plook_u32ff_binca(real32_T u, const real32_T bp[], uint32_T maxIndex,
  real32_T *fraction, struct fUDC* inst)
{
  uint32_T bpIndex;

  /* Prelookup - Index and Fraction
     Index Search method: 'binary'
     Extrapolation method: 'Clip'
     Use previous index: 'off'
     Use last breakpoint for index at or above upper limit: 'on'
     Remove protection against out-of-range input in generated code: 'off'
   */
  if (u <= bp[0U]) {
    bpIndex = 0U;
    *fraction = 0.0F;
  } else if (u < bp[maxIndex]) {
    bpIndex = binsearch_u32f(u, bp, maxIndex >> 1U, maxIndex, inst);
    *fraction = (u - bp[bpIndex]) / (bp[bpIndex + 1U] - bp[bpIndex]);
  } else {
    bpIndex = maxIndex;
    *fraction = 0.0F;
  }

  return bpIndex;
}

real32_T intrp2d_if_u32f_la_pw(const uint32_T bpIndex[], const real32_T frac[],
  const real32_T table[], uint32_T stride, const uint32_T maxIndex[], struct fUDC* inst)
{
  real32_T y;
  real32_T yL_1d;
  real32_T yR_1d;
  uint32_T offset_1d;

  /* Interpolation 2-D
     Interpolation method: 'Linear'
     Use last breakpoint for index at or above upper limit: 'on'
     Overflow mode: 'portable wrapping'
   */
  offset_1d = bpIndex[1U] * stride + bpIndex[0U];
  if (bpIndex[0U] == maxIndex[0U]) {
    yL_1d = table[offset_1d];
  } else {
    yL_1d = (table[offset_1d + 1U] - table[offset_1d]) * frac[0U] +
      table[offset_1d];
  }

  if (bpIndex[1U] == maxIndex[1U]) {
    y = yL_1d;
  } else {
    offset_1d += stride;
    if (bpIndex[0U] == maxIndex[0U]) {
      yR_1d = table[offset_1d];
    } else {
      yR_1d = (table[offset_1d + 1U] - table[offset_1d]) * frac[0U] +
        table[offset_1d];
    }

    y = (yR_1d - yL_1d) * frac[1U] + yL_1d;
  }

  return y;
}

uint32_T binsearch_u32f(real32_T u, const real32_T bp[], uint32_T startIndex,
  uint32_T maxIndex, struct fUDC* inst)
{
  uint32_T iRght;
  uint32_T iLeft;
  uint32_T bpIdx;

  /* Binary Search */
  bpIdx = startIndex;
  iLeft = 0U;
  iRght = maxIndex;
  while (iRght - iLeft > 1U) {
    if (u < bp[bpIdx]) {
      iRght = bpIdx;
    } else {
      iLeft = bpIdx;
    }

    bpIdx = (iRght + iLeft) >> 1U;
  }

  return iLeft;
}

/*
 * Initial conditions for atomic system:
 *    '<S30>/Cell1'
 *    '<S30>/Cell2'
 *    '<S30>/Cell3'
 */
void UDC_Cell1_Init(rtDW_Cell1_UDC *localDW, struct fUDC* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S30>/Cell1'
 *    '<S30>/Cell2'
 *    '<S30>/Cell3'
 */
void UDC_Cell1(real32_T rtu_mdotExhWetkgs, real32_T rtu_cpExhJkgK, real32_T
               rtu_TgSCRInC, real32_T rtu_haWm2K, real32_T rtu_ACatm2, boolean_T
               rtu_Resetbool, real32_T rtu_I0C, real32_T rtu_TambC, real32_T
               rtu_mCatkg, real32_T rtu_cCatJkgK, const real32_T
               rtu_rNH3StorMap_x[5], const real32_T rtu_rNH3StorMap_y[5],
               rtB_Cell1_UDC *localB, rtDW_Cell1_UDC *localDW, struct fUDC* inst)
{
  real32_T rtb_Switch_jl;
  real32_T rtb_Switch_da;
  real32_T rtb_Add1_n;

  /* Product: '<S36>/Divide1' */
  rtb_Switch_jl = rtu_mdotExhWetkgs * rtu_cpExhJkgK;

  /* Product: '<S36>/Divide' */
  rtb_Switch_da = rtu_haWm2K * rtu_ACatm2;

  /* DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_I0C;
  }

  if (rtu_Resetbool || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_I0C;
  }

  localB->DiscreteTimeIntegrator = localDW->DiscreteTimeIntegrator_DSTATE;

  /* End of DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */

  /* Sum: '<S36>/Add1' incorporates:
   *  Product: '<S36>/Divide2'
   *  Product: '<S36>/Divide3'
   *  Product: '<S36>/Divide4'
   *  Sum: '<S36>/Add2'
   */
  rtb_Add1_n = (rtb_Switch_jl * rtu_TgSCRInC - (rtb_Switch_jl + rtb_Switch_da) *
                localB->DiscreteTimeIntegrator) + rtb_Switch_da * rtu_TambC;

  /* Switch: '<S40>/Switch' incorporates:
   *  Abs: '<S40>/Abs'
   *  Constant: '<S40>/Constant2'
   *  RelationalOperator: '<S40>/Relational Operator'
   */
  if (1.1920929E-7F >= (real32_T)fabs(rtu_mCatkg)) {
    rtb_Switch_da = 1.1920929E-7F;
  } else {
    rtb_Switch_da = rtu_mCatkg;
  }

  /* End of Switch: '<S40>/Switch' */

  /* Switch: '<S41>/Switch' incorporates:
   *  Abs: '<S41>/Abs'
   *  Constant: '<S41>/Constant2'
   *  RelationalOperator: '<S41>/Relational Operator'
   */
  if (1.1920929E-7F >= (real32_T)fabs(rtu_cCatJkgK)) {
    rtb_Switch_jl = 1.1920929E-7F;
  } else {
    rtb_Switch_jl = rtu_cCatJkgK;
  }

  /* End of Switch: '<S41>/Switch' */
  /* Dynamic Look-Up Table Block: '<S36>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(localB->LookupTableDynamic), rtu_rNH3StorMap_y,
    localB->DiscreteTimeIntegrator, rtu_rNH3StorMap_x, 4U, inst);

  /* Update for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' incorporates:
   *  Product: '<S36>/Divide5'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  if (!rtu_Resetbool) {
    localDW->DiscreteTimeIntegrator_DSTATE += rtb_Add1_n / rtb_Switch_da /
      rtb_Switch_jl * 0.1F;
  }

  if (rtu_Resetbool) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */
}

/*
 * Initial conditions for atomic system:
 *    '<S15>/Filter'
 *    '<S15>/Filter1'
 *    '<S97>/Filter_DPr'
 *    '<S98>/Filter_DPr'
 *    '<S120>/Filter'
 *    '<S120>/Filter2'
 *    '<S139>/Filter_CatOut'
 *    '<S139>/Filter_OxiIn'
 */
void UDC_Filter_Init(rtDW_Filter_UDC *localDW, struct fUDC* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S15>/Filter'
 *    '<S15>/Filter1'
 *    '<S97>/Filter_DPr'
 *    '<S98>/Filter_DPr'
 *    '<S120>/Filter'
 *    '<S120>/Filter2'
 *    '<S139>/Filter_CatOut'
 *    '<S139>/Filter_OxiIn'
 */
void UDC_Filter(real32_T rtu_T_filt, boolean_T rtu_reset, real32_T rtu_x0,
                rtB_Filter_UDC *localB, rtDW_Filter_UDC *localDW, struct fUDC* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator_b5;
  boolean_T rtb_RelationalOperator_m5;
  real32_T tmp;

  /* RelationalOperator: '<S62>/Relational Operator' incorporates:
   *  Constant: '<S62>/Constant'
   */
  rtb_RelationalOperator_m5 = (rtu_T_filt > 0.0F);

  /* Logic: '<S62>/Logical Operator' incorporates:
   *  Logic: '<S62>/Logical Operator1'
   */
  rtb_LogicalOperator_b5 = (rtu_reset || (!rtb_RelationalOperator_m5));

  /* DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  if (rtb_LogicalOperator_b5 || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  /* Switch: '<S62>/Switch' incorporates:
   *  DiscreteIntegrator: '<S62>/Discrete-Time Integrator'
   */
  if (rtb_RelationalOperator_m5) {
    localB->Switch = localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    localB->Switch = rtu_x0;
  }

  /* End of Switch: '<S62>/Switch' */

  /* Update for DiscreteIntegrator: '<S62>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S62>/Discrete-Time Integrator'
   *  Product: '<S62>/Divide4'
   *  Sum: '<S62>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  if (!rtb_LogicalOperator_b5) {
    /* Switch: '<S68>/Switch' incorporates:
     *  Abs: '<S68>/Abs'
     *  RelationalOperator: '<S68>/Relational Operator'
     */
    if (2.22044605E-16F >= (real32_T)fabs(rtu_T_filt)) {
      tmp = 2.22044605E-16F;
    } else {
      tmp = rtu_T_filt;
    }

    /* End of Switch: '<S68>/Switch' */
    localDW->DiscreteTimeIntegrator_DSTATE += (rtu_x0 -
      localDW->DiscreteTimeIntegrator_DSTATE) / tmp * 0.1F;
  }

  if (rtb_LogicalOperator_b5) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */
}

/*
 * Output and update for atomic system:
 *    '<S65>/TON'
 *    '<S111>/TON'
 *    '<S120>/TON'
 *    '<S120>/TON1'
 *    '<S137>/TON'
 *    '<S137>/TON3'
 *    '<S138>/TON'
 *    '<S138>/TON1'
 *    '<S138>/TON2'
 *    '<S139>/TON'
 *    ...
 */
void UDC_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_UDC *localB,
             rtDW_TON_UDC *localDW, struct fUDC* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2_ju;
  boolean_T rtb_RelationalOperator_jm;

  /* Logic: '<S72>/Logical Operator2' */
  rtb_LogicalOperator2_ju = !rtu_IN;

  /* DiscreteIntegrator: '<S72>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_ju || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S72>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S72>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_jm = (localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Logic: '<S72>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_jm && rtu_IN);

  /* Update for DiscreteIntegrator: '<S72>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S74>/Conversion'
   *  Logic: '<S72>/Logical Operator'
   *  Logic: '<S72>/Logical Operator1'
   */
  if (!rtb_LogicalOperator2_ju) {
    localDW->DiscreteTimeIntegrator_DSTATE += (real32_T)
      ((!rtb_RelationalOperator_jm) && rtu_IN) * 0.1F;
  }

  if (rtb_LogicalOperator2_ju) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S72>/Discrete-Time Integrator' */
}

/*
 * Output and update for enable system:
 *    '<S73>/Enabled Subsystem'
 *    '<S73>/Enabled Subsystem1'
 *    '<S146>/Enabled Subsystem'
 *    '<S146>/Enabled Subsystem1'
 *    '<S160>/Enabled Subsystem'
 *    '<S160>/Enabled Subsystem1'
 *    '<S174>/Enabled Subsystem'
 *    '<S174>/Enabled Subsystem1'
 */
void UDC_EnabledSubsystem(boolean_T rtu_0, real32_T rtu_1, real32_T *rty_Out1, struct fUDC* inst)
{
  /* Outputs for Enabled SubSystem: '<S73>/Enabled Subsystem' incorporates:
   *  EnablePort: '<S76>/Enable'
   */
  if (rtu_0) {
    /* Inport: '<S76>/In1' */
    *rty_Out1 = rtu_1;
  }

  /* End of Outputs for SubSystem: '<S73>/Enabled Subsystem' */
}

/*
 * Initial conditions for atomic system:
 *    '<S65>/TP'
 *    '<S137>/TP'
 *    '<S138>/TP1'
 *    '<S139>/TP'
 */
void UDC_TP_Init(rtDW_TP_UDC *localDW, struct fUDC* inst)
{
  /* InitializeConditions for UnitDelay: '<S73>/Unit Delay2' */
  localDW->UnitDelay2_DSTATE = TRUE;
}

/*
 * Output and update for atomic system:
 *    '<S65>/TP'
 *    '<S137>/TP'
 *    '<S138>/TP1'
 *    '<S139>/TP'
 */
void UDC_TP(boolean_T rtu_IN, real32_T rtu_PT, rtB_TP_UDC *localB, rtDW_TP_UDC
            *localDW, struct fUDC* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator3_h;
  real32_T rtb_Switch2_n;
  real32_T rtb_UkYk1_j;
  real32_T rtb_Yk1_i1;

  /* Product: '<S78>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S78>/sample time'
   *
   * About '<S78>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_n = 0.1F;

  /* UnitDelay: '<S78>/Delay Input2' */
  rtb_Yk1_i1 = localDW->DelayInput2_DSTATE;

  /* Logic: '<S73>/Logical Operator3' incorporates:
   *  Logic: '<S73>/Logical Operator2'
   *  UnitDelay: '<S73>/Unit Delay2'
   */
  rtb_LogicalOperator3_h = ((!rtu_IN) && localDW->UnitDelay2_DSTATE);

  /* Outputs for Enabled SubSystem: '<S73>/Enabled Subsystem' */

  /* Constant: '<S73>/Constant10' */
  UDC_EnabledSubsystem(rtb_LogicalOperator3_h, 0.0F, &localB->Merge, inst);

  /* End of Outputs for SubSystem: '<S73>/Enabled Subsystem' */

  /* Outputs for Enabled SubSystem: '<S73>/Enabled Subsystem1' */
  UDC_EnabledSubsystem(rtu_IN, rtu_PT, &localB->Merge, inst);

  /* End of Outputs for SubSystem: '<S73>/Enabled Subsystem1' */

  /* Sum: '<S78>/Difference Inputs1' */
  rtb_UkYk1_j = localB->Merge - rtb_Yk1_i1;

  /* Switch: '<S79>/Switch2' incorporates:
   *  RelationalOperator: '<S79>/LowerRelop1'
   */
  if (!(rtb_UkYk1_j > 0.1F)) {
    /* Switch: '<S79>/Switch' incorporates:
     *  RelationalOperator: '<S79>/UpperRelop'
     */
    if (rtb_UkYk1_j < -999.9F) {
      rtb_Switch2_n = -999.9F;
    } else {
      rtb_Switch2_n = rtb_UkYk1_j;
    }

    /* End of Switch: '<S79>/Switch' */
  }

  /* End of Switch: '<S79>/Switch2' */

  /* Sum: '<S78>/Difference Inputs2' */
  rtb_Switch2_n += rtb_Yk1_i1;

  /* Logic: '<S73>/Logical Operator1' incorporates:
   *  Constant: '<S75>/Constant'
   *  RelationalOperator: '<S73>/Relational Operator1'
   *  RelationalOperator: '<S75>/Compare'
   */
  localB->LogicalOperator1 = ((rtb_Switch2_n > 0.0F) && (rtb_Switch2_n < rtu_PT));

  /* Update for UnitDelay: '<S78>/Delay Input2' */
  localDW->DelayInput2_DSTATE = rtb_Switch2_n;

  /* Update for UnitDelay: '<S73>/Unit Delay2' incorporates:
   *  RelationalOperator: '<S73>/Relational Operator3'
   */
  localDW->UnitDelay2_DSTATE = (rtb_Switch2_n >= rtu_PT);
}

/*
 * Initial conditions for atomic system:
 *    '<S119>/TOF'
 *    '<S119>/TOF1'
 */
void UDC_TOF_Init(rtDW_TOF_UDC *localDW, struct fUDC* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S123>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
  localDW->DiscreteTimeIntegrator_PrevRese = 2;
}

/*
 * Output and update for atomic system:
 *    '<S119>/TOF'
 *    '<S119>/TOF1'
 */
void UDC_TOF(boolean_T rtu_IN, real_T rtu_PT, rtB_TOF_UDC *localB, rtDW_TOF_UDC *
             localDW, struct fUDC* inst)
{
  real_T rtb_Switch_dc;

  /* Switch: '<S123>/Switch' incorporates:
   *  Constant: '<S123>/Constant1'
   */
  if (rtu_IN) {
    rtb_Switch_dc = 0.0;
  } else {
    rtb_Switch_dc = rtu_PT;
  }

  /* End of Switch: '<S123>/Switch' */

  /* DiscreteIntegrator: '<S123>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_dc;
  }

  if (rtu_IN && (localDW->DiscreteTimeIntegrator_PrevRese <= 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_dc;
  }

  /* Logic: '<S123>/Logical Operator1' incorporates:
   *  DiscreteIntegrator: '<S123>/Discrete-Time Integrator'
   *  RelationalOperator: '<S123>/Relational Operator'
   */
  localB->LogicalOperator1 = !(localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Update for DiscreteIntegrator: '<S123>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S125>/Conversion'
   *  Logic: '<S123>/Logical Operator5'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  localDW->DiscreteTimeIntegrator_DSTATE += 0.1 * (real_T)!rtu_IN;
  if (rtu_IN) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S123>/Discrete-Time Integrator' */
}

/* Model step function */
void UDC_step(struct fUDC* inst)
{
  /* local block i/o variables */
  real32_T rtb_rP_Act_Norm_Filt;
  real32_T rtb_rTiFilt_P_Act_Norm;
  real32_T rtb_rTiFilt_T_SCR_Avg;
  real32_T rtb_rTOnDelay_SS_P;
  real32_T rtb_rTOnDelay_SS_T;
  real32_T rtb_Switch3;
  real32_T rtb_rTiFiltUreaFFAdjust;
  real32_T rtb_rT_SCR_CatHeatTrans_Coef;
  real32_T rtb_rC_SCR_ExhaustGas;
  real32_T rtb_rC_SCR_Cat;
  real32_T rtb_rTSCRInit;
  real32_T rtb_rNH3StorMap_x[5];
  real32_T rtb_rNH3StorMap_y[5];
  real32_T rtb_Divide2_c;
  real32_T rtb_Divide3;
  real32_T rtb_rT_Ch_T1LP_Avg;
  real32_T rtb_Ai_jl;
  real32_T rtb_Switch6;
  real32_T rtb_rFlow_SCR_UreaDosingUnit_ff;
  real32_T rtb_rSCR_NOxControlWaiting;
  real32_T rtb_Ai_j0;
  real32_T rtb_rTiConstAvgOn;
  real32_T rtb_rTiConstAvgOff;
  real32_T rtb_rTiWaitSteadyState;
  real32_T rtb_rTi_SlipDetectWait;
  real32_T rtb_rTiSCR_EAC_DurationStartup;
  real32_T rtb_rNOx_EMLineOxiIn;
  real32_T rtb_rCemsIntFiltFact;
  real32_T rtb_rTiNOxMarginDelay;
  real32_T rtb_rTiNOxMarginDelay_j;
  real32_T rtb_rTiNOxCLSatDelay;
  real32_T rtb_rTiSwitchValve;
  real32_T rtb_rTiWaitSwitch;
  real32_T rtb_rNOx_EMLineCatOut_b;
  real32_T rtb_Switch4;
  real32_T rtb_Gain_a;
  real32_T rtb_rTiNOxMarginDelay_d;
  real32_T rtb_rTiWaitNH3slip_fallback;
  real32_T rtb_etaVolConst_p;
  real32_T rtb_DifferenceInputs2_i;
  real32_T rtb_etaVolConst_f;
  real32_T rtb_DifferenceInputs2_a;
  real32_T rtb_rTiSCR_NH3Slip_WaitNOxGrad_;
  real32_T rtb_Switch_ld;
  real32_T rtb_rTiFilt_DPrVlv;
  real32_T rtb_rTiFilt_DPrVlv_b;
  real32_T rtb_Switch3_l;
  real32_T rtb_rMdot_exh;
  real32_T rtb_LookupTableDynamic;
  real32_T rtb_rUrPpCntrFFMap_x[11];
  real32_T rtb_rUrPpCntrFFMap_y[11];
  real32_T rtb_LookupTableDynamic_f;
  real32_T rtb_Saturation1;
  real32_T rtb_Saturation1_f;
  real32_T rtb_rUrValLinMap_x[11];
  real32_T rtb_rUrValLinMap_y[11];
  real32_T rtb_Switch1_n;
  real32_T rtb_rUrClKiOffs_x[5];
  real32_T rtb_rUrClKiOffs_y[5];
  real32_T rtb_Switch2_mg;
  real32_T rtb_LookupTableDynamic_b;
  real32_T rtb_Switch_h;
  real32_T rtb_LookupTableDynamic1;
  real32_T rtb_rTSCRAvg;
  real32_T rtb_LookupTableDynamic_e;
  boolean_T rtb_bOpModeStop;
  boolean_T rtb_RelationalOperator5;
  boolean_T rtb_RelationalOperator1;
  boolean_T rtb_bNH3StDRes;
  boolean_T rtb_bNH3StDRes2;
  boolean_T rtb_bTSCRRes;
  boolean_T rtb_bRel_SCR_Dosing_n;
  boolean_T rtb_LogicalOperator_p;
  boolean_T rtb_bSatUpLim_k;
  boolean_T rtb_LogicalOperator_b;
  boolean_T rtb_LogicalOperator1_n;
  boolean_T rtb_bSCR_EngineSteadyState_i;
  boolean_T rtb_UnitDelay_h;
  boolean_T rtb_FixPtRelationalOperator;
  boolean_T rtb_bRel_SCR_Dosing_no;
  boolean_T rtb_LogicalOperator2_f;
  boolean_T rtb_LogicalOperator4_m;
  boolean_T rtb_LogicalOperator5_m;
  boolean_T rtb_LogicalOperator_b1;
  boolean_T rtb_LogicalOperator8;
  boolean_T rtb_LogicalOperator1_m;
  boolean_T rtb_Logic[2];
  boolean_T rtb_LogicalOperator4_l;
  boolean_T rtb_LogicalOperator_k;
  boolean_T rtb_LogicalOperator7_n;
  boolean_T rtb_LogicalOperator20;
  boolean_T rtb_LogicalOperator21;
  boolean_T rtb_Compare;
  boolean_T rtb_Compare_l;
  boolean_T rtb_Compare_f;
  boolean_T rtb_Logic_k[2];
  boolean_T rtb_LogicalOperator_e;
  boolean_T rtb_bRdy_f;
  boolean_T rtb_bRdy_k;
  boolean_T rtb_LogicalOperator2_j;
  boolean_T rtb_LogicalOperator_g;
  real32_T rNOx_EMLineCatOut;
  boolean_T bEMLineCatOut_GQ;
  real32_T rNOx_EMLineOxiIn;
  boolean_T bEMLineOxiIn_GQ;
  real32_T rNOx_Act;
  boolean_T rtb_RelationalOperator2;
  boolean_T rtb_LogicalOperator1_f;
  real32_T rtb_BusCreator_h_rNOx_SCR_CatOu;
  real32_T rtb_BusCreator_h_rTSCRAvg;
  real32_T rtb_Switch_ah;
  boolean_T rtb_bFreezeCtr_j;
  real32_T rtb_rNOx_CatOutCor_k;
  boolean_T rtb_bNOx_CatOutCor_n;
  real32_T rtb_rNOxEngOutCor_e;
  real32_T rtb_Divide_h;
  real32_T rtb_Switch_f;
  real32_T rtb_Gain1;
  boolean_T rtb_LogicalOperator1_b;
  real32_T rtb_UkYk1;
  real32_T rtb_DifferenceInputs2;
  real32_T rtb_rFlowUreaFF_LT;
  real32_T rtb_BusCreator_h3_rUrCorFactSli;
  boolean_T rtb_BusCreator_h3_bSCR_EMValve1;
  real32_T rtb_Switch;
  real32_T rtb_rFlowUreaFF_NOx_i;
  real32_T rtb_DiscreteTimeIntegrator_b;
  real32_T rtb_Divide1_o;
  real32_T rtb_DiscreteTimeIntegrator_a;
  real32_T rtb_Divide1_m;
  real32_T rtb_Divide5;
  real32_T rtb_Saturation_m;
  real32_T rtb_rFlowUreaFF_Map;
  uint32_T rtb_DataTypeConversion;
  real32_T rtb_rFlowUreaFF_NH3;
  uint8_T rtb_iIdxFFOut;
  real32_T rtb_rFlow_SCR_UreaDosing_ffNH3C;
  real32_T rtb_Product_f;
  real32_T rtb_DiscreteTimeIntegrator;
  real32_T rtb_Product3;
  real32_T rtb_Switch2_h;
  real32_T rtb_Switch2_m;
  real32_T rtb_rSV;
  real32_T rtb_etaVolConst;
  boolean_T rtb_LogicalOperator1_o;
  boolean_T rtb_bNH3SlipCtrlEna;
  boolean_T rtb_bSCR_NH3SlipInterrupt_k;
  real32_T rtb_sampletime_c;
  real32_T rtb_Switch2_p;
  real32_T rtb_Switch2_kp;
  real32_T rtb_rNOxRedRatioMap_out[18];
  real32_T rtb_Prelookup_o2;
  real32_T frac[2];
  real32_T rtb_Prelookup1_o2;
  uint32_T bpIndex[2];
  uint32_T rtb_Prelookup1_o1;
  real32_T rtb_Switch_jg;
  real32_T rtb_Switch_ky;
  real32_T rtb_Switch_kk;
  real32_T rtb_UnitDelay;
  real32_T rtb_Product_k;
  real32_T rtb_DiscreteTimeIntegrator_p;
  real32_T rtb_Product3_i;
  real32_T rtb_Switch2_l;
  boolean_T rtb_RelationalOperator_mq;
  real32_T rtb_Divide2_h;
  int32_T i;
  int32_T tmp;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  UDC_B.BusInput1 = inst->Para;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  UDC_B.BusInput = inst->In;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  UDC_B.BusInput2 = inst->Perm;

  /* Switch: '<S9>/Switch2' */
  if (UDC_B.BusInput.bESCEnable) {
    rtb_Switch_ah = UDC_B.BusInput.rNOx_ESC_CatOut_Set;
  } else {
    rtb_Switch_ah = UDC_B.BusInput1.rNOx_SCR_CatOut_Set;
  }

  /* End of Switch: '<S9>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* BusSelector: '<S119>/Bus Selector8' */
  rtb_bRdy_f = UDC_B.BusInput.tEMLineOxiIn.bRdy;

  /* BusSelector: '<S119>/Bus Selector9' */
  rtb_bRdy_k = UDC_B.BusInput.tEMLineCatOut.bRdy;

  /* Outputs for Atomic SubSystem: '<S119>/TOF' */

  /* Constant: '<S119>/Constant2' */
  UDC_TOF(rtb_bRdy_k, 300.0, &UDC_B.TOF, &UDC_DWork.TOF, inst);

  /* End of Outputs for SubSystem: '<S119>/TOF' */

  /* Outputs for Atomic SubSystem: '<S119>/TOF1' */
  UDC_TOF(rtb_bRdy_f, 300.0, &UDC_B.TOF1, &UDC_DWork.TOF1, inst);

  /* End of Outputs for SubSystem: '<S119>/TOF1' */

  /* MATLAB Function: '<S119>/MATLAB Function' */
  /* MATLAB Function 'SignalManager/E21_NOxCatOutManager/MATLAB Function': '<S122>:1' */
  if ((!UDC_DWork.rNOx_EMLineCatOut_1_not_empty) ||
      (!UDC_DWork.rNOx_EMLineOxiIn_1_not_empty) ||
      (!UDC_DWork.rNOx_Act_1_not_empty)) {
    /* '<S122>:1:10' */
    /* '<S122>:1:11' */
    UDC_DWork.rNOx_EMLineCatOut_1 = 0.0F;
    UDC_DWork.rNOx_EMLineCatOut_1_not_empty = TRUE;

    /* '<S122>:1:12' */
    UDC_DWork.rNOx_EMLineOxiIn_1 = 0.0F;
    UDC_DWork.rNOx_EMLineOxiIn_1_not_empty = TRUE;

    /* '<S122>:1:13' */
    UDC_DWork.rNOx_Act_1 = 0.0F;
    UDC_DWork.rNOx_Act_1_not_empty = TRUE;
  }

  /* % CatOut */
  if (UDC_B.BusInput.tEMLineCatOut.bRdy) {
    /* '<S122>:1:17' */
    if (UDC_B.BusInput.tEMLineCatOut.bNO && UDC_B.BusInput.tEMLineCatOut.bNO2) {
      /* '<S122>:1:18' */
      /* '<S122>:1:19' */
      rNOx_EMLineCatOut = UDC_B.BusInput.tEMLineCatOut.rNO +
        UDC_B.BusInput.tEMLineCatOut.rNO2;

      /* '<S122>:1:20' */
      bEMLineCatOut_GQ = TRUE;
    } else if (UDC_B.BusInput.tEMLineCatOut.bNO) {
      /* '<S122>:1:21' */
      /* '<S122>:1:22' */
      rNOx_EMLineCatOut = 2.0F * UDC_B.BusInput.tEMLineCatOut.rNO;

      /* '<S122>:1:23' */
      bEMLineCatOut_GQ = TRUE;
    } else if (UDC_B.BusInput.tEMLineCatOut.bNO2) {
      /* '<S122>:1:24' */
      /* '<S122>:1:25' */
      rNOx_EMLineCatOut = 2.0F * UDC_B.BusInput.tEMLineCatOut.rNO2;

      /* '<S122>:1:26' */
      bEMLineCatOut_GQ = TRUE;
    } else {
      /* '<S122>:1:28' */
      rNOx_EMLineCatOut = UDC_DWork.rNOx_EMLineCatOut_1;

      /* '<S122>:1:29' */
      bEMLineCatOut_GQ = FALSE;
    }
  } else {
    /* '<S122>:1:32' */
    rNOx_EMLineCatOut = UDC_DWork.rNOx_EMLineCatOut_1;

    /* '<S122>:1:33' */
    bEMLineCatOut_GQ = FALSE;
  }

  /* '<S122>:1:36' */
  UDC_DWork.rNOx_EMLineCatOut_1 = rNOx_EMLineCatOut;

  /* % OxiIn */
  if (UDC_B.BusInput.tEMLineOxiIn.bRdy) {
    /* '<S122>:1:40' */
    if (UDC_B.BusInput.tEMLineOxiIn.bNO && UDC_B.BusInput.tEMLineOxiIn.bNO2) {
      /* '<S122>:1:41' */
      /* '<S122>:1:42' */
      rNOx_EMLineOxiIn = UDC_B.BusInput.tEMLineOxiIn.rNO +
        UDC_B.BusInput.tEMLineOxiIn.rNO2;

      /* '<S122>:1:43' */
      bEMLineOxiIn_GQ = TRUE;
    } else if (UDC_B.BusInput.tEMLineOxiIn.bNO) {
      /* '<S122>:1:44' */
      /* '<S122>:1:45' */
      rNOx_EMLineOxiIn = UDC_B.BusInput.tEMLineOxiIn.rNO;

      /* '<S122>:1:46' */
      bEMLineOxiIn_GQ = TRUE;
    } else {
      /* '<S122>:1:48' */
      rNOx_EMLineOxiIn = UDC_DWork.rNOx_EMLineOxiIn_1;

      /* '<S122>:1:49' */
      bEMLineOxiIn_GQ = FALSE;
    }
  } else {
    /* '<S122>:1:52' */
    rNOx_EMLineOxiIn = UDC_DWork.rNOx_EMLineOxiIn_1;

    /* '<S122>:1:53' */
    bEMLineOxiIn_GQ = FALSE;
  }

  /* '<S122>:1:56' */
  if ((0.1F >= rNOx_EMLineOxiIn) || rtIsNaNF(rNOx_EMLineOxiIn)) {
    rNOx_EMLineOxiIn = 0.1F;
  }

  /* '<S122>:1:57' */
  UDC_DWork.rNOx_EMLineOxiIn_1 = rNOx_EMLineOxiIn;

  /* % NOx act for NOx controller */
  if (UDC_B.BusInput.tEMLineOxiIn.bNO && UDC_B.BusInput.tEMLineOxiIn.bRdy) {
    /* '<S122>:1:60' */
    /*  CEMS OxiIn */
    /* '<S122>:1:61' */
    rNOx_Act = rNOx_EMLineOxiIn;

    /* '<S122>:1:62' */
    rtb_bFreezeCtr_j = FALSE;
  } else if ((!UDC_B.BusInput.tEMLineOxiIn.bNO) &&
             (UDC_B.BusInput.tEMLineCatOut.bNO2 ||
              UDC_B.BusInput.tEMLineCatOut.bNO) &&
             UDC_B.BusInput.tEMLineCatOut.bRdy) {
    /* '<S122>:1:63' */
    /* '<S122>:1:64' */
    rNOx_Act = rNOx_EMLineCatOut;

    /* '<S122>:1:65' */
    rtb_bFreezeCtr_j = FALSE;
  } else if (bEMLineCatOut_GQ && ((real_T)((real32_T)fabs(rNOx_EMLineCatOut -
                rNOx_EMLineOxiIn) / rNOx_EMLineOxiIn) <= 0.1)) {
    /* '<S122>:1:66' */
    /* '<S122>:1:67' */
    rNOx_Act = rNOx_EMLineCatOut;

    /* '<S122>:1:68' */
    rtb_bFreezeCtr_j = FALSE;
  } else if (UDC_B.BusInput.tNOx_SCR_CatOut.GoodQual) {
    /* '<S122>:1:69' */
    /*  Sensor CatOut */
    /* '<S122>:1:70' */
    rNOx_Act = UDC_B.BusInput.tNOx_SCR_CatOut.Ai;

    /* '<S122>:1:71' */
    rtb_bFreezeCtr_j = FALSE;
  } else if (UDC_B.BusInput.bNOx_SCR_CatOut_Est_Ok) {
    /* '<S122>:1:72' */
    /*  Estimation */
    /* '<S122>:1:73' */
    rNOx_Act = UDC_B.BusInput.rNOx_SCR_CatOut_Est;

    /* '<S122>:1:74' */
    rtb_bFreezeCtr_j = FALSE;
  } else {
    /* '<S122>:1:76' */
    rNOx_Act = UDC_DWork.rNOx_Act_1;

    /* '<S122>:1:77' */
    rtb_bFreezeCtr_j = TRUE;
  }

  if ((!UDC_B.TOF1.LogicalOperator1) && (!UDC_B.TOF.LogicalOperator1) &&
      (!UDC_B.BusInput.tNOx_SCR_CatOut.GoodQual)) {
    /* '<S122>:1:80' */
    /* '<S122>:1:81' */
    rNOx_Act = 0.0F;
  }

  /* '<S122>:1:84' */
  UDC_DWork.rNOx_Act_1 = rNOx_Act;

  /* % NOx CatOut */
  /* '<S122>:1:88' */
  rtb_bNOx_CatOutCor_n = TRUE;
  if (bEMLineCatOut_GQ) {
    /* '<S122>:1:89' */
    /*  CEMS CatOut */
    /* '<S122>:1:90' */
    rtb_rNOx_CatOutCor_k = rNOx_EMLineCatOut;
  } else if (UDC_B.BusInput.tNOx_SCR_CatOut.GoodQual) {
    /* '<S122>:1:91' */
    /*  Sensor CatOut */
    /* '<S122>:1:92' */
    rtb_rNOx_CatOutCor_k = UDC_B.BusInput.tNOx_SCR_CatOut.Ai;
  } else if (bEMLineOxiIn_GQ) {
    /* '<S122>:1:93' */
    /*  CEMS OxiIn */
    /* '<S122>:1:94' */
    rtb_rNOx_CatOutCor_k = rNOx_EMLineOxiIn;
  } else if (UDC_B.BusInput.bNOx_SCR_CatOut_Est_Ok) {
    /* '<S122>:1:95' */
    /*  Estimation */
    /* '<S122>:1:96' */
    rtb_rNOx_CatOutCor_k = UDC_B.BusInput.rNOx_SCR_CatOut_Est;
  } else {
    /* '<S122>:1:98' */
    rtb_rNOx_CatOutCor_k = 0.0F;

    /* '<S122>:1:99' */
    rtb_bNOx_CatOutCor_n = FALSE;
  }

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* MATLAB Function: '<S9>/E20_NOxEngOutManager' */
  /* MATLAB Function 'SignalManager/E20_NOxEngOutManager': '<S118>:1' */
  /*  replaces NOx sensor signal by parameter value in case of NOx signal fault */
  /*  detection */
  if (!UDC_B.BusInput.tNOx_SCR_EngOut.GoodQual) {
    /* '<S118>:1:7' */
    if (UDC_B.BusInput.bNOx_SCR_EngOut_Est_Ok) {
      /* '<S118>:1:8' */
      /* '<S118>:1:9' */
      rtb_rNOxEngOutCor_e = UDC_B.BusInput.rNOx_SCR_EngOut_Est;
    } else {
      /* '<S118>:1:11' */
      rtb_rNOxEngOutCor_e = UDC_B.BusInput1.rNOx_SCR_EngOut_Expect;
    }
  } else {
    /* '<S118>:1:14' */
    rtb_rNOxEngOutCor_e = UDC_B.BusInput.tNOx_SCR_EngOut.Ai;
  }

  /* End of MATLAB Function: '<S9>/E20_NOxEngOutManager' */

  /* BusSelector: '<S9>/Bus Selector6' */
  rtb_rP_Act_Norm_Filt = UDC_B.BusInput.rP_Act_Norm_Filt;
  rtb_bOpModeStop = UDC_B.BusInput.bOpModeStop;

  /* BusSelector: '<S120>/Bus Selector1' */
  rtb_rTiFilt_P_Act_Norm = UDC_B.BusInput2.SM.rTiFilt_P_Act_Norm;
  rtb_rTiFilt_T_SCR_Avg = UDC_B.BusInput2.SM.rTiFilt_T_SCR_Avg;
  rtb_rTOnDelay_SS_P = UDC_B.BusInput2.SM.rTOnDelay_SS_P;
  rtb_rTOnDelay_SS_T = UDC_B.BusInput2.SM.rTOnDelay_SS_T;

  /* RelationalOperator: '<S120>/Relational Operator2' */
  rtb_RelationalOperator2 = (rtb_rP_Act_Norm_Filt >=
    UDC_B.BusInput2.SM.rP_Act_enable);

  /* Outputs for Atomic SubSystem: '<S120>/Filter' */
  UDC_Filter(rtb_rTiFilt_P_Act_Norm, rtb_bOpModeStop, rtb_rP_Act_Norm_Filt,
             &UDC_B.Filter, &UDC_DWork.Filter, inst);

  /* End of Outputs for SubSystem: '<S120>/Filter' */

  /* Sum: '<S120>/Add' */
  rtb_rTSCRAvg = rtb_rP_Act_Norm_Filt - UDC_B.Filter.Switch;

  /* Abs: '<S120>/Abs' */
  rtb_rTSCRAvg = (real32_T)fabs(rtb_rTSCRAvg);

  /* RelationalOperator: '<S120>/Relational Operator5' */
  rtb_RelationalOperator5 = (rtb_rTSCRAvg < UDC_B.BusInput2.SM.rThresh_SS_P);

  /* Outputs for Atomic SubSystem: '<S120>/TON' */
  UDC_TON(rtb_RelationalOperator5, rtb_rTOnDelay_SS_P, &UDC_B.TON,
          &UDC_DWork.TON, inst);

  /* End of Outputs for SubSystem: '<S120>/TON' */

  /* Switch: '<S121>/Switch3' incorporates:
   *  Constant: '<S121>/const1'
   *  Constant: '<S121>/const2'
   *  Constant: '<S121>/const7'
   *  Logic: '<S121>/Logical Operator'
   *  Logic: '<S121>/Logical Operator1'
   *  Logic: '<S121>/Logical Operator2'
   *  Product: '<S121>/Divide1'
   *  Product: '<S121>/Divide4'
   *  Sum: '<S121>/Add2'
   *  Switch: '<S121>/Switch2'
   */
  if ((!UDC_B.BusInput.tT_SCR_CatIn.GoodQual) &&
      (!UDC_B.BusInput.tT_SCR_CatOut.GoodQual)) {
    rtb_Switch3 = 280.0F;
  } else {
    if (UDC_B.BusInput.tT_SCR_CatIn.GoodQual) {
      /* Switch: '<S121>/Switch2' */
      rtb_Product_k = UDC_B.BusInput.tT_SCR_CatIn.Ai;
    } else {
      /* Switch: '<S121>/Switch2' */
      rtb_Product_k = UDC_B.BusInput.tT_SCR_CatOut.Ai;
    }

    /* Switch: '<S121>/Switch1' */
    if (UDC_B.BusInput.tT_SCR_CatOut.GoodQual) {
      rtb_UkYk1 = UDC_B.BusInput.tT_SCR_CatOut.Ai;
    } else {
      rtb_UkYk1 = UDC_B.BusInput.tT_SCR_CatIn.Ai;
    }

    /* End of Switch: '<S121>/Switch1' */
    rtb_Switch3 = (rtb_UkYk1 * 2.0F + rtb_Product_k) / 3.0F;
  }

  /* End of Switch: '<S121>/Switch3' */

  /* Outputs for Atomic SubSystem: '<S120>/Filter2' */
  UDC_Filter(rtb_rTiFilt_T_SCR_Avg, rtb_bOpModeStop, rtb_Switch3, &UDC_B.Filter2,
             &UDC_DWork.Filter2, inst);

  /* End of Outputs for SubSystem: '<S120>/Filter2' */

  /* Sum: '<S120>/Add1' */
  rtb_rTSCRAvg = rtb_Switch3 - UDC_B.Filter2.Switch;

  /* Abs: '<S120>/Abs1' */
  rtb_rTSCRAvg = (real32_T)fabs(rtb_rTSCRAvg);

  /* RelationalOperator: '<S120>/Relational Operator1' */
  rtb_RelationalOperator1 = (rtb_rTSCRAvg < UDC_B.BusInput2.SM.rThresh_SS_T_Avg);

  /* Outputs for Atomic SubSystem: '<S120>/TON1' */
  UDC_TON(rtb_RelationalOperator1, rtb_rTOnDelay_SS_T, &UDC_B.TON1,
          &UDC_DWork.TON1, inst);

  /* End of Outputs for SubSystem: '<S120>/TON1' */

  /* Logic: '<S120>/Logical Operator1' */
  rtb_LogicalOperator1_f = (rtb_RelationalOperator2 &&
    UDC_B.TON.LogicalOperator3 && UDC_B.TON1.LogicalOperator3);

  /* BusCreator: '<S9>/Bus Creator' */
  rtb_BusCreator_h_rNOx_SCR_CatOu = rtb_Switch_ah;
  rtb_BusCreator_h_rTSCRAvg = rtb_Switch3;

  /* BusSelector: '<S12>/Bus Selector15' */
  rtb_rTSCRAvg = UDC_B.BusInput.rP_Act_Norm_Filt;

  /* BusSelector: '<S12>/Bus Selector2' */
  rtb_Switch1_n = UDC_B.BusInput1.rNFlow_SCR_Urea100;

  /* SignalConversion: '<S12>/TmpSignal ConversionAtLookup Table DynamicInport3' incorporates:
   *  BusSelector: '<S12>/Bus Selector2'
   *  Constant: '<S12>/Constant1'
   */
  rtb_rUrClKiOffs_y[0] = 0.0F;
  rtb_rUrClKiOffs_y[1] = UDC_B.BusInput1.rNFlow_SCR_Urea30;
  rtb_rUrClKiOffs_y[2] = UDC_B.BusInput1.rNFlow_SCR_Urea50;
  rtb_rUrClKiOffs_y[3] = UDC_B.BusInput1.rNFlow_SCR_Urea75;
  rtb_rUrClKiOffs_y[4] = rtb_Switch1_n;

  /* Dynamic Look-Up Table Block: '<S12>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_Treal_T( &(rtb_Switch1_n), rtb_rUrClKiOffs_y,
    rtb_rTSCRAvg, UDC_ConstP.Constant_Value, 4U, inst);

  /* BusSelector: '<S15>/Bus Selector3' */
  rtb_rTiFiltUreaFFAdjust = UDC_B.BusInput2.FF.rTiFiltUreaFFAdjust;

  /* Gain: '<S15>/Gain1' */
  rtb_Gain1 = 0.0166666675F * UDC_B.BusInput2.FF.rUreaGainDeltaRamp;

  /* Product: '<S66>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S66>/sample time'
   *
   * About '<S66>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch_f = rtb_Gain1 * 0.1F;

  /* Logic: '<S15>/Logical Operator4' */
  rtb_RelationalOperator2 = !UDC_B.BusInput1.bSCR_UreaNFlowAutoCorr_Active;

  /* Logic: '<S15>/Logical Operator1' */
  rtb_LogicalOperator1_b = !UDC_B.BusInput1.bSCR_UreaNFlowAutoCorr_Active;

  /* Delay: '<S15>/Delay' */
  rtb_RelationalOperator_mq = (((UDC_PrevZCSigState.Delay_Reset_ZCE ==
    UDC_POS_ZCSIG) != rtb_LogicalOperator1_b) &&
    (UDC_PrevZCSigState.Delay_Reset_ZCE != UDC_UNINITIALIZED_ZCSIG));
  UDC_PrevZCSigState.Delay_Reset_ZCE = (uint8_T)rtb_LogicalOperator1_b;
  if (rtb_LogicalOperator1_b || rtb_RelationalOperator_mq) {
    UDC_DWork.Delay_DSTATE = 0.0F;
  }

  rtb_Switch2_l = UDC_DWork.Delay_DSTATE;

  /* Delay: '<S66>/Delay' */
  rtb_RelationalOperator_mq = (((UDC_PrevZCSigState.Delay_Reset_ZCE_n ==
    UDC_POS_ZCSIG) != rtb_RelationalOperator2) &&
    (UDC_PrevZCSigState.Delay_Reset_ZCE_n != UDC_UNINITIALIZED_ZCSIG));
  UDC_PrevZCSigState.Delay_Reset_ZCE_n = (uint8_T)rtb_RelationalOperator2;
  if (rtb_RelationalOperator2 || rtb_RelationalOperator_mq) {
    UDC_DWork.icLoad = 1U;
  }

  if (UDC_DWork.icLoad != 0) {
    UDC_DWork.Delay_DSTATE_d = UDC_B.BusInput1.rCF_SCR_UreaNFlowGain;
  }

  /* Switch: '<S66>/etaVolConst' incorporates:
   *  Delay: '<S15>/Delay'
   *  Sum: '<S15>/Add7'
   */
  if (rtb_RelationalOperator2) {
    rtb_UkYk1 = UDC_B.BusInput1.rCF_SCR_UreaNFlowGain;
  } else {
    rtb_UkYk1 = UDC_B.BusInput1.rCF_SCR_UreaNFlowGain + UDC_DWork.Delay_DSTATE;
  }

  /* End of Switch: '<S66>/etaVolConst' */

  /* Sum: '<S66>/Difference Inputs1' incorporates:
   *  Delay: '<S66>/Delay'
   */
  rtb_UkYk1 -= UDC_DWork.Delay_DSTATE_d;

  /* Switch: '<S80>/Switch2' incorporates:
   *  RelationalOperator: '<S80>/LowerRelop1'
   */
  if (!(rtb_UkYk1 > rtb_Switch_f)) {
    /* Product: '<S66>/delta fall limit' incorporates:
     *  Gain: '<S15>/Gain3'
     *  SampleTimeMath: '<S66>/sample time'
     *
     * About '<S66>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_etaVolConst = -rtb_Gain1 * 0.1F;

    /* Switch: '<S80>/Switch' incorporates:
     *  RelationalOperator: '<S80>/UpperRelop'
     */
    if (rtb_UkYk1 < rtb_etaVolConst) {
      rtb_Switch_f = rtb_etaVolConst;
    } else {
      rtb_Switch_f = rtb_UkYk1;
    }

    /* End of Switch: '<S80>/Switch' */
  }

  /* End of Switch: '<S80>/Switch2' */

  /* Sum: '<S66>/Difference Inputs2' incorporates:
   *  Delay: '<S66>/Delay'
   */
  rtb_DifferenceInputs2 = rtb_Switch_f + UDC_DWork.Delay_DSTATE_d;

  /* Product: '<S12>/Divide4' */
  rtb_rFlowUreaFF_LT = rtb_Switch1_n * rtb_DifferenceInputs2;

  /* Outputs for Atomic SubSystem: '<Root>/SlipDetection' */
  /* Logic: '<S137>/Logical Operator1' */
  rtb_LogicalOperator1_o = (UDC_B.BusInput.bSCR_Man ||
    UDC_B.BusInput.bSCR_NOxControl_Man || UDC_B.BusInput.bSCR_UreaDosingUnit_Man);

  /* Logic: '<S137>/Logical Operator10' */
  rtb_LogicalOperator1_b = !UDC_B.BusInput.bRel_SCR_Dosing;

  /* Outputs for Atomic SubSystem: '<S137>/TOF' */
  /* Logic: '<S143>/Logical Operator' */
  rtb_RelationalOperator2 = (rtb_LogicalOperator1_b || rtb_LogicalOperator1_o);

  /* Product: '<S147>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S147>/sample time'
   *
   * About '<S147>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_UkYk1 = 0.1F;

  /* Switch: '<S143>/Switch' incorporates:
   *  UnitDelay: '<S143>/Unit Delay'
   */
  if (UDC_DWork.UnitDelay_DSTATE_jw) {
    /* Gain: '<S143>/Gain' */
    rtb_etaVolConst = 1.1F * UDC_B.BusInput2.Slip.rTiWaitSCRMan;
  } else {
    /* Gain: '<S143>/Gain' incorporates:
     *  Constant: '<S143>/Constant4'
     */
    rtb_etaVolConst = 0.0F;
  }

  /* End of Switch: '<S143>/Switch' */

  /* Switch: '<S147>/etaVolConst' */
  if (rtb_RelationalOperator2) {
    rtb_Gain1 = rtb_etaVolConst;
  } else {
    rtb_Gain1 = UDC_B.BusInput2.Slip.rTiWaitSCRMan;
  }

  /* End of Switch: '<S147>/etaVolConst' */

  /* Delay: '<S147>/Delay' */
  rtb_RelationalOperator_mq = (((UDC_PrevZCSigState.Delay_Reset_ZCE_b ==
    UDC_POS_ZCSIG) != rtb_RelationalOperator2) &&
    (UDC_PrevZCSigState.Delay_Reset_ZCE_b != UDC_UNINITIALIZED_ZCSIG));
  UDC_PrevZCSigState.Delay_Reset_ZCE_b = (uint8_T)rtb_RelationalOperator2;
  if (rtb_RelationalOperator2 || rtb_RelationalOperator_mq) {
    UDC_DWork.icLoad_d = 1U;
  }

  if (UDC_DWork.icLoad_d != 0) {
    UDC_DWork.Delay_DSTATE_f = rtb_etaVolConst;
  }

  /* Sum: '<S147>/Difference Inputs1' incorporates:
   *  Delay: '<S147>/Delay'
   */
  rtb_Gain1 -= UDC_DWork.Delay_DSTATE_f;

  /* Switch: '<S148>/Switch2' incorporates:
   *  RelationalOperator: '<S148>/LowerRelop1'
   */
  if (!(rtb_Gain1 > 0.1F)) {
    /* Switch: '<S148>/Switch' incorporates:
     *  RelationalOperator: '<S148>/UpperRelop'
     */
    if (rtb_Gain1 < -0.1F) {
      rtb_UkYk1 = -0.1F;
    } else {
      rtb_UkYk1 = rtb_Gain1;
    }

    /* End of Switch: '<S148>/Switch' */
  }

  /* End of Switch: '<S148>/Switch2' */

  /* Sum: '<S147>/Difference Inputs2' incorporates:
   *  Delay: '<S147>/Delay'
   */
  rtb_Gain1 = rtb_UkYk1 + UDC_DWork.Delay_DSTATE_f;

  /* RelationalOperator: '<S143>/Relational Operator' */
  rtb_RelationalOperator_mq = (rtb_Gain1 < UDC_B.BusInput2.Slip.rTiWaitSCRMan);

  /* Update for UnitDelay: '<S143>/Unit Delay' */
  UDC_DWork.UnitDelay_DSTATE_jw = rtb_LogicalOperator1_b;

  /* Update for Delay: '<S147>/Delay' */
  UDC_DWork.icLoad_d = 0U;
  UDC_DWork.Delay_DSTATE_f = rtb_Gain1;

  /* End of Outputs for SubSystem: '<S137>/TOF' */

  /* Logic: '<S137>/Logical Operator9' */
  rtb_RelationalOperator2 = !UDC_B.BusInput.bSCR_NH3SlipDetect_Blocked;

  /* BusSelector: '<S137>/Bus Selector3' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   */
  rtb_bSCR_EngineSteadyState_i = rtb_LogicalOperator1_f;

  /* BusSelector: '<S137>/Bus Selector4' */
  rtb_rTiWaitSteadyState = UDC_B.BusInput2.Slip.rTiWaitSteadyState;

  /* Outputs for Atomic SubSystem: '<S137>/TON' */
  UDC_TON(rtb_bSCR_EngineSteadyState_i, rtb_rTiWaitSteadyState, &UDC_B.TON_a,
          &UDC_DWork.TON_a, inst);

  /* End of Outputs for SubSystem: '<S137>/TON' */

  /* UnitDelay: '<S10>/Unit Delay' */
  rtb_UnitDelay_h = UDC_DWork.UnitDelay_DSTATE_l;

  /* RelationalOperator: '<S142>/FixPt Relational Operator' incorporates:
   *  UnitDelay: '<S142>/Delay Input1'
   */
  rtb_FixPtRelationalOperator = ((int32_T)rtb_UnitDelay_h < (int32_T)
    UDC_DWork.DelayInput1_DSTATE);

  /* BusSelector: '<S137>/Bus Selector5' */
  rtb_rTi_SlipDetectWait = UDC_B.BusInput2.Slip.rTi_SlipDetectWait;

  /* Outputs for Atomic SubSystem: '<S137>/TP' */
  UDC_TP(rtb_FixPtRelationalOperator, rtb_rTi_SlipDetectWait, &UDC_B.TP_e,
         &UDC_DWork.TP_e, inst);

  /* End of Outputs for SubSystem: '<S137>/TP' */

  /* Logic: '<S137>/Logical Operator12' */
  rtb_LogicalOperator1_b = !UDC_B.TP_e.LogicalOperator1;

  /* BusSelector: '<S137>/Bus Selector11' */
  rtb_bRel_SCR_Dosing_no = UDC_B.BusInput.bRel_SCR_Dosing;

  /* BusSelector: '<S137>/Bus Selector10' */
  rtb_rTiSCR_EAC_DurationStartup = UDC_B.BusInput1.rTiSCR_EAC_DurationStartup;

  /* Outputs for Atomic SubSystem: '<S137>/TON3' */
  UDC_TON(rtb_bRel_SCR_Dosing_no, rtb_rTiSCR_EAC_DurationStartup, &UDC_B.TON3,
          &UDC_DWork.TON3, inst);

  /* End of Outputs for SubSystem: '<S137>/TON3' */

  /* Outputs for Atomic SubSystem: '<S137>/TOF' */
  /* Logic: '<S137>/Logical Operator8' incorporates:
   *  Logic: '<S137>/Logical Operator5'
   *  Logic: '<S143>/Logical Operator3'
   */
  rtb_bNH3SlipCtrlEna = ((!(rtb_RelationalOperator_mq || rtb_LogicalOperator1_o))
    && rtb_RelationalOperator2 && UDC_B.TON_a.LogicalOperator3 &&
    UDC_B.BusInput1.bSCR_NH3SlipDetect_Active && rtb_LogicalOperator1_b &&
    UDC_B.TON3.LogicalOperator3);

  /* End of Outputs for SubSystem: '<S137>/TOF' */

  /* Logic: '<S141>/Logical Operator8' incorporates:
   *  Logic: '<S141>/Logical Operator9'
   *  UnitDelay: '<S141>/Unit Delay'
   */
  rtb_bSCR_NH3SlipInterrupt_k = ((!rtb_bNH3SlipCtrlEna) &&
    UDC_DWork.UnitDelay_DSTATE_dg);

  /* Switch: '<S141>/Switch1' incorporates:
   *  Constant: '<S141>/Constant7'
   */
  if (rtb_bSCR_NH3SlipInterrupt_k) {
    rtb_Switch2_p = 100.0F;
  } else {
    rtb_Switch2_p = UDC_B.BusInput2.Slip.rNH3SlipActSlope;
  }

  /* End of Switch: '<S141>/Switch1' */

  /* Product: '<S202>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S202>/sample time'
   *
   * About '<S202>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_kp = rtb_Switch2_p * 0.1F;

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* BusSelector: '<S139>/Bus Selector' incorporates:
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_rNOx_EMLineOxiIn = rNOx_EMLineOxiIn;

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* BusSelector: '<S139>/Bus Selector3' */
  rtb_rCemsIntFiltFact = UDC_B.BusInput2.Slip.rCemsIntFiltFact;

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Logic: '<S138>/Logical Operator10' incorporates:
   *  Logic: '<S138>/Logical Operator16'
   *  Logic: '<S138>/Logical Operator17'
   *  Logic: '<S138>/Logical Operator9'
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_RelationalOperator2 = (UDC_B.BusInput.bEMLine1_Exist &&
    (!UDC_B.BusInput.bEMLine2_Exist) && ((boolean_T)((int32_T)bEMLineCatOut_GQ ^
                               (int32_T)bEMLineOxiIn_GQ)) && rtb_UnitDelay_h);

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* Logic: '<S138>/Logical Operator15' incorporates:
   *  Logic: '<S138>/Logical Operator14'
   */
  rtb_LogicalOperator1_b = (UDC_B.BusInput.bEMLine1_Exist &&
    (!UDC_B.BusInput.bEMLine2_Exist));

  /* Logic: '<S138>/Logical Operator12' */
  rtb_RelationalOperator_mq = !rtb_UnitDelay_h;

  /* Logic: '<S138>/Logical Operator6' incorporates:
   *  UnitDelay: '<S138>/Unit Delay2'
   */
  rtb_LogicalOperator1_o = !UDC_DWork.UnitDelay2_DSTATE_f;

  /* Product: '<S138>/Divide1' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   */
  rtb_etaVolConst = rtb_Switch_ah * UDC_B.BusInput2.Slip.rNOxMarginSet;

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Logic: '<S138>/Logical Operator2' incorporates:
   *  MATLAB Function: '<S119>/MATLAB Function'
   *  RelationalOperator: '<S138>/Relational Operator2'
   */
  rtb_LogicalOperator2_f = (bEMLineCatOut_GQ && rtb_bNH3SlipCtrlEna &&
    rtb_LogicalOperator1_o && (rNOx_EMLineCatOut > rtb_etaVolConst));

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* BusSelector: '<S138>/Bus Selector5' */
  rtb_rTiNOxMarginDelay = UDC_B.BusInput2.Slip.rTiNOxMarginDelay;

  /* Outputs for Atomic SubSystem: '<S138>/TON' */
  UDC_TON(rtb_LogicalOperator2_f, rtb_rTiNOxMarginDelay, &UDC_B.TON_i,
          &UDC_DWork.TON_i, inst);

  /* End of Outputs for SubSystem: '<S138>/TON' */

  /* Product: '<S138>/Divide3' */
  rtb_etaVolConst = rtb_rFlowUreaFF_LT * UDC_B.BusInput2.Slip.rNOxMarginFFLT;

  /* Logic: '<S138>/Logical Operator4' incorporates:
   *  RelationalOperator: '<S138>/Relational Operator1'
   */
  rtb_LogicalOperator4_m = ((UDC_B.BusInput.tFlow_SCR_UreaDosingOut.Ai >
    rtb_etaVolConst) && rtb_LogicalOperator1_o && rtb_bNH3SlipCtrlEna);

  /* BusSelector: '<S138>/Bus Selector8' */
  rtb_rTiNOxMarginDelay_j = UDC_B.BusInput2.Slip.rTiNOxMarginDelay;

  /* Outputs for Atomic SubSystem: '<S138>/TON1' */
  UDC_TON(rtb_LogicalOperator4_m, rtb_rTiNOxMarginDelay_j, &UDC_B.TON1_k,
          &UDC_DWork.TON1_k, inst);

  /* End of Outputs for SubSystem: '<S138>/TON1' */

  /* Logic: '<S138>/Logical Operator5' incorporates:
   *  UnitDelay: '<S10>/Unit Delay2'
   */
  rtb_LogicalOperator5_m = (UDC_DWork.UnitDelay2_DSTATE_i &&
    rtb_LogicalOperator1_o && rtb_bNH3SlipCtrlEna);

  /* BusSelector: '<S138>/Bus Selector9' */
  rtb_rTiNOxCLSatDelay = UDC_B.BusInput2.Slip.rTiNOxCLSatDelay;

  /* Outputs for Atomic SubSystem: '<S138>/TON2' */
  UDC_TON(rtb_LogicalOperator5_m, rtb_rTiNOxCLSatDelay, &UDC_B.TON2,
          &UDC_DWork.TON2, inst);

  /* End of Outputs for SubSystem: '<S138>/TON2' */

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Logic: '<S138>/Logical Operator' incorporates:
   *  Logic: '<S138>/Logical Operator1'
   *  Logic: '<S138>/Logical Operator3'
   *  Logic: '<S138>/Logical Operator7'
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_LogicalOperator_b1 = (rtb_LogicalOperator1_b && ((boolean_T)((int32_T)
    bEMLineCatOut_GQ ^ (int32_T)bEMLineOxiIn_GQ)) && rtb_RelationalOperator_mq &&
    rtb_bNH3SlipCtrlEna && UDC_B.TON_i.LogicalOperator3 &&
    (UDC_B.TON1_k.LogicalOperator3 || UDC_B.TON2.LogicalOperator3));

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* BusSelector: '<S138>/Bus Selector3' */
  rtb_rTiSwitchValve = UDC_B.BusInput2.Slip.rTiSwitchValve;

  /* Outputs for Atomic SubSystem: '<S138>/TP1' */
  UDC_TP(rtb_LogicalOperator_b1, rtb_rTiSwitchValve, &UDC_B.TP1, &UDC_DWork.TP1, inst);

  /* End of Outputs for SubSystem: '<S138>/TP1' */

  /* Logic: '<S138>/Logical Operator8' */
  rtb_LogicalOperator8 = (rtb_RelationalOperator2 || UDC_B.TP1.LogicalOperator1);

  /* BusSelector: '<S139>/Bus Selector5' */
  rtb_rTiWaitSwitch = UDC_B.BusInput2.Slip.rTiWaitSwitch;

  /* Outputs for Atomic SubSystem: '<S139>/TP' */
  UDC_TP(rtb_LogicalOperator8, rtb_rTiWaitSwitch, &UDC_B.TP_m, &UDC_DWork.TP_m, inst);

  /* End of Outputs for SubSystem: '<S139>/TP' */

  /* Logic: '<S139>/Logical Operator1' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   *  Logic: '<S139>/Logical Operator2'
   */
  rtb_LogicalOperator1_m = (UDC_B.BusInput2.Slip.bCemsIntFiltRes ||
    (!rtb_LogicalOperator1_f) || UDC_B.TP_m.LogicalOperator1);

  /* Outputs for Atomic SubSystem: '<S139>/Filter_OxiIn' */
  UDC_Filter(rtb_rCemsIntFiltFact, rtb_LogicalOperator1_m, rtb_rNOx_EMLineOxiIn,
             &UDC_B.Filter_OxiIn, &UDC_DWork.Filter_OxiIn, inst);

  /* End of Outputs for SubSystem: '<S139>/Filter_OxiIn' */

  /* UnitDelay: '<S139>/Unit Delay4' */
  rtb_etaVolConst = UDC_DWork.UnitDelay4_DSTATE;

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* BusSelector: '<S139>/Bus Selector4' incorporates:
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_rNOx_EMLineCatOut_b = rNOx_EMLineCatOut;

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* Outputs for Atomic SubSystem: '<S139>/Filter_CatOut' */
  UDC_Filter(rtb_rCemsIntFiltFact, rtb_LogicalOperator1_m,
             rtb_rNOx_EMLineCatOut_b, &UDC_B.Filter_CatOut,
             &UDC_DWork.Filter_CatOut, inst);

  /* End of Outputs for SubSystem: '<S139>/Filter_CatOut' */

  /* Switch: '<S139>/Switch4' */
  if (rtb_LogicalOperator8) {
    rtb_Switch4 = rtb_etaVolConst;
  } else {
    rtb_Switch4 = UDC_B.Filter_CatOut.Switch;
  }

  /* End of Switch: '<S139>/Switch4' */

  /* Sum: '<S139>/Add4' */
  rtb_Gain1 = rtb_Switch4 - UDC_B.Filter_OxiIn.Switch;

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Logic: '<S139>/Logical Operator7' incorporates:
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_RelationalOperator2 = (UDC_B.BusInput.bEMLine1_Exist &&
    UDC_B.BusInput.bEMLine2_Exist && bEMLineCatOut_GQ && bEMLineOxiIn_GQ);

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* CombinatorialLogic: '<S156>/Logic' incorporates:
   *  Logic: '<S138>/Logical Operator11'
   *  Logic: '<S138>/Logical Operator13'
   *  Memory: '<S156>/Memory'
   */
  rtb_DataTypeConversion = ((((uint32_T)!rtb_bNH3SlipCtrlEna << 1) + (uint32_T)
    !UDC_B.TP1.LogicalOperator1) << 1) + (uint32_T)
    UDC_DWork.Memory_PreviousInput;
  rtb_Logic[0U] = UDC_ConstP.pooled28[rtb_DataTypeConversion];
  rtb_Logic[1U] = UDC_ConstP.pooled28[rtb_DataTypeConversion + 8U];

  /* Logic: '<S139>/Logical Operator4' incorporates:
   *  Logic: '<S139>/Logical Operator5'
   */
  rtb_LogicalOperator4_l = ((!rtb_Logic[0]) && rtb_LogicalOperator8);

  /* Gain: '<S139>/Gain' */
  rtb_Gain_a = 0.99F * UDC_B.BusInput2.Slip.rTiSwitchValve;

  /* Outputs for Atomic SubSystem: '<S139>/TON' */
  UDC_TON(rtb_LogicalOperator4_l, rtb_Gain_a, &UDC_B.TON_o, &UDC_DWork.TON_o, inst);

  /* End of Outputs for SubSystem: '<S139>/TON' */

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Logic: '<S139>/Logical Operator8' incorporates:
   *  Logic: '<S139>/Logical Operator9'
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_RelationalOperator2 = (rtb_RelationalOperator2 || (bEMLineOxiIn_GQ &&
    UDC_B.TON_o.LogicalOperator3));

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* Switch: '<S141>/Switch4' incorporates:
   *  Constant: '<S141>/Constant6'
   */
  if (rtb_bNH3SlipCtrlEna) {
    /* Switch: '<S10>/Switch1' */
    if (rtb_RelationalOperator2) {
      /* Switch: '<S170>/Switch' incorporates:
       *  Abs: '<S170>/Abs'
       *  Constant: '<S170>/Constant2'
       *  RelationalOperator: '<S170>/Relational Operator'
       */
      if (1.1920929E-7F >= (real32_T)fabs(UDC_B.BusInput1.rNOx_SCR_EngOut_Expect))
      {
        rtb_Product_k = 1.1920929E-7F;
      } else {
        rtb_Product_k = UDC_B.BusInput1.rNOx_SCR_EngOut_Expect;
      }

      /* End of Switch: '<S170>/Switch' */

      /* Product: '<S139>/Divide1' */
      rtb_etaVolConst = rtb_Gain1 * UDC_B.BusInput2.Slip.rGainSlipCor /
        rtb_Product_k;

      /* Saturate: '<S139>/Saturation' incorporates:
       *  Constant: '<S139>/Constant5'
       *  Sum: '<S139>/Add6'
       */
      if (1.0F - rtb_etaVolConst >= 1.0F) {
        rtb_Switch_f = 1.0F;
      } else if (1.0F - rtb_etaVolConst <= 0.0F) {
        rtb_Switch_f = 0.0F;
      } else {
        rtb_Switch_f = 1.0F - rtb_etaVolConst;
      }

      /* End of Saturate: '<S139>/Saturation' */
    } else {
      /* Sum: '<S140>/Add1' incorporates:
       *  BusCreator: '<S9>/Bus Creator'
       */
      rtb_etaVolConst = rtb_rNOxEngOutCor_e -
        UDC_B.BusInput1.rNOx_SCR_CatOut_Set;

      /* Switch: '<S186>/Switch' incorporates:
       *  Abs: '<S186>/Abs'
       *  RelationalOperator: '<S186>/Relational Operator'
       */
      if (0.1F >= (real32_T)fabs(rtb_etaVolConst)) {
        rtb_etaVolConst = 0.1F;
      }

      /* End of Switch: '<S186>/Switch' */

      /* Product: '<S140>/Divide2' incorporates:
       *  BusCreator: '<S9>/Bus Creator'
       *  Sum: '<S140>/Add'
       */
      rtb_Switch_f = UDC_B.BusInput2.Slip.rGainSlipCorSens * rtb_rFlowUreaFF_LT /
        rtb_etaVolConst / UDC_B.BusInput.tFlow_SCR_UreaDosingOut.Ai *
        (rtb_rNOxEngOutCor_e - UDC_B.BusInput.tNOx_SCR_CatOut.Ai);
    }

    /* End of Switch: '<S10>/Switch1' */
  } else {
    rtb_Switch_f = 1.0F;
  }

  /* End of Switch: '<S141>/Switch4' */

  /* Sum: '<S139>/Add1' */
  rtb_etaVolConst = rtb_Gain1 - UDC_B.BusInput1.rDNOx_SCR_NH3Slip_Hi;

  /* Relay: '<S139>/Relay1' */
  if (rtb_etaVolConst >= 0.0F) {
    UDC_DWork.Relay1_Mode = TRUE;
  } else {
    if (rtb_etaVolConst <= -2.0F) {
      UDC_DWork.Relay1_Mode = FALSE;
    }
  }

  if (UDC_DWork.Relay1_Mode) {
    rtb_etaVolConst = 1.0F;
  } else {
    rtb_etaVolConst = 0.0F;
  }

  /* End of Relay: '<S139>/Relay1' */

  /* Product: '<S140>/Divide3' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   */
  rtb_Gain1 = rtb_Switch_ah * UDC_B.BusInput2.Slip.rNOxMarginSet;

  /* Product: '<S140>/Divide1' */
  rtb_UkYk1 = UDC_B.BusInput2.Slip.rNOxMarginFFLT * rtb_rFlowUreaFF_LT;

  /* Logic: '<S140>/Logical Operator' incorporates:
   *  RelationalOperator: '<S140>/Relational Operator'
   *  RelationalOperator: '<S140>/Relational Operator1'
   */
  rtb_LogicalOperator_k = (UDC_B.BusInput.tNOx_SCR_CatOut.GoodQual &&
    (UDC_B.BusInput.tNOx_SCR_CatOut.Ai > rtb_Gain1) &&
    (UDC_B.BusInput.tFlow_SCR_UreaDosingOut.Ai > rtb_UkYk1));

  /* BusSelector: '<S140>/Bus Selector15' */
  rtb_rTiNOxMarginDelay_d = UDC_B.BusInput2.Slip.rTiNOxMarginDelay;

  /* Outputs for Atomic SubSystem: '<S140>/TON' */
  UDC_TON(rtb_LogicalOperator_k, rtb_rTiNOxMarginDelay_d, &UDC_B.TON_fg,
          &UDC_DWork.TON_fg, inst);

  /* End of Outputs for SubSystem: '<S140>/TON' */

  /* BusSelector: '<S140>/Bus Selector19' */
  rtb_rTiWaitNH3slip_fallback = UDC_B.BusInput.rTiWaitNH3slip_fallback;

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Logic: '<S140>/Logical Operator7' incorporates:
   *  Logic: '<S140>/Logical Operator10'
   *  Logic: '<S140>/Logical Operator11'
   *  Logic: '<S140>/Logical Operator13'
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_LogicalOperator7_n = ((!bEMLineCatOut_GQ) && (!bEMLineOxiIn_GQ) &&
    (!UDC_B.BusInput.bSCR_Man));

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* Outputs for Atomic SubSystem: '<S140>/TON1' */
  UDC_TON(rtb_LogicalOperator7_n, rtb_rTiWaitNH3slip_fallback, &UDC_B.TON1_p,
          &UDC_DWork.TON1_p, inst);

  /* End of Outputs for SubSystem: '<S140>/TON1' */

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Logic: '<S140>/Logical Operator20' incorporates:
   *  Logic: '<S140>/Logical Operator16'
   *  Logic: '<S140>/Logical Operator18'
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_LogicalOperator20 = ((!bEMLineCatOut_GQ) && (!UDC_B.BusInput.bSCR_Man));

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* Outputs for Atomic SubSystem: '<S140>/TON2' */
  UDC_TON(rtb_LogicalOperator20, rtb_rTiWaitNH3slip_fallback, &UDC_B.TON2_a,
          &UDC_DWork.TON2_a, inst);

  /* End of Outputs for SubSystem: '<S140>/TON2' */

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Logic: '<S140>/Logical Operator21' incorporates:
   *  Logic: '<S140>/Logical Operator17'
   *  Logic: '<S140>/Logical Operator19'
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  rtb_LogicalOperator21 = ((!bEMLineOxiIn_GQ) && (!UDC_B.BusInput.bSCR_Man));

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* Outputs for Atomic SubSystem: '<S140>/TON3' */
  UDC_TON(rtb_LogicalOperator21, rtb_rTiWaitNH3slip_fallback, &UDC_B.TON3_p,
          &UDC_DWork.TON3_p, inst);

  /* End of Outputs for SubSystem: '<S140>/TON3' */

  /* Switch: '<S10>/Switch4' incorporates:
   *  Constant: '<S169>/Constant'
   *  Logic: '<S139>/Logical Operator12'
   *  Logic: '<S139>/Logical Operator3'
   *  Logic: '<S140>/Logical Operator1'
   *  Logic: '<S140>/Logical Operator12'
   *  Logic: '<S140>/Logical Operator14'
   *  Logic: '<S140>/Logical Operator15'
   *  Logic: '<S140>/Logical Operator2'
   *  Logic: '<S140>/Logical Operator3'
   *  Logic: '<S140>/Logical Operator4'
   *  Logic: '<S140>/Logical Operator5'
   *  Logic: '<S140>/Logical Operator6'
   *  Logic: '<S140>/Logical Operator8'
   *  Logic: '<S140>/Logical Operator9'
   *  RelationalOperator: '<S169>/Compare'
   */
  if (rtb_RelationalOperator2) {
    rtb_RelationalOperator2 = (rtb_bNH3SlipCtrlEna && (!rtb_UnitDelay_h) &&
      (rtb_etaVolConst > 0.0F));
  } else {
    rtb_RelationalOperator2 = (UDC_B.TON_fg.LogicalOperator3 &&
      rtb_bNH3SlipCtrlEna && (!rtb_UnitDelay_h) &&
      (((!UDC_B.BusInput.bEMLine1_Exist) && (!UDC_B.BusInput.bEMLine2_Exist)) ||
       (UDC_B.BusInput.bEMLine1_Exist && (!UDC_B.BusInput.bEMLine2_Exist) &&
        UDC_B.TON1_p.LogicalOperator3) || (UDC_B.BusInput.bEMLine1_Exist &&
      UDC_B.BusInput.bEMLine2_Exist && (UDC_B.TON2_a.LogicalOperator3 ||
      UDC_B.TON3_p.LogicalOperator3))));
  }

  /* End of Switch: '<S10>/Switch4' */

  /* RelationalOperator: '<S205>/Compare' incorporates:
   *  Constant: '<S205>/Constant'
   *  Logic: '<S141>/Logical Operator1'
   */
  rtb_Compare = (rtb_bNH3SlipCtrlEna && rtb_RelationalOperator2);

  /* RelationalOperator: '<S198>/FixPt Relational Operator' incorporates:
   *  UnitDelay: '<S198>/Delay Input1'
   */
  rtb_RelationalOperator2 = ((int32_T)rtb_Compare > (int32_T)
    UDC_DWork.DelayInput1_DSTATE_m);

  /* Switch: '<S202>/etaVolConst' incorporates:
   *  Constant: '<S141>/Constant3'
   */
  if (rtb_RelationalOperator2) {
    rtb_etaVolConst_p = rtb_Switch_f;
  } else {
    rtb_etaVolConst_p = 1.0F;
  }

  /* End of Switch: '<S202>/etaVolConst' */

  /* Delay: '<S202>/Delay' */
  rtb_RelationalOperator_mq = (((UDC_PrevZCSigState.Delay_Reset_ZCE_d ==
    UDC_POS_ZCSIG) != rtb_RelationalOperator2) &&
    (UDC_PrevZCSigState.Delay_Reset_ZCE_d != UDC_UNINITIALIZED_ZCSIG));
  UDC_PrevZCSigState.Delay_Reset_ZCE_d = (uint8_T)rtb_RelationalOperator2;
  if (rtb_RelationalOperator2 || rtb_RelationalOperator_mq) {
    UDC_DWork.icLoad_g = 1U;
  }

  if (UDC_DWork.icLoad_g != 0) {
    UDC_DWork.Delay_DSTATE_k = rtb_Switch_f;
  }

  /* Sum: '<S202>/Difference Inputs1' incorporates:
   *  Delay: '<S202>/Delay'
   */
  rtb_Gain1 = rtb_etaVolConst_p - UDC_DWork.Delay_DSTATE_k;

  /* Switch: '<S209>/Switch2' incorporates:
   *  RelationalOperator: '<S209>/LowerRelop1'
   */
  if (!(rtb_Gain1 > rtb_Switch2_kp)) {
    /* Switch: '<S209>/Switch' incorporates:
     *  RelationalOperator: '<S209>/UpperRelop'
     */
    if (rtb_Gain1 < 0.0F) {
      rtb_Switch2_kp = 0.0F;
    } else {
      rtb_Switch2_kp = rtb_Gain1;
    }

    /* End of Switch: '<S209>/Switch' */
  }

  /* End of Switch: '<S209>/Switch2' */

  /* Sum: '<S202>/Difference Inputs2' incorporates:
   *  Delay: '<S202>/Delay'
   */
  rtb_DifferenceInputs2_i = rtb_Switch2_kp + UDC_DWork.Delay_DSTATE_k;

  /* RelationalOperator: '<S196>/Compare' incorporates:
   *  Constant: '<S196>/Constant'
   */
  rtb_Compare_l = (rtb_DifferenceInputs2_i < 1.0F);

  /* Product: '<S203>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S203>/sample time'
   *
   * About '<S203>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_p *= 0.1F;

  /* BusSelector: '<S141>/Bus Selector1' */
  rtb_etaVolConst = UDC_B.BusInput2.Slip.rGainFreezeCtr;

  /* Saturate: '<S141>/Saturation' */
  if (rtb_etaVolConst >= 1.0F) {
    rtb_etaVolConst = 1.0F;
  } else {
    if (rtb_etaVolConst <= 0.0F) {
      rtb_etaVolConst = 0.0F;
    }
  }

  /* Sum: '<S141>/Add' incorporates:
   *  Constant: '<S141>/Constant1'
   *  Constant: '<S141>/Constant2'
   *  Product: '<S141>/Product'
   *  Saturate: '<S141>/Saturation'
   *  Sum: '<S141>/Add1'
   */
  rtb_etaVolConst = (rtb_Switch_f - 1.0F) * rtb_etaVolConst + 1.0F;

  /* Switch: '<S203>/etaVolConst' incorporates:
   *  Constant: '<S141>/Constant3'
   */
  if (rtb_RelationalOperator2) {
    rtb_etaVolConst_f = rtb_etaVolConst;
  } else {
    rtb_etaVolConst_f = 1.0F;
  }

  /* End of Switch: '<S203>/etaVolConst' */

  /* Delay: '<S203>/Delay' */
  rtb_RelationalOperator_mq = (((UDC_PrevZCSigState.Delay_Reset_ZCE_i ==
    UDC_POS_ZCSIG) != rtb_RelationalOperator2) &&
    (UDC_PrevZCSigState.Delay_Reset_ZCE_i != UDC_UNINITIALIZED_ZCSIG));
  UDC_PrevZCSigState.Delay_Reset_ZCE_i = (uint8_T)rtb_RelationalOperator2;
  if (rtb_RelationalOperator2 || rtb_RelationalOperator_mq) {
    UDC_DWork.icLoad_e = 1U;
  }

  if (UDC_DWork.icLoad_e != 0) {
    UDC_DWork.Delay_DSTATE_h = rtb_etaVolConst;
  }

  /* Sum: '<S203>/Difference Inputs1' incorporates:
   *  Delay: '<S203>/Delay'
   */
  rtb_Gain1 = rtb_etaVolConst_f - UDC_DWork.Delay_DSTATE_h;

  /* Switch: '<S210>/Switch2' incorporates:
   *  RelationalOperator: '<S210>/LowerRelop1'
   */
  if (!(rtb_Gain1 > rtb_Switch2_p)) {
    /* Switch: '<S210>/Switch' incorporates:
     *  RelationalOperator: '<S210>/UpperRelop'
     */
    if (rtb_Gain1 < 0.0F) {
      rtb_Switch2_p = 0.0F;
    } else {
      rtb_Switch2_p = rtb_Gain1;
    }

    /* End of Switch: '<S210>/Switch' */
  }

  /* End of Switch: '<S210>/Switch2' */

  /* Sum: '<S203>/Difference Inputs2' incorporates:
   *  Delay: '<S203>/Delay'
   */
  rtb_DifferenceInputs2_a = rtb_Switch2_p + UDC_DWork.Delay_DSTATE_h;

  /* RelationalOperator: '<S197>/Compare' incorporates:
   *  Constant: '<S197>/Constant'
   */
  rtb_Compare_f = (rtb_DifferenceInputs2_a < 1.0F);

  /* Logic: '<S141>/Logical Operator4' */
  rtb_LogicalOperator1_b = !rtb_Compare_f;

  /* BusSelector: '<S141>/Bus Selector15' */
  rtb_rTiSCR_NH3Slip_WaitNOxGrad_ =
    UDC_B.BusInput1.rTiSCR_NH3Slip_WaitNOxGrad_CL;

  /* Outputs for Atomic SubSystem: '<S141>/TON' */
  UDC_TON(rtb_Compare_f, rtb_rTiSCR_NH3Slip_WaitNOxGrad_, &UDC_B.TON_p,
          &UDC_DWork.TON_p, inst);

  /* End of Outputs for SubSystem: '<S141>/TON' */

  /* Outputs for Atomic SubSystem: '<S141>/Filter1' */
  /* RelationalOperator: '<S199>/Relational Operator' incorporates:
   *  Constant: '<S199>/Constant'
   */
  rtb_RelationalOperator2 = (UDC_B.BusInput2.Slip.rTiFilter_Nox > 0.0F);

  /* Logic: '<S199>/Logical Operator' incorporates:
   *  Logic: '<S199>/Logical Operator1'
   */
  rtb_LogicalOperator_e = (UDC_B.BusInput.bOpModeStop ||
    (!rtb_RelationalOperator2));

  /* DiscreteIntegrator: '<S199>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator_e || (UDC_DWork.DiscreteTimeIntegrator_PrevRe_e != 0))
  {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE_o = 0.0F;
  }

  /* Abs: '<S206>/Abs' */
  rtb_etaVolConst = (real32_T)fabs(UDC_B.BusInput2.Slip.rTiFilter_Nox);

  /* Switch: '<S206>/Switch' incorporates:
   *  RelationalOperator: '<S206>/Relational Operator'
   */
  if (2.22044605E-16F >= rtb_etaVolConst) {
    rtb_etaVolConst = 2.22044605E-16F;
  } else {
    rtb_etaVolConst = UDC_B.BusInput2.Slip.rTiFilter_Nox;
  }

  /* End of Switch: '<S206>/Switch' */

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  /* Product: '<S199>/Divide4' incorporates:
   *  DiscreteIntegrator: '<S199>/Discrete-Time Integrator'
   *  MATLAB Function: '<S119>/MATLAB Function'
   *  Sum: '<S199>/Sum4'
   */
  rtb_etaVolConst = (rNOx_Act - UDC_DWork.DiscreteTimeIntegrator_DSTATE_o) /
    rtb_etaVolConst;

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* Update for DiscreteIntegrator: '<S199>/Discrete-Time Integrator' */
  if (!rtb_LogicalOperator_e) {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE_o += 0.1F * rtb_etaVolConst;
  }

  if (rtb_LogicalOperator_e) {
    UDC_DWork.DiscreteTimeIntegrator_PrevRe_e = 1;
  } else {
    UDC_DWork.DiscreteTimeIntegrator_PrevRe_e = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S199>/Discrete-Time Integrator' */

  /* Switch: '<S199>/Switch1' incorporates:
   *  Constant: '<S199>/Constant'
   */
  if (rtb_LogicalOperator_e) {
    rtb_etaVolConst = 0.0F;
  }

  /* End of Switch: '<S199>/Switch1' */
  /* End of Outputs for SubSystem: '<S141>/Filter1' */

  /* RelationalOperator: '<S141>/Relational Operator' */
  rtb_RelationalOperator2 = (rtb_etaVolConst > UDC_B.BusInput2.Slip.rNOxGradLim);

  /* CombinatorialLogic: '<S200>/Logic' incorporates:
   *  Logic: '<S141>/Logical Operator12'
   *  Memory: '<S200>/Memory'
   */
  rtb_DataTypeConversion = ((((uint32_T)rtb_RelationalOperator2 << 1) +
    (uint32_T)!rtb_Compare_f) << 1) + (uint32_T)UDC_DWork.Memory_PreviousInput_k;
  rtb_Logic_k[0U] = UDC_ConstP.pooled28[rtb_DataTypeConversion];
  rtb_Logic_k[1U] = UDC_ConstP.pooled28[rtb_DataTypeConversion + 8U];

  /* Product: '<S141>/Product1' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   */
  rtb_etaVolConst = rtb_Switch_ah * UDC_B.BusInput2.Slip.rNOxFactorSet_CL;

  /* MATLAB Function: '<S141>/switchHold fct1' incorporates:
   *  Logic: '<S141>/Logical Operator11'
   *  Logic: '<S141>/Logical Operator3'
   *  Logic: '<S141>/Logical Operator5'
   *  Logic: '<S141>/Logical Operator6'
   *  Logic: '<S141>/Logical Operator7'
   *  RelationalOperator: '<S141>/Relational Operator1'
   */
  /* MATLAB Function 'SlipDetection/E9_5_SlipCtrlCorr/switchHold fct1': '<S204>:1' */
  if (rtb_LogicalOperator1_b) {
    /* '<S204>:1:9' */
    /* '<S204>:1:10' */
    UDC_DWork.x = TRUE;
  } else {
    if ((UDC_B.TON_p.LogicalOperator3 && rtb_Logic_k[0]) ||
        ((UDC_B.BusInput.tNOx_SCR_CatOut.Ai <= rtb_etaVolConst) &&
         (!UDC_B.BusInput.tEMLineCatOut.bRdy) &&
         (!UDC_B.BusInput.tEMLineOxiIn.bRdy) &&
         UDC_B.BusInput.tNOx_SCR_CatOut.GoodQual)) {
      /* '<S204>:1:11' */
      /* '<S204>:1:12' */
      UDC_DWork.x = FALSE;
    }
  }

  /* Logic: '<S141>/Logical Operator10' incorporates:
   *  Logic: '<S141>/Logical Operator2'
   *  MATLAB Function: '<S141>/switchHold fct1'
   */
  /* '<S204>:1:14' */
  rtb_RelationalOperator_mq = (rtb_bSCR_NH3SlipInterrupt_k || (rtb_Compare_f &&
    UDC_DWork.x));

  /* BusCreator: '<S10>/Bus Creator' */
  rtb_LogicalOperator1_o = rtb_Compare_l;
  rtb_BusCreator_h3_rUrCorFactSli = rtb_DifferenceInputs2_i;
  rtb_BusCreator_h3_bSCR_EMValve1 = rtb_LogicalOperator8;

  /* End of Outputs for SubSystem: '<Root>/SlipDetection' */

  /* Switch: '<S18>/Switch1' incorporates:
   *  Constant: '<S18>/Constant1'
   */
  if (UDC_B.BusInput.bESCEnable) {
    rtb_Switch1_n = UDC_B.BusInput.rNFlow_ESC_UreaOffs;
  } else {
    rtb_Switch1_n = 0.0F;
  }

  /* End of Switch: '<S18>/Switch1' */

  /* Switch: '<S18>/Switch' incorporates:
   *  Constant: '<S18>/Constant2'
   */
  if (UDC_B.BusInput.bESCEnable) {
    rtb_Switch_f = UDC_B.BusInput.rCF_ESC_UreaNFlow;
  } else {
    rtb_Switch_f = 1.0F;
  }

  /* End of Switch: '<S18>/Switch' */

  /* Outputs for Atomic SubSystem: '<S11>/UrInFFCalcManager' */
  /* MATLAB Function: '<S20>/UrInMethCalculation' */
  /* MATLAB Function 'FeedForward/D1_FF_Manager/UrInFFCalcManager/UrInMethCalculation': '<S21>:1' */
  /*  prioritze different methods as follows: */
  /*  1) Model-based */
  /*  2) NOx sensors + 2D map based */
  /*  3) Engine out NOx sensor + engine exhaust massflow based */
  /*  4) Load table based */
  /*  Transient is always on */
  if (UDC_B.BusInput2.FF.bUrInModEn && UDC_B.BusInput.tNOx_SCR_EngOut.GoodQual &&
      (UDC_B.BusInput1.iIdx_SCR_UreaNFlow_SelectFF == 3)) {
    /* '<S21>:1:11' */
    /*  Model based */
    /* '<S21>:1:12' */
    rtb_iIdxFFOut = 3U;
  } else if (UDC_B.BusInput2.FF.bNH3InFFSSEn &&
             UDC_B.BusInput.tNOx_SCR_EngOut.GoodQual &&
             UDC_B.BusInput.tNOx_SCR_CatOut.GoodQual &&
             (UDC_B.BusInput1.iIdx_SCR_UreaNFlow_SelectFF == 2)) {
    /* '<S21>:1:13' */
    /*  map based */
    /* '<S21>:1:14' */
    rtb_iIdxFFOut = 2U;
  } else if (UDC_B.BusInput.tNOx_SCR_EngOut.GoodQual &&
             (UDC_B.BusInput1.iIdx_SCR_UreaNFlow_SelectFF > 0)) {
    /* '<S21>:1:15' */
    /*  NOx based */
    /* '<S21>:1:16' */
    rtb_iIdxFFOut = 1U;
  } else if (UDC_B.BusInput1.iIdx_SCR_UreaNFlow_SelectFF >= 0) {
    /* '<S21>:1:17' */
    /*  load table based */
    /* '<S21>:1:18' */
    rtb_iIdxFFOut = 0U;
  } else {
    /*  load table based */
    /* '<S21>:1:20' */
    rtb_iIdxFFOut = 0U;
  }

  /* End of MATLAB Function: '<S20>/UrInMethCalculation' */
  /* End of Outputs for SubSystem: '<S11>/UrInFFCalcManager' */

  /* Outputs for Atomic SubSystem: '<S5>/spaceVelocityCalc' */
  /* Switch: '<S82>/Switch' incorporates:
   *  Abs: '<S82>/Abs'
   *  BusSelector: '<S17>/Bus Selector2'
   *  Constant: '<S82>/Constant2'
   *  RelationalOperator: '<S82>/Relational Operator'
   */
  if (1.1920929E-7F >= (real32_T)fabs(UDC_B.BusInput1.rVol_SCR_Cat)) {
    rtb_Product_k = 1.1920929E-7F;
  } else {
    rtb_Product_k = UDC_B.BusInput1.rVol_SCR_Cat;
  }

  /* End of Switch: '<S82>/Switch' */

  /* Product: '<S17>/Divide' */
  rtb_rSV = UDC_B.BusInput.rVol_Ch_Engine_Norm / rtb_Product_k;

  /* Product: '<S17>/Mult' incorporates:
   *  Gain: '<S17>/Nm3//s'
   */
  rtb_rMdot_exh = 0.000277777785F * UDC_B.BusInput.rVol_Ch_Engine_Norm *
    UDC_B.BusInput2.FF.rNRho_SCR_WetExhaust;

  /* End of Outputs for SubSystem: '<S5>/spaceVelocityCalc' */

  /* BusSelector: '<S13>/Bus Selector3' */
  rtb_Divide_h = UDC_B.BusInput2.FF.rMwExh;

  /* Abs: '<S22>/Abs' */
  rtb_rTSCRAvg = (real32_T)fabs(rtb_Divide_h);

  /* Switch: '<S22>/Switch' incorporates:
   *  Constant: '<S22>/Constant2'
   *  RelationalOperator: '<S22>/Relational Operator'
   */
  if (1.1920929E-7F >= rtb_rTSCRAvg) {
    rtb_Divide_h = 1.1920929E-7F;
  }

  /* End of Switch: '<S22>/Switch' */

  /* Product: '<S13>/Product1' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   *  Constant: '<S13>/Const1'
   *  Gain: '<S13>/kg t o g'
   *  Gain: '<S13>/ppm2Moles'
   *  Product: '<S13>/Divide'
   *  Product: '<S13>/Divide2'
   *  Product: '<S13>/Product'
   *  Sum: '<S13>/Add7'
   *  Sum: '<S13>/Subtract'
   */
  rtb_etaVolConst = (1.0F - UDC_B.BusInput.rHum_CatOut) * rtb_rMdot_exh *
    1000.0F / rtb_Divide_h * ((rtb_rNOxEngOutCor_e - rtb_Switch_ah) * 1.0E-6F) *
    UDC_B.BusInput2.FF.rMwUr;

  /* Product: '<S13>/Product2' incorporates:
   *  Constant: '<S13>/mol ratio'
   */
  rtb_Divide_h = 2.0F * UDC_B.BusInput1.rPc_SCR_UreaSolution;

  /* Abs: '<S23>/Abs' */
  rtb_rTSCRAvg = (real32_T)fabs(rtb_Divide_h);

  /* Switch: '<S23>/Switch' incorporates:
   *  Constant: '<S23>/Constant2'
   *  RelationalOperator: '<S23>/Relational Operator'
   */
  if (1.1920929E-7F >= rtb_rTSCRAvg) {
    rtb_Divide_h = 1.1920929E-7F;
  }

  /* End of Switch: '<S23>/Switch' */

  /* Product: '<S13>/Divide1' */
  rtb_etaVolConst /= rtb_Divide_h;

  /* Sum: '<S13>/Add' incorporates:
   *  BusSelector: '<S13>/Bus Selector2'
   *  Constant: '<S13>/Const'
   *  Gain: '<S13>/Gain'
   *  Gain: '<S13>/Gain1'
   *  Gain: '<S13>/Gain2'
   *  Math: '<S13>/Math Function'
   */
  rtb_Divide_h = ((280.0F * UDC_B.BusInput1.rPc_SCR_UreaSolution + 1009.2F) -
                  0.418F * UDC_B.BusInput.rT_Ch_T1LP_Avg) -
    UDC_B.BusInput.rT_Ch_T1LP_Avg * UDC_B.BusInput.rT_Ch_T1LP_Avg * 0.00202F;

  /* Abs: '<S24>/Abs' */
  rtb_rTSCRAvg = (real32_T)fabs(rtb_Divide_h);

  /* Switch: '<S24>/Switch' incorporates:
   *  Constant: '<S24>/Constant2'
   *  RelationalOperator: '<S24>/Relational Operator'
   */
  if (1.1920929E-7F >= rtb_rTSCRAvg) {
    rtb_Switch = 1.1920929E-7F;
  } else {
    rtb_Switch = rtb_Divide_h;
  }

  /* End of Switch: '<S24>/Switch' */

  /* Product: '<S13>/Divide4' incorporates:
   *  Constant: '<S13>/h to s'
   *  Product: '<S13>/Divide3'
   */
  rtb_rFlowUreaFF_NOx_i = rtb_etaVolConst * 3600.0F / rtb_Switch *
    UDC_B.BusInput2.FF.rUreaCalibFact * rtb_DifferenceInputs2;

  /* BusSelector: '<S14>/Bus Selector2' */
  rtb_bNH3StDRes = UDC_B.BusInput2.FF.bNH3StDRes;
  rtb_bNH3StDRes2 = UDC_B.BusInput2.FF.bNH3StDRes2;

  /* BusSelector: '<S30>/Bus Selector4' */
  rtb_rT_SCR_CatHeatTrans_Coef = UDC_B.BusInput2.FF.rT_SCR_CatHeatTrans_Coef;
  rtb_rC_SCR_ExhaustGas = UDC_B.BusInput2.FF.rC_SCR_ExhaustGas;
  rtb_rC_SCR_Cat = UDC_B.BusInput2.FF.rC_SCR_Cat;
  rtb_rTSCRInit = UDC_B.BusInput2.FF.rTSCRInit;
  rtb_bTSCRRes = UDC_B.BusInput2.FF.bTSCRRes;
  for (i = 0; i < 5; i++) {
    rtb_rNH3StorMap_x[i] = UDC_B.BusInput2.FF.rNH3StorMap_x[i];
  }

  for (i = 0; i < 5; i++) {
    rtb_rNH3StorMap_y[i] = UDC_B.BusInput2.FF.rNH3StorMap_y[i];
  }

  /* End of BusSelector: '<S30>/Bus Selector4' */

  /* Product: '<S30>/Divide2' */
  rtb_Divide2_c = UDC_B.BusInput2.FF.rMass_SCR_Cat / 3.0F;

  /* Product: '<S30>/Divide3' */
  rtb_Divide3 = UDC_B.BusInput2.FF.rA_SCR_CatSurfaceOuter / 3.0F;

  /* BusSelector: '<S30>/Bus Selector3' */
  rtb_rT_Ch_T1LP_Avg = UDC_B.BusInput.rT_Ch_T1LP_Avg;

  /* BusSelector: '<S30>/Bus Selector1' */
  rtb_Ai_jl = UDC_B.BusInput.tT_SCR_CatIn.Ai;

  /* Outputs for Atomic SubSystem: '<S30>/Cell1' */
  UDC_Cell1(rtb_rMdot_exh, rtb_rC_SCR_ExhaustGas, rtb_Ai_jl,
            rtb_rT_SCR_CatHeatTrans_Coef, rtb_Divide3, rtb_bTSCRRes,
            rtb_rTSCRInit, rtb_rT_Ch_T1LP_Avg, rtb_Divide2_c, rtb_rC_SCR_Cat,
            rtb_rNH3StorMap_x, rtb_rNH3StorMap_y, &UDC_B.Cell1, &UDC_DWork.Cell1, inst);

  /* End of Outputs for SubSystem: '<S30>/Cell1' */

  /* Outputs for Atomic SubSystem: '<S30>/Cell2' */
  UDC_Cell1(rtb_rMdot_exh, rtb_rC_SCR_ExhaustGas,
            UDC_B.Cell1.DiscreteTimeIntegrator, rtb_rT_SCR_CatHeatTrans_Coef,
            rtb_Divide3, rtb_bTSCRRes, rtb_rTSCRInit, rtb_rT_Ch_T1LP_Avg,
            rtb_Divide2_c, rtb_rC_SCR_Cat, rtb_rNH3StorMap_x, rtb_rNH3StorMap_y,
            &UDC_B.Cell2, &UDC_DWork.Cell2, inst);

  /* End of Outputs for SubSystem: '<S30>/Cell2' */

  /* Outputs for Atomic SubSystem: '<S30>/Cell3' */
  UDC_Cell1(rtb_rMdot_exh, rtb_rC_SCR_ExhaustGas,
            UDC_B.Cell2.DiscreteTimeIntegrator, rtb_rT_SCR_CatHeatTrans_Coef,
            rtb_Divide3, rtb_bTSCRRes, rtb_rTSCRInit, rtb_rT_Ch_T1LP_Avg,
            rtb_Divide2_c, rtb_rC_SCR_Cat, rtb_rNH3StorMap_x, rtb_rNH3StorMap_y,
            &UDC_B.Cell3, &UDC_DWork.Cell3, inst);

  /* End of Outputs for SubSystem: '<S30>/Cell3' */

  /* Product: '<S30>/Divide' incorporates:
   *  Sum: '<S30>/Add1'
   */
  rtb_Divide_h = ((UDC_B.Cell1.DiscreteTimeIntegrator +
                   UDC_B.Cell2.DiscreteTimeIntegrator) +
                  UDC_B.Cell3.DiscreteTimeIntegrator) / 3.0F;

  /* Logic: '<S30>/Logical Operator' incorporates:
   *  Logic: '<S30>/Logical Operator2'
   */
  rtb_RelationalOperator2 = (UDC_B.BusInput2.FF.bTSCRObsEn ||
    (!UDC_B.BusInput.tT_SCR_CatOut.GoodQual));

  /* BusSelector: '<S14>/Bus Selector4' */
  rtb_rTSCRAvg = rtb_BusCreator_h_rTSCRAvg;

  /* Switch: '<S30>/Switch6' */
  if (rtb_RelationalOperator2) {
    rtb_Switch6 = rtb_Divide_h;
  } else {
    rtb_Switch6 = rtb_rTSCRAvg;
  }

  /* End of Switch: '<S30>/Switch6' */

  /* Outputs for Atomic SubSystem: '<S14>/steadyStateUsageMap' */
  /* BusSelector: '<S35>/Bus Selector' */
  for (i = 0; i < 18; i++) {
    rtb_rNOxRedRatioMap_out[i] = UDC_B.BusInput2.FF.rNOxRedRatioMap_out[i];
  }

  /* End of BusSelector: '<S35>/Bus Selector' */

  /* PreLookup: '<S59>/Prelookup' */
  rtb_DataTypeConversion = plook_u32ff_binca(rtb_rSV,
    UDC_B.BusInput2.FF.rNOxRedRatioMap_SV, 2U, &rtb_Prelookup_o2, inst);

  /* PreLookup: '<S59>/Prelookup1' */
  rtb_Prelookup1_o1 = plook_u32ff_binca(rtb_Switch6,
    UDC_B.BusInput2.FF.rNOxRedRatioMap_T, 5U, &rtb_Prelookup1_o2, inst);

  /* Interpolation_n-D: '<S59>/Interpolation Using Prelookup' */
  rtb_etaVolConst = rtb_Prelookup_o2;
  frac[0] = rtb_etaVolConst;
  rtb_etaVolConst = rtb_Prelookup1_o2;
  frac[1] = rtb_etaVolConst;
  bpIndex[0] = rtb_DataTypeConversion;
  bpIndex[1] = rtb_Prelookup1_o1;
  rtb_etaVolConst = intrp2d_if_u32f_la_pw(bpIndex, frac, rtb_rNOxRedRatioMap_out,
    3U, UDC_ConstP.InterpolationUsingPre, inst);

  /* Switch: '<S35>/Switch2' incorporates:
   *  Constant: '<S35>/I5'
   */
  if (UDC_B.BusInput.bRel_SCR_Dosing) {
    /* Sum: '<S35>/Add' incorporates:
     *  BusCreator: '<S9>/Bus Creator'
     */
    rtb_Gain1 = rtb_rNOxEngOutCor_e - rtb_Switch_ah;

    /* Product: '<S35>/Divide3' incorporates:
     *  BusCreator: '<S9>/Bus Creator'
     */
    rtb_etaVolConst *= rtb_rNOxEngOutCor_e;

    /* Switch: '<S60>/Switch2' incorporates:
     *  RelationalOperator: '<S60>/LowerRelop1'
     */
    if (!(rtb_Gain1 > rtb_etaVolConst)) {
      /* Switch: '<S60>/Switch' incorporates:
       *  Constant: '<S35>/deltaNOxMin (ppm)'
       *  RelationalOperator: '<S60>/UpperRelop'
       */
      if (rtb_Gain1 < 0.0F) {
        rtb_etaVolConst = 0.0F;
      } else {
        rtb_etaVolConst = rtb_Gain1;
      }

      /* End of Switch: '<S60>/Switch' */
    }

    /* End of Switch: '<S60>/Switch2' */

    /* Product: '<S35>/Divide2' */
    rtb_Divide2_h = UDC_B.BusInput2.FF.rNH3SSCor * rtb_etaVolConst;
  } else {
    rtb_Divide2_h = 0.0F;
  }

  /* End of Switch: '<S35>/Switch2' */
  /* End of Outputs for SubSystem: '<S14>/steadyStateUsageMap' */

  /* Switch: '<S14>/Switch1' incorporates:
   *  Constant: '<S14>/const1'
   */
  if (UDC_B.BusInput2.FF.bNH3InFFSSEn) {
    rtb_Switch_ah = rtb_Divide2_h;
  } else {
    rtb_Switch_ah = 0.0F;
  }

  /* End of Switch: '<S14>/Switch1' */

  /* DiscreteIntegrator: '<S28>/Discrete-Time Integrator' */
  if (rtb_bNH3StDRes || (UDC_DWork.DiscreteTimeIntegrator_PrevRese != 0)) {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  rtb_DiscreteTimeIntegrator_b = UDC_DWork.DiscreteTimeIntegrator_DSTATE;

  /* End of DiscreteIntegrator: '<S28>/Discrete-Time Integrator' */

  /* Product: '<S30>/Divide1' incorporates:
   *  Sum: '<S30>/Add'
   */
  rtb_Divide1_o = ((UDC_B.Cell1.LookupTableDynamic +
                    UDC_B.Cell2.LookupTableDynamic) +
                   UDC_B.Cell3.LookupTableDynamic) / 3.0F;

  /* Logic: '<S30>/Logical Operator1' incorporates:
   *  Logic: '<S30>/Logical Operator3'
   */
  rtb_RelationalOperator2 = (UDC_B.BusInput2.FF.bTSCRObsEn ||
    (!UDC_B.BusInput.tT_SCR_CatOut.GoodQual));

  /* Dynamic Look-Up Table Block: '<S30>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic), rtb_rNH3StorMap_y,
    rtb_rTSCRAvg, rtb_rNH3StorMap_x, 4U, inst);

  /* Switch: '<S30>/Switch1' */
  if (rtb_RelationalOperator2) {
    rtb_Switch_ky = rtb_Divide1_o;
  } else {
    rtb_Switch_ky = rtb_LookupTableDynamic;
  }

  /* End of Switch: '<S30>/Switch1' */

  /* Product: '<S28>/Divide2' incorporates:
   *  Sum: '<S28>/Add3'
   */
  rtb_DiscreteTimeIntegrator_a = (rtb_Switch_ky - rtb_DiscreteTimeIntegrator_b) *
    UDC_B.BusInput2.FF.rNH3InTrGainB;

  /* Switch: '<S28>/Switch1' incorporates:
   *  Constant: '<S28>/I2'
   *  Constant: '<S28>/I3'
   *  Switch: '<S28>/Switch'
   */
  if (rtb_DiscreteTimeIntegrator_a > 0.0F) {
    rtb_UkYk1 = 1.0F;
  } else if (UDC_B.BusInput.bOpModeStop) {
    /* Switch: '<S28>/Switch' incorporates:
     *  Constant: '<S28>/I1'
     */
    rtb_UkYk1 = 0.0F;
  } else {
    rtb_UkYk1 = 1.0F;
  }

  /* End of Switch: '<S28>/Switch1' */

  /* Switch: '<S28>/Switch3' incorporates:
   *  Constant: '<S28>/I6'
   */
  if (rtb_DiscreteTimeIntegrator_a > 0.0F) {
    /* Switch: '<S28>/Switch2' incorporates:
     *  Constant: '<S28>/I4'
     *  Constant: '<S28>/I5'
     */
    if (UDC_B.BusInput.bRel_SCR_Dosing) {
      rtb_Product_k = 1.0F;
    } else {
      rtb_Product_k = 0.0F;
    }

    /* End of Switch: '<S28>/Switch2' */
  } else {
    rtb_Product_k = 1.0F;
  }

  /* End of Switch: '<S28>/Switch3' */

  /* Product: '<S28>/Divide5' */
  rtb_Divide5 = rtb_UkYk1 * rtb_Product_k * rtb_DiscreteTimeIntegrator_a;

  /* RelationalOperator: '<S31>/LowerRelop1' */
  rtb_RelationalOperator2 = (rtb_Divide5 > UDC_B.BusInput2.FF.rdNH3TrMaxLim);

  /* Switch: '<S31>/Switch2' */
  if (rtb_RelationalOperator2) {
    rtb_Switch_jg = UDC_B.BusInput2.FF.rdNH3TrMaxLim;
  } else {
    /* RelationalOperator: '<S31>/UpperRelop' */
    rtb_RelationalOperator2 = (rtb_Divide5 < UDC_B.BusInput2.FF.rdNH3TrMinLim);

    /* Switch: '<S31>/Switch' */
    if (rtb_RelationalOperator2) {
      rtb_Switch_jg = UDC_B.BusInput2.FF.rdNH3TrMinLim;
    } else {
      rtb_Switch_jg = rtb_Divide5;
    }

    /* End of Switch: '<S31>/Switch' */
  }

  /* End of Switch: '<S31>/Switch2' */

  /* Switch: '<S14>/Switch' incorporates:
   *  Constant: '<S14>/const3'
   */
  if (UDC_B.BusInput2.FF.bdeltNH3InTrEn) {
    rtb_Divide1_m = rtb_Switch_jg;
  } else {
    rtb_Divide1_m = 0.0F;
  }

  /* End of Switch: '<S14>/Switch' */

  /* DiscreteIntegrator: '<S29>/Discrete-Time Integrator' */
  if (rtb_bNH3StDRes2 || (UDC_DWork.DiscreteTimeIntegrator_PrevRe_k != 0)) {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE_i = 0.0F;
  }

  rtb_DiscreteTimeIntegrator_a = UDC_DWork.DiscreteTimeIntegrator_DSTATE_i;

  /* Saturate: '<S29>/Saturation' incorporates:
   *  DiscreteIntegrator: '<S29>/Discrete-Time Integrator'
   */
  if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_i >= 100000.0F) {
    rtb_Saturation_m = 100000.0F;
  } else if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_i <= 0.0F) {
    rtb_Saturation_m = 0.0F;
  } else {
    rtb_Saturation_m = UDC_DWork.DiscreteTimeIntegrator_DSTATE_i;
  }

  /* End of Saturate: '<S29>/Saturation' */

  /* Product: '<S29>/Divide1' incorporates:
   *  Sum: '<S29>/Add3'
   */
  rtb_etaVolConst = (rtb_Switch_ky - rtb_Saturation_m) *
    UDC_B.BusInput2.FF.rNH3InTrGainD;

  /* RelationalOperator: '<S33>/LowerRelop1' */
  rtb_RelationalOperator2 = (rtb_etaVolConst > UDC_B.BusInput2.FF.rdNH3TrMaxLim2);

  /* Switch: '<S33>/Switch2' */
  if (rtb_RelationalOperator2) {
    rtb_Switch_ky = UDC_B.BusInput2.FF.rdNH3TrMaxLim2;
  } else {
    /* RelationalOperator: '<S33>/UpperRelop' */
    rtb_RelationalOperator2 = (rtb_etaVolConst <
      UDC_B.BusInput2.FF.rdNH3TrMinLim2);

    /* Switch: '<S33>/Switch' */
    if (rtb_RelationalOperator2) {
      rtb_Switch_ky = UDC_B.BusInput2.FF.rdNH3TrMinLim2;
    } else {
      rtb_Switch_ky = rtb_etaVolConst;
    }

    /* End of Switch: '<S33>/Switch' */
  }

  /* End of Switch: '<S33>/Switch2' */

  /* Switch: '<S14>/Switch3' incorporates:
   *  Constant: '<S14>/const2'
   */
  if (UDC_B.BusInput2.FF.bdeltNH3InTrEn2) {
    rtb_Switch2_mg = rtb_Switch_ky;
  } else {
    rtb_Switch2_mg = 0.0F;
  }

  /* End of Switch: '<S14>/Switch3' */

  /* Sum: '<S14>/Add4' */
  rtb_etaVolConst = (rtb_Switch_ah + rtb_Divide1_m) + rtb_Switch2_mg;

  /* RelationalOperator: '<S32>/LowerRelop1' */
  rtb_RelationalOperator2 = (rtb_etaVolConst > UDC_B.BusInput2.FF.rNH3FFMaxLim);

  /* Switch: '<S32>/Switch2' */
  if (rtb_RelationalOperator2) {
    rtb_Switch_kk = UDC_B.BusInput2.FF.rNH3FFMaxLim;
  } else {
    /* RelationalOperator: '<S32>/UpperRelop' */
    rtb_RelationalOperator2 = (rtb_etaVolConst < UDC_B.BusInput2.FF.rNH3FFMinLim);

    /* Switch: '<S32>/Switch' */
    if (rtb_RelationalOperator2) {
      rtb_Switch_kk = UDC_B.BusInput2.FF.rNH3FFMinLim;
    } else {
      rtb_Switch_kk = rtb_etaVolConst;
    }

    /* End of Switch: '<S32>/Switch' */
  }

  /* End of Switch: '<S32>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S14>/UreaMassFlowCalcFF' */
  /* Sum: '<S34>/Add' incorporates:
   *  BusSelector: '<S34>/Bus Selector1'
   *  Constant: '<S34>/Const'
   *  Gain: '<S34>/Gain'
   *  Gain: '<S34>/Gain1'
   *  Gain: '<S34>/Gain2'
   *  Math: '<S34>/Math Function'
   */
  rtb_UkYk1 = ((280.0F * UDC_B.BusInput1.rPc_SCR_UreaSolution + 1009.2F) -
               0.418F * UDC_B.BusInput.rT_Ch_T1LP_Avg) -
    UDC_B.BusInput.rT_Ch_T1LP_Avg * UDC_B.BusInput.rT_Ch_T1LP_Avg * 0.00202F;

  /* BusSelector: '<S34>/Bus Selector3' */
  rtb_etaVolConst = UDC_B.BusInput2.FF.rMwExh;

  /* Switch: '<S53>/Switch' incorporates:
   *  Abs: '<S53>/Abs'
   *  Constant: '<S53>/Constant2'
   *  RelationalOperator: '<S53>/Relational Operator'
   */
  if (1.1920929E-7F >= (real32_T)fabs(rtb_etaVolConst)) {
    rtb_etaVolConst = 1.1920929E-7F;
  }

  /* End of Switch: '<S53>/Switch' */

  /* Product: '<S34>/Product1' incorporates:
   *  Constant: '<S34>/Const1'
   *  Gain: '<S34>/kg t o g'
   *  Gain: '<S34>/ppm2Moles'
   *  Product: '<S34>/Divide'
   *  Product: '<S34>/Divide2'
   *  Product: '<S34>/Product'
   *  Sum: '<S34>/Subtract'
   */
  rtb_etaVolConst = (1.0F - UDC_B.BusInput.rHum_CatOut) * rtb_rMdot_exh *
    1000.0F / rtb_etaVolConst * (1.0E-6F * rtb_Switch_kk) *
    UDC_B.BusInput2.FF.rMwUr;

  /* Product: '<S34>/Product2' incorporates:
   *  Constant: '<S34>/mol ratio'
   */
  rtb_Gain1 = 2.0F * UDC_B.BusInput1.rPc_SCR_UreaSolution;

  /* Switch: '<S54>/Switch' incorporates:
   *  Abs: '<S54>/Abs'
   *  Constant: '<S54>/Constant2'
   *  RelationalOperator: '<S54>/Relational Operator'
   */
  if (1.1920929E-7F >= (real32_T)fabs(rtb_Gain1)) {
    rtb_Gain1 = 1.1920929E-7F;
  }

  /* End of Switch: '<S54>/Switch' */

  /* Switch: '<S55>/Switch' incorporates:
   *  Abs: '<S55>/Abs'
   *  Constant: '<S55>/Constant2'
   *  RelationalOperator: '<S55>/Relational Operator'
   */
  if (1.1920929E-7F >= (real32_T)fabs(rtb_UkYk1)) {
    rtb_UkYk1 = 1.1920929E-7F;
  }

  /* End of Switch: '<S55>/Switch' */

  /* Product: '<S14>/Divide4' incorporates:
   *  Constant: '<S34>/h to s'
   *  Product: '<S34>/Divide1'
   *  Product: '<S34>/Divide3'
   */
  rtb_rFlowUreaFF_Map = rtb_etaVolConst / rtb_Gain1 * 3600.0F / rtb_UkYk1 *
    UDC_B.BusInput2.FF.rUreaCalibFact * rtb_DifferenceInputs2;

  /* End of Outputs for SubSystem: '<S14>/UreaMassFlowCalcFF' */

  /* BusSelector: '<S16>/Bus Selector3' */
  rtb_Switch2_mg = UDC_B.BusInput2.FF.rNH3SensTrDel;

  /* Product: '<S16>/Divide1' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   */
  rtb_Divide1_m = rtb_rNOxEngOutCor_e * UDC_B.BusInput2.FF.rNH3SensGain;

  /* Switch: '<S16>/Switch1' incorporates:
   *  RelationalOperator: '<S16>/Relational Operator1'
   */
  if (UDC_B.BusInput.rNH3_SCR_OxiIn > UDC_B.BusInput1.rDNOx_SCR_NH3Slip_Hi) {
    rtb_LookupTableDynamic1 = UDC_B.BusInput2.FF.rNH3SensStepDwn;
  } else {
    rtb_LookupTableDynamic1 = UDC_B.BusInput2.FF.rNH3SensStepUp;
  }

  /* End of Switch: '<S16>/Switch1' */

  /* Switch: '<S16>/Switch' incorporates:
   *  Constant: '<S16>/Constant3'
   *  Constant: '<S16>/Constant4'
   *  RelationalOperator: '<S16>/Relational Operator'
   */
  if (UDC_B.BusInput.tT_SCR_CatOut.Ai >
      UDC_B.BusInput1.rT_SCR_UreaDosingUnit_Release) {
    i = 1;
  } else {
    i = 0;
  }

  /* End of Switch: '<S16>/Switch' */

  /* Product: '<S16>/Divide' */
  rtb_etaVolConst = (real32_T)i * rtb_LookupTableDynamic1;

  /* SampleTimeMath: '<S16>/Weighted Sample Time'
   *
   * About '<S16>/Weighted Sample Time':
   *  y = u * K where K = 1 / ( w * Ts )
   */
  rtb_LookupTableDynamic1 = rtb_Switch2_mg * 10.0F;

  /* DataTypeConversion: '<S16>/Data Type Conversion' */
  rtb_Product_k = (real32_T)floor(rtb_LookupTableDynamic1);
  if (rtIsNaNF(rtb_Product_k) || rtIsInfF(rtb_Product_k)) {
    rtb_Product_k = 0.0F;
  } else {
    rtb_Product_k = (real32_T)fmod(rtb_Product_k, 4.2949673E+9F);
  }

  rtb_DataTypeConversion = rtb_Product_k < 0.0F ? (uint32_T)-(int32_T)(uint32_T)
    -rtb_Product_k : (uint32_T)rtb_Product_k;

  /* End of DataTypeConversion: '<S16>/Data Type Conversion' */

  /* Delay: '<S16>/Variable Integer Delay' */
  if (rtb_DataTypeConversion < 1U) {
    i = 1;
  } else if (rtb_DataTypeConversion > 1000U) {
    i = 1000;
  } else {
    i = (int32_T)rtb_DataTypeConversion;
  }

  /* Sum: '<S16>/Add' incorporates:
   *  Delay: '<S16>/Variable Integer Delay'
   */
  rtb_etaVolConst += UDC_DWork.VariableIntegerDelay_DSTATE[1000U - (uint32_T)i];

  /* Switch: '<S81>/Switch2' incorporates:
   *  RelationalOperator: '<S81>/LowerRelop1'
   */
  if (!(rtb_etaVolConst > rtb_Divide1_m)) {
    /* Switch: '<S81>/Switch' incorporates:
     *  Constant: '<S16>/Constant'
     *  RelationalOperator: '<S81>/UpperRelop'
     */
    if (rtb_etaVolConst < 0.0F) {
      rtb_Divide1_m = 0.0F;
    } else {
      rtb_Divide1_m = rtb_etaVolConst;
    }

    /* End of Switch: '<S81>/Switch' */
  }

  /* End of Switch: '<S81>/Switch2' */

  /* Switch: '<S16>/Switch2' incorporates:
   *  Constant: '<S16>/const2'
   */
  if (UDC_B.BusInput2.FF.bSCR_NH3Control_Active) {
    rtb_LookupTableDynamic1 = rtb_Divide1_m;
  } else {
    rtb_LookupTableDynamic1 = 0.0F;
  }

  /* End of Switch: '<S16>/Switch2' */

  /* Product: '<S16>/Divide4' */
  rtb_rFlowUreaFF_NH3 = rtb_LookupTableDynamic1 * rtb_DifferenceInputs2;

  /* MultiPortSwitch: '<S11>/Multiport Switch' incorporates:
   *  Constant: '<S5>/const2'
   */
  switch (rtb_iIdxFFOut) {
   case 0:
    rtb_etaVolConst = rtb_rFlowUreaFF_LT;
    break;

   case 1:
    rtb_etaVolConst = rtb_rFlowUreaFF_NOx_i;
    break;

   case 2:
    rtb_etaVolConst = rtb_rFlowUreaFF_Map;
    break;

   case 3:
    rtb_etaVolConst = 0.0F;
    break;

   case 4:
    rtb_etaVolConst = rtb_rFlowUreaFF_NH3;
    break;

   default:
    rtb_etaVolConst = rtb_rFlowUreaFF_LT;
    break;
  }

  /* End of MultiPortSwitch: '<S11>/Multiport Switch' */

  /* RelationalOperator: '<S19>/LowerRelop1' */
  rtb_RelationalOperator2 = (rtb_etaVolConst > UDC_B.BusInput2.FF.rUrFFMaxLim);

  /* Switch: '<S19>/Switch2' */
  if (rtb_RelationalOperator2) {
    rtb_LookupTableDynamic1 = UDC_B.BusInput2.FF.rUrFFMaxLim;
  } else {
    /* RelationalOperator: '<S19>/UpperRelop' */
    rtb_RelationalOperator2 = (rtb_etaVolConst < UDC_B.BusInput2.FF.rUrFFMinLim);

    /* Switch: '<S19>/Switch' */
    if (rtb_RelationalOperator2) {
      rtb_LookupTableDynamic1 = UDC_B.BusInput2.FF.rUrFFMinLim;
    } else {
      rtb_LookupTableDynamic1 = rtb_etaVolConst;
    }

    /* End of Switch: '<S19>/Switch' */
  }

  /* End of Switch: '<S19>/Switch2' */

  /* Sum: '<S18>/Add8' incorporates:
   *  Product: '<S18>/Divide4'
   */
  rtb_rFlow_SCR_UreaDosingUnit_ff = rtb_Switch_f * rtb_LookupTableDynamic1 +
    rtb_Switch1_n;

  /* Product: '<S8>/Divide3' */
  rtb_rFlow_SCR_UreaDosing_ffNH3C = rtb_BusCreator_h3_rUrCorFactSli *
    rtb_rFlow_SCR_UreaDosingUnit_ff;

  /* BusSelector: '<S111>/Bus Selector12' */
  rtb_rSCR_NOxControlWaiting = UDC_B.BusInput1.rSCR_NOxControlWaiting;

  /* UnitDelay: '<S111>/Unit Delay' */
  rtb_UnitDelay = UDC_DWork.UnitDelay_DSTATE;

  /* BusSelector: '<S113>/Bus Selector1' */
  for (i = 0; i < 5; i++) {
    rtb_rUrClKiOffs_y[i] = UDC_B.BusInput2.CLNOx.rUrClKpOffs_x[i];
  }

  for (i = 0; i < 5; i++) {
    rtb_rUrClKiOffs_x[i] = UDC_B.BusInput2.CLNOx.rUrClKpOffs_y[i];
  }

  /* End of BusSelector: '<S113>/Bus Selector1' */
  /* Dynamic Look-Up Table Block: '<S113>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic1), rtb_rUrClKiOffs_x,
    rtb_Switch6, rtb_rUrClKiOffs_y, 4U, inst);

  /* Sum: '<S113>/Add2' */
  rtb_etaVolConst = rtb_LookupTableDynamic1 + UDC_B.BusInput1.rSCR_NOxCtrl_Kp;

  /* BusSelector: '<S111>/Bus Selector14' */
  rtb_bRel_SCR_Dosing_n = UDC_B.BusInput.bRel_SCR_Dosing;

  /* Logic: '<S111>/Logical Operator5' */
  rtb_RelationalOperator2 = (UDC_B.BusInput.bSCR_UreaDosingUnit_Man &&
    UDC_B.BusInput1.bSCR_UreaFlowCtrl_Active);

  /* Outputs for Atomic SubSystem: '<S111>/TON' */
  UDC_TON(rtb_bRel_SCR_Dosing_n, rtb_rSCR_NOxControlWaiting, &UDC_B.TON_f,
          &UDC_DWork.TON_f, inst);

  /* End of Outputs for SubSystem: '<S111>/TON' */

  /* Outputs for Atomic SubSystem: '<Root>/SlipDetection' */
  /* Logic: '<S111>/Logical Operator' incorporates:
   *  BusCreator: '<S10>/Bus Creator'
   *  Logic: '<S111>/Logical Operator3'
   */
  rtb_LogicalOperator_p = (UDC_B.BusInput2.CLNOx.bUrClRes ||
    rtb_RelationalOperator2 || (!UDC_B.TON_f.LogicalOperator3) ||
    UDC_B.BusInput.bSCR_Man || UDC_B.BusInput.bSCR_NOxControl_Man ||
    rtb_RelationalOperator_mq || UDC_B.BusInput.bSCR_NH3SlipDetect_Blocked);

  /* End of Outputs for SubSystem: '<Root>/SlipDetection' */

  /* Logic: '<S111>/Logical Operator8' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   */
  rtb_RelationalOperator2 = (rtb_bFreezeCtr_j || rtb_LogicalOperator_p);

  /* Switch: '<S111>/Switch1' incorporates:
   *  Constant: '<S111>/Constant'
   *  Gain: '<S111>/Gain'
   *  MATLAB Function: '<S119>/MATLAB Function'
   *  Sum: '<S111>/Add7'
   */
  if (rtb_RelationalOperator2) {
    rtb_LookupTableDynamic1 = 0.0F;
  } else {
    /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
    rtb_LookupTableDynamic1 = -(rtb_BusCreator_h_rNOx_SCR_CatOu - rNOx_Act);

    /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */
  }

  /* End of Switch: '<S111>/Switch1' */

  /* Gain: '<S112>/Gain' */
  rtb_LookupTableDynamic1 *= 0.001F;

  /* Product: '<S112>/Product' */
  rtb_Product_f = rtb_etaVolConst * rtb_LookupTableDynamic1;

  /* DiscreteIntegrator: '<S112>/Discrete-Time Integrator' */
  if (UDC_DWork.DiscreteTimeIntegrator_IC_LOADI != 0) {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = UDC_B.BusInput2.CLNOx.rUrClI0;
    if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_p >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_p <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = -3.402823466E+38F;
      }
    }
  }

  if (rtb_LogicalOperator_p || (UDC_DWork.DiscreteTimeIntegrator_PrevRe_j != 0))
  {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = UDC_B.BusInput2.CLNOx.rUrClI0;
    if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_p >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_p <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = -3.402823466E+38F;
      }
    }
  }

  if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_p >= 3.402823466E+38F) {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = 3.402823466E+38F;
  } else {
    if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_p <= -3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = -3.402823466E+38F;
    }
  }

  rtb_DiscreteTimeIntegrator = UDC_DWork.DiscreteTimeIntegrator_DSTATE_p;

  /* End of DiscreteIntegrator: '<S112>/Discrete-Time Integrator' */

  /* BusSelector: '<S113>/Bus Selector4' */
  for (i = 0; i < 5; i++) {
    rtb_rUrClKiOffs_x[i] = UDC_B.BusInput2.CLNOx.rUrClKdOffs_x[i];
  }

  for (i = 0; i < 5; i++) {
    rtb_rUrClKiOffs_y[i] = UDC_B.BusInput2.CLNOx.rUrClKdOffs_y[i];
  }

  /* End of BusSelector: '<S113>/Bus Selector4' */
  /* Dynamic Look-Up Table Block: '<S113>/Lookup Table Dynamic2'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Switch2_mg), rtb_rUrClKiOffs_y, rtb_Switch6,
    rtb_rUrClKiOffs_x, 4U, inst);

  /* Product: '<S112>/Product2' incorporates:
   *  Sum: '<S113>/Add3'
   */
  rtb_etaVolConst = (rtb_Switch2_mg + UDC_B.BusInput1.rSCR_NOxCtrl_Kd) *
    rtb_LookupTableDynamic1;

  /* DiscreteIntegrator: '<S112>/Discrete-Time Integrator1' */
  if (UDC_DWork.DiscreteTimeIntegrator1_IC_LOAD != 0) {
    UDC_DWork.DiscreteTimeIntegrator1_DSTATE = UDC_B.BusInput2.CLNOx.rUrClD0;
    if (UDC_DWork.DiscreteTimeIntegrator1_DSTATE >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTATE = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTATE <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTATE = -3.402823466E+38F;
      }
    }
  }

  if (rtb_LogicalOperator_p || (UDC_DWork.DiscreteTimeIntegrator1_PrevRes != 0))
  {
    UDC_DWork.DiscreteTimeIntegrator1_DSTATE = UDC_B.BusInput2.CLNOx.rUrClD0;
    if (UDC_DWork.DiscreteTimeIntegrator1_DSTATE >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTATE = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTATE <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTATE = -3.402823466E+38F;
      }
    }
  }

  if (UDC_DWork.DiscreteTimeIntegrator1_DSTATE >= 3.402823466E+38F) {
    UDC_DWork.DiscreteTimeIntegrator1_DSTATE = 3.402823466E+38F;
  } else {
    if (UDC_DWork.DiscreteTimeIntegrator1_DSTATE <= -3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTATE = -3.402823466E+38F;
    }
  }

  rtb_Switch2_mg = UDC_DWork.DiscreteTimeIntegrator1_DSTATE;

  /* End of DiscreteIntegrator: '<S112>/Discrete-Time Integrator1' */

  /* Product: '<S112>/Product3' incorporates:
   *  Sum: '<S112>/Sum2'
   */
  rtb_Product3 = (rtb_etaVolConst - rtb_Switch2_mg) *
    UDC_B.BusInput2.CLNOx.rUrClN;

  /* Switch: '<S111>/Switch' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   *  Sum: '<S112>/Sum1'
   */
  if (!rtb_bFreezeCtr_j) {
    rtb_UnitDelay = (rtb_Product_f + rtb_DiscreteTimeIntegrator) + rtb_Product3;
  }

  /* End of Switch: '<S111>/Switch' */

  /* Switch: '<S114>/Switch2' incorporates:
   *  RelationalOperator: '<S114>/LowerRelop1'
   *  RelationalOperator: '<S114>/UpperRelop'
   *  Switch: '<S114>/Switch'
   */
  if (rtb_UnitDelay > UDC_B.BusInput1.rSCR_NOxCtrl_Ymax) {
    rtb_Switch2_m = UDC_B.BusInput1.rSCR_NOxCtrl_Ymax;
  } else if (rtb_UnitDelay < UDC_B.BusInput1.rSCR_NOxCtrl_Ymin) {
    /* Switch: '<S114>/Switch' */
    rtb_Switch2_m = UDC_B.BusInput1.rSCR_NOxCtrl_Ymin;
  } else {
    rtb_Switch2_m = rtb_UnitDelay;
  }

  /* End of Switch: '<S114>/Switch2' */

  /* Switch: '<S8>/Switch1' incorporates:
   *  Constant: '<S8>/const1'
   *  Switch: '<S8>/Switch7'
   */
  if (UDC_B.BusInput.bSCR_NOxControl_Man) {
    rtb_Switch_ah = UDC_B.BusInput.rFlow_SCR_UreaDosingUnit_spMan;
  } else if (UDC_B.BusInput.bRel_SCR_Dosing) {
    /* Switch: '<S8>/Switch7' incorporates:
     *  Sum: '<S8>/Add6'
     */
    rtb_Switch_ah = rtb_rFlow_SCR_UreaDosing_ffNH3C + rtb_Switch2_m;
  } else {
    rtb_Switch_ah = 0.0F;
  }

  /* End of Switch: '<S8>/Switch1' */

  /* Switch: '<S110>/Switch2' incorporates:
   *  Constant: '<S8>/const2'
   *  RelationalOperator: '<S110>/LowerRelop1'
   *  RelationalOperator: '<S110>/UpperRelop'
   *  Switch: '<S110>/Switch'
   */
  if (rtb_Switch_ah > UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi) {
    rtb_Switch2_h = UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi;
  } else if (rtb_Switch_ah < 0.0F) {
    /* Switch: '<S110>/Switch' incorporates:
     *  Constant: '<S8>/const2'
     */
    rtb_Switch2_h = 0.0F;
  } else {
    rtb_Switch2_h = rtb_Switch_ah;
  }

  /* End of Switch: '<S110>/Switch2' */

  /* If: '<S6>/If' incorporates:
   *  Constant: '<S84>/Constant'
   *  Constant: '<S84>/Constant1'
   *  Constant: '<S84>/Constant2'
   *  Constant: '<S84>/Constant7'
   *  Constant: '<S84>/Constant8'
   */
  if (UDC_B.BusInput1.bSCR_UreaDosingValve_Exist &&
      UDC_B.BusInput1.bSCR_UreaFlowCtrl_Active) {
    /* Outputs for IfAction SubSystem: '<S6>/UrValCntr' incorporates:
     *  ActionPort: '<S86>/Action Port'
     */
    /* Sum: '<S86>/Add2' */
    rtb_etaVolConst = UDC_B.BusInput2.CLVal.rUrValKpOffs +
      UDC_B.BusInput1.rSCR_UreaFlowCtrl_Kp;

    /* Switch: '<S86>/Switch1' incorporates:
     *  Constant: '<S86>/Constant'
     *  Sum: '<S86>/Add7'
     */
    if (UDC_B.BusInput.tFlow_SCR_UreaDosingOut.GoodQual) {
      rtb_Product_k = rtb_Switch2_h - UDC_B.BusInput.tFlow_SCR_UreaDosingOut.Ai;
    } else {
      rtb_Product_k = 0.0F;
    }

    /* End of Switch: '<S86>/Switch1' */

    /* Gain: '<S94>/Gain' */
    rtb_sampletime_c = 0.01F * rtb_Product_k;

    /* Product: '<S94>/Product' */
    rtb_Product_k = rtb_etaVolConst * rtb_sampletime_c;

    /* Logic: '<S86>/Logical Operator' incorporates:
     *  Logic: '<S86>/Logical Operator1'
     *  Logic: '<S86>/Logical Operator2'
     *  Logic: '<S86>/Logical Operator3'
     */
    rtb_LogicalOperator_g = (UDC_B.BusInput2.CLVal.bUrValRes ||
      (!UDC_B.BusInput1.bSCR_UreaDosingValve_Exist) ||
      (!UDC_B.BusInput.bRel_SCR_Dosing) ||
      (!UDC_B.BusInput1.bSCR_UreaFlowCtrl_Active) || UDC_B.BusInput.bSCR_Man ||
      UDC_B.BusInput.bSCR_UreaDosingUnit_Man);

    /* DiscreteIntegrator: '<S94>/Discrete-Time Integrator' */
    if (UDC_DWork.DiscreteTimeIntegrator_IC_LOA_f != 0) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = UDC_B.BusInput2.CLVal.rUrValI0;
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_e >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_e <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = -3.402823466E+38F;
        }
      }
    }

    if (rtb_LogicalOperator_g || (UDC_DWork.DiscreteTimeIntegrator_PrevRe_p != 0))
    {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = UDC_B.BusInput2.CLVal.rUrValI0;
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_e >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_e <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = -3.402823466E+38F;
        }
      }
    }

    if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_e >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_e <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = -3.402823466E+38F;
      }
    }

    rtb_DiscreteTimeIntegrator_p = UDC_DWork.DiscreteTimeIntegrator_DSTATE_e;

    /* Sum: '<S86>/Add6' */
    rtb_etaVolConst = UDC_B.BusInput2.CLVal.rUrValKdOffs +
      UDC_B.BusInput1.rSCR_UreaFlowCtrl_Kd;

    /* DiscreteIntegrator: '<S94>/Discrete-Time Integrator1' */
    if (UDC_DWork.DiscreteTimeIntegrator1_IC_LO_i != 0) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = UDC_B.BusInput2.CLVal.rUrValD0;
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = -3.402823466E+38F;
        }
      }
    }

    if (rtb_LogicalOperator_g || (UDC_DWork.DiscreteTimeIntegrator1_PrevR_e != 0))
    {
      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = UDC_B.BusInput2.CLVal.rUrValD0;
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = -3.402823466E+38F;
        }
      }
    }

    if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = -3.402823466E+38F;
      }
    }

    /* Product: '<S94>/Product3' incorporates:
     *  DiscreteIntegrator: '<S94>/Discrete-Time Integrator1'
     *  Product: '<S94>/Product2'
     *  Sum: '<S94>/Sum2'
     */
    rtb_Product3_i = (rtb_etaVolConst * rtb_sampletime_c -
                      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b) *
      UDC_B.BusInput2.CLVal.rUrValN;

    /* Switch: '<S86>/Switch' incorporates:
     *  DiscreteIntegrator: '<S94>/Discrete-Time Integrator'
     *  Sum: '<S94>/Sum1'
     *  UnitDelay: '<S86>/Unit Delay'
     */
    if (UDC_B.BusInput.tFlow_SCR_UreaDosingOut.GoodQual) {
      rtb_Switch2_kp = (rtb_Product_k +
                        UDC_DWork.DiscreteTimeIntegrator_DSTATE_e) +
        rtb_Product3_i;
    } else {
      rtb_Switch2_kp = UDC_DWork.UnitDelay_DSTATE_n;
    }

    /* End of Switch: '<S86>/Switch' */

    /* Switch: '<S95>/Switch2' incorporates:
     *  RelationalOperator: '<S95>/LowerRelop1'
     *  RelationalOperator: '<S95>/UpperRelop'
     *  Switch: '<S95>/Switch'
     */
    if (rtb_Switch2_kp > UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ymax) {
      rtb_Switch2_p = UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ymax;
    } else if (rtb_Switch2_kp < UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ymin) {
      /* Switch: '<S95>/Switch' */
      rtb_Switch2_p = UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ymin;
    } else {
      rtb_Switch2_p = rtb_Switch2_kp;
    }

    /* End of Switch: '<S95>/Switch2' */

    /* Abs: '<S93>/Abs' incorporates:
     *  BusSelector: '<S86>/Bus Selector1'
     */
    rtb_LookupTableDynamic_e = (real32_T)fabs
      (UDC_B.BusInput1.rFlow_SCR_UreaDosingValveCoeff);

    /* Switch: '<S93>/Switch' incorporates:
     *  BusSelector: '<S86>/Bus Selector1'
     *  Constant: '<S93>/Constant2'
     *  RelationalOperator: '<S93>/Relational Operator'
     */
    if (1.1920929E-7F >= rtb_LookupTableDynamic_e) {
      rtb_Switch_f = 1.1920929E-7F;
    } else {
      rtb_Switch_f = UDC_B.BusInput1.rFlow_SCR_UreaDosingValveCoeff;
    }

    /* End of Switch: '<S93>/Switch' */

    /* UnitDelay: '<S97>/Unit Delay' */
    rtb_LookupTableDynamic_e = UDC_DWork.UnitDelay_DSTATE_d;

    /* Switch: '<S97>/Switch' */
    if (UDC_B.BusInput.tDPr_UreaDosingUnit.GoodQual) {
      rtb_Switch_ld = UDC_B.BusInput.tDPr_UreaDosingUnit.Ai;
    } else {
      rtb_Switch_ld = rtb_LookupTableDynamic_e;
    }

    /* End of Switch: '<S97>/Switch' */

    /* BusSelector: '<S97>/Bus Selector2' */
    for (i = 0; i < 11; i++) {
      rtb_rUrValLinMap_x[i] = UDC_B.BusInput2.CLVal.rUrValLinMap_x[i];
    }

    for (i = 0; i < 11; i++) {
      rtb_rUrValLinMap_y[i] = UDC_B.BusInput2.CLVal.rUrValLinMap_y[i];
    }

    rtb_rTiFilt_DPrVlv = UDC_B.BusInput2.CLVal.rTiFilt_DPrVlv;

    /* End of BusSelector: '<S97>/Bus Selector2' */

    /* Outputs for Atomic SubSystem: '<S97>/Filter_DPr' */
    UDC_Filter(rtb_rTiFilt_DPrVlv, rtb_LogicalOperator_g, rtb_Switch_ld,
               &UDC_B.Filter_DPr, &UDC_DWork.Filter_DPr, inst);

    /* End of Outputs for SubSystem: '<S97>/Filter_DPr' */

    /* Product: '<S97>/Divide2' incorporates:
     *  Gain: '<S97>/Gain'
     */
    rtb_LookupTableDynamic_e = UDC_B.Filter_DPr.Switch / (0.001F * rtb_Switch);

    /* Saturate: '<S97>/Saturation' */
    if (rtb_LookupTableDynamic_e >= 1.0E+6F) {
      rtb_LookupTableDynamic_e = 1.0E+6F;
    } else {
      if (rtb_LookupTableDynamic_e <= 0.001F) {
        rtb_LookupTableDynamic_e = 0.001F;
      }
    }

    /* End of Saturate: '<S97>/Saturation' */

    /* Sqrt: '<S97>/Sqrt' */
    rtb_LookupTableDynamic_e = (real32_T)sqrt(rtb_LookupTableDynamic_e);

    /* Abs: '<S100>/Abs' */
    rtb_Switch_h = (real32_T)fabs(rtb_LookupTableDynamic_e);

    /* Switch: '<S100>/Switch' incorporates:
     *  Constant: '<S100>/Constant2'
     *  RelationalOperator: '<S100>/Relational Operator'
     */
    if (1.1920929E-7F >= rtb_Switch_h) {
      rtb_LookupTableDynamic_e = 1.1920929E-7F;
    }

    /* End of Switch: '<S100>/Switch' */

    /* Product: '<S97>/Divide1' */
    rtb_LookupTableDynamic_e = rtb_Switch2_h / rtb_Switch_f /
      rtb_LookupTableDynamic_e;

    /* Dynamic Look-Up Table Block: '<S97>/Lookup Table Dynamic'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_Switch_h), rtb_rUrValLinMap_y,
      rtb_LookupTableDynamic_e, rtb_rUrValLinMap_x, 10U, inst);

    /* Sum: '<S86>/Add3' */
    rtb_LookupTableDynamic_e = rtb_Switch_h + rtb_Switch2_p;

    /* Product: '<S86>/Divide1' incorporates:
     *  Sum: '<S86>/Add1'
     */
    rtb_etaVolConst = (rtb_Switch2_kp - rtb_Switch2_p) *
      UDC_B.BusInput2.CLVal.rUrValKaw;

    /* Product: '<S86>/Divide6' incorporates:
     *  Sum: '<S86>/Add10'
     */
    rtb_Gain1 = (rtb_LookupTableDynamic_e -
                 UDC_B.BusInput.rPos_SCR_UreaDosingValve) *
      UDC_B.BusInput2.CLVal.rUrValKawExt;

    /* Saturate: '<S86>/Saturation1' */
    if (rtb_LookupTableDynamic_e >= 1.0F) {
      rtb_Saturation1_f = 1.0F;
    } else if (rtb_LookupTableDynamic_e <= 0.0F) {
      rtb_Saturation1_f = 0.0F;
    } else {
      rtb_Saturation1_f = rtb_LookupTableDynamic_e;
    }

    /* End of Saturate: '<S86>/Saturation1' */

    /* Product: '<S86>/Divide2' incorporates:
     *  Sum: '<S86>/Add8'
     */
    rtb_UkYk1 = (rtb_LookupTableDynamic_e - rtb_Saturation1_f) *
      UDC_B.BusInput2.CLVal.rUrValKaw;

    /* Sum: '<S86>/Add4' */
    rtb_etaVolConst = (rtb_etaVolConst + rtb_Gain1) + rtb_UkYk1;

    /* Sum: '<S86>/Add5' */
    rtb_UkYk1 = UDC_B.BusInput2.CLVal.rUrValKiOffs +
      UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ki;

    /* Switch: '<S96>/Switch2' incorporates:
     *  Gain: '<S86>/Gain3'
     *  RelationalOperator: '<S96>/LowerRelop1'
     *  RelationalOperator: '<S96>/UpperRelop'
     *  Switch: '<S96>/Switch'
     */
    if (rtb_etaVolConst > UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi) {
      rtb_LookupTableDynamic_e = UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi;
    } else if (rtb_etaVolConst < -UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi) {
      /* Switch: '<S96>/Switch' incorporates:
       *  Gain: '<S86>/Gain3'
       */
      rtb_LookupTableDynamic_e = -UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi;
    } else {
      /* Switch: '<S96>/Switch' */
      rtb_LookupTableDynamic_e = rtb_etaVolConst;
    }

    /* End of Switch: '<S96>/Switch2' */

    /* Gain: '<S86>/Gain2' */
    rtb_LookupTableDynamic_e = -rtb_LookupTableDynamic_e;

    /* Logic: '<S86>/Logical Operator4' */
    rtb_LogicalOperator1_b = !rtb_LogicalOperator_g;

    /* Sum: '<S94>/Add' */
    rtb_etaVolConst = rtb_sampletime_c + rtb_LookupTableDynamic_e;

    /* BusCreator: '<S94>/Bus Creator' */
    rtb_sampletime_c = rtb_LookupTableDynamic_e;

    /* SignalConversion: '<S86>/Signal Conversion' */
    UDC_B.Merge5[0] = rtb_Switch_h;

    /* SignalConversion: '<S86>/Signal Conversion1' */
    UDC_B.Merge5[1] = rtb_Saturation1_f;

    /* SignalConversion: '<S86>/Signal Conversion2' */
    UDC_B.Merge5[2] = rtb_Switch2_p;

    /* BusSelector: '<S98>/Bus Selector4' */
    for (i = 0; i < 11; i++) {
      rtb_rUrValLinMap_y[i] = UDC_B.BusInput2.CLVal.rUrValLinMap_y[i];
    }

    for (i = 0; i < 11; i++) {
      rtb_rUrValLinMap_x[i] = UDC_B.BusInput2.CLVal.rUrValLinMap_x[i];
    }

    rtb_rTiFilt_DPrVlv_b = UDC_B.BusInput2.CLVal.rTiFilt_DPrVlv;

    /* End of BusSelector: '<S98>/Bus Selector4' */

    /* UnitDelay: '<S98>/Unit Delay2' */
    rtb_Switch_h = UDC_DWork.UnitDelay2_DSTATE;

    /* Switch: '<S98>/Switch3' */
    if (UDC_B.BusInput.tDPr_UreaDosingUnit.GoodQual) {
      rtb_Switch3_l = UDC_B.BusInput.tDPr_UreaDosingUnit.Ai;
    } else {
      rtb_Switch3_l = rtb_Switch_h;
    }

    /* End of Switch: '<S98>/Switch3' */

    /* Outputs for Atomic SubSystem: '<S98>/Filter_DPr' */
    UDC_Filter(rtb_rTiFilt_DPrVlv_b, rtb_LogicalOperator_g, rtb_Switch3_l,
               &UDC_B.Filter_DPr_h, &UDC_DWork.Filter_DPr_h, inst);

    /* End of Outputs for SubSystem: '<S98>/Filter_DPr' */

    /* Product: '<S98>/Divide5' incorporates:
     *  Gain: '<S98>/Gain1'
     */
    rtb_Switch_h = UDC_B.Filter_DPr_h.Switch / (0.001F * rtb_Switch);

    /* Saturate: '<S98>/Saturation2' */
    if (rtb_Switch_h >= 1.0E+6F) {
      rtb_Switch_h = 1.0E+6F;
    } else {
      if (rtb_Switch_h <= 0.001F) {
        rtb_Switch_h = 0.001F;
      }
    }

    /* End of Saturate: '<S98>/Saturation2' */

    /* Sqrt: '<S98>/Sqrt1' */
    rtb_Switch_h = (real32_T)sqrt(rtb_Switch_h);

    /* Abs: '<S105>/Abs' */
    rtb_LookupTableDynamic_e = (real32_T)fabs(rtb_Switch_h);

    /* Switch: '<S105>/Switch' incorporates:
     *  Constant: '<S105>/Constant2'
     *  RelationalOperator: '<S105>/Relational Operator'
     */
    if (1.1920929E-7F >= rtb_LookupTableDynamic_e) {
      rtb_Switch_h = 1.1920929E-7F;
    }

    /* End of Switch: '<S105>/Switch' */
    /* Dynamic Look-Up Table Block: '<S98>/Lookup Table Dynamic'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic_e), rtb_rUrValLinMap_x,
      rtb_Saturation1_f, rtb_rUrValLinMap_y, 10U, inst);

    /* Product: '<S98>/Divide4' */
    UDC_B.Merge5[3] = rtb_Switch_h * rtb_Switch_f * rtb_LookupTableDynamic_e;

    /* Update for DiscreteIntegrator: '<S94>/Discrete-Time Integrator' incorporates:
     *  Product: '<S94>/Product1'
     */
    UDC_DWork.DiscreteTimeIntegrator_IC_LOA_f = 0U;
    if (!rtb_LogicalOperator_g) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_e += rtb_UkYk1 * rtb_etaVolConst *
        0.1F;
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_e >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_e <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator_DSTATE_e = -3.402823466E+38F;
        }
      }
    }

    if (rtb_LogicalOperator_g) {
      UDC_DWork.DiscreteTimeIntegrator_PrevRe_p = 1;
    } else {
      UDC_DWork.DiscreteTimeIntegrator_PrevRe_p = 0;
    }

    /* End of Update for DiscreteIntegrator: '<S94>/Discrete-Time Integrator' */

    /* Update for DiscreteIntegrator: '<S94>/Discrete-Time Integrator1' */
    UDC_DWork.DiscreteTimeIntegrator1_IC_LO_i = 0U;
    if (!rtb_LogicalOperator_g) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b += 0.1F * rtb_Product3_i;
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator1_DSTAT_b = -3.402823466E+38F;
        }
      }
    }

    if (rtb_LogicalOperator_g) {
      UDC_DWork.DiscreteTimeIntegrator1_PrevR_e = 1;
    } else {
      UDC_DWork.DiscreteTimeIntegrator1_PrevR_e = 0;
    }

    /* End of Update for DiscreteIntegrator: '<S94>/Discrete-Time Integrator1' */

    /* Update for UnitDelay: '<S86>/Unit Delay' */
    UDC_DWork.UnitDelay_DSTATE_n = rtb_Switch2_kp;

    /* Update for UnitDelay: '<S97>/Unit Delay' */
    UDC_DWork.UnitDelay_DSTATE_d = rtb_Switch_ld;

    /* Update for UnitDelay: '<S98>/Unit Delay2' */
    UDC_DWork.UnitDelay2_DSTATE = rtb_Switch3_l;

    /* End of Outputs for SubSystem: '<S6>/UrValCntr' */
  } else if (UDC_B.BusInput1.bSCR_UreaFlowCtrl_Active) {
    /* Outputs for IfAction SubSystem: '<S6>/UrPumpCntr' incorporates:
     *  ActionPort: '<S85>/Action Port'
     */
    /* BusSelector: '<S85>/Bus Selector2' */
    for (i = 0; i < 11; i++) {
      rtb_rUrPpCntrFFMap_x[i] = UDC_B.BusInput2.CLPp.rUrPpCntrFFMap_x[i];
    }

    for (i = 0; i < 11; i++) {
      rtb_rUrPpCntrFFMap_y[i] = UDC_B.BusInput2.CLPp.rUrPpCntrFFMap_y[i];
    }

    /* End of BusSelector: '<S85>/Bus Selector2' */

    /* Sum: '<S85>/Add2' */
    rtb_etaVolConst = UDC_B.BusInput2.CLPp.rUrPpKpOffs +
      UDC_B.BusInput1.rSCR_UreaFlowCtrl_Kp;

    /* Switch: '<S85>/Switch1' incorporates:
     *  Constant: '<S85>/Constant'
     *  Logic: '<S85>/Logical Operator6'
     *  Sum: '<S85>/Add7'
     */
    if (UDC_B.BusInput.tFlow_SCR_UreaDosingOut.GoodQual &&
        UDC_B.BusInput1.bFlow_SCR_UreaDosingOut_Exist) {
      rtb_Product_k = rtb_Switch2_h - UDC_B.BusInput.tFlow_SCR_UreaDosingOut.Ai;
    } else {
      rtb_Product_k = 0.0F;
    }

    /* End of Switch: '<S85>/Switch1' */

    /* Gain: '<S88>/Gain' */
    rtb_sampletime_c = 0.01F * rtb_Product_k;

    /* Product: '<S88>/Product' */
    rtb_Product_k = rtb_etaVolConst * rtb_sampletime_c;

    /* Logic: '<S85>/Logical Operator2' incorporates:
     *  Logic: '<S85>/Logical Operator1'
     *  Logic: '<S85>/Logical Operator3'
     *  Logic: '<S85>/Logical Operator5'
     */
    rtb_LogicalOperator2_j = (UDC_B.BusInput2.CLPp.bUrPpRes ||
      (!UDC_B.BusInput1.bSCR_UreaFlowCtrl_Active) ||
      (!UDC_B.BusInput.bRel_SCR_Dosing) || UDC_B.BusInput.bSCR_Man ||
      UDC_B.BusInput.bSCR_UreaDosingUnit_Man ||
      (!UDC_B.BusInput1.bFlow_SCR_UreaDosingOut_Exist));

    /* DiscreteIntegrator: '<S88>/Discrete-Time Integrator' */
    if (UDC_DWork.DiscreteTimeIntegrator_IC_LOA_e != 0) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = UDC_B.BusInput2.CLPp.rUrPpI0;
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_d >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_d <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = -3.402823466E+38F;
        }
      }
    }

    if (rtb_LogicalOperator2_j || (UDC_DWork.DiscreteTimeIntegrator_PrevR_j5 !=
         0)) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = UDC_B.BusInput2.CLPp.rUrPpI0;
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_d >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_d <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = -3.402823466E+38F;
        }
      }
    }

    if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_d >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_d <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = -3.402823466E+38F;
      }
    }

    rtb_DiscreteTimeIntegrator_p = UDC_DWork.DiscreteTimeIntegrator_DSTATE_d;

    /* Sum: '<S85>/Add6' */
    rtb_etaVolConst = UDC_B.BusInput2.CLPp.rUrPpKdOffs +
      UDC_B.BusInput1.rSCR_UreaFlowCtrl_Kd;

    /* DiscreteIntegrator: '<S88>/Discrete-Time Integrator1' */
    if (UDC_DWork.DiscreteTimeIntegrator1_IC_LO_n != 0) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = UDC_B.BusInput2.CLPp.rUrPpD0;
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = -3.402823466E+38F;
        }
      }
    }

    if (rtb_LogicalOperator2_j || (UDC_DWork.DiscreteTimeIntegrator1_PrevR_b !=
         0)) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = UDC_B.BusInput2.CLPp.rUrPpD0;
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = -3.402823466E+38F;
        }
      }
    }

    if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = -3.402823466E+38F;
      }
    }

    /* Product: '<S88>/Product3' incorporates:
     *  DiscreteIntegrator: '<S88>/Discrete-Time Integrator1'
     *  Product: '<S88>/Product2'
     *  Sum: '<S88>/Sum2'
     */
    rtb_Product3_i = (rtb_etaVolConst * rtb_sampletime_c -
                      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l) *
      UDC_B.BusInput2.CLPp.rUrPpN;

    /* Switch: '<S85>/Switch' incorporates:
     *  DiscreteIntegrator: '<S88>/Discrete-Time Integrator'
     *  Logic: '<S85>/Logical Operator7'
     *  Logic: '<S85>/Logical Operator8'
     *  Sum: '<S88>/Sum1'
     *  UnitDelay: '<S85>/Unit Delay'
     */
    if (UDC_B.BusInput.tFlow_SCR_UreaDosingOut.GoodQual ||
        (!UDC_B.BusInput1.bFlow_SCR_UreaDosingOut_Exist)) {
      rtb_Switch2_kp = (rtb_Product_k +
                        UDC_DWork.DiscreteTimeIntegrator_DSTATE_d) +
        rtb_Product3_i;
    } else {
      rtb_Switch2_kp = UDC_DWork.UnitDelay_DSTATE_j;
    }

    /* End of Switch: '<S85>/Switch' */

    /* Switch: '<S90>/Switch2' incorporates:
     *  RelationalOperator: '<S90>/LowerRelop1'
     *  RelationalOperator: '<S90>/UpperRelop'
     *  Switch: '<S90>/Switch'
     */
    if (rtb_Switch2_kp > UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ymax) {
      rtb_Switch2_p = UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ymax;
    } else if (rtb_Switch2_kp < UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ymin) {
      /* Switch: '<S90>/Switch' */
      rtb_Switch2_p = UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ymin;
    } else {
      rtb_Switch2_p = rtb_Switch2_kp;
    }

    /* End of Switch: '<S90>/Switch2' */

    /* Abs: '<S87>/Abs' */
    rtb_LookupTableDynamic_b = (real32_T)fabs
      (UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi);

    /* Switch: '<S87>/Switch' incorporates:
     *  Constant: '<S87>/Constant2'
     *  RelationalOperator: '<S87>/Relational Operator'
     */
    if (1.1920929E-7F >= rtb_LookupTableDynamic_b) {
      rtb_LookupTableDynamic_b = 1.1920929E-7F;
    } else {
      rtb_LookupTableDynamic_b = UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi;
    }

    /* End of Switch: '<S87>/Switch' */

    /* Product: '<S85>/Divide2' */
    rtb_LookupTableDynamic_b = 1.0F / rtb_LookupTableDynamic_b * rtb_Switch2_h;

    /* Dynamic Look-Up Table Block: '<S85>/Lookup Table Dynamic'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic_f), rtb_rUrPpCntrFFMap_y,
      rtb_LookupTableDynamic_b, rtb_rUrPpCntrFFMap_x, 10U, inst);

    /* Sum: '<S85>/Add3' */
    rtb_LookupTableDynamic_b = rtb_LookupTableDynamic_f + rtb_Switch2_p;

    /* Product: '<S85>/Divide1' incorporates:
     *  Sum: '<S85>/Add1'
     */
    rtb_etaVolConst = (rtb_Switch2_kp - rtb_Switch2_p) *
      UDC_B.BusInput2.CLPp.rUrPpKaw;

    /* Product: '<S85>/Divide6' incorporates:
     *  Sum: '<S85>/Add10'
     */
    rtb_Gain1 = (rtb_LookupTableDynamic_b -
                 UDC_B.BusInput.rPc_SCR_UreaDosingPump) *
      UDC_B.BusInput2.CLPp.rUrPpKawExt;

    /* Saturate: '<S85>/Saturation1' */
    if (rtb_LookupTableDynamic_b >= 1.0F) {
      rtb_Saturation1 = 1.0F;
    } else if (rtb_LookupTableDynamic_b <= 0.0F) {
      rtb_Saturation1 = 0.0F;
    } else {
      rtb_Saturation1 = rtb_LookupTableDynamic_b;
    }

    /* End of Saturate: '<S85>/Saturation1' */

    /* Product: '<S85>/Divide3' incorporates:
     *  Sum: '<S85>/Add8'
     */
    rtb_UkYk1 = (rtb_LookupTableDynamic_b - rtb_Saturation1) *
      UDC_B.BusInput2.CLPp.rUrPpKaw;

    /* Sum: '<S85>/Add4' */
    rtb_etaVolConst = (rtb_etaVolConst + rtb_Gain1) + rtb_UkYk1;

    /* Sum: '<S85>/Add5' */
    rtb_UkYk1 = UDC_B.BusInput2.CLPp.rUrPpKiOffs +
      UDC_B.BusInput1.rSCR_UreaFlowCtrl_Ki;

    /* Switch: '<S91>/Switch2' incorporates:
     *  Gain: '<S85>/Gain2'
     *  RelationalOperator: '<S91>/LowerRelop1'
     *  RelationalOperator: '<S91>/UpperRelop'
     *  Switch: '<S91>/Switch'
     */
    if (rtb_etaVolConst > UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi) {
      rtb_LookupTableDynamic_b = UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi;
    } else if (rtb_etaVolConst < -UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi) {
      /* Switch: '<S91>/Switch' incorporates:
       *  Gain: '<S85>/Gain2'
       */
      rtb_LookupTableDynamic_b = -UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi;
    } else {
      /* Switch: '<S91>/Switch' */
      rtb_LookupTableDynamic_b = rtb_etaVolConst;
    }

    /* End of Switch: '<S91>/Switch2' */

    /* Gain: '<S85>/Gain1' */
    rtb_LookupTableDynamic_b = -rtb_LookupTableDynamic_b;

    /* Logic: '<S85>/Logical Operator4' */
    rtb_LogicalOperator1_b = !rtb_LogicalOperator2_j;

    /* Sum: '<S88>/Add' */
    rtb_etaVolConst = rtb_sampletime_c + rtb_LookupTableDynamic_b;

    /* BusCreator: '<S88>/Bus Creator' */
    rtb_sampletime_c = rtb_LookupTableDynamic_b;

    /* Dynamic Look-Up Table Block: '<S89>/Lookup Table Dynamic'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic_b), rtb_rUrPpCntrFFMap_x,
      rtb_Saturation1, rtb_rUrPpCntrFFMap_y, 10U, inst);

    /* Product: '<S89>/Divide2' */
    UDC_B.Merge5[3] = rtb_LookupTableDynamic_b *
      UDC_B.BusInput1.rFlow_SCR_UreaDosingUnit_Hi;

    /* SignalConversion: '<S85>/Signal Conversion' */
    UDC_B.Merge5[0] = rtb_LookupTableDynamic_f;

    /* SignalConversion: '<S85>/Signal Conversion1' */
    UDC_B.Merge5[1] = rtb_Saturation1;

    /* SignalConversion: '<S85>/Signal Conversion2' */
    UDC_B.Merge5[2] = rtb_Switch2_p;

    /* Update for DiscreteIntegrator: '<S88>/Discrete-Time Integrator' incorporates:
     *  Product: '<S88>/Product1'
     */
    UDC_DWork.DiscreteTimeIntegrator_IC_LOA_e = 0U;
    if (!rtb_LogicalOperator2_j) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_d += rtb_UkYk1 * rtb_etaVolConst *
        0.1F;
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_d >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_d <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator_DSTATE_d = -3.402823466E+38F;
        }
      }
    }

    if (rtb_LogicalOperator2_j) {
      UDC_DWork.DiscreteTimeIntegrator_PrevR_j5 = 1;
    } else {
      UDC_DWork.DiscreteTimeIntegrator_PrevR_j5 = 0;
    }

    /* End of Update for DiscreteIntegrator: '<S88>/Discrete-Time Integrator' */

    /* Update for DiscreteIntegrator: '<S88>/Discrete-Time Integrator1' */
    UDC_DWork.DiscreteTimeIntegrator1_IC_LO_n = 0U;
    if (!rtb_LogicalOperator2_j) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l += 0.1F * rtb_Product3_i;
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l >= 3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = 3.402823466E+38F;
      } else {
        if (UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l <= -3.402823466E+38F) {
          UDC_DWork.DiscreteTimeIntegrator1_DSTAT_l = -3.402823466E+38F;
        }
      }
    }

    if (rtb_LogicalOperator2_j) {
      UDC_DWork.DiscreteTimeIntegrator1_PrevR_b = 1;
    } else {
      UDC_DWork.DiscreteTimeIntegrator1_PrevR_b = 0;
    }

    /* End of Update for DiscreteIntegrator: '<S88>/Discrete-Time Integrator1' */

    /* Update for UnitDelay: '<S85>/Unit Delay' */
    UDC_DWork.UnitDelay_DSTATE_j = rtb_Switch2_kp;

    /* End of Outputs for SubSystem: '<S6>/UrPumpCntr' */
  } else {
    /* Outputs for IfAction SubSystem: '<S6>/Dummy' incorporates:
     *  ActionPort: '<S84>/Action Port'
     */
    UDC_B.Merge5[1] = 0.0F;
    UDC_B.Merge5[0] = 0.0F;
    UDC_B.Merge5[2] = 0.0F;
    UDC_B.Merge5[3] = 0.0F;
    rtb_LogicalOperator1_b = FALSE;

    /* BusCreator: '<S84>/Bus Creator' incorporates:
     *  Constant: '<S84>/Constant'
     *  Constant: '<S84>/Constant1'
     *  Constant: '<S84>/Constant2'
     *  Constant: '<S84>/Constant3'
     *  Constant: '<S84>/Constant4'
     *  Constant: '<S84>/Constant5'
     *  Constant: '<S84>/Constant6'
     *  Constant: '<S84>/Constant7'
     *  Constant: '<S84>/Constant8'
     */
    rtb_Product_k = 0.0F;
    rtb_DiscreteTimeIntegrator_p = 0.0F;
    rtb_Product3_i = 0.0F;
    rtb_sampletime_c = 0.0F;

    /* End of Outputs for SubSystem: '<S6>/Dummy' */
  }

  /* End of If: '<S6>/If' */

  /* BusCreator: '<Root>/Bus Creator1' incorporates:
   *  BusCreator: '<S10>/Bus Creator'
   *  BusCreator: '<S9>/Bus Creator'
   *  Logic: '<S111>/Logical Operator4'
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  UDC_Y.OutUDbus.rFlow_SCR_UreaDosingUnit_sp = rtb_Switch2_h;
  UDC_Y.OutUDbus.rFlow_SCR_NOxCtrl_Y = rtb_Switch2_m;
  UDC_Y.OutUDbus.bSCR_NOxCtrl_Act = !rtb_RelationalOperator2;

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  UDC_Y.OutUDbus.rNOx_SCR_NOxCtrl_act = rNOx_Act;

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */
  UDC_Y.OutUDbus.rNOx_SCR_CatOut_Set = rtb_BusCreator_h_rNOx_SCR_CatOu;
  UDC_Y.OutUDbus.bSCR_EngineSteadyState = rtb_LogicalOperator1_f;
  UDC_Y.OutUDbus.rPc_SCR_UreaDosingUnit_sp = UDC_B.Merge5[1];
  UDC_Y.OutUDbus.rPc_SCR_UreaDosingUnit_ff = UDC_B.Merge5[0];
  UDC_Y.OutUDbus.rPc_SCR_UreaFlowCtrl_Y = UDC_B.Merge5[2];
  UDC_Y.OutUDbus.bSCR_UreaFlowCtrl_Act = rtb_LogicalOperator1_b;
  UDC_Y.OutUDbus.rFlow_SCR_UreaDosingValve_Calc = UDC_B.Merge5[3];
  UDC_Y.OutUDbus.bSCR_NH3SlipDetected = rtb_LogicalOperator1_o;

  /* Outputs for Atomic SubSystem: '<Root>/SlipDetection' */
  UDC_Y.OutUDbus.bSCR_NH3SlipInterrupt = rtb_bSCR_NH3SlipInterrupt_k;

  /* End of Outputs for SubSystem: '<Root>/SlipDetection' */
  UDC_Y.OutUDbus.bSCR_EMValve1_SGbOxi_Dem = rtb_BusCreator_h3_bSCR_EMValve1;
  UDC_Y.OutUDbus.rFlow_SCR_UreaDosingUnit_ff = rtb_rFlow_SCR_UreaDosingUnit_ff;
  UDC_Y.OutUDbus.rUreaGain_Adj = rtb_DifferenceInputs2;
  UDC_Y.OutUDbus.rFlow_SCR_UreaDosing_ffNH3Cor = rtb_rFlow_SCR_UreaDosing_ffNH3C;

  /* Switch: '<S111>/Switch2' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   *  Constant: '<S111>/Constant1'
   *  Gain: '<S111>/Gain2'
   *  Sum: '<S111>/Add1'
   */
  if (rtb_bFreezeCtr_j) {
    rtb_etaVolConst = 0.0F;
  } else {
    /* Product: '<S111>/Divide6' incorporates:
     *  Sum: '<S111>/Add10'
     *  UnitDelay: '<S8>/Unit Delay'
     */
    rtb_UkYk1 = (UDC_DWork.UnitDelay_DSTATE_g -
                 UDC_B.BusInput.tFlow_SCR_UreaDosingOut.Ai) *
      UDC_B.BusInput2.CLNOx.rUrClKawExt;

    /* Product: '<S111>/Divide1' incorporates:
     *  Sum: '<S8>/Sum'
     */
    rtb_Gain1 = (rtb_Switch_ah - rtb_Switch2_h) * UDC_B.BusInput2.CLNOx.rUrClKaw;

    /* Product: '<S111>/Divide5' incorporates:
     *  Sum: '<S111>/Add9'
     */
    rtb_etaVolConst = (rtb_UnitDelay - rtb_Switch2_m) *
      UDC_B.BusInput2.CLNOx.rUrClKaw;
    rtb_etaVolConst = -((rtb_etaVolConst + rtb_Gain1) + rtb_UkYk1);
  }

  /* End of Switch: '<S111>/Switch2' */

  /* Switch: '<S115>/Switch2' incorporates:
   *  Gain: '<S111>/Gain1'
   *  RelationalOperator: '<S115>/LowerRelop1'
   *  RelationalOperator: '<S115>/UpperRelop'
   *  Switch: '<S115>/Switch'
   */
  if (rtb_etaVolConst > UDC_B.BusInput1.rNOx_SCR_CatOut_Hi) {
    rtb_Switch2_mg = UDC_B.BusInput1.rNOx_SCR_CatOut_Hi;
  } else if (rtb_etaVolConst < -UDC_B.BusInput1.rNOx_SCR_CatOut_Hi) {
    /* Switch: '<S115>/Switch' incorporates:
     *  Gain: '<S111>/Gain1'
     */
    rtb_Switch2_mg = -UDC_B.BusInput1.rNOx_SCR_CatOut_Hi;
  } else {
    /* Switch: '<S115>/Switch' */
    rtb_Switch2_mg = rtb_etaVolConst;
  }

  /* End of Switch: '<S115>/Switch2' */

  /* RelationalOperator: '<S111>/Relational Operator' */
  rtb_RelationalOperator2 = (rtb_UnitDelay >= UDC_B.BusInput1.rSCR_NOxCtrl_Ymax);

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S10>/Bus Creator'
   *  BusCreator: '<S111>/Bus Creator'
   *  BusCreator: '<S112>/Bus Creator'
   *  BusCreator: '<S5>/Bus Creator'
   *  BusCreator: '<S9>/Bus Creator'
   *  MATLAB Function: '<S119>/MATLAB Function'
   */
  UDC_Y.DebugUDbus.SM.rNOx_SCR_CatOut_Set = rtb_BusCreator_h_rNOx_SCR_CatOu;

  /* Outputs for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */
  UDC_Y.DebugUDbus.SM.rNOx_EMLineCatOut = rNOx_EMLineCatOut;
  UDC_Y.DebugUDbus.SM.bEMLineCatOut_GQ = bEMLineCatOut_GQ;
  UDC_Y.DebugUDbus.SM.rNOx_EMLineOxiIn = rNOx_EMLineOxiIn;
  UDC_Y.DebugUDbus.SM.bEMLineOxiIn_GQ = bEMLineOxiIn_GQ;
  UDC_Y.DebugUDbus.SM.rNOx_SCR_NOxCtrl_act = rNOx_Act;

  /* End of Outputs for SubSystem: '<S9>/E21_NOxCatOutManager' */
  UDC_Y.DebugUDbus.SM.bFreezeCtr = rtb_bFreezeCtr_j;
  UDC_Y.DebugUDbus.SM.rNOx_CatOutCor = rtb_rNOx_CatOutCor_k;
  UDC_Y.DebugUDbus.SM.bNOx_CatOutCor = rtb_bNOx_CatOutCor_n;
  UDC_Y.DebugUDbus.SM.rNOxEngOutCor = rtb_rNOxEngOutCor_e;
  UDC_Y.DebugUDbus.SM.bSCR_EngineSteadyState = rtb_LogicalOperator1_f;
  UDC_Y.DebugUDbus.SM.rTSCRAvg = rtb_BusCreator_h_rTSCRAvg;
  UDC_Y.DebugUDbus.FF.rSV = rtb_rSV;
  UDC_Y.DebugUDbus.FF.rMdot_exh = rtb_rMdot_exh;
  UDC_Y.DebugUDbus.FF.rTSCRAvgEst = rtb_Divide_h;
  UDC_Y.DebugUDbus.FF.rTSCRAvgAr = rtb_rTSCRAvg;
  UDC_Y.DebugUDbus.FF.rTSCRAvg = rtb_Switch6;
  UDC_Y.DebugUDbus.FF.rNH3StDMaxAvgEst = rtb_Divide1_o;
  UDC_Y.DebugUDbus.FF.rNH3StDMaxAr = rtb_LookupTableDynamic;
  UDC_Y.DebugUDbus.FF.rNH3StDEst = rtb_DiscreteTimeIntegrator_b;
  UDC_Y.DebugUDbus.FF.rNH3InFFSS = rtb_Divide2_h;
  UDC_Y.DebugUDbus.FF.rNH3InFF = rtb_Switch_kk;
  UDC_Y.DebugUDbus.FF.rdeltaNH3InTr = rtb_Switch_jg;
  UDC_Y.DebugUDbus.FF.rdeltaNH3InTr2 = rtb_Switch_ky;
  UDC_Y.DebugUDbus.FF.rNH3StDEst2 = rtb_Saturation_m;
  UDC_Y.DebugUDbus.FF.iIdxFFOut = rtb_iIdxFFOut;
  UDC_Y.DebugUDbus.FF.rFlowUreaFF_LT = rtb_rFlowUreaFF_LT;
  UDC_Y.DebugUDbus.FF.rFlowUreaFF_NOx = rtb_rFlowUreaFF_NOx_i;
  UDC_Y.DebugUDbus.FF.rFlowUreaFF_Map = rtb_rFlowUreaFF_Map;
  UDC_Y.DebugUDbus.FF.rFlowUreaFF_NH3 = rtb_rFlowUreaFF_NH3;
  UDC_Y.DebugUDbus.FF.rDensUrea = rtb_Switch;
  UDC_Y.DebugUDbus.Slip.bSCR_NH3SlipDetected = rtb_LogicalOperator1_o;
  UDC_Y.DebugUDbus.Slip.rUrCorFactSlip = rtb_BusCreator_h3_rUrCorFactSli;

  /* Outputs for Atomic SubSystem: '<Root>/SlipDetection' */
  UDC_Y.DebugUDbus.Slip.bFreezeCtrl = rtb_RelationalOperator_mq;
  UDC_Y.DebugUDbus.Slip.bSCR_NH3SlipInterrupt = rtb_bSCR_NH3SlipInterrupt_k;
  UDC_Y.DebugUDbus.Slip.bNH3SlipCtrlEna = rtb_bNH3SlipCtrlEna;

  /* End of Outputs for SubSystem: '<Root>/SlipDetection' */
  UDC_Y.DebugUDbus.Slip.bSCR_EMValve1_SGbOxi_Dem =
    rtb_BusCreator_h3_bSCR_EMValve1;
  UDC_Y.DebugUDbus.CLNOx.up = rtb_Product_f;
  UDC_Y.DebugUDbus.CLNOx.ui = rtb_DiscreteTimeIntegrator;
  UDC_Y.DebugUDbus.CLNOx.ud = rtb_Product3;
  UDC_Y.DebugUDbus.CLNOx.aw = rtb_Switch2_mg;
  UDC_Y.DebugUDbus.CLNOx.bFreeze = rtb_bFreezeCtr_j;
  UDC_Y.DebugUDbus.CLNOx.bSatUpLim = rtb_RelationalOperator2;
  UDC_Y.DebugUDbus.CLFlow.up = rtb_Product_k;
  UDC_Y.DebugUDbus.CLFlow.ui = rtb_DiscreteTimeIntegrator_p;
  UDC_Y.DebugUDbus.CLFlow.ud = rtb_Product3_i;
  UDC_Y.DebugUDbus.CLFlow.aw = rtb_sampletime_c;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->dbg = UDC_Y.DebugUDbus;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Out = UDC_Y.OutUDbus;

  /* BusSelector: '<Root>/Bus Selector10' incorporates:
   *  BusCreator: '<S111>/Bus Creator'
   */
  rtb_bSatUpLim_k = rtb_RelationalOperator2;

  /* Product: '<S28>/Divide3' */
  rtb_sampletime_c = rtb_Divide5 * UDC_B.BusInput2.FF.rNH3InTrGainA;

  /* Product: '<S29>/Divide5' */
  rtb_Switch2_kp = UDC_B.BusInput2.FF.rGainDeload * rtb_Saturation_m;

  /* Switch: '<S29>/Switch2' incorporates:
   *  Constant: '<S29>/I4'
   *  Constant: '<S29>/I5'
   */
  if (UDC_B.BusInput.bRel_SCR_Dosing) {
    i = 1;
  } else {
    i = 0;
  }

  /* End of Switch: '<S29>/Switch2' */

  /* Switch: '<S29>/Switch' incorporates:
   *  Constant: '<S29>/I1'
   *  Constant: '<S29>/I2'
   */
  if (UDC_B.BusInput.bOpModeStop) {
    tmp = 0;
  } else {
    tmp = 1;
  }

  /* End of Switch: '<S29>/Switch' */

  /* Product: '<S29>/Divide2' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   *  Product: '<S29>/Divide3'
   *  Product: '<S29>/Divide4'
   *  Sum: '<S29>/Add1'
   *  Sum: '<S29>/Add2'
   */
  rtb_Switch_f = ((real32_T)i * rtb_Switch_kk - (rtb_rNOxEngOutCor_e -
    rtb_rNOx_CatOutCor_k)) * (real32_T)tmp * UDC_B.BusInput2.FF.rNH3InTrGainC;

  /* BusSelector: '<S15>/Bus Selector5' */
  rtb_Ai_j0 = UDC_B.BusInput.tFlow_SCR_UreaDosingOut.Ai;

  /* BusSelector: '<S65>/Bus Selector3' */
  rtb_rTiConstAvgOn = UDC_B.BusInput2.FF.rTiConstAvgOn;
  rtb_rTiConstAvgOff = UDC_B.BusInput2.FF.rTiConstAvgOff;

  /* RelationalOperator: '<S65>/Relational Operator' */
  rtb_RelationalOperator2 = (UDC_B.BusInput.rP_Act_Norm_Filt >=
    UDC_B.BusInput2.FF.rPnorm_Thresh);

  /* Logic: '<S65>/Logical Operator' incorporates:
   *  BusCreator: '<S9>/Bus Creator'
   *  Logic: '<S65>/Logical Operator2'
   *  Logic: '<S65>/Logical Operator3'
   *  UnitDelay: '<S65>/Unit Delay4'
   */
  rtb_LogicalOperator_b = ((!UDC_B.BusInput.bSCR_Man) &&
    UDC_B.BusInput.bRel_SCR_Dosing &&
    UDC_B.BusInput.tFlow_SCR_UreaDosingOut.GoodQual && rtb_RelationalOperator2 &&
    rtb_LogicalOperator1_f && UDC_B.BusInput1.bSCR_Active &&
    UDC_B.BusInput1.bSCR_UreaNFlowAutoCorr_Active &&
    (!UDC_DWork.UnitDelay4_DSTATE_j));

  /* Logic: '<S65>/Logical Operator1' */
  rtb_LogicalOperator1_n = !rtb_LogicalOperator_b;

  /* Outputs for Atomic SubSystem: '<S15>/Filter' */
  UDC_Filter(rtb_rTiFiltUreaFFAdjust, rtb_LogicalOperator1_n, rtb_Ai_j0,
             &UDC_B.Filter_o, &UDC_DWork.Filter_o, inst);

  /* End of Outputs for SubSystem: '<S15>/Filter' */

  /* Outputs for Atomic SubSystem: '<S15>/Filter1' */
  UDC_Filter(rtb_rTiFiltUreaFFAdjust, rtb_LogicalOperator1_n,
             rtb_rFlow_SCR_UreaDosingUnit_ff, &UDC_B.Filter1, &UDC_DWork.Filter1, inst);

  /* End of Outputs for SubSystem: '<S15>/Filter1' */

  /* Outputs for Atomic SubSystem: '<S65>/TON' */
  UDC_TON(rtb_LogicalOperator_b, rtb_rTiConstAvgOn, &UDC_B.TON_j,
          &UDC_DWork.TON_j, inst);

  /* End of Outputs for SubSystem: '<S65>/TON' */

  /* Switch: '<S15>/Switch' */
  if (UDC_B.TON_j.LogicalOperator3) {
    /* Switch: '<S61>/Switch' incorporates:
     *  Abs: '<S61>/Abs'
     *  RelationalOperator: '<S61>/Relational Operator'
     */
    if (0.001F >= (real32_T)fabs(UDC_B.Filter1.Switch)) {
      rtb_Product_k = 0.001F;
    } else {
      rtb_Product_k = UDC_B.Filter1.Switch;
    }

    /* End of Switch: '<S61>/Switch' */

    /* Sum: '<S15>/Add1' incorporates:
     *  Constant: '<S15>/Constant15'
     *  Product: '<S15>/Divide2'
     *  Product: '<S15>/Product1'
     *  Sum: '<S15>/Add4'
     *  Sum: '<S15>/Add5'
     */
    rtb_etaVolConst = (UDC_B.Filter_o.Switch / rtb_Product_k - 1.0F) *
      (UDC_B.BusInput1.rCF_SCR_UreaNFlowGain + rtb_Switch2_l) + rtb_Switch2_l;

    /* RelationalOperator: '<S64>/LowerRelop1' */
    rtb_RelationalOperator2 = (rtb_etaVolConst >
      UDC_B.BusInput2.FF.rUreaGainDeltaLim);

    /* Switch: '<S64>/Switch2' */
    if (rtb_RelationalOperator2) {
      rtb_Switch2_l = UDC_B.BusInput2.FF.rUreaGainDeltaLim;
    } else {
      /* Gain: '<S15>/Gain2' */
      rtb_Gain1 = -UDC_B.BusInput2.FF.rUreaGainDeltaLim;

      /* Switch: '<S64>/Switch' incorporates:
       *  RelationalOperator: '<S64>/UpperRelop'
       */
      if (rtb_etaVolConst < rtb_Gain1) {
        rtb_Switch2_l = rtb_Gain1;
      } else {
        rtb_Switch2_l = rtb_etaVolConst;
      }

      /* End of Switch: '<S64>/Switch' */
    }

    /* End of Switch: '<S64>/Switch2' */
  }

  /* End of Switch: '<S15>/Switch' */

  /* Outputs for Atomic SubSystem: '<S65>/TP' */
  UDC_TP(UDC_B.TON_j.LogicalOperator3, rtb_rTiConstAvgOff, &UDC_B.TP,
         &UDC_DWork.TP, inst);

  /* End of Outputs for SubSystem: '<S65>/TP' */

  /* Sum: '<S112>/Add' */
  rtb_etaVolConst = rtb_LookupTableDynamic1 + rtb_Switch2_mg;

  /* BusSelector: '<S113>/Bus Selector3' */
  for (i = 0; i < 5; i++) {
    rtb_rUrClKiOffs_x[i] = UDC_B.BusInput2.CLNOx.rUrClKiOffs_x[i];
  }

  for (i = 0; i < 5; i++) {
    rtb_rUrClKiOffs_y[i] = UDC_B.BusInput2.CLNOx.rUrClKiOffs_y[i];
  }

  /* End of BusSelector: '<S113>/Bus Selector3' */
  /* Dynamic Look-Up Table Block: '<S113>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic1), rtb_rUrClKiOffs_y,
    rtb_Switch6, rtb_rUrClKiOffs_x, 4U, inst);

  /* Sum: '<S113>/Add1' */
  rtb_Gain1 = rtb_LookupTableDynamic1 + UDC_B.BusInput1.rSCR_NOxCtrl_Ki;

  /* UnitDelay: '<S7>/Unit Delay' */
  UDC_B.UnitDelay = UDC_DWork.UnitDelay_DSTATE_c;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Version = UDC_B.UnitDelay;

  /* Update for Delay: '<S15>/Delay' */
  UDC_DWork.Delay_DSTATE = rtb_Switch2_l;

  /* Update for Delay: '<S66>/Delay' */
  UDC_DWork.icLoad = 0U;
  UDC_DWork.Delay_DSTATE_d = rtb_DifferenceInputs2;

  /* Update for Atomic SubSystem: '<Root>/SlipDetection' */
  /* Update for UnitDelay: '<S10>/Unit Delay' */
  UDC_DWork.UnitDelay_DSTATE_l = rtb_Compare_l;

  /* Update for UnitDelay: '<S142>/Delay Input1' */
  UDC_DWork.DelayInput1_DSTATE = rtb_UnitDelay_h;

  /* Update for UnitDelay: '<S141>/Unit Delay' */
  UDC_DWork.UnitDelay_DSTATE_dg = rtb_Compare_l;

  /* Update for UnitDelay: '<S138>/Unit Delay2' */
  UDC_DWork.UnitDelay2_DSTATE_f = rtb_LogicalOperator8;

  /* Update for UnitDelay: '<S10>/Unit Delay2' */
  UDC_DWork.UnitDelay2_DSTATE_i = rtb_bSatUpLim_k;

  /* Update for UnitDelay: '<S139>/Unit Delay4' */
  UDC_DWork.UnitDelay4_DSTATE = rtb_Switch4;

  /* Update for Memory: '<S156>/Memory' */
  UDC_DWork.Memory_PreviousInput = rtb_Logic[0];

  /* Update for UnitDelay: '<S198>/Delay Input1' */
  UDC_DWork.DelayInput1_DSTATE_m = rtb_Compare;

  /* Update for Delay: '<S202>/Delay' */
  UDC_DWork.icLoad_g = 0U;
  UDC_DWork.Delay_DSTATE_k = rtb_DifferenceInputs2_i;

  /* Update for Delay: '<S203>/Delay' */
  UDC_DWork.icLoad_e = 0U;
  UDC_DWork.Delay_DSTATE_h = rtb_DifferenceInputs2_a;

  /* Update for Memory: '<S200>/Memory' */
  UDC_DWork.Memory_PreviousInput_k = rtb_Logic_k[0];

  /* End of Update for SubSystem: '<Root>/SlipDetection' */

  /* Update for DiscreteIntegrator: '<S28>/Discrete-Time Integrator' */
  if (!rtb_bNH3StDRes) {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE += 0.1F * rtb_sampletime_c;
  }

  if (rtb_bNH3StDRes) {
    UDC_DWork.DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    UDC_DWork.DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S28>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S29>/Discrete-Time Integrator' incorporates:
   *  Gain: '<S29>/Gain'
   *  Sum: '<S29>/Add4'
   *  Sum: '<S29>/Add5'
   *  Sum: '<S29>/Add6'
   */
  if (!rtb_bNH3StDRes2) {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE_i += ((rtb_Switch_f - rtb_Switch2_kp)
      - (rtb_DiscreteTimeIntegrator_a - rtb_Saturation_m) * 100.0F) * 0.1F;
  }

  if (rtb_bNH3StDRes2) {
    UDC_DWork.DiscreteTimeIntegrator_PrevRe_k = 1;
  } else {
    UDC_DWork.DiscreteTimeIntegrator_PrevRe_k = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S29>/Discrete-Time Integrator' */

  /* Update for Delay: '<S16>/Variable Integer Delay' */
  for (i = 0; i < 999; i++) {
    UDC_DWork.VariableIntegerDelay_DSTATE[i] =
      UDC_DWork.VariableIntegerDelay_DSTATE[i + 1];
  }

  UDC_DWork.VariableIntegerDelay_DSTATE[999] = rtb_Divide1_m;

  /* End of Update for Delay: '<S16>/Variable Integer Delay' */

  /* Update for UnitDelay: '<S111>/Unit Delay' */
  UDC_DWork.UnitDelay_DSTATE = rtb_UnitDelay;

  /* Update for DiscreteIntegrator: '<S112>/Discrete-Time Integrator' incorporates:
   *  Product: '<S112>/Product1'
   */
  UDC_DWork.DiscreteTimeIntegrator_IC_LOADI = 0U;
  if (!rtb_LogicalOperator_p) {
    UDC_DWork.DiscreteTimeIntegrator_DSTATE_p += rtb_Gain1 * rtb_etaVolConst *
      0.1F;
    if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_p >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator_DSTATE_p <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator_DSTATE_p = -3.402823466E+38F;
      }
    }
  }

  if (rtb_LogicalOperator_p) {
    UDC_DWork.DiscreteTimeIntegrator_PrevRe_j = 1;
  } else {
    UDC_DWork.DiscreteTimeIntegrator_PrevRe_j = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S112>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S112>/Discrete-Time Integrator1' */
  UDC_DWork.DiscreteTimeIntegrator1_IC_LOAD = 0U;
  if (!rtb_LogicalOperator_p) {
    UDC_DWork.DiscreteTimeIntegrator1_DSTATE += 0.1F * rtb_Product3;
    if (UDC_DWork.DiscreteTimeIntegrator1_DSTATE >= 3.402823466E+38F) {
      UDC_DWork.DiscreteTimeIntegrator1_DSTATE = 3.402823466E+38F;
    } else {
      if (UDC_DWork.DiscreteTimeIntegrator1_DSTATE <= -3.402823466E+38F) {
        UDC_DWork.DiscreteTimeIntegrator1_DSTATE = -3.402823466E+38F;
      }
    }
  }

  if (rtb_LogicalOperator_p) {
    UDC_DWork.DiscreteTimeIntegrator1_PrevRes = 1;
  } else {
    UDC_DWork.DiscreteTimeIntegrator1_PrevRes = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S112>/Discrete-Time Integrator1' */

  /* Update for UnitDelay: '<S8>/Unit Delay' */
  UDC_DWork.UnitDelay_DSTATE_g = rtb_Switch2_h;

  /* Update for UnitDelay: '<S65>/Unit Delay4' */
  UDC_DWork.UnitDelay4_DSTATE_j = UDC_B.TP.LogicalOperator1;

  /* Update for UnitDelay: '<S7>/Unit Delay' */
  UDC_DWork.UnitDelay_DSTATE_c = 108U;
}

/* Model initialize function */
void UDC_initialize(struct fUDC* inst)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* InitializeConditions for IfAction SubSystem: '<S6>/UrValCntr' */
  /* InitializeConditions for DiscreteIntegrator: '<S94>/Discrete-Time Integrator' */
  UDC_DWork.DiscreteTimeIntegrator_IC_LOA_f = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S94>/Discrete-Time Integrator1' */
  UDC_DWork.DiscreteTimeIntegrator1_IC_LO_i = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S97>/Filter_DPr' */
  UDC_Filter_Init(&UDC_DWork.Filter_DPr, inst);

  /* End of InitializeConditions for SubSystem: '<S97>/Filter_DPr' */

  /* InitializeConditions for Atomic SubSystem: '<S98>/Filter_DPr' */
  UDC_Filter_Init(&UDC_DWork.Filter_DPr_h, inst);

  /* End of InitializeConditions for SubSystem: '<S98>/Filter_DPr' */

  /* End of InitializeConditions for SubSystem: '<S6>/UrValCntr' */

  /* InitializeConditions for IfAction SubSystem: '<S6>/UrPumpCntr' */
  /* InitializeConditions for DiscreteIntegrator: '<S88>/Discrete-Time Integrator' */
  UDC_DWork.DiscreteTimeIntegrator_IC_LOA_e = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S88>/Discrete-Time Integrator1' */
  UDC_DWork.DiscreteTimeIntegrator1_IC_LO_n = 1U;

  /* End of InitializeConditions for SubSystem: '<S6>/UrPumpCntr' */
  UDC_PrevZCSigState.Delay_Reset_ZCE = UNINITIALIZED_ZCSIG;
  UDC_PrevZCSigState.Delay_Reset_ZCE_n = UNINITIALIZED_ZCSIG;
  UDC_PrevZCSigState.Delay_Reset_ZCE_d = UNINITIALIZED_ZCSIG;
  UDC_PrevZCSigState.Delay_Reset_ZCE_i = UNINITIALIZED_ZCSIG;
  UDC_PrevZCSigState.Delay_Reset_ZCE_b = UNINITIALIZED_ZCSIG;

  /* InitializeConditions for Atomic SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* InitializeConditions for Atomic SubSystem: '<S119>/TOF' */
  UDC_TOF_Init(&UDC_DWork.TOF, inst);

  /* End of InitializeConditions for SubSystem: '<S119>/TOF' */

  /* InitializeConditions for Atomic SubSystem: '<S119>/TOF1' */
  UDC_TOF_Init(&UDC_DWork.TOF1, inst);

  /* End of InitializeConditions for SubSystem: '<S119>/TOF1' */

  /* End of InitializeConditions for SubSystem: '<S9>/E21_NOxCatOutManager' */

  /* InitializeConditions for Atomic SubSystem: '<S120>/Filter' */
  UDC_Filter_Init(&UDC_DWork.Filter, inst);

  /* End of InitializeConditions for SubSystem: '<S120>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S120>/Filter2' */
  UDC_Filter_Init(&UDC_DWork.Filter2, inst);

  /* End of InitializeConditions for SubSystem: '<S120>/Filter2' */

  /* InitializeConditions for Delay: '<S66>/Delay' */
  UDC_DWork.icLoad = 1U;

  /* InitializeConditions for Atomic SubSystem: '<Root>/SlipDetection' */
  /* InitializeConditions for Atomic SubSystem: '<S137>/TOF' */
  /* InitializeConditions for UnitDelay: '<S143>/Unit Delay' */
  UDC_DWork.UnitDelay_DSTATE_jw = TRUE;

  /* InitializeConditions for Delay: '<S147>/Delay' */
  UDC_DWork.icLoad_d = 1U;

  /* End of InitializeConditions for SubSystem: '<S137>/TOF' */

  /* InitializeConditions for Atomic SubSystem: '<S137>/TP' */
  UDC_TP_Init(&UDC_DWork.TP_e, inst);

  /* End of InitializeConditions for SubSystem: '<S137>/TP' */

  /* InitializeConditions for Atomic SubSystem: '<S138>/TP1' */
  UDC_TP_Init(&UDC_DWork.TP1, inst);

  /* End of InitializeConditions for SubSystem: '<S138>/TP1' */

  /* InitializeConditions for Atomic SubSystem: '<S139>/TP' */
  UDC_TP_Init(&UDC_DWork.TP_m, inst);

  /* End of InitializeConditions for SubSystem: '<S139>/TP' */

  /* InitializeConditions for Atomic SubSystem: '<S139>/Filter_OxiIn' */
  UDC_Filter_Init(&UDC_DWork.Filter_OxiIn, inst);

  /* End of InitializeConditions for SubSystem: '<S139>/Filter_OxiIn' */

  /* InitializeConditions for Atomic SubSystem: '<S139>/Filter_CatOut' */
  UDC_Filter_Init(&UDC_DWork.Filter_CatOut, inst);

  /* End of InitializeConditions for SubSystem: '<S139>/Filter_CatOut' */

  /* InitializeConditions for Delay: '<S202>/Delay' */
  UDC_DWork.icLoad_g = 1U;

  /* InitializeConditions for Delay: '<S203>/Delay' */
  UDC_DWork.icLoad_e = 1U;

  /* InitializeConditions for MATLAB Function: '<S141>/switchHold fct1' */
  UDC_DWork.x = TRUE;

  /* End of InitializeConditions for SubSystem: '<Root>/SlipDetection' */

  /* InitializeConditions for Atomic SubSystem: '<S30>/Cell1' */
  UDC_Cell1_Init(&UDC_DWork.Cell1, inst);

  /* End of InitializeConditions for SubSystem: '<S30>/Cell1' */

  /* InitializeConditions for Atomic SubSystem: '<S30>/Cell2' */
  UDC_Cell1_Init(&UDC_DWork.Cell2, inst);

  /* End of InitializeConditions for SubSystem: '<S30>/Cell2' */

  /* InitializeConditions for Atomic SubSystem: '<S30>/Cell3' */
  UDC_Cell1_Init(&UDC_DWork.Cell3, inst);

  /* End of InitializeConditions for SubSystem: '<S30>/Cell3' */

  /* InitializeConditions for DiscreteIntegrator: '<S112>/Discrete-Time Integrator' */
  UDC_DWork.DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S112>/Discrete-Time Integrator1' */
  UDC_DWork.DiscreteTimeIntegrator1_IC_LOAD = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S15>/Filter' */
  UDC_Filter_Init(&UDC_DWork.Filter_o, inst);

  /* End of InitializeConditions for SubSystem: '<S15>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S15>/Filter1' */
  UDC_Filter_Init(&UDC_DWork.Filter1, inst);

  /* End of InitializeConditions for SubSystem: '<S15>/Filter1' */

  /* InitializeConditions for Atomic SubSystem: '<S65>/TP' */
  UDC_TP_Init(&UDC_DWork.TP, inst);

  /* End of InitializeConditions for SubSystem: '<S65>/TP' */
}

/* Model terminate function */
void UDC_terminate(struct fUDC* inst)
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
