/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_PFPDR
 * File: AC_PFPDR.h
 * Author: 502423184
 * Created: Fri Apr 24 12:55:11 2015
 ********************************************************************
 * Header for program AC_PFPDR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_AC_PFPDR_h_
#define RTW_HEADER_AC_PFPDR_h_
#ifndef AC_PFPDR_COMMON_INCLUDES_
# define AC_PFPDR_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* AC_PFPDR_COMMON_INCLUDES_ */

#include "AC_PFPDR_types.h"
#include "lPFPDR.h"

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

/* Block signals for system '<S9>/TON' */

/* Block states (auto storage) for system '<S9>/TON' */

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* Model entry point functions */
extern void AC_PFPDR_initialize(struct PFPDR* inst);
extern void AC_PFPDR_step(BlockIO_AC_PFPDR *AC_PFPDR_B, D_Work_AC_PFPDR
  *AC_PFPDR_DWork, struct PFPDR* inst);
extern void AC_PFPDR_terminate(struct PFPDR* inst);

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
 * '<Root>' : 'AC_PFPDR'
 * '<S1>'   : 'AC_PFPDR/SimuBlock'
 * '<S2>'   : 'AC_PFPDR/SimuBlock/PFPDR_Autocode'
 * '<S3>'   : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/Environment Controller'
 * '<S4>'   : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/Environment Controller1'
 * '<S5>'   : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR'
 * '<S6>'   : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Abort Conditions'
 * '<S7>'   : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Chart (MATLAB)'
 * '<S8>'   : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Hysterese'
 * '<S9>'   : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Time Delay'
 * '<S10>'  : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Abort Conditions/Abort Condition 1'
 * '<S11>'  : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Abort Conditions/Abort Condition 2'
 * '<S12>'  : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Abort Conditions/Abort Condition 3'
 * '<S13>'  : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Time Delay/TON'
 * '<S14>'  : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Time Delay/TON1'
 * '<S15>'  : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Time Delay/TON/Data Type Conversion Inherited'
 * '<S16>'  : 'AC_PFPDR/SimuBlock/PFPDR_Autocode/PFPDR/Time Delay/TON1/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_AC_PFPDR_h_ */
