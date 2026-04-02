/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: DAI
 * File: DAI.h
 * Author: 105055527
 * Last modified by: cadm_kafkama00
 * Created: Sat Nov 11 23:05:34 2017
 * Last modified: Wed Oct 02 14:21:06 2024
 * Model Version: 4.14
 * Description: Direct Air Injection for J920 Faststart

   History:

   V0.02  Arnold, 27.11.2017,  tech demonstrator @ P20
   V0.03  Arnold, 24.10.2018,  rename from AirAss to DAI
   V0.04  Arnold, 24.10.2018,  deleted exhaust side DAI, deleted intake dynamics
   V0.05  Arnold, 14.08.2019,  unit testing done, pre-release for Pforzheim P21
   V0.06  Kafka, 20.09.2019, bug fix for testbench manual massflow testing
   V0.07  Kafka, 01.10.2019, massflow limitations changed from per valve to total massflow
   V0.08  Kafka, 02.10.2019, mass flow limitation over boost pressure removed for speed ramp
   V0.09  Kafka, 14.10.2019, disable for negative power trajectory is added in the enable subblock
   V0.10  Kafka, 18.12.2019, disable on speed hysteresis during speed ramp
   V4.14  Kafka, 06.09.2024, update to Matlab Version 2021b


 * modified Comment:
 ********************************************************************
 * Header for program DAI
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_DAI_h_
#define RTW_HEADER_DAI_h_
#include <math.h>
#ifndef DAI_COMMON_INCLUDES_
#define DAI_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* DAI_COMMON_INCLUDES_ */

#include "DAI_types.h"
#include "lDAI.h"
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

#ifndef rtmGetRootDWork
#define rtmGetRootDWork(rtm)           ((rtm)->dwork)
#endif

#ifndef rtmSetRootDWork
#define rtmSetRootDWork(rtm, val)      ((rtm)->dwork = (val))
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
 * Program:            DAI
 * Author:             cadm_kafkama00
 * Created:            02.10.2024 14:21
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Users\kafkama00\Documents\Git\DirectAirInjection\DAI.slx
 * Model Version:      4.14
 * Simulink Version:   R2021b
 * B&R Target:         V6.7.1
 * Description:        Direct Air Injection for J920 Faststart
 *
 *                     History:
 *
 *                        V0.02  Arnold, 27.11.2017,  tech demonstrator @ P20
 *                        V0.03  Arnold, 24.10.2018,  rename from AirAss to DAI
 *                        V0.04  Arnold, 24.10.2018,  deleted exhaust side DAI, deleted intake dynamics
 *                        V0.05  Arnold, 14.08.2019,  unit testing done, pre-release for Pforzheim P21
 *                        V0.06  Kafka, 20.09.2019, bug fix for testbench manual massflow testing
 *                        V0.07  Kafka, 01.10.2019, massflow limitations changed from per valve to total massflow
 *                        V0.08  Kafka, 02.10.2019, mass flow limitation over boost pressure removed for speed ramp
 *                        V0.09  Kafka, 14.10.2019, disable for negative power trajectory is added in the enable subblock
 *                        V0.10  Kafka, 18.12.2019, disable on speed hysteresis during speed ramp
 *                        V4.14  Kafka, 06.09.2024, update to Matlab Version 2021b
 *
 *
 ****************************************************************************************************
 * Last Modified By:   cadm_kafkama00
 * Last Modified Date: Wed Oct 02 14:20:47 2024
 ****************************************************************************************************/

/* Block signals for system '<S2>/Hystersis' */

/* Block states (default storage) for system '<S2>/Hystersis' */

/* Block signals (default storage) */

/* Block states (default storage) for system '<Root>' */

/* Invariant block signals (default storage) */

/* Real-time Model Data Structure */

extern const ConstBlockIO_DAI DAI_ConstB;/* constant block i/o */

/* Model entry point functions */
extern void DAI_initialize(RT_MODEL_DAI *const DAI_M, struct fDAI* inst);
extern void DAI_step(RT_MODEL_DAI *const DAI_M, struct fDAI* inst);
extern void DAI_terminate(RT_MODEL_DAI *const DAI_M, struct fDAI* inst);

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
 * '<Root>' : 'DAI'
 * '<S1>'   : 'DAI/AirFlowDemand'
 * '<S2>'   : 'DAI/Enable'
 * '<S3>'   : 'DAI/EngineMassFlow'
 * '<S4>'   : 'DAI/Info'
 * '<S5>'   : 'DAI/ValvePos'
 * '<S6>'   : 'DAI/AirFlowDemand/Compare To Constant'
 * '<S7>'   : 'DAI/AirFlowDemand/RateLimit'
 * '<S8>'   : 'DAI/AirFlowDemand/Saturation Dynamic1'
 * '<S9>'   : 'DAI/AirFlowDemand/Saturation Dynamic2'
 * '<S10>'  : 'DAI/AirFlowDemand/SpeedRampMassFlow'
 * '<S11>'  : 'DAI/AirFlowDemand/RateLimit/Rate Limiter Dynamic'
 * '<S12>'  : 'DAI/AirFlowDemand/RateLimit/Rate Limiter Dynamic/Saturation Dynamic'
 * '<S13>'  : 'DAI/AirFlowDemand/SpeedRampMassFlow/MATLAB Function'
 * '<S14>'  : 'DAI/Enable/Difference'
 * '<S15>'  : 'DAI/Enable/Hystersis'
 * '<S16>'  : 'DAI/Enable/Hystersis1'
 * '<S17>'  : 'DAI/Enable/Hystersis2'
 * '<S18>'  : 'DAI/Enable/Hystersis3'
 * '<S19>'  : 'DAI/Enable/MATLAB Function'
 * '<S20>'  : 'DAI/Enable/TON'
 * '<S21>'  : 'DAI/Enable/TON/Data Type Conversion Inherited'
 * '<S22>'  : 'DAI/EngineMassFlow/Compare To Constant'
 * '<S23>'  : 'DAI/EngineMassFlow/Saturation Dynamic'
 * '<S24>'  : 'DAI/EngineMassFlow/actual engine massflow'
 * '<S25>'  : 'DAI/EngineMassFlow/bar2Pa'
 * '<S26>'  : 'DAI/EngineMassFlow/bar2Pa1'
 * '<S27>'  : 'DAI/EngineMassFlow/degC2K'
 * '<S28>'  : 'DAI/EngineMassFlow/desired engine massflow'
 * '<S29>'  : 'DAI/EngineMassFlow/rpm2rad'
 * '<S30>'  : 'DAI/EngineMassFlow/rpm2rad1'
 * '<S31>'  : 'DAI/ValvePos/Discharge coefficient computation_A'
 * '<S32>'  : 'DAI/ValvePos/Discharge coefficient computation_B'
 * '<S33>'  : 'DAI/ValvePos/Divisor'
 * '<S34>'  : 'DAI/ValvePos/Saturation Dynamic1'
 * '<S35>'  : 'DAI/ValvePos/Saturation Dynamic2'
 * '<S36>'  : 'DAI/ValvePos/bar2Pa'
 * '<S37>'  : 'DAI/ValvePos/bar2Pa1'
 * '<S38>'  : 'DAI/ValvePos/bar2Pa2'
 * '<S39>'  : 'DAI/ValvePos/bar2Pa3'
 * '<S40>'  : 'DAI/ValvePos/degC2K'
 * '<S41>'  : 'DAI/ValvePos/Divisor/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_DAI_h_ */
