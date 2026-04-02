/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: DAI
 * File: DAI.c
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

#include "DAI.h"
#include "DAI_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/* Forward declaration for local functions */
static void DAI_merge(int32_T idx[5], real32_T x[5], int32_T offset, int32_T np,
                      int32_T nq, int32_T iwork[5], real32_T xwork[5], struct fDAI* inst);
static void DAI_sort(real32_T x[5], int32_T idx[5], struct fDAI* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_real32_T */
void BINARYSEARCH_real32_T(uint32_T *piLeft, uint32_T *piRght, real32_T u, const
  real32_T *pData, uint32_T iHi, struct fDAI* inst)
{
  /* Find the location of current input value in the data table. */
  *piLeft = 0U;
  *piRght = iHi;
  if (u <= pData[0] ) {
    /* Less than or equal to the smallest point in the table. */
    *piRght = 0U;
  } else if (u >= pData[iHi] ) {
    /* Greater than or equal to the largest point in the table. */
    *piLeft = iHi;
  } else {
    uint32_T i;

    /* Do a binary search. */
    while (( *piRght - *piLeft ) > 1U ) {
      /* Get the average of the left and right indices using to Floor rounding. */
      i = (*piLeft + *piRght) >> 1;

      /* Move either the right index or the left index so that */
      /*  LeftDataPoint <= CurrentValue < RightDataPoint */
      if (u < pData[i] ) {
        *piRght = i;
      } else {
        *piLeft = i;
      }
    }
  }
}

/* Lookup Utility LookUp_real32_T_real32_T */
void LookUp_real32_T_real32_T(real32_T *pY, const real32_T *pYData, real32_T u,
  const real32_T *pUData, uint32_T iHi, struct fDAI* inst)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_real32_T( &(iLeft), &(iRght), u, pUData, iHi, inst);

  {
    real32_T lambda;
    if (pUData[iRght] > pUData[iLeft] ) {
      real32_T num;
      real32_T den;
      den = pUData[iRght];
      den -= pUData[iLeft];
      num = u;
      num -= pUData[iLeft];
      lambda = num / den;
    } else {
      lambda = 0.0F;
    }

    {
      real32_T yLeftCast;
      real32_T yRghtCast;
      yLeftCast = pYData[iLeft];
      yRghtCast = pYData[iRght];
      yLeftCast += lambda * ( yRghtCast - yLeftCast );
      (*pY) = yLeftCast;
    }
  }
}

/*
 * Output and update for atomic system:
 *    '<S2>/Hystersis'
 *    '<S2>/Hystersis2'
 */
void DAI_Hystersis(real32_T rtu_Gw, real32_T rtu_Hy, real32_T rtu_In,
                   rtB_Hystersis_DAI *localB, rtDW_Hystersis_DAI *localDW, struct fDAI* inst)
{
  localDW->Inter = ((rtu_In >= rtu_Gw) || ((rtu_In >= rtu_Gw - rtu_Hy) &&
    localDW->Inter));
  localB->Out = localDW->Inter;
}

/* Function for MATLAB Function: '<S10>/MATLAB Function' */
static void DAI_merge(int32_T idx[5], real32_T x[5], int32_T offset, int32_T np,
                      int32_T nq, int32_T iwork[5], real32_T xwork[5], struct fDAI* inst)
{
  int32_T q;
  if ((np != 0) && (nq != 0)) {
    int32_T iout;
    int32_T n;
    int32_T n_tmp;
    n_tmp = np + nq;
    for (q = 0; q < n_tmp; q++) {
      iout = offset + q;
      iwork[q] = idx[iout];
      xwork[q] = x[iout];
    }

    n = 0;
    q = np;
    iout = offset - 1;
    int32_T exitg1;
    do {
      exitg1 = 0;
      iout++;
      if (xwork[n] <= xwork[q]) {
        idx[iout] = iwork[n];
        x[iout] = xwork[n];
        if (n + 1 < np) {
          n++;
        } else {
          exitg1 = 1;
        }
      } else {
        idx[iout] = iwork[q];
        x[iout] = xwork[q];
        if (q + 1 < n_tmp) {
          q++;
        } else {
          q = iout - n;
          while (n + 1 <= np) {
            iout = (q + n) + 1;
            idx[iout] = iwork[n];
            x[iout] = xwork[n];
            n++;
          }

          exitg1 = 1;
        }
      }
    } while (exitg1 == 0);
  }
}

