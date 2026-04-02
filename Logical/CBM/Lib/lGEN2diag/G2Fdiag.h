/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: G2Fdiag
 * File: G2Fdiag.h
 * Author: 106003773
 * Created: Wed Apr 20 16:09:39 2016
 ********************************************************************
 * Header for program G2Fdiag
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_G2Fdiag_h_
#define RTW_HEADER_G2Fdiag_h_
#ifndef G2Fdiag_COMMON_INCLUDES_
# define G2Fdiag_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#endif                                 /* G2Fdiag_COMMON_INCLUDES_ */

#include "G2Fdiag_types.h"
#include "lGEN2diag.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((void*) 0)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((void) 0)
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

/* Block signals for system '<S7>/TOF' */

/* Block states (auto storage) for system '<S7>/TOF' */

/* Block signals for system '<S8>/TON' */

/* Block states (auto storage) for system '<S8>/TON' */

/* Block signals for system '<S6>/TP' */

/* Block states (auto storage) for system '<S6>/TP' */

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Block signals (auto storage) */
extern BlockIO_G2Fdiag G2Fdiag_B;

/* Block states (auto storage) */
extern D_Work_G2Fdiag G2Fdiag_DWork;

/* External inputs (root inport signals with auto storage) */
extern ExternalInputs_G2Fdiag G2Fdiag_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExternalOutputs_G2Fdiag G2Fdiag_Y;

/* Model entry point functions */
extern void G2Fdiag_initialize(struct fGEN2diag* inst);
extern void G2Fdiag_step(struct fGEN2diag* inst);
extern void G2Fdiag_terminate(struct fGEN2diag* inst);

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
 * '<Root>' : 'G2Fdiag'
 * '<S1>'   : 'G2Fdiag/Environment Controller'
 * '<S2>'   : 'G2Fdiag/Environment Controller1'
 * '<S3>'   : 'G2Fdiag/GEN2_Friction_Detection'
 * '<S4>'   : 'G2Fdiag/Info'
 * '<S5>'   : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic'
 * '<S6>'   : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection'
 * '<S7>'   : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Exteternal disturbance'
 * '<S8>'   : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring'
 * '<S9>'   : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GasMixingTransient'
 * '<S10>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/LEANOX error monitoring'
 * '<S11>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Min Load Detection'
 * '<S12>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Power ramp detection'
 * '<S13>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp'
 * '<S14>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring'
 * '<S15>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Wastegate monitoring'
 * '<S16>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Exteternal disturbance/TOF'
 * '<S17>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Exteternal disturbance/TOF/Data Type Conversion Inherited'
 * '<S18>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change GCB'
 * '<S19>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change MCB'
 * '<S20>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/TON'
 * '<S21>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change GCB/Detect Fall Nonpositive'
 * '<S22>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change GCB/Detect Rise Positive'
 * '<S23>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change GCB/Detect Fall Nonpositive/Nonpositive'
 * '<S24>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change GCB/Detect Rise Positive/Positive'
 * '<S25>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change MCB/Detect Fall Nonpositive'
 * '<S26>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change MCB/Detect Rise Positive'
 * '<S27>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change MCB/Detect Fall Nonpositive/Nonpositive'
 * '<S28>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/State Change MCB/Detect Rise Positive/Positive'
 * '<S29>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GBC and MBC monitoring/TON/Data Type Conversion Inherited'
 * '<S30>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GasMixingTransient/TON'
 * '<S31>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GasMixingTransient/filterTexh'
 * '<S32>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GasMixingTransient/highpass gas mixing'
 * '<S33>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GasMixingTransient/TON/Data Type Conversion Inherited'
 * '<S34>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/GasMixingTransient/highpass gas mixing/filter4'
 * '<S35>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/LEANOX error monitoring/TON'
 * '<S36>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/LEANOX error monitoring/filter4'
 * '<S37>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/LEANOX error monitoring/TON/Data Type Conversion Inherited'
 * '<S38>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Min Load Detection/TOF'
 * '<S39>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Min Load Detection/TOF/Data Type Conversion Inherited'
 * '<S40>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Power ramp detection/TOF'
 * '<S41>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Power ramp detection/filter4'
 * '<S42>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Power ramp detection/TOF/Data Type Conversion Inherited'
 * '<S43>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/Detect Fall Nonpositive'
 * '<S44>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/Detect Rise Positive'
 * '<S45>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/MATLAB Function'
 * '<S46>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/TON'
 * '<S47>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/TON1'
 * '<S48>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/filterTexh'
 * '<S49>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/highpassTexh'
 * '<S50>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/Detect Fall Nonpositive/Nonpositive'
 * '<S51>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/Detect Rise Positive/Positive'
 * '<S52>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/TON/Data Type Conversion Inherited'
 * '<S53>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/TON1/Data Type Conversion Inherited'
 * '<S54>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Texh settled after power ramp/highpassTexh/filter4'
 * '<S55>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring/TON'
 * '<S56>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring/voltage phase 1'
 * '<S57>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring/voltage phase 2'
 * '<S58>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring/voltage phase 3'
 * '<S59>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring/TON/Data Type Conversion Inherited'
 * '<S60>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring/voltage phase 1/filter4'
 * '<S61>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring/voltage phase 2/filter4'
 * '<S62>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Voltage monitoring/voltage phase 3/filter4'
 * '<S63>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Wastegate monitoring/TON'
 * '<S64>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Wastegate monitoring/filter4'
 * '<S65>'  : 'G2Fdiag/GEN2_Friction_Detection/DiagActivLogic/Wastegate monitoring/TON/Data Type Conversion Inherited'
 * '<S66>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/Detect Increase'
 * '<S67>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/Detect Increase1'
 * '<S68>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP'
 * '<S69>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP1'
 * '<S70>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/detection logic'
 * '<S71>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/detection logic1'
 * '<S72>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/highpass1'
 * '<S73>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/highpass2'
 * '<S74>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/lowpass1'
 * '<S75>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/lowpass2'
 * '<S76>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/vector to scalar (mean, etc.)'
 * '<S77>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP/Compare To Zero'
 * '<S78>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP/Enabled Subsystem'
 * '<S79>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP/Enabled Subsystem1'
 * '<S80>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP/Rate Limiter'
 * '<S81>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP/Rate Limiter/Saturation Dynamic'
 * '<S82>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP1/Compare To Zero'
 * '<S83>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP1/Enabled Subsystem'
 * '<S84>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP1/Enabled Subsystem1'
 * '<S85>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP1/Rate Limiter'
 * '<S86>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/TP1/Rate Limiter/Saturation Dynamic'
 * '<S87>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/highpass1/filter4'
 * '<S88>'  : 'G2Fdiag/GEN2_Friction_Detection/Fault Detection/highpass2/filter4'
 */
#endif                                 /* RTW_HEADER_G2Fdiag_h_ */
