/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PUscuff
 * File: PUscuff_private.h
 * Author: 212442560
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Wed Nov 10 09:52:05 2021
 * Model Version: 0.06
 * Description: PU scuffing detection.

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    17.05.2021    Schmidt,   created initial model
   V0.02    04.08.2021    Schmidt,   model cleanup
   V0.03    31.08.2021    Schmidt,   new version after model/code review (replaced 'Tapped Delay' blocks, para name changes)
   V0.04    09.09.2021    Schmidt,   modifications after P6 validation (parameter cleanup, added trip release delay)
   V0.05    29.09.2021    Schmidt,   added debug outputs (bLearnReactAfterKnock, rP2s_filt_contLearn)
   V0.06    10.11.2021    Schmidt,   knock anomaly det.: filtering probability, threshold change
   IO sample rate corrections (Ts=100ms)
 ********************************************************************
 * Header for program PUscuff
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_PUscuff_private_h_
#define RTW_HEADER_PUscuff_private_h_
#include "rtwtypes.h"
#include "PUscuff.h"
#include <bur/plctypes.h>
#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

#ifndef AST_ROUND
#define AST_ROUND(x)                   ((x)>=0?(long long)((x)+0.5):(long long)((x)-0.5))
#endif

extern void PUscuff_Filter2_Init(rtDW_Filter2_PUscuff *localDW, struct fPUscuff* inst);
extern void PUscuff_Filter2(real32_T rtu_in, real32_T rtu_T_filt, boolean_T
  rtu_reset, rtB_Filter2_PUscuff *localB, rtDW_Filter2_PUscuff *localDW, struct fPUscuff* inst);
extern void PUscuff_TON1(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON1_PUscuff
  *localB, rtDW_TON1_PUscuff *localDW, struct fPUscuff* inst);
extern void PUscuff_MATLABFunction11(const boolean_T rtu_u[25], uint8_T
  rtu_numCyl, rtB_MATLABFunction11_PUscuff *localB, struct fPUscuff* inst);
extern void PUscuff_Filter1_Init(rtDW_Filter1_PUscuff *localDW, struct fPUscuff* inst);
extern void PUscuff_Filter1(real32_T rtu_in, boolean_T rtu_reset,
  rtB_Filter1_PUscuff *localB, const rtC_Filter1_PUscuff *localC,
  rtDW_Filter1_PUscuff *localDW, struct fPUscuff* inst);

#endif                                 /* RTW_HEADER_PUscuff_private_h_ */
