/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: FSync
 * File: FSync.c
 * Author: 105051359
 * Created: Mon Mar 13 15:42:43 2017
 ********************************************************************
 * Implementation of program FSync
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "FSync.h"
#include "FSync_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_S16 */
void BINARYSEARCH_S16(uint32_T *piLeft, uint32_T *piRght, int16_T u, const
                      int16_T *pData, uint32_T iHi, struct fFSync* inst)
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

/* Lookup Interpolation INTERPOLATE_U8S16_S16 */
void INTERPOLATE_U8S16_S16(uint8_T *pY, int16_T yL, int16_T yR, int16_T x,
  int16_T xL, int16_T xR, struct fFSync* inst)
{
  int32_T bigProd;
  int16_T yDiff;
  int16_T xNum;
  int16_T xDen;
  uint8_T yAdjust;
  *pY = (uint8_T)yL;

  /* If x is not strictly between xR and xL
   * then an interpolation calculation is not necessary x == xL
   * or not valid.  The invalid situation is expected when the input
   * is beyond the left or right end of the table.  The design is
   * that yL holds the correct value for *pY
   * in invalid situations.
   */
  if ((xR > xL) && (x > xL) ) {
    xDen = xR;
    xDen = (int16_T)(xDen - xL);
    xNum = x;
    xNum = (int16_T)(xNum - xL);
    if (yR >= yL ) {
      yDiff = yR;
      yDiff = (int16_T)(yDiff - yL);
    } else {
      yDiff = yL;
      yDiff = (int16_T)(yDiff - yR);
    }

    bigProd = yDiff * xNum;
    yAdjust = (uint8_T)div_s32_floor(bigProd, (int32_T)xDen, inst);
    if (yR >= yL ) {
      *pY = (uint8_T)((uint32_T)*pY + (uint32_T)yAdjust);
    } else {
      *pY = (uint8_T)((uint32_T)*pY - (uint32_T)yAdjust);
    }
  }
}

/* Lookup Utility LookUp_U8S16_S16 */
void LookUp_U8S16_S16(uint8_T *pY, const int16_T *pYData, int16_T u, const
                      int16_T *pUData, uint32_T iHi, struct fFSync* inst)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_S16( &(iLeft), &(iRght), u, pUData, iHi, inst);
  INTERPOLATE_U8S16_S16( pY, pYData[iLeft], pYData[iRght], u, pUData[iLeft],
                        pUData[iRght], inst);
}

int32_T div_s32_floor(int32_T numerator, int32_T denominator, struct fFSync* inst)
{
  int32_T quotient;
  uint32_T absNumerator;
  uint32_T absDenominator;
  uint32_T tempAbsQuotient;
  uint32_T quotientNeedsNegation;
  if (denominator == 0) {
    quotient = numerator >= 0 ? MAX_int32_T : MIN_int32_T;

    /* Divide by zero handler */
  } else {
    absNumerator = (uint32_T)(numerator >= 0 ? numerator : -numerator);
    absDenominator = (uint32_T)(denominator >= 0 ? denominator : -denominator);
    quotientNeedsNegation = ((numerator < 0) != (denominator < 0));
    tempAbsQuotient = absNumerator / absDenominator;
    if (quotientNeedsNegation) {
      absNumerator %= absDenominator;
      if (absNumerator > 0) {
        tempAbsQuotient += (uint32_T)1;
      }
    }

    quotient = quotientNeedsNegation ? -(int32_T)tempAbsQuotient : (int32_T)
      tempAbsQuotient;
  }

  return quotient;
}

