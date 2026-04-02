/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PUscuff
 * File: PUscuff.h
 * Author: 212442560
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Wed Nov 10 09:52:05 2021
 * Model Version: 0.06
 * Description: PU scuffing detection.

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    17.05.2021    Schmidt,   created initial model
   V0.02    04.08.2021    Schmidt,   model cleanup
   V0.03    31.08.2021    Schmidt,   new version after model/code review (replaced 'Tapped Delay' blocks, para name changes)
   V0.04    09.09.2021    Schmidt,   modifications after P6 validation (parameter cleanup, added trip release delay)
   V0.05    29.09.2021    Schmidt,   added debug outputs (bLearnReactAfterKnock, rP2s_filt_contLearn)
   V0.06    10.11.2021    Schmidt,   knock anomaly det.: filtering probability, threshold change
   IO sample rate corrections (Ts=100ms)
 ********************************************************************
 * Header for program PUscuff
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_PUscuff_h_
#define RTW_HEADER_PUscuff_h_
#include <math.h>
#ifndef PUscuff_COMMON_INCLUDES_
# define PUscuff_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* PUscuff_COMMON_INCLUDES_ */

#include "PUscuff_types.h"
#include "lPUscuff.h"
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
 * Program:            PUscuff
 * Author:             schmisi00
 * Created:            10.11.2021 09:52
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Git\PUscuff_Detection\Simulation\PUscuff.slx
 * Model Version:      0.06
 * Simulink Version:   R2020a
 * B&R Target:         V6.4.1
 * Description:        PU scuffing detection.
 *
 *                     Outstandings:
 *                     -------------
 *                     - NA
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   schmisi00
 * Last Modified Date: Wed Nov 10 09:51:56 2021
 * Modified Comment:   V0.01    17.05.2021    Schmidt,   created initial model
 *                     V0.02    04.08.2021    Schmidt,   model cleanup
 *                     V0.03    31.08.2021    Schmidt,   new version after model/code review (replaced 'Tapped Delay' blocks, para name changes)
 *                     V0.04    09.09.2021    Schmidt,   modifications after P6 validation (parameter cleanup, added trip release delay)
 *                     V0.05    29.09.2021    Schmidt,   added debug outputs (bLearnReactAfterKnock, rP2s_filt_contLearn)
 *                     V0.06    10.11.2021    Schmidt,   knock anomaly det.: filtering probability, threshold change
 *                                                                         IO sample rate corrections (Ts=100ms)
 ****************************************************************************************************/

/* Block signals for system '<S8>/Filter2' */

/* Block states (default storage) for system '<S8>/Filter2' */

/* Block signals for system '<S8>/TON1' */

/* Block states (default storage) for system '<S8>/TON1' */

/* Block signals for system '<S1>/MATLAB Function11' */

/* Block signals for system '<S2>/Filter1' */

/* Block states (default storage) for system '<S2>/Filter1' */

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* Invariant block signals for system '<S8>/Filter2' */

/* Invariant block signals for system '<S2>/Filter1' */

/* Invariant block signals (default storage) */

/* External inputs (root inport signals with default storage) */

/* External outputs (root outports fed by signals with default storage) */

/* Real-time Model Data Structure */

extern const ConstBlockIO_PUscuff PUscuff_ConstB;/* constant block i/o */

