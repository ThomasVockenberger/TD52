/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: UDC
 * File: UDC.h
 * Author: 105055527
 * Created: Thu Mar 02 16:51:06 2017
 ********************************************************************
 * Header for program UDC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_UDC_h_
#define RTW_HEADER_UDC_h_
#ifndef UDC_COMMON_INCLUDES_
# define UDC_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#include "rtGetInf.h"
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#endif                                 /* UDC_COMMON_INCLUDES_ */

#include "UDC_types.h"
#include "lUDC.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((void*) 0)
#endif

#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

/* Block signals for system '<S30>/Cell1' */

/* Block states (auto storage) for system '<S30>/Cell1' */

/* Block signals for system '<S15>/Filter' */

/* Block states (auto storage) for system '<S15>/Filter' */

/* Block signals for system '<S65>/TON' */

/* Block states (auto storage) for system '<S65>/TON' */

/* Block signals for system '<S65>/TP' */

/* Block states (auto storage) for system '<S65>/TP' */

/* Block signals for system '<S119>/TOF' */

/* Block states (auto storage) for system '<S119>/TOF' */

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* Zero-crossing (trigger) state */

/* Invariant block signals for system '<S15>/Filter' */

/* Invariant block signals (auto storage) */

/* Constant parameters (auto storage) */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Real-time Model Data Structure */

/* Block signals (auto storage) */
extern BlockIO_UDC UDC_B;

/* Block states (auto storage) */
extern D_Work_UDC UDC_DWork;

/* External inputs (root inport signals with auto storage) */
extern ExternalInputs_UDC UDC_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExternalOutputs_UDC UDC_Y;
extern const ConstBlockIO_UDC UDC_ConstB;/* constant block i/o */

/* Constant parameters (auto storage) */
extern const ConstParam_UDC UDC_ConstP;

/* Model entry point functions */
extern void UDC_initialize(struct fUDC* inst);
extern void UDC_step(struct fUDC* inst);
extern void UDC_terminate(struct fUDC* inst);

