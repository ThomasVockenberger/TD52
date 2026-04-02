(*******************************************************************************
gas_train		gas train  					(INIT)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.30.0	06.11.2014	Tinello		Update to NEW specification

Instructions for use:
--------------------

*******************************************************************************)
PROGRAM _INIT

	(* ramp settings *)
	xRAMPE_R_DPr_MGT_P1.enable		:= TRUE;
	xRAMPE_R_DPr_MGT_P1.Rise		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_MGT_P1.Sink		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_MGT_P1.TC_Time		:= TASK_TIME_100MS;

	xRAMPE_R_DPr_MGT_P2.enable		:= TRUE;
	xRAMPE_R_DPr_MGT_P2.Rise		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_MGT_P2.Sink		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_MGT_P2.TC_Time		:= TASK_TIME_100MS;

	xRAMPE_R_DPr_MGT_Ch_P1.enable	:= TRUE;
	xRAMPE_R_DPr_MGT_Ch_P1.Rise		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_MGT_Ch_P1.Sink		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_MGT_Ch_P1.TC_Time	:= TASK_TIME_100MS;

	xRAMPE_R_DPr_MGT_Ch_P2.enable	:= TRUE;
	xRAMPE_R_DPr_MGT_Ch_P2.Rise		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_MGT_Ch_P2.Sink		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_MGT_Ch_P2.TC_Time	:= TASK_TIME_100MS;


	xRAMPE_R_DPr_PCGT_P1.enable		:= TRUE;
	xRAMPE_R_DPr_PCGT_P1.Rise		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_PCGT_P1.Sink		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_PCGT_P1.TC_Time	:= TASK_TIME_100MS;

	xRAMPE_R_DPr_PCGT_P2.enable		:= TRUE;
	xRAMPE_R_DPr_PCGT_P2.Rise		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_PCGT_P2.Sink		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_PCGT_P2.TC_Time	:= TASK_TIME_100MS;

	xRAMPE_R_DPr_PCGT_Ch_P1.enable	:= TRUE;
	xRAMPE_R_DPr_PCGT_Ch_P1.Rise	:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_PCGT_Ch_P1.Sink	:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_PCGT_Ch_P1.TC_Time	:= TASK_TIME_100MS;

	xRAMPE_R_DPr_PCGT_Ch_P2.enable	:= TRUE;
	xRAMPE_R_DPr_PCGT_Ch_P2.Rise	:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_PCGT_Ch_P2.Sink	:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_DPr_PCGT_Ch_P2.TC_Time	:= TASK_TIME_100MS;
	
	(* Settings for DBOV *)
	rDPr_MGT_DBOV_SetAct_GR_Th; 				(* gas rail pressure threshold for main gas train dome blow off valve *)
	rDPr_MGT_DBOV_SetAct_GR_Hy; 				(* gas rail pressure hysteresis for main gas train dome blow off valve different for type 6/9*)
	xTOF_POS_EDGE_MGT_BOV.PT		:= T#300ms; (* duration for opening DBOV after positive edge of MBOV *)
	xTON_MGT_DBOV.PT				:= T#60s;

	(* PT1 settings for H2 content measurement *)
	xLCRPT1_H2.enable := TRUE;
	xLCRPT1_H2.t	  := 1;	

END_PROGRAM
