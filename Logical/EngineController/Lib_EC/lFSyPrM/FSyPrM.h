/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: FSyPrM
 * File: FSyPrM.h
 * Author: 105055527
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Mon Jan 25 17:32:20 2021
 * Model Version: 0.08
 * Description: Fast synchronization controller for pre-mixed engines.

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    30.03.2020    Schmidt,   project/controller carryover from FSync to FSyncPrM
   V0.02    02.04.2020    Schmidt,   cleanup and deletion of functions not used by pre-mixed engines
   V0.03    12.05.2020    Schmidt,   upgrade to MATLAB/SIMULINK R2020a
   V0.04    14.05.2020    Schmidt,   B&R blocks upgrade to AS Target v6.2.0 (officially supports MATLAB 2020a)
   V0.05    03.08.2020    Schmidt,   changed speed reference for function activation from nominal speed (parameter) to bus bar frequency
   added detection for speed exceedance --> switch over to standard idle controller
   V0.06    04.08.2020    Schmidt,   moved function activation from PARA bus to IN bus
   V0.07    17.08.2020    Schmidt,   included modifications after P6 tests
   V0.08    25.01.2021    Schmidt,   use of frequency based speed set-point (rN_Set) only if rF_MMD_BusBar > 0.5*rF_Nom
 ********************************************************************
 * Header for program FSyPrM
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_FSyPrM_h_
#define RTW_HEADER_FSyPrM_h_
#include <math.h>
#ifndef FSyPrM_COMMON_INCLUDES_
# define FSyPrM_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* FSyPrM_COMMON_INCLUDES_ */

#include "FSyPrM_types.h"
#include "lFSyPrM.h"
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
 * Program:            FSyPrM
 * Author:             schmisi00
 * Created:            25.01.2021 17:32
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Git\FastSync_PreMixed\03_Simulation\FSyPrM.slx
 * Model Version:      0.08
 * Simulink Version:   R2020a
 * B&R Target:         V6.3.1
 * Description:        Fast synchronization controller for pre-mixed engines.
 *
 *                     Outstandings:
 *                     -------------
 *                     - NA
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   schmisi00
 * Last Modified Date: Mon Jan 25 17:31:53 2021
 * Modified Comment:   V0.01    30.03.2020    Schmidt,   project/controller carryover from FSync to FSyncPrM
 *                     V0.02    02.04.2020    Schmidt,   cleanup and deletion of functions not used by pre-mixed engines
 *                     V0.03    12.05.2020    Schmidt,   upgrade to MATLAB/SIMULINK R2020a
 *                     V0.04    14.05.2020    Schmidt,   B&R blocks upgrade to AS Target v6.2.0 (officially supports MATLAB 2020a)
 *                     V0.05    03.08.2020    Schmidt,   changed speed reference for function activation from nominal speed (parameter) to bus bar frequency
 *                                                                          added detection for speed exceedance --> switch over to standard idle controller
 *                     V0.06    04.08.2020    Schmidt,   moved function activation from PARA bus to IN bus
 *                     V0.07    17.08.2020    Schmidt,   included modifications after P6 tests
 *                     V0.08    25.01.2021    Schmidt,   use of frequency based speed set-point (rN_Set) only if rF_MMD_BusBar > 0.5*rF_Nom
 ****************************************************************************************************/

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* External inputs (root inport signals with default storage) */

/* External outputs (root outports fed by signals with default storage) */

/* Real-time Model Data Structure */

/* Model entry point functions */
extern void FSyPrM_initialize(RT_MODEL_FSyPrM *const FSyPrM_M, struct fFSyPrM* inst);
extern void FSyPrM_step(RT_MODEL_FSyPrM *const FSyPrM_M, struct fFSyPrM* inst);
extern void FSyPrM_terminate(RT_MODEL_FSyPrM *const FSyPrM_M, struct fFSyPrM* inst);

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
 * '<Root>' : 'FSyPrM'
 * '<S1>'   : 'FSyPrM/EngSpeedGradient'
 * '<S2>'   : 'FSyPrM/Environment Controller3'
 * '<S3>'   : 'FSyPrM/Environment Controller4'
 * '<S4>'   : 'FSyPrM/Environment Controller5'
 * '<S5>'   : 'FSyPrM/FSyncITPCtrl'
 * '<S6>'   : 'FSyPrM/Info'
 * '<S7>'   : 'FSyPrM/Skipfire_active'
 * '<S8>'   : 'FSyPrM/Time2Sample'
 * '<S9>'   : 'FSyPrM/ValueSelect'
 * '<S10>'  : 'FSyPrM/EngSpeedGradient/Filter'
 * '<S11>'  : 'FSyPrM/EngSpeedGradient/Filter1'
 * '<S12>'  : 'FSyPrM/EngSpeedGradient/Filter/Divisor'
 * '<S13>'  : 'FSyPrM/EngSpeedGradient/Filter/Divisor/Data Type Conversion Inherited'
 * '<S14>'  : 'FSyPrM/EngSpeedGradient/Filter1/Divisor'
 * '<S15>'  : 'FSyPrM/EngSpeedGradient/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S16>'  : 'FSyPrM/ValueSelect/Divisor'
 * '<S17>'  : 'FSyPrM/ValueSelect/Divisor1'
 * '<S18>'  : 'FSyPrM/ValueSelect/Filter'
 * '<S19>'  : 'FSyPrM/ValueSelect/Divisor/Data Type Conversion Inherited'
 * '<S20>'  : 'FSyPrM/ValueSelect/Divisor1/Data Type Conversion Inherited'
 * '<S21>'  : 'FSyPrM/ValueSelect/Filter/Divisor'
 * '<S22>'  : 'FSyPrM/ValueSelect/Filter/Divisor/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_FSyPrM_h_ */
