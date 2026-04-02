/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: Sim6CTR
 * File: Sim6CTR.c
 * Author: 105051472
 * Created: Wed Oct 23 10:19:46 2013
 ********************************************************************
 * Implementation of program Sim6CTR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.0
 * (ERT based)
 ********************************************************************/
#include "Sim6CTR.h"
#include "Sim6CTR_private.h"

/*  Defines */

/* Named constants for Chart: '<S1>/Chart' */
#define Sim6CTR_IN_Close_CBP_3u4       ((uint8_T)1U)
#define Sim6CTR_IN_LoadDrop            ((uint8_T)1U)
#define Sim6CTR_IN_Lock_TV             ((uint8_T)1U)
#define Sim6CTR_IN_NO_ACTIVE_CHILD     ((uint8_T)0U)
#define Sim6CTR_IN_Open_CBP_3u4        ((uint8_T)2U)
#define Sim6CTR_IN_Release_TV          ((uint8_T)2U)
#define Sim6CTR_IN_Standard            ((uint8_T)2U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */


/* Block states (auto storage) */


/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void Sim6CTR_step(struct Sim6CTR* inst)
{
  real_T rtb_Product;
  real_T rtb_Trackingswitch;
  real32_T rtb_Product2_g;
  real32_T rtb_Product1;
  real32_T rtb_Product2_b;
  real32_T rtb_Sum;
  real32_T rtb_Saturation;
  int32_T rtb_Switch1;
  real32_T rtb_Switch_h;
  boolean_T rtb_RelationalOperator2;
  real32_T rtb_Abs;
  real32_T rtb_SumI1;
  real32_T rtb_Saturation_o;
  real32_T rtb_Switch2;
  boolean_T rtb_Compare_e;

  /* S-Function (bur_in): '<Root>/Input10' */
  inst->bur_Sim6CTR_B.Input10 = inst->bInit;

  /* Switch: '<S1>/Switch1' incorporates:
   *  Constant: '<S1>/Constant12'
   *  Constant: '<S1>/Constant3'
   */
  if (inst->bur_Sim6CTR_B.Input10) {
    rtb_Switch1 = 2;
  } else {
    rtb_Switch1 = 3;
  }

  /* End of Switch: '<S1>/Switch1' */

  /* S-Function (bur_in): '<Root>/Input11' */
  inst->bur_Sim6CTR_B.Input11 = inst->Init_Value_CBP;

  /* S-Function (bur_in): '<Root>/Input1' */
  inst->bur_Sim6CTR_B.Input1 = inst->w_set;

  /* Product: '<S7>/Product' */
  rtb_Product = inst->bur_Sim6CTR_B.Input1;

  /* S-Function (bur_in): '<Root>/Input9' */
  inst->bur_Sim6CTR_B.Input9 = inst->x_act;

  /* Sum: '<S7>/Sum' incorporates:
   *  Product: '<S7>/Product1'
   */
  rtb_Product -= (real_T)inst->bur_Sim6CTR_B.Input9;

  /* DeadZone: '<S7>/Deadband' */
  if ((!(rtb_Product > 0.0)) && (rtb_Product >= -0.0)) {
    rtb_Product = 0.0;
  }

  /* End of DeadZone: '<S7>/Deadband' */

  /* Product: '<S7>/Product2' */
  rtb_Product2_g = (real32_T)-rtb_Product;

  /* S-Function (bur_in): '<Root>/Input3' */
  inst->bur_Sim6CTR_B.Input3 = inst->P_CBP;

  /* Product: '<S10>/Product1' incorporates:
   *  Product: '<S7>/Product2'
   */
  rtb_Product1 = (real32_T)-rtb_Product * inst->bur_Sim6CTR_B.Input3;

  /* DiscreteIntegrator: '<S10>/Integrator' */
  rtb_Product2_b = inst->bur_Sim6CTR_DWork.Integrator_DSTATE;

  /* S-Function (bur_in): '<Root>/Input5' */
  inst->bur_Sim6CTR_B.Input5 = inst->D_CBP;

  /* Sum: '<S10>/Sum2' incorporates:
   *  Sum: '<S10>/Sum1'
   */
  rtb_Sum = rtb_Product1 + rtb_Product2_b;

  /* Saturate: '<S10>/Saturation' */
  if (rtb_Sum >= inst->u_max_CBP) {
    rtb_Saturation = inst->u_max_CBP;
  } else if (rtb_Sum <= inst->u_min_CBP) {
    rtb_Saturation = inst->u_min_CBP;
  } else {
    rtb_Saturation = rtb_Sum;
  }

  /* End of Saturate: '<S10>/Saturation' */

  /* MultiPortSwitch: '<S7>/Mode switch' */
  switch (rtb_Switch1) {
   case 1:
    inst->bur_Sim6CTR_B.Modeswitch = inst->bur_Sim6CTR_B.Input11;
    break;

   case 2:
    inst->bur_Sim6CTR_B.Modeswitch = inst->bur_Sim6CTR_B.Input11;
    break;

   default:
    inst->bur_Sim6CTR_B.Modeswitch = rtb_Saturation;
    break;
  }

  /* End of MultiPortSwitch: '<S7>/Mode switch' */

  /* S-Function (bur_out): '<Root>/Output' */
  inst->rPos_CBP = inst->bur_Sim6CTR_B.Modeswitch;

  /* S-Function (bur_in): '<Root>/Input13' */
  inst->bur_Sim6CTR_B.Input13 = inst->rN_act;

  /* S-Function (bur_in): '<Root>/Input12' */
  inst->bur_Sim6CTR_B.Input12 = inst->rN_set;

  /* RelationalOperator: '<S1>/Relational Operator1' incorporates:
   *  Constant: '<S1>/rN_ok_offset'
   *  Sum: '<S1>/Add'
   */
  inst->bur_Sim6CTR_B.RelationalOperator1 = (inst->bur_Sim6CTR_B.Input13 < inst->bur_Sim6CTR_B.Input12 +
    inst->rN_ok_offset);

  /* Switch: '<S9>/Switch' incorporates:
   *  Constant: '<S1>/Cyclic Time'
   *  Constant: '<S9>/Constant4'
   *  Sum: '<S9>/Add'
   *  UnitDelay: '<S6>/Unit Delay2'
   *  UnitDelay: '<S9>/Unit Delay'
   */
  if (inst->bur_Sim6CTR_DWork.UnitDelay2_DSTATE) {
    rtb_Switch_h = 0.0F;
  } else {
    rtb_Switch_h = (real32_T)((real_T)inst->CycleTime + (real_T)
      inst->bur_Sim6CTR_DWork.UnitDelay_DSTATE);
  }

  /* End of Switch: '<S9>/Switch' */

  /* RelationalOperator: '<S6>/Relational Operator2' incorporates:
   *  Constant: '<S1>/Ts_downSampling_speed'
   */
  rtb_RelationalOperator2 = (rtb_Switch_h >= inst->Ts_downSampling_speed);

  /* Switch: '<S6>/Switch' incorporates:
   *  UnitDelay: '<S6>/Unit Delay'
   */
  if (rtb_RelationalOperator2) {
    inst->bur_Sim6CTR_B.Switch = inst->bur_Sim6CTR_B.Input13;
  } else {
    inst->bur_Sim6CTR_B.Switch = inst->bur_Sim6CTR_DWork.UnitDelay_DSTATE_e;
  }

  /* End of Switch: '<S6>/Switch' */

  /* Sum: '<S5>/Diff' incorporates:
   *  UnitDelay: '<S5>/UD'
   */
  inst->bur_Sim6CTR_B.Diff = inst->bur_Sim6CTR_B.Switch - inst->bur_Sim6CTR_DWork.UD_DSTATE;

  /* RelationalOperator: '<S4>/Compare' incorporates:
   *  Constant: '<S4>/Constant'
   */
  inst->bur_Sim6CTR_B.Compare = (inst->bur_Sim6CTR_B.Diff < 0.0F);

  /* Delay: '<S1>/Delay' */
  rtb_Product1 = inst->bur_Sim6CTR_DWork.Delay_DSTATE[0];

  /* S-Function (bur_in): '<Root>/Input2' */
  inst->bur_Sim6CTR_B.Input2 = inst->rP_el;

  /* Sum: '<S1>/Add1' */
  inst->bur_Sim6CTR_B.Add1 = inst->bur_Sim6CTR_B.Input2 - rtb_Product1;

  /* RelationalOperator: '<S1>/Relational Operator' incorporates:
   *  Constant: '<S1>/rP_drop_limit'
   */
  inst->bur_Sim6CTR_B.RelationalOperator = (inst->bur_Sim6CTR_B.Add1 < inst->rP_drop_limit);

  /* Chart: '<S1>/Chart' incorporates:
   *  Constant: '<S1>/rP_el_LockTV'
   *  MinMax: '<S1>/MinMax'
   *  UnitDelay: '<S1>/Unit Delay'
   */
  /* Gateway: Island Controller/Chart */
  /* During: Island Controller/Chart */
  if (inst->bur_Sim6CTR_DWork.is_active_c1_Sim6CTR == 0U) {
    /* Entry: Island Controller/Chart */
    inst->bur_Sim6CTR_DWork.is_active_c1_Sim6CTR = 1U;

    /* Entry Internal: Island Controller/Chart */
    /* Transition: '<S3>:12' */
    inst->bur_Sim6CTR_DWork.is_c1_Sim6CTR = Sim6CTR_IN_Standard;

    /* Entry 'Standard': '<S3>:7' */
    inst->bur_Sim6CTR_B.bLoadDrop = FALSE;
    inst->bur_Sim6CTR_B.Open4CBP = FALSE;

    /* Entry Internal 'Standard': '<S3>:7' */
    /* Transition: '<S3>:16' */
    inst->bur_Sim6CTR_DWork.is_Standard = Sim6CTR_IN_Release_TV;

    /* Entry 'Release_TV': '<S3>:15' */
    inst->bur_Sim6CTR_B.Lock_TV = FALSE;
    inst->bur_Sim6CTR_B.Control_State = 11;
  } else if (inst->bur_Sim6CTR_DWork.is_c1_Sim6CTR == Sim6CTR_IN_LoadDrop) {
    /* During 'LoadDrop': '<S3>:10' */
    if (inst->bur_Sim6CTR_B.RelationalOperator1 && inst->bur_Sim6CTR_B.Compare) {
      /* Transition: '<S3>:25' */
      /* Exit Internal 'LoadDrop': '<S3>:10' */
      inst->bur_Sim6CTR_DWork.is_LoadDrop = Sim6CTR_IN_NO_ACTIVE_CHILD;
      inst->bur_Sim6CTR_DWork.is_c1_Sim6CTR = Sim6CTR_IN_Standard;

      /* Entry 'Standard': '<S3>:7' */
      inst->bur_Sim6CTR_B.bLoadDrop = FALSE;
      inst->bur_Sim6CTR_B.Open4CBP = FALSE;

      /* Entry Internal 'Standard': '<S3>:7' */
      /* Transition: '<S3>:16' */
      inst->bur_Sim6CTR_DWork.is_Standard = Sim6CTR_IN_Release_TV;

      /* Entry 'Release_TV': '<S3>:15' */
      inst->bur_Sim6CTR_B.Lock_TV = FALSE;
      inst->bur_Sim6CTR_B.Control_State = 11;
    } else {
      switch (inst->bur_Sim6CTR_DWork.is_LoadDrop) {
       case Sim6CTR_IN_Close_CBP_3u4:
        break;

       default:
        /* During 'Open_CBP_3u4': '<S3>:29' */
        if (inst->bur_Sim6CTR_B.Compare) {
          /* Transition: '<S3>:32' */
          inst->bur_Sim6CTR_DWork.is_LoadDrop = Sim6CTR_IN_Close_CBP_3u4;

          /* Entry 'Close_CBP_3u4': '<S3>:31' */
          inst->bur_Sim6CTR_B.Open4CBP = FALSE;
          inst->bur_Sim6CTR_B.Control_State = 22;
        }
        break;
      }
    }
  } else {
    /* During 'Standard': '<S3>:7' */
    if (inst->bur_Sim6CTR_B.RelationalOperator) {
      /* Transition: '<S3>:23' */
      /* Exit Internal 'Standard': '<S3>:7' */
      inst->bur_Sim6CTR_DWork.is_Standard = Sim6CTR_IN_NO_ACTIVE_CHILD;
      inst->bur_Sim6CTR_DWork.is_c1_Sim6CTR = Sim6CTR_IN_LoadDrop;

      /* Entry 'LoadDrop': '<S3>:10' */
      inst->bur_Sim6CTR_B.Lock_TV = FALSE;
      inst->bur_Sim6CTR_B.bLoadDrop = TRUE;

      /* Entry Internal 'LoadDrop': '<S3>:10' */
      /* Transition: '<S3>:30' */
      inst->bur_Sim6CTR_DWork.is_LoadDrop = Sim6CTR_IN_Open_CBP_3u4;

      /* Entry 'Open_CBP_3u4': '<S3>:29' */
      inst->bur_Sim6CTR_B.Open4CBP = TRUE;
      inst->bur_Sim6CTR_B.Control_State = 21;
    } else if (inst->bur_Sim6CTR_DWork.is_Standard == Sim6CTR_IN_Lock_TV) {
      /* MinMax: '<S1>/MinMax' incorporates:
       *  Constant: '<S1>/rP_el_LockTV'
       *  Constant: '<S1>/rP_el_ReleaseTV'
       */
      /* During 'Lock_TV': '<S3>:9' */
      if (inst->rP_el_LockTV <= inst->rP_el_ReleaseTV) {
        rtb_Product = inst->rP_el_LockTV;
      } else {
        rtb_Product = inst->rP_el_ReleaseTV;
      }

      if ((real_T)inst->bur_Sim6CTR_B.Input2 < rtb_Product) {
        /* Transition: '<S3>:20' */
        inst->bur_Sim6CTR_DWork.is_Standard = Sim6CTR_IN_Release_TV;

        /* Entry 'Release_TV': '<S3>:15' */
        inst->bur_Sim6CTR_B.Lock_TV = FALSE;
        inst->bur_Sim6CTR_B.Control_State = 11;
      }
    } else {
      /* During 'Release_TV': '<S3>:15' */
      if ((inst->bur_Sim6CTR_B.Input2 > inst->rP_el_LockTV) && (inst->bur_Sim6CTR_DWork.UnitDelay_DSTATE_n
           > 72.0F)) {
        /* Transition: '<S3>:19' */
        inst->bur_Sim6CTR_DWork.is_Standard = Sim6CTR_IN_Lock_TV;

        /* Entry 'Lock_TV': '<S3>:9' */
        inst->bur_Sim6CTR_B.Lock_TV = TRUE;
        inst->bur_Sim6CTR_B.Control_State = 12;
      }
    }
  }

  /* End of Chart: '<S1>/Chart' */

  /* Switch: '<S1>/Switch' incorporates:
   *  Constant: '<S1>/Constant2'
   *  Constant: '<S1>/Constant31'
   *  Logic: '<S1>/Logical Operator'
   */
  if (inst->bur_Sim6CTR_B.Input10 || inst->bur_Sim6CTR_B.Lock_TV) {
    rtb_Product = 2.0;
  } else {
    rtb_Product = 3.0;
  }

  /* End of Switch: '<S1>/Switch' */

  /* S-Function (bur_in): '<Root>/Input14' */
  inst->bur_Sim6CTR_B.Input14 = inst->Init_Value_TV;

  /* Switch: '<S1>/Switch2' incorporates:
   *  Constant: '<S1>/u_man_TV'
   */
  if (inst->bur_Sim6CTR_B.Input10) {
    rtb_Switch2 = inst->bur_Sim6CTR_B.Input14;
  } else {
    rtb_Switch2 = inst->u_man_TV;
  }

  /* End of Switch: '<S1>/Switch2' */

  /* Sum: '<S8>/Sum' incorporates:
   *  Product: '<S8>/Product'
   *  Product: '<S8>/Product1'
   */
  rtb_Trackingswitch = (real_T)inst->bur_Sim6CTR_B.Input1 - (real_T)inst->bur_Sim6CTR_B.Input9;

  /* DeadZone: '<S8>/Deadband' */
  if ((!(rtb_Trackingswitch > 0.0)) && (rtb_Trackingswitch >= -0.0)) {
    rtb_Trackingswitch = 0.0;
  }

  /* End of DeadZone: '<S8>/Deadband' */

  /* Product: '<S8>/Product2' */
  rtb_Product2_b = (real32_T)rtb_Trackingswitch;

  /* S-Function (bur_in): '<Root>/Input6' */
  inst->bur_Sim6CTR_B.Input6 = inst->P_TV;

  /* Product: '<S13>/Product1' incorporates:
   *  Product: '<S8>/Product2'
   */
  rtb_Product1 = (real32_T)rtb_Trackingswitch * inst->bur_Sim6CTR_B.Input6;

  /* DiscreteIntegrator: '<S13>/Integrator' */
  rtb_Abs = inst->bur_Sim6CTR_DWork.Integrator_DSTATE_i;

  /* S-Function (bur_in): '<Root>/Input8' */
  inst->bur_Sim6CTR_B.Input8 = inst->D_TV;

  /* Sum: '<S13>/Sum2' incorporates:
   *  Sum: '<S13>/Sum1'
   */
  rtb_SumI1 = rtb_Product1 + rtb_Abs;

  /* Saturate: '<S13>/Saturation' */
  if (rtb_SumI1 >= inst->u_max_TV) {
    rtb_Saturation_o = inst->u_max_TV;
  } else if (rtb_SumI1 <= inst->u_min_TV) {
    rtb_Saturation_o = inst->u_min_TV;
  } else {
    rtb_Saturation_o = rtb_SumI1;
  }

  /* End of Saturate: '<S13>/Saturation' */

  /* MultiPortSwitch: '<S8>/Mode switch' */
  switch ((int32_T)rtb_Product) {
   case 1:
    inst->bur_Sim6CTR_B.Modeswitch_a = rtb_Switch2;
    break;

   case 2:
    inst->bur_Sim6CTR_B.Modeswitch_a = rtb_Switch2;
    break;

   default:
    inst->bur_Sim6CTR_B.Modeswitch_a = rtb_Saturation_o;
    break;
  }

  /* End of MultiPortSwitch: '<S8>/Mode switch' */

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->rPos_TV = inst->bur_Sim6CTR_B.Modeswitch_a;

  /* S-Function (bur_out): '<Root>/Output10' */
  inst->rN_act_Diff = inst->bur_Sim6CTR_B.Diff;

  /* S-Function (bur_out): '<Root>/Output11' */
  inst->bOpen4CBP = inst->bur_Sim6CTR_B.Open4CBP;

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->bLoadDrop = inst->bur_Sim6CTR_B.bLoadDrop;

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->Control_State = inst->bur_Sim6CTR_B.Control_State;

  /* S-Function (bur_out): '<Root>/Output4' */
  inst->bLock_TV = inst->bur_Sim6CTR_B.Lock_TV;

  /* S-Function (bur_out): '<Root>/Output5' */
  inst->bN_ok = inst->bur_Sim6CTR_B.RelationalOperator1;

  /* S-Function (bur_out): '<Root>/Output6' */
  inst->bN_rate_neg = inst->bur_Sim6CTR_B.Compare;

  /* S-Function (bur_out): '<Root>/Output7' */
  inst->bP_drop = inst->bur_Sim6CTR_B.RelationalOperator;

  /* S-Function (bur_out): '<Root>/Output8' */
  inst->rP_grad = inst->bur_Sim6CTR_B.Add1;

  /* S-Function (bur_out): '<Root>/Output9' */
  inst->rN_act_DS = inst->bur_Sim6CTR_B.Switch;

  /* S-Function (bur_in): '<Root>/Input4' */
  inst->bur_Sim6CTR_B.Input4 = inst->I_CBP;

  /* S-Function (bur_in): '<Root>/Input7' */
  inst->bur_Sim6CTR_B.Input7 = inst->I_TV;

  /* Sum: '<S11>/Sum' */
  rtb_Sum = rtb_Saturation - rtb_Sum;

  /* MultiPortSwitch: '<S7>/Tracking switch' incorporates:
   *  Constant: '<S7>/Constant'
   *  Constant: '<S7>/Constant1'
   */
  switch (rtb_Switch1) {
   case 1:
    rtb_Trackingswitch = 0.0;
    break;

   case 2:
    rtb_Trackingswitch = 1.0;
    break;

   default:
    rtb_Trackingswitch = 0.0;
    break;
  }

  /* End of MultiPortSwitch: '<S7>/Tracking switch' */

  /* Sum: '<S10>/SumI1' incorporates:
   *  Product: '<S10>/Product'
   *  Product: '<S10>/Product2'
   *  Sum: '<S10>/SumI3'
   */
  rtb_Abs = (real32_T)((real_T)(inst->bur_Sim6CTR_B.Input11 - rtb_Saturation) *
                       rtb_Trackingswitch) + rtb_Product2_g * inst->bur_Sim6CTR_B.Input4;

  /* Signum: '<S11>/SignPreSat' */
  if (rtb_Sum < 0.0F) {
    rtb_Product2_g = -1.0F;
  } else if (rtb_Sum > 0.0F) {
    rtb_Product2_g = 1.0F;
  } else {
    rtb_Product2_g = rtb_Sum;
  }

  /* Signum: '<S11>/SignPreIntegrator' */
  if (rtb_Abs < 0.0F) {
    rtb_Saturation = -1.0F;
  } else if (rtb_Abs > 0.0F) {
    rtb_Saturation = 1.0F;
  } else {
    rtb_Saturation = rtb_Abs;
  }

  /* Switch: '<S10>/Switch' incorporates:
   *  Abs: '<S11>/Abs'
   *  Constant: '<S10>/Constant4'
   *  Constant: '<S12>/Constant'
   *  Logic: '<S11>/AND'
   *  RelationalOperator: '<S11>/Equal'
   *  RelationalOperator: '<S12>/Compare'
   *  Signum: '<S11>/SignPreIntegrator'
   *  Signum: '<S11>/SignPreSat'
   */
  if (((real32_T)fabs(rtb_Sum) > 0.1F) && (rtb_Product2_g != rtb_Saturation)) {
    rtb_Abs = 0.0F;
  }

  /* End of Switch: '<S10>/Switch' */

  /* Sum: '<S14>/Sum' */
  rtb_SumI1 = rtb_Saturation_o - rtb_SumI1;

  /* RelationalOperator: '<S15>/Compare' incorporates:
   *  Abs: '<S14>/Abs'
   *  Constant: '<S15>/Constant'
   */
  rtb_Compare_e = ((real32_T)fabs(rtb_SumI1) > 0.1F);

  /* Signum: '<S14>/SignPreSat' */
  if (rtb_SumI1 < 0.0F) {
    rtb_Product1 = -1.0F;
  } else if (rtb_SumI1 > 0.0F) {
    rtb_Product1 = 1.0F;
  } else {
    rtb_Product1 = rtb_SumI1;
  }

  /* End of Signum: '<S14>/SignPreSat' */

  /* MultiPortSwitch: '<S8>/Tracking switch' incorporates:
   *  Constant: '<S8>/Constant'
   *  Constant: '<S8>/Constant1'
   */
  switch ((int32_T)rtb_Product) {
   case 1:
    rtb_Trackingswitch = 0.0;
    break;

   case 2:
    rtb_Trackingswitch = 1.0;
    break;

   default:
    rtb_Trackingswitch = 0.0;
    break;
  }

  /* End of MultiPortSwitch: '<S8>/Tracking switch' */

  /* Sum: '<S13>/SumI1' incorporates:
   *  Product: '<S13>/Product'
   *  Product: '<S13>/Product2'
   *  Sum: '<S13>/SumI3'
   */
  rtb_SumI1 = (real32_T)((real_T)(rtb_Switch2 - rtb_Saturation_o) *
    rtb_Trackingswitch) + rtb_Product2_b * inst->bur_Sim6CTR_B.Input7;

  /* Signum: '<S14>/SignPreIntegrator' */
  if (rtb_SumI1 < 0.0F) {
    rtb_Product2_g = -1.0F;
  } else if (rtb_SumI1 > 0.0F) {
    rtb_Product2_g = 1.0F;
  } else {
    rtb_Product2_g = rtb_SumI1;
  }

  /* Switch: '<S13>/Switch' incorporates:
   *  Constant: '<S13>/Constant4'
   *  Logic: '<S14>/AND'
   *  RelationalOperator: '<S14>/Equal'
   *  Signum: '<S14>/SignPreIntegrator'
   */
  if (rtb_Compare_e && (rtb_Product1 != rtb_Product2_g)) {
    rtb_Product1 = 0.0F;
  } else {
    rtb_Product1 = rtb_SumI1;
  }

  /* End of Switch: '<S13>/Switch' */

  /* Update for DiscreteIntegrator: '<S10>/Integrator' */
  inst->bur_Sim6CTR_DWork.Integrator_DSTATE += 0.01F * rtb_Abs;

  /* Update for UnitDelay: '<S6>/Unit Delay2' */
  inst->bur_Sim6CTR_DWork.UnitDelay2_DSTATE = rtb_RelationalOperator2;

  /* Update for UnitDelay: '<S9>/Unit Delay' */
  inst->bur_Sim6CTR_DWork.UnitDelay_DSTATE = rtb_Switch_h;

  /* Update for UnitDelay: '<S6>/Unit Delay' */
  inst->bur_Sim6CTR_DWork.UnitDelay_DSTATE_e = inst->bur_Sim6CTR_B.Switch;

  /* Update for UnitDelay: '<S5>/UD' */
  inst->bur_Sim6CTR_DWork.UD_DSTATE = inst->bur_Sim6CTR_B.Switch;

  /* Update for Delay: '<S1>/Delay' */
  for (rtb_Switch1 = 0; rtb_Switch1 < 9; rtb_Switch1++) {
    inst->bur_Sim6CTR_DWork.Delay_DSTATE[rtb_Switch1] =
      inst->bur_Sim6CTR_DWork.Delay_DSTATE[rtb_Switch1 + 1];
  }

  inst->bur_Sim6CTR_DWork.Delay_DSTATE[9] = inst->bur_Sim6CTR_B.Input2;

  /* End of Update for Delay: '<S1>/Delay' */

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  inst->bur_Sim6CTR_DWork.UnitDelay_DSTATE_n = inst->bur_Sim6CTR_B.Modeswitch_a;

  /* Update for DiscreteIntegrator: '<S13>/Integrator' */
  inst->bur_Sim6CTR_DWork.Integrator_DSTATE_i += 0.01F * rtb_Product1;
}

/* Model initialize function */
void Sim6CTR_initialize(struct Sim6CTR* inst)
{
  /* InitializeConditions for Chart: '<S1>/Chart' */
  inst->bur_Sim6CTR_B.Control_State = 0;
  inst->bur_Sim6CTR_B.Lock_TV = FALSE;
  inst->bur_Sim6CTR_B.bLoadDrop = FALSE;
  inst->bur_Sim6CTR_B.Open4CBP = FALSE;
}

/* Model terminate function */
void Sim6CTR_terminate(struct Sim6CTR* inst)
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
 * control_toolbox                                                            *
 * identification_toolbox                                                     *
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 * stateflow                                                                  *
 *============================================================================*/
