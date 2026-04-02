/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SCRT_ss
 * File: SCRT_ss.h
 * Author: 105055527
 * Last modified by: arnolge00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Fri Oct 01 08:40:23 2021
 * Model Version: 1.00
 * Description: Steady state detection for SCR inlet temperature controller vie ignition timing

   Outstandings:
   -------------
   - NA
 * modified Comment: V1.00  01.10.2021, Arnold, created
 ********************************************************************
 * Header for program SCRT_ss
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_SCRT_ss_h_
#define RTW_HEADER_SCRT_ss_h_
#include <math.h>
#ifndef SCRT_ss_COMMON_INCLUDES_
# define SCRT_ss_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* SCRT_ss_COMMON_INCLUDES_ */

#include "SCRT_ss_types.h"
#include "lSCRT_ss.h"
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
 * Program:            Demo
 * Author:             arnolge00
 * Created:            03.04.2020 22:15
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Users\arnolge00\Documents\MATLAB\Demo\Demo.slx
 * Model Version:      1.01
 * Simulink Version:   R2018b
 * B&R Target:         V6.1.0
 * Description:        Demo Version of two filters with additional signal quality check
 *
 *                     Outstandings:
 *                     -------------
 *                     - NA
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   arnolge00
 * Last Modified Date: Fri Apr 03 22:06:49 2020
 * Modified Comment:   V1.00  18.09.2018 Arnold   created for training
 *                     V1.01  19.09.2018 Arnold   test
 ****************************************************************************************************/

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* External inputs (root inport signals with default storage) */

/* External outputs (root outports fed by signals with default storage) */

/* Real-time Model Data Structure */

/* Model entry point functions */
extern void SCRT_ss_initialize(RT_MODEL_SCRT_ss *const SCRT_ss_M, struct fSCRT_ss* inst);
extern void SCRT_ss_step(RT_MODEL_SCRT_ss *const SCRT_ss_M, struct fSCRT_ss* inst);
extern void SCRT_ss_terminate(RT_MODEL_SCRT_ss *const SCRT_ss_M, struct fSCRT_ss* inst);

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
 * '<Root>' : 'SCRT_ss'
 * '<S1>'   : 'SCRT_ss/Environment Controller'
 * '<S2>'   : 'SCRT_ss/Environment Controller2'
 * '<S3>'   : 'SCRT_ss/Info'
 * '<S4>'   : 'SCRT_ss/SteadyState'
 * '<S5>'   : 'SCRT_ss/SteadyState/Filter'
 * '<S6>'   : 'SCRT_ss/SteadyState/Filter1'
 * '<S7>'   : 'SCRT_ss/SteadyState/TON'
 * '<S8>'   : 'SCRT_ss/SteadyState/Filter/Divisor'
 * '<S9>'   : 'SCRT_ss/SteadyState/Filter/Divisor/Data Type Conversion Inherited'
 * '<S10>'  : 'SCRT_ss/SteadyState/Filter1/Divisor'
 * '<S11>'  : 'SCRT_ss/SteadyState/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S12>'  : 'SCRT_ss/SteadyState/TON/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_SCRT_ss_h_ */
