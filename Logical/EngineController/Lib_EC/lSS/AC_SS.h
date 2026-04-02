/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_SS
 * File: AC_SS.h
 * Author: 105055527
 * Created: Thu May 19 13:50:06 2016
 ********************************************************************
 * Header for program AC_SS
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V5.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_AC_SS_h_
#define RTW_HEADER_AC_SS_h_
#ifndef AC_SS_COMMON_INCLUDES_
# define AC_SS_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* AC_SS_COMMON_INCLUDES_ */

#include "AC_SS_types.h"
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

/* Block signals for system '<S13>/Filter' */

/* Block states (auto storage) for system '<S13>/Filter' */

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* Invariant block signals for system '<S13>/Filter' */

/* Invariant block signals (auto storage) */

/* Constant parameters (auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Real-time Model Data Structure */

extern const ConstBlockIO_AC_SS AC_SS_ConstB;/* constant block i/o */

/* Constant parameters (auto storage) */
extern const ConstParam_AC_SS AC_SS_ConstP;

/* Model entry point functions */
extern void AC_SS_initialize(D_Work_AC_SS *AC_SS_DWork, struct SS* inst);
extern void AC_SS_step(BlockIO_AC_SS *AC_SS_B, D_Work_AC_SS *AC_SS_DWork,
  ExternalOutputs_AC_SS *AC_SS_Y, struct SS* inst);
