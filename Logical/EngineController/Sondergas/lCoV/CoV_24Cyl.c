/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: CoV_24Cyl
 * File: CoV_24Cyl.c
 * Author: 105055527
 * Created: Tue Sep 23 05:31:36 2014
 ********************************************************************
 * Implementation of program CoV_24Cyl
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "CoV_24Cyl.h"
#include "CoV_24Cyl_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */
struct BlockIO_CoV_24Cyl CoV_24Cyl_B;

/* Block states (auto storage) */
struct D_Work_CoV_24Cyl CoV_24Cyl_DWork;

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Model step function */
void CoV_24Cyl_step(struct CoV* inst)
{
  real_T rtb_SumofElements;
  real32_T rtb_MathFunction[100];
  real32_T rtb_SumofElements2;
  int32_T i;

  /* Sum: '<S1>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S1>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X[i + 1];
  }

  /* End of Sum: '<S1>/Sum of Elements' */

  /* Product: '<S1>/Divide' incorporates:
   *  Constant: '<S1>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S1>/Math Function'
   *
   * About '<S1>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S1>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S1>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X[i] -
      CoV_24Cyl_B.Avg;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S1>/Math Function' */

  /* Sum: '<S1>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S1>/Sum of Elements2' */

  /* Product: '<S1>/Divide1' incorporates:
   *  Constant: '<S1>/set as Ncyc!!!'
   */
  rtb_SumofElements2 = (real32_T)((real_T)rtb_SumofElements2 / 100.0);

  /* Sqrt: '<S1>/Sqrt' */
  CoV_24Cyl_B.Std = (real32_T)sqrt(rtb_SumofElements2);

  /* Saturate: '<S1>/Saturation' */
  if (CoV_24Cyl_B.Avg >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg;
  }

  /* Product: '<S1>/Divide2' incorporates:
   *  Saturate: '<S1>/Saturation'
   */
  CoV_24Cyl_B.CoV = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std;

  /* Sum: '<S2>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S2>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_c[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_c[i + 1];
  }

  /* End of Sum: '<S2>/Sum of Elements' */

  /* Product: '<S2>/Divide' incorporates:
   *  Constant: '<S2>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_g = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S2>/Math Function'
   *
   * About '<S2>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S2>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S2>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_c[i] -
      CoV_24Cyl_B.Avg_g;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S2>/Math Function' */

  /* Sum: '<S2>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S2>/Sum of Elements2' */

  /* Sqrt: '<S2>/Sqrt' incorporates:
   *  Constant: '<S2>/set as Ncyc!!!'
   *  Product: '<S2>/Divide1'
   */
  CoV_24Cyl_B.Std_n = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S2>/Saturation' */
  if (CoV_24Cyl_B.Avg_g >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_g <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_g;
  }

  /* Product: '<S2>/Divide2' incorporates:
   *  Saturate: '<S2>/Saturation'
   */
  CoV_24Cyl_B.CoV_c = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_n;

  /* Sum: '<S13>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S13>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_a[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_a[i + 1];
  }

  /* End of Sum: '<S13>/Sum of Elements' */

  /* Product: '<S13>/Divide' incorporates:
   *  Constant: '<S13>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_d = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S13>/Math Function'
   *
   * About '<S13>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S13>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S13>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_a[i] -
      CoV_24Cyl_B.Avg_d;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S13>/Math Function' */

  /* Sum: '<S13>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S13>/Sum of Elements2' */

  /* Sqrt: '<S13>/Sqrt' incorporates:
   *  Constant: '<S13>/set as Ncyc!!!'
   *  Product: '<S13>/Divide1'
   */
  CoV_24Cyl_B.Std_f = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S13>/Saturation' */
  if (CoV_24Cyl_B.Avg_d >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_d <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_d;
  }

  /* Product: '<S13>/Divide2' incorporates:
   *  Saturate: '<S13>/Saturation'
   */
  CoV_24Cyl_B.CoV_d = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_f;

  /* Sum: '<S19>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S19>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ch[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ch[i +
      1];
  }

  /* End of Sum: '<S19>/Sum of Elements' */

  /* Product: '<S19>/Divide' incorporates:
   *  Constant: '<S19>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_m = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S19>/Math Function'
   *
   * About '<S19>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S19>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S19>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ch[i] -
      CoV_24Cyl_B.Avg_m;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S19>/Math Function' */

  /* Sum: '<S19>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S19>/Sum of Elements2' */

  /* Sqrt: '<S19>/Sqrt' incorporates:
   *  Constant: '<S19>/set as Ncyc!!!'
   *  Product: '<S19>/Divide1'
   */
  CoV_24Cyl_B.Std_i = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S19>/Saturation' */
  if (CoV_24Cyl_B.Avg_m >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_m <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_m;
  }

  /* Product: '<S19>/Divide2' incorporates:
   *  Saturate: '<S19>/Saturation'
   */
  CoV_24Cyl_B.CoV_m = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_i;

  /* Sum: '<S20>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S20>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m[i + 1];
  }

  /* End of Sum: '<S20>/Sum of Elements' */

  /* Product: '<S20>/Divide' incorporates:
   *  Constant: '<S20>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_dg = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S20>/Math Function'
   *
   * About '<S20>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S20>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S20>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m[i] -
      CoV_24Cyl_B.Avg_dg;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S20>/Math Function' */

  /* Sum: '<S20>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S20>/Sum of Elements2' */

  /* Sqrt: '<S20>/Sqrt' incorporates:
   *  Constant: '<S20>/set as Ncyc!!!'
   *  Product: '<S20>/Divide1'
   */
  CoV_24Cyl_B.Std_g = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S20>/Saturation' */
  if (CoV_24Cyl_B.Avg_dg >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_dg <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_dg;
  }

  /* Product: '<S20>/Divide2' incorporates:
   *  Saturate: '<S20>/Saturation'
   */
  CoV_24Cyl_B.CoV_k = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_g;

  /* Sum: '<S21>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S21>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b[i + 1];
  }

  /* End of Sum: '<S21>/Sum of Elements' */

  /* Product: '<S21>/Divide' incorporates:
   *  Constant: '<S21>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_h = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S21>/Math Function'
   *
   * About '<S21>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S21>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S21>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b[i] -
      CoV_24Cyl_B.Avg_h;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S21>/Math Function' */

  /* Sum: '<S21>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S21>/Sum of Elements2' */

  /* Sqrt: '<S21>/Sqrt' incorporates:
   *  Constant: '<S21>/set as Ncyc!!!'
   *  Product: '<S21>/Divide1'
   */
  CoV_24Cyl_B.Std_h = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S21>/Saturation' */
  if (CoV_24Cyl_B.Avg_h >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_h <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_h;
  }

  /* Product: '<S21>/Divide2' incorporates:
   *  Saturate: '<S21>/Saturation'
   */
  CoV_24Cyl_B.CoV_e = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_h;

  /* Sum: '<S22>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S22>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m3[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m3[i +
      1];
  }

  /* End of Sum: '<S22>/Sum of Elements' */

  /* Product: '<S22>/Divide' incorporates:
   *  Constant: '<S22>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_c = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S22>/Math Function'
   *
   * About '<S22>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S22>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S22>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m3[i] -
      CoV_24Cyl_B.Avg_c;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S22>/Math Function' */

  /* Sum: '<S22>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S22>/Sum of Elements2' */

  /* Sqrt: '<S22>/Sqrt' incorporates:
   *  Constant: '<S22>/set as Ncyc!!!'
   *  Product: '<S22>/Divide1'
   */
  CoV_24Cyl_B.Std_k = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S22>/Saturation' */
  if (CoV_24Cyl_B.Avg_c >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_c <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_c;
  }

  /* Product: '<S22>/Divide2' incorporates:
   *  Saturate: '<S22>/Saturation'
   */
  CoV_24Cyl_B.CoV_mz = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_k;

  /* Sum: '<S23>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S23>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ap[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ap[i +
      1];
  }

  /* End of Sum: '<S23>/Sum of Elements' */

  /* Product: '<S23>/Divide' incorporates:
   *  Constant: '<S23>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_a = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S23>/Math Function'
   *
   * About '<S23>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S23>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S23>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ap[i] -
      CoV_24Cyl_B.Avg_a;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S23>/Math Function' */

  /* Sum: '<S23>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S23>/Sum of Elements2' */

  /* Sqrt: '<S23>/Sqrt' incorporates:
   *  Constant: '<S23>/set as Ncyc!!!'
   *  Product: '<S23>/Divide1'
   */
  CoV_24Cyl_B.Std_kl = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S23>/Saturation' */
  if (CoV_24Cyl_B.Avg_a >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_a <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_a;
  }

  /* Product: '<S23>/Divide2' incorporates:
   *  Saturate: '<S23>/Saturation'
   */
  CoV_24Cyl_B.CoV_db = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_kl;

  /* Sum: '<S24>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S24>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_d[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_d[i + 1];
  }

  /* End of Sum: '<S24>/Sum of Elements' */

  /* Product: '<S24>/Divide' incorporates:
   *  Constant: '<S24>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_n = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S24>/Math Function'
   *
   * About '<S24>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S24>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S24>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_d[i] -
      CoV_24Cyl_B.Avg_n;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S24>/Math Function' */

  /* Sum: '<S24>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S24>/Sum of Elements2' */

  /* Sqrt: '<S24>/Sqrt' incorporates:
   *  Constant: '<S24>/set as Ncyc!!!'
   *  Product: '<S24>/Divide1'
   */
  CoV_24Cyl_B.Std_j = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S24>/Saturation' */
  if (CoV_24Cyl_B.Avg_n >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_n <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_n;
  }

  /* Product: '<S24>/Divide2' incorporates:
   *  Saturate: '<S24>/Saturation'
   */
  CoV_24Cyl_B.CoV_n = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_j;

  /* Sum: '<S25>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S25>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_j[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_j[i + 1];
  }

  /* End of Sum: '<S25>/Sum of Elements' */

  /* Product: '<S25>/Divide' incorporates:
   *  Constant: '<S25>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_n5 = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S25>/Math Function'
   *
   * About '<S25>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S25>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S25>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_j[i] -
      CoV_24Cyl_B.Avg_n5;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S25>/Math Function' */

  /* Sum: '<S25>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S25>/Sum of Elements2' */

  /* Sqrt: '<S25>/Sqrt' incorporates:
   *  Constant: '<S25>/set as Ncyc!!!'
   *  Product: '<S25>/Divide1'
   */
  CoV_24Cyl_B.Std_gz = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S25>/Saturation' */
  if (CoV_24Cyl_B.Avg_n5 >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_n5 <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_n5;
  }

  /* Product: '<S25>/Divide2' incorporates:
   *  Saturate: '<S25>/Saturation'
   */
  CoV_24Cyl_B.CoV_l = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_gz;

  /* Sum: '<S3>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S3>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b0[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b0[i +
      1];
  }

  /* End of Sum: '<S3>/Sum of Elements' */

  /* Product: '<S3>/Divide' incorporates:
   *  Constant: '<S3>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_m0 = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S3>/Math Function'
   *
   * About '<S3>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S3>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S3>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b0[i] -
      CoV_24Cyl_B.Avg_m0;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S3>/Math Function' */

  /* Sum: '<S3>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S3>/Sum of Elements2' */

  /* Sqrt: '<S3>/Sqrt' incorporates:
   *  Constant: '<S3>/set as Ncyc!!!'
   *  Product: '<S3>/Divide1'
   */
  CoV_24Cyl_B.Std_l = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S3>/Saturation' */
  if (CoV_24Cyl_B.Avg_m0 >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_m0 <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_m0;
  }

  /* Product: '<S3>/Divide2' incorporates:
   *  Saturate: '<S3>/Saturation'
   */
  CoV_24Cyl_B.CoV_cl = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_l;

  /* Sum: '<S4>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S4>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_da[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_da[i +
      1];
  }

  /* End of Sum: '<S4>/Sum of Elements' */

  /* Product: '<S4>/Divide' incorporates:
   *  Constant: '<S4>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_e = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S4>/Math Function'
   *
   * About '<S4>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S4>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S4>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_da[i] -
      CoV_24Cyl_B.Avg_e;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S4>/Math Function' */

  /* Sum: '<S4>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S4>/Sum of Elements2' */

  /* Sqrt: '<S4>/Sqrt' incorporates:
   *  Constant: '<S4>/set as Ncyc!!!'
   *  Product: '<S4>/Divide1'
   */
  CoV_24Cyl_B.Std_hh = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S4>/Saturation' */
  if (CoV_24Cyl_B.Avg_e >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_e <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_e;
  }

  /* Product: '<S4>/Divide2' incorporates:
   *  Saturate: '<S4>/Saturation'
   */
  CoV_24Cyl_B.CoV_me = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_hh;

  /* Sum: '<S5>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S5>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_di[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_di[i +
      1];
  }

  /* End of Sum: '<S5>/Sum of Elements' */

  /* Product: '<S5>/Divide' incorporates:
   *  Constant: '<S5>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_n4 = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S5>/Math Function'
   *
   * About '<S5>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S5>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S5>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_di[i] -
      CoV_24Cyl_B.Avg_n4;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S5>/Math Function' */

  /* Sum: '<S5>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S5>/Sum of Elements2' */

  /* Sqrt: '<S5>/Sqrt' incorporates:
   *  Constant: '<S5>/set as Ncyc!!!'
   *  Product: '<S5>/Divide1'
   */
  CoV_24Cyl_B.Std_hx = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S5>/Saturation' */
  if (CoV_24Cyl_B.Avg_n4 >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_n4 <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_n4;
  }

  /* Product: '<S5>/Divide2' incorporates:
   *  Saturate: '<S5>/Saturation'
   */
  CoV_24Cyl_B.CoV_lo = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_hx;

  /* Sum: '<S6>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S6>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g[i + 1];
  }

  /* End of Sum: '<S6>/Sum of Elements' */

  /* Product: '<S6>/Divide' incorporates:
   *  Constant: '<S6>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_e5 = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S6>/Math Function'
   *
   * About '<S6>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S6>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S6>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g[i] -
      CoV_24Cyl_B.Avg_e5;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S6>/Math Function' */

  /* Sum: '<S6>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S6>/Sum of Elements2' */

  /* Sqrt: '<S6>/Sqrt' incorporates:
   *  Constant: '<S6>/set as Ncyc!!!'
   *  Product: '<S6>/Divide1'
   */
  CoV_24Cyl_B.Std_e = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S6>/Saturation' */
  if (CoV_24Cyl_B.Avg_e5 >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_e5 <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_e5;
  }

  /* Product: '<S6>/Divide2' incorporates:
   *  Saturate: '<S6>/Saturation'
   */
  CoV_24Cyl_B.CoV_f = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_e;

  /* Sum: '<S7>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S7>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jg[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jg[i +
      1];
  }

  /* End of Sum: '<S7>/Sum of Elements' */

  /* Product: '<S7>/Divide' incorporates:
   *  Constant: '<S7>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_eu = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S7>/Math Function'
   *
   * About '<S7>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S7>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S7>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jg[i] -
      CoV_24Cyl_B.Avg_eu;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S7>/Math Function' */

  /* Sum: '<S7>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S7>/Sum of Elements2' */

  /* Sqrt: '<S7>/Sqrt' incorporates:
   *  Constant: '<S7>/set as Ncyc!!!'
   *  Product: '<S7>/Divide1'
   */
  CoV_24Cyl_B.Std_m = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S7>/Saturation' */
  if (CoV_24Cyl_B.Avg_eu >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_eu <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_eu;
  }

  /* Product: '<S7>/Divide2' incorporates:
   *  Saturate: '<S7>/Saturation'
   */
  CoV_24Cyl_B.CoV_i = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_m;

  /* Sum: '<S8>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S8>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_l[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_l[i + 1];
  }

  /* End of Sum: '<S8>/Sum of Elements' */

  /* Product: '<S8>/Divide' incorporates:
   *  Constant: '<S8>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_ey = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S8>/Math Function'
   *
   * About '<S8>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S8>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S8>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_l[i] -
      CoV_24Cyl_B.Avg_ey;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S8>/Math Function' */

  /* Sum: '<S8>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S8>/Sum of Elements2' */

  /* Sqrt: '<S8>/Sqrt' incorporates:
   *  Constant: '<S8>/set as Ncyc!!!'
   *  Product: '<S8>/Divide1'
   */
  CoV_24Cyl_B.Std_b = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S8>/Saturation' */
  if (CoV_24Cyl_B.Avg_ey >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_ey <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_ey;
  }

  /* Product: '<S8>/Divide2' incorporates:
   *  Saturate: '<S8>/Saturation'
   */
  CoV_24Cyl_B.CoV_lh = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_b;

  /* Sum: '<S9>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S9>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f[i + 1];
  }

  /* End of Sum: '<S9>/Sum of Elements' */

  /* Product: '<S9>/Divide' incorporates:
   *  Constant: '<S9>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_j = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S9>/Math Function'
   *
   * About '<S9>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S9>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S9>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f[i] -
      CoV_24Cyl_B.Avg_j;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S9>/Math Function' */

  /* Sum: '<S9>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S9>/Sum of Elements2' */

  /* Sqrt: '<S9>/Sqrt' incorporates:
   *  Constant: '<S9>/set as Ncyc!!!'
   *  Product: '<S9>/Divide1'
   */
  CoV_24Cyl_B.Std_ev = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S9>/Saturation' */
  if (CoV_24Cyl_B.Avg_j >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_j <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_j;
  }

  /* Product: '<S9>/Divide2' incorporates:
   *  Saturate: '<S9>/Saturation'
   */
  CoV_24Cyl_B.CoV_mw = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_ev;

  /* Sum: '<S10>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S10>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_n[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_n[i + 1];
  }

  /* End of Sum: '<S10>/Sum of Elements' */

  /* Product: '<S10>/Divide' incorporates:
   *  Constant: '<S10>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_p = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S10>/Math Function'
   *
   * About '<S10>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S10>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S10>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_n[i] -
      CoV_24Cyl_B.Avg_p;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S10>/Math Function' */

  /* Sum: '<S10>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S10>/Sum of Elements2' */

  /* Sqrt: '<S10>/Sqrt' incorporates:
   *  Constant: '<S10>/set as Ncyc!!!'
   *  Product: '<S10>/Divide1'
   */
  CoV_24Cyl_B.Std_a = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S10>/Saturation' */
  if (CoV_24Cyl_B.Avg_p >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_p <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_p;
  }

  /* Product: '<S10>/Divide2' incorporates:
   *  Saturate: '<S10>/Saturation'
   */
  CoV_24Cyl_B.CoV_iy = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_a;

  /* Sum: '<S11>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S11>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f0[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f0[i +
      1];
  }

  /* End of Sum: '<S11>/Sum of Elements' */

  /* Product: '<S11>/Divide' incorporates:
   *  Constant: '<S11>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_gz = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S11>/Math Function'
   *
   * About '<S11>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S11>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S11>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f0[i] -
      CoV_24Cyl_B.Avg_gz;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S11>/Math Function' */

  /* Sum: '<S11>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S11>/Sum of Elements2' */

  /* Sqrt: '<S11>/Sqrt' incorporates:
   *  Constant: '<S11>/set as Ncyc!!!'
   *  Product: '<S11>/Divide1'
   */
  CoV_24Cyl_B.Std_d = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S11>/Saturation' */
  if (CoV_24Cyl_B.Avg_gz >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_gz <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_gz;
  }

  /* Product: '<S11>/Divide2' incorporates:
   *  Saturate: '<S11>/Saturation'
   */
  CoV_24Cyl_B.CoV_cc = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_d;

  /* Sum: '<S12>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S12>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ln[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ln[i +
      1];
  }

  /* End of Sum: '<S12>/Sum of Elements' */

  /* Product: '<S12>/Divide' incorporates:
   *  Constant: '<S12>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_pv = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S12>/Math Function'
   *
   * About '<S12>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S12>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S12>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ln[i] -
      CoV_24Cyl_B.Avg_pv;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S12>/Math Function' */

  /* Sum: '<S12>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S12>/Sum of Elements2' */

  /* Sqrt: '<S12>/Sqrt' incorporates:
   *  Constant: '<S12>/set as Ncyc!!!'
   *  Product: '<S12>/Divide1'
   */
  CoV_24Cyl_B.Std_ht = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S12>/Saturation' */
  if (CoV_24Cyl_B.Avg_pv >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_pv <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_pv;
  }

  /* Product: '<S12>/Divide2' incorporates:
   *  Saturate: '<S12>/Saturation'
   */
  CoV_24Cyl_B.CoV_h = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_ht;

  /* Sum: '<S14>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S14>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jc[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jc[i +
      1];
  }

  /* End of Sum: '<S14>/Sum of Elements' */

  /* Product: '<S14>/Divide' incorporates:
   *  Constant: '<S14>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_d2 = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S14>/Math Function'
   *
   * About '<S14>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S14>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S14>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jc[i] -
      CoV_24Cyl_B.Avg_d2;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S14>/Math Function' */

  /* Sum: '<S14>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S14>/Sum of Elements2' */

  /* Sqrt: '<S14>/Sqrt' incorporates:
   *  Constant: '<S14>/set as Ncyc!!!'
   *  Product: '<S14>/Divide1'
   */
  CoV_24Cyl_B.Std_ji = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S14>/Saturation' */
  if (CoV_24Cyl_B.Avg_d2 >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_d2 <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_d2;
  }

  /* Product: '<S14>/Divide2' incorporates:
   *  Saturate: '<S14>/Saturation'
   */
  CoV_24Cyl_B.CoV_hj = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_ji;

  /* Sum: '<S15>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S15>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_i[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_i[i + 1];
  }

  /* End of Sum: '<S15>/Sum of Elements' */

  /* Product: '<S15>/Divide' incorporates:
   *  Constant: '<S15>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_b = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S15>/Math Function'
   *
   * About '<S15>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S15>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S15>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_i[i] -
      CoV_24Cyl_B.Avg_b;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S15>/Math Function' */

  /* Sum: '<S15>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S15>/Sum of Elements2' */

  /* Sqrt: '<S15>/Sqrt' incorporates:
   *  Constant: '<S15>/set as Ncyc!!!'
   *  Product: '<S15>/Divide1'
   */
  CoV_24Cyl_B.Std_ag = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S15>/Saturation' */
  if (CoV_24Cyl_B.Avg_b >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_b <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_b;
  }

  /* Product: '<S15>/Divide2' incorporates:
   *  Saturate: '<S15>/Saturation'
   */
  CoV_24Cyl_B.CoV_j = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_ag;

  /* Sum: '<S16>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S16>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_mr[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_mr[i +
      1];
  }

  /* End of Sum: '<S16>/Sum of Elements' */

  /* Product: '<S16>/Divide' incorporates:
   *  Constant: '<S16>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_o = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S16>/Math Function'
   *
   * About '<S16>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S16>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S16>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_mr[i] -
      CoV_24Cyl_B.Avg_o;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S16>/Math Function' */

  /* Sum: '<S16>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S16>/Sum of Elements2' */

  /* Sqrt: '<S16>/Sqrt' incorporates:
   *  Constant: '<S16>/set as Ncyc!!!'
   *  Product: '<S16>/Divide1'
   */
  CoV_24Cyl_B.Std_gd = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S16>/Saturation' */
  if (CoV_24Cyl_B.Avg_o >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_o <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_o;
  }

  /* Product: '<S16>/Divide2' incorporates:
   *  Saturate: '<S16>/Saturation'
   */
  CoV_24Cyl_B.CoV_nw = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_gd;

  /* Sum: '<S17>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S17>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g1[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g1[i +
      1];
  }

  /* End of Sum: '<S17>/Sum of Elements' */

  /* Product: '<S17>/Divide' incorporates:
   *  Constant: '<S17>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_l = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S17>/Math Function'
   *
   * About '<S17>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S17>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S17>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g1[i] -
      CoV_24Cyl_B.Avg_l;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S17>/Math Function' */

  /* Sum: '<S17>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S17>/Sum of Elements2' */

  /* Sqrt: '<S17>/Sqrt' incorporates:
   *  Constant: '<S17>/set as Ncyc!!!'
   *  Product: '<S17>/Divide1'
   */
  CoV_24Cyl_B.Std_ik = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S17>/Saturation' */
  if (CoV_24Cyl_B.Avg_l >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_l <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_l;
  }

  /* Product: '<S17>/Divide2' incorporates:
   *  Saturate: '<S17>/Saturation'
   */
  CoV_24Cyl_B.CoV_o = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_ik;

  /* Sum: '<S18>/Sum of Elements' incorporates:
   *  S-Function (sfix_udelay): '<S18>/Tapped Delay set as N_cyc!!!'
   */
  rtb_SumofElements = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_cc[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements += (real_T)CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_cc[i +
      1];
  }

  /* End of Sum: '<S18>/Sum of Elements' */

  /* Product: '<S18>/Divide' incorporates:
   *  Constant: '<S18>/set as Ncyc!!!'
   */
  CoV_24Cyl_B.Avg_lu = (real32_T)(rtb_SumofElements / 100.0);

  /* Math: '<S18>/Math Function'
   *
   * About '<S18>/Math Function':
   *  Operator: magnitude^2
   */
  for (i = 0; i < 100; i++) {
    /* Sum: '<S18>/Add' incorporates:
     *  S-Function (sfix_udelay): '<S18>/Tapped Delay set as N_cyc!!!'
     */
    rtb_SumofElements2 = CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_cc[i] -
      CoV_24Cyl_B.Avg_lu;
    rtb_MathFunction[i] = rtb_SumofElements2 * rtb_SumofElements2;
  }

  /* End of Math: '<S18>/Math Function' */

  /* Sum: '<S18>/Sum of Elements2' */
  rtb_SumofElements2 = rtb_MathFunction[0];
  for (i = 0; i < 99; i++) {
    rtb_SumofElements2 += rtb_MathFunction[i + 1];
  }

  /* End of Sum: '<S18>/Sum of Elements2' */

  /* Sqrt: '<S18>/Sqrt' incorporates:
   *  Constant: '<S18>/set as Ncyc!!!'
   *  Product: '<S18>/Divide1'
   */
  CoV_24Cyl_B.Std_c = (real32_T)sqrt((real32_T)((real_T)rtb_SumofElements2 /
    100.0));

  /* Saturate: '<S18>/Saturation' */
  if (CoV_24Cyl_B.Avg_lu >= 100.0F) {
    rtb_SumofElements2 = 100.0F;
  } else if (CoV_24Cyl_B.Avg_lu <= 0.1F) {
    rtb_SumofElements2 = 0.1F;
  } else {
    rtb_SumofElements2 = CoV_24Cyl_B.Avg_lu;
  }

  /* Product: '<S18>/Divide2' incorporates:
   *  Saturate: '<S18>/Saturation'
   */
  CoV_24Cyl_B.CoV_ja = 1.0F / rtb_SumofElements2 * CoV_24Cyl_B.Std_c;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->CoV[0] = CoV_24Cyl_B.CoV;
  inst->CoV[1] = CoV_24Cyl_B.CoV_c;
  inst->CoV[2] = CoV_24Cyl_B.CoV_d;
  inst->CoV[3] = CoV_24Cyl_B.CoV_m;
  inst->CoV[4] = CoV_24Cyl_B.CoV_k;
  inst->CoV[5] = CoV_24Cyl_B.CoV_e;
  inst->CoV[6] = CoV_24Cyl_B.CoV_mz;
  inst->CoV[7] = CoV_24Cyl_B.CoV_db;
  inst->CoV[8] = CoV_24Cyl_B.CoV_n;
  inst->CoV[9] = CoV_24Cyl_B.CoV_l;
  inst->CoV[10] = CoV_24Cyl_B.CoV_cl;
  inst->CoV[11] = CoV_24Cyl_B.CoV_me;
  inst->CoV[12] = CoV_24Cyl_B.CoV_lo;
  inst->CoV[13] = CoV_24Cyl_B.CoV_f;
  inst->CoV[14] = CoV_24Cyl_B.CoV_i;
  inst->CoV[15] = CoV_24Cyl_B.CoV_lh;
  inst->CoV[16] = CoV_24Cyl_B.CoV_mw;
  inst->CoV[17] = CoV_24Cyl_B.CoV_iy;
  inst->CoV[18] = CoV_24Cyl_B.CoV_cc;
  inst->CoV[19] = CoV_24Cyl_B.CoV_h;
  inst->CoV[20] = CoV_24Cyl_B.CoV_hj;
  inst->CoV[21] = CoV_24Cyl_B.CoV_j;
  inst->CoV[22] = CoV_24Cyl_B.CoV_nw;
  inst->CoV[23] = CoV_24Cyl_B.CoV_o;
  inst->CoV[24] = CoV_24Cyl_B.CoV_ja;

  /* S-Function (bur_out): '<Root>/Output1' */
  inst->Avg[0] = CoV_24Cyl_B.Avg;
  inst->Avg[1] = CoV_24Cyl_B.Avg_g;
  inst->Avg[2] = CoV_24Cyl_B.Avg_d;
  inst->Avg[3] = CoV_24Cyl_B.Avg_m;
  inst->Avg[4] = CoV_24Cyl_B.Avg_dg;
  inst->Avg[5] = CoV_24Cyl_B.Avg_h;
  inst->Avg[6] = CoV_24Cyl_B.Avg_c;
  inst->Avg[7] = CoV_24Cyl_B.Avg_a;
  inst->Avg[8] = CoV_24Cyl_B.Avg_n;
  inst->Avg[9] = CoV_24Cyl_B.Avg_n5;
  inst->Avg[10] = CoV_24Cyl_B.Avg_m0;
  inst->Avg[11] = CoV_24Cyl_B.Avg_e;
  inst->Avg[12] = CoV_24Cyl_B.Avg_n4;
  inst->Avg[13] = CoV_24Cyl_B.Avg_e5;
  inst->Avg[14] = CoV_24Cyl_B.Avg_eu;
  inst->Avg[15] = CoV_24Cyl_B.Avg_ey;
  inst->Avg[16] = CoV_24Cyl_B.Avg_j;
  inst->Avg[17] = CoV_24Cyl_B.Avg_p;
  inst->Avg[18] = CoV_24Cyl_B.Avg_gz;
  inst->Avg[19] = CoV_24Cyl_B.Avg_pv;
  inst->Avg[20] = CoV_24Cyl_B.Avg_d2;
  inst->Avg[21] = CoV_24Cyl_B.Avg_b;
  inst->Avg[22] = CoV_24Cyl_B.Avg_o;
  inst->Avg[23] = CoV_24Cyl_B.Avg_l;
  inst->Avg[24] = CoV_24Cyl_B.Avg_lu;

  /* S-Function (bur_out): '<Root>/Output2' */
  inst->Std[0] = CoV_24Cyl_B.Std;
  inst->Std[1] = CoV_24Cyl_B.Std_n;
  inst->Std[2] = CoV_24Cyl_B.Std_f;
  inst->Std[3] = CoV_24Cyl_B.Std_i;
  inst->Std[4] = CoV_24Cyl_B.Std_g;
  inst->Std[5] = CoV_24Cyl_B.Std_h;
  inst->Std[6] = CoV_24Cyl_B.Std_k;
  inst->Std[7] = CoV_24Cyl_B.Std_kl;
  inst->Std[8] = CoV_24Cyl_B.Std_j;
  inst->Std[9] = CoV_24Cyl_B.Std_gz;
  inst->Std[10] = CoV_24Cyl_B.Std_l;
  inst->Std[11] = CoV_24Cyl_B.Std_hh;
  inst->Std[12] = CoV_24Cyl_B.Std_hx;
  inst->Std[13] = CoV_24Cyl_B.Std_e;
  inst->Std[14] = CoV_24Cyl_B.Std_m;
  inst->Std[15] = CoV_24Cyl_B.Std_b;
  inst->Std[16] = CoV_24Cyl_B.Std_ev;
  inst->Std[17] = CoV_24Cyl_B.Std_a;
  inst->Std[18] = CoV_24Cyl_B.Std_d;
  inst->Std[19] = CoV_24Cyl_B.Std_ht;
  inst->Std[20] = CoV_24Cyl_B.Std_ji;
  inst->Std[21] = CoV_24Cyl_B.Std_ag;
  inst->Std[22] = CoV_24Cyl_B.Std_gd;
  inst->Std[23] = CoV_24Cyl_B.Std_ik;
  inst->Std[24] = CoV_24Cyl_B.Std_c;

  /* S-Function (bur_in): '<Root>/Input25' */
  {
    int_T i1;
    real32_T *y0 = CoV_24Cyl_B.Input25;
    for (i1=0; i1 < 25; i1++) {
      y0[i1] = inst->In[i1];
    }
  }

  /* Selector: '<S1>/Selector' incorporates:
   *  Constant: '<Root>/Constant24'
   */
  CoV_24Cyl_B.Selector = CoV_24Cyl_B.Input25[0];

  /* Selector: '<S2>/Selector' incorporates:
   *  Constant: '<Root>/Constant'
   */
  CoV_24Cyl_B.Selector_l = CoV_24Cyl_B.Input25[1];

  /* Selector: '<S3>/Selector' incorporates:
   *  Constant: '<Root>/Constant9'
   */
  CoV_24Cyl_B.Selector_a = CoV_24Cyl_B.Input25[10];

  /* Selector: '<S4>/Selector' incorporates:
   *  Constant: '<Root>/Constant10'
   */
  CoV_24Cyl_B.Selector_n = CoV_24Cyl_B.Input25[11];

  /* Selector: '<S5>/Selector' incorporates:
   *  Constant: '<Root>/Constant11'
   */
  CoV_24Cyl_B.Selector_c = CoV_24Cyl_B.Input25[12];

  /* Selector: '<S6>/Selector' incorporates:
   *  Constant: '<Root>/Constant12'
   */
  CoV_24Cyl_B.Selector_c4 = CoV_24Cyl_B.Input25[13];

  /* Selector: '<S7>/Selector' incorporates:
   *  Constant: '<Root>/Constant13'
   */
  CoV_24Cyl_B.Selector_g = CoV_24Cyl_B.Input25[14];

  /* Selector: '<S8>/Selector' incorporates:
   *  Constant: '<Root>/Constant14'
   */
  CoV_24Cyl_B.Selector_o = CoV_24Cyl_B.Input25[15];

  /* Selector: '<S9>/Selector' incorporates:
   *  Constant: '<Root>/Constant15'
   */
  CoV_24Cyl_B.Selector_ct = CoV_24Cyl_B.Input25[16];

  /* Selector: '<S10>/Selector' incorporates:
   *  Constant: '<Root>/Constant16'
   */
  CoV_24Cyl_B.Selector_h = CoV_24Cyl_B.Input25[17];

  /* Selector: '<S11>/Selector' incorporates:
   *  Constant: '<Root>/Constant17'
   */
  CoV_24Cyl_B.Selector_lk = CoV_24Cyl_B.Input25[18];

  /* Selector: '<S12>/Selector' incorporates:
   *  Constant: '<Root>/Constant18'
   */
  CoV_24Cyl_B.Selector_b = CoV_24Cyl_B.Input25[19];

  /* Selector: '<S13>/Selector' incorporates:
   *  Constant: '<Root>/Constant1'
   */
  CoV_24Cyl_B.Selector_al = CoV_24Cyl_B.Input25[2];

  /* Selector: '<S14>/Selector' incorporates:
   *  Constant: '<Root>/Constant19'
   */
  CoV_24Cyl_B.Selector_j = CoV_24Cyl_B.Input25[20];

  /* Selector: '<S15>/Selector' incorporates:
   *  Constant: '<Root>/Constant20'
   */
  CoV_24Cyl_B.Selector_d = CoV_24Cyl_B.Input25[21];

  /* Selector: '<S16>/Selector' incorporates:
   *  Constant: '<Root>/Constant21'
   */
  CoV_24Cyl_B.Selector_f = CoV_24Cyl_B.Input25[22];

  /* Selector: '<S17>/Selector' incorporates:
   *  Constant: '<Root>/Constant22'
   */
  CoV_24Cyl_B.Selector_p = CoV_24Cyl_B.Input25[23];

  /* Selector: '<S18>/Selector' incorporates:
   *  Constant: '<Root>/Constant23'
   */
  CoV_24Cyl_B.Selector_hu = CoV_24Cyl_B.Input25[24];

  /* Selector: '<S19>/Selector' incorporates:
   *  Constant: '<Root>/Constant2'
   */
  CoV_24Cyl_B.Selector_ob = CoV_24Cyl_B.Input25[3];

  /* Selector: '<S20>/Selector' incorporates:
   *  Constant: '<Root>/Constant3'
   */
  CoV_24Cyl_B.Selector_ox = CoV_24Cyl_B.Input25[4];

  /* Selector: '<S21>/Selector' incorporates:
   *  Constant: '<Root>/Constant4'
   */
  CoV_24Cyl_B.Selector_m = CoV_24Cyl_B.Input25[5];

  /* Selector: '<S22>/Selector' incorporates:
   *  Constant: '<Root>/Constant5'
   */
  CoV_24Cyl_B.Selector_p5 = CoV_24Cyl_B.Input25[6];

  /* Selector: '<S23>/Selector' incorporates:
   *  Constant: '<Root>/Constant6'
   */
  CoV_24Cyl_B.Selector_k = CoV_24Cyl_B.Input25[7];

  /* Selector: '<S24>/Selector' incorporates:
   *  Constant: '<Root>/Constant7'
   */
  CoV_24Cyl_B.Selector_og = CoV_24Cyl_B.Input25[8];

  /* Selector: '<S25>/Selector' incorporates:
   *  Constant: '<Root>/Constant8'
   */
  CoV_24Cyl_B.Selector_fv = CoV_24Cyl_B.Input25[9];

  /* Update for S-Function (sfix_udelay): '<S1>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X[99] = CoV_24Cyl_B.Selector;

  /* End of Update for S-Function (sfix_udelay): '<S1>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S2>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_c[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_c[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_c[99] = CoV_24Cyl_B.Selector_l;

  /* End of Update for S-Function (sfix_udelay): '<S2>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S13>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_a[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_a[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_a[99] = CoV_24Cyl_B.Selector_al;

  /* End of Update for S-Function (sfix_udelay): '<S13>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S19>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ch[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ch[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ch[99] = CoV_24Cyl_B.Selector_ob;

  /* End of Update for S-Function (sfix_udelay): '<S19>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S20>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m[99] = CoV_24Cyl_B.Selector_ox;

  /* End of Update for S-Function (sfix_udelay): '<S20>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S21>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b[99] = CoV_24Cyl_B.Selector_m;

  /* End of Update for S-Function (sfix_udelay): '<S21>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S22>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m3[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m3[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_m3[99] = CoV_24Cyl_B.Selector_p5;

  /* End of Update for S-Function (sfix_udelay): '<S22>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S23>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ap[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ap[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ap[99] = CoV_24Cyl_B.Selector_k;

  /* End of Update for S-Function (sfix_udelay): '<S23>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S24>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_d[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_d[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_d[99] = CoV_24Cyl_B.Selector_og;

  /* End of Update for S-Function (sfix_udelay): '<S24>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S25>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_j[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_j[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_j[99] = CoV_24Cyl_B.Selector_fv;

  /* End of Update for S-Function (sfix_udelay): '<S25>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S3>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b0[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b0[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_b0[99] = CoV_24Cyl_B.Selector_a;

  /* End of Update for S-Function (sfix_udelay): '<S3>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S4>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_da[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_da[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_da[99] = CoV_24Cyl_B.Selector_n;

  /* End of Update for S-Function (sfix_udelay): '<S4>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S5>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_di[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_di[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_di[99] = CoV_24Cyl_B.Selector_c;

  /* End of Update for S-Function (sfix_udelay): '<S5>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S6>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g[99] = CoV_24Cyl_B.Selector_c4;

  /* End of Update for S-Function (sfix_udelay): '<S6>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S7>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jg[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jg[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jg[99] = CoV_24Cyl_B.Selector_g;

  /* End of Update for S-Function (sfix_udelay): '<S7>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S8>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_l[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_l[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_l[99] = CoV_24Cyl_B.Selector_o;

  /* End of Update for S-Function (sfix_udelay): '<S8>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S9>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f[99] = CoV_24Cyl_B.Selector_ct;

  /* End of Update for S-Function (sfix_udelay): '<S9>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S10>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_n[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_n[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_n[99] = CoV_24Cyl_B.Selector_h;

  /* End of Update for S-Function (sfix_udelay): '<S10>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S11>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f0[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f0[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_f0[99] = CoV_24Cyl_B.Selector_lk;

  /* End of Update for S-Function (sfix_udelay): '<S11>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S12>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ln[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ln[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_ln[99] = CoV_24Cyl_B.Selector_b;

  /* End of Update for S-Function (sfix_udelay): '<S12>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S14>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jc[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jc[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_jc[99] = CoV_24Cyl_B.Selector_j;

  /* End of Update for S-Function (sfix_udelay): '<S14>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S15>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_i[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_i[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_i[99] = CoV_24Cyl_B.Selector_d;

  /* End of Update for S-Function (sfix_udelay): '<S15>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S16>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_mr[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_mr[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_mr[99] = CoV_24Cyl_B.Selector_f;

  /* End of Update for S-Function (sfix_udelay): '<S16>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S17>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g1[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g1[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_g1[99] = CoV_24Cyl_B.Selector_p;

  /* End of Update for S-Function (sfix_udelay): '<S17>/Tapped Delay set as N_cyc!!!' */

  /* Update for S-Function (sfix_udelay): '<S18>/Tapped Delay set as N_cyc!!!' */
  for (i = 0; i < 99; i++) {
    CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_cc[i] =
      CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_cc[i + 1];
  }

  CoV_24Cyl_DWork.TappedDelaysetasN_cyc_X_cc[99] = CoV_24Cyl_B.Selector_hu;

  /* End of Update for S-Function (sfix_udelay): '<S18>/Tapped Delay set as N_cyc!!!' */
}

/* Model initialize function */
void CoV_24Cyl_initialize(struct CoV* inst)
{
  /* (no initialization code required) */
}

/* Model terminate function */
void CoV_24Cyl_terminate(struct CoV* inst)
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
