/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PCGVmon
 * File: PCGVmon_private.h
 * Author: 105055527
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Thu Nov 26 09:45:08 2020
 * Model Version: 0.03
 * Description: Pre-chamber gas valve monitoring (sticking detection).

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    22.09.2020    Schmidt,   created initial model
   V0.02    15.10.2020    Schmidt,   modifications after code review / unit testing
   V0.03    26.11.2020    Schmidt,   perm's for class borders (no-hardcoded borders)
 ********************************************************************
 * Header for program PCGVmon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.2.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_PCGVmon_private_h_
#define RTW_HEADER_PCGVmon_private_h_
#include "rtwtypes.h"
#include "PCGVmon.h"
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

extern void PCGVmon_setZero(const real32_T rtu_u[25], uint8_T rtu_numCyl,
  rtB_setZero_PCGVmon *localB, struct fPCGVmon* inst);
extern void PCGVmon_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_PCGVmon
  *localB, rtDW_TON_PCGVmon *localDW, struct fPCGVmon* inst);
extern void PCGVmon_MATLABFunction(real32_T rtu_u, boolean_T rtu_acive,
  rtB_MATLABFunction_PCGVmon *localB, struct fPCGVmon* inst);

#endif                                 /* RTW_HEADER_PCGVmon_private_h_ */
