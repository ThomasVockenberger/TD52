/********************************************************************
 * COPYRIGHT -- B&R Industrial Automation GmbH
 ********************************************************************
 * Program: SAFI_VCD
 * File: SAFI_VCD.c
 * Author: 105055527
 * Last modified by: andreme00
 * Created: Mon Sep 05 18:14:57 2016
 * Last modified: Thu Sep 10 09:08:42 2020
 * Model Version: 1.04
 * Description: Post processing algorithm of the SAFI 2 KLS valve closure timing detection feature.

   Outstandings:
   -------------
   - NA
 * modified Comment: V1.00  31.01.2019  Andre   Generated
   V1.01  20.03.2019  Arnold  Generate reusable code
   V1.02  19.03.2020  Andre   Added detection of the 2nd highest peak for unbalanced valve detection (Development version)
   V1.03  31.07.2020  Andre   Corrected unbalance valve detection. Added reset.
   V1.04  10.09.2020  Andre   Do not fill up the VecVC array with value within first degrees of window. Use the min detection percentage on both peaks.
 ********************************************************************
 * Implementation of program SAFI_VCD
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V6.2.0
 * (ERT based)
 ********************************************************************/

#include "SAFI_VCD.h"
#include "SAFI_VCD_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/* Forward declaration for local functions */
static boolean_T SAFI_VCD_all(const real32_T x[100], struct fSAFI_VCD* inst);
static real32_T SAFI_VCD_std(const real32_T x[100], struct fSAFI_VCD* inst);
static void SAFI_VCD_histcounts(const real32_T x[100], real_T n[719], struct fSAFI_VCD* inst);
static void SAFI_VCD_getAllPeaksCodegen(const real_T y[719], int32_T iPk_data[],
  int32_T *iPk_size, int32_T *iInf_size, int32_T iInflect_data[], int32_T
  *iInflect_size, struct fSAFI_VCD* inst);
static void SAFI_VCD_removeSmallPeaks(const real_T y[719], const int32_T
  iFinite_data[], const int32_T *iFinite_size, int32_T iPk_data[], int32_T
  *iPk_size, struct fSAFI_VCD* inst);
static void SAFI_VCD_do_vectors(const int32_T a_data[], const int32_T *a_size,
  int32_T c_data[], int32_T *c_size, int32_T ia_data[], int32_T *ia_size,
  int32_T *ib_size, struct fSAFI_VCD* inst);
static void findPeaksSeparatedByMoreThanMin(const int32_T *iPk_size, int32_T
  idx_data[], int32_T *idx_size, struct fSAFI_VCD* inst);
static void SAFI_VCD_sortIdx(const real_T x_data[], const int32_T *x_size,
  int32_T idx_data[], int32_T *idx_size, struct fSAFI_VCD* inst);
static void SAFI_VCD_orderPeaks(const real_T Y[719], const int32_T iPk_data[],
  int32_T idx_data[], int32_T *idx_size, rtB_FindVC_SAFI_VCD *localB, struct fSAFI_VCD* inst);
static void SAFI_VCD_assignOutputs(const real_T y[719], const real_T x[719],
  const int32_T iPk_data[], const int32_T *iPk_size, real_T YpkOut_data[],
  int32_T YpkOut_size[2], real_T XpkOut_data[], int32_T XpkOut_size[2], struct fSAFI_VCD* inst);
