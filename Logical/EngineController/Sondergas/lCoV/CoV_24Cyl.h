/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: CoV_24Cyl
 * File: CoV_24Cyl.h
 * Author: 105055527
 * Created: Tue Sep 23 05:31:36 2014
 ********************************************************************
 * Header for program CoV_24Cyl
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_CoV_24Cyl_h_
#define RTW_HEADER_CoV_24Cyl_h_
#ifndef CoV_24Cyl_COMMON_INCLUDES_
# define CoV_24Cyl_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* CoV_24Cyl_COMMON_INCLUDES_ */

#include "CoV_24Cyl_types.h"
#include "lCoV.h"

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
extern BlockIO_CoV_24Cyl CoV_24Cyl_B;

/* Block states (auto storage) */
extern D_Work_CoV_24Cyl CoV_24Cyl_DWork;

/* Model entry point functions */
extern void CoV_24Cyl_initialize(struct CoV* inst);
extern void CoV_24Cyl_step(struct CoV* inst);
extern void CoV_24Cyl_terminate(struct CoV* inst);

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
 * '<Root>' : 'CoV_24Cyl'
 * '<S1>'   : 'CoV_24Cyl/CoV_0'
 * '<S2>'   : 'CoV_24Cyl/CoV_1'
 * '<S3>'   : 'CoV_24Cyl/CoV_10'
 * '<S4>'   : 'CoV_24Cyl/CoV_11'
 * '<S5>'   : 'CoV_24Cyl/CoV_12'
 * '<S6>'   : 'CoV_24Cyl/CoV_13'
 * '<S7>'   : 'CoV_24Cyl/CoV_14'
 * '<S8>'   : 'CoV_24Cyl/CoV_15'
 * '<S9>'   : 'CoV_24Cyl/CoV_16'
 * '<S10>'  : 'CoV_24Cyl/CoV_17'
 * '<S11>'  : 'CoV_24Cyl/CoV_18'
 * '<S12>'  : 'CoV_24Cyl/CoV_19'
 * '<S13>'  : 'CoV_24Cyl/CoV_2'
 * '<S14>'  : 'CoV_24Cyl/CoV_20'
 * '<S15>'  : 'CoV_24Cyl/CoV_21'
 * '<S16>'  : 'CoV_24Cyl/CoV_22'
 * '<S17>'  : 'CoV_24Cyl/CoV_23'
 * '<S18>'  : 'CoV_24Cyl/CoV_24'
 * '<S19>'  : 'CoV_24Cyl/CoV_3'
 * '<S20>'  : 'CoV_24Cyl/CoV_4'
 * '<S21>'  : 'CoV_24Cyl/CoV_5'
 * '<S22>'  : 'CoV_24Cyl/CoV_6'
 * '<S23>'  : 'CoV_24Cyl/CoV_7'
 * '<S24>'  : 'CoV_24Cyl/CoV_8'
 * '<S25>'  : 'CoV_24Cyl/CoV_9'
 */
#endif                                 /* RTW_HEADER_CoV_24Cyl_h_ */
