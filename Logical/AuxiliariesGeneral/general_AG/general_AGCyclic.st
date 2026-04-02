(*******************************************************************************
general		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2023
 
Customized modifications: -
------------------------
 
History:
-------
V4.00.0	25.04.2012	lettenb.	new
V4.04.0	27.10.2016	lettenb.	service mode prelubrication added
V4.05.0 11.12.2017	lettenb.	check para setup added
V4.09.0 10.03.2020	Schmid		bOMSS_Off added for starter demand ignition selftest
V4.10.0 17.08.2020	Schmid		added FreshOilPump_Block signal
V4.11.0	07.02.2022	Schmid		added para setup check variable (already introduced with v4.10)
V4.13.0	18.12.2023	Tinello		added speed for 5s reached (2023-184) 
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* check para setup *)
	IN_AG.tPB2MM.bParaSetupOk;
	Para.iEng_Motortype;    (* MIN= 208    MAX= 920    *)
	Para.rN_EngStart_LimHi; (* MIN=  50.0  MAX= 2200.0 *)
	Para.rN_EngNom; 		(* MIN= 100.0  MAX= 2200.0 *)
	Para.tiPreLube;			(* MIN=   2    MAX= 300    *)
	
	
	(* engine typ *)
	xEngType.Motortype := INT_TO_UINT(Para.iEng_Motortype);
	xEngType();				(* use: xEngType.Type2 as BOOL, ....*)


	(* engine operation mode *)
			bOMSS_Off  := FALSE;
			bOMSS_Man  := FALSE;
			bOMSS_Aut  := FALSE;
			bOMSS_Test := FALSE;
			bOMSS_MAT  := FALSE;
			bOMSS_Scav := FALSE;
	CASE IN_AG.iIdx_OMSS OF
		0:	bOMSS_Off  := TRUE;
		1:	bOMSS_Man  := TRUE;
			bOMSS_MAT  := TRUE;
		2:	bOMSS_Aut  := TRUE;
			bOMSS_MAT  := TRUE;
		3:	bOMSS_Test := TRUE;
			bOMSS_MAT  := TRUE;
		4:	bOMSS_Scav := TRUE;
	END_CASE;			

	(* PLC Running *) 
	IN_AG.tPB2MM.bSys_Run;

	
	(*---------------------------------------------------------------------------*)
	(* start speed exceeded *)
	xGR_MAXR_DREHZ(In	:= IN_AG.rN_EngAct, Gw:= Para.rN_EngStart_LimHi, Hy:= Para.rN_EngStart_HyHi);
	xTOF_M_DREHZ(IN		:= xGR_MAXR_DREHZ.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#10s);
	xTON_M_DREHZ_5s(IN	:= xGR_MAXR_DREHZ.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#5s);

	M_DREHZ 			:= xTOF_M_DREHZ.Q;
	M_DREHZ_5s 			:= xTON_M_DREHZ_5s.Q;

	(* ramp up speed *)
	xGR_MAXR_HDREHZ(In:= IN_AG.rN_EngAct, Gw:= Para.rN_EngStart_LimHiHi, Hy:= Para.rN_EngStart_HyHiHi);
	M_HDREHZ := xGR_MAXR_HDREHZ.Q AND IN_AG.tPB2MM.bParaSetupOk;	
	
	(* limit cooling water temperature pre-heating OFF *)
	xGRMAXR_KWT(In := IN_AG.tT_ECW.Ai, Gw := Para.rT_ECW_PreH_LimOFF, Hy := Para.rT_ECW_PreH_HyOFF);
	xTON_T_ECW_PreH_LimOFF(IN:= xGRMAXR_KWT.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#2s);
	AN_VORW := xTON_T_ECW_PreH_LimOFF.Q;	

	(* forward TC_CoolDownRun info for MM customized  *)
	OUT_AG.bTC_CoolDownRun := bTC_CoolDownRun;
	
	(* run time exceeded fresh oil pump  *)
	OUT_AG.tFreshOilPump_RTC.Do := 			MM2VIS.bMsg2742
									OR NOT 	IN_AG.tL_OilSumpHi.Di
									OR NOT	IN_AG.tL_OilSump2Hi.Di
									OR NOT	IN_AG.tL_OilSump3Hi.Di;
									
	(* block fresh oil pressure increase pump operation at oil pressure max warning *)
	OUT_AG.tFreshOilPump_Block.Do := MM2VIS.bMsg9328;


	(* service mode prelubrication *)
	(* operation of both pre-lubrication pumps for 50 oph AND 30 starts *)
	IF Para.iEng_Motortype = 624 AND Para.bServicePrelub THEN

		xImpH(CLK := IN_AG.tImp_OpHour.Do);
		IF xImpH.Q THEN iCntH := LIMIT(iCntH + 1, 0, 999999);	(* counter + 1 *)
		END_IF;
	
		xImpS(CLK := IN_AG.bImp_Start);
		IF xImpS.Q THEN iCntS := LIMIT(iCntS + 1, 0, 999999);	(* counter + 1 *)
		END_IF;
	
		xService(CLK := IN_AG.bServiceMode);
		IF xService.Q THEN iCntH := iCntS := 0;					(* counter reset *)
		END_IF;
			
		bServicePrelube := (iCntH <= 50) OR (iCntS <= 30);
	ELSE
		bServicePrelube := FALSE;
	END_IF;

			
END_PROGRAM
