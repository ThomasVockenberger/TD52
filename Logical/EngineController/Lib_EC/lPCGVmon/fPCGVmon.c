/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PCGVmon
 * File: fPCGVmon.c
 * Author: 105055527
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Thu Nov 26 09:45:08 2020
 * Model Version: 0.03
 * Description: Pre-chamber gas valve monitoring (sticking detection).

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    22.09.2020    Schmidt,   created initial model
   V0.02    15.10.2020    Schmidt,   modifications after code review / unit testing
   V0.03    26.11.2020    Schmidt,   perm's for class borders (no-hardcoded borders)
 ********************************************************************
 * Implementation of program PCGVmon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.2.0
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "PCGVmon.h"
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
void fPCGVmon(struct fPCGVmon* inst)
{
  tag_RTM_PCGVmon* const PCGVmon_M = &(inst)->bur_PCGVmon;
	inst->bur_PCGVmon.blockIO = &(inst)->bur_BlockIO_PCGVmon;
	inst->bur_PCGVmon.inputs = &(inst)->bur_ExternalInputs_PCGVmon;
	inst->bur_PCGVmon.outputs = &(inst)->bur_ExternalOutputs_PCGVmon;
	inst->bur_PCGVmon.dwork = &(inst)->bur_D_Work_PCGVmon;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    PCGVmon_initialize(PCGVmon_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    PCGVmon_step(PCGVmon_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    PCGVmon_terminate(PCGVmon_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 1.0s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A6.2.0 (28-May-2020)
 *****************************************************************************/

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.8 (R2020a)18-Nov-2019                                             *
 * Simulink 10.1 (R2020a)18-Nov-2019                                          *
 * Simulink Coder 9.3 (R2020a)18-Nov-2019                                     *
 * Embedded Coder 7.4 (R2020a)18-Nov-2019                                     *
 * Stateflow 10.2 (R2020a)18-Nov-2019                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
