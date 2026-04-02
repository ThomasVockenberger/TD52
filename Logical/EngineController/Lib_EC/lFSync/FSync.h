/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: FSync
 * File: FSync.h
 * Author: 105051359
 * Created: Mon Mar 13 15:42:43 2017
 ********************************************************************
 * Header for program FSync
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_FSync_h_
#define RTW_HEADER_FSync_h_
#ifndef FSync_COMMON_INCLUDES_
# define FSync_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* FSync_COMMON_INCLUDES_ */

#include "FSync_types.h"
#include "lFSync.h"

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
 * Program:            FSync
 * Author:             arnolge00
 * Created:            05.07.2021 14:02
 ****************************************************************************************************
 * MODEL INFORMATION
 ****************************************************************************************************
 * Model Name:         C:\Users\arnolge00\Documents\MATLAB\Git\FastSync\03_Simulation\ModelFull\FSync.slx
 * Model Version:      0.07
 * Simulink Version:   R2012b
 * B&R Target:         V4.5.1
 * Description:
 ****************************************************************************************************
 * HISTORY
 ****************************************************************************************************
 * Last Modified By:   arnolge00
 * Last Modified Date: Mon Jul 05 14:00:19 2021
 * Modified Comment:   V0.01    11.05.2017    Arnold,   first version used @P20
 *                     V0.02    23.05.2017    Arnold,   Generator frequency included
 *                     V0.03    29.05.2017    Arnold,   added idle speed
 *                     V0.04    29.05.2017    Arnold,   added P-part and Sync offset for Ctrl=1
 *                     V0.05    05.08.2020    Schmidt,  changed grid frequency variable from rF_MMD_Synch2 to rF_MMD_BusBar
 *                     V0.06    25.01.2021    Schmidt,  use of frequency based speed set-point (rN_Set) only if rF_MMD_BusBar > 0.5*rF_Nom
 *                     V0.07    05.07.2021    Arnold,   prevent NaN with using of standard filter
 ****************************************************************************************************/

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Model entry point functions */
extern void FSync_initialize(D_Work_FSync *FSync_DWork, struct fFSync* inst);
extern void FSync_step(BlockIO_FSync *FSync_B, D_Work_FSync *FSync_DWork,
  ExternalOutputs_FSync *FSync_Y, struct fFSync* inst);
extern void FSync_terminate(struct fFSync* inst);

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
 * '<Root>' : 'FSync'
 * '<S1>'   : 'FSync/Environment Controller'
 * '<S2>'   : 'FSync/Environment Controller1'
 * '<S3>'   : 'FSync/Environment Controller2'
 * '<S4>'   : 'FSync/Info'
 * '<S5>'   : 'FSync/NSkipInit'
 * '<S6>'   : 'FSync/SkipFireCtrl'
 * '<S7>'   : 'FSync/Skipfire_active'
 * '<S8>'   : 'FSync/Time2Sample'
 * '<S9>'   : 'FSync/ValueSelect'
 * '<S10>'  : 'FSync/ValueSelect/Compare To Constant1'
 * '<S11>'  : 'FSync/ValueSelect/Compare To Zero1'
 * '<S12>'  : 'FSync/ValueSelect/Compare To Zero2'
 * '<S13>'  : 'FSync/ValueSelect/Compare To Zero3'
 * '<S14>'  : 'FSync/ValueSelect/Compare To Zero4'
 * '<S15>'  : 'FSync/ValueSelect/Divisor'
 * '<S16>'  : 'FSync/ValueSelect/Divisor1'
 * '<S17>'  : 'FSync/ValueSelect/Filter'
 * '<S18>'  : 'FSync/ValueSelect/Saturation Dynamic'
 * '<S19>'  : 'FSync/ValueSelect/Divisor/Data Type Conversion Inherited'
 * '<S20>'  : 'FSync/ValueSelect/Divisor1/Data Type Conversion Inherited'
 * '<S21>'  : 'FSync/ValueSelect/Filter/Divisor'
 * '<S22>'  : 'FSync/ValueSelect/Filter/Divisor/Data Type Conversion Inherited'
 */
#endif                                 /* RTW_HEADER_FSync_h_ */
