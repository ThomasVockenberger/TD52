/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: UDC
 * File: UDC_private.h
 * Author: 105055527
 * Created: Thu Mar 02 16:51:06 2017
 ********************************************************************
 * Header for program UDC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_UDC_private_h_
#define RTW_HEADER_UDC_private_h_
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

void BINARYSEARCH_real32_T(uint32_T *piLeft, uint32_T *piRght, real32_T u, const
  real32_T *pData, uint32_T iHi, struct fUDC* inst);
void LookUp_real32_T_real32_T(real32_T *pY, const real32_T *pYData, real32_T u,
  const real32_T *pUData, uint32_T iHi, struct fUDC* inst);
void BINARYSEARCH_real32_Treal_T(uint32_T *piLeft, uint32_T *piRght, real32_T u,
  const real_T *pData, uint32_T iHi, struct fUDC* inst);
void LookUp_real32_T_real32_Treal_T(real32_T *pY, const real32_T *pYData,
  real32_T u, const real_T *pUData, uint32_T iHi, struct fUDC* inst);
extern uint32_T plook_u32ff_binca(real32_T u, const real32_T bp[], uint32_T
  maxIndex, real32_T *fraction, struct fUDC* inst);
extern real32_T intrp2d_if_u32f_la_pw(const uint32_T bpIndex[], const real32_T
  frac[], const real32_T table[], uint32_T stride, const uint32_T maxIndex[], struct fUDC* inst);
extern uint32_T binsearch_u32f(real32_T u, const real32_T bp[], uint32_T
  startIndex, uint32_T maxIndex, struct fUDC* inst);
extern void UDC_Cell1_Init(rtDW_Cell1_UDC *localDW, struct fUDC* inst);
extern void UDC_Cell1(real32_T rtu_mdotExhWetkgs, real32_T rtu_cpExhJkgK,
                      real32_T rtu_TgSCRInC, real32_T rtu_haWm2K, real32_T
                      rtu_ACatm2, boolean_T rtu_Resetbool, real32_T rtu_I0C,
                      real32_T rtu_TambC, real32_T rtu_mCatkg, real32_T
                      rtu_cCatJkgK, const real32_T rtu_rNH3StorMap_x[5], const
                      real32_T rtu_rNH3StorMap_y[5], rtB_Cell1_UDC *localB,
                      rtDW_Cell1_UDC *localDW, struct fUDC* inst);
extern void UDC_Filter_Init(rtDW_Filter_UDC *localDW, struct fUDC* inst);
extern void UDC_Filter(real32_T rtu_T_filt, boolean_T rtu_reset, real32_T rtu_x0,
  rtB_Filter_UDC *localB, rtDW_Filter_UDC *localDW, struct fUDC* inst);
extern void UDC_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_UDC *localB,
                    rtDW_TON_UDC *localDW, struct fUDC* inst);
extern void UDC_EnabledSubsystem(boolean_T rtu_0, real32_T rtu_1, real32_T
  *rty_Out1, struct fUDC* inst);
extern void UDC_TP_Init(rtDW_TP_UDC *localDW, struct fUDC* inst);
extern void UDC_TP(boolean_T rtu_IN, real32_T rtu_PT, rtB_TP_UDC *localB,
                   rtDW_TP_UDC *localDW, struct fUDC* inst);
extern void UDC_TOF_Init(rtDW_TOF_UDC *localDW, struct fUDC* inst);
extern void UDC_TOF(boolean_T rtu_IN, real_T rtu_PT, rtB_TOF_UDC *localB,
                    rtDW_TOF_UDC *localDW, struct fUDC* inst);

#endif                                 /* RTW_HEADER_UDC_private_h_ */
