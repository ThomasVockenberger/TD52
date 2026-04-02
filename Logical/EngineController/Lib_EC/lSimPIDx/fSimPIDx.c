/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: SimPIDBR6
 * File: fSimPIDx.c
 * Author: 105055527
 * Created: Tue Dec 06 16:11:54 2016
 ********************************************************************
 * Implementation of program SimPIDBR6
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "SimPIDBR6.h"
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

void fSimPIDx(struct fSimPIDx* inst)
{
  BlockIO_SimPIDBR6 *SimPIDBR6_B = &(inst)->bur_BlockIO_SimPIDBR6;
	D_Work_SimPIDBR6 *SimPIDBR6_DWork = &(inst)->bur_D_Work_SimPIDBR6;
	

  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    SimPIDBR6_initialize(SimPIDBR6_DWork, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    SimPIDBR6_step(SimPIDBR6_B, SimPIDBR6_DWork, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    SimPIDBR6_terminate(inst);
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
 * curve_fitting_toolbox                                                      *
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
