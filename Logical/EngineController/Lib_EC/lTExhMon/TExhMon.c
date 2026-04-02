/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: TExhMon
 * File: TExhMon.c
 * Author: 120011115
 * Created: Mon Sep 05 16:14:57 2016
 ********************************************************************
 * Implementation of program TExhMon
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/
#include "TExhMon.h"
#include "TExhMon_private.h"

/*  Defines */
#define TExhMon_POS_ZCSIG              ((uint8_T)1U)
#define TExhMon_ZERO_ZCSIG             ((uint8_T)0U)

/*  Data Types */

/**************************** GLOBAL DATA *************************************/
/*  Definitions */

/*  Declarations  */

/* Forward declaration for local functions */
static void TExhMon_eml_li_find(const boolean_T x[25], int32_T y_data[25],
  int32_T *y_sizes, struct fTExhMon* inst);
static void TExhMon_eml_li_find_b(const boolean_T x[25], int32_T y_data[25],
  int32_T *y_sizes, struct fTExhMon* inst);

/***************************** FILE SCOPE DATA ********************************/

/*************************** FUNCTIONS ****************************************/

/*
 * Output and update for atomic system:
 *    '<S1>/TON_TExhMon_Act_GCB_ON'
 *    '<S1>/xTON_bdTExhMon_Act_P'
 */
void TExhMon_TON_TExhMon_Act_GCB_ON(boolean_T rtu_IN, real32_T rtu_PT,
  rtB_TON_TExhMon_Act_GCB_ON_TExh *localB, rtDW_TON_TExhMon_Act_GCB_ON_TEx
  *localDW, struct fTExhMon* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2_p;
  boolean_T rtb_RelationalOperator_p;

  /* Logic: '<S10>/Logical Operator2' */
  rtb_LogicalOperator2_p = !rtu_IN;

  /* DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
  if (rtb_LogicalOperator2_p || (localDW->DiscreteTimeIntegrator_PrevRese != 0))
  {
    localDW->DiscreteTimeIntegrator_DSTATE = 0.0F;
  }

  /* RelationalOperator: '<S10>/Relational Operator' incorporates:
   *  DiscreteIntegrator: '<S10>/Discrete-Time Integrator'
   */
  rtb_RelationalOperator_p = (localDW->DiscreteTimeIntegrator_DSTATE >= rtu_PT);

  /* Logic: '<S10>/Logical Operator3' */
  localB->LogicalOperator3 = (rtb_RelationalOperator_p && rtu_IN);

  /* Update for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' incorporates:
   *  DataTypeConversion: '<S12>/Conversion'
   *  Logic: '<S10>/Logical Operator'
   *  Logic: '<S10>/Logical Operator1'
   */
  if (!rtb_LogicalOperator2_p) {
    localDW->DiscreteTimeIntegrator_DSTATE += (real32_T)
      ((!rtb_RelationalOperator_p) && rtu_IN);
  }

  if (rtb_LogicalOperator2_p) {
    localDW->DiscreteTimeIntegrator_PrevRese = 1;
  } else {
    localDW->DiscreteTimeIntegrator_PrevRese = 0;
  }

  /* End of Update for DiscreteIntegrator: '<S10>/Discrete-Time Integrator' */
}

/*
 * Output and update for atomic system:
 *    '<S5>/TON_InBound'
 *    '<S5>/TON_OutBound'
 */
void TExhMon_TON_InBound(const boolean_T rtu_IN[25], real32_T rtu_PT,
  rtB_TON_InBound_TExhMon *localB, rtDW_TON_InBound_TExhMon *localDW, struct fTExhMon* inst)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2_o[25];
  int32_T i;
  boolean_T rtb_RelationalOperator_g_0;
  for (i = 0; i < 25; i++) {
    /* Logic: '<S18>/Logical Operator2' */
    rtb_LogicalOperator2_o[i] = !rtu_IN[i];

    /* DiscreteIntegrator: '<S18>/Discrete-Time Integrator' */
    if (rtb_LogicalOperator2_o[i] || (localDW->DiscreteTimeIntegrator_PrevRese[i]
         != 0)) {
      localDW->DiscreteTimeIntegrator_DSTATE[i] = 0.0F;
    }

    /* RelationalOperator: '<S18>/Relational Operator' incorporates:
     *  DiscreteIntegrator: '<S18>/Discrete-Time Integrator'
     */
    rtb_RelationalOperator_g_0 = (localDW->DiscreteTimeIntegrator_DSTATE[i] >=
      rtu_PT);

    /* Logic: '<S18>/Logical Operator3' */
    localB->LogicalOperator3[i] = (rtb_RelationalOperator_g_0 && rtu_IN[i]);

    /* Update for DiscreteIntegrator: '<S18>/Discrete-Time Integrator' incorporates:
     *  DataTypeConversion: '<S23>/Conversion'
     *  Logic: '<S18>/Logical Operator'
     *  Logic: '<S18>/Logical Operator1'
     */
    if (!rtb_LogicalOperator2_o[i]) {
      localDW->DiscreteTimeIntegrator_DSTATE[i] += (real32_T)
        ((!rtb_RelationalOperator_g_0) && rtu_IN[i]);
    }

    if (rtb_LogicalOperator2_o[i]) {
      localDW->DiscreteTimeIntegrator_PrevRese[i] = 1;
    } else {
      localDW->DiscreteTimeIntegrator_PrevRese[i] = 0;
    }

    /* End of Update for DiscreteIntegrator: '<S18>/Discrete-Time Integrator' */
  }
}

/* Function for MATLAB Function: '<S16>/MATLAB Function1' */
static void TExhMon_eml_li_find(const boolean_T x[25], int32_T y_data[25],
  int32_T *y_sizes, struct fTExhMon* inst)
{
  int32_T k;
  int32_T b_i;
  k = 0;
  for (b_i = 0; b_i < 25; b_i++) {
    if (x[b_i]) {
      k++;
    }
  }

  *y_sizes = k;
  k = 0;
  for (b_i = 0; b_i < 25; b_i++) {
    if (x[b_i]) {
      y_data[k] = b_i + 1;
      k++;
    }
  }
}

/* Function for MATLAB Function: '<S7>/MATLAB Function' */
static void TExhMon_eml_li_find_b(const boolean_T x[25], int32_T y_data[25],
  int32_T *y_sizes, struct fTExhMon* inst)
{
  int32_T k;
  int32_T b_i;
  k = 0;
  for (b_i = 0; b_i < 25; b_i++) {
    if (x[b_i]) {
      k++;
    }
  }

  *y_sizes = k;
  k = 0;
  for (b_i = 0; b_i < 25; b_i++) {
    if (x[b_i]) {
      y_data[k] = b_i + 1;
      k++;
    }
  }
}

