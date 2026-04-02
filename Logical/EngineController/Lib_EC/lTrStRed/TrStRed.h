/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: TrStRed
 * File: TrStRed.h
 * Author: 105055527
 * Last modified by: maranen00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Mon Dec 06 12:59:10 2021
 * Model Version: 0.3.0
 * Description: Thermal reactor start time reduction function

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.1.0 18.05.2021 Maran   TrStRed function first draft
   V0.1.1 27.05.2021 Maran   added limitation based on cyl. EG max temp. above setpoint
   V0.1.2 02.08.2021 Maran   added half load factor for function limit range
   V0.2.0 15.11.2021 Maran   added saturation limits to control error for the closed loop integrator (PERM parameters)
   V0.3.0 06.12.2021 Maran   removed unused logic in controller block; added filtered value of monitoring variables in debug interface
 ********************************************************************
 * Header for program TrStRed
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_TrStRed_h_
#define RTW_HEADER_TrStRed_h_
#include <math.h>
#ifndef TrStRed_COMMON_INCLUDES_
# define TrStRed_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "zero_crossing_types.h"
#endif                                 /* TrStRed_COMMON_INCLUDES_ */

#include "TrStRed_types.h"
#include "lTrStRed.h"
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

#ifndef rtmGetPrevZCSigState
# define rtmGetPrevZCSigState(rtm)     ((rtm)->prevZCSigState)
#endif

#ifndef rtmSetPrevZCSigState
# define rtmSetPrevZCSigState(rtm, val) ((rtm)->prevZCSigState = (val))
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
 * Program:            TrStRed
 * Author:             maranen00
 * Created:            06.12.2021 12:59
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Git\Cl-Air_start_time_reduction\02_Modeling_and_Auto-code_generation\TrStRed.slx
 * Model Version:      0.3.0
 * Simulink Version:   R2020a
 * B&R Target:         V6.3.1
 * Description:        Thermal reactor start time reduction function
 *
 *                     Outstandings:
 *                     -------------
 *                     - NA
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   maranen00
 * Last Modified Date: Mon Dec 06 12:55:28 2021
 * Modified Comment:   V0.1.0 18.05.2021 Maran   TrStRed function first draft
 *                     V0.1.1 27.05.2021 Maran   added limitation based on cyl. EG max temp. above setpoint
 *                     V0.1.2 02.08.2021 Maran   added half load factor for function limit range
 *                     V0.2.0 15.11.2021 Maran   added saturation limits to control error for the closed loop integrator (PERM parameters)
 *                     V0.3.0 06.12.2021 Maran   removed unused logic in controller block; added filtered value of monitoring variables in debug interface
 ****************************************************************************************************/

/* Block signals for system '<S6>/Filter' */

/* Block states (default storage) for system '<S6>/Filter' */

/* Block signals for system '<S8>/TON' */

/* Block states (default storage) for system '<S8>/TON' */

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* Zero-crossing (trigger) state */

/* Invariant block signals for system '<S6>/Filter' */

/* Invariant block signals (default storage) */

/* Constant parameters (default storage) */

/* External inputs (root inport signals with default storage) */

/* External outputs (root outports fed by signals with default storage) */

/* Real-time Model Data Structure */

extern const ConstBlockIO_TrStRed TrStRed_ConstB;/* constant block i/o */

/* Constant parameters (default storage) */
extern const ConstParam_TrStRed TrStRed_ConstP;

/* Model entry point functions */
extern void TrStRed_initialize(RT_MODEL_TrStRed *const TrStRed_M, struct fTrStRed* inst);
extern void TrStRed_step(RT_MODEL_TrStRed *const TrStRed_M, struct fTrStRed* inst);
extern void TrStRed_terminate(RT_MODEL_TrStRed *const TrStRed_M, struct fTrStRed* inst);

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
 * '<Root>' : 'TrStRed'
 * '<S1>'   : 'TrStRed/Ctrl'
 * '<S2>'   : 'TrStRed/Environment Controller'
 * '<S3>'   : 'TrStRed/Environment Controller1'
 * '<S4>'   : 'TrStRed/Environment Controller2'
 * '<S5>'   : 'TrStRed/Info'
 * '<S6>'   : 'TrStRed/Limitation'
 * '<S7>'   : 'TrStRed/Saturation Dynamic'
 * '<S8>'   : 'TrStRed/SteadyState'
 * '<S9>'   : 'TrStRed/TrStRed_started'
 * '<S10>'  : 'TrStRed/TrStRed_stopping'
 * '<S11>'  : 'TrStRed/Limitation/Divisor'
 * '<S12>'  : 'TrStRed/Limitation/Divisor1'
 * '<S13>'  : 'TrStRed/Limitation/Divisor3'
 * '<S14>'  : 'TrStRed/Limitation/Divisor4'
 * '<S15>'  : 'TrStRed/Limitation/Divisor5'
 * '<S16>'  : 'TrStRed/Limitation/Divisor6'
 * '<S17>'  : 'TrStRed/Limitation/Filter'
 * '<S18>'  : 'TrStRed/Limitation/Filter1'
 * '<S19>'  : 'TrStRed/Limitation/Saturation Dynamic'
 * '<S20>'  : 'TrStRed/Limitation/rateLimit'
 * '<S21>'  : 'TrStRed/Limitation/rateLimit1'
 * '<S22>'  : 'TrStRed/Limitation/Divisor/Data Type Conversion Inherited'
 * '<S23>'  : 'TrStRed/Limitation/Divisor1/Data Type Conversion Inherited'
 * '<S24>'  : 'TrStRed/Limitation/Divisor3/Data Type Conversion Inherited'
 * '<S25>'  : 'TrStRed/Limitation/Divisor4/Data Type Conversion Inherited'
 * '<S26>'  : 'TrStRed/Limitation/Divisor5/Data Type Conversion Inherited'
 * '<S27>'  : 'TrStRed/Limitation/Divisor6/Data Type Conversion Inherited'
 * '<S28>'  : 'TrStRed/Limitation/Filter/Divisor'
 * '<S29>'  : 'TrStRed/Limitation/Filter/Divisor/Data Type Conversion Inherited'
 * '<S30>'  : 'TrStRed/Limitation/Filter1/Divisor'
 * '<S31>'  : 'TrStRed/Limitation/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S32>'  : 'TrStRed/Limitation/rateLimit/Saturation Dynamic'
 * '<S33>'  : 'TrStRed/Limitation/rateLimit1/Saturation Dynamic'
 * '<S34>'  : 'TrStRed/SteadyState/TON'
 * '<S35>'  : 'TrStRed/SteadyState/TON/Data Type Conversion Inherited'
 * '<S36>'  : 'TrStRed/TrStRed_started/S-R Flip-Flop'
 * '<S37>'  : 'TrStRed/TrStRed_started/S-R Flip-Flop1'
 * '<S38>'  : 'TrStRed/TrStRed_stopping/S-R Flip-Flop'
 * '<S39>'  : 'TrStRed/TrStRed_stopping/TON'
 * '<S40>'  : 'TrStRed/TrStRed_stopping/TON/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_TrStRed_h_ */
