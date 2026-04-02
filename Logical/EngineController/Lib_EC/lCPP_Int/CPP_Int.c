/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: CPP_Int
 * File: CPP_Int.c
 * Author: Messner
 * Created: Fri Nov 24 07:48:45 2017
 ********************************************************************
 * Implementation of program CPP_Int
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "CPP_Int.h"
#include "CPP_Int_private.h"

/*  Defines */
#define CPP_Int_POS_ZCSIG              ((uint8_T)1U)
#define CPP_Int_UNINITIALIZED_ZCSIG    ((uint8_T)3U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/
real32_T rt_roundf(real32_T u, struct fCPP_Int* inst)
{
  real32_T y;
  if ((real32_T)fabs(u) < 8.388608E+6F) {
    if (u >= 0.5F) {
      y = (real32_T)floor(u + 0.5F);
    } else if (u > -0.5F) {
      y = 0.0F;
    } else {
      y = (real32_T)ceil(u - 0.5F);
    }
  } else {
    y = u;
  }

  return y;
}

/* Model step function */
void CPP_Int_step(struct BlockIO_CPP_Int *CPP_Int_B, struct D_Work_CPP_Int *CPP_Int_DWork,
                  struct PrevZCSigStates_CPP_Int *CPP_Int_PrevZCSigState,
                  ExternalOutputs_CPP_Int *CPP_Int_Y, struct fCPP_Int* inst)
{
  /* local block i/o variables */
  boolean_T rtb_Reset;
  real32_T rtb_Switch_j;
  uint16_T rtb_OneSamplebeforenextCycle;
  uint16_T rtb_Subtract3_h;
  boolean_T rtb_LogicalOperator3;
  boolean_T rtb_FixPtRelationalOperator_h;
  uint16_T rtb_Subtract1;
  boolean_T rtb_RelationalOperator1;
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_LogicalOperator1_j;
  real32_T rtb_rPr_AbsLimHi_k;
  real32_T rtb_Switch_g;
  boolean_T rtb_LimitReached;
  real32_T rtb_rPr_AbsLim_h;
  uint16_T u;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  CPP_Int_B->BusInput = inst->In;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  CPP_Int_B->BusInput1 = inst->Para;

  /* Delay: '<S1>/Engine Cycle Counter' incorporates:
   *  UnitDelay: '<S1>/Unit Delay1'
   */
  if (CPP_Int_DWork->UnitDelay1_DSTATE) {
    CPP_Int_DWork->EngineCycleCounter_DSTATE = 0U;
  }

  /* Sum: '<S1>/Subtract3' incorporates:
   *  Delay: '<S1>/Engine Cycle Counter'
   */
  rtb_Subtract3_h = (uint16_T)((uint32_T)
    CPP_Int_DWork->EngineCycleCounter_DSTATE + 1U);

  /* Switch: '<S12>/Switch' incorporates:
   *  Abs: '<S12>/Abs'
   *  BusSelector: '<Root>/Bus Selector7'
   *  RelationalOperator: '<S12>/Relational Operator'
   */
  if (2.22044605E-16F >= (real32_T)fabs(CPP_Int_B->BusInput.tiSample)) {
    rtb_Switch_j = 2.22044605E-16F;
  } else {
    rtb_Switch_j = CPP_Int_B->BusInput.tiSample;
  }

  /* End of Switch: '<S12>/Switch' */

  /* MinMax: '<S14>/MinMax' incorporates:
   *  BusSelector: '<Root>/Bus Selector7'
   */
  if (CPP_Int_B->BusInput.rN_Eng >= 100.0F) {
    rtb_rPr_AbsLimHi_k = CPP_Int_B->BusInput.rN_Eng;
  } else {
    rtb_rPr_AbsLimHi_k = 100.0F;
  }

  /* Product: '<S1>/Samples  Per Cycle' incorporates:
   *  Constant: '<S14>/Constant2'
   *  MinMax: '<S14>/MinMax'
   *  Product: '<S14>/Divide'
   */
  rtb_rPr_AbsLimHi_k = (real32_T)fmod(rt_roundf(1.0F / rtb_rPr_AbsLimHi_k *
    120.0F / rtb_Switch_j, inst), 65536.0F);
  rtb_OneSamplebeforenextCycle = (uint16_T)(rtb_rPr_AbsLimHi_k < 0.0F ?
    (uint16_T)(int32_T)(int16_T)-(int16_T)(uint16_T)-rtb_rPr_AbsLimHi_k :
    (uint16_T)rtb_rPr_AbsLimHi_k);

  /* Logic: '<S1>/Logical Operator3' incorporates:
   *  RelationalOperator: '<S13>/FixPt Relational Operator'
   *  RelationalOperator: '<S1>/Relational Operator'
   *  UnitDelay: '<S13>/Delay Input1'
   */
  rtb_LogicalOperator3 = ((rtb_Subtract3_h >= rtb_OneSamplebeforenextCycle) ||
    (CPP_Int_B->BusInput.rPr_CPP != CPP_Int_DWork->DelayInput1_DSTATE));

  /* RelationalOperator: '<S11>/FixPt Relational Operator' incorporates:
   *  UnitDelay: '<S11>/Delay Input1'
   */
  rtb_FixPtRelationalOperator_h = ((int32_T)rtb_LogicalOperator3 > (int32_T)
    CPP_Int_DWork->DelayInput1_DSTATE_c);

  /* Delay: '<S1>/Filter Cycle Counter' incorporates:
   *  Logic: '<S1>/Logical Operator4'
   *  UnitDelay: '<S1>/Unit Delay2'
   */
  if (CPP_Int_DWork->UnitDelay2_DSTATE || rtb_FixPtRelationalOperator_h) {
    CPP_Int_DWork->FilterCycleCounter_DSTATE = 0U;
  }

  /* Sum: '<S1>/Subtract1' incorporates:
   *  Delay: '<S1>/Filter Cycle Counter'
   *  Logic: '<S1>/One Cycle Self-locking'
   */
  rtb_Subtract1 = (uint16_T)((uint32_T)
    ((CPP_Int_DWork->FilterCycleCounter_DSTATE != 0) ||
     rtb_FixPtRelationalOperator_h) + (uint32_T)
    CPP_Int_DWork->FilterCycleCounter_DSTATE);

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  CPP_Int_B->BusInput2 = inst->Perm;

  /* Sum: '<S1>/One Sample before next Cycle' incorporates:
   *  Constant: '<S1>/act2'
   */
  rtb_OneSamplebeforenextCycle--;

  /* Product: '<S1>/Samples Per Cycle' incorporates:
   *  BusSelector: '<Root>/Bus Selector6'
   */
  rtb_rPr_AbsLimHi_k = (real32_T)fmod(rt_roundf
    (CPP_Int_B->BusInput2.tiSensorFilter / rtb_Switch_j, inst), 65536.0F);

  /* MinMax: '<S1>/MinMax1' incorporates:
   *  Product: '<S1>/Samples Per Cycle'
   */
  u = (uint16_T)(rtb_rPr_AbsLimHi_k < 0.0F ? (uint16_T)(int32_T)(int16_T)
                 -(int16_T)(uint16_T)-rtb_rPr_AbsLimHi_k : (uint16_T)
                 rtb_rPr_AbsLimHi_k);
  if (u <= rtb_OneSamplebeforenextCycle) {
    rtb_OneSamplebeforenextCycle = u;
  }

  /* End of MinMax: '<S1>/MinMax1' */

  /* Saturate: '<S1>/Limit Cycle Count' */
  if (!(rtb_OneSamplebeforenextCycle <= 1000)) {
    rtb_OneSamplebeforenextCycle = 1000U;
  }

  /* RelationalOperator: '<S1>/Relational Operator1' incorporates:
   *  Saturate: '<S1>/Limit Cycle Count'
   */
  rtb_RelationalOperator1 = (rtb_Subtract1 > rtb_OneSamplebeforenextCycle);

  /* Logic: '<Root>/Logical Operator2' incorporates:
   *  RelationalOperator: '<S4>/FixPt Relational Operator'
   *  UnitDelay: '<S4>/Delay Input1'
   */
  rtb_LogicalOperator2 = (rtb_RelationalOperator1 || ((int32_T)
    CPP_Int_B->BusInput.bReset > (int32_T)CPP_Int_DWork->DelayInput1_DSTATE_f));

  /* Outputs for Triggered SubSystem: '<Root>/Cylinder Peak Pressure Error Calculator' incorporates:
   *  TriggerPort: '<S2>/Trigger'
   */
  if (rtb_LogicalOperator2 &&
      (CPP_Int_PrevZCSigState->CylinderPeakPressureErrorCalcul != POS_ZCSIG)) {
    /* Switch: '<S2>/Switch2' */
    if (CPP_Int_B->BusInput.bLimpHomeExt) {
      rtb_rPr_AbsLimHi_k = CPP_Int_B->BusInput1.rPr_AbsLimHi_LHE;
    } else {
      rtb_rPr_AbsLimHi_k = CPP_Int_B->BusInput1.rPr_AbsLimHi;
    }

    /* End of Switch: '<S2>/Switch2' */

    /* Switch: '<S2>/Switch1' */
    if (CPP_Int_B->BusInput.bLimpHomeExt) {
      rtb_rPr_AbsLim_h = CPP_Int_B->BusInput1.rPr_AbsLim_LHE;
    } else {
      rtb_rPr_AbsLim_h = CPP_Int_B->BusInput1.rPr_AbsLim;
    }

    /* End of Switch: '<S2>/Switch1' */

    /* Switch: '<S18>/Switch' incorporates:
     *  Constant: '<S2>/act2'
     *  RelationalOperator: '<S18>/LowerRelop1'
     *  RelationalOperator: '<S18>/UpperRelop'
     *  Sum: '<S2>/Subtract2'
     *  Switch: '<S18>/Switch2'
     */
    if ((!(rtb_rPr_AbsLimHi_k > rtb_rPr_AbsLimHi_k)) && (rtb_rPr_AbsLimHi_k <
         1.0F + rtb_rPr_AbsLim_h)) {
      rtb_rPr_AbsLimHi_k = 1.0F + rtb_rPr_AbsLim_h;
    }

    /* End of Switch: '<S18>/Switch' */

    /* Sum: '<S2>/Pressure Limit Deviation [bar]' */
    rtb_rPr_AbsLimHi_k -= rtb_rPr_AbsLim_h;

    /* Switch: '<S16>/Switch' incorporates:
     *  Abs: '<S16>/Abs'
     *  RelationalOperator: '<S16>/Relational Operator'
     */
    if (2.22044605E-16F >= (real32_T)fabs(rtb_rPr_AbsLimHi_k)) {
      rtb_Switch_g = 2.22044605E-16F;
    } else {
      rtb_Switch_g = rtb_rPr_AbsLimHi_k;
    }

    /* End of Switch: '<S16>/Switch' */

    /* Switch: '<S2>/Sensor Error Filter' incorporates:
     *  Gain: '<S2>/Gain'
     */
    if (CPP_Int_B->BusInput.bSensorErr) {
      CPP_Int_B->SensorErrorFilter = 0.75F * rtb_rPr_AbsLim_h;
    } else {
      CPP_Int_B->SensorErrorFilter = CPP_Int_B->BusInput.rPr_CPP;
    }

    /* End of Switch: '<S2>/Sensor Error Filter' */

    /* Sum: '<S2>/Pressure Error [bar]' */
    rtb_Switch_j = CPP_Int_B->SensorErrorFilter - rtb_rPr_AbsLim_h;

    /* Switch: '<S17>/Switch2' incorporates:
     *  RelationalOperator: '<S17>/LowerRelop1'
     */
    if (!(rtb_Switch_j > rtb_rPr_AbsLimHi_k)) {
      /* Switch: '<S17>/Switch' incorporates:
       *  Constant: '<S2>/act1'
       *  RelationalOperator: '<S17>/UpperRelop'
       */
      if (rtb_Switch_j < 0.0F) {
        rtb_rPr_AbsLimHi_k = 0.0F;
      } else {
        rtb_rPr_AbsLimHi_k = rtb_Switch_j;
      }

      /* End of Switch: '<S17>/Switch' */
    }

    /* End of Switch: '<S17>/Switch2' */

    /* Product: '<S2>/Divide3' incorporates:
     *  DataTypeConversion: '<S2>/Data Type Conversion'
     *  Logic: '<S2>/Logical Operator2'
     */
    CPP_Int_B->Divide3 = (real32_T)!CPP_Int_B->BusInput.bReset / rtb_Switch_g *
      rtb_rPr_AbsLimHi_k;
  }

  CPP_Int_PrevZCSigState->CylinderPeakPressureErrorCalcul = (uint8_T)
    (rtb_LogicalOperator2 ? (int32_T)POS_ZCSIG : (int32_T)ZERO_ZCSIG);

  /* End of Outputs for SubSystem: '<Root>/Cylinder Peak Pressure Error Calculator' */

  /* Outputs for Triggered SubSystem: '<Root>/Cylinder Peak Pressure Integrator' incorporates:
   *  TriggerPort: '<S3>/Trigger'
   */
  if (rtb_LogicalOperator2 &&
      (CPP_Int_PrevZCSigState->CylinderPeakPressureIntegrator_ != POS_ZCSIG)) {
    /* Delay: '<S21>/Resettable Delay' */
    rtb_LimitReached = (((CPP_Int_PrevZCSigState->ResettableDelay_Reset_ZCE ==
                          CPP_Int_POS_ZCSIG) != CPP_Int_B->BusInput.bReset) &&
                        (CPP_Int_PrevZCSigState->ResettableDelay_Reset_ZCE !=
                         CPP_Int_UNINITIALIZED_ZCSIG));
    CPP_Int_PrevZCSigState->ResettableDelay_Reset_ZCE = (uint8_T)
      CPP_Int_B->BusInput.bReset;
    if (CPP_Int_B->BusInput.bReset || rtb_LimitReached) {
      CPP_Int_DWork->ResettableDelay_DSTATE = 0.0F;
    }

    /* Switch: '<S3>/Switch4' incorporates:
     *  Constant: '<S20>/Constant'
     *  Gain: '<S3>/Decent'
     *  Math: '<S3>/Power Weighting Function'
     *  RelationalOperator: '<S20>/Compare'
     */
    if (CPP_Int_B->Divide3 <= 0.0F) {
      rtb_Switch_j = -CPP_Int_B->BusInput2.rInt_Dec;
    } else if ((CPP_Int_B->Divide3 < 0.0F) && (CPP_Int_B->BusInput2.rInt_Power >
                (real32_T)floor(CPP_Int_B->BusInput2.rInt_Power))) {
      /* Math: '<S3>/Power Weighting Function' */
      rtb_Switch_j = -(real32_T)pow(-CPP_Int_B->Divide3,
        CPP_Int_B->BusInput2.rInt_Power);
    } else {
      /* Math: '<S3>/Power Weighting Function' */
      rtb_Switch_j = (real32_T)pow(CPP_Int_B->Divide3,
        CPP_Int_B->BusInput2.rInt_Power);
    }

    /* End of Switch: '<S3>/Switch4' */

    /* Sum: '<S21>/Subtract3' incorporates:
     *  Delay: '<S21>/Resettable Delay'
     */
    rtb_rPr_AbsLimHi_k = CPP_Int_DWork->ResettableDelay_DSTATE + rtb_Switch_j;

    /* Saturate: '<S21>/Saturadition' */
    if (rtb_rPr_AbsLimHi_k >= 1.0F) {
      CPP_Int_B->Saturadition = 1.0F;
    } else if (rtb_rPr_AbsLimHi_k <= 0.0F) {
      CPP_Int_B->Saturadition = 0.0F;
    } else {
      CPP_Int_B->Saturadition = rtb_rPr_AbsLimHi_k;
    }

    /* End of Saturate: '<S21>/Saturadition' */

    /* Update for Delay: '<S21>/Resettable Delay' */
    CPP_Int_DWork->ResettableDelay_DSTATE = CPP_Int_B->Saturadition;
  }

  CPP_Int_PrevZCSigState->CylinderPeakPressureIntegrator_ = (uint8_T)
    (rtb_LogicalOperator2 ? (int32_T)POS_ZCSIG : (int32_T)ZERO_ZCSIG);

  /* End of Outputs for SubSystem: '<Root>/Cylinder Peak Pressure Integrator' */

  /* Outputs for Triggered SubSystem: '<Root>/Ignition Point and PI Duration Offset Calculator' incorporates:
   *  TriggerPort: '<S8>/Trigger'
   */
  if (rtb_LogicalOperator2 &&
      (CPP_Int_PrevZCSigState->IgnitionPointandPIDurationOffse != POS_ZCSIG)) {
    /* Switch: '<S24>/Switch2' incorporates:
     *  Constant: '<S22>/act2'
     *  RelationalOperator: '<S24>/LowerRelop1'
     *  RelationalOperator: '<S24>/UpperRelop'
     *  Switch: '<S24>/Switch'
     */
    if (CPP_Int_B->BusInput2.rIgn_IntLimLo > CPP_Int_B->BusInput2.rIgn_IntLimHi)
    {
      rtb_Switch_j = CPP_Int_B->BusInput2.rIgn_IntLimHi;
    } else if (CPP_Int_B->BusInput2.rIgn_IntLimLo < 0.0F) {
      /* Switch: '<S24>/Switch' incorporates:
       *  Constant: '<S22>/act2'
       */
      rtb_Switch_j = 0.0F;
    } else {
      rtb_Switch_j = CPP_Int_B->BusInput2.rIgn_IntLimLo;
    }

    /* End of Switch: '<S24>/Switch2' */

    /* RelationalOperator: '<S27>/Limit Reached' */
    rtb_LimitReached = (CPP_Int_B->Saturadition >= rtb_Switch_j);

    /* Switch: '<S28>/Switch2' incorporates:
     *  Constant: '<S22>/act3'
     *  RelationalOperator: '<S28>/LowerRelop1'
     *  RelationalOperator: '<S28>/UpperRelop'
     *  Switch: '<S28>/Switch'
     */
    if (CPP_Int_B->BusInput2.rIgn_IntLimHi > 1.0F) {
      rtb_rPr_AbsLimHi_k = 1.0F;
    } else if (CPP_Int_B->BusInput2.rIgn_IntLimHi <
               CPP_Int_B->BusInput2.rIgn_IntLimLo) {
      /* Switch: '<S28>/Switch' */
      rtb_rPr_AbsLimHi_k = CPP_Int_B->BusInput2.rIgn_IntLimLo;
    } else {
      rtb_rPr_AbsLimHi_k = CPP_Int_B->BusInput2.rIgn_IntLimHi;
    }

    /* End of Switch: '<S28>/Switch2' */

    /* Sum: '<S22>/Delta X' */
    rtb_rPr_AbsLim_h = rtb_rPr_AbsLimHi_k - rtb_Switch_j;

    /* Switch: '<S29>/Switch' incorporates:
     *  Abs: '<S29>/Abs'
     *  RelationalOperator: '<S29>/Relational Operator'
     */
    if (2.22044605E-16F >= (real32_T)fabs(rtb_rPr_AbsLim_h)) {
      rtb_rPr_AbsLim_h = 2.22044605E-16F;
    }

    /* End of Switch: '<S29>/Switch' */

    /* Product: '<S22>/y = k * (x - d)' incorporates:
     *  DataTypeConversion: '<S27>/Data Type Conversion'
     *  Gain: '<S8>/Ignition Point reduction'
     *  Product: '<S25>/[k] - factor'
     *  Product: '<S27>/Enable Signal'
     *  Sum: '<S22>/Level Offset [x - d]'
     */
    rtb_Switch_j = ((real32_T)rtb_LimitReached * CPP_Int_B->Saturadition -
                    rtb_Switch_j) * (1.0F / rtb_rPr_AbsLim_h *
      -CPP_Int_B->BusInput1.rCA_Ign_Offset_Max);

    /* Switch: '<S26>/Switch2' incorporates:
     *  Constant: '<S22>/act1'
     *  Gain: '<S8>/Ignition Point reduction'
     *  RelationalOperator: '<S26>/LowerRelop1'
     *  RelationalOperator: '<S26>/UpperRelop'
     *  Switch: '<S26>/Switch'
     */
    if (rtb_Switch_j > 0.0F) {
      rtb_Switch_j = 0.0F;
    } else {
      if (rtb_Switch_j < -CPP_Int_B->BusInput1.rCA_Ign_Offset_Max) {
        /* Switch: '<S26>/Switch' incorporates:
         *  Gain: '<S8>/Ignition Point reduction'
         */
        rtb_Switch_j = -CPP_Int_B->BusInput1.rCA_Ign_Offset_Max;
      }
    }

    /* End of Switch: '<S26>/Switch2' */

    /* Product: '<S22>/Enable Output' incorporates:
     *  DataTypeConversion: '<S22>/Data Type Conversion'
     */
    CPP_Int_B->EnableOutput = (real32_T)rtb_LimitReached * rtb_Switch_j;

    /* Switch: '<S31>/Switch2' incorporates:
     *  Constant: '<S23>/act2'
     *  RelationalOperator: '<S31>/LowerRelop1'
     *  RelationalOperator: '<S31>/UpperRelop'
     *  Switch: '<S31>/Switch'
     */
    if (CPP_Int_B->BusInput2.rPI_Dur_IntLimLo >
        CPP_Int_B->BusInput2.rPI_Dur_IntLimHi) {
      rtb_Switch_j = CPP_Int_B->BusInput2.rPI_Dur_IntLimHi;
    } else if (CPP_Int_B->BusInput2.rPI_Dur_IntLimLo < 0.0F) {
      /* Switch: '<S31>/Switch' incorporates:
       *  Constant: '<S23>/act2'
       */
      rtb_Switch_j = 0.0F;
    } else {
      rtb_Switch_j = CPP_Int_B->BusInput2.rPI_Dur_IntLimLo;
    }

    /* End of Switch: '<S31>/Switch2' */

    /* RelationalOperator: '<S34>/Limit Reached' */
    rtb_LimitReached = (CPP_Int_B->Saturadition >= rtb_Switch_j);

    /* Switch: '<S35>/Switch2' incorporates:
     *  Constant: '<S23>/act3'
     *  RelationalOperator: '<S35>/LowerRelop1'
     *  RelationalOperator: '<S35>/UpperRelop'
     *  Switch: '<S35>/Switch'
     */
    if (CPP_Int_B->BusInput2.rPI_Dur_IntLimHi > 1.0F) {
      rtb_rPr_AbsLimHi_k = 1.0F;
    } else if (CPP_Int_B->BusInput2.rPI_Dur_IntLimHi <
               CPP_Int_B->BusInput2.rPI_Dur_IntLimLo) {
      /* Switch: '<S35>/Switch' */
      rtb_rPr_AbsLimHi_k = CPP_Int_B->BusInput2.rPI_Dur_IntLimLo;
    } else {
      rtb_rPr_AbsLimHi_k = CPP_Int_B->BusInput2.rPI_Dur_IntLimHi;
    }

    /* End of Switch: '<S35>/Switch2' */

    /* Sum: '<S23>/Delta X' */
    rtb_rPr_AbsLim_h = rtb_rPr_AbsLimHi_k - rtb_Switch_j;

    /* Switch: '<S36>/Switch' incorporates:
     *  Abs: '<S36>/Abs'
     *  RelationalOperator: '<S36>/Relational Operator'
     */
    if (2.22044605E-16F >= (real32_T)fabs(rtb_rPr_AbsLim_h)) {
      rtb_rPr_AbsLim_h = 2.22044605E-16F;
    }

    /* End of Switch: '<S36>/Switch' */

    /* Product: '<S23>/y = k * (x - d)' incorporates:
     *  DataTypeConversion: '<S34>/Data Type Conversion'
     *  Gain: '<S8>/PI Duration reduction'
     *  Product: '<S32>/[k] - factor'
     *  Product: '<S34>/Enable Signal'
     *  Sum: '<S23>/Level Offset [x - d]'
     */
    rtb_Switch_j = ((real32_T)rtb_LimitReached * CPP_Int_B->Saturadition -
                    rtb_Switch_j) * (1.0F / rtb_rPr_AbsLim_h *
      -CPP_Int_B->BusInput1.rPI_Dur_Offset_Max);

    /* Switch: '<S33>/Switch2' incorporates:
     *  Constant: '<S23>/act1'
     *  Gain: '<S8>/PI Duration reduction'
     *  RelationalOperator: '<S33>/LowerRelop1'
     *  RelationalOperator: '<S33>/UpperRelop'
     *  Switch: '<S33>/Switch'
     */
    if (rtb_Switch_j > 0.0F) {
      rtb_Switch_j = 0.0F;
    } else {
      if (rtb_Switch_j < -CPP_Int_B->BusInput1.rPI_Dur_Offset_Max) {
        /* Switch: '<S33>/Switch' incorporates:
         *  Gain: '<S8>/PI Duration reduction'
         */
        rtb_Switch_j = -CPP_Int_B->BusInput1.rPI_Dur_Offset_Max;
      }
    }

    /* End of Switch: '<S33>/Switch2' */

    /* Product: '<S23>/Enable Output' incorporates:
     *  DataTypeConversion: '<S23>/Data Type Conversion'
     */
    CPP_Int_B->EnableOutput_m = (real32_T)rtb_LimitReached * rtb_Switch_j;
  }

  CPP_Int_PrevZCSigState->IgnitionPointandPIDurationOffse = (uint8_T)
    (rtb_LogicalOperator2 ? (int32_T)POS_ZCSIG : (int32_T)ZERO_ZCSIG);

  /* End of Outputs for SubSystem: '<Root>/Ignition Point and PI Duration Offset Calculator' */

  /* RelationalOperator: '<S39>/Compare' incorporates:
   *  Constant: '<S39>/Constant'
   */
  rtb_LogicalOperator2 = (CPP_Int_B->Saturadition >= 0.99F);

  /* RelationalOperator: '<S38>/Compare' incorporates:
   *  Constant: '<S38>/Constant'
   */
  rtb_LogicalOperator1_j = (CPP_Int_B->Saturadition > 0.0F);

  /* Logic: '<S10>/Sensor Error during Integrator Nonempty' */
  rtb_LimitReached = (CPP_Int_B->BusInput.bSensorErr && rtb_LogicalOperator1_j);

  /* Logic: '<S40>/Logical Operator2' */
  rtb_Reset = !rtb_LogicalOperator1_j;

  /* DiscreteIntegrator: '<S40>/Discrete-Time Accumulator' */
  if (rtb_Reset || (CPP_Int_DWork->DiscreteTimeAccumulator_PrevRes != 0)) {
    CPP_Int_DWork->DiscreteTimeAccumulator_DSTATE = 0.0F;
  }

  /* Logic: '<S40>/Logical Operator3' incorporates:
   *  DiscreteIntegrator: '<S40>/Discrete-Time Accumulator'
   *  RelationalOperator: '<S40>/Relational Operator'
   */
  rtb_LogicalOperator1_j = (rtb_LogicalOperator1_j &&
    (CPP_Int_DWork->DiscreteTimeAccumulator_DSTATE >=
     CPP_Int_B->BusInput2.tiInt_NonEmpty));

  /* Logic: '<S10>/Logical Operator3' */
  rtb_LimitReached = (rtb_LogicalOperator2 || rtb_LimitReached ||
                      rtb_LogicalOperator1_j);

  /* BusCreator: '<Root>/Bus Creator' incorporates:
   *  Logic: '<S10>/Logical Operator1'
   *  Logic: '<S10>/Logical Operator2'
   *  Logic: '<S10>/Logical Operator4'
   */
  CPP_Int_Y->tCPPI_OUT_c.rPr_CPP_Filt = CPP_Int_B->SensorErrorFilter;
  CPP_Int_Y->tCPPI_OUT_c.rPI_Dur_Offset = CPP_Int_B->EnableOutput_m;
  CPP_Int_Y->tCPPI_OUT_c.rCA_Ign_Offset = CPP_Int_B->EnableOutput;
  CPP_Int_Y->tCPPI_OUT_c.rNum_CPP_Int = CPP_Int_B->Saturadition;
  CPP_Int_Y->tCPPI_OUT_c.bCPP_AbsLim = ((!CPP_Int_B->BusInput.bLimpHomeExt) &&
    rtb_LimitReached);
  CPP_Int_Y->tCPPI_OUT_c.bCPP_AbsLim_LHE = (rtb_LimitReached &&
    CPP_Int_B->BusInput.bLimpHomeExt);
  CPP_Int_Y->tCPPI_OUT_c.bSkipCyl = rtb_LogicalOperator2;

  /* BusCreator: '<Root>/Bus Creator1' incorporates:
   *  DiscreteIntegrator: '<S40>/Discrete-Time Accumulator'
   */
  CPP_Int_Y->tCPPI_DBUG_o.tiInt_NonEmpty =
    CPP_Int_DWork->DiscreteTimeAccumulator_DSTATE;
  CPP_Int_Y->tCPPI_DBUG_o.rCPP_Err = CPP_Int_B->Divide3;
  CPP_Int_Y->tCPPI_DBUG_o.bECPG = rtb_FixPtRelationalOperator_h;
  CPP_Int_Y->tCPPI_DBUG_o.bFCPG = rtb_RelationalOperator1;

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Out = CPP_Int_Y->tCPPI_OUT_c;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Dbg = CPP_Int_Y->tCPPI_DBUG_o;

  /* Logic: '<S40>/Logical Operator1' */
  rtb_LogicalOperator1_j = !rtb_LogicalOperator1_j;

  /* Product: '<S40>/Block Windup' incorporates:
   *  DataTypeConversion: '<S40>/Data Type Conversion'
   */
  rtb_Switch_j = CPP_Int_B->BusInput.tiSample * (real32_T)rtb_LogicalOperator1_j;

  /* UnitDelay: '<S9>/Unit Delay' */
  CPP_Int_B->UnitDelay = CPP_Int_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->Version = CPP_Int_B->UnitDelay;

  /* Update for UnitDelay: '<S1>/Unit Delay2' */
  CPP_Int_DWork->UnitDelay2_DSTATE = rtb_RelationalOperator1;

  /* Update for UnitDelay: '<S1>/Unit Delay1' */
  CPP_Int_DWork->UnitDelay1_DSTATE = rtb_FixPtRelationalOperator_h;

  /* Update for Delay: '<S1>/Engine Cycle Counter' */
  CPP_Int_DWork->EngineCycleCounter_DSTATE = rtb_Subtract3_h;

  /* Update for UnitDelay: '<S13>/Delay Input1' */
  CPP_Int_DWork->DelayInput1_DSTATE = CPP_Int_B->BusInput.rPr_CPP;

  /* Update for UnitDelay: '<S11>/Delay Input1' */
  CPP_Int_DWork->DelayInput1_DSTATE_c = rtb_LogicalOperator3;

  /* Update for Delay: '<S1>/Filter Cycle Counter' */
  CPP_Int_DWork->FilterCycleCounter_DSTATE = rtb_Subtract1;

  /* Update for UnitDelay: '<S4>/Delay Input1' */
  CPP_Int_DWork->DelayInput1_DSTATE_f = CPP_Int_B->BusInput.bReset;

  /* Update for DiscreteIntegrator: '<S40>/Discrete-Time Accumulator' */
  CPP_Int_DWork->DiscreteTimeAccumulator_DSTATE += rtb_Switch_j;
  if (rtb_Reset) {
    CPP_Int_DWork->DiscreteTimeAccumulator_PrevRes = 1;
  } else {
    CPP_Int_DWork->DiscreteTimeAccumulator_PrevRes = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S40>/Discrete-Time Accumulator' */

  /* Update for UnitDelay: '<S9>/Unit Delay' */
  CPP_Int_DWork->UnitDelay_DSTATE = 10U;
}

/* Model initialize function */
void CPP_Int_initialize(struct PrevZCSigStates_CPP_Int *CPP_Int_PrevZCSigState, struct fCPP_Int* inst)
{
  CPP_Int_PrevZCSigState->IgnitionPointandPIDurationOffse = POS_ZCSIG;
  CPP_Int_PrevZCSigState->CylinderPeakPressureIntegrator_ = POS_ZCSIG;
  CPP_Int_PrevZCSigState->ResettableDelay_Reset_ZCE = UNINITIALIZED_ZCSIG;
  CPP_Int_PrevZCSigState->CylinderPeakPressureErrorCalcul = POS_ZCSIG;
}

/* Model terminate function */
void CPP_Int_terminate(struct fCPP_Int* inst)
{
  /* (no terminate code required) */
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 8.0 (R2012b)20-Jul-2012                                             *
 * Simulink 8.0 (R2012b)20-Jul-2012                                           *
 * Simulink Coder 8.3 (R2012b)20-Jul-2012                                     *
 * Embedded Coder 6.3 (R2012b)20-Jul-2012                                     *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
