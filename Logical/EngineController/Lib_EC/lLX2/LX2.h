/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LX2
 * File: LX2.h
 * Author: 212566120
 * Created: Wed Apr 11 13:34:17 2018
 ********************************************************************
 * Header for program LX2
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_LX2_h_
#define RTW_HEADER_LX2_h_
#ifndef LX2_COMMON_INCLUDES_
# define LX2_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* LX2_COMMON_INCLUDES_ */

#include "LX2_types.h"
#include "lLX2.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
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
 * Program:            LX2
 * Author:             maranen00
 * Created:            21.07.2022 16:03
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Git\Leanox_Plus\3 modeling & auto-code generation\LX2.slx
 * Model Version:      1.3.0
 * Simulink Version:   R2012b
 * B&R Target:         V4.5.1
 * Description:        Leanox 2.0
 *
 *                     Outstandings:
 *                     -----------------
 *
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   maranen00
 * Last Modified Date: Thu Jul 21 15:21:04 2022
 * Modified Comment:   V0.1    Schneider, 11.04.2018, created
 *                     V0.2    Schneider, 13.07.2018, 1st Engine Screening Tests P4
 *                     V0.3    Schneider, 01.08.2018, added gas-mixing functionality, (2nd Engine Screening Tests P4)
 *                     V0.4    Schneider, 24.08.2018, added Threshold for gas-mixing functionality
 *                     V0.5    Schneider, 31.08.2018, 3rd Engine Screening Tests P4
 *                     V0.6    Schneider, 11.09.2018, Pilot Release
 *                     V0.6.1  Schneider, 24.09.2018, added logic for LX2 in Saturation
 *                     V0.7    Arnold,    15.11.2018, changed modes to benable, added bActive, deleted external resets
 *                     V0.8    Arnold,    23.11.2018, reset NOx filter to actual value - limited to 20/300ppm
 *                     V0.9    Arnold,    28.11.2018, Ctrl reset bugfix, Ctrl freeze if misfire or knocking
 *                     V0.9.1 Maran,     19.12.2018, shifting of NOx filter time from PERM to PARA
 *                     V0.9.2 Maran,     03.01.2019, Update of initialization of NOx filtered value in case of signal fault;
 *                                                                 Integrator clamping logic update to consider also the "Map only mode" for the LX2 limit warning;
 *                                                                 Update to display BPOC curve also when LX2 is not active.
 *                     V0.9.3 Maran,     03.01.2019, Definition of PARA LX2_OffsetLimit; Slope, SlopeEx, UpperLim and LowerLim removed from PERM.
 *                     V0.9.4 Maran,     04.01.2019, added LX2 steady state
 *                     V0.9.5 Maran,     07.01.2019, added PERM parameters for LX2 steady state
 *                     V0.9.6 Maran,     14.01.2019, updated LX2 limit warning logic
 *                     V0.9.7 Maran,     21.01.2019, updated reset logic of NOx signal filter in case of signal fault
 *                     V1.0.1 Maran,     31.07.2019, Update of initialization of internal BPOC in case the corresponding BPOC learning is not active;
 *                                                                 SlopeEx limitation reduced from 60% to 30% of interpolation slope limit.
 *                     V1.0.2 Maran,     17.10.2019, Removed library link for rate limiter; Lx adjustment confirmation removed from state machine function.
 *                     V1.0.3 Maran,     21.01.2020, Smoothing function bugfix for left/right nodes at different distances
 *                     V1.1.0 Maran,     18.01.2021, added skipfire to steady state; initialized Lx deviation monitoring for steady state with current value;
 *                                                                 Limited extrapolated BPOC value at 0kW to 10% of control range.
 *                     V1.1.1 Maran,     19.01.2021, NOx filter init limit applied only to actual value;
 *                                                                 added limitation to control error for the closed loop integrator (PERM parameter);
 *                                                                 removed freezing of closed loop in misfire event for positive offset limitation only.
 *                     V1.1.2 Maran,     19.02.2021, replaced skipfire in steady state with external interface signal for steady state loss;
 *                                                                 added external interface for BPOC learning stop.
 *                     V1.2.0 Maran,     28.06.2021, added Leanox point c in BPOC library; removed unused BPOC ouput rLX2_delta_LX1;
 *                                                                 input/ouput details for Lp_c integration added in high level BPOC block.
 *                     V1.3.0 Maran,     21.07.2022, added fast ramp activation and multiplier inputs.
 ****************************************************************************************************/

/* Block signals for system '<S10>/Boost Pressure Offset Curve' */

/* Block signals for system '<S37>/TON' */

/* Block states (auto storage) for system '<S37>/TON' */

/* Block signals for system '<S8>/Filter1' */

/* Block states (auto storage) for system '<S8>/Filter1' */

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* Zero-crossing (trigger) state */

/* Constant parameters (auto storage) */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Real-time Model Data Structure */

/* Block signals (auto storage) */
extern BlockIO_LX2 LX2_B;

/* Block states (auto storage) */
extern D_Work_LX2 LX2_DWork;

/* External inputs (root inport signals with auto storage) */
extern ExternalInputs_LX2 LX2_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExternalOutputs_LX2 LX2_Y;

/* Constant parameters (auto storage) */
extern const ConstParam_LX2 LX2_ConstP;

/* Model entry point functions */
extern void LX2_initialize(struct fLX2* inst);
extern void LX2_step(struct fLX2* inst);
extern void LX2_terminate(struct fLX2* inst);

