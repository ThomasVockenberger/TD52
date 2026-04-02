/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: J920_fric
 * File: J920_fric.h
 * Author: 212348321
 * Created: Mon Jun 13 15:26:38 2016
 ********************************************************************
 * Header for program J920_fric
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_J920_fric_h_
#define RTW_HEADER_J920_fric_h_
#ifndef J920_fric_COMMON_INCLUDES_
# define J920_fric_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* J920_fric_COMMON_INCLUDES_ */

#include "J920_fric_types.h"
#include "lFricIMEP.h"

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

/* Block signals for system '<S12>/TON' */

/* Block states (auto storage) for system '<S12>/TON' */

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Model entry point functions */
extern void J920_fric_initialize(DW_J920_fric *J920_fric_DW, struct fFricIMEP* inst);
extern void J920_fric_step(B_J920_fric *J920_fric_B, DW_J920_fric *J920_fric_DW,
  ExtY_J920_fric *J920_fric_Y, struct fFricIMEP* inst);
extern void J920_fric_terminate(struct fFricIMEP* inst);

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
 * '<Root>' : 'J920_fric'
 * '<S1>'   : 'J920_fric/Environment Controller'
 * '<S2>'   : 'J920_fric/Environment Controller1'
 * '<S3>'   : 'J920_fric/IMEP_Based_Fric_Detection'
 * '<S4>'   : 'J920_fric/Info'
 * '<S5>'   : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic'
 * '<S6>'   : 'J920_fric/IMEP_Based_Fric_Detection/Fault Detection'
 * '<S7>'   : 'J920_fric/IMEP_Based_Fric_Detection/Friction Power Estimation '
 * '<S8>'   : 'J920_fric/IMEP_Based_Fric_Detection/IMEP_Averaging'
 * '<S9>'   : 'J920_fric/IMEP_Based_Fric_Detection/Kinetic energy'
 * '<S10>'  : 'J920_fric/IMEP_Based_Fric_Detection/PMEP'
 * '<S11>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Current monitoring'
 * '<S12>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion'
 * '<S13>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/LimpHome status monitoring'
 * '<S14>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Load step detection'
 * '<S15>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Power theshold'
 * '<S16>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring'
 * '<S17>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Wastegate monitoring'
 * '<S18>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change GCB'
 * '<S19>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change MCB'
 * '<S20>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/TON'
 * '<S21>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change GCB/Detect Fall Nonpositive'
 * '<S22>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change GCB/Detect Rise Positive'
 * '<S23>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change GCB/Detect Fall Nonpositive/Nonpositive'
 * '<S24>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change GCB/Detect Rise Positive/Positive'
 * '<S25>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change MCB/Detect Fall Nonpositive'
 * '<S26>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change MCB/Detect Rise Positive'
 * '<S27>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change MCB/Detect Fall Nonpositive/Nonpositive'
 * '<S28>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/State Change MCB/Detect Rise Positive/Positive'
 * '<S29>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/External disturbtion/TON/Data Type Conversion Inherited'
 * '<S30>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Load step detection/TON'
 * '<S31>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Load step detection/TON/Data Type Conversion Inherited'
 * '<S32>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Power theshold/Power filter'
 * '<S33>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring/TON'
 * '<S34>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring/voltage phase 1'
 * '<S35>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring/voltage phase 2'
 * '<S36>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring/voltage phase 3'
 * '<S37>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring/TON/Data Type Conversion Inherited'
 * '<S38>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring/voltage phase 1/filter'
 * '<S39>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring/voltage phase 2/filter'
 * '<S40>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Voltage monitoring/voltage phase 3/filter'
 * '<S41>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Wastegate monitoring/TON'
 * '<S42>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Wastegate monitoring/filter'
 * '<S43>'  : 'J920_fric/IMEP_Based_Fric_Detection/Activation logic/Wastegate monitoring/TON/Data Type Conversion Inherited'
 * '<S44>'  : 'J920_fric/IMEP_Based_Fric_Detection/Fault Detection/Fast - Filter'
 * '<S45>'  : 'J920_fric/IMEP_Based_Fric_Detection/Fault Detection/Slow - Filter'
 * '<S46>'  : 'J920_fric/IMEP_Based_Fric_Detection/Fault Detection/movAvg J920'
 * '<S47>'  : 'J920_fric/IMEP_Based_Fric_Detection/Friction Power Estimation /Pmech Cal'
 * '<S48>'  : 'J920_fric/IMEP_Based_Fric_Detection/Friction Power Estimation /Pmech Cal/Divisor'
 * '<S49>'  : 'J920_fric/IMEP_Based_Fric_Detection/Friction Power Estimation /Pmech Cal/Filter'
 * '<S50>'  : 'J920_fric/IMEP_Based_Fric_Detection/Friction Power Estimation /Pmech Cal/Divisor/Data Type Conversion Inherited'
 * '<S51>'  : 'J920_fric/IMEP_Based_Fric_Detection/Friction Power Estimation /Pmech Cal/Filter/Divisor'
 * '<S52>'  : 'J920_fric/IMEP_Based_Fric_Detection/Friction Power Estimation /Pmech Cal/Filter/Divisor/Data Type Conversion Inherited'
 * '<S53>'  : 'J920_fric/IMEP_Based_Fric_Detection/IMEP_Averaging/IMEP validation layer'
 * '<S54>'  : 'J920_fric/IMEP_Based_Fric_Detection/IMEP_Averaging/MIsfireCorr'
 * '<S55>'  : 'J920_fric/IMEP_Based_Fric_Detection/IMEP_Averaging/Nr. of valid cylinder'
 * '<S56>'  : 'J920_fric/IMEP_Based_Fric_Detection/IMEP_Averaging/MIsfireCorr/Compare To Constant'
 */
#endif                                 /* RTW_HEADER_J920_fric_h_ */
