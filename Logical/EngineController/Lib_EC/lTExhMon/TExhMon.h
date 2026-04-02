/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: TExhMon
 * File: TExhMon.h
 * Author: 120011115
 * Created: Mon Sep 05 16:14:57 2016
 ********************************************************************
 * Header for program TExhMon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_TExhMon_h_
#define RTW_HEADER_TExhMon_h_
#ifndef TExhMon_COMMON_INCLUDES_
# define TExhMon_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* TExhMon_COMMON_INCLUDES_ */

#include "TExhMon_types.h"
#include "lTExhMon.h"

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

/* user code (top of header file) */
/***************************************************************************************************
 * COPYRIGHT -- INNIO Jenbacher GmbH & CO OG
 ****************************************************************************************************
 * Program:            TExhMon
 * Author:             schmisi00
 * Created:            12.01.2021 16:31
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         c:\Git\ValveFractureMonitoring\EC_TExh_Monitoring\TExhMon.slx
 * Model Version:      1.05
 * Simulink Version:   R2012b
 * B&R Target:         V4.5.1
 * Description:        Exhaust Temperature Monitoring Function.
 *
 *                     Outstandings:
 *                     -------------
 *                     - NA
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   schmisi00
 * Last Modified Date: Tue Jan 12 16:15:42 2021
 * Modified Comment:   V1.00  20.10.2019 -  Created, model implementation from AS to Simulink
 *                     V1.01  20.11.2019 -  Added exhaust gas temperature tolerance range
 *                     V1.02  21.11.2019 -  Model cleanup, removed unused parameters and inputs
 *                     V1.03  10.12.2019 -  Bugfix, included number of cylinders in median calculation
 *                     V1.04  31.01.2020 -  Bugfix, corrected rdT2ref calculation when re-activation of invalid cylinders,
 *                                                      changed upper limit of parameter tDelay_dTExhMon_Act_Lim
 *                     V1.05  07.01.2020 -  Detection of exhaust gas temperature signal jumps
 ****************************************************************************************************/

/* Block signals for system '<S1>/TON_TExhMon_Act_GCB_ON' */

/* Block states (auto storage) for system '<S1>/TON_TExhMon_Act_GCB_ON' */

/* Block signals for system '<S5>/TON_InBound' */

/* Block states (auto storage) for system '<S5>/TON_InBound' */

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* Zero-crossing (trigger) state */

/* Constant parameters (auto storage) */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Constant parameters (auto storage) */
extern const ConstParam_TExhMon TExhMon_ConstP;

/* Model entry point functions */
extern void TExhMon_initialize(D_Work_TExhMon *TExhMon_DWork,
  PrevZCSigStates_TExhMon *TExhMon_PrevZCSigState, struct fTExhMon* inst);
extern void TExhMon_step(BlockIO_TExhMon *TExhMon_B, D_Work_TExhMon
  *TExhMon_DWork, PrevZCSigStates_TExhMon *TExhMon_PrevZCSigState,
  ExternalOutputs_TExhMon *TExhMon_Y, struct fTExhMon* inst);
extern void TExhMon_terminate(struct fTExhMon* inst);

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
 * '<Root>' : 'TExhMon'
 * '<S1>'   : 'TExhMon/Activation Criterias'
 * '<S2>'   : 'TExhMon/Environment Controller'
 * '<S3>'   : 'TExhMon/Environment Controller1'
 * '<S4>'   : 'TExhMon/Info'
 * '<S5>'   : 'TExhMon/Init_Calculations'
 * '<S6>'   : 'TExhMon/PARA_Limitation'
 * '<S7>'   : 'TExhMon/TExh Mon Cont Exec'
 * '<S8>'   : 'TExhMon/Activation Criterias/S-R Flip-Flop'
 * '<S9>'   : 'TExhMon/Activation Criterias/S-R Flip-Flop1'
 * '<S10>'  : 'TExhMon/Activation Criterias/TON_TExhMon_Act_GCB_ON'
 * '<S11>'  : 'TExhMon/Activation Criterias/xTON_bdTExhMon_Act_P'
 * '<S12>'  : 'TExhMon/Activation Criterias/TON_TExhMon_Act_GCB_ON/Data Type Conversion Inherited'
 * '<S13>'  : 'TExhMon/Activation Criterias/xTON_bdTExhMon_Act_P/Data Type Conversion Inherited'
 * '<S14>'  : 'TExhMon/Init_Calculations/  '
 * '<S15>'  : 'TExhMon/Init_Calculations/  1'
 * '<S16>'  : 'TExhMon/Init_Calculations/EGT_SignalJumpDetection'
 * '<S17>'  : 'TExhMon/Init_Calculations/MATLAB Function'
 * '<S18>'  : 'TExhMon/Init_Calculations/TON_InBound'
 * '<S19>'  : 'TExhMon/Init_Calculations/TON_OutBound'
 * '<S20>'  : 'TExhMon/Init_Calculations/EGT_SignalJumpDetection/MATLAB Function1'
 * '<S21>'  : 'TExhMon/Init_Calculations/EGT_SignalJumpDetection/TOF'
 * '<S22>'  : 'TExhMon/Init_Calculations/EGT_SignalJumpDetection/TOF/Data Type Conversion Inherited'
 * '<S23>'  : 'TExhMon/Init_Calculations/TON_InBound/Data Type Conversion Inherited'
 * '<S24>'  : 'TExhMon/Init_Calculations/TON_OutBound/Data Type Conversion Inherited'
 * '<S25>'  : 'TExhMon/TExh Mon Cont Exec/Detect Increase'
 * '<S26>'  : 'TExhMon/TExh Mon Cont Exec/MATLAB Function'
 */
#endif                                 /* RTW_HEADER_TExhMon_h_ */
