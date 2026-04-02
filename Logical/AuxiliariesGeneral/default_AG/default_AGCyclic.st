(*******************************************************************************
default		value set

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
Customized modifications: -
------------------------
 
History:
-------
V4.00.0	24.04.2012	lettenb.	new
		01.10.2014  			tEO_Level_Hi/Lo removed(setted for 2times) 
V4.00.1	29.01.2015  			920(stapelfeld) added
V4.03.0 29.07.2015	plattner	DayOil.. added
		13.10.2015	lettenb.	oiltank.. added
V4.04.0 09.05.2016				tCV_..., tL_OilSump3Hi added
		07.09.2016	Tinello		oil filter unit added
V4.06.0	19.06.2018	Perktold,	Louvers closed messages
V4.07.0 09.08.2018	Schmid		tCC2WP_Op added
		08.01.2019	Schmid		redundant pump control
		10.01.2019	Schmid		boiler failure and seismic alarm added
		25.02.2019	Stary/lett. bAuxRel_FireProtFlaps: FireProtFlap feedback signals included in aux.release, safety case
V4.10.0 26.05.2020	Schmid		tECWP_CB_On added		
		24.11.2020	lettenb.	grid config.monitoring added
		18.01.2021	Schmid		sensors for leakage detection in additional external oil tank
V4.11.0 17.12.2021	Schmid		control battery check
		17.01.2022	lettenb.	tInAirER_Lou1/2, tOutAirER_Lou removed, bugfix
V4.14.0 11.04.2025	Tinello		SAFETY related:	tSafetyLoop_EmStop and tSafetyLoop_Eng added to get rid of problems during simulation
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	IN_AG.tSafetyLoop_EmStop.Di		:=	IN_AG.tSafetyLoop_EmStop.Di		OR  NOT IN_AG.tSafetyLoop_EmStop.GoodQual; 	(* SAFETY PLC *)
	IN_AG.tSafetyLoop_Eng.Di		:=	IN_AG.tSafetyLoop_Eng.Di		OR  NOT IN_AG.tSafetyLoop_Eng.GoodQual; 	(* SAFETY PLC *)
	IN_AG.tL_ECW_Lo.Di				:=	IN_AG.tL_ECW_Lo.Di				OR	NOT IN_AG.tL_ECW_Lo.GoodQual;
	IN_AG.tL_ECW_LoLo.Di			:=	IN_AG.tL_ECW_LoLo.Di			OR	NOT IN_AG.tL_ECW_LoLo.GoodQual;
	IN_AG.tCP_CBTrip.Di				:=	IN_AG.tCP_CBTrip.Di				OR	NOT IN_AG.tCP_CBTrip.GoodQual;
	IN_AG.tIFCP_CBTrip.Di			:=	IN_AG.tIFCP_CBTrip.Di			OR	NOT IN_AG.tIFCP_CBTrip.GoodQual;
	IN_AG.tMCP_CBTrip.Di			:=	IN_AG.tMCP_CBTrip.Di			OR	NOT IN_AG.tMCP_CBTrip.GoodQual;
	IN_AG.tU_StarterBat_Lo.Di		:=	IN_AG.tU_StarterBat_Lo.Di		OR	NOT IN_AG.tU_StarterBat_Lo.GoodQual;
	IN_AG.tL_WasteOilTank_Hi.Di		:=	IN_AG.tL_WasteOilTank_Hi.Di		OR	NOT IN_AG.tL_WasteOilTank_Hi.GoodQual;
	IN_AG.tAuxOverVoltProt_Ok.Di	:=	IN_AG.tAuxOverVoltProt_Ok.Di	OR	NOT IN_AG.tAuxOverVoltProt_Ok.GoodQual;
	IN_AG.tUPS_Ok.Di				:=	IN_AG.tUPS_Ok.Di				OR	NOT IN_AG.tUPS_Ok.GoodQual;
	IN_AG.tT_AirIFCP_Hi.Di			:=	IN_AG.tT_AirIFCP_Hi.Di			OR	NOT IN_AG.tT_AirIFCP_Hi.GoodQual;

	IN_AG.tAuxV_Eng_ok.Di			:=	IN_AG.tAuxV_Eng_ok.Di			OR	NOT IN_AG.tAuxV_Eng_ok.GoodQual;
	IN_AG.tEOP1AC_CB_trip.Di		:=	IN_AG.tEOP1AC_CB_trip.Di		OR	NOT IN_AG.tEOP1AC_CB_trip.GoodQual;
	IN_AG.tFS_ECW.Di				:=	IN_AG.tFS_ECW.Di				OR	NOT IN_AG.tFS_ECW.GoodQual;
	IN_AG.tGT1_SafeDevOK.Di			:=	IN_AG.tGT1_SafeDevOK.Di			OR	NOT IN_AG.tGT1_SafeDevOK.GoodQual;
	IN_AG.tGT2_SafeDevOK.Di			:=	IN_AG.tGT2_SafeDevOK.Di			OR	NOT IN_AG.tGT2_SafeDevOK.GoodQual;
	IN_AG.tRelAuxNoMon.Di			:=	IN_AG.tRelAuxNoMon.Di			OR	NOT IN_AG.tRelAuxNoMon.GoodQual;
	IN_AG.tMainsStartDevOk.Di		:=	IN_AG.tMainsStartDevOk.Di		OR	NOT IN_AG.tMainsStartDevOk.GoodQual;
	IN_AG.tEO_Level_Hi.Di			:=	IN_AG.tEO_Level_Hi.Di			OR	NOT IN_AG.tEO_Level_Hi.GoodQual;
	IN_AG.tEO_Level_Lo.Di			:=	IN_AG.tEO_Level_Lo.Di			OR	NOT IN_AG.tEO_Level_Lo.GoodQual;
	IN_AG.tCDP_Op.Di				:=	IN_AG.tCDP_Op.Di				OR	NOT IN_AG.tCDP_Op.GoodQual;
	IN_AG.tEOP_Op.Di				:=	IN_AG.tEOP_Op.Di				OR	NOT IN_AG.tEOP_Op.GoodQual;
	IN_AG.tGasAlarm.Di				:=	IN_AG.tGasAlarm.Di				OR	NOT IN_AG.tGasAlarm.GoodQual;
	IN_AG.tGasPreAlarm.Di			:=	IN_AG.tGasPreAlarm.Di			OR	NOT IN_AG.tGasPreAlarm.GoodQual;
	IN_AG.tFireAlarm.Di				:=	IN_AG.tFireAlarm.Di				OR	NOT IN_AG.tFireAlarm.GoodQual;
	IN_AG.tRelMainGVext.Di			:=	IN_AG.tRelMainGVext.Di			OR	NOT IN_AG.tRelMainGVext.GoodQual;
	IN_AG.tMainsStartDevFail.Di		:=	IN_AG.tMainsStartDevFail.Di		OR	NOT IN_AG.tMainsStartDevFail.GoodQual;
	IN_AG.tU_StarterBat_Lo.Di		:=	IN_AG.tU_StarterBat_Lo.Di		OR	NOT IN_AG.tU_StarterBat_Lo.GoodQual;
	IN_AG.tECWP_FC_Rdy.Di			:=	IN_AG.tECWP_FC_Rdy.Di			OR	NOT IN_AG.tECWP_FC_Rdy.GoodQual;
	IN_AG.tEOP_FC_Rdy.Di			:=	IN_AG.tEOP_FC_Rdy.Di			OR	NOT IN_AG.tEOP_FC_Rdy.GoodQual;
	IN_AG.tAuxFail.Di				:=	IN_AG.tAuxFail.Di				OR	NOT IN_AG.tAuxFail.GoodQual;
	IN_AG.tTransformerTrip.Di		:=	IN_AG.tTransformerTrip.Di		OR	NOT IN_AG.tTransformerTrip.GoodQual;
	IN_AG.tTransformerWarning.Di	:=	IN_AG.tTransformerWarning.Di	OR	NOT IN_AG.tTransformerWarning.GoodQual;
	IN_AG.tSafetyLoop_Gas.Di		:=	IN_AG.tSafetyLoop_Gas.Di		OR	NOT IN_AG.tSafetyLoop_Gas.GoodQual;
	IN_AG.tSafetyLoop_HWC.Di		:=	IN_AG.tSafetyLoop_HWC.Di		OR	NOT IN_AG.tSafetyLoop_HWC.GoodQual;
	IN_AG.tL_OilSumpHi.Di			:=	IN_AG.tL_OilSumpHi.Di			OR	NOT IN_AG.tL_OilSumpHi.GoodQual;
	IN_AG.tL_OilSump2Hi.Di			:=	IN_AG.tL_OilSump2Hi.Di			OR	NOT IN_AG.tL_OilSump2Hi.GoodQual;
	IN_AG.tL_OilSump3Hi.Di			:=	IN_AG.tL_OilSump3Hi.Di			OR	NOT IN_AG.tL_OilSump3Hi.GoodQual;

	IN_AG.tEOF_DiffMax.Di 			:= IN_AG.tEOF_DiffMax.Di 			OR NOT IN_AG.tEOF_DiffMax.GoodQual;	
    IN_AG.tPr_TCOF_EOF_DiffMax.Di 	:= IN_AG.tPr_TCOF_EOF_DiffMax.Di 	OR NOT IN_AG.tPr_TCOF_EOF_DiffMax.GoodQual;
 	IN_AG.tPr_EO_Gear_Min.Di		:= IN_AG.tPr_EO_Gear_Min.Di 		OR NOT IN_AG.tPr_EO_Gear_Min.GoodQual;
	IN_AG.tT_EO_Gear_Max.Di			:= IN_AG.tT_EO_Gear_Max.Di			OR NOT IN_AG.tT_EO_Gear_Max.GoodQual;
	IN_AG.tEO_Supply_Fail.Di		:= IN_AG.tEO_Supply_Fail.Di			OR NOT IN_AG.tEO_Supply_Fail.GoodQual;

	IN_AG.tCO_Alarm.Di				:= IN_AG.tCO_Alarm.Di				OR NOT IN_AG.tCO_Alarm.GoodQual;
	IN_AG.tCO_PreAlarm.Di			:= IN_AG.tCO_PreAlarm.Di			OR NOT IN_AG.tCO_PreAlarm.GoodQual;
	IN_AG.tAuxErrWarn.Di			:= IN_AG.tAuxErrWarn.Di				OR NOT IN_AG.tAuxErrWarn.GoodQual;
	IN_AG.tActFiltAlarm.Di			:= IN_AG.tActFiltAlarm.Di			OR NOT IN_AG.tActFiltAlarm.GoodQual;
	IN_AG.tActFiltWarn.Di			:= IN_AG.tActFiltWarn.Di			OR NOT IN_AG.tActFiltWarn.GoodQual;
	IN_AG.tL_InMa_NotHi.Di			:= IN_AG.tL_InMa_NotHi.Di			OR NOT IN_AG.tL_InMa_NotHi.GoodQual;

	IN_AG.tECWP_Op.Di				:= IN_AG.tECWP_Op.Di				OR NOT IN_AG.tECWP_Op.GoodQual;
	IN_AG.tEngTurn.Di				:= IN_AG.tEngTurn.Di				OR NOT IN_AG.tEngTurn.GoodQual;
	IN_AG.tTCOP_CB_On.Di			:= IN_AG.tTCOP_CB_On.Di				OR NOT IN_AG.tTCOP_CB_On.GoodQual;
	IN_AG.tTCOP_UPS_CB_On.Di		:= IN_AG.tTCOP_UPS_CB_On.Di			OR NOT IN_AG.tTCOP_UPS_CB_On.GoodQual;
	IN_AG.tECWP_CB_On.Di			:= IN_AG.tECWP_CB_On.Di				OR NOT IN_AG.tECWP_CB_On.GoodQual;
	IN_AG.tECWP_PreH_CB_On.Di		:= IN_AG.tECWP_PreH_CB_On.Di		OR NOT IN_AG.tECWP_PreH_CB_On.GoodQual;
	IN_AG.tChUnit1_CB_On.Di			:= IN_AG.tChUnit1_CB_On.Di			OR NOT IN_AG.tChUnit1_CB_On.GoodQual;
	IN_AG.tChUnit2_CB_On.Di			:= IN_AG.tChUnit2_CB_On.Di			OR NOT IN_AG.tChUnit2_CB_On.GoodQual;
	IN_AG.tChUnit3_CB_On.Di			:= IN_AG.tChUnit3_CB_On.Di			OR NOT IN_AG.tChUnit3_CB_On.GoodQual;
	IN_AG.tChUnit4_CB_On.Di			:= IN_AG.tChUnit4_CB_On.Di			OR NOT IN_AG.tChUnit4_CB_On.GoodQual;
	IN_AG.tPS_EI_CB_On.Di			:= IN_AG.tPS_EI_CB_On.Di			OR NOT IN_AG.tPS_EI_CB_On.GoodQual;
	IN_AG.tSTT_CB_On.Di				:= IN_AG.tSTT_CB_On.Di				OR NOT IN_AG.tSTT_CB_On.GoodQual;
	IN_AG.tENGIA_CB_On.Di			:= IN_AG.tENGIA_CB_On.Di			OR NOT IN_AG.tENGIA_CB_On.GoodQual;
	IN_AG.tECWP_Service_CB_On.Di	:= IN_AG.tECWP_Service_CB_On.Di		OR NOT IN_AG.tECWP_Service_CB_On.GoodQual;
	IN_AG.tPS400V_ENGIA_CB_On.Di	:= IN_AG.tPS400V_ENGIA_CB_On.Di		OR NOT IN_AG.tPS400V_ENGIA_CB_On.GoodQual;
	IN_AG.tUPS_CB_On.Di				:= IN_AG.tUPS_CB_On.Di				OR NOT IN_AG.tUPS_CB_On.GoodQual;
	IN_AG.tENGIA_UPS_CB_On.Di		:= IN_AG.tENGIA_UPS_CB_On.Di		OR NOT IN_AG.tENGIA_UPS_CB_On.GoodQual;
	IN_AG.tCV_Eng_Low.Di			:= IN_AG.tCV_Eng_Low.Di				OR NOT IN_AG.tCV_Eng_Low.GoodQual;
	IN_AG.tCV_TCA_Low.Di			:= IN_AG.tCV_TCA_Low.Di				OR NOT IN_AG.tCV_TCA_Low.GoodQual;
	IN_AG.tCV_MCP_Low.Di			:= IN_AG.tCV_MCP_Low.Di				OR NOT IN_AG.tCV_MCP_Low.GoodQual;

	IN_AG.tBbBlower_FC_Rdy.Di		:= IN_AG.tBbBlower_FC_Rdy.Di		OR NOT IN_AG.tBbBlower_FC_Rdy.GoodQual;
	
	IN_AG.tAuxV_ModIf_ok.Di			:= IN_AG.tAuxV_ModIf_ok.Di			OR NOT IN_AG.tAuxV_ModIf_ok.GoodQual;
	IN_AG.tAuxV_Aux_ok.Di			:= IN_AG.tAuxV_Aux_ok.Di			OR NOT IN_AG.tAuxV_Aux_ok.GoodQual;
	IN_AG.tL_DayOilSump_Hi.Di		:= IN_AG.tL_DayOilSump_Hi.Di		OR NOT IN_AG.tL_DayOilSump_Hi.GoodQual;
	IN_AG.tDayOilTank_Leck.Di		:= IN_AG.tDayOilTank_Leck.Di		OR NOT IN_AG.tDayOilTank_Leck.GoodQual;
	IN_AG.tL_DayOilTank_Hi.Di		:= IN_AG.tL_DayOilTank_Hi.Di		OR NOT IN_AG.tL_DayOilTank_Hi.GoodQual;

	IN_AG.tL_FreshOilTank_Hi.Di		:= IN_AG.tL_FreshOilTank_Hi.Di		OR NOT IN_AG.tL_FreshOilTank_Hi.GoodQual;
	IN_AG.tOF_FreshOilTank.Di		:= IN_AG.tOF_FreshOilTank.Di		OR NOT IN_AG.tOF_FreshOilTank.GoodQual;
	IN_AG.tLeak_FreshOilPump.Di		:= IN_AG.tLeak_FreshOilPump.Di		OR NOT IN_AG.tLeak_FreshOilPump.GoodQual;
	IN_AG.tLeak_FreshOilTank.Di		:= IN_AG.tLeak_FreshOilTank.Di		OR NOT IN_AG.tLeak_FreshOilTank.GoodQual;
	IN_AG.tOF_WasteOilTank.Di		:= IN_AG.tOF_WasteOilTank.Di		OR NOT IN_AG.tOF_WasteOilTank.GoodQual;
	IN_AG.tLeak_WasteOilPump.Di		:= IN_AG.tLeak_WasteOilPump.Di		OR NOT IN_AG.tLeak_WasteOilPump.GoodQual;
	IN_AG.tLeak_WasteOilTank.Di		:= IN_AG.tLeak_WasteOilTank.Di		OR NOT IN_AG.tLeak_WasteOilTank.GoodQual;
	IN_AG.tGF_OilSystem.Di			:= IN_AG.tGF_OilSystem.Di			OR NOT IN_AG.tGF_OilSystem.GoodQual;

	IN_AG.tCV_GENI_Ok.Di			:= IN_AG.tCV_GENI_Ok.Di				OR NOT IN_AG.tCV_GENI_Ok.GoodQual;
	IN_AG.tCV_ENGIB_Ok.Di			:= IN_AG.tCV_ENGIB_Ok.Di			OR NOT IN_AG.tCV_ENGIB_Ok.GoodQual;
	IN_AG.tCV_TCMI_Ok.Di			:= IN_AG.tCV_TCMI_Ok.Di				OR NOT IN_AG.tCV_TCMI_Ok.GoodQual;
	IN_AG.tCV_TCUS_Ok.Di			:= IN_AG.tCV_TCUS_Ok.Di				OR NOT IN_AG.tCV_TCUS_Ok.GoodQual;
	IN_AG.tCV_JWMI_Ok.Di			:= IN_AG.tCV_JWMI_Ok.Di				OR NOT IN_AG.tCV_JWMI_Ok.GoodQual;
	IN_AG.tCV_OILMI_Ok.Di			:= IN_AG.tCV_OILMI_Ok.Di			OR NOT IN_AG.tCV_OILMI_Ok.GoodQual;
	IN_AG.tCV_M_Ok.Di				:= IN_AG.tCV_M_Ok.Di				OR NOT IN_AG.tCV_M_Ok.GoodQual;
	IN_AG.tCV_A_Ok.Di				:= IN_AG.tCV_A_Ok.Di				OR NOT IN_AG.tCV_A_Ok.GoodQual;
	IN_AG.tCV_AUX_Ok[1].Di			:= IN_AG.tCV_AUX_Ok[1].Di			OR NOT IN_AG.tCV_AUX_Ok[1].GoodQual;
	IN_AG.tCV_AUX_Ok[2].Di			:= IN_AG.tCV_AUX_Ok[2].Di			OR NOT IN_AG.tCV_AUX_Ok[2].GoodQual;
	IN_AG.tCV_AUX_Ok[3].Di			:= IN_AG.tCV_AUX_Ok[3].Di			OR NOT IN_AG.tCV_AUX_Ok[3].GoodQual;
	IN_AG.tCV_AUX_Ok[4].Di			:= IN_AG.tCV_AUX_Ok[4].Di			OR NOT IN_AG.tCV_AUX_Ok[4].GoodQual;
	IN_AG.tCV_AUX_Ok[5].Di			:= IN_AG.tCV_AUX_Ok[5].Di			OR NOT IN_AG.tCV_AUX_Ok[5].GoodQual;

	IN_AG.tOFUP_Centrifuge_CB.Di	:= IN_AG.tOFUP_Centrifuge_CB.Di		OR NOT IN_AG.tOFUP_Centrifuge_CB.GoodQual;
	IN_AG.tOFUP_Filter_CB.Di		:= IN_AG.tOFUP_Filter_CB.Di			OR NOT IN_AG.tOFUP_Filter_CB.GoodQual;

	IN_AG.tBoilerFailure.Di			:= IN_AG.tBoilerFailure.Di			OR NOT IN_AG.tBoilerFailure.GoodQual;
	IN_AG.tSeismicAlarm.Di			:= IN_AG.tSeismicAlarm.Di			OR NOT IN_AG.tSeismicAlarm.GoodQual;

	(* redundant pump options *)
	IF NOT Para.bRedHWP_Active THEN		IN_AG.tHWP_Op.Di	:=	IN_AG.tHWP_Op.Di	OR	NOT IN_AG.tHWP_Op.GoodQual;
	ELSE								IN_AG.tHWP_Op.Di	:=	IN_AG.tHWP1_Op.Di	OR		IN_AG.tHWP2_Op.Di;
	END_IF;

	IF NOT Para.bRedCCWP_Active THEN	IN_AG.tCCWP_Op.Di	:=	IN_AG.tCCWP_Op.Di	OR	NOT IN_AG.tCCWP_Op.GoodQual;
	ELSE								IN_AG.tCCWP_Op.Di	:=	IN_AG.tCCWP1_Op.Di	OR		IN_AG.tCCWP2_Op.Di;
	END_IF;
	
	IF NOT Para.bRedCC2WP_Active THEN	IN_AG.tCC2WP_Op.Di	:=	IN_AG.tCC2WP_Op.Di	OR	NOT IN_AG.tCC2WP_Op.GoodQual;
	ELSE								IN_AG.tCC2WP_Op.Di	:=	IN_AG.tCC2WP1_Op.Di	OR		IN_AG.tCC2WP2_Op.Di;
	END_IF;

	IF NOT Para.bRedEmCWP_Active THEN	IN_AG.tEmCWP_Op.Di	:=	IN_AG.tEmCWP_Op.Di	OR	NOT IN_AG.tEmCWP_Op.GoodQual;
	ELSE								IN_AG.tEmCWP_Op.Di	:=	IN_AG.tEmCWP1_Op.Di	OR		IN_AG.tEmCWP2_Op.Di;
	END_IF;


	IF NOT IN_AG.tOutAirER_LouClosed.GoodQual THEN
		IN_AG.tOutAirER_LouClosed.Di  :=	TRUE;
	END_IF;
	IF NOT IN_AG.tInAirER_Lou1Closed.GoodQual THEN
		IN_AG.tInAirER_Lou1Closed.Di  :=	TRUE;
	END_IF;
	IF NOT IN_AG.tInAirER_Lou2Closed.GoodQual THEN
		IN_AG.tInAirER_Lou2Closed.Di  :=	TRUE;
	END_IF;

	IN_AG.tFireProtFlap1_InlAir_Opened.Di  := IN_AG.tFireProtFlap1_InlAir_Opened.Di  OR NOT IN_AG.tFireProtFlap1_InlAir_Opened.GoodQual;
	IN_AG.tFireProtFlap2_InlAir_Opened.Di  := IN_AG.tFireProtFlap2_InlAir_Opened.Di  OR NOT IN_AG.tFireProtFlap2_InlAir_Opened.GoodQual;
	IN_AG.tFireProtFlap1_OutlAir_Opened.Di := IN_AG.tFireProtFlap1_OutlAir_Opened.Di OR NOT IN_AG.tFireProtFlap1_OutlAir_Opened.GoodQual;
	IN_AG.tFireProtFlap2_OutlAir_Opened.Di := IN_AG.tFireProtFlap2_OutlAir_Opened.Di OR NOT IN_AG.tFireProtFlap2_OutlAir_Opened.GoodQual;
	IN_AG.tFireProtFlap1_InlAir_Closed.Di  := IN_AG.tFireProtFlap1_InlAir_Closed.Di  OR NOT IN_AG.tFireProtFlap1_InlAir_Closed.GoodQual;
	IN_AG.tFireProtFlap2_InlAir_Closed.Di  := IN_AG.tFireProtFlap2_InlAir_Closed.Di  OR NOT IN_AG.tFireProtFlap2_InlAir_Closed.GoodQual;
	IN_AG.tFireProtFlap1_OutlAir_Closed.Di := IN_AG.tFireProtFlap1_OutlAir_Closed.Di OR NOT IN_AG.tFireProtFlap1_OutlAir_Closed.GoodQual;
	IN_AG.tFireProtFlap2_OutlAir_Closed.Di := IN_AG.tFireProtFlap2_OutlAir_Closed.Di OR NOT IN_AG.tFireProtFlap2_OutlAir_Closed.GoodQual;

	IN_AG.tMCP_AuxPS_CB_Trip.Di		:= IN_AG.tMCP_AuxPS_CB_Trip.Di		OR NOT IN_AG.tMCP_AuxPS_CB_Trip.GoodQual;
	IN_AG.tMCP_AuxPS_CB_On.Di		:= IN_AG.tMCP_AuxPS_CB_On.Di		OR NOT IN_AG.tMCP_AuxPS_CB_On.GoodQual;
	IN_AG.tMCP_AuxPS_GndFault.Di	:= IN_AG.tMCP_AuxPS_GndFault.Di		OR NOT IN_AG.tMCP_AuxPS_GndFault.GoodQual;
	IN_AG.tMCP_FC_GndFault.Di		:= IN_AG.tMCP_FC_GndFault.Di		OR NOT IN_AG.tMCP_FC_GndFault.GoodQual;
	IN_AG.tMIP_FC_GndFault.Di		:= IN_AG.tMIP_FC_GndFault.Di		OR NOT IN_AG.tMIP_FC_GndFault.GoodQual;
	IN_AG.tAuxCP_FC_GndFault.Di		:= IN_AG.tAuxCP_FC_GndFault.Di		OR NOT IN_AG.tAuxCP_FC_GndFault.GoodQual;
	IN_AG.tAuxCP_AuxPS_GndFault.Di	:= IN_AG.tAuxCP_AuxPS_GndFault.Di	OR NOT IN_AG.tAuxCP_AuxPS_GndFault.GoodQual;
	IN_AG.tAuxCP_AuxPS_CB_Trip.Di	:= IN_AG.tAuxCP_AuxPS_CB_Trip.Di	OR NOT IN_AG.tAuxCP_AuxPS_CB_Trip.GoodQual;
	IN_AG.tAuxCP_AuxPS_CB_On.Di		:= IN_AG.tAuxCP_AuxPS_CB_On.Di		OR NOT IN_AG.tAuxCP_AuxPS_CB_On.GoodQual;
	
	IN_AG.tBatChargeDev_Ok.Di		:= IN_AG.tBatChargeDev_Ok.Di		OR NOT IN_AG.tBatChargeDev_Ok.GoodQual;
	FOR iIdx_CtrlBat := 1 TO iNum_CtrlBatMon DO
		IN_AG.tCtrlBat_ChargeDev_Ok[iIdx_CtrlBat].Di	:=	IN_AG.tCtrlBat_ChargeDev_Ok[iIdx_CtrlBat].Di	OR NOT IN_AG.tCtrlBat_ChargeDev_Ok[iIdx_CtrlBat].GoodQual;
	END_FOR;
	
	IN_AG.tLeak_OilExtensionTank1.Di	:= IN_AG.tLeak_OilExtensionTank1.Di	OR NOT IN_AG.tLeak_OilExtensionTank1.GoodQual;
	IN_AG.tLeak_OilExtensionTank2.Di	:= IN_AG.tLeak_OilExtensionTank2.Di	OR NOT IN_AG.tLeak_OilExtensionTank2.GoodQual;
	IN_AG.tLeak_OilExtensionTank3.Di	:= IN_AG.tLeak_OilExtensionTank3.Di	OR NOT IN_AG.tLeak_OilExtensionTank3.GoodQual;

//	IN_AG.x.Di		:=	IN_AG.x.Di		OR	NOT IN_AG.x.GoodQual;

END_PROGRAM
