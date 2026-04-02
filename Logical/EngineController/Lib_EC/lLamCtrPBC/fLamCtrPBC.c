/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: LamCtrPBC
 * File: fLamCtrPBC.c
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
 * Implementation of program LamCtrPBC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "LamCtrPBC.h"
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
void fLamCtrPBC(struct fLamCtrPBC* inst)
{
  tag_RTM_LamCtrPBC* const LamCtrPBC_M = &(inst)->bur_LamCtrPBC;
	inst->bur_LamCtrPBC.blockIO = &(inst)->bur_BlockIO_LamCtrPBC;
	inst->bur_LamCtrPBC.prevZCSigState = &(inst)->bur_PrevZCSigStates_LamCtrPBC;
	inst->bur_LamCtrPBC.inputs = &(inst)->bur_ExternalInputs_LamCtrPBC;
	inst->bur_LamCtrPBC.outputs = &(inst)->bur_ExternalOutputs_LamCtrPBC;
	inst->bur_LamCtrPBC.dwork = &(inst)->bur_D_Work_LamCtrPBC;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    LamCtrPBC_initialize(LamCtrPBC_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    LamCtrPBC_step(LamCtrPBC_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    LamCtrPBC_terminate(LamCtrPBC_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A6.4.1 (27-Apr-2021)
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
