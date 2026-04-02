/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SCRT_ss
 * File: SCRT_ss_private.h
 * Author: 105055527
 * Last modified by: arnolge00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Fri Oct 01 08:40:23 2021
 * Model Version: 1.00
 * Description: Steady state detection for SCR inlet temperature controller vie ignition timing

   Outstandings:
   -------------
   - NA
 * modified Comment: V1.00  01.10.2021, Arnold, created
 ********************************************************************
 * Header for program SCRT_ss
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_SCRT_ss_private_h_
#define RTW_HEADER_SCRT_ss_private_h_
#include "rtwtypes.h"
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
#endif                                 /* RTW_HEADER_SCRT_ss_private_h_ */
