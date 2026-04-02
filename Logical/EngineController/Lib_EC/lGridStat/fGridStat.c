/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: GridStat
 * File: fGridStat.c
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
 * Implementation of program GridStat
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "GridStat.h"
#include "rtwtypes.h"

/* Defines */
#define SS_TERMINATE 4
#define SS_OUTPUT 3
#define SS_INITIALIZE 2


/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/
#ifdef __cplusplus

unsigned long bur_heap_size = 6553500;

#endif

/*LEGACYMODE_VARIABLES*/
void fGridStat(struct fGridStat* inst)
{
  tag_RTM_GridStat* const GridStat_M = &(inst)->bur_GridStat;
	inst->bur_GridStat.blockIO = &(inst)->bur_BlockIO_GridStat;
	inst->bur_GridStat.prevZCSigState = &(inst)->bur_PrevZCSigStates_GridStat;
	inst->bur_GridStat.outputs = &(inst)->bur_ExternalOutputs_GridStat;
	inst->bur_GridStat.dwork = &(inst)->bur_D_Work_GridStat;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    GridStat_initialize(GridStat_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    GridStat_step(GridStat_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    GridStat_terminate(GridStat_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A6.7.1 (02-Dec-2022)
 *****************************************************************************/

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.11 (R2021b)14-May-2021                                            *
 * Simulink 10.4 (R2021b)14-May-2021                                          *
 * Simulink Coder 9.6 (R2021b)14-May-2021                                     *
 * Embedded Coder 7.7 (R2021b)14-May-2021                                     *
 * Stateflow 10.5 (R2021b)14-May-2021                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
