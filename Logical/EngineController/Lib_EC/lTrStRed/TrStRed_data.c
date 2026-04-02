/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: TrStRed
 * File: TrStRed_data.c
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
 * Data for program TrStRed
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.3.1
 * (ERT based)
 ********************************************************************/

#include "TrStRed.h"
#include "TrStRed_private.h"

/*  GLOBAL DATA DEFINITIONS */

/* Invariant block signals (default storage) */
const ConstBlockIO_TrStRed TrStRed_ConstB = {
  /* Start of '<S6>/Filter1' */
  {
    2.22044605E-16F                    /* '<S31>/Conversion' */
  }
  ,

  /* End of '<S6>/Filter1' */

  /* Start of '<S6>/Filter' */
  {
    2.22044605E-16F                    /* '<S29>/Conversion' */
  }
  /* End of '<S6>/Filter' */
};

/* Constant parameters (default storage) */
const ConstParam_TrStRed TrStRed_ConstP = {
  /* Pooled Parameter (Expression: [0 1;1 0;0 1;0 1;1 0;1 0;0 0;0 0])
   * Referenced by:
   *   '<S36>/Logic'
   *   '<S37>/Logic'
   *   '<S38>/Logic'
   */
  { 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0 }
};
