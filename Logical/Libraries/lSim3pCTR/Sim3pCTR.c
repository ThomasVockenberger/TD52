/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: Sim3pCTR
 * File: Sim3pCTR.c
 * Author: 105051472
 * Created: Thu Jan 10 08:03:20 2013
 ********************************************************************
 * Implementation of program Sim3pCTR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V3.3
 * (ERT based)
 ********************************************************************/

#include "Sim3pCTR.h"
#include "Sim3pCTR_private.h"

/*  Defines */

/* Named constants for Stateflow: '<S2>/StateMachine' */
#define Sim3pCTR_IN_NO_ACTIVE_CHILD    (0U)
#define Sim3pCTR_IN_decrease           (1U)
#define Sim3pCTR_IN_decrease_inv       (1U)
#define Sim3pCTR_IN_disabled           (1U)
#define Sim3pCTR_IN_enabled            (2U)
#define Sim3pCTR_IN_increase           (2U)
#define Sim3pCTR_IN_increase_inv       (2U)
#define Sim3pCTR_IN_inverse            (1U)
#define Sim3pCTR_IN_man_decrease       (1U)
#define Sim3pCTR_IN_man_increase       (2U)
#define Sim3pCTR_IN_man_steady         (3U)
#define Sim3pCTR_IN_manual_ramp        (3U)
#define Sim3pCTR_IN_normal             (2U)
#define Sim3pCTR_IN_steady             (3U)
#define Sim3pCTR_IN_steady_inv         (3U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */


/* Block states (auto storage) */