/* Model step function */
void TExhMon_step(struct BlockIO_TExhMon *TExhMon_B, struct D_Work_TExhMon *TExhMon_DWork,
                  struct PrevZCSigStates_TExhMon *TExhMon_PrevZCSigState,
                  ExternalOutputs_TExhMon *TExhMon_Y, struct fTExhMon* inst)
{
  /* local block i/o variables */
  real32_T rtb_Divide5;
  real32_T rtb_Divide3;
  real32_T rtb_tDelay_dTExhMon_Act_Lim;
  real32_T rtb_tDelay_dTExhMon_Act_P_Lim;
  boolean_T rtb_RelationalOperator[25];
  boolean_T rtb_LogicalOperator3[25];
  boolean_T rtb_tGCB_On_Di_i;
  boolean_T rtb_Logic_e[2];
  boolean_T rtb_y_ct[25];
  int32_T c;
  int32_T midm;
  int32_T k;
  int32_T j;
  int32_T pEnd;
  int32_T p;
  int32_T q;
  int32_T qEnd;
  int32_T kEnd;
  int32_T b_j;
  real32_T rtb_tDelay_dTExhMon_Act;
  real32_T rtb_tDelay_dTExhMon_Act_P;
  real32_T rtb_rTExhBound_SensScal;
  real32_T rtb_rdT_Ref_Max_Lim;
  real32_T rtb_Divide6;
  real32_T rtb_Abs[25];
  real32_T rtb_rTExhBound_SensScal_Lim;
  boolean_T rtb_LogicalOperator1_g[25];
  boolean_T rtb_y_c[25];
  real32_T rtb_Divide[25];
  real32_T rtb_Divide2[25];
  boolean_T rtb_Memory;
  boolean_T rtb_RelationalOperator3;
  boolean_T rtb_LogicalOperator_g;
  real32_T rtb_Product1[25];
  real32_T rtb_Product3[25];
  real32_T rtb_Product5[25];
  real32_T rtb_rdT2Ref[25];
  real32_T rtb_Switch9[25];
  real32_T rtb_rFiltTau_TExh_Lim;
  real32_T rtb_rdT2Exp_Max_Lim;
  real32_T rtb_y;
  boolean_T rtb_FixPtRelationalOperator[25];
  real32_T rtb_Switch2[25];
  uint32_T tmp;
  boolean_T rtb_Switch_b[25];
  int32_T i;
  boolean_T rtb_FixPtRelationalOperator_0[25];
  int16_T e_data[25];
  int32_T idx_data[25];
  int32_T idx_sizes;
  int32_T idx0_data[25];
  int8_T y_data[25];
  int32_T tmp_data[25];
  int32_T tmp_data_0[25];
  int32_T tmp_data_1[25];
  int16_T b_j_data[25];
  boolean_T rtb_FixPtRelationalOperator_1;
  boolean_T rtb_Logic_idx;
  int32_T i_0;

  /* S-Function (bur_bus_in): '<Root>/Bus Input1' */
  TExhMon_B->BusInput1 = inst->Para;

  /* BusSelector: '<S6>/Bus Selector10' */
  rtb_tDelay_dTExhMon_Act = TExhMon_B->BusInput1.tDelay_dTExhMon_Act;
  rtb_tDelay_dTExhMon_Act_P = TExhMon_B->BusInput1.tDelay_dTExhMon_Act_P;
  rtb_rTExhBound_SensScal = TExhMon_B->BusInput1.rTExhBound_SensScal;

  /* Switch: '<S6>/Switch5' incorporates:
   *  BusSelector: '<S6>/Bus Selector10'
   *  Constant: '<S6>/Constant5'
   */
  if (TExhMon_B->BusInput1.rFiltTau_Texh != 0.0F) {
    /* Saturate: '<S6>/Saturation5' */
    if (TExhMon_B->BusInput1.rFiltTau_Texh >= 100.0F) {
      rtb_rFiltTau_TExh_Lim = 100.0F;
    } else if (TExhMon_B->BusInput1.rFiltTau_Texh <= 0.1F) {
      rtb_rFiltTau_TExh_Lim = 0.1F;
    } else {
      rtb_rFiltTau_TExh_Lim = TExhMon_B->BusInput1.rFiltTau_Texh;
    }

    /* End of Saturate: '<S6>/Saturation5' */
  } else {
    rtb_rFiltTau_TExh_Lim = 50.0F;
  }

  /* End of Switch: '<S6>/Switch5' */

  /* Switch: '<S6>/Switch6' incorporates:
   *  BusSelector: '<S6>/Bus Selector10'
   *  Constant: '<S6>/Constant6'
   */
  if (TExhMon_B->BusInput1.rdT2Exp_Max != 0.0F) {
    /* Saturate: '<S6>/Saturation6' */
    if (TExhMon_B->BusInput1.rdT2Exp_Max >= 200.0F) {
      rtb_rdT2Exp_Max_Lim = 200.0F;
    } else if (TExhMon_B->BusInput1.rdT2Exp_Max <= 0.0F) {
      rtb_rdT2Exp_Max_Lim = 0.0F;
    } else {
      rtb_rdT2Exp_Max_Lim = TExhMon_B->BusInput1.rdT2Exp_Max;
    }

    /* End of Saturate: '<S6>/Saturation6' */
  } else {
    rtb_rdT2Exp_Max_Lim = 30.0F;
  }

  /* End of Switch: '<S6>/Switch6' */

  /* Switch: '<S6>/Switch2' incorporates:
   *  BusSelector: '<S6>/Bus Selector10'
   *  Constant: '<S6>/Constant2'
   */
  if (TExhMon_B->BusInput1.rdT_Ref_Max != 0.0F) {
    /* Saturate: '<S6>/Saturation2' */
    if (TExhMon_B->BusInput1.rdT_Ref_Max >= 200.0F) {
      rtb_rdT_Ref_Max_Lim = 200.0F;
    } else if (TExhMon_B->BusInput1.rdT_Ref_Max <= 0.0F) {
      rtb_rdT_Ref_Max_Lim = 0.0F;
    } else {
      rtb_rdT_Ref_Max_Lim = TExhMon_B->BusInput1.rdT_Ref_Max;
    }

    /* End of Saturate: '<S6>/Saturation2' */
  } else {
    rtb_rdT_Ref_Max_Lim = 10.0F;
  }

  /* End of Switch: '<S6>/Switch2' */

  /* Product: '<S5>/Divide6' incorporates:
   *  Constant: '<S5>/Constant3'
   */
  rtb_Divide6 = 0.6F * rtb_rdT_Ref_Max_Lim;

  /* S-Function (bur_bus_in): '<Root>/Bus Input' */
  TExhMon_B->BusInput = inst->In;

  /* MATLAB Function: '<S5>/MATLAB Function' */
  /* MATLAB Function 'Init_Calculations/MATLAB Function': '<S17>:1' */
  /* '<S17>:1:3' */
  for (i = 0; i < 25; i++) {
    rtb_y_c[i] = FALSE;
  }

  i_0 = (int32_T)((uint32_T)TExhMon_B->BusInput.ucNumCyl + 1U);
  if ((uint32_T)i_0 > 255U) {
    i_0 = 255;
  }

  if (2 > (uint8_T)i_0) {
    b_j = 1;
    c = 0;
  } else {
    b_j = 2;
    c = (uint8_T)i_0;
  }

  i = c - b_j;
  for (i_0 = 0; i_0 <= i; i_0++) {
    b_j_data[i_0] = (int16_T)(b_j + i_0);
  }

  i = (c - b_j) + 1;
  for (i_0 = 0; i_0 < i; i_0++) {
    for (idx_sizes = 0; idx_sizes < 1; idx_sizes++) {
      e_data[i_0] = b_j_data[i_0];
    }
  }

  /* '<S17>:1:4' */
  for (i_0 = 0; i_0 < i; i_0++) {
    rtb_y_c[e_data[i_0] - 1] = TRUE;
  }

  /* End of MATLAB Function: '<S5>/MATLAB Function' */

  /* MATLAB Function: '<S5>/  1' */
  /* output */
  /* '<S17>:1:7' */
  /* MATLAB Function 'Init_Calculations/  1': '<S15>:1' */
  i_0 = (int32_T)((uint32_T)TExhMon_B->BusInput.ucNumCyl + 1U);
  if ((uint32_T)i_0 > 255U) {
    i_0 = 255;
  }

  if (2 > (uint8_T)i_0) {
    b_j = 0;
    c = 1;
  } else {
    b_j = 1;
    c = (uint8_T)i_0 + 1;
  }

  /* '<S15>:1:3' */
  if ((c - b_j) - 1 == 0) {
    rtb_y = 0.0F;
  } else {
    midm = ((c - b_j) - 1) / 2;
    idx_sizes = (int8_T)((c - b_j) - 1);
    for (i_0 = 1; i_0 < c - b_j; i_0++) {
      idx_data[i_0 - 1] = i_0;
    }

    for (i_0 = 1; i_0 <= (c - b_j) - 2; i_0 += 2) {
      if (!(TExhMon_B->BusInput.rT_EPU_EG[(b_j + i_0) - 1] <=
            TExhMon_B->BusInput.rT_EPU_EG[b_j + i_0])) {
        idx_data[i_0 - 1] = i_0 + 1;
        idx_data[i_0] = i_0;
      }
    }

    i = (c - b_j) - 1;
    for (i_0 = 0; i_0 < i; i_0++) {
      idx0_data[i_0] = 1;
    }

    i = 2;
    while (i < (c - b_j) - 1) {
      idx_sizes = i << 1;
      j = 1;
      for (pEnd = 1 + i; pEnd < c - b_j; pEnd = qEnd + i) {
        p = j;
        q = pEnd;
        qEnd = j + idx_sizes;
        if (qEnd > c - b_j) {
          qEnd = c - b_j;
        }

        k = 0;
        kEnd = qEnd - j;
        while (k + 1 <= kEnd) {
          if (TExhMon_B->BusInput.rT_EPU_EG[(idx_data[p - 1] + b_j) - 1] <=
              TExhMon_B->BusInput.rT_EPU_EG[(idx_data[q - 1] + b_j) - 1]) {
            idx0_data[k] = idx_data[p - 1];
            p++;
            if (p == pEnd) {
              while (q < qEnd) {
                k++;
                idx0_data[k] = idx_data[q - 1];
                q++;
              }
            }
          } else {
            idx0_data[k] = idx_data[q - 1];
            q++;
            if (q == qEnd) {
              while (p < pEnd) {
                k++;
                idx0_data[k] = idx_data[p - 1];
                p++;
              }
            }
          }

          k++;
        }

        for (i_0 = 0; i_0 + 1 <= kEnd; i_0++) {
          idx_data[(j + i_0) - 1] = idx0_data[i_0];
        }

        j = qEnd;
      }

      i = idx_sizes;
    }

    if ((c - b_j) - 1 == midm << 1) {
      if ((TExhMon_B->BusInput.rT_EPU_EG[(idx_data[midm - 1] + b_j) - 1] < 0.0F)
          != (TExhMon_B->BusInput.rT_EPU_EG[(b_j + idx_data[midm]) - 1] < 0.0F))
      {
        rtb_y = (TExhMon_B->BusInput.rT_EPU_EG[(idx_data[midm - 1] + b_j) - 1] +
                 TExhMon_B->BusInput.rT_EPU_EG[(b_j + idx_data[midm]) - 1]) /
          2.0F;
      } else {
        rtb_y = (TExhMon_B->BusInput.rT_EPU_EG[(b_j + idx_data[midm]) - 1] -
                 TExhMon_B->BusInput.rT_EPU_EG[(idx_data[midm - 1] + b_j) - 1]) /
          2.0F + TExhMon_B->BusInput.rT_EPU_EG[(idx_data[midm - 1] + b_j) - 1];
      }
    } else {
      rtb_y = TExhMon_B->BusInput.rT_EPU_EG[(b_j + idx_data[midm]) - 1];
    }
  }

  /* End of MATLAB Function: '<S5>/  1' */

  /* Abs: '<S5>/Abs' incorporates:
   *  Sum: '<S5>/Subtract'
   */
  for (i = 0; i < 25; i++) {
    rtb_Abs[i] = (real32_T)fabs(TExhMon_B->BusInput.rT_EPU_EG[i] - rtb_y);
  }

  /* End of Abs: '<S5>/Abs' */

  /* Switch: '<S6>/Switch8' incorporates:
   *  Constant: '<S6>/Constant8'
   */
  if (rtb_rTExhBound_SensScal != 0.0F) {
    /* Saturate: '<S6>/Saturation8' */
    if (rtb_rTExhBound_SensScal >= 10.0F) {
      rtb_rTExhBound_SensScal_Lim = 10.0F;
    } else if (rtb_rTExhBound_SensScal <= 0.1F) {
      rtb_rTExhBound_SensScal_Lim = 0.1F;
    } else {
      rtb_rTExhBound_SensScal_Lim = rtb_rTExhBound_SensScal;
    }

    /* End of Saturate: '<S6>/Saturation8' */
  } else {
    rtb_rTExhBound_SensScal_Lim = 1.0F;
  }

  /* End of Switch: '<S6>/Switch8' */

  /* Product: '<S5>/Divide4' incorporates:
   *  Constant: '<S5>/Constant1'
   */
  rtb_rTExhBound_SensScal = 15.0F * rtb_rTExhBound_SensScal_Lim;

  /* RelationalOperator: '<S5>/Relational Operator' */
  for (i = 0; i < 25; i++) {
    rtb_RelationalOperator[i] = (rtb_Abs[i] > rtb_rTExhBound_SensScal);
  }

  /* End of RelationalOperator: '<S5>/Relational Operator' */

  /* Product: '<S5>/Divide5' incorporates:
   *  Constant: '<S5>/Constant'
   */
  rtb_Divide5 = 5.0F * rtb_rTExhBound_SensScal_Lim;

  /* Outputs for Atomic SubSystem: '<S5>/TON_OutBound' */
  TExhMon_TON_InBound(rtb_RelationalOperator, rtb_Divide5,
                      &TExhMon_B->TON_OutBound, &TExhMon_DWork->TON_OutBound, inst);

  /* End of Outputs for SubSystem: '<S5>/TON_OutBound' */

  /* Logic: '<S5>/Logical Operator3' */
  for (i = 0; i < 25; i++) {
    rtb_LogicalOperator3[i] = !TExhMon_B->TON_OutBound.LogicalOperator3[i];
  }

  /* End of Logic: '<S5>/Logical Operator3' */

  /* Product: '<S5>/Divide3' incorporates:
   *  Constant: '<S5>/Constant2'
   */
  rtb_Divide3 = 120.0F / rtb_rTExhBound_SensScal_Lim;

  /* Outputs for Atomic SubSystem: '<S5>/TON_InBound' */
  TExhMon_TON_InBound(rtb_LogicalOperator3, rtb_Divide3, &TExhMon_B->TON_InBound,
                      &TExhMon_DWork->TON_InBound, inst);

  /* End of Outputs for SubSystem: '<S5>/TON_InBound' */

  /* MATLAB Function: '<S16>/MATLAB Function1' */
  /* MATLAB Function 'Init_Calculations/EGT_SignalJumpDetection/MATLAB Function1': '<S20>:1' */
  rtb_Memory = !TExhMon_B->BusInput.tGCB_On_Di;

  /* '<S20>:1:10' */
  for (i = 0; i < 25; i++) {
    /* MATLAB Function: '<S16>/MATLAB Function1' incorporates:
     *  RelationalOperator: '<S16>/Relational Operator2'
     */
    rtb_FixPtRelationalOperator[i] = (TExhMon_DWork->TexhJump[i] && (!(rtb_Abs[i]
      > rtb_rTExhBound_SensScal)));

    /* RelationalOperator: '<S16>/Relational Operator1' incorporates:
     *  Constant: '<S16>/Constant4'
     *  Delay: '<S16>/Delay'
     *  Sum: '<S16>/Add'
     */
    rtb_FixPtRelationalOperator_0[i] = (TExhMon_B->BusInput.rT_EPU_EG[i] >
      TExhMon_DWork->Delay_DSTATE[i] + 5.0F);
  }

  /* MATLAB Function: '<S16>/MATLAB Function1' */
  TExhMon_eml_li_find(rtb_FixPtRelationalOperator_0, idx_data, &idx_sizes, inst);

  /* '<S20>:1:12' */
  for (i_0 = 0; i_0 < idx_sizes; i_0++) {
    TExhMon_DWork->TexhJump[idx_data[i_0] - 1] = TRUE;
  }

  for (i_0 = 0; i_0 < 25; i_0++) {
    rtb_FixPtRelationalOperator_0[i_0] = (rtb_FixPtRelationalOperator[i_0] ||
      rtb_Memory);
  }

  TExhMon_eml_li_find(rtb_FixPtRelationalOperator_0, idx_data, &idx_sizes, inst);

  /* '<S20>:1:13' */
  for (i_0 = 0; i_0 < idx_sizes; i_0++) {
    TExhMon_DWork->TexhJump[idx_data[i_0] - 1] = FALSE;
  }

  /* Outputs for Atomic SubSystem: '<S16>/TOF' */
  /* output */
  /* '<S20>:1:16' */
  for (i = 0; i < 25; i++) {
    /* MATLAB Function: '<S16>/MATLAB Function1' */
    rtb_y_ct[i] = TExhMon_DWork->TexhJump[i];

    /* Switch: '<S21>/Switch' incorporates:
     *  Constant: '<S21>/Constant1'
     */
    if (rtb_y_ct[i]) {
      rtb_Abs[i] = 0.0F;
    } else {
      rtb_Abs[i] = rtb_Divide3;
    }

    /* End of Switch: '<S21>/Switch' */
  }

  /* DiscreteIntegrator: '<S21>/Discrete-Time Integrator' */
  if (TExhMon_DWork->DiscreteTimeIntegrator_IC_LOADI != 0) {
    for (i = 0; i < 25; i++) {
      TExhMon_DWork->DiscreteTimeIntegrator_DSTATE[i] = rtb_Abs[i];
    }
  }

  /* Update for DiscreteIntegrator: '<S21>/Discrete-Time Integrator' */
  TExhMon_DWork->DiscreteTimeIntegrator_IC_LOADI = 0U;

  /* End of Outputs for SubSystem: '<S16>/TOF' */

  /* MATLAB Function: '<S5>/  ' incorporates:
   *  Logic: '<S21>/Logical Operator1'
   *  Logic: '<S5>/Logical Operator'
   */
  /* MATLAB Function 'Init_Calculations/  ': '<S14>:1' */
  /* '<S14>:1:4' */
  k = 0;

  /* Outputs for Atomic SubSystem: '<S16>/TOF' */
  for (i = 0; i < 25; i++) {
    /* DiscreteIntegrator: '<S21>/Discrete-Time Integrator' */
    if (rtb_y_ct[i] && (TExhMon_DWork->DiscreteTimeIntegrator_PrevRese[i] <= 0))
    {
      TExhMon_DWork->DiscreteTimeIntegrator_DSTATE[i] = rtb_Abs[i];
    }

    /* Logic: '<S21>/Logical Operator1' incorporates:
     *  DiscreteIntegrator: '<S21>/Discrete-Time Integrator'
     *  RelationalOperator: '<S21>/Relational Operator'
     */
    rtb_RelationalOperator3 = !(TExhMon_DWork->DiscreteTimeIntegrator_DSTATE[i] >=
      rtb_Divide3);

    /* Update for DiscreteIntegrator: '<S21>/Discrete-Time Integrator' incorporates:
     *  DataTypeConversion: '<S22>/Conversion'
     *  Logic: '<S21>/Logical Operator5'
     */
    TExhMon_DWork->DiscreteTimeIntegrator_DSTATE[i] += (real32_T)!rtb_y_ct[i];
    if (rtb_y_ct[i]) {
      TExhMon_DWork->DiscreteTimeIntegrator_PrevRese[i] = 1;
    } else {
      TExhMon_DWork->DiscreteTimeIntegrator_PrevRese[i] = 0;
    }

    /* Logic: '<S5>/Logical Operator' incorporates:
     *  Logic: '<S5>/Logical Operator1'
     *  Logic: '<S5>/Logical Operator2'
     *  Logic: '<S5>/Logical Operator4'
     */
    rtb_FixPtRelationalOperator_1 = (rtb_y_c[i] && (!(TExhMon_B->
      BusInput.MSAGT[i] || (!TExhMon_B->TON_InBound.LogicalOperator3[i]) ||
      rtb_RelationalOperator3)));

    /* Switch: '<S5>/Switch9' incorporates:
     *  Product: '<S5>/Divide1'
     */
    if ((rtb_FixPtRelationalOperator_1 ? (int32_T)
         TExhMon_B->BusInput.bTExh_Mon_UseNarrowWindow[i] : 0) != 0) {
      rtb_Switch9[i] = rtb_Divide6;
    } else {
      rtb_Switch9[i] = rtb_rdT_Ref_Max_Lim;
    }

    /* End of Switch: '<S5>/Switch9' */

    /* Product: '<S5>/Divide' */
    rtb_Divide[i] = rtb_FixPtRelationalOperator_1 ?
      TExhMon_B->BusInput.rT_EPU_EG[i] : 0.0F;
    if (rtb_FixPtRelationalOperator_1) {
      k++;
    }

    rtb_LogicalOperator1_g[i] = rtb_RelationalOperator3;
    rtb_y_c[i] = rtb_FixPtRelationalOperator_1;
  }

  /* End of Outputs for SubSystem: '<S16>/TOF' */
  c = k;
  j = 0;
  for (i = 0; i < 25; i++) {
    if (rtb_y_c[i]) {
      y_data[j] = (int8_T)(i + 1);
      j++;
    }
  }

  if (k == 0) {
    rtb_rTExhBound_SensScal_Lim = 0.0F;
  } else {
    midm = k / 2;
    idx_sizes = (int8_T)k;
    for (i_0 = 1; i_0 <= k; i_0++) {
      idx_data[i_0 - 1] = i_0;
    }

    for (i_0 = 1; i_0 <= k - 1; i_0 += 2) {
      if (!(rtb_Divide[y_data[i_0 - 1] - 1] <= rtb_Divide[y_data[i_0] - 1])) {
        idx_data[i_0 - 1] = i_0 + 1;
        idx_data[i_0] = i_0;
      }
    }

    for (i_0 = 0; i_0 < k; i_0++) {
      idx0_data[i_0] = 1;
    }

    k = 2;
    while (k < c) {
      idx_sizes = k << 1;
      b_j = 1;
      for (pEnd = 1 + k; pEnd < c + 1; pEnd = qEnd + k) {
        p = b_j;
        q = pEnd;
        qEnd = b_j + idx_sizes;
        if (qEnd > c + 1) {
          qEnd = c + 1;
        }

        i_0 = 0;
        kEnd = qEnd - b_j;
        while (i_0 + 1 <= kEnd) {
          if (rtb_Divide[y_data[idx_data[p - 1] - 1] - 1] <=
              rtb_Divide[y_data[idx_data[q - 1] - 1] - 1]) {
            idx0_data[i_0] = idx_data[p - 1];
            p++;
            if (p == pEnd) {
              while (q < qEnd) {
                i_0++;
                idx0_data[i_0] = idx_data[q - 1];
                q++;
              }
            }
          } else {
            idx0_data[i_0] = idx_data[q - 1];
            q++;
            if (q == qEnd) {
              while (p < pEnd) {
                i_0++;
                idx0_data[i_0] = idx_data[p - 1];
                p++;
              }
            }
          }

          i_0++;
        }

        for (i_0 = 0; i_0 + 1 <= kEnd; i_0++) {
          idx_data[(b_j + i_0) - 1] = idx0_data[i_0];
        }

        b_j = qEnd;
      }

      k = idx_sizes;
    }

    if (midm << 1 == c) {
      if ((rtb_Divide[y_data[idx_data[midm - 1] - 1] - 1] < 0.0F) !=
          (rtb_Divide[y_data[idx_data[midm] - 1] - 1] < 0.0F)) {
        rtb_rTExhBound_SensScal_Lim = (rtb_Divide[y_data[idx_data[midm - 1] - 1]
          - 1] + rtb_Divide[y_data[idx_data[midm] - 1] - 1]) / 2.0F;
      } else {
        rtb_rTExhBound_SensScal_Lim = (rtb_Divide[y_data[idx_data[midm] - 1] - 1]
          - rtb_Divide[y_data[idx_data[midm - 1] - 1] - 1]) / 2.0F +
          rtb_Divide[y_data[idx_data[midm - 1] - 1] - 1];
      }
    } else {
      rtb_rTExhBound_SensScal_Lim = rtb_Divide[y_data[idx_data[midm] - 1] - 1];
    }
  }

  /* End of MATLAB Function: '<S5>/  ' */

  /* Product: '<S5>/Divide2' */
  for (i = 0; i < 25; i++) {
    rtb_Divide2[i] = rtb_y_c[i] ? TExhMon_B->BusInput.rCA_Ign_Act[i] : 0.0F;
  }

  /* End of Product: '<S5>/Divide2' */

  /* BusSelector: '<Root>/Bus Selector9' */
  rtb_tGCB_On_Di_i = TExhMon_B->BusInput.tGCB_On_Di;

  /* CombinatorialLogic: '<S8>/Logic' incorporates:
   *  Constant: '<S1>/Constant3'
   *  Logic: '<S1>/Logical Operator1'
   *  Memory: '<S8>/Memory'
   *  RelationalOperator: '<S1>/Relational Operator1'
   */
  rtb_Logic_idx = TExhMon_ConstP.pooled12[((((uint32_T)
    (rtb_rTExhBound_SensScal_Lim > 500.0F) << 1) + (uint32_T)!rtb_tGCB_On_Di_i) <<
    1) + (uint32_T)TExhMon_DWork->Memory_PreviousInput];

  /* Switch: '<S6>/Switch3' incorporates:
   *  Constant: '<S6>/Constant3'
   */
  if (rtb_tDelay_dTExhMon_Act != 0.0F) {
    /* Saturate: '<S6>/Saturation3' */
    if (rtb_tDelay_dTExhMon_Act >= 3600.0F) {
      rtb_tDelay_dTExhMon_Act_Lim = 3600.0F;
    } else if (rtb_tDelay_dTExhMon_Act <= 0.0F) {
      rtb_tDelay_dTExhMon_Act_Lim = 0.0F;
    } else {
      rtb_tDelay_dTExhMon_Act_Lim = rtb_tDelay_dTExhMon_Act;
    }

    /* End of Saturate: '<S6>/Saturation3' */
  } else {
    rtb_tDelay_dTExhMon_Act_Lim = 120.0F;
  }

  /* End of Switch: '<S6>/Switch3' */

  /* Outputs for Atomic SubSystem: '<S1>/TON_TExhMon_Act_GCB_ON' */
  TExhMon_TON_TExhMon_Act_GCB_ON(rtb_tGCB_On_Di_i, rtb_tDelay_dTExhMon_Act_Lim,
    &TExhMon_B->TON_TExhMon_Act_GCB_ON, &TExhMon_DWork->TON_TExhMon_Act_GCB_ON, inst);

  /* End of Outputs for SubSystem: '<S1>/TON_TExhMon_Act_GCB_ON' */

  /* CombinatorialLogic: '<S9>/Logic' incorporates:
   *  Constant: '<S1>/Constant2'
   *  Memory: '<S9>/Memory'
   *  RelationalOperator: '<S1>/Relational Operator2'
   *  RelationalOperator: '<S1>/Relational Operator3'
   */
  tmp = ((((uint32_T)(TExhMon_B->BusInput.rP_Act_Norm_Filt > 0.25F) << 1) +
          (uint32_T)(TExhMon_B->BusInput.rP_Act_Norm_Filt < 0.1875F)) << 1) +
    (uint32_T)TExhMon_DWork->Memory_PreviousInput_o;
  rtb_Logic_e[0U] = TExhMon_ConstP.pooled12[tmp];
  rtb_Logic_e[1U] = TExhMon_ConstP.pooled12[tmp + 8U];

  /* Switch: '<S6>/Switch7' incorporates:
   *  Constant: '<S6>/Constant7'
   */
  if (rtb_tDelay_dTExhMon_Act_P != 0.0F) {
    /* Saturate: '<S6>/Saturation7' */
    if (rtb_tDelay_dTExhMon_Act_P >= 500.0F) {
      rtb_tDelay_dTExhMon_Act_P_Lim = 500.0F;
    } else if (rtb_tDelay_dTExhMon_Act_P <= 0.0F) {
      rtb_tDelay_dTExhMon_Act_P_Lim = 0.0F;
    } else {
      rtb_tDelay_dTExhMon_Act_P_Lim = rtb_tDelay_dTExhMon_Act_P;
    }

    /* End of Saturate: '<S6>/Saturation7' */
  } else {
    rtb_tDelay_dTExhMon_Act_P_Lim = 60.0F;
  }

  /* End of Switch: '<S6>/Switch7' */

  /* Outputs for Atomic SubSystem: '<S1>/xTON_bdTExhMon_Act_P' */
  TExhMon_TON_TExhMon_Act_GCB_ON(rtb_Logic_e[0], rtb_tDelay_dTExhMon_Act_P_Lim,
    &TExhMon_B->xTON_bdTExhMon_Act_P, &TExhMon_DWork->xTON_bdTExhMon_Act_P, inst);

  /* End of Outputs for SubSystem: '<S1>/xTON_bdTExhMon_Act_P' */

  /* Logic: '<S1>/Logical Operator' */
  rtb_LogicalOperator_g = (rtb_Logic_idx &&
    TExhMon_B->TON_TExhMon_Act_GCB_ON.LogicalOperator3 &&
    TExhMon_B->xTON_bdTExhMon_Act_P.LogicalOperator3 &&
    TExhMon_B->BusInput1.bTExhMon_Release);

  /* Logic: '<Root>/Logical Operator1' */
  rtb_Memory = !rtb_LogicalOperator_g;

  /* Outputs for Atomic SubSystem: '<Root>/TExh Mon Cont Exec' */
  /* Sum: '<S7>/Add10' */
  rtb_y = rtb_rTExhBound_SensScal_Lim + rtb_rdT2Exp_Max_Lim;
  for (i = 0; i < 25; i++) {
    /* Sum: '<S7>/Add1' */
    rtb_Abs[i] = rtb_Divide2[i] - TExhMon_B->BusInput.rCA_IgnP_Set;

    /* RelationalOperator: '<S25>/FixPt Relational Operator' incorporates:
     *  UnitDelay: '<S25>/Delay Input1'
     */
    rtb_FixPtRelationalOperator_1 = ((int32_T)rtb_y_c[i] > (int32_T)
      TExhMon_DWork->DelayInput1_DSTATE[i]);

    /* Switch: '<S7>/Switch' incorporates:
     *  UnitDelay: '<S7>/Unit Delay'
     */
    if (rtb_FixPtRelationalOperator_1) {
      rtb_Switch_b[i] = TExhMon_DWork->UnitDelay_DSTATE_i[i];
    } else {
      rtb_Switch_b[i] = rtb_y_c[i];
    }

    /* End of Switch: '<S7>/Switch' */

    /* RelationalOperator: '<S25>/FixPt Relational Operator' */
    rtb_FixPtRelationalOperator[i] = rtb_FixPtRelationalOperator_1;
  }

  /* Product: '<S7>/Divide' */
  rtb_rTExhBound_SensScal = TExhMon_B->BusInput.rTs_task / rtb_rFiltTau_TExh_Lim;

  /* MATLAB Function: '<S7>/MATLAB Function' */
  /* MATLAB Function 'TExh Mon Cont Exec/MATLAB Function': '<S26>:1' */
  /* '<S26>:1:8' */
  if ((!TExhMon_DWork->rdT2Ref_1_not_empty) || rtb_Memory ||
      TExhMon_DWork->bReset_1) {
    /* '<S26>:1:15' */
    /*      rdT2Ref_1 = (rT_EPU_EG - rTExhAVG_MEDIAN) * bValid; */
    /* '<S26>:1:18' */
    TExhMon_DWork->rdT2Ref_1_not_empty = TRUE;

    /* '<S26>:1:20' */
    for (i = 0; i < 25; i++) {
      TExhMon_DWork->rdT2Ref_1[i] = rtb_Divide[i] - rtb_rTExhBound_SensScal_Lim;
      rtb_FixPtRelationalOperator_0[i] = !(rtb_Switch_b[i] == 1);
    }

    TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator_0, idx_data, &idx_sizes, inst);

    /* '<S26>:1:21' */
    for (i_0 = 0; i_0 < idx_sizes; i_0++) {
      TExhMon_DWork->rdT2Ref_1[idx_data[i_0] - 1] = 0.0F;
    }
  }

  /* '<S26>:1:24' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    rtb_FixPtRelationalOperator[i_0] = (rtb_FixPtRelationalOperator[i_0] == 1);
  }

  /* '<S26>:1:25' */
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, idx_data, &idx_sizes, inst);
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, idx0_data, &idx_sizes, inst);
  for (i_0 = 0; i_0 < idx_sizes; i_0++) {
    TExhMon_DWork->rdT2Ref_1[idx_data[i_0] - 1] = rtb_Divide[idx0_data[i_0] - 1]
      - rtb_rTExhBound_SensScal_Lim;
  }

  if ((!TExhMon_DWork->rCA_ITPOffset_1_not_empty) || rtb_Memory ||
      TExhMon_DWork->bReset_1) {
    /* '<S26>:1:27' */
    /* '<S26>:1:28' */
    for (i = 0; i < 25; i++) {
      TExhMon_DWork->rCA_ITPOffset_1[i] = 0.0F;
    }

    TExhMon_DWork->rCA_ITPOffset_1_not_empty = TRUE;
  }

  /* '<S26>:1:31' */
  /*  not valid signal */
  /* '<S26>:1:33' */
  for (i = 0; i < 25; i++) {
    rtb_rdT2Ref[i] = TExhMon_DWork->rdT2Ref_1[i];
    rtb_FixPtRelationalOperator[i] = ((rtb_Divide[i] >
      rtb_rTExhBound_SensScal_Lim - TExhMon_B->BusInput.rdTExh_Misfire) &&
      rtb_Switch_b[i]);
  }

  /*  no misfire and valid signal */
  /* '<S26>:1:34' */
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, idx_data, &idx_sizes, inst);
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, idx0_data, &idx_sizes, inst);
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, tmp_data, &i, inst);
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, tmp_data_0, &i, inst);
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, tmp_data_1, &i, inst);
  for (i_0 = 0; i_0 < idx_sizes; i_0++) {
    rtb_rdT2Ref[idx_data[i_0] - 1] = ((rtb_Divide[tmp_data[i_0] - 1] -
      rtb_rTExhBound_SensScal_Lim) * rtb_rTExhBound_SensScal +
      TExhMon_DWork->rdT2Ref_1[idx0_data[i_0] - 1] * (1.0F -
      rtb_rTExhBound_SensScal)) + (TExhMon_DWork->rCA_ITPOffset_1[tmp_data_0[i_0]
      - 1] - rtb_Abs[tmp_data_1[i_0] - 1]) *
      TExhMon_B->BusInput.rT_dTExhMon_ITPComp;
  }

  /* '<S26>:1:40' */
  for (i_0 = 0; i_0 < 25; i_0++) {
    rtb_FixPtRelationalOperator[i_0] = ((!rtb_FixPtRelationalOperator[i_0]) &&
      rtb_Switch_b[i_0]);
  }

  /*  misfire and valid signal */
  /* '<S26>:1:41' */
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, idx_data, &idx_sizes, inst);
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, idx0_data, &idx_sizes, inst);
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, tmp_data, &i, inst);
  TExhMon_eml_li_find_b(rtb_FixPtRelationalOperator, tmp_data_0, &i, inst);
  for (i_0 = 0; i_0 < idx_sizes; i_0++) {
    rtb_rdT2Ref[idx_data[i_0] - 1] = (TExhMon_DWork->
      rCA_ITPOffset_1[tmp_data[i_0] - 1] - rtb_Abs[tmp_data_0[i_0] - 1]) *
      TExhMon_B->BusInput.rT_dTExhMon_ITPComp + TExhMon_DWork->
      rdT2Ref_1[idx0_data[i_0] - 1];
  }

  /* '<S26>:1:46' */
  /* '<S26>:1:47' */
  /* '<S26>:1:48' */
  TExhMon_DWork->bReset_1 = rtb_Memory;

  /* Delay: '<S7>/Delay1' incorporates:
   *  Sum: '<S7>/Add11'
   */
  rtb_RelationalOperator3 = (rtb_Memory &&
    (TExhMon_PrevZCSigState->Delay1_Reset_ZCE != TExhMon_POS_ZCSIG));
  TExhMon_PrevZCSigState->Delay1_Reset_ZCE = (uint8_T)rtb_Memory;
  for (i = 0; i < 25; i++) {
    /* MATLAB Function: '<S7>/MATLAB Function' */
    TExhMon_DWork->rdT2Ref_1[i] = rtb_rdT2Ref[i];
    TExhMon_DWork->rCA_ITPOffset_1[i] = rtb_Abs[i];
    if (rtb_RelationalOperator3) {
      TExhMon_DWork->Delay1_DSTATE[i] = 65535.0F;
    }

    rtb_Abs[i] = rtb_rTExhBound_SensScal_Lim + rtb_rdT2Ref[i];
  }

  /* Delay: '<S7>/Delay2' */
  rtb_RelationalOperator3 = ((!rtb_Memory) &&
    (TExhMon_PrevZCSigState->Delay2_Reset_ZCE != TExhMon_ZERO_ZCSIG));
  TExhMon_PrevZCSigState->Delay2_Reset_ZCE = (uint8_T)rtb_Memory;

  /* Logic: '<S7>/Logical Operator2' */
  rtb_Memory = !rtb_Memory;
  for (i = 0; i < 25; i++) {
    /* Delay: '<S7>/Delay2' */
    if (rtb_RelationalOperator3) {
      TExhMon_DWork->Delay2_DSTATE[i] = 0.0F;
    }

    /* Sum: '<S7>/Add9' incorporates:
     *  Sum: '<S7>/Add5'
     */
    rtb_tDelay_dTExhMon_Act = (rtb_rdT2Ref[i] + rtb_rTExhBound_SensScal_Lim) +
      rtb_Switch9[i];

    /* MinMax: '<S7>/MinMax1' */
    if (!(rtb_tDelay_dTExhMon_Act <= rtb_y)) {
      rtb_tDelay_dTExhMon_Act = rtb_y;
    }

    /* Product: '<S7>/Product1' incorporates:
     *  MinMax: '<S7>/MinMax1'
     */
    rtb_tDelay_dTExhMon_Act = rtb_y_c[i] ? rtb_tDelay_dTExhMon_Act : 0.0F;

    /* Logic: '<S7>/Logical Operator' incorporates:
     *  RelationalOperator: '<S7>/Relational Operator1'
     */
    rtb_FixPtRelationalOperator[i] = (rtb_y_c[i] && (rtb_Divide[i] >
      rtb_tDelay_dTExhMon_Act) && rtb_Memory);

    /* Product: '<S7>/Product3' incorporates:
     *  Sum: '<S7>/Add12'
     */
    rtb_tDelay_dTExhMon_Act_P = rtb_y_c[i] ? rtb_Divide[i] - rtb_Abs[i] : 0.0F;

    /* Switch: '<S7>/Switch2' incorporates:
     *  Constant: '<S7>/Constant2'
     */
    if (rtb_y_c[i]) {
      /* MinMax: '<S7>/MinMax3' incorporates:
       *  Delay: '<S7>/Delay1'
       */
      if (rtb_tDelay_dTExhMon_Act_P <= TExhMon_DWork->Delay1_DSTATE[i]) {
        rtb_Switch2[i] = rtb_tDelay_dTExhMon_Act_P;
      } else {
        rtb_Switch2[i] = TExhMon_DWork->Delay1_DSTATE[i];
      }

      /* End of MinMax: '<S7>/MinMax3' */
    } else {
      rtb_Switch2[i] = 65535.0F;
    }

    /* End of Switch: '<S7>/Switch2' */

    /* MinMax: '<S7>/MinMax4' incorporates:
     *  Delay: '<S7>/Delay2'
     */
    if (rtb_tDelay_dTExhMon_Act_P >= TExhMon_DWork->Delay2_DSTATE[i]) {
      rtb_rTExhBound_SensScal = rtb_tDelay_dTExhMon_Act_P;
    } else {
      rtb_rTExhBound_SensScal = TExhMon_DWork->Delay2_DSTATE[i];
    }

    /* Product: '<S7>/Product5' incorporates:
     *  MinMax: '<S7>/MinMax4'
     */
    rtb_Product5[i] = rtb_y_c[i] ? rtb_rTExhBound_SensScal : 0.0F;

    /* Product: '<S7>/Product3' */
    rtb_Product3[i] = rtb_tDelay_dTExhMon_Act_P;

    /* Product: '<S7>/Product1' */
    rtb_Product1[i] = rtb_tDelay_dTExhMon_Act;
  }

  /* Sum: '<S7>/Sum of Elements' */
  tmp = (uint32_T)rtb_FixPtRelationalOperator[0];
  for (j = 0; j < 24; j++) {
    tmp += (uint32_T)rtb_FixPtRelationalOperator[j + 1];
  }

  for (i = 0; i < 25; i++) {
    /* Update for UnitDelay: '<S7>/Unit Delay' */
    TExhMon_DWork->UnitDelay_DSTATE_i[i] = rtb_y_c[i];

    /* Update for UnitDelay: '<S25>/Delay Input1' */
    TExhMon_DWork->DelayInput1_DSTATE[i] = rtb_y_c[i];

    /* Update for Delay: '<S7>/Delay1' */
    TExhMon_DWork->Delay1_DSTATE[i] = rtb_Switch2[i];

    /* Update for Delay: '<S7>/Delay2' */
    TExhMon_DWork->Delay2_DSTATE[i] = rtb_Product5[i];

    /* BusCreator: '<Root>/Bus Creator' incorporates:
     *  Product: '<S7>/Product'
     *  Product: '<S7>/Product4'
     */
    TExhMon_Y->Out.bdTExhMonTrip[i] = rtb_FixPtRelationalOperator[i];
    TExhMon_Y->Out.rT_Exh_Exp[i] = rtb_y_c[i] ? rtb_Abs[i] : 0.0F;
    TExhMon_Y->Out.rT_EG_Lim_dTExhMon[i] = rtb_Product1[i];
    TExhMon_Y->Out.rdT2Limit[i] = rtb_Product3[i];
    TExhMon_Y->Out.rdT2Limit_Max[i] = rtb_Product5[i];
    TExhMon_Y->Out.rdT2Limit_Min[i] = rtb_y_c[i] ? rtb_Switch2[i] : 0.0F;
  }

  /* Switch: '<S7>/Switch1' incorporates:
   *  BusCreator: '<Root>/Bus Creator'
   *  Sum: '<S7>/Sum of Elements'
   */
  TExhMon_Y->Out.bdTExhMonTrip_all = ((uint8_T)tmp != 0);

  /* End of Outputs for SubSystem: '<Root>/TExh Mon Cont Exec' */

  /* BusCreator: '<Root>/Bus Creator' */
  TExhMon_Y->Out.bdTExhMon_Act = rtb_LogicalOperator_g;
  TExhMon_Y->Out.rTExh_median = rtb_rTExhBound_SensScal_Lim;

  /* BusCreator: '<Root>/Bus Creator1' */
  TExhMon_Y->Dbg.rP_Act_Norm_Filt_dbg = TExhMon_B->BusInput.rP_Act_Norm_Filt;
  for (i = 0; i < 25; i++) {
    TExhMon_Y->Dbg.rdT2Ref[i] = rtb_rdT2Ref[i];
    TExhMon_Y->Dbg.rT_EPU_EG_Cyl_Vect[i] = rtb_Divide[i];
    TExhMon_Y->Dbg.rCA_Ign_Act_Vect[i] = rtb_Divide2[i];
    TExhMon_Y->Dbg.rdT_Ref_Max_Cyl[i] = rtb_Switch9[i];
    TExhMon_Y->Dbg.bValidCyl[i] = rtb_y_c[i];
    TExhMon_Y->Dbg.bEGTSignalJump[i] = rtb_LogicalOperator1_g[i];
  }

  /* End of BusCreator: '<Root>/Bus Creator1' */

  /* S-Function (bur_bus_out): '<Root>/Bus Output' */
  inst->Out = TExhMon_Y->Out;

  /* S-Function (bur_bus_out): '<Root>/Bus Output1' */
  inst->Dbg = TExhMon_Y->Dbg;

  /* UnitDelay: '<S4>/Unit Delay' */
  TExhMon_B->UnitDelay = TExhMon_DWork->UnitDelay_DSTATE;

  /* S-Function (bur_out): '<Root>/Output' */
  inst->Version = TExhMon_B->UnitDelay;

  /* Update for Delay: '<S16>/Delay' */
  for (i = 0; i < 25; i++) {
    TExhMon_DWork->Delay_DSTATE[i] = TExhMon_B->BusInput.rT_EPU_EG[i];
  }

  /* End of Update for Delay: '<S16>/Delay' */

  /* Update for Memory: '<S8>/Memory' */
  TExhMon_DWork->Memory_PreviousInput = rtb_Logic_idx;

  /* Update for Memory: '<S9>/Memory' */
  TExhMon_DWork->Memory_PreviousInput_o = rtb_Logic_e[0];

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  TExhMon_DWork->UnitDelay_DSTATE = 105U;
}

