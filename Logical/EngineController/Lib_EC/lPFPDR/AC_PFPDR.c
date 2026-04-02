/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_PFPDR
 * File: AC_PFPDR.c
 * Author: 502423184
 * Created: Fri Apr 24 12:55:11 2015
 ********************************************************************
 * Implementation of program AC_PFPDR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "AC_PFPDR.h"
#include "AC_PFPDR_private.h"

/*  Defines */

/* Named constants for Chart: '<S5>/Chart (MATLAB)' */
#define AC_PFPDR_IN_Abort              ((uint8_T)1U)
#define AC_PFPDR_IN_Detection          ((uint8_T)1U)
#define AC_PFPDR_IN_DetectionRun       ((uint8_T)2U)
#define AC_PFPDR_IN_EGTSR              ((uint8_T)3U)
#define AC_PFPDR_IN_IDLE               ((uint8_T)4U)
#define AC_PFPDR_IN_IgnitionPoint      ((uint8_T)2U)
#define AC_PFPDR_IN_IgnpointReturn     ((uint8_T)3U)
#define AC_PFPDR_IN_Lambda             ((uint8_T)4U)
#define AC_PFPDR_IN_LambdaReturn       ((uint8_T)5U)
#define AC_PFPDR_IN_NO_ACTIVE_CHILD    ((uint8_T)0U)
#define AC_PFPDR_IN_SaveProfile        ((uint8_T)6U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/* Forward declaration for local functions */
static void AC_PFP_enter_atomic_SaveProfile(struct BlockIO_AC_PFPDR *AC_PFPDR_B,
  struct D_Work_AC_PFPDR *AC_PFPDR_DWork, struct PFPDR* inst);
static void AC_PFPDR_exit_atomic_EGTSR(struct BlockIO_AC_PFPDR *AC_PFPDR_B, struct PFPDR* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/*
 * Output and update for atomic system:
 *    '<S9>/TON'
 *    '<S9>/TON1'
 */
void AC_PFPDR_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_AC_PFPDR *localB,
                  rtDW_TON_AC_PFPDR *localDW, struct PFPDR* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_RelationalOperator;

  /* Logic: '<S13>/Logical Operator2' */
  rtb_LogicalOperator2 = !rtu_IN;

  /* DiscreteIntegrator: '<S13>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2 || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S13>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S13>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator = (localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Logic: '<S13>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator && rtu_IN);

  /* Update for DiscreteIntegrator: '<S13>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S15>/Conversion'
   *  Logic: '<S13>/Logical Operator'
   *  Logic: '<S13>/Logical Operator1'
   */
  if (!rtb_LogicalOperator2) {
    localDW->DiscreteTimeIntegrator_DSTATE += (real32_T)
      ((!rtb_RelationalOperator) && rtu_IN) * 0.01F;
  }

  if (rtb_LogicalOperator2) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S13>/Discrete-Time Integrator' */
}

/* Function for Chart: '<S5>/Chart (MATLAB)' */
static void AC_PFP_enter_atomic_SaveProfile(struct BlockIO_AC_PFPDR *AC_PFPDR_B,
  struct D_Work_AC_PFPDR *AC_PFPDR_DWork, struct PFPDR* inst)
{
  uint8_T iCyl;
  int32_T i;

  /* Entry 'SaveProfile': '<S7>:74' */
  AC_PFPDR_B->iSubState = 4;
  for (i = 0; i < 25; i++) {
    AC_PFPDR_B->rCA_IP_aDR[i] = AC_PFPDR_DWork->rCA_IgnP_Act_Filt[i] /
      AC_PFPDR_DWork->rCnt_Filt;
  }

  /* Store actual Ignition Points */
  AC_PFPDR_B->rCA_IP_aDR_Max = 0.0F;
  i = (int32_T)((uint32_T)AC_PFPDR_B->u4Cylinder + 1U);
  if ((uint32_T)i > 255U) {
    i = 255;
  }

  for (iCyl = 2U; iCyl <= (uint8_T)i; iCyl = (uint8_T)((uint32_T)iCyl + 1U)) {
    if (AC_PFPDR_B->rCA_IP_aDR_Max < AC_PFPDR_B->rCA_IP_aDR[iCyl - 1]) {
      AC_PFPDR_B->rCA_IP_aDR_Max = AC_PFPDR_B->rCA_IP_aDR[iCyl - 1];
    }
  }

  i = (int32_T)((uint32_T)AC_PFPDR_B->u4Cylinder + 1U);
  if ((uint32_T)i > 255U) {
    i = 255;
  }

  for (iCyl = 2U; iCyl <= (uint8_T)i; iCyl = (uint8_T)((uint32_T)iCyl + 1U)) {
    AC_PFPDR_B->rCA_IP_aDR_Offs[iCyl - 1] = AC_PFPDR_B->rCA_IP_aDR[iCyl - 1] +
      -AC_PFPDR_B->rCA_IP_aDR_Max;
  }
}

