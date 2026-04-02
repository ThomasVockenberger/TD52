/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: LamCtrPBC
 * File: LamCtrPBC.c
 * Author: kafkama00
 * Last modified by: kafkama00
 * Created: Mon Oct 11 17:08:29 2021
 * Last modified: Wed Dec 01 09:46:51 2021
 * Model Version: 1.00
 * Description: Lambda controller for pressure based control engines
 * modified Comment: V0.01 11.10.2021 created for first tests
   V0.02 12.10.2021 added debug signals
   V0.03 17.11.2021 added distortion rejection
   V1.00 01.12.2021 remove distortion rejection, serial release DIA.NE V4.11
 ********************************************************************
 * Implementation of program LamCtrPBC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
 * (ERT based)
 ********************************************************************/

#include "LamCtrPBC.h"
#include "LamCtrPBC_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */
const LamCtrPBC_OUT_Bus LamCtrPBC_rtZLamCtrPBC_OUT_Bus = {
  0.0F                                 /* rLam_ref */
} ;                                    /* LamCtrPBC_OUT_Bus ground */

const LamCtrPBC_DBG_Bus LamCtrPBC_rtZLamCtrPBC_DBG_Bus = {
  0.0F,                                /* e_lam */
  0.0F,                                /* u */
  0.0F,                                /* u_lim */
  0.0F,                                /* up_LamCtr */
  0.0F,                                /* ui_LamCtr */
  0.0F,                                /* uAW_LamCtr */
  0.0F,                                /* u_PT1_smith */
  0.0F,                                /* u_delay_smith */
  0.0F                                 /* fb_smith */
} ;                                    /* LamCtrPBC_DBG_Bus ground */

/*  Declarations  */
const LamCtrPBC_IN_Bus LamCtrPBC_rtZLamCtrPBC_IN_Bus = { 0.0F,/* rLam_Set */
  0.0F,                                /* rLam_PBC */
  false                                /* bReset */
};

const LamCtrPBC_PARA_Bus LamCtrPBC_rtZLamCtrPBC_PARA_Bus = { 0.0F,/* rKp_LamCtr */
  0.0F,                                /* rKi_LamCtr */
  0.0F,                                /* rKAW_LamCtr */
  0.0F,                                /* rulim_LamCtr_up */
  0.0F                                 /* rulim_LamCtr_low */
};

