/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: AI50toIT_mdl
 * File: AI50toIT_mdl_private.h
 * Author: 105055527
 * Created: Thu Sep 11 18:05:22 2014
 ********************************************************************
 * Header for program AI50toIT_mdl
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_AI50toIT_mdl_private_h_
#define RTW_HEADER_AI50toIT_mdl_private_h_
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
extern real32_T Kt;                    /* Variable: Kt
                                        * Referenced by: '<S6>/Constant10'
                                        */
extern real32_T N;                     /* Variable: N
                                        * Referenced by: '<S6>/Constant8'
                                        */
extern real32_T T_filt_AI50;           /* Variable: T_filt_AI50
                                        * Referenced by: '<S1>/Constant3'
                                        */
extern real32_T deadband;              /* Variable: deadband
                                        * Referenced by: '<S6>/Constant11'
                                        */
extern real32_T kd;                    /* Variable: kd
                                        * Referenced by: '<S6>/Constant7'
                                        */
extern real32_T ki;                    /* Variable: ki
                                        * Referenced by: '<S6>/Constant6'
                                        */
extern real32_T kp;                    /* Variable: kp
                                        * Referenced by: '<S6>/Constant5'
                                        */
extern real32_T umax;                  /* Variable: umax
                                        * Referenced by: '<S6>/Constant16'
                                        */
extern real32_T umin;                  /* Variable: umin
                                        * Referenced by: '<S6>/Constant17'
                                        */
extern int16_T mode;                   /* Variable: mode
                                        * Referenced by: '<S6>/Constant'
                                        */
extern boolean_T invert;               /* Variable: invert
                                        * Referenced by: '<S6>/Constant4'
                                        */
extern boolean_T reset;                /* Variable: reset
                                        * Referenced by:
                                        *   '<S1>/Constant2'
                                        *   '<S6>/Constant1'
                                        */

#endif                                 /* RTW_HEADER_AI50toIT_mdl_private_h_ */
