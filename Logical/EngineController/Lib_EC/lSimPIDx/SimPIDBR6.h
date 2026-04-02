/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: SimPIDBR6
 * File: SimPIDBR6.h
 * Author: 105055527
 * Created: Tue Dec 06 16:11:54 2016
 ********************************************************************
 * Header for program SimPIDBR6
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_SimPIDBR6_h_
#define RTW_HEADER_SimPIDBR6_h_
#ifndef SimPIDBR6_COMMON_INCLUDES_
# define SimPIDBR6_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* SimPIDBR6_COMMON_INCLUDES_ */

#include "SimPIDBR6_types.h"
#include "lSimPIDx.h"

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

/* Model entry point functions */
extern void SimPIDBR6_initialize(D_Work_SimPIDBR6 *SimPIDBR6_DWork, struct fSimPIDx* inst);
extern void SimPIDBR6_step(BlockIO_SimPIDBR6 *SimPIDBR6_B, D_Work_SimPIDBR6
  *SimPIDBR6_DWork, struct fSimPIDx* inst);
extern void SimPIDBR6_terminate(struct fSimPIDx* inst);

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
 * '<Root>' : 'SimPIDBR6'
 * '<S1>'   : 'SimPIDBR6/PID Autocoding'
 * '<S2>'   : 'SimPIDBR6/PID Autocoding/PID'
 * '<S3>'   : 'SimPIDBR6/PID Autocoding/PID/Clamping circuit'
 * '<S4>'   : 'SimPIDBR6/PID Autocoding/PID/Clamping circuit/Compare To Constant'
 */
#endif                                 /* RTW_HEADER_SimPIDBR6_h_ */
