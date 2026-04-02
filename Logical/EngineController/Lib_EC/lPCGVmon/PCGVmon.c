/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: PCGVmon
 * File: PCGVmon.c
 * Author: 105055527
 * Last modified by: schmisi00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Thu Nov 26 09:45:08 2020
 * Model Version: 0.03
 * Description: Pre-chamber gas valve monitoring (sticking detection).

   Outstandings:
   -------------
   - NA
 * modified Comment: V0.01    22.09.2020    Schmidt,   created initial model
   V0.02    15.10.2020    Schmidt,   modifications after code review / unit testing
   V0.03    26.11.2020    Schmidt,   perm's for class borders (no-hardcoded borders)
 ********************************************************************
 * Implementation of program PCGVmon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.2.0
 * (ERT based)
 ********************************************************************/

#include "PCGVmon.h"
#include "PCGVmon_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/* Forward declaration for local functions */
static int32_T PCGVmon_thirdOfFive(const real32_T v_data[], int32_T ia, int32_T
  ib, struct fPCGVmon* inst);
static void PCGVmon_quickselect(real32_T v_data[], const int32_T *v_size,
  int32_T n, int32_T vlen, real32_T *vn, int32_T *nfirst, int32_T *nlast, struct fPCGVmon* inst);
static void PCGVmon_merge(int32_T idx_data[], real32_T x_data[], int32_T offset,
  int32_T np, int32_T nq, int32_T iwork_data[], real32_T xwork_data[], struct fPCGVmon* inst);
static void PCGVmon_sortIdx(real32_T x_data[], int32_T *x_size, int32_T
  idx_data[], int32_T *idx_size, struct fPCGVmon* inst);
static void PCGVmon_sort(real32_T x_data[], const int32_T *x_size, struct fPCGVmon* inst);
static void PCGVmon_abs(const real32_T x[25], real32_T y[25], struct fPCGVmon* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/*
 * Output and update for atomic system:
 *    '<S4>/setZero'
 *    '<S4>/setZero1'
 *    '<S6>/setZero'
 */
void PCGVmon_setZero(const real32_T rtu_u[25], uint8_T rtu_numCyl,
                     rtB_setZero_PCGVmon *localB, struct fPCGVmon* inst)
{
  int32_T b;
  int32_T i;
  int32_T tmp;
  for (i = 0; i < 25; i++) {
    localB->y[i] = rtu_u[i];
  }

  /* MATLAB Function 'Subsystem/setZero': '<S16>:1' */
  if (rtu_numCyl < 24) {
    /* '<S16>:1:2' */
    b = rtu_numCyl + 1;

    /* '<S16>:1:3' */
    tmp = 25 - b;
    for (i = 0; i < tmp; i++) {
      localB->y[b + i] = 0.0F;
    }
  }

  /* '<S16>:1:5' */
  localB->y[0] = 0.0F;

  /* '<S16>:1:6' */
}

/*
 * Output and update for atomic system:
 *    '<S5>/TON'
 *    '<S5>/TON1'
 *    '<S6>/TON2'
 */
void PCGVmon_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_PCGVmon *localB,
                 rtDW_TON_PCGVmon *localDW, struct fPCGVmon* inst)
{
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_RelationalOperator_a;

  /* Logic: '<S26>/Logical Operator2' */
  rtb_LogicalOperator2 = !rtu_IN;

  /* DiscreteIntegrator: '<S26>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2 || (localDW->DiscreteTimeIntegrator_PrevRese != 0)) {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S26>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S26>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_a = (localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Logic: '<S26>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_a && rtu_IN);

  /* Update for DiscreteIntegrator: '<S26>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S29>/Conversion'
   *  Logic: '<S26>/Logical Operator'
   *  Logic: '<S26>/Logical Operator1'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (real32_T)
    ((!rtb_RelationalOperator_a) && rtu_IN);
  localDW->DiscreteTimeIntegrator_PrevRese = (int8_T)rtb_LogicalOperator2;
}

/*
 * Output and update for atomic system:
 *    '<S7>/MATLAB Function'
 *    '<S7>/MATLAB Function1'
 *    '<S7>/MATLAB Function10'
 *    '<S7>/MATLAB Function2'
 *    '<S7>/MATLAB Function3'
 *    '<S7>/MATLAB Function4'
 *    '<S7>/MATLAB Function5'
 *    '<S7>/MATLAB Function6'
 *    '<S7>/MATLAB Function7'
 *    '<S7>/MATLAB Function8'
 *    '<S7>/MATLAB Function9'
 */
void PCGVmon_MATLABFunction(real32_T rtu_u, boolean_T rtu_acive,
  rtB_MATLABFunction_PCGVmon *localB, struct fPCGVmon* inst)
{
  /* MATLAB Function 'Subsystem3/MATLAB Function': '<S39>:1' */
  if (!rtu_acive) {
    /* '<S39>:1:3' */
    /* '<S39>:1:4' */
    localB->y = 0.0F;
  } else {
    /* '<S39>:1:6' */
    localB->y = rtu_u;
  }
}

/* Function for MATLAB Function: '<S4>/median' */
static int32_T PCGVmon_thirdOfFive(const real32_T v_data[], int32_T ia, int32_T
  ib, struct fPCGVmon* inst)
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

/* Function for MATLAB Function: '<S4>/median' */
static void PCGVmon_quickselect(real32_T v_data[], const int32_T *v_size,
  int32_T n, int32_T vlen, real32_T *vn, int32_T *nfirst, int32_T *nlast, struct fPCGVmon* inst)
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
              i1 = PCGVmon_thirdOfFive(v_data, i1, i1 + 4, inst) - 1;
              destidx = ia + k;
              vref = v_data[destidx];
              v_data[destidx] = v_data[i1];
              v_data[i1] = vref;
            }

            if (b_nlast > 0) {
              i1 = (ngroupsof5 * 5 + ia) + 1;
              i1 = PCGVmon_thirdOfFive(v_data, i1, (i1 + b_nlast) - 1, inst) - 1;
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

/* Function for MATLAB Function: '<S5>/stdDev1' */
static void PCGVmon_merge(int32_T idx_data[], real32_T x_data[], int32_T offset,
  int32_T np, int32_T nq, int32_T iwork_data[], real32_T xwork_data[], struct fPCGVmon* inst)
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
      iwork_data[q] = idx_data[iout];
      xwork_data[q] = x_data[iout];
    }

    n = 0;
    q = np;
    iout = offset - 1;
    do {
      exitg1 = 0;
      iout++;
      if (xwork_data[n] <= xwork_data[q]) {
        idx_data[iout] = iwork_data[n];
        x_data[iout] = xwork_data[n];
        if (n + 1 < np) {
          n++;
        } else {
          exitg1 = 1;
        }
      } else {
        idx_data[iout] = iwork_data[q];
        x_data[iout] = xwork_data[q];
        if (q + 1 < n_tmp) {
          q++;
        } else {
          q = iout - n;
          while (n + 1 <= np) {
            iout = (q + n) + 1;
            idx_data[iout] = iwork_data[n];
            x_data[iout] = xwork_data[n];
            n++;
          }

          exitg1 = 1;
        }
      }
    } while (exitg1 == 0);
  }
}