/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void Sim3pCTR_step(struct Sim3pCTR* inst)
{
  real32_T rtb_Switch;
  real32_T rtb_Add;
  real32_T rtb_Add1;

  /* S-Function (bur_in): '<Root>/Input' */
  inst->bur_Sim3pCTR_B.Input = inst->Enable;

  /* S-Function (bur_in): '<Root>/Input9' */
  inst->bur_Sim3pCTR_B.Input9 = inst->SetValue;

  /* S-Function (bur_in): '<Root>/Input1' */
  inst->bur_Sim3pCTR_B.Input1 = inst->HysPos;

  /* S-Function (bur_in): '<Root>/Input2' */
  inst->bur_Sim3pCTR_B.Input2 = inst->HysNeg;

  /* S-Function (bur_in): '<Root>/Input3' */
  inst->bur_Sim3pCTR_B.Input3 = inst->ActValue;

  /* S-Function (bur_in): '<Root>/Input4' */
  inst->bur_Sim3pCTR_B.Input4 = inst->dY_up;

  /* S-Function (bur_in): '<Root>/Input5' */
  inst->bur_Sim3pCTR_B.Input5 = inst->dY_down;

  /* S-Function (bur_in): '<Root>/Input6' */
  inst->bur_Sim3pCTR_B.Input6 = inst->CycleTime;

  /* S-Function (bur_in): '<Root>/Input7' */
  inst->bur_Sim3pCTR_B.Input7 = inst->Reset;

  /* S-Function (bur_in): '<Root>/Input8' */
  inst->bur_Sim3pCTR_B.Input8 = inst->InitValue;

  /* S-Function (bur_in): '<Root>/Input14' */
  inst->bur_Sim3pCTR_B.Input14 = inst->bInverse;

  /* S-Function (bur_in): '<Root>/Input12' */
  inst->bur_Sim3pCTR_B.Input12 = inst->bRamp_Y_min;

  /* S-Function (bur_in): '<Root>/Input13' */
  inst->bur_Sim3pCTR_B.Input13 = inst->bRamp_Y_max;

  /* S-Function (bur_in): '<Root>/Input10' */
  inst->bur_Sim3pCTR_B.Input10 = inst->Y_min;

  /* S-Function (bur_in): '<Root>/Input11' */
  inst->bur_Sim3pCTR_B.Input11 = inst->Y_max;

  /* Outputs for Atomic SubSystem: '<Root>/Sim3pCTR' */
  /* Sum: '<S2>/Add' */
  rtb_Add = inst->bur_Sim3pCTR_B.Input9 + inst->bur_Sim3pCTR_B.Input1;

  /* Sum: '<S2>/Add1' */
  rtb_Add1 = inst->bur_Sim3pCTR_B.Input9 - inst->bur_Sim3pCTR_B.Input2;

  /* Switch: '<S3>/Switch' incorporates:
   *  UnitDelay: '<S3>/Unit Delay'
   */
  if (inst->bur_Sim3pCTR_B.Input7) {
    rtb_Switch = inst->bur_Sim3pCTR_B.Input8;
  } else {
    rtb_Switch = inst->bur_Sim3pCTR_DWork.UnitDelay_DSTATE;
  }

  /* End of Switch: '<S3>/Switch' */

  /* Switch: '<S5>/Switch2' incorporates:
   *  RelationalOperator: '<S5>/LowerRelop1'
   */
  if (rtb_Switch > inst->bur_Sim3pCTR_B.Input11) {
    inst->bur_Sim3pCTR_B.Switch2 = inst->bur_Sim3pCTR_B.Input11;
  } else {
    /* Switch: '<S5>/Switch' incorporates:
     *  RelationalOperator: '<S5>/UpperRelop'
     */
    if (rtb_Switch < inst->bur_Sim3pCTR_B.Input10) {
      inst->bur_Sim3pCTR_B.Switch2 = inst->bur_Sim3pCTR_B.Input10;
    } else {
      inst->bur_Sim3pCTR_B.Switch2 = rtb_Switch;
    }

    /* End of Switch: '<S5>/Switch' */
  }

  /* End of Switch: '<S5>/Switch2' */

  /* RelationalOperator: '<S2>/Relational Operator' */
  inst->bur_Sim3pCTR_B.RelationalOperator = ((inst->bur_Sim3pCTR_B.Switch2 <= inst->bur_Sim3pCTR_B.Input10));

  /* RelationalOperator: '<S2>/Relational Operator1' */
  inst->bur_Sim3pCTR_B.RelationalOperator1 = ((inst->bur_Sim3pCTR_B.Switch2 >= inst->bur_Sim3pCTR_B.Input11));

  /* Stateflow: '<S2>/StateMachine' */

  /* Gateway: Sim3pCTR/StateMachine */
  /* During: Sim3pCTR/StateMachine */
  if (inst->bur_Sim3pCTR_DWork.is_active_c1_Sim3pCTR == 0) {
    /* Entry: Sim3pCTR/StateMachine */
    inst->bur_Sim3pCTR_DWork.is_active_c1_Sim3pCTR = 1U;

    /* Transition: '<S4>:79' */
    inst->bur_Sim3pCTR_DWork.is_c1_Sim3pCTR = Sim3pCTR_IN_disabled;

    /* Entry 'disabled': '<S4>:69' */
    inst->bur_Sim3pCTR_B.state = 0;
  } else {
    switch (inst->bur_Sim3pCTR_DWork.is_c1_Sim3pCTR) {
     case Sim3pCTR_IN_disabled:
      /* During 'disabled': '<S4>:69' */
      if (inst->bur_Sim3pCTR_B.Input == TRUE) {
        /* Transition: '<S4>:70' */
        inst->bur_Sim3pCTR_DWork.is_c1_Sim3pCTR = Sim3pCTR_IN_enabled;

        /* Transition: '<S4>:123' */
        inst->bur_Sim3pCTR_DWork.is_enabled = Sim3pCTR_IN_normal;

        /* Transition: '<S4>:78' */
        inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_steady;

        /* Entry 'steady': '<S4>:11' */
        inst->bur_Sim3pCTR_B.state = 0;
      }
      break;

     case Sim3pCTR_IN_enabled:
      /* During 'enabled': '<S4>:62' */
      if (inst->bur_Sim3pCTR_B.Input == FALSE) {
        /* Transition: '<S4>:71' */
        inst->bur_Sim3pCTR_DWork.is_inverse = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
        inst->bur_Sim3pCTR_DWork.is_enabled = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
        inst->bur_Sim3pCTR_DWork.is_normal = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
        inst->bur_Sim3pCTR_DWork.is_c1_Sim3pCTR = Sim3pCTR_IN_disabled;

        /* Entry 'disabled': '<S4>:69' */
        inst->bur_Sim3pCTR_B.state = 0;
      } else if (inst->bur_Sim3pCTR_B.Input13 || inst->bur_Sim3pCTR_B.Input12) {
        /* Transition: '<S4>:99' */
        inst->bur_Sim3pCTR_DWork.is_inverse = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
        inst->bur_Sim3pCTR_DWork.is_enabled = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
        inst->bur_Sim3pCTR_DWork.is_normal = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
        inst->bur_Sim3pCTR_DWork.is_c1_Sim3pCTR = Sim3pCTR_IN_manual_ramp;

        /* Transition: '<S4>:87' */
        inst->bur_Sim3pCTR_DWork.is_manual_ramp = Sim3pCTR_IN_man_steady;

        /* Entry 'man_steady': '<S4>:88' */
        inst->bur_Sim3pCTR_B.state = 0;
      } else {
        switch (inst->bur_Sim3pCTR_DWork.is_enabled) {
         case Sim3pCTR_IN_inverse:
          /* During 'inverse': '<S4>:109' */
          if (inst->bur_Sim3pCTR_B.Input14 == FALSE) {
            /* Transition: '<S4>:121' */
            inst->bur_Sim3pCTR_DWork.is_inverse = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
            inst->bur_Sim3pCTR_DWork.is_enabled = Sim3pCTR_IN_normal;

            /* Transition: '<S4>:78' */
            inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_steady;

            /* Entry 'steady': '<S4>:11' */
            inst->bur_Sim3pCTR_B.state = 0;
          } else {
            switch (inst->bur_Sim3pCTR_DWork.is_inverse) {
             case Sim3pCTR_IN_decrease_inv:
              /* During 'decrease_inv': '<S4>:117' */
              if ((inst->bur_Sim3pCTR_B.Input3 <= inst->bur_Sim3pCTR_B.Input9) ||
                  inst->bur_Sim3pCTR_B.RelationalOperator1) {
                /* Transition: '<S4>:112' */
                inst->bur_Sim3pCTR_DWork.is_inverse = Sim3pCTR_IN_steady_inv;

                /* Entry 'steady_inv': '<S4>:115' */
                inst->bur_Sim3pCTR_B.state = 0;
              }
              break;

             case Sim3pCTR_IN_increase_inv:
              /* During 'increase_inv': '<S4>:116' */
              if ((inst->bur_Sim3pCTR_B.Input3 >= inst->bur_Sim3pCTR_B.Input9) ||
                  inst->bur_Sim3pCTR_B.RelationalOperator) {
                /* Transition: '<S4>:111' */
                inst->bur_Sim3pCTR_DWork.is_inverse = Sim3pCTR_IN_steady_inv;

                /* Entry 'steady_inv': '<S4>:115' */
                inst->bur_Sim3pCTR_B.state = 0;
              }
              break;

             case Sim3pCTR_IN_steady_inv:
              /* During 'steady_inv': '<S4>:115' */
              if ((inst->bur_Sim3pCTR_B.Input3 < rtb_Add1) &&
                  (!inst->bur_Sim3pCTR_B.RelationalOperator)) {
                /* Transition: '<S4>:113' */
                inst->bur_Sim3pCTR_DWork.is_inverse = Sim3pCTR_IN_increase_inv;

                /* Entry 'increase_inv': '<S4>:116' */
                inst->bur_Sim3pCTR_B.state = 1;
              } else {
                if ((inst->bur_Sim3pCTR_B.Input3 > rtb_Add) &&
                    (!inst->bur_Sim3pCTR_B.RelationalOperator1)) {
                  /* Transition: '<S4>:114' */
                  inst->bur_Sim3pCTR_DWork.is_inverse = Sim3pCTR_IN_decrease_inv;

                  /* Entry 'decrease_inv': '<S4>:117' */
                  inst->bur_Sim3pCTR_B.state = 2;
                }
              }
              break;

             default:
              /* Transition: '<S4>:110' */
              inst->bur_Sim3pCTR_DWork.is_inverse = Sim3pCTR_IN_steady_inv;

              /* Entry 'steady_inv': '<S4>:115' */
              inst->bur_Sim3pCTR_B.state = 0;
              break;
            }
          }
          break;

         case Sim3pCTR_IN_normal:
          /* During 'normal': '<S4>:106' */
          if (inst->bur_Sim3pCTR_B.Input14 == TRUE) {
            /* Transition: '<S4>:120' */
            inst->bur_Sim3pCTR_DWork.is_normal = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
            inst->bur_Sim3pCTR_DWork.is_enabled = Sim3pCTR_IN_inverse;

            /* Transition: '<S4>:110' */
            inst->bur_Sim3pCTR_DWork.is_inverse = Sim3pCTR_IN_steady_inv;

            /* Entry 'steady_inv': '<S4>:115' */
            inst->bur_Sim3pCTR_B.state = 0;
          } else {
            switch (inst->bur_Sim3pCTR_DWork.is_normal) {
             case Sim3pCTR_IN_decrease:
              /* During 'decrease': '<S4>:25' */
              if ((inst->bur_Sim3pCTR_B.Input3 <= inst->bur_Sim3pCTR_B.Input9) ||
                  inst->bur_Sim3pCTR_B.RelationalOperator) {
                /* Transition: '<S4>:27' */
                inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_steady;

                /* Entry 'steady': '<S4>:11' */
                inst->bur_Sim3pCTR_B.state = 0;
              }
              break;

             case Sim3pCTR_IN_increase:
              /* During 'increase': '<S4>:24' */
              if ((inst->bur_Sim3pCTR_B.Input3 >= inst->bur_Sim3pCTR_B.Input9) ||
                  inst->bur_Sim3pCTR_B.RelationalOperator1) {
                /* Transition: '<S4>:31' */
                inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_steady;

                /* Entry 'steady': '<S4>:11' */
                inst->bur_Sim3pCTR_B.state = 0;
              }
              break;

             case Sim3pCTR_IN_steady:
              /* During 'steady': '<S4>:11' */
              if ((inst->bur_Sim3pCTR_B.Input3 > rtb_Add) &&
                  (!inst->bur_Sim3pCTR_B.RelationalOperator)) {
                /* Transition: '<S4>:29' */
                inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_decrease;

                /* Entry 'decrease': '<S4>:25' */
                inst->bur_Sim3pCTR_B.state = 1;
              } else {
                if ((inst->bur_Sim3pCTR_B.Input3 < rtb_Add1) &&
                    (!inst->bur_Sim3pCTR_B.RelationalOperator1)) {
                  /* Transition: '<S4>:32' */
                  inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_increase;

                  /* Entry 'increase': '<S4>:24' */
                  inst->bur_Sim3pCTR_B.state = 2;
                }
              }
              break;

             default:
              /* Transition: '<S4>:78' */
              inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_steady;

              /* Entry 'steady': '<S4>:11' */
              inst->bur_Sim3pCTR_B.state = 0;
              break;
            }
          }
          break;

         default:
          /* Transition: '<S4>:123' */
          inst->bur_Sim3pCTR_DWork.is_enabled = Sim3pCTR_IN_normal;

          /* Transition: '<S4>:78' */
          inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_steady;

          /* Entry 'steady': '<S4>:11' */
          inst->bur_Sim3pCTR_B.state = 0;
          break;
        }
      }
      break;

     case Sim3pCTR_IN_manual_ramp:
      /* During 'manual_ramp': '<S4>:86' */
      if (inst->bur_Sim3pCTR_B.Input == FALSE) {
        /* Transition: '<S4>:98' */
        inst->bur_Sim3pCTR_DWork.is_manual_ramp = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
        inst->bur_Sim3pCTR_DWork.is_c1_Sim3pCTR = Sim3pCTR_IN_disabled;

        /* Entry 'disabled': '<S4>:69' */
        inst->bur_Sim3pCTR_B.state = 0;
      } else if ((!inst->bur_Sim3pCTR_B.Input13) && (!inst->bur_Sim3pCTR_B.Input12)) {
        /* Transition: '<S4>:101' */
        inst->bur_Sim3pCTR_DWork.is_manual_ramp = (uint8_T)Sim3pCTR_IN_NO_ACTIVE_CHILD;
        inst->bur_Sim3pCTR_DWork.is_c1_Sim3pCTR = Sim3pCTR_IN_enabled;

        /* Transition: '<S4>:123' */
        inst->bur_Sim3pCTR_DWork.is_enabled = Sim3pCTR_IN_normal;

        /* Transition: '<S4>:78' */
        inst->bur_Sim3pCTR_DWork.is_normal = Sim3pCTR_IN_steady;

        /* Entry 'steady': '<S4>:11' */
        inst->bur_Sim3pCTR_B.state = 0;
      } else {
        switch (inst->bur_Sim3pCTR_DWork.is_manual_ramp) {
         case Sim3pCTR_IN_man_decrease:
          /* During 'man_decrease': '<S4>:90' */
          if ((!inst->bur_Sim3pCTR_B.Input12) || inst->bur_Sim3pCTR_B.RelationalOperator) {
            /* Transition: '<S4>:95' */
            inst->bur_Sim3pCTR_DWork.is_manual_ramp = Sim3pCTR_IN_man_steady;

            /* Entry 'man_steady': '<S4>:88' */
            inst->bur_Sim3pCTR_B.state = 0;
          }
          break;

         case Sim3pCTR_IN_man_increase:
          /* During 'man_increase': '<S4>:89' */
          if ((!inst->bur_Sim3pCTR_B.Input13) || inst->bur_Sim3pCTR_B.RelationalOperator1 ||
              inst->bur_Sim3pCTR_B.Input12) {
            /* Transition: '<S4>:92' */
            inst->bur_Sim3pCTR_DWork.is_manual_ramp = Sim3pCTR_IN_man_steady;

            /* Entry 'man_steady': '<S4>:88' */
            inst->bur_Sim3pCTR_B.state = 0;
          }
          break;

         case Sim3pCTR_IN_man_steady:
          /* During 'man_steady': '<S4>:88' */
          if (inst->bur_Sim3pCTR_B.Input12 && (!inst->bur_Sim3pCTR_B.RelationalOperator)) {
            /* Transition: '<S4>:93' */
            inst->bur_Sim3pCTR_DWork.is_manual_ramp = Sim3pCTR_IN_man_decrease;

            /* Entry 'man_decrease': '<S4>:90' */
            inst->bur_Sim3pCTR_B.state = 1;
          } else {
            if (inst->bur_Sim3pCTR_B.Input13 && (!inst->bur_Sim3pCTR_B.Input12) &&
                (!inst->bur_Sim3pCTR_B.RelationalOperator1)) {
              /* Transition: '<S4>:91' */
              inst->bur_Sim3pCTR_DWork.is_manual_ramp = Sim3pCTR_IN_man_increase;

              /* Entry 'man_increase': '<S4>:89' */
              inst->bur_Sim3pCTR_B.state = 2;
            }
          }
          break;

         default:
          /* Transition: '<S4>:87' */
          inst->bur_Sim3pCTR_DWork.is_manual_ramp = Sim3pCTR_IN_man_steady;

          /* Entry 'man_steady': '<S4>:88' */
          inst->bur_Sim3pCTR_B.state = 0;
          break;
        }
      }
      break;

     default:
      /* Transition: '<S4>:79' */
      inst->bur_Sim3pCTR_DWork.is_c1_Sim3pCTR = Sim3pCTR_IN_disabled;

      /* Entry 'disabled': '<S4>:69' */
      inst->bur_Sim3pCTR_B.state = 0;
      break;
    }
  }

  /* End of Stateflow: '<S2>/StateMachine' */

  /* Switch: '<S3>/Switch1' incorporates:
   *  Product: '<S3>/Product'
   *  Sum: '<S3>/Add'
   */
  if (inst->bur_Sim3pCTR_B.Input7) {
    rtb_Add = inst->bur_Sim3pCTR_B.Input8;
  } else {
    /* MultiPortSwitch: '<S2>/Multiport Switch' incorporates:
     *  Constant: '<S2>/Constant'
     *  Gain: '<S2>/Gain'
     */
    switch (inst->bur_Sim3pCTR_B.state) {
     case 0:
      rtb_Add = 0.0F;
      break;

     case 1:
      rtb_Add = -inst->bur_Sim3pCTR_B.Input5;
      break;

     default:
      rtb_Add = inst->bur_Sim3pCTR_B.Input4;
      break;
    }

    /* End of MultiPortSwitch: '<S2>/Multiport Switch' */
    rtb_Add = rtb_Add * inst->bur_Sim3pCTR_B.Input6 + inst->bur_Sim3pCTR_B.Switch2;
  }

  /* End of Switch: '<S3>/Switch1' */

  /* Update for UnitDelay: '<S3>/Unit Delay' */
  inst->bur_Sim3pCTR_DWork.UnitDelay_DSTATE = rtb_Add;

  /* End of Outputs for SubSystem: '<Root>/Sim3pCTR' */

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Y = inst->bur_Sim3pCTR_B.Switch2;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->bY_min_limit = inst->bur_Sim3pCTR_B.RelationalOperator;

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->bY_max_limit = inst->bur_Sim3pCTR_B.RelationalOperator1;

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->State = inst->bur_Sim3pCTR_B.state;
}

/* Model initialize function */
void Sim3pCTR_initialize(struct Sim3pCTR* inst)
{
  /* (no initialization code required) */
}

/* Model terminate function */
void Sim3pCTR_terminate(struct Sim3pCTR* inst)
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
 * stateflow                                                                  *
 *============================================================================*/
