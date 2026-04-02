/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_PFPDR
 * File: AC_PFPDR_private.h
 * Author: 502423184
 * Created: Fri Apr 24 12:55:11 2015
 ********************************************************************
 * Header for program AC_PFPDR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_AC_PFPDR_private_h_
#define RTW_HEADER_AC_PFPDR_private_h_
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

extern real_T rt_roundd(real_T u, struct PFPDR* inst);

/* Exported functions */
extern void AC_PFPDR_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_AC_PFPDR
  *localB, rtDW_TON_AC_PFPDR *localDW, struct PFPDR* inst);

#endif                                 /* RTW_HEADER_AC_PFPDR_private_h_ */
