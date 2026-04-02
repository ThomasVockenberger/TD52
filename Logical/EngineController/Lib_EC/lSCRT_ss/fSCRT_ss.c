/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SCRT_ss
 * File: fSCRT_ss.c
 * Author: 105055527
 * Last modified by: arnolge00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Fri Oct 01 08:40:23 2021
 * Model Version: 1.00
 * Description: Steady state detection for SCR inlet temperature controller vie ignition timing

   Outstandings:
   -------------
   - NA
 * modified Comment: V1.00  01.10.2021, Arnold, created
 ********************************************************************
 * Implementation of program SCRT_ss
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.0
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "SCRT_ss.h"
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
void fSCRT_ss(struct fSCRT_ss* inst)
{
  tag_RTM_SCRT_ss* const SCRT_ss_M = &(inst)->bur_SCRT_ss;
	inst->bur_SCRT_ss.blockIO = &(inst)->bur_BlockIO_SCRT_ss;
	inst->bur_SCRT_ss.inputs = &(inst)->bur_ExternalInputs_SCRT_ss;
	inst->bur_SCRT_ss.outputs = &(inst)->bur_ExternalOutputs_SCRT_ss;
	inst->bur_SCRT_ss.dwork = &(inst)->bur_D_Work_SCRT_ss;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    SCRT_ss_initialize(SCRT_ss_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    SCRT_ss_step(SCRT_ss_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    SCRT_ss_terminate(SCRT_ss_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A6.3.0 (23-Oct-2020)
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
