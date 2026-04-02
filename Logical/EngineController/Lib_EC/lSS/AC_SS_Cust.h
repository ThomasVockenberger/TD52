/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_SS_Cust
 * File: AC_SS_Cust.h
 * Author: 105055527
 * Created: Thu May 19 13:50:06 2016
 ********************************************************************
 * Header for program AC_SS_Cust
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V5.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_AC_SS_Cust_h_
#define RTW_HEADER_AC_SS_Cust_h_
#ifndef AC_SS_Cust_COMMON_INCLUDES_
# define AC_SS_Cust_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* AC_SS_Cust_COMMON_INCLUDES_ */

#include "AC_SS_Cust_types.h"
#include "lSS.h"

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

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* External outputs (root outports fed by signals with auto storage) */

/* Real-time Model Data Structure */

/* Model entry point functions */
extern void AC_SS_Cust_initialize(struct SS_Cust* inst);
extern void AC_SS_Cust_step(BlockIO_AC_SS_Cust *AC_SS_Cust_B, D_Work_AC_SS_Cust *
  AC_SS_Cust_DWork, ExternalOutputs_AC_SS_Cust *AC_SS_Cust_Y, struct SS_Cust* inst);
extern void AC_SS_Cust_terminate(struct SS_Cust* inst);

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
 * '<Root>' : 'AC_SS_Cust'
 * '<S1>'   : 'AC_SS_Cust/Environment Controller'
 * '<S2>'   : 'AC_SS_Cust/SS_Cust'
 * '<S3>'   : 'AC_SS_Cust/SS_Cust/TON'
 * '<S4>'   : 'AC_SS_Cust/SS_Cust/TON/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_AC_SS_Cust_h_ */
