/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: HiContr
 * File: HiContr.h
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Header for program HiContr
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_HiContr_h_
#define RTW_HEADER_HiContr_h_
#ifndef HiContr_COMMON_INCLUDES_
# define HiContr_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* HiContr_COMMON_INCLUDES_ */

#include "HiContr_types.h"
#include "lHiContr.h"

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
extern BlockIO_HiContr HiContr_B;

/* Block states (auto storage) */
extern D_Work_HiContr HiContr_DWork;

/* Model entry point functions */
extern void HiContr_initialize(struct HiContr* inst);
extern void HiContr_step(struct HiContr* inst);
extern void HiContr_terminate(struct HiContr* inst);

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
 * '<Root>' : 'HiContr'
 * '<S1>'   : 'HiContr/Cyl'
 * '<S2>'   : 'HiContr/Model Info'
 * '<S3>'   : 'HiContr/Cyl/DocBlock'
 * '<S4>'   : 'HiContr/Cyl/GICounter1'
 * '<S5>'   : 'HiContr/Cyl/GlowIgn Integrator'
 * '<S6>'   : 'HiContr/Cyl/Misifire Integrator1'
 * '<S7>'   : 'HiContr/Cyl/Model Info'
 * '<S8>'   : 'HiContr/Cyl/MovingAverage and StdDev'
 * '<S9>'   : 'HiContr/Cyl/Saturation Dynamic1'
 * '<S10>'  : 'HiContr/Cyl/Saturation Dynamic2'
 * '<S11>'  : 'HiContr/Cyl/Saturation Dynamic3'
 * '<S12>'  : 'HiContr/Cyl/Saturation Dynamic4'
 * '<S13>'  : 'HiContr/Cyl/Saturation Dynamic5'
 * '<S14>'  : 'HiContr/Cyl/Threshold'
 * '<S15>'  : 'HiContr/Cyl/Threshold2'
 * '<S16>'  : 'HiContr/Cyl/Threshold3'
 * '<S17>'  : 'HiContr/Cyl/Threshold4'
 * '<S18>'  : 'HiContr/Cyl/Threshold5'
 * '<S19>'  : 'HiContr/Cyl/Threshold6'
 * '<S20>'  : 'HiContr/Cyl/Threshold7'
 * '<S21>'  : 'HiContr/Cyl/Weak Combustion Integrator'
 */
#endif                                 /* RTW_HEADER_HiContr_h_ */
