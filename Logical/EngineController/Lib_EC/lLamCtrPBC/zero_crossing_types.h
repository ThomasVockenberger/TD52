/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: LamCtrPBC
 * File: zero_crossing_types.h
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

#ifndef ZERO_CROSSING_TYPES_H
#define ZERO_CROSSING_TYPES_H
#include "rtwtypes.h"

/* Trigger directions: falling, either, and rising */
typedef enum {
  FALLING_ZERO_CROSSING = -1,
  ANY_ZERO_CROSSING = 0,
  RISING_ZERO_CROSSING = 1
} ZCDirection;

/* Previous state of a trigger signal */
typedef uint8_T ZCSigState;

/* Initial value of a trigger zero crossing signal */
#define UNINITIALIZED_ZCSIG            0x03U
#define NEG_ZCSIG                      0x02U
#define POS_ZCSIG                      0x01U
#define ZERO_ZCSIG                     0x00U

/* Current state of a trigger signal */
typedef enum {
  FALLING_ZCEVENT = -1,
  NO_ZCEVENT = 0,
  RISING_ZCEVENT = 1
} ZCEventType;

#endif                                 /* ZERO_CROSSING_TYPES_H */

#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

#ifndef AST_ROUND
#define AST_ROUND(x)                   ((x)>=0?(long long)((x)+0.5):(long long)((x)-0.5))
#endif