/* Real-time Model object */
extern RT_MODEL_LX2 *const LX2_M;

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
 * '<Root>' : 'LX2'
 * '<S1>'   : 'LX2/Environment Controller'
 * '<S2>'   : 'LX2/Environment Controller1'
 * '<S3>'   : 'LX2/Environment Controller3'
 * '<S4>'   : 'LX2/Info'
 * '<S5>'   : 'LX2/Leanox 2.0'
 * '<S6>'   : 'LX2/Leanox 2.0/BPOC'
 * '<S7>'   : 'LX2/Leanox 2.0/Controller'
 * '<S8>'   : 'LX2/Leanox 2.0/STM'
 * '<S9>'   : 'LX2/Leanox 2.0/BPOC/BPOC for Visu_DBUG'
 * '<S10>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 1'
 * '<S11>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 2'
 * '<S12>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 3'
 * '<S13>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 4'
 * '<S14>'  : 'LX2/Leanox 2.0/BPOC/Visu'
 * '<S15>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 1/Boost Pressure Offset Curve'
 * '<S16>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 1/Divisor'
 * '<S17>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 1/Saturation Dynamic2'
 * '<S18>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 1/Divisor/Data Type Conversion Inherited'
 * '<S19>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 2/Boost Pressure Offset Curve'
 * '<S20>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 2/Divisor'
 * '<S21>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 2/Saturation Dynamic2'
 * '<S22>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 2/Divisor/Data Type Conversion Inherited'
 * '<S23>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 3/Boost Pressure Offset Curve'
 * '<S24>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 3/Divisor'
 * '<S25>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 3/Saturation Dynamic2'
 * '<S26>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 3/Divisor/Data Type Conversion Inherited'
 * '<S27>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 4/Boost Pressure Offset Curve'
 * '<S28>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 4/Divisor'
 * '<S29>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 4/Saturation Dynamic2'
 * '<S30>'  : 'LX2/Leanox 2.0/BPOC/Boost Pressure Offset Map GAS 4/Divisor/Data Type Conversion Inherited'
 * '<S31>'  : 'LX2/Leanox 2.0/BPOC/Visu/MATLAB Function'
 * '<S32>'  : 'LX2/Leanox 2.0/Controller/Compare To Zero'
 * '<S33>'  : 'LX2/Leanox 2.0/Controller/Compare To Zero1'
 * '<S34>'  : 'LX2/Leanox 2.0/Controller/Detect Increase'
 * '<S35>'  : 'LX2/Leanox 2.0/Controller/Filter'
 * '<S36>'  : 'LX2/Leanox 2.0/Controller/I-Controller with Anti Wind-up (clamping)'
 * '<S37>'  : 'LX2/Leanox 2.0/Controller/LX2 limit exceeded'
 * '<S38>'  : 'LX2/Leanox 2.0/Controller/MATLAB Function'
 * '<S39>'  : 'LX2/Leanox 2.0/Controller/Saturation Dynamic1'
 * '<S40>'  : 'LX2/Leanox 2.0/Controller/Saturation Dynamic2'
 * '<S41>'  : 'LX2/Leanox 2.0/Controller/rateLimit'
 * '<S42>'  : 'LX2/Leanox 2.0/Controller/Filter/Divisor'
 * '<S43>'  : 'LX2/Leanox 2.0/Controller/Filter/Divisor/Data Type Conversion Inherited'
 * '<S44>'  : 'LX2/Leanox 2.0/Controller/I-Controller with Anti Wind-up (clamping)/Anti Wind-Up Clamping'
 * '<S45>'  : 'LX2/Leanox 2.0/Controller/I-Controller with Anti Wind-up (clamping)/Divisor'
 * '<S46>'  : 'LX2/Leanox 2.0/Controller/I-Controller with Anti Wind-up (clamping)/Divisor/Data Type Conversion Inherited'
 * '<S47>'  : 'LX2/Leanox 2.0/Controller/LX2 limit exceeded/TON'
 * '<S48>'  : 'LX2/Leanox 2.0/Controller/LX2 limit exceeded/TON/Data Type Conversion Inherited'
 * '<S49>'  : 'LX2/Leanox 2.0/Controller/rateLimit/Saturation Dynamic'
 * '<S50>'  : 'LX2/Leanox 2.0/STM/Filter1'
 * '<S51>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState'
 * '<S52>'  : 'LX2/Leanox 2.0/STM/Logic'
 * '<S53>'  : 'LX2/Leanox 2.0/STM/MATLAB Function'
 * '<S54>'  : 'LX2/Leanox 2.0/STM/SaveTimer'
 * '<S55>'  : 'LX2/Leanox 2.0/STM/Filter1/Divisor'
 * '<S56>'  : 'LX2/Leanox 2.0/STM/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S57>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState/Filter'
 * '<S58>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState/Filter1'
 * '<S59>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState/TON'
 * '<S60>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState/Filter/Divisor'
 * '<S61>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState/Filter/Divisor/Data Type Conversion Inherited'
 * '<S62>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState/Filter1/Divisor'
 * '<S63>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState/Filter1/Divisor/Data Type Conversion Inherited'
 * '<S64>'  : 'LX2/Leanox 2.0/STM/LX2_SteadyState/TON/Data Type Conversion Inherited'
 * '<S65>'  : 'LX2/Leanox 2.0/STM/Logic/Compare To Constant'
 * '<S66>'  : 'LX2/Leanox 2.0/STM/SaveTimer/TON'
 * '<S67>'  : 'LX2/Leanox 2.0/STM/SaveTimer/TON/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_LX2_h_ */
