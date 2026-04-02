/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: UDC
 * File: UDC_data.c
 * Author: 105055527
 * Created: Thu Mar 02 16:51:06 2017
 ********************************************************************
 * Data for program UDC
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "UDC.h"
#include "UDC_private.h"

/*  GLOBAL DATA DEFINITIONS */

/* Invariant block signals (auto storage) */
const ConstBlockIO_UDC UDC_ConstB = {
  /* Start of '<S139>/Filter_OxiIn' */
  {
    2.22044605E-16F
    /* '<S179>/Conversion' */
  }
  /* End of '<S139>/Filter_OxiIn' */
  ,

  /* Start of '<S139>/Filter_CatOut' */
  {
    2.22044605E-16F
    /* '<S177>/Conversion' */
  }
  /* End of '<S139>/Filter_CatOut' */
  ,

  /* Start of '<S120>/Filter2' */
  {
    2.22044605E-16F
    /* '<S134>/Conversion' */
  }
  /* End of '<S120>/Filter2' */
  ,

  /* Start of '<S120>/Filter' */
  {
    2.22044605E-16F
    /* '<S132>/Conversion' */
  }
  /* End of '<S120>/Filter' */
  ,

  /* Start of '<S98>/Filter_DPr' */
  {
    2.22044605E-16F
    /* '<S109>/Conversion' */
  }
  /* End of '<S98>/Filter_DPr' */
  ,

  /* Start of '<S97>/Filter_DPr' */
  {
    2.22044605E-16F
    /* '<S104>/Conversion' */
  }
  /* End of '<S97>/Filter_DPr' */
  ,

  /* Start of '<S15>/Filter1' */
  {
    2.22044605E-16F
    /* '<S71>/Conversion' */
  }
  /* End of '<S15>/Filter1' */
  ,

  /* Start of '<S15>/Filter' */
  {
    2.22044605E-16F
    /* '<S69>/Conversion' */
  }
  /* End of '<S15>/Filter' */
};

/* Constant parameters (auto storage) */
const ConstParam_UDC UDC_ConstP = {
  /* Expression: [0 0.3 0.5 0.75 1]
   * Referenced by: '<S12>/Constant'
   */
  { 0.0, 0.3, 0.5, 0.75, 1.0 },

  /* Computed Parameter: InterpolationUsingPre
   * Referenced by: '<S59>/Interpolation Using Prelookup'
   */
  { 2U, 5U },

  /* Pooled Parameter (Expression: [0 1;1 0;0 1;0 1;1 0;1 0;0 0;0 0])
   * Referenced by:
   *   '<S156>/Logic'
   *   '<S200>/Logic'
   */
  { 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0 }
};
