/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: Sim3pCTR
 * File: Sim3pCTR.h
 * Author: 105051472
 * Created: Thu Jan 10 08:03:20 2013
 ********************************************************************
 * Header for program Sim3pCTR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V3.3
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_Sim3pCTR_h_
#define RTW_HEADER_Sim3pCTR_h_
#ifndef Sim3pCTR_COMMON_INCLUDES_
# define Sim3pCTR_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* Sim3pCTR_COMMON_INCLUDES_ */

#include "Sim3pCTR_types.h"
#include "lSim3pCTR.h"

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
extern BlockIO_Sim3pCTR Sim3pCTR_B;

/* Block states (auto storage) */
extern D_Work_Sim3pCTR Sim3pCTR_DWork;

/* Model entry point functions */
extern void Sim3pCTR_initialize(struct Sim3pCTR* inst);
extern void Sim3pCTR_step(struct Sim3pCTR* inst);
extern void Sim3pCTR_terminate(struct Sim3pCTR* inst);

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
 * '<Root>' : Sim3pCTR
 * '<S1>'   : Sim3pCTR/Model Info
 * '<S2>'   : Sim3pCTR/Sim3pCTR
 * '<S3>'   : Sim3pCTR/Sim3pCTR/Integrator
 * '<S4>'   : Sim3pCTR/Sim3pCTR/StateMachine
 * '<S5>'   : Sim3pCTR/Sim3pCTR/Integrator/Saturation Dynamic
 */
#endif                                 /* RTW_HEADER_Sim3pCTR_h_ */
