/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: DAI
 * File: DAI_data.c
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
 * Data for program DAI
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#include "DAI.h"
#include "DAI_private.h"

/*  GLOBAL DATA DEFINITIONS */

/* Invariant block signals (default storage) */
const ConstBlockIO_DAI DAI_ConstB = {
  414U,                                /* '<S4>/Data Type Conversion3' */
  1.0F                                 /* '<S41>/Conversion' */
};
