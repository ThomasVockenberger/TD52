/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LambdaAdp
 * File: LambdaAdp.c
 * Author: 105051472
 * Created: Wed Oct 29 12:06:16 2014
 ********************************************************************
 * Implementation of program LambdaAdp
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "LambdaAdp.h"
#include "LambdaAdp_private.h"

/*  Defines */

/* Named constants for Chart: '<S1>/Lambda_Active' */
#define LambdaAdp_IN_Lambda_Corr_OFF   ((uint8_T)1U)
#define LambdaAdp_IN_Lambda_Corr_ON    ((uint8_T)2U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */
struct BlockIO_LambdaAdp LambdaAdp_B;

/* Block states (auto storage) */
struct D_Work_LambdaAdp LambdaAdp_DWork;

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void LambdaAdp_step(struct lLamCorr* inst)
{
  real32_T rtb_Divide;
  real32_T rtb_Yk1;

  /* S-Function (bur_in): '<Root>/Input4' */
  LambdaAdp_B.Input4 = inst->bLambda_Corr_Enable;

  /* S-Function (bur_in): '<Root>/Input1' */
  LambdaAdp_B.Input1 = inst->rP_Rot;

  /* S-Function (bur_in): '<Root>/Input2' */
  LambdaAdp_B.Input2 = inst->rN_Eng;

  /* S-Function (bur_in): '<Root>/Input3' */
  LambdaAdp_B.Input3 = inst->rLam_OffsLimit_Neg;

  /* Outputs for Atomic SubSystem: '<Root>/LambdaAdaption' */
  /* Product: '<S1>/Divide' incorporates:
   *  Constant: '<S1>/inst->rP_Nom'
   */
  rtb_Divide = LambdaAdp_B.Input1 / inst->rP_Nom;

  /* Product: '<S1>/Divide1' incorporates:
   *  Constant: '<S1>/inst->rN_Set'
   *  Sum: '<S1>/Subtract'
   */
  rtb_Yk1 = (LambdaAdp_B.Input2 - inst->rN_Set) / inst->rN_Set;

  /* RelationalOperator: '<S1>/Relational Operator2' incorporates:
   *  Constant: '<S1>/no_limit1'
   */
  LambdaAdp_B.RelationalOperator2 = (rtb_Yk1 <= 0.0F);

  /* RelationalOperator: '<S1>/Relational Operator' incorporates:
   *  Constant: '<S1>/inst->rP_Rot_Norm_Lam_Trig'
   */
  LambdaAdp_B.RelationalOperator = (rtb_Divide >= inst->rP_Rot_Norm_Lam_Trig);

  /* RelationalOperator: '<S1>/Relational Operator1' incorporates:
   *  Constant: '<S1>/inst->rN_Delta_Lim'
   */
  LambdaAdp_B.RelationalOperator1 = (rtb_Yk1 <= inst->rN_Delta_Lim);

  /* Chart: '<S1>/Lambda_Active' */
  /* Gateway: LambdaAdaption/Lambda_Active */
  /* During: LambdaAdaption/Lambda_Active */
  if (LambdaAdp_DWork.is_active_c1_LambdaAdp == 0U) {
    /* Entry: LambdaAdaption/Lambda_Active */
    LambdaAdp_DWork.is_active_c1_LambdaAdp = 1U;

    /* Entry Internal: LambdaAdaption/Lambda_Active */
    /* Transition: '<S2>:3' */
    LambdaAdp_DWork.is_c1_LambdaAdp = LambdaAdp_IN_Lambda_Corr_OFF;

    /* Entry 'Lambda_Corr_OFF': '<S2>:2' */
    LambdaAdp_B.bLambda_Corr_Act = FALSE;
  } else if (LambdaAdp_DWork.is_c1_LambdaAdp == LambdaAdp_IN_Lambda_Corr_OFF) {
    /* During 'Lambda_Corr_OFF': '<S2>:2' */
    if (LambdaAdp_B.RelationalOperator && LambdaAdp_B.RelationalOperator2 &&
        LambdaAdp_B.Input4) {
      /* Transition: '<S2>:4' */
      LambdaAdp_DWork.is_c1_LambdaAdp = LambdaAdp_IN_Lambda_Corr_ON;

      /* Entry 'Lambda_Corr_ON': '<S2>:6' */
      LambdaAdp_B.bLambda_Corr_Act = TRUE;
    }
  } else {
    /* During 'Lambda_Corr_ON': '<S2>:6' */
    if ((!LambdaAdp_B.RelationalOperator1) && (!LambdaAdp_B.RelationalOperator))
    {
      /* Transition: '<S2>:5' */
      LambdaAdp_DWork.is_c1_LambdaAdp = LambdaAdp_IN_Lambda_Corr_OFF;

      /* Entry 'Lambda_Corr_OFF': '<S2>:2' */
      LambdaAdp_B.bLambda_Corr_Act = FALSE;
    }
  }

  /* End of Chart: '<S1>/Lambda_Active' */

  /* Outputs for Enabled SubSystem: '<S1>/MAX' incorporates:
   *  EnablePort: '<S3>/Enable'
   */
  if (LambdaAdp_B.bLambda_Corr_Act) {
    if (!LambdaAdp_DWork.MAX_MODE) {
      /* InitializeConditions for UnitDelay: '<S3>/Unit Delay' */
      LambdaAdp_DWork.UnitDelay_DSTATE = 0.0F;
      LambdaAdp_DWork.MAX_MODE = TRUE;
    }

    /* MinMax: '<S3>/MinMax' incorporates:
     *  UnitDelay: '<S3>/Unit Delay'
     */
    if (rtb_Divide >= LambdaAdp_DWork.UnitDelay_DSTATE) {
      LambdaAdp_B.MinMax = rtb_Divide;
    } else {
      LambdaAdp_B.MinMax = LambdaAdp_DWork.UnitDelay_DSTATE;
    }

    /* End of MinMax: '<S3>/MinMax' */

    /* Update for UnitDelay: '<S3>/Unit Delay' */
    LambdaAdp_DWork.UnitDelay_DSTATE = LambdaAdp_B.MinMax;
  } else {
    if (LambdaAdp_DWork.MAX_MODE) {
      /* Disable for Outport: '<S3>/Out1' */
      LambdaAdp_B.MinMax = 0.0F;
      LambdaAdp_DWork.MAX_MODE = FALSE;
    }
  }

  /* End of Outputs for SubSystem: '<S1>/MAX' */

  /* Product: '<S1>/Product' incorporates:
   *  Constant: '<S1>/inst->rP_Rot_Norm_Lambda_Gain'
   */
  rtb_Divide = LambdaAdp_B.MinMax * inst->rP_Rot_Norm_Lambda_Gain;

  /* Switch: '<S5>/Switch2' incorporates:
   *  Constant: '<S1>/inst->rLam_OffsLimit_pos'
   *  RelationalOperator: '<S5>/LowerRelop1'
   *  RelationalOperator: '<S5>/UpperRelop'
   *  Switch: '<S5>/Switch'
   */
  if (rtb_Divide > inst->rLam_OffsLimit_pos) {
    rtb_Divide = inst->rLam_OffsLimit_pos;
  } else {
    if (rtb_Divide < LambdaAdp_B.Input3) {
      /* Switch: '<S5>/Switch' */
      rtb_Divide = LambdaAdp_B.Input3;
    }
  }

  /* End of Switch: '<S5>/Switch2' */

  /* Sum: '<S4>/Difference Inputs1' incorporates:
   *  UnitDelay: '<S4>/Delay Input2'
   */
  rtb_Yk1 = rtb_Divide - LambdaAdp_DWork.DelayInput2_DSTATE;

  /* Product: '<S4>/delta rise limit' incorporates:
   *  Constant: '<S1>/inst->rLam_Ramp_Grad'
   *  SampleTimeMath: '<S4>/sample time'
   *
   * About '<S4>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Divide = inst->rLam_Ramp_Grad * 0.01F;

  /* Switch: '<S6>/Switch2' incorporates:
   *  RelationalOperator: '<S6>/LowerRelop1'
   */
  if (!(rtb_Yk1 > rtb_Divide)) {
    /* Product: '<S4>/delta fall limit' incorporates:
     *  Constant: '<S1>/no_limit'
     *  SampleTimeMath: '<S4>/sample time'
     *
     * About '<S4>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Divide = -999.99F;

    /* Switch: '<S6>/Switch' incorporates:
     *  RelationalOperator: '<S6>/UpperRelop'
     */
    if (!(rtb_Yk1 < -999.99F)) {
      rtb_Divide = rtb_Yk1;
    }

    /* End of Switch: '<S6>/Switch' */
  }

  /* End of Switch: '<S6>/Switch2' */

  /* Sum: '<S4>/Difference Inputs2' incorporates:
   *  UnitDelay: '<S4>/Delay Input2'
   */
  LambdaAdp_B.DifferenceInputs2 = rtb_Divide +
    LambdaAdp_DWork.DelayInput2_DSTATE;

  /* Update for UnitDelay: '<S4>/Delay Input2' */
  LambdaAdp_DWork.DelayInput2_DSTATE = LambdaAdp_B.DifferenceInputs2;

  /* End of Outputs for SubSystem: '<Root>/LambdaAdaption' */

  /* S-Function (bur_out): '<Root>/Output' */
  inst->rLambda_Corr = LambdaAdp_B.DifferenceInputs2;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->bLambda_Freeze = LambdaAdp_B.bLambda_Corr_Act;

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->rP_Rot_Max = LambdaAdp_B.MinMax;

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->bN_Delta_Act = LambdaAdp_B.RelationalOperator1;

  /* S-Function (bur_out): '<Root>/Output4' */
  inst->bP_Rot_Lambda_Act = LambdaAdp_B.RelationalOperator;

  /* S-Function (bur_out): '<Root>/Output5' */
  inst->bN_Delta_Neg = LambdaAdp_B.RelationalOperator2;
}

/* Model initialize function */
void LambdaAdp_initialize(struct lLamCorr* inst)
{
  /* InitializeConditions for Atomic SubSystem: '<Root>/LambdaAdaption' */
  /* InitializeConditions for Chart: '<S1>/Lambda_Active' */
  LambdaAdp_B.bLambda_Corr_Act = FALSE;

  /* End of InitializeConditions for SubSystem: '<Root>/LambdaAdaption' */
}

/* Model terminate function */
void LambdaAdp_terminate(struct lLamCorr* inst)
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
 * stateflow                                                                  *
 *============================================================================*/
