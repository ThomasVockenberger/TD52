/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LambdaAdp
 * File: LambdaAdp.h
 * Author: 105051472
 * Created: Wed Oct 29 12:06:16 2014
 ********************************************************************
 * Header for program LambdaAdp
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_LambdaAdp_h_
#define RTW_HEADER_LambdaAdp_h_
#ifndef LambdaAdp_COMMON_INCLUDES_
# define LambdaAdp_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* LambdaAdp_COMMON_INCLUDES_ */

#include "LambdaAdp_types.h"
#include "lLamCorr.h"

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
extern BlockIO_LambdaAdp LambdaAdp_B;

/* Block states (auto storage) */
extern D_Work_LambdaAdp LambdaAdp_DWork;

/* Model entry point functions */
extern void LambdaAdp_initialize(struct lLamCorr* inst);
extern void LambdaAdp_step(struct lLamCorr* inst);
extern void LambdaAdp_terminate(struct lLamCorr* inst);

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
 * '<Root>' : 'LambdaAdp'
 * '<S1>'   : 'LambdaAdp/LambdaAdaption'
 * '<S2>'   : 'LambdaAdp/LambdaAdaption/Lambda_Active'
 * '<S3>'   : 'LambdaAdp/LambdaAdaption/MAX'
 * '<S4>'   : 'LambdaAdp/LambdaAdaption/Rate Limiter Dynamic'
 * '<S5>'   : 'LambdaAdp/LambdaAdaption/Saturation Dynamic'
 * '<S6>'   : 'LambdaAdp/LambdaAdaption/Rate Limiter Dynamic/Saturation Dynamic'
 */
#endif                                 /* RTW_HEADER_LambdaAdp_h_ */
