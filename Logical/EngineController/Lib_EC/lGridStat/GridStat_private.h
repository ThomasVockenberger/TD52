/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: GridStat
 * File: GridStat_private.h
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

#ifndef RTW_HEADER_GridStat_private_h_
#define RTW_HEADER_GridStat_private_h_
#include "rtwtypes.h"
#include "zero_crossing_types.h"
#include "GridStat.h"
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

extern int32_T div_nde_s32_floor(int32_T numerator, int32_T denominator, struct fGridStat* inst);
extern void GridStat_TofLvrtWeakBlk1_Init(rtDW_TofLvrtWeakBlk1_GridStat *localDW, struct fGridStat* inst);
extern void GridStat_TofLvrtWeakBlk1(plcbit rtu_IN, real32_T rtu_PT,
  rtB_TofLvrtWeakBlk1_GridStat *localB, rtDW_TofLvrtWeakBlk1_GridStat *localDW, struct fGridStat* inst);
extern void GridS_TpDetNabsProtTrigger_Init(rtDW_TpDetNabsProtTrigger_GridS
  *localDW, struct fGridStat* inst);
extern void GridStat_TpDetNabsProtTrigger(plcbit rtu_IN, real32_T rtu_PT,
  rtB_TpDetNabsProtTrigger_GridSt *localB, rtDW_TpDetNabsProtTrigger_GridS
  *localDW, struct fGridStat* inst);

#endif                                 /* RTW_HEADER_GridStat_private_h_ */
