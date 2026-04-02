(***************************************************************************
AuxGnl			auxiliaries general, different outputs  

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	10.07.1998 Pa			erstellt
 		24.11.1998 Pa			korrekturlesung
V170	08.03.2002 LH			Anforderung Netzstartgerät
 								Anforderung Entregung
 								Anforderung Lastabwurf
V180	21.03.2003 LH			Zuschaltung COSPHI-Regler geändert
V206	22.06.2004 LH			Freigabe Gemischregler über Parameter
V2071c	20.09.2005 LH			neu: Generator ohne Spannung
 								neu: Freigabe Spannungsanwahl LS-Generator
V2072	16.11.2005 LH			Grenzwert Generatorspannung auf Prozent Nennspannung bezogen
V190	14.04.2004 LH			Anforderung Lastabwurf angepasst
 		06.06.2006 LH			neu: Spannungsverstellung Generator
V2102	22.11.2006 LH			Lastabwurf durch Anforderung P-Reduktion im Inselbetrieb
 								GW Generatorspannung: 12,5% --> 30,0%
V212	16.10.2006 LH			Anpassungen für ESY-NEU
V220	19.02.2007 LH			E_LSHK nur noch für GSY aktiv
 								neu: Anforderung Heizwasserpumpe
 								neu: Quittierung Warnung
 		23.03.2007 LH			Aktivierung LSHK für CUN1 AvK-Generator (Plattner)
 		20.04.2007 LH			Eingabe Generator-Nennspannung --> settings 
 		11.05.2007 LH			keine Entregung mehr beim Abstellvorgang (Kruckenhauser)
V2201	04.06.2007 LH			Anforderung Heizwasserpumpe --> Heizwasserpumpe EIN
V2225	23.04.2008 LH			Erweiterungen für Pakistan
V2.34.0	14.10.2008 lettenb.		generator deexcitation A_ENTR: M_GEN_PT added
V2.50.0	28.01.2009 lettenb.		M_MMD_OL added
								DO_DMND_LS: M_BTRB added for PAK
V2.60.0	07.08.2009 lettenb.		FA_A_QUITT from VISA added
V3.10.0	07.08.2009 lettenb.		A_COSPHI: PAK removed (country specific selection removed/steiger joh.)
								FG_KT: AN_RLT_M added (demand cooling tower/steiger/pfister)
V3.20.0	30.09.2010 maier(BuR)	M_GSEIN replaced with GCB_ON
								NS_EIN replaced with MCB_ON
		07.12.2010 lettenb.		DO_A_QUITT, DO_W_QUITT moved to task reset
		07.02.2011				FG_HGV, FG_HGV_ext release main gas valve added (moved from task biogas)
V3.99.0 18.03.2013 pankajrodey	Logic for OUT_AG.tMainsStartDevDem.Do (demand mains start device) moved 
								from this task to EleStart task
V4.03.0 29.07.2015 plattner		condensor pump added
		07.08.2015 Denk			Manual operating auxiliaries control functionality added
		04.12.2015 lettenb.		OUT_AG.tGearPump_Dem.Do added (gruber)
V4.04.0 05.10.2016 Stary        added manual operating mode for engine room air outlet ventilation frequency converter setpoint (xManAuxCtr[17])
		15.11.2016 Stary		bugfix: used rER_OutlV_FC_Set instead of rER_OutlV_FC_Set_Man
V4.05.0 20.09.2017 Messner		Active Cooling Program added
V4.05.1	14.02.2018 Messner		Starter battery voltage monitoring
V4.07.0	09.08.2018 Schmid		2nd low temperature charge cooling circuit added
		08.01.2019 Schmid		redundant pump control added
		22.02.2019 Schmid		ManAuxCtr for hydraulic pre-heating added
		18.03.2019 Schmid		change to redundant pump control logic - new naming convention, new warning texts
		26.04.2019 Schmid		A1031 safety loop emergency stop push button AND A1054 fire alarm split on HW side - adaptations to preserve prior functionality
V4.09.0	05.07.2019 Schmidt		added failed TC post-cooling detection/counter
V4.10.0	20.08.2020 Schmid		bugfix failed TC post-cooling detection/counter - prevent double counting of events
		16.12.2020 Schmid		Battery test (starter and buffer batteries) function added
		23.12.2020 Schmid		ManAuxCtr for prelubrication pump added
V4.11.0	17.12.2021 Schmid		control battery check extension
V4.11.1	08.02.2022 Schmid		bugfixes control battery check extension
v4.12.0	07.03.2023 Tinello		Change of post lubrication
V4.14.0 17.10.2024 Racero		Buffer battery test logic adapted
V4.25.0	10.07.2025 Tinello	 	SafetyPLC: added release heating water pump from EG

Instructions for use:
--------------------
 - acc. network comments  

Outstandings:
------------
***************************************************************************)

