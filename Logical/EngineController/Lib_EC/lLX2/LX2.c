/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LX2
 * File: LX2.c
 * Author: 212566120
 * Created: Wed Apr 11 13:34:17 2018
 ********************************************************************
 * Implementation of program LX2
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "LX2.h"
#include "LX2_private.h"

/*  Defines */
#define LX2_POS_ZCSIG                  ((uint8_T)1U)
#define LX2_UNINITIALIZED_ZCSIG        ((uint8_T)3U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */
struct BlockIO_LX2 LX2_B;

/* Block states (auto storage) */
struct D_Work_LX2 LX2_DWork;

/* Previous zero-crossings (trigger) states */
struct PrevZCSigStates_LX2 LX2_PrevZCSigState;

/* External inputs (root inport signals with auto storage) */
ExternalInputs_LX2 LX2_U;

/* External outputs (root outports fed by signals with auto storage) */
ExternalOutputs_LX2 LX2_Y;

/* Real-time model */
RT_MODEL_LX2 LX2_M_;
RT_MODEL_LX2 *const LX2_M = &LX2_M_;

/*  Declarations  */

/* Forward declaration for local functions */
static void LX2_my_split(real32_T x, real32_T *b_y1, real32_T *y2, struct fLX2* inst);
static void LX2_my_detect(real32_T x, real32_T *x1, real32_T *x2, struct fLX2* inst);
static real32_T LX2_my_split_i(real32_T x, struct fLX2* inst);
static void LX2_my_find(const real32_T V[11], real_T LowerLimit, real32_T
  UpperLimit, real_T p[11], struct fLX2* inst);
static void LX2_my_find_e(const real32_T V[11], real_T LowerLimit, real32_T
  UpperLimit, real_T p[11], struct fLX2* inst);
static void LX2_my_find_ex(const real32_T V[11], real32_T LowerLimit, real32_T
  UpperLimit, real_T p[11], struct fLX2* inst);
static void LX2_my_find_exl(const real32_T V[11], real32_T LowerLimit, real32_T
  UpperLimit, real_T p[11], struct fLX2* inst);
static void LX2_my_find_exlq(const real32_T V[11], real32_T LowerLimit, real_T
  UpperLimit, real_T p[11], struct fLX2* inst);
static void LX2_my_find_exlqw(const real32_T V[11], real32_T LowerLimit, real_T
  UpperLimit, real_T p[11], struct fLX2* inst);
static void LX2_my_find_exlqwy(const real32_T V[11], real_T p[11], struct fLX2* inst);
static real32_T LX2_sum(const real32_T x[11], struct fLX2* inst);
static void LX2_my_smoothing(const real32_T Pl[2], real32_T Pm[2], const
  real32_T Pr[2], real32_T slope_max, struct fLX2* inst);
