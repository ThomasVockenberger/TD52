/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SAFI_VCD
 * File: rt_defines.h
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

#ifndef RTW_HEADER_rt_defines_h_
#define RTW_HEADER_rt_defines_h_
#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

#ifndef AST_ROUND
#define AST_ROUND(x)                   ((x)>=0?(long long)((x)+0.5):(long long)((x)-0.5))
#endif

/*===========*
 * Constants *
 *===========*/
#define RT_PI                          3.14159265358979323846
#define RT_PIF                         3.1415927F
#define RT_LN_10                       2.30258509299404568402
#define RT_LN_10F                      2.3025851F
#define RT_LOG10E                      0.43429448190325182765
#define RT_LOG10EF                     0.43429449F
#define RT_E                           2.7182818284590452354
#define RT_EF                          2.7182817F

/*
 * UNUSED_PARAMETER(x)
 *   Used to specify that a function parameter (argument) is required but not
 *   accessed by the function body.
 */
#ifndef UNUSED_PARAMETER
# if defined(__LCC__)
#   define UNUSED_PARAMETER(x)                                   /* do nothing */
# else

/*
 * This is the semi-ANSI standard way of indicating that an
 * unused function parameter is required.
 */
#   define UNUSED_PARAMETER(x)         (void) (x)
# endif
#endif
#endif                                 /* RTW_HEADER_rt_defines_h_ */
