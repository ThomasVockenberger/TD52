/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PCGVmon
 * File: PCGVmon.h
 * Author: 105055527
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Thu Nov 26 09:45:08 2020
 * Model Version: 0.03
 * Description: Pre-chamber gas valve monitoring (sticking detection).

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    22.09.2020    Schmidt,   created initial model
   V0.02    15.10.2020    Schmidt,   modifications after code review / unit testing
   V0.03    26.11.2020    Schmidt,   perm's for class borders (no-hardcoded borders)
 ********************************************************************
 * Header for program PCGVmon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.2.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_PCGVmon_h_
#define RTW_HEADER_PCGVmon_h_
#include <math.h>
#include <string.h>
#ifndef PCGVmon_COMMON_INCLUDES_
# define PCGVmon_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* PCGVmon_COMMON_INCLUDES_ */

#include "PCGVmon_types.h"
#include "lPCGVmon.h"
/* Beginning of Dynamic TypeDefs: */
/* End of Dynamic TypeDefs: */
#ifndef MIN
#define MIN(a,b)	((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)	((a) > (b) ? (a) : (b))
#endif

#ifndef AST_ROUND
#define AST_ROUND(x) ((x)>=0?(long long)((x)+0.5):(long long)((x)-0.5))
#endif

#include "rt_defines.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetBlockIO
# define rtmGetBlockIO(rtm)            ((rtm)->blockIO)
#endif

#ifndef rtmSetBlockIO
# define rtmSetBlockIO(rtm, val)       ((rtm)->blockIO = (val))
#endif

#ifndef rtmGetRootDWork
# define rtmGetRootDWork(rtm)          ((rtm)->dwork)
#endif

#ifndef rtmSetRootDWork
# define rtmSetRootDWork(rtm, val)     ((rtm)->dwork = (val))
#endif

#ifndef rtmGetU
# define rtmGetU(rtm)                  ((rtm)->inputs)
#endif

#ifndef rtmSetU
# define rtmSetU(rtm, val)             ((rtm)->inputs = (val))
#endif

#ifndef rtmGetY
# define rtmGetY(rtm)                  ((rtm)->outputs)
#endif

#ifndef rtmSetY
# define rtmSetY(rtm, val)             ((rtm)->outputs = (val))
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

#ifndef AST_ROUND
#define AST_ROUND(x)                   ((x)>=0?(long long)((x)+0.5):(long long)((x)-0.5))
#endif

/* user code (top of header file) */
/***************************************************************************************************
 * COPYRIGHT -- INNIO Jenbacher GmbH & CO OG
 ****************************************************************************************************
 * Program:            PCGVmon
 * Author:             schmisi00
 * Created:            26.11.2020 09:45
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Git\PCGVmonitoring\Simulation\PCGVmon.slx
 * Model Version:      0.03
 * Simulink Version:   R2020a
 * B&R Target:         V6.2.0
 * Description:        Pre-chamber gas valve monitoring (sticking detection).
 *
 *                     Outstandings:
 *                     -------------
 *                     - NA
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   schmisi00
 * Last Modified Date: Thu Nov 26 09:03:53 2020
 * Modified Comment:   V0.01    22.09.2020    Schmidt,   created initial model
 *                     V0.02    15.10.2020    Schmidt,   modifications after code review / unit testing
 *                     V0.03    26.11.2020    Schmidt,   perm's for class borders (no-hardcoded borders)
 ****************************************************************************************************/

/* Block signals for system '<S4>/setZero' */

/* Block signals for system '<S5>/TON' */

/* Block states (default storage) for system '<S5>/TON' */

/* Block signals for system '<S7>/MATLAB Function' */

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* External inputs (root inport signals with default storage) */

/* External outputs (root outports fed by signals with default storage) */

/* Real-time Model Data Structure */

