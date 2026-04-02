(*******************************************************************************
GeneralCH		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	18.03.2013 	Tinello 	Created 
V04.04.00.00	18.05.2016 	Tinello 	bP_Nom10_600s added for Spec Vers. c 
										Release Module, number of CBV and motor type added
										bP_Nom75_02s, bGCB_On_300s added
V04.06.00.00	01.10.2018 	Tinello 	bNetP_Island_20s added
V04.07.00.00	04.12.2018 	Tinello 	Number of compressor bypass valves added for engine type 4
V04.12.00.00	23.03.2023	Tinello		Added release Sys_Run

(*******************************************************************************)

PROGRAM _CYCLIC

	(* Release Module if ParaSetupOk = TRUE *)
	xTON_ParaSetupOk(IN		:= IN_CH.tPB2MM.bParaSetupOk, PT:= T#10s);
	bRelModul_ParaSetupOk	:= xTON_ParaSetupOk.Q;

	xTON_Sys_Run(IN			:= IN_CH.tPB2MM.bSys_Run, PT:= T#60s);
	bRelModul_Sys_Run		:= xTON_Sys_Run.Q;


	(* Engine motortype *)
	xEngType.Motortype 	:= INT_TO_UINT(Para.iEng_Motortype);
	xEngType();


	(* Operation mode selector switch *)
	bOMSS_MAT 	:= (IN_CH.iIdx_OMSS = 1) OR (IN_CH.iIdx_OMSS = 2) OR (IN_CH.iIdx_OMSS = 3);	(* 1= manual; 2= auto; 3= test mode *)

	
	(* engine start speed reached *)
	xGR_MAXR_StartSpd(In:= IN_CH.rN_EngAct, Gw := Para.rN_EngStart_LimHi, Hy := Para.rN_EngStart_HyHi);
	xTOF_StartSpd(IN 	:= xGR_MAXR_StartSpd.Q AND bRelModul_ParaSetupOk, PT := T#10s);
	bStartSpd			:= xTOF_StartSpd.Q;

	
	(* engine power > 10%Pn + 60s / 300s *)	
	xGR_MAXR_P_Act10(In := IN_CH.rP_Act_Norm_Filt, Gw:= 0.1, Hy:= 0.01);				
	xTON_P_Act10_60(IN	:= xGR_MAXR_P_Act10.Q AND bRelModul_ParaSetupOk AND IN_CH.tGCB_On.Di, PT:= T#60s);
	xTON_P_Act10_300(IN	:= xGR_MAXR_P_Act10.Q AND bRelModul_ParaSetupOk AND IN_CH.tGCB_On.Di, PT:= T#300s);
	xTON_P_Act10_600(IN	:= xGR_MAXR_P_Act10.Q AND bRelModul_ParaSetupOk AND IN_CH.tGCB_On.Di, PT:= T#600s);

	bP_Nom10_60s 		:= xTON_P_Act10_60.Q;
	bP_Nom10_300s 		:= xTON_P_Act10_300.Q;
	bP_Nom10_600s 		:= xTON_P_Act10_600.Q;

	
	(* engine power > 50%Pn + 30s *)	
	xGR_MAXR_P_Act50(In := IN_CH.rP_Act_Norm_Filt, Gw:= 0.5, Hy:= 0.01);				
	xTON_P_Act50_30(IN	:= xGR_MAXR_P_Act50.Q AND bRelModul_ParaSetupOk AND IN_CH.tGCB_On.Di, PT:= T#30s);

	bP_Nom50_30s 		:= xTON_P_Act50_30.Q;


	(* engine power > 75%Pn + 2s *)	
	xGR_MAXR_P_Act75(In := IN_CH.rP_Act_Norm_Filt, Gw:= 0.75, Hy:= 0.05);				
	xTON_P_Act75_02(IN	:= xGR_MAXR_P_Act75.Q AND bRelModul_ParaSetupOk AND IN_CH.tGCB_On.Di, PT:= T#2s);

	bP_Nom75_02s 		:= xTON_P_Act75_02.Q;


	(* generator circuit breaker CLOSED + 300s *)	
	xTON_GCB_On_300(IN	:= IN_CH.tGCB_On.Di, PT:= T#300s);
	bGCB_On_300s 		:= xTON_GCB_On_300.Q;


	(* call function for the state machine - engine operation mode *)
	xOpMode(in 	:= IN_CH.iSt_OpMode);

	(* Mains parallel operation mode / island mode + 20s *)	
	xTON_NetP_Island_20(IN	:= xOpMode.NetP OR xOpMode.Island, PT:= T#20s);
	bNetP_Island_20s		:= xTON_NetP_Island_20.Q;


	(* gastype *)
	gastype	:= IN_CH.iIdx_Gtyp_Dem;


	(* Number of compressor bypass valves *)
	CASE Para.iEng_Motortype OF
		412:	IF xOpMode.Island						 	THEN	rNum_Ch_CBV_Valve	:= 2;
															ELSE	rNum_Ch_CBV_Valve	:= 1;
				END_IF
		416:	IF xOpMode.Island						 	THEN	rNum_Ch_CBV_Valve	:= 2;
															ELSE	rNum_Ch_CBV_Valve	:= 1;
				END_IF
		420:	IF xOpMode.Island						 	THEN	rNum_Ch_CBV_Valve	:= 2;
															ELSE	rNum_Ch_CBV_Valve	:= 1;
				END_IF
		424:	IF xOpMode.Island						 	THEN	rNum_Ch_CBV_Valve	:= 2;
															ELSE	rNum_Ch_CBV_Valve	:= 1;
				END_IF
		612:														rNum_Ch_CBV_Valve	:= 1;
		616:														rNum_Ch_CBV_Valve	:= 2;
		620:														rNum_Ch_CBV_Valve	:= 3;
		624:	IF FIND(IN_CH.szEng_Motorversion, 'H') = 1 	THEN	rNum_Ch_CBV_Valve	:= 2;
															ELSE	rNum_Ch_CBV_Valve	:= 4;
				END_IF
		920:														rNum_Ch_CBV_Valve	:= 2;
	END_CASE


	
END_PROGRAM
