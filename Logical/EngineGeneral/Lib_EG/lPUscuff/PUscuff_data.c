/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PUscuff
 * File: PUscuff_data.c
 * Author: 212442560
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Wed Nov 10 09:52:05 2021
 * Model Version: 0.06
 * Description: PU scuffing detection.

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    17.05.2021    Schmidt,   created initial model
   V0.02    04.08.2021    Schmidt,   model cleanup
   V0.03    31.08.2021    Schmidt,   new version after model/code review (replaced 'Tapped Delay' blocks, para name changes)
   V0.04    09.09.2021    Schmidt,   modifications after P6 validation (parameter cleanup, added trip release delay)
   V0.05    29.09.2021    Schmidt,   added debug outputs (bLearnReactAfterKnock, rP2s_filt_contLearn)
   V0.06    10.11.2021    Schmidt,   knock anomaly det.: filtering probability, threshold change
   IO sample rate corrections (Ts=100ms)
 ********************************************************************
 * Data for program PUscuff
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
 * (ERT based)
 ********************************************************************/

#include "PUscuff.h"
#include "PUscuff_private.h"

/*  GLOBAL DATA DEFINITIONS */

/* Invariant block signals (default storage) */
const ConstBlockIO_PUscuff PUscuff_ConstB = {
  /* Start of '<S6>/Filter3' */
  {
    2.22044605E-16F                    /* '<S52>/Conversion' */
  }
  ,

  /* End of '<S6>/Filter3' */

  /* Start of '<S6>/Filter1' */
  {
    2.22044605E-16F                    /* '<S50>/Conversion' */
  }
  ,

  /* End of '<S6>/Filter1' */

  /* Start of '<S2>/Filter9' */
  {
    1800.0F,                           /* '<S33>/Abs' */
    2.22044605E-16F,                   /* '<S34>/Conversion' */
    1800.0F,                           /* '<S33>/Switch' */
    0                                  /* '<S33>/Relational Operator' */
  }
  ,

  /* End of '<S2>/Filter9' */

  /* Start of '<S2>/Filter4' */
  {
    1.0F,                              /* '<S31>/Abs' */
    2.22044605E-16F,                   /* '<S32>/Conversion' */
    1.0F,                              /* '<S31>/Switch' */
    0                                  /* '<S31>/Relational Operator' */
  }
  ,

  /* End of '<S2>/Filter4' */

  /* Start of '<S2>/Filter1' */
  {
    40.0F,                             /* '<S29>/Abs' */
    2.22044605E-16F,                   /* '<S30>/Conversion' */
    40.0F,                             /* '<S29>/Switch' */
    0                                  /* '<S29>/Relational Operator' */
  }
  ,

  /* End of '<S2>/Filter1' */

  /* Start of '<S8>/Filter2' */
  {
    2.22044605E-16F                    /* '<S16>/Conversion' */
  }
  /* End of '<S8>/Filter2' */
};