/* Model entry point functions */
extern void PCGVmon_initialize(RT_MODEL_PCGVmon *const PCGVmon_M, struct fPCGVmon* inst);
extern void PCGVmon_step(RT_MODEL_PCGVmon *const PCGVmon_M, struct fPCGVmon* inst);
extern void PCGVmon_terminate(RT_MODEL_PCGVmon *const PCGVmon_M, struct fPCGVmon* inst);

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
 * '<Root>' : 'PCGVmon'
 * '<S1>'   : 'PCGVmon/Environment Controller'
 * '<S2>'   : 'PCGVmon/Environment Controller1'
 * '<S3>'   : 'PCGVmon/Info'
 * '<S4>'   : 'PCGVmon/Subsystem'
 * '<S5>'   : 'PCGVmon/Subsystem1'
 * '<S6>'   : 'PCGVmon/Subsystem2'
 * '<S7>'   : 'PCGVmon/Subsystem3'
 * '<S8>'   : 'PCGVmon/Subsystem4'
 * '<S9>'   : 'PCGVmon/Subsystem/Filter'
 * '<S10>'  : 'PCGVmon/Subsystem/Filter1'
 * '<S11>'  : 'PCGVmon/Subsystem/Filter4'
 * '<S12>'  : 'PCGVmon/Subsystem/Filter5'
 * '<S13>'  : 'PCGVmon/Subsystem/median'
 * '<S14>'  : 'PCGVmon/Subsystem/median3'
 * '<S15>'  : 'PCGVmon/Subsystem/reset'
 * '<S16>'  : 'PCGVmon/Subsystem/setZero'
 * '<S17>'  : 'PCGVmon/Subsystem/setZero1'
 * '<S18>'  : 'PCGVmon/Subsystem/Filter/Divisor'
 * '<S19>'  : 'PCGVmon/Subsystem/Filter/Divisor/Data Type Conversion Inherited'
 * '<S20>'  : 'PCGVmon/Subsystem/Filter1/Divisor'
 * '<S21>'  : 'PCGVmon/Subsystem/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S22>'  : 'PCGVmon/Subsystem/Filter4/Divisor'
 * '<S23>'  : 'PCGVmon/Subsystem/Filter4/Divisor/Data Type Conversion Inherited'
 * '<S24>'  : 'PCGVmon/Subsystem/Filter5/Divisor'
 * '<S25>'  : 'PCGVmon/Subsystem/Filter5/Divisor/Data Type Conversion Inherited'
 * '<S26>'  : 'PCGVmon/Subsystem1/TON'
 * '<S27>'  : 'PCGVmon/Subsystem1/TON1'
 * '<S28>'  : 'PCGVmon/Subsystem1/stdDev1'
 * '<S29>'  : 'PCGVmon/Subsystem1/TON/Data Type Conversion Inherited'
 * '<S30>'  : 'PCGVmon/Subsystem1/TON1/Data Type Conversion Inherited'
 * '<S31>'  : 'PCGVmon/Subsystem2/MATLAB Function1'
 * '<S32>'  : 'PCGVmon/Subsystem2/MATLAB Function2'
 * '<S33>'  : 'PCGVmon/Subsystem2/MATLAB Function3'
 * '<S34>'  : 'PCGVmon/Subsystem2/TON2'
 * '<S35>'  : 'PCGVmon/Subsystem2/setZero'
 * '<S36>'  : 'PCGVmon/Subsystem2/TON2/Data Type Conversion Inherited'
 * '<S37>'  : 'PCGVmon/Subsystem3/Detect Decrease1'
 * '<S38>'  : 'PCGVmon/Subsystem3/Divisor'
 * '<S39>'  : 'PCGVmon/Subsystem3/MATLAB Function'
 * '<S40>'  : 'PCGVmon/Subsystem3/MATLAB Function1'
 * '<S41>'  : 'PCGVmon/Subsystem3/MATLAB Function10'
 * '<S42>'  : 'PCGVmon/Subsystem3/MATLAB Function2'
 * '<S43>'  : 'PCGVmon/Subsystem3/MATLAB Function3'
 * '<S44>'  : 'PCGVmon/Subsystem3/MATLAB Function4'
 * '<S45>'  : 'PCGVmon/Subsystem3/MATLAB Function5'
 * '<S46>'  : 'PCGVmon/Subsystem3/MATLAB Function6'
 * '<S47>'  : 'PCGVmon/Subsystem3/MATLAB Function7'
 * '<S48>'  : 'PCGVmon/Subsystem3/MATLAB Function8'
 * '<S49>'  : 'PCGVmon/Subsystem3/MATLAB Function9'
 * '<S50>'  : 'PCGVmon/Subsystem3/Divisor/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_PCGVmon_h_ */
