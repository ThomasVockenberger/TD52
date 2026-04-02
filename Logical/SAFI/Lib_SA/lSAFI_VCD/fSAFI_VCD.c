/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SAFI_VCD
 * File: fSAFI_VCD.c
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
 * Implementation of program SAFI_VCD
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.2.0
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "SAFI_VCD.h"
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
void fSAFI_VCD(struct fSAFI_VCD* inst)
{
  tag_RTM_SAFI_VCD* const SAFI_VCD_M = &(inst)->bur_SAFI_VCD;
	inst->bur_SAFI_VCD.blockIO = &(inst)->bur_BlockIO_SAFI_VCD;
	inst->bur_SAFI_VCD.inputs = &(inst)->bur_ExternalInputs_SAFI_VCD;
	inst->bur_SAFI_VCD.outputs = &(inst)->bur_ExternalOutputs_SAFI_VCD;
	inst->bur_SAFI_VCD.dwork = &(inst)->bur_D_Work_SAFI_VCD;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    SAFI_VCD_initialize(SAFI_VCD_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    SAFI_VCD_step(SAFI_VCD_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    SAFI_VCD_terminate(SAFI_VCD_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
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
 * signal_toolbox                                                             *
 * simulink                                                                   *
 *============================================================================*/
