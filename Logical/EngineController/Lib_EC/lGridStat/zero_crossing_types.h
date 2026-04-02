/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: GridStat
 * File: zero_crossing_types.h
 * Author: 105055527
 * Last modified by: cadm_kafkama00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Tue Nov 26 15:54:38 2024
 * Model Version: 2.02
 * Description: Detection Algorithm for grid connection.

   HISTORY:
   V1.00  24.07.2020 Keller   created
   V1.01  07.08.2020 Huber  included function block from simulation
   V1.02  29.04.2021 Denk   VectorShift and LVRT function added
   V1.03  31.01.2022 Keller  add input for GCB_On

   V2.00  10.08.2023 Walch  Revision of parametrization, sensitivity and FRT selectivity
   V2.01  22.11.2023 Walch  Include grid observer
   10.01.2024 Walch  Include TP LVRT hold time for weak LVRT blocking
   V2.02  25.11.2024 Walch  Update grid observer for SS mains parallel vs. island plausibility check
 * modified Comment:
 ********************************************************************
 * Header for program GridStat
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
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
