/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: DAI
 * File: fDAI.c
 * Author: 105055527
 * Last modified by: cadm_kafkama00
 * Created: Sat Nov 11 23:05:34 2017
 * Last modified: Wed Oct 02 14:21:06 2024
 * Model Version: 4.14
 * Description: Direct Air Injection for J920 Faststart

   History:

   V0.02  Arnold, 27.11.2017,  tech demonstrator @ P20
   V0.03  Arnold, 24.10.2018,  rename from AirAss to DAI
   V0.04  Arnold, 24.10.2018,  deleted exhaust side DAI, deleted intake dynamics
   V0.05  Arnold, 14.08.2019,  unit testing done, pre-release for Pforzheim P21
   V0.06  Kafka, 20.09.2019, bug fix for testbench manual massflow testing
   V0.07  Kafka, 01.10.2019, massflow limitations changed from per valve to total massflow
   V0.08  Kafka, 02.10.2019, mass flow limitation over boost pressure removed for speed ramp
   V0.09  Kafka, 14.10.2019, disable for negative power trajectory is added in the enable subblock
   V0.10  Kafka, 18.12.2019, disable on speed hysteresis during speed ramp
   V4.14  Kafka, 06.09.2024, update to Matlab Version 2021b


 * modified Comment:
 ********************************************************************
 * Implementation of program DAI
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#include <bur/plctypes.h>
#include "DAI.h"
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
void fDAI(struct fDAI* inst)
{
  tag_RTM_DAI* const DAI_M = &(inst)->bur_DAI;
	inst->bur_DAI.blockIO = &(inst)->bur_BlockIO_DAI;
	inst->bur_DAI.dwork = &(inst)->bur_D_Work_DAI;
	
  switch (inst->ssMethodType)
  {
   case SS_INITIALIZE:
    /* call model initialize function */
    DAI_initialize(DAI_M, inst);
    break;

   case SS_OUTPUT:
    /* call model step function */
    DAI_step(DAI_M, inst);

    
    break;

   case SS_TERMINATE:
    /* call model terminate function */
    DAI_terminate(DAI_M, inst);
    break;
  }
}

/*****************************************************************************
   Function block sample time: 0.01s
 *****************************************************************************/

/*****************************************************************************
   B&R Automation Studio Target for Simulink Version: A6.7.1 (02-Dec-2022)
 *****************************************************************************/

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.11 (R2021b)14-May-2021                                            *
 * Simulink 10.4 (R2021b)14-May-2021                                          *
 * Simulink Coder 9.6 (R2021b)14-May-2021                                     *
 * Embedded Coder 7.7 (R2021b)14-May-2021                                     *
 * Stateflow 10.5 (R2021b)14-May-2021                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
