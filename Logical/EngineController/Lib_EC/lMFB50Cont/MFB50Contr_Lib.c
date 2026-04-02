/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: MFB50Contr_Lib
 * File: MFB50Contr_Lib.c
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Implementation of program MFB50Contr_Lib
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "MFB50Contr_Lib.h"
#include "MFB50Contr_Lib_private.h"

/*  Defines */

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/* Block signals (auto storage) */
struct BlockIO_MFB50Contr_Lib MFB50Contr_Lib_B;

/* Block states (auto storage) */
struct D_Work_MFB50Contr_Lib MFB50Contr_Lib_DWork;

/*  Declarations  */

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/* Lookup Binary Search Utility BINARYSEARCH_real_T */
void BINARYSEARCH_real_T(uint32_T *piLeft, uint32_T *piRght, real_T u, const
  real_T *pData, uint32_T iHi, struct MFB50Contr* inst)
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

/* Lookup Utility LookUp_real_T_real_T */
void LookUp_real_T_real_T(real_T *pY, const real_T *pYData, real_T u, const
  real_T *pUData, uint32_T iHi, struct MFB50Contr* inst)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_real_T( &(iLeft), &(iRght), u, pUData, iHi, inst);

  {
    real_T lambda;
    if (pUData[iRght] > pUData[iLeft] ) {
      real_T num;
      real_T den;
      den = pUData[iRght];
      den = den - pUData[iLeft];
      num = u;
      num = num - pUData[iLeft];
      lambda = num / den;
    } else {
      lambda = 0.0;
    }

    {
      real_T yLeftCast;
      real_T yRghtCast;
      yLeftCast = pYData[iLeft];
      yRghtCast = pYData[iRght];
      yLeftCast += lambda * ( yRghtCast - yLeftCast );
      (*pY) = yLeftCast;
    }
  }
}

real_T rt_roundd(real_T u, struct MFB50Contr* inst)
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

