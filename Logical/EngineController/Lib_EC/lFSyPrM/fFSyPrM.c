/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: FSyPrM
 * File: fFSyPrM.c
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
 * Implementation of program FSyPrM
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.1
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "FSyPrM.h"
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
void fFSyPrM(struct fFSyPrM* inst)
{
  tag_RTM_FSyPrM* const FSyPrM_M = &(inst)->bur_FSyPrM;
	inst->bur_FSyPrM.blockIO = &(inst)->bur_BlockIO_FSyPrM;
	inst->bur_FSyPrM.inputs = &(inst)->bur_ExternalInputs_FSyPrM;
	inst->bur_FSyPrM.outputs = &(inst)->bur_ExternalOutputs_FSyPrM;
	inst->bur_FSyPrM.dwork = &(inst)->bur_D_Work_FSyPrM;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    FSyPrM_initialize(FSyPrM_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    FSyPrM_step(FSyPrM_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    FSyPrM_terminate(FSyPrM_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A6.3.1 (15-Dec-2020)
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
