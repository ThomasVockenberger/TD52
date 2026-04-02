(*******************************************************************************
GeneralEM		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V04.05.00.00	22.05.2017	Tinello		new
V04.05.06.00	16.07.2018	Tinello 	Bugfix start speed, bu
V04.07.00.00	11.04.2019	Tinello 	engine motortype included
V04.14.00.00	18.11.2024	Farre		added NOx sensor selection: standard or Low (2023-183)

																																	
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC
	
	(* Release Module if ParaSetupOk = TRUE *)
	xTON_ParaSetupOk(IN		:= IN_EM.tPB2MM.bParaSetupOk, PT:= T#10s);
	bRelModul_ParaSetupOk	:= xTON_ParaSetupOk.Q;


	(* operation mode *)
	xOpMode.in	:=	IN_EM.iSt_OpMode;
	xOpMode();


	(* Operation mode selector switch *) 	(* 1= manual; 2= auto; 3= test mode *)
	xTOF_OMSS_MAT(IN	:= (IN_EM.iIdx_OMSS = 1) OR (IN_EM.iIdx_OMSS = 2) OR (IN_EM.iIdx_OMSS = 3), PT := T#10m);
	bOMSS_MAT			:= xTOF_OMSS_MAT.IN;
	bOMSS_MAT_TOF_10m	:= xTOF_OMSS_MAT.Q;


	(* engine start speed reached *)
	xGR_MAXR_StartSpd(In:= IN_EM.rN_EngAct,   Gw := Para.rN_EngStart_LimHi, Hy := Para.rN_EngStart_HyHi);
	xTOF_StartSpd(IN 	:= xGR_MAXR_StartSpd.Q AND bRelModul_ParaSetupOk, 	PT := T#10s);
	xTON_StartSpd_5m(IN := xGR_MAXR_StartSpd.Q AND bRelModul_ParaSetupOk, 	PT := T#5m);

	bStartSpd			:= xTOF_StartSpd.Q;
	bStartSpd_5m		:= xTON_StartSpd_5m.Q;


	(* Engine motortype *)
	xEngType.Motortype 	:= INT_TO_UINT(Para.iEng_Motortype);
	xEngType();
	
	
	(* Type of device installed after catalyst *) 
	bNOxS_CatOut_Std 	:= Para.iNOxS_CatOut_Device_Type = 0;				(* 0: Standard NOx sensor *)
	bNOxS_CatOut_Low 	:= Para.iNOxS_CatOut_Device_Type = 1;				(* 1: Low NOx sensor *)

END_PROGRAM