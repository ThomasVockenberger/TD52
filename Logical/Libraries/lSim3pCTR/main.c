/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: Sim3pCTR
 * File: main.c
 * Author: 105051472
 * Created: Thu Jan 10 08:03:20 2013
 ********************************************************************
 * Implementation of program Sim3pCTR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V3.3
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "Sim3pCTR.h"
#include "rtwtypes.h"

BOOL bur_firsttime = TRUE;

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/
#ifdef __cplusplus

unsigned long bur_heap_size = 65535;

#endif

void Sim3pCTR(struct Sim3pCTR* inst)
{
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    Sim3pCTR_initialize(inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    Sim3pCTR_step(inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    Sim3pCTR_terminate(inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: V3.3.19 (13-Jun-2012)
 *****************************************************************************/

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 7.12 (R2011a)09-Mar-2011                                            *
 * Simulink 7.7 (R2011a)09-Mar-2011                                           *
 * Simulink Coder 8.0 (R2011a)09-Mar-2011                                     *
 * Embedded Coder 6.0 (R2011a)09-Mar-2011                                     *
 * Stateflow 7.7 (R2011a)09-Mar-2011                                          *
 * Simulink Fixed Point 6.5 (R2011a)09-Mar-2011                               *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 * stateflow                                                                  *
 *============================================================================*/
