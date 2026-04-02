/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer Industrie-Elektronik Ges.m.b.H.
 ********************************************************************
 * Program: Sim6CTR
 * File: Sim6CTR_private.h
 * Author: 105051472
 * Created: Wed Oct 23 10:19:46 2013
 ********************************************************************
 * Header for program Sim6CTR
 ********************************************************************
 * Generated with B&R Automation Studio Target for Simulink V4.0
 * (ERT based)
 ********************************************************************/

#ifndef RTW_HEADER_Sim6CTR_private_h_
#define RTW_HEADER_Sim6CTR_private_h_
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
extern real32_T CycleTime;             /* Variable: CycleTime
                                        * Referenced by: '<S1>/Cyclic Time'
                                        */
extern real32_T Ts_downSampling_speed; /* Variable: Ts_downSampling_speed
                                        * Referenced by: '<S1>/Ts_downSampling_speed'
                                        */
extern real32_T rN_ok_offset;          /* Variable: rN_ok_offset
                                        * Referenced by: '<S1>/rN_ok_offset'
                                        */
extern real32_T rP_drop_limit;         /* Variable: rP_drop_limit
                                        * Referenced by: '<S1>/rP_drop_limit'
                                        */
extern real32_T rP_el_LockTV;          /* Variable: rP_el_LockTV
                                        * Referenced by: '<S1>/rP_el_LockTV'
                                        */
extern real32_T rP_el_ReleaseTV;       /* Variable: rP_el_ReleaseTV
                                        * Referenced by: '<S1>/rP_el_ReleaseTV'
                                        */
extern real32_T u_man_TV;              /* Variable: u_man_TV
                                        * Referenced by: '<S1>/u_man_TV'
                                        */
extern real32_T u_max_CBP;             /* Variable: u_max_CBP
                                        * Referenced by: '<S10>/Saturation'
                                        */
extern real32_T u_max_TV;              /* Variable: u_max_TV
                                        * Referenced by: '<S13>/Saturation'
                                        */
extern real32_T u_min_CBP;             /* Variable: u_min_CBP
                                        * Referenced by: '<S10>/Saturation'
                                        */
extern real32_T u_min_TV;              /* Variable: u_min_TV
                                        * Referenced by: '<S13>/Saturation'
                                        */

#endif                                 /* RTW_HEADER_Sim6CTR_private_h_ */
