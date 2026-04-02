/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SCRT_ss
 * File: SCRT_ss.c
 * Author: 105055527
 * Last modified by: arnolge00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Fri Oct 01 08:40:23 2021
 * Model Version: 1.00
 * Description: Steady state detection for SCR inlet temperature controller vie ignition timing

   Outstandings:
   -------------
   - NA
 * modified Comment: V1.00  01.10.2021, Arnold, created
 ********************************************************************
 * Implementation of program SCRT_ss
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.0
 * (ERT based)
 ********************************************************************/

#include "SCRT_ss.h"
#include "SCRT_ss_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void SCRT_ss_step(RT_MODEL_SCRT_ss *const SCRT_ss_M, struct fSCRT_ss* inst)
{
  struct BlockIO_SCRT_ss *SCRT_ss_B = ((struct BlockIO_SCRT_ss *) SCRT_ss_M->blockIO);
  struct D_Work_SCRT_ss *SCRT_ss_DWork = ((struct D_Work_SCRT_ss *) SCRT_ss_M->dwork);
  ExternalOutputs_SCRT_ss *SCRT_ss_Y = (ExternalOutputs_SCRT_ss *)
    SCRT_ss_M->outputs;
  real32_T rtb_Switch_n;
  boolean_T rtb_LogicalOperator3;
  boolean_T rtb_LogicalOperator_f2;
  boolean_T rtb_LogicalOperator_m;
  boolean_T rtb_RelationalOperator;
  boolean_T rtb_LogicalOperator;
  boolean_T rtb_LogicalOperator2;
  real32_T tmp;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  SCRT_ss_B->BusInput2 = inst->In;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  SCRT_ss_B->BusInput1 = inst->Perm;

  /* Outputs for Atomic SubSystem: '<S4>/Filter' */
  /* RelationalOperator: '<S5>/Relational Operator' incorporates:
   *  Constant: '<S5>/Constant'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_LogicalOperator_f2 = (SCRT_ss_B->BusInput1.rTi_Filt_LXdev > 0.0F);

  /* End of Outputs for SubSystem: '<S4>/Filter' */

  /* Logic: '<S4>/NOT' incorporates:
   *  Logic: '<S4>/NOT1'
   *  Switch: '<S1>/Environment Switch'
   */
  rtb_LogicalOperator = !SCRT_ss_B->BusInput2.bEna;

  /* Outputs for Atomic SubSystem: '<S4>/Filter' */
  /* Logic: '<S5>/Logical Operator' incorporates:
   *  Logic: '<S4>/NOT'
   *  Logic: '<S5>/Logical Operator1'
   */
  rtb_LogicalOperator_m = (rtb_LogicalOperator || (!rtb_LogicalOperator_f2));

  /* DiscreteIntegrator: '<S5>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator_m || (SCRT_ss_DWork->DiscreteTimeIntegrator_PrevRe_c
       != 0)) {
    SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_f = 0.0F;
  }

  /* Switch: '<S5>/Switch' incorporates:
   *  DiscreteIntegrator: '<S5>/Discrete-Time Integrator'
   *  Switch: '<S1>/Environment Switch'
   */
  if (rtb_LogicalOperator_f2) {
    rtb_Switch_n = SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_f;
  } else {
    rtb_Switch_n = SCRT_ss_B->BusInput2.rPr_Leanox_Dev;
  }

  /* End of Switch: '<S5>/Switch' */

  /* Switch: '<S8>/Switch' incorporates:
   *  Abs: '<S8>/Abs'
   *  RelationalOperator: '<S8>/Relational Operator'
   *  Switch: '<S2>/Environment Switch'
   */
  if (2.22044605E-16F >= (real32_T)fabs(SCRT_ss_B->BusInput1.rTi_Filt_LXdev)) {
    tmp = 2.22044605E-16F;
  } else {
    tmp = SCRT_ss_B->BusInput1.rTi_Filt_LXdev;
  }

  /* End of Switch: '<S8>/Switch' */

  /* Update for DiscreteIntegrator: '<S5>/Discrete-Time Integrator' incorporates:
   *  Product: '<S5>/Divide4'
   *  Sum: '<S5>/Sum4'
   *  Switch: '<S1>/Environment Switch'
   */
  SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_f +=
    (SCRT_ss_B->BusInput2.rPr_Leanox_Dev -
     SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_f) / tmp * 0.01F;
  SCRT_ss_DWork->DiscreteTimeIntegrator_PrevRe_c = (int8_T)rtb_LogicalOperator_m;

  /* End of Outputs for SubSystem: '<S4>/Filter' */

  /* RelationalOperator: '<S4>/Relational Operator' incorporates:
   *  Abs: '<S4>/Abs'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_LogicalOperator_m = ((real32_T)fabs(rtb_Switch_n) <=
    SCRT_ss_B->BusInput1.rThreshold_LXdev_ss);

  /* Outputs for Atomic SubSystem: '<S4>/Filter1' */
  /* RelationalOperator: '<S6>/Relational Operator' incorporates:
   *  Constant: '<S6>/Constant'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_LogicalOperator_f2 = (SCRT_ss_B->BusInput1.rTi_Filt_Pset > 0.0F);

  /* Logic: '<S6>/Logical Operator' incorporates:
   *  Logic: '<S6>/Logical Operator1'
   */
  rtb_LogicalOperator = (rtb_LogicalOperator || (!rtb_LogicalOperator_f2));

  /* DiscreteIntegrator: '<S6>/Discrete-Time Integrator' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  if (SCRT_ss_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_e =
      SCRT_ss_B->BusInput2.rP_Set_Norm;
  }

  if (rtb_LogicalOperator || (SCRT_ss_DWork->DiscreteTimeIntegrator_PrevRe_g !=
       0)) {
    SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_e =
      SCRT_ss_B->BusInput2.rP_Set_Norm;
  }

  /* Switch: '<S6>/Switch' incorporates:
   *  DiscreteIntegrator: '<S6>/Discrete-Time Integrator'
   *  Switch: '<S1>/Environment Switch'
   */
  if (rtb_LogicalOperator_f2) {
    rtb_Switch_n = SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_e;
  } else {
    rtb_Switch_n = SCRT_ss_B->BusInput2.rP_Set_Norm;
  }

  /* End of Switch: '<S6>/Switch' */

  /* Update for DiscreteIntegrator: '<S6>/Discrete-Time Integrator' */
  SCRT_ss_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Switch: '<S10>/Switch' incorporates:
   *  Abs: '<S10>/Abs'
   *  RelationalOperator: '<S10>/Relational Operator'
   *  Switch: '<S2>/Environment Switch'
   */
  if (2.22044605E-16F >= (real32_T)fabs(SCRT_ss_B->BusInput1.rTi_Filt_Pset)) {
    tmp = 2.22044605E-16F;
  } else {
    tmp = SCRT_ss_B->BusInput1.rTi_Filt_Pset;
  }

  /* End of Switch: '<S10>/Switch' */

  /* Update for DiscreteIntegrator: '<S6>/Discrete-Time Integrator' incorporates:
   *  Product: '<S6>/Divide4'
   *  Sum: '<S6>/Sum4'
   *  Switch: '<S1>/Environment Switch'
   */
  SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_e +=
    (SCRT_ss_B->BusInput2.rP_Set_Norm -
     SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE_e) / tmp * 0.01F;
  SCRT_ss_DWork->DiscreteTimeIntegrator_PrevRe_g = (int8_T)rtb_LogicalOperator;

  /* End of Outputs for SubSystem: '<S4>/Filter1' */

  /* RelationalOperator: '<S4>/Relational Operator1' incorporates:
   *  Abs: '<S4>/Abs1'
   *  Sum: '<S4>/Sum'
   *  Switch: '<S1>/Environment Switch'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_LogicalOperator_f2 = ((real32_T)fabs(rtb_Switch_n -
    SCRT_ss_B->BusInput2.rP_Set_Norm) <= SCRT_ss_B->BusInput1.rThreshold_Pset_ss);

  /* Logic: '<S4>/AND' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  rtb_LogicalOperator = (rtb_LogicalOperator_m && rtb_LogicalOperator_f2 &&
    SCRT_ss_B->BusInput2.bEna);

  /* Outputs for Atomic SubSystem: '<S4>/TON' */
  /* Logic: '<S7>/Logical Operator2' */
  rtb_LogicalOperator2 = !rtb_LogicalOperator;

  /* DiscreteIntegrator: '<S7>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2 || (SCRT_ss_DWork->DiscreteTimeIntegrator_PrevRese !=
       0)) {
    SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S7>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S7>/Discrete-Time Integrator'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_RelationalOperator = (SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE >=
    SCRT_ss_B->BusInput1.rTi_Delay_ss);

  /* Logic: '<S7>/Logical Operator3' */
  rtb_LogicalOperator3 = (rtb_RelationalOperator && rtb_LogicalOperator);

  /* Update for DiscreteIntegrator: '<S7>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S12>/Conversion'
   *  Logic: '<S7>/Logical Operator'
   *  Logic: '<S7>/Logical Operator1'
   */
  SCRT_ss_DWork->DiscreteTimeIntegrator_DSTATE += (real32_T)
    ((!rtb_RelationalOperator) && rtb_LogicalOperator) * 0.01F;
  SCRT_ss_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator2;

  /* End of Outputs for SubSystem: '<S4>/TON' */

  /* Outport: '<Root>/Out' incorporates:
   *  BusCreator generated from: '<Root>/Out'
   */
  SCRT_ss_Y->Out.bSCRT_ss = rtb_LogicalOperator3;

  /* Outport: '<Root>/dbg' incorporates:
   *  BusCreator generated from: '<Root>/dbg'
   */
  SCRT_ss_Y->dbg.bss_LXdev = rtb_LogicalOperator_m;
  SCRT_ss_Y->dbg.bss_P = rtb_LogicalOperator_f2;
  SCRT_ss_Y->dbg.bss_noDelay = rtb_LogicalOperator;

  /* BusCreator generated from: '<Root>/Bus Output' */
  SCRT_ss_B->BusConversion_InsertedFor_BusOu.bSCRT_ss = rtb_LogicalOperator3;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Out = SCRT_ss_B->BusConversion_InsertedFor_BusOu;

  /* BusCreator generated from: '<Root>/Bus Output1' */
  SCRT_ss_B->BusConversion_InsertedFor_Bus_d.bss_LXdev = rtb_LogicalOperator_m;
  SCRT_ss_B->BusConversion_InsertedFor_Bus_d.bss_P = rtb_LogicalOperator_f2;
  SCRT_ss_B->BusConversion_InsertedFor_Bus_d.bss_noDelay = rtb_LogicalOperator;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Dbg = SCRT_ss_B->BusConversion_InsertedFor_Bus_d;

  /* UnitDelay: '<S3>/Unit Delay' */
  SCRT_ss_B->UnitDelay = SCRT_ss_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->Version = SCRT_ss_B->UnitDelay;

  /* Update for UnitDelay: '<S3>/Unit Delay' */
  SCRT_ss_DWork->UnitDelay_DSTATE = 100U;
}

/* Model initialize function */
void SCRT_ss_initialize(RT_MODEL_SCRT_ss *const SCRT_ss_M, struct fSCRT_ss* inst)
{
  struct D_Work_SCRT_ss *SCRT_ss_DWork = ((struct D_Work_SCRT_ss *) SCRT_ss_M->dwork);

  /* SystemInitialize for Atomic SubSystem: '<S4>/Filter1' */
  /* InitializeConditions for DiscreteIntegrator: '<S6>/Discrete-Time Integrator' */
  SCRT_ss_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* End of SystemInitialize for SubSystem: '<S4>/Filter1' */
}

/* Model terminate function */
void SCRT_ss_terminate(RT_MODEL_SCRT_ss *const SCRT_ss_M, struct fSCRT_ss* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(SCRT_ss_M);
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
