/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: J920_fric
 * File: J920_fric.c
 * Author: 212348321
 * Created: Mon Jun 13 15:26:38 2016
 ********************************************************************
 * Implementation of program J920_fric
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "J920_fric.h"
#include "J920_fric_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_real32_T */
void BINARYSEARCH_real32_T(uint32_T *piLeft, uint32_T *piRght, real32_T u, const
  real32_T *pData, uint32_T iHi, struct fFricIMEP* inst)
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
  const real32_T *pUData, uint32_T iHi, struct fFricIMEP* inst)
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

/*
 * Output and update for atomic system:
 *    '<S12>/TON'
 *    '<S14>/TON'
 *    '<S16>/TON'
 *    '<S17>/TON'
 */
void J920_fric_TON(boolean_T rtu_IN, real32_T rtu_PT, B_TON_J920_fric *localB,
                   DW_TON_J920_fric *localDW, struct fFricIMEP* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2_jy;
  boolean_T rtb_RelationalOperator_m;

  /* Logic: '<S20>/Logical Operator2' */
  rtb_LogicalOperator2_jy = !rtu_IN;

  /* DiscreteIntegrator: '<S20>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_jy || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S20>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S20>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_m = (localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Logic: '<S20>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_m && rtu_IN);

  /* Update for DiscreteIntegrator: '<S20>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S29>/Conversion'
   *  Logic: '<S20>/Logical Operator'
   *  Logic: '<S20>/Logical Operator1'
   */
  if (!rtb_LogicalOperator2_jy) {
    localDW->DiscreteTimeIntegrator_DSTATE += (real32_T)
      ((!rtb_RelationalOperator_m) && rtu_IN) * 0.01F;
  }

  if (rtb_LogicalOperator2_jy) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S20>/Discrete-Time Integrator' */
}

