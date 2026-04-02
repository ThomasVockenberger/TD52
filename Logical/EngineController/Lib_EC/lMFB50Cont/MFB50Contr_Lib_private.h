/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: MFB50Contr_Lib
 * File: MFB50Contr_Lib_private.h
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Header for program MFB50Contr_Lib
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_MFB50Contr_Lib_private_h_
#define RTW_HEADER_MFB50Contr_Lib_private_h_
#include "rtwtypes.h"
#include <bur/plctypes.h>
#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#else
#ifdef TMWTYPES_PREVIOUSLY_INCLUDED
#error This file requires rtwtypes.h to be included before tmwtypes.h
#else

/* Check for inclusion of an incorrect version of rtwtypes.h */
#ifndef RTWTYPES_ID_C08S16I32L32N32F1
#error This code was generated with a different "rtwtypes.h" than the file included
#endif                                 /* RTWTYPES_ID_C08S16I32L32N32F1 */
#endif                                 /* TMWTYPES_PREVIOUSLY_INCLUDED */
#endif                                 /* __RTWTYPES_H__ */

#ifndef MIN
#define MIN(a,b)                       ((a) < (b) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)                       ((a) > (b) ? (a) : (b))
#endif

/* Imported (extern) block parameters */
extern real_T I0AllCyl[21];            /* Variable: I0AllCyl
                                        * Referenced by: '<Root>/inputvariable'
                                        */
extern real_T MFB50ActAllCyl[21];      /* Variable: MFB50ActAllCyl
                                        * Referenced by: '<Root>/inputvariable8'
                                        */
extern real_T MFB50EnPowTh;            /* Variable: MFB50EnPowTh
                                        * Referenced by: '<Root>/Relay'
                                        */
extern real_T MFB50EnSpdTh;            /* Variable: MFB50EnSpdTh
                                        * Referenced by: '<Root>/default 500 (rpm)'
                                        */
extern real_T MFB50GlobRefExt;         /* Variable: MFB50GlobRefExt
                                        * Referenced by: '<Root>/MFB50RefGlobExt (CADafTDC)'
                                        */
extern real_T MFB50RefOffsetAllCyl[21];/* Variable: MFB50RefOffsetAllCyl
                                        * Referenced by: '<Root>/inputvariable20'
                                        */
extern real_T MapIoP2sx[2];            /* Variable: MapIoP2sx
                                        * Referenced by: '<S7>/inputvariable1'
                                        */
extern real_T MapIoP2sy[2];            /* Variable: MapIoP2sy
                                        * Referenced by: '<S7>/inputvariable2'
                                        */
extern real_T MapMFB50oP2sx[2];        /* Variable: MapMFB50oP2sx
                                        * Referenced by: '<S4>/inputvariable1'
                                        */
extern real_T MapMFB50oP2sy[2];        /* Variable: MapMFB50oP2sy
                                        * Referenced by: '<S4>/inputvariable2'
                                        */
extern real_T MapMFB50oT3HPx[2];       /* Variable: MapMFB50oT3HPx
                                        * Referenced by: '<S4>/inputvariable7'
                                        */
extern real_T MapMFB50oT3HPy[2];       /* Variable: MapMFB50oT3HPy
                                        * Referenced by: '<S4>/inputvariable8'
                                        */
extern real_T MapPoP2sx[2];            /* Variable: MapPoP2sx
                                        * Referenced by: '<S7>/inputvariable8'
                                        */
extern real_T MapPoP2sy[2];            /* Variable: MapPoP2sy
                                        * Referenced by: '<S7>/inputvariable9'
                                        */
extern real_T PelAct;                  /* Variable: PelAct
                                        * Referenced by: '<Root>/Pel actual (%)'
                                        */
extern real_T T1_PT1;                  /* Variable: T1_PT1
                                        * Referenced by:
                                        *   '<S9>/timeconst'
                                        *   '<S10>/T1_PT1'
                                        */
extern real_T T3HP_A;                  /* Variable: T3HP_A
                                        * Referenced by: '<Root>/T3HP_A (°C)'
                                        */
extern real_T T3HP_B;                  /* Variable: T3HP_B
                                        * Referenced by: '<Root>/T3HP_B (°C)'
                                        */
extern real_T deadbandNeg;             /* Variable: deadbandNeg
                                        * Referenced by: '<S12>/Constant10'
                                        */
extern real_T deadbandPos;             /* Variable: deadbandPos
                                        * Referenced by: '<S12>/Constant9'
                                        */
extern real_T engSpeed;                /* Variable: engSpeed
                                        * Referenced by: '<Root>/engSpeed (rpm)'
                                        */
extern real_T init_PT1[21];            /* Variable: init_PT1
                                        * Referenced by:
                                        *   '<S9>/Initial value'
                                        *   '<S10>/init_PT1'
                                        */
extern real_T p2s_A;                   /* Variable: p2s_A
                                        * Referenced by: '<Root>/p2s_A (mbar)'
                                        */
extern real_T p2s_B;                   /* Variable: p2s_B
                                        * Referenced by: '<Root>/p2s_B (mbar)'
                                        */
extern real_T uMax;                    /* Variable: uMax
                                        * Referenced by: '<S12>/Constant6'
                                        */
extern real_T uMin;                    /* Variable: uMin
                                        * Referenced by: '<S12>/Constant7'
                                        */
extern int16_T EngOpState;             /* Variable: EngOpState
                                        * Referenced by: '<Root>/inputvariable5'
                                        */
extern boolean_T LoadEnabled;          /* Variable: LoadEnabled
                                        * Referenced by: '<Root>/Load enabled (boolean)'
                                        */
extern boolean_T MFB50ContrEn;         /* Variable: MFB50ContrEn
                                        * Referenced by: '<Root>/inputvariable6'
                                        */
extern boolean_T MFB50MedianEn;        /* Variable: MFB50MedianEn
                                        * Referenced by: '<Root>/MFB50MedianEn'
                                        */
extern boolean_T freezeAllCyl[21];     /* Variable: freezeAllCyl
                                        * Referenced by: '<Root>/inputvariable23'
                                        */
extern boolean_T isFastStart;          /* Variable: isFastStart
                                        * Referenced by: '<Root>/inputvariable4'
                                        */
extern boolean_T isITRetLimpHomeAllCyl[21];/* Variable: isITRetLimpHomeAllCyl
                                            * Referenced by: '<Root>/inputvariable7'
                                            */
extern boolean_T isKnockITRetAllCyl[21];/* Variable: isKnockITRetAllCyl
                                         * Referenced by: '<Root>/inputvariable2'
                                         */
extern boolean_T isSensFailAllCyl[21]; /* Variable: isSensFailAllCyl
                                        * Referenced by: '<Root>/inputvariable3'
                                        */
extern boolean_T isSkipAllCyl[21];     /* Variable: isSkipAllCyl
                                        * Referenced by: '<Root>/inputvariable1'
                                        */
extern boolean_T resetAllCyl[21];      /* Variable: resetAllCyl
                                        * Referenced by: '<Root>/manual reset'
                                        */
extern real_T rt_roundd(real_T u, struct MFB50Contr* inst);

/* Exported functions */
void BINARYSEARCH_real_T(uint32_T *piLeft, uint32_T *piRght, real_T u, const
  real_T *pData, uint32_T iHi, struct MFB50Contr* inst);
void LookUp_real_T_real_T(real_T *pY, const real_T *pYData, real_T u, const
  real_T *pUData, uint32_T iHi, struct MFB50Contr* inst);

#endif                                 /* RTW_HEADER_MFB50Contr_Lib_private_h_ */
