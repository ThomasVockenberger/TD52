/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LamStart
 * File: fLamStart.c
 * Author: 105055527
 * Created: Thu May 18 17:26:11 2017
 ********************************************************************
 * Implementation of program LamStart
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "LamStart.h"
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

void fLamStart(struct fLamStart* inst)
{
  BlockIO_LamStart *LamStart_B = &(inst)->bur_BlockIO_LamStart;
	D_Work_LamStart *LamStart_DWork = &(inst)->bur_D_Work_LamStart;
	PrevZCSigStates_LamStart *LamStart_PrevZCSigState = &(inst)->bur_PrevZCSigStates_LamStart;
	ExternalOutputs_LamStart *LamStart_Y = &(inst)->bur_ExternalOutputs_LamStart;
	

  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    LamStart_initialize(LamStart_DWork, LamStart_PrevZCSigState, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    LamStart_step(LamStart_B, LamStart_DWork, LamStart_PrevZCSigState,
                  LamStart_Y, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    LamStart_terminate(inst);
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