/* Function for MATLAB Function: '<S10>/MATLAB Function' */
static void DAI_sort(real32_T x[5], int32_T idx[5], struct fDAI* inst)
{
  int32_T iwork[5];
  int32_T i2;
  int32_T i3;
  int32_T ib;
  int32_T k;
  real32_T xwork[5];
  real32_T x4[4];
  int8_T idx4[4];
  int8_T perm[4];
  x4[0] = 0.0F;
  idx4[0] = 0;
  x4[1] = 0.0F;
  idx4[1] = 0;
  x4[2] = 0.0F;
  idx4[2] = 0;
  x4[3] = 0.0F;
  idx4[3] = 0;
  ib = 0;
  for (k = 0; k < 5; k++) {
    idx[k] = 0;
    ib++;
    idx4[ib - 1] = (int8_T)(k + 1);
    x4[ib - 1] = x[k];
    if (ib == 4) {
      int32_T i4;
      real32_T tmp;
      real32_T tmp_0;
      if (x4[0] <= x4[1]) {
        ib = 1;
        i2 = 2;
      } else {
        ib = 2;
        i2 = 1;
      }

      if (x4[2] <= x4[3]) {
        i3 = 3;
        i4 = 4;
      } else {
        i3 = 4;
        i4 = 3;
      }

      tmp = x4[ib - 1];
      tmp_0 = x4[i3 - 1];
      if (tmp <= tmp_0) {
        tmp = x4[i2 - 1];
        if (tmp <= tmp_0) {
          perm[0] = (int8_T)ib;
          perm[1] = (int8_T)i2;
          perm[2] = (int8_T)i3;
          perm[3] = (int8_T)i4;
        } else if (tmp <= x4[i4 - 1]) {
          perm[0] = (int8_T)ib;
          perm[1] = (int8_T)i3;
          perm[2] = (int8_T)i2;
          perm[3] = (int8_T)i4;
        } else {
          perm[0] = (int8_T)ib;
          perm[1] = (int8_T)i3;
          perm[2] = (int8_T)i4;
          perm[3] = (int8_T)i2;
        }
      } else {
        tmp_0 = x4[i4 - 1];
        if (tmp <= tmp_0) {
          if (x4[i2 - 1] <= tmp_0) {
            perm[0] = (int8_T)i3;
            perm[1] = (int8_T)ib;
            perm[2] = (int8_T)i2;
            perm[3] = (int8_T)i4;
          } else {
            perm[0] = (int8_T)i3;
            perm[1] = (int8_T)ib;
            perm[2] = (int8_T)i4;
            perm[3] = (int8_T)i2;
          }
        } else {
          perm[0] = (int8_T)i3;
          perm[1] = (int8_T)i4;
          perm[2] = (int8_T)ib;
          perm[3] = (int8_T)i2;
        }
      }

      idx[k - 3] = idx4[perm[0] - 1];
      idx[k - 2] = idx4[perm[1] - 1];
      idx[k - 1] = idx4[perm[2] - 1];
      idx[k] = idx4[perm[3] - 1];
      x[k - 3] = x4[perm[0] - 1];
      x[k - 2] = x4[perm[1] - 1];
      x[k - 1] = x4[perm[2] - 1];
      x[k] = x4[perm[3] - 1];
      ib = 0;
    }
  }

  if (ib > 0) {
    perm[1] = 0;
    perm[2] = 0;
    perm[3] = 0;
    if (ib == 1) {
      perm[0] = 1;
    } else if (ib == 2) {
      if (x4[0] <= x4[1]) {
        perm[0] = 1;
        perm[1] = 2;
      } else {
        perm[0] = 2;
        perm[1] = 1;
      }
    } else if (x4[0] <= x4[1]) {
      if (x4[1] <= x4[2]) {
        perm[0] = 1;
        perm[1] = 2;
        perm[2] = 3;
      } else if (x4[0] <= x4[2]) {
        perm[0] = 1;
        perm[1] = 3;
        perm[2] = 2;
      } else {
        perm[0] = 3;
        perm[1] = 1;
        perm[2] = 2;
      }
    } else if (x4[0] <= x4[2]) {
      perm[0] = 2;
      perm[1] = 1;
      perm[2] = 3;
    } else if (x4[1] <= x4[2]) {
      perm[0] = 2;
      perm[1] = 3;
      perm[2] = 1;
    } else {
      perm[0] = 3;
      perm[1] = 2;
      perm[2] = 1;
    }

    for (k = 0; k < ib; k++) {
      i2 = perm[k] - 1;
      i3 = (k - ib) + 5;
      idx[i3] = idx4[i2];
      x[i3] = x4[i2];
    }
  }

  for (k = 0; k < 5; k++) {
    iwork[k] = 0;
    xwork[k] = 0.0F;
  }

  DAI_merge(idx, x, 0, 4, 1, iwork, xwork, inst);
}

