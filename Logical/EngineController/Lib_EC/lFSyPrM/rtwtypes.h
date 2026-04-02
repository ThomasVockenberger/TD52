/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: FSyPrM
 * File: rtwtypes.h
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

#ifndef RTWTYPES_H
#define RTWTYPES_H

/* Logical type definitions */
#if (!defined(__cplusplus))
#  ifndef false
#   define false                       (0U)
#  endif

#  ifndef true
#   define true                        (1U)
#  endif
#endif

/*=======================================================================*
 * Target hardware information
 *   Device type: Intel->x86/Pentium
 *   Number of bits:     char:   8    short:   16    long:  32
 *                       long:  32
 *                       native word size:  32
 *   Byte ordering: LittleEndian
 *   Signed integer division rounds to: Zero
 *   Shift right on a signed integer as arithmetic shift: on
 *=======================================================================*/

/*=======================================================================*
 * Fixed width word size data types:                                     *
 *   int8_T, int16_T, int32_T     - signed 8, 16, or 32 bit integers     *
 *   uint8_T, uint16_T, uint32_T  - unsigned 8, 16, or 32 bit integers   *
 *   real32_T, real64_T           - 32 and 64 bit floating point numbers *
 *=======================================================================*/
typedef signed char int8_T;
typedef unsigned char uint8_T;
typedef short int16_T;
typedef unsigned short uint16_T;
typedef long int32_T;
typedef unsigned long uint32_T;
typedef float real32_T;
typedef double real64_T;

/*===========================================================================*
 * Generic type definitions: boolean_T, char_T, byte_T, int_T, uint_T,       *
 *                           real_T, time_T, ulong_T.                        *
 *===========================================================================*/
typedef double real_T;
typedef double time_T;
typedef unsigned char boolean_T;
typedef long int_T;
typedef unsigned long uint_T;
typedef unsigned long ulong_T;
typedef char char_T;
typedef unsigned char uchar_T;
typedef char_T byte_T;

/*=======================================================================*
 * Min and Max:                                                          *
 *   int8_T, int16_T, int32_T     - signed 8, 16, or 32 bit integers     *
 *   uint8_T, uint16_T, uint32_T  - unsigned 8, 16, or 32 bit integers   *
 *=======================================================================*/
#define MAX_int8_T                     ((int8_T)(127))
#define MIN_int8_T                     ((int8_T)(-128))
#define MAX_uint8_T                    ((uint8_T)(255U))
#define MAX_int16_T                    ((int16_T)(32767))
#define MIN_int16_T                    ((int16_T)(-32768))
#define MAX_uint16_T                   ((uint16_T)(65535U))
#define MAX_int32_T                    ((int32_T)(2147483647))
#define MIN_int32_T                    ((int32_T)(-2147483647-1))
#define MAX_uint32_T                   ((uint32_T)(0xFFFFFFFFU))

/* Block D-Work pointer type */
typedef void * pointer_T;

#endif                                 /* RTWTYPES_H */

#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

#ifndef AST_ROUND
#define AST_ROUND(x)                   ((x)>=0?(long long)((x)+0.5):(long long)((x)-0.5))
#endif