/* Model step function */
void FSync_step(struct BlockIO_FSync *FSync_B, struct D_Work_FSync *FSync_DWork,
                ExternalOutputs_FSync *FSync_Y, struct fFSync* inst)
{
  /* local block i/o variables */
  int16_T rtb_DataTypeConversion;
  int16_T rtb_DataTypeConversion1[2];
  int16_T rtb_DataTypeConversion2[2];
  uint8_T rtb_LookupTableDynamic;
  boolean_T rtb_LogicalOperator_o;
  uint8_T iNum_SkipMin;
  real32_T S;
  real32_T gk;
  boolean_T b;
  boolean_T c;
  boolean_T e;
  boolean_T f;
  boolean_T g;
  boolean_T h;
  boolean_T k;
  boolean_T l;
  real32_T rtb_Divide;
  int8_T rtb_Switch2;
  int8_T rtb_Abs;
  int8_T rtb_DataTypeConversion9;
  real32_T rtb_Switch1;
  boolean_T rtb_RelationalOperator_pw;
  real32_T rtb_Switch;
  real32_T rtb_Add1;
  boolean_T rtb_bEna;
  boolean_T rtb_bSetReached;
  uint32_T qY;
  int32_T tmp;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  FSync_B->BusInput = inst->In;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  FSync_B->BusInput1 = inst->Perm;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  FSync_B->BusInput2 = inst->Para;

  /* MATLAB Function: '<Root>/Skipfire_active' */
  /* MATLAB Function 'Skipfire_active': '<S7>:1' */
  /* % enable Sync function */
  if (FSync_B->BusInput.rN_Eng >= FSync_B->BusInput1.rN_enableNorm *
      FSync_B->BusInput2.rN_EngNom) {
    /* '<S7>:1:14' */
    /* '<S7>:1:15' */
    FSync_DWork->ssr = TRUE;
  }

  if (FSync_B->BusInput.rN_Eng >= FSync_B->BusInput1.rN_idleNorm *
      FSync_B->BusInput2.rN_EngNom) {
    /* '<S7>:1:18' */
    /* '<S7>:1:19' */
    FSync_DWork->ssr_Set = TRUE;
  }

  if (FSync_B->BusInput.bGCB_ON || (FSync_B->BusInput.rN_Eng < 100.0F)) {
    /* '<S7>:1:22' */
    /* '<S7>:1:23' */
    FSync_DWork->ssr = FALSE;

    /* '<S7>:1:24' */
    FSync_DWork->ssr_Set = FALSE;
  }

  /* '<S7>:1:28' */
  rtb_bEna = FSync_DWork->ssr;

  /* '<S7>:1:29' */
  rtb_bSetReached = FSync_DWork->ssr_Set;

  /* End of MATLAB Function: '<Root>/Skipfire_active' */

  /* DataTypeConversion: '<S5>/Data Type Conversion' incorporates:
   *  Gain: '<S5>/Gain'
   */
  S = (real32_T)fmod((real32_T)floor(10.0F * FSync_B->BusInput.rT_EO), 65536.0F);
  rtb_DataTypeConversion = (int16_T)(S < 0.0F ? (int16_T)-(int16_T)(uint16_T)-S :
                                     (int16_T)(uint16_T)S);

  /* DataTypeConversion: '<S5>/Data Type Conversion1' incorporates:
   *  BusSelector: '<S5>/Bus Selector1'
   *  Gain: '<S5>/Gain1'
   */
  S = (real32_T)fmod((real32_T)floor(10.0F * FSync_B->BusInput1.rT_Cold),
                     65536.0F);
  rtb_DataTypeConversion1[0] = (int16_T)(S < 0.0F ? (int16_T)-(int16_T)(uint16_T)
    -S : (int16_T)(uint16_T)S);
  S = (real32_T)fmod((real32_T)floor(10.0F * FSync_B->BusInput1.rT_Warm),
                     65536.0F);
  rtb_DataTypeConversion1[1] = (int16_T)(S < 0.0F ? (int16_T)-(int16_T)(uint16_T)
    -S : (int16_T)(uint16_T)S);

  /* DataTypeConversion: '<S5>/Data Type Conversion2' incorporates:
   *  BusSelector: '<S5>/Bus Selector1'
   */
  rtb_DataTypeConversion2[0] = FSync_B->BusInput1.iNum_SkipCyl_Cold;
  rtb_DataTypeConversion2[1] = FSync_B->BusInput1.iNum_SkipCyl_Warm;

  /* Dynamic Look-Up Table Block: '<S5>/Lookup Table Dynamic'
   * Input0  Data Type:  Integer        S16
   * Input1  Data Type:  Integer        S16
   * Input2  Data Type:  Integer        S16
   * Output0 Data Type:  Integer        U8
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_U8S16_S16( &(rtb_LookupTableDynamic), rtb_DataTypeConversion2,
                   rtb_DataTypeConversion, rtb_DataTypeConversion1, 1U, inst);

  /* Switch: '<S9>/Switch1' incorporates:
   *  Constant: '<S13>/Constant'
   *  Logic: '<S9>/Logical Operator3'
   *  Product: '<S9>/Divide1'
   *  RelationalOperator: '<S13>/Compare'
   */
  if (FSync_B->BusInput1.bF_act_ena && (FSync_B->BusInput.iIdx_SyOMSS > 0)) {
    /* Switch: '<S15>/Switch' incorporates:
     *  Abs: '<S15>/Abs'
     *  RelationalOperator: '<S15>/Relational Operator'
     */
    if (1.0F >= (real32_T)fabs(FSync_B->BusInput2.rF_Nom)) {
      S = 1.0F;
    } else {
      S = FSync_B->BusInput2.rF_Nom;
    }

    /* End of Switch: '<S15>/Switch' */
    rtb_Switch1 = FSync_B->BusInput.rF_MMD * FSync_B->BusInput2.rN_EngNom / S;
  } else {
    rtb_Switch1 = FSync_B->BusInput.rN_Eng;
  }

  /* End of Switch: '<S9>/Switch1' */

  /* Switch: '<S16>/Switch' incorporates:
   *  Abs: '<S16>/Abs'
   *  BusSelector: '<S9>/Bus Selector'
   *  RelationalOperator: '<S16>/Relational Operator'
   */
  if (1.0F >= (real32_T)fabs(FSync_B->BusInput2.rF_Nom)) {
    S = 1.0F;
  } else {
    S = FSync_B->BusInput2.rF_Nom;
  }

  /* End of Switch: '<S16>/Switch' */

  /* Product: '<S9>/Divide' */
  rtb_Divide = FSync_B->BusInput.rF_MMD_BusBar / S *
    FSync_B->BusInput2.rN_EngNom;

  /* Outputs for Atomic SubSystem: '<S9>/Filter' */
  /* RelationalOperator: '<S17>/Relational Operator' incorporates:
   *  Constant: '<S17>/Constant'
   */
  rtb_RelationalOperator_pw = (FSync_B->BusInput1.rTi_FiltF > 0.0F);

  /* Logic: '<S17>/Logical Operator' incorporates:
   *  Logic: '<S17>/Logical Operator1'
   */
  rtb_LogicalOperator_o = (FSync_B->BusInput.bReset ||
    (!rtb_RelationalOperator_pw));

  /* DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */
  if (FSync_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    FSync_DWork->DiscreteTimeIntegrator_DSTATE = FSync_B->BusInput2.rN_EngNom;
  }

  if (rtb_LogicalOperator_o || (FSync_DWork->DiscreteTimeIntegrator_PrevRese !=
       0)) {
    FSync_DWork->DiscreteTimeIntegrator_DSTATE = FSync_B->BusInput2.rN_EngNom;
  }

  /* Switch: '<S17>/Switch' incorporates:
   *  DiscreteIntegrator: '<S17>/Discrete-Time Integrator'
   */
  if (rtb_RelationalOperator_pw) {
    rtb_Switch = FSync_DWork->DiscreteTimeIntegrator_DSTATE;
  } else {
    rtb_Switch = rtb_Divide;
  }

  /* End of Switch: '<S17>/Switch' */

  /* Update for DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */
  FSync_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Switch: '<S21>/Switch' incorporates:
   *  Abs: '<S21>/Abs'
   *  RelationalOperator: '<S21>/Relational Operator'
   */
  if (2.22044605E-16F >= (real32_T)fabs(FSync_B->BusInput1.rTi_FiltF)) {
    S = 2.22044605E-16F;
  } else {
    S = FSync_B->BusInput1.rTi_FiltF;
  }

  /* End of Switch: '<S21>/Switch' */

  /* Update for DiscreteIntegrator: '<S17>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S17>/Discrete-Time Integrator'
   *  Product: '<S17>/Divide4'
   *  Sum: '<S17>/Sum4'
   */
  FSync_DWork->DiscreteTimeIntegrator_DSTATE += (rtb_Divide -
    FSync_DWork->DiscreteTimeIntegrator_DSTATE) / S * 0.01F;
  if (rtb_LogicalOperator_o) {
    FSync_DWork->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    FSync_DWork->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Outputs for SubSystem: '<S9>/Filter' */

  /* Switch: '<S9>/Switch2' incorporates:
   *  Constant: '<S11>/Constant'
   *  Constant: '<S9>/Constant'
   *  Logic: '<S9>/Logical Operator1'
   *  RelationalOperator: '<S11>/Compare'
   */
  if ((FSync_B->BusInput.iIdx_SyOMSS > 0) && FSync_B->BusInput2.bFastSync) {
    rtb_Switch2 = FSync_B->BusInput1.iCtrSel;
  } else {
    rtb_Switch2 = 1;
  }

  /* End of Switch: '<S9>/Switch2' */

  /* Switch: '<S9>/Switch' incorporates:
   *  BusSelector: '<S9>/Bus Selector'
   *  Constant: '<S14>/Constant'
   *  Constant: '<S9>/Constant1'
   *  Logic: '<S9>/Logical Operator'
   *  Product: '<S9>/Product1'
   *  RelationalOperator: '<S14>/Compare'
   *  RelationalOperator: '<S9>/Relational Operator'
   */
  if (FSync_B->BusInput1.bSpeedSet_ena || (FSync_B->BusInput.iIdx_SyOMSS == 0) ||
      (FSync_B->BusInput.rF_MMD_BusBar < 0.5F * FSync_B->BusInput2.rF_Nom)) {
    rtb_Switch = FSync_B->BusInput2.rN_EngNom;
  }

  /* End of Switch: '<S9>/Switch' */

  /* Switch: '<S9>/Switch4' incorporates:
   *  Constant: '<S10>/Constant'
   *  Constant: '<S12>/Constant'
   *  Constant: '<S9>/Const_0'
   *  Logic: '<S9>/Logical Operator2'
   *  RelationalOperator: '<S10>/Compare'
   *  RelationalOperator: '<S12>/Compare'
   */
  if ((FSync_B->BusInput.iIdx_SyOMSS > 0) && (rtb_Switch2 == 1)) {
    S = FSync_B->BusInput2.rN_Offs_Sync;
  } else {
    S = 0.0F;
  }

  /* End of Switch: '<S9>/Switch4' */

  /* Sum: '<S9>/Add1' */
  rtb_Add1 = rtb_Switch + S;

  /* Abs: '<S9>/Abs' */
  if (FSync_B->BusInput1.iNum_SkipCylLim_P < 0) {
    rtb_Abs = (int8_T)-FSync_B->BusInput1.iNum_SkipCylLim_P;
  } else {
    rtb_Abs = FSync_B->BusInput1.iNum_SkipCylLim_P;
  }

  /* End of Abs: '<S9>/Abs' */

  /* Product: '<S9>/Product' incorporates:
   *  Sum: '<S9>/Add'
   */
  S = (rtb_Switch1 - rtb_Add1) * FSync_B->BusInput1.rGain_P;

  /* DataTypeConversion: '<S9>/Data Type Conversion9' */
  if (S < 0.0F) {
    S = (real32_T)ceil(S);
  } else {
    S = (real32_T)floor(S);
  }

  S = (real32_T)fmod(S, 256.0F);
  rtb_DataTypeConversion9 = (int8_T)(S < 0.0F ? (int8_T)-(int8_T)(uint8_T)-S :
    (int8_T)(uint8_T)S);

  /* End of DataTypeConversion: '<S9>/Data Type Conversion9' */

  /* Switch: '<S18>/Switch2' incorporates:
   *  RelationalOperator: '<S18>/LowerRelop1'
   */
  if (!(rtb_DataTypeConversion9 > rtb_Abs)) {
    /* Gain: '<S9>/Gain2' */
    rtb_Abs = (int8_T)-rtb_Abs;

    /* Switch: '<S18>/Switch' incorporates:
     *  RelationalOperator: '<S18>/UpperRelop'
     */
    if (!(rtb_DataTypeConversion9 < rtb_Abs)) {
      rtb_Abs = rtb_DataTypeConversion9;
    }

    /* End of Switch: '<S18>/Switch' */
  }

  /* End of Switch: '<S18>/Switch2' */

  /* MATLAB Function: '<Root>/SkipFireCtrl' incorporates:
   *  Gain: '<S9>/Conv rad'
   *  Product: '<S8>/Product1'
   *  SampleTimeMath: '<S8>/Weighted Sample Time'
   *
   * About '<S8>/Weighted Sample Time':
   *  y = K where K = 1 / ( w * Ts )
   */
  iNum_SkipMin = FSync_B->BusInput1.iNum_SkipMin;

  /* MATLAB Function 'SkipFireCtrl': '<S6>:1' */
  /* % init */
  if ((!FSync_DWork->cyl_skipped_not_empty) || (!rtb_bEna)) {
    /* '<S6>:1:14' */
    /* '<S6>:1:15' */
    FSync_DWork->cyl_skipped = 0U;
    FSync_DWork->cyl_skipped_not_empty = TRUE;

    /* '<S6>:1:16' */
    FSync_DWork->skipcounter = 0U;

    /* '<S6>:1:17' */
    FSync_DWork->bSkipDrehz_O = FALSE;

    /* '<S6>:1:18' */
    FSync_DWork->bSkipDrehz_U = FALSE;

    /* '<S6>:1:19' */
    FSync_DWork->Count_Switch = 0U;

    /* '<S6>:1:20' */
    FSync_DWork->No_Access = FALSE;

    /* '<S6>:1:21' */
    FSync_DWork->rN_Set_old = 0.0F;
  }

  /* % switch to ctrl 1 after a certain time */
  if (rtb_bSetReached) {
    /* '<S6>:1:26' */
    if (((real32_T)FSync_DWork->Count_Switch < FSync_B->BusInput1.rTi_FastSync *
         100.0F) && (rtb_Switch2 > 1)) {
      /* '<S6>:1:27' */
      /* '<S6>:1:28' */
      qY = (uint32_T)FSync_DWork->Count_Switch + 1U;
      if (qY > 65535U) {
        qY = 65535U;
      }

      FSync_DWork->Count_Switch = (uint16_T)qY;

      /* '<S6>:1:29' */
      FSync_B->bEnabled = TRUE;

      /* '<S6>:1:30' */
      FSync_DWork->No_Access = FALSE;
    } else if (!FSync_DWork->No_Access) {
      /* '<S6>:1:31' */
      /* '<S6>:1:32' */
      rtb_Switch2 = 1;

      /* '<S6>:1:33' */
      FSync_DWork->cyl_skipped = rtb_LookupTableDynamic;

      /* '<S6>:1:34' */
      FSync_DWork->No_Access = TRUE;

      /* '<S6>:1:35' */
      FSync_B->bEnabled = FSync_B->BusInput1.bStdCtrl;

      /*  switch to structured text standard controller if bStdCtrl is not set */
    } else {
      /* '<S6>:1:37' */
      rtb_Switch2 = 1;

      /* '<S6>:1:38' */
      FSync_B->bEnabled = FSync_B->BusInput1.bStdCtrl;
    }
  } else {
    /* '<S6>:1:41' */
    iNum_SkipMin = 0U;

    /* '<S6>:1:42' */
    FSync_B->bEnabled = TRUE;
  }

  if (FSync_DWork->skipcounter < 2000) {
    /* '<S6>:1:47' */
    /* '<S6>:1:48' */
    qY = (uint32_T)FSync_DWork->skipcounter + 1U;
    if (qY > 65535U) {
      qY = 65535U;
    }

    FSync_DWork->skipcounter = (uint16_T)qY;
  } else {
    /* '<S6>:1:50' */
    FSync_DWork->skipcounter = 0U;
  }

  /* % Modified law */
  /* '<S6>:1:56' */
  rtb_Divide = rtb_Switch1 - rtb_Add1;

  /* '<S6>:1:57' */
  rtb_Switch = 0.0174532924F * FSync_B->BusInput.rAng_MMD_Diff -
    FSync_B->BusInput1.rAngleSetDeg * 3.14159274F / 180.0F;

  /* '<S6>:1:59' */
  S = 0.5F * rtb_Divide * (real32_T)fabs(rtb_Divide) * 3.0F * 3.14159274F /
    30.0F * 3.0F * 3.14159274F / 30.0F + rtb_Switch;
  if ((0.5F * rtb_Divide * rtb_Divide * 3.0F * 3.14159274F / 30.0F * 3.0F *
       3.14159274F / 30.0F + rtb_Switch == 0.0F) && (rtb_Divide >= 0.0F)) {
    /* '<S6>:1:60' */
    b = TRUE;
  } else {
    /* '<S6>:1:60' */
    b = FALSE;
  }

  /*  x2: speed, x1: angle gamma minus */
  if ((-0.5F * rtb_Divide * rtb_Divide * 3.0F * 3.14159274F / 30.0F * 3.0F *
       3.14159274F / 30.0F + rtb_Switch == 0.0F) && (rtb_Divide <= 0.0F)) {
    /* '<S6>:1:61' */
    c = TRUE;
  } else {
    /* '<S6>:1:61' */
    c = FALSE;
  }

  /*  gamma plus */
  /*  why not using direct S1 ??? */
  /*  why not using direct S2 ??? */
  /* '<S6>:1:64' */
  /*  x2 */
  /*  x1                                                                              % not used, delete ??? */
  if ((S <= FSync_B->BusInput1.rRelaxAngleDeg * 3.14159274F / 180.0F) && (S >=
       -FSync_B->BusInput1.rRelaxAngleDeg * 3.14159274F / 180.0F) &&
      (-rtb_Divide < 0.0F)) {
    /* '<S6>:1:66' */
    rtb_RelationalOperator_pw = TRUE;
  } else {
    /* '<S6>:1:66' */
    rtb_RelationalOperator_pw = FALSE;
  }

  if ((S <= FSync_B->BusInput1.rRelaxAngleDeg * 3.14159274F / 180.0F) && (S >=
       -FSync_B->BusInput1.rRelaxAngleDeg * 3.14159274F / 180.0F) &&
      (-rtb_Divide > 0.0F)) {
    /* '<S6>:1:67' */
    e = TRUE;
  } else {
    /* '<S6>:1:67' */
    e = FALSE;
  }

  /* '<S6>:1:68' */
  /* '<S6>:1:69' */
  /* '<S6>:1:70' */
  if ((-0.5F * rtb_Divide * rtb_Divide * 3.0F * 3.14159274F / 30.0F * 3.0F *
       3.14159274F / 30.0F + rtb_Switch == FSync_B->BusInput1.rRelaxAngleDeg *
       3.14159274F / 180.0F) && (-rtb_Divide < 0.0F)) {
    /* '<S6>:1:71' */
    f = TRUE;
  } else {
    /* '<S6>:1:71' */
    f = FALSE;
  }

  if ((-FSync_B->BusInput1.rRelaxAngleDeg * 3.14159274F / 180.0F == S) &&
      (-rtb_Divide > 0.0F)) {
    /* '<S6>:1:72' */
    g = TRUE;
  } else {
    /* '<S6>:1:72' */
    g = FALSE;
  }

  if (rtb_RelationalOperator_pw || (S < -FSync_B->BusInput1.rRelaxAngleDeg *
       3.14159274F / 180.0F)) {
    /* '<S6>:1:66' */
    /* '<S6>:1:73' */
    h = TRUE;
  } else {
    /* '<S6>:1:73' */
    h = FALSE;
  }

  if (e || (S > FSync_B->BusInput1.rRelaxAngleDeg * 3.14159274F / 180.0F)) {
    /* '<S6>:1:67' */
    /* '<S6>:1:74' */
    rtb_RelationalOperator_pw = TRUE;
  } else {
    /* '<S6>:1:74' */
    rtb_RelationalOperator_pw = FALSE;
  }

  /*  k->inf, time optimal, k->0 fuel optimal */
  /* '<S6>:1:76' */
  gk = (FSync_B->BusInput1.rWeightFuel + 4.0F) / (2.0F *
    FSync_B->BusInput1.rWeightFuel);
  if ((S >= 0.0F) && (gk * rtb_Divide * (real32_T)fabs(rtb_Divide) * 3.0F *
                      3.14159274F / 30.0F * 3.0F * 3.14159274F / 30.0F +
                      rtb_Switch > 0.0F)) {
    /* '<S6>:1:77' */
    e = TRUE;
  } else {
    /* '<S6>:1:77' */
    e = FALSE;
  }

  /*  not used, delete ??? */
  if ((S <= 0.0F) && (gk * rtb_Divide * (real32_T)fabs(rtb_Divide) * 3.0F *
                      3.14159274F / 30.0F * 3.0F * 3.14159274F / 30.0F +
                      rtb_Switch < 0.0F)) {
    /* '<S6>:1:79' */
    k = TRUE;
  } else {
    /* '<S6>:1:79' */
    k = FALSE;
  }

  if ((S > 0.0F) && (gk * rtb_Divide * (real32_T)fabs(rtb_Divide) * 3.0F *
                     3.14159274F / 30.0F * 3.0F * 3.14159274F / 30.0F +
                     rtb_Switch <= 0.0F)) {
    /* '<S6>:1:80' */
    l = TRUE;
  } else {
    /* '<S6>:1:80' */
    l = FALSE;
  }

  /* '<S6>:1:81' */
  rtb_Divide = 10.0F * rtb_Divide * 3.0F * 3.14159274F / 30.0F * 3.0F *
    3.14159274F / 30.0F + rtb_Switch;

  /* % Change Selector */
  /* '<S6>:1:85' */
  switch (rtb_Switch2) {
   case 1:
    /*  Std skip firing */
    if ((rtb_Switch1 > rtb_Add1 + FSync_B->BusInput1.rN_SetTol) &&
        (FSync_DWork->cyl_skipped < 18) && rtb_bSetReached &&
        ((FSync_DWork->skipcounter > FSync_B->BusInput1.iSkipCounterLimit) ||
         FSync_DWork->bSkipDrehz_U)) {
      /* '<S6>:1:87' */
      /* Sid: prohibit entering if counter below limit, min dwell time in skip mode time optimal */
      /* '<S6>:1:88' */
      tmp = (int32_T)((uint32_T)FSync_DWork->cyl_skipped + 1U);
      if ((uint32_T)tmp > 255U) {
        tmp = 255;
      }

      FSync_DWork->cyl_skipped = (uint8_T)tmp;

      /*  increase mode */
      /* '<S6>:1:89' */
      FSync_DWork->skipcounter = 0U;

      /* '<S6>:1:90' */
      FSync_DWork->bSkipDrehz_O = TRUE;

      /* '<S6>:1:91' */
      FSync_DWork->bSkipDrehz_U = FALSE;
    } else {
      if ((rtb_Switch1 < rtb_Add1 - FSync_B->BusInput1.rN_SetTol) &&
          (FSync_DWork->cyl_skipped > 0) && rtb_bSetReached &&
          ((FSync_DWork->skipcounter > FSync_B->BusInput1.iSkipCounterLimit) ||
           FSync_DWork->bSkipDrehz_O)) {
        /* '<S6>:1:92' */
        /*  Cyl 1 and 11 are prmanently fired --> max 18 Cylinders skipped */
        /* '<S6>:1:93' */
        qY = (uint32_T)FSync_DWork->cyl_skipped - 1U;
        if (qY > FSync_DWork->cyl_skipped) {
          qY = 0U;
        }

        FSync_DWork->cyl_skipped = (uint8_T)(int32_T)qY;

        /*  decrease mode */
        /* '<S6>:1:94' */
        FSync_DWork->skipcounter = 0U;

        /* '<S6>:1:95' */
        FSync_DWork->bSkipDrehz_O = FALSE;

        /* '<S6>:1:96' */
        FSync_DWork->bSkipDrehz_U = TRUE;
      }
    }
    break;

   case 2:
    /*  Time optimal */
    if ((S > FSync_B->BusInput1.rHystOptimal) || (b && rtb_bEna)) {
      /* '<S6>:1:100' */
      /* '<S6>:1:60' */
      /* '<S6>:1:100' */
      /* '<S6>:1:101' */
      FSync_DWork->cyl_skipped = FSync_B->BusInput1.iNum_SkipMax;

      /*  increase mode */
      /* '<S6>:1:102' */
      FSync_DWork->skipcounter = 0U;

      /* '<S6>:1:103' */
      FSync_DWork->bSkipDrehz_O = TRUE;

      /* '<S6>:1:104' */
      FSync_DWork->bSkipDrehz_U = FALSE;
    } else {
      if ((S < -FSync_B->BusInput1.rHystOptimal) || (c && rtb_bEna)) {
        /* '<S6>:1:105' */
        /* '<S6>:1:61' */
        /* '<S6>:1:105' */
        /* '<S6>:1:106' */
        FSync_DWork->cyl_skipped = iNum_SkipMin;

        /*  decrease mode */
        /* '<S6>:1:107' */
        FSync_DWork->skipcounter = 0U;

        /* '<S6>:1:108' */
        FSync_DWork->bSkipDrehz_O = FALSE;

        /* '<S6>:1:109' */
        FSync_DWork->bSkipDrehz_U = TRUE;
      }
    }
    break;

   case 3:
    /*  Time optimal with constraints on the angle */
    if ((rtb_RelationalOperator_pw || g) && rtb_bEna) {
      /* '<S6>:1:74' */
      /* '<S6>:1:72' */
      /* '<S6>:1:113' */
      /* '<S6>:1:114' */
      FSync_DWork->cyl_skipped = FSync_B->BusInput1.iNum_SkipMax;

      /*  increase mode */
      /* '<S6>:1:115' */
      FSync_DWork->skipcounter = 0U;

      /* '<S6>:1:116' */
      FSync_DWork->bSkipDrehz_O = TRUE;

      /* '<S6>:1:117' */
      FSync_DWork->bSkipDrehz_U = FALSE;
    } else {
      if ((h || f) && rtb_bEna) {
        /* '<S6>:1:73' */
        /* '<S6>:1:71' */
        /* '<S6>:1:118' */
        /* '<S6>:1:119' */
        FSync_DWork->cyl_skipped = iNum_SkipMin;

        /*  decrease mode */
        /* '<S6>:1:120' */
        FSync_DWork->skipcounter = 0U;

        /* '<S6>:1:121' */
        FSync_DWork->bSkipDrehz_O = FALSE;

        /* '<S6>:1:122' */
        FSync_DWork->bSkipDrehz_U = TRUE;
      }
    }
    break;

   case 4:
    /*  Fuel and time optimal */
    if (e && rtb_bEna) {
      /* '<S6>:1:77' */
      /* '<S6>:1:126' */
      /* '<S6>:1:127' */
      FSync_DWork->cyl_skipped = FSync_B->BusInput1.iNum_SkipMax;

      /*  increase mode */
      /* '<S6>:1:128' */
      FSync_DWork->skipcounter = 0U;

      /* '<S6>:1:129' */
      FSync_DWork->bSkipDrehz_O = TRUE;

      /* '<S6>:1:130' */
      FSync_DWork->bSkipDrehz_U = FALSE;
    } else {
      if (k && rtb_bEna) {
        /* '<S6>:1:79' */
        /* '<S6>:1:131' */
        /*  use with averaging controller */
        /* '<S6>:1:132' */
        FSync_DWork->cyl_skipped = iNum_SkipMin;

        /*  decrease mode */
        /* '<S6>:1:133' */
        FSync_DWork->skipcounter = 0U;

        /* '<S6>:1:134' */
        FSync_DWork->bSkipDrehz_O = FALSE;

        /* '<S6>:1:135' */
        FSync_DWork->bSkipDrehz_U = TRUE;

        /*  elseif(H2)        % delete ??? */
        /*      cyl_skipped=cyl_skipped+1; */
        /*  elseif(H4) */
        /*      cyl_skipped=cyl_skipped-1; */
      }
    }
    break;

   case 5:
    /*  Modified skip firing */
    if ((rtb_Divide > 0.0F) && (FSync_DWork->cyl_skipped < 18) && rtb_bEna &&
        ((FSync_DWork->skipcounter > FSync_B->BusInput1.iSkipCounterLimit) ||
         FSync_DWork->bSkipDrehz_U)) {
      /* '<S6>:1:143' */
      /* Sid: prohibit entering if counter below limit, min dwell time in skip mode time optimal */
      /* '<S6>:1:144' */
      tmp = (int32_T)((uint32_T)FSync_DWork->cyl_skipped + 1U);
      if ((uint32_T)tmp > 255U) {
        tmp = 255;
      }

      FSync_DWork->cyl_skipped = (uint8_T)tmp;

      /*  increase mode */
      /* '<S6>:1:145' */
      FSync_DWork->skipcounter = 0U;

      /* '<S6>:1:146' */
      FSync_DWork->bSkipDrehz_O = TRUE;

      /* '<S6>:1:147' */
      FSync_DWork->bSkipDrehz_U = FALSE;
    } else {
      if ((rtb_Divide < 0.0F) && (FSync_DWork->cyl_skipped > 0) && rtb_bEna &&
          ((FSync_DWork->skipcounter > FSync_B->BusInput1.iSkipCounterLimit) ||
           FSync_DWork->bSkipDrehz_O)) {
        /* '<S6>:1:148' */
        /*  Cyl 1 and 11 are prmanently fired --> max 18 Cylinders skipped */
        /* '<S6>:1:149' */
        qY = (uint32_T)FSync_DWork->cyl_skipped - 1U;
        if (qY > FSync_DWork->cyl_skipped) {
          qY = 0U;
        }

        FSync_DWork->cyl_skipped = (uint8_T)(int32_T)qY;

        /*  decrease mode */
        /* '<S6>:1:150' */
        FSync_DWork->skipcounter = 0U;

        /* '<S6>:1:151' */
        FSync_DWork->bSkipDrehz_O = FALSE;

        /* '<S6>:1:152' */
        FSync_DWork->bSkipDrehz_U = TRUE;
      }
    }
    break;

   default:
    if ((rtb_Switch1 > rtb_Add1 + FSync_B->BusInput1.rN_SetTol) &&
        (FSync_DWork->cyl_skipped < 18) && rtb_bEna &&
        ((FSync_DWork->skipcounter > FSync_B->BusInput1.iSkipCounterLimit) ||
         FSync_DWork->bSkipDrehz_U)) {
      /* '<S6>:1:156' */
      /* Sid: prohibit entering if counter below limit, min dwell time in skip mode time optimal */
      /* '<S6>:1:157' */
      tmp = (int32_T)((uint32_T)FSync_DWork->cyl_skipped + 1U);
      if ((uint32_T)tmp > 255U) {
        tmp = 255;
      }

      FSync_DWork->cyl_skipped = (uint8_T)tmp;

      /*  increase mode */
      /* '<S6>:1:158' */
      FSync_DWork->skipcounter = 0U;

      /* '<S6>:1:159' */
      FSync_DWork->bSkipDrehz_O = TRUE;

      /* '<S6>:1:160' */
      FSync_DWork->bSkipDrehz_U = FALSE;
    } else {
      if ((rtb_Switch1 < rtb_Add1 - FSync_B->BusInput1.rN_SetTol) &&
          (FSync_DWork->cyl_skipped > 0) && rtb_bEna &&
          ((FSync_DWork->skipcounter > FSync_B->BusInput1.iSkipCounterLimit) ||
           FSync_DWork->bSkipDrehz_O)) {
        /* '<S6>:1:161' */
        /*  Cyl 1 and 11 are prmanently fired --> max 18 Cylinders skipped */
        /* '<S6>:1:162' */
        qY = (uint32_T)FSync_DWork->cyl_skipped - 1U;
        if (qY > FSync_DWork->cyl_skipped) {
          qY = 0U;
        }

        FSync_DWork->cyl_skipped = (uint8_T)(int32_T)qY;

        /*  decrease mode */
        /* '<S6>:1:163' */
        FSync_DWork->skipcounter = 0U;

        /* '<S6>:1:164' */
        FSync_DWork->bSkipDrehz_O = FALSE;

        /* '<S6>:1:165' */
        FSync_DWork->bSkipDrehz_U = TRUE;
      }
    }
    break;
  }

  /* % Output */
  /*  fire all cylinders in case of setpoint increase */
  if (rtb_Add1 - FSync_DWork->rN_Set_old > 100.0F) {
    /* '<S6>:1:172' */
    /* '<S6>:1:173' */
    FSync_DWork->cyl_skipped = 0U;
  }

  /* '<S6>:1:175' */
  FSync_DWork->rN_Set_old = rtb_Add1;
  if (!rtb_bEna) {
    /* Outport: '<Root>/SkipCyl' */
    /* '<S6>:1:178' */
    /* '<S6>:1:179' */
    FSync_Y->SkipCyl = 0U;
  } else if (rtb_Switch2 == 1) {
    /* '<S6>:1:181' */
    /* '<S6>:1:182' */
    iNum_SkipMin = FSync_DWork->cyl_skipped;
    if (FSync_DWork->cyl_skipped > 127) {
      iNum_SkipMin = 127U;
    }

    tmp = iNum_SkipMin + rtb_Abs;
    if (tmp > 127) {
      tmp = 127;
    }

    rtb_DataTypeConversion9 = (int8_T)tmp;
    if ((int8_T)tmp < 0) {
      rtb_DataTypeConversion9 = 0;
    }

    /* Outport: '<Root>/SkipCyl' */
    FSync_Y->SkipCyl = (uint8_T)rtb_DataTypeConversion9;
  } else {
    /* Outport: '<Root>/SkipCyl' */
    /* '<S6>:1:184' */
    FSync_Y->SkipCyl = FSync_DWork->cyl_skipped;
  }

  /* % debugging */
  /* '<S6>:1:189' */
  FSync_Y->dbg.iSkipCounter = FSync_DWork->skipcounter;

  /* '<S6>:1:190' */
  FSync_Y->dbg.rSwitchSurf = S;

  /* '<S6>:1:191' */
  FSync_Y->dbg.Sf1 = c;

  /* '<S6>:1:192' */
  FSync_Y->dbg.Sf2 = b;

  /* '<S6>:1:193' */
  FSync_Y->dbg.H3 = k;

  /* '<S6>:1:194' */
  FSync_Y->dbg.H4 = l;

  /* '<S6>:1:195' */
  FSync_Y->dbg.rSmodSlid = rtb_Divide;

  /* '<S6>:1:196' */
  FSync_Y->dbg.iCounterSwitch = FSync_DWork->Count_Switch;

  /* '<S6>:1:197' */
  FSync_Y->dbg.bEna = rtb_bEna;

  /* '<S6>:1:198' */
  FSync_Y->dbg.iNskip_init = rtb_LookupTableDynamic;

  /* '<S6>:1:199' */
  FSync_Y->dbg.iCtrSel = rtb_Switch2;

  /* '<S6>:1:200' */
  FSync_Y->dbg.iNumSkipCyl_P = rtb_Abs;

  /* '<S6>:1:201' */
  FSync_Y->dbg.rN_Set = rtb_Add1;

  /* '<S6>:1:202' */
  FSync_Y->dbg.rN_Eng = rtb_Switch1;

  /* End of MATLAB Function: '<Root>/SkipFireCtrl' */

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->dbg = FSync_Y->dbg;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->iSkipCyl = FSync_Y->SkipCyl;

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->bEnabled = FSync_B->bEnabled;

  /* UnitDelay: '<S4>/Unit Delay' */
  FSync_B->UnitDelay = FSync_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->Version = FSync_B->UnitDelay;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  FSync_DWork->UnitDelay_DSTATE = 7U;
}

/* Model initialize function */
void FSync_initialize(struct D_Work_FSync *FSync_DWork, struct fFSync* inst)
{
  /* InitializeConditions for Atomic SubSystem: '<S9>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */
  FSync_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* End of InitializeConditions for SubSystem: '<S9>/Filter' */
}

/* Model terminate function */
void FSync_terminate(struct fFSync* inst)
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
