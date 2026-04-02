/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: Gen2_ref
 * File: rtGetNaN.c
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
 * Implementation of program Gen2_ref
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.7.1
 * (ERT based)
 ********************************************************************/

/*
 * Abstract:
 *      Function to initialize non-finite, NaN
 */
#include "rtGetNaN.h"

/*  Defines */
#define NumBitsPerChar                 8U

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/*
 * Initialize rtNaN needed by the generated code.
 * NaN is initialized as non-signaling. Assumes IEEE.
 */
real_T rtGetNaN(void)
{
  size_t bitsPerReal = sizeof(real_T) * (NumBitsPerChar);
  real_T nan = 0.0;
  if (bitsPerReal == 32U) {
    nan = rtGetNaNF();
  } else {
    union {
      LittleEndianIEEEDouble bitVal;
      real_T fltVal;
    } tmpVal;

    tmpVal.bitVal.words.wordH = 0xFFF80000U;
    tmpVal.bitVal.words.wordL = 0x00000000U;
    nan = tmpVal.fltVal;
  }

  return nan;
}

/*
 * Initialize rtNaNF needed by the generated code.
 * NaN is initialized as non-signaling. Assumes IEEE.
 */
real32_T rtGetNaNF(void)
{
  IEEESingle nanF = { { 0.0F } };

  nanF.wordL.wordLuint = 0xFFC00000U;
  return nanF.wordL.wordLreal;
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 9.11 (R2021b)14-May-2021                                            *
 * Simulink 10.4 (R2021b)14-May-2021                                          *
 * Simulink Coder 9.6 (R2021b)14-May-2021                                     *
 * Embedded Coder 7.7 (R2021b)14-May-2021                                     *
 * Stateflow 10.5 (R2021b)14-May-2021                                         *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * control_toolbox                                                            *
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