/* Function for MATLAB Function: '<S5>/stdDev1' */
static void PCGVmon_sortIdx(real32_T x_data[], int32_T *x_size, int32_T
  idx_data[], int32_T *idx_size, struct fPCGVmon* inst)
{
  real32_T b_x_data[25];
  int32_T iwork_data[25];
  real32_T xwork_data[25];
  int32_T n;
  real32_T x4[4];
  int8_T idx4[4];
  int32_T ib;
  int8_T perm[4];
  int32_T nTail;
  int32_T nPairs;
  int32_T i3;
  int32_T i4;
  int32_T b_x_size;
  int8_T b_idx_0;
  real32_T tmp;
  real32_T tmp_0;
  b_idx_0 = (int8_T)*x_size;
  *idx_size = b_idx_0;
  if (0 <= b_idx_0 - 1) {
    memset(&idx_data[0], 0, b_idx_0 * sizeof(int32_T));
  }

  if (*x_size != 0) {
    b_x_size = *x_size;
    nPairs = *x_size;
    for (n = 0; n < nPairs; n++) {
      b_x_data[n] = x_data[n];
    }

    *idx_size = b_idx_0;
    if (0 <= b_idx_0 - 1) {
      memset(&idx_data[0], 0, b_idx_0 * sizeof(int32_T));
    }

    n = *x_size - 1;
    x4[0] = 0.0F;
    idx4[0] = 0;
    x4[1] = 0.0F;
    idx4[1] = 0;
    x4[2] = 0.0F;
    idx4[2] = 0;
    x4[3] = 0.0F;
    idx4[3] = 0;
    ib = 0;
    for (nPairs = 0; nPairs <= n; nPairs++) {
      ib++;
      idx4[ib - 1] = (int8_T)(nPairs + 1);
      x4[ib - 1] = b_x_data[nPairs];
      if (ib == 4) {
        if (x4[0] <= x4[1]) {
          ib = 1;
          nTail = 2;
        } else {
          ib = 2;
          nTail = 1;
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
          tmp = x4[nTail - 1];
          if (tmp <= tmp_0) {
            perm[0] = (int8_T)ib;
            perm[1] = (int8_T)nTail;
            perm[2] = (int8_T)i3;
            perm[3] = (int8_T)i4;
          } else if (tmp <= x4[i4 - 1]) {
            perm[0] = (int8_T)ib;
            perm[1] = (int8_T)i3;
            perm[2] = (int8_T)nTail;
            perm[3] = (int8_T)i4;
          } else {
            perm[0] = (int8_T)ib;
            perm[1] = (int8_T)i3;
            perm[2] = (int8_T)i4;
            perm[3] = (int8_T)nTail;
          }
        } else {
          tmp_0 = x4[i4 - 1];
          if (tmp <= tmp_0) {
            if (x4[nTail - 1] <= tmp_0) {
              perm[0] = (int8_T)i3;
              perm[1] = (int8_T)ib;
              perm[2] = (int8_T)nTail;
              perm[3] = (int8_T)i4;
            } else {
              perm[0] = (int8_T)i3;
              perm[1] = (int8_T)ib;
              perm[2] = (int8_T)i4;
              perm[3] = (int8_T)nTail;
            }
          } else {
            perm[0] = (int8_T)i3;
            perm[1] = (int8_T)i4;
            perm[2] = (int8_T)ib;
            perm[3] = (int8_T)nTail;
          }
        }

        nTail = perm[0] - 1;
        idx_data[nPairs - 3] = idx4[nTail];
        i3 = perm[1] - 1;
        idx_data[nPairs - 2] = idx4[i3];
        ib = perm[2] - 1;
        idx_data[nPairs - 1] = idx4[ib];
        i4 = perm[3] - 1;
        idx_data[nPairs] = idx4[i4];
        b_x_data[nPairs - 3] = x4[nTail];
        b_x_data[nPairs - 2] = x4[i3];
        b_x_data[nPairs - 1] = x4[ib];
        b_x_data[nPairs] = x4[i4];
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

      for (nPairs = 0; nPairs < ib; nPairs++) {
        nTail = perm[nPairs] - 1;
        i3 = ((n - ib) + nPairs) + 1;
        idx_data[i3] = idx4[nTail];
        b_x_data[i3] = x4[nTail];
      }
    }

    if (*x_size > 1) {
      nPairs = (int8_T)*x_size;
      for (n = 0; n < nPairs; n++) {
        xwork_data[n] = 0.0F;
      }

      if (0 <= b_idx_0 - 1) {
        memset(&iwork_data[0], 0, b_idx_0 * sizeof(int32_T));
      }

      nPairs = *x_size >> 2;
      n = 4;
      while (nPairs > 1) {
        if ((nPairs & 1U) != 0U) {
          nPairs--;
          ib = n * nPairs;
          nTail = *x_size - ib;
          if (nTail > n) {
            PCGVmon_merge(idx_data, b_x_data, ib, n, nTail - n, iwork_data,
                          xwork_data, inst);
          }
        }

        ib = n << 1;
        nPairs >>= 1;
        for (nTail = 0; nTail < nPairs; nTail++) {
          PCGVmon_merge(idx_data, b_x_data, nTail * ib, n, n, iwork_data,
                        xwork_data, inst);
        }

        n = ib;
      }

      if (*x_size > n) {
        PCGVmon_merge(idx_data, b_x_data, 0, n, *x_size - n, iwork_data,
                      xwork_data, inst);
      }
    }

    for (n = 0; n < b_x_size; n++) {
      x_data[n] = b_x_data[n];
    }
  }
}

/* Function for MATLAB Function: '<S5>/stdDev1' */
static void PCGVmon_sort(real32_T x_data[], const int32_T *x_size, struct fPCGVmon* inst)
{
  int32_T dim;
  real32_T vwork_data[25];
  int32_T vstride;
  int32_T b;
  int32_T c_k;
  int32_T vwork_size;
  emxArray_int32_T_25_PCGVmon vwork_data_0;
  dim = 2;
  if (*x_size != 1) {
    dim = 1;
    b = *x_size - 1;
  } else {
    b = 0;
  }

  vwork_size = b + 1;
  vstride = 1;
  c_k = 0;
  while (c_k <= dim - 2) {
    vstride *= *x_size;
    c_k = 1;
  }

  for (dim = 0; dim < vstride; dim++) {
    for (c_k = 0; c_k <= b; c_k++) {
      vwork_data[c_k] = x_data[c_k * vstride + dim];
    }

    PCGVmon_sortIdx(vwork_data, &vwork_size, vwork_data_0.data,
                    &vwork_data_0.size, inst);
    for (c_k = 0; c_k <= b; c_k++) {
      x_data[dim + c_k * vstride] = vwork_data[c_k];
    }
  }
}

/* Function for MATLAB Function: '<S6>/MATLAB Function1' */
static void PCGVmon_abs(const real32_T x[25], real32_T y[25], struct fPCGVmon* inst)
{
  int32_T k;
  for (k = 0; k < 25; k++) {
    y[k] = (real32_T)fabs(x[k]);
  }
}

/* Model step function */
void PCGVmon_step(RT_MODEL_PCGVmon *const PCGVmon_M, struct fPCGVmon* inst)
{
  struct BlockIO_PCGVmon *PCGVmon_B = ((struct BlockIO_PCGVmon *) PCGVmon_M->blockIO);
  struct D_Work_PCGVmon *PCGVmon_DWork = ((struct D_Work_PCGVmon *) PCGVmon_M->dwork);
  ExternalOutputs_PCGVmon *PCGVmon_Y = (ExternalOutputs_PCGVmon *)
    PCGVmon_M->outputs;
  boolean_T reset;
  int32_T midm1;
  int32_T unusedU5;
  real32_T medi;
  real32_T Tsort_data[25];
  int32_T n;
  real32_T absdiff_data[23];
  boolean_T d[25];
  boolean_T i[25];
  real32_T b_data[25];
  int8_T c_data[25];
  real32_T d_data[25];
  real32_T e_data[25];
  real32_T f_data[25];
  int8_T g_data[25];
  real32_T h_data[25];
  real32_T j_data[25];
  real32_T k_data[25];
  real32_T l_data[25];
  real32_T m_data[25];
  int8_T s_data[25];
  uint16_T b_data_0[25];
  uint16_T c_data_0[25];
  uint16_T d_data_0[25];
  uint16_T e_data_0[25];
  real32_T rtb_Divide;
  real32_T rtb_Switch;
  real32_T rtb_Switch_b[25];
  real32_T rtb_Switch1;
  boolean_T rtb_BPCGVstickin[25];
  real32_T rtb_DotProduct;
  real32_T rtb_Switch10;
  real32_T rtb_Switch12;
  real32_T rtb_Divide4_k[25];
  real32_T rtb_Divide4_f;
  real32_T rtb_y_e;
  real32_T rtb_UnitDelay3;
  real32_T rtb_UnitDelay4;
  real32_T rtb_UnitDelay5;
  real32_T rtb_UnitDelay6;
  real32_T rtb_UnitDelay7;
  real32_T rtb_UnitDelay9;
  real32_T rtb_UnitDelay11;
  real32_T rtb_Switch_hx[25];
  boolean_T r_tmp[25];
  int32_T i_0;
  int32_T Tsort_size;
  boolean_T r_tmp_0;
  uint32_T tmp;
  int32_T loop_ub;
  int32_T rtb_Switch1_tmp;
  boolean_T rtb_LogicalOperator1_tmp;
  boolean_T rtb_LogicalOperator1_tmp_0;
  boolean_T exitg1;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  PCGVmon_B->BusInput = inst->Input;

  /* MATLAB Function: '<S4>/reset' incorporates:
   *  MATLAB Function: '<S4>/median'
   *  MATLAB Function: '<S4>/median3'
   *  MATLAB Function: '<S5>/stdDev1'
   *  Switch: '<S1>/Environment Switch'
   */
  /* MATLAB Function 'Subsystem/reset': '<S15>:1' */
  rtb_Switch1_tmp = (int32_T)(PCGVmon_B->BusInput.ucNumCyl + 1U);
  unusedU5 = rtb_Switch1_tmp;
  if ((uint32_T)rtb_Switch1_tmp > 255U) {
    unusedU5 = 255;
  }

  if (2 > (uint8_T)unusedU5) {
    i_0 = 0;
    n = 0;
  } else {
    i_0 = 1;
    n = (uint8_T)unusedU5;
  }

  midm1 = n - i_0;
  for (unusedU5 = 0; unusedU5 < midm1; unusedU5++) {
    rtb_BPCGVstickin[unusedU5] = (PCGVmon_B->BusInput.rT_EPU_EG[i_0 + unusedU5] <=
      0.0F);
  }

  reset = false;
  i_0 = 1;
  exitg1 = false;
  while ((!exitg1) && (i_0 <= midm1)) {
    if (!rtb_BPCGVstickin[i_0 - 1]) {
      i_0++;
    } else {
      reset = true;
      exitg1 = true;
    }
  }

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  /* '<S15>:1:9' */
  PCGVmon_B->BusInput1 = inst->Perm;

  /* Switch: '<S2>/Environment Switch' */
  rtb_DotProduct = PCGVmon_B->BusInput1.rT_recoverLim;

  /* Logic: '<S4>/Logical Operator' incorporates:
   *  MATLAB Function: '<S6>/MATLAB Function1'
   *  Switch: '<S1>/Environment Switch'
   */
  rtb_LogicalOperator1_tmp = !PCGVmon_B->BusInput.tGCB_On_Di;

  /* Logic: '<S4>/Logical Operator2' incorporates:
   *  MATLAB Function: '<S6>/MATLAB Function1'
   *  MATLAB Function: '<S6>/MATLAB Function3'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_LogicalOperator1_tmp_0 = !PCGVmon_B->BusInput1.bPCGVmon_Act;

  /* Logic: '<S4>/Logical Operator1' incorporates:
   *  Logic: '<S4>/Logical Operator'
   *  Logic: '<S4>/Logical Operator2'
   *  MATLAB Function: '<S4>/reset'
   */
  reset = (rtb_LogicalOperator1_tmp || reset || rtb_LogicalOperator1_tmp_0);

  /* Outputs for Atomic SubSystem: '<S4>/Filter' */
  /* DiscreteIntegrator: '<S9>/Discrete-Time Integrator' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  if (PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_o != 0) {
    for (i_0 = 0; i_0 < 25; i_0++) {
      PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_m[i_0] =
        PCGVmon_B->BusInput.rT_EPU_EG[i_0];
    }
  }

  /* Update for DiscreteIntegrator: '<S9>/Discrete-Time Integrator' */
  PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_o = 0U;
  for (i_0 = 0; i_0 < 25; i_0++) {
    /* DiscreteIntegrator: '<S9>/Discrete-Time Integrator' incorporates:
     *  Logic: '<S9>/Logical Operator'
     *  Switch: '<S1>/Environment Switch'
     */
    if (reset || (PCGVmon_DWork->DiscreteTimeIntegrator_PrevRe_l != 0)) {
      PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_m[i_0] =
        PCGVmon_B->BusInput.rT_EPU_EG[i_0];
    }

    /* Product: '<S9>/Divide4' incorporates:
     *  DiscreteIntegrator: '<S9>/Discrete-Time Integrator'
     *  Sum: '<S9>/Sum4'
     *  Switch: '<S1>/Environment Switch'
     */
    rtb_y_e = (PCGVmon_B->BusInput.rT_EPU_EG[i_0] -
               PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_m[i_0]) / 8.0F;

    /* Switch: '<S9>/Switch' incorporates:
     *  DiscreteIntegrator: '<S9>/Discrete-Time Integrator'
     */
    rtb_Switch_hx[i_0] = PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_m[i_0];

    /* Update for DiscreteIntegrator: '<S9>/Discrete-Time Integrator' */
    PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_m[i_0] += rtb_y_e;

    /* Product: '<S9>/Divide4' */
    rtb_Divide4_k[i_0] = rtb_y_e;
  }

  /* Update for DiscreteIntegrator: '<S9>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S9>/Logical Operator'
   */
  PCGVmon_DWork->DiscreteTimeIntegrator_PrevRe_l = (int8_T)reset;

  /* End of Outputs for SubSystem: '<S4>/Filter' */

  /* MATLAB Function: '<S4>/median' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  /* MATLAB Function 'Subsystem/median': '<S13>:1' */
  unusedU5 = rtb_Switch1_tmp;
  if ((uint32_T)rtb_Switch1_tmp > 255U) {
    unusedU5 = 255;
  }

  if (2 > (uint8_T)unusedU5) {
    i_0 = 0;
    n = 0;
  } else {
    i_0 = 1;
    n = (uint8_T)unusedU5;
  }

  /* '<S13>:1:3' */
  loop_ub = n - i_0;
  if (loop_ub == 0) {
    rtb_y_e = 0.0F;
  } else if (loop_ub <= 4) {
    if (loop_ub == 0) {
      rtb_y_e = 0.0F;
    } else if (loop_ub == 1) {
      rtb_y_e = PCGVmon_B->BusInput.rT_EPU_EG[i_0];
    } else if (loop_ub == 2) {
      /* Switch: '<S1>/Environment Switch' */
      rtb_Switch = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + 1];
      if ((rtb_Switch < 0.0F) != (PCGVmon_B->BusInput.rT_EPU_EG[i_0] < 0.0F)) {
        rtb_y_e = (rtb_Switch + PCGVmon_B->BusInput.rT_EPU_EG[i_0]) / 2.0F;
      } else {
        rtb_y_e = (rtb_Switch - PCGVmon_B->BusInput.rT_EPU_EG[i_0]) / 2.0F +
          PCGVmon_B->BusInput.rT_EPU_EG[i_0];
      }
    } else if (loop_ub == 3) {
      /* Switch: '<S1>/Environment Switch' */
      rtb_Switch = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + 1];
      if (PCGVmon_B->BusInput.rT_EPU_EG[i_0] < rtb_Switch) {
        rtb_Divide4_f = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + 2];
        if (rtb_Switch < rtb_Divide4_f) {
          unusedU5 = 1;
        } else if (PCGVmon_B->BusInput.rT_EPU_EG[i_0] < rtb_Divide4_f) {
          unusedU5 = 2;
        } else {
          unusedU5 = 0;
        }
      } else {
        rtb_Divide4_f = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + 2];
        if (PCGVmon_B->BusInput.rT_EPU_EG[i_0] < rtb_Divide4_f) {
          unusedU5 = 0;
        } else if (rtb_Switch < rtb_Divide4_f) {
          unusedU5 = 2;
        } else {
          unusedU5 = 1;
        }
      }

      rtb_y_e = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + unusedU5];
    } else {
      /* Switch: '<S1>/Environment Switch' */
      rtb_Switch = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + 1];
      if (PCGVmon_B->BusInput.rT_EPU_EG[i_0] < rtb_Switch) {
        rtb_Divide4_f = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + 2];
        if (rtb_Switch < rtb_Divide4_f) {
          midm1 = 0;
          n = 1;
          loop_ub = 2;
        } else if (PCGVmon_B->BusInput.rT_EPU_EG[i_0] < rtb_Divide4_f) {
          midm1 = 0;
          n = 2;
          loop_ub = 1;
        } else {
          midm1 = 2;
          n = 0;
          loop_ub = 1;
        }
      } else {
        rtb_Divide4_f = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + 2];
        if (PCGVmon_B->BusInput.rT_EPU_EG[i_0] < rtb_Divide4_f) {
          midm1 = 1;
          n = 0;
          loop_ub = 2;
        } else if (rtb_Switch < rtb_Divide4_f) {
          midm1 = 1;
          n = 2;
          loop_ub = 0;
        } else {
          midm1 = 2;
          n = 1;
          loop_ub = 0;
        }
      }

      unusedU5 = i_0 + midm1;

      /* Switch: '<S1>/Environment Switch' */
      rtb_Switch = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + 3];
      if (PCGVmon_B->BusInput.rT_EPU_EG[unusedU5] < rtb_Switch) {
        unusedU5 = i_0 + loop_ub;
        if (rtb_Switch < PCGVmon_B->BusInput.rT_EPU_EG[unusedU5]) {
          unusedU5 = i_0 + n;
          if ((PCGVmon_B->BusInput.rT_EPU_EG[unusedU5] < 0.0F) != (rtb_Switch <
               0.0F)) {
            rtb_y_e = (PCGVmon_B->BusInput.rT_EPU_EG[unusedU5] + rtb_Switch) /
              2.0F;
          } else {
            rtb_y_e = (rtb_Switch - PCGVmon_B->BusInput.rT_EPU_EG[unusedU5]) /
              2.0F + PCGVmon_B->BusInput.rT_EPU_EG[unusedU5];
          }
        } else {
          i_0 += n;
          if ((PCGVmon_B->BusInput.rT_EPU_EG[i_0] < 0.0F) !=
              (PCGVmon_B->BusInput.rT_EPU_EG[unusedU5] < 0.0F)) {
            rtb_y_e = (PCGVmon_B->BusInput.rT_EPU_EG[i_0] +
                       PCGVmon_B->BusInput.rT_EPU_EG[unusedU5]) / 2.0F;
          } else {
            rtb_y_e = (PCGVmon_B->BusInput.rT_EPU_EG[unusedU5] -
                       PCGVmon_B->BusInput.rT_EPU_EG[i_0]) / 2.0F +
              PCGVmon_B->BusInput.rT_EPU_EG[i_0];
          }
        }
      } else {
        i_0 += n;
        if ((PCGVmon_B->BusInput.rT_EPU_EG[unusedU5] < 0.0F) !=
            (PCGVmon_B->BusInput.rT_EPU_EG[i_0] < 0.0F)) {
          rtb_y_e = (PCGVmon_B->BusInput.rT_EPU_EG[unusedU5] +
                     PCGVmon_B->BusInput.rT_EPU_EG[i_0]) / 2.0F;
        } else {
          rtb_y_e = (PCGVmon_B->BusInput.rT_EPU_EG[i_0] -
                     PCGVmon_B->BusInput.rT_EPU_EG[unusedU5]) / 2.0F +
            PCGVmon_B->BusInput.rT_EPU_EG[unusedU5];
        }
      }
    }
  } else {
    midm1 = loop_ub >> 1;
    if ((loop_ub & 1U) == 0U) {
      Tsort_size = loop_ub;
      for (unusedU5 = 0; unusedU5 < loop_ub; unusedU5++) {
        Tsort_data[unusedU5] = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + unusedU5];
      }

      PCGVmon_quickselect(Tsort_data, &Tsort_size, midm1 + 1, n - i_0, &rtb_y_e,
                          &unusedU5, &loop_ub, inst);
      if (midm1 < unusedU5) {
        PCGVmon_quickselect(Tsort_data, &Tsort_size, midm1, loop_ub - 1,
                            &rtb_Divide4_f, &i_0, &n, inst);
        if ((rtb_y_e < 0.0F) != (rtb_Divide4_f < 0.0F)) {
          rtb_y_e = (rtb_y_e + rtb_Divide4_f) / 2.0F;
        } else {
          rtb_y_e += (rtb_Divide4_f - rtb_y_e) / 2.0F;
        }
      }
    } else {
      Tsort_size = loop_ub;
      for (unusedU5 = 0; unusedU5 < loop_ub; unusedU5++) {
        Tsort_data[unusedU5] = PCGVmon_B->BusInput.rT_EPU_EG[i_0 + unusedU5];
      }

      PCGVmon_quickselect(Tsort_data, &Tsort_size, midm1 + 1, n - i_0, &rtb_y_e,
                          &loop_ub, &unusedU5, inst);
    }
  }

  /* Outputs for Atomic SubSystem: '<S4>/Filter1' */
  /* DiscreteIntegrator: '<S10>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S10>/Logical Operator'
   */
  if (PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_l != 0) {
    PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_b = rtb_y_e;
  }

  if (reset || (PCGVmon_DWork->DiscreteTimeIntegrator_PrevRe_p != 0)) {
    PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_b = rtb_y_e;
  }

  /* Product: '<S10>/Divide4' incorporates:
   *  DiscreteIntegrator: '<S10>/Discrete-Time Integrator'
   *  Sum: '<S10>/Sum4'
   */
  rtb_Divide4_f = (rtb_y_e - PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_b) /
    12.0F;

  /* Switch: '<S10>/Switch' incorporates:
   *  DiscreteIntegrator: '<S10>/Discrete-Time Integrator'
   */
  rtb_y_e = PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_b;

  /* Switch: '<S10>/Switch1' incorporates:
   *  Constant: '<S10>/Constant'
   *  Logic: '<S10>/Logical Operator'
   */
  if (reset) {
    rtb_Switch1 = 0.0F;
  } else {
    rtb_Switch1 = rtb_Divide4_f;
  }

  /* End of Switch: '<S10>/Switch1' */

  /* Update for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S10>/Logical Operator'
   */
  PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_l = 0U;
  PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_b += rtb_Divide4_f;
  PCGVmon_DWork->DiscreteTimeIntegrator_PrevRe_p = (int8_T)reset;

  /* End of Outputs for SubSystem: '<S4>/Filter1' */

  /* MATLAB Function: '<S4>/median3' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  /* MATLAB Function 'Subsystem/median3': '<S14>:1' */
  unusedU5 = rtb_Switch1_tmp;
  if ((uint32_T)rtb_Switch1_tmp > 255U) {
    unusedU5 = 255;
  }

  if (2 > (uint8_T)unusedU5) {
    i_0 = 0;
    n = 0;
  } else {
    i_0 = 1;
    n = (uint8_T)unusedU5;
  }

  /* '<S14>:1:3' */
  loop_ub = n - i_0;
  if (loop_ub == 0) {
    medi = 0.0F;
  } else if (loop_ub <= 4) {
    if (loop_ub == 0) {
      medi = 0.0F;
    } else if (loop_ub == 1) {
      medi = PCGVmon_B->BusInput.rU_Ign_Act[i_0];
    } else if (loop_ub == 2) {
      /* Switch: '<S1>/Environment Switch' */
      rtb_Switch = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + 1];
      if ((rtb_Switch < 0.0F) != (PCGVmon_B->BusInput.rU_Ign_Act[i_0] < 0.0F)) {
        medi = (rtb_Switch + PCGVmon_B->BusInput.rU_Ign_Act[i_0]) / 2.0F;
      } else {
        medi = (rtb_Switch - PCGVmon_B->BusInput.rU_Ign_Act[i_0]) / 2.0F +
          PCGVmon_B->BusInput.rU_Ign_Act[i_0];
      }
    } else if (loop_ub == 3) {
      /* Switch: '<S1>/Environment Switch' */
      rtb_Switch = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + 1];
      if (PCGVmon_B->BusInput.rU_Ign_Act[i_0] < rtb_Switch) {
        rtb_Divide4_f = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + 2];
        if (rtb_Switch < rtb_Divide4_f) {
          unusedU5 = 1;
        } else if (PCGVmon_B->BusInput.rU_Ign_Act[i_0] < rtb_Divide4_f) {
          unusedU5 = 2;
        } else {
          unusedU5 = 0;
        }
      } else {
        rtb_Divide4_f = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + 2];
        if (PCGVmon_B->BusInput.rU_Ign_Act[i_0] < rtb_Divide4_f) {
          unusedU5 = 0;
        } else if (rtb_Switch < rtb_Divide4_f) {
          unusedU5 = 2;
        } else {
          unusedU5 = 1;
        }
      }

      medi = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + unusedU5];
    } else {
      /* Switch: '<S1>/Environment Switch' */
      rtb_Switch = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + 1];
      if (PCGVmon_B->BusInput.rU_Ign_Act[i_0] < rtb_Switch) {
        rtb_Divide4_f = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + 2];
        if (rtb_Switch < rtb_Divide4_f) {
          midm1 = 0;
          n = 1;
          loop_ub = 2;
        } else if (PCGVmon_B->BusInput.rU_Ign_Act[i_0] < rtb_Divide4_f) {
          midm1 = 0;
          n = 2;
          loop_ub = 1;
        } else {
          midm1 = 2;
          n = 0;
          loop_ub = 1;
        }
      } else {
        rtb_Divide4_f = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + 2];
        if (PCGVmon_B->BusInput.rU_Ign_Act[i_0] < rtb_Divide4_f) {
          midm1 = 1;
          n = 0;
          loop_ub = 2;
        } else if (rtb_Switch < rtb_Divide4_f) {
          midm1 = 1;
          n = 2;
          loop_ub = 0;
        } else {
          midm1 = 2;
          n = 1;
          loop_ub = 0;
        }
      }

      unusedU5 = i_0 + midm1;

      /* Switch: '<S1>/Environment Switch' */
      rtb_Switch = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + 3];
      if (PCGVmon_B->BusInput.rU_Ign_Act[unusedU5] < rtb_Switch) {
        unusedU5 = i_0 + loop_ub;
        if (rtb_Switch < PCGVmon_B->BusInput.rU_Ign_Act[unusedU5]) {
          unusedU5 = i_0 + n;
          if ((PCGVmon_B->BusInput.rU_Ign_Act[unusedU5] < 0.0F) != (rtb_Switch <
               0.0F)) {
            medi = (PCGVmon_B->BusInput.rU_Ign_Act[unusedU5] + rtb_Switch) /
              2.0F;
          } else {
            medi = (rtb_Switch - PCGVmon_B->BusInput.rU_Ign_Act[unusedU5]) /
              2.0F + PCGVmon_B->BusInput.rU_Ign_Act[unusedU5];
          }
        } else {
          i_0 += n;
          if ((PCGVmon_B->BusInput.rU_Ign_Act[i_0] < 0.0F) !=
              (PCGVmon_B->BusInput.rU_Ign_Act[unusedU5] < 0.0F)) {
            medi = (PCGVmon_B->BusInput.rU_Ign_Act[i_0] +
                    PCGVmon_B->BusInput.rU_Ign_Act[unusedU5]) / 2.0F;
          } else {
            medi = (PCGVmon_B->BusInput.rU_Ign_Act[unusedU5] -
                    PCGVmon_B->BusInput.rU_Ign_Act[i_0]) / 2.0F +
              PCGVmon_B->BusInput.rU_Ign_Act[i_0];
          }
        }
      } else {
        i_0 += n;
        if ((PCGVmon_B->BusInput.rU_Ign_Act[unusedU5] < 0.0F) !=
            (PCGVmon_B->BusInput.rU_Ign_Act[i_0] < 0.0F)) {
          medi = (PCGVmon_B->BusInput.rU_Ign_Act[unusedU5] +
                  PCGVmon_B->BusInput.rU_Ign_Act[i_0]) / 2.0F;
        } else {
          medi = (PCGVmon_B->BusInput.rU_Ign_Act[i_0] -
                  PCGVmon_B->BusInput.rU_Ign_Act[unusedU5]) / 2.0F +
            PCGVmon_B->BusInput.rU_Ign_Act[unusedU5];
        }
      }
    }
  } else {
    midm1 = loop_ub >> 1;
    if ((loop_ub & 1U) == 0U) {
      Tsort_size = loop_ub;
      for (unusedU5 = 0; unusedU5 < loop_ub; unusedU5++) {
        Tsort_data[unusedU5] = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + unusedU5];
      }

      PCGVmon_quickselect(Tsort_data, &Tsort_size, midm1 + 1, n - i_0, &medi,
                          &unusedU5, &loop_ub, inst);
      if (midm1 < unusedU5) {
        PCGVmon_quickselect(Tsort_data, &Tsort_size, midm1, loop_ub - 1,
                            &rtb_Divide4_f, &i_0, &n, inst);
        if ((medi < 0.0F) != (rtb_Divide4_f < 0.0F)) {
          medi = (medi + rtb_Divide4_f) / 2.0F;
        } else {
          medi += (rtb_Divide4_f - medi) / 2.0F;
        }
      }
    } else {
      Tsort_size = loop_ub;
      for (unusedU5 = 0; unusedU5 < loop_ub; unusedU5++) {
        Tsort_data[unusedU5] = PCGVmon_B->BusInput.rU_Ign_Act[i_0 + unusedU5];
      }

      PCGVmon_quickselect(Tsort_data, &Tsort_size, midm1 + 1, n - i_0, &medi,
                          &loop_ub, &unusedU5, inst);
    }
  }

  /* Outputs for Atomic SubSystem: '<S4>/Filter5' */
  /* DiscreteIntegrator: '<S12>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S12>/Logical Operator'
   *  MATLAB Function: '<S4>/median3'
   */
  /* '<S14>:1:5' */
  if (PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE = medi;
  }

  if (reset || (PCGVmon_DWork->DiscreteTimeIntegrator_PrevRese != 0)) {
    PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE = medi;
  }

  /* Switch: '<S12>/Switch' incorporates:
   *  DiscreteIntegrator: '<S12>/Discrete-Time Integrator'
   */
  rtb_Switch = PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE;

  /* Update for DiscreteIntegrator: '<S12>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S12>/Logical Operator'
   *  MATLAB Function: '<S4>/median3'
   *  Product: '<S12>/Divide4'
   *  Sum: '<S12>/Sum4'
   */
  PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;
  PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE += (medi -
    PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE) / 6.0F;
  PCGVmon_DWork->DiscreteTimeIntegrator_PrevRese = (int8_T)reset;

  /* End of Outputs for SubSystem: '<S4>/Filter5' */

  /* Outputs for Atomic SubSystem: '<S4>/Filter4' */
  /* DiscreteIntegrator: '<S11>/Discrete-Time Integrator' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  if (PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_b != 0) {
    for (i_0 = 0; i_0 < 25; i_0++) {
      PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_d[i_0] =
        PCGVmon_B->BusInput.rU_Ign_Act[i_0];
    }
  }

  /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_b = 0U;
  for (i_0 = 0; i_0 < 25; i_0++) {
    /* DiscreteIntegrator: '<S11>/Discrete-Time Integrator' incorporates:
     *  Switch: '<S1>/Environment Switch'
     */
    if (reset || (PCGVmon_DWork->DiscreteTimeIntegrator_PrevRe_a != 0)) {
      PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_d[i_0] =
        PCGVmon_B->BusInput.rU_Ign_Act[i_0];
    }

    /* Switch: '<S11>/Switch' incorporates:
     *  DiscreteIntegrator: '<S11>/Discrete-Time Integrator'
     */
    rtb_Divide4_f = PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_d[i_0];

    /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' incorporates:
     *  Product: '<S11>/Divide4'
     *  Sum: '<S11>/Sum4'
     *  Switch: '<S1>/Environment Switch'
     */
    PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_d[i_0] +=
      (PCGVmon_B->BusInput.rU_Ign_Act[i_0] -
       PCGVmon_DWork->DiscreteTimeIntegrator_DSTATE_d[i_0]) / 6.0F;

    /* Sum: '<S4>/Subtract1' */
    Tsort_data[i_0] = rtb_Divide4_f - rtb_Switch;

    /* Switch: '<S11>/Switch' */
    rtb_Switch_b[i_0] = rtb_Divide4_f;
  }

  /* Update for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  PCGVmon_DWork->DiscreteTimeIntegrator_PrevRe_a = (int8_T)reset;

  /* End of Outputs for SubSystem: '<S4>/Filter4' */

  /* MATLAB Function: '<S4>/setZero1' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  PCGVmon_setZero(Tsort_data, PCGVmon_B->BusInput.ucNumCyl,
                  &PCGVmon_B->sf_setZero1, inst);

  /* Sum: '<S4>/Subtract' incorporates:
   *  Switch: '<S9>/Switch1'
   */
  for (unusedU5 = 0; unusedU5 < 25; unusedU5++) {
    /* Outputs for Atomic SubSystem: '<S4>/Filter' */
    /* Switch: '<S9>/Switch1' incorporates:
     *  Constant: '<S9>/Constant'
     *  Logic: '<S9>/Logical Operator'
     */
    if (reset) {
      rtb_Divide4_f = 0.0F;
    } else {
      rtb_Divide4_f = rtb_Divide4_k[unusedU5];
    }

    rtb_Divide4_k[unusedU5] = rtb_Switch1 - rtb_Divide4_f;

    /* End of Outputs for SubSystem: '<S4>/Filter' */
  }

  /* End of Sum: '<S4>/Subtract' */

  /* MATLAB Function: '<S4>/setZero' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  PCGVmon_setZero(rtb_Divide4_k, PCGVmon_B->BusInput.ucNumCyl,
                  &PCGVmon_B->sf_setZero, inst);

  /* MinMax: '<S5>/Max1' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    if (PCGVmon_B->sf_setZero.y[i_0] > 0.0F) {
      rtb_Divide4_k[i_0] = PCGVmon_B->sf_setZero.y[i_0];
    } else {
      rtb_Divide4_k[i_0] = 0.0F;
    }
  }

  /* End of MinMax: '<S5>/Max1' */

  /* MATLAB Function: '<S5>/stdDev1' */
  /* MATLAB Function 'Subsystem1/stdDev1': '<S28>:1' */
  if ((uint32_T)rtb_Switch1_tmp > 255U) {
    rtb_Switch1_tmp = 255;
  }

  if (2 > (uint8_T)rtb_Switch1_tmp) {
    i_0 = 0;
    n = 0;
  } else {
    i_0 = 1;
    n = (uint8_T)rtb_Switch1_tmp;
  }

  /* '<S28>:1:3' */
  midm1 = n - i_0;
  for (rtb_Switch1_tmp = 0; rtb_Switch1_tmp < midm1; rtb_Switch1_tmp++) {
    Tsort_data[rtb_Switch1_tmp] = rtb_Divide4_k[i_0 + rtb_Switch1_tmp];
  }

  PCGVmon_sort(Tsort_data, &midm1, inst);
  if (3 > midm1 - 2) {
    i_0 = -1;
    midm1 = -1;
  } else {
    i_0 = 1;
    midm1 -= 3;
  }

  /* '<S28>:1:4' */
  unusedU5 = midm1 - i_0;
  if (unusedU5 == 0) {
    rtb_Switch1 = 0.0F;
  } else if (unusedU5 == 1) {
    rtb_Switch1 = 0.0F;
  } else {
    if (unusedU5 == 0) {
      rtb_Switch1 = 0.0F;
    } else {
      rtb_Switch1 = Tsort_data[i_0 + 1];
      for (loop_ub = 2; loop_ub <= unusedU5; loop_ub++) {
        rtb_Switch1 += Tsort_data[i_0 + loop_ub];
      }
    }

    rtb_Switch1_tmp = unusedU5 - 1;
    rtb_Switch1 /= (real32_T)rtb_Switch1_tmp + 1.0F;
    for (loop_ub = 0; loop_ub < unusedU5; loop_ub++) {
      absdiff_data[loop_ub] = (real32_T)fabs(Tsort_data[(i_0 + loop_ub) + 1] -
        rtb_Switch1);
    }

    rtb_Switch1 = 0.0F;
    rtb_Divide4_f = 1.29246971E-26F;
    for (n = 0; n <= rtb_Switch1_tmp; n++) {
      if (absdiff_data[n] > rtb_Divide4_f) {
        medi = rtb_Divide4_f / absdiff_data[n];
        rtb_Switch1 = rtb_Switch1 * medi * medi + 1.0F;
        rtb_Divide4_f = absdiff_data[n];
      } else {
        medi = absdiff_data[n] / rtb_Divide4_f;
        rtb_Switch1 += medi * medi;
      }
    }

    rtb_Switch1 = rtb_Divide4_f * (real32_T)sqrt(rtb_Switch1);
    rtb_Switch1 /= (real32_T)sqrt((real32_T)((midm1 - i_0) - 1));
  }

  /* Outputs for Atomic SubSystem: '<S5>/TON1' */
  /* Switch: '<S1>/Environment Switch' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  /* '<S28>:1:6' */
  PCGVmon_TON(PCGVmon_B->BusInput.tGCB_On_Di,
              PCGVmon_B->BusInput1.rTi_GCBon_Delay, &PCGVmon_B->TON1,
              &PCGVmon_DWork->TON1, inst);

  /* End of Outputs for SubSystem: '<S5>/TON1' */

  /* Logic: '<S5>/Logical Operator1' incorporates:
   *  MATLAB Function: '<S5>/stdDev1'
   *  RelationalOperator: '<S5>/GreaterThan'
   *  Switch: '<S2>/Environment Switch'
   */
  reset = ((rtb_Switch1 < PCGVmon_B->BusInput1.rGradient_LimSwitch) &&
           PCGVmon_B->TON1.LogicalOperator3);

  /* Switch: '<S5>/Switch1' incorporates:
   *  Constant: '<S5>/Constant13'
   *  Constant: '<S5>/Constant15'
   */
  if (reset) {
    rtb_Divide4_f = 0.6F;
  } else {
    rtb_Divide4_f = 1.5F;
  }

  /* End of Switch: '<S5>/Switch1' */

  /* Sum: '<S5>/Add1' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_Divide4_f += PCGVmon_B->BusInput1.rOffset_EGTgradient_trans;

  /* RateLimiter: '<S5>/Rate Limiter' */
  medi = rtb_Divide4_f - PCGVmon_DWork->PrevY;
  if (medi > 1.0F) {
    rtb_Divide4_f = PCGVmon_DWork->PrevY + 1.0F;
  } else {
    if (medi < -0.01F) {
      rtb_Divide4_f = PCGVmon_DWork->PrevY + -0.01F;
    }
  }

  PCGVmon_DWork->PrevY = rtb_Divide4_f;

  /* End of RateLimiter: '<S5>/Rate Limiter' */

  /* Outputs for Atomic SubSystem: '<S5>/TON' */
  /* Switch: '<S2>/Environment Switch' */
  PCGVmon_TON(reset, PCGVmon_B->BusInput1.rTi_EGT_ss_ActDelay, &PCGVmon_B->TON,
              &PCGVmon_DWork->TON, inst);

  /* End of Outputs for SubSystem: '<S5>/TON' */

  /* Switch: '<S5>/Switch2' incorporates:
   *  Constant: '<S5>/Constant20'
   *  Constant: '<S5>/Constant21'
   *  Sum: '<S5>/Add3'
   *  Switch: '<S2>/Environment Switch'
   */
  if (PCGVmon_B->TON.LogicalOperator3) {
    rtb_Divide = PCGVmon_B->BusInput1.rOffset_EGTgradient_ss + -0.1F;
  } else {
    rtb_Divide = 0.0F;
  }

  /* End of Switch: '<S5>/Switch2' */

  /* RateLimiter: '<S5>/Rate Limiter1' */
  medi = rtb_Divide - PCGVmon_DWork->PrevY_a;
  if (medi > 1.0F) {
    rtb_Divide = PCGVmon_DWork->PrevY_a + 1.0F;
  } else {
    if (medi < -0.001F) {
      rtb_Divide = PCGVmon_DWork->PrevY_a + -0.001F;
    }
  }

  PCGVmon_DWork->PrevY_a = rtb_Divide;

  /* End of RateLimiter: '<S5>/Rate Limiter1' */

  /* Sum: '<S5>/Add' */
  rtb_Divide4_f += rtb_Divide;

  /* Sum: '<S8>/Subtract2' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    Tsort_data[i_0] = PCGVmon_B->sf_setZero.y[i_0] - rtb_Divide4_f;
  }

  /* End of Sum: '<S8>/Subtract2' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    /* Relay: '<S8>/Relay1' */
    if (Tsort_data[i_0] >= 0.0F) {
      PCGVmon_DWork->Relay1_Mode[i_0] = true;
    } else {
      if (Tsort_data[i_0] <= -0.2F) {
        PCGVmon_DWork->Relay1_Mode[i_0] = false;
      }
    }

    /* Logic: '<S8>/Logical Operator3' incorporates:
     *  Logic: '<S8>/Logical Operator4'
     *  Relay: '<S8>/Relay1'
     *  Switch: '<S1>/Environment Switch'
     *  Switch: '<S2>/Environment Switch'
     */
    rtb_BPCGVstickin[i_0] = ((!PCGVmon_B->BusInput.MSAGT[i_0]) &&
      PCGVmon_DWork->Relay1_Mode[i_0] && PCGVmon_B->BusInput1.bPCGVmon_Act);

    /* Relay: '<S8>/Relay1' */
    Tsort_data[i_0] = PCGVmon_DWork->Relay1_Mode[i_0];
  }

  /* Outputs for Atomic SubSystem: '<S6>/TON2' */
  /* RelationalOperator: '<S6>/GreaterThan3' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_TON(rtb_y_e > PCGVmon_B->BusInput1.rTmedian_StartThresh,
              PCGVmon_B->BusInput1.rTi_Uign_MonActDelay, &PCGVmon_B->TON2,
              &PCGVmon_DWork->TON2, inst);

  /* End of Outputs for SubSystem: '<S6>/TON2' */

  /* MATLAB Function: '<S6>/MATLAB Function2' incorporates:
   *  Delay: '<S6>/Delay'
   *  Switch: '<S2>/Environment Switch'
   */
  /* MATLAB Function 'Subsystem2/MATLAB Function2': '<S32>:1' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    d[i_0] = (rtb_Switch_b[i_0] > PCGVmon_B->BusInput1.rU_Ign_CylActThresh *
              rtb_Switch);
  }

  reset = !PCGVmon_B->TON2.LogicalOperator3;
  for (i_0 = 0; i_0 < 25; i_0++) {
    if ((!PCGVmon_DWork->bPCGVstickTexhGradOld[i_0]) && rtb_BPCGVstickin[i_0] &&
        (((PCGVmon_B->sf_setZero1.y[i_0] > PCGVmon_DWork->Delay_DSTATE[i_0] -
           PCGVmon_B->BusInput1.rU_Ign_DetLim) && d[i_0] &&
          PCGVmon_B->TON2.LogicalOperator3) || reset)) {
      /* '<S32>:1:14' */
      /* '<S32>:1:19' */
      PCGVmon_DWork->bPCGVstick_temp[i_0] = true;
    }
  }

  /* '<S32>:1:24' */
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstickTexhGradOld[midm1] && (!rtb_BPCGVstickin[midm1]))
    {
      /* '<S32>:1:21' */
      /* '<S32>:1:22' */
      PCGVmon_DWork->bPCGVstick_temp[midm1] = false;
    }

    PCGVmon_DWork->bPCGVstickTexhGradOld[midm1] = rtb_BPCGVstickin[midm1];
  }

  /* MATLAB Function: '<S6>/MATLAB Function1' incorporates:
   *  Delay: '<S6>/Delay1'
   *  MATLAB Function: '<S6>/MATLAB Function2'
   *  MATLAB Function: '<S6>/MATLAB Function3'
   *  Switch: '<S1>/Environment Switch'
   *  Switch: '<S2>/Environment Switch'
   */
  /* '<S32>:1:27' */
  /* MATLAB Function 'Subsystem2/MATLAB Function1': '<S31>:1' */
  if (rtb_y_e < 500.0F) {
    /* '<S31>:1:60' */
    /* '<S31>:1:61' */
    rtb_Switch = 6.0F;
  } else {
    /* '<S31>:1:63' */
    rtb_Switch = 2.5F;
  }

  /* '<S31>:1:67' */
  for (rtb_Switch1_tmp = 0; rtb_Switch1_tmp < 25; rtb_Switch1_tmp++) {
    rtb_Switch_b[rtb_Switch1_tmp] = rtb_Switch_hx[rtb_Switch1_tmp] - rtb_y_e;
  }

  PCGVmon_abs(rtb_Switch_b, rtb_Switch_hx, inst);
  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (rtb_Switch_hx[midm1] < rtb_DotProduct) {
      /* '<S31>:1:70' */
      PCGVmon_DWork->bTexhInRange[midm1] = true;
    }

    if (rtb_Switch_hx[midm1] >= rtb_DotProduct) {
      /* '<S31>:1:71' */
      PCGVmon_DWork->bTexhInRange[midm1] = false;
    }

    if (PCGVmon_DWork->bPCGVstick_temp[midm1]) {
      b_data[i_0] = PCGVmon_DWork->count1[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstick_temp[midm1]) {
      /* '<S31>:1:74' */
      PCGVmon_DWork->count1[midm1] = b_data[i_0] + 1.0F;
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->switch1[midm1]) {
      c_data[i_0] = (int8_T)(midm1 + 1);
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->switch1[midm1]) {
      i_0++;
    }
  }

  unusedU5 = i_0;
  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->switch1[midm1]) {
      d_data[i_0] = PCGVmon_DWork->count2[midm1];
      i_0++;
    }
  }

  /* '<S31>:1:75' */
  for (rtb_Switch1_tmp = 0; rtb_Switch1_tmp < unusedU5; rtb_Switch1_tmp++) {
    PCGVmon_DWork->count2[c_data[rtb_Switch1_tmp] - 1] = d_data[rtb_Switch1_tmp]
      + 1.0F;
  }

  /* '<S31>:1:77' */
  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    reset = !PCGVmon_DWork->bPCGVstick_temp[midm1];
    i[midm1] = (PCGVmon_DWork->bPCGVstickOld[midm1] && reset);
    if (PCGVmon_DWork->bPCGVstickOld[midm1] && reset) {
      /* '<S31>:1:77' */
      e_data[i_0] = PCGVmon_DWork->tiStickDurAll[midm1];
      i_0++;
    }

    d[midm1] = reset;
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstickOld[midm1] && d[midm1]) {
      /* '<S31>:1:77' */
      f_data[i_0] = PCGVmon_DWork->count1[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstickOld[midm1] && d[midm1]) {
      /* '<S31>:1:77' */
      /* '<S31>:1:78' */
      PCGVmon_DWork->tiStickDurAll[midm1] = e_data[i_0] + f_data[i_0];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstickOld[midm1] && d[midm1]) {
      /* '<S31>:1:77' */
      m_data[i_0] = PCGVmon_DWork->count1[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstickOld[midm1] && d[midm1]) {
      /* '<S31>:1:77' */
      /* '<S31>:1:80' */
      PCGVmon_DWork->tiStickDur[midm1] = m_data[i_0];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstickOld[midm1] && d[midm1]) {
      /* '<S31>:1:77' */
      g_data[i_0] = (int8_T)(midm1 + 1);
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstickOld[midm1] && d[midm1]) {
      /* '<S31>:1:77' */
      i_0++;
    }
  }

  unusedU5 = i_0;
  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bPCGVstickOld[midm1] && d[midm1]) {
      /* '<S31>:1:77' */
      s_data[i_0] = (int8_T)(midm1 + 1);
      i_0++;
    }
  }

  /* '<S31>:1:81' */
  for (rtb_Switch1_tmp = 0; rtb_Switch1_tmp < unusedU5; rtb_Switch1_tmp++) {
    PCGVmon_DWork->tiMultStick[g_data[rtb_Switch1_tmp] - 1] =
      PCGVmon_DWork->count1[s_data[rtb_Switch1_tmp] - 1] * rtb_Switch;
  }

  for (i_0 = 0; i_0 < 25; i_0++) {
    if (i[i_0]) {
      /* '<S31>:1:82' */
      PCGVmon_DWork->count1[i_0] = 0.0F;

      /* '<S31>:1:83' */
      PCGVmon_DWork->count2[i_0] = 0.0F;

      /* '<S31>:1:84' */
      PCGVmon_DWork->switch1[i_0] = true;

      /* '<S31>:1:85' */
      PCGVmon_DWork->switch2[i_0] = true;

      /* '<S31>:1:86' */
      PCGVmon_DWork->switch3[i_0] = true;
    }

    PCGVmon_DWork->bTexhInRangeOld[i_0] = ((!PCGVmon_DWork->bTexhInRangeOld[i_0])
      && PCGVmon_DWork->bTexhInRange[i_0] && (PCGVmon_DWork->count2[i_0] >
      PCGVmon_DWork->tiMultStick[i_0]));
    i[i_0] = PCGVmon_DWork->switch3[i_0];
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bTexhInRangeOld[midm1] && PCGVmon_DWork->switch3[midm1])
    {
      /* '<S31>:1:89' */
      h_data[i_0] = PCGVmon_DWork->tiStickDurAll[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bTexhInRangeOld[midm1] && PCGVmon_DWork->switch3[midm1])
    {
      /* '<S31>:1:89' */
      j_data[i_0] = PCGVmon_DWork->count2[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  reset = (rtb_LogicalOperator1_tmp && PCGVmon_DWork->GCBold);
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (PCGVmon_DWork->bTexhInRangeOld[midm1] && PCGVmon_DWork->switch3[midm1])
    {
      /* '<S31>:1:89' */
      /* '<S31>:1:90' */
      PCGVmon_DWork->tiStickDurAll[midm1] = h_data[i_0] + j_data[i_0];
      i_0++;

      /* '<S31>:1:89' */
      /* '<S31>:1:91' */
      PCGVmon_DWork->switch2[midm1] = false;

      /* '<S31>:1:89' */
      /* '<S31>:1:92' */
      PCGVmon_DWork->switch1[midm1] = false;

      /* '<S31>:1:89' */
      /* '<S31>:1:93' */
      PCGVmon_DWork->count2[midm1] = 0.0F;
    }

    r_tmp_0 = ((!PCGVmon_DWork->bPCGVstickOld[midm1]) &&
               PCGVmon_DWork->bPCGVstick_temp[midm1]);
    d[midm1] = ((r_tmp_0 || reset) && (PCGVmon_DWork->count2[midm1] >
      PCGVmon_DWork->tiMultStick[midm1]));
    r_tmp[midm1] = r_tmp_0;
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && PCGVmon_DWork->switch2[midm1]) {
      /* '<S31>:1:95' */
      k_data[i_0] = PCGVmon_DWork->tiStickDurAll[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && PCGVmon_DWork->switch2[midm1]) {
      /* '<S31>:1:95' */
      l_data[i_0] = PCGVmon_DWork->count2[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && PCGVmon_DWork->switch2[midm1]) {
      /* '<S31>:1:95' */
      /* '<S31>:1:96' */
      PCGVmon_DWork->tiStickDurAll[midm1] = k_data[i_0] + l_data[i_0];
      i_0++;

      /* '<S31>:1:95' */
      /* '<S31>:1:97' */
      PCGVmon_DWork->switch3[midm1] = false;
    }

    if (PCGVmon_DWork->bTexhInRangeOld[midm1] && i[midm1]) {
      /* '<S31>:1:89' */
      /* '<S31>:1:98' */
      PCGVmon_DWork->switch1[midm1] = false;
    }

    if (d[midm1] && PCGVmon_DWork->switch2[midm1]) {
      /* '<S31>:1:95' */
      /* '<S31>:1:99' */
      PCGVmon_DWork->count2[midm1] = 0.0F;
    }

    PCGVmon_DWork->bPCGVstickOld[midm1] = (r_tmp[midm1] || (rtb_Switch_hx[midm1]
      < PCGVmon_B->BusInput1.rT_recoverLim));
    if (PCGVmon_DWork->bPCGVstickOld[midm1] || rtb_LogicalOperator1_tmp) {
      /* '<S31>:1:101' */
      /* '<S31>:1:102' */
      PCGVmon_DWork->switch1[midm1] = false;

      /* '<S31>:1:101' */
      /* '<S31>:1:103' */
      PCGVmon_DWork->count2[midm1] = 0.0F;
    }

    d[midm1] = ((PCGVmon_DWork->count1Old[midm1] == 1.0F) &&
                (PCGVmon_DWork->count1[midm1] > 1.0F));
  }

  reset = (PCGVmon_B->BusInput.tGCB_On_Di && (!PCGVmon_DWork->GCBold));

  /* '<S31>:1:110' */
  /* '<S31>:1:111' */
  /* '<S31>:1:112' */
  PCGVmon_DWork->GCBold = PCGVmon_B->BusInput.tGCB_On_Di;

  /* '<S31>:1:113' */
  /* '<S31>:1:115' */
  /* '<S31>:1:116' */
  /* '<S31>:1:117' */
  /* '<S31>:1:118' */
  /* '<S31>:1:119' */
  /* '<S31>:1:120' */
  /* '<S31>:1:121' */
  /* MATLAB Function 'Subsystem2/MATLAB Function3': '<S33>:1' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    if (d[i_0] || reset || rtb_LogicalOperator1_tmp_0) {
      /* '<S31>:1:105' */
      /* '<S31>:1:106' */
      PCGVmon_DWork->tiStickDurAll[i_0] = 0.0F;
    }

    PCGVmon_DWork->bTexhInRangeOld[i_0] = PCGVmon_DWork->bTexhInRange[i_0];
    PCGVmon_DWork->bPCGVstickOld[i_0] = PCGVmon_DWork->bPCGVstick_temp[i_0];
    PCGVmon_DWork->count1Old[i_0] = PCGVmon_DWork->count1[i_0];
    rtb_Switch_b[i_0] = PCGVmon_DWork->count1[i_0];

    /* MATLAB Function: '<S6>/MATLAB Function3' incorporates:
     *  MATLAB Function: '<S6>/MATLAB Function2'
     *  Switch: '<S2>/Environment Switch'
     */
    i[i_0] = (PCGVmon_DWork->tiStickDurAll[i_0] <
              PCGVmon_B->BusInput1.iTi_PCGV_class1_border);
    d[i_0] = (((PCGVmon_DWork->Cnt1OldDely[i_0] > 0.0F) &&
               (PCGVmon_DWork->Delay1_DSTATE[i_0] == 0.0F) &&
               ((PCGVmon_DWork->Cnt2Old[i_0] == 0.0F) && (PCGVmon_DWork->
      count2[i_0] == 0.0F))) || ((PCGVmon_DWork->Cnt2Old[i_0] >
                PCGVmon_DWork->count2[i_0]) && (PCGVmon_DWork->count2[i_0] ==
                0.0F)));
  }

  /* MATLAB Function: '<S6>/MATLAB Function3' incorporates:
   *  Delay: '<S6>/Delay1'
   *  MATLAB Function: '<S6>/MATLAB Function1'
   *  Switch: '<S1>/Environment Switch'
   *  Switch: '<S2>/Environment Switch'
   */
  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && i[midm1]) {
      /* '<S33>:1:57' */
      b_data_0[i_0] = PCGVmon_DWork->iCnt_class1[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && i[midm1]) {
      /* '<S33>:1:57' */
      /* '<S33>:1:58' */
      tmp = b_data_0[i_0] + 1U;
      if (tmp > 65535U) {
        tmp = 65535U;
      }

      PCGVmon_DWork->iCnt_class1[midm1] = (uint16_T)tmp;
      i_0++;
    }

    d[midm1] = (((PCGVmon_DWork->Cnt1OldDely[midm1] > 0.0F) &&
                 (PCGVmon_DWork->Delay1_DSTATE[midm1] == 0.0F) &&
                 ((PCGVmon_DWork->Cnt2Old[midm1] == 0.0F) &&
                  (PCGVmon_DWork->count2[midm1] == 0.0F))) ||
                ((PCGVmon_DWork->Cnt2Old[midm1] > PCGVmon_DWork->count2[midm1]) &&
                 (PCGVmon_DWork->count2[midm1] == 0.0F)));
    i[midm1] = ((PCGVmon_DWork->tiStickDurAll[midm1] >=
                 PCGVmon_B->BusInput1.iTi_PCGV_class1_border) &&
                (PCGVmon_DWork->tiStickDurAll[midm1] <
                 PCGVmon_B->BusInput1.iTi_PCGV_class2_border));
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && i[midm1]) {
      /* '<S33>:1:60' */
      c_data_0[i_0] = PCGVmon_DWork->iCnt_class2[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && i[midm1]) {
      /* '<S33>:1:60' */
      /* '<S33>:1:61' */
      tmp = c_data_0[i_0] + 1U;
      if (tmp > 65535U) {
        tmp = 65535U;
      }

      PCGVmon_DWork->iCnt_class2[midm1] = (uint16_T)tmp;
      i_0++;
    }

    d[midm1] = (((PCGVmon_DWork->Cnt1OldDely[midm1] > 0.0F) &&
                 (PCGVmon_DWork->Delay1_DSTATE[midm1] == 0.0F) &&
                 ((PCGVmon_DWork->Cnt2Old[midm1] == 0.0F) &&
                  (PCGVmon_DWork->count2[midm1] == 0.0F))) ||
                ((PCGVmon_DWork->Cnt2Old[midm1] > PCGVmon_DWork->count2[midm1]) &&
                 (PCGVmon_DWork->count2[midm1] == 0.0F)));
    i[midm1] = ((PCGVmon_DWork->tiStickDurAll[midm1] >=
                 PCGVmon_B->BusInput1.iTi_PCGV_class2_border) &&
                (PCGVmon_DWork->tiStickDurAll[midm1] <
                 PCGVmon_B->BusInput1.iTi_PCGV_class3_border));
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && i[midm1]) {
      /* '<S33>:1:63' */
      d_data_0[i_0] = PCGVmon_DWork->iCnt_class3[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && i[midm1]) {
      /* '<S33>:1:63' */
      /* '<S33>:1:64' */
      tmp = d_data_0[i_0] + 1U;
      if (tmp > 65535U) {
        tmp = 65535U;
      }

      PCGVmon_DWork->iCnt_class3[midm1] = (uint16_T)tmp;
      i_0++;
    }

    d[midm1] = (((PCGVmon_DWork->Cnt1OldDely[midm1] > 0.0F) &&
                 (PCGVmon_DWork->Delay1_DSTATE[midm1] == 0.0F) &&
                 ((PCGVmon_DWork->Cnt2Old[midm1] == 0.0F) &&
                  (PCGVmon_DWork->count2[midm1] == 0.0F))) ||
                ((PCGVmon_DWork->Cnt2Old[midm1] > PCGVmon_DWork->count2[midm1]) &&
                 (PCGVmon_DWork->count2[midm1] == 0.0F)));
    i[midm1] = ((PCGVmon_DWork->tiStickDurAll[midm1] >=
                 PCGVmon_B->BusInput1.iTi_PCGV_class3_border) &&
                (PCGVmon_DWork->tiStickDurAll[midm1] <
                 PCGVmon_B->BusInput1.iTi_PCGV_class4_border));
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && i[midm1]) {
      /* '<S33>:1:66' */
      e_data_0[i_0] = PCGVmon_DWork->iCnt_class4[midm1];
      i_0++;
    }
  }

  i_0 = 0;
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] && i[midm1]) {
      /* '<S33>:1:66' */
      /* '<S33>:1:67' */
      tmp = e_data_0[i_0] + 1U;
      if (tmp > 65535U) {
        tmp = 65535U;
      }

      PCGVmon_DWork->iCnt_class4[midm1] = (uint16_T)tmp;
      i_0++;
    }

    reset = ((PCGVmon_DWork->iCnt_class1[midm1] > PCGVmon_DWork->
              iCnt_class1Old[midm1]) || (PCGVmon_DWork->iCnt_class2[midm1] >
              PCGVmon_DWork->iCnt_class2Old[midm1]) ||
             (PCGVmon_DWork->iCnt_class3[midm1] > PCGVmon_DWork->
              iCnt_class3Old[midm1]));
    rtb_LogicalOperator1_tmp = (PCGVmon_DWork->iCnt_class4[midm1] >
      PCGVmon_DWork->iCnt_class4Old[midm1]);
    if (reset || rtb_LogicalOperator1_tmp) {
      /* '<S33>:1:72' */
      /* '<S33>:1:73' */
      PCGVmon_DWork->lastStickDurTmp[midm1] = PCGVmon_DWork->tiStickDurAll[midm1];
    }

    if ((!reset) && (!rtb_LogicalOperator1_tmp)) {
      /* '<S33>:1:74' */
      PCGVmon_DWork->lastStickDurTmp[midm1] = 0.0F;
    }

    if ((PCGVmon_B->BusInput.iCnt_PCGV_class1_MM2VIS[midm1] >= 65534) ||
        rtb_LogicalOperator1_tmp_0) {
      /* '<S33>:1:79' */
      /* '<S33>:1:80' */
      PCGVmon_DWork->iCnt_class1[midm1] = 0U;
    }

    d[midm1] = (PCGVmon_B->BusInput.iCnt_PCGV_class2_MM2VIS[midm1] >= 65534);
    i[midm1] = rtb_LogicalOperator1_tmp;
  }

  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] || rtb_LogicalOperator1_tmp_0) {
      /* '<S33>:1:81' */
      /* '<S33>:1:82' */
      PCGVmon_DWork->iCnt_class2[midm1] = 0U;
    }

    d[midm1] = (PCGVmon_B->BusInput.iCnt_PCGV_class3_MM2VIS[midm1] >= 65534);
  }

  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] || rtb_LogicalOperator1_tmp_0) {
      /* '<S33>:1:83' */
      /* '<S33>:1:84' */
      PCGVmon_DWork->iCnt_class3[midm1] = 0U;
    }

    d[midm1] = (PCGVmon_B->BusInput.iCnt_PCGV_class4_MM2VIS[midm1] >= 65534);
  }

  /* '<S33>:1:90' */
  /* '<S33>:1:91' */
  /* '<S33>:1:92' */
  /* '<S33>:1:93' */
  /* '<S33>:1:94' */
  /* '<S33>:1:95' */
  /* '<S33>:1:97' */
  /* '<S33>:1:98' */
  /* '<S33>:1:99' */
  /* '<S33>:1:100' */
  /* '<S33>:1:101' */
  for (midm1 = 0; midm1 < 25; midm1++) {
    if (d[midm1] || rtb_LogicalOperator1_tmp_0) {
      /* '<S33>:1:85' */
      /* '<S33>:1:86' */
      PCGVmon_DWork->iCnt_class4[midm1] = 0U;
    }

    PCGVmon_DWork->Cnt1OldDely[midm1] = PCGVmon_DWork->Delay1_DSTATE[midm1];
    PCGVmon_DWork->Cnt2Old[midm1] = PCGVmon_DWork->count2[midm1];
    PCGVmon_DWork->iCnt_class1Old[midm1] = PCGVmon_DWork->iCnt_class1[midm1];
    PCGVmon_DWork->iCnt_class2Old[midm1] = PCGVmon_DWork->iCnt_class2[midm1];
    PCGVmon_DWork->iCnt_class3Old[midm1] = PCGVmon_DWork->iCnt_class3[midm1];
    PCGVmon_DWork->iCnt_class4Old[midm1] = PCGVmon_DWork->iCnt_class4[midm1];
    Tsort_data[midm1] = PCGVmon_DWork->lastStickDurTmp[midm1];
  }

  /* MinMax: '<S7>/MinMax2' incorporates:
   *  UnitDelay: '<S7>/Unit Delay2'
   */
  medi = PCGVmon_DWork->UnitDelay2_DSTATE[0];
  for (i_0 = 0; i_0 < 24; i_0++) {
    rtb_DotProduct = PCGVmon_DWork->UnitDelay2_DSTATE[i_0 + 1];
    if (medi <= rtb_DotProduct) {
      medi = rtb_DotProduct;
    }
  }

  /* DotProduct: '<S7>/Dot Product' */
  rtb_DotProduct = 0.0F;

  /* UnitDelay: '<S7>/Unit Delay3' */
  rtb_UnitDelay3 = PCGVmon_DWork->UnitDelay3_DSTATE;

  /* UnitDelay: '<S7>/Unit Delay4' */
  rtb_UnitDelay4 = PCGVmon_DWork->UnitDelay4_DSTATE;

  /* UnitDelay: '<S7>/Unit Delay5' */
  rtb_UnitDelay5 = PCGVmon_DWork->UnitDelay5_DSTATE;

  /* UnitDelay: '<S7>/Unit Delay6' */
  rtb_UnitDelay6 = PCGVmon_DWork->UnitDelay6_DSTATE;

  /* UnitDelay: '<S7>/Unit Delay7' */
  rtb_UnitDelay7 = PCGVmon_DWork->UnitDelay7_DSTATE;

  /* UnitDelay: '<S7>/Unit Delay9' */
  rtb_UnitDelay9 = PCGVmon_DWork->UnitDelay9_DSTATE;

  /* UnitDelay: '<S7>/Unit Delay11' */
  rtb_UnitDelay11 = PCGVmon_DWork->UnitDelay11_DSTATE;
  for (i_0 = 0; i_0 < 25; i_0++) {
    /* DotProduct: '<S7>/Dot Product' incorporates:
     *  MATLAB Function: '<S6>/MATLAB Function3'
     */
    rtb_DotProduct += PCGVmon_DWork->lastStickDurTmp[i_0];

    /* Outport: '<Root>/Out' incorporates:
     *  MATLAB Function: '<S6>/MATLAB Function3'
     */
    PCGVmon_Y->Out.iCnt_PCGV_class1[i_0] = PCGVmon_DWork->iCnt_class1[i_0];
    PCGVmon_Y->Out.iCnt_PCGV_class2[i_0] = PCGVmon_DWork->iCnt_class2[i_0];
    PCGVmon_Y->Out.iCnt_PCGV_class3[i_0] = PCGVmon_DWork->iCnt_class3[i_0];
    PCGVmon_Y->Out.iCnt_PCGV_class4[i_0] = PCGVmon_DWork->iCnt_class4[i_0];
  }

  /* Switch: '<S7>/Switch3' incorporates:
   *  DotProduct: '<S7>/Dot Product'
   *  MinMax: '<S7>/MinMax2'
   *  RelationalOperator: '<S37>/FixPt Relational Operator'
   *  Switch: '<S7>/Switch10'
   *  Switch: '<S7>/Switch11'
   *  Switch: '<S7>/Switch12'
   *  Switch: '<S7>/Switch13'
   *  Switch: '<S7>/Switch4'
   *  Switch: '<S7>/Switch5'
   *  Switch: '<S7>/Switch6'
   *  Switch: '<S7>/Switch7'
   *  Switch: '<S7>/Switch8'
   *  Switch: '<S7>/Switch9'
   *  UnitDelay: '<S37>/Delay Input1'
   *  UnitDelay: '<S7>/Unit Delay10'
   *  UnitDelay: '<S7>/Unit Delay12'
   *  UnitDelay: '<S7>/Unit Delay13'
   *  UnitDelay: '<S7>/Unit Delay8'
   */
  if (rtb_DotProduct < PCGVmon_DWork->DelayInput1_DSTATE) {
    rtb_Switch = medi;
    rtb_Switch10 = PCGVmon_DWork->UnitDelay8_DSTATE;
    rtb_Switch12 = PCGVmon_DWork->UnitDelay10_DSTATE;
  } else {
    rtb_Switch = PCGVmon_DWork->UnitDelay13_DSTATE;
    medi = rtb_UnitDelay3;
    rtb_UnitDelay3 = rtb_UnitDelay4;
    rtb_UnitDelay4 = rtb_UnitDelay5;
    rtb_UnitDelay5 = rtb_UnitDelay6;
    rtb_UnitDelay6 = rtb_UnitDelay7;
    rtb_UnitDelay7 = PCGVmon_DWork->UnitDelay8_DSTATE;
    rtb_Switch10 = rtb_UnitDelay9;
    rtb_UnitDelay9 = PCGVmon_DWork->UnitDelay10_DSTATE;
    rtb_Switch12 = rtb_UnitDelay11;
    rtb_UnitDelay11 = PCGVmon_DWork->UnitDelay12_DSTATE;
  }

  /* End of Switch: '<S7>/Switch3' */

  /* Sum: '<S7>/Add3' incorporates:
   *  Switch: '<S7>/Switch14'
   *  Switch: '<S7>/Switch15'
   *  Switch: '<S7>/Switch16'
   *  Switch: '<S7>/Switch17'
   *  Switch: '<S7>/Switch18'
   *  Switch: '<S7>/Switch19'
   *  Switch: '<S7>/Switch20'
   *  Switch: '<S7>/Switch21'
   *  Switch: '<S7>/Switch22'
   *  Switch: '<S7>/Switch23'
   */
  rtb_Divide = (real32_T)((((((((((medi > 0.0F) + (rtb_UnitDelay3 > 0.0F)) +
    (rtb_UnitDelay4 > 0.0F)) + (rtb_UnitDelay5 > 0.0F)) + (rtb_UnitDelay6 > 0.0F))
    + (rtb_UnitDelay7 > 0.0F)) + (rtb_Switch10 > 0.0F)) + (rtb_UnitDelay9 > 0.0F))
    + (rtb_Switch12 > 0.0F)) + (rtb_UnitDelay11 > 0.0F));

  /* Switch: '<S38>/Switch' incorporates:
   *  Abs: '<S38>/Abs'
   *  RelationalOperator: '<S38>/Relational Operator'
   */
  if (2.22044605E-16F >= rtb_Divide) {
    rtb_Divide = 2.22044605E-16F;
  }

  /* End of Switch: '<S38>/Switch' */

  /* Product: '<S7>/Divide' incorporates:
   *  Sum: '<S7>/Add2'
   */
  rtb_Divide = (((((((((medi + rtb_UnitDelay3) + rtb_UnitDelay4) +
                      rtb_UnitDelay5) + rtb_UnitDelay6) + rtb_UnitDelay7) +
                   rtb_Switch10) + rtb_UnitDelay9) + rtb_Switch12) +
                rtb_UnitDelay11) / rtb_Divide;

  /* Outport: '<Root>/Out' incorporates:
   *  BusCreator generated from: '<Root>/Out'
   */
  PCGVmon_Y->Out.rTi_PCGV_LastStickDur = rtb_Switch;
  PCGVmon_Y->Out.rTi_PCGV_MeanLastStickEvts = rtb_Divide;

  /* MATLAB Function: '<S6>/setZero' incorporates:
   *  Switch: '<S1>/Environment Switch'
   */
  PCGVmon_setZero(rtb_Switch_hx, PCGVmon_B->BusInput.ucNumCyl,
                  &PCGVmon_B->sf_setZero_m, inst);

  /* BusCreator generated from: '<Root>/Dbg' incorporates:
   *  MATLAB Function: '<S5>/stdDev1'
   *  MATLAB Function: '<S6>/MATLAB Function1'
   *  MATLAB Function: '<S6>/MATLAB Function2'
   *  Outport: '<Root>/Dbg'
   */
  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_Y->Dbg.bPCGVstick[i_0] = rtb_BPCGVstickin[i_0];
    PCGVmon_Y->Dbg.rTexh_median_diff_grad[i_0] = rtb_Divide4_k[i_0];
  }

  PCGVmon_Y->Dbg.rStdDev = rtb_Switch1;
  PCGVmon_Y->Dbg.detectionLim = rtb_Divide4_f;
  PCGVmon_Y->Dbg.rTexh_median_filt = rtb_y_e;
  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_Y->Dbg.rU_Ign_Act_Filt[i_0] = PCGVmon_B->sf_setZero1.y[i_0];
  }

  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_Y->Dbg.rTexhMedDeviat[i_0] = PCGVmon_B->sf_setZero_m.y[i_0];
  }

  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_Y->Dbg.count1_stick[i_0] = PCGVmon_DWork->count1[i_0];
    PCGVmon_Y->Dbg.count2_stickLong[i_0] = PCGVmon_DWork->count2[i_0];
    PCGVmon_Y->Dbg.unstickDet[i_0] = PCGVmon_DWork->tiStickDur[i_0];
    PCGVmon_Y->Dbg.multStickDur[i_0] = PCGVmon_DWork->tiMultStick[i_0];
    PCGVmon_Y->Dbg.tiStickDurAll[i_0] = PCGVmon_DWork->tiStickDurAll[i_0];
    PCGVmon_Y->Dbg.bPCGVstickALL[i_0] = PCGVmon_DWork->bPCGVstick_temp[i_0];
    PCGVmon_Y->Dbg.bTexhInRange_out[i_0] = PCGVmon_DWork->bTexhInRange[i_0];

    /* BusCreator generated from: '<Root>/Bus Output' incorporates:
     *  MATLAB Function: '<S6>/MATLAB Function1'
     *  MATLAB Function: '<S6>/MATLAB Function2'
     */
    PCGVmon_B->BusConversion_InsertedFor_BusOu.bPCGVstick[i_0] =
      rtb_BPCGVstickin[i_0];
    PCGVmon_B->BusConversion_InsertedFor_BusOu.rTexh_median_diff_grad[i_0] =
      rtb_Divide4_k[i_0];
  }

  /* End of BusCreator generated from: '<Root>/Dbg' */

  /* BusCreator generated from: '<Root>/Bus Output' incorporates:
   *  MATLAB Function: '<S5>/stdDev1'
   *  MATLAB Function: '<S6>/MATLAB Function1'
   *  MATLAB Function: '<S6>/MATLAB Function2'
   */
  PCGVmon_B->BusConversion_InsertedFor_BusOu.rStdDev = rtb_Switch1;
  PCGVmon_B->BusConversion_InsertedFor_BusOu.detectionLim = rtb_Divide4_f;
  PCGVmon_B->BusConversion_InsertedFor_BusOu.rTexh_median_filt = rtb_y_e;
  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_B->BusConversion_InsertedFor_BusOu.rU_Ign_Act_Filt[i_0] =
      PCGVmon_B->sf_setZero1.y[i_0];
  }

  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_B->BusConversion_InsertedFor_BusOu.rTexhMedDeviat[i_0] =
      PCGVmon_B->sf_setZero_m.y[i_0];
  }

  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_B->BusConversion_InsertedFor_BusOu.count1_stick[i_0] =
      PCGVmon_DWork->count1[i_0];
    PCGVmon_B->BusConversion_InsertedFor_BusOu.count2_stickLong[i_0] =
      PCGVmon_DWork->count2[i_0];
    PCGVmon_B->BusConversion_InsertedFor_BusOu.unstickDet[i_0] =
      PCGVmon_DWork->tiStickDur[i_0];
    PCGVmon_B->BusConversion_InsertedFor_BusOu.multStickDur[i_0] =
      PCGVmon_DWork->tiMultStick[i_0];
    PCGVmon_B->BusConversion_InsertedFor_BusOu.tiStickDurAll[i_0] =
      PCGVmon_DWork->tiStickDurAll[i_0];
    PCGVmon_B->BusConversion_InsertedFor_BusOu.bPCGVstickALL[i_0] =
      PCGVmon_DWork->bPCGVstick_temp[i_0];
    PCGVmon_B->BusConversion_InsertedFor_BusOu.bTexhInRange_out[i_0] =
      PCGVmon_DWork->bTexhInRange[i_0];
  }

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Debug = PCGVmon_B->BusConversion_InsertedFor_BusOu;

  /* BusCreator generated from: '<Root>/Bus Output1' incorporates:
   *  MATLAB Function: '<S6>/MATLAB Function3'
   */
  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_B->BusConversion_InsertedFor_Bus_d.iCnt_PCGV_class1[i_0] =
      PCGVmon_DWork->iCnt_class1[i_0];
    PCGVmon_B->BusConversion_InsertedFor_Bus_d.iCnt_PCGV_class2[i_0] =
      PCGVmon_DWork->iCnt_class2[i_0];
    PCGVmon_B->BusConversion_InsertedFor_Bus_d.iCnt_PCGV_class3[i_0] =
      PCGVmon_DWork->iCnt_class3[i_0];
    PCGVmon_B->BusConversion_InsertedFor_Bus_d.iCnt_PCGV_class4[i_0] =
      PCGVmon_DWork->iCnt_class4[i_0];
  }

  PCGVmon_B->BusConversion_InsertedFor_Bus_d.rTi_PCGV_LastStickDur = rtb_Switch;
  PCGVmon_B->BusConversion_InsertedFor_Bus_d.rTi_PCGV_MeanLastStickEvts =
    rtb_Divide;

  /* End of BusCreator generated from: '<Root>/Bus Output1' */

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Output = PCGVmon_B->BusConversion_InsertedFor_Bus_d;

  /* MATLAB Function: '<S7>/MATLAB Function' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_Switch, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction, inst);

  /* MATLAB Function: '<S7>/MATLAB Function1' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(medi, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction1_p, inst);

  /* MATLAB Function: '<S7>/MATLAB Function10' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_UnitDelay11, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction10, inst);

  /* MATLAB Function: '<S7>/MATLAB Function2' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_UnitDelay3, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction2_o, inst);

  /* MATLAB Function: '<S7>/MATLAB Function3' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_UnitDelay4, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction3_o, inst);

  /* MATLAB Function: '<S7>/MATLAB Function4' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_UnitDelay5, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction4, inst);

  /* MATLAB Function: '<S7>/MATLAB Function5' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_UnitDelay6, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction5, inst);

  /* MATLAB Function: '<S7>/MATLAB Function6' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_UnitDelay7, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction6, inst);

  /* MATLAB Function: '<S7>/MATLAB Function7' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_Switch10, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction7, inst);

  /* MATLAB Function: '<S7>/MATLAB Function8' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_UnitDelay9, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction8, inst);

  /* MATLAB Function: '<S7>/MATLAB Function9' incorporates:
   *  Switch: '<S2>/Environment Switch'
   */
  PCGVmon_MATLABFunction(rtb_Switch12, PCGVmon_B->BusInput1.bPCGVmon_Act,
    &PCGVmon_B->sf_MATLABFunction9, inst);

  /* UnitDelay: '<S3>/Unit Delay' */
  PCGVmon_B->UnitDelay = PCGVmon_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Version = PCGVmon_B->UnitDelay;

  /* Update for Delay: '<S6>/Delay' */
  for (i_0 = 0; i_0 < 2; i_0++) {
    for (midm1 = 0; midm1 < 25; midm1++) {
      PCGVmon_DWork->Delay_DSTATE[i_0 * 25 + midm1] =
        PCGVmon_DWork->Delay_DSTATE[(i_0 + 1) * 25 + midm1];
    }
  }

  for (i_0 = 0; i_0 < 25; i_0++) {
    PCGVmon_DWork->Delay_DSTATE[i_0 + 50] = PCGVmon_B->sf_setZero1.y[i_0];
  }

  /* End of Update for Delay: '<S6>/Delay' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    /* Update for Delay: '<S6>/Delay1' */
    PCGVmon_DWork->Delay1_DSTATE[i_0] = rtb_Switch_b[i_0];

    /* Update for UnitDelay: '<S7>/Unit Delay2' */
    PCGVmon_DWork->UnitDelay2_DSTATE[i_0] = Tsort_data[i_0];
  }

  /* Update for UnitDelay: '<S37>/Delay Input1' incorporates:
   *  DotProduct: '<S7>/Dot Product'
   */
  PCGVmon_DWork->DelayInput1_DSTATE = rtb_DotProduct;

  /* Update for UnitDelay: '<S7>/Unit Delay13' */
  PCGVmon_DWork->UnitDelay13_DSTATE = PCGVmon_B->sf_MATLABFunction.y;

  /* Update for UnitDelay: '<S7>/Unit Delay3' */
  PCGVmon_DWork->UnitDelay3_DSTATE = PCGVmon_B->sf_MATLABFunction1_p.y;

  /* Update for UnitDelay: '<S7>/Unit Delay4' */
  PCGVmon_DWork->UnitDelay4_DSTATE = PCGVmon_B->sf_MATLABFunction2_o.y;

  /* Update for UnitDelay: '<S7>/Unit Delay5' */
  PCGVmon_DWork->UnitDelay5_DSTATE = PCGVmon_B->sf_MATLABFunction3_o.y;

  /* Update for UnitDelay: '<S7>/Unit Delay6' */
  PCGVmon_DWork->UnitDelay6_DSTATE = PCGVmon_B->sf_MATLABFunction4.y;

  /* Update for UnitDelay: '<S7>/Unit Delay7' */
  PCGVmon_DWork->UnitDelay7_DSTATE = PCGVmon_B->sf_MATLABFunction5.y;

  /* Update for UnitDelay: '<S7>/Unit Delay8' */
  PCGVmon_DWork->UnitDelay8_DSTATE = PCGVmon_B->sf_MATLABFunction6.y;

  /* Update for UnitDelay: '<S7>/Unit Delay9' */
  PCGVmon_DWork->UnitDelay9_DSTATE = PCGVmon_B->sf_MATLABFunction7.y;

  /* Update for UnitDelay: '<S7>/Unit Delay10' */
  PCGVmon_DWork->UnitDelay10_DSTATE = PCGVmon_B->sf_MATLABFunction8.y;

  /* Update for UnitDelay: '<S7>/Unit Delay11' */
  PCGVmon_DWork->UnitDelay11_DSTATE = PCGVmon_B->sf_MATLABFunction9.y;

  /* Update for UnitDelay: '<S7>/Unit Delay12' */
  PCGVmon_DWork->UnitDelay12_DSTATE = PCGVmon_B->sf_MATLABFunction10.y;

  /* Update for UnitDelay: '<S3>/Unit Delay' */
  PCGVmon_DWork->UnitDelay_DSTATE = 3U;
}

