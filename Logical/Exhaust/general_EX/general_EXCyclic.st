(*******************************************************************************
general_EX		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V4.00.0	25.04.2012	lettenb.	new
V4.03.0	01.07.2015	lettenb.	xBH_OpHour_Oxi added
V4.05.0 11.12.2017	lettenb.	check para setup added, EG average values for EM added
V4.05.1 15.02.2018	lettenb.	bAMM_T_EG... reset added
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* check para setup *)
	IN_EX.tPB2MM.bParaSetupOk;
	Para.iEng_Motortype;    (* MIN= 208    MAX= 920    *)
	Para.rN_EngStart_LimHi; (* MIN=  50.0  MAX= 2200.0 *)


	(* engine typ *)
	xEngType.Motortype := INT_TO_UINT(Para.iEng_Motortype);
	xEngType();				(* use: xEngType.Type2 as BOOL, ....*)


	(* engine operation mode *)
			bOMSS_Man  := FALSE;	
			bOMSS_Aut  := FALSE;
			bOMSS_Test := FALSE;
			bOMSS_MAT  := FALSE;
			bOMSS_Scav := FALSE;
	CASE IN_EX.iIdx_OMSS OF
		1:	bOMSS_Man  := TRUE;	
			bOMSS_MAT  := TRUE;
		2:	bOMSS_Aut  := TRUE;
			bOMSS_MAT  := TRUE;
		3:	bOMSS_Test := TRUE;
			bOMSS_MAT  := TRUE;
		4:	bOMSS_Scav := TRUE;
	END_CASE;			


	(* Operation hour counter - oxi cat operation *)
	xBH_OpHour_Oxi(enable := IN_EX.tEng_Run.Do, BH_adr := ADR(OpHour_Oxi.tick));
	xR_TRIG_OpHour_Oxi(CLK := xBH_OpHour_Oxi.BH_Imp);
	
	IF xR_TRIG_OpHour_Oxi.Q THEN	(* if an operation hour is finished *)
		(* operating hour counter *)
		VIS2MM.iCnt_OpHours_Oxi := VIS2MM.iCnt_OpHours_Oxi + 1;		(* increase counter *)
		(* check limits *)
		IF VIS2MM.iCnt_OpHours_Oxi >= 1000000000 THEN
			VIS2MM.iCnt_OpHours_Oxi := VIS2MM.iCnt_OpHours_Oxi - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCnt_OpHours_Oxi <= -1000000000 THEN
			VIS2MM.iCnt_OpHours_Oxi := VIS2MM.iCnt_OpHours_Oxi + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	
	(* Reset Warning by VISU *)
	bResetWarning := IN_EX.tAB2EX.bResetWarning;
	
	
	(* average values for other modules *)
	OUT_EX.bAMM_T_EGbTC := FALSE;
	OUT_EX.bAMM_T_EGaTC := FALSE;
	OUT_EX.bAMM_T_EGaLPTC_Avg := FALSE;
	OUT_EX.bAMM_T_EGbHPTC_Avg := FALSE;
	OUT_EX.bAMM_T_EGaHPTC_Avg := FALSE;
	(*-----------------------------------------------------------------------------------------------------*)
	IF 		Para.bT_EGbTC_Active     AND IN_EX.tT_EGbTC.GoodQual	 THEN OUT_EX.rT_EGbTC := IN_EX.tT_EGbTC.Ai;
	ELSE 																  OUT_EX.rT_EGbTC := 0.0;
																		  OUT_EX.bAMM_T_EGbTC := TRUE;
	END_IF;																		  

	IF 		Para.bT_EGaTC_Active     AND IN_EX.tT_EGaTC.GoodQual	 THEN OUT_EX.rT_EGaTC := IN_EX.tT_EGaTC.Ai;
	ELSE 																  OUT_EX.rT_EGaTC := 0.0;
																		  OUT_EX.bAMM_T_EGaTC := TRUE;
	END_IF;																		  
	(*-----------------------------------------------------------------------------------------------------*)
	IF 		Para.bT_EGaLPTC_A_Active AND IN_EX.tT_EGaLPTC_A.GoodQual THEN
		IF 	Para.bT_EGaLPTC_B_Active AND IN_EX.tT_EGaLPTC_B.GoodQual THEN OUT_EX.rT_EGaLPTC_Avg :=(IN_EX.tT_EGaLPTC_A.Ai + IN_EX.tT_EGaLPTC_B.Ai) / 2;
		ELSE  															  OUT_EX.rT_EGaLPTC_Avg := IN_EX.tT_EGaLPTC_A.Ai;
		END_IF;
	ELSIF 	Para.bT_EGaLPTC_B_Active AND IN_EX.tT_EGaLPTC_B.GoodQual THEN OUT_EX.rT_EGaLPTC_Avg := IN_EX.tT_EGaLPTC_B.Ai;
	ELSE  																  OUT_EX.rT_EGaLPTC_Avg := 0.0;
																		  OUT_EX.bAMM_T_EGaLPTC_Avg := TRUE;
	END_IF;
	(*-----------------------------------------------------------------------------------------------------*)
	IF 		Para.bT_EGbHPTC_A_Active AND IN_EX.tT_EGbHPTC_A.GoodQual THEN
		IF 	Para.bT_EGbHPTC_B_Active AND IN_EX.tT_EGbHPTC_B.GoodQual THEN OUT_EX.rT_EGbHPTC_Avg :=(IN_EX.tT_EGbHPTC_A.Ai + IN_EX.tT_EGbHPTC_B.Ai) / 2;
		ELSE  															  OUT_EX.rT_EGbHPTC_Avg := IN_EX.tT_EGbHPTC_A.Ai;
		END_IF;
	ELSIF 	Para.bT_EGbHPTC_B_Active AND IN_EX.tT_EGbHPTC_B.GoodQual THEN OUT_EX.rT_EGbHPTC_Avg := IN_EX.tT_EGbHPTC_B.Ai;
	ELSE  																  OUT_EX.rT_EGbHPTC_Avg := 0.0;
																		  OUT_EX.bAMM_T_EGbHPTC_Avg := TRUE;
	END_IF;
	(*-----------------------------------------------------------------------------------------------------*)
	IF 		Para.bT_EGaHPTC_A_Active AND IN_EX.tT_EGaHPTC_A.GoodQual THEN
		IF 	Para.bT_EGaHPTC_B_Active AND IN_EX.tT_EGaHPTC_B.GoodQual THEN OUT_EX.rT_EGaHPTC_Avg :=(IN_EX.tT_EGaHPTC_A.Ai + IN_EX.tT_EGaHPTC_B.Ai) / 2;
		ELSE  															  OUT_EX.rT_EGaHPTC_Avg := IN_EX.tT_EGaHPTC_A.Ai;
		END_IF;
	ELSIF 	Para.bT_EGaHPTC_B_Active AND IN_EX.tT_EGaHPTC_B.GoodQual THEN OUT_EX.rT_EGaHPTC_Avg := IN_EX.tT_EGaHPTC_B.Ai;
	ELSE  																  OUT_EX.rT_EGaHPTC_Avg := 0.0;
																		  OUT_EX.bAMM_T_EGaHPTC_Avg := TRUE;
	END_IF;
	
	MM2VIS.rT_EGaLPTC_Avg	:= OUT_EX.rT_EGaLPTC_Avg;
	MM2VIS.rT_EGbHPTC_Avg	:= OUT_EX.rT_EGbHPTC_Avg;
	MM2VIS.rT_EGaHPTC_Avg	:= OUT_EX.rT_EGaHPTC_Avg;
	(*-----------------------------------------------------------------------------------------------------*)
	
	
END_PROGRAM
