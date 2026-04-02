/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_SS
 * File: AC_SS_private.h
 * Author: 105055527
 * Created: Thu May 19 13:50:06 2016
 ********************************************************************
 * Header for program AC_SS
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V5.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_AC_SS_private_h_
#define RTW_HEADER_AC_SS_private_h_
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

extern void AC_SS_Filter_Init(real32_T rtu_x0, rtDW_Filter_AC_SS *localDW, struct SS* inst);
extern void AC_SS_Filter(real32_T rtu_in, real32_T rtu_T_filt, boolean_T
  rtu_reset, real32_T rtu_x0, rtB_Filter_AC_SS *localB, rtDW_Filter_AC_SS
  *localDW, struct SS* inst);

#endif                                 /* RTW_HEADER_AC_SS_private_h_ */
