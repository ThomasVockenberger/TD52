(*******************************************************************************
Vent_ER			ventilation engine room 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	04.07.1998	Pa			erstellt
 		24.11.1998	Pa			korrekturlesung
V170	06.02.2002	LH			Erfassung Raumtemperatur
V172	02.07.2002	LH			Ventilatoransteuerung, Variante ohne Jalousien
V173	13.11.2002	LH			Einlesen des Analogeinganges in pb17 verlegt
V180	25.02.2003	LH			überarbeitet, Grenzwerte über Rezept
 								Notkühler --> Kühler und erweitert auf 4 Stufen
 								Gemischkühler neu und in 4 Stufen
V181	13.05.2003	LH			Initialisierung für Kühler (Schrittkette)
 		05.06.2003	LH			GW Raumtemperatur angepasst
 		24.06.2003	LH			Gemischkühler in 3 Stufen
V182	04.08.2003	LH			Erfassung Ansauglufttemperatur
V183	25.11.2003	LH			Gemischkühler wieder in 4 Stufen
 								Variante Kombikühler eingeführt
V184	12.01.2004	LH			Ventilation bei Messignal Raumtemperatur
V206	22.06.2004	LH			Raumlüftung NEU aufgrund von Synchronisierproblemen
V207	23.09.2004	LH			20 min. Nachlauf der geregelten Ventilation (Kruckenhauser)
 								Ansauglufttemperatur aktiviert
V2071	05.02.2005	LH			Aktivierung Messtelle Raumtemperatur über Parameter
 		23.02.2005	LH			Nachlauf der geregelten Ventilation nur mit Anforderung Hilfsbetriebe! (Egger)
V2073b	16.05.2006	LH			Lüftung 100% auch bei Gasalarm
V190	09.09.2004	LH			Raumtemperatur und Ansauglufttemperatur --> eigene tasks
 								Lüftung im Stillstand erst mit 40°C
V210	08.09.2004	LH			Variante Raumlüftung für kalte Länder
 								Initialisierung Kühlerschrittkette erweitert auf 11 Regler
 		16.11.2005	LH			Ansteuerung Frequenzumformer bei Gasvoralarm bzw. N2-Spuelung korrigiert 
V230	24.01.2008	LH			wegen Einführung Gemischkühlerschrittkette 4-stufigen Gemischkühler gelöscht
V2.34.0	15.10.2008	lettenb.	M_NKWD replaced with M_NKWD_W
V3.10.0	17.02.2010	lettenb.	MRL_FU: EINS -> bAirInVentF(parameter) fehlerbehebung(bruno plattn.)
.								(W2120 störg.raumlüftg.kommt wenn keine raumlüftung)
V3.20.0	30.09.2010	maier(BuR)	M_GSEIN replaced with GCB_ON
.		17.12.2010	lettenb.	purge cycle added, K_var/K_anz/Anz_anfhbt/K_reg setting from parameter
V3.30.0	14.09.2011	lettenb.	FG_FU: dmnd_purge added (bugfix)
V3.99.0 15.02.2013	lettenb.	pb3_VE renamed to Vent_ER
V4.00.0	08.04.2015				FG_FU:(var.with louvers) Para.bER_VentColdCountryMode 'NOT' added(bugfix)
V4.02.0 03.08.2015  Stary       FG_FU: added variant with 2 controlled inlet+outlet louvers 
		07.08.2015  Denk		Manual operating auxiliaries control functionality added
		13.08.2015	lettenb.	OUT_VE.tRel_ER_Fan.Do: var.for noFU added(undef.demand ZJAL2 with gcb.on/off)(hackel)
        09.12.2015  Stary       line 189-192: modified variable for louver feedback check
V4.04.0 20.05.2016	lettenb.	tDemPurgeER.Do added, bugfix
V4.04.0 27.09.2016  Stary       Task modified with introduction of cases for the variant-management engine room ventilation
		24.10.2016  Stary       changed parameters for release engine-room ventilation depending on analog position-feedback louvers - bugfix
		21.12.2016  Stary       modification of code after software-test on simulator
		23.01.2017  Stary       modification of code after test with WINMODE (bugfix)
		27.02.2017  Stary       added AND NOT IN_VE.bMsg1031 in release FC (bugfix)
		03.03.2017  lettenb.    added AND NOT IN_VE.bMsg1054 in release FC (bugfix)
		08.05.2017	lettenb.	FG_FU, tRel_ER_FC logic corr., bugfix
V4.05.0 20.09.2017	Messner		Active Cooling Program added
V4.07.0 25.02.2019	lettenb.	bERV_NotRdy engine room ventilation not ready - block engine start added, PWR-FFI-2018-0637 gem. TA 1100-0110 
		13.05.2019	lettenb.	ANF_LUE: room vent.active with RTM40(not just minimum fan speed) and extended cooldown time after engine stop
		17.09.2019	lettenb.	ZJAL2: man.aux.control if only 1 inair louver is active, bugfix
V4.10.0	22.12.2020	lettenb.	config VAR.21/22: analog louvers with fix speed fans(set ZJAL1,ZJAL2,AJAL for this config.)
		25.01.2021	lettenb.	engine room ventilation not ready - block engine start: OUT_VE.bERV_NotRdy moved to task MsgVE, bugfix
V4.11.0	23.11.2021	lettenb.	processed signales to AuxRelEngOp (release engine operation) depending on louvers configuration, bugfix
V4.13.0 25.09.2023	Bacci		added IN_VE.tAuxV_Supply_Ok.Di in release FC
		05.12.2023	Bacci		Added ventilation demand before starting the ingition selftest and exhaust scavenging. New DO for inlet louvers demand for customer
V4.14.0 25.11.2024	Bacci		T6 Start procedure with purge start (2024-219): added ventilation demand before purge cranking cycle during fast start preparation 
V4.25.0 26.11.2025	Bacci		Safety Function - Insufficient Ventilation (2024-202): reactivation of cold county function and safety plausibility check added

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* parameter *)
	Para.bLouvers;					(* engine room ventilation with louvers *)
	Para.bER_VentColdCountryMode;	(* engine room ventilation cold country mode *)
	Para.bVISA;						(* monitoring according VISA *)


	(*----------------------------------------------------------------------------------------------*)
	(* start ventilation *)
	RTM25 := bT_AirER_Hi1 OR IN_VE.tT_AirER_Ext_Hi1.Di OR IN_VE.bACP_AirER_Dem;

	(* ventilation stage 2 *)
	RTM30 := bT_AirER_Hi2 OR IN_VE.tT_AirER_Ext_Hi2.Di;

	(* start ventilation at stopped engine *)
	RTM40 := bT_AirER_Hi4 OR IN_VE.bACP_AirER_Dem;
	
	(* demand engine room ventilation for purge cycle *)
	dmnd_purge	:=	Para.bPurgecycle_Active 
				AND(IN_VE.bEng_Dem OR IN_VE.bGV_On);

	OUT_VE.tDemPurgeER.Do := dmnd_purge;

	(* signal failure for engine room ventilation *)
	IF Para.bER_VentColdCountryMode THEN
		MS_LUE	:= (IN_VE.bAMM_T_Ch_T1LP_Avg AND IN_VE.bEng_Aux_Dem_CDR)
				OR  MM2VIS.bMsg3152;
	ELSE
		MS_LUE	:=  MM2VIS.bMsg3152;
	END_IF;

	
	(* purge cycle time *)
	xTON_purgecycle(IN:= OUT_VE.tRel_ER_FC.Do AND NOT MM2VIS.bMsg2120 AND NOT MM2VIS.bMsg2795 AND NOT MM2VIS.bMsg2796, PT:= T#60s);
	OUT_VE.bPurgeER_Rdy := IN_VE.tAirER_FS.Di AND xTON_purgecycle.Q;
	
	
	(* Demand engine room ventilation *)
	ANF_LUE	:= IN_VE.bEng_Aux_Dem_CDR
			OR dmnd_purge
			OR IN_VE.bACP_AirER_Dem
			OR RTM40;

	
	(* fan speed minimum *)
	OUT_VE.tSet_ER_Fan_Min.Do := (IN_VE.bEng_Aux_Dem OR dmnd_purge) 
						  AND NOT IN_VE.tGCB_On.Di;
	
	
	(* release increased ventilation intensity *)
	IF Para.bInAirER_Fan_FU OR Para.bOutAirER_Fan_FU THEN
		OUT_VE.tRel_ER_Fan.Do := ANF_LUE AND NOT OUT_VE.tSet_ER_Fan_Min.Do;
	ELSE
		OUT_VE.tRel_ER_Fan.Do := ANF_LUE;
	END_IF;

	(* inlet louvers demand for customer. Ventilation in our scope *)
	OUT_VE.tDemERVentInLou_Cust.Do := IN_VE.bInLouDemIgn OR IN_VE.bInLouDemEX OR IN_VE.bInLouDemAG;
	

	IF IN_VE.bSafetyPLC_Active AND NOT Para.bSafe_ERV_Cust_Active THEN
		(* Cold country mode active for safety PLC *)
		OUT_VE.bERV_ColdCountry := Para.bER_VentColdCountryMode AND NOT (bT_InAirER_LimHi_Lou OR RTM40 OR MS_LUE);
	
		(*----------------------------------------------------------------*)
		(* safety plausibility check for inlet, outlet louvers and fans *)
		(*----------------------------------------------------------------*)
		(* Minimum release conditions for safety plausibility checks *)
		bRel_ERV_SafeCheck_Min := 	NOT IN_VE.bEng_Aux_Dem_CDR									(* CDR done*)
								AND NOT dmnd_purge												(* Engine room purge done *)
								AND NOT IN_VE.bInLouDemIgn										(* Ignition self test done*)
								AND NOT IN_VE.bInLouDemEX										(* Exhaust gas scavenging done *)
								AND NOT IN_VE.bInLouDemAG										(* Inlet louver demended for purge cycle during fast start preparation *)
								AND NOT (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)		(* Nitrogen scavenging done*)
								AND NOT IN_VE.bMsg1054											(* No fire alarm *)
								AND NOT IN_VE.bMsg1031											(* No emergency stop*)
								AND NOT IN_VE.bMsg1052											(* No gas prealarm *)
								AND NOT IN_VE.bMsg1053;											(* No gas alarm *)
	
		(* Extended release conditions for safety plausibility checks *)
		bRel_ERV_SafeCheck_Ext := 		bRel_ERV_SafeCheck_Min
								AND NOT MS_LUE										(* No engine room or engine intake temparture MSF *)
								AND NOT OUT_VE.bMsg2705								(* No engine room differential pressure MSF *)
								AND NOT RTM40										(* High engine room temperature at engine stop *)
								AND NOT IN_VE.tManAuxCtr.bInAirER_Lou1DemOpen 		(* No inlet louvers 1 manual request *)
								AND NOT IN_VE.tManAuxCtr.bInAirER_Lou2DemOpen		(* No inlet louvers 2 manual request *)
								AND NOT IN_VE.tManAuxCtr.bOutAirER_LouDemOpen		(* No outlet louvers manual request *)
								AND NOT IN_VE.tManAuxCtr.bER_FC_Set;				(* No ventilation fan frequency converter manual request *)
	
		(* engine stopped within 50 min *)
		xTOF_EngStop_SafeCheck(IN:= IN_VE.bEng_Aux_Dem_CDR, PT:= T#50m);
	
		(* reset plausibility check status *)
		xR_TRIG_bERV_SafeCheck_OK_Rset(CLK := IN_VE.bEng_Aux_Dem_CDR);
		IF xR_TRIG_bERV_SafeCheck_OK_Rset.Q THEN
			bERV_SafeCheck_OK := FALSE;
		END_IF;
	
		(* General release for safety plauibility checks *)
		bRel_ERV_SafeCheck := (bRel_ERV_SafeCheck_Ext OR (bRel_ERV_SafeCheck_Min AND (NOT xTOF_EngStop_SafeCheck.Q OR IN_VE.bERV_PC_Forced))) AND xOpMode.Stop;	
		xR_TRIG_bRel_ERV_SafeCheck(CLK := bRel_ERV_SafeCheck);

		(* break safe plausibility check in case minimum release requirement not fulfilled or extended release not fulfilled while engine stopped within 50 minutes and no check force from safety PLC *)
		IF NOT bRel_ERV_SafeCheck THEN
			iStepCnt_SafeCheck := 0;
		(* activate safe plausibility check in case of extended release conditions fulfilled or minimum release condition fulfilled and engine stopped longer than 50 min or heck force from safety PLC *)
		ELSIF xR_TRIG_bRel_ERV_SafeCheck.Q AND NOT bERV_SafeCheck_OK THEN	
			iStepCnt_SafeCheck := 10;
		END_IF;
	
		(*----------------------------------------------------------------*)
		IF iStepCnt_SafeCheck = 0 THEN
			bERV_SafeCheck_CloseLou	:= FALSE;
			bERV_SafeCheck_OpenLou	:= FALSE;
			OUT_VE.bERV_Lou_PC_OP	:= FALSE;
			OUT_VE.bERV_Lou_PC_CL 	:= FALSE;
			xTON_ERV_SafeCheck_CloseLou(IN:= FALSE, PT:= T#0s);
			xTON_ERV_SafeCheck_OpenLou(IN:= FALSE, PT:= T#0s);
		END_IF;
	
		(*----------------------------------------------------------------*)
		(* Step 1: close louvers for 3 minutes*)
		IF iStepCnt_SafeCheck = 10 THEN
			bERV_SafeCheck_CloseLou	:= TRUE;
			xTON_ERV_SafeCheck_CloseLou.IN := TRUE;
			xTON_ERV_SafeCheck_CloseLou.PT :=  T#180s;
	
			IF xTON_ERV_SafeCheck_CloseLou.Q THEN
				bERV_SafeCheck_CloseLou	:= FALSE;
				xTON_ERV_SafeCheck_CloseLou.IN := FALSE;
				xTON_ERV_SafeCheck_CloseLou.PT :=  T#0s;
				iStepCnt_SafeCheck := iStepCnt_SafeCheck + 10;
			END_IF;
		END_IF;
		(*----------------------------------------------------------------*)
		(* Step 2: open louvers for 3 minutes*)
		IF iStepCnt_SafeCheck = 20 THEN
			bERV_SafeCheck_OpenLou	:= TRUE;
			OUT_VE.bERV_Lou_PC_OP := TRUE;
			xTON_ERV_SafeCheck_OpenLou.IN := TRUE;
			xTON_ERV_SafeCheck_OpenLou.PT :=  T#180s;
	
			IF xTON_ERV_SafeCheck_OpenLou.Q THEN
				bERV_SafeCheck_OpenLou	:= FALSE;
				OUT_VE.bERV_Lou_PC_OP := FALSE;
				xTON_ERV_SafeCheck_OpenLou.IN := TRUE;
				xTON_ERV_SafeCheck_OpenLou.PT :=  T#0s;
				iStepCnt_SafeCheck := iStepCnt_SafeCheck + 10;
			END_IF;
		END_IF;
	 		
		(*----------------------------------------------------------------*)
		(* Step 3: close louvers for 3 minutes*)
		IF iStepCnt_SafeCheck = 30 THEN
			bERV_SafeCheck_CloseLou	:= TRUE;
			OUT_VE.bERV_Lou_PC_CL := TRUE;
			xTON_ERV_SafeCheck_CloseLou.IN := TRUE;
			xTON_ERV_SafeCheck_CloseLou.PT :=  T#180s;
	
			IF xTON_ERV_SafeCheck_CloseLou.Q THEN
				bERV_SafeCheck_CloseLou	:= FALSE;
				OUT_VE.bERV_Lou_PC_CL := FALSE;
				xTON_ERV_SafeCheck_CloseLou.IN := FALSE;
				xTON_ERV_SafeCheck_CloseLou.PT :=  T#0s;
				bERV_SafeCheck_OK := TRUE;
				iStepCnt_SafeCheck := 0;
			END_IF;
		END_IF;
	 		
		(*----------------------------------------------------------------*)
	ELSE
		OUT_VE.bERV_ColdCountry :=FALSE;
		bERV_SafeCheck_CloseLou := FALSE;
		bERV_SafeCheck_OpenLou := FALSE;
		OUT_VE.bERV_Lou_PC_OP := FALSE;
		OUT_VE.bERV_Lou_PC_CL := FALSE;
		xTON_ERV_SafeCheck_CloseLou(IN:= FALSE, PT:= T#0s);
		xTON_ERV_SafeCheck_OpenLou(IN:= FALSE, PT:= T#0s);
	END_IF;

		(* Call of the FUB *)
		xTON_ERV_SafeCheck_CloseLou();
		xTON_ERV_SafeCheck_OpenLou();

(*---------------------------------------------------------- INLET LOUVERS HANDLING -----------------------------------------------------------------------------------*)
// 	CONTROL-TYPE
	Para.iTypeCtr_InlLou_ERV; 		// (0-2)  0 ... no control of louvers 
							  		//        1 ... engine room inlet louvers 1+2 demanded (DO)
							  		//        2 ... inlet louvers controlled (AO)
//	FEEDBACK-TYPE
	Para.iTypeFeedback_InlLou_ERV; 	// (0-2)  0 ... no feedback-signals
								   	//        1 ... feedback signals digital (DI)
								   	//        2 ... feedback signals analog (AI)
	
	
   	(* HANDLING OF CASES FOR RELEASE ROOM-VENTILATION *)
	iValueInlLou := Para.iTypeCtr_InlLou_ERV * 10 + Para.iTypeFeedback_InlLou_ERV; // according to this value the variants will run into the fitting case
	
	//		0 ... no control and no feedback
	//	   11 ... louvers demanded, feedback signal digital
	//     12 ... louvers demanded, feedback signal analog
	//     21 ... louvers controlled, feedback signal digital
	//     22 ... louvers controlled, feedback signal analog

	CASE iValueInlLou OF
	
	// ------------------------------------ no control and no feedback ----------------------------------------------------------------------- 		
	  0:    
		 	IN_VE.tInAirER_Lou1Opened.Di	:=	IN_VE.tInAirER_Lou1Opened.Di OR	NOT IN_VE.tInAirER_Lou1Opened.GoodQual; 
			IN_VE.tInAirER_Lou2Opened.Di	:=	IN_VE.tInAirER_Lou2Opened.Di OR	NOT IN_VE.tInAirER_Lou2Opened.GoodQual;
	
			(* needed for demand air inlet fan 1 (fix-speed) *)
			ZJAL1 	:=(((bT_InAirER_LimHi_Lou OR NOT Para.bER_VentColdCountryMode) AND (IN_VE.bEng_Aux_Dem_CDR OR dmnd_purge))
					OR	RTM40
					OR	MS_LUE
					OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
					OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
					OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
					OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
					OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
					AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

			OUT_VE.tInAirER_Lou1DemOpen.Do	:= (ZJAL1 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031)
											OR	IN_VE.bMsg1052
											OR	IN_VE.bMsg1053;
		
			(* needed for demand air inlet fan 2 (fix-speed) *)
			IF Para.bInAirER_Fan_FU THEN
				ZJAL2	:=(((bT_InAirER_LimHi_Lou OR NOT Para.bER_VentColdCountryMode) AND (IN_VE.bEng_Aux_Dem_CDR OR dmnd_purge))
						OR	RTM40
						OR	MS_LUE
						OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
						OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
						OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)
						
			ELSE
				ZJAL2	:= ((RTM30 AND OUT_VE.tRel_ER_Fan.Do)
						OR	MS_LUE
						OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
						OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
						OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)				
			END_IF;
		
			OUT_VE.tInAirER_Lou2DemOpen.Do	:= (ZJAL2 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031) 
											OR	IN_VE.bMsg1052
											OR	IN_VE.bMsg1053;
	   
			(* release engine room ventilation case 0 *)
			FG_FU_InlLou_Case0	:=	NOT IN_VE.bMsg1054 
								AND NOT IN_VE.bMsg1031
								AND	  (((bOMSS_MAT AND IN_VE.bEng_Aux_Dem_CDR)
									OR (bOMSS_MAT AND dmnd_purge)
									OR (bOMSS_MAT AND RTM40)
									OR (bOMSS_MAT AND MM2VIS.bMsg3152)
									OR (IN_VE.bRel_ScavN2 AND IN_VE.bInAirER_FanSet100)
									OR  IN_VE.tManAuxCtr.bER_FC_Set)(* Manual operating auxiliaries control - Handbedienebene *)
									AND NOT bERV_SafeCheck_CloseLou) (* louver /fan off for safety plausibility check*)
									OR IN_VE.bMsg1052 
									OR IN_VE.bMsg1053;
				
	// ------------------------------------- louvers demanded, feedback signal digital -------------------------------------------------------	
	 11: 
		    (* demand engine room air inlet louver 1 *)
	     	ZJAL1 	:=(((bT_InAirER_LimHi_Lou OR NOT Para.bER_VentColdCountryMode) AND (IN_VE.bEng_Aux_Dem_CDR OR dmnd_purge))
					OR	RTM40
					OR	MS_LUE
					OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
					OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
					OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
					OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
					OR  IN_VE.tManAuxCtr.bInAirER_Lou1DemOpen			(* Manual operating auxiliaries control - Handbedienebene *)
					OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
					AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

		 	OUT_VE.tInAirER_Lou1DemOpen.Do	:= (ZJAL1 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031)
											OR	IN_VE.bMsg1052
											OR	IN_VE.bMsg1053;
		
			(* demand engine room air inlet louver 2 *)
			IF Para.bInAirER_Fan_FU THEN
				ZJAL2	:=(((bT_InAirER_LimHi_Lou OR NOT Para.bER_VentColdCountryMode) AND (IN_VE.bEng_Aux_Dem_CDR OR dmnd_purge))
						OR	RTM40
						OR	MS_LUE
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
						OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
						OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
						OR (IN_VE.tManAuxCtr.bInAirER_Lou1DemOpen AND NOT Para.bInAirER_Lou2_visible)	(* only 1 inlet louver active *)
						OR  IN_VE.tManAuxCtr.bInAirER_Lou2DemOpen			(* Manual operating auxiliaries control - Handbedienebene *)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)
			ELSE
				ZJAL2	:= ((RTM30 AND OUT_VE.tRel_ER_Fan.Do)
						OR	MS_LUE
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
						OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
						OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
						OR (IN_VE.tManAuxCtr.bInAirER_Lou1DemOpen AND NOT Para.bInAirER_Lou2_visible)	(* only 1 inlet louver active *)
						OR  IN_VE.tManAuxCtr.bInAirER_Lou2DemOpen			(* Manual operating auxiliaries control - Handbedienebene *)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)
			END_IF;
		
			OUT_VE.tInAirER_Lou2DemOpen.Do	:= (ZJAL2 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031)
											OR	IN_VE.bMsg1052
											OR	IN_VE.bMsg1053;
			
			(* release engine room ventilation case 11 *)
			IN_VE.tInAirER_Lou2Opened.Di	:=	IN_VE.tInAirER_Lou2Opened.Di OR	NOT IN_VE.tInAirER_Lou2Opened.GoodQual;
		
			FG_FU_InlLou_Case11 := OUT_VE.tInAirER_Lou1DemOpen.Do AND IN_VE.tInAirER_Lou1Opened.Di
						       AND OUT_VE.tInAirER_Lou2DemOpen.Do AND IN_VE.tInAirER_Lou2Opened.Di;
		
			FG_InlVent_Step1_CtrInlLou := FALSE; // for correct case-change
			FG_InlVent_Step2_CtrInlLou := FALSE; // for correct case-change
		
	// ----------------------------------------- louvers demanded, feedback signal analog ----------------------------------------------------
	 12:   	
			(* demand engine room air inlet louver 1 *)
			ZJAL1 	:=(((bT_InAirER_LimHi_Lou OR NOT Para.bER_VentColdCountryMode) AND (IN_VE.bEng_Aux_Dem_CDR OR dmnd_purge))
					OR	RTM40
					OR	MS_LUE
					OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
					OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
					OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
					OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
					OR  IN_VE.tManAuxCtr.bInAirER_Lou1DemOpen			(* Manual operating auxiliaries control - Handbedienebene *)
					OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
					AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

			OUT_VE.tInAirER_Lou1DemOpen.Do	:= (ZJAL1 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031)
											OR	IN_VE.bMsg1052
											OR	IN_VE.bMsg1053;
				
			(* demand engine room air inlet louver 2 *)
			IF Para.bInAirER_Fan_FU THEN
				ZJAL2	:=(((bT_InAirER_LimHi_Lou OR NOT Para.bER_VentColdCountryMode) AND (IN_VE.bEng_Aux_Dem_CDR OR dmnd_purge))
						OR	RTM40
						OR	MS_LUE
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
						OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
						OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
						OR (IN_VE.tManAuxCtr.bInAirER_Lou1DemOpen AND NOT Para.bInAirER_Lou2_visible)	(* only 1 inlet louver active *)
						OR  IN_VE.tManAuxCtr.bInAirER_Lou2DemOpen			(* Manual operating auxiliaries control - Handbedienebene *)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)
			ELSE
				ZJAL2	:= ((RTM30 AND OUT_VE.tRel_ER_Fan.Do)
						OR	MS_LUE
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	IN_VE.bInLouDemIgn (* inlet louver demended for ignition self test *)
						OR	IN_VE.bInLouDemEX  (* inlet louver demended for scavenging *)
						OR	IN_VE.bInLouDemAG  (* inlet louver demended for purge cycle during fast start preparation *)
						OR (IN_VE.tManAuxCtr.bInAirER_Lou1DemOpen AND NOT Para.bInAirER_Lou2_visible)	(* only 1 inlet louver active *)
						OR  IN_VE.tManAuxCtr.bInAirER_Lou2DemOpen			(* Manual operating auxiliaries control - Handbedienebene *)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)
			END_IF;
			
			OUT_VE.tInAirER_Lou2DemOpen.Do	:= (ZJAL2 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031) 
											OR	IN_VE.bMsg1052
											OR	IN_VE.bMsg1053;
		
			(* check of position from inlet-louvers *)
			xGR_MAXR_InlLou1(In := IN_VE.tPos_InlLou1.Ai, Gw := Para.rPosLim_InlLou_Rel_ERV, Hy := Para.rPosLim_InlLou_Rel_ERV_Hy); 
			xGR_MAXR_InlLou2(In := IN_VE.tPos_InlLou2.Ai, Gw := Para.rPosLim_InlLou_Rel_ERV, Hy := Para.rPosLim_InlLou_Rel_ERV_Hy); 
				
			Pos_InlLou1_OK := Para.bPos_InlLou1_Active AND xGR_MAXR_InlLou1.Q; 
			Pos_InlLou2_OK := Para.bPos_InlLou2_Active AND xGR_MAXR_InlLou2.Q;
			OUT_VE.Pos_InlLou1_OK := Pos_InlLou1_OK; // for release auxiliaries --> monitoring A1129 (AG)
			OUT_VE.Pos_InlLou2_OK := Pos_InlLou2_OK; // for release auxiliaries --> monitoring A1129 (AG)		
		
			(* release engine room ventilation case 12 *)
			FG_FU_InlLou_Case12   := (OUT_VE.tInAirER_Lou1DemOpen.Do AND Pos_InlLou1_OK)
								AND ((OUT_VE.tInAirER_Lou2DemOpen.Do AND Pos_InlLou2_OK) OR NOT Para.bPos_InlLou2_Active);
		
			FG_InlVent_Step1_CtrInlLou := FALSE; // for correct case-change
			FG_InlVent_Step2_CtrInlLou := FALSE; // for correct case-change
		
	// -------------------------------------- louvers controlled, feedback signal digital --------------------------------------------------------------------			
	 21:   	
			(* demand engine room air inlet louver *)
			ZJAL1 	:=((IN_VE.bEng_Aux_Dem_CDR OR dmnd_purge)
					OR	RTM40
					OR	MS_LUE
					OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
					OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
					AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)
					(*OUT_IG.bInLouDemIgn AND OUT_IG.bInLouDemEX AND IN_VE.bInLouDemAG not needed for fan activation. Louver AO signal defined in the Ctr_InlLou*)

			ZJAL2	:= ((RTM30 AND OUT_VE.tRel_ER_Fan.Do)
					OR	MS_LUE
					OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
					OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
					AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

			(* release engine room ventilation case 21 *)
			IN_VE.tInAirER_Lou2Opened.Di := IN_VE.tInAirER_Lou2Opened.Di OR	NOT IN_VE.tInAirER_Lou2Opened.GoodQual;
	
			FG_FU_InlLou_Case21   := Para.bCtr_InlLou AND IN_VE.tInAirER_Lou1Opened.Di AND IN_VE.tInAirER_Lou2Opened.Di;
		
			(* air inlet fan 1 *)
			Release_InlVent_Step1_INT := (ZJAL1 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031)  // general release ventilation step 1 depending on temperature, gas-alarm etc.
									OR	IN_VE.bMsg1052
									OR	IN_VE.bMsg1053;
			FG_InlVent_Step1_CtrInlLou := Release_InlVent_Step1_INT AND Para.bCtr_InlLou AND IN_VE.tInAirER_Lou1Opened.Di; 	// fix-speed inlet-fan 1
			
			(* air inlet fan 2 *)
			Release_InlVent_Step2_INT := (ZJAL2 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031)  // general release ventilation step 2 depending on temperature, gas-alarm etc.
									OR	IN_VE.bMsg1052
									OR	IN_VE.bMsg1053;
			FG_InlVent_Step2_CtrInlLou := Release_InlVent_Step2_INT AND Para.bCtr_InlLou AND IN_VE.tInAirER_Lou1Opened.Di AND IN_VE.tInAirER_Lou2Opened.Di;  // fix-speed inlet-fan 2
			
			OUT_VE.tInAirER_Lou1DemOpen.Do := FALSE; // for correct case-change
			OUT_VE.tInAirER_Lou2DemOpen.Do := FALSE; // for correct case-change
		
	// --------------------------------------- louvers controlled, feedback signal analog ---------------------------------------------------------------------		
	 22:   
			(* demand engine room air inlet louver *)
			ZJAL1 	:=((IN_VE.bEng_Aux_Dem_CDR OR dmnd_purge)
					OR	RTM40
					OR	MS_LUE
					OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
					OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
					AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)
					(*OUT_IG.bInLouDemIgn AND OUT_IG.bInLouDemEX AND IN_VE.bInLouDemAG not needed for fan activation. Louver AO signalo defined in the Ctr_InlLou*)

			ZJAL2	:= ((RTM30 AND OUT_VE.tRel_ER_Fan.Do)
					OR	MS_LUE
					OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
					OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
					AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

			(* check of position from inlet-louvers *)
			xGR_MAXR_InlLou1(In := IN_VE.tPos_InlLou1.Ai, Gw := Para.rPosLim_InlLou_Rel_ERV, Hy := Para.rPosLim_InlLou_Rel_ERV_Hy); 
			xGR_MAXR_InlLou2(In := IN_VE.tPos_InlLou2.Ai, Gw := Para.rPosLim_InlLou_Rel_ERV, Hy := Para.rPosLim_InlLou_Rel_ERV_Hy); 
				
			Pos_InlLou1_OK := Para.bPos_InlLou1_Active AND xGR_MAXR_InlLou1.Q; 
			Pos_InlLou2_OK := Para.bPos_InlLou2_Active AND xGR_MAXR_InlLou2.Q;
			OUT_VE.Pos_InlLou1_OK := Pos_InlLou1_OK; // for release auxiliaries --> monitoring A1129 (AG)
			OUT_VE.Pos_InlLou2_OK := Pos_InlLou2_OK; // for release auxiliaries --> monitoring A1129 (AG)	
		
			(* release engine room ventilation CASE 22 *)
			FG_FU_InlLou_Case22   := Para.bCtr_InlLou AND Pos_InlLou1_OK AND (Pos_InlLou2_OK OR NOT Para.bPos_InlLou2_Active);
			
			(* air inlet fan 1 *)
			Release_InlVent_Step1_INT := (ZJAL1 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031)  // general release ventilation step 1 depending on temperature, gas-alarm etc.
									OR	IN_VE.bMsg1052
									OR	IN_VE.bMsg1053;
			FG_InlVent_Step1_CtrInlLou := Release_InlVent_Step1_INT AND Para.bCtr_InlLou AND Pos_InlLou1_OK;  // fix-speed inlet-fan 1
			
			(* air inlet fan 2 *)
			Release_InlVent_Step2_INT := (ZJAL2 AND NOT IN_VE.bMsg1054 AND NOT IN_VE.bMsg1031)  // general release ventilation step 2 depending on temperature, gas-alarm etc.
									OR	IN_VE.bMsg1052
									OR	IN_VE.bMsg1053;
			FG_InlVent_Step2_CtrInlLou := Release_InlVent_Step2_INT AND Para.bCtr_InlLou AND Pos_InlLou1_OK AND (Pos_InlLou2_OK OR NOT Para.bPos_InlLou2_Active);  // fix-speed inlet-fan 2		
			
			OUT_VE.tInAirER_Lou1DemOpen.Do := FALSE; // for correct case-change
			OUT_VE.tInAirER_Lou2DemOpen.Do := FALSE; // for correct case-change
	
	END_CASE;	

	
(*---------------------------------------------------------- OUTLET LOUVERS HANDLING -----------------------------------------------------------------------------------*)
// 	CONTROL-TYPE
	Para.iTypeCtr_OutlLou_ERV; 		// (0-2)  0 ... no control of louvers 
							   		//        1 ... engine room outlet louvers 1+2 demanded (DO)
							   		//        2 ... outlet louvers controlled (AO)
//	FEEDBACK-TYPE
	Para.iTypeFeedback_OutlLou_ERV; // (0-2)  0 ... no feedback-signals
									//        1 ... feedback signals digital (DI)
									//        2 ... feedback signals analog (AI)
	
	
	(* HANDLING OF CASES FOR RELEASE ROOM-VENTILATION *)
	iValueOutlLou := Para.iTypeCtr_OutlLou_ERV*10 + Para.iTypeFeedback_OutlLou_ERV; // according to this value the variants will run into the fitting case

	//		0 ... no control and no feedback
	//	   11 ... louvers demanded, feedback signal digital
	//     12 ... louvers demanded, feedback signal analog
	//     21 ... louvers controlled, feedback signal digital
	//     22 ... louvers controlled, feedback signal analog

	CASE iValueOutlLou OF
		
		// --------------------------------------- no control and no feedback ------------------------------------------------------------		
		0:    
				IN_VE.tOutAirER_LouOpened.Di := IN_VE.tOutAirER_LouOpened.Di OR	NOT IN_VE.tOutAirER_LouOpened.GoodQual;
		
				(* needed for demand air inlet fan 1+2 (fix-speed) *)
				AJAL	:=	(IN_VE.bEng_Aux_Dem_CDR
						OR	dmnd_purge 
						OR	RTM40 
						OR	MS_LUE
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)
						
				OUT_VE.tOutAirER_LouDemOpen.Do	:= (AJAL AND NOT IN_VE.bMsg1031 AND NOT IN_VE.bMsg1054)
												OR	IN_VE.bMsg1052
												OR	IN_VE.bMsg1053;
		
				(* release engine room ventilation case 0 *)
				FG_FU_OutLou_Case0	:=	NOT IN_VE.bMsg1054 
									AND NOT IN_VE.bMsg1031
									AND	  (((bOMSS_MAT AND IN_VE.bEng_Aux_Dem_CDR)
										OR (bOMSS_MAT AND dmnd_purge)
										OR (bOMSS_MAT AND RTM40)
										OR (bOMSS_MAT AND MM2VIS.bMsg3152)
										OR (IN_VE.bRel_ScavN2 AND IN_VE.bInAirER_FanSet100)
										OR  IN_VE.tManAuxCtr.bER_FC_Set) (* Manual operating auxiliaries control - Handbedienebene *)
										AND NOT bERV_SafeCheck_CloseLou) (* louver /fan off for safety plausibility check*)
										OR IN_VE.bMsg1052 
										OR IN_VE.bMsg1053;
			
	
	
	// ---------------------------------------louvers demanded, feedback signal digital -----------------------------------------------------------	
		11: 
				(* demand engine room air outlet louvers *)
				AJAL	:=	(IN_VE.bEng_Aux_Dem_CDR
						OR	dmnd_purge 
						OR	RTM40 
						OR	MS_LUE 
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR  IN_VE.tManAuxCtr.bOutAirER_LouDemOpen			(* Manual operating auxiliaries control - Handbedienebene *)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

				OUT_VE.tOutAirER_LouDemOpen.Do	:= (AJAL AND NOT IN_VE.bMsg1031 AND NOT IN_VE.bMsg1054)
												OR	IN_VE.bMsg1052
												OR	IN_VE.bMsg1053;
					
				(* Release engine room ventilation case 12 *)
				FG_FU_OutlLou_Case11 := OUT_VE.tOutAirER_LouDemOpen.Do AND IN_VE.tOutAirER_LouOpened.Di;
		
				FG_InlVent_Step12_CtrOutlLou := FALSE; // for correct case-change						
	
	// ---------------------------------------- louvers demanded, feedback signal analog -----------------------------------------------------------
		12:   	
				(* demand engine room air outlet louvers *)
				AJAL	:=	(IN_VE.bEng_Aux_Dem_CDR
						OR	dmnd_purge 
						OR	RTM40 
						OR	MS_LUE 
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR  IN_VE.tManAuxCtr.bOutAirER_LouDemOpen			(* Manual operating auxiliaries control - Handbedienebene *)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

				OUT_VE.tOutAirER_LouDemOpen.Do	:= (AJAL AND NOT IN_VE.bMsg1031 AND NOT IN_VE.bMsg1054)
												OR	IN_VE.bMsg1052
												OR	IN_VE.bMsg1053;								
			
				(* check of position from outlet-louvers *)
				xGR_MAXR_OutlLou1(In:= IN_VE.tPos_OutlLou1.Ai, Gw:= Para.rPosLim_OutlLou_Rel_ERV, Hy:= Para.rPosLim_OutlLou_Rel_ERV_Hy); 
				xGR_MAXR_OutlLou2(In:= IN_VE.tPos_OutlLou2.Ai, Gw:= Para.rPosLim_OutlLou_Rel_ERV, Hy:= Para.rPosLim_OutlLou_Rel_ERV_Hy); 
								
				Pos_OutlLou1_OK := Para.bPos_OutlLou1_Active AND xGR_MAXR_OutlLou1.Q; 
				Pos_OutlLou2_OK := Para.bPos_OutlLou2_Active AND xGR_MAXR_OutlLou2.Q;
				OUT_VE.Pos_OutlLou1_OK := Pos_OutlLou1_OK; // for release auxiliaries --> monitoring A1129 (AG)
				OUT_VE.Pos_OutlLou2_OK := Pos_OutlLou2_OK; // for release auxiliaries --> monitoring A1129 (AG)	
	
				(* release engine room ventilation case 12 *)
				FG_FU_OutlLou_Case12	:= OUT_VE.tOutAirER_LouDemOpen.Do AND Pos_OutlLou1_OK AND (Pos_OutlLou2_OK OR NOT Para.bPos_OutlLou2_Active);
		
				FG_InlVent_Step12_CtrOutlLou := FALSE; // for correct case-change	
		
	// ------------------------------------------- louvers controlled, feedback signal digital --------------------------------------------------------- 			
		21:   	
				(* demand air inlet fan 1+2 (fix-speed) *)
				AJAL	:=	(IN_VE.bEng_Aux_Dem_CDR
						OR	dmnd_purge 
						OR	RTM40 
						OR	MS_LUE
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

				(* release engine room ventilation case 21 *)
				FG_FU_OutlLou_Case21	:= (Para.bCtr_OutlLou_RDP OR Para.bCtr_OutlLou_RT) AND IN_VE.tOutAirER_LouOpened.Di;
			
				(* air inlet fan 1+2 *)			
			    Release_InlVent_StepINT	:= (AJAL AND NOT IN_VE.bMsg1031 AND NOT IN_VE.bMsg1054)	// general release ventilation step 1 depending on temperature, gas-alarm etc.
										OR	IN_VE.bMsg1052
										OR	IN_VE.bMsg1053;
				FG_InlVent_Step12_CtrOutlLou := Release_InlVent_StepINT AND (Para.bCtr_OutlLou_RDP OR Para.bCtr_OutlLou_RT) AND IN_VE.tOutAirER_LouOpened.Di;  // fix-speed inlet-fan 1+2
			
				OUT_VE.tOutAirER_LouDemOpen.Do := FALSE; // for correct case-change
		
	// -------------------------------------------- louvers controlled, feedback signal analog ---------------------------------------------------------		
		22:   
				(* demand air inlet fan 1+2 (fix-speed) *)
				AJAL	:=	(IN_VE.bEng_Aux_Dem_CDR
						OR	dmnd_purge 
						OR	RTM40 
						OR	MS_LUE
						OR (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2)
						OR	bERV_SafeCheck_OpenLou) (* louver demand for safety plausibility check*)
						AND NOT bERV_SafeCheck_CloseLou; (* louver closed for safety plausibility check*)

				(* check of position from outlet-louvers *)
				xGR_MAXR_OutlLou1(In:= IN_VE.tPos_OutlLou1.Ai, Gw:= Para.rPosLim_OutlLou_Rel_ERV, Hy:= Para.rPosLim_OutlLou_Rel_ERV_Hy); 
				xGR_MAXR_OutlLou2(In:= IN_VE.tPos_OutlLou2.Ai, Gw:= Para.rPosLim_OutlLou_Rel_ERV, Hy:= Para.rPosLim_OutlLou_Rel_ERV_Hy); 
								
				Pos_OutlLou1_OK := Para.bPos_OutlLou1_Active AND xGR_MAXR_OutlLou1.Q; 
				Pos_OutlLou2_OK := Para.bPos_OutlLou2_Active AND xGR_MAXR_OutlLou2.Q;
				OUT_VE.Pos_OutlLou1_OK := Pos_OutlLou1_OK; // for release auxiliaries --> monitoring A1129 (AG)
				OUT_VE.Pos_OutlLou2_OK := Pos_OutlLou2_OK; // for release auxiliaries --> monitoring A1129 (AG)	
	
				(* release engine room ventilation CASE 22 *)
				FG_FU_OutlLou_Case22	:= (Para.bCtr_OutlLou_RDP OR Para.bCtr_OutlLou_RT) AND Pos_OutlLou1_OK AND (Pos_OutlLou2_OK OR NOT Para.bPos_OutlLou2_Active);
				
				(* air inlet fan 1+2 *)			
				Release_InlVent_StepINT	:= (AJAL AND NOT IN_VE.bMsg1031 AND NOT IN_VE.bMsg1054)	// general release ventilation step 1 depending on temperature, gas-alarm etc.
										OR	IN_VE.bMsg1052
										OR	IN_VE.bMsg1053;		
				FG_InlVent_Step12_CtrOutlLou := Release_InlVent_StepINT AND (Para.bCtr_OutlLou_RDP OR Para.bCtr_OutlLou_RT) 
											AND Pos_OutlLou1_OK AND (Pos_OutlLou2_OK OR NOT Para.bPos_OutlLou2_Active);	// fix-speed inlet-fan 1+2
			
				OUT_VE.tOutAirER_LouDemOpen.Do := FALSE; // for correct case-change
		
	END_CASE;		

(*------------------------ CASE CHECK FOR RELEASE ENGINE ROOM VENTILATION -----------------------------------------*)	
	(* Inlet ventilation *)
	FG_FU_InlLou_ZW := (FG_FU_InlLou_Case0  AND iValueInlLou = 0)
					OR (FG_FU_InlLou_Case11 AND iValueInlLou = 11)
					OR (FG_FU_InlLou_Case12 AND iValueInlLou = 12)
					OR (FG_FU_InlLou_Case21 AND iValueInlLou = 21) 
					OR (FG_FU_InlLou_Case22 AND iValueInlLou = 22);
	
	(* Outlet ventilation *)
	FG_FU_OutlLou_ZW := (FG_FU_OutLou_Case0  AND iValueOutlLou = 0)
					 OR (FG_FU_OutlLou_Case11 AND iValueOutlLou = 11)
					 OR (FG_FU_OutlLou_Case12 AND iValueOutlLou = 12)
					 OR (FG_FU_OutlLou_Case21 AND iValueOutlLou = 21) 
					 OR (FG_FU_OutlLou_Case22 AND iValueOutlLou = 22);
	

(*---------------------------------------------------------- ROOM VENTILATION FAN HANDLING -----------------------------------------------------------------------------------*)		
	
		(* air inlet fan 1 *)
		OUT_VE.tInAirER_Fan1DemOn.Do :=	(((OUT_VE.tInAirER_Lou1DemOpen.Do OR IN_VE.tManAuxCtr.bInAirER_Fan1DemOn) AND IN_VE.tInAirER_Lou1Opened.Di) OR FG_InlVent_Step1_CtrInlLou) 
									AND (((OUT_VE.tOutAirER_LouDemOpen.Do OR IN_VE.tManAuxCtr.bInAirER_Fan1DemOn) AND IN_VE.tOutAirER_LouOpened.Di) OR FG_InlVent_Step12_CtrOutlLou);
									
		(* air inlet fan 2 *)
		OUT_VE.tInAirER_Fan2DemOn.Do := (((OUT_VE.tInAirER_Lou2DemOpen.Do OR IN_VE.tManAuxCtr.bInAirER_Fan2DemOn) AND IN_VE.tInAirER_Lou2Opened.Di) OR FG_InlVent_Step2_CtrInlLou)
									AND (((OUT_VE.tOutAirER_LouDemOpen.Do OR IN_VE.tManAuxCtr.bInAirER_Fan2DemOn) AND IN_VE.tOutAirER_LouOpened.Di) OR FG_InlVent_Step12_CtrOutlLou);				 			
	
		(* release frequency converter for engine room ventilation (inlet/outlet) *)
	    

		IF IN_VE.tManAuxCtr.bER_FC_Set THEN				(* Manual operating auxiliaries control - Handbedienebene *)
			FG_FU	:=	NOT IN_VE.bMsg1031
					AND NOT IN_VE.bMsg1054
					AND		FG_FU_InlLou_ZW 
					AND 	FG_FU_OutlLou_ZW
					AND		IN_VE.tAuxV_Supply_Ok.Di;
		ELSE
			FG_FU	:=	NOT IN_VE.bMsg1031
					AND NOT IN_VE.bMsg1054
					AND		FG_FU_InlLou_ZW
					AND 	FG_FU_OutlLou_ZW
					AND		IN_VE.tAuxV_Supply_Ok.Di;
		END_IF;
		OUT_VE.tRel_ER_FC.Do := FG_FU OR IN_VE.bMsg1052 OR IN_VE.bMsg1053 OR (IN_VE.bACP_AirER_Dem AND NOT bERV_SafeCheck_CloseLou);
		
		(* demand fixed fan speed *)
		FU_FIX		:=     (MS_LUE AND OUT_VE.tRel_ER_Fan.Do) 
					OR		bT_AirER_Hi 
					OR	NOT	IN_VE.tT_AirER_Ext_Hi.Di
					OR 	   (IN_VE.bInAirER_FanSet100 AND IN_VE.bRel_ScavN2) 
					OR		IN_VE.bMsg1052 OR IN_VE.bMsg1053;
			
		bCtrER_YFix := OUT_VE.tRel_ER_FC.Do AND FU_FIX;
	
(*---------------------------------------------------------------------------*)
	(* release engine room temperature controller *)
	(* see task: Ctr_ER *)
(*---------------------------------------------------------------------------*)
	(* open or not closed inlet louvers release from ventilation for ignition and exhaust*)
	IF iValueInlLou =0 THEN
		OUT_VE.bInLouRelVE := IN_VE.tInAirER_Lou1Opened.Di OR IN_VE.tInAirER_Lou2Opened.Di;
	ELSE
		OUT_VE.bInLouRelVE := (IN_VE.tInAirER_Lou1Opened.Di AND IN_VE.tInAirER_Lou1Opened.GoodQual) OR ((NOT IN_VE.tInAirER_Lou1Closed.Di) AND IN_VE.tInAirER_Lou1Closed.GoodQual) OR
							  (Pos_InlLou1_OK AND IN_VE.tPos_InlLou1.GoodQual) OR
							  (IN_VE.tInAirER_Lou2Opened.Di AND IN_VE.tInAirER_Lou2Opened.GoodQual) OR ((NOT IN_VE.tInAirER_Lou2Closed.Di) AND IN_VE.tInAirER_Lou2Closed.GoodQual) OR
							  (Pos_InlLou2_OK AND IN_VE.tPos_InlLou2.GoodQual);
	END_IF;
	
(*---------------------------------------------------------------------------*)
	(* processed signales to AuxRelEngOp (release engine operation) depending on louvers configuration *)
	OUT_VE.tInAirER_Lou1Opened.Di := IN_VE.tInAirER_Lou1Opened.Di;	
	OUT_VE.tInAirER_Lou2Opened.Di := IN_VE.tInAirER_Lou2Opened.Di;
	OUT_VE.tOutAirER_LouOpened.Di := IN_VE.tOutAirER_LouOpened.Di;

END_PROGRAM
