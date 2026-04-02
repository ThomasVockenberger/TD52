/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: GridStat
 * File: GridStat.h
 * Author: 105055527
 * Last modified by: cadm_kafkama00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Tue Nov 26 15:54:38 2024
 * Model Version: 2.02
 * Description: Detection Algorithm for grid connection.

   HISTORY:
   V1.00  24.07.2020 Keller   created
   V1.01  07.08.2020 Huber  included function block from simulation
   V1.02  29.04.2021 Denk   VectorShift and LVRT function added
   V1.03  31.01.2022 Keller  add input for GCB_On

   V2.00  10.08.2023 Walch  Revision of parametrization, sensitivity and FRT selectivity
   V2.01  22.11.2023 Walch  Include grid observer
   10.01.2024 Walch  Include TP LVRT hold time for weak LVRT blocking
   V2.02  25.11.2024 Walch  Update grid observer for SS mains parallel vs. island plausibility check
 * modified Comment:
 ********************************************************************
 * Header for program GridStat
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_GridStat_h_
#define RTW_HEADER_GridStat_h_
#include <math.h>
#ifndef GridStat_COMMON_INCLUDES_
#define GridStat_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "zero_crossing_types.h"
#endif                                 /* GridStat_COMMON_INCLUDES_ */

#include "GridStat_types.h"
#include "lGridStat.h"
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
#define rtmGetBlockIO(rtm)             ((rtm)->blockIO)
#endif

#ifndef rtmSetBlockIO
#define rtmSetBlockIO(rtm, val)        ((rtm)->blockIO = (val))
#endif

#ifndef rtmGetPrevZCSigState
#define rtmGetPrevZCSigState(rtm)      ((rtm)->prevZCSigState)
#endif

#ifndef rtmSetPrevZCSigState
#define rtmSetPrevZCSigState(rtm, val) ((rtm)->prevZCSigState = (val))
#endif

#ifndef rtmGetRootDWork
#define rtmGetRootDWork(rtm)           ((rtm)->dwork)
#endif

#ifndef rtmSetRootDWork
#define rtmSetRootDWork(rtm, val)      ((rtm)->dwork = (val))
#endif

#ifndef rtmGetY
#define rtmGetY(rtm)                   ((rtm)->outputs)
#endif

#ifndef rtmSetY
#define rtmSetY(rtm, val)              ((rtm)->outputs = (val))
#endif

#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
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
 * Program:            GridStat
 * Author:             cadm_kafkama00
 * Created:            26.11.2024 15:54
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Users\kafkama00\Documents\Git\JenCtrLib\Controllers\GridStatusDetection\GridStat.slx
 * Model Version:      2.02
 * Simulink Version:   R2021b
 * B&R Target:         V6.7.1
 * Description:        Detection Algorithm for grid connection.
 *
 *                     HISTORY:
 *                     V1.00  24.07.2020 Keller   created
 *                     V1.01  07.08.2020 Huber  included function block from simulation
 *                     V1.02  29.04.2021 Denk   VectorShift and LVRT function added
 *                     V1.03  31.01.2022 Keller  add input for GCB_On
 *
 *                     V2.00  10.08.2023 Walch  Revision of parametrization, sensitivity and FRT selectivity
 *                     V2.01  22.11.2023 Walch  Include grid observer
 *                                10.01.2024 Walch  Include TP LVRT hold time for weak LVRT blocking
 *                     V2.02  25.11.2024 Walch  Update grid observer for SS mains parallel vs. island plausibility check
 ****************************************************************************************************
 * Last Modified By:   walchin00
 * Last Modified Date: Mon Nov 25 17:05:58 2024
 ****************************************************************************************************/

/* Block signals for system '<S4>/TofLvrtWeakBlk1' */

/* Block states (default storage) for system '<S4>/TofLvrtWeakBlk1' */

/* Block signals for system '<S4>/TpDetNabsProtTrigger' */

/* Block states (default storage) for system '<S4>/TpDetNabsProtTrigger' */

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* Zero-crossing (trigger) state */

/* External outputs (root outports fed by signals with default storage) */

/* Real-time Model Data Structure */

