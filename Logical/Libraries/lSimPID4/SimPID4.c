/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: SimPID4
 * File: SimPID4.c
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Implementation of program SimPID4
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#include "SimPID4.h"
#include "SimPID4_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */


/* Block states (auto storage) */


/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void SimPID4_step(struct SimPID4* inst)
{
  real_T rtb_Product;
  real_T rtb_Invertswitch;
  real32_T rtb_Product2;
  real32_T rtb_Gain2;
  real32_T rtb_SumI1;

  /* S-Function (bur_in): '<Root>/Input9' */
  inst->bur_SimPID4_B.Input9 = inst->mode;

  /* S-Function (bur_in): '<Root>/Input10' */
  inst->bur_SimPID4_B.Input10 = inst->u_man;

  /* S-Function (bur_in): '<Root>/Input6' */
  inst->bur_SimPID4_B.Input6 = inst->a;

  /* S-Function (bur_in): '<Root>/Input5' */
  inst->bur_SimPID4_B.Input5 = inst->invert;

  /* Switch: '<S2>/Invert switch' incorporates:
   *  Constant: '<S2>/Constant2'
   *  Constant: '<S2>/Constant3'
   */
  if (inst->bur_SimPID4_B.Input5) {
    rtb_Invertswitch = -1.0;
  } else {
    rtb_Invertswitch = 1.0;
  }

  /* End of Switch: '<S2>/Invert switch' */

  /* S-Function (bur_in): '<Root>/Input4' */
  inst->bur_SimPID4_B.Input4 = inst->w;

  /* Product: '<S2>/Product' incorporates:
   *  Constant: '<S2>/Scaling'
   */
  rtb_Product = 1.0 / (inst->wxmax - inst->wxmin) * (real_T)inst->bur_SimPID4_B.Input4;

  /* S-Function (bur_in): '<Root>/Input' */
  inst->bur_SimPID4_B.Input = inst->x;

  /* Sum: '<S2>/Sum' incorporates:
   *  Constant: '<S2>/Scaling'
   *  Product: '<S2>/Product1'
   */
  rtb_Product -= 1.0 / (inst->wxmax - inst->wxmin) * (real_T)inst->bur_SimPID4_B.Input;

  /* DeadZone: '<S2>/Deadband' */
  if (rtb_Product > inst->deadband) {
    rtb_Product -= inst->deadband;
  } else if (rtb_Product >= -inst->deadband) {
    rtb_Product = 0.0;
  } else {
    rtb_Product -= -inst->deadband;
  }

  /* End of DeadZone: '<S2>/Deadband' */

  /* Product: '<S2>/Product2' */
  rtb_Product2 = (real32_T)(rtb_Invertswitch * rtb_Product);

  /* Gain: '<S3>/Gain' */
  inst->bur_SimPID4_B.Gain = inst->P * rtb_Product2;

  /* S-Function (bur_in): '<Root>/Input1' */
  inst->bur_SimPID4_B.Input1 = inst->reset;

  /* S-Function (bur_in): '<Root>/Input2' */
  inst->bur_SimPID4_B.Input2 = inst->I0;

  /* DiscreteIntegrator: '<S3>/Integrator' */
  if (inst->bur_SimPID4_DWork.Integrator_IC_LOADING != 0) {
    inst->bur_SimPID4_DWork.Integrator_DSTATE = inst->bur_SimPID4_B.Input2;
  }

  if (inst->bur_SimPID4_B.Input1) {
    inst->bur_SimPID4_DWork.Integrator_DSTATE = inst->bur_SimPID4_B.Input2;
  }

  inst->bur_SimPID4_B.Integrator = inst->bur_SimPID4_DWork.Integrator_DSTATE;

  /* End of DiscreteIntegrator: '<S3>/Integrator' */

  /* Gain: '<S3>/Gain2' */
  rtb_Gain2 = inst->D * rtb_Product2;

  /* S-Function (bur_in): '<Root>/Input3' */
  inst->bur_SimPID4_B.Input3 = inst->D0;

  /* DiscreteIntegrator: '<S3>/Filter' */
  if (inst->bur_SimPID4_DWork.Filter_IC_LOADING != 0) {
    inst->bur_SimPID4_DWork.Filter_DSTATE = inst->bur_SimPID4_B.Input3;
  }

  if (inst->bur_SimPID4_B.Input1) {
    inst->bur_SimPID4_DWork.Filter_DSTATE = inst->bur_SimPID4_B.Input3;
  }

  /* End of DiscreteIntegrator: '<S3>/Filter' */

  /* Gain: '<S3>/Filter Coefficient' incorporates:
   *  DiscreteIntegrator: '<S3>/Filter'
   *  Sum: '<S3>/SumD'
   */
  inst->bur_SimPID4_B.FilterCoefficient = (rtb_Gain2 - inst->bur_SimPID4_DWork.Filter_DSTATE) * inst->N;

  /* Sum: '<S3>/Sum2' incorporates:
   *  Sum: '<S3>/Sum1'
   */
  rtb_Gain2 = ((inst->bur_SimPID4_B.Gain + inst->bur_SimPID4_B.Integrator) +
               inst->bur_SimPID4_B.FilterCoefficient) + inst->bur_SimPID4_B.Input6;

  /* Saturate: '<S3>/Saturation' */
  inst->bur_SimPID4_B.Saturation = rtb_Gain2 >= inst->umax ? inst->umax : rtb_Gain2 <= inst->umin ? inst->umin :
    rtb_Gain2;

  /* MultiPortSwitch: '<S2>/Mode switch' */
  switch (inst->bur_SimPID4_B.Input9) {
   case 1:
    inst->bur_SimPID4_B.Modeswitch = inst->bur_SimPID4_B.Input10;
    break;

   case 2:
    inst->bur_SimPID4_B.Modeswitch = inst->bur_SimPID4_B.Input10;
    break;

   default:
    inst->bur_SimPID4_B.Modeswitch = inst->bur_SimPID4_B.Saturation;
    break;
  }

  /* End of MultiPortSwitch: '<S2>/Mode switch' */

  /* S-Function (bur_out): '<Root>/Output' */
  inst->u = inst->bur_SimPID4_B.Modeswitch;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->up = inst->bur_SimPID4_B.Gain;

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->ui = inst->bur_SimPID4_B.Integrator;

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->ud = inst->bur_SimPID4_B.FilterCoefficient;

  /* S-Function (bur_out): '<Root>/Output4' */
  inst->u_tr = inst->bur_SimPID4_B.Saturation;

  /* S-Function (bur_in): '<Root>/Input7' */
  inst->bur_SimPID4_B.Input7 = inst->fbk_mode;

  /* S-Function (bur_in): '<Root>/Input8' */
  inst->bur_SimPID4_B.Input8 = inst->u_fbk;

  /* MultiPortSwitch: '<S3>/Multiport Switch' */
  if (inst->bur_SimPID4_B.Input7 == 1) {
    rtb_SumI1 = inst->bur_SimPID4_B.Input8;
  } else {
    rtb_SumI1 = inst->bur_SimPID4_B.Saturation;
  }

  /* End of MultiPortSwitch: '<S3>/Multiport Switch' */

  /* Sum: '<S4>/Sum' */
  rtb_Gain2 = rtb_SumI1 - rtb_Gain2;

  /* MultiPortSwitch: '<S2>/Tracking switch' incorporates:
   *  Constant: '<S2>/Constant'
   *  Constant: '<S2>/Constant1'
   */
  switch (inst->bur_SimPID4_B.Input9) {
   case 1:
    rtb_Invertswitch = 0.0;
    break;

   case 2:
    rtb_Invertswitch = inst->Kt;
    break;

   default:
    rtb_Invertswitch = 0.0;
    break;
  }

  /* End of MultiPortSwitch: '<S2>/Tracking switch' */

  /* Sum: '<S3>/SumI1' incorporates:
   *  Gain: '<S3>/Gain1'
   *  Product: '<S3>/Product'
   *  Sum: '<S3>/SumI3'
   */
  rtb_SumI1 = (real32_T)((real_T)(inst->bur_SimPID4_B.Input10 - inst->bur_SimPID4_B.Saturation) *
    rtb_Invertswitch) + inst->I * rtb_Product2;

  /* Switch: '<S3>/Switch' incorporates:
   *  Abs: '<S4>/Abs'
   *  Constant: '<S3>/Constant4'
   *  Constant: '<S5>/Constant'
   *  Logic: '<S4>/AND'
   *  RelationalOperator: '<S4>/Equal'
   *  RelationalOperator: '<S5>/Compare'
   *  Signum: '<S4>/SignPreIntegrator'
   *  Signum: '<S4>/SignPreSat'
   */
  if (((real32_T)fabs(rtb_Gain2) > 0.005F) && ((rtb_Gain2 < 0.0F ? -1.0F :
        rtb_Gain2 > 0.0F ? 1.0F : rtb_Gain2) != (rtb_SumI1 < 0.0F ? -1.0F :
        rtb_SumI1 > 0.0F ? 1.0F : rtb_SumI1))) {
    rtb_SumI1 = 0.0F;
  }

  /* End of Switch: '<S3>/Switch' */

  /* Update for DiscreteIntegrator: '<S3>/Integrator' */
  inst->bur_SimPID4_DWork.Integrator_IC_LOADING = 0U;
  inst->bur_SimPID4_DWork.Integrator_DSTATE = 0.01F * rtb_SumI1 +
    inst->bur_SimPID4_DWork.Integrator_DSTATE;

  /* Update for DiscreteIntegrator: '<S3>/Filter' */
  inst->bur_SimPID4_DWork.Filter_IC_LOADING = 0U;
  inst->bur_SimPID4_DWork.Filter_DSTATE = 0.01F * inst->bur_SimPID4_B.FilterCoefficient +
    inst->bur_SimPID4_DWork.Filter_DSTATE;
}

/* Model initialize function */
void SimPID4_initialize(struct SimPID4* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S3>/Integrator' */
  inst->bur_SimPID4_DWork.Integrator_IC_LOADING = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S3>/Filter' */
  inst->bur_SimPID4_DWork.Filter_IC_LOADING = 1U;
}

/* Model terminate function */
void SimPID4_terminate(struct SimPID4* inst)
{
  /* (no terminate code required) */
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 7.12 (R2011a)09-Mar-2011                                            *
 * Simulink 7.7 (R2011a)09-Mar-2011                                           *
 * Simulink Coder 8.0 (R2011a)09-Mar-2011                                     *
 * Embedded Coder 6.0 (R2011a)09-Mar-2011                                     *
 * Stateflow 7.7 (R2011a)09-Mar-2011                                          *
 * Simulink Fixed Point 6.5 (R2011a)09-Mar-2011                               *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
