/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: HiContr
 * File: HiContr_private.h
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Header for program HiContr
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_HiContr_private_h_
#define RTW_HEADER_HiContr_private_h_
#include "rtwtypes.h"
#include <bur/plctypes.h>
#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#else
#ifdef TMWTYPES_PREVIOUSLY_INCLUDED
#error This file requires rtwtypes.h to be included before tmwtypes.h
#else

/* Check for inclusion of an incorrect version of rtwtypes.h */
#ifndef RTWTYPES_ID_C08S16I32L32N32F1
#error This code was generated with a different "rtwtypes.h" than the file included
#endif                                 /* RTWTYPES_ID_C08S16I32L32N32F1 */
#endif                                 /* TMWTYPES_PREVIOUSLY_INCLUDED */
#endif                                 /* __RTWTYPES_H__ */

#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

/* Imported (extern) block parameters */
extern real32_T GIGain;                /* Variable: GIGain
                                        * Referenced by: '<S1>/GIGain (%*100cycles//events)'
                                        */
extern real32_T GIPowGain;             /* Variable: GIPowGain
                                        * Referenced by: '<S1>/GIPowGain (%Pnom*100cycles//events)'
                                        */
extern real32_T MFGain;                /* Variable: MFGain
                                        * Referenced by: '<S1>/MFGain (%*100cycles//events)'
                                        */
extern real32_T MFGainSkipTdown;       /* Variable: MFGainSkipTdown
                                        * Referenced by: '<S1>/MF_Gain_Skip_Tdown'
                                        */
extern real32_T MFThSkipOff;           /* Variable: MFThSkipOff
                                        * Referenced by: '<S1>/Relay1'
                                        */
extern real32_T MFThSkipOn;            /* Variable: MFThSkipOn
                                        * Referenced by: '<S1>/Relay1'
                                        */
extern real32_T PmaxLimReaHys;         /* Variable: PmaxLimReaHys
                                        * Referenced by: '<S1>/Relay'
                                        */
extern real32_T WCGain;                /* Variable: WCGain
                                        * Referenced by: '<S1>/WCGain (bar*100cycles//events)'
                                        */
extern real32_T WCScaling;             /* Variable: WCScaling
                                        * Referenced by: '<S1>/scaling relative to  Pmax at full load (%//bar)'
                                        */

#endif                                 /* RTW_HEADER_HiContr_private_h_ */
