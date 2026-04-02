/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: SimPID4
 * File: SimPID4.h
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Header for program SimPID4
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_SimPID4_h_
#define RTW_HEADER_SimPID4_h_
#ifndef SimPID4_COMMON_INCLUDES_
# define SimPID4_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* SimPID4_COMMON_INCLUDES_ */

#include "SimPID4_types.h"
#include "lSimPID4.h"

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


/* Block signals (auto storage) */
extern BlockIO_SimPID4 SimPID4_B;

/* Block states (auto storage) */
extern D_Work_SimPID4 SimPID4_DWork;

/* Model entry point functions */
extern void SimPID4_initialize(struct SimPID4* inst);
extern void SimPID4_step(struct SimPID4* inst);
extern void SimPID4_terminate(struct SimPID4* inst);

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
 * '<Root>' : SimPID4
 * '<S1>'   : SimPID4/Model Info
 * '<S2>'   : SimPID4/PID Autocoding
 * '<S3>'   : SimPID4/PID Autocoding/PID
 * '<S4>'   : SimPID4/PID Autocoding/PID/Clamping circuit
 * '<S5>'   : SimPID4/PID Autocoding/PID/Clamping circuit/Compare To Constant
 */
#endif                                 /* RTW_HEADER_SimPID4_h_ */
