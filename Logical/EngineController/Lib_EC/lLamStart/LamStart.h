/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LamStart
 * File: LamStart.h
 * Author: 105055527
 * Created: Thu May 18 17:26:11 2017
 ********************************************************************
 * Header for program LamStart
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_LamStart_h_
#define RTW_HEADER_LamStart_h_
#ifndef LamStart_COMMON_INCLUDES_
# define LamStart_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* LamStart_COMMON_INCLUDES_ */

#include "LamStart_types.h"
#include "lLamStart.h"

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

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* Zero-crossing (trigger) state */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Model entry point functions */
extern void LamStart_initialize(D_Work_LamStart *LamStart_DWork,
  PrevZCSigStates_LamStart *LamStart_PrevZCSigState, struct fLamStart* inst);
extern void LamStart_step(BlockIO_LamStart *LamStart_B, D_Work_LamStart
  *LamStart_DWork, PrevZCSigStates_LamStart *LamStart_PrevZCSigState,
  ExternalOutputs_LamStart *LamStart_Y, struct fLamStart* inst);
extern void LamStart_terminate(struct fLamStart* inst);

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
 * '<Root>' : 'LamStart'
 * '<S1>'   : 'LamStart/EC1'
 * '<S2>'   : 'LamStart/EC2'
 * '<S3>'   : 'LamStart/EC3'
 * '<S4>'   : 'LamStart/Info'
 * '<S5>'   : 'LamStart/Saturation Dynamic'
 * '<S6>'   : 'LamStart/enableStartLambda'
 * '<S7>'   : 'LamStart/enableStartLambda/Hysteresis'
 * '<S8>'   : 'LamStart/enableStartLambda/TON'
 * '<S9>'   : 'LamStart/enableStartLambda/rateLimit'
 * '<S10>'  : 'LamStart/enableStartLambda/TON/Data Type Conversion Inherited'
 * '<S11>'  : 'LamStart/enableStartLambda/rateLimit/Saturation Dynamic'
 */
#endif                                 /* RTW_HEADER_LamStart_h_ */
