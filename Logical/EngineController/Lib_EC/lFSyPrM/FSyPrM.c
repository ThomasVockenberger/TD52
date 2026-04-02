/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: FSyPrM
 * File: FSyPrM.c
 * Author: 105055527
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Mon Jan 25 17:32:20 2021
 * Model Version: 0.08
 * Description: Fast synchronization controller for pre-mixed engines.

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    30.03.2020    Schmidt,   project/controller carryover from FSync to FSyncPrM
   V0.02    02.04.2020    Schmidt,   cleanup and deletion of functions not used by pre-mixed engines
   V0.03    12.05.2020    Schmidt,   upgrade to MATLAB/SIMULINK R2020a
   V0.04    14.05.2020    Schmidt,   B&R blocks upgrade to AS Target v6.2.0 (officially supports MATLAB 2020a)
   V0.05    03.08.2020    Schmidt,   changed speed reference for function activation from nominal speed (parameter) to bus bar frequency
   added detection for speed exceedance --> switch over to standard idle controller
   V0.06    04.08.2020    Schmidt,   moved function activation from PARA bus to IN bus
   V0.07    17.08.2020    Schmidt,   included modifications after P6 tests
   V0.08    25.01.2021    Schmidt,   use of frequency based speed set-point (rN_Set) only if rF_MMD_BusBar > 0.5*rF_Nom
 ********************************************************************
 * Implementation of program FSyPrM
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.1
 * (ERT based)
 ********************************************************************/

