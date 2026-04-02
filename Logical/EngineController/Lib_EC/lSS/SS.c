/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AC_SS
 * File: SS.c
 * Author: 105055527
 * Created: Thu May 19 13:50:06 2016
 ********************************************************************
 * Implementation of program AC_SS
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V5.0
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "AC_SS.h"
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

void SS(struct SS* inst)
{
/*  tag_RTM_AC_SS* const AC_SS_M = &(inst)->bur_AC_SS;	*/
	BlockIO_AC_SS *AC_SS_B = &(inst)->bur_BlockIO_AC_SS;
	D_Work_AC_SS *AC_SS_DWork = &(inst)->bur_D_Work_AC_SS;
	ExternalOutputs_AC_SS *AC_SS_Y = &(inst)->bur_ExternalOutputs_AC_SS;
	

  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    AC_SS_initialize(AC_SS_DWork, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    AC_SS_step(AC_SS_B, AC_SS_DWork, AC_SS_Y, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    AC_SS_terminate(inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A5.1.0 (06-May-2016)
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