PROGRAM _CYCLIC

	(* demand heat water pump *)
	OUT_AG.tHWP_Dem.Do		:= IN_AG.bEng_Aux_Dem_CDR AND NOT MM2VIS.bMsg1054 AND NOT IN_AG.bMsg1031 AND IN_AG.bRel_HWP_Dem; (* SAFETY PLC *)

	
	(* demand condensor pump *)
	OUT_AG.tCDP_Dem.Do := (IN_AG.bEng_Aux_Dem_CDR OR OUT_AG.tManAuxCtr.bCDP_Dem)	(* Manual operating auxiliaries control - Handbedienebene *)	 
						  AND NOT  MM2VIS.bMsg1053 
						  AND NOT  MM2VIS.bMsg1054 
						  AND NOT IN_AG.bMsg1031;
	
	
	(* release main gas valve *)
	(* logic for IN_AG.tRelMainGVext.Di have to be added customized if needed ! *)
	OUT_AG.tMainGV_Rel.Do := NOT  MM2VIS.bMsg1052 AND NOT  MM2VIS.bMsg1053 AND NOT  MM2VIS.bMsg1054 AND NOT IN_AG.bMsg1031 AND IN_AG.tRelMainGVext.Di;

	
	(* gear pump demand *)
	OUT_AG.tGearPump_Dem.Do := (IN_AG.bEng_Aux_Dem_CDR	OR M_DREHZ)
						AND NOT IN_AG.bMsg1019
						AND(NOT IN_AG.bMsg1031			OR M_DREHZ)
						AND(NOT MM2VIS.bMsg1054			OR M_DREHZ);	


	(* Manual operating auxiliaries control - Handbedienebene *)
	(* General release *)
	bManAuxCtr_GnlRel := 		Para.bManAuxCtr_Active
						AND 	IN_AG.tPB2MM.bParaSetupOk 
						AND 	bOMSS_Man	
						AND NOT IN_AG.bMsg1031
						AND NOT IN_AG.bMsg1056
						AND	NOT MM2VIS.bMsg1052
						AND NOT MM2VIS.bMsg1053
						AND NOT MM2VIS.bMsg1054
						AND NOT bTC_CoolDownRun
						AND NOT IN_AG.bEng_Aux_Dem_TOF;
	OUT_AG.tManAuxCtr.bGnl_Rel := bManAuxCtr_GnlRel;
	
	
	(* Engine preheating pump *)
	xManAuxCtr[1].GnlRel		:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bECWP_PreH_COf_Man;
	xManAuxCtr[1].VisuCmdButton := VIS2MM.tManAuxCtr.bECWP_PreH_COf;
	xManAuxCtr[1].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
	xManAuxCtr[1]();
	OUT_AG.tManAuxCtr.bECWP_PreH_COf := xManAuxCtr[1].COf;
	VIS2MM.tManAuxCtr.bECWP_PreH_COf := xManAuxCtr[1].COf;

	(* Engine preheating *)
	xManAuxCtr[2].GnlRel		:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bECW_PreH_COf_Man;
	xManAuxCtr[2].VisuCmdButton := VIS2MM.tManAuxCtr.bECW_PreH_COf;
	xManAuxCtr[2].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
	xManAuxCtr[2]();
	OUT_AG.tManAuxCtr.bECW_PreH_COf := xManAuxCtr[2].COf;
	VIS2MM.tManAuxCtr.bECW_PreH_COf := xManAuxCtr[2].COf;


	(* Air outlet louvre *)
	xManAuxCtr[3].GnlRel		:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bOutAirER_LouDemOpen_Man;
	xManAuxCtr[3].VisuCmdButton := VIS2MM.tManAuxCtr.bOutAirER_LouDemOpen;
	xManAuxCtr[3].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
	xManAuxCtr[3]();
	OUT_AG.tManAuxCtr.bOutAirER_LouDemOpen := xManAuxCtr[3].COn;
	VIS2MM.tManAuxCtr.bOutAirER_LouDemOpen := xManAuxCtr[3].COn;

	(* Air inlet louvre 1 *)
	xManAuxCtr[4].GnlRel		:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bInAirER_Lou1DemOpen_Man;
	xManAuxCtr[4].VisuCmdButton := VIS2MM.tManAuxCtr.bInAirER_Lou1DemOpen;
	xManAuxCtr[4].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
	xManAuxCtr[4]();
	OUT_AG.tManAuxCtr.bInAirER_Lou1DemOpen := xManAuxCtr[4].COn;
	VIS2MM.tManAuxCtr.bInAirER_Lou1DemOpen := xManAuxCtr[4].COn;

	(* Air inlet louvre 2 *)
	xManAuxCtr[5].GnlRel		:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bInAirER_Lou2DemOpen_Man;
	xManAuxCtr[5].VisuCmdButton := VIS2MM.tManAuxCtr.bInAirER_Lou2DemOpen;
	xManAuxCtr[5].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
	xManAuxCtr[5]();
	OUT_AG.tManAuxCtr.bInAirER_Lou2DemOpen := xManAuxCtr[5].COn;
	VIS2MM.tManAuxCtr.bInAirER_Lou2DemOpen := xManAuxCtr[5].COn;


	(* Air inlet fan 1 *)
	xManAuxCtr[6].GnlRel		:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bInAirER_Fan1DemOn_Man;
	xManAuxCtr[6].VisuCmdButton := VIS2MM.tManAuxCtr.bInAirER_Fan1DemOn;
	xManAuxCtr[6].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
	xManAuxCtr[6]();
	OUT_AG.tManAuxCtr.bInAirER_Fan1DemOn := xManAuxCtr[6].COn;
	VIS2MM.tManAuxCtr.bInAirER_Fan1DemOn := xManAuxCtr[6].COn;

	(* Air inlet fan 2 *)
	xManAuxCtr[7].GnlRel		:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bInAirER_Fan2DemOn_Man;
	xManAuxCtr[7].VisuCmdButton := VIS2MM.tManAuxCtr.bInAirER_Fan2DemOn;
	xManAuxCtr[7].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
	xManAuxCtr[7]();
	OUT_AG.tManAuxCtr.bInAirER_Fan2DemOn := xManAuxCtr[7].COn;
	VIS2MM.tManAuxCtr.bInAirER_Fan2DemOn := xManAuxCtr[7].COn;

	(* Engine room frequency converter setpoint *)
	xManAuxCtr[8].GnlRel		  := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bER_FC_Set_Man AND NOT bGnlTrip;		(* Solange die Störung Raumtemperatur max. ansteht soll die Raumlüftung auf 100% bleiben. Erst nach erfolgreicher Quittierung soll die Handbedienebeneneingabe wieder aktiviert werden.*)
	xManAuxCtr[8].VisuCmdSetpoint := VIS2MM.tManAuxCtr.rER_FC_Set;
	xManAuxCtr[8].MaxCmdTime 	  := Para.tiManAuxCtr_Max;
	xManAuxCtr[8]();
	OUT_AG.tManAuxCtr.bER_FC_Set := xManAuxCtr[8].COn;
	OUT_AG.tManAuxCtr.rER_FC_Set := xManAuxCtr[8].SetVal;
	IF (xManAuxCtr[8].COn = FALSE) THEN	VIS2MM.tManAuxCtr.rER_FC_Set := 0.0; END_IF;

	
	(* Emergency cooler demand pump *)
	xManAuxCtr[9].GnlRel		:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bEC_DemPump_Man AND NOT IN_AG.bMsg3404 AND NOT IN_AG.bMsg1019;
	xManAuxCtr[9].VisuCmdButton := VIS2MM.tManAuxCtr.bEC_DemPump;
	xManAuxCtr[9].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
	xManAuxCtr[9]();
	OUT_AG.tManAuxCtr.bEC_DemPump := xManAuxCtr[9].COn;
	VIS2MM.tManAuxCtr.bEC_DemPump := xManAuxCtr[9].COn;
	
	(* Emergency cooler demand fan 1 - 16 *)
	xManAuxCtr[10].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bEC_DemFan_Man AND NOT IN_AG.bMsg3404 AND NOT IN_AG.bMsg1019;
	xManAuxCtr[10].VisuCmdButton := VIS2MM.tManAuxCtr.bEC_DemFan;
	xManAuxCtr[10].MaxCmdTime    := Para.tiManAuxCtr_Max;
	xManAuxCtr[10]();
	OUT_AG.tManAuxCtr.bEC_DemFan := xManAuxCtr[10].COn;
	VIS2MM.tManAuxCtr.bEC_DemFan := xManAuxCtr[10].COn;
		

	(* Charge cooler demand pump *)
	xManAuxCtr[11].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bChC_DemPump_Man AND NOT IN_AG.bMsg1130 AND NOT IN_AG.bMsg2117;
	xManAuxCtr[11].VisuCmdButton := VIS2MM.tManAuxCtr.bChC_DemPump;
	xManAuxCtr[11].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[11]();
	OUT_AG.tManAuxCtr.bChC_DemPump := xManAuxCtr[11].COn;
	VIS2MM.tManAuxCtr.bChC_DemPump := xManAuxCtr[11].COn;
	
	(* Charge cooler demand fan 1 - 16 *)
	xManAuxCtr[12].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bChC_DemFan_Man;
	xManAuxCtr[12].VisuCmdButton := VIS2MM.tManAuxCtr.bChC_DemFan;
	xManAuxCtr[12].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[12]();
	OUT_AG.tManAuxCtr.bChC_DemFan := xManAuxCtr[12].COn;
	VIS2MM.tManAuxCtr.bChC_DemFan := xManAuxCtr[12].COn;
	

	(* Control signal Boiler valve open *)
	xManAuxCtr[13].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bEG_BoVaCoOpen_Man AND NOT IN_AG.tEG_BoVaOpened.Di AND NOT OUT_AG.tManAuxCtr.bEG_BoVaCoClose;
	xManAuxCtr[13].VisuCmdButton := VIS2MM.tManAuxCtr.bEG_BoVaCoOpen;
	xManAuxCtr[13].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[13]();
	OUT_AG.tManAuxCtr.bEG_BoVaCoOpen := xManAuxCtr[13].COn;
	VIS2MM.tManAuxCtr.bEG_BoVaCoOpen := xManAuxCtr[13].COn;	
	
	(* Control signal Boiler valve close *)
	xManAuxCtr[14].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bEG_BoVaCoOpen_Man AND NOT IN_AG.tEG_BoVaClosed.Di AND NOT OUT_AG.tManAuxCtr.bEG_BoVaCoOpen;
	xManAuxCtr[14].VisuCmdButton := VIS2MM.tManAuxCtr.bEG_BoVaCoClose;
	xManAuxCtr[14].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[14]();
	OUT_AG.tManAuxCtr.bEG_BoVaCoClose := xManAuxCtr[14].COn;
	VIS2MM.tManAuxCtr.bEG_BoVaCoClose := xManAuxCtr[14].COn;

	(* Control signal Bypass valve open *)
	xManAuxCtr[15].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bEG_ByVaCoOpen_Man AND NOT IN_AG.tEG_ByVaOpened.Di AND NOT OUT_AG.tManAuxCtr.bEG_ByVaCoClose;
	xManAuxCtr[15].VisuCmdButton := VIS2MM.tManAuxCtr.bEG_ByVaCoOpen;
	xManAuxCtr[15].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[15]();
	OUT_AG.tManAuxCtr.bEG_ByVaCoOpen := xManAuxCtr[15].COn;
	VIS2MM.tManAuxCtr.bEG_ByVaCoOpen := xManAuxCtr[15].COn;	
	
	(* Control signal Bypass valve close *)
	xManAuxCtr[16].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bEG_ByVaCoOpen_Man AND NOT IN_AG.tEG_ByVaClosed.Di AND NOT OUT_AG.tManAuxCtr.bEG_ByVaCoOpen;
	xManAuxCtr[16].VisuCmdButton := VIS2MM.tManAuxCtr.bEG_ByVaCoClose;
	xManAuxCtr[16].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[16]();
	OUT_AG.tManAuxCtr.bEG_ByVaCoClose := xManAuxCtr[16].COn;
	VIS2MM.tManAuxCtr.bEG_ByVaCoClose := xManAuxCtr[16].COn;
	
	(* Engine room air outlet ventilation frequency converter setpoint *)
	xManAuxCtr[17].GnlRel		  := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bER_OutlV_FC_Set_Man AND NOT bGnlTrip;		(* Solange die Störung Raumtemperatur max. ansteht soll die Raumlüftung auf 100% bleiben. Erst nach erfolgreicher Quittierung soll die Handbedienebeneneingabe wieder aktiviert werden.*)
	xManAuxCtr[17].VisuCmdSetpoint := VIS2MM.tManAuxCtr.rER_OutlV_FC_Set;
	xManAuxCtr[17].MaxCmdTime 	  := Para.tiManAuxCtr_Max;
	xManAuxCtr[17]();
	OUT_AG.tManAuxCtr.bER_OutlV_FC_Set := xManAuxCtr[17].COn;
	OUT_AG.tManAuxCtr.rER_OutlV_FC_Set_Man := xManAuxCtr[17].SetVal;
	IF (xManAuxCtr[17].COn = FALSE) THEN VIS2MM.tManAuxCtr.rER_OutlV_FC_Set := 0.0; END_IF;

	(* Charge cooler 2 demand pump *)
	xManAuxCtr[18].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bChC2_DemPump_Man AND NOT IN_AG.bMsg9226;
	xManAuxCtr[18].VisuCmdButton := VIS2MM.tManAuxCtr.bChC2_DemPump;
	xManAuxCtr[18].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[18]();
	OUT_AG.tManAuxCtr.bChC2_DemPump := xManAuxCtr[18].COn;
	VIS2MM.tManAuxCtr.bChC2_DemPump := xManAuxCtr[18].COn;

	(* Charge cooler 2 demand fan 1 - 16 *)
	xManAuxCtr[19].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bChC2_DemFan_Man;
	xManAuxCtr[19].VisuCmdButton := VIS2MM.tManAuxCtr.bChC2_DemFan;
	xManAuxCtr[19].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[19]();
	OUT_AG.tManAuxCtr.bChC2_DemFan := xManAuxCtr[19].COn;
	VIS2MM.tManAuxCtr.bChC2_DemFan := xManAuxCtr[19].COn;


	(* reserve auxiliary #1 - #40 *)
	FOR i:= 1 TO 40 BY 1 DO 
		xManAuxCtr[19+i].GnlRel		 	:= bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bAuxCust_Man[i];
		xManAuxCtr[19+i].VisuCmdButton 	:= VIS2MM.tManAuxCtr.bAuxCust[i];
		xManAuxCtr[19+i].MaxCmdTime 	:= Para.tiManAuxCtr_Max;
		xManAuxCtr[19+i]();
		OUT_AG.tManAuxCtr.bAuxCust[i] := xManAuxCtr[19+i].COn;
		VIS2MM.tManAuxCtr.bAuxCust[i] := xManAuxCtr[19+i].COn;
	END_FOR;


	(* Interventionsmodule NED/BEL *)
	(* Demand condensor pump *)
	xManAuxCtr[60].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bCDP_Dem_Man;
	xManAuxCtr[60].VisuCmdButton := VIS2MM.tManAuxCtr.bCDP_Dem;
	xManAuxCtr[60].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[60]();
	OUT_AG.tManAuxCtr.bCDP_Dem	 := xManAuxCtr[60].COn;
	VIS2MM.tManAuxCtr.bCDP_Dem 	 := xManAuxCtr[60].COn;

	(* Boiler house ventilation *)
	xManAuxCtr[61].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bBHV_Dem_Man;
	xManAuxCtr[61].VisuCmdButton := VIS2MM.tManAuxCtr.bBHV_Dem;						
	xManAuxCtr[61].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[61]();
	OUT_AG.tManAuxCtr.bBHV_Dem	 	:= xManAuxCtr[61].COn;
	VIS2MM.tManAuxCtr.bBHV_Dem 	 	:= xManAuxCtr[61].COn;
	OUT_AG.tManAuxCtr.bBHV_Dem_Man 	:= VIS2MM.tManAuxCtr.bBHV_Dem_Man;

	(* Demand heating circuit flap *)
	xManAuxCtr[62].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bHWF_Dem_Man;
	xManAuxCtr[62].VisuCmdButton := VIS2MM.tManAuxCtr.bHWF_Dem;						
	xManAuxCtr[62].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[62]();
	OUT_AG.tManAuxCtr.bHWF_Dem	 := xManAuxCtr[62].COn;
	VIS2MM.tManAuxCtr.bHWF_Dem 	 := xManAuxCtr[62].COn;

	(* Charge cooler pre heating *)
	xManAuxCtr[63].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bChC_Heating_Man;
	xManAuxCtr[63].VisuCmdButton := VIS2MM.tManAuxCtr.bChC_Heating;
	xManAuxCtr[63].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[63]();
	OUT_AG.tManAuxCtr.bChC_Heating	:= xManAuxCtr[63].COn;
	VIS2MM.tManAuxCtr.bChC_Heating	:= xManAuxCtr[63].COn;

	(* CO2 demand CODINOX *)
	xManAuxCtr[64].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bCO2_DemCodinox_Man;
	xManAuxCtr[64].VisuCmdButton := VIS2MM.tManAuxCtr.bCO2_DemCodinox;
	xManAuxCtr[64].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[64]();
	OUT_AG.tManAuxCtr.bCO2_DemCodinox := xManAuxCtr[64].COn;
	VIS2MM.tManAuxCtr.bCO2_DemCodinox := xManAuxCtr[64].COn;

	(* Charge cooler 2 pre heating *)
	xManAuxCtr[65].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bChC2_Heating_Man;
	xManAuxCtr[65].VisuCmdButton := VIS2MM.tManAuxCtr.bChC2_Heating;
	xManAuxCtr[65].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[65]();
	OUT_AG.tManAuxCtr.bChC2_Heating	:= xManAuxCtr[65].COn;
	VIS2MM.tManAuxCtr.bChC2_Heating	:= xManAuxCtr[65].COn;

	(* Engine cooling water hydraulic preheating *)
	xManAuxCtr[66].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bECW_HydrPreH_COf_Man;
	xManAuxCtr[66].VisuCmdButton := VIS2MM.tManAuxCtr.bECW_HydrPreH_COf;
	xManAuxCtr[66].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[66]();
	OUT_AG.tManAuxCtr.bECW_HydrPreH_COf := xManAuxCtr[66].COf;
	VIS2MM.tManAuxCtr.bECW_HydrPreH_COf := xManAuxCtr[66].COf;
	
	(* Engine prelubrication oil pumps *)
	xManAuxCtr[67].GnlRel		 := bManAuxCtr_GnlRel AND VIS2MM.tManAuxCtr.bEOP_DemPump_Man;
	xManAuxCtr[67].VisuCmdButton := VIS2MM.tManAuxCtr.bEOP_DemPump;
	xManAuxCtr[67].MaxCmdTime 	 := Para.tiManAuxCtr_Max;
	xManAuxCtr[67]();
	OUT_AG.tManAuxCtr.bEOP_DemPump	 := xManAuxCtr[67].COn;
	VIS2MM.tManAuxCtr.bEOP_DemPump	 := xManAuxCtr[67].COn;

	(* Message generation *)
	iCnt_Active := 0;
	FOR i:= 1 TO 67 BY 1 DO	
		IF xManAuxCtr[i].COn = TRUE THEN
			iCnt_Active := iCnt_Active + 1;
		END_IF;
	END_FOR;
	bMsg1292_Set := INT_TO_BOOL(iCnt_Active);
	
	
	(*===========================================================================*)	
	(* Active Cooling Program (ACP) *)
	
	(* Release Active Cooling Program *)
	bACP_Rel := 	Para.bACP_Enable
			AND 	bOMSS_MAT  
			AND		IN_AG.tPB2MM.bParaSetupOk
			AND NOT IN_AG.bEng_Dem
			AND NOT IN_AG.bEng_Aux_Dem_CDR 
			AND NOT bTC_CoolDownRun
			AND NOT MM2VIS.bEng_StaSpdExc
			AND NOT IN_AG.bMsg1031 
			AND NOT MM2VIS.bMsg1052 
			AND NOT MM2VIS.bMsg1053 
			AND NOT MM2VIS.bMsg1054;
				

	(*-------------------------------------------*)
	(* Automatic activation on specific DateTime *) 
	bACP_AoDT_Active := FALSE;
	
	IF VIS2MM.iACP_Year < tRealTime.year THEN							(* Check for rigth DATE - Years *)
		bACP_AoDT_Active := TRUE;
	ELSIF VIS2MM.iACP_Year = tRealTime.year THEN 
		
		IF VIS2MM.iACP_Month < tRealTime.month THEN 					(* Check for rigth DATE - Month *)
			bACP_AoDT_Active := TRUE;
		ELSIF VIS2MM.iACP_Month = tRealTime.month THEN 
			
			IF VIS2MM.iACP_Day < tRealTime.day THEN 					(* Check for rigth DATE - Day *)
				bACP_AoDT_Active := TRUE;
			ELSIF VIS2MM.iACP_Day = tRealTime.day THEN 
				
				IF VIS2MM.iACP_Hour < tRealTime.hour THEN 				(* Check for rigth TIME - Hour *)
					bACP_AoDT_Active := TRUE;
				ELSIF VIS2MM.iACP_Hour = tRealTime.hour THEN 
					
					IF VIS2MM.iACP_Minute <= tRealTime.minute THEN 		(* Check for rigth TIME - Minutes *)
						bACP_AoDT_Active := TRUE;
					END_IF;
				END_IF;
			END_IF;
		END_IF;
	END_IF;

	
	(*-------------------------------------------*)
	(* Reset Active Cooling Program *)
	xF_TRIG_ACP_Active(CLK := VIS2MM.bACP_Active AND bACP_Rel);			(* Program manually cancelled *)
	
	IF bACP_Start AND xF_TRIG_ACP_Active.Q THEN							(* Programm finished or Cancelled  *)
		
		VIS2MM.bACP_Active 	:= FALSE;
		
		IF bACP_AoDT_Active AND bACP_Cmp THEN							(* Automatic Programm activated *)
			VIS2MM.iACP_Year 	:= 0;
			VIS2MM.iACP_Month 	:= 0;
			VIS2MM.iACP_Day 	:= 0;
			VIS2MM.iACP_Hour 	:= 0;
			VIS2MM.iACP_Minute 	:= 0;
		END_IF;
	END_IF;
	
	
	(*-------------------------------------------*)
	(* Start Active Cooling Program *) 
	xTON_ACP_Start(IN := bACP_Rel AND VIS2MM.bACP_Active AND bACP_AoDT_Active, PT := T#10s);
	bACP_Start := xTON_ACP_Start.Q;
			
	IF NOT bACP_Start THEN	
		bACP_ECW_Cmp 	:= FALSE;
		bACP_EO_Cmp 	:= FALSE;
	END_IF;
	
		
	(*-------------------------------------------*)
	(* Demand Ventilation and HT - int and ext
	(* Engine Room Ventilation - Demand *) 
	OUT_AG.bACP_AirER_Dem 		:= bACP_Start AND NOT bACP_Cmp AND VIS2MM.bACP_AirER_Active;
	OUT_AG.tACP_AirER_Dem.Do 	:= OUT_AG.bACP_AirER_Dem;
	
	(* Engine Room HT - Demand *)
	OUT_AG.tACP_HT_Dem.Do		:= bACP_Start AND NOT bACP_Cmp AND (VIS2MM.bACP_ECW_Active OR VIS2MM.bACP_EO_Active);
	
	
	(*-------------------------------------------*)
	(* Active Cooling Program finished *)
	(* Engine Cooling Water temperature below set point check with overrun *)
	xTON_ACP_ECW_Cmp.IN := bACP_Start AND IN_AG.tT_ECW.Ai <= Para.rT_ACP_ECW_sp;
	xTON_ACP_ECW_Cmp.PT := T#20m;
	xTON_ACP_ECW_Cmp();
	
	IF bACP_Start AND (xTON_ACP_ECW_Cmp.Q OR NOT VIS2MM.bACP_ECW_Active) THEN
		bACP_ECW_Cmp := TRUE;	
	END_IF;
	
	(* Engine Oil temperature below set point check with overrun *)
	xTON_ACP_EO_Cmp.IN := bACP_Start AND IN_AG.tT_EO_Pan.Ai <= Para.rT_ACP_EO_sp;
	xTON_ACP_EO_Cmp.PT := T#20m;
	xTON_ACP_EO_Cmp();
	
	IF bACP_Start AND (xTON_ACP_EO_Cmp.Q OR NOT VIS2MM.bACP_EO_Active) THEN
		bACP_EO_Cmp := TRUE;	
	END_IF;	
	
	(* All temperatures below set points check *) 
	bACP_Cmp := bACP_ECW_Cmp AND bACP_EO_Cmp;
	
	
	(*=====================================================================================*)
	(*================================ BATTERY MONITORING =================================*)
	(*=====================================================================================*)
	(*------------------------------------------------------*)
	(*----------------- ENGINE BATTERY SETS ----------------*)
	(*------------------------------------------------------*)
	
	xR_TRIG_Sys_Run(CLK := IN_AG.tPB2MM.bSys_Run);
	
	(*--- starter battery voltage monitoring ---*)
	xTON_StarterBat_Hi	(IN := IN_AG.tU_StarterBat.Ai > Para.rU_StarterBat_Hi, PT := T#60s);
	xGR_MAX_StarterBat_Hi(In := IN_AG.tU_StarterBat.Ai, Gw := Para.rU_StarterBat_Hi, Hy := 5.0);
		
	xGR_MIN_StarterBat_Lo(In:= IN_AG.tU_StarterBat.Ai, Gw:= Para.rU_StarterBat_Lo, Hy:= 2.0);
	xTON_U_StarterBat_Lo.IN	:=	(Para.iBatMon_Mode = 0)
							AND	(	(NOT IN_AG.tU_StarterBat_Lo.Di AND IN_AG.tU_StarterBat_Lo.GoodQual)
								 OR	(xGR_MIN_StarterBat_Lo.Q AND IN_AG.tU_StarterBat.GoodQual)	);
	xTON_U_StarterBat_Lo(PT:= T#60s);
		
		
	// -------------- Battery-voltage test starter and buffer batteries ----------------
	//	Up to 3 sets of batteries can be monitored : - starter batteries					(Para.iBatMon_Mode = 1 OR 2)
	//												 - buffer battery 1 for control system	(Para.iBatMon_Mode = 1 OR 2)
	//												 - buffer battery 2 for control system	(Para.iBatMon_Mode = 2)
	//  The buffer battery voltage is tested in standstill (2h after engine stop, then repeated every 24h).
	//	Additionally, the starter batteries are tested during engine start while the starters are cranking.
	//	A manual trigger of the battery test is also possible via a button on the HMI.
	//	If the proactive battery test 2 (Para.iBatMon_Mode = 2) is configured (= 2 buffer battery sets),
	//	additional measurements during engine operation are performed (2h after engine start, then repeated every 24h).
	//	The measured voltages are logged in trending and in case a measurement result is below a threshold parameter, 
	//	an according warning for the battery set is triggered.
	//
	//	Measurement procedure: 
	//		* disconnect battery set to be tested
	//		* measurement of battery idle voltage (no load applied)
	//		* if idle voltage < limit, according warning is triggered
	//	otherwise...
	//		* load resistor is connected to battery
	//		* battery voltage is measured and averaged under load
	//		* if load voltage < limit, according warning is triggered

	
	(* --- list inputs and interfaces --- *)
	(* buffer battery 1: *)
	rU_BufferBat1 := IN_AG.tU_BufferBat1.Ai;
	Para.rU_BufferBat_Lo;		(* load voltage minimum *)
	Para.rU_BufferBat_Idle_Lo;	(* idle voltage minimum *)
	
	(* buffer battery 2: *)
	rU_BufferBat2 := IN_AG.tU_BufferBat2.Ai;
	Para.rU_BufferBat_Lo;		(* load voltage minimum *)
	Para.rU_BufferBat_Idle_Lo;	(* idle voltage minimum *)

	(* starter battery: *)
	rU_StarterBat := IN_AG.tU_StarterBat.Ai;
	OUT_AG.tChargeOff_Dem.Do;
	Para.rU_StarterBat_Lo;			(* load voltage minimum *)
	Para.rU_StarterBat_Crank_Lo;	(* start voltage minimum *)
	Para.rU_StarterBat_Idle_Lo;		(* idle voltage minimum *)

	(* reset trigger bit for warnings and VIS datapoint update *)
	iUpdate_UBat_Meas := 0;
	bAMM_U_BufferBat1_Lo		:= FALSE;	(* W9334 *)
	xTOF_AMM_U_BufferBat1_Lo.IN	:= FALSE;
	bAMM_U_BufferBat2_Lo		:= FALSE;	(* W9335 *)
	xTOF_AMM_U_BufferBat2_Lo.IN	:= FALSE;
	bAMM_U_StarterBat_Lo		:= FALSE;	(* W1148 *)
	xTOF_AMM_U_StarterBat_Lo.IN	:= FALSE;

	
	(* --- measurement cycles: --- *)
	xTON_2hOperation	(IN:=	IN_AG.tEng_Run.Do	AND IN_AG.tAuxV_Eng_ok.Di, PT:= T#2h);
	xR_TRIG_2hOperation	(CLK:=	xTON_2hOperation.Q);
	xTON_2hStandstill	(IN:=	NOT IN_AG.bEng_Dem	AND IN_AG.tAuxV_Eng_ok.Di, PT:= T#2h);
	xR_TRIG_2hStandstill(CLK:=	xTON_2hStandstill.Q);
	
	CASE Para.iBatMon_Mode OF
	
		1:	(* proactive battery test 1 *)
			iNr_Batteries		:= 1;
			(* trigger measurement: *)
			IF xTON_2hOperation.Q THEN			// after 2h operation
				bBatMon_Required := TRUE;
				IF xR_TRIG_2hOperation.Q THEN
					xTON_24hCycle(IN:= TRUE, PT:= T#0s);
				END_IF;
			ELSIF xTON_2hStandstill.Q THEN		// after 2h standstill
				bBatMon_Required := TRUE;
				IF xR_TRIG_2hStandstill.Q THEN
					xTON_24hCycle(IN:= TRUE, PT:= T#0s);
				END_IF;
			ELSE
				bBatMon_Required := FALSE;
			END_IF;
			
		2:	(* proactive battery test 2 *)
			IF xEngType.Type9 THEN
				iNr_Batteries	:= 2;
			ELSE
				iNr_Batteries	:= 3;
			END_IF;
			(* trigger measurement: *)
			IF xTON_2hOperation.Q THEN			// after 2h operation
				bBatMon_Required := TRUE;
				IF xR_TRIG_2hOperation.Q THEN
					xTON_24hCycle(IN:= TRUE, PT:= T#0s);
				END_IF;
			ELSIF xTON_2hStandstill.Q THEN		// after 2h standstill
				bBatMon_Required := TRUE;
				IF xR_TRIG_2hStandstill.Q THEN
					xTON_24hCycle(IN:= TRUE, PT:= T#0s);
				END_IF;
			ELSE
				bBatMon_Required := FALSE;
			END_IF;
			
	ELSE	(* no proactive battery test *)
			iNr_Batteries		:= 0;
			bBatMon_Required	:= FALSE;
			
	END_CASE;
	
	bBatMon_ManTestRunning	:= VIS2MM.bBatMon_ManTestStart OR (bBatMon_ManTestRunning AND bBatMon_TestRunning);
	IF EDGEPOS(VIS2MM.bBatMon_ManTestStart) THEN	// custom request
		(* reset VIS button *)
		VIS2MM.bBatMon_ManTestStart := FALSE;
		CASE Para.iBatMon_Mode OF
			1:	bBatMon_Required	:= NOT IN_AG.tEng_Run.Do AND NOT IN_AG.bEng_Dem;
			2:	bBatMon_Required	:= TRUE;
		ELSE	bBatMon_Required	:= FALSE;
		END_CASE;
		xTON_24hCycle(IN:= bBatMon_Required, PT:= T#0s);
	END_IF;	
	
	bBatMon_TrigMeas := xTON_24hCycle.Q;
	xTON_24hCycle(IN:= NOT xTON_24hCycle.Q AND bBatMon_Required, PT:= T#24h);	// repeat measurement every 24h
	
	
	(* --- monitoring conditions: ---*)
	xTOF_ChargeFault.IN	:= (NOT IN_AG.tBatChargeDev_Ok.Di AND MM2VIS.bMsg9336);
	xTOF_ChargeFault.PT	:= T#2h;
	xTOF_ChargeFault();
	
	rUBat_Min_CBTrip := 10.0;
	xTON_U_BufferBat1_CBTrip(IN:= (rU_BufferBat1 < rUBat_Min_CBTrip), PT:= T#1s);
	xTON_U_BufferBat2_CBTrip(IN:= (rU_BufferBat2 < rUBat_Min_CBTrip) AND (Para.iBatMon_Mode = 2), PT:= T#1s);

	xTOF_BuffBat_Reconnected.IN	:=	(bDisconnect_BufferBat1 OR bDisconnect_BufferBat2)
								OR	(xTON_U_BufferBat1_CBTrip.Q OR xTON_U_BufferBat2_CBTrip.Q);
	xTOF_BuffBat_Reconnected.PT	:=	T#2h;
	xTOF_BuffBat_Reconnected();
	
	(* general: *)
	bBatMon_RelMon		:=	IN_AG.tAuxV_Eng_ok.Di			// AuxV ok
						AND	NOT OUT_AG.tEOP1DC_Dem.Do		// DC prelube pump not running
						AND NOT IN_AG.bMsg1056				// safety loop engine ok
						AND NOT bChargeOff_EngStart			// no engine start in progress
						AND (	NOT xTOF_ChargeFault.Q		// Malfunction charging device
							 OR(NOT xTOF_ChargeFault.IN AND bBatMon_ManTestRunning))
						AND	(	NOT IN_AG.bEng_Dem			// not in start preparation
							 OR xTON_2hOperation.Q
							 OR	bBatMon_ManTestRunning);
	
	(* Buffer battery test conditions: *)
	bBufferBat_RelMon	:=	bBatMon_RelMon
						AND	(	NOT xTOF_BuffBat_Reconnected.Q
							 OR(NOT xTOF_BuffBat_Reconnected.IN AND bBatMon_ManTestRunning));
													
	(* Starter battery test conditions: *)
	bStarterBat_RelMon	:=	bBatMon_RelMon
						AND (	NOT MM2VIS.bMsg1148		// Check/exchange starter battery
							 OR	bBatMon_ManTestRunning);
	
		
	(* --- select battery set to be tested --- *)
	bBufferBat1_Disconnect4Test	:= FALSE;
	bBufferBat1_ConnectLoad		:= FALSE;
	bBufferBat2_Disconnect4Test	:= FALSE;
	bBufferBat2_ConnectLoad		:= FALSE;
	bStarterBat_Disconnect4Test	:= FALSE;
	bStarterBat_ConnectLoad		:= FALSE;
	
	CASE iIdx_Bat OF
		0:	rU_Battery := 0.0;
			bBatMon_TestAllowed := TRUE;
		
		1:	(* ----- Buffer battery 1 ----- *)
			rU_Battery := rU_BufferBat1;
			bBufferBat1_Disconnect4Test	:= xTP_ChargeOff.Q		AND bBufferBat_RelMon;	(* Disconnector *)
			bBufferBat1_ConnectLoad		:= xTP_ConnectLoad.Q	AND bBufferBat_RelMon;	(* Connect test load *)
			bBatMon_TestAllowed			:= bBufferBat_RelMon;
			
		2:	(* ----- Buffer battery 2 ----- *)
			rU_Battery := rU_BufferBat2;
			bBufferBat2_Disconnect4Test	:= xTP_ChargeOff.Q		AND bBufferBat_RelMon;	(* Disconnector *)
			bBufferBat2_ConnectLoad		:= xTP_ConnectLoad.Q	AND bBufferBat_RelMon;	(* Connect test load *)
			bBatMon_TestAllowed			:= bBufferBat_RelMon;
			
		3:	(* ----- Starter battery ------ *)
			rU_Battery := rU_StarterBat;
			bStarterBat_Disconnect4Test := xTP_ChargeOff.Q		AND bStarterBat_RelMon;	(* Disconnector *)
			bStarterBat_ConnectLoad		:= xTP_ConnectLoad.Q	AND bStarterBat_RelMon;	(* Connect test load *)
			bBatMon_TestAllowed			:= bStarterBat_RelMon;
			
		ELSE rU_Battery := 0.0;
	END_CASE;
	
	
	(* --- MEASUREMENT PROCEDURE --- *)
	(* --- Option 1: measurement process during standstill and operation: --- *)
	IF (NOT bBatMon_TestAllowed AND bBatMon_TestRunning) THEN
		rUBat_Avg				:= 0.0;
		IF iStepCnt < 50 THEN
			iUpdate_UBat_Meas	:= 3;	(* invalid measurement *)
		END_IF;

		iStepCnt := 99;		(* interrupt and next battery if current one is blocked/faulty *)
	END_IF;
	
	CASE iStepCnt OF
		0:	(* Step 0: Wait for measurement trigger *)
			xTP_ChargeOff.IN			:= FALSE;
			xTON_ChargeOff_MeasIdle.IN	:= FALSE;
			xTP_UAvg_Short.IN			:= FALSE;
			xTON_ChargeOff.IN			:= FALSE;
			xTP_ConnectLoad.IN			:= FALSE;
			xTON_LoadStable.IN			:= FALSE;
			xTP_UAvg.IN					:= FALSE;
			xTP_Wait.IN					:= FALSE;
			IF EDGEPOS(bBatMon_TrigMeas) THEN
				iIdx_Bat	:= 1;
				iStepCnt	:= 10;
				bBatMon_TestRunning := TRUE;
			END_IF;
	
		10: (* Step 1: Disconnect charging device *)
			xTP_ChargeOff.IN			:= TRUE;
			xTON_ChargeOff_MeasIdle.IN	:= xTP_ChargeOff.Q;
			xTON_ChargeOff.IN			:= xTP_ChargeOff.Q;
			xTP_ConnectLoad.IN			:= xTON_ChargeOff.Q;
			IF xTON_ChargeOff_MeasIdle.Q THEN
				xTP_UAvg_Short.IN := TRUE;
				xTON_ChargeOff_MeasIdle.IN := FALSE;
				iStepCnt := 20;
			END_IF;
			
		20:	(* Step 2: Measure battery idle/unloaded voltage *)
			IF xTP_UAvg_Short.Q THEN
				rUBat_Cum	:= rUBat_Cum + rU_Battery;
				iCount_Avg	:= iCount_Avg + 1;
			ELSE
				IF iCount_Avg > 0 THEN
					rUBat_Avg	:= rUBat_Cum / iCount_Avg;
					rUBat_Idle	:= rUBat_Avg;
					iCount_Avg	:= 0;
					rUBat_Cum	:= 0.0;
					iUpdate_UBat_Meas := 2;	(* check warning thresholds in idle and update VIS datapoints *)
				ELSE
					rUBat_Avg	:= 0.0;
					iCount_Avg	:= 0;
					rUBat_Cum	:= 0.0;
					iUpdate_UBat_Meas := 0;	(* no action *)
				END_IF;
				xTP_UAvg_Short.IN := FALSE;
			END_IF;
			xTP_ConnectLoad.IN := xTON_ChargeOff.Q;
			IF xTP_ConnectLoad.Q THEN
				xTON_ChargeOff.IN := FALSE;
				iStepCnt := 30;
			END_IF;	
		
		30:	(* Step 3: Connect load resistors *)
			xTON_LoadStable.IN := xTP_ConnectLoad.Q;
			IF xTON_LoadStable.Q THEN
				xTON_LoadStable.IN := FALSE;
				xTP_UAvg.IN := TRUE;
				iStepCnt := 40;
			END_IF;
		
		40: (* Step 4: Measure battery voltage *)
			IF xTP_UAvg.Q THEN
				rUBat_Cum	:= rUBat_Cum + rU_Battery;
				iCount_Avg	:= iCount_Avg + 1;
			ELSE
				IF iCount_Avg > 0 THEN
					rUBat_Avg		:= rUBat_Cum / iCount_Avg;
					iCount_Avg		:= 0;
					rUBat_Cum		:= 0.0;
					iUpdate_UBat_Meas	:= 1;	(* check warning thresholds under load and update VIS datapoints *)
				ELSE
					rUBat_Avg		:= 0.0;
					iCount_Avg		:= 0;
					rUBat_Cum		:= 0.0;
					iUpdate_UBat_Meas	:= 3;	(* invalid measurement *)
				END_IF;
				xTP_UAvg.IN := FALSE;
				iStepCnt := 50;
			END_IF;
		
		50:	(* Step 5: Wait for end of test *)
			rUBat_Avg	:= 0.0;
			rUBat_Idle	:= 0.0;
			IF NOT xTP_ChargeOff.Q THEN
				iStepCnt	:= 99;
			END_IF;
			
		99: (* Termination Step: Cancel measurement procedure if interrupted *)
			(* reset FUB timers: *)
			xTP_ChargeOff(IN:= FALSE, PT:= T#0s);
			xTON_ChargeOff_MeasIdle(IN:= FALSE, PT:= T#0s);
			xTP_UAvg_Short(IN:= FALSE, PT:= T#0s);
			xTON_ChargeOff(IN:= FALSE, PT:= T#0s);
			xTP_ConnectLoad(IN:= FALSE, PT:= T#0s);
			xTON_LoadStable(IN:= FALSE, PT:= T#0s);
			xTP_UAvg(IN:= FALSE, PT:= T#0s);
			xTP_Wait(IN:= TRUE);
			(* Reset voltage averaging variables: *)
			rUBat_Cum	:= 0.0;
			iCount_Avg	:= 0;
			(* Next battery or finish: *)
			IF iUpdate_UBat_Meas = 0 THEN
				IF iIdx_Bat < iNr_Batteries THEN
					IF NOT xTP_Wait.Q THEN
						xTP_Wait.IN:= FALSE;
						iIdx_Bat := iIdx_Bat + 1;
						iStepCnt := 10;
					END_IF;
				ELSE
					iIdx_Bat := 0;
					iStepCnt := 0;
					bBatMon_TestRunning := FALSE;
				END_IF;
			END_IF;
			
		ELSE iStepCnt := 0;
		
	END_CASE;
	
	(* FUB calls *)
	xTP_ChargeOff(PT:= T#50s);				(* disconnect battery set duration *)
	xTON_ChargeOff_MeasIdle(PT:= T#5s);		(* delay for start of idle voltage measurement *)
	xTP_UAvg_Short(PT:= T#3s);				(* idle voltage measurement duration *)
	xTON_ChargeOff(PT:= T#10s);				(* delay for start of load voltage measurement *)
	xTP_ConnectLoad(PT:= T#30s);			(* connect test load duration *)
	xTON_LoadStable(PT:= T#10s);			(* delay for stabilisation & start of measurement of load voltage *)
	xTP_UAvg(PT:= T#10s);					(* load voltage measurement duration *)
	xTP_Wait(PT:= T#10s);					(* pause duration between test of battery sets *)

	(* Battery test status to VISU *)
	MM2VIS.bBatMon_TestRunning := bBatMon_TestRunning;
	
		
	(* --- Option 2: measurement process during start: --- *)
	xTON_EngStart(IN:= OUT_AG.bEng_Start, PT:= Para.tiU_StarterBat_MeasDelay);
	xF_TRIG_EngStart(CLK:= OUT_AG.bEng_Start);
	IF NOT xEngType.Type9 AND ((Para.iBatMon_Mode = 1) OR (Para.iBatMon_Mode = 2)) THEN
		IF OUT_AG.bEng_Start THEN
			iIdx_Bat := 3;
		END_IF;
		
		(* collect voltage data *)
		IF xTP_UAvg_EngStart.Q AND xTON_EngStart.Q THEN
			rUBat_Cum	:= rUBat_Cum + rU_StarterBat;
			iCount_Avg	:= iCount_Avg + 1;
		END_IF;
		
		(* calculate average voltage if start process lasts long enough *)
		IF xF_TRIG_EngStart.Q THEN
			IF xTON_StartValid.Q AND (iCount_Avg > 0) THEN
				rUBat_Avg	:= rUBat_Cum / iCount_Avg;
				iCount_Avg	:= 0;
				rUBat_Cum	:= 0.0;
				iUpdate_UBat_Meas := 1;	(* check warning thresholds for cranking and update VIS datapoints *)
			ELSE
				rUBat_Avg	:= 0.0;
				iCount_Avg	:= 0;
				rUBat_Cum	:= 0.0;
				iUpdate_UBat_Meas := 3;	(* invalid measurement *)
			END_IF;
			xTP_UAvg_EngStart(IN:= FALSE);
		END_IF;
	END_IF;
	xTON_StartValid(IN:= OUT_AG.bEng_Start, PT:= (Para.tiU_StarterBat_MeasDelay + Para.tiU_StarterBat_MeasTime));
	xTP_UAvg_EngStart(IN:= xTON_EngStart.Q, PT:= Para.tiU_StarterBat_MeasTime);

	(* battery voltages of last start to VIS *)
	rUBat_Min_IdleLoadDiff	:= 0.3;
	rUBat_Diff_Disconnect	:= 1.0;
	bDisconnect_BufferBat1	:= bDisconnect_BufferBat1 AND (MM2VIS.bMsg9334 OR xTOF_AMM_U_BufferBat1_Lo.Q);
	bDisconnect_BufferBat2	:= bDisconnect_BufferBat2 AND (MM2VIS.bMsg9335 OR xTOF_AMM_U_BufferBat2_Lo.Q);
	IF iUpdate_UBat_Meas > 0 THEN
		CASE iUpdate_UBat_Meas OF
			1:	(* check warning thresholds under load and update VIS datapoints *)
				CASE iIdx_Bat OF
					1:	MM2VIS.rU_BufferBat1_BatTest	:=	rUBat_Avg;
						xTOF_AMM_U_BufferBat1_Lo.IN		:=	(rUBat_Avg < Para.rU_BufferBat_Lo)						(* voltage below threshold *)
														OR	(rUBat_Avg > (rUBat_Idle - rUBat_Min_IdleLoadDiff));	(* load voltage too high compared to idle*)
						IF (Para.iBatMon_Mode = 2) THEN
							bDisconnect_BufferBat1	:=	(rUBat_Avg < (Para.rU_BufferBat_Lo - rUBat_Diff_Disconnect));
						ELSE
							bDisconnect_BufferBat1	:=	FALSE;
						END_IF;
						
					2:	MM2VIS.rU_BufferBat2_BatTest	:=	rUBat_Avg;
						xTOF_AMM_U_BufferBat2_Lo.IN		:=	(rUBat_Avg < Para.rU_BufferBat_Lo)						(* voltage below threshold *)
														OR	(rUBat_Avg > (rUBat_Idle - rUBat_Min_IdleLoadDiff));	(* load voltage too high compared to idle*)
						IF (Para.iBatMon_Mode = 2) THEN
							bDisconnect_BufferBat2	:=	(rUBat_Avg < (Para.rU_BufferBat_Lo - rUBat_Diff_Disconnect));
						ELSE
							bDisconnect_BufferBat2	:=	FALSE;
						END_IF;
						
					3:	MM2VIS.rU_StarterBat_BatTest	:=	rUBat_Avg;
						IF xF_TRIG_EngStart.Q THEN (* measurement during start *)
							xTOF_AMM_U_StarterBat_Lo.IN	:=	(rUBat_Avg < Para.rU_StarterBat_Crank_Lo);
						ELSE (* measurement during operation or standstill*)
							xTOF_AMM_U_StarterBat_Lo.IN	:=	(rUBat_Avg < Para.rU_StarterBat_Lo)					(* voltage below threshold *)
														OR	(rUBat_Avg > (rUBat_Idle - rUBat_Min_IdleLoadDiff));	(* load voltage too high compared to idle*)
						END_IF;
				END_CASE;
				
			2:	(* check warning thresholds in idle and update VIS datapoints *)
				CASE iIdx_Bat OF
					1:	MM2VIS.rU_BufferBat1_BatTest	:=	rUBat_Avg;
						xTOF_AMM_U_BufferBat1_Lo.IN		:=	(rUBat_Avg < Para.rU_BufferBat_Idle_Lo);
						IF (Para.iBatMon_Mode = 2) THEN
							bDisconnect_BufferBat1	:=	(rUBat_Avg < (Para.rU_BufferBat_Idle_Lo - rUBat_Diff_Disconnect));
						ELSE
							bDisconnect_BufferBat1	:=	FALSE;
						END_IF;
						
					2:	MM2VIS.rU_BufferBat2_BatTest	:=	rUBat_Avg;
						xTOF_AMM_U_BufferBat2_Lo.IN		:=	(rUBat_Avg < Para.rU_BufferBat_Idle_Lo);
						IF (Para.iBatMon_Mode = 2) THEN
							bDisconnect_BufferBat2	:=	(rUBat_Avg < (Para.rU_BufferBat_Idle_Lo - rUBat_Diff_Disconnect));
						ELSE
							bDisconnect_BufferBat2	:=	FALSE;
						END_IF;
						
					3:	MM2VIS.rU_StarterBat_BatTest	:=	rUBat_Avg;
						xTOF_AMM_U_StarterBat_Lo.IN		:=	(rUBat_Avg < Para.rU_StarterBat_Idle_Lo);
				END_CASE;
				
			ELSE	(* invalid measurement *)
				CASE iIdx_Bat OF
					1:	MM2VIS.rU_BufferBat1_BatTest	:=	0.0;
					2:	MM2VIS.rU_BufferBat2_BatTest	:=	0.0;
					3:	MM2VIS.rU_StarterBat_BatTest	:=	0.0;
				END_CASE;
		END_CASE;
		iUpdate_UBat_Meas	:=	0;
	END_IF;

	(* --- Delay trigger of warning message to have correct HMI assistant values --- *)
	xTOF_AMM_U_BufferBat1_Lo(PT := T#2.5s);
	xTOF_AMM_U_BufferBat2_Lo(PT := T#2.5s);
	xTOF_AMM_U_StarterBat_Lo(PT := T#2.5s);
	
	(* --- Circuit breaker tripped --- *)
	bAMM_U_BufferBat1_Lo := EDGENEG(xTOF_AMM_U_BufferBat1_Lo.Q) OR xTON_U_BufferBat1_CBTrip.Q;
	bAMM_U_BufferBat2_Lo := EDGENEG(xTOF_AMM_U_BufferBat2_Lo.Q) OR xTON_U_BufferBat2_CBTrip.Q;
	
	(* --- Other starter battery monitorings triggered --- *)
	bAMM_U_StarterBat_Lo := EDGENEG(xTOF_AMM_U_StarterBat_Lo.Q) OR xTON_U_StarterBat_Lo.Q;
	
	(* --- SET OUTPUTS --- *)
	(* ensure one buffer battery stays connected *)
	xTON_BufferBat1_Connected(IN:= NOT OUT_AG.tBufferBat1_Disconnect.Do, PT:= T#1s);
	xTON_BufferBat2_Connected(IN:= NOT OUT_AG.tBufferBat2_Disconnect.Do OR (Para.iBatMon_Mode = 1), PT:= T#1s);
	(* ensure that load is disconnected when battery is reconnected *)
	xTOF_BufferBat1_LoadDisconnect(IN:= EDGENEG(bBufferBat1_ConnectLoad), PT:= T#1s);
	xTOF_BufferBat2_LoadDisconnect(IN:= EDGENEG(bBufferBat2_ConnectLoad), PT:= T#1s);
	xTOF_StarterBat_LoadDisconnect(IN:= EDGENEG(bStarterBat_ConnectLoad), PT:= T#1s);

	(* ----- Buffer battery 1 ----- *)
	OUT_AG.tBufferBat1_Disconnect.Do	:=	(bBufferBat1_Disconnect4Test OR bDisconnect_BufferBat1 OR xTOF_BufferBat1_LoadDisconnect.Q)	(* open disconnector *)
										AND xTON_BufferBat2_Connected.Q		(* other battery connected *)
										AND NOT xTON_U_BufferBat2_CBTrip.Q;	(* no circuit breaker trip of other battery *)
	OUT_AG.tBufferBat1_ConnectLoad.Do	:= bBufferBat1_ConnectLoad AND OUT_AG.tBufferBat1_Disconnect.Do;	(* connect load resistor *)
	
	(* ----- Buffer battery 2 ----- *)
	OUT_AG.tBufferBat2_Disconnect.Do	:=	(bBufferBat2_Disconnect4Test OR bDisconnect_BufferBat2 OR xTOF_BufferBat2_LoadDisconnect.Q)	(* open disconnector *)
										AND	xTON_BufferBat1_Connected.Q		(* other battery connected *)
										AND NOT xTON_U_BufferBat1_CBTrip.Q;	(* no circuit breaker trip of other battery *)
	OUT_AG.tBufferBat2_ConnectLoad.Do	:= bBufferBat2_ConnectLoad AND OUT_AG.tBufferBat2_Disconnect.Do;	(* connect load resistor *)
	
	(* ----- Starter battery ----- *)
	bStarterBat_Disconnect				:= bStarterBat_Disconnect4Test OR xTOF_StarterBat_LoadDisconnect.Q;	(* open disconnector *)
	OUT_AG.tStarterBat_ConnectLoad.Do	:= bStarterBat_ConnectLoad AND OUT_AG.tChargeOff_Dem.Do;			(* connect load resistor *)
	


	(*-----------------------------------------------------------------------------*)
	(*--------------- CONTROL BATTERY TEST / AUXILIARY BATTERY SETS ---------------*)
	(*-----------------------------------------------------------------------------*)
	
	(* --- list inputs and interfaces --- *)
//	IN_AG.tU_CtrlBat[1..4].Ai;
//	IN_AG.tCtrlBat_ChargeDev_Ok[1..4].Di;
//	OUT_AG.tCtrlBat_Disconnect[1..4].Do;
//	OUT_AG.tCtrlBat_ConnectLoad[1..4].Do;
//	IN_AG.sLocIdent_CtrlBatMon[1..4];
//	IN_AG.bAuxV_ok_CtrlBatMon[1..4];
//	
//	Para.rU_BufferBat_Lo;		(* load voltage minimum *)
//	Para.rU_BufferBat_Idle_Lo;	(* idle voltage minimum *)
//	
//	MM2VIS.rU_CtrlBat[1..4];
//	MM2VIS.rU_CtrlBat_BatTest[1..4];
//	MM2VIS.bCtrlBatMon_TestRunning;
//	VIS2MM.bCtrlBatMon_ManTestStart;
//	
//	MM2VIS.sLocIdent_CtrlBatMon[1..4];
//	MM2VIS.sCtrlBat_LocFault;
//	MM2VIS.sCtrlBat_ChargeDev_LocFault;
//	MM2VIS.iNumActive_CtrlBatMon;
	
	(* determine number of used control battery test sets *)
	IF EDGENEG(xR_TRIG_Sys_Run.Q) THEN
		FOR iIdx_CtrlBat := 1 TO iNum_CtrlBatMon DO
			bCtrlBat_Used[iIdx_CtrlBat] := FALSE;
			IF IN_AG.tU_CtrlBat[iIdx_CtrlBat].Exist THEN
				iNr_CtrlBat_Used	:= iNr_CtrlBat_Used + 1;
				bCtrlBat_Used[iIdx_CtrlBat] := TRUE;
			END_IF;
		END_FOR;
		iNr_CtrlBat_Used			:= LIMIT(0, iNr_CtrlBat_Used, iNum_CtrlBatMon);
	END_IF;

	(* reset trigger bit for warnings and VIS datapoint update *)
	iUpdate_UCtrlBat_Meas	:= 0;
	FOR iIdx_CtrlBat := 1 TO iNum_CtrlBatMon DO
		bAMM_U_CtrlBat_Lo[iIdx_CtrlBat]			:= FALSE;	(* W9357 *)
		xTOF_AMM_U_CtrlBat_Lo[iIdx_CtrlBat].IN	:= FALSE; 
	END_FOR;
	
	(* --- measurement cycles: --- *)
	IF (IN_AG.tEng_Run.Do OR IN_AG.bEng_Dem) THEN
		bCtrlBatMon_Required		:= FALSE;
	ELSE				
		(* trigger measurement: *)
		IF xTON_2hStandstill.Q THEN		// after 2h standstill
			bCtrlBatMon_Required	:= TRUE;
			IF xR_TRIG_2hStandstill.Q THEN
				xTON_24hCycle_CtrlBatMon(IN:= TRUE, PT:= T#0s);
			END_IF;
		ELSE
			bCtrlBatMon_Required	:= FALSE;
		END_IF;
	END_IF;
	
	bCtrlBatMon_ManTestRunning	:= VIS2MM.bCtrlBatMon_ManTestStart OR (bCtrlBatMon_ManTestRunning AND bCtrlBatMon_TestRunning);
	IF EDGEPOS(VIS2MM.bCtrlBatMon_ManTestStart) THEN	// custom request
		VIS2MM.bCtrlBatMon_ManTestStart	:= FALSE;		// reset VIS button
		bCtrlBatMon_Required			:= NOT IN_AG.tEng_Run.Do AND NOT IN_AG.bEng_Dem;
		xTON_24hCycle_CtrlBatMon(IN:= bCtrlBatMon_Required, PT:= T#0s);
	END_IF;	
	
	bCtrlBatMon_TrigMeas := xTON_24hCycle_CtrlBatMon.Q;
	xTON_24hCycle_CtrlBatMon(IN:= NOT xTON_24hCycle_CtrlBatMon.Q AND bCtrlBatMon_Required, PT:= T#24h);	// repeat measurement every 24h
	
	
	(* --- monitoring conditions: ---*)
	FOR iIdx_CtrlBat := 1 TO iNum_CtrlBatMon DO
		IF iIdx_CtrlBat <= iNr_CtrlBat_Used THEN
			xTOF_ChargeFault_CtrlBat[iIdx_CtrlBat](IN:= NOT IN_AG.tCtrlBat_ChargeDev_Ok[iIdx_CtrlBat].Di AND MM2VIS.bMsg9358, PT:= T#2h);
			
			xTON_U_CtrlBat_CBTrip[iIdx_CtrlBat](IN:= (IN_AG.tU_CtrlBat[iIdx_CtrlBat].Ai < rUBat_Min_CBTrip), PT:= T#3s);
			xTOF_CtrlBat_Reconnected[iIdx_CtrlBat](IN:= xTON_U_CtrlBat_CBTrip[iIdx_CtrlBat].Q, PT:= T#2h);
		ELSE
			xTOF_ChargeFault_CtrlBat[iIdx_CtrlBat](IN:= FALSE, PT:= T#2h);
			
			xTON_U_CtrlBat_CBTrip[iIdx_CtrlBat](IN:= FALSE, PT:= T#3s);
			xTOF_CtrlBat_Reconnected[iIdx_CtrlBat](IN:= FALSE, PT:= T#2h);
		END_IF;
		
		bCtrlBat_Disconnect4Test[iIdx_CtrlBat]	:= FALSE;
		bCtrlBat_ConnectLoad[iIdx_CtrlBat]		:= FALSE;
	END_FOR;
	
	
	(* --- select battery set to be tested --- *)
	IF iIdx_CtrlBat_UnderTest = 0 THEN
		rU_CtrlBat				:= 0.0;
		bCtrlBatMon_TestAllowed	:= TRUE;
	ELSE
		(* Control battery test conditions: *)
		bCtrlBatMon_TestAllowed	:=	IN_AG.bAuxV_ok_CtrlBatMon[iIdx_CtrlBat_UnderTest]			// AuxV ok
								AND NOT IN_AG.bMsg1056											// safety loop engine ok
								AND (	NOT xTOF_ChargeFault_CtrlBat[iIdx_CtrlBat_UnderTest].Q	// Malfunction charging device
									 OR(NOT xTOF_ChargeFault_CtrlBat[iIdx_CtrlBat_UnderTest].IN AND bCtrlBatMon_ManTestRunning))
								AND	(	NOT xTOF_CtrlBat_Reconnected[iIdx_CtrlBat_UnderTest].Q	// Battery not recently reconnected
									 OR(NOT xTOF_CtrlBat_Reconnected[iIdx_CtrlBat_UnderTest].IN AND bCtrlBatMon_ManTestRunning))
								AND	(	NOT IN_AG.bEng_Dem AND NOT IN_AG.tEng_Run.Do);			// engine not running
	
		rU_CtrlBat				:= IN_AG.tU_CtrlBat[iIdx_CtrlBat_UnderTest].Ai;
		bCtrlBat_Disconnect4Test[iIdx_CtrlBat_UnderTest]	:= xTP_CtrlBatMon_ChargeOff.Q	AND bCtrlBatMon_TestAllowed;	(* Disconnector *)
		bCtrlBat_ConnectLoad[iIdx_CtrlBat_UnderTest]		:= xTP_CtrlBatMon_ConnectLoad.Q	AND bCtrlBatMon_TestAllowed;	(* Connect test load *)
	END_IF;
	
	
	(* --- MEASUREMENT PROCEDURE --- *)
	(* --- Option 1: measurement process during standstill and operation: --- *)
	IF (NOT bCtrlBatMon_TestAllowed AND bCtrlBatMon_TestRunning) THEN
		rUCtrlBat_Avg				:= 0.0;
		IF iStepCnt_CtrlBatMon < 50 THEN
			iUpdate_UCtrlBat_Meas	:= 3;	(* invalid measurement *)
		END_IF;

		iStepCnt_CtrlBatMon := 99;		(* interrupt and next battery if current one is blocked/faulty *)
	END_IF;
	
	CASE iStepCnt_CtrlBatMon OF
		0:	(* Step 0: Wait for measurement trigger *)
			xTP_CtrlBatMon_ChargeOff.IN				:= FALSE;
			xTON_CtrlBatMon_ChrgOffMeasIdle.IN		:= FALSE;
			xTP_CtrlBatMon_UAvg_Short.IN			:= FALSE;
			xTON_CtrlBatMon_ChargeOff.IN			:= FALSE;
			xTP_CtrlBatMon_ConnectLoad.IN			:= FALSE;
			xTON_CtrlBatMon_LoadStable.IN			:= FALSE;
			xTP_CtrlBatMon_UAvg.IN					:= FALSE;
			xTP_CtrlBatMon_Wait.IN					:= FALSE;
			IF EDGEPOS(bCtrlBatMon_TrigMeas) THEN
				iIdx_CtrlBat_UnderTest	:= 1;
				iStepCnt_CtrlBatMon		:= 10;
				bCtrlBatMon_TestRunning	:= TRUE;
			END_IF;
	
		10: (* Step 1: Disconnect charging device *)
			xTP_CtrlBatMon_ChargeOff.IN				:= TRUE;
			xTON_CtrlBatMon_ChrgOffMeasIdle.IN		:= xTP_CtrlBatMon_ChargeOff.Q;
			xTON_CtrlBatMon_ChargeOff.IN			:= xTP_CtrlBatMon_ChargeOff.Q;
			xTP_CtrlBatMon_ConnectLoad.IN			:= xTON_CtrlBatMon_ChargeOff.Q;
			IF xTON_CtrlBatMon_ChrgOffMeasIdle.Q THEN
				xTP_CtrlBatMon_UAvg_Short.IN		:= TRUE;
				xTON_CtrlBatMon_ChrgOffMeasIdle.IN	:= FALSE;
				iStepCnt_CtrlBatMon					:= 20;
			END_IF;
			
		20:	(* Step 2: Measure battery idle/unloaded voltage *)
			IF xTP_CtrlBatMon_UAvg_Short.Q THEN
				rUCtrlBat_Cum			:= rUCtrlBat_Cum + rU_CtrlBat;
				iCount_CtrlBatMon_Avg	:= iCount_CtrlBatMon_Avg + 1;
			ELSE
				IF iCount_CtrlBatMon_Avg > 0 THEN
					rUCtrlBat_Avg			:= rUCtrlBat_Cum / iCount_CtrlBatMon_Avg;
					rUCtrlBat_Idle			:= rUCtrlBat_Avg;
					iCount_CtrlBatMon_Avg	:= 0;
					rUCtrlBat_Cum			:= 0.0;
					iUpdate_UCtrlBat_Meas	:= 2;	(* check warning thresholds in idle and update VIS datapoints *)
				ELSE
					rUCtrlBat_Avg			:= 0.0;
					iCount_CtrlBatMon_Avg	:= 0;
					rUCtrlBat_Cum			:= 0.0;
					iUpdate_UCtrlBat_Meas	:= 0;	(* no action *)
				END_IF;
				xTP_CtrlBatMon_UAvg_Short.IN := FALSE;
			END_IF;
			xTP_CtrlBatMon_ConnectLoad.IN 		:= xTON_CtrlBatMon_ChargeOff.Q;
			IF xTP_CtrlBatMon_ConnectLoad.Q THEN
				xTON_CtrlBatMon_ChargeOff.IN	:= FALSE;
				iStepCnt_CtrlBatMon				:= 30;
			END_IF;	
		
		30:	(* Step 3: Connect load resistors *)
			xTON_CtrlBatMon_LoadStable.IN := xTP_CtrlBatMon_ConnectLoad.Q;
			IF xTON_CtrlBatMon_LoadStable.Q THEN
				xTON_CtrlBatMon_LoadStable.IN	:= FALSE;
				xTP_CtrlBatMon_UAvg.IN 			:= TRUE;
				iStepCnt_CtrlBatMon				:= 40;
			END_IF;
		
		40: (* Step 4: Measure battery voltage *)
			IF xTP_CtrlBatMon_UAvg.Q THEN
				rUCtrlBat_Cum			:= rUCtrlBat_Cum + rU_CtrlBat;
				iCount_CtrlBatMon_Avg	:= iCount_CtrlBatMon_Avg + 1;
			ELSE
				IF iCount_CtrlBatMon_Avg > 0 THEN
					rUCtrlBat_Avg			:= rUCtrlBat_Cum / iCount_CtrlBatMon_Avg;
					iCount_CtrlBatMon_Avg	:= 0;
					rUCtrlBat_Cum			:= 0.0;
					iUpdate_UCtrlBat_Meas	:= 1;	(* check warning thresholds under load and update VIS datapoints *)
				ELSE
					rUCtrlBat_Avg			:= 0.0;
					iCount_CtrlBatMon_Avg	:= 0;
					rUCtrlBat_Cum			:= 0.0;
					iUpdate_UCtrlBat_Meas	:= 3;	(* invalid measurement *)
				END_IF;
				xTP_CtrlBatMon_UAvg.IN 	:= FALSE;
				iStepCnt_CtrlBatMon		:= 50;
			END_IF;
		
		50:	(* Step 5: Wait for end of test *)
			rUCtrlBat_Avg	:= 0.0;
			rUCtrlBat_Idle	:= 0.0;
			IF NOT xTP_CtrlBatMon_ChargeOff.Q THEN
				iStepCnt_CtrlBatMon	:= 99;
			END_IF;
			
		99: (* Termination Step: Cancel measurement procedure if interrupted *)
			(* reset FUB timers: *)
			xTP_CtrlBatMon_ChargeOff(IN:= FALSE, PT:= T#0s);
			xTON_CtrlBatMon_ChrgOffMeasIdle(IN:= FALSE, PT:= T#0s);
			xTP_CtrlBatMon_UAvg_Short(IN:= FALSE, PT:= T#0s);
			xTON_CtrlBatMon_ChargeOff(IN:= FALSE, PT:= T#0s);
			xTP_CtrlBatMon_ConnectLoad(IN:= FALSE, PT:= T#0s);
			xTON_CtrlBatMon_LoadStable(IN:= FALSE, PT:= T#0s);
			xTP_CtrlBatMon_UAvg(IN:= FALSE, PT:= T#0s);
			xTP_CtrlBatMon_Wait(IN:= TRUE);
			(* Reset voltage averaging variables: *)
			rUCtrlBat_Cum			:= 0.0;
			iCount_CtrlBatMon_Avg	:= 0;
			(* Next battery or finish: *)
			IF iUpdate_UCtrlBat_Meas = 0 THEN
				IF iIdx_CtrlBat_UnderTest < iNr_CtrlBat_Used THEN
					IF NOT xTP_CtrlBatMon_Wait.Q THEN
						xTP_CtrlBatMon_Wait.IN	:= FALSE;
						iIdx_CtrlBat_UnderTest	:= iIdx_CtrlBat_UnderTest + 1;
						iStepCnt_CtrlBatMon		:= 10;
					END_IF;
				ELSE
					iIdx_CtrlBat_UnderTest	:= 0;
					iStepCnt_CtrlBatMon		:= 0;
					bCtrlBatMon_TestRunning	:= FALSE;
				END_IF;
			END_IF;
			
		ELSE iStepCnt_CtrlBatMon := 0;
		
	END_CASE;
	
	(* FUB calls *)
	xTP_CtrlBatMon_ChargeOff(PT:= T#50s);			(* disconnect battery set duration *)
	xTON_CtrlBatMon_ChrgOffMeasIdle(PT:= T#5s);		(* delay for start of idle voltage measurement *)
	xTP_CtrlBatMon_UAvg_Short(PT:= T#3s);			(* idle voltage measurement duration *)
	xTON_CtrlBatMon_ChargeOff(PT:= T#10s);			(* delay for start of load voltage measurement *)
	xTP_CtrlBatMon_ConnectLoad(PT:= T#30s);			(* connect test load duration *)
	xTON_CtrlBatMon_LoadStable(PT:= T#10s);			(* delay for stabilisation & start of measurement of load voltage *)
	xTP_CtrlBatMon_UAvg(PT:= T#10s);				(* load voltage measurement duration *)
	xTP_CtrlBatMon_Wait(PT:= T#10s);				(* pause duration between test of battery sets *)

	(* Battery test status to VISU *)
	MM2VIS.bCtrlBatMon_TestRunning := bCtrlBatMon_TestRunning;
	
		
	(* battery voltages of last start to VIS *)	
	IF (iUpdate_UCtrlBat_Meas > 0) AND (iIdx_CtrlBat_UnderTest <> 0) THEN
		CASE iUpdate_UCtrlBat_Meas OF
			1:	(* check warning thresholds under load and update VIS datapoints *)
				MM2VIS.rU_CtrlBat_BatTest[iIdx_CtrlBat_UnderTest]	:=	rUCtrlBat_Avg;
				xTOF_AMM_U_CtrlBat_Lo[iIdx_CtrlBat_UnderTest].IN	:=	(rUCtrlBat_Avg < Para.rU_BufferBat_Lo)							(* voltage below threshold *)
																	OR	(rUCtrlBat_Avg > (rUCtrlBat_Idle - rUBat_Min_IdleLoadDiff));	(* load voltage too high compared to idle*)
				
			2:	(* check warning thresholds in idle and update VIS datapoints *)
				MM2VIS.rU_CtrlBat_BatTest[iIdx_CtrlBat_UnderTest]	:=	rUCtrlBat_Idle;
				xTOF_AMM_U_CtrlBat_Lo[iIdx_CtrlBat_UnderTest].IN	:=	(rUCtrlBat_Idle < Para.rU_BufferBat_Idle_Lo);
				
			ELSE	(* invalid measurement *)
				MM2VIS.rU_CtrlBat_BatTest[iIdx_CtrlBat_UnderTest]	:=	0.0;
		END_CASE;
		iUpdate_UCtrlBat_Meas	:=	0;
	END_IF;

	bAMM_U_CtrlBat_Lo_Coll	:=	FALSE;
	FOR iIdx_CtrlBat := 1 TO iNum_CtrlBatMon DO
		IF iIdx_CtrlBat <= iNr_CtrlBat_Used THEN
			(* --- Delay trigger of warning message to have correct HMI assistant values --- *)
			xTOF_AMM_U_CtrlBat_Lo[iIdx_CtrlBat](PT := T#2.5s);
			
			IF xTOF_AMM_U_CtrlBat_Lo[iIdx_CtrlBat].Q OR xTON_U_CtrlBat_CBTrip[iIdx_CtrlBat].IN THEN
				MM2VIS.sCtrlBat_LocFault	:=	IN_AG.sLocIdent_CtrlBatMon[iIdx_CtrlBat];
			END_IF;
			
			(* --- Generate warnings --- *)
			xF_TRIG_AMM_U_CtrlBat_Lo[iIdx_CtrlBat](CLK:= xTOF_AMM_U_CtrlBat_Lo[iIdx_CtrlBat].Q);
			bAMM_U_CtrlBat_Lo[iIdx_CtrlBat]	:=	xF_TRIG_AMM_U_CtrlBat_Lo[iIdx_CtrlBat].Q OR xTON_U_CtrlBat_CBTrip[iIdx_CtrlBat].Q; // Regular warning trigger + Circuit breaker tripped
			bAMM_U_CtrlBat_Lo_Coll			:=	bAMM_U_CtrlBat_Lo[iIdx_CtrlBat] OR bAMM_U_CtrlBat_Lo_Coll;
			
			(* --- SET OUTPUTS --- *)
			(* ensure that load is disconnected when battery is reconnected *)
			xTOF_CtrlBat_LoadDisconnect[iIdx_CtrlBat](IN:= bCtrlBat_ConnectLoad[iIdx_CtrlBat], PT:= T#1s);
		
			(* ----- Control battery ----- *)
			OUT_AG.tCtrlBat_Disconnect[iIdx_CtrlBat].Do		:=	bCtrlBat_Disconnect4Test[iIdx_CtrlBat] OR xTOF_CtrlBat_LoadDisconnect[iIdx_CtrlBat].Q;	(* open disconnector *)
			OUT_AG.tCtrlBat_ConnectLoad[iIdx_CtrlBat].Do	:=	bCtrlBat_ConnectLoad[iIdx_CtrlBat] AND OUT_AG.tCtrlBat_Disconnect[iIdx_CtrlBat].Do;		(* connect load resistor *)
		ELSE
			(* --- Reset variables --- *)
			xF_TRIG_AMM_U_CtrlBat_Lo[iIdx_CtrlBat](CLK:= FALSE);
			xTOF_AMM_U_CtrlBat_Lo[iIdx_CtrlBat](IN:= FALSE, PT:= T#2.5s);
			bAMM_U_CtrlBat_Lo[iIdx_CtrlBat]	:=	FALSE;
			
			(* --- RESET OUTPUTS --- *)
			xTOF_CtrlBat_LoadDisconnect[iIdx_CtrlBat](IN:= FALSE, PT:= T#1s);
			OUT_AG.tCtrlBat_Disconnect[iIdx_CtrlBat].Do		:=	FALSE;
			OUT_AG.tCtrlBat_ConnectLoad[iIdx_CtrlBat].Do	:=	FALSE;
		END_IF;
	END_FOR;

	(*-----------------------------------------------------------------------------*)


	
	
	(*----------------------------------------------------------------------------------*)
	(* redundant/double pump control *)
	(*----------------------------------------------------------------------------------*)
 
	(*--- high temperature circuit pumps 1+2 (heating water pumps) ---*)
	(* inputs *)
	xRedPump_HWP.Enable				:= Para.bRedHWP_Active;
	xRedPump_HWP.bDemGnl			:= OUT_AG.tHWP_Dem.Do;
	xRedPump_HWP.bPump1_Op			:= IN_AG.tHWP1_Op.Di;
	xRedPump_HWP.bPump2_Op			:= IN_AG.tHWP2_Op.Di;
	xRedPump_HWP.bMonActive			:= NOT bNoMon4BlackStart;
	xRedPump_HWP.tiNoFB_Timeout 	:= T#5s;
	(* inputs - pump warnings *)
	xRedPump_HWP.bReadMsg_noFB		:= MM2VIS.bMsg3519 OR MM2VIS.bMsg9255;
	xRedPump_HWP.iReadPumpIdx_noFB	:= iRedHWP_Fail;

	xRedPump_HWP();
	
	(* outputs *)
	OUT_AG.tHWP1_Dem.Do				:= xRedPump_HWP.bPump1_Dem;
	OUT_AG.tHWP2_Dem.Do				:= xRedPump_HWP.bPump2_Dem;
	(* outputs - pump warnings *)
	bRedHWP_Fail					:= xRedPump_HWP.bSetMsg_noFB;
	iRedHWP_Fail					:= xRedPump_HWP.iSetPumpIdx_noFB;
	(*---------------------------*)


	(*--- low temperature circuit pumps 1+3 (charge cooler water pumps) ---*)
	(* inputs *)
	xRedPump_CCWP.Enable			:= Para.bRedCCWP_Active;
	xRedPump_CCWP.bDemGnl			:= IN_AG.bCCWP_Dem;
	xRedPump_CCWP.bPump1_Op			:= IN_AG.tCCWP1_Op.Di;
	xRedPump_CCWP.bPump2_Op			:= IN_AG.tCCWP2_Op.Di;
	xRedPump_CCWP.bMonActive		:= NOT bNoMon4BlackStart;
	xRedPump_CCWP.tiNoFB_Timeout 	:= T#5s;
	(* inputs - pump warnings *)
	xRedPump_CCWP.bReadMsg_noFB		:= MM2VIS.bMsg2118 OR MM2VIS.bMsg9256;
	xRedPump_CCWP.iReadPumpIdx_noFB	:= iRedCCWP_Fail;

	xRedPump_CCWP();

	(* outputs *)
	OUT_AG.tCCWP1_Dem.Do			:= xRedPump_CCWP.bPump1_Dem;
	OUT_AG.tCCWP2_Dem.Do			:= xRedPump_CCWP.bPump2_Dem;
	(* outputs - pump warnings *)
	bRedCCWP_Fail					:= xRedPump_CCWP.bSetMsg_noFB;
	iRedCCWP_Fail					:= xRedPump_CCWP.iSetPumpIdx_noFB;
	(*---------------------------*)


	(*--- low temperature circuit pumps 2+4 (charge cooler 2 water pumps) ---*)
	(* inputs *)
	xRedPump_CC2WP.Enable				:= Para.bRedCC2WP_Active;
	xRedPump_CC2WP.bDemGnl				:= IN_AG.bCC2WP_Dem;
	xRedPump_CC2WP.bPump1_Op			:= IN_AG.tCC2WP1_Op.Di;
	xRedPump_CC2WP.bPump2_Op			:= IN_AG.tCC2WP2_Op.Di;
	xRedPump_CC2WP.bMonActive			:= NOT bNoMon4BlackStart;
	xRedPump_CC2WP.tiNoFB_Timeout 		:= T#5s;
	(* inputs - pump warnings *)
	xRedPump_CC2WP.bReadMsg_noFB		:= MM2VIS.bMsg9227 OR MM2VIS.bMsg9257;
	xRedPump_CC2WP.iReadPumpIdx_noFB	:= iRedCC2WP_Fail;

	xRedPump_CC2WP();

	(* outputs *)
	OUT_AG.tCC2WP1_Dem.Do				:= xRedPump_CC2WP.bPump1_Dem;
	OUT_AG.tCC2WP2_Dem.Do				:= xRedPump_CC2WP.bPump2_Dem;
	(* outputs - pump warnings *)
	bRedCC2WP_Fail						:= xRedPump_CC2WP.bSetMsg_noFB;
	iRedCC2WP_Fail						:= xRedPump_CC2WP.iSetPumpIdx_noFB;
	(*---------------------------*)


	(*--- emergency cooling circuit pumps ---*)
	(* inputs *)
	xRedPump_EmCWP.Enable				:= Para.bRedEmCWP_Active;
	xRedPump_EmCWP.bDemGnl				:= IN_AG.bEmCWP_Dem;
	xRedPump_EmCWP.bPump1_Op			:= IN_AG.tEmCWP1_Op.Di;
	xRedPump_EmCWP.bPump2_Op			:= IN_AG.tEmCWP2_Op.Di;
	xRedPump_EmCWP.bMonActive			:= NOT bNoMon4BlackStart;
	xRedPump_EmCWP.tiNoFB_Timeout 		:= T#5s;
	(* inputs - pump warnings *)
	xRedPump_EmCWP.bReadMsg_noFB		:= MM2VIS.bMsg9279 OR MM2VIS.bMsg9258;
	xRedPump_EmCWP.iReadPumpIdx_noFB	:= iRedEmCWP_Fail;

	xRedPump_EmCWP();

	(* outputs *)
	OUT_AG.tEmCWP1_Dem.Do				:= xRedPump_EmCWP.bPump1_Dem;
	OUT_AG.tEmCWP2_Dem.Do				:= xRedPump_EmCWP.bPump2_Dem;
	(* outputs - pump warnings *)
	bRedEmCWP_Fail						:= xRedPump_EmCWP.bSetMsg_noFB;
	iRedEmCWP_Fail						:= xRedPump_EmCWP.iSetPumpIdx_noFB;
	(*---------------------------*)	
	
	
	(*----------------------------------------------------------------------------------*)
	(* turbocharger counter for failed post-cooling *)
	(*----------------------------------------------------------------------------------*)

	(* trap TC black shutdowns by PLC powerfails *)
	IF EDGEPOS(IN_AG.tPB2MM.bSys_Run) THEN
		IF iSt_TC_PwrInterrupt.0 THEN
			iCnt_TC_abs_RSP := iCnt_TC_abs_RSP + 1;														(* counter for failed post-coolings caused by DIANE power interruptions *)
			iCnt_TC_abs 	:= iCnt_TC_abs + 1;															(* absolute counter *)
			iCnt_TC_rel_A 	:= iCnt_TC_rel_A + 1;														(* relative counter for failed TC post-cooling at bank A *)
			iCnt_TC_rel_B 	:= iCnt_TC_rel_B + 1;														(* relative counter for failed TC post-cooling at bank B *)	
		END_IF;
		
		(* initial writing of permanent variables on VISU after PLC start-up *)
		VIS2MM.iCnt_TC_abs 		:= iCnt_TC_abs;
		VIS2MM.iCnt_TC_rel_A 	:= iCnt_TC_rel_A;
		VIS2MM.iCnt_TC_rel_B 	:= iCnt_TC_rel_B;
		VIS2MM.iCnt_TC_abs_RSP	:= iCnt_TC_abs_RSP;
	END_IF;
	
	(* check if user input from VISU - reset of counters *)
	IF IN_AG.tPB2MM.bSys_Run THEN																	
		IF VIS2MM.iCnt_TC_abs <> iCnt_TC_abs THEN
			iCnt_TC_abs := VIS2MM.iCnt_TC_abs;
		END_IF;
		IF VIS2MM.iCnt_TC_rel_A <> iCnt_TC_rel_A THEN
			iCnt_TC_rel_A := VIS2MM.iCnt_TC_rel_A;
		END_IF;
		IF VIS2MM.iCnt_TC_rel_B <> iCnt_TC_rel_B THEN
			iCnt_TC_rel_B := VIS2MM.iCnt_TC_rel_B;
		END_IF;
		IF VIS2MM.iCnt_TC_abs_RSP <> iCnt_TC_abs_RSP THEN
			iCnt_TC_abs_RSP := VIS2MM.iCnt_TC_abs_RSP;
		END_IF;
	END_IF;
	
	
	(* catch hot shut down by emergency stop or fire alarm during operation *)
	xF_TRIG_TC_CoolDown_EmStop_Fire(CLK := (IN_AG.bMsg1031 OR MM2VIS.bMsg1054) AND M_HDREHZ);
	
	(* time-span and triggers considered for un-/successful TC post-cooling assessment *)
	IF xEngType.Type9 THEN
			xTP_TC_CoolDownCheck.PT := (xTON_TL_OP_Ein.PT - T#2m);
			
			xTP_TC_CoolDownCheck.IN :=	NOT Para.bTC_watercooled 									(* --- Type 9: only oilcooled TC --- *)
									AND	(	(bTC_CoolDownRun AND (iCnt_TL = 0)) 					(* normal TC post-cooling run - first (long) cooling phase *)
									  	 OR	xF_TRIG_TC_CoolDown_EmStop_Fire.Q	);					(* A1031 or A1054 during engine run = prior to start of TC post-cooling*)

			xTON_TC_CoolDownInterrupt.IN := xTP_TC_CoolDownCheck.Q									(* post-cooling pressure interruption, pressure <= 0.2 bar for t_interrupt <= 1 min *)
										AND	(tPr_TCLubOil_Min.Ai < Para.rPr_TC_Oil_CoolDownInterrupt_Lo)
										AND (NOT MM2VIS.bMsg2624 OR NOT MM2VIS.bMsg2625)
										AND (Para.bPr_Oil_LPTC_In_A OR Para.bPr_Oil_LPTC_In_B);
									  								  
	ELSIF Para.bTSTC_Exist THEN																		(* --- 624 twin stage turbocharged --- *)
		IF Para.tiPostLub_Continuous = 0 THEN														(* watercooled turbocharger KBB *)
			xTP_TC_CoolDownCheck.PT := (xTOF_WCTC_CoolDown.PT - T#2m);								
			xTP_TC_CoolDownCheck.IN :=	bTC_CoolDownRun
									OR	xF_TRIG_TC_CoolDown_EmStop_Fire.Q;							(* A1031 or A1054 during engine run = prior to start of TC post-cooling*) 
			
			xTON_TC_CoolDownInterrupt.IN := xTP_TC_CoolDownCheck.Q									(* check water flow *)
										AND NOT IN_AG.tFS_ECW.Di
										AND IN_AG.tFS_ECW.GoodQual;
		
		ELSE
			xTP_TC_CoolDownCheck.PT := (xTON_TL_OP_Ein.PT - T#2m);
			xTP_TC_CoolDownCheck.IN := (bTC_CoolDownRun AND (iCnt_TL = 0)) 							(* normal TC post-cooling run - first (long) cooling phase *)(* --- 624tstc, WCTC + OCTC --- *)
									OR	xF_TRIG_TC_CoolDown_EmStop_Fire.Q;							(* A1031 or A1054 during engine run = prior to start of TC post-cooling*)
									  
			xTON_TC_CoolDownInterrupt.IN := xTP_TC_CoolDownCheck.Q									(* check water flow and oil pressure level *)
										AND	(	(NOT IN_AG.tFS_ECW.Di AND IN_AG.tFS_ECW.GoodQual)
										 	 OR	((IN_AG.tPr_TC_EOF_After.Ai < Para.rPr_TC_Oil_CoolDownInterrupt_Lo) AND NOT (MM2VIS.bMsg2224 OR MM2VIS.bMsg2433) AND Para.bPr_TCOaF_Active)	);	

		END_IF;
	
	ELSIF NOT Para.bTC_watercooled AND NOT (xEngType.Type3 OR xEngType.Type2) THEN					(* --- Type 4+6: purely oil-cooled TC --- *)
		xTP_TC_CoolDownCheck.PT := (xTOF_OCTC_CoolDown.PT - T#2m);
		xTP_TC_CoolDownCheck.IN :=	bTC_CoolDownRun
								OR	xF_TRIG_TC_CoolDown_EmStop_Fire.Q;								(* A1031 or A1054 during engine run = prior to start of TC post-cooling*)  
		
		xTON_TC_CoolDownInterrupt.IN :=	xTP_TC_CoolDownCheck.Q										(* check oil pressure level for oil-cooled TC *)
									AND	(IN_AG.tPr_EngLubOil.Ai < Para.rPr_TC_Oil_CoolDownInterrupt_Lo)
									AND NOT MM2VIS.bMsg2103;

	ELSIF Para.bTC_watercooled THEN																	(* --- Type 3+4+6: purely water-cooled TC --- *)
		xTP_TC_CoolDownCheck.PT := (xTOF_WCTC_CoolDown.PT - T#2m);
		xTP_TC_CoolDownCheck.IN :=	bTC_CoolDownRun
								OR	xF_TRIG_TC_CoolDown_EmStop_Fire.Q;								(* A1031 or A1054 during engine run = prior to start of TC post-cooling*)
								  
		xTON_TC_CoolDownInterrupt.IN :=	xTP_TC_CoolDownCheck.Q										(* check water flow *)
									AND	NOT IN_AG.tFS_ECW.Di
									AND IN_AG.tFS_ECW.GoodQual;
	ELSE
		xTON_TC_CoolDownInterrupt.IN := FALSE;
	END_IF;

	(* FUBs for TC post-cooling interruption *)
	xTON_TC_CoolDownInterrupt(PT := T#1m);
	xR_TRIG_TC_CoolDownInterrupt(CLK := xTON_TC_CoolDownInterrupt.Q);
	
	(* FUB for TC post-cooling monitoring *)
	xTP_TC_CoolDownCheck(); 									(* represents monitoring duration of the TC post-cooling *)
	IF EDGENEG(bTC_CoolDownRun) AND M_HDREHZ THEN				(* reset of post-cooling monitoring duration, if engine start during interval cooldown program *)
		xTP_TC_CoolDownCheck(IN:= FALSE, PT:= T#0s); 
	END_IF;				

	(* bit for detecting TC black shutdowns by PLC powerfails *)
	IF xTP_TC_CoolDownCheck.Q OR M_HDREHZ THEN
		iSt_TC_PwrInterrupt.0 := TRUE;							(* variable to detect TC black shut-downs by PLC power fail, DINT to match memory size of spare perm's (REAL perm variable lengths must not change *)
	ELSIF IN_AG.tPB2MM.bSys_Run THEN
		iSt_TC_PwrInterrupt.0 := FALSE;
	END_IF;
	xF_TRIG_TC_CoolDownCheck(CLK := xTP_TC_CoolDownCheck.Q);

	
	(* evaluate average oil pressure during continuous TC post-cooling phase *)
	IF xEngType.Type9 THEN
		IF xTP_TC_CoolDownCheck.Q THEN
			(* collect data from pressure measured by sensor downstream the oil filter during 18min of post-cooling *)	
			iCnt_TC_Avg := iCnt_TC_Avg + 1;
			rPr_TCLubOil_Cum := rPr_TCLubOil_Cum + tPr_TCLubOil_Min.Ai;				(* cumulated pressure data *)
		END_IF;

		xGR_MINR_TC_CoolDownInterrupt(In := tPr_TCLubOil_Min.Ai, Gw := Para.rPr_TC_Oil_CoolDownInterrupt_Lo, Hy := 0.1);								(* threshold and hysteresis for multiple pressure losses condition *)
		xCTU_TC_CoolDownInterrupt(CU := (xGR_MINR_TC_CoolDownInterrupt.Q AND xTP_TC_CoolDownCheck.Q), RESET := xF_TRIG_TC_CoolDownCheck.Q, PV := 3);	(* more than 2 interruptions lead to counter increase, regardless of durations *)
		xR_TRIG_TC_CoolDownInterrupt_Cnt(CLK := xCTU_TC_CoolDownInterrupt.Q);
		
		(* calculate average oil pressure at the end of the continuous cooling phase *)
		IF xF_TRIG_TC_CoolDownCheck.Q THEN
			IF (iCnt_TC_Avg > 0) AND ((Para.bPr_Oil_LPTC_In_A AND NOT MM2VIS.bMsg2624) OR (Para.bPr_Oil_LPTC_In_B AND NOT MM2VIS.bMsg2625))  THEN
				rPr_TCLubOil_Avg := rPr_TCLubOil_Cum / INT_TO_REAL(iCnt_TC_Avg);
			ELSE
				rPr_TCLubOil_Avg :=	Para.rPr_TC_EOF_After_Avg_Lo + 0.1;
			END_IF;	
			
			(* reset *)
			iCnt_TC_Avg 		:= 0;
			rPr_TCLubOil_Cum 	:= 0;
		END_IF;
	END_IF;
	
	
	(* reset trigger bits *)
	IF NOT xTP_TC_CoolDownCheck.Q AND NOT xF_TRIG_TC_CoolDownCheck.Q THEN
		bTC_CoolDownInterrupt 			:= TRUE; 
		xTON_TC_CoolDownInterrupt.IN 	:= FALSE;
	END_IF;

	(* check for fulfilled conditions for TC cooling interruption and set counters accordingly *)
	IF bTC_CoolDownInterrupt AND	(	(xTP_TC_CoolDownCheck.Q AND xR_TRIG_TC_CoolDownInterrupt.Q)								(* oil pressure/water flow interrupted too long during post-cooling *)
									 OR	(xEngType.Type9	AND	(	(xTP_TC_CoolDownCheck.Q AND xR_TRIG_TC_CoolDownInterrupt_Cnt.Q)	(* multiple pressure interruptions during post-cooling *)
															 OR	(	xF_TRIG_TC_CoolDownCheck.Q 
																AND	(rPr_TCLubOil_Avg < Para.rPr_TC_EOF_After_Avg_Lo)			(* average oil pressure at the end of post-cooling phase below threshold *)
																AND	NOT (EDGENEG(bTC_CoolDownRun) AND M_HDREHZ)					(* no engine restart *)
															   	)															))) THEN	
		iCnt_TC_abs 	:= iCnt_TC_abs + 1;															(* absolute counter *)
		iCnt_TC_rel_A 	:= iCnt_TC_rel_A + 1;														(* relative counter for failed TC post-cooling at bank A *)
		iCnt_TC_rel_B 	:= iCnt_TC_rel_B + 1;														(* relative counter for failed TC post-cooling at bank B *)

		bTC_CoolDownInterrupt := FALSE;																(* ensure that the counters are increased only once per TC post-cooling cycle *)
	END_IF;
	
	
	(* check if failed post-cooling detected and write to VISU *)
	IF ABS(iCnt_TC_abs - VIS2MM.iCnt_TC_abs) <= 1 THEN
		VIS2MM.iCnt_TC_abs := iCnt_TC_abs;
	END_IF;
	IF ABS(iCnt_TC_rel_A - VIS2MM.iCnt_TC_rel_A) <= 1 THEN
		VIS2MM.iCnt_TC_rel_A := iCnt_TC_rel_A;
	END_IF;
	IF ABS(iCnt_TC_rel_B - VIS2MM.iCnt_TC_rel_B) <= 1 THEN
		VIS2MM.iCnt_TC_rel_B := iCnt_TC_rel_B;
	END_IF;
	IF ABS(iCnt_TC_abs_RSP - VIS2MM.iCnt_TC_abs_RSP) <= 1 THEN
		VIS2MM.iCnt_TC_abs_RSP := iCnt_TC_abs_RSP;
	END_IF;
	
	(*-------------------------------------------------------------------------------*)

END_PROGRAM