/* Model step function */
void J920_fric_step(B_J920_fric *J920_fric_B, DW_J920_fric *J920_fric_DW,
                    ExtY_J920_fric *J920_fric_Y, struct fFricIMEP* inst)
{
  /* local block i/o variables */
  real32_T rtb_LoadStep_TDly;
  real32_T rtb_ExtDist_TDly;
  real32_T rtb_WGM_TDly;
  real32_T rtb_Vltg_TDly;
  real32_T rtb_rPrChP2s_f;
  real32_T rtb_rPos_Set_WG_Norm_g;
  real32_T rtb_T_EO;
  real32_T rtb_WG_Pos[3];
  real32_T rtb_Comp[3];
  real32_T rtb_P2_IP[10];
  real32_T rtb_PMEP_IP[10];
  real32_T rtb_PMEPCC;
  real32_T rtb_WGCC;
  real32_T rtb_TEO[3];
  real32_T rtb_Comp_j[3];
  real32_T rtb_Comp_d[3];
  real32_T rtb_Sig[3];
  real32_T rtb_Add1_e;
  real32_T rtb_DiscreteTimeIntegrator_n1;
  real32_T rtb_DataTypeConversion_o;
  real32_T rtb_Product_g;
  boolean_T rtb_WGM_reset;
  boolean_T rtb_bVltg_reset;
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_RelationalOperator;
  boolean_T rtb_LogicalOperator2_e;
  boolean_T rtb_LogicalOperator2_h;
  boolean_T rtb_LogicalOperator_f;
  boolean_T rtb_LogicalOperator1_k;
  boolean_T rtb_Compare;
  boolean_T rtb_Compare_n;
  boolean_T rtb_Compare_h;
  boolean_T rtb_Compare_p;
  real32_T rtb_rTconst_Power_Filt;
  real32_T rtb_WGM_Tconst;
  real32_T rtb_Vltg_Tconst;
  real32_T rtb_DiscreteTimeIntegrator_c;
  boolean_T rtb_RelationalOperator_b;
  real32_T rtb_DiscreteTimeIntegrator_n;
  real32_T rtb_DiscreteTimeIntegrator_p;
  real32_T rtb_DiscreteTimeIntegrator_b;
  real32_T rtb_DiscreteTimeIntegrator_h;
  real32_T rtb_Switch_p;
  boolean_T rtb_LogicalOperator2_m;
  boolean_T rtb_LogicalOperator2_k;
  boolean_T rtb_RelationalOperator2_e;
  real32_T rtb_omega_sensrads;
  real32_T rtb_omega_dot_sensrads2;
  real_T rtb_Divide1;
  boolean_T rtb_LogicalOperator_l[25];
  real_T rtb_multiply[25];
  uint32_T tmp;
  boolean_T rtb_Switch1;
  boolean_T rtb_Switch3;
  real32_T rtb_Add_k;
  real32_T rtb_Product_f;
  real32_T rtb_DiscreteTimeIntegrator;
  real32_T rtb_Sum1;
  real32_T rtb_Product_fm;
  real32_T rtb_Product1_k;
  real32_T rtb_Sum_j;
  int32_T i;
  real_T u;
  real32_T u_0;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  J920_fric_B->BusInput1 = inst->In;

  /* BusSelector: '<S3>/Bus Selector9' */
  rtb_WGM_reset = J920_fric_B->BusInput1.WGM_reset;
  rtb_bVltg_reset = J920_fric_B->BusInput1.bVltg_reset;

  /* RelationalOperator: '<S28>/Compare' incorporates:
   *  Constant: '<S28>/Constant'
   */
  rtb_Compare = J920_fric_B->BusInput1.bMCBON;

  /* RelationalOperator: '<S27>/Compare' incorporates:
   *  Constant: '<S27>/Constant'
   */
  rtb_Compare_n = !J920_fric_B->BusInput1.bMCBON;

  /* RelationalOperator: '<S24>/Compare' incorporates:
   *  Constant: '<S24>/Constant'
   */
  rtb_Compare_h = J920_fric_B->BusInput1.bGCBON;

  /* RelationalOperator: '<S23>/Compare' incorporates:
   *  Constant: '<S23>/Constant'
   */
  rtb_Compare_p = !J920_fric_B->BusInput1.bGCBON;

  /* Logic: '<S12>/Logical Operator2' incorporates:
   *  Constant: '<S24>/Constant'
   *  Constant: '<S28>/Constant'
   *  Logic: '<S12>/Logical Operator3'
   *  Logic: '<S18>/Logical Operator'
   *  Logic: '<S19>/Logical Operator'
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
  rtb_LogicalOperator2 = !(((int32_T)J920_fric_B->BusInput1.bMCBON > (int32_T)
    J920_fric_DW->DelayInput1_DSTATE) || ((int32_T)rtb_Compare_n > (int32_T)
    J920_fric_DW->DelayInput1_DSTATE_k) || (((int32_T)
    J920_fric_B->BusInput1.bGCBON > (int32_T)J920_fric_DW->DelayInput1_DSTATE_h)
    || ((int32_T)rtb_Compare_p > (int32_T)J920_fric_DW->DelayInput1_DSTATE_c)) ||
                           (J920_fric_B->BusInput1.bExt_dist != 0.0F));

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  J920_fric_B->BusInput = inst->Para;

  /* BusSelector: '<S3>/Bus Selector4' */
  rtb_LoadStep_TDly = J920_fric_B->BusInput.LoadStep_TDly;
  rtb_rTconst_Power_Filt = J920_fric_B->BusInput.rTconst_Power_Filt;
  rtb_ExtDist_TDly = J920_fric_B->BusInput.ExtDist_TDly;
  rtb_WGM_Tconst = J920_fric_B->BusInput.WGM_Tconst;
  rtb_WGM_TDly = J920_fric_B->BusInput.WGM_TDly;
  rtb_Vltg_Tconst = J920_fric_B->BusInput.Vltg_Tconst;
  rtb_Vltg_TDly = J920_fric_B->BusInput.Vltg_TDly;

  /* Outputs for Atomic SubSystem: '<S12>/TON' */
  J920_fric_TON(rtb_LogicalOperator2, rtb_ExtDist_TDly, &J920_fric_B->TON,
                &J920_fric_DW->TON, inst);

  /* End of Outputs for SubSystem: '<S12>/TON' */

  /* RelationalOperator: '<S14>/Relational Operator' incorporates:
   *  Abs: '<S14>/Abs'
   *  Sum: '<S14>/Add2'
   */
  rtb_RelationalOperator = ((real32_T)fabs(J920_fric_B->BusInput1.Speed -
    J920_fric_B->BusInput.rNEngNom) <= J920_fric_B->BusInput.Speedrange);

  /* Outputs for Atomic SubSystem: '<S14>/TON' */
  J920_fric_TON(rtb_RelationalOperator, rtb_LoadStep_TDly, &J920_fric_B->TON_i,
                &J920_fric_DW->TON_i, inst);

  /* End of Outputs for SubSystem: '<S14>/TON' */

  /* DiscreteIntegrator: '<S32>/Discrete-Time Integrator' */
  if (J920_fric_DW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE =
      J920_fric_B->BusInput.rIC_Power_filt;
  }

  rtb_DiscreteTimeIntegrator_c = J920_fric_DW->DiscreteTimeIntegrator_DSTATE;

  /* Saturate: '<S15>/Saturation' incorporates:
   *  DiscreteIntegrator: '<S32>/Discrete-Time Integrator'
   */
  if (J920_fric_DW->DiscreteTimeIntegrator_DSTATE >= 0.0F) {
    rtb_DiscreteTimeIntegrator_n = J920_fric_DW->DiscreteTimeIntegrator_DSTATE;
  } else {
    rtb_DiscreteTimeIntegrator_n = 0.0F;
  }

  /* RelationalOperator: '<S15>/Relational Operator' incorporates:
   *  Saturate: '<S15>/Saturation'
   */
  rtb_RelationalOperator_b = (rtb_DiscreteTimeIntegrator_n >=
    J920_fric_B->BusInput.rPower_Thrsh);

  /* DiscreteIntegrator: '<S42>/Discrete-Time Integrator' */
  if (J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_m != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_a = J920_fric_B->BusInput.WGM_y0;
  }

  if (rtb_WGM_reset || (J920_fric_DW->DiscreteTimeIntegrator_PrevRese != 0)) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_a = J920_fric_B->BusInput.WGM_y0;
  }

  rtb_DiscreteTimeIntegrator_n = J920_fric_DW->DiscreteTimeIntegrator_DSTATE_a;

  /* Logic: '<S17>/Logical Operator2' incorporates:
   *  Abs: '<S17>/Abs'
   *  DiscreteIntegrator: '<S42>/Discrete-Time Integrator'
   *  RelationalOperator: '<S17>/Relational Operator1'
   *  Sum: '<S17>/Add'
   */
  rtb_LogicalOperator2_e = !(J920_fric_B->BusInput.WGM_FaultThrsh <= (real32_T)
    fabs(J920_fric_B->BusInput1.rPos_Set_WG_Norm -
         J920_fric_DW->DiscreteTimeIntegrator_DSTATE_a));

  /* Outputs for Atomic SubSystem: '<S17>/TON' */
  J920_fric_TON(rtb_LogicalOperator2_e, rtb_WGM_TDly, &J920_fric_B->TON_n,
                &J920_fric_DW->TON_n, inst);

  /* End of Outputs for SubSystem: '<S17>/TON' */

  /* DiscreteIntegrator: '<S38>/Discrete-Time Integrator' */
  if (J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_l != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_h =
      J920_fric_B->BusInput.Vltg_y0;
  }

  if (rtb_bVltg_reset || (J920_fric_DW->DiscreteTimeIntegrator_PrevRe_f != 0)) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_h =
      J920_fric_B->BusInput.Vltg_y0;
  }

  rtb_DiscreteTimeIntegrator_p = J920_fric_DW->DiscreteTimeIntegrator_DSTATE_h;

  /* DiscreteIntegrator: '<S39>/Discrete-Time Integrator' */
  if (J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_b != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_f =
      J920_fric_B->BusInput.Vltg_y0;
  }

  if (rtb_bVltg_reset || (J920_fric_DW->DiscreteTimeIntegrator_PrevRe_j != 0)) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_f =
      J920_fric_B->BusInput.Vltg_y0;
  }

  rtb_DiscreteTimeIntegrator_b = J920_fric_DW->DiscreteTimeIntegrator_DSTATE_f;

  /* DiscreteIntegrator: '<S40>/Discrete-Time Integrator' */
  if (J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_e != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_o =
      J920_fric_B->BusInput.Vltg_y0;
  }

  if (rtb_bVltg_reset || (J920_fric_DW->DiscreteTimeIntegrator_PrevRe_p != 0)) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_o =
      J920_fric_B->BusInput.Vltg_y0;
  }

  rtb_DiscreteTimeIntegrator_h = J920_fric_DW->DiscreteTimeIntegrator_DSTATE_o;

  /* Sum: '<S36>/Add' incorporates:
   *  DiscreteIntegrator: '<S40>/Discrete-Time Integrator'
   */
  rtb_Product_g = J920_fric_B->BusInput1.U_L3L1 -
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_o;

  /* Abs: '<S36>/Abs' */
  rtb_Product_g = (real32_T)fabs(rtb_Product_g);

  /* Logic: '<S16>/Logical Operator2' incorporates:
   *  Abs: '<S34>/Abs'
   *  Abs: '<S35>/Abs'
   *  DiscreteIntegrator: '<S38>/Discrete-Time Integrator'
   *  DiscreteIntegrator: '<S39>/Discrete-Time Integrator'
   *  Logic: '<S16>/Logical Operator1'
   *  RelationalOperator: '<S34>/Relational Operator1'
   *  RelationalOperator: '<S35>/Relational Operator1'
   *  RelationalOperator: '<S36>/Relational Operator1'
   *  Sum: '<S34>/Add'
   *  Sum: '<S35>/Add'
   */
  rtb_LogicalOperator2_h = !((J920_fric_B->BusInput.Vltg_FaultThrsh <= (real32_T)
    fabs(J920_fric_B->BusInput1.U_L1L2 -
         J920_fric_DW->DiscreteTimeIntegrator_DSTATE_h)) ||
    (J920_fric_B->BusInput.Vltg_FaultThrsh <= (real32_T)fabs
     (J920_fric_B->BusInput1.U_L2L3 -
      J920_fric_DW->DiscreteTimeIntegrator_DSTATE_f)) ||
    (J920_fric_B->BusInput.Vltg_FaultThrsh <= rtb_Product_g));

  /* Outputs for Atomic SubSystem: '<S16>/TON' */
  J920_fric_TON(rtb_LogicalOperator2_h, rtb_Vltg_TDly, &J920_fric_B->TON_e,
                &J920_fric_DW->TON_e, inst);

  /* End of Outputs for SubSystem: '<S16>/TON' */

  /* Sum: '<S11>/Add1' */
  rtb_Product_g = J920_fric_B->BusInput1.I_L1 - J920_fric_B->BusInput1.I_L2;

  /* Abs: '<S11>/Abs' */
  rtb_Product_g = (real32_T)fabs(rtb_Product_g);

  /* Product: '<S11>/Divide' incorporates:
   *  Constant: '<S11>/Constant'
   *  Sum: '<S11>/Add'
   */
  rtb_Divide1 = (real_T)((J920_fric_B->BusInput1.I_L1 +
    J920_fric_B->BusInput1.I_L2) + J920_fric_B->BusInput1.I_L3) / 9.0;

  /* MinMax: '<S11>/MinMax' */
  if (!(rtb_Divide1 >= 10.0)) {
    rtb_Divide1 = 10.0;
  }

  /* Logic: '<S11>/Logical Operator2' incorporates:
   *  Abs: '<S11>/Abs1'
   *  Logic: '<S11>/Logical Operator'
   *  Logic: '<S11>/Logical Operator1'
   *  MinMax: '<S11>/MinMax'
   *  RelationalOperator: '<S11>/Relational Operator1'
   *  RelationalOperator: '<S11>/Relational Operator2'
   *  Sum: '<S11>/Add2'
   */
  rtb_LogicalOperator2_k = !((((real_T)rtb_Product_g >= rtb_Divide1) || ((real_T)
                               (real32_T)fabs(J920_fric_B->BusInput1.I_L2 -
    J920_fric_B->BusInput1.I_L3) >= rtb_Divide1)) &&
    J920_fric_B->BusInput1.bGCBON);

  /* Sum: '<S13>/Sum of Elements' */
  tmp = (uint32_T)J920_fric_B->BusInput1.bLimpHomeCylG2[0];
  for (i = 0; i < 24; i++) {
    tmp += (uint32_T)J920_fric_B->BusInput1.bLimpHomeCylG2[i + 1];
  }

  /* RelationalOperator: '<S13>/Relational Operator1' incorporates:
   *  Sum: '<S13>/Sum of Elements'
   */
  rtb_LogicalOperator2_m = (18 >= (uint8_T)tmp);

  /* Sum: '<S13>/Sum of Elements1' */
  tmp = (uint32_T)J920_fric_B->BusInput1.bLimpHomeCyl[0];
  for (i = 0; i < 24; i++) {
    tmp += (uint32_T)J920_fric_B->BusInput1.bLimpHomeCyl[i + 1];
  }

  /* RelationalOperator: '<S13>/Relational Operator2' incorporates:
   *  Sum: '<S13>/Sum of Elements1'
   */
  rtb_RelationalOperator2_e = (18 >= (uint8_T)tmp);

  /* Sum: '<S13>/Sum of Elements2' */
  tmp = (uint32_T)J920_fric_B->BusInput1.bLimpHomeCylExt[0];
  for (i = 0; i < 24; i++) {
    tmp += (uint32_T)J920_fric_B->BusInput1.bLimpHomeCylExt[i + 1];
  }

  /* Logic: '<S13>/Logical Operator2' incorporates:
   *  RelationalOperator: '<S13>/Relational Operator3'
   *  Sum: '<S13>/Sum of Elements2'
   */
  rtb_LogicalOperator2_m = (rtb_LogicalOperator2_m && rtb_RelationalOperator2_e &&
                            (18 >= (uint8_T)tmp));

  /* Logic: '<S5>/Logical Operator1' incorporates:
   *  Logic: '<S5>/Logical Operator'
   */
  rtb_RelationalOperator2_e = (J920_fric_B->BusInput1.Man_Cond_On ||
    (J920_fric_B->TON.LogicalOperator3 && J920_fric_B->TON_i.LogicalOperator3 &&
     rtb_RelationalOperator_b && J920_fric_B->TON_n.LogicalOperator3 &&
     J920_fric_B->TON_e.LogicalOperator3 && rtb_LogicalOperator2_k &&
     rtb_LogicalOperator2_m));

  /* Gain: '<S9>/Gain1' */
  rtb_omega_sensrads = 0.104719758F * J920_fric_B->BusInput1.Speed;

  /* DiscreteIntegrator: '<S9>/Filter1' */
  if (J920_fric_DW->Filter1_IC_LOADING != 0) {
    J920_fric_DW->Filter1_DSTATE = J920_fric_B->BusInput.rD0_init;
  }

  if (J920_fric_B->BusInput1.bReset_P_kin) {
    J920_fric_DW->Filter1_DSTATE = J920_fric_B->BusInput.rD0_init;
  }

  /* Product: '<S9>/Filter coefficient N' incorporates:
   *  DiscreteIntegrator: '<S9>/Filter1'
   *  Product: '<S9>/Derivative gain'
   *  Sum: '<S9>/SumD'
   */
  rtb_omega_dot_sensrads2 = (rtb_omega_sensrads * J920_fric_B->BusInput.rD_P_kin
    - J920_fric_DW->Filter1_DSTATE) * J920_fric_B->BusInput.rN_P_kin;

  /* Switch: '<S9>/Switch' incorporates:
   *  Constant: '<S9>/Constant'
   *  Gain: '<S9>/kW//W1'
   *  Logic: '<S9>/Logical Operator'
   *  Logic: '<S9>/Logical Operator1'
   *  Product: '<S9>/Inertia (kgm2)  '
   *  Product: '<S9>/Product1'
   */
  if (!(J920_fric_B->BusInput1.bGCBON && J920_fric_B->BusInput1.bMCBON)) {
    rtb_Switch_p = rtb_omega_dot_sensrads2 * rtb_omega_sensrads *
      J920_fric_B->BusInput.rInertia * 0.001F;
  } else {
    rtb_Switch_p = 0.0F;
  }

  /* End of Switch: '<S9>/Switch' */

  /* Outputs for Atomic SubSystem: '<S47>/Filter' */
  /* DiscreteIntegrator: '<S49>/Discrete-Time Integrator' incorporates:
   *  Delay: '<S7>/Delay'
   */
  if (J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_j != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_e = J920_fric_DW->Delay_DSTATE[0];
  }

  if (J920_fric_DW->DiscreteTimeIntegrator_PrevRe_d != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_e = J920_fric_DW->Delay_DSTATE[0];
  }

  /* Switch: '<S49>/Switch' incorporates:
   *  DiscreteIntegrator: '<S49>/Discrete-Time Integrator'
   */
  rtb_omega_sensrads = J920_fric_DW->DiscreteTimeIntegrator_DSTATE_e;

  /* Update for DiscreteIntegrator: '<S49>/Discrete-Time Integrator' incorporates:
   *  Delay: '<S7>/Delay'
   *  DiscreteIntegrator: '<S49>/Discrete-Time Integrator'
   *  Product: '<S49>/Divide4'
   *  Sum: '<S49>/Sum4'
   */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_j = 0U;
  J920_fric_DW->DiscreteTimeIntegrator_DSTATE_e += (J920_fric_DW->Delay_DSTATE[0]
    - J920_fric_DW->DiscreteTimeIntegrator_DSTATE_e) / 0.2F * 0.01F;
  J920_fric_DW->DiscreteTimeIntegrator_PrevRe_d = 0;

  /* End of Outputs for SubSystem: '<S47>/Filter' */

  /* BusSelector: '<S3>/Bus Selector3' */
  rtb_Product_g = J920_fric_B->BusInput.rP_Nom;

  /* Abs: '<S48>/Abs' */
  rtb_DataTypeConversion_o = (real32_T)fabs(rtb_Product_g);

  /* Switch: '<S48>/Switch' incorporates:
   *  RelationalOperator: '<S48>/Relational Operator'
   */
  if (1.0F >= rtb_DataTypeConversion_o) {
    rtb_Product_g = 1.0F;
  }

  /* End of Switch: '<S48>/Switch' */

  /* Product: '<S47>/Divide' */
  rtb_Product_g = rtb_omega_sensrads / rtb_Product_g;

  /* BusSelector: '<S47>/Bus Selector2' */
  rtb_Comp_d[0] = J920_fric_B->BusInput.PFComp_G_CC.Sig[0];
  rtb_Comp_d[1] = J920_fric_B->BusInput.PFComp_G_CC.Sig[1];
  rtb_Comp_d[2] = J920_fric_B->BusInput.PFComp_G_CC.Sig[2];
  rtb_Sig[0] = J920_fric_B->BusInput.PFComp_G_CC.Comp[0];
  rtb_Sig[1] = J920_fric_B->BusInput.PFComp_G_CC.Comp[1];
  rtb_Sig[2] = J920_fric_B->BusInput.PFComp_G_CC.Comp[2];

  /* Dynamic Look-Up Table Block: '<S47>/PMEP G CC'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_DataTypeConversion_o), rtb_Sig, rtb_Product_g,
    rtb_Comp_d, 2U, inst);

  /* BusSelector: '<S3>/Bus Selector8' */
  rtb_Product_g = J920_fric_B->BusInput1.PF_Act;

  /* BusSelector: '<S47>/Bus Selector1' */
  rtb_Sig[0] = J920_fric_B->BusInput.PFComp_CC.Sig[0];
  rtb_Sig[1] = J920_fric_B->BusInput.PFComp_CC.Sig[1];
  rtb_Sig[2] = J920_fric_B->BusInput.PFComp_CC.Sig[2];
  rtb_Comp_d[0] = J920_fric_B->BusInput.PFComp_CC.Comp[0];
  rtb_Comp_d[1] = J920_fric_B->BusInput.PFComp_CC.Comp[1];
  rtb_Comp_d[2] = J920_fric_B->BusInput.PFComp_CC.Comp[2];

  /* Dynamic Look-Up Table Block: '<S47>/PMEP CC'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Add1_e), rtb_Comp_d, rtb_Product_g, rtb_Sig,
    2U, inst);

  /* Sum: '<S47>/Add1' incorporates:
   *  Product: '<S47>/Product'
   *  Product: '<S47>/Product1'
   */
  rtb_Add1_e = rtb_DataTypeConversion_o * rtb_Add1_e * rtb_omega_sensrads +
    rtb_Switch_p;

  /* Switch: '<S53>/Switch1' incorporates:
   *  Constant: '<S53>/Constant1'
   */
  if (J920_fric_B->BusInput1.rPrChP2s != 0.0F) {
    u = J920_fric_B->BusInput1.rPrChP2s;
  } else {
    u = 10.0;
  }

  /* End of Switch: '<S53>/Switch1' */

  /* Switch: '<S53>/Switch' incorporates:
   *  Constant: '<S53>/Constant'
   */
  if (J920_fric_B->BusInput.IMEPVali_Fac != 0.0F) {
    rtb_Divide1 = J920_fric_B->BusInput.IMEPVali_Fac;
  } else {
    rtb_Divide1 = 8.0;
  }

  /* End of Switch: '<S53>/Switch' */

  /* Product: '<S53>/m' */
  rtb_Divide1 *= u;
  for (i = 0; i < 25; i++) {
    /* Logic: '<S8>/Logical Operator' incorporates:
     *  Logic: '<S8>/Logical Operator1'
     *  Logic: '<S8>/Logical Operator2'
     *  RelationalOperator: '<S53>/Relational Operator'
     */
    rtb_Switch1 = !(((real_T)J920_fric_B->BusInput1.rPrIMEP[i] > rtb_Divide1) ||
                    J920_fric_B->BusInput1.bPBCSensErr[i] ||
                    (J920_fric_B->BusInput1.bLimpHomeCylG2[i] ||
                     J920_fric_B->BusInput1.bLimpHomeCyl[i] ||
                     J920_fric_B->BusInput1.bLimpHomeCylExt[i]));

    /* Switch: '<S54>/Switch' incorporates:
     *  Constant: '<S54>/Constant1'
     *  Constant: '<S54>/Constant2'
     *  Constant: '<S56>/Constant'
     *  RelationalOperator: '<S56>/Compare'
     */
    if (J920_fric_B->BusInput1.rPrIMEP[i] < 1.0F) {
      u = -0.2;
    } else {
      u = 0.0;
    }

    /* End of Switch: '<S54>/Switch' */

    /* Product: '<S8>/multiply' incorporates:
     *  Sum: '<S54>/Add'
     */
    rtb_multiply[i] = rtb_Switch1 ? (real_T)J920_fric_B->BusInput1.rPrIMEP[i] +
      u : 0.0;

    /* Logic: '<S8>/Logical Operator' */
    rtb_LogicalOperator_l[i] = rtb_Switch1;
  }

  /* Sum: '<S8>/Sum of Elements' */
  rtb_Divide1 = rtb_multiply[0];

  /* Sum: '<S55>/Sum of Elements1' */
  tmp = (uint32_T)rtb_LogicalOperator_l[0];
  for (i = 0; i < 24; i++) {
    /* Sum: '<S8>/Sum of Elements' */
    rtb_Divide1 += rtb_multiply[i + 1];
    tmp += (uint32_T)rtb_LogicalOperator_l[i + 1];
  }

  /* Sum: '<S55>/Add2' incorporates:
   *  Constant: '<S55>/Constant'
   *  Sum: '<S55>/Add1'
   *  Sum: '<S55>/Add3'
   *  Sum: '<S55>/Sum of Elements1'
   */
  u = (25.0 - (25.0 - (real_T)(uint8_T)tmp)) - (25.0 - (real_T)
    J920_fric_B->BusInput.NumberOfCylinder);

  /* Saturate: '<S55>/Saturation' */
  if (!(u >= 1.0)) {
    u = 1.0;
  }

  /* Product: '<S8>/Divide1' incorporates:
   *  Saturate: '<S55>/Saturation'
   */
  rtb_Divide1 /= u;

  /* DataTypeConversion: '<S8>/Data Type Conversion' */
  rtb_DataTypeConversion_o = (real32_T)rtb_Divide1;

  /* BusSelector: '<S3>/Bus Selector7' */
  rtb_rPrChP2s_f = J920_fric_B->BusInput1.rPrChP2s;
  rtb_rPos_Set_WG_Norm_g = J920_fric_B->BusInput1.rPos_Set_WG_Norm;

  /* Outputs for Atomic SubSystem: '<S3>/PMEP' */
  /* BusSelector: '<S10>/Bus Selector' */
  rtb_WG_Pos[0] = J920_fric_B->BusInput.WGComp_CC.WG_Pos[0];
  rtb_WG_Pos[1] = J920_fric_B->BusInput.WGComp_CC.WG_Pos[1];
  rtb_WG_Pos[2] = J920_fric_B->BusInput.WGComp_CC.WG_Pos[2];
  rtb_Comp[0] = J920_fric_B->BusInput.WGComp_CC.Comp[0];
  rtb_Comp[1] = J920_fric_B->BusInput.WGComp_CC.Comp[1];
  rtb_Comp[2] = J920_fric_B->BusInput.WGComp_CC.Comp[2];

  /* BusSelector: '<S10>/Bus Selector1' */
  for (i = 0; i < 10; i++) {
    rtb_P2_IP[i] = J920_fric_B->BusInput.PMEP_CC.P2_IP[i];
    rtb_PMEP_IP[i] = J920_fric_B->BusInput.PMEP_CC.PMEP_IP[i];
  }

  /* End of BusSelector: '<S10>/Bus Selector1' */
  /* Dynamic Look-Up Table Block: '<S10>/PMEP CC'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_PMEPCC), rtb_PMEP_IP, rtb_rPrChP2s_f,
    rtb_P2_IP, 9U, inst);

  /* Dynamic Look-Up Table Block: '<S10>/WG CC'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_WGCC), rtb_Comp, rtb_rPos_Set_WG_Norm_g,
    rtb_WG_Pos, 2U, inst);

  /* Product: '<S10>/Product' */
  rtb_Product_f = rtb_PMEPCC * rtb_WGCC;

  /* End of Outputs for SubSystem: '<S3>/PMEP' */

  /* Product: '<S7>/Product' incorporates:
   *  Gain: '<S7>/Gain'
   *  Gain: '<S7>/bar_to_Kpa'
   *  Sum: '<S7>/Subtract1'
   */
  rtb_Product_g = (rtb_DataTypeConversion_o + rtb_Product_f) * 100.0F *
    J920_fric_B->BusInput.NumberOfCylinder * J920_fric_B->BusInput.rEngine_Vd *
    (0.00833333377F * J920_fric_B->BusInput1.Speed);

  /* Sum: '<S7>/Add' */
  rtb_Add_k = rtb_Product_g - rtb_Add1_e;

  /* BusSelector: '<S3>/Bus Selector11' */
  rtb_T_EO = J920_fric_B->BusInput1.T_EO;

  /* BusSelector: '<S3>/Bus Selector5' */
  rtb_omega_sensrads = J920_fric_B->BusInput.rTconst_fricflt_slowfilt;

  /* Outputs for Atomic SubSystem: '<S3>/Fault Detection' */
  /* BusSelector: '<S6>/Bus Selector' */
  rtb_TEO[0] = J920_fric_B->BusInput.TEOComp_CC.TEO[0];
  rtb_TEO[1] = J920_fric_B->BusInput.TEOComp_CC.TEO[1];
  rtb_TEO[2] = J920_fric_B->BusInput.TEOComp_CC.TEO[2];
  rtb_Comp_j[0] = J920_fric_B->BusInput.TEOComp_CC.Comp[0];
  rtb_Comp_j[1] = J920_fric_B->BusInput.TEOComp_CC.Comp[1];
  rtb_Comp_j[2] = J920_fric_B->BusInput.TEOComp_CC.Comp[2];

  /* MATLAB Function: '<S6>/movAvg J920' incorporates:
   *  DataTypeConversion: '<S6>/Data Type Conversion'
   */
  /* MATLAB Function 'IMEP_Based_Fric_Detection/Fault Detection/movAvg J920': '<S46>:1' */
  /*  base 240 --> 20 engine cycle --> 2.4 sec. */
  /* '<S46>:1:10' */
  rtb_Divide1 = J920_fric_DW->y_1 * 359.0 / 360.0 + (real_T)rtb_Add_k / 360.0;

  /* '<S46>:1:11' */
  J920_fric_DW->y_1 = rtb_Divide1;

  /* Logic: '<S6>/Logical Operator' */
  rtb_LogicalOperator_f = !rtb_RelationalOperator2_e;

  /* DiscreteIntegrator: '<S44>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S6>/Data Type Conversion1'
   */
  if (J920_fric_DW->DiscreteTimeIntegrator_IC_LO_el != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_g = (real32_T)rtb_Divide1;
  }

  if (rtb_LogicalOperator_f || (J920_fric_DW->DiscreteTimeIntegrator_PrevRe_k !=
       0)) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_g = (real32_T)rtb_Divide1;
  }

  rtb_DiscreteTimeIntegrator = J920_fric_DW->DiscreteTimeIntegrator_DSTATE_g;

  /* Sum: '<S44>/Sum1' incorporates:
   *  DiscreteIntegrator: '<S44>/Discrete-Time Integrator'
   */
  rtb_Sum1 = rtb_Add_k - J920_fric_DW->DiscreteTimeIntegrator_DSTATE_g;

  /* End of Outputs for SubSystem: '<S3>/Fault Detection' */

  /* BusSelector: '<S3>/Bus Selector5' */
  u_0 = J920_fric_B->BusInput.rTconst_fricflt_fastfilt;

  /* Outputs for Atomic SubSystem: '<S3>/Fault Detection' */
  /* Logic: '<S6>/Logical Operator1' */
  rtb_LogicalOperator1_k = !rtb_RelationalOperator2_e;

  /* Dynamic Look-Up Table Block: '<S6>/TEO CC'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_DiscreteTimeIntegrator_n1), rtb_Comp_j,
    rtb_T_EO, rtb_TEO, 2U, inst);

  /* Product: '<S6>/Product' */
  rtb_Product_fm = rtb_DiscreteTimeIntegrator_n1 *
    J920_fric_B->BusInput.Diff_Thrsh;

  /* Product: '<S6>/Product1' */
  rtb_Product1_k = rtb_DiscreteTimeIntegrator_n1 *
    J920_fric_B->BusInput.Abs_Thrsh;

  /* DiscreteIntegrator: '<S45>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S6>/Data Type Conversion1'
   */
  if (J920_fric_DW->DiscreteTimeIntegrator_IC_LO_jk != 0) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_p = (real32_T)rtb_Divide1;
  }

  if (rtb_LogicalOperator1_k || (J920_fric_DW->DiscreteTimeIntegrator_PrevR_dw
       != 0)) {
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_p = (real32_T)rtb_Divide1;
  }

  rtb_DiscreteTimeIntegrator_n1 = J920_fric_DW->DiscreteTimeIntegrator_DSTATE_p;

  /* End of DiscreteIntegrator: '<S45>/Discrete-Time Integrator' */

  /* Sum: '<S6>/Sum' */
  rtb_Sum_j = rtb_DiscreteTimeIntegrator - rtb_DiscreteTimeIntegrator_n1;

  /* Switch: '<S6>/Switch1' incorporates:
   *  Constant: '<S6>/3'
   *  Constant: '<S6>/6'
   *  RelationalOperator: '<S6>/Relational Operator1'
   *  RelationalOperator: '<S6>/Relational Operator2'
   *  Switch: '<S6>/Switch3'
   */
  if (rtb_RelationalOperator2_e) {
    rtb_Switch1 = (rtb_Product1_k <= rtb_DiscreteTimeIntegrator);
    rtb_Switch3 = (rtb_Product_fm <= rtb_Sum_j);
  } else {
    rtb_Switch1 = FALSE;
    rtb_Switch3 = FALSE;
  }

  /* End of Switch: '<S6>/Switch1' */

  /* Update for DiscreteIntegrator: '<S44>/Discrete-Time Integrator' incorporates:
   *  Product: '<S44>/Divide'
   */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LO_el = 0U;
  if (!rtb_LogicalOperator_f) {
    /* Saturate: '<S44>/Saturation' */
    if (!(u_0 >= 1.0F)) {
      u_0 = 1.0F;
    }

    /* End of Saturate: '<S44>/Saturation' */
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_g += rtb_Sum1 / u_0 * 0.01F;
  }

  if (rtb_LogicalOperator_f) {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRe_k = 1;
  } else {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRe_k = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S44>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S45>/Discrete-Time Integrator' incorporates:
   *  Product: '<S45>/Divide'
   *  Saturate: '<S45>/Saturation'
   *  Sum: '<S45>/Sum1'
   */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LO_jk = 0U;
  if (!rtb_LogicalOperator1_k) {
    /* Saturate: '<S45>/Saturation' */
    if (!(rtb_omega_sensrads >= 1.0F)) {
      rtb_omega_sensrads = 1.0F;
    }

    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_p += (rtb_Add_k -
      rtb_DiscreteTimeIntegrator_n1) / rtb_omega_sensrads * 0.01F;
  }

  if (rtb_LogicalOperator1_k) {
    J920_fric_DW->DiscreteTimeIntegrator_PrevR_dw = 1;
  } else {
    J920_fric_DW->DiscreteTimeIntegrator_PrevR_dw = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S45>/Discrete-Time Integrator' */
  /* End of Outputs for SubSystem: '<S3>/Fault Detection' */

  /* BusCreator: '<S3>/Bus Creator1' */
  J920_fric_Y->OUT.Fault_Abs = rtb_Switch1;
  J920_fric_Y->OUT.Fault_Diff = rtb_Switch3;

  /* Product: '<S7>/Product1' */
  rtb_omega_sensrads = J920_fric_B->BusInput.NumberOfCylinder *
    J920_fric_B->BusInput.rEngine_Vd * J920_fric_B->BusInput1.Speed;

  /* Saturate: '<S7>/Saturation' */
  if (!(rtb_omega_sensrads >= 1.0F)) {
    rtb_omega_sensrads = 1.0F;
  }

  /* End of Saturate: '<S7>/Saturation' */

  /* BusCreator: '<S3>/Bus Creator' incorporates:
   *  Gain: '<S7>/Gain1'
   *  Gain: '<S7>/Gain2'
   *  Gain: '<S7>/Gain3'
   *  Gain: '<S7>/Gain4'
   *  Product: '<S7>/Divide'
   *  Product: '<S7>/Divide1'
   *  SignalConversion: '<S3>/TmpSignal ConversionAtBus CreatorInport16'
   *  SignalConversion: '<S3>/TmpSignal ConversionAtBus CreatorInport5'
   *  SignalConversion: '<S3>/TmpSignal ConversionAtBus CreatorInport6'
   */
  J920_fric_Y->dbg.Pfric = rtb_Add_k;
  J920_fric_Y->dbg.P_kin = rtb_Switch_p;
  J920_fric_Y->dbg.omega_dot = rtb_omega_dot_sensrads2;
  J920_fric_Y->dbg.Power = rtb_DiscreteTimeIntegrator_c;
  J920_fric_Y->dbg.FD_Param_Diff[0] = rtb_Sum_j;
  J920_fric_Y->dbg.FD_Param_Diff[1] = rtb_Product_fm;
  J920_fric_Y->dbg.FD_Param_Abs[0] = rtb_DiscreteTimeIntegrator;
  J920_fric_Y->dbg.FD_Param_Abs[1] = rtb_Product1_k;
  J920_fric_Y->dbg.BMEP = 1.0F / rtb_omega_sensrads * (120.0F * rtb_Add1_e) *
    0.01F;
  J920_fric_Y->dbg.PMEP = rtb_Product_f;
  J920_fric_Y->dbg.IMEP_avg = rtb_DataTypeConversion_o;
  J920_fric_Y->dbg.Pmech = rtb_Add1_e;
  J920_fric_Y->dbg.Condition_ON = rtb_RelationalOperator2_e;
  J920_fric_Y->dbg.Pind = rtb_Product_g;
  J920_fric_Y->dbg.FMEP = 120.0F * rtb_Add_k / rtb_omega_sensrads * 0.01F;
  J920_fric_Y->dbg.Pact = J920_fric_B->BusInput1.Pact;
  J920_fric_Y->dbg.Speed = J920_fric_B->BusInput1.Speed;
  J920_fric_Y->dbg.Condition_dbg[0] = J920_fric_B->TON.LogicalOperator3;
  J920_fric_Y->dbg.Condition_dbg[1] = J920_fric_B->TON_i.LogicalOperator3;
  J920_fric_Y->dbg.Condition_dbg[2] = rtb_RelationalOperator_b;
  J920_fric_Y->dbg.Condition_dbg[3] = J920_fric_B->TON_n.LogicalOperator3;
  J920_fric_Y->dbg.Condition_dbg[4] = J920_fric_B->TON_e.LogicalOperator3;
  J920_fric_Y->dbg.Condition_dbg[5] = rtb_LogicalOperator2_k;
  J920_fric_Y->dbg.Condition_dbg[6] = rtb_LogicalOperator2_m;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Out = J920_fric_Y->OUT;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->dbgOut = J920_fric_Y->dbg;

  /* Sum: '<S32>/Sum' */
  rtb_Switch_p = J920_fric_B->BusInput1.Pact - rtb_DiscreteTimeIntegrator_c;

  /* Sum: '<S38>/Sum' */
  rtb_Product_fm = J920_fric_B->BusInput1.U_L1L2 - rtb_DiscreteTimeIntegrator_p;

  /* Sum: '<S39>/Sum' */
  rtb_Add_k = J920_fric_B->BusInput1.U_L2L3 - rtb_DiscreteTimeIntegrator_b;

  /* Sum: '<S40>/Sum' */
  rtb_Product_f = J920_fric_B->BusInput1.U_L3L1 - rtb_DiscreteTimeIntegrator_h;

  /* Sum: '<S42>/Sum' */
  rtb_Sum1 = J920_fric_B->BusInput1.rPos_Set_WG_Norm -
    rtb_DiscreteTimeIntegrator_n;

  /* UnitDelay: '<S4>/Unit Delay' */
  J920_fric_B->UnitDelay = J920_fric_DW->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output8' */
  inst->Info = J920_fric_B->UnitDelay;

  /* Update for UnitDelay: '<S26>/Delay Input1' */
  J920_fric_DW->DelayInput1_DSTATE = rtb_Compare;

  /* Update for UnitDelay: '<S25>/Delay Input1' */
  J920_fric_DW->DelayInput1_DSTATE_k = rtb_Compare_n;

  /* Update for UnitDelay: '<S22>/Delay Input1' */
  J920_fric_DW->DelayInput1_DSTATE_h = rtb_Compare_h;

  /* Update for UnitDelay: '<S21>/Delay Input1' */
  J920_fric_DW->DelayInput1_DSTATE_c = rtb_Compare_p;

  /* Update for DiscreteIntegrator: '<S32>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Saturate: '<S32>/Saturation' */
  if (!(rtb_rTconst_Power_Filt >= 1.0F)) {
    rtb_rTconst_Power_Filt = 1.0F;
  }

  /* End of Saturate: '<S32>/Saturation' */

  /* Update for DiscreteIntegrator: '<S32>/Discrete-Time Integrator' incorporates:
   *  Product: '<S32>/Divide'
   */
  J920_fric_DW->DiscreteTimeIntegrator_DSTATE += rtb_Switch_p /
    rtb_rTconst_Power_Filt * 0.01F;

  /* Update for DiscreteIntegrator: '<S42>/Discrete-Time Integrator' incorporates:
   *  Product: '<S42>/Divide'
   */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_m = 0U;
  if (!rtb_WGM_reset) {
    /* Saturate: '<S42>/Saturation' */
    if (!(rtb_WGM_Tconst >= 0.01F)) {
      rtb_WGM_Tconst = 0.01F;
    }

    /* End of Saturate: '<S42>/Saturation' */
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_a += rtb_Sum1 / rtb_WGM_Tconst *
      0.01F;
  }

  if (rtb_WGM_reset) {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S42>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S38>/Discrete-Time Integrator' incorporates:
   *  Product: '<S38>/Divide'
   */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_l = 0U;
  if (!rtb_bVltg_reset) {
    /* Saturate: '<S38>/Saturation' */
    if (rtb_Vltg_Tconst >= 0.01F) {
      rtb_DiscreteTimeIntegrator_n = rtb_Vltg_Tconst;
    } else {
      rtb_DiscreteTimeIntegrator_n = 0.01F;
    }

    /* End of Saturate: '<S38>/Saturation' */
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_h += rtb_Product_fm /
      rtb_DiscreteTimeIntegrator_n * 0.01F;
  }

  if (rtb_bVltg_reset) {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRe_f = 1;
  } else {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRe_f = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S38>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S39>/Discrete-Time Integrator' incorporates:
   *  Product: '<S39>/Divide'
   */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_b = 0U;
  if (!rtb_bVltg_reset) {
    /* Saturate: '<S39>/Saturation' */
    if (rtb_Vltg_Tconst >= 0.01F) {
      rtb_DiscreteTimeIntegrator_n = rtb_Vltg_Tconst;
    } else {
      rtb_DiscreteTimeIntegrator_n = 0.01F;
    }

    /* End of Saturate: '<S39>/Saturation' */
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_f += rtb_Add_k /
      rtb_DiscreteTimeIntegrator_n * 0.01F;
  }

  if (rtb_bVltg_reset) {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRe_j = 1;
  } else {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRe_j = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S39>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S40>/Discrete-Time Integrator' incorporates:
   *  Product: '<S40>/Divide'
   */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_e = 0U;
  if (!rtb_bVltg_reset) {
    /* Saturate: '<S40>/Saturation' */
    if (!(rtb_Vltg_Tconst >= 0.01F)) {
      rtb_Vltg_Tconst = 0.01F;
    }

    /* End of Saturate: '<S40>/Saturation' */
    J920_fric_DW->DiscreteTimeIntegrator_DSTATE_o += rtb_Product_f /
      rtb_Vltg_Tconst * 0.01F;
  }

  if (rtb_bVltg_reset) {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRe_p = 1;
  } else {
    J920_fric_DW->DiscreteTimeIntegrator_PrevRe_p = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S40>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S9>/Filter1' */
  J920_fric_DW->Filter1_IC_LOADING = 0U;
  J920_fric_DW->Filter1_DSTATE += 0.01F * rtb_omega_dot_sensrads2;

  /* Update for Delay: '<S7>/Delay' */
  J920_fric_DW->Delay_DSTATE[0] = J920_fric_DW->Delay_DSTATE[1];
  J920_fric_DW->Delay_DSTATE[1] = J920_fric_B->BusInput1.Pact;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  J920_fric_DW->UnitDelay_DSTATE = 71U;
}

/* Model initialize function */
void J920_fric_initialize(DW_J920_fric *J920_fric_DW, struct fFricIMEP* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S32>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S42>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_m = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S38>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_l = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S39>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_b = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S40>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_e = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S9>/Filter1' */
  J920_fric_DW->Filter1_IC_LOADING = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S47>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S49>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LOA_j = 1U;

  /* End of InitializeConditions for SubSystem: '<S47>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S3>/Fault Detection' */
  /* InitializeConditions for DiscreteIntegrator: '<S44>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LO_el = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S45>/Discrete-Time Integrator' */
  J920_fric_DW->DiscreteTimeIntegrator_IC_LO_jk = 1U;

  /* End of InitializeConditions for SubSystem: '<S3>/Fault Detection' */
}

/* Model terminate function */
void J920_fric_terminate(struct fFricIMEP* inst)
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