#include "FSyPrM.h"
#include "FSyPrM_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void FSyPrM_step(RT_MODEL_FSyPrM *const FSyPrM_M, struct fFSyPrM* inst)
{
  struct BlockIO_FSyPrM *FSyPrM_B = ((struct BlockIO_FSyPrM *) FSyPrM_M->blockIO);
  struct D_Work_FSyPrM *FSyPrM_DWork = ((struct D_Work_FSyPrM *) FSyPrM_M->dwork);
  ExternalOutputs_FSyPrM *FSyPrM_Y = (ExternalOutputs_FSyPrM *)
    FSyPrM_M->outputs;
  boolean_T bEnabled;
  real32_T rN_err;
  real32_T rAngle_err;
  real32_T S;
  real32_T gk;
  boolean_T Sf1;
  boolean_T Sf2;
  boolean_T Gplus;
  boolean_T Gminus;
  boolean_T Gammaplus;
  boolean_T Gammaminus;
  boolean_T H1;
  boolean_T H3;
  real32_T rtb_Switch1_i;
  real32_T rtb_DiscreteTimeIntegrator_g;
  int8_T rtb_Switch2;
  real_T rtb_Switch1;
  real32_T S_tmp;
  uint32_T tmp;
  real32_T tmp_0;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  FSyPrM_B->BusInput = inst->In;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  FSyPrM_B->BusInput1 = inst->Para;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  FSyPrM_B->BusInput2 = inst->Perm;

  /* Switch: '<S9>/Switch1' incorporates:
   *  Product: '<S9>/Divide1'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S3>/Environment Switch'
   *  Switch: '<S4>/Environment Switch'
   */
  if (FSyPrM_B->BusInput2.bF_act_ena) {
    /* Switch: '<S16>/Switch' incorporates:
     *  Abs: '<S16>/Abs'
     *  RelationalOperator: '<S16>/Relational Operator'
     *  Switch: '<S4>/Environment Switch'
     */
    if (1.0F >= (real32_T)fabs(FSyPrM_B->BusInput1.rF_Nom)) {
      gk = 1.0F;
    } else {
      gk = FSyPrM_B->BusInput1.rF_Nom;
    }

    /* End of Switch: '<S16>/Switch' */
    rtb_Switch1_i = FSyPrM_B->BusInput.rF_MMD * FSyPrM_B->BusInput1.rN_EngNom /
      gk;
  } else {
    rtb_Switch1_i = FSyPrM_B->BusInput.rN_Eng;
  }

  /* End of Switch: '<S9>/Switch1' */

  /* Outputs for Atomic SubSystem: '<S1>/Filter' */
  /* DiscreteIntegrator: '<S10>/Discrete-Time Integrator' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  if (FSyPrM_DWork->DiscreteTimeIntegrator_IC_LO_dn != 0) {
    FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_k = rtb_Switch1_i;
  }

  if (FSyPrM_B->BusInput.bReset ||
      (FSyPrM_DWork->DiscreteTimeIntegrator_PrevRe_d != 0)) {
    FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_k = rtb_Switch1_i;
  }

  rtb_DiscreteTimeIntegrator_g = FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_k;

  /* Update for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
  FSyPrM_DWork->DiscreteTimeIntegrator_IC_LO_dn = 0U;

  /* Switch: '<S12>/Switch' incorporates:
   *  Abs: '<S12>/Abs'
   *  RelationalOperator: '<S12>/Relational Operator'
   *  Switch: '<S3>/Environment Switch'
   */
  if (2.22044605E-16F >= (real32_T)fabs(FSyPrM_B->BusInput2.rTi_Filtn)) {
    gk = 2.22044605E-16F;
  } else {
    gk = FSyPrM_B->BusInput2.rTi_Filtn;
  }

  /* End of Switch: '<S12>/Switch' */

  /* Update for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' incorporates:
   *  Product: '<S10>/Divide4'
   *  Sum: '<S10>/Sum4'
   *  Switch: '<S2>/Environment Switch'
   */
  FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_k += (rtb_Switch1_i -
    FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_k) / gk * 0.01F;
  FSyPrM_DWork->DiscreteTimeIntegrator_PrevRe_d = (int8_T)
    FSyPrM_B->BusInput.bReset;

  /* End of Outputs for SubSystem: '<S1>/Filter' */

  /* Outputs for Atomic SubSystem: '<S1>/Filter1' */
  /* DiscreteIntegrator: '<S11>/Discrete-Time Integrator' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  if (FSyPrM_DWork->DiscreteTimeIntegrator_IC_LOA_d != 0) {
    FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_g = rtb_DiscreteTimeIntegrator_g;
  }

  if (FSyPrM_B->BusInput.bReset ||
      (FSyPrM_DWork->DiscreteTimeIntegrator_PrevRe_h != 0)) {
    FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_g = rtb_DiscreteTimeIntegrator_g;
  }

  /* Product: '<S11>/Divide4' incorporates:
   *  DiscreteIntegrator: '<S11>/Discrete-Time Integrator'
   *  Sum: '<S11>/Sum4'
   */
  rtb_DiscreteTimeIntegrator_g = (rtb_DiscreteTimeIntegrator_g -
    FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_g) / 0.01F;

  /* Switch: '<S11>/Switch1' incorporates:
   *  Constant: '<S11>/Constant'
   *  Switch: '<S2>/Environment Switch'
   */
  if (FSyPrM_B->BusInput.bReset) {
    rtb_Switch1 = 0.0;
  } else {
    rtb_Switch1 = rtb_DiscreteTimeIntegrator_g;
  }

  /* End of Switch: '<S11>/Switch1' */

  /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  FSyPrM_DWork->DiscreteTimeIntegrator_IC_LOA_d = 0U;
  FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE_g += 0.01F *
    rtb_DiscreteTimeIntegrator_g;
  FSyPrM_DWork->DiscreteTimeIntegrator_PrevRe_h = (int8_T)
    FSyPrM_B->BusInput.bReset;

  /* End of Outputs for SubSystem: '<S1>/Filter1' */

  /* Outputs for Atomic SubSystem: '<S9>/Filter' */
  /* DiscreteIntegrator: '<S18>/Discrete-Time Integrator' incorporates:
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S4>/Environment Switch'
   */
  if (FSyPrM_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE = FSyPrM_B->BusInput1.rN_EngNom;
  }

  if (FSyPrM_B->BusInput.bReset ||
      (FSyPrM_DWork->DiscreteTimeIntegrator_PrevRese != 0)) {
    FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE = FSyPrM_B->BusInput1.rN_EngNom;
  }

  rtb_DiscreteTimeIntegrator_g = FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE;

  /* Update for DiscreteIntegrator: '<S18>/Discrete-Time Integrator' */
  FSyPrM_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* End of Outputs for SubSystem: '<S9>/Filter' */

  /* Switch: '<S17>/Switch' incorporates:
   *  Abs: '<S17>/Abs'
   *  RelationalOperator: '<S17>/Relational Operator'
   *  Switch: '<S4>/Environment Switch'
   */
  if (1.0F >= (real32_T)fabs(FSyPrM_B->BusInput1.rF_Nom)) {
    gk = 1.0F;
  } else {
    gk = FSyPrM_B->BusInput1.rF_Nom;
  }

  /* End of Switch: '<S17>/Switch' */

  /* Outputs for Atomic SubSystem: '<S9>/Filter' */
  /* Switch: '<S21>/Switch' incorporates:
   *  Abs: '<S21>/Abs'
   *  RelationalOperator: '<S21>/Relational Operator'
   *  Switch: '<S3>/Environment Switch'
   */
  if (2.22044605E-16F >= (real32_T)fabs(FSyPrM_B->BusInput2.rTi_FiltF)) {
    tmp_0 = 2.22044605E-16F;
  } else {
    tmp_0 = FSyPrM_B->BusInput2.rTi_FiltF;
  }

  /* End of Switch: '<S21>/Switch' */

  /* Update for DiscreteIntegrator: '<S18>/Discrete-Time Integrator' incorporates:
   *  Product: '<S18>/Divide4'
   *  Product: '<S9>/Divide'
   *  Sum: '<S18>/Sum4'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S4>/Environment Switch'
   */
  FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE +=
    (FSyPrM_B->BusInput.rF_MMD_BusBar / gk * FSyPrM_B->BusInput1.rN_EngNom -
     FSyPrM_DWork->DiscreteTimeIntegrator_DSTATE) / tmp_0 * 0.01F;
  FSyPrM_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)
    FSyPrM_B->BusInput.bReset;

  /* End of Outputs for SubSystem: '<S9>/Filter' */

  /* Switch: '<S9>/Switch' incorporates:
   *  Constant: '<S9>/Constant1'
   *  Logic: '<S9>/Logical Operator'
   *  Product: '<S9>/Product'
   *  RelationalOperator: '<S9>/Relational Operator'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S3>/Environment Switch'
   *  Switch: '<S4>/Environment Switch'
   */
  if (FSyPrM_B->BusInput2.bSpeedSet_ena || (FSyPrM_B->BusInput.rF_MMD_BusBar <
       0.5F * FSyPrM_B->BusInput1.rF_Nom)) {
    rtb_DiscreteTimeIntegrator_g = FSyPrM_B->BusInput1.rN_EngNom;
  }

  /* End of Switch: '<S9>/Switch' */

  /* MATLAB Function: '<Root>/Skipfire_active' incorporates:
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S3>/Environment Switch'
   */
  /* MATLAB Function 'Skipfire_active': '<S7>:1' */
  if (FSyPrM_B->BusInput.rN_Eng >= FSyPrM_B->BusInput2.rN_enableNorm *
      rtb_DiscreteTimeIntegrator_g) {
    /* '<S7>:1:16' */
    /* '<S7>:1:17' */
    FSyPrM_DWork->ssr = true;
  }

  if ((rtb_Switch1 < FSyPrM_B->BusInput2.rN_dot_release) && ((real32_T)fabs
       (FSyPrM_B->BusInput.rN_Eng - rtb_DiscreteTimeIntegrator_g) <
       FSyPrM_B->BusInput2.rN_SpdSettled)) {
    /* '<S7>:1:20' */
    /* '<S7>:1:21' */
    FSyPrM_DWork->spd_settled = true;
  }

  if (FSyPrM_DWork->spd_settled && ((real32_T)fabs(FSyPrM_B->BusInput.rN_Eng -
        rtb_DiscreteTimeIntegrator_g) > FSyPrM_B->BusInput2.rN_SpdDevMax)) {
    /* '<S7>:1:24' */
    /* '<S7>:1:25' */
    FSyPrM_DWork->spd_DevExc = true;
  }

  if (FSyPrM_B->BusInput.bGCB_ON || (FSyPrM_B->BusInput.rN_Eng < 100.0F)) {
    /* '<S7>:1:28' */
    /* '<S7>:1:29' */
    FSyPrM_DWork->ssr = false;

    /* '<S7>:1:30' */
    FSyPrM_DWork->spd_settled = false;

    /* '<S7>:1:31' */
    FSyPrM_DWork->spd_DevExc = false;
  }

  /* Switch: '<S9>/Switch2' incorporates:
   *  Constant: '<S9>/Constant'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S3>/Environment Switch'
   */
  /* '<S7>:1:35' */
  /* '<S7>:1:36' */
  /* '<S7>:1:37' */
  if (FSyPrM_B->BusInput.bFastSync) {
    rtb_Switch2 = FSyPrM_B->BusInput2.iCtrSel;
  } else {
    rtb_Switch2 = 0;
  }

  /* End of Switch: '<S9>/Switch2' */

  /* MATLAB Function: '<Root>/FSyncITPCtrl' incorporates:
   *  Gain: '<S9>/Conv rad'
   *  MATLAB Function: '<Root>/Skipfire_active'
   *  Outport: '<Root>/dbg'
   *  Product: '<S8>/Product1'
   *  SampleTimeMath: '<S8>/Weighted Sample Time'
   *  Switch: '<S2>/Environment Switch'
   *  Switch: '<S3>/Environment Switch'
   *
   * About '<S8>/Weighted Sample Time':
   *  y = K where K = 1 / ( w * Ts )
   */
  /* MATLAB Function 'FSyncITPCtrl': '<S5>:1' */
  if ((!FSyPrM_DWork->CA_retarded_not_empty) || (!FSyPrM_DWork->ssr) ||
      (rtb_Switch2 == 0)) {
    /* '<S5>:1:10' */
    /* '<S5>:1:11' */
    FSyPrM_DWork->CA_retarded = FSyPrM_B->BusInput2.rCA_ITPRetardMax;
    FSyPrM_DWork->CA_retarded_not_empty = true;

    /* '<S5>:1:12' */
    FSyPrM_DWork->retardcounter = 0U;

    /* '<S5>:1:13' */
    FSyPrM_DWork->Count_Switch = 0U;
  }

  if (FSyPrM_DWork->spd_settled) {
    /* '<S5>:1:18' */
    if ((FSyPrM_DWork->Count_Switch < FSyPrM_B->BusInput2.rTi_FastSync * 100.0F)
        && (rtb_Switch2 >= 1) && (!FSyPrM_DWork->spd_DevExc)) {
      /* '<S5>:1:19' */
      /* '<S5>:1:20' */
      tmp = FSyPrM_DWork->Count_Switch + 1U;
      if (tmp > 65535U) {
        tmp = 65535U;
      }

      FSyPrM_DWork->Count_Switch = (uint16_T)tmp;

      /* '<S5>:1:21' */
      bEnabled = true;
    } else {
      /* '<S5>:1:23' */
      bEnabled = false;
    }
  } else {
    /* '<S5>:1:26' */
    bEnabled = false;
  }

  if (FSyPrM_DWork->retardcounter < 2000) {
    /* '<S5>:1:30' */
    /* '<S5>:1:31' */
    tmp = FSyPrM_DWork->retardcounter + 1U;
    if (tmp > 65535U) {
      tmp = 65535U;
    }

    FSyPrM_DWork->retardcounter = (uint16_T)tmp;
  } else {
    /* '<S5>:1:33' */
    FSyPrM_DWork->retardcounter = 0U;
  }

  /* '<S5>:1:39' */
  rN_err = rtb_Switch1_i - rtb_DiscreteTimeIntegrator_g;

  /* '<S5>:1:40' */
  rAngle_err = 0.0174532924F * FSyPrM_B->BusInput.rAng_MMD_Diff -
    FSyPrM_B->BusInput2.rAngleSetDeg * 3.14159274F / 180.0F;

  /* '<S5>:1:42' */
  S_tmp = (real32_T)fabs(rN_err);
  S = 0.5F * rN_err * S_tmp * 2.0F * 3.14159274F / 30.0F * 2.0F * 3.14159274F /
    30.0F + rAngle_err;
  if ((0.5F * rN_err * rN_err * 2.0F * 3.14159274F / 30.0F * 2.0F * 3.14159274F /
       30.0F + rAngle_err == 0.0F) && (rN_err >= 0.0F)) {
    /* '<S5>:1:43' */
    Sf1 = true;
  } else {
    Sf1 = false;
  }

  gk = -0.5F * rN_err * rN_err * 2.0F * 3.14159274F / 30.0F * 2.0F * 3.14159274F
    / 30.0F + rAngle_err;
  if ((gk == 0.0F) && (rN_err <= 0.0F)) {
    /* '<S5>:1:44' */
    Sf2 = true;
  } else {
    Sf2 = false;
  }

  /* '<S5>:1:45' */
  tmp_0 = FSyPrM_B->BusInput2.rRelaxAngleDeg * 3.14159274F / 180.0F;
  if ((S <= tmp_0) && (S >= -FSyPrM_B->BusInput2.rRelaxAngleDeg * 3.14159274F /
                       180.0F) && (-rN_err < 0.0F)) {
    /* '<S5>:1:47' */
    Gplus = true;
  } else {
    Gplus = false;
  }

  if ((S <= tmp_0) && (S >= -FSyPrM_B->BusInput2.rRelaxAngleDeg * 3.14159274F /
                       180.0F) && (-rN_err > 0.0F)) {
    /* '<S5>:1:48' */
    Gminus = true;
  } else {
    Gminus = false;
  }

  /* '<S5>:1:49' */
  /* '<S5>:1:50' */
  /* '<S5>:1:51' */
  if ((gk == tmp_0) && (-rN_err < 0.0F)) {
    /* '<S5>:1:52' */
    Gammaplus = true;
  } else {
    Gammaplus = false;
  }

  gk = -FSyPrM_B->BusInput2.rRelaxAngleDeg * 3.14159274F / 180.0F;
  if ((gk == S) && (-rN_err > 0.0F)) {
    /* '<S5>:1:53' */
    Gammaminus = true;
  } else {
    Gammaminus = false;
  }

  if (Gplus || (S < gk)) {
    /* '<S5>:1:54' */
    Gplus = true;
  }

  if (Gminus || (S > tmp_0)) {
    /* '<S5>:1:55' */
    Gminus = true;
  }

  /* '<S5>:1:57' */
  gk = (FSyPrM_B->BusInput2.rWeightFuel + 4.0F) / (2.0F *
    FSyPrM_B->BusInput2.rWeightFuel);
  if ((S >= 0.0F) && (gk * rN_err * S_tmp * 2.0F * 3.14159274F / 30.0F * 2.0F *
                      3.14159274F / 30.0F + rAngle_err > 0.0F)) {
    /* '<S5>:1:58' */
    H1 = true;
  } else {
    H1 = false;
  }

  if ((S <= 0.0F) && (gk * rN_err * (real32_T)fabs(rN_err) * 2.0F * 3.14159274F /
                      30.0F * 2.0F * 3.14159274F / 30.0F + rAngle_err < 0.0F)) {
    /* '<S5>:1:60' */
    H3 = true;
  } else {
    H3 = false;
  }

  if ((S > 0.0F) && (gk * rN_err * (real32_T)fabs(rN_err) * 2.0F * 3.14159274F /
                     30.0F * 2.0F * 3.14159274F / 30.0F + rAngle_err <= 0.0F)) {
    /* '<S5>:1:61' */
    FSyPrM_Y->dbg.H4 = true;
  } else {
    FSyPrM_Y->dbg.H4 = false;
  }

  /* '<S5>:1:62' */
  /* '<S5>:1:66' */
  switch (rtb_Switch2) {
   case 1:
    if ((S > FSyPrM_B->BusInput2.rHystOptimal) || (Sf2 && FSyPrM_DWork->ssr)) {
      /* '<S5>:1:68' */
      /* '<S5>:1:69' */
      FSyPrM_DWork->CA_retarded = FSyPrM_B->BusInput2.rCA_ITPRetardMin;

      /* '<S5>:1:70' */
      FSyPrM_DWork->retardcounter = 0U;
    } else {
      if ((S < -FSyPrM_B->BusInput2.rHystOptimal) || (Sf1 && FSyPrM_DWork->ssr))
      {
        /* '<S5>:1:71' */
        /* '<S5>:1:72' */
        FSyPrM_DWork->CA_retarded = FSyPrM_B->BusInput2.rCA_ITPRetardMax;

        /* '<S5>:1:73' */
        FSyPrM_DWork->retardcounter = 0U;
      }
    }
    break;

   case 2:
    if ((Gminus || Gammaminus) && FSyPrM_DWork->ssr) {
      /* '<S5>:1:77' */
      /* '<S5>:1:78' */
      FSyPrM_DWork->CA_retarded = FSyPrM_B->BusInput2.rCA_ITPRetardMin;

      /* '<S5>:1:79' */
      FSyPrM_DWork->retardcounter = 0U;
    } else {
      if ((Gplus || Gammaplus) && FSyPrM_DWork->ssr) {
        /* '<S5>:1:80' */
        /* '<S5>:1:81' */
        FSyPrM_DWork->CA_retarded = FSyPrM_B->BusInput2.rCA_ITPRetardMax;

        /* '<S5>:1:82' */
        FSyPrM_DWork->retardcounter = 0U;
      }
    }
    break;

   case 3:
    if (H1 && FSyPrM_DWork->ssr) {
      /* '<S5>:1:86' */
      /* '<S5>:1:87' */
      FSyPrM_DWork->CA_retarded = FSyPrM_B->BusInput2.rCA_ITPRetardMin;

      /* '<S5>:1:88' */
      FSyPrM_DWork->retardcounter = 0U;
    } else {
      if (H3 && FSyPrM_DWork->ssr) {
        /* '<S5>:1:89' */
        /* '<S5>:1:90' */
        FSyPrM_DWork->CA_retarded = FSyPrM_B->BusInput2.rCA_ITPRetardMax;

        /* '<S5>:1:91' */
        FSyPrM_DWork->retardcounter = 0U;
      }
    }
    break;

   default:
    /* '<S5>:1:99' */
    FSyPrM_DWork->CA_retarded = FSyPrM_B->BusInput2.rCA_ITPRetardMax;

    /* '<S5>:1:100' */
    FSyPrM_DWork->retardcounter = 0U;
    break;
  }

  if (!FSyPrM_DWork->ssr) {
    /* Outport: '<Root>/rRetardITP' */
    /* '<S5>:1:105' */
    /* '<S5>:1:106' */
    FSyPrM_Y->rRetardITP = FSyPrM_B->BusInput2.rCA_ITPRetardMax;
  } else if (bEnabled) {
    /* Outport: '<Root>/rRetardITP' */
    /* '<S5>:1:108' */
    /* '<S5>:1:109' */
    FSyPrM_Y->rRetardITP = FSyPrM_DWork->CA_retarded;
  } else {
    /* Outport: '<Root>/rRetardITP' */
    /* '<S5>:1:111' */
    FSyPrM_Y->rRetardITP = FSyPrM_B->BusInput2.rCA_ITPRetardMax;
  }

  /* '<S5>:1:116' */
  FSyPrM_Y->dbg.iRetardCounter = FSyPrM_DWork->retardcounter;

  /* '<S5>:1:117' */
  FSyPrM_Y->dbg.rSwitchSurf = S;

  /* '<S5>:1:118' */
  FSyPrM_Y->dbg.Sf1 = Sf1;

  /* '<S5>:1:119' */
  FSyPrM_Y->dbg.Sf2 = Sf2;

  /* '<S5>:1:120' */
  FSyPrM_Y->dbg.H3 = H3;

  /* '<S5>:1:121' */
  /* '<S5>:1:122' */
  FSyPrM_Y->dbg.rSmodSlid = 10.0F * rN_err * 2.0F * 3.14159274F / 30.0F * 2.0F *
    3.14159274F / 30.0F + rAngle_err;

  /* '<S5>:1:123' */
  FSyPrM_Y->dbg.iCounterSwitch = FSyPrM_DWork->Count_Switch;

  /* '<S5>:1:124' */
  FSyPrM_Y->dbg.bEna = FSyPrM_DWork->ssr;

  /* '<S5>:1:125' */
  FSyPrM_Y->dbg.iCtrSel = rtb_Switch2;

  /* '<S5>:1:126' */
  FSyPrM_Y->dbg.rN_Set = rtb_DiscreteTimeIntegrator_g;

  /* '<S5>:1:127' */
  FSyPrM_Y->dbg.rN_Eng = rtb_Switch1_i;

  /* '<S5>:1:128' */
  FSyPrM_Y->dbg.bSpdSettled = FSyPrM_DWork->spd_settled;

  /* '<S5>:1:129' */
  FSyPrM_Y->dbg.rN_dot = (real32_T)rtb_Switch1;
  FSyPrM_B->bEnabled = bEnabled;

  /* End of MATLAB Function: '<Root>/FSyncITPCtrl' */

  /* S-Function (bur_bus_out): '<Root>/Bus Output' incorporates:
   *  Outport: '<Root>/dbg'
   */
  inst->Dbg = FSyPrM_Y->dbg;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->bEnabled = FSyPrM_B->bEnabled;

  /* S-Function (bur_out): '<Root>/Output2' incorporates:
   *  Outport: '<Root>/rRetardITP'
   */
  inst->rRetardITP = FSyPrM_Y->rRetardITP;

  /* UnitDelay: '<S6>/Unit Delay' */
  FSyPrM_B->UnitDelay = FSyPrM_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Version = FSyPrM_B->UnitDelay;

  /* Update for UnitDelay: '<S6>/Unit Delay' */
  FSyPrM_DWork->UnitDelay_DSTATE = 8U;
}

