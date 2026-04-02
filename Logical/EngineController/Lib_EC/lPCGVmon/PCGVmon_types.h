/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PCGVmon
 * File: PCGVmon_types.h
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

#ifndef RTW_HEADER_PCGVmon_types_h_
#define RTW_HEADER_PCGVmon_types_h_
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









#ifndef struct_emxArray_int32_T_25
#define struct_emxArray_int32_T_25


#endif                                 /*struct_emxArray_int32_T_25*/

#ifndef typedef_emxArray_int32_T_25_PCGVmon
#define typedef_emxArray_int32_T_25_PCGVmon



#endif                                 /*typedef_emxArray_int32_T_25_PCGVmon*/

/* Forward declaration for rtModel */


#endif                                 /* RTW_HEADER_PCGVmon_types_h_ */
