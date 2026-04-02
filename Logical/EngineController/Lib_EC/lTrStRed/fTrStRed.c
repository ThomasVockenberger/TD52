/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: TrStRed
 * File: fTrStRed.c
 * Author: 105055527
 * Last modified by: maranen00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Mon Dec 06 12:59:10 2021
 * Model Version: 0.3.0
 * Description: Thermal reactor start time reduction function

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.1.0 18.05.2021 Maran   TrStRed function first draft
   V0.1.1 27.05.2021 Maran   added limitation based on cyl. EG max temp. above setpoint
   V0.1.2 02.08.2021 Maran   added half load factor for function limit range
   V0.2.0 15.11.2021 Maran   added saturation limits to control error for the closed loop integrator (PERM parameters)
   V0.3.0 06.12.2021 Maran   removed unused logic in controller block; added filtered value of monitoring variables in debug interface
 ********************************************************************
 * Implementation of program TrStRed
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.1
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "TrStRed.h"
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

/*LEGACYMODE_VARIABLES*/
void fTrStRed(struct fTrStRed* inst)
{
  tag_RTM_TrStRed* const TrStRed_M = &(inst)->bur_TrStRed;
	inst->bur_TrStRed.blockIO = &(inst)->bur_BlockIO_TrStRed;
	inst->bur_TrStRed.prevZCSigState = &(inst)->bur_PrevZCSigStates_TrStRed;
	inst->bur_TrStRed.inputs = &(inst)->bur_ExternalInputs_TrStRed;
	inst->bur_TrStRed.outputs = &(inst)->bur_ExternalOutputs_TrStRed;
	inst->bur_TrStRed.dwork = &(inst)->bur_D_Work_TrStRed;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    TrStRed_initialize(TrStRed_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    TrStRed_step(TrStRed_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    TrStRed_terminate(TrStRed_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A6.3.1 (15-Dec-2020)
 *****************************************************************************/

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.8 (R2020a)18-Nov-2019                                             *
 * Simulink 10.1 (R2020a)18-Nov-2019                                          *
 * Simulink Coder 9.3 (R2020a)18-Nov-2019                                     *
 * Embedded Coder 7.4 (R2020a)18-Nov-2019                                     *
 * Stateflow 10.2 (R2020a)18-Nov-2019                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
