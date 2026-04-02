/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: LamCtrPBC
 * File: rt_defines.h
 * Author: kafkama00
 * Last modified by: kafkama00
 * Created: Mon Oct 11 17:08:29 2021
 * Last modified: Wed Dec 01 09:46:51 2021
 * Model Version: 1.00
 * Description: Lambda controller for pressure based control engines
 * modified Comment: V0.01 11.10.2021 created for first tests
   V0.02 12.10.2021 added debug signals
   V0.03 17.11.2021 added distortion rejection
   V1.00 01.12.2021 remove distortion rejection, serial release DIA.NE V4.11
 ********************************************************************
 * Header for program LamCtrPBC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
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
