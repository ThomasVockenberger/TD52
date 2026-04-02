/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: TExhMon
 * File: fTExhMon.c
 * Author: 120011115
 * Created: Mon Sep 05 16:14:57 2016
 ********************************************************************
 * Implementation of program TExhMon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "TExhMon.h"
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

void fTExhMon(struct fTExhMon* inst)
{
  BlockIO_TExhMon *TExhMon_B = &(inst)->bur_BlockIO_TExhMon;
	D_Work_TExhMon *TExhMon_DWork = &(inst)->bur_D_Work_TExhMon;
	PrevZCSigStates_TExhMon *TExhMon_PrevZCSigState = &(inst)->bur_PrevZCSigStates_TExhMon;
	ExternalOutputs_TExhMon *TExhMon_Y = &(inst)->bur_ExternalOutputs_TExhMon;
	

  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    TExhMon_initialize(TExhMon_DWork, TExhMon_PrevZCSigState, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    TExhMon_step(TExhMon_B, TExhMon_DWork, TExhMon_PrevZCSigState, TExhMon_Y, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    TExhMon_terminate(inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 1.0s
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
