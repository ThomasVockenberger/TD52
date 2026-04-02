/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: SimPID4
 * File: main.c
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Implementation of program SimPID4
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "SimPID4.h"
#include "rtwtypes.h"

BOOL bur_firsttime = TRUE;

/*  Defines */
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

void SimPID4(struct SimPID4* inst)
{
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    SimPID4_initialize(inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    SimPID4_step(inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    SimPID4_terminate(inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A4.2.11 (15-Jan-2014)
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
 *============================================================================*/
