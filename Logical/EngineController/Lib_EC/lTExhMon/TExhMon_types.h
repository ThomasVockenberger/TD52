/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: TExhMon
 * File: TExhMon_types.h
 * Author: 120011115
 * Created: Mon Sep 05 16:14:57 2016
 ********************************************************************
 * Header for program TExhMon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_TExhMon_types_h_
#define RTW_HEADER_TExhMon_types_h_
#include "rtwtypes.h"
#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif









#ifndef _DEFINED_TYPEDEF_FOR_tTExhMon_PARA_Lim_
#define _DEFINED_TYPEDEF_FOR_tTExhMon_PARA_Lim_

typedef struct {
  real32_T tDelay_dTExhMon_Act_Lim;
  real32_T rdT_Ref_Max_Lim;
  real32_T rFiltTau_TExh_Lim;
  real32_T rdT2Exp_Max_Lim;
  real32_T tDelay_dTExhMon_Act_P_Lim;
  real32_T rTExhBound_SensScal_Lim;
} tTExhMon_PARA_Lim;

#endif
#endif                                 /* RTW_HEADER_TExhMon_types_h_ */
