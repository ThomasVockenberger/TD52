/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: SimPIDBR6
 * File: SimPIDBR6.c
 * Author: 105055527
 * Created: Tue Dec 06 16:11:54 2016
 ********************************************************************
 * Implementation of program SimPIDBR6
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "SimPIDBR6.h"
#include "SimPIDBR6_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void SimPIDBR6_step(struct BlockIO_SimPIDBR6 *SimPIDBR6_B, struct D_Work_SimPIDBR6
                    *SimPIDBR6_DWork, struct fSimPIDx* inst)
{
  real_T rtb_Product;
  real_T rtb_Invertswitch;
  real32_T rtb_Product2;
  real32_T rtb_Gain2;
  real32_T rtb_Gain;
  real32_T rtb_SumI;

  /* S-Function (bur_in): '<Root>/Input9' */
  SimPIDBR6_B->Input9 = inst->mode;

  /* S-Function (bur_in): '<Root>/Input10' */
  SimPIDBR6_B->Input10 = inst->u_man;

  /* S-Function (bur_in): '<Root>/Input6' */
  SimPIDBR6_B->Input6 = inst->a;

  /* S-Function (bur_in): '<Root>/Input5' */
  SimPIDBR6_B->Input5 = inst->invert;

  /* Switch: '<S1>/Invert switch' incorporates:
   *  Constant: '<S1>/Constant2'
   *  Constant: '<S1>/Constant3'
   */
  if (SimPIDBR6_B->Input5) {
    rtb_Invertswitch = -1.0;
  } else {
    rtb_Invertswitch = 1.0;
  }

  /* End of Switch: '<S1>/Invert switch' */

  /* S-Function (bur_in): '<Root>/Input4' */
  SimPIDBR6_B->Input4 = inst->w;

  /* Product: '<S1>/Product' incorporates:
   *  Constant: '<S1>/Scaling'
   */
  rtb_Product = 1.0 / (inst->wxmax - inst->wxmin) * (real_T)SimPIDBR6_B->Input4;

  /* S-Function (bur_in): '<Root>/Input' */
  SimPIDBR6_B->Input = inst->x;

  /* Sum: '<S1>/Sum' incorporates:
   *  Constant: '<S1>/Scaling'
   *  Product: '<S1>/Product1'
   */
  rtb_Product -= 1.0 / (inst->wxmax - inst->wxmin) * (real_T)SimPIDBR6_B->Input;

  /* DeadZone: '<S1>/Deadband' */
  if (rtb_Product > inst->deadband) {
    rtb_Product -= inst->deadband;
  } else if (rtb_Product >= -inst->deadband) {
    rtb_Product = 0.0;
  } else {
    rtb_Product -= -inst->deadband;
  }

  /* End of DeadZone: '<S1>/Deadband' */

  /* Product: '<S1>/Product2' */
  rtb_Product2 = (real32_T)(rtb_Invertswitch * rtb_Product);

  /* Gain: '<S2>/Gain' */
  SimPIDBR6_B->Gain = inst->P * rtb_Product2;

  /* S-Function (bur_in): '<Root>/Input1' */
  SimPIDBR6_B->Input1 = inst->reset;

  /* S-Function (bur_in): '<Root>/Input2' */
  SimPIDBR6_B->Input2 = inst->I0;

  /* DiscreteIntegrator: '<S2>/Integrator' */
  if (SimPIDBR6_DWork->Integrator_IC_LOADING != 0) {
    SimPIDBR6_DWork->Integrator_DSTATE = SimPIDBR6_B->Input2;
  }

  if (SimPIDBR6_B->Input1) {
    SimPIDBR6_DWork->Integrator_DSTATE = SimPIDBR6_B->Input2;
  }

  SimPIDBR6_B->Integrator = SimPIDBR6_DWork->Integrator_DSTATE;

  /* End of DiscreteIntegrator: '<S2>/Integrator' */

  /* Gain: '<S2>/Gain2' */
  rtb_Gain2 = inst->D * rtb_Product2;

  /* S-Function (bur_in): '<Root>/Input3' */
  SimPIDBR6_B->Input3 = inst->D0;

  /* DiscreteIntegrator: '<S2>/Filter' */
  if (SimPIDBR6_DWork->Filter_IC_LOADING != 0) {
    SimPIDBR6_DWork->Filter_DSTATE = SimPIDBR6_B->Input3;
  }

  if (SimPIDBR6_B->Input1) {
    SimPIDBR6_DWork->Filter_DSTATE = SimPIDBR6_B->Input3;
  }

  /* Gain: '<S2>/Filter Coefficient' incorporates:
   *  DiscreteIntegrator: '<S2>/Filter'
   *  Sum: '<S2>/SumD'
   */
  SimPIDBR6_B->FilterCoefficient = (rtb_Gain2 - SimPIDBR6_DWork->Filter_DSTATE) *
    inst->N;

  /* Sum: '<S2>/Sum2' incorporates:
   *  Sum: '<S2>/Sum1'
   */
  rtb_Gain2 = ((SimPIDBR6_B->Gain + SimPIDBR6_B->Integrator) +
               SimPIDBR6_B->FilterCoefficient) + SimPIDBR6_B->Input6;

  /* Saturate: '<S2>/Saturation' */
  if (rtb_Gain2 >= inst->umax) {
    SimPIDBR6_B->Saturation = inst->umax;
  } else if (rtb_Gain2 <= inst->umin) {
    SimPIDBR6_B->Saturation = inst->umin;
  } else {
    SimPIDBR6_B->Saturation = rtb_Gain2;
  }

  /* End of Saturate: '<S2>/Saturation' */

  /* MultiPortSwitch: '<S1>/Mode switch' */
  switch (SimPIDBR6_B->Input9) {
   case 1:
    SimPIDBR6_B->Modeswitch = SimPIDBR6_B->Input10;
    break;

   case 2:
    SimPIDBR6_B->Modeswitch = SimPIDBR6_B->Input10;
    break;

   default:
    SimPIDBR6_B->Modeswitch = SimPIDBR6_B->Saturation;
    break;
  }

  /* End of MultiPortSwitch: '<S1>/Mode switch' */

  /* S-Function (bur_out): '<Root>/Output' */
  inst->u = SimPIDBR6_B->Modeswitch;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->up = SimPIDBR6_B->Gain;

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->ui = SimPIDBR6_B->Integrator;

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->ud = SimPIDBR6_B->FilterCoefficient;

  /* S-Function (bur_out): '<Root>/Output4' */
  inst->u_tr = SimPIDBR6_B->Saturation;

  /* S-Function (bur_in): '<Root>/Input11' */
  SimPIDBR6_B->Input11 = inst->e_int;

  /* S-Function (bur_in): '<Root>/Input7' */
  SimPIDBR6_B->Input7 = inst->fbk_mode;

  /* S-Function (bur_in): '<Root>/Input8' */
  SimPIDBR6_B->Input8 = inst->u_fbk;

  /* MultiPortSwitch: '<S2>/Multiport Switch' */
  if (SimPIDBR6_B->Input7 == 1) {
    rtb_Gain = SimPIDBR6_B->Input8;
  } else {
    rtb_Gain = SimPIDBR6_B->Saturation;
  }

  /* End of MultiPortSwitch: '<S2>/Multiport Switch' */

  /* Sum: '<S3>/Sum' */
  rtb_Gain2 = rtb_Gain - rtb_Gain2;

  /* MultiPortSwitch: '<S1>/Tracking switch' incorporates:
   *  Constant: '<S1>/Constant'
   *  Constant: '<S1>/Constant1'
   */
  switch (SimPIDBR6_B->Input9) {
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

  /* End of MultiPortSwitch: '<S1>/Tracking switch' */

  /* Sum: '<S2>/SumI1' incorporates:
   *  Gain: '<S2>/Gain1'
   *  Product: '<S2>/Product'
   *  Sum: '<S2>/SumI3'
   */
  rtb_Product2 = (inst->I * rtb_Product2 + SimPIDBR6_B->Input11) + (real32_T)((real_T)
    (SimPIDBR6_B->Input10 - SimPIDBR6_B->Saturation) * rtb_Invertswitch);

  /* Signum: '<S3>/SignPreSat' */
  if (rtb_Gain2 < 0.0F) {
    rtb_Gain = -1.0F;
  } else if (rtb_Gain2 > 0.0F) {
    rtb_Gain = 1.0F;
  } else {
    rtb_Gain = rtb_Gain2;
  }

  /* Signum: '<S3>/SignPreIntegrator' */
  if (rtb_Product2 < 0.0F) {
    rtb_SumI = -1.0F;
  } else if (rtb_Product2 > 0.0F) {
    rtb_SumI = 1.0F;
  } else {
    rtb_SumI = rtb_Product2;
  }

  /* Switch: '<S2>/Switch' incorporates:
   *  Abs: '<S3>/Abs'
   *  Constant: '<S2>/Constant4'
   *  Constant: '<S4>/Constant'
   *  Logic: '<S3>/AND'
   *  RelationalOperator: '<S3>/Equal'
   *  RelationalOperator: '<S4>/Compare'
   *  Signum: '<S3>/SignPreIntegrator'
   *  Signum: '<S3>/SignPreSat'
   */
  if (((real32_T)fabs(rtb_Gain2) > 0.005F) && (rtb_Gain != rtb_SumI)) {
    rtb_Gain2 = 0.0F;
  } else {
    rtb_Gain2 = rtb_Product2;
  }

  /* End of Switch: '<S2>/Switch' */

  /* Update for DiscreteIntegrator: '<S2>/Integrator' */
  SimPIDBR6_DWork->Integrator_IC_LOADING = 0U;
  SimPIDBR6_DWork->Integrator_DSTATE += 0.01F * rtb_Gain2;

  /* Update for DiscreteIntegrator: '<S2>/Filter' */
  SimPIDBR6_DWork->Filter_IC_LOADING = 0U;
  SimPIDBR6_DWork->Filter_DSTATE += 0.01F * SimPIDBR6_B->FilterCoefficient;
}

/* Model initialize function */
void SimPIDBR6_initialize(struct D_Work_SimPIDBR6 *SimPIDBR6_DWork, struct fSimPIDx* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S2>/Integrator' */
  SimPIDBR6_DWork->Integrator_IC_LOADING = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S2>/Filter' */
  SimPIDBR6_DWork->Filter_IC_LOADING = 1U;
}

/* Model terminate function */
void SimPIDBR6_terminate(struct fSimPIDx* inst)
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
 * curve_fitting_toolbox                                                      *
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