const LamCtrPBC_PERM_Bus LamCtrPBC_rtZLamCtrPBC_PERM_Bus = { 0,/* iTd_smith_LamCtr */
  0.0F                                 /* rTi_smith_LamCtr */
};

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void LamCtrPBC_step(RT_MODEL_LamCtrPBC *const LamCtrPBC_M, struct fLamCtrPBC* inst)
{
  struct BlockIO_LamCtrPBC *LamCtrPBC_B = ((struct BlockIO_LamCtrPBC *) LamCtrPBC_M->blockIO);
  struct D_Work_LamCtrPBC *LamCtrPBC_DWork = ((struct D_Work_LamCtrPBC *) LamCtrPBC_M->dwork);
  struct PrevZCSigStates_LamCtrPBC *LamCtrPBC_PrevZCSigState =
    ((struct PrevZCSigStates_LamCtrPBC *) LamCtrPBC_M->prevZCSigState);
  ExternalOutputs_LamCtrPBC *LamCtrPBC_Y = (ExternalOutputs_LamCtrPBC *)
    LamCtrPBC_M->outputs;
  real32_T rtb_e_lam;
  real32_T rtb_u_delay_smith;
  real32_T rtb_up_LamCtr;
  real32_T rtb_uAW_LamCtr;
  real32_T rtb_u;
  boolean_T rtb_RelationalOperator;
  real32_T rtb_Switch2;
  real32_T rtb_Switch_p;
  real32_T rtb_Switch1;
  real32_T rtb_rLam_ref;
  real32_T rtb_EnvironmentSwitch_o_rLam_PB;
  boolean_T rtb_EnvironmentSwitch_o_bReset;
  real32_T rtb_EnvironmentSwitch_rKi_LamCt;
  boolean_T rtb_LogicalOperator;
  int32_T i;
  int8_T tmp;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  LamCtrPBC_B->BusInput = inst->In;

  /* Switch: '<S1>/Environment Switch' */
  rtb_EnvironmentSwitch_o_rLam_PB = LamCtrPBC_B->BusInput.rLam_PBC;
  rtb_EnvironmentSwitch_o_bReset = LamCtrPBC_B->BusInput.bReset;

  /* Delay: '<Root>/Delay1' incorporates:
   *  DiscreteIntegrator: '<Root>/Discrete-Time Integrator'
   *  Switch: '<S1>/Environment Switch'
   */
  rtb_RelationalOperator = !LamCtrPBC_B->BusInput.bReset;
  if (rtb_RelationalOperator && (LamCtrPBC_PrevZCSigState->Delay1_Reset_ZCE !=
       ZERO_ZCSIG)) {
    LamCtrPBC_DWork->icLoad = 1U;
  }

  LamCtrPBC_PrevZCSigState->Delay1_Reset_ZCE = LamCtrPBC_B->BusInput.bReset;
  if (LamCtrPBC_DWork->icLoad != 0) {
    LamCtrPBC_DWork->Delay1_DSTATE = LamCtrPBC_B->BusInput.rLam_Set;
  }

  /* Sum: '<Root>/Sum' incorporates:
   *  Delay: '<Root>/Delay1'
   *  Switch: '<S1>/Environment Switch'
   */
  rtb_e_lam = LamCtrPBC_B->BusInput.rLam_Set - LamCtrPBC_DWork->Delay1_DSTATE;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  LamCtrPBC_B->BusInput1 = inst->Para;

  /* Switch: '<S2>/Environment Switch' */
  rtb_EnvironmentSwitch_rKi_LamCt = LamCtrPBC_B->BusInput1.rKi_LamCtr;

  /* Product: '<Root>/Product' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_up_LamCtr = LamCtrPBC_B->BusInput1.rKp_LamCtr * rtb_e_lam;

  /* DiscreteIntegrator: '<Root>/Discrete-Time Integrator' */
  if (rtb_RelationalOperator &&
      (LamCtrPBC_DWork->DiscreteTimeIntegrator_PrevRese == 1)) {
    LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* Sum: '<Root>/Sum2' incorporates:
   *  DiscreteIntegrator: '<Root>/Discrete-Time Integrator'
   */
  rtb_u = rtb_up_LamCtr + LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE;

  /* Switch: '<S6>/Switch2' incorporates:
   *  RelationalOperator: '<S6>/LowerRelop1'
   *  RelationalOperator: '<S6>/UpperRelop'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S6>/Switch'
   */
  if (rtb_u > LamCtrPBC_B->BusInput1.rulim_LamCtr_up) {
    rtb_Switch2 = LamCtrPBC_B->BusInput1.rulim_LamCtr_up;
  } else if (rtb_u < LamCtrPBC_B->BusInput1.rulim_LamCtr_low) {
    /* Switch: '<S6>/Switch' */
    rtb_Switch2 = LamCtrPBC_B->BusInput1.rulim_LamCtr_low;
  } else {
    rtb_Switch2 = rtb_u;
  }

  /* End of Switch: '<S6>/Switch2' */

  /* Product: '<Root>/Product2' incorporates:
   *  Sum: '<Root>/Sum5'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_uAW_LamCtr = (rtb_u - rtb_Switch2) * LamCtrPBC_B->BusInput1.rKAW_LamCtr;

  /* Switch: '<Root>/Switch' incorporates:
   *  Sum: '<Root>/Sum3'
   *  Switch: '<S1>/Environment Switch'
   */
  if (LamCtrPBC_B->BusInput.bReset) {
    rtb_rLam_ref = LamCtrPBC_B->BusInput.rLam_Set;
  } else {
    rtb_rLam_ref = LamCtrPBC_B->BusInput.rLam_Set + rtb_Switch2;
  }

  /* End of Switch: '<Root>/Switch' */

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  LamCtrPBC_B->BusInput2 = inst->Perm;

  /* Outputs for Atomic SubSystem: '<Root>/Filter2' */
  /* RelationalOperator: '<S4>/Relational Operator' incorporates:
   *  Constant: '<S4>/Constant'
   *  Switch: '<S3>/Environment Switch'
   */
  rtb_RelationalOperator = (LamCtrPBC_B->BusInput2.rTi_smith_LamCtr > 0.0F);

  /* Logic: '<S4>/Logical Operator' incorporates:
   *  Logic: '<S4>/Logical Operator1'
   *  Switch: '<S1>/Environment Switch'
   */
  rtb_LogicalOperator = (LamCtrPBC_B->BusInput.bReset ||
    (!rtb_RelationalOperator));

  /* DiscreteIntegrator: '<S4>/Discrete-Time Integrator' */
  if (LamCtrPBC_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE_n = rtb_rLam_ref;
  }

  if (rtb_LogicalOperator || (LamCtrPBC_DWork->DiscreteTimeIntegrator_PrevRe_m
       != 0)) {
    LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE_n = rtb_rLam_ref;
  }

  /* Switch: '<S4>/Switch' incorporates:
   *  DiscreteIntegrator: '<S4>/Discrete-Time Integrator'
   */
  if (rtb_RelationalOperator) {
    rtb_Switch_p = LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE_n;
  } else {
    rtb_Switch_p = rtb_rLam_ref;
  }

  /* End of Switch: '<S4>/Switch' */

  /* Update for DiscreteIntegrator: '<S4>/Discrete-Time Integrator' */
  LamCtrPBC_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Switch: '<S7>/Switch' incorporates:
   *  Abs: '<S7>/Abs'
   *  RelationalOperator: '<S7>/Relational Operator'
   *  Switch: '<S3>/Environment Switch'
   */
  if (LamCtrPBC_ConstB.Conversion >= fabsf
      (LamCtrPBC_B->BusInput2.rTi_smith_LamCtr)) {
    rtb_u_delay_smith = LamCtrPBC_ConstB.Conversion;
  } else {
    rtb_u_delay_smith = LamCtrPBC_B->BusInput2.rTi_smith_LamCtr;
  }

  /* End of Switch: '<S7>/Switch' */

  /* Update for DiscreteIntegrator: '<S4>/Discrete-Time Integrator' incorporates:
   *  Product: '<S4>/Divide4'
   *  Sum: '<S4>/Sum4'
   */
  LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE_n += (rtb_rLam_ref -
    LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE_n) / rtb_u_delay_smith *
    0.01F;
  LamCtrPBC_DWork->DiscreteTimeIntegrator_PrevRe_m = (int8_T)rtb_LogicalOperator;

  /* End of Outputs for SubSystem: '<Root>/Filter2' */

  /* Delay: '<Root>/Delay' incorporates:
   *  Switch: '<S3>/Environment Switch'
   */
  if (LamCtrPBC_DWork->icLoad_o != 0) {
    for (i = 0; i < 50; i++) {
      LamCtrPBC_DWork->Delay_DSTATE[i] = rtb_Switch_p;
    }
  }

  if (LamCtrPBC_B->BusInput2.iTd_smith_LamCtr <= 0) {
    rtb_u_delay_smith = rtb_Switch_p;
  } else {
    if (LamCtrPBC_B->BusInput2.iTd_smith_LamCtr > 50) {
      tmp = 50;
    } else {
      tmp = LamCtrPBC_B->BusInput2.iTd_smith_LamCtr;
    }

    rtb_u_delay_smith = LamCtrPBC_DWork->Delay_DSTATE[(int8_T)(50 - tmp)];
  }

  /* End of Delay: '<Root>/Delay' */

  /* Sum: '<Root>/Sum6' */
  rtb_Switch1 = rtb_Switch_p - rtb_u_delay_smith;

  /* Outport: '<Root>/dbg' incorporates:
   *  BusCreator generated from: '<Root>/dbg'
   *  DiscreteIntegrator: '<Root>/Discrete-Time Integrator'
   */
  LamCtrPBC_Y->dbg.e_lam = rtb_e_lam;
  LamCtrPBC_Y->dbg.u = rtb_u;
  LamCtrPBC_Y->dbg.u_lim = rtb_Switch2;
  LamCtrPBC_Y->dbg.up_LamCtr = rtb_up_LamCtr;
  LamCtrPBC_Y->dbg.ui_LamCtr = LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE;
  LamCtrPBC_Y->dbg.uAW_LamCtr = rtb_uAW_LamCtr;
  LamCtrPBC_Y->dbg.u_PT1_smith = rtb_Switch_p;
  LamCtrPBC_Y->dbg.u_delay_smith = rtb_u_delay_smith;
  LamCtrPBC_Y->dbg.fb_smith = rtb_Switch1;

  /* BusCreator generated from: '<Root>/Bus Output1' incorporates:
   *  DiscreteIntegrator: '<Root>/Discrete-Time Integrator'
   */
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.e_lam = rtb_e_lam;
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.u = rtb_u;
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.u_lim = rtb_Switch2;
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.up_LamCtr = rtb_up_LamCtr;
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.ui_LamCtr =
    LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE;
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.uAW_LamCtr = rtb_uAW_LamCtr;
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.u_PT1_smith = rtb_Switch_p;
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.u_delay_smith = rtb_u_delay_smith;
  LamCtrPBC_B->BusConversion_InsertedFor_BusOu.fb_smith = rtb_Switch1;

  /* BusCreator generated from: '<Root>/Bus Output' */
  LamCtrPBC_B->BusConversion_InsertedFor_Bus_b.rLam_ref = rtb_rLam_ref;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Out = LamCtrPBC_B->BusConversion_InsertedFor_Bus_b;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->dbg = LamCtrPBC_B->BusConversion_InsertedFor_BusOu;

  /* UnitDelay: '<S5>/Unit Delay' */
  LamCtrPBC_B->UnitDelay = LamCtrPBC_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Version = LamCtrPBC_B->UnitDelay;

  /* Switch: '<Root>/Switch1' incorporates:
   *  Constant: '<Root>/Constant'
   *  Switch: '<S3>/Environment Switch'
   */
  if (LamCtrPBC_B->BusInput2.iTd_smith_LamCtr <= 0) {
    rtb_Switch1 = 0.0F;
  }

  /* End of Switch: '<Root>/Switch1' */

  /* Outport: '<Root>/Out' incorporates:
   *  BusCreator generated from: '<Root>/Out'
   */
  LamCtrPBC_Y->Out.rLam_ref = rtb_rLam_ref;

  /* Update for Delay: '<Root>/Delay1' incorporates:
   *  Sum: '<Root>/Sum1'
   */
  LamCtrPBC_DWork->icLoad = 0U;
  LamCtrPBC_DWork->Delay1_DSTATE = rtb_EnvironmentSwitch_o_rLam_PB + rtb_Switch1;

  /* Update for DiscreteIntegrator: '<Root>/Discrete-Time Integrator' incorporates:
   *  Product: '<Root>/Product1'
   *  Sum: '<Root>/Sum4'
   */
  LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE += (rtb_e_lam *
    rtb_EnvironmentSwitch_rKi_LamCt - rtb_uAW_LamCtr) * 0.01F;
  LamCtrPBC_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)
    rtb_EnvironmentSwitch_o_bReset;

  /* Update for Delay: '<Root>/Delay' */
  LamCtrPBC_DWork->icLoad_o = 0U;
  for (i = 0; i < 49; i++) {
    LamCtrPBC_DWork->Delay_DSTATE[i] = LamCtrPBC_DWork->Delay_DSTATE[i + 1];
  }

  LamCtrPBC_DWork->Delay_DSTATE[49] = rtb_Switch_p;

  /* End of Update for Delay: '<Root>/Delay' */

  /* Update for UnitDelay: '<S5>/Unit Delay' */
  LamCtrPBC_DWork->UnitDelay_DSTATE = LamCtrPBC_ConstB.DataTypeConversion3;
}

