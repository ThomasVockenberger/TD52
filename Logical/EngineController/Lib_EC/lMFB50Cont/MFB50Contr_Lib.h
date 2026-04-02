/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: MFB50Contr_Lib
 * File: MFB50Contr_Lib.h
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Header for program MFB50Contr_Lib
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_MFB50Contr_Lib_h_
#define RTW_HEADER_MFB50Contr_Lib_h_
#ifndef MFB50Contr_Lib_COMMON_INCLUDES_
# define MFB50Contr_Lib_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* MFB50Contr_Lib_COMMON_INCLUDES_ */

#include "MFB50Contr_Lib_types.h"
#include "lMFB50Cont.h"

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
extern BlockIO_MFB50Contr_Lib MFB50Contr_Lib_B;

/* Block states (auto storage) */
extern D_Work_MFB50Contr_Lib MFB50Contr_Lib_DWork;

/* Model entry point functions */
extern void MFB50Contr_Lib_initialize(struct MFB50Contr* inst);
extern void MFB50Contr_Lib_step(struct MFB50Contr* inst);
extern void MFB50Contr_Lib_terminate(struct MFB50Contr* inst);

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
 * '<Root>' : 'MFB50Contr_Lib'
 * '<S1>'   : 'MFB50Contr_Lib/1st order Filter2'
 * '<S2>'   : 'MFB50Contr_Lib/Compare To Zero'
 * '<S3>'   : 'MFB50Contr_Lib/MFB50Controller'
 * '<S4>'   : 'MFB50Contr_Lib/MFB50RefCalc'
 * '<S5>'   : 'MFB50Contr_Lib/Median'
 * '<S6>'   : 'MFB50Contr_Lib/Model Info'
 * '<S7>'   : 'MFB50Contr_Lib/PI cntr gain scheduling'
 * '<S8>'   : 'MFB50Contr_Lib/clockGenerator'
 * '<S9>'   : 'MFB50Contr_Lib/param filter p2'
 * '<S10>'  : 'MFB50Contr_Lib/MFB50Controller/MFB50ContrAllCyl'
 * '<S11>'  : 'MFB50Contr_Lib/MFB50Controller/MFB50ContrAllCyl/1st order Filter'
 * '<S12>'  : 'MFB50Contr_Lib/MFB50Controller/MFB50ContrAllCyl/PI controller'
 * '<S13>'  : 'MFB50Contr_Lib/MFB50Controller/MFB50ContrAllCyl/PI controller/PICntr'
 * '<S14>'  : 'MFB50Contr_Lib/MFB50RefCalc/LVRT control'
 * '<S15>'  : 'MFB50Contr_Lib/MFB50RefCalc/T3HPcalc'
 * '<S16>'  : 'MFB50Contr_Lib/PI cntr gain scheduling/P2sCalc'
 */
#endif                                 /* RTW_HEADER_MFB50Contr_Lib_h_ */