/* Real-time Model object */
extern RT_MODEL_UDC *const UDC_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'UDC'
 * '<S1>'   : 'UDC/DocBlock1'
 * '<S2>'   : 'UDC/Environment Controller'
 * '<S3>'   : 'UDC/Environment Controller1'
 * '<S4>'   : 'UDC/Environment Controller2'
 * '<S5>'   : 'UDC/FeedForward'
 * '<S6>'   : 'UDC/Flow_CL'
 * '<S7>'   : 'UDC/Info1'
 * '<S8>'   : 'UDC/NOx_CL'
 * '<S9>'   : 'UDC/SignalManager'
 * '<S10>'  : 'UDC/SlipDetection'
 * '<S11>'  : 'UDC/FeedForward/D1_FF_Manager'
 * '<S12>'  : 'UDC/FeedForward/D1a_FF_LoadTab'
 * '<S13>'  : 'UDC/FeedForward/D1b_FF_NOx'
 * '<S14>'  : 'UDC/FeedForward/D1c_FF_map'
 * '<S15>'  : 'UDC/FeedForward/D6_FF_Adjust'
 * '<S16>'  : 'UDC/FeedForward/FF_NH3Sens_based'
 * '<S17>'  : 'UDC/FeedForward/spaceVelocityCalc'
 * '<S18>'  : 'UDC/FeedForward/D1_FF_Manager/ESC_Corr'
 * '<S19>'  : 'UDC/FeedForward/D1_FF_Manager/Saturation Dynamic1'
 * '<S20>'  : 'UDC/FeedForward/D1_FF_Manager/UrInFFCalcManager'
 * '<S21>'  : 'UDC/FeedForward/D1_FF_Manager/UrInFFCalcManager/UrInMethCalculation'
 * '<S22>'  : 'UDC/FeedForward/D1b_FF_NOx/Divisor'
 * '<S23>'  : 'UDC/FeedForward/D1b_FF_NOx/Divisor1'
 * '<S24>'  : 'UDC/FeedForward/D1b_FF_NOx/Divisor2'
 * '<S25>'  : 'UDC/FeedForward/D1b_FF_NOx/Divisor/Data Type Conversion Inherited'
 * '<S26>'  : 'UDC/FeedForward/D1b_FF_NOx/Divisor1/Data Type Conversion Inherited'
 * '<S27>'  : 'UDC/FeedForward/D1b_FF_NOx/Divisor2/Data Type Conversion Inherited'
 * '<S28>'  : 'UDC/FeedForward/D1c_FF_map/SCRStorageDynamics'
 * '<S29>'  : 'UDC/FeedForward/D1c_FF_map/SCRStorageDynamicsNOxInclude'
 * '<S30>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel'
 * '<S31>'  : 'UDC/FeedForward/D1c_FF_map/Saturation Dynamic1'
 * '<S32>'  : 'UDC/FeedForward/D1c_FF_map/Saturation Dynamic2'
 * '<S33>'  : 'UDC/FeedForward/D1c_FF_map/Saturation Dynamic3'
 * '<S34>'  : 'UDC/FeedForward/D1c_FF_map/UreaMassFlowCalcFF'
 * '<S35>'  : 'UDC/FeedForward/D1c_FF_map/steadyStateUsageMap'
 * '<S36>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell1'
 * '<S37>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell2'
 * '<S38>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell3'
 * '<S39>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Divisor'
 * '<S40>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell1/Divisor'
 * '<S41>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell1/Divisor1'
 * '<S42>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell1/Divisor/Data Type Conversion Inherited'
 * '<S43>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell1/Divisor1/Data Type Conversion Inherited'
 * '<S44>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell2/Divisor'
 * '<S45>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell2/Divisor1'
 * '<S46>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell2/Divisor/Data Type Conversion Inherited'
 * '<S47>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell2/Divisor1/Data Type Conversion Inherited'
 * '<S48>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell3/Divisor'
 * '<S49>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell3/Divisor1'
 * '<S50>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell3/Divisor/Data Type Conversion Inherited'
 * '<S51>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Cell3/Divisor1/Data Type Conversion Inherited'
 * '<S52>'  : 'UDC/FeedForward/D1c_FF_map/SCRThermalMaxStorageModel/Divisor/Data Type Conversion Inherited'
 * '<S53>'  : 'UDC/FeedForward/D1c_FF_map/UreaMassFlowCalcFF/Divisor'
 * '<S54>'  : 'UDC/FeedForward/D1c_FF_map/UreaMassFlowCalcFF/Divisor1'
 * '<S55>'  : 'UDC/FeedForward/D1c_FF_map/UreaMassFlowCalcFF/Divisor2'
 * '<S56>'  : 'UDC/FeedForward/D1c_FF_map/UreaMassFlowCalcFF/Divisor/Data Type Conversion Inherited'
 * '<S57>'  : 'UDC/FeedForward/D1c_FF_map/UreaMassFlowCalcFF/Divisor1/Data Type Conversion Inherited'
 * '<S58>'  : 'UDC/FeedForward/D1c_FF_map/UreaMassFlowCalcFF/Divisor2/Data Type Conversion Inherited'
 * '<S59>'  : 'UDC/FeedForward/D1c_FF_map/steadyStateUsageMap/SV_TSCR_to_NOxRedRatio'
 * '<S60>'  : 'UDC/FeedForward/D1c_FF_map/steadyStateUsageMap/Saturation Dynamic'
 * '<S61>'  : 'UDC/FeedForward/D6_FF_Adjust/Divisor1'
 * '<S62>'  : 'UDC/FeedForward/D6_FF_Adjust/Filter'
 * '<S63>'  : 'UDC/FeedForward/D6_FF_Adjust/Filter1'
 * '<S64>'  : 'UDC/FeedForward/D6_FF_Adjust/Saturation Dynamic1'
 * '<S65>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing'
 * '<S66>'  : 'UDC/FeedForward/D6_FF_Adjust/rateLimit'
 * '<S67>'  : 'UDC/FeedForward/D6_FF_Adjust/Divisor1/Data Type Conversion Inherited'
 * '<S68>'  : 'UDC/FeedForward/D6_FF_Adjust/Filter/Divisor'
 * '<S69>'  : 'UDC/FeedForward/D6_FF_Adjust/Filter/Divisor/Data Type Conversion Inherited'
 * '<S70>'  : 'UDC/FeedForward/D6_FF_Adjust/Filter1/Divisor'
 * '<S71>'  : 'UDC/FeedForward/D6_FF_Adjust/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S72>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing/TON'
 * '<S73>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing/TP'
 * '<S74>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing/TON/Data Type Conversion Inherited'
 * '<S75>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing/TP/Compare To Zero'
 * '<S76>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing/TP/Enabled Subsystem'
 * '<S77>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing/TP/Enabled Subsystem1'
 * '<S78>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing/TP/Rate Limiter'
 * '<S79>'  : 'UDC/FeedForward/D6_FF_Adjust/Timing/TP/Rate Limiter/Saturation Dynamic'
 * '<S80>'  : 'UDC/FeedForward/D6_FF_Adjust/rateLimit/Saturation Dynamic'
 * '<S81>'  : 'UDC/FeedForward/FF_NH3Sens_based/Saturation Dynamic'
 * '<S82>'  : 'UDC/FeedForward/spaceVelocityCalc/Divisor1'
 * '<S83>'  : 'UDC/FeedForward/spaceVelocityCalc/Divisor1/Data Type Conversion Inherited'
 * '<S84>'  : 'UDC/Flow_CL/Dummy'
 * '<S85>'  : 'UDC/Flow_CL/UrPumpCntr'
 * '<S86>'  : 'UDC/Flow_CL/UrValCntr'
 * '<S87>'  : 'UDC/Flow_CL/UrPumpCntr/Divisor1'
 * '<S88>'  : 'UDC/Flow_CL/UrPumpCntr/PID_UrPump'
 * '<S89>'  : 'UDC/Flow_CL/UrPumpCntr/PumpFlowCorrCheck'
 * '<S90>'  : 'UDC/Flow_CL/UrPumpCntr/Saturation Dynamic1'
 * '<S91>'  : 'UDC/Flow_CL/UrPumpCntr/Saturation Dynamic2'
 * '<S92>'  : 'UDC/Flow_CL/UrPumpCntr/Divisor1/Data Type Conversion Inherited'
 * '<S93>'  : 'UDC/Flow_CL/UrValCntr/Divisor1'
 * '<S94>'  : 'UDC/Flow_CL/UrValCntr/PID_UrVal'
 * '<S95>'  : 'UDC/Flow_CL/UrValCntr/Saturation Dynamic1'
 * '<S96>'  : 'UDC/Flow_CL/UrValCntr/Saturation Dynamic2'
 * '<S97>'  : 'UDC/Flow_CL/UrValCntr/U6_ValveFlowCorr'
 * '<S98>'  : 'UDC/Flow_CL/UrValCntr/ValveFlowCorrCheck'
 * '<S99>'  : 'UDC/Flow_CL/UrValCntr/Divisor1/Data Type Conversion Inherited'
 * '<S100>' : 'UDC/Flow_CL/UrValCntr/U6_ValveFlowCorr/Divisor'
 * '<S101>' : 'UDC/Flow_CL/UrValCntr/U6_ValveFlowCorr/Filter_DPr'
 * '<S102>' : 'UDC/Flow_CL/UrValCntr/U6_ValveFlowCorr/Divisor/Data Type Conversion Inherited'
 * '<S103>' : 'UDC/Flow_CL/UrValCntr/U6_ValveFlowCorr/Filter_DPr/Divisor'
 * '<S104>' : 'UDC/Flow_CL/UrValCntr/U6_ValveFlowCorr/Filter_DPr/Divisor/Data Type Conversion Inherited'
 * '<S105>' : 'UDC/Flow_CL/UrValCntr/ValveFlowCorrCheck/Divisor2'
 * '<S106>' : 'UDC/Flow_CL/UrValCntr/ValveFlowCorrCheck/Filter_DPr'
 * '<S107>' : 'UDC/Flow_CL/UrValCntr/ValveFlowCorrCheck/Divisor2/Data Type Conversion Inherited'
 * '<S108>' : 'UDC/Flow_CL/UrValCntr/ValveFlowCorrCheck/Filter_DPr/Divisor'
 * '<S109>' : 'UDC/Flow_CL/UrValCntr/ValveFlowCorrCheck/Filter_DPr/Divisor/Data Type Conversion Inherited'
 * '<S110>' : 'UDC/NOx_CL/Saturation Dynamic1'
 * '<S111>' : 'UDC/NOx_CL/UreaInjectionClosedLoopControl'
 * '<S112>' : 'UDC/NOx_CL/UreaInjectionClosedLoopControl/PID_NOx'
 * '<S113>' : 'UDC/NOx_CL/UreaInjectionClosedLoopControl/PID_Para'
 * '<S114>' : 'UDC/NOx_CL/UreaInjectionClosedLoopControl/Saturation Dynamic1'
 * '<S115>' : 'UDC/NOx_CL/UreaInjectionClosedLoopControl/Saturation Dynamic2'
 * '<S116>' : 'UDC/NOx_CL/UreaInjectionClosedLoopControl/TON'
 * '<S117>' : 'UDC/NOx_CL/UreaInjectionClosedLoopControl/TON/Data Type Conversion Inherited'
 * '<S118>' : 'UDC/SignalManager/E20_NOxEngOutManager'
 * '<S119>' : 'UDC/SignalManager/E21_NOxCatOutManager'
 * '<S120>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState'
 * '<S121>' : 'UDC/SignalManager/E23_T_SCR_Avg'
 * '<S122>' : 'UDC/SignalManager/E21_NOxCatOutManager/MATLAB Function'
 * '<S123>' : 'UDC/SignalManager/E21_NOxCatOutManager/TOF'
 * '<S124>' : 'UDC/SignalManager/E21_NOxCatOutManager/TOF1'
 * '<S125>' : 'UDC/SignalManager/E21_NOxCatOutManager/TOF/Data Type Conversion Inherited'
 * '<S126>' : 'UDC/SignalManager/E21_NOxCatOutManager/TOF1/Data Type Conversion Inherited'
 * '<S127>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/Filter'
 * '<S128>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/Filter2'
 * '<S129>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/TON'
 * '<S130>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/TON1'
 * '<S131>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/Filter/Divisor'
 * '<S132>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/Filter/Divisor/Data Type Conversion Inherited'
 * '<S133>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/Filter2/Divisor'
 * '<S134>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/Filter2/Divisor/Data Type Conversion Inherited'
 * '<S135>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/TON/Data Type Conversion Inherited'
 * '<S136>' : 'UDC/SignalManager/E22_Engine_Cat_SteadyState/TON1/Data Type Conversion Inherited'
 * '<S137>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna'
 * '<S138>' : 'UDC/SlipDetection/E9_2'
 * '<S139>' : 'UDC/SlipDetection/E9_3_SlipDetection'
 * '<S140>' : 'UDC/SlipDetection/E9_4_SlipDetection'
 * '<S141>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr'
 * '<S142>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/Detect Decrease'
 * '<S143>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TOF'
 * '<S144>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TON'
 * '<S145>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TON3'
 * '<S146>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TP'
 * '<S147>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TOF/rateLimit'
 * '<S148>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TOF/rateLimit/Saturation Dynamic'
 * '<S149>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TON/Data Type Conversion Inherited'
 * '<S150>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TON3/Data Type Conversion Inherited'
 * '<S151>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TP/Compare To Zero'
 * '<S152>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TP/Enabled Subsystem'
 * '<S153>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TP/Enabled Subsystem1'
 * '<S154>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TP/Rate Limiter'
 * '<S155>' : 'UDC/SlipDetection/E9_1_SlipCtrlEna/TP/Rate Limiter/Saturation Dynamic'
 * '<S156>' : 'UDC/SlipDetection/E9_2/S-R Flip-Flop'
 * '<S157>' : 'UDC/SlipDetection/E9_2/TON'
 * '<S158>' : 'UDC/SlipDetection/E9_2/TON1'
 * '<S159>' : 'UDC/SlipDetection/E9_2/TON2'
 * '<S160>' : 'UDC/SlipDetection/E9_2/TP1'
 * '<S161>' : 'UDC/SlipDetection/E9_2/TON/Data Type Conversion Inherited'
 * '<S162>' : 'UDC/SlipDetection/E9_2/TON1/Data Type Conversion Inherited'
 * '<S163>' : 'UDC/SlipDetection/E9_2/TON2/Data Type Conversion Inherited'
 * '<S164>' : 'UDC/SlipDetection/E9_2/TP1/Compare To Zero'
 * '<S165>' : 'UDC/SlipDetection/E9_2/TP1/Enabled Subsystem'
 * '<S166>' : 'UDC/SlipDetection/E9_2/TP1/Enabled Subsystem1'
 * '<S167>' : 'UDC/SlipDetection/E9_2/TP1/Rate Limiter'
 * '<S168>' : 'UDC/SlipDetection/E9_2/TP1/Rate Limiter/Saturation Dynamic'
 * '<S169>' : 'UDC/SlipDetection/E9_3_SlipDetection/Compare To Zero'
 * '<S170>' : 'UDC/SlipDetection/E9_3_SlipDetection/Divisor'
 * '<S171>' : 'UDC/SlipDetection/E9_3_SlipDetection/Filter_CatOut'
 * '<S172>' : 'UDC/SlipDetection/E9_3_SlipDetection/Filter_OxiIn'
 * '<S173>' : 'UDC/SlipDetection/E9_3_SlipDetection/TON'
 * '<S174>' : 'UDC/SlipDetection/E9_3_SlipDetection/TP'
 * '<S175>' : 'UDC/SlipDetection/E9_3_SlipDetection/Divisor/Data Type Conversion Inherited'
 * '<S176>' : 'UDC/SlipDetection/E9_3_SlipDetection/Filter_CatOut/Divisor'
 * '<S177>' : 'UDC/SlipDetection/E9_3_SlipDetection/Filter_CatOut/Divisor/Data Type Conversion Inherited'
 * '<S178>' : 'UDC/SlipDetection/E9_3_SlipDetection/Filter_OxiIn/Divisor'
 * '<S179>' : 'UDC/SlipDetection/E9_3_SlipDetection/Filter_OxiIn/Divisor/Data Type Conversion Inherited'
 * '<S180>' : 'UDC/SlipDetection/E9_3_SlipDetection/TON/Data Type Conversion Inherited'
 * '<S181>' : 'UDC/SlipDetection/E9_3_SlipDetection/TP/Compare To Zero'
 * '<S182>' : 'UDC/SlipDetection/E9_3_SlipDetection/TP/Enabled Subsystem'
 * '<S183>' : 'UDC/SlipDetection/E9_3_SlipDetection/TP/Enabled Subsystem1'
 * '<S184>' : 'UDC/SlipDetection/E9_3_SlipDetection/TP/Rate Limiter'
 * '<S185>' : 'UDC/SlipDetection/E9_3_SlipDetection/TP/Rate Limiter/Saturation Dynamic'
 * '<S186>' : 'UDC/SlipDetection/E9_4_SlipDetection/Divisor2'
 * '<S187>' : 'UDC/SlipDetection/E9_4_SlipDetection/TON'
 * '<S188>' : 'UDC/SlipDetection/E9_4_SlipDetection/TON1'
 * '<S189>' : 'UDC/SlipDetection/E9_4_SlipDetection/TON2'
 * '<S190>' : 'UDC/SlipDetection/E9_4_SlipDetection/TON3'
 * '<S191>' : 'UDC/SlipDetection/E9_4_SlipDetection/Divisor2/Data Type Conversion Inherited'
 * '<S192>' : 'UDC/SlipDetection/E9_4_SlipDetection/TON/Data Type Conversion Inherited'
 * '<S193>' : 'UDC/SlipDetection/E9_4_SlipDetection/TON1/Data Type Conversion Inherited'
 * '<S194>' : 'UDC/SlipDetection/E9_4_SlipDetection/TON2/Data Type Conversion Inherited'
 * '<S195>' : 'UDC/SlipDetection/E9_4_SlipDetection/TON3/Data Type Conversion Inherited'
 * '<S196>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/Compare To Constant'
 * '<S197>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/Compare To Constant1'
 * '<S198>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/Detect Rise Positive'
 * '<S199>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/Filter1'
 * '<S200>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/S-R Flip-Flop'
 * '<S201>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/TON'
 * '<S202>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/rateLimit'
 * '<S203>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/rateLimit1'
 * '<S204>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/switchHold fct1'
 * '<S205>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/Detect Rise Positive/Positive'
 * '<S206>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/Filter1/Divisor'
 * '<S207>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S208>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/TON/Data Type Conversion Inherited'
 * '<S209>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/rateLimit/Saturation Dynamic'
 * '<S210>' : 'UDC/SlipDetection/E9_5_SlipCtrlCorr/rateLimit1/Saturation Dynamic'
 */
#endif                                 /* RTW_HEADER_UDC_h_ */
