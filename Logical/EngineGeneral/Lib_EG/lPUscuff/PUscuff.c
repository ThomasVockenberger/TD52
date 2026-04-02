/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PUscuff
 * File: PUscuff.c
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
 * Implementation of program PUscuff
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.4.1
 * (ERT based)
 ********************************************************************/

#include "PUscuff.h"
#include "PUscuff_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/* Forward declaration for local functions */
static void PUscuff_merge(int32_T idx[25], real32_T x[25], int32_T offset,
  int32_T np, int32_T nq, int32_T iwork[25], real32_T xwork[25], struct fPUscuff* inst);
static void PUscuff_sort(real32_T x[25], struct fPUscuff* inst);
static int32_T PUscuff_thirdOfFive(const real32_T v_data[], int32_T ia, int32_T
  ib, struct fPUscuff* inst);
static void PUscuff_quickselect(real32_T v_data[], const int32_T *v_size,
  int32_T n, int32_T vlen, real32_T *vn, int32_T *nfirst, int32_T *nlast, struct fPUscuff* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/*
 * System initialize for atomic system:
 *    '<S8>/Filter2'
 *    '<S6>/Filter1'
 *    '<S6>/Filter3'
 */
void PUscuff_Filter2_Init(rtDW_Filter2_PUscuff *localDW, struct fPUscuff* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S8>/Filter2'
 *    '<S6>/Filter1'
 *    '<S6>/Filter3'
 */
void PUscuff_Filter2(real32_T rtu_in, real32_T rtu_T_filt, boolean_T rtu_reset,
                     rtB_Filter2_PUscuff *localB, rtDW_Filter2_PUscuff *localDW, struct fPUscuff* inst)
{
  real32_T tmp;

  /* DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  if (rtu_reset || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  localB->DiscreteTimeIntegrator = localDW->DiscreteTimeIntegrator_DSTATE;

  /* End of DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Switch: '<S15>/Switch' incorporates:
   *  Abs: '<S15>/Abs'
   *  RelationalOperator: '<S15>/Relational Operator'
   */
  if (2.22044605E-16F >= (real32_T)fabs(rtu_T_filt)) {
    tmp = 2.22044605E-16F;
  } else {
    tmp = rtu_T_filt;
  }

  /* End of Switch: '<S15>/Switch' */

  /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' incorporates:
   *  Product: '<S11>/Divide4'
   *  Sum: '<S11>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (rtu_in -
    localB->DiscreteTimeIntegrator) / tmp * 0.1F;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtu_reset;
}

/*
 * Output and update for atomic system:
 *    '<S8>/TON1'
 *    '<S8>/TON2'
 *    '<S2>/TON1'
 *    '<S2>/TON2'
 *    '<S2>/TON5'
 *    '<S6>/TON4'
 */
void PUscuff_TON1(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON1_PUscuff *localB,
                  rtDW_TON1_PUscuff *localDW, struct fPUscuff* inst)
{
  boolean_T rtb_LogicalOperator2_a;
  boolean_T rtb_RelationalOperator_d;

  /* Logic: '<S13>/Logical Operator2' */
  rtb_LogicalOperator2_a = !rtu_IN;

  /* DiscreteIntegrator: '<S13>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_a || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S13>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S13>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_d = (localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Logic: '<S13>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_d && rtu_IN);

  /* Update for DiscreteIntegrator: '<S13>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S17>/Conversion'
   *  Logic: '<S13>/Logical Operator'
   *  Logic: '<S13>/Logical Operator1'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (real32_T)
    ((!rtb_RelationalOperator_d) && rtu_IN) * 0.1F;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator2_a;
}

/*
 * Output and update for atomic system:
 *    '<S1>/MATLAB Function11'
 *    '<S24>/MATLAB Function1'
 */
void PUscuff_MATLABFunction11(const boolean_T rtu_u[25], uint8_T rtu_numCyl,
  rtB_MATLABFunction11_PUscuff *localB, struct fPUscuff* inst)
{
  int32_T c;
  int32_T d;
  boolean_T y;
  int32_T ix;
  boolean_T exitg1;

  /* MATLAB Function 'Activation and Detection Logic/MATLAB Function11': '<S9>:1' */
  c = (int32_T)(rtu_numCyl + 1U);
  if ((uint32_T)c > 255U) {
    c = 255;
  }

  if (2 > (uint8_T)c) {
    d = -1;
    c = 0;
  } else {
    d = 0;
    c = (uint8_T)c;
  }

  y = false;
  ix = 1;
  exitg1 = false;
  while ((!exitg1) && (ix <= (c - d) - 1)) {
    if (rtu_u[d + ix]) {
      y = true;
      exitg1 = true;
    } else {
      ix++;
    }
  }

  if (y) {
    /* '<S9>:1:4' */
    /* '<S9>:1:5' */
    localB->y = true;
  } else {
    /* '<S9>:1:7' */
    localB->y = false;
  }
}

/*
 * System initialize for atomic system:
 *    '<S2>/Filter1'
 *    '<S2>/Filter4'
 *    '<S2>/Filter9'
 */
void PUscuff_Filter1_Init(rtDW_Filter1_PUscuff *localDW, struct fPUscuff* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S20>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S2>/Filter1'
 *    '<S2>/Filter4'
 *    '<S2>/Filter9'
 */
void PUscuff_Filter1(real32_T rtu_in, boolean_T rtu_reset, rtB_Filter1_PUscuff
                     *localB, const rtC_Filter1_PUscuff *localC,
                     rtDW_Filter1_PUscuff *localDW, struct fPUscuff* inst)
{
  /* DiscreteIntegrator: '<S20>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  if (rtu_reset || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_in;
  }

  localB->DiscreteTimeIntegrator = localDW->DiscreteTimeIntegrator_DSTATE;

  /* End of DiscreteIntegrator: '<S20>/Discrete-Time Integrator' */

  /* Update for DiscreteIntegrator: '<S20>/Discrete-Time Integrator' incorporates:
   *  Product: '<S20>/Divide4'
   *  Sum: '<S20>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;
  localDW->DiscreteTimeIntegrator_DSTATE += (rtu_in -
    localB->DiscreteTimeIntegrator) / localC->Switch * 0.1F;
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtu_reset;
}

/* Function for MATLAB Function: '<S6>/MATLAB Function' */
static void PUscuff_merge(int32_T idx[25], real32_T x[25], int32_T offset,
  int32_T np, int32_T nq, int32_T iwork[25], real32_T xwork[25], struct fPUscuff* inst)
{
  int32_T n;
  int32_T q;
  int32_T iout;
  int32_T n_tmp;
  int32_T exitg1;
  if (nq != 0) {
    n_tmp = np + nq;
    for (q = 0; q < n_tmp; q++) {
      iout = offset + q;
      iwork[q] = idx[iout];
      xwork[q] = x[iout];
    }

    n = 0;
    q = np;
    iout = offset - 1;
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

/* Function for MATLAB Function: '<S6>/MATLAB Function' */
static void PUscuff_sort(real32_T x[25], struct fPUscuff* inst)
{
  int32_T idx[25];
  int32_T iwork[25];
  real32_T xwork[25];
  real32_T x4[4];
  int8_T idx4[4];
  int32_T ib;
  int8_T perm[4];
  int32_T i2;
  int32_T i3;
  int32_T i4;
  int32_T bLen;
  real32_T tmp;
  real32_T tmp_0;
  x4[0] = 0.0F;
  idx4[0] = 0;
  x4[1] = 0.0F;
  idx4[1] = 0;
  x4[2] = 0.0F;
  idx4[2] = 0;
  x4[3] = 0.0F;
  idx4[3] = 0;
  ib = 0;
  for (bLen = 0; bLen < 25; bLen++) {
    idx[bLen] = 0;
    ib++;
    idx4[ib - 1] = (int8_T)(bLen + 1);
    x4[ib - 1] = x[bLen];
    if (ib == 4) {
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

      i2 = perm[0] - 1;
      idx[bLen - 3] = idx4[i2];
      i3 = perm[1] - 1;
      idx[bLen - 2] = idx4[i3];
      ib = perm[2] - 1;
      idx[bLen - 1] = idx4[ib];
      i4 = perm[3] - 1;
      idx[bLen] = idx4[i4];
      x[bLen - 3] = x4[i2];
      x[bLen - 2] = x4[i3];
      x[bLen - 1] = x4[ib];
      x[bLen] = x4[i4];
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

    for (bLen = 0; bLen < ib; bLen++) {
      i2 = perm[bLen] - 1;
      i3 = (bLen - ib) + 25;
      idx[i3] = idx4[i2];
      x[i3] = x4[i2];
    }
  }

  for (bLen = 0; bLen < 25; bLen++) {
    xwork[bLen] = 0.0F;
    iwork[bLen] = 0;
  }

  ib = 6;
  bLen = 4;
  while (ib > 1) {
    if ((ib & 1U) != 0U) {
      ib--;
      i2 = bLen * ib;
      if (25 - i2 > bLen) {
        PUscuff_merge(idx, x, i2, bLen, 25 - (i2 + bLen), iwork, xwork, inst);
      }
    }

    i2 = bLen << 1;
    ib >>= 1;
    for (i3 = 0; i3 < ib; i3++) {
      PUscuff_merge(idx, x, i3 * i2, bLen, bLen, iwork, xwork, inst);
    }

    bLen = i2;
  }

  if (25 > bLen) {
    PUscuff_merge(idx, x, 0, bLen, 25 - bLen, iwork, xwork, inst);
  }
}

/* Function for MATLAB Function: '<S6>/MATLAB Function' */
static int32_T PUscuff_thirdOfFive(const real32_T v_data[], int32_T ia, int32_T
  ib, struct fPUscuff* inst)
{
  int32_T im;
  int32_T j4;
  int32_T j5;
  real32_T v4;
  real32_T v5;
  int32_T b_j1;
  int32_T j2;
  real32_T v5_tmp;
  if ((ia == ib) || (ia + 1 == ib)) {
    im = ia;
  } else if ((ia + 2 == ib) || (ia + 3 == ib)) {
    v4 = v_data[ia - 1];
    if (v4 < v_data[ia]) {
      v5_tmp = v_data[ia + 1];
      if (v_data[ia] < v5_tmp) {
        im = ia + 1;
      } else if (v4 < v5_tmp) {
        im = ia + 2;
      } else {
        im = ia;
      }
    } else {
      v5_tmp = v_data[ia + 1];
      if (v4 < v5_tmp) {
        im = ia;
      } else if (v_data[ia] < v5_tmp) {
        im = ia + 2;
      } else {
        im = ia + 1;
      }
    }
  } else {
    v4 = v_data[ia - 1];
    if (v4 < v_data[ia]) {
      v5_tmp = v_data[ia + 1];
      if (v_data[ia] < v5_tmp) {
        b_j1 = ia;
        j2 = ia;
        im = ia + 2;
      } else if (v4 < v5_tmp) {
        b_j1 = ia;
        j2 = ia + 1;
        im = ia + 1;
      } else {
        b_j1 = ia + 2;
        j2 = ia - 1;
        im = ia + 1;
      }
    } else {
      v5_tmp = v_data[ia + 1];
      if (v4 < v5_tmp) {
        b_j1 = ia + 1;
        j2 = ia - 1;
        im = ia + 2;
      } else if (v_data[ia] < v5_tmp) {
        b_j1 = ia + 1;
        j2 = ia + 1;
        im = ia;
      } else {
        b_j1 = ia + 2;
        j2 = ia;
        im = ia;
      }
    }

    j4 = ia;
    j5 = ia + 1;
    v4 = v_data[ia + 2];
    v5_tmp = v_data[ia + 3];
    v5 = v5_tmp;
    if (v5_tmp < v4) {
      j4 = ia + 1;
      j5 = ia;
      v5 = v4;
      v4 = v5_tmp;
    }

    if (v5 < v_data[b_j1 - 1]) {
      im = b_j1;
    } else if (v5 < v_data[j2]) {
      im = j5 + 3;
    } else if (v4 < v_data[j2]) {
      im = j2 + 1;
    } else {
      if (v4 < v_data[im - 1]) {
        im = j4 + 3;
      }
    }
  }

  return im;
}

/* Function for MATLAB Function: '<S6>/MATLAB Function' */
static void PUscuff_quickselect(real32_T v_data[], const int32_T *v_size,
  int32_T n, int32_T vlen, real32_T *vn, int32_T *nfirst, int32_T *nlast, struct fPUscuff* inst)
{
  int32_T ipiv;
  int32_T ia;
  int32_T ib;
  int32_T oldnv;
  boolean_T checkspeed;
  boolean_T isslow;
  real32_T b_v_data[25];
  real32_T vref;
  real32_T vk;
  int32_T k;
  int32_T ngroupsof5;
  int32_T b_nlast;
  int32_T i1;
  int32_T destidx;
  boolean_T exitg1;
  boolean_T guard1 = false;
  if (n > vlen) {
    *vn = 0.0F;
    *nfirst = 0;
    *nlast = 0;
  } else {
    ipiv = n - 1;
    ia = 0;
    ib = vlen - 1;
    *nfirst = 1;
    *nlast = vlen;
    oldnv = vlen;
    checkspeed = false;
    isslow = false;
    exitg1 = false;
    while ((!exitg1) && (ia + 1 < ib + 1)) {
      i1 = *v_size;
      ngroupsof5 = *v_size;
      for (k = 0; k < ngroupsof5; k++) {
        b_v_data[k] = v_data[k];
      }

      vref = v_data[ipiv];
      b_v_data[ipiv] = v_data[ib];
      b_v_data[ib] = v_data[ipiv];
      ngroupsof5 = ia;
      b_nlast = -1;
      for (k = ia; k < ib; k++) {
        vk = b_v_data[k];
        if (b_v_data[k] == vref) {
          b_v_data[k] = b_v_data[ngroupsof5];
          b_v_data[ngroupsof5] = vk;
          b_nlast++;
          ngroupsof5++;
        } else {
          if (b_v_data[k] < vref) {
            b_v_data[k] = b_v_data[ngroupsof5];
            b_v_data[ngroupsof5] = vk;
            ngroupsof5++;
          }
        }
      }

      b_v_data[ib] = b_v_data[ngroupsof5];
      b_v_data[ngroupsof5] = v_data[ipiv];
      for (k = 0; k < i1; k++) {
        v_data[k] = b_v_data[k];
      }

      *nlast = ngroupsof5 + 1;
      guard1 = false;
      if (n <= ngroupsof5 + 1) {
        *nfirst = ngroupsof5 - b_nlast;
        if (n >= *nfirst) {
          exitg1 = true;
        } else {
          ib = ngroupsof5 - 1;
          guard1 = true;
        }
      } else {
        ia = ngroupsof5 + 1;
        guard1 = true;
      }

      if (guard1) {
        ipiv = (ib - ia) + 1;
        if (checkspeed) {
          isslow = (ipiv > oldnv / 2);
          oldnv = ipiv;
        }

        checkspeed = !checkspeed;
        if (isslow) {
          while (ipiv > 1) {
            ngroupsof5 = ipiv / 5;
            b_nlast = ipiv - ngroupsof5 * 5;
            ipiv = ngroupsof5;
            for (k = 0; k < ngroupsof5; k++) {
              i1 = (k * 5 + ia) + 1;
              i1 = PUscuff_thirdOfFive(v_data, i1, i1 + 4, inst) - 1;
              destidx = ia + k;
              vref = v_data[destidx];
              v_data[destidx] = v_data[i1];
              v_data[i1] = vref;
            }

            if (b_nlast > 0) {
              i1 = (ngroupsof5 * 5 + ia) + 1;
              i1 = PUscuff_thirdOfFive(v_data, i1, (i1 + b_nlast) - 1, inst) - 1;
              destidx = ia + ngroupsof5;
              vref = v_data[destidx];
              v_data[destidx] = v_data[i1];
              v_data[i1] = vref;
              ipiv = ngroupsof5 + 1;
            }
          }
        } else {
          if (ipiv >= 3) {
            ipiv = (ipiv - 1) / 2 + ia;
            if (b_v_data[ia] < b_v_data[ipiv]) {
              if (b_v_data[ipiv] >= b_v_data[ib]) {
                if (b_v_data[ia] < b_v_data[ib]) {
                  ipiv = ib;
                } else {
                  ipiv = ia;
                }
              }
            } else if (b_v_data[ia] < b_v_data[ib]) {
              ipiv = ia;
            } else {
              if (b_v_data[ipiv] < b_v_data[ib]) {
                ipiv = ib;
              }
            }

            if (ipiv + 1 > ia + 1) {
              v_data[ia] = b_v_data[ipiv];
              v_data[ipiv] = b_v_data[ia];
            }
          }
        }

        ipiv = ia;
        *nfirst = ia + 1;
        *nlast = ib + 1;
      }
    }

    *vn = v_data[*nlast - 1];
  }
}

/* Model step function */
void PUscuff_step(RT_MODEL_PUscuff *const PUscuff_M, struct fPUscuff* inst)
{
  struct BlockIO_PUscuff *PUscuff_B = ((struct BlockIO_PUscuff *) PUscuff_M->blockIO);
  struct D_Work_PUscuff *PUscuff_DWork = ((struct D_Work_PUscuff *) PUscuff_M->dwork);
  ExternalOutputs_PUscuff *PUscuff_Y = (ExternalOutputs_PUscuff *)
    PUscuff_M->outputs;
  real32_T LUT_P2s_PrCC_interp[28];
  int32_T idx[14];
  real32_T ycol[14];
  real32_T x[14];
  int32_T iwork[14];
  int32_T d_i;
  int32_T pEnd;
  int32_T p;
  int32_T q;
  int32_T qEnd;
  int32_T kEnd;
  int32_T low_ip1;
  int32_T high_i;
  real32_T knockNoise_Sort[25];
  uint8_T b;
  real32_T absdiff_data[23];
  real32_T xbar;
  real32_T scale;
  real32_T t;
  boolean_T b_x[14];
  real32_T rtb_rPUscf_LearnScale_Lim;
  real32_T rtb_rTiPUscf_LearnReactDelay_Li;
  boolean_T rtb_activation;
  boolean_T rtb_LogicalOperator12;
  boolean_T rtb_LogicalOperator2_p;
  boolean_T rtb_LogicalOperator1_d;
  boolean_T rtb_LogicalOperator4_p;
  boolean_T rtb_actLearn;
  boolean_T rtb_LogicalOperator10;
  boolean_T rtb_LogicalOperator1_i[25];
  boolean_T rtb_LogicalOperator4[25];
  boolean_T rtb_LogicalOperator9_k;
  boolean_T rtb_LogicalOperator8_l;
  real32_T rtb_LUT_P2s_PrCC_ColVect[28];
  real32_T rtb_y_probability[25];
  boolean_T rtb_RelationalOperator_e;
  real32_T rtb_knockNoise_Median;
  real32_T rtb_Product2;
  real32_T rtb_Abs1;
  int32_T i;
  real32_T LUT_P2s_PrCC_interp_0[28];
  uint32_T qY;
  boolean_T rtb_LogicalOperator12_tmp;
  boolean_T exitg1;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  PUscuff_B->BusInput1 = inst->Para;

  /* Switch: '<S7>/Switch4' incorporates:
   *  Constant: '<S7>/Constant4'
   *  Switch: '<S4>/Environment Switch'
   */
  if (PUscuff_B->BusInput1.rTiPUscf_LearnReactDelay != 0.0F) {
    /* Saturate: '<S7>/Saturation4' */
    if (PUscuff_B->BusInput1.rTiPUscf_LearnReactDelay > 100000.0F) {
      rtb_rTiPUscf_LearnReactDelay_Li = 100000.0F;
    } else if (PUscuff_B->BusInput1.rTiPUscf_LearnReactDelay < 0.0F) {
      rtb_rTiPUscf_LearnReactDelay_Li = 0.0F;
    } else {
      rtb_rTiPUscf_LearnReactDelay_Li =
        PUscuff_B->BusInput1.rTiPUscf_LearnReactDelay;
    }

    /* End of Saturate: '<S7>/Saturation4' */
  } else {
    rtb_rTiPUscf_LearnReactDelay_Li = 1200.0F;
  }

  /* End of Switch: '<S7>/Switch4' */

  /* RelationalOperator: '<S24>/Relational Operator1' incorporates:
   *  UnitDelay: '<S24>/Unit Delay3'
   */
  rtb_activation = (PUscuff_DWork->UnitDelay3_DSTATE >=
                    rtb_rTiPUscf_LearnReactDelay_Li);

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  PUscuff_B->BusInput = inst->In;

  /* Logic: '<S2>/Logical Operator12' incorporates:
   *  Constant: '<S37>/Constant'
   *  Logic: '<S24>/Logical Operator1'
   *  Logic: '<S2>/Logical Operator13'
   *  Logic: '<S6>/Logical Operator5'
   *  MATLAB Function: '<S2>/MATLAB Function8'
   *  RelationalOperator: '<S37>/Compare'
   *  Switch: '<S3>/Environment Switch'
   */
  rtb_LogicalOperator12_tmp = !PUscuff_B->BusInput.tGCB_On_Di;
  rtb_LogicalOperator12 = rtb_LogicalOperator12_tmp;

  /* Outputs for Atomic SubSystem: '<S2>/Filter4' */
  /* Switch: '<S3>/Environment Switch' incorporates:
   *  Logic: '<S2>/Logical Operator8'
   */
  PUscuff_Filter1(PUscuff_B->BusInput.rP2s, !PUscuff_B->BusInput.tGCB_On_Di,
                  &PUscuff_B->Filter4, &PUscuff_ConstB.Filter4,
                  &PUscuff_DWork->Filter4, inst);

  /* End of Outputs for SubSystem: '<S2>/Filter4' */

  /* Outputs for Atomic SubSystem: '<S2>/Filter1' */
  /* Logic: '<S2>/Logical Operator12' */
  PUscuff_Filter1(PUscuff_B->Filter4.DiscreteTimeIntegrator,
                  rtb_LogicalOperator12_tmp, &PUscuff_B->Filter1,
                  &PUscuff_ConstB.Filter1, &PUscuff_DWork->Filter1, inst);

  /* End of Outputs for SubSystem: '<S2>/Filter1' */

  /* Switch: '<S7>/Switch5' incorporates:
   *  Constant: '<S7>/Constant5'
   *  Switch: '<S4>/Environment Switch'
   */
  if (PUscuff_B->BusInput1.rPUscf_LearnScale != 0.0F) {
    /* Saturate: '<S7>/Saturation5' */
    if (PUscuff_B->BusInput1.rPUscf_LearnScale > 100000.0F) {
      rtb_rPUscf_LearnScale_Lim = 100000.0F;
    } else if (PUscuff_B->BusInput1.rPUscf_LearnScale < 0.0F) {
      rtb_rPUscf_LearnScale_Lim = 0.0F;
    } else {
      rtb_rPUscf_LearnScale_Lim = PUscuff_B->BusInput1.rPUscf_LearnScale;
    }

    /* End of Saturate: '<S7>/Saturation5' */
  } else {
    rtb_rPUscf_LearnScale_Lim = 1.0F;
  }

  /* End of Switch: '<S7>/Switch5' */

  /* Switch: '<S23>/Switch3' incorporates:
   *  Constant: '<S2>/Constant6'
   *  Logic: '<S2>/Logical Operator12'
   */
  if (rtb_LogicalOperator12_tmp) {
    rtb_LogicalOperator12 = false;
  } else {
    /* Abs: '<S2>/Abs1' incorporates:
     *  Sum: '<S2>/Subtract1'
     */
    rtb_Abs1 = (real32_T)fabs(PUscuff_B->Filter1.DiscreteTimeIntegrator -
      PUscuff_B->Filter4.DiscreteTimeIntegrator);

    /* Product: '<S2>/Product2' incorporates:
     *  Constant: '<S2>/Constant3'
     */
    rtb_Product2 = 0.05F * rtb_rPUscf_LearnScale_Lim;

    /* Switch: '<S23>/Switch1' incorporates:
     *  Constant: '<S2>/Constant4'
     *  RelationalOperator: '<S23>/groesser '
     *  RelationalOperator: '<S23>/kleiner'
     *  Sum: '<S2>/Subtract2'
     *  UnitDelay: '<S23>/Unit Delay2'
     */
    if (rtb_Abs1 >= rtb_Product2 - 0.02F) {
      rtb_LogicalOperator12 = ((rtb_Abs1 > rtb_Product2) ||
        PUscuff_DWork->UnitDelay2_DSTATE);
    }

    /* End of Switch: '<S23>/Switch1' */
  }

  /* End of Switch: '<S23>/Switch3' */

  /* Outputs for Atomic SubSystem: '<S2>/TON2' */
  /* Logic: '<S2>/Logical Operator5' incorporates:
   *  Constant: '<S2>/Constant7'
   */
  PUscuff_TON1(!rtb_LogicalOperator12, 20.0F, &PUscuff_B->TON2_d,
               &PUscuff_DWork->TON2_d, inst);

  /* End of Outputs for SubSystem: '<S2>/TON2' */

  /* Outputs for Atomic SubSystem: '<S2>/Filter9' */
  /* Switch: '<S3>/Environment Switch' incorporates:
   *  Logic: '<S2>/Logical Operator2'
   */
  PUscuff_Filter1(PUscuff_B->BusInput.rP2s, !PUscuff_B->BusInput.tGCB_On_Di,
                  &PUscuff_B->Filter9, &PUscuff_ConstB.Filter9,
                  &PUscuff_DWork->Filter9, inst);

  /* End of Outputs for SubSystem: '<S2>/Filter9' */

  /* RelationalOperator: '<S2>/Relational Operator' incorporates:
   *  Abs: '<S2>/Abs5'
   *  Constant: '<S2>/Constant8'
   *  Product: '<S2>/Product1'
   *  Sum: '<S2>/Subtract7'
   *  Switch: '<S3>/Environment Switch'
   */
  rtb_LogicalOperator2_p = ((real32_T)fabs
    (PUscuff_B->Filter9.DiscreteTimeIntegrator - PUscuff_B->BusInput.rP2s) >
    0.1F * rtb_rPUscf_LearnScale_Lim);

  /* Outputs for Atomic SubSystem: '<S2>/TON5' */
  /* Logic: '<S2>/Logical Operator9' incorporates:
   *  Constant: '<S2>/Constant5'
   */
  PUscuff_TON1(!rtb_LogicalOperator2_p, 120.0F, &PUscuff_B->TON5,
               &PUscuff_DWork->TON5, inst);

  /* End of Outputs for SubSystem: '<S2>/TON5' */

  /* Logic: '<S2>/Logical Operator1' */
  rtb_LogicalOperator1_d = !PUscuff_B->TON5.LogicalOperator3;

  /* Logic: '<S2>/Logical Operator6' incorporates:
   *  Constant: '<S2>/Constant9'
   *  RelationalOperator: '<S2>/Relational Operator3'
   *  UnitDelay: '<S2>/Unit Delay1'
   */
  rtb_actLearn = (rtb_LogicalOperator12_tmp || rtb_LogicalOperator2_p ||
                  (PUscuff_DWork->UnitDelay1_DSTATE >= 1800.0F));

  /* DiscreteIntegrator: '<S2>/Discrete-Time Integrator' incorporates:
   *  Constant: '<S2>/Constant21'
   */
  if (rtb_actLearn || (PUscuff_DWork->DiscreteTimeIntegrator_PrevRese != 0)) {
    PUscuff_DWork->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  rtb_rPUscf_LearnScale_Lim = PUscuff_DWork->DiscreteTimeIntegrator_DSTATE;

  /* RelationalOperator: '<S2>/Relational Operator2' incorporates:
   *  Constant: '<S2>/Constant10'
   *  DiscreteIntegrator: '<S2>/Discrete-Time Integrator'
   */
  rtb_LogicalOperator4_p = (PUscuff_DWork->DiscreteTimeIntegrator_DSTATE >=
    1800.0F);

  /* Switch: '<S7>/Switch2' incorporates:
   *  Constant: '<S7>/Constant2'
   *  Switch: '<S4>/Environment Switch'
   */
  if (PUscuff_B->BusInput1.rTiPUscf_EnaDelay != 0.0F) {
    /* Saturate: '<S7>/Saturation2' */
    if (PUscuff_B->BusInput1.rTiPUscf_EnaDelay > 100000.0F) {
      rtb_Abs1 = 100000.0F;
    } else if (PUscuff_B->BusInput1.rTiPUscf_EnaDelay < 0.0F) {
      rtb_Abs1 = 0.0F;
    } else {
      rtb_Abs1 = PUscuff_B->BusInput1.rTiPUscf_EnaDelay;
    }

    /* End of Saturate: '<S7>/Saturation2' */
  } else {
    rtb_Abs1 = 20.0F;
  }

  /* End of Switch: '<S7>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S2>/TON1' */
  /* Switch: '<S3>/Environment Switch' */
  PUscuff_TON1(PUscuff_B->BusInput.tGCB_On_Di, rtb_Abs1, &PUscuff_B->TON1_n,
               &PUscuff_DWork->TON1_n, inst);

  /* End of Outputs for SubSystem: '<S2>/TON1' */

  /* Switch: '<S2>/Switch' */
  if (rtb_LogicalOperator1_d) {
    rtb_LogicalOperator10 = PUscuff_B->TON2_d.LogicalOperator3;
  } else {
    rtb_LogicalOperator10 = rtb_LogicalOperator4_p;
  }

  /* End of Switch: '<S2>/Switch' */

  /* Logic: '<S2>/Logical Operator10' incorporates:
   *  Switch: '<S3>/Environment Switch'
   */
  rtb_LogicalOperator10 = (rtb_activation && rtb_LogicalOperator10 &&
    PUscuff_B->TON1_n.LogicalOperator3 && PUscuff_B->BusInput.tPr_CC_GoodQual);

  /* MATLAB Function: '<S2>/MATLAB Function8' incorporates:
   *  Switch: '<S3>/Environment Switch'
   */
  /* MATLAB Function 'Crankcase Pressure Learning and Prediction/MATLAB Function8': '<S25>:1' */
  /* '<S25>:1:63' */
  /* '<S25>:1:5' */
  /* '<S25>:1:7' */
  if ((!PUscuff_DWork->LUT_P2s_PrCC_not_empty) || rtb_LogicalOperator12_tmp) {
    /* '<S25>:1:17' */
    /* '<S25>:1:18' */
    for (i = 0; i < 28; i++) {
      PUscuff_DWork->LUT_P2s_PrCC[i] = 0.0F;
    }

    PUscuff_DWork->LUT_P2s_PrCC_not_empty = true;

    /* '<S25>:1:20' */
    for (d_i = 0; d_i < 13; d_i++) {
      /* '<S25>:1:20' */
      /* '<S25>:1:23' */
      PUscuff_DWork->LUT_P2s_PrCC[d_i + 1] = PUscuff_DWork->LUT_P2s_PrCC[d_i] +
        1.0E-10F;
    }
  }

  if (rtb_LogicalOperator10) {
    /* '<S25>:1:31' */
    /* '<S25>:1:33' */
    PUscuff_DWork->LUT_P2s_PrCC[1] = 1.0F;

    /* '<S25>:1:34' */
    PUscuff_DWork->LUT_P2s_PrCC[15] = 0.0F;

    /* '<S25>:1:36' */
    for (d_i = 0; d_i < 12; d_i++) {
      /* '<S25>:1:36' */
      if ((PUscuff_B->Filter4.DiscreteTimeIntegrator > PUscuff_DWork->rLearnTmp)
          && (PUscuff_B->Filter4.DiscreteTimeIntegrator <
              (PUscuff_DWork->rLearnTmp + 0.5F) - 0.05F)) {
        /* '<S25>:1:40' */
        /* '<S25>:1:41' */
        PUscuff_DWork->LUT_P2s_PrCC[d_i + 2] =
          PUscuff_B->Filter4.DiscreteTimeIntegrator;

        /* '<S25>:1:42' */
        PUscuff_DWork->LUT_P2s_PrCC[d_i + 16] = PUscuff_B->BusInput.tPr_CC_Ai;
      }

      /* '<S25>:1:44' */
      PUscuff_DWork->rLearnTmp += 0.5F;
    }
  }

  /* '<S25>:1:51' */
  for (i = 0; i <= 13; i += 2) {
    rtb_LogicalOperator2_p = true;
    rtb_knockNoise_Median = PUscuff_DWork->LUT_P2s_PrCC[i + 1];
    if (rtb_knockNoise_Median != PUscuff_DWork->LUT_P2s_PrCC[i]) {
      rtb_LogicalOperator2_p = (PUscuff_DWork->LUT_P2s_PrCC[i] <=
        rtb_knockNoise_Median);
    }

    if (rtb_LogicalOperator2_p) {
      idx[i] = i + 1;
      idx[i + 1] = i + 2;
    } else {
      idx[i] = i + 2;
      idx[i + 1] = i + 1;
    }
  }

  d_i = 2;
  while (d_i < 14) {
    high_i = d_i << 1;
    i = 1;
    pEnd = d_i + 1;
    while (pEnd < 15) {
      p = i - 1;
      q = pEnd - 1;
      qEnd = i + high_i;
      if (qEnd > 15) {
        qEnd = 15;
      }

      low_ip1 = 0;
      kEnd = qEnd - i;
      while (low_ip1 + 1 <= kEnd) {
        rtb_LogicalOperator2_p = true;
        rtb_knockNoise_Median = PUscuff_DWork->LUT_P2s_PrCC[idx[p] - 1];
        xbar = PUscuff_DWork->LUT_P2s_PrCC[idx[q] - 1];
        if (rtb_knockNoise_Median != xbar) {
          rtb_LogicalOperator2_p = (rtb_knockNoise_Median <= xbar);
        }

        if (rtb_LogicalOperator2_p) {
          iwork[low_ip1] = idx[p];
          p++;
          if (p + 1 == pEnd) {
            while (q + 1 < qEnd) {
              low_ip1++;
              iwork[low_ip1] = idx[q];
              q++;
            }
          }
        } else {
          iwork[low_ip1] = idx[q];
          q++;
          if (q + 1 == qEnd) {
            while (p + 1 < pEnd) {
              low_ip1++;
              iwork[low_ip1] = idx[p];
              p++;
            }
          }
        }

        low_ip1++;
      }

      for (pEnd = -1; pEnd < kEnd - 1; pEnd++) {
        idx[i + pEnd] = iwork[pEnd + 1];
      }

      i = qEnd;
      pEnd = qEnd + d_i;
    }

    d_i = high_i;
  }

  for (qEnd = 0; qEnd < 28; qEnd++) {
    LUT_P2s_PrCC_interp[qEnd] = PUscuff_DWork->LUT_P2s_PrCC[qEnd];
  }

  for (d_i = 0; d_i < 2; d_i++) {
    for (low_ip1 = 0; low_ip1 < 14; low_ip1++) {
      ycol[low_ip1] = LUT_P2s_PrCC_interp[(14 * d_i + idx[low_ip1]) - 1];
    }

    for (low_ip1 = 0; low_ip1 < 14; low_ip1++) {
      LUT_P2s_PrCC_interp[low_ip1 + 14 * d_i] = ycol[low_ip1];
    }
  }

  /* '<S25>:1:54' */
  for (d_i = 0; d_i < 13; d_i++) {
    /* '<S25>:1:54' */
    rtb_knockNoise_Median = LUT_P2s_PrCC_interp[d_i + 1];
    if (rtb_knockNoise_Median == LUT_P2s_PrCC_interp[d_i]) {
      /* '<S25>:1:56' */
      /* '<S25>:1:57' */
      LUT_P2s_PrCC_interp[d_i + 1] = rtb_knockNoise_Median + 1.0E-6F;
    }
  }

  /* '<S25>:1:63' */
  for (qEnd = 0; qEnd < 14; qEnd++) {
    ycol[qEnd] = LUT_P2s_PrCC_interp[qEnd + 14];
    x[qEnd] = LUT_P2s_PrCC_interp[qEnd];
  }

  if (LUT_P2s_PrCC_interp[1] < LUT_P2s_PrCC_interp[0]) {
    for (low_ip1 = 0; low_ip1 < 7; low_ip1++) {
      rtb_Product2 = x[low_ip1];
      x[low_ip1] = x[13 - low_ip1];
      x[13 - low_ip1] = rtb_Product2;
    }

    for (i = 0; i < 7; i++) {
      rtb_Product2 = ycol[i];
      ycol[i] = ycol[13 - i];
      ycol[13 - i] = rtb_Product2;
    }
  }

  if (PUscuff_B->Filter4.DiscreteTimeIntegrator > x[13]) {
    rtb_Product2 = (PUscuff_B->Filter4.DiscreteTimeIntegrator - x[13]) / (x[13]
      - x[12]) * (ycol[13] - ycol[12]) + ycol[13];
  } else if (PUscuff_B->Filter4.DiscreteTimeIntegrator < x[0]) {
    rtb_Product2 = (PUscuff_B->Filter4.DiscreteTimeIntegrator - x[0]) / (x[1] -
      x[0]) * (ycol[1] - ycol[0]) + ycol[0];
  } else {
    d_i = 1;
    low_ip1 = 2;
    high_i = 14;
    while (high_i > low_ip1) {
      i = (d_i + high_i) >> 1;
      if (PUscuff_B->Filter4.DiscreteTimeIntegrator >= x[i - 1]) {
        d_i = i;
        low_ip1 = i + 1;
      } else {
        high_i = i;
      }
    }

    rtb_Product2 = x[d_i - 1];
    rtb_Product2 = (PUscuff_B->Filter4.DiscreteTimeIntegrator - rtb_Product2) /
      (x[d_i] - rtb_Product2);
    if (rtb_Product2 == 0.0F) {
      rtb_Product2 = ycol[d_i - 1];
    } else if (rtb_Product2 == 1.0F) {
      rtb_Product2 = ycol[d_i];
    } else {
      rtb_knockNoise_Median = ycol[d_i - 1];
      if (rtb_knockNoise_Median == ycol[d_i]) {
        rtb_Product2 = rtb_knockNoise_Median;
      } else {
        rtb_Product2 = (1.0F - rtb_Product2) * rtb_knockNoise_Median +
          rtb_Product2 * ycol[d_i];
      }
    }
  }

  /* '<S25>:1:65' */
  /* '<S25>:1:66' */
  /* '<S25>:1:67' */
  /* '<S25>:1:70' */
  PUscuff_DWork->rLearnTmp = 1.3F;
  for (qEnd = 0; qEnd < 14; qEnd++) {
    rtb_LUT_P2s_PrCC_ColVect[qEnd] = LUT_P2s_PrCC_interp[qEnd];
    rtb_LUT_P2s_PrCC_ColVect[qEnd + 14] = LUT_P2s_PrCC_interp[qEnd + 14];
  }

  /* MATLAB Function: '<S6>/MATLAB Function' incorporates:
   *  Switch: '<S3>/Environment Switch'
   */
  /* MATLAB Function 'Knock Anomaly Detection/MATLAB Function': '<S44>:1' */
  /* '<S44>:1:4' */
  for (i = 0; i < 25; i++) {
    knockNoise_Sort[i] = PUscuff_B->BusInput.rKnockNoise[i];
  }

  PUscuff_sort(knockNoise_Sort, inst);
  qEnd = (int32_T)(PUscuff_B->BusInput.iNumCyl + 1U);
  if ((uint32_T)qEnd > 255U) {
    qEnd = 255;
  }

  if (2 > (uint8_T)qEnd) {
    d_i = 0;
    high_i = 0;
  } else {
    d_i = 1;
    high_i = (uint8_T)qEnd;
  }

  /* '<S44>:1:6' */
  i = high_i - d_i;
  if (i == 0) {
    rtb_knockNoise_Median = 0.0F;
  } else if (i <= 4) {
    if (i == 0) {
      rtb_knockNoise_Median = 0.0F;
    } else if (i == 1) {
      rtb_knockNoise_Median = PUscuff_B->BusInput.rKnockNoise[d_i];
    } else if (i == 2) {
      rtb_knockNoise_Median = PUscuff_B->BusInput.rKnockNoise[d_i + 1];
      if ((rtb_knockNoise_Median < 0.0F) != (PUscuff_B->BusInput.rKnockNoise[d_i]
           < 0.0F)) {
        rtb_knockNoise_Median = (rtb_knockNoise_Median +
          PUscuff_B->BusInput.rKnockNoise[d_i]) / 2.0F;
      } else {
        rtb_knockNoise_Median = (rtb_knockNoise_Median -
          PUscuff_B->BusInput.rKnockNoise[d_i]) / 2.0F +
          PUscuff_B->BusInput.rKnockNoise[d_i];
      }
    } else if (i == 3) {
      rtb_knockNoise_Median = PUscuff_B->BusInput.rKnockNoise[d_i + 1];
      if (PUscuff_B->BusInput.rKnockNoise[d_i] < rtb_knockNoise_Median) {
        xbar = PUscuff_B->BusInput.rKnockNoise[d_i + 2];
        if (rtb_knockNoise_Median < xbar) {
          qEnd = 1;
        } else if (PUscuff_B->BusInput.rKnockNoise[d_i] < xbar) {
          qEnd = 2;
        } else {
          qEnd = 0;
        }
      } else {
        xbar = PUscuff_B->BusInput.rKnockNoise[d_i + 2];
        if (PUscuff_B->BusInput.rKnockNoise[d_i] < xbar) {
          qEnd = 0;
        } else if (rtb_knockNoise_Median < xbar) {
          qEnd = 2;
        } else {
          qEnd = 1;
        }
      }

      rtb_knockNoise_Median = PUscuff_B->BusInput.rKnockNoise[d_i + qEnd];
    } else {
      rtb_knockNoise_Median = PUscuff_B->BusInput.rKnockNoise[d_i + 1];
      if (PUscuff_B->BusInput.rKnockNoise[d_i] < rtb_knockNoise_Median) {
        xbar = PUscuff_B->BusInput.rKnockNoise[d_i + 2];
        if (rtb_knockNoise_Median < xbar) {
          low_ip1 = 0;
          high_i = 1;
          i = 2;
        } else if (PUscuff_B->BusInput.rKnockNoise[d_i] < xbar) {
          low_ip1 = 0;
          high_i = 2;
          i = 1;
        } else {
          low_ip1 = 2;
          high_i = 0;
          i = 1;
        }
      } else {
        xbar = PUscuff_B->BusInput.rKnockNoise[d_i + 2];
        if (PUscuff_B->BusInput.rKnockNoise[d_i] < xbar) {
          low_ip1 = 1;
          high_i = 0;
          i = 2;
        } else if (rtb_knockNoise_Median < xbar) {
          low_ip1 = 1;
          high_i = 2;
          i = 0;
        } else {
          low_ip1 = 2;
          high_i = 1;
          i = 0;
        }
      }

      qEnd = d_i + low_ip1;
      rtb_knockNoise_Median = PUscuff_B->BusInput.rKnockNoise[d_i + 3];
      if (PUscuff_B->BusInput.rKnockNoise[qEnd] < rtb_knockNoise_Median) {
        qEnd = d_i + i;
        if (rtb_knockNoise_Median < PUscuff_B->BusInput.rKnockNoise[qEnd]) {
          qEnd = d_i + high_i;
          if ((PUscuff_B->BusInput.rKnockNoise[qEnd] < 0.0F) !=
              (rtb_knockNoise_Median < 0.0F)) {
            rtb_knockNoise_Median = (PUscuff_B->BusInput.rKnockNoise[qEnd] +
              rtb_knockNoise_Median) / 2.0F;
          } else {
            rtb_knockNoise_Median = (rtb_knockNoise_Median -
              PUscuff_B->BusInput.rKnockNoise[qEnd]) / 2.0F +
              PUscuff_B->BusInput.rKnockNoise[qEnd];
          }
        } else {
          d_i += high_i;
          if ((PUscuff_B->BusInput.rKnockNoise[d_i] < 0.0F) !=
              (PUscuff_B->BusInput.rKnockNoise[qEnd] < 0.0F)) {
            rtb_knockNoise_Median = (PUscuff_B->BusInput.rKnockNoise[d_i] +
              PUscuff_B->BusInput.rKnockNoise[qEnd]) / 2.0F;
          } else {
            rtb_knockNoise_Median = (PUscuff_B->BusInput.rKnockNoise[qEnd] -
              PUscuff_B->BusInput.rKnockNoise[d_i]) / 2.0F +
              PUscuff_B->BusInput.rKnockNoise[d_i];
          }
        }
      } else {
        d_i += high_i;
        if ((PUscuff_B->BusInput.rKnockNoise[qEnd] < 0.0F) !=
            (PUscuff_B->BusInput.rKnockNoise[d_i] < 0.0F)) {
          rtb_knockNoise_Median = (PUscuff_B->BusInput.rKnockNoise[qEnd] +
            PUscuff_B->BusInput.rKnockNoise[d_i]) / 2.0F;
        } else {
          rtb_knockNoise_Median = (PUscuff_B->BusInput.rKnockNoise[d_i] -
            PUscuff_B->BusInput.rKnockNoise[qEnd]) / 2.0F +
            PUscuff_B->BusInput.rKnockNoise[qEnd];
        }
      }
    }
  } else {
    low_ip1 = i >> 1;
    if ((i & 1U) == 0U) {
      pEnd = i;
      for (qEnd = 0; qEnd < i; qEnd++) {
        rtb_y_probability[qEnd] = PUscuff_B->BusInput.rKnockNoise[d_i + qEnd];
      }

      PUscuff_quickselect(rtb_y_probability, &pEnd, low_ip1 + 1, high_i - d_i,
                          &rtb_knockNoise_Median, &qEnd, &i, inst);
      if (low_ip1 < qEnd) {
        PUscuff_quickselect(rtb_y_probability, &pEnd, low_ip1, i - 1, &xbar,
                            &d_i, &high_i, inst);
        if ((rtb_knockNoise_Median < 0.0F) != (xbar < 0.0F)) {
          rtb_knockNoise_Median = (rtb_knockNoise_Median + xbar) / 2.0F;
        } else {
          rtb_knockNoise_Median += (xbar - rtb_knockNoise_Median) / 2.0F;
        }
      }
    } else {
      pEnd = i;
      for (qEnd = 0; qEnd < i; qEnd++) {
        rtb_y_probability[qEnd] = PUscuff_B->BusInput.rKnockNoise[d_i + qEnd];
      }

      PUscuff_quickselect(rtb_y_probability, &pEnd, low_ip1 + 1, high_i - d_i,
                          &rtb_knockNoise_Median, &i, &qEnd, inst);
    }
  }

  qY = 25U - PUscuff_B->BusInput.iNumCyl;
  if (qY > 25U) {
    qY = 0U;
  }

  b = (uint8_T)((int32_T)qY + 3);
  if (b > 23) {
    d_i = -1;
    low_ip1 = -1;
  } else {
    d_i = b - 2;
    low_ip1 = 22;
  }

  /* '<S44>:1:7' */
  for (i = 0; i < 25; i++) {
    rtb_y_probability[i] = PUscuff_B->BusInput.rKnockNoise[i];
  }

  PUscuff_sort(rtb_y_probability, inst);
  high_i = low_ip1 - d_i;
  if (high_i == 0) {
    xbar = 0.0F;
  } else if (high_i == 1) {
    xbar = 0.0F;
  } else {
    if (high_i == 0) {
      xbar = 0.0F;
    } else {
      xbar = knockNoise_Sort[d_i + 1];
      for (i = 2; i <= high_i; i++) {
        xbar += knockNoise_Sort[d_i + i];
      }
    }

    xbar /= ((real32_T)high_i - 1.0F) + 1.0F;
    for (i = 0; i < high_i; i++) {
      absdiff_data[i] = (real32_T)fabs(knockNoise_Sort[(d_i + i) + 1] - xbar);
    }

    xbar = 0.0F;
    scale = 1.29246971E-26F;
    for (pEnd = 0; pEnd < low_ip1 - d_i; pEnd++) {
      if (absdiff_data[pEnd] > scale) {
        t = scale / absdiff_data[pEnd];
        xbar = xbar * t * t + 1.0F;
        scale = absdiff_data[pEnd];
      } else {
        t = absdiff_data[pEnd] / scale;
        xbar += t * t;
      }
    }

    xbar = scale * (real32_T)sqrt(xbar);
    xbar /= (real32_T)sqrt((real32_T)(low_ip1 - d_i) - 1.0F);
  }

  /* End of MATLAB Function: '<S6>/MATLAB Function' */

  /* Outputs for Atomic SubSystem: '<S6>/Filter1' */
  /* Constant: '<S6>/Constant1' incorporates:
   *  Logic: '<S6>/Logical Operator2'
   *  Switch: '<S3>/Environment Switch'
   */
  PUscuff_Filter2(rtb_knockNoise_Median, 15.0F, !PUscuff_B->BusInput.tGCB_On_Di,
                  &PUscuff_B->Filter1_a, &PUscuff_DWork->Filter1_a, inst);

  /* End of Outputs for SubSystem: '<S6>/Filter1' */

  /* Outputs for Atomic SubSystem: '<S6>/Filter3' */
  /* Constant: '<S6>/Constant7' incorporates:
   *  Logic: '<S6>/Logical Operator3'
   *  Switch: '<S3>/Environment Switch'
   */
  PUscuff_Filter2(xbar, 15.0F, !PUscuff_B->BusInput.tGCB_On_Di,
                  &PUscuff_B->Filter3, &PUscuff_DWork->Filter3, inst);

  /* End of Outputs for SubSystem: '<S6>/Filter3' */

  /* MATLAB Function: '<S6>/MATLAB Function3' incorporates:
   *  MATLAB Function: '<S6>/MATLAB Function2'
   *  Switch: '<S3>/Environment Switch'
   */
  /* MATLAB Function 'Knock Anomaly Detection/MATLAB Function2': '<S45>:1' */
  /* '<S45>:1:4' */
  /* MATLAB Function 'Knock Anomaly Detection/MATLAB Function3': '<S46>:1' */
  /* '<S46>:1:11' */
  if (PUscuff_B->Filter3.DiscreteTimeIntegrator > 1.0E-10F) {
    xbar = PUscuff_B->Filter3.DiscreteTimeIntegrator;
  } else {
    xbar = 1.0E-10F;
  }

  /* '<S46>:1:14' */
  rtb_knockNoise_Median = 1.0F / (xbar * 2.50662827F);
  for (i = 0; i < 25; i++) {
    rtb_y_probability[i] = PUscuff_B->BusInput.rKnockNoise[i] -
      PUscuff_B->Filter1_a.DiscreteTimeIntegrator;
  }

  xbar = xbar * xbar * 2.0F;
  for (i = 0; i < 25; i++) {
    scale = (real32_T)exp(-(rtb_y_probability[i] * rtb_y_probability[i]) / xbar)
      * rtb_knockNoise_Median;
    if (scale >= 100.0F) {
      scale = 100.0F;
    }

    rtb_y_probability[i] = scale;
  }

  /* End of MATLAB Function: '<S6>/MATLAB Function3' */

  /* Outputs for Atomic SubSystem: '<S6>/Filter4' */
  /* DiscreteIntegrator: '<S43>/Discrete-Time Integrator' */
  /* '<S46>:1:16' */
  if (PUscuff_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    for (i = 0; i < 25; i++) {
      PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_n[i] = rtb_y_probability[i];
    }
  }

  /* Update for DiscreteIntegrator: '<S43>/Discrete-Time Integrator' */
  PUscuff_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;
  for (i = 0; i < 25; i++) {
    /* DiscreteIntegrator: '<S43>/Discrete-Time Integrator' incorporates:
     *  Sum: '<S43>/Sum4'
     */
    if (rtb_LogicalOperator12_tmp ||
        (PUscuff_DWork->DiscreteTimeIntegrator_PrevRe_f != 0)) {
      PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_n[i] = rtb_y_probability[i];
    }

    knockNoise_Sort[i] = PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_n[i];

    /* Update for DiscreteIntegrator: '<S43>/Discrete-Time Integrator' incorporates:
     *  Product: '<S43>/Divide4'
     *  Sum: '<S43>/Sum4'
     */
    PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_n[i] += (rtb_y_probability[i] -
      PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_n[i]) / 0.25F * 0.1F;
  }

  /* Update for DiscreteIntegrator: '<S43>/Discrete-Time Integrator' */
  PUscuff_DWork->DiscreteTimeIntegrator_PrevRe_f = (int8_T)
    rtb_LogicalOperator12_tmp;

  /* End of Outputs for SubSystem: '<S6>/Filter4' */

  /* Switch: '<S7>/Switch1' incorporates:
   *  Constant: '<S7>/Constant1'
   *  Switch: '<S4>/Environment Switch'
   */
  if (PUscuff_B->BusInput1.rPUscf_Eps_scale != 0.0F) {
    /* Saturate: '<S7>/Saturation1' */
    if (PUscuff_B->BusInput1.rPUscf_Eps_scale > 100000.0F) {
      rtb_knockNoise_Median = 100000.0F;
    } else if (PUscuff_B->BusInput1.rPUscf_Eps_scale < 1.0E-5F) {
      rtb_knockNoise_Median = 1.0E-5F;
    } else {
      rtb_knockNoise_Median = PUscuff_B->BusInput1.rPUscf_Eps_scale;
    }

    /* End of Saturate: '<S7>/Saturation1' */
  } else {
    rtb_knockNoise_Median = 1.0F;
  }

  /* End of Switch: '<S7>/Switch1' */

  /* Product: '<S6>/Product' incorporates:
   *  Constant: '<S6>/Constant2'
   */
  rtb_knockNoise_Median *= 1.0E-6F;

  /* Outputs for Atomic SubSystem: '<S6>/TON4' */
  /* Switch: '<S3>/Environment Switch' */
  PUscuff_TON1(PUscuff_B->BusInput.tGCB_On_Di, rtb_Abs1, &PUscuff_B->TON4,
               &PUscuff_DWork->TON4, inst);

  /* End of Outputs for SubSystem: '<S6>/TON4' */

  /* Logic: '<S6>/Logical Operator4' incorporates:
   *  RelationalOperator: '<S6>/Relational Operator1'
   *  RelationalOperator: '<S6>/Relational Operator2'
   *  Switch: '<S3>/Environment Switch'
   */
  for (i = 0; i < 25; i++) {
    rtb_LogicalOperator4[i] = ((PUscuff_B->BusInput.rKnockNoise[i] >
      PUscuff_B->Filter1_a.DiscreteTimeIntegrator) && (knockNoise_Sort[i] <
      rtb_knockNoise_Median) && PUscuff_B->TON4.LogicalOperator3);
  }

  /* End of Logic: '<S6>/Logical Operator4' */

  /* Outputs for Atomic SubSystem: '<S6>/TON' */
  for (d_i = 0; d_i < 25; d_i++) {
    /* Logic: '<S47>/Logical Operator2' */
    rtb_LogicalOperator2_p = !rtb_LogicalOperator4[d_i];

    /* DiscreteIntegrator: '<S47>/Discrete-Time Integrator' */
    if (rtb_LogicalOperator2_p ||
        (PUscuff_DWork->DiscreteTimeIntegrator_PrevRe_n[d_i] != 0)) {
      PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_a[d_i] = 0.0F;
    }

    /* RelationalOperator: '<S47>/Relational Operator' incorporates:
     *  Constant: '<S6>/Constant6'
     *  DiscreteIntegrator: '<S47>/Discrete-Time Integrator'
     */
    rtb_RelationalOperator_e = (PUscuff_DWork->
      DiscreteTimeIntegrator_DSTATE_a[d_i] >= 1.0F);

    /* Update for DiscreteIntegrator: '<S47>/Discrete-Time Integrator' incorporates:
     *  DataTypeConversion: '<S55>/Conversion'
     *  Logic: '<S47>/Logical Operator'
     *  Logic: '<S47>/Logical Operator1'
     *  Logic: '<S47>/Logical Operator2'
     */
    PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_a[d_i] += (real32_T)
      ((!rtb_RelationalOperator_e) && rtb_LogicalOperator4[d_i]) * 0.1F;
    PUscuff_DWork->DiscreteTimeIntegrator_PrevRe_n[d_i] = (int8_T)
      rtb_LogicalOperator2_p;

    /* RelationalOperator: '<S47>/Relational Operator' incorporates:
     *  Logic: '<S47>/Logical Operator2'
     *  Logic: '<S47>/Logical Operator3'
     *  Logic: '<S6>/Logical Operator'
     *  Logic: '<S6>/Logical Operator1'
     *  Switch: '<S3>/Environment Switch'
     */
    rtb_LogicalOperator1_i[d_i] = (rtb_RelationalOperator_e &&
      rtb_LogicalOperator4[d_i] && (!PUscuff_B->BusInput.bKnockSig[d_i]));
  }

  /* End of Outputs for SubSystem: '<S6>/TON' */

  /* Outputs for Atomic SubSystem: '<S8>/TON1' */
  /* Switch: '<S3>/Environment Switch' */
  PUscuff_TON1(PUscuff_B->BusInput.tGCB_On_Di, rtb_Abs1, &PUscuff_B->TON1,
               &PUscuff_DWork->TON1, inst);

  /* End of Outputs for SubSystem: '<S8>/TON1' */

  /* Outputs for Atomic SubSystem: '<S8>/Filter2' */
  /* Constant: '<S8>/Constant4' incorporates:
   *  Logic: '<S8>/Logical Operator3'
   *  Switch: '<S3>/Environment Switch'
   */
  PUscuff_Filter2(PUscuff_B->Filter4.DiscreteTimeIntegrator, 15.0F,
                  !PUscuff_B->BusInput.tGCB_On_Di, &PUscuff_B->Filter2,
                  &PUscuff_DWork->Filter2, inst);

  /* End of Outputs for SubSystem: '<S8>/Filter2' */

  /* Outputs for Atomic SubSystem: '<S8>/TON2' */
  /* RelationalOperator: '<S8>/Relational Operator2' incorporates:
   *  Abs: '<S8>/Abs2'
   *  Constant: '<S8>/Constant1'
   *  Constant: '<S8>/Constant2'
   *  Sum: '<S8>/Subtract2'
   */
  PUscuff_TON1((real32_T)fabs(PUscuff_B->Filter4.DiscreteTimeIntegrator -
    PUscuff_B->Filter2.DiscreteTimeIntegrator) < 0.1F, 20.0F, &PUscuff_B->TON2,
               &PUscuff_DWork->TON2, inst);

  /* End of Outputs for SubSystem: '<S8>/TON2' */

  /* MATLAB Function: '<S2>/MATLAB Function8' */
  /* MATLAB Function 'Activation and Detection Logic/Activation Logic/MATLAB Function14': '<S12>:1' */
  for (qEnd = 0; qEnd < 14; qEnd++) {
    LUT_P2s_PrCC_interp_0[qEnd] = LUT_P2s_PrCC_interp[qEnd];
    LUT_P2s_PrCC_interp_0[qEnd + 14] = LUT_P2s_PrCC_interp[qEnd + 14];
  }

  /* MATLAB Function: '<S8>/MATLAB Function14' */
  for (qEnd = 0; qEnd < 14; qEnd++) {
    x[qEnd] = PUscuff_B->Filter4.DiscreteTimeIntegrator -
      LUT_P2s_PrCC_interp_0[qEnd];
  }

  for (low_ip1 = 0; low_ip1 < 14; low_ip1++) {
    b_x[low_ip1] = ((real32_T)fabs(x[low_ip1]) <= 0.5F);
  }

  rtb_LogicalOperator2_p = false;
  i = 0;
  exitg1 = false;
  while ((!exitg1) && (i < 14)) {
    if (!b_x[i]) {
      i++;
    } else {
      rtb_LogicalOperator2_p = true;
      exitg1 = true;
    }
  }

  /* End of MATLAB Function: '<S8>/MATLAB Function14' */

  /* Logic: '<S8>/Logical Operator2' incorporates:
   *  Switch: '<S3>/Environment Switch'
   *  Switch: '<S4>/Environment Switch'
   */
  rtb_LogicalOperator2_p = (PUscuff_B->BusInput1.bPUscf_Ena &&
    PUscuff_B->TON1.LogicalOperator3 && PUscuff_B->BusInput.tPr_CC_GoodQual &&
    PUscuff_B->TON2.LogicalOperator3 && rtb_LogicalOperator2_p);

  /* Switch: '<S7>/Switch3' incorporates:
   *  Constant: '<S7>/Constant3'
   *  Switch: '<S4>/Environment Switch'
   */
  if (PUscuff_B->BusInput1.rPr_CC_PUscf_Dev_HiHi != 0.0F) {
    /* Saturate: '<S7>/Saturation3' */
    if (PUscuff_B->BusInput1.rPr_CC_PUscf_Dev_HiHi > 100000.0F) {
      rtb_knockNoise_Median = 100000.0F;
    } else if (PUscuff_B->BusInput1.rPr_CC_PUscf_Dev_HiHi < 0.0F) {
      rtb_knockNoise_Median = 0.0F;
    } else {
      rtb_knockNoise_Median = PUscuff_B->BusInput1.rPr_CC_PUscf_Dev_HiHi;
    }

    /* End of Saturate: '<S7>/Saturation3' */
  } else {
    rtb_knockNoise_Median = 4.0F;
  }

  /* End of Switch: '<S7>/Switch3' */

  /* MATLAB Function: '<S1>/MATLAB Function11' incorporates:
   *  Switch: '<S3>/Environment Switch'
   */
  PUscuff_MATLABFunction11(rtb_LogicalOperator1_i, PUscuff_B->BusInput.iNumCyl,
    &PUscuff_B->sf_MATLABFunction11, inst);

  /* Outputs for Atomic SubSystem: '<S1>/TOF2' */
  /* Switch: '<S10>/Switch' incorporates:
   *  Constant: '<S10>/Constant1'
   *  Constant: '<S1>/Constant4'
   */
  if (PUscuff_B->sf_MATLABFunction11.y) {
    rtb_Abs1 = 0.0F;
  } else {
    rtb_Abs1 = 300.0F;
  }

  /* End of Switch: '<S10>/Switch' */

  /* DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
  if (PUscuff_DWork->DiscreteTimeIntegrator_IC_LOA_b != 0) {
    PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_m = rtb_Abs1;
  }

  if (PUscuff_B->sf_MATLABFunction11.y &&
      (PUscuff_DWork->DiscreteTimeIntegrator_PrevRe_e <= 0)) {
    PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_m = rtb_Abs1;
  }

  /* RelationalOperator: '<S10>/Relational Operator' incorporates:
   *  Constant: '<S1>/Constant4'
   *  DiscreteIntegrator: '<S10>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_e = (PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_m >=
    300.0F);

  /* Update for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S19>/Conversion'
   *  Logic: '<S10>/Logical Operator5'
   */
  PUscuff_DWork->DiscreteTimeIntegrator_IC_LOA_b = 0U;
  PUscuff_DWork->DiscreteTimeIntegrator_DSTATE_m += 0.1F * (real32_T)
    !PUscuff_B->sf_MATLABFunction11.y;
  PUscuff_DWork->DiscreteTimeIntegrator_PrevRe_e = (int8_T)
    PUscuff_B->sf_MATLABFunction11.y;

  /* Logic: '<S1>/Logical Operator9' incorporates:
   *  Logic: '<S10>/Logical Operator1'
   *  MATLAB Function: '<S2>/MATLAB Function8'
   *  RelationalOperator: '<S1>/Relational Operator2'
   *  Sum: '<S1>/Subtract4'
   *  Switch: '<S3>/Environment Switch'
   */
  rtb_LogicalOperator9_k = ((PUscuff_B->BusInput.tPr_CC_Ai - rtb_Product2 >=
    rtb_knockNoise_Median) && (!rtb_RelationalOperator_e));

  /* End of Outputs for SubSystem: '<S1>/TOF2' */

  /* Logic: '<S1>/Logical Operator8' */
  rtb_LogicalOperator8_l = (rtb_LogicalOperator9_k && rtb_LogicalOperator2_p);

  /* Outport: '<Root>/Out' incorporates:
   *  BusCreator generated from: '<Root>/Out'
   *  MATLAB Function: '<S2>/MATLAB Function8'
   */
  PUscuff_Y->Out.rPr_CC_pred = rtb_Product2;
  PUscuff_Y->Out.bPUscf_LearnEna = rtb_LogicalOperator10;
  for (i = 0; i < 25; i++) {
    PUscuff_Y->Out.bYpredict[i] = rtb_LogicalOperator1_i[i];
  }

  PUscuff_Y->Out.bPUscf_RelTrip = rtb_LogicalOperator2_p;
  PUscuff_Y->Out.bPUscf_TripALL = rtb_LogicalOperator8_l;
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt1 = rtb_LUT_P2s_PrCC_ColVect[0];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt2 = rtb_LUT_P2s_PrCC_ColVect[1];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt3 = rtb_LUT_P2s_PrCC_ColVect[2];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt4 = rtb_LUT_P2s_PrCC_ColVect[3];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt5 = rtb_LUT_P2s_PrCC_ColVect[4];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt6 = rtb_LUT_P2s_PrCC_ColVect[5];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt7 = rtb_LUT_P2s_PrCC_ColVect[6];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt8 = rtb_LUT_P2s_PrCC_ColVect[7];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt9 = rtb_LUT_P2s_PrCC_ColVect[8];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt10 = rtb_LUT_P2s_PrCC_ColVect[9];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt11 = rtb_LUT_P2s_PrCC_ColVect[10];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt12 = rtb_LUT_P2s_PrCC_ColVect[11];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt13 = rtb_LUT_P2s_PrCC_ColVect[12];
  PUscuff_Y->Out.tPUscuff_Map.rP2s_x_pt14 = rtb_LUT_P2s_PrCC_ColVect[13];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt1 = rtb_LUT_P2s_PrCC_ColVect[14];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt2 = rtb_LUT_P2s_PrCC_ColVect[15];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt3 = rtb_LUT_P2s_PrCC_ColVect[16];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt4 = rtb_LUT_P2s_PrCC_ColVect[17];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt5 = rtb_LUT_P2s_PrCC_ColVect[18];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt6 = rtb_LUT_P2s_PrCC_ColVect[19];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt7 = rtb_LUT_P2s_PrCC_ColVect[20];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt8 = rtb_LUT_P2s_PrCC_ColVect[21];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt9 = rtb_LUT_P2s_PrCC_ColVect[22];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt10 = rtb_LUT_P2s_PrCC_ColVect[23];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt11 = rtb_LUT_P2s_PrCC_ColVect[24];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt12 = rtb_LUT_P2s_PrCC_ColVect[25];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt13 = rtb_LUT_P2s_PrCC_ColVect[26];
  PUscuff_Y->Out.tPUscuff_Map.rPrCC_y_pt14 = rtb_LUT_P2s_PrCC_ColVect[27];

  /* End of Outport: '<Root>/Out' */

  /* Logic: '<S2>/Logical Operator3' */
  rtb_RelationalOperator_e = (rtb_LogicalOperator1_d &&
    PUscuff_B->TON2_d.LogicalOperator3);

  /* Logic: '<S2>/Logical Operator4' incorporates:
   *  Logic: '<S2>/Logical Operator7'
   */
  rtb_LogicalOperator4_p = (rtb_LogicalOperator4_p && (!rtb_LogicalOperator1_d));

  /* BusCreator generated from: '<Root>/Dbg' incorporates:
   *  MATLAB Function: '<S6>/MATLAB Function2'
   *  Outport: '<Root>/Dbg'
   *  Switch: '<S3>/Environment Switch'
   */
  PUscuff_Y->Dbg.rP2s_filt_fast = PUscuff_B->Filter4.DiscreteTimeIntegrator;
  PUscuff_Y->Dbg.rP2s_filt_slow = PUscuff_B->Filter9.DiscreteTimeIntegrator;
  PUscuff_Y->Dbg.tPr_CC_Ai = PUscuff_B->BusInput.tPr_CC_Ai;
  PUscuff_Y->Dbg.bLearnEna_cont = rtb_RelationalOperator_e;
  PUscuff_Y->Dbg.bLearnEna_cyclic = rtb_LogicalOperator4_p;
  for (i = 0; i < 25; i++) {
    PUscuff_Y->Dbg.rKnockNoise[i] = PUscuff_B->BusInput.rKnockNoise[i];
    PUscuff_Y->Dbg.rYprobability[i] = knockNoise_Sort[i];
  }

  PUscuff_Y->Dbg.rKnockNoise_median =
    PUscuff_B->Filter1_a.DiscreteTimeIntegrator;
  PUscuff_Y->Dbg.rKnockNoise_stdDev = PUscuff_B->Filter3.DiscreteTimeIntegrator;
  PUscuff_Y->Dbg.bTripPccANDknock = rtb_LogicalOperator9_k;
  PUscuff_Y->Dbg.bLearnReactAfterKnock = rtb_activation;
  PUscuff_Y->Dbg.rP2s_filt_contLearn = PUscuff_B->Filter1.DiscreteTimeIntegrator;

  /* End of BusCreator generated from: '<Root>/Dbg' */

  /* BusCreator generated from: '<Root>/Bus Output' incorporates:
   *  MATLAB Function: '<S2>/MATLAB Function8'
   */
  PUscuff_B->BusConversion_InsertedFor_Bus_b.rPr_CC_pred = rtb_Product2;
  PUscuff_B->BusConversion_InsertedFor_Bus_b.bPUscf_LearnEna =
    rtb_LogicalOperator10;
  for (i = 0; i < 25; i++) {
    PUscuff_B->BusConversion_InsertedFor_Bus_b.bYpredict[i] =
      rtb_LogicalOperator1_i[i];
  }

  PUscuff_B->BusConversion_InsertedFor_Bus_b.bPUscf_RelTrip =
    rtb_LogicalOperator2_p;
  PUscuff_B->BusConversion_InsertedFor_Bus_b.bPUscf_TripALL =
    rtb_LogicalOperator8_l;
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt1 =
    rtb_LUT_P2s_PrCC_ColVect[0];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt2 =
    rtb_LUT_P2s_PrCC_ColVect[1];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt3 =
    rtb_LUT_P2s_PrCC_ColVect[2];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt4 =
    rtb_LUT_P2s_PrCC_ColVect[3];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt5 =
    rtb_LUT_P2s_PrCC_ColVect[4];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt6 =
    rtb_LUT_P2s_PrCC_ColVect[5];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt7 =
    rtb_LUT_P2s_PrCC_ColVect[6];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt8 =
    rtb_LUT_P2s_PrCC_ColVect[7];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt9 =
    rtb_LUT_P2s_PrCC_ColVect[8];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt10 =
    rtb_LUT_P2s_PrCC_ColVect[9];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt11 =
    rtb_LUT_P2s_PrCC_ColVect[10];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt12 =
    rtb_LUT_P2s_PrCC_ColVect[11];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt13 =
    rtb_LUT_P2s_PrCC_ColVect[12];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rP2s_x_pt14 =
    rtb_LUT_P2s_PrCC_ColVect[13];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt1 =
    rtb_LUT_P2s_PrCC_ColVect[14];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt2 =
    rtb_LUT_P2s_PrCC_ColVect[15];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt3 =
    rtb_LUT_P2s_PrCC_ColVect[16];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt4 =
    rtb_LUT_P2s_PrCC_ColVect[17];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt5 =
    rtb_LUT_P2s_PrCC_ColVect[18];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt6 =
    rtb_LUT_P2s_PrCC_ColVect[19];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt7 =
    rtb_LUT_P2s_PrCC_ColVect[20];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt8 =
    rtb_LUT_P2s_PrCC_ColVect[21];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt9 =
    rtb_LUT_P2s_PrCC_ColVect[22];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt10 =
    rtb_LUT_P2s_PrCC_ColVect[23];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt11 =
    rtb_LUT_P2s_PrCC_ColVect[24];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt12 =
    rtb_LUT_P2s_PrCC_ColVect[25];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt13 =
    rtb_LUT_P2s_PrCC_ColVect[26];
  PUscuff_B->BusConversion_InsertedFor_Bus_b.tPUscuff_Map.rPrCC_y_pt14 =
    rtb_LUT_P2s_PrCC_ColVect[27];

  /* End of BusCreator generated from: '<Root>/Bus Output' */

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Out = PUscuff_B->BusConversion_InsertedFor_Bus_b;

  /* BusCreator generated from: '<Root>/Bus Output1' incorporates:
   *  MATLAB Function: '<S6>/MATLAB Function2'
   *  Switch: '<S3>/Environment Switch'
   */
  PUscuff_B->BusConversion_InsertedFor_BusOu.rP2s_filt_fast =
    PUscuff_B->Filter4.DiscreteTimeIntegrator;
  PUscuff_B->BusConversion_InsertedFor_BusOu.rP2s_filt_slow =
    PUscuff_B->Filter9.DiscreteTimeIntegrator;
  PUscuff_B->BusConversion_InsertedFor_BusOu.tPr_CC_Ai =
    PUscuff_B->BusInput.tPr_CC_Ai;
  PUscuff_B->BusConversion_InsertedFor_BusOu.bLearnEna_cont =
    rtb_RelationalOperator_e;
  PUscuff_B->BusConversion_InsertedFor_BusOu.bLearnEna_cyclic =
    rtb_LogicalOperator4_p;
  for (i = 0; i < 25; i++) {
    PUscuff_B->BusConversion_InsertedFor_BusOu.rKnockNoise[i] =
      PUscuff_B->BusInput.rKnockNoise[i];
    PUscuff_B->BusConversion_InsertedFor_BusOu.rYprobability[i] =
      knockNoise_Sort[i];
  }

  PUscuff_B->BusConversion_InsertedFor_BusOu.rKnockNoise_median =
    PUscuff_B->Filter1_a.DiscreteTimeIntegrator;
  PUscuff_B->BusConversion_InsertedFor_BusOu.rKnockNoise_stdDev =
    PUscuff_B->Filter3.DiscreteTimeIntegrator;
  PUscuff_B->BusConversion_InsertedFor_BusOu.bTripPccANDknock =
    rtb_LogicalOperator9_k;
  PUscuff_B->BusConversion_InsertedFor_BusOu.bLearnReactAfterKnock =
    rtb_activation;
  PUscuff_B->BusConversion_InsertedFor_BusOu.rP2s_filt_contLearn =
    PUscuff_B->Filter1.DiscreteTimeIntegrator;

  /* End of BusCreator generated from: '<Root>/Bus Output1' */

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Dbg = PUscuff_B->BusConversion_InsertedFor_BusOu;

  /* RelationalOperator: '<S35>/FixPt Relational Operator' incorporates:
   *  UnitDelay: '<S35>/Delay Input1'
   */
  rtb_RelationalOperator_e = ((int32_T)rtb_LogicalOperator12_tmp > (int32_T)
    PUscuff_DWork->DelayInput1_DSTATE);

  /* MATLAB Function: '<S24>/MATLAB Function1' incorporates:
   *  Switch: '<S3>/Environment Switch'
   */
  PUscuff_MATLABFunction11(rtb_LogicalOperator1_i, PUscuff_B->BusInput.iNumCyl,
    &PUscuff_B->sf_MATLABFunction1, inst);

  /* Switch: '<S24>/Switch3' incorporates:
   *  Constant: '<S24>/Constant8'
   */
  if (!rtb_RelationalOperator_e) {
    rtb_rTiPUscf_LearnReactDelay_Li = 0.0F;
  }

  /* End of Switch: '<S24>/Switch3' */

  /* DiscreteIntegrator: '<S24>/Discrete-Time Integrator2' incorporates:
   *  Logic: '<S24>/Logical Operator11'
   */
  if (PUscuff_DWork->DiscreteTimeIntegrator2_IC_LOAD != 0) {
    PUscuff_DWork->DiscreteTimeIntegrator2_DSTATE =
      rtb_rTiPUscf_LearnReactDelay_Li;
  }

  if (PUscuff_B->sf_MATLABFunction1.y || rtb_RelationalOperator_e) {
    PUscuff_DWork->DiscreteTimeIntegrator2_DSTATE =
      rtb_rTiPUscf_LearnReactDelay_Li;
  }

  rtb_rTiPUscf_LearnReactDelay_Li =
    PUscuff_DWork->DiscreteTimeIntegrator2_DSTATE;

  /* End of DiscreteIntegrator: '<S24>/Discrete-Time Integrator2' */

  /* UnitDelay: '<S5>/Unit Delay' */
  PUscuff_B->UnitDelay = PUscuff_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->Version = PUscuff_B->UnitDelay;

  /* Update for UnitDelay: '<S24>/Unit Delay3' */
  PUscuff_DWork->UnitDelay3_DSTATE = rtb_rTiPUscf_LearnReactDelay_Li;

  /* Update for UnitDelay: '<S23>/Unit Delay2' */
  PUscuff_DWork->UnitDelay2_DSTATE = rtb_LogicalOperator12;

  /* Update for UnitDelay: '<S2>/Unit Delay1' */
  PUscuff_DWork->UnitDelay1_DSTATE = rtb_rPUscf_LearnScale_Lim;

  /* Update for DiscreteIntegrator: '<S2>/Discrete-Time Integrator' */
  PUscuff_DWork->DiscreteTimeIntegrator_DSTATE += 0.1F;
  PUscuff_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_actLearn;

  /* Update for UnitDelay: '<S35>/Delay Input1' */
  PUscuff_DWork->DelayInput1_DSTATE = rtb_LogicalOperator12_tmp;

  /* Update for DiscreteIntegrator: '<S24>/Discrete-Time Integrator2' incorporates:
   *  Switch: '<S24>/Switch2'
   */
  PUscuff_DWork->DiscreteTimeIntegrator2_IC_LOAD = 0U;
  PUscuff_DWork->DiscreteTimeIntegrator2_DSTATE += 0.1F * (real32_T)
    !rtb_activation;

  /* Update for UnitDelay: '<S5>/Unit Delay' */
  PUscuff_DWork->UnitDelay_DSTATE = 6U;
}

/* Model initialize function */
void PUscuff_initialize(RT_MODEL_PUscuff *const PUscuff_M, struct fPUscuff* inst)
{
  struct D_Work_PUscuff *PUscuff_DWork = ((struct D_Work_PUscuff *) PUscuff_M->dwork);

  /* InitializeConditions for DiscreteIntegrator: '<S24>/Discrete-Time Integrator2' */
  PUscuff_DWork->DiscreteTimeIntegrator2_IC_LOAD = 1U;

  /* SystemInitialize for Atomic SubSystem: '<S2>/Filter4' */
  PUscuff_Filter1_Init(&PUscuff_DWork->Filter4, inst);

  /* End of SystemInitialize for SubSystem: '<S2>/Filter4' */

  /* SystemInitialize for Atomic SubSystem: '<S2>/Filter1' */
  PUscuff_Filter1_Init(&PUscuff_DWork->Filter1, inst);

  /* End of SystemInitialize for SubSystem: '<S2>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S2>/Filter9' */
  PUscuff_Filter1_Init(&PUscuff_DWork->Filter9, inst);

  /* End of SystemInitialize for SubSystem: '<S2>/Filter9' */

  /* SystemInitialize for MATLAB Function: '<S2>/MATLAB Function8' */
  PUscuff_DWork->rLearnTmp = 1.3F;

  /* SystemInitialize for Atomic SubSystem: '<S6>/Filter1' */
  PUscuff_Filter2_Init(&PUscuff_DWork->Filter1_a, inst);

  /* End of SystemInitialize for SubSystem: '<S6>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S6>/Filter3' */
  PUscuff_Filter2_Init(&PUscuff_DWork->Filter3, inst);

  /* End of SystemInitialize for SubSystem: '<S6>/Filter3' */

  /* SystemInitialize for Atomic SubSystem: '<S6>/Filter4' */
  /* InitializeConditions for DiscreteIntegrator: '<S43>/Discrete-Time Integrator' */
  PUscuff_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* End of SystemInitialize for SubSystem: '<S6>/Filter4' */

  /* SystemInitialize for Atomic SubSystem: '<S8>/Filter2' */
  PUscuff_Filter2_Init(&PUscuff_DWork->Filter2, inst);

  /* End of SystemInitialize for SubSystem: '<S8>/Filter2' */

  /* SystemInitialize for Atomic SubSystem: '<S1>/TOF2' */
  /* InitializeConditions for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
  PUscuff_DWork->DiscreteTimeIntegrator_PrevRe_e = 2;
  PUscuff_DWork->DiscreteTimeIntegrator_IC_LOA_b = 1U;

  /* End of SystemInitialize for SubSystem: '<S1>/TOF2' */
}

/* Model terminate function */
void PUscuff_terminate(RT_MODEL_PUscuff *const PUscuff_M, struct fPUscuff* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(PUscuff_M);
}

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
