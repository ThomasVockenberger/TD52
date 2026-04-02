/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: IP_EGTCtr
 * File: IP_EGTCtr.h
 * Author: 302013638
 * Created: Fri Sep 10 20:20:48 2010
 ********************************************************************
 * Header for program IP_EGTCtr
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_IP_EGTCtr_h_
#define RTW_HEADER_IP_EGTCtr_h_
#ifndef IP_EGTCtr_COMMON_INCLUDES_
# define IP_EGTCtr_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* IP_EGTCtr_COMMON_INCLUDES_ */

#include "IP_EGTCtr_types.h"
#include "lIP_EGTCtr.h"

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
extern BlockIO_IP_EGTCtr IP_EGTCtr_B;

/* Block states (auto storage) */
extern D_Work_IP_EGTCtr IP_EGTCtr_DWork;

/* Model entry point functions */
extern void IP_EGTCtr_initialize(struct fIP_EGTCtr* inst);
extern void IP_EGTCtr_step(struct fIP_EGTCtr* inst);
extern void IP_EGTCtr_terminate(struct fIP_EGTCtr* inst);

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
 * '<Root>' : 'IP_EGTCtr'
 * '<S1>'   : 'IP_EGTCtr/DocBlock'
 * '<S2>'   : 'IP_EGTCtr/Model Info'
 * '<S3>'   : 'IP_EGTCtr/TexhCntrSys'
 * '<S4>'   : 'IP_EGTCtr/TexhCntrSys/Dead Zone Dynamic'
 * '<S5>'   : 'IP_EGTCtr/TexhCntrSys/Saturation Dynamic4'
 */
#endif                                 /* RTW_HEADER_IP_EGTCtr_h_ */
