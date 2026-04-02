/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SAFI_VCD
 * File: SAFI_VCD.h
 * Author: 105055527
 * Last modified by: andreme00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Thu Sep 10 09:08:42 2020
 * Model Version: 1.04
 * Description: Post processing algorithm of the SAFI 2 KLS valve closure timing detection feature.

   Outstandings:
   -------------
   - NA
 * modified Comment: V1.00  31.01.2019  Andre   Generated
   V1.01  20.03.2019  Arnold  Generate reusable code
   V1.02  19.03.2020  Andre   Added detection of the 2nd highest peak for unbalanced valve detection (Development version)
   V1.03  31.07.2020  Andre   Corrected unbalance valve detection. Added reset.
   V1.04  10.09.2020  Andre   Do not fill up the VecVC array with value within first degrees of window. Use the min detection percentage on both peaks.
 ********************************************************************
 * Header for program SAFI_VCD
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.2.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_SAFI_VCD_h_
#define RTW_HEADER_SAFI_VCD_h_
#include <math.h>
#include <string.h>
#ifndef SAFI_VCD_COMMON_INCLUDES_
# define SAFI_VCD_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* SAFI_VCD_COMMON_INCLUDES_ */

#include "SAFI_VCD_types.h"
#include "lSAFI_VCD.h"
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

/* Block signals for system '<Root>/FindVC' */

/* Block states (default storage) for system '<Root>/FindVC' */

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* External inputs (root inport signals with default storage) */

/* External outputs (root outports fed by signals with default storage) */

/* Real-time Model Data Structure */

/* Model entry point functions */
extern void SAFI_VCD_initialize(RT_MODEL_SAFI_VCD *const SAFI_VCD_M, struct fSAFI_VCD* inst);
extern void SAFI_VCD_step(RT_MODEL_SAFI_VCD *const SAFI_VCD_M, struct fSAFI_VCD* inst);
extern void SAFI_VCD_terminate(RT_MODEL_SAFI_VCD *const SAFI_VCD_M, struct fSAFI_VCD* inst);

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
 * '<Root>' : 'SAFI_VCD'
 * '<S1>'   : 'SAFI_VCD/Environment Controller'
 * '<S2>'   : 'SAFI_VCD/Environment Controller1'
 * '<S3>'   : 'SAFI_VCD/FindVC'
 * '<S4>'   : 'SAFI_VCD/Info'
 */
#endif                                 /* RTW_HEADER_SAFI_VCD_h_ */