static void LX2_interp1(const real32_T varargin_1[3], const real32_T varargin_2
  [3], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static void LX2_interp1_o(const real32_T varargin_1[4], const real32_T
  varargin_2[4], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static void LX2_interp1_o5pn4ly1(const real32_T varargin_1[11], const real32_T
  varargin_2[11], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static void LX2_interp1_o5(const real32_T varargin_1[5], const real32_T
  varargin_2[5], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static void LX2_interp1_o5p(const real32_T varargin_1[6], const real32_T
  varargin_2[6], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static void LX2_interp1_o5pn(const real32_T varargin_1[7], const real32_T
  varargin_2[7], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static real32_T LX2_interp1_o5pn4ly1e(const real32_T varargin_1[2], const
  real32_T varargin_2[2], real32_T varargin_3, struct fLX2* inst);
static void LX2_interp1_o5pn4(const real32_T varargin_1[8], const real32_T
  varargin_2[8], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static void LX2_interp1_o5pn4l(const real32_T varargin_1[9], const real32_T
  varargin_2[9], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static void LX2_interp1_o5pn4ly(const real32_T varargin_1[10], const real32_T
  varargin_2[10], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst);
static void LX2_rdivide(const real32_T x[4], real_T y, real32_T z[4], struct fLX2* inst);

/* Forward declaration for local functions */
static void LX2_my_BPOC_enable_h(const real32_T splitfactor[4], boolean_T
  bLX2_enable, const real32_T rThreshold_save2map[2], boolean_T
  bExt_BPOC_learning_Stop, boolean_T bBPOC_enable[4], boolean_T
  bSave_BPOC_enable[4], struct fLX2* inst);
static void LX2_my_BPOC_enable(const real32_T splitfactor[4], boolean_T
  bLX2_enable, const real32_T rThreshold_save2map[2], boolean_T
  bExt_BPOC_learning_Stop, boolean_T bBPOC_enable[4], boolean_T
  bSave_BPOC_enable[4], struct fLX2* inst);
static void LX2_my_gasmixing(uint16_T iIdx_Gtyp_Dem, real32_T rGT_QualMix_1_2,
  real32_T rGT_RatioMix, boolean_T bLX2_enable, const real32_T
  rThreshold_save2map[2], boolean_T bExt_BPOC_learning_Stop, real32_T
  splitfactor_Gas[4], boolean_T bBPOC_enable[4], boolean_T bSave_BPOC_enable[4], struct fLX2* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_real32_T */
void BINARYSEARCH_real32_T(uint32_T *piLeft, uint32_T *piRght, real32_T u, const
  real32_T *pData, uint32_T iHi, struct fLX2* inst)
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
  const real32_T *pUData, uint32_T iHi, struct fLX2* inst)
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
      den = den - pUData[iLeft];
      num = u;
      num = num - pUData[iLeft];
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

real32_T rt_roundf(real32_T u, struct fLX2* inst)
{
  real32_T y;
  if ((real32_T)fabs(u) < 8.388608E+6F) {
    if (u >= 0.5F) {
      y = (real32_T)floor(u + 0.5F);
    } else if (u > -0.5F) {
      y = 0.0F;
    } else {
      y = (real32_T)ceil(u - 0.5F);
    }
  } else {
    y = u;
  }

  return y;
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_split(real32_T x, real32_T *b_y1, real32_T *y2, struct fLX2* inst)
{
  real32_T t;

  /*  End od 'my_detect-function' */
  /*  ---------------------------------------------------------------------------------- */
  /* % my_split function */
  /* ************************************************************************** */
  /*  divides new measurement value up to neighborhood node points via leverage function */
  /*  */
  /*  Input:    x   ... Engine Power [%] */
  /*  Output:   y1  ... weighting of node left from x [-] */
  /*                  y2  ... weighting of node right from x [-] */
  /* ************************************************************************** */
  t = rt_roundf(x / 10.0F, inst) * 10.0F;

  /*  temporary var for decision and find neighborhood point */
  if (x < t) {
    /*  slope between the two neighboring points is positive */
    t -= x;
    *y2 = 1.0F - t / 10.0F;

    /*  weighting of node right from x */
    *b_y1 = 1.0F - (1.0F - t / 10.0F);

    /*  weighting of node left from x */
  } else if (x > t) {
    /*  slope between the two neighboring points is negative */
    t = x - t;
    *b_y1 = 1.0F - t / 10.0F;

    /*  weighting of node left from x */
    *y2 = 1.0F - (1.0F - t / 10.0F);

    /*  weighting of node right from x */
  } else if ((x == t) && (x != 100.0F)) {
    /*  x is exactly on node point; weighting factor is 1 */
    *b_y1 = 1.0F;
    *y2 = 0.0F;
  } else {
    /*  x is 100 */
    *b_y1 = 0.0F;
    *y2 = 1.0F;
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_detect(real32_T x, real32_T *x1, real32_T *x2, struct fLX2* inst)
{
  /*  End od 'BPOC.m' */
  /*  ---------------------------------------------------------------------------------- */
  /* % my_detect function */
  /* ************************************************************************** */
  /*  returns indices of affected node points due to new measurement value */
  /*  */
  /*  Input:    x   ... Engine Power [%] */
  /*  Output:   x1  ... index of left neighbouring node point [-] */
  /*                  x2  ... index of right neighbouring node point [-] */
  /* ************************************************************************** */
  if (!(x - (real32_T)floor(x / 2.0F) * 2.0F != 0.0F)) {
    /*  if x is exaclty on node -> manipulate x value with a super small value so that it is not lying on node anymore ;-) */
    x += 0.001F;
  }

  if (x <= 0.0F) {
    /*  input is limited to positive values  */
    *x1 = 1.0F;
    *x2 = 2.0F;
  } else if (x >= 100.0F) {
    /*  input is limited to values smaller than 100 (full load) */
    *x1 = 10.0F;
    *x2 = 11.0F;
  } else {
    *x1 = (real32_T)ceil(x / 10.0F);
    *x2 = *x1 + 1.0F;
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static real32_T LX2_my_split_i(real32_T x, struct fLX2* inst)
{
  real32_T b_y1;
  real32_T t;

  /*  End od 'my_detect-function' */
  /*  ---------------------------------------------------------------------------------- */
  /* % my_split function */
  /* ************************************************************************** */
  /*  divides new measurement value up to neighborhood node points via leverage function */
  /*  */
  /*  Input:    x   ... Engine Power [%] */
  /*  Output:   y1  ... weighting of node left from x [-] */
  /*                  y2  ... weighting of node right from x [-] */
  /* ************************************************************************** */
  t = rt_roundf(x / 10.0F, inst) * 10.0F;

  /*  temporary var for decision and find neighborhood point */
  if (x < t) {
    /*  slope between the two neighboring points is positive */
    /*  weighting of node right from x */
    b_y1 = 1.0F - (1.0F - (t - x) / 10.0F);

    /*  weighting of node left from x */
  } else if (x > t) {
    /*  slope between the two neighboring points is negative */
    b_y1 = 1.0F - (x - t) / 10.0F;

    /*  weighting of node left from x */
    /*  weighting of node right from x */
  } else if ((x == t) && (x != 100.0F)) {
    /*  x is exactly on node point; weighting factor is 1 */
    b_y1 = 1.0F;
  } else {
    /*  x is 100 */
    b_y1 = 0.0F;
  }

  return b_y1;
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_find(const real32_T V[11], real_T LowerLimit, real32_T
  UpperLimit, real_T p[11], struct fLX2* inst)
{
  real32_T i;
  int32_T b_i;
  int32_T b;
  int32_T i_0;

  /*  end of 'my_smoothing-function' */
  /* ---------------------------------------------------------------------------------- */
  /* % my_find */
  /* ************************************************************************** */
  /*  returns indices of already measured points depending on 'mode' and 'Limits' */
  /*  */
  /*  Input:    V                   ... binary map (vector, 11 elements, boolean) */
  /*                LowerLimit   ... lower search boundary (scalar) */
  /*                UpperLimit   ... upper search boundary (scalar) */
  /*                mode            ... 'first' -> returns first 2 indices */
  /*                                      ... 'last' -> returns last 2 indices */
  /*                                      ... 'all' -> returns all found indices */
  /*  */
  /*  Output: Pm	...	middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /* ************************************************************************** */
  for (i_0 = 0; i_0 < 11; i_0++) {
    p[i_0] = 0.0;
  }

  /*  fixed allocated vector for saving indices */
  /*  -> function will return indices of first two elements which were found */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded */
  i_0 = 0;
  b = (int32_T)((1.0F - (real32_T)LowerLimit) + UpperLimit);
  for (b_i = 0; b_i < b; b_i++) {
    i = (real32_T)LowerLimit + (real32_T)b_i;
    if ((V[(int32_T)i - 1] != 0.0F) && (i_0 < 2)) {
      p[i_0] = i;
      i_0++;
    }
  }

  /*  -> function will return indices of last two elements which were found        */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded   */
  /*  end 'if-function' */
  /*  end of 'my_find-function'  */
  /* ---------------------------------------------------------------------------------- */
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_find_e(const real32_T V[11], real_T LowerLimit, real32_T
  UpperLimit, real_T p[11], struct fLX2* inst)
{
  real32_T i;
  int32_T b_i;
  int32_T b;
  int32_T i_0;

  /*  end of 'my_smoothing-function' */
  /* ---------------------------------------------------------------------------------- */
  /* % my_find */
  /* ************************************************************************** */
  /*  returns indices of already measured points depending on 'mode' and 'Limits' */
  /*  */
  /*  Input:    V                   ... binary map (vector, 11 elements, boolean) */
  /*                LowerLimit   ... lower search boundary (scalar) */
  /*                UpperLimit   ... upper search boundary (scalar) */
  /*                mode            ... 'first' -> returns first 2 indices */
  /*                                      ... 'last' -> returns last 2 indices */
  /*                                      ... 'all' -> returns all found indices */
  /*  */
  /*  Output: Pm	...	middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /* ************************************************************************** */
  for (i_0 = 0; i_0 < 11; i_0++) {
    p[i_0] = 0.0;
  }

  /*  fixed allocated vector for saving indices */
  /*  -> function will return indices of first two elements which were found */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded */
  i_0 = 2;
  b = (int32_T)-((-1.0F - UpperLimit) + (real32_T)LowerLimit);
  for (b_i = 0; b_i < b; b_i++) {
    i = UpperLimit + -(real32_T)b_i;
    if ((V[(int32_T)i - 1] != 0.0F) && (i_0 > 0)) {
      p[i_0 - 1] = i;
      i_0--;
    }
  }

  /*  -> function will return all indices which were found - used for smoothing-function and interpolation of all points */
  /*  -> loop writes values into p from end to start of vector - smoothing-function need this order */
  /*  end 'if-function' */
  /*  end of 'my_find-function'  */
  /* ---------------------------------------------------------------------------------- */
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_find_ex(const real32_T V[11], real32_T LowerLimit, real32_T
  UpperLimit, real_T p[11], struct fLX2* inst)
{
  real32_T i;
  int32_T b_i;
  int32_T b;
  int32_T i_0;

  /*  end of 'my_smoothing-function' */
  /* ---------------------------------------------------------------------------------- */
  /* % my_find */
  /* ************************************************************************** */
  /*  returns indices of already measured points depending on 'mode' and 'Limits' */
  /*  */
  /*  Input:    V                   ... binary map (vector, 11 elements, boolean) */
  /*                LowerLimit   ... lower search boundary (scalar) */
  /*                UpperLimit   ... upper search boundary (scalar) */
  /*                mode            ... 'first' -> returns first 2 indices */
  /*                                      ... 'last' -> returns last 2 indices */
  /*                                      ... 'all' -> returns all found indices */
  /*  */
  /*  Output: Pm	...	middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /* ************************************************************************** */
  for (i_0 = 0; i_0 < 11; i_0++) {
    p[i_0] = 0.0;
  }

  /*  fixed allocated vector for saving indices */
  /*  -> function will return indices of first two elements which were found */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded */
  i_0 = 0;
  b = (int32_T)((1.0F - LowerLimit) + UpperLimit);
  for (b_i = 0; b_i < b; b_i++) {
    i = LowerLimit + (real32_T)b_i;
    if ((V[(int32_T)i - 1] != 0.0F) && (i_0 < 2)) {
      p[i_0] = i;
      i_0++;
    }
  }

  /*  -> function will return indices of last two elements which were found        */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded   */
  /*  end 'if-function' */
  /*  end of 'my_find-function'  */
  /* ---------------------------------------------------------------------------------- */
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_find_exl(const real32_T V[11], real32_T LowerLimit, real32_T
  UpperLimit, real_T p[11], struct fLX2* inst)
{
  real32_T i;
  int32_T b_i;
  int32_T b;
  int32_T i_0;

  /*  end of 'my_smoothing-function' */
  /* ---------------------------------------------------------------------------------- */
  /* % my_find */
  /* ************************************************************************** */
  /*  returns indices of already measured points depending on 'mode' and 'Limits' */
  /*  */
  /*  Input:    V                   ... binary map (vector, 11 elements, boolean) */
  /*                LowerLimit   ... lower search boundary (scalar) */
  /*                UpperLimit   ... upper search boundary (scalar) */
  /*                mode            ... 'first' -> returns first 2 indices */
  /*                                      ... 'last' -> returns last 2 indices */
  /*                                      ... 'all' -> returns all found indices */
  /*  */
  /*  Output: Pm	...	middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /* ************************************************************************** */
  for (i_0 = 0; i_0 < 11; i_0++) {
    p[i_0] = 0.0;
  }

  /*  fixed allocated vector for saving indices */
  /*  -> function will return indices of first two elements which were found */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded */
  i_0 = 2;
  b = (int32_T)-((-1.0F - UpperLimit) + LowerLimit);
  for (b_i = 0; b_i < b; b_i++) {
    i = UpperLimit + -(real32_T)b_i;
    if ((V[(int32_T)i - 1] != 0.0F) && (i_0 > 0)) {
      p[i_0 - 1] = i;
      i_0--;
    }
  }

  /*  -> function will return all indices which were found - used for smoothing-function and interpolation of all points */
  /*  -> loop writes values into p from end to start of vector - smoothing-function need this order */
  /*  end 'if-function' */
  /*  end of 'my_find-function'  */
  /* ---------------------------------------------------------------------------------- */
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_find_exlq(const real32_T V[11], real32_T LowerLimit, real_T
  UpperLimit, real_T p[11], struct fLX2* inst)
{
  real32_T i;
  int32_T b_i;
  int32_T b;
  int32_T i_0;

  /*  end of 'my_smoothing-function' */
  /* ---------------------------------------------------------------------------------- */
  /* % my_find */
  /* ************************************************************************** */
  /*  returns indices of already measured points depending on 'mode' and 'Limits' */
  /*  */
  /*  Input:    V                   ... binary map (vector, 11 elements, boolean) */
  /*                LowerLimit   ... lower search boundary (scalar) */
  /*                UpperLimit   ... upper search boundary (scalar) */
  /*                mode            ... 'first' -> returns first 2 indices */
  /*                                      ... 'last' -> returns last 2 indices */
  /*                                      ... 'all' -> returns all found indices */
  /*  */
  /*  Output: Pm	...	middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /* ************************************************************************** */
  for (i_0 = 0; i_0 < 11; i_0++) {
    p[i_0] = 0.0;
  }

  /*  fixed allocated vector for saving indices */
  /*  -> function will return indices of first two elements which were found */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded */
  i_0 = 0;
  b = (int32_T)((1.0F - LowerLimit) + (real32_T)UpperLimit);
  for (b_i = 0; b_i < b; b_i++) {
    i = LowerLimit + (real32_T)b_i;
    if ((V[(int32_T)i - 1] != 0.0F) && (i_0 < 2)) {
      p[i_0] = i;
      i_0++;
    }
  }

  /*  -> function will return indices of last two elements which were found        */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded   */
  /*  end 'if-function' */
  /*  end of 'my_find-function'  */
  /* ---------------------------------------------------------------------------------- */
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_find_exlqw(const real32_T V[11], real32_T LowerLimit, real_T
  UpperLimit, real_T p[11], struct fLX2* inst)
{
  real32_T i;
  int32_T b_i;
  int32_T b;
  int32_T i_0;

  /*  end of 'my_smoothing-function' */
  /* ---------------------------------------------------------------------------------- */
  /* % my_find */
  /* ************************************************************************** */
  /*  returns indices of already measured points depending on 'mode' and 'Limits' */
  /*  */
  /*  Input:    V                   ... binary map (vector, 11 elements, boolean) */
  /*                LowerLimit   ... lower search boundary (scalar) */
  /*                UpperLimit   ... upper search boundary (scalar) */
  /*                mode            ... 'first' -> returns first 2 indices */
  /*                                      ... 'last' -> returns last 2 indices */
  /*                                      ... 'all' -> returns all found indices */
  /*  */
  /*  Output: Pm	...	middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /* ************************************************************************** */
  for (i_0 = 0; i_0 < 11; i_0++) {
    p[i_0] = 0.0;
  }

  /*  fixed allocated vector for saving indices */
  /*  -> function will return indices of first two elements which were found */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded */
  i_0 = 2;
  b = (int32_T)-((-1.0F - (real32_T)UpperLimit) + LowerLimit);
  for (b_i = 0; b_i < b; b_i++) {
    i = (real32_T)UpperLimit + -(real32_T)b_i;
    if ((V[(int32_T)i - 1] != 0.0F) && (i_0 > 0)) {
      p[i_0 - 1] = i;
      i_0--;
    }
  }

  /*  -> function will return all indices which were found - used for smoothing-function and interpolation of all points */
  /*  -> loop writes values into p from end to start of vector - smoothing-function need this order */
  /*  end 'if-function' */
  /*  end of 'my_find-function'  */
  /* ---------------------------------------------------------------------------------- */
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_find_exlqwy(const real32_T V[11], real_T p[11], struct fLX2* inst)
{
  real_T j;
  int32_T i;

  /*  end of 'my_smoothing-function' */
  /* ---------------------------------------------------------------------------------- */
  /* % my_find */
  /* ************************************************************************** */
  /*  returns indices of already measured points depending on 'mode' and 'Limits' */
  /*  */
  /*  Input:    V                   ... binary map (vector, 11 elements, boolean) */
  /*                LowerLimit   ... lower search boundary (scalar) */
  /*                UpperLimit   ... upper search boundary (scalar) */
  /*                mode            ... 'first' -> returns first 2 indices */
  /*                                      ... 'last' -> returns last 2 indices */
  /*                                      ... 'all' -> returns all found indices */
  /*  */
  /*  Output: Pm	...	middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /* ************************************************************************** */
  for (i = 0; i < 11; i++) {
    p[i] = 0.0;
  }

  /*  fixed allocated vector for saving indices */
  /*  -> function will return indices of first two elements which were found */
  /*  -> always write 2 values to p - no need for more, thats why 2=hard coded */
  j = 11.0;
  for (i = 0; i < 11; i++) {
    if (V[10 - i] != 0.0F) {
      p[(int32_T)j - 1] = 11.0 + -(real_T)i;
      j--;
    }
  }

  /*  end 'if-function' */
  /*  end of 'my_find-function'  */
  /* ---------------------------------------------------------------------------------- */
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static real32_T LX2_sum(const real32_T x[11], struct fLX2* inst)
{
  real32_T y;
  int32_T k;
  y = x[0];
  for (k = 0; k < 10; k++) {
    y += x[k + 1];
  }

  return y;
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_my_smoothing(const real32_T Pl[2], real32_T Pm[2], const
  real32_T Pr[2], real32_T slope_max, struct fLX2* inst)
{
  real32_T Pmr_max;
  real32_T Pmr_min;
  real32_T Pml_max;
  real32_T Pml_min;

  /*  End of 'my_split-function' */
  /* ---------------------------------------------------------------------------------- */
  /* % my_smoothing function */
  /* ************************************************************************** */
  /*  returns new delta_p2s at Pm, if one of the slopes of the triangel is */
  /*  greater than slope_max */
  /*  */
  /*  Input:    Pl      ... left point of triangle (vector, 2 elements, Pl(1)->[%], Pl(2)->[mbar]) */
  /*                Pm    ... middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /*                Pr      ... right point of triangle (vector, 2 elements, Pr(1)->[%], Pr(2)->[mbar]) */
  /*                slope_max   ... max. slope within triangle [mbar/%-Engine Power] */
  /*  */
  /*  Output: Pm	...	middle point of triangle  (vector, 2 elements, Pm(1)->[%], Pm(2)->[mbar]) */
  /* ************************************************************************** */
  /*  calc slope right */
  /*  calc slope left */
  if (((real32_T)fabs((Pr[1] - Pm[1]) / (Pr[0] - Pm[0])) > slope_max) ||
      ((real32_T)fabs((Pm[1] - Pl[1]) / (Pm[0] - Pl[0])) > slope_max)) {
    /*  one of the slopes are not within the limit */
    Pmr_max = (Pr[0] - Pm[0]) * slope_max + Pr[1];

    /*  max. allowed value for Pm depending on Pr */
    Pmr_min = Pr[1] - (Pr[0] - Pm[0]) * slope_max;

    /*  min. value allowed for Pm depending on Pr */
    Pml_max = (Pm[0] - Pl[0]) * slope_max + Pl[1];

    /*  max. value allowed for Pm depending on Pl */
    Pml_min = Pl[1] - (Pm[0] - Pl[0]) * slope_max;

    /*  min. value allowed for Pm depending on Pl */
    /*  make Pm to Pm_new   */
    if ((Pmr_max >= Pml_max) && (Pmr_min <= Pml_min) && (Pr[0] - Pm[0] > Pm[0] -
         Pl[0])) {
      /*  bigger right area contains left area */
      if (Pm[1] >= Pml_max) {
        Pm[1] = Pml_max;
      } else {
        if (Pm[1] <= Pml_min) {
          Pm[1] = Pml_min;
        }
      }
    } else if ((Pml_max >= Pmr_max) && (Pml_min <= Pmr_min) && (Pm[0] - Pl[0] >
                Pr[0] - Pm[0])) {
      /*  bigger left area contains right area */
      if (Pm[1] >= Pmr_max) {
        Pm[1] = Pmr_max;
      } else {
        if (Pm[1] <= Pmr_min) {
          Pm[1] = Pmr_min;
        }
      }
    } else if ((Pmr_max <= Pml_max) && (Pmr_max >= Pml_min)) {
      /*  required slope can be reached by changing Pm to the closest value in the overlap area */
      if (Pm[1] >= Pmr_max) {
        Pm[1] = Pmr_max;
      } else {
        if (Pm[1] <= Pml_min) {
          Pm[1] = Pml_min;
        }
      }
    } else if ((Pmr_min >= Pml_min) && (Pmr_min <= Pml_max)) {
      /*  required slope can be reached by changing Pm to the closest value in the overlap area */
      if (Pm[1] >= Pml_max) {
        Pm[1] = Pml_max;
      } else {
        if (Pm[1] <= Pmr_min) {
          Pm[1] = Pmr_min;
        }
      }
    } else if (Pmr_max < Pml_min) {
      /*  required slope cannot be reached by changing Pm in pos. direction -> right slope of triange is set to slope_max */
      Pm[1] = Pmr_max;
    } else {
      if (Pmr_min > Pml_max) {
        /*  required slope cannot be reached by changing Pm in neg. direction -> right slope of triange is set to slope_max */
        Pm[1] = Pmr_min;
      }
    }

    /*  make Pm_new to Pm */
  }

  /*  end smoothing-algorithm */
  /*  if slopes are okay, delta_p2s @ Pm will not be changed -> Pm-Input == Pm-Output */
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1(const real32_T varargin_1[3], const real32_T varargin_2
  [3], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[3];
  real32_T x[3];
  real32_T r;
  int32_T low_i;
  int32_T low_ip;
  int32_T high_i;
  int32_T i;
  y[0] = varargin_2[0];
  y[1] = varargin_2[1];
  y[2] = varargin_2[2];
  x[0] = varargin_1[0];
  x[1] = varargin_1[1];
  x[2] = varargin_1[2];
  for (i = 0; i < 11; i++) {
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    x[0] = varargin_1[2];
    x[2] = varargin_1[0];
    y[0] = varargin_2[2];
    y[2] = varargin_2[0];
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[2]) || (varargin_3[i] < x[0]))) {
      low_i = 0;
      low_ip = 2;
      high_i = 3;
      while (high_i > low_ip) {
        if (varargin_3[i] >= varargin_1[1]) {
          low_i = 1;
          low_ip = 3;
        } else {
          high_i = 2;
        }
      }

      r = (varargin_3[i] - x[low_i]) / (x[low_i + 1] - x[low_i]);
      if (y[low_i + 1] == y[low_i]) {
        yi[i] = y[low_i];
      } else {
        yi[i] = (1.0F - r) * y[low_i] + y[low_i + 1] * r;
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1_o(const real32_T varargin_1[4], const real32_T
  varargin_2[4], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[4];
  real32_T x[4];
  real32_T r;
  int32_T low_i;
  int32_T low_ip;
  int32_T high_i;
  int32_T mid_i;
  int32_T i;
  y[0] = varargin_2[0];
  y[1] = varargin_2[1];
  y[2] = varargin_2[2];
  y[3] = varargin_2[3];
  x[0] = varargin_1[0];
  x[1] = varargin_1[1];
  x[2] = varargin_1[2];
  x[3] = varargin_1[3];
  for (i = 0; i < 11; i++) {
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    x[0] = varargin_1[3];
    x[3] = varargin_1[0];
    x[1] = varargin_1[2];
    x[2] = varargin_1[1];
    y[0] = varargin_2[3];
    y[3] = varargin_2[0];
    y[1] = varargin_2[2];
    y[2] = varargin_2[1];
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[3]) || (varargin_3[i] < x[0]))) {
      low_i = 1;
      low_ip = 2;
      high_i = 4;
      while (high_i > low_ip) {
        mid_i = (low_i + high_i) >> 1;
        if (varargin_3[i] >= x[mid_i - 1]) {
          low_i = mid_i;
          low_ip = mid_i + 1;
        } else {
          high_i = mid_i;
        }
      }

      r = (varargin_3[i] - x[low_i - 1]) / (x[low_i] - x[low_i - 1]);
      if (y[low_i - 1] == y[low_i]) {
        yi[i] = y[low_i - 1];
      } else {
        yi[i] = (1.0F - r) * y[low_i - 1] + r * y[low_i];
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1_o5pn4ly1(const real32_T varargin_1[11], const real32_T
  varargin_2[11], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[11];
  real32_T x[11];
  real32_T r;
  int32_T ixright;
  int32_T low_ip;
  int32_T high_i;
  int32_T mid_i;
  int32_T i;
  for (i = 0; i < 11; i++) {
    y[i] = varargin_2[i];
    x[i] = varargin_1[i];
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    for (i = 0; i < 5; i++) {
      r = x[i];
      x[i] = x[10 - i];
      x[10 - i] = r;
    }

    i = 0;
    for (ixright = 10; i + 1 < ixright + 1; ixright--) {
      r = y[i];
      y[i] = y[ixright];
      y[ixright] = r;
      i++;
    }
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[10]) || (varargin_3[i] < x[0]))) {
      ixright = 1;
      low_ip = 2;
      high_i = 11;
      while (high_i > low_ip) {
        mid_i = (ixright + high_i) >> 1;
        if (varargin_3[i] >= x[mid_i - 1]) {
          ixright = mid_i;
          low_ip = mid_i + 1;
        } else {
          high_i = mid_i;
        }
      }

      if (ixright != 0) {
        r = (varargin_3[i] - x[ixright - 1]) / (x[ixright] - x[ixright - 1]);
        if (y[ixright - 1] == y[ixright]) {
          yi[i] = y[ixright - 1];
        } else {
          yi[i] = (1.0F - r) * y[ixright - 1] + r * y[ixright];
        }
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1_o5(const real32_T varargin_1[5], const real32_T
  varargin_2[5], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[5];
  real32_T x[5];
  real32_T r;
  int32_T low_i;
  int32_T low_ip;
  int32_T high_i;
  int32_T mid_i;
  int32_T i;
  for (i = 0; i < 5; i++) {
    y[i] = varargin_2[i];
    x[i] = varargin_1[i];
  }

  for (i = 0; i < 11; i++) {
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    r = x[0];
    x[0] = x[4];
    x[4] = r;
    r = x[1];
    x[1] = x[3];
    x[3] = r;
    r = y[0];
    y[0] = y[4];
    y[4] = r;
    r = y[1];
    y[1] = y[3];
    y[3] = r;
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[4]) || (varargin_3[i] < x[0]))) {
      low_i = 1;
      low_ip = 2;
      high_i = 5;
      while (high_i > low_ip) {
        mid_i = (low_i + high_i) >> 1;
        if (varargin_3[i] >= x[mid_i - 1]) {
          low_i = mid_i;
          low_ip = mid_i + 1;
        } else {
          high_i = mid_i;
        }
      }

      r = (varargin_3[i] - x[low_i - 1]) / (x[low_i] - x[low_i - 1]);
      if (y[low_i - 1] == y[low_i]) {
        yi[i] = y[low_i - 1];
      } else {
        yi[i] = (1.0F - r) * y[low_i - 1] + r * y[low_i];
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1_o5p(const real32_T varargin_1[6], const real32_T
  varargin_2[6], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[6];
  real32_T x[6];
  real32_T r;
  int32_T low_i;
  int32_T low_ip;
  int32_T high_i;
  int32_T mid_i;
  int32_T i;
  for (i = 0; i < 6; i++) {
    y[i] = varargin_2[i];
    x[i] = varargin_1[i];
  }

  for (i = 0; i < 11; i++) {
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    r = x[0];
    x[0] = x[5];
    x[5] = r;
    r = x[1];
    x[1] = x[4];
    x[4] = r;
    r = x[2];
    x[2] = x[3];
    x[3] = r;
    r = y[0];
    y[0] = y[5];
    y[5] = r;
    r = y[1];
    y[1] = y[4];
    y[4] = r;
    r = y[2];
    y[2] = y[3];
    y[3] = r;
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[5]) || (varargin_3[i] < x[0]))) {
      low_i = 1;
      low_ip = 2;
      high_i = 6;
      while (high_i > low_ip) {
        mid_i = (low_i + high_i) >> 1;
        if (varargin_3[i] >= x[mid_i - 1]) {
          low_i = mid_i;
          low_ip = mid_i + 1;
        } else {
          high_i = mid_i;
        }
      }

      if (low_i != 0) {
        r = (varargin_3[i] - x[low_i - 1]) / (x[low_i] - x[low_i - 1]);
        if (y[low_i - 1] == y[low_i]) {
          yi[i] = y[low_i - 1];
        } else {
          yi[i] = (1.0F - r) * y[low_i - 1] + r * y[low_i];
        }
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1_o5pn(const real32_T varargin_1[7], const real32_T
  varargin_2[7], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[7];
  real32_T x[7];
  real32_T r;
  int32_T low_i;
  int32_T low_ip;
  int32_T high_i;
  int32_T mid_i;
  int32_T i;
  for (i = 0; i < 7; i++) {
    y[i] = varargin_2[i];
    x[i] = varargin_1[i];
  }

  for (i = 0; i < 11; i++) {
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    r = x[0];
    x[0] = x[6];
    x[6] = r;
    r = x[1];
    x[1] = x[5];
    x[5] = r;
    r = x[2];
    x[2] = x[4];
    x[4] = r;
    r = y[0];
    y[0] = y[6];
    y[6] = r;
    r = y[1];
    y[1] = y[5];
    y[5] = r;
    r = y[2];
    y[2] = y[4];
    y[4] = r;
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[6]) || (varargin_3[i] < x[0]))) {
      low_i = 1;
      low_ip = 2;
      high_i = 7;
      while (high_i > low_ip) {
        mid_i = (low_i + high_i) >> 1;
        if (varargin_3[i] >= x[mid_i - 1]) {
          low_i = mid_i;
          low_ip = mid_i + 1;
        } else {
          high_i = mid_i;
        }
      }

      r = (varargin_3[i] - x[low_i - 1]) / (x[low_i] - x[low_i - 1]);
      if (y[low_i - 1] == y[low_i]) {
        yi[i] = y[low_i - 1];
      } else {
        yi[i] = (1.0F - r) * y[low_i - 1] + r * y[low_i];
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static real32_T LX2_interp1_o5pn4ly1e(const real32_T varargin_1[2], const
  real32_T varargin_2[2], real32_T varargin_3, struct fLX2* inst)
{
  real32_T yi;
  real32_T r;
  int32_T ixleft;
  int32_T ixright;
  real32_T y_idx;
  real32_T x_idx;
  real32_T x_idx_0;
  real32_T y_idx_0;
  y_idx_0 = varargin_2[0];
  y_idx = varargin_2[1];
  x_idx = varargin_1[0];
  x_idx_0 = varargin_1[1];
  yi = 0.0F;
  if (varargin_1[1] < varargin_1[0]) {
    x_idx = varargin_1[1];
    x_idx_0 = varargin_1[0];
    ixleft = 1;
    ixright = 2;
    while (ixleft < ixright) {
      r = y_idx_0;
      y_idx_0 = y_idx;
      y_idx = r;
      ixleft = 2;
      ixright = 1;
    }
  }

  if (!((varargin_3 > x_idx_0) || (varargin_3 < x_idx))) {
    r = (varargin_3 - x_idx) / (x_idx_0 - x_idx);
    if (y_idx_0 == y_idx) {
      yi = y_idx_0;
    } else {
      yi = (1.0F - r) * y_idx_0 + r * y_idx;
    }
  }

  return yi;
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1_o5pn4(const real32_T varargin_1[8], const real32_T
  varargin_2[8], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[8];
  real32_T x[8];
  real32_T r;
  int32_T low_i;
  int32_T low_ip;
  int32_T high_i;
  int32_T mid_i;
  int32_T i;
  for (i = 0; i < 8; i++) {
    y[i] = varargin_2[i];
    x[i] = varargin_1[i];
  }

  for (i = 0; i < 11; i++) {
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    r = x[0];
    x[0] = x[7];
    x[7] = r;
    r = x[1];
    x[1] = x[6];
    x[6] = r;
    r = x[2];
    x[2] = x[5];
    x[5] = r;
    r = x[3];
    x[3] = x[4];
    x[4] = r;
    r = y[0];
    y[0] = y[7];
    y[7] = r;
    r = y[1];
    y[1] = y[6];
    y[6] = r;
    r = y[2];
    y[2] = y[5];
    y[5] = r;
    r = y[3];
    y[3] = y[4];
    y[4] = r;
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[7]) || (varargin_3[i] < x[0]))) {
      low_i = 1;
      low_ip = 2;
      high_i = 8;
      while (high_i > low_ip) {
        mid_i = (low_i + high_i) >> 1;
        if (varargin_3[i] >= x[mid_i - 1]) {
          low_i = mid_i;
          low_ip = mid_i + 1;
        } else {
          high_i = mid_i;
        }
      }

      r = (varargin_3[i] - x[low_i - 1]) / (x[low_i] - x[low_i - 1]);
      if (y[low_i - 1] == y[low_i]) {
        yi[i] = y[low_i - 1];
      } else {
        yi[i] = (1.0F - r) * y[low_i - 1] + r * y[low_i];
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1_o5pn4l(const real32_T varargin_1[9], const real32_T
  varargin_2[9], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[9];
  real32_T x[9];
  real32_T r;
  int32_T low_i;
  int32_T low_ip;
  int32_T high_i;
  int32_T mid_i;
  int32_T i;
  for (i = 0; i < 9; i++) {
    y[i] = varargin_2[i];
    x[i] = varargin_1[i];
  }

  for (i = 0; i < 11; i++) {
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    r = x[0];
    x[0] = x[8];
    x[8] = r;
    r = x[1];
    x[1] = x[7];
    x[7] = r;
    r = x[2];
    x[2] = x[6];
    x[6] = r;
    r = x[3];
    x[3] = x[5];
    x[5] = r;
    r = y[0];
    y[0] = y[8];
    y[8] = r;
    r = y[1];
    y[1] = y[7];
    y[7] = r;
    r = y[2];
    y[2] = y[6];
    y[6] = r;
    r = y[3];
    y[3] = y[5];
    y[5] = r;
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[8]) || (varargin_3[i] < x[0]))) {
      low_i = 1;
      low_ip = 2;
      high_i = 9;
      while (high_i > low_ip) {
        mid_i = (low_i + high_i) >> 1;
        if (varargin_3[i] >= x[mid_i - 1]) {
          low_i = mid_i;
          low_ip = mid_i + 1;
        } else {
          high_i = mid_i;
        }
      }

      r = (varargin_3[i] - x[low_i - 1]) / (x[low_i] - x[low_i - 1]);
      if (y[low_i - 1] == y[low_i]) {
        yi[i] = y[low_i - 1];
      } else {
        yi[i] = (1.0F - r) * y[low_i - 1] + r * y[low_i];
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_interp1_o5pn4ly(const real32_T varargin_1[10], const real32_T
  varargin_2[10], const real32_T varargin_3[11], real32_T yi[11], struct fLX2* inst)
{
  real32_T y[10];
  real32_T x[10];
  real32_T r;
  int32_T low_i;
  int32_T low_ip;
  int32_T high_i;
  int32_T mid_i;
  int32_T i;
  for (i = 0; i < 10; i++) {
    y[i] = varargin_2[i];
    x[i] = varargin_1[i];
  }

  for (i = 0; i < 11; i++) {
    yi[i] = 0.0F;
  }

  if (varargin_1[1] < varargin_1[0]) {
    for (i = 0; i < 5; i++) {
      r = x[i];
      x[i] = x[9 - i];
      x[9 - i] = r;
    }

    for (i = 0; i < 5; i++) {
      r = y[i];
      y[i] = y[9 - i];
      y[9 - i] = r;
    }
  }

  for (i = 0; i < 11; i++) {
    if (!((varargin_3[i] > x[9]) || (varargin_3[i] < x[0]))) {
      low_i = 1;
      low_ip = 2;
      high_i = 10;
      while (high_i > low_ip) {
        mid_i = (low_i + high_i) >> 1;
        if (varargin_3[i] >= x[mid_i - 1]) {
          low_i = mid_i;
          low_ip = mid_i + 1;
        } else {
          high_i = mid_i;
        }
      }

      if (low_i != 0) {
        r = (varargin_3[i] - x[low_i - 1]) / (x[low_i] - x[low_i - 1]);
        if (y[low_i - 1] == y[low_i]) {
          yi[i] = y[low_i - 1];
        } else {
          yi[i] = (1.0F - r) * y[low_i - 1] + r * y[low_i];
        }
      }
    }
  }
}

/* Function for MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
static void LX2_rdivide(const real32_T x[4], real_T y, real32_T z[4], struct fLX2* inst)
{
  z[0] = x[0] / (real32_T)y;
  z[1] = x[1] / (real32_T)y;
  z[2] = x[2] / (real32_T)y;
  z[3] = x[3] / (real32_T)y;
}

/*
 * Output and update for atomic system:
 *    '<S10>/Boost Pressure Offset Curve'
 *    '<S11>/Boost Pressure Offset Curve'
 *    '<S12>/Boost Pressure Offset Curve'
 *    '<S13>/Boost Pressure Offset Curve'
 */
void LX2_BoostPressureOffsetCurve(real32_T rtu_x, real32_T rtu_y, const real32_T
  rtu_IN_offset[11], const boolean_T rtu_IN_measured[11], const real32_T
  rtu_LPs[3], boolean_T rtu_Lp_c_ena, real32_T rtu_s_max, real32_T rtu_s_maxEx,
  uint16_T rtu_w1, uint16_T rtu_w2, uint16_T rtu_w3, uint16_T rtu_w4, real32_T
  rtu_limit_value, boolean_T rtu_Enable, rtB_BoostPressureOffsetCurve_LX *localB, struct fLX2* inst)
{
  real32_T x;
  real32_T y;
  boolean_T Lp_c_ena;
  real32_T s_max;
  real32_T s_maxEx;
  real32_T DBUG_sInt;
  real32_T DBUG_sExt_right;
  real32_T DBUG_sExt_left;
  real32_T P_LPs[11];
  real32_T P[44];
  real32_T P_new[44];
  real32_T slope;
  real32_T delta_slope;
  real_T p[11];
  real32_T aa;
  real32_T aa_0;
  real32_T b;
  real32_T b_0;
  real32_T w;
  real32_T w_0;
  real32_T w_1;
  real32_T f[2];
  boolean_T guard = FALSE;
  int32_T i;
  real32_T tmp[4];
  real32_T tmp_0[2];
  real32_T P_new_0[2];
  real32_T P_new_1[11];
  real32_T P_new_2[11];
  real32_T P_new_3[10];
  real32_T P_new_4[10];
  real32_T P_new_5[9];
  real32_T P_new_6[9];
  real32_T P_new_7[8];
  real32_T P_new_8[8];
  real32_T P_new_9[7];
  real32_T P_new_a[7];
  real32_T P_new_b[6];
  real32_T P_new_c[6];
  real32_T P_new_d[5];
  real32_T P_new_e[5];
  real32_T P_new_f[4];
  real32_T P_new_g[4];
  real32_T P_new_h[3];
  real32_T P_new_i[3];
  real32_T P_new_j[2];
  real32_T P_new_k[2];
  real32_T Lp_idx;
  real32_T Lp_idx_0;

  /* MATLAB Function 'Boost Pressure Offset Map/Boost Pressure Offset Curve': '<S15>:1' */
  x = rtu_x;
  y = rtu_y;
  Lp_c_ena = rtu_Lp_c_ena;
  s_max = rtu_s_max;
  s_maxEx = rtu_s_maxEx;

  /* % Header */
  /*  This Function manipulates the Boost-Pressure-Offset-Curve (BPOC) */
  /*  depending on a new delta_p2s @ %-EnginePower */
  /*  Rev 1 : Christian Schneider, 24.08.2018 */
  /*  Rev 1.1 : Enrico Maran, 18.01.2021    //extrapolation at 0% load limited to 10% of control limit   */
  /*  Rev 2.0 : Enrico Maran, 22.06.2021    //integrated Leanox point at low load */
  /*  Input:    x                   ...   normiert Engine Power [%],[0...100], (scalar) */
  /*                y                   ...   delta_p2s [bar], (scalar) */
  /*                IN_offset      ...   delta_p2s [bar] @ node points, (vector, 11 elements, scalar) */
  /*                IN_measured ... binary map of already measured points [-], (vector, 11 elements, boolean) */
  /*                LPs               ...   position of Leanox points (half/full load/low load), [%-Engine Power] (vector, 3 elements, scalar) */
  /*                Lp_c_ena         ...   Leanox point c enabled (~25% load) [-], (boolean) */
  /*                s_max           ...   max. allowed slope of BPOC (interpolation) [bar/%-Engine Power], (scalar) */
  /*                s_maxEx       ...   max. allowed slope of BPOC towards Leanox-Points (extrapolation)  [bar/%-Engine Power], (scalar) */
  /*                w1                ...   weighting factor for Leanox Point 1 (0% load), [-], (integer) */
  /*                w2                ...   weighting factor for Leanox Point 2 (~50% load, able to vary), [-], (integer) */
  /*                w3                ...   weighting factor for Leanox Point 3 (100% load), [-], (integer) */
  /*                w4                ...   weighting factor for Leanox Point c (~25% load), [-], (integer) */
  /*                limit_value       ...   BPOC limit value [bar], (scalar) */
  /*                Enable         ...   enable function [-], (boolean) */
  /*  */
  /*  Output: OUT_offset      ...   delta p2s [bar] @ node points, (vector, 11 elements, scalar) */
  /*                OUT_measured ... binary map of already measured points [-], (vector, 11 elements, boolean) */
  /*                Nodes             ... Nodes of BPOC [%-Engine Power], (vector, 11 elements, scalar) */
  /*                e                      ... error between new delta_p2s value and interpolated BPOC-value [bar], (scalar) */
  /*  */
  /*  Debug-Outbuts: DBUG_a     ...     nodes of BPOC which are affected by new measurement value [-], (vector, 2 elements, scalar) -> DBUG_a(1)=left node, DBUG_a(1)=right node */
  /*                              DBUG_b     ...     weighting of affected node points due to leverage function [-], (vector, 2 elements, scalar) -> DBUG_b(1)=left node, DBUG_b(1)=right node */
  /*                              DBUG_Lp   ...     location of leanox points on map (indices) [-], (vector, 3 elements, scalar) -> DBUG_Lp(1)=leanox point @ 0kW, DBUG_Lp(2)=leanox point @ ~50 load, DBUG_Lp(3)=leanox point @ 100 load, DBUG_Lp(4)=leanox point @ ~25 load */
  /*                              DBUG_s     ...     s ... calculated slopes (Interpolation/Extrapolation), [vector, 3 elements, scalar]-> DBUG_sInt ... slope between affected nodes, DBUG_sExt_left ... extrapolation slope to the left side, DBUG_sExt_right ... extrapolation slope to the left side */
  /* % Main Function BPOC */
  /*  node points of BPOC <<| LX2_FunReq-4 |>> */
  /*  Initzialisation of DBUG variables */
  /*  set DBUG_sInt to -1 -> only for debugging */
  DBUG_sExt_right = -1.0F;

  /*  set DBUG_sExt_right to -1 -> only for debugging */
  DBUG_sExt_left = -1.0F;

  /*  set DBUG_sExt_left to -1 -> only for debugging */
  if (rtu_Enable) {
    /*  enable manipulation of BPOC */
    /* % check input parameter and creating P-Matrix */
    /*  x-Parameter -> normiert Engine Power [%] */
    /*  (only values between "0 <= x <= 100" are allowed) */
    if (rtu_x < 0.0F) {
      x = 0.0F;
    } else {
      if (rtu_x > 100.0F) {
        x = 100.0F;
      }
    }

    /* --------------------------------------------- */
    /*  s_max & s_maxEx -> slope limit between two nodes (interpolation/extrapolation) [bar/%-EngPower] */
    /*  (only values between "0 <= s_max <= 3" are allowed) */
    if (rtu_s_max < 0.0F) {
      s_max = 0.0F;
    } else {
      if (rtu_s_max > 10.0F) {
        s_max = 3.0F;
      }
    }

    if (rtu_s_maxEx < 0.0F) {
      s_maxEx = 0.0F;
    } else {
      if (rtu_s_maxEx > s_max) {
        /*  s_maxEx is not allowed to be greater than s_max */
        s_maxEx = s_max;
      }
    }

    /* --------------------------------------------- */
    /*  w1, w2, w3 -> weighting factors for teached in leanox points [-] */
    /*  (only values between "0 <= s_max <= 10" are allowed) */
    /*  casting is needed because further calculations are not possible with datatype integer */
    w_1 = (real32_T)rtu_w4;

    /* --------------------------------------------- */
    /*  Creating P-Matrix (11-by-4 Matrix) */
    /*  */
    /*  Column 1, P(:,1) -> Node points */
    /*  Column 2, P(:,2) -> delta_p2s offset values */
    /*  Column 3, P(:,3) -> binary map of already measured points */
    /*  Column 4, P(:,4) -> binary map of Leanox points */
    /*  */
    /*  Example: */
    /*     0        0           0       1 */
    /*    10        0.01356     0       0 */
    /*    20        0.01476     0       0 */
    /*    30        0.02952     0       0 */
    /*    40        0.04428     0       1 */
    /*    50        0.04430     1       0 */
    /*    60        0.04432     0       0 */
    /*    70        0.04434     0       0 */
    /*    80        0.04436     1       0 */
    /*    90        0.04438     1       0 */
    /*   100        0.04440     1       1 */
    /*  *********************************************************************** */
    /*  Handling of Leanox Points  */
    /*        -> all Leanox Points are lying direct on a node point  */
    /*        -> if teached in Leanox point is not lying direct on node point - it will be moved to the most closest one */
    /*        -> weighting factor of leanox point will be weighted again depending on distance of real/teached leanox point */
    /*  *********************************************************************** */
    for (i = 0; i < 11; i++) {
      P_LPs[i] = 0.0F;
    }

    /*  create 4th column of P-Matrix */
    Lp_idx = 0.0F;

    /*  vector for saving indices of Leanox points depending on Node points */
    /*  Leanox Point 1 at 0% load (fix) */
    P_LPs[0] = 1.0F;

    /*  Lp1 always at node 1 -> 0% load */
    /*  Lp1 always at node 1 -> 0% load => Index 1 */
    /* ********************************* */
    /*  Leanox Point 2 at half load (variable -> depending on location of teached in point) */
    LX2_my_split(rtu_LPs[0], &slope, &delta_slope, inst);
    LX2_my_detect(rtu_LPs[0], &aa, &aa_0, inst);
    if (slope > delta_slope) {
      P_LPs[(int32_T)aa - 1] = 1.0F;
      w = (real32_T)rtu_w2 * slope;

      /*  weighting factor w2 of Lp2 will be weighted again depending on distance of real Leanox point */
      Lp_idx_0 = aa;

      /*  saving index of Leanox point 2 */
    } else {
      /*  bb1 < bb2 */
      P_LPs[(int32_T)aa_0 - 1] = 1.0F;
      w = (real32_T)rtu_w2 * delta_slope;

      /*  weighting factor w2 of Lp2 will be weighted again depending on distance of real Leanox point */
      Lp_idx_0 = aa_0;

      /*  saving index of Leanox point 2 */
    }

    /* ********************************* */
    /*  Leanox Point 3 at full load (fix) */
    P_LPs[10] = 1.0F;

    /*  Lp3 always at node 11 -> 100% load */
    /*  Lp3 always at node 11 -> 100% load => Index 11 */
    /* ********************************* */
    /*  adjustment of weighting factor due to position/distance of real Leanox point */
    if ((rtu_LPs[1] > 100.0F) && (rtu_LPs[1] < 110.0F)) {
      /*  Lp3 is between 100% and 110% load */
      w_0 = (1.0F - (rtu_LPs[1] - 100.0F) / 10.0F) * (real32_T)rtu_w3;
    } else if ((rtu_LPs[1] > 90.0F) && (rtu_LPs[1] <= 100.0F)) {
      /*  LP is between 90% and 100% load */
      w_0 = (1.0F - LX2_my_split_i(rtu_LPs[1], inst)) * (real32_T)rtu_w3;
    } else {
      w_0 = 0.0F;

      /*  LP not in defined range (>110% or <90%) */
    }

    /* ********************************* */
    /*  Leanox Point c at low load (~25%) (variable -> depending on location of teached in point) */
    if (rtu_Lp_c_ena) {
      if ((rtu_LPs[2] < rtu_LPs[0]) && (rtu_LPs[2] >= 10.0F)) {
        /*  if actual load reference of 25% Leanox point is lower than 50% Leanox point and >=10% load */
        LX2_my_split(rtu_LPs[2], &slope, &delta_slope, inst);
        LX2_my_detect(rtu_LPs[2], &aa, &aa_0, inst);
        if (slope > delta_slope) {
          P_LPs[(int32_T)aa - 1] = 1.0F;
          w_1 = (real32_T)rtu_w4 * slope;

          /*  weighting factor w4 of Lp_c will be weighted again depending on distance of real Leanox point */
          Lp_idx = aa;

          /*  saving index of Leanox point c */
        } else {
          /*  bb1_Lp_c < bb2_Lp_c */
          P_LPs[(int32_T)aa_0 - 1] = 1.0F;
          w_1 = (real32_T)rtu_w4 * delta_slope;

          /*  weighting factor w4 of Lp_c will be weighted again depending on distance of real Leanox point */
          Lp_idx = aa_0;

          /*  saving index of Leanox point c */
        }
      } else {
        /*  assign to 25% leanox point same values as 50% point */
        w_1 = w;
        Lp_idx = Lp_idx_0;
      }
    }

    /* ********************************* */
    /*  casting is needed because P-Matrix is not able to contain different datatypes */
    for (i = 0; i < 11; i++) {
      P[i] = 10.0F * (real32_T)i;
    }

    for (i = 0; i < 11; i++) {
      P[i + 11] = rtu_IN_offset[i];
    }

    for (i = 0; i < 11; i++) {
      P[i + 22] = (real32_T)rtu_IN_measured[i];
    }

    for (i = 0; i < 11; i++) {
      P[i + 33] = P_LPs[i];
    }

    /*  crating P-matrix */
    /* ---------------------------------------------------------------------------------- */
    /* % Detection of new Measurement point + Split via Leverage Function */
    for (i = 0; i < 44; i++) {
      P_new[i] = P[i];
    }

    /*  make old matrix to new matrix */
    /*  detects which nodes of BPOC are affected by new measurement value <<| LX2_FunReq-17 |>> */
    LX2_my_detect(x, &aa, &aa_0, inst);

    /*  divides new measurement value up to neighborhood node points via leverage function <<| LX2_FunReq-17 |>> */
    LX2_my_split(x, &b, &b_0, inst);

    /* ---------------------------------------------------------------------------------- */
    /* % Handling of measured values    */
    /*  <<| LX2_FunReq-17 |>><<| LX2_FunReq-18 |>><<| LX2_FunReq-15 |>> */
    P_new[(int32_T)aa + 10] = ((P[(int32_T)aa + 10] * (1.0F - b) + rtu_y * b) +
      P[(int32_T)aa + 10]) / 2.0F;

    /*  old and new value are weighted depending on split-function */
    P_new[(int32_T)aa + 21] = 1.0F;

    /*  writing 1 to the binary map -> already measured point */
    P_new[(int32_T)aa_0 + 10] = ((P[(int32_T)aa_0 + 10] * (1.0F - b_0) + rtu_y *
      b_0) + P[(int32_T)aa_0 + 10]) / 2.0F;

    /*  old and new value are weighted depending on split-function */
    P_new[(int32_T)aa_0 + 21] = 1.0F;

    /*  writing 1 to the binary map -> already measured point */
    slope = (P_new[(int32_T)aa_0 + 10] - P_new[(int32_T)aa + 10]) / (P_new
      [(int32_T)aa_0 - 1] - P_new[(int32_T)aa - 1]);
    DBUG_sInt = slope;

    /*  map calculated slope to DBUG_sInt variable */
    if ((real32_T)fabs(slope) > s_max) {
      /*  check if slope is within limit */
      delta_slope = (real32_T)fabs(slope) - s_max;

      /*  calc delta between max. allowed slope and actual slope */
      if (slope > 0.0F) {
        /*  slope is positive */
        P_new[(int32_T)aa + 10] += (P_new[(int32_T)aa_0 - 1] - P_new[(int32_T)aa
          - 1]) * (delta_slope * b_0);

        /*  move left point up (pos.), depending on delta_slope */
        P_new[(int32_T)aa_0 + 10] -= (P_new[(int32_T)aa_0 - 1] - P_new[(int32_T)
          aa - 1]) * (delta_slope * b);

        /*  move right point down (neg.), dependting on delta_slope */
      } else {
        if (slope < 0.0F) {
          /*  slope is negative */
          P_new[(int32_T)aa + 10] -= (P_new[(int32_T)aa_0 - 1] - P_new[(int32_T)
            aa - 1]) * (delta_slope * b_0);

          /*  move left point down (neg.), depending on delta_slope */
          P_new[(int32_T)aa_0 + 10] += (P_new[(int32_T)aa_0 - 1] - P_new
            [(int32_T)aa - 1]) * (delta_slope * b);

          /*  move right point up (pos.), depending on delta_slope */
        }
      }
    }

    /* ---------------------------------------------------------------------------------- */
    /* % manipulation of teached LEANOX Points */
    /*  <<| LX2_FunReq-14 |>> */
    /*  Leanox point 1 - Lp1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
    if (x < P[(int32_T)Lp_idx_0 - 1]) {
      if (!(rtu_Lp_c_ena && (Lp_idx < Lp_idx_0))) {
        /*  x lies between  Lp1 and Lp2  */
        LX2_my_find(*(real32_T (*)[11])&P_new[22], 1.0, Lp_idx_0, p, inst);

        /*  indices of  two most closest node points with already measured values -> right side of Lp1 */
        slope = (P_new[(int32_T)p[1] + 10] - P_new[(int32_T)p[0] + 10]) /
          (P_new[(int32_T)p[1] - 1] - P_new[(int32_T)p[0] - 1]);

        /*  calc slope between points, which were found before */
        DBUG_sExt_left = slope;

        /*  map calculated slope to DBUG_sExt_left variable */
        if ((real32_T)fabs(slope) > s_maxEx) {
          /*  check if slope okay, otherwise limit it to s_maxEx */
          if (slope < 0.0F) {
            slope = -s_maxEx;
          } else {
            slope = s_maxEx;
          }
        }

        P_new[11] = ((P_new[(int32_T)p[0] + 10] - (P_new[(int32_T)p[0] - 1] -
          P_new[0]) * slope) + (real32_T)rtu_w1 * P[11]) / (1.0F + (real32_T)
          rtu_w1);

        /*  Extrapolation to Lp1 */
        if (P_new[22] == 0.0F) {
          /*  if LP1 is not measured apply additional limitation to extrapolated value */
          slope = rtu_limit_value * 0.1F;
          if (P_new[11] <= slope) {
            slope = P_new[11];
          }

          delta_slope = -rtu_limit_value * 0.1F;
          if (delta_slope >= slope) {
            P_new[11] = delta_slope;
          } else {
            P_new[11] = slope;
          }

          /*  limitation to 10% of control range */
        }
      } else {
        guard = TRUE;
      }
    } else {
      guard = TRUE;
    }

    if (guard && ((x < P[(int32_T)Lp_idx - 1]) && rtu_Lp_c_ena && (Lp_idx <
          Lp_idx_0))) {
      /*  x lies between  Lp1 and Lp_c     */
      LX2_my_find(*(real32_T (*)[11])&P_new[22], 1.0, Lp_idx, p, inst);

      /*  indices of  two most closest node points with already measured values -> right side of Lp1 */
      slope = (P_new[(int32_T)p[1] + 10] - P_new[(int32_T)p[0] + 10]) / (P_new
        [(int32_T)p[1] - 1] - P_new[(int32_T)p[0] - 1]);

      /*  calc slope between points, which were found before */
      DBUG_sExt_left = slope;

      /*  map calculated slope to DBUG_sExt_left variable */
      if ((real32_T)fabs(slope) > s_maxEx) {
        /*  check if slope okay, otherwise limit it to s_maxEx */
        if (slope < 0.0F) {
          slope = -s_maxEx;
        } else {
          slope = s_maxEx;
        }
      }

      P_new[11] = ((P_new[(int32_T)p[0] + 10] - (P_new[(int32_T)p[0] - 1] -
        P_new[0]) * slope) + (real32_T)rtu_w1 * P[11]) / (1.0F + (real32_T)
        rtu_w1);

      /*  Extrapolation to Lp1 */
      if (P_new[22] == 0.0F) {
        /*  if LP1 is not measured apply additional limitation to extrapolated value */
        slope = rtu_limit_value * 0.1F;
        if (P_new[11] <= slope) {
          slope = P_new[11];
        }

        delta_slope = -rtu_limit_value * 0.1F;
        if (delta_slope >= slope) {
          P_new[11] = delta_slope;
        } else {
          P_new[11] = slope;
        }

        /*  limitation to 10% of control range */
      }
    }

    /* ---------------------------------------------------------------------------------- */
    /*  <<| LX2_FunReq-14 |>> */
    /*  Leanox point c (~25% load) - Lp4  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
    if (rtu_Lp_c_ena && (Lp_idx < Lp_idx_0)) {
      /*  apply only if Lp_c is enabled, otherwise consider standard 3 Leanox point logic  */
      if (x < P[(int32_T)Lp_idx - 1]) {
        /*  x lies between  Lp1 and Lp_c  */
        LX2_my_find_e(*(real32_T (*)[11])&P_new[22], 1.0, Lp_idx, p, inst);

        /*  indices of  two most closest node points with already measured values -> left side of Lp_c */
        /*  new Measurment point is between two nodes */
        slope = (P_new[(int32_T)p[1] + 10] - P_new[(int32_T)p[0] + 10]) /
          (P_new[(int32_T)p[1] - 1] - P_new[(int32_T)p[0] - 1]);

        /*  calc slope between points, which were found before */
        DBUG_sExt_right = slope;

        /*  map calculated slope to DBUG_sExt_right variable */
        if ((real32_T)fabs(slope) > s_maxEx) {
          /*  check if slope okay, otherwise limit it to s_maxEx */
          if (slope < 0.0F) {
            slope = -s_maxEx;
          } else {
            slope = s_maxEx;
          }
        }

        P_new[(int32_T)Lp_idx + 10] = (((P_new[(int32_T)Lp_idx - 1] - P_new
          [(int32_T)p[1] - 1]) * slope + P_new[(int32_T)p[1] + 10]) + P[(int32_T)
          Lp_idx + 10] * w_1) / (1.0F + w_1);

        /*  Extrapolation to Lp2 */
      } else if ((x > P[(int32_T)Lp_idx - 1]) && (x < P[(int32_T)Lp_idx_0 - 1]))
      {
        /*  x lies between  Lp_c and Lp2  */
        LX2_my_find_ex(*(real32_T (*)[11])&P_new[22], Lp_idx, Lp_idx_0, p, inst);

        /*  indices of  two most closest node points with already measured values -> right side of Lp_c */
        slope = (P_new[(int32_T)p[1] + 10] - P_new[(int32_T)p[0] + 10]) /
          (P_new[(int32_T)p[1] - 1] - P_new[(int32_T)p[0] - 1]);

        /*  calc slope between points, which were found before */
        DBUG_sExt_left = slope;

        /*  map calculated slope to DBUG_sExt_left variable */
        if ((real32_T)fabs(slope) > s_maxEx) {
          /*  check if slope okay, otherwise limit it to s_maxEx */
          if (slope < 0.0F) {
            slope = -s_maxEx;
          } else {
            slope = s_maxEx;
          }
        }

        P_new[(int32_T)Lp_idx + 10] = ((P_new[(int32_T)p[0] + 10] - (P_new
          [(int32_T)p[0] - 1] - P_new[(int32_T)Lp_idx - 1]) * slope) + P
          [(int32_T)Lp_idx + 10] * w_1) / (1.0F + w_1);
      } else {
        if (P[(int32_T)Lp_idx - 1] == x) {
          P_new[(int32_T)Lp_idx + 10] = (P[(int32_T)Lp_idx + 10] * w_1 + P_new
            [(int32_T)Lp_idx + 10]) / (1.0F + w_1);

          /*  measurement point lies exactly on node of Lp_c */
        }
      }
    }

    /* ---------------------------------------------------------------------------------- */
    /*  <<| LX2_FunReq-14 |>> */
    /*  Leanox point 2 - Lp2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
    guard = FALSE;
    if (x < P[(int32_T)Lp_idx_0 - 1]) {
      if (!(rtu_Lp_c_ena && (Lp_idx < Lp_idx_0))) {
        /*  x lies between  Lp1 and Lp2  */
        LX2_my_find_e(*(real32_T (*)[11])&P_new[22], 1.0, Lp_idx_0, p, inst);

        /*  indices of  two most closest node points with already measured values -> left side of Lp2 */
        /*  new Measurment point is between two nodes */
        slope = (P_new[(int32_T)p[1] + 10] - P_new[(int32_T)p[0] + 10]) /
          (P_new[(int32_T)p[1] - 1] - P_new[(int32_T)p[0] - 1]);

        /*  calc slope between points, which were found before */
        DBUG_sExt_right = slope;

        /*  map calculated slope to DBUG_sExt_right variable */
        if ((real32_T)fabs(slope) > s_maxEx) {
          /*  check if slope okay, otherwise limit it to s_maxEx */
          if (slope < 0.0F) {
            slope = -s_maxEx;
          } else {
            slope = s_maxEx;
          }
        }

        P_new[(int32_T)Lp_idx_0 + 10] = (((P_new[(int32_T)Lp_idx_0 - 1] - P_new
          [(int32_T)p[1] - 1]) * slope + P_new[(int32_T)p[1] + 10]) + P[(int32_T)
          Lp_idx_0 + 10] * w) / (1.0F + w);

        /*  Extrapolation to Lp2 */
      } else {
        guard = TRUE;
      }
    } else {
      guard = TRUE;
    }

    if (guard) {
      if ((x < P[(int32_T)Lp_idx_0 - 1]) && (x > P[(int32_T)Lp_idx - 1]) &&
          rtu_Lp_c_ena && (Lp_idx < Lp_idx_0)) {
        /*  x lies between  Lp_c and Lp2  */
        LX2_my_find_exl(*(real32_T (*)[11])&P_new[22], Lp_idx, Lp_idx_0, p, inst);

        /*  indices of  two most closest node points with already measured values -> left side of Lp2 */
        /*  new Measurment point is between two nodes */
        slope = (P_new[(int32_T)p[1] + 10] - P_new[(int32_T)p[0] + 10]) /
          (P_new[(int32_T)p[1] - 1] - P_new[(int32_T)p[0] - 1]);

        /*  calc slope between points, which were found before */
        DBUG_sExt_right = slope;

        /*  map calculated slope to DBUG_sExt_right variable */
        if ((real32_T)fabs(slope) > s_maxEx) {
          /*  check if slope okay, otherwise limit it to s_maxEx */
          if (slope < 0.0F) {
            slope = -s_maxEx;
          } else {
            slope = s_maxEx;
          }
        }

        P_new[(int32_T)Lp_idx_0 + 10] = (((P_new[(int32_T)Lp_idx_0 - 1] - P_new
          [(int32_T)p[1] - 1]) * slope + P_new[(int32_T)p[1] + 10]) + P[(int32_T)
          Lp_idx_0 + 10] * w) / (1.0F + w);

        /*  Extrapolation to Lp2 */
      } else if (x > P[(int32_T)Lp_idx_0 - 1]) {
        /*  x lies between  Lp2 and Lp3  */
        LX2_my_find_exlq(*(real32_T (*)[11])&P_new[22], Lp_idx_0, 11.0, p, inst);

        /*  indices of  two most closest node points with already measured values -> right side of Lp2 */
        slope = (P_new[(int32_T)p[1] + 10] - P_new[(int32_T)p[0] + 10]) /
          (P_new[(int32_T)p[1] - 1] - P_new[(int32_T)p[0] - 1]);

        /*  calc slope between points, which were found before */
        DBUG_sExt_left = slope;

        /*  map calculated slope to DBUG_sExt_left variable */
        if ((real32_T)fabs(slope) > s_maxEx) {
          /*  check if slope okay, otherwise limit it to s_maxEx */
          if (slope < 0.0F) {
            slope = -s_maxEx;
          } else {
            slope = s_maxEx;
          }
        }

        P_new[(int32_T)Lp_idx_0 + 10] = ((P_new[(int32_T)p[0] + 10] - (P_new
          [(int32_T)p[0] - 1] - P_new[(int32_T)Lp_idx_0 - 1]) * slope) + P
          [(int32_T)Lp_idx_0 + 10] * w) / (1.0F + w);
      } else {
        if (P[(int32_T)Lp_idx_0 - 1] == x) {
          P_new[(int32_T)Lp_idx_0 + 10] = (P[(int32_T)Lp_idx_0 + 10] * w +
            P_new[(int32_T)Lp_idx_0 + 10]) / (1.0F + w);

          /*  measurement point lies exactly on node of Lp2 */
        }
      }
    }

    /* ---------------------------------------------------------------------------------- */
    /*  <<| LX2_FunReq-14 |>> */
    /*  Leanox point 3 - Lp3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
    if (x > P[(int32_T)Lp_idx_0 - 1]) {
      /*  x lies between  Lp2 and Lp3  */
      LX2_my_find_exlqw(*(real32_T (*)[11])&P_new[22], Lp_idx_0, 11.0, p, inst);

      /*  indices of  two most closest node points with already measured values -> left side of Lp3 */
      slope = (P_new[(int32_T)p[1] + 10] - P_new[(int32_T)p[0] + 10]) / (P_new
        [(int32_T)p[1] - 1] - P_new[(int32_T)p[0] - 1]);

      /*  calc slope between points, which were found before */
      DBUG_sExt_right = slope;

      /*  map calculated slope to DBUG_sExt_right variable */
      if ((real32_T)fabs(slope) > s_maxEx) {
        /*  check if slope okay, otherwise limit it to s_maxEx */
        if (slope < 0.0F) {
          slope = -s_maxEx;
        } else {
          slope = s_maxEx;
        }
      }

      P_new[21] = (((P_new[10] - P_new[(int32_T)p[1] - 1]) * slope + P_new
                    [(int32_T)p[1] + 10]) + w_0 * P[21]) / (1.0F + w_0);
    }

    /* ---------------------------------------------------------------------------------- */
    /* % BPOC smoothening */
    /*  <<| LX2_FunReq-15 |>> to guarantee all slopes of BPOC are within the required limit  */
    for (i = 0; i < 11; i++) {
      P_LPs[i] = P_new[22 + i];
    }

    /*  binary map of node points with already measured values */
    P_LPs[0] = 1.0F;
    P_LPs[(int32_T)Lp_idx_0 - 1] = 1.0F;
    P_LPs[10] = 1.0F;

    /*  consider Leanox points in map */
    if (rtu_Lp_c_ena && (Lp_idx < Lp_idx_0)) {
      /*  consider also Leanox point c if relevant */
      P_LPs[(int32_T)Lp_idx - 1] = 1.0F;
    }

    LX2_my_find_exlqwy(P_LPs, p, inst);

    /*  find all indices of j, where already measured values available */
    /*  for-loop applies smoothing-function from biggest to smallest indices (from 100% load -> 0% load) */
    slope = LX2_sum(P_LPs, inst) - 3.0F;
    for (i = 0; i < (int32_T)(slope + 1.0F); i++) {
      /*  Input of my_smoothing: right point of triangle */
      /*  Input of my_smoothing: middle point of triangle */
      /*  Input of my_smoothing: left point of triangle */
      /*  call smoothening-function */
      f[0] = P_new[(int32_T)p[(int32_T)(10.0F - (real32_T)i) - 1] - 1];
      f[1] = P_new[(int32_T)p[(int32_T)(10.0F - (real32_T)i) - 1] + 10];
      P_new_j[0] = P_new[(int32_T)p[(int32_T)(9.0F - (real32_T)i) - 1] - 1];
      P_new_j[1] = P_new[(int32_T)p[(int32_T)(9.0F - (real32_T)i) - 1] + 10];
      P_new_k[0] = P_new[(int32_T)p[(int32_T)(11.0F - (real32_T)i) - 1] - 1];
      P_new_k[1] = P_new[(int32_T)p[(int32_T)(11.0F - (real32_T)i) - 1] + 10];
      LX2_my_smoothing(P_new_j, f, P_new_k, s_max, inst);
      P_new[(int32_T)p[(int32_T)(10.0F - (real32_T)i) - 1] + 10] = f[1];
    }

    /*  end smoothening */
    /* % Interpolation */
    /*  <<| LX2_FunReq-16 |>> */
    /*  interpolates complete BPOC depending on how many measured points are already available */
    for (i = 0; i < 11; i++) {
      P_LPs[i] = P_new[22 + i];
    }

    P_LPs[0] = 1.0F;
    P_LPs[(int32_T)Lp_idx_0 - 1] = 1.0F;
    P_LPs[10] = 1.0F;
    if (Lp_c_ena && (Lp_idx < Lp_idx_0)) {
      /*  consider also Leanox point c if relevant */
      P_LPs[(int32_T)Lp_idx - 1] = 1.0F;
    }

    LX2_my_find_exlqwy(P_LPs, p, inst);

    /*  find all indices for interpolation algorithm */
    if (LX2_sum(P_LPs, inst) == 3.0F) {
      P_new_h[0] = P_new[(int32_T)p[8] - 1];
      P_new_h[1] = P_new[(int32_T)p[9] - 1];
      P_new_h[2] = P_new[(int32_T)p[10] - 1];
      P_new_i[0] = P_new[(int32_T)p[0] + 10];
      P_new_i[1] = P_new[(int32_T)p[1] + 10];
      P_new_i[2] = P_new[(int32_T)p[2] + 10];
      for (i = 0; i < 11; i++) {
        P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
      }

      LX2_interp1(P_new_h, P_new_i, P_LPs, *(real32_T (*)[11])&P_new[11], inst);
    } else if (LX2_sum(P_LPs, inst) == 4.0F) {
      P_new_f[0] = P_new[(int32_T)p[7] - 1];
      P_new_f[1] = P_new[(int32_T)p[8] - 1];
      P_new_f[2] = P_new[(int32_T)p[9] - 1];
      P_new_f[3] = P_new[(int32_T)p[10] - 1];
      P_new_g[0] = P_new[(int32_T)p[7] + 10];
      P_new_g[1] = P_new[(int32_T)p[8] + 10];
      P_new_g[2] = P_new[(int32_T)p[9] + 10];
      P_new_g[3] = P_new[(int32_T)p[10] + 10];
      for (i = 0; i < 11; i++) {
        P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
      }

      LX2_interp1_o(P_new_f, P_new_g, P_LPs, *(real32_T (*)[11])&P_new[11], inst);
    } else if (LX2_sum(P_LPs, inst) == 5.0F) {
      P_new_d[0] = P_new[(int32_T)p[6] - 1];
      P_new_d[1] = P_new[(int32_T)p[7] - 1];
      P_new_d[2] = P_new[(int32_T)p[8] - 1];
      P_new_d[3] = P_new[(int32_T)p[9] - 1];
      P_new_d[4] = P_new[(int32_T)p[10] - 1];
      P_new_e[0] = P_new[(int32_T)p[6] + 10];
      P_new_e[1] = P_new[(int32_T)p[7] + 10];
      P_new_e[2] = P_new[(int32_T)p[8] + 10];
      P_new_e[3] = P_new[(int32_T)p[9] + 10];
      P_new_e[4] = P_new[(int32_T)p[10] + 10];
      for (i = 0; i < 11; i++) {
        P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
      }

      LX2_interp1_o5(P_new_d, P_new_e, P_LPs, *(real32_T (*)[11])&P_new[11], inst);
    } else if (LX2_sum(P_LPs, inst) == 6.0F) {
      P_new_b[0] = P_new[(int32_T)p[5] - 1];
      P_new_b[1] = P_new[(int32_T)p[6] - 1];
      P_new_b[2] = P_new[(int32_T)p[7] - 1];
      P_new_b[3] = P_new[(int32_T)p[8] - 1];
      P_new_b[4] = P_new[(int32_T)p[9] - 1];
      P_new_b[5] = P_new[(int32_T)p[10] - 1];
      P_new_c[0] = P_new[(int32_T)p[5] + 10];
      P_new_c[1] = P_new[(int32_T)p[6] + 10];
      P_new_c[2] = P_new[(int32_T)p[7] + 10];
      P_new_c[3] = P_new[(int32_T)p[8] + 10];
      P_new_c[4] = P_new[(int32_T)p[9] + 10];
      P_new_c[5] = P_new[(int32_T)p[10] + 10];
      for (i = 0; i < 11; i++) {
        P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
      }

      LX2_interp1_o5p(P_new_b, P_new_c, P_LPs, *(real32_T (*)[11])&P_new[11], inst);
    } else if (LX2_sum(P_LPs, inst) == 7.0F) {
      P_new_9[0] = P_new[(int32_T)p[4] - 1];
      P_new_9[1] = P_new[(int32_T)p[5] - 1];
      P_new_9[2] = P_new[(int32_T)p[6] - 1];
      P_new_9[3] = P_new[(int32_T)p[7] - 1];
      P_new_9[4] = P_new[(int32_T)p[8] - 1];
      P_new_9[5] = P_new[(int32_T)p[9] - 1];
      P_new_9[6] = P_new[(int32_T)p[10] - 1];
      P_new_a[0] = P_new[(int32_T)p[4] + 10];
      P_new_a[1] = P_new[(int32_T)p[5] + 10];
      P_new_a[2] = P_new[(int32_T)p[6] + 10];
      P_new_a[3] = P_new[(int32_T)p[7] + 10];
      P_new_a[4] = P_new[(int32_T)p[8] + 10];
      P_new_a[5] = P_new[(int32_T)p[9] + 10];
      P_new_a[6] = P_new[(int32_T)p[10] + 10];
      for (i = 0; i < 11; i++) {
        P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
      }

      LX2_interp1_o5pn(P_new_9, P_new_a, P_LPs, *(real32_T (*)[11])&P_new[11], inst);
    } else if (LX2_sum(P_LPs, inst) == 8.0F) {
      P_new_7[0] = P_new[(int32_T)p[3] - 1];
      P_new_7[1] = P_new[(int32_T)p[4] - 1];
      P_new_7[2] = P_new[(int32_T)p[5] - 1];
      P_new_7[3] = P_new[(int32_T)p[6] - 1];
      P_new_7[4] = P_new[(int32_T)p[7] - 1];
      P_new_7[5] = P_new[(int32_T)p[8] - 1];
      P_new_7[6] = P_new[(int32_T)p[9] - 1];
      P_new_7[7] = P_new[(int32_T)p[10] - 1];
      P_new_8[0] = P_new[(int32_T)p[3] + 10];
      P_new_8[1] = P_new[(int32_T)p[4] + 10];
      P_new_8[2] = P_new[(int32_T)p[5] + 10];
      P_new_8[3] = P_new[(int32_T)p[6] + 10];
      P_new_8[4] = P_new[(int32_T)p[7] + 10];
      P_new_8[5] = P_new[(int32_T)p[8] + 10];
      P_new_8[6] = P_new[(int32_T)p[9] + 10];
      P_new_8[7] = P_new[(int32_T)p[10] + 10];
      for (i = 0; i < 11; i++) {
        P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
      }

      LX2_interp1_o5pn4(P_new_7, P_new_8, P_LPs, *(real32_T (*)[11])&P_new[11], inst);
    } else if (LX2_sum(P_LPs, inst) == 9.0F) {
      P_new_5[0] = P_new[(int32_T)p[2] - 1];
      P_new_5[1] = P_new[(int32_T)p[3] - 1];
      P_new_5[2] = P_new[(int32_T)p[4] - 1];
      P_new_5[3] = P_new[(int32_T)p[5] - 1];
      P_new_5[4] = P_new[(int32_T)p[6] - 1];
      P_new_5[5] = P_new[(int32_T)p[7] - 1];
      P_new_5[6] = P_new[(int32_T)p[8] - 1];
      P_new_5[7] = P_new[(int32_T)p[9] - 1];
      P_new_5[8] = P_new[(int32_T)p[10] - 1];
      P_new_6[0] = P_new[(int32_T)p[2] + 10];
      P_new_6[1] = P_new[(int32_T)p[3] + 10];
      P_new_6[2] = P_new[(int32_T)p[4] + 10];
      P_new_6[3] = P_new[(int32_T)p[5] + 10];
      P_new_6[4] = P_new[(int32_T)p[6] + 10];
      P_new_6[5] = P_new[(int32_T)p[7] + 10];
      P_new_6[6] = P_new[(int32_T)p[8] + 10];
      P_new_6[7] = P_new[(int32_T)p[9] + 10];
      P_new_6[8] = P_new[(int32_T)p[10] + 10];
      for (i = 0; i < 11; i++) {
        P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
      }

      LX2_interp1_o5pn4l(P_new_5, P_new_6, P_LPs, *(real32_T (*)[11])&P_new[11], inst);
    } else if (LX2_sum(P_LPs, inst) == 10.0F) {
      P_new_3[0] = P_new[(int32_T)p[1] - 1];
      P_new_3[1] = P_new[(int32_T)p[2] - 1];
      P_new_3[2] = P_new[(int32_T)p[3] - 1];
      P_new_3[3] = P_new[(int32_T)p[4] - 1];
      P_new_3[4] = P_new[(int32_T)p[5] - 1];
      P_new_3[5] = P_new[(int32_T)p[6] - 1];
      P_new_3[6] = P_new[(int32_T)p[7] - 1];
      P_new_3[7] = P_new[(int32_T)p[8] - 1];
      P_new_3[8] = P_new[(int32_T)p[9] - 1];
      P_new_3[9] = P_new[(int32_T)p[10] - 1];
      P_new_4[0] = P_new[(int32_T)p[1] + 10];
      P_new_4[1] = P_new[(int32_T)p[2] + 10];
      P_new_4[2] = P_new[(int32_T)p[3] + 10];
      P_new_4[3] = P_new[(int32_T)p[4] + 10];
      P_new_4[4] = P_new[(int32_T)p[5] + 10];
      P_new_4[5] = P_new[(int32_T)p[6] + 10];
      P_new_4[6] = P_new[(int32_T)p[7] + 10];
      P_new_4[7] = P_new[(int32_T)p[8] + 10];
      P_new_4[8] = P_new[(int32_T)p[9] + 10];
      P_new_4[9] = P_new[(int32_T)p[10] + 10];
      for (i = 0; i < 11; i++) {
        P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
      }

      LX2_interp1_o5pn4ly(P_new_3, P_new_4, P_LPs, *(real32_T (*)[11])&P_new[11], inst);
    } else {
      if (LX2_sum(P_LPs, inst) == 11.0F) {
        for (i = 0; i < 11; i++) {
          P_LPs[i] = (*(real32_T (*)[11])&P_new[0])[i];
        }

        for (i = 0; i < 11; i++) {
          P_new_1[i] = (*(real32_T (*)[11])&P_new[11])[i];
        }

        for (i = 0; i < 11; i++) {
          P_new_2[i] = (*(real32_T (*)[11])&P_new[0])[i];
        }

        LX2_interp1_o5pn4ly1(P_LPs, P_new_1, P_new_2, *(real32_T (*)[11])&P_new
                             [11], inst);
      }
    }

    /*  write new interpolated values to Output */
    for (i = 0; i < 11; i++) {
      localB->OUT_offset[i] = P_new[11 + i];
      localB->OUT_measured[i] = (P_new[22 + i] != 0.0F);
    }

    /* % error calculation */
    /*  error between new delta_p2s value and interpolated BPOC-value -> for debugging reasons only */
    if ((aa_0 != 0.0F) && (aa_0 != 11.0F)) {
      tmp_0[0] = (real32_T)((int32_T)aa - 1) * 10.0F;
      tmp_0[1] = (real32_T)((int32_T)(aa + 1.0F) - 1) * 10.0F;
      P_new_0[0] = P_new[(int32_T)aa + 10];
      P_new_0[1] = P_new[(int32_T)(aa + 1.0F) + 10];
      slope = y - LX2_interp1_o5pn4ly1e(tmp_0, P_new_0, x, inst);
    } else {
      /*  a2==single(11) */
      slope = y - P_new[(int32_T)aa_0 + 10];
    }

    localB->DBUG_a[0] = aa;
    localB->DBUG_a[1] = aa_0;

    /*  a1, a2 ... results of my_detect */
    localB->DBUG_b[0] = b;
    localB->DBUG_b[1] = b_0;

    /*  b1, b2 ... results of my_split */
    tmp[0] = 0.0F;
    tmp[1] = Lp_idx_0 - 1.0F;
    tmp[2] = 10.0F;
    tmp[3] = Lp_idx - 1.0F;
    LX2_rdivide(tmp, 10.0, localB->DBUG_Lp, inst);

    /*  Lp ... location of leanox points on map (indices). Set DBUG_Lp(4,1) to -1 if Lp_c not enabled */
    localB->DBUG_s[0] = DBUG_sInt;
    localB->DBUG_s[1] = DBUG_sExt_left;
    localB->DBUG_s[2] = DBUG_sExt_right;

    /*  DBUG_sInt ... slope between affected nodes, DBUG_sExt_left ... extrapolation slope to the left side, DBUG_sExt_right ... extrapolation slope to the left side */
  } else {
    /*  if function is disabled... Input == Output */
    for (i = 0; i < 11; i++) {
      localB->OUT_offset[i] = rtu_IN_offset[i];
      localB->OUT_measured[i] = rtu_IN_measured[i];
    }

    slope = 0.0F;

    /*  set error to zero -> for debugging reasons only */
    localB->DBUG_a[0] = -1.0F;
    localB->DBUG_a[1] = -1.0F;

    /*  a1, a2 ... results of my_detect | % set var to -1 -> for debugging reasons only */
    localB->DBUG_b[0] = -1.0F;
    localB->DBUG_b[1] = -1.0F;

    /*  b1, b2 ... results of my_split | % set var to -1 -> for debugging reasons only */
    localB->DBUG_Lp[0] = -1.0F;
    localB->DBUG_Lp[1] = -1.0F;
    localB->DBUG_Lp[2] = -1.0F;
    localB->DBUG_Lp[3] = -1.0F;

    /*  Lp ... location of leanox points on map (indices) | % set var to -1 -> for debugging reasons only */
    localB->DBUG_s[0] = -1.0F;
    localB->DBUG_s[1] = -1.0F;
    localB->DBUG_s[2] = -1.0F;

    /*  s ... calculated slopes (Interpolation/Extrapolation)  | % set var to -1 -> for debugging reasons only */
  }

  /* '<S15>:1:3' */
  localB->e = slope;
}

/*
 * Output and update for atomic system:
 *    '<S37>/TON'
 *    '<S54>/TON'
 */
void LX2_TON(boolean_T rtu_IN, real32_T rtu_PT, rtB_TON_LX2 *localB,
             rtDW_TON_LX2 *localDW, struct fLX2* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2_g;
  boolean_T rtb_RelationalOperator_o;

  /* Logic: '<S47>/Logical Operator2' */
  rtb_LogicalOperator2_g = !rtu_IN;

  /* DiscreteIntegrator: '<S47>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_g || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  localB->DiscreteTimeIntegrator = localDW->DiscreteTimeIntegrator_DSTATE;

  /* End of DiscreteIntegrator: '<S47>/Discrete-Time Integrator' */

  /* RelationalOperator: '<S47>/Relational Operator' */
  rtb_RelationalOperator_o = (localB->DiscreteTimeIntegrator >= rtu_PT);

  /* Logic: '<S47>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_o && rtu_IN);

  /* Update for DiscreteIntegrator: '<S47>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S48>/Conversion'
   *  Logic: '<S47>/Logical Operator'
   *  Logic: '<S47>/Logical Operator1'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (real32_T)
    ((!rtb_RelationalOperator_o) && rtu_IN) * 0.1F;
  if (rtb_LogicalOperator2_g) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S47>/Discrete-Time Integrator' */
}

/*
 * Initial conditions for atomic system:
 *    '<S8>/Filter1'
 *    '<S51>/Filter'
 *    '<S51>/Filter1'
 */
void LX2_Filter1_Init(rtDW_Filter1_LX2 *localDW, struct fLX2* inst)
{
  /* InitializeConditions for DiscreteIntegrator: '<S50>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 1U;
}

/*
 * Output and update for atomic system:
 *    '<S8>/Filter1'
 *    '<S51>/Filter'
 *    '<S51>/Filter1'
 */
void LX2_Filter1(uint16_T rtu_T_filt, boolean_T rtu_reset, real32_T rtu_x0,
                 rtB_Filter1_LX2 *localB, rtDW_Filter1_LX2 *localDW, struct fLX2* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator_j;
  boolean_T rtb_RelationalOperator_ly;
  real32_T tmp;

  /* RelationalOperator: '<S50>/Relational Operator' incorporates:
   *  Constant: '<S50>/Constant'
   *  DataTypeConversion: '<S50>/Data Type Conversion2'
   */
  rtb_RelationalOperator_ly = (rtu_T_filt > 0);

  /* Logic: '<S50>/Logical Operator' incorporates:
   *  Logic: '<S50>/Logical Operator1'
   */
  rtb_LogicalOperator_j = (rtu_reset || (!rtb_RelationalOperator_ly));

  /* DiscreteIntegrator: '<S50>/Discrete-Time Integrator' */
  if (localDW->DiscreteTimeIntegrator_IC_LOADI != 0) {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  if (rtb_LogicalOperator_j || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = rtu_x0;
  }

  /* Switch: '<S50>/Switch' incorporates:
   *  DiscreteIntegrator: '<S50>/Discrete-Time Integrator'
   */
  if (rtb_RelationalOperator_ly) {
    localB->Switch = localDW->DiscreteTimeIntegrator_DSTATE;
  } else {
    localB->Switch = rtu_x0;
  }

  /* End of Switch: '<S50>/Switch' */

  /* Update for DiscreteIntegrator: '<S50>/Discrete-Time Integrator' */
  localDW->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* Switch: '<S55>/Switch' incorporates:
   *  Constant: '<S55>/Constant2'
   *  DataTypeConversion: '<S50>/Data Type Conversion2'
   *  RelationalOperator: '<S55>/Relational Operator'
   */
  if (0.1F >= (real32_T)rtu_T_filt) {
    tmp = 0.1F;
  } else {
    tmp = (real32_T)rtu_T_filt;
  }

  /* End of Switch: '<S55>/Switch' */

  /* Update for DiscreteIntegrator: '<S50>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S50>/Discrete-Time Integrator'
   *  Product: '<S50>/Divide4'
   *  Sum: '<S50>/Sum4'
   */
  localDW->DiscreteTimeIntegrator_DSTATE += (rtu_x0 -
    localDW->DiscreteTimeIntegrator_DSTATE) / tmp * 0.1F;
  if (rtb_LogicalOperator_j) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }
}

/* Function for MATLAB Function: '<S8>/MATLAB Function' */
static void LX2_my_BPOC_enable_h(const real32_T splitfactor[4], boolean_T
  bLX2_enable, const real32_T rThreshold_save2map[2], boolean_T
  bExt_BPOC_learning_Stop, boolean_T bBPOC_enable[4], boolean_T
  bSave_BPOC_enable[4], struct fLX2* inst)
{
  /* % my_BPOC_enable */
  bSave_BPOC_enable[0] = (bLX2_enable && (splitfactor[0] > rThreshold_save2map[0])
    && (splitfactor[2] < 1.0F - rThreshold_save2map[1]) &&
    (!bExt_BPOC_learning_Stop));
  bBPOC_enable[0] = (splitfactor[0] > 0.0F);
  bSave_BPOC_enable[1] = (bLX2_enable && (splitfactor[1] > rThreshold_save2map[0])
    && (splitfactor[2] < 1.0F - rThreshold_save2map[1]) &&
    (!bExt_BPOC_learning_Stop));
  bBPOC_enable[1] = (splitfactor[1] > 0.0F);
  bSave_BPOC_enable[2] = (bLX2_enable && (splitfactor[2] > rThreshold_save2map[1])
    && (!bExt_BPOC_learning_Stop));
  bBPOC_enable[2] = (splitfactor[2] > 0.0F);
  bSave_BPOC_enable[3] = (bLX2_enable && (splitfactor[3] > rThreshold_save2map[1])
    && (!bExt_BPOC_learning_Stop));
  bBPOC_enable[3] = (splitfactor[3] > 0.0F);
}

/* Function for MATLAB Function: '<S8>/MATLAB Function' */
static void LX2_my_BPOC_enable(const real32_T splitfactor[4], boolean_T
  bLX2_enable, const real32_T rThreshold_save2map[2], boolean_T
  bExt_BPOC_learning_Stop, boolean_T bBPOC_enable[4], boolean_T
  bSave_BPOC_enable[4], struct fLX2* inst)
{
  /* % my_BPOC_enable */
  bSave_BPOC_enable[0] = (bLX2_enable && (splitfactor[0] > rThreshold_save2map[0])
    && (splitfactor[2] < 1.0F - rThreshold_save2map[1]) &&
    (!bExt_BPOC_learning_Stop));
  bBPOC_enable[0] = (splitfactor[0] > 0.0F);
  bSave_BPOC_enable[1] = (bLX2_enable && (splitfactor[1] > rThreshold_save2map[0])
    && (splitfactor[2] < 1.0F - rThreshold_save2map[1]) &&
    (!bExt_BPOC_learning_Stop));
  bBPOC_enable[1] = (splitfactor[1] > 0.0F);
  bSave_BPOC_enable[2] = (bLX2_enable && (splitfactor[2] > rThreshold_save2map[1])
    && (!bExt_BPOC_learning_Stop));
  bBPOC_enable[2] = (splitfactor[2] > 0.0F);
  bSave_BPOC_enable[3] = (bLX2_enable && (splitfactor[3] > rThreshold_save2map[1])
    && (!bExt_BPOC_learning_Stop));
  bBPOC_enable[3] = (splitfactor[3] > 0.0F);
}

/* Function for MATLAB Function: '<S8>/MATLAB Function' */
static void LX2_my_gasmixing(uint16_T iIdx_Gtyp_Dem, real32_T rGT_QualMix_1_2,
  real32_T rGT_RatioMix, boolean_T bLX2_enable, const real32_T
  rThreshold_save2map[2], boolean_T bExt_BPOC_learning_Stop, real32_T
  splitfactor_Gas[4], boolean_T bBPOC_enable[4], boolean_T bSave_BPOC_enable[4], struct fLX2* inst)
{
  real32_T tmp[2];

  /*  function undesired_operating */
  /* % function my_gasmixing <<LX2_FunReq-26>> */
  /*  define output vectors */
  if (iIdx_Gtyp_Dem < 4) {
    splitfactor_Gas[0] = (1.0F - rGT_QualMix_1_2) * (1.0F - rGT_RatioMix);
    splitfactor_Gas[1] = (1.0F - rGT_RatioMix) * rGT_QualMix_1_2;
    splitfactor_Gas[2] = rGT_RatioMix;
    splitfactor_Gas[3] = 0.0F;
    LX2_my_BPOC_enable(splitfactor_Gas, bLX2_enable, rThreshold_save2map,
                       bExt_BPOC_learning_Stop, bBPOC_enable, bSave_BPOC_enable, inst);
  } else if (iIdx_Gtyp_Dem == 4) {
    splitfactor_Gas[0] = 0.0F;
    splitfactor_Gas[1] = 0.0F;
    splitfactor_Gas[2] = 0.0F;
    splitfactor_Gas[3] = 1.0F;
    tmp[0] = 0.0F;
    tmp[1] = 0.0F;
    LX2_my_BPOC_enable_h(splitfactor_Gas, bLX2_enable, tmp,
                         bExt_BPOC_learning_Stop, bBPOC_enable,
                         bSave_BPOC_enable, inst);
  } else {
    /*  undefined Gastype */
    splitfactor_Gas[0] = 0.0F;
    splitfactor_Gas[1] = 0.0F;
    splitfactor_Gas[2] = 0.0F;
    splitfactor_Gas[3] = 0.0F;
    tmp[0] = 1.0F;
    tmp[1] = 1.0F;
    LX2_my_BPOC_enable_h(splitfactor_Gas, bLX2_enable, tmp,
                         bExt_BPOC_learning_Stop, bBPOC_enable,
                         bSave_BPOC_enable, inst);
  }
}

/* Model step function */
void LX2_step(struct fLX2* inst)
{
  /* local block i/o variables */
  real32_T rtb_rLX2_inLimitSetup_Time;
  real32_T rtb_rPr_Leanox_Dev;
  real32_T rtb_rP_Set_Norm;
  real32_T rtb_DataTypeConversion;
  real32_T rtb_Gain7;
  real32_T rtb_Delay2[11];
  real32_T rtb_Sum1;
  real32_T rtb_Lp2Lp3Lp_c[3];
  real32_T rtb_mbar2bar2;
  real32_T rtb_mbar2bar3;
  real32_T rtb_mbar2bar4;
  real32_T rtb_Switch1[11];
  real32_T rtb_Delay2_e[11];
  real32_T rtb_Sum1_e;
  real32_T rtb_Lp2Lp3Lp_c_n[3];
  real32_T rtb_mbar2bar2_e;
  real32_T rtb_mbar2bar3_h;
  real32_T rtb_mbar2bar4_m;
  real32_T rtb_Switch1_m[11];
  real32_T rtb_Delay2_o[11];
  real32_T rtb_Sum1_b;
  real32_T rtb_Lp2Lp3Lp_c_l[3];
  real32_T rtb_mbar2bar2_o;
  real32_T rtb_mbar2bar3_o;
  real32_T rtb_mbar2bar4_e;
  real32_T rtb_Switch1_i[11];
  real32_T rtb_Delay2_o1[11];
  real32_T rtb_Sum1_h;
  real32_T rtb_Lp2Lp3Lp_c_e[3];
  real32_T rtb_mbar2bar2_m;
  real32_T rtb_mbar2bar3_a;
  real32_T rtb_mbar2bar4_g;
  real32_T rtb_Switch1_it[11];
  real32_T rtb_InterpolateBPOCatLp_c25load;
  real32_T rtb_InterpolateBPOC;
  real32_T rtb_InterpolateBPOCatLp_c25lo_h;
  real32_T rtb_InterpolateBPOC_k;
  real32_T rtb_InterpolateBPOCatLp_c25lo_l;
  real32_T rtb_InterpolateBPOC_h;
  real32_T rtb_InterpolateBPOCatLp_c25lo_e;
  real32_T rtb_InterpolateBPOC_a;
  real32_T rtb_Selector12;
  real32_T rtb_Switch2_b;
  real32_T rtb_Abs;
  real32_T rtb_Divide;
  real32_T rtb_Switch2_l;
  uint16_T rtb_iFiltConst_LeanoxDev_Steady;
  uint16_T rtb_iFiltConst_P_set_SteadyStat;
  uint16_T rtb_iFilterConst_P_set;
  uint16_T rtb_iWeight_Lp_0kW;
  uint16_T rtb_iWeight_Lp_b;
  uint16_T rtb_iWeight_Lp_a;
  uint16_T rtb_iWeight_Lp_c;
  uint16_T rtb_iWeight_Lp_0kW_e;
  uint16_T rtb_iWeight_Lp_b_c;
  uint16_T rtb_iWeight_Lp_a_m;
  uint16_T rtb_iWeight_Lp_c_m;
  uint16_T rtb_iWeight_Lp_0kW_d;
  uint16_T rtb_iWeight_Lp_b_a;
  uint16_T rtb_iWeight_Lp_a_j;
  uint16_T rtb_iWeight_Lp_c_f;
  uint16_T rtb_iWeight_Lp_0kW_k;
  uint16_T rtb_iWeight_Lp_b_e;
  uint16_T rtb_iWeight_Lp_a_h;
  uint16_T rtb_iWeight_Lp_c_e;
  boolean_T rtb_LogicalOperator1;
  boolean_T rtb_LogicalOperator3;
  boolean_T rtb_LogicalOperator4_n;
  boolean_T rtb_LogicalOperator8_g;
  boolean_T rtb_LogicalOperator7_m;
  boolean_T rtb_bLp_c_ena;
  boolean_T rtb_Delay1[11];
  boolean_T rtb_LogicalOperator7_e;
  boolean_T rtb_bLp_c_ena_i;
  boolean_T rtb_Delay1_g[11];
  boolean_T rtb_LogicalOperator7_l;
  boolean_T rtb_bLp_c_ena_h;
  boolean_T rtb_Delay1_l[11];
  boolean_T rtb_LogicalOperator7_i;
  boolean_T rtb_bLp_c_ena_n;
  boolean_T rtb_Delay1_c[11];
  boolean_T rtb_LogicalOperator4_g;
  boolean_T rtb_LogicalOperator2_de;
  boolean_T rtb_Reset;
  boolean_T rtb_LogicalOperator_d;
  boolean_T didZcEventOccur;
  boolean_T bCtrl_enable;
  boolean_T bCtrl_freeze;
  boolean_T bEng_misfire;
  boolean_T b_bEng_knock;
  real32_T b_y;
  real32_T rtb_Switch2_kt;
  real32_T rtb_Switch7;
  real32_T rtb_Gain3;
  boolean_T rtb_u;
  boolean_T rtb_u_b;
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_LogicalOperator3_e;
  real32_T rtb_Switch_nq;
  boolean_T rtb_Compare_n;
  real32_T rtb_rNOx_act_g;
  boolean_T rtb_LogicalOperator6_a;
  boolean_T rtb_LogicalOperator_f;
  boolean_T rtb_bSave_BPOC_enable[4];
  real32_T rtb_rP_Lp_c[5];
  real32_T rtb_rPr_LX2_offset_Lp_c[5];
  real32_T rtb_rPr_LX2_offset_Lp_a[5];
  real32_T rtb_rPr_LX2_offset_Lp_b[5];
  boolean_T rtb_LogicalOperator5_k;
  real32_T rtb_splitfactor_Gas[4];
  real32_T rtb_Switch3;
  real32_T rtb_LowerLimit_factor;
  boolean_T rtb_bBPOC_enable_a[4];
  real32_T rtb_SumofElements2;
  real32_T rtb_SumofElements1;
  real32_T rtb_SumofElements_o;
  real32_T rtb_SumofElements;
  real32_T rtb_DiscreteTimeIntegrator;
  real32_T rtb_Sum2_e;
  boolean_T rtb_bLX2_save[5];
  real32_T rtb_Product4[11];
  real32_T rtb_Product5[11];
  real32_T rtb_Product6[11];
  real32_T rtb_Product7[11];
  int8_T rtb_Switch5_kl[11];
  int8_T rtb_Switch4[11];
  int8_T rtb_Switch6_j[11];
  int8_T rtb_rLX2_BPOC[11];
  real32_T rtb_Switch2[11];
  real32_T rtb_Switch2_j[11];
  real32_T rtb_Switch2_k[11];
  real32_T rtb_Switch2_kq[11];
  real32_T rtb_Switch6;
  real32_T rtb_UnitDelay3;
  boolean_T rtb_RelationalOperator_b;
  boolean_T rtb_UnitDelay1;
  real32_T rtb_UnitDelay2;
  int32_T i;
  real32_T tmp[2];
  real32_T rtb_splitfactor_VISU_idx;
  boolean_T rtb_Switch2_a_idx;
  boolean_T rtb_Switch2_a_idx_0;
  boolean_T rtb_Switch2_a_idx_1;
  boolean_T rtb_Switch2_a_idx_2;
  uint32_T tmp_0;
  real_T rtb_Sum2_e_0;
  real32_T tmp_1;
  int32_T rtb_splitfactor_Gas_0;
  real_T tmp_2;
  int32_T rtb_splitfactor_Gas_1;
  int32_T rtb_splitfactor_Gas_2;
  int32_T rtb_splitfactor_Gas_3;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  LX2_B.BusInput = inst->IN;

  /* Switch: '<S7>/Switch3' incorporates:
   *  Constant: '<S7>/Constant1'
   */
  if (LX2_B.BusInput.bLX2_fastRamp) {
    rtb_Switch7 = LX2_B.BusInput.rLX2_fastRampMult;
  } else {
    rtb_Switch7 = 1.0F;
  }

  /* End of Switch: '<S7>/Switch3' */

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  LX2_B.BusInput1 = inst->PERM;

  /* BusSelector: '<S5>/Bus Selector7' */
  rtb_rLX2_inLimitSetup_Time = LX2_B.BusInput1.rLX2_inLimitSetup_Time;

  /* Gain: '<S7>/Gain3' incorporates:
   *  BusSelector: '<S5>/Bus Selector7'
   *  DataTypeConversion: '<S7>/Data Type Conversion2'
   *  Product: '<S7>/RateLimit_multiplier'
   */
  rtb_Gain3 = rtb_Switch7 * (real32_T)LX2_B.BusInput1.iCtrl_RateLimit_TraceBack *
    0.001F;

  /* Product: '<S41>/delta rise limit' incorporates:
   *  SampleTimeMath: '<S41>/sample time'
   *
   * About '<S41>/sample time':
   *  y = K where K = ( w * Ts )
   */
  rtb_Switch2_kt = rtb_Gain3 * 0.1F;

  /* UnitDelay: '<S7>/Unit Delay3' */
  rtb_UnitDelay3 = LX2_DWork.UnitDelay3_DSTATE;

  /* S-Function (bur_bus_in): '<Root>/Bus Input2' */
  LX2_B.BusInput2 = inst->PARA;

  /* BusSelector: '<S51>/Bus Selector4' */
  rtb_rPr_Leanox_Dev = LX2_B.BusInput.rPr_Leanox_Dev;
  rtb_rP_Set_Norm = LX2_B.BusInput.rP_Set_Norm;

  /* BusSelector: '<S51>/Bus Selector5' */
  rtb_iFiltConst_LeanoxDev_Steady =
    LX2_B.BusInput1.iFiltConst_LeanoxDev_SteadyState;
  rtb_iFiltConst_P_set_SteadyStat = LX2_B.BusInput1.iFiltConst_P_set_SteadyState;

  /* Logic: '<S51>/Logical Operator1' */
  rtb_LogicalOperator1 = !LX2_B.BusInput.bLX2_active;

  /* Outputs for Atomic SubSystem: '<S51>/Filter' */
  LX2_Filter1(rtb_iFiltConst_LeanoxDev_Steady, rtb_LogicalOperator1,
              rtb_rPr_Leanox_Dev, &LX2_B.Filter, &LX2_DWork.Filter, inst);

  /* End of Outputs for SubSystem: '<S51>/Filter' */

  /* RelationalOperator: '<S51>/ ' incorporates:
   *  Abs: '<S51>/Abs'
   *  Product: '<S51>/Thres'
   */
  rtb_u = ((real32_T)fabs(LX2_B.Filter.Switch) <=
           LX2_B.BusInput1.rThreshold_LeanoxDev_SteadyState *
           LX2_B.BusInput2.rLX2_SteadyStateFactor);

  /* Logic: '<S51>/Logical Operator3' */
  rtb_LogicalOperator3 = !LX2_B.BusInput.bLX2_active;

  /* Outputs for Atomic SubSystem: '<S51>/Filter1' */
  LX2_Filter1(rtb_iFiltConst_P_set_SteadyStat, rtb_LogicalOperator3,
              rtb_rP_Set_Norm, &LX2_B.Filter1, &LX2_DWork.Filter1, inst);

  /* End of Outputs for SubSystem: '<S51>/Filter1' */

  /* Sum: '<S51>/Sum2' */
  rtb_Switch7 = LX2_B.Filter1.Switch - rtb_rP_Set_Norm;

  /* Abs: '<S51>/Abs1' */
  rtb_Switch7 = (real32_T)fabs(rtb_Switch7);

  /* RelationalOperator: '<S51>/   ' incorporates:
   *  Product: '<S51>/Thres1'
   */
  rtb_u_b = (rtb_Switch7 <= LX2_B.BusInput1.rThreshold_P_set_SteadyState *
             LX2_B.BusInput2.rLX2_SteadyStateFactor);

  /* Logic: '<S51>/Logical Operator2' incorporates:
   *  Logic: '<S51>/Logical Operator4'
   */
  rtb_LogicalOperator2 = (LX2_B.BusInput.bLX2_active && rtb_u && rtb_u_b &&
    (!LX2_B.BusInput.bExt_SteadyState_Loss));

  /* Outputs for Atomic SubSystem: '<S51>/TON' */
  /* Logic: '<S59>/Logical Operator2' */
  rtb_LogicalOperator2_de = !rtb_LogicalOperator2;

  /* DiscreteIntegrator: '<S59>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_de || (LX2_DWork.DiscreteTimeIntegrator_PrevRe_m != 0))
  {
    LX2_DWork.DiscreteTimeIntegrator_DSTATE_l = 0U;
  }

  /* RelationalOperator: '<S59>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S59>/Discrete-Time Integrator'
   */
  tmp_0 = (uint32_T)LX2_DWork.DiscreteTimeIntegrator_DSTATE_l * 52429U;
  rtb_RelationalOperator_b = (((tmp_0 & 4U) != 0U) + (tmp_0 >> 3) >= ((uint32_T)
    LX2_B.BusInput1.iTiDelay_SteadyState << 16));

  /* Logic: '<S59>/Logical Operator3' */
  rtb_LogicalOperator3_e = (rtb_RelationalOperator_b && rtb_LogicalOperator2);

  /* Update for DiscreteIntegrator: '<S59>/Discrete-Time Integrator' incorporates:
   *  Logic: '<S59>/Logical Operator'
   *  Logic: '<S59>/Logical Operator1'
   */
  LX2_DWork.DiscreteTimeIntegrator_DSTATE_l = (uint16_T)((uint32_T)
    ((!rtb_RelationalOperator_b) && rtb_LogicalOperator2) + (uint32_T)
    LX2_DWork.DiscreteTimeIntegrator_DSTATE_l);
  if (rtb_LogicalOperator2_de) {
    LX2_DWork.DiscreteTimeIntegrator_PrevRe_m = 1;
  } else {
    LX2_DWork.DiscreteTimeIntegrator_PrevRe_m = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S59>/Discrete-Time Integrator' */
  /* End of Outputs for SubSystem: '<S51>/TON' */

  /* MATLAB Function: '<S8>/MATLAB Function' incorporates:
   *  Constant: '<S65>/Constant'
   *  Logic: '<S52>/Logical Operator'
   *  Logic: '<S52>/Logical Operator10'
   *  RelationalOperator: '<S65>/Compare'
   */
  /* MATLAB Function 'Leanox 2.0/STM/MATLAB Function': '<S53>:1' */
  /* % Header */
  /*  This Function controls the features of LX2, like saving the map, gasmixing, enabling/disabling, timer, etc., */
  /*  depending on various inputs. */
  /*  Rev 1 : Christian Schneider, 24.08.2018 */
  /*  Rev 1.1 : Enrico Maran, 17.10.2019, Removed bLeanox_Adjust input/use */
  /*  Rev 1.2 : Enrico Maran, 17.02.2021, Removed closed loop freezing if bEng_misfire; added external interface for BPOC learning stop */
  /*  */
  /* % LX2 State Machine */
  /*  -> LEANOX 2.0 is OFF */
  if ((!LX2_B.BusInput2.bLX2_enable) || (!LX2_B.BusInput.bLX2_active)) {
    /*  LX2 off */
    /*  function undesired_operating */
    /* % function my_gasmixing <<LX2_FunReq-26>> */
    /*  define output vectors */
    /*  undefined Gastype */
    rtb_splitfactor_Gas[0] = 0.0F;
    rtb_splitfactor_Gas[1] = 0.0F;
    rtb_splitfactor_Gas[2] = 0.0F;
    rtb_splitfactor_Gas[3] = 0.0F;
    tmp[0] = 1.0F;
    tmp[1] = 1.0F;
    LX2_my_BPOC_enable_h(rtb_splitfactor_Gas, FALSE, tmp,
                         LX2_B.BusInput.bExt_BPOC_learning_Stop,
                         rtb_bBPOC_enable_a, rtb_bSave_BPOC_enable, inst);
    bCtrl_enable = FALSE;

    /*  NOx controler enable */
    bCtrl_freeze = TRUE;

    /*  freeze NOx controler output */
    b_bEng_knock = FALSE;
    bEng_misfire = FALSE;

    /*  -> LEANOX 2.0 is ON */
  } else if ((!LX2_B.BusInput.bLeanox_Engine_Man) && (rtb_LogicalOperator3_e &&
              LX2_B.BusInput.bNOx_valid && (!LX2_B.BusInput.bESC_active) &&
              (LX2_B.BusInput.rNOx_act >= 10.0F))) {
    /*  Engine in Leanox Auto Mode */
    /*              bBPOC_enable_Gas1=true;  */
    /*              bSave_BPOC_enable_Gas1=true; */
    LX2_my_gasmixing(LX2_B.BusInput.iIdx_Gtyp_Dem,
                     LX2_B.BusInput.rGT_QualMix_1_2, LX2_B.BusInput.rGT_RatioMix,
                     TRUE, LX2_B.BusInput1.rThreshold_save2map,
                     LX2_B.BusInput.bExt_BPOC_learning_Stop, rtb_splitfactor_Gas,
                     rtb_bBPOC_enable_a, rtb_bSave_BPOC_enable, inst);
    bCtrl_enable = TRUE;

    /* % function Misfire and Knocking handlig at LX2 */
    if (LX2_B.BusInput.rKnock_level <= LX2_B.BusInput1.rThreshold_knock) {
      b_bEng_knock = FALSE;
    } else {
      b_bEng_knock = TRUE;
    }

    if (LX2_B.BusInput.rMisfire_level <= LX2_B.BusInput1.rThreshold_misfire) {
      bEng_misfire = FALSE;
    } else {
      bEng_misfire = TRUE;
    }

    bCtrl_freeze = b_bEng_knock;
  } else {
    /*  Engine in Leanox Manuel Mode >or< not allowed to act -> freeze output of LX2 and do not update BPOC */
    LX2_my_gasmixing(LX2_B.BusInput.iIdx_Gtyp_Dem,
                     LX2_B.BusInput.rGT_QualMix_1_2, LX2_B.BusInput.rGT_RatioMix,
                     FALSE, LX2_B.BusInput1.rThreshold_save2map,
                     LX2_B.BusInput.bExt_BPOC_learning_Stop, rtb_splitfactor_Gas,
                     rtb_bBPOC_enable_a, rtb_bSave_BPOC_enable, inst);
    bCtrl_enable = FALSE;
    bCtrl_freeze = TRUE;
    b_bEng_knock = FALSE;
    bEng_misfire = FALSE;
  }

  /* Switch: '<S7>/Switch7' incorporates:
   *  Gain: '<S7>/mbar2bar1'
   *  MATLAB Function: '<S8>/MATLAB Function'
   */
  /* '<S53>:1:4' */
  if (bEng_misfire) {
    rtb_Switch7 = rtb_UnitDelay3;
  } else {
    rtb_Switch7 = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;
  }

  /* End of Switch: '<S7>/Switch7' */

  /* BusSelector: '<S5>/Bus Selector2' */
  rtb_Switch_nq = LX2_B.BusInput2.rLX2_Ctrl_Tn;

  /* RelationalOperator: '<S32>/Compare' incorporates:
   *  BusSelector: '<S5>/Bus Selector2'
   *  Constant: '<S32>/Constant'
   */
  rtb_Compare_n = (LX2_B.BusInput2.rLX2_Ctrl_Tn <= 0.0F);

  /* BusSelector: '<S5>/Bus Selector4' */
  rtb_rNOx_act_g = LX2_B.BusInput.rNOx_act;

  /* Logic: '<S5>/Logical Operator6' */
  rtb_LogicalOperator6_a = !LX2_B.BusInput.bLX2_active;

  /* UnitDelay: '<S7>/Unit Delay1' */
  rtb_UnitDelay1 = LX2_DWork.UnitDelay1_DSTATE;

  /* Logic: '<S52>/Logical Operator11' incorporates:
   *  Logic: '<S52>/Logical Operator5'
   *  Logic: '<S52>/Logical Operator6'
   *  Logic: '<S52>/Logical Operator7'
   *  Logic: '<S52>/Logical Operator8'
   *  UnitDelay: '<S52>/Unit Delay1'
   */
  rtb_LogicalOperator_f = (LX2_DWork.UnitDelay1_DSTATE_l ||
    (((!LX2_B.BusInput2.bLX2_enable) || (!LX2_B.BusInput.bLX2_active)) &&
     LX2_B.BusInput.bBPOC_reset));

  /* Logic: '<S54>/Logical Operator4' incorporates:
   *  Logic: '<S54>/Logical Operator1'
   *  Logic: '<S54>/Logical Operator27'
   *  Logic: '<S54>/Logical Operator3'
   *  UnitDelay: '<S54>/Unit Delay'
   */
  rtb_LogicalOperator4_n = ((!LX2_DWork.UnitDelay_DSTATE_l) &&
    (!rtb_LogicalOperator_f) && (rtb_bSave_BPOC_enable[0] ||
    rtb_bSave_BPOC_enable[1] || rtb_bSave_BPOC_enable[2] ||
    rtb_bSave_BPOC_enable[3]));

  /* DataTypeConversion: '<S54>/Data Type Conversion' incorporates:
   *  BusSelector: '<S54>/Bus Selector5'
   */
  rtb_DataTypeConversion = (real32_T)LX2_B.BusInput1.iTiUpdate_BPOC;

  /* Outputs for Atomic SubSystem: '<S54>/TON' */
  LX2_TON(rtb_LogicalOperator4_n, rtb_DataTypeConversion, &LX2_B.TON_p,
          &LX2_DWork.TON_p, inst);

  /* End of Outputs for SubSystem: '<S54>/TON' */

  /* Switch: '<S54>/Switch2' incorporates:
   *  Switch: '<S54>/Switch1'
   */
  if (rtb_LogicalOperator_f) {
    rtb_Switch2_a_idx = TRUE;
    rtb_Switch2_a_idx_0 = TRUE;
    rtb_Switch2_a_idx_1 = TRUE;
    rtb_Switch2_a_idx_2 = TRUE;
  } else if (LX2_B.TON_p.LogicalOperator3) {
    /* Switch: '<S54>/Switch1' */
    rtb_Switch2_a_idx = rtb_bSave_BPOC_enable[0];
    rtb_Switch2_a_idx_0 = rtb_bSave_BPOC_enable[1];
    rtb_Switch2_a_idx_1 = rtb_bSave_BPOC_enable[2];
    rtb_Switch2_a_idx_2 = rtb_bSave_BPOC_enable[3];
  } else {
    rtb_Switch2_a_idx = FALSE;
    rtb_Switch2_a_idx_0 = FALSE;
    rtb_Switch2_a_idx_1 = FALSE;
    rtb_Switch2_a_idx_2 = FALSE;
  }

  /* End of Switch: '<S54>/Switch2' */

  /* Gain: '<S8>/Gain7' */
  rtb_Gain7 = 100.0F * LX2_B.BusInput.rP_Set_Norm;

  /* BusSelector: '<S8>/Bus Selector4' */
  rtb_iFilterConst_P_set = LX2_B.BusInput1.iFilterConst_P_set;

  /* Logic: '<S8>/Logical Operator8' */
  rtb_LogicalOperator8_g = !LX2_B.BusInput.bLX2_active;

  /* Outputs for Atomic SubSystem: '<S8>/Filter1' */
  LX2_Filter1(rtb_iFilterConst_P_set, rtb_LogicalOperator8_g, rtb_Gain7,
              &LX2_B.Filter1_i, &LX2_DWork.Filter1_i, inst);

  /* End of Outputs for SubSystem: '<S8>/Filter1' */

  /* Gain: '<S10>/mbar2bar' */
  rtb_UnitDelay3 = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* Logic: '<S10>/Logical Operator7' incorporates:
   *  Logic: '<S10>/Logical Operator8'
   *  Selector: '<S10>/Selector1'
   */
  rtb_LogicalOperator7_m = ((!rtb_LogicalOperator_f) && rtb_bSave_BPOC_enable[0]);

  /* Logic: '<S10>/Logical Operator2' incorporates:
   *  Logic: '<S10>/Logical Operator3'
   */
  rtb_RelationalOperator_b = ((!rtb_LogicalOperator7_m) || rtb_LogicalOperator_f);

  /* BusSelector: '<S6>/Bus Selector6' */
  for (i = 0; i < 5; i++) {
    rtb_rP_Lp_c[i] = LX2_B.BusInput.rP_Nom[i];
    rtb_rPr_LX2_offset_Lp_c[i] = LX2_B.BusInput.rP_Lp_b[i];
    rtb_rPr_LX2_offset_Lp_a[i] = LX2_B.BusInput.rP_Lp_a[i];
    rtb_rPr_LX2_offset_Lp_b[i] = LX2_B.BusInput.rP_Lp_c[i];
  }

  rtb_bLp_c_ena = LX2_B.BusInput.bLp_c_ena;

  /* End of BusSelector: '<S6>/Bus Selector6' */

  /* Logic: '<S10>/Logical Operator5' */
  rtb_LogicalOperator5_k = !rtb_LogicalOperator_f;

  /* Delay: '<S10>/Delay2' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay2_Reset_ZCE == LX2_POS_ZCSIG) !=
                      rtb_RelationalOperator_b) &&
                     (LX2_PrevZCSigState.Delay2_Reset_ZCE !=
                      LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay2_Reset_ZCE = (uint8_T)rtb_RelationalOperator_b;
  if (rtb_RelationalOperator_b || didZcEventOccur) {
    LX2_DWork.icLoad = 1U;
  }

  for (i = 0; i < 11; i++) {
    if (LX2_DWork.icLoad != 0) {
      /* Switch: '<S10>/Switch5' incorporates:
       *  Constant: '<S10>/Constant5'
       */
      if (rtb_LogicalOperator5_k) {
        LX2_DWork.Delay2_DSTATE[i] = LX2_B.BusInput.rLX2_BPOC_Gas1[i];
      } else {
        LX2_DWork.Delay2_DSTATE[i] = 0.0F;
      }

      /* End of Switch: '<S10>/Switch5' */
    }

    rtb_Delay2[i] = LX2_DWork.Delay2_DSTATE[i];
  }

  /* End of Delay: '<S10>/Delay2' */
  /* Dynamic Look-Up Table Block: '<S10>/Interpolate BPOC_actual'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Selector12), rtb_Delay2,
    LX2_B.Filter1_i.Switch, LX2_ConstP.pooled14, 10U, inst);

  /* UnitDelay: '<S6>/Unit Delay2' */
  rtb_UnitDelay2 = LX2_DWork.UnitDelay2_DSTATE;

  /* Sum: '<S10>/Sum1' incorporates:
   *  Product: '<S10>/Divide4'
   *  Selector: '<S10>/Selector2'
   *  Sum: '<S10>/Sum2'
   *  UnitDelay: '<S6>/Unit Delay2'
   */
  rtb_Sum1 = (LX2_DWork.UnitDelay2_DSTATE - rtb_Selector12) *
    rtb_splitfactor_Gas[0] + rtb_Selector12;

  /* Logic: '<S10>/Logical Operator6' incorporates:
   *  Logic: '<S10>/Logical Operator4'
   */
  rtb_RelationalOperator_b = ((!rtb_LogicalOperator7_m) || rtb_LogicalOperator_f);

  /* Logic: '<S10>/Logical Operator1' */
  rtb_LogicalOperator5_k = !rtb_LogicalOperator_f;

  /* Delay: '<S10>/Delay1' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay1_Reset_ZCE == LX2_POS_ZCSIG) !=
                      rtb_RelationalOperator_b) &&
                     (LX2_PrevZCSigState.Delay1_Reset_ZCE !=
                      LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay1_Reset_ZCE = (uint8_T)rtb_RelationalOperator_b;
  if (rtb_RelationalOperator_b || didZcEventOccur) {
    LX2_DWork.icLoad_o = 1U;
  }

  for (i = 0; i < 11; i++) {
    if (LX2_DWork.icLoad_o != 0) {
      /* Switch: '<S10>/Switch4' incorporates:
       *  Constant: '<S10>/Constant4'
       */
      if (rtb_LogicalOperator5_k) {
        LX2_DWork.Delay1_DSTATE[i] = LX2_B.BusInput.bLX2_BPOC_measured_Gas1[i];
      } else {
        LX2_DWork.Delay1_DSTATE[i] = FALSE;
      }

      /* End of Switch: '<S10>/Switch4' */
    }

    rtb_Delay1[i] = LX2_DWork.Delay1_DSTATE[i];
  }

  /* End of Delay: '<S10>/Delay1' */

  /* Selector: '<S10>/Selector6' incorporates:
   *  Constant: '<S6>/Constant3'
   */
  rtb_Selector12 = rtb_rPr_LX2_offset_Lp_c[1];

  /* Selector: '<S10>/Selector4' incorporates:
   *  Constant: '<S6>/Constant3'
   */
  rtb_Switch2_b = rtb_rP_Lp_c[1];

  /* Abs: '<S16>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Switch2_b);

  /* Switch: '<S16>/Switch' incorporates:
   *  RelationalOperator: '<S16>/Relational Operator'
   */
  if (2.22044605E-16F >= rtb_Abs) {
    rtb_Switch2_b = 2.22044605E-16F;
  }

  /* End of Switch: '<S16>/Switch' */

  /* Gain: '<S10>/Gain1' incorporates:
   *  Constant: '<S6>/Constant3'
   *  Product: '<S10>/Divide'
   *  Selector: '<S10>/Selector12'
   *  Selector: '<S10>/Selector5'
   */
  rtb_Lp2Lp3Lp_c[0] = rtb_Selector12 / rtb_Switch2_b * 100.0F;
  rtb_Lp2Lp3Lp_c[1] = rtb_rPr_LX2_offset_Lp_a[1] / rtb_Switch2_b * 100.0F;
  rtb_Lp2Lp3Lp_c[2] = rtb_rPr_LX2_offset_Lp_b[1] / rtb_Switch2_b * 100.0F;

  /* Gain: '<S6>/SlopeMax_factor' */
  rtb_Abs = 0.01F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* Gain: '<S10>/mbar2bar2' */
  rtb_mbar2bar2 = 0.001F * rtb_Abs;

  /* Gain: '<S6>/SlopeMaxEx_factor' */
  rtb_Switch2_b = 0.003F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* Gain: '<S10>/mbar2bar3' */
  rtb_mbar2bar3 = 0.001F * rtb_Switch2_b;

  /* BusSelector: '<S6>/Bus Selector5' */
  rtb_iWeight_Lp_0kW = LX2_B.BusInput1.iWeight_Lp_0kW;
  rtb_iWeight_Lp_b = LX2_B.BusInput1.iWeight_Lp_b;
  rtb_iWeight_Lp_a = LX2_B.BusInput1.iWeight_Lp_a;
  rtb_iWeight_Lp_c = LX2_B.BusInput1.iWeight_Lp_c;

  /* Gain: '<S10>/mbar2bar4' */
  rtb_mbar2bar4 = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* MATLAB Function: '<S10>/Boost Pressure Offset Curve' */
  LX2_BoostPressureOffsetCurve(LX2_B.Filter1_i.Switch, rtb_Sum1, rtb_Delay2,
    rtb_Delay1, rtb_Lp2Lp3Lp_c, rtb_bLp_c_ena, rtb_mbar2bar2, rtb_mbar2bar3,
    rtb_iWeight_Lp_0kW, rtb_iWeight_Lp_b, rtb_iWeight_Lp_a, rtb_iWeight_Lp_c,
    rtb_mbar2bar4, rtb_LogicalOperator7_m, &LX2_B.sf_BoostPressureOffsetCurve, inst);

  /* Gain: '<S5>/LowerLimit_factor' */
  rtb_LowerLimit_factor = -LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* Gain: '<S10>/mbar2bar1' incorporates:
   *  Gain: '<S5>/LowerLimit_factor'
   */
  rtb_Switch3 = 0.001F * -LX2_B.BusInput2.rPr_LX2_OffsetLimit;
  for (i = 0; i < 11; i++) {
    /* Switch: '<S17>/Switch2' incorporates:
     *  RelationalOperator: '<S17>/LowerRelop1'
     *  RelationalOperator: '<S17>/UpperRelop'
     *  Switch: '<S17>/Switch'
     */
    if (LX2_B.sf_BoostPressureOffsetCurve.OUT_offset[i] > rtb_UnitDelay3) {
      rtb_splitfactor_VISU_idx = rtb_UnitDelay3;
    } else if (LX2_B.sf_BoostPressureOffsetCurve.OUT_offset[i] < rtb_Switch3) {
      /* Switch: '<S17>/Switch' */
      rtb_splitfactor_VISU_idx = rtb_Switch3;
    } else {
      rtb_splitfactor_VISU_idx = LX2_B.sf_BoostPressureOffsetCurve.OUT_offset[i];
    }

    /* Switch: '<S10>/Switch1' incorporates:
     *  Selector: '<S10>/Selector7'
     */
    if (rtb_Switch2_a_idx) {
      rtb_Switch1[i] = rtb_splitfactor_VISU_idx;
    } else {
      rtb_Switch1[i] = LX2_B.BusInput.rLX2_BPOC_Gas1[i];
    }

    /* End of Switch: '<S10>/Switch1' */

    /* Switch: '<S17>/Switch2' */
    rtb_Switch2[i] = rtb_splitfactor_VISU_idx;
  }

  /* Switch: '<S10>/Switch3' incorporates:
   *  Constant: '<S10>/Constant2'
   *  Constant: '<S10>/Constant3'
   *  Selector: '<S10>/Selector3'
   */
  if (rtb_bBPOC_enable_a[0]) {
    /* Dynamic Look-Up Table Block: '<S10>/Interpolate BPOC'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_InterpolateBPOC_a), rtb_Switch1,
      LX2_B.Filter1_i.Switch, LX2_ConstP.pooled14, 10U, inst);
    rtb_Switch3 = rtb_InterpolateBPOC_a;
  } else {
    rtb_Switch3 = 0.0F;
  }

  /* End of Switch: '<S10>/Switch3' */

  /* Gain: '<S11>/mbar2bar' */
  rtb_UnitDelay3 = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* Logic: '<S11>/Logical Operator7' incorporates:
   *  Logic: '<S11>/Logical Operator8'
   *  Selector: '<S11>/Selector1'
   */
  rtb_LogicalOperator7_e = ((!rtb_LogicalOperator_f) && rtb_bSave_BPOC_enable[1]);

  /* Logic: '<S11>/Logical Operator2' incorporates:
   *  Logic: '<S11>/Logical Operator3'
   */
  rtb_RelationalOperator_b = ((!rtb_LogicalOperator7_e) || rtb_LogicalOperator_f);

  /* BusSelector: '<S6>/Bus Selector8' */
  for (i = 0; i < 5; i++) {
    rtb_rPr_LX2_offset_Lp_b[i] = LX2_B.BusInput.rP_Nom[i];
    rtb_rPr_LX2_offset_Lp_a[i] = LX2_B.BusInput.rP_Lp_b[i];
    rtb_rPr_LX2_offset_Lp_c[i] = LX2_B.BusInput.rP_Lp_a[i];
    rtb_rP_Lp_c[i] = LX2_B.BusInput.rP_Lp_c[i];
  }

  rtb_bLp_c_ena_i = LX2_B.BusInput.bLp_c_ena;

  /* End of BusSelector: '<S6>/Bus Selector8' */

  /* Logic: '<S11>/Logical Operator5' */
  rtb_LogicalOperator5_k = !rtb_LogicalOperator_f;

  /* Delay: '<S11>/Delay2' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay2_Reset_ZCE_o == LX2_POS_ZCSIG)
                      != rtb_RelationalOperator_b) &&
                     (LX2_PrevZCSigState.Delay2_Reset_ZCE_o !=
                      LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay2_Reset_ZCE_o = (uint8_T)rtb_RelationalOperator_b;
  if (rtb_RelationalOperator_b || didZcEventOccur) {
    LX2_DWork.icLoad_or = 1U;
  }

  for (i = 0; i < 11; i++) {
    if (LX2_DWork.icLoad_or != 0) {
      /* Switch: '<S11>/Switch5' incorporates:
       *  Constant: '<S11>/Constant5'
       */
      if (rtb_LogicalOperator5_k) {
        LX2_DWork.Delay2_DSTATE_j[i] = LX2_B.BusInput.rLX2_BPOC_Gas2[i];
      } else {
        LX2_DWork.Delay2_DSTATE_j[i] = 0.0F;
      }

      /* End of Switch: '<S11>/Switch5' */
    }

    rtb_Delay2_e[i] = LX2_DWork.Delay2_DSTATE_j[i];
  }

  /* End of Delay: '<S11>/Delay2' */
  /* Dynamic Look-Up Table Block: '<S11>/Interpolate BPOC_actual'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Selector12), rtb_Delay2_e,
    LX2_B.Filter1_i.Switch, LX2_ConstP.pooled14, 10U, inst);

  /* Sum: '<S11>/Sum1' incorporates:
   *  Product: '<S11>/Divide4'
   *  Selector: '<S11>/Selector2'
   *  Sum: '<S11>/Sum2'
   */
  rtb_Sum1_e = (rtb_UnitDelay2 - rtb_Selector12) * rtb_splitfactor_Gas[1] +
    rtb_Selector12;

  /* Logic: '<S11>/Logical Operator6' incorporates:
   *  Logic: '<S11>/Logical Operator4'
   */
  rtb_RelationalOperator_b = ((!rtb_LogicalOperator7_e) || rtb_LogicalOperator_f);

  /* Logic: '<S11>/Logical Operator1' */
  rtb_LogicalOperator5_k = !rtb_LogicalOperator_f;

  /* Delay: '<S11>/Delay1' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay1_Reset_ZCE_n == LX2_POS_ZCSIG)
                      != rtb_RelationalOperator_b) &&
                     (LX2_PrevZCSigState.Delay1_Reset_ZCE_n !=
                      LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay1_Reset_ZCE_n = (uint8_T)rtb_RelationalOperator_b;
  if (rtb_RelationalOperator_b || didZcEventOccur) {
    LX2_DWork.icLoad_oj = 1U;
  }

  for (i = 0; i < 11; i++) {
    if (LX2_DWork.icLoad_oj != 0) {
      /* Switch: '<S11>/Switch4' incorporates:
       *  Constant: '<S11>/Constant4'
       */
      if (rtb_LogicalOperator5_k) {
        LX2_DWork.Delay1_DSTATE_l[i] = LX2_B.BusInput.bLX2_BPOC_measured_Gas2[i];
      } else {
        LX2_DWork.Delay1_DSTATE_l[i] = FALSE;
      }

      /* End of Switch: '<S11>/Switch4' */
    }

    rtb_Delay1_g[i] = LX2_DWork.Delay1_DSTATE_l[i];
  }

  /* End of Delay: '<S11>/Delay1' */

  /* Selector: '<S11>/Selector6' incorporates:
   *  Constant: '<S6>/Constant1'
   */
  rtb_Selector12 = rtb_rPr_LX2_offset_Lp_a[2];

  /* Selector: '<S11>/Selector12' incorporates:
   *  Constant: '<S6>/Constant1'
   */
  rtb_Divide = rtb_rP_Lp_c[2];

  /* Selector: '<S11>/Selector4' incorporates:
   *  Constant: '<S6>/Constant1'
   */
  rtb_Switch2_l = rtb_rPr_LX2_offset_Lp_b[2];

  /* Switch: '<S20>/Switch' incorporates:
   *  Abs: '<S20>/Abs'
   *  RelationalOperator: '<S20>/Relational Operator'
   */
  if (2.22044605E-16F >= (real32_T)fabs(rtb_Switch2_l)) {
    rtb_Switch2_l = 2.22044605E-16F;
  }

  /* End of Switch: '<S20>/Switch' */

  /* Gain: '<S11>/Gain1' incorporates:
   *  Constant: '<S6>/Constant1'
   *  Product: '<S11>/Divide'
   *  Selector: '<S11>/Selector5'
   */
  rtb_Lp2Lp3Lp_c_n[0] = rtb_Selector12 / rtb_Switch2_l * 100.0F;
  rtb_Lp2Lp3Lp_c_n[1] = rtb_rPr_LX2_offset_Lp_c[2] / rtb_Switch2_l * 100.0F;
  rtb_Lp2Lp3Lp_c_n[2] = rtb_Divide / rtb_Switch2_l * 100.0F;

  /* Gain: '<S11>/mbar2bar2' */
  rtb_mbar2bar2_e = 0.001F * rtb_Abs;

  /* Gain: '<S11>/mbar2bar3' */
  rtb_mbar2bar3_h = 0.001F * rtb_Switch2_b;

  /* BusSelector: '<S6>/Bus Selector7' */
  rtb_iWeight_Lp_0kW_e = LX2_B.BusInput1.iWeight_Lp_0kW;
  rtb_iWeight_Lp_b_c = LX2_B.BusInput1.iWeight_Lp_b;
  rtb_iWeight_Lp_a_m = LX2_B.BusInput1.iWeight_Lp_a;
  rtb_iWeight_Lp_c_m = LX2_B.BusInput1.iWeight_Lp_c;

  /* Gain: '<S11>/mbar2bar4' */
  rtb_mbar2bar4_m = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* MATLAB Function: '<S11>/Boost Pressure Offset Curve' */
  LX2_BoostPressureOffsetCurve(LX2_B.Filter1_i.Switch, rtb_Sum1_e, rtb_Delay2_e,
    rtb_Delay1_g, rtb_Lp2Lp3Lp_c_n, rtb_bLp_c_ena_i, rtb_mbar2bar2_e,
    rtb_mbar2bar3_h, rtb_iWeight_Lp_0kW_e, rtb_iWeight_Lp_b_c,
    rtb_iWeight_Lp_a_m, rtb_iWeight_Lp_c_m, rtb_mbar2bar4_m,
    rtb_LogicalOperator7_e, &LX2_B.sf_BoostPressureOffsetCurve_f, inst);

  /* Gain: '<S11>/mbar2bar1' */
  rtb_SumofElements2 = 0.001F * rtb_LowerLimit_factor;
  for (i = 0; i < 11; i++) {
    /* Switch: '<S21>/Switch2' incorporates:
     *  RelationalOperator: '<S21>/LowerRelop1'
     *  RelationalOperator: '<S21>/UpperRelop'
     *  Switch: '<S21>/Switch'
     */
    if (LX2_B.sf_BoostPressureOffsetCurve_f.OUT_offset[i] > rtb_UnitDelay3) {
      rtb_splitfactor_VISU_idx = rtb_UnitDelay3;
    } else if (LX2_B.sf_BoostPressureOffsetCurve_f.OUT_offset[i] <
               rtb_SumofElements2) {
      /* Switch: '<S21>/Switch' */
      rtb_splitfactor_VISU_idx = rtb_SumofElements2;
    } else {
      rtb_splitfactor_VISU_idx =
        LX2_B.sf_BoostPressureOffsetCurve_f.OUT_offset[i];
    }

    /* Switch: '<S11>/Switch1' incorporates:
     *  Selector: '<S11>/Selector7'
     */
    if (rtb_Switch2_a_idx_0) {
      rtb_Switch1_m[i] = rtb_splitfactor_VISU_idx;
    } else {
      rtb_Switch1_m[i] = LX2_B.BusInput.rLX2_BPOC_Gas2[i];
    }

    /* End of Switch: '<S11>/Switch1' */

    /* Switch: '<S21>/Switch2' */
    rtb_Switch2_j[i] = rtb_splitfactor_VISU_idx;
  }

  /* Switch: '<S11>/Switch3' incorporates:
   *  Constant: '<S11>/Constant2'
   *  Constant: '<S11>/Constant3'
   *  Selector: '<S11>/Selector3'
   */
  if (rtb_bBPOC_enable_a[1]) {
    /* Dynamic Look-Up Table Block: '<S11>/Interpolate BPOC'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_InterpolateBPOC_h), rtb_Switch1_m,
      LX2_B.Filter1_i.Switch, LX2_ConstP.pooled14, 10U, inst);
    rtb_SumofElements2 = rtb_InterpolateBPOC_h;
  } else {
    rtb_SumofElements2 = 0.0F;
  }

  /* End of Switch: '<S11>/Switch3' */

  /* Gain: '<S12>/mbar2bar' */
  rtb_Switch2_l = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* Logic: '<S12>/Logical Operator7' incorporates:
   *  Logic: '<S12>/Logical Operator8'
   *  Selector: '<S12>/Selector1'
   */
  rtb_LogicalOperator7_l = ((!rtb_LogicalOperator_f) && rtb_bSave_BPOC_enable[2]);

  /* Logic: '<S12>/Logical Operator2' incorporates:
   *  Logic: '<S12>/Logical Operator3'
   */
  rtb_RelationalOperator_b = ((!rtb_LogicalOperator7_l) || rtb_LogicalOperator_f);

  /* BusSelector: '<S6>/Bus Selector10' */
  for (i = 0; i < 5; i++) {
    rtb_rPr_LX2_offset_Lp_b[i] = LX2_B.BusInput.rP_Nom[i];
    rtb_rPr_LX2_offset_Lp_a[i] = LX2_B.BusInput.rP_Lp_b[i];
    rtb_rPr_LX2_offset_Lp_c[i] = LX2_B.BusInput.rP_Lp_a[i];
    rtb_rP_Lp_c[i] = LX2_B.BusInput.rP_Lp_c[i];
  }

  rtb_bLp_c_ena_h = LX2_B.BusInput.bLp_c_ena;

  /* End of BusSelector: '<S6>/Bus Selector10' */

  /* Logic: '<S12>/Logical Operator5' */
  rtb_LogicalOperator5_k = !rtb_LogicalOperator_f;

  /* Delay: '<S12>/Delay2' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay2_Reset_ZCE_or == LX2_POS_ZCSIG)
                      != rtb_RelationalOperator_b) &&
                     (LX2_PrevZCSigState.Delay2_Reset_ZCE_or !=
                      LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay2_Reset_ZCE_or = (uint8_T)rtb_RelationalOperator_b;
  if (rtb_RelationalOperator_b || didZcEventOccur) {
    LX2_DWork.icLoad_p = 1U;
  }

  for (i = 0; i < 11; i++) {
    if (LX2_DWork.icLoad_p != 0) {
      /* Switch: '<S12>/Switch5' incorporates:
       *  Constant: '<S12>/Constant5'
       */
      if (rtb_LogicalOperator5_k) {
        LX2_DWork.Delay2_DSTATE_b[i] = LX2_B.BusInput.rLX2_BPOC_Gas3[i];
      } else {
        LX2_DWork.Delay2_DSTATE_b[i] = 0.0F;
      }

      /* End of Switch: '<S12>/Switch5' */
    }

    rtb_Delay2_o[i] = LX2_DWork.Delay2_DSTATE_b[i];
  }

  /* End of Delay: '<S12>/Delay2' */
  /* Dynamic Look-Up Table Block: '<S12>/Interpolate BPOC_actual'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Divide), rtb_Delay2_o, LX2_B.Filter1_i.Switch,
    LX2_ConstP.pooled14, 10U, inst);

  /* Sum: '<S12>/Sum1' incorporates:
   *  Product: '<S12>/Divide4'
   *  Selector: '<S12>/Selector2'
   *  Sum: '<S12>/Sum2'
   */
  rtb_Sum1_b = (rtb_UnitDelay2 - rtb_Divide) * rtb_splitfactor_Gas[2] +
    rtb_Divide;

  /* Logic: '<S12>/Logical Operator6' incorporates:
   *  Logic: '<S12>/Logical Operator4'
   */
  rtb_RelationalOperator_b = ((!rtb_LogicalOperator7_l) || rtb_LogicalOperator_f);

  /* Logic: '<S12>/Logical Operator1' */
  rtb_LogicalOperator5_k = !rtb_LogicalOperator_f;

  /* Delay: '<S12>/Delay1' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay1_Reset_ZCE_e == LX2_POS_ZCSIG)
                      != rtb_RelationalOperator_b) &&
                     (LX2_PrevZCSigState.Delay1_Reset_ZCE_e !=
                      LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay1_Reset_ZCE_e = (uint8_T)rtb_RelationalOperator_b;
  if (rtb_RelationalOperator_b || didZcEventOccur) {
    LX2_DWork.icLoad_d = 1U;
  }

  for (i = 0; i < 11; i++) {
    if (LX2_DWork.icLoad_d != 0) {
      /* Switch: '<S12>/Switch4' incorporates:
       *  Constant: '<S12>/Constant4'
       */
      if (rtb_LogicalOperator5_k) {
        LX2_DWork.Delay1_DSTATE_o[i] = LX2_B.BusInput.bLX2_BPOC_measured_Gas3[i];
      } else {
        LX2_DWork.Delay1_DSTATE_o[i] = FALSE;
      }

      /* End of Switch: '<S12>/Switch4' */
    }

    rtb_Delay1_l[i] = LX2_DWork.Delay1_DSTATE_o[i];
  }

  /* End of Delay: '<S12>/Delay1' */

  /* Selector: '<S12>/Selector6' incorporates:
   *  Constant: '<S6>/Constant5'
   */
  rtb_Divide = rtb_rPr_LX2_offset_Lp_a[3];

  /* Selector: '<S12>/Selector12' incorporates:
   *  Constant: '<S6>/Constant5'
   */
  rtb_Selector12 = rtb_rP_Lp_c[3];

  /* Switch: '<S24>/Switch' incorporates:
   *  Abs: '<S24>/Abs'
   *  Constant: '<S6>/Constant5'
   *  RelationalOperator: '<S24>/Relational Operator'
   *  Selector: '<S12>/Selector4'
   */
  if (2.22044605E-16F >= (real32_T)fabs(rtb_rPr_LX2_offset_Lp_b[3])) {
    rtb_UnitDelay3 = 2.22044605E-16F;
  } else {
    rtb_UnitDelay3 = rtb_rPr_LX2_offset_Lp_b[3];
  }

  /* End of Switch: '<S24>/Switch' */

  /* Gain: '<S12>/Gain1' incorporates:
   *  Constant: '<S6>/Constant5'
   *  Product: '<S12>/Divide'
   *  Selector: '<S12>/Selector5'
   */
  rtb_Lp2Lp3Lp_c_l[0] = rtb_Divide / rtb_UnitDelay3 * 100.0F;
  rtb_Lp2Lp3Lp_c_l[1] = rtb_rPr_LX2_offset_Lp_c[3] / rtb_UnitDelay3 * 100.0F;
  rtb_Lp2Lp3Lp_c_l[2] = rtb_Selector12 / rtb_UnitDelay3 * 100.0F;

  /* Gain: '<S12>/mbar2bar2' */
  rtb_mbar2bar2_o = 0.001F * rtb_Abs;

  /* Gain: '<S12>/mbar2bar3' */
  rtb_mbar2bar3_o = 0.001F * rtb_Switch2_b;

  /* BusSelector: '<S6>/Bus Selector9' */
  rtb_iWeight_Lp_0kW_d = LX2_B.BusInput1.iWeight_Lp_0kW;
  rtb_iWeight_Lp_b_a = LX2_B.BusInput1.iWeight_Lp_b;
  rtb_iWeight_Lp_a_j = LX2_B.BusInput1.iWeight_Lp_a;
  rtb_iWeight_Lp_c_f = LX2_B.BusInput1.iWeight_Lp_c;

  /* Gain: '<S12>/mbar2bar4' */
  rtb_mbar2bar4_e = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* MATLAB Function: '<S12>/Boost Pressure Offset Curve' */
  LX2_BoostPressureOffsetCurve(LX2_B.Filter1_i.Switch, rtb_Sum1_b, rtb_Delay2_o,
    rtb_Delay1_l, rtb_Lp2Lp3Lp_c_l, rtb_bLp_c_ena_h, rtb_mbar2bar2_o,
    rtb_mbar2bar3_o, rtb_iWeight_Lp_0kW_d, rtb_iWeight_Lp_b_a,
    rtb_iWeight_Lp_a_j, rtb_iWeight_Lp_c_f, rtb_mbar2bar4_e,
    rtb_LogicalOperator7_l, &LX2_B.sf_BoostPressureOffsetCurve_d, inst);

  /* Gain: '<S12>/mbar2bar1' */
  rtb_SumofElements1 = 0.001F * rtb_LowerLimit_factor;
  for (i = 0; i < 11; i++) {
    /* Switch: '<S25>/Switch2' incorporates:
     *  RelationalOperator: '<S25>/LowerRelop1'
     *  RelationalOperator: '<S25>/UpperRelop'
     *  Switch: '<S25>/Switch'
     */
    if (LX2_B.sf_BoostPressureOffsetCurve_d.OUT_offset[i] > rtb_Switch2_l) {
      rtb_splitfactor_VISU_idx = rtb_Switch2_l;
    } else if (LX2_B.sf_BoostPressureOffsetCurve_d.OUT_offset[i] <
               rtb_SumofElements1) {
      /* Switch: '<S25>/Switch' */
      rtb_splitfactor_VISU_idx = rtb_SumofElements1;
    } else {
      rtb_splitfactor_VISU_idx =
        LX2_B.sf_BoostPressureOffsetCurve_d.OUT_offset[i];
    }

    /* Switch: '<S12>/Switch1' incorporates:
     *  Selector: '<S12>/Selector7'
     */
    if (rtb_Switch2_a_idx_1) {
      rtb_Switch1_i[i] = rtb_splitfactor_VISU_idx;
    } else {
      rtb_Switch1_i[i] = LX2_B.BusInput.rLX2_BPOC_Gas3[i];
    }

    /* End of Switch: '<S12>/Switch1' */

    /* Switch: '<S25>/Switch2' */
    rtb_Switch2_k[i] = rtb_splitfactor_VISU_idx;
  }

  /* Switch: '<S12>/Switch3' incorporates:
   *  Constant: '<S12>/Constant2'
   *  Constant: '<S12>/Constant3'
   *  Selector: '<S12>/Selector3'
   */
  if (rtb_bBPOC_enable_a[2]) {
    /* Dynamic Look-Up Table Block: '<S12>/Interpolate BPOC'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_InterpolateBPOC_k), rtb_Switch1_i,
      LX2_B.Filter1_i.Switch, LX2_ConstP.pooled14, 10U, inst);
    rtb_SumofElements1 = rtb_InterpolateBPOC_k;
  } else {
    rtb_SumofElements1 = 0.0F;
  }

  /* End of Switch: '<S12>/Switch3' */

  /* Gain: '<S13>/mbar2bar' */
  rtb_Switch2_l = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* Logic: '<S13>/Logical Operator7' incorporates:
   *  Logic: '<S13>/Logical Operator8'
   *  Selector: '<S13>/Selector1'
   */
  rtb_LogicalOperator7_i = ((!rtb_LogicalOperator_f) && rtb_bSave_BPOC_enable[3]);

  /* Logic: '<S13>/Logical Operator2' incorporates:
   *  Logic: '<S13>/Logical Operator3'
   */
  rtb_RelationalOperator_b = ((!rtb_LogicalOperator7_i) || rtb_LogicalOperator_f);

  /* BusSelector: '<S6>/Bus Selector11' */
  for (i = 0; i < 5; i++) {
    rtb_rPr_LX2_offset_Lp_b[i] = LX2_B.BusInput.rP_Nom[i];
    rtb_rPr_LX2_offset_Lp_a[i] = LX2_B.BusInput.rP_Lp_b[i];
    rtb_rPr_LX2_offset_Lp_c[i] = LX2_B.BusInput.rP_Lp_a[i];
    rtb_rP_Lp_c[i] = LX2_B.BusInput.rP_Lp_c[i];
  }

  rtb_bLp_c_ena_n = LX2_B.BusInput.bLp_c_ena;

  /* End of BusSelector: '<S6>/Bus Selector11' */

  /* Logic: '<S13>/Logical Operator5' */
  rtb_LogicalOperator5_k = !rtb_LogicalOperator_f;

  /* Delay: '<S13>/Delay2' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay2_Reset_ZCE_k == LX2_POS_ZCSIG)
                      != rtb_RelationalOperator_b) &&
                     (LX2_PrevZCSigState.Delay2_Reset_ZCE_k !=
                      LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay2_Reset_ZCE_k = (uint8_T)rtb_RelationalOperator_b;
  if (rtb_RelationalOperator_b || didZcEventOccur) {
    LX2_DWork.icLoad_f = 1U;
  }

  for (i = 0; i < 11; i++) {
    if (LX2_DWork.icLoad_f != 0) {
      /* Switch: '<S13>/Switch5' incorporates:
       *  Constant: '<S13>/Constant5'
       */
      if (rtb_LogicalOperator5_k) {
        LX2_DWork.Delay2_DSTATE_d[i] = LX2_B.BusInput.rLX2_BPOC_Gas4[i];
      } else {
        LX2_DWork.Delay2_DSTATE_d[i] = 0.0F;
      }

      /* End of Switch: '<S13>/Switch5' */
    }

    rtb_Delay2_o1[i] = LX2_DWork.Delay2_DSTATE_d[i];
  }

  /* End of Delay: '<S13>/Delay2' */
  /* Dynamic Look-Up Table Block: '<S13>/Interpolate BPOC_actual'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Divide), rtb_Delay2_o1, LX2_B.Filter1_i.Switch,
    LX2_ConstP.pooled14, 10U, inst);

  /* Sum: '<S13>/Sum1' incorporates:
   *  Product: '<S13>/Divide4'
   *  Selector: '<S13>/Selector2'
   *  Sum: '<S13>/Sum2'
   */
  rtb_Sum1_h = (rtb_UnitDelay2 - rtb_Divide) * rtb_splitfactor_Gas[3] +
    rtb_Divide;

  /* Logic: '<S13>/Logical Operator6' incorporates:
   *  Logic: '<S13>/Logical Operator4'
   */
  rtb_RelationalOperator_b = ((!rtb_LogicalOperator7_i) || rtb_LogicalOperator_f);

  /* Logic: '<S13>/Logical Operator1' */
  rtb_LogicalOperator5_k = !rtb_LogicalOperator_f;

  /* Delay: '<S13>/Delay1' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay1_Reset_ZCE_k == LX2_POS_ZCSIG)
                      != rtb_RelationalOperator_b) &&
                     (LX2_PrevZCSigState.Delay1_Reset_ZCE_k !=
                      LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay1_Reset_ZCE_k = (uint8_T)rtb_RelationalOperator_b;
  if (rtb_RelationalOperator_b || didZcEventOccur) {
    LX2_DWork.icLoad_c = 1U;
  }

  for (i = 0; i < 11; i++) {
    if (LX2_DWork.icLoad_c != 0) {
      /* Switch: '<S13>/Switch4' incorporates:
       *  Constant: '<S13>/Constant4'
       */
      if (rtb_LogicalOperator5_k) {
        LX2_DWork.Delay1_DSTATE_g[i] = LX2_B.BusInput.bLX2_BPOC_measured_Gas4[i];
      } else {
        LX2_DWork.Delay1_DSTATE_g[i] = FALSE;
      }

      /* End of Switch: '<S13>/Switch4' */
    }

    rtb_Delay1_c[i] = LX2_DWork.Delay1_DSTATE_g[i];
  }

  /* End of Delay: '<S13>/Delay1' */

  /* Selector: '<S13>/Selector6' incorporates:
   *  Constant: '<S6>/Constant8'
   */
  rtb_Divide = rtb_rPr_LX2_offset_Lp_a[4];

  /* Selector: '<S13>/Selector12' incorporates:
   *  Constant: '<S6>/Constant8'
   */
  rtb_Selector12 = rtb_rP_Lp_c[4];

  /* Switch: '<S28>/Switch' incorporates:
   *  Abs: '<S28>/Abs'
   *  Constant: '<S6>/Constant8'
   *  RelationalOperator: '<S28>/Relational Operator'
   *  Selector: '<S13>/Selector4'
   */
  if (2.22044605E-16F >= (real32_T)fabs(rtb_rPr_LX2_offset_Lp_b[4])) {
    rtb_UnitDelay3 = 2.22044605E-16F;
  } else {
    rtb_UnitDelay3 = rtb_rPr_LX2_offset_Lp_b[4];
  }

  /* End of Switch: '<S28>/Switch' */

  /* Gain: '<S13>/Gain1' incorporates:
   *  Constant: '<S6>/Constant8'
   *  Product: '<S13>/Divide'
   *  Selector: '<S13>/Selector5'
   */
  rtb_Lp2Lp3Lp_c_e[0] = rtb_Divide / rtb_UnitDelay3 * 100.0F;
  rtb_Lp2Lp3Lp_c_e[1] = rtb_rPr_LX2_offset_Lp_c[4] / rtb_UnitDelay3 * 100.0F;
  rtb_Lp2Lp3Lp_c_e[2] = rtb_Selector12 / rtb_UnitDelay3 * 100.0F;

  /* Gain: '<S13>/mbar2bar2' */
  rtb_mbar2bar2_m = 0.001F * rtb_Abs;

  /* Gain: '<S13>/mbar2bar3' */
  rtb_mbar2bar3_a = 0.001F * rtb_Switch2_b;

  /* BusSelector: '<S6>/Bus Selector12' */
  rtb_iWeight_Lp_0kW_k = LX2_B.BusInput1.iWeight_Lp_0kW;
  rtb_iWeight_Lp_b_e = LX2_B.BusInput1.iWeight_Lp_b;
  rtb_iWeight_Lp_a_h = LX2_B.BusInput1.iWeight_Lp_a;
  rtb_iWeight_Lp_c_e = LX2_B.BusInput1.iWeight_Lp_c;

  /* Gain: '<S13>/mbar2bar4' */
  rtb_mbar2bar4_g = 0.001F * LX2_B.BusInput2.rPr_LX2_OffsetLimit;

  /* MATLAB Function: '<S13>/Boost Pressure Offset Curve' */
  LX2_BoostPressureOffsetCurve(LX2_B.Filter1_i.Switch, rtb_Sum1_h, rtb_Delay2_o1,
    rtb_Delay1_c, rtb_Lp2Lp3Lp_c_e, rtb_bLp_c_ena_n, rtb_mbar2bar2_m,
    rtb_mbar2bar3_a, rtb_iWeight_Lp_0kW_k, rtb_iWeight_Lp_b_e,
    rtb_iWeight_Lp_a_h, rtb_iWeight_Lp_c_e, rtb_mbar2bar4_g,
    rtb_LogicalOperator7_i, &LX2_B.sf_BoostPressureOffsetCurve_a, inst);

  /* Gain: '<S13>/mbar2bar1' */
  rtb_SumofElements_o = 0.001F * rtb_LowerLimit_factor;
  for (i = 0; i < 11; i++) {
    /* Switch: '<S29>/Switch2' incorporates:
     *  RelationalOperator: '<S29>/LowerRelop1'
     *  RelationalOperator: '<S29>/UpperRelop'
     *  Switch: '<S29>/Switch'
     */
    if (LX2_B.sf_BoostPressureOffsetCurve_a.OUT_offset[i] > rtb_Switch2_l) {
      rtb_splitfactor_VISU_idx = rtb_Switch2_l;
    } else if (LX2_B.sf_BoostPressureOffsetCurve_a.OUT_offset[i] <
               rtb_SumofElements_o) {
      /* Switch: '<S29>/Switch' */
      rtb_splitfactor_VISU_idx = rtb_SumofElements_o;
    } else {
      rtb_splitfactor_VISU_idx =
        LX2_B.sf_BoostPressureOffsetCurve_a.OUT_offset[i];
    }

    /* Switch: '<S13>/Switch1' incorporates:
     *  Selector: '<S13>/Selector7'
     */
    if (rtb_Switch2_a_idx_2) {
      rtb_Switch1_it[i] = rtb_splitfactor_VISU_idx;
    } else {
      rtb_Switch1_it[i] = LX2_B.BusInput.rLX2_BPOC_Gas4[i];
    }

    /* End of Switch: '<S13>/Switch1' */

    /* Switch: '<S29>/Switch2' */
    rtb_Switch2_kq[i] = rtb_splitfactor_VISU_idx;
  }

  /* Switch: '<S13>/Switch3' incorporates:
   *  Constant: '<S13>/Constant2'
   *  Constant: '<S13>/Constant3'
   *  Selector: '<S13>/Selector3'
   */
  if (rtb_bBPOC_enable_a[3]) {
    /* Dynamic Look-Up Table Block: '<S13>/Interpolate BPOC'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_InterpolateBPOC), rtb_Switch1_it,
      LX2_B.Filter1_i.Switch, LX2_ConstP.pooled14, 10U, inst);
    rtb_SumofElements_o = rtb_InterpolateBPOC;
  } else {
    rtb_SumofElements_o = 0.0F;
  }

  /* End of Switch: '<S13>/Switch3' */

  /* Sum: '<S7>/Sum of Elements' incorporates:
   *  Product: '<S7>/Product'
   */
  rtb_SumofElements = ((rtb_Switch3 * rtb_splitfactor_Gas[0] +
                        rtb_SumofElements2 * rtb_splitfactor_Gas[1]) +
                       rtb_SumofElements1 * rtb_splitfactor_Gas[2]) +
    rtb_SumofElements_o * rtb_splitfactor_Gas[3];

  /* MATLAB Function: '<S7>/MATLAB Function' incorporates:
   *  Logic: '<S7>/Logical Operator1'
   *  Logic: '<S7>/Logical Operator2'
   *  Logic: '<S7>/Logical Operator6'
   *  MATLAB Function: '<S8>/MATLAB Function'
   *  SignalConversion: '<S38>/TmpSignal ConversionAt SFunction Inport4'
   *  UnitDelay: '<S7>/Unit Delay5'
   *  UnitDelay: '<S7>/Unit Delay6'
   */
  /* MATLAB Function 'Leanox 2.0/Controller/MATLAB Function': '<S38>:1' */
  if (rtb_Compare_n || rtb_LogicalOperator6_a || (!bCtrl_enable)) {
    /* '<S38>:1:9' */
    /* '<S38>:1:10' */
    rtb_Reset = TRUE;

    /* '<S38>:1:11' */
    b_y = 0.0F;
  } else if (rtb_UnitDelay1) {
    /* '<S38>:1:12' */
    /* '<S38>:1:13' */
    rtb_Reset = TRUE;

    /* '<S38>:1:14' */
    b_y = LX2_DWork.UnitDelay6_DSTATE;
  } else if (rtb_Switch2_a_idx || rtb_Switch2_a_idx_0 || rtb_Switch2_a_idx_1 ||
             rtb_Switch2_a_idx_2) {
    /* '<S38>:1:15' */
    /* '<S38>:1:16' */
    rtb_Reset = TRUE;

    /* '<S38>:1:17' */
    b_y = (LX2_DWork.UnitDelay5_DSTATE - rtb_SumofElements) +
      LX2_DWork.UnitDelay6_DSTATE;
  } else {
    /* '<S38>:1:19' */
    rtb_Reset = FALSE;

    /* '<S38>:1:20' */
    b_y = LX2_DWork.y0_1;
  }

  /* '<S38>:1:22' */
  LX2_DWork.y0_1 = b_y;

  /* DiscreteIntegrator: '<S36>/Discrete-Time Integrator' incorporates:
   *  MATLAB Function: '<S7>/MATLAB Function'
   */
  if (LX2_DWork.DiscreteTimeIntegrator_IC_LOADI != 0) {
    LX2_DWork.DiscreteTimeIntegrator_DSTATE = b_y;
  }

  if (rtb_Reset || (LX2_DWork.DiscreteTimeIntegrator_PrevRese != 0)) {
    LX2_DWork.DiscreteTimeIntegrator_DSTATE = b_y;
  }

  rtb_DiscreteTimeIntegrator = LX2_DWork.DiscreteTimeIntegrator_DSTATE;

  /* Sum: '<S7>/Sum2' incorporates:
   *  DiscreteIntegrator: '<S36>/Discrete-Time Integrator'
   */
  rtb_Sum2_e = LX2_DWork.DiscreteTimeIntegrator_DSTATE + rtb_SumofElements;

  /* Switch: '<S7>/Switch6' incorporates:
   *  Gain: '<S7>/mbar2bar'
   *  MATLAB Function: '<S8>/MATLAB Function'
   *  UnitDelay: '<S7>/Unit Delay4'
   */
  if (b_bEng_knock) {
    rtb_Switch6 = LX2_DWork.UnitDelay4_DSTATE;
  } else {
    rtb_Switch6 = 0.001F * rtb_LowerLimit_factor;
  }

  /* End of Switch: '<S7>/Switch6' */

  /* Switch: '<S39>/Switch2' incorporates:
   *  RelationalOperator: '<S39>/LowerRelop1'
   *  RelationalOperator: '<S39>/UpperRelop'
   *  Switch: '<S39>/Switch'
   */
  if (rtb_Sum2_e > rtb_Switch7) {
    rtb_UnitDelay3 = rtb_Switch7;
  } else if (rtb_Sum2_e < rtb_Switch6) {
    /* Switch: '<S39>/Switch' */
    rtb_UnitDelay3 = rtb_Switch6;
  } else {
    rtb_UnitDelay3 = rtb_Sum2_e;
  }

  /* End of Switch: '<S39>/Switch2' */

  /* Logic: '<S52>/Logical Operator2' */
  rtb_Compare_n = (LX2_B.BusInput.bLeanox_Adjust && LX2_B.BusInput2.bLX2_enable);

  /* Delay: '<S41>/Delay' */
  didZcEventOccur = (((LX2_PrevZCSigState.Delay_Reset_ZCE == LX2_POS_ZCSIG) !=
                      rtb_Compare_n) && (LX2_PrevZCSigState.Delay_Reset_ZCE !=
    LX2_UNINITIALIZED_ZCSIG));
  LX2_PrevZCSigState.Delay_Reset_ZCE = (uint8_T)rtb_Compare_n;
  if (rtb_Compare_n || didZcEventOccur) {
    LX2_DWork.icLoad_i = 1U;
  }

  if (LX2_DWork.icLoad_i != 0) {
    LX2_DWork.Delay_DSTATE = rtb_UnitDelay3;
  }

  rtb_Switch2_l = LX2_DWork.Delay_DSTATE;

  /* End of Delay: '<S41>/Delay' */

  /* Sum: '<S41>/Difference Inputs1' incorporates:
   *  Switch: '<S41>/etaVolConst'
   */
  rtb_UnitDelay2 = rtb_UnitDelay3 - rtb_Switch2_l;

  /* Switch: '<S49>/Switch2' incorporates:
   *  RelationalOperator: '<S49>/LowerRelop1'
   */
  if (!(rtb_UnitDelay2 > rtb_Switch2_kt)) {
    /* Product: '<S41>/delta fall limit' incorporates:
     *  UnaryMinus: '<S7>/Unary Minus1'
     */
    rtb_UnitDelay3 = -rtb_Gain3 * 0.1F;

    /* Switch: '<S49>/Switch' incorporates:
     *  RelationalOperator: '<S49>/UpperRelop'
     */
    if (rtb_UnitDelay2 < rtb_UnitDelay3) {
      rtb_Switch2_kt = rtb_UnitDelay3;
    } else {
      rtb_Switch2_kt = rtb_UnitDelay2;
    }

    /* End of Switch: '<S49>/Switch' */
  }

  /* End of Switch: '<S49>/Switch2' */

  /* Sum: '<S41>/Difference Inputs2' */
  rtb_Switch2_kt += rtb_Switch2_l;

  /* SignalConversion: '<S5>/TmpSignal ConversionAtBus CreatorInport2' incorporates:
   *  Constant: '<S5>/Constant'
   */
  rtb_bLX2_save[0] = FALSE;
  rtb_bLX2_save[1] = rtb_Switch2_a_idx;
  rtb_bLX2_save[2] = rtb_Switch2_a_idx_0;
  rtb_bLX2_save[3] = rtb_Switch2_a_idx_1;
  rtb_bLX2_save[4] = rtb_Switch2_a_idx_2;

  /* Dynamic Look-Up Table Block: '<S10>/Interpolate BPOC at Lp2 (half load)'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Switch2_l), rtb_Switch1, rtb_Lp2Lp3Lp_c[0],
    LX2_ConstP.pooled14, 10U, inst);

  /* Dynamic Look-Up Table Block: '<S11>/Interpolate BPOC at Lp2 (half load)'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Divide), rtb_Switch1_m, rtb_Lp2Lp3Lp_c_n[0],
    LX2_ConstP.pooled14, 10U, inst);

  /* Dynamic Look-Up Table Block: '<S12>/Interpolate BPOC at Lp2 (half load)'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Abs), rtb_Switch1_i, rtb_Lp2Lp3Lp_c_l[0],
    LX2_ConstP.pooled14, 10U, inst);

  /* Dynamic Look-Up Table Block: '<S13>/Interpolate BPOC at Lp2 (half load)'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Switch2_b), rtb_Switch1_it, rtb_Lp2Lp3Lp_c_e[0],
    LX2_ConstP.pooled14, 10U, inst);

  /* SignalConversion: '<S5>/TmpSignal ConversionAtBus CreatorInport3' incorporates:
   *  Constant: '<S5>/Constant1'
   */
  rtb_rPr_LX2_offset_Lp_b[0] = 0.0F;
  rtb_rPr_LX2_offset_Lp_b[1] = rtb_Switch2_l;
  rtb_rPr_LX2_offset_Lp_b[2] = rtb_Divide;
  rtb_rPr_LX2_offset_Lp_b[3] = rtb_Abs;
  rtb_rPr_LX2_offset_Lp_b[4] = rtb_Switch2_b;

  /* Dynamic Look-Up Table Block: '<S10>/Interpolate BPOC at Lp3 (full load)'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Switch2_l), rtb_Switch1, rtb_Lp2Lp3Lp_c[1],
    LX2_ConstP.pooled14, 10U, inst);

  /* Dynamic Look-Up Table Block: '<S11>/Interpolate BPOC at Lp3 (full load)'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Divide), rtb_Switch1_m, rtb_Lp2Lp3Lp_c_n[1],
    LX2_ConstP.pooled14, 10U, inst);

  /* Dynamic Look-Up Table Block: '<S12>/Interpolate BPOC at Lp3 (full load)'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Abs), rtb_Switch1_i, rtb_Lp2Lp3Lp_c_l[1],
    LX2_ConstP.pooled14, 10U, inst);

  /* Dynamic Look-Up Table Block: '<S13>/Interpolate BPOC at Lp3 (full load)'
   * Input0  Data Type:  Floating Point real32_T
   * Input1  Data Type:  Floating Point real32_T
   * Input2  Data Type:  Floating Point real32_T
   * Output0 Data Type:  Floating Point real32_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real32_T_real32_T( &(rtb_Switch2_b), rtb_Switch1_it, rtb_Lp2Lp3Lp_c_e[1],
    LX2_ConstP.pooled14, 10U, inst);

  /* SignalConversion: '<S5>/TmpSignal ConversionAtBus CreatorInport4' incorporates:
   *  Constant: '<S5>/Constant2'
   */
  rtb_rPr_LX2_offset_Lp_a[0] = 0.0F;
  rtb_rPr_LX2_offset_Lp_a[1] = rtb_Switch2_l;
  rtb_rPr_LX2_offset_Lp_a[2] = rtb_Divide;
  rtb_rPr_LX2_offset_Lp_a[3] = rtb_Abs;
  rtb_rPr_LX2_offset_Lp_a[4] = rtb_Switch2_b;

  /* Switch: '<S10>/Switch2' incorporates:
   *  Constant: '<S10>/Constant1'
   *  Constant: '<S10>/Constant2'
   */
  if (rtb_bLp_c_ena) {
    /* Dynamic Look-Up Table Block: '<S10>/Interpolate BPOC at Lp_c (25% load)'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_InterpolateBPOCatLp_c25lo_e), rtb_Switch1,
      rtb_Lp2Lp3Lp_c[2], LX2_ConstP.pooled14, 10U, inst);
    rtb_Switch2_l = rtb_InterpolateBPOCatLp_c25lo_e;
  } else {
    rtb_Switch2_l = 0.0F;
  }

  /* End of Switch: '<S10>/Switch2' */

  /* Switch: '<S11>/Switch2' incorporates:
   *  Constant: '<S11>/Constant1'
   *  Constant: '<S11>/Constant2'
   */
  if (rtb_bLp_c_ena_i) {
    /* Dynamic Look-Up Table Block: '<S11>/Interpolate BPOC at Lp_c (25% load)'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_InterpolateBPOCatLp_c25lo_l), rtb_Switch1_m,
      rtb_Lp2Lp3Lp_c_n[2], LX2_ConstP.pooled14, 10U, inst);
    rtb_Divide = rtb_InterpolateBPOCatLp_c25lo_l;
  } else {
    rtb_Divide = 0.0F;
  }

  /* End of Switch: '<S11>/Switch2' */

  /* Switch: '<S12>/Switch2' incorporates:
   *  Constant: '<S12>/Constant1'
   *  Constant: '<S12>/Constant2'
   */
  if (rtb_bLp_c_ena_h) {
    /* Dynamic Look-Up Table Block: '<S12>/Interpolate BPOC at Lp_c (25% load)'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_InterpolateBPOCatLp_c25lo_h), rtb_Switch1_i,
      rtb_Lp2Lp3Lp_c_l[2], LX2_ConstP.pooled14, 10U, inst);
    rtb_Abs = rtb_InterpolateBPOCatLp_c25lo_h;
  } else {
    rtb_Abs = 0.0F;
  }

  /* End of Switch: '<S12>/Switch2' */

  /* Switch: '<S13>/Switch2' incorporates:
   *  Constant: '<S13>/Constant1'
   *  Constant: '<S13>/Constant2'
   */
  if (rtb_bLp_c_ena_n) {
    /* Dynamic Look-Up Table Block: '<S13>/Interpolate BPOC at Lp_c (25% load)'
     * Input0  Data Type:  Floating Point real32_T
     * Input1  Data Type:  Floating Point real32_T
     * Input2  Data Type:  Floating Point real32_T
     * Output0 Data Type:  Floating Point real32_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real32_T_real32_T( &(rtb_InterpolateBPOCatLp_c25load), rtb_Switch1_it,
      rtb_Lp2Lp3Lp_c_e[2], LX2_ConstP.pooled14, 10U, inst);
    rtb_Switch2_b = rtb_InterpolateBPOCatLp_c25load;
  } else {
    rtb_Switch2_b = 0.0F;
  }

  /* End of Switch: '<S13>/Switch2' */

  /* SignalConversion: '<S5>/TmpSignal ConversionAtBus CreatorInport5' incorporates:
   *  Constant: '<S5>/Constant3'
   */
  rtb_rPr_LX2_offset_Lp_c[0] = 0.0F;
  rtb_rPr_LX2_offset_Lp_c[1] = rtb_Switch2_l;
  rtb_rPr_LX2_offset_Lp_c[2] = rtb_Divide;
  rtb_rPr_LX2_offset_Lp_c[3] = rtb_Abs;
  rtb_rPr_LX2_offset_Lp_c[4] = rtb_Switch2_b;

  /* MATLAB Function: '<S14>/MATLAB Function' */
  /* MATLAB Function 'Leanox 2.0/BPOC/Visu/MATLAB Function': '<S31>:1' */
  /* persistent y0_1 */
  /*   */
  /*  if isempty(y0_1) */
  /*      y0_1 = single(0); */
  /*  end */
  /*  define output vector */
  /* '<S31>:1:11' */
  if (!LX2_B.BusInput2.bLX2_enable) {
    /* '<S31>:1:13' */
    /* '<S31>:1:14' */
    rtb_UnitDelay3 = 0.0F;

    /* '<S31>:1:15' */
    rtb_UnitDelay2 = 0.0F;

    /* '<S31>:1:16' */
    rtb_Gain3 = 0.0F;

    /* '<S31>:1:17' */
    rtb_splitfactor_VISU_idx = 0.0F;
  } else if (LX2_B.BusInput2.bLX2_enable && LX2_B.BusInput.bLX2_active) {
    /* '<S31>:1:19' */
    /* '<S31>:1:20' */
    rtb_UnitDelay3 = rtb_splitfactor_Gas[0];
    rtb_UnitDelay2 = rtb_splitfactor_Gas[1];
    rtb_Gain3 = rtb_splitfactor_Gas[2];
    rtb_splitfactor_VISU_idx = rtb_splitfactor_Gas[3];
  } else {
    /*  (bLX2_enable == true) && (bLX2_active == false) */
    if (LX2_B.BusInput.iIdx_Gtyp_Dem < 4) {
      /* '<S31>:1:23' */
      /* '<S31>:1:24' */
      rtb_UnitDelay3 = (1.0F - LX2_B.BusInput.rGT_QualMix_1_2) * (1.0F -
        LX2_B.BusInput.rGT_RatioMix);

      /* '<S31>:1:25' */
      rtb_UnitDelay2 = (1.0F - LX2_B.BusInput.rGT_RatioMix) *
        LX2_B.BusInput.rGT_QualMix_1_2;

      /* '<S31>:1:26' */
      rtb_Gain3 = LX2_B.BusInput.rGT_RatioMix;

      /* '<S31>:1:27' */
      rtb_splitfactor_VISU_idx = 0.0F;
    } else if (LX2_B.BusInput.iIdx_Gtyp_Dem == 4) {
      /* '<S31>:1:29' */
      /* '<S31>:1:30' */
      rtb_UnitDelay3 = 0.0F;

      /* '<S31>:1:31' */
      rtb_UnitDelay2 = 0.0F;

      /* '<S31>:1:32' */
      rtb_Gain3 = 0.0F;

      /* '<S31>:1:33' */
      rtb_splitfactor_VISU_idx = 1.0F;
    } else {
      /*  undefined Gastype */
      /* '<S31>:1:36' */
      rtb_UnitDelay3 = 0.0F;

      /* '<S31>:1:37' */
      rtb_UnitDelay2 = 0.0F;

      /* '<S31>:1:38' */
      rtb_Gain3 = 0.0F;

      /* '<S31>:1:39' */
      rtb_splitfactor_VISU_idx = 0.0F;
    }
  }

  /* End of MATLAB Function: '<S14>/MATLAB Function' */

  /* Selector: '<S14>/Selector9' */
  /*  y0_1 = y0; */
  rtb_Switch2_l = rtb_UnitDelay3;

  /* Product: '<S14>/Product4' */
  for (i = 0; i < 11; i++) {
    /* Switch: '<S14>/Switch10' incorporates:
     *  Constant: '<S14>/Constant18'
     */
    if (rtb_Switch2_l != 0.0F) {
      tmp_1 = LX2_B.BusInput.rLX2_BPOC_Gas1[i];
    } else {
      tmp_1 = 0.0F;
    }

    /* End of Switch: '<S14>/Switch10' */
    rtb_Product4[i] = rtb_Switch2_l * tmp_1;
  }

  /* End of Product: '<S14>/Product4' */

  /* Selector: '<S14>/Selector10' */
  rtb_Switch2_l = rtb_UnitDelay2;

  /* Product: '<S14>/Product5' */
  for (i = 0; i < 11; i++) {
    /* Switch: '<S14>/Switch8' incorporates:
     *  Constant: '<S14>/Constant19'
     */
    if (rtb_Switch2_l != 0.0F) {
      tmp_1 = LX2_B.BusInput.rLX2_BPOC_Gas2[i];
    } else {
      tmp_1 = 0.0F;
    }

    /* End of Switch: '<S14>/Switch8' */
    rtb_Product5[i] = rtb_Switch2_l * tmp_1;
  }

  /* End of Product: '<S14>/Product5' */

  /* Selector: '<S14>/Selector11' */
  rtb_Switch2_l = rtb_Gain3;

  /* Product: '<S14>/Product6' */
  for (i = 0; i < 11; i++) {
    /* Switch: '<S14>/Switch9' incorporates:
     *  Constant: '<S14>/Constant21'
     */
    if (rtb_Switch2_l != 0.0F) {
      tmp_1 = LX2_B.BusInput.rLX2_BPOC_Gas3[i];
    } else {
      tmp_1 = 0.0F;
    }

    /* End of Switch: '<S14>/Switch9' */
    rtb_Product6[i] = rtb_Switch2_l * tmp_1;
  }

  /* End of Product: '<S14>/Product6' */

  /* Selector: '<S14>/Selector12' */
  rtb_Switch2_l = rtb_splitfactor_VISU_idx;
  for (i = 0; i < 11; i++) {
    /* Switch: '<S14>/Switch11' incorporates:
     *  Constant: '<S14>/Constant23'
     */
    if (rtb_Switch2_l != 0.0F) {
      tmp_1 = LX2_B.BusInput.rLX2_BPOC_Gas4[i];
    } else {
      tmp_1 = 0.0F;
    }

    /* End of Switch: '<S14>/Switch11' */

    /* Product: '<S14>/Product7' */
    rtb_Product7[i] = rtb_Switch2_l * tmp_1;

    /* Switch: '<S14>/Switch6' incorporates:
     *  Constant: '<S14>/Constant7'
     *  Selector: '<S14>/Selector5'
     */
    if (rtb_UnitDelay3 != 0.0F) {
      rtb_Switch5_kl[i] = (int8_T)LX2_B.BusInput.bLX2_BPOC_measured_Gas1[i];
    } else {
      rtb_Switch5_kl[i] = 0;
    }

    /* End of Switch: '<S14>/Switch6' */

    /* Switch: '<S14>/Switch4' incorporates:
     *  Constant: '<S14>/Constant10'
     *  Selector: '<S14>/Selector6'
     */
    if (rtb_UnitDelay2 != 0.0F) {
      rtb_Switch4[i] = (int8_T)LX2_B.BusInput.bLX2_BPOC_measured_Gas2[i];
    } else {
      rtb_Switch4[i] = 0;
    }

    /* End of Switch: '<S14>/Switch4' */

    /* Switch: '<S14>/Switch5' incorporates:
     *  Constant: '<S14>/Constant11'
     *  Selector: '<S14>/Selector7'
     */
    if (rtb_Gain3 != 0.0F) {
      rtb_Switch6_j[i] = (int8_T)LX2_B.BusInput.bLX2_BPOC_measured_Gas3[i];
    } else {
      rtb_Switch6_j[i] = 0;
    }

    /* End of Switch: '<S14>/Switch5' */

    /* Switch: '<S14>/Switch7' incorporates:
     *  Constant: '<S14>/Constant13'
     *  Selector: '<S14>/Selector8'
     */
    if (rtb_splitfactor_VISU_idx != 0.0F) {
      rtb_rLX2_BPOC[i] = (int8_T)LX2_B.BusInput.bLX2_BPOC_measured_Gas4[i];
    } else {
      rtb_rLX2_BPOC[i] = 0;
    }

    /* End of Switch: '<S14>/Switch7' */
  }

  /* Logic: '<S37>/Logical Operator4' incorporates:
   *  Bias: '<S37>/Bias'
   *  Bias: '<S37>/Bias1'
   *  Gain: '<S37>/mbar2bar'
   *  Gain: '<S37>/mbar2bar1'
   *  RelationalOperator: '<S37>/Relational Operator2'
   *  RelationalOperator: '<S37>/Relational Operator3'
   */
  rtb_LogicalOperator4_g = ((rtb_Switch2_kt >= 0.001F *
    LX2_B.BusInput2.rPr_LX2_OffsetLimit + -1.1920929E-5F) || (rtb_Switch2_kt <=
    0.001F * rtb_LowerLimit_factor + 1.1920929E-5F));

  /* Outputs for Atomic SubSystem: '<S37>/TON' */
  LX2_TON(rtb_LogicalOperator4_g, rtb_rLX2_inLimitSetup_Time, &LX2_B.TON_b,
          &LX2_DWork.TON_b, inst);

  /* End of Outputs for SubSystem: '<S37>/TON' */

  /* BusCreator: '<S5>/Bus Creator' incorporates:
   *  Logic: '<S14>/Logical Operator'
   *  Logic: '<S14>/Logical Operator1'
   *  Logic: '<S14>/Logical Operator2'
   *  Sum: '<S14>/Add'
   */
  LX2_Y.tLX2_OUT_c.rPr_LX2_offset = rtb_Switch2_kt;
  for (i = 0; i < 5; i++) {
    LX2_Y.tLX2_OUT_c.bLX2_save[i] = rtb_bLX2_save[i];
    LX2_Y.tLX2_OUT_c.rPr_LX2_offset_Lp_b[i] = rtb_rPr_LX2_offset_Lp_b[i];
    LX2_Y.tLX2_OUT_c.rPr_LX2_offset_Lp_a[i] = rtb_rPr_LX2_offset_Lp_a[i];
    LX2_Y.tLX2_OUT_c.rPr_LX2_offset_Lp_c[i] = rtb_rPr_LX2_offset_Lp_c[i];
  }

  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_OUT_c.rLX2_BPOC_Gas1[i] = rtb_Switch2[i];
    LX2_Y.tLX2_OUT_c.bLX2_BPOC_measured_Gas1[i] =
      LX2_B.sf_BoostPressureOffsetCurve.OUT_measured[i];
    LX2_Y.tLX2_OUT_c.rLX2_BPOC_Gas2[i] = rtb_Switch2_j[i];
    LX2_Y.tLX2_OUT_c.bLX2_BPOC_measured_Gas2[i] =
      LX2_B.sf_BoostPressureOffsetCurve_f.OUT_measured[i];
    LX2_Y.tLX2_OUT_c.rLX2_BPOC_Gas3[i] = rtb_Switch2_k[i];
    LX2_Y.tLX2_OUT_c.bLX2_BPOC_measured_Gas3[i] =
      LX2_B.sf_BoostPressureOffsetCurve_d.OUT_measured[i];
    LX2_Y.tLX2_OUT_c.rLX2_BPOC_Gas4[i] = rtb_Switch2_kq[i];
    LX2_Y.tLX2_OUT_c.bLX2_BPOC_measured_Gas4[i] =
      LX2_B.sf_BoostPressureOffsetCurve_a.OUT_measured[i];
    LX2_Y.tLX2_OUT_c.rLX2_BPOC[i] = ((rtb_Product4[i] + rtb_Product5[i]) +
      rtb_Product6[i]) + rtb_Product7[i];
    LX2_Y.tLX2_OUT_c.bLX2_BPOC_measured[i] = ((rtb_Switch5_kl[i] != 0) ||
      (rtb_Switch4[i] != 0) || (rtb_Switch6_j[i] != 0) || (rtb_rLX2_BPOC[i] != 0));
  }

  LX2_Y.tLX2_OUT_c.bBPOC_enable = (rtb_bBPOC_enable_a[0] || rtb_bBPOC_enable_a[1]
    || rtb_bBPOC_enable_a[2] || rtb_bBPOC_enable_a[3]);
  LX2_Y.tLX2_OUT_c.bBPOC_save_enable = (rtb_bSave_BPOC_enable[0] ||
    rtb_bSave_BPOC_enable[1] || rtb_bSave_BPOC_enable[2] ||
    rtb_bSave_BPOC_enable[3]);
  LX2_Y.tLX2_OUT_c.bLX2_inLimit = LX2_B.TON_b.LogicalOperator3;

  /* End of BusCreator: '<S5>/Bus Creator' */

  /* BusCreator: '<S8>/Bus Creator' */
  rtb_LogicalOperator5_k = rtb_LogicalOperator_f;

  /* Switch: '<S7>/Switch2' incorporates:
   *  RelationalOperator: '<S34>/FixPt Relational Operator'
   *  Sum: '<S7>/Sum9'
   *  UnitDelay: '<S34>/Delay Input1'
   */
  if ((uint8_T)((int32_T)LX2_B.BusInput.bNOx_valid - ((int32_T)
        LX2_B.BusInput.bNOx_valid > (int32_T)LX2_DWork.DelayInput1_DSTATE)) != 0)
  {
    /* Saturate: '<S7>/Saturation' */
    if (rtb_rNOx_act_g >= 300.0F) {
      rtb_UnitDelay3 = 300.0F;
    } else if (rtb_rNOx_act_g <= 20.0F) {
      rtb_UnitDelay3 = 20.0F;
    } else {
      rtb_UnitDelay3 = rtb_rNOx_act_g;
    }

    /* End of Saturate: '<S7>/Saturation' */
  } else {
    rtb_UnitDelay3 = LX2_B.BusInput.rNOx_set;
  }

  /* End of Switch: '<S7>/Switch2' */

  /* Outputs for Atomic SubSystem: '<S7>/Filter' */
  /* RelationalOperator: '<S35>/Relational Operator' incorporates:
   *  Constant: '<S35>/Constant'
   */
  rtb_RelationalOperator_b = (LX2_B.BusInput2.rFilterConst_NOx > 0.0F);

  /* Logic: '<S35>/Logical Operator' incorporates:
   *  Logic: '<S35>/Logical Operator1'
   *  Logic: '<S7>/Logical Operator3'
   *  Logic: '<S7>/Logical Operator4'
   */
  rtb_LogicalOperator_d = ((!LX2_B.BusInput.bNOx_valid) ||
    rtb_LogicalOperator6_a || (!rtb_RelationalOperator_b));

  /* DiscreteIntegrator: '<S35>/Discrete-Time Integrator' */
  if (LX2_DWork.DiscreteTimeIntegrator_IC_LOA_l != 0) {
    LX2_DWork.DiscreteTimeIntegrator_DSTATE_n = rtb_UnitDelay3;
  }

  if (rtb_LogicalOperator_d || (LX2_DWork.DiscreteTimeIntegrator_PrevRe_a != 0))
  {
    LX2_DWork.DiscreteTimeIntegrator_DSTATE_n = rtb_UnitDelay3;
  }

  /* Switch: '<S35>/Switch' incorporates:
   *  DiscreteIntegrator: '<S35>/Discrete-Time Integrator'
   */
  if (rtb_RelationalOperator_b) {
    rtb_splitfactor_VISU_idx = LX2_DWork.DiscreteTimeIntegrator_DSTATE_n;
  } else {
    rtb_splitfactor_VISU_idx = rtb_rNOx_act_g;
  }

  /* End of Switch: '<S35>/Switch' */

  /* Update for DiscreteIntegrator: '<S35>/Discrete-Time Integrator' */
  LX2_DWork.DiscreteTimeIntegrator_IC_LOA_l = 0U;

  /* Switch: '<S42>/Switch' incorporates:
   *  Abs: '<S42>/Abs'
   *  Constant: '<S42>/Constant2'
   *  RelationalOperator: '<S42>/Relational Operator'
   */
  if (0.1F >= (real32_T)fabs(LX2_B.BusInput2.rFilterConst_NOx)) {
    tmp_1 = 0.1F;
  } else {
    tmp_1 = LX2_B.BusInput2.rFilterConst_NOx;
  }

  /* End of Switch: '<S42>/Switch' */

  /* Update for DiscreteIntegrator: '<S35>/Discrete-Time Integrator' incorporates:
   *  DiscreteIntegrator: '<S35>/Discrete-Time Integrator'
   *  Product: '<S35>/Divide4'
   *  Sum: '<S35>/Sum4'
   */
  LX2_DWork.DiscreteTimeIntegrator_DSTATE_n += (rtb_rNOx_act_g -
    LX2_DWork.DiscreteTimeIntegrator_DSTATE_n) / tmp_1 * 0.1F;
  if (rtb_LogicalOperator_d) {
    LX2_DWork.DiscreteTimeIntegrator_PrevRe_a = 1;
  } else {
    LX2_DWork.DiscreteTimeIntegrator_PrevRe_a = 0;
  }

  /* End of Outputs for SubSystem: '<S7>/Filter' */

  /* Sum: '<S7>/Sum' */
  rtb_UnitDelay3 = rtb_splitfactor_VISU_idx - LX2_B.BusInput.rNOx_set;

  /* Switch: '<S40>/Switch2' incorporates:
   *  Gain: '<S7>/LowerLim_factor'
   *  RelationalOperator: '<S40>/LowerRelop1'
   *  RelationalOperator: '<S40>/UpperRelop'
   *  Switch: '<S40>/Switch'
   */
  if (rtb_UnitDelay3 > LX2_B.BusInput1.rCtrlError_Limit) {
    rtb_Switch2_l = LX2_B.BusInput1.rCtrlError_Limit;
  } else if (rtb_UnitDelay3 < -LX2_B.BusInput1.rCtrlError_Limit) {
    /* Switch: '<S40>/Switch' incorporates:
     *  Gain: '<S7>/LowerLim_factor'
     */
    rtb_Switch2_l = -LX2_B.BusInput1.rCtrlError_Limit;
  } else {
    /* Switch: '<S40>/Switch' */
    rtb_Switch2_l = rtb_UnitDelay3;
  }

  /* End of Switch: '<S40>/Switch2' */

  /* Switch: '<S7>/Switch1' incorporates:
   *  Constant: '<S33>/Constant'
   *  Constant: '<S7>/Constant'
   *  Logic: '<S7>/Logical Operator5'
   *  MATLAB Function: '<S8>/MATLAB Function'
   *  RelationalOperator: '<S33>/Compare'
   */
  if ((rtb_Switch7 <= 0.0F) || bCtrl_freeze) {
    rtb_Divide = 0.0F;
  } else {
    rtb_Divide = rtb_Switch2_l;
  }

  /* End of Switch: '<S7>/Switch1' */

  /* Abs: '<S45>/Abs' */
  rtb_Abs = (real32_T)fabs(rtb_Switch_nq);

  /* Switch: '<S45>/Switch' incorporates:
   *  Constant: '<S45>/Constant2'
   *  RelationalOperator: '<S45>/Relational Operator'
   */
  if (0.1F >= rtb_Abs) {
    rtb_Switch_nq = 0.1F;
  }

  /* End of Switch: '<S45>/Switch' */

  /* Product: '<S36>/Divide' */
  rtb_Divide /= rtb_Switch_nq;

  /* Signum: '<S44>/Sign2' incorporates:
   *  DataTypeConversion: '<S44>/Data Type Conversion2'
   */
  if (rtb_Sum2_e < 0.0F) {
    rtb_Sum2_e_0 = -1.0;
  } else if (rtb_Sum2_e > 0.0F) {
    rtb_Sum2_e_0 = 1.0;
  } else {
    rtb_Sum2_e_0 = rtb_Sum2_e;
  }

  /* Signum: '<S44>/Sign1' incorporates:
   *  DataTypeConversion: '<S44>/Data Type Conversion3'
   */
  if (rtb_Divide < 0.0F) {
    tmp_2 = -1.0;
  } else if (rtb_Divide > 0.0F) {
    tmp_2 = 1.0;
  } else {
    tmp_2 = rtb_Divide;
  }

  /* Logic: '<S44>/Logical Operator' incorporates:
   *  Logic: '<S44>/Logical Operator1'
   *  Logic: '<S44>/Logical Operator2'
   *  Logic: '<S44>/Logical Operator7'
   *  MATLAB Function: '<S8>/MATLAB Function'
   *  RelationalOperator: '<S44>/Equal'
   *  RelationalOperator: '<S44>/Relational Operator'
   *  RelationalOperator: '<S44>/Relational Operator1'
   *  Signum: '<S44>/Sign1'
   *  Signum: '<S44>/Sign2'
   */
  rtb_LogicalOperator_f = (((rtb_Sum2_e >= rtb_Switch7) || (rtb_Sum2_e <=
    rtb_Switch6)) && ((rtb_Sum2_e_0 == tmp_2) || (!bCtrl_enable)));

  /* BusCreator: '<S5>/Bus Creator1' incorporates:
   *  BusCreator: '<S8>/Bus Creator'
   *  MATLAB Function: '<S8>/MATLAB Function'
   */
  LX2_Y.tLX2_DBUG_j.Stm.rP_act_Norm_Filt = LX2_B.Filter1_i.Switch;
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_enable[0] = rtb_bBPOC_enable_a[0];
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_enable[1] = rtb_bBPOC_enable_a[1];
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_enable[2] = rtb_bBPOC_enable_a[2];
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_enable[3] = rtb_bBPOC_enable_a[3];
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_save_enable[0] = rtb_bSave_BPOC_enable[0];
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_save_enable[1] = rtb_bSave_BPOC_enable[1];
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_save_enable[2] = rtb_bSave_BPOC_enable[2];
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_save_enable[3] = rtb_bSave_BPOC_enable[3];
  LX2_Y.tLX2_DBUG_j.Stm.rSplitfactor_Gas[0] = rtb_splitfactor_Gas[0];
  LX2_Y.tLX2_DBUG_j.Stm.rSplitfactor_Gas[1] = rtb_splitfactor_Gas[1];
  LX2_Y.tLX2_DBUG_j.Stm.rSplitfactor_Gas[2] = rtb_splitfactor_Gas[2];
  LX2_Y.tLX2_DBUG_j.Stm.rSplitfactor_Gas[3] = rtb_splitfactor_Gas[3];
  LX2_Y.tLX2_DBUG_j.Stm.bCtrl_enable = bCtrl_enable;
  LX2_Y.tLX2_DBUG_j.Stm.bCtrl_freeze = bCtrl_freeze;
  LX2_Y.tLX2_DBUG_j.Stm.bEng_knock = b_bEng_knock;
  LX2_Y.tLX2_DBUG_j.Stm.bEng_misfire = bEng_misfire;
  LX2_Y.tLX2_DBUG_j.Stm.bBPOC_reset = rtb_LogicalOperator5_k;

  /* DataTypeConversion: '<S54>/Data Type Conversion1' */
  tmp_1 = (real32_T)fmod((real32_T)floor(LX2_B.TON_p.DiscreteTimeIntegrator),
    65536.0F);

  /* BusCreator: '<S5>/Bus Creator1' incorporates:
   *  BusCreator: '<S10>/Bus Creator1'
   *  BusCreator: '<S11>/Bus Creator1'
   *  BusCreator: '<S12>/Bus Creator1'
   *  BusCreator: '<S13>/Bus Creator1'
   *  BusCreator: '<S7>/Bus Creator1'
   *  BusCreator: '<S8>/Bus Creator'
   *  DataTypeConversion: '<S54>/Data Type Conversion1'
   *  Logic: '<S9>/Logical Operator'
   *  MATLAB Function: '<S7>/MATLAB Function'
   *  Product: '<S9>/Product'
   *  Product: '<S9>/Product1'
   *  Product: '<S9>/Product2'
   *  Product: '<S9>/Product3'
   *  Product: '<S9>/Product4'
   *  Product: '<S9>/Product5'
   *  Product: '<S9>/Product6'
   *  Product: '<S9>/Product7'
   *  Selector: '<S10>/Selector3'
   *  Selector: '<S11>/Selector3'
   *  Selector: '<S12>/Selector3'
   *  Selector: '<S13>/Selector3'
   *  Selector: '<S9>/Selector1'
   *  Selector: '<S9>/Selector16'
   *  Selector: '<S9>/Selector17'
   *  Selector: '<S9>/Selector18'
   *  Selector: '<S9>/Selector19'
   *  Selector: '<S9>/Selector2'
   *  Selector: '<S9>/Selector3'
   *  Selector: '<S9>/Selector4'
   *  Sum: '<S9>/Add'
   *  Sum: '<S9>/Sum of Elements'
   *  Sum: '<S9>/Sum of Elements1'
   *  Sum: '<S9>/Sum of Elements2'
   */
  LX2_Y.tLX2_DBUG_j.Stm.iTimer_save = (uint16_T)(tmp_1 < 0.0F ? (uint16_T)
    (int32_T)(int16_T)-(int16_T)(uint16_T)-tmp_1 : (uint16_T)tmp_1);
  LX2_Y.tLX2_DBUG_j.Stm.bLX2_SteadyState = rtb_LogicalOperator3_e;
  LX2_Y.tLX2_DBUG_j.Stm.bLX2_SteadyState_noDelay = rtb_LogicalOperator2;
  LX2_Y.tLX2_DBUG_j.Stm.bLX2_LeanoxDev_Steady = rtb_u;
  LX2_Y.tLX2_DBUG_j.Stm.bLX2_P_Set_Steady = rtb_u_b;
  LX2_Y.tLX2_DBUG_j.Ctr.rCtrlError = rtb_Switch2_l;
  LX2_Y.tLX2_DBUG_j.Ctr.rPr_offset_Ctrl = rtb_DiscreteTimeIntegrator;
  LX2_Y.tLX2_DBUG_j.Ctr.rPr_LX2_offset_preSat = rtb_Sum2_e;
  LX2_Y.tLX2_DBUG_j.Ctr.bLX2_inSaturation = rtb_LogicalOperator_f;
  LX2_Y.tLX2_DBUG_j.Ctr.rNOx_act_filt = rtb_splitfactor_VISU_idx;
  LX2_Y.tLX2_DBUG_j.Ctr.rPr_Ctrl_LowerLim_act = rtb_Switch6;
  LX2_Y.tLX2_DBUG_j.Ctr.rPr_Ctrl_UpperLim_act = rtb_Switch7;
  LX2_Y.tLX2_DBUG_j.Ctr.rPr_offset_BPOC_all = rtb_SumofElements;
  LX2_Y.tLX2_DBUG_j.Ctr.rPr_y0_Ctrl = b_y;
  LX2_Y.tLX2_DBUG_j.Ctr.rLX2_inLimit_Timer = LX2_B.TON_b.DiscreteTimeIntegrator;
  LX2_Y.tLX2_DBUG_j.Ctr.bLX2_inLimit_NoDelay = rtb_LogicalOperator4_g;
  LX2_Y.tLX2_DBUG_j.Gas1.bBPOC_enable = rtb_bBPOC_enable_a[0];
  LX2_Y.tLX2_DBUG_j.Gas1.bBPOC_save_enable = rtb_LogicalOperator7_m;
  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_DBUG_j.Gas1.bBPOC_measured_map_IN[i] = rtb_Delay1[i];
    LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_offset_map_IN[i] = rtb_Delay2[i];
  }

  LX2_Y.tLX2_DBUG_j.Gas1.rPr_BPOC_offset_IN = rtb_Sum1;
  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_DBUG_j.Gas1.bBPOC_measured_map_OUT[i] =
      LX2_B.sf_BoostPressureOffsetCurve.OUT_measured[i];
    LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_offset_map_OUT[i] = rtb_Switch2[i];
  }

  LX2_Y.tLX2_DBUG_j.Gas1.rPr_BPOC_offset_OUT = rtb_Switch3;
  LX2_Y.tLX2_DBUG_j.Gas1.rP_act_Norm_Filt = LX2_B.Filter1_i.Switch;
  LX2_Y.tLX2_DBUG_j.Gas1.rLX2_BPOC_Error = LX2_B.sf_BoostPressureOffsetCurve.e;
  LX2_Y.tLX2_DBUG_j.Gas1.rLX2_Lp[0] = rtb_Lp2Lp3Lp_c[0];
  LX2_Y.tLX2_DBUG_j.Gas1.rLX2_Lp[1] = rtb_Lp2Lp3Lp_c[1];
  LX2_Y.tLX2_DBUG_j.Gas1.rLX2_Lp[2] = rtb_Lp2Lp3Lp_c[2];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_a[0] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_a[0];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_a[1] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_a[1];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_b[0] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_b[0];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_b[1] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_b[1];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_Lp[0] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_Lp[0];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_Lp[1] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_Lp[1];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_Lp[2] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_Lp[2];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_Lp[3] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_Lp[3];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_s[0] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_s[0];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_s[1] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_s[1];
  LX2_Y.tLX2_DBUG_j.Gas1.rBPOC_DBUG_s[2] =
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_s[2];
  LX2_Y.tLX2_DBUG_j.Gas2.bBPOC_enable = rtb_bBPOC_enable_a[1];
  LX2_Y.tLX2_DBUG_j.Gas2.bBPOC_save_enable = rtb_LogicalOperator7_e;
  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_DBUG_j.Gas2.bBPOC_measured_map_IN[i] = rtb_Delay1_g[i];
    LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_offset_map_IN[i] = rtb_Delay2_e[i];
  }

  LX2_Y.tLX2_DBUG_j.Gas2.rPr_BPOC_offset_IN = rtb_Sum1_e;
  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_DBUG_j.Gas2.bBPOC_measured_map_OUT[i] =
      LX2_B.sf_BoostPressureOffsetCurve_f.OUT_measured[i];
    LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_offset_map_OUT[i] = rtb_Switch2_j[i];
  }

  LX2_Y.tLX2_DBUG_j.Gas2.rPr_BPOC_offset_OUT = rtb_SumofElements2;
  LX2_Y.tLX2_DBUG_j.Gas2.rP_act_Norm_Filt = LX2_B.Filter1_i.Switch;
  LX2_Y.tLX2_DBUG_j.Gas2.rLX2_BPOC_Error = LX2_B.sf_BoostPressureOffsetCurve_f.e;
  LX2_Y.tLX2_DBUG_j.Gas2.rLX2_Lp[0] = rtb_Lp2Lp3Lp_c_n[0];
  LX2_Y.tLX2_DBUG_j.Gas2.rLX2_Lp[1] = rtb_Lp2Lp3Lp_c_n[1];
  LX2_Y.tLX2_DBUG_j.Gas2.rLX2_Lp[2] = rtb_Lp2Lp3Lp_c_n[2];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_a[0] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_a[0];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_a[1] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_a[1];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_b[0] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_b[0];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_b[1] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_b[1];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_Lp[0] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_Lp[0];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_Lp[1] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_Lp[1];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_Lp[2] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_Lp[2];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_Lp[3] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_Lp[3];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_s[0] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_s[0];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_s[1] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_s[1];
  LX2_Y.tLX2_DBUG_j.Gas2.rBPOC_DBUG_s[2] =
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_s[2];
  LX2_Y.tLX2_DBUG_j.Gas3.bBPOC_enable = rtb_bBPOC_enable_a[2];
  LX2_Y.tLX2_DBUG_j.Gas3.bBPOC_save_enable = rtb_LogicalOperator7_l;
  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_DBUG_j.Gas3.bBPOC_measured_map_IN[i] = rtb_Delay1_l[i];
    LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_offset_map_IN[i] = rtb_Delay2_o[i];
  }

  LX2_Y.tLX2_DBUG_j.Gas3.rPr_BPOC_offset_IN = rtb_Sum1_b;
  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_DBUG_j.Gas3.bBPOC_measured_map_OUT[i] =
      LX2_B.sf_BoostPressureOffsetCurve_d.OUT_measured[i];
    LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_offset_map_OUT[i] = rtb_Switch2_k[i];
  }

  LX2_Y.tLX2_DBUG_j.Gas3.rPr_BPOC_offset_OUT = rtb_SumofElements1;
  LX2_Y.tLX2_DBUG_j.Gas3.rP_act_Norm_Filt = LX2_B.Filter1_i.Switch;
  LX2_Y.tLX2_DBUG_j.Gas3.rLX2_BPOC_Error = LX2_B.sf_BoostPressureOffsetCurve_d.e;
  LX2_Y.tLX2_DBUG_j.Gas3.rLX2_Lp[0] = rtb_Lp2Lp3Lp_c_l[0];
  LX2_Y.tLX2_DBUG_j.Gas3.rLX2_Lp[1] = rtb_Lp2Lp3Lp_c_l[1];
  LX2_Y.tLX2_DBUG_j.Gas3.rLX2_Lp[2] = rtb_Lp2Lp3Lp_c_l[2];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_a[0] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_a[0];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_a[1] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_a[1];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_b[0] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_b[0];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_b[1] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_b[1];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_Lp[0] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_Lp[0];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_Lp[1] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_Lp[1];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_Lp[2] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_Lp[2];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_Lp[3] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_Lp[3];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_s[0] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_s[0];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_s[1] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_s[1];
  LX2_Y.tLX2_DBUG_j.Gas3.rBPOC_DBUG_s[2] =
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_s[2];
  LX2_Y.tLX2_DBUG_j.Gas4.bBPOC_enable = rtb_bBPOC_enable_a[3];
  LX2_Y.tLX2_DBUG_j.Gas4.bBPOC_save_enable = rtb_LogicalOperator7_i;
  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_DBUG_j.Gas4.bBPOC_measured_map_IN[i] = rtb_Delay1_c[i];
    LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_offset_map_IN[i] = rtb_Delay2_o1[i];
  }

  LX2_Y.tLX2_DBUG_j.Gas4.rPr_BPOC_offset_IN = rtb_Sum1_h;
  for (i = 0; i < 11; i++) {
    LX2_Y.tLX2_DBUG_j.Gas4.bBPOC_measured_map_OUT[i] =
      LX2_B.sf_BoostPressureOffsetCurve_a.OUT_measured[i];
    LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_offset_map_OUT[i] = rtb_Switch2_kq[i];
  }

  LX2_Y.tLX2_DBUG_j.Gas4.rPr_BPOC_offset_OUT = rtb_SumofElements_o;
  LX2_Y.tLX2_DBUG_j.Gas4.rP_act_Norm_Filt = LX2_B.Filter1_i.Switch;
  LX2_Y.tLX2_DBUG_j.Gas4.rLX2_BPOC_Error = LX2_B.sf_BoostPressureOffsetCurve_a.e;
  LX2_Y.tLX2_DBUG_j.Gas4.rLX2_Lp[0] = rtb_Lp2Lp3Lp_c_e[0];
  LX2_Y.tLX2_DBUG_j.Gas4.rLX2_Lp[1] = rtb_Lp2Lp3Lp_c_e[1];
  LX2_Y.tLX2_DBUG_j.Gas4.rLX2_Lp[2] = rtb_Lp2Lp3Lp_c_e[2];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_a[0] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_a[0];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_a[1] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_a[1];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_b[0] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_b[0];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_b[1] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_b[1];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_Lp[0] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_Lp[0];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_Lp[1] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_Lp[1];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_Lp[2] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_Lp[2];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_Lp[3] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_Lp[3];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_s[0] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_s[0];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_s[1] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_s[1];
  LX2_Y.tLX2_DBUG_j.Gas4.rBPOC_DBUG_s[2] =
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_s[2];
  for (i = 0; i < 11; i++) {
    /* Switch: '<S9>/Switch21' incorporates:
     *  Constant: '<S9>/Constant17'
     *  Selector: '<S9>/Selector1'
     */
    if (rtb_splitfactor_Gas[0] != 0.0F) {
      rtb_splitfactor_VISU_idx = rtb_Switch2[i];
    } else {
      rtb_splitfactor_VISU_idx = 0.0F;
    }

    /* End of Switch: '<S9>/Switch21' */

    /* Switch: '<S9>/Switch1' incorporates:
     *  Constant: '<S9>/Constant2'
     *  Selector: '<S9>/Selector2'
     */
    if (rtb_splitfactor_Gas[1] != 0.0F) {
      rtb_UnitDelay3 = rtb_Switch2_j[i];
    } else {
      rtb_UnitDelay3 = 0.0F;
    }

    /* End of Switch: '<S9>/Switch1' */

    /* Switch: '<S9>/Switch2' incorporates:
     *  Constant: '<S9>/Constant4'
     *  Selector: '<S9>/Selector3'
     */
    if (rtb_splitfactor_Gas[2] != 0.0F) {
      rtb_UnitDelay2 = rtb_Switch2_k[i];
    } else {
      rtb_UnitDelay2 = 0.0F;
    }

    /* End of Switch: '<S9>/Switch2' */

    /* Switch: '<S9>/Switch3' incorporates:
     *  Constant: '<S9>/Constant6'
     *  Selector: '<S9>/Selector4'
     */
    if (rtb_splitfactor_Gas[3] != 0.0F) {
      rtb_Gain3 = rtb_Switch2_kq[i];
    } else {
      rtb_Gain3 = 0.0F;
    }

    /* End of Switch: '<S9>/Switch3' */
    LX2_Y.tLX2_DBUG_j.rLX2_BPOC_internal[i] = ((rtb_splitfactor_Gas[0] *
      rtb_splitfactor_VISU_idx + rtb_splitfactor_Gas[1] * rtb_UnitDelay3) +
      rtb_splitfactor_Gas[2] * rtb_UnitDelay2) + rtb_splitfactor_Gas[3] *
      rtb_Gain3;

    /* Switch: '<S9>/Switch6' incorporates:
     *  Constant: '<S9>/Constant7'
     *  Product: '<S9>/Product4'
     *  Product: '<S9>/Product5'
     *  Product: '<S9>/Product6'
     *  Product: '<S9>/Product7'
     *  Selector: '<S9>/Selector1'
     *  Selector: '<S9>/Selector2'
     *  Selector: '<S9>/Selector3'
     *  Selector: '<S9>/Selector4'
     *  Selector: '<S9>/Selector5'
     *  Sum: '<S9>/Add'
     */
    if (rtb_splitfactor_Gas[0] != 0.0F) {
      rtb_splitfactor_Gas_0 = (int32_T)
        LX2_B.sf_BoostPressureOffsetCurve.OUT_measured[i];
    } else {
      rtb_splitfactor_Gas_0 = 0;
    }

    /* End of Switch: '<S9>/Switch6' */

    /* Switch: '<S9>/Switch4' incorporates:
     *  Constant: '<S9>/Constant10'
     *  Selector: '<S9>/Selector6'
     */
    if (rtb_splitfactor_Gas[1] != 0.0F) {
      rtb_splitfactor_Gas_1 = (int32_T)
        LX2_B.sf_BoostPressureOffsetCurve_f.OUT_measured[i];
    } else {
      rtb_splitfactor_Gas_1 = 0;
    }

    /* End of Switch: '<S9>/Switch4' */

    /* Switch: '<S9>/Switch5' incorporates:
     *  Constant: '<S9>/Constant11'
     *  Selector: '<S9>/Selector7'
     */
    if (rtb_splitfactor_Gas[2] != 0.0F) {
      rtb_splitfactor_Gas_2 = (int32_T)
        LX2_B.sf_BoostPressureOffsetCurve_d.OUT_measured[i];
    } else {
      rtb_splitfactor_Gas_2 = 0;
    }

    /* End of Switch: '<S9>/Switch5' */

    /* Switch: '<S9>/Switch7' incorporates:
     *  Constant: '<S9>/Constant13'
     *  Selector: '<S9>/Selector8'
     */
    if (rtb_splitfactor_Gas[3] != 0.0F) {
      rtb_splitfactor_Gas_3 = (int32_T)
        LX2_B.sf_BoostPressureOffsetCurve_a.OUT_measured[i];
    } else {
      rtb_splitfactor_Gas_3 = 0;
    }

    /* End of Switch: '<S9>/Switch7' */
    LX2_Y.tLX2_DBUG_j.bLX2_BPOC_measured_internal[i] = ((rtb_splitfactor_Gas_0
      != 0) || (rtb_splitfactor_Gas_1 != 0) || (rtb_splitfactor_Gas_2 != 0) ||
      (rtb_splitfactor_Gas_3 != 0));
  }

  LX2_Y.tLX2_DBUG_j.rBPOC_Lp_all[0] = ((rtb_splitfactor_Gas[0] *
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_Lp[1] + rtb_splitfactor_Gas[1] *
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_Lp[1]) + rtb_splitfactor_Gas[2] *
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_Lp[1]) + rtb_splitfactor_Gas[3] *
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_Lp[1];
  LX2_Y.tLX2_DBUG_j.rBPOC_Lp_all[1] = ((rtb_splitfactor_Gas[0] *
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_Lp[2] + rtb_splitfactor_Gas[1] *
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_Lp[2]) + rtb_splitfactor_Gas[2] *
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_Lp[2]) + rtb_splitfactor_Gas[3] *
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_Lp[2];
  LX2_Y.tLX2_DBUG_j.rBPOC_Lp_all[2] = ((rtb_splitfactor_Gas[0] *
    LX2_B.sf_BoostPressureOffsetCurve.DBUG_Lp[3] + rtb_splitfactor_Gas[1] *
    LX2_B.sf_BoostPressureOffsetCurve_f.DBUG_Lp[3]) + rtb_splitfactor_Gas[2] *
    LX2_B.sf_BoostPressureOffsetCurve_d.DBUG_Lp[3]) + rtb_splitfactor_Gas[3] *
    LX2_B.sf_BoostPressureOffsetCurve_a.DBUG_Lp[3];

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Output = LX2_Y.tLX2_OUT_c;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->DBUG = LX2_Y.tLX2_DBUG_j;

  /* Switch: '<S36>/Switch' incorporates:
   *  Constant: '<S36>/Constant'
   */
  if (rtb_LogicalOperator_f) {
    rtb_UnitDelay3 = 0.0F;
  } else {
    rtb_UnitDelay3 = rtb_Divide;
  }

  /* End of Switch: '<S36>/Switch' */

  /* UnitDelay: '<S4>/Unit Delay' */
  LX2_B.UnitDelay = LX2_DWork.UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Version = LX2_B.UnitDelay;

  /* Update for UnitDelay: '<S7>/Unit Delay3' */
  LX2_DWork.UnitDelay3_DSTATE = rtb_Switch2_kt;

  /* Update for UnitDelay: '<S7>/Unit Delay1' */
  LX2_DWork.UnitDelay1_DSTATE = rtb_Compare_n;

  /* Update for UnitDelay: '<S52>/Unit Delay1' */
  LX2_DWork.UnitDelay1_DSTATE_l = rtb_Compare_n;

  /* Update for UnitDelay: '<S54>/Unit Delay' */
  LX2_DWork.UnitDelay_DSTATE_l = LX2_B.TON_p.LogicalOperator3;

  /* Update for Delay: '<S10>/Delay2' */
  LX2_DWork.icLoad = 0U;

  /* Update for UnitDelay: '<S6>/Unit Delay2' */
  LX2_DWork.UnitDelay2_DSTATE = rtb_Switch2_kt;

  /* Update for Delay: '<S10>/Delay1' */
  LX2_DWork.icLoad_o = 0U;

  /* Update for Delay: '<S11>/Delay2' */
  LX2_DWork.icLoad_or = 0U;

  /* Update for Delay: '<S11>/Delay1' */
  LX2_DWork.icLoad_oj = 0U;

  /* Update for Delay: '<S12>/Delay2' */
  LX2_DWork.icLoad_p = 0U;

  /* Update for Delay: '<S12>/Delay1' */
  LX2_DWork.icLoad_d = 0U;

  /* Update for Delay: '<S13>/Delay2' */
  LX2_DWork.icLoad_f = 0U;

  /* Update for Delay: '<S13>/Delay1' */
  LX2_DWork.icLoad_c = 0U;
  for (i = 0; i < 11; i++) {
    /* Update for Delay: '<S10>/Delay2' */
    LX2_DWork.Delay2_DSTATE[i] = rtb_Switch2[i];

    /* Update for Delay: '<S10>/Delay1' */
    LX2_DWork.Delay1_DSTATE[i] =
      LX2_B.sf_BoostPressureOffsetCurve.OUT_measured[i];

    /* Update for Delay: '<S11>/Delay2' */
    LX2_DWork.Delay2_DSTATE_j[i] = rtb_Switch2_j[i];

    /* Update for Delay: '<S11>/Delay1' */
    LX2_DWork.Delay1_DSTATE_l[i] =
      LX2_B.sf_BoostPressureOffsetCurve_f.OUT_measured[i];

    /* Update for Delay: '<S12>/Delay2' */
    LX2_DWork.Delay2_DSTATE_b[i] = rtb_Switch2_k[i];

    /* Update for Delay: '<S12>/Delay1' */
    LX2_DWork.Delay1_DSTATE_o[i] =
      LX2_B.sf_BoostPressureOffsetCurve_d.OUT_measured[i];

    /* Update for Delay: '<S13>/Delay2' */
    LX2_DWork.Delay2_DSTATE_d[i] = rtb_Switch2_kq[i];
    LX2_DWork.Delay1_DSTATE_g[i] =
      LX2_B.sf_BoostPressureOffsetCurve_a.OUT_measured[i];
  }

  /* End of Update for Delay: '<S13>/Delay1' */

  /* Update for UnitDelay: '<S7>/Unit Delay5' */
  LX2_DWork.UnitDelay5_DSTATE = rtb_SumofElements;

  /* Update for UnitDelay: '<S7>/Unit Delay6' */
  LX2_DWork.UnitDelay6_DSTATE = rtb_DiscreteTimeIntegrator;

  /* Update for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */
  LX2_DWork.DiscreteTimeIntegrator_IC_LOADI = 0U;
  LX2_DWork.DiscreteTimeIntegrator_DSTATE += 0.000100000005F * rtb_UnitDelay3;
  if (rtb_Reset) {
    LX2_DWork.DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    LX2_DWork.DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */

  /* Update for UnitDelay: '<S7>/Unit Delay4' */
  LX2_DWork.UnitDelay4_DSTATE = rtb_Switch2_kt;

  /* Update for Delay: '<S41>/Delay' */
  LX2_DWork.icLoad_i = 0U;
  LX2_DWork.Delay_DSTATE = rtb_Switch2_kt;

  /* Update for UnitDelay: '<S34>/Delay Input1' */
  LX2_DWork.DelayInput1_DSTATE = LX2_B.BusInput.bNOx_valid;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  LX2_DWork.UnitDelay_DSTATE = 130U;
}

/* Model initialize function */
void LX2_initialize(struct fLX2* inst)
{
  LX2_PrevZCSigState.Delay2_Reset_ZCE = UNINITIALIZED_ZCSIG;
  LX2_PrevZCSigState.Delay1_Reset_ZCE = UNINITIALIZED_ZCSIG;
  LX2_PrevZCSigState.Delay2_Reset_ZCE_o = UNINITIALIZED_ZCSIG;
  LX2_PrevZCSigState.Delay1_Reset_ZCE_n = UNINITIALIZED_ZCSIG;
  LX2_PrevZCSigState.Delay2_Reset_ZCE_or = UNINITIALIZED_ZCSIG;
  LX2_PrevZCSigState.Delay1_Reset_ZCE_e = UNINITIALIZED_ZCSIG;
  LX2_PrevZCSigState.Delay2_Reset_ZCE_k = UNINITIALIZED_ZCSIG;
  LX2_PrevZCSigState.Delay1_Reset_ZCE_k = UNINITIALIZED_ZCSIG;
  LX2_PrevZCSigState.Delay_Reset_ZCE = UNINITIALIZED_ZCSIG;

  /* InitializeConditions for Atomic SubSystem: '<S51>/Filter' */
  LX2_Filter1_Init(&LX2_DWork.Filter, inst);

  /* End of InitializeConditions for SubSystem: '<S51>/Filter' */

  /* InitializeConditions for Atomic SubSystem: '<S51>/Filter1' */
  LX2_Filter1_Init(&LX2_DWork.Filter1, inst);

  /* End of InitializeConditions for SubSystem: '<S51>/Filter1' */

  /* InitializeConditions for Atomic SubSystem: '<S8>/Filter1' */
  LX2_Filter1_Init(&LX2_DWork.Filter1_i, inst);

  /* End of InitializeConditions for SubSystem: '<S8>/Filter1' */

  /* InitializeConditions for Delay: '<S10>/Delay2' */
  LX2_DWork.icLoad = 1U;

  /* InitializeConditions for Delay: '<S10>/Delay1' */
  LX2_DWork.icLoad_o = 1U;

  /* InitializeConditions for Delay: '<S11>/Delay2' */
  LX2_DWork.icLoad_or = 1U;

  /* InitializeConditions for Delay: '<S11>/Delay1' */
  LX2_DWork.icLoad_oj = 1U;

  /* InitializeConditions for Delay: '<S12>/Delay2' */
  LX2_DWork.icLoad_p = 1U;

  /* InitializeConditions for Delay: '<S12>/Delay1' */
  LX2_DWork.icLoad_d = 1U;

  /* InitializeConditions for Delay: '<S13>/Delay2' */
  LX2_DWork.icLoad_f = 1U;

  /* InitializeConditions for Delay: '<S13>/Delay1' */
  LX2_DWork.icLoad_c = 1U;

  /* InitializeConditions for DiscreteIntegrator: '<S36>/Discrete-Time Integrator' */
  LX2_DWork.DiscreteTimeIntegrator_IC_LOADI = 1U;

  /* InitializeConditions for Delay: '<S41>/Delay' */
  LX2_DWork.icLoad_i = 1U;

  /* InitializeConditions for Atomic SubSystem: '<S7>/Filter' */
  /* InitializeConditions for DiscreteIntegrator: '<S35>/Discrete-Time Integrator' */
  LX2_DWork.DiscreteTimeIntegrator_IC_LOA_l = 1U;

  /* End of InitializeConditions for SubSystem: '<S7>/Filter' */
}

/* Model terminate function */
void LX2_terminate(struct fLX2* inst)
{
  /* (no terminate code required) */
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 8.0 (R2012b)20-Jul-2012                                             *
 * Simulink 8.0 (R2012b)20-Jul-2012                                           *
 * Simulink Coder 8.3 (R2012b)20-Jul-2012                                     *
 * Embedded Coder 6.3 (R2012b)20-Jul-2012                                     *
 * Stateflow 8.0 (R2012b)20-Jul-2012                                          *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
