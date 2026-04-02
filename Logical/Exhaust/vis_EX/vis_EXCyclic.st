(*******************************************************************************
vis		visualization

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V4.00.0	25.04.2012	lettenb.	new
V4.00.1	25.04.2012	lettenb.	MM2VIS.tN2_ScavSigLampOn added
V4.00.2	23.01.2015				920(stapelfeld) added
V4.03.0	29.07.2015	plattner	rPr_Diff_ExG... added
		07.08.2015  Denk		Manual operating auxiliaries control functionality added
V4.05.0	22.05.2017	TinelloM	SCR deleted
		12.07.2017	Messner		Scavenging Valve Temperature Sensor added
		04.12.2017	Messner		Oxidation catalyst added
V4.07.0	13.05.2019	lettenb.	MM2VIS.rT_EGaTC: average value to existing bus interface #505
V4.09.0	02.08.2019	lettenb.	temperature exhaust gas pressure relief valve 1/2 added
V4.14.0	16.10.2024	VighM		Fast exhaust pressure value for visualisation added
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC


	IF Para.bT_EGaLPTC_A_Active AND Para.bT_EGaLPTC_B_Active THEN
			MM2VIS.rT_EGaTC	:=  OUT_EX.rT_EGaLPTC_Avg; (* average value to existing bus interface #505 *)
	ELSE	MM2VIS.rT_EGaTC	:=	IN_EX.tT_EGaTC.Ai;
	END_IF;

	MM2VIS.rT_EGaHE			:=	IN_EX.tT_EGaHE.Ai;
	MM2VIS.rT_PlateHE		:=	IN_EX.tT_PlateHE.Ai;
	MM2VIS.rT_EGbTC			:=	IN_EX.tT_EGbTC.Ai;

	MM2VIS.rT_EGaLPTC_A		:=	IN_EX.tT_EGaLPTC_A.Ai;
	MM2VIS.rT_EGaLPTC_B		:=	IN_EX.tT_EGaLPTC_B.Ai;
	MM2VIS.rT_EGbHPTC_A		:=	IN_EX.tT_EGbHPTC_A.Ai;
	MM2VIS.rT_EGbHPTC_B		:=	IN_EX.tT_EGbHPTC_B.Ai;
	MM2VIS.rT_EGaHPTC_A		:=	IN_EX.tT_EGaHPTC_A.Ai;
	MM2VIS.rT_EGaHPTC_B		:=	IN_EX.tT_EGaHPTC_B.Ai;
	MM2VIS.rPr_EGbHPTC_A	:=	IN_EX.tPr_EGbHPTC_A.Ai;
	MM2VIS.rPr_EGbHPTC_B	:=	IN_EX.tPr_EGbHPTC_B.Ai;
	MM2VIS.rPr_EGaHPTC_A	:=	IN_EX.tPr_EGaHPTC_A.Ai;
	MM2VIS.rPr_EGaHPTC_B	:=	IN_EX.tPr_EGaHPTC_B.Ai;
	MM2VIS.rPr_EGaLPTC_A	:=	IN_EX.tPr_EGaLPTC_A.Ai;	
	MM2VIS.rPr_EGaLPTC_B	:=	IN_EX.tPr_EGaLPTC_B.Ai;	

	(* scavenging *)
	MM2VIS.bScavVaOpened	:=	IN_EX.tScavVaOpened.Di;
	MM2VIS.bScavFanCoOn		:=	OUT_EX.tScavFanCoOn.Do;
	MM2VIS.bN2_ScavGV_CoOpen:=	OUT_EX.tN2_ScavGV_CoOpen.Do;
	MM2VIS.bN2_ScavSigLampOn:=	OUT_EX.tN2_ScavSigLampOn.Do;
	MM2VIS.rT_bScavValve	:= 	IN_EX.tT_bScavValve.Ai;
	
	(* exhaust gas valves *)
	IF (IN_EX.tManAuxCtr.bGnl_Rel = TRUE) THEN
		MM2VIS.bEG_BoVaOpened	:=	IN_EX.tEG_BoVaOpened.Di;
		MM2VIS.bEG_ByVaOpened	:=	IN_EX.tEG_ByVaOpened.Di;
	ELSE
		MM2VIS.bEG_BoVaOpened	:=	OUT_EX.bEG_BoVaOpened;
		MM2VIS.bEG_ByVaOpened	:=	OUT_EX.bEG_ByVaOpened;
								Para.bEG_BoVa_Visible;	(* for vis *)
								Para.bEG_ByVa_Visible;	(* for vis *)
	END_IF;	
	
	(* codinox *)
	MM2VIS.bCodinox_Rdy	    :=	IN_EX.tCodinox_Rdy.Di;
	MM2VIS.bCO2_VaOpened	:=	IN_EX.tCO2_VaOpened.Di;
	MM2VIS.bCO2_FanCoOn		:=	OUT_EX.tCO2_FanCoOn.Do;	
	MM2VIS.bT_EGaHE1_Active	:=	Para.bCodinox_Active OR NOT Para.bT_EGaHE1_Active; (* 0=visible *)
	MM2VIS.rT_EGaHE1		:=	IN_EX.tT_EGaHE1.Ai;
	MM2VIS.bT_EGaHE2_Active	:=	Para.bCodinox_Active OR NOT Para.bT_EGaHE2_Active;        
	MM2VIS.rT_EGaHE2		:=	IN_EX.tT_EGaHE2.Ai;	

	MM2VIS.rPr_Diff_ExGFilter		:=	IN_EX.tPr_Diff_ExGFilter.Ai;	
	MM2VIS.rPr_Diff_ExGCooler		:=  IN_EX.tPr_Diff_ExGCooler.Ai;
	
	(* OXIcat *)
	MM2VIS.rT_EGbCat		:= IN_EX.tT_EGbCat.Ai;
	MM2VIS.rT_EGaCat		:= IN_EX.tT_EGaCat.Ai;
	MM2VIS.rPr_OXIcat_In 	:= IN_EX.tPr_OXIcat_In.Ai;
	MM2VIS.rPr_OXIcat_Diff 	:= IN_EX.tPr_OXIcat_In.Ai - IN_EX.tPr_OXIcat_Out.Ai;

	MM2VIS.rT_EG_PrReliefVa1	:= IN_EX.tT_EG_PrReliefVa1.Ai;
	MM2VIS.rT_EG_PrReliefVa2	:= IN_EX.tT_EG_PrReliefVa2.Ai;

	(* fast exhaust pressure sensor *)
	MM2VIS.rPr_OXIcat_In_Fast := IN_EX.tPr_EG_Deflag_Fast_TC1.Ai;
END_PROGRAM