/* Model step function */
void MFB50Contr_Lib_step(struct MFB50Contr* inst)
{
  int8_T idx[21];
  int32_T k;
  int8_T idx_0[21];
  int32_T i;
  int32_T j;
  int32_T p;
  int32_T q;
  int32_T qEnd;
  int32_T kEnd;
  real_T rtb_Switch1_e;
  real_T rtb_Switch2;
  boolean_T rtb_Compare;
  real_T rtb_Switch1;
  boolean_T rtb_Switch_k[21];
  int32_T s10_iter;
  int32_T i_0;

  /* Switch: '<S8>/Switch' incorporates:
   *  Constant: '<Root>/inst->engSpeed (rpm)'
   *  Constant: '<S8>/const1'
   */
  if (inst->engSpeed > 0.0) {
    rtb_Switch1 = inst->engSpeed;
  } else {
    rtb_Switch1 = 1.0;
  }

  /* End of Switch: '<S8>/Switch' */

  /* Product: '<S8>/Divide' incorporates:
   *  Constant: '<S8>/const'
   */
  MFB50Contr_Lib_B.Divide = 120.0 / rtb_Switch1;

  /* Switch: '<S8>/Switch2' incorporates:
   *  Constant: '<S8>/const4'
   *  Sum: '<S8>/Add'
   *  Sum: '<S8>/Add1'
   *  UnitDelay: '<S8>/Unit Delay'
   */
  if ((0.01 + MFB50Contr_Lib_DWork.UnitDelay_DSTATE) - MFB50Contr_Lib_B.Divide >=
      0.0) {
    rtb_Switch2 = 0.01;
  } else {
    rtb_Switch2 = 0.01 + MFB50Contr_Lib_DWork.UnitDelay_DSTATE;
  }

  /* End of Switch: '<S8>/Switch2' */

  /* DataTypeConversion: '<S8>/Data Type Conversion' incorporates:
   *  Constant: '<S8>/const4'
   *  Product: '<S8>/Divide2'
   */
  rtb_Switch1 = fmod(rt_roundd(100.0 * rtb_Switch2, inst), 4.294967296E+9);
  MFB50Contr_Lib_B.DataTypeConversion = rtb_Switch1 < 0.0 ? -(int32_T)(uint32_T)
    -rtb_Switch1 : (int32_T)(uint32_T)rtb_Switch1;

  /* Switch: '<Root>/Switch1' incorporates:
   *  Constant: '<Root>/Constant1'
   *  Constant: '<Root>/inputvariable6'
   */
  if (inst->MFB50ContrEn) {
    rtb_Switch1_e = (real_T)MFB50Contr_Lib_B.DataTypeConversion;
  } else {
    rtb_Switch1_e = 99.0;
  }

  /* End of Switch: '<Root>/Switch1' */

  /* MATLAB Function: '<Root>/Median' incorporates:
   *  Constant: '<Root>/inputvariable8'
   */
  /* MATLAB Function 'Median': '<S5>:1' */
  /*  Output */
  /*  y_f: filtered signal - tustin approximation */
  /* '<S5>:1:6' */
  for (s10_iter = 0; s10_iter < 21; s10_iter++) {
    idx[s10_iter] = (int8_T)(s10_iter + 1);
  }

  for (s10_iter = 0; s10_iter <= 18; s10_iter += 2) {
    if (!(inst->MFB50ActAllCyl[s10_iter] <= inst->MFB50ActAllCyl[s10_iter + 1])) {
      idx[s10_iter] = (int8_T)(s10_iter + 2);
      idx[s10_iter + 1] = (int8_T)(s10_iter + 1);
    }
  }

  for (i_0 = 0; i_0 < 21; i_0++) {
    idx_0[i_0] = 1;
  }

  i_0 = 2;
  while (i_0 < 21) {
    i = i_0 << 1;
    j = 1;
    s10_iter = 1 + i_0;
    while (s10_iter < 22) {
      p = j;
      q = s10_iter;
      qEnd = j + i;
      if (qEnd > 22) {
        qEnd = 22;
      }

      k = 0;
      kEnd = qEnd - j;
      while (k + 1 <= kEnd) {
        if (inst->MFB50ActAllCyl[idx[p - 1] - 1] <= inst->MFB50ActAllCyl[idx[q - 1] - 1]) {
          idx_0[k] = idx[p - 1];
          p++;
          if (p == s10_iter) {
            while (q < qEnd) {
              k++;
              idx_0[k] = idx[q - 1];
              q++;
            }
          }
        } else {
          idx_0[k] = idx[q - 1];
          q++;
          if (q == qEnd) {
            while (p < s10_iter) {
              k++;
              idx_0[k] = idx[p - 1];
              p++;
            }
          }
        }

        k++;
      }

      for (s10_iter = 0; s10_iter + 1 <= kEnd; s10_iter++) {
        idx[(j + s10_iter) - 1] = idx_0[s10_iter];
      }

      j = qEnd;
      s10_iter = qEnd + i_0;
    }

    i_0 = i;
  }

  MFB50Contr_Lib_B.y_median = inst->MFB50ActAllCyl[idx[10] - 1];

  /* End of MATLAB Function: '<Root>/Median' */

  /* MATLAB Function: '<Root>/1st order Filter2' incorporates:
   *  Constant: '<S9>/Initial value'
   *  Constant: '<S9>/timeconst'
   *  SignalConversion: '<S1>/TmpSignal ConversionAt SFunction Inport2'
   */
  /* MATLAB Function '1st order Filter2': '<S1>:1' */
  /*  Input */
  /*  y: raw signal */
  /*  parameters */
  /* '<S1>:1:9' */
  /*  time const */
  /* '<S1>:1:10' */
  /*  sample time */
  /* '<S1>:1:11' */
  /*  initial conditions */
  /*  init */
  if (!MFB50Contr_Lib_DWork.y_z_not_empty_p) {
    /* '<S1>:1:14' */
    /* '<S1>:1:15' */
    MFB50Contr_Lib_DWork.y_z_l = inst->init_PT1[0];
    MFB50Contr_Lib_DWork.y_z_not_empty_p = TRUE;

    /* '<S1>:1:16' */
    MFB50Contr_Lib_DWork.y_f_z_i = inst->init_PT1[0];
  }

  /*  Output */
  /*  y_f: filtered signal - tustin approximation */
  /* '<S1>:1:21' */
  MFB50Contr_Lib_B.y_f_e = (((200.0 * inst->T1_PT1 - 1.0) *
    MFB50Contr_Lib_DWork.y_f_z_i + MFB50Contr_Lib_B.y_median) +
    MFB50Contr_Lib_DWork.y_z_l) * (1.0 / (200.0 * inst->T1_PT1 + 1.0));

  /* '<S1>:1:23' */
  MFB50Contr_Lib_DWork.y_z_l = MFB50Contr_Lib_B.y_median;

  /* '<S1>:1:24' */
  MFB50Contr_Lib_DWork.y_f_z_i = MFB50Contr_Lib_B.y_f_e;

  /* End of MATLAB Function: '<Root>/1st order Filter2' */

  /* SwitchCase: '<Root>/Switch Case1' */
  rtb_Switch1 = fmod(rtb_Switch1_e, 4.294967296E+9);
  switch (rtb_Switch1 < 0.0 ? -(int32_T)(uint32_T)-rtb_Switch1 : (int32_T)
          (uint32_T)rtb_Switch1) {
   case 2:
    /* Outputs for IfAction SubSystem: '<Root>/MFB50RefCalc' incorporates:
     *  ActionPort: '<S4>/Action Port'
     */
    /* Dynamic Look-Up Table Block: '<S4>/Lookup Table Dynamic1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(MFB50Contr_Lib_B.LookupTableDynamic1_m),
                         inst->MapMFB50oP2sy, MFB50Contr_Lib_B.p2sOut, inst->MapMFB50oP2sx,
                         1U, inst);

    /* S-Function (bur_out): '<S4>/Output1' */
    inst->MFB50RefGlobP2s = MFB50Contr_Lib_B.LookupTableDynamic1_m;

    /* MATLAB Function: '<S4>/T3HPcalc' incorporates:
     *  Constant: '<Root>/inst->T3HP_A (°C)'
     *  Constant: '<Root>/inst->T3HP_B (°C)'
     */
    /* MATLAB Function 'MFB50RefCalc/T3HPcalc': '<S15>:1' */
    /*  Output */
    if (((inst->T3HP_A < 0.0) || (inst->T3HP_A > 1000.0)) && ((inst->T3HP_B < 0.0) || (inst->T3HP_B >
          1000.0))) {
      /* '<S15>:1:5' */
      /* '<S15>:1:6' */
      MFB50Contr_Lib_B.T3HPout = 80.0;
    } else if ((inst->T3HP_A < 0.0) || (inst->T3HP_A > 1000.0)) {
      /* '<S15>:1:7' */
      /* '<S15>:1:8' */
      MFB50Contr_Lib_B.T3HPout = inst->T3HP_B;
    } else if ((inst->T3HP_B < 0.0) || (inst->T3HP_B > 1000.0)) {
      /* '<S15>:1:9' */
      /* '<S15>:1:10' */
      MFB50Contr_Lib_B.T3HPout = inst->T3HP_A;
    } else {
      /* '<S15>:1:12' */
      MFB50Contr_Lib_B.T3HPout = (inst->T3HP_A + inst->T3HP_B) / 2.0;
    }

    /* End of MATLAB Function: '<S4>/T3HPcalc' */

    /* S-Function (bur_out): '<S4>/Output2' */
    inst->T3HPout = MFB50Contr_Lib_B.T3HPout;

    /* Dynamic Look-Up Table Block: '<S4>/Lookup Table Dynamic'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(MFB50Contr_Lib_B.LookupTableDynamic), inst->MapMFB50oT3HPy,
                         MFB50Contr_Lib_B.T3HPout, inst->MapMFB50oT3HPx, 1U, inst);

    /* S-Function (bur_out): '<S4>/Output6' */
    inst->MFB50RefGlobT3HP = MFB50Contr_Lib_B.LookupTableDynamic;

    /* Switch: '<S4>/Switch1' incorporates:
     *  Constant: '<Root>/inputvariable4'
     *  Constant: '<S4>/Constant1'
     *  Sum: '<S4>/Add2'
     */
    if (inst->isFastStart) {
      rtb_Switch1 = MFB50Contr_Lib_B.LookupTableDynamic +
        MFB50Contr_Lib_B.LookupTableDynamic1_m;
    } else {
      rtb_Switch1 = 0.0;
    }

    /* End of Switch: '<S4>/Switch1' */

    /* MultiPortSwitch: '<S4>/Engine operation state, down .. 0, speed up .. 1, idle (start in load mode) .. 2, load mode .. 3, idle (stop mode) .. 4 island mode .. 5' incorporates:
     *  Constant: '<Root>/inputvariable5'
     *  Constant: '<S4>/IslandCntr'
     *  Constant: '<S4>/MFB50OffsOther'
     *  Constant: '<S4>/MFB50OffsetIsland'
     */
    switch (inst->EngOpState) {
     case 1:
     case 2:
     case 3:
      break;

     case 4:
      rtb_Switch1 = 0.0;
      break;

     case 5:
      rtb_Switch1 = 0.0;
      break;

     default:
      rtb_Switch1 = 0.0;
      break;
    }

    /* End of MultiPortSwitch: '<S4>/Engine operation state, down .. 0, speed up .. 1, idle (start in load mode) .. 2, load mode .. 3, idle (stop mode) .. 4 island mode .. 5' */

    /* Sum: '<S4>/Add1' incorporates:
     *  Constant: '<Root>/MFB50RefGlobExt (CADafTDC)'
     */
    MFB50Contr_Lib_B.Add1 = rtb_Switch1 + inst->MFB50GlobRefExt;

    /* End of Outputs for SubSystem: '<Root>/MFB50RefCalc' */
    break;

   case 1:
    /* Outputs for IfAction SubSystem: '<Root>/PI cntr gain scheduling' incorporates:
     *  ActionPort: '<S7>/Action Port'
     */
    /* MATLAB Function: '<S7>/P2sCalc' incorporates:
     *  Constant: '<Root>/inst->p2s_A (mbar)'
     *  Constant: '<Root>/inst->p2s_B (mbar)'
     */
    /* MATLAB Function 'PI cntr gain scheduling/P2sCalc': '<S16>:1' */
    /*  Inputs (mbar) */
    /*  Output (mbar) */
    if (((inst->p2s_A < 0.0) || (inst->p2s_A > 10000.0)) && ((inst->p2s_B < 0.0) || (inst->p2s_B >
          10000.0))) {
      /* '<S16>:1:6' */
      /* '<S16>:1:7' */
      MFB50Contr_Lib_B.p2sOut = 1000.0;
    } else if ((inst->p2s_A < 0.0) || (inst->p2s_A > 10000.0)) {
      /* '<S16>:1:8' */
      /* '<S16>:1:9' */
      MFB50Contr_Lib_B.p2sOut = inst->p2s_B;
    } else if ((inst->p2s_B < 0.0) || (inst->p2s_B > 10000.0)) {
      /* '<S16>:1:10' */
      /* '<S16>:1:11' */
      MFB50Contr_Lib_B.p2sOut = inst->p2s_A;
    } else {
      /* '<S16>:1:13' */
      MFB50Contr_Lib_B.p2sOut = (inst->p2s_A + inst->p2s_B) / 2.0;
    }

    /* End of MATLAB Function: '<S7>/P2sCalc' */

    /* S-Function (bur_out): '<S7>/Output1' */
    inst->p2sOut = MFB50Contr_Lib_B.p2sOut;

    /* Dynamic Look-Up Table Block: '<S7>/Lookup Table Dynamic1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(MFB50Contr_Lib_B.LookupTableDynamic1), inst->MapPoP2sy,
                         MFB50Contr_Lib_B.p2sOut, inst->MapPoP2sx, 1U, inst);

    /* S-Function (bur_out): '<S7>/Output4' */
    inst->P = MFB50Contr_Lib_B.LookupTableDynamic1;

    /* Dynamic Look-Up Table Block: '<S7>/Lookup Table Dynamic2'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(MFB50Contr_Lib_B.LookupTableDynamic2), inst->MapIoP2sy,
                         MFB50Contr_Lib_B.p2sOut, inst->MapIoP2sx, 1U, inst);

    /* S-Function (bur_out): '<S7>/Output5' */
    inst->I = MFB50Contr_Lib_B.LookupTableDynamic2;

    /* End of Outputs for SubSystem: '<Root>/PI cntr gain scheduling' */
    break;
  }

  /* End of SwitchCase: '<Root>/Switch Case1' */

  /* Relay: '<Root>/Relay' incorporates:
   *  Constant: '<Root>/Pel actual (%)'
   */
  if (inst->PelAct >= inst->MFB50EnPowTh) {
    MFB50Contr_Lib_DWork.Relay_Mode = TRUE;
  } else {
    if (inst->PelAct <= inst->MFB50EnPowTh - 5.0) {
      MFB50Contr_Lib_DWork.Relay_Mode = FALSE;
    }
  }

  /* RelationalOperator: '<S2>/Compare' incorporates:
   *  Constant: '<Root>/default 500 (rpm)'
   *  Constant: '<Root>/inst->engSpeed (rpm)'
   *  Constant: '<S2>/Constant'
   *  Sum: '<Root>/Add'
   */
  rtb_Compare = (inst->engSpeed - inst->MFB50EnSpdTh > 0.0);

  /* Switch: '<Root>/Switch2' incorporates:
   *  Constant: '<Root>/Load enabled (boolean)'
   *  Logic: '<Root>/Logical Operator'
   */
  if ((int32_T)inst->LoadEnabled > 0) {
    /* Relay: '<Root>/Relay' */
    if (MFB50Contr_Lib_DWork.Relay_Mode) {
      i_0 = 1;
    } else {
      i_0 = 0;
    }

    rtb_Compare = ((i_0 != 0) && rtb_Compare);
  }

  /* End of Switch: '<Root>/Switch2' */

  /* Switch: '<Root>/Switch' incorporates:
   *  Constant: '<Root>/manual reset'
   *  Constant: '<Root>/reset all cylinders below speed treshold'
   */
  for (i_0 = 0; i_0 < 21; i_0++) {
    if (rtb_Compare) {
      rtb_Switch_k[i_0] = inst->resetAllCyl[i_0];
    } else {
      rtb_Switch_k[i_0] = TRUE;
    }
  }

  /* End of Switch: '<Root>/Switch' */

  /* SwitchCase: '<Root>/Switch Case' */
  rtb_Switch1 = fmod(rtb_Switch1_e, 4.294967296E+9);
  switch (rtb_Switch1 < 0.0 ? -(int32_T)(uint32_T)-rtb_Switch1 : (int32_T)
          (uint32_T)rtb_Switch1) {
   case 1:
   case 2:
   case 3:
   case 4:
   case 5:
   case 6:
   case 7:
   case 8:
   case 9:
   case 10:
    /* Outputs for IfAction SubSystem: '<Root>/MFB50Controller' incorporates:
     *  ActionPort: '<S3>/Action Port'
     */
    /* Outputs for Iterator SubSystem: '<S3>/MFB50ContrAllCyl' incorporates:
     *  ForIterator: '<S10>/For Iterator'
     */
    for (s10_iter = 0; s10_iter < 2; s10_iter++) {
      /* DataTypeConversion: '<S10>/Data Type Conversion' incorporates:
       *  Constant: '<S10>/Constant1'
       *  Product: '<S10>/Divide'
       *  Sum: '<S10>/Add1'
       */
      rtb_Switch1 = fmod(rt_roundd((real_T)s10_iter * 10.0 + (real_T)
        MFB50Contr_Lib_B.DataTypeConversion, inst), 4.294967296E+9);
      MFB50Contr_Lib_B.DataTypeConversion_o = rtb_Switch1 < 0.0 ? -(int32_T)
        (uint32_T)-rtb_Switch1 : (int32_T)(uint32_T)rtb_Switch1;

      /* Logic: '<S10>/Logical Operator' incorporates:
       *  Constant: '<Root>/inputvariable1'
       *  Constant: '<Root>/inputvariable23'
       *  Constant: '<Root>/inputvariable3'
       *  Constant: '<Root>/inputvariable7'
       *  Selector: '<S10>/Selector2'
       *  Selector: '<S10>/Selector3'
       *  Selector: '<S10>/Selector5'
       *  Selector: '<S10>/Selector7'
       */
      MFB50Contr_Lib_B.LogicalOperator =
        (inst->freezeAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o] ||
         inst->isSkipAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o] ||
         inst->isSensFailAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o] ||
         inst->isITRetLimpHomeAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o]);

      /* S-Function (bur_out): '<S10>/Output1' */
      inst->freezeCyl = MFB50Contr_Lib_B.LogicalOperator;

      /* S-Function (bur_out): '<S10>/Output3' */
      inst->cyl = MFB50Contr_Lib_B.DataTypeConversion_o;

      /* Saturate: '<S10>/Saturation' incorporates:
       *  Constant: '<Root>/inputvariable8'
       *  Selector: '<S10>/Selector'
       */
      if (inst->MFB50ActAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o] >= 50.0) {
        rtb_Switch1_e = 50.0;
      } else if (inst->MFB50ActAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o] <= -50.0)
      {
        rtb_Switch1_e = -50.0;
      } else {
        rtb_Switch1_e = inst->MFB50ActAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o];
      }

      /* End of Saturate: '<S10>/Saturation' */

      /* MATLAB Function: '<S10>/1st order Filter' incorporates:
       *  Constant: '<S10>/inst->T1_PT1'
       *  Constant: '<S10>/Ts'
       *  Constant: '<S10>/inst->init_PT1'
       */
      /* MATLAB Function 'MFB50Controller/MFB50ContrAllCyl/1st order Filter': '<S11>:1' */
      /*  Input */
      /*  y: raw signal */
      /*  parameters */
      /*  T1: time const */
      /*  Ts: sample time */
      /*  init: initial conditions */
      /*  init */
      if (!MFB50Contr_Lib_DWork.y_z_not_empty) {
        /* '<S11>:1:15' */
        /* '<S11>:1:16' */
        MFB50Contr_Lib_DWork.y_z_not_empty = TRUE;

        /* '<S11>:1:17' */
        for (i_0 = 0; i_0 < 21; i_0++) {
          MFB50Contr_Lib_DWork.y_z[i_0] = inst->init_PT1[i_0];
          MFB50Contr_Lib_DWork.y_f_z[i_0] = inst->init_PT1[i_0];
        }
      }

      if (!MFB50Contr_Lib_DWork.y_f_int_not_empty) {
        /* '<S11>:1:19' */
        /* '<S11>:1:20' */
        for (i_0 = 0; i_0 < 21; i_0++) {
          MFB50Contr_Lib_DWork.y_f_int[i_0] = inst->init_PT1[i_0];
        }

        MFB50Contr_Lib_DWork.y_f_int_not_empty = TRUE;
      }

      /*  Output */
      /*  y_f: filtered signal - tustin approximation */
      /* '<S11>:1:25' */
      i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
        i_0 = MAX_int32_T;
      }

      i = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i <= 0)) {
        i = MAX_int32_T;
      }

      j = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (j <= 0)) {
        j = MAX_int32_T;
      }

      MFB50Contr_Lib_DWork.y_f_int[i_0 - 1] = (((16.666666666666668 * inst->T1_PT1 -
        1.0) * MFB50Contr_Lib_DWork.y_f_z[i - 1] + rtb_Switch1_e) +
        MFB50Contr_Lib_DWork.y_z[j - 1]) * (1.0 / (16.666666666666668 * inst->T1_PT1 +
        1.0));

      /* '<S11>:1:27' */
      i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
        i_0 = MAX_int32_T;
      }

      MFB50Contr_Lib_DWork.y_z[i_0 - 1] = rtb_Switch1_e;

      /* '<S11>:1:28' */
      i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
        i_0 = MAX_int32_T;
      }

      i = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i <= 0)) {
        i = MAX_int32_T;
      }

      MFB50Contr_Lib_DWork.y_f_z[i_0 - 1] = MFB50Contr_Lib_DWork.y_f_int[i - 1];

      /* '<S11>:1:29' */
      for (i_0 = 0; i_0 < 21; i_0++) {
        MFB50Contr_Lib_B.y_f[i_0] = MFB50Contr_Lib_DWork.y_f_int[i_0];
      }

      /* End of MATLAB Function: '<S10>/1st order Filter' */

      /* Switch: '<S10>/Switch' incorporates:
       *  Constant: '<Root>/inst->MFB50MedianEn'
       */
      if (inst->MFB50MedianEn) {
        rtb_Switch1 = MFB50Contr_Lib_B.y_f_e;
      } else {
        rtb_Switch1 = MFB50Contr_Lib_B.Add1;
      }

      /* End of Switch: '<S10>/Switch' */

      /* Gain: '<S12>/Gain' incorporates:
       *  Constant: '<Root>/inputvariable20'
       *  Selector: '<S10>/Selector4'
       *  Selector: '<S10>/Selector8'
       *  Sum: '<S10>/Sum'
       *  Sum: '<S12>/Sum'
       */
      rtb_Switch1_e = -((rtb_Switch1 +
                         inst->MFB50RefOffsetAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o])
                        - MFB50Contr_Lib_B.y_f[MFB50Contr_Lib_B.DataTypeConversion_o]);

      /* MATLAB Function: '<S12>/PICntr' incorporates:
       *  Constant: '<Root>/inputvariable'
       *  Constant: '<Root>/inputvariable2'
       *  Constant: '<S12>/Constant10'
       *  Constant: '<S12>/Constant6'
       *  Constant: '<S12>/Constant7'
       *  Constant: '<S12>/Constant9'
       *  Constant: '<S12>/Ts1'
       *  Selector: '<S10>/Selector1'
       *  Selector: '<S10>/Selector6'
       */
      /* MATLAB Function 'MFB50Controller/MFB50ContrAllCyl/PI controller/PICntr': '<S13>:1' */
      /*  init */
      if (!MFB50Contr_Lib_DWork.iState_not_empty) {
        /* '<S13>:1:8' */
        /* '<S13>:1:9' */
        for (i_0 = 0; i_0 < 21; i_0++) {
          MFB50Contr_Lib_DWork.iState[i_0] = inst->I0AllCyl[i_0];
        }

        MFB50Contr_Lib_DWork.iState_not_empty = TRUE;
      }

      if (!MFB50Contr_Lib_DWork.uState_not_empty) {
        /* '<S13>:1:14' */
        /* '<S13>:1:15' */
        for (i_0 = 0; i_0 < 21; i_0++) {
          MFB50Contr_Lib_DWork.uState[i_0] = inst->I0AllCyl[i_0];
        }

        MFB50Contr_Lib_DWork.uState_not_empty = TRUE;
      }

      /* '<S13>:1:18' */
      /* '<S13>:1:19' */
      /* '<S13>:1:20' */
      for (i_0 = 0; i_0 < 21; i_0++) {
        MFB50Contr_Lib_B.out[i_0] = MFB50Contr_Lib_DWork.uState[i_0];
        MFB50Contr_Lib_B.ui[i_0] = MFB50Contr_Lib_DWork.iState[i_0];
        MFB50Contr_Lib_B.up[i_0] = MFB50Contr_Lib_DWork.pState[i_0];
      }

      if ((rtb_Switch1_e <= 0.0) &&
          inst->isKnockITRetAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o] &&
          (!MFB50Contr_Lib_B.LogicalOperator)) {
        /* '<S13>:1:22' */
        /* '<S13>:1:23' */
        rtb_Compare = FALSE;
      } else if ((rtb_Switch1_e > 0.0) &&
                 inst->isKnockITRetAllCyl[MFB50Contr_Lib_B.DataTypeConversion_o]) {
        /* '<S13>:1:24' */
        /* '<S13>:1:25' */
        rtb_Compare = TRUE;
      } else {
        /* '<S13>:1:27' */
        rtb_Compare = MFB50Contr_Lib_B.LogicalOperator;
      }

      if ((rtb_Switch1_e >= inst->deadbandNeg) && (rtb_Switch1_e <= inst->deadbandPos)) {
        /* '<S13>:1:31' */
        /* '<S13>:1:32' */
        rtb_Switch1_e = 0.0;
      } else {
        /* '<S13>:1:34' */
      }

      /* '<S13>:1:37' */
      i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
        i_0 = MAX_int32_T;
      }

      MFB50Contr_Lib_DWork.pState[i_0 - 1] =
        MFB50Contr_Lib_B.LookupTableDynamic1 * rtb_Switch1_e;

      /* '<S13>:1:38' */
      i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
        i_0 = MAX_int32_T;
      }

      i = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i <= 0)) {
        i = MAX_int32_T;
      }

      rtb_Switch1 = (0.12 * MFB50Contr_Lib_B.LookupTableDynamic2 * rtb_Switch1_e
                     + MFB50Contr_Lib_DWork.iState[i_0 - 1]) +
        MFB50Contr_Lib_DWork.pState[i - 1];
      if (rtb_Switch_k[MFB50Contr_Lib_B.DataTypeConversion_o]) {
        /* '<S13>:1:40' */
        /* '<S13>:1:41' */
        i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
        if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
          i_0 = MAX_int32_T;
        }

        i = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
        if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i <= 0)) {
          i = MAX_int32_T;
        }

        MFB50Contr_Lib_DWork.iState[i_0 - 1] = inst->I0AllCyl[i - 1];

        /* '<S13>:1:42' */
        i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
        if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
          i_0 = MAX_int32_T;
        }

        i = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
        if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i <= 0)) {
          i = MAX_int32_T;
        }

        MFB50Contr_Lib_DWork.uState[i_0 - 1] = inst->I0AllCyl[i - 1];

        /* '<S13>:1:43' */
        i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
        if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
          i_0 = MAX_int32_T;
        }

        MFB50Contr_Lib_DWork.pState[i_0 - 1] = 0.0;
      } else {
        if ((!rtb_Compare) && (rtb_Switch1 > inst->uMin) && (rtb_Switch1 < inst->uMax)) {
          /* '<S13>:1:44' */
          /*  || ((u <= inst->uMin) && (ki * eDead > 0)) || ((u >= inst->uMax) && (ki * eDead < 0))) */
          /* '<S13>:1:45' */
          i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
          if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
            i_0 = MAX_int32_T;
          }

          i = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
          if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i <= 0)) {
            i = MAX_int32_T;
          }

          MFB50Contr_Lib_DWork.iState[i_0 - 1] = 0.12 *
            MFB50Contr_Lib_B.LookupTableDynamic2 * rtb_Switch1_e +
            MFB50Contr_Lib_DWork.iState[i - 1];
        }
      }

      /* '<S13>:1:48' */
      i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
        i_0 = MAX_int32_T;
      }

      i = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
      if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i <= 0)) {
        i = MAX_int32_T;
      }

      rtb_Switch1 = MFB50Contr_Lib_DWork.iState[i_0 - 1] +
        MFB50Contr_Lib_DWork.pState[i - 1];
      if (rtb_Switch1 > inst->uMax) {
        /* '<S13>:1:50' */
        /* '<S13>:1:51' */
        rtb_Switch1 = inst->uMax;
      } else {
        if (rtb_Switch1 < inst->uMin) {
          /* '<S13>:1:52' */
          /* '<S13>:1:53' */
          rtb_Switch1 = inst->uMin;
        }
      }

      if (!rtb_Compare) {
        /* '<S13>:1:56' */
        /* '<S13>:1:57' */
        i_0 = MFB50Contr_Lib_B.DataTypeConversion_o + 1;
        if ((MFB50Contr_Lib_B.DataTypeConversion_o > 0) && (i_0 <= 0)) {
          i_0 = MAX_int32_T;
        }

        MFB50Contr_Lib_DWork.uState[i_0 - 1] = rtb_Switch1;
      }

      /* End of MATLAB Function: '<S12>/PICntr' */
    }

    /* End of Outputs for SubSystem: '<S3>/MFB50ContrAllCyl' */
    /* End of Outputs for SubSystem: '<Root>/MFB50Controller' */
    break;
  }

  /* End of SwitchCase: '<Root>/Switch Case' */

  /* S-Function (bur_out): '<Root>/Output' */
  {
    int_T i1;
    const real_T *u0 = MFB50Contr_Lib_B.out;
    for (i1=0; i1 < 21; i1++) {
      inst->ITOffsetAllCyl_u[i1] = u0[i1];
    }
  }

  /* S-Function (bur_out): '<Root>/Output1' */
  {
    int_T i1;
    const real_T *u0 = MFB50Contr_Lib_B.up;
    for (i1=0; i1 < 21; i1++) {
      inst->ITOffsetAllCyl_up[i1] = u0[i1];
    }
  }

  /* S-Function (bur_out): '<Root>/Output2' */
  {
    int_T i1;
    const real_T *u0 = MFB50Contr_Lib_B.ui;
    for (i1=0; i1 < 21; i1++) {
      inst->ITOffsetAllCyl_ui[i1] = u0[i1];
    }
  }

  /* S-Function (bur_out): '<Root>/Output3' */
  inst->clock = MFB50Contr_Lib_B.DataTypeConversion;

  /* S-Function (bur_out): '<Root>/Output6' */
  inst->MFB50RefGlob = MFB50Contr_Lib_B.Add1;

  /* S-Function (bur_out): '<Root>/Output7' */
  {
    int_T i1;
    const real_T *u0 = MFB50Contr_Lib_B.y_f;
    for (i1=0; i1 < 21; i1++) {
      inst->MFB50ActFiltAllCyl[i1] = u0[i1];
    }
  }

  /* S-Function (bur_out): '<Root>/Output8' */
  inst->MFB50MedianFilt = MFB50Contr_Lib_B.y_f_e;

  /* S-Function (bur_out): '<Root>/Output9' */
  inst->MFB50Median = MFB50Contr_Lib_B.y_median;

  /* S-Function (bur_out): '<S8>/Output3' */
  inst->Tcycle = MFB50Contr_Lib_B.Divide;

  /* Update for UnitDelay: '<S8>/Unit Delay' */
  MFB50Contr_Lib_DWork.UnitDelay_DSTATE = rtb_Switch2;
}

/* Model initialize function */
void MFB50Contr_Lib_initialize(struct MFB50Contr* inst)
{
  /* S-Function (bur_out): '<Root>/Output4' */
  inst->ACversion = 1.1;
}

/* Model terminate function */
void MFB50Contr_Lib_terminate(struct MFB50Contr* inst)
{
  /* (no terminate code required) */
}

/*======================== TOOL VERSION INFORMATION ==========================*
 * MATLAB 8.0 (R2012b)20-Jul-2012                                             *
 * Simulink 8.0 (R2012b)20-Jul-2012                                           *
 * Simulink Coder 8.3 (R2012b)20-Jul-2012                                     *
 * Embedded Coder 6.3 (R2012b)20-Jul-2012                                     *
 * Stateflow 8.0 (R2012b)20-Jul-2012                                          *
 * Simulink Fixed Point 7.2 (R2012b)20-Jul-2012                               *
 *============================================================================*/

/*======================= LICENSE IN USE INFORMATION =========================*
 * matlab                                                                     *
 * matlab_coder                                                               *
 * real-time_workshop                                                         *
 * rtw_embedded_coder                                                         *
 * simulink                                                                   *
 *============================================================================*/
