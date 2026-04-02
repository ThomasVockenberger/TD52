/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: HiContr
 * File: HiContr.c
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Implementation of program HiContr
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "HiContr.h"
#include "HiContr_private.h"

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
void HiContr_step(struct HiContr* inst)
{
  /* local block i/o variables */
  boolean_T rtb_Compare_j;
  real32_T rtb_Switch1;
  boolean_T rtb_Compare;
  boolean_T rtb_LogicalOperator6;
  real32_T rtb_invert;
  boolean_T rtb_LogicalOperator3;
  real_T rtb_Divide3_g;
  real32_T rtb_MathFunction[100];
  real32_T rtb_Sum;
  real32_T rtb_Divide2;
  real32_T rtb_Add7;
  boolean_T rtb_LogicalOperator1;
  boolean_T rtb_LogicalOperator11;
  boolean_T rtb_LogicalOperator;
  boolean_T rtb_BitwiseOperator2;
  boolean_T rtb_BitwiseOperator1;
  real32_T rtb_Add8;
  real_T rtb_Divide3_d;
  real_T rtb_Divide3_p;
  real_T rtb_Add;
  int32_T i;
  int16_T tmp;

  /* S-Function (bur_in): '<S1>/Input17' */
  inst->bur_HiContr_B.Input17 = inst->GIThPIDUR;

  /* S-Function (bur_in): '<Root>/Input5' */
  inst->bur_HiContr_B.Input5_c = inst->EngStopErrAck;

  /* DiscreteIntegrator: '<S5>/Discrete-Time Integrator' */
  if (inst->bur_HiContr_B.Input5_c || (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRese != 0))
  {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE >= 100.0F) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE = 100.0F;
  } else {
    if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE <= 0.0F) {
      inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE = 0.0F;
    }
  }

  inst->bur_HiContr_B.DiscreteTimeIntegrator = inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE;

  /* End of DiscreteIntegrator: '<S5>/Discrete-Time Integrator' */

  /* Sum: '<S1>/Add5' */
  rtb_Switch1 = inst->bur_HiContr_B.DiscreteTimeIntegrator - inst->bur_HiContr_B.Input17;

  /* S-Function (bur_in): '<Root>/Input9' */
  inst->bur_HiContr_B.Input9_a = inst->GIContrEnable;

  /* Logic: '<S1>/Logical Operator6' incorporates:
   *  Constant: '<S16>/Constant'
   *  RelationalOperator: '<S16>/Compare'
   */
  rtb_LogicalOperator6 = ((rtb_Switch1 > 0.0F) && inst->bur_HiContr_B.Input9_a);

  /* Switch: '<S1>/Switch2' incorporates:
   *  Constant: '<S1>/Constant2'
   */
  if (!rtb_LogicalOperator6) {
    rtb_Switch1 = 0.0F;
  }

  /* End of Switch: '<S1>/Switch2' */

  /* Gain: '<S1>/invert' incorporates:
   *  Gain: '<S1>/GIGain (%*100cycles//events)'
   */
  rtb_invert = -(inst->GIGain * rtb_Switch1);

  /* S-Function (bur_in): '<S1>/Input13' */
  inst->bur_HiContr_B.Input13 = inst->GIPIDURLimMin;

  /* Switch: '<S12>/Switch2' incorporates:
   *  Constant: '<S1>/Constant6'
   *  RelationalOperator: '<S12>/LowerRelop1'
   *  RelationalOperator: '<S12>/UpperRelop'
   *  Switch: '<S12>/Switch'
   */
  if (rtb_invert > 0.0F) {
    inst->bur_HiContr_B.Switch2 = 0.0F;
  } else if (rtb_invert < inst->bur_HiContr_B.Input13) {
    /* Switch: '<S12>/Switch' */
    inst->bur_HiContr_B.Switch2 = inst->bur_HiContr_B.Input13;
  } else {
    inst->bur_HiContr_B.Switch2 = rtb_invert;
  }

  /* End of Switch: '<S12>/Switch2' */

  /* S-Function (bur_out): '<S1>/Output1' */
  inst->PIDUROffsetGI = inst->bur_HiContr_B.Switch2;

  /* S-Function (bur_in): '<S1>/Input11' */
  inst->bur_HiContr_B.Input11 = inst->MFPIDURLimMax;

  /* S-Function (bur_in): '<S1>/Input14' */
  inst->bur_HiContr_B.Input14 = inst->MFThPIDUR;

  /* DiscreteIntegrator: '<S6>/Discrete-Time Integrator' */
  if (inst->bur_HiContr_B.Input5_c || (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_f != 0))
  {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e = 0.0F;
  }

  if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e >= 100.0F) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e = 100.0F;
  } else {
    if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e <= 0.0F) {
      inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e = 0.0F;
    }
  }

  inst->bur_HiContr_B.DiscreteTimeIntegrator_d =
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e;

  /* End of DiscreteIntegrator: '<S6>/Discrete-Time Integrator' */

  /* Sum: '<S1>/Add2' */
  rtb_Switch1 = inst->bur_HiContr_B.DiscreteTimeIntegrator_d - inst->bur_HiContr_B.Input14;

  /* S-Function (bur_in): '<Root>/Input7' */
  inst->bur_HiContr_B.Input7_c = inst->MFContrEnable;

  /* Logic: '<S1>/Logical Operator3' incorporates:
   *  Constant: '<S14>/Constant'
   *  RelationalOperator: '<S14>/Compare'
   */
  rtb_LogicalOperator3 = ((rtb_Switch1 > 0.0F) && inst->bur_HiContr_B.Input7_c);

  /* Switch: '<S1>/Switch' incorporates:
   *  Constant: '<S1>/Constant'
   */
  if (!rtb_LogicalOperator3) {
    rtb_Switch1 = 0.0F;
  }

  /* End of Switch: '<S1>/Switch' */

  /* Gain: '<S1>/MFGain (%*100cycles//events)' */
  rtb_invert = inst->MFGain * rtb_Switch1;

  /* Switch: '<S9>/Switch2' incorporates:
   *  Constant: '<S1>/Constant7'
   *  RelationalOperator: '<S9>/LowerRelop1'
   *  RelationalOperator: '<S9>/UpperRelop'
   *  Switch: '<S9>/Switch'
   */
  if (rtb_invert > inst->bur_HiContr_B.Input11) {
    inst->bur_HiContr_B.Switch2_e = inst->bur_HiContr_B.Input11;
  } else if (rtb_invert < 0.0F) {
    /* Switch: '<S9>/Switch' incorporates:
     *  Constant: '<S1>/Constant7'
     */
    inst->bur_HiContr_B.Switch2_e = 0.0F;
  } else {
    inst->bur_HiContr_B.Switch2_e = rtb_invert;
  }

  /* End of Switch: '<S9>/Switch2' */

  /* S-Function (bur_out): '<S1>/Output2' */
  inst->PIDUROffsetMF = inst->bur_HiContr_B.Switch2_e;

  /* S-Function (bur_out): '<S1>/Output3' */
  inst->MFIntOut = inst->bur_HiContr_B.DiscreteTimeIntegrator_d;

  /* DiscreteIntegrator: '<S21>/Discrete-Time Integrator' */
  if (inst->bur_HiContr_B.Input5_c || (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_c != 0))
  {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c = 0.0F;
  }

  if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c >= 100.0F) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c = 100.0F;
  } else {
    if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c <= 0.0F) {
      inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c = 0.0F;
    }
  }

  inst->bur_HiContr_B.DiscreteTimeIntegrator_l =
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c;

  /* End of DiscreteIntegrator: '<S21>/Discrete-Time Integrator' */

  /* S-Function (bur_out): '<S1>/Output4' */
  inst->WCIntOut = inst->bur_HiContr_B.DiscreteTimeIntegrator_l;

  /* S-Function (bur_out): '<S1>/Output5' */
  inst->GIIntOut = inst->bur_HiContr_B.DiscreteTimeIntegrator;

  /* S-Function (bur_in): '<Root>/Input10' */
  inst->bur_HiContr_B.Input10_h = inst->PmaxLimContrEnable;

  /* S-Function (bur_in): '<Root>/Input11' */
  inst->bur_HiContr_B.Input11_h = inst->PmaxLimDiane;

  /* S-Function (bur_in): '<S1>/Input7' */
  inst->bur_HiContr_B.Input7 = inst->PmaxSDLimMar;

  /* Sum: '<S1>/Subtract' */
  rtb_invert = inst->bur_HiContr_B.Input11_h - inst->bur_HiContr_B.Input7;

  /* Sum: '<S8>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S8>/Tapped Delay set as N_cyc!!!'
   */
  rtb_Divide3_g = inst->bur_HiContr_DWork.TappedDelaysetasN_cyc_X[0];
  for (i = 0; i < 99; i++) {
    rtb_Divide3_g += (real_T)inst->bur_HiContr_DWork.TappedDelaysetasN_cyc_X[i + 1];
  }

  /* End of Sum: '<S8>/Sum of Elements' */

  /* Product: '<S8>/Divide' incorporates:
   *  Constant: '<S8>/set as Ncyc!!!'
   */
  inst->bur_HiContr_B.Divide = (real32_T)(rtb_Divide3_g / 100.0);

  /* Math: '<S8>/Math Function'
   *
   * About '<S8>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S8>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S8>/Tapped Delay set as N_cyc!!!'
     */
    rtb_Switch1 = inst->bur_HiContr_DWork.TappedDelaysetasN_cyc_X[i] - inst->bur_HiContr_B.Divide;
    rtb_MathFunction[i] = rtb_Switch1 * rtb_Switch1;
  }

  /* End of Math: '<S8>/Math Function' */

  /* Sum: '<S8>/Sum of Elements2' */
  rtb_Switch1 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_Switch1 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S8>/Sum of Elements2' */

  /* Sqrt: '<S8>/Sqrt' incorporates:
   *  Constant: '<S8>/set as Ncyc!!!'
   *  Product: '<S8>/Divide1'
   */
  inst->bur_HiContr_B.Sqrt = (real32_T)sqrt((real32_T)((real_T)rtb_Switch1 / 100.0));

  /* S-Function (bur_in): '<S1>/Input8' */
  inst->bur_HiContr_B.Input8 = inst->PmaxStdevFact;

  /* Sum: '<S1>/Sum' incorporates:
   *  Product: '<S1>/Product2'
   *  Sum: '<S1>/Add'
   */
  rtb_Sum = rtb_invert - (inst->bur_HiContr_B.Sqrt * inst->bur_HiContr_B.Input8 + inst->bur_HiContr_B.Divide);

  /* S-Function (bur_in): '<S1>/Input9' */
  inst->bur_HiContr_B.Input9 = inst->PmaxContrGain;

  /* Product: '<S1>/Product1' incorporates:
   *  Product: '<S1>/Product3'
   */
  rtb_invert = inst->bur_HiContr_B.Input10_h ? rtb_Sum * inst->bur_HiContr_B.Input9 : 0.0F;

  /* S-Function (bur_in): '<S1>/Input10' */
  inst->bur_HiContr_B.Input10 = inst->PmaxContrLimMin;

  /* Switch: '<S10>/Switch2' incorporates:
   *  Constant: '<S1>/Constant4'
   *  RelationalOperator: '<S10>/LowerRelop1'
   *  RelationalOperator: '<S10>/UpperRelop'
   *  Switch: '<S10>/Switch'
   */
  if (rtb_invert > 0.0F) {
    inst->bur_HiContr_B.Switch2_k = 0.0F;
  } else if (rtb_invert < inst->bur_HiContr_B.Input10) {
    /* Switch: '<S10>/Switch' */
    inst->bur_HiContr_B.Switch2_k = inst->bur_HiContr_B.Input10;
  } else {
    inst->bur_HiContr_B.Switch2_k = rtb_invert;
  }

  /* End of Switch: '<S10>/Switch2' */

  /* S-Function (bur_out): '<S1>/Output6' */
  inst->PIDUROffsetPmax = inst->bur_HiContr_B.Switch2_k;

  /* S-Function (bur_in): '<S1>/Input19' */
  inst->bur_HiContr_B.Input19 = inst->GIThSkipReset;

  /* RelationalOperator: '<S18>/Compare' incorporates:
   *  Constant: '<S18>/Constant'
   *  Sum: '<S1>/Add1'
   */
  rtb_Compare_j = (inst->bur_HiContr_B.DiscreteTimeIntegrator - inst->bur_HiContr_B.Input19 < 0.0F);

  /* DiscreteIntegrator: '<S4>/Discrete-Time Integrator' */
  if (rtb_Compare_j || (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_n != 0)) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n = 0.0F;
  }

  if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n >= 100.0F) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n = 100.0F;
  } else {
    if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n <= 0.0F) {
      inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n = 0.0F;
    }
  }

  inst->bur_HiContr_B.DiscreteTimeIntegrator_dl =
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n;

  /* End of DiscreteIntegrator: '<S4>/Discrete-Time Integrator' */

  /* S-Function (bur_out): '<S1>/Output7' */
  inst->GICountOut = inst->bur_HiContr_B.DiscreteTimeIntegrator_dl;

  /* S-Function (bur_out): '<S1>/Output8' */
  inst->PmaxAv = inst->bur_HiContr_B.Divide;

  /* S-Function (bur_out): '<S1>/Output9' */
  inst->PmaxStd = inst->bur_HiContr_B.Sqrt;

  /* S-Function (bur_in): '<S1>/Input16' */
  inst->bur_HiContr_B.Input16 = inst->WCThPmax;

  /* Sum: '<S1>/Add4' */
  rtb_Switch1 = inst->bur_HiContr_B.DiscreteTimeIntegrator_l - inst->bur_HiContr_B.Input16;

  /* S-Function (bur_in): '<S1>/Input18' */
  inst->bur_HiContr_B.Input18 = inst->GIThSkip;

  /* Sum: '<S1>/Add6' */
  rtb_invert = inst->bur_HiContr_B.DiscreteTimeIntegrator - inst->bur_HiContr_B.Input18;

  /* S-Function (bur_in): '<S1>/Input21' */
  inst->bur_HiContr_B.Input21 = inst->GIThCount;

  /* Sum: '<S1>/Add7' */
  rtb_Add7 = inst->bur_HiContr_B.DiscreteTimeIntegrator_dl - inst->bur_HiContr_B.Input21;

  /* Relay: '<S1>/Relay1' */
  if (inst->bur_HiContr_B.DiscreteTimeIntegrator_d >= inst->MFThSkipOn) {
    inst->bur_HiContr_DWork.Relay1_Mode = TRUE;
  } else {
    if (inst->bur_HiContr_B.DiscreteTimeIntegrator_d <= inst->MFThSkipOff) {
      inst->bur_HiContr_DWork.Relay1_Mode = FALSE;
    }
  }

  if (inst->bur_HiContr_DWork.Relay1_Mode) {
    rtb_Divide2 = 1.0F;
  } else {
    rtb_Divide2 = 0.0F;
  }

  /* End of Relay: '<S1>/Relay1' */

  /* Sum: '<S1>/Add8' incorporates:
   *  Constant: '<S1>/Constant3'
   *  Gain: '<S1>/MF_Gain_Skip_Tdown'
   */
  rtb_Add8 = inst->MFGainSkipTdown * rtb_Divide2 + 1.0F;

  /* S-Function (bur_in): '<Root>/Input1' */
  inst->bur_HiContr_B.Input1_h = inst->Misfire2;

  /* S-Function (sfix_bitop): '<S1>/Bitwise Operator' */
  rtb_Compare = !inst->bur_HiContr_B.Input1_h;

  /* S-Function (bur_in): '<Root>/Input20' */
  inst->bur_HiContr_B.Input20_o = inst->Misfire1;

  /* S-Function (sfix_bitop): '<S1>/Bitwise Operator1' */
  rtb_BitwiseOperator1 = !inst->bur_HiContr_B.Input20_o;

  /* RelationalOperator: '<S19>/Compare' incorporates:
   *  Constant: '<S19>/Constant'
   */
  rtb_LogicalOperator1 = (rtb_Add7 > 0.0F);

  /* S-Function (sfix_bitop): '<S1>/Bitwise Operator2' */
  rtb_BitwiseOperator2 = !rtb_LogicalOperator1;

  /* S-Function (bur_in): '<Root>/Input4' */
  inst->bur_HiContr_B.Input4_d = inst->SensSignFault;

  /* S-Function (sfix_bitop): '<S1>/Bitwise Operator3' */
  rtb_LogicalOperator = !inst->bur_HiContr_B.Input4_d;

  /* S-Function (bur_in): '<S1>/Input6' */
  inst->bur_HiContr_B.Input6 = inst->TGICount;

  /* Logic: '<S1>/Logical Operator9' incorporates:
   *  Constant: '<S17>/Constant'
   *  RelationalOperator: '<S17>/Compare'
   */
  rtb_LogicalOperator11 = (inst->bur_HiContr_B.Input9_a && (rtb_invert > 0.0F));

  /* Sum: '<S4>/Add' incorporates:
   *  Constant: '<S1>/Constant9'
   *  Product: '<S4>/Divide'
   *  Product: '<S4>/Divide2'
   */
  rtb_Add = rtb_LogicalOperator11 ? 1.0 / (real_T)inst->bur_HiContr_B.Input6 : 0.0;

  /* Switch: '<S1>/Switch3' incorporates:
   *  Constant: '<S1>/Constant12'
   *  Logic: '<S1>/Logical Operator10'
   */
  if (rtb_LogicalOperator1 && inst->bur_HiContr_B.Input9_a) {
    /* Switch: '<S13>/Switch2' incorporates:
     *  Constant: '<S1>/Constant10'
     *  Constant: '<S1>/Constant11'
     *  RelationalOperator: '<S13>/LowerRelop1'
     *  RelationalOperator: '<S13>/UpperRelop'
     *  Switch: '<S13>/Switch'
     */
    if (rtb_invert > 100.0F) {
      rtb_invert = 100.0F;
    } else {
      if (rtb_invert < 0.0F) {
        /* Switch: '<S13>/Switch' incorporates:
         *  Constant: '<S1>/Constant10'
         */
        rtb_invert = 0.0F;
      }
    }

    /* End of Switch: '<S13>/Switch2' */
  } else {
    rtb_invert = 0.0F;
  }

  /* End of Switch: '<S1>/Switch3' */

  /* Gain: '<S1>/GIPowGain (%Pnom*100cycles//events)' */
  inst->bur_HiContr_B.GIPowGainPnom100cyclesevents = inst->GIPowGain * rtb_invert;

  /* S-Function (bur_in): '<S1>/Input5' */
  inst->bur_HiContr_B.Input5 = inst->TdownGI;

  /* Product: '<S5>/Divide1' incorporates:
   *  Constant: '<S5>/Constant'
   */
  rtb_Divide3_g = 1.0 / (real_T)inst->bur_HiContr_B.Input5;

  /* S-Function (bur_in): '<Root>/Input2' */
  inst->bur_HiContr_B.Input2_g = inst->GlowIgn;

  /* S-Function (bur_in): '<S1>/Input4' */
  inst->bur_HiContr_B.Input4 = inst->TupGI;

  /* Sum: '<S5>/Add' incorporates:
   *  Product: '<S5>/Divide'
   *  Product: '<S5>/Divide2'
   *  Product: '<S5>/Divide3'
   */
  rtb_Divide3_g = (real_T)(rtb_LogicalOperator ? (real32_T)inst->bur_HiContr_B.Input2_g /
    inst->bur_HiContr_B.Input4 : 0.0F) - (rtb_LogicalOperator ? rtb_Divide3_g : 0.0);

  /* S-Function (bur_in): '<S1>/Input1' */
  inst->bur_HiContr_B.Input1 = inst->TdownMF;

  /* S-Function (bur_in): '<S1>/Input12' */
  inst->bur_HiContr_B.Input12 = inst->WCPmaxLimMax;

  /* S-Function (bur_in): '<S1>/Input2' */
  inst->bur_HiContr_B.Input2 = inst->TupWC;

  /* S-Function (bur_in): '<S1>/Input20' */
  inst->bur_HiContr_B.Input20 = inst->TupMF;

  /* S-Function (bur_in): '<S1>/Input3' */
  inst->bur_HiContr_B.Input3 = inst->TdownWC;

  /* Logic: '<S1>/Logical Operator' */
  rtb_LogicalOperator = (inst->bur_HiContr_B.Input20_o && inst->bur_HiContr_B.Input1_h);

  /* Logic: '<S1>/Logical Operator1' */
  rtb_LogicalOperator1 = (inst->bur_HiContr_B.Input20_o && rtb_Compare);

  /* S-Function (bur_in): '<Root>/Input6' */
  inst->bur_HiContr_B.Input6_a = inst->KnockCountMeasAct;

  /* Relay: '<S1>/Relay' */
  if (rtb_Sum >= inst->PmaxLimReaHys) {
    inst->bur_HiContr_DWork.Relay_Mode = TRUE;
  } else {
    if (rtb_Sum <= 0.0F) {
      inst->bur_HiContr_DWork.Relay_Mode = FALSE;
    }
  }

  if (inst->bur_HiContr_DWork.Relay_Mode) {
    tmp = 0;
  } else {
    tmp = 1;
  }

  /* End of Relay: '<S1>/Relay' */

  /* RelationalOperator: '<S20>/Compare' incorporates:
   *  Constant: '<S20>/Constant'
   */
  inst->bur_HiContr_B.Compare = (tmp > 0);

  /* Logic: '<S1>/Logical Operator13' incorporates:
   *  Logic: '<S1>/Logical Operator14'
   *  Logic: '<S1>/Logical Operator5'
   */
  inst->bur_HiContr_B.LogicalOperator13 = ((inst->bur_HiContr_B.Input7_c && (rtb_Divide2 != 0.0F)) ||
                                 (rtb_LogicalOperator11 && rtb_BitwiseOperator2));

  /* S-Function (bur_in): '<Root>/Input12' */
  inst->bur_HiContr_B.Input12_e = inst->SkipCylExt;

  /* Logic: '<S1>/Logical Operator11' incorporates:
   *  Logic: '<S1>/Logical Operator12'
   */
  rtb_LogicalOperator11 = !(inst->bur_HiContr_B.Input6_a || rtb_LogicalOperator6 ||
    inst->bur_HiContr_B.Compare || inst->bur_HiContr_B.Input4_d || (inst->bur_HiContr_B.LogicalOperator13 ||
    inst->bur_HiContr_B.Input12_e));

  /* Logic: '<S1>/Logical Operator2' */
  inst->bur_HiContr_B.LogicalOperator2 = (rtb_BitwiseOperator1 && inst->bur_HiContr_B.Input1_h);

  /* S-Function (bur_in): '<Root>/Input8' */
  inst->bur_HiContr_B.Input8_f = inst->WCContrEnable;

  /* Logic: '<S1>/Logical Operator7' */
  inst->bur_HiContr_B.LogicalOperator7 = (rtb_LogicalOperator3 || rtb_LogicalOperator6 ||
    inst->bur_HiContr_B.Compare || inst->bur_HiContr_B.Input4_d);

  /* Logic: '<S1>/Logical Operator8' */
  inst->bur_HiContr_B.LogicalOperator8 = (rtb_LogicalOperator3 || rtb_LogicalOperator6 ||
    inst->bur_HiContr_B.Compare || inst->bur_HiContr_B.Input4_d);

  /* MinMax: '<S1>/MinMax' */
  if (inst->bur_HiContr_B.Switch2_k <= inst->bur_HiContr_B.Switch2) {
    rtb_Add7 = inst->bur_HiContr_B.Switch2_k;
  } else {
    rtb_Add7 = inst->bur_HiContr_B.Switch2;
  }

  /* Product: '<S6>/Divide3' incorporates:
   *  Constant: '<S6>/Constant'
   *  Product: '<S1>/Product'
   *  Product: '<S6>/Divide1'
   */
  rtb_Divide3_d = 1.0 / (real_T)(inst->bur_HiContr_B.Input1 * rtb_Add8);

  /* Product: '<S6>/Divide2' incorporates:
   *  Product: '<S6>/Divide'
   */
  rtb_Divide2 = rtb_LogicalOperator11 ? (real32_T)rtb_LogicalOperator /
    inst->bur_HiContr_B.Input20 : 0.0F;

  /* Switch: '<S1>/Switch1' incorporates:
   *  Constant: '<S15>/Constant'
   *  Constant: '<S1>/Constant1'
   *  Logic: '<S1>/Logical Operator4'
   *  RelationalOperator: '<S15>/Compare'
   */
  if (!((rtb_Switch1 > 0.0F) && inst->bur_HiContr_B.Input8_f)) {
    rtb_Switch1 = 0.0F;
  }

  /* End of Switch: '<S1>/Switch1' */

  /* Gain: '<S1>/scaling relative to  Pmax at full load (%//bar)' incorporates:
   *  Gain: '<S1>/WCGain (bar*100cycles//events)'
   */
  rtb_invert = inst->WCGain * rtb_Switch1 * inst->WCScaling;

  /* Switch: '<S11>/Switch2' incorporates:
   *  Constant: '<S1>/Constant8'
   *  RelationalOperator: '<S11>/LowerRelop1'
   *  RelationalOperator: '<S11>/UpperRelop'
   *  Switch: '<S11>/Switch'
   */
  if (rtb_invert > inst->bur_HiContr_B.Input12) {
    inst->bur_HiContr_B.Switch2_a = inst->bur_HiContr_B.Input12;
  } else if (rtb_invert < 0.0F) {
    /* Switch: '<S11>/Switch' incorporates:
     *  Constant: '<S1>/Constant8'
     */
    inst->bur_HiContr_B.Switch2_a = 0.0F;
  } else {
    inst->bur_HiContr_B.Switch2_a = rtb_invert;
  }

  /* End of Switch: '<S11>/Switch2' */

  /* Switch: '<S1>/Switch4' incorporates:
   *  MinMax: '<S1>/MinMax'
   */
  if (rtb_Add7 >= 0.0F) {
    inst->bur_HiContr_B.Switch4 = inst->bur_HiContr_B.Switch2_e;
  } else {
    inst->bur_HiContr_B.Switch4 = rtb_Add7;
  }

  /* End of Switch: '<S1>/Switch4' */

  /* Product: '<S21>/Divide3' incorporates:
   *  Constant: '<S21>/Constant'
   *  Product: '<S21>/Divide1'
   */
  rtb_Divide3_p = 1.0 / (real_T)inst->bur_HiContr_B.Input3;

  /* Product: '<S21>/Divide2' incorporates:
   *  Product: '<S21>/Divide'
   */
  rtb_invert = rtb_LogicalOperator11 ? (real32_T)rtb_LogicalOperator1 /
    inst->bur_HiContr_B.Input2 : 0.0F;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->FaultMFSign = inst->bur_HiContr_B.LogicalOperator2;

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->MFB50Freeze = inst->bur_HiContr_B.LogicalOperator7;

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->OptPIDFreeze = inst->bur_HiContr_B.LogicalOperator8;

  /* S-Function (bur_out): '<Root>/Output4' */
  inst->PIDUROffsetCyl = inst->bur_HiContr_B.Switch4;

  /* S-Function (bur_out): '<Root>/Output6' */
  inst->PmaxStabLayOffset = inst->bur_HiContr_B.Switch2_a;

  /* S-Function (bur_out): '<Root>/Output7' */
  inst->PmaxLimReached = inst->bur_HiContr_B.Compare;

  /* S-Function (bur_out): '<Root>/Output8' */
  inst->SkipCyl = inst->bur_HiContr_B.LogicalOperator13;

  /* S-Function (bur_out): '<Root>/Output9' */
  inst->PowRedCyl = inst->bur_HiContr_B.GIPowGainPnom100cyclesevents;

  /* S-Function (bur_in): '<Root>/Input3' */
  inst->bur_HiContr_B.Input3_g = inst->Pmax;

  /* Update for DiscreteIntegrator: '<S5>/Discrete-Time Integrator' */
  if (!inst->bur_HiContr_B.Input5_c) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE += (real32_T)(0.01 *
      rtb_Divide3_g);
    if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE >= 100.0F) {
      inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE = 100.0F;
    } else {
      if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE <= 0.0F) {
        inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE = 0.0F;
      }
    }
  }

  if (inst->bur_HiContr_B.Input5_c) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S5>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S6>/Discrete-Time Integrator' incorporates:
   *  Sum: '<S6>/Add'
   */
  if (!inst->bur_HiContr_B.Input5_c) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e += (real32_T)(((real_T)
      rtb_Divide2 - rtb_Divide3_d) * 0.01);
    if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e >= 100.0F) {
      inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e = 100.0F;
    } else {
      if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e <= 0.0F) {
        inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_e = 0.0F;
      }
    }
  }

  if (inst->bur_HiContr_B.Input5_c) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_f = 1;
  } else {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_f = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S6>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S21>/Discrete-Time Integrator' incorporates:
   *  Sum: '<S21>/Add'
   */
  if (!inst->bur_HiContr_B.Input5_c) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c += (real32_T)(((real_T)
      rtb_invert - rtb_Divide3_p) * 0.01);
    if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c >= 100.0F) {
      inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c = 100.0F;
    } else {
      if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c <= 0.0F) {
        inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_c = 0.0F;
      }
    }
  }

  if (inst->bur_HiContr_B.Input5_c) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_c = 1;
  } else {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_c = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S21>/Discrete-Time Integrator' */

  /* Update for S-Function (sfix_udelay): '<S8>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    inst->bur_HiContr_DWork.TappedDelaysetasN_cyc_X[i] =
      inst->bur_HiContr_DWork.TappedDelaysetasN_cyc_X[i + 1];
  }

  inst->bur_HiContr_DWork.TappedDelaysetasN_cyc_X[99] = inst->bur_HiContr_B.Input3_g;

  /* End of Update for S-Function (sfix_udelay): '<S8>/Tapped Delay set as N_cyc!!!' */

  /* Update for DiscreteIntegrator: '<S4>/Discrete-Time Integrator' */
  if (!rtb_Compare_j) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n += (real32_T)(0.01 * rtb_Add);
    if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n >= 100.0F) {
      inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n = 100.0F;
    } else {
      if (inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n <= 0.0F) {
        inst->bur_HiContr_DWork.DiscreteTimeIntegrator_DSTATE_n = 0.0F;
      }
    }
  }

  if (rtb_Compare_j) {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_n = 1;
  } else {
    inst->bur_HiContr_DWork.DiscreteTimeIntegrator_PrevRe_n = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S4>/Discrete-Time Integrator' */
}

/* Model initialize function */
void HiContr_initialize(struct HiContr* inst)
{
  /* (no initialization code required) */
}

/* Model terminate function */
void HiContr_terminate(struct HiContr* inst)
{
  /* (no terminate code required) */
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 8.0 (R2012b)20-Jul-2012                                             *
 * Simulink 8.0 (R2012b)20-Jul-2012                                           *
 * Simulink Coder 8.3 (R2012b)20-Jul-2012                                     *
 * Embedded Coder 6.3 (R2012b)20-Jul-2012                                     *
 * Stateflow 8.0 (R2012b)20-Jul-2012                                          *
 * Simulink Fixed Point 7.2 (R2012b)20-Jul-2012                               *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
