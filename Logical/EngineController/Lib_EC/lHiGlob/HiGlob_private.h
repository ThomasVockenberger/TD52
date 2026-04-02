/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: HiGlob
 * File: HiGlob_private.h
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Header for program HiGlob
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_HiGlob_private_h_
#define RTW_HEADER_HiGlob_private_h_
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
extern real32_T KITPmaxLim;            /* Variable: KITPmaxLim
                                        * Referenced by: '<S4>/KITPmaxLim (CAD//events*100cycles)'
                                        */
extern real32_T KPredPmaxLim;          /* Variable: KPredPmaxLim
                                        * Referenced by: '<S4>/KPredPmaxLim (%Pel//events*100cycles)'
                                        */
extern real32_T SkipToPowRedGain;      /* Variable: SkipToPowRedGain
                                        * Referenced by: '<Root>/SkipToPowRedGain'
                                        */

#endif                                 /* RTW_HEADER_HiGlob_private_h_ */
