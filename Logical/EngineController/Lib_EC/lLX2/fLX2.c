/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LX2
 * File: fLX2.c
 * Author: 212566120
 * Created: Wed Apr 11 13:34:17 2018
 ********************************************************************
 * Implementation of program LX2
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "LX2.h"
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

void fLX2(struct fLX2* inst)
{
  
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    LX2_initialize(inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    LX2_step(inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    LX2_terminate(inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.099999999999999992s
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
