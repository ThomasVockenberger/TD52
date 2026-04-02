/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: HiGlob
 * File: HiGlob.h
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Header for program HiGlob
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_HiGlob_h_
#define RTW_HEADER_HiGlob_h_
#ifndef HiGlob_COMMON_INCLUDES_
# define HiGlob_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* HiGlob_COMMON_INCLUDES_ */

#include "HiGlob_types.h"
#include "lHiGlob.h"

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
extern BlockIO_HiGlob HiGlob_B;

/* Block states (auto storage) */
extern D_Work_HiGlob HiGlob_DWork;

/* Model entry point functions */
extern void HiGlob_initialize(struct HiGlob* inst);
extern void HiGlob_step(struct HiGlob* inst);
extern void HiGlob_terminate(struct HiGlob* inst);

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
 * '<Root>' : HiGlob
 * '<S1>'   : HiGlob/Compare To Zero
 * '<S2>'   : HiGlob/CylSkipped
 * '<S3>'   : HiGlob/Model Info
 * '<S4>'   : HiGlob/PmaxLimitGlobal
 * '<S5>'   : HiGlob/Saturation Dynamic1
 * '<S6>'   : HiGlob/Saturation Dynamic2
 * '<S7>'   : HiGlob/Saturation Dynamic3
 * '<S8>'   : HiGlob/Saturation Dynamic4
 * '<S9>'   : HiGlob/SkipCounter
 * '<S10>'  : HiGlob/SkipCounter1
 * '<S11>'  : HiGlob/threshold
 * '<S12>'  : HiGlob/threshold1
 * '<S13>'  : HiGlob/threshold2
 * '<S14>'  : HiGlob/threshold3
 * '<S15>'  : HiGlob/threshold4
 * '<S16>'  : HiGlob/PmaxLimitGlobal/Compare To threshold
 * '<S17>'  : HiGlob/PmaxLimitGlobal/PmaxLimit Integrator
 * '<S18>'  : HiGlob/PmaxLimitGlobal/Saturation Dynamic
 * '<S19>'  : HiGlob/PmaxLimitGlobal/Saturation Dynamic1
 * '<S20>'  : HiGlob/PmaxLimitGlobal/Saturation Dynamic2
 */
#endif                                 /* RTW_HEADER_HiGlob_h_ */