/* Model initialize function */
void TExhMon_initialize(struct D_Work_TExhMon *TExhMon_DWork, struct PrevZCSigStates_TExhMon
  *TExhMon_PrevZCSigState, struct fTExhMon* inst)
{
  TExhMon_PrevZCSigState->Delay1_Reset_ZCE = POS_ZCSIG;
  TExhMon_PrevZCSigState->Delay2_Reset_ZCE = ZERO_ZCSIG;

  {
    int32_T i;

    /* InitializeConditions for Atomic SubSystem: '<S16>/TOF' */
    /* InitializeConditions for DiscreteIntegrator: '<S21>/Discrete-Time Integrator' */
    TExhMon_DWork->DiscreteTimeIntegrator_IC_LOADI = 1U;

    /* End of InitializeConditions for SubSystem: '<S16>/TOF' */

    /* InitializeConditions for Atomic SubSystem: '<Root>/TExh Mon Cont Exec' */
    /* InitializeConditions for MATLAB Function: '<S7>/MATLAB Function' */
    TExhMon_DWork->bReset_1 = TRUE;

    /* InitializeConditions for Atomic SubSystem: '<S16>/TOF' */
    for (i = 0; i < 25; i++) {
      /* InitializeConditions for DiscreteIntegrator: '<S21>/Discrete-Time Integrator' */
      TExhMon_DWork->DiscreteTimeIntegrator_PrevRese[i] = 2;

      /* InitializeConditions for Delay: '<S7>/Delay1' */
      TExhMon_DWork->Delay1_DSTATE[i] = 65535.0F;
    }

    /* End of InitializeConditions for SubSystem: '<S16>/TOF' */
    /* End of InitializeConditions for SubSystem: '<Root>/TExh Mon Cont Exec' */
  }
}

/* Model terminate function */
void TExhMon_terminate(struct fTExhMon* inst)
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
