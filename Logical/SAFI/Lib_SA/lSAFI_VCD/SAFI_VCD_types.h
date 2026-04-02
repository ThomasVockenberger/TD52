/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SAFI_VCD
 * File: SAFI_VCD_types.h
 * Author: 105055527
 * Last modified by: andreme00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Thu Sep 10 09:08:42 2020
 * Model Version: 1.04
 * Description: Post processing algorithm of the SAFI 2 KLS valve closure timing detection feature.

   Outstandings:
   -------------
   - NA
 * modified Comment: V1.00  31.01.2019  Andre   Generated
   V1.01  20.03.2019  Arnold  Generate reusable code
   V1.02  19.03.2020  Andre   Added detection of the 2nd highest peak for unbalanced valve detection (Development version)
   V1.03  31.07.2020  Andre   Corrected unbalance valve detection. Added reset.
   V1.04  10.09.2020  Andre   Do not fill up the VecVC array with value within first degrees of window. Use the min detection percentage on both peaks.
 ********************************************************************
 * Header for program SAFI_VCD
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.2.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_SAFI_VCD_types_h_
#define RTW_HEADER_SAFI_VCD_types_h_
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


#endif                                 /* RTW_HEADER_SAFI_VCD_types_h_ */
