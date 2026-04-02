/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PUscuff
 * File: fPUscuff.c
 * Author: 212442560
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Wed Nov 10 09:52:05 2021
 * Model Version: 0.06
 * Description: PU scuffing detection.

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    17.05.2021    Schmidt,   created initial model
   V0.02    04.08.2021    Schmidt,   model cleanup
   V0.03    31.08.2021    Schmidt,   new version after model/code review (replaced 'Tapped Delay' blocks, para name changes)
   V0.04    09.09.2021    Schmidt,   modifications after P6 validation (parameter cleanup, added trip release delay)
   V0.05    29.09.2021    Schmidt,   added debug outputs (bLearnReactAfterKnock, rP2s_filt_contLearn)
   V0.06    10.11.2021    Schmidt,   knock anomaly det.: filtering probability, threshold change
   IO sample rate corrections (Ts=100ms)
 ********************************************************************
 * Implementation of program PUscuff
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "PUscuff.h"
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
void fPUscuff(struct fPUscuff* inst)
{
  tag_RTM_PUscuff* const PUscuff_M = &(inst)->bur_PUscuff;
	inst->bur_PUscuff.blockIO = &(inst)->bur_BlockIO_PUscuff;
	inst->bur_PUscuff.inputs = &(inst)->bur_ExternalInputs_PUscuff;
	inst->bur_PUscuff.outputs = &(inst)->bur_ExternalOutputs_PUscuff;
	inst->bur_PUscuff.dwork = &(inst)->bur_D_Work_PUscuff;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    PUscuff_initialize(PUscuff_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    PUscuff_step(PUscuff_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    PUscuff_terminate(PUscuff_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.099999999999999992s
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
