/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: HiGlob
 * File: HiGlob.c
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Implementation of program HiGlob
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.0
 * (ERT based)
 ********************************************************************/

#include "HiGlob.h"
#include "HiGlob_private.h"

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
void HiGlob_step(struct HiGlob* inst)
{
  /* local block i/o variables */
  boolean_T rtb_BitwiseOperator;
  boolean_T rtb_BitwiseOperator1;
  real32_T rtb_MinMax2;
  real32_T rtb_percent;
  real32_T rtb_Divide_n;
  real_T rtb_Divide;
  int16_T rtb_Subtract1;
  boolean_T rtb_LowerRelop1_l;
  boolean_T rtb_Compare_jf;
  int16_T rtb_Switch_o;

  /* S-Function (bur_in): '<Root>/Input11' */
  inst->bur_HiGlob_B.Input11 = inst->ZcylEng;

  /* S-Function (bur_in): '<S4>/Input15' */
  inst->bur_HiGlob_B.Input15_p = inst->NCylPmaxTh;

  /* Sum: '<S4>/Add' */
  rtb_Switch_o = (int16_T)(inst->bur_HiGlob_B.Input11 - inst->bur_HiGlob_B.Input15_p);

  /* S-Function (bur_in): '<Root>/Input12' */
  inst->bur_HiGlob_B.Input12 = inst->EngStopErrAck;

  /* DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */
  if (inst->bur_HiGlob_B.Input12 || (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRese != 0)) {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE >= 1000.0F) {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE = 1000.0F;
  } else {
    if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE <= 0.0F) {
      inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE = 0.0F;
    }
  }

  rtb_MinMax2 = inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE;

  /* End of DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */

  /* S-Function (bur_in): '<S4>/Input3' */
  inst->bur_HiGlob_B.Input3 = inst->PmaxLimPowTh;

  /* Sum: '<S4>/Add1' */
  rtb_percent = rtb_MinMax2 - inst->bur_HiGlob_B.Input3;

  /* Gain: '<S4>/KITPmaxLim (CAD//events*100cycles)' */
  rtb_MinMax2 *= inst->KITPmaxLim;

  /* S-Function (bur_in): '<Root>/Input13' */
  inst->bur_HiGlob_B.Input13 = inst->PmaxLimContrEn;

  /* Product: '<S4>/Divide' */
  rtb_Divide_n = inst->bur_HiGlob_B.Input13 ? rtb_MinMax2 : 0.0F;

  /* S-Function (bur_in): '<S4>/Input1' */
  inst->bur_HiGlob_B.Input1 = inst->TdownPmax;

  /* S-Function (bur_in): '<S4>/Input2' */
  inst->bur_HiGlob_B.Input2 = inst->TupPmax;

  /* S-Function (bur_in): '<S4>/Input4' */
  inst->bur_HiGlob_B.Input4 = inst->ITPmaxLimMax;

  /* Switch: '<S4>/Switch3' incorporates:
   *  Constant: '<S16>/Constant'
   *  Constant: '<S4>/Constant4'
   *  Logic: '<S4>/Logical Operator13'
   *  RelationalOperator: '<S16>/Compare'
   */
  if (!((rtb_percent > 0.0F) && inst->bur_HiGlob_B.Input13)) {
    rtb_percent = 0.0F;
  }

  /* End of Switch: '<S4>/Switch3' */

  /* Gain: '<S4>/KPredPmaxLim (%Pel//events*100cycles)' */
  rtb_MinMax2 = inst->KPredPmaxLim * rtb_percent;

  /* Product: '<S17>/Divide1' incorporates:
   *  Constant: '<S17>/Constant'
   */
  rtb_Divide = 1.0 / (real_T)inst->bur_HiGlob_B.Input1;

  /* S-Function (bur_in): '<Root>/Input10' */
  inst->bur_HiGlob_B.Input10 = inst->PmaxLimReachGlob;

  /* Sum: '<S4>/Subtract1' */
  rtb_Subtract1 = (int16_T)(inst->bur_HiGlob_B.Input10 - inst->bur_HiGlob_B.Input15_p);

  /* Switch: '<S18>/Switch2' incorporates:
   *  RelationalOperator: '<S18>/LowerRelop1'
   */
  if (!(rtb_Subtract1 > rtb_Switch_o)) {
    /* Switch: '<S18>/Switch' incorporates:
     *  Constant: '<S4>/Constant1'
     *  RelationalOperator: '<S18>/UpperRelop'
     */
    if (rtb_Subtract1 < 0) {
      rtb_Subtract1 = 0;
    }

    /* End of Switch: '<S18>/Switch' */
    rtb_Switch_o = rtb_Subtract1;
  }

  /* End of Switch: '<S18>/Switch2' */

  /* Product: '<S17>/Divide2' incorporates:
   *  Product: '<S17>/Divide'
   *  Sum: '<S17>/Add'
   */
  rtb_Divide = (real_T)((real32_T)rtb_Switch_o / inst->bur_HiGlob_B.Input2) - rtb_Divide;

  /* Switch: '<S19>/Switch2' incorporates:
   *  RelationalOperator: '<S19>/LowerRelop1'
   */
  if (rtb_Divide_n > inst->bur_HiGlob_B.Input4) {
    inst->bur_HiGlob_B.Switch2 = inst->bur_HiGlob_B.Input4;
  } else {
    /* Switch: '<S19>/Switch' incorporates:
     *  Constant: '<S4>/Constant6'
     *  RelationalOperator: '<S19>/UpperRelop'
     */
    if (rtb_Divide_n < 0.0F) {
      inst->bur_HiGlob_B.Switch2 = 0.0F;
    } else {
      inst->bur_HiGlob_B.Switch2 = rtb_Divide_n;
    }

    /* End of Switch: '<S19>/Switch' */
  }

  /* End of Switch: '<S19>/Switch2' */

  /* S-Function (bur_in): '<Root>/Input15' */
  inst->bur_HiGlob_B.Input15 = inst->PredPmaxLimMax;

  /* Switch: '<S20>/Switch2' incorporates:
   *  RelationalOperator: '<S20>/LowerRelop1'
   */
  if (rtb_MinMax2 > inst->bur_HiGlob_B.Input15) {
    inst->bur_HiGlob_B.Switch2_j = inst->bur_HiGlob_B.Input15;
  } else {
    /* Switch: '<S20>/Switch' incorporates:
     *  Constant: '<S4>/Constant9'
     *  RelationalOperator: '<S20>/UpperRelop'
     */
    if (rtb_MinMax2 < 0.0F) {
      inst->bur_HiGlob_B.Switch2_j = 0.0F;
    } else {
      inst->bur_HiGlob_B.Switch2_j = rtb_MinMax2;
    }

    /* End of Switch: '<S20>/Switch' */
  }

  /* End of Switch: '<S20>/Switch2' */

  /* S-Function (bur_in): '<Root>/Input1' */
  inst->bur_HiGlob_B.Input1_p = inst->SkipCylNr;

  /* Gain: '<Root>/percent' incorporates:
   *  Product: '<Root>/Divide1'
   */
  rtb_percent = (real32_T)inst->bur_HiGlob_B.Input1_p / (real32_T)inst->bur_HiGlob_B.Input11 *
    100.0F;

  /* S-Function (sfix_bitop): '<Root>/Bitwise Operator' incorporates:
   *  Constant: '<S2>/Constant'
   *  RelationalOperator: '<S2>/Compare'
   */
  rtb_BitwiseOperator = !(rtb_percent > 0.0F);

  /* DiscreteIntegrator: '<S9>/Discrete-Time Integrator' */
  if (rtb_BitwiseOperator || (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRe_o != 0))
  {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i = 0.0F;
  }

  if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i >= 1.0E+6F) {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i = 1.0E+6F;
  } else {
    if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i <= 0.0F) {
      inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i = 0.0F;
    }
  }

  inst->bur_HiGlob_B.DiscreteTimeIntegrator = inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i;

  /* End of DiscreteIntegrator: '<S9>/Discrete-Time Integrator' */

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->SkipCountOut = inst->bur_HiGlob_B.DiscreteTimeIntegrator;

  /* S-Function (bur_in): '<Root>/Input5' */
  inst->bur_HiGlob_B.Input5 = inst->SkipRefRedLimMax;

  /* S-Function (bur_in): '<Root>/Input2' */
  inst->bur_HiGlob_B.Input2_f = inst->MaxCylSkipBefPowRed;

  /* Sum: '<Root>/Add2' */
  rtb_MinMax2 = rtb_percent - inst->bur_HiGlob_B.Input2_f;

  /* Switch: '<Root>/Switch2' incorporates:
   *  Constant: '<Root>/Constant2'
   *  Constant: '<S11>/Constant'
   *  RelationalOperator: '<S11>/Compare'
   */
  if (!(rtb_MinMax2 > 0.0F)) {
    rtb_MinMax2 = 0.0F;
  }

  /* End of Switch: '<Root>/Switch2' */

  /* S-Function (bur_in): '<Root>/Input4' */
  inst->bur_HiGlob_B.Input4_i = inst->MaxSkipDurBefRefRed;

  /* S-Function (bur_in): '<Root>/Input3' */
  inst->bur_HiGlob_B.Input3_a = inst->SkipCountLimMax;

  /* Switch: '<S7>/Switch2' incorporates:
   *  RelationalOperator: '<S7>/LowerRelop1'
   */
  if (inst->bur_HiGlob_B.DiscreteTimeIntegrator > inst->bur_HiGlob_B.Input3_a) {
    rtb_Divide_n = inst->bur_HiGlob_B.Input3_a;
  } else {
    /* Switch: '<S7>/Switch' incorporates:
     *  Constant: '<Root>/Constant7'
     *  RelationalOperator: '<S7>/UpperRelop'
     */
    if (inst->bur_HiGlob_B.DiscreteTimeIntegrator < 0.0F) {
      rtb_Divide_n = 0.0F;
    } else {
      rtb_Divide_n = inst->bur_HiGlob_B.DiscreteTimeIntegrator;
    }

    /* End of Switch: '<S7>/Switch' */
  }

  /* End of Switch: '<S7>/Switch2' */

  /* Switch: '<Root>/Switch1' incorporates:
   *  Constant: '<Root>/Constant8'
   *  Constant: '<S12>/Constant'
   *  RelationalOperator: '<S12>/Compare'
   *  Sum: '<Root>/Add4'
   */
  if (rtb_Divide_n - inst->bur_HiGlob_B.Input4_i > 0.0F) {
    rtb_Divide_n = rtb_percent;
  } else {
    rtb_Divide_n = 0.0F;
  }

  /* End of Switch: '<Root>/Switch1' */

  /* MinMax: '<Root>/MinMax2' */
  rtb_MinMax2 = rtb_MinMax2 >= rtb_Divide_n ? rtb_MinMax2 : rtb_Divide_n;

  /* Sum: '<Root>/Add3' incorporates:
   *  Constant: '<Root>/Constant4'
   *  Gain: '<Root>/SkipToPowRedGain'
   *  MinMax: '<Root>/MinMax2'
   */
  rtb_Divide_n = 100.0F - inst->SkipToPowRedGain * rtb_MinMax2;

  /* RelationalOperator: '<S5>/LowerRelop1' */
  rtb_LowerRelop1_l = (rtb_Divide_n > inst->bur_HiGlob_B.Input5);

  /* S-Function (bur_in): '<Root>/Input6' */
  inst->bur_HiGlob_B.Input6 = inst->SkipRefRedLimMin;

  /* Switch: '<S5>/Switch2' */
  if (rtb_LowerRelop1_l) {
    inst->bur_HiGlob_B.Switch2_d = inst->bur_HiGlob_B.Input5;
  } else {
    /* Switch: '<S5>/Switch' incorporates:
     *  RelationalOperator: '<S5>/UpperRelop'
     */
    if (rtb_Divide_n < inst->bur_HiGlob_B.Input6) {
      inst->bur_HiGlob_B.Switch2_d = inst->bur_HiGlob_B.Input6;
    } else {
      inst->bur_HiGlob_B.Switch2_d = rtb_Divide_n;
    }

    /* End of Switch: '<S5>/Switch' */
  }

  /* End of Switch: '<S5>/Switch2' */

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->RefPowUpLim = inst->bur_HiGlob_B.Switch2_d;

  /* S-Function (bur_in): '<Root>/Input14' */
  inst->bur_HiGlob_B.Input14 = inst->PowRedCylMax;

  /* MinMax: '<Root>/MinMax' */
  inst->bur_HiGlob_B.MinMax = inst->bur_HiGlob_B.Input14 >= inst->bur_HiGlob_B.Switch2_j ? inst->bur_HiGlob_B.Input14 :
    inst->bur_HiGlob_B.Switch2_j;

  /* RelationalOperator: '<S15>/Compare' incorporates:
   *  Constant: '<S15>/Constant'
   *  Sum: '<Root>/Add7'
   */
  rtb_LowerRelop1_l = (inst->bur_HiGlob_B.MinMax - inst->bur_HiGlob_B.Input15 > 0.0F);

  /* S-Function (bur_in): '<Root>/Input9' */
  inst->bur_HiGlob_B.Input9 = inst->MaxSkipDurBefStop;

  /* S-Function (bur_in): '<Root>/Input7' */
  inst->bur_HiGlob_B.Input7 = inst->SkipOvCountLimMax;

  /* S-Function (sfix_bitop): '<Root>/Bitwise Operator1' incorporates:
   *  Constant: '<S1>/Constant'
   *  MinMax: '<Root>/MinMax2'
   *  RelationalOperator: '<S1>/Compare'
   */
  rtb_BitwiseOperator1 = !(rtb_MinMax2 > 0.0F);

  /* DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
  if (rtb_BitwiseOperator1 || (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRe_n != 0))
  {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o = 0.0F;
  }

  if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o >= 1.0E+7F) {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o = 1.0E+7F;
  } else {
    if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o <= 0.0F) {
      inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o = 0.0F;
    }
  }

  /* End of DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */

  /* Switch: '<S8>/Switch2' incorporates:
   *  DiscreteIntegrator: '<S10>/Discrete-Time Integrator'
   *  RelationalOperator: '<S8>/LowerRelop1'
   */
  if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o > inst->bur_HiGlob_B.Input7) {
    rtb_Divide_n = inst->bur_HiGlob_B.Input7;
  } else {
    /* Switch: '<S8>/Switch' incorporates:
     *  Constant: '<Root>/Constant11'
     *  RelationalOperator: '<S8>/UpperRelop'
     */
    if ((real_T)inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o < 0.0) {
      rtb_Divide_n = 0.0F;
    } else {
      rtb_Divide_n = inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o;
    }

    /* End of Switch: '<S8>/Switch' */
  }

  /* End of Switch: '<S8>/Switch2' */

  /* RelationalOperator: '<S14>/Compare' incorporates:
   *  Constant: '<S14>/Constant'
   *  Sum: '<Root>/Add6'
   */
  rtb_Compare_jf = (rtb_Divide_n - inst->bur_HiGlob_B.Input9 > 0.0F);

  /* S-Function (bur_in): '<Root>/Input8' */
  inst->bur_HiGlob_B.Input8 = inst->MaxCylSkipBefStop;

  /* Logic: '<Root>/Logical Operator' incorporates:
   *  Constant: '<S13>/Constant'
   *  RelationalOperator: '<S13>/Compare'
   *  Sum: '<Root>/Add5'
   */
  inst->bur_HiGlob_B.LogicalOperator = ((rtb_LowerRelop1_l || rtb_Compare_jf ||
    (rtb_percent - inst->bur_HiGlob_B.Input8 > 0.0F)));

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->EngShutDwn = inst->bur_HiGlob_B.LogicalOperator;

  /* S-Function (bur_out): '<Root>/Output4' */
  inst->PowRefRedFin = inst->bur_HiGlob_B.MinMax;

  /* S-Function (bur_out): '<Root>/Output5' */
  inst->ITGlobOffsetPmax = inst->bur_HiGlob_B.Switch2;

  /* S-Function (bur_out): '<Root>/Output6' */
  inst->PowRefRedGlob = inst->bur_HiGlob_B.Switch2_j;

  /* Sum: '<Root>/Add1' incorporates:
   *  Constant: '<Root>/Constant'
   */
  rtb_Switch_o = (int16_T)(inst->bur_HiGlob_B.Input11 - 1);

  /* Switch: '<S6>/Switch2' incorporates:
   *  RelationalOperator: '<S6>/LowerRelop1'
   */
  if (!(inst->bur_HiGlob_B.Input1_p > rtb_Switch_o)) {
    /* Switch: '<S6>/Switch' incorporates:
     *  Constant: '<Root>/Constant1'
     *  RelationalOperator: '<S6>/UpperRelop'
     */
    if (inst->bur_HiGlob_B.Input1_p < 0) {
      rtb_Switch_o = 0;
    } else {
      rtb_Switch_o = inst->bur_HiGlob_B.Input1_p;
    }

    /* End of Switch: '<S6>/Switch' */
  }

  /* End of Switch: '<S6>/Switch2' */

  /* Sum: '<Root>/Add' */
  rtb_Switch_o = (int16_T)(inst->bur_HiGlob_B.Input11 - rtb_Switch_o);

  /* Product: '<Root>/Divide' */
  inst->bur_HiGlob_B.Divide = (real32_T)inst->bur_HiGlob_B.Input11 / (real32_T)rtb_Switch_o;

  /* S-Function (bur_out): '<Root>/Output9' */
  inst->LEANOXCor = inst->bur_HiGlob_B.Divide;

  /* S-Function (bur_in): '<Root>/Input16' */
  inst->bur_HiGlob_B.Input16 = inst->TSkipCount;

  /* S-Function (bur_in): '<Root>/Input17' */
  inst->bur_HiGlob_B.Input17 = inst->TSkipCount1;

  /* Update for DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */
  if (!inst->bur_HiGlob_B.Input12) {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE = (real32_T)(0.01 * rtb_Divide) +
      inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE;
    if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE >= 1000.0F) {
      inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE = 1000.0F;
    } else {
      if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE <= 0.0F) {
        inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE = 0.0F;
      }
    }
  }

  if (inst->bur_HiGlob_B.Input12) {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of DiscreteIntegrator: '<S17>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S9>/Discrete-Time Integrator' */
  if (!rtb_BitwiseOperator) {
    if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i >= 1.0E+6F) {
      inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i = 1.0E+6F;
    } else {
      if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i <= 0.0F) {
        inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_i = 0.0F;
      }
    }
  }

  if (rtb_BitwiseOperator) {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRe_o = 1;
  } else {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRe_o = 0;
  }

  /* End of DiscreteIntegrator: '<S9>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
  if (!rtb_BitwiseOperator1) {
    if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o >= 1.0E+7F) {
      inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o = 1.0E+7F;
    } else {
      if (inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o <= 0.0F) {
        inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_DSTATE_o = 0.0F;
      }
    }
  }

  if (rtb_BitwiseOperator1) {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRe_n = 1;
  } else {
    inst->bur_HiGlob_DWork.DiscreteTimeIntegrator_PrevRe_n = 0;
  }

  /* End of DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
}

/* Model initialize function */
void HiGlob_initialize(struct HiGlob* inst)
{
  /* (no initialization code required) */
}

/* Model terminate function */
void HiGlob_terminate(struct HiGlob* inst)
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
