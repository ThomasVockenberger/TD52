/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: UDC
 * File: rtGetInf.h
 * Author: 105055527
 * Created: Thu Mar 02 16:51:06 2017
 ********************************************************************
 * Header for program UDC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_rtGetInf_h_
#define RTW_HEADER_rtGetInf_h_
#include <stddef.h>
#include "rtwtypes.h"
#include "rt_nonfinite.h"
#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

extern real_T rtGetInf(void);
extern real32_T rtGetInfF(void);
extern real_T rtGetMinusInf(void);
extern real32_T rtGetMinusInfF(void);

#endif                                 /* RTW_HEADER_rtGetInf_h_ */
