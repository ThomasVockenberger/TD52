/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: MeNoiAL
 * File: fMeNoiAL.c
 * Author: 120011115
 * Created: Mon Sep 05 16:14:57 2016
 ********************************************************************
 * Implementation of program MeNoiAL
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include <bur/plctypes.h>
#include "MeNoiAL.h"
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

void fMeNoiAL(struct fMeNoiAL* inst)
{
  BlockIO_MeNoiAL *MeNoiAL_B = &(inst)->bur_BlockIO_MeNoiAL;
	D_Work_MeNoiAL *MeNoiAL_DWork = &(inst)->bur_D_Work_MeNoiAL;
	ExternalOutputs_MeNoiAL *MeNoiAL_Y = &(inst)->bur_ExternalOutputs_MeNoiAL;
	

  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    MeNoiAL_initialize(MeNoiAL_DWork, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    MeNoiAL_step(MeNoiAL_B, MeNoiAL_DWork, MeNoiAL_Y, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    MeNoiAL_terminate(inst);
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
