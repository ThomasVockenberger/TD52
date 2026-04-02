/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LX2
 * File: LX2_private.h
 * Author: 212566120
 * Created: Wed Apr 11 13:34:17 2018
 ********************************************************************
 * Header for program LX2
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_LX2_private_h_
#define RTW_HEADER_LX2_private_h_
#include "rtwtypes.h"
#include <bur/plctypes.h>
#ifndef UCHAR_MAX
#include <limits.h>
#endif

#if ( UCHAR_MAX != (0xFFU) ) || ( SCHAR_MAX != (0x7F) )
#error "Code was generated for compiler with different sized uchar/char. Consider adjusting Emulation Hardware word size settings on the Hardware Implementation pane to match your compiler word sizes as defined in the compiler's limits.h header file. Alternatively, you can select 'None' for Emulation Hardware and select the 'Enable portable word sizes' option for ERT based targets, which will disable the preprocessor word size checks."
#endif

#if ( USHRT_MAX != (0xFFFFU) ) || ( SHRT_MAX != (0x7FFF) )
#error "Code was generated for compiler with different sized ushort/short. Consider adjusting Emulation Hardware word size settings on the Hardware Implementation pane to match your compiler word sizes as defined in the compilers limits.h header file. Alternatively, you can select 'None' for Emulation Hardware and select the 'Enable portable word sizes' option for ERT based targets, this will disable the preprocessor word size checks."
#endif

#if ( UINT_MAX != (0xFFFFFFFFU) ) || ( INT_MAX != (0x7FFFFFFF) )
#error "Code was generated for compiler with different sized uint/int. Consider adjusting Emulation Hardware word size settings on the Hardware Implementation pane to match your compiler word sizes as defined in the compilers limits.h header file. Alternatively, you can select 'None' for Emulation Hardware and select the 'Enable portable word sizes' option for ERT based targets, this will disable the preprocessor word size checks."
#endif

#if ( ULONG_MAX != (0xFFFFFFFFU) ) || ( LONG_MAX != (0x7FFFFFFF) )
#error "Code was generated for compiler with different sized ulong/long. Consider adjusting Emulation Hardware word size settings on the Hardware Implementation pane to match your compiler word sizes as defined in the compilers limits.h header file. Alternatively, you can select 'None' for Emulation Hardware and select the 'Enable portable word sizes' option for ERT based targets, this will disable the preprocessor word size checks."
#endif

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

extern real32_T rt_roundf(real32_T u, struct fLX2* inst);

/* Exported functions */
void BINARYSEARCH_real32_T(uint32_T *piLeft, uint32_T *piRght, real32_T u, const
  real32_T *pData, uint32_T iHi, struct fLX2* inst);
void LookUp_real32_T_real32_T(real32_T *pY, const real32_T *pYData, real32_T u,
  const real32_T *pUData, uint32_T iHi, struct fLX2* inst);
extern void LX2_BoostPressureOffsetCurve(real32_T rtu_x, real32_T rtu_y, const
  real32_T rtu_IN_offset[11], const boolean_T rtu_IN_measured[11], const
  real32_T rtu_LPs[3], boolean_T rtu_Lp_c_ena, real32_T rtu_s_max, real32_T
  rtu_s_maxEx, uint16_T rtu_w1, uint16_T rtu_w2, uint16_T rtu_w3, uint16_T
  rtu_w4, real32_T rtu_limit_value, boolean_T rtu_Enable,
  rtB_BoostPressureOffsetCurve_LX *localB, struct fLX2* inst);
extern void LX2_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_LX2 *localB,
                    rtDW_TON_LX2 *localDW, struct fLX2* inst);
extern void LX2_Filter1_Init(rtDW_Filter1_LX2 *localDW, struct fLX2* inst);
extern void LX2_Filter1(uint16_T rtu_T_filt, boolean_T rtu_reset, real32_T
  rtu_x0, rtB_Filter1_LX2 *localB, rtDW_Filter1_LX2 *localDW, struct fLX2* inst);

#endif                                 /* RTW_HEADER_LX2_private_h_ */
