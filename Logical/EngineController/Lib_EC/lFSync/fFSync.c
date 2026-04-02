/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: FSync
 * File: fFSync.c
 * Author: 105051359
 * Created: Mon Mar 13 15:42:43 2017
 ********************************************************************
 * Implementation of program FSync
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "FSync.h"
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

void fFSync(struct fFSync* inst)
{
  BlockIO_FSync *FSync_B = &(inst)->bur_BlockIO_FSync;
	D_Work_FSync *FSync_DWork = &(inst)->bur_D_Work_FSync;
	ExternalOutputs_FSync *FSync_Y = &(inst)->bur_ExternalOutputs_FSync;
	

  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    FSync_initialize(FSync_DWork, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    FSync_step(FSync_B, FSync_DWork, FSync_Y, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    FSync_terminate(inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A4.5.1 (27-Jul-2015)
 *****************************************************************************/

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 8.0 (R2012b)20-Jul-2012                                             *
 * Simulink 8.0 (R2012b)20-Jul-2012                                           *
 * Simulink Coder 8.3 (R2012b)20-Jul-2012                                     *
 * Embedded Coder 6.3 (R2012b)20-Jul-2012                                     *
 * Stateflow 8.0 (R2012b)20-Jul-2012                                          *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