/* Model initialize function */
void PCGVmon_initialize(RT_MODEL_PCGVmon *const PCGVmon_M, struct fPCGVmon* inst)
{
  struct D_Work_PCGVmon *PCGVmon_DWork = ((struct D_Work_PCGVmon *) PCGVmon_M->dwork);

  /* InitializeConditions for RateLimiter: '<S5>/Rate Limiter' */
  PCGVmon_DWork->PrevY = 1.0F;

  /* SystemInitialize for Atomic SubSystem: '<S4>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S9>/Discrete-Time Integrator' */
  PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_o = 1U;

  /* End of SystemInitialize for SubSystem: '<S4>/Filter' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/Filter1' */
  /* InitializeConditions for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
  PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_l = 1U;

  /* End of SystemInitialize for SubSystem: '<S4>/Filter1' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/Filter5' */
  /* InitializeConditions for DiscreteIntegrator: '<S12>/Discrete-Time Integrator' */
  PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* End of SystemInitialize for SubSystem: '<S4>/Filter5' */

  /* SystemInitialize for Atomic SubSystem: '<S4>/Filter4' */
  /* InitializeConditions for DiscreteIntegrator: '<S11>/Discrete-Time Integrator' */
  PCGVmon_DWork->DiscreteTimeIntegrator_IC_LOA_b = 1U;

  /* End of SystemInitialize for SubSystem: '<S4>/Filter4' */
}

/* Model terminate function */
void PCGVmon_terminate(RT_MODEL_PCGVmon *const PCGVmon_M, struct fPCGVmon* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(PCGVmon_M);
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
