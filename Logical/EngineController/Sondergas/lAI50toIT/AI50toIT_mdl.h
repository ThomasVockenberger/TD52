/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AI50toIT_mdl
 * File: AI50toIT_mdl.h
 * Author: 105055527
 * Created: Thu Sep 11 18:05:22 2014
 ********************************************************************
 * Header for program AI50toIT_mdl
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_AI50toIT_mdl_h_
#define RTW_HEADER_AI50toIT_mdl_h_
#ifndef AI50toIT_mdl_COMMON_INCLUDES_
# define AI50toIT_mdl_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* AI50toIT_mdl_COMMON_INCLUDES_ */

#include "AI50toIT_mdl_types.h"
#include "lAI50toIT.h"

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

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Block signals (auto storage) */
extern BlockIO_AI50toIT_mdl AI50toIT_mdl_B;

/* Block states (auto storage) */
extern D_Work_AI50toIT_mdl AI50toIT_mdl_DWork;

/* External inputs (root inport signals with auto storage) */
extern ExternalInputs_AI50toIT_mdl AI50toIT_mdl_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExternalOutputs_AI50toIT_mdl AI50toIT_mdl_Y;

/* Model entry point functions */
extern void AI50toIT_mdl_initialize(struct AI50toIT* inst);
extern void AI50toIT_mdl_step(struct AI50toIT* inst);
extern void AI50toIT_mdl_terminate(struct AI50toIT* inst);

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
 * '<Root>' : 'AI50toIT_mdl'
 * '<S1>'   : 'AI50toIT_mdl/AI50 filt'
 * '<S2>'   : 'AI50toIT_mdl/DocBlock'
 * '<S3>'   : 'AI50toIT_mdl/Environment Controller'
 * '<S4>'   : 'AI50toIT_mdl/Environment Controller1'
 * '<S5>'   : 'AI50toIT_mdl/Model Info'
 * '<S6>'   : 'AI50toIT_mdl/PID'
 * '<S7>'   : 'AI50toIT_mdl/Saturation Dynamic'
 * '<S8>'   : 'AI50toIT_mdl/PID/PID Autocoding2'
 * '<S9>'   : 'AI50toIT_mdl/PID/Saturation Dynamic'
 * '<S10>'  : 'AI50toIT_mdl/PID/PID Autocoding2/Dead Zone Dynamic'
 * '<S11>'  : 'AI50toIT_mdl/PID/PID Autocoding2/PID'
 * '<S12>'  : 'AI50toIT_mdl/PID/PID Autocoding2/PID/Clamping circuit'
 * '<S13>'  : 'AI50toIT_mdl/PID/PID Autocoding2/PID/Saturation Dynamic'
 * '<S14>'  : 'AI50toIT_mdl/PID/PID Autocoding2/PID/Clamping circuit/Compare To Constant'
 */
#endif                                 /* RTW_HEADER_AI50toIT_mdl_h_ */
