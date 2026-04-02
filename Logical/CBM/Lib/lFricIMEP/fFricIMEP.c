/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: J920_fric
 * File: fFricIMEP.c
 * Author: 212348321
 * Created: Mon Jun 13 15:26:38 2016
 ********************************************************************
 * Implementation of program J920_fric
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "J920_fric.h"
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

void fFricIMEP(struct fFricIMEP* inst)
{
  B_J920_fric *J920_fric_B = &(inst)->bur_B_J920_fric;
	DW_J920_fric *J920_fric_DW = &(inst)->bur_DW_J920_fric;
	ExtY_J920_fric *J920_fric_Y = &(inst)->bur_ExtY_J920_fric;
	

  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    J920_fric_initialize(J920_fric_DW, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    J920_fric_step(J920_fric_B, J920_fric_DW, J920_fric_Y, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    J920_fric_terminate(inst);
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
