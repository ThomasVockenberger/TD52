/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AI50toIT_mdl
 * File: AI50toIT_mdl.c
 * Author: 105055527
 * Created: Thu Sep 11 18:05:22 2014
 ********************************************************************
 * Implementation of program AI50toIT_mdl
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "AI50toIT_mdl.h"
#include "AI50toIT_mdl_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */
struct BlockIO_AI50toIT_mdl AI50toIT_mdl_B;

/* Block states (auto storage) */
struct D_Work_AI50toIT_mdl AI50toIT_mdl_DWork;

/* External inputs (root inport signals with auto storage) */
ExternalInputs_AI50toIT_mdl AI50toIT_mdl_U;

/* External outputs (root outports fed by signals with auto storage) */
ExternalOutputs_AI50toIT_mdl AI50toIT_mdl_Y;

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void AI50toIT_mdl_step(struct AI50toIT* inst)
{
  real32_T rtb_Add[25];
  real32_T rtb_Abs[25];
  real32_T rtb_Trackingswitch;
  real32_T rtb_Invertswitch;
  real32_T rtb_SumI1[25];
  boolean_T rtb_LowerRelop1_k[25];
  int32_T i;
  real32_T rtb_SumI;
  real32_T rtb_SumI_0;

  /* S-Function (bur_in): '<Root>/Input16' */
  {
    int_T i1;
    real32_T *y0 = AI50toIT_mdl_B.Input16;
    for (i1=0; i1 < 25; i1++) {
      y0[i1] = inst->uman[i1];
    }
  }

  /* Switch: '<S8>/Invert switch' incorporates:
   *  Constant: '<S6>/Constant4'
   *  Constant: '<S8>/Constant2'
   *  Constant: '<S8>/Constant3'
   */
  if ((int32_T)inst->invert > 0) {
    rtb_Invertswitch = -1.0F;
  } else {
    rtb_Invertswitch = 1.0F;
  }

  /* End of Switch: '<S8>/Invert switch' */

  /* S-Function (bur_in): '<Root>/Input5' */
  AI50toIT_mdl_B.Input5 = inst->AI50ref;

  /* S-Function (bur_in): '<Root>/Input8' */
  {
    int_T i1;
    real32_T *y0 = AI50toIT_mdl_B.Input8;
    for (i1=0; i1 < 25; i1++) {
      y0[i1] = inst->AI50offset[i1];
    }
  }

  /* S-Function (bur_in): '<Root>/Input3' */
  {
    int_T i1;
    real32_T *y0 = AI50toIT_mdl_B.Input3;
    for (i1=0; i1 < 25; i1++) {
      y0[i1] = inst->AI50offset_knck[i1];
    }
  }

  /* S-Function (bur_in): '<Root>/Input4' */
  AI50toIT_mdl_B.Input4 = inst->K_knck;

  /* Sum: '<Root>/Add' incorporates:
   *  Product: '<Root>/Product'
   */
  for (i = 0; i < 25; i++) {
    rtb_Add[i] = (AI50toIT_mdl_B.Input5 + AI50toIT_mdl_B.Input8[i]) +
      AI50toIT_mdl_B.Input3[i] * AI50toIT_mdl_B.Input4;
  }

  /* End of Sum: '<Root>/Add' */

  /* DiscreteIntegrator: '<S1>/Discrete-Time Integrator' incorporates:
   *  Constant: '<S1>/Constant2'
   */
  if (inst->reset || (AI50toIT_mdl_DWork.DiscreteTimeIntegrator_PrevRese != 0)) {
    for (i = 0; i < 25; i++) {
      AI50toIT_mdl_DWork.DiscreteTimeIntegrator_DSTATE[i] = 10.0F;
    }
  }

  for (i = 0; i < 25; i++) {
    /* DiscreteIntegrator: '<S1>/Discrete-Time Integrator' */
    AI50toIT_mdl_B.DiscreteTimeIntegrator[i] =
      AI50toIT_mdl_DWork.DiscreteTimeIntegrator_DSTATE[i];

    /* Sum: '<S8>/Sum' incorporates:
     *  Product: '<S8>/Product'
     *  Product: '<S8>/Product1'
     */
    rtb_Trackingswitch = rtb_Add[i] - AI50toIT_mdl_B.DiscreteTimeIntegrator[i];

    /* Switch: '<S10>/Switch' incorporates:
     *  Constant: '<S6>/Constant11'
     *  Gain: '<S8>/Gain1'
     *  RelationalOperator: '<S10>/u_GTE_up'
     *  RelationalOperator: '<S10>/u_GT_lo'
     *  Switch: '<S10>/Switch1'
     */
    if (rtb_Trackingswitch >= inst->deadband) {
      rtb_SumI = inst->deadband;
    } else if (rtb_Trackingswitch > -inst->deadband) {
      /* Switch: '<S10>/Switch1' */
      rtb_SumI = rtb_Trackingswitch;
    } else {
      rtb_SumI = -inst->deadband;
    }

    /* End of Switch: '<S10>/Switch' */

    /* Product: '<S8>/Product2' incorporates:
     *  Sum: '<S10>/Diff'
     */
    AI50toIT_mdl_B.Product2[i] = (rtb_Trackingswitch - rtb_SumI) *
      rtb_Invertswitch;

    /* Product: '<S11>/Product1' incorporates:
     *  Constant: '<S6>/Constant5'
     */
    AI50toIT_mdl_B.Product1[i] = inst->kp * AI50toIT_mdl_B.Product2[i];

    /* Sum: '<S8>/Sum' */
    rtb_Abs[i] = rtb_Trackingswitch;
  }

  for (i = 0; i < 25; i++) {
    /* DiscreteIntegrator: '<S11>/Integrator' incorporates:
     *  Constant: '<S6>/Constant1'
     */
    if (inst->reset) {
      AI50toIT_mdl_DWork.Integrator_DSTATE[i] = 0.0F;
    }

    AI50toIT_mdl_B.Integrator[i] = AI50toIT_mdl_DWork.Integrator_DSTATE[i];

    /* End of DiscreteIntegrator: '<S11>/Integrator' */

    /* DiscreteIntegrator: '<S11>/Filter' incorporates:
     *  Constant: '<S6>/Constant1'
     */
    if (inst->reset) {
      AI50toIT_mdl_DWork.Filter_DSTATE[i] = 0.0F;
    }

    /* Product: '<S11>/Product4' incorporates:
     *  Constant: '<S6>/Constant7'
     *  Constant: '<S6>/Constant8'
     *  DiscreteIntegrator: '<S11>/Filter'
     *  Product: '<S11>/Product3'
     *  Sum: '<S11>/SumD'
     */
    AI50toIT_mdl_B.Product4[i] = (AI50toIT_mdl_B.Product2[i] * inst->kd -
      AI50toIT_mdl_DWork.Filter_DSTATE[i]) * inst->N;

    /* Sum: '<S11>/Sum2' incorporates:
     *  Sum: '<S11>/Sum1'
     */
    rtb_SumI = (AI50toIT_mdl_B.Product1[i] + AI50toIT_mdl_B.Integrator[i]) +
      AI50toIT_mdl_B.Product4[i];

    /* Switch: '<S13>/Switch2' incorporates:
     *  Constant: '<S6>/Constant12'
     *  Constant: '<S6>/Constant14'
     *  RelationalOperator: '<S13>/LowerRelop1'
     *  RelationalOperator: '<S13>/UpperRelop'
     *  Switch: '<S13>/Switch'
     */
    if (rtb_SumI > 20.0F) {
      AI50toIT_mdl_B.Switch2[i] = 20.0F;
    } else if (rtb_SumI < -20.0F) {
      /* Switch: '<S13>/Switch' incorporates:
       *  Constant: '<S6>/Constant14'
       */
      AI50toIT_mdl_B.Switch2[i] = -20.0F;
    } else {
      AI50toIT_mdl_B.Switch2[i] = rtb_SumI;
    }

    /* End of Switch: '<S13>/Switch2' */

    /* Sum: '<S11>/Sum2' */
    rtb_SumI1[i] = rtb_SumI;
  }

  /* MultiPortSwitch: '<S8>/Mode switch' incorporates:
   *  Constant: '<S6>/Constant'
   */
  switch (inst->mode) {
   case 1:
    for (i = 0; i < 25; i++) {
      AI50toIT_mdl_B.Modeswitch[i] = AI50toIT_mdl_B.Input16[i];
    }
    break;

   case 2:
    for (i = 0; i < 25; i++) {
      AI50toIT_mdl_B.Modeswitch[i] = AI50toIT_mdl_B.Input16[i];
    }
    break;

   default:
    for (i = 0; i < 25; i++) {
      AI50toIT_mdl_B.Modeswitch[i] = AI50toIT_mdl_B.Switch2[i];
    }
    break;
  }

  for (i = 0; i < 25; i++) {
    /* Switch: '<S9>/Switch2' incorporates:
     *  Constant: '<S6>/Constant16'
     *  Constant: '<S6>/Constant17'
     *  RelationalOperator: '<S9>/LowerRelop1'
     *  RelationalOperator: '<S9>/UpperRelop'
     *  Switch: '<S9>/Switch'
     */
    if (AI50toIT_mdl_B.Modeswitch[i] > inst->umax) {
      /* Outport: '<Root>/IToffset' */
      AI50toIT_mdl_Y.IToffset[i] = inst->umax;
    } else if (AI50toIT_mdl_B.Modeswitch[i] < inst->umin) {
      /* Switch: '<S9>/Switch' incorporates:
       *  Constant: '<S6>/Constant17'
       *  Outport: '<Root>/IToffset'
       */
      AI50toIT_mdl_Y.IToffset[i] = inst->umin;
    } else {
      /* Outport: '<Root>/IToffset' incorporates:
       *  Switch: '<S9>/Switch'
       */
      AI50toIT_mdl_Y.IToffset[i] = AI50toIT_mdl_B.Modeswitch[i];
    }

    /* End of Switch: '<S9>/Switch2' */

    /* Outport: '<Root>/ITsat' incorporates:
     *  Sum: '<S6>/Sum2'
     */
    AI50toIT_mdl_Y.ITsat[i] = AI50toIT_mdl_Y.IToffset[i] -
      AI50toIT_mdl_B.Modeswitch[i];

    /* Outport: '<Root>/AI50err' incorporates:
     *  Sum: '<S6>/Sum3'
     */
    AI50toIT_mdl_Y.AI50err[i] = rtb_Add[i] -
      AI50toIT_mdl_B.DiscreteTimeIntegrator[i];
  }

  /* End of MultiPortSwitch: '<S8>/Mode switch' */

  /* S-Function (bur_out): '<Root>/Output1' */
  {
    int_T i1;
    const real32_T *u0 = &AI50toIT_mdl_Y.ITsat[0];
    for (i1=0; i1 < 25; i1++) {
      inst->ITsat[i1] = u0[i1];
    }
  }

  /* S-Function (bur_out): '<Root>/Output2' */
  {
    int_T i1;
    const real32_T *u0 = &AI50toIT_mdl_Y.AI50err[0];
    for (i1=0; i1 < 25; i1++) {
      inst->AI50err[i1] = u0[i1];
    }
  }

  /* S-Function (bur_out): '<Root>/Output3' */
  {
    int_T i1;
    const real32_T *u0 = &AI50toIT_mdl_Y.IToffset[0];
    for (i1=0; i1 < 25; i1++) {
      inst->IToffset[i1] = u0[i1];
    }
  }

  /* S-Function (bur_out): '<Root>/Output6' */
  {
    int_T i1;
    const real32_T *u0 = AI50toIT_mdl_B.DiscreteTimeIntegrator;
    for (i1=0; i1 < 25; i1++) {
      inst->DB_AI50_f[i1] = u0[i1];
    }
  }

  /* S-Function (bur_in): '<Root>/Input1' */
  AI50toIT_mdl_B.Input1 = inst->AI50_max;

  /* S-Function (bur_in): '<Root>/Input9' */
  {
    int_T i1;
    real32_T *y0 = AI50toIT_mdl_B.Input9;
    for (i1=0; i1 < 25; i1++) {
      y0[i1] = inst->AI50act[i1];
    }
  }

  /* RelationalOperator: '<S7>/LowerRelop1' */
  for (i = 0; i < 25; i++) {
    rtb_LowerRelop1_k[i] = (AI50toIT_mdl_B.Input9[i] > AI50toIT_mdl_B.Input1);
  }

  /* End of RelationalOperator: '<S7>/LowerRelop1' */

  /* S-Function (bur_in): '<Root>/Input2' */
  AI50toIT_mdl_B.Input2 = inst->AI50_min;

  /* Sum: '<S1>/Sum2' */
  for (i = 0; i < 25; i++) {
    /* Switch: '<S7>/Switch2' incorporates:
     *  RelationalOperator: '<S7>/UpperRelop'
     *  Switch: '<S7>/Switch'
     */
    if (rtb_LowerRelop1_k[i]) {
      rtb_Trackingswitch = AI50toIT_mdl_B.Input1;
    } else if (AI50toIT_mdl_B.Input9[i] < AI50toIT_mdl_B.Input2) {
      /* Switch: '<S7>/Switch' */
      rtb_Trackingswitch = AI50toIT_mdl_B.Input2;
    } else {
      rtb_Trackingswitch = AI50toIT_mdl_B.Input9[i];
    }

    /* End of Switch: '<S7>/Switch2' */
    rtb_Abs[i] = rtb_Trackingswitch - AI50toIT_mdl_B.DiscreteTimeIntegrator[i];
  }

  /* End of Sum: '<S1>/Sum2' */

  /* Saturate: '<S1>/Saturation' incorporates:
   *  Constant: '<S1>/Constant3'
   */
  if (inst->T_filt_AI50 >= 0.001F) {
    rtb_Invertswitch = inst->T_filt_AI50;
  } else {
    rtb_Invertswitch = 0.001F;
  }

  /* End of Saturate: '<S1>/Saturation' */

  /* S-Function (bur_out): '<S6>/Output5' */
  inst->dbg1[0] = AI50toIT_mdl_B.Modeswitch[1];
  inst->dbg1[1] = AI50toIT_mdl_B.Switch2[1];
  inst->dbg1[2] = AI50toIT_mdl_B.Product1[1];
  inst->dbg1[3] = AI50toIT_mdl_B.Integrator[1];
  inst->dbg1[4] = AI50toIT_mdl_B.Product4[1];
  inst->dbg1[5] = AI50toIT_mdl_B.Product2[1];
  for (i = 0; i < 25; i++) {
    /* Sum: '<S12>/Sum' incorporates:
     *  Signum: '<S12>/SignPreSat'
     */
    rtb_SumI = AI50toIT_mdl_Y.IToffset[i] - rtb_SumI1[i];

    /* RelationalOperator: '<S14>/Compare' incorporates:
     *  Abs: '<S12>/Abs'
     *  Constant: '<S14>/Constant'
     */
    rtb_LowerRelop1_k[i] = ((real32_T)fabs(rtb_SumI) > 0.1F);

    /* Signum: '<S12>/SignPreSat' */
    if (rtb_SumI < 0.0F) {
      rtb_Add[i] = -1.0F;
    } else if (rtb_SumI > 0.0F) {
      rtb_Add[i] = 1.0F;
    } else {
      rtb_Add[i] = rtb_SumI;
    }
  }

  /* MultiPortSwitch: '<S8>/Tracking switch' incorporates:
   *  Constant: '<S6>/Constant'
   *  Constant: '<S6>/Constant10'
   *  Constant: '<S8>/Constant1'
   */
  switch (inst->mode) {
   case 1:
    rtb_Trackingswitch = 0.0F;
    break;

   case 2:
    rtb_Trackingswitch = inst->Kt;
    break;

   default:
    rtb_Trackingswitch = 0.0F;
    break;
  }

  for (i = 0; i < 25; i++) {
    /* Sum: '<S11>/SumI1' incorporates:
     *  Constant: '<S6>/Constant6'
     *  Product: '<S11>/Product'
     *  Product: '<S11>/Product2'
     *  Sum: '<S11>/SumI3'
     */
    rtb_SumI = (AI50toIT_mdl_B.Input16[i] - AI50toIT_mdl_B.Switch2[i]) *
      rtb_Trackingswitch + AI50toIT_mdl_B.Product2[i] * inst->ki;

    /* Switch: '<S11>/Switch' incorporates:
     *  Constant: '<S11>/Constant4'
     *  Logic: '<S12>/AND'
     *  RelationalOperator: '<S12>/Equal'
     */
    if (rtb_SumI < 0.0F) {
      rtb_SumI_0 = -1.0F;
    } else if (rtb_SumI > 0.0F) {
      rtb_SumI_0 = 1.0F;
    } else {
      rtb_SumI_0 = rtb_SumI;
    }

    if (rtb_LowerRelop1_k[i] && (rtb_Add[i] != rtb_SumI_0)) {
      rtb_SumI = 0.0F;
    }

    rtb_Add[i] = rtb_SumI;

    /* End of Switch: '<S11>/Switch' */
  }

  /* End of MultiPortSwitch: '<S8>/Tracking switch' */

  /* Update for DiscreteIntegrator: '<S1>/Discrete-Time Integrator' incorporates:
   *  Constant: '<S1>/Constant2'
   *  Product: '<S1>/Divide'
   */
  if (inst->reset == 0) {
    for (i = 0; i < 25; i++) {
      AI50toIT_mdl_DWork.DiscreteTimeIntegrator_DSTATE[i] += rtb_Abs[i] /
        rtb_Invertswitch * 0.08F;
    }
  }

  if ((int32_T)inst->reset > 0) {
    AI50toIT_mdl_DWork.DiscreteTimeIntegrator_PrevRese = 1;
  } else if (inst->reset == 0) {
    AI50toIT_mdl_DWork.DiscreteTimeIntegrator_PrevRese = 0;
  } else {
    AI50toIT_mdl_DWork.DiscreteTimeIntegrator_PrevRese = 2;
  }

  for (i = 0; i < 25; i++) {
    /* Update for DiscreteIntegrator: '<S11>/Integrator' */
    AI50toIT_mdl_DWork.Integrator_DSTATE[i] += 0.08F * rtb_Add[i];

    /* Update for DiscreteIntegrator: '<S11>/Filter' */
    AI50toIT_mdl_DWork.Filter_DSTATE[i] += 0.08F * AI50toIT_mdl_B.Product4[i];
  }

  /* End of Update for DiscreteIntegrator: '<S1>/Discrete-Time Integrator' */
}

/* Model initialize function */
void AI50toIT_mdl_initialize(struct AI50toIT* inst)
{
  /* S-Function (bur_out): '<Root>/Output7' */
  inst->DB_Ts = 0.08;

  {
    int32_T i;
    for (i = 0; i < 25; i++) {
      /* InitializeConditions for DiscreteIntegrator: '<S1>/Discrete-Time Integrator' */
      AI50toIT_mdl_DWork.DiscreteTimeIntegrator_DSTATE[i] = 10.0F;
    }
  }
}

/* Model terminate function */
void AI50toIT_mdl_terminate(struct AI50toIT* inst)
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