extern void AC_SS_terminate(struct SS* inst);

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
 * '<Root>' : 'AC_SS'
 * '<S1>'   : 'AC_SS/Environment Controller'
 * '<S2>'   : 'AC_SS/SS'
 * '<S3>'   : 'AC_SS/SS/SS_IP'
 * '<S4>'   : 'AC_SS/SS/SS_Lam'
 * '<S5>'   : 'AC_SS/SS/SS_N'
 * '<S6>'   : 'AC_SS/SS/SS_P'
 * '<S7>'   : 'AC_SS/SS/SS_P2s'
 * '<S8>'   : 'AC_SS/SS/SS_P_d'
 * '<S9>'   : 'AC_SS/SS/SS_T2s'
 * '<S10>'  : 'AC_SS/SS/SS_T_EG'
 * '<S11>'  : 'AC_SS/SS/SS_IP/SS'
 * '<S12>'  : 'AC_SS/SS/SS_IP/SS/Deviation_comp1'
 * '<S13>'  : 'AC_SS/SS/SS_IP/SS/Slew_rate_comp3'
 * '<S14>'  : 'AC_SS/SS/SS_IP/SS/Slew_rate_comp3/Filter'
 * '<S15>'  : 'AC_SS/SS/SS_IP/SS/Slew_rate_comp3/Filter/Divisor'
 * '<S16>'  : 'AC_SS/SS/SS_IP/SS/Slew_rate_comp3/Filter/Divisor/Data Type Conversion Inherited'
 * '<S17>'  : 'AC_SS/SS/SS_Lam/SS'
 * '<S18>'  : 'AC_SS/SS/SS_Lam/SS/Deviation_comp1'
 * '<S19>'  : 'AC_SS/SS/SS_Lam/SS/Slew_rate_comp3'
 * '<S20>'  : 'AC_SS/SS/SS_Lam/SS/Slew_rate_comp3/Filter'
 * '<S21>'  : 'AC_SS/SS/SS_Lam/SS/Slew_rate_comp3/Filter/Divisor'
 * '<S22>'  : 'AC_SS/SS/SS_Lam/SS/Slew_rate_comp3/Filter/Divisor/Data Type Conversion Inherited'
 * '<S23>'  : 'AC_SS/SS/SS_N/SS'
 * '<S24>'  : 'AC_SS/SS/SS_N/SS/Deviation_comp1'
 * '<S25>'  : 'AC_SS/SS/SS_N/SS/Slew_rate_comp3'
 * '<S26>'  : 'AC_SS/SS/SS_N/SS/Slew_rate_comp3/Filter'
 * '<S27>'  : 'AC_SS/SS/SS_N/SS/Slew_rate_comp3/Filter/Divisor'
 * '<S28>'  : 'AC_SS/SS/SS_N/SS/Slew_rate_comp3/Filter/Divisor/Data Type Conversion Inherited'
 * '<S29>'  : 'AC_SS/SS/SS_P/SS'
 * '<S30>'  : 'AC_SS/SS/SS_P/SS/Deviation_comp1'
 * '<S31>'  : 'AC_SS/SS/SS_P/SS/Slew_rate_comp3'
 * '<S32>'  : 'AC_SS/SS/SS_P/SS/Slew_rate_comp3/Filter'
 * '<S33>'  : 'AC_SS/SS/SS_P/SS/Slew_rate_comp3/Filter/Divisor'
 * '<S34>'  : 'AC_SS/SS/SS_P/SS/Slew_rate_comp3/Filter/Divisor/Data Type Conversion Inherited'
 * '<S35>'  : 'AC_SS/SS/SS_P2s/SS'
 * '<S36>'  : 'AC_SS/SS/SS_P2s/SS/Deviation_comp1'
 * '<S37>'  : 'AC_SS/SS/SS_P2s/SS/Slew_rate_comp3'
 * '<S38>'  : 'AC_SS/SS/SS_P2s/SS/Slew_rate_comp3/Filter'
 * '<S39>'  : 'AC_SS/SS/SS_P2s/SS/Slew_rate_comp3/Filter/Divisor'
 * '<S40>'  : 'AC_SS/SS/SS_P2s/SS/Slew_rate_comp3/Filter/Divisor/Data Type Conversion Inherited'
 * '<S41>'  : 'AC_SS/SS/SS_P_d/SS'
 * '<S42>'  : 'AC_SS/SS/SS_P_d/SS/Deviation_comp1'
 * '<S43>'  : 'AC_SS/SS/SS_P_d/SS/Slew_rate_comp3'
 * '<S44>'  : 'AC_SS/SS/SS_P_d/SS/Slew_rate_comp3/Filter'
 * '<S45>'  : 'AC_SS/SS/SS_P_d/SS/Slew_rate_comp3/Filter/Divisor'
 * '<S46>'  : 'AC_SS/SS/SS_P_d/SS/Slew_rate_comp3/Filter/Divisor/Data Type Conversion Inherited'
 * '<S47>'  : 'AC_SS/SS/SS_T2s/SS'
 * '<S48>'  : 'AC_SS/SS/SS_T2s/SS/Deviation_comp1'
 * '<S49>'  : 'AC_SS/SS/SS_T2s/SS/Slew_rate_comp3'
 * '<S50>'  : 'AC_SS/SS/SS_T2s/SS/Slew_rate_comp3/Filter'
 * '<S51>'  : 'AC_SS/SS/SS_T2s/SS/Slew_rate_comp3/Filter/Divisor'
 * '<S52>'  : 'AC_SS/SS/SS_T2s/SS/Slew_rate_comp3/Filter/Divisor/Data Type Conversion Inherited'
 * '<S53>'  : 'AC_SS/SS/SS_T_EG/SS'
 * '<S54>'  : 'AC_SS/SS/SS_T_EG/SS/Deviation_comp1'
 * '<S55>'  : 'AC_SS/SS/SS_T_EG/SS/Slew_rate_comp3'
 * '<S56>'  : 'AC_SS/SS/SS_T_EG/SS/Slew_rate_comp3/Filter'
 * '<S57>'  : 'AC_SS/SS/SS_T_EG/SS/Slew_rate_comp3/Filter/Divisor'
 * '<S58>'  : 'AC_SS/SS/SS_T_EG/SS/Slew_rate_comp3/Filter/Divisor/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_AC_SS_h_ */