static void SAFI_VCD_findpeaks(const real_T Yin[719], real_T Ypk_data[], int32_T
  Ypk_size[2], real_T Xpk_data[], int32_T Xpk_size[2], rtB_FindVC_SAFI_VCD
  *localB, struct fSAFI_VCD* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Function for MATLAB Function: '<Root>/FindVC' */
static boolean_T SAFI_VCD_all(const real32_T x[100], struct fSAFI_VCD* inst)
{
  boolean_T y;
  int32_T k;
  boolean_T exitg1;
  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 100)) {
    if (x[k] == 0.0F) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  return y;
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static real32_T SAFI_VCD_std(const real32_T x[100], struct fSAFI_VCD* inst)
{
  real32_T y;
  real32_T absdiff[100];
  real32_T xbar;
  real32_T t;
  int32_T c_k;
  xbar = x[0];
  for (c_k = 0; c_k < 99; c_k++) {
    xbar += x[c_k + 1];
  }

  xbar /= 100.0F;
  for (c_k = 0; c_k < 100; c_k++) {
    absdiff[c_k] = (real32_T)fabs(x[c_k] - xbar);
  }

  y = 0.0F;
  xbar = 1.29246971E-26F;
  for (c_k = 0; c_k < 100; c_k++) {
    if (absdiff[c_k] > xbar) {
      t = xbar / absdiff[c_k];
      y = y * t * t + 1.0F;
      xbar = absdiff[c_k];
    } else {
      t = absdiff[c_k] / xbar;
      y += t * t;
    }
  }

  y = xbar * (real32_T)sqrt(y);
  y /= 9.94987392F;
  return y;
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void SAFI_VCD_histcounts(const real32_T x[100], real_T n[719], struct fSAFI_VCD* inst)
{
  int32_T ni[719];
  real32_T bGuess;
  int32_T k;
  int32_T low_i;
  int32_T low_ip1;
  int32_T high_i;
  int32_T mid_i;
  memset(&ni[0], 0, 719U * sizeof(int32_T));
  for (k = 0; k < 100; k++) {
    if ((x[k] >= 1.0F) && (x[k] <= 720.0F)) {
      bGuess = (real32_T)ceil(x[k] - 1.0F);
      if ((bGuess >= 1.0F) && (bGuess < 720.0F) && (x[k] >= (bGuess - 1.0) + 1.0)
          && (x[k] < ((bGuess + 1.0) - 1.0) + 1.0)) {
        low_i = (int32_T)bGuess - 1;
        ni[low_i]++;
      } else {
        low_i = 1;
        low_ip1 = 2;
        high_i = 720;
        while (high_i > low_ip1) {
          mid_i = (low_i + high_i) >> 1;
          if (x[k] >= ((real_T)mid_i - 1.0) + 1.0) {
            low_i = mid_i;
            low_ip1 = mid_i + 1;
          } else {
            high_i = mid_i;
          }
        }

        ni[low_i - 1]++;
      }
    }
  }

  for (k = 0; k < 719; k++) {
    n[k] = ni[k];
  }
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void SAFI_VCD_getAllPeaksCodegen(const real_T y[719], int32_T iPk_data[],
  int32_T *iPk_size, int32_T *iInf_size, int32_T iInflect_data[], int32_T
  *iInflect_size, struct fSAFI_VCD* inst)
{
  int32_T nPk;
  int32_T nInflect;
  char_T dir;
  int32_T kfirst;
  real_T ykfirst;
  char_T previousdir;
  int32_T k;
  int16_T iPk_data_0[719];
  real_T tmp;
  nPk = -1;
  nInflect = -1;
  dir = 'n';
  kfirst = 1;
  ykfirst = y[0];
  for (k = 0; k < 718; k++) {
    tmp = y[k + 1];
    if (tmp != ykfirst) {
      previousdir = dir;
      if (tmp < ykfirst) {
        dir = 'd';
        if ('d' != previousdir) {
          nInflect++;
          iInflect_data[nInflect] = kfirst;
          if (previousdir == 'i') {
            nPk++;
            iPk_data[nPk] = kfirst;
          }
        }
      } else {
        dir = 'i';
        if ('i' != previousdir) {
          nInflect++;
          iInflect_data[nInflect] = kfirst;
        }
      }

      ykfirst = tmp;
      kfirst = k + 2;
    }
  }

  if ((nInflect + 1 == 0) || (iInflect_data[nInflect] < 719)) {
    nInflect++;
    iInflect_data[nInflect] = 719;
  }

  if (1 > nPk + 1) {
    nPk = -1;
  }

  k = nPk + 1;
  for (kfirst = 0; kfirst <= nPk; kfirst++) {
    iPk_data_0[kfirst] = (int16_T)iPk_data[kfirst];
  }

  *iPk_size = k;
  for (kfirst = 0; kfirst < k; kfirst++) {
    iPk_data[kfirst] = iPk_data_0[kfirst];
  }

  *iInf_size = 0;
  if (1 > nInflect + 1) {
    nInflect = -1;
  }

  nPk = nInflect + 1;
  for (kfirst = 0; kfirst <= nInflect; kfirst++) {
    iPk_data_0[kfirst] = (int16_T)iInflect_data[kfirst];
  }

  *iInflect_size = nPk;
  for (kfirst = 0; kfirst < nPk; kfirst++) {
    iInflect_data[kfirst] = iPk_data_0[kfirst];
  }
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void SAFI_VCD_removeSmallPeaks(const real_T y[719], const int32_T
  iFinite_data[], const int32_T *iFinite_size, int32_T iPk_data[], int32_T
  *iPk_size, struct fSAFI_VCD* inst)
{
  int32_T nPk;
  int32_T k;
  real_T u0;
  nPk = 0;
  for (k = 0; k < *iFinite_size; k++) {
    u0 = y[iFinite_data[k] - 2];
    if (u0 <= y[iFinite_data[k]]) {
      u0 = y[iFinite_data[k]];
    }

    if (y[iFinite_data[k] - 1] - u0 >= 0.0) {
      nPk++;
      iPk_data[nPk - 1] = iFinite_data[k];
    }
  }

  if (1 > nPk) {
    *iPk_size = 0;
  } else {
    *iPk_size = nPk;
  }
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void SAFI_VCD_do_vectors(const int32_T a_data[], const int32_T *a_size,
  int32_T c_data[], int32_T *c_size, int32_T ia_data[], int32_T *ia_size,
  int32_T *ib_size, struct fSAFI_VCD* inst)
{
  int32_T nc;
  int32_T nia;
  int32_T ialast;
  int32_T b_ialast;
  *c_size = *a_size;
  *ia_size = *a_size;
  *ib_size = 0;
  nc = 0;
  nia = 0;
  for (ialast = 1; ialast <= *a_size; ialast = b_ialast + 1) {
    b_ialast = ialast;
    while ((b_ialast < *a_size) && (a_data[ialast - 1] == a_data[b_ialast])) {
      b_ialast++;
    }

    nc++;
    nia++;
    c_data[nc - 1] = a_data[ialast - 1];
    ia_data[nia - 1] = ialast;
  }

  if (*a_size > 0) {
    if (1 > nia) {
      *ia_size = 0;
    } else {
      *ia_size = nia;
    }

    if (1 > nc) {
      *c_size = 0;
    } else {
      *c_size = nc;
    }
  }
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void findPeaksSeparatedByMoreThanMin(const int32_T *iPk_size, int32_T
  idx_data[], int32_T *idx_size, struct fSAFI_VCD* inst)
{
  int32_T y_data[719];
  int32_T n;
  int32_T yk;
  int32_T k;
  if (*iPk_size < 1) {
    n = 0;
  } else {
    n = *iPk_size;
  }

  if (n > 0) {
    y_data[0] = 1;
    yk = 1;
    for (k = 2; k <= n; k++) {
      yk++;
      y_data[k - 1] = yk;
    }
  }

  *idx_size = n;
  for (yk = 0; yk < n; yk++) {
    idx_data[yk] = y_data[yk];
  }
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void SAFI_VCD_sortIdx(const real_T x_data[], const int32_T *x_size,
  int32_T idx_data[], int32_T *idx_size, struct fSAFI_VCD* inst)
{
  int32_T n;
  int32_T iwork_data[719];
  int32_T k;
  int32_T i;
  int32_T i2;
  int32_T j;
  int32_T pEnd;
  int32_T p;
  int32_T q;
  int32_T qEnd;
  int32_T kEnd;
  int16_T b_idx_0;
  int32_T tmp;
  int32_T tmp_0;
  n = *x_size + 1;
  b_idx_0 = (int16_T)*x_size;
  *idx_size = b_idx_0;
  if (0 <= b_idx_0 - 1) {
    memset(&idx_data[0], 0, b_idx_0 * sizeof(int32_T));
  }

  for (i = 1; i <= n - 2; i += 2) {
    if (x_data[i - 1] >= x_data[i]) {
      idx_data[i - 1] = i;
      idx_data[i] = i + 1;
    } else {
      idx_data[i - 1] = i + 1;
      idx_data[i] = i;
    }
  }

  if ((*x_size & 1U) != 0U) {
    idx_data[*x_size - 1] = *x_size;
  }

  i = 2;
  while (i < n - 1) {
    i2 = i << 1;
    j = 1;
    pEnd = i + 1;
    while (pEnd < n) {
      p = j;
      q = pEnd;
      qEnd = j + i2;
      if (qEnd > n) {
        qEnd = n;
      }

      k = 0;
      kEnd = qEnd - j;
      while (k + 1 <= kEnd) {
        tmp = idx_data[q - 1];
        tmp_0 = idx_data[p - 1];
        if (x_data[tmp_0 - 1] >= x_data[tmp - 1]) {
          iwork_data[k] = tmp_0;
          p++;
          if (p == pEnd) {
            while (q < qEnd) {
              k++;
              iwork_data[k] = idx_data[q - 1];
              q++;
            }
          }
        } else {
          iwork_data[k] = tmp;
          q++;
          if (q == qEnd) {
            while (p < pEnd) {
              k++;
              iwork_data[k] = idx_data[p - 1];
              p++;
            }
          }
        }

        k++;
      }

      for (pEnd = 0; pEnd < kEnd; pEnd++) {
        idx_data[(j + pEnd) - 1] = iwork_data[pEnd];
      }

      j = qEnd;
      pEnd = qEnd + i;
    }

    i = i2;
  }
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void SAFI_VCD_orderPeaks(const real_T Y[719], const int32_T iPk_data[],
  int32_T idx_data[], int32_T *idx_size, rtB_FindVC_SAFI_VCD *localB, struct fSAFI_VCD* inst)
{
  int32_T tmp_data[719];
  int32_T idx_data_0[719];
  int32_T i;
  int32_T tmp_size;
  if (*idx_size != 0) {
    for (i = 0; i < *idx_size; i++) {
      localB->Y_data[i] = Y[iPk_data[idx_data[i] - 1] - 1];
    }

    SAFI_VCD_sortIdx(localB->Y_data, idx_size, tmp_data, &tmp_size, inst);
    for (i = 0; i < tmp_size; i++) {
      idx_data_0[i] = idx_data[tmp_data[i] - 1];
    }

    *idx_size = tmp_size;
    for (i = 0; i < tmp_size; i++) {
      idx_data[i] = idx_data_0[i];
    }
  }
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void SAFI_VCD_assignOutputs(const real_T y[719], const real_T x[719],
  const int32_T iPk_data[], const int32_T *iPk_size, real_T YpkOut_data[],
  int32_T YpkOut_size[2], real_T XpkOut_data[], int32_T XpkOut_size[2], struct fSAFI_VCD* inst)
{
  int32_T i;
  int32_T loop_ub;
  YpkOut_size[0] = 1;
  YpkOut_size[1] = *iPk_size;
  loop_ub = *iPk_size;
  for (i = 0; i < loop_ub; i++) {
    YpkOut_data[i] = y[iPk_data[i] - 1];
  }

  XpkOut_size[0] = 1;
  XpkOut_size[1] = *iPk_size;
  loop_ub = *iPk_size;
  for (i = 0; i < loop_ub; i++) {
    XpkOut_data[i] = x[iPk_data[i] - 1];
  }
}

/* Function for MATLAB Function: '<Root>/FindVC' */
static void SAFI_VCD_findpeaks(const real_T Yin[719], real_T Ypk_data[], int32_T
  Ypk_size[2], real_T Xpk_data[], int32_T Xpk_size[2], rtB_FindVC_SAFI_VCD
  *localB, struct fSAFI_VCD* inst)
{
  int32_T idx_data[719];
  int32_T iFinite_data[719];
  int32_T tmp_data[719];
  int32_T idx_size;
  int32_T iFinite_size;
  int32_T iInfinite_size;
  int32_T ib_size;
  SAFI_VCD_getAllPeaksCodegen(Yin, iFinite_data, &iFinite_size, &iInfinite_size,
    idx_data, &idx_size, inst);
  SAFI_VCD_removeSmallPeaks(Yin, iFinite_data, &iFinite_size, tmp_data,
    &iInfinite_size, inst);
  SAFI_VCD_do_vectors(tmp_data, &iInfinite_size, iFinite_data, &iFinite_size,
                      idx_data, &idx_size, &ib_size, inst);
  findPeaksSeparatedByMoreThanMin(&iFinite_size, idx_data, &idx_size, inst);
  SAFI_VCD_orderPeaks(Yin, iFinite_data, idx_data, &idx_size, localB, inst);
  if (idx_size > 2) {
    idx_size = 2;
  }

  for (iFinite_size = 0; iFinite_size < 719; iFinite_size++) {
    localB->dv1[iFinite_size] = (real_T)iFinite_size + 1.0;
  }

  for (iFinite_size = 0; iFinite_size < idx_size; iFinite_size++) {
    tmp_data[iFinite_size] = iFinite_data[idx_data[iFinite_size] - 1];
  }

  SAFI_VCD_assignOutputs(Yin, localB->dv1, tmp_data, &idx_size, Ypk_data,
    Ypk_size, Xpk_data, Xpk_size, inst);
}

real_T rt_roundd(real_T u, struct fSAFI_VCD* inst)
{
  real_T y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

/* Output and update for atomic system: '<Root>/FindVC' */
void SAFI_VCD_FindVC(uint16_T rtu_VC_in, uint16_T rtu_WinStart, boolean_T
                     rtu_bReset, real32_T rtu_StdLim, rtB_FindVC_SAFI_VCD
                     *localB, rtDW_FindVC_SAFI_VCD *localDW, struct fSAFI_VCD* inst)
{
  real32_T StdVC;
  int32_T i;
  int32_T VCpeaks_size[2];
  int32_T IdxVCpeaks_size[2];
  real_T tmp;
  uint32_T tmp_0;
  uint32_T tmp_1;

  /* MATLAB Function 'FindVC': '<S3>:1' */
  /* '<S3>:1:3' */
  localB->VC_out = 0U;
  localB->VC_out_perc = 0U;
  localB->VC_2ndPeak = 0U;
  localB->VC_2ndPeak_perc = 0U;
  StdVC = 0.0F;
  if ((!localDW->idx_not_empty) || rtu_bReset) {
    localDW->idx = 1U;
    localDW->idx_not_empty = true;
  }

  if ((!localDW->VecVC_not_empty) || rtu_bReset) {
    for (i = 0; i < 100; i++) {
      localDW->VecVC[i] = 0.0F;
    }

    localDW->VecVC_not_empty = true;
  }

  tmp_1 = rtu_WinStart + 5U;
  tmp_0 = tmp_1;
  if (tmp_1 > 65535U) {
    tmp_0 = 65535U;
  }

  if (rtu_VC_in > (int32_T)tmp_0) {
    localDW->VecVC[localDW->idx - 1] = rtu_VC_in;
    tmp_0 = localDW->idx + 1U;
    if (tmp_0 > 65535U) {
      tmp_0 = 65535U;
    }

    localDW->idx = (uint16_T)tmp_0;
    if (localDW->idx > 100) {
      localDW->idx = 1U;
    }
  }

  if (SAFI_VCD_all(localDW->VecVC, inst)) {
    StdVC = SAFI_VCD_std(localDW->VecVC, inst);
    SAFI_VCD_histcounts(localDW->VecVC, localB->dv, inst);
    SAFI_VCD_findpeaks(localB->dv, localB->VCpeaks_data, VCpeaks_size,
                       localB->IdxVCpeaks_data, IdxVCpeaks_size, localB, inst);
    if (StdVC <= rtu_StdLim) {
      tmp = rt_roundd(localB->IdxVCpeaks_data[0], inst);
      if (tmp < 65536.0) {
        if (tmp >= 0.0) {
          localB->VC_out = (uint16_T)tmp;
        } else {
          localB->VC_out = 0U;
        }
      } else {
        localB->VC_out = MAX_uint16_T;
      }

      tmp = rt_roundd(localB->VCpeaks_data[0] / 100.0 * 100.0, inst);
      if (tmp < 65536.0) {
        if (tmp >= 0.0) {
          localB->VC_out_perc = (uint16_T)tmp;
        } else {
          localB->VC_out_perc = 0U;
        }
      } else {
        localB->VC_out_perc = MAX_uint16_T;
      }
    }

    if (VCpeaks_size[1] > 1) {
      if (tmp_1 > 65535U) {
        tmp_1 = 65535U;
      }

      if (localB->IdxVCpeaks_data[1] >= tmp_1) {
        tmp = rt_roundd(localB->IdxVCpeaks_data[1], inst);
        if (tmp < 65536.0) {
          if (tmp >= 0.0) {
            localB->VC_2ndPeak = (uint16_T)tmp;
          } else {
            localB->VC_2ndPeak = 0U;
          }
        } else {
          localB->VC_2ndPeak = MAX_uint16_T;
        }

        tmp = rt_roundd(localB->VCpeaks_data[1] / 100.0 * 100.0, inst);
        if (tmp < 65536.0) {
          if (tmp >= 0.0) {
            localB->VC_2ndPeak_perc = (uint16_T)tmp;
          } else {
            localB->VC_2ndPeak_perc = 0U;
          }
        } else {
          localB->VC_2ndPeak_perc = MAX_uint16_T;
        }
      }
    }
  }

  /* '<S3>:1:3' */
  localB->StdVC_Dbg = StdVC;

  /* '<S3>:1:3' */
}

/* Model step function */
void SAFI_VCD_step(RT_MODEL_SAFI_VCD *const SAFI_VCD_M, struct fSAFI_VCD* inst)
{
  struct BlockIO_SAFI_VCD *SAFI_VCD_B = ((struct BlockIO_SAFI_VCD *) SAFI_VCD_M->blockIO);
  struct D_Work_SAFI_VCD *SAFI_VCD_DWork = ((struct D_Work_SAFI_VCD *) SAFI_VCD_M->dwork);
  ExternalOutputs_SAFI_VCD *SAFI_VCD_Y = (ExternalOutputs_SAFI_VCD *)
    SAFI_VCD_M->outputs;
  boolean_T rtb_LogicalOperator5;
  boolean_T rtb_LogicalOperator1;
  int16_T rtb_Subtract1;
  uint16_T rtb_Subtract1_0;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  SAFI_VCD_B->BusInput2 = inst->In;

  /* S-Function (bur_bus_in): '<Root>/Bus Input3' */
  SAFI_VCD_B->BusInput3 = inst->Para;

  /* MATLAB Function: '<Root>/FindVC' incorporates:
   *  Switch: '<S1>/Environment Switch'
   *  Switch: '<S2>/Environment Switch'
   */
  SAFI_VCD_FindVC(SAFI_VCD_B->BusInput2.VC_in, SAFI_VCD_B->BusInput2.WinStart,
                  SAFI_VCD_B->BusInput2.bReset, SAFI_VCD_B->BusInput3.StdLim,
                  &SAFI_VCD_B->sf_FindVC, &SAFI_VCD_DWork->sf_FindVC, inst);

  /* Logic: '<Root>/Logical Operator5' incorporates:
   *  RelationalOperator: '<Root>/Relational Operator5'
   *  RelationalOperator: '<Root>/Relational Operator6'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_LogicalOperator5 = ((SAFI_VCD_B->sf_FindVC.VC_out_perc >=
    SAFI_VCD_B->BusInput3.iPeakPercLim) && (0 != SAFI_VCD_B->sf_FindVC.VC_out));

  /* Logic: '<Root>/Logical Operator1' incorporates:
   *  RelationalOperator: '<Root>/Relational Operator4'
   *  RelationalOperator: '<Root>/Relational Operator7'
   *  Switch: '<S2>/Environment Switch'
   */
  rtb_LogicalOperator1 = ((SAFI_VCD_B->sf_FindVC.VC_2ndPeak != 0) &&
    (SAFI_VCD_B->sf_FindVC.VC_2ndPeak_perc >= SAFI_VCD_B->BusInput3.iPeakPercLim));

  /* Sum: '<Root>/Subtract1' */
  rtb_Subtract1 = (int16_T)((int16_T)SAFI_VCD_B->sf_FindVC.VC_out - (int16_T)
    SAFI_VCD_B->sf_FindVC.VC_2ndPeak);

  /* BusCreator: '<Root>/Bus Creator3' incorporates:
   *  Outport: '<Root>/Out'
   */
  SAFI_VCD_Y->Out.VC_out = SAFI_VCD_B->sf_FindVC.VC_out;

  /* Abs: '<Root>/Abs1' */
  if (rtb_Subtract1 < 0) {
    rtb_Subtract1_0 = (uint16_T)-rtb_Subtract1;
  } else {
    rtb_Subtract1_0 = (uint16_T)rtb_Subtract1;
  }

  /* End of Abs: '<Root>/Abs1' */

  /* BusCreator: '<Root>/Bus Creator3' incorporates:
   *  Logic: '<Root>/Logical Operator'
   *  Logic: '<Root>/Logical Operator2'
   *  Logic: '<Root>/Logical Operator3'
   *  Logic: '<Root>/Logical Operator4'
   *  Outport: '<Root>/Out'
   *  RelationalOperator: '<Root>/Relational Operator1'
   *  RelationalOperator: '<Root>/Relational Operator2'
   *  RelationalOperator: '<Root>/Relational Operator3'
   *  Switch: '<S2>/Environment Switch'
   */
  SAFI_VCD_Y->Out.bUnbalance = ((rtb_LogicalOperator5 &&
    (SAFI_VCD_B->sf_FindVC.VC_out <= SAFI_VCD_B->BusInput3.iEarlyClosureLim)) ||
    ((SAFI_VCD_B->sf_FindVC.VC_2ndPeak <= SAFI_VCD_B->BusInput3.iEarlyClosureLim)
     && rtb_LogicalOperator1) || (rtb_LogicalOperator5 && rtb_LogicalOperator1 &&
    (rtb_Subtract1_0 >= SAFI_VCD_B->BusInput3.iDistanceLim)));

  /* BusCreator: '<Root>/Bus Creator1' incorporates:
   *  Outport: '<Root>/Out1'
   */
  SAFI_VCD_Y->Out1.StdVC_Dbg = SAFI_VCD_B->sf_FindVC.StdVC_Dbg;
  SAFI_VCD_Y->Out1.iVC_out_perc = SAFI_VCD_B->sf_FindVC.VC_out_perc;
  SAFI_VCD_Y->Out1.iVC_2ndPeak = SAFI_VCD_B->sf_FindVC.VC_2ndPeak;
  SAFI_VCD_Y->Out1.iVC_2ndPeak_perc = SAFI_VCD_B->sf_FindVC.VC_2ndPeak_perc;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' incorporates:
   *  Outport: '<Root>/Out1'
   */
  inst->dbg = SAFI_VCD_Y->Out1;

  /* S-Function (bur_bus_out): '<Root>/Bus Output2' incorporates:
   *  Outport: '<Root>/Out'
   */
  inst->Out = SAFI_VCD_Y->Out;

  /* UnitDelay: '<S4>/Unit Delay' */
  SAFI_VCD_B->UnitDelay = SAFI_VCD_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->Version = SAFI_VCD_B->UnitDelay;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  SAFI_VCD_DWork->UnitDelay_DSTATE = 104U;
}

/* Model initialize function */
void SAFI_VCD_initialize(RT_MODEL_SAFI_VCD *const SAFI_VCD_M, struct fSAFI_VCD* inst)
{
  /* (no initialization code required) */
  UNUSED_PARAMETER(SAFI_VCD_M);
}

/* Model terminate function */
void SAFI_VCD_terminate(RT_MODEL_SAFI_VCD *const SAFI_VCD_M, struct fSAFI_VCD* inst)
{
  /* (no terminate code required) */
  UNUSED_PARAMETER(SAFI_VCD_M);
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
 * signal_toolbox                                                             *
 * simulink                                                                   *
 *============================================================================*/