/* Model initialize function */
void LamCtrPBC_initialize(RT_MODEL_LamCtrPBC *const LamCtrPBC_M, struct fLamCtrPBC* inst)
{
  struct D_Work_LamCtrPBC *LamCtrPBC_DWork = ((struct D_Work_LamCtrPBC *) LamCtrPBC_M->dwork);
  struct PrevZCSigStates_LamCtrPBC *LamCtrPBC_PrevZCSigState =
    ((struct PrevZCSigStates_LamCtrPBC *) LamCtrPBC_M->prevZCSigState);
  struct BlockIO_LamCtrPBC *LamCtrPBC_B = ((struct BlockIO_LamCtrPBC *) LamCtrPBC_M->blockIO);
  ExternalInputs_LamCtrPBC *LamCtrPBC_U = (ExternalInputs_LamCtrPBC *)
    LamCtrPBC_M->inputs;
  ExternalOutputs_LamCtrPBC *LamCtrPBC_Y = (ExternalOutputs_LamCtrPBC *)
    LamCtrPBC_M->outputs;

  /* Registration code */

  /* block I/O */
  (void) memset(((void *) LamCtrPBC_B), 0,
                sizeof(struct BlockIO_LamCtrPBC));

  {
    LamCtrPBC_B->BusConversion_InsertedFor_BusOu =
      LamCtrPBC_rtZLamCtrPBC_DBG_Bus;
    LamCtrPBC_B->BusInput1 = LamCtrPBC_rtZLamCtrPBC_PARA_Bus;
    LamCtrPBC_B->BusInput = LamCtrPBC_rtZLamCtrPBC_IN_Bus;
    LamCtrPBC_B->BusInput2 = LamCtrPBC_rtZLamCtrPBC_PERM_Bus;
    LamCtrPBC_B->BusConversion_InsertedFor_Bus_b =
      LamCtrPBC_rtZLamCtrPBC_OUT_Bus;
  }

  /* states (dwork) */
  (void) memset((void *)LamCtrPBC_DWork, 0,
                sizeof(struct D_Work_LamCtrPBC));
  LamCtrPBC_DWork->Delay1_DSTATE = 0.0F;
  LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE = 0.0F;

  {
    int32_T i;
    for (i = 0; i < 50; i++) {
      LamCtrPBC_DWork->Delay_DSTATE[i] = 0.0F;
    }
  }

  LamCtrPBC_DWork->DiscreteTimeIntegrator_DSTATE_n = 0.0F;

  /* external inputs */
  LamCtrPBC_U->In = LamCtrPBC_rtZLamCtrPBC_IN_Bus;
  LamCtrPBC_U->Para = LamCtrPBC_rtZLamCtrPBC_PARA_Bus;
  LamCtrPBC_U->Perm = LamCtrPBC_rtZLamCtrPBC_PERM_Bus;

  /* external outputs */
  LamCtrPBC_Y->Out = LamCtrPBC_rtZLamCtrPBC_OUT_Bus;
  LamCtrPBC_Y->dbg = LamCtrPBC_rtZLamCtrPBC_DBG_Bus;
  LamCtrPBC_PrevZCSigState->Delay1_Reset_ZCE = ZERO_ZCSIG;

  /* InitializeConditions for Delay: '<Root>/Delay1' */
  LamCtrPBC_DWork->icLoad = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<Root>/Discrete-Time Integrator' */
  LamCtrPBC_DWork->DiscreteTimeIntegrator_PrevRese = 2;

  /* InitializeConditions for Delay: '<Root>/Delay' */
  LamCtrPBC_DWork->icLoad_o = 1U;

  /* SystemInitialize for Atomic SubSystem: '<Root>/Filter2' */
  /* InitializeConditions for DiscreteIntegrator: '<S4>/Discrete-Time Integrator' */
  LamCtrPBC_DWork->DiscreteTimeIntegrator_PrevRe_m = 0;
  LamCtrPBC_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* End of SystemInitialize for SubSystem: '<Root>/Filter2' */
}

/* Model terminate function */
void LamCtrPBC_terminate(RT_MODEL_LamCtrPBC *const LamCtrPBC_M, struct fLamCtrPBC* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(LamCtrPBC_M);
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