/* Model initialize function */
void FSyPrM_initialize(RT_MODEL_FSyPrM *const FSyPrM_M, struct fFSyPrM* inst)
{
  struct D_Work_FSyPrM *FSyPrM_DWork = ((struct D_Work_FSyPrM *) FSyPrM_M->dwork);

  /* SystemInitialize for Atomic SubSystem: '<S1>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
  FSyPrM_DWork->DiscreteTimeIntegrator_IC_LO_dn = 1U;

  /* End of SystemInitialize for SubSystem: '<S1>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S1>/Filter1' */
  /* InitializeConditions for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  FSyPrM_DWork->DiscreteTimeIntegrator_IC_LOA_d = 1U;

  /* End of SystemInitialize for SubSystem: '<S1>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S9>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S18>/Discrete-Time Integrator' */
  FSyPrM_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* End of SystemInitialize for SubSystem: '<S9>/Filter' */
}

/* Model terminate function */
void FSyPrM_terminate(RT_MODEL_FSyPrM *const FSyPrM_M, struct fFSyPrM* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(FSyPrM_M);
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.8 (R2020a)18-Nov-2019                                             *
 * Simulink 10.1 (R2020a)18-Nov-2019                                          *
 * Simulink Coder 9.3 (R2020a)18-Nov-2019                                     *
 * Embedded Coder 7.4 (R2020a)18-Nov-2019                                     *
 * Stateflow 10.2 (R2020a)18-Nov-2019                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
