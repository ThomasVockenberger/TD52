/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: MeNoiAL
 * File: MeNoiAL.c
 * Author: 120011115
 * Created: Mon Sep 05 16:14:57 2016
 ********************************************************************
 * Implementation of program MeNoiAL
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "MeNoiAL.h"
#include "MeNoiAL_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void MeNoiAL_step(struct BlockIO_MeNoiAL *MeNoiAL_B, struct D_Work_MeNoiAL *MeNoiAL_DWork,
                  ExternalOutputs_MeNoiAL *MeNoiAL_Y, struct fMeNoiAL* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator;
  real32_T rtb_rFiltTau_MeNoi;
  real32_T rtb_rMargTExh_Active;
  real32_T rtb_rFenst2LiMn;
  real32_T rtb_Switch4;
  real32_T rtb_Divide;
  uint16_T rtb_Divide1[25];
  real32_T rtb_Switch;
  real32_T rtb_Switch3;
  real32_T rtb_Switch5;
  boolean_T rtb_y[25];
  real32_T rtb_Switch2_h[25];
  int32_T i;
  uint8_T rtb_SumofElements1;
  uint32_T tmp;
  boolean_T rtb_RelationalOperator_m;
  real32_T rtb_SumofElements_k;
  real32_T DiscreteTimeIntegrator[25];
  int32_T i_0;
  int32_T i_1;
  int16_T e_data[25];
  int16_T tmp_data[25];
  boolean_T rtb_LowerRelop;
  real32_T DiscreteTimeIntegrator_0;
  int32_T i_2;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  MeNoiAL_B->BusInput1 = inst->Para;

  /* BusSelector: '<Root>/Bus Selector6' */
  rtb_rFiltTau_MeNoi = MeNoiAL_B->BusInput1.rFiltTau_MeNoi;
  rtb_rMargTExh_Active = MeNoiAL_B->BusInput1.rMargTExh_Active;
  rtb_rFenst2LiMn = MeNoiAL_B->BusInput1.rFenst2LiMn;

  /* Switch: '<S7>/Switch4' incorporates:
   *  BusSelector: '<Root>/Bus Selector6'
   *  Constant: '<S7>/Constant4'
   */
  if (MeNoiAL_B->BusInput1.rFenst2LiMx != 0.0F) {
    /* Saturate: '<S7>/Saturation4' */
    if (MeNoiAL_B->BusInput1.rFenst2LiMx >= 16000.0F) {
      rtb_Switch4 = 16000.0F;
    } else if (MeNoiAL_B->BusInput1.rFenst2LiMx <= 0.0F) {
      rtb_Switch4 = 0.0F;
    } else {
      rtb_Switch4 = MeNoiAL_B->BusInput1.rFenst2LiMx;
    }

    /* End of Saturate: '<S7>/Saturation4' */
  } else {
    rtb_Switch4 = 2000.0F;
  }

  /* End of Switch: '<S7>/Switch4' */

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  MeNoiAL_B->BusInput = inst->In;

  /* Switch: '<S7>/Switch5' incorporates:
   *  Constant: '<S7>/Constant5'
   */
  if (rtb_rFenst2LiMn != 0.0F) {
    /* Saturate: '<S7>/Saturation5' */
    if (rtb_rFenst2LiMn >= 16000.0F) {
      rtb_Switch5 = 16000.0F;
    } else if (rtb_rFenst2LiMn <= 0.0F) {
      rtb_Switch5 = 0.0F;
    } else {
      rtb_Switch5 = rtb_rFenst2LiMn;
    }

    /* End of Saturate: '<S7>/Saturation5' */
  } else {
    rtb_Switch5 = 30.0F;
  }

  /* End of Switch: '<S7>/Switch5' */

  /* Switch: '<S7>/Switch' incorporates:
   *  Constant: '<S7>/Constant'
   */
  if (rtb_rFiltTau_MeNoi != 0.0F) {
    /* Saturate: '<S7>/Saturation' */
    if (rtb_rFiltTau_MeNoi >= 50.0F) {
      rtb_Switch = 50.0F;
    } else if (rtb_rFiltTau_MeNoi <= 0.0F) {
      rtb_Switch = 0.0F;
    } else {
      rtb_Switch = rtb_rFiltTau_MeNoi;
    }

    /* End of Saturate: '<S7>/Saturation' */
  } else {
    rtb_Switch = 5.0F;
  }

  /* End of Switch: '<S7>/Switch' */

  /* Product: '<S7>/Divide' incorporates:
   *  Constant: '<S7>/Constant2'
   */
  rtb_Divide = rtb_Switch4 / 3.5F;

  /* Switch: '<S7>/Switch3' incorporates:
   *  Constant: '<S7>/Constant3'
   */
  if (rtb_rMargTExh_Active != 0.0F) {
    /* Saturate: '<S7>/Saturation3' */
    if (rtb_rMargTExh_Active >= 1.0F) {
      rtb_Switch3 = 1.0F;
    } else if (rtb_rMargTExh_Active <= 0.0F) {
      rtb_Switch3 = 0.0F;
    } else {
      rtb_Switch3 = rtb_rMargTExh_Active;
    }

    /* End of Saturate: '<S7>/Saturation3' */
  } else {
    rtb_Switch3 = 0.15F;
  }

  /* End of Switch: '<S7>/Switch3' */

  /* Outputs for Atomic SubSystem: '<Root>/Fenst2_Average_Min_Max' */
  /* MATLAB Function: '<S4>/MATLAB Function1' */
  /* MATLAB Function 'Fenst2_Average_Min_Max/MATLAB Function1': '<S9>:1' */
  /* '<S9>:1:3' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    rtb_y[i_0] = FALSE;
  }

  i_2 = (int32_T)((uint32_T)MeNoiAL_B->BusInput.ucNumCyl + 1U);
  if ((uint32_T)i_2 > 255U) {
    i_2 = 255;
  }

  if (2 > (uint8_T)i_2) {
    i = 1;
    i_2 = 0;
  } else {
    i = 2;
    i_2 = (uint8_T)i_2;
  }

  i_0 = i_2 - i;
  for (i_1 = 0; i_1 <= i_0; i_1++) {
    tmp_data[i_1] = (int16_T)(i + i_1);
  }

  i_0 = (i_2 - i) + 1;
  for (i_2 = 0; i_2 < i_0; i_2++) {
    for (i = 0; i < 1; i++) {
      e_data[i_2] = tmp_data[i_2];
    }
  }

  /* '<S9>:1:4' */
  for (i_2 = 0; i_2 < i_0; i_2++) {
    rtb_y[e_data[i_2] - 1] = TRUE;
  }

  /* output */
  /* '<S9>:1:7' */
  for (i_2 = 0; i_2 < 25; i_2++) {
    /* Logic: '<S4>/Logical Operator' incorporates:
     *  Logic: '<S4>/Logical Operator2'
     *  Product: '<S4>/Divide1'
     */
    rtb_RelationalOperator_m = (rtb_y[i_2] && (!MeNoiAL_B->
      BusInput.bKnockSig[i_2]));

    /* Product: '<S4>/Divide1' incorporates:
     *  DataTypeConversion: '<S4>/Data Type Conversion5'
     */
    rtb_Divide1[i_2] = (uint16_T)(rtb_RelationalOperator_m ?
      MeNoiAL_B->BusInput.uFenst2[i_2] : 0);

    /* Logic: '<S4>/Logical Operator' */
    rtb_y[i_2] = rtb_RelationalOperator_m;
  }

  /* End of MATLAB Function: '<S4>/MATLAB Function1' */

  /* Sum: '<S4>/Sum of Elements1' */
  tmp = (uint32_T)rtb_y[0];
  for (i_2 = 0; i_2 < 24; i_2++) {
    tmp += (uint32_T)rtb_y[i_2 + 1];
  }

  rtb_SumofElements1 = (uint8_T)tmp;

  /* End of Sum: '<S4>/Sum of Elements1' */

  /* Switch: '<S4>/Switch' incorporates:
   *  Constant: '<S4>/Constant2'
   *  DataTypeConversion: '<S4>/Data Type Conversion4'
   *  Product: '<S4>/Divide'
   */
  if (rtb_SumofElements1 != 0) {
    /* Sum: '<S4>/Sum of Elements' */
    rtb_SumofElements_k = (real32_T)rtb_Divide1[0];
    for (i_2 = 0; i_2 < 24; i_2++) {
      rtb_SumofElements_k += (real32_T)rtb_Divide1[i_2 + 1];
    }

    /* End of Sum: '<S4>/Sum of Elements' */

    /* Switch: '<S8>/Switch' incorporates:
     *  RelationalOperator: '<S8>/Relational Operator'
     */
    if (1 >= rtb_SumofElements1) {
      rtb_SumofElements1 = 1U;
    }

    /* End of Switch: '<S8>/Switch' */
    rtb_rFiltTau_MeNoi = rtb_SumofElements_k / (real32_T)rtb_SumofElements1;
  } else {
    rtb_rFiltTau_MeNoi = 0.0F;
  }

  /* End of Switch: '<S4>/Switch' */

  /* MinMax: '<S4>/MinMax1' */
  rtb_rMargTExh_Active = (real32_T)rtb_Divide1[0];
  for (i = 0; i < 24; i++) {
    if (!(rtb_rMargTExh_Active >= (real32_T)rtb_Divide1[i + 1])) {
      rtb_rMargTExh_Active = (real32_T)rtb_Divide1[i + 1];
    }
  }

  /* Switch: '<S4>/Switch2' incorporates:
   *  Constant: '<S4>/Constant3'
   */
  for (i_0 = 0; i_0 < 25; i_0++) {
    if (rtb_y[i_0]) {
      rtb_Switch2_h[i_0] = (real32_T)rtb_Divide1[i_0];
    } else {
      rtb_Switch2_h[i_0] = 65535.0F;
    }
  }

  /* End of Switch: '<S4>/Switch2' */

  /* MinMax: '<S4>/MinMax' */
  rtb_SumofElements_k = rtb_Switch2_h[0];
  for (i = 0; i < 24; i++) {
    if (!(rtb_SumofElements_k <= rtb_Switch2_h[i + 1])) {
      rtb_SumofElements_k = rtb_Switch2_h[i + 1];
    }
  }

  /* End of Outputs for SubSystem: '<Root>/Fenst2_Average_Min_Max' */

  /* Outputs for Atomic SubSystem: '<Root>/Mechanical Noise Adaptive Limit' */
  /* DataTypeConversion: '<S6>/Data Type Conversion1' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    rtb_Switch2_h[i_0] = (real32_T)MeNoiAL_B->BusInput.uFenst2[i_0];
  }

  /* End of DataTypeConversion: '<S6>/Data Type Conversion1' */

  /* Outputs for Atomic SubSystem: '<S6>/Backward Euler PT1' */
  /* Switch: '<S15>/Switch' incorporates:
   *  Abs: '<S15>/Abs'
   *  RelationalOperator: '<S15>/Relational Operator'
   */
  if (2.22044605E-16F >= rtb_Switch) {
    rtb_rFenst2LiMn = 2.22044605E-16F;
  } else {
    rtb_rFenst2LiMn = rtb_Switch;
  }

  /* End of Switch: '<S15>/Switch' */

  /* RelationalOperator: '<S11>/Relational Operator' incorporates:
   *  Constant: '<S11>/Constant'
   */
  rtb_RelationalOperator_m = (rtb_Switch > 0.0F);

  /* Logic: '<S11>/Logical Operator' incorporates:
   *  Logic: '<S11>/Logical Operator1'
   */
  rtb_LogicalOperator = !rtb_RelationalOperator_m;

  /* DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  if (MeNoiAL_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    for (i_0 = 0; i_0 < 25; i_0++) {
      MeNoiAL_DWork->DiscreteTimeIntegrator_DSTATE[i_0] = rtb_Switch2_h[i_0];
    }
  }

  /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  MeNoiAL_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;
  for (i_0 = 0; i_0 < 25; i_0++) {
    /* DiscreteIntegrator: '<S11>/Discrete-Time Integrator' incorporates:
     *  Delay: '<S11>/Delay'
     *  Product: '<S11>/Divide4'
     *  Sum: '<S11>/Sum4'
     */
    if (rtb_LogicalOperator || (MeNoiAL_DWork->DiscreteTimeIntegrator_PrevRese
         != 0)) {
      MeNoiAL_DWork->DiscreteTimeIntegrator_DSTATE[i_0] = rtb_Switch2_h[i_0];
    }

    DiscreteTimeIntegrator_0 = (rtb_Switch2_h[i_0] - MeNoiAL_DWork->
      Delay_DSTATE[i_0]) / rtb_rFenst2LiMn * 0.01F +
      MeNoiAL_DWork->DiscreteTimeIntegrator_DSTATE[i_0];

    /* Update for Delay: '<S11>/Delay' */
    MeNoiAL_DWork->Delay_DSTATE[i_0] = DiscreteTimeIntegrator_0;

    /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
    MeNoiAL_DWork->DiscreteTimeIntegrator_DSTATE[i_0] = DiscreteTimeIntegrator_0;

    /* Sum: '<S6>/Add2' incorporates:
     *  Constant: '<S6>/Constant3'
     *  Product: '<S6>/Product1'
     *  Switch: '<S11>/Switch'
     */
    if (!rtb_RelationalOperator_m) {
      DiscreteTimeIntegrator_0 = rtb_Switch2_h[i_0];
    }

    DiscreteTimeIntegrator_0 = DiscreteTimeIntegrator_0 * 1.1F + rtb_Divide;

    /* End of Sum: '<S6>/Add2' */

    /* RelationalOperator: '<S13>/LowerRelop1' */
    rtb_LowerRelop = (DiscreteTimeIntegrator_0 > rtb_Switch4);

    /* Switch: '<S13>/Switch' incorporates:
     *  RelationalOperator: '<S13>/UpperRelop'
     */
    if (DiscreteTimeIntegrator_0 < rtb_Switch5) {
      DiscreteTimeIntegrator_0 = rtb_Switch5;
    }

    /* End of Switch: '<S13>/Switch' */

    /* Switch: '<S13>/Switch2' */
    if (rtb_LowerRelop) {
      DiscreteTimeIntegrator_0 = rtb_Switch4;
    }

    /* End of Switch: '<S13>/Switch2' */

    /* Product: '<S6>/Divide2' */
    DiscreteTimeIntegrator_0 = rtb_y[i_0] ? DiscreteTimeIntegrator_0 : 0.0F;
    DiscreteTimeIntegrator[i_0] = DiscreteTimeIntegrator_0;
  }

  /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator) {
    MeNoiAL_DWork->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    MeNoiAL_DWork->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Outputs for SubSystem: '<S6>/Backward Euler PT1' */

  /* Sum: '<S6>/Sum of Elements1' */
  tmp = (uint32_T)rtb_y[0];
  for (i_2 = 0; i_2 < 24; i_2++) {
    tmp += (uint32_T)rtb_y[i_2 + 1];
  }

  rtb_SumofElements1 = (uint8_T)tmp;

  /* End of Sum: '<S6>/Sum of Elements1' */

  /* Switch: '<S6>/Switch' incorporates:
   *  Constant: '<S6>/Constant2'
   *  DataTypeConversion: '<S6>/Data Type Conversion6'
   *  Product: '<S6>/Divide'
   */
  if (rtb_SumofElements1 != 0) {
    /* Sum: '<S6>/Sum of Elements' */
    rtb_rFenst2LiMn = DiscreteTimeIntegrator[0];
    for (i_2 = 0; i_2 < 24; i_2++) {
      rtb_rFenst2LiMn += DiscreteTimeIntegrator[i_2 + 1];
    }

    /* End of Sum: '<S6>/Sum of Elements' */

    /* Switch: '<S12>/Switch' incorporates:
     *  Constant: '<S12>/Constant2'
     *  RelationalOperator: '<S12>/Relational Operator'
     */
    if (1 >= rtb_SumofElements1) {
      i_2 = 1;
    } else {
      i_2 = rtb_SumofElements1;
    }

    /* End of Switch: '<S12>/Switch' */
    rtb_rFenst2LiMn /= (real32_T)i_2;
  } else {
    rtb_rFenst2LiMn = 0.0F;
  }

  /* End of Switch: '<S6>/Switch' */

  /* Sum: '<S6>/Add1' incorporates:
   *  Product: '<S6>/Product2'
   */
  rtb_rFenst2LiMn += rtb_Switch4 * rtb_Switch3;

  /* Switch: '<S14>/Switch2' incorporates:
   *  RelationalOperator: '<S14>/LowerRelop1'
   *  RelationalOperator: '<S14>/UpperRelop'
   *  Switch: '<S14>/Switch'
   */
  if (rtb_rFenst2LiMn > rtb_Switch4) {
    rtb_rFenst2LiMn = rtb_Switch4;
  } else {
    if (rtb_rFenst2LiMn < rtb_Switch5) {
      /* Switch: '<S14>/Switch' */
      rtb_rFenst2LiMn = rtb_Switch5;
    }
  }

  /* End of Switch: '<S14>/Switch2' */
  /* End of Outputs for SubSystem: '<Root>/Mechanical Noise Adaptive Limit' */

  /* Outputs for Atomic SubSystem: '<Root>/Fenst2 Thresh Alarm' */
  /* Switch: '<S3>/Switch' incorporates:
   *  Product: '<S3>/Product'
   */
  if (MeNoiAL_B->BusInput1.bMeNoi_Active) {
    for (i_0 = 0; i_0 < 25; i_0++) {
      rtb_Switch2_h[i_0] = DiscreteTimeIntegrator[i_0];
    }
  } else {
    for (i_0 = 0; i_0 < 25; i_0++) {
      rtb_Switch2_h[i_0] = rtb_Switch4 * MeNoiAL_ConstB.DataTypeConversion[i_0];
    }
  }

  for (i_0 = 0; i_0 < 25; i_0++) {
    /* RelationalOperator: '<S3>/Relational Operator' */
    rtb_LowerRelop = ((real32_T)rtb_Divide1[i_0] > rtb_Switch2_h[i_0]);

    /* Switch: '<S3>/Switch1' incorporates:
     *  Constant: '<S3>/Constant'
     *  Constant: '<S3>/Constant1'
     *  Delay: '<S3>/Delay'
     *  Sum: '<S3>/Sum'
     */
    if (rtb_LowerRelop) {
      rtb_SumofElements1 = (uint8_T)((uint32_T)MeNoiAL_DWork->Delay_DSTATE_c[i_0]
        + 1U);
    } else {
      rtb_SumofElements1 = 0U;
    }

    /* End of Switch: '<S3>/Switch1' */

    /* Logic: '<S3>/ 1' incorporates:
     *  Constant: '<S3>/Constant2'
     *  RelationalOperator: '<S3>/Relational Operator1'
     */
    rtb_RelationalOperator_m = ((rtb_SumofElements1 > 150) &&
      MeNoiAL_B->BusInput.bGCB_On_TC2_Di);

    /* Switch: '<S3>/Switch2' incorporates:
     *  Constant: '<S3>/Constant3'
     */
    if (rtb_RelationalOperator_m) {
      rtb_SumofElements1 = 150U;
    }

    /* End of Switch: '<S3>/Switch2' */

    /* Update for Delay: '<S3>/Delay' */
    MeNoiAL_DWork->Delay_DSTATE_c[i_0] = rtb_SumofElements1;

    /* BusCreator: '<Root>/Bus Creator' incorporates:
     *  Logic: '<S3>/ '
     *  Logic: '<S3>/ 2'
     *  Logic: '<S3>/Logical Operator'
     *  RelationalOperator: '<S3>/Relational Operator2'
     */
    MeNoiAL_Y->Out_MeNoiAL.bTExh_Mon_UseNarrowWindow[i_0] =
      ((MeNoiAL_B->BusInput1.bMeNoi_Active && rtb_LowerRelop) ||
       (MeNoiAL_B->BusInput1.bMeNoi_Active && (DiscreteTimeIntegrator[i_0] >
         rtb_rFenst2LiMn)));
    MeNoiAL_Y->Out_MeNoiAL.bValve[i_0] = rtb_RelationalOperator_m;

    /* BusCreator: '<Root>/Bus Creator1' */
    MeNoiAL_Y->Dbg_MeNoiAL.uMeNoi_Cnt[i_0] = rtb_SumofElements1;
    MeNoiAL_Y->Dbg_MeNoiAL.rFenst2_Vect[i_0] = (real32_T)rtb_Divide1[i_0];
    MeNoiAL_Y->Dbg_MeNoiAL.bValidCyl[i_0] = rtb_y[i_0];
  }

  /* End of Switch: '<S3>/Switch' */
  /* End of Outputs for SubSystem: '<Root>/Fenst2 Thresh Alarm' */

  /* Outputs for Atomic SubSystem: '<Root>/Fenst2_Average_Min_Max' */
  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  DataTypeConversion: '<S4>/Data Type Conversion1'
   *  DataTypeConversion: '<S4>/Data Type Conversion2'
   *  DataTypeConversion: '<S4>/Data Type Conversion3'
   *  MinMax: '<S4>/MinMax'
   *  MinMax: '<S4>/MinMax1'
   */
  MeNoiAL_Y->Out_MeNoiAL.uFenst2_Av = (uint16_T)(real32_T)fmod((real32_T)floor
    (rtb_rFiltTau_MeNoi), 65536.0F);
  MeNoiAL_Y->Out_MeNoiAL.uFenst2_Mx = (uint16_T)(int32_T)(real32_T)fmod
    (rtb_rMargTExh_Active, 65536.0F);
  MeNoiAL_Y->Out_MeNoiAL.uFenst2_Mn = (uint16_T)(int32_T)(real32_T)fmod
    (rtb_SumofElements_k, 65536.0F);

  /* End of Outputs for SubSystem: '<Root>/Fenst2_Average_Min_Max' */

  /* BusCreator: '<Root>/Bus Creator1' */
  MeNoiAL_Y->Dbg_MeNoiAL.rFiltTau_Lim = rtb_Switch;
  MeNoiAL_Y->Dbg_MeNoiAL.rFiltGain_Lim = 0.0F;
  MeNoiAL_Y->Dbg_MeNoiAL.rMargTexhAct_Lim = rtb_Switch3;
  MeNoiAL_Y->Dbg_MeNoiAL.rOffMeNoi_Lim = rtb_Divide;
  MeNoiAL_Y->Dbg_MeNoiAL.rFenst2LiMx_Lim = rtb_Switch4;
  MeNoiAL_Y->Dbg_MeNoiAL.rFenst2LiMn_Lim = rtb_Switch5;
  for (i_0 = 0; i_0 < 25; i_0++) {
    MeNoiAL_Y->Dbg_MeNoiAL.uAdapLim_MeNoi_Cyl[i_0] = DiscreteTimeIntegrator[i_0];
  }

  MeNoiAL_Y->Dbg_MeNoiAL.uAdapLim_Marg = rtb_rFenst2LiMn;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Out = MeNoiAL_Y->Out_MeNoiAL;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Dbg = MeNoiAL_Y->Dbg_MeNoiAL;

  /* UnitDelay: '<S5>/Unit Delay' */
  MeNoiAL_B->UnitDelay = MeNoiAL_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Version = MeNoiAL_B->UnitDelay;

  /* Update for UnitDelay: '<S5>/Unit Delay' */
  MeNoiAL_DWork->UnitDelay_DSTATE = 103U;
}

/* Model initialize function */
void MeNoiAL_initialize(struct D_Work_MeNoiAL *MeNoiAL_DWork, struct fMeNoiAL* inst)
{
  /* InitializeConditions for Atomic SubSystem: '<Root>/Mechanical Noise Adaptive Limit' */
  /* InitializeConditions for Atomic SubSystem: '<S6>/Backward Euler PT1' */
  /* InitializeConditions for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  MeNoiAL_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* End of InitializeConditions for SubSystem: '<S6>/Backward Euler PT1' */
  /* End of InitializeConditions for SubSystem: '<Root>/Mechanical Noise Adaptive Limit' */
}

/* Model terminate function */
void MeNoiAL_terminate(struct fMeNoiAL* inst)
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
