/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: CPP_Int
 * File: CPP_Int.h
 * Author: Messner
 * Created: Fri Nov 24 07:48:45 2017
 ********************************************************************
 * Header for program CPP_Int
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_CPP_Int_h_
#define RTW_HEADER_CPP_Int_h_
#ifndef CPP_Int_COMMON_INCLUDES_
# define CPP_Int_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* CPP_Int_COMMON_INCLUDES_ */

#include "CPP_Int_types.h"
#include "lCPP_Int.h"

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

/* Block signals (auto storage) */

/* Block states (auto storage) for system '<Root>' */

/* Zero-crossing (trigger) state */

/* External inputs (root inport signals with auto storage) */

/* External outputs (root outports fed by signals with auto storage) */

/* Model entry point functions */
extern void CPP_Int_initialize(PrevZCSigStates_CPP_Int *CPP_Int_PrevZCSigState, struct fCPP_Int* inst);
extern void CPP_Int_step(BlockIO_CPP_Int *CPP_Int_B, D_Work_CPP_Int
  *CPP_Int_DWork, PrevZCSigStates_CPP_Int *CPP_Int_PrevZCSigState,
  ExternalOutputs_CPP_Int *CPP_Int_Y, struct fCPP_Int* inst);
extern void CPP_Int_terminate(struct fCPP_Int* inst);

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
 * '<Root>' : 'CPP_Int'
 * '<S1>'   : 'CPP_Int/Cycle Phase Detector Clock'
 * '<S2>'   : 'CPP_Int/Cylinder Peak Pressure Error Calculator'
 * '<S3>'   : 'CPP_Int/Cylinder Peak Pressure Integrator'
 * '<S4>'   : 'CPP_Int/Detect Increase'
 * '<S5>'   : 'CPP_Int/Environment Controller'
 * '<S6>'   : 'CPP_Int/Environment Controller1'
 * '<S7>'   : 'CPP_Int/Environment Controller2'
 * '<S8>'   : 'CPP_Int/Ignition Point and PI Duration Offset Calculator'
 * '<S9>'   : 'CPP_Int/Info'
 * '<S10>'  : 'CPP_Int/Shutdown Procedures '
 * '<S11>'  : 'CPP_Int/Cycle Phase Detector Clock/Detect Increase'
 * '<S12>'  : 'CPP_Int/Cycle Phase Detector Clock/Divisor'
 * '<S13>'  : 'CPP_Int/Cycle Phase Detector Clock/Pressure Change Detect'
 * '<S14>'  : 'CPP_Int/Cycle Phase Detector Clock/RPM TO  SecPerCycle'
 * '<S15>'  : 'CPP_Int/Cycle Phase Detector Clock/Divisor/Data Type Conversion Inherited'
 * '<S16>'  : 'CPP_Int/Cylinder Peak Pressure Error Calculator/Divisor'
 * '<S17>'  : 'CPP_Int/Cylinder Peak Pressure Error Calculator/Saturation Dynamic'
 * '<S18>'  : 'CPP_Int/Cylinder Peak Pressure Error Calculator/Saturation Dynamic1'
 * '<S19>'  : 'CPP_Int/Cylinder Peak Pressure Error Calculator/Divisor/Data Type Conversion Inherited'
 * '<S20>'  : 'CPP_Int/Cylinder Peak Pressure Integrator/Compare To Zero'
 * '<S21>'  : 'CPP_Int/Cylinder Peak Pressure Integrator/Integrator'
 * '<S22>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Ignition Point reduction'
 * '<S23>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Port Injection Duration reduction'
 * '<S24>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Ignition Point reduction/Lower Signal Limiter'
 * '<S25>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Ignition Point reduction/Ramp Slope [k] - factor'
 * '<S26>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Ignition Point reduction/Saturation Dynamic1'
 * '<S27>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Ignition Point reduction/Signal Enabler'
 * '<S28>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Ignition Point reduction/Upper Signal Limiter'
 * '<S29>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Ignition Point reduction/Ramp Slope [k] - factor/Divisor'
 * '<S30>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Ignition Point reduction/Ramp Slope [k] - factor/Divisor/Data Type Conversion Inherited'
 * '<S31>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Port Injection Duration reduction/Lower Signal Limiter'
 * '<S32>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Port Injection Duration reduction/Ramp Slope [k] - factor'
 * '<S33>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Port Injection Duration reduction/Saturation Dynamic1'
 * '<S34>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Port Injection Duration reduction/Signal Enabler'
 * '<S35>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Port Injection Duration reduction/Upper Signal Limiter'
 * '<S36>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Port Injection Duration reduction/Ramp Slope [k] - factor/Divisor'
 * '<S37>'  : 'CPP_Int/Ignition Point and PI Duration Offset Calculator/Ramp Limiter Port Injection Duration reduction/Ramp Slope [k] - factor/Divisor/Data Type Conversion Inherited'
 * '<S38>'  : 'CPP_Int/Shutdown Procedures /Integrator Nonempty'
 * '<S39>'  : 'CPP_Int/Shutdown Procedures /Integrator Full'
 * '<S40>'  : 'CPP_Int/Shutdown Procedures /TON Timer Integrator Nonempty'
 */
#endif                                 /* RTW_HEADER_CPP_Int_h_ */