/* Model step function */
void DAI_step(RT_MODEL_DAI *const DAI_M, struct fDAI* inst)
{
  struct BlockIO_DAI *DAI_B = DAI_M->blockIO;
  struct D_Work_DAI *DAI_DWork = DAI_M->dwork;

  /* local block i/o variables */
  real32_T rtb_CorrInternal[2];
  real32_T rtb_LookupTableDynamic2;
  real32_T rtb_LookupTableDynamic2_g;
  real32_T rtb_Saturation2[2];
  int32_T iidx[5];
  int32_T i;
  real32_T rtb_x_out[5];
  real32_T rtb_y_out[5];
  real32_T rtb_rCd[2];
  real32_T rtb_Disableintakedynamics1;
  real32_T rtb_Product_nc;
  real32_T rtb_Switch2_i;
  real32_T rtb_Switch2_n;
  real32_T rtb_UkYk1;
  real32_T rtb_rFlow_eng_act;
  real32_T rtb_rFlow_eng_des;
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_LogicalOperator5;

  /* S-Function (bur_bus_in): '<Root>/Bus Input3' */
  DAI_B->BusInput3 = inst->In;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  DAI_B->BusInput1 = inst->Para;

  /* Outputs for Atomic SubSystem: '<Root>/EngineMassFlow' */
  /* MATLAB Function: '<S3>/desired engine massflow' incorporates:
   *  Constant: '<S27>/Constant1'
   *  MATLAB Function: '<S3>/actual engine massflow'
   *  Sum: '<S27>/Add1'
   */
  rtb_rFlow_eng_act = fmaxf((DAI_B->BusInput3.rT_T2s + 273.15F) * 287.15F, 1.0F);
  rtb_Disableintakedynamics1 = DAI_B->BusInput3.rVE_Eng *
    DAI_B->BusInput3.rV_EngDis;

  /* Outputs for Atomic SubSystem: '<Root>/Enable' */
  /* Product: '<S3>/Product' incorporates:
   *  Product: '<S2>/Product'
   */
  rtb_Product_nc = DAI_B->BusInput3.rN_Set_Norm * DAI_B->BusInput1.rN_EngNom;

  /* End of Outputs for SubSystem: '<Root>/Enable' */

  /* MATLAB Function: '<S3>/desired engine massflow' incorporates:
   *  Constant: '<S25>/Constant1'
   *  Constant: '<S30>/Constant1'
   *  Product: '<S25>/Product'
   *  Product: '<S30>/Product'
   *  Product: '<S3>/Product'
   */
  rtb_rFlow_eng_des = DAI_B->BusInput3.rPr_P2s_des * 100000.0F *
    rtb_Disableintakedynamics1 / rtb_rFlow_eng_act * (rtb_Product_nc *
    0.104719758F) / 2.0F / 6.28318548F;

  /* Switch: '<S23>/Switch2' incorporates:
   *  Constant: '<S3>/Constant4'
   *  RelationalOperator: '<S23>/LowerRelop1'
   *  RelationalOperator: '<S23>/UpperRelop'
   *  Switch: '<S23>/Switch'
   */
  if (DAI_B->BusInput3.rN_Eng > DAI_B->BusInput1.rN_EngNom) {
    rtb_Switch2_i = DAI_B->BusInput1.rN_EngNom;
  } else if (DAI_B->BusInput3.rN_Eng < 1.0F) {
    /* Switch: '<S23>/Switch' incorporates:
     *  Constant: '<S3>/Constant4'
     */
    rtb_Switch2_i = 1.0F;
  } else {
    rtb_Switch2_i = DAI_B->BusInput3.rN_Eng;
  }

  /* End of Switch: '<S23>/Switch2' */

  /* MATLAB Function: '<S3>/actual engine massflow' incorporates:
   *  Constant: '<S26>/Constant1'
   *  Constant: '<S29>/Constant1'
   *  Product: '<S26>/Product'
   *  Product: '<S29>/Product'
   */
  rtb_rFlow_eng_act = DAI_B->BusInput3.rPr_P2s_Avg * 100000.0F *
    rtb_Disableintakedynamics1 / rtb_rFlow_eng_act * (rtb_Switch2_i *
    0.104719758F) / 2.0F / 6.28318548F;

  /* End of Outputs for SubSystem: '<Root>/EngineMassFlow' */

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  DAI_B->BusInput2 = inst->Perm;

  /* Outputs for Atomic SubSystem: '<Root>/AirFlowDemand' */
  /* MATLAB Function: '<S10>/MATLAB Function' incorporates:
   *  Product: '<S10>/Divide'
   *  SignalConversion generated from: '<S13>/ SFunction '
   */
  rtb_x_out[0] = DAI_B->BusInput1.rN_DAI_On;
  rtb_x_out[1] = DAI_B->BusInput1.rN_EngNom * DAI_B->BusInput2.rNref_ff[0];
  rtb_x_out[2] = DAI_B->BusInput1.rN_EngNom * DAI_B->BusInput2.rNref_ff[1];
  rtb_x_out[3] = DAI_B->BusInput1.rN_EngNom * DAI_B->BusInput2.rNref_ff[2];
  rtb_x_out[4] = DAI_B->BusInput1.rN_DAI_Off;
  DAI_sort(rtb_x_out, iidx, inst);
  for (i = 0; i < 5; i++) {
    rtb_y_out[i] = DAI_B->BusInput2.rFlowRef_ff[iidx[i] - 1];
  }

  /* End of MATLAB Function: '<S10>/MATLAB Function' */

  /* Switch: '<S1>/ManMode' incorporates:
   *  Constant: '<S22>/Constant'
   *  Constant: '<S6>/Constant'
   *  RelationalOperator: '<S22>/Compare'
   *  RelationalOperator: '<S6>/Compare'
   *  Switch: '<S1>/OpMode'
   *  Switch: '<S3>/Disable intake dynamics1'
   */
  if (DAI_B->BusInput3.Test.bManEnable) {
    rtb_Disableintakedynamics1 = DAI_B->BusInput3.Test.rManMassReq;
  } else if (DAI_B->BusInput3.iOpMode <= 45) {
    /* S-Function (sfix_look1_dyn): '<S10>/Lookup Table Dynamic2' incorporates:
     *  Switch: '<S1>/OpMode'
     */
    /* Dynamic Look-Up Table Block: '<S10>/Lookup Table Dynamic2'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic2_g), &rtb_y_out[0],
      DAI_B->BusInput3.rN_Eng, &rtb_x_out[0], 4U, inst);

    /* Switch: '<S1>/OpMode' incorporates:
     *  Product: '<S10>/Product3'
     */
    rtb_Disableintakedynamics1 = DAI_B->BusInput1.rGain_DAI_Start *
      rtb_LookupTableDynamic2_g;
  } else {
    /* Outputs for Atomic SubSystem: '<Root>/EngineMassFlow' */
    if (DAI_B->BusInput3.iOpMode < 50) {
      /* Switch: '<S3>/Disable intake dynamics1' incorporates:
       *  Constant: '<S3>/Constant1'
       */
      rtb_Switch2_i = 0.0F;
    } else {
      /* Switch: '<S3>/Disable intake dynamics1' incorporates:
       *  Sum: '<S3>/Add'
       */
      rtb_Switch2_i = rtb_rFlow_eng_des - rtb_rFlow_eng_act;
    }

    /* End of Outputs for SubSystem: '<Root>/EngineMassFlow' */

    /* Product: '<S1>/Product3' incorporates:
     *  Switch: '<S1>/OpMode'
     */
    rtb_Disableintakedynamics1 = rtb_Switch2_i * DAI_B->BusInput1.rGain_DAI;

    /* S-Function (sfix_look1_dyn): '<S1>/Lookup Table Dynamic2' incorporates:
     *  Switch: '<S1>/OpMode'
     */
    /* Dynamic Look-Up Table Block: '<S1>/Lookup Table Dynamic2'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_LookupTableDynamic2),
      &DAI_B->BusInput2.rRefFlowMaxP2s_y[0], DAI_B->BusInput3.rPr_P2s_Avg,
      &DAI_B->BusInput2.rRefFlowMaxP2s_x[0], 4U, inst);

    /* Switch: '<S8>/Switch2' incorporates:
     *  Constant: '<S1>/Constant2'
     *  RelationalOperator: '<S8>/LowerRelop1'
     *  RelationalOperator: '<S8>/UpperRelop'
     *  Switch: '<S1>/OpMode'
     *  Switch: '<S8>/Switch'
     */
    if (rtb_Disableintakedynamics1 > rtb_LookupTableDynamic2) {
      rtb_Disableintakedynamics1 = rtb_LookupTableDynamic2;
    } else if (rtb_Disableintakedynamics1 < 0.0F) {
      /* Switch: '<S8>/Switch' incorporates:
       *  Constant: '<S1>/Constant2'
       */
      rtb_Disableintakedynamics1 = 0.0F;
    }

    /* End of Switch: '<S8>/Switch2' */
  }

  /* End of Switch: '<S1>/ManMode' */

  /* Switch: '<S9>/Switch2' incorporates:
   *  Constant: '<S1>/Constant1'
   *  RelationalOperator: '<S9>/LowerRelop1'
   *  RelationalOperator: '<S9>/UpperRelop'
   *  Switch: '<S9>/Switch'
   */
  if (rtb_Disableintakedynamics1 > DAI_B->BusInput2.rMaxFlow) {
    rtb_Disableintakedynamics1 = DAI_B->BusInput2.rMaxFlow;
  } else if (rtb_Disableintakedynamics1 < 0.0F) {
    /* Switch: '<S9>/Switch' incorporates:
     *  Constant: '<S1>/Constant1'
     */
    rtb_Disableintakedynamics1 = 0.0F;
  }

  /* End of Switch: '<S9>/Switch2' */

  /* Abs: '<S7>/Abs' */
  rtb_Switch2_i = fabsf(DAI_B->BusInput2.rRateLimPos);

  /* Product: '<S11>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S11>/sample time'
   *
   * About '<S11>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_n = rtb_Switch2_i * 0.01F;

  /* Sum: '<S11>/Difference Inputs1' incorporates:
   *  UnitDelay: '<S11>/Delay Input2'
   */
  rtb_UkYk1 = rtb_Disableintakedynamics1 - DAI_DWork->DelayInput2_DSTATE;

  /* Switch: '<S12>/Switch2' incorporates:
   *  RelationalOperator: '<S12>/LowerRelop1'
   */
  if (rtb_UkYk1 <= rtb_Switch2_n) {
    /* Product: '<S11>/delta fall limit' incorporates:
     *  Abs: '<S7>/Abs1'
     *  Gain: '<S7>/Gain'
     *  SampleTimeMath: '<S11>/sample time'
     *
     * About '<S11>/sample time':
     *  y = K where K = ( w * Ts )
     */
    rtb_Switch2_n = -fabsf(DAI_B->BusInput2.rRateLimNeg) * 0.01F;

    /* Switch: '<S12>/Switch' incorporates:
     *  RelationalOperator: '<S12>/UpperRelop'
     */
    if (rtb_UkYk1 >= rtb_Switch2_n) {
      rtb_Switch2_n = rtb_UkYk1;
    }

    /* End of Switch: '<S12>/Switch' */
  }

  /* End of Switch: '<S12>/Switch2' */

  /* Sum: '<S11>/Difference Inputs2' incorporates:
   *  UnitDelay: '<S11>/Delay Input2'
   */
  rtb_UkYk1 = rtb_Switch2_n + DAI_DWork->DelayInput2_DSTATE;

  /* Switch: '<S7>/Rate limits selection' */
  if (rtb_Switch2_i >= 1.0E-6F) {
    rtb_Disableintakedynamics1 = rtb_UkYk1;
  }

  /* End of Switch: '<S7>/Rate limits selection' */

  /* Update for UnitDelay: '<S11>/Delay Input2' */
  DAI_DWork->DelayInput2_DSTATE = rtb_UkYk1;

  /* End of Outputs for SubSystem: '<Root>/AirFlowDemand' */

  /* Outputs for Atomic SubSystem: '<Root>/Enable' */
  /* Sum: '<S2>/Add' */
  rtb_Switch2_i = rtb_Product_nc - DAI_B->BusInput3.rN_Eng;

  /* MATLAB Function: '<S2>/Hystersis1' */
  DAI_DWork->Inter_n = ((rtb_Switch2_i >= DAI_B->BusInput2.rNDiffOn) ||
                        ((rtb_Switch2_i > DAI_B->BusInput2.rNDiffOff) &&
    DAI_DWork->Inter_n));

  /* MATLAB Function: '<S2>/Hystersis' */
  DAI_Hystersis(DAI_B->BusInput2.rFlowActOn, DAI_B->BusInput2.rFlowActHyst,
                rtb_Disableintakedynamics1, &DAI_B->sf_Hystersis,
                &DAI_DWork->sf_Hystersis, inst);

  /* MATLAB Function: '<S2>/Hystersis2' incorporates:
   *  Sum: '<S2>/Add1'
   */
  DAI_Hystersis(DAI_B->BusInput2.rPrDiffOn, DAI_B->BusInput2.rPrDiffHyst,
                DAI_B->BusInput3.rPr_DAI_In - DAI_B->BusInput3.rPr_P2s_Avg,
                &DAI_B->sf_Hystersis2, &DAI_DWork->sf_Hystersis2, inst);

  /* Sum: '<S14>/Diff' incorporates:
   *  UnitDelay: '<S14>/UD'
   */
  rtb_Switch2_i = DAI_B->BusInput3.rP_GEN2_Norm - DAI_DWork->UD_DSTATE;

  /* MATLAB Function: '<S2>/Hystersis3' incorporates:
   *  Constant: '<S2>/Constant'
   *  Constant: '<S2>/Constant1'
   */
  DAI_DWork->Inter = ((rtb_Switch2_i >= -1.0E-7) || ((rtb_Switch2_i >= -1.2E-7) &&
    DAI_DWork->Inter));

  /* Outputs for Atomic SubSystem: '<S2>/TON' */
  /* Logic: '<S20>/Logical Operator2' incorporates:
   *  Logic: '<S20>/Logical Operator3'
   */
  rtb_LogicalOperator2 = !DAI_B->BusInput3.bP_Set_reached;

  /* DiscreteIntegrator: '<S20>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S20>/Logical Operator2'
   */
  if (rtb_LogicalOperator2 || (DAI_DWork->DiscreteTimeIntegrator_PrevRese != 0))
  {
    DAI_DWork->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S20>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S20>/Discrete-Time Integrator'
   */
  rtb_LogicalOperator5 = (DAI_DWork->DiscreteTimeIntegrator_DSTATE >=
    DAI_B->BusInput2.rTi_P_Set_reached_delay);

  /* Update for DiscreteIntegrator: '<S20>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S21>/Conversion'
   *  Logic: '<S20>/Logical Operator'
   *  Logic: '<S20>/Logical Operator1'
   *  Logic: '<S20>/Logical Operator2'
   */
  if (!rtb_LogicalOperator2) {
    DAI_DWork->DiscreteTimeIntegrator_DSTATE += (real32_T)
      ((!rtb_LogicalOperator5) && DAI_B->BusInput3.bP_Set_reached) * 0.01F;
  }

  DAI_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator2;

  /* End of Update for DiscreteIntegrator: '<S20>/Discrete-Time Integrator' */
  /* End of Outputs for SubSystem: '<S2>/TON' */

  /* MATLAB Function: '<S2>/MATLAB Function' incorporates:
   *  Logic: '<S20>/Logical Operator3'
   *  MATLAB Function: '<S2>/Hystersis1'
   *  MATLAB Function: '<S2>/Hystersis3'
   */
  switch (DAI_B->BusInput3.iOpMode) {
   case 30:
    rtb_LogicalOperator2 = (DAI_B->BusInput1.bDAI_Active_Start &&
      DAI_B->sf_Hystersis.Out && DAI_DWork->Inter_n && (DAI_B->BusInput3.rN_Eng >=
      DAI_B->BusInput1.rN_DAI_On) && (DAI_B->BusInput3.rN_Eng <
      DAI_B->BusInput1.rN_DAI_Off) && DAI_B->sf_Hystersis2.Out);
    DAI_DWork->bStart2Idle = true;
    DAI_B->BusCreator.bDAI_Tank_Pr_Ena = true;
    break;

   case 40:
    if (DAI_DWork->bStart2Idle && (DAI_B->BusInput3.rN_Eng <=
         DAI_B->BusInput1.rN_EngNom * 0.95F)) {
      rtb_LogicalOperator2 = (DAI_B->BusInput1.bDAI_Active_Start &&
        DAI_B->sf_Hystersis.Out && DAI_DWork->Inter_n &&
        (DAI_B->BusInput3.rN_Eng >= DAI_B->BusInput1.rN_DAI_On) &&
        (DAI_B->BusInput3.rN_Eng < DAI_B->BusInput1.rN_DAI_Off) &&
        DAI_B->sf_Hystersis2.Out);
    } else {
      rtb_LogicalOperator2 = false;
      DAI_DWork->bStart2Idle = false;
    }

    DAI_B->BusCreator.bDAI_Tank_Pr_Ena = true;
    break;

   case 50:
    /* Outputs for Atomic SubSystem: '<S2>/TON' */
    rtb_LogicalOperator2 = (((((!rtb_LogicalOperator5) || rtb_LogicalOperator2) &&
      DAI_B->BusInput1.bDAI_Active_PowRamp) || DAI_B->BusInput1.bDAI_Active_NetP)
      && DAI_B->sf_Hystersis.Out && DAI_B->sf_Hystersis2.Out && DAI_DWork->Inter);

    /* End of Outputs for SubSystem: '<S2>/TON' */
    DAI_B->BusCreator.bDAI_Tank_Pr_Ena =
      !DAI_B->BusInput3.bAMM_Pr_AirStarter_Tank_Lo;
    DAI_DWork->bStart2Idle = false;
    break;

   case 60:
    rtb_LogicalOperator2 = (DAI_B->BusInput1.bDAI_Active_Island &&
      DAI_B->sf_Hystersis.Out && DAI_DWork->Inter_n && DAI_B->sf_Hystersis2.Out);
    DAI_DWork->bStart2Idle = false;
    DAI_B->BusCreator.bDAI_Tank_Pr_Ena =
      !DAI_B->BusInput3.bAMM_Pr_AirStarter_Tank_Lo;
    break;

   default:
    rtb_LogicalOperator2 = false;
    DAI_DWork->bStart2Idle = false;
    DAI_B->BusCreator.bDAI_Tank_Pr_Ena = true;
    break;
  }

  /* End of MATLAB Function: '<S2>/MATLAB Function' */

  /* Logic: '<S2>/Logical Operator3' incorporates:
   *  Logic: '<S2>/Logical Operator2'
   */
  rtb_LogicalOperator2 = (DAI_B->BusInput1.bDAI_Active && (rtb_LogicalOperator2 &&
    DAI_B->BusInput3.bDAI_ena));

  /* Logic: '<S2>/Logical Operator4' incorporates:
   *  Logic: '<S2>/Logical Operator5'
   */
  DAI_B->BusCreator.bDAI_DP_Warn = (DAI_B->BusInput3.bDAI_ena &&
    (!DAI_B->sf_Hystersis2.Out));

  /* Update for UnitDelay: '<S14>/UD' */
  DAI_DWork->UD_DSTATE = DAI_B->BusInput3.rP_GEN2_Norm;

  /* End of Outputs for SubSystem: '<Root>/Enable' */

  /* Outputs for Atomic SubSystem: '<Root>/ValvePos' */
  /* Switch: '<S33>/Switch' incorporates:
   *  DataTypeConversion: '<S5>/Data Type Conversion'
   *  RelationalOperator: '<S33>/Relational Operator'
   */
  if (DAI_ConstB.Conversion >= DAI_B->BusInput2.iNumValve) {
    rtb_Switch2_i = DAI_ConstB.Conversion;
  } else {
    rtb_Switch2_i = DAI_B->BusInput2.iNumValve;
  }

  /* End of Switch: '<S33>/Switch' */

  /* Product: '<S5>/Product' */
  rtb_UkYk1 = 1.0F / rtb_Switch2_i * rtb_Disableintakedynamics1;

  /* Switch: '<S35>/Switch2' incorporates:
   *  Constant: '<S5>/Constant1'
   *  Constant: '<S5>/Constant3'
   *  RelationalOperator: '<S35>/LowerRelop1'
   *  RelationalOperator: '<S35>/UpperRelop'
   *  Switch: '<S35>/Switch'
   */
  if (DAI_B->BusInput3.rPr_DAI_A > 10.0F) {
    rtb_Switch2_i = 10.0F;
  } else if (DAI_B->BusInput3.rPr_DAI_A < 2.0F) {
    /* Switch: '<S35>/Switch' incorporates:
     *  Constant: '<S5>/Constant3'
     */
    rtb_Switch2_i = 2.0F;
  } else {
    rtb_Switch2_i = DAI_B->BusInput3.rPr_DAI_A;
  }

  /* End of Switch: '<S35>/Switch2' */

  /* Product: '<S37>/Product' incorporates:
   *  Constant: '<S37>/Constant1'
   */
  rtb_Product_nc = rtb_Switch2_i * 100000.0F;

  /* Product: '<S36>/Product' incorporates:
   *  Constant: '<S36>/Constant1'
   */
  rtb_Switch2_i = DAI_B->BusInput3.rPr_P2s_A * 100000.0F;

  /* MATLAB Function: '<S5>/Discharge coefficient computation_A' incorporates:
   *  Constant: '<S40>/Constant1'
   *  Sum: '<S40>/Add1'
   */
  if (rtb_Product_nc >= rtb_Switch2_i) {
    rtb_Switch2_i = fmaxf(rtb_Switch2_i / rtb_Product_nc, 1.0E-6F);
    if (rtb_Switch2_i >= 0.52828178771717416) {
      rtb_Switch2_i = sqrtf((powf(rtb_Switch2_i, 1.42857146F) - powf
        (rtb_Switch2_i, 1.71428573F)) * 3.5F);
    } else {
      rtb_Switch2_i = 0.484178245F;
    }

    rtb_Product_nc = rtb_UkYk1 / fmaxf(DAI_B->BusInput2.rDiam *
      DAI_B->BusInput2.rDiam * 3.14159274F / 4.0F * rtb_Product_nc * sqrtf(2.0F /
      fmaxf((DAI_B->BusInput3.rT_DAI + 273.15F) * 287.15F, 1.0E-6F)) *
      rtb_Switch2_i, 1.0E-6F);
  } else {
    rtb_Product_nc = 0.0F;
  }

  /* End of MATLAB Function: '<S5>/Discharge coefficient computation_A' */

  /* Switch: '<S34>/Switch2' incorporates:
   *  Constant: '<S5>/Constant4'
   *  Constant: '<S5>/Constant5'
   *  RelationalOperator: '<S34>/LowerRelop1'
   *  RelationalOperator: '<S34>/UpperRelop'
   *  Switch: '<S34>/Switch'
   */
  if (DAI_B->BusInput3.rPr_DAI_B > 10.0F) {
    rtb_Switch2_i = 10.0F;
  } else if (DAI_B->BusInput3.rPr_DAI_B < 2.0F) {
    /* Switch: '<S34>/Switch' incorporates:
     *  Constant: '<S5>/Constant5'
     */
    rtb_Switch2_i = 2.0F;
  } else {
    rtb_Switch2_i = DAI_B->BusInput3.rPr_DAI_B;
  }

  /* End of Switch: '<S34>/Switch2' */

  /* Product: '<S39>/Product' incorporates:
   *  Constant: '<S39>/Constant1'
   */
  rtb_Switch2_n = rtb_Switch2_i * 100000.0F;

  /* Product: '<S38>/Product' incorporates:
   *  Constant: '<S38>/Constant1'
   */
  rtb_Switch2_i = DAI_B->BusInput3.rPr_P2s_B * 100000.0F;

  /* MATLAB Function: '<S5>/Discharge coefficient computation_B' incorporates:
   *  Constant: '<S40>/Constant1'
   *  Sum: '<S40>/Add1'
   */
  if (rtb_Switch2_n >= rtb_Switch2_i) {
    rtb_Switch2_i = fmaxf(rtb_Switch2_i / rtb_Switch2_n, 1.0E-6F);
    if (rtb_Switch2_i >= 0.52828178771717416) {
      rtb_Switch2_i = sqrtf((powf(rtb_Switch2_i, 1.42857146F) - powf
        (rtb_Switch2_i, 1.71428573F)) * 3.5F);
    } else {
      rtb_Switch2_i = 0.484178245F;
    }

    rtb_Switch2_i = rtb_UkYk1 / fmaxf(DAI_B->BusInput2.rDiam *
      DAI_B->BusInput2.rDiam * 3.14159274F / 4.0F * rtb_Switch2_n * sqrtf(2.0F /
      fmaxf((DAI_B->BusInput3.rT_DAI + 273.15F) * 287.15F, 1.0E-6F)) *
      rtb_Switch2_i, 1.0E-6F);
  } else {
    rtb_Switch2_i = 0.0F;
  }

  /* End of MATLAB Function: '<S5>/Discharge coefficient computation_B' */

  /* Saturate: '<S5>/Saturation1' */
  if (rtb_Product_nc > 1.0F) {
    rtb_rCd[0] = 1.0F;
  } else if (rtb_Product_nc < 0.0F) {
    rtb_rCd[0] = 0.0F;
  } else {
    rtb_rCd[0] = rtb_Product_nc;
  }

  if (rtb_Switch2_i > 1.0F) {
    rtb_rCd[1] = 1.0F;
  } else if (rtb_Switch2_i < 0.0F) {
    rtb_rCd[1] = 0.0F;
  } else {
    rtb_rCd[1] = rtb_Switch2_i;
  }

  /* End of Saturate: '<S5>/Saturation1' */

  /* Switch: '<S5>/ManMode' */
  if (DAI_B->BusInput3.Test.bManPosEnable) {
    rtb_UkYk1 = DAI_B->BusInput3.Test.rManPos[0];
    rtb_Product_nc = DAI_B->BusInput3.Test.rManPos[1];
  } else {
    /* S-Function (sfix_look1_dyn): '<S5>/Cd2Pos' */
    /* Dynamic Look-Up Table Block: '<S5>/Cd2Pos'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_Saturation2[0]),
      &DAI_B->BusInput2.rPosBrkPts[0], rtb_rCd[0], &DAI_B->BusInput2.rDisBrkPts
      [0], 10U, inst);
    LookUp_real32_T_real32_T( &(rtb_Saturation2[1]),
      &DAI_B->BusInput2.rPosBrkPts[0], rtb_rCd[1], &DAI_B->BusInput2.rDisBrkPts
      [0], 10U, inst);

    /* Saturate: '<S5>/Saturation2' incorporates:
     *  Product: '<S5>/Product2'
     */
    rtb_Saturation2[0] *= DAI_B->BusInput2.rGainFlow;

    /* Saturate: '<S5>/Saturation2' */
    if (rtb_Saturation2[0] > 1.0F) {
      /* Saturate: '<S5>/Saturation2' */
      rtb_Saturation2[0] = 1.0F;
    } else if (rtb_Saturation2[0] < 0.0F) {
      /* Saturate: '<S5>/Saturation2' */
      rtb_Saturation2[0] = 0.0F;
    }

    /* Saturate: '<S5>/Saturation2' incorporates:
     *  Product: '<S5>/Product2'
     */
    rtb_Saturation2[1] *= DAI_B->BusInput2.rGainFlow;

    /* Saturate: '<S5>/Saturation2' */
    if (rtb_Saturation2[1] > 1.0F) {
      /* Saturate: '<S5>/Saturation2' */
      rtb_Saturation2[1] = 1.0F;
    } else if (rtb_Saturation2[1] < 0.0F) {
      /* Saturate: '<S5>/Saturation2' */
      rtb_Saturation2[1] = 0.0F;
    }

    /* S-Function (sfix_look1_dyn): '<S5>/CorrInternal' */
    /* Dynamic Look-Up Table Block: '<S5>/CorrInternal'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_CorrInternal[0]),
      &DAI_B->BusInput2.rRefValve_y[0], rtb_Saturation2[0],
      &DAI_B->BusInput2.rRefValve_x[0], 4U, inst);
    LookUp_real32_T_real32_T( &(rtb_CorrInternal[1]),
      &DAI_B->BusInput2.rRefValve_y[0], rtb_Saturation2[1],
      &DAI_B->BusInput2.rRefValve_x[0], 4U, inst);
    rtb_UkYk1 = rtb_CorrInternal[0];
    rtb_Product_nc = rtb_CorrInternal[1];
  }

  /* End of Switch: '<S5>/ManMode' */

  /* Logic: '<S5>/Logical Operator1' */
  rtb_LogicalOperator5 = (rtb_LogicalOperator2 ||
    DAI_B->BusInput3.Test.bManPosEnable);

  /* Saturate: '<S5>/Saturation3' */
  if (rtb_UkYk1 > 1.0F) {
    rtb_UkYk1 = 1.0F;
  } else if (rtb_UkYk1 < 0.0F) {
    rtb_UkYk1 = 0.0F;
  }

  /* Switch: '<S5>/Enable' */
  if (rtb_LogicalOperator5) {
    /* BusCreator: '<Root>/Bus Creator' */
    DAI_B->BusCreator.rPos_DAI_Set_A = rtb_UkYk1;
  } else {
    /* BusCreator: '<Root>/Bus Creator' incorporates:
     *  Constant: '<S5>/Constant2'
     */
    DAI_B->BusCreator.rPos_DAI_Set_A = 0.0F;
  }

  /* End of Outputs for SubSystem: '<Root>/ValvePos' */

  /* BusCreator: '<Root>/Bus Creator1' */
  DAI_B->BusCreator1.rPos_AirValve[0] = rtb_UkYk1;

  /* Outputs for Atomic SubSystem: '<Root>/ValvePos' */
  /* Saturate: '<S5>/Saturation3' */
  if (rtb_Product_nc > 1.0F) {
    rtb_UkYk1 = 1.0F;
  } else if (rtb_Product_nc < 0.0F) {
    rtb_UkYk1 = 0.0F;
  } else {
    rtb_UkYk1 = rtb_Product_nc;
  }

  /* Switch: '<S5>/Enable' */
  if (rtb_LogicalOperator5) {
    /* BusCreator: '<Root>/Bus Creator' */
    DAI_B->BusCreator.rPos_DAI_Set_B = rtb_UkYk1;
  } else {
    /* BusCreator: '<Root>/Bus Creator' incorporates:
     *  Constant: '<S5>/Constant2'
     */
    DAI_B->BusCreator.rPos_DAI_Set_B = 0.0F;
  }

  /* End of Outputs for SubSystem: '<Root>/ValvePos' */

  /* BusCreator: '<Root>/Bus Creator' */
  DAI_B->BusCreator.bDAI_V_Dem = rtb_LogicalOperator2;
  DAI_B->BusCreator.rFlow_DAI_Dem = rtb_Disableintakedynamics1;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Out = DAI_B->BusCreator;

  /* BusCreator: '<Root>/Bus Creator1' */
  DAI_B->BusCreator1.rFlow_eng_des = rtb_rFlow_eng_des;
  DAI_B->BusCreator1.rFlow_eng_act = rtb_rFlow_eng_act;
  DAI_B->BusCreator1.rCd[0] = rtb_rCd[0];
  DAI_B->BusCreator1.rCd[1] = rtb_rCd[1];
  DAI_B->BusCreator1.rPos_AirValve[1] = rtb_UkYk1;

  /* S-Function (bur_bus_out): '<Root>/Bus Output2' */
  inst->dbg = DAI_B->BusCreator1;

  /* UnitDelay: '<S4>/Unit Delay' */
  DAI_B->UnitDelay = DAI_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->Version = DAI_B->UnitDelay;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  DAI_DWork->UnitDelay_DSTATE = DAI_ConstB.DataTypeConversion3;
}

/* Model initialize function */
void DAI_initialize(RT_MODEL_DAI *const DAI_M, struct fDAI* inst)
{
  /* (no initialization code required) */
  UNUSED_PARAMETER(DAI_M);
}

/* Model terminate function */
void DAI_terminate(RT_MODEL_DAI *const DAI_M, struct fDAI* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(DAI_M);
}

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
