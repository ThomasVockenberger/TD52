(*******************************************************************************
vis			visualization

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2024
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0	24.04.2012	lettenb.	new
V3.99.0	25.04.2013	lettenb.	data for oil counter trending added
		03.05.2013				ctr input var's from vis moved to Ctr_EO
		16.05.2013				MM2VIS.rOC_Consum_Avg added
V3.99.1	21.08.2013	Denk		Oil quality sensor added
V4.00.0	30.06.2014	lettenb.	MM2VIS.bECWP1Dem: xEngType.Type2 added, bugfix
		20.11.2014				920: engine bearing removed --> MM_EG
		26.01.2015				920: Ctr_EOVal_LT, Ctr_EOVal_LT added
V4.03.0 07.08.2015  Denk		Manual operating auxiliaries control functionality added
		11.01.2016				MM2VIS oil counter interfaces moved from Vis_AG -> Cnt_EO(to enable scroll function of settings)bugfix
V4.04.0	10.05.2016	lettenb.	rPr_EOaP added
V4.05.0	10.05.2016	lettenb.	prelubrication for fast start
V4.05.1	19.02.2018	lettenb.	rDPr_BbFilt_A,rDPr_BbFilt_B prepared for vis
V4.06.0	19.09.2018	Perktold, 	integrated MM2VIS.bPreL_FS_EngStaRel
V4.07.0	17.12.2018	Schmid		hydraulic ECW pre-heating added
		08.01.2019	Schmid		redundant pump control
V4.09.0	11.12.2019	Schmid		new air starter design: engagement pressure sensor and valve commands added
V4.10.0	12.01.2020	Schmid		added MM2VIS.bNoExtendedPrelube for 5min start
		16.12.2020	Schmid		battery voltages added
V4.11.0	05.11.2021	Schmid		added OUT_AG.bECWP_MechDriven for Pr_ECW plausibility check
V4.12.0	06.12.2022 	Bacci		control cabinet battery voltages bugfixing 
		24.02.2023	Tinello		added MM2VIS for HWP
V4.13.0	27.09.2023	Bacci		MM2VIS.rOQS_Temp, MM2VIS.rOQS_Visco, MM2VIS.rOQS_Dielect, MM2VIS.rOQS_Conduct deleted
		01.02.2024	Tinello		Only one calculation for oil filter diff pressure (2023-184) 
		15.02.2024	Bacci		MM2VIS.bU_Starter_engage1 added
V4.14.0	25.11.2024  Bacci		T6 Start procedure with purge start (2024-219): added volume of purge air, purge state, fast start readiness

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	MM2VIS.rPr_CC      				:= IN_AG.tPr_CC.Ai;

	MM2VIS.bEOP1AC_Dem 				:= OUT_AG.tEOP1AC_Dem.Do;
	MM2VIS.bEOP1DC_Dem 				:= OUT_AG.tEOP1DC_Dem.Do;

	IF Para.bECWP_MechDriven AND (xEngType.Type2 OR xEngType.Type3) THEN
		MM2VIS.bECWP1Dem			:=	M_DREHZ;
		OUT_AG.bECWP_MechDriven		:=	TRUE;		(*custom new Pr_ECW plausibility check*)
	ELSE
		MM2VIS.bECWP1Dem			:=	OUT_AG.tECWP1Dem.Do;
		OUT_AG.bECWP_MechDriven		:=	FALSE;		(*custom new Pr_ECW plausibility check*)
	END_IF;


	MM2VIS.bECWP2Dem      			:= OUT_AG.tECWP2Dem.Do;
	MM2VIS.bECWP_PreH_Dem 			:= OUT_AG.tECWP_PreH_Dem.Do;
	MM2VIS.bECW_PreH_Dem  			:= OUT_AG.tECW_PreH_Dem.Do;
	MM2VIS.bECW_PreHV_Opened  		:= IN_AG.tECW_PreHV_Opened.Di;
	MM2VIS.bECW_CV_Open		    	:= bECW_CV_Open;
	MM2VIS.rCtr_ECW_Set				:= OUT_AG.tCtr_ECW_Set.Ao;
	MM2VIS.rPr_ECWaP1				:= IN_AG.tPr_ECWaP1.Ai;
	MM2VIS.rPr_ECWaP2				:= IN_AG.tPr_ECWaP2.Ai;

	MM2VIS.bPreL_FS_EngStaRel		:= OUT_AG.bPreL_FS_EngStaRel AND OUT_AG.bT_EOP_RelFS AND (Para.bFSPreL_Act OR xEngType.Type3);
	MM2VIS.bNoExtendedPrelube		:= OUT_AG.bNoExtendedPrelube;

	MM2VIS.bEng_StaSpdExc			:= M_DREHZ;
	MM2VIS.rPr_EOF_Diff				:= rDPr_EOF;
	
	MM2VIS.rPr_EngLubOil 			:= IN_AG.tPr_EngLubOil.Ai;
	MM2VIS.rPr_EOF_DiffMon 			:= IN_AG.tPr_EOF_DiffMon.Ai;	(* engine oil pressure before filter *)
	MM2VIS.rEO_Level 				:= IN_AG.tEO_Level.Ai;
	MM2VIS.rPr_EOF_After			:= IN_AG.tPr_EOF_After.Ai;
	MM2VIS.rPr_EOaP					:= IN_AG.tPr_EOaP.Ai;			(* engine oil pressure after pump *)
	MM2VIS.rT_EO					:= IN_AG.tT_EO.Ai;
	MM2VIS.rT_EOP_After				:= IN_AG.tT_EOP_After.Ai;

	MM2VIS.rPr_TC_EOF_After			:= IN_AG.tPr_TC_EOF_After.Ai;
	MM2VIS.rPr_TC_EOF_Before		:= IN_AG.tPr_TC_EOF_Before.Ai;
	MM2VIS.rPr_Oil_LPTC_In_A		:= IN_AG.tPr_Oil_LPTC_In_A.Ai;
	MM2VIS.rPr_Oil_LPTC_In_B		:= IN_AG.tPr_Oil_LPTC_In_B.Ai;
	MM2VIS.rPr_TCO		 			:= IN_AG.tPr_TCO.Ai;
	MM2VIS.bTCOV_CoClose 			:= OUT_AG.tTCOV_CoClose.Do;
		
	MM2VIS.rT_EO_Pan				:= IN_AG.tT_EO_Pan.Ai;
	MM2VIS.rT_EO_Preheating			:= IN_AG.tT_EO_Preheating.Ai;
	MM2VIS.bEOF_PreheatRel			:= OUT_AG.tEOF_PreheatRel.Do;
	MM2VIS.bEO_Preheat1				:= OUT_AG.tEO_Preheat1.Do;
	MM2VIS.bEO_Preheat2				:= OUT_AG.tEO_Preheat2.Do;
	MM2VIS.bEO_Preheat3				:= OUT_AG.tEO_Preheat3.Do;
	
	(*BlowBy*)
	MM2VIS.rPr_f_BbFilt				:= IN_AG.tPr_f_BbFilt.Ai;
	MM2VIS.rPr_a_BbFilt				:= IN_AG.tPr_a_BbFilt.Ai;
	MM2VIS.rPr_f_BbFilt_A			:= IN_AG.tPr_f_BbFilt_A.Ai;
	MM2VIS.rPr_a_BbFilt_A			:= IN_AG.tPr_a_BbFilt_A.Ai;
	MM2VIS.rPr_f_BbFilt_B			:= IN_AG.tPr_f_BbFilt_B.Ai;
	MM2VIS.rPr_a_BbFilt_B			:= IN_AG.tPr_a_BbFilt_B.Ai;
	MM2VIS.rDPr_BbFilt				:= rDPr_BbFilt;
	MM2VIS.rDPr_BbFilt_A			:= rDPr_BbFilt_A;
	MM2VIS.rDPr_BbFilt_B			:= rDPr_BbFilt_B;

	(*EleStart*)
	MM2VIS.bU_Starter_engage1		:= IN_AG.tU_Starter_engage1.GoodQual;
	MM2VIS.iVol_PurgeAir			:= iVol_PurgeAir;
	MM2VIS.bSt_Purge				:= bSt_Purge;
	MM2VIS.bFS_Rdy_STT_StPurge		:= OUT_AG.bFS_Rdy_STT_StPurge OR NOT xEngType.Type6;
	MM2VIS.iTi_ST_Res				:= iTi_ST_Res;

	(*AirStart*)
	MM2VIS.rPr_AirStarter_Tank		:= IN_AG.tPr_AirStarter_Tank.Ai;
	MM2VIS.rPr_AirStarter_Supply	:= IN_AG.tPr_AirStarter_Supply.Ai;
	MM2VIS.rN_AirStarter			:= rN_AirStarter;
	MM2VIS.rPr_AirST_Engage			:= IN_AG.tPr_AirST_Engage.Ai;
	MM2VIS.bAirST_ValEngage			:= OUT_AG.tAirST_ValEngage.Do;
	MM2VIS.bAirST_ValStart			:= OUT_AG.tAirST_ValStart.Do;

	(* Manual operating auxiliaries control - Handbedienebene *)
	MM2VIS.bManOpAuxCtr_Gnl_Rel		:= OUT_AG.tManAuxCtr.bGnl_Rel;		(* General release for button MAN/AUTO visibility *)

	(* Hydraulic ECW pre-heating *)
	MM2VIS.bECW_HydrPreH_Dem		:= bECW_HydrPreH_Dem;
	MM2VIS.rT_HW_Su_PreH_ECW_LimLo	:= IN_AG.tT_ECW.Ai + 10.0;
	MM2VIS.rT_HW_Su_PreH_ECW_LimHi	:= 95.0;

	(* Heating water pump *)
	MM2VIS.bHWP_On					:= OUT_AG.tHWP_Dem.Do 		AND IN_AG.tHWP_Op.Di;
	
	(* Redundant heating water pumps *)
	MM2VIS.bHWP1_Op					:= OUT_AG.tHWP1_Dem.Do		AND IN_AG.tHWP1_Op.Di;
	MM2VIS.bHWP2_Op					:= OUT_AG.tHWP2_Dem.Do		AND IN_AG.tHWP2_Op.Di;
	(* Redundant charge cooler water pumps *)
	MM2VIS.bCCWP1_Op				:= OUT_AG.tCCWP1_Dem.Do		AND IN_AG.tCCWP1_Op.Di;
	MM2VIS.bCCWP2_Op				:= OUT_AG.tCCWP2_Dem.Do		AND IN_AG.tCCWP2_Op.Di;
	(* Redundant charge cooler 2 water pumps *)
	MM2VIS.bCC2WP1_Op				:= OUT_AG.tCC2WP1_Dem.Do	AND IN_AG.tCC2WP1_Op.Di;
	MM2VIS.bCC2WP2_Op				:= OUT_AG.tCC2WP2_Dem.Do	AND IN_AG.tCC2WP2_Op.Di;
	(* Redundant emergency cooler water pumps *)
	MM2VIS.bEmCWP1_Op				:= OUT_AG.tEmCWP1_Dem.Do	AND IN_AG.tEmCWP1_Op.Di;
	MM2VIS.bEmCWP2_Op				:= OUT_AG.tEmCWP2_Dem.Do	AND IN_AG.tEmCWP2_Op.Di;

	(* Battery voltages *)
	MM2VIS.rU_StarterBat := IN_AG.tU_StarterBat.Ai;
	MM2VIS.rU_BufferBat1 := IN_AG.tU_BufferBat1.Ai;
	MM2VIS.rU_BufferBat2 := IN_AG.tU_BufferBat2.Ai;
	
	MM2VIS.bStarterBat_UnderTest   := bStarterBat_Disconnect;
	MM2VIS.bBufferBat_UnderTest[1] := OUT_AG.tBufferBat1_Disconnect.Do;
	MM2VIS.bBufferBat_UnderTest[2] := OUT_AG.tBufferBat2_Disconnect.Do;
	
	FOR iIdx_CtrlBat := 1 TO iNum_CtrlBatMon DO
		MM2VIS.rU_CtrlBat[iIdx_CtrlBat]				:=	IN_AG.tU_CtrlBat[iIdx_CtrlBat].Ai;
		MM2VIS.sLocIdent_CtrlBatMon[iIdx_CtrlBat]	:=	IN_AG.sLocIdent_CtrlBatMon[iIdx_CtrlBat];
		MM2VIS.bCtrlBat_UnderTest[iIdx_CtrlBat]     :=  OUT_AG.tCtrlBat_Disconnect[iIdx_CtrlBat].Do;
	END_FOR;

	MM2VIS.bCtrlBat_Used                            :=  bCtrlBat_Used;
	MM2VIS.iNumActive_CtrlBatMon					:=	iNr_CtrlBat_Used;
	
	MM2VIS.bU_StarterBat_Exist						:=	FALSE;
	
	(* Oil leakage affected additional oil tank - A2361 assistant value *)
	IF 		NOT IN_AG.tLeak_OilExtensionTank1.Di THEN	MM2VIS.iLeak_OilExtensionTank := 1;
	ELSIF	NOT IN_AG.tLeak_OilExtensionTank2.Di THEN	MM2VIS.iLeak_OilExtensionTank := 2;
	ELSIF	NOT IN_AG.tLeak_OilExtensionTank3.Di THEN	MM2VIS.iLeak_OilExtensionTank := 3;
	ELSE												MM2VIS.iLeak_OilExtensionTank := 0;
	END_IF;
	
END_PROGRAM
