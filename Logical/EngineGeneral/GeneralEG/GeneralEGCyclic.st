(*******************************************************************************
GeneralEG		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2021
 
Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	08.02.2013 	Tinello 	Created 
V04.03.00.00	20.01.2016	Tinello		Release Module if ParaSetupOk = TRUE added
V04.05.00.00	26.01.2017	Tinello		Release Module from 10s -> 20s
V04.10.00.00	28.01.2021	Tinello		operation mode added
	
(*******************************************************************************)
PROGRAM _CYCLIC

	(* Release Module if ParaSetupOk = TRUE *)
	xTON_ParaSetupOk(IN		:= IN_EG.tPB2MM.bParaSetupOk, PT:= T#20s);
	bRelModul_ParaSetupOk	:= xTON_ParaSetupOk.Q;


	(* Engine motortype *)
	xEngType.Motortype 	:= INT_TO_UINT(Para.iEng_Motortype);
	xEngType();

	
	(* Number of cylinder --> VISU *)
	MM2VIS.iNum_Cyl 	:= xEngType.NumberOfCylinder;

	
	(* engine start speed reached *)
	xGR_MAXR_StartSpd(In:= IN_EG.rN_EngAct,   Gw := Para.rN_EngStart_LimHi, Hy := Para.rN_EngStart_HyHi);
	xTOF_StartSpd(IN 	:= xGR_MAXR_StartSpd.Q AND bRelModul_ParaSetupOk, 	PT := T#10s);
	bStartSpd			:= xTOF_StartSpd.Q;

	
	(* Power signal missing *)
	xGR_MINR_P_Lo(In 	:= IN_EG.rP_Act_Norm, Gw := Para.rP_LimLo, Hy := Para.rP_HyLo);	
	bP_Lo_Trig 		 	:= xGR_MINR_P_Lo.Q AND bRelModul_ParaSetupOk;

	(* Operation mode selector switch *)
	bOMSS_MAT := (IN_EG.iIdx_OMSS = 1) OR (IN_EG.iIdx_OMSS = 2) OR (IN_EG.iIdx_OMSS = 3);	(* 1= manual; 2= auto; 3= test mode *)


	(* operation mode *)
	xOpMode.in	:=	IN_EG.iSt_OpMode;
	xOpMode();
		
END_PROGRAM
