/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: Gen2_ref
 * File: Gen2_ref.c
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
 * Implementation of program Gen2_ref
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#include "Gen2_ref.h"
#include "Gen2_ref_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/* Forward declaration for local functions */
static real_T Gen2_ref_maximum(const real_T x[13], struct Gen2* inst);

/* Forward declaration for local functions */
static real_T Gen2_ref_minimum(const real_T x[13], struct Gen2* inst);
static real_T Gen2_ref_maximum_f(const real_T x[13], struct Gen2* inst);
static void Gen2_ref_diag(const real_T v[2], real_T d[4], struct Gen2* inst);
static void Gen2_ref_diag_i(const real_T v[4], real_T d[16], struct Gen2* inst);
static void Gen2_ref_diag_i2(const real_T v[3], real_T d[9], struct Gen2* inst);
static void Gen2_ref_state_space_d(const real_T x[3], const real_T p[22], real_T
  Ke_in, real_T Phi[9], real_T h[12], real_T hd[3], struct Gen2* inst);
static void Gen2_ref_diag_i2a(const real_T v[6], real_T d[36], struct Gen2* inst);
static real_T Gen2_ref_det(const real_T x[9], struct Gen2* inst);
static void Gen2_ref_mrdiv(const real_T A[18], const real_T B[9], real_T Y[18], struct Gen2* inst);
static void Gen2_ref_mldivide(const real_T A[16], const real_T B[12], real_T Y
  [12], struct Gen2* inst);
static void Gen2_ref_integrate_model(real_T x0[3], const real_T K[12], const
  real_T u2_past[100], real_T d, const real_T x_disturb[3], const real_T Bd[9],
  real_T x_disturb1_map, const real_T u_sp[4], const real_T x_sp[3], int16_T N,
  const real_T u_min[4], const real_T u_max[4], const real_T p[22], struct Gen2* inst);
static void Gen2_ref_mldivide_j(const real_T A[4], const real_T B[12], real_T Y
  [12], struct Gen2* inst);
static real_T Gen2_ref_maximum_f5(const real_T x[7], struct Gen2* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_real_T */
void BINARYSEARCH_real_T(uint32_T *piLeft, uint32_T *piRght, real_T u, const
  real_T *pData, uint32_T iHi, struct Gen2* inst)
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

/* Lookup Utility LookUp_real_T_real_T */
void LookUp_real_T_real_T(real_T *pY, const real_T *pYData, real_T u, const
  real_T *pUData, uint32_T iHi, struct Gen2* inst)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_real_T( &(iLeft), &(iRght), u, pUData, iHi, inst);

  {
    real_T lambda;
    if (pUData[iRght] > pUData[iLeft] ) {
      real_T num;
      real_T den;
      den = pUData[iRght];
      den -= pUData[iLeft];
      num = u;
      num -= pUData[iLeft];
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
      (*pY) = yLeftCast;
    }
  }
}

/* Lookup Utility LookUp_real_T_real_T_SAT */
void LookUp_real_T_real_T_SAT(real_T *pY, const real_T *pYData, real_T u, const
  real_T *pUData, uint32_T iHi, struct Gen2* inst)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_real_T( &(iLeft), &(iRght), u, pUData, iHi, inst);

  {
    real_T lambda;
    if (pUData[iRght] > pUData[iLeft] ) {
      real_T num;
      real_T den;
      den = pUData[iRght];
      den -= pUData[iLeft];
      num = u;
      num -= pUData[iLeft];
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
      (*pY) = yLeftCast;
    }
  }
}

/* Lookup Utility LookUp_real_Treal32_T_K4km1JJi */
void LookUp_real_Treal32_T_K4km1JJi(real_T *pY, const real32_T *pYData, real_T
  u, const real_T *pUData, uint32_T iHi, struct Gen2* inst)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_real_T( &(iLeft), &(iRght), u, pUData, iHi, inst);

  {
    real_T lambda;
    if (pUData[iRght] > pUData[iLeft] ) {
      real_T num;
      real_T den;
      den = pUData[iRght];
      den -= pUData[iLeft];
      num = u;
      num -= pUData[iLeft];
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
      (*pY) = yLeftCast;
    }
  }
}

/* Lookup Binary Search Utility BINARYSEARCH_real32_Treal_T */
void BINARYSEARCH_real32_Treal_T(uint32_T *piLeft, uint32_T *piRght, real32_T u,
  const real_T *pData, uint32_T iHi, struct Gen2* inst)
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

/* Lookup Utility LookUp_real_T_real32_Treal_T */
void LookUp_real_T_real32_Treal_T(real_T *pY, const real_T *pYData, real32_T u,
  const real_T *pUData, uint32_T iHi, struct Gen2* inst)
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
      den -= pUData[iLeft];
      num = u;
      num -= pUData[iLeft];
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
      (*pY) = yLeftCast;
    }
  }
}

real_T look1_binlxpw(real_T u0, const real_T bp0[], const real_T table[],
                     uint32_T maxIndex, struct Gen2* inst)
{
  real_T frac;
  real_T yL_0d0;
  uint32_T bpIdx;
  uint32_T iLeft;
  uint32_T iRght;

  /* Column-major Lookup 1-D
     Search method: 'binary'
     Use previous index: 'off'
     Interpolation method: 'Linear point-slope'
     Extrapolation method: 'Linear'
     Use last breakpoint for index at or above upper limit: 'off'
     Remove protection against out-of-range input in generated code: 'off'
   */
  /* Prelookup - Index and Fraction
     Index Search method: 'binary'
     Extrapolation method: 'Linear'
     Use previous index: 'off'
     Use last breakpoint for index at or above upper limit: 'off'
     Remove protection against out-of-range input in generated code: 'off'
   */
  if (u0 <= bp0[0U]) {
    iLeft = 0U;
    frac = (u0 - bp0[0U]) / (bp0[1U] - bp0[0U]);
  } else if (u0 < bp0[maxIndex]) {
    /* Binary Search */
    bpIdx = maxIndex >> 1U;
    iLeft = 0U;
    iRght = maxIndex;
    while (iRght - iLeft > 1U) {
      if (u0 < bp0[bpIdx]) {
        iRght = bpIdx;
      } else {
        iLeft = bpIdx;
      }

      bpIdx = (iRght + iLeft) >> 1U;
    }

    frac = (u0 - bp0[iLeft]) / (bp0[iLeft + 1U] - bp0[iLeft]);
  } else {
    iLeft = maxIndex - 1U;
    frac = (u0 - bp0[maxIndex - 1U]) / (bp0[maxIndex] - bp0[maxIndex - 1U]);
  }

  /* Column-major Interpolation 1-D
     Interpolation method: 'Linear point-slope'
     Use last breakpoint for index at or above upper limit: 'off'
     Overflow mode: 'portable wrapping'
   */
  yL_0d0 = table[iLeft];
  return (table[iLeft + 1U] - yL_0d0) * frac + yL_0d0;
}

/*
 * System initialize for atomic system:
 *    '<S23>/Filter1'
 *    '<S23>/Filter2'
 *    '<S23>/Filter4'
 *    '<S344>/WO1'
 *    '<S424>/Filter1'
 */
void Gen2_ref_Filter1_Init(rtDW_Filter1_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S49>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S23>/Filter1'
 *    '<S23>/Filter2'
 *    '<S23>/Filter4'
 *    '<S344>/WO1'
 *    '<S424>/Filter1'
 */
void Gen2_ref_Filter1(real_T rtu_in, real_T rtu_T_filt, boolean_T rtu_reset,
                      rtB_Filter1_Gen2_ref *localB, rtDW_Filter1_Gen2_ref
                      *localDW, struct Gen2* inst)
{
  real_T rtb_Divide4_p;
  boolean_T rtb_LogicalOperator_kj;

  /* Logic: '<S49>/Logical Operator' incorporates:
   *  Constant: '<S49>/Constant'
   *  Logic: '<S49>/Logical Operator1'
   *  RelationalOperator: '<S49>/Relational Operator'
   */
  rtb_LogicalOperator_kj = (rtu_reset || (!(rtu_T_filt > 0.0)));

  /* DiscreteIntegrator: '<S49>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  if (rtb_LogicalOperator_kj || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  /* Switch: '<S71>/Switch' incorporates:
   *  Abs: '<S71>/Abs'
   *  Constant: '<S71>/Constant2'
   *  RelationalOperator: '<S71>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtu_T_filt)) {
    rtb_Divide4_p = 2.2204460492503131E-16;
  } else {
    rtb_Divide4_p = rtu_T_filt;
  }

  /* End of Switch: '<S71>/Switch' */

  /* Product: '<S49>/Divide4' incorporates:
   *  DiscreteIntegrator: '<S49>/Discrete-Time Integrator'
   *  Sum: '<S49>/Sum4'
   */
  rtb_Divide4_p = (rtu_in - localDW->DiscreteTimeIntegrator_DSTATE) /
    rtb_Divide4_p;

  /* Switch: '<S49>/Switch1' */
  if (rtb_LogicalOperator_kj) {
    /* Switch: '<S49>/Switch1' incorporates:
     *  Constant: '<S49>/Constant'
     */
    localB->Switch1 = 0.0;
  } else {
    /* Switch: '<S49>/Switch1' */
    localB->Switch1 = rtb_Divide4_p;
  }

  /* End of Switch: '<S49>/Switch1' */

  /* Update for DiscreteIntegrator: '<S49>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  localDW->DiscreteTimeIntegrator_DSTATE += 0.01 * rtb_Divide4_p;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator_kj;
}

/*
 * Output and update for atomic system:
 *    '<S23>/TON_1'
 *    '<S6>/TON'
 *    '<S667>/TON1'
 *    '<S634>/Delay Retard'
 *    '<S634>/TON'
 *    '<S714>/TON'
 *    '<S715>/TON'
 *    '<S716>/TON'
 *    '<S747>/TON'
 *    '<S831>/TON1'
 *    ...
 */
void Gen2_ref_TON_1(boolean_T rtu_IN, real_T rtu_PT, rtB_TON_1_Gen2_ref *localB,
                    rtDW_TON_1_Gen2_ref *localDW, struct Gen2* inst)
{
  boolean_T rtb_LogicalOperator2_oe;
  boolean_T rtb_RelationalOperator_m1;

  /* Logic: '<S61>/Logical Operator2' */
  rtb_LogicalOperator2_oe = !rtu_IN;

  /* DiscreteIntegrator: '<S61>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_oe || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0;
  }

  /* RelationalOperator: '<S61>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S61>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_m1 = (localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Logic: '<S61>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_m1 && rtu_IN);

  /* Update for DiscreteIntegrator: '<S61>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S95>/Conversion'
   *  Logic: '<S61>/Logical Operator'
   *  Logic: '<S61>/Logical Operator1'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (real_T)((!rtb_RelationalOperator_m1)
    && rtu_IN) * 0.01;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator2_oe;
}

/*
 * System initialize for atomic system:
 *    '<S62>/Filter3'
 *    '<S134>/Filter'
 *    '<S344>/WO2'
 *    '<S585>/Filter'
 *    '<S628>/Filter'
 *    '<S633>/Filter'
 *    '<S761>/Filter1'
 *    '<S19>/Filter'
 *    '<S19>/Filter1'
 *    '<S20>/Filter'
 *    ...
 */
void Gen2_ref_Filter3_Init(real_T rtu_x0, rtDW_Filter3_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S97>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
}

/*
 * Output and update for atomic system:
 *    '<S62>/Filter3'
 *    '<S134>/Filter'
 *    '<S344>/WO2'
 *    '<S585>/Filter'
 *    '<S628>/Filter'
 *    '<S633>/Filter'
 *    '<S761>/Filter1'
 *    '<S19>/Filter'
 *    '<S19>/Filter1'
 *    '<S20>/Filter'
 *    ...
 */
void Gen2_ref_Filter3(real_T rtu_in, real_T rtu_T_filt, real_T rtu_x0, boolean_T
                      rtu_reset, rtB_Filter3_Gen2_ref *localB,
                      rtDW_Filter3_Gen2_ref *localDW, struct Gen2* inst)
{
  real_T tmp;
  boolean_T rtb_LogicalOperator_hy;
  boolean_T rtb_RelationalOperator_hc;

  /* RelationalOperator: '<S97>/Relational Operator' incorporates:
   *  Constant: '<S97>/Constant'
   */
  rtb_RelationalOperator_hc = (rtu_T_filt > 0.0);

  /* Logic: '<S97>/Logical Operator' incorporates:
   *  Logic: '<S97>/Logical Operator1'
   */
  rtb_LogicalOperator_hy = (rtu_reset || (!rtb_RelationalOperator_hc));

  /* DiscreteIntegrator: '<S97>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator_hy || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  /* Switch: '<S97>/Switch' */
  if (rtb_RelationalOperator_hc) {
    /* Switch: '<S97>/Switch' incorporates:
     *  DiscreteIntegrator: '<S97>/Discrete-Time Integrator'
     */
    localB->Switch = localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    /* Switch: '<S97>/Switch' */
    localB->Switch = rtu_in;
  }

  /* End of Switch: '<S97>/Switch' */

  /* Switch: '<S100>/Switch' incorporates:
   *  Abs: '<S100>/Abs'
   *  Constant: '<S100>/Constant2'
   *  RelationalOperator: '<S100>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtu_T_filt)) {
    tmp = 2.2204460492503131E-16;
  } else {
    tmp = rtu_T_filt;
  }

  /* End of Switch: '<S100>/Switch' */

  /* Update for DiscreteIntegrator: '<S97>/Discrete-Time Integrator' incorporates:
   *  Product: '<S97>/Divide4'
   *  Sum: '<S97>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (rtu_in -
    localDW->DiscreteTimeIntegrator_DSTATE) / tmp * 0.01;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator_hy;
}

/*
 * System initialize for atomic system:
 *    '<S24>/MATLAB Function'
 *    '<S25>/MATLAB Function'
 */
void Gen2_ref_MATLABFunction_Init(rtDW_MATLABFunction_Gen2_ref *localDW, struct Gen2* inst)
{
  localDW->out = 2.0;
}

/*
 * Output and update for atomic system:
 *    '<S24>/MATLAB Function'
 *    '<S25>/MATLAB Function'
 */
void Gen2_ref_MATLABFunction(real_T rtu_u, real_T rtu_u_deact, real_T rtu_u_act,
  rtB_MATLABFunction_Gen2_ref *localB, rtDW_MATLABFunction_Gen2_ref *localDW, struct Gen2* inst)
{
  if (rtu_u > rtu_u_act) {
    localDW->out = 1.0;
  } else if (rtu_u < rtu_u_deact) {
    localDW->out = 2.0;
  }

  localB->y = localDW->out;
}

/*
 * Output and update for atomic system:
 *    '<S27>/engine massflow'
 *    '<S46>/engine massflow'
 */
void Gen2_ref_enginemassflow(real_T rtu_p_2s, real_T rtu_T_2s, real_T rtu_n_e,
  real_T rtu_eta_V, real_T rtu_V_d, rtB_enginemassflow_Gen2_ref *localB, struct Gen2* inst)
{
  real_T u0;
  u0 = 287.15 * rtu_T_2s;
  if (!(u0 >= 1.0)) {
    u0 = 1.0;
  }

  localB->dm_e = rtu_eta_V * rtu_V_d * rtu_p_2s / u0 * rtu_n_e / 2.0 /
    6.2831853071795862;
}

/*
 * Output and update for atomic system:
 *    '<S1>/IntegerZOH'
 *    '<S1>/IntegerZOH2'
 *    '<S5>/IntegerZOH'
 *    '<S5>/IntegerZOH1'
 *    '<S8>/IntegerZOH'
 */
void Gen2_ref_IntegerZOH(real_T rtu_u, int16_T rtu_i, rtB_IntegerZOH_Gen2_ref
  *localB, rtDW_IntegerZOH_Gen2_ref *localDW, struct Gen2* inst)
{
  if (!localDW->count_not_empty) {
    localDW->count_not_empty = true;
    localDW->u_z = rtu_u;
  }

  if (localDW->count < rtu_i) {
    localB->y = localDW->u_z;
    localDW->count++;
  } else {
    localB->y = rtu_u;
    localDW->u_z = rtu_u;
    localDW->count = 1.0;
  }
}

/*
 * Output and update for atomic system:
 *    '<S144>/lam2cg1'
 *    '<S267>/lam2cg'
 *    '<S268>/lam2cg'
 */
void Gen2_ref_lam2cg1(real_T rtu_lam, real_T rtu_AFRs, rtB_lam2cg1_Gen2_ref
                      *localB, struct Gen2* inst)
{
  real_T rtb_Switch_oai;

  /* Bias: '<S150>/Bias' incorporates:
   *  Product: '<S150>/Product'
   */
  rtb_Switch_oai = rtu_lam * rtu_AFRs + 1.0;

  /* Switch: '<S152>/Switch' incorporates:
   *  Abs: '<S152>/Abs'
   *  Constant: '<S152>/Constant2'
   *  RelationalOperator: '<S152>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Switch_oai)) {
    rtb_Switch_oai = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S152>/Switch' */

  /* Product: '<S150>/Divide' incorporates:
   *  Constant: '<S150>/Constant'
   */
  localB->Divide = 1.0 / rtb_Switch_oai;
}

/*
 * Output and update for atomic system:
 *    '<S44>/engine massflow2'
 *    '<S46>/engine massflow1'
 */
void Gen2_ref_enginemassflow2(real_T rtu_p_2s, real_T rtu_T_2s, real_T rtu_n_e,
  real_T rtu_eta_V, real_T rtu_V_d, rtB_enginemassflow2_Gen2_ref *localB, struct Gen2* inst)
{
  real_T u0;
  u0 = 287.15 * rtu_T_2s;
  if (!(u0 >= 1.0)) {
    u0 = 1.0;
  }

  localB->dm_e = rtu_eta_V * rtu_V_d * rtu_p_2s / u0 * rtu_n_e / 2.0 /
    6.2831853071795862;
}

/*
 * Output and update for atomic system:
 *    '<S161>/Inverse_Linearization4'
 *    '<S45>/Inverse_Linearization1'
 *    '<S45>/Inverse_Linearization3'
 *    '<S45>/Inverse_Linearization2'
 */
void Gen2_ref_Inverse_Linearization4(real_T rtu_rPos_TV_u, const tGen2Parameter *
  rtu_rPos_TV_u_f, rtB_Inverse_Linearization4_Gen2 *localB, struct Gen2* inst)
{
  /* S-Function (sfix_look1_dyn): '<S169>/LCRScal_Lam_EOT1' */
  /* Dynamic Look-Up Table Block: '<S169>/LCRScal_Lam_EOT1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(localB->LCRScal_Lam_EOT1),
                       &rtu_rPos_TV_u_f->bdcTv.rPosTv_Lin_x[0], rtu_rPos_TV_u,
                       &rtu_rPos_TV_u_f->bdcTv.rPosTv_Lin_y[0], 9U, inst);
}

/*
 * System initialize for atomic system:
 *    '<S190>/N_TC_HP_filt'
 *    '<S192>/N_TC_LP_filt'
 *    '<S193>/N_TC_LP_filt'
 *    '<S194>/Pel_filt'
 *    '<S195>/T1HP_filt'
 *    '<S196>/T1LP_filt'
 *    '<S197>/T2s_filt'
 *    '<S201>/Volt_filt'
 *    '<S202>/p1HP_filt'
 *    '<S204>/p2HP_filt'
 *    ...
 */
void Gen2_ref_N_TC_HP_filt_Init(rtDW_N_TC_HP_filt_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S209>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S190>/N_TC_HP_filt'
 *    '<S192>/N_TC_LP_filt'
 *    '<S193>/N_TC_LP_filt'
 *    '<S194>/Pel_filt'
 *    '<S195>/T1HP_filt'
 *    '<S196>/T1LP_filt'
 *    '<S197>/T2s_filt'
 *    '<S201>/Volt_filt'
 *    '<S202>/p1HP_filt'
 *    '<S204>/p2HP_filt'
 *    ...
 */
void Gen2_ref_N_TC_HP_filt(real_T rtu_in, real_T rtu_T_filt, boolean_T rtu_reset,
  rtB_N_TC_HP_filt_Gen2_ref *localB, rtDW_N_TC_HP_filt_Gen2_ref *localDW, struct Gen2* inst)
{
  real_T tmp;
  boolean_T rtb_LogicalOperator_ip;
  boolean_T rtb_RelationalOperator_glm;

  /* RelationalOperator: '<S209>/Relational Operator' incorporates:
   *  Constant: '<S209>/Constant'
   */
  rtb_RelationalOperator_glm = (rtu_T_filt > 0.0);

  /* Logic: '<S209>/Logical Operator' incorporates:
   *  Logic: '<S209>/Logical Operator1'
   */
  rtb_LogicalOperator_ip = (rtu_reset || (!rtb_RelationalOperator_glm));

  /* DiscreteIntegrator: '<S209>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  if (rtb_LogicalOperator_ip || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  /* Switch: '<S209>/Switch' */
  if (rtb_RelationalOperator_glm) {
    /* Switch: '<S209>/Switch' incorporates:
     *  DiscreteIntegrator: '<S209>/Discrete-Time Integrator'
     */
    localB->Switch = localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    /* Switch: '<S209>/Switch' */
    localB->Switch = rtu_in;
  }

  /* End of Switch: '<S209>/Switch' */

  /* Update for DiscreteIntegrator: '<S209>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Switch: '<S210>/Switch' incorporates:
   *  Abs: '<S210>/Abs'
   *  Constant: '<S210>/Constant2'
   *  RelationalOperator: '<S210>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtu_T_filt)) {
    tmp = 2.2204460492503131E-16;
  } else {
    tmp = rtu_T_filt;
  }

  /* End of Switch: '<S210>/Switch' */

  /* Update for DiscreteIntegrator: '<S209>/Discrete-Time Integrator' incorporates:
   *  Product: '<S209>/Divide4'
   *  Sum: '<S209>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (rtu_in -
    localDW->DiscreteTimeIntegrator_DSTATE) / tmp * 0.01;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator_ip;
}

/*
 * Output and update for atomic system:
 *    '<S267>/Mg'
 *    '<S268>/Mg'
 */
void Gen2_ref_Mg(real_T rtu_rhoGas, rtB_Mg_Gen2_ref *localB, struct Gen2* inst)
{
  real_T tmp;

  /* Switch: '<S279>/Switch' incorporates:
   *  Abs: '<S279>/Abs'
   *  Constant: '<S279>/Constant2'
   *  RelationalOperator: '<S279>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtu_rhoGas)) {
    tmp = 2.2204460492503131E-16;
  } else {
    tmp = rtu_rhoGas;
  }

  /* End of Switch: '<S279>/Switch' */

  /* Bias: '<S274>/Bias' incorporates:
   *  Constant: '<S274>/rhoAir'
   *  Product: '<S274>/Divide'
   */
  localB->Bias = 1.293 / tmp + -1.0;
}

/*
 * Output and update for atomic system:
 *    '<S267>/lam2cg1'
 *    '<S268>/lam2cg1'
 */
void Gen2_ref_lam2cg1_a(real_T rtu_lam, real_T rtu_Lmin, rtB_lam2cg1_Gen2_ref_i *
  localB, struct Gen2* inst)
{
  real_T rtb_Switch_nb;

  /* Bias: '<S277>/Bias' incorporates:
   *  Product: '<S277>/Product'
   */
  rtb_Switch_nb = rtu_lam * rtu_Lmin + 1.0;

  /* Switch: '<S287>/Switch' incorporates:
   *  Abs: '<S287>/Abs'
   *  Constant: '<S287>/Constant2'
   *  RelationalOperator: '<S287>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Switch_nb)) {
    rtb_Switch_nb = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S287>/Switch' */

  /* Product: '<S277>/Divide' incorporates:
   *  Constant: '<S277>/Constant'
   */
  localB->Divide = 1.0 / rtb_Switch_nb;
}

/*
 * Output and update for atomic system:
 *    '<S305>/FILTER no delay'
 *    '<S305>/FILTER no delay1'
 *    '<S305>/FILTER no delay2'
 *    '<S305>/FILTER no delay3'
 *    '<S305>/FILTER no delay4'
 *    '<S305>/FILTER no delay5'
 *    '<S628>/FILTER no delay'
 */
void Gen2_ref_FILTERnodelay(real_T rtu_u, real_T rtu_T, real_T rtu_Ts, boolean_T
  rtu_reset, rtB_FILTERnodelay_Gen2_ref *localB, rtDW_FILTERnodelay_Gen2_ref
  *localDW, struct Gen2* inst)
{
  real_T d_dt;
  if ((!localDW->x_not_empty) || rtu_reset) {
    localDW->x = rtu_u;
    localDW->x_not_empty = true;
  }

  if (rtu_Ts > 0.0) {
    if (rtu_T >= rtu_Ts) {
      d_dt = rtu_T;
    } else {
      d_dt = rtu_Ts;
    }

    d_dt = (rtu_u - localDW->x) / d_dt;
    localDW->x += rtu_Ts * d_dt;
    localB->y = localDW->x;
  } else {
    d_dt = rtu_u - localDW->x;
    localDW->x = rtu_u;
    localB->y = rtu_u;
  }

  localB->d_dt = d_dt;
}

/*
 * System initialize for atomic system:
 *    '<S306>/2nd Order Filter'
 *    '<S306>/2nd Order Filter1'
 *    '<S306>/2nd Order Filter2'
 */
void Gen2_ref_undOrderFilter_Init(rtDW_undOrderFilter_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S314>/Discrete-Time Integrator1' */
  localDW->DiscreteTimeIntegrator1_IC_LOAD = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S306>/2nd Order Filter'
 *    '<S306>/2nd Order Filter1'
 *    '<S306>/2nd Order Filter2'
 */
void Gen2_ref_undOrderFilter(real_T rtu_in, real_T rtu_omega, real_T rtu_d,
  boolean_T rtu_reset, rtB_undOrderFilter_Gen2_ref *localB,
  rtDW_undOrderFilter_Gen2_ref *localDW, struct Gen2* inst)
{
  real_T rtb_Divide1_jr;
  real_T rtb_a0b0_o;
  real_T rtb_x2_g;

  /* DiscreteIntegrator: '<S314>/Discrete-Time Integrator' */
  if (rtu_reset || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0;
  }

  rtb_x2_g = localDW->DiscreteTimeIntegrator_DSTATE;

  /* Product: '<S314>/Product' */
  rtb_a0b0_o = rtu_omega * rtu_omega;

  /* Switch: '<S319>/Switch' incorporates:
   *  Abs: '<S319>/Abs'
   *  Constant: '<S319>/Constant2'
   *  RelationalOperator: '<S319>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_a0b0_o)) {
    rtb_Divide1_jr = 2.2204460492503131E-16;
  } else {
    rtb_Divide1_jr = rtb_a0b0_o;
  }

  /* End of Switch: '<S319>/Switch' */

  /* Product: '<S314>/Divide1' */
  rtb_Divide1_jr = rtu_in / rtb_Divide1_jr;

  /* DiscreteIntegrator: '<S314>/Discrete-Time Integrator1' */
  if (localDW->DiscreteTimeIntegrator1_IC_LOAD != 0) {
    localDW->DiscreteTimeIntegrator1_DSTATE = rtb_Divide1_jr;
  }

  if (rtu_reset || (localDW->DiscreteTimeIntegrator1_PrevRes != 0)) {
    localDW->DiscreteTimeIntegrator1_DSTATE = rtb_Divide1_jr;
  }

  /* Switch: '<S314>/Switch1' incorporates:
   *  RelationalOperator: '<S314>/Relational Operator'
   */
  if (rtb_a0b0_o > 0.0) {
    /* Switch: '<S314>/Switch1' incorporates:
     *  DiscreteIntegrator: '<S314>/Discrete-Time Integrator'
     *  Product: '<S314>/Product5'
     */
    localB->Switch1 = rtb_a0b0_o * localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    /* Switch: '<S314>/Switch1' */
    localB->Switch1 = 0.0;
  }

  /* End of Switch: '<S314>/Switch1' */

  /* Update for DiscreteIntegrator: '<S314>/Discrete-Time Integrator' incorporates:
   *  Constant: '<S314>/Constant1'
   *  DiscreteIntegrator: '<S314>/Discrete-Time Integrator1'
   *  Product: '<S314>/Product1'
   *  Product: '<S314>/Product3'
   *  Product: '<S314>/Product4'
   *  Sum: '<S314>/Sum'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += ((rtu_in - rtb_a0b0_o *
    localDW->DiscreteTimeIntegrator1_DSTATE) - rtu_omega * rtu_d * 2.0 *
    localDW->DiscreteTimeIntegrator_DSTATE) * 0.01;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtu_reset;

  /* Update for DiscreteIntegrator: '<S314>/Discrete-Time Integrator1' incorporates:
   *  DiscreteIntegrator: '<S314>/Discrete-Time Integrator'
   */
  localDW->DiscreteTimeIntegrator1_IC_LOAD = 0U;
  localDW->DiscreteTimeIntegrator1_DSTATE += 0.01 * rtb_x2_g;
  localDW->DiscreteTimeIntegrator1_PrevRes = (int8_T)rtu_reset;
}

/*
 * System initialize for atomic system:
 *    '<S306>/2nd Order Filter3'
 *    '<S418>/2nd Order Filter'
 */
void Gen2_ref_undOrderFilter3_Init(rtDW_undOrderFilter3_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S317>/Discrete-Time Integrator1' */
  localDW->DiscreteTimeIntegrator1_IC_LOAD = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S306>/2nd Order Filter3'
 *    '<S418>/2nd Order Filter'
 */
void Gen2_ref_undOrderFilter3(real_T rtu_in, real_T rtu_omega, real_T rtu_d,
  boolean_T rtu_reset, rtB_undOrderFilter3_Gen2_ref *localB,
  rtDW_undOrderFilter3_Gen2_ref *localDW, struct Gen2* inst)
{
  real_T rtb_Divide1_k;
  real_T rtb_a0b0_e;
  real_T rtb_x2_f;

  /* DiscreteIntegrator: '<S317>/Discrete-Time Integrator' */
  if (rtu_reset || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0;
  }

  rtb_x2_f = localDW->DiscreteTimeIntegrator_DSTATE;

  /* Product: '<S317>/Product' */
  rtb_a0b0_e = rtu_omega * rtu_omega;

  /* Switch: '<S325>/Switch' incorporates:
   *  Abs: '<S325>/Abs'
   *  Constant: '<S325>/Constant2'
   *  RelationalOperator: '<S325>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_a0b0_e)) {
    rtb_Divide1_k = 2.2204460492503131E-16;
  } else {
    rtb_Divide1_k = rtb_a0b0_e;
  }

  /* End of Switch: '<S325>/Switch' */

  /* Product: '<S317>/Divide1' */
  rtb_Divide1_k = rtu_in / rtb_Divide1_k;

  /* DiscreteIntegrator: '<S317>/Discrete-Time Integrator1' */
  if (localDW->DiscreteTimeIntegrator1_IC_LOAD != 0) {
    localDW->DiscreteTimeIntegrator1_DSTATE = rtb_Divide1_k;
  }

  if (rtu_reset || (localDW->DiscreteTimeIntegrator1_PrevRes != 0)) {
    localDW->DiscreteTimeIntegrator1_DSTATE = rtb_Divide1_k;
  }

  /* Switch: '<S317>/Switch' incorporates:
   *  RelationalOperator: '<S317>/Relational Operator'
   *  Switch: '<S317>/Switch1'
   */
  if (rtb_a0b0_e > 0.0) {
    /* Switch: '<S317>/Switch' incorporates:
     *  DiscreteIntegrator: '<S317>/Discrete-Time Integrator1'
     *  Product: '<S317>/Product2'
     */
    localB->Switch = localDW->DiscreteTimeIntegrator1_DSTATE * rtb_a0b0_e;

    /* Switch: '<S317>/Switch1' incorporates:
     *  DiscreteIntegrator: '<S317>/Discrete-Time Integrator'
     *  Product: '<S317>/Product5'
     */
    localB->Switch1 = rtb_a0b0_e * localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    /* Switch: '<S317>/Switch' */
    localB->Switch = rtu_in;

    /* Switch: '<S317>/Switch1' */
    localB->Switch1 = 0.0;
  }

  /* End of Switch: '<S317>/Switch' */

  /* Update for DiscreteIntegrator: '<S317>/Discrete-Time Integrator' incorporates:
   *  Constant: '<S317>/Constant1'
   *  DiscreteIntegrator: '<S317>/Discrete-Time Integrator1'
   *  Product: '<S317>/Product1'
   *  Product: '<S317>/Product3'
   *  Product: '<S317>/Product4'
   *  Sum: '<S317>/Sum'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += ((rtu_in - rtb_a0b0_e *
    localDW->DiscreteTimeIntegrator1_DSTATE) - rtu_omega * rtu_d * 2.0 *
    localDW->DiscreteTimeIntegrator_DSTATE) * 0.01;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtu_reset;

  /* Update for DiscreteIntegrator: '<S317>/Discrete-Time Integrator1' incorporates:
   *  DiscreteIntegrator: '<S317>/Discrete-Time Integrator'
   */
  localDW->DiscreteTimeIntegrator1_IC_LOAD = 0U;
  localDW->DiscreteTimeIntegrator1_DSTATE += 0.01 * rtb_x2_f;
  localDW->DiscreteTimeIntegrator1_PrevRes = (int8_T)rtu_reset;
}

/*
 * System initialize for atomic system:
 *    '<S6>/TOF'
 *    '<S6>/TOF1'
 *    '<S6>/TOF2'
 *    '<S425>/TOF'
 *    '<S427>/TOF1'
 *    '<S427>/TOF3'
 *    '<S667>/TOF'
 *    '<S831>/TOF'
 */
void Gen2_ref_TOF_Init(rtDW_TOF_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S329>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_PrevRese = 2;
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S6>/TOF'
 *    '<S6>/TOF1'
 *    '<S6>/TOF2'
 *    '<S425>/TOF'
 *    '<S427>/TOF1'
 *    '<S427>/TOF3'
 *    '<S667>/TOF'
 *    '<S831>/TOF'
 */
void Gen2_ref_TOF(boolean_T rtu_IN, real_T rtu_PT, rtB_TOF_Gen2_ref *localB,
                  rtDW_TOF_Gen2_ref *localDW, struct Gen2* inst)
{
  real_T rtb_Switch_aro;

  /* Switch: '<S329>/Switch' incorporates:
   *  Constant: '<S329>/Constant1'
   */
  if (rtu_IN) {
    rtb_Switch_aro = 0.0;
  } else {
    rtb_Switch_aro = rtu_PT;
  }

  /* End of Switch: '<S329>/Switch' */

  /* DiscreteIntegrator: '<S329>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_aro;
  }

  if (rtu_IN && (localDW->DiscreteTimeIntegrator_PrevRese <= 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_aro;
  }

  /* Logic: '<S329>/Logical Operator1' incorporates:
   *  DiscreteIntegrator: '<S329>/Discrete-Time Integrator'
   *  RelationalOperator: '<S329>/Relational Operator'
   */
  localB->LogicalOperator1 = !(localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Update for DiscreteIntegrator: '<S329>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S333>/Conversion'
   *  Logic: '<S329>/Logical Operator5'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  localDW->DiscreteTimeIntegrator_DSTATE += 0.01 * (real_T)!rtu_IN;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtu_IN;
}

/*
 * Output and update for atomic system:
 *    '<S373>/2-point interpolation, with extrapolation'
 *    '<S373>/2-point interpolation, with extrapolation1'
 *    '<S473>/2-point interpolation, with extrapolation'
 *    '<S473>/2-point interpolation, with extrapolation1'
 *    '<S789>/2-point interpolation, with extrapolation'
 *    '<S789>/2-point interpolation, with extrapolation1'
 */
void upointinterpolationwithextrapol(real_T rtu_x, const real_T rtu_xDat[2],
  const real_T rtu_yDat[2], rtB_upointinterpolationwithextr *localB, struct Gen2* inst)
{
  real_T delta_x;
  delta_x = rtu_xDat[1] - rtu_xDat[0];
  if (fabs(delta_x) > 1.0E-7) {
    localB->y = (rtu_x - rtu_xDat[0]) / delta_x * (rtu_yDat[1] - rtu_yDat[0]) +
      rtu_yDat[0];
  } else {
    localB->y = (rtu_yDat[0] + rtu_yDat[1]) * 0.5;
  }
}

/*
 * Output and update for atomic system:
 *    '<S379>/MATLAB Function'
 *    '<S389>/MATLAB Function'
 */
void Gen2_ref_MATLABFunction_g(boolean_T rtu_reset, real_T rtu_u0, boolean_T
  rtu_LvrtFlg, real_T rtu_Y0Lvrt, rtB_MATLABFunction_Gen2_ref_k *localB,
  rtDW_MATLABFunction_Gen2_ref_f *localDW, struct Gen2* inst)
{
  if (!localDW->Y0OutTemp_not_empty) {
    localDW->Y0OutTemp = rtu_u0;
    localDW->Y0OutTemp_not_empty = true;
  }

  if (rtu_reset) {
    localB->ireset = true;
    localDW->Y0OutTemp = rtu_u0;
  } else if (rtu_LvrtFlg) {
    localB->ireset = true;
    localDW->Y0OutTemp = rtu_Y0Lvrt;
  } else {
    localB->ireset = false;
  }

  localB->Y0Out = localDW->Y0OutTemp;
}

/*
 * Output and update for atomic system:
 *    '<S379>/MATLAB Function1'
 *    '<S389>/MATLAB Function1'
 */
void Gen2_ref_MATLABFunction1(real_T rtu_LamIn, boolean_T rtu_LvrtFlg,
  rtB_MATLABFunction1_Gen2_ref *localB, rtDW_MATLABFunction1_Gen2_ref *localDW, struct Gen2* inst)
{
  if (!localDW->LamFix_not_empty) {
    localDW->LamFix = rtu_LamIn;
    localDW->LamFix_not_empty = true;
  }

  if (!rtu_LvrtFlg) {
    localB->LamOut = rtu_LamIn;
    localDW->LamFix = rtu_LamIn;
  } else {
    localB->LamOut = localDW->LamFix;
  }
}

/*
 * System initialize for atomic system:
 *    '<S344>/Pd_filt'
 *    '<S8>/Filter'
 *    '<S637>/Filter'
 *    '<S761>/Filter'
 *    '<S14>/Filter'
 *    '<S875>/Pd_filt'
 */
void Gen2_ref_Pd_filt_Init(rtDW_Pd_filt_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S396>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S344>/Pd_filt'
 *    '<S8>/Filter'
 *    '<S637>/Filter'
 *    '<S761>/Filter'
 *    '<S14>/Filter'
 *    '<S875>/Pd_filt'
 */
void Gen2_ref_Pd_filt(real_T rtu_in, real_T rtu_T_filt, real_T rtu_x0, boolean_T
                      rtu_reset, rtB_Pd_filt_Gen2_ref *localB,
                      rtDW_Pd_filt_Gen2_ref *localDW, struct Gen2* inst)
{
  real_T tmp;
  boolean_T rtb_LogicalOperator_f;
  boolean_T rtb_RelationalOperator_py;

  /* RelationalOperator: '<S396>/Relational Operator' incorporates:
   *  Constant: '<S396>/Constant'
   */
  rtb_RelationalOperator_py = (rtu_T_filt > 0.0);

  /* Logic: '<S396>/Logical Operator' incorporates:
   *  Logic: '<S396>/Logical Operator1'
   */
  rtb_LogicalOperator_f = (rtu_reset || (!rtb_RelationalOperator_py));

  /* DiscreteIntegrator: '<S396>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  if (rtb_LogicalOperator_f || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  /* Switch: '<S396>/Switch' */
  if (rtb_RelationalOperator_py) {
    /* Switch: '<S396>/Switch' incorporates:
     *  DiscreteIntegrator: '<S396>/Discrete-Time Integrator'
     */
    localB->Switch = localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    /* Switch: '<S396>/Switch' */
    localB->Switch = rtu_in;
  }

  /* End of Switch: '<S396>/Switch' */

  /* Update for DiscreteIntegrator: '<S396>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Switch: '<S405>/Switch' incorporates:
   *  Abs: '<S405>/Abs'
   *  Constant: '<S405>/Constant2'
   *  RelationalOperator: '<S405>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtu_T_filt)) {
    tmp = 2.2204460492503131E-16;
  } else {
    tmp = rtu_T_filt;
  }

  /* End of Switch: '<S405>/Switch' */

  /* Update for DiscreteIntegrator: '<S396>/Discrete-Time Integrator' incorporates:
   *  Product: '<S396>/Divide4'
   *  Sum: '<S396>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (rtu_in -
    localDW->DiscreteTimeIntegrator_DSTATE) / tmp * 0.01;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator_f;
}

/*
 * System initialize for atomic system:
 *    '<S426>/TP'
 *    '<S426>/TP1'
 *    '<S427>/TP'
 *    '<S608>/SkipPulseWaitTP'
 *    '<S667>/TP'
 *    '<S667>/TP1'
 *    '<S831>/TP'
 *    '<S831>/TP1'
 */
void Gen2_ref_TP_Init(rtDW_TP_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for UnitDelay: '<S492>/Unit Delay2' */
  localDW->UnitDelay2_DSTATE = true;
}

/*
 * Output and update for atomic system:
 *    '<S426>/TP'
 *    '<S426>/TP1'
 *    '<S427>/TP'
 *    '<S608>/SkipPulseWaitTP'
 *    '<S667>/TP'
 *    '<S667>/TP1'
 *    '<S831>/TP'
 *    '<S831>/TP1'
 */
void Gen2_ref_TP(boolean_T rtu_IN, real_T rtu_PT, rtB_TP_Gen2_ref *localB,
                 rtDW_TP_Gen2_ref *localDW, struct Gen2* inst)
{
  real_T rtb_Switch2_ne;
  real_T rtb_UkYk1_gdc;

  /* Product: '<S498>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S498>/sample time'
   *
   * About '<S498>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_ne = 0.01;

  /* Outputs for Enabled SubSystem: '<S492>/Enabled Subsystem' incorporates:
   *  EnablePort: '<S496>/Enable'
   */
  /* Logic: '<S492>/Logical Operator3' incorporates:
   *  Logic: '<S492>/Logical Operator2'
   *  UnitDelay: '<S492>/Unit Delay2'
   */
  if ((!rtu_IN) && localDW->UnitDelay2_DSTATE) {
    /* Merge: '<S492>/Merge' incorporates:
     *  Constant: '<S492>/Constant10'
     *  Inport: '<S496>/In1'
     */
    localB->Merge = 0.0;
  }

  /* End of Logic: '<S492>/Logical Operator3' */
  /* End of Outputs for SubSystem: '<S492>/Enabled Subsystem' */

  /* Outputs for Enabled SubSystem: '<S492>/Enabled Subsystem1' incorporates:
   *  EnablePort: '<S497>/Enable'
   */
  if (rtu_IN) {
    /* Merge: '<S492>/Merge' incorporates:
     *  Inport: '<S497>/In1'
     */
    localB->Merge = rtu_PT;
  }

  /* End of Outputs for SubSystem: '<S492>/Enabled Subsystem1' */

  /* Sum: '<S498>/Difference Inputs1' incorporates:
   *  UnitDelay: '<S498>/Delay Input2'
   */
  rtb_UkYk1_gdc = localB->Merge - localDW->DelayInput2_DSTATE;

  /* Switch: '<S499>/Switch2' incorporates:
   *  RelationalOperator: '<S499>/LowerRelop1'
   */
  if (!(rtb_UkYk1_gdc > 0.01)) {
    /* Product: '<S498>/delta fall limit' incorporates:
     *  Constant: '<S492>/Constant9'
     *  SampleTimeMath: '<S498>/sample time'
     *
     * About '<S498>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch2_ne = -99.990000000000009;

    /* Switch: '<S499>/Switch' incorporates:
     *  RelationalOperator: '<S499>/UpperRelop'
     */
    if (!(rtb_UkYk1_gdc < -99.990000000000009)) {
      rtb_Switch2_ne = rtb_UkYk1_gdc;
    }

    /* End of Switch: '<S499>/Switch' */
  }

  /* End of Switch: '<S499>/Switch2' */

  /* Sum: '<S498>/Difference Inputs2' incorporates:
   *  UnitDelay: '<S498>/Delay Input2'
   */
  rtb_UkYk1_gdc = rtb_Switch2_ne + localDW->DelayInput2_DSTATE;

  /* Logic: '<S492>/Logical Operator1' incorporates:
   *  Constant: '<S495>/Constant'
   *  RelationalOperator: '<S492>/Relational Operator1'
   *  RelationalOperator: '<S495>/Compare'
   */
  localB->LogicalOperator1 = ((rtb_UkYk1_gdc > 0.0) && (rtb_UkYk1_gdc < rtu_PT));

  /* Update for UnitDelay: '<S492>/Unit Delay2' incorporates:
   *  RelationalOperator: '<S492>/Relational Operator3'
   */
  localDW->UnitDelay2_DSTATE = (rtb_UkYk1_gdc >= rtu_PT);

  /* Update for UnitDelay: '<S498>/Delay Input2' */
  localDW->DelayInput2_DSTATE = rtb_UkYk1_gdc;
}

/*
 * System initialize for atomic system:
 *    '<S427>/TOF'
 *    '<S427>/TOF2'
 */
void Gen2_ref_TOF_p_Init(rtDW_TOF_Gen2_ref_f *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S511>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_PrevRese = 2;
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S427>/TOF'
 *    '<S427>/TOF2'
 * Common block description:
 *   Off Delay Timer
 */
void Gen2_ref_TOF_c(boolean_T rtu_IN, real32_T rtu_PT, rtB_TOF_Gen2_ref_j
                    *localB, rtDW_TOF_Gen2_ref_f *localDW, struct Gen2* inst)
{
  real32_T rtb_Switch_kwg;

  /* Switch: '<S511>/Switch' incorporates:
   *  Constant: '<S511>/Constant1'
   */
  if (rtu_IN) {
    rtb_Switch_kwg = 0.0F;
  } else {
    rtb_Switch_kwg = rtu_PT;
  }

  /* End of Switch: '<S511>/Switch' */

  /* DiscreteIntegrator: '<S511>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_kwg;
  }

  if (rtu_IN && (localDW->DiscreteTimeIntegrator_PrevRese <= 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtb_Switch_kwg;
  }

  /* Logic: '<S511>/Logical Operator1' incorporates:
   *  DiscreteIntegrator: '<S511>/Discrete-Time Integrator'
   *  RelationalOperator: '<S511>/Relational Operator'
   */
  localB->LogicalOperator1 = !(localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Update for DiscreteIntegrator: '<S511>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S529>/Conversion'
   *  Logic: '<S511>/Logical Operator5'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  localDW->DiscreteTimeIntegrator_DSTATE += 0.01F * (real32_T)!rtu_IN;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtu_IN;
}

/*
 * System initialize for atomic system:
 *    '<S427>/TP_ActSat_CBV'
 *    '<S427>/TP_ActSat_TV'
 *    '<S427>/TP_Ign retard'
 *    '<S427>/TP_Misfire_OFF'
 *    '<S427>/TP_Misfire_OFF1'
 *    '<S427>/TP_Misfire_OFF2'
 *    '<S427>/TP_Misfire_ON'
 *    '<S427>/TP_Misfire_ON_2nd time'
 */
void Gen2_ref_TP_ActSat_CBV_Init(rtDW_TP_ActSat_CBV_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for UnitDelay: '<S516>/Unit Delay2' */
  localDW->UnitDelay2_DSTATE = true;
}

/*
 * Output and update for atomic system:
 *    '<S427>/TP_ActSat_CBV'
 *    '<S427>/TP_ActSat_TV'
 *    '<S427>/TP_Ign retard'
 *    '<S427>/TP_Misfire_OFF'
 *    '<S427>/TP_Misfire_OFF1'
 *    '<S427>/TP_Misfire_OFF2'
 *    '<S427>/TP_Misfire_ON'
 *    '<S427>/TP_Misfire_ON_2nd time'
 */
void Gen2_ref_TP_ActSat_CBV(boolean_T rtu_IN, real_T rtu_PT,
  rtB_TP_ActSat_CBV_Gen2_ref *localB, rtDW_TP_ActSat_CBV_Gen2_ref *localDW, struct Gen2* inst)
{
  real_T rtb_Switch2_fj;
  real_T rtb_UkYk1_d;

  /* Product: '<S541>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S541>/sample time'
   *
   * About '<S541>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_fj = 0.01;

  /* Outputs for Enabled SubSystem: '<S516>/Enabled Subsystem' incorporates:
   *  EnablePort: '<S539>/Enable'
   */
  /* Logic: '<S516>/Logical Operator3' incorporates:
   *  Logic: '<S516>/Logical Operator2'
   *  UnitDelay: '<S516>/Unit Delay2'
   */
  if ((!rtu_IN) && localDW->UnitDelay2_DSTATE) {
    /* Merge: '<S516>/Merge' incorporates:
     *  Constant: '<S516>/Constant10'
     *  Inport: '<S539>/In1'
     */
    localB->Merge = 0.0;
  }

  /* End of Logic: '<S516>/Logical Operator3' */
  /* End of Outputs for SubSystem: '<S516>/Enabled Subsystem' */

  /* Outputs for Enabled SubSystem: '<S516>/Enabled Subsystem1' incorporates:
   *  EnablePort: '<S540>/Enable'
   */
  if (rtu_IN) {
    /* Merge: '<S516>/Merge' incorporates:
     *  Inport: '<S540>/In1'
     */
    localB->Merge = rtu_PT;
  }

  /* End of Outputs for SubSystem: '<S516>/Enabled Subsystem1' */

  /* Sum: '<S541>/Difference Inputs1' incorporates:
   *  UnitDelay: '<S541>/Delay Input2'
   */
  rtb_UkYk1_d = localB->Merge - localDW->DelayInput2_DSTATE;

  /* Switch: '<S542>/Switch2' incorporates:
   *  RelationalOperator: '<S542>/LowerRelop1'
   */
  if (!(rtb_UkYk1_d > 0.01)) {
    /* Product: '<S541>/delta fall limit' incorporates:
     *  Constant: '<S516>/Constant9'
     *  SampleTimeMath: '<S541>/sample time'
     *
     * About '<S541>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch2_fj = -99.990000000000009;

    /* Switch: '<S542>/Switch' incorporates:
     *  RelationalOperator: '<S542>/UpperRelop'
     */
    if (!(rtb_UkYk1_d < -99.990000000000009)) {
      rtb_Switch2_fj = rtb_UkYk1_d;
    }

    /* End of Switch: '<S542>/Switch' */
  }

  /* End of Switch: '<S542>/Switch2' */

  /* Sum: '<S541>/Difference Inputs2' incorporates:
   *  UnitDelay: '<S541>/Delay Input2'
   */
  rtb_UkYk1_d = rtb_Switch2_fj + localDW->DelayInput2_DSTATE;

  /* Logic: '<S516>/Logical Operator1' incorporates:
   *  Constant: '<S538>/Constant'
   *  RelationalOperator: '<S516>/Relational Operator1'
   *  RelationalOperator: '<S538>/Compare'
   */
  localB->LogicalOperator1 = ((rtb_UkYk1_d > 0.0) && (rtb_UkYk1_d < rtu_PT));

  /* Update for UnitDelay: '<S516>/Unit Delay2' incorporates:
   *  RelationalOperator: '<S516>/Relational Operator3'
   */
  localDW->UnitDelay2_DSTATE = (rtb_UkYk1_d >= rtu_PT);

  /* Update for UnitDelay: '<S541>/Delay Input2' */
  localDW->DelayInput2_DSTATE = rtb_UkYk1_d;
}

/*
 * Output and update for atomic system:
 *    '<S589>/MATLAB Function'
 *    '<S582>/MATLAB Function'
 *    '<S582>/MATLAB Function1'
 *    '<S633>/MATLAB Function'
 *    '<S19>/MATLAB Function'
 */
void Gen2_ref_MATLABFunction_n(real_T rtu_u, real_T rtu_eps,
  rtB_MATLABFunction_Gen2_ref_o *localB, rtDW_MATLABFunction_Gen2_ref_k *localDW, struct Gen2* inst)
{
  real_T delta;
  delta = rtu_u - localDW->y_z;
  if (delta > rtu_eps) {
    localB->y = localDW->y_z + 1.0;
  } else if (delta < -rtu_eps) {
    localB->y = localDW->y_z - 1.0;
  } else {
    localB->y = localDW->y_z;
  }

  localDW->y_z = localB->y;
}

/*
 * System initialize for atomic system:
 *    '<S630>/Filter'
 *    '<S636>/Filter'
 */
void Gen2_ref_Filter_Init(rtDW_Filter_Gen2_ref *localDW, struct Gen2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S665>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S630>/Filter'
 *    '<S636>/Filter'
 */
void Gen2_ref_Filter(real_T rtu_in, real_T rtu_x0, boolean_T rtu_reset,
                     rtB_Filter_Gen2_ref *localB, const rtC_Filter_Gen2_ref
                     *localC, rtDW_Filter_Gen2_ref *localDW, struct Gen2* inst)
{
  boolean_T rtb_LogicalOperator_g1;

  /* Logic: '<S665>/Logical Operator' */
  rtb_LogicalOperator_g1 = (rtu_reset || localC->LogicalOperator1);

  /* DiscreteIntegrator: '<S665>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  if (rtb_LogicalOperator_g1 || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  /* Switch: '<S665>/Switch' */
  if (localC->RelationalOperator_g) {
    /* Switch: '<S665>/Switch' incorporates:
     *  DiscreteIntegrator: '<S665>/Discrete-Time Integrator'
     */
    localB->Switch = localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    /* Switch: '<S665>/Switch' */
    localB->Switch = rtu_in;
  }

  /* End of Switch: '<S665>/Switch' */

  /* Update for DiscreteIntegrator: '<S665>/Discrete-Time Integrator' incorporates:
   *  Product: '<S665>/Divide4'
   *  Sum: '<S665>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  localDW->DiscreteTimeIntegrator_DSTATE += (rtu_in -
    localDW->DiscreteTimeIntegrator_DSTATE) / localC->Switch * 0.01;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator_g1;
}

/*
 * Output and update for atomic system:
 *    '<S666>/Ke Map Update'
 *    '<S830>/Ke Map Update'
 */
void Gen2_ref_KeMapUpdate(real_T rtu_in, boolean_T rtu_reset, real_T rtu_Ke_map,
  boolean_T rtu_resetTrans, boolean_T rtu_resetTrans_f, const tGen2Parameter
  *rtu_para, rtB_KeMapUpdate_Gen2_ref *localB, rtDW_KeMapUpdate_Gen2_ref
  *localDW, struct Gen2* inst)
{
  real_T rtb_RelationalOperator_gj;
  real_T rtb_Switch_cs;
  real_T rtb_Switch_mvl;
  boolean_T rtb_LogicalOperator_lv;
  boolean_T rtb_RelationalOperator_kzb;

  /* Sum: '<S671>/Sum' incorporates:
   *  Product: '<S671>/Divide2'
   */
  rtb_Switch_mvl = rtu_para->SpeedCtrl.rTiF_KeEstIncrAfterTrans * (real_T)
    rtu_resetTrans + rtu_para->SpeedCtrl.rTiF_KeEstDiffMapUpdate;

  /* RelationalOperator: '<S671>/Relational Operator' incorporates:
   *  Constant: '<S671>/Constant'
   */
  rtb_RelationalOperator_kzb = (rtb_Switch_mvl > 0.0);

  /* Logic: '<S671>/Logical Operator' incorporates:
   *  Logic: '<S671>/Logical Operator1'
   */
  rtb_LogicalOperator_lv = (rtu_reset || rtu_resetTrans_f ||
    (!rtb_RelationalOperator_kzb));

  /* DiscreteIntegrator: '<S671>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator_lv || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0;
  }

  /* Sum: '<S671>/Sum3' */
  rtb_Switch_cs = rtu_in - rtu_Ke_map;

  /* Switch: '<S671>/Switch' incorporates:
   *  DiscreteIntegrator: '<S671>/Discrete-Time Integrator'
   */
  if (rtb_RelationalOperator_kzb) {
    rtb_RelationalOperator_gj = localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    rtb_RelationalOperator_gj = rtb_Switch_cs;
  }

  /* End of Switch: '<S671>/Switch' */

  /* Sum: '<S671>/Sum1' */
  localB->Sum1 = rtb_RelationalOperator_gj + rtu_Ke_map;

  /* Switch: '<S674>/Switch' incorporates:
   *  Abs: '<S674>/Abs'
   *  Constant: '<S674>/Constant2'
   *  RelationalOperator: '<S674>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Switch_mvl)) {
    rtb_Switch_mvl = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S674>/Switch' */

  /* Update for DiscreteIntegrator: '<S671>/Discrete-Time Integrator' incorporates:
   *  Product: '<S671>/Divide4'
   *  Sum: '<S671>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (rtb_Switch_cs -
    localDW->DiscreteTimeIntegrator_DSTATE) / rtb_Switch_mvl * 0.01;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator_lv;
}

/* Function for MATLAB Function: '<S666>/MATLAB Function1' */
static real_T Gen2_ref_maximum(const real_T x[13], struct Gen2* inst)
{
  real_T ex;
  int32_T idx;
  int32_T k;
  boolean_T exitg1;
  if (!rtIsNaN(x[0])) {
    idx = 1;
  } else {
    idx = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k < 14)) {
      if (!rtIsNaN(x[k - 1])) {
        idx = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }

  if (idx == 0) {
    ex = x[0];
  } else {
    ex = x[idx - 1];
    while (idx + 1 <= 13) {
      if (ex < x[idx]) {
        ex = x[idx];
      }

      idx++;
    }
  }

  return ex;
}

/*
 * Output and update for atomic system:
 *    '<S666>/MATLAB Function1'
 *    '<S830>/MATLAB Function1'
 */
void Gen2_ref_MATLABFunction1_m(const real_T rtu_x_ref[13], const real_T
  rtu_y_ref[13], real_T rtu_epsilon, real_T rtu_x_f, real_T rtu_y_act, boolean_T
  rtu_reset, boolean_T rtu_issteady, rtB_MATLABFunction1_Gen2_ref_h *localB,
  rtDW_MATLABFunction1_Gen2_ref_c *localDW, struct Gen2* inst)
{
  real_T delta_y;
  real_T delta_y_tmp_tmp;
  real_T delta_y_tmp_tmp_0;
  real_T u0;
  real_T x;
  real_T y_map_tmp;
  int32_T i;
  int32_T k;
  boolean_T exitg1;
  if ((!localDW->y_map_not_empty) || rtu_reset) {
    localDW->y_map_not_empty = true;
    for (i = 0; i < 13; i++) {
      localDW->y_map[i] = rtu_y_ref[i];
      localDW->x_map[i] = rtu_x_ref[i];
    }
  }

  if (Gen2_ref_maximum(localDW->y_map, inst) < 0.1) {
    for (i = 0; i < 13; i++) {
      localDW->y_map[i] = rtu_y_ref[i];
    }
  }

  if (!rtIsNaN(localDW->x_map[0])) {
    i = 1;
  } else {
    i = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k < 14)) {
      if (!rtIsNaN(localDW->x_map[k - 1])) {
        i = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }

  if (i == 0) {
    x = localDW->x_map[0];
  } else {
    x = localDW->x_map[i - 1];
    while (i + 1 <= 13) {
      if (x > localDW->x_map[i]) {
        x = localDW->x_map[i];
      }

      i++;
    }
  }

  if ((!(x >= rtu_x_f)) && (!rtIsNaN(rtu_x_f))) {
    x = rtu_x_f;
  }

  u0 = Gen2_ref_maximum(localDW->x_map, inst);
  if ((u0 <= x) || rtIsNaN(x)) {
    x = u0;
  }

  k = 0;
  if (!(x < localDW->x_map[0])) {
    for (i = 0; i < 13; i++) {
      if (x > localDW->x_map[i]) {
        k = i;
      }
    }
  }

  if (k + 1 < 13) {
    if (rtu_issteady && (!rtu_reset)) {
      u0 = localDW->y_map[k + 1];
      delta_y_tmp_tmp = x - localDW->x_map[k];
      delta_y_tmp_tmp_0 = localDW->x_map[k + 1];
      delta_y = delta_y_tmp_tmp / (delta_y_tmp_tmp_0 - localDW->x_map[k]) * (u0
        - localDW->y_map[k]) + localDW->y_map[k];
      delta_y = ((1.0 - rtu_epsilon) * delta_y + rtu_epsilon * rtu_y_act) -
        delta_y;
      x = delta_y_tmp_tmp_0 - x;
      delta_y_tmp_tmp_0 = delta_y_tmp_tmp + x;
      y_map_tmp = delta_y_tmp_tmp_0 * x;
      x = (delta_y_tmp_tmp * delta_y_tmp_tmp + y_map_tmp) - delta_y_tmp_tmp * x;
      localDW->y_map[k] += y_map_tmp * delta_y / x;
      localDW->y_map[k + 1] = delta_y_tmp_tmp_0 * delta_y_tmp_tmp * delta_y / x
        + u0;
    }
  } else if (rtu_issteady && (!rtu_reset)) {
    localDW->y_map[12] = (1.0 - rtu_epsilon) * localDW->y_map[12] + rtu_epsilon *
      rtu_y_act;
  }

  for (i = 0; i < 13; i++) {
    localB->y_map_new[i] = localDW->y_map[i];
  }
}

real_T rt_roundd_snf(real_T u, struct Gen2* inst)
{
  real_T y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

real_T rt_powd_snf(real_T u0, real_T u1, struct Gen2* inst)
{
  real_T tmp;
  real_T tmp_0;
  real_T y;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = (rtNaN);
  } else {
    tmp = fabs(u0);
    tmp_0 = fabs(u1);
    if (rtIsInf(u1)) {
      if (tmp == 1.0) {
        y = 1.0;
      } else if (tmp > 1.0) {
        if (u1 > 0.0) {
          y = (rtInf);
        } else {
          y = 0.0;
        }
      } else if (u1 > 0.0) {
        y = 0.0;
      } else {
        y = (rtInf);
      }
    } else if (tmp_0 == 0.0) {
      y = 1.0;
    } else if (tmp_0 == 1.0) {
      if (u1 > 0.0) {
        y = u0;
      } else {
        y = 1.0 / u0;
      }
    } else if (u1 == 2.0) {
      y = u0 * u0;
    } else if ((u1 == 0.5) && (u0 >= 0.0)) {
      y = sqrt(u0);
    } else if ((u0 < 0.0) && (u1 > floor(u1))) {
      y = (rtNaN);
    } else {
      y = pow(u0, u1);
    }
  }

  return y;
}

/* Function for MATLAB Function: '<S716>/MATLAB Function' */
static real_T Gen2_ref_minimum(const real_T x[13], struct Gen2* inst)
{
  real_T ex;
  int32_T idx;
  int32_T k;
  boolean_T exitg1;
  if (!rtIsNaN(x[0])) {
    idx = 1;
  } else {
    idx = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k < 14)) {
      if (!rtIsNaN(x[k - 1])) {
        idx = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }

  if (idx == 0) {
    ex = x[0];
  } else {
    ex = x[idx - 1];
    while (idx + 1 <= 13) {
      if (ex > x[idx]) {
        ex = x[idx];
      }

      idx++;
    }
  }

  return ex;
}

/* Function for MATLAB Function: '<S714>/MATLAB Function1' */
static real_T Gen2_ref_maximum_f(const real_T x[13], struct Gen2* inst)
{
  real_T ex;
  int32_T idx;
  int32_T k;
  boolean_T exitg1;
  if (!rtIsNaN(x[0])) {
    idx = 1;
  } else {
    idx = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k < 14)) {
      if (!rtIsNaN(x[k - 1])) {
        idx = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }

  if (idx == 0) {
    ex = x[0];
  } else {
    ex = x[idx - 1];
    while (idx + 1 <= 13) {
      if (ex < x[idx]) {
        ex = x[idx];
      }

      idx++;
    }
  }

  return ex;
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_diag(const real_T v[2], real_T d[4], struct Gen2* inst)
{
  d[1] = 0.0;
  d[2] = 0.0;
  d[0] = v[0];
  d[3] = v[1];
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_diag_i(const real_T v[4], real_T d[16], struct Gen2* inst)
{
  int32_T i;
  for (i = 0; i < 16; i++) {
    d[i] = 0.0;
  }

  d[0] = v[0];
  d[5] = v[1];
  d[10] = v[2];
  d[15] = v[3];
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_diag_i2(const real_T v[3], real_T d[9], struct Gen2* inst)
{
  int32_T i;
  for (i = 0; i < 9; i++) {
    d[i] = 0.0;
  }

  d[0] = v[0];
  d[4] = v[1];
  d[8] = v[2];
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_state_space_d(const real_T x[3], const real_T p[22], real_T
  Ke_in, real_T Phi[9], real_T h[12], real_T hd[3], struct Gen2* inst)
{
  real_T Phi_tmp;
  real_T Phi_tmp_0;
  real_T Phi_tmp_1;
  real_T a_tmp;
  a_tmp = x[2] * p[8] + 1.0;
  Phi[0] = 1.0;
  Phi_tmp = a_tmp * p[3];
  Phi[3] = Ke_in * p[2] / Phi_tmp;
  Phi[6] = -(Ke_in * p[8] * p[2] * x[1]) / (a_tmp * a_tmp * p[3]);
  Phi[1] = 0.0;
  Phi_tmp_0 = p[2] / p[5];
  Phi[4] = 1.0 - Phi_tmp_0;
  Phi[7] = 0.0;
  Phi[2] = 0.0;
  Phi[5] = 0.0;
  Phi_tmp_1 = p[2] / p[6];
  Phi[8] = 1.0 - Phi_tmp_1;
  h[0] = 0.0;
  h[3] = 0.0;
  h[6] = p[7] * Ke_in * p[2] * x[1] / Phi_tmp;
  h[9] = -(p[11] * Ke_in * p[2] * x[1]) / ((p[12] - p[11] * p[16]) * p[3] *
    a_tmp);
  h[1] = Phi_tmp_0;
  h[4] = 0.0;
  h[7] = 0.0;
  h[10] = 0.0;
  h[2] = 0.0;
  h[5] = Phi_tmp_1;
  h[8] = 0.0;
  h[11] = 0.0;
  hd[0] = -p[2] / p[3];
  hd[1] = 0.0;
  hd[2] = 0.0;
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_diag_i2a(const real_T v[6], real_T d[36], struct Gen2* inst)
{
  int32_T j;
  for (j = 0; j < 36; j++) {
    d[j] = 0.0;
  }

  for (j = 0; j < 6; j++) {
    d[j + 6 * j] = v[j];
  }
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static real_T Gen2_ref_det(const real_T x[9], struct Gen2* inst)
{
  real_T A[9];
  real_T s;
  real_T smax;
  real_T y;
  int32_T c;
  int32_T c_ix;
  int32_T c_k;
  int32_T ijA;
  int32_T ix;
  int32_T iy;
  int32_T j;
  int32_T jj;
  int8_T ipiv[3];
  boolean_T isodd;
  for (j = 0; j < 9; j++) {
    A[j] = x[j];
  }

  ipiv[0] = 1;
  ipiv[1] = 2;
  for (j = 0; j < 2; j++) {
    jj = j << 2;
    iy = 0;
    ix = jj;
    smax = fabs(A[jj]);
    for (c_k = 2; c_k <= 3 - j; c_k++) {
      ix++;
      s = fabs(A[ix]);
      if (s > smax) {
        iy = c_k - 1;
        smax = s;
      }
    }

    if (A[jj + iy] != 0.0) {
      if (iy != 0) {
        iy += j;
        ipiv[j] = (int8_T)(iy + 1);
        smax = A[j];
        A[j] = A[iy];
        A[iy] = smax;
        smax = A[j + 3];
        A[j + 3] = A[iy + 3];
        A[iy + 3] = smax;
        smax = A[j + 6];
        A[j + 6] = A[iy + 6];
        A[iy + 6] = smax;
      }

      iy = (jj - j) + 3;
      for (ix = jj + 1; ix < iy; ix++) {
        A[ix] /= A[jj];
      }
    }

    iy = jj;
    ix = jj + 3;
    for (c_k = 0; c_k <= 1 - j; c_k++) {
      if (A[ix] != 0.0) {
        smax = -A[ix];
        c_ix = jj + 1;
        ijA = iy + 4;
        c = (iy - j) + 6;
        while (ijA + 1 <= c) {
          A[ijA] += A[c_ix] * smax;
          c_ix++;
          ijA++;
        }
      }

      ix += 3;
      iy += 3;
    }
  }

  isodd = (ipiv[0] > 1);
  y = A[0] * A[4] * A[8];
  if (ipiv[1] > 2) {
    isodd = !isodd;
  }

  if (isodd) {
    y = -y;
  }

  return y;
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_mrdiv(const real_T A[18], const real_T B[9], real_T Y[18], struct Gen2* inst)
{
  real_T b_A[9];
  real_T a21;
  real_T maxval;
  int32_T Y_tmp;
  int32_T Y_tmp_0;
  int32_T Y_tmp_1;
  int32_T r1;
  int32_T r2;
  int32_T r3;
  int32_T rtemp;
  for (r1 = 0; r1 < 9; r1++) {
    b_A[r1] = B[r1];
  }

  r1 = 0;
  r2 = 1;
  r3 = 2;
  maxval = fabs(B[0]);
  a21 = fabs(B[1]);
  if (a21 > maxval) {
    maxval = a21;
    r1 = 1;
    r2 = 0;
  }

  if (fabs(B[2]) > maxval) {
    r1 = 2;
    r2 = 1;
    r3 = 0;
  }

  b_A[r2] = B[r2] / B[r1];
  b_A[r3] /= b_A[r1];
  b_A[r2 + 3] -= b_A[r1 + 3] * b_A[r2];
  b_A[r3 + 3] -= b_A[r1 + 3] * b_A[r3];
  b_A[r2 + 6] -= b_A[r1 + 6] * b_A[r2];
  b_A[r3 + 6] -= b_A[r1 + 6] * b_A[r3];
  if (fabs(b_A[r3 + 3]) > fabs(b_A[r2 + 3])) {
    rtemp = r2;
    r2 = r3;
    r3 = rtemp;
  }

  b_A[r3 + 3] /= b_A[r2 + 3];
  b_A[r3 + 6] -= b_A[r3 + 3] * b_A[r2 + 6];
  for (rtemp = 0; rtemp < 6; rtemp++) {
    Y_tmp = 6 * r1 + rtemp;
    Y[Y_tmp] = A[rtemp] / b_A[r1];
    Y_tmp_0 = 6 * r2 + rtemp;
    Y[Y_tmp_0] = A[rtemp + 6] - b_A[r1 + 3] * Y[Y_tmp];
    Y_tmp_1 = 6 * r3 + rtemp;
    Y[Y_tmp_1] = A[rtemp + 12] - b_A[r1 + 6] * Y[Y_tmp];
    Y[Y_tmp_0] /= b_A[r2 + 3];
    Y[Y_tmp_1] -= b_A[r2 + 6] * Y[Y_tmp_0];
    Y[Y_tmp_1] /= b_A[r3 + 6];
    Y[Y_tmp_0] -= b_A[r3 + 3] * Y[Y_tmp_1];
    Y[Y_tmp] -= Y[Y_tmp_1] * b_A[r3];
    Y[Y_tmp] -= Y[Y_tmp_0] * b_A[r2];
  }
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_mldivide(const real_T A[16], const real_T B[12], real_T Y
  [12], struct Gen2* inst)
{
  real_T b_A[16];
  real_T s;
  real_T smax;
  int32_T b_j;
  int32_T c;
  int32_T c_ix;
  int32_T c_k;
  int32_T ijA;
  int32_T ix;
  int32_T iy;
  int32_T jj;
  int8_T ipiv[4];
  int8_T ipiv_0;
  for (b_j = 0; b_j < 16; b_j++) {
    b_A[b_j] = A[b_j];
  }

  for (b_j = 0; b_j < 12; b_j++) {
    Y[b_j] = B[b_j];
  }

  ipiv[0] = 1;
  ipiv[1] = 2;
  ipiv[2] = 3;
  ipiv[3] = 4;
  for (b_j = 0; b_j < 3; b_j++) {
    jj = b_j * 5;
    iy = 0;
    ix = jj;
    smax = fabs(b_A[jj]);
    for (c_k = 2; c_k <= 4 - b_j; c_k++) {
      ix++;
      s = fabs(b_A[ix]);
      if (s > smax) {
        iy = c_k - 1;
        smax = s;
      }
    }

    if (b_A[jj + iy] != 0.0) {
      if (iy != 0) {
        c_k = b_j + iy;
        ipiv[b_j] = (int8_T)(c_k + 1);
        smax = b_A[b_j];
        b_A[b_j] = b_A[c_k];
        b_A[c_k] = smax;
        smax = b_A[b_j + 4];
        b_A[b_j + 4] = b_A[c_k + 4];
        b_A[c_k + 4] = smax;
        smax = b_A[b_j + 8];
        b_A[b_j + 8] = b_A[c_k + 8];
        b_A[c_k + 8] = smax;
        smax = b_A[b_j + 12];
        b_A[b_j + 12] = b_A[c_k + 12];
        b_A[c_k + 12] = smax;
      }

      iy = (jj - b_j) + 4;
      for (ix = jj + 1; ix < iy; ix++) {
        b_A[ix] /= b_A[jj];
      }
    }

    iy = jj;
    ix = jj + 4;
    for (c_k = 0; c_k <= 2 - b_j; c_k++) {
      if (b_A[ix] != 0.0) {
        smax = -b_A[ix];
        c_ix = jj + 1;
        ijA = iy + 5;
        c = (iy - b_j) + 8;
        while (ijA + 1 <= c) {
          b_A[ijA] += b_A[c_ix] * smax;
          c_ix++;
          ijA++;
        }
      }

      ix += 4;
      iy += 4;
    }
  }

  for (b_j = 0; b_j < 3; b_j++) {
    ipiv_0 = ipiv[b_j];
    if (b_j + 1 != ipiv_0) {
      smax = Y[b_j];
      Y[b_j] = Y[ipiv_0 - 1];
      Y[ipiv_0 - 1] = smax;
      smax = Y[b_j + 4];
      Y[b_j + 4] = Y[ipiv_0 + 3];
      Y[ipiv_0 + 3] = smax;
      smax = Y[b_j + 8];
      Y[b_j + 8] = Y[ipiv_0 + 7];
      Y[ipiv_0 + 7] = smax;
    }
  }

  for (b_j = 0; b_j < 3; b_j++) {
    jj = b_j << 2;
    if (Y[jj] != 0.0) {
      for (c_k = 2; c_k < 5; c_k++) {
        iy = (c_k + jj) - 1;
        Y[iy] -= b_A[c_k - 1] * Y[jj];
      }
    }

    if (Y[jj + 1] != 0.0) {
      for (c_k = 3; c_k < 5; c_k++) {
        iy = (c_k + jj) - 1;
        Y[iy] -= Y[jj + 1] * b_A[c_k + 3];
      }
    }

    smax = Y[jj + 2];
    if (smax != 0.0) {
      Y[jj + 3] -= smax * b_A[11];
    }
  }

  for (b_j = 0; b_j < 3; b_j++) {
    jj = b_j << 2;
    smax = Y[jj + 3];
    if (smax != 0.0) {
      Y[jj + 3] = smax / b_A[15];
      for (c_k = 0; c_k < 3; c_k++) {
        iy = c_k + jj;
        Y[iy] -= Y[jj + 3] * b_A[c_k + 12];
      }
    }

    smax = Y[jj + 2];
    if (smax != 0.0) {
      Y[jj + 2] = smax / b_A[10];
      for (c_k = 0; c_k < 2; c_k++) {
        iy = c_k + jj;
        Y[iy] -= Y[jj + 2] * b_A[c_k + 8];
      }
    }

    smax = Y[jj + 1];
    if (smax != 0.0) {
      Y[jj + 1] = smax / b_A[5];
      Y[jj] -= Y[jj + 1] * b_A[4];
    }

    if (Y[jj] != 0.0) {
      Y[jj] /= b_A[0];
    }
  }
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_integrate_model(real_T x0[3], const real_T K[12], const
  real_T u2_past[100], real_T d, const real_T x_disturb[3], const real_T Bd[9],
  real_T x_disturb1_map, const real_T u_sp[4], const real_T x_sp[3], int16_T N,
  const real_T u_min[4], const real_T u_max[4], const real_T p[22], struct Gen2* inst)
{
  real_T u_k[4];
  real_T u_k_0;
  real_T u_max_0;
  real_T u_min_0;
  real_T x_sp_idx_0;
  real_T x_sp_idx_1;
  real_T x_sp_idx_2;
  int32_T k;
  int32_T m;
  for (k = 0; k < N; k++) {
    x_sp_idx_0 = x_sp[0] - x0[0];
    x_sp_idx_1 = x_sp[1] - x0[1];
    x_sp_idx_2 = x_sp[2] - x0[2];
    for (m = 0; m < 4; m++) {
      u_min_0 = u_min[m];
      u_max_0 = u_max[m];
      u_k_0 = u_sp[m] - ((K[m + 4] * x_sp_idx_1 + K[m] * x_sp_idx_0) + K[m + 8] *
                         x_sp_idx_2);
      if (u_k_0 > u_max_0) {
        u_k_0 = u_max_0;
      } else if (u_k_0 < u_min_0) {
        u_k_0 = u_min_0;
      }

      u_k[m] = u_k_0;
    }

    x_sp_idx_0 = x0[1] * p[10] + p[9];
    x_sp_idx_1 = 1.0 / p[5] * (u_k[0] - x0[1]);
    x_sp_idx_2 = 1.0 / p[6] * (u2_past[k] - x0[2]);
    x0[0] += (((1.0 / (x0[2] * p[8] + 1.0) * p[4] * x0[1] * (u_k[2] * p[7] + 1.0)
                - d) * (1.0 / p[3]) + x_disturb[0] * Bd[0]) + x_disturb1_map *
              Bd[0]) * p[2];
    if ((x_sp_idx_0 <= x_sp_idx_1) || rtIsNaN(x_sp_idx_1)) {
      x_sp_idx_1 = x_sp_idx_0;
    }

    x0[1] += x_sp_idx_1 * p[2];
    x0[2] += x_sp_idx_2 * p[2];
  }
}

/* Function for MATLAB Function: '<S431>/LQR Controller 3states' */
static void Gen2_ref_mldivide_j(const real_T A[4], const real_T B[12], real_T Y
  [12], struct Gen2* inst)
{
  real_T Y_tmp_0;
  real_T a21;
  real_T a22;
  real_T a22_tmp;
  int32_T Y_tmp;
  int32_T k;
  int32_T r1;
  int32_T r2;
  if (fabs(A[1]) > fabs(A[0])) {
    r1 = 1;
    r2 = 0;
  } else {
    r1 = 0;
    r2 = 1;
  }

  a21 = A[r2] / A[r1];
  a22_tmp = A[r1 + 2];
  a22 = A[r2 + 2] - a22_tmp * a21;
  for (k = 0; k < 6; k++) {
    Y_tmp = k << 1;
    Y_tmp_0 = B[Y_tmp + r1];
    Y[Y_tmp + 1] = (B[Y_tmp + r2] - Y_tmp_0 * a21) / a22;
    Y[Y_tmp] = (Y_tmp_0 - Y[Y_tmp + 1] * a22_tmp) / A[r1];
  }
}

/* Function for MATLAB Function: '<S715>/MATLAB Function1' */
static real_T Gen2_ref_maximum_f5(const real_T x[7], struct Gen2* inst)
{
  real_T ex;
  int32_T idx;
  int32_T k;
  boolean_T exitg1;
  if (!rtIsNaN(x[0])) {
    idx = 1;
  } else {
    idx = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k < 8)) {
      if (!rtIsNaN(x[k - 1])) {
        idx = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }

  if (idx == 0) {
    ex = x[0];
  } else {
    ex = x[idx - 1];
    while (idx + 1 <= 7) {
      if (ex < x[idx]) {
        ex = x[idx];
      }

      idx++;
    }
  }

  return ex;
}

/* Model step function */
void Gen2_ref_step(RT_MODEL_Gen2_ref *const Gen2_ref_M, struct Gen2* inst)
{
  struct BlockIO_Gen2_ref *Gen2_ref_B = Gen2_ref_M->blockIO;
  struct D_Work_Gen2_ref *Gen2_ref_DWork = Gen2_ref_M->dwork;
  struct PrevZCSigStates_Gen2_ref *Gen2_ref_PrevZCSigState = Gen2_ref_M->prevZCSigState;
  ExternalOutputs_Gen2_ref *Gen2_ref_Y = (ExternalOutputs_Gen2_ref *)
    Gen2_ref_M->outputs;

  /* local block i/o variables */
  real_T rtb_LookupTableDynamic2;
  real_T rtb_gainschedulingKeng1;
  real_T rtb_kappa0;
  real_T rtb_LookupTableDynamic;
  real_T rtb_LookupTableDynamic1;
  real_T rtb_gainschedulingKeng1_f;
  real_T rtb_CDSet_50;
  real_T rtb_CDSet_100;
  real_T rtb_LookupTableDynamic3;
  real_T rtb_LookupTableDynamic_n;
  real_T rtb_LookupTableDynamic_m;
  real_T rtb_LookupTableDynamic1_b;
  real_T rtb_gainschedulingKspeed;
  real_T rtb_gainschedulingTlam;
  real_T rtb_LookupTableDynamic2_h;
  real_T rtb_LookupTableDynamic_l;
  real_T rtb_LookupTableDynamic1_g;
  real_T rtb_gainschedulingD;
  real_T rtb_gainschedulingx_dist1;
  real_T rtb_gainschedulingKengPOW;
  real_T rtb_gainschedulingKeng;
  real_T rtb_LookupTableDynamic2_f;
  real_T rtb_LookupTableDynamic1_h;
  real_T rtb_LookupTableDynamic_h;
  real_T rtb_LookupTableDynamic_nk;
  real_T rtb_LookupTableDynamic1_o;
  real_T rtb_LookupTableDynamic_i;
  real_T rtb_LookupTableDynamic1_e;
  real_T rtb_LCRScal_Lam_EOT1;
  real_T rtb_LCRScal_Lam_EOT1_i;
  real_T rtb_Surgeprotectiondependingont;
  real_T rtb_Surgeprotectiondependingonb;
  real_T rtb_Lookup7;
  real_T rtb_Lookup6;
  real_T rtb_Lookup5;
  real_T rtb_Lookup4;
  real_T rtb_Lookup3;
  real_T rtb_Lookup2;
  real_T rtb_Lookup1;
  real_T rtb_kp_m;
  real_T u_lambda_past[100];
  real_T P_[36];
  real_T P_2inp_aug_tmp[36];
  real_T Phi_aug[36];
  real_T Phi_aug_0[36];
  real_T Phi_aug_1[36];
  real_T Phi_aug_2[36];
  real_T rtb_TmpSignalConversionAtSFunct[22];
  real_T Phi_obs_tmp_0[18];
  real_T rtb_K_KF_out[18];
  real_T R[16];
  real_T R_0[16];
  real_T rtb_ResettableDelay_br[13];
  real_T rtb_Switch3_je[13];
  real_T rtb_y_map_new[13];
  real_T rtb_y_map_new_n[13];
  real_T H_aug[12];
  real_T K_2inp_aug[12];
  real_T rtb_H_OUT[12];
  real_T rtb_H_OUT_0[12];
  real_T rtb_K_LQR[12];
  real_T rtb_K_LQR_0[12];
  real_T tmp[12];
  real_T rtb_Switch6_n[10];
  real_T B_d[9];
  real_T Phi_obs[9];
  real_T Q[9];
  real_T R_KF[9];
  real_T rtb_Phi_OUT[9];
  real_T rtb_Phi_OUT_0[9];
  real_T rtb_Phi_OUT_1[9];
  real_T rtb_Sum_og[8];
  real_T rtb_Switch_g[8];
  real_T rtb_Switch_dau[7];
  real_T rtb_y_map_new_a[7];
  real_T Hd_obs_0[6];
  real_T rtb_Switch_i5[6];
  real_T rtb_TmpSignalConversionAtDelayI[6];
  real_T rtb_TmpSignalConversionAtSFun_0[6];
  real_T rtb_TmpSignalConversionAtSFun_1[6];
  real_T x_[6];
  real_T rtb_Gain1_eu[5];
  real_T rtb_Gain2_k[5];
  real_T R_2inp[4];
  real_T rtb_Divide3_e[4];
  real_T rtb_Divide3_i0[4];
  real_T rtb_Divide_ab[4];
  real_T rtb_Product_m[4];
  real_T Hd_obs[3];
  real_T Phi_obs_tmp_1[3];
  real_T rtb_Switch1_cl[3];
  real_T rtb_TmpSignalConversionAtSFun_g[3];
  real_T rtb_TmpSignalConversionAtSFun_p[3];
  real_T rtb_err_KF[3];
  real_T rtb_err_cont[3];
  real_T rtb_TmpSignalConversionAtLoo_ht[2];
  real_T rtb_TmpSignalConversionAtLook_d[2];
  real_T rtb_u_sp_KF[2];
  real_T FILT_IN;
  real_T Ts_tmp;
  real_T delta_y;
  real_T delta_y_tmp_tmp;
  real_T err;
  real_T r;
  real_T rtb_Abs;
  real_T rtb_Abs_n;
  real_T rtb_Add2;
  real_T rtb_Add2_h;
  real_T rtb_BusCreator1_ref_P2_FB_CBV;
  real_T rtb_BusCreator1_ref_P2_FF;
  real_T rtb_BusCreator1_ref_P2s_FB_TV;
  real_T rtb_DataTypeConversion15;
  real_T rtb_DiscreteTimeIntegrator_g3;
  real_T rtb_Divide1_f1_tmp;
  real_T rtb_Divide1_fn;
  real_T rtb_Divide1_h4;
  real_T rtb_Divide1_k;
  real_T rtb_Divide2;
  real_T rtb_Divide2_a;
  real_T rtb_Divide2_f;
  real_T rtb_Divide3_a0;
  real_T rtb_Divide3_d;
  real_T rtb_Divide3_ep;
  real_T rtb_Divide3_g;
  real_T rtb_Divide3_k;
  real_T rtb_Divide3_n_tmp;
  real_T rtb_Divide3_p;
  real_T rtb_Divide4_d;
  real_T rtb_Divide4_ia;
  real_T rtb_Divide5_h;
  real_T rtb_Divide6_n;
  real_T rtb_Divide_br;
  real_T rtb_Divide_i1;
  real_T rtb_Divide_kp;
  real_T rtb_Divide_kt;
  real_T rtb_Divide_mr_tmp;
  real_T rtb_Divide_n0;
  real_T rtb_Gain;
  real_T rtb_Gain1_f_tmp;
  real_T rtb_Gain1_fr;
  real_T rtb_Gain1_o;
  real_T rtb_Gain2_ao;
  real_T rtb_Gain2_cm;
  real_T rtb_Gain3;
  real_T rtb_Gain6_b;
  real_T rtb_Gain6_jx;
  real_T rtb_Gain7;
  real_T rtb_Gain_i;
  real_T rtb_Gain_kl;
  real_T rtb_Gain_kp;
  real_T rtb_LogicalOperator1_js_tmp;
  real_T rtb_MassFlowCalc;
  real_T rtb_MinMax1_g;
  real_T rtb_MinMax1_h;
  real_T rtb_MinMax3;
  real_T rtb_MinMax_a;
  real_T rtb_MinMax_mf;
  real_T rtb_MinMax_n;
  real_T rtb_MultiportSwitch;
  real_T rtb_Pa2bar;
  real_T rtb_Pa2bar_k;
  real_T rtb_Pa2bar_o;
  real_T rtb_PactOut;
  real_T rtb_PactOut_o;
  real_T rtb_PactOut_tmp;
  real_T rtb_PrefOut;
  real_T rtb_Product1;
  real_T rtb_Product1_aq;
  real_T rtb_Product1_b;
  real_T rtb_Product1_b4;
  real_T rtb_Product1_bc;
  real_T rtb_Product1_c1_tmp;
  real_T rtb_Product1_e_tmp;
  real_T rtb_Product1_fu;
  real_T rtb_Product1_mqz;
  real_T rtb_Product2;
  real_T rtb_Product3_g;
  real_T rtb_Product4;
  real_T rtb_Product4_d;
  real_T rtb_Product_gj;
  real_T rtb_Product_l0;
  real_T rtb_Product_o;
  real_T rtb_RoundingFunction;
  real_T rtb_Saturation;
  real_T rtb_Saturation1_i;
  real_T rtb_Saturation6;
  real_T rtb_Saturation6_tmp;
  real_T rtb_Saturation_cx;
  real_T rtb_Saturation_e;
  real_T rtb_Saturation_gh;
  real_T rtb_Saturation_o;
  real_T rtb_Sum10;
  real_T rtb_Sum11;
  real_T rtb_Sum1_dh;
  real_T rtb_Sum1_idx_2;
  real_T rtb_Sum1_idx_3;
  real_T rtb_Sum1_jz;
  real_T rtb_Sum1_l;
  real_T rtb_Sum1_lo;
  real_T rtb_Sum2_a1;
  real_T rtb_Sum2_a_tmp;
  real_T rtb_Sum2_kg;
  real_T rtb_Sum3_hx;
  real_T rtb_Sum3_o;
  real_T rtb_Sum4_g;
  real_T rtb_Sum4_ny;
  real_T rtb_Sum5_iu;
  real_T rtb_Sum5_j;
  real_T rtb_Sum6_o_tmp;
  real_T rtb_Sum7_l5;
  real_T rtb_Sum8_m;
  real_T rtb_Sum_c;
  real_T rtb_Sum_e;
  real_T rtb_Sum_gb;
  real_T rtb_Sum_ig;
  real_T rtb_Sum_mf;
  real_T rtb_SumofElements;
  real_T rtb_SumofElements_l;
  real_T rtb_Switch13;
  real_T rtb_Switch1_d2;
  real_T rtb_Switch1_ep;
  real_T rtb_Switch1_k;
  real_T rtb_Switch1_kk;
  real_T rtb_Switch1_lk;
  real_T rtb_Switch1_mm;
  real_T rtb_Switch2_a;
  real_T rtb_Switch2_ba;
  real_T rtb_Switch2_by;
  real_T rtb_Switch2_c4;
  real_T rtb_Switch2_d1;
  real_T rtb_Switch2_ejy_tmp;
  real_T rtb_Switch2_ejy_tmp_0;
  real_T rtb_Switch2_g3;
  real_T rtb_Switch2_gd_idx_0;
  real_T rtb_Switch2_gd_idx_1;
  real_T rtb_Switch2_gd_idx_2;
  real_T rtb_Switch2_gd_idx_3;
  real_T rtb_Switch2_gs;
  real_T rtb_Switch2_h1;
  real_T rtb_Switch2_j0;
  real_T rtb_Switch2_jf;
  real_T rtb_Switch2_jq;
  real_T rtb_Switch2_jw;
  real_T rtb_Switch2_l;
  real_T rtb_Switch2_lu;
  real_T rtb_Switch2_n5;
  real_T rtb_Switch2_oou;
  real_T rtb_Switch4_p;
  real_T rtb_Switch5_iq;
  real_T rtb_Switch5_nn;
  real_T rtb_Switch8;
  real_T rtb_Switch9_k;
  real_T rtb_Switch_bs;
  real_T rtb_Switch_ct_tmp;
  real_T rtb_Switch_czo;
  real_T rtb_Switch_dhr;
  real_T rtb_Switch_dz_tmp;
  real_T rtb_Switch_e;
  real_T rtb_Switch_e3;
  real_T rtb_Switch_ed;
  real_T rtb_Switch_eu;
  real_T rtb_Switch_fi;
  real_T rtb_Switch_iy;
  real_T rtb_Switch_jv;
  real_T rtb_Switch_jz;
  real_T rtb_Switch_kr;
  real_T rtb_Switch_ks;
  real_T rtb_Switch_n;
  real_T rtb_Switch_nb;
  real_T rtb_Switch_on;
  real_T rtb_UkYk1_a4;
  real_T rtb_VariableIntegerDelay;
  real_T rtb_VariableIntegerDelay_b;
  real_T rtb_W2kW_o;
  real_T rtb_bResetHlci_0;
  real_T rtb_bar2Pa6;
  real_T rtb_deltafalllimit_ca;
  real_T rtb_deltafalllimit_h0;
  real_T rtb_dm_e;
  real_T rtb_dm_e_tmp;
  real_T rtb_etaBreakConst;
  real_T rtb_etaVolConst_lt;
  real_T rtb_kW2W;
  real_T rtb_kW2W1_h;
  real_T rtb_mbar2pa_g;
  real_T rtb_mbar2pa_i;
  real_T rtb_p1HP;
  real_T rtb_p1LP;
  real_T rtb_p2HP;
  real_T rtb_p2s;
  real_T rtb_rKK2_k;
  real_T rtb_rSkip_level;
  real_T rtb_up;
  real_T rtb_x_KF_out_idx_0;
  real_T rtb_x_KF_out_idx_1;
  real_T rtb_x_KF_out_idx_2;
  real_T rtb_x_sp_KF_idx_0;
  real_T rtb_x_sp_KF_idx_1;
  real_T rtb_x_sp_KF_idx_2;
  real_T u0;
  real_T u1;
  real_T x;
  real_T y_map_tmp;
  real_T y_map_tmp_0;
  int32_T Phi_aug_tmp;
  int32_T Phi_aug_tmp_0;
  int32_T i;
  int32_T k;
  int32_T rtb_H_OUT_tmp;
  int32_T rtb_K_LQR_tmp;
  real32_T rtb_BusCreator1_h_ui;
  real32_T rtb_TOF2_PT;
  real32_T rtb_rPos_CBV3;
  int16_T Npred;
  int16_T tmp_0;
  uint16_T rtb_DataTypeConversion_l;
  int8_T Phi_obs_tmp[18];
  uint8_T u0_0;
  boolean_T rtb_Act;
  boolean_T rtb_LogicalOperator;
  boolean_T rtb_LogicalOperator12_a;
  boolean_T rtb_LogicalOperator1_a0;
  boolean_T rtb_LogicalOperator1_e;
  boolean_T rtb_LogicalOperator1_i2;
  boolean_T rtb_LogicalOperator1_ix;
  boolean_T rtb_LogicalOperator1_j;
  boolean_T rtb_LogicalOperator1_ja;
  boolean_T rtb_LogicalOperator1_pa;
  boolean_T rtb_LogicalOperator2_dc;
  boolean_T rtb_LogicalOperator2_e;
  boolean_T rtb_LogicalOperator2_fy;
  boolean_T rtb_LogicalOperator2_k_tmp;
  boolean_T rtb_LogicalOperator2_l;
  boolean_T rtb_LogicalOperator2_ov;
  boolean_T rtb_LogicalOperator2_p1;
  boolean_T rtb_LogicalOperator3_aa;
  boolean_T rtb_LogicalOperator3_b;
  boolean_T rtb_LogicalOperator3_fj;
  boolean_T rtb_LogicalOperator3_gq;
  boolean_T rtb_LogicalOperator3_ja;
  boolean_T rtb_LogicalOperator3_k;
  boolean_T rtb_LogicalOperator4_go;
  boolean_T rtb_LogicalOperator4_m5;
  boolean_T rtb_LogicalOperator5;
  boolean_T rtb_LogicalOperator5_g_tmp;
  boolean_T rtb_LogicalOperator5_mv;
  boolean_T rtb_LogicalOperator5_p;
  boolean_T rtb_LogicalOperator_aw;
  boolean_T rtb_LogicalOperator_b;
  boolean_T rtb_LogicalOperator_cn;
  boolean_T rtb_LogicalOperator_f;
  boolean_T rtb_LogicalOperator_hi;
  boolean_T rtb_LogicalOperator_i;
  boolean_T rtb_LogicalOperator_in;
  boolean_T rtb_RelationalOperator1_j;
  boolean_T rtb_RelationalOperator2_j;
  boolean_T rtb_RelationalOperator_a;
  boolean_T rtb_RelationalOperator_l5;
  boolean_T rtb_RelationalOperator_ok;
  boolean_T rtb_Switch2_au;
  boolean_T rtb_Switch2_ij;
  boolean_T rtb_Switch2_jv;
  boolean_T rtb_Switch3_le;
  boolean_T rtb_Switch3_of;
  boolean_T rtb_Switch4_j;
  boolean_T rtb_Switch4_mu;
  boolean_T rtb_TOF_IN;
  boolean_T rtb_bActGasQualImprov;
  boolean_T rtb_bCBV_min;
  boolean_T rtb_bResetBdc;
  boolean_T rtb_bResetHlci;
  boolean_T rtb_bTV_sat;
  boolean_T rtb_bTriger_IT_LJ;
  boolean_T rtb_dbg_HLCi;
  boolean_T rtb_i_reset;
  static const int8_T b[18] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0,
    0, 1 };

  static const real_T c[36] = { 0.0001, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0001,
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0001, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0001,
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0001, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0001 };

  static const int8_T C_aug[18] = { 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
    0, 0, 0 };

  static const int8_T d[18] = { 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0,
    0, 0 };

  static const int8_T b_a[9] = { 1, 0, 0, 0, 1, 0, 0, 0, 1 };

  real_T rtb_Divide_mr_tmp_0;
  real_T rtb_Switch_fy_tmp_tmp;
  boolean_T exitg1;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  Gen2_ref_B->BusInput = inst->IN;

  /* Logic: '<S4>/Logical Operator' incorporates:
   *  Constant: '<S188>/Constant'
   *  RelationalOperator: '<S188>/Compare'
   */
  rtb_LogicalOperator = ((Gen2_ref_B->BusInput.iOpMode == 50) &&
    Gen2_ref_B->BusInput.bGen2_NetP_ena);

  /* S-Function (bur_bus_in): '<Root>/Bus Input3' */
  Gen2_ref_B->BusInput3 = inst->Para;

  /* Switch: '<S427>/Switch5' incorporates:
   *  Delay: '<S427>/Delay'
   *  RelationalOperator: '<S427>/Relational Operator11'
   */
  if (Gen2_ref_DWork->Delay_DSTATE[0] >=
      Gen2_ref_B->BusInput3.LR.rP_LR_Trig_GasStop_HL) {
    rtb_Divide4_d = Gen2_ref_B->BusInput3.LR.rP_LR_Trig_GasStop_HL;
  } else {
    rtb_Divide4_d = Gen2_ref_B->BusInput3.LR.rP_LR_Trig_GasStop;
  }

  /* End of Switch: '<S427>/Switch5' */

  /* RelationalOperator: '<S427>/Relational Operator13' incorporates:
   *  Delay: '<S427>/Delay'
   */
  rtb_LogicalOperator5_mv = (Gen2_ref_DWork->Delay_DSTATE[0] >= rtb_Divide4_d);

  /* Gain: '<S418>/Gain' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion34'
   */
  rtb_Gain = 0.10471975511965977 * Gen2_ref_B->BusInput.rN_Eng_LRskipF;

  /* Logic: '<S4>/Logical Operator8' incorporates:
   *  Constant: '<S189>/Constant'
   *  RelationalOperator: '<S189>/Compare'
   */
  rtb_bResetBdc = ((Gen2_ref_B->BusInput.iOpMode <= 10) ||
                   Gen2_ref_B->BusInput.bResetGlobal);

  /* Logic: '<S4>/Logical Operator5' incorporates:
   *  Constant: '<S187>/Constant'
   *  Logic: '<S4>/Logical Operator1'
   *  Logic: '<S4>/Logical Operator4'
   *  RelationalOperator: '<S187>/Compare'
   */
  rtb_bResetHlci = (rtb_bResetBdc || ((Gen2_ref_B->BusInput.iOpMode != 60) ||
    (!Gen2_ref_B->BusInput.bGen2_island_ena)));

  /* Outputs for Atomic SubSystem: '<S418>/2nd Order Filter' */
  Gen2_ref_undOrderFilter3(rtb_Gain,
    Gen2_ref_B->BusInput3.SpeedCtrl.r2ndOrdFiltOmega_N_Prot,
    Gen2_ref_B->BusInput3.SpeedCtrl.r2ndOrdFiltD_N_Prot, rtb_bResetHlci,
    &Gen2_ref_B->undOrderFilter_j, &Gen2_ref_DWork->undOrderFilter_j, inst);

  /* End of Outputs for SubSystem: '<S418>/2nd Order Filter' */

  /* Outputs for Atomic SubSystem: '<S418>/Filter' */
  /* RelationalOperator: '<S439>/Relational Operator' incorporates:
   *  Constant: '<S439>/Constant'
   */
  rtb_bCBV_min = (Gen2_ref_B->BusInput3.SpeedCtrl.rTi_Prot > 0.0);

  /* Logic: '<S439>/Logical Operator' incorporates:
   *  Logic: '<S439>/Logical Operator1'
   */
  rtb_LogicalOperator_in = (rtb_bResetHlci || (!rtb_bCBV_min));

  /* DiscreteIntegrator: '<S439>/Discrete-Time Integrator' */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_f != 0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_eh = rtb_Gain;
  }

  if (rtb_LogicalOperator_in || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_g
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_eh = rtb_Gain;
  }

  /* Abs: '<S442>/Abs' */
  FILT_IN = fabs(Gen2_ref_B->BusInput3.SpeedCtrl.rTi_Prot);

  /* Switch: '<S442>/Switch' incorporates:
   *  Constant: '<S442>/Constant2'
   *  RelationalOperator: '<S442>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= FILT_IN) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.SpeedCtrl.rTi_Prot;
  }

  /* End of Switch: '<S442>/Switch' */

  /* Product: '<S439>/Divide4' incorporates:
   *  DiscreteIntegrator: '<S439>/Discrete-Time Integrator'
   *  Sum: '<S439>/Sum4'
   */
  rtb_Divide4_ia = (rtb_Gain - Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_eh) /
    rtb_bResetHlci_0;

  /* Switch: '<S439>/Switch' incorporates:
   *  DiscreteIntegrator: '<S439>/Discrete-Time Integrator'
   */
  if (rtb_bCBV_min) {
    rtb_Switch_ed = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_eh;
  } else {
    rtb_Switch_ed = rtb_Gain;
  }

  /* End of Switch: '<S439>/Switch' */

  /* Update for DiscreteIntegrator: '<S439>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_f = 0U;
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_eh += 0.01 * rtb_Divide4_ia;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_g = (int8_T)
    rtb_LogicalOperator_in;

  /* End of Outputs for SubSystem: '<S418>/Filter' */

  /* Switch: '<S418>/Switch' incorporates:
   *  Switch: '<S418>/Switch1'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.b2ndOrdFilt_N_Prot) {
    rtb_Switch_eu = Gen2_ref_B->undOrderFilter_j.Switch;
    rtb_Switch1_mm = Gen2_ref_B->undOrderFilter_j.Switch1;
  } else {
    rtb_Switch_eu = rtb_Switch_ed;

    /* Outputs for Atomic SubSystem: '<S418>/Filter' */
    /* Switch: '<S439>/Switch1' incorporates:
     *  Constant: '<S439>/Constant'
     */
    if (rtb_LogicalOperator_in) {
      rtb_Switch1_mm = 0.0;
    } else {
      rtb_Switch1_mm = rtb_Divide4_ia;
    }

    /* End of Switch: '<S439>/Switch1' */
    /* End of Outputs for SubSystem: '<S418>/Filter' */
  }

  /* End of Switch: '<S418>/Switch' */

  /* Gain: '<S418>/Gain1' incorporates:
   *  Product: '<S418>/Divide'
   */
  rtb_Gain1_fr = -(rtb_Switch_eu * rtb_Switch1_mm *
                   Gen2_ref_B->BusInput3.eng.rJ_Eng);

  /* Abs: '<S508>/Abs' incorporates:
   *  Abs: '<S605>/Abs'
   *  Abs: '<S858>/Abs'
   */
  rtb_Product1_e_tmp = fabs(Gen2_ref_B->BusInput3.eng.rP_Nom);

  /* Switch: '<S508>/Switch' incorporates:
   *  Abs: '<S508>/Abs'
   *  Constant: '<S508>/Constant2'
   *  RelationalOperator: '<S508>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Product1_e_tmp) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rP_Nom;
  }

  /* End of Switch: '<S508>/Switch' */

  /* Gain: '<S427>/Gain6' incorporates:
   *  Gain: '<S427>/Gain2'
   *  Product: '<S427>/Divide3'
   */
  rtb_Saturation = -(0.001 * rtb_Gain1_fr / rtb_bResetHlci_0);

  /* Saturate: '<S427>/Saturation' */
  if (rtb_Saturation > 1000.0) {
    rtb_Saturation = 1000.0;
  } else if (rtb_Saturation < 0.0) {
    rtb_Saturation = 0.0;
  }

  /* End of Saturate: '<S427>/Saturation' */

  /* RelationalOperator: '<S427>/Relational Operator8' */
  rtb_dbg_HLCi = (rtb_Saturation > rtb_Divide4_d);

  /* DataTypeConversion: '<S4>/Data Type Conversion15' */
  rtb_DataTypeConversion15 = Gen2_ref_B->BusInput.rN_Eng;

  /* Outputs for Atomic SubSystem: '<S201>/Volt_filt' */
  /* DataTypeConversion: '<S4>/Data Type Conversion17' */
  Gen2_ref_N_TC_HP_filt((real_T)Gen2_ref_B->BusInput.rU_Gen_Norm,
                        Gen2_ref_B->BusInput3.inFilt.rTiF_V, rtb_bResetBdc,
                        &Gen2_ref_B->Volt_filt, &Gen2_ref_DWork->Volt_filt, inst);

  /* End of Outputs for SubSystem: '<S201>/Volt_filt' */

  /* Gain: '<S4>/Gain2' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion13'
   */
  rtb_Gain2_ao = 1000.0 * Gen2_ref_B->BusInput.rP_Act;

  /* Gain: '<S4>/kW2W' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion19'
   */
  rtb_kW2W = 1000.0 * Gen2_ref_B->BusInput.rP_Set;

  /* Gain: '<S4>/bar2Pa3' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion5'
   */
  rtb_p2s = 100000.0 * Gen2_ref_B->BusInput.tPr.rp2s;

  /* Outputs for Atomic SubSystem: '<S205>/p2s_filt' */
  Gen2_ref_N_TC_HP_filt(rtb_p2s, Gen2_ref_B->BusInput3.inFilt.rTiF_Pr,
                        rtb_bResetBdc, &Gen2_ref_B->p2s_filt,
                        &Gen2_ref_DWork->p2s_filt, inst);

  /* End of Outputs for SubSystem: '<S205>/p2s_filt' */

  /* SignalConversion generated from: '<S425>/Delay' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion16'
   */
  rtb_TmpSignalConversionAtDelayI[0] = rtb_DataTypeConversion15;
  rtb_TmpSignalConversionAtDelayI[1] = Gen2_ref_B->BusInput.rN_Set;
  rtb_TmpSignalConversionAtDelayI[2] = Gen2_ref_B->Volt_filt.Switch;
  rtb_TmpSignalConversionAtDelayI[3] = rtb_Gain2_ao;
  rtb_TmpSignalConversionAtDelayI[4] = rtb_kW2W;

  /* Switch: '<S8>/Switch7' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bUseFilteredFeedback) {
    /* SignalConversion generated from: '<S425>/Delay' */
    rtb_TmpSignalConversionAtDelayI[5] = Gen2_ref_B->p2s_filt.Switch;
  } else {
    /* SignalConversion generated from: '<S425>/Delay' */
    rtb_TmpSignalConversionAtDelayI[5] = rtb_p2s;
  }

  /* End of Switch: '<S8>/Switch7' */

  /* Delay: '<S425>/Delay' incorporates:
   *  Switch: '<S425>/Switch'
   */
  Gen2_ref_DWork->icLoad = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE == 1) !=
    (int32_T)rtb_bResetHlci) && (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE != 3))
    || rtb_bResetHlci || Gen2_ref_DWork->icLoad);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE = rtb_bResetHlci;
  for (i = 0; i < 6; i++) {
    rtb_Divide4_d = rtb_TmpSignalConversionAtDelayI[i];
    if (Gen2_ref_DWork->icLoad) {
      Gen2_ref_DWork->Delay_DSTATE_o[i] = rtb_Divide4_d;
    }

    /* Switch: '<S425>/Switch' */
    if (Gen2_ref_B->BusInput.tLvrt.bLvrtFlg) {
      rtb_Divide4_d = Gen2_ref_DWork->Delay_DSTATE_o[i];
    }

    rtb_TmpSignalConversionAtDelayI[i] = rtb_Divide4_d;
  }

  /* Outputs for Atomic SubSystem: '<S425>/TOF' */
  /* Constant: '<S425>/Constant3' */
  Gen2_ref_TOF(Gen2_ref_B->BusInput.tLvrt.bLvrtFlg, 1.0, &Gen2_ref_B->TOF_h,
               &Gen2_ref_DWork->TOF_h, inst);

  /* End of Outputs for SubSystem: '<S425>/TOF' */

  /* Logic: '<S425>/Logical Operator2' incorporates:
   *  Logic: '<S26>/Logical Operator2'
   *  Logic: '<S45>/Logical Operator2'
   */
  rtb_LogicalOperator_b = !Gen2_ref_B->BusInput.tLvrt.bLvrtFlg;

  /* Outputs for Atomic SubSystem: '<S425>/Filter' */
  /* Logic: '<S485>/Logical Operator' incorporates:
   *  Logic: '<S425>/Logical Operator1'
   *  Logic: '<S425>/Logical Operator2'
   *  Logic: '<S425>/Logical Operator3'
   */
  rtb_LogicalOperator_in = (((!Gen2_ref_B->TOF_h.LogicalOperator1) &&
    rtb_LogicalOperator_b) || rtb_bResetHlci ||
    Gen2_ref_B->BusInput3.SpeedCtrl.bReset_LVRT_inputFilter);

  /* DiscreteIntegrator: '<S485>/Discrete-Time Integrator' */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_p != 0) {
    for (i = 0; i < 6; i++) {
      Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gl[i] =
        rtb_TmpSignalConversionAtDelayI[i];
    }
  }

  /* Update for DiscreteIntegrator: '<S485>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_p = 0U;
  for (i = 0; i < 6; i++) {
    /* Switch: '<S485>/Switch' */
    rtb_Divide4_d = rtb_TmpSignalConversionAtDelayI[i];

    /* DiscreteIntegrator: '<S485>/Discrete-Time Integrator' */
    if (rtb_LogicalOperator_in ||
        (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_cs != 0)) {
      Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gl[i] = rtb_Divide4_d;
    }

    /* Switch: '<S485>/Switch' incorporates:
     *  DiscreteIntegrator: '<S485>/Discrete-Time Integrator'
     */
    rtb_Switch_i5[i] = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gl[i];

    /* Update for DiscreteIntegrator: '<S485>/Discrete-Time Integrator' incorporates:
     *  Product: '<S485>/Divide4'
     *  Sum: '<S485>/Sum4'
     */
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gl[i] += (rtb_Divide4_d -
      Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gl[i]) / 0.1 * 0.01;
  }

  /* Update for DiscreteIntegrator: '<S485>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_cs = (int8_T)
    rtb_LogicalOperator_in;

  /* End of Outputs for SubSystem: '<S425>/Filter' */

  /* Switch: '<S424>/Switch' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bLSLdeactNref) {
    rtb_Switch_ks = Gen2_ref_B->BusInput3.eng.rN_Nom;
  } else {
    rtb_Switch_ks = rtb_Switch_i5[1];
  }

  /* End of Switch: '<S424>/Switch' */

  /* Switch: '<S509>/Switch' incorporates:
   *  Abs: '<S509>/Abs'
   *  Constant: '<S509>/Constant2'
   *  RelationalOperator: '<S509>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Switch_ks)) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = rtb_Switch_ks;
  }

  /* End of Switch: '<S509>/Switch' */

  /* Product: '<S427>/Divide4' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion34'
   */
  rtb_Divide4_d = Gen2_ref_B->BusInput.rN_Eng_LRskipF / rtb_bResetHlci_0;

  /* RelationalOperator: '<S427>/Relational Operator3' */
  rtb_RelationalOperator2_j = (rtb_Divide4_d >
    Gen2_ref_B->BusInput3.LR.rN_LR_Trig_GasStop);

  /* Logic: '<S427>/Logical Operator11' incorporates:
   *  Logic: '<S427>/Logical Operator25'
   *  UnitDelay: '<S427>/Unit Delay4'
   */
  rtb_LogicalOperator_in = ((!Gen2_ref_DWork->TOF_state) &&
    rtb_LogicalOperator5_mv && rtb_dbg_HLCi &&
    Gen2_ref_B->BusInput3.LR.bP_LoadReject_Active && rtb_RelationalOperator2_j);

  /* Sum: '<S427>/Sum6' incorporates:
   *  Constant: '<S427>/Constant7'
   *  Gain: '<S427>/Gain3'
   */
  rtb_Divide4_ia = 0.001 * Gen2_ref_B->BusInput3.LR.rTi_LR_GasStop + 0.01;

  /* Outputs for Atomic SubSystem: '<S427>/TOF1' */
  Gen2_ref_TOF(rtb_LogicalOperator_in, rtb_Divide4_ia, &Gen2_ref_B->TOF1_o,
               &Gen2_ref_DWork->TOF1_o, inst);

  /* End of Outputs for SubSystem: '<S427>/TOF1' */

  /* Outputs for Atomic SubSystem: '<S427>/TP' */
  Gen2_ref_TP(rtb_LogicalOperator_in, rtb_Divide4_ia, &Gen2_ref_B->TP_p,
              &Gen2_ref_DWork->TP_p, inst);

  /* End of Outputs for SubSystem: '<S427>/TP' */

  /* Switch: '<S427>/Switch1' */
  if (Gen2_ref_B->BusInput3.LR.bTiTOF_GasSTop) {
    rtb_TOF_IN = Gen2_ref_B->TOF1_o.LogicalOperator1;
  } else {
    rtb_TOF_IN = Gen2_ref_B->TP_p.LogicalOperator1;
  }

  /* End of Switch: '<S427>/Switch1' */

  /* Switch: '<Root>/GasStop1' */
  rtb_dbg_HLCi = ((!rtb_LogicalOperator) && rtb_TOF_IN);

  /* Outputs for Atomic SubSystem: '<S8>/BDC_Trajectory' */
  /* Gain: '<S345>/Gain8' incorporates:
   *  Gain: '<S417>/Gain8'
   *  Gain: '<S760>/Gain8'
   */
  rtb_Switch_ct_tmp = 100000.0 * Gen2_ref_B->BusInput3.traj.rPr_p2s_Sr_Man;

  /* Product: '<S413>/delta rise limit' incorporates:
   *  Gain: '<S345>/Gain8'
   *  Product: '<S434>/delta rise limit'
   *  Product: '<S795>/delta rise limit'
   *  SampleTimeMath: '<S413>/sample time'
   *
   * About '<S413>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Divide_mr_tmp_0 = rtb_Switch_ct_tmp * 0.01;

  /* End of Outputs for SubSystem: '<S8>/BDC_Trajectory' */
  rtb_Divide_kp = rtb_Divide_mr_tmp_0;

  /* Gain: '<S4>/bar2Pa6' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion27'
   */
  rtb_bar2Pa6 = 100000.0 * Gen2_ref_B->BusInput.rPr_p2sMan;

  /* Logic: '<S4>/Logical Operator3' incorporates:
   *  Logic: '<S4>/Logical Operator2'
   */
  rtb_LogicalOperator_in = ((!rtb_LogicalOperator) || rtb_bResetBdc);

  /* DiscreteIntegrator: '<S345>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator_in || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRese
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE = 1.0;
  }

  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE = 0.0;
  }

  /* Logic: '<S345>/Logical Operator' incorporates:
   *  Constant: '<S345>/Constant2'
   *  DiscreteIntegrator: '<S345>/Discrete-Time Integrator'
   *  RelationalOperator: '<S345>/Relational Operator'
   */
  rtb_LogicalOperator_cn = ((0.99 <=
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE) || rtb_LogicalOperator_in);

  /* Delay: '<S413>/Delay' */
  Gen2_ref_DWork->icLoad_n = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_k == 1)
    != (int32_T)rtb_LogicalOperator_cn) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_k != 3)) || rtb_LogicalOperator_cn
    || Gen2_ref_DWork->icLoad_n);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_k = rtb_LogicalOperator_cn;
  if (Gen2_ref_DWork->icLoad_n) {
    Gen2_ref_DWork->Delay_DSTATE_n = rtb_bar2Pa6;
  }

  /* Sum: '<S413>/Difference Inputs1' incorporates:
   *  Delay: '<S413>/Delay'
   *  Switch: '<S413>/etaVolConst'
   */
  rtb_Divide4_ia = rtb_bar2Pa6 - Gen2_ref_DWork->Delay_DSTATE_n;

  /* Switch: '<S416>/Switch2' incorporates:
   *  Product: '<S413>/delta rise limit'
   *  RelationalOperator: '<S416>/LowerRelop1'
   */
  if (!(rtb_Divide4_ia > rtb_Divide_mr_tmp_0)) {
    /* Product: '<S413>/delta fall limit' incorporates:
     *  Gain: '<S345>/Gain15'
     *  Gain: '<S345>/Gain8'
     *  SampleTimeMath: '<S413>/sample time'
     *
     * About '<S413>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch_ed = -rtb_Switch_ct_tmp * 0.01;

    /* Switch: '<S416>/Switch' incorporates:
     *  RelationalOperator: '<S416>/UpperRelop'
     */
    if (rtb_Divide4_ia < rtb_Switch_ed) {
      rtb_Divide_kp = rtb_Switch_ed;
    } else {
      rtb_Divide_kp = rtb_Divide4_ia;
    }

    /* End of Switch: '<S416>/Switch' */
  }

  /* End of Switch: '<S416>/Switch2' */

  /* Sum: '<S413>/Difference Inputs2' incorporates:
   *  Delay: '<S413>/Delay'
   */
  rtb_Divide4_ia = rtb_Divide_kp + Gen2_ref_DWork->Delay_DSTATE_n;

  /* Outputs for Atomic SubSystem: '<S345>/p2sfilt' */
  Gen2_ref_N_TC_HP_filt(rtb_Divide4_ia,
                        Gen2_ref_B->BusInput3.traj.rTiF_Pr_p2s_Man,
                        rtb_LogicalOperator_cn, &Gen2_ref_B->p2sfilt,
                        &Gen2_ref_DWork->p2sfilt, inst);

  /* End of Outputs for SubSystem: '<S345>/p2sfilt' */

  /* Gain: '<S875>/kW2W1' incorporates:
   *  Gain: '<S343>/Pa2bar2'
   *  Gain: '<S344>/kW2W1'
   *  Gain: '<S586>/Gain1'
   *  Gain: '<S639>/kW2W'
   *  Gain: '<S761>/kW2W'
   *  Switch: '<S761>/Switch2'
   */
  rtb_Product1_aq = 1000.0 * Gen2_ref_B->BusInput3.eng.rP_Nom;

  /* Product: '<S881>/delta rise limit' incorporates:
   *  Gain: '<S875>/kW2W1'
   *  Product: '<S875>/Divide1'
   *  SampleTimeMath: '<S881>/sample time'
   *
   * About '<S881>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Divide2_a = rtb_Product1_aq *
    Gen2_ref_B->BusInput3.traj.rP_Ramp_IncGrad_Norm * 0.01;

  /* Product: '<S875>/Product' incorporates:
   *  Gain: '<S875>/kW2W1'
   */
  rtb_Product_gj = rtb_Product1_aq * Gen2_ref_B->BusInput3.eng.rP_Start_Norm;

  /* Outputs for Atomic SubSystem: '<S194>/Pel_filt' */
  Gen2_ref_N_TC_HP_filt(rtb_Gain2_ao, Gen2_ref_B->BusInput3.inFilt.rTiF_P,
                        rtb_bResetBdc, &Gen2_ref_B->Pel_filt,
                        &Gen2_ref_DWork->Pel_filt, inst);

  /* End of Outputs for SubSystem: '<S194>/Pel_filt' */

  /* MATLAB Function: '<S874>/MATLAB Function' */
  if (!Gen2_ref_B->BusInput.tLvrt.bLvrtFlg) {
    rtb_PactOut = Gen2_ref_B->Pel_filt.Switch;
    rtb_PrefOut = rtb_kW2W;
    Gen2_ref_DWork->LVRTFlgRise = false;
  } else if (Gen2_ref_B->BusInput.tLvrt.bLvrtFlg &&
             (!Gen2_ref_DWork->LVRTFlgRise)) {
    Gen2_ref_DWork->PFix = Gen2_ref_B->Pel_filt.Switch;
    rtb_PactOut = Gen2_ref_DWork->PFix;
    rtb_PrefOut = Gen2_ref_DWork->PFix;
    Gen2_ref_DWork->LVRTFlgRise = true;
  } else {
    rtb_PactOut = Gen2_ref_DWork->PFix;
    rtb_PrefOut = Gen2_ref_DWork->PFix;
  }

  /* End of MATLAB Function: '<S874>/MATLAB Function' */

  /* Switch: '<S881>/etaVolConst' incorporates:
   *  Constant: '<S875>/ tde2'
   *  Gain: '<S875>/kW2W1'
   *  RelationalOperator: '<S878>/LowerRelop1'
   *  RelationalOperator: '<S878>/UpperRelop'
   *  Switch: '<S878>/Switch'
   *  Switch: '<S878>/Switch2'
   */
  if (Gen2_ref_B->BusInput.bResetTraj) {
    rtb_PactOut = rtb_Product_gj;
  } else {
    if (rtb_PrefOut > rtb_Product1_aq) {
      /* Switch: '<S878>/Switch2' incorporates:
       *  Gain: '<S875>/kW2W1'
       */
      rtb_PrefOut = rtb_Product1_aq;
    } else if (rtb_PrefOut < 1.0) {
      /* Switch: '<S878>/Switch' incorporates:
       *  Constant: '<S875>/ tde2'
       *  Switch: '<S878>/Switch2'
       */
      rtb_PrefOut = 1.0;
    }

    /* Switch: '<S880>/Switch2' incorporates:
     *  Constant: '<S875>/ tde2'
     *  Gain: '<S875>/kW2W1'
     *  RelationalOperator: '<S878>/UpperRelop'
     *  RelationalOperator: '<S880>/LowerRelop1'
     *  RelationalOperator: '<S880>/UpperRelop'
     *  Switch: '<S878>/Switch'
     *  Switch: '<S878>/Switch2'
     *  Switch: '<S880>/Switch'
     */
    if (rtb_PactOut > rtb_Product1_aq) {
      rtb_PactOut = rtb_Product1_aq;
    } else if (rtb_PactOut < rtb_Product_gj) {
      /* Switch: '<S880>/Switch' */
      rtb_PactOut = rtb_Product_gj;
    }

    /* End of Switch: '<S880>/Switch2' */

    /* Sum: '<S875>/Sum10' incorporates:
     *  Gain: '<S875>/kW2W1'
     *  Product: '<S875>/Divide5'
     */
    rtb_PactOut += Gen2_ref_B->BusInput3.traj.rP_Diff_Max_Norm * rtb_Product1_aq;

    /* Switch: '<S879>/Switch2' incorporates:
     *  RelationalOperator: '<S879>/LowerRelop1'
     */
    if (!(rtb_PrefOut > rtb_PactOut)) {
      /* Switch: '<S879>/Switch' incorporates:
       *  Constant: '<S875>/ tde3'
       *  RelationalOperator: '<S879>/UpperRelop'
       */
      if (rtb_PrefOut < 1.0) {
        rtb_PactOut = 1.0;
      } else {
        rtb_PactOut = rtb_PrefOut;
      }

      /* End of Switch: '<S879>/Switch' */
    }

    /* End of Switch: '<S879>/Switch2' */
  }

  /* End of Switch: '<S881>/etaVolConst' */

  /* Delay: '<S881>/Delay' */
  Gen2_ref_DWork->icLoad_m = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_b == 1)
    != (int32_T)Gen2_ref_B->BusInput.bResetTraj) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_b != 3)) ||
    Gen2_ref_B->BusInput.bResetTraj || Gen2_ref_DWork->icLoad_m);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_b = Gen2_ref_B->BusInput.bResetTraj;
  if (Gen2_ref_DWork->icLoad_m) {
    Gen2_ref_DWork->Delay_DSTATE_oh = rtb_Product_gj;
  }

  /* Sum: '<S881>/Difference Inputs1' incorporates:
   *  Delay: '<S881>/Delay'
   */
  rtb_PactOut -= Gen2_ref_DWork->Delay_DSTATE_oh;

  /* Switch: '<S884>/Switch2' incorporates:
   *  RelationalOperator: '<S884>/LowerRelop1'
   */
  if (!(rtb_PactOut > rtb_Divide2_a)) {
    /* Product: '<S881>/delta fall limit' incorporates:
     *  Abs: '<S875>/Abs2'
     *  Gain: '<S875>/Gain2'
     *  Gain: '<S875>/kW2W1'
     *  Product: '<S875>/Divide2'
     *  SampleTimeMath: '<S881>/sample time'
     *
     * About '<S881>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch_ed = -fabs(rtb_Product1_aq *
                          Gen2_ref_B->BusInput3.traj.rP_Ramp_DecGrad_Norm) *
      0.01;

    /* Switch: '<S884>/Switch' incorporates:
     *  RelationalOperator: '<S884>/UpperRelop'
     */
    if (rtb_PactOut < rtb_Switch_ed) {
      rtb_Divide2_a = rtb_Switch_ed;
    } else {
      rtb_Divide2_a = rtb_PactOut;
    }

    /* End of Switch: '<S884>/Switch' */
  }

  /* End of Switch: '<S884>/Switch2' */

  /* Sum: '<S881>/Difference Inputs2' incorporates:
   *  Delay: '<S881>/Delay'
   */
  rtb_Switch_ed = rtb_Divide2_a + Gen2_ref_DWork->Delay_DSTATE_oh;

  /* Outputs for Atomic SubSystem: '<S875>/Pd_filt' */
  Gen2_ref_Pd_filt(rtb_Switch_ed, Gen2_ref_B->BusInput3.traj.rTiFpowtraj,
                   rtb_Product_gj, Gen2_ref_B->BusInput.bResetTraj,
                   &Gen2_ref_B->Pd_filt_p, &Gen2_ref_DWork->Pd_filt_p, inst);

  /* End of Outputs for SubSystem: '<S875>/Pd_filt' */

  /* Gain: '<S344>/kW2W1' */
  rtb_kW2W1_h = rtb_Product1_aq;

  /* Product: '<S404>/delta rise limit' incorporates:
   *  Product: '<S344>/Divide1'
   *  SampleTimeMath: '<S404>/sample time'
   *
   * About '<S404>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Divide2_a = rtb_kW2W1_h * Gen2_ref_B->BusInput3.traj.rP_Ramp_IncGrad_Norm *
    0.01;

  /* Product: '<S344>/Product' */
  rtb_PactOut = rtb_kW2W1_h * Gen2_ref_B->BusInput3.eng.rP_Start_Norm;

  /* Logic: '<Root>/Logical Operator1' incorporates:
   *  Logic: '<Root>/Logical Operator2'
   */
  rtb_LogicalOperator1_e = (Gen2_ref_B->BusInput.tLvrt.bLvrtFlg &&
    (!rtb_LogicalOperator_in));

  /* MATLAB Function: '<S339>/MATLAB Function' */
  if (!rtb_LogicalOperator1_e) {
    rtb_PactOut_o = Gen2_ref_B->Pel_filt.Switch;
    rtb_Product_gj = rtb_kW2W;
    Gen2_ref_DWork->LVRTFlgRise_e = false;
  } else if (!Gen2_ref_DWork->LVRTFlgRise_e) {
    Gen2_ref_DWork->PFix_g = Gen2_ref_B->Pel_filt.Switch;
    rtb_PactOut_o = Gen2_ref_DWork->PFix_g;
    rtb_Product_gj = Gen2_ref_DWork->PFix_g;
    Gen2_ref_DWork->LVRTFlgRise_e = true;
  } else {
    rtb_PactOut_o = Gen2_ref_DWork->PFix_g;
    rtb_Product_gj = Gen2_ref_DWork->PFix_g;
  }

  /* End of MATLAB Function: '<S339>/MATLAB Function' */

  /* Switch: '<S397>/Switch2' incorporates:
   *  Constant: '<S344>/ tde2'
   *  RelationalOperator: '<S397>/LowerRelop1'
   *  RelationalOperator: '<S397>/UpperRelop'
   *  Switch: '<S397>/Switch'
   */
  if (rtb_Product_gj > rtb_kW2W1_h) {
    rtb_PrefOut = rtb_kW2W1_h;
  } else if (rtb_Product_gj < 1.0) {
    /* Switch: '<S397>/Switch' incorporates:
     *  Constant: '<S344>/ tde2'
     */
    rtb_PrefOut = 1.0;
  } else {
    rtb_PrefOut = rtb_Product_gj;
  }

  /* End of Switch: '<S397>/Switch2' */

  /* Switch: '<S404>/etaVolConst' incorporates:
   *  RelationalOperator: '<S399>/LowerRelop1'
   *  RelationalOperator: '<S399>/UpperRelop'
   *  Switch: '<S399>/Switch'
   *  Switch: '<S399>/Switch2'
   */
  if (rtb_LogicalOperator_in) {
    rtb_Product_gj = rtb_PactOut;
  } else {
    if (rtb_PactOut_o > rtb_kW2W1_h) {
      /* Switch: '<S399>/Switch2' */
      rtb_Divide_kp = rtb_kW2W1_h;
    } else if (rtb_PactOut_o < rtb_PactOut) {
      /* Switch: '<S399>/Switch' incorporates:
       *  Switch: '<S399>/Switch2'
       */
      rtb_Divide_kp = rtb_PactOut;
    } else {
      /* Switch: '<S399>/Switch2' incorporates:
       *  Switch: '<S399>/Switch'
       */
      rtb_Divide_kp = rtb_PactOut_o;
    }

    /* Sum: '<S344>/Sum10' incorporates:
     *  Product: '<S344>/Divide5'
     *  RelationalOperator: '<S399>/UpperRelop'
     *  Switch: '<S399>/Switch'
     *  Switch: '<S399>/Switch2'
     */
    rtb_Product_gj = Gen2_ref_B->BusInput3.traj.rP_Diff_Max_Norm * rtb_kW2W1_h +
      rtb_Divide_kp;

    /* Switch: '<S398>/Switch2' incorporates:
     *  RelationalOperator: '<S398>/LowerRelop1'
     */
    if (!(rtb_PrefOut > rtb_Product_gj)) {
      /* Switch: '<S398>/Switch' incorporates:
       *  Constant: '<S344>/ tde3'
       *  RelationalOperator: '<S398>/UpperRelop'
       */
      if (rtb_PrefOut < 1.0) {
        rtb_Product_gj = 1.0;
      } else {
        rtb_Product_gj = rtb_PrefOut;
      }

      /* End of Switch: '<S398>/Switch' */
    }

    /* End of Switch: '<S398>/Switch2' */
  }

  /* End of Switch: '<S404>/etaVolConst' */

  /* Delay: '<S404>/Delay' */
  Gen2_ref_DWork->icLoad_k = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_n == 1)
    != (int32_T)rtb_LogicalOperator_in) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_n != 3)) || rtb_LogicalOperator_in
    || Gen2_ref_DWork->icLoad_k);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_n = rtb_LogicalOperator_in;
  if (Gen2_ref_DWork->icLoad_k) {
    Gen2_ref_DWork->Delay_DSTATE_g = rtb_PactOut;
  }

  /* Sum: '<S404>/Difference Inputs1' incorporates:
   *  Delay: '<S404>/Delay'
   */
  rtb_Product_gj -= Gen2_ref_DWork->Delay_DSTATE_g;

  /* Switch: '<S411>/Switch2' incorporates:
   *  RelationalOperator: '<S411>/LowerRelop1'
   */
  if (!(rtb_Product_gj > rtb_Divide2_a)) {
    /* Product: '<S404>/delta fall limit' incorporates:
     *  Abs: '<S344>/Abs2'
     *  Gain: '<S344>/Gain2'
     *  Product: '<S344>/Divide2'
     *  SampleTimeMath: '<S404>/sample time'
     *
     * About '<S404>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_deltafalllimit_ca = -fabs(rtb_kW2W1_h *
      Gen2_ref_B->BusInput3.traj.rP_Ramp_DecGrad_Norm) * 0.01;

    /* Switch: '<S411>/Switch' incorporates:
     *  RelationalOperator: '<S411>/UpperRelop'
     */
    if (rtb_Product_gj < rtb_deltafalllimit_ca) {
      rtb_Divide2_a = rtb_deltafalllimit_ca;
    } else {
      rtb_Divide2_a = rtb_Product_gj;
    }

    /* End of Switch: '<S411>/Switch' */
  }

  /* End of Switch: '<S411>/Switch2' */

  /* Sum: '<S404>/Difference Inputs2' incorporates:
   *  Delay: '<S404>/Delay'
   */
  rtb_Product_gj = rtb_Divide2_a + Gen2_ref_DWork->Delay_DSTATE_g;

  /* Outputs for Atomic SubSystem: '<S344>/Pd_filt' */
  Gen2_ref_Pd_filt(rtb_Product_gj, Gen2_ref_B->BusInput3.traj.rTiFpowtraj,
                   rtb_PactOut, rtb_LogicalOperator_in, &Gen2_ref_B->Pd_filt,
                   &Gen2_ref_DWork->Pd_filt, inst);

  /* End of Outputs for SubSystem: '<S344>/Pd_filt' */

  /* Gain: '<S344>/kW2W2' */
  rtb_PactOut = 1000.0 * rtb_kW2W1_h;

  /* Gain: '<S344>/kW2W3' */
  rtb_Divide2_a = 0.1 * rtb_PactOut;

  /* Outputs for Atomic SubSystem: '<S344>/WO1' */
  Gen2_ref_Filter1(rtb_PrefOut, Gen2_ref_B->BusInput3.traj.rTi_FSM_WO_1,
                   rtb_LogicalOperator_in, &Gen2_ref_B->WO1,
                   &Gen2_ref_DWork->WO1, inst);

  /* End of Outputs for SubSystem: '<S344>/WO1' */

  /* Outputs for Atomic SubSystem: '<S344>/WO2' */
  Gen2_ref_Filter3(Gen2_ref_B->WO1.Switch1,
                   Gen2_ref_B->BusInput3.traj.rTi_FSM_WO_2, Gen2_ref_ConstB.tde1,
                   rtb_LogicalOperator_in, &Gen2_ref_B->WO2,
                   &Gen2_ref_DWork->WO2, inst);

  /* End of Outputs for SubSystem: '<S344>/WO2' */

  /* Product: '<S344>/Divide3' */
  rtb_PrefOut = Gen2_ref_B->BusInput3.traj.rK_FSM_WO * Gen2_ref_B->WO2.Switch;

  /* Switch: '<S400>/Switch2' incorporates:
   *  RelationalOperator: '<S400>/LowerRelop1'
   */
  if (rtb_PrefOut > rtb_Divide2_a) {
    rtb_Switch2_g3 = rtb_Divide2_a;
  } else {
    /* Gain: '<S344>/kW2W4' */
    rtb_PactOut *= -0.1;

    /* Switch: '<S400>/Switch' incorporates:
     *  RelationalOperator: '<S400>/UpperRelop'
     */
    if (rtb_PrefOut < rtb_PactOut) {
      rtb_Switch2_g3 = rtb_PactOut;
    } else {
      rtb_Switch2_g3 = rtb_PrefOut;
    }

    /* End of Switch: '<S400>/Switch' */
  }

  /* End of Switch: '<S400>/Switch2' */

  /* Switch: '<S7>/Switch1' */
  if (Gen2_ref_B->BusInput3.traj.bUseSpeedCtrlPd) {
    rtb_kW2W1_h = Gen2_ref_B->Pd_filt_p.Switch;
  } else {
    /* Sum: '<S344>/Sum1' */
    rtb_PactOut = Gen2_ref_B->Pd_filt.Switch + rtb_Switch2_g3;

    /* Switch: '<S401>/Switch2' incorporates:
     *  RelationalOperator: '<S401>/LowerRelop1'
     */
    if (!(rtb_PactOut > rtb_kW2W1_h)) {
      /* Switch: '<S401>/Switch' incorporates:
       *  Constant: '<S344>/ tde4'
       *  RelationalOperator: '<S401>/UpperRelop'
       */
      if (rtb_PactOut < 1.0) {
        rtb_kW2W1_h = 1.0;
      } else {
        rtb_kW2W1_h = rtb_PactOut;
      }

      /* End of Switch: '<S401>/Switch' */
    }

    /* End of Switch: '<S401>/Switch2' */
  }

  /* End of Switch: '<S7>/Switch1' */

  /* Gain: '<S338>/W2kW' incorporates:
   *  Gain: '<S16>/W2kW'
   */
  rtb_PactOut_tmp = 0.001 * rtb_kW2W1_h;

  /* Switch: '<S376>/Switch2' incorporates:
   *  Gain: '<S338>/W2kW'
   *  RelationalOperator: '<S376>/LowerRelop1'
   */
  if (rtb_PactOut_tmp > Gen2_ref_B->BusInput3.eng.rP_Nom) {
    rtb_PrefOut = Gen2_ref_B->BusInput3.eng.rP_Nom;
  } else {
    /* Product: '<S373>/Divide6' */
    rtb_PrefOut = Gen2_ref_B->BusInput3.eng.rP_Nom *
      Gen2_ref_B->BusInput3.leanox.rP_P2sRedIP_SP_Norm;

    /* Switch: '<S376>/Switch' incorporates:
     *  RelationalOperator: '<S376>/UpperRelop'
     */
    if (!(rtb_PactOut_tmp < rtb_PrefOut)) {
      rtb_PrefOut = rtb_PactOut_tmp;
    }

    /* End of Switch: '<S376>/Switch' */
  }

  /* End of Switch: '<S376>/Switch2' */

  /* MATLAB Function: '<S373>/2-point interpolation, with extrapolation' */
  upointinterpolationwithextrapol(rtb_PrefOut,
    Gen2_ref_B->BusInput3.leanox.Comp_IgnP_x,
    Gen2_ref_B->BusInput3.leanox.Comp_IgnP_y,
    &Gen2_ref_B->sf_2pointinterpolationwithextra, inst);

  /* Outputs for Atomic SubSystem: '<S190>/N_TC_HP_filt' */
  /* DataTypeConversion: '<S4>/Data Type Conversion14' */
  Gen2_ref_N_TC_HP_filt((real_T)Gen2_ref_B->BusInput.rCA_Ign_Avg,
                        Gen2_ref_B->BusInput3.inFilt.rTiF_Ign, rtb_bResetBdc,
                        &Gen2_ref_B->N_TC_HP_filt, &Gen2_ref_DWork->N_TC_HP_filt, inst);

  /* End of Outputs for SubSystem: '<S190>/N_TC_HP_filt' */

  /* Switch: '<S377>/Switch2' incorporates:
   *  Gain: '<S338>/W2kW'
   *  RelationalOperator: '<S377>/LowerRelop1'
   */
  if (rtb_PactOut_tmp > Gen2_ref_B->BusInput3.eng.rP_Nom) {
    rtb_PrefOut = Gen2_ref_B->BusInput3.eng.rP_Nom;
  } else {
    /* Product: '<S373>/Divide1' */
    rtb_PrefOut = Gen2_ref_B->BusInput3.eng.rP_Nom *
      Gen2_ref_B->BusInput3.leanox.rP2s_Comp_Act_SP;

    /* Switch: '<S377>/Switch' incorporates:
     *  RelationalOperator: '<S377>/UpperRelop'
     */
    if (!(rtb_PactOut_tmp < rtb_PrefOut)) {
      rtb_PrefOut = rtb_PactOut_tmp;
    }

    /* End of Switch: '<S377>/Switch' */
  }

  /* End of Switch: '<S377>/Switch2' */

  /* MATLAB Function: '<S373>/2-point interpolation, with extrapolation1' */
  upointinterpolationwithextrapol(rtb_PrefOut,
    Gen2_ref_B->BusInput3.leanox.Comp_ChTmp_x,
    Gen2_ref_B->BusInput3.leanox.Comp_ChTmp_y,
    &Gen2_ref_B->sf_2pointinterpolationwithext_d, inst);

  /* Outputs for Atomic SubSystem: '<S197>/T2s_filt' */
  /* Bias: '<S4>/C2K2' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion9'
   */
  Gen2_ref_N_TC_HP_filt(Gen2_ref_B->BusInput.tT.rT2s + 273.15,
                        Gen2_ref_B->BusInput3.inFilt.rTiF_T, rtb_bResetBdc,
                        &Gen2_ref_B->T2s_filt, &Gen2_ref_DWork->T2s_filt, inst);

  /* End of Outputs for SubSystem: '<S197>/T2s_filt' */

  /* Switch: '<S338>/Switch1' incorporates:
   *  Gain: '<S338>/W2kW'
   *  Product: '<S338>/Divide6'
   *  Sum: '<S338>/Add4'
   */
  if (Gen2_ref_B->BusInput.tLEANOXin.bZylAusfall) {
    /* Switch: '<S355>/Switch' incorporates:
     *  Abs: '<S355>/Abs'
     *  Constant: '<S355>/Constant2'
     *  RelationalOperator: '<S355>/Relational Operator'
     */
    if (1.0 >= fabs(Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng)) {
      rtb_bResetHlci_0 = 1.0;
    } else {
      rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
    }

    /* End of Switch: '<S355>/Switch' */
    rtb_deltafalllimit_ca = rtb_PactOut_tmp / rtb_bResetHlci_0 + rtb_PactOut_tmp;
  } else {
    rtb_deltafalllimit_ca = rtb_PactOut_tmp;
  }

  /* End of Switch: '<S338>/Switch1' */

  /* Outputs for Atomic SubSystem: '<S193>/N_TC_LP_filt' */
  Gen2_ref_N_TC_HP_filt(rtb_DataTypeConversion15,
                        Gen2_ref_B->BusInput3.inFilt.rTiF_N, rtb_bResetBdc,
                        &Gen2_ref_B->N_TC_LP_filt_f,
                        &Gen2_ref_DWork->N_TC_LP_filt_f, inst);

  /* End of Outputs for SubSystem: '<S193>/N_TC_LP_filt' */

  /* Switch: '<S7>/Switch' */
  if (Gen2_ref_B->BusInput3.leanox.bMeasuredSpeed) {
    rtb_MinMax_n = Gen2_ref_B->N_TC_LP_filt_f.Switch;
  } else {
    rtb_MinMax_n = Gen2_ref_B->BusInput3.eng.rN_Nom;
  }

  /* End of Switch: '<S7>/Switch' */

  /* Switch: '<S346>/Switch' incorporates:
   *  Abs: '<S346>/Abs'
   *  Constant: '<S346>/Constant2'
   *  RelationalOperator: '<S346>/Relational Operator'
   */
  if (1.0 >= fabs(rtb_MinMax_n)) {
    rtb_Switch_on = 1.0;
  } else {
    rtb_Switch_on = rtb_MinMax_n;
  }

  /* End of Switch: '<S346>/Switch' */

  /* Switch: '<S338>/Switch4' */
  if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena) {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rP_c;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rP_1;
  }

  /* End of Switch: '<S338>/Switch4' */

  /* Switch: '<S338>/Switch2' incorporates:
   *  Logic: '<S338>/Logical Operator1'
   *  Product: '<S338>/Divide4'
   *  RelationalOperator: '<S338>/Relational Operator1'
   *  RelationalOperator: '<S338>/Relational Operator3'
   *  Sum: '<S338>/Add5'
   *  Switch: '<S338>/Switch5'
   */
  if (rtb_deltafalllimit_ca < rtb_bResetHlci_0) {
    /* Switch: '<S338>/Switch_b_c' incorporates:
     *  Logic: '<S338>/Logical Operator'
     *  RelationalOperator: '<S338>/Relational Operator2'
     */
    if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena && (rtb_deltafalllimit_ca <
         Gen2_ref_B->BusInput3.leanox.rP_c)) {
      /* SignalConversion generated from: '<S338>/Lookup Table Dynamic1' */
      rtb_TmpSignalConversionAtLoo_ht[0] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_0;

      /* Switch: '<S356>/Switch' incorporates:
       *  Abs: '<S356>/Abs'
       *  Constant: '<S356>/Constant2'
       *  RelationalOperator: '<S356>/Relational Operator'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_c)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_c;
      }

      /* End of Switch: '<S356>/Switch' */

      /* SignalConversion generated from: '<S338>/Lookup Table Dynamic1' incorporates:
       *  Product: '<S338>/Divide5'
       */
      rtb_TmpSignalConversionAtLoo_ht[1] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_c *
        Gen2_ref_B->BusInput3.leanox.rN_c / rtb_bResetHlci_0 *
        Gen2_ref_B->T2s_filt.Switch / rtb_Switch_on;

      /* SignalConversion generated from: '<S338>/Lookup Table Dynamic1' incorporates:
       *  Constant: '<S338>/Pel_a (kW)1'
       */
      rtb_TmpSignalConversionAtLook_d[0] = 0.0;
      rtb_TmpSignalConversionAtLook_d[1] = Gen2_ref_B->BusInput3.leanox.rP_c;

      /* S-Function (sfix_look1_dyn): '<S338>/Lookup Table Dynamic1' */
      /* Dynamic Look-Up Table Block: '<S338>/Lookup Table Dynamic1'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_LookupTableDynamic1_e),
                           &rtb_TmpSignalConversionAtLoo_ht[0],
                           rtb_deltafalllimit_ca,
                           &rtb_TmpSignalConversionAtLook_d[0], 1U, inst);
      rtb_MinMax_n = rtb_LookupTableDynamic1_e;
    } else {
      /* SignalConversion generated from: '<S338>/Lookup Table Dynamic' */
      rtb_TmpSignalConversionAtLoo_ht[0] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_0;

      /* Switch: '<S354>/Switch' incorporates:
       *  Abs: '<S354>/Abs'
       *  Constant: '<S354>/Constant2'
       *  RelationalOperator: '<S354>/Relational Operator'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_1)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_1;
      }

      /* End of Switch: '<S354>/Switch' */

      /* SignalConversion generated from: '<S338>/Lookup Table Dynamic' incorporates:
       *  Product: '<S338>/Divide1'
       */
      rtb_TmpSignalConversionAtLoo_ht[1] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
        Gen2_ref_B->BusInput3.leanox.rN_1 / rtb_bResetHlci_0 *
        Gen2_ref_B->T2s_filt.Switch / rtb_Switch_on;

      /* SignalConversion generated from: '<S338>/Lookup Table Dynamic' incorporates:
       *  Constant: '<S338>/Pel_a (kW)3'
       */
      rtb_TmpSignalConversionAtLook_d[0] = 0.0;
      rtb_TmpSignalConversionAtLook_d[1] = Gen2_ref_B->BusInput3.leanox.rP_1;

      /* S-Function (sfix_look1_dyn): '<S338>/Lookup Table Dynamic' */
      /* Dynamic Look-Up Table Block: '<S338>/Lookup Table Dynamic'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_LookupTableDynamic_i),
                           &rtb_TmpSignalConversionAtLoo_ht[0],
                           rtb_deltafalllimit_ca,
                           &rtb_TmpSignalConversionAtLook_d[0], 1U, inst);
      rtb_MinMax_n = rtb_LookupTableDynamic_i;
    }

    /* End of Switch: '<S338>/Switch_b_c' */
  } else {
    if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena && (rtb_deltafalllimit_ca <
         Gen2_ref_B->BusInput3.leanox.rP_1)) {
      /* Sum: '<S338>/Add1' incorporates:
       *  Switch: '<S338>/Switch5'
       */
      rtb_Switch_jz = Gen2_ref_B->BusInput3.leanox.rP_1 -
        Gen2_ref_B->BusInput3.leanox.rP_c;

      /* Sum: '<S338>/Sum4' incorporates:
       *  Switch: '<S338>/Switch5'
       */
      rtb_Divide2_a = Gen2_ref_B->BusInput3.leanox.rP_c +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S349>/Switch' incorporates:
       *  Abs: '<S349>/Abs'
       *  Constant: '<S349>/Constant2'
       *  RelationalOperator: '<S349>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(rtb_Divide2_a)) {
        rtb_rKK2_k = 1.0;
      } else {
        rtb_rKK2_k = rtb_Divide2_a;
      }

      /* End of Switch: '<S349>/Switch' */

      /* Sum: '<S338>/Sum5' incorporates:
       *  Switch: '<S338>/Switch5'
       */
      rtb_Divide2_a = Gen2_ref_B->BusInput3.leanox.rP_1 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S357>/Switch' incorporates:
       *  Abs: '<S357>/Abs'
       *  Constant: '<S357>/Constant2'
       *  RelationalOperator: '<S357>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_1)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_1;
      }

      /* End of Switch: '<S357>/Switch' */

      /* Switch: '<S348>/Switch' incorporates:
       *  Abs: '<S348>/Abs'
       *  Constant: '<S348>/Constant2'
       *  RelationalOperator: '<S348>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(rtb_Divide2_a)) {
        rtb_Divide2_a = 1.0;
      }

      /* End of Switch: '<S348>/Switch' */

      /* Product: '<S338>/rKK3' incorporates:
       *  Switch: '<S338>/Switch5'
       */
      rtb_Divide2_a = Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
        Gen2_ref_B->BusInput3.leanox.rN_1 / rtb_bResetHlci_0 / rtb_Divide2_a;

      /* Switch: '<S350>/Switch' incorporates:
       *  Abs: '<S350>/Abs'
       *  Constant: '<S350>/Constant2'
       *  RelationalOperator: '<S350>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_c)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_c;
      }

      /* End of Switch: '<S350>/Switch' */

      /* Switch: '<S358>/Switch' incorporates:
       *  Abs: '<S358>/Abs'
       *  Constant: '<S358>/Constant2'
       *  RelationalOperator: '<S358>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(rtb_Switch_jz)) {
        rtb_Switch_jz = 1.0;
      }

      /* End of Switch: '<S358>/Switch' */

      /* Switch: '<S338>/Switch5' incorporates:
       *  Gain: '<S338>/W2kW'
       *  Product: '<S338>/Divide10'
       *  Product: '<S338>/Divide9'
       *  Product: '<S338>/rKK4'
       *  Sum: '<S338>/Add3'
       *  Sum: '<S338>/Sum6'
       *  Sum: '<S338>/Sum7'
       */
      rtb_PactOut = (rtb_Divide2_a - Gen2_ref_B->BusInput3.leanox.rPr_mbar_c *
                     Gen2_ref_B->BusInput3.leanox.rN_c / rtb_bResetHlci_0 /
                     rtb_rKK2_k) / rtb_Switch_jz * (rtb_PactOut_tmp -
        Gen2_ref_B->BusInput3.leanox.rP_1) + rtb_Divide2_a;
    } else {
      /* Sum: '<S338>/Add10' incorporates:
       *  Switch: '<S338>/Switch5'
       */
      rtb_Switch_jz = Gen2_ref_B->BusInput3.leanox.rP_2 -
        Gen2_ref_B->BusInput3.leanox.rP_1;

      /* Sum: '<S338>/Sum' incorporates:
       *  Switch: '<S338>/Switch5'
       */
      rtb_rKK2_k = Gen2_ref_B->BusInput3.leanox.rP_1 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Sum: '<S338>/Sum1' incorporates:
       *  Switch: '<S338>/Switch5'
       */
      rtb_Divide2_a = Gen2_ref_B->BusInput3.leanox.rP_2 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S347>/Switch' incorporates:
       *  Abs: '<S347>/Abs'
       *  Constant: '<S347>/Constant2'
       *  RelationalOperator: '<S347>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_2)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_2;
      }

      /* End of Switch: '<S347>/Switch' */

      /* Switch: '<S352>/Switch' incorporates:
       *  Abs: '<S352>/Abs'
       *  Constant: '<S352>/Constant2'
       *  RelationalOperator: '<S352>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(rtb_Divide2_a)) {
        rtb_Divide2_a = 1.0;
      }

      /* End of Switch: '<S352>/Switch' */

      /* Product: '<S338>/rKK1' incorporates:
       *  Switch: '<S338>/Switch5'
       */
      rtb_Divide2_a = Gen2_ref_B->BusInput3.leanox.rPr_mbar_2 *
        Gen2_ref_B->BusInput3.leanox.rN_2 / rtb_bResetHlci_0 / rtb_Divide2_a;

      /* Switch: '<S353>/Switch' incorporates:
       *  Abs: '<S353>/Abs'
       *  Constant: '<S353>/Constant2'
       *  RelationalOperator: '<S353>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(rtb_rKK2_k)) {
        rtb_rKK2_k = 1.0;
      }

      /* End of Switch: '<S353>/Switch' */

      /* Switch: '<S351>/Switch' incorporates:
       *  Abs: '<S351>/Abs'
       *  Constant: '<S351>/Constant2'
       *  RelationalOperator: '<S351>/Relational Operator'
       *  Switch: '<S338>/Switch5'
       */
      if (1.0 >= fabs(rtb_Switch_jz)) {
        rtb_Switch_jz = 1.0;
      }

      /* End of Switch: '<S351>/Switch' */

      /* Switch: '<S338>/Switch5' incorporates:
       *  Gain: '<S338>/W2kW'
       *  Product: '<S338>/Divide2'
       *  Product: '<S338>/Divide3'
       *  Product: '<S338>/rKK2'
       *  Sum: '<S338>/Add2'
       *  Sum: '<S338>/Sum2'
       *  Sum: '<S338>/Sum3'
       */
      rtb_PactOut = (rtb_Divide2_a - Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
                     Gen2_ref_B->BusInput3.leanox.rN_1 /
                     Gen2_ref_B->BusInput3.leanox.rT_1 / rtb_rKK2_k) /
        rtb_Switch_jz * (rtb_PactOut_tmp - Gen2_ref_B->BusInput3.leanox.rP_2) +
        rtb_Divide2_a;
    }

    rtb_MinMax_n = rtb_PactOut * Gen2_ref_B->T2s_filt.Switch *
      (Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict + rtb_deltafalllimit_ca) /
      rtb_Switch_on;
  }

  /* End of Switch: '<S338>/Switch2' */

  /* Product: '<S359>/Divide8' incorporates:
   *  DataTypeConversion: '<S359>/Data Type Conversion2'
   */
  rtb_PactOut = rtb_MinMax_n * Gen2_ref_B->BusInput.tLEANOXin.rLEANOX_fact_BC;

  /* Delay: '<S15>/Resettable Delay' incorporates:
   *  Constant: '<S15>/Pel_a (kW)2'
   */
  Gen2_ref_DWork->icLoad_nl =
    ((((Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE == 1) != (int32_T)
       rtb_bResetBdc) && (Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE !=
       3)) || rtb_bResetBdc || Gen2_ref_DWork->icLoad_nl);
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE = rtb_bResetBdc;
  if (Gen2_ref_DWork->icLoad_nl) {
    Gen2_ref_DWork->ResettableDelay_DSTATE = 0.0;
  }

  /* Sum: '<S888>/Sum1' incorporates:
   *  Sum: '<S589>/Sum1'
   */
  rtb_Divide_mr_tmp = Gen2_ref_B->BusInput3.SkipF.rP_1 -
    Gen2_ref_B->BusInput3.SkipF.rP_0;

  /* Abs: '<S901>/Abs' incorporates:
   *  Abs: '<S596>/Abs'
   *  Sum: '<S888>/Sum1'
   */
  rtb_Switch2_ba = fabs(rtb_Divide_mr_tmp);

  /* Switch: '<S901>/Switch' incorporates:
   *  Abs: '<S901>/Abs'
   *  Constant: '<S901>/Constant2'
   *  RelationalOperator: '<S901>/Relational Operator'
   *  Sum: '<S888>/Sum1'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_ba) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = rtb_Divide_mr_tmp;
  }

  /* End of Switch: '<S901>/Switch' */

  /* Sum: '<S888>/Sum3' incorporates:
   *  Gain: '<S888>/Gain'
   *  Product: '<S888>/Divide'
   *  Product: '<S888>/Product'
   *  Sum: '<S888>/Sum'
   *  Sum: '<S888>/Sum2'
   */
  rtb_deltafalllimit_ca = Gen2_ref_B->BusInput3.SkipF.rNum_P0 - (0.001 *
    rtb_kW2W1_h - Gen2_ref_B->BusInput3.SkipF.rP_0) *
    (Gen2_ref_B->BusInput3.SkipF.rNum_P0 / rtb_bResetHlci_0);

  /* Switch: '<S902>/Switch2' incorporates:
   *  Constant: '<S888>/Constant1'
   *  RelationalOperator: '<S902>/LowerRelop1'
   *  RelationalOperator: '<S902>/UpperRelop'
   *  Switch: '<S902>/Switch'
   */
  if (rtb_deltafalllimit_ca > Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng) {
    rtb_deltafalllimit_ca = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  } else if (rtb_deltafalllimit_ca < 0.0) {
    /* Switch: '<S902>/Switch' incorporates:
     *  Constant: '<S888>/Constant1'
     */
    rtb_deltafalllimit_ca = 0.0;
  }

  /* End of Switch: '<S902>/Switch2' */

  /* Rounding: '<S888>/Rounding Function' */
  rtb_MinMax_n = rt_roundd_snf(rtb_deltafalllimit_ca, inst);

  /* MinMax: '<S19>/MinMax' */
  if ((Gen2_ref_B->BusInput.iN_Skip_Ext >= rtb_MinMax_n) || rtIsNaN(rtb_MinMax_n))
  {
    rtb_MinMax_n = Gen2_ref_B->BusInput.iN_Skip_Ext;
  }

  /* End of MinMax: '<S19>/MinMax' */

  /* Sum: '<S19>/Sum4' */
  rtb_deltafalllimit_ca = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng - rtb_MinMax_n;

  /* Switch: '<S892>/Switch2' incorporates:
   *  RelationalOperator: '<S892>/LowerRelop1'
   *  RelationalOperator: '<S892>/UpperRelop'
   *  Switch: '<S892>/Switch'
   */
  if (rtb_deltafalllimit_ca > Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng) {
    rtb_deltafalllimit_ca = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  } else if (rtb_deltafalllimit_ca < 1.0) {
    /* Switch: '<S892>/Switch' */
    rtb_deltafalllimit_ca = 1.0;
  }

  /* End of Switch: '<S892>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S19>/Filter1' */
  /* Product: '<S19>/Divide1' */
  Gen2_ref_Filter3(Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng /
                   rtb_deltafalllimit_ca, Gen2_ref_B->BusInput3.SkipF.rTiF_stat,
                   1.0, rtb_bResetBdc, &Gen2_ref_B->Filter1_l,
                   &Gen2_ref_DWork->Filter1_l, inst);

  /* End of Outputs for SubSystem: '<S19>/Filter1' */

  /* Switch: '<S19>/NSkip1' incorporates:
   *  Constant: '<S19>/Constant5'
   *  Logic: '<S19>/Logical Operator1'
   */
  if (!Gen2_ref_B->BusInput3.SkipF.bSF_ON) {
    u0 = 1.0;
  } else {
    u0 = Gen2_ref_B->Filter1_l.Switch;
  }

  /* End of Switch: '<S19>/NSkip1' */

  /* Switch: '<S373>/Switch1' incorporates:
   *  Constant: '<S373>/Pel_a (kW)1'
   *  DataTypeConversion: '<S4>/Data Type Conversion22'
   *  Product: '<S373>/Divide5'
   *  Sum: '<S373>/Add12'
   */
  if (Gen2_ref_B->BusInput3.leanox.bZZPKorr) {
    rtb_bResetHlci_0 = (Gen2_ref_B->BusInput.rCA_Ign_OP_Power -
                        Gen2_ref_B->N_TC_HP_filt.Switch) *
      Gen2_ref_B->sf_2pointinterpolationwithextra.y;
  } else {
    rtb_bResetHlci_0 = 0.0;
  }

  /* End of Switch: '<S373>/Switch1' */

  /* Switch: '<S373>/Switch2' incorporates:
   *  Constant: '<S373>/Pel_a (kW)2'
   *  Product: '<S373>/Divide9'
   *  Sum: '<S373>/Add13'
   */
  if (Gen2_ref_B->BusInput3.leanox.bt2Korr) {
    delta_y = (Gen2_ref_B->T2s_filt.Switch - Gen2_ref_B->BusInput3.leanox.rT_2) *
      Gen2_ref_B->sf_2pointinterpolationwithext_d.y;
  } else {
    delta_y = 0.0;
  }

  /* End of Switch: '<S373>/Switch2' */

  /* Switch: '<S373>/Switch3' incorporates:
   *  Constant: '<S373>/Pel_a (kW)3'
   */
  if (Gen2_ref_B->BusInput3.leanox.bHum_Act) {
    FILT_IN = Gen2_ref_B->BusInput3.leanox.rP2s_Comp_HumOffset;
  } else {
    FILT_IN = 0.0;
  }

  /* End of Switch: '<S373>/Switch3' */

  /* MinMax: '<S359>/MinMax' incorporates:
   *  MinMax: '<S775>/MinMax'
   */
  rtb_bCBV_min = !rtIsNaN(Gen2_ref_B->BusInput.tLEANOXin.rHiCtr_Leanox_Corr);
  if ((!(u0 >= Gen2_ref_B->BusInput.tLEANOXin.rHiCtr_Leanox_Corr)) &&
      rtb_bCBV_min) {
    u0 = Gen2_ref_B->BusInput.tLEANOXin.rHiCtr_Leanox_Corr;
  }

  /* End of MinMax: '<S359>/MinMax' */

  /* Gain: '<S359>/mbar2pa' incorporates:
   *  DataTypeConversion: '<S359>/Data Type Conversion'
   *  Delay: '<S15>/Resettable Delay'
   *  Product: '<S359>/Divide5'
   *  Sum: '<S359>/Add1'
   *  Sum: '<S359>/Add11'
   *  Sum: '<S359>/Add9'
   */
  rtb_Pa2bar_k = (((((rtb_bResetHlci_0 + delta_y) + FILT_IN) + rtb_PactOut) +
                   Gen2_ref_DWork->ResettableDelay_DSTATE) * u0 +
                  Gen2_ref_B->BusInput.tLEANOXin.rLEANOXoffset) * 100.0;

  /* Saturate: '<S388>/Saturation' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.rPosValvethrshAW > 1.0) {
    /* Saturate: '<S490>/Saturation' incorporates:
     *  Saturate: '<S18>/Saturation'
     *  Saturate: '<S752>/Saturation'
     *  Switch: '<S752>/Switch2'
     */
    rtb_PactOut = 1.0;
  } else if (Gen2_ref_B->BusInput3.SpeedCtrl.rPosValvethrshAW < 0.0) {
    /* Saturate: '<S490>/Saturation' incorporates:
     *  Saturate: '<S18>/Saturation'
     *  Saturate: '<S752>/Saturation'
     *  Switch: '<S752>/Switch2'
     */
    rtb_PactOut = 0.0;
  } else {
    /* Saturate: '<S490>/Saturation' incorporates:
     *  Saturate: '<S18>/Saturation'
     *  Saturate: '<S752>/Saturation'
     *  Switch: '<S752>/Switch2'
     */
    rtb_PactOut = Gen2_ref_B->BusInput3.SpeedCtrl.rPosValvethrshAW;
  }

  /* Sum: '<S388>/Sum1' incorporates:
   *  Saturate: '<S388>/Saturation'
   *  Sum: '<S752>/Sum1'
   *  Switch: '<S752>/Switch2'
   */
  rtb_Switch2_ejy_tmp_0 = Gen2_ref_B->BusInput3.bdcCbv.rPos_min + rtb_PactOut;
  rtb_Switch2_l = rtb_Switch2_ejy_tmp_0;

  /* RelationalOperator: '<S388>/Relational Operator' incorporates:
   *  Delay: '<Root>/Delay4'
   */
  rtb_LogicalOperator_cn = (Gen2_ref_DWork->Delay4_DSTATE <= rtb_Switch2_l);

  /* Delay: '<Root>/Delay3' */
  rtb_Switch_on = Gen2_ref_DWork->Delay3_DSTATE;

  /* Saturate: '<S388>/Saturation2' */
  if (Gen2_ref_B->BusInput3.bdcTv.rPos_max > 1.0) {
    /* Saturate: '<S752>/Saturation2' incorporates:
     *  Saturate: '<S18>/Saturation2'
     *  Switch: '<S752>/Switch2'
     */
    rtb_PrefOut = 1.0;
  } else if (Gen2_ref_B->BusInput3.bdcTv.rPos_max < 0.1) {
    /* Saturate: '<S752>/Saturation2' incorporates:
     *  Saturate: '<S18>/Saturation2'
     *  Switch: '<S752>/Switch2'
     */
    rtb_PrefOut = 0.1;
  } else {
    /* Saturate: '<S752>/Saturation2' incorporates:
     *  Saturate: '<S18>/Saturation2'
     *  Switch: '<S752>/Switch2'
     */
    rtb_PrefOut = Gen2_ref_B->BusInput3.bdcTv.rPos_max;
  }

  rtb_Switch2_l = rtb_PrefOut;

  /* End of Saturate: '<S388>/Saturation2' */

  /* Product: '<S388>/Divide1' */
  rtb_deltafalllimit_ca = rtb_Switch_on / rtb_Switch2_l;

  /* Sum: '<S388>/Sum' incorporates:
   *  Constant: '<S388>/Constant4'
   *  Saturate: '<S388>/Saturation'
   */
  rtb_Switch2_l = 1.0 - rtb_PactOut;

  /* RelationalOperator: '<S388>/Relational Operator1' */
  rtb_LogicalOperator5_mv = (rtb_deltafalllimit_ca >= rtb_Switch2_l);

  /* Logic: '<S388>/Logical Operator' */
  rtb_LogicalOperator2_p1 = (rtb_LogicalOperator_cn && rtb_LogicalOperator5_mv);

  /* Switch: '<S388>/Switch' incorporates:
   *  Constant: '<S388>/Constant'
   *  Constant: '<S388>/Constant1'
   */
  if (rtb_LogicalOperator2_p1) {
    rtb_mbar2pa_g = 0.0;
  } else {
    rtb_mbar2pa_g = 1.0E+6;
  }

  /* End of Switch: '<S388>/Switch' */

  /* Outputs for Atomic SubSystem: '<S6>/TOF' */
  /* Delay: '<Root>/Delay6' */
  Gen2_ref_TOF(Gen2_ref_DWork->Delay6_DSTATE,
               Gen2_ref_B->BusInput3.GQC.rTOF_DetSat, &Gen2_ref_B->TOF,
               &Gen2_ref_DWork->TOF, inst);

  /* End of Outputs for SubSystem: '<S6>/TOF' */

  /* Logic: '<Root>/Logical Operator' incorporates:
   *  Logic: '<Root>/Logical Operator4'
   */
  rtb_LogicalOperator_cn = (rtb_LogicalOperator_in && rtb_bResetHlci);

  /* Delay: '<Root>/Delay2' incorporates:
   *  Bias: '<Root>/Bias'
   *  Delay: '<Root>/Delay1'
   *  Logic: '<Root>/Logical Operator'
   */
  Gen2_ref_DWork->icLoad_e = ((((Gen2_ref_PrevZCSigState->Delay2_Reset_ZCE == 1)
    != (int32_T)rtb_LogicalOperator_cn) &&
    (Gen2_ref_PrevZCSigState->Delay2_Reset_ZCE != 3)) || rtb_LogicalOperator_cn ||
    Gen2_ref_DWork->icLoad_e);
  Gen2_ref_PrevZCSigState->Delay2_Reset_ZCE = rtb_LogicalOperator_cn;
  if (Gen2_ref_DWork->icLoad_e) {
    Gen2_ref_DWork->Delay2_DSTATE = Gen2_ref_DWork->Delay1_DSTATE[1] + 0.01;
  }

  /* Logic: '<S6>/Logical Operator2' incorporates:
   *  Abs: '<S6>/Abs2'
   *  Abs: '<S6>/Abs3'
   *  Delay: '<Root>/Delay1'
   *  Delay: '<Root>/Delay2'
   *  RelationalOperator: '<S6>/Relational Operator2'
   *  RelationalOperator: '<S6>/Relational Operator3'
   *  Sum: '<S6>/Sum2'
   *  Sum: '<S6>/Sum3'
   */
  rtb_LogicalOperator2_fy = ((fabs(Gen2_ref_DWork->Delay2_DSTATE -
    Gen2_ref_DWork->Delay1_DSTATE[0]) < Gen2_ref_B->BusInput3.GQC.rThrshLamSat) ||
    (fabs(Gen2_ref_DWork->Delay2_DSTATE - Gen2_ref_DWork->Delay1_DSTATE[1]) <
     Gen2_ref_B->BusInput3.GQC.rThrshLamSat));

  /* Outputs for Atomic SubSystem: '<S6>/TON' */
  Gen2_ref_TON_1(rtb_LogicalOperator2_fy, Gen2_ref_B->BusInput3.GQC.rTON_LamSat,
                 &Gen2_ref_B->TON, &Gen2_ref_DWork->TON, inst);

  /* End of Outputs for SubSystem: '<S6>/TON' */

  /* Switch: '<S6>/Switch3' incorporates:
   *  Constant: '<S6>/Constant8'
   *  Logic: '<S6>/Logical Operator'
   *  Logic: '<S6>/Logical Operator1'
   */
  if (Gen2_ref_B->BusInput3.GQC.bEnableFuncQGC) {
    rtb_bActGasQualImprov = ((!Gen2_ref_B->TOF.LogicalOperator1) &&
      Gen2_ref_B->TON.LogicalOperator3);
  } else {
    rtb_bActGasQualImprov = false;
  }

  /* End of Switch: '<S6>/Switch3' */

  /* Sum: '<S343>/Sum2' incorporates:
   *  Sum: '<S342>/Sum2'
   */
  u0 = rtb_kW2W1_h - rtb_PactOut_o;

  /* Product: '<S343>/Product' incorporates:
   *  DataTypeConversion: '<S343>/Data Type Conversion'
   *  Gain: '<S343>/Gain4'
   *  Sum: '<S343>/Sum2'
   */
  rtb_Switch_jz = u0 * 1.0E-6 * (real_T)rtb_bActGasQualImprov;

  /* Saturate: '<S388>/Saturation1' */
  if (Gen2_ref_B->BusInput3.bdcCbv.rPos_max > 1.0) {
    /* Saturate: '<S490>/Saturation1' incorporates:
     *  Saturate: '<S18>/Saturation1'
     */
    rtb_deltafalllimit_ca = 1.0;
  } else if (Gen2_ref_B->BusInput3.bdcCbv.rPos_max < 0.1) {
    /* Saturate: '<S490>/Saturation1' incorporates:
     *  Saturate: '<S18>/Saturation1'
     */
    rtb_deltafalllimit_ca = 0.1;
  } else {
    /* Saturate: '<S490>/Saturation1' incorporates:
     *  Saturate: '<S18>/Saturation1'
     */
    rtb_deltafalllimit_ca = Gen2_ref_B->BusInput3.bdcCbv.rPos_max;
  }

  /* Sum: '<S388>/Sum2' incorporates:
   *  Saturate: '<S388>/Saturation'
   *  Sum: '<S752>/Sum2'
   *  Switch: '<S752>/Switch2'
   *  Switch: '<S755>/Switch2'
   */
  rtb_LogicalOperator1_js_tmp = Gen2_ref_B->BusInput3.bdcTv.rPos_min +
    rtb_PactOut;

  /* Logic: '<S388>/Logical Operator1' incorporates:
   *  Delay: '<Root>/Delay4'
   *  Logic: '<S388>/Logical Operator2'
   *  Product: '<S388>/Divide'
   *  RelationalOperator: '<S388>/Relational Operator2'
   *  RelationalOperator: '<S388>/Relational Operator3'
   *  Saturate: '<S388>/Saturation1'
   *  Sum: '<S388>/Sum2'
   */
  rtb_LogicalOperator1_j = ((Gen2_ref_DWork->Delay4_DSTATE /
    rtb_deltafalllimit_ca >= rtb_Switch2_l) && ((rtb_Switch_on <=
    rtb_LogicalOperator1_js_tmp) || rtb_LogicalOperator5_mv));

  /* Switch: '<S390>/Switch2' incorporates:
   *  RelationalOperator: '<S390>/LowerRelop1'
   */
  if (!(rtb_Switch_jz > rtb_mbar2pa_g)) {
    /* Switch: '<S388>/Switch1' incorporates:
     *  Constant: '<S388>/Constant2'
     *  Constant: '<S388>/Constant3'
     */
    if (rtb_LogicalOperator1_j) {
      rtb_Switch_on = 0.0;
    } else {
      rtb_Switch_on = -1.0E+6;
    }

    /* End of Switch: '<S388>/Switch1' */

    /* Switch: '<S390>/Switch' incorporates:
     *  RelationalOperator: '<S390>/UpperRelop'
     */
    if (rtb_Switch_jz < rtb_Switch_on) {
      rtb_mbar2pa_g = rtb_Switch_on;
    } else {
      rtb_mbar2pa_g = rtb_Switch_jz;
    }

    /* End of Switch: '<S390>/Switch' */
  }

  /* End of Switch: '<S390>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S6>/TOF1' */
  /* RelationalOperator: '<S6>/Relational Operator' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion30'
   */
  Gen2_ref_TOF((Gen2_ref_B->BusInput.rKnock_level >
                Gen2_ref_B->BusInput3.GQC.rThreshold_knock),
               Gen2_ref_B->BusInput3.GQC.rTOF_KnockMisfDet, &Gen2_ref_B->TOF1,
               &Gen2_ref_DWork->TOF1, inst);

  /* End of Outputs for SubSystem: '<S6>/TOF1' */

  /* Switch: '<S6>/Switch2' */
  rtb_Switch2_jv = (Gen2_ref_B->BusInput3.GQC.bActKnockDetGQC &&
                    Gen2_ref_B->TOF1.LogicalOperator1);

  /* Logic: '<S343>/Logical Operator2' */
  rtb_LogicalOperator2_e = !rtb_Switch2_jv;

  /* Outputs for Atomic SubSystem: '<S6>/TOF2' */
  /* RelationalOperator: '<S6>/Relational Operator1' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion33'
   */
  Gen2_ref_TOF((Gen2_ref_B->BusInput.rMisfire_level >
                Gen2_ref_B->BusInput3.GQC.rThreshold_misfire),
               Gen2_ref_B->BusInput3.GQC.rTOF_KnockMisfDet, &Gen2_ref_B->TOF2,
               &Gen2_ref_DWork->TOF2, inst);

  /* End of Outputs for SubSystem: '<S6>/TOF2' */

  /* Switch: '<S6>/Switch4' */
  rtb_Switch4_mu = (Gen2_ref_B->BusInput3.GQC.bActKnockDetGQC &&
                    Gen2_ref_B->TOF2.LogicalOperator1);

  /* Logic: '<S343>/Logical Operator4' */
  rtb_LogicalOperator5_mv = !rtb_Switch4_mu;

  /* Switch: '<S343>/Switch3' incorporates:
   *  UnitDelay: '<S343>/Unit Delay1'
   */
  if (rtb_LogicalOperator5_mv) {
    /* Switch: '<S343>/Switch2' incorporates:
     *  UnitDelay: '<S343>/Unit Delay1'
     */
    if (rtb_LogicalOperator2_e) {
      rtb_Switch_on = rtb_mbar2pa_g;
    } else {
      rtb_Switch_on = Gen2_ref_DWork->UnitDelay1_DSTATE;
    }

    /* End of Switch: '<S343>/Switch2' */
  } else {
    rtb_Switch_on = Gen2_ref_DWork->UnitDelay1_DSTATE;
  }

  /* End of Switch: '<S343>/Switch3' */

  /* Switch: '<S343>/Switch' */
  if (!rtb_LogicalOperator2_e) {
    /* Saturate: '<S343>/Saturation1' */
    if (rtb_mbar2pa_g < 0.0) {
      rtb_mbar2pa_g = 0.0;
    }

    /* End of Saturate: '<S343>/Saturation1' */
  }

  /* End of Switch: '<S343>/Switch' */

  /* Switch: '<S343>/Switch1' incorporates:
   *  Saturate: '<S343>/Saturation2'
   */
  if (rtb_LogicalOperator5_mv) {
    rtb_Switch_jz = rtb_mbar2pa_g;
  } else if (rtb_mbar2pa_g > 0.0) {
    /* Saturate: '<S343>/Saturation2' */
    rtb_Switch_jz = 0.0;
  } else {
    /* Saturate: '<S343>/Saturation2' */
    rtb_Switch_jz = rtb_mbar2pa_g;
  }

  /* End of Switch: '<S343>/Switch1' */

  /* DataTypeConversion: '<S343>/Data Type Conversion2' incorporates:
   *  UnitDelay: '<S343>/Unit Delay'
   */
  rtb_mbar2pa_g = Gen2_ref_DWork->UnitDelay_DSTATE_mg;

  /* Saturate: '<S343>/Saturation' */
  if (rtb_mbar2pa_g > 0.01) {
    rtb_mbar2pa_g = 0.01;
  } else if (rtb_mbar2pa_g < -0.01) {
    rtb_mbar2pa_g = -0.01;
  }

  /* End of Saturate: '<S343>/Saturation' */

  /* Product: '<S343>/Product1' incorporates:
   *  DataTypeConversion: '<S343>/Data Type Conversion1'
   *  Gain: '<S343>/Gain2'
   *  Logic: '<S343>/Logical Operator1'
   *  Logic: '<S343>/Logical Operator3'
   *  Logic: '<S388>/Logical Operator3'
   */
  rtb_Product1 = -(real_T)((!rtb_bActGasQualImprov) || (rtb_LogicalOperator1_j ||
    rtb_LogicalOperator2_p1)) * rtb_mbar2pa_g *
    Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rFactAW_aux;

  /* Product: '<S343>/Product2' */
  rtb_Pa2bar_o = rtb_PactOut_o / rtb_Product1_aq;

  /* S-Function (sfix_look1_dyn): '<S343>/Lookup Table Dynamic' */
  /* Dynamic Look-Up Table Block: '<S343>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_mbar2pa_g),
                       &Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rPrP2sOffs_max_y[0],
                       rtb_Pa2bar_o,
                       &Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rPrP2sOffs_max_x[0],
                       5U, inst);

  /* Gain: '<S343>/mbar2bar' */
  rtb_rKK2_k = 0.001 * rtb_mbar2pa_g;

  /* Outputs for Atomic SubSystem: '<S343>/PID_Power' */
  /* Product: '<S389>/Divide1' */
  FILT_IN = Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rKp * rtb_Switch_on;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S389>/Data Type Conversion1'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.up = (real32_T)FILT_IN;

  /* Product: '<S389>/Divide2' */
  r = rtb_Switch_jz * Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rKd;

  /* DiscreteIntegrator: '<S389>/Discrete-Time Integrator1' */
  if (rtb_LogicalOperator_in || (Gen2_ref_DWork->DiscreteTimeIntegrator1_Prev_ko
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_m = 0.0;
  }

  /* Product: '<S389>/Divide3' incorporates:
   *  DiscreteIntegrator: '<S389>/Discrete-Time Integrator1'
   *  Sum: '<S389>/Sum1'
   */
  rtb_Divide3_d = (r - Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_m) *
    Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rN;

  /* Delay: '<S389>/Delay2' */
  r = Gen2_ref_DWork->Delay2_DSTATE_h;

  /* MATLAB Function: '<S389>/MATLAB Function' incorporates:
   *  Constant: '<S343>/Constant'
   *  Sum: '<S389>/Sum6'
   */
  Gen2_ref_MATLABFunction_g(rtb_LogicalOperator_in, 0.0, rtb_LogicalOperator1_e,
    (r - FILT_IN) - rtb_Divide3_d, &Gen2_ref_B->sf_MATLABFunction_a,
    &Gen2_ref_DWork->sf_MATLABFunction_a, inst);

  /* DiscreteIntegrator: '<S389>/Discrete-Time Integrator' */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_c != 0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_hn =
      Gen2_ref_B->sf_MATLABFunction_a.Y0Out;
  }

  if (Gen2_ref_B->sf_MATLABFunction_a.ireset ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_b != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_hn =
      Gen2_ref_B->sf_MATLABFunction_a.Y0Out;
  }

  /* Sum: '<S389>/Sum3' incorporates:
   *  DiscreteIntegrator: '<S389>/Discrete-Time Integrator'
   *  Sum: '<S389>/Sum'
   */
  FILT_IN = (FILT_IN + Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_hn) +
    rtb_Divide3_d;

  /* Product: '<S394>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S394>/sample time'
   *
   * About '<S394>/sample time':
   *  y = K where K = ( w * Ts )
   */
  r = Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rLam_Sr_Pos * 0.01;

  /* Delay: '<S394>/Delay' incorporates:
   *  Constant: '<S343>/Constant1'
   *  Delay: '<S404>/Delay'
   */
  Gen2_ref_DWork->icLoad_ht = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_e ==
    1) != (int32_T)rtb_LogicalOperator_in) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_e != 3)) || rtb_LogicalOperator_in
    || Gen2_ref_DWork->icLoad_ht);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_e = rtb_LogicalOperator_in;
  if (Gen2_ref_DWork->icLoad_ht) {
    Gen2_ref_DWork->Delay_DSTATE_fo = 0.0;
  }

  /* Switch: '<S394>/etaVolConst' incorporates:
   *  Constant: '<S343>/Constant1'
   */
  if (rtb_LogicalOperator_in) {
    rtb_Abs = 0.0;
  } else {
    rtb_Abs = FILT_IN;
  }

  /* End of Switch: '<S394>/etaVolConst' */

  /* Sum: '<S394>/Difference Inputs1' incorporates:
   *  Delay: '<S394>/Delay'
   */
  rtb_Divide2_a = rtb_Abs - Gen2_ref_DWork->Delay_DSTATE_fo;

  /* Switch: '<S395>/Switch2' incorporates:
   *  RelationalOperator: '<S395>/LowerRelop1'
   */
  if (!(rtb_Divide2_a > r)) {
    /* Product: '<S394>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S394>/sample time'
     *
     * About '<S394>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Divide_kp = Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rLam_Sr_Neg * 0.01;

    /* Switch: '<S395>/Switch' incorporates:
     *  RelationalOperator: '<S395>/UpperRelop'
     */
    if (rtb_Divide2_a < rtb_Divide_kp) {
      r = rtb_Divide_kp;
    } else {
      r = rtb_Divide2_a;
    }

    /* End of Switch: '<S395>/Switch' */
  }

  /* End of Switch: '<S395>/Switch2' */

  /* Sum: '<S394>/Difference Inputs2' incorporates:
   *  Delay: '<S394>/Delay'
   */
  rtb_Divide2_a = r + Gen2_ref_DWork->Delay_DSTATE_fo;

  /* Switch: '<S393>/Switch2' incorporates:
   *  RelationalOperator: '<S393>/LowerRelop1'
   */
  if (!(rtb_Divide2_a > rtb_rKK2_k)) {
    /* Gain: '<S343>/Pa2bar1' */
    rtb_rKK2_k = -rtb_rKK2_k;

    /* Switch: '<S393>/Switch' incorporates:
     *  RelationalOperator: '<S393>/UpperRelop'
     */
    if (!(rtb_Divide2_a < rtb_rKK2_k)) {
      rtb_rKK2_k = rtb_Divide2_a;
    }

    /* End of Switch: '<S393>/Switch' */
  }

  /* End of Switch: '<S393>/Switch2' */

  /* Sum: '<S389>/Sum2' */
  r = rtb_rKK2_k - FILT_IN;

  /* Product: '<S389>/Divide4' */
  r *= Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rKaw;

  /* MATLAB Function: '<S389>/MATLAB Function1' */
  Gen2_ref_MATLABFunction1(rtb_rKK2_k, rtb_LogicalOperator1_e,
    &Gen2_ref_B->sf_MATLABFunction1_ep, &Gen2_ref_DWork->sf_MATLABFunction1_ep, inst);

  /* BusCreator: '<S389>/Bus Creator1' incorporates:
   *  DataTypeConversion: '<S389>/Data Type Conversion2'
   *  DiscreteIntegrator: '<S389>/Discrete-Time Integrator'
   */
  rtb_BusCreator1_h_ui = (real32_T)
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_hn;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S389>/Bus Creator1'
   *  DataTypeConversion: '<S389>/Data Type Conversion4'
   *  DataTypeConversion: '<S389>/Data Type Conversion7'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.aw = (real32_T)r;
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.u_unsat = (real32_T)FILT_IN;

  /* Product: '<S389>/Divide' */
  FILT_IN = rtb_Switch_jz * Gen2_ref_B->BusInput3.PowCtrlGQCp2s.rKi;

  /* Update for DiscreteIntegrator: '<S389>/Discrete-Time Integrator1' */
  Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_m += 0.01 * rtb_Divide3_d;
  Gen2_ref_DWork->DiscreteTimeIntegrator1_Prev_ko = (int8_T)
    rtb_LogicalOperator_in;

  /* Update for Delay: '<S389>/Delay2' */
  Gen2_ref_DWork->Delay2_DSTATE_h = Gen2_ref_B->sf_MATLABFunction1_ep.LamOut;

  /* Update for DiscreteIntegrator: '<S389>/Discrete-Time Integrator' incorporates:
   *  Sum: '<S389>/Sum4'
   *  Sum: '<S389>/Sum5'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_c = 0U;
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_hn += ((rtb_Product1 + r) +
    FILT_IN) * 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_b = (int8_T)
    Gen2_ref_B->sf_MATLABFunction_a.ireset;

  /* Update for Delay: '<S394>/Delay' */
  Gen2_ref_DWork->icLoad_ht = false;
  Gen2_ref_DWork->Delay_DSTATE_fo = rtb_Divide2_a;

  /* End of Outputs for SubSystem: '<S343>/PID_Power' */

  /* Sum: '<S345>/Sum1' incorporates:
   *  Constant: '<S345>/Constant1'
   *  DiscreteIntegrator: '<S345>/Discrete-Time Integrator'
   *  Gain: '<S343>/2Pa'
   *  Product: '<S345>/Product'
   *  Product: '<S345>/Product1'
   *  Sum: '<S345>/Sum'
   *  Sum: '<S7>/Sum'
   */
  rtb_Pa2bar_o = (100000.0 * Gen2_ref_B->sf_MATLABFunction1_ep.LamOut +
                  rtb_Pa2bar_k) * Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE
    + (1.0 - Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE) *
    Gen2_ref_B->p2sfilt.Switch;

  /* Product: '<S795>/delta rise limit' */
  rtb_mbar2pa_g = rtb_Divide_mr_tmp_0;

  /* DiscreteIntegrator: '<S760>/Discrete-Time Integrator' */
  if (rtb_bResetHlci || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_i != 0))
  {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h = 1.0;
  }

  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h = 0.0;
  }

  /* Logic: '<S760>/Logical Operator' incorporates:
   *  Constant: '<S760>/Constant2'
   *  DiscreteIntegrator: '<S760>/Discrete-Time Integrator'
   *  RelationalOperator: '<S760>/Relational Operator'
   */
  rtb_LogicalOperator1_j = ((0.99 <=
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h) || rtb_bResetHlci);

  /* Delay: '<S795>/Delay' */
  Gen2_ref_DWork->icLoad_h = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_m == 1)
    != (int32_T)rtb_LogicalOperator1_j) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_m != 3)) || rtb_LogicalOperator1_j
    || Gen2_ref_DWork->icLoad_h);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_m = rtb_LogicalOperator1_j;
  if (Gen2_ref_DWork->icLoad_h) {
    Gen2_ref_DWork->Delay_DSTATE_b = rtb_bar2Pa6;
  }

  /* Sum: '<S795>/Difference Inputs1' incorporates:
   *  Delay: '<S795>/Delay'
   *  Switch: '<S795>/etaVolConst'
   */
  rtb_Switch_jz = rtb_bar2Pa6 - Gen2_ref_DWork->Delay_DSTATE_b;

  /* Switch: '<S798>/Switch2' incorporates:
   *  RelationalOperator: '<S798>/LowerRelop1'
   */
  if (!(rtb_Switch_jz > rtb_mbar2pa_g)) {
    /* Product: '<S795>/delta fall limit' incorporates:
     *  Gain: '<S760>/Gain15'
     *  SampleTimeMath: '<S795>/sample time'
     *
     * About '<S795>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_rKK2_k = -rtb_Switch_ct_tmp * 0.01;

    /* Switch: '<S798>/Switch' incorporates:
     *  RelationalOperator: '<S798>/UpperRelop'
     */
    if (rtb_Switch_jz < rtb_rKK2_k) {
      rtb_mbar2pa_g = rtb_rKK2_k;
    } else {
      rtb_mbar2pa_g = rtb_Switch_jz;
    }

    /* End of Switch: '<S798>/Switch' */
  }

  /* End of Switch: '<S798>/Switch2' */

  /* Sum: '<S795>/Difference Inputs2' incorporates:
   *  Delay: '<S795>/Delay'
   */
  rtb_Switch_jz = rtb_mbar2pa_g + Gen2_ref_DWork->Delay_DSTATE_b;

  /* Outputs for Atomic SubSystem: '<S760>/p2sfilt' */
  Gen2_ref_N_TC_HP_filt(rtb_Switch_jz,
                        Gen2_ref_B->BusInput3.traj.rTiF_Pr_p2s_Man,
                        rtb_LogicalOperator1_j, &Gen2_ref_B->p2sfilt_l,
                        &Gen2_ref_DWork->p2sfilt_l, inst);

  /* End of Outputs for SubSystem: '<S760>/p2sfilt' */

  /* Gain: '<S432>/bar2mbar1' incorporates:
   *  Gain: '<S430>/bar2mbar1'
   */
  rtb_mbar2pa_i = 1000.0 * Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  rtb_mbar2pa_g = rtb_mbar2pa_i;

  /* Sum: '<S424>/Sum4' incorporates:
   *  Constant: '<S424>/Constant2'
   */
  rtb_Switch2_l = Gen2_ref_B->BusInput3.SpeedCtrl.rLSLff2load_lim + 1.0;

  /* Outputs for Atomic SubSystem: '<S424>/speed Filter' */
  Gen2_ref_N_TC_HP_filt(rtb_Switch_i5[0],
                        Gen2_ref_B->BusInput3.SpeedCtrl.rTiF_SpeedffRefDroop,
                        rtb_bResetHlci, &Gen2_ref_B->speedFilter,
                        &Gen2_ref_DWork->speedFilter, inst);

  /* End of Outputs for SubSystem: '<S424>/speed Filter' */

  /* Switch: '<S424>/Switch1' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bffRefDroopMeasSpeed) {
    /* Switch: '<S424>/Switch2' */
    if (Gen2_ref_B->BusInput3.SpeedCtrl.bffRefDroopFiltMeasSpd) {
      rtb_bResetHlci_0 = Gen2_ref_B->speedFilter.Switch;
    } else {
      rtb_bResetHlci_0 = rtb_Switch_i5[0];
    }

    /* End of Switch: '<S424>/Switch2' */
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rN_Nom;
  }

  /* End of Switch: '<S424>/Switch1' */

  /* Sum: '<S424>/Sum2' */
  rtb_rKK2_k = rtb_Switch_i5[1] - rtb_bResetHlci_0;

  /* Outputs for Atomic SubSystem: '<S424>/Filter1' */
  Gen2_ref_Filter1(rtb_rKK2_k, Gen2_ref_B->BusInput3.SpeedCtrl.rTiF_LSLff_d,
                   rtb_bResetHlci, &Gen2_ref_B->Filter1_f,
                   &Gen2_ref_DWork->Filter1_f, inst);

  /* End of Outputs for SubSystem: '<S424>/Filter1' */

  /* Product: '<S424>/Divide2' */
  rtb_Divide2_a = Gen2_ref_B->Filter1_f.Switch1 *
    Gen2_ref_B->BusInput3.SpeedCtrl.rLSLff2load_d;

  /* Saturate: '<S424>/Saturation' */
  if (Gen2_ref_B->BusInput3.eng.rN_Nom <= 1.0) {
    rtb_bResetHlci_0 = 1.0;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rN_Nom;
  }

  /* End of Saturate: '<S424>/Saturation' */

  /* Product: '<S424>/Divide' */
  rtb_Divide_kp = rtb_rKK2_k / rtb_bResetHlci_0 *
    Gen2_ref_B->BusInput3.SpeedCtrl.rLSLff2load;

  /* Product: '<S424>/Divide1' incorporates:
   *  Constant: '<S424>/Constant'
   *  Sum: '<S424>/Sum3'
   */
  rtb_rKK2_k = ((rtb_Divide2_a + rtb_Divide_kp) + 1.0) *
    Gen2_ref_B->BusInput3.SpeedCtrl.rff2load_Ext;

  /* Switch: '<S479>/Switch2' incorporates:
   *  RelationalOperator: '<S479>/LowerRelop1'
   */
  if (rtb_rKK2_k > rtb_Switch2_l) {
    rtb_Sum1_jz = rtb_Switch2_l;
  } else {
    /* Sum: '<S424>/Sum1' incorporates:
     *  Constant: '<S424>/Constant1'
     */
    rtb_Sum1_jz = 1.0 - Gen2_ref_B->BusInput3.SpeedCtrl.rLSLff2load_lim;

    /* Switch: '<S479>/Switch' incorporates:
     *  Constant: '<S424>/Constant1'
     *  RelationalOperator: '<S479>/UpperRelop'
     *  Sum: '<S424>/Sum1'
     */
    if (!(rtb_rKK2_k < 1.0 - Gen2_ref_B->BusInput3.SpeedCtrl.rLSLff2load_lim)) {
      rtb_Sum1_jz = rtb_rKK2_k;
    }

    /* End of Switch: '<S479>/Switch' */
  }

  /* End of Switch: '<S479>/Switch2' */

  /* Saturate: '<S761>/Saturation2' */
  if (rtb_Switch_i5[2] > 1.0) {
    rtb_rKK2_k = 1.0;
  } else if (rtb_Switch_i5[2] < 0.1) {
    rtb_rKK2_k = 0.1;
  } else {
    rtb_rKK2_k = rtb_Switch_i5[2];
  }

  /* End of Saturate: '<S761>/Saturation2' */

  /* Outputs for Atomic SubSystem: '<S761>/Filter1' */
  /* UnitDelay: '<S761>/Unit Delay2' */
  Gen2_ref_Filter3(Gen2_ref_DWork->UnitDelay2_DSTATE,
                   Gen2_ref_B->BusInput3.LoadEst.rTiFCorrUnom,
                   Gen2_ref_ConstB.Constant1_g, rtb_bResetHlci,
                   &Gen2_ref_B->Filter1_p, &Gen2_ref_DWork->Filter1_p, inst);

  /* End of Outputs for SubSystem: '<S761>/Filter1' */

  /* Sum: '<S761>/Sum1' */
  rtb_Switch_iy = rtb_rKK2_k + Gen2_ref_B->Filter1_p.Switch;

  /* Math: '<S761>/Math Function1' */
  if ((rtb_Switch_iy < 0.0) && (Gen2_ref_B->BusInput3.LoadEst.rNu > floor
       (Gen2_ref_B->BusInput3.LoadEst.rNu))) {
    rtb_Switch_iy = -rt_powd_snf(-rtb_Switch_iy,
      Gen2_ref_B->BusInput3.LoadEst.rNu, inst);
  } else {
    rtb_Switch_iy = rt_powd_snf(rtb_Switch_iy, Gen2_ref_B->BusInput3.LoadEst.rNu, inst);
  }

  /* End of Math: '<S761>/Math Function1' */

  /* Abs: '<S799>/Abs' */
  rtb_Switch2_l = fabs(rtb_Switch_iy);

  /* Switch: '<S799>/Switch' incorporates:
   *  Constant: '<S799>/Constant2'
   *  RelationalOperator: '<S799>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_l) {
    rtb_Switch_iy = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S799>/Switch' */

  /* Switch: '<S761>/Switch2' incorporates:
   *  Constant: '<S761>/Constant2'
   *  Product: '<S761>/Divide'
   *  Product: '<S761>/Divide1'
   *  Product: '<S761>/Divide2'
   *  Sum: '<S761>/Sum2'
   *  Sum: '<S761>/Sum3'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bAddLSLfac) {
    rtb_Switch2_gs = (rtb_Sum1_jz - 1.0) * rtb_Product1_aq + rtb_Switch_i5[3] /
      rtb_Switch_iy;
  } else {
    rtb_Switch2_gs = rtb_Switch_i5[3] / rtb_Switch_iy * rtb_Sum1_jz;
  }

  /* Outputs for Atomic SubSystem: '<S761>/Filter' */
  Gen2_ref_Pd_filt(rtb_Switch2_gs, Gen2_ref_B->BusInput3.LoadEst.rTiF_PowEst,
                   rtb_Switch_i5[3], rtb_bResetHlci, &Gen2_ref_B->Filter_kj,
                   &Gen2_ref_DWork->Filter_kj, inst);

  /* End of Outputs for SubSystem: '<S761>/Filter' */

  /* Switch: '<S761>/Switch' */
  if (Gen2_ref_B->BusInput3.LoadEst.bFilterOFF) {
    rtb_Switch_bs = rtb_Switch2_gs;
  } else {
    rtb_Switch_bs = Gen2_ref_B->Filter_kj.Switch;
  }

  /* End of Switch: '<S761>/Switch' */

  /* Gain: '<S758>/W2kW' */
  rtb_W2kW_o = 0.001 * rtb_Switch_bs;

  /* Switch: '<S792>/Switch2' incorporates:
   *  RelationalOperator: '<S792>/LowerRelop1'
   */
  if (rtb_W2kW_o > Gen2_ref_B->BusInput3.eng.rP_Nom) {
    rtb_Divide6_n = Gen2_ref_B->BusInput3.eng.rP_Nom;
  } else {
    /* Product: '<S789>/Divide6' */
    rtb_Divide6_n = Gen2_ref_B->BusInput3.eng.rP_Nom *
      Gen2_ref_B->BusInput3.leanox.rP_P2sRedIP_SP_Norm;

    /* Switch: '<S792>/Switch' incorporates:
     *  RelationalOperator: '<S792>/UpperRelop'
     */
    if (!(rtb_W2kW_o < rtb_Divide6_n)) {
      rtb_Divide6_n = rtb_W2kW_o;
    }

    /* End of Switch: '<S792>/Switch' */
  }

  /* End of Switch: '<S792>/Switch2' */

  /* MATLAB Function: '<S789>/2-point interpolation, with extrapolation' */
  upointinterpolationwithextrapol(rtb_Divide6_n,
    Gen2_ref_B->BusInput3.leanox.Comp_IgnP_x,
    Gen2_ref_B->BusInput3.leanox.Comp_IgnP_y,
    &Gen2_ref_B->sf_2pointinterpolationwithext_a, inst);

  /* Switch: '<S789>/Switch1' incorporates:
   *  Constant: '<S789>/Pel_a (kW)1'
   *  DataTypeConversion: '<S4>/Data Type Conversion22'
   *  Product: '<S789>/Divide5'
   *  Sum: '<S789>/Add12'
   */
  if (Gen2_ref_B->BusInput3.leanox.bZZPKorr) {
    rtb_Switch2_l = (Gen2_ref_B->BusInput.rCA_Ign_OP_Power -
                     Gen2_ref_B->N_TC_HP_filt.Switch) *
      Gen2_ref_B->sf_2pointinterpolationwithext_a.y;
  } else {
    rtb_Switch2_l = 0.0;
  }

  /* End of Switch: '<S789>/Switch1' */

  /* Switch: '<S793>/Switch2' incorporates:
   *  RelationalOperator: '<S793>/LowerRelop1'
   */
  if (rtb_W2kW_o > Gen2_ref_B->BusInput3.eng.rP_Nom) {
    rtb_Divide6_n = Gen2_ref_B->BusInput3.eng.rP_Nom;
  } else {
    /* Product: '<S789>/Divide1' */
    rtb_Divide6_n = Gen2_ref_B->BusInput3.eng.rP_Nom *
      Gen2_ref_B->BusInput3.leanox.rP2s_Comp_Act_SP;

    /* Switch: '<S793>/Switch' incorporates:
     *  RelationalOperator: '<S793>/UpperRelop'
     */
    if (!(rtb_W2kW_o < rtb_Divide6_n)) {
      rtb_Divide6_n = rtb_W2kW_o;
    }

    /* End of Switch: '<S793>/Switch' */
  }

  /* End of Switch: '<S793>/Switch2' */

  /* MATLAB Function: '<S789>/2-point interpolation, with extrapolation1' */
  upointinterpolationwithextrapol(rtb_Divide6_n,
    Gen2_ref_B->BusInput3.leanox.Comp_ChTmp_x,
    Gen2_ref_B->BusInput3.leanox.Comp_ChTmp_y,
    &Gen2_ref_B->sf_2pointinterpolationwithex_je, inst);

  /* Switch: '<S789>/Switch2' incorporates:
   *  Constant: '<S789>/Pel_a (kW)2'
   *  Product: '<S789>/Divide9'
   *  Sum: '<S789>/Add13'
   */
  if (Gen2_ref_B->BusInput3.leanox.bt2Korr) {
    rtb_bResetHlci_0 = (Gen2_ref_B->T2s_filt.Switch -
                        Gen2_ref_B->BusInput3.leanox.rT_2) *
      Gen2_ref_B->sf_2pointinterpolationwithex_je.y;
  } else {
    rtb_bResetHlci_0 = 0.0;
  }

  /* End of Switch: '<S789>/Switch2' */

  /* Switch: '<S789>/Switch3' incorporates:
   *  Constant: '<S789>/Pel_a (kW)3'
   */
  if (Gen2_ref_B->BusInput3.leanox.bHum_Act) {
    delta_y = Gen2_ref_B->BusInput3.leanox.rP2s_Comp_HumOffset;
  } else {
    delta_y = 0.0;
  }

  /* End of Switch: '<S789>/Switch3' */

  /* Sum: '<S775>/Add11' */
  rtb_Divide6_n = (rtb_Switch2_l + rtb_bResetHlci_0) + delta_y;

  /* Switch: '<S758>/Switch1' incorporates:
   *  Product: '<S758>/Divide6'
   *  Sum: '<S758>/Add4'
   */
  if (Gen2_ref_B->BusInput.tLEANOXin.bZylAusfall) {
    /* Switch: '<S771>/Switch' incorporates:
     *  Abs: '<S771>/Abs'
     *  Constant: '<S771>/Constant2'
     *  RelationalOperator: '<S771>/Relational Operator'
     */
    if (1.0 >= fabs(Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng)) {
      rtb_bResetHlci_0 = 1.0;
    } else {
      rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
    }

    /* End of Switch: '<S771>/Switch' */
    rtb_Switch1_k = rtb_W2kW_o / rtb_bResetHlci_0 + rtb_W2kW_o;
  } else {
    rtb_Switch1_k = rtb_W2kW_o;
  }

  /* End of Switch: '<S758>/Switch1' */

  /* Switch: '<S432>/Switch' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bRefSpeedLEANOX) {
    rtb_Switch2_n5 = rtb_Switch_i5[1];
  } else {
    rtb_Switch2_n5 = Gen2_ref_B->BusInput3.eng.rN_Nom;
  }

  /* End of Switch: '<S432>/Switch' */

  /* Switch: '<S762>/Switch' incorporates:
   *  Abs: '<S762>/Abs'
   *  Constant: '<S762>/Constant2'
   *  RelationalOperator: '<S762>/Relational Operator'
   */
  if (1.0 >= fabs(rtb_Switch2_n5)) {
    rtb_Switch2_n5 = 1.0;
  }

  /* End of Switch: '<S762>/Switch' */

  /* Switch: '<S758>/Switch4' */
  if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena) {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rP_c;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rP_1;
  }

  /* End of Switch: '<S758>/Switch4' */

  /* Switch: '<S758>/Switch2' incorporates:
   *  Logic: '<S758>/Logical Operator1'
   *  Product: '<S758>/Divide4'
   *  RelationalOperator: '<S758>/Relational Operator1'
   *  RelationalOperator: '<S758>/Relational Operator3'
   *  Sum: '<S758>/Add5'
   *  Switch: '<S758>/Switch5'
   */
  if (rtb_Switch1_k < rtb_bResetHlci_0) {
    /* Switch: '<S758>/Switch_b_c' incorporates:
     *  Logic: '<S758>/Logical Operator'
     *  RelationalOperator: '<S758>/Relational Operator2'
     */
    if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena && (rtb_Switch1_k <
         Gen2_ref_B->BusInput3.leanox.rP_c)) {
      /* SignalConversion generated from: '<S758>/Lookup Table Dynamic1' */
      rtb_TmpSignalConversionAtLoo_ht[0] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_0;

      /* Switch: '<S772>/Switch' incorporates:
       *  Abs: '<S772>/Abs'
       *  Constant: '<S772>/Constant2'
       *  RelationalOperator: '<S772>/Relational Operator'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_c)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_c;
      }

      /* End of Switch: '<S772>/Switch' */

      /* SignalConversion generated from: '<S758>/Lookup Table Dynamic1' incorporates:
       *  Product: '<S758>/Divide5'
       */
      rtb_TmpSignalConversionAtLoo_ht[1] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_c *
        Gen2_ref_B->BusInput3.leanox.rN_c / rtb_bResetHlci_0 *
        Gen2_ref_B->T2s_filt.Switch / rtb_Switch2_n5;

      /* SignalConversion generated from: '<S758>/Lookup Table Dynamic1' incorporates:
       *  Constant: '<S758>/Pel_a (kW)1'
       */
      rtb_TmpSignalConversionAtLook_d[0] = 0.0;
      rtb_TmpSignalConversionAtLook_d[1] = Gen2_ref_B->BusInput3.leanox.rP_c;

      /* S-Function (sfix_look1_dyn): '<S758>/Lookup Table Dynamic1' */
      /* Dynamic Look-Up Table Block: '<S758>/Lookup Table Dynamic1'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_LookupTableDynamic1_b),
                           &rtb_TmpSignalConversionAtLoo_ht[0], rtb_Switch1_k,
                           &rtb_TmpSignalConversionAtLook_d[0], 1U, inst);
      rtb_Switch2_n5 = rtb_LookupTableDynamic1_b;
    } else {
      /* SignalConversion generated from: '<S758>/Lookup Table Dynamic' */
      rtb_TmpSignalConversionAtLoo_ht[0] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_0;

      /* Switch: '<S770>/Switch' incorporates:
       *  Abs: '<S770>/Abs'
       *  Constant: '<S770>/Constant2'
       *  RelationalOperator: '<S770>/Relational Operator'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_1)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_1;
      }

      /* End of Switch: '<S770>/Switch' */

      /* SignalConversion generated from: '<S758>/Lookup Table Dynamic' incorporates:
       *  Product: '<S758>/Divide1'
       */
      rtb_TmpSignalConversionAtLoo_ht[1] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
        Gen2_ref_B->BusInput3.leanox.rN_1 / rtb_bResetHlci_0 *
        Gen2_ref_B->T2s_filt.Switch / rtb_Switch2_n5;

      /* SignalConversion generated from: '<S758>/Lookup Table Dynamic' incorporates:
       *  Constant: '<S758>/Pel_a (kW)3'
       */
      rtb_TmpSignalConversionAtLook_d[0] = 0.0;
      rtb_TmpSignalConversionAtLook_d[1] = Gen2_ref_B->BusInput3.leanox.rP_1;

      /* S-Function (sfix_look1_dyn): '<S758>/Lookup Table Dynamic' */
      /* Dynamic Look-Up Table Block: '<S758>/Lookup Table Dynamic'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_LookupTableDynamic_m),
                           &rtb_TmpSignalConversionAtLoo_ht[0], rtb_Switch1_k,
                           &rtb_TmpSignalConversionAtLook_d[0], 1U, inst);
      rtb_Switch2_n5 = rtb_LookupTableDynamic_m;
    }

    /* End of Switch: '<S758>/Switch_b_c' */
  } else {
    if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena && (rtb_Switch1_k <
         Gen2_ref_B->BusInput3.leanox.rP_1)) {
      /* Sum: '<S758>/Add1' incorporates:
       *  Switch: '<S758>/Switch5'
       */
      rtb_Switch_jv = Gen2_ref_B->BusInput3.leanox.rP_1 -
        Gen2_ref_B->BusInput3.leanox.rP_c;

      /* Sum: '<S758>/Sum4' incorporates:
       *  Switch: '<S758>/Switch5'
       */
      rtb_Switch_fi = Gen2_ref_B->BusInput3.leanox.rP_c +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S765>/Switch' incorporates:
       *  Abs: '<S765>/Abs'
       *  Constant: '<S765>/Constant2'
       *  RelationalOperator: '<S765>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(rtb_Switch_fi)) {
        rtb_PactOut_o = 1.0;
      } else {
        rtb_PactOut_o = rtb_Switch_fi;
      }

      /* End of Switch: '<S765>/Switch' */

      /* Sum: '<S758>/Sum5' incorporates:
       *  Switch: '<S758>/Switch5'
       */
      rtb_Switch_fi = Gen2_ref_B->BusInput3.leanox.rP_1 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S773>/Switch' incorporates:
       *  Abs: '<S773>/Abs'
       *  Constant: '<S773>/Constant2'
       *  RelationalOperator: '<S773>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_1)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_1;
      }

      /* End of Switch: '<S773>/Switch' */

      /* Switch: '<S764>/Switch' incorporates:
       *  Abs: '<S764>/Abs'
       *  Constant: '<S764>/Constant2'
       *  RelationalOperator: '<S764>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(rtb_Switch_fi)) {
        rtb_Switch_fi = 1.0;
      }

      /* End of Switch: '<S764>/Switch' */

      /* Product: '<S758>/rKK3' incorporates:
       *  Switch: '<S758>/Switch5'
       */
      rtb_Switch_fi = Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
        Gen2_ref_B->BusInput3.leanox.rN_1 / rtb_bResetHlci_0 / rtb_Switch_fi;

      /* Switch: '<S766>/Switch' incorporates:
       *  Abs: '<S766>/Abs'
       *  Constant: '<S766>/Constant2'
       *  RelationalOperator: '<S766>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_c)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_c;
      }

      /* End of Switch: '<S766>/Switch' */

      /* Switch: '<S774>/Switch' incorporates:
       *  Abs: '<S774>/Abs'
       *  Constant: '<S774>/Constant2'
       *  RelationalOperator: '<S774>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(rtb_Switch_jv)) {
        rtb_Switch_jv = 1.0;
      }

      /* End of Switch: '<S774>/Switch' */

      /* Switch: '<S758>/Switch5' incorporates:
       *  Product: '<S758>/Divide10'
       *  Product: '<S758>/Divide9'
       *  Product: '<S758>/rKK4'
       *  Sum: '<S758>/Add3'
       *  Sum: '<S758>/Sum6'
       *  Sum: '<S758>/Sum7'
       */
      rtb_W2kW_o = (rtb_Switch_fi - Gen2_ref_B->BusInput3.leanox.rPr_mbar_c *
                    Gen2_ref_B->BusInput3.leanox.rN_c / rtb_bResetHlci_0 /
                    rtb_PactOut_o) / rtb_Switch_jv * (rtb_W2kW_o -
        Gen2_ref_B->BusInput3.leanox.rP_1) + rtb_Switch_fi;
    } else {
      /* Sum: '<S758>/Add10' incorporates:
       *  Switch: '<S758>/Switch5'
       */
      rtb_Switch_jv = Gen2_ref_B->BusInput3.leanox.rP_2 -
        Gen2_ref_B->BusInput3.leanox.rP_1;

      /* Sum: '<S758>/Sum' incorporates:
       *  Switch: '<S758>/Switch5'
       */
      rtb_PactOut_o = Gen2_ref_B->BusInput3.leanox.rP_1 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Sum: '<S758>/Sum1' incorporates:
       *  Switch: '<S758>/Switch5'
       */
      rtb_Switch_fi = Gen2_ref_B->BusInput3.leanox.rP_2 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S763>/Switch' incorporates:
       *  Abs: '<S763>/Abs'
       *  Constant: '<S763>/Constant2'
       *  RelationalOperator: '<S763>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_2)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_2;
      }

      /* End of Switch: '<S763>/Switch' */

      /* Switch: '<S768>/Switch' incorporates:
       *  Abs: '<S768>/Abs'
       *  Constant: '<S768>/Constant2'
       *  RelationalOperator: '<S768>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(rtb_Switch_fi)) {
        rtb_Switch_fi = 1.0;
      }

      /* End of Switch: '<S768>/Switch' */

      /* Product: '<S758>/rKK1' incorporates:
       *  Switch: '<S758>/Switch5'
       */
      rtb_Switch_fi = Gen2_ref_B->BusInput3.leanox.rPr_mbar_2 *
        Gen2_ref_B->BusInput3.leanox.rN_2 / rtb_bResetHlci_0 / rtb_Switch_fi;

      /* Switch: '<S769>/Switch' incorporates:
       *  Abs: '<S769>/Abs'
       *  Constant: '<S769>/Constant2'
       *  RelationalOperator: '<S769>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(rtb_PactOut_o)) {
        rtb_PactOut_o = 1.0;
      }

      /* End of Switch: '<S769>/Switch' */

      /* Switch: '<S767>/Switch' incorporates:
       *  Abs: '<S767>/Abs'
       *  Constant: '<S767>/Constant2'
       *  RelationalOperator: '<S767>/Relational Operator'
       *  Switch: '<S758>/Switch5'
       */
      if (1.0 >= fabs(rtb_Switch_jv)) {
        rtb_Switch_jv = 1.0;
      }

      /* End of Switch: '<S767>/Switch' */

      /* Switch: '<S758>/Switch5' incorporates:
       *  Product: '<S758>/Divide2'
       *  Product: '<S758>/Divide3'
       *  Product: '<S758>/rKK2'
       *  Sum: '<S758>/Add2'
       *  Sum: '<S758>/Sum2'
       *  Sum: '<S758>/Sum3'
       */
      rtb_W2kW_o = (rtb_Switch_fi - Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
                    Gen2_ref_B->BusInput3.leanox.rN_1 /
                    Gen2_ref_B->BusInput3.leanox.rT_1 / rtb_PactOut_o) /
        rtb_Switch_jv * (rtb_W2kW_o - Gen2_ref_B->BusInput3.leanox.rP_2) +
        rtb_Switch_fi;
    }

    rtb_Switch2_n5 = rtb_W2kW_o * Gen2_ref_B->T2s_filt.Switch *
      (Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict + rtb_Switch1_k) /
      rtb_Switch2_n5;
  }

  /* End of Switch: '<S758>/Switch2' */

  /* Product: '<S775>/Divide8' incorporates:
   *  DataTypeConversion: '<S775>/Data Type Conversion2'
   */
  rtb_Switch1_k = rtb_Switch2_n5 *
    Gen2_ref_B->BusInput.tLEANOXin.rLEANOX_fact_BC;

  /* Outputs for Atomic SubSystem: '<S585>/Filter1' */
  Gen2_ref_N_TC_HP_filt(rtb_Switch_i5[3],
                        Gen2_ref_B->BusInput3.SkipF.rTi_StatSkipF_FiltP,
                        rtb_bResetBdc, &Gen2_ref_B->Filter1_fg,
                        &Gen2_ref_DWork->Filter1_fg, inst);

  /* End of Outputs for SubSystem: '<S585>/Filter1' */

  /* Sum: '<S589>/Sum' */
  rtb_Switch2_l = Gen2_ref_B->BusInput3.SkipF.rNum_P0;

  /* Abs: '<S596>/Abs' */
  rtb_W2kW_o = rtb_Switch2_ba;

  /* Switch: '<S585>/Switch' */
  if (Gen2_ref_B->BusInput3.SkipF.bStatSkipF_FiltP_active) {
    rtb_bResetHlci_0 = Gen2_ref_B->Filter1_fg.Switch;
  } else {
    rtb_bResetHlci_0 = rtb_Switch_i5[3];
  }

  /* End of Switch: '<S585>/Switch' */

  /* Switch: '<S596>/Switch' incorporates:
   *  Constant: '<S596>/Constant2'
   *  RelationalOperator: '<S596>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_W2kW_o) {
    rtb_Divide_mr_tmp = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S596>/Switch' */

  /* Sum: '<S589>/Sum3' incorporates:
   *  Gain: '<S589>/Gain'
   *  Product: '<S589>/Divide'
   *  Product: '<S589>/Product'
   *  Sum: '<S589>/Sum2'
   */
  rtb_W2kW_o = Gen2_ref_B->BusInput3.SkipF.rNum_P0 - (0.001 * rtb_bResetHlci_0 -
    Gen2_ref_B->BusInput3.SkipF.rP_0) * (rtb_Switch2_l / rtb_Divide_mr_tmp);

  /* Switch: '<S598>/Switch2' incorporates:
   *  Constant: '<S589>/Constant1'
   *  RelationalOperator: '<S598>/LowerRelop1'
   *  RelationalOperator: '<S598>/UpperRelop'
   *  Switch: '<S598>/Switch'
   */
  if (rtb_W2kW_o > Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng) {
    rtb_W2kW_o = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  } else if (rtb_W2kW_o < 0.0) {
    /* Switch: '<S598>/Switch' incorporates:
     *  Constant: '<S589>/Constant1'
     */
    rtb_W2kW_o = 0.0;
  }

  /* End of Switch: '<S598>/Switch2' */

  /* MATLAB Function: '<S589>/MATLAB Function' */
  Gen2_ref_MATLABFunction_n(rtb_W2kW_o, Gen2_ref_B->BusInput3.SkipF.rHy_eps,
    &Gen2_ref_B->sf_MATLABFunction_n, &Gen2_ref_DWork->sf_MATLABFunction_n, inst);

  /* Gain: '<S586>/Gain1' */
  rtb_W2kW_o = rtb_Product1_aq;

  /* Switch: '<S600>/Switch' incorporates:
   *  Abs: '<S600>/Abs'
   *  Constant: '<S600>/Constant2'
   *  RelationalOperator: '<S600>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_W2kW_o)) {
    rtb_W2kW_o = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S600>/Switch' */

  /* Product: '<S586>/Divide' */
  rtb_Switch_jv = rtb_Switch_i5[3] / rtb_W2kW_o;

  /* S-Function (sfix_look1_dyn): '<S586>/Lookup Table Dynamic' */
  /* Dynamic Look-Up Table Block: '<S586>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_W2kW_o), &Gen2_ref_B->BusInput3.SkipF.rLamRefSkip
                       [0], rtb_Switch_jv,
                       &Gen2_ref_B->BusInput3.SkipF.rPrefSkipNorm[0], 1U, inst);

  /* Sum: '<S586>/Sum4' incorporates:
   *  DiscreteIntegrator: '<S579>/Discrete-Time Integrator'
   */
  rtb_W2kW_o = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_m - rtb_W2kW_o;

  /* MinMax: '<S586>/MinMax' */
  if ((Gen2_ref_B->BusInput3.SkipF.rPrefSkipNorm[0] >=
       Gen2_ref_B->BusInput3.SkipF.rPrefSkipNorm[1]) || rtIsNaN
      (Gen2_ref_B->BusInput3.SkipF.rPrefSkipNorm[1])) {
    rtb_PactOut_o = Gen2_ref_B->BusInput3.SkipF.rPrefSkipNorm[0];
  } else {
    rtb_PactOut_o = Gen2_ref_B->BusInput3.SkipF.rPrefSkipNorm[1];
  }

  /* MATLAB Function: '<S586>/MATLAB Function' incorporates:
   *  MinMax: '<S586>/MinMax'
   */
  if (rtb_Switch_jv > rtb_PactOut_o) {
    rtb_Switch_jv = 0.0;
  } else if (rtb_Switch_jv < 0.9 * rtb_PactOut_o) {
    rtb_Switch_jv = 1.0;
  } else {
    rtb_Switch_jv = Gen2_ref_DWork->y_z;
  }

  Gen2_ref_DWork->y_z = rtb_Switch_jv;

  /* End of MATLAB Function: '<S586>/MATLAB Function' */

  /* Sum: '<S429>/Sum' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion34'
   *  Sum: '<S581>/Sum2'
   */
  rtb_Divide_mr_tmp = rtb_Switch_ks - Gen2_ref_B->BusInput.rN_Eng_LRskipF;

  /* Gain: '<S586>/Gain3' */
  rtb_Switch2_l = -2.0 * Gen2_ref_B->BusInput3.SkipF.rN_LevelNskip;

  /* Logic: '<S586>/Logical Operator' incorporates:
   *  Constant: '<S586>/Constant4'
   *  RelationalOperator: '<S586>/Relational Operator1'
   *  Sum: '<S429>/Sum'
   *  Sum: '<S586>/Sum6'
   */
  rtb_LogicalOperator1_j = ((1.0 - rtb_Switch_jv != 0.0) || (rtb_Divide_mr_tmp <=
    rtb_Switch2_l));

  /* DiscreteIntegrator: '<S586>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator1_j || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_k
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_p = 0.0;
  }

  /* Product: '<S586>/Product1' incorporates:
   *  DiscreteIntegrator: '<S586>/Discrete-Time Integrator'
   *  Product: '<S586>/Product2'
   *  Sum: '<S586>/Sum9'
   */
  rtb_Switch_fi = (rtb_W2kW_o * Gen2_ref_B->BusInput3.SkipF.rKpTrackLam +
                   Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_p) *
    rtb_Switch_jv;

  /* DataTypeConversion: '<S585>/Data Type Conversion1' */
  rtb_Switch2_l = Gen2_ref_B->BusInput3.SkipF.rNum_reserve;

  /* Sum: '<S585>/Sum1' incorporates:
   *  Sum: '<S585>/Sum5'
   */
  rtb_Switch_jv = (Gen2_ref_B->sf_MATLABFunction_n.y + rtb_Switch_fi) +
    rtb_Switch2_l;

  /* MinMax: '<S585>/MinMax' */
  if ((Gen2_ref_B->BusInput.iN_Skip_Ext >= rtb_Switch_jv) || rtIsNaN
      (rtb_Switch_jv)) {
    rtb_Switch_jv = Gen2_ref_B->BusInput.iN_Skip_Ext;
  }

  /* End of MinMax: '<S585>/MinMax' */

  /* Switch: '<S591>/Switch2' incorporates:
   *  Constant: '<S585>/Constant8'
   *  Constant: '<S585>/Constant9'
   *  RelationalOperator: '<S591>/LowerRelop1'
   *  RelationalOperator: '<S591>/UpperRelop'
   *  Sum: '<S585>/Sum8'
   *  Switch: '<S591>/Switch'
   */
  if (rtb_Switch_jv > Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng - 1.0) {
    rtb_Switch2_ba = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng - 1.0;
  } else if (rtb_Switch_jv < 0.0) {
    /* Switch: '<S591>/Switch' incorporates:
     *  Constant: '<S585>/Constant8'
     */
    rtb_Switch2_ba = 0.0;
  } else {
    rtb_Switch2_ba = rtb_Switch_jv;
  }

  /* End of Switch: '<S591>/Switch2' */

  /* Sum: '<S585>/Sum4' */
  rtb_Switch2_n5 = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng - rtb_Switch2_ba;

  /* Switch: '<S590>/Switch2' incorporates:
   *  RelationalOperator: '<S590>/LowerRelop1'
   *  RelationalOperator: '<S590>/UpperRelop'
   *  Switch: '<S590>/Switch'
   */
  if (rtb_Switch2_n5 > Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng) {
    rtb_Switch2_n5 = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  } else if (rtb_Switch2_n5 < 1.0) {
    /* Switch: '<S590>/Switch' */
    rtb_Switch2_n5 = 1.0;
  }

  /* End of Switch: '<S590>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S585>/Filter' */
  /* Product: '<S585>/Divide1' */
  Gen2_ref_Filter3(Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng / rtb_Switch2_n5,
                   Gen2_ref_B->BusInput3.SkipF.rTiF_stat, 1.0, rtb_bResetBdc,
                   &Gen2_ref_B->Filter_n, &Gen2_ref_DWork->Filter_n, inst);

  /* End of Outputs for SubSystem: '<S585>/Filter' */

  /* Switch: '<S8>/Switch2' incorporates:
   *  Constant: '<S8>/Constant2'
   */
  if (Gen2_ref_B->BusInput3.SkipF.bSF_ON) {
    rtb_Divide5_h = Gen2_ref_B->Filter_n.Switch;
  } else {
    rtb_Divide5_h = 1.0;
  }

  /* End of Switch: '<S8>/Switch2' */

  /* MinMax: '<S775>/MinMax' */
  if ((!(rtb_Divide5_h >= Gen2_ref_B->BusInput.tLEANOXin.rHiCtr_Leanox_Corr)) &&
      rtb_bCBV_min) {
    /* MinMax: '<S459>/MinMax' */
    rtb_Divide5_h = Gen2_ref_B->BusInput.tLEANOXin.rHiCtr_Leanox_Corr;
  }

  rtb_Switch2_l = rtb_Divide5_h;

  /* Product: '<S775>/Divide5' incorporates:
   *  Delay: '<S15>/Resettable Delay'
   *  Sum: '<S775>/Add9'
   */
  rtb_Divide6_n = ((rtb_Divide6_n + rtb_Switch1_k) +
                   Gen2_ref_DWork->ResettableDelay_DSTATE) * rtb_Switch2_l;

  /* DataTypeConversion: '<S775>/Data Type Conversion' */
  rtb_Switch2_l = Gen2_ref_B->BusInput.tLEANOXin.rLEANOXoffset;

  /* Sum: '<S432>/Sum' incorporates:
   *  Gain: '<S432>/pa2mbar'
   *  Gain: '<S775>/mbar2pa'
   *  Sum: '<S775>/Add1'
   */
  rtb_Divide6_n = (rtb_Divide6_n + rtb_Switch2_l) * 100.0 * 0.01 +
    Gen2_ref_B->BusInput3.leanox.rPr_Offset_Island;

  /* Switch: '<S759>/Switch2' incorporates:
   *  RelationalOperator: '<S759>/LowerRelop1'
   */
  if (!(rtb_Divide6_n > rtb_mbar2pa_g)) {
    /* Gain: '<S432>/bar2mbar2' */
    rtb_mbar2pa_g = 1000.0 * Gen2_ref_B->BusInput3.traj.rPr_p2s_min;

    /* Switch: '<S759>/Switch' incorporates:
     *  RelationalOperator: '<S759>/UpperRelop'
     */
    if (!(rtb_Divide6_n < rtb_mbar2pa_g)) {
      rtb_mbar2pa_g = rtb_Divide6_n;
    }

    /* End of Switch: '<S759>/Switch' */
  }

  /* End of Switch: '<S759>/Switch2' */

  /* Gain: '<S432>/mbar2pa' */
  rtb_mbar2pa_g *= 100.0;

  /* Sum: '<S760>/Sum1' incorporates:
   *  Constant: '<S760>/Constant1'
   *  DiscreteIntegrator: '<S760>/Discrete-Time Integrator'
   *  Product: '<S760>/Product'
   *  Product: '<S760>/Product1'
   *  Sum: '<S760>/Sum'
   */
  rtb_Switch2_l = (1.0 - Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h) *
    Gen2_ref_B->p2sfilt_l.Switch +
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h * rtb_mbar2pa_g;

  /* Switch: '<Root>/BDC_traj3' */
  if (rtb_LogicalOperator) {
    rtb_Divide_kt = rtb_Pa2bar_o;
  } else {
    rtb_Divide_kt = rtb_Switch2_l;
  }

  /* End of Switch: '<Root>/BDC_traj3' */

  /* Sum: '<S307>/Sum3' incorporates:
   *  Gain: '<S307>/Gain'
   *  Gain: '<S307>/Gain1'
   */
  rtb_Product1_b = 1.0E-5 * rtb_Divide_kt - 1.0E-5 * rtb_p2s;

  /* RelationalOperator: '<S307>/Relational Operator' incorporates:
   *  Abs: '<S307>/Abs'
   */
  rtb_LogicalOperator2_e = (fabs(rtb_Product1_b) >
    Gen2_ref_B->BusInput3.fdc.rThrshSwTransFilt);

  /* DiscreteIntegrator: '<S307>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_e || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_p
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d = 0.0;
  }

  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d = 0.0;
  }

  /* DataTypeConversion: '<S4>/Data Type Conversion2' */
  rtb_Product1_b = Gen2_ref_B->BusInput.tPr.rp1LP;

  /* Gain: '<S4>/bar2Pa' */
  rtb_p1LP = 100000.0 * rtb_Product1_b;

  /* MATLAB Function: '<S305>/FILTER no delay' */
  Gen2_ref_FILTERnodelay(rtb_p1LP, Gen2_ref_B->BusInput3.fdc.TiF_Pr_p1,
    Gen2_ref_B->BusInput3.eng.Ts, rtb_bResetBdc, &Gen2_ref_B->sf_FILTERnodelay,
    &Gen2_ref_DWork->sf_FILTERnodelay, inst);

  /* DataTypeConversion: '<S4>/Data Type Conversion3' */
  rtb_Product1_b = Gen2_ref_B->BusInput.tPr.rp1HP;

  /* Gain: '<S4>/bar2Pa1' */
  rtb_p1HP = 100000.0 * rtb_Product1_b;

  /* MATLAB Function: '<S305>/FILTER no delay1' */
  Gen2_ref_FILTERnodelay(rtb_p1HP, Gen2_ref_B->BusInput3.fdc.TiF_Pr_p2_LP,
    Gen2_ref_B->BusInput3.eng.Ts, rtb_bResetBdc, &Gen2_ref_B->sf_FILTERnodelay1,
    &Gen2_ref_DWork->sf_FILTERnodelay1, inst);

  /* DataTypeConversion: '<S4>/Data Type Conversion4' */
  rtb_Product1_b = Gen2_ref_B->BusInput.tPr.rp2HP;

  /* Gain: '<S4>/bar2Pa2' */
  rtb_p2HP = 100000.0 * rtb_Product1_b;

  /* MATLAB Function: '<S305>/FILTER no delay2' */
  Gen2_ref_FILTERnodelay(rtb_p2HP, Gen2_ref_B->BusInput3.fdc.TiF_Pr_p2_HP,
    Gen2_ref_B->BusInput3.eng.Ts, rtb_bResetBdc, &Gen2_ref_B->sf_FILTERnodelay2,
    &Gen2_ref_DWork->sf_FILTERnodelay2, inst);

  /* MATLAB Function: '<S305>/FILTER no delay3' */
  Gen2_ref_FILTERnodelay(rtb_p2s, Gen2_ref_B->BusInput3.fdc.TiF_Pr_p2s,
    Gen2_ref_B->BusInput3.eng.Ts, rtb_bResetBdc, &Gen2_ref_B->sf_FILTERnodelay3,
    &Gen2_ref_DWork->sf_FILTERnodelay3, inst);

  /* Outputs for Atomic SubSystem: '<S306>/2nd Order Filter' */
  Gen2_ref_undOrderFilter(rtb_p1LP,
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltOmegaPressure,
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltDPressure, rtb_bResetBdc,
    &Gen2_ref_B->undOrderFilter, &Gen2_ref_DWork->undOrderFilter, inst);

  /* End of Outputs for SubSystem: '<S306>/2nd Order Filter' */

  /* Outputs for Atomic SubSystem: '<S306>/2nd Order Filter1' */
  Gen2_ref_undOrderFilter(rtb_p1HP,
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltOmegaPressure,
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltDPressure, rtb_bResetBdc,
    &Gen2_ref_B->undOrderFilter1, &Gen2_ref_DWork->undOrderFilter1, inst);

  /* End of Outputs for SubSystem: '<S306>/2nd Order Filter1' */

  /* Outputs for Atomic SubSystem: '<S306>/2nd Order Filter2' */
  Gen2_ref_undOrderFilter(rtb_p2HP,
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltOmegaPressure,
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltDPressure, rtb_bResetBdc,
    &Gen2_ref_B->undOrderFilter2, &Gen2_ref_DWork->undOrderFilter2, inst);

  /* End of Outputs for SubSystem: '<S306>/2nd Order Filter2' */

  /* Outputs for Atomic SubSystem: '<S306>/2nd Order Filter3' */
  Gen2_ref_undOrderFilter3(rtb_p2s,
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltOmegaPressure,
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltDPressure, rtb_bResetBdc,
    &Gen2_ref_B->undOrderFilter3, &Gen2_ref_DWork->undOrderFilter3, inst);

  /* End of Outputs for SubSystem: '<S306>/2nd Order Filter3' */

  /* Switch: '<S272>/Switch2' */
  if (Gen2_ref_B->BusInput3.fdc.bEnable2ndOrdFiltDerivative) {
    /* Switch: '<S272>/Switch6' incorporates:
     *  Constant: '<S307>/Constant2'
     *  DiscreteIntegrator: '<S307>/Discrete-Time Integrator'
     *  Product: '<S307>/Product'
     *  Product: '<S307>/Product1'
     *  Sum: '<S307>/Sum'
     *  Sum: '<S307>/Sum4'
     */
    if (Gen2_ref_B->BusInput3.fdc.bEnableTransSwFilt) {
      rtb_Switch2_gd_idx_0 = (1.0 -
        Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d) *
        Gen2_ref_B->sf_FILTERnodelay.d_dt +
        Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d *
        Gen2_ref_B->undOrderFilter.Switch1;
      rtb_Switch2_gd_idx_1 = (1.0 -
        Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d) *
        Gen2_ref_B->sf_FILTERnodelay1.d_dt +
        Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d *
        Gen2_ref_B->undOrderFilter1.Switch1;
      rtb_Switch2_gd_idx_2 = (1.0 -
        Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d) *
        Gen2_ref_B->sf_FILTERnodelay2.d_dt +
        Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d *
        Gen2_ref_B->undOrderFilter2.Switch1;
      rtb_Switch2_gd_idx_3 = (1.0 -
        Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d) *
        Gen2_ref_B->sf_FILTERnodelay3.d_dt +
        Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d *
        Gen2_ref_B->undOrderFilter3.Switch1;
    } else {
      rtb_Switch2_gd_idx_0 = Gen2_ref_B->undOrderFilter.Switch1;
      rtb_Switch2_gd_idx_1 = Gen2_ref_B->undOrderFilter1.Switch1;
      rtb_Switch2_gd_idx_2 = Gen2_ref_B->undOrderFilter2.Switch1;
      rtb_Switch2_gd_idx_3 = Gen2_ref_B->undOrderFilter3.Switch1;
    }

    /* End of Switch: '<S272>/Switch6' */
  } else {
    rtb_Switch2_gd_idx_0 = Gen2_ref_B->sf_FILTERnodelay.d_dt;
    rtb_Switch2_gd_idx_1 = Gen2_ref_B->sf_FILTERnodelay1.d_dt;
    rtb_Switch2_gd_idx_2 = Gen2_ref_B->sf_FILTERnodelay2.d_dt;
    rtb_Switch2_gd_idx_3 = Gen2_ref_B->sf_FILTERnodelay3.d_dt;
  }

  /* End of Switch: '<S272>/Switch2' */

  /* DataTypeConversion: '<S4>/Data Type Conversion1' */
  rtb_Product1_b = Gen2_ref_B->BusInput.tT.rT1LP;

  /* Outputs for Atomic SubSystem: '<S196>/T1LP_filt' */
  /* Bias: '<S4>/C2K' */
  Gen2_ref_N_TC_HP_filt(rtb_Product1_b + 273.15,
                        Gen2_ref_B->BusInput3.inFilt.rTiF_T, rtb_bResetBdc,
                        &Gen2_ref_B->T1LP_filt, &Gen2_ref_DWork->T1LP_filt, inst);

  /* End of Outputs for SubSystem: '<S196>/T1LP_filt' */

  /* DataTypeConversion: '<S4>/Data Type Conversion8' */
  rtb_Product1_b = Gen2_ref_B->BusInput.tT.rT1HP;

  /* Outputs for Atomic SubSystem: '<S195>/T1HP_filt' */
  /* Bias: '<S4>/C2K1' */
  Gen2_ref_N_TC_HP_filt(rtb_Product1_b + 273.15,
                        Gen2_ref_B->BusInput3.inFilt.rTiF_T, rtb_bResetBdc,
                        &Gen2_ref_B->T1HP_filt, &Gen2_ref_DWork->T1HP_filt, inst);

  /* End of Outputs for SubSystem: '<S195>/T1HP_filt' */

  /* Outputs for Atomic SubSystem: '<S267>/Mg' */
  Gen2_ref_Mg(Gen2_ref_B->BusInput3.eng.rRho_gas, &Gen2_ref_B->Mg, inst);

  /* End of Outputs for SubSystem: '<S267>/Mg' */

  /* Sum: '<S342>/Sum2' */
  rtb_Switch1_k = u0;

  /* Abs: '<S342>/Abs3' */
  rtb_Switch_jv = fabs(rtb_Switch1_k);

  /* Sum: '<S381>/Add1' */
  rtb_Product1_b = Gen2_ref_B->BusInput3.EGTLim.rT_CR_soft -
    Gen2_ref_B->BusInput3.EGTLim.rT_CR_hard;

  /* Saturate: '<S381>/Saturation6' */
  if (rtb_Product1_b > 1.0E+6) {
    rtb_Saturation6 = 1.0E+6;
  } else if (rtb_Product1_b < 1.0) {
    rtb_Saturation6 = 1.0;
  } else {
    rtb_Saturation6 = rtb_Product1_b;
  }

  /* End of Saturate: '<S381>/Saturation6' */

  /* DataTypeConversion: '<S4>/Data Type Conversion12' */
  rtb_Product1_b = Gen2_ref_B->BusInput.tT.rTcylMax;

  /* Bias: '<S342>/Bias' incorporates:
   *  Bias: '<S4>/C2K5'
   */
  rtb_PactOut_o = (rtb_Product1_b + 273.15) + -273.15;

  /* Sum: '<S381>/Add6' */
  rtb_Divide6_n = Gen2_ref_B->BusInput3.EGTLim.rT_max -
    Gen2_ref_B->BusInput3.EGTLim.rT_CR_hard;

  /* Sum: '<S381>/Sum15' */
  rtb_Switch2_n5 = (rtb_PactOut_o + rtb_Saturation6) - rtb_Divide6_n;

  /* Switch: '<S387>/Switch2' incorporates:
   *  Constant: '<S381>/Constant17'
   *  RelationalOperator: '<S387>/LowerRelop1'
   *  RelationalOperator: '<S387>/UpperRelop'
   *  Switch: '<S387>/Switch'
   */
  if (rtb_Switch2_n5 > rtb_Saturation6) {
    rtb_Switch2_n5 = rtb_Saturation6;
  } else if (rtb_Switch2_n5 < 0.0) {
    /* Switch: '<S387>/Switch' incorporates:
     *  Constant: '<S381>/Constant17'
     */
    rtb_Switch2_n5 = 0.0;
  }

  /* End of Switch: '<S387>/Switch2' */

  /* Switch: '<S381>/Switch7' incorporates:
   *  Constant: '<S381>/Constant23'
   *  Constant: '<S381>/Constant5'
   *  Product: '<S381>/Divide8'
   *  Sum: '<S381>/Sum1'
   */
  if (Gen2_ref_B->BusInput3.EGTLim.bActive) {
    rtb_Product1_b = 1.0 - rtb_Switch2_n5 / rtb_Saturation6;
  } else {
    rtb_Product1_b = 1.0;
  }

  /* End of Switch: '<S381>/Switch7' */

  /* Product: '<S342>/Product' */
  rtb_Product1_b *= rtb_Switch_jv;

  /* Switch: '<S380>/Switch2' incorporates:
   *  RelationalOperator: '<S380>/LowerRelop1'
   */
  if (!(rtb_Switch1_k > rtb_Product1_b)) {
    /* Gain: '<S342>/Gain2' */
    rtb_Switch_jv = -rtb_Switch_jv;

    /* Switch: '<S380>/Switch' incorporates:
     *  RelationalOperator: '<S380>/UpperRelop'
     */
    if (rtb_Switch1_k < rtb_Switch_jv) {
      rtb_Product1_b = rtb_Switch_jv;
    } else {
      rtb_Product1_b = rtb_Switch1_k;
    }

    /* End of Switch: '<S380>/Switch' */
  }

  /* End of Switch: '<S380>/Switch2' */

  /* Gain: '<S342>/Gain4' */
  rtb_Switch_jv = -1.0E-6 * rtb_Product1_b;

  /* Sum: '<S11>/Sum' incorporates:
   *  Constant: '<S11>/Constant'
   */
  rtb_Switch_fy_tmp_tmp = 1.0 - Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2;
  rtb_Product1_b = 1.0 - Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2;

  /* Saturate: '<S11>/Saturation' */
  if (rtb_Product1_b > 1.0) {
    rtb_Product1_b = 1.0;
  } else if (rtb_Product1_b < 0.0) {
    rtb_Product1_b = 0.0;
  }

  /* End of Saturate: '<S11>/Saturation' */

  /* Saturate: '<S11>/Saturation1' */
  if (Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2 > 1.0F) {
    rtb_rPos_CBV3 = 1.0F;
  } else if (Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2 < 0.0F) {
    rtb_rPos_CBV3 = 0.0F;
  } else {
    rtb_rPos_CBV3 = Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2;
  }

  /* End of Saturate: '<S11>/Saturation1' */

  /* Sum: '<S11>/Sum1' incorporates:
   *  Product: '<S11>/Product'
   *  Product: '<S11>/Product1'
   */
  rtb_Sum1_idx_2 = rtb_Product1_b * Gen2_ref_B->BusInput3.eng.rMin_Air_Ratio_kg
    + rtb_rPos_CBV3 * Gen2_ref_B->BusInput3.eng.rMin_Air_Ratio_M_kg;
  rtb_Sum1_idx_3 = rtb_Product1_b * Gen2_ref_B->BusInput3.eng.rLHV +
    rtb_rPos_CBV3 * Gen2_ref_B->BusInput3.eng.rLHV_M;

  /* Switch: '<S3>/etaVolConst' */
  if (Gen2_ref_B->BusInput3.Eff.bActive_EtaVolExt) {
    rtb_etaVolConst_lt = Gen2_ref_B->BusInput3.Eff.rEtaVolExt;
  } else {
    rtb_etaVolConst_lt = 0.0;
  }

  /* End of Switch: '<S3>/etaVolConst' */

  /* Switch: '<S3>/etaBreakConst' */
  if (Gen2_ref_B->BusInput3.Eff.bActive_EtaBrakeExt) {
    rtb_etaBreakConst = Gen2_ref_B->BusInput3.Eff.rEtaBrakeExt;
  } else {
    rtb_etaBreakConst = 0.0;
  }

  /* End of Switch: '<S3>/etaBreakConst' */

  /* Switch: '<S342>/Switch' */
  if (Gen2_ref_B->BusInput3.PowCtrl.bActive_MbcFF) {
    /* Product: '<S340>/Divide1' incorporates:
     *  Constant: '<S340>/Constant'
     *  Constant: '<S340>/R_air'
     */
    rtb_Switch1_k = rtb_Sum1_idx_2 * 287.15 * Gen2_ref_B->T2s_filt.Switch *
      rtb_kW2W1_h * 12.566370614359172;

    /* Saturate: '<S340>/Saturation1' */
    if (rtb_Switch1_k <= 1.0) {
      rtb_Switch1_k = 1.0;
    }

    /* End of Saturate: '<S340>/Saturation1' */

    /* Saturate: '<S340>/Saturation' */
    if (rtb_Sum1_idx_2 <= 1.0) {
      rtb_Product1_b = 1.0;
    } else {
      rtb_Product1_b = rtb_Sum1_idx_2;
    }

    /* End of Saturate: '<S340>/Saturation' */

    /* Sum: '<S340>/Sum' incorporates:
     *  Constant: '<S340>/Constant1'
     *  Gain: '<S340>/Gain'
     *  Product: '<S340>/Divide'
     *  Product: '<S340>/Divide2'
     *  Product: '<S340>/Divide4'
     */
    rtb_Switch_e3 = Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng * rtb_Sum1_idx_3 *
      (0.10471975511965977 * Gen2_ref_B->BusInput3.eng.rN_Nom) *
      rtb_etaVolConst_lt * rtb_etaBreakConst * Gen2_ref_B->p2s_filt.Switch /
      rtb_Switch1_k - 1.0 / rtb_Product1_b;

    /* Saturate: '<S340>/Saturation2' */
    if (rtb_Switch_e3 > 2.2) {
      rtb_Switch_e3 = 2.2;
    } else if (rtb_Switch_e3 < 1.3) {
      rtb_Switch_e3 = 1.3;
    }

    /* End of Saturate: '<S340>/Saturation2' */
  } else {
    rtb_Switch_e3 = Gen2_ref_B->BusInput3.PowCtrl.rLam_ff;
  }

  /* End of Switch: '<S342>/Switch' */

  /* Switch: '<S381>/Switch8' incorporates:
   *  Constant: '<S381>/Constant10'
   *  Product: '<S381>/Product'
   *  Product: '<S381>/Product1'
   *  Sum: '<S381>/Sum16'
   */
  if (Gen2_ref_B->BusInput3.EGTLim.bActive) {
    /* Sum: '<S381>/Sum8' */
    u0 = rtb_PactOut_o - rtb_Divide6_n;

    /* Saturate: '<S381>/Saturation3' */
    if (u0 > 1.0E+6) {
      u0 = 1.0E+6;
    } else if (u0 < 0.0) {
      u0 = 0.0;
    }

    /* End of Saturate: '<S381>/Saturation3' */
    rtb_Switch8 = u0 * Gen2_ref_B->BusInput3.EGTLim.rKaw_hard +
      Gen2_ref_B->BusInput3.EGTLim.rKaw_soft * rtb_Switch2_n5;
  } else {
    rtb_Switch8 = 0.0;
  }

  /* End of Switch: '<S381>/Switch8' */

  /* Gain: '<S14>/Gain2' incorporates:
   *  Gain: '<S133>/Gain1'
   *  Gain: '<S14>/Gain'
   *  Gain: '<S14>/Gain3'
   *  Gain: '<S23>/Gain'
   *  Gain: '<S25>/Gain1'
   *  Gain: '<S426>/Gain1'
   *  Gain: '<S9>/Gain5'
   *  Switch: '<S106>/Switch2'
   *  Switch: '<S133>/Switch'
   *  Switch: '<S133>/Switch1'
   *  Switch: '<S426>/Switch'
   *  Switch: '<S426>/Switch1'
   *  Switch: '<S426>/Switch2'
   *  Switch: '<S494>/etaVolConst'
   */
  rtb_kW2W1_h = 1.0E-5 * Gen2_ref_B->p2s_filt.Switch;
  rtb_Product1_b = rtb_kW2W1_h;

  /* S-Function (sfix_look1_dyn): '<S14>/Lookup Table Dynamic1' */
  /* Dynamic Look-Up Table Block: '<S14>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Saturation Mode: Saturate
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T_SAT( &(rtb_Sum8_m),
    &Gen2_ref_B->BusInput3.LamLim.refPoint_LamUpLim_ABS_y[0], rtb_Product1_b,
    &Gen2_ref_B->BusInput3.LamLim.refPoint_LamUpLim_ABS_x[0], 5U, inst);

  /* Logic: '<S14>/Logical Operator6' incorporates:
   *  Logic: '<S14>/Logical Operator10'
   */
  rtb_LogicalOperator5_g_tmp =
    !Gen2_ref_B->BusInput3.LamLim.bActLamLim_GQCimprovement;

  /* Logic: '<S14>/Logical Operator5' incorporates:
   *  Logic: '<S14>/Logical Operator6'
   */
  rtb_LogicalOperator5_mv = (Gen2_ref_B->BusInput3.LamLim.bLamOffsInitPerm ||
    rtb_LogicalOperator5_g_tmp);

  /* Gain: '<S14>/Gain3' */
  rtb_Product1_b = rtb_kW2W1_h;

  /* S-Function (sfix_look1_dyn): '<S14>/Lookup Table Dynamic2' */
  /* Dynamic Look-Up Table Block: '<S14>/Lookup Table Dynamic2'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Saturation Mode: Saturate
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T_SAT( &(rtb_LookupTableDynamic2),
    &Gen2_ref_B->BusInput3.LamLim.refPoint_LamLoLim_ABS_y[0], rtb_Product1_b,
    &Gen2_ref_B->BusInput3.LamLim.refPoint_LamLoLim_ABS_x[0], 5U, inst);

  /* Saturate: '<S14>/Saturation' */
  if (Gen2_ref_B->BusInput3.LamLim.rFactEnrich <= 0.0) {
    rtb_Product1_b = 0.0;
  } else {
    rtb_Product1_b = Gen2_ref_B->BusInput3.LamLim.rFactEnrich;
  }

  /* End of Saturate: '<S14>/Saturation' */

  /* Gain: '<S14>/Gain' */
  rtb_PactOut_o = rtb_kW2W1_h;

  /* Switch: '<S14>/Switch5' */
  if (Gen2_ref_B->BusInput3.LamLim.bNOx250mg) {
    /* S-Function (sfix_look1_dyn): '<S14>/Lookup Table Dynamic' */
    /* Dynamic Look-Up Table Block: '<S14>/Lookup Table Dynamic'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real_T
     * Saturation Mode: Saturate
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_Treal32_T_K4km1JJi( &(rtb_LookupTableDynamic_n),
      &Gen2_ref_B->BusInput3.LamLim.rLamMapBase250mg[0], rtb_PactOut_o,
      &Gen2_ref_B->BusInput3.LamLim.rPr_p2s_Lup_in[0], 9U, inst);
    rtb_PactOut_o = rtb_LookupTableDynamic_n;
  } else {
    /* S-Function (sfix_look1_dyn): '<S14>/Lookup Table Dynamic3' */
    /* Dynamic Look-Up Table Block: '<S14>/Lookup Table Dynamic3'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real_T
     * Saturation Mode: Saturate
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_Treal32_T_K4km1JJi( &(rtb_LookupTableDynamic3),
      &Gen2_ref_B->BusInput3.LamLim.rLamMapBase[0], rtb_PactOut_o,
      &Gen2_ref_B->BusInput3.LamLim.rPr_p2s_Lup_in[0], 9U, inst);
    rtb_PactOut_o = rtb_LookupTableDynamic3;
  }

  /* End of Switch: '<S14>/Switch5' */

  /* Product: '<S14>/Product' incorporates:
   *  Constant: '<S14>/Constant'
   *  Sum: '<S14>/Sum1'
   *  Sum: '<S14>/Sum2'
   */
  rtb_Product_l0 = (1.0 - rtb_Product1_b) * (rtb_PactOut_o -
    rtb_LookupTableDynamic2);

  /* Delay: '<S14>/Resettable Delay2' */
  if (Gen2_ref_DWork->icLoad_l) {
    Gen2_ref_DWork->ResettableDelay2_DSTATE =
      Gen2_ref_B->BusInput3.LamLim.rLamOffsetLimInit;
  }

  rtb_Product1_b = Gen2_ref_DWork->ResettableDelay2_DSTATE;

  /* End of Delay: '<S14>/Resettable Delay2' */

  /* Switch: '<S14>/Switch6' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion28'
   *  DataTypeConversion: '<S4>/Data Type Conversion31'
   *  DataTypeConversion: '<S4>/Data Type Conversion32'
   *  Sum: '<S14>/Sum16'
   *  UnitDelay: '<S14>/Unit Delay4'
   */
  if (Gen2_ref_DWork->UnitDelay4_DSTATE_d) {
    rtb_Divide6_n = (((Gen2_ref_B->BusInput.rLam_idle - rtb_LookupTableDynamic2)
                      - rtb_Product_l0) - Gen2_ref_B->BusInput.rOffsetLamLimit)
      + Gen2_ref_B->BusInput.rDeltaLamSync;
  } else {
    rtb_Divide6_n = rtb_Product1_b;
  }

  /* End of Switch: '<S14>/Switch6' */

  /* Switch: '<S14>/Switch7' */
  if (rtb_LogicalOperator5_mv) {
    rtb_Switch2_n5 = Gen2_ref_B->BusInput3.LamLim.rLamOffsetLimInit;
  } else {
    rtb_Switch2_n5 = rtb_Divide6_n;
  }

  /* End of Switch: '<S14>/Switch7' */

  /* Delay: '<S14>/Resettable Delay' incorporates:
   *  Logic: '<Root>/Logical Operator'
   */
  Gen2_ref_DWork->icLoad_i =
    ((((Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_j == 1) != (int32_T)
       rtb_LogicalOperator_cn) &&
      (Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_j != 3)) ||
     rtb_LogicalOperator_cn || Gen2_ref_DWork->icLoad_i);
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_j = rtb_LogicalOperator_cn;
  if (Gen2_ref_DWork->icLoad_i) {
    Gen2_ref_DWork->ResettableDelay_DSTATE_l = rtb_Switch2_n5;
  }

  /* Sum: '<S14>/Sum' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion28'
   *  UnitDelay: '<S14>/Unit Delay'
   */
  rtb_Switch1_k = (Gen2_ref_DWork->UnitDelay_DSTATE -
                   Gen2_ref_B->BusInput.rOffsetLamLimit) - rtb_PactOut_o;

  /* Switch: '<S14>/Switch9' */
  if (rtb_Switch2_jv) {
    /* Switch: '<S860>/Switch2' incorporates:
     *  Constant: '<S14>/Constant2'
     *  Delay: '<S14>/Resettable Delay'
     *  RelationalOperator: '<S860>/LowerRelop1'
     *  RelationalOperator: '<S860>/UpperRelop'
     *  Switch: '<S860>/Switch'
     */
    if (rtb_Switch1_k > 2.0) {
      rtb_Switch1_k = 2.0;
    } else if (rtb_Switch1_k < Gen2_ref_DWork->ResettableDelay_DSTATE_l) {
      /* Switch: '<S860>/Switch' incorporates:
       *  Delay: '<S14>/Resettable Delay'
       */
      rtb_Switch1_k = Gen2_ref_DWork->ResettableDelay_DSTATE_l;
    }

    /* End of Switch: '<S860>/Switch2' */
  }

  /* End of Switch: '<S14>/Switch9' */

  /* Abs: '<S858>/Abs' */
  rtb_Product1_b = rtb_Product1_e_tmp;

  /* Switch: '<S858>/Switch' incorporates:
   *  Constant: '<S858>/Constant2'
   *  RelationalOperator: '<S858>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Product1_b) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rP_Nom;
  }

  /* End of Switch: '<S858>/Switch' */

  /* RelationalOperator: '<S14>/Relational Operator' incorporates:
   *  Gain: '<S14>/Gain1'
   *  Product: '<S14>/Divide'
   */
  rtb_RelationalOperator_l5 = (0.001 * rtb_Gain2_ao / rtb_bResetHlci_0 >
    Gen2_ref_B->BusInput3.LamLim.rPminSSadapt);

  /* Switch: '<S908>/Switch' incorporates:
   *  Constant: '<S908>/Constant2'
   *  RelationalOperator: '<S908>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Product1_b) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rP_Nom;
  }

  /* End of Switch: '<S908>/Switch' */

  /* Product: '<S20>/Divide1' incorporates:
   *  Gain: '<S20>/Gain6'
   */
  rtb_Saturation6 = 0.001 * rtb_Gain2_ao / rtb_bResetHlci_0;

  /* Outputs for Atomic SubSystem: '<S20>/Filter1' */
  /* Logic: '<Root>/Logical Operator' */
  Gen2_ref_Filter3(rtb_Saturation6, Gen2_ref_B->BusInput3.LamLim.rTiSSfilter,
                   Gen2_ref_ConstB.T_filt1, rtb_LogicalOperator_cn,
                   &Gen2_ref_B->Filter1_ny, &Gen2_ref_DWork->Filter1_ny, inst);

  /* End of Outputs for SubSystem: '<S20>/Filter1' */

  /* Logic: '<S917>/Logical Operator' incorporates:
   *  Logic: '<Root>/Logical Operator'
   *  UnitDelay: '<S917>/Unit Delay'
   */
  rtb_LogicalOperator_i = (rtb_LogicalOperator_cn ||
    Gen2_ref_DWork->UnitDelay_DSTATE_k);

  /* DiscreteIntegrator: '<S917>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator_i || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_ka
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_c = 0.0;
  }

  /* RelationalOperator: '<S917>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S917>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_a = (Gen2_ref_B->BusInput3.LamLim.rTiSSsampling <=
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_c);

  /* Outputs for Enabled SubSystem: '<S20>/Enabled Subsystem2' incorporates:
   *  EnablePort: '<S909>/Enable'
   */
  if (rtb_RelationalOperator_a) {
    /* Inport: '<S909>/In1' */
    Gen2_ref_B->In1 = Gen2_ref_B->Filter1_ny.Switch;

    /* Memory: '<S909>/Memory' */
    FILT_IN = Gen2_ref_DWork->Memory_PreviousInput;

    /* Sum: '<S909>/Sum' */
    Gen2_ref_B->Sum = Gen2_ref_B->In1 - FILT_IN;

    /* Update for Memory: '<S909>/Memory' */
    Gen2_ref_DWork->Memory_PreviousInput = Gen2_ref_B->In1;
  }

  /* End of Outputs for SubSystem: '<S20>/Enabled Subsystem2' */

  /* Sum: '<S20>/Sum2' */
  rtb_Product1_b = rtb_Saturation6 - Gen2_ref_B->In1;

  /* Abs: '<S20>/Abs4' */
  rtb_Saturation6 = fabs(rtb_Product1_b);

  /* Outputs for Atomic SubSystem: '<S20>/Filter3' */
  /* Logic: '<Root>/Logical Operator' */
  Gen2_ref_Filter3(rtb_Saturation6, Gen2_ref_B->BusInput3.LamLim.rTiSSfilter,
                   Gen2_ref_ConstB.T_filt1, rtb_LogicalOperator_cn,
                   &Gen2_ref_B->Filter3_f, &Gen2_ref_DWork->Filter3_f, inst);

  /* End of Outputs for SubSystem: '<S20>/Filter3' */

  /* Abs: '<S20>/Abs1' */
  rtb_Product1_b = fabs(Gen2_ref_B->Sum);

  /* RelationalOperator: '<S20>/Relational Operator3' */
  rtb_LogicalOperator_aw = (rtb_Product1_b <=
    Gen2_ref_B->BusInput3.LamLim.rThrshSSPow);

  /* Gain: '<S20>/Gain1' incorporates:
   *  Sum: '<S20>/Sum'
   */
  rtb_Product1_b = (Gen2_ref_B->p2s_filt.Switch - rtb_Divide_kt) * 0.01;

  /* Abs: '<S20>/Abs' */
  rtb_Abs = fabs(rtb_Product1_b);

  /* Gain: '<S20>/Gain2' */
  rtb_Product1_b = 2.0 * Gen2_ref_B->BusInput3.LamLim.rThrshSSboost;

  /* Outputs for Atomic SubSystem: '<S20>/Filter' */
  /* Logic: '<Root>/Logical Operator' */
  Gen2_ref_Filter3(rtb_Abs, Gen2_ref_B->BusInput3.LamLim.rTiSSfilter,
                   Gen2_ref_ConstB.T_filt1, rtb_LogicalOperator_cn,
                   &Gen2_ref_B->Filter_f, &Gen2_ref_DWork->Filter_f, inst);

  /* End of Outputs for SubSystem: '<S20>/Filter' */

  /* Outputs for Atomic SubSystem: '<S20>/TON1' */
  /* Logic: '<S20>/Logical Operator' incorporates:
   *  RelationalOperator: '<S20>/Relational Operator'
   *  RelationalOperator: '<S20>/Relational Operator1'
   */
  Gen2_ref_TON_1(((rtb_Abs <= rtb_Product1_b) && (Gen2_ref_B->Filter_f.Switch <=
    Gen2_ref_B->BusInput3.LamLim.rThrshSSboost)),
                 Gen2_ref_B->BusInput3.LamLim.rTiSSsampling, &Gen2_ref_B->TON1_n,
                 &Gen2_ref_DWork->TON1_n, inst);

  /* End of Outputs for SubSystem: '<S20>/TON1' */

  /* Sum: '<S20>/Sum1' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion16'
   */
  rtb_Product1_b = rtb_DataTypeConversion15 - Gen2_ref_B->BusInput.rN_Set;

  /* Abs: '<S20>/Abs3' */
  rtb_Abs = fabs(rtb_Product1_b);

  /* Gain: '<S20>/Gain3' */
  rtb_Product1_b = 2.0 * Gen2_ref_B->BusInput3.LamLim.rThrshSSspeed;

  /* Outputs for Atomic SubSystem: '<S20>/Filter2' */
  /* Logic: '<Root>/Logical Operator' */
  Gen2_ref_Filter3(rtb_Abs, Gen2_ref_B->BusInput3.LamLim.rTiSSfilter,
                   Gen2_ref_ConstB.T_filt1, rtb_LogicalOperator_cn,
                   &Gen2_ref_B->Filter2_o, &Gen2_ref_DWork->Filter2_o, inst);

  /* End of Outputs for SubSystem: '<S20>/Filter2' */

  /* Outputs for Atomic SubSystem: '<S20>/TON' */
  /* Logic: '<S20>/Logical Operator2' incorporates:
   *  RelationalOperator: '<S20>/Relational Operator4'
   *  RelationalOperator: '<S20>/Relational Operator5'
   */
  Gen2_ref_TON_1(((rtb_Abs <= rtb_Product1_b) && (Gen2_ref_B->Filter2_o.Switch <=
    Gen2_ref_B->BusInput3.LamLim.rThrshSSspeed)),
                 Gen2_ref_B->BusInput3.LamLim.rTiSSsampling, &Gen2_ref_B->TON_l,
                 &Gen2_ref_DWork->TON_l, inst);

  /* End of Outputs for SubSystem: '<S20>/TON' */

  /* Outputs for Atomic SubSystem: '<S20>/TON2' */
  /* Logic: '<S20>/Logical Operator1' incorporates:
   *  RelationalOperator: '<S20>/Relational Operator2'
   *  RelationalOperator: '<S20>/Relational Operator6'
   */
  Gen2_ref_TON_1(((rtb_Saturation6 <= Gen2_ref_B->BusInput3.LamLim.rThrshSSPow) &&
                  (Gen2_ref_B->Filter3_f.Switch <=
                   Gen2_ref_B->BusInput3.LamLim.rThrshSSPow) &&
                  rtb_LogicalOperator_aw && Gen2_ref_B->TON1_n.LogicalOperator3 &&
                  Gen2_ref_B->TON_l.LogicalOperator3),
                 Gen2_ref_B->BusInput3.LamLim.rTiSSsampling, &Gen2_ref_B->TON2,
                 &Gen2_ref_DWork->TON2, inst);

  /* End of Outputs for SubSystem: '<S20>/TON2' */

  /* Switch: '<S14>/Switch4' incorporates:
   *  Delay: '<S14>/Resettable Delay'
   *  Logic: '<S14>/Logical Operator1'
   *  Switch: '<S14>/Switch3'
   */
  if (rtb_RelationalOperator_l5 &&
      Gen2_ref_B->BusInput3.LamLim.bAutomaticOffsetON &&
      (Gen2_ref_B->BusInput3.LamLim.bActLambdaOffsetNotSteady ||
       Gen2_ref_B->TON2.LogicalOperator3)) {
    /* Switch: '<S14>/Switch12' */
    if (rtb_Switch4_mu) {
      /* Switch: '<S861>/Switch2' incorporates:
       *  Constant: '<S14>/Constant6'
       *  Delay: '<S14>/Resettable Delay'
       *  RelationalOperator: '<S861>/LowerRelop1'
       *  RelationalOperator: '<S861>/UpperRelop'
       *  Switch: '<S861>/Switch'
       */
      if (rtb_Switch1_k > Gen2_ref_DWork->ResettableDelay_DSTATE_l) {
        rtb_Switch1_k = Gen2_ref_DWork->ResettableDelay_DSTATE_l;
      } else if (rtb_Switch1_k < -2.0) {
        /* Switch: '<S861>/Switch' incorporates:
         *  Constant: '<S14>/Constant6'
         */
        rtb_Switch1_k = -2.0;
      }

      /* End of Switch: '<S861>/Switch2' */
    }

    /* End of Switch: '<S14>/Switch12' */
  } else {
    rtb_Switch1_k = Gen2_ref_DWork->ResettableDelay_DSTATE_l;
  }

  /* End of Switch: '<S14>/Switch4' */

  /* Switch: '<S14>/Switch10' incorporates:
   *  Logic: '<S14>/Logical Operator7'
   *  Logic: '<S14>/Logical Operator9'
   *  Product: '<S14>/Divide1'
   */
  if (Gen2_ref_B->TON2.LogicalOperator3 ||
      (!Gen2_ref_B->BusInput3.LamLim.bActLambdaOffsetNotSteady)) {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.LamLim.rTiFiltLambdaOffset;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.LamLim.rFactTiFiltLamOffsNotSteady *
      Gen2_ref_B->BusInput3.LamLim.rTiFiltLambdaOffset;
  }

  /* End of Switch: '<S14>/Switch10' */

  /* Outputs for Atomic SubSystem: '<S14>/Filter' */
  /* Logic: '<Root>/Logical Operator' */
  Gen2_ref_Pd_filt(rtb_Switch1_k, rtb_bResetHlci_0, rtb_Switch2_n5,
                   rtb_LogicalOperator_cn, &Gen2_ref_B->Filter_l,
                   &Gen2_ref_DWork->Filter_l, inst);

  /* End of Outputs for SubSystem: '<S14>/Filter' */

  /* Sum: '<S14>/Sum4' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion28'
   */
  rtb_Sum4_ny = Gen2_ref_B->Filter_l.Switch +
    Gen2_ref_B->BusInput.rOffsetLamLimit;

  /* Saturate: '<S14>/Saturation1' */
  if (Gen2_ref_B->BusInput3.LamLim.rFactLean <= 0.0) {
    rtb_Product1_b = 0.0;
  } else {
    rtb_Product1_b = Gen2_ref_B->BusInput3.LamLim.rFactLean;
  }

  /* End of Saturate: '<S14>/Saturation1' */

  /* Product: '<S14>/Product1' incorporates:
   *  Constant: '<S14>/Constant1'
   *  Sum: '<S14>/Sum6'
   *  Sum: '<S14>/Sum7'
   */
  rtb_Product1_b = (rtb_PactOut_o - rtb_Sum8_m) * (1.0 - rtb_Product1_b);

  /* Sum: '<S14>/Sum5' */
  rtb_Sum5_j = rtb_Sum4_ny + rtb_Product1_b;

  /* Sum: '<S14>/Sum3' */
  rtb_Switch2_n5 = rtb_Sum8_m + rtb_Sum5_j;

  /* MinMax: '<S14>/MinMax' */
  if ((!(rtb_Switch2_n5 <= Gen2_ref_B->BusInput3.LamLim.rLam_max)) && (!rtIsNaN
       (Gen2_ref_B->BusInput3.LamLim.rLam_max))) {
    rtb_Switch2_n5 = Gen2_ref_B->BusInput3.LamLim.rLam_max;
  }

  /* End of MinMax: '<S14>/MinMax' */

  /* Sum: '<S14>/Sum8' */
  rtb_Sum8_m = rtb_Sum4_ny + rtb_Product_l0;

  /* Delay: '<S14>/Resettable Delay3' incorporates:
   *  Logic: '<Root>/Logical Operator'
   */
  Gen2_ref_DWork->icLoad_f =
    ((((Gen2_ref_PrevZCSigState->ResettableDelay3_Reset_ZCE == 1) != (int32_T)
       rtb_LogicalOperator_cn) &&
      (Gen2_ref_PrevZCSigState->ResettableDelay3_Reset_ZCE != 3)) ||
     rtb_LogicalOperator_cn || Gen2_ref_DWork->icLoad_f);
  Gen2_ref_PrevZCSigState->ResettableDelay3_Reset_ZCE = rtb_LogicalOperator_cn;
  Gen2_ref_DWork->ResettableDelay3_DSTATE = (Gen2_ref_DWork->icLoad_f ||
    Gen2_ref_DWork->ResettableDelay3_DSTATE);

  /* Switch: '<S14>/Switch13' incorporates:
   *  Constant: '<S14>/Constant5'
   *  Delay: '<S14>/Resettable Delay3'
   *  Logic: '<S14>/Logical Operator11'
   */
  if (Gen2_ref_DWork->ResettableDelay3_DSTATE) {
    rtb_RelationalOperator_l5 = !rtb_RelationalOperator_l5;
  } else {
    rtb_RelationalOperator_l5 = false;
  }

  /* End of Switch: '<S14>/Switch13' */

  /* Logic: '<S14>/Logical Operator12' */
  rtb_LogicalOperator12_a = !rtb_RelationalOperator_l5;

  /* Switch: '<S14>/Switch11' incorporates:
   *  Logic: '<Root>/Logical Operator'
   *  Logic: '<S14>/Logical Operator4'
   */
  if (rtb_LogicalOperator_cn || rtb_LogicalOperator12_a ||
      rtb_LogicalOperator5_g_tmp) {
    /* Sum: '<S14>/Sum9' */
    rtb_Switch1_k = rtb_LookupTableDynamic2 + rtb_Sum8_m;

    /* MinMax: '<S14>/MinMax1' */
    if ((!(rtb_Switch1_k >= Gen2_ref_B->BusInput3.LamLim.rLam_min)) && (!rtIsNaN
         (Gen2_ref_B->BusInput3.LamLim.rLam_min))) {
      rtb_Switch1_k = Gen2_ref_B->BusInput3.LamLim.rLam_min;
    }
  } else {
    /* Sum: '<S14>/Sum9' */
    u0 = rtb_LookupTableDynamic2 + rtb_Sum8_m;

    /* MinMax: '<S14>/MinMax1' */
    if ((!(u0 >= Gen2_ref_B->BusInput3.LamLim.rLam_min)) && (!rtIsNaN
         (Gen2_ref_B->BusInput3.LamLim.rLam_min))) {
      u0 = Gen2_ref_B->BusInput3.LamLim.rLam_min;
    }

    /* Sum: '<S14>/Sum14' incorporates:
     *  DataTypeConversion: '<S4>/Data Type Conversion31'
     *  DataTypeConversion: '<S4>/Data Type Conversion32'
     */
    rtb_Switch1_k = (real_T)Gen2_ref_B->BusInput.rLam_idle +
      Gen2_ref_B->BusInput.rDeltaLamSync;

    /* MinMax: '<S14>/MinMax4' */
    if ((u0 >= rtb_Switch1_k) || rtIsNaN(rtb_Switch1_k)) {
      rtb_Switch1_k = u0;
    }

    /* End of MinMax: '<S14>/MinMax4' */
  }

  /* End of Switch: '<S14>/Switch11' */

  /* Outputs for Atomic SubSystem: '<S342>/PID_Power' */
  /* Product: '<S379>/Divide1' */
  FILT_IN = Gen2_ref_B->BusInput3.PowCtrl.rKp * rtb_Switch_jv;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S379>/Bus Creator1'
   *  DataTypeConversion: '<S379>/Data Type Conversion1'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.up = (real32_T)FILT_IN;

  /* Product: '<S379>/Divide2' */
  r = rtb_Switch_jv * Gen2_ref_B->BusInput3.PowCtrl.rKd;

  /* DiscreteIntegrator: '<S379>/Discrete-Time Integrator1' */
  if (rtb_LogicalOperator_in || (Gen2_ref_DWork->DiscreteTimeIntegrator1_PrevR_l
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTA_nh = 0.0;
  }

  /* Product: '<S379>/Divide3' incorporates:
   *  DiscreteIntegrator: '<S379>/Discrete-Time Integrator1'
   *  Sum: '<S379>/Sum1'
   */
  rtb_Divide3_p = (r - Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTA_nh) *
    Gen2_ref_B->BusInput3.PowCtrl.rN;

  /* Delay: '<S379>/Delay2' */
  r = Gen2_ref_DWork->Delay2_DSTATE_o;

  /* MATLAB Function: '<S379>/MATLAB Function' incorporates:
   *  Constant: '<S342>/Constant'
   *  Sum: '<S379>/Sum6'
   */
  Gen2_ref_MATLABFunction_g(rtb_LogicalOperator_in, 0.0, rtb_LogicalOperator1_e,
    ((r - rtb_Switch_e3) - FILT_IN) - rtb_Divide3_p,
    &Gen2_ref_B->sf_MATLABFunction_g, &Gen2_ref_DWork->sf_MATLABFunction_g, inst);

  /* DiscreteIntegrator: '<S379>/Discrete-Time Integrator' */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_g != 0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_f =
      Gen2_ref_B->sf_MATLABFunction_g.Y0Out;
  }

  if (Gen2_ref_B->sf_MATLABFunction_g.ireset ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_o3 != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_f =
      Gen2_ref_B->sf_MATLABFunction_g.Y0Out;
  }

  /* Sum: '<S379>/Sum3' incorporates:
   *  DiscreteIntegrator: '<S379>/Discrete-Time Integrator'
   *  Sum: '<S379>/Sum'
   */
  FILT_IN = ((FILT_IN + Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_f) +
             rtb_Divide3_p) + rtb_Switch_e3;

  /* Product: '<S385>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S385>/sample time'
   *
   * About '<S385>/sample time':
   *  y = K where K = ( w * Ts )
   */
  r = Gen2_ref_B->BusInput3.PowCtrl.rLam_Sr_Pos * 0.01;

  /* Delay: '<S385>/Delay' incorporates:
   *  Delay: '<S404>/Delay'
   */
  Gen2_ref_DWork->icLoad_nq = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_at ==
    1) != (int32_T)rtb_LogicalOperator_in) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_at != 3)) ||
    rtb_LogicalOperator_in || Gen2_ref_DWork->icLoad_nq);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_at = rtb_LogicalOperator_in;
  if (Gen2_ref_DWork->icLoad_nq) {
    Gen2_ref_DWork->Delay_DSTATE_dj = rtb_Switch_e3;
  }

  /* Switch: '<S385>/etaVolConst' */
  if (rtb_LogicalOperator_in) {
    rtb_Abs = rtb_Switch_e3;
  } else {
    rtb_Abs = FILT_IN;
  }

  /* End of Switch: '<S385>/etaVolConst' */

  /* Sum: '<S385>/Difference Inputs1' incorporates:
   *  Delay: '<S385>/Delay'
   */
  rtb_Saturation6 = rtb_Abs - Gen2_ref_DWork->Delay_DSTATE_dj;

  /* Switch: '<S386>/Switch2' incorporates:
   *  RelationalOperator: '<S386>/LowerRelop1'
   */
  if (!(rtb_Saturation6 > r)) {
    /* Product: '<S385>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S385>/sample time'
     *
     * About '<S385>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Abs = Gen2_ref_B->BusInput3.PowCtrl.rLam_Sr_Neg * 0.01;

    /* Switch: '<S386>/Switch' incorporates:
     *  RelationalOperator: '<S386>/UpperRelop'
     */
    if (rtb_Saturation6 < rtb_Abs) {
      r = rtb_Abs;
    } else {
      r = rtb_Saturation6;
    }

    /* End of Switch: '<S386>/Switch' */
  }

  /* End of Switch: '<S386>/Switch2' */

  /* Sum: '<S385>/Difference Inputs2' incorporates:
   *  Delay: '<S385>/Delay'
   */
  rtb_Saturation6 = r + Gen2_ref_DWork->Delay_DSTATE_dj;

  /* Switch: '<S384>/Switch2' incorporates:
   *  RelationalOperator: '<S384>/LowerRelop1'
   *  RelationalOperator: '<S384>/UpperRelop'
   *  Switch: '<S384>/Switch'
   */
  if (rtb_Saturation6 > rtb_Switch2_n5) {
    rtb_Switch2_jw = rtb_Switch2_n5;
  } else if (rtb_Saturation6 < rtb_Switch1_k) {
    /* Switch: '<S384>/Switch' */
    rtb_Switch2_jw = rtb_Switch1_k;
  } else {
    rtb_Switch2_jw = rtb_Saturation6;
  }

  /* End of Switch: '<S384>/Switch2' */

  /* Sum: '<S379>/Sum2' */
  r = rtb_Switch2_jw - FILT_IN;

  /* Product: '<S379>/Divide4' */
  r *= Gen2_ref_B->BusInput3.PowCtrl.rKaw;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S379>/Bus Creator1'
   *  DataTypeConversion: '<S379>/Data Type Conversion2'
   *  DataTypeConversion: '<S379>/Data Type Conversion4'
   *  DataTypeConversion: '<S379>/Data Type Conversion7'
   *  DiscreteIntegrator: '<S379>/Discrete-Time Integrator'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.ui = (real32_T)
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_f;
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.aw = (real32_T)r;
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.u_unsat = (real32_T)FILT_IN;

  /* Product: '<S379>/Divide' */
  FILT_IN = rtb_Switch_jv * Gen2_ref_B->BusInput3.PowCtrl.rKi;

  /* MATLAB Function: '<S379>/MATLAB Function1' */
  Gen2_ref_MATLABFunction1(rtb_Switch2_jw, rtb_LogicalOperator1_e,
    &Gen2_ref_B->sf_MATLABFunction1_h, &Gen2_ref_DWork->sf_MATLABFunction1_h, inst);

  /* Update for DiscreteIntegrator: '<S379>/Discrete-Time Integrator1' incorporates:
   *  DiscreteIntegrator: '<S389>/Discrete-Time Integrator1'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTA_nh += 0.01 * rtb_Divide3_p;

  /* Outputs for Atomic SubSystem: '<S343>/PID_Power' */
  Gen2_ref_DWork->DiscreteTimeIntegrator1_PrevR_l = (int8_T)
    rtb_LogicalOperator_in;

  /* End of Outputs for SubSystem: '<S343>/PID_Power' */

  /* Update for Delay: '<S379>/Delay2' */
  Gen2_ref_DWork->Delay2_DSTATE_o = Gen2_ref_B->sf_MATLABFunction1_h.LamOut;

  /* Update for DiscreteIntegrator: '<S379>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion29'
   *  Sum: '<S379>/Sum4'
   *  Sum: '<S379>/Sum5'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_g = 0U;
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_f +=
    (((Gen2_ref_B->BusInput.rAW_EGT_ext + rtb_Switch8) + r) + FILT_IN) * 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_o3 = (int8_T)
    Gen2_ref_B->sf_MATLABFunction_g.ireset;

  /* Update for Delay: '<S385>/Delay' */
  Gen2_ref_DWork->icLoad_nq = false;
  Gen2_ref_DWork->Delay_DSTATE_dj = rtb_Saturation6;

  /* End of Outputs for SubSystem: '<S342>/PID_Power' */

  /* Gain: '<S631>/Gain2' */
  rtb_Saturation6 = 0.10471975511965977 * rtb_Switch_ks;

  /* Gain: '<S431>/Gain1' incorporates:
   *  Gain: '<S626>/Gain11'
   *  Gain: '<S631>/Gain3'
   */
  rtb_Gain1_f_tmp = 0.10471975511965977 * rtb_Switch_i5[0];

  /* Sum: '<S748>/Sum' incorporates:
   *  Gain: '<S431>/Gain1'
   *  Sum: '<S747>/Sum2'
   */
  rtb_Saturation6_tmp = rtb_Saturation6 - rtb_Gain1_f_tmp;

  /* Outputs for Atomic SubSystem: '<S747>/TON' */
  /* UnitDelay: '<S641>/Unit Delay2' */
  Gen2_ref_TON_1(Gen2_ref_DWork->UnitDelay2_DSTATE_d2,
                 Gen2_ref_B->BusInput3.SpeedCtrl.tOutOfNWindow,
                 &Gen2_ref_B->TON_d, &Gen2_ref_DWork->TON_d, inst);

  /* End of Outputs for SubSystem: '<S747>/TON' */

  /* Logic: '<S747>/Logical Operator3' incorporates:
   *  Logic: '<S747>/Logical Operator2'
   *  UnitDelay: '<S641>/Unit Delay2'
   */
  rtb_LogicalOperator3_b = (Gen2_ref_DWork->UnitDelay2_DSTATE_d2 &&
    (!Gen2_ref_B->TON_d.LogicalOperator3));

  /* Switch: '<S747>/Switch5' incorporates:
   *  Abs: '<S747>/Abs'
   *  Gain: '<S747>/Gain5'
   *  Logic: '<S747>/Logical Operator4'
   *  RelationalOperator: '<S747>/Relational Operator'
   *  Sum: '<S747>/Sum3'
   */
  if ((fabs(rtb_Saturation6_tmp * 9.5492965855137211) >
       Gen2_ref_B->BusInput3.SpeedCtrl.rOutOfNWinHys +
       Gen2_ref_B->BusInput3.SpeedCtrl.rOutOfNWindow) && rtb_LogicalOperator3_b)
  {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.SpeedCtrl.rOutOfNWindow;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.SpeedCtrl.rThrsh_ss_int_iLQR;
  }

  /* End of Switch: '<S747>/Switch5' */

  /* RelationalOperator: '<S748>/Relational Operator' incorporates:
   *  Abs: '<S748>/Abs'
   *  Gain: '<S641>/Gain5'
   *  Sum: '<S748>/Sum'
   */
  rtb_LogicalOperator2_p1 = (fabs(rtb_Saturation6_tmp) > 0.10471975511965977 *
    rtb_bResetHlci_0);

  /* Logic: '<S748>/Logical Operator' incorporates:
   *  Logic: '<S748>/Logical Operator1'
   */
  rtb_LogicalOperator1_e = (rtb_LogicalOperator2_p1 ||
    (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act ||
     Gen2_ref_B->BusInput3.SpeedCtrl.bComModeLQR || rtb_bResetHlci));

  /* Gain: '<S641>/Gain1' */
  rtb_Switch_jv = 0.10471975511965977 *
    Gen2_ref_B->BusInput3.SpeedCtrl.rInitSpeedCtrl_iLQR;

  /* DiscreteIntegrator: '<S748>/Discrete-Time Integrator' */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_k = rtb_Switch_jv;
  }

  if (rtb_LogicalOperator1_e || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_j
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_k = rtb_Switch_jv;
  }

  /* Switch: '<S748>/Switch' incorporates:
   *  Constant: '<S748>/Constant3'
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator'
   *  Logic: '<S748>/Logical Operator6'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bTrackNbyLambda ||
      Gen2_ref_B->BusInput3.SpeedCtrl.bTrackNbyKe) {
    rtb_Switch_dhr = 0.0;
  } else {
    rtb_Switch_dhr = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_k;
  }

  /* End of Switch: '<S748>/Switch' */

  /* Sum: '<S641>/Sum1' */
  rtb_Sum1_l = rtb_Saturation6 + rtb_Switch_dhr;

  /* Gain: '<S431>/Gain2' */
  rtb_Gain2_cm = 1.0E-5 * rtb_Switch2_l;

  /* Switch: '<S695>/Switch2' incorporates:
   *  RelationalOperator: '<S695>/LowerRelop1'
   *  RelationalOperator: '<S695>/UpperRelop'
   *  Switch: '<S695>/Switch'
   */
  if (rtb_Gain2_cm > Gen2_ref_B->BusInput3.traj.rPr_p2s_max) {
    rtb_Abs = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  } else if (rtb_Gain2_cm < Gen2_ref_B->BusInput3.traj.rPr_p2s_min) {
    /* Switch: '<S695>/Switch' */
    rtb_Abs = Gen2_ref_B->BusInput3.traj.rPr_p2s_min;
  } else {
    rtb_Abs = rtb_Gain2_cm;
  }

  /* End of Switch: '<S695>/Switch2' */

  /* DiscreteIntegrator: '<S748>/Discrete-Time Integrator4' */
  if (rtb_LogicalOperator1_e || (Gen2_ref_DWork->DiscreteTimeIntegrator4_PrevRes
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = 0.0;
    if (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE >= 0.0) {
      Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = 0.0;
    } else if (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE <= -0.3) {
      Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = -0.3;
    }
  }

  if (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE >= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = 0.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE <= -0.3) {
    Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = -0.3;
  }

  /* Logic: '<S748>/Logical Operator3' incorporates:
   *  Logic: '<S748>/Logical Operator2'
   */
  rtb_LogicalOperator3_fj = (rtb_LogicalOperator2_p1 || (rtb_bResetHlci ||
    Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act ||
    Gen2_ref_B->BusInput3.SpeedCtrl.bComModeLQR_boost));

  /* DiscreteIntegrator: '<S748>/Discrete-Time Integrator1' */
  if (rtb_LogicalOperator3_fj ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator1_PrevRes != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTATE = 0.0;
  }

  /* Sum: '<S641>/Sum2' incorporates:
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator1'
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator4'
   *  Sum: '<S641>/Sum4'
   *  Sum: '<S748>/Sum5'
   */
  rtb_Sum2_a_tmp = (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE +
                    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTATE) + rtb_Abs;

  /* Outputs for Atomic SubSystem: '<Root>/brake eff estimate' */
  /* Gain: '<S626>/Gain10' incorporates:
   *  Gain: '<S21>/Gain1'
   *  Gain: '<S631>/Gain1'
   *  Gain: '<S814>/Gain10'
   */
  rtb_Switch2_ejy_tmp = 1000.0 * Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

  /* End of Outputs for SubSystem: '<Root>/brake eff estimate' */
  rtb_Switch2_l = rtb_Switch2_ejy_tmp;

  /* Switch: '<S626>/Switch3' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bMeasPowKeEst) {
    rtb_bResetHlci_0 = rtb_Switch_i5[3];
  } else {
    rtb_bResetHlci_0 = rtb_Switch_bs;
  }

  /* End of Switch: '<S626>/Switch3' */

  /* Sum: '<S626>/Sum3' */
  rtb_Switch_jv = rtb_bResetHlci_0 + rtb_Switch2_l;

  /* Abs: '<S646>/Abs' incorporates:
   *  Abs: '<S694>/Abs'
   */
  r = fabs(rtb_Gain1_f_tmp);
  rtb_Switch2_l = r;

  /* Switch: '<S646>/Switch' incorporates:
   *  Constant: '<S646>/Constant2'
   *  RelationalOperator: '<S646>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_l) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = rtb_Gain1_f_tmp;
  }

  /* End of Switch: '<S646>/Switch' */

  /* Product: '<S626>/Divide3' */
  rtb_Divide3_g = rtb_Switch_jv / rtb_bResetHlci_0;

  /* Gain: '<S431>/Gain3' incorporates:
   *  Gain: '<S628>/Gain1'
   *  Gain: '<S630>/Gain6'
   *  Gain: '<S636>/Gain1'
   *  Gain: '<S636>/Gain2'
   *  Gain: '<S636>/Gain6'
   *  Gain: '<S639>/Gain5'
   *  Switch: '<S636>/Switch6'
   */
  rtb_Gain3 = 1.0E-5 * rtb_Switch_i5[5];

  /* Saturate: '<S637>/Saturation' */
  if (Gen2_ref_B->BusInput3.PowCtrl.rLam_Start <= 1.0) {
    rtb_Saturation_o = 1.0;
  } else {
    rtb_Saturation_o = Gen2_ref_B->BusInput3.PowCtrl.rLam_Start;
  }

  /* End of Saturate: '<S637>/Saturation' */

  /* Delay: '<S637>/Resettable Delay' incorporates:
   *  Delay: '<S425>/Delay'
   */
  Gen2_ref_DWork->icLoad_ef =
    ((((Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_m == 1) != (int32_T)
       rtb_bResetHlci) && (Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_m
       != 3)) || rtb_bResetHlci || Gen2_ref_DWork->icLoad_ef);
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_m = rtb_bResetHlci;
  if (Gen2_ref_DWork->icLoad_ef) {
    Gen2_ref_DWork->ResettableDelay_DSTATE_i = rtb_Saturation_o;
  }

  rtb_Switch_jv = Gen2_ref_DWork->ResettableDelay_DSTATE_i;

  /* Abs: '<S736>/Abs' */
  rtb_Switch2_l = fabs(rtb_Product1_aq);

  /* Switch: '<S736>/Switch' incorporates:
   *  Constant: '<S736>/Constant2'
   *  RelationalOperator: '<S736>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_l) {
    rtb_Product1_aq = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S736>/Switch' */

  /* Product: '<S639>/Product1' */
  rtb_Product1_aq = rtb_Switch_i5[3] / rtb_Product1_aq;

  /* Outputs for Atomic SubSystem: '<S737>/Filter' */
  /* DiscreteIntegrator: '<S743>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S743>/Logical Operator'
   */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_m != 0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_n = rtb_Product1_aq;
  }

  if (rtb_bResetHlci || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_kx != 0))
  {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_n = rtb_Product1_aq;
  }

  /* Switch: '<S743>/Switch' incorporates:
   *  DiscreteIntegrator: '<S743>/Discrete-Time Integrator'
   */
  rtb_Switch_nb = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_n;

  /* Update for DiscreteIntegrator: '<S743>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S743>/Logical Operator'
   *  Product: '<S743>/Divide4'
   *  Sum: '<S743>/Sum4'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_m = 0U;
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_n += (rtb_Product1_aq -
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_n) / 0.1 * 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_kx = (int8_T)rtb_bResetHlci;

  /* End of Outputs for SubSystem: '<S737>/Filter' */

  /* Switch: '<S737>/Switch3' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_D_iLQR) {
    /* Saturate: '<S737>/Saturation' */
    if (rtb_Switch_nb > 1.0) {
      rtb_Product1_aq = 1.0;
    } else if (rtb_Switch_nb < 0.0) {
      rtb_Product1_aq = 0.0;
    } else {
      rtb_Product1_aq = rtb_Switch_nb;
    }

    /* End of Saturate: '<S737>/Saturation' */

    /* S-Function (sfix_look1_dyn): '<S737>/gain scheduling D' */
    /* Dynamic Look-Up Table Block: '<S737>/gain scheduling D'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_gainschedulingD),
                         &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_D_y[0],
                         rtb_Product1_aq,
                         &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_D_x[0],
                         5U, inst);
    rtb_Switch_nb = rtb_gainschedulingD;
  } else {
    rtb_Switch_nb = Gen2_ref_B->BusInput3.SpeedCtrl.rD_iLQR;
  }

  /* End of Switch: '<S737>/Switch3' */

  /* Abs: '<S742>/Abs' incorporates:
   *  Abs: '<S731>/Abs'
   */
  rtb_Switch_dz_tmp = fabs(Gen2_ref_B->BusInput3.eng.Ts);
  rtb_Switch2_l = rtb_Switch_dz_tmp;

  /* Switch: '<S742>/Switch' incorporates:
   *  Constant: '<S742>/Constant2'
   *  RelationalOperator: '<S742>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_l) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.Ts;
  }

  /* End of Switch: '<S742>/Switch' */

  /* Product: '<S737>/Product1' incorporates:
   *  Product: '<S737>/Product'
   *  Rounding: '<S737>/Rounding Function'
   */
  rtb_Product1_b4 = floor(rtb_Switch_nb / rtb_bResetHlci_0) *
    Gen2_ref_B->BusInput3.eng.Ts;

  /* Switch: '<S731>/Switch' incorporates:
   *  Constant: '<S731>/Constant2'
   *  RelationalOperator: '<S731>/Relational Operator'
   */
  if (0.001 >= rtb_Switch_dz_tmp) {
    rtb_bResetHlci_0 = 0.001;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.Ts;
  }

  /* End of Switch: '<S731>/Switch' */

  /* DataTypeConversion: '<S637>/Data Type Conversion' incorporates:
   *  Product: '<S637>/Divide'
   */
  rtb_bResetHlci_0 = floor(rtb_Product1_b4 / rtb_bResetHlci_0);
  if (rtIsNaN(rtb_bResetHlci_0) || rtIsInf(rtb_bResetHlci_0)) {
    rtb_bResetHlci_0 = 0.0;
  } else {
    rtb_bResetHlci_0 = fmod(rtb_bResetHlci_0, 65536.0);
  }

  rtb_DataTypeConversion_l = (uint16_T)(rtb_bResetHlci_0 < 0.0 ? (int32_T)
    (uint16_T)-(int16_T)(uint16_T)-rtb_bResetHlci_0 : (int32_T)(uint16_T)
    rtb_bResetHlci_0);

  /* End of DataTypeConversion: '<S637>/Data Type Conversion' */

  /* Delay: '<S637>/Variable Integer Delay' incorporates:
   *  Delay: '<S425>/Delay'
   *  Delay: '<S637>/Resettable Delay'
   */
  if ((((Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZCE == 1) !=
        (int32_T)rtb_bResetHlci) &&
       (Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZCE != 3)) ||
      rtb_bResetHlci) {
    Gen2_ref_DWork->icLoad_b = true;
    Gen2_ref_DWork->CircBufIdx = 0U;
  }

  Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZCE = rtb_bResetHlci;
  if (Gen2_ref_DWork->icLoad_b) {
    for (i = 0; i < 200; i++) {
      Gen2_ref_DWork->VariableIntegerDelay_DSTATE[i] = rtb_Saturation_o;
    }
  }

  if (rtb_DataTypeConversion_l <= 0) {
    rtb_VariableIntegerDelay = Gen2_ref_DWork->ResettableDelay_DSTATE_i;
  } else {
    if (rtb_DataTypeConversion_l > 200) {
      rtb_DataTypeConversion_l = 200U;
    }

    if (rtb_DataTypeConversion_l <= Gen2_ref_DWork->CircBufIdx) {
      rtb_DataTypeConversion_l = (uint16_T)((uint32_T)Gen2_ref_DWork->CircBufIdx
        - rtb_DataTypeConversion_l);
    } else {
      rtb_DataTypeConversion_l = (uint16_T)((uint16_T)((uint32_T)
        Gen2_ref_DWork->CircBufIdx - rtb_DataTypeConversion_l) + 200U);
    }

    rtb_VariableIntegerDelay = Gen2_ref_DWork->
      VariableIntegerDelay_DSTATE[rtb_DataTypeConversion_l];
  }

  /* End of Delay: '<S637>/Variable Integer Delay' */

  /* Gain: '<S639>/Gain5' */
  rtb_Product1_aq = rtb_Gain3;

  /* Switch: '<S740>/Switch3' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_T_Lam_iLQR) {
    /* S-Function (sfix_look1_dyn): '<S740>/gain scheduling Tlam' */
    /* Dynamic Look-Up Table Block: '<S740>/gain scheduling Tlam'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_gainschedulingTlam),
                         &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Tlam_y[0],
                         rtb_Product1_aq,
                         &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Tlam_x[0],
                         6U, inst);
    rtb_Switch_nb = rtb_gainschedulingTlam;
  } else {
    rtb_Switch_nb = Gen2_ref_B->BusInput3.SpeedCtrl.rTi_Lam_iLQR;
  }

  /* End of Switch: '<S740>/Switch3' */

  /* UnitDelay: '<S628>/Unit Delay1' */
  rtb_Switch2_l = Gen2_ref_DWork->UnitDelay1_DSTATE_a;

  /* Switch: '<S740>/Switch4' incorporates:
   *  Constant: '<S740>/Constant5'
   */
  if (!Gen2_ref_B->BusInput3.SpeedCtrl.bAddTi_Tlam) {
    rtb_Switch2_l = 0.0;
  }

  /* End of Switch: '<S740>/Switch4' */

  /* Sum: '<S740>/Sum2' */
  rtb_Sum2_kg = rtb_Switch_nb + rtb_Switch2_l;

  /* Outputs for Atomic SubSystem: '<S637>/Filter' */
  Gen2_ref_Pd_filt(rtb_VariableIntegerDelay, rtb_Sum2_kg, rtb_Saturation_o,
                   rtb_bResetHlci, &Gen2_ref_B->Filter_bd,
                   &Gen2_ref_DWork->Filter_bd, inst);

  /* End of Outputs for SubSystem: '<S637>/Filter' */

  /* Sum: '<S626>/Sum4' incorporates:
   *  Constant: '<S626>/it_offset_ref2'
   *  Product: '<S626>/Divide5'
   */
  rtb_Switch_nb = Gen2_ref_B->Filter_bd.Switch * rtb_Sum1_idx_2 + 1.0;

  /* Abs: '<S647>/Abs' */
  rtb_Switch2_l = fabs(rtb_Switch_nb);

  /* Switch: '<S647>/Switch' incorporates:
   *  Constant: '<S647>/Constant2'
   *  RelationalOperator: '<S647>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_l) {
    rtb_Switch_nb = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S647>/Switch' */

  /* Product: '<S626>/Divide4' */
  rtb_Switch_nb = rtb_Gain3 / rtb_Switch_nb;

  /* Abs: '<S648>/Abs' */
  rtb_Switch2_l = fabs(rtb_Switch_nb);

  /* Switch: '<S648>/Switch' incorporates:
   *  Constant: '<S648>/Constant2'
   *  RelationalOperator: '<S648>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_l) {
    rtb_Switch_nb = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S648>/Switch' */

  /* Outputs for Atomic SubSystem: '<S626>/Filter1' */
  /* Product: '<S626>/Divide11' */
  Gen2_ref_N_TC_HP_filt(rtb_Divide3_g / rtb_Switch_nb,
                        Gen2_ref_B->BusInput3.SpeedCtrl.rTiFKeEst,
                        rtb_bResetHlci, &Gen2_ref_B->Filter1_o,
                        &Gen2_ref_DWork->Filter1_o, inst);

  /* End of Outputs for SubSystem: '<S626>/Filter1' */

  /* Delay: '<S625>/Delay' */
  rtb_Switch2_l = Gen2_ref_DWork->Delay_DSTATE_k;

  /* Switch: '<S625>/Switch' incorporates:
   *  Constant: '<S625>/R_air'
   */
  if (!Gen2_ref_B->BusInput3.SpeedCtrl.bUseRgasEst) {
    rtb_Switch2_l = 287.15;
  }

  /* End of Switch: '<S625>/Switch' */

  /* Abs: '<S643>/Abs' incorporates:
   *  Abs: '<S149>/Abs'
   *  Abs: '<S273>/Abs'
   *  Abs: '<S289>/Abs'
   */
  rtb_bResetHlci_0 = fabs(Gen2_ref_B->T2s_filt.Switch);

  /* Switch: '<S643>/Switch' incorporates:
   *  Abs: '<S643>/Abs'
   *  Constant: '<S643>/Constant2'
   *  RelationalOperator: '<S643>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_bResetHlci_0) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = Gen2_ref_B->T2s_filt.Switch;
  }

  /* End of Switch: '<S643>/Switch' */

  /* Switch: '<S642>/Switch' incorporates:
   *  Abs: '<S642>/Abs'
   *  Constant: '<S642>/Constant2'
   *  RelationalOperator: '<S642>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Switch2_l)) {
    rtb_Switch2_l = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S642>/Switch' */

  /* Gain: '<S625>/Gain1' incorporates:
   *  Gain: '<S625>/Gain2'
   *  Product: '<S625>/Divide3'
   */
  rtb_VariableIntegerDelay = Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng / delta_y *
    rtb_etaVolConst_lt * rtb_etaBreakConst * rtb_Sum1_idx_3 / rtb_Switch2_l *
    0.079577471545947673 * 100000.0;

  /* Product: '<S8>/Product1' incorporates:
   *  DataTypeConversion: '<S8>/Data Type Conversion2'
   */
  rtb_Product1_fu = (real_T)Gen2_ref_B->BusInput3.SkipF.bSF_ON * rtb_Switch2_ba;

  /* Saturate: '<S625>/Saturation' */
  if (Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng <= 1.0) {
    delta_y = 1.0;
  } else {
    delta_y = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  }

  /* End of Saturate: '<S625>/Saturation' */

  /* Product: '<S625>/Divide1' */
  u0 = Gen2_ref_B->BusInput3.SpeedCtrl.rK_skip_iLQR / delta_y * rtb_Product1_fu;

  /* Saturate: '<S625>/Saturation1' */
  if (u0 > 1.0) {
    u0 = 1.0;
  } else if (u0 < 0.0) {
    u0 = 0.0;
  }

  /* End of Saturate: '<S625>/Saturation1' */

  /* Product: '<S625>/Product' incorporates:
   *  Constant: '<S625>/it_offset_ref2'
   *  Sum: '<S625>/Sum3'
   */
  rtb_Switch_nb = (1.0 - u0) * rtb_VariableIntegerDelay;

  /* Abs: '<S670>/Abs' */
  rtb_Switch2_l = fabs(rtb_Switch_nb);

  /* Switch: '<S670>/Switch' incorporates:
   *  Constant: '<S670>/Constant2'
   *  RelationalOperator: '<S670>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_l) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = rtb_Switch_nb;
  }

  /* End of Switch: '<S670>/Switch' */

  /* Product: '<S666>/Product1' */
  rtb_Divide3_g = Gen2_ref_B->Filter1_o.Switch / delta_y;

  /* Gain: '<S630>/Gain6' */
  rtb_Gain6_b = rtb_Gain3;

  /* Logic: '<S666>/Logical Operator3' incorporates:
   *  Logic: '<S714>/Logical Operator3'
   *  Logic: '<S830>/Logical Operator3'
   */
  rtb_LogicalOperator2_l = !Gen2_ref_B->BusInput3.SpeedCtrl.bKeAdaptON;

  /* Logic: '<S666>/Logical Operator2' incorporates:
   *  Logic: '<S666>/Logical Operator3'
   */
  rtb_LogicalOperator_f = (rtb_bResetHlci || rtb_LogicalOperator2_l);

  /* Delay: '<S666>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_i0 = ((rtb_LogicalOperator_f &&
    (Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_a != 1)) ||
    Gen2_ref_DWork->icLoad_i0);
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_a = rtb_LogicalOperator_f;
  for (i = 0; i < 13; i++) {
    if (Gen2_ref_DWork->icLoad_i0) {
      Gen2_ref_DWork->ResettableDelay_DSTATE_a[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y[i];
    }

    rtb_ResettableDelay_br[i] = Gen2_ref_DWork->ResettableDelay_DSTATE_a[i];
  }

  /* End of Delay: '<S666>/Resettable Delay' */

  /* S-Function (sfix_look1_dyn): '<S666>/gain scheduling Keng1' */
  /* Dynamic Look-Up Table Block: '<S666>/gain scheduling Keng1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_gainschedulingKeng1), &rtb_ResettableDelay_br[0],
                       rtb_Gain6_b,
                       &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_x[0],
                       12U, inst);

  /* Outputs for Atomic SubSystem: '<S667>/TP' */
  /* UnitDelay: '<S667>/Unit Delay2' incorporates:
   *  SignalConversion generated from: '<S667>/Bus Selector1'
   */
  Gen2_ref_TP(Gen2_ref_DWork->UnitDelay2_DSTATE_n,
              Gen2_ref_B->BusInput3.SpeedCtrl.rTp_KeEst_reset,
              &Gen2_ref_B->TP_p2, &Gen2_ref_DWork->TP_p2, inst);

  /* End of Outputs for SubSystem: '<S667>/TP' */

  /* Outputs for Atomic SubSystem: '<S667>/TON1' */
  Gen2_ref_TON_1(Gen2_ref_DWork->UnitDelay2_DSTATE_n,
                 Gen2_ref_B->BusInput3.SpeedCtrl.tOutOfNWindow,
                 &Gen2_ref_B->TON1, &Gen2_ref_DWork->TON1, inst);

  /* End of Outputs for SubSystem: '<S667>/TON1' */

  /* Switch: '<S667>/Switch2' incorporates:
   *  Constant: '<S667>/Constant1'
   *  Switch: '<S667>/Switch'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeEstResetOFF) {
    rtb_Switch2_ij = false;
  } else if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeEstreset_TP) {
    /* Switch: '<S667>/Switch' */
    rtb_Switch2_ij = Gen2_ref_B->TP_p2.LogicalOperator1;
  } else {
    /* Switch: '<S667>/Switch' incorporates:
     *  Logic: '<S667>/Logical Operator4'
     *  Logic: '<S667>/Logical Operator5'
     *  UnitDelay: '<S667>/Unit Delay2'
     */
    rtb_Switch2_ij = (Gen2_ref_DWork->UnitDelay2_DSTATE_n &&
                      (!Gen2_ref_B->TON1.LogicalOperator3));
  }

  /* End of Switch: '<S667>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S667>/TP1' */
  /* UnitDelay: '<S667>/Unit Delay2' incorporates:
   *  SignalConversion generated from: '<S667>/Bus Selector9'
   */
  Gen2_ref_TP(Gen2_ref_DWork->UnitDelay2_DSTATE_n,
              Gen2_ref_B->BusInput3.SpeedCtrl.rT_KeEstIncreaseTiF,
              &Gen2_ref_B->TP1_c, &Gen2_ref_DWork->TP1_c, inst);

  /* End of Outputs for SubSystem: '<S667>/TP1' */

  /* UnitDelay: '<S667>/Unit Delay1' */
  rtb_Switch2_l = Gen2_ref_DWork->UnitDelay1_DSTATE_e;

  /* DataTypeConversion: '<S667>/Data Type Conversion' */
  delta_y = floor(rtb_Switch2_l);
  if (rtIsNaN(delta_y) || rtIsInf(delta_y)) {
    delta_y = 0.0;
  } else {
    delta_y = fmod(delta_y, 65536.0);
  }

  /* Outputs for Atomic SubSystem: '<S667>/TOF' */
  /* RelationalOperator: '<S667>/Relational Operator' incorporates:
   *  DataTypeConversion: '<S667>/Data Type Conversion'
   */
  Gen2_ref_TOF(((delta_y < 0.0 ? (int32_T)(int16_T)-(int16_T)(uint16_T)-delta_y :
                 (int32_T)(int16_T)(uint16_T)delta_y) > 0),
               Gen2_ref_B->BusInput3.SpeedCtrl.rTof_KeEstPause_SkipF,
               &Gen2_ref_B->TOF_g, &Gen2_ref_DWork->TOF_g, inst);

  /* End of Outputs for SubSystem: '<S667>/TOF' */

  /* Switch: '<S667>/Switch3' incorporates:
   *  Constant: '<S667>/Constant2'
   *  Switch: '<S667>/Switch1'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeEstIncreaseTiFOFF) {
    rtb_Switch3_of = false;
  } else if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeEstPause_SkipF) {
    /* Switch: '<S667>/Switch1' incorporates:
     *  Logic: '<S667>/Logical Operator3'
     */
    rtb_Switch3_of = (Gen2_ref_B->TP1_c.LogicalOperator1 ||
                      Gen2_ref_B->TOF_g.LogicalOperator1);
  } else {
    /* Switch: '<S667>/Switch1' */
    rtb_Switch3_of = Gen2_ref_B->TP1_c.LogicalOperator1;
  }

  /* End of Switch: '<S667>/Switch3' */

  /* Outputs for Atomic SubSystem: '<S666>/Ke Map Update' */
  Gen2_ref_KeMapUpdate(rtb_Divide3_g, rtb_bResetHlci, rtb_gainschedulingKeng1,
                       rtb_Switch3_of, rtb_Switch2_ij, &Gen2_ref_B->BusInput3,
                       &Gen2_ref_B->KeMapUpdate, &Gen2_ref_DWork->KeMapUpdate, inst);

  /* End of Outputs for SubSystem: '<S666>/Ke Map Update' */

  /* Switch: '<S666>/Switch1' incorporates:
   *  Logic: '<S666>/Logical Operator4'
   */
  if (!Gen2_ref_B->BusInput3.SpeedCtrl.bActKeEst2Dof) {
    rtb_Switch1_ep = rtb_Divide3_g;
  } else {
    rtb_Switch1_ep = Gen2_ref_B->KeMapUpdate.Sum1;
  }

  /* End of Switch: '<S666>/Switch1' */

  /* Logic: '<S630>/Logical Operator1' incorporates:
   *  Logic: '<S630>/Logical Operator2'
   *  Logic: '<S636>/Logical Operator5'
   */
  rtb_LogicalOperator5_g_tmp = (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act &&
    (!Gen2_ref_B->BusInput3.SpeedCtrl.bKeMap4KF));

  /* Outputs for Atomic SubSystem: '<S630>/Filter' */
  /* Constant: '<S630>/Constant3' incorporates:
   *  Logic: '<S630>/Logical Operator1'
   *  Logic: '<S630>/Logical Operator3'
   *  Logic: '<S630>/Logical Operator4'
   */
  Gen2_ref_Filter(1.0, rtb_Switch1_ep, ((!rtb_LogicalOperator5_g_tmp) ||
    rtb_bResetHlci), &Gen2_ref_B->Filter_nk, &Gen2_ref_ConstB.Filter_nk,
                  &Gen2_ref_DWork->Filter_nk, inst);

  /* End of Outputs for SubSystem: '<S630>/Filter' */

  /* Gain: '<S636>/Gain6' */
  rtb_Gain6_jx = rtb_Gain3;

  /* Logic: '<S431>/Logical Operator' */
  rtb_LogicalOperator_hi = (rtb_bResetHlci ||
    Gen2_ref_B->BusInput3.SpeedCtrl.bActKeEstMapUpdate);

  /* Logic: '<S714>/Logical Operator2' incorporates:
   *  Logic: '<S715>/Logical Operator2'
   */
  rtb_LogicalOperator2_k_tmp = (rtb_LogicalOperator_hi || rtb_LogicalOperator2_l);

  /* Delay: '<S714>/Resettable Delay1' incorporates:
   *  Logic: '<S714>/Logical Operator2'
   */
  Gen2_ref_DWork->icLoad_np = ((rtb_LogicalOperator2_k_tmp &&
    (Gen2_ref_PrevZCSigState->ResettableDelay1_Reset_ZCE != 1)) ||
    Gen2_ref_DWork->icLoad_np);
  Gen2_ref_PrevZCSigState->ResettableDelay1_Reset_ZCE =
    rtb_LogicalOperator2_k_tmp;

  /* Delay: '<S714>/Resettable Delay' incorporates:
   *  Logic: '<S714>/Logical Operator2'
   */
  Gen2_ref_DWork->icLoad_j = ((rtb_LogicalOperator2_k_tmp &&
    (Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_e != 1)) ||
    Gen2_ref_DWork->icLoad_j);
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_e =
    rtb_LogicalOperator2_k_tmp;
  for (i = 0; i < 13; i++) {
    /* Delay: '<S714>/Resettable Delay1' */
    if (Gen2_ref_DWork->icLoad_np) {
      Gen2_ref_DWork->ResettableDelay1_DSTATE[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y[i];
    }

    /* Delay: '<S714>/Resettable Delay' */
    if (Gen2_ref_DWork->icLoad_j) {
      Gen2_ref_DWork->ResettableDelay_DSTATE_m[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y[i];
    }

    /* Switch: '<S714>/Switch' incorporates:
     *  Delay: '<S714>/Resettable Delay'
     *  Delay: '<S714>/Resettable Delay1'
     *  UnitDelay: '<S714>/Unit Delay1'
     */
    if (Gen2_ref_DWork->UnitDelay1_DSTATE_o) {
      rtb_ResettableDelay_br[i] = Gen2_ref_DWork->ResettableDelay1_DSTATE[i];
    } else {
      rtb_ResettableDelay_br[i] = Gen2_ref_DWork->ResettableDelay_DSTATE_m[i];
    }

    /* End of Switch: '<S714>/Switch' */
  }

  /* S-Function (sfix_look1_dyn): '<S714>/gain scheduling Keng1' */
  /* Dynamic Look-Up Table Block: '<S714>/gain scheduling Keng1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Switch2_l), &rtb_ResettableDelay_br[0],
                       rtb_Gain6_jx,
                       &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_x[0],
                       12U, inst);

  /* DiscreteIntegrator: '<S714>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S714>/Logical Operator2'
   */
  if (rtb_LogicalOperator2_k_tmp ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_o != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_l = 0.0;
  }

  /* Sum: '<S714>/Sum' incorporates:
   *  DiscreteIntegrator: '<S714>/Discrete-Time Integrator'
   */
  rtb_Sum_ig = rtb_Switch2_l + Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_l;

  /* Abs: '<S712>/Abs' */
  rtb_Switch2_l = rtb_Product1_e_tmp;

  /* Switch: '<S712>/Switch' incorporates:
   *  Constant: '<S712>/Constant2'
   *  RelationalOperator: '<S712>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_l) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = Gen2_ref_B->BusInput3.eng.rP_Nom;
  }

  /* End of Switch: '<S712>/Switch' */

  /* Product: '<S636>/Divide' */
  rtb_Switch2_l = rtb_Switch_i5[3] / delta_y;

  /* Gain: '<S636>/Gain7' */
  rtb_Gain7 = 0.001 * rtb_Switch2_l;

  /* RelationalOperator: '<S636>/Relational Operator' */
  rtb_RelationalOperator_ok = (rtb_Gain7 >
    Gen2_ref_B->BusInput3.SpeedCtrl.rMinPow_p2sGSC);

  /* Delay: '<S715>/Resettable Delay1' incorporates:
   *  Logic: '<S714>/Logical Operator2'
   */
  Gen2_ref_DWork->icLoad_a = ((rtb_LogicalOperator2_k_tmp &&
    (Gen2_ref_PrevZCSigState->ResettableDelay1_Reset_ZCE_g != 1)) ||
    Gen2_ref_DWork->icLoad_a);
  Gen2_ref_PrevZCSigState->ResettableDelay1_Reset_ZCE_g =
    rtb_LogicalOperator2_k_tmp;

  /* Delay: '<S715>/Resettable Delay' incorporates:
   *  Logic: '<S714>/Logical Operator2'
   */
  Gen2_ref_DWork->icLoad_m3 = ((rtb_LogicalOperator2_k_tmp &&
    (Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_b != 1)) ||
    Gen2_ref_DWork->icLoad_m3);
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_b =
    rtb_LogicalOperator2_k_tmp;
  for (i = 0; i < 7; i++) {
    /* Delay: '<S715>/Resettable Delay1' */
    if (Gen2_ref_DWork->icLoad_a) {
      Gen2_ref_DWork->ResettableDelay1_DSTATE_e[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_KengPOW_y[i];
    }

    /* Delay: '<S715>/Resettable Delay' */
    if (Gen2_ref_DWork->icLoad_m3) {
      Gen2_ref_DWork->ResettableDelay_DSTATE_e[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_KengPOW_y[i];
    }

    /* Switch: '<S715>/Switch' incorporates:
     *  Delay: '<S715>/Resettable Delay'
     *  Delay: '<S715>/Resettable Delay1'
     *  UnitDelay: '<S715>/Unit Delay1'
     */
    if (Gen2_ref_DWork->UnitDelay1_DSTATE_j) {
      rtb_Switch_dau[i] = Gen2_ref_DWork->ResettableDelay1_DSTATE_e[i];
    } else {
      rtb_Switch_dau[i] = Gen2_ref_DWork->ResettableDelay_DSTATE_e[i];
    }

    /* End of Switch: '<S715>/Switch' */
  }

  /* S-Function (sfix_look1_dyn): '<S715>/gain scheduling Keng1' */
  /* Dynamic Look-Up Table Block: '<S715>/gain scheduling Keng1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Switch2_l), &rtb_Switch_dau[0], rtb_Gain7,
                       &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_KengPOW_x
                       [0], 6U, inst);

  /* DiscreteIntegrator: '<S715>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_k_tmp ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_n != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_e = 0.0;
  }

  /* Sum: '<S715>/Sum' incorporates:
   *  DiscreteIntegrator: '<S715>/Discrete-Time Integrator'
   */
  rtb_Sum_gb = rtb_Switch2_l + Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_e;

  /* Switch: '<S636>/Switch2' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_Ke_iLQR) {
    /* Switch: '<S636>/Switch1' incorporates:
     *  Switch: '<S636>/Switch4'
     */
    if (rtb_RelationalOperator_ok) {
      /* Switch: '<S636>/Switch5' */
      if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeAdaptON) {
        rtb_Divide3_g = rtb_Sum_ig;
      } else {
        /* S-Function (sfix_look1_dyn): '<S636>/gain scheduling Keng' */
        /* Dynamic Look-Up Table Block: '<S636>/gain scheduling Keng'
         * Input0  Data Type:  Floating Point real_T
         * Input1  Data Type:  Floating Point real_T
         * Input2  Data Type:  Floating Point real_T
         * Output0 Data Type:  Floating Point real_T
         * Lookup Method: Linear_Endpoint
         *
         */
        LookUp_real_T_real_T( &(rtb_gainschedulingKeng),
                             &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y
                             [0], rtb_Gain6_jx,
                             &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_x
                             [0], 12U, inst);
        rtb_Divide3_g = rtb_gainschedulingKeng;
      }

      /* End of Switch: '<S636>/Switch5' */
    } else if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeAdaptON) {
      /* Switch: '<S636>/Switch4' */
      rtb_Divide3_g = rtb_Sum_gb;
    } else {
      /* S-Function (sfix_look1_dyn): '<S636>/gain scheduling KengPOW' incorporates:
       *  Switch: '<S636>/Switch4'
       */
      /* Dynamic Look-Up Table Block: '<S636>/gain scheduling KengPOW'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_gainschedulingKengPOW),
                           &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_KengPOW_y
                           [0], rtb_Gain7,
                           &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_KengPOW_x
                           [0], 6U, inst);

      /* Switch: '<S636>/Switch4' */
      rtb_Divide3_g = rtb_gainschedulingKengPOW;
    }

    /* End of Switch: '<S636>/Switch1' */
  } else {
    rtb_Divide3_g = Gen2_ref_B->BusInput3.SpeedCtrl.rFactKe_iLQR;
  }

  /* End of Switch: '<S636>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S636>/Filter' */
  /* Constant: '<S636>/Constant3' incorporates:
   *  Logic: '<S636>/Logical Operator3'
   *  Logic: '<S636>/Logical Operator4'
   */
  Gen2_ref_Filter(1.0, rtb_Divide3_g, ((!rtb_LogicalOperator5_g_tmp) ||
    rtb_LogicalOperator_hi), &Gen2_ref_B->Filter_m, &Gen2_ref_ConstB.Filter_m,
                  &Gen2_ref_DWork->Filter_m, inst);

  /* End of Outputs for SubSystem: '<S636>/Filter' */

  /* Switch: '<S431>/Switch2' incorporates:
   *  Switch: '<S636>/Switch3'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bActKeEstMapUpdate) {
    /* Switch: '<S630>/Switch3' incorporates:
     *  Logic: '<S630>/Logical Operator1'
     */
    if (rtb_LogicalOperator5_g_tmp) {
      rtb_Switch2_l = Gen2_ref_B->Filter_nk.Switch;
    } else {
      rtb_Switch2_l = rtb_Switch1_ep;
    }

    /* End of Switch: '<S630>/Switch3' */
  } else if (rtb_LogicalOperator5_g_tmp) {
    /* Switch: '<S636>/Switch3' */
    rtb_Switch2_l = Gen2_ref_B->Filter_m.Switch;
  } else {
    rtb_Switch2_l = rtb_Divide3_g;
  }

  /* End of Switch: '<S431>/Switch2' */

  /* Product: '<S431>/Product' */
  rtb_Product_o = rtb_Switch2_l * rtb_Switch_nb;

  /* Gain: '<S631>/Gain1' */
  rtb_Switch2_l = rtb_Switch2_ejy_tmp;

  /* Switch: '<S692>/Switch' incorporates:
   *  Abs: '<S692>/Abs'
   *  Constant: '<S692>/Constant2'
   *  RelationalOperator: '<S692>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Saturation6)) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = rtb_Saturation6;
  }

  /* End of Switch: '<S692>/Switch' */

  /* Product: '<S631>/Divide' incorporates:
   *  Sum: '<S631>/Sum'
   */
  rtb_Divide_i1 = (rtb_Switch_bs + rtb_Switch2_l) / delta_y;

  /* Switch: '<S693>/Switch' incorporates:
   *  Abs: '<S693>/Abs'
   *  Constant: '<S693>/Constant2'
   *  RelationalOperator: '<S693>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Divide_i1)) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = rtb_Divide_i1;
  }

  /* End of Switch: '<S693>/Switch' */

  /* Switch: '<S631>/Switch1' incorporates:
   *  Constant: '<S631>/Constant3'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bExternalOffsetON) {
    FILT_IN = rtb_Sum4_ny;
  } else {
    FILT_IN = 0.0;
  }

  /* End of Switch: '<S631>/Switch1' */

  /* Sum: '<S631>/Sum2' incorporates:
   *  Constant: '<S631>/it_offset_ref1'
   *  Product: '<S631>/Divide1'
   *  Product: '<S631>/Divide2'
   *  Sum: '<S631>/Sum1'
   */
  rtb_Gain2_cm = (rtb_Gain2_cm * rtb_Product_o / delta_y - 1.0) / rtb_Sum1_idx_2
    + FILT_IN;

  /* Switch: '<S696>/Switch2' incorporates:
   *  RelationalOperator: '<S696>/LowerRelop1'
   *  RelationalOperator: '<S696>/UpperRelop'
   *  Switch: '<S696>/Switch'
   */
  if (rtb_Gain2_cm > rtb_Switch2_n5) {
    rtb_Switch2_c4 = rtb_Switch2_n5;
  } else if (rtb_Gain2_cm < rtb_Switch1_k) {
    /* Switch: '<S696>/Switch' */
    rtb_Switch2_c4 = rtb_Switch1_k;
  } else {
    rtb_Switch2_c4 = rtb_Gain2_cm;
  }

  /* End of Switch: '<S696>/Switch2' */

  /* DiscreteIntegrator: '<S748>/Discrete-Time Integrator3' */
  if (rtb_LogicalOperator1_e || (Gen2_ref_DWork->DiscreteTimeIntegrator3_PrevRes
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator3_DSTATE = 0.0;
  }

  /* Switch: '<S748>/Switch1' incorporates:
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator3'
   *  Gain: '<S748>/Gain'
   *  Logic: '<S748>/Logical Operator4'
   *  Logic: '<S748>/Logical Operator5'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bTrackNbyLambda &&
      (!Gen2_ref_B->BusInput3.SpeedCtrl.bTrackNbyKe)) {
    rtb_Gain2_cm = -0.01 * Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_k;
  } else {
    rtb_Gain2_cm = Gen2_ref_DWork->DiscreteTimeIntegrator3_DSTATE;
  }

  /* End of Switch: '<S748>/Switch1' */

  /* Sum: '<S641>/Sum6' incorporates:
   *  Sum: '<S641>/Sum5'
   */
  rtb_Sum6_o_tmp = rtb_Switch2_c4 + rtb_Gain2_cm;

  /* Switch: '<S697>/Switch2' incorporates:
   *  Constant: '<S631>/it_offset_ref'
   *  RelationalOperator: '<S697>/LowerRelop1'
   *  RelationalOperator: '<S697>/UpperRelop'
   *  Switch: '<S697>/Switch'
   */
  if (0.0 > Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_max_iLQR) {
    rtb_Switch2_oou = Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_max_iLQR;
  } else if (0.0 < Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_min_iLQR) {
    /* Switch: '<S697>/Switch' */
    rtb_Switch2_oou = Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_min_iLQR;
  } else {
    rtb_Switch2_oou = 0.0;
  }

  /* End of Switch: '<S697>/Switch2' */

  /* Switch: '<S431>/Switch9' incorporates:
   *  Constant: '<S431>/Constant6'
   *  Rounding: '<S629>/Rounding Function'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bSF_OFF_iLQR) {
    rtb_Switch9_k = 0.0;
  } else {
    /* Sum: '<S629>/Sum1' */
    rtb_Gain2_cm = Gen2_ref_B->BusInput3.SkipF.rP_max_1 -
      Gen2_ref_B->BusInput3.SkipF.rP_max_0;

    /* Switch: '<S662>/Switch' incorporates:
     *  Abs: '<S662>/Abs'
     *  Constant: '<S662>/Constant2'
     *  RelationalOperator: '<S662>/Relational Operator'
     */
    if (2.2204460492503131E-16 >= fabs(rtb_Gain2_cm)) {
      rtb_Gain2_cm = 2.2204460492503131E-16;
    }

    /* End of Switch: '<S662>/Switch' */

    /* Sum: '<S629>/Sum3' incorporates:
     *  Gain: '<S629>/Gain'
     *  Product: '<S629>/Divide'
     *  Sum: '<S629>/Sum'
     *  Sum: '<S629>/Sum2'
     */
    rtb_Gain2_cm = (0.001 * rtb_Switch_bs - Gen2_ref_B->BusInput3.SkipF.rP_max_0)
      * (Gen2_ref_B->BusInput3.SkipF.rNum_max_P1 -
         Gen2_ref_B->BusInput3.SkipF.rNum_max_P0) / rtb_Gain2_cm +
      Gen2_ref_B->BusInput3.SkipF.rNum_max_P0;

    /* Switch: '<S663>/Switch2' incorporates:
     *  Constant: '<S629>/Constant5'
     *  RelationalOperator: '<S663>/LowerRelop1'
     *  RelationalOperator: '<S663>/UpperRelop'
     *  Switch: '<S663>/Switch'
     */
    if (rtb_Gain2_cm > Gen2_ref_B->BusInput3.SkipF.rNum_max) {
      rtb_Gain2_cm = Gen2_ref_B->BusInput3.SkipF.rNum_max;
    } else if (rtb_Gain2_cm < 0.0) {
      /* Switch: '<S663>/Switch' incorporates:
       *  Constant: '<S629>/Constant5'
       */
      rtb_Gain2_cm = 0.0;
    }

    /* End of Switch: '<S663>/Switch2' */
    rtb_Switch9_k = rt_roundd_snf(rtb_Gain2_cm, inst);
  }

  /* End of Switch: '<S431>/Switch9' */

  /* Switch: '<S698>/Switch2' incorporates:
   *  Constant: '<S431>/Nskip_min'
   *  RelationalOperator: '<S698>/LowerRelop1'
   *  RelationalOperator: '<S698>/UpperRelop'
   *  Switch: '<S698>/Switch'
   */
  if (rtb_Product1_fu > rtb_Switch9_k) {
    rtb_Gain2_cm = rtb_Switch9_k;
  } else if (rtb_Product1_fu < 0.0) {
    /* Switch: '<S698>/Switch' incorporates:
     *  Constant: '<S431>/Nskip_min'
     */
    rtb_Gain2_cm = 0.0;
  } else {
    rtb_Gain2_cm = rtb_Product1_fu;
  }

  /* End of Switch: '<S698>/Switch2' */

  /* DiscreteIntegrator: '<S748>/Discrete-Time Integrator2' */
  if (rtb_LogicalOperator1_e || (Gen2_ref_DWork->DiscreteTimeIntegrator2_PrevRes
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator2_DSTATE = 0.0;
  }

  /* Sum: '<S641>/Sum3' incorporates:
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator2'
   */
  rtb_Sum3_o = rtb_Gain2_cm + Gen2_ref_DWork->DiscreteTimeIntegrator2_DSTATE;

  /* Delay: '<S431>/Delay' incorporates:
   *  SignalConversion generated from: '<S431>/Delay'
   */
  if (Gen2_ref_DWork->icLoad_b3) {
    Gen2_ref_DWork->Delay_DSTATE_ba[0] = rtb_Sum2_a_tmp;
    Gen2_ref_DWork->Delay_DSTATE_ba[1] = rtb_Sum6_o_tmp;
    Gen2_ref_DWork->Delay_DSTATE_ba[2] = rtb_Switch2_oou;
    Gen2_ref_DWork->Delay_DSTATE_ba[3] = rtb_Sum3_o;
  }

  /* Switch: '<S694>/Switch' incorporates:
   *  Constant: '<S694>/Constant2'
   *  RelationalOperator: '<S694>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= r) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = rtb_Gain1_f_tmp;
  }

  /* End of Switch: '<S694>/Switch' */

  /* Product: '<S631>/Divide3' incorporates:
   *  Sum: '<S631>/Sum3'
   */
  rtb_Divide3_ep = (rtb_Switch_i5[3] + rtb_Switch2_l) / delta_y;

  /* Switch: '<S738>/Switch' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_iLQR_R1) {
    /* S-Function (sfix_look1_dyn): '<S738>/Lookup Table Dynamic' */
    /* Dynamic Look-Up Table Block: '<S738>/Lookup Table Dynamic'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Saturation Mode: Saturate
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T_SAT( &(rtb_LookupTableDynamic_l),
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_R1_y[0], rtb_Product1_aq,
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_RQT_x[0], 5U, inst);
    rtb_Divide3_i0[0] = Gen2_ref_B->BusInput3.SpeedCtrl.rR_iLQR[0];
    rtb_Divide3_i0[1] = rtb_LookupTableDynamic_l;
    rtb_Divide3_i0[2] = Gen2_ref_B->BusInput3.SpeedCtrl.rR_iLQR[2];
    rtb_Divide3_i0[3] = Gen2_ref_B->BusInput3.SpeedCtrl.rR_iLQR[3];
  } else {
    rtb_Divide3_i0[0] = Gen2_ref_B->BusInput3.SpeedCtrl.rR_iLQR[0];
    rtb_Divide3_i0[1] = Gen2_ref_B->BusInput3.SpeedCtrl.rR_iLQR[1];
    rtb_Divide3_i0[2] = Gen2_ref_B->BusInput3.SpeedCtrl.rR_iLQR[2];
    rtb_Divide3_i0[3] = Gen2_ref_B->BusInput3.SpeedCtrl.rR_iLQR[3];
  }

  /* End of Switch: '<S738>/Switch' */

  /* Product: '<S738>/Product' */
  rtb_Product_m[0] = Gen2_ref_B->BusInput3.SpeedCtrl.rFactorRilqr *
    rtb_Divide3_i0[0];
  rtb_Product_m[1] = Gen2_ref_B->BusInput3.SpeedCtrl.rFactorRilqr *
    rtb_Divide3_i0[1];
  rtb_Product_m[2] = Gen2_ref_B->BusInput3.SpeedCtrl.rFactorRilqr *
    rtb_Divide3_i0[2];
  rtb_Product_m[3] = Gen2_ref_B->BusInput3.SpeedCtrl.rFactorRilqr *
    rtb_Divide3_i0[3];

  /* Switch: '<S738>/Switch1' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_iLQR_Q0) {
    /* S-Function (sfix_look1_dyn): '<S738>/Lookup Table Dynamic1' */
    /* Dynamic Look-Up Table Block: '<S738>/Lookup Table Dynamic1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Saturation Mode: Saturate
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T_SAT( &(rtb_LookupTableDynamic1_g),
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Q0_y[0], rtb_Product1_aq,
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_RQT_x[0], 5U, inst);
    rtb_Switch1_cl[0] = rtb_LookupTableDynamic1_g;
    rtb_Switch1_cl[1] = Gen2_ref_B->BusInput3.SpeedCtrl.rQ_iLQR[1];
    rtb_Switch1_cl[2] = Gen2_ref_B->BusInput3.SpeedCtrl.rQ_iLQR[2];
  } else {
    rtb_Switch1_cl[0] = Gen2_ref_B->BusInput3.SpeedCtrl.rQ_iLQR[0];
    rtb_Switch1_cl[1] = Gen2_ref_B->BusInput3.SpeedCtrl.rQ_iLQR[1];
    rtb_Switch1_cl[2] = Gen2_ref_B->BusInput3.SpeedCtrl.rQ_iLQR[2];
  }

  /* End of Switch: '<S738>/Switch1' */

  /* Switch: '<S739>/Switch' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_iLQR_TBDC) {
    /* S-Function (sfix_look1_dyn): '<S739>/Lookup Table Dynamic2' */
    /* Dynamic Look-Up Table Block: '<S739>/Lookup Table Dynamic2'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Saturation Mode: Saturate
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T_SAT( &(rtb_LookupTableDynamic2_h),
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_TBDC_y[0], rtb_Product1_aq,
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_RQT_x[0], 5U, inst);
    rtb_Switch_czo = rtb_LookupTableDynamic2_h;
  } else {
    rtb_Switch_czo = Gen2_ref_B->BusInput3.SpeedCtrl.rTi_BDC_iLQR;
  }

  /* End of Switch: '<S739>/Switch' */

  /* S-Function (sfix_look1_dyn): '<S639>/Lookup Table Dynamic1' */
  /* Dynamic Look-Up Table Block: '<S639>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_kappa0),
                       &Gen2_ref_B->BusInput3.SpeedCtrl.rKappa0_iLQR_y[0],
                       rtb_Product1_aq,
                       &Gen2_ref_B->BusInput3.SpeedCtrl.rKappa0_iLQR_x[0], 4U, inst);

  /* Switch: '<S605>/Switch' incorporates:
   *  Constant: '<S605>/Constant2'
   *  RelationalOperator: '<S605>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Product1_e_tmp) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = Gen2_ref_B->BusInput3.eng.rP_Nom;
  }

  /* End of Switch: '<S605>/Switch' */

  /* Gain: '<S581>/Gain6' incorporates:
   *  Gain: '<S581>/Gain3'
   *  Product: '<S581>/Divide3'
   */
  rtb_Product1_aq = -(0.001 * rtb_Gain1_fr / delta_y);

  /* Saturate: '<S581>/Saturation' */
  if (rtb_Product1_aq > 1000.0) {
    rtb_Product1_aq = 1000.0;
  } else if (rtb_Product1_aq < 0.0) {
    rtb_Product1_aq = 0.0;
  }

  /* End of Saturate: '<S581>/Saturation' */

  /* Gain: '<S581>/Gain1' */
  rtb_Switch2_l = -rtb_Divide_mr_tmp;

  /* Saturate: '<S581>/Saturation1' */
  if (rtb_Switch2_l > 1000.0) {
    rtb_Divide3_g = 1000.0;
  } else if (rtb_Switch2_l < 0.0) {
    rtb_Divide3_g = 0.0;
  } else {
    rtb_Divide3_g = rtb_Switch2_l;
  }

  /* End of Saturate: '<S581>/Saturation1' */

  /* Product: '<S581>/Divide2' */
  rtb_Switch2_l = rtb_Divide3_g * Gen2_ref_B->BusInput3.SkipF.rKp_skiplevel;

  /* Sum: '<S581>/Sum1' incorporates:
   *  Product: '<S581>/Divide1'
   */
  rtb_rSkip_level = rtb_Product1_aq * Gen2_ref_B->BusInput3.SkipF.rKd_skiplevel
    + rtb_Switch2_l;

  /* Switch: '<S606>/Switch1' incorporates:
   *  Constant: '<S606>/Constant3'
   *  Logic: '<S581>/Logical Operator1'
   *  RelationalOperator: '<S581>/Relational Operator'
   *  RelationalOperator: '<S581>/Relational Operator1'
   *  RelationalOperator: '<S581>/Relational Operator2'
   *  UnitDelay: '<S606>/Unit Delay'
   */
  if (rtb_Divide3_g >= Gen2_ref_B->BusInput3.SkipF.rN_limit_skip_off) {
    rtb_LogicalOperator1_ja = ((rtb_Divide3_g >=
      Gen2_ref_B->BusInput3.SkipF.rN_limit_skip_on) || (rtb_Product1_aq >=
      Gen2_ref_B->BusInput3.SkipF.rProt_limit_skip_on) ||
      Gen2_ref_DWork->UnitDelay_DSTATE_ma);
  } else {
    rtb_LogicalOperator1_ja = false;
  }

  /* End of Switch: '<S606>/Switch1' */

  /* Switch: '<S581>/Switch1' incorporates:
   *  Constant: '<S581>/  2'
   */
  if (rtb_LogicalOperator1_ja) {
    rtb_Switch2_l = rtb_rSkip_level;
  } else {
    rtb_Switch2_l = 0.0;
  }

  /* End of Switch: '<S581>/Switch1' */

  /* UnitDelay: '<S608>/Unit Delay' */
  rtb_LogicalOperator5 = Gen2_ref_DWork->TP_state;

  /* Switch: '<S604>/Switch' incorporates:
   *  Abs: '<S604>/Abs'
   *  Constant: '<S604>/Constant2'
   *  RelationalOperator: '<S604>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(Gen2_ref_B->BusInput3.eng.rN_Nom)) {
    rtb_Saturation_o = 2.2204460492503131E-16;
  } else {
    rtb_Saturation_o = Gen2_ref_B->BusInput3.eng.rN_Nom;
  }

  /* End of Switch: '<S604>/Switch' */

  /* Outputs for Atomic SubSystem: '<S608>/SkipPulseWaitTP' */
  /* RelationalOperator: '<S611>/FixPt Relational Operator' incorporates:
   *  Constant: '<S608>/Constant'
   *  DataTypeConversion: '<S581>/Data Type Conversion8'
   *  Gain: '<S581>/ to Hz1'
   *  Gain: '<S581>/Hz to cycle period3'
   *  Product: '<S581>/Divide5'
   *  Sum: '<S608>/Sum'
   *  UnitDelay: '<S608>/Unit Delay'
   *  UnitDelay: '<S611>/Delay Input1'
   */
  Gen2_ref_TP(((int32_T)Gen2_ref_DWork->TP_state < (int32_T)
               Gen2_ref_DWork->DelayInput1_DSTATE), 2.0 * (60.0 * ((real_T)
    Gen2_ref_B->BusInput3.SkipF.iNr_cycles_ignON / rtb_Saturation_o)) - 0.01,
              &Gen2_ref_B->SkipPulseWaitTP, &Gen2_ref_DWork->SkipPulseWaitTP, inst);

  /* End of Outputs for SubSystem: '<S608>/SkipPulseWaitTP' */

  /* Logic: '<S581>/Logical Operator2' */
  rtb_LogicalOperator2_ov = !rtb_LogicalOperator1_ja;

  /* Logic: '<S608>/Logical Operator4' incorporates:
   *  Delay: '<S608>/Delay to avoid alg.loop'
   */
  rtb_LogicalOperator4_m5 = (Gen2_ref_DWork->Delaytoavoidalgloop_DSTATE ||
    Gen2_ref_B->SkipPulseWaitTP.LogicalOperator1 || rtb_LogicalOperator2_ov);

  /* DiscreteIntegrator: '<S608>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator4_m5 ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_m != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_h5 = 0.0;
  }

  /* Logic: '<S608>/Logical Operator1' incorporates:
   *  DiscreteIntegrator: '<S608>/Discrete-Time Integrator'
   *  Logic: '<S608>/Logical Operator2'
   *  Logic: '<S608>/Logical Operator3'
   *  RelationalOperator: '<S608>/Relational Operator'
   */
  rtb_LogicalOperator1_pa = ((Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_h5 >=
    Gen2_ref_B->BusInput3.SkipF.rThrsh_PulseGenerator_trigger) &&
    (!Gen2_ref_B->SkipPulseWaitTP.LogicalOperator1) && (!rtb_LogicalOperator2_ov));

  /* Switch: '<S581>/Switch' incorporates:
   *  RelationalOperator: '<S603>/FixPt Relational Operator'
   *  UnitDelay: '<S581>/Unit Delay'
   *  UnitDelay: '<S603>/Delay Input1'
   */
  if ((int32_T)rtb_LogicalOperator1_pa > (int32_T)
      Gen2_ref_DWork->DelayInput1_DSTATE_n) {
    rtb_Product1_aq = rtb_Switch2_l;
  } else {
    rtb_Product1_aq = Gen2_ref_DWork->UnitDelay_DSTATE_f;
  }

  /* End of Switch: '<S581>/Switch' */

  /* MinMax: '<S581>/MinMax' */
  if ((rtb_Switch2_l >= rtb_Product1_aq) || rtIsNaN(rtb_Product1_aq)) {
    rtb_Product1_aq = rtb_Switch2_l;
  }

  /* End of MinMax: '<S581>/MinMax' */

  /* Product: '<S581>/Product' */
  rtb_Divide3_g = rtb_Product1_aq * (real_T)rtb_LogicalOperator1_pa;

  /* Switch: '<S607>/Switch2' incorporates:
   *  Constant: '<S581>/  10'
   *  RelationalOperator: '<S607>/LowerRelop1'
   *  RelationalOperator: '<S607>/UpperRelop'
   *  Switch: '<S607>/Switch'
   */
  if (rtb_Divide3_g > Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng) {
    rtb_Divide1_h4 = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  } else if (rtb_Divide3_g < 0.0) {
    /* Switch: '<S607>/Switch' incorporates:
     *  Constant: '<S581>/  10'
     */
    rtb_Divide1_h4 = 0.0;
  } else {
    rtb_Divide1_h4 = rtb_Divide3_g;
  }

  /* End of Switch: '<S607>/Switch2' */

  /* Quantizer: '<S581>/Quantizer1' */
  rtb_Divide1_f1_tmp = rt_roundd_snf(rtb_Divide1_h4, inst);

  /* Gain: '<S582>/Gain1' incorporates:
   *  Gain: '<S581>/Gain1'
   */
  rtb_Gain1_o = -rtb_Divide_mr_tmp;

  /* Switch: '<S622>/Switch2' incorporates:
   *  Constant: '<S582>/  1'
   *  RelationalOperator: '<S622>/LowerRelop1'
   *  RelationalOperator: '<S622>/UpperRelop'
   *  Switch: '<S622>/Switch'
   */
  if (rtb_Gain1_o > 500.0) {
    rtb_Divide1_h4 = 500.0;
  } else if (rtb_Gain1_o < Gen2_ref_B->BusInput3.SkipF.rN_LevelNskip) {
    /* Switch: '<S622>/Switch' */
    rtb_Divide1_h4 = Gen2_ref_B->BusInput3.SkipF.rN_LevelNskip;
  } else {
    rtb_Divide1_h4 = rtb_Gain1_o;
  }

  /* End of Switch: '<S622>/Switch2' */

  /* Product: '<S582>/Product1' incorporates:
   *  Sum: '<S582>/Sum3'
   */
  rtb_Divide3_g = (rtb_Divide1_h4 - Gen2_ref_B->BusInput3.SkipF.rN_LevelNskip) *
    Gen2_ref_B->BusInput3.SkipF.rKp;

  /* MATLAB Function: '<S582>/MATLAB Function1' */
  Gen2_ref_MATLABFunction_n(rtb_Divide3_g, Gen2_ref_B->BusInput3.SkipF.rHy_eps,
    &Gen2_ref_B->sf_MATLABFunction1_e, &Gen2_ref_DWork->sf_MATLABFunction1_e, inst);

  /* Gain: '<S582>/Gain3' */
  rtb_Divide1_h4 = -Gen2_ref_B->BusInput3.SkipF.rN_LevelNskip_lowN;

  /* Switch: '<S623>/Switch2' incorporates:
   *  RelationalOperator: '<S623>/LowerRelop1'
   */
  if (!(rtb_Gain1_o > rtb_Divide1_h4)) {
    /* Switch: '<S623>/Switch' incorporates:
     *  Constant: '<S582>/  2'
     *  RelationalOperator: '<S623>/UpperRelop'
     */
    if (rtb_Gain1_o < -500.0) {
      rtb_Divide1_h4 = -500.0;
    } else {
      rtb_Divide1_h4 = rtb_Gain1_o;
    }

    /* End of Switch: '<S623>/Switch' */
  }

  /* End of Switch: '<S623>/Switch2' */

  /* Product: '<S582>/Product2' incorporates:
   *  Sum: '<S582>/Sum8'
   */
  rtb_Gain1_o = (Gen2_ref_B->BusInput3.SkipF.rN_LevelNskip_lowN + rtb_Divide1_h4)
    * Gen2_ref_B->BusInput3.SkipF.rKp_lowN;

  /* MATLAB Function: '<S582>/MATLAB Function' */
  Gen2_ref_MATLABFunction_n(rtb_Gain1_o, Gen2_ref_B->BusInput3.SkipF.rHy_eps,
    &Gen2_ref_B->sf_MATLABFunction_k, &Gen2_ref_DWork->sf_MATLABFunction_k, inst);

  /* Switch: '<S429>/Switch5' incorporates:
   *  Sum: '<S582>/Sum1'
   *  Switch: '<S582>/Switch1'
   */
  if (Gen2_ref_B->BusInput3.SkipF.bSkipfire_pulse_active) {
    /* Switch: '<S581>/Switch4' incorporates:
     *  Constant: '<S581>/  16'
     *  DataTypeConversion: '<S581>/Data Type Conversion6'
     */
    if (Gen2_ref_B->BusInput3.SkipF.bSkipfire_pulse_active) {
      rtb_Switch5_iq = (real32_T)rtb_Divide1_f1_tmp;
    } else {
      rtb_Switch5_iq = 0.0;
    }

    /* End of Switch: '<S581>/Switch4' */
  } else {
    if (Gen2_ref_B->BusInput3.SkipF.bSFroundFB_ON) {
      /* Switch: '<S582>/Switch1' */
      rtb_Divide3_g = Gen2_ref_B->sf_MATLABFunction1_e.y;
    }

    /* Switch: '<S582>/Switch' */
    if (Gen2_ref_B->BusInput3.SkipF.bSFroundFB_ON_lowN) {
      rtb_Gain1_o = Gen2_ref_B->sf_MATLABFunction_k.y;
    }

    /* End of Switch: '<S582>/Switch' */
    rtb_Switch5_iq = rtb_Divide3_g + rtb_Gain1_o;
  }

  /* End of Switch: '<S429>/Switch5' */

  /* Switch: '<S632>/Switch2' incorporates:
   *  Constant: '<S431>/Constant'
   *  RelationalOperator: '<S632>/LowerRelop1'
   *  RelationalOperator: '<S632>/UpperRelop'
   *  Switch: '<S632>/Switch'
   */
  if (rtb_Switch5_iq > Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng) {
    rtb_Divide3_g = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  } else if (rtb_Switch5_iq < 0.0) {
    /* Switch: '<S632>/Switch' incorporates:
     *  Constant: '<S431>/Constant'
     */
    rtb_Divide3_g = 0.0;
  } else {
    rtb_Divide3_g = rtb_Switch5_iq;
  }

  /* End of Switch: '<S632>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S716>/TON' */
  /* Logic: '<S716>/Logical Operator1' incorporates:
   *  Logic: '<S716>/Logical Operator2'
   *  UnitDelay: '<S716>/Unit Delay3'
   */
  Gen2_ref_TON_1(((!Gen2_ref_DWork->UnitDelay3_DSTATE_go) &&
                  Gen2_ref_B->TON2.LogicalOperator3),
                 Gen2_ref_B->BusInput3.SpeedCtrl.rT_x_dist1_map_update,
                 &Gen2_ref_B->TON_j, &Gen2_ref_DWork->TON_j, inst);

  /* End of Outputs for SubSystem: '<S716>/TON' */

  /* Gain: '<S636>/Gain1' */
  rtb_Divide1_h4 = rtb_Gain3;

  /* UnitDelay: '<S716>/Unit Delay1' */
  for (i = 0; i < 13; i++) {
    rtb_Switch3_je[i] = Gen2_ref_DWork->UnitDelay1_DSTATE_f[i];
  }

  /* End of UnitDelay: '<S716>/Unit Delay1' */

  /* S-Function (sfix_look1_dyn): '<S716>/gain scheduling x_dist1' */
  /* Dynamic Look-Up Table Block: '<S716>/gain scheduling x_dist1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Switch2_l), &rtb_Switch3_je[0], rtb_Divide1_h4,
                       &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_KF_x_dist1_x[0],
                       12U, inst);

  /* Switch: '<S716>/Switch1' incorporates:
   *  Constant: '<S716>/Constant2'
   *  UnitDelay: '<S716>/Unit Delay2'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_GS_xdist1) {
    delta_y = Gen2_ref_DWork->UnitDelay2_DSTATE_m;
  } else {
    delta_y = 0.0;
  }

  /* End of Switch: '<S716>/Switch1' */

  /* Sum: '<S716>/Sum' */
  rtb_Gain1_o = delta_y + rtb_Switch2_l;

  /* MATLAB Function: '<S716>/MATLAB Function' incorporates:
   *  DataTypeConversion: '<S716>/Data Type Conversion6'
   */
  if ((!Gen2_ref_DWork->y_map_not_empty) || rtb_LogicalOperator_hi) {
    Gen2_ref_DWork->y_map_not_empty = true;
    for (i = 0; i < 13; i++) {
      Gen2_ref_DWork->y_map[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_KF_x_dist1_y[i];
      Gen2_ref_DWork->x_map[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_KF_x_dist1_x[i];
    }
  }

  u0 = Gen2_ref_minimum(Gen2_ref_DWork->x_map, inst);
  if ((u0 >= rtb_Divide1_h4) || rtIsNaN(rtb_Divide1_h4)) {
    rtb_Divide1_h4 = u0;
  }

  x = Gen2_ref_maximum_f(Gen2_ref_DWork->x_map, inst);
  if ((!(x <= rtb_Divide1_h4)) && (!rtIsNaN(rtb_Divide1_h4))) {
    x = rtb_Divide1_h4;
  }

  k = 0;
  if (!(x < Gen2_ref_DWork->x_map[0])) {
    for (i = 0; i < 13; i++) {
      if (x >= Gen2_ref_DWork->x_map[i]) {
        k = i;
      }
    }
  }

  if (k + 1 < 13) {
    if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_x_dist1_AdaptON &&
        (!rtb_LogicalOperator_hi)) {
      rtb_Switch_n = Gen2_ref_DWork->y_map[k + 1];
      delta_y_tmp_tmp = x - Gen2_ref_DWork->x_map[k];
      u0 = Gen2_ref_DWork->x_map[k + 1];
      delta_y = delta_y_tmp_tmp / (u0 - Gen2_ref_DWork->x_map[k]) *
        (rtb_Switch_n - Gen2_ref_DWork->y_map[k]) + Gen2_ref_DWork->y_map[k];
      delta_y = ((1.0 - (real_T)Gen2_ref_B->TON_j.LogicalOperator3) * delta_y +
                 (real_T)Gen2_ref_B->TON_j.LogicalOperator3 * rtb_Gain1_o) -
        delta_y;
      x = u0 - x;
      rtb_Gain1_o = delta_y_tmp_tmp + x;
      y_map_tmp = rtb_Gain1_o * x;
      y_map_tmp_0 = (delta_y_tmp_tmp * delta_y_tmp_tmp + y_map_tmp) -
        delta_y_tmp_tmp * x;
      Gen2_ref_DWork->y_map[k] += y_map_tmp * delta_y / y_map_tmp_0;
      Gen2_ref_DWork->y_map[k + 1] = rtb_Gain1_o * delta_y_tmp_tmp * delta_y /
        y_map_tmp_0 + rtb_Switch_n;
    }
  } else if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_x_dist1_AdaptON &&
             (!rtb_LogicalOperator_hi)) {
    Gen2_ref_DWork->y_map[12] = (1.0 - (real_T)
      Gen2_ref_B->TON_j.LogicalOperator3) * Gen2_ref_DWork->y_map[12] + (real_T)
      Gen2_ref_B->TON_j.LogicalOperator3 * rtb_Gain1_o;
  }

  for (i = 0; i < 13; i++) {
    rtb_y_map_new[i] = Gen2_ref_DWork->y_map[i];
  }

  /* End of MATLAB Function: '<S716>/MATLAB Function' */

  /* Switch: '<S636>/Switch6' incorporates:
   *  Constant: '<S636>/Constant2'
   *  Logic: '<S636>/Logical Operator2'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_GS_xdist1 &&
      Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act) {
    /* Gain: '<S636>/Gain2' */
    rtb_Gain1_o = rtb_Gain3;

    /* S-Function (sfix_look1_dyn): '<S636>/gain scheduling x_dist1' */
    /* Dynamic Look-Up Table Block: '<S636>/gain scheduling x_dist1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_gainschedulingx_dist1), &rtb_y_map_new[0],
                         rtb_Gain1_o,
                         &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_KF_x_dist1_x
                         [0], 12U, inst);
    rtb_Gain1_o = rtb_gainschedulingx_dist1;
  } else {
    rtb_Gain1_o = 0.0;
  }

  /* SignalConversion generated from: '<S627>/ SFunction ' incorporates:
   *  MATLAB Function: '<S431>/LQR Controller 3states'
   *  Sum: '<S641>/Sum2'
   *  Sum: '<S641>/Sum6'
   */
  rtb_TmpSignalConversionAtSFun_g[0] = rtb_Sum1_l;
  rtb_TmpSignalConversionAtSFun_g[1] = rtb_Sum2_a_tmp;
  rtb_TmpSignalConversionAtSFun_g[2] = rtb_Sum6_o_tmp;

  /* SignalConversion generated from: '<S627>/ SFunction ' incorporates:
   *  MATLAB Function: '<S431>/LQR Controller 3states'
   */
  rtb_Divide_ab[0] = rtb_Sum2_a_tmp;
  rtb_Divide_ab[1] = rtb_Sum6_o_tmp;
  rtb_Divide_ab[2] = rtb_Switch2_oou;
  rtb_Divide_ab[3] = rtb_Sum3_o;

  /* SignalConversion generated from: '<S627>/ SFunction ' incorporates:
   *  Gain: '<S431>/Gain1'
   *  MATLAB Function: '<S431>/LQR Controller 3states'
   */
  rtb_TmpSignalConversionAtSFun_p[0] = rtb_Gain1_f_tmp;
  rtb_TmpSignalConversionAtSFun_p[1] = rtb_Gain3;
  rtb_TmpSignalConversionAtSFun_p[2] = Gen2_ref_B->Filter_bd.Switch;

  /* SignalConversion generated from: '<S627>/ SFunction ' incorporates:
   *  Constant: '<S431>/Nskip_min'
   *  MATLAB Function: '<S431>/LQR Controller 3states'
   */
  rtb_Divide3_e[0] = Gen2_ref_B->BusInput3.traj.rPr_p2s_min;
  rtb_Divide3_e[1] = rtb_Switch1_k;
  rtb_Divide3_e[2] = Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_min_iLQR;
  rtb_Divide3_e[3] = 0.0;

  /* SignalConversion generated from: '<S627>/ SFunction ' incorporates:
   *  MATLAB Function: '<S431>/LQR Controller 3states'
   */
  rtb_Divide3_i0[0] = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  rtb_Divide3_i0[1] = rtb_Switch2_n5;
  rtb_Divide3_i0[2] = Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_max_iLQR;
  rtb_Divide3_i0[3] = rtb_Switch9_k;

  /* SignalConversion generated from: '<S627>/ SFunction ' incorporates:
   *  Constant: '<S639>/Constant'
   *  DataTypeConversion: '<S639>/Data Type Conversion'
   *  DataTypeConversion: '<S639>/Data Type Conversion1'
   *  MATLAB Function: '<S431>/LQR Controller 3states'
   *  Product: '<S639>/Product'
   */
  rtb_TmpSignalConversionAtSFunct[0] =
    Gen2_ref_B->BusInput3.SpeedCtrl.iNiter_iLQR;
  rtb_TmpSignalConversionAtSFunct[1] = rtb_Product1_b4;
  rtb_TmpSignalConversionAtSFunct[2] = Gen2_ref_B->BusInput3.eng.Ts;
  rtb_TmpSignalConversionAtSFunct[3] = Gen2_ref_B->BusInput3.eng.rJ_Eng *
    Gen2_ref_B->BusInput3.SpeedCtrl.rFactInertiaLQR;
  rtb_TmpSignalConversionAtSFunct[4] = rtb_Product_o;
  rtb_TmpSignalConversionAtSFunct[5] = rtb_Switch_czo;
  rtb_TmpSignalConversionAtSFunct[6] = rtb_Sum2_kg;
  rtb_TmpSignalConversionAtSFunct[7] =
    Gen2_ref_B->BusInput3.SpeedCtrl.rK_it2_iLQR;
  rtb_TmpSignalConversionAtSFunct[8] = rtb_Sum1_idx_2;
  rtb_TmpSignalConversionAtSFunct[9] = rtb_kappa0;
  rtb_TmpSignalConversionAtSFunct[10] =
    Gen2_ref_B->BusInput3.SpeedCtrl.rK_slope_iLQR;
  rtb_TmpSignalConversionAtSFunct[11] =
    Gen2_ref_B->BusInput3.SpeedCtrl.rK_skip_iLQR;
  rtb_TmpSignalConversionAtSFunct[12] = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  rtb_TmpSignalConversionAtSFunct[13] =
    Gen2_ref_B->BusInput3.SpeedCtrl.rN_DB_Lambda_act;
  rtb_TmpSignalConversionAtSFunct[14] = 1.0;
  rtb_TmpSignalConversionAtSFunct[15] =
    Gen2_ref_B->BusInput3.SpeedCtrl.iNiterRediLQR;
  rtb_TmpSignalConversionAtSFunct[16] = rtb_Product1_fu;
  rtb_TmpSignalConversionAtSFunct[17] = Gen2_ref_B->BusInput3.eng.rP_Nom;
  rtb_TmpSignalConversionAtSFunct[18] = Gen2_ref_B->BusInput3.eng.rN_Nom;
  rtb_TmpSignalConversionAtSFunct[19] = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  rtb_TmpSignalConversionAtSFunct[20] = Gen2_ref_B->BusInput3.LamLim.rLam_max;
  rtb_TmpSignalConversionAtSFunct[21] = rtb_Divide3_g;

  /* MATLAB Function: '<S431>/LQR Controller 3states' incorporates:
   *  DataTypeConversion: '<S639>/Data Type Conversion'
   *  DataTypeConversion: '<S639>/Data Type Conversion1'
   *  Delay: '<S431>/Delay'
   *  Gain: '<S431>/Gain1'
   *  Logic: '<S636>/Logical Operator1'
   *  SignalConversion generated from: '<S627>/ SFunction '
   *  Sum: '<S641>/Sum2'
   *  Sum: '<S641>/Sum6'
   *  Switch: '<S636>/Switch7'
   */
  rtb_Switch2_l = rtb_Gain1_f_tmp;
  y_map_tmp = rtb_Gain3;
  y_map_tmp_0 = Gen2_ref_B->Filter_bd.Switch;
  Gen2_ref_diag(&rtb_Product_m[0], R_2inp, inst);
  Gen2_ref_diag_i(rtb_Product_m, R, inst);
  Gen2_ref_diag_i2(rtb_Switch1_cl, Q, inst);
  for (i = 0; i < 12; i++) {
    rtb_K_LQR[i] = 0.0;
    K_2inp_aug[i] = 0.0;
  }

  delta_y = rt_roundd_snf(rtb_Product1_b4 / Gen2_ref_B->BusInput3.eng.Ts, inst);
  if (delta_y < 32768.0) {
    if (delta_y >= -32768.0) {
      Npred = (int16_T)delta_y;
    } else {
      Npred = MIN_int16_T;
    }
  } else {
    Npred = MAX_int16_T;
  }

  rtb_Product1_b4 = Gen2_ref_B->BusInput3.SpeedCtrl.rN_DB_Lambda_act *
    3.1415926535897931 / 30.0;
  rtb_TmpSignalConversionAtLoo_ht[1] = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  if (1.0 < rtb_TmpSignalConversionAtLoo_ht[1]) {
    delta_y = rtb_TmpSignalConversionAtLoo_ht[1];
  } else {
    delta_y = 1.0;
  }

  rtb_Sum2_kg = (1.0 - rtb_Divide3_g / delta_y) * rtb_Product_o;
  Gen2_ref_diag_i2(Gen2_ref_B->BusInput3.SpeedCtrl.rBd_KF, B_d, inst);
  rtb_Switch1_cl[0] = 0.0;
  rtb_Switch1_cl[1] = 0.0;
  rtb_Switch1_cl[2] = 0.0;
  Gen2_ref_diag_i2(Gen2_ref_B->BusInput3.SpeedCtrl.rR_KF, R_KF, inst);
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_x_dist1_AdaptON &&
      Gen2_ref_B->BusInput3.SpeedCtrl.bKF_GS_xdist1 &&
      Gen2_ref_B->TON_j.LogicalOperator3) {
    Gen2_ref_DWork->x_KF[0] = rtb_Gain1_f_tmp;
    Gen2_ref_DWork->x_KF[3] = 0.0;
    Gen2_ref_DWork->x_KF[1] = rtb_Gain3;
    Gen2_ref_DWork->x_KF[4] = 0.0;
    Gen2_ref_DWork->x_KF[2] = Gen2_ref_B->Filter_bd.Switch;
    Gen2_ref_DWork->x_KF[5] = 0.0;
  }

  if ((!Gen2_ref_DWork->P_not_empty) || rtb_bResetHlci) {
    for (i = 0; i < 9; i++) {
      Gen2_ref_DWork->P[i] = 0.0;
    }

    Gen2_ref_DWork->P_not_empty = true;
    for (i = 0; i < 36; i++) {
      Gen2_ref_DWork->P_2inp_aug[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      Gen2_ref_DWork->u2_past[i] = rtb_Sum6_o_tmp;
    }

    Gen2_ref_DWork->count = 1.0;
    Gen2_ref_DWork->red_comp = false;
    rtb_Product_m[0] = rtb_Sum2_a_tmp;
    rtb_Product_m[1] = rtb_Sum6_o_tmp;
    rtb_Product_m[2] = rtb_Switch2_oou;
    rtb_Product_m[3] = rtb_Sum3_o;
    Gen2_ref_DWork->x_KF[0] = rtb_Gain1_f_tmp;
    Gen2_ref_DWork->x_KF[3] = 0.0;
    Gen2_ref_DWork->x_KF[1] = rtb_Gain3;
    Gen2_ref_DWork->x_KF[4] = 0.0;
    Gen2_ref_DWork->x_KF[2] = Gen2_ref_B->Filter_bd.Switch;
    Gen2_ref_DWork->x_KF[5] = 0.0;
    for (i = 0; i < 36; i++) {
      Gen2_ref_DWork->P_KF[i] = c[i];
    }

    for (i = 0; i < 18; i++) {
      rtb_K_KF_out[i] = 0.0;
    }

    rtb_err_KF[0] = 0.0;
    rtb_x_KF_out_idx_0 = rtb_Gain1_f_tmp;
    rtb_x_sp_KF_idx_0 = rtb_Sum1_l;
    rtb_err_KF[1] = 0.0;
    rtb_x_KF_out_idx_1 = rtb_Gain3;
    rtb_x_sp_KF_idx_1 = rtb_Sum2_a_tmp;
    rtb_err_KF[2] = 0.0;
    rtb_x_KF_out_idx_2 = Gen2_ref_B->Filter_bd.Switch;
    rtb_x_sp_KF_idx_2 = rtb_Sum6_o_tmp;
    rtb_u_sp_KF[0] = rtb_Sum2_a_tmp;
    rtb_u_sp_KF[1] = rtb_Sum6_o_tmp;
    Gen2_ref_state_space_d(rtb_TmpSignalConversionAtSFun_g,
      rtb_TmpSignalConversionAtSFunct, rtb_Product_o, rtb_Phi_OUT, rtb_H_OUT,
      Hd_obs, inst);
    for (i = 0; i < 3; i++) {
      rtb_err_cont[i] = 0.0;
      Phi_aug_tmp_0 = i << 2;
      K_2inp_aug[Phi_aug_tmp_0] = rtb_H_OUT[i];
      K_2inp_aug[Phi_aug_tmp_0 + 1] = rtb_H_OUT[i + 3];
      K_2inp_aug[Phi_aug_tmp_0 + 2] = rtb_H_OUT[i + 6];
      K_2inp_aug[Phi_aug_tmp_0 + 3] = rtb_H_OUT[i + 9];
    }

    for (i = 0; i < 4; i++) {
      for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
        Phi_aug_tmp_0 = (Phi_aug_tmp << 2) + i;
        rtb_H_OUT_0[Phi_aug_tmp_0] = 0.0;
        rtb_H_OUT_0[Phi_aug_tmp_0] += Gen2_ref_DWork->P[3 * Phi_aug_tmp] *
          K_2inp_aug[i];
        rtb_H_OUT_0[Phi_aug_tmp_0] += Gen2_ref_DWork->P[3 * Phi_aug_tmp + 1] *
          K_2inp_aug[i + 4];
        rtb_H_OUT_0[Phi_aug_tmp_0] += Gen2_ref_DWork->P[3 * Phi_aug_tmp + 2] *
          K_2inp_aug[i + 8];
      }

      for (Phi_aug_tmp = 0; Phi_aug_tmp < 4; Phi_aug_tmp++) {
        rtb_H_OUT_tmp = (Phi_aug_tmp << 2) + i;
        R_0[rtb_H_OUT_tmp] = -(((rtb_H_OUT[3 * Phi_aug_tmp + 1] * rtb_H_OUT_0[i
          + 4] + rtb_H_OUT[3 * Phi_aug_tmp] * rtb_H_OUT_0[i]) + rtb_H_OUT[3 *
          Phi_aug_tmp + 2] * rtb_H_OUT_0[i + 8]) + R[rtb_H_OUT_tmp]);
      }
    }

    Gen2_ref_mldivide(R_0, K_2inp_aug, rtb_K_LQR_0, inst);
    for (i = 0; i < 4; i++) {
      for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
        rtb_H_OUT_tmp = (Phi_aug_tmp << 2) + i;
        tmp[rtb_H_OUT_tmp] = 0.0;
        tmp[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp] * rtb_K_LQR_0[i];
        tmp[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp + 1] *
          rtb_K_LQR_0[i + 4];
        tmp[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp + 2] *
          rtb_K_LQR_0[i + 8];
      }

      for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
        Phi_aug_tmp_0 = (Phi_aug_tmp << 2) + i;
        rtb_K_LQR[Phi_aug_tmp_0] = 0.0;
        rtb_K_LQR[Phi_aug_tmp_0] += rtb_Phi_OUT[3 * Phi_aug_tmp] * tmp[i];
        rtb_K_LQR[Phi_aug_tmp_0] += rtb_Phi_OUT[3 * Phi_aug_tmp + 1] * tmp[i + 4];
        rtb_K_LQR[Phi_aug_tmp_0] += rtb_Phi_OUT[3 * Phi_aug_tmp + 2] * tmp[i + 8];
      }
    }
  } else {
    if (Gen2_ref_DWork->red_comp) {
      rtb_Product1_fu = Gen2_ref_B->BusInput3.SpeedCtrl.iNiterRediLQR;
    } else {
      rtb_Product1_fu = Gen2_ref_B->BusInput3.SpeedCtrl.iNiter_iLQR;
    }

    Gen2_ref_state_space_d(rtb_TmpSignalConversionAtSFun_p,
      rtb_TmpSignalConversionAtSFunct, rtb_Product_o, rtb_Phi_OUT, rtb_H_OUT,
      Hd_obs, inst);
    if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_KeNskip_Obs) {
      Gen2_ref_state_space_d(rtb_TmpSignalConversionAtSFun_p,
        rtb_TmpSignalConversionAtSFunct, rtb_Sum2_kg, Phi_obs, H_aug, Hd_obs, inst);
    } else {
      Gen2_ref_state_space_d(rtb_TmpSignalConversionAtSFun_p,
        rtb_TmpSignalConversionAtSFunct, rtb_Product_o, Phi_obs, H_aug, Hd_obs, inst);
    }

    if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_use_Pg) {
      rtb_Sum4_g = rtb_Divide3_ep;
    } else {
      rtb_Sum4_g = rtb_Divide_i1;
    }

    if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_calc ||
        Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act ||
        Gen2_ref_B->BusInput3.SpeedCtrl.bKF_use_states) {
      rtb_Switch_n = Gen2_ref_B->BusInput3.eng.Ts;
      for (i = 0; i < 3; i++) {
        Phi_aug[6 * i] = Phi_obs[3 * i];
        Phi_aug_tmp_0 = (i + 3) * 6;
        Phi_aug[Phi_aug_tmp_0] = B_d[3 * i] * rtb_Switch_n;
        Phi_aug_tmp = 3 * i + 1;
        Phi_aug[6 * i + 1] = Phi_obs[Phi_aug_tmp];
        Phi_aug[Phi_aug_tmp_0 + 1] = B_d[Phi_aug_tmp] * rtb_Switch_n;
        Phi_aug_tmp = 3 * i + 2;
        Phi_aug[6 * i + 2] = Phi_obs[Phi_aug_tmp];
        Phi_aug[Phi_aug_tmp_0 + 2] = B_d[Phi_aug_tmp] * rtb_Switch_n;
      }

      for (i = 0; i < 6; i++) {
        Phi_aug[6 * i + 3] = b[3 * i];
        Phi_aug[6 * i + 4] = b[3 * i + 1];
        Phi_aug[6 * i + 5] = b[3 * i + 2];
      }

      rtb_Sum5_iu = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
      if (Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng < 1.0) {
        rtb_Sum5_iu = 1.0;
      }

      rtb_TmpSignalConversionAtSFun_0[0] = (1.0 - rtb_Divide3_g / rtb_Sum5_iu) *
        rtb_Product_o * Gen2_ref_B->BusInput3.eng.Ts * Gen2_ref_DWork->x_KF[1] /
        ((Gen2_ref_DWork->x_KF[2] * rtb_Sum1_idx_2 + 1.0) *
         rtb_TmpSignalConversionAtSFunct[3]);
      rtb_TmpSignalConversionAtSFun_0[1] = Gen2_ref_B->BusInput3.eng.Ts /
        rtb_Switch_czo * (Gen2_ref_DWork->Delay_DSTATE_ba[0] -
                          Gen2_ref_DWork->x_KF[1]);
      rtb_TmpSignalConversionAtSFun_0[2] = Gen2_ref_B->BusInput3.eng.Ts /
        rtb_TmpSignalConversionAtSFunct[6] * (Gen2_ref_DWork->Delay_DSTATE_ba[1]
        - Gen2_ref_DWork->x_KF[2]);
      rtb_TmpSignalConversionAtSFun_0[3] = 0.0;
      Hd_obs_0[0] = Gen2_ref_DWork->x_KF[0];
      Hd_obs_0[3] = 0.0;
      rtb_TmpSignalConversionAtSFun_0[4] = 0.0;
      Hd_obs_0[1] = Gen2_ref_DWork->x_KF[1];
      Hd_obs_0[4] = 0.0;
      rtb_TmpSignalConversionAtSFun_0[5] = 0.0;
      Hd_obs_0[2] = Gen2_ref_DWork->x_KF[2];
      Hd_obs_0[5] = 0.0;
      for (i = 0; i < 6; i++) {
        rtb_TmpSignalConversionAtSFun_1[i] = ((Phi_aug[i + 18] *
          Gen2_ref_DWork->x_KF[3] + Phi_aug[i + 24] * Gen2_ref_DWork->x_KF[4]) +
          Phi_aug[i + 30] * Gen2_ref_DWork->x_KF[5]) +
          (rtb_TmpSignalConversionAtSFun_0[i] + Hd_obs_0[i]);
      }

      Hd_obs_0[0] = Hd_obs[0] * rtb_Sum4_g;
      Hd_obs_0[3] = 0.0 * rtb_Sum4_g;
      Hd_obs_0[1] = Hd_obs[1] * rtb_Sum4_g;
      Hd_obs_0[4] = 0.0 * rtb_Sum4_g;
      Hd_obs_0[2] = Hd_obs[2] * rtb_Sum4_g;
      Hd_obs_0[5] = 0.0 * rtb_Sum4_g;
      rtb_TmpSignalConversionAtSFun_0[0] = B_d[0] * rtb_Gain1_o *
        Gen2_ref_B->BusInput3.eng.Ts;
      for (i = 0; i < 5; i++) {
        rtb_TmpSignalConversionAtSFun_0[i + 1] = 0.0;
      }

      for (i = 0; i < 6; i++) {
        x_[i] = (rtb_TmpSignalConversionAtSFun_1[i] + Hd_obs_0[i]) +
          rtb_TmpSignalConversionAtSFun_0[i];
        for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
          Phi_aug_0[Phi_aug_tmp + 6 * i] = 0.0;
        }

        for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
            Phi_aug_tmp_0 = 6 * i + Phi_aug_tmp;
            Phi_aug_0[Phi_aug_tmp_0] += Phi_aug[6 * rtb_H_OUT_tmp + Phi_aug_tmp]
              * Gen2_ref_DWork->P_KF[6 * i + rtb_H_OUT_tmp];
          }
        }
      }

      Gen2_ref_diag_i2a(Gen2_ref_B->BusInput3.SpeedCtrl.rQ_KF, Phi_aug_1, inst);
      for (i = 0; i < 6; i++) {
        for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
          delta_y = 0.0;
          for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
            delta_y += Phi_aug_0[6 * rtb_H_OUT_tmp + i] * Phi_aug[6 *
              rtb_H_OUT_tmp + Phi_aug_tmp];
          }

          Phi_aug_tmp_0 = 6 * Phi_aug_tmp + i;
          P_[Phi_aug_tmp_0] = Phi_aug_1[Phi_aug_tmp_0] + delta_y;
        }
      }

      for (i = 0; i < 18; i++) {
        Phi_obs_tmp[i] = C_aug[i];
        rtb_K_KF_out[i] = d[i];
      }

      for (i = 0; i < 3; i++) {
        for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
          k = 3 * Phi_aug_tmp + i;
          Phi_obs_tmp_0[k] = 0.0;
          for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
            Phi_obs_tmp_0[k] += (real_T)Phi_obs_tmp[3 * rtb_H_OUT_tmp + i] * P_
              [6 * Phi_aug_tmp + rtb_H_OUT_tmp];
          }
        }

        for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
          delta_y = 0.0;
          for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
            delta_y += Phi_obs_tmp_0[3 * rtb_H_OUT_tmp + i] * rtb_K_KF_out[6 *
              Phi_aug_tmp + rtb_H_OUT_tmp];
          }

          k = 3 * Phi_aug_tmp + i;
          Phi_obs[k] = R_KF[k] + delta_y;
        }
      }

      if (fabs(Gen2_ref_det(Phi_obs, inst)) <= 2.2204460492503131E-16) {
        for (i = 0; i < 3; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
            k = 3 * Phi_aug_tmp + i;
            Phi_obs_tmp_0[k] = 0.0;
            for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
              Phi_obs_tmp_0[k] += (real_T)Phi_obs_tmp[3 * rtb_H_OUT_tmp + i] *
                Gen2_ref_DWork->P_KF[6 * Phi_aug_tmp + rtb_H_OUT_tmp];
            }
          }

          for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
            delta_y = 0.0;
            for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
              delta_y += Phi_obs_tmp_0[3 * rtb_H_OUT_tmp + i] * rtb_K_KF_out[6 *
                Phi_aug_tmp + rtb_H_OUT_tmp];
            }

            k = 3 * Phi_aug_tmp + i;
            Phi_obs[k] = R_KF[k] + delta_y;
          }
        }
      }

      for (i = 0; i < 3; i++) {
        for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
          Phi_aug_tmp_0 = 6 * i + Phi_aug_tmp;
          Phi_obs_tmp_0[Phi_aug_tmp_0] = 0.0;
          for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
            Phi_obs_tmp_0[Phi_aug_tmp_0] += P_[6 * rtb_H_OUT_tmp + Phi_aug_tmp] *
              rtb_K_KF_out[6 * i + rtb_H_OUT_tmp];
          }
        }
      }

      Gen2_ref_mrdiv(Phi_obs_tmp_0, Phi_obs, rtb_K_KF_out, inst);
      for (i = 0; i < 6; i++) {
        for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
          k = 6 * Phi_aug_tmp + i;
          Phi_obs_tmp_0[k] = 0.0;
          Phi_obs_tmp_0[k] += Phi_obs[3 * Phi_aug_tmp] * rtb_K_KF_out[i];
          Phi_obs_tmp_0[k] += Phi_obs[3 * Phi_aug_tmp + 1] * rtb_K_KF_out[i + 6];
          Phi_obs_tmp_0[k] += Phi_obs[3 * Phi_aug_tmp + 2] * rtb_K_KF_out[i + 12];
        }

        for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
          k = 6 * Phi_aug_tmp + i;
          Gen2_ref_DWork->P_KF[k] = P_[k] - ((Phi_obs_tmp_0[i + 6] *
            rtb_K_KF_out[Phi_aug_tmp + 6] + Phi_obs_tmp_0[i] *
            rtb_K_KF_out[Phi_aug_tmp]) + Phi_obs_tmp_0[i + 12] *
            rtb_K_KF_out[Phi_aug_tmp + 12]);
        }
      }

      for (i = 0; i < 3; i++) {
        Phi_obs_tmp_1[i] = 0.0;
        for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
          Phi_obs_tmp_1[i] += (real_T)Phi_obs_tmp[3 * Phi_aug_tmp + i] *
            x_[Phi_aug_tmp];
        }

        rtb_err_KF[i] = (((real_T)b_a[i + 3] * rtb_Gain3 + (real_T)b_a[i] *
                          rtb_Gain1_f_tmp) + (real_T)b_a[i + 6] *
                         Gen2_ref_B->Filter_bd.Switch) - Phi_obs_tmp_1[i];
      }

      for (i = 0; i < 6; i++) {
        Gen2_ref_DWork->x_KF[i] = ((rtb_K_KF_out[i + 6] * rtb_err_KF[1] +
          rtb_K_KF_out[i] * rtb_err_KF[0]) + rtb_K_KF_out[i + 12] * rtb_err_KF[2])
          + x_[i];
      }

      rtb_x_KF_out_idx_0 = Gen2_ref_DWork->x_KF[0];
      rtb_Switch1_cl[0] = Gen2_ref_DWork->x_KF[3];
      rtb_x_KF_out_idx_1 = Gen2_ref_DWork->x_KF[1];
      rtb_Switch1_cl[1] = Gen2_ref_DWork->x_KF[4];
      rtb_x_KF_out_idx_2 = Gen2_ref_DWork->x_KF[2];
      rtb_Switch1_cl[2] = Gen2_ref_DWork->x_KF[5];
      if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_use_states ||
          Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act) {
        rtb_Switch2_l = Gen2_ref_DWork->x_KF[0];
        y_map_tmp = Gen2_ref_DWork->x_KF[1];
        y_map_tmp_0 = Gen2_ref_DWork->x_KF[2];
      }

      rtb_x_sp_KF_idx_0 = rtb_Sum1_l;
      if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_constr_handling) {
        if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_Lam_dyn_SP_shift) {
          FILT_IN = Gen2_ref_DWork->x_KF[3] + rtb_Gain1_o;
          rtb_x_sp_KF_idx_2 = ((FILT_IN * rtb_TmpSignalConversionAtSFunct[3] *
                                B_d[0] + rtb_Sum2_kg * rtb_Sum2_a_tmp) -
                               rtb_Divide_i1) / (rtb_Divide_i1 * rtb_Sum1_idx_2
            - rtb_TmpSignalConversionAtSFunct[3] * rtb_Sum1_idx_2 * FILT_IN *
            B_d[0]) + Gen2_ref_DWork->x_KF[5] * rtb_TmpSignalConversionAtSFunct
            [6] * B_d[8];
        } else {
          rtb_x_sp_KF_idx_1 = Gen2_ref_DWork->x_KF[3] + rtb_Gain1_o;
          rtb_x_sp_KF_idx_2 = ((rtb_x_sp_KF_idx_1 *
                                rtb_TmpSignalConversionAtSFunct[3] * B_d[0] +
                                rtb_Sum2_kg * rtb_Sum2_a_tmp) - rtb_Divide_i1) /
            (rtb_Divide_i1 * rtb_Sum1_idx_2 - rtb_TmpSignalConversionAtSFunct[3]
             * rtb_Sum1_idx_2 * rtb_x_sp_KF_idx_1 * B_d[0]);
        }

        if (rtb_x_sp_KF_idx_2 > rtb_Switch2_n5) {
          rtb_x_sp_KF_idx_2 = rtb_Switch2_n5;
        } else if (rtb_x_sp_KF_idx_2 < rtb_Switch1_k) {
          rtb_x_sp_KF_idx_2 = rtb_Switch1_k;
        }

        if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_p2s_dyn_SP_shift) {
          rtb_x_sp_KF_idx_1 = (rtb_Divide_i1 - (Gen2_ref_DWork->x_KF[3] +
            rtb_Gain1_o) * rtb_TmpSignalConversionAtSFunct[3] * B_d[0]) *
            (rtb_x_sp_KF_idx_2 * rtb_Sum1_idx_2 + 1.0) / rtb_Sum2_kg +
            Gen2_ref_DWork->x_KF[4] * rtb_Switch_czo * B_d[4];
        } else if ((rtb_Divide3_g > 0.0) &&
                   (!Gen2_ref_B->BusInput3.SpeedCtrl.bKF_constr_handlLR)) {
          rtb_x_sp_KF_idx_1 = rtb_Sum2_a_tmp;
        } else {
          rtb_x_sp_KF_idx_1 = (rtb_Divide_i1 - (Gen2_ref_DWork->x_KF[3] +
            rtb_Gain1_o) * rtb_TmpSignalConversionAtSFunct[3] * B_d[0]) *
            (rtb_x_sp_KF_idx_2 * rtb_Sum1_idx_2 + 1.0) / rtb_Sum2_kg;
        }
      } else {
        if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_p2s_dyn_SP_shift) {
          rtb_x_sp_KF_idx_1 = Gen2_ref_DWork->x_KF[4] * rtb_Switch_czo * B_d[4]
            + rtb_Sum2_a_tmp;
        } else {
          rtb_x_sp_KF_idx_1 = rtb_Sum2_a_tmp;
        }

        if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_Lam_dyn_SP_shift) {
          rtb_x_sp_KF_idx_2 = (((Gen2_ref_DWork->x_KF[3] + rtb_Gain1_o) *
                                rtb_TmpSignalConversionAtSFunct[3] * B_d[0] +
                                rtb_Sum2_kg * rtb_Sum2_a_tmp) - rtb_Divide_i1) /
            (rtb_Divide_i1 * rtb_Sum1_idx_2 - rtb_TmpSignalConversionAtSFunct[3]
             * rtb_Sum1_idx_2 * (Gen2_ref_DWork->x_KF[3] + rtb_Gain1_o) * B_d[0])
            + Gen2_ref_DWork->x_KF[5] * rtb_TmpSignalConversionAtSFunct[6] *
            B_d[8];
        } else {
          rtb_x_sp_KF_idx_2 = (((Gen2_ref_DWork->x_KF[3] + rtb_Gain1_o) *
                                rtb_TmpSignalConversionAtSFunct[3] * B_d[0] +
                                rtb_Sum2_kg * rtb_Sum2_a_tmp) - rtb_Divide_i1) /
            (rtb_Divide_i1 * rtb_Sum1_idx_2 - rtb_TmpSignalConversionAtSFunct[3]
             * rtb_Sum1_idx_2 * (Gen2_ref_DWork->x_KF[3] + rtb_Gain1_o) * B_d[0]);
        }
      }

      rtb_u_sp_KF[0] = rtb_x_sp_KF_idx_1;
      rtb_u_sp_KF[1] = rtb_x_sp_KF_idx_2;
    } else {
      rtb_err_KF[0] = 0.0;
      rtb_x_KF_out_idx_0 = rtb_Gain1_f_tmp * 0.0;
      rtb_x_sp_KF_idx_0 = 0.0;
      rtb_err_KF[1] = 0.0;
      rtb_x_KF_out_idx_1 = rtb_Gain3 * 0.0;
      rtb_x_sp_KF_idx_1 = 0.0;
      rtb_err_KF[2] = 0.0;
      rtb_x_KF_out_idx_2 = Gen2_ref_B->Filter_bd.Switch * 0.0;
      rtb_x_sp_KF_idx_2 = 0.0;
      rtb_u_sp_KF[0] = 0.0;
      rtb_u_sp_KF[1] = 0.0;
      for (i = 0; i < 18; i++) {
        rtb_K_KF_out[i] = 0.0;
      }
    }

    rtb_err_cont[0] = rtb_Sum1_l - rtb_Switch2_l;
    rtb_err_cont[1] = rtb_Sum2_a_tmp - y_map_tmp;
    rtb_err_cont[2] = rtb_Sum6_o_tmp - y_map_tmp_0;
    if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act) {
      rtb_Switch_n = Gen2_ref_B->BusInput3.eng.Ts;
      for (i = 0; i < 3; i++) {
        Phi_aug[6 * i] = rtb_Phi_OUT[3 * i];
        Phi_aug_tmp_0 = (i + 3) * 6;
        Phi_aug[Phi_aug_tmp_0] = B_d[3 * i] * rtb_Switch_n;
        Phi_aug_tmp = 3 * i + 1;
        Phi_aug[6 * i + 1] = rtb_Phi_OUT[Phi_aug_tmp];
        Phi_aug[Phi_aug_tmp_0 + 1] = B_d[Phi_aug_tmp] * rtb_Switch_n;
        Phi_aug_tmp = 3 * i + 2;
        Phi_aug[6 * i + 2] = rtb_Phi_OUT[Phi_aug_tmp];
        Phi_aug[Phi_aug_tmp_0 + 2] = B_d[Phi_aug_tmp] * rtb_Switch_n;
      }

      for (i = 0; i < 6; i++) {
        Phi_aug[6 * i + 3] = b[3 * i];
        Phi_aug[6 * i + 4] = b[3 * i + 1];
        Phi_aug[6 * i + 5] = b[3 * i + 2];
      }

      for (i = 0; i < 2; i++) {
        H_aug[6 * i] = rtb_H_OUT[3 * i];
        H_aug[6 * i + 3] = 0.0;
        H_aug[6 * i + 1] = rtb_H_OUT[3 * i + 1];
        H_aug[6 * i + 4] = 0.0;
        H_aug[6 * i + 2] = rtb_H_OUT[3 * i + 2];
        H_aug[6 * i + 5] = 0.0;
      }

      for (i = 0; i < 3; i++) {
        P_[6 * i] = Q[3 * i];
        Phi_aug_tmp_0 = (i + 3) * 6;
        P_[Phi_aug_tmp_0] = 0.0;
        P_[6 * i + 1] = Q[3 * i + 1];
        P_[Phi_aug_tmp_0 + 1] = 0.0;
        P_[6 * i + 2] = Q[3 * i + 2];
        P_[Phi_aug_tmp_0 + 2] = 0.0;
      }

      for (i = 0; i < 6; i++) {
        P_[6 * i + 3] = 0.0;
        P_[6 * i + 4] = 0.0;
        P_[6 * i + 5] = 0.0;
      }

      if (0 <= (int32_T)rtb_Product1_fu - 1) {
        for (i = 0; i < 6; i++) {
          Phi_aug_tmp_0 = i << 1;
          rtb_K_LQR[Phi_aug_tmp_0] = H_aug[i];
          rtb_K_LQR[Phi_aug_tmp_0 + 1] = H_aug[i + 6];
        }
      }

      for (k = 0; k < (int32_T)rtb_Product1_fu; k++) {
        for (i = 0; i < 2; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
            Phi_aug_tmp_0 = (Phi_aug_tmp << 1) + i;
            rtb_K_LQR_0[Phi_aug_tmp_0] = 0.0;
            for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
              rtb_K_LQR_0[Phi_aug_tmp_0] += rtb_K_LQR[(rtb_H_OUT_tmp << 1) + i] *
                Gen2_ref_DWork->P_2inp_aug[6 * Phi_aug_tmp + rtb_H_OUT_tmp];
            }
          }

          for (Phi_aug_tmp = 0; Phi_aug_tmp < 2; Phi_aug_tmp++) {
            delta_y = 0.0;
            for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
              delta_y += rtb_K_LQR_0[(rtb_H_OUT_tmp << 1) + i] * H_aug[6 *
                Phi_aug_tmp + rtb_H_OUT_tmp];
            }

            rtb_H_OUT_tmp = (Phi_aug_tmp << 1) + i;
            rtb_Product_m[rtb_H_OUT_tmp] = -(R_2inp[rtb_H_OUT_tmp] + delta_y);
          }
        }

        Gen2_ref_mldivide_j(rtb_Product_m, rtb_K_LQR, rtb_K_LQR_0, inst);
        for (i = 0; i < 2; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
            rtb_H_OUT_tmp = (Phi_aug_tmp << 1) + i;
            tmp[rtb_H_OUT_tmp] = 0.0;
            for (Phi_aug_tmp_0 = 0; Phi_aug_tmp_0 < 6; Phi_aug_tmp_0++) {
              tmp[rtb_H_OUT_tmp] += rtb_K_LQR_0[(Phi_aug_tmp_0 << 1) + i] *
                Gen2_ref_DWork->P_2inp_aug[6 * Phi_aug_tmp + Phi_aug_tmp_0];
            }
          }

          for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
            Phi_aug_tmp_0 = (Phi_aug_tmp << 1) + i;
            K_2inp_aug[Phi_aug_tmp_0] = 0.0;
            for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
              K_2inp_aug[Phi_aug_tmp_0] += tmp[(rtb_H_OUT_tmp << 1) + i] *
                Phi_aug[6 * Phi_aug_tmp + rtb_H_OUT_tmp];
            }
          }
        }

        for (i = 0; i < 6; i++) {
          rtb_H_OUT_0[i] = 0.0;
          Phi_aug_tmp_0 = i << 1;
          rtb_Sum2_kg = K_2inp_aug[Phi_aug_tmp_0];
          rtb_H_OUT_0[i] += rtb_Sum2_kg * R_2inp[0];
          rtb_Switch_czo = K_2inp_aug[Phi_aug_tmp_0 + 1];
          rtb_H_OUT_0[i] += rtb_Switch_czo * R_2inp[1];
          rtb_H_OUT_0[i + 6] = 0.0;
          rtb_H_OUT_0[i + 6] += rtb_Sum2_kg * R_2inp[2];
          rtb_H_OUT_0[i + 6] += rtb_Switch_czo * R_2inp[3];
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
            rtb_H_OUT_tmp = 6 * Phi_aug_tmp + i;
            P_2inp_aug_tmp[rtb_H_OUT_tmp] = 0.0;
            Phi_aug_tmp_0 = Phi_aug_tmp << 1;
            P_2inp_aug_tmp[rtb_H_OUT_tmp] += K_2inp_aug[Phi_aug_tmp_0] * H_aug[i];
            P_2inp_aug_tmp[rtb_H_OUT_tmp] += K_2inp_aug[Phi_aug_tmp_0 + 1] *
              H_aug[i + 6];
            Phi_aug_0[Phi_aug_tmp + 6 * i] = Phi_aug[rtb_H_OUT_tmp] +
              P_2inp_aug_tmp[rtb_H_OUT_tmp];
          }
        }

        for (i = 0; i < 6; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
            Phi_aug_tmp_0 = 6 * Phi_aug_tmp + i;
            Phi_aug_1[Phi_aug_tmp_0] = 0.0;
            for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
              Phi_aug_1[Phi_aug_tmp_0] += Phi_aug_0[6 * rtb_H_OUT_tmp + i] *
                Gen2_ref_DWork->P_2inp_aug[6 * Phi_aug_tmp + rtb_H_OUT_tmp];
            }
          }
        }

        for (i = 0; i < 36; i++) {
          Phi_aug_0[i] = Phi_aug[i] + P_2inp_aug_tmp[i];
        }

        for (i = 0; i < 6; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
            Phi_aug_tmp_0 = Phi_aug_tmp << 1;
            rtb_K_LQR_tmp = 6 * Phi_aug_tmp + i;
            P_2inp_aug_tmp[rtb_K_LQR_tmp] = (K_2inp_aug[Phi_aug_tmp_0 + 1] *
              rtb_H_OUT_0[i + 6] + K_2inp_aug[Phi_aug_tmp_0] * rtb_H_OUT_0[i]) +
              P_[rtb_K_LQR_tmp];
            Phi_aug_2[rtb_K_LQR_tmp] = 0.0;
            for (rtb_H_OUT_tmp = 0; rtb_H_OUT_tmp < 6; rtb_H_OUT_tmp++) {
              Phi_aug_2[rtb_K_LQR_tmp] += Phi_aug_1[6 * rtb_H_OUT_tmp + i] *
                Phi_aug_0[6 * Phi_aug_tmp + rtb_H_OUT_tmp];
            }
          }
        }

        for (i = 0; i < 36; i++) {
          Gen2_ref_DWork->P_2inp_aug[i] = P_2inp_aug_tmp[i] + Phi_aug_2[i];
        }
      }

      for (i = 0; i < 3; i++) {
        Phi_aug_tmp_0 = i << 2;
        rtb_H_OUT_tmp = i << 1;
        rtb_K_LQR[Phi_aug_tmp_0] = K_2inp_aug[rtb_H_OUT_tmp];
        rtb_K_LQR[Phi_aug_tmp_0 + 2] = 0.0;
        rtb_K_LQR[Phi_aug_tmp_0 + 1] = K_2inp_aug[rtb_H_OUT_tmp + 1];
        rtb_K_LQR[Phi_aug_tmp_0 + 3] = 0.0;
        Gen2_ref_DWork->P[3 * i] = Gen2_ref_DWork->P_2inp_aug[6 * i];
        Gen2_ref_DWork->P[3 * i + 1] = Gen2_ref_DWork->P_2inp_aug[6 * i + 1];
        Gen2_ref_DWork->P[3 * i + 2] = Gen2_ref_DWork->P_2inp_aug[6 * i + 2];
      }
    } else {
      if (0 <= (int32_T)rtb_Product1_fu - 1) {
        for (i = 0; i < 3; i++) {
          rtb_H_OUT_tmp = i << 2;
          rtb_H_OUT_0[rtb_H_OUT_tmp] = rtb_H_OUT[i];
          rtb_H_OUT_0[rtb_H_OUT_tmp + 1] = rtb_H_OUT[i + 3];
          rtb_H_OUT_0[rtb_H_OUT_tmp + 2] = rtb_H_OUT[i + 6];
          rtb_H_OUT_0[rtb_H_OUT_tmp + 3] = rtb_H_OUT[i + 9];
        }
      }

      for (k = 0; k < (int32_T)rtb_Product1_fu; k++) {
        for (i = 0; i < 4; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
            rtb_H_OUT_tmp = (Phi_aug_tmp << 2) + i;
            rtb_K_LQR[rtb_H_OUT_tmp] = 0.0;
            rtb_K_LQR[rtb_H_OUT_tmp] += rtb_H_OUT[3 * i] * Gen2_ref_DWork->P[3 *
              Phi_aug_tmp];
            rtb_K_LQR[rtb_H_OUT_tmp] += rtb_H_OUT[3 * i + 1] * Gen2_ref_DWork->
              P[3 * Phi_aug_tmp + 1];
            rtb_K_LQR[rtb_H_OUT_tmp] += rtb_H_OUT[3 * i + 2] * Gen2_ref_DWork->
              P[3 * Phi_aug_tmp + 2];
          }

          for (Phi_aug_tmp = 0; Phi_aug_tmp < 4; Phi_aug_tmp++) {
            rtb_H_OUT_tmp = (Phi_aug_tmp << 2) + i;
            R_0[rtb_H_OUT_tmp] = -(((rtb_H_OUT[3 * Phi_aug_tmp + 1] *
              rtb_K_LQR[i + 4] + rtb_H_OUT[3 * Phi_aug_tmp] * rtb_K_LQR[i]) +
              rtb_H_OUT[3 * Phi_aug_tmp + 2] * rtb_K_LQR[i + 8]) +
              R[rtb_H_OUT_tmp]);
          }
        }

        Gen2_ref_mldivide(R_0, rtb_H_OUT_0, rtb_K_LQR_0, inst);
        for (i = 0; i < 4; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
            rtb_H_OUT_tmp = (Phi_aug_tmp << 2) + i;
            tmp[rtb_H_OUT_tmp] = 0.0;
            tmp[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp] *
              rtb_K_LQR_0[i];
            tmp[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp + 1] *
              rtb_K_LQR_0[i + 4];
            tmp[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp + 2] *
              rtb_K_LQR_0[i + 8];
          }

          for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
            Phi_aug_tmp_0 = (Phi_aug_tmp << 2) + i;
            rtb_K_LQR[Phi_aug_tmp_0] = 0.0;
            rtb_K_LQR[Phi_aug_tmp_0] += rtb_Phi_OUT[3 * Phi_aug_tmp] * tmp[i];
            rtb_K_LQR[Phi_aug_tmp_0] += rtb_Phi_OUT[3 * Phi_aug_tmp + 1] * tmp[i
              + 4];
            rtb_K_LQR[Phi_aug_tmp_0] += rtb_Phi_OUT[3 * Phi_aug_tmp + 2] * tmp[i
              + 8];
          }
        }

        for (i = 0; i < 3; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
            rtb_H_OUT_tmp = 3 * Phi_aug_tmp + i;
            R_KF[rtb_H_OUT_tmp] = 0.0;
            Phi_aug_tmp_0 = Phi_aug_tmp << 2;
            R_KF[rtb_H_OUT_tmp] += rtb_K_LQR[Phi_aug_tmp_0] * rtb_H_OUT[i];
            R_KF[rtb_H_OUT_tmp] += rtb_K_LQR[Phi_aug_tmp_0 + 1] * rtb_H_OUT[i +
              3];
            R_KF[rtb_H_OUT_tmp] += rtb_K_LQR[Phi_aug_tmp_0 + 2] * rtb_H_OUT[i +
              6];
            R_KF[rtb_H_OUT_tmp] += rtb_K_LQR[Phi_aug_tmp_0 + 3] * rtb_H_OUT[i +
              9];
          }

          for (Phi_aug_tmp = 0; Phi_aug_tmp < 4; Phi_aug_tmp++) {
            Phi_aug_tmp_0 = 3 * Phi_aug_tmp + i;
            rtb_K_LQR_0[Phi_aug_tmp_0] = 0.0;
            rtb_H_OUT_tmp = i << 2;
            rtb_K_LQR_tmp = Phi_aug_tmp << 2;
            rtb_K_LQR_0[Phi_aug_tmp_0] += rtb_K_LQR[rtb_H_OUT_tmp] *
              R[rtb_K_LQR_tmp];
            rtb_K_LQR_0[Phi_aug_tmp_0] += rtb_K_LQR[rtb_H_OUT_tmp + 1] *
              R[rtb_K_LQR_tmp + 1];
            rtb_K_LQR_0[Phi_aug_tmp_0] += rtb_K_LQR[rtb_H_OUT_tmp + 2] *
              R[rtb_K_LQR_tmp + 2];
            rtb_K_LQR_0[Phi_aug_tmp_0] += rtb_K_LQR[rtb_H_OUT_tmp + 3] *
              R[rtb_K_LQR_tmp + 3];
          }

          Phi_obs[3 * i] = rtb_Phi_OUT[i] + R_KF[i];
          Phi_obs[3 * i + 1] = rtb_Phi_OUT[i + 3] + R_KF[i + 3];
          Phi_obs[3 * i + 2] = rtb_Phi_OUT[i + 6] + R_KF[i + 6];
        }

        for (i = 0; i < 3; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
            rtb_H_OUT_tmp = 3 * Phi_aug_tmp + i;
            rtb_Phi_OUT_0[rtb_H_OUT_tmp] = 0.0;
            rtb_Phi_OUT_0[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp] *
              Phi_obs[i];
            rtb_Phi_OUT_0[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp +
              1] * Phi_obs[i + 3];
            rtb_Phi_OUT_0[rtb_H_OUT_tmp] += Gen2_ref_DWork->P[3 * Phi_aug_tmp +
              2] * Phi_obs[i + 6];
          }
        }

        for (i = 0; i < 9; i++) {
          Phi_obs[i] = rtb_Phi_OUT[i] + R_KF[i];
        }

        for (i = 0; i < 3; i++) {
          for (Phi_aug_tmp = 0; Phi_aug_tmp < 3; Phi_aug_tmp++) {
            rtb_H_OUT_tmp = Phi_aug_tmp << 2;
            Phi_aug_tmp_0 = 3 * Phi_aug_tmp + i;
            R_KF[Phi_aug_tmp_0] = (((rtb_K_LQR[rtb_H_OUT_tmp + 1] *
              rtb_K_LQR_0[i + 3] + rtb_K_LQR[rtb_H_OUT_tmp] * rtb_K_LQR_0[i]) +
              rtb_K_LQR[rtb_H_OUT_tmp + 2] * rtb_K_LQR_0[i + 6]) +
              rtb_K_LQR[rtb_H_OUT_tmp + 3] * rtb_K_LQR_0[i + 9]) +
              Q[Phi_aug_tmp_0];
            rtb_Phi_OUT_1[Phi_aug_tmp_0] = 0.0;
            rtb_Phi_OUT_1[Phi_aug_tmp_0] += Phi_obs[3 * Phi_aug_tmp] *
              rtb_Phi_OUT_0[i];
            rtb_Phi_OUT_1[Phi_aug_tmp_0] += Phi_obs[3 * Phi_aug_tmp + 1] *
              rtb_Phi_OUT_0[i + 3];
            rtb_Phi_OUT_1[Phi_aug_tmp_0] += Phi_obs[3 * Phi_aug_tmp + 2] *
              rtb_Phi_OUT_0[i + 6];
          }
        }

        for (i = 0; i < 9; i++) {
          Gen2_ref_DWork->P[i] = R_KF[i] + rtb_Phi_OUT_1[i];
        }
      }
    }

    rtb_TmpSignalConversionAtSFun_0[0] = rtb_x_sp_KF_idx_0;
    rtb_TmpSignalConversionAtSFun_0[3] = 0.0;
    rtb_TmpSignalConversionAtSFun_1[0] = rtb_Switch2_l;
    rtb_TmpSignalConversionAtSFun_1[3] = 0.0;
    rtb_TmpSignalConversionAtSFun_0[1] = rtb_x_sp_KF_idx_1;
    rtb_TmpSignalConversionAtSFun_0[4] = 0.0;
    rtb_TmpSignalConversionAtSFun_1[1] = y_map_tmp;
    rtb_TmpSignalConversionAtSFun_1[4] = 0.0;
    rtb_TmpSignalConversionAtSFun_0[2] = rtb_x_sp_KF_idx_2;
    rtb_TmpSignalConversionAtSFun_0[5] = 0.0;
    rtb_TmpSignalConversionAtSFun_1[2] = y_map_tmp_0;
    rtb_TmpSignalConversionAtSFun_1[5] = 0.0;
    for (i = 0; i < 6; i++) {
      Hd_obs_0[i] = rtb_TmpSignalConversionAtSFun_0[i] -
        rtb_TmpSignalConversionAtSFun_1[i];
    }

    for (i = 0; i < 2; i++) {
      delta_y = 0.0;
      for (Phi_aug_tmp = 0; Phi_aug_tmp < 6; Phi_aug_tmp++) {
        delta_y += K_2inp_aug[(Phi_aug_tmp << 1) + i] * Hd_obs_0[Phi_aug_tmp];
      }

      R_2inp[i] = rtb_u_sp_KF[i] - delta_y;
    }

    R_2inp[2] = 0.0;
    R_2inp[3] = 0.0;
    if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act) {
      for (i = 0; i < 4; i++) {
        rtb_Product_m[i] = R_2inp[i];
      }

      for (i = 0; i < 3; i++) {
        Phi_aug_tmp = i << 2;
        k = i << 1;
        H_aug[Phi_aug_tmp] = K_2inp_aug[k];
        H_aug[Phi_aug_tmp + 2] = 0.0;
        H_aug[Phi_aug_tmp + 1] = K_2inp_aug[k + 1];
        H_aug[Phi_aug_tmp + 3] = 0.0;
      }

      R_2inp[0] = rtb_u_sp_KF[0];
      R_2inp[1] = rtb_u_sp_KF[1];
      R_2inp[2] = 0.0;
      R_2inp[3] = 0.0;
      Hd_obs[0] = rtb_x_sp_KF_idx_0;
      Hd_obs[1] = rtb_x_sp_KF_idx_1;
      Hd_obs[2] = rtb_x_sp_KF_idx_2;
    } else {
      for (i = 0; i < 4; i++) {
        rtb_Product_m[i] = rtb_Divide_ab[i] - ((rtb_K_LQR[i + 4] * rtb_err_cont
          [1] + rtb_K_LQR[i] * rtb_err_cont[0]) + rtb_K_LQR[i + 8] *
          rtb_err_cont[2]);
      }

      for (i = 0; i < 12; i++) {
        H_aug[i] = rtb_K_LQR[i];
      }

      R_2inp[0] = rtb_Sum2_a_tmp;
      R_2inp[1] = rtb_Sum6_o_tmp;
      R_2inp[2] = rtb_Switch2_oou;
      R_2inp[3] = rtb_Sum3_o;
      Hd_obs[0] = rtb_Sum1_l;
      Hd_obs[1] = rtb_Sum2_a_tmp;
      Hd_obs[2] = rtb_Sum6_o_tmp;
    }

    for (i = 0; i < 100; i++) {
      u_lambda_past[i] = 0.0;
    }

    for (k = 1; k - 1 < Npred; k++) {
      i = Npred + 1;
      if (Npred + 1 > 32767) {
        i = 32767;
      }

      delta_y = rt_roundd_snf(Gen2_ref_DWork->count - (real_T)i, inst);
      if (delta_y < 32768.0) {
        if (delta_y >= -32768.0) {
          tmp_0 = (int16_T)delta_y;
        } else {
          tmp_0 = MIN_int16_T;
        }
      } else {
        tmp_0 = MAX_int16_T;
      }

      i = tmp_0 + (int16_T)k;
      if (i > 32767) {
        i = 32767;
      } else if (i < -32768) {
        i = -32768;
      }

      if (i < 1) {
        i = Npred + 1;
        if (Npred + 1 > 32767) {
          i = 32767;
        }

        delta_y = rt_roundd_snf((real_T)i - Gen2_ref_DWork->count, inst);
        if (delta_y < 32768.0) {
          if (delta_y >= -32768.0) {
            tmp_0 = (int16_T)delta_y;
          } else {
            tmp_0 = MIN_int16_T;
          }
        } else {
          tmp_0 = MAX_int16_T;
        }

        i = 100 - tmp_0;
        if (delta_y < 32768.0) {
          if (delta_y >= -32768.0) {
            tmp_0 = (int16_T)delta_y;
          } else {
            tmp_0 = MIN_int16_T;
          }
        } else {
          tmp_0 = MAX_int16_T;
        }

        if (100 - tmp_0 > 32767) {
          i = 32767;
        }

        i += (int16_T)k;
        if (i > 32767) {
          i = 32767;
        } else if (i < -32768) {
          i = -32768;
        }

        u_lambda_past[(int16_T)k - 1] = Gen2_ref_DWork->u2_past[i - 1];
      } else {
        i = Npred + 1;
        if (Npred + 1 > 32767) {
          i = 32767;
        }

        delta_y = rt_roundd_snf(Gen2_ref_DWork->count - (real_T)i, inst);
        if (delta_y < 32768.0) {
          if (delta_y >= -32768.0) {
            tmp_0 = (int16_T)delta_y;
          } else {
            tmp_0 = MIN_int16_T;
          }
        } else {
          tmp_0 = MAX_int16_T;
        }

        i = tmp_0 + (int16_T)k;
        if (i > 32767) {
          i = 32767;
        } else if (i < -32768) {
          i = -32768;
        }

        u_lambda_past[(int16_T)k - 1] = Gen2_ref_DWork->u2_past[i - 1];
      }
    }

    rtb_TmpSignalConversionAtSFun_g[0] = rtb_Switch2_l;
    rtb_TmpSignalConversionAtSFun_g[1] = y_map_tmp;
    rtb_TmpSignalConversionAtSFun_g[2] = y_map_tmp_0;
    if (!Gen2_ref_B->BusInput3.SpeedCtrl.bPredFB_usePg) {
      rtb_Divide3_ep = rtb_Divide_i1;
    }

    Gen2_ref_integrate_model(rtb_TmpSignalConversionAtSFun_g, H_aug,
      u_lambda_past, rtb_Divide3_ep, rtb_Switch1_cl, B_d, rtb_Gain1_o, R_2inp,
      Hd_obs, Npred, rtb_Divide3_e, rtb_Divide3_i0,
      rtb_TmpSignalConversionAtSFunct, inst);
    if (rtb_Product1_b4 > 0.5) {
      rtb_Product1_fu = Hd_obs[0] - rtb_TmpSignalConversionAtSFun_g[0];
      if (rtb_Product1_fu > 0.0) {
        u0 = rtb_Product1_fu - rtb_Product1_b4;
        if (u0 >= 0.0) {
          Hd_obs[0] = u0;
        } else {
          Hd_obs[0] = 0.0;
        }
      } else {
        u0 = rtb_Product1_fu + rtb_Product1_b4;
        if (u0 <= 0.0) {
          Hd_obs[0] = u0;
        } else {
          Hd_obs[0] = 0.0;
        }
      }

      rtb_Product_m[1] = R_2inp[1] - (((Hd_obs[1] -
        rtb_TmpSignalConversionAtSFun_g[1]) * H_aug[5] + Hd_obs[0] * H_aug[1]) +
        (Hd_obs[2] - rtb_TmpSignalConversionAtSFun_g[2]) * H_aug[9]);
    } else {
      rtb_Product_m[1] = R_2inp[1] - (((Hd_obs[0] -
        rtb_TmpSignalConversionAtSFun_g[0]) * H_aug[1] + (Hd_obs[1] -
        rtb_TmpSignalConversionAtSFun_g[1]) * H_aug[5]) + (Hd_obs[2] -
        rtb_TmpSignalConversionAtSFun_g[2]) * H_aug[9]);
    }

    rtb_Product1_b4 = rtb_Product_m[0];
    if (rtb_Product_m[0] > Gen2_ref_B->BusInput3.traj.rPr_p2s_max) {
      rtb_Product1_b4 = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
    } else if (rtb_Product_m[0] < Gen2_ref_B->BusInput3.traj.rPr_p2s_min) {
      rtb_Product1_b4 = Gen2_ref_B->BusInput3.traj.rPr_p2s_min;
    }

    rtb_Product_m[0] = rtb_Product1_b4;
    rtb_Product1_b4 = rtb_Product_m[1];
    if (rtb_Product_m[1] > rtb_Switch2_n5) {
      rtb_Product1_b4 = rtb_Switch2_n5;
    } else if (rtb_Product_m[1] < rtb_Switch1_k) {
      rtb_Product1_b4 = rtb_Switch1_k;
    }

    rtb_Product_m[1] = rtb_Product1_b4;
    rtb_Product1_b4 = rtb_Product_m[2];
    if (rtb_Product_m[2] > Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_max_iLQR) {
      rtb_Product1_b4 = Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_max_iLQR;
    } else if (rtb_Product_m[2] <
               Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_min_iLQR) {
      rtb_Product1_b4 = Gen2_ref_B->BusInput3.SpeedCtrl.rDeltaZZP_min_iLQR;
    }

    rtb_Product_m[2] = rtb_Product1_b4;
    rtb_Product1_b4 = rtb_Product_m[3];
    if (rtb_Product_m[3] > rtb_Switch9_k) {
      rtb_Product1_b4 = rtb_Switch9_k;
    } else if (rtb_Product_m[3] < 0.0) {
      rtb_Product1_b4 = 0.0;
    }

    rtb_Product_m[3] = rtb_Product1_b4;
    Gen2_ref_DWork->u2_past[(int32_T)Gen2_ref_DWork->count - 1] = rtb_Product_m
      [1];
    Gen2_ref_DWork->count++;
    if (Gen2_ref_DWork->count > 100.0) {
      Gen2_ref_DWork->count = 1.0;
    }

    Gen2_ref_DWork->red_comp = true;
  }

  /* Sum: '<S749>/Sum' incorporates:
   *  Sum: '<S634>/Sum'
   */
  delta_y_tmp_tmp = rtb_Product_m[0] - rtb_Gain3;

  /* MATLAB Function: '<S749>/MATLAB Function' incorporates:
   *  Sum: '<S749>/Sum'
   */
  Gen2_ref_DWork->x_h -= 1.0 / Gen2_ref_B->BusInput3.SpeedCtrl.rTi_DPr_Limit *
    Gen2_ref_DWork->x_h * Gen2_ref_B->BusInput3.eng.Ts;
  if (delta_y_tmp_tmp > Gen2_ref_B->BusInput3.SpeedCtrl.rDPr_Limit) {
    Gen2_ref_DWork->SR_LoadStep = true;
    Gen2_ref_DWork->x_h = 1.0;
  } else if (delta_y_tmp_tmp < -Gen2_ref_B->BusInput3.SpeedCtrl.rDPr_Limit) {
    Gen2_ref_DWork->SR_LoadStep = false;
    Gen2_ref_DWork->x_h = 1.0;
  }

  rtb_Act = (Gen2_ref_DWork->x_h >
             Gen2_ref_B->BusInput3.SpeedCtrl.rDPr_Limit_Thrsh);

  /* Sum: '<S628>/Sum' incorporates:
   *  Sum: '<S634>/Sum1'
   *  Sum: '<S749>/Sum1'
   *  Sum: '<S8>/Sum'
   */
  rtb_Product1_c1_tmp = rtb_Switch_ks - rtb_Switch_i5[0];

  /* Switch: '<S628>/Switch' incorporates:
   *  Abs: '<S628>/Abs'
   *  Logic: '<S628>/Logical Operator'
   *  Logic: '<S628>/Logical Operator1'
   *  RelationalOperator: '<S628>/Relational Operator'
   *  Sum: '<S628>/Sum'
   */
  if ((!rtb_Act) && (Gen2_ref_B->BusInput3.SpeedCtrl.rN_thrshFiltLam > fabs
                     (rtb_Product1_c1_tmp))) {
    rtb_Product1_b4 = Gen2_ref_B->BusInput3.SpeedCtrl.rTi_LamCmd_iLQR;
  } else {
    rtb_Product1_b4 = Gen2_ref_B->BusInput3.eng.Ts;
  }

  /* End of Switch: '<S628>/Switch' */

  /* MATLAB Function: '<S628>/FILTER no delay' */
  Gen2_ref_FILTERnodelay(rtb_Product_m[1], rtb_Product1_b4,
    Gen2_ref_B->BusInput3.eng.Ts, rtb_bResetHlci,
    &Gen2_ref_B->sf_FILTERnodelay_b, &Gen2_ref_DWork->sf_FILTERnodelay_b, inst);

  /* Abs: '<S628>/Abs2' */
  rtb_Sum2_kg = fabs(Gen2_ref_B->BusInput3.SpeedCtrl.rNdbLambdaKp);

  /* Switch: '<S658>/Switch2' incorporates:
   *  Constant: '<S628>/  1'
   *  RelationalOperator: '<S658>/LowerRelop1'
   *  RelationalOperator: '<S658>/UpperRelop'
   *  Sum: '<S628>/Sum'
   *  Switch: '<S658>/Switch'
   */
  if (rtb_Product1_c1_tmp > 500.0) {
    rtb_Divide1_h4 = 500.0;
  } else if (rtb_Product1_c1_tmp < rtb_Sum2_kg) {
    /* Switch: '<S658>/Switch' */
    rtb_Divide1_h4 = rtb_Sum2_kg;
  } else {
    rtb_Divide1_h4 = rtb_Product1_c1_tmp;
  }

  /* End of Switch: '<S658>/Switch2' */

  /* Sum: '<S628>/Sum3' */
  rtb_Product1_fu = rtb_Divide1_h4 - rtb_Sum2_kg;

  /* Gain: '<S628>/Gain1' */
  rtb_Sum2_kg = rtb_Gain3;

  /* Switch: '<S659>/Switch' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_iLQR_addKpLam) {
    /* S-Function (sfix_look1_dyn): '<S659>/Lookup Table Dynamic2' */
    /* Dynamic Look-Up Table Block: '<S659>/Lookup Table Dynamic2'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Saturation Mode: Saturate
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T_SAT( &(rtb_LookupTableDynamic2_f),
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_addKpLam_Kp_y[0], rtb_Sum2_kg,
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_addKpLam_Kp_x[0], 5U, inst);
    rtb_Divide1_h4 = rtb_LookupTableDynamic2_f;
  } else {
    rtb_Divide1_h4 = Gen2_ref_B->BusInput3.SpeedCtrl.rGainLambdaKp;
  }

  /* End of Switch: '<S659>/Switch' */

  /* Product: '<S628>/Product1' incorporates:
   *  Abs: '<S628>/Abs1'
   *  Gain: '<S628>/Gain'
   */
  rtb_Product1_fu *= -0.001 * fabs(rtb_Divide1_h4);

  /* Switch: '<S659>/Switch1' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_iLQR_addKpLam) {
    /* S-Function (sfix_look1_dyn): '<S659>/Lookup Table Dynamic1' */
    /* Dynamic Look-Up Table Block: '<S659>/Lookup Table Dynamic1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Saturation Mode: Saturate
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T_SAT( &(rtb_LookupTableDynamic1_h),
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_addKpLam_Ti_y[0], rtb_Sum2_kg,
      &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_addKpLam_Kp_x[0], 5U, inst);
    rtb_Sum2_kg = rtb_LookupTableDynamic1_h;
  } else {
    rtb_Sum2_kg = Gen2_ref_B->BusInput3.SpeedCtrl.rTiLambdaKp;
  }

  /* End of Switch: '<S659>/Switch1' */

  /* Outputs for Atomic SubSystem: '<S628>/Filter' */
  Gen2_ref_Filter3(rtb_Product1_fu, rtb_Sum2_kg, Gen2_ref_ConstB.Constant2,
                   rtb_bResetHlci, &Gen2_ref_B->Filter_b,
                   &Gen2_ref_DWork->Filter_b, inst);

  /* End of Outputs for SubSystem: '<S628>/Filter' */

  /* MinMax: '<S628>/MinMax' */
  if ((!(rtb_Product1_fu <= Gen2_ref_B->Filter_b.Switch)) && (!rtIsNaN
       (Gen2_ref_B->Filter_b.Switch))) {
    rtb_Product1_fu = Gen2_ref_B->Filter_b.Switch;
  }

  /* End of MinMax: '<S628>/MinMax' */

  /* Sum: '<S628>/Sum1' */
  rtb_Sum2_kg = Gen2_ref_B->sf_FILTERnodelay_b.y + rtb_Product1_fu;

  /* Switch: '<S657>/Switch2' incorporates:
   *  RelationalOperator: '<S657>/LowerRelop1'
   *  RelationalOperator: '<S657>/UpperRelop'
   *  Switch: '<S657>/Switch'
   */
  if (rtb_Sum2_kg > rtb_Switch2_n5) {
    rtb_Sum2_kg = rtb_Switch2_n5;
  } else if (rtb_Sum2_kg < rtb_Switch1_k) {
    /* Switch: '<S657>/Switch' */
    rtb_Sum2_kg = rtb_Switch1_k;
  }

  /* End of Switch: '<S657>/Switch2' */

  /* Switch: '<S8>/Switch12' incorporates:
   *  Constant: '<S8>/Constant4'
   *  Logic: '<S8>/Logical Operator6'
   *  Logic: '<S8>/Logical Operator8'
   */
  if ((!Gen2_ref_B->BusInput3.SpeedCtrl.bSwitchOutputSampleSS) ||
      Gen2_ref_B->TON2.LogicalOperator3) {
    Npred = Gen2_ref_B->BusInput3.SpeedCtrl.iOutputSample;
  } else {
    Npred = 1;
  }

  /* End of Switch: '<S8>/Switch12' */

  /* MATLAB Function: '<S8>/IntegerZOH' */
  Gen2_ref_IntegerZOH(rtb_Sum2_kg, Npred, &Gen2_ref_B->sf_IntegerZOH_g,
                      &Gen2_ref_DWork->sf_IntegerZOH_g, inst);

  /* Switch: '<Root>/lam_cmd' */
  if (rtb_LogicalOperator) {
    rtb_Product1_fu = Gen2_ref_B->sf_MATLABFunction1_h.LamOut;
  } else {
    rtb_Product1_fu = Gen2_ref_B->sf_IntegerZOH_g.y;
  }

  /* End of Switch: '<Root>/lam_cmd' */

  /* Outputs for Atomic SubSystem: '<S267>/lam2cg' */
  Gen2_ref_lam2cg1(rtb_Product1_fu, Gen2_ref_B->BusInput3.eng.rMin_Air_Ratio_kg,
                   &Gen2_ref_B->lam2cg, inst);

  /* End of Outputs for SubSystem: '<S267>/lam2cg' */

  /* Product: '<S267>/Divide3' incorporates:
   *  Bias: '<S267>/Bias'
   *  Constant: '<S267>/R_air'
   *  Product: '<S267>/Divide2'
   */
  rtb_Divide3_n_tmp = (Gen2_ref_B->Mg.Bias * Gen2_ref_B->lam2cg.Divide + 1.0) *
    287.15;

  /* Product: '<S267>/Divide' incorporates:
   *  Product: '<S267>/Divide3'
   *  Product: '<S268>/Divide'
   */
  rtb_SumofElements_l = rtb_Switch2_gd_idx_0 * Gen2_ref_B->BusInput3.eng.rVol_GM
    / Gen2_ref_B->T1LP_filt.Switch;
  R_2inp[0] = rtb_SumofElements_l / rtb_Divide3_n_tmp *
    Gen2_ref_B->BusInput3.fdc.rCF[0];
  rtb_RoundingFunction = rtb_Switch2_gd_idx_1 *
    Gen2_ref_B->BusInput3.eng.rVol_IC_LP / Gen2_ref_B->T1HP_filt.Switch;
  R_2inp[1] = rtb_RoundingFunction / rtb_Divide3_n_tmp *
    Gen2_ref_B->BusInput3.fdc.rCF[1];
  rtb_Switch2_d1 = rtb_Switch2_gd_idx_2 * Gen2_ref_B->BusInput3.eng.rVol_IC_HP /
    Gen2_ref_B->T2s_filt.Switch;
  R_2inp[2] = rtb_Switch2_d1 / rtb_Divide3_n_tmp * Gen2_ref_B->
    BusInput3.fdc.rCF[2];
  rtb_Product1_mqz = rtb_Switch2_gd_idx_3 * Gen2_ref_B->BusInput3.eng.rVol_im /
    Gen2_ref_B->T2s_filt.Switch;
  R_2inp[3] = rtb_Product1_mqz / rtb_Divide3_n_tmp *
    Gen2_ref_B->BusInput3.fdc.rCF[3];

  /* Product: '<S267>/Divide1' incorporates:
   *  Sum: '<S267>/Sum of Elements'
   */
  rtb_Divide1_h4 = (((R_2inp[0] + R_2inp[1]) + R_2inp[2]) + R_2inp[3]) *
    Gen2_ref_B->lam2cg.Divide;

  /* Switch: '<S267>/Switch' incorporates:
   *  Constant: '<S267>/Constant5'
   */
  if (Gen2_ref_B->BusInput3.fdc.bActive_dyn) {
    rtb_Switch2_l = rtb_Divide1_h4;
  } else {
    rtb_Switch2_l = 0.0;
  }

  /* End of Switch: '<S267>/Switch' */

  /* MATLAB Function: '<S305>/FILTER no delay4' */
  Gen2_ref_FILTERnodelay(rtb_DataTypeConversion15,
    Gen2_ref_B->BusInput3.fdc.rTiF_N_GF, Gen2_ref_B->BusInput3.eng.Ts,
    rtb_bResetBdc, &Gen2_ref_B->sf_FILTERnodelay4,
    &Gen2_ref_DWork->sf_FILTERnodelay4, inst);

  /* Outputs for Atomic SubSystem: '<S306>/2nd Order Filter4' */
  /* DiscreteIntegrator: '<S318>/Discrete-Time Integrator' */
  if (rtb_bResetBdc || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_i3 != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ic = 0.0;
  }

  rtb_SumofElements = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ic;

  /* Product: '<S318>/Product' */
  rtb_Divide3_ep = Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltOmegaSpeed *
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltOmegaSpeed;

  /* Abs: '<S327>/Abs' */
  FILT_IN = fabs(rtb_Divide3_ep);

  /* Switch: '<S327>/Switch' incorporates:
   *  Constant: '<S327>/Constant2'
   *  RelationalOperator: '<S327>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= FILT_IN) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = rtb_Divide3_ep;
  }

  /* End of Switch: '<S327>/Switch' */

  /* Product: '<S318>/Divide1' */
  rtb_Sum4_g = rtb_DataTypeConversion15 / delta_y;

  /* DiscreteIntegrator: '<S318>/Discrete-Time Integrator1' */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator1_IC_LO_n != 0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_h = rtb_Sum4_g;
  }

  if (rtb_bResetBdc || (Gen2_ref_DWork->DiscreteTimeIntegrator1_Prev_ks != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_h = rtb_Sum4_g;
  }

  /* Product: '<S318>/Product1' incorporates:
   *  Constant: '<S318>/Constant1'
   */
  FILT_IN = Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltOmegaSpeed *
    Gen2_ref_B->BusInput3.fdc.r2ndOrdFiltDSpeed * 2.0;

  /* Switch: '<S318>/Switch' incorporates:
   *  DiscreteIntegrator: '<S318>/Discrete-Time Integrator1'
   *  Product: '<S318>/Product2'
   *  RelationalOperator: '<S318>/Relational Operator'
   */
  if (rtb_Divide3_ep > 0.0) {
    rtb_Switch_kr = Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_h *
      rtb_Divide3_ep;
  } else {
    rtb_Switch_kr = rtb_DataTypeConversion15;
  }

  /* End of Switch: '<S318>/Switch' */

  /* Update for DiscreteIntegrator: '<S318>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S318>/Discrete-Time Integrator1'
   *  Product: '<S318>/Product3'
   *  Product: '<S318>/Product4'
   *  Sum: '<S318>/Sum'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ic += ((rtb_DataTypeConversion15
    - rtb_Divide3_ep * Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_h) -
    FILT_IN * Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ic) * 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_i3 = (int8_T)rtb_bResetBdc;

  /* Update for DiscreteIntegrator: '<S318>/Discrete-Time Integrator1' incorporates:
   *  DiscreteIntegrator: '<S318>/Discrete-Time Integrator'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator1_IC_LO_n = 0U;
  Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_h += 0.01 * rtb_SumofElements;
  Gen2_ref_DWork->DiscreteTimeIntegrator1_Prev_ks = (int8_T)rtb_bResetBdc;

  /* End of Outputs for SubSystem: '<S306>/2nd Order Filter4' */

  /* Switch: '<S272>/Switch5' */
  if (Gen2_ref_B->BusInput3.fdc.bFiltdSpeedGasFlow) {
    /* Switch: '<S272>/Switch3' */
    if (Gen2_ref_B->BusInput3.fdc.bEnable2ndOrdFiltInputs) {
      /* Switch: '<S272>/Switch8' incorporates:
       *  Constant: '<S307>/Constant2'
       *  DiscreteIntegrator: '<S307>/Discrete-Time Integrator'
       *  Product: '<S307>/Product4'
       *  Product: '<S307>/Product5'
       *  Sum: '<S307>/Sum2'
       *  Sum: '<S307>/Sum4'
       */
      if (Gen2_ref_B->BusInput3.fdc.bEnableTransSwFilt) {
        rtb_Switch5_nn = (1.0 - Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d)
          * Gen2_ref_B->sf_FILTERnodelay4.y +
          Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d * rtb_Switch_kr;
      } else {
        rtb_Switch5_nn = rtb_Switch_kr;
      }

      /* End of Switch: '<S272>/Switch8' */
    } else {
      rtb_Switch5_nn = Gen2_ref_B->sf_FILTERnodelay4.y;
    }

    /* End of Switch: '<S272>/Switch3' */
  } else {
    rtb_Switch5_nn = rtb_DataTypeConversion15;
  }

  /* End of Switch: '<S272>/Switch5' */

  /* MATLAB Function: '<S305>/FILTER no delay5' */
  Gen2_ref_FILTERnodelay(rtb_p2s, Gen2_ref_B->BusInput3.fdc.rTiF_Pr_p2s_GF,
    Gen2_ref_B->BusInput3.eng.Ts, rtb_bResetBdc, &Gen2_ref_B->sf_FILTERnodelay5,
    &Gen2_ref_DWork->sf_FILTERnodelay5, inst);

  /* Switch: '<S272>/Switch4' */
  if (Gen2_ref_B->BusInput3.fdc.bFiltdPresGasFlow) {
    /* Switch: '<S272>/Switch1' */
    if (Gen2_ref_B->BusInput3.fdc.bEnable2ndOrdFiltInputs) {
      /* Switch: '<S272>/Switch7' incorporates:
       *  Constant: '<S307>/Constant2'
       *  DiscreteIntegrator: '<S307>/Discrete-Time Integrator'
       *  Product: '<S307>/Product2'
       *  Product: '<S307>/Product3'
       *  Sum: '<S307>/Sum1'
       *  Sum: '<S307>/Sum4'
       */
      if (Gen2_ref_B->BusInput3.fdc.bEnableTransSwFilt) {
        rtb_Switch4_p = (1.0 - Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d) *
          Gen2_ref_B->sf_FILTERnodelay5.y +
          Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d *
          Gen2_ref_B->undOrderFilter3.Switch;
      } else {
        rtb_Switch4_p = Gen2_ref_B->undOrderFilter3.Switch;
      }

      /* End of Switch: '<S272>/Switch7' */
    } else {
      rtb_Switch4_p = Gen2_ref_B->sf_FILTERnodelay5.y;
    }

    /* End of Switch: '<S272>/Switch1' */
  } else {
    rtb_Switch4_p = rtb_p2s;
  }

  /* End of Switch: '<S272>/Switch4' */

  /* Outputs for Atomic SubSystem: '<S267>/lam2cg1' */
  Gen2_ref_lam2cg1_a(rtb_Product1_fu, Gen2_ref_B->BusInput3.eng.rMin_Air_Ratio,
                     &Gen2_ref_B->lam2cg1_a, inst);

  /* End of Outputs for SubSystem: '<S267>/lam2cg1' */

  /* Switch: '<S273>/Switch' incorporates:
   *  Constant: '<S273>/Constant2'
   *  RelationalOperator: '<S273>/Relational Operator'
   */
  if (1.0 >= rtb_bResetHlci_0) {
    delta_y = 1.0;
  } else {
    delta_y = Gen2_ref_B->T2s_filt.Switch;
  }

  /* End of Switch: '<S273>/Switch' */

  /* Gain: '<S267>/Gain2' incorporates:
   *  Gain: '<S144>/Gain2'
   *  Gain: '<S268>/Gain2'
   */
  rtb_Gain_kp = 0.5 * Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng;

  /* Product: '<S267>/Divide8' incorporates:
   *  Gain: '<S267>/Gain1'
   *  Product: '<S268>/Divide8'
   */
  rtb_Sum_e = 0.016666666666666666 * rtb_Switch5_nn * rtb_etaVolConst_lt;

  /* Product: '<S267>/Product3' incorporates:
   *  Gain: '<S267>/Gain2'
   *  Gain: '<S267>/StandardCond'
   *  Product: '<S267>/Divide10'
   *  Product: '<S267>/Divide8'
   */
  rtb_Product3_g = rtb_Switch4_p / delta_y * 0.0026957809030347889 * rtb_Sum_e *
    Gen2_ref_B->lam2cg1_a.Divide * rtb_Gain_kp *
    Gen2_ref_B->BusInput3.eng.rRho_gas;

  /* Sum: '<S267>/Add1' */
  rtb_SumofElements = rtb_Switch2_l + rtb_Product3_g;

  /* Sum: '<S5>/Add' incorporates:
   *  Constant: '<S11>/Constant'
   *  Sum: '<S11>/Sum'
   */
  rtb_Switch2_l = 1.0 - Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2;

  /* Switch: '<S5>/Switch12' incorporates:
   *  Constant: '<S5>/Constant4'
   *  Logic: '<S5>/Logical Operator6'
   *  Logic: '<S5>/Logical Operator8'
   */
  if ((!Gen2_ref_B->BusInput3.fdc.bSwitchOutputSampleSS) ||
      Gen2_ref_B->TON2.LogicalOperator3) {
    Npred = Gen2_ref_B->BusInput3.fdc.iOutputSample;
  } else {
    Npred = 1;
  }

  /* End of Switch: '<S5>/Switch12' */

  /* MATLAB Function: '<S5>/IntegerZOH' incorporates:
   *  Product: '<S5>/Divide'
   */
  Gen2_ref_IntegerZOH(rtb_SumofElements * rtb_Switch2_l, Npred,
                      &Gen2_ref_B->sf_IntegerZOH_f,
                      &Gen2_ref_DWork->sf_IntegerZOH_f, inst);

  /* Product: '<S494>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S494>/sample time'
   *
   * About '<S494>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_l = Gen2_ref_B->BusInput3.LR.rRL_GasFlowSatCompUp * 0.01;

  /* UnitDelay: '<Root>/Unit Delay4' */
  rtb_Divide3_ep = Gen2_ref_DWork->UnitDelay4_DSTATE;

  /* Switch: '<S1>/Switch8' */
  if (Gen2_ref_B->BusInput3.bdcMisc.bUnfilteredFeedback) {
    rtb_MassFlowCalc = rtb_p2s;
  } else {
    rtb_MassFlowCalc = Gen2_ref_B->p2s_filt.Switch;
  }

  /* End of Switch: '<S1>/Switch8' */

  /* Outputs for Atomic SubSystem: '<S204>/p2HP_filt' */
  Gen2_ref_N_TC_HP_filt(rtb_p2HP, Gen2_ref_B->BusInput3.inFilt.rTiF_Pr,
                        rtb_bResetBdc, &Gen2_ref_B->p2HP_filt,
                        &Gen2_ref_DWork->p2HP_filt, inst);

  /* End of Outputs for SubSystem: '<S204>/p2HP_filt' */

  /* Switch: '<S1>/Switch9' */
  if (Gen2_ref_B->BusInput3.bdcMisc.bUnfilteredFeedback) {
    rtb_Switch2_a = rtb_p2HP;
  } else {
    rtb_Switch2_a = Gen2_ref_B->p2HP_filt.Switch;
  }

  /* End of Switch: '<S1>/Switch9' */

  /* Switch: '<S32>/Switch' incorporates:
   *  Abs: '<S32>/Abs'
   *  Constant: '<S32>/Constant2'
   *  RelationalOperator: '<S32>/Relational Operator'
   */
  if (0.1 >= fabs(rtb_Switch2_a)) {
    delta_y = 0.1;
  } else {
    delta_y = rtb_Switch2_a;
  }

  /* End of Switch: '<S32>/Switch' */

  /* Product: '<S1>/Divide' */
  rtb_Divide_br = rtb_MassFlowCalc / delta_y;

  /* Outputs for Atomic SubSystem: '<S202>/p1HP_filt' */
  Gen2_ref_N_TC_HP_filt(rtb_p1HP, Gen2_ref_B->BusInput3.inFilt.rTiF_Pr,
                        rtb_bResetBdc, &Gen2_ref_B->p1HP_filt,
                        &Gen2_ref_DWork->p1HP_filt, inst);

  /* End of Outputs for SubSystem: '<S202>/p1HP_filt' */

  /* Switch: '<S1>/Switch10' incorporates:
   *  Constant: '<S1>/Constant2'
   *  Switch: '<S1>/Switch11'
   */
  if (Gen2_ref_B->BusInput3.bdcMisc.bUnfilteredFeedback) {
    rtb_Switch2_oou = rtb_p1HP;
    x = rtb_p1LP;
  } else {
    rtb_Switch2_oou = Gen2_ref_B->p1HP_filt.Switch;
    x = 100000.0;
  }

  /* End of Switch: '<S1>/Switch10' */

  /* Abs: '<S34>/Abs' incorporates:
   *  Abs: '<S35>/Abs'
   */
  rtb_p1LP = fabs(x);
  rtb_Switch_n = rtb_p1LP;

  /* Switch: '<S34>/Switch' incorporates:
   *  Constant: '<S34>/Constant2'
   *  RelationalOperator: '<S34>/Relational Operator'
   */
  if (0.1 >= rtb_Switch_n) {
    delta_y = 0.1;
  } else {
    delta_y = x;
  }

  /* End of Switch: '<S34>/Switch' */

  /* Product: '<S1>/Divide2' */
  rtb_Divide2 = rtb_Switch2_oou / delta_y;

  /* Abs: '<S33>/Abs' */
  rtb_Switch_n = fabs(rtb_Switch2_oou);

  /* Switch: '<S33>/Switch' incorporates:
   *  Constant: '<S33>/Constant2'
   *  RelationalOperator: '<S33>/Relational Operator'
   */
  if (0.1 >= rtb_Switch_n) {
    rtb_Switch2_oou = 0.1;
  }

  /* End of Switch: '<S33>/Switch' */

  /* Product: '<S1>/Divide1' */
  rtb_Divide1_fn = rtb_Switch2_a / rtb_Switch2_oou;

  /* Abs: '<S35>/Abs' */
  rtb_Switch_n = rtb_p1LP;

  /* Switch: '<S35>/Switch' incorporates:
   *  Constant: '<S35>/Constant2'
   *  RelationalOperator: '<S35>/Relational Operator'
   */
  if (0.1 >= rtb_Switch_n) {
    x = 0.1;
  }

  /* End of Switch: '<S35>/Switch' */

  /* Product: '<S1>/Divide3' */
  rtb_Divide3_a0 = rtb_MassFlowCalc / x;

  /* MATLAB Function: '<S24>/MATLAB Function' incorporates:
   *  Gain: '<S24>/Gain'
   *  Sum: '<S24>/Sum'
   */
  Gen2_ref_MATLABFunction(1.0E-5 * Gen2_ref_B->p2s_filt.Switch,
    Gen2_ref_B->BusInput3.bdcMisc.rPrSwitchFFmethod,
    Gen2_ref_B->BusInput3.bdcMisc.rPrSwitchFFmethod +
    Gen2_ref_B->BusInput3.bdcMisc.rPrSwitchFFmethod_hys,
    &Gen2_ref_B->sf_MATLABFunction_f, &Gen2_ref_DWork->sf_MATLABFunction_f, inst);

  /* Abs: '<S139>/Abs' */
  rtb_Switch_n = fabs(Gen2_ref_B->BusInput3.eng.rNum_TCperStage);

  /* Switch: '<S139>/Switch' incorporates:
   *  Constant: '<S139>/Constant2'
   *  RelationalOperator: '<S139>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch_n) {
    rtb_Switch_n = 2.2204460492503131E-16;
  } else {
    rtb_Switch_n = Gen2_ref_B->BusInput3.eng.rNum_TCperStage;
  }

  /* End of Switch: '<S139>/Switch' */

  /* Gain: '<S144>/Gain1' */
  x = 0.016666666666666666 * rtb_DataTypeConversion15;

  /* Outputs for Atomic SubSystem: '<S144>/lam2cg1' */
  Gen2_ref_lam2cg1(rtb_Product1_fu, Gen2_ref_B->BusInput3.eng.rMin_Air_Ratio,
                   &Gen2_ref_B->lam2cg1, inst);

  /* End of Outputs for SubSystem: '<S144>/lam2cg1' */

  /* Gain: '<S144>/Gain2' */
  rtb_Switch2_a = rtb_Gain_kp;

  /* Switch: '<S149>/Switch' incorporates:
   *  Constant: '<S149>/Constant2'
   *  RelationalOperator: '<S149>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_bResetHlci_0) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = Gen2_ref_B->T2s_filt.Switch;
  }

  /* End of Switch: '<S149>/Switch' */

  /* Fcn: '<S144>/MassFlowCalc' incorporates:
   *  Constant: '<S144>/rhoAir'
   *  Gain: '<S144>/StandardCond'
   *  Product: '<S144>/Divide10'
   */
  rtb_MassFlowCalc = Gen2_ref_B->p2s_filt.Switch / delta_y *
    0.0026957809030347889 * (rtb_etaVolConst_lt * x) * rtb_Switch2_a * ((1.0 -
    Gen2_ref_B->lam2cg1.Divide) * 1.293 + Gen2_ref_B->lam2cg1.Divide *
    Gen2_ref_B->BusInput3.eng.rRho_gas);

  /* Logic: '<S1>/Logical Operator1' */
  rtb_LogicalOperator_hi = (Gen2_ref_B->BusInput3.bdcMisc.bReset_Filter ||
    Gen2_ref_B->BusInput3.bdcMisc.bActive_BDC);

  /* Sum: '<S31>/Diff' incorporates:
   *  UnitDelay: '<S31>/UD'
   */
  u0_0 = (uint8_T)(rtb_LogicalOperator_hi - Gen2_ref_DWork->UD_DSTATE);

  /* Saturate: '<S1>/Saturation1' */
  if (u0_0 > 1) {
    u0_0 = 1U;
  }

  /* End of Saturate: '<S1>/Saturation1' */

  /* Logic: '<S1>/Logical Operator2' incorporates:
   *  DataTypeConversion: '<S1>/Data Type Conversion21'
   */
  rtb_LogicalOperator2_dc = (rtb_bResetBdc || (u0_0 != 0));

  /* Outputs for Atomic SubSystem: '<S134>/Filter' */
  /* UnitDelay: '<S1>/Unit Delay1' */
  Gen2_ref_Filter3(Gen2_ref_DWork->UnitDelay1_DSTATE_ek,
                   Gen2_ref_B->BusInput3.SpeedCtrl.rTi_CBV_SurgeProtec,
                   Gen2_ref_ConstB.u, rtb_LogicalOperator2_dc,
                   &Gen2_ref_B->Filter, &Gen2_ref_DWork->Filter, inst);

  /* End of Outputs for SubSystem: '<S134>/Filter' */

  /* Lookup_n-D: '<S134>/LT%2deg' incorporates:
   *  Switch: '<S141>/Switch'
   */
  x = look1_binlxpw(Gen2_ref_B->Filter.Switch, Gen2_ref_ConstP.LT2deg_bp01Data,
                    Gen2_ref_ConstP.LT2deg_tableData, 3U, inst);

  /* S-Function (sfix_look1_dyn): '<S134>/Lookup Table Dynamic' */
  /* Dynamic Look-Up Table Block: '<S134>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_LookupTableDynamic),
                       &Gen2_ref_B->BusInput3.bdcCbv.rCd_vect_y[0], x,
                       &Gen2_ref_B->BusInput3.bdcCbv.rCd_vect_x[0], 10U, inst);

  /* MATLAB Function: '<S134>/MATLAB Function1' incorporates:
   *  Constant: '<S134>/Constant3'
   *  Constant: '<S1>/Constant2'
   *  Product: '<S134>/Product1'
   */
  if (Gen2_ref_B->p2HP_filt.Switch >= 100000.0) {
    if ((1.0E-6 >= Gen2_ref_B->p2HP_filt.Switch) || rtIsNaN
        (Gen2_ref_B->p2HP_filt.Switch)) {
      delta_y = 1.0E-6;
    } else {
      delta_y = Gen2_ref_B->p2HP_filt.Switch;
    }

    r = 100000.0 / delta_y;
    if ((1.0E-6 >= r) || rtIsNaN(r)) {
      r = 1.0E-6;
    }

    if (1.0 / r <= 1.8929291587378541) {
      u1 = sqrt(287.15 * Gen2_ref_B->T2s_filt.Switch);
      if ((1.0E-6 >= u1) || rtIsNaN(u1)) {
        u1 = 1.0E-6;
      }

      rtb_p1LP = 0.78539816339744828 * Gen2_ref_B->BusInput3.bdcCbv.rDref *
        Gen2_ref_B->BusInput3.bdcCbv.rDref * rtb_LookupTableDynamic *
        Gen2_ref_B->p2HP_filt.Switch / u1 * sqrt((rt_powd_snf(r,
        1.4285714285714286, inst) - rt_powd_snf(r, 1.7142857142857144, inst)) *
        7.0000000000000009);
    } else {
      u1 = sqrt(287.15 * Gen2_ref_B->T2s_filt.Switch);
      if ((1.0E-6 >= u1) || rtIsNaN(u1)) {
        u1 = 1.0E-6;
      }

      rtb_p1LP = 0.78539816339744828 * Gen2_ref_B->BusInput3.bdcCbv.rDref *
        Gen2_ref_B->BusInput3.bdcCbv.rDref * rtb_LookupTableDynamic *
        Gen2_ref_B->p2HP_filt.Switch / u1 * 0.6847314563772704;
    }
  } else {
    rtb_p1LP = 0.0;
  }

  /* End of MATLAB Function: '<S134>/MATLAB Function1' */

  /* Product: '<S134>/Divide1' */
  x = rtb_p1LP * Gen2_ref_B->BusInput3.eng.rNum_CBV;

  /* Fcn: '<S134>/CorredtedMassflow' incorporates:
   *  Product: '<S134>/Divide'
   *  Sum: '<S134>/Add2'
   *  UnitDelay: '<Root>/Unit Delay2'
   */
  rtb_p1LP = Gen2_ref_B->T1LP_filt.Switch / 298.0;
  if (rtb_p1LP < 0.0) {
    rtb_p1LP = -sqrt(-rtb_p1LP);
  } else {
    rtb_p1LP = sqrt(rtb_p1LP);
  }

  rtb_Switch_n = (((rtb_MassFlowCalc + x) + Gen2_ref_DWork->UnitDelay2_DSTATE_h
                   [2]) + Gen2_ref_DWork->UnitDelay2_DSTATE_h[3]) * (1.0 /
    rtb_Switch_n) * rtb_p1LP * 100000.0 / 100000.0;

  /* End of Fcn: '<S134>/CorredtedMassflow' */

  /* Fcn: '<S134>/SurgeLine1' */
  rtb_Saturation_gh = Gen2_ref_B->BusInput3.SpeedCtrl.rK_SurgeLine_LP *
    rtb_Switch_n + Gen2_ref_B->BusInput3.SpeedCtrl.rA_SurgeLine_LP;

  /* Saturate: '<S134>/Saturation' */
  if (rtb_Saturation_gh > 7.0) {
    rtb_Saturation_gh = 7.0;
  } else if (rtb_Saturation_gh < 1.0) {
    rtb_Saturation_gh = 1.0;
  }

  /* End of Saturate: '<S134>/Saturation' */

  /* Switch: '<S1>/Switch7' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bSwitch_SurgeLine_LIMIT) {
    /* Switch: '<S43>/Switch1' */
    if (Gen2_ref_B->BusInput3.SpeedCtrl.bSwitch_SurgeLine_LIMIT) {
      rtb_p1LP = rtb_Saturation_gh;
    } else {
      rtb_p1LP = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
    }

    /* End of Switch: '<S43>/Switch1' */
  } else {
    rtb_p1LP = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  }

  /* End of Switch: '<S1>/Switch7' */

  /* Switch: '<S58>/Switch2' incorporates:
   *  RelationalOperator: '<S58>/LowerRelop1'
   *  RelationalOperator: '<S58>/UpperRelop'
   *  Switch: '<S58>/Switch'
   */
  if (rtb_p1LP > Gen2_ref_B->BusInput3.traj.rPr_p2s_max) {
    rtb_Switch2_oou = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  } else if (rtb_p1LP < Gen2_ref_B->BusInput3.bdcMisc.rMinLimSurgeline) {
    /* Switch: '<S58>/Switch' */
    rtb_Switch2_oou = Gen2_ref_B->BusInput3.bdcMisc.rMinLimSurgeline;
  } else {
    rtb_Switch2_oou = rtb_p1LP;
  }

  /* End of Switch: '<S58>/Switch2' */

  /* UnitDelay: '<S62>/Unit Delay4' */
  rtb_LogicalOperator2_ov = Gen2_ref_DWork->UnitDelay4_DSTATE_k;

  /* Gain: '<S23>/Gain' */
  rtb_Gain_kl = rtb_kW2W1_h;
  for (i = 0; i < 5; i++) {
    /* Sum: '<S23>/Sum12' incorporates:
     *  Sum: '<S23>/Sum8'
     *  Sum: '<S25>/Sum2'
     *  Switch: '<S106>/Switch2'
     */
    rtb_Gain1_eu[i] = Gen2_ref_B->BusInput3.traj.rOffs_WS_Actuators +
      Gen2_ref_B->BusInput3.traj.rPrR_deltaP_TV_x[i];
  }

  /* S-Function (sfix_look1_dyn): '<S23>/Lookup Table Dynamic' */
  /* Dynamic Look-Up Table Block: '<S23>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Switch2_a),
                       &Gen2_ref_B->BusInput3.traj.rPrR_deltaP_TV_y[0],
                       rtb_Gain_kl, &rtb_Gain1_eu[0], 4U, inst);

  /* Saturate: '<S23>/Saturation1' */
  if (Gen2_ref_B->BusInput3.eng.rNum_TV > 1.0) {
    /* Saturate: '<S44>/Saturation' incorporates:
     *  Saturate: '<S25>/Saturation1'
     *  Switch: '<S106>/Switch2'
     */
    rtb_Saturation1_i = 1.0;
  } else if (Gen2_ref_B->BusInput3.eng.rNum_TV < 0.0) {
    /* Saturate: '<S44>/Saturation' incorporates:
     *  Saturate: '<S25>/Saturation1'
     *  Switch: '<S106>/Switch2'
     */
    rtb_Saturation1_i = 0.0;
  } else {
    /* Saturate: '<S44>/Saturation' incorporates:
     *  Saturate: '<S25>/Saturation1'
     *  Switch: '<S106>/Switch2'
     */
    rtb_Saturation1_i = Gen2_ref_B->BusInput3.eng.rNum_TV;
  }

  rtb_MinMax_a = rtb_Saturation1_i;

  /* End of Saturate: '<S23>/Saturation1' */

  /* Product: '<S23>/Product2' */
  rtb_Product2 = rtb_Switch2_a * rtb_MinMax_a;

  /* MATLAB Function: '<S62>/MATLAB Function' */
  Gen2_ref_DWork->x_i = ((rtb_Product2 < Gen2_ref_B->BusInput3.traj.rDPp2sCompON)
    || ((!(rtb_Product2 > Gen2_ref_B->BusInput3.traj.rDPp2sCompON + 0.03)) &&
        Gen2_ref_DWork->x_i));

  /* Logic: '<S62>/Logical Operator' incorporates:
   *  Logic: '<S62>/Logical Operator9'
   *  MATLAB Function: '<S62>/MATLAB Function'
   */
  rtb_LogicalOperator_aw = ((!rtb_LogicalOperator2_ov) || (!Gen2_ref_DWork->x_i));

  /* Logic: '<S62>/Logical Operator1' incorporates:
   *  Logic: '<S62>/Logical Operator2'
   */
  rtb_LogicalOperator1_i2 = ((rtb_LogicalOperator_aw &&
    Gen2_ref_B->BusInput3.traj.bResetCompTrans) || rtb_LogicalOperator2_dc);

  /* DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator1_i2 ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_oa != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a = 0.0;
  }

  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a <= -0.1) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a = -0.1;
  }

  /* Product: '<S88>/delta rise limit' incorporates:
   *  Constant: '<S78>/Constant1'
   *  SampleTimeMath: '<S88>/sample time'
   *
   * About '<S88>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_MinMax_a = 1.0E+8;

  /* Switch: '<Root>/BDC_traj' incorporates:
   *  Gain: '<S431>/Gain4'
   */
  if (!rtb_LogicalOperator) {
    rtb_Pa2bar_o = 100000.0 * rtb_Product_m[0];
  }

  /* End of Switch: '<Root>/BDC_traj' */

  /* Gain: '<S23>/Gain1' */
  rtb_p1LP = 1.0E-5 * rtb_Pa2bar_o;

  /* Logic: '<S78>/Logical Operator' incorporates:
   *  RelationalOperator: '<S78>/Relational Operator'
   */
  rtb_LogicalOperator2_p1 = (Gen2_ref_B->BusInput3.traj.bRateLimRejON &&
    (Gen2_ref_B->BusInput3.traj.rNmaxRateLimRejON > rtb_DataTypeConversion15));

  /* Logic: '<S78>/Logical Operator1' incorporates:
   *  Logic: '<S78>/Logical Operator2'
   */
  rtb_LogicalOperator1_a0 = ((!rtb_LogicalOperator2_p1) ||
    rtb_LogicalOperator2_dc);

  /* Gain: '<S23>/Gain2' */
  rtb_p1HP = 1.0E-5 * rtb_Divide_kt;

  /* Gain: '<S78>/Gain' */
  rtb_Divide_kt = 100.0 * Gen2_ref_B->BusInput3.traj.rTi_RateLimRej;

  /* Delay: '<S78>/Variable Integer Delay' */
  Gen2_ref_DWork->icLoad_ev =
    ((((Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZC_i == 1) !=
       (int32_T)rtb_LogicalOperator1_a0) &&
      (Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZC_i != 3)) ||
     rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_ev);
  Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZC_i =
    rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_ev) {
    for (i = 0; i < 300; i++) {
      Gen2_ref_DWork->VariableIntegerDelay_DSTATE_b[i] = rtb_p1HP;
    }
  }

  if ((rtb_Divide_kt < 1.0) || rtIsNaN(rtb_Divide_kt)) {
    rtb_VariableIntegerDelay_b = rtb_p1HP;
  } else {
    if (rtb_Divide_kt > 300.0) {
      i = 300;
    } else {
      delta_y = floor(rtb_Divide_kt);
      if (rtIsNaN(delta_y)) {
        i = 0;
      } else {
        i = (int32_T)(uint32_T)fmod(delta_y, 4.294967296E+9);
      }
    }

    rtb_VariableIntegerDelay_b = Gen2_ref_DWork->VariableIntegerDelay_DSTATE_b
      [300U - i];
  }

  /* Saturate: '<S78>/Saturation' */
  if (Gen2_ref_B->BusInput3.traj.rTi_RateLimRej <= 0.01) {
    rtb_Switch2_a = 0.01;
  } else {
    rtb_Switch2_a = Gen2_ref_B->BusInput3.traj.rTi_RateLimRej;
  }

  /* End of Saturate: '<S78>/Saturation' */

  /* Product: '<S78>/Divide' incorporates:
   *  Sum: '<S78>/Sum'
   */
  rtb_Divide_kt = (rtb_p1HP - rtb_VariableIntegerDelay_b) / rtb_Switch2_a;

  /* Abs: '<S78>/Abs2' incorporates:
   *  Abs: '<S77>/Abs2'
   */
  rtb_UkYk1_a4 = fabs(Gen2_ref_B->BusInput3.traj.rPrTriggerRateLimRej);

  /* Gain: '<S78>/Gain3' incorporates:
   *  Abs: '<S78>/Abs2'
   */
  rtb_Switch2_jq = -rtb_UkYk1_a4;

  /* Logic: '<S78>/Logical Operator3' incorporates:
   *  RelationalOperator: '<S78>/Relational Operator1'
   */
  rtb_LogicalOperator3_ja = (rtb_LogicalOperator1_a0 || (rtb_Divide_kt >
    rtb_Switch2_jq));

  /* Delay: '<S88>/Delay' */
  Gen2_ref_DWork->icLoad_d = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_d == 1)
    != (int32_T)rtb_LogicalOperator3_ja) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_d != 3)) ||
    rtb_LogicalOperator3_ja || Gen2_ref_DWork->icLoad_d);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_d = rtb_LogicalOperator3_ja;
  if (Gen2_ref_DWork->icLoad_d) {
    Gen2_ref_DWork->Delay_DSTATE_ko = rtb_p1LP;
  }

  /* Switch: '<S88>/etaVolConst' incorporates:
   *  UnitDelay: '<S78>/Unit Delay'
   */
  if (rtb_LogicalOperator3_ja) {
    rtb_p2HP = rtb_p1LP;
  } else {
    rtb_p2HP = Gen2_ref_DWork->UnitDelay_DSTATE_e;
  }

  /* End of Switch: '<S88>/etaVolConst' */

  /* Sum: '<S88>/Difference Inputs1' incorporates:
   *  Delay: '<S88>/Delay'
   */
  rtb_p2HP -= Gen2_ref_DWork->Delay_DSTATE_ko;

  /* Abs: '<S78>/Abs1' */
  rtb_Sum1_dh = fabs(Gen2_ref_B->BusInput3.traj.rPrDeltaMinRateLimRej);

  /* Abs: '<S78>/Abs' incorporates:
   *  Abs: '<S77>/Abs'
   */
  rtb_Switch_czo = fabs(Gen2_ref_B->BusInput3.traj.rPrDeltaMinRateLimRejFF);

  /* Product: '<S78>/Divide1' incorporates:
   *  Abs: '<S78>/Abs'
   *  Gain: '<S78>/Gain1'
   */
  rtb_MinMax_mf = -rtb_Switch_czo / rtb_Switch2_a;

  /* MinMax: '<S78>/MinMax' */
  if ((rtb_Divide_kt <= rtb_MinMax_mf) || rtIsNaN(rtb_MinMax_mf)) {
    rtb_MinMax_mf = rtb_Divide_kt;
  }

  /* End of MinMax: '<S78>/MinMax' */

  /* Product: '<S78>/Divide2' incorporates:
   *  Gain: '<S78>/Gain2'
   */
  rtb_MinMax3 = -rtb_Sum1_dh / rtb_Switch2_a;

  /* MinMax: '<S78>/MinMax3' */
  if ((!(rtb_MinMax3 <= rtb_MinMax_mf)) && (!rtIsNaN(rtb_MinMax_mf))) {
    rtb_MinMax3 = rtb_MinMax_mf;
  }

  /* End of MinMax: '<S78>/MinMax3' */

  /* Switch: '<S92>/Switch2' incorporates:
   *  RelationalOperator: '<S92>/LowerRelop1'
   */
  if (!(rtb_p2HP > 1.0E+8)) {
    /* Product: '<S88>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S88>/sample time'
     *
     * About '<S88>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Sum4_g = rtb_MinMax3 * 0.01;

    /* Switch: '<S92>/Switch' incorporates:
     *  RelationalOperator: '<S92>/UpperRelop'
     */
    if (rtb_p2HP < rtb_Sum4_g) {
      rtb_MinMax_a = rtb_Sum4_g;
    } else {
      rtb_MinMax_a = rtb_p2HP;
    }

    /* End of Switch: '<S92>/Switch' */
  }

  /* End of Switch: '<S92>/Switch2' */

  /* Sum: '<S88>/Difference Inputs2' incorporates:
   *  Delay: '<S88>/Delay'
   */
  rtb_p2HP = rtb_MinMax_a + Gen2_ref_DWork->Delay_DSTATE_ko;

  /* Product: '<S90>/delta rise limit' incorporates:
   *  Constant: '<S78>/Constant4'
   *  SampleTimeMath: '<S90>/sample time'
   *
   * About '<S90>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum_c = 1.0E+8;

  /* Delay: '<S90>/Delay' incorporates:
   *  Delay: '<S78>/Variable Integer Delay'
   */
  Gen2_ref_DWork->icLoad_es = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_l ==
    1) != (int32_T)rtb_LogicalOperator1_a0) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_l != 3)) ||
    rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_es);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_l = rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_es) {
    Gen2_ref_DWork->Delay_DSTATE_j = rtb_p1LP;
  }

  /* Sum: '<S90>/Difference Inputs1' incorporates:
   *  Delay: '<S90>/Delay'
   *  Switch: '<S90>/etaVolConst'
   */
  rtb_Sum4_g = rtb_p1LP - Gen2_ref_DWork->Delay_DSTATE_j;

  /* Gain: '<S78>/Gain5' incorporates:
   *  Gain: '<S77>/Gain5'
   */
  FILT_IN = 0.001 * Gen2_ref_B->BusInput3.leanox.rPr_mbar_2;
  rtb_Sum1_dh = FILT_IN;

  /* Gain: '<S78>/Gain6' incorporates:
   *  Product: '<S78>/Divide3'
   */
  rtb_Switch9_k = -(rtb_Sum1_dh / rtb_Switch2_a);

  /* Switch: '<S94>/Switch2' incorporates:
   *  RelationalOperator: '<S94>/LowerRelop1'
   */
  if (!(rtb_Sum4_g > 1.0E+8)) {
    /* Product: '<S90>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S90>/sample time'
     *
     * About '<S90>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Sum5_iu = rtb_Switch9_k * 0.01;

    /* Switch: '<S94>/Switch' incorporates:
     *  RelationalOperator: '<S94>/UpperRelop'
     */
    if (rtb_Sum4_g < rtb_Sum5_iu) {
      rtb_Sum_c = rtb_Sum5_iu;
    } else {
      rtb_Sum_c = rtb_Sum4_g;
    }

    /* End of Switch: '<S94>/Switch' */
  }

  /* End of Switch: '<S94>/Switch2' */

  /* Sum: '<S90>/Difference Inputs2' incorporates:
   *  Delay: '<S90>/Delay'
   */
  rtb_Sum4_g = rtb_Sum_c + Gen2_ref_DWork->Delay_DSTATE_j;

  /* Switch: '<S78>/Switch1' */
  if (rtb_LogicalOperator2_p1) {
    /* Switch: '<S78>/Switch3' */
    if (Gen2_ref_B->BusInput3.traj.bRateLimRejStepSizeDep) {
      rtb_Sum_c = rtb_p2HP;
    } else {
      rtb_Sum_c = rtb_Sum4_g;
    }

    /* End of Switch: '<S78>/Switch3' */
  } else {
    rtb_Sum_c = rtb_p1LP;
  }

  /* End of Switch: '<S78>/Switch1' */

  /* MinMax: '<S78>/MinMax2' */
  if ((!(rtb_Sum_c >= rtb_p1LP)) && (!rtIsNaN(rtb_p1LP))) {
    rtb_Sum_c = rtb_p1LP;
  }

  /* End of MinMax: '<S78>/MinMax2' */

  /* Sum: '<S52>/Sum11' incorporates:
   *  DiscreteIntegrator: '<S62>/Discrete-Time Integrator'
   *  Gain: '<S52>/Gain'
   */
  rtb_Sum11 = 0.0 * Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a + rtb_Sum_c;

  /* Product: '<S87>/delta rise limit' incorporates:
   *  Constant: '<S78>/Constant3'
   *  SampleTimeMath: '<S87>/sample time'
   *
   * About '<S87>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum1_dh = 1.0E+8;

  /* Delay: '<S87>/Delay' incorporates:
   *  Delay: '<S78>/Variable Integer Delay'
   */
  Gen2_ref_DWork->icLoad_evr = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_i ==
    1) != (int32_T)rtb_LogicalOperator1_a0) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_i != 3)) ||
    rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_evr);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_i = rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_evr) {
    Gen2_ref_DWork->Delay_DSTATE_m = rtb_p1HP;
  }

  /* Sum: '<S87>/Difference Inputs1' incorporates:
   *  Delay: '<S87>/Delay'
   *  Switch: '<S87>/etaVolConst'
   */
  rtb_Sum5_iu = rtb_p1HP - Gen2_ref_DWork->Delay_DSTATE_m;

  /* Switch: '<S91>/Switch2' incorporates:
   *  RelationalOperator: '<S91>/LowerRelop1'
   */
  if (!(rtb_Sum5_iu > 1.0E+8)) {
    /* Product: '<S87>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S87>/sample time'
     *
     * About '<S87>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Sum3_o = rtb_MinMax_mf * 0.01;

    /* Switch: '<S91>/Switch' incorporates:
     *  RelationalOperator: '<S91>/UpperRelop'
     */
    if (rtb_Sum5_iu < rtb_Sum3_o) {
      rtb_Sum1_dh = rtb_Sum3_o;
    } else {
      rtb_Sum1_dh = rtb_Sum5_iu;
    }

    /* End of Switch: '<S91>/Switch' */
  }

  /* End of Switch: '<S91>/Switch2' */

  /* Sum: '<S87>/Difference Inputs2' incorporates:
   *  Delay: '<S87>/Delay'
   */
  rtb_Sum5_iu = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_m;

  /* Product: '<S89>/delta rise limit' incorporates:
   *  Constant: '<S78>/Constant4'
   *  SampleTimeMath: '<S89>/sample time'
   *
   * About '<S89>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum1_dh = 1.0E+8;

  /* Delay: '<S89>/Delay' incorporates:
   *  Delay: '<S78>/Variable Integer Delay'
   */
  Gen2_ref_DWork->icLoad_fg = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_mu ==
    1) != (int32_T)rtb_LogicalOperator1_a0) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_mu != 3)) ||
    rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_fg);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_mu = rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_fg) {
    Gen2_ref_DWork->Delay_DSTATE_d = rtb_p1HP;
  }

  /* Sum: '<S89>/Difference Inputs1' incorporates:
   *  Delay: '<S89>/Delay'
   *  Switch: '<S89>/etaVolConst'
   */
  rtb_Sum3_o = rtb_p1HP - Gen2_ref_DWork->Delay_DSTATE_d;

  /* Switch: '<S93>/Switch2' incorporates:
   *  RelationalOperator: '<S93>/LowerRelop1'
   */
  if (!(rtb_Sum3_o > 1.0E+8)) {
    /* Product: '<S89>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S89>/sample time'
     *
     * About '<S89>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch9_k *= 0.01;

    /* Switch: '<S93>/Switch' incorporates:
     *  RelationalOperator: '<S93>/UpperRelop'
     */
    if (rtb_Sum3_o < rtb_Switch9_k) {
      rtb_Sum1_dh = rtb_Switch9_k;
    } else {
      rtb_Sum1_dh = rtb_Sum3_o;
    }

    /* End of Switch: '<S93>/Switch' */
  }

  /* End of Switch: '<S93>/Switch2' */

  /* Sum: '<S89>/Difference Inputs2' incorporates:
   *  Delay: '<S89>/Delay'
   */
  rtb_Switch9_k = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_d;

  /* Switch: '<S78>/Switch' */
  if (rtb_LogicalOperator2_p1) {
    /* Switch: '<S78>/Switch2' */
    if (Gen2_ref_B->BusInput3.traj.bRateLimRejStepSizeDep) {
      rtb_Sum1_dh = rtb_Sum5_iu;
    } else {
      rtb_Sum1_dh = rtb_Switch9_k;
    }

    /* End of Switch: '<S78>/Switch2' */
  } else {
    rtb_Sum1_dh = rtb_p1HP;
  }

  /* End of Switch: '<S78>/Switch' */

  /* MinMax: '<S78>/MinMax1' */
  if ((rtb_p1HP >= rtb_Sum1_dh) || rtIsNaN(rtb_Sum1_dh)) {
    rtb_MinMax1_h = rtb_p1HP;
  } else {
    rtb_MinMax1_h = rtb_Sum1_dh;
  }

  /* End of MinMax: '<S78>/MinMax1' */

  /* Product: '<S80>/delta rise limit' incorporates:
   *  Constant: '<S77>/Constant1'
   *  SampleTimeMath: '<S80>/sample time'
   *
   * About '<S80>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum1_dh = 1.0E+8;

  /* Switch: '<S52>/Switch' */
  if (Gen2_ref_B->BusInput3.traj.bCBVrefFFonly) {
    rtb_Sum3_o = rtb_p1HP;
  } else {
    rtb_Sum3_o = rtb_p1LP;
  }

  /* End of Switch: '<S52>/Switch' */

  /* Logic: '<S77>/Logical Operator' incorporates:
   *  RelationalOperator: '<S77>/Relational Operator'
   */
  rtb_LogicalOperator2_p1 = (Gen2_ref_B->BusInput3.traj.bRateLimRejCBV &&
    (Gen2_ref_B->BusInput3.traj.rNmaxRateLimRejON > rtb_DataTypeConversion15));

  /* Logic: '<S77>/Logical Operator1' incorporates:
   *  Logic: '<S77>/Logical Operator2'
   */
  rtb_LogicalOperator1_a0 = ((!rtb_LogicalOperator2_p1) ||
    rtb_LogicalOperator2_dc);

  /* Gain: '<S77>/Gain' */
  rtb_Gain_i = 100.0 * Gen2_ref_B->BusInput3.traj.rTi_RateLimRejCBV;

  /* Delay: '<S77>/Variable Integer Delay' */
  Gen2_ref_DWork->icLoad_c =
    ((((Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZC_o == 1) !=
       (int32_T)rtb_LogicalOperator1_a0) &&
      (Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZC_o != 3)) ||
     rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_c);
  Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZC_o =
    rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_c) {
    for (i = 0; i < 300; i++) {
      Gen2_ref_DWork->VariableIntegerDelay_DSTATE_e[i] = rtb_p1HP;
    }
  }

  if ((rtb_Gain_i < 1.0) || rtIsNaN(rtb_Gain_i)) {
    rtb_Gain_i = rtb_p1HP;
  } else {
    if (rtb_Gain_i > 300.0) {
      i = 300;
    } else {
      delta_y = floor(rtb_Gain_i);
      if (rtIsNaN(delta_y)) {
        i = 0;
      } else {
        i = (int32_T)(uint32_T)fmod(delta_y, 4.294967296E+9);
      }
    }

    rtb_Gain_i = Gen2_ref_DWork->VariableIntegerDelay_DSTATE_e[300U - i];
  }

  /* Saturate: '<S77>/Saturation' */
  if (Gen2_ref_B->BusInput3.traj.rTi_RateLimRejCBV <= 0.01) {
    rtb_Saturation_e = 0.01;
  } else {
    rtb_Saturation_e = Gen2_ref_B->BusInput3.traj.rTi_RateLimRejCBV;
  }

  /* End of Saturate: '<S77>/Saturation' */

  /* Product: '<S77>/Divide' incorporates:
   *  Sum: '<S77>/Sum'
   */
  rtb_MinMax_a = (rtb_p1HP - rtb_Gain_i) / rtb_Saturation_e;

  /* Abs: '<S77>/Abs2' */
  rtb_Switch2_a = rtb_UkYk1_a4;

  /* Logic: '<S77>/Logical Operator3' incorporates:
   *  Gain: '<S77>/Gain3'
   *  RelationalOperator: '<S77>/Relational Operator1'
   */
  rtb_LogicalOperator3_k = (rtb_LogicalOperator1_a0 || (rtb_MinMax_a >
    -rtb_Switch2_a));

  /* Delay: '<S80>/Delay' */
  Gen2_ref_DWork->icLoad_eu = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_d3 ==
    1) != (int32_T)rtb_LogicalOperator3_k) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_d3 != 3)) ||
    rtb_LogicalOperator3_k || Gen2_ref_DWork->icLoad_eu);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_d3 = rtb_LogicalOperator3_k;
  if (Gen2_ref_DWork->icLoad_eu) {
    Gen2_ref_DWork->Delay_DSTATE_g2 = rtb_Sum3_o;
  }

  /* Switch: '<S80>/etaVolConst' incorporates:
   *  UnitDelay: '<S77>/Unit Delay'
   */
  if (rtb_LogicalOperator3_k) {
    rtb_UkYk1_a4 = rtb_Sum3_o;
  } else {
    rtb_UkYk1_a4 = Gen2_ref_DWork->UnitDelay_DSTATE_d;
  }

  /* End of Switch: '<S80>/etaVolConst' */

  /* Sum: '<S80>/Difference Inputs1' incorporates:
   *  Delay: '<S80>/Delay'
   */
  rtb_UkYk1_a4 -= Gen2_ref_DWork->Delay_DSTATE_g2;

  /* Abs: '<S77>/Abs' */
  rtb_Switch2_a = rtb_Switch_czo;

  /* Product: '<S77>/Divide1' incorporates:
   *  Gain: '<S77>/Gain1'
   */
  rtb_Gain_i = -rtb_Switch2_a / rtb_Saturation_e;

  /* MinMax: '<S77>/MinMax' */
  if ((rtb_MinMax_a <= rtb_Gain_i) || rtIsNaN(rtb_Gain_i)) {
    rtb_Gain_i = rtb_MinMax_a;
  }

  /* End of MinMax: '<S77>/MinMax' */

  /* Switch: '<S84>/Switch2' incorporates:
   *  RelationalOperator: '<S84>/LowerRelop1'
   */
  if (!(rtb_UkYk1_a4 > 1.0E+8)) {
    /* Product: '<S77>/Divide2' incorporates:
     *  Abs: '<S77>/Abs1'
     *  Gain: '<S77>/Gain2'
     */
    u0 = -fabs(Gen2_ref_B->BusInput3.traj.rPrDeltaMinRateLimRej) /
      rtb_Saturation_e;

    /* MinMax: '<S77>/MinMax3' */
    if ((!(u0 <= rtb_Gain_i)) && (!rtIsNaN(rtb_Gain_i))) {
      u0 = rtb_Gain_i;
    }

    /* End of MinMax: '<S77>/MinMax3' */

    /* Product: '<S80>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S80>/sample time'
     *
     * About '<S80>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch_czo = u0 * 0.01;

    /* Switch: '<S84>/Switch' incorporates:
     *  RelationalOperator: '<S84>/UpperRelop'
     */
    if (rtb_UkYk1_a4 < rtb_Switch_czo) {
      rtb_Sum1_dh = rtb_Switch_czo;
    } else {
      rtb_Sum1_dh = rtb_UkYk1_a4;
    }

    /* End of Switch: '<S84>/Switch' */
  }

  /* End of Switch: '<S84>/Switch2' */

  /* Sum: '<S80>/Difference Inputs2' incorporates:
   *  Delay: '<S80>/Delay'
   */
  rtb_Switch_czo = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_g2;

  /* Product: '<S82>/delta rise limit' incorporates:
   *  Constant: '<S77>/Constant4'
   *  SampleTimeMath: '<S82>/sample time'
   *
   * About '<S82>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum1_dh = 1.0E+8;

  /* Delay: '<S82>/Delay' incorporates:
   *  Delay: '<S77>/Variable Integer Delay'
   */
  Gen2_ref_DWork->icLoad_ee = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_c ==
    1) != (int32_T)rtb_LogicalOperator1_a0) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_c != 3)) ||
    rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_ee);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_c = rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_ee) {
    Gen2_ref_DWork->Delay_DSTATE_dm = rtb_Sum3_o;
  }

  /* Sum: '<S82>/Difference Inputs1' incorporates:
   *  Delay: '<S82>/Delay'
   *  Switch: '<S82>/etaVolConst'
   */
  rtb_UkYk1_a4 = rtb_Sum3_o - Gen2_ref_DWork->Delay_DSTATE_dm;

  /* Gain: '<S77>/Gain5' */
  rtb_MinMax_a = FILT_IN;

  /* Gain: '<S77>/Gain6' incorporates:
   *  Product: '<S77>/Divide3'
   */
  rtb_Saturation_e = -(rtb_MinMax_a / rtb_Saturation_e);

  /* Switch: '<S86>/Switch2' incorporates:
   *  RelationalOperator: '<S86>/LowerRelop1'
   */
  if (!(rtb_UkYk1_a4 > 1.0E+8)) {
    /* Product: '<S82>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S82>/sample time'
     *
     * About '<S82>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_deltafalllimit_h0 = rtb_Saturation_e * 0.01;

    /* Switch: '<S86>/Switch' incorporates:
     *  RelationalOperator: '<S86>/UpperRelop'
     */
    if (rtb_UkYk1_a4 < rtb_deltafalllimit_h0) {
      rtb_Sum1_dh = rtb_deltafalllimit_h0;
    } else {
      rtb_Sum1_dh = rtb_UkYk1_a4;
    }

    /* End of Switch: '<S86>/Switch' */
  }

  /* End of Switch: '<S86>/Switch2' */

  /* Sum: '<S82>/Difference Inputs2' incorporates:
   *  Delay: '<S82>/Delay'
   */
  rtb_UkYk1_a4 = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_dm;

  /* Switch: '<S77>/Switch1' */
  if (rtb_LogicalOperator2_p1) {
    /* Switch: '<S77>/Switch3' */
    if (Gen2_ref_B->BusInput3.traj.bRateLimRejStepSizeDep) {
      rtb_Sum1_dh = rtb_Switch_czo;
    } else {
      rtb_Sum1_dh = rtb_UkYk1_a4;
    }

    /* End of Switch: '<S77>/Switch3' */
  } else {
    rtb_Sum1_dh = rtb_Sum3_o;
  }

  /* End of Switch: '<S77>/Switch1' */

  /* MinMax: '<S77>/MinMax2' */
  if ((!(rtb_Sum1_dh >= rtb_Sum3_o)) && (!rtIsNaN(rtb_Sum3_o))) {
    rtb_Sum1_dh = rtb_Sum3_o;
  }

  /* End of MinMax: '<S77>/MinMax2' */

  /* Sum: '<S52>/Sum7' incorporates:
   *  DiscreteIntegrator: '<S62>/Discrete-Time Integrator'
   */
  rtb_Sum7_l5 = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a + rtb_Sum1_dh;

  /* Product: '<S79>/delta rise limit' incorporates:
   *  Constant: '<S77>/Constant3'
   *  SampleTimeMath: '<S79>/sample time'
   *
   * About '<S79>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum1_dh = 1.0E+8;

  /* Delay: '<S79>/Delay' incorporates:
   *  Delay: '<S77>/Variable Integer Delay'
   */
  Gen2_ref_DWork->icLoad_ki = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_p ==
    1) != (int32_T)rtb_LogicalOperator1_a0) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_p != 3)) ||
    rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_ki);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_p = rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_ki) {
    Gen2_ref_DWork->Delay_DSTATE_jl = rtb_p1HP;
  }

  /* Sum: '<S79>/Difference Inputs1' incorporates:
   *  Delay: '<S79>/Delay'
   *  Switch: '<S79>/etaVolConst'
   */
  rtb_deltafalllimit_h0 = rtb_p1HP - Gen2_ref_DWork->Delay_DSTATE_jl;

  /* Switch: '<S83>/Switch2' incorporates:
   *  RelationalOperator: '<S83>/LowerRelop1'
   */
  if (!(rtb_deltafalllimit_h0 > 1.0E+8)) {
    /* Product: '<S79>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S79>/sample time'
     *
     * About '<S79>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Gain_i *= 0.01;

    /* Switch: '<S83>/Switch' incorporates:
     *  RelationalOperator: '<S83>/UpperRelop'
     */
    if (rtb_deltafalllimit_h0 < rtb_Gain_i) {
      rtb_Sum1_dh = rtb_Gain_i;
    } else {
      rtb_Sum1_dh = rtb_deltafalllimit_h0;
    }

    /* End of Switch: '<S83>/Switch' */
  }

  /* End of Switch: '<S83>/Switch2' */

  /* Sum: '<S79>/Difference Inputs2' incorporates:
   *  Delay: '<S79>/Delay'
   */
  rtb_Gain_i = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_jl;

  /* Product: '<S81>/delta rise limit' incorporates:
   *  Constant: '<S77>/Constant4'
   *  SampleTimeMath: '<S81>/sample time'
   *
   * About '<S81>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum1_dh = 1.0E+8;

  /* Delay: '<S81>/Delay' incorporates:
   *  Delay: '<S77>/Variable Integer Delay'
   */
  Gen2_ref_DWork->icLoad_h3 = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_ih ==
    1) != (int32_T)rtb_LogicalOperator1_a0) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_ih != 3)) ||
    rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_h3);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_ih = rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_h3) {
    Gen2_ref_DWork->Delay_DSTATE_h = rtb_p1HP;
  }

  /* Sum: '<S81>/Difference Inputs1' incorporates:
   *  Delay: '<S81>/Delay'
   *  Switch: '<S81>/etaVolConst'
   */
  rtb_deltafalllimit_h0 = rtb_p1HP - Gen2_ref_DWork->Delay_DSTATE_h;

  /* Switch: '<S85>/Switch2' incorporates:
   *  RelationalOperator: '<S85>/LowerRelop1'
   */
  if (!(rtb_deltafalllimit_h0 > 1.0E+8)) {
    /* Product: '<S81>/delta fall limit' incorporates:
     *  SampleTimeMath: '<S81>/sample time'
     *
     * About '<S81>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Saturation_e *= 0.01;

    /* Switch: '<S85>/Switch' incorporates:
     *  RelationalOperator: '<S85>/UpperRelop'
     */
    if (rtb_deltafalllimit_h0 < rtb_Saturation_e) {
      rtb_Sum1_dh = rtb_Saturation_e;
    } else {
      rtb_Sum1_dh = rtb_deltafalllimit_h0;
    }

    /* End of Switch: '<S85>/Switch' */
  }

  /* End of Switch: '<S85>/Switch2' */

  /* Sum: '<S81>/Difference Inputs2' incorporates:
   *  Delay: '<S81>/Delay'
   */
  rtb_Saturation_e = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_h;

  /* Switch: '<S77>/Switch' */
  if (rtb_LogicalOperator2_p1) {
    /* Switch: '<S77>/Switch2' */
    if (Gen2_ref_B->BusInput3.traj.bRateLimRejStepSizeDep) {
      rtb_Sum1_dh = rtb_Gain_i;
    } else {
      rtb_Sum1_dh = rtb_Saturation_e;
    }

    /* End of Switch: '<S77>/Switch2' */
  } else {
    rtb_Sum1_dh = rtb_p1HP;
  }

  /* End of Switch: '<S77>/Switch' */

  /* MinMax: '<S77>/MinMax1' */
  if ((rtb_p1HP >= rtb_Sum1_dh) || rtIsNaN(rtb_Sum1_dh)) {
    rtb_MinMax1_g = rtb_p1HP;
  } else {
    rtb_MinMax1_g = rtb_Sum1_dh;
  }

  /* End of MinMax: '<S77>/MinMax1' */

  /* Abs: '<S23>/Abs1' */
  rtb_Sum1_dh = fabs(Gen2_ref_B->BusInput3.traj.rPrTriggerLargeRej);

  /* Switch: '<S23>/Switch1' incorporates:
   *  RelationalOperator: '<S23>/Relational Operator3'
   *  Sum: '<S23>/Sum7'
   */
  if (rtb_Gain_kl - rtb_p1HP > rtb_Sum1_dh) {
    rtb_Switch1_lk = Gen2_ref_B->BusInput3.traj.rTi_BDC_rej_CBV;
  } else {
    rtb_Switch1_lk = Gen2_ref_B->BusInput3.traj.rTi_BDC;
  }

  /* End of Switch: '<S23>/Switch1' */

  /* Product: '<S23>/Product1' */
  rtb_Product1_bc = Gen2_ref_B->BusInput3.traj.rFactTi_BDC_CBV * rtb_Switch1_lk;

  /* Switch: '<S1>/Switch13' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion16'
   */
  if (Gen2_ref_B->BusInput3.bdcMisc.bUseNsetBDC) {
    rtb_Switch13 = Gen2_ref_B->BusInput.rN_Set;
  } else {
    rtb_Switch13 = Gen2_ref_B->BusInput3.eng.rN_Nom;
  }

  /* End of Switch: '<S1>/Switch13' */

  /* Sum: '<S23>/Sum4' incorporates:
   *  Sum: '<S133>/Sum'
   */
  rtb_Switch1_kk = rtb_DataTypeConversion15 - rtb_Switch13;

  /* MATLAB Function: '<S23>/ref traj' incorporates:
   *  MATLAB Function: '<S431>/ref traj'
   *  Sum: '<S23>/Sum4'
   */
  if ((!Gen2_ref_DWork->x_not_empty_n) || rtb_LogicalOperator2_dc) {
    Gen2_ref_DWork->x_e = rtb_Gain_kl;
    Gen2_ref_DWork->x_not_empty_n = true;
    Gen2_ref_DWork->x0 = rtb_Gain_kl;
    Gen2_ref_DWork->x1 = rtb_Gain_kl;
    Gen2_ref_DWork->x2 = rtb_Gain_kl;
    Gen2_ref_DWork->x3 = rtb_Gain_kl;
    Gen2_ref_DWork->x4 = rtb_Gain_kl;
  }

  if (Gen2_ref_B->BusInput3.eng.Ts >= 0.01) {
    Ts_tmp = Gen2_ref_B->BusInput3.eng.Ts;
  } else {
    Ts_tmp = 0.01;
  }

  delta_y = rtb_MinMax1_h - rtb_Gain_kl;
  if (delta_y > Gen2_ref_B->BusInput3.traj.rThrshSwTbdcUp) {
    rtb_Switch2_j0 = Gen2_ref_B->BusInput3.traj.rTi_BDC_up;
  } else {
    rtb_Switch2_j0 = Gen2_ref_B->BusInput3.traj.rTi_BDC;
  }

  if (Gen2_ref_B->BusInput3.traj.bLimitFFcmdTV) {
    if ((rtb_Sum11 >= rtb_MinMax1_h) || rtIsNaN(rtb_MinMax1_h)) {
      FILT_IN = rtb_Sum11;
    } else {
      FILT_IN = rtb_MinMax1_h;
    }
  } else {
    FILT_IN = rtb_Sum11;
  }

  rtb_LogicalOperator5_g_tmp = rtIsNaN(Ts_tmp);
  if ((rtb_Switch2_j0 >= Ts_tmp) || rtb_LogicalOperator5_g_tmp) {
    r = rtb_Switch2_j0;
  } else {
    r = Ts_tmp;
  }

  rtb_Switch2_a = FILT_IN - Gen2_ref_DWork->x0;
  u0 = 1.0 / r * rtb_Switch2_a;
  if ((Gen2_ref_B->BusInput3.traj.rTi_BDC >= Ts_tmp) ||
      rtb_LogicalOperator5_g_tmp) {
    FILT_IN = Gen2_ref_B->BusInput3.traj.rTi_BDC;
  } else {
    FILT_IN = Ts_tmp;
  }

  u1 = 1.0 / FILT_IN * rtb_Switch2_a;
  if ((u0 >= u1) || rtIsNaN(u1)) {
    u1 = u0;
  }

  rtb_Sum10 = u1 * Ts_tmp + Gen2_ref_DWork->x0;
  if (Gen2_ref_B->BusInput3.traj.bLimitFFcmdCBV) {
    if ((rtb_Sum7_l5 >= rtb_MinMax1_g) || rtIsNaN(rtb_MinMax1_g)) {
      FILT_IN = rtb_Sum7_l5;
    } else {
      FILT_IN = rtb_MinMax1_g;
    }
  } else {
    FILT_IN = rtb_Sum7_l5;
  }

  if (rtb_Switch1_kk > 0.0) {
    if ((rtb_Switch2_j0 >= Ts_tmp) || rtb_LogicalOperator5_g_tmp) {
      r = rtb_Switch2_j0;
    } else {
      r = Ts_tmp;
    }

    rtb_Switch2_a = FILT_IN - Gen2_ref_DWork->x1;
    u0 = 1.0 / r * rtb_Switch2_a;
    if ((rtb_Product1_bc >= Ts_tmp) || rtb_LogicalOperator5_g_tmp) {
      FILT_IN = rtb_Product1_bc;
    } else {
      FILT_IN = Ts_tmp;
    }

    FILT_IN = 1.0 / FILT_IN * rtb_Switch2_a;
    if ((u0 >= FILT_IN) || rtIsNaN(FILT_IN)) {
      FILT_IN = u0;
    }
  } else {
    if ((rtb_Switch2_j0 >= Ts_tmp) || rtb_LogicalOperator5_g_tmp) {
      r = rtb_Switch2_j0;
    } else {
      r = Ts_tmp;
    }

    rtb_Switch2_a = FILT_IN - Gen2_ref_DWork->x1;
    u0 = 1.0 / r * rtb_Switch2_a;
    if ((Gen2_ref_B->BusInput3.traj.rTi_BDC >= Ts_tmp) ||
        rtb_LogicalOperator5_g_tmp) {
      FILT_IN = Gen2_ref_B->BusInput3.traj.rTi_BDC;
    } else {
      FILT_IN = Ts_tmp;
    }

    FILT_IN = 1.0 / FILT_IN * rtb_Switch2_a;
    if ((u0 >= FILT_IN) || rtIsNaN(FILT_IN)) {
      FILT_IN = u0;
    }
  }

  rtb_Switch2_h1 = FILT_IN * Ts_tmp + Gen2_ref_DWork->x1;
  if ((rtb_Switch2_j0 >= Ts_tmp) || rtb_LogicalOperator5_g_tmp) {
    r = rtb_Switch2_j0;
  } else {
    r = Ts_tmp;
  }

  rtb_Switch2_a = rtb_MinMax1_h - Gen2_ref_DWork->x2;
  u0 = 1.0 / r * rtb_Switch2_a;
  if ((Gen2_ref_B->BusInput3.traj.rTi_BDC >= Ts_tmp) ||
      rtb_LogicalOperator5_g_tmp) {
    FILT_IN = Gen2_ref_B->BusInput3.traj.rTi_BDC;
  } else {
    FILT_IN = Ts_tmp;
  }

  u1 = 1.0 / FILT_IN * rtb_Switch2_a;
  if ((u0 >= u1) || rtIsNaN(u1)) {
    u1 = u0;
  }

  rtb_Switch2_lu = u1 * Ts_tmp + Gen2_ref_DWork->x2;
  if ((rtb_Switch2_j0 >= Ts_tmp) || rtb_LogicalOperator5_g_tmp) {
    r = rtb_Switch2_j0;
  } else {
    r = Ts_tmp;
  }

  rtb_Switch2_a = rtb_MinMax1_g - Gen2_ref_DWork->x3;
  u0 = 1.0 / r * rtb_Switch2_a;
  rtb_bCBV_min = !rtb_LogicalOperator5_g_tmp;
  if ((!(rtb_Product1_bc >= Ts_tmp)) && rtb_bCBV_min) {
    rtb_Product1_bc = Ts_tmp;
  }

  u1 = 1.0 / rtb_Product1_bc * rtb_Switch2_a;
  if ((u0 >= u1) || rtIsNaN(u1)) {
    u1 = u0;
  }

  rtb_Divide3_k = u1 * Ts_tmp + Gen2_ref_DWork->x3;
  if ((rtb_Switch2_j0 >= Ts_tmp) || rtb_LogicalOperator5_g_tmp) {
    r = rtb_Switch2_j0;
  } else {
    r = Ts_tmp;
  }

  rtb_Switch2_a = rtb_Sum11 - Gen2_ref_DWork->x_e;
  u0 = 1.0 / r * rtb_Switch2_a;
  if ((Gen2_ref_B->BusInput3.traj.rTi_BDC >= Ts_tmp) ||
      rtb_LogicalOperator5_g_tmp) {
    FILT_IN = Gen2_ref_B->BusInput3.traj.rTi_BDC;
  } else {
    FILT_IN = Ts_tmp;
  }

  FILT_IN = 1.0 / FILT_IN * rtb_Switch2_a;
  if ((u0 >= FILT_IN) || rtIsNaN(FILT_IN)) {
    FILT_IN = u0;
  }

  if (FILT_IN > 0.0) {
    u0 = FILT_IN * Ts_tmp + Gen2_ref_DWork->x_e;
    rtb_Product1_bc = rtb_Gain_kl + Gen2_ref_B->BusInput3.traj.rPrR_delta_p2s;
    if ((u0 <= rtb_Product1_bc) || rtIsNaN(rtb_Product1_bc)) {
      rtb_Product1_bc = u0;
    }
  } else {
    u0 = FILT_IN * Ts_tmp + Gen2_ref_DWork->x_e;
    rtb_Product1_bc = rtb_Gain_kl - Gen2_ref_B->BusInput3.traj.rPrR_delta_p2s;
    if ((u0 >= rtb_Product1_bc) || rtIsNaN(rtb_Product1_bc)) {
      rtb_Product1_bc = u0;
    }
  }

  if ((!(rtb_Switch2_j0 >= Ts_tmp)) && rtb_bCBV_min) {
    rtb_Switch2_j0 = Ts_tmp;
  }

  rtb_Switch2_a = rtb_Sum7_l5 - Gen2_ref_DWork->x4;
  u0 = 1.0 / rtb_Switch2_j0 * rtb_Switch2_a;
  if ((!(rtb_Switch1_lk >= Ts_tmp)) && rtb_bCBV_min) {
    rtb_Switch1_lk = Ts_tmp;
  }

  u1 = 1.0 / rtb_Switch1_lk * rtb_Switch2_a;
  if (FILT_IN > 0.0) {
    if ((u0 >= u1) || rtIsNaN(u1)) {
      u1 = u0;
    }

    u0 = u1 * Ts_tmp + Gen2_ref_DWork->x4;
    rtb_Switch2_j0 = rtb_Gain_kl + Gen2_ref_B->BusInput3.traj.rPrR_delta_p2s;
    if ((u0 <= rtb_Switch2_j0) || rtIsNaN(rtb_Switch2_j0)) {
      rtb_Switch2_j0 = u0;
    }
  } else {
    if ((u0 >= u1) || rtIsNaN(u1)) {
      u1 = u0;
    }

    rtb_Switch2_j0 = u1 * Ts_tmp + Gen2_ref_DWork->x4;
  }

  Gen2_ref_DWork->x_e = rtb_Product1_bc;
  Gen2_ref_DWork->x0 = rtb_Sum10;
  Gen2_ref_DWork->x1 = rtb_Switch2_h1;
  Gen2_ref_DWork->x2 = rtb_Switch2_lu;
  Gen2_ref_DWork->x3 = rtb_Divide3_k;
  Gen2_ref_DWork->x4 = rtb_Switch2_j0;

  /* Product: '<S64>/delta rise limit' incorporates:
   *  Constant: '<S23>/Constant4'
   *  SampleTimeMath: '<S64>/sample time'
   *
   * About '<S64>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum1_dh = 100000.0;

  /* S-Function (sfix_look1_dyn): '<S23>/Lookup Table Dynamic1' */
  /* Dynamic Look-Up Table Block: '<S23>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_MinMax_a),
                       &Gen2_ref_B->BusInput3.traj.rRateLimTVdpctrl[0],
                       rtb_Gain_kl, &rtb_Gain1_eu[0], 4U, inst);

  /* Abs: '<S23>/Abs3' */
  rtb_Switch1_lk = fabs(rtb_MinMax_a);

  /* Product: '<S63>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S63>/sample time'
   *
   * About '<S63>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_MinMax_a = rtb_Switch1_lk * 0.01;

  /* Switch: '<S23>/Switch2' incorporates:
   *  Delay: '<S23>/Delay'
   *  Switch: '<S23>/Switch4'
   */
  if (Gen2_ref_DWork->Delay_DSTATE_lv) {
    FILT_IN = rtb_Product2;
  } else if (Gen2_ref_B->BusInput3.traj.bFactInitResetTVdp) {
    /* Sum: '<S23>/Sum' incorporates:
     *  MATLAB Function: '<S23>/ref traj'
     *  Switch: '<S23>/Switch4'
     */
    FILT_IN = Gen2_ref_B->BusInput3.traj.rPrR_TC_LP_min - rtb_Divide3_k;

    /* Saturate: '<S23>/Saturation' incorporates:
     *  Switch: '<S23>/Switch4'
     */
    if (FILT_IN > 1.0) {
      FILT_IN = 1.0;
    } else if (FILT_IN < 0.0) {
      FILT_IN = 0.0;
    }

    /* End of Saturate: '<S23>/Saturation' */
  } else {
    /* Switch: '<S23>/Switch4' incorporates:
     *  Constant: '<S23>/Constant2'
     */
    FILT_IN = 0.0;
  }

  /* End of Switch: '<S23>/Switch2' */

  /* Logic: '<S23>/Logical Operator4' incorporates:
   *  Constant: '<S23>/Constant1'
   *  MATLAB Function: '<S23>/ref traj'
   *  RelationalOperator: '<S23>/Relational Operator2'
   *  Sum: '<S23>/Sum4'
   */
  rtb_LogicalOperator2_p1 = (((rtb_Sum11 - rtb_Gain_kl >
    Gen2_ref_B->BusInput3.traj.rPr_delta_p2s_resetTVdp) || (delta_y >
    Gen2_ref_B->BusInput3.traj.rPr_delta_p2s_resetTVdp) ||
    rtb_LogicalOperator2_dc) && (rtb_Switch1_kk <= 0.0));

  /* Abs: '<S23>/Abs' incorporates:
   *  Sum: '<S23>/Sum4'
   */
  rtb_Switch2_a = fabs(rtb_Switch1_kk);

  /* Outputs for Atomic SubSystem: '<S23>/TON_1' */
  /* Logic: '<S23>/Logical Operator5' incorporates:
   *  Logic: '<S23>/Logical Operator6'
   *  RelationalOperator: '<S23>/Relational Operator'
   */
  Gen2_ref_TON_1(((!rtb_LogicalOperator2_p1) && (rtb_Switch2_a <=
    Gen2_ref_B->BusInput3.traj.rN_ssTVdpCtrl)),
                 Gen2_ref_B->BusInput3.traj.rT_TON_TVdpCtrl, &Gen2_ref_B->TON_1,
                 &Gen2_ref_DWork->TON_1, inst);

  /* End of Outputs for SubSystem: '<S23>/TON_1' */

  /* Switch: '<S53>/Switch' incorporates:
   *  Switch: '<S53>/Switch1'
   *  UnitDelay: '<S53>/Unit Delay4'
   */
  if (!rtb_LogicalOperator2_p1) {
    rtb_LogicalOperator2_p1 = ((!Gen2_ref_B->TON_1.LogicalOperator3) &&
      Gen2_ref_DWork->UnitDelay4_DSTATE_o);
  }

  /* End of Switch: '<S53>/Switch' */

  /* Logic: '<S23>/Logical Operator1' */
  rtb_LogicalOperator1_a0 = (rtb_LogicalOperator || rtb_LogicalOperator2_p1);

  /* Delay: '<S63>/Delay' */
  Gen2_ref_DWork->icLoad_g = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_k2 ==
    1) != (int32_T)rtb_LogicalOperator1_a0) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_k2 != 3)) ||
    rtb_LogicalOperator1_a0 || Gen2_ref_DWork->icLoad_g);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_k2 = rtb_LogicalOperator1_a0;
  if (Gen2_ref_DWork->icLoad_g) {
    Gen2_ref_DWork->Delay_DSTATE_c = FILT_IN;
  }

  /* Switch: '<S63>/etaVolConst' */
  if (!rtb_LogicalOperator1_a0) {
    FILT_IN = rtb_Product2;
  }

  /* End of Switch: '<S63>/etaVolConst' */

  /* Sum: '<S63>/Difference Inputs1' incorporates:
   *  Delay: '<S63>/Delay'
   */
  rtb_deltafalllimit_h0 = FILT_IN - Gen2_ref_DWork->Delay_DSTATE_c;

  /* Switch: '<S102>/Switch2' incorporates:
   *  RelationalOperator: '<S102>/LowerRelop1'
   */
  if (!(rtb_deltafalllimit_h0 > rtb_MinMax_a)) {
    /* Product: '<S63>/delta fall limit' incorporates:
     *  Gain: '<S23>/Gain4'
     *  SampleTimeMath: '<S63>/sample time'
     *
     * About '<S63>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch1_lk = -rtb_Switch1_lk * 0.01;

    /* Switch: '<S102>/Switch' incorporates:
     *  RelationalOperator: '<S102>/UpperRelop'
     */
    if (rtb_deltafalllimit_h0 < rtb_Switch1_lk) {
      rtb_MinMax_a = rtb_Switch1_lk;
    } else {
      rtb_MinMax_a = rtb_deltafalllimit_h0;
    }

    /* End of Switch: '<S102>/Switch' */
  }

  /* End of Switch: '<S102>/Switch2' */

  /* Sum: '<S63>/Difference Inputs2' incorporates:
   *  Delay: '<S63>/Delay'
   */
  rtb_deltafalllimit_h0 = rtb_MinMax_a + Gen2_ref_DWork->Delay_DSTATE_c;

  /* Switch: '<S23>/Switch3' */
  if (rtb_LogicalOperator) {
    rtb_MinMax_a = rtb_Product2;
  } else {
    rtb_MinMax_a = rtb_deltafalllimit_h0;
  }

  /* End of Switch: '<S23>/Switch3' */

  /* Saturate: '<S23>/Saturation2' */
  if (rtb_MinMax_a <= 0.0) {
    rtb_Switch2_a = 0.0;
  } else {
    rtb_Switch2_a = rtb_MinMax_a;
  }

  /* End of Saturate: '<S23>/Saturation2' */

  /* Delay: '<S64>/Delay' incorporates:
   *  Constant: '<S23>/Constant3'
   */
  Gen2_ref_DWork->icLoad_c1 = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_a ==
    1) != (int32_T)rtb_LogicalOperator2_dc) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_a != 3)) ||
    rtb_LogicalOperator2_dc || Gen2_ref_DWork->icLoad_c1);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_a = rtb_LogicalOperator2_dc;
  if (Gen2_ref_DWork->icLoad_c1) {
    Gen2_ref_DWork->Delay_DSTATE_i = 0.0;
  }

  /* Switch: '<S64>/etaVolConst' incorporates:
   *  Constant: '<S23>/Constant3'
   */
  if (rtb_LogicalOperator2_dc) {
    FILT_IN = 0.0;
  } else {
    FILT_IN = rtb_Switch2_a;
  }

  /* End of Switch: '<S64>/etaVolConst' */

  /* Sum: '<S64>/Difference Inputs1' incorporates:
   *  Delay: '<S64>/Delay'
   */
  rtb_Switch1_lk = FILT_IN - Gen2_ref_DWork->Delay_DSTATE_i;

  /* Switch: '<S103>/Switch2' incorporates:
   *  RelationalOperator: '<S103>/LowerRelop1'
   */
  if (!(rtb_Switch1_lk > 100000.0)) {
    /* Product: '<S64>/delta fall limit' incorporates:
     *  Abs: '<S23>/Abs2'
     *  Gain: '<S23>/Gain7'
     *  SampleTimeMath: '<S64>/sample time'
     *
     * About '<S64>/sample time':
     *  y = K where K = ( w * Ts )
     */
    FILT_IN = -fabs(Gen2_ref_B->BusInput3.traj.rRateResetTVdpctrl) * 0.01;

    /* Switch: '<S103>/Switch' incorporates:
     *  RelationalOperator: '<S103>/UpperRelop'
     */
    if (rtb_Switch1_lk < FILT_IN) {
      rtb_Sum1_dh = FILT_IN;
    } else {
      rtb_Sum1_dh = rtb_Switch1_lk;
    }

    /* End of Switch: '<S103>/Switch' */
  }

  /* End of Switch: '<S103>/Switch2' */

  /* Sum: '<S64>/Difference Inputs2' incorporates:
   *  Delay: '<S64>/Delay'
   */
  rtb_Switch1_lk = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_i;

  /* Sum: '<S23>/Sum5' incorporates:
   *  MATLAB Function: '<S23>/ref traj'
   */
  FILT_IN = rtb_Switch2_h1 + rtb_Switch1_lk;

  /* Switch: '<S54>/Switch2' incorporates:
   *  RelationalOperator: '<S54>/LowerRelop1'
   *  RelationalOperator: '<S54>/UpperRelop'
   *  Switch: '<S54>/Switch'
   */
  if (FILT_IN > rtb_Switch2_oou) {
    rtb_Switch2_h1 = rtb_Switch2_oou;
  } else if (FILT_IN < Gen2_ref_B->BusInput3.traj.rPrMinRefp2ff) {
    /* Switch: '<S54>/Switch' */
    rtb_Switch2_h1 = Gen2_ref_B->BusInput3.traj.rPrMinRefp2ff;
  } else {
    rtb_Switch2_h1 = FILT_IN;
  }

  /* End of Switch: '<S54>/Switch2' */

  /* Switch: '<S60>/Switch2' incorporates:
   *  MATLAB Function: '<S23>/ref traj'
   *  RelationalOperator: '<S60>/LowerRelop1'
   *  RelationalOperator: '<S60>/UpperRelop'
   *  Switch: '<S60>/Switch'
   */
  if (rtb_Switch2_lu > Gen2_ref_B->BusInput3.traj.rPr_p2s_max) {
    rtb_Switch2_lu = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  } else if (rtb_Switch2_lu < Gen2_ref_B->BusInput3.traj.rPr_p2s_min) {
    /* Switch: '<S60>/Switch' */
    rtb_Switch2_lu = Gen2_ref_B->BusInput3.traj.rPr_p2s_min;
  }

  /* End of Switch: '<S60>/Switch2' */

  /* Sum: '<S23>/Sum2' incorporates:
   *  MATLAB Function: '<S23>/ref traj'
   */
  FILT_IN = rtb_Divide3_k + rtb_Switch2_a;

  /* Switch: '<S59>/Switch2' incorporates:
   *  RelationalOperator: '<S59>/LowerRelop1'
   *  RelationalOperator: '<S59>/UpperRelop'
   *  Switch: '<S59>/Switch'
   */
  if (FILT_IN > Gen2_ref_B->BusInput3.traj.rPr_p2s_max) {
    rtb_Sum1_dh = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  } else if (FILT_IN < Gen2_ref_B->BusInput3.traj.rPrMinRefp2ff) {
    /* Switch: '<S59>/Switch' */
    rtb_Sum1_dh = Gen2_ref_B->BusInput3.traj.rPrMinRefp2ff;
  } else {
    rtb_Sum1_dh = FILT_IN;
  }

  /* End of Switch: '<S59>/Switch2' */

  /* Abs: '<S68>/Abs' */
  rtb_Switch2_a = fabs(Gen2_ref_B->BusInput3.bdcMisc.rRefGainScheduleSL);

  /* Switch: '<S68>/Switch' incorporates:
   *  Constant: '<S68>/Constant2'
   *  RelationalOperator: '<S68>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_a) {
    FILT_IN = 2.2204460492503131E-16;
  } else {
    FILT_IN = Gen2_ref_B->BusInput3.bdcMisc.rRefGainScheduleSL;
  }

  /* End of Switch: '<S68>/Switch' */

  /* Abs: '<S67>/Abs' */
  rtb_Switch2_a = fabs(rtb_Switch13);

  /* Sum: '<S48>/Sum8' incorporates:
   *  Gain: '<S23>/Gain3'
   */
  rtb_Product4_d = 1.0E-5 * Gen2_ref_B->p2HP_filt.Switch - rtb_Switch2_oou;

  /* Switch: '<S67>/Switch' incorporates:
   *  Constant: '<S67>/Constant2'
   *  RelationalOperator: '<S67>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch2_a) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = rtb_Switch13;
  }

  /* End of Switch: '<S67>/Switch' */

  /* Saturate: '<S48>/Saturation1' */
  if (rtb_Product4_d <= 0.0) {
    rtb_Product4_d = 0.0;
  }

  /* End of Saturate: '<S48>/Saturation1' */

  /* Product: '<S48>/Divide3' incorporates:
   *  DataTypeConversion: '<S48>/Data Type Conversion'
   *  Product: '<S48>/Divide2'
   *  RelationalOperator: '<S48>/Relational Operator2'
   */
  rtb_Divide3_k = (real_T)(Gen2_ref_B->BusInput3.LR.rN_LR_HardLim_norm > 1.0 /
    delta_y * rtb_DataTypeConversion15) * rtb_Product4_d;

  /* DiscreteIntegrator: '<S48>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_dc ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_l != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac = 0.0;
  }

  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac = 0.0;
  }

  /* Switch: '<S48>/Switch' incorporates:
   *  Constant: '<S48>/ON1'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bSwitch_SurgeLine_LIMIT) {
    /* Sum: '<S48>/Sum12' incorporates:
     *  DiscreteIntegrator: '<S48>/Discrete-Time Integrator'
     *  Product: '<S48>/Product2'
     */
    rtb_Product4_d = rtb_Divide3_k *
      Gen2_ref_B->BusInput3.bdcMisc.rKpSurgeProtectSL +
      Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac;

    /* Saturate: '<S48>/Saturation3' */
    if (rtb_Product4_d > 5.0) {
      rtb_Product4_d = 5.0;
    } else if (rtb_Product4_d < 0.0) {
      rtb_Product4_d = 0.0;
    }

    /* End of Saturate: '<S48>/Saturation3' */
  } else {
    rtb_Product4_d = 0.0;
  }

  /* End of Switch: '<S48>/Switch' */

  /* Product: '<S48>/Divide4' incorporates:
   *  Gain: '<S23>/Gain5'
   *  Product: '<S48>/Divide5'
   */
  rtb_Product4_d *= 1.0 / FILT_IN * (1.0E-5 * Gen2_ref_B->p2s_filt.Switch);

  /* Saturate: '<S23>/Saturation3' */
  if (rtb_MinMax_a >= 0.0) {
    rtb_Switch2_a = 0.0;
  } else {
    rtb_Switch2_a = rtb_MinMax_a;
  }

  /* End of Saturate: '<S23>/Saturation3' */

  /* Gain: '<S23>/Gain6' */
  rtb_Switch2_a = -rtb_Switch2_a;

  /* Sum: '<S23>/Sum9' incorporates:
   *  MATLAB Function: '<S23>/ref traj'
   *  Sum: '<S23>/Sum11'
   */
  rtb_Product1_bc = (rtb_Product1_bc + rtb_Switch2_a) + rtb_Product4_d;

  /* Switch: '<S56>/Switch2' incorporates:
   *  RelationalOperator: '<S56>/LowerRelop1'
   *  RelationalOperator: '<S56>/UpperRelop'
   *  Switch: '<S56>/Switch'
   */
  if (rtb_Product1_bc > Gen2_ref_B->BusInput3.traj.rPr_p2s_max) {
    /* BusCreator: '<S23>/Bus Creator1' */
    rtb_BusCreator1_ref_P2s_FB_TV = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  } else if (rtb_Product1_bc < Gen2_ref_B->BusInput3.traj.rPr_p2s_min) {
    /* Switch: '<S56>/Switch' incorporates:
     *  BusCreator: '<S23>/Bus Creator1'
     */
    rtb_BusCreator1_ref_P2s_FB_TV = Gen2_ref_B->BusInput3.traj.rPr_p2s_min;
  } else {
    /* BusCreator: '<S23>/Bus Creator1' incorporates:
     *  Switch: '<S56>/Switch'
     */
    rtb_BusCreator1_ref_P2s_FB_TV = rtb_Product1_bc;
  }

  /* End of Switch: '<S56>/Switch2' */

  /* Sum: '<S23>/Sum1' incorporates:
   *  MATLAB Function: '<S23>/ref traj'
   */
  rtb_Product1_bc = rtb_Switch2_j0 + rtb_Switch1_lk;

  /* Switch: '<S55>/Switch2' incorporates:
   *  RelationalOperator: '<S55>/LowerRelop1'
   */
  if (!(rtb_Product1_bc > rtb_Switch2_oou)) {
    /* Switch: '<S55>/Switch' incorporates:
     *  RelationalOperator: '<S55>/UpperRelop'
     */
    if (rtb_Product1_bc < Gen2_ref_B->BusInput3.traj.rPrR_TC_LP_min) {
      rtb_Switch2_oou = Gen2_ref_B->BusInput3.traj.rPrR_TC_LP_min;
    } else {
      rtb_Switch2_oou = rtb_Product1_bc;
    }

    /* End of Switch: '<S55>/Switch' */
  }

  /* End of Switch: '<S55>/Switch2' */

  /* Sum: '<S23>/Sum10' incorporates:
   *  MATLAB Function: '<S23>/ref traj'
   *  Sum: '<S23>/Sum3'
   */
  rtb_Sum10 = (rtb_Sum10 + rtb_Switch2_a) + rtb_Product4_d;

  /* Switch: '<S57>/Switch2' incorporates:
   *  RelationalOperator: '<S57>/LowerRelop1'
   *  RelationalOperator: '<S57>/UpperRelop'
   *  Switch: '<S57>/Switch'
   */
  if (rtb_Sum10 > Gen2_ref_B->BusInput3.traj.rPr_p2s_max) {
    rtb_Switch2_jf = Gen2_ref_B->BusInput3.traj.rPr_p2s_max;
  } else if (rtb_Sum10 < Gen2_ref_B->BusInput3.traj.rPr_p2s_min) {
    /* Switch: '<S57>/Switch' */
    rtb_Switch2_jf = Gen2_ref_B->BusInput3.traj.rPr_p2s_min;
  } else {
    rtb_Switch2_jf = rtb_Sum10;
  }

  /* End of Switch: '<S57>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S23>/Filter2' */
  /* UnitDelay: '<S23>/Unit Delay3' */
  Gen2_ref_Filter1(rtb_Switch2_jf, Gen2_ref_B->BusInput3.traj.rTiF_PrR_der,
                   Gen2_ref_DWork->UnitDelay3_DSTATE_gf, &Gen2_ref_B->Filter2,
                   &Gen2_ref_DWork->Filter2, inst);

  /* End of Outputs for SubSystem: '<S23>/Filter2' */

  /* Outputs for Atomic SubSystem: '<S23>/Filter1' */
  Gen2_ref_Filter1(rtb_Switch2_h1, Gen2_ref_B->BusInput3.traj.rTiF_PrR_der,
                   Gen2_ref_DWork->UnitDelay3_DSTATE_gf, &Gen2_ref_B->Filter1,
                   &Gen2_ref_DWork->Filter1, inst);

  /* End of Outputs for SubSystem: '<S23>/Filter1' */

  /* Outputs for Atomic SubSystem: '<S23>/Filter4' */
  Gen2_ref_Filter1(rtb_Switch2_lu, Gen2_ref_B->BusInput3.traj.rTiF_PrR_der,
                   Gen2_ref_DWork->UnitDelay3_DSTATE_gf, &Gen2_ref_B->Filter4,
                   &Gen2_ref_DWork->Filter4, inst);

  /* End of Outputs for SubSystem: '<S23>/Filter4' */

  /* BusCreator: '<S23>/Bus Creator1' */
  rtb_BusCreator1_ref_P2_FF = rtb_Sum1_dh;
  rtb_BusCreator1_ref_P2_FB_CBV = rtb_Switch2_oou;

  /* MultiPortSwitch: '<S24>/Multiport Switch' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  if ((int32_T)Gen2_ref_B->sf_MATLABFunction_f.y == 1) {
    rtb_Sum2_a1 = rtb_Switch2_jf;
  } else {
    rtb_Sum2_a1 = rtb_Switch2_lu;
  }

  /* End of MultiPortSwitch: '<S24>/Multiport Switch' */

  /* MATLAB Function: '<S44>/engine massflow2' incorporates:
   *  Gain: '<S1>/Gain9'
   *  Gain: '<S44>/rpm2rad1'
   */
  Gen2_ref_enginemassflow2(100000.0 * rtb_Sum2_a1, Gen2_ref_B->T2s_filt.Switch,
    0.10471975511965977 * rtb_Switch13, rtb_etaVolConst_lt,
    Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng, &Gen2_ref_B->sf_enginemassflow2, inst);

  /* MultiPortSwitch: '<S24>/Multiport Switch1' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  if ((int32_T)Gen2_ref_B->sf_MATLABFunction_f.y == 1) {
    rtb_Sum2_a1 = Gen2_ref_B->Filter2.Switch1;
  } else {
    rtb_Sum2_a1 = Gen2_ref_B->Filter4.Switch1;
  }

  /* End of MultiPortSwitch: '<S24>/Multiport Switch1' */

  /* Gain: '<S1>/Gain10' */
  rtb_Switch2_oou = 100000.0 * rtb_Sum2_a1;

  /* DataTypeConversion: '<S155>/Data Type Conversion' */
  rtb_Sum2_a1 = Gen2_ref_B->BusInput3.bdcTv.bDynFFtv_ON;

  /* Product: '<S155>/Divide7' incorporates:
   *  Constant: '<S155>/R_air'
   */
  rtb_Product4_d = 287.15 * Gen2_ref_B->T2s_filt.Switch;

  /* Product: '<S155>/Divide6' */
  rtb_Product4_d = Gen2_ref_B->BusInput3.eng.rVol_im / rtb_Product4_d;

  /* Product: '<S155>/Divide8' */
  rtb_Switch2_oou = rtb_Switch2_oou * rtb_Sum2_a1 * rtb_Product4_d;

  /* Saturate: '<S44>/Saturation1' */
  if (Gen2_ref_B->BusInput3.eng.rNum_TV > 10.0) {
    rtb_Sum2_a1 = 10.0;
  } else if (Gen2_ref_B->BusInput3.eng.rNum_TV < 1.0) {
    rtb_Sum2_a1 = 1.0;
  } else {
    rtb_Sum2_a1 = Gen2_ref_B->BusInput3.eng.rNum_TV;
  }

  /* End of Saturate: '<S44>/Saturation1' */

  /* Product: '<S44>/Divide' incorporates:
   *  Sum: '<S44>/Sum3'
   */
  rtb_Divide_n0 = (Gen2_ref_B->sf_enginemassflow2.dm_e + rtb_Switch2_oou) /
    rtb_Sum2_a1;

  /* MultiPortSwitch: '<S24>/Multiport Switch2' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  rtb_Sum2_a1 = rtb_Sum1_dh;

  /* Gain: '<S1>/Gain11' */
  rtb_Switch2_oou = 100000.0 * rtb_Sum2_a1;

  /* MultiPortSwitch: '<S24>/Multiport Switch3' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  rtb_Sum2_a1 = rtb_Switch2_lu;

  /* Gain: '<S1>/Gain12' */
  rtb_Sum10 = 100000.0 * rtb_Sum2_a1;

  /* MATLAB Function: '<S44>/MATLAB Function3' incorporates:
   *  Constant: '<S44>/Constant3'
   *  Product: '<S44>/Product1'
   */
  if (rtb_Switch2_oou >= rtb_Sum10) {
    r = rtb_Sum10 / rtb_Switch2_oou;
    if ((1.0E-6 >= r) || rtIsNaN(r)) {
      r = 1.0E-6;
    }

    if (1.0 / r <= 1.8929291587378541) {
      u0 = 0.78539816339744828 * Gen2_ref_B->BusInput3.bdcTv.rDref *
        Gen2_ref_B->BusInput3.bdcTv.rDref * rtb_Switch2_oou / sqrt(287.15 *
        Gen2_ref_B->T2s_filt.Switch) * sqrt((rt_powd_snf(r, 1.4285714285714286, inst)
        - rt_powd_snf(r, 1.7142857142857144, inst)) * 7.0000000000000009);
      if (!(u0 >= 1.0E-6)) {
        u0 = 1.0E-6;
      }

      rtb_Switch2_oou = rtb_Divide_n0 / u0;
    } else {
      u0 = 0.78539816339744828 * Gen2_ref_B->BusInput3.bdcTv.rDref *
        Gen2_ref_B->BusInput3.bdcTv.rDref * rtb_Switch2_oou / sqrt(287.15 *
        Gen2_ref_B->T2s_filt.Switch) * 0.6847314563772704;
      if (!(u0 >= 1.0E-6)) {
        u0 = 1.0E-6;
      }

      rtb_Switch2_oou = rtb_Divide_n0 / u0;
    }
  } else {
    rtb_Switch2_oou = 1.0;
  }

  /* End of MATLAB Function: '<S44>/MATLAB Function3' */

  /* Saturate: '<S44>/Saturation3' */
  if (rtb_Switch2_oou > 1.0) {
    rtb_Sum2_a1 = 1.0;
  } else if (rtb_Switch2_oou < 0.0) {
    rtb_Sum2_a1 = 0.0;
  } else {
    rtb_Sum2_a1 = rtb_Switch2_oou;
  }

  /* End of Saturate: '<S44>/Saturation3' */

  /* S-Function (sfix_look1_dyn): '<S44>/Lookup Table Dynamic1' */
  /* Dynamic Look-Up Table Block: '<S44>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Product4_d),
                       &Gen2_ref_B->BusInput3.bdcTv.rCd_vect_x[0], rtb_Sum2_a1,
                       &Gen2_ref_B->BusInput3.bdcTv.rCd_vect_y[0], 10U, inst);

  /* MinMax: '<S44>/MinMax' */
  rtb_Sum1_dh = Gen2_ref_B->BusInput3.bdcTv.rCd_vect_x[0];
  for (k = 0; k < 10; k++) {
    u1 = Gen2_ref_B->BusInput3.bdcTv.rCd_vect_x[k + 1];
    if ((!(rtb_Sum1_dh >= u1)) && (!rtIsNaN(u1))) {
      rtb_Sum1_dh = u1;
    }
  }

  /* End of MinMax: '<S44>/MinMax' */

  /* Switch: '<S154>/Switch' incorporates:
   *  Abs: '<S154>/Abs'
   *  Constant: '<S154>/Constant2'
   *  RelationalOperator: '<S154>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Sum1_dh)) {
    rtb_Sum1_dh = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S154>/Switch' */

  /* Product: '<S44>/Divide1' */
  rtb_Switch2_oou = rtb_Product4_d / rtb_Sum1_dh;

  /* Saturate: '<S44>/Saturation' */
  rtb_Product4_d = rtb_Saturation1_i;

  /* Product: '<S44>/Product' */
  rtb_Switch2_oou *= rtb_Product4_d;

  /* Gain: '<S427>/Gain1' */
  rtb_Product4_d = 0.001 * Gen2_ref_B->BusInput3.LR.rTi_LR_LIM_TV_OFF;

  /* Outputs for Atomic SubSystem: '<S427>/TOF3' */
  /* Logic: '<S427>/Logical Operator14' incorporates:
   *  Bias: '<S427>/ u+Ts3'
   *  Logic: '<S427>/Logical Operator15'
   *  RelationalOperator: '<S427>/Relational Operator10'
   *  RelationalOperator: '<S427>/Relational Operator5'
   */
  Gen2_ref_TOF((rtb_RelationalOperator2_j &&
                Gen2_ref_B->BusInput3.LR.bLIM_TVbyP2s_OFFatLargeRej &&
                ((rtb_Saturation > Gen2_ref_B->BusInput3.LR.rP_Trig_TVbyP2S_OFF)
                 || (rtb_Divide4_d > Gen2_ref_B->BusInput3.LR.rN_LR_HardLim_norm))),
               rtb_Product4_d + 0.01, &Gen2_ref_B->TOF3, &Gen2_ref_DWork->TOF3, inst);

  /* End of Outputs for SubSystem: '<S427>/TOF3' */

  /* Logic: '<S427>/Logical Operator16' incorporates:
   *  Logic: '<S427>/Logical Operator17'
   *  RelationalOperator: '<S427>/Relational Operator7'
   *  UnitDelay: '<S427>/Unit Delay1'
   */
  rtb_LogicalOperator1_a0 = (Gen2_ref_B->TOF3.LogicalOperator1 ||
    ((rtb_Divide4_d > Gen2_ref_B->BusInput3.LR.rN_LIM_TVbyPOS_ON) &&
     Gen2_ref_DWork->UnitDelay1_DSTATE_m));

  /* Switch: '<S133>/Switch' incorporates:
   *  Logic: '<S43>/Logical Operator'
   *  Switch: '<S133>/Switch1'
   */
  if (rtb_LogicalOperator1_a0) {
    rtb_Switch_e = Gen2_ref_B->BusInput3.bdcTv.rPos_min;
  } else {
    if (Gen2_ref_B->BusInput3.LR.bSwitch_Surge_TV_Min) {
      /* Gain: '<S133>/Gain1' incorporates:
       *  Switch: '<S133>/Switch1'
       */
      rtb_Sum10 = rtb_kW2W1_h;

      /* S-Function (sfix_look1_dyn): '<S133>/Surge protection depending  on boost pressure' incorporates:
       *  Switch: '<S133>/Switch1'
       */
      /* Dynamic Look-Up Table Block: '<S133>/Surge protection depending  on boost pressure'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_Surgeprotectiondependingonb),
                           &Gen2_ref_B->BusInput3.LR.rLCRCurve_DK_min_Lup_y[0],
                           rtb_Sum10,
                           &Gen2_ref_B->BusInput3.LR.rLCRCurve_DK_min_Lup_x[0],
                           7U, inst);

      /* Switch: '<S133>/Switch1' incorporates:
       *  Sum: '<S133>/Sum1'
       */
      rtb_Sum10 = rtb_Surgeprotectiondependingonb +
        Gen2_ref_B->BusInput3.LR.rLCRCurve_DK_min_Lup_offset;
    } else {
      /* Switch: '<S133>/Switch1' */
      rtb_Sum10 = Gen2_ref_B->BusInput3.bdcTv.rPos_min;
    }

    /* Switch: '<S136>/Switch2' incorporates:
     *  RelationalOperator: '<S136>/LowerRelop1'
     *  RelationalOperator: '<S136>/UpperRelop'
     *  Switch: '<S136>/Switch'
     */
    if (rtb_Sum10 > Gen2_ref_B->BusInput3.bdcTv.rPos_max) {
      rtb_Switch_e = Gen2_ref_B->BusInput3.bdcTv.rPos_max;
    } else if (rtb_Sum10 < Gen2_ref_B->BusInput3.bdcTv.rPos_min) {
      /* Switch: '<S136>/Switch' */
      rtb_Switch_e = Gen2_ref_B->BusInput3.bdcTv.rPos_min;
    } else {
      rtb_Switch_e = rtb_Sum10;
    }

    /* End of Switch: '<S136>/Switch2' */
  }

  /* Switch: '<S157>/Switch2' incorporates:
   *  RelationalOperator: '<S157>/LowerRelop1'
   *  RelationalOperator: '<S157>/UpperRelop'
   *  Switch: '<S157>/Switch'
   */
  if (rtb_Switch2_oou > Gen2_ref_B->BusInput3.bdcTv.rPos_max) {
    rtb_Product4_d = Gen2_ref_B->BusInput3.bdcTv.rPos_max;
  } else if (rtb_Switch2_oou < rtb_Switch_e) {
    /* Switch: '<S157>/Switch' */
    rtb_Product4_d = rtb_Switch_e;
  } else {
    rtb_Product4_d = rtb_Switch2_oou;
  }

  /* End of Switch: '<S157>/Switch2' */

  /* Switch: '<S45>/Switch4' incorporates:
   *  Constant: '<S45>/Constant1'
   */
  if (Gen2_ref_B->BusInput3.bdcTv.bActive_ff) {
    rtb_Sum1_dh = rtb_Product4_d;
  } else {
    rtb_Sum1_dh = 0.0;
  }

  /* End of Switch: '<S45>/Switch4' */

  /* Saturate: '<S45>/Saturation1' */
  if (rtb_Sum1_dh > 1.0) {
    rtb_Switch2_oou = 1.0;
  } else if (rtb_Sum1_dh < 0.0) {
    rtb_Switch2_oou = 0.0;
  } else {
    rtb_Switch2_oou = rtb_Sum1_dh;
  }

  /* End of Saturate: '<S45>/Saturation1' */

  /* Outputs for Atomic SubSystem: '<S45>/Inverse_Linearization1' */
  Gen2_ref_Inverse_Linearization4(rtb_Switch2_oou, &Gen2_ref_B->BusInput3,
    &Gen2_ref_B->Inverse_Linearization1, inst);

  /* End of Outputs for SubSystem: '<S45>/Inverse_Linearization1' */

  /* S-Function (sfix_look1_dyn): '<S41>/Lookup8' */
  /* Dynamic Look-Up Table Block: '<S41>/Lookup8'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Sum1_dh),
                       &Gen2_ref_B->BusInput3.bdcTv.rGainMultRej_y[0],
                       rtb_DataTypeConversion15,
                       &Gen2_ref_B->BusInput3.bdcTv.rGainMultRej_x[0], 4U, inst);

  /* Gain: '<S41>/Pa2bar' incorporates:
   *  DiscreteIntegrator: '<S132>/Discrete-Time Integrator'
   */
  rtb_Pa2bar = 1.0E-5 * Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_g;

  /* Switch: '<S41>/Switch11' incorporates:
   *  Sum: '<S41>/Sum2'
   *  Sum: '<S41>/Sum4'
   */
  if (rtb_LogicalOperator) {
    /* S-Function (sfix_look1_dyn): '<S41>/Lookup' */
    /* Dynamic Look-Up Table Block: '<S41>/Lookup'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_kp_m), &Gen2_ref_B->BusInput3.bdcTv.rKp_Lup[0],
                         rtb_Pa2bar, &Gen2_ref_B->BusInput3.bdcMisc.rPr_Lup_in[0],
                         9U, inst);
    rtb_Switch2_oou = rtb_kp_m + Gen2_ref_B->BusInput3.bdcTv.rKp_grid_offset;
  } else {
    /* S-Function (sfix_look1_dyn): '<S41>/Lookup1' */
    /* Dynamic Look-Up Table Block: '<S41>/Lookup1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Lookup1),
                         &Gen2_ref_B->BusInput3.bdcTv.rKp_island_Lup[0],
                         rtb_Pa2bar, &Gen2_ref_B->BusInput3.bdcMisc.rPr_Lup_in[0],
                         9U, inst);
    rtb_Switch2_oou = rtb_Lookup1 +
      Gen2_ref_B->BusInput3.bdcTv.rKp_island_offset;
  }

  /* End of Switch: '<S41>/Switch11' */

  /* Product: '<S41>/Product' */
  rtb_Switch2_oou *= rtb_Sum1_dh;

  /* Switch: '<S128>/Switch2' incorporates:
   *  RelationalOperator: '<S128>/LowerRelop1'
   *  RelationalOperator: '<S128>/UpperRelop'
   *  Switch: '<S128>/Switch'
   */
  if (rtb_Switch2_oou > Gen2_ref_B->BusInput3.bdcMisc.rKpMax) {
    FILT_IN = Gen2_ref_B->BusInput3.bdcMisc.rKpMax;
  } else if (rtb_Switch2_oou < Gen2_ref_B->BusInput3.bdcMisc.rKpMin) {
    /* Switch: '<S128>/Switch' */
    FILT_IN = Gen2_ref_B->BusInput3.bdcMisc.rKpMin;
  } else {
    FILT_IN = rtb_Switch2_oou;
  }

  /* End of Switch: '<S128>/Switch2' */

  /* DataTypeConversion: '<S1>/Data Type Conversion20' */
  rtb_Sum1_dh = Gen2_ref_B->BusInput3.bdcMisc.bActive_BDC;

  /* Logic: '<S1>/Logical Operator' incorporates:
   *  DataTypeConversion: '<S1>/Data Type Conversion12'
   */
  rtb_LogicalOperator3_k = !(rtb_Sum1_dh != 0.0);

  /* MATLAB Function: '<S45>/tv_fb_err' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   *  SignalConversion generated from: '<S168>/ SFunction '
   */
  if ((!Gen2_ref_DWork->err_1_not_empty) || rtb_LogicalOperator3_k) {
    Gen2_ref_DWork->err_1 = 0.0;
    Gen2_ref_DWork->err_1_not_empty = true;
  }

  rtb_Sum10 = rtb_BusCreator1_ref_P2s_FB_TV - rtb_Divide3_a0;
  rtb_i_reset = (Gen2_ref_B->BusInput.tLvrt.bLvrtFlg || rtb_LogicalOperator3_k);
  rtb_Switch2_oou = Gen2_ref_DWork->err_1 - rtb_Sum10;
  Gen2_ref_DWork->err_1 = rtb_Sum10;

  /* Product: '<S45>/Product4' incorporates:
   *  MATLAB Function: '<S45>/tv_fb_err'
   */
  rtb_Product4 = FILT_IN * rtb_Sum10;

  /* Logic: '<S45>/Logical Operator1' incorporates:
   *  Logic: '<S45>/Logical Operator2'
   *  RelationalOperator: '<S160>/FixPt Relational Operator'
   *  UnitDelay: '<S160>/Delay Input1'
   */
  rtb_bCBV_min = ((Gen2_ref_B->BusInput3.bdcTv.bActive_ff !=
                   Gen2_ref_DWork->DelayInput1_DSTATE_f) &&
                  ((!rtb_LogicalOperator3_k) && rtb_LogicalOperator_b));

  /* Logic: '<S45>/Logical Operator3' */
  rtb_LogicalOperator3_aa = (rtb_i_reset || rtb_bCBV_min);

  /* Delay: '<S45>/Delay' */
  if (Gen2_ref_DWork->icLoad_eh) {
    Gen2_ref_DWork->Delay_DSTATE_cn =
      Gen2_ref_B->Inverse_Linearization1.LCRScal_Lam_EOT1;
  }

  /* Outputs for Atomic SubSystem: '<S161>/Inverse_Linearization4' */
  Gen2_ref_Inverse_Linearization4(Gen2_ref_B->BusInput3.bdcTv.rPos_Start,
    &Gen2_ref_B->BusInput3, &Gen2_ref_B->Inverse_Linearization4, inst);

  /* End of Outputs for SubSystem: '<S161>/Inverse_Linearization4' */

  /* Sum: '<S161>/Add2' */
  rtb_Add2 = (Gen2_ref_B->Inverse_Linearization4.LCRScal_Lam_EOT1 -
              Gen2_ref_B->Inverse_Linearization1.LCRScal_Lam_EOT1) -
    rtb_Product4;

  /* Delay: '<S161>/Delay' */
  if ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_o == 1) != (int32_T)
        rtb_LogicalOperator3_k) && (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_o
        != 3)) || rtb_LogicalOperator3_k) {
    Gen2_ref_DWork->Delay_DSTATE_gp = 0.0;
  }

  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_o = rtb_LogicalOperator3_k;

  /* Switch: '<S45>/Switch1' incorporates:
   *  Delay: '<S161>/Delay2'
   *  Delay: '<S45>/Delay'
   *  Sum: '<S45>/Sum'
   *  Sum: '<S45>/Sum4'
   *  Switch: '<S161>/Switch1'
   *  Switch: '<S161>/Switch3'
   *  UnitDelay: '<S45>/Unit Delay1'
   */
  if (rtb_bCBV_min) {
    rtb_Switch1_d2 = (Gen2_ref_DWork->Delay_DSTATE_cn -
                      Gen2_ref_B->Inverse_Linearization1.LCRScal_Lam_EOT1) +
      Gen2_ref_DWork->UnitDelay1_DSTATE_ed;
  } else if (Gen2_ref_DWork->Delay2_DSTATE_f) {
    /* Switch: '<S161>/Switch3' */
    rtb_Switch1_d2 = rtb_Add2;
  } else if (Gen2_ref_B->BusInput.tLvrt.bLvrtFlg) {
    /* Outputs for Atomic SubSystem: '<S45>/Inverse_Linearization4' */
    /* S-Function (sfix_look1_dyn): '<S165>/LCRScal_Lam_EOT1' incorporates:
     *  Switch: '<S161>/Switch1'
     *  Switch: '<S161>/Switch3'
     */
    /* Dynamic Look-Up Table Block: '<S165>/LCRScal_Lam_EOT1'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real32_Treal_T( &(rtb_LCRScal_Lam_EOT1_i),
      &Gen2_ref_B->BusInput3.bdcTv.rPosTv_Lin_x[0],
      Gen2_ref_B->BusInput.tLvrt.rTvPosFb,
      &Gen2_ref_B->BusInput3.bdcTv.rPosTv_Lin_y[0], 9U, inst);

    /* End of Outputs for SubSystem: '<S45>/Inverse_Linearization4' */

    /* Switch: '<S161>/Switch1' incorporates:
     *  Sum: '<S161>/Add3'
     *  Switch: '<S161>/Switch3'
     */
    rtb_Switch1_d2 = (rtb_LCRScal_Lam_EOT1_i -
                      Gen2_ref_B->Inverse_Linearization1.LCRScal_Lam_EOT1) -
      rtb_Product4;
  } else {
    /* Switch: '<S161>/Switch1' incorporates:
     *  Delay: '<S161>/Delay'
     *  Delay: '<S161>/Delay1'
     *  Product: '<S45>/Product3'
     *  Sum: '<S161>/Add1'
     *  Switch: '<S161>/Switch3'
     */
    rtb_Switch1_d2 = (rtb_Switch2_oou * FILT_IN +
                      Gen2_ref_DWork->Delay1_DSTATE_l) +
      Gen2_ref_DWork->Delay_DSTATE_gp;
  }

  /* End of Switch: '<S45>/Switch1' */

  /* DiscreteIntegrator: '<S45>/Discrete-Time Integrator1' */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator1_IC_LOAD != 0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_n = rtb_Switch1_d2;
  }

  if (rtb_LogicalOperator3_aa ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator1_PrevR_k != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_n = rtb_Switch1_d2;
  }

  rtb_Product1_bc = Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_n;

  /* Sum: '<S45>/Sum2' incorporates:
   *  DiscreteIntegrator: '<S45>/Discrete-Time Integrator1'
   */
  rtb_Switch2_oou = rtb_Product4 +
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_n;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S45>/Bus Creator'
   *  DataTypeConversion: '<S45>/Data Type Conversion1'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.BDC.tv.fb = (real32_T)rtb_Switch2_oou;

  /* Sum: '<S45>/Sum5' */
  rtb_Switch2_a = Gen2_ref_B->Inverse_Linearization1.LCRScal_Lam_EOT1 +
    rtb_Switch2_oou;

  /* MinMax: '<S45>/MinMax' */
  if ((Gen2_ref_B->BusInput3.bdcTv.rPos_min >= rtb_Switch_e) || rtIsNaN
      (rtb_Switch_e)) {
    delta_y = Gen2_ref_B->BusInput3.bdcTv.rPos_min;
  } else {
    delta_y = rtb_Switch_e;
  }

  /* End of MinMax: '<S45>/MinMax' */

  /* Outputs for Atomic SubSystem: '<S45>/Inverse_Linearization3' */
  Gen2_ref_Inverse_Linearization4(delta_y, &Gen2_ref_B->BusInput3,
    &Gen2_ref_B->Inverse_Linearization3, inst);

  /* End of Outputs for SubSystem: '<S45>/Inverse_Linearization3' */

  /* Outputs for Atomic SubSystem: '<S427>/TP_ActSat_TV' */
  /* Logic: '<S427>/Logical Operator2' incorporates:
   *  Bias: '<S427>/u+Ts1'
   *  Delay: '<S427>/Delay'
   *  Gain: '<S427>/Gain4'
   *  RelationalOperator: '<S427>/Relational Operator16'
   *  RelationalOperator: '<S427>/Relational Operator17'
   */
  Gen2_ref_TP_ActSat_CBV((rtb_RelationalOperator2_j &&
    Gen2_ref_B->BusInput3.LR.bP_LoadReject_Active &&
    (Gen2_ref_DWork->Delay_DSTATE[0] >=
     Gen2_ref_B->BusInput3.LR.rP_LR_Trig_ActSat_TV) && (rtb_Saturation >
    Gen2_ref_B->BusInput3.LR.rP_LR_Trig_ActSat_TV) &&
    Gen2_ref_B->BusInput3.LR.bLR_ActSat_TV), 0.001 *
    Gen2_ref_B->BusInput3.LR.rTi_LR_ActSat_TV + 0.01, &Gen2_ref_B->TP_ActSat_TV,
    &Gen2_ref_DWork->TP_ActSat_TV, inst);

  /* End of Outputs for SubSystem: '<S427>/TP_ActSat_TV' */

  /* Switch: '<S45>/Switch2' */
  if (Gen2_ref_B->TP_ActSat_TV.LogicalOperator1) {
    rtb_Switch2_by = Gen2_ref_B->Inverse_Linearization3.LCRScal_Lam_EOT1;
  } else {
    /* Outputs for Atomic SubSystem: '<S45>/Inverse_Linearization2' */
    Gen2_ref_Inverse_Linearization4(Gen2_ref_B->BusInput3.bdcTv.rPos_max,
      &Gen2_ref_B->BusInput3, &Gen2_ref_B->Inverse_Linearization2, inst);

    /* End of Outputs for SubSystem: '<S45>/Inverse_Linearization2' */

    /* Switch: '<S167>/Switch2' incorporates:
     *  RelationalOperator: '<S167>/LowerRelop1'
     *  RelationalOperator: '<S167>/UpperRelop'
     *  Switch: '<S167>/Switch'
     */
    if (rtb_Switch2_a > Gen2_ref_B->Inverse_Linearization2.LCRScal_Lam_EOT1) {
      rtb_Switch2_by = Gen2_ref_B->Inverse_Linearization2.LCRScal_Lam_EOT1;
    } else if (rtb_Switch2_a <
               Gen2_ref_B->Inverse_Linearization3.LCRScal_Lam_EOT1) {
      /* Switch: '<S167>/Switch' */
      rtb_Switch2_by = Gen2_ref_B->Inverse_Linearization3.LCRScal_Lam_EOT1;
    } else {
      rtb_Switch2_by = rtb_Switch2_a;
    }

    /* End of Switch: '<S167>/Switch2' */
  }

  /* End of Switch: '<S45>/Switch2' */

  /* Switch: '<S41>/Switch4' incorporates:
   *  Constant: '<S41>/Constant1'
   *  Gain: '<S41>/Pa2bar1'
   *  RelationalOperator: '<S41>/Relational Operator'
   *  RelationalOperator: '<S41>/Relational Operator1'
   *  Sum: '<S41>/Sum8'
   *  Sum: '<S41>/Sum9'
   *  UnitDelay: '<S41>/Unit Delay'
   */
  if (rtb_DataTypeConversion15 < 0.5 *
      Gen2_ref_B->BusInput3.SpeedCtrl.rOutOfNWindow + rtb_Switch13) {
    rtb_Switch4_j = false;
  } else {
    rtb_Switch4_j = ((rtb_DataTypeConversion15 >
                      Gen2_ref_B->BusInput3.SpeedCtrl.rOutOfNWindow +
                      rtb_Switch13) || Gen2_ref_DWork->UnitDelay_DSTATE_je);
  }

  /* End of Switch: '<S41>/Switch4' */

  /* Switch: '<S41>/Switch1' incorporates:
   *  Sum: '<S41>/Sum3'
   *  Sum: '<S41>/Sum5'
   */
  if (rtb_LogicalOperator) {
    /* S-Function (sfix_look1_dyn): '<S41>/Lookup2' */
    /* Dynamic Look-Up Table Block: '<S41>/Lookup2'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Lookup2), &Gen2_ref_B->BusInput3.bdcTv.rKi_Lup[0],
                         rtb_Pa2bar, &Gen2_ref_B->BusInput3.bdcMisc.rPr_Lup_in[0],
                         9U, inst);
    rtb_Switch2_oou = rtb_Lookup2 + Gen2_ref_B->BusInput3.bdcTv.rKi_grid_offset;
  } else {
    /* Logic: '<S41>/Logical Operator1' */
    rtb_LogicalOperator1_ix = (rtb_Switch4_j &&
      Gen2_ref_B->BusInput3.bdcTv.bKi_island_reject);

    /* Switch: '<S41>/Switch6' */
    for (i = 0; i < 10; i++) {
      if (rtb_LogicalOperator1_ix) {
        rtb_Switch6_n[i] = Gen2_ref_B->BusInput3.bdcTv.rKi_island_reject_Lup[i];
      } else {
        rtb_Switch6_n[i] = Gen2_ref_B->BusInput3.bdcTv.rKi_island_Lup[i];
      }
    }

    /* End of Switch: '<S41>/Switch6' */

    /* S-Function (sfix_look1_dyn): '<S41>/Lookup3' */
    /* Dynamic Look-Up Table Block: '<S41>/Lookup3'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Lookup3), &rtb_Switch6_n[0], rtb_Pa2bar,
                         &Gen2_ref_B->BusInput3.bdcMisc.rPr_Lup_in[0], 9U, inst);
    rtb_Switch2_oou = rtb_Lookup3 +
      Gen2_ref_B->BusInput3.bdcTv.rKi_island_offset;
  }

  /* End of Switch: '<S41>/Switch1' */

  /* Switch: '<S129>/Switch2' incorporates:
   *  RelationalOperator: '<S129>/LowerRelop1'
   *  RelationalOperator: '<S129>/UpperRelop'
   *  Switch: '<S129>/Switch'
   */
  if (rtb_Switch2_oou > Gen2_ref_B->BusInput3.bdcMisc.rKiMax) {
    rtb_Switch2_j0 = Gen2_ref_B->BusInput3.bdcMisc.rKiMax;
  } else if (rtb_Switch2_oou < Gen2_ref_B->BusInput3.bdcMisc.rKiMin) {
    /* Switch: '<S129>/Switch' */
    rtb_Switch2_j0 = Gen2_ref_B->BusInput3.bdcMisc.rKiMin;
  } else {
    rtb_Switch2_j0 = rtb_Switch2_oou;
  }

  /* End of Switch: '<S129>/Switch2' */

  /* Switch: '<S45>/Switch5' incorporates:
   *  Constant: '<S45>/Constant3'
   *  Product: '<S45>/Divide'
   *  RelationalOperator: '<S45>/Relational Operator'
   */
  if (Gen2_ref_B->BusInput3.bdcTv.rKaw <= 0.0) {
    /* Saturate: '<S45>/Saturation' */
    if (FILT_IN <= 0.1) {
      FILT_IN = 0.1;
    }

    /* End of Saturate: '<S45>/Saturation' */
    rtb_Switch2_oou = rtb_Switch2_j0 / FILT_IN;
  } else {
    rtb_Switch2_oou = Gen2_ref_B->BusInput3.bdcTv.rKaw;
  }

  /* End of Switch: '<S45>/Switch5' */

  /* Product: '<S45>/Product2' incorporates:
   *  Sum: '<S45>/Sum1'
   */
  rtb_Switch2_oou *= rtb_Switch2_by - rtb_Switch2_a;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S45>/Bus Creator'
   *  DataTypeConversion: '<S45>/Data Type Conversion5'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.BDC.tv.ff_unsat = (real32_T)rtb_Product4_d;

  /* MATLAB Function: '<S25>/MATLAB Function' incorporates:
   *  Gain: '<S25>/Gain'
   *  Sum: '<S25>/Sum'
   */
  Gen2_ref_MATLABFunction(1.0E-5 * Gen2_ref_B->p2s_filt.Switch,
    Gen2_ref_B->BusInput3.bdcMisc.rPrSwitchFFmethod,
    Gen2_ref_B->BusInput3.bdcMisc.rPrSwitchFFmethod +
    Gen2_ref_B->BusInput3.bdcMisc.rPrSwitchFFmethod_hys,
    &Gen2_ref_B->sf_MATLABFunction_e, &Gen2_ref_DWork->sf_MATLABFunction_e, inst);

  /* MultiPortSwitch: '<S25>/Multiport Switch' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  if ((int32_T)Gen2_ref_B->sf_MATLABFunction_e.y == 1) {
    rtb_MultiportSwitch = rtb_Switch2_jf;
  } else {
    rtb_MultiportSwitch = rtb_Switch2_lu;
  }

  /* End of MultiPortSwitch: '<S25>/Multiport Switch' */

  /* Gain: '<S1>/Gain' */
  FILT_IN = 100000.0 * rtb_MultiportSwitch;

  /* MATLAB Function: '<S27>/engine massflow' incorporates:
   *  Gain: '<S27>/rpm2rad1'
   */
  Gen2_ref_enginemassflow(FILT_IN, Gen2_ref_B->T2s_filt.Switch,
    0.10471975511965977 * rtb_Switch13, rtb_etaVolConst_lt,
    Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng, &Gen2_ref_B->sf_enginemassflow, inst);

  /* Switch: '<S27>/Switch' */
  if (Gen2_ref_B->BusInput3.bdcCbv.bFF_overspeed) {
    rtb_Switch2_a = rtb_DataTypeConversion15;
  } else {
    rtb_Switch2_a = rtb_Switch13;
  }

  /* End of Switch: '<S27>/Switch' */

  /* Switch: '<S114>/Switch2' incorporates:
   *  RelationalOperator: '<S114>/LowerRelop1'
   */
  if (!(rtb_DataTypeConversion15 > rtb_Switch2_a)) {
    /* Switch: '<S114>/Switch' incorporates:
     *  Constant: '<S27>/Constant4'
     *  RelationalOperator: '<S114>/UpperRelop'
     */
    if (rtb_DataTypeConversion15 < 1.0) {
      rtb_Switch2_a = 1.0;
    } else {
      rtb_Switch2_a = rtb_DataTypeConversion15;
    }

    /* End of Switch: '<S114>/Switch' */
  }

  /* End of Switch: '<S114>/Switch2' */

  /* MATLAB Function: '<S27>/engine massflow1' */
  u0 = 287.15 * Gen2_ref_B->T2s_filt.Switch;

  /* Switch: '<S27>/Switch1' incorporates:
   *  Saturate: '<S27>/Saturation4'
   */
  if (Gen2_ref_B->BusInput3.bdcCbv.bFF_low_boost) {
    delta_y = Gen2_ref_B->p2s_filt.Switch;
  } else if (Gen2_ref_B->p2s_filt.Switch <= 100000.0) {
    /* Saturate: '<S27>/Saturation4' */
    delta_y = 100000.0;
  } else {
    delta_y = Gen2_ref_B->p2s_filt.Switch;
  }

  /* End of Switch: '<S27>/Switch1' */

  /* MATLAB Function: '<S27>/engine massflow1' incorporates:
   *  Gain: '<S27>/rpm2rad'
   *  Product: '<S13>/Product1'
   */
  if (!(u0 >= 1.0)) {
    u0 = 1.0;
  }

  rtb_dm_e_tmp = rtb_etaVolConst_lt * Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng;
  rtb_dm_e = rtb_dm_e_tmp * delta_y / u0 * (0.10471975511965977 * rtb_Switch2_a)
    / 2.0 / 6.2831853071795862;

  /* Gain: '<S27>/rpm2rad2' */
  rtb_Switch2_a = 1.0E-5 * FILT_IN;

  /* S-Function (sfix_look1_dyn): '<S27>/Lookup Table Dynamic1' */
  /* Dynamic Look-Up Table Block: '<S27>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Divide2_f),
                       &Gen2_ref_B->BusInput3.bdcCbv.rRefCBVres_y[0],
                       rtb_Switch2_a, &Gen2_ref_B->
                       BusInput3.bdcCbv.rRefCBVres_x[0], 4U, inst);

  /* UnitDelay: '<S1>/Unit Delay' */
  FILT_IN = Gen2_ref_DWork->UnitDelay_DSTATE_i;

  /* Sum: '<S133>/Sum' */
  rtb_Switch2_a = rtb_Switch1_kk;

  /* RelationalOperator: '<S133>/Relational Operator' */
  rtb_LogicalOperator1_ix = (Gen2_ref_B->BusInput3.LR.rN_trig_cbv_lim <=
    rtb_Switch2_a);

  /* DiscreteIntegrator: '<S133>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator1_ix ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_no != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_j = 0.0;
  }

  /* RelationalOperator: '<S133>/Relational Operator1' incorporates:
   *  DiscreteIntegrator: '<S133>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator1_j = (Gen2_ref_B->BusInput3.LR.iNum_steady_state >
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_j);

  /* Switch: '<S133>/Switch3' incorporates:
   *  Logic: '<S133>/Logical Operator4'
   */
  if (rtb_RelationalOperator1_j &&
      Gen2_ref_B->BusInput3.LR.bSwitch_Surge_CBV_Min) {
    /* S-Function (sfix_look1_dyn): '<S133>/Surge protection depending  on throttle position' */
    /* Dynamic Look-Up Table Block: '<S133>/Surge protection depending  on throttle position'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Surgeprotectiondependingont),
                         &Gen2_ref_B->BusInput3.LR.rCBV_lim_byTV_Lup_y[0],
                         FILT_IN, &Gen2_ref_B->BusInput3.LR.rCBV_lim_byTV_Lup_x
                         [0], 4U, inst);
    FILT_IN = rtb_Surgeprotectiondependingont;
  } else {
    FILT_IN = Gen2_ref_B->BusInput3.bdcCbv.rPos_min;
  }

  /* End of Switch: '<S133>/Switch3' */

  /* Switch: '<S137>/Switch2' incorporates:
   *  RelationalOperator: '<S137>/LowerRelop1'
   *  RelationalOperator: '<S137>/UpperRelop'
   *  Switch: '<S137>/Switch'
   */
  if (FILT_IN > Gen2_ref_B->BusInput3.bdcCbv.rPos_max) {
    rtb_Switch2_a = Gen2_ref_B->BusInput3.bdcCbv.rPos_max;
  } else if (FILT_IN < Gen2_ref_B->BusInput3.bdcCbv.rPos_min) {
    /* Switch: '<S137>/Switch' */
    rtb_Switch2_a = Gen2_ref_B->BusInput3.bdcCbv.rPos_min;
  } else {
    rtb_Switch2_a = FILT_IN;
  }

  /* End of Switch: '<S137>/Switch2' */

  /* Switch: '<S1>/CBV Min' */
  if (rtb_LogicalOperator) {
    rtb_Switch1_kk = Gen2_ref_B->BusInput3.bdcCbv.rPos_min;
  } else {
    rtb_Switch1_kk = rtb_Switch2_a;
  }

  /* End of Switch: '<S1>/CBV Min' */

  /* Outputs for Atomic SubSystem: '<S27>/cbv tracking1' */
  /* Abs: '<S116>/Abs' */
  rtb_Abs_n = fabs(Gen2_ref_B->BusInput3.bdcCbv.rMaxErrCBVtracking);

  /* Logic: '<S116>/Logical Operator' incorporates:
   *  Logic: '<S116>/Logical Operator2'
   */
  rtb_LogicalOperator5_p = !Gen2_ref_B->BusInput3.bdcCbv.bFFonly_2nd_CBV;

  /* Logic: '<S116>/Logical Operator5' incorporates:
   *  Constant: '<S121>/Constant'
   *  Constant: '<S122>/Constant'
   *  DataTypeConversion: '<S1>/Data Type Conversion14'
   *  Logic: '<S116>/Logical Operator'
   *  Logic: '<S116>/Logical Operator1'
   *  Logic: '<S116>/Logical Operator2'
   *  Logic: '<S116>/Logical Operator3'
   *  Logic: '<S116>/Logical Operator4'
   *  Logic: '<S116>/Logical Operator6'
   *  Logic: '<S1>/Logical Operator5'
   *  RelationalOperator: '<S121>/Compare'
   *  RelationalOperator: '<S122>/Compare'
   */
  rtb_LogicalOperator5_p = ((((!(Gen2_ref_B->BusInput3.eng.rNum_CBV > 1.5)) ||
    rtb_LogicalOperator5_p) && ((!(Gen2_ref_B->BusInput3.eng.rNum_CBV > 2.5)) ||
    (rtb_LogicalOperator5_p && (!Gen2_ref_B->BusInput3.bdcCbv.bFFonly_3rd_CBV))))
    || (!Gen2_ref_B->BusInput3.bdcCbv.bCBVtracking2nd3rdCBV) || (!(rtb_Sum1_dh
    != 0.0)));

  /* DiscreteIntegrator: '<S116>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator5_p || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_lh
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_iq = 0.0;
  }

  r = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_iq;

  /* End of DiscreteIntegrator: '<S116>/Discrete-Time Integrator' */

  /* Switch: '<S116>/Switch8' incorporates:
   *  Constant: '<S116>/max_PR1'
   */
  if (Gen2_ref_B->TON2.LogicalOperator3) {
    /* Sum: '<S116>/Sum' incorporates:
     *  UnitDelay: '<S1>/Unit Delay5'
     */
    rtb_Sum_mf = Gen2_ref_DWork->UnitDelay5_DSTATE -
      Gen2_ref_B->BusInput3.bdcCbv.rRefCBVtracking;

    /* Switch: '<S116>/Switch4' incorporates:
     *  Constant: '<S116>/max_PR5'
     *  Constant: '<S116>/max_PR6'
     *  RelationalOperator: '<S116>/Relational Operator3'
     *  Sum: '<S116>/Sum5'
     *  UnitDelay: '<S27>/Unit Delay6'
     */
    if (Gen2_ref_DWork->UnitDelay6_DSTATE >
        Gen2_ref_B->BusInput3.bdcCbv.rPos_max - 0.001) {
      FILT_IN = 0.0;
    } else {
      FILT_IN = rtb_Abs_n;
    }

    /* End of Switch: '<S116>/Switch4' */

    /* Switch: '<S123>/Switch2' incorporates:
     *  RelationalOperator: '<S123>/LowerRelop1'
     */
    if (!(rtb_Sum_mf > FILT_IN)) {
      /* Switch: '<S116>/Switch5' incorporates:
       *  Constant: '<S116>/max_PR5'
       *  Constant: '<S116>/max_PR6'
       *  Gain: '<S116>/Gain2'
       *  RelationalOperator: '<S116>/Relational Operator2'
       *  Sum: '<S116>/Sum4'
       *  UnitDelay: '<S27>/Unit Delay6'
       */
      if (Gen2_ref_DWork->UnitDelay6_DSTATE < rtb_Switch1_kk + 0.001) {
        FILT_IN = 0.0;
      } else {
        FILT_IN = -rtb_Abs_n;
      }

      /* End of Switch: '<S116>/Switch5' */

      /* Switch: '<S123>/Switch' incorporates:
       *  RelationalOperator: '<S123>/UpperRelop'
       */
      if (!(rtb_Sum_mf < FILT_IN)) {
        FILT_IN = rtb_Sum_mf;
      }

      /* End of Switch: '<S123>/Switch' */
    }

    /* End of Switch: '<S123>/Switch2' */
  } else {
    FILT_IN = 0.0;
  }

  /* End of Switch: '<S116>/Switch8' */

  /* Update for DiscreteIntegrator: '<S116>/Discrete-Time Integrator' incorporates:
   *  Product: '<S116>/Divide'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_iq +=
    Gen2_ref_B->BusInput3.bdcCbv.rKiCBVtracking * FILT_IN * 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_lh = (int8_T)
    rtb_LogicalOperator5_p;

  /* End of Outputs for SubSystem: '<S27>/cbv tracking1' */

  /* Sum: '<S27>/Sum3' incorporates:
   *  Constant: '<S27>/Constant'
   *  Sum: '<S27>/Sum5'
   */
  FILT_IN = (rtb_Divide2_f + r) + 1.0;

  /* MultiPortSwitch: '<S25>/Multiport Switch1' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  if ((int32_T)Gen2_ref_B->sf_MATLABFunction_e.y == 1) {
    rtb_Divide2_f = Gen2_ref_B->Filter1.Switch1;
  } else {
    rtb_Divide2_f = Gen2_ref_B->Filter4.Switch1;
  }

  /* End of MultiPortSwitch: '<S25>/Multiport Switch1' */

  /* Gain: '<S1>/Gain1' */
  r = 100000.0 * rtb_Divide2_f;

  /* DataTypeConversion: '<S117>/Data Type Conversion' */
  rtb_Divide2_f = Gen2_ref_B->BusInput3.bdcCbv.bDynFFcbv_ON;

  /* Sum: '<S117>/Sum3' incorporates:
   *  Sum: '<S175>/Sum3'
   */
  rtb_Saturation_cx = Gen2_ref_B->BusInput3.eng.rVol_IC_HP +
    Gen2_ref_B->BusInput3.eng.rVol_IC_LP;
  rtb_Sum_mf = rtb_Saturation_cx;

  /* Product: '<S117>/Divide6' incorporates:
   *  Constant: '<S117>/R_air'
   *  Product: '<S117>/Divide7'
   */
  rtb_Abs_n = rtb_Sum_mf / (287.15 * Gen2_ref_B->T2s_filt.Switch);

  /* Saturate: '<S27>/Saturation5' */
  if (Gen2_ref_B->BusInput3.eng.rNum_CBV > 10.0) {
    rtb_Sum_mf = 10.0;
  } else if (Gen2_ref_B->BusInput3.eng.rNum_CBV < 1.0) {
    rtb_Sum_mf = 1.0;
  } else {
    rtb_Sum_mf = Gen2_ref_B->BusInput3.eng.rNum_CBV;
  }

  /* End of Saturate: '<S27>/Saturation5' */

  /* Product: '<S27>/Divide1' incorporates:
   *  Product: '<S117>/Divide8'
   *  Product: '<S27>/Product'
   *  Sum: '<S27>/Sum1'
   *  Sum: '<S27>/Sum2'
   */
  rtb_Sum_mf = ((rtb_dm_e * FILT_IN - r * rtb_Divide2_f * rtb_Abs_n) -
                Gen2_ref_B->sf_enginemassflow.dm_e) / rtb_Sum_mf;

  /* Saturate: '<S27>/Saturation' */
  if (rtb_Sum_mf <= 0.0) {
    rtb_Abs_n = 0.0;
  } else {
    rtb_Abs_n = rtb_Sum_mf;
  }

  /* End of Saturate: '<S27>/Saturation' */

  /* MultiPortSwitch: '<S25>/Multiport Switch2' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  if ((int32_T)Gen2_ref_B->sf_MATLABFunction_e.y == 1) {
    FILT_IN = rtb_Switch2_h1;
  } else {
    FILT_IN = rtb_BusCreator1_ref_P2_FF;
  }

  /* End of MultiPortSwitch: '<S25>/Multiport Switch2' */

  /* Switch: '<S106>/Switch2' incorporates:
   *  Constant: '<S25>/Constant'
   *  RelationalOperator: '<S106>/LowerRelop1'
   */
  if (FILT_IN > 1.0E+6) {
    rtb_Sum_mf = 1.0E+6;
  } else {
    /* Gain: '<S25>/Gain1' */
    r = rtb_kW2W1_h;

    /* S-Function (sfix_look1_dyn): '<S25>/Lookup Table Dynamic' */
    /* Dynamic Look-Up Table Block: '<S25>/Lookup Table Dynamic'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Sum1_lo),
                         &Gen2_ref_B->BusInput3.traj.rPrR_deltaP_TV_y[0], r,
                         &rtb_Gain1_eu[0], 4U, inst);

    /* Sum: '<S25>/Sum1' incorporates:
     *  Product: '<S25>/Product2'
     */
    rtb_Sum1_lo = rtb_Sum1_lo * rtb_Saturation1_i + rtb_MultiportSwitch;

    /* Switch: '<S106>/Switch' incorporates:
     *  RelationalOperator: '<S106>/UpperRelop'
     */
    if (FILT_IN < rtb_Sum1_lo) {
      rtb_Sum_mf = rtb_Sum1_lo;
    } else {
      rtb_Sum_mf = FILT_IN;
    }

    /* End of Switch: '<S106>/Switch' */
  }

  /* Gain: '<S1>/Gain2' */
  rtb_Sum1_lo = 100000.0 * rtb_Sum_mf;

  /* MATLAB Function: '<S27>/MATLAB Function1' incorporates:
   *  Constant: '<S1>/Constant2'
   *  Constant: '<S27>/Constant3'
   *  Product: '<S27>/Product1'
   */
  if (rtb_Sum1_lo >= 100000.0) {
    r = 100000.0 / rtb_Sum1_lo;
    if (1.0E-6 >= r) {
      r = 1.0E-6;
    }

    if (1.0 / r <= 1.8929291587378541) {
      u0 = 0.78539816339744828 * Gen2_ref_B->BusInput3.bdcCbv.rDref *
        Gen2_ref_B->BusInput3.bdcCbv.rDref * rtb_Sum1_lo / sqrt(287.15 *
        Gen2_ref_B->T2s_filt.Switch) * sqrt((rt_powd_snf(r, 1.4285714285714286, inst)
        - rt_powd_snf(r, 1.7142857142857144, inst)) * 7.0000000000000009);
      if (!(u0 >= 1.0E-6)) {
        u0 = 1.0E-6;
      }

      rtb_Sum1_lo = rtb_Abs_n / u0;
    } else {
      u0 = 0.78539816339744828 * Gen2_ref_B->BusInput3.bdcCbv.rDref *
        Gen2_ref_B->BusInput3.bdcCbv.rDref * rtb_Sum1_lo / sqrt(287.15 *
        Gen2_ref_B->T2s_filt.Switch) * 0.6847314563772704;
      if (!(u0 >= 1.0E-6)) {
        u0 = 1.0E-6;
      }

      rtb_Sum1_lo = rtb_Abs_n / u0;
    }
  } else {
    rtb_Sum1_lo = 0.0;
  }

  /* End of MATLAB Function: '<S27>/MATLAB Function1' */

  /* Saturate: '<S27>/Saturation1' */
  if (rtb_Sum1_lo > 1.0) {
    rtb_Sum_mf = 1.0;
  } else if (rtb_Sum1_lo < 0.0) {
    rtb_Sum_mf = 0.0;
  } else {
    rtb_Sum_mf = rtb_Sum1_lo;
  }

  /* End of Saturate: '<S27>/Saturation1' */

  /* S-Function (sfix_look1_dyn): '<S27>/Lookup Table Dynamic' */
  /* Dynamic Look-Up Table Block: '<S27>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Divide2_f),
                       &Gen2_ref_B->BusInput3.bdcCbv.rCd_vect_x[0], rtb_Sum_mf,
                       &Gen2_ref_B->BusInput3.bdcCbv.rCd_vect_y[0], 10U, inst);

  /* MinMax: '<S27>/MinMax' */
  r = Gen2_ref_B->BusInput3.bdcCbv.rCd_vect_x[0];
  for (k = 0; k < 10; k++) {
    u1 = Gen2_ref_B->BusInput3.bdcCbv.rCd_vect_x[k + 1];
    if ((!(r >= u1)) && (!rtIsNaN(u1))) {
      r = u1;
    }
  }

  /* End of MinMax: '<S27>/MinMax' */

  /* Abs: '<S112>/Abs' */
  FILT_IN = fabs(r);

  /* Switch: '<S112>/Switch' incorporates:
   *  Constant: '<S112>/Constant2'
   *  RelationalOperator: '<S112>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= FILT_IN) {
    r = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S112>/Switch' */

  /* Product: '<S27>/Divide' */
  delta_y = rtb_Divide2_f / r;
  for (i = 0; i < 5; i++) {
    /* Gain: '<S27>/Gain1' */
    rtb_Gain1_eu[i] = 0.01 * Gen2_ref_B->BusInput3.bdcCbv.rRefCBVconvert_x[i];

    /* Gain: '<S27>/Gain2' */
    rtb_Gain2_k[i] = 0.01 * Gen2_ref_B->BusInput3.bdcCbv.rRefCBVconvert_y[i];
  }

  /* S-Function (sfix_look1_dyn): '<S27>/Lookup Table Dynamic2' */
  /* Dynamic Look-Up Table Block: '<S27>/Lookup Table Dynamic2'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(FILT_IN), &rtb_Gain2_k[0], delta_y, &rtb_Gain1_eu[0],
                       4U, inst);

  /* Saturate: '<S27>/Saturation3' */
  if (Gen2_ref_B->BusInput3.eng.rNum_CBV > 1.0) {
    r = 1.0;
  } else if (Gen2_ref_B->BusInput3.eng.rNum_CBV < 0.0) {
    r = 0.0;
  } else {
    r = Gen2_ref_B->BusInput3.eng.rNum_CBV;
  }

  /* End of Saturate: '<S27>/Saturation3' */

  /* Product: '<S27>/Divide2' */
  rtb_Divide2_f = FILT_IN * r;

  /* Switch: '<S115>/Switch2' incorporates:
   *  RelationalOperator: '<S115>/LowerRelop1'
   *  RelationalOperator: '<S115>/UpperRelop'
   *  Switch: '<S115>/Switch'
   */
  if (rtb_Divide2_f > Gen2_ref_B->BusInput3.bdcCbv.rPos_max) {
    rtb_Sum1_lo = Gen2_ref_B->BusInput3.bdcCbv.rPos_max;
  } else if (rtb_Divide2_f < rtb_Switch1_kk) {
    /* Switch: '<S115>/Switch' */
    rtb_Sum1_lo = rtb_Switch1_kk;
  } else {
    rtb_Sum1_lo = rtb_Divide2_f;
  }

  /* End of Switch: '<S115>/Switch2' */

  /* Switch: '<S26>/Switch4' incorporates:
   *  Constant: '<S26>/Constant1'
   */
  if (Gen2_ref_B->BusInput3.bdcCbv.bActive_ff) {
    FILT_IN = rtb_Sum1_lo;
  } else {
    FILT_IN = 0.0;
  }

  /* End of Switch: '<S26>/Switch4' */

  /* Saturate: '<S26>/Saturation1' */
  if (FILT_IN > 1.0) {
    rtb_Saturation1_i = 1.0;
  } else if (FILT_IN < 0.0) {
    rtb_Saturation1_i = 0.0;
  } else {
    rtb_Saturation1_i = FILT_IN;
  }

  /* End of Saturate: '<S26>/Saturation1' */

  /* Switch: '<S41>/Switch2' incorporates:
   *  Sum: '<S41>/Sum'
   *  Sum: '<S41>/Sum7'
   */
  if (rtb_LogicalOperator) {
    /* S-Function (sfix_look1_dyn): '<S41>/Lookup4' */
    /* Dynamic Look-Up Table Block: '<S41>/Lookup4'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Lookup4), &Gen2_ref_B->BusInput3.bdcCbv.rKp_Lup
                         [0], rtb_Pa2bar,
                         &Gen2_ref_B->BusInput3.bdcMisc.rPr_Lup_in[0], 9U, inst);
    FILT_IN = rtb_Lookup4 + Gen2_ref_B->BusInput3.bdcCbv.rKp_grid_offset;
  } else {
    /* S-Function (sfix_look1_dyn): '<S41>/Lookup5' */
    /* Dynamic Look-Up Table Block: '<S41>/Lookup5'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Lookup5),
                         &Gen2_ref_B->BusInput3.bdcCbv.rKp_island_Lup[0],
                         rtb_Pa2bar, &Gen2_ref_B->BusInput3.bdcMisc.rPr_Lup_in[0],
                         9U, inst);
    FILT_IN = rtb_Lookup5 + Gen2_ref_B->BusInput3.bdcCbv.rKp_island_offset;
  }

  /* End of Switch: '<S41>/Switch2' */

  /* S-Function (sfix_look1_dyn): '<S41>/Lookup9' */
  /* Dynamic Look-Up Table Block: '<S41>/Lookup9'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(r), &Gen2_ref_B->BusInput3.bdcCbv.rGainMultRej_y[0],
                       rtb_DataTypeConversion15,
                       &Gen2_ref_B->BusInput3.bdcCbv.rGainMultRej_x[0], 4U, inst);

  /* Product: '<S41>/Product1' */
  rtb_Divide2_f = FILT_IN * r;

  /* Switch: '<S130>/Switch2' incorporates:
   *  RelationalOperator: '<S130>/LowerRelop1'
   *  RelationalOperator: '<S130>/UpperRelop'
   *  Switch: '<S130>/Switch'
   */
  if (rtb_Divide2_f > Gen2_ref_B->BusInput3.bdcMisc.rKpMax) {
    rtb_Divide2_f = Gen2_ref_B->BusInput3.bdcMisc.rKpMax;
  } else if (rtb_Divide2_f < Gen2_ref_B->BusInput3.bdcMisc.rKpMin) {
    /* Switch: '<S130>/Switch' */
    rtb_Divide2_f = Gen2_ref_B->BusInput3.bdcMisc.rKpMin;
  }

  /* End of Switch: '<S130>/Switch2' */

  /* Logic: '<S1>/Logical Operator3' incorporates:
   *  DataTypeConversion: '<S1>/Data Type Conversion13'
   */
  rtb_LogicalOperator5_p = !(rtb_Sum1_dh != 0.0);

  /* MATLAB Function: '<S26>/fb_err' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   *  SignalConversion generated from: '<S110>/ SFunction '
   */
  if ((!Gen2_ref_DWork->err_1_not_empty_d) || rtb_LogicalOperator5_p) {
    Gen2_ref_DWork->err_1_a = 0.0;
    Gen2_ref_DWork->err_1_not_empty_d = true;
  }

  err = rtb_Divide2 * rtb_Divide1_fn - rtb_BusCreator1_ref_P2_FB_CBV;
  FILT_IN = Gen2_ref_DWork->err_1_a - err;
  Gen2_ref_DWork->err_1_a = err;

  /* Product: '<S26>/Product' incorporates:
   *  MATLAB Function: '<S26>/fb_err'
   */
  rtb_up = rtb_Divide2_f * err;

  /* Logic: '<S26>/Logical Operator1' incorporates:
   *  Logic: '<S26>/Logical Operator2'
   *  RelationalOperator: '<S107>/FixPt Relational Operator'
   *  UnitDelay: '<S107>/Delay Input1'
   */
  rtb_bCBV_min = ((Gen2_ref_B->BusInput3.bdcCbv.bActive_ff !=
                   Gen2_ref_DWork->DelayInput1_DSTATE_fv) &&
                  ((!rtb_LogicalOperator5_p) && rtb_LogicalOperator_b));

  /* Logic: '<S26>/Logical Operator' incorporates:
   *  MATLAB Function: '<S26>/fb_err'
   */
  rtb_LogicalOperator_b = (Gen2_ref_B->BusInput.tLvrt.bLvrtFlg ||
    rtb_LogicalOperator5_p || rtb_bCBV_min);

  /* Delay: '<S26>/Delay' */
  if (Gen2_ref_DWork->icLoad_kq) {
    Gen2_ref_DWork->Delay_DSTATE_hq = rtb_Saturation1_i;
  }

  /* Sum: '<S111>/Add2' */
  rtb_Add2_h = (Gen2_ref_B->BusInput3.bdcCbv.rPos_Start - rtb_Saturation1_i) -
    rtb_up;

  /* Delay: '<S111>/Delay' */
  if ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_kk == 1) != (int32_T)
        rtb_LogicalOperator5_p) && (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_kk
        != 3)) || rtb_LogicalOperator5_p) {
    Gen2_ref_DWork->Delay_DSTATE_ow = 0.0;
  }

  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_kk = rtb_LogicalOperator5_p;

  /* Switch: '<S26>/Switch1' incorporates:
   *  Delay: '<S111>/Delay2'
   *  Delay: '<S26>/Delay'
   *  Sum: '<S26>/Sum'
   *  Sum: '<S26>/Sum3'
   *  Switch: '<S111>/Switch3'
   *  UnitDelay: '<S26>/Unit Delay1'
   */
  if (rtb_bCBV_min) {
    rtb_Add2_h = (Gen2_ref_DWork->Delay_DSTATE_hq - rtb_Saturation1_i) +
      Gen2_ref_DWork->UnitDelay1_DSTATE_c;
  } else if (!Gen2_ref_DWork->Delay2_DSTATE_k) {
    /* Switch: '<S111>/Switch1' incorporates:
     *  Delay: '<S111>/Delay'
     *  Product: '<S26>/Product3'
     *  Sum: '<S111>/Add1'
     *  Sum: '<S111>/Add3'
     *  Switch: '<S111>/Switch'
     *  Switch: '<S111>/Switch3'
     */
    if (Gen2_ref_B->BusInput.tLvrt.bLvrtFlg) {
      rtb_Add2_h = (Gen2_ref_B->BusInput.tLvrt.rCbvPosFb - rtb_Saturation1_i) -
        rtb_up;
    } else {
      if (!rtb_LogicalOperator5_p) {
        /* Switch: '<S111>/Switch' incorporates:
         *  Constant: '<S111>/Constant'
         */
        rtb_Add2_h = 0.0;
      }

      rtb_Add2_h = (FILT_IN * rtb_Divide2_f + rtb_Add2_h) +
        Gen2_ref_DWork->Delay_DSTATE_ow;
    }

    /* End of Switch: '<S111>/Switch1' */
  }

  /* End of Switch: '<S26>/Switch1' */

  /* DiscreteIntegrator: '<S26>/Discrete-Time Integrator' */
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_l != 0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ja = rtb_Add2_h;
  }

  if (rtb_LogicalOperator_b || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_c
       != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ja = rtb_Add2_h;
  }

  rtb_MultiportSwitch = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ja;

  /* Switch: '<S26>/Switch6' incorporates:
   *  Constant: '<S26>/Constant5'
   *  DiscreteIntegrator: '<S26>/Discrete-Time Integrator'
   *  Sum: '<S26>/Sum1'
   */
  if (Gen2_ref_B->BusInput3.bdcCbv.bFFonly) {
    FILT_IN = 0.0;
  } else {
    FILT_IN = rtb_up + Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ja;
  }

  /* End of Switch: '<S26>/Switch6' */

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S26>/Bus Creator1'
   *  DataTypeConversion: '<S26>/Data Type Conversion1'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.BDC.cbv.fb_cbv = (real32_T)FILT_IN;

  /* Sum: '<S26>/Sum5' */
  r = rtb_Saturation1_i + FILT_IN;

  /* Gain: '<S427>/Gain5' */
  FILT_IN = 0.001 * Gen2_ref_B->BusInput3.LR.rTi_LR_ActSat_CBV;

  /* Outputs for Atomic SubSystem: '<S427>/TP_ActSat_CBV' */
  /* Logic: '<S427>/Logical Operator1' incorporates:
   *  Bias: '<S427>/ u+Ts6'
   *  Delay: '<S427>/Delay'
   *  RelationalOperator: '<S427>/Relational Operator15'
   *  RelationalOperator: '<S427>/Relational Operator18'
   */
  Gen2_ref_TP_ActSat_CBV((rtb_RelationalOperator2_j &&
    Gen2_ref_B->BusInput3.LR.bP_LoadReject_Active &&
    (Gen2_ref_DWork->Delay_DSTATE[0] >=
     Gen2_ref_B->BusInput3.LR.rP_LR_Trig_ActSat_CBV) && (rtb_Saturation >
    Gen2_ref_B->BusInput3.LR.rP_LR_Trig_ActSat_CBV) &&
    Gen2_ref_B->BusInput3.LR.bLR_ActSat_CBV), FILT_IN + 0.01,
    &Gen2_ref_B->TP_ActSat_CBV, &Gen2_ref_DWork->TP_ActSat_CBV, inst);

  /* End of Outputs for SubSystem: '<S427>/TP_ActSat_CBV' */

  /* Switch: '<S26>/Switch2' incorporates:
   *  MinMax: '<S26>/MinMax'
   *  RelationalOperator: '<S108>/LowerRelop1'
   *  Switch: '<S108>/Switch2'
   */
  if (Gen2_ref_B->TP_ActSat_CBV.LogicalOperator1) {
    rtb_Switch1_kk = Gen2_ref_B->BusInput3.bdcCbv.rPos_max;
  } else if (r > Gen2_ref_B->BusInput3.bdcCbv.rPos_max) {
    /* Switch: '<S108>/Switch2' */
    rtb_Switch1_kk = Gen2_ref_B->BusInput3.bdcCbv.rPos_max;
  } else {
    if ((rtb_Switch1_kk >= Gen2_ref_B->BusInput3.bdcCbv.rPos_min) || rtIsNaN
        (Gen2_ref_B->BusInput3.bdcCbv.rPos_min)) {
      /* MinMax: '<S26>/MinMax' incorporates:
       *  Switch: '<S108>/Switch2'
       */
      FILT_IN = rtb_Switch1_kk;
    } else {
      /* MinMax: '<S26>/MinMax' incorporates:
       *  Switch: '<S108>/Switch2'
       */
      FILT_IN = Gen2_ref_B->BusInput3.bdcCbv.rPos_min;
    }

    /* Switch: '<S108>/Switch' incorporates:
     *  RelationalOperator: '<S108>/UpperRelop'
     *  Switch: '<S108>/Switch2'
     */
    if (r < FILT_IN) {
      rtb_Switch1_kk = FILT_IN;
    } else {
      rtb_Switch1_kk = r;
    }

    /* End of Switch: '<S108>/Switch' */
  }

  /* End of Switch: '<S26>/Switch2' */

  /* Switch: '<S41>/Switch3' incorporates:
   *  Sum: '<S41>/Sum1'
   *  Sum: '<S41>/Sum6'
   */
  if (rtb_LogicalOperator) {
    /* S-Function (sfix_look1_dyn): '<S41>/Lookup6' */
    /* Dynamic Look-Up Table Block: '<S41>/Lookup6'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Lookup6), &Gen2_ref_B->BusInput3.bdcCbv.rKi_Lup
                         [0], rtb_Pa2bar,
                         &Gen2_ref_B->BusInput3.bdcMisc.rPr_Lup_in[0], 9U, inst);
    FILT_IN = rtb_Lookup6 + Gen2_ref_B->BusInput3.bdcCbv.rKi_grid_offset;
  } else {
    /* Logic: '<S41>/Logical Operator' */
    rtb_bCBV_min = (rtb_Switch4_j &&
                    Gen2_ref_B->BusInput3.bdcCbv.bKi_island_reject);

    /* Switch: '<S41>/Switch5' */
    for (i = 0; i < 10; i++) {
      if (rtb_bCBV_min) {
        rtb_Switch6_n[i] = Gen2_ref_B->BusInput3.bdcCbv.rKi_island_reject_Lup[i];
      } else {
        rtb_Switch6_n[i] = Gen2_ref_B->BusInput3.bdcCbv.rKi_island_Lup[i];
      }
    }

    /* End of Switch: '<S41>/Switch5' */

    /* S-Function (sfix_look1_dyn): '<S41>/Lookup7' */
    /* Dynamic Look-Up Table Block: '<S41>/Lookup7'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_Lookup7), &rtb_Switch6_n[0], rtb_Pa2bar,
                         &Gen2_ref_B->BusInput3.bdcMisc.rPr_Lup_in[0], 9U, inst);
    FILT_IN = rtb_Lookup7 + Gen2_ref_B->BusInput3.bdcCbv.rKi_island_offset;
  }

  /* End of Switch: '<S41>/Switch3' */

  /* Switch: '<S131>/Switch2' incorporates:
   *  RelationalOperator: '<S131>/LowerRelop1'
   *  RelationalOperator: '<S131>/UpperRelop'
   *  Switch: '<S131>/Switch'
   */
  if (FILT_IN > Gen2_ref_B->BusInput3.bdcMisc.rKiMax) {
    rtb_Pa2bar = Gen2_ref_B->BusInput3.bdcMisc.rKiMax;
  } else if (FILT_IN < Gen2_ref_B->BusInput3.bdcMisc.rKiMin) {
    /* Switch: '<S131>/Switch' */
    rtb_Pa2bar = Gen2_ref_B->BusInput3.bdcMisc.rKiMin;
  } else {
    rtb_Pa2bar = FILT_IN;
  }

  /* End of Switch: '<S131>/Switch2' */

  /* Switch: '<S26>/Switch5' incorporates:
   *  Constant: '<S26>/Constant4'
   *  Product: '<S26>/Divide'
   *  RelationalOperator: '<S26>/Relational Operator'
   */
  if (Gen2_ref_B->BusInput3.bdcCbv.rKaw <= 0.0) {
    /* Saturate: '<S26>/Saturation' */
    if (rtb_Divide2_f <= 0.1) {
      rtb_Divide2_f = 0.1;
    }

    /* End of Saturate: '<S26>/Saturation' */
    FILT_IN = rtb_Pa2bar / rtb_Divide2_f;
  } else {
    FILT_IN = Gen2_ref_B->BusInput3.bdcCbv.rKaw;
  }

  /* End of Switch: '<S26>/Switch5' */

  /* Product: '<S26>/Product2' incorporates:
   *  Sum: '<S26>/Sum4'
   */
  rtb_Divide2_f = (rtb_Switch1_kk - r) * FILT_IN;

  /* Switch: '<S109>/Switch2' incorporates:
   *  Constant: '<S26>/Constant2'
   *  RelationalOperator: '<S109>/LowerRelop1'
   *  RelationalOperator: '<S109>/UpperRelop'
   *  Switch: '<S109>/Switch'
   */
  if (rtb_Divide2_f > 1.0E+10) {
    FILT_IN = 1.0E+10;
  } else if (rtb_Divide2_f < Gen2_ref_B->BusInput3.bdcCbv.rAW_lim_rej) {
    /* Switch: '<S109>/Switch' */
    FILT_IN = Gen2_ref_B->BusInput3.bdcCbv.rAW_lim_rej;
  } else {
    FILT_IN = rtb_Divide2_f;
  }

  /* End of Switch: '<S109>/Switch2' */

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S43>/Bus Creator6'
   *  DataTypeConversion: '<S43>/Data Type Conversion2'
   *  DataTypeConversion: '<S43>/Data Type Conversion4'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.BDC.SP.rMdot_mixture_Bypass = (real32_T)x;
  Gen2_ref_Y->dbg.BDC.SP.mdot_corr = (real32_T)rtb_Switch_n;

  /* Sum: '<S23>/Sum6' */
  rtb_Divide2_f = rtb_Sum_c - rtb_Gain_kl;

  /* Product: '<S62>/Product' incorporates:
   *  MATLAB Function: '<S62>/MATLAB Function'
   */
  rtb_Sum_c = (rtb_LogicalOperator2_ov ? (real_T)Gen2_ref_DWork->x_i : 0.0) *
    rtb_Divide2_f;

  /* Outputs for Atomic SubSystem: '<S62>/Filter3' */
  Gen2_ref_Filter3(rtb_Sum_c, Gen2_ref_B->BusInput3.traj.rTiFp2sComp,
                   Gen2_ref_ConstB.Constant11, rtb_LogicalOperator2_dc,
                   &Gen2_ref_B->Filter3, &Gen2_ref_DWork->Filter3, inst);

  /* End of Outputs for SubSystem: '<S62>/Filter3' */

  /* Switch: '<S62>/Switch4' incorporates:
   *  DiscreteIntegrator: '<S62>/Discrete-Time Integrator'
   *  Gain: '<S62>/Gain6'
   *  Product: '<S62>/Divide'
   *  Product: '<S62>/Product3'
   *  Switch: '<S62>/Switch'
   */
  if (rtb_LogicalOperator_aw) {
    /* Switch: '<S96>/Switch' incorporates:
     *  Abs: '<S96>/Abs'
     *  Constant: '<S96>/Constant2'
     *  RelationalOperator: '<S96>/Relational Operator'
     */
    if (2.2204460492503131E-16 >= fabs(Gen2_ref_B->BusInput3.traj.rTiFp2sComp))
    {
      delta_y = 2.2204460492503131E-16;
    } else {
      delta_y = Gen2_ref_B->BusInput3.traj.rTiFp2sComp;
    }

    /* End of Switch: '<S96>/Switch' */
    rtb_Gain_kl = -Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a / delta_y;
  } else {
    if (!Gen2_ref_B->BusInput3.traj.bUseUnFilterComp) {
      /* Switch: '<S62>/Switch' */
      rtb_Sum_c = Gen2_ref_B->Filter3.Switch;
    }

    /* Switch: '<S62>/Switch2' incorporates:
     *  Abs: '<S62>/Abs2'
     *  Constant: '<S62>/Constant2'
     *  Logic: '<S62>/Logical Operator3'
     *  Logic: '<S62>/Logical Operator7'
     *  Logic: '<S62>/Logical Operator8'
     *  MATLAB Function: '<S62>/MATLAB Function'
     *  RelationalOperator: '<S62>/Relational Operator4'
     *  RelationalOperator: '<S62>/Relational Operator5'
     *  RelationalOperator: '<S62>/Relational Operator6'
     *  UnitDelay: '<S1>/Unit Delay2'
     */
    if ((Gen2_ref_DWork->x_i && (rtb_Divide2_f > 0.0) &&
         (Gen2_ref_B->BusInput3.traj.rMinCbvAwTvDpCmp >
          Gen2_ref_DWork->UnitDelay2_DSTATE_d)) || (rtb_LogicalOperator && (fabs
          (Gen2_ref_B->Filter4.Switch1) >
          Gen2_ref_B->BusInput3.traj.rMindpdtTvDpCmp)) ||
        Gen2_ref_B->BusInput.tLvrt.bLvrtFlg) {
      delta_y = 0.0;
    } else {
      delta_y = Gen2_ref_B->BusInput3.traj.rGainP2sComp;
    }

    /* End of Switch: '<S62>/Switch2' */
    rtb_Gain_kl = rtb_Sum_c * delta_y;
  }

  /* End of Switch: '<S62>/Switch4' */

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S1>/Bus Creator2'
   *  BusCreator: '<S23>/Bus Creator'
   *  DataTypeConversion: '<S1>/Data Type Conversion15'
   *  DataTypeConversion: '<S1>/Data Type Conversion9'
   *  DataTypeConversion: '<S23>/Data Type Conversion5'
   *  DataTypeConversion: '<S78>/Data Type Conversion6'
   *  Outport: '<Root>/dbg'
   * */
  Gen2_ref_Y->dbg.BDC.MP.TVdpFF = (real32_T)rtb_MinMax_a;
  Gen2_ref_Y->dbg.BDC.RL.RLthrsh = (real32_T)rtb_Switch2_jq;
  Gen2_ref_Y->dbg.BDC.FF.CBV_cd = (real32_T)rtb_Sum_mf;
  Gen2_ref_Y->dbg.BDC.FF.TV_cd = (real32_T)rtb_Sum2_a1;

  /* Switch: '<S172>/Switch2' incorporates:
   *  Constant: '<S46>/Constant4'
   *  RelationalOperator: '<S172>/LowerRelop1'
   *  RelationalOperator: '<S172>/UpperRelop'
   *  Switch: '<S172>/Switch'
   */
  if (rtb_DataTypeConversion15 > rtb_Switch13) {
    r = rtb_Switch13;
  } else if (rtb_DataTypeConversion15 < 1.0) {
    /* Switch: '<S172>/Switch' incorporates:
     *  Constant: '<S46>/Constant4'
     */
    r = 1.0;
  } else {
    r = rtb_DataTypeConversion15;
  }

  /* End of Switch: '<S172>/Switch2' */

  /* Saturate: '<S46>/Saturation4' */
  if (Gen2_ref_B->p2s_filt.Switch <= 100000.0) {
    delta_y = 100000.0;
  } else {
    delta_y = Gen2_ref_B->p2s_filt.Switch;
  }

  /* End of Saturate: '<S46>/Saturation4' */

  /* MATLAB Function: '<S46>/engine massflow1' incorporates:
   *  Gain: '<S46>/rpm2rad'
   */
  Gen2_ref_enginemassflow2(delta_y, Gen2_ref_B->T2s_filt.Switch,
    0.10471975511965977 * r, rtb_etaVolConst_lt,
    Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng, &Gen2_ref_B->sf_enginemassflow1_e, inst);

  /* Gain: '<S1>/Gain7' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  rtb_Divide2_f = 100000.0 * rtb_Switch2_lu;

  /* MATLAB Function: '<S46>/engine massflow' incorporates:
   *  Gain: '<S46>/rpm2rad1'
   */
  Gen2_ref_enginemassflow(rtb_Divide2_f, Gen2_ref_B->T2s_filt.Switch,
    0.10471975511965977 * rtb_Switch13, rtb_etaVolConst_lt,
    Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng, &Gen2_ref_B->sf_enginemassflow_h, inst);

  /* Gain: '<S46>/rpm2rad2' */
  r = 1.0E-5 * rtb_Divide2_f;

  /* S-Function (sfix_look1_dyn): '<S46>/Lookup Table Dynamic1' */
  /* Dynamic Look-Up Table Block: '<S46>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Sum_mf),
                       &Gen2_ref_B->BusInput3.bdcWgv.rRefWGVres_y[0], r,
                       &Gen2_ref_B->BusInput3.bdcWgv.rRefWGVres_x[0], 4U, inst);

  /* Outputs for Atomic SubSystem: '<S46>/cbv tracking1' */
  /* Abs: '<S174>/Abs' */
  rtb_Sum_c = fabs(Gen2_ref_B->BusInput3.bdcWgv.rMaxErrCBVtracking);

  /* Sum: '<S174>/Sum4' incorporates:
   *  Gain: '<S46>/Gain'
   *  Gain: '<S46>/Gain1'
   */
  r = 9.9999999999999991E-6 * rtb_Divide2_f - 9.9999999999999991E-6 *
    Gen2_ref_B->p2s_filt.Switch;

  /* RelationalOperator: '<S174>/Relational Operator2' */
  rtb_LogicalOperator2_ov = (r >
    Gen2_ref_B->BusInput3.bdcWgv.rLimit_p2s_CBVtracking);

  /* Outputs for Atomic SubSystem: '<S174>/TP' */
  /* Product: '<S185>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S185>/sample time'
   *
   * About '<S185>/sample time':
   *  y = K where K = ( w * Ts )
   */
  r = 0.01;

  /* Outputs for Enabled SubSystem: '<S181>/Enabled Subsystem' incorporates:
   *  EnablePort: '<S183>/Enable'
   */
  /* Logic: '<S181>/Logical Operator3' incorporates:
   *  Logic: '<S181>/Logical Operator2'
   *  UnitDelay: '<S181>/Unit Delay2'
   */
  if ((!rtb_LogicalOperator2_ov) && Gen2_ref_DWork->UnitDelay2_DSTATE_b) {
    /* Merge: '<S181>/Merge' incorporates:
     *  Constant: '<S181>/Constant10'
     *  Inport: '<S183>/In1'
     */
    Gen2_ref_B->Merge = 0.0;
  }

  /* End of Logic: '<S181>/Logical Operator3' */
  /* End of Outputs for SubSystem: '<S181>/Enabled Subsystem' */

  /* Outputs for Enabled SubSystem: '<S181>/Enabled Subsystem1' incorporates:
   *  EnablePort: '<S184>/Enable'
   */
  if (rtb_LogicalOperator2_ov) {
    /* Merge: '<S181>/Merge' incorporates:
     *  Inport: '<S184>/In1'
     *  SignalConversion generated from: '<S174>/Bus Selector1'
     */
    Gen2_ref_B->Merge = Gen2_ref_B->BusInput3.bdcWgv.rTi_TP_CBVtracking;
  }

  /* End of Outputs for SubSystem: '<S181>/Enabled Subsystem1' */

  /* UnitDelay: '<S185>/Delay Input2' */
  rtb_Divide2_f = Gen2_ref_DWork->DelayInput2_DSTATE;

  /* Sum: '<S185>/Difference Inputs1' */
  rtb_Sum2_a1 = Gen2_ref_B->Merge - rtb_Divide2_f;

  /* Switch: '<S186>/Switch2' incorporates:
   *  RelationalOperator: '<S186>/LowerRelop1'
   */
  if (!(rtb_Sum2_a1 > 0.01)) {
    /* Switch: '<S186>/Switch' incorporates:
     *  RelationalOperator: '<S186>/UpperRelop'
     */
    if (rtb_Sum2_a1 < -99.990000000000009) {
      r = -99.990000000000009;
    } else {
      r = rtb_Sum2_a1;
    }

    /* End of Switch: '<S186>/Switch' */
  }

  /* End of Switch: '<S186>/Switch2' */

  /* Sum: '<S185>/Difference Inputs2' */
  rtb_Divide2_f += r;

  /* Update for UnitDelay: '<S181>/Unit Delay2' incorporates:
   *  RelationalOperator: '<S181>/Relational Operator3'
   *  SignalConversion generated from: '<S174>/Bus Selector1'
   */
  Gen2_ref_DWork->UnitDelay2_DSTATE_b = (rtb_Divide2_f >=
    Gen2_ref_B->BusInput3.bdcWgv.rTi_TP_CBVtracking);

  /* Update for UnitDelay: '<S185>/Delay Input2' */
  Gen2_ref_DWork->DelayInput2_DSTATE = rtb_Divide2_f;

  /* Logic: '<S174>/Logical Operator5' incorporates:
   *  Constant: '<S179>/Constant'
   *  Constant: '<S182>/Constant'
   *  DataTypeConversion: '<S1>/Data Type Conversion11'
   *  Logic: '<S174>/Logical Operator1'
   *  Logic: '<S174>/Logical Operator4'
   *  Logic: '<S181>/Logical Operator1'
   *  Logic: '<S1>/Logical Operator4'
   *  RelationalOperator: '<S179>/Compare'
   *  RelationalOperator: '<S181>/Relational Operator1'
   *  RelationalOperator: '<S182>/Compare'
   *  SignalConversion generated from: '<S174>/Bus Selector1'
   */
  rtb_LogicalOperator2_ov = ((!Gen2_ref_B->BusInput3.bdcWgv.bTransWGctrl_FF) ||
    (!Gen2_ref_B->BusInput3.bdcWgv.bCBVtracking) ||
    (Gen2_ref_B->BusInput3.eng.rNum_WGV < 0.5) || (!(rtb_Sum1_dh != 0.0)) ||
    ((rtb_Divide2_f > 0.0) && (rtb_Divide2_f <
    Gen2_ref_B->BusInput3.bdcWgv.rTi_TP_CBVtracking)));

  /* End of Outputs for SubSystem: '<S174>/TP' */

  /* DiscreteIntegrator: '<S174>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_ov ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_a != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gw = 0.0;
  }

  rtb_DiscreteTimeIntegrator_g3 =
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gw;

  /* Sum: '<S174>/Sum' incorporates:
   *  UnitDelay: '<S1>/Unit Delay3'
   */
  rtb_Divide2_f = Gen2_ref_DWork->UnitDelay3_DSTATE_g -
    Gen2_ref_B->BusInput3.bdcWgv.rRefCBVtracking;

  /* Switch: '<S174>/Switch8' incorporates:
   *  Constant: '<S174>/max_PR1'
   */
  if (Gen2_ref_B->TON2.LogicalOperator3) {
    /* Switch: '<S174>/Switch1' incorporates:
     *  Constant: '<S174>/max_PR2'
     *  Constant: '<S174>/max_PR3'
     *  RelationalOperator: '<S174>/Relational Operator1'
     *  Sum: '<S174>/Sum2'
     *  UnitDelay: '<S46>/Unit Delay'
     */
    if (Gen2_ref_DWork->UnitDelay_DSTATE_b >
        Gen2_ref_B->BusInput3.bdcWgv.rPos_max - 0.001) {
      r = 0.0;
    } else {
      r = rtb_Sum_c;
    }

    /* End of Switch: '<S174>/Switch1' */

    /* Switch: '<S180>/Switch2' incorporates:
     *  RelationalOperator: '<S180>/LowerRelop1'
     */
    if (!(rtb_Divide2_f > r)) {
      /* Switch: '<S174>/Switch2' incorporates:
       *  Constant: '<S174>/max_PR2'
       *  Constant: '<S174>/max_PR3'
       *  Gain: '<S174>/Gain'
       *  RelationalOperator: '<S174>/Relational Operator'
       *  Sum: '<S174>/Sum1'
       *  UnitDelay: '<S46>/Unit Delay'
       */
      if (Gen2_ref_DWork->UnitDelay_DSTATE_b <
          Gen2_ref_B->BusInput3.bdcWgv.rPos_min + 0.001) {
        rtb_Sum_c = 0.0;
      } else {
        rtb_Sum_c = -rtb_Sum_c;
      }

      /* End of Switch: '<S174>/Switch2' */

      /* Switch: '<S180>/Switch' incorporates:
       *  RelationalOperator: '<S180>/UpperRelop'
       */
      if (rtb_Divide2_f < rtb_Sum_c) {
        r = rtb_Sum_c;
      } else {
        r = rtb_Divide2_f;
      }

      /* End of Switch: '<S180>/Switch' */
    }

    /* End of Switch: '<S180>/Switch2' */
  } else {
    r = 0.0;
  }

  /* End of Switch: '<S174>/Switch8' */

  /* Product: '<S174>/Divide1' */
  rtb_Divide1_k = rtb_Divide2_f * Gen2_ref_B->BusInput3.bdcWgv.rKpCBVtracking;

  /* Sum: '<S174>/Sum3' incorporates:
   *  DiscreteIntegrator: '<S174>/Discrete-Time Integrator'
   */
  rtb_Sum3_hx = Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gw + rtb_Divide1_k;

  /* Update for DiscreteIntegrator: '<S174>/Discrete-Time Integrator' incorporates:
   *  Product: '<S174>/Divide'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_gw +=
    Gen2_ref_B->BusInput3.bdcWgv.rKiCBVtracking * r * 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_a = (int8_T)
    rtb_LogicalOperator2_ov;

  /* End of Outputs for SubSystem: '<S46>/cbv tracking1' */

  /* Sum: '<S46>/Sum4' */
  rtb_Sum_mf += rtb_Sum3_hx;

  /* Product: '<S46>/Divide3' */
  r = Gen2_ref_B->sf_enginemassflow_h.dm_e * rtb_Sum_mf;

  /* Product: '<S46>/Product' incorporates:
   *  Constant: '<S46>/Constant'
   *  Sum: '<S46>/Sum3'
   */
  rtb_Sum_c = (rtb_Sum_mf + 1.0) * Gen2_ref_B->sf_enginemassflow1_e.dm_e;

  /* Gain: '<S1>/Gain8' incorporates:
   *  BusCreator: '<S23>/Bus Creator1'
   */
  rtb_Sum_mf = 100000.0 * Gen2_ref_B->Filter4.Switch1;

  /* DataTypeConversion: '<S175>/Data Type Conversion' */
  rtb_Divide2_f = Gen2_ref_B->BusInput3.bdcWgv.bDynFFwgv_ON;

  /* Sum: '<S175>/Sum3' */
  rtb_Sum2_a1 = rtb_Saturation_cx;

  /* Sum: '<S46>/Sum1' incorporates:
   *  Constant: '<S175>/R_air'
   *  Product: '<S175>/Divide6'
   *  Product: '<S175>/Divide7'
   *  Product: '<S175>/Divide8'
   *  Sum: '<S46>/Sum2'
   */
  rtb_Divide2_f = (rtb_Sum_c - rtb_Sum2_a1 / (287.15 *
    Gen2_ref_B->T2s_filt.Switch) * (rtb_Sum_mf * rtb_Divide2_f)) -
    Gen2_ref_B->sf_enginemassflow_h.dm_e;

  /* Switch: '<S173>/Switch2' incorporates:
   *  RelationalOperator: '<S173>/LowerRelop1'
   */
  if (!(rtb_Divide2_f > r)) {
    /* Switch: '<S173>/Switch' incorporates:
     *  Constant: '<S46>/Constant1'
     *  RelationalOperator: '<S173>/UpperRelop'
     */
    if (rtb_Divide2_f < 0.0) {
      r = 0.0;
    } else {
      r = rtb_Divide2_f;
    }

    /* End of Switch: '<S173>/Switch' */
  }

  /* End of Switch: '<S173>/Switch2' */

  /* Saturate: '<S46>/Saturation5' */
  if (Gen2_ref_B->BusInput3.eng.rNum_WGV > 10.0) {
    rtb_Sum_mf = 10.0;
  } else if (Gen2_ref_B->BusInput3.eng.rNum_WGV < 1.0) {
    rtb_Sum_mf = 1.0;
  } else {
    rtb_Sum_mf = Gen2_ref_B->BusInput3.eng.rNum_WGV;
  }

  /* End of Saturate: '<S46>/Saturation5' */

  /* Product: '<S46>/Divide1' */
  r /= rtb_Sum_mf;

  /* Saturate: '<S46>/Saturation' */
  if (r <= 0.0) {
    rtb_Saturation_cx = 0.0;
  } else {
    rtb_Saturation_cx = r;
  }

  /* End of Saturate: '<S46>/Saturation' */

  /* DataTypeConversion: '<S4>/Data Type Conversion26' */
  r = Gen2_ref_B->BusInput.tPr.rp3HP;

  /* Outputs for Atomic SubSystem: '<S207>/p3LP_filt' */
  /* Gain: '<S4>/bar2Pa7' */
  Gen2_ref_N_TC_HP_filt(100000.0 * r, Gen2_ref_B->BusInput3.inFilt.rTiF_Pr,
                        rtb_bResetBdc, &Gen2_ref_B->p3LP_filt_e,
                        &Gen2_ref_DWork->p3LP_filt_e, inst);

  /* End of Outputs for SubSystem: '<S207>/p3LP_filt' */

  /* Switch: '<S1>/Switch' */
  if (Gen2_ref_B->BusInput3.bdcWgv.bSensorP3 != 0.0) {
    rtb_Divide2_f = Gen2_ref_B->p3LP_filt_e.Switch;
  } else {
    rtb_Divide2_f = Gen2_ref_B->p2s_filt.Switch;
  }

  /* End of Switch: '<S1>/Switch' */

  /* DataTypeConversion: '<S4>/Data Type Conversion7' */
  r = Gen2_ref_B->BusInput.tPr.rp4LP;

  /* Outputs for Atomic SubSystem: '<S208>/p4LP_filt' */
  /* Gain: '<S4>/bar2Pa5' */
  Gen2_ref_N_TC_HP_filt(100000.0 * r, Gen2_ref_B->BusInput3.inFilt.rTiF_Pr,
                        rtb_bResetBdc, &Gen2_ref_B->p4LP_filt,
                        &Gen2_ref_DWork->p4LP_filt, inst);

  /* End of Outputs for SubSystem: '<S208>/p4LP_filt' */

  /* MATLAB Function: '<S46>/MATLAB Function1' incorporates:
   *  Constant: '<S46>/Constant3'
   *  Product: '<S46>/Product1'
   */
  if (rtb_Divide2_f >= Gen2_ref_B->p4LP_filt.Switch) {
    r = Gen2_ref_B->p4LP_filt.Switch / rtb_Divide2_f;
    if ((1.0E-6 >= r) || rtIsNaN(r)) {
      r = 1.0E-6;
    }

    if (1.0 / r <= 1.8929291587378541) {
      u0 = 0.78539816339744828 * Gen2_ref_B->BusInput3.bdcWgv.rDref *
        Gen2_ref_B->BusInput3.bdcWgv.rDref * rtb_Divide2_f / sqrt(287.15 *
        Gen2_ref_B->T2s_filt.Switch) * sqrt((rt_powd_snf(r, 1.4285714285714286, inst)
        - rt_powd_snf(r, 1.7142857142857144, inst)) * 7.0000000000000009);
      if (!(u0 >= 1.0E-6)) {
        u0 = 1.0E-6;
      }

      rtb_Divide2_f = rtb_Saturation_cx / u0;
    } else {
      u0 = 0.78539816339744828 * Gen2_ref_B->BusInput3.bdcWgv.rDref *
        Gen2_ref_B->BusInput3.bdcWgv.rDref * rtb_Divide2_f / sqrt(287.15 *
        Gen2_ref_B->T2s_filt.Switch) * 0.6847314563772704;
      if (!(u0 >= 1.0E-6)) {
        u0 = 1.0E-6;
      }

      rtb_Divide2_f = rtb_Saturation_cx / u0;
    }
  } else {
    rtb_Divide2_f = 0.0;
  }

  /* End of MATLAB Function: '<S46>/MATLAB Function1' */

  /* Saturate: '<S46>/Saturation1' */
  if (rtb_Divide2_f > 1.0) {
    r = 1.0;
  } else if (rtb_Divide2_f < 0.0) {
    r = 0.0;
  } else {
    r = rtb_Divide2_f;
  }

  /* End of Saturate: '<S46>/Saturation1' */

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S1>/Bus Creator2'
   *  DataTypeConversion: '<S1>/Data Type Conversion19'
   *  DataTypeConversion: '<S1>/Data Type Conversion7'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.BDC.FF.wg_cd = (real32_T)r;
  Gen2_ref_Y->dbg.BDC.FF.u_tv_ff = (real32_T)rtb_Product4_d;

  /* MinMax: '<S490>/MinMax' incorporates:
   *  DataTypeConversion: '<S43>/Data Type Conversion25'
   */
  if ((Gen2_ref_B->BusInput3.bdcTv.rPos_min >= (real32_T)rtb_Switch_e) ||
      rtIsNaN((real32_T)rtb_Switch_e)) {
    rtb_Sum_mf = Gen2_ref_B->BusInput3.bdcTv.rPos_min;
  } else {
    rtb_Sum_mf = (real32_T)rtb_Switch_e;
  }

  /* End of MinMax: '<S490>/MinMax' */

  /* Logic: '<S426>/Logical Operator3' incorporates:
   *  Constant: '<S490>/Constant4'
   *  Logic: '<S426>/Logical Operator'
   *  Logic: '<S426>/Logical Operator2'
   *  Logic: '<S490>/Logical Operator1'
   *  Product: '<S490>/Divide'
   *  RelationalOperator: '<S490>/Relational Operator2'
   *  RelationalOperator: '<S490>/Relational Operator3'
   *  Sum: '<S490>/Sum'
   *  Sum: '<S490>/Sum2'
   *  UnitDelay: '<Root>/Unit Delay3'
   */
  rtb_LogicalOperator3_gq = (((Gen2_ref_DWork->UnitDelay3_DSTATE /
    rtb_deltafalllimit_ca >= 1.0 - rtb_PactOut) && (rtb_Divide3_ep <= rtb_Sum_mf
    + rtb_PactOut)) || (Gen2_ref_B->TP_ActSat_CBV.LogicalOperator1 &&
                        Gen2_ref_B->TP_ActSat_TV.LogicalOperator1) ||
    (!Gen2_ref_B->BusInput3.LR.bAct_CompActSatOnly));

  /* Switch: '<S491>/Switch3' incorporates:
   *  Constant: '<S426>/Constant'
   */
  if (rtb_bResetHlci) {
    rtb_LogicalOperator_aw = false;
  } else {
    /* Sum: '<S426>/Sum2' */
    rtb_Divide2_f = rtb_Switch_i5[0] - rtb_Switch_ks;

    /* Switch: '<S491>/Switch1' incorporates:
     *  Constant: '<S491>/FALSE'
     *  RelationalOperator: '<S491>/groesser '
     *  RelationalOperator: '<S491>/kleiner'
     *  UnitDelay: '<S491>/Unit Delay2'
     */
    if (rtb_Divide2_f < Gen2_ref_B->BusInput3.LR.rN_GasFlowSatComp_diffLo) {
      rtb_LogicalOperator_aw = false;
    } else {
      rtb_LogicalOperator_aw = ((rtb_Divide2_f >
        Gen2_ref_B->BusInput3.LR.rN_GasFlowSatComp_diffUp) ||
        Gen2_ref_DWork->UnitDelay2_DSTATE_j);
    }

    /* End of Switch: '<S491>/Switch1' */
  }

  /* End of Switch: '<S491>/Switch3' */

  /* Gain: '<S426>/Gain' */
  rtb_Sum_mf = 100000.0 * Gen2_ref_B->BusInput3.LR.rP2s_GasFlowSatComp_SettleLim;

  /* Outputs for Atomic SubSystem: '<S426>/TP' */
  /* RelationalOperator: '<S426>/Relational Operator' incorporates:
   *  SignalConversion generated from: '<S426>/Bus Selector3'
   */
  Gen2_ref_TP((rtb_Switch_i5[5] <= rtb_Sum_mf),
              Gen2_ref_B->BusInput3.LR.rTi_GasFlowSatComp_TP2psSettle,
              &Gen2_ref_B->TP, &Gen2_ref_DWork->TP, inst);

  /* End of Outputs for SubSystem: '<S426>/TP' */

  /* Outputs for Atomic SubSystem: '<S426>/TP1' */
  /* RelationalOperator: '<S426>/Relational Operator1' incorporates:
   *  SignalConversion generated from: '<S426>/Bus Selector5'
   */
  Gen2_ref_TP((rtb_Saturation >
               Gen2_ref_B->BusInput3.LR.rP_GasFlowSatComp_RotLim),
              Gen2_ref_B->BusInput3.LR.rTi_GasFlowSatComp_ProtTP,
              &Gen2_ref_B->TP1, &Gen2_ref_DWork->TP1, inst);

  /* End of Outputs for SubSystem: '<S426>/TP1' */

  /* Switch: '<S494>/etaVolConst' incorporates:
   *  Constant: '<S426>/Constant4'
   *  Logic: '<S426>/Logical Operator1'
   *  Logic: '<S426>/Logical Operator4'
   *  Switch: '<S426>/Switch'
   */
  if (rtb_bResetHlci) {
    rtb_Divide2_f = 1.0;
  } else if (Gen2_ref_B->BusInput3.LR.bActGasFlowSatComp &&
             rtb_LogicalOperator3_gq && rtb_LogicalOperator_aw &&
             (!Gen2_ref_B->TP.LogicalOperator1) &&
             Gen2_ref_B->TP1.LogicalOperator1) {
    /* Switch: '<S426>/Switch1' incorporates:
     *  Switch: '<S426>/Switch'
     */
    if (Gen2_ref_B->BusInput3.LR.bGS_GasFlowSatComp_active) {
      /* Switch: '<S426>/Switch2' */
      if (Gen2_ref_B->BusInput3.LR.bGS_GasFlowSatComp_UseProt) {
        rtb_Divide2_f = rtb_Saturation;
      } else {
        rtb_Divide2_f = rtb_kW2W1_h;
      }

      /* S-Function (sfix_look1_dyn): '<S426>/Lookup Table Dynamic' */
      /* Dynamic Look-Up Table Block: '<S426>/Lookup Table Dynamic'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_LookupTableDynamic_h),
                           &Gen2_ref_B->BusInput3.LR.rGainGasFlowSatComp_GS_y[0],
                           rtb_Divide2_f,
                           &Gen2_ref_B->BusInput3.LR.rGainGasFlowSatComp_GS_x[0],
                           7U, inst);
      rtb_Divide2_f = rtb_LookupTableDynamic_h;
    } else {
      rtb_Divide2_f = Gen2_ref_B->BusInput3.LR.rGainGasFlowSatComp;
    }
  } else {
    /* Switch: '<S426>/Switch' incorporates:
     *  Constant: '<S426>/Constant4'
     */
    rtb_Divide2_f = 1.0;
  }

  /* Delay: '<S494>/Delay' incorporates:
   *  Constant: '<S426>/Constant4'
   *  Delay: '<S425>/Delay'
   */
  Gen2_ref_DWork->icLoad_ir = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_bc ==
    1) != (int32_T)rtb_bResetHlci) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_bc != 3)) || rtb_bResetHlci ||
    Gen2_ref_DWork->icLoad_ir);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_bc = rtb_bResetHlci;
  if (Gen2_ref_DWork->icLoad_ir) {
    Gen2_ref_DWork->Delay_DSTATE_f = 1.0;
  }

  /* Sum: '<S494>/Difference Inputs1' incorporates:
   *  Delay: '<S494>/Delay'
   */
  rtb_Divide2_f -= Gen2_ref_DWork->Delay_DSTATE_f;

  /* Switch: '<S505>/Switch2' incorporates:
   *  RelationalOperator: '<S505>/LowerRelop1'
   */
  if (!(rtb_Divide2_f > rtb_Switch2_l)) {
    /* Switch: '<S505>/Switch' incorporates:
     *  RelationalOperator: '<S505>/UpperRelop'
     */
    if (rtb_Divide2_f < -10.0) {
      rtb_Switch2_l = -10.0;
    } else {
      rtb_Switch2_l = rtb_Divide2_f;
    }

    /* End of Switch: '<S505>/Switch' */
  }

  /* End of Switch: '<S505>/Switch2' */

  /* Sum: '<S494>/Difference Inputs2' incorporates:
   *  Delay: '<S494>/Delay'
   */
  rtb_Switch2_l += Gen2_ref_DWork->Delay_DSTATE_f;

  /* Switch: '<Root>/GasStop' incorporates:
   *  Constant: '<Root>/Constant3'
   *  Product: '<S5>/Product'
   */
  if (rtb_dbg_HLCi) {
    rtb_Sum_c = 0.0;
  } else {
    rtb_Sum_c = Gen2_ref_B->sf_IntegerZOH_f.y * rtb_Switch2_l;
  }

  /* End of Switch: '<Root>/GasStop' */

  /* Outputs for Atomic SubSystem: '<S268>/Mg' */
  Gen2_ref_Mg(Gen2_ref_B->BusInput3.eng.rRho_gas_M, &Gen2_ref_B->Mg_l, inst);

  /* End of Outputs for SubSystem: '<S268>/Mg' */

  /* Outputs for Atomic SubSystem: '<S268>/lam2cg' */
  Gen2_ref_lam2cg1(rtb_Product1_fu,
                   Gen2_ref_B->BusInput3.eng.rMin_Air_Ratio_M_kg,
                   &Gen2_ref_B->lam2cg_i, inst);

  /* End of Outputs for SubSystem: '<S268>/lam2cg' */

  /* Product: '<S268>/Divide3' incorporates:
   *  Bias: '<S268>/Bias'
   *  Constant: '<S268>/R_air'
   *  Product: '<S268>/Divide2'
   */
  rtb_Switch_ks = (Gen2_ref_B->Mg_l.Bias * Gen2_ref_B->lam2cg_i.Divide + 1.0) *
    287.15;

  /* Product: '<S268>/Divide' incorporates:
   *  Product: '<S268>/Divide3'
   */
  rtb_Divide_ab[0] = rtb_SumofElements_l / rtb_Switch_ks *
    Gen2_ref_B->BusInput3.fdc.rCF[0];
  rtb_Divide_ab[1] = rtb_RoundingFunction / rtb_Switch_ks *
    Gen2_ref_B->BusInput3.fdc.rCF[1];
  rtb_Divide_ab[2] = rtb_Switch2_d1 / rtb_Switch_ks *
    Gen2_ref_B->BusInput3.fdc.rCF[2];
  rtb_Divide_ab[3] = rtb_Product1_mqz / rtb_Switch_ks *
    Gen2_ref_B->BusInput3.fdc.rCF[3];

  /* Product: '<S268>/Divide1' incorporates:
   *  Sum: '<S268>/Sum of Elements'
   */
  rtb_Sum_mf = (((rtb_Divide_ab[0] + rtb_Divide_ab[1]) + rtb_Divide_ab[2]) +
                rtb_Divide_ab[3]) * Gen2_ref_B->lam2cg_i.Divide;

  /* Switch: '<S268>/Switch' incorporates:
   *  Constant: '<S268>/Constant5'
   */
  if (Gen2_ref_B->BusInput3.fdc.bActive_dyn) {
    rtb_Divide2_f = rtb_Sum_mf;
  } else {
    rtb_Divide2_f = 0.0;
  }

  /* End of Switch: '<S268>/Switch' */

  /* Abs: '<S289>/Abs' incorporates:
   *  Abs: '<S817>/Abs'
   */
  delta_y = rtb_bResetHlci_0;
  rtb_Sum2_a1 = delta_y;

  /* Switch: '<S289>/Switch' incorporates:
   *  Constant: '<S289>/Constant2'
   *  RelationalOperator: '<S289>/Relational Operator'
   */
  if (1.0 >= rtb_Sum2_a1) {
    rtb_SumofElements_l = 1.0;
  } else {
    rtb_SumofElements_l = Gen2_ref_B->T2s_filt.Switch;
  }

  /* End of Switch: '<S289>/Switch' */

  /* Outputs for Atomic SubSystem: '<S268>/lam2cg1' */
  Gen2_ref_lam2cg1_a(rtb_Product1_fu, Gen2_ref_B->BusInput3.eng.rMin_Air_Ratio_M,
                     &Gen2_ref_B->lam2cg1_i, inst);

  /* End of Outputs for SubSystem: '<S268>/lam2cg1' */

  /* Gain: '<S268>/Gain2' */
  rtb_Sum2_a1 = rtb_Gain_kp;

  /* Product: '<S268>/Product3' incorporates:
   *  Gain: '<S268>/StandardCond'
   *  Product: '<S268>/Divide10'
   *  Product: '<S268>/Divide8'
   */
  rtb_Sum2_a1 = rtb_Switch4_p / rtb_SumofElements_l * 0.0026957809030347889 *
    rtb_Sum_e * Gen2_ref_B->lam2cg1_i.Divide * rtb_Sum2_a1 *
    Gen2_ref_B->BusInput3.eng.rRho_gas_M;

  /* Sum: '<S268>/Add1' */
  rtb_SumofElements_l = rtb_Divide2_f + rtb_Sum2_a1;

  /* MATLAB Function: '<S5>/IntegerZOH1' incorporates:
   *  Product: '<S5>/Divide1'
   */
  Gen2_ref_IntegerZOH(Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2 *
                      rtb_SumofElements_l, Npred, &Gen2_ref_B->sf_IntegerZOH1_n,
                      &Gen2_ref_DWork->sf_IntegerZOH1_n, inst);

  /* Switch: '<Root>/GasStop2' incorporates:
   *  Constant: '<Root>/Constant3'
   *  Product: '<S5>/Product1'
   */
  if (rtb_dbg_HLCi) {
    rtb_Switch2_jq = 0.0;
  } else {
    rtb_Switch2_jq = rtb_Switch2_l * Gen2_ref_B->sf_IntegerZOH1_n.y;
  }

  /* End of Switch: '<Root>/GasStop2' */

  /* Switch: '<S1>/Switch1' incorporates:
   *  Constant: '<S1>/Constant3'
   *  Constant: '<S30>/Constant'
   *  RelationalOperator: '<S30>/Compare'
   */
  if (Gen2_ref_B->BusInput3.eng.rNum_TV > 0.5) {
    /* Outputs for Atomic SubSystem: '<S45>/Linearization' */
    /* S-Function (sfix_look1_dyn): '<S166>/LCRScal_Lam_EOT1' */
    /* Dynamic Look-Up Table Block: '<S166>/LCRScal_Lam_EOT1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(rtb_LCRScal_Lam_EOT1),
                         &Gen2_ref_B->BusInput3.bdcTv.rPosTv_Lin_y[0],
                         rtb_Switch2_by,
                         &Gen2_ref_B->BusInput3.bdcTv.rPosTv_Lin_x[0], 9U, inst);

    /* End of Outputs for SubSystem: '<S45>/Linearization' */
    rtb_Switch13 = rtb_LCRScal_Lam_EOT1;
  } else {
    rtb_Switch13 = 1.0;
  }

  /* End of Switch: '<S1>/Switch1' */

  /* Switch: '<S1>/Switch12' incorporates:
   *  Constant: '<S1>/Constant1'
   *  Logic: '<S1>/Logical Operator6'
   *  Logic: '<S1>/Logical Operator8'
   */
  if ((!Gen2_ref_B->BusInput3.bdcMisc.bSwitchOutputSampleSS) ||
      Gen2_ref_B->TON2.LogicalOperator3) {
    Npred = Gen2_ref_B->BusInput3.bdcMisc.iOutputSample;
  } else {
    Npred = 1;
  }

  /* End of Switch: '<S1>/Switch12' */

  /* MATLAB Function: '<S1>/IntegerZOH' */
  Gen2_ref_IntegerZOH(rtb_Switch13, Npred, &Gen2_ref_B->sf_IntegerZOH,
                      &Gen2_ref_DWork->sf_IntegerZOH, inst);

  /* Switch: '<S1>/Switch3' incorporates:
   *  Constant: '<S1>/Constant'
   *  Constant: '<S29>/Constant'
   *  RelationalOperator: '<S29>/Compare'
   */
  if (Gen2_ref_B->BusInput3.eng.rNum_CBV > 1.5) {
    /* Switch: '<S1>/Switch5' */
    if (Gen2_ref_B->BusInput3.bdcCbv.bFFonly_2nd_CBV) {
      rtb_Product4_d = rtb_Sum1_lo;
    } else {
      rtb_Product4_d = rtb_Switch1_kk;
    }

    /* End of Switch: '<S1>/Switch5' */
  } else {
    rtb_Product4_d = 0.0;
  }

  /* End of Switch: '<S1>/Switch3' */

  /* Switch: '<S1>/Switch4' incorporates:
   *  Constant: '<S1>/Constant'
   *  Constant: '<S28>/Constant'
   *  RelationalOperator: '<S28>/Compare'
   */
  if (Gen2_ref_B->BusInput3.eng.rNum_CBV > 2.5) {
    /* Switch: '<S1>/Switch6' */
    if (Gen2_ref_B->BusInput3.bdcCbv.bFFonly_3rd_CBV) {
      rtb_MinMax_a = rtb_Sum1_lo;
    } else {
      rtb_MinMax_a = rtb_Switch1_kk;
    }

    /* End of Switch: '<S1>/Switch6' */
  } else {
    rtb_MinMax_a = 0.0;
  }

  /* End of Switch: '<S1>/Switch4' */

  /* SignalConversion generated from: '<S38>/ SFunction ' incorporates:
   *  MATLAB Function: '<S1>/IntegerZOH1'
   */
  rtb_TmpSignalConversionAtSFun_p[0] = rtb_Switch1_kk;
  rtb_TmpSignalConversionAtSFun_p[1] = rtb_Product4_d;
  rtb_TmpSignalConversionAtSFun_p[2] = rtb_MinMax_a;

  /* MATLAB Function: '<S1>/IntegerZOH1' incorporates:
   *  SignalConversion generated from: '<S38>/ SFunction '
   */
  if (!Gen2_ref_DWork->count_not_empty) {
    Gen2_ref_DWork->count_not_empty = true;
    Gen2_ref_DWork->u_z[0] = rtb_Switch1_kk;
    Gen2_ref_DWork->u_z[1] = rtb_Product4_d;
    Gen2_ref_DWork->u_z[2] = rtb_MinMax_a;
  }

  if (Gen2_ref_DWork->count_p < Npred) {
    rtb_TmpSignalConversionAtSFun_p[0] = Gen2_ref_DWork->u_z[0];
    rtb_TmpSignalConversionAtSFun_p[1] = Gen2_ref_DWork->u_z[1];
    rtb_TmpSignalConversionAtSFun_p[2] = Gen2_ref_DWork->u_z[2];
    Gen2_ref_DWork->count_p++;
  } else {
    Gen2_ref_DWork->u_z[0] = rtb_Switch1_kk;
    Gen2_ref_DWork->u_z[1] = rtb_Product4_d;
    Gen2_ref_DWork->u_z[2] = rtb_MinMax_a;
    Gen2_ref_DWork->count_p = 1.0;
  }

  /* S-Function (sfix_look1_dyn): '<S46>/Lookup Table Dynamic' */
  /* Dynamic Look-Up Table Block: '<S46>/Lookup Table Dynamic'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Divide2_f),
                       &Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_x[0], r,
                       &Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_y[0], 10U, inst);

  /* MinMax: '<S46>/MinMax' */
  r = Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_x[0];
  for (k = 0; k < 10; k++) {
    u1 = Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_x[k + 1];
    if ((!(r >= u1)) && (!rtIsNaN(u1))) {
      r = u1;
    }
  }

  /* End of MinMax: '<S46>/MinMax' */

  /* Abs: '<S170>/Abs' */
  rtb_Product4_d = fabs(r);

  /* Switch: '<S170>/Switch' incorporates:
   *  Constant: '<S170>/Constant2'
   *  RelationalOperator: '<S170>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Product4_d) {
    rtb_Sum_e = 2.2204460492503131E-16;
  } else {
    rtb_Sum_e = r;
  }

  /* End of Switch: '<S170>/Switch' */

  /* Saturate: '<S46>/Saturation3' */
  if (Gen2_ref_B->BusInput3.eng.rNum_WGV > 1.0) {
    r = 1.0;
  } else if (Gen2_ref_B->BusInput3.eng.rNum_WGV < 0.0) {
    r = 0.0;
  } else {
    r = Gen2_ref_B->BusInput3.eng.rNum_WGV;
  }

  /* End of Saturate: '<S46>/Saturation3' */

  /* Product: '<S46>/Divide2' incorporates:
   *  Product: '<S46>/Divide'
   */
  rtb_Switch2_by = rtb_Divide2_f / rtb_Sum_e * r;

  /* Switch: '<S1>/Switch2' incorporates:
   *  Constant: '<S1>/max_PR2'
   */
  if (Gen2_ref_B->BusInput3.bdcWgv.bTransWGctrl_FF) {
    r = rtb_Switch2_by;
  } else {
    r = 0.0;
  }

  /* End of Switch: '<S1>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S192>/N_TC_LP_filt' */
  /* DataTypeConversion: '<S4>/Data Type Conversion20' */
  Gen2_ref_N_TC_HP_filt((real_T)Gen2_ref_B->BusInput.rN_TC_LP,
                        Gen2_ref_B->BusInput3.inFilt.rTiF_N, rtb_bResetBdc,
                        &Gen2_ref_B->N_TC_LP_filt, &Gen2_ref_DWork->N_TC_LP_filt, inst);

  /* End of Outputs for SubSystem: '<S192>/N_TC_LP_filt' */

  /* Sum: '<S22>/Sum1' */
  rtb_Divide2_f = Gen2_ref_B->N_TC_LP_filt.Switch -
    Gen2_ref_B->BusInput3.bdcWgv.rTcMaxSpeed;

  /* Gain: '<S22>/Gain' */
  rtb_Gain_kp = 0.001 * rtb_Divide2_f;

  /* DiscreteIntegrator: '<S22>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_dc ||
      (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_jc != 0)) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i = 0.0;
  }

  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i = 0.0;
  }

  /* Switch: '<S22>/Switch' incorporates:
   *  Constant: '<S22>/ON1'
   */
  if (Gen2_ref_B->BusInput3.bdcWgv.bWgvTcOvrspdCtrl) {
    /* Sum: '<S22>/Sum3' incorporates:
     *  DiscreteIntegrator: '<S22>/Discrete-Time Integrator'
     *  Product: '<S22>/Product'
     */
    rtb_Divide2_f = rtb_Gain_kp *
      Gen2_ref_B->BusInput3.bdcWgv.rKpWgvTcOvrspdCtrl +
      Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i;

    /* Saturate: '<S22>/Saturation' */
    if (rtb_Divide2_f > 1.0) {
      rtb_Divide2_f = 1.0;
    } else if (rtb_Divide2_f < 0.0) {
      rtb_Divide2_f = 0.0;
    }

    /* End of Saturate: '<S22>/Saturation' */
  } else {
    rtb_Divide2_f = 0.0;
  }

  /* End of Switch: '<S22>/Switch' */

  /* Sum: '<S22>/Sum' */
  rtb_Divide2_f += r;

  /* Switch: '<S42>/Switch2' incorporates:
   *  RelationalOperator: '<S42>/LowerRelop1'
   *  RelationalOperator: '<S42>/UpperRelop'
   *  Switch: '<S42>/Switch'
   */
  if (rtb_Divide2_f > Gen2_ref_B->BusInput3.bdcWgv.rPos_max) {
    rtb_Divide2_f = Gen2_ref_B->BusInput3.bdcWgv.rPos_max;
  } else if (rtb_Divide2_f < Gen2_ref_B->BusInput3.bdcWgv.rPos_min) {
    /* Switch: '<S42>/Switch' */
    rtb_Divide2_f = Gen2_ref_B->BusInput3.bdcWgv.rPos_min;
  }

  /* End of Switch: '<S42>/Switch2' */

  /* MATLAB Function: '<S1>/IntegerZOH2' */
  Gen2_ref_IntegerZOH(rtb_Divide2_f, Npred, &Gen2_ref_B->sf_IntegerZOH2,
                      &Gen2_ref_DWork->sf_IntegerZOH2, inst);

  /* Switch: '<Root>/BDC_traj1' incorporates:
   *  Switch: '<Root>/BDC_traj2'
   */
  if (rtb_LogicalOperator) {
    rtb_Divide2_f = rtb_TmpSignalConversionAtSFun_p[0];
    r = rtb_TmpSignalConversionAtSFun_p[0];
  } else {
    rtb_Divide2_f = rtb_TmpSignalConversionAtSFun_p[1];
    r = rtb_TmpSignalConversionAtSFun_p[2];
  }

  /* End of Switch: '<Root>/BDC_traj1' */

  /* Logic: '<S16>/Logical Operator6' */
  rtb_bCBV_min = !Gen2_ref_B->BusInput3.inFilt.bFiltOutput;

  /* SignalConversion generated from: '<S873>/ SFunction ' incorporates:
   *  MATLAB Function: '<S16>/FILTER no delay'
   */
  rtb_Switch_g[0] = rtb_Sum_c;
  rtb_Switch_g[1] = rtb_Switch2_jq;
  rtb_Switch_g[2] = rtb_Product1_fu;
  rtb_Switch_g[3] = Gen2_ref_B->sf_IntegerZOH.y;
  rtb_Switch_g[4] = rtb_TmpSignalConversionAtSFun_p[0];
  rtb_Switch_g[5] = Gen2_ref_B->sf_IntegerZOH2.y;
  rtb_Switch_g[6] = rtb_Divide2_f;
  rtb_Switch_g[7] = r;

  /* MATLAB Function: '<S16>/FILTER no delay' incorporates:
   *  Logic: '<S16>/Logical Operator1'
   */
  if ((!Gen2_ref_DWork->x_not_empty) || (rtb_bCBV_min || rtb_bResetBdc)) {
    for (i = 0; i < 8; i++) {
      Gen2_ref_DWork->x[i] = rtb_Switch_g[i];
    }

    Gen2_ref_DWork->x_not_empty = true;
  }

  if (Gen2_ref_B->BusInput3.eng.Ts > 0.0) {
    if ((Gen2_ref_B->BusInput3.inFilt.rTiF_OUT >= Gen2_ref_B->BusInput3.eng.Ts) ||
        rtIsNaN(Gen2_ref_B->BusInput3.eng.Ts)) {
      rtb_Product4_d = Gen2_ref_B->BusInput3.inFilt.rTiF_OUT;
    } else {
      rtb_Product4_d = Gen2_ref_B->BusInput3.eng.Ts;
    }

    for (i = 0; i < 8; i++) {
      Gen2_ref_DWork->x[i] += (rtb_Switch_g[i] - Gen2_ref_DWork->x[i]) /
        rtb_Product4_d * Gen2_ref_B->BusInput3.eng.Ts;
      rtb_Switch_g[i] = Gen2_ref_DWork->x[i];
    }
  } else {
    for (i = 0; i < 8; i++) {
      Gen2_ref_DWork->x[i] = rtb_Switch_g[i];
    }
  }

  /* Switch: '<S16>/Switch' */
  rtb_Sum_og[0] = rtb_Sum_c;
  rtb_Sum_og[1] = rtb_Switch2_jq;
  rtb_Sum_og[2] = rtb_Product1_fu;
  rtb_Sum_og[3] = Gen2_ref_B->sf_IntegerZOH.y;
  rtb_Sum_og[4] = rtb_TmpSignalConversionAtSFun_p[0];
  rtb_Sum_og[5] = Gen2_ref_B->sf_IntegerZOH2.y;
  rtb_Sum_og[6] = rtb_Divide2_f;
  rtb_Sum_og[7] = r;
  for (i = 0; i < 8; i++) {
    rtb_Divide2_f = rtb_Switch_g[i];
    if (rtb_bCBV_min) {
      rtb_Divide2_f = rtb_Sum_og[i];
    }

    rtb_Switch_g[i] = rtb_Divide2_f;
  }

  /* End of Switch: '<S16>/Switch' */

  /* Gain: '<S430>/bar2mbar1' */
  r = rtb_mbar2pa_i;

  /* Sum: '<S8>/Sum' */
  rtb_Divide2_f = rtb_Product1_c1_tmp;

  /* Switch: '<S422>/Switch' incorporates:
   *  Constant: '<S422>/Constant4'
   *  Logic: '<S422>/Logical Operator2'
   *  RelationalOperator: '<S422>/Relational Operator'
   */
  if ((rtb_Divide2_f > Gen2_ref_B->BusInput3.SpeedCtrl.rOutOfNWindow) &&
      Gen2_ref_B->BusInput3.SpeedCtrl.bScaleLeanoxErrorEnrichment) {
    /* Product: '<S422>/Product8' incorporates:
     *  Constant: '<S422>/Constant'
     *  DataTypeConversion: '<S4>/Data Type Conversion28'
     *  Product: '<S422>/Product5'
     *  Sum: '<S14>/Sum10'
     *  Sum: '<S422>/Sum3'
     *  Sum: '<S8>/Sum2'
     */
    rtb_Divide2_f = (((Gen2_ref_B->BusInput.rOffsetLamLimit + rtb_PactOut_o) +
                      rtb_Sum4_ny) * rtb_Sum1_idx_2 + 1.0) * rtb_Switch_i5[0];

    /* Saturate: '<S422>/Saturation1' */
    if (rtb_Divide2_f <= 1.0) {
      rtb_Divide2_f = 1.0;
    }

    /* End of Saturate: '<S422>/Saturation1' */

    /* Product: '<S422>/Divide' incorporates:
     *  Constant: '<S422>/Constant'
     *  Product: '<S422>/Product3'
     *  Product: '<S422>/Product7'
     *  Sum: '<S422>/Sum2'
     */
    rtb_Divide2_f = (rtb_Sum2_kg * rtb_Sum1_idx_2 + 1.0) *
      Gen2_ref_B->BusInput3.eng.rN_Nom / rtb_Divide2_f;

    /* Saturate: '<S422>/Saturation' */
    if (rtb_Divide2_f > 1.0) {
      rtb_Divide2_f = 1.0;
    } else if (rtb_Divide2_f < 0.1) {
      rtb_Divide2_f = 0.1;
    }

    /* End of Saturate: '<S422>/Saturation' */
  } else {
    rtb_Divide2_f = 1.0;
  }

  /* End of Switch: '<S422>/Switch' */

  /* Product: '<S8>/Product' */
  rtb_Product4_d = rtb_Gain1_fr * Gen2_ref_B->BusInput3.SpeedCtrl.rFactProt;

  /* Gain: '<S423>/W2kW' incorporates:
   *  Sum: '<S8>/Sum1'
   */
  rtb_Sum4_ny = (rtb_Switch_i5[3] - rtb_Product4_d) * 0.001;

  /* Switch: '<S476>/Switch2' incorporates:
   *  RelationalOperator: '<S476>/LowerRelop1'
   */
  if (rtb_Sum4_ny > Gen2_ref_B->BusInput3.eng.rP_Nom) {
    rtb_Sum_c = Gen2_ref_B->BusInput3.eng.rP_Nom;
  } else {
    /* Product: '<S473>/Divide6' */
    rtb_Sum_c = Gen2_ref_B->BusInput3.eng.rP_Nom *
      Gen2_ref_B->BusInput3.leanox.rP_P2sRedIP_SP_Norm;

    /* Switch: '<S476>/Switch' incorporates:
     *  RelationalOperator: '<S476>/UpperRelop'
     */
    if (!(rtb_Sum4_ny < rtb_Sum_c)) {
      rtb_Sum_c = rtb_Sum4_ny;
    }

    /* End of Switch: '<S476>/Switch' */
  }

  /* End of Switch: '<S476>/Switch2' */

  /* MATLAB Function: '<S473>/2-point interpolation, with extrapolation' */
  upointinterpolationwithextrapol(rtb_Sum_c,
    Gen2_ref_B->BusInput3.leanox.Comp_IgnP_x,
    Gen2_ref_B->BusInput3.leanox.Comp_IgnP_y,
    &Gen2_ref_B->sf_2pointinterpolationwithext_j, inst);

  /* Switch: '<S473>/Switch1' incorporates:
   *  Constant: '<S473>/Pel_a (kW)1'
   *  DataTypeConversion: '<S4>/Data Type Conversion22'
   *  Product: '<S473>/Divide5'
   *  Sum: '<S473>/Add12'
   */
  if (Gen2_ref_B->BusInput3.leanox.bZZPKorr) {
    rtb_Product4_d = (Gen2_ref_B->BusInput.rCA_Ign_OP_Power -
                      Gen2_ref_B->N_TC_HP_filt.Switch) *
      Gen2_ref_B->sf_2pointinterpolationwithext_j.y;
  } else {
    rtb_Product4_d = 0.0;
  }

  /* End of Switch: '<S473>/Switch1' */

  /* Switch: '<S477>/Switch2' incorporates:
   *  RelationalOperator: '<S477>/LowerRelop1'
   */
  if (rtb_Sum4_ny > Gen2_ref_B->BusInput3.eng.rP_Nom) {
    rtb_Sum_c = Gen2_ref_B->BusInput3.eng.rP_Nom;
  } else {
    /* Product: '<S473>/Divide1' */
    rtb_Sum_c = Gen2_ref_B->BusInput3.eng.rP_Nom *
      Gen2_ref_B->BusInput3.leanox.rP2s_Comp_Act_SP;

    /* Switch: '<S477>/Switch' incorporates:
     *  RelationalOperator: '<S477>/UpperRelop'
     */
    if (!(rtb_Sum4_ny < rtb_Sum_c)) {
      rtb_Sum_c = rtb_Sum4_ny;
    }

    /* End of Switch: '<S477>/Switch' */
  }

  /* End of Switch: '<S477>/Switch2' */

  /* MATLAB Function: '<S473>/2-point interpolation, with extrapolation1' */
  upointinterpolationwithextrapol(rtb_Sum_c,
    Gen2_ref_B->BusInput3.leanox.Comp_ChTmp_x,
    Gen2_ref_B->BusInput3.leanox.Comp_ChTmp_y,
    &Gen2_ref_B->sf_2pointinterpolationwithext_o, inst);

  /* Switch: '<S473>/Switch3' incorporates:
   *  Constant: '<S473>/Pel_a (kW)3'
   */
  if (Gen2_ref_B->BusInput3.leanox.bHum_Act) {
    rtb_Sum1_dh = Gen2_ref_B->BusInput3.leanox.rP2s_Comp_HumOffset;
  } else {
    rtb_Sum1_dh = 0.0;
  }

  /* End of Switch: '<S473>/Switch3' */

  /* Switch: '<S473>/Switch2' incorporates:
   *  Constant: '<S473>/Pel_a (kW)2'
   *  Product: '<S473>/Divide9'
   *  Sum: '<S473>/Add13'
   */
  if (Gen2_ref_B->BusInput3.leanox.bt2Korr) {
    rtb_bResetHlci_0 = (Gen2_ref_B->T2s_filt.Switch -
                        Gen2_ref_B->BusInput3.leanox.rT_2) *
      Gen2_ref_B->sf_2pointinterpolationwithext_o.y;
  } else {
    rtb_bResetHlci_0 = 0.0;
  }

  /* End of Switch: '<S473>/Switch2' */

  /* Sum: '<S459>/Add11' */
  rtb_Sum_c = (rtb_Product4_d + rtb_bResetHlci_0) + rtb_Sum1_dh;

  /* Switch: '<S423>/Switch1' incorporates:
   *  Product: '<S423>/Divide6'
   *  Sum: '<S423>/Add4'
   */
  if (Gen2_ref_B->BusInput.tLEANOXin.bZylAusfall) {
    /* Switch: '<S455>/Switch' incorporates:
     *  Abs: '<S455>/Abs'
     *  Constant: '<S455>/Constant2'
     *  RelationalOperator: '<S455>/Relational Operator'
     */
    if (1.0 >= fabs(Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng)) {
      rtb_bResetHlci_0 = 1.0;
    } else {
      rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
    }

    /* End of Switch: '<S455>/Switch' */
    rtb_Switch2_jq = rtb_Sum4_ny / rtb_bResetHlci_0 + rtb_Sum4_ny;
  } else {
    rtb_Switch2_jq = rtb_Sum4_ny;
  }

  /* End of Switch: '<S423>/Switch1' */

  /* Abs: '<S446>/Abs' */
  rtb_Product4_d = fabs(rtb_Switch_i5[0]);

  /* Switch: '<S446>/Switch' incorporates:
   *  Constant: '<S446>/Constant2'
   *  RelationalOperator: '<S446>/Relational Operator'
   */
  if (1.0 >= rtb_Product4_d) {
    rtb_MinMax_a = 1.0;
  } else {
    rtb_MinMax_a = rtb_Switch_i5[0];
  }

  /* End of Switch: '<S446>/Switch' */

  /* Switch: '<S423>/Switch4' */
  if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena) {
    rtb_Product4_d = Gen2_ref_B->BusInput3.leanox.rP_c;
  } else {
    rtb_Product4_d = Gen2_ref_B->BusInput3.leanox.rP_1;
  }

  /* End of Switch: '<S423>/Switch4' */

  /* Switch: '<S423>/Switch2' incorporates:
   *  Logic: '<S423>/Logical Operator1'
   *  Product: '<S423>/Divide4'
   *  RelationalOperator: '<S423>/Relational Operator1'
   *  RelationalOperator: '<S423>/Relational Operator3'
   *  Sum: '<S423>/Add5'
   *  Switch: '<S423>/Switch5'
   */
  if (rtb_Switch2_jq < rtb_Product4_d) {
    /* Switch: '<S423>/Switch_b_c' incorporates:
     *  Logic: '<S423>/Logical Operator'
     *  RelationalOperator: '<S423>/Relational Operator2'
     */
    if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena && (rtb_Switch2_jq <
         Gen2_ref_B->BusInput3.leanox.rP_c)) {
      /* SignalConversion generated from: '<S423>/Lookup Table Dynamic1' */
      rtb_TmpSignalConversionAtLoo_ht[0] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_0;

      /* Switch: '<S456>/Switch' incorporates:
       *  Abs: '<S456>/Abs'
       *  Constant: '<S456>/Constant2'
       *  RelationalOperator: '<S456>/Relational Operator'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_c)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_c;
      }

      /* End of Switch: '<S456>/Switch' */

      /* SignalConversion generated from: '<S423>/Lookup Table Dynamic1' incorporates:
       *  Product: '<S423>/Divide5'
       */
      rtb_TmpSignalConversionAtLoo_ht[1] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_c *
        Gen2_ref_B->BusInput3.leanox.rN_c / rtb_bResetHlci_0 *
        Gen2_ref_B->T2s_filt.Switch / rtb_MinMax_a;

      /* SignalConversion generated from: '<S423>/Lookup Table Dynamic1' incorporates:
       *  Constant: '<S423>/Pel_a (kW)1'
       */
      rtb_TmpSignalConversionAtLook_d[0] = 0.0;
      rtb_TmpSignalConversionAtLook_d[1] = Gen2_ref_B->BusInput3.leanox.rP_c;

      /* S-Function (sfix_look1_dyn): '<S423>/Lookup Table Dynamic1' */
      /* Dynamic Look-Up Table Block: '<S423>/Lookup Table Dynamic1'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_LookupTableDynamic1_o),
                           &rtb_TmpSignalConversionAtLoo_ht[0], rtb_Switch2_jq,
                           &rtb_TmpSignalConversionAtLook_d[0], 1U, inst);
      rtb_Product4_d = rtb_LookupTableDynamic1_o;
    } else {
      /* SignalConversion generated from: '<S423>/Lookup Table Dynamic' */
      rtb_TmpSignalConversionAtLoo_ht[0] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_0;

      /* Switch: '<S454>/Switch' incorporates:
       *  Abs: '<S454>/Abs'
       *  Constant: '<S454>/Constant2'
       *  RelationalOperator: '<S454>/Relational Operator'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_1)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_1;
      }

      /* End of Switch: '<S454>/Switch' */

      /* SignalConversion generated from: '<S423>/Lookup Table Dynamic' incorporates:
       *  Product: '<S423>/Divide1'
       */
      rtb_TmpSignalConversionAtLoo_ht[1] =
        Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
        Gen2_ref_B->BusInput3.leanox.rN_1 / rtb_bResetHlci_0 *
        Gen2_ref_B->T2s_filt.Switch / rtb_MinMax_a;

      /* SignalConversion generated from: '<S423>/Lookup Table Dynamic' incorporates:
       *  Constant: '<S423>/Pel_a (kW)3'
       */
      rtb_TmpSignalConversionAtLook_d[0] = 0.0;
      rtb_TmpSignalConversionAtLook_d[1] = Gen2_ref_B->BusInput3.leanox.rP_1;

      /* S-Function (sfix_look1_dyn): '<S423>/Lookup Table Dynamic' */
      /* Dynamic Look-Up Table Block: '<S423>/Lookup Table Dynamic'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_LookupTableDynamic_nk),
                           &rtb_TmpSignalConversionAtLoo_ht[0], rtb_Switch2_jq,
                           &rtb_TmpSignalConversionAtLook_d[0], 1U, inst);
      rtb_Product4_d = rtb_LookupTableDynamic_nk;
    }

    /* End of Switch: '<S423>/Switch_b_c' */
  } else {
    if (Gen2_ref_B->BusInput3.leanox.bLp_c_Ena && (rtb_Switch2_jq <
         Gen2_ref_B->BusInput3.leanox.rP_1)) {
      /* Sum: '<S423>/Add1' incorporates:
       *  Switch: '<S423>/Switch5'
       */
      rtb_Product4_d = Gen2_ref_B->BusInput3.leanox.rP_1 -
        Gen2_ref_B->BusInput3.leanox.rP_c;

      /* Sum: '<S423>/Sum4' incorporates:
       *  Switch: '<S423>/Switch5'
       */
      rtb_Sum1_dh = Gen2_ref_B->BusInput3.leanox.rP_c +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S449>/Switch' incorporates:
       *  Abs: '<S449>/Abs'
       *  Constant: '<S449>/Constant2'
       *  RelationalOperator: '<S449>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(rtb_Sum1_dh)) {
        rtb_Switch_n = 1.0;
      } else {
        rtb_Switch_n = rtb_Sum1_dh;
      }

      /* End of Switch: '<S449>/Switch' */

      /* Sum: '<S423>/Sum5' incorporates:
       *  Switch: '<S423>/Switch5'
       */
      rtb_Sum1_dh = Gen2_ref_B->BusInput3.leanox.rP_1 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S457>/Switch' incorporates:
       *  Abs: '<S457>/Abs'
       *  Constant: '<S457>/Constant2'
       *  RelationalOperator: '<S457>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_1)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_1;
      }

      /* End of Switch: '<S457>/Switch' */

      /* Switch: '<S448>/Switch' incorporates:
       *  Abs: '<S448>/Abs'
       *  Constant: '<S448>/Constant2'
       *  RelationalOperator: '<S448>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(rtb_Sum1_dh)) {
        rtb_Sum1_dh = 1.0;
      }

      /* End of Switch: '<S448>/Switch' */

      /* Product: '<S423>/rKK3' incorporates:
       *  Switch: '<S423>/Switch5'
       */
      rtb_Sum1_dh = Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
        Gen2_ref_B->BusInput3.leanox.rN_1 / rtb_bResetHlci_0 / rtb_Sum1_dh;

      /* Switch: '<S450>/Switch' incorporates:
       *  Abs: '<S450>/Abs'
       *  Constant: '<S450>/Constant2'
       *  RelationalOperator: '<S450>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_c)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_c;
      }

      /* End of Switch: '<S450>/Switch' */

      /* Switch: '<S458>/Switch' incorporates:
       *  Abs: '<S458>/Abs'
       *  Constant: '<S458>/Constant2'
       *  RelationalOperator: '<S458>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(rtb_Product4_d)) {
        rtb_Product4_d = 1.0;
      }

      /* End of Switch: '<S458>/Switch' */

      /* Switch: '<S423>/Switch5' incorporates:
       *  Product: '<S423>/Divide10'
       *  Product: '<S423>/Divide9'
       *  Product: '<S423>/rKK4'
       *  Sum: '<S423>/Add3'
       *  Sum: '<S423>/Sum6'
       *  Sum: '<S423>/Sum7'
       */
      rtb_Sum4_ny = (rtb_Sum1_dh - Gen2_ref_B->BusInput3.leanox.rPr_mbar_c *
                     Gen2_ref_B->BusInput3.leanox.rN_c / rtb_bResetHlci_0 /
                     rtb_Switch_n) / rtb_Product4_d * (rtb_Sum4_ny -
        Gen2_ref_B->BusInput3.leanox.rP_1) + rtb_Sum1_dh;
    } else {
      /* Sum: '<S423>/Add10' incorporates:
       *  Switch: '<S423>/Switch5'
       */
      rtb_Product4_d = Gen2_ref_B->BusInput3.leanox.rP_2 -
        Gen2_ref_B->BusInput3.leanox.rP_1;

      /* Sum: '<S423>/Sum' incorporates:
       *  Switch: '<S423>/Switch5'
       */
      rtb_Switch_n = Gen2_ref_B->BusInput3.leanox.rP_1 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Sum: '<S423>/Sum1' incorporates:
       *  Switch: '<S423>/Switch5'
       */
      rtb_Sum1_dh = Gen2_ref_B->BusInput3.leanox.rP_2 +
        Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict;

      /* Switch: '<S447>/Switch' incorporates:
       *  Abs: '<S447>/Abs'
       *  Constant: '<S447>/Constant2'
       *  RelationalOperator: '<S447>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(Gen2_ref_B->BusInput3.leanox.rT_2)) {
        rtb_bResetHlci_0 = 1.0;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.leanox.rT_2;
      }

      /* End of Switch: '<S447>/Switch' */

      /* Switch: '<S452>/Switch' incorporates:
       *  Abs: '<S452>/Abs'
       *  Constant: '<S452>/Constant2'
       *  RelationalOperator: '<S452>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(rtb_Sum1_dh)) {
        rtb_Sum1_dh = 1.0;
      }

      /* End of Switch: '<S452>/Switch' */

      /* Product: '<S423>/rKK1' incorporates:
       *  Switch: '<S423>/Switch5'
       */
      rtb_Sum1_dh = Gen2_ref_B->BusInput3.leanox.rPr_mbar_2 *
        Gen2_ref_B->BusInput3.leanox.rN_2 / rtb_bResetHlci_0 / rtb_Sum1_dh;

      /* Switch: '<S453>/Switch' incorporates:
       *  Abs: '<S453>/Abs'
       *  Constant: '<S453>/Constant2'
       *  RelationalOperator: '<S453>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(rtb_Switch_n)) {
        rtb_Switch_n = 1.0;
      }

      /* End of Switch: '<S453>/Switch' */

      /* Switch: '<S451>/Switch' incorporates:
       *  Abs: '<S451>/Abs'
       *  Constant: '<S451>/Constant2'
       *  RelationalOperator: '<S451>/Relational Operator'
       *  Switch: '<S423>/Switch5'
       */
      if (1.0 >= fabs(rtb_Product4_d)) {
        rtb_Product4_d = 1.0;
      }

      /* End of Switch: '<S451>/Switch' */

      /* Switch: '<S423>/Switch5' incorporates:
       *  Product: '<S423>/Divide2'
       *  Product: '<S423>/Divide3'
       *  Product: '<S423>/rKK2'
       *  Sum: '<S423>/Add2'
       *  Sum: '<S423>/Sum2'
       *  Sum: '<S423>/Sum3'
       */
      rtb_Sum4_ny = (rtb_Sum1_dh - Gen2_ref_B->BusInput3.leanox.rPr_mbar_1 *
                     Gen2_ref_B->BusInput3.leanox.rN_1 /
                     Gen2_ref_B->BusInput3.leanox.rT_1 / rtb_Switch_n) /
        rtb_Product4_d * (rtb_Sum4_ny - Gen2_ref_B->BusInput3.leanox.rP_2) +
        rtb_Sum1_dh;
    }

    rtb_Product4_d = rtb_Sum4_ny * Gen2_ref_B->T2s_filt.Switch *
      (Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict + rtb_Switch2_jq) /
      rtb_MinMax_a;
  }

  /* End of Switch: '<S423>/Switch2' */

  /* Product: '<S459>/Divide8' incorporates:
   *  DataTypeConversion: '<S459>/Data Type Conversion2'
   */
  rtb_Sum4_ny = rtb_Product4_d * Gen2_ref_B->BusInput.tLEANOXin.rLEANOX_fact_BC;

  /* MinMax: '<S459>/MinMax' */
  rtb_Product4_d = rtb_Divide5_h;

  /* Product: '<S459>/Divide5' incorporates:
   *  Delay: '<S15>/Resettable Delay'
   *  Sum: '<S459>/Add9'
   */
  rtb_Divide5_h = ((rtb_Sum_c + rtb_Sum4_ny) +
                   Gen2_ref_DWork->ResettableDelay_DSTATE) * rtb_Product4_d;

  /* DataTypeConversion: '<S459>/Data Type Conversion' */
  rtb_Product4_d = Gen2_ref_B->BusInput.tLEANOXin.rLEANOXoffset;

  /* Gain: '<S459>/mbar2pa' incorporates:
   *  Sum: '<S459>/Add1'
   */
  rtb_mbar2pa_i = (rtb_Divide5_h + rtb_Product4_d) * 100.0;

  /* Sum: '<S430>/Sum2' incorporates:
   *  Gain: '<S430>/pa2mbar'
   *  Product: '<S8>/Product3'
   */
  rtb_Divide2_f = rtb_Divide2_f * rtb_mbar2pa_i * 0.01 +
    Gen2_ref_B->BusInput3.leanox.rPr_Offset_Island;

  /* Switch: '<S624>/Switch2' incorporates:
   *  RelationalOperator: '<S624>/LowerRelop1'
   */
  if (!(rtb_Divide2_f > r)) {
    /* Gain: '<S430>/bar2mbar2' */
    rtb_Divide5_h = 1000.0 * Gen2_ref_B->BusInput3.traj.rPr_p2s_min;

    /* Switch: '<S624>/Switch' incorporates:
     *  RelationalOperator: '<S624>/UpperRelop'
     */
    if (rtb_Divide2_f < rtb_Divide5_h) {
      r = rtb_Divide5_h;
    } else {
      r = rtb_Divide2_f;
    }

    /* End of Switch: '<S624>/Switch' */
  }

  /* End of Switch: '<S624>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S8>/Filter' */
  /* Gain: '<S430>/mbar2pa1' */
  Gen2_ref_Pd_filt(100.0 * r, Gen2_ref_B->BusInput3.SpeedCtrl.rTi_p2s_LEANOX,
                   rtb_Switch_i5[5], rtb_bResetHlci, &Gen2_ref_B->Filter_k,
                   &Gen2_ref_DWork->Filter_k, inst);

  /* End of Outputs for SubSystem: '<S8>/Filter' */

  /* Switch: '<Root>/BDC_traj4' */
  if (rtb_LogicalOperator) {
    r = rtb_Pa2bar_k;
  } else {
    r = Gen2_ref_B->Filter_k.Switch;
  }

  /* End of Switch: '<Root>/BDC_traj4' */

  /* Gain: '<S16>/Pa2bar1' */
  rtb_Sum_e = 1.0E-5 * r;

  /* Gain: '<S889>/Gain' */
  r = 0.001 * Gen2_ref_B->Pel_filt.Switch;

  /* Sum: '<S889>/Sum' */
  rtb_Divide2_f = Gen2_ref_B->BusInput3.SkipF.rNum_max_P1 -
    Gen2_ref_B->BusInput3.SkipF.rNum_max_P0;

  /* Sum: '<S889>/Sum1' */
  rtb_Product4_d = Gen2_ref_B->BusInput3.SkipF.rP_max_1 -
    Gen2_ref_B->BusInput3.SkipF.rP_max_0;

  /* Switch: '<S904>/Switch' incorporates:
   *  Abs: '<S904>/Abs'
   *  Constant: '<S904>/Constant2'
   *  RelationalOperator: '<S904>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= fabs(rtb_Product4_d)) {
    rtb_Product4_d = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S904>/Switch' */

  /* Sum: '<S889>/Sum3' incorporates:
   *  Product: '<S889>/Divide'
   *  Sum: '<S889>/Sum2'
   */
  rtb_Divide2_f = (r - Gen2_ref_B->BusInput3.SkipF.rP_max_0) * rtb_Divide2_f /
    rtb_Product4_d + Gen2_ref_B->BusInput3.SkipF.rNum_max_P0;

  /* Switch: '<S905>/Switch2' incorporates:
   *  Constant: '<S889>/Constant5'
   *  RelationalOperator: '<S905>/LowerRelop1'
   *  RelationalOperator: '<S905>/UpperRelop'
   *  Switch: '<S905>/Switch'
   */
  if (rtb_Divide2_f > Gen2_ref_B->BusInput3.SkipF.rNum_max) {
    r = Gen2_ref_B->BusInput3.SkipF.rNum_max;
  } else if (rtb_Divide2_f < 0.0) {
    /* Switch: '<S905>/Switch' incorporates:
     *  Constant: '<S889>/Constant5'
     */
    r = 0.0;
  } else {
    r = rtb_Divide2_f;
  }

  /* End of Switch: '<S905>/Switch2' */

  /* Rounding: '<S889>/Rounding Function' */
  rtb_RoundingFunction = rt_roundd_snf(r, inst);

  /* Gain: '<S427>/Gain9' incorporates:
   *  Gain: '<S427>/Gain10'
   *  Gain: '<S427>/Gain11'
   */
  r = 0.001 * Gen2_ref_B->BusInput3.LR.iTime_Eng_Cyc;

  /* Bias: '<S427>/ u+Ts1' incorporates:
   *  Product: '<S427>/Product1'
   */
  rtb_Divide2_f = r * Gen2_ref_B->BusInput3.LR.iCyc_Ign_Max_Off + 0.01;

  /* Outputs for Atomic SubSystem: '<S427>/TP_Misfire_ON' */
  /* Logic: '<S427>/Logical Operator3' incorporates:
   *  Delay: '<S427>/Delay'
   *  Logic: '<S427>/Logical Operator24'
   *  RelationalOperator: '<S427>/Relational Operator1'
   *  RelationalOperator: '<S427>/Relational Operator6'
   *  UnitDelay: '<S427>/Unit Delay5'
   */
  Gen2_ref_TP_ActSat_CBV(((!Gen2_ref_DWork->TOF_2_state) &&
    rtb_RelationalOperator2_j && (Gen2_ref_DWork->Delay_DSTATE[0] >=
    Gen2_ref_B->BusInput3.LR.rP_LR_Trig_Misf) && (rtb_Saturation >
    Gen2_ref_B->BusInput3.LR.rP_LR_Trig_Misf) &&
    Gen2_ref_B->BusInput3.LR.bP_LoadReject_Active), rtb_Divide2_f,
    &Gen2_ref_B->TP_Misfire_ON, &Gen2_ref_DWork->TP_Misfire_ON, inst);

  /* End of Outputs for SubSystem: '<S427>/TP_Misfire_ON' */

  /* Bias: '<S427>/ u+Ts8' incorporates:
   *  Product: '<S427>/Product2'
   */
  rtb_Divide5_h = r * Gen2_ref_B->BusInput3.LR.iCyc_Ign_Min_On + 0.01;

  /* Outputs for Atomic SubSystem: '<S427>/TP_Misfire_OFF' */
  /* Logic: '<S427>/Logical Operator6' */
  Gen2_ref_TP_ActSat_CBV(!Gen2_ref_B->TP_Misfire_ON.LogicalOperator1,
    rtb_Divide5_h, &Gen2_ref_B->TP_Misfire_OFF, &Gen2_ref_DWork->TP_Misfire_OFF, inst);

  /* End of Outputs for SubSystem: '<S427>/TP_Misfire_OFF' */

  /* Logic: '<S427>/Logical Operator8' incorporates:
   *  Logic: '<S427>/Logical Operator18'
   *  Switch: '<S427>/Switch'
   */
  rtb_bCBV_min = !Gen2_ref_B->TP_Misfire_OFF.LogicalOperator1;

  /* Outputs for Atomic SubSystem: '<S427>/TP_Misfire_OFF1' */
  /* Sum: '<S427>/Sum' incorporates:
   *  Gain: '<S427>/Gain12'
   */
  Gen2_ref_TP_ActSat_CBV(Gen2_ref_B->TP_Misfire_ON.LogicalOperator1, 2.0 *
    rtb_Divide2_f + rtb_Divide5_h, &Gen2_ref_B->TP_Misfire_OFF1,
    &Gen2_ref_DWork->TP_Misfire_OFF1, inst);

  /* End of Outputs for SubSystem: '<S427>/TP_Misfire_OFF1' */

  /* Switch: '<S427>/Switch2' incorporates:
   *  Constant: '<S427>/Constant1'
   *  Logic: '<S427>/Logical Operator19'
   *  Logic: '<S427>/Logical Operator5'
   *  UnitDelay: '<S427>/Unit Delay2'
   *  UnitDelay: '<S427>/Unit Delay3'
   */
  if (Gen2_ref_B->TP_Misfire_ON.LogicalOperator1) {
    rtb_dbg_HLCi = true;
  } else {
    rtb_dbg_HLCi = (Gen2_ref_B->TP_Misfire_OFF1.LogicalOperator1 &&
                    (!Gen2_ref_DWork->UnitDelay3_DSTATE_h5) &&
                    Gen2_ref_DWork->UnitDelay2_DSTATE_hh);
  }

  /* End of Switch: '<S427>/Switch2' */

  /* Switch: '<S427>/Switch' incorporates:
   *  Constant: '<S427>/Constant4'
   *  DataTypeConversion: '<S4>/Data Type Conversion34'
   *  Logic: '<S427>/Logical Operator20'
   *  Logic: '<S427>/Logical Operator21'
   *  RelationalOperator: '<S427>/Relational Operator9'
   *  Switch: '<S427>/Switch3'
   */
  if (Gen2_ref_B->BusInput.rN_Eng_LRskipF >
      Gen2_ref_B->BusInput3.LR.rN_Misf_2_Trig) {
    rtb_LogicalOperator2_ov = (rtb_bCBV_min &&
      (!Gen2_ref_B->TP_Misfire_ON.LogicalOperator1) && rtb_dbg_HLCi);
  } else {
    rtb_LogicalOperator2_ov = false;
  }

  /* Outputs for Atomic SubSystem: '<S427>/TP_Misfire_ON_2nd time' */
  /* Bias: '<S427>/ u+Ts9' incorporates:
   *  Product: '<S427>/Product3'
   */
  Gen2_ref_TP_ActSat_CBV(rtb_LogicalOperator2_ov, r *
    Gen2_ref_B->BusInput3.LR.iCyc_Ign_Max_Off + 0.01,
    &Gen2_ref_B->TP_Misfire_ON_2ndtime, &Gen2_ref_DWork->TP_Misfire_ON_2ndtime, inst);

  /* End of Outputs for SubSystem: '<S427>/TP_Misfire_ON_2nd time' */

  /* Outputs for Atomic SubSystem: '<S427>/TP_Misfire_OFF2' */
  /* Logic: '<S427>/Logical Operator22' */
  Gen2_ref_TP_ActSat_CBV(!Gen2_ref_B->TP_Misfire_ON_2ndtime.LogicalOperator1,
    rtb_Divide5_h, &Gen2_ref_B->TP_Misfire_OFF2,
    &Gen2_ref_DWork->TP_Misfire_OFF2, inst);

  /* End of Outputs for SubSystem: '<S427>/TP_Misfire_OFF2' */

  /* Logic: '<S427>/Logical Operator23' */
  rtb_bTV_sat = !Gen2_ref_B->TP_Misfire_OFF2.LogicalOperator1;

  /* Logic: '<S427>/Logical Operator9' incorporates:
   *  Logic: '<S427>/Logical Operator10'
   *  Logic: '<S427>/Logical Operator7'
   *  Logic: '<S427>/Logical Operator8'
   */
  rtb_bCBV_min = ((Gen2_ref_B->TP_Misfire_ON.LogicalOperator1 && rtb_bCBV_min &&
                   rtb_bTV_sat) || (rtb_bCBV_min &&
    Gen2_ref_B->TP_Misfire_ON_2ndtime.LogicalOperator1 && rtb_bTV_sat));

  /* Switch: '<S19>/Switch2' incorporates:
   *  Constant: '<S19>/Constant2'
   */
  if (rtb_bCBV_min) {
    rtb_Switch2_d1 = rtb_RoundingFunction;
  } else {
    rtb_Switch2_d1 = 0.0;
  }

  /* End of Switch: '<S19>/Switch2' */

  /* Gain: '<S896>/Gain5' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion16'
   *  Sum: '<S19>/Sum'
   */
  rtb_Divide2_f = -(Gen2_ref_B->BusInput.rN_Set - rtb_DataTypeConversion15);

  /* Switch: '<S907>/Switch2' incorporates:
   *  Constant: '<S896>/  1'
   *  RelationalOperator: '<S907>/LowerRelop1'
   *  RelationalOperator: '<S907>/UpperRelop'
   *  Switch: '<S907>/Switch'
   */
  if (rtb_Divide2_f > 500.0) {
    r = 500.0;
  } else if (rtb_Divide2_f < Gen2_ref_B->BusInput3.SkipF.rN_Active_Lim) {
    /* Switch: '<S907>/Switch' */
    r = Gen2_ref_B->BusInput3.SkipF.rN_Active_Lim;
  } else {
    r = rtb_Divide2_f;
  }

  /* End of Switch: '<S907>/Switch2' */

  /* Product: '<S896>/Product1' incorporates:
   *  Sum: '<S896>/Sum3'
   */
  rtb_Product1_mqz = (r - Gen2_ref_B->BusInput3.SkipF.rN_Active_Lim) *
    Gen2_ref_B->BusInput3.SkipF.rKp;

  /* Outputs for Atomic SubSystem: '<S19>/Filter' */
  Gen2_ref_Filter3(rtb_Product1_mqz, Gen2_ref_B->BusInput3.SkipF.rTiF_Num,
                   Gen2_ref_ConstB.x0_f, rtb_bResetBdc, &Gen2_ref_B->Filter_mn,
                   &Gen2_ref_DWork->Filter_mn, inst);

  /* End of Outputs for SubSystem: '<S19>/Filter' */

  /* Switch: '<S19>/Switch1' incorporates:
   *  Constant: '<S19>/  1'
   *  Logic: '<S19>/Logical Operator'
   */
  if (Gen2_ref_B->BusInput3.eng.bPI_engine ||
      Gen2_ref_B->BusInput3.eng.bActive_MisfCtrl) {
    /* Switch: '<S893>/Switch2' incorporates:
     *  Constant: '<S19>/Constant23'
     *  RelationalOperator: '<S893>/LowerRelop1'
     *  RelationalOperator: '<S893>/UpperRelop'
     *  Switch: '<S893>/Switch'
     */
    if (Gen2_ref_B->Filter_mn.Switch > rtb_RoundingFunction) {
      rtb_Divide2_f = rtb_RoundingFunction;
    } else if (Gen2_ref_B->Filter_mn.Switch < 0.0) {
      /* Switch: '<S893>/Switch' incorporates:
       *  Constant: '<S19>/Constant23'
       */
      rtb_Divide2_f = 0.0;
    } else {
      rtb_Divide2_f = Gen2_ref_B->Filter_mn.Switch;
    }

    /* End of Switch: '<S893>/Switch2' */
  } else {
    rtb_Divide2_f = 0.0;
  }

  /* End of Switch: '<S19>/Switch1' */

  /* MATLAB Function: '<S19>/MATLAB Function' */
  Gen2_ref_MATLABFunction_n(rtb_Divide2_f, Gen2_ref_B->BusInput3.SkipF.rHy_eps,
    &Gen2_ref_B->sf_MATLABFunction_i, &Gen2_ref_DWork->sf_MATLABFunction_i, inst);

  /* MATLAB Function: '<S633>/MATLAB Function' */
  Gen2_ref_MATLABFunction_n(rtb_Product_m[3],
    Gen2_ref_B->BusInput3.SkipF.rHy_eps, &Gen2_ref_B->sf_MATLABFunction_kd,
    &Gen2_ref_DWork->sf_MATLABFunction_kd, inst);

  /* Switch: '<S19>/NSkip' incorporates:
   *  Switch: '<S8>/Switch1'
   */
  if (rtb_LogicalOperator) {
    rtb_Divide2_f = rtb_MinMax_n;
  } else {
    if (Gen2_ref_B->BusInput3.SkipF.bSF_ON) {
      /* Switch: '<S8>/Switch9' incorporates:
       *  DataTypeConversion: '<S8>/Data Type Conversion2'
       *  Logic: '<S8>/Logical Operator1'
       *  Product: '<S8>/Product2'
       *  Sum: '<S429>/Sum9'
       *  Switch: '<S8>/Switch1'
       */
      if (!Gen2_ref_B->BusInput3.SpeedCtrl.bSF_OFF_iLQR) {
        rtb_Divide2_f = Gen2_ref_B->sf_MATLABFunction_kd.y;
      } else {
        rtb_Divide2_f = (rtb_Switch2_ba + rtb_Switch5_iq) * (real_T)
          Gen2_ref_B->BusInput3.SkipF.bSF_ON;
      }

      /* End of Switch: '<S8>/Switch9' */
    } else {
      /* Switch: '<S8>/Switch1' incorporates:
       *  Constant: '<S8>/Constant3'
       */
      rtb_Divide2_f = 0.0;
    }

    /* Sum: '<S19>/Sum1' incorporates:
     *  Switch: '<S19>/Switch4'
     */
    rtb_Divide2_f += rtb_Switch2_d1;

    /* Switch: '<S895>/Switch2' incorporates:
     *  Constant: '<S19>/Constant4'
     *  RelationalOperator: '<S895>/LowerRelop1'
     *  RelationalOperator: '<S895>/UpperRelop'
     *  Switch: '<S895>/Switch'
     */
    if (rtb_Divide2_f > rtb_RoundingFunction) {
      rtb_Divide2_f = rtb_RoundingFunction;
    } else if (rtb_Divide2_f < 0.0) {
      /* Switch: '<S895>/Switch' incorporates:
       *  Constant: '<S19>/Constant4'
       */
      rtb_Divide2_f = 0.0;
    }

    /* End of Switch: '<S895>/Switch2' */
  }

  /* End of Switch: '<S19>/NSkip' */

  /* Switch: '<S894>/Switch2' incorporates:
   *  Constant: '<S19>/Constant3'
   *  RelationalOperator: '<S894>/LowerRelop1'
   *  RelationalOperator: '<S894>/UpperRelop'
   *  Switch: '<S894>/Switch'
   */
  if (rtb_Divide2_f > Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng) {
    r = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  } else if (rtb_Divide2_f < 0.0) {
    /* Switch: '<S894>/Switch' incorporates:
     *  Constant: '<S19>/Constant3'
     */
    r = 0.0;
  } else {
    r = rtb_Divide2_f;
  }

  /* End of Switch: '<S894>/Switch2' */

  /* DataTypeConversion: '<S16>/Data Type Conversion9' */
  rtb_bResetHlci_0 = floor(r);
  if (rtIsNaN(rtb_bResetHlci_0) || rtIsInf(rtb_bResetHlci_0)) {
    rtb_bResetHlci_0 = 0.0;
  } else {
    rtb_bResetHlci_0 = fmod(rtb_bResetHlci_0, 65536.0);
  }

  /* BusCreator: '<S16>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S16>/Data Type Conversion9'
   *  Outport: '<Root>/out'
   */
  Gen2_ref_Y->out.iNskip = (int16_T)(rtb_bResetHlci_0 < 0.0 ? (int32_T)(int16_T)
    -(int16_T)(uint16_T)-rtb_bResetHlci_0 : (int32_T)(int16_T)(uint16_T)
    rtb_bResetHlci_0);

  /* Abs: '<S9>/Abs1' */
  rtb_Divide2_f = fabs(Gen2_ref_B->BusInput3.ITC.rITCdeltaMAX);

  /* S-Function (sfix_look1_dyn): '<S634>/Lookup Table Dynamic1' */
  /* Dynamic Look-Up Table Block: '<S634>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_LookupTableDynamic1),
                       &Gen2_ref_B->BusInput3.ITC.rITCtransDeltaAcc_y[0],
                       rtb_Gain3, &Gen2_ref_B->
                       BusInput3.ITC.rITCtransDeltaAcc_x[0], 4U, inst);

  /* Abs: '<S634>/Abs2' incorporates:
   *  Abs: '<S9>/Abs4'
   */
  rtb_Sum4_ny = fabs(Gen2_ref_B->BusInput3.ITC.rITCtransSRback);

  /* Product: '<S708>/delta rise limit' incorporates:
   *  Abs: '<S634>/Abs2'
   *  Gain: '<S634>/Gain2'
   *  Product: '<S811>/delta rise limit'
   *  SampleTimeMath: '<S708>/sample time'
   *
   * About '<S708>/sample time':
   *  y = K where K = ( w * Ts )
   */
  x = 1000.0 * rtb_Sum4_ny * 0.01;
  rtb_Product4_d = x;

  /* Switch: '<S634>/Switch' incorporates:
   *  RelationalOperator: '<S634>/Relational Operator2'
   *  UnitDelay: '<S634>/Unit Delay'
   */
  rtb_bTriger_IT_LJ = ((delta_y_tmp_tmp >
                        Gen2_ref_B->BusInput3.ITC.rITCtransDPthrsh) ||
                       Gen2_ref_DWork->UnitDelay_DSTATE_kx);

  /* Outputs for Atomic SubSystem: '<S634>/Delay Retard' */
  Gen2_ref_TON_1(rtb_bTriger_IT_LJ, Gen2_ref_B->BusInput3.ITC.rITCtransDelay,
                 &Gen2_ref_B->DelayRetard, &Gen2_ref_DWork->DelayRetard, inst);

  /* End of Outputs for SubSystem: '<S634>/Delay Retard' */

  /* Switch: '<S634>/Switch1' incorporates:
   *  Abs: '<S634>/Abs1'
   *  Constant: '<S634>/Constant7'
   */
  if (Gen2_ref_B->DelayRetard.LogicalOperator3) {
    rtb_Sum_c = fabs(rtb_LookupTableDynamic1);
  } else {
    rtb_Sum_c = 0.0;
  }

  /* End of Switch: '<S634>/Switch1' */

  /* Delay: '<S708>/Delay' incorporates:
   *  Constant: '<S634>/Constant3'
   *  Delay: '<S425>/Delay'
   */
  Gen2_ref_DWork->icLoad_nv = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_j ==
    1) != (int32_T)rtb_bResetHlci) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_j != 3)) || rtb_bResetHlci ||
    Gen2_ref_DWork->icLoad_nv);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_j = rtb_bResetHlci;
  if (Gen2_ref_DWork->icLoad_nv) {
    Gen2_ref_DWork->Delay_DSTATE_l = 0.0;
  }

  /* Switch: '<S708>/etaVolConst' incorporates:
   *  Constant: '<S634>/Constant3'
   */
  if (rtb_bResetHlci) {
    rtb_bResetHlci_0 = 0.0;
  } else {
    rtb_bResetHlci_0 = rtb_Sum_c;
  }

  /* End of Switch: '<S708>/etaVolConst' */

  /* Sum: '<S708>/Difference Inputs1' incorporates:
   *  Delay: '<S708>/Delay'
   */
  rtb_Divide5_h = rtb_bResetHlci_0 - Gen2_ref_DWork->Delay_DSTATE_l;

  /* Switch: '<S711>/Switch2' incorporates:
   *  RelationalOperator: '<S711>/LowerRelop1'
   */
  if (!(rtb_Divide5_h > rtb_Product4_d)) {
    /* Product: '<S708>/delta fall limit' incorporates:
     *  Abs: '<S634>/Abs2'
     *  Gain: '<S634>/Gain1'
     *  SampleTimeMath: '<S708>/sample time'
     *
     * About '<S708>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch5_iq = -rtb_Sum4_ny * 0.01;

    /* Switch: '<S711>/Switch' incorporates:
     *  RelationalOperator: '<S711>/UpperRelop'
     */
    if (rtb_Divide5_h < rtb_Switch5_iq) {
      rtb_Product4_d = rtb_Switch5_iq;
    } else {
      rtb_Product4_d = rtb_Divide5_h;
    }

    /* End of Switch: '<S711>/Switch' */
  }

  /* End of Switch: '<S711>/Switch2' */

  /* Sum: '<S708>/Difference Inputs2' incorporates:
   *  Delay: '<S708>/Delay'
   */
  rtb_Divide5_h = rtb_Product4_d + Gen2_ref_DWork->Delay_DSTATE_l;

  /* Signum: '<S634>/Sign' */
  if (rtb_LookupTableDynamic1 < 0.0) {
    rtb_bResetHlci_0 = -1.0;
  } else if (rtb_LookupTableDynamic1 > 0.0) {
    rtb_bResetHlci_0 = 1.0;
  } else if (rtb_LookupTableDynamic1 == 0.0) {
    rtb_bResetHlci_0 = 0.0;
  } else {
    rtb_bResetHlci_0 = (rtNaN);
  }

  /* End of Signum: '<S634>/Sign' */

  /* MinMax: '<S634>/MinMax' */
  if ((rtb_Divide5_h >= rtb_Sum_c) || rtIsNaN(rtb_Sum_c)) {
    rtb_Sum_c = rtb_Divide5_h;
  }

  /* End of MinMax: '<S634>/MinMax' */

  /* Product: '<S634>/Product' */
  rtb_Product4_d = rtb_bResetHlci_0 * rtb_Sum_c;

  /* Sum: '<S431>/Sum' */
  rtb_Sum_c = rtb_Product_m[2] + rtb_Product4_d;

  /* Gain: '<S427>/Gain8' */
  rtb_Sum1_dh = 1000.0 * Gen2_ref_B->BusInput3.LR.rRateITadvance;

  /* Product: '<S524>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S524>/sample time'
   *
   * About '<S524>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Sum1_dh *= 0.01;

  /* Outputs for Atomic SubSystem: '<S427>/TP_Ign retard' */
  /* Logic: '<S427>/Logical Operator4' incorporates:
   *  Bias: '<S427>/ u+Ts2'
   *  Gain: '<S427>/Gain13'
   *  RelationalOperator: '<S427>/Relational Operator2'
   */
  Gen2_ref_TP_ActSat_CBV(((rtb_Saturation >
    Gen2_ref_B->BusInput3.LR.rP_LR_Trig_IGN_Retard) &&
    Gen2_ref_B->BusInput3.LR.bP_LoadReject_Active && rtb_RelationalOperator2_j),
    0.001 * Gen2_ref_B->BusInput3.LR.rTi_LR_IGN_Retard_MAX + 0.01,
    &Gen2_ref_B->TP_Ignretard, &Gen2_ref_DWork->TP_Ignretard, inst);

  /* End of Outputs for SubSystem: '<S427>/TP_Ign retard' */

  /* Logic: '<S427>/Logical Operator12' incorporates:
   *  Logic: '<S427>/Logical Operator13'
   *  RelationalOperator: '<S427>/Relational Operator4'
   *  UnitDelay: '<S427>/Unit Delay'
   */
  rtb_RelationalOperator2_j = (rtb_TOF_IN ||
    Gen2_ref_B->TP_Ignretard.LogicalOperator1 || ((rtb_Divide4_d >
    Gen2_ref_B->BusInput3.LR.rN_LR_IGN_Retard_ON) &&
    Gen2_ref_DWork->UnitDelay_DSTATE_n));

  /* Sum: '<S427>/Sum2' */
  rtb_MinMax_a = Gen2_ref_B->BusInput3.LR.rProt_IGN_Retard_max -
    Gen2_ref_B->BusInput3.LR.rProt_IGN_Retard_min;

  /* Abs: '<S506>/Abs' */
  rtb_Switch_n = fabs(rtb_MinMax_a);

  /* Switch: '<S506>/Switch' incorporates:
   *  Constant: '<S506>/Constant2'
   *  RelationalOperator: '<S506>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch_n) {
    rtb_MinMax_a = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S506>/Switch' */

  /* Sum: '<S427>/Sum4' incorporates:
   *  Product: '<S427>/Divide'
   *  Product: '<S427>/Product'
   *  Sum: '<S427>/Sum1'
   *  Sum: '<S427>/Sum3'
   */
  rtb_Divide4_d = (rtb_Saturation -
                   Gen2_ref_B->BusInput3.LR.rProt_IGN_Retard_min) / rtb_MinMax_a
    * (Gen2_ref_B->BusInput3.LR.rLR_IGN_Retard_IT -
       Gen2_ref_B->BusInput3.LR.rLR_IGN_Retard_IT_min) +
    Gen2_ref_B->BusInput3.LR.rLR_IGN_Retard_IT_min;

  /* Switch: '<S510>/Switch2' incorporates:
   *  RelationalOperator: '<S510>/LowerRelop1'
   *  RelationalOperator: '<S510>/UpperRelop'
   *  Switch: '<S510>/Switch'
   */
  if (rtb_Divide4_d > Gen2_ref_B->BusInput3.LR.rLR_IGN_Retard_IT) {
    rtb_Switch2_jq = Gen2_ref_B->BusInput3.LR.rLR_IGN_Retard_IT;
  } else if (rtb_Divide4_d < Gen2_ref_B->BusInput3.LR.rLR_IGN_Retard_IT_min) {
    /* Switch: '<S510>/Switch' */
    rtb_Switch2_jq = Gen2_ref_B->BusInput3.LR.rLR_IGN_Retard_IT_min;
  } else {
    rtb_Switch2_jq = rtb_Divide4_d;
  }

  /* End of Switch: '<S510>/Switch2' */

  /* Switch: '<S427>/Switch6' incorporates:
   *  UnitDelay: '<S427>/Unit Delay6'
   */
  if (rtb_RelationalOperator2_j) {
    rtb_MinMax_a = Gen2_ref_DWork->UnitDelay6_DSTATE_m;
  } else {
    rtb_MinMax_a = rtb_Switch2_jq;
  }

  /* End of Switch: '<S427>/Switch6' */

  /* MinMax: '<S427>/MinMax1' */
  if ((rtb_MinMax_a >= rtb_Switch2_jq) || rtIsNaN(rtb_Switch2_jq)) {
    rtb_Divide4_d = rtb_MinMax_a;
  } else {
    rtb_Divide4_d = rtb_Switch2_jq;
  }

  /* End of MinMax: '<S427>/MinMax1' */

  /* Switch: '<S427>/Ign retard type 6' incorporates:
   *  Constant: '<S427>/Constant'
   */
  if (rtb_RelationalOperator2_j) {
    rtb_MinMax_a = rtb_Divide4_d;
  } else {
    rtb_MinMax_a = 0.0;
  }

  /* End of Switch: '<S427>/Ign retard type 6' */

  /* Delay: '<S524>/Delay' incorporates:
   *  Constant: '<S427>/Constant2'
   *  Delay: '<S425>/Delay'
   */
  Gen2_ref_DWork->icLoad_dk = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_h ==
    1) != (int32_T)rtb_bResetHlci) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_h != 3)) || rtb_bResetHlci ||
    Gen2_ref_DWork->icLoad_dk);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_h = rtb_bResetHlci;
  if (Gen2_ref_DWork->icLoad_dk) {
    Gen2_ref_DWork->Delay_DSTATE_p = 0.0;
  }

  /* Switch: '<S524>/etaVolConst' incorporates:
   *  Constant: '<S427>/Constant2'
   */
  if (rtb_bResetHlci) {
    rtb_bResetHlci_0 = 0.0;
  } else {
    rtb_bResetHlci_0 = rtb_MinMax_a;
  }

  /* End of Switch: '<S524>/etaVolConst' */

  /* Sum: '<S524>/Difference Inputs1' incorporates:
   *  Delay: '<S524>/Delay'
   */
  rtb_Switch5_iq = rtb_bResetHlci_0 - Gen2_ref_DWork->Delay_DSTATE_p;

  /* Switch: '<S578>/Switch2' incorporates:
   *  RelationalOperator: '<S578>/LowerRelop1'
   */
  if (!(rtb_Switch5_iq > rtb_Sum1_dh)) {
    /* Product: '<S524>/delta fall limit' incorporates:
     *  Gain: '<S427>/Gain7'
     *  SampleTimeMath: '<S524>/sample time'
     *
     * About '<S524>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Sum1_dh = -Gen2_ref_B->BusInput3.LR.rRateITadvance * 0.01;

    /* Switch: '<S578>/Switch' incorporates:
     *  RelationalOperator: '<S578>/UpperRelop'
     */
    if (!(rtb_Switch5_iq < rtb_Sum1_dh)) {
      rtb_Sum1_dh = rtb_Switch5_iq;
    }

    /* End of Switch: '<S578>/Switch' */
  }

  /* End of Switch: '<S578>/Switch2' */

  /* Sum: '<S524>/Difference Inputs2' incorporates:
   *  Delay: '<S524>/Delay'
   */
  rtb_Switch5_iq = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_p;

  /* MinMax: '<S427>/MinMax' */
  if ((rtb_Switch5_iq >= rtb_MinMax_a) || rtIsNaN(rtb_MinMax_a)) {
    rtb_MinMax_a = rtb_Switch5_iq;
  }

  /* End of MinMax: '<S427>/MinMax' */

  /* Gain: '<S9>/Gain5' */
  rtb_Sum1_dh = rtb_kW2W1_h;

  /* S-Function (sfix_look1_dyn): '<S9>/Lookup Table Dynamic1' */
  /* Dynamic Look-Up Table Block: '<S9>/Lookup Table Dynamic1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Switch_n),
                       &Gen2_ref_B->BusInput3.ITC.rITCoffsetP2s_y[0],
                       rtb_Sum1_dh, &Gen2_ref_B->BusInput3.ITC.rITCoffsetP2s_x[0],
                       4U, inst);

  /* Product: '<S811>/delta rise limit' */
  rtb_Sum1_dh = x;

  /* Delay: '<S811>/Delay' incorporates:
   *  Constant: '<S9>/Constant1'
   *  Delay: '<S425>/Delay'
   */
  Gen2_ref_DWork->icLoad_iv = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_bi ==
    1) != (int32_T)rtb_bResetHlci) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_bi != 3)) || rtb_bResetHlci ||
    Gen2_ref_DWork->icLoad_iv);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_bi = rtb_bResetHlci;
  if (Gen2_ref_DWork->icLoad_iv) {
    Gen2_ref_DWork->Delay_DSTATE_i4 = 0.0;
  }

  /* Switch: '<S811>/etaVolConst' incorporates:
   *  Constant: '<S9>/Constant1'
   */
  if (rtb_bResetHlci) {
    rtb_bResetHlci_0 = 0.0;
  } else {
    rtb_bResetHlci_0 = rtb_Switch_n;
  }

  /* End of Switch: '<S811>/etaVolConst' */

  /* Sum: '<S811>/Difference Inputs1' incorporates:
   *  Delay: '<S811>/Delay'
   */
  x = rtb_bResetHlci_0 - Gen2_ref_DWork->Delay_DSTATE_i4;

  /* Switch: '<S812>/Switch2' incorporates:
   *  RelationalOperator: '<S812>/LowerRelop1'
   */
  if (!(x > rtb_Sum1_dh)) {
    /* Product: '<S811>/delta fall limit' incorporates:
     *  Gain: '<S9>/Gain8'
     *  SampleTimeMath: '<S811>/sample time'
     *
     * About '<S811>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Sum4_ny = -rtb_Sum4_ny * 0.01;

    /* Switch: '<S812>/Switch' incorporates:
     *  RelationalOperator: '<S812>/UpperRelop'
     */
    if (x < rtb_Sum4_ny) {
      rtb_Sum1_dh = rtb_Sum4_ny;
    } else {
      rtb_Sum1_dh = x;
    }

    /* End of Switch: '<S812>/Switch' */
  }

  /* End of Switch: '<S812>/Switch2' */

  /* Sum: '<S811>/Difference Inputs2' incorporates:
   *  Delay: '<S811>/Delay'
   */
  rtb_Sum4_ny = rtb_Sum1_dh + Gen2_ref_DWork->Delay_DSTATE_i4;

  /* MinMax: '<S9>/MinMax2' */
  if ((!(rtb_Switch_n >= rtb_Sum4_ny)) && (!rtIsNaN(rtb_Sum4_ny))) {
    rtb_Switch_n = rtb_Sum4_ny;
  }

  /* End of MinMax: '<S9>/MinMax2' */

  /* Sum: '<S9>/Sum1' incorporates:
   *  Gain: '<S9>/Gain'
   *  Gain: '<S9>/Gain3'
   *  Sum: '<S8>/Sum3'
   */
  rtb_Sum1_dh = -(rtb_Sum_c + rtb_MinMax_a) + -rtb_Switch_n;

  /* Switch: '<S9>/deltaIT' incorporates:
   *  Constant: '<S807>/Constant'
   *  Constant: '<S9>/Constant'
   *  RelationalOperator: '<S807>/Compare'
   */
  if (Gen2_ref_B->BusInput.iOpMode < 60) {
    rtb_Switch_n = 0.0;
  } else {
    rtb_Switch_n = rtb_Sum1_dh;
  }

  /* End of Switch: '<S9>/deltaIT' */

  /* Switch: '<S810>/Switch2' incorporates:
   *  RelationalOperator: '<S810>/LowerRelop1'
   */
  if (!(rtb_Switch_n > rtb_Divide2_f)) {
    /* Gain: '<S9>/Gain4' incorporates:
     *  Abs: '<S9>/Abs'
     */
    rtb_Divide2_f = -fabs(Gen2_ref_B->BusInput3.ITC.rITCdeltaMIN);

    /* Switch: '<S810>/Switch' incorporates:
     *  RelationalOperator: '<S810>/UpperRelop'
     */
    if (!(rtb_Switch_n < rtb_Divide2_f)) {
      rtb_Divide2_f = rtb_Switch_n;
    }

    /* End of Switch: '<S810>/Switch' */
  }

  /* End of Switch: '<S810>/Switch2' */

  /* BusCreator: '<S16>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S16>/Data Type Conversion10'
   *  Outport: '<Root>/out'
   */
  Gen2_ref_Y->out.rdeltaIT = (real32_T)rtb_Divide2_f;

  /* Gain: '<S16>/W2kW' */
  rtb_Divide2_f = rtb_PactOut_tmp;

  /* BusCreator: '<S16>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S16>/Data Type Conversion4'
   *  Outport: '<Root>/out'
   */
  Gen2_ref_Y->out.rP_des = (real32_T)rtb_Divide2_f;

  /* Switch: '<S14>/Switch1' */
  for (i = 0; i < 10; i++) {
    if (Gen2_ref_B->BusInput3.LamLim.bNOx250mg) {
      Gen2_ref_Y->out.rLamMap[i] = Gen2_ref_B->
        BusInput3.LamLim.rLamMapBase250mg[i];
    } else {
      Gen2_ref_Y->out.rLamMap[i] = Gen2_ref_B->BusInput3.LamLim.rLamMapBase[i];
    }
  }

  /* End of Switch: '<S14>/Switch1' */

  /* DataTypeConversion: '<S16>/Data Type Conversion21' */
  for (i = 0; i < 13; i++) {
    Gen2_ref_Y->out.rState_Dist1Map[i] = (real32_T)rtb_y_map_new[i];
  }

  /* End of DataTypeConversion: '<S16>/Data Type Conversion21' */

  /* Switch: '<S12>/Switch7' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bUseFilteredFeedback) {
    rtb_Divide2_f = Gen2_ref_B->p2s_filt.Switch;
  } else {
    rtb_Divide2_f = rtb_p2s;
  }

  /* End of Switch: '<S12>/Switch7' */

  /* Gain: '<S815>/Gain6' incorporates:
   *  Gain: '<S12>/Gain3'
   */
  rtb_kW2W1_h = 1.0E-5 * rtb_Divide2_f;

  /* Switch: '<S814>/Switch3' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bMeasPowKeEst) {
    rtb_Switch_n = rtb_Gain2_ao;
  } else {
    rtb_Switch_n = rtb_kW2W;
  }

  /* End of Switch: '<S814>/Switch3' */

  /* Gain: '<S814>/Gain10' */
  x = rtb_Switch2_ejy_tmp;

  /* Sum: '<S814>/Sum3' */
  rtb_kW2W = rtb_Switch_n + x;

  /* Gain: '<S814>/Gain11' */
  rtb_Switch_n = 0.10471975511965977 * rtb_DataTypeConversion15;

  /* Abs: '<S820>/Abs' */
  x = fabs(rtb_Switch_n);

  /* Switch: '<S820>/Switch' incorporates:
   *  Constant: '<S820>/Constant2'
   *  RelationalOperator: '<S820>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= x) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = rtb_Switch_n;
  }

  /* End of Switch: '<S820>/Switch' */

  /* Gain: '<S12>/Gain3' */
  x = rtb_kW2W1_h;

  /* Product: '<S814>/Divide5' */
  rtb_Divide2_f = rtb_Product1_fu * rtb_Sum1_idx_2;

  /* Sum: '<S814>/Sum4' incorporates:
   *  Constant: '<S814>/it_offset_ref2'
   */
  rtb_Divide2_f++;

  /* Abs: '<S821>/Abs' */
  rtb_Switch_n = fabs(rtb_Divide2_f);

  /* Switch: '<S821>/Switch' incorporates:
   *  Constant: '<S821>/Constant2'
   *  RelationalOperator: '<S821>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch_n) {
    rtb_Divide2_f = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S821>/Switch' */

  /* Product: '<S814>/Divide4' */
  rtb_Divide2_f = x / rtb_Divide2_f;

  /* Abs: '<S822>/Abs' */
  rtb_Switch_n = fabs(rtb_Divide2_f);

  /* Switch: '<S822>/Switch' incorporates:
   *  Constant: '<S822>/Constant2'
   *  RelationalOperator: '<S822>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch_n) {
    rtb_Divide2_f = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S822>/Switch' */

  /* Outputs for Atomic SubSystem: '<S814>/Filter1' */
  /* Product: '<S814>/Divide11' incorporates:
   *  Product: '<S814>/Divide3'
   */
  Gen2_ref_N_TC_HP_filt(rtb_kW2W / rtb_bResetHlci_0 / rtb_Divide2_f,
                        Gen2_ref_B->BusInput3.SpeedCtrl.rTiFKeEst,
                        rtb_LogicalOperator_cn, &Gen2_ref_B->Filter1_n,
                        &Gen2_ref_DWork->Filter1_n, inst);

  /* End of Outputs for SubSystem: '<S814>/Filter1' */

  /* Abs: '<S817>/Abs' */
  rtb_Divide2_f = delta_y;

  /* Switch: '<S817>/Switch' incorporates:
   *  Constant: '<S817>/Constant2'
   *  RelationalOperator: '<S817>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Divide2_f) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = Gen2_ref_B->T2s_filt.Switch;
  }

  /* End of Switch: '<S817>/Switch' */

  /* Product: '<S5>/Divide4' incorporates:
   *  Product: '<S268>/Divide3'
   */
  rtb_Switch_n = rtb_Switch_ks * Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2;

  /* Sum: '<S5>/Add3' incorporates:
   *  Constant: '<S11>/Constant'
   *  Sum: '<S11>/Sum'
   */
  x = 1.0 - Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2;

  /* Sum: '<S5>/Add4' incorporates:
   *  Product: '<S267>/Divide3'
   *  Product: '<S5>/Divide5'
   */
  rtb_kW2W = rtb_Divide3_n_tmp * x + rtb_Switch_n;

  /* Abs: '<S816>/Abs' */
  rtb_Switch_n = fabs(rtb_kW2W);

  /* Saturate: '<S813>/Saturation' */
  if (Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng <= 1.0) {
    rtb_Divide2_f = 1.0;
  } else {
    rtb_Divide2_f = Gen2_ref_B->BusInput3.eng.rNum_Cyl_Eng;
  }

  /* End of Saturate: '<S813>/Saturation' */

  /* Product: '<S813>/Divide1' */
  u0 = 1.0 / rtb_Divide2_f * r;

  /* Switch: '<S816>/Switch' incorporates:
   *  Constant: '<S816>/Constant2'
   *  RelationalOperator: '<S816>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch_n) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = rtb_kW2W;
  }

  /* End of Switch: '<S816>/Switch' */

  /* Saturate: '<S813>/Saturation1' */
  if (u0 > 1.0) {
    u0 = 1.0;
  } else if (u0 < 0.0) {
    u0 = 0.0;
  }

  /* End of Saturate: '<S813>/Saturation1' */

  /* Product: '<S813>/Product' incorporates:
   *  Constant: '<S813>/it_offset_ref2'
   *  Gain: '<S813>/Gain1'
   *  Gain: '<S813>/Gain2'
   *  Product: '<S813>/Divide3'
   *  Sum: '<S813>/Sum3'
   */
  r = Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng / delta_y * rtb_etaVolConst_lt *
    rtb_etaBreakConst * rtb_Sum1_idx_3 / rtb_bResetHlci_0 * 0.079577471545947673
    * 100000.0 * (1.0 - u0);

  /* Abs: '<S834>/Abs' */
  rtb_Divide2_f = fabs(r);

  /* Switch: '<S834>/Switch' incorporates:
   *  Constant: '<S834>/Constant2'
   *  RelationalOperator: '<S834>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Divide2_f) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = r;
  }

  /* End of Switch: '<S834>/Switch' */

  /* Product: '<S830>/Product1' */
  rtb_Switch_n = Gen2_ref_B->Filter1_n.Switch / rtb_bResetHlci_0;

  /* Logic: '<S830>/Logical Operator2' */
  rtb_LogicalOperator2_l = (rtb_LogicalOperator_cn || rtb_LogicalOperator2_l);

  /* Delay: '<S830>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_ix = ((rtb_LogicalOperator2_l &&
    (Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_k != 1)) ||
    Gen2_ref_DWork->icLoad_ix);
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_k = rtb_LogicalOperator2_l;
  for (i = 0; i < 13; i++) {
    if (Gen2_ref_DWork->icLoad_ix) {
      Gen2_ref_DWork->ResettableDelay_DSTATE_k[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y[i];
    }

    rtb_Switch3_je[i] = Gen2_ref_DWork->ResettableDelay_DSTATE_k[i];
  }

  /* End of Delay: '<S830>/Resettable Delay' */

  /* S-Function (sfix_look1_dyn): '<S830>/gain scheduling Keng1' */
  /* Dynamic Look-Up Table Block: '<S830>/gain scheduling Keng1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_gainschedulingKeng1_f), &rtb_Switch3_je[0],
                       rtb_kW2W1_h,
                       &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_x[0],
                       12U, inst);

  /* Outputs for Atomic SubSystem: '<S831>/TP' */
  /* UnitDelay: '<S831>/Unit Delay2' incorporates:
   *  SignalConversion generated from: '<S831>/Bus Selector1'
   */
  Gen2_ref_TP(Gen2_ref_DWork->UnitDelay2_DSTATE_i,
              Gen2_ref_B->BusInput3.SpeedCtrl.rTp_KeEst_reset, &Gen2_ref_B->TP_g,
              &Gen2_ref_DWork->TP_g, inst);

  /* End of Outputs for SubSystem: '<S831>/TP' */

  /* Outputs for Atomic SubSystem: '<S831>/TON1' */
  Gen2_ref_TON_1(Gen2_ref_DWork->UnitDelay2_DSTATE_i,
                 Gen2_ref_B->BusInput3.SpeedCtrl.tOutOfNWindow,
                 &Gen2_ref_B->TON1_m, &Gen2_ref_DWork->TON1_m, inst);

  /* End of Outputs for SubSystem: '<S831>/TON1' */

  /* Outputs for Atomic SubSystem: '<S831>/TP1' */
  Gen2_ref_TP(Gen2_ref_DWork->UnitDelay2_DSTATE_i,
              Gen2_ref_B->BusInput3.SpeedCtrl.rT_KeEstIncreaseTiF,
              &Gen2_ref_B->TP1_l, &Gen2_ref_DWork->TP1_l, inst);

  /* End of Outputs for SubSystem: '<S831>/TP1' */

  /* UnitDelay: '<S831>/Unit Delay1' */
  rtb_Divide2_f = Gen2_ref_DWork->UnitDelay1_DSTATE_n;

  /* DataTypeConversion: '<S831>/Data Type Conversion' */
  rtb_bResetHlci_0 = floor(rtb_Divide2_f);
  if (rtIsNaN(rtb_bResetHlci_0) || rtIsInf(rtb_bResetHlci_0)) {
    rtb_bResetHlci_0 = 0.0;
  } else {
    rtb_bResetHlci_0 = fmod(rtb_bResetHlci_0, 65536.0);
  }

  /* Outputs for Atomic SubSystem: '<S831>/TOF' */
  /* RelationalOperator: '<S831>/Relational Operator' incorporates:
   *  DataTypeConversion: '<S831>/Data Type Conversion'
   */
  Gen2_ref_TOF(((rtb_bResetHlci_0 < 0.0 ? (int32_T)(int16_T)-(int16_T)(uint16_T)
                 -rtb_bResetHlci_0 : (int32_T)(int16_T)(uint16_T)
                 rtb_bResetHlci_0) > 0),
               Gen2_ref_B->BusInput3.SpeedCtrl.rTof_KeEstPause_SkipF,
               &Gen2_ref_B->TOF_n, &Gen2_ref_DWork->TOF_n, inst);

  /* End of Outputs for SubSystem: '<S831>/TOF' */

  /* Switch: '<S831>/Switch3' incorporates:
   *  Constant: '<S831>/Constant2'
   *  Switch: '<S831>/Switch1'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeEstIncreaseTiFOFF) {
    rtb_Switch3_le = false;
  } else if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeEstPause_SkipF) {
    /* Switch: '<S831>/Switch1' incorporates:
     *  Logic: '<S831>/Logical Operator3'
     */
    rtb_Switch3_le = (Gen2_ref_B->TP1_l.LogicalOperator1 ||
                      Gen2_ref_B->TOF_n.LogicalOperator1);
  } else {
    /* Switch: '<S831>/Switch1' */
    rtb_Switch3_le = Gen2_ref_B->TP1_l.LogicalOperator1;
  }

  /* End of Switch: '<S831>/Switch3' */

  /* Switch: '<S831>/Switch2' incorporates:
   *  Constant: '<S831>/Constant1'
   *  Logic: '<S831>/Logical Operator4'
   *  Logic: '<S831>/Logical Operator5'
   *  Switch: '<S831>/Switch'
   *  UnitDelay: '<S831>/Unit Delay2'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeEstResetOFF) {
    rtb_LogicalOperator2_ov = false;
  } else if (Gen2_ref_B->BusInput3.SpeedCtrl.bKeEstreset_TP) {
    /* Switch: '<S831>/Switch' */
    rtb_LogicalOperator2_ov = Gen2_ref_B->TP_g.LogicalOperator1;
  } else {
    rtb_LogicalOperator2_ov = (Gen2_ref_DWork->UnitDelay2_DSTATE_i &&
      (!Gen2_ref_B->TON1_m.LogicalOperator3));
  }

  /* End of Switch: '<S831>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S830>/Ke Map Update' */
  Gen2_ref_KeMapUpdate(rtb_Switch_n, rtb_LogicalOperator_cn,
                       rtb_gainschedulingKeng1_f, rtb_Switch3_le,
                       rtb_LogicalOperator2_ov, &Gen2_ref_B->BusInput3,
                       &Gen2_ref_B->KeMapUpdate_h,
                       &Gen2_ref_DWork->KeMapUpdate_h, inst);

  /* End of Outputs for SubSystem: '<S830>/Ke Map Update' */

  /* Switch: '<S830>/Switch1' incorporates:
   *  Logic: '<S830>/Logical Operator4'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bActKeEst2Dof) {
    rtb_Switch_n = Gen2_ref_B->KeMapUpdate_h.Sum1;
  }

  /* End of Switch: '<S830>/Switch1' */

  /* MATLAB Function: '<S830>/MATLAB Function1' incorporates:
   *  Delay: '<S830>/Delay'
   *  Logic: '<S830>/Logical Operator1'
   */
  Gen2_ref_MATLABFunction1_m
    (Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_x,
     Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y,
     Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptEps, rtb_kW2W1_h, rtb_Switch_n,
     Gen2_ref_DWork->Delay_DSTATE_n2, !rtb_Switch3_le,
     &Gen2_ref_B->sf_MATLABFunction1_l, &Gen2_ref_DWork->sf_MATLABFunction1_l, inst);

  /* Logic: '<Root>/Logical Operator3' */
  rtb_bTV_sat = (Gen2_ref_B->BusInput3.KeEstNetP.bActKeEstNetP &&
                 rtb_LogicalOperator);

  /* MATLAB Function: '<S666>/MATLAB Function1' incorporates:
   *  Delay: '<S666>/Delay'
   *  Logic: '<S666>/Logical Operator1'
   */
  Gen2_ref_MATLABFunction1_m
    (Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_x,
     Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y,
     Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptEps, rtb_Gain6_b, rtb_Switch1_ep,
     Gen2_ref_DWork->Delay_DSTATE_cnq, !rtb_Switch3_of,
     &Gen2_ref_B->sf_MATLABFunction1_m, &Gen2_ref_DWork->sf_MATLABFunction1_m, inst);

  /* Sum: '<S635>/Sum' incorporates:
   *  Delay: '<S637>/Resettable Delay'
   */
  rtb_kW2W1_h = Gen2_ref_DWork->ResettableDelay_DSTATE_i - rtb_Switch1_k;

  /* Abs: '<S635>/Abs1' */
  rtb_Divide2_f = fabs(Gen2_ref_B->BusInput3.LamLim.rThrshLamSatOn);

  /* Abs: '<S635>/Abs' */
  rtb_Switch_n = fabs(Gen2_ref_B->BusInput3.LamLim.rThrshLamSatOff);

  /* MinMax: '<S635>/MinMax' */
  if ((rtb_Divide2_f >= rtb_Switch_n) || rtIsNaN(rtb_Switch_n)) {
    rtb_Gain6_b = rtb_Divide2_f;
  } else {
    rtb_Gain6_b = rtb_Switch_n;
  }

  /* End of MinMax: '<S635>/MinMax' */

  /* Switch: '<S635>/Switch2' incorporates:
   *  Constant: '<S635>/Constant4'
   *  RelationalOperator: '<S635>/Relational Operator'
   *  RelationalOperator: '<S635>/Relational Operator1'
   *  Switch: '<S635>/Switch3'
   *  UnitDelay: '<S635>/Unit Delay1'
   */
  if (rtb_kW2W1_h < rtb_Divide2_f) {
    rtb_kW2W1_h = 1.0;
  } else if (rtb_kW2W1_h > rtb_Gain6_b) {
    /* Switch: '<S635>/Switch3' incorporates:
     *  Constant: '<S635>/Constant5'
     */
    rtb_kW2W1_h = 0.0;
  } else {
    rtb_kW2W1_h = Gen2_ref_DWork->UnitDelay1_DSTATE_eq;
  }

  /* End of Switch: '<S635>/Switch2' */

  /* Sum: '<S635>/Sum1' incorporates:
   *  Delay: '<S637>/Resettable Delay'
   */
  rtb_Switch1_ep = rtb_Switch2_n5 - Gen2_ref_DWork->ResettableDelay_DSTATE_i;

  /* Switch: '<S635>/Switch4' incorporates:
   *  Constant: '<S635>/Constant6'
   *  RelationalOperator: '<S635>/Relational Operator2'
   *  RelationalOperator: '<S635>/Relational Operator3'
   *  Switch: '<S635>/Switch5'
   *  UnitDelay: '<S635>/Unit Delay2'
   */
  if (rtb_Switch1_ep < rtb_Divide2_f) {
    rtb_Gain6_b = 1.0;
  } else if (rtb_Switch1_ep > rtb_Gain6_b) {
    /* Switch: '<S635>/Switch5' incorporates:
     *  Constant: '<S635>/Constant7'
     */
    rtb_Gain6_b = 0.0;
  } else {
    rtb_Gain6_b = Gen2_ref_DWork->UnitDelay2_DSTATE_di;
  }

  /* End of Switch: '<S635>/Switch4' */

  /* Logic: '<S635>/Logical Operator2' */
  rtb_LogicalOperator2_ov = ((rtb_kW2W1_h != 0.0) || (rtb_Gain6_b != 0.0));

  /* Switch: '<S714>/Switch7' incorporates:
   *  Constant: '<S714>/Constant1'
   *  Logic: '<S714>/Logical Operator5'
   */
  if (!rtb_LogicalOperator2_ov) {
    rtb_Divide2_f = Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptEps;
  } else {
    rtb_Divide2_f = 0.0;
  }

  /* End of Switch: '<S714>/Switch7' */

  /* Outputs for Atomic SubSystem: '<S714>/TON' */
  Gen2_ref_TON_1(Gen2_ref_B->TON2.LogicalOperator3,
                 Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptTon, &Gen2_ref_B->TON_o,
                 &Gen2_ref_DWork->TON_o, inst);

  /* End of Outputs for SubSystem: '<S714>/TON' */

  /* Logic: '<S714>/Logical Operator1' */
  rtb_Switch2_au = (rtb_RelationalOperator_ok &&
                    Gen2_ref_B->TON_o.LogicalOperator3);

  /* MATLAB Function: '<S714>/MATLAB Function1' incorporates:
   *  Delay: '<S714>/Delay'
   */
  if ((!Gen2_ref_DWork->y_map_not_empty_d) || Gen2_ref_DWork->Delay_DSTATE_a) {
    Gen2_ref_DWork->y_map_not_empty_d = true;
    for (i = 0; i < 13; i++) {
      Gen2_ref_DWork->y_map_f[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y[i];
      Gen2_ref_DWork->x_map_n[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_x[i];
    }
  }

  if (Gen2_ref_maximum_f(Gen2_ref_DWork->y_map_f, inst) < 0.1) {
    for (i = 0; i < 13; i++) {
      Gen2_ref_DWork->y_map_f[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_y[i];
    }
  }

  if (!rtIsNaN(Gen2_ref_DWork->x_map_n[0])) {
    k = 1;
  } else {
    k = 0;
    i = 2;
    exitg1 = false;
    while ((!exitg1) && (i < 14)) {
      if (!rtIsNaN(Gen2_ref_DWork->x_map_n[i - 1])) {
        k = i;
        exitg1 = true;
      } else {
        i++;
      }
    }
  }

  if (k == 0) {
    rtb_Switch1_ep = Gen2_ref_DWork->x_map_n[0];
  } else {
    rtb_Switch1_ep = Gen2_ref_DWork->x_map_n[k - 1];
    while (k + 1 <= 13) {
      if (rtb_Switch1_ep > Gen2_ref_DWork->x_map_n[k]) {
        rtb_Switch1_ep = Gen2_ref_DWork->x_map_n[k];
      }

      k++;
    }
  }

  if ((rtb_Switch1_ep >= rtb_Gain6_jx) || rtIsNaN(rtb_Gain6_jx)) {
    rtb_Gain6_jx = rtb_Switch1_ep;
  }

  x = Gen2_ref_maximum_f(Gen2_ref_DWork->x_map_n, inst);
  if ((!(x <= rtb_Gain6_jx)) && (!rtIsNaN(rtb_Gain6_jx))) {
    x = rtb_Gain6_jx;
  }

  k = 0;
  if (!(x < Gen2_ref_DWork->x_map_n[0])) {
    for (i = 0; i < 13; i++) {
      if (x > Gen2_ref_DWork->x_map_n[i]) {
        k = i;
      }
    }
  }

  if (k + 1 < 13) {
    if (rtb_Switch2_au && (!Gen2_ref_DWork->Delay_DSTATE_a)) {
      rtb_Switch_n = Gen2_ref_DWork->y_map_f[k + 1];
      delta_y_tmp_tmp = x - Gen2_ref_DWork->x_map_n[k];
      u0 = Gen2_ref_DWork->x_map_n[k + 1];
      delta_y = delta_y_tmp_tmp / (u0 - Gen2_ref_DWork->x_map_n[k]) *
        (rtb_Switch_n - Gen2_ref_DWork->y_map_f[k]) + Gen2_ref_DWork->y_map_f[k];
      delta_y = ((1.0 - rtb_Divide2_f) * delta_y + rtb_Divide2_f * rtb_Sum_ig) -
        delta_y;
      x = u0 - x;
      rtb_Divide2_f = delta_y_tmp_tmp + x;
      rtb_PactOut_tmp = rtb_Divide2_f * x;
      rtb_bResetHlci_0 = (delta_y_tmp_tmp * delta_y_tmp_tmp + rtb_PactOut_tmp) -
        delta_y_tmp_tmp * x;
      Gen2_ref_DWork->y_map_f[k] += rtb_PactOut_tmp * delta_y / rtb_bResetHlci_0;
      Gen2_ref_DWork->y_map_f[k + 1] = rtb_Divide2_f * delta_y_tmp_tmp * delta_y
        / rtb_bResetHlci_0 + rtb_Switch_n;
    }
  } else if (rtb_Switch2_au && (!Gen2_ref_DWork->Delay_DSTATE_a)) {
    Gen2_ref_DWork->y_map_f[12] = (1.0 - rtb_Divide2_f) *
      Gen2_ref_DWork->y_map_f[12] + rtb_Divide2_f * rtb_Sum_ig;
  }

  for (i = 0; i < 13; i++) {
    rtb_y_map_new_n[i] = Gen2_ref_DWork->y_map_f[i];
  }

  /* Switch: '<S431>/Switch3' incorporates:
   *  MATLAB Function: '<S714>/MATLAB Function1'
   */
  for (i = 0; i < 13; i++) {
    if (Gen2_ref_B->BusInput3.SpeedCtrl.bActKeEstMapUpdate) {
      rtb_Switch3_je[i] = Gen2_ref_B->sf_MATLABFunction1_m.y_map_new[i];
    } else {
      rtb_Switch3_je[i] = Gen2_ref_DWork->y_map_f[i];
    }
  }

  /* End of Switch: '<S431>/Switch3' */

  /* Switch: '<S715>/Switch7' incorporates:
   *  Constant: '<S715>/Constant1'
   *  Logic: '<S715>/Logical Operator5'
   */
  if (!rtb_LogicalOperator2_ov) {
    rtb_Divide2_f = Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptEps;
  } else {
    rtb_Divide2_f = 0.0;
  }

  /* End of Switch: '<S715>/Switch7' */

  /* Outputs for Atomic SubSystem: '<S715>/TON' */
  Gen2_ref_TON_1(Gen2_ref_B->TON2.LogicalOperator3,
                 Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptTon, &Gen2_ref_B->TON_m,
                 &Gen2_ref_DWork->TON_m, inst);

  /* End of Outputs for SubSystem: '<S715>/TON' */

  /* Logic: '<S715>/Logical Operator1' incorporates:
   *  Logic: '<S636>/Logical Operator'
   */
  rtb_Switch3_le = ((!rtb_RelationalOperator_ok) &&
                    Gen2_ref_B->TON_m.LogicalOperator3);

  /* MATLAB Function: '<S715>/MATLAB Function1' incorporates:
   *  Delay: '<S715>/Delay'
   */
  if ((!Gen2_ref_DWork->y_map_not_empty_f) || Gen2_ref_DWork->Delay_DSTATE_ng) {
    Gen2_ref_DWork->y_map_not_empty_f = true;
    for (i = 0; i < 7; i++) {
      Gen2_ref_DWork->y_map_i[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_KengPOW_y[i];
      Gen2_ref_DWork->x_map_c[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_KengPOW_x[i];
    }
  }

  if (Gen2_ref_maximum_f5(Gen2_ref_DWork->y_map_i, inst) < 0.1) {
    for (i = 0; i < 7; i++) {
      Gen2_ref_DWork->y_map_i[i] =
        Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_KengPOW_y[i];
    }
  }

  if (!rtIsNaN(Gen2_ref_DWork->x_map_c[0])) {
    k = 1;
  } else {
    k = 0;
    i = 2;
    exitg1 = false;
    while ((!exitg1) && (i < 8)) {
      if (!rtIsNaN(Gen2_ref_DWork->x_map_c[i - 1])) {
        k = i;
        exitg1 = true;
      } else {
        i++;
      }
    }
  }

  if (k == 0) {
    rtb_Switch1_ep = Gen2_ref_DWork->x_map_c[0];
  } else {
    rtb_Switch1_ep = Gen2_ref_DWork->x_map_c[k - 1];
    while (k + 1 <= 7) {
      if (rtb_Switch1_ep > Gen2_ref_DWork->x_map_c[k]) {
        rtb_Switch1_ep = Gen2_ref_DWork->x_map_c[k];
      }

      k++;
    }
  }

  if ((rtb_Switch1_ep >= rtb_Gain7) || rtIsNaN(rtb_Gain7)) {
    rtb_Gain7 = rtb_Switch1_ep;
  }

  x = Gen2_ref_maximum_f5(Gen2_ref_DWork->x_map_c, inst);
  if ((!(x <= rtb_Gain7)) && (!rtIsNaN(rtb_Gain7))) {
    x = rtb_Gain7;
  }

  k = 0;
  if (!(x < Gen2_ref_DWork->x_map_c[0])) {
    for (i = 0; i < 7; i++) {
      if (x > Gen2_ref_DWork->x_map_c[i]) {
        k = i;
      }
    }
  }

  if (k + 1 < 7) {
    if (rtb_Switch3_le && (!Gen2_ref_DWork->Delay_DSTATE_ng)) {
      rtb_Switch_n = Gen2_ref_DWork->y_map_i[k + 1];
      delta_y_tmp_tmp = x - Gen2_ref_DWork->x_map_c[k];
      u0 = Gen2_ref_DWork->x_map_c[k + 1];
      delta_y = delta_y_tmp_tmp / (u0 - Gen2_ref_DWork->x_map_c[k]) *
        (rtb_Switch_n - Gen2_ref_DWork->y_map_i[k]) + Gen2_ref_DWork->y_map_i[k];
      delta_y = ((1.0 - rtb_Divide2_f) * delta_y + rtb_Divide2_f * rtb_Sum_gb) -
        delta_y;
      x = u0 - x;
      rtb_Divide2_f = delta_y_tmp_tmp + x;
      rtb_PactOut_tmp = rtb_Divide2_f * x;
      rtb_Gain7 = (delta_y_tmp_tmp * delta_y_tmp_tmp + rtb_PactOut_tmp) -
        delta_y_tmp_tmp * x;
      Gen2_ref_DWork->y_map_i[k] += rtb_PactOut_tmp * delta_y / rtb_Gain7;
      Gen2_ref_DWork->y_map_i[k + 1] = rtb_Divide2_f * delta_y_tmp_tmp * delta_y
        / rtb_Gain7 + rtb_Switch_n;
    }
  } else if (rtb_Switch3_le && (!Gen2_ref_DWork->Delay_DSTATE_ng)) {
    Gen2_ref_DWork->y_map_i[6] = (1.0 - rtb_Divide2_f) * Gen2_ref_DWork->
      y_map_i[6] + rtb_Divide2_f * rtb_Sum_gb;
  }

  for (i = 0; i < 7; i++) {
    rtb_y_map_new_a[i] = Gen2_ref_DWork->y_map_i[i];
  }

  /* Sum: '<S275>/Add2' incorporates:
   *  Sum: '<S291>/Add2'
   */
  rtb_PactOut_tmp = Gen2_ref_B->BusInput3.leanox.rP_Eng_Frict +
    Gen2_ref_B->BusInput3.eng.rP_Nom;
  rtb_Divide2_f = rtb_PactOut_tmp;

  /* Gain: '<S275>/Gain' */
  rtb_Gain7 = 1000.0 * rtb_Divide2_f;

  /* Abs: '<S281>/Abs' */
  rtb_Divide2_f = fabs(Gen2_ref_B->BusInput3.eng.rLHV);

  /* Abs: '<S282>/Abs' incorporates:
   *  Abs: '<S298>/Abs'
   */
  rtb_Switch_n = fabs(Gen2_ref_B->BusInput3.Eff.rEtaBrakeExt);

  /* Switch: '<S281>/Switch' incorporates:
   *  Constant: '<S281>/Constant2'
   *  RelationalOperator: '<S281>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Divide2_f) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rLHV;
  }

  /* End of Switch: '<S281>/Switch' */

  /* Switch: '<S282>/Switch' incorporates:
   *  Constant: '<S282>/Constant2'
   *  RelationalOperator: '<S282>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch_n) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = Gen2_ref_B->BusInput3.Eff.rEtaBrakeExt;
  }

  /* End of Switch: '<S282>/Switch' */

  /* Product: '<S275>/Divide4' */
  rtb_Divide2_f = rtb_Gain7 / rtb_bResetHlci_0 / delta_y;

  /* Gain: '<S275>/Gain3' */
  rtb_Gain7 = 0.1 * rtb_Divide2_f;

  /* BusCreator: '<S16>/Bus Creator' incorporates:
   *  Outport: '<Root>/out'
   *  RelationalOperator: '<S275>/Relational Operator'
   *  Sum: '<S275>/Add3'
   */
  Gen2_ref_Y->out.TJ_GasO[1] = (rtb_SumofElements > rtb_Divide2_f + rtb_Gain7);

  /* Sum: '<S291>/Add2' */
  rtb_Divide2_f = rtb_PactOut_tmp;

  /* Gain: '<S291>/Gain' */
  rtb_Sum_gb = 1000.0 * rtb_Divide2_f;

  /* Abs: '<S297>/Abs' */
  rtb_Divide2_f = fabs(Gen2_ref_B->BusInput3.eng.rLHV_M);

  /* Switch: '<S297>/Switch' incorporates:
   *  Constant: '<S297>/Constant2'
   *  RelationalOperator: '<S297>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Divide2_f) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rLHV_M;
  }

  /* End of Switch: '<S297>/Switch' */

  /* Switch: '<S298>/Switch' incorporates:
   *  Constant: '<S298>/Constant2'
   *  RelationalOperator: '<S298>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Switch_n) {
    delta_y = 2.2204460492503131E-16;
  } else {
    delta_y = Gen2_ref_B->BusInput3.Eff.rEtaBrakeExt;
  }

  /* End of Switch: '<S298>/Switch' */

  /* Product: '<S291>/Divide4' */
  rtb_Divide2_f = rtb_Sum_gb / rtb_bResetHlci_0 / delta_y;

  /* Gain: '<S291>/Gain3' */
  rtb_Sum_gb = 0.1 * rtb_Divide2_f;

  /* BusCreator: '<S16>/Bus Creator' incorporates:
   *  Outport: '<Root>/out'
   *  RelationalOperator: '<S291>/Relational Operator'
   *  Sum: '<S291>/Add3'
   */
  Gen2_ref_Y->out.TJ_GasO[2] = (rtb_SumofElements_l > rtb_Divide2_f + rtb_Sum_gb);

  /* UnitDelay: '<S275>/Unit Delay2' */
  rtb_Gain6_jx = Gen2_ref_DWork->UnitDelay2_DSTATE_k;

  /* UnitDelay: '<S291>/Unit Delay2' */
  rtb_Sum_ig = Gen2_ref_DWork->UnitDelay2_DSTATE_p;

  /* Gain: '<S16>/W2kW1 ' */
  rtb_Divide2_f = 0.001 * Gen2_ref_B->Pd_filt_p.Switch;

  /* DataTypeConversion: '<S16>/Data Type Conversion16' */
  Gen2_ref_Y->out.Ptraj_SpeedCtrl = (real32_T)rtb_Divide2_f;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S12>/Bus Creator'
   *  DataTypeConversion: '<S12>/Data Type Conversion'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.KeEstNetP.Ke_calc = (real32_T)r;

  /* Sum: '<S749>/Sum1' */
  r = rtb_Product1_c1_tmp;

  /* Gain: '<S749>/Gain7' */
  rtb_Divide2_f = -Gen2_ref_B->BusInput3.SpeedCtrl.rOutOfNWindow;

  /* Logic: '<S749>/Logical Operator4' incorporates:
   *  Logic: '<S749>/Logical Operator'
   *  Logic: '<S749>/Logical Operator1'
   *  Logic: '<S749>/Logical Operator2'
   *  Logic: '<S749>/Logical Operator3'
   *  MATLAB Function: '<S749>/MATLAB Function'
   *  RelationalOperator: '<S749>/Relational Operator'
   *  RelationalOperator: '<S749>/Relational Operator1'
   */
  rtb_LogicalOperator4_go = (rtb_Act && ((Gen2_ref_DWork->SR_LoadStep && (r >
    Gen2_ref_B->BusInput3.SpeedCtrl.rOutOfNWindow)) ||
    ((!Gen2_ref_DWork->SR_LoadStep) && (r < rtb_Divide2_f))));

  /* S-Function (sfix_look1_dyn): '<S431>/gain scheduling Keng' */
  /* Dynamic Look-Up Table Block: '<S431>/gain scheduling Keng'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(r), &rtb_Switch3_je[0], rtb_Gain3,
                       &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Keng_x[0],
                       12U, inst);

  /* Product: '<S431>/Product2' */
  rtb_Switch1_ep = r * rtb_Switch_nb;

  /* Switch: '<S13>/Switch' incorporates:
   *  DataTypeConversion: '<S12>/Data Type Conversion1'
   *  DataTypeConversion: '<S13>/Data Type Conversion'
   *  DataTypeConversion: '<S13>/Data Type Conversion1'
   *  DataTypeConversion: '<S431>/Data Type Conversion22'
   *  Gain: '<S13>/tom^3'
   *  Gain: '<S13>/tom^3_2'
   */
  if (rtb_LogicalOperator) {
    r = 1.0E-5 * (real32_T)Gen2_ref_B->Filter1_n.Switch;
  } else {
    r = 1.0E-5 * (real32_T)Gen2_ref_B->Filter1_o.Switch;
  }

  /* End of Switch: '<S13>/Switch' */

  /* Product: '<S13>/Product2' incorporates:
   *  Constant: '<S13>/4pi'
   */
  rtb_Switch_n = r * rtb_kW2W * Gen2_ref_B->T2s_filt.Switch * 12.566370614359172;

  /* Product: '<S13>/Product1' */
  r = rtb_dm_e_tmp * rtb_etaBreakConst;

  /* Abs: '<S856>/Abs' */
  rtb_Divide2_f = fabs(r);

  /* BusCreator: '<S16>/Bus Creator' incorporates:
   *  Constant: '<S5>/Constant2'
   *  Constant: '<S5>/Constant3'
   *  DataTypeConversion: '<S16>/Data Type Conversion'
   *  DataTypeConversion: '<S16>/Data Type Conversion11'
   *  DataTypeConversion: '<S16>/Data Type Conversion12'
   *  DataTypeConversion: '<S16>/Data Type Conversion13'
   *  DataTypeConversion: '<S16>/Data Type Conversion14'
   *  DataTypeConversion: '<S16>/Data Type Conversion15'
   *  DataTypeConversion: '<S16>/Data Type Conversion17'
   *  DataTypeConversion: '<S16>/Data Type Conversion18'
   *  DataTypeConversion: '<S16>/Data Type Conversion2'
   *  DataTypeConversion: '<S16>/Data Type Conversion3'
   *  DataTypeConversion: '<S16>/Data Type Conversion5'
   *  DataTypeConversion: '<S16>/Data Type Conversion6'
   *  DataTypeConversion: '<S16>/Data Type Conversion7'
   *  DataTypeConversion: '<S16>/Data Type Conversion8'
   *  Gain: '<S16>/Pa2bar'
   *  Logic: '<S275>/Logical Operator'
   *  Logic: '<S291>/Logical Operator'
   *  MATLAB Function: '<S715>/MATLAB Function1'
   *  Outport: '<Root>/out'
   *  RelationalOperator: '<S275>/Relational Operator1'
   *  RelationalOperator: '<S275>/Relational Operator2'
   *  RelationalOperator: '<S291>/Relational Operator1'
   *  RelationalOperator: '<S291>/Relational Operator2'
   *  SignalConversion generated from: '<S16>/Bus Creator'
   *  Sum: '<S275>/Add4'
   *  Sum: '<S275>/Add5'
   *  Sum: '<S291>/Add4'
   *  Sum: '<S291>/Add5'
   *  UnitDelay: '<S275>/Unit Delay'
   *  UnitDelay: '<S275>/Unit Delay1'
   *  UnitDelay: '<S275>/Unit Delay2'
   *  UnitDelay: '<S275>/Unit Delay3'
   *  UnitDelay: '<S291>/Unit Delay'
   *  UnitDelay: '<S291>/Unit Delay1'
   *  UnitDelay: '<S291>/Unit Delay2'
   *  UnitDelay: '<S291>/Unit Delay3'
   * */
  Gen2_ref_Y->out.rmdot_gas = (real32_T)rtb_Switch_g[0];
  Gen2_ref_Y->out.rmdot_gas_M = (real32_T)rtb_Switch_g[1];
  Gen2_ref_Y->out.rLamGen2 = (real32_T)rtb_Switch_g[2];
  Gen2_ref_Y->out.rPos_TV = (real32_T)rtb_Switch_g[3];
  Gen2_ref_Y->out.rPos_CBV = (real32_T)rtb_Switch_g[4];
  Gen2_ref_Y->out.rPos_WGV = (real32_T)rtb_Switch_g[5];
  Gen2_ref_Y->out.rPr_p2s_des = (real32_T)(1.0E-5 * rtb_Pa2bar_o);
  Gen2_ref_Y->out.rPrP2sLEANOXref = (real32_T)rtb_Sum_e;
  Gen2_ref_Y->out.rLamLimUp = (real32_T)rtb_Switch2_n5;
  Gen2_ref_Y->out.rLamLimLo = (real32_T)rtb_Switch1_k;
  Gen2_ref_Y->out.rLamss = (real32_T)rtb_PactOut_o;
  for (i = 0; i < 13; i++) {
    /* Switch: '<Root>/GasStop8' incorporates:
     *  DataTypeConversion: '<S16>/Data Type Conversion19'
     */
    if (rtb_bTV_sat) {
      Gen2_ref_Y->out.rKengMap[i] = (real32_T)
        Gen2_ref_B->sf_MATLABFunction1_l.y_map_new[i];
    } else {
      Gen2_ref_Y->out.rKengMap[i] = (real32_T)rtb_Switch3_je[i];
    }

    /* End of Switch: '<Root>/GasStop8' */
  }

  for (i = 0; i < 7; i++) {
    Gen2_ref_Y->out.rKengMap_P[i] = (real32_T)Gen2_ref_DWork->y_map_i[i];
  }

  Gen2_ref_Y->out.rPos_CBV2 = (real32_T)rtb_Switch_g[6];
  Gen2_ref_Y->out.rPos_CBV3 = (real32_T)rtb_Switch_g[7];
  Gen2_ref_Y->out.bAirAssistIntake = false;
  Gen2_ref_Y->out.bAirAssistExhaust = false;
  Gen2_ref_Y->out.rPos_AAV_Intake = 0.0F;
  Gen2_ref_Y->out.rPos_AAV_Exhaust = 0.0F;
  Gen2_ref_Y->out.TJ_GasO[0] = false;
  Gen2_ref_Y->out.TJ_GasO[3] = false;
  Gen2_ref_Y->out.TJ_GasO[4] = false;
  Gen2_ref_Y->out.TJ_GasM[0] = false;
  Gen2_ref_Y->out.TJ_GasM[1] = ((rtb_SumofElements -
    Gen2_ref_DWork->UnitDelay_DSTATE_dk > rtb_Gain7) &&
    (Gen2_ref_DWork->UnitDelay2_DSTATE_k - Gen2_ref_DWork->UnitDelay1_DSTATE_b >
     Gen2_ref_DWork->UnitDelay3_DSTATE_m) &&
    Gen2_ref_B->BusInput3.fdc.bActive_GasFlowStepLimit);
  Gen2_ref_Y->out.TJ_GasM[2] = ((rtb_SumofElements_l -
    Gen2_ref_DWork->UnitDelay_DSTATE_m > rtb_Sum_gb) &&
    (Gen2_ref_DWork->UnitDelay2_DSTATE_p - Gen2_ref_DWork->UnitDelay1_DSTATE_c2 >
     Gen2_ref_DWork->UnitDelay3_DSTATE_h) &&
    Gen2_ref_B->BusInput3.fdc.bActive_GasFlowStepLimit);
  Gen2_ref_Y->out.TJ_GasM[3] = false;
  Gen2_ref_Y->out.TJ_GasM[4] = false;
  Gen2_ref_Y->out.bSS = Gen2_ref_B->TON2.LogicalOperator3;

  /* Switch: '<S856>/Switch' incorporates:
   *  Constant: '<S856>/Constant2'
   *  RelationalOperator: '<S856>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Divide2_f) {
    r = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S856>/Switch' */

  /* BusCreator: '<S16>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S16>/Data Type Conversion20'
   *  Outport: '<Root>/out'
   *  Product: '<S13>/Product'
   */
  Gen2_ref_Y->out.rLHV_est = (real32_T)(rtb_Switch_n / r);

  /* Gain: '<S7>/W2kW' */
  r = 0.001 * rtb_Switch2_g3;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S7>/Bus Creator2'
   *  DataTypeConversion: '<S7>/Data Type Conversion2'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.HLC.Gen2DbgHlcTraj.rP_Set_Delta_FSM = (real32_T)r;

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  Constant: '<S307>/Constant2'
   *  DataTypeConversion: '<S272>/Data Type Conversion'
   *  DataTypeConversion: '<S272>/Data Type Conversion1'
   *  DataTypeConversion: '<S272>/Data Type Conversion2'
   *  DataTypeConversion: '<S272>/Data Type Conversion3'
   *  DataTypeConversion: '<S272>/Data Type Conversion4'
   *  DataTypeConversion: '<S272>/Data Type Conversion5'
   *  DataTypeConversion: '<S272>/Data Type Conversion6'
   *  DataTypeConversion: '<S272>/Data Type Conversion7'
   *  DataTypeConversion: '<S272>/Data Type Conversion8'
   *  DataTypeConversion: '<S272>/Data Type Conversion9'
   *  DiscreteIntegrator: '<S307>/Discrete-Time Integrator'
   *  Sum: '<S307>/Sum4'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.p2s_raw = (real32_T)rtb_p2s;
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.p2s_1stOrd = (real32_T)
    Gen2_ref_B->sf_FILTERnodelay5.y;
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.p2s_2ndOrd = (real32_T)
    Gen2_ref_B->undOrderFilter3.Switch;
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.ne_raw = (real32_T)
    rtb_DataTypeConversion15;
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.ne_1stOrd = (real32_T)
    Gen2_ref_B->sf_FILTERnodelay4.y;
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.ne_2ndOrd = (real32_T)rtb_Switch_kr;
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.p2s_in = (real32_T)rtb_Switch4_p;
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.ne_in = (real32_T)rtb_Switch5_nn;
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.Ratio1stOrd = (real32_T)(1.0 -
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d);
  Gen2_ref_Y->dbg.FDC.dbgFDC_Filtering.Ratio2ndOrd = (real32_T)
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d;

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion1'
   *  DataTypeConversion: '<S5>/Data Type Conversion10'
   *  DataTypeConversion: '<S5>/Data Type Conversion11'
   *  DataTypeConversion: '<S5>/Data Type Conversion2'
   *  DataTypeConversion: '<S5>/Data Type Conversion3'
   *  DataTypeConversion: '<S5>/Data Type Conversion4'
   *  DataTypeConversion: '<S5>/Data Type Conversion9'
   *  Product: '<S267>/Divide3'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.mdot_dyn = (real32_T)rtb_Divide1_h4;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.mdot_set = (real32_T)rtb_SumofElements;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.mdot_ss = (real32_T)rtb_Product3_g;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rFactCompLR = (real32_T)rtb_Switch2_l;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.Rgas12 = (real32_T)rtb_Divide3_n_tmp;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rdpdt[0] = (real32_T)
    rtb_Switch2_gd_idx_0;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rmdot_mix_dyn[0] = (real32_T)R_2inp[0];

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion5'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt3.rmdot_mix_dyn_M[0] = (real32_T)
    rtb_Divide_ab[0];

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion1'
   *  DataTypeConversion: '<S5>/Data Type Conversion10'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rdpdt[1] = (real32_T)
    rtb_Switch2_gd_idx_1;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rmdot_mix_dyn[1] = (real32_T)R_2inp[1];

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion5'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt3.rmdot_mix_dyn_M[1] = (real32_T)
    rtb_Divide_ab[1];

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion1'
   *  DataTypeConversion: '<S5>/Data Type Conversion10'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rdpdt[2] = (real32_T)
    rtb_Switch2_gd_idx_2;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rmdot_mix_dyn[2] = (real32_T)R_2inp[2];

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion5'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt3.rmdot_mix_dyn_M[2] = (real32_T)
    rtb_Divide_ab[2];

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion1'
   *  DataTypeConversion: '<S5>/Data Type Conversion10'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rdpdt[3] = (real32_T)
    rtb_Switch2_gd_idx_3;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt1and2.rmdot_mix_dyn[3] = (real32_T)R_2inp[3];

  /* BusCreator generated from: '<S5>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion12'
   *  DataTypeConversion: '<S5>/Data Type Conversion5'
   *  DataTypeConversion: '<S5>/Data Type Conversion6'
   *  DataTypeConversion: '<S5>/Data Type Conversion7'
   *  DataTypeConversion: '<S5>/Data Type Conversion8'
   *  Product: '<S268>/Divide3'
   */
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt3.rmdot_mix_dyn_M[3] = (real32_T)
    rtb_Divide_ab[3];
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt3.mdot_dyn_M = (real32_T)rtb_Sum_mf;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt3.mdot_set_M = (real32_T)rtb_SumofElements_l;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt3.mdot_ss_M = (real32_T)rtb_Sum2_a1;
  Gen2_ref_Y->dbg.FDC.dbgFDC_GasArt3.Rgas3 = (real32_T)rtb_Switch_ks;

  /* BusCreator: '<S9>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S9>/Data Type Conversion3'
   */
  Gen2_ref_Y->dbg.ITC.IT_off_start = 0.0F;
  Gen2_ref_Y->dbg.ITC.IT_off_island34 = 0.0F;
  Gen2_ref_Y->dbg.ITC.IT_off_island6 = (real32_T)rtb_Sum1_dh;

  /* BusCreator: '<S19>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S19>/Data Type Conversion2'
   *  DataTypeConversion: '<S19>/Data Type Conversion3'
   *  DataTypeConversion: '<S19>/Data Type Conversion4'
   *  DataTypeConversion: '<S19>/Data Type Conversion5'
   */
  Gen2_ref_Y->dbg.SkipF.NskipPow = (real32_T)rtb_MinMax_n;
  Gen2_ref_Y->dbg.SkipF.NskipMax = (real32_T)rtb_RoundingFunction;
  Gen2_ref_Y->dbg.SkipF.Nskip34 = (real32_T)rtb_Product1_mqz;
  Gen2_ref_Y->dbg.SkipF.Nskip6 = (real32_T)rtb_Switch2_d1;

  /* Logic: '<S14>/Logical Operator2' */
  Gen2_ref_Y->dbg.LamLim.bInitLamOffs = !rtb_LogicalOperator5_mv;

  /* BusCreator: '<S14>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S14>/Data Type Conversion'
   *  DataTypeConversion: '<S14>/Data Type Conversion10'
   *  DataTypeConversion: '<S14>/Data Type Conversion2'
   *  DataTypeConversion: '<S14>/Data Type Conversion3'
   *  DataTypeConversion: '<S14>/Data Type Conversion4'
   *  DataTypeConversion: '<S14>/Data Type Conversion5'
   *  DataTypeConversion: '<S14>/Data Type Conversion7'
   *  DataTypeConversion: '<S14>/Data Type Conversion8'
   *  DataTypeConversion: '<S14>/Data Type Conversion9'
   *  DataTypeConversion: '<S4>/Data Type Conversion28'
   */
  Gen2_ref_Y->dbg.LamLim.extOffset = Gen2_ref_B->BusInput.rOffsetLamLimit;
  Gen2_ref_Y->dbg.LamLim.AutoOffset = (real32_T)Gen2_ref_B->Filter_l.Switch;
  Gen2_ref_Y->dbg.LamLim.ScaledOffsetUpLim = (real32_T)rtb_Product1_b;
  Gen2_ref_Y->dbg.LamLim.ScaledOffsetLoLim = (real32_T)rtb_Product_l0;
  Gen2_ref_Y->dbg.LamLim.offsetUpLim = (real32_T)rtb_Sum5_j;
  Gen2_ref_Y->dbg.LamLim.offsetLoLim = (real32_T)rtb_Sum8_m;
  Gen2_ref_Y->dbg.LamLim.LamLoLim = (real32_T)rtb_Switch1_k;
  Gen2_ref_Y->dbg.LamLim.LamUpLim = (real32_T)rtb_Switch2_n5;
  Gen2_ref_Y->dbg.LamLim.LamSteadyState = (real32_T)rtb_PactOut_o;
  Gen2_ref_Y->dbg.LamLim.rLamOffsInit = (real32_T)rtb_Divide6_n;
  Gen2_ref_Y->dbg.LamLim.bPminSSadaptReached_Hys = rtb_LogicalOperator12_a;

  /* Gain: '<Root>/W2kW' */
  rtb_Sum8_m = 0.001 * rtb_Gain2_ao;

  /* S-Function (sfix_look1_dyn): '<S865>/LCRScal_CD1' */
  /* Dynamic Look-Up Table Block: '<S865>/LCRScal_CD1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_CDSet_50),
                       &Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_y[0],
                       Gen2_ref_B->BusInput3.leanox.rWG_1,
                       &Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_x[0], 10U, inst);

  /* S-Function (sfix_look1_dyn): '<S865>/LCRScal_CD2' */
  /* Dynamic Look-Up Table Block: '<S865>/LCRScal_CD2'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_CDSet_100),
                       &Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_y[0],
                       Gen2_ref_B->BusInput3.leanox.rWG_2,
                       &Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_x[0], 10U, inst);

  /* SignalConversion generated from: '<S867>/ SFunction ' incorporates:
   *  MATLAB Function: '<S15>/LookUp Extrapolation'
   *  SignalConversion generated from: '<S15>/LCRScal_DPWG4'
   */
  rtb_TmpSignalConversionAtLoo_ht[0] = Gen2_ref_B->BusInput3.leanox.rP_1;
  rtb_TmpSignalConversionAtLoo_ht[1] = Gen2_ref_B->BusInput3.leanox.rP_2;

  /* SignalConversion generated from: '<S867>/ SFunction ' incorporates:
   *  MATLAB Function: '<S15>/LookUp Extrapolation'
   */
  rtb_TmpSignalConversionAtLook_d[0] = rtb_CDSet_50;
  rtb_TmpSignalConversionAtLook_d[1] = rtb_CDSet_100;

  /* MATLAB Function: '<S15>/LookUp Extrapolation' */
  if (rtb_TmpSignalConversionAtLoo_ht[0] == rtb_TmpSignalConversionAtLoo_ht[1])
  {
    rtb_DataTypeConversion15 = 0.0;
  } else {
    rtb_DataTypeConversion15 = (rtb_TmpSignalConversionAtLook_d[1] -
      rtb_TmpSignalConversionAtLook_d[0]) / (rtb_TmpSignalConversionAtLoo_ht[1]
      - rtb_TmpSignalConversionAtLoo_ht[0]);
    rtb_DataTypeConversion15 = (rtb_TmpSignalConversionAtLook_d[0] -
      rtb_TmpSignalConversionAtLoo_ht[0] * rtb_DataTypeConversion15) +
      rtb_DataTypeConversion15 * rtb_Sum8_m;
    if (!(rtb_DataTypeConversion15 >= 0.0)) {
      rtb_DataTypeConversion15 = 0.0;
    }

    if (!(rtb_DataTypeConversion15 <= 1.0)) {
      rtb_DataTypeConversion15 = 1.0;
    }
  }

  /* DataTypeConversion: '<S15>/Data Type Conversion' */
  r = Gen2_ref_B->BusInput.tLvrt.rWgPosFb;

  /* Gain: '<S15>/Gain' */
  rtb_Sum_e = 100.0 * r;

  /* S-Function (sfix_look1_dyn): '<S15>/LCRScal_DPWG2' */
  /* Dynamic Look-Up Table Block: '<S15>/LCRScal_DPWG2'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Sum_mf), &Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_y
                       [0], rtb_Sum_e, &Gen2_ref_B->BusInput3.bdcWgv.rCd_vect_x
                       [0], 10U, inst);

  /* BusCreator: '<Root>/Bus Creator1' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion4'
   */
  Gen2_ref_Y->dbg.LxWgvCmp.CDAct = (real32_T)rtb_Sum_mf;

  /* Math: '<S868>/Math Function' */
  r = Gen2_ref_B->BusInput3.bdcWgv.rDref * Gen2_ref_B->BusInput3.bdcWgv.rDref;

  /* Abs: '<S871>/Abs' */
  rtb_Divide2_f = fabs(Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng);

  /* Switch: '<S871>/Switch' incorporates:
   *  Constant: '<S871>/Constant2'
   *  RelationalOperator: '<S871>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Divide2_f) {
    rtb_Divide2_f = 2.2204460492503131E-16;
  } else {
    rtb_Divide2_f = Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng;
  }

  /* End of Switch: '<S871>/Switch' */

  /* Product: '<S868>/Divide' incorporates:
   *  Constant: '<S868>/Constant'
   *  Sum: '<S15>/Add1'
   */
  rtb_Sum_mf = (rtb_DataTypeConversion15 - rtb_Sum_mf) * r * 0.78539816339744828
    * Gen2_ref_B->BusInput3.eng.rNum_WGV / rtb_Divide2_f;

  /* SignalConversion generated from: '<S15>/LCRScal_DPWG4' */
  rtb_TmpSignalConversionAtLook_d[0] = rtb_TmpSignalConversionAtLoo_ht[0];
  rtb_TmpSignalConversionAtLook_d[1] = rtb_TmpSignalConversionAtLoo_ht[1];

  /* S-Function (sfix_look1_dyn): '<S15>/LCRScal_DPWG3' */
  /* Dynamic Look-Up Table Block: '<S15>/LCRScal_DPWG3'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(r), &Gen2_ref_B->BusInput3.leanox.Comp_WG_1_y[0],
                       rtb_Sum_mf, &Gen2_ref_B->BusInput3.leanox.Comp_WG_1_x[0],
                       9U, inst);

  /* S-Function (sfix_look1_dyn): '<S15>/LCRScal_DPWG1' */
  /* Dynamic Look-Up Table Block: '<S15>/LCRScal_DPWG1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(rtb_Divide2_f),
                       &Gen2_ref_B->BusInput3.leanox.Comp_WG_2_y[0], rtb_Sum_mf,
                       &Gen2_ref_B->BusInput3.leanox.Comp_WG_2_x[0], 9U, inst);

  /* SignalConversion generated from: '<S15>/LCRScal_DPWG4' */
  rtb_TmpSignalConversionAtLoo_ht[0] = r;
  rtb_TmpSignalConversionAtLoo_ht[1] = rtb_Divide2_f;

  /* S-Function (sfix_look1_dyn): '<S15>/LCRScal_DPWG4' */
  /* Dynamic Look-Up Table Block: '<S15>/LCRScal_DPWG4'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(r), &rtb_TmpSignalConversionAtLoo_ht[0], rtb_Sum8_m,
                       &rtb_TmpSignalConversionAtLook_d[0], 1U, inst);

  /* BusCreator: '<Root>/Bus Creator1' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion3'
   *  DataTypeConversion: '<Root>/Data Type Conversion5'
   *  DataTypeConversion: '<Root>/Data Type Conversion6'
   *  DataTypeConversion: '<Root>/Data Type Conversion8'
   *  Delay: '<S15>/Resettable Delay'
   */
  Gen2_ref_Y->dbg.LxWgvCmp.CDSet = (real32_T)rtb_DataTypeConversion15;
  Gen2_ref_Y->dbg.LxWgvCmp.DeltaCD_aux = (real32_T)rtb_Sum_mf;
  Gen2_ref_Y->dbg.LxWgvCmp.DeltaP2s_set = (real32_T)r;
  Gen2_ref_Y->dbg.LxWgvCmp.DeltaP2s_Comp_WGV = (real32_T)
    Gen2_ref_DWork->ResettableDelay_DSTATE;

  /* BusCreator: '<S6>/Bus Creator' incorporates:
   *  Delay: '<Root>/Delay6'
   */
  Gen2_ref_Y->dbg.GQC.bActGasQualImprov = rtb_bActGasQualImprov;
  Gen2_ref_Y->dbg.GQC.bDetSatLambda = rtb_LogicalOperator2_fy;
  Gen2_ref_Y->dbg.GQC.bDetKnock = rtb_Switch2_jv;
  Gen2_ref_Y->dbg.GQC.bDetSatActuators = Gen2_ref_DWork->Delay6_DSTATE;
  Gen2_ref_Y->dbg.GQC.bMisfDet = rtb_Switch4_mu;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S427>/Bus Creator5'
   *  BusCreator: '<S429>/Bus Creator'
   *  DataTypeConversion: '<S418>/Data Type Conversion10'
   *  DataTypeConversion: '<S418>/Data Type Conversion11'
   *  DataTypeConversion: '<S418>/Data Type Conversion12'
   *  DataTypeConversion: '<S418>/Data Type Conversion13'
   *  DataTypeConversion: '<S427>/Data Type Conversion'
   *  DataTypeConversion: '<S427>/Data Type Conversion1'
   *  DataTypeConversion: '<S427>/Data Type Conversion2'
   *  DataTypeConversion: '<S427>/Data Type Conversion3'
   *  DataTypeConversion: '<S427>/Data Type Conversion4'
   *  DataTypeConversion: '<S429>/Data Type Conversion1'
   *  DataTypeConversion: '<S429>/Data Type Conversion4'
   *  DataTypeConversion: '<S429>/Data Type Conversion5'
   *  DataTypeConversion: '<S432>/Data Type Conversion1'
   *  DataTypeConversion: '<S432>/Data Type Conversion10'
   *  DataTypeConversion: '<S432>/Data Type Conversion11'
   *  DataTypeConversion: '<S432>/Data Type Conversion2'
   *  DataTypeConversion: '<S432>/Data Type Conversion3'
   *  DataTypeConversion: '<S432>/Data Type Conversion4'
   *  DataTypeConversion: '<S432>/Data Type Conversion5'
   *  DataTypeConversion: '<S432>/Data Type Conversion6'
   *  DataTypeConversion: '<S581>/Data Type Conversion6'
   *  Outport: '<Root>/dbg'
   *  Quantizer: '<S581>/Quantizer1'
   */
  Gen2_ref_Y->dbg.HLCi.FF.rPest_FF = (real32_T)rtb_Switch_bs;
  Gen2_ref_Y->dbg.HLCi.FF.rP2s_FF = (real32_T)rtb_mbar2pa_g;
  Gen2_ref_Y->dbg.HLCi.FF.P_est_vFilt = (real32_T)rtb_Switch2_gs;
  Gen2_ref_Y->dbg.HLCi.FF.LineVol_nPower = (real32_T)rtb_Switch_iy;
  Gen2_ref_Y->dbg.HLCi.FF.LineVol_vPower = (real32_T)rtb_rKK2_k;
  Gen2_ref_Y->dbg.HLCi.FF.rFactLSL = (real32_T)rtb_Sum1_jz;
  Gen2_ref_Y->dbg.HLCi.FF.rLSLff_p = (real32_T)rtb_Divide_kp;
  Gen2_ref_Y->dbg.HLCi.FF.rLSLff_d = (real32_T)rtb_Divide2_a;
  Gen2_ref_Y->dbg.HLCi.LR.bLR_GasStop = rtb_TOF_IN;
  Gen2_ref_Y->dbg.HLCi.LR.bIgnOff = rtb_bCBV_min;
  Gen2_ref_Y->dbg.HLCi.LR.bLR_ActSat_CBV =
    Gen2_ref_B->TP_ActSat_CBV.LogicalOperator1;
  Gen2_ref_Y->dbg.HLCi.LR.bLR_ActSat_TV =
    Gen2_ref_B->TP_ActSat_TV.LogicalOperator1;
  Gen2_ref_Y->dbg.HLCi.LR.bLR_IGN_Retard_Trig = rtb_RelationalOperator2_j;
  Gen2_ref_Y->dbg.HLCi.LR.rP_Rot_Corr_Norm = (real32_T)rtb_Saturation;
  Gen2_ref_Y->dbg.HLCi.LR.IGN_retard_interpol = (real32_T)rtb_Switch2_jq;
  Gen2_ref_Y->dbg.HLCi.LR.IGN_retard_active = (real32_T)rtb_Divide4_d;
  Gen2_ref_Y->dbg.HLCi.LR.delta_IGN_Retard = (real32_T)rtb_MinMax_a;
  Gen2_ref_Y->dbg.HLCi.LR.rFactCompLR = (real32_T)rtb_Switch2_l;
  Gen2_ref_Y->dbg.HLCi.LR.bLR_SatActuators = rtb_LogicalOperator3_gq;
  Gen2_ref_Y->dbg.HLCi.Prot.omega = (real32_T)rtb_Gain;
  Gen2_ref_Y->dbg.HLCi.Prot.omega_filt = (real32_T)rtb_Switch_eu;
  Gen2_ref_Y->dbg.HLCi.Prot.omega_dot = (real32_T)rtb_Switch1_mm;
  Gen2_ref_Y->dbg.HLCi.Prot.rProt = (real32_T)rtb_Gain1_fr;
  Gen2_ref_Y->dbg.HLCi.SkipF.rSkipfire_PI = (real32_T)rtb_Switch2_ba;
  Gen2_ref_Y->dbg.HLCi.SkipF.rLam_skip = (real32_T)rtb_Switch_fi;
  Gen2_ref_Y->dbg.HLCi.SkipF.bDemand_Skip = rtb_LogicalOperator1_ja;
  Gen2_ref_Y->dbg.HLCi.SkipF.rSkip_level = (real32_T)rtb_rSkip_level;
  Gen2_ref_Y->dbg.HLCi.SkipF.rSkipfire = (real32_T)rtb_Divide1_f1_tmp;
  Gen2_ref_Y->dbg.HLCi.SkipF.bSkip_pulse_on = rtb_LogicalOperator1_pa;

  /* Switch: '<S429>/Switch1' incorporates:
   *  BusCreator: '<Root>/Bus Creator'
   *  DataTypeConversion: '<S429>/Data Type Conversion2'
   *  Outport: '<Root>/dbg'
   */
  Gen2_ref_Y->dbg.HLCi.SkipF.rN_diff = (real32_T)rtb_Divide_mr_tmp;

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  BusCreator: '<S1>/Bus Creator2'
   *  BusCreator: '<S23>/Bus Creator1'
   *  BusCreator: '<S389>/Bus Creator1'
   *  BusCreator: '<S431>/Bus Creator'
   *  BusCreator: '<S7>/Bus Creator2'
   *  DataTypeConversion: '<S12>/Data Type Conversion1'
   *  DataTypeConversion: '<S1>/Data Type Conversion'
   *  DataTypeConversion: '<S1>/Data Type Conversion1'
   *  DataTypeConversion: '<S1>/Data Type Conversion10'
   *  DataTypeConversion: '<S1>/Data Type Conversion16'
   *  DataTypeConversion: '<S1>/Data Type Conversion17'
   *  DataTypeConversion: '<S1>/Data Type Conversion18'
   *  DataTypeConversion: '<S1>/Data Type Conversion2'
   *  DataTypeConversion: '<S1>/Data Type Conversion22'
   *  DataTypeConversion: '<S1>/Data Type Conversion23'
   *  DataTypeConversion: '<S1>/Data Type Conversion24'
   *  DataTypeConversion: '<S1>/Data Type Conversion3'
   *  DataTypeConversion: '<S1>/Data Type Conversion4'
   *  DataTypeConversion: '<S1>/Data Type Conversion5'
   *  DataTypeConversion: '<S1>/Data Type Conversion6'
   *  DataTypeConversion: '<S1>/Data Type Conversion8'
   *  DataTypeConversion: '<S23>/Data Type Conversion'
   *  DataTypeConversion: '<S23>/Data Type Conversion1'
   *  DataTypeConversion: '<S23>/Data Type Conversion2'
   *  DataTypeConversion: '<S23>/Data Type Conversion3'
   *  DataTypeConversion: '<S23>/Data Type Conversion4'
   *  DataTypeConversion: '<S23>/Data Type Conversion6'
   *  DataTypeConversion: '<S23>/Data Type Conversion7'
   *  DataTypeConversion: '<S26>/Data Type Conversion'
   *  DataTypeConversion: '<S26>/Data Type Conversion2'
   *  DataTypeConversion: '<S26>/Data Type Conversion3'
   *  DataTypeConversion: '<S26>/Data Type Conversion4'
   *  DataTypeConversion: '<S26>/Data Type Conversion5'
   *  DataTypeConversion: '<S26>/Data Type Conversion7'
   *  DataTypeConversion: '<S379>/Data Type Conversion10'
   *  DataTypeConversion: '<S379>/Data Type Conversion3'
   *  DataTypeConversion: '<S379>/Data Type Conversion5'
   *  DataTypeConversion: '<S379>/Data Type Conversion8'
   *  DataTypeConversion: '<S389>/Data Type Conversion3'
   *  DataTypeConversion: '<S389>/Data Type Conversion6'
   *  DataTypeConversion: '<S389>/Data Type Conversion8'
   *  DataTypeConversion: '<S431>/Data Type Conversion1'
   *  DataTypeConversion: '<S431>/Data Type Conversion10'
   *  DataTypeConversion: '<S431>/Data Type Conversion11'
   *  DataTypeConversion: '<S431>/Data Type Conversion12'
   *  DataTypeConversion: '<S431>/Data Type Conversion13'
   *  DataTypeConversion: '<S431>/Data Type Conversion14'
   *  DataTypeConversion: '<S431>/Data Type Conversion15'
   *  DataTypeConversion: '<S431>/Data Type Conversion16'
   *  DataTypeConversion: '<S431>/Data Type Conversion17'
   *  DataTypeConversion: '<S431>/Data Type Conversion18'
   *  DataTypeConversion: '<S431>/Data Type Conversion19'
   *  DataTypeConversion: '<S431>/Data Type Conversion2'
   *  DataTypeConversion: '<S431>/Data Type Conversion20'
   *  DataTypeConversion: '<S431>/Data Type Conversion21'
   *  DataTypeConversion: '<S431>/Data Type Conversion22'
   *  DataTypeConversion: '<S431>/Data Type Conversion23'
   *  DataTypeConversion: '<S431>/Data Type Conversion24'
   *  DataTypeConversion: '<S431>/Data Type Conversion25'
   *  DataTypeConversion: '<S431>/Data Type Conversion26'
   *  DataTypeConversion: '<S431>/Data Type Conversion27'
   *  DataTypeConversion: '<S431>/Data Type Conversion3'
   *  DataTypeConversion: '<S431>/Data Type Conversion4'
   *  DataTypeConversion: '<S431>/Data Type Conversion5'
   *  DataTypeConversion: '<S431>/Data Type Conversion6'
   *  DataTypeConversion: '<S431>/Data Type Conversion7'
   *  DataTypeConversion: '<S431>/Data Type Conversion8'
   *  DataTypeConversion: '<S431>/Data Type Conversion9'
   *  DataTypeConversion: '<S43>/Data Type Conversion1'
   *  DataTypeConversion: '<S43>/Data Type Conversion24'
   *  DataTypeConversion: '<S43>/Data Type Conversion25'
   *  DataTypeConversion: '<S43>/Data Type Conversion3'
   *  DataTypeConversion: '<S45>/Data Type Conversion'
   *  DataTypeConversion: '<S45>/Data Type Conversion2'
   *  DataTypeConversion: '<S45>/Data Type Conversion3'
   *  DataTypeConversion: '<S45>/Data Type Conversion4'
   *  DataTypeConversion: '<S45>/Data Type Conversion7'
   *  DataTypeConversion: '<S4>/Data Type Conversion29'
   *  DataTypeConversion: '<S78>/Data Type Conversion1'
   *  DataTypeConversion: '<S78>/Data Type Conversion10'
   *  DataTypeConversion: '<S78>/Data Type Conversion2'
   *  DataTypeConversion: '<S78>/Data Type Conversion3'
   *  DataTypeConversion: '<S78>/Data Type Conversion4'
   *  DataTypeConversion: '<S78>/Data Type Conversion5'
   *  DataTypeConversion: '<S78>/Data Type Conversion7'
   *  DataTypeConversion: '<S78>/Data Type Conversion8'
   *  DataTypeConversion: '<S78>/Data Type Conversion9'
   *  DataTypeConversion: '<S7>/Data Type Conversion1'
   *  DiscreteIntegrator: '<S26>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S45>/Discrete-Time Integrator1'
   *  DiscreteIntegrator: '<S62>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator4'
   *  Gain: '<S431>/Gain1'
   *  Gain: '<S7>/Pa2bar'
   *  Logic: '<S45>/Logical Operator'
   *  MATLAB Function: '<S431>/LQR Controller 3states'
   *  Outport: '<Root>/dbg'
   *  SignalConversion generated from: '<S627>/ SFunction '
   *  Sum: '<S641>/Sum2'
   *  Sum: '<S641>/Sum6'
   */
  Gen2_ref_Y->dbg.HLCi.LQR.x_ref[0] = (real32_T)rtb_Saturation6;
  Gen2_ref_Y->dbg.HLCi.LQR.x_ref[1] = (real32_T)rtb_Abs;
  Gen2_ref_Y->dbg.HLCi.LQR.x_ref[2] = (real32_T)rtb_Switch2_c4;
  Gen2_ref_Y->dbg.HLCi.LQR.x_sp[0] = (real32_T)rtb_Sum1_l;
  Gen2_ref_Y->dbg.HLCi.LQR.x_sp[1] = (real32_T)rtb_Sum2_a_tmp;
  Gen2_ref_Y->dbg.HLCi.LQR.x_sp[2] = (real32_T)rtb_Sum6_o_tmp;
  Gen2_ref_Y->dbg.HLCi.LQR.x_k[0] = (real32_T)rtb_Gain1_f_tmp;
  Gen2_ref_Y->dbg.HLCi.LQR.x_k[1] = (real32_T)rtb_Gain3;
  Gen2_ref_Y->dbg.HLCi.LQR.x_k[2] = (real32_T)Gen2_ref_B->Filter_bd.Switch;
  Gen2_ref_Y->dbg.HLCi.LQR.u_k[0] = (real32_T)rtb_Product_m[0];
  Gen2_ref_Y->dbg.HLCi.LQR.u_k[1] = (real32_T)rtb_Product_m[1];
  Gen2_ref_Y->dbg.HLCi.LQR.u_k[2] = (real32_T)rtb_Product_m[2];
  Gen2_ref_Y->dbg.HLCi.LQR.u_k[3] = (real32_T)rtb_Product_m[3];
  Gen2_ref_Y->dbg.HLCi.LQR.x_dist1_map = (real32_T)rtb_Gain1_o;
  Gen2_ref_Y->dbg.HLCi.LQR.x_KF[0] = (real32_T)rtb_x_KF_out_idx_0;
  Gen2_ref_Y->dbg.HLCi.LQR.x_dist_KF[0] = (real32_T)rtb_Switch1_cl[0];
  Gen2_ref_Y->dbg.HLCi.LQR.x_sp_KF[0] = (real32_T)rtb_x_sp_KF_idx_0;
  Gen2_ref_Y->dbg.HLCi.LQR.x_KF[1] = (real32_T)rtb_x_KF_out_idx_1;
  Gen2_ref_Y->dbg.HLCi.LQR.x_dist_KF[1] = (real32_T)rtb_Switch1_cl[1];
  Gen2_ref_Y->dbg.HLCi.LQR.x_sp_KF[1] = (real32_T)rtb_x_sp_KF_idx_1;
  Gen2_ref_Y->dbg.HLCi.LQR.x_KF[2] = (real32_T)rtb_x_KF_out_idx_2;
  Gen2_ref_Y->dbg.HLCi.LQR.x_dist_KF[2] = (real32_T)rtb_Switch1_cl[2];
  Gen2_ref_Y->dbg.HLCi.LQR.x_sp_KF[2] = (real32_T)rtb_x_sp_KF_idx_2;
  Gen2_ref_Y->dbg.HLCi.LQR.u_sp_KF[0] = (real32_T)rtb_u_sp_KF[0];
  Gen2_ref_Y->dbg.HLCi.LQR.u_sp_KF[1] = (real32_T)rtb_u_sp_KF[1];
  Gen2_ref_Y->dbg.HLCi.LQR.err_KF[0] = (real32_T)rtb_err_KF[0];
  Gen2_ref_Y->dbg.HLCi.LQR.err_KF[1] = (real32_T)rtb_err_KF[1];
  Gen2_ref_Y->dbg.HLCi.LQR.err_KF[2] = (real32_T)rtb_err_KF[2];
  for (i = 0; i < 18; i++) {
    Gen2_ref_Y->dbg.HLCi.LQR.K_KF[i] = (real32_T)rtb_K_KF_out[i];
  }

  for (i = 0; i < 36; i++) {
    Gen2_ref_Y->dbg.HLCi.LQR.P_KF[i] = (real32_T)Gen2_ref_DWork->P_KF[i];
  }

  Gen2_ref_Y->dbg.HLCi.LQR.err_cont[0] = (real32_T)rtb_err_cont[0];
  Gen2_ref_Y->dbg.HLCi.LQR.err_cont[1] = (real32_T)rtb_err_cont[1];
  Gen2_ref_Y->dbg.HLCi.LQR.err_cont[2] = (real32_T)rtb_err_cont[2];
  Gen2_ref_Y->dbg.HLCi.LQR.Ke_calc = (real32_T)rtb_Switch_nb;
  Gen2_ref_Y->dbg.HLCi.LQR.Ke = (real32_T)rtb_Product_o;
  Gen2_ref_Y->dbg.HLCi.LQR.Ke0 = (real32_T)rtb_VariableIntegerDelay;
  Gen2_ref_Y->dbg.HLCi.LQR.eOmRef = (real32_T)rtb_Switch_dhr;
  Gen2_ref_Y->dbg.HLCi.LQR.bTrigDPr_limit = rtb_Act;
  Gen2_ref_Y->dbg.HLCi.LQR.bOutOfNWindow = rtb_LogicalOperator4_go;
  Gen2_ref_Y->dbg.HLCi.LQR.omega_dot = (real32_T)((rtb_Product_o / (y_map_tmp_0 *
    rtb_Sum1_idx_2 + 1.0) * y_map_tmp * (rtb_Product_m[2] *
    Gen2_ref_B->BusInput3.SpeedCtrl.rK_it2_iLQR + 1.0) - rtb_Divide_i1) * (1.0 /
    rtb_TmpSignalConversionAtSFunct[3]));
  Gen2_ref_Y->dbg.HLCi.LQR.bLamSat = rtb_LogicalOperator2_ov;
  for (i = 0; i < 9; i++) {
    Gen2_ref_Y->dbg.HLCi.LQR.Phi[i] = (real32_T)rtb_Phi_OUT[i];
  }

  Gen2_ref_Y->dbg.HLCi.LQR.x_k_pred[0] = (real32_T)
    rtb_TmpSignalConversionAtSFun_g[0];
  Gen2_ref_Y->dbg.HLCi.LQR.x_k_pred[1] = (real32_T)
    rtb_TmpSignalConversionAtSFun_g[1];
  Gen2_ref_Y->dbg.HLCi.LQR.x_k_pred[2] = (real32_T)
    rtb_TmpSignalConversionAtSFun_g[2];
  for (i = 0; i < 12; i++) {
    Gen2_ref_Y->dbg.HLCi.LQR.H[i] = (real32_T)rtb_H_OUT[i];
    Gen2_ref_Y->dbg.HLCi.LQR.K_LQR[i] = (real32_T)rtb_K_LQR[i];
  }

  for (i = 0; i < 9; i++) {
    Gen2_ref_Y->dbg.HLCi.LQR.P_LQR[i] = (real32_T)Gen2_ref_DWork->P[i];
  }

  Gen2_ref_Y->dbg.HLCi.LQR.Ke_act_map = (real32_T)rtb_Switch1_ep;
  Gen2_ref_Y->dbg.HLCi.LQR.bAdaptReleased = rtb_RelationalOperator_ok;
  Gen2_ref_Y->dbg.HLCi.LQR.bResKeEst = rtb_Switch2_ij;
  Gen2_ref_Y->dbg.HLCi.LQR.bKeEstTransDet = rtb_Switch3_of;
  Gen2_ref_Y->dbg.HLCi.LQR.Ke_est = (real32_T)Gen2_ref_B->Filter1_o.Switch;
  Gen2_ref_Y->dbg.HLCi.LQR.delta_IT_Acc = (real32_T)rtb_Product4_d;
  Gen2_ref_Y->dbg.HLCi.LQR.dPr_P2s_RefSatLam = (real32_T)
    Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE;
  Gen2_ref_Y->dbg.HLC.Gen2DbgHlcTraj.rp2s_leanox = (real32_T)(1.0E-5 *
    rtb_Pa2bar_k);

  /* Outputs for Atomic SubSystem: '<S342>/PID_Power' */
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.ff = (real32_T)rtb_Switch_e3;
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.ud = (real32_T)rtb_Divide3_p;
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.aw_ext = (real32_T)rtb_Switch8;

  /* End of Outputs for SubSystem: '<S342>/PID_Power' */
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.aw_aux =
    Gen2_ref_B->BusInput.rAW_EGT_ext;

  /* Outputs for Atomic SubSystem: '<S342>/PID_Power' */
  Gen2_ref_Y->dbg.HLC.BGen2DbgHlcPowCtrl.u = (real32_T)rtb_Switch2_jw;

  /* End of Outputs for SubSystem: '<S342>/PID_Power' */

  /* Outputs for Atomic SubSystem: '<S343>/PID_Power' */
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.ff = 0.0F;

  /* End of Outputs for SubSystem: '<S343>/PID_Power' */
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.ui = rtb_BusCreator1_h_ui;

  /* Outputs for Atomic SubSystem: '<S343>/PID_Power' */
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.ud = (real32_T)rtb_Divide3_d;
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.aw_ext = 0.0F;
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.aw_aux = (real32_T)rtb_Product1;
  Gen2_ref_Y->dbg.HLC.dbgHLCPowCtrlGQC.u = (real32_T)
    Gen2_ref_B->sf_MATLABFunction1_ep.LamOut;

  /* End of Outputs for SubSystem: '<S343>/PID_Power' */
  Gen2_ref_Y->dbg.BDC.Misc.PI_tv = (real32_T)rtb_Divide_br;
  Gen2_ref_Y->dbg.BDC.Misc.PI_LP = (real32_T)rtb_Divide2;
  Gen2_ref_Y->dbg.BDC.Misc.PI_HP = (real32_T)rtb_Divide1_fn;
  Gen2_ref_Y->dbg.BDC.Misc.PI_total = (real32_T)rtb_Divide3_a0;
  Gen2_ref_Y->dbg.BDC.tv.ff = (real32_T)
    Gen2_ref_B->Inverse_Linearization1.LCRScal_Lam_EOT1;
  Gen2_ref_Y->dbg.BDC.tv.up = (real32_T)rtb_Product4;
  Gen2_ref_Y->dbg.BDC.tv.ui = (real32_T)
    Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_n;
  Gen2_ref_Y->dbg.BDC.tv.uaw = (real32_T)rtb_Switch2_oou;
  Gen2_ref_Y->dbg.BDC.tv.i0 = (real32_T)rtb_Switch1_d2;
  Gen2_ref_Y->dbg.BDC.tv.bTVCtrl_ON = !rtb_i_reset;
  Gen2_ref_Y->dbg.BDC.cbv.ff_cbv = (real32_T)rtb_Saturation1_i;
  Gen2_ref_Y->dbg.BDC.cbv.ff_cbv_unsat = (real32_T)rtb_Sum1_lo;
  Gen2_ref_Y->dbg.BDC.cbv.up_cbv = (real32_T)rtb_up;
  Gen2_ref_Y->dbg.BDC.cbv.ui_cbv = (real32_T)
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ja;
  Gen2_ref_Y->dbg.BDC.cbv.uaw_cbv = (real32_T)FILT_IN;
  Gen2_ref_Y->dbg.BDC.cbv.i0_cbv = (real32_T)rtb_Add2_h;
  Gen2_ref_Y->dbg.BDC.SP.rCBV_Min = (real32_T)rtb_Switch2_a;
  Gen2_ref_Y->dbg.BDC.SP.rTV_Min = (real32_T)rtb_Switch_e;
  Gen2_ref_Y->dbg.BDC.SP.rMdot_mixture_cyl = (real32_T)rtb_MassFlowCalc;
  Gen2_ref_Y->dbg.BDC.SP.rPrR_TC_Surge = (real32_T)rtb_Saturation_gh;
  Gen2_ref_Y->dbg.BDC.MP.u = (real32_T)rtb_Sum11;
  Gen2_ref_Y->dbg.BDC.MP.u_ff = (real32_T)rtb_MinMax1_h;
  Gen2_ref_Y->dbg.BDC.MP.u0 = (real32_T)rtb_Sum7_l5;
  Gen2_ref_Y->dbg.BDC.MP.u0_ff = (real32_T)rtb_MinMax1_g;
  Gen2_ref_Y->dbg.BDC.MP.TVdp = (real32_T)rtb_Product2;
  Gen2_ref_Y->dbg.BDC.MP.offset = (real32_T)
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a;
  Gen2_ref_Y->dbg.BDC.MP.offset_in = (real32_T)rtb_Gain_kl;
  Gen2_ref_Y->dbg.BDC.RL.RLp2s_d = (real32_T)rtb_p1LP;
  Gen2_ref_Y->dbg.BDC.RL.RLp2s_d_ff = (real32_T)rtb_p1HP;
  Gen2_ref_Y->dbg.BDC.RL.RLp2s_d_ff_z = (real32_T)rtb_VariableIntegerDelay_b;
  Gen2_ref_Y->dbg.BDC.RL.RLact = (real32_T)rtb_MinMax3;
  Gen2_ref_Y->dbg.BDC.RL.RL = (real32_T)rtb_MinMax_mf;
  Gen2_ref_Y->dbg.BDC.RL.Rlrequ = (real32_T)rtb_Divide_kt;
  Gen2_ref_Y->dbg.BDC.RL.RLp2s_d_RL = (real32_T)rtb_p2HP;
  Gen2_ref_Y->dbg.BDC.RL.RLp2s_d_ff_RL = (real32_T)rtb_Sum5_iu;
  Gen2_ref_Y->dbg.BDC.RL.Rlreset = rtb_LogicalOperator3_ja;
  Gen2_ref_Y->dbg.BDC.traj.ref_P2_FF_CBV = rtb_Switch2_h1;
  Gen2_ref_Y->dbg.BDC.traj.ref_P2s_FF = rtb_Switch2_lu;
  Gen2_ref_Y->dbg.BDC.traj.ref_P2_FF = rtb_BusCreator1_ref_P2_FF;
  Gen2_ref_Y->dbg.BDC.traj.ref_P2s_FB_TV = rtb_BusCreator1_ref_P2s_FB_TV;
  Gen2_ref_Y->dbg.BDC.traj.ref_P2_FB_CBV = rtb_BusCreator1_ref_P2_FB_CBV;
  Gen2_ref_Y->dbg.BDC.traj.ref_P2s_FF_TV = rtb_Switch2_jf;
  Gen2_ref_Y->dbg.BDC.traj.d_dt_ref_P2s_FF_TV = Gen2_ref_B->Filter2.Switch1;
  Gen2_ref_Y->dbg.BDC.traj.d_dt_ref_P2_FF_CBV = Gen2_ref_B->Filter1.Switch1;
  Gen2_ref_Y->dbg.BDC.traj.d_dt_ref_P2s_FF = Gen2_ref_B->Filter4.Switch1;
  Gen2_ref_Y->dbg.BDC.FF.me = (real32_T)rtb_dm_e;
  Gen2_ref_Y->dbg.BDC.FF.me_d = (real32_T)Gen2_ref_B->sf_enginemassflow.dm_e;
  Gen2_ref_Y->dbg.BDC.FF.me_cbv_d = (real32_T)rtb_Abs_n;
  Gen2_ref_Y->dbg.BDC.FF.TV_me_d = (real32_T)rtb_Divide_n0;
  Gen2_ref_Y->dbg.BDC.FF.wg_me = (real32_T)Gen2_ref_B->sf_enginemassflow1_e.dm_e;
  Gen2_ref_Y->dbg.BDC.FF.wg_me_d = (real32_T)
    Gen2_ref_B->sf_enginemassflow_h.dm_e;
  Gen2_ref_Y->dbg.BDC.FF.wg_m_d = (real32_T)rtb_Saturation_cx;
  Gen2_ref_Y->dbg.BDC.FF.u_ff_cbv = (real32_T)rtb_Sum1_lo;
  Gen2_ref_Y->dbg.BDC.FF.dbg_cbvTracking_PI = (real32_T)rtb_Sum3_hx;
  Gen2_ref_Y->dbg.BDC.FF.dbg_cbvTracking_P = (real32_T)rtb_Divide1_k;
  Gen2_ref_Y->dbg.BDC.FF.dbg_cbvTracking_I = (real32_T)
    rtb_DiscreteTimeIntegrator_g3;
  Gen2_ref_Y->dbg.KeEstNetP.KeEstNetP = (real32_T)Gen2_ref_B->Filter1_n.Switch;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' incorporates:
   *  Outport: '<Root>/dbg'
   */
  inst->dbgOut = Gen2_ref_Y->dbg;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' incorporates:
   *  Outport: '<Root>/out'
   */
  inst->OUT = Gen2_ref_Y->out;

  /* S-Function (bur_in): '<Root>/Input1' */
  Gen2_ref_B->Input1 = inst->rLam_BrakeEffEst;

  /* Outputs for Atomic SubSystem: '<Root>/brake eff estimate' */
  /* Gain: '<S21>/Gain' */
  rtb_Sum_mf = 0.10471975511965977 * Gen2_ref_B->BusInput3.eng.rN_Nom;

  /* Product: '<S21>/Divide' */
  rtb_Sum_mf = Gen2_ref_B->BusInput3.eng.rVol_Hub_Eng * rtb_Sum1_idx_3 *
    rtb_Sum_mf * rtb_etaVolConst_lt * Gen2_ref_B->p2s_filt.Switch;

  /* Product: '<S21>/Divide3' */
  rtb_Divide2_f = Gen2_ref_B->Input1 * rtb_Sum1_idx_2;

  /* Sum: '<S21>/Sum1' incorporates:
   *  Constant: '<S21>/Constant2'
   */
  rtb_Gain = rtb_Divide2_f + 1.0;

  /* Gain: '<S21>/Gain1' */
  rtb_Divide2_f = rtb_Switch2_ejy_tmp;

  /* Saturate: '<S21>/Saturation3' */
  if (rtb_Sum_mf <= 1.0) {
    rtb_Sum_mf = 1.0;
  }

  /* End of Saturate: '<S21>/Saturation3' */

  /* Product: '<S21>/Divide2' incorporates:
   *  Constant: '<S21>/Constant'
   *  Product: '<S21>/Divide1'
   *  Sum: '<S21>/Sum2'
   */
  u0 = rtb_Gain * rtb_kW2W * Gen2_ref_B->T2s_filt.Switch *
    (Gen2_ref_B->Pel_filt.Switch + rtb_Divide2_f) * 12.566370614359172 * (1.0 /
    rtb_Sum_mf);

  /* Saturate: '<S21>/Saturation2' */
  if (u0 > 1.0) {
    /* DataTypeConversion: '<Root>/Data Type Conversion1' */
    Gen2_ref_B->DataTypeConversion1 = 1.0F;
  } else if (u0 < 0.0001) {
    /* DataTypeConversion: '<Root>/Data Type Conversion1' */
    Gen2_ref_B->DataTypeConversion1 = 0.0001F;
  } else {
    /* DataTypeConversion: '<Root>/Data Type Conversion1' */
    Gen2_ref_B->DataTypeConversion1 = (real32_T)u0;
  }

  /* End of Saturate: '<S21>/Saturation2' */
  /* End of Outputs for SubSystem: '<Root>/brake eff estimate' */

  /* S-Function (bur_out): '<Root>/Output' */
  inst->rEtaBrakeEst = Gen2_ref_B->DataTypeConversion1;

  /* DataTypeConversion: '<S22>/Data Type Conversion' incorporates:
   *  Constant: '<S47>/Constant'
   *  DiscreteIntegrator: '<S22>/Discrete-Time Integrator'
   *  RelationalOperator: '<S47>/Compare'
   */
  rtb_Sum_mf = (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i > 0.0);

  /* Product: '<S22>/Product1' */
  rtb_Divide2_f = rtb_Gain_kp * Gen2_ref_B->BusInput3.bdcWgv.rKiWgvTcOvrspdCtrl;

  /* Product: '<S22>/Product2' */
  rtb_Gain = Gen2_ref_B->BusInput3.bdcWgv.rIntDischargeTcOvrspedCtrl *
    rtb_Sum_mf;

  /* Saturate: '<S22>/Saturation2' */
  if (rtb_Divide2_f <= 0.0) {
    delta_y = 0.0;
  } else {
    delta_y = rtb_Divide2_f;
  }

  /* End of Saturate: '<S22>/Saturation2' */

  /* DataTypeConversion: '<S48>/Data Type Conversion1' incorporates:
   *  Constant: '<S66>/Constant'
   *  DiscreteIntegrator: '<S48>/Discrete-Time Integrator'
   *  RelationalOperator: '<S66>/Compare'
   */
  rtb_Sum_mf = (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac > 0.0);

  /* Product: '<S48>/Product3' */
  rtb_Divide2_f = rtb_Divide3_k *
    Gen2_ref_B->BusInput3.bdcMisc.rKiSurgeProtectSL;

  /* Sum: '<S48>/Sum11' incorporates:
   *  Product: '<S48>/Product4'
   */
  rtb_Switch_eu = rtb_Divide2_f -
    Gen2_ref_B->BusInput3.bdcMisc.rIntDischargeSurgeCtrl * rtb_Sum_mf;

  /* Sum: '<S26>/Sum2' incorporates:
   *  MATLAB Function: '<S26>/fb_err'
   *  Product: '<S26>/Product1'
   */
  rtb_Switch1_mm = err * rtb_Pa2bar + FILT_IN;

  /* Saturate: '<S132>/Saturation' */
  if (Gen2_ref_B->BusInput3.bdcMisc.rTiF_Pr_p2s > 1000.0) {
    FILT_IN = 1000.0;
  } else if (Gen2_ref_B->BusInput3.bdcMisc.rTiF_Pr_p2s < 0.001) {
    FILT_IN = 0.001;
  } else {
    FILT_IN = Gen2_ref_B->BusInput3.bdcMisc.rTiF_Pr_p2s;
  }

  /* End of Saturate: '<S132>/Saturation' */

  /* Product: '<S132>/Divide' incorporates:
   *  DiscreteIntegrator: '<S132>/Discrete-Time Integrator'
   *  Sum: '<S132>/Sum4'
   */
  rtb_Gain1_fr = (Gen2_ref_B->p2s_filt.Switch -
                  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_g) / FILT_IN;

  /* Abs: '<S135>/Abs' incorporates:
   *  Abs: '<S742>/Abs'
   */
  FILT_IN = rtb_Switch_dz_tmp;

  /* Switch: '<S135>/Switch' incorporates:
   *  Constant: '<S135>/Constant2'
   *  RelationalOperator: '<S135>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= FILT_IN) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.Ts;
  }

  /* End of Switch: '<S135>/Switch' */

  /* Product: '<S133>/Divide' incorporates:
   *  Logic: '<S133>/Logical Operator2'
   *  Logic: '<S133>/Logical Operator3'
   *  UnitDelay: '<S133>/Unit Delay'
   */
  rtb_Saturation = (real_T)((!rtb_LogicalOperator1_ix) &&
    Gen2_ref_DWork->UnitDelay_DSTATE_o) / rtb_bResetHlci_0;

  /* Switch: '<S161>/Switch' incorporates:
   *  Constant: '<S161>/Constant'
   */
  if (rtb_LogicalOperator3_k) {
    rtb_Sum8_m = rtb_Add2;
  } else {
    rtb_Sum8_m = 0.0;
  }

  /* End of Switch: '<S161>/Switch' */

  /* Product: '<S5>/Divide3' */
  rtb_Divide3_e[0] = Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2 *
    rtb_Divide_ab[0];
  rtb_Divide3_e[1] = Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2 *
    rtb_Divide_ab[1];
  rtb_Divide3_e[2] = Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2 *
    rtb_Divide_ab[2];
  rtb_Divide3_e[3] = Gen2_ref_B->BusInput.IN_EC_rGT_RatioMix_TC2 *
    rtb_Divide_ab[3];

  /* Switch: '<S345>/Switch2' incorporates:
   *  Constant: '<S345>/Constant4'
   *  Product: '<S345>/Divide'
   *  Saturate: '<S345>/Saturation'
   */
  if (Gen2_ref_B->BusInput.bActive_p2sMan) {
    rtb_DataTypeConversion15 = -100.0;
  } else {
    if (Gen2_ref_B->BusInput3.traj.rTiLEANOXman <= 0.01) {
      /* Saturate: '<S345>/Saturation' */
      rtb_bResetHlci_0 = 0.01;
    } else {
      /* Saturate: '<S345>/Saturation' */
      rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.traj.rTiLEANOXman;
    }

    rtb_DataTypeConversion15 = 1.0 / rtb_bResetHlci_0;
  }

  /* End of Switch: '<S345>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S8>/BDC_Trajectory' */
  /* DiscreteIntegrator: '<S417>/Discrete-Time Integrator' */
  if (rtb_bResetHlci || (Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_ly != 0))
  {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b = 1.0;
  }

  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b = 0.0;
  }

  /* Logic: '<S417>/Logical Operator' incorporates:
   *  Constant: '<S417>/Constant2'
   *  DiscreteIntegrator: '<S417>/Discrete-Time Integrator'
   *  RelationalOperator: '<S417>/Relational Operator'
   */
  rtb_LogicalOperator5_mv = ((0.99 <=
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b) || rtb_bResetHlci);

  /* Product: '<S434>/delta rise limit' */
  FILT_IN = rtb_Divide_mr_tmp_0;

  /* Delay: '<S434>/Delay' */
  Gen2_ref_DWork->icLoad_mu = ((((Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_mt ==
    1) != (int32_T)rtb_LogicalOperator5_mv) &&
    (Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_mt != 3)) ||
    rtb_LogicalOperator5_mv || Gen2_ref_DWork->icLoad_mu);
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_mt = rtb_LogicalOperator5_mv;
  if (Gen2_ref_DWork->icLoad_mu) {
    Gen2_ref_DWork->Delay_DSTATE_h4 = rtb_bar2Pa6;
  }

  /* Sum: '<S434>/Difference Inputs1' incorporates:
   *  Delay: '<S434>/Delay'
   *  Switch: '<S434>/etaVolConst'
   */
  rtb_bar2Pa6 -= Gen2_ref_DWork->Delay_DSTATE_h4;

  /* Switch: '<S437>/Switch2' incorporates:
   *  RelationalOperator: '<S437>/LowerRelop1'
   */
  if (!(rtb_bar2Pa6 > FILT_IN)) {
    /* Product: '<S434>/delta fall limit' incorporates:
     *  Gain: '<S417>/Gain15'
     *  SampleTimeMath: '<S434>/sample time'
     *
     * About '<S434>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Gain2_ao = -rtb_Switch_ct_tmp * 0.01;

    /* Switch: '<S437>/Switch' incorporates:
     *  RelationalOperator: '<S437>/UpperRelop'
     */
    if (rtb_bar2Pa6 < rtb_Gain2_ao) {
      FILT_IN = rtb_Gain2_ao;
    } else {
      FILT_IN = rtb_bar2Pa6;
    }

    /* End of Switch: '<S437>/Switch' */
  }

  /* End of Switch: '<S437>/Switch2' */

  /* Sum: '<S434>/Difference Inputs2' incorporates:
   *  Delay: '<S434>/Delay'
   */
  rtb_bar2Pa6 = FILT_IN + Gen2_ref_DWork->Delay_DSTATE_h4;

  /* Outputs for Atomic SubSystem: '<S417>/p2sfilt' */
  Gen2_ref_N_TC_HP_filt(rtb_bar2Pa6, Gen2_ref_B->BusInput3.traj.rTiF_Pr_p2s_Man,
                        rtb_LogicalOperator5_mv, &Gen2_ref_B->p2sfilt_b,
                        &Gen2_ref_DWork->p2sfilt_b, inst);

  /* End of Outputs for SubSystem: '<S417>/p2sfilt' */

  /* Sum: '<S417>/Sum1' incorporates:
   *  Constant: '<S417>/Constant1'
   *  DiscreteIntegrator: '<S417>/Discrete-Time Integrator'
   *  Product: '<S417>/Product'
   *  Product: '<S417>/Product1'
   *  Sum: '<S417>/Sum'
   */
  rtb_Divide2_f = (1.0 - Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b) *
    Gen2_ref_B->p2sfilt_b.Switch +
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b * rtb_mbar2pa_i;

  /* Switch: '<S417>/Switch2' incorporates:
   *  Constant: '<S417>/Constant4'
   *  Product: '<S417>/Divide'
   *  Saturate: '<S417>/Saturation'
   */
  if (Gen2_ref_B->BusInput.bActive_p2sMan) {
    rtb_Gain2_ao = -100.0;
  } else {
    if (Gen2_ref_B->BusInput3.traj.rTiLEANOXman <= 0.01) {
      /* Saturate: '<S417>/Saturation' */
      rtb_bResetHlci_0 = 0.01;
    } else {
      /* Saturate: '<S417>/Saturation' */
      rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.traj.rTiLEANOXman;
    }

    rtb_Gain2_ao = 1.0 / rtb_bResetHlci_0;
  }

  /* End of Switch: '<S417>/Switch2' */

  /* Update for DiscreteIntegrator: '<S417>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S743>/Logical Operator'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b += 0.01 * rtb_Gain2_ao;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b = 0.0;
  }

  /* Outputs for Atomic SubSystem: '<S737>/Filter' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_ly = (int8_T)rtb_bResetHlci;

  /* End of Update for DiscreteIntegrator: '<S417>/Discrete-Time Integrator' */
  /* End of Outputs for SubSystem: '<S737>/Filter' */

  /* Update for Delay: '<S434>/Delay' */
  Gen2_ref_DWork->icLoad_mu = false;
  Gen2_ref_DWork->Delay_DSTATE_h4 = rtb_bar2Pa6;

  /* End of Outputs for SubSystem: '<S8>/BDC_Trajectory' */

  /* Sum: '<S427>/Sum5' incorporates:
   *  Constant: '<S427>/Constant6'
   */
  FILT_IN = Gen2_ref_B->BusInput3.LR.rTiAvoidTrigMisf + 0.01;

  /* DataTypeConversion: '<S427>/Data Type Conversion5' */
  rtb_rPos_CBV3 = (real32_T)FILT_IN;

  /* Sum: '<S427>/Sum7' incorporates:
   *  Constant: '<S427>/Constant6'
   *  Sum: '<S427>/Sum5'
   */
  FILT_IN = Gen2_ref_B->BusInput3.LR.rTiAvoidTrigMisf + 0.01;

  /* DataTypeConversion: '<S427>/Data Type Conversion6' */
  rtb_TOF2_PT = (real32_T)FILT_IN;

  /* Gain: '<S427>/Gain' */
  FILT_IN = 0.001 * rtb_Switch_i5[3];

  /* Abs: '<S507>/Abs' */
  rtb_Sum_mf = rtb_Product1_e_tmp;

  /* Switch: '<S507>/Switch' incorporates:
   *  Constant: '<S507>/Constant2'
   *  RelationalOperator: '<S507>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= rtb_Sum_mf) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.eng.rP_Nom;
  }

  /* End of Switch: '<S507>/Switch' */

  /* Product: '<S427>/Divide1' */
  rtb_bar2Pa6 = FILT_IN / rtb_bResetHlci_0;

  /* Outputs for Atomic SubSystem: '<S427>/TOF' */
  Gen2_ref_TOF_c(rtb_TOF_IN, rtb_rPos_CBV3, &Gen2_ref_B->TOF_c,
                 &Gen2_ref_DWork->TOF_c, inst);

  /* End of Outputs for SubSystem: '<S427>/TOF' */

  /* Outputs for Atomic SubSystem: '<S427>/TOF2' */
  Gen2_ref_TOF_c(Gen2_ref_B->TP_Misfire_ON.LogicalOperator1, rtb_TOF2_PT,
                 &Gen2_ref_B->TOF2_d, &Gen2_ref_DWork->TOF2_d, inst);

  /* End of Outputs for SubSystem: '<S427>/TOF2' */

  /* Abs: '<S583>/Abs' */
  FILT_IN = fabs(Gen2_ref_B->BusInput3.SkipF.rTiF_Lam);

  /* Switch: '<S583>/Switch' incorporates:
   *  Constant: '<S583>/Constant2'
   *  RelationalOperator: '<S583>/Relational Operator'
   */
  if (2.2204460492503131E-16 >= FILT_IN) {
    rtb_bResetHlci_0 = 2.2204460492503131E-16;
  } else {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.SkipF.rTiF_Lam;
  }

  /* End of Switch: '<S583>/Switch' */

  /* Product: '<S579>/Divide' incorporates:
   *  DiscreteIntegrator: '<S579>/Discrete-Time Integrator'
   *  Sum: '<S579>/Sum4'
   */
  rtb_Gain2_ao = (rtb_Sum2_kg - Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_m)
    / rtb_bResetHlci_0;

  /* Product: '<S586>/Product3' */
  rtb_p2s = Gen2_ref_B->BusInput3.SkipF.rKiTrackLam * rtb_W2kW_o;

  /* DataTypeConversion: '<S581>/Data Type Conversion13' */
  FILT_IN = Gen2_ref_B->BusInput3.SkipF.iNr_cycles_ignOFF;

  /* Bias: '<S608>/Bias' incorporates:
   *  Gain: '<S581>/ to Hz'
   *  Gain: '<S581>/Hz to cycle period2'
   *  Product: '<S581>/Divide7'
   */
  FILT_IN = FILT_IN / rtb_Saturation_o * 60.0 * 2.0 + -0.01;

  /* Abs: '<S612>/Abs' */
  rtb_Sum_mf = fabs(FILT_IN);

  /* RelationalOperator: '<S612>/Relational Operator' incorporates:
   *  Constant: '<S612>/Constant2'
   */
  rtb_TOF_IN = (2.2204460492503131E-16 >= rtb_Sum_mf);

  /* Sum: '<S608>/Sum1' */
  rtb_Sum_mf = Gen2_ref_B->BusInput3.SkipF.rThrsh_PulseGenerator_reset -
    Gen2_ref_B->BusInput3.SkipF.rThrsh_PulseGenerator_trigger;

  /* Switch: '<S612>/Switch' incorporates:
   *  Constant: '<S612>/Constant2'
   */
  if (rtb_TOF_IN) {
    FILT_IN = 2.2204460492503131E-16;
  }

  /* End of Switch: '<S612>/Switch' */

  /* Product: '<S608>/Product1' */
  rtb_Switch2_g3 = rtb_Sum_mf / FILT_IN;

  /* RelationalOperator: '<S608>/Relational Operator1' incorporates:
   *  DiscreteIntegrator: '<S608>/Discrete-Time Integrator'
   */
  rtb_TOF_IN = (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_h5 >=
                Gen2_ref_B->BusInput3.SkipF.rThrsh_PulseGenerator_reset);

  /* Outputs for Atomic SubSystem: '<S633>/Filter' */
  Gen2_ref_Filter3(Gen2_ref_B->sf_MATLABFunction_kd.y,
                   Gen2_ref_B->BusInput3.SkipF.rTiF_stat,
                   Gen2_ref_ConstB.Constant3, rtb_bResetHlci,
                   &Gen2_ref_B->Filter_pj, &Gen2_ref_DWork->Filter_pj, inst);

  /* End of Outputs for SubSystem: '<S633>/Filter' */

  /* MATLAB Function: '<S431>/ref traj' */
  if ((!Gen2_ref_DWork->x_not_empty_i) || rtb_bResetHlci) {
    Gen2_ref_DWork->x_d = rtb_Gain3;
    Gen2_ref_DWork->x_not_empty_i = true;
  }

  if ((Gen2_ref_B->BusInput3.traj.rTi_BDC >= Ts_tmp) ||
      rtb_LogicalOperator5_g_tmp) {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.traj.rTi_BDC;
  } else {
    rtb_bResetHlci_0 = Ts_tmp;
  }

  rtb_Switch2_a = rtb_Product_m[0] - Gen2_ref_DWork->x_d;
  u0 = 1.0 / rtb_bResetHlci_0 * rtb_Switch2_a;
  if ((Gen2_ref_B->BusInput3.traj.rTi_BDC >= Ts_tmp) ||
      rtb_LogicalOperator5_g_tmp) {
    rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.traj.rTi_BDC;
  } else {
    rtb_bResetHlci_0 = Ts_tmp;
  }

  FILT_IN = 1.0 / rtb_bResetHlci_0 * rtb_Switch2_a;
  if ((u0 >= FILT_IN) || rtIsNaN(FILT_IN)) {
    FILT_IN = u0;
  }

  if (FILT_IN > 0.0) {
    u0 = FILT_IN * Ts_tmp + Gen2_ref_DWork->x_d;
    rtb_Divide2_a = rtb_Gain3 + Gen2_ref_B->BusInput3.traj.rPrR_delta_p2s;
    if ((u0 <= rtb_Divide2_a) || rtIsNaN(rtb_Divide2_a)) {
      rtb_Divide2_a = u0;
    }
  } else {
    u0 = FILT_IN * Ts_tmp + Gen2_ref_DWork->x_d;
    rtb_Divide2_a = rtb_Gain3 - Gen2_ref_B->BusInput3.traj.rPrR_delta_p2s;
    if ((u0 >= rtb_Divide2_a) || rtIsNaN(rtb_Divide2_a)) {
      rtb_Divide2_a = u0;
    }
  }

  Gen2_ref_DWork->x_d = rtb_Divide2_a;

  /* SignalConversion generated from: '<S431>/Delay' */
  rtb_Divide_ab[0] = rtb_Divide2_a;
  rtb_Divide_ab[1] = Gen2_ref_B->Filter_bd.Switch;
  rtb_Divide_ab[3] = Gen2_ref_B->sf_MATLABFunction_kd.y;

  /* Sum: '<S634>/Sum1' */
  FILT_IN = rtb_Product1_c1_tmp;

  /* Outputs for Atomic SubSystem: '<S634>/TON' */
  Gen2_ref_TON_1(rtb_bTriger_IT_LJ, Gen2_ref_B->BusInput3.ITC.rITCtransTON,
                 &Gen2_ref_B->TON_c, &Gen2_ref_DWork->TON_c, inst);

  /* End of Outputs for SubSystem: '<S634>/TON' */

  /* Switch: '<S634>/Switch2' incorporates:
   *  Abs: '<S634>/Abs'
   *  Logic: '<S634>/Logical Operator1'
   *  Logic: '<S634>/Logical Operator5'
   *  RelationalOperator: '<S634>/Relational Operator3'
   */
  rtb_LogicalOperator5_mv = ((!rtb_bResetHlci) &&
    ((!Gen2_ref_B->TON_c.LogicalOperator3) ||
     (!(Gen2_ref_B->BusInput3.ITC.rITCtransNthrsh > fabs(FILT_IN)))) &&
    rtb_bTriger_IT_LJ);

  /* Switch: '<S714>/Switch6' incorporates:
   *  Constant: '<S714>/Constant'
   *  Constant: '<S715>/Constant'
   *  Logic: '<S714>/Logical Operator4'
   *  Switch: '<S715>/Switch6'
   */
  if (!rtb_LogicalOperator2_ov) {
    /* Switch: '<S714>/Switch1' incorporates:
     *  DiscreteIntegrator: '<S714>/Discrete-Time Integrator'
     *  Gain: '<S714>/Gain2'
     */
    if (rtb_Switch2_au) {
      /* Switch: '<S636>/Switch8' incorporates:
       *  Gain: '<S636>/Gain3'
       *  Logic: '<S636>/Logical Operator7'
       */
      if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_KeLearn_boost &&
          Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act) {
        rtb_bResetHlci_0 = -rtb_Switch1_cl[0];
      } else {
        rtb_bResetHlci_0 = rtb_Switch_dhr;
      }

      /* End of Switch: '<S636>/Switch8' */

      /* Product: '<S714>/Product' incorporates:
       *  Abs: '<S714>/Abs'
       *  Gain: '<S714>/Gain1'
       */
      rtb_Switch_ks = -fabs(Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptGain) *
        rtb_bResetHlci_0;

      /* Switch: '<S721>/Switch2' incorporates:
       *  Gain: '<S714>/Gain'
       *  RelationalOperator: '<S721>/LowerRelop1'
       *  RelationalOperator: '<S721>/UpperRelop'
       *  Switch: '<S721>/Switch'
       */
      if (rtb_Switch_ks > Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptRL) {
        rtb_Switch_ks = Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptRL;
      } else if (rtb_Switch_ks < -Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptRL) {
        /* Switch: '<S721>/Switch' incorporates:
         *  Gain: '<S714>/Gain'
         */
        rtb_Switch_ks = -Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptRL;
      }

      /* End of Switch: '<S721>/Switch2' */
    } else {
      rtb_Switch_ks = -Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_l;
    }

    /* End of Switch: '<S714>/Switch1' */

    /* Switch: '<S715>/Switch1' incorporates:
     *  DiscreteIntegrator: '<S715>/Discrete-Time Integrator'
     *  Gain: '<S715>/Gain2'
     */
    if (rtb_Switch3_le) {
      /* Switch: '<S636>/Switch9' incorporates:
       *  Gain: '<S636>/Gain4'
       *  Logic: '<S636>/Logical Operator8'
       */
      if (Gen2_ref_B->BusInput3.SpeedCtrl.bKF_KeLearn_power &&
          Gen2_ref_B->BusInput3.SpeedCtrl.bKF_act) {
        rtb_Switch_dhr = -rtb_Switch1_cl[0];
      }

      /* End of Switch: '<S636>/Switch9' */

      /* Product: '<S715>/Product' incorporates:
       *  Abs: '<S715>/Abs'
       *  Gain: '<S715>/Gain1'
       */
      rtb_Divide2_a = -fabs(Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptGain) *
        rtb_Switch_dhr;

      /* Switch: '<S725>/Switch2' incorporates:
       *  Gain: '<S715>/Gain'
       *  RelationalOperator: '<S725>/LowerRelop1'
       *  RelationalOperator: '<S725>/UpperRelop'
       *  Switch: '<S725>/Switch'
       */
      if (rtb_Divide2_a > Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptRL) {
        rtb_Divide2_a = Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptRL;
      } else if (rtb_Divide2_a < -Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptRL) {
        /* Switch: '<S725>/Switch' incorporates:
         *  Gain: '<S715>/Gain'
         */
        rtb_Divide2_a = -Gen2_ref_B->BusInput3.SpeedCtrl.rKeAdaptRL;
      }

      /* End of Switch: '<S725>/Switch2' */
    } else {
      rtb_Divide2_a = -Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_e;
    }

    /* End of Switch: '<S715>/Switch1' */
  } else {
    rtb_Switch_ks = 0.0;
    rtb_Divide2_a = 0.0;
  }

  /* End of Switch: '<S714>/Switch6' */

  /* Switch: '<S747>/Switch1' incorporates:
   *  Constant: '<S747>/Constant'
   *  Logic: '<S747>/Logical Operator'
   *  Logic: '<S747>/Logical Operator1'
   *  Switch: '<S747>/Switch2'
   *  UnitDelay: '<S641>/Unit Delay2'
   */
  if (!Gen2_ref_DWork->UnitDelay2_DSTATE_d2) {
    /* Switch: '<S747>/Switch3' */
    if (Gen2_ref_B->BusInput3.SpeedCtrl.bGS_Kspeed_iLQR) {
      /* S-Function (sfix_look1_dyn): '<S747>/gain scheduling Kspeed' */
      /* Dynamic Look-Up Table Block: '<S747>/gain scheduling Kspeed'
       * Input0  Data Type:  Floating Point real_T
       * Input1  Data Type:  Floating Point real_T
       * Input2  Data Type:  Floating Point real_T
       * Output0 Data Type:  Floating Point real_T
       * Lookup Method: Linear_Endpoint
       *
       */
      LookUp_real_T_real_T( &(rtb_gainschedulingKspeed),
                           &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Kspeed_y
                           [0], rtb_Gain3,
                           &Gen2_ref_B->BusInput3.SpeedCtrl.refPoint_iLQR_Kspeed_x
                           [0], 6U, inst);
      FILT_IN = rtb_gainschedulingKspeed;
    } else {
      FILT_IN = Gen2_ref_B->BusInput3.SpeedCtrl.rGain_ss_speed_iLQR;
    }

    /* End of Switch: '<S747>/Switch3' */
  } else if (Gen2_ref_DWork->UnitDelay2_DSTATE_d2 &&
             Gen2_ref_B->TON_d.LogicalOperator3) {
    /* Switch: '<S747>/Switch2' */
    FILT_IN = Gen2_ref_B->BusInput3.SpeedCtrl.rGain_ss_speed_iLQR_back;
  } else {
    FILT_IN = 0.0;
  }

  /* End of Switch: '<S747>/Switch1' */

  /* Switch: '<S747>/Switch4' incorporates:
   *  Constant: '<S747>/Constant'
   */
  if (rtb_LogicalOperator3_b) {
    rtb_Sum_mf = 0.0;
  } else {
    rtb_Sum_mf = Gen2_ref_B->BusInput3.SpeedCtrl.rGain_ss_boost_iLQR;
  }

  /* End of Switch: '<S747>/Switch4' */

  /* Switch: '<S641>/Switch' incorporates:
   *  Gain: '<S8>/pa2bar   '
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bSepEmisCtrl) {
    rtb_Abs = 1.0E-5 * rtb_Divide2_f;
  }

  /* End of Switch: '<S641>/Switch' */

  /* Sum: '<S748>/Sum3' incorporates:
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator4'
   */
  rtb_MinMax_n = (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE + rtb_Abs) -
    rtb_Gain3;

  /* Switch: '<S752>/Switch2' */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bAW_iLQR_LEANOX) {
    /* RelationalOperator: '<S752>/Relational Operator1' incorporates:
     *  Constant: '<S752>/Constant4'
     *  Product: '<S752>/Divide1'
     *  Sum: '<S752>/Sum'
     */
    rtb_LogicalOperator2_fy = (rtb_Divide3_ep / rtb_PrefOut >= 1.0 - rtb_PactOut);

    /* Switch: '<S752>/Switch' incorporates:
     *  Constant: '<S752>/Constant'
     *  Constant: '<S752>/Constant1'
     *  Logic: '<S752>/Logical Operator'
     *  RelationalOperator: '<S752>/Relational Operator'
     *  UnitDelay: '<Root>/Unit Delay3'
     */
    if ((Gen2_ref_DWork->UnitDelay3_DSTATE <= rtb_Switch2_ejy_tmp_0) &&
        rtb_LogicalOperator2_fy) {
      rtb_Divide2_f = 0.0;
    } else {
      rtb_Divide2_f = 1.0E+6;
    }

    /* End of Switch: '<S752>/Switch' */

    /* Switch: '<S755>/Switch2' incorporates:
     *  RelationalOperator: '<S755>/LowerRelop1'
     */
    if (!(rtb_MinMax_n > rtb_Divide2_f)) {
      /* Saturate: '<S752>/Saturation1' */
      if (Gen2_ref_B->BusInput3.bdcCbv.rPos_max > 1.0) {
        rtb_bResetHlci_0 = 1.0;
      } else if (Gen2_ref_B->BusInput3.bdcCbv.rPos_max < 0.1) {
        rtb_bResetHlci_0 = 0.1;
      } else {
        rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.bdcCbv.rPos_max;
      }

      /* End of Saturate: '<S752>/Saturation1' */

      /* Switch: '<S752>/Switch1' incorporates:
       *  Constant: '<S752>/Constant2'
       *  Constant: '<S752>/Constant3'
       *  Constant: '<S752>/Constant4'
       *  Logic: '<S752>/Logical Operator1'
       *  Logic: '<S752>/Logical Operator2'
       *  Product: '<S752>/Divide'
       *  RelationalOperator: '<S752>/Relational Operator2'
       *  RelationalOperator: '<S752>/Relational Operator3'
       *  Sum: '<S752>/Sum'
       *  UnitDelay: '<Root>/Unit Delay3'
       */
      if ((Gen2_ref_DWork->UnitDelay3_DSTATE / rtb_bResetHlci_0 >= 1.0 -
           rtb_PactOut) && ((rtb_Divide3_ep <= rtb_LogicalOperator1_js_tmp) ||
                            rtb_LogicalOperator2_fy)) {
        rtb_Divide2_f = 0.0;
      } else {
        rtb_Divide2_f = -1.0E+6;
      }

      /* End of Switch: '<S752>/Switch1' */

      /* Switch: '<S755>/Switch' incorporates:
       *  RelationalOperator: '<S755>/UpperRelop'
       */
      if (!(rtb_MinMax_n < rtb_Divide2_f)) {
        rtb_Divide2_f = rtb_MinMax_n;
      }

      /* End of Switch: '<S755>/Switch' */
    }
  } else {
    rtb_Divide2_f = rtb_MinMax_n;
  }

  /* Switch: '<S756>/Switch2' incorporates:
   *  RelationalOperator: '<S756>/LowerRelop1'
   *  RelationalOperator: '<S756>/UpperRelop'
   *  Switch: '<S756>/Switch'
   */
  if (Gen2_ref_B->Filter_bd.Switch > rtb_Switch2_n5) {
    rtb_Sum2_a1 = rtb_Switch2_n5;
  } else if (Gen2_ref_B->Filter_bd.Switch < rtb_Switch1_k) {
    /* Switch: '<S756>/Switch' */
    rtb_Sum2_a1 = rtb_Switch1_k;
  } else {
    rtb_Sum2_a1 = Gen2_ref_B->Filter_bd.Switch;
  }

  /* End of Switch: '<S756>/Switch2' */

  /* Sum: '<S753>/Sum2' incorporates:
   *  Product: '<S753>/Product'
   *  Sum: '<S753>/Sum1'
   */
  rtb_Sum2_a1 = (rtb_Sum2_a1 - Gen2_ref_B->Filter_bd.Switch) *
    Gen2_ref_B->BusInput3.SpeedCtrl.rGain_LEANOX_AW_iLQR + rtb_MinMax_n;

  /* Switch: '<S748>/Switch3' incorporates:
   *  Constant: '<S748>/Constant5'
   *  Logic: '<S748>/Logical Operator7'
   *  Sum: '<S748>/Sum'
   */
  if (Gen2_ref_B->BusInput3.SpeedCtrl.bAWLam_iLQR && (rtb_kW2W1_h != 0.0)) {
    rtb_Product4_d = 0.0;
  } else {
    rtb_Product4_d = rtb_Saturation6_tmp;
  }

  /* End of Switch: '<S748>/Switch3' */

  /* Switch: '<S754>/Switch2' incorporates:
   *  RelationalOperator: '<S754>/LowerRelop1'
   *  Sum: '<S748>/Sum'
   */
  if (!(rtb_Saturation6_tmp > rtb_Product4_d)) {
    /* Switch: '<S748>/Switch4' incorporates:
     *  Constant: '<S748>/Constant5'
     *  Logic: '<S748>/Logical Operator8'
     */
    if ((rtb_Gain6_b != 0.0) &&
        Gen2_ref_B->BusInput3.SpeedCtrl.bAWLam_iLQR_uplim) {
      rtb_MinMax_n = 0.0;
    } else {
      rtb_MinMax_n = rtb_Saturation6_tmp;
    }

    /* End of Switch: '<S748>/Switch4' */

    /* Switch: '<S754>/Switch' incorporates:
     *  RelationalOperator: '<S754>/UpperRelop'
     */
    if (rtb_Saturation6_tmp < rtb_MinMax_n) {
      rtb_Product4_d = rtb_MinMax_n;
    } else {
      rtb_Product4_d = rtb_Saturation6_tmp;
    }

    /* End of Switch: '<S754>/Switch' */
  }

  /* End of Switch: '<S754>/Switch2' */

  /* Product: '<S748>/Product' */
  rtb_MinMax_n = rtb_Product4_d * FILT_IN;

  /* Product: '<S748>/Product1' */
  rtb_Divide2_f *= rtb_Sum_mf;

  /* Product: '<S748>/Product2' incorporates:
   *  Sum: '<S748>/Sum1'
   */
  rtb_Pa2bar_k = (rtb_Gain2_cm - Gen2_ref_B->Filter_pj.Switch) *
    Gen2_ref_B->BusInput3.SpeedCtrl.rGain_ss_Nskip_iLQR;

  /* Product: '<S748>/Product3' */
  rtb_Product1 = Gen2_ref_B->BusInput3.SpeedCtrl.rGain_ss_LEANOX_iLQR *
    rtb_Sum2_a1;

  /* Product: '<S748>/Product4' */
  rtb_Product4_d *= Gen2_ref_B->BusInput3.SpeedCtrl.rGain_ss_speed2boost_iLQR;

  /* Switch: '<S748>/Switch5' incorporates:
   *  Gain: '<S748>/Gain2'
   *  Gain: '<S748>/Gain3'
   */
  if (rtb_Gain6_b != 0.0) {
    rtb_Divide3_d = -Gen2_ref_B->BusInput3.SpeedCtrl.rGainLamUplim2boost;
  } else {
    rtb_Divide3_d = 0.1 * Gen2_ref_B->BusInput3.SpeedCtrl.rGainLamUplim2boost;
  }

  /* End of Switch: '<S748>/Switch5' */

  /* Switch: '<S760>/Switch2' incorporates:
   *  Constant: '<S760>/Constant4'
   *  Product: '<S760>/Divide'
   *  Saturate: '<S760>/Saturation'
   */
  if (Gen2_ref_B->BusInput.bActive_p2sMan) {
    rtb_Divide_kp = -100.0;
  } else {
    if (Gen2_ref_B->BusInput3.traj.rTiLEANOXman <= 0.01) {
      /* Saturate: '<S760>/Saturation' */
      rtb_bResetHlci_0 = 0.01;
    } else {
      /* Saturate: '<S760>/Saturation' */
      rtb_bResetHlci_0 = Gen2_ref_B->BusInput3.traj.rTiLEANOXman;
    }

    rtb_Divide_kp = 1.0 / rtb_bResetHlci_0;
  }

  /* End of Switch: '<S760>/Switch2' */

  /* Switch: '<S761>/Switch1' incorporates:
   *  Constant: '<S761>/Constant'
   *  Logic: '<S761>/Logical Operator'
   *  Sum: '<S761>/Sum'
   */
  if (Gen2_ref_B->BusInput3.LoadEst.bCorrUnom &&
      Gen2_ref_B->TON2.LogicalOperator3) {
    rtb_rKK2_k = 1.0 - rtb_rKK2_k;
  } else {
    rtb_rKK2_k = Gen2_ref_B->Filter1_p.Switch;
  }

  /* End of Switch: '<S761>/Switch1' */

  /* Logic: '<S12>/Logical Operator' */
  rtb_LogicalOperator2_fy = !Gen2_ref_B->TON2.LogicalOperator3;

  /* Switch: '<S15>/Switch5' incorporates:
   *  UnitDelay: '<S15>/Unit Delay'
   */
  if (Gen2_ref_B->TON2.LogicalOperator3) {
    rtb_mbar2pa_g = r;
  } else {
    rtb_mbar2pa_g = Gen2_ref_DWork->UnitDelay_DSTATE_fm;
  }

  /* End of Switch: '<S15>/Switch5' */

  /* Switch: '<S15>/Switch4' incorporates:
   *  Constant: '<S15>/Pel_a (kW)1'
   *  Constant: '<S15>/Pel_a (kW)4'
   *  Logic: '<S15>/Logical Operator'
   *  RelationalOperator: '<S15>/Relational Operator'
   */
  if (Gen2_ref_B->BusInput3.leanox.bWGKorr &&
      (Gen2_ref_B->BusInput3.eng.rNum_WGV > 0.0)) {
    rtb_bResetHlci_0 = rtb_mbar2pa_g;
  } else {
    rtb_bResetHlci_0 = 0.0;
  }

  /* End of Switch: '<S15>/Switch4' */

  /* Outputs for Atomic SubSystem: '<S15>/Filter1' */
  Gen2_ref_N_TC_HP_filt(rtb_bResetHlci_0, Gen2_ref_B->BusInput3.leanox.rTiF_WG,
                        rtb_bResetBdc, &Gen2_ref_B->Filter1_fj,
                        &Gen2_ref_DWork->Filter1_fj, inst);

  /* End of Outputs for SubSystem: '<S15>/Filter1' */

  /* Saturate: '<S18>/Saturation1' */
  FILT_IN = rtb_deltafalllimit_ca;

  /* Saturate: '<S18>/Saturation2' */
  r = rtb_PrefOut;

  /* Product: '<S18>/Divide1' */
  rtb_PrefOut = Gen2_ref_B->sf_IntegerZOH.y / r;

  /* Saturate: '<S18>/Saturation' */
  r = rtb_PactOut;

  /* Sum: '<S18>/Sum1' */
  rtb_Sum_mf = Gen2_ref_B->BusInput3.bdcCbv.rPos_min + r;

  /* RelationalOperator: '<S18>/Relational Operator' */
  rtb_bCBV_min = (rtb_TmpSignalConversionAtSFun_p[0] <= rtb_Sum_mf);

  /* Sum: '<S18>/Sum2' */
  rtb_Sum_mf = Gen2_ref_B->BusInput3.bdcTv.rPos_min + r;

  /* Sum: '<S18>/Sum' incorporates:
   *  Constant: '<S18>/Constant4'
   */
  r = 1.0 - r;

  /* Logic: '<S18>/Logical Operator2' incorporates:
   *  RelationalOperator: '<S18>/Relational Operator1'
   *  RelationalOperator: '<S18>/Relational Operator3'
   */
  rtb_bTV_sat = ((Gen2_ref_B->sf_IntegerZOH.y <= rtb_Sum_mf) || (rtb_PrefOut >=
    r));

  /* UnitDelay: '<S10>/Unit Delay' */
  Gen2_ref_B->UnitDelay = Gen2_ref_DWork->UnitDelay_DSTATE_j;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->Version = Gen2_ref_B->UnitDelay;

  /* Update for UnitDelay: '<S427>/Unit Delay4' */
  Gen2_ref_DWork->TOF_state = Gen2_ref_B->TOF_c.LogicalOperator1;

  /* Update for Delay: '<S427>/Delay' */
  for (k = 0; k < 29; k++) {
    Gen2_ref_DWork->Delay_DSTATE[k] = Gen2_ref_DWork->Delay_DSTATE[k + 1];
  }

  Gen2_ref_DWork->Delay_DSTATE[29] = rtb_bar2Pa6;

  /* End of Update for Delay: '<S427>/Delay' */

  /* Update for Delay: '<S425>/Delay' */
  Gen2_ref_DWork->icLoad = false;
  for (i = 0; i < 6; i++) {
    Gen2_ref_DWork->Delay_DSTATE_o[i] = rtb_TmpSignalConversionAtDelayI[i];
  }

  /* End of Update for Delay: '<S425>/Delay' */

  /* Update for DiscreteIntegrator: '<S345>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S389>/Discrete-Time Integrator1'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE += 0.01 *
    rtb_DataTypeConversion15;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE = 0.0;
  }

  /* Outputs for Atomic SubSystem: '<S343>/PID_Power' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)
    rtb_LogicalOperator_in;

  /* End of Update for DiscreteIntegrator: '<S345>/Discrete-Time Integrator' */
  /* End of Outputs for SubSystem: '<S343>/PID_Power' */

  /* Update for Delay: '<S413>/Delay' */
  Gen2_ref_DWork->icLoad_n = false;
  Gen2_ref_DWork->Delay_DSTATE_n = rtb_Divide4_ia;

  /* Update for Delay: '<S881>/Delay' */
  Gen2_ref_DWork->icLoad_m = false;
  Gen2_ref_DWork->Delay_DSTATE_oh = rtb_Switch_ed;

  /* Update for Delay: '<S404>/Delay' */
  Gen2_ref_DWork->icLoad_k = false;
  Gen2_ref_DWork->Delay_DSTATE_g = rtb_Product_gj;

  /* Update for Delay: '<S15>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_nl = false;
  Gen2_ref_DWork->ResettableDelay_DSTATE = Gen2_ref_B->Filter1_fj.Switch;

  /* Update for Delay: '<Root>/Delay4' */
  Gen2_ref_DWork->Delay4_DSTATE = rtb_TmpSignalConversionAtSFun_p[0];

  /* Update for Delay: '<Root>/Delay3' */
  Gen2_ref_DWork->Delay3_DSTATE = Gen2_ref_B->sf_IntegerZOH.y;

  /* Update for Delay: '<Root>/Delay6' incorporates:
   *  Logic: '<S18>/Logical Operator'
   *  Logic: '<S18>/Logical Operator1'
   *  Logic: '<S18>/Logical Operator3'
   *  Product: '<S18>/Divide'
   *  RelationalOperator: '<S18>/Relational Operator2'
   */
  Gen2_ref_DWork->Delay6_DSTATE = (((rtb_TmpSignalConversionAtSFun_p[0] /
    FILT_IN >= r) && rtb_bTV_sat) || (rtb_bCBV_min && rtb_bTV_sat));

  /* Update for Delay: '<Root>/Delay1' incorporates:
   *  SignalConversion generated from: '<Root>/Delay1'
   */
  Gen2_ref_DWork->Delay1_DSTATE[0] = rtb_Switch2_n5;
  Gen2_ref_DWork->Delay1_DSTATE[1] = rtb_Switch1_k;
  Gen2_ref_DWork->Delay1_DSTATE[2] = rtb_PactOut_o;

  /* Update for Delay: '<Root>/Delay2' */
  Gen2_ref_DWork->icLoad_e = false;
  Gen2_ref_DWork->Delay2_DSTATE = rtb_Product1_fu;

  /* Update for UnitDelay: '<S343>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE = rtb_Switch_on;

  /* Update for UnitDelay: '<S343>/Unit Delay' incorporates:
   *  BusCreator: '<S389>/Bus Creator1'
   */
  Gen2_ref_DWork->UnitDelay_DSTATE_mg = rtb_BusCreator1_h_ui;

  /* Update for DiscreteIntegrator: '<S760>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S743>/Logical Operator'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h += 0.01 * rtb_Divide_kp;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h = 0.0;
  }

  /* Outputs for Atomic SubSystem: '<S737>/Filter' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_i = (int8_T)rtb_bResetHlci;

  /* End of Update for DiscreteIntegrator: '<S760>/Discrete-Time Integrator' */
  /* End of Outputs for SubSystem: '<S737>/Filter' */

  /* Update for Delay: '<S795>/Delay' */
  Gen2_ref_DWork->icLoad_h = false;
  Gen2_ref_DWork->Delay_DSTATE_b = rtb_Switch_jz;

  /* Update for UnitDelay: '<S761>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE = rtb_rKK2_k;

  /* Update for DiscreteIntegrator: '<S579>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_m += 0.01 * rtb_Gain2_ao;

  /* Update for DiscreteIntegrator: '<S586>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_p += 0.01 * rtb_p2s;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_k = (int8_T)
    rtb_LogicalOperator1_j;

  /* Update for DiscreteIntegrator: '<S307>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d += 0.01;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_d = 0.0;
  }

  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_p = (int8_T)
    rtb_LogicalOperator2_e;

  /* End of Update for DiscreteIntegrator: '<S307>/Discrete-Time Integrator' */

  /* Update for UnitDelay: '<S14>/Unit Delay4' incorporates:
   *  Logic: '<Root>/Logical Operator'
   */
  Gen2_ref_DWork->UnitDelay4_DSTATE_d = rtb_LogicalOperator_cn;

  /* Update for Delay: '<S14>/Resettable Delay2' */
  Gen2_ref_DWork->icLoad_l = false;
  Gen2_ref_DWork->ResettableDelay2_DSTATE = rtb_Divide6_n;

  /* Update for Delay: '<S14>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_i = false;
  Gen2_ref_DWork->ResettableDelay_DSTATE_l = Gen2_ref_B->Filter_l.Switch;

  /* Update for UnitDelay: '<S14>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE = rtb_Product1_fu;

  /* Update for UnitDelay: '<S917>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_k = rtb_RelationalOperator_a;

  /* Update for DiscreteIntegrator: '<S917>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_c += 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_ka = (int8_T)
    rtb_LogicalOperator_i;

  /* Update for Delay: '<S14>/Resettable Delay3' */
  Gen2_ref_DWork->icLoad_f = false;
  Gen2_ref_DWork->ResettableDelay3_DSTATE = rtb_RelationalOperator_l5;

  /* Update for UnitDelay: '<S641>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_d2 = rtb_LogicalOperator4_go;

  /* Update for DiscreteIntegrator: '<S748>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_k += 0.01 * rtb_MinMax_n;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_j = (int8_T)
    rtb_LogicalOperator1_e;

  /* Update for DiscreteIntegrator: '<S748>/Discrete-Time Integrator4' incorporates:
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE += 0.01 * rtb_Divide3_d;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE >= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = 0.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE <= -0.3) {
    Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = -0.3;
  }

  Gen2_ref_DWork->DiscreteTimeIntegrator4_PrevRes = (int8_T)
    rtb_LogicalOperator1_e;

  /* End of Update for DiscreteIntegrator: '<S748>/Discrete-Time Integrator4' */

  /* Update for DiscreteIntegrator: '<S748>/Discrete-Time Integrator1' incorporates:
   *  Sum: '<S748>/Sum2'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTATE += (rtb_Product4_d +
    rtb_Divide2_f) * 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator1_PrevRes = (int8_T)
    rtb_LogicalOperator3_fj;

  /* Update for Delay: '<S637>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_ef = false;
  Gen2_ref_DWork->ResettableDelay_DSTATE_i = rtb_Sum2_kg;

  /* Update for Delay: '<S637>/Variable Integer Delay' */
  Gen2_ref_DWork->icLoad_b = false;
  Gen2_ref_DWork->VariableIntegerDelay_DSTATE[Gen2_ref_DWork->CircBufIdx] =
    rtb_Switch_jv;
  if (Gen2_ref_DWork->CircBufIdx < 199) {
    Gen2_ref_DWork->CircBufIdx++;
  } else {
    Gen2_ref_DWork->CircBufIdx = 0U;
  }

  /* End of Update for Delay: '<S637>/Variable Integer Delay' */

  /* Update for UnitDelay: '<S628>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_a = rtb_Product1_b4;

  /* Update for Delay: '<S625>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_k = rtb_kW2W;

  /* Update for Delay: '<S666>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_i0 = false;
  for (i = 0; i < 13; i++) {
    Gen2_ref_DWork->ResettableDelay_DSTATE_a[i] =
      Gen2_ref_B->sf_MATLABFunction1_m.y_map_new[i];
  }

  /* End of Update for Delay: '<S666>/Resettable Delay' */

  /* Update for UnitDelay: '<S667>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_n = rtb_LogicalOperator4_go;

  /* Update for UnitDelay: '<S667>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_e = rtb_Divide3_g;

  /* Update for Delay: '<S714>/Resettable Delay1' */
  Gen2_ref_DWork->icLoad_np = false;

  /* Update for UnitDelay: '<S714>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_o = rtb_Switch2_au;

  /* Update for Delay: '<S714>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_j = false;
  for (i = 0; i < 13; i++) {
    /* Update for Delay: '<S714>/Resettable Delay1' */
    Gen2_ref_DWork->ResettableDelay1_DSTATE[i] = rtb_ResettableDelay_br[i];

    /* Update for Delay: '<S714>/Resettable Delay' */
    Gen2_ref_DWork->ResettableDelay_DSTATE_m[i] = rtb_y_map_new_n[i];
  }

  /* Update for DiscreteIntegrator: '<S714>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S714>/Logical Operator2'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_l += 0.01 * rtb_Switch_ks;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_o = (int8_T)
    rtb_LogicalOperator2_k_tmp;

  /* Update for Delay: '<S715>/Resettable Delay1' */
  Gen2_ref_DWork->icLoad_a = false;

  /* Update for UnitDelay: '<S715>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_j = rtb_Switch3_le;

  /* Update for Delay: '<S715>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_m3 = false;
  for (i = 0; i < 7; i++) {
    /* Update for Delay: '<S715>/Resettable Delay1' */
    Gen2_ref_DWork->ResettableDelay1_DSTATE_e[i] = rtb_Switch_dau[i];

    /* Update for Delay: '<S715>/Resettable Delay' */
    Gen2_ref_DWork->ResettableDelay_DSTATE_e[i] = rtb_y_map_new_a[i];
  }

  /* Update for DiscreteIntegrator: '<S715>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S714>/Logical Operator2'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_e += 0.01 * rtb_Divide2_a;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_n = (int8_T)
    rtb_LogicalOperator2_k_tmp;

  /* Update for DiscreteIntegrator: '<S748>/Discrete-Time Integrator3' incorporates:
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator3_DSTATE += 0.01 * rtb_Product1;
  Gen2_ref_DWork->DiscreteTimeIntegrator3_PrevRes = (int8_T)
    rtb_LogicalOperator1_e;

  /* Update for DiscreteIntegrator: '<S748>/Discrete-Time Integrator2' incorporates:
   *  DiscreteIntegrator: '<S748>/Discrete-Time Integrator'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator2_DSTATE += 0.01 * rtb_Pa2bar_k;
  Gen2_ref_DWork->DiscreteTimeIntegrator2_PrevRes = (int8_T)
    rtb_LogicalOperator1_e;

  /* Update for Delay: '<S431>/Delay' incorporates:
   *  SignalConversion generated from: '<S431>/Delay'
   */
  Gen2_ref_DWork->icLoad_b3 = false;
  Gen2_ref_DWork->Delay_DSTATE_ba[0] = rtb_Divide_ab[0];
  Gen2_ref_DWork->Delay_DSTATE_ba[1] = rtb_Divide_ab[1];
  Gen2_ref_DWork->Delay_DSTATE_ba[2] = rtb_Sum_c;
  Gen2_ref_DWork->Delay_DSTATE_ba[3] = rtb_Divide_ab[3];

  /* Update for UnitDelay: '<S606>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_ma = rtb_LogicalOperator1_ja;

  /* Update for Delay: '<S608>/Delay to avoid alg.loop' */
  Gen2_ref_DWork->Delaytoavoidalgloop_DSTATE = rtb_TOF_IN;

  /* Update for UnitDelay: '<S608>/Unit Delay' */
  Gen2_ref_DWork->TP_state = rtb_LogicalOperator1_pa;

  /* Update for UnitDelay: '<S611>/Delay Input1' */
  Gen2_ref_DWork->DelayInput1_DSTATE = rtb_LogicalOperator5;

  /* Update for DiscreteIntegrator: '<S608>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_h5 += 0.01 * rtb_Switch2_g3;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_m = (int8_T)
    rtb_LogicalOperator4_m5;

  /* Update for UnitDelay: '<S603>/Delay Input1' */
  Gen2_ref_DWork->DelayInput1_DSTATE_n = rtb_LogicalOperator1_pa;

  /* Update for UnitDelay: '<S581>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_f = rtb_Product1_aq;

  /* Update for UnitDelay: '<S716>/Unit Delay3' */
  Gen2_ref_DWork->UnitDelay3_DSTATE_go = Gen2_ref_B->TON_j.LogicalOperator3;

  /* Update for UnitDelay: '<S716>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_m = rtb_Switch1_cl[0];

  /* Update for UnitDelay: '<S716>/Unit Delay1' */
  for (i = 0; i < 13; i++) {
    Gen2_ref_DWork->UnitDelay1_DSTATE_f[i] = rtb_y_map_new[i];
  }

  /* End of Update for UnitDelay: '<S716>/Unit Delay1' */

  /* Update for UnitDelay: '<Root>/Unit Delay3' */
  Gen2_ref_DWork->UnitDelay3_DSTATE = rtb_TmpSignalConversionAtSFun_p[0];

  /* Update for UnitDelay: '<Root>/Unit Delay4' */
  Gen2_ref_DWork->UnitDelay4_DSTATE = Gen2_ref_B->sf_IntegerZOH.y;

  /* Update for UnitDelay: '<S1>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_ek = rtb_Switch1_kk;

  /* Update for UnitDelay: '<S31>/UD' */
  Gen2_ref_DWork->UD_DSTATE = rtb_LogicalOperator_hi;

  /* Update for UnitDelay: '<Root>/Unit Delay2' incorporates:
   *  Product: '<S5>/Divide2'
   *  Sum: '<S11>/Sum'
   *  Sum: '<S5>/Add2'
   */
  Gen2_ref_DWork->UnitDelay2_DSTATE_h[0] = rtb_Switch_fy_tmp_tmp * R_2inp[0] +
    rtb_Divide3_e[0];
  Gen2_ref_DWork->UnitDelay2_DSTATE_h[1] = rtb_Switch_fy_tmp_tmp * R_2inp[1] +
    rtb_Divide3_e[1];
  Gen2_ref_DWork->UnitDelay2_DSTATE_h[2] = rtb_Switch_fy_tmp_tmp * R_2inp[2] +
    rtb_Divide3_e[2];
  Gen2_ref_DWork->UnitDelay2_DSTATE_h[3] = rtb_Switch_fy_tmp_tmp * R_2inp[3] +
    rtb_Divide3_e[3];

  /* Update for UnitDelay: '<S62>/Unit Delay4' */
  Gen2_ref_DWork->UnitDelay4_DSTATE_k = Gen2_ref_B->TON_1.LogicalOperator3;

  /* Update for DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a += 0.01 * rtb_Gain_kl;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a <= -0.1) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_a = -0.1;
  }

  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_oa = (int8_T)
    rtb_LogicalOperator1_i2;

  /* End of Update for DiscreteIntegrator: '<S62>/Discrete-Time Integrator' */

  /* Update for Delay: '<S78>/Variable Integer Delay' */
  Gen2_ref_DWork->icLoad_ev = false;

  /* Update for UnitDelay: '<S78>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_e = rtb_p1LP;

  /* Update for Delay: '<S88>/Delay' */
  Gen2_ref_DWork->icLoad_d = false;
  Gen2_ref_DWork->Delay_DSTATE_ko = rtb_p2HP;

  /* Update for Delay: '<S90>/Delay' */
  Gen2_ref_DWork->icLoad_es = false;
  Gen2_ref_DWork->Delay_DSTATE_j = rtb_Sum4_g;

  /* Update for Delay: '<S87>/Delay' */
  Gen2_ref_DWork->icLoad_evr = false;
  Gen2_ref_DWork->Delay_DSTATE_m = rtb_Sum5_iu;

  /* Update for Delay: '<S89>/Delay' */
  Gen2_ref_DWork->icLoad_fg = false;
  Gen2_ref_DWork->Delay_DSTATE_d = rtb_Switch9_k;

  /* Update for Delay: '<S77>/Variable Integer Delay' */
  Gen2_ref_DWork->icLoad_c = false;
  for (k = 0; k < 299; k++) {
    /* Update for Delay: '<S78>/Variable Integer Delay' */
    Gen2_ref_DWork->VariableIntegerDelay_DSTATE_b[k] =
      Gen2_ref_DWork->VariableIntegerDelay_DSTATE_b[k + 1];

    /* Update for Delay: '<S77>/Variable Integer Delay' */
    Gen2_ref_DWork->VariableIntegerDelay_DSTATE_e[k] =
      Gen2_ref_DWork->VariableIntegerDelay_DSTATE_e[k + 1];
  }

  /* Update for Delay: '<S78>/Variable Integer Delay' */
  Gen2_ref_DWork->VariableIntegerDelay_DSTATE_b[299] = rtb_p1HP;

  /* Update for Delay: '<S77>/Variable Integer Delay' */
  Gen2_ref_DWork->VariableIntegerDelay_DSTATE_e[299] = rtb_p1HP;

  /* Update for UnitDelay: '<S77>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_d = rtb_Sum3_o;

  /* Update for Delay: '<S80>/Delay' */
  Gen2_ref_DWork->icLoad_eu = false;
  Gen2_ref_DWork->Delay_DSTATE_g2 = rtb_Switch_czo;

  /* Update for Delay: '<S82>/Delay' */
  Gen2_ref_DWork->icLoad_ee = false;
  Gen2_ref_DWork->Delay_DSTATE_dm = rtb_UkYk1_a4;

  /* Update for Delay: '<S79>/Delay' */
  Gen2_ref_DWork->icLoad_ki = false;
  Gen2_ref_DWork->Delay_DSTATE_jl = rtb_Gain_i;

  /* Update for Delay: '<S81>/Delay' */
  Gen2_ref_DWork->icLoad_h3 = false;
  Gen2_ref_DWork->Delay_DSTATE_h = rtb_Saturation_e;

  /* Update for Delay: '<S23>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_lv = rtb_LogicalOperator;

  /* Update for UnitDelay: '<S53>/Unit Delay4' */
  Gen2_ref_DWork->UnitDelay4_DSTATE_o = rtb_LogicalOperator2_p1;

  /* Update for Delay: '<S63>/Delay' */
  Gen2_ref_DWork->icLoad_g = false;
  Gen2_ref_DWork->Delay_DSTATE_c = rtb_deltafalllimit_h0;

  /* Update for Delay: '<S64>/Delay' */
  Gen2_ref_DWork->icLoad_c1 = false;
  Gen2_ref_DWork->Delay_DSTATE_i = rtb_Switch1_lk;

  /* Update for DiscreteIntegrator: '<S48>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac += 0.01 * rtb_Switch_eu;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ac = 0.0;
  }

  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_l = (int8_T)
    rtb_LogicalOperator2_dc;

  /* Update for UnitDelay: '<S23>/Unit Delay3' */
  Gen2_ref_DWork->UnitDelay3_DSTATE_gf = rtb_LogicalOperator2_dc;

  /* Update for UnitDelay: '<S427>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_m = rtb_LogicalOperator1_a0;

  /* Update for DiscreteIntegrator: '<S132>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_g += 0.01 * rtb_Gain1_fr;

  /* Update for UnitDelay: '<S160>/Delay Input1' */
  Gen2_ref_DWork->DelayInput1_DSTATE_f = Gen2_ref_B->BusInput3.bdcTv.bActive_ff;

  /* Update for UnitDelay: '<S45>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_ed = rtb_Product1_bc;

  /* Update for Delay: '<S45>/Delay' */
  Gen2_ref_DWork->icLoad_eh = false;
  Gen2_ref_DWork->Delay_DSTATE_cn =
    Gen2_ref_B->Inverse_Linearization1.LCRScal_Lam_EOT1;

  /* Update for Delay: '<S161>/Delay2' */
  Gen2_ref_DWork->Delay2_DSTATE_f = rtb_LogicalOperator3_k;

  /* Update for Delay: '<S161>/Delay1' */
  Gen2_ref_DWork->Delay1_DSTATE_l = rtb_Sum8_m;

  /* Update for Delay: '<S161>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_gp = rtb_Product1_bc;

  /* Update for DiscreteIntegrator: '<S45>/Discrete-Time Integrator1' incorporates:
   *  MATLAB Function: '<S45>/tv_fb_err'
   *  Product: '<S45>/Product1'
   *  Sum: '<S45>/Sum3'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator1_IC_LOAD = 0U;
  Gen2_ref_DWork->DiscreteTimeIntegrator1_DSTAT_n += (rtb_Sum10 * rtb_Switch2_j0
    + rtb_Switch2_oou) * 0.01;
  Gen2_ref_DWork->DiscreteTimeIntegrator1_PrevR_k = (int8_T)
    rtb_LogicalOperator3_aa;

  /* Update for UnitDelay: '<S41>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_je = rtb_Switch4_j;

  /* Update for UnitDelay: '<S1>/Unit Delay5' */
  Gen2_ref_DWork->UnitDelay5_DSTATE = rtb_Switch1_kk;

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_i = rtb_Switch13;

  /* Update for DiscreteIntegrator: '<S133>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_j += 0.01 * rtb_Saturation;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_no = (int8_T)
    rtb_LogicalOperator1_ix;

  /* Update for UnitDelay: '<S27>/Unit Delay6' */
  Gen2_ref_DWork->UnitDelay6_DSTATE = rtb_Sum1_lo;

  /* Update for UnitDelay: '<S107>/Delay Input1' */
  Gen2_ref_DWork->DelayInput1_DSTATE_fv =
    Gen2_ref_B->BusInput3.bdcCbv.bActive_ff;

  /* Update for UnitDelay: '<S26>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_c = rtb_MultiportSwitch;

  /* Update for Delay: '<S26>/Delay' */
  Gen2_ref_DWork->icLoad_kq = false;
  Gen2_ref_DWork->Delay_DSTATE_hq = rtb_Saturation1_i;

  /* Update for Delay: '<S111>/Delay2' */
  Gen2_ref_DWork->Delay2_DSTATE_k = rtb_LogicalOperator5_p;

  /* Update for Delay: '<S111>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_ow = rtb_MultiportSwitch;

  /* Update for DiscreteIntegrator: '<S26>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_l = 0U;
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTAT_ja += 0.01 * rtb_Switch1_mm;
  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevRe_c = (int8_T)
    rtb_LogicalOperator_b;

  /* Update for UnitDelay: '<S1>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_d = rtb_Switch1_kk;

  /* Update for UnitDelay: '<S1>/Unit Delay3' */
  Gen2_ref_DWork->UnitDelay3_DSTATE_g = rtb_Switch1_kk;

  /* Update for UnitDelay: '<S46>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_b = rtb_Switch2_by;

  /* Update for UnitDelay: '<S491>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_j = rtb_LogicalOperator_aw;

  /* Update for Delay: '<S494>/Delay' */
  Gen2_ref_DWork->icLoad_ir = false;
  Gen2_ref_DWork->Delay_DSTATE_f = rtb_Switch2_l;

  /* Update for DiscreteIntegrator: '<S22>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S48>/Discrete-Time Integrator'
   *  Sum: '<S22>/Sum2'
   */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i += (delta_y - rtb_Gain) * 0.01;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i >= 1.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i = 1.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i <= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_i = 0.0;
  }

  Gen2_ref_DWork->DiscreteTimeIntegrator_PrevR_jc = (int8_T)
    rtb_LogicalOperator2_dc;

  /* End of Update for DiscreteIntegrator: '<S22>/Discrete-Time Integrator' */

  /* Update for UnitDelay: '<S427>/Unit Delay5' */
  Gen2_ref_DWork->TOF_2_state = Gen2_ref_B->TOF2_d.LogicalOperator1;

  /* Update for UnitDelay: '<S427>/Unit Delay3' */
  Gen2_ref_DWork->UnitDelay3_DSTATE_h5 =
    Gen2_ref_B->TP_Misfire_ON_2ndtime.LogicalOperator1;

  /* Update for UnitDelay: '<S427>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_hh = rtb_dbg_HLCi;

  /* Update for UnitDelay: '<S634>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_kx = rtb_LogicalOperator5_mv;

  /* Update for Delay: '<S708>/Delay' */
  Gen2_ref_DWork->icLoad_nv = false;
  Gen2_ref_DWork->Delay_DSTATE_l = rtb_Divide5_h;

  /* Update for UnitDelay: '<S427>/Unit Delay6' */
  Gen2_ref_DWork->UnitDelay6_DSTATE_m = rtb_Divide4_d;

  /* Update for UnitDelay: '<S427>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_n = rtb_RelationalOperator2_j;

  /* Update for Delay: '<S524>/Delay' */
  Gen2_ref_DWork->icLoad_dk = false;
  Gen2_ref_DWork->Delay_DSTATE_p = rtb_Switch5_iq;

  /* Update for Delay: '<S811>/Delay' */
  Gen2_ref_DWork->icLoad_iv = false;
  Gen2_ref_DWork->Delay_DSTATE_i4 = rtb_Sum4_ny;

  /* Update for Delay: '<S830>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_ix = false;
  for (i = 0; i < 13; i++) {
    Gen2_ref_DWork->ResettableDelay_DSTATE_k[i] =
      Gen2_ref_B->sf_MATLABFunction1_l.y_map_new[i];
  }

  /* End of Update for Delay: '<S830>/Resettable Delay' */

  /* Update for UnitDelay: '<S831>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_i = rtb_LogicalOperator2_fy;

  /* Update for UnitDelay: '<S831>/Unit Delay1' incorporates:
   *  Constant: '<S12>/Constant'
   */
  Gen2_ref_DWork->UnitDelay1_DSTATE_n = 0.0;

  /* Update for Delay: '<S830>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_n2 = rtb_LogicalOperator2_l;

  /* Update for Delay: '<S666>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_cnq = rtb_LogicalOperator_f;

  /* Update for UnitDelay: '<S635>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_eq = rtb_kW2W1_h;

  /* Update for UnitDelay: '<S635>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_di = rtb_Gain6_b;

  /* Update for Delay: '<S714>/Delay' incorporates:
   *  Logic: '<S714>/Logical Operator2'
   */
  Gen2_ref_DWork->Delay_DSTATE_a = rtb_LogicalOperator2_k_tmp;

  /* Update for Delay: '<S715>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_ng = rtb_LogicalOperator2_k_tmp;

  /* Update for UnitDelay: '<S275>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_dk = rtb_SumofElements;

  /* Update for UnitDelay: '<S275>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_b = rtb_Gain6_jx;

  /* Update for UnitDelay: '<S275>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_k = rtb_SumofElements;

  /* Update for UnitDelay: '<S275>/Unit Delay3' */
  Gen2_ref_DWork->UnitDelay3_DSTATE_m = rtb_Gain7;

  /* Update for UnitDelay: '<S291>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_m = rtb_SumofElements_l;

  /* Update for UnitDelay: '<S291>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_c2 = rtb_Sum_ig;

  /* Update for UnitDelay: '<S291>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_p = rtb_SumofElements_l;

  /* Update for UnitDelay: '<S291>/Unit Delay3' */
  Gen2_ref_DWork->UnitDelay3_DSTATE_h = rtb_Sum_gb;

  /* Update for UnitDelay: '<S133>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_o = rtb_RelationalOperator1_j;

  /* Update for UnitDelay: '<S15>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_fm = rtb_mbar2pa_g;

  /* Update for UnitDelay: '<S10>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE_j = 4140004U;
}

/* Model initialize function */
void Gen2_ref_initialize(RT_MODEL_Gen2_ref *const Gen2_ref_M, struct Gen2* inst)
{
  struct D_Work_Gen2_ref *Gen2_ref_DWork = Gen2_ref_M->dwork;
  struct PrevZCSigStates_Gen2_ref *Gen2_ref_PrevZCSigState = Gen2_ref_M->prevZCSigState;

  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_k = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_b = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_n = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay2_Reset_ZCE = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_m = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_j = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay3_Reset_ZCE = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_m = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZCE = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_a = POS_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay1_Reset_ZCE = POS_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_e = POS_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay1_Reset_ZCE_g = POS_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_b = POS_ZCSIG;
  Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZC_i = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_d = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_l = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_i = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_mu = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->VariableIntegerDelay_Reset_ZC_o = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_d3 = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_c = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_p = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_ih = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_k2 = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_a = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_o = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_kk = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_bc = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_j = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_h = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_bi = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->ResettableDelay_Reset_ZCE_k = POS_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_at = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_e = UNINITIALIZED_ZCSIG;
  Gen2_ref_PrevZCSigState->Delay_Reset_ZCE_mt = UNINITIALIZED_ZCSIG;

  /* InitializeConditions for Delay: '<S425>/Delay' */
  Gen2_ref_DWork->icLoad = true;

  /* InitializeConditions for DiscreteIntegrator: '<S345>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE = 1.0;

  /* InitializeConditions for Delay: '<S413>/Delay' */
  Gen2_ref_DWork->icLoad_n = true;

  /* InitializeConditions for Delay: '<S881>/Delay' */
  Gen2_ref_DWork->icLoad_m = true;

  /* InitializeConditions for Delay: '<S404>/Delay' */
  Gen2_ref_DWork->icLoad_k = true;

  /* InitializeConditions for Delay: '<S15>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_nl = true;

  /* InitializeConditions for Delay: '<Root>/Delay2' */
  Gen2_ref_DWork->icLoad_e = true;

  /* InitializeConditions for DiscreteIntegrator: '<S760>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_h = 1.0;

  /* InitializeConditions for Delay: '<S795>/Delay' */
  Gen2_ref_DWork->icLoad_h = true;

  /* InitializeConditions for DiscreteIntegrator: '<S579>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_m = 1.7;

  /* InitializeConditions for UnitDelay: '<S14>/Unit Delay4' */
  Gen2_ref_DWork->UnitDelay4_DSTATE_d = true;

  /* InitializeConditions for Delay: '<S14>/Resettable Delay2' */
  Gen2_ref_DWork->icLoad_l = true;

  /* InitializeConditions for Delay: '<S14>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_i = true;

  /* InitializeConditions for UnitDelay: '<S14>/Unit Delay' */
  Gen2_ref_DWork->UnitDelay_DSTATE = 1.7;

  /* InitializeConditions for Delay: '<S14>/Resettable Delay3' */
  Gen2_ref_DWork->icLoad_f = true;

  /* InitializeConditions for DiscreteIntegrator: '<S748>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S748>/Discrete-Time Integrator4' */
  Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = 0.0;
  if (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE >= 0.0) {
    Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = 0.0;
  } else if (Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE <= -0.3) {
    Gen2_ref_DWork->DiscreteTimeIntegrator4_DSTATE = -0.3;
  }

  /* End of InitializeConditions for DiscreteIntegrator: '<S748>/Discrete-Time Integrator4' */

  /* InitializeConditions for Delay: '<S637>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_ef = true;

  /* InitializeConditions for Delay: '<S637>/Variable Integer Delay' */
  Gen2_ref_DWork->icLoad_b = true;

  /* InitializeConditions for UnitDelay: '<S628>/Unit Delay1' */
  Gen2_ref_DWork->UnitDelay1_DSTATE_a = 1.0;

  /* InitializeConditions for Delay: '<S625>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_k = 287.0;

  /* InitializeConditions for Delay: '<S666>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_i0 = true;

  /* InitializeConditions for Delay: '<S714>/Resettable Delay1' */
  Gen2_ref_DWork->icLoad_np = true;

  /* InitializeConditions for Delay: '<S714>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_j = true;

  /* InitializeConditions for Delay: '<S715>/Resettable Delay1' */
  Gen2_ref_DWork->icLoad_a = true;

  /* InitializeConditions for Delay: '<S715>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_m3 = true;

  /* InitializeConditions for Delay: '<S431>/Delay' */
  Gen2_ref_DWork->icLoad_b3 = true;

  /* InitializeConditions for Delay: '<S78>/Variable Integer Delay' */
  Gen2_ref_DWork->icLoad_ev = true;

  /* InitializeConditions for Delay: '<S88>/Delay' */
  Gen2_ref_DWork->icLoad_d = true;

  /* InitializeConditions for Delay: '<S90>/Delay' */
  Gen2_ref_DWork->icLoad_es = true;

  /* InitializeConditions for Delay: '<S87>/Delay' */
  Gen2_ref_DWork->icLoad_evr = true;

  /* InitializeConditions for Delay: '<S89>/Delay' */
  Gen2_ref_DWork->icLoad_fg = true;

  /* InitializeConditions for Delay: '<S77>/Variable Integer Delay' */
  Gen2_ref_DWork->icLoad_c = true;

  /* InitializeConditions for Delay: '<S80>/Delay' */
  Gen2_ref_DWork->icLoad_eu = true;

  /* InitializeConditions for Delay: '<S82>/Delay' */
  Gen2_ref_DWork->icLoad_ee = true;

  /* InitializeConditions for Delay: '<S79>/Delay' */
  Gen2_ref_DWork->icLoad_ki = true;

  /* InitializeConditions for Delay: '<S81>/Delay' */
  Gen2_ref_DWork->icLoad_h3 = true;

  /* InitializeConditions for UnitDelay: '<S53>/Unit Delay4' */
  Gen2_ref_DWork->UnitDelay4_DSTATE_o = true;

  /* InitializeConditions for Delay: '<S63>/Delay' */
  Gen2_ref_DWork->icLoad_g = true;

  /* InitializeConditions for Delay: '<S64>/Delay' */
  Gen2_ref_DWork->icLoad_c1 = true;

  /* InitializeConditions for UnitDelay: '<S23>/Unit Delay3' */
  Gen2_ref_DWork->UnitDelay3_DSTATE_gf = true;

  /* InitializeConditions for DiscreteIntegrator: '<S132>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_g = 100000.0;

  /* InitializeConditions for Delay: '<S45>/Delay' */
  Gen2_ref_DWork->icLoad_eh = true;

  /* InitializeConditions for Delay: '<S161>/Delay2' */
  Gen2_ref_DWork->Delay2_DSTATE_f = true;

  /* InitializeConditions for DiscreteIntegrator: '<S45>/Discrete-Time Integrator1' */
  Gen2_ref_DWork->DiscreteTimeIntegrator1_IC_LOAD = 1U;

  /* InitializeConditions for Delay: '<S26>/Delay' */
  Gen2_ref_DWork->icLoad_kq = true;

  /* InitializeConditions for Delay: '<S111>/Delay2' */
  Gen2_ref_DWork->Delay2_DSTATE_k = true;

  /* InitializeConditions for DiscreteIntegrator: '<S26>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_l = 1U;

  /* InitializeConditions for Delay: '<S494>/Delay' */
  Gen2_ref_DWork->icLoad_ir = true;

  /* InitializeConditions for Delay: '<S708>/Delay' */
  Gen2_ref_DWork->icLoad_nv = true;

  /* InitializeConditions for Delay: '<S524>/Delay' */
  Gen2_ref_DWork->icLoad_dk = true;

  /* InitializeConditions for Delay: '<S811>/Delay' */
  Gen2_ref_DWork->icLoad_iv = true;

  /* InitializeConditions for Delay: '<S830>/Resettable Delay' */
  Gen2_ref_DWork->icLoad_ix = true;

  /* InitializeConditions for Delay: '<S830>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_n2 = true;

  /* InitializeConditions for Delay: '<S666>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_cnq = true;

  /* InitializeConditions for Delay: '<S714>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_a = true;

  /* InitializeConditions for Delay: '<S715>/Delay' */
  Gen2_ref_DWork->Delay_DSTATE_ng = true;

  /* SystemInitialize for Atomic SubSystem: '<S418>/2nd Order Filter' */
  Gen2_ref_undOrderFilter3_Init(&Gen2_ref_DWork->undOrderFilter_j, inst);

  /* End of SystemInitialize for SubSystem: '<S418>/2nd Order Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S418>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S439>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_f = 1U;

  /* End of SystemInitialize for SubSystem: '<S418>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S201>/Volt_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->Volt_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S201>/Volt_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S205>/p2s_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->p2s_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S205>/p2s_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S425>/TOF' */
  Gen2_ref_TOF_Init(&Gen2_ref_DWork->TOF_h, inst);

  /* End of SystemInitialize for SubSystem: '<S425>/TOF' */

  /* SystemInitialize for Atomic SubSystem: '<S425>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S485>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_p = 1U;

  /* End of SystemInitialize for SubSystem: '<S425>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TOF1' */
  Gen2_ref_TOF_Init(&Gen2_ref_DWork->TOF1_o, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TOF1' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP' */
  Gen2_ref_TP_Init(&Gen2_ref_DWork->TP_p, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP' */

  /* SystemInitialize for Atomic SubSystem: '<S345>/p2sfilt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->p2sfilt, inst);

  /* End of SystemInitialize for SubSystem: '<S345>/p2sfilt' */

  /* SystemInitialize for Atomic SubSystem: '<S194>/Pel_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->Pel_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S194>/Pel_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S875>/Pd_filt' */
  Gen2_ref_Pd_filt_Init(&Gen2_ref_DWork->Pd_filt_p, inst);

  /* End of SystemInitialize for SubSystem: '<S875>/Pd_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S344>/Pd_filt' */
  Gen2_ref_Pd_filt_Init(&Gen2_ref_DWork->Pd_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S344>/Pd_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S344>/WO1' */
  Gen2_ref_Filter1_Init(&Gen2_ref_DWork->WO1, inst);

  /* End of SystemInitialize for SubSystem: '<S344>/WO1' */

  /* SystemInitialize for Atomic SubSystem: '<S344>/WO2' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.tde1, &Gen2_ref_DWork->WO2, inst);

  /* End of SystemInitialize for SubSystem: '<S344>/WO2' */

  /* SystemInitialize for Atomic SubSystem: '<S190>/N_TC_HP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->N_TC_HP_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S190>/N_TC_HP_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S197>/T2s_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->T2s_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S197>/T2s_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S193>/N_TC_LP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->N_TC_LP_filt_f, inst);

  /* End of SystemInitialize for SubSystem: '<S193>/N_TC_LP_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S19>/Filter1' */
  Gen2_ref_Filter3_Init(1.0, &Gen2_ref_DWork->Filter1_l, inst);

  /* End of SystemInitialize for SubSystem: '<S19>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S6>/TOF' */
  Gen2_ref_TOF_Init(&Gen2_ref_DWork->TOF, inst);

  /* End of SystemInitialize for SubSystem: '<S6>/TOF' */

  /* SystemInitialize for Atomic SubSystem: '<S6>/TOF1' */
  Gen2_ref_TOF_Init(&Gen2_ref_DWork->TOF1, inst);

  /* End of SystemInitialize for SubSystem: '<S6>/TOF1' */

  /* SystemInitialize for Atomic SubSystem: '<S6>/TOF2' */
  Gen2_ref_TOF_Init(&Gen2_ref_DWork->TOF2, inst);

  /* End of SystemInitialize for SubSystem: '<S6>/TOF2' */

  /* SystemInitialize for Atomic SubSystem: '<S343>/PID_Power' */
  /* InitializeConditions for DiscreteIntegrator: '<S389>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_c = 1U;

  /* InitializeConditions for Delay: '<S394>/Delay' */
  Gen2_ref_DWork->icLoad_ht = true;

  /* End of SystemInitialize for SubSystem: '<S343>/PID_Power' */

  /* SystemInitialize for Atomic SubSystem: '<S760>/p2sfilt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->p2sfilt_l, inst);

  /* End of SystemInitialize for SubSystem: '<S760>/p2sfilt' */

  /* SystemInitialize for Atomic SubSystem: '<S424>/speed Filter' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->speedFilter, inst);

  /* End of SystemInitialize for SubSystem: '<S424>/speed Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S424>/Filter1' */
  Gen2_ref_Filter1_Init(&Gen2_ref_DWork->Filter1_f, inst);

  /* End of SystemInitialize for SubSystem: '<S424>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S761>/Filter1' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.Constant1_g, &Gen2_ref_DWork->Filter1_p, inst);

  /* End of SystemInitialize for SubSystem: '<S761>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S761>/Filter' */
  Gen2_ref_Pd_filt_Init(&Gen2_ref_DWork->Filter_kj, inst);

  /* End of SystemInitialize for SubSystem: '<S761>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S585>/Filter1' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->Filter1_fg, inst);

  /* End of SystemInitialize for SubSystem: '<S585>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S585>/Filter' */
  Gen2_ref_Filter3_Init(1.0, &Gen2_ref_DWork->Filter_n, inst);

  /* End of SystemInitialize for SubSystem: '<S585>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S306>/2nd Order Filter' */
  Gen2_ref_undOrderFilter_Init(&Gen2_ref_DWork->undOrderFilter, inst);

  /* End of SystemInitialize for SubSystem: '<S306>/2nd Order Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S306>/2nd Order Filter1' */
  Gen2_ref_undOrderFilter_Init(&Gen2_ref_DWork->undOrderFilter1, inst);

  /* End of SystemInitialize for SubSystem: '<S306>/2nd Order Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S306>/2nd Order Filter2' */
  Gen2_ref_undOrderFilter_Init(&Gen2_ref_DWork->undOrderFilter2, inst);

  /* End of SystemInitialize for SubSystem: '<S306>/2nd Order Filter2' */

  /* SystemInitialize for Atomic SubSystem: '<S306>/2nd Order Filter3' */
  Gen2_ref_undOrderFilter3_Init(&Gen2_ref_DWork->undOrderFilter3, inst);

  /* End of SystemInitialize for SubSystem: '<S306>/2nd Order Filter3' */

  /* SystemInitialize for Atomic SubSystem: '<S196>/T1LP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->T1LP_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S196>/T1LP_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S195>/T1HP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->T1HP_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S195>/T1HP_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S20>/Filter1' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.T_filt1, &Gen2_ref_DWork->Filter1_ny, inst);

  /* End of SystemInitialize for SubSystem: '<S20>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S20>/Filter3' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.T_filt1, &Gen2_ref_DWork->Filter3_f, inst);

  /* End of SystemInitialize for SubSystem: '<S20>/Filter3' */

  /* SystemInitialize for Atomic SubSystem: '<S20>/Filter' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.T_filt1, &Gen2_ref_DWork->Filter_f, inst);

  /* End of SystemInitialize for SubSystem: '<S20>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S20>/Filter2' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.T_filt1, &Gen2_ref_DWork->Filter2_o, inst);

  /* End of SystemInitialize for SubSystem: '<S20>/Filter2' */

  /* SystemInitialize for Atomic SubSystem: '<S14>/Filter' */
  Gen2_ref_Pd_filt_Init(&Gen2_ref_DWork->Filter_l, inst);

  /* End of SystemInitialize for SubSystem: '<S14>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S342>/PID_Power' */
  /* InitializeConditions for DiscreteIntegrator: '<S379>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_g = 1U;

  /* InitializeConditions for Delay: '<S385>/Delay' */
  Gen2_ref_DWork->icLoad_nq = true;

  /* End of SystemInitialize for SubSystem: '<S342>/PID_Power' */

  /* SystemInitialize for Atomic SubSystem: '<S737>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S743>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_IC_LOA_m = 1U;

  /* End of SystemInitialize for SubSystem: '<S737>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S637>/Filter' */
  Gen2_ref_Pd_filt_Init(&Gen2_ref_DWork->Filter_bd, inst);

  /* End of SystemInitialize for SubSystem: '<S637>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S626>/Filter1' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->Filter1_o, inst);

  /* End of SystemInitialize for SubSystem: '<S626>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S667>/TP' */
  Gen2_ref_TP_Init(&Gen2_ref_DWork->TP_p2, inst);

  /* End of SystemInitialize for SubSystem: '<S667>/TP' */

  /* SystemInitialize for Atomic SubSystem: '<S667>/TP1' */
  Gen2_ref_TP_Init(&Gen2_ref_DWork->TP1_c, inst);

  /* End of SystemInitialize for SubSystem: '<S667>/TP1' */

  /* SystemInitialize for Atomic SubSystem: '<S667>/TOF' */
  Gen2_ref_TOF_Init(&Gen2_ref_DWork->TOF_g, inst);

  /* End of SystemInitialize for SubSystem: '<S667>/TOF' */

  /* SystemInitialize for Atomic SubSystem: '<S630>/Filter' */
  Gen2_ref_Filter_Init(&Gen2_ref_DWork->Filter_nk, inst);

  /* End of SystemInitialize for SubSystem: '<S630>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S636>/Filter' */
  Gen2_ref_Filter_Init(&Gen2_ref_DWork->Filter_m, inst);

  /* End of SystemInitialize for SubSystem: '<S636>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S608>/SkipPulseWaitTP' */
  Gen2_ref_TP_Init(&Gen2_ref_DWork->SkipPulseWaitTP, inst);

  /* End of SystemInitialize for SubSystem: '<S608>/SkipPulseWaitTP' */

  /* SystemInitialize for MATLAB Function: '<S749>/MATLAB Function' */
  Gen2_ref_DWork->SR_LoadStep = true;

  /* SystemInitialize for Atomic SubSystem: '<S628>/Filter' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.Constant2, &Gen2_ref_DWork->Filter_b, inst);

  /* End of SystemInitialize for SubSystem: '<S628>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S306>/2nd Order Filter4' */
  /* InitializeConditions for DiscreteIntegrator: '<S318>/Discrete-Time Integrator1' */
  Gen2_ref_DWork->DiscreteTimeIntegrator1_IC_LO_n = 1U;

  /* End of SystemInitialize for SubSystem: '<S306>/2nd Order Filter4' */

  /* SystemInitialize for Atomic SubSystem: '<S204>/p2HP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->p2HP_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S204>/p2HP_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S202>/p1HP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->p1HP_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S202>/p1HP_filt' */

  /* SystemInitialize for MATLAB Function: '<S24>/MATLAB Function' */
  Gen2_ref_MATLABFunction_Init(&Gen2_ref_DWork->sf_MATLABFunction_f, inst);

  /* SystemInitialize for Atomic SubSystem: '<S134>/Filter' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.u, &Gen2_ref_DWork->Filter, inst);

  /* End of SystemInitialize for SubSystem: '<S134>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S23>/Filter2' */
  Gen2_ref_Filter1_Init(&Gen2_ref_DWork->Filter2, inst);

  /* End of SystemInitialize for SubSystem: '<S23>/Filter2' */

  /* SystemInitialize for Atomic SubSystem: '<S23>/Filter1' */
  Gen2_ref_Filter1_Init(&Gen2_ref_DWork->Filter1, inst);

  /* End of SystemInitialize for SubSystem: '<S23>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S23>/Filter4' */
  Gen2_ref_Filter1_Init(&Gen2_ref_DWork->Filter4, inst);

  /* End of SystemInitialize for SubSystem: '<S23>/Filter4' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TOF3' */
  Gen2_ref_TOF_Init(&Gen2_ref_DWork->TOF3, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TOF3' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP_ActSat_TV' */
  Gen2_ref_TP_ActSat_CBV_Init(&Gen2_ref_DWork->TP_ActSat_TV, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP_ActSat_TV' */

  /* SystemInitialize for MATLAB Function: '<S25>/MATLAB Function' */
  Gen2_ref_MATLABFunction_Init(&Gen2_ref_DWork->sf_MATLABFunction_e, inst);

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP_ActSat_CBV' */
  Gen2_ref_TP_ActSat_CBV_Init(&Gen2_ref_DWork->TP_ActSat_CBV, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP_ActSat_CBV' */

  /* SystemInitialize for Atomic SubSystem: '<S62>/Filter3' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.Constant11, &Gen2_ref_DWork->Filter3, inst);

  /* End of SystemInitialize for SubSystem: '<S62>/Filter3' */

  /* SystemInitialize for Atomic SubSystem: '<S46>/cbv tracking1' */
  /* SystemInitialize for Atomic SubSystem: '<S174>/TP' */
  /* InitializeConditions for UnitDelay: '<S181>/Unit Delay2' */
  Gen2_ref_DWork->UnitDelay2_DSTATE_b = true;

  /* End of SystemInitialize for SubSystem: '<S174>/TP' */
  /* End of SystemInitialize for SubSystem: '<S46>/cbv tracking1' */

  /* SystemInitialize for Atomic SubSystem: '<S207>/p3LP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->p3LP_filt_e, inst);

  /* End of SystemInitialize for SubSystem: '<S207>/p3LP_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S208>/p4LP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->p4LP_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S208>/p4LP_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S426>/TP' */
  Gen2_ref_TP_Init(&Gen2_ref_DWork->TP, inst);

  /* End of SystemInitialize for SubSystem: '<S426>/TP' */

  /* SystemInitialize for Atomic SubSystem: '<S426>/TP1' */
  Gen2_ref_TP_Init(&Gen2_ref_DWork->TP1, inst);

  /* End of SystemInitialize for SubSystem: '<S426>/TP1' */

  /* SystemInitialize for Atomic SubSystem: '<S192>/N_TC_LP_filt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->N_TC_LP_filt, inst);

  /* End of SystemInitialize for SubSystem: '<S192>/N_TC_LP_filt' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/Filter' */
  Gen2_ref_Pd_filt_Init(&Gen2_ref_DWork->Filter_k, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP_Misfire_ON' */
  Gen2_ref_TP_ActSat_CBV_Init(&Gen2_ref_DWork->TP_Misfire_ON, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP_Misfire_ON' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP_Misfire_OFF' */
  Gen2_ref_TP_ActSat_CBV_Init(&Gen2_ref_DWork->TP_Misfire_OFF, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP_Misfire_OFF' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP_Misfire_OFF1' */
  Gen2_ref_TP_ActSat_CBV_Init(&Gen2_ref_DWork->TP_Misfire_OFF1, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP_Misfire_OFF1' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP_Misfire_ON_2nd time' */
  Gen2_ref_TP_ActSat_CBV_Init(&Gen2_ref_DWork->TP_Misfire_ON_2ndtime, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP_Misfire_ON_2nd time' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP_Misfire_OFF2' */
  Gen2_ref_TP_ActSat_CBV_Init(&Gen2_ref_DWork->TP_Misfire_OFF2, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP_Misfire_OFF2' */

  /* SystemInitialize for Atomic SubSystem: '<S19>/Filter' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.x0_f, &Gen2_ref_DWork->Filter_mn, inst);

  /* End of SystemInitialize for SubSystem: '<S19>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TP_Ign retard' */
  Gen2_ref_TP_ActSat_CBV_Init(&Gen2_ref_DWork->TP_Ignretard, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TP_Ign retard' */

  /* SystemInitialize for Atomic SubSystem: '<S814>/Filter1' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->Filter1_n, inst);

  /* End of SystemInitialize for SubSystem: '<S814>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S831>/TP' */
  Gen2_ref_TP_Init(&Gen2_ref_DWork->TP_g, inst);

  /* End of SystemInitialize for SubSystem: '<S831>/TP' */

  /* SystemInitialize for Atomic SubSystem: '<S831>/TP1' */
  Gen2_ref_TP_Init(&Gen2_ref_DWork->TP1_l, inst);

  /* End of SystemInitialize for SubSystem: '<S831>/TP1' */

  /* SystemInitialize for Atomic SubSystem: '<S831>/TOF' */
  Gen2_ref_TOF_Init(&Gen2_ref_DWork->TOF_n, inst);

  /* End of SystemInitialize for SubSystem: '<S831>/TOF' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/BDC_Trajectory' */
  /* InitializeConditions for DiscreteIntegrator: '<S417>/Discrete-Time Integrator' */
  Gen2_ref_DWork->DiscreteTimeIntegrator_DSTATE_b = 1.0;

  /* InitializeConditions for Delay: '<S434>/Delay' */
  Gen2_ref_DWork->icLoad_mu = true;

  /* SystemInitialize for Atomic SubSystem: '<S417>/p2sfilt' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->p2sfilt_b, inst);

  /* End of SystemInitialize for SubSystem: '<S417>/p2sfilt' */
  /* End of SystemInitialize for SubSystem: '<S8>/BDC_Trajectory' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TOF' */
  Gen2_ref_TOF_p_Init(&Gen2_ref_DWork->TOF_c, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TOF' */

  /* SystemInitialize for Atomic SubSystem: '<S427>/TOF2' */
  Gen2_ref_TOF_p_Init(&Gen2_ref_DWork->TOF2_d, inst);

  /* End of SystemInitialize for SubSystem: '<S427>/TOF2' */

  /* SystemInitialize for Atomic SubSystem: '<S633>/Filter' */
  Gen2_ref_Filter3_Init(Gen2_ref_ConstB.Constant3, &Gen2_ref_DWork->Filter_pj, inst);

  /* End of SystemInitialize for SubSystem: '<S633>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S15>/Filter1' */
  Gen2_ref_N_TC_HP_filt_Init(&Gen2_ref_DWork->Filter1_fj, inst);

  /* End of SystemInitialize for SubSystem: '<S15>/Filter1' */
}

/* Model terminate function */
void Gen2_ref_terminate(RT_MODEL_Gen2_ref *const Gen2_ref_M, struct Gen2* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(Gen2_ref_M);
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.11 (R2021b)14-May-2021                                            *
 * Simulink 10.4 (R2021b)14-May-2021                                          *
 * Simulink Coder 9.6 (R2021b)14-May-2021                                     *
 * Embedded Coder 7.7 (R2021b)14-May-2021                                     *
 * Stateflow 10.5 (R2021b)14-May-2021                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * control_toolbox                                                            *
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
