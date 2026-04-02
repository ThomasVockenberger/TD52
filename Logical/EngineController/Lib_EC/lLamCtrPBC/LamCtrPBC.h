/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: LamCtrPBC
 * File: LamCtrPBC.h
 * Author: kafkama00
 * Last modified by: kafkama00
 * Created: Mon Oct 11 17:08:29 2021
 * Last modified: Wed Dec 01 09:46:51 2021
 * Model Version: 1.00
 * Description: Lambda controller for pressure based control engines
 * modified Comment: V0.01 11.10.2021 created for first tests
   V0.02 12.10.2021 added debug signals
   V0.03 17.11.2021 added distortion rejection
   V1.00 01.12.2021 remove distortion rejection, serial release DIA.NE V4.11
 ********************************************************************
 * Header for program LamCtrPBC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_LamCtrPBC_h_
#define RTW_HEADER_LamCtrPBC_h_
#include <math.h>
#include <string.h>
#ifndef LamCtrPBC_COMMON_INCLUDES_
# define LamCtrPBC_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "zero_crossing_types.h"
#endif                                 /* LamCtrPBC_COMMON_INCLUDES_ */

#include "LamCtrPBC_types.h"
#include "lLamCtrPBC.h"
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
 * Program:            LamCtrPBC
 * Author:             kafkama00
 * Created:            01.12.2021 09:46
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Users\kafkama00\Documents\Git\LamCtrPBC\LamCtrPBC.slx
 * Model Version:      1.00
 * Simulink Version:   R2020a
 * B&R Target:         V6.4.1
 * Description:        Lambda controller for pressure based control engines
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   kafkama00
 * Last Modified Date: Wed Dec 01 09:46:42 2021
 * Modified Comment:   V0.01 11.10.2021 created for first tests
 *                     V0.02 12.10.2021 added debug signals
 *                     V0.03 17.11.2021 added distortion rejection
 *                     V1.00 01.12.2021 remove distortion rejection, serial release DIA.NE V4.11
 ****************************************************************************************************/

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* Zero-crossing (trigger) state */

/* Invariant block signals (default storage) */

/* External inputs (root inport signals with default storage) */

/* External outputs (root outports fed by signals with default storage) */

/* Real-time Model Data Structure */

/* External data declarations for dependent source files */
extern const LamCtrPBC_IN_Bus LamCtrPBC_rtZLamCtrPBC_IN_Bus;/* LamCtrPBC_IN_Bus ground */
extern const LamCtrPBC_PARA_Bus LamCtrPBC_rtZLamCtrPBC_PARA_Bus;/* LamCtrPBC_PARA_Bus ground */
extern const LamCtrPBC_PERM_Bus LamCtrPBC_rtZLamCtrPBC_PERM_Bus;/* LamCtrPBC_PERM_Bus ground */
extern const LamCtrPBC_OUT_Bus LamCtrPBC_rtZLamCtrPBC_OUT_Bus;/* LamCtrPBC_OUT_Bus ground */
extern const LamCtrPBC_DBG_Bus LamCtrPBC_rtZLamCtrPBC_DBG_Bus;/* LamCtrPBC_DBG_Bus ground */
extern const ConstBlockIO_LamCtrPBC LamCtrPBC_ConstB;/* constant block i/o */

/* Model entry point functions */
extern void LamCtrPBC_initialize(RT_MODEL_LamCtrPBC *const LamCtrPBC_M, struct fLamCtrPBC* inst);
extern void LamCtrPBC_step(RT_MODEL_LamCtrPBC *const LamCtrPBC_M, struct fLamCtrPBC* inst);
extern void LamCtrPBC_terminate(RT_MODEL_LamCtrPBC *const LamCtrPBC_M, struct fLamCtrPBC* inst);

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
 * '<Root>' : 'LamCtrPBC'
 * '<S1>'   : 'LamCtrPBC/Environment Controller'
 * '<S2>'   : 'LamCtrPBC/Environment Controller1'
 * '<S3>'   : 'LamCtrPBC/Environment Controller2'
 * '<S4>'   : 'LamCtrPBC/Filter2'
 * '<S5>'   : 'LamCtrPBC/Info'
 * '<S6>'   : 'LamCtrPBC/Saturation Dynamic'
 * '<S7>'   : 'LamCtrPBC/Filter2/Divisor'
 * '<S8>'   : 'LamCtrPBC/Filter2/Divisor/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_LamCtrPBC_h_ */
