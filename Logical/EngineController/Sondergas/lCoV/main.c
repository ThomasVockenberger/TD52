/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: CoV_24Cyl
 * File: main.c
 * Author: 105055527
 * Created: Tue Sep 23 05:31:36 2014
 ********************************************************************
 * Implementation of program CoV_24Cyl
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "CoV_24Cyl.h"
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

void CoV(struct CoV* inst)
{
  
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    CoV_24Cyl_initialize(inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    CoV_24Cyl_step(inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    CoV_24Cyl_terminate(inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.08s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A4.3.1 (09-Apr-2014)
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