/* Function for Chart: '<S5>/Chart (MATLAB)' */
static void AC_PFPDR_exit_atomic_EGTSR(struct BlockIO_AC_PFPDR *AC_PFPDR_B, struct PFPDR* inst)
{
  uint8_T iCyl;
  real32_T rT_EG_Avg;
  int32_T i;
  real32_T rT_EG_Avg_0;

  /* Exit 'EGTSR': '<S7>:5' */
  /* rT_EG_Avg = sum(rT_EG_Act(2:iNum_Cyl+1))/iNum_Cyl; */
  rT_EG_Avg = 0.0F;
  i = (int32_T)((uint32_T)AC_PFPDR_B->u4Cylinder + 1U);
  if ((uint32_T)i > 255U) {
    i = 255;
  }

  for (iCyl = 2U; iCyl <= (uint8_T)i; iCyl = (uint8_T)((uint32_T)iCyl + 1U)) {
    rT_EG_Avg += AC_PFPDR_B->rT_EG_Act[iCyl - 1];
  }

  rT_EG_Avg /= (real32_T)AC_PFPDR_B->u4Cylinder;

  /* too cold cylinders: */
  /* too hot cylinders: */
  rT_EG_Avg_0 = rT_EG_Avg + AC_PFPDR_B->rT_EG_DevLim;
  for (i = 0; i < 25; i++) {
    AC_PFPDR_B->rCA_IP_EGT_Offs[i] = (real32_T)((AC_PFPDR_B->rT_EG_Act[i] <
      rT_EG_Avg - AC_PFPDR_B->rT_EG_DevLim) && (AC_PFPDR_B->rT_EG_Act[i] >
      rT_EG_Avg - 50.0F)) * -AC_PFPDR_B->rCA_IP_EGT;
    AC_PFPDR_B->rCA_IP_EGT_Offs[i] += (real32_T)((AC_PFPDR_B->rT_EG_Act[i] >
      rT_EG_Avg_0) && (AC_PFPDR_B->rT_EG_Act[i] < rT_EG_Avg + 50.0F)) *
      AC_PFPDR_B->rCA_IP_EGT;
  }
}

