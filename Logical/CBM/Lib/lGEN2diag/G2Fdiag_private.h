/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: G2Fdiag
 * File: G2Fdiag_private.h
 * Author: 106003773
 * Created: Wed Apr 20 16:09:39 2016
 ********************************************************************
 * Header for program G2Fdiag
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_G2Fdiag_private_h_
#define RTW_HEADER_G2Fdiag_private_h_
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

extern void G2Fdiag_TOF_Init(rtDW_TOF_G2Fdiag *localDW, struct fGEN2diag* inst);
extern void G2Fdiag_TOF(boolean_T rtu_IN, real_T rtu_PT, rtB_TOF_G2Fdiag *localB,
  rtDW_TOF_G2Fdiag *localDW, struct fGEN2diag* inst);
extern void G2Fdiag_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_G2Fdiag
  *localB, rtDW_TON_G2Fdiag *localDW, struct fGEN2diag* inst);
extern void G2Fdiag_EnabledSubsystem(boolean_T rtu_0, real_T rtu_1, real_T
  *rty_Out1, struct fGEN2diag* inst);
extern void G2Fdiag_TP_Init(rtDW_TP_G2Fdiag *localDW, struct fGEN2diag* inst);
extern void G2Fdiag_TP(boolean_T rtu_IN, real_T rtu_PT, rtB_TP_G2Fdiag *localB,
  rtDW_TP_G2Fdiag *localDW, struct fGEN2diag* inst);

#endif                                 /* RTW_HEADER_G2Fdiag_private_h_ */
