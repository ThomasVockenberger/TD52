/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: IP_EGTCtr
 * File: IP_EGTCtr.c
 * Author: 302013638
 * Created: Fri Sep 10 20:20:48 2010
 ********************************************************************
 * Implementation of program IP_EGTCtr
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "IP_EGTCtr.h"
#include "IP_EGTCtr_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */
struct BlockIO_IP_EGTCtr IP_EGTCtr_B;

/* Block states (auto storage) */
struct D_Work_IP_EGTCtr IP_EGTCtr_DWork;

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void IP_EGTCtr_step(struct fIP_EGTCtr* inst)
{
  /* local block i/o variables */
  boolean_T rtb_bReset;
  real32_T rtb_e;
  real32_T rtb_up;
  real32_T rtb_ud;
  real32_T rtb_Product2;
  real32_T rtb_Add;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  IP_EGTCtr_B.in = inst->in;

  /* BusSelector: '<Root>/BusConversion_InsertedFor_Bus Creator1_at_inport_1' */
  rtb_bReset = IP_EGTCtr_B.in.bReset;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  IP_EGTCtr_B.perm = inst->perm;

  /* Gain: '<S3>/Gain' incorporates:
   *  Sum: '<S3>/Add4'
   *  Sum: '<S3>/Add6'
   */
  rtb_e = -((IP_EGTCtr_B.in.rT_EG_MaxLim - IP_EGTCtr_B.perm.rT_EG_DltLim) -
            IP_EGTCtr_B.in.rT_EG_Max);

  /* Product: '<S3>/Product1' */
  rtb_up = rtb_e * IP_EGTCtr_B.perm.Kp;

  /* DiscreteIntegrator: '<S3>/Discrete-Time Integrator' */
  if (IP_EGTCtr_DWork.DiscreteTimeIntegrator_IC_LOADI != 0) {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator_DSTATE = IP_EGTCtr_B.in.rCA_Init;
  }

  if (rtb_bReset || (IP_EGTCtr_DWork.DiscreteTimeIntegrator_PrevRese != 0)) {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator_DSTATE = IP_EGTCtr_B.in.rCA_Init;
  }

  /* DiscreteIntegrator: '<S3>/Discrete-Time Integrator1' */
  if (rtb_bReset || (IP_EGTCtr_DWork.DiscreteTimeIntegrator1_PrevRes != 0)) {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator1_DSTATE = 0.0F;
  }

  /* Switch: '<S4>/Switch' incorporates:
   *  RelationalOperator: '<S4>/u_GTE_up'
   *  RelationalOperator: '<S4>/u_GT_lo'
   *  Switch: '<S4>/Switch1'
   */
  if (rtb_e >= IP_EGTCtr_B.perm.DeadUpD) {
    rtb_ud = IP_EGTCtr_B.perm.DeadUpD;
  } else if (rtb_e > IP_EGTCtr_B.perm.DeadLoD) {
    /* Switch: '<S4>/Switch1' */
    rtb_ud = rtb_e;
  } else {
    rtb_ud = IP_EGTCtr_B.perm.DeadLoD;
  }

  /* End of Switch: '<S4>/Switch' */

  /* Product: '<S3>/Divide3' incorporates:
   *  DiscreteIntegrator: '<S3>/Discrete-Time Integrator1'
   *  Product: '<S3>/Product3'
   *  Sum: '<S3>/Sum1'
   *  Sum: '<S4>/Diff'
   */
  rtb_ud = ((rtb_e - rtb_ud) * IP_EGTCtr_B.perm.Kd -
            IP_EGTCtr_DWork.DiscreteTimeIntegrator1_DSTATE) * IP_EGTCtr_B.perm.N;

  /* Sum: '<S3>/Add' incorporates:
   *  DiscreteIntegrator: '<S3>/Discrete-Time Integrator'
   */
  rtb_Add = (rtb_up + IP_EGTCtr_DWork.DiscreteTimeIntegrator_DSTATE) + rtb_ud;

  /* Product: '<S3>/Product2' incorporates:
   *  Sum: '<S3>/Add2'
   */
  rtb_Product2 = (rtb_Add - IP_EGTCtr_B.in.rCA_IP_Act_Rel) *
    IP_EGTCtr_B.perm.KAW;

  /* Switch: '<S3>/Switch' incorporates:
   *  RelationalOperator: '<S5>/LowerRelop1'
   *  RelationalOperator: '<S5>/UpperRelop'
   *  Switch: '<S5>/Switch'
   *  Switch: '<S5>/Switch2'
   */
  if (rtb_bReset) {
    /* BusCreator: '<Root>/Bus Creator' incorporates:
     *  Constant: '<S3>/Constant'
     */
    IP_EGTCtr_B.BusCreator.ulim = 0.0F;
  } else if (rtb_Add > IP_EGTCtr_B.perm.UpLim) {
    /* Switch: '<S5>/Switch2' incorporates:
     *  BusCreator: '<Root>/Bus Creator'
     */
    IP_EGTCtr_B.BusCreator.ulim = IP_EGTCtr_B.perm.UpLim;
  } else if (rtb_Add < IP_EGTCtr_B.perm.LoLim) {
    /* Switch: '<S5>/Switch' incorporates:
     *  BusCreator: '<Root>/Bus Creator'
     *  Switch: '<S5>/Switch2'
     */
    IP_EGTCtr_B.BusCreator.ulim = IP_EGTCtr_B.perm.LoLim;
  } else {
    /* BusCreator: '<Root>/Bus Creator' incorporates:
     *  Switch: '<S5>/Switch'
     *  Switch: '<S5>/Switch2'
     */
    IP_EGTCtr_B.BusCreator.ulim = rtb_Add;
  }

  /* End of Switch: '<S3>/Switch' */

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  DiscreteIntegrator: '<S3>/Discrete-Time Integrator'
   */
  IP_EGTCtr_B.BusCreator.u = rtb_Add;
  IP_EGTCtr_B.BusCreator.up = rtb_up;
  IP_EGTCtr_B.BusCreator.ui = IP_EGTCtr_DWork.DiscreteTimeIntegrator_DSTATE;
  IP_EGTCtr_B.BusCreator.ud = rtb_ud;
  IP_EGTCtr_B.BusCreator.e = rtb_e;
  IP_EGTCtr_B.BusCreator.AW = rtb_Product2;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->out = IP_EGTCtr_B.BusCreator;

  /* Product: '<S3>/Product' */
  rtb_e *= IP_EGTCtr_B.perm.Ki;

  /* Update for DiscreteIntegrator: '<S3>/Discrete-Time Integrator' incorporates:
   *  Sum: '<S3>/Add5'
   */
  IP_EGTCtr_DWork.DiscreteTimeIntegrator_IC_LOADI = 0U;
  if (!rtb_bReset) {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator_DSTATE += (rtb_e - rtb_Product2) *
      0.01F;
  }

  if (rtb_bReset) {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S3>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S3>/Discrete-Time Integrator1' */
  if (!rtb_bReset) {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator1_DSTATE += 0.01F * rtb_ud;
  }

  if (rtb_bReset) {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator1_PrevRes = 1;
  } else {
    IP_EGTCtr_DWork.DiscreteTimeIntegrator1_PrevRes = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S3>/Discrete-Time Integrator1' */
}

/* Model initialize function */
void IP_EGTCtr_initialize(struct fIP_EGTCtr* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S3>/Discrete-Time Integrator' */
  IP_EGTCtr_DWork.DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/* Model terminate function */
void IP_EGTCtr_terminate(struct fIP_EGTCtr* inst)
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
