/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: DAI
 * File: rtwtypes.h
 * Author: 105055527
 * Last modified by: cadm_kafkama00
 * Created: Sat Nov 11 23:05:34 2017
 * Last modified: Wed Oct 02 14:21:06 2024
 * Model Version: 4.14
 * Description: Direct Air Injection for J920 Faststart

   History:

   V0.02  Arnold, 27.11.2017,  tech demonstrator @ P20
   V0.03  Arnold, 24.10.2018,  rename from AirAss to DAI
   V0.04  Arnold, 24.10.2018,  deleted exhaust side DAI, deleted intake dynamics
   V0.05  Arnold, 14.08.2019,  unit testing done, pre-release for Pforzheim P21
   V0.06  Kafka, 20.09.2019, bug fix for testbench manual massflow testing
   V0.07  Kafka, 01.10.2019, massflow limitations changed from per valve to total massflow
   V0.08  Kafka, 02.10.2019, mass flow limitation over boost pressure removed for speed ramp
   V0.09  Kafka, 14.10.2019, disable for negative power trajectory is added in the enable subblock
   V0.10  Kafka, 18.12.2019, disable on speed hysteresis during speed ramp
   V4.14  Kafka, 06.09.2024, update to Matlab Version 2021b


 * modified Comment:
 ********************************************************************
 * Header for program DAI
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#ifndef RTWTYPES_H
#define RTWTYPES_H

/* Logical type definitions */
#if (!defined(__cplusplus))
#ifndef false
#define false                          (0U)
#endif

#ifndef true
#define true                           (1U)
#endif
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
