/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: FSyPrM
 * File: FSyPrM_types.h
 * Author: 105055527
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Mon Jan 25 17:32:20 2021
 * Model Version: 0.08
 * Description: Fast synchronization controller for pre-mixed engines.

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    30.03.2020    Schmidt,   project/controller carryover from FSync to FSyncPrM
   V0.02    02.04.2020    Schmidt,   cleanup and deletion of functions not used by pre-mixed engines
   V0.03    12.05.2020    Schmidt,   upgrade to MATLAB/SIMULINK R2020a
   V0.04    14.05.2020    Schmidt,   B&R blocks upgrade to AS Target v6.2.0 (officially supports MATLAB 2020a)
   V0.05    03.08.2020    Schmidt,   changed speed reference for function activation from nominal speed (parameter) to bus bar frequency
   added detection for speed exceedance --> switch over to standard idle controller
   V0.06    04.08.2020    Schmidt,   moved function activation from PARA bus to IN bus
   V0.07    17.08.2020    Schmidt,   included modifications after P6 tests
   V0.08    25.01.2021    Schmidt,   use of frequency based speed set-point (rN_Set) only if rF_MMD_BusBar > 0.5*rF_Nom
 ********************************************************************
 * Header for program FSyPrM
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.1
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_FSyPrM_types_h_
#define RTW_HEADER_FSyPrM_types_h_
#include "rtwtypes.h"

/* Model Code Variants */
#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

#ifndef AST_ROUND
#define AST_ROUND(x)                   ((x)>=0?(long long)((x)+0.5):(long long)((x)-0.5))
#endif









/* Forward declaration for rtModel */


#endif                                 /* RTW_HEADER_FSyPrM_types_h_ */
