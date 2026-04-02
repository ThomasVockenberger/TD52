/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: TExhMon
 * File: TExhMon_private.h
 * Author: 120011115
 * Created: Mon Sep 05 16:14:57 2016
 ********************************************************************
 * Header for program TExhMon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_TExhMon_private_h_
#define RTW_HEADER_TExhMon_private_h_
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

extern void TExhMon_TON_TExhMon_Act_GCB_ON(boolean_T rtu_IN, real32_T rtu_PT,
  rtB_TON_TExhMon_Act_GCB_ON_TExh *localB, rtDW_TON_TExhMon_Act_GCB_ON_TEx
  *localDW, struct fTExhMon* inst);
extern void TExhMon_TON_InBound(const boolean_T rtu_IN[25], real32_T rtu_PT,
  rtB_TON_InBound_TExhMon *localB, rtDW_TON_InBound_TExhMon *localDW, struct fTExhMon* inst);

#endif                                 /* RTW_HEADER_TExhMon_private_h_ */
