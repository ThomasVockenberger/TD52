/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_SS_Cust
 * File: AC_SS_Cust.c
 * Author: 105055527
 * Created: Thu May 19 13:50:06 2016
 ********************************************************************
 * Implementation of program AC_SS_Cust
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V5.0
 * (ERT based)
 ********************************************************************/
#include "AC_SS_Cust.h"
#include "AC_SS_Cust_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void AC_SS_Cust_step(struct BlockIO_AC_SS_Cust *AC_SS_Cust_B, struct D_Work_AC_SS_Cust
                     *AC_SS_Cust_DWork, ExternalOutputs_AC_SS_Cust *AC_SS_Cust_Y, struct SS_Cust* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_bSS;
  real32_T rtb_DiscreteTimeIntegrator;
  boolean_T rtb_RelationalOperator_e;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  AC_SS_Cust_B->BusInput = inst->in;

  /* Logic: '<S2>/Logical Operator' incorporates:
   *  RelationalOperator: '<S2>/Relational Operator'
   *  RelationalOperator: '<S2>/Relational Operator1'
   *  S-Function (sfix_bitop): '<S2>/Bitwise Operator'
   *  S-Function (sfix_bitop): '<S2>/Bitwise Operator1'
   */
  rtb_bSS = (((AC_SS_Cust_B->BusInput.iSelectAbs & AC_SS_Cust_B->BusInput.iAbs) ==
              AC_SS_Cust_B->BusInput.iSelectAbs) &&
             ((AC_SS_Cust_B->BusInput.iSelectRel & AC_SS_Cust_B->BusInput.iRel) ==
              AC_SS_Cust_B->BusInput.iSelectRel));

  /* Outputs for Atomic SubSystem: '<S2>/TON' */
  /* Logic: '<S3>/Logical Operator2' */
  rtb_LogicalOperator2 = !rtb_bSS;

  /* DiscreteIntegrator: '<S3>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2 || (AC_SS_Cust_DWork->DiscreteTimeIntegrator_PrevRese
       != 0)) {
    AC_SS_Cust_DWork->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  rtb_DiscreteTimeIntegrator = AC_SS_Cust_DWork->DiscreteTimeIntegrator_DSTATE;

  /* RelationalOperator: '<S3>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S3>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_e = (AC_SS_Cust_DWork->DiscreteTimeIntegrator_DSTATE >=
    AC_SS_Cust_B->BusInput.rTi_Del);

  /* Update for DiscreteIntegrator: '<S3>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S4>/Conversion'
   *  Logic: '<S3>/Logical Operator'
   *  Logic: '<S3>/Logical Operator1'
   */
  if (!rtb_LogicalOperator2) {
    AC_SS_Cust_DWork->DiscreteTimeIntegrator_DSTATE += (real32_T)
      ((!rtb_RelationalOperator_e) && rtb_bSS) * 0.01F;
  }

  if (rtb_LogicalOperator2) {
    AC_SS_Cust_DWork->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    AC_SS_Cust_DWork->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S3>/Discrete-Time Integrator' */
  /* End of Outputs for SubSystem: '<S2>/TON' */

  /* BusCreator: '<S2>/Bus Creator' incorporates:
   *  Logic: '<S3>/Logical Operator3'
   */
  AC_SS_Cust_Y->out.bSS = rtb_bSS;

  /* Outputs for Atomic SubSystem: '<S2>/TON' */
  AC_SS_Cust_Y->out.bSS_Del = (rtb_RelationalOperator_e && rtb_bSS);

  /* End of Outputs for SubSystem: '<S2>/TON' */
  AC_SS_Cust_Y->out.rET = rtb_DiscreteTimeIntegrator;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->out = AC_SS_Cust_Y->out;
}

/* Model initialize function */
void AC_SS_Cust_initialize(struct SS_Cust* inst)
{
  /* (no initialization code required) */
}

/* Model terminate function */
void AC_SS_Cust_terminate(struct SS_Cust* inst)
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
