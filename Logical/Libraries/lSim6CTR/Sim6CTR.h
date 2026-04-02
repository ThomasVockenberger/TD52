/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: Sim6CTR
 * File: Sim6CTR.h
 * Author: 105051472
 * Created: Wed Oct 23 10:19:46 2013
 ********************************************************************
 * Header for program Sim6CTR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_Sim6CTR_h_
#define RTW_HEADER_Sim6CTR_h_
#ifndef Sim6CTR_COMMON_INCLUDES_
# define Sim6CTR_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* Sim6CTR_COMMON_INCLUDES_ */

#include "Sim6CTR_types.h"
#include "lSim6CTR.h"

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
extern BlockIO_Sim6CTR Sim6CTR_B;

/* Block states (auto storage) */
extern D_Work_Sim6CTR Sim6CTR_DWork;

/* Model entry point functions */
extern void Sim6CTR_initialize(struct Sim6CTR* inst);
extern void Sim6CTR_step(struct Sim6CTR* inst);
extern void Sim6CTR_terminate(struct Sim6CTR* inst);

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
 * '<Root>' : 'Sim6CTR'
 * '<S1>'   : 'Sim6CTR/Island Controller'
 * '<S2>'   : 'Sim6CTR/Model Info'
 * '<S3>'   : 'Sim6CTR/Island Controller/Chart'
 * '<S4>'   : 'Sim6CTR/Island Controller/Compare To Constant1'
 * '<S5>'   : 'Sim6CTR/Island Controller/Difference1'
 * '<S6>'   : 'Sim6CTR/Island Controller/Down Sampling'
 * '<S7>'   : 'Sim6CTR/Island Controller/PID CBP'
 * '<S8>'   : 'Sim6CTR/Island Controller/PID TV'
 * '<S9>'   : 'Sim6CTR/Island Controller/Down Sampling/Timer'
 * '<S10>'  : 'Sim6CTR/Island Controller/PID CBP/PID'
 * '<S11>'  : 'Sim6CTR/Island Controller/PID CBP/PID/Clamping circuit'
 * '<S12>'  : 'Sim6CTR/Island Controller/PID CBP/PID/Clamping circuit/Compare To Constant'
 * '<S13>'  : 'Sim6CTR/Island Controller/PID TV/PID'
 * '<S14>'  : 'Sim6CTR/Island Controller/PID TV/PID/Clamping circuit'
 * '<S15>'  : 'Sim6CTR/Island Controller/PID TV/PID/Clamping circuit/Compare To Constant'
 */
#endif                                 /* RTW_HEADER_Sim6CTR_h_ */