/* Model entry point functions */
extern void PUscuff_initialize(RT_MODEL_PUscuff *const PUscuff_M, struct fPUscuff* inst);
extern void PUscuff_step(RT_MODEL_PUscuff *const PUscuff_M, struct fPUscuff* inst);
extern void PUscuff_terminate(RT_MODEL_PUscuff *const PUscuff_M, struct fPUscuff* inst);

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
 * '<Root>' : 'PUscuff'
 * '<S1>'   : 'PUscuff/Activation and Detection Logic'
 * '<S2>'   : 'PUscuff/Crankcase Pressure Learning and Prediction'
 * '<S3>'   : 'PUscuff/Environment Controller'
 * '<S4>'   : 'PUscuff/Environment Controller1'
 * '<S5>'   : 'PUscuff/Info'
 * '<S6>'   : 'PUscuff/Knock Anomaly Detection'
 * '<S7>'   : 'PUscuff/Parameter Plausibility Check'
 * '<S8>'   : 'PUscuff/Activation and Detection Logic/Activation Logic'
 * '<S9>'   : 'PUscuff/Activation and Detection Logic/MATLAB Function11'
 * '<S10>'  : 'PUscuff/Activation and Detection Logic/TOF2'
 * '<S11>'  : 'PUscuff/Activation and Detection Logic/Activation Logic/Filter2'
 * '<S12>'  : 'PUscuff/Activation and Detection Logic/Activation Logic/MATLAB Function14'
 * '<S13>'  : 'PUscuff/Activation and Detection Logic/Activation Logic/TON1'
 * '<S14>'  : 'PUscuff/Activation and Detection Logic/Activation Logic/TON2'
 * '<S15>'  : 'PUscuff/Activation and Detection Logic/Activation Logic/Filter2/Divisor'
 * '<S16>'  : 'PUscuff/Activation and Detection Logic/Activation Logic/Filter2/Divisor/Data Type Conversion Inherited'
 * '<S17>'  : 'PUscuff/Activation and Detection Logic/Activation Logic/TON1/Data Type Conversion Inherited'
 * '<S18>'  : 'PUscuff/Activation and Detection Logic/Activation Logic/TON2/Data Type Conversion Inherited'
 * '<S19>'  : 'PUscuff/Activation and Detection Logic/TOF2/Data Type Conversion Inherited'
 * '<S20>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter1'
 * '<S21>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter4'
 * '<S22>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter9'
 * '<S23>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Hysterese'
 * '<S24>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/LearnReactAfterKnock'
 * '<S25>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/MATLAB Function8'
 * '<S26>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/TON1'
 * '<S27>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/TON2'
 * '<S28>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/TON5'
 * '<S29>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter1/Divisor'
 * '<S30>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S31>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter4/Divisor'
 * '<S32>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter4/Divisor/Data Type Conversion Inherited'
 * '<S33>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter9/Divisor'
 * '<S34>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/Filter9/Divisor/Data Type Conversion Inherited'
 * '<S35>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/LearnReactAfterKnock/Detect Rise Positive'
 * '<S36>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/LearnReactAfterKnock/MATLAB Function1'
 * '<S37>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/LearnReactAfterKnock/Detect Rise Positive/Positive'
 * '<S38>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/TON1/Data Type Conversion Inherited'
 * '<S39>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/TON2/Data Type Conversion Inherited'
 * '<S40>'  : 'PUscuff/Crankcase Pressure Learning and Prediction/TON5/Data Type Conversion Inherited'
 * '<S41>'  : 'PUscuff/Knock Anomaly Detection/Filter1'
 * '<S42>'  : 'PUscuff/Knock Anomaly Detection/Filter3'
 * '<S43>'  : 'PUscuff/Knock Anomaly Detection/Filter4'
 * '<S44>'  : 'PUscuff/Knock Anomaly Detection/MATLAB Function'
 * '<S45>'  : 'PUscuff/Knock Anomaly Detection/MATLAB Function2'
 * '<S46>'  : 'PUscuff/Knock Anomaly Detection/MATLAB Function3'
 * '<S47>'  : 'PUscuff/Knock Anomaly Detection/TON'
 * '<S48>'  : 'PUscuff/Knock Anomaly Detection/TON4'
 * '<S49>'  : 'PUscuff/Knock Anomaly Detection/Filter1/Divisor'
 * '<S50>'  : 'PUscuff/Knock Anomaly Detection/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S51>'  : 'PUscuff/Knock Anomaly Detection/Filter3/Divisor'
 * '<S52>'  : 'PUscuff/Knock Anomaly Detection/Filter3/Divisor/Data Type Conversion Inherited'
 * '<S53>'  : 'PUscuff/Knock Anomaly Detection/Filter4/Divisor'
 * '<S54>'  : 'PUscuff/Knock Anomaly Detection/Filter4/Divisor/Data Type Conversion Inherited'
 * '<S55>'  : 'PUscuff/Knock Anomaly Detection/TON/Data Type Conversion Inherited'
 * '<S56>'  : 'PUscuff/Knock Anomaly Detection/TON4/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_PUscuff_h_ */
