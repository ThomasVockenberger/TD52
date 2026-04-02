/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: MeNoiAL
 * File: MeNoiAL.h
 * Author: 120011115
 * Created: Mon Sep 05 16:14:57 2016
 ********************************************************************
 * Header for program MeNoiAL
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_MeNoiAL_h_
#define RTW_HEADER_MeNoiAL_h_
#ifndef MeNoiAL_COMMON_INCLUDES_
# define MeNoiAL_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* MeNoiAL_COMMON_INCLUDES_ */

#include "MeNoiAL_types.h"
#include "lMeNoiAL.h"

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
 * Program:            MeNoiAL
 * Author:             schmisi00
 * Created:            12.03.2020 09:42
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Git\ValveFractureMonitoring\KN_MechNoiseAdapLim\MeNoiAL.slx
 * Model Version:      1.03
 * Simulink Version:   R2012b
 * B&R Target:         V4.5.1
 * Description:        Mechanical Noise Monitoring Function.
 *
 *                     Outstandings:
 *                     -------------
 *                     - NA
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   schmisi00
 * Last Modified Date: Thu Mar 12 09:41:58 2020
 * Modified Comment:   V1.00 - 20.09.2019 - Created, model implementation from AS to Simulink
 *                     V1.01 - 11.11.2019 - Removed trigger (Para.bMeNoi_Active) from adaptive limit calculation block
 *                     V1.02 - 21.11.2019 - Model cleanup, removed parameter rFiltGain_MeNoi and rFiltOffsFac_MeNoi
 *                     V1.03 - 12.03.2020 - Fenst2_Min calculation change to avoid 65535 during engine standstill
 ****************************************************************************************************/

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* Invariant block signals (auto storage) */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

extern const ConstBlockIO_MeNoiAL MeNoiAL_ConstB;/* constant block i/o */

/* Model entry point functions */
extern void MeNoiAL_initialize(D_Work_MeNoiAL *MeNoiAL_DWork, struct fMeNoiAL* inst);
extern void MeNoiAL_step(BlockIO_MeNoiAL *MeNoiAL_B, D_Work_MeNoiAL
  *MeNoiAL_DWork, ExternalOutputs_MeNoiAL *MeNoiAL_Y, struct fMeNoiAL* inst);
extern void MeNoiAL_terminate(struct fMeNoiAL* inst);

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
 * '<Root>' : 'MeNoiAL'
 * '<S1>'   : 'MeNoiAL/Environment Controller'
 * '<S2>'   : 'MeNoiAL/Environment Controller1'
 * '<S3>'   : 'MeNoiAL/Fenst2 Thresh Alarm'
 * '<S4>'   : 'MeNoiAL/Fenst2_Average_Min_Max'
 * '<S5>'   : 'MeNoiAL/Info'
 * '<S6>'   : 'MeNoiAL/Mechanical Noise Adaptive Limit'
 * '<S7>'   : 'MeNoiAL/PARA_Limitation'
 * '<S8>'   : 'MeNoiAL/Fenst2_Average_Min_Max/Divisor'
 * '<S9>'   : 'MeNoiAL/Fenst2_Average_Min_Max/MATLAB Function1'
 * '<S10>'  : 'MeNoiAL/Fenst2_Average_Min_Max/Divisor/Data Type Conversion Inherited'
 * '<S11>'  : 'MeNoiAL/Mechanical Noise Adaptive Limit/Backward Euler PT1'
 * '<S12>'  : 'MeNoiAL/Mechanical Noise Adaptive Limit/Divisor'
 * '<S13>'  : 'MeNoiAL/Mechanical Noise Adaptive Limit/Saturation Dynamic'
 * '<S14>'  : 'MeNoiAL/Mechanical Noise Adaptive Limit/Saturation Dynamic1'
 * '<S15>'  : 'MeNoiAL/Mechanical Noise Adaptive Limit/Backward Euler PT1/Divisor'
 * '<S16>'  : 'MeNoiAL/Mechanical Noise Adaptive Limit/Backward Euler PT1/Divisor/Data Type Conversion Inherited'
 * '<S17>'  : 'MeNoiAL/Mechanical Noise Adaptive Limit/Divisor/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_MeNoiAL_h_ */
