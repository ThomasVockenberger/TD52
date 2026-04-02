/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: CPP_Int
 * File: fCPP_Int.c
 * Author: Messner
 * Created: Fri Nov 24 07:48:45 2017
 ********************************************************************
 * Implementation of program CPP_Int
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "CPP_Int.h"
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

void fCPP_Int(struct fCPP_Int* inst)
{
  BlockIO_CPP_Int *CPP_Int_B = &(inst)->bur_BlockIO_CPP_Int;
	D_Work_CPP_Int *CPP_Int_DWork = &(inst)->bur_D_Work_CPP_Int;
	PrevZCSigStates_CPP_Int *CPP_Int_PrevZCSigState = &(inst)->bur_PrevZCSigStates_CPP_Int;
	ExternalOutputs_CPP_Int *CPP_Int_Y = &(inst)->bur_ExternalOutputs_CPP_Int;
	

  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    CPP_Int_initialize(CPP_Int_PrevZCSigState, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    CPP_Int_step(CPP_Int_B, CPP_Int_DWork, CPP_Int_PrevZCSigState, CPP_Int_Y, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    CPP_Int_terminate(inst);
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
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
