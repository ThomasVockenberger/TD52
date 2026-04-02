/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: LambdaAdp
 * File: LambdaAdp_private.h
 * Author: 105051472
 * Created: Wed Oct 29 12:06:16 2014
 ********************************************************************
 * Header for program LambdaAdp
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.2
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_LambdaAdp_private_h_
#define RTW_HEADER_LambdaAdp_private_h_
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
extern real32_T rLam_OffsLimit_pos;    /* Variable: rLam_OffsLimit_pos
                                        * Referenced by: '<S1>/rLam_OffsLimit_pos'
                                        */
extern real32_T rLam_Ramp_Grad;        /* Variable: rLam_Ramp_Grad
                                        * Referenced by: '<S1>/rLam_Ramp_Grad'
                                        */
extern real32_T rN_Delta_Lim;          /* Variable: rN_Delta_Lim
                                        * Referenced by: '<S1>/rN_Delta_Lim'
                                        */
extern real32_T rN_Set;                /* Variable: rN_Set
                                        * Referenced by: '<S1>/rN_Set'
                                        */
extern real32_T rP_Nom;                /* Variable: rP_Nom
                                        * Referenced by: '<S1>/rP_Nom'
                                        */
extern real32_T rP_Rot_Norm_Lam_Trig;  /* Variable: rP_Rot_Norm_Lam_Trig
                                        * Referenced by: '<S1>/rP_Rot_Norm_Lam_Trig'
                                        */
extern real32_T rP_Rot_Norm_Lambda_Gain;/* Variable: rP_Rot_Norm_Lambda_Gain
                                         * Referenced by: '<S1>/rP_Rot_Norm_Lambda_Gain'
                                         */

#endif                                 /* RTW_HEADER_LambdaAdp_private_h_ */