real_T rt_roundd(real_T u, struct PFPDR* inst)
{
  real_T y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

/* Model step function */
void AC_PFPDR_step(struct BlockIO_AC_PFPDR *AC_PFPDR_B, struct D_Work_AC_PFPDR *AC_PFPDR_DWork, struct PFPDR* inst)
{
  /* local block i/o variables */
  real32_T rtb_rT_Abort_Delay;
  real32_T rtb_Subtract;
  boolean_T rtb_Abort;
  real32_T rCA_IP_Max;
  uint8_T rtb_iNum_Cyl;
  boolean_T rtb_abort1;
  boolean_T rtb_abort2;
  boolean_T rtb_abort3;
  int32_T rtb_Switch;
  int32_T i;

  /* S-Function (bur_bus_in): '<S2>/Bus Input1' */
  AC_PFPDR_B->BusInput1 = inst->in;

  /* BusSelector: '<S2>/BusConversion_InsertedFor_Bus Creator_at_inport_0' */
  AC_PFPDR_B->bStartTrigger = AC_PFPDR_B->BusInput1.bStartTrigger;
  for (i = 0; i < 25; i++) {
    AC_PFPDR_B->rT_EG_Act[i] = AC_PFPDR_B->BusInput1.rT_EG_Act[i];
    AC_PFPDR_B->rCA_IP_Act[i] = AC_PFPDR_B->BusInput1.rCA_IP_Act[i];
  }

  rtb_iNum_Cyl = AC_PFPDR_B->BusInput1.iNum_Cyl;
  AC_PFPDR_B->bMisfLim = AC_PFPDR_B->BusInput1.bMisfLim;
  AC_PFPDR_B->bManAbort = AC_PFPDR_B->BusInput1.bManAbort;
  AC_PFPDR_B->bReset = AC_PFPDR_B->BusInput1.bReset;
  AC_PFPDR_B->rLam_Act = AC_PFPDR_B->BusInput1.rLam_Act;
  AC_PFPDR_B->bSteadyState = AC_PFPDR_B->BusInput1.bSteadyState;

  /* End of BusSelector: '<S2>/BusConversion_InsertedFor_Bus Creator_at_inport_0' */

  /* UnitDelay: '<S5>/Unit Delay' */
  AC_PFPDR_B->UnitDelay = AC_PFPDR_DWork->UnitDelay_DSTATE;

  /* UnitDelay: '<S5>/Unit Delay1' */
  AC_PFPDR_B->UnitDelay1 = AC_PFPDR_DWork->UnitDelay1_DSTATE;

  /* S-Function (bur_bus_in): '<S2>/Bus Input' */
  AC_PFPDR_B->BusInput = inst->par;

  /* BusSelector: '<S2>/BusConversion_InsertedFor_Bus Creator_at_inport_1' */
  AC_PFPDR_B->rCA_IP_MaxLim = AC_PFPDR_B->BusInput.rCA_IP_MaxLim;
  AC_PFPDR_B->rT_EG_DevLim = AC_PFPDR_B->BusInput.rT_EG_DevLim;
  AC_PFPDR_B->rCA_IP_EGT = AC_PFPDR_B->BusInput.rCA_IP_EGT;
  rtb_rT_Abort_Delay = AC_PFPDR_B->BusInput.rT_Abort_Delay;

  /* Product: '<S5>/Divide' incorporates:
   *  Constant: '<S5>/Constant'
   */
  AC_PFPDR_B->Divide = AC_PFPDR_B->BusInput.rTi_EGT_Delay / 0.01F;

  /* Product: '<S5>/Product' incorporates:
   *  Constant: '<S5>/Constant'
   */
  AC_PFPDR_B->Product = AC_PFPDR_B->BusInput.rCA_IP_DR_SR * 0.01F;

  /* Product: '<S5>/Product1' incorporates:
   *  Constant: '<S5>/Constant'
   */
  AC_PFPDR_B->Product1 = AC_PFPDR_B->BusInput.rLam_DR_SR * 0.01F;

  /* Product: '<S5>/Product2' incorporates:
   *  Constant: '<S5>/Constant'
   */
  AC_PFPDR_B->Product2 = AC_PFPDR_B->BusInput.rCA_IP_DR_SR_Return * 0.01F;

  /* Product: '<S5>/Product3' incorporates:
   *  Constant: '<S5>/Constant'
   */
  AC_PFPDR_B->Product3 = AC_PFPDR_B->BusInput.rLam_DR_SR_Return * 0.01F;

  /* UnitDelay: '<S5>/Unit Delay2' */
  AC_PFPDR_B->UnitDelay2 = AC_PFPDR_DWork->UnitDelay2_DSTATE;

  /* Saturate: '<S5>/1-24 Cylinder' */
  if (rtb_iNum_Cyl >= 24) {
    AC_PFPDR_B->u4Cylinder = 24U;
  } else if (rtb_iNum_Cyl <= 1) {
    AC_PFPDR_B->u4Cylinder = 1U;
  } else {
    AC_PFPDR_B->u4Cylinder = rtb_iNum_Cyl;
  }

  /* End of Saturate: '<S5>/1-24 Cylinder' */

  /* Chart: '<S5>/Chart (MATLAB)' */
  /* Gateway: SimuBlock/PFPDR_Autocode/PFPDR/Chart (MATLAB) */
  /* During: SimuBlock/PFPDR_Autocode/PFPDR/Chart (MATLAB) */
  if (AC_PFPDR_DWork->is_active_c6_AC_PFPDR == 0U) {
    /* Entry: SimuBlock/PFPDR_Autocode/PFPDR/Chart (MATLAB) */
    AC_PFPDR_DWork->is_active_c6_AC_PFPDR = 1U;

    /* Entry Internal: SimuBlock/PFPDR_Autocode/PFPDR/Chart (MATLAB) */
    /* Transition: '<S7>:2' */
    AC_PFPDR_DWork->is_c6_AC_PFPDR = AC_PFPDR_IN_IDLE;

    /* Entry 'IDLE': '<S7>:1' */
    AC_PFPDR_B->iState = 0;
    AC_PFPDR_B->bLeanox_Man = FALSE;
    AC_PFPDR_B->bPFPDR_active = FALSE;
    AC_PFPDR_B->bEGTSR_active = FALSE;
  } else {
    switch (AC_PFPDR_DWork->is_c6_AC_PFPDR) {
     case AC_PFPDR_IN_Abort:
      /* During 'Abort': '<S7>:65' */
      /* Transition: '<S7>:68' */
      AC_PFPDR_DWork->is_c6_AC_PFPDR = AC_PFPDR_IN_IDLE;

      /* Entry 'IDLE': '<S7>:1' */
      AC_PFPDR_B->iState = 0;
      AC_PFPDR_B->bLeanox_Man = FALSE;
      AC_PFPDR_B->bPFPDR_active = FALSE;
      AC_PFPDR_B->bEGTSR_active = FALSE;
      break;

     case AC_PFPDR_IN_DetectionRun:
      /* During 'DetectionRun': '<S7>:7' */
      if (AC_PFPDR_DWork->bDR_Done) {
        /* Transition: '<S7>:6' */
        /* Exit Internal 'DetectionRun': '<S7>:7' */
        switch (AC_PFPDR_DWork->is_DetectionRun) {
         case AC_PFPDR_IN_IgnpointReturn:
          /* Exit 'IgnpointReturn': '<S7>:71' */
          AC_PFPDR_B->rCA_IP_DR_Offs = 0.0F;
          AC_PFPDR_DWork->bDR_Lam = TRUE;
          AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_NO_ACTIVE_CHILD;
          break;

         case AC_PFPDR_IN_LambdaReturn:
          /* Exit 'LambdaReturn': '<S7>:70' */
          AC_PFPDR_DWork->bDR_Lam = FALSE;
          AC_PFPDR_B->rLam_DR_Offs = 0.0F;
          AC_PFPDR_DWork->bDR_Done = TRUE;
          AC_PFPDR_B->bLeanox_Man = FALSE;
          AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_NO_ACTIVE_CHILD;
          break;

         default:
          AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_NO_ACTIVE_CHILD;
          break;
        }

        AC_PFPDR_DWork->is_c6_AC_PFPDR = AC_PFPDR_IN_EGTSR;

        /* Entry 'EGTSR': '<S7>:5' */
        /*  INIT routine */
        AC_PFPDR_B->iState = 2;
        AC_PFPDR_B->iSubState = 0;
        AC_PFPDR_DWork->iCnt = 0.0F;
        AC_PFPDR_DWork->bEGT_Done = FALSE;
        AC_PFPDR_B->bEGTSR_active = TRUE;
        AC_PFPDR_B->bPFPDR_active = FALSE;

        /*  CYCLIC routine */
      } else if (AC_PFPDR_B->bReset) {
        /* Transition: '<S7>:86' */
        /* Exit Internal 'DetectionRun': '<S7>:7' */
        switch (AC_PFPDR_DWork->is_DetectionRun) {
         case AC_PFPDR_IN_IgnpointReturn:
          /* Exit 'IgnpointReturn': '<S7>:71' */
          AC_PFPDR_B->rCA_IP_DR_Offs = 0.0F;
          AC_PFPDR_DWork->bDR_Lam = TRUE;
          AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_NO_ACTIVE_CHILD;
          break;

         case AC_PFPDR_IN_LambdaReturn:
          /* Exit 'LambdaReturn': '<S7>:70' */
          AC_PFPDR_DWork->bDR_Lam = FALSE;
          AC_PFPDR_B->rLam_DR_Offs = 0.0F;
          AC_PFPDR_DWork->bDR_Done = TRUE;
          AC_PFPDR_B->bLeanox_Man = FALSE;
          AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_NO_ACTIVE_CHILD;
          break;

         default:
          AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_NO_ACTIVE_CHILD;
          break;
        }

        AC_PFPDR_DWork->is_c6_AC_PFPDR = AC_PFPDR_IN_Abort;

        /* Entry 'Abort': '<S7>:65' */
        /*  INIT routine */
        AC_PFPDR_B->iState = 3;
        AC_PFPDR_B->bLeanox_Man = FALSE;
        AC_PFPDR_B->rCA_IP_DR_Offs = 0.0F;
        AC_PFPDR_B->rLam_DR_Offs = 0.0F;
      } else {
        if (AC_PFPDR_B->UnitDelay1) {
          for (i = 0; i < 25; i++) {
            AC_PFPDR_DWork->rCA_IgnP_Act_Filt[i] += AC_PFPDR_B->rCA_IP_Act[i];
          }

          AC_PFPDR_DWork->rCnt_Filt++;
        } else {
          for (i = 0; i < 25; i++) {
            AC_PFPDR_DWork->rCA_IgnP_Act_Filt[i] = AC_PFPDR_B->rCA_IP_Act[i];
          }

          AC_PFPDR_DWork->rCnt_Filt = 1.0F;
        }

        switch (AC_PFPDR_DWork->is_DetectionRun) {
         case AC_PFPDR_IN_Detection:
          /* During 'Detection': '<S7>:10' */
          /* Transition: '<S7>:11' */
          AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_IgnitionPoint;

          /* Entry 'IgnitionPoint': '<S7>:9' */
          AC_PFPDR_B->iSubState = 2;
          break;

         case AC_PFPDR_IN_IgnitionPoint:
          /* During 'IgnitionPoint': '<S7>:9' */
          if (AC_PFPDR_B->UnitDelay || AC_PFPDR_B->bManAbort) {
            /* Transition: '<S7>:8' */
            AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_SaveProfile;
            AC_PFP_enter_atomic_SaveProfile(AC_PFPDR_B, AC_PFPDR_DWork, inst);
          } else if (AC_PFPDR_DWork->bDR_Lam || (!AC_PFPDR_B->UnitDelay2)) {
            /* Transition: '<S7>:16' */
            AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_Lambda;

            /* Entry 'Lambda': '<S7>:15' */
            AC_PFPDR_B->iSubState = 3;
            AC_PFPDR_B->bLeanox_Man = TRUE;
          } else {
            rCA_IP_Max = AC_PFPDR_B->rCA_IP_Act[1];
            i = (int32_T)((uint32_T)AC_PFPDR_B->u4Cylinder + 1U);
            if ((uint32_T)i > 255U) {
              i = 255;
            }

            for (rtb_iNum_Cyl = 2U; rtb_iNum_Cyl <= (uint8_T)i; rtb_iNum_Cyl =
                 (uint8_T)((uint32_T)rtb_iNum_Cyl + 1U)) {
              if (rCA_IP_Max < AC_PFPDR_B->rCA_IP_Act[rtb_iNum_Cyl - 1]) {
                rCA_IP_Max = AC_PFPDR_B->rCA_IP_Act[rtb_iNum_Cyl - 1];
              }
            }

            AC_PFPDR_DWork->bDR_Lam = ((rCA_IP_Max >= AC_PFPDR_B->rCA_IP_MaxLim)
              || AC_PFPDR_B->bMisfLim);
            AC_PFPDR_B->rCA_IP_DR_Offs += AC_PFPDR_B->Product;
          }
          break;

         case AC_PFPDR_IN_IgnpointReturn:
          /* During 'IgnpointReturn': '<S7>:71' */
          if (AC_PFPDR_B->rCA_IP_DR_Offs <= 0.0F) {
            /* Transition: '<S7>:73' */
            /* Exit 'IgnpointReturn': '<S7>:71' */
            AC_PFPDR_B->rCA_IP_DR_Offs = 0.0F;
            AC_PFPDR_DWork->bDR_Lam = TRUE;
            AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_LambdaReturn;

            /* Entry 'LambdaReturn': '<S7>:70' */
            AC_PFPDR_B->iSubState = 5;
          } else {
            AC_PFPDR_B->rCA_IP_DR_Offs -= AC_PFPDR_B->Product2;
          }
          break;

         case AC_PFPDR_IN_Lambda:
          /* During 'Lambda': '<S7>:15' */
          if (AC_PFPDR_B->UnitDelay || AC_PFPDR_B->bManAbort) {
            /* Transition: '<S7>:17' */
            AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_SaveProfile;
            AC_PFP_enter_atomic_SaveProfile(AC_PFPDR_B, AC_PFPDR_DWork, inst);
          } else if (AC_PFPDR_B->UnitDelay2 && (!AC_PFPDR_DWork->bDR_Lam)) {
            /* Transition: '<S7>:82' */
            AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_IgnitionPoint;

            /* Entry 'IgnitionPoint': '<S7>:9' */
            AC_PFPDR_B->iSubState = 2;
          } else {
            AC_PFPDR_B->rLam_DR_Offs -= AC_PFPDR_B->Product1;
          }
          break;

         case AC_PFPDR_IN_LambdaReturn:
          /* During 'LambdaReturn': '<S7>:70' */
          if ((AC_PFPDR_B->rLam_DR_Offs >= 0.0F) || (!AC_PFPDR_DWork->bDR_Lam))
          {
            /* Transition: '<S7>:72' */
            /* Exit 'LambdaReturn': '<S7>:70' */
            AC_PFPDR_DWork->bDR_Lam = FALSE;
            AC_PFPDR_B->rLam_DR_Offs = 0.0F;
            AC_PFPDR_DWork->bDR_Done = TRUE;
            AC_PFPDR_B->bLeanox_Man = FALSE;
            AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_Detection;

            /* Entry 'Detection': '<S7>:10' */
            AC_PFPDR_B->iSubState = 1;
          } else {
            AC_PFPDR_B->rLam_DR_Offs += AC_PFPDR_B->Product3;
            if (AC_PFPDR_DWork->rLam_bDR < AC_PFPDR_B->rLam_Act) {
              AC_PFPDR_DWork->bDR_Lam = FALSE;
            }
          }
          break;

         default:
          /* During 'SaveProfile': '<S7>:74' */
          /* Transition: '<S7>:75' */
          AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_IgnpointReturn;

          /* Entry 'IgnpointReturn': '<S7>:71' */
          AC_PFPDR_B->iSubState = 6;
          break;
        }
      }
      break;

     case AC_PFPDR_IN_EGTSR:
      /* During 'EGTSR': '<S7>:5' */
      if (AC_PFPDR_DWork->bEGT_Done) {
        /* Transition: '<S7>:4' */
        AC_PFPDR_exit_atomic_EGTSR(AC_PFPDR_B, inst);
        AC_PFPDR_DWork->is_c6_AC_PFPDR = AC_PFPDR_IN_IDLE;

        /* Entry 'IDLE': '<S7>:1' */
        AC_PFPDR_B->iState = 0;
        AC_PFPDR_B->bLeanox_Man = FALSE;
        AC_PFPDR_B->bPFPDR_active = FALSE;
        AC_PFPDR_B->bEGTSR_active = FALSE;
      } else if (AC_PFPDR_B->bManAbort || AC_PFPDR_B->bReset) {
        /* Transition: '<S7>:67' */
        AC_PFPDR_exit_atomic_EGTSR(AC_PFPDR_B, inst);
        AC_PFPDR_DWork->is_c6_AC_PFPDR = AC_PFPDR_IN_Abort;

        /* Entry 'Abort': '<S7>:65' */
        /*  INIT routine */
        AC_PFPDR_B->iState = 3;
        AC_PFPDR_B->bLeanox_Man = FALSE;
        AC_PFPDR_B->rCA_IP_DR_Offs = 0.0F;
        AC_PFPDR_B->rLam_DR_Offs = 0.0F;
      } else {
        AC_PFPDR_DWork->iCnt++;
        AC_PFPDR_DWork->bEGT_Done = ((AC_PFPDR_DWork->iCnt > AC_PFPDR_B->Divide)
          && AC_PFPDR_B->bSteadyState);

        /*  EXIT routine */
      }
      break;

     default:
      /* During 'IDLE': '<S7>:1' */
      if (AC_PFPDR_B->bStartTrigger && AC_PFPDR_B->bSteadyState) {
        /* Transition: '<S7>:3' */
        AC_PFPDR_DWork->is_c6_AC_PFPDR = AC_PFPDR_IN_DetectionRun;

        /* Entry 'DetectionRun': '<S7>:7' */
        /*  INIT routine */
        AC_PFPDR_B->iState = 1;
        AC_PFPDR_B->bPFPDR_active = TRUE;
        AC_PFPDR_DWork->bDR_Done = FALSE;
        AC_PFPDR_DWork->bDR_Lam = FALSE;
        AC_PFPDR_B->bLeanox_Man = FALSE;
        AC_PFPDR_B->rCA_IP_DR_Offs = 0.0F;
        AC_PFPDR_B->rLam_DR_Offs = 0.0F;
        AC_PFPDR_B->rCA_IP_bDR_Avg = 0.0F;
        i = (int32_T)((uint32_T)AC_PFPDR_B->u4Cylinder + 1U);
        if ((uint32_T)i > 255U) {
          i = 255;
        }

        for (rtb_iNum_Cyl = 2U; rtb_iNum_Cyl <= (uint8_T)i; rtb_iNum_Cyl =
             (uint8_T)((uint32_T)rtb_iNum_Cyl + 1U)) {
          AC_PFPDR_B->rCA_IP_bDR_Avg += AC_PFPDR_B->rCA_IP_Act[rtb_iNum_Cyl - 1];
        }

        AC_PFPDR_B->rCA_IP_bDR_Avg /= (real32_T)AC_PFPDR_B->u4Cylinder;
        AC_PFPDR_DWork->rLam_bDR = AC_PFPDR_B->rLam_Act;
        for (i = 0; i < 25; i++) {
          AC_PFPDR_B->rCA_IP_bDR[i] = AC_PFPDR_B->rCA_IP_Act[i];
          AC_PFPDR_B->rCA_IP_aDR_Offs[i] = 0.0F;
          AC_PFPDR_DWork->rCA_IgnP_Act_Filt[i] = AC_PFPDR_B->rCA_IP_Act[i];
        }

        AC_PFPDR_DWork->rCnt_Filt = 1.0F;

        /* Entry Internal 'DetectionRun': '<S7>:7' */
        /* Transition: '<S7>:58' */
        AC_PFPDR_DWork->is_DetectionRun = AC_PFPDR_IN_Detection;

        /* Entry 'Detection': '<S7>:10' */
        AC_PFPDR_B->iSubState = 1;
      }
      break;
    }
  }

  /* End of Chart: '<S5>/Chart (MATLAB)' */

  /* BusCreator: '<S2>/BusConversion_InsertedFor_Bus Output_at_inport_0' incorporates:
   *  Logic: '<S2>/ZylOpt deact'
   *  SignalConversion: '<S2>/BusConversion_InsertedFor_Bus Output_at_inport_0'
   */
  AC_PFPDR_B->BusConversion_InsertedFor_BusOu.iState[0] = AC_PFPDR_B->iState;
  AC_PFPDR_B->BusConversion_InsertedFor_BusOu.iState[1] = AC_PFPDR_B->iSubState;
  AC_PFPDR_B->BusConversion_InsertedFor_BusOu.rLam_DR_Offs =
    AC_PFPDR_B->rLam_DR_Offs;
  AC_PFPDR_B->BusConversion_InsertedFor_BusOu.rCA_IP_DR_Offs =
    AC_PFPDR_B->rCA_IP_DR_Offs;
  AC_PFPDR_B->BusConversion_InsertedFor_BusOu.bLeanox_Man =
    AC_PFPDR_B->bLeanox_Man;
  for (i = 0; i < 25; i++) {
    AC_PFPDR_B->BusConversion_InsertedFor_BusOu.rCA_IP_DR_Profile[i] =
      AC_PFPDR_B->rCA_IP_aDR_Offs[i];
    AC_PFPDR_B->BusConversion_InsertedFor_BusOu.rCA_IP_EGT_Profile[i] =
      AC_PFPDR_B->rCA_IP_EGT_Offs[i];
  }

  AC_PFPDR_B->BusConversion_InsertedFor_BusOu.bPFPDR_act =
    AC_PFPDR_B->bPFPDR_active;
  AC_PFPDR_B->BusConversion_InsertedFor_BusOu.bEGTSR_act =
    AC_PFPDR_B->bEGTSR_active;
  AC_PFPDR_B->BusConversion_InsertedFor_BusOu.bZYLOPT_OFF =
    (AC_PFPDR_B->bPFPDR_active || AC_PFPDR_B->bEGTSR_active);

  /* End of BusCreator: '<S2>/BusConversion_InsertedFor_Bus Output_at_inport_0' */

  /* S-Function (bur_bus_out): '<S2>/Bus Output' */
  inst->out = AC_PFPDR_B->BusConversion_InsertedFor_BusOu;

  /* MATLAB Function: '<S6>/Abort Condition 1' */
  /* MATLAB Function 'SimuBlock/PFPDR_Autocode/PFPDR/Abort Conditions/Abort Condition 1': '<S10>:1' */
  /* variable array size not suported by autocode: */
  /* abort1 = (sum((rCA_Knck_Red(1:iNum_Cyl)-min(rCA_Knck_Red(1:iNum_Cyl)))>0)/iNum_Cyl) >= 0.25; */
  /*  rCA_Knck_Red_min = rCA_Knck_Red(2); */
  /*  for iCyl=2:iNum_Cyl+1 */
  /*       if rCA_Knck_Red_min > rCA_Knck_Red(iCyl) */
  /*           rCA_Knck_Red_min = rCA_Knck_Red(iCyl); */
  /*       end */
  /*  end */
  /* '<S10>:1:10' */
  rCA_IP_Max = 0.0F;

  /* '<S10>:1:11' */
  i = (int32_T)((uint32_T)AC_PFPDR_B->u4Cylinder + 1U);
  if ((uint32_T)i > 255U) {
    i = 255;
  }

  /* '<S10>:1:11' */
  for (rtb_iNum_Cyl = 2U; rtb_iNum_Cyl <= (uint8_T)i; rtb_iNum_Cyl = (uint8_T)
       ((uint32_T)rtb_iNum_Cyl + 1U)) {
    /* '<S10>:1:11' */
    if (AC_PFPDR_B->BusInput1.rCA_Knck_Red[rtb_iNum_Cyl - 1] > 0.0F) {
      /* '<S10>:1:12' */
      /* '<S10>:1:13' */
      rCA_IP_Max++;
    }
  }

  if (rCA_IP_Max >= (real32_T)(uint8_T)(int32_T)rt_roundd(0.25 * (real_T)
       AC_PFPDR_B->u4Cylinder, inst)) {
    /* '<S10>:1:16' */
    /* '<S10>:1:17' */
    rtb_abort1 = TRUE;
  } else {
    /* '<S10>:1:19' */
    rtb_abort1 = FALSE;
  }

  /* End of MATLAB Function: '<S6>/Abort Condition 1' */

  /* Switch: '<S6>/Switch' incorporates:
   *  Constant: '<S6>/AlterMotor'
   *  Constant: '<S6>/NeuerMotor '
   */
  if (AC_PFPDR_B->BusInput1.bPFPDR_Profile) {
    rtb_Switch = 5;
  } else {
    rtb_Switch = 4;
  }

  /* End of Switch: '<S6>/Switch' */

  /* MATLAB Function: '<S6>/Abort Condition 2' */
  /* MATLAB Function 'SimuBlock/PFPDR_Autocode/PFPDR/Abort Conditions/Abort Condition 2': '<S11>:1' */
  /* variable array size not suported by autocode: */
  /* abort2 = sum((rCA_IgnP_Set - rCA_Ign_Act(1:iNum_Cyl)) >= rCA_Dev_Max)>0; */
  /* '<S11>:1:4' */
  rtb_abort2 = FALSE;

  /* '<S11>:1:5' */
  i = (int32_T)((uint32_T)AC_PFPDR_B->u4Cylinder + 1U);
  if ((uint32_T)i > 255U) {
    i = 255;
  }

  /* '<S11>:1:5' */
  for (rtb_iNum_Cyl = 2U; rtb_iNum_Cyl <= (uint8_T)i; rtb_iNum_Cyl = (uint8_T)
       ((uint32_T)rtb_iNum_Cyl + 1U)) {
    /* '<S11>:1:5' */
    if ((real_T)(AC_PFPDR_B->BusInput1.rCA_IP_Set - AC_PFPDR_B->
                 rCA_IP_Act[rtb_iNum_Cyl - 1]) >= (real_T)rtb_Switch) {
      /* '<S11>:1:6' */
      /* '<S11>:1:7' */
      rtb_abort2 = TRUE;
    }
  }

  /* End of MATLAB Function: '<S6>/Abort Condition 2' */

  /* MATLAB Function: '<S6>/Abort Condition 3' */
  /* MATLAB Function 'SimuBlock/PFPDR_Autocode/PFPDR/Abort Conditions/Abort Condition 3': '<S12>:1' */
  /* '<S12>:1:4' */
  rtb_abort3 = (AC_PFPDR_B->rLam_DR_Offs <= -AC_PFPDR_B->BusInput.rLam_DR_Lim);

  /* BusCreator: '<S2>/BusConversion_InsertedFor_Bus Output1_at_inport_0' incorporates:
   *  SignalConversion: '<S2>/BusConversion_InsertedFor_Bus Output1_at_inport_0'
   */
  AC_PFPDR_B->BusConversion_InsertedFor_Bus_c.rT_Sampling = 0.01F;
  for (i = 0; i < 25; i++) {
    AC_PFPDR_B->BusConversion_InsertedFor_Bus_c.rCA_IP_aDR[i] =
      AC_PFPDR_B->rCA_IP_aDR[i];
    AC_PFPDR_B->BusConversion_InsertedFor_Bus_c.rCA_IP_bDR[i] =
      AC_PFPDR_B->rCA_IP_bDR[i];
  }

  AC_PFPDR_B->BusConversion_InsertedFor_Bus_c.rCA_IP_aDR_Avg =
    AC_PFPDR_B->rCA_IP_aDR_Max;
  AC_PFPDR_B->BusConversion_InsertedFor_Bus_c.rCA_IP_bDR_Avg =
    AC_PFPDR_B->rCA_IP_bDR_Avg;
  AC_PFPDR_B->BusConversion_InsertedFor_Bus_c.bAbort_DR[0] = rtb_abort1;
  AC_PFPDR_B->BusConversion_InsertedFor_Bus_c.bAbort_DR[1] = rtb_abort2;
  AC_PFPDR_B->BusConversion_InsertedFor_Bus_c.bAbort_DR[2] = rtb_abort3;

  /* End of BusCreator: '<S2>/BusConversion_InsertedFor_Bus Output1_at_inport_0' */

  /* S-Function (bur_bus_out): '<S2>/Bus Output1' */
  inst->dbg = AC_PFPDR_B->BusConversion_InsertedFor_Bus_c;

  /* Logic: '<S6>/Abort' */
  rtb_Abort = (rtb_abort1 || rtb_abort2 || rtb_abort3);

  /* Switch: '<S8>/Switch3' incorporates:
   *  Abs: '<S5>/Abs'
   *  Constant: '<S5>/TRUE'
   *  Logic: '<S5>/Logical Operator'
   *  RelationalOperator: '<S8>/groesser '
   *  RelationalOperator: '<S8>/kleiner'
   *  Sum: '<S5>/plus '
   *  Switch: '<S8>/Switch1'
   *  Switch: '<S8>/Switch2'
   *  UnitDelay: '<S8>/Unit Delay2'
   */
  if (!AC_PFPDR_B->bPFPDR_active) {
    rtb_abort1 = TRUE;
  } else if (AC_PFPDR_B->BusInput1.rPos_CBV < AC_PFPDR_B->BusInput.rPos_CBV_Opt)
  {
    /* Switch: '<S8>/Switch1' incorporates:
     *  Constant: '<S8>/FALSE'
     */
    rtb_abort1 = FALSE;
  } else if (AC_PFPDR_B->BusInput1.rPos_CBV > AC_PFPDR_B->BusInput.rPos_CBV_Opt
             + (real32_T)fabs(AC_PFPDR_B->BusInput.rPos_CBV_Hys)) {
    /* Switch: '<S8>/Switch2' incorporates:
     *  Constant: '<S8>/TRUE'
     *  Switch: '<S8>/Switch1'
     */
    rtb_abort1 = TRUE;
  } else {
    rtb_abort1 = AC_PFPDR_DWork->UnitDelay2_DSTATE_l;
  }

  /* End of Switch: '<S8>/Switch3' */

  /* Sum: '<S9>/Subtract' */
  rtb_Subtract = rtb_rT_Abort_Delay - AC_PFPDR_B->BusInput.rT_Abort_Filter;

  /* Outputs for Atomic SubSystem: '<S9>/TON' */
  AC_PFPDR_TON(rtb_Abort, rtb_rT_Abort_Delay, &AC_PFPDR_B->TON,
               &AC_PFPDR_DWork->TON, inst);

  /* End of Outputs for SubSystem: '<S9>/TON' */

  /* Outputs for Atomic SubSystem: '<S9>/TON1' */
  AC_PFPDR_TON(rtb_Abort, rtb_Subtract, &AC_PFPDR_B->TON1, &AC_PFPDR_DWork->TON1, inst);

  /* End of Outputs for SubSystem: '<S9>/TON1' */

  /* Update for UnitDelay: '<S5>/Unit Delay' */
  AC_PFPDR_DWork->UnitDelay_DSTATE = AC_PFPDR_B->TON.LogicalOperator3;

  /* Update for UnitDelay: '<S5>/Unit Delay1' */
  AC_PFPDR_DWork->UnitDelay1_DSTATE = AC_PFPDR_B->TON1.LogicalOperator3;

  /* Update for UnitDelay: '<S5>/Unit Delay2' */
  AC_PFPDR_DWork->UnitDelay2_DSTATE = rtb_abort1;

  /* Update for UnitDelay: '<S8>/Unit Delay2' */
  AC_PFPDR_DWork->UnitDelay2_DSTATE_l = rtb_abort1;
}

/* Model initialize function */
void AC_PFPDR_initialize(struct PFPDR* inst)
{
  /* (no initialization code required) */
}

/* Model terminate function */
void AC_PFPDR_terminate(struct PFPDR* inst)
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
