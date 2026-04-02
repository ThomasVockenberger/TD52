/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: HiContr
 * File: main.c
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Implementation of program HiContr
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "HiContr.h"
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

void HiContr(struct HiContr* inst)
{
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    HiContr_initialize(inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    HiContr_step(inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    HiContr_terminate(inst);
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
 * MATLAB 8.0 (R2012b)20-Jul-2012                                             *
 * Simulink 8.0 (R2012b)20-Jul-2012                                           *
 * Simulink Coder 8.3 (R2012b)20-Jul-2012                                     *
 * Embedded Coder 6.3 (R2012b)20-Jul-2012                                     *
 * Stateflow 8.0 (R2012b)20-Jul-2012                                          *
 * Simulink Fixed Point 7.2 (R2012b)20-Jul-2012                               *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
