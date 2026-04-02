/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: Gen2_ref
 * File: Gen2_ref_data.c
 * Author: 105055527
 * Last modified by: kelleto00
 * Created: Wed Apr 16 13:02:53 2008
 * Last modified: Wed Oct 09 10:01:33 2024
 * Model Version: 4.14.00.04
 * Description: V4.10.00.01, 01-09-2020 Keller, Ke Estimator, additive LS factor, Ptraj SpeedCtrl, LVRT Freeze HLCi
   V4.10.00.01, 02-10-2020 Keller, bugfix HLCi p2srefLX init, BDC_lib: change Inf to 1e7
   V4.10.00.01, 13-11-2020 Keller, bugfix LXcorr T2s/ZZP, LSLff damping, dbgOut for Leanox WG compensation
   V4.10.00.01, 27-01-2021 Keller, Lx WGV compensation: no reset in island mode, addition before skipfire compensation
   V4.10.00.01, 02-02-2021 Keller, initialization lambda estimation with rLam_Start
   V4.11.00.01, 28-05-2021 Keller, Gas Quality Change (GQC) Improvements, LHV estimator output
   V4.11.00.01, 05-11-2021 Keller, Bugfix BDC: worksplit offset, optionally Nset instead of Nnom, rN_Eng_LRskipF
   V4.12.00.01, 10-02-2021 Keller, SpeedCtrl2.0 TU Wien: Disturbance Estimator, LQR incl. droop & leanox
   V4.12.00.02, 23-05-2022 Arnold, Leanox point C in low load
   V4.12.00.02, 09-06-2022 Kafka, add external skip fire input for isolated and grid parallel operation
   V4.12.00.03, 15-09-2022 Keller, add power trajectory to HLCi for extended LQR (Droop setpoint)
   V4.12.00.04, 12-10-2022 Keller, add gas flow comp. factor for rejections
   V4.12.00.05, 13-10-2022 Keller, power filter for static skipfire in island mode
   V4.12.00.06, 15-11-2022 Keller, Ke adaptation with disturbance observer
   V4.13.00.01, 15-11-2022 Keller, FDC: R_mix output, HLCi: R_mix for Ke
   V4.13.00.02, 10-07-2023 Keller, interpolation of LHV, rho_gas and Lmin
   V4.13.00.03, 10-07-2023 Keller, load dependent gas dosage delay
   V4.13.00.04, 11-09-2023 Keller, D-part FSM, bugfix dPTV ramp
   V4.13.00.05, 27-02-2024 Keller, Filter outputs without bSS
   V4.13.00.06, 10-04-2024 Keller, bugfix leanox manual mode with bSepEmisCtrl
   V4.14.00.01, 01-07-2024 Keller, iNskip_LRfor Ke calculation
   V4.14.00.02, 17-09-2024 Keller, Use actual speed for observer disturbance dg (Gen2_ref/HLC_Island (HLC_Island_ref)/iLQR_SF/Ref LQR)
   V4.14.00.03, 30-09-2024 Keller, LR gas flow compensation possible without actuator saturation
   V4.14.00.04, 02-10-2024 Keller, Limit derivative power setpoint for FSM
 * modified Comment:
 ********************************************************************
 * Data for program Gen2_ref
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

#include "Gen2_ref.h"
#include "Gen2_ref_private.h"

/*  GLOBAL DATA DEFINITIONS */

/* Invariant block signals (default storage) */
const ConstBlockIO_Gen2_ref Gen2_ref_ConstB = {
  0.0,                                 /* '<S62>/Constant11' */
  1.0,                                 /* '<S134>/  1' */
  0.0,                                 /* '<S344>/ tde1' */
  0.0,                                 /* '<S628>/Constant2' */
  0.0,                                 /* '<S633>/Constant3' */
  0.0,                                 /* '<S761>/Constant1' */
  0.0,                                 /* '<S19>/  x0' */
  1.0,                                 /* '<S20>/T_filt1' */

  /* Start of '<S830>/Ke Map Update' */
  {
    0.0                                /* '<S835>/Constant1' */
  }
  ,

  /* End of '<S830>/Ke Map Update' */

  /* Start of '<S636>/Filter' */
  {
    10.0,                              /* '<S718>/Abs' */
    10.0,                              /* '<S718>/Switch' */
    0,                                 /* '<S718>/Relational Operator' */
    1,                                 /* '<S713>/Relational Operator' */
    0                                  /* '<S713>/Logical Operator1' */
  }
  ,

  /* End of '<S636>/Filter' */

  /* Start of '<S666>/Ke Map Update' */
  {
    0.0                                /* '<S671>/Constant1' */
  }
  ,

  /* End of '<S666>/Ke Map Update' */

  /* Start of '<S630>/Filter' */
  {
    10.0,                              /* '<S668>/Abs' */
    10.0,                              /* '<S668>/Switch' */
    0,                                 /* '<S668>/Relational Operator' */
    1,                                 /* '<S665>/Relational Operator' */
    0                                  /* '<S665>/Logical Operator1' */
  }
  ,

  /* End of '<S630>/Filter' */

  /* Start of '<S418>/2nd Order Filter' */
  {
    0.0                                /* '<S438>/Constant' */
  }
  ,

  /* End of '<S418>/2nd Order Filter' */

  /* Start of '<S306>/2nd Order Filter3' */
  {
    0.0                                /* '<S317>/Constant' */
  }
  ,

  /* End of '<S306>/2nd Order Filter3' */

  /* Start of '<S306>/2nd Order Filter2' */
  {
    0.0                                /* '<S316>/Constant' */
  }
  ,

  /* End of '<S306>/2nd Order Filter2' */

  /* Start of '<S306>/2nd Order Filter1' */
  {
    0.0                                /* '<S315>/Constant' */
  }
  ,

  /* End of '<S306>/2nd Order Filter1' */

  /* Start of '<S306>/2nd Order Filter' */
  {
    0.0                                /* '<S314>/Constant' */
  }
  /* End of '<S306>/2nd Order Filter' */
};

/* Constant parameters (default storage) */
const ConstParam_Gen2_ref Gen2_ref_ConstP = {
  /* Expression: [0 0 70 70]
   * Referenced by: '<S134>/LT%2deg'
   */
  { 0.0, 0.0, 70.0, 70.0 },

  /* Expression: [0 0.0625 0.9375 1]
   * Referenced by: '<S134>/LT%2deg'
   */
  { 0.0, 0.0625, 0.9375, 1.0 }
};