/* Model entry point functions */
extern void GridStat_initialize(RT_MODEL_GridStat *const GridStat_M, struct fGridStat* inst);
extern void GridStat_step(RT_MODEL_GridStat *const GridStat_M, struct fGridStat* inst);
extern void GridStat_terminate(RT_MODEL_GridStat *const GridStat_M, struct fGridStat* inst);

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
 * '<Root>' : 'GridStat'
 * '<S1>'   : 'GridStat/Info1'
 * '<S2>'   : 'GridStat/detection + correction: transition to Island'
 * '<S3>'   : 'GridStat/detection + correction: transition to Island/Filter'
 * '<S4>'   : 'GridStat/detection + correction: transition to Island/N//Prot Detection'
 * '<S5>'   : 'GridStat/detection + correction: transition to Island/Smooth Detection'
 * '<S6>'   : 'GridStat/detection + correction: transition to Island/TofMcbFb'
 * '<S7>'   : 'GridStat/detection + correction: transition to Island/TofReset'
 * '<S8>'   : 'GridStat/detection + correction: transition to Island/VPN Detection'
 * '<S9>'   : 'GridStat/detection + correction: transition to Island/Filter/Divisor'
 * '<S10>'  : 'GridStat/detection + correction: transition to Island/Filter/Divisor/Data Type Conversion Inherited'
 * '<S11>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/Speed_filter'
 * '<S12>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TofLvrtWeakBlk1'
 * '<S13>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpDetNabsProtTrigger'
 * '<S14>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtBlockHold1'
 * '<S15>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtTrigHold1'
 * '<S16>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpNabsTrigger'
 * '<S17>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpProtTrigger'
 * '<S18>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/Speed_filter/Divisor'
 * '<S19>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/Speed_filter/Divisor/Data Type Conversion Inherited'
 * '<S20>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TofLvrtWeakBlk1/Data Type Conversion Inherited'
 * '<S21>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpDetNabsProtTrigger/Compare To Zero'
 * '<S22>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpDetNabsProtTrigger/Enabled Subsystem'
 * '<S23>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpDetNabsProtTrigger/Enabled Subsystem1'
 * '<S24>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpDetNabsProtTrigger/Rate Limiter'
 * '<S25>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpDetNabsProtTrigger/Rate Limiter/Saturation Dynamic'
 * '<S26>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtBlockHold1/Compare To Zero'
 * '<S27>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtBlockHold1/Enabled Subsystem'
 * '<S28>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtBlockHold1/Enabled Subsystem1'
 * '<S29>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtBlockHold1/Rate Limiter'
 * '<S30>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtBlockHold1/Rate Limiter/Saturation Dynamic'
 * '<S31>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtTrigHold1/Compare To Zero'
 * '<S32>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtTrigHold1/Enabled Subsystem'
 * '<S33>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtTrigHold1/Enabled Subsystem1'
 * '<S34>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtTrigHold1/Rate Limiter'
 * '<S35>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpLvrtTrigHold1/Rate Limiter/Saturation Dynamic'
 * '<S36>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpNabsTrigger/Compare To Zero'
 * '<S37>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpNabsTrigger/Enabled Subsystem'
 * '<S38>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpNabsTrigger/Enabled Subsystem1'
 * '<S39>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpNabsTrigger/Rate Limiter'
 * '<S40>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpNabsTrigger/Rate Limiter/Saturation Dynamic'
 * '<S41>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpProtTrigger/Compare To Zero'
 * '<S42>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpProtTrigger/Enabled Subsystem'
 * '<S43>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpProtTrigger/Enabled Subsystem1'
 * '<S44>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpProtTrigger/Rate Limiter'
 * '<S45>'  : 'GridStat/detection + correction: transition to Island/N//Prot Detection/TpProtTrigger/Rate Limiter/Saturation Dynamic'
 * '<S46>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor'
 * '<S47>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor1'
 * '<S48>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor2'
 * '<S49>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor3'
 * '<S50>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor4'
 * '<S51>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor5'
 * '<S52>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Grid Observer'
 * '<S53>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor/Data Type Conversion Inherited'
 * '<S54>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor1/Data Type Conversion Inherited'
 * '<S55>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor2/Data Type Conversion Inherited'
 * '<S56>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor3/Data Type Conversion Inherited'
 * '<S57>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor4/Data Type Conversion Inherited'
 * '<S58>'  : 'GridStat/detection + correction: transition to Island/Smooth Detection/Divisor5/Data Type Conversion Inherited'
 * '<S59>'  : 'GridStat/detection + correction: transition to Island/TofMcbFb/Data Type Conversion Inherited'
 * '<S60>'  : 'GridStat/detection + correction: transition to Island/TofReset/Data Type Conversion Inherited'
 * '<S61>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TP_PU_trigger'
 * '<S62>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TofAfterFRT'
 * '<S63>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TofLvrtWeakBlk2'
 * '<S64>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpDetVPNTrigger'
 * '<S65>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtBlockHold2'
 * '<S66>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtTrigHold2'
 * '<S67>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpNTrigger'
 * '<S68>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpPTrigger'
 * '<S69>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpUTrigger'
 * '<S70>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TP_PU_trigger/Compare To Zero'
 * '<S71>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TP_PU_trigger/Enabled Subsystem'
 * '<S72>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TP_PU_trigger/Enabled Subsystem1'
 * '<S73>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TP_PU_trigger/Rate Limiter'
 * '<S74>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TP_PU_trigger/Rate Limiter/Saturation Dynamic'
 * '<S75>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TofAfterFRT/Data Type Conversion Inherited'
 * '<S76>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TofLvrtWeakBlk2/Data Type Conversion Inherited'
 * '<S77>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpDetVPNTrigger/Compare To Zero'
 * '<S78>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpDetVPNTrigger/Enabled Subsystem'
 * '<S79>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpDetVPNTrigger/Enabled Subsystem1'
 * '<S80>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpDetVPNTrigger/Rate Limiter'
 * '<S81>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpDetVPNTrigger/Rate Limiter/Saturation Dynamic'
 * '<S82>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtBlockHold2/Compare To Zero'
 * '<S83>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtBlockHold2/Enabled Subsystem'
 * '<S84>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtBlockHold2/Enabled Subsystem1'
 * '<S85>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtBlockHold2/Rate Limiter'
 * '<S86>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtBlockHold2/Rate Limiter/Saturation Dynamic'
 * '<S87>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtTrigHold2/Compare To Zero'
 * '<S88>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtTrigHold2/Enabled Subsystem'
 * '<S89>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtTrigHold2/Enabled Subsystem1'
 * '<S90>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtTrigHold2/Rate Limiter'
 * '<S91>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpLvrtTrigHold2/Rate Limiter/Saturation Dynamic'
 * '<S92>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpNTrigger/Compare To Zero'
 * '<S93>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpNTrigger/Enabled Subsystem'
 * '<S94>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpNTrigger/Enabled Subsystem1'
 * '<S95>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpNTrigger/Rate Limiter'
 * '<S96>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpNTrigger/Rate Limiter/Saturation Dynamic'
 * '<S97>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpPTrigger/Compare To Zero'
 * '<S98>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpPTrigger/Enabled Subsystem'
 * '<S99>'  : 'GridStat/detection + correction: transition to Island/VPN Detection/TpPTrigger/Enabled Subsystem1'
 * '<S100>' : 'GridStat/detection + correction: transition to Island/VPN Detection/TpPTrigger/Rate Limiter'
 * '<S101>' : 'GridStat/detection + correction: transition to Island/VPN Detection/TpPTrigger/Rate Limiter/Saturation Dynamic'
 * '<S102>' : 'GridStat/detection + correction: transition to Island/VPN Detection/TpUTrigger/Compare To Zero'
 * '<S103>' : 'GridStat/detection + correction: transition to Island/VPN Detection/TpUTrigger/Enabled Subsystem'
 * '<S104>' : 'GridStat/detection + correction: transition to Island/VPN Detection/TpUTrigger/Enabled Subsystem1'
 * '<S105>' : 'GridStat/detection + correction: transition to Island/VPN Detection/TpUTrigger/Rate Limiter'
 * '<S106>' : 'GridStat/detection + correction: transition to Island/VPN Detection/TpUTrigger/Rate Limiter/Saturation Dynamic'
 */
#endif                                 /* RTW_HEADER_GridStat_h_ */
