/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: SimPID4
 * File: SimPID4_private.h
 * Author: 106001702
 * Created: Wed Nov 09 12:46:00 2011
 ********************************************************************
 * Header for program SimPID4
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_SimPID4_private_h_
#define RTW_HEADER_SimPID4_private_h_
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
extern real_T deadband;                /* Variable: deadband
                                        * Referenced by: '<S2>/Deadband'
                                        */
extern real_T wxmax;                   /* Variable: wxmax
                                        * Referenced by: '<S2>/Scaling'
                                        */
extern real_T wxmin;                   /* Variable: wxmin
                                        * Referenced by: '<S2>/Scaling'
                                        */
extern real32_T D;                     /* Variable: D
                                        * Referenced by: '<S3>/Gain2'
                                        */
extern real32_T I;                     /* Variable: I
                                        * Referenced by: '<S3>/Gain1'
                                        */
extern real32_T Kt;                    /* Variable: Kt
                                        * Referenced by: '<S2>/Constant'
                                        */
extern real32_T N;                     /* Variable: N
                                        * Referenced by: '<S3>/Filter Coefficient'
                                        */
extern real32_T P;                     /* Variable: P
                                        * Referenced by: '<S3>/Gain'
                                        */
extern real32_T umax;                  /* Variable: umax
                                        * Referenced by: '<S3>/Saturation'
                                        */
extern real32_T umin;                  /* Variable: umin
                                        * Referenced by: '<S3>/Saturation'
                                        */

#endif                                 /* RTW_HEADER_SimPID4_private_h_ */
