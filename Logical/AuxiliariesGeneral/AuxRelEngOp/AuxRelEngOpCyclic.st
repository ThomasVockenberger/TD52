(********************************************************************
release engine operation from auxiliaries 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	06.07.1998	Pa			erstellt
 		24.11.1998	Pa			korrekturlesung
V11		04.07.2000	Pa			eigener Baustein für Br4
V170	08.03.2002	LH			Freigabe Netzstartgerät
V184	04.02.2004	LH			RM Gemischkühlwasserpumpe aus FGHBT gelöscht
V206	22.06.2004	LH			Überbrückung Vorschmierzeit nur bei reinem Notstrom
V2071	03.03.2005	LH			Es müssen immer beide Gasstrecken OK sein!
V190	24.07.2004	LH			Freigabe durch Hilfsbetriebe optimiert 
V2201	04.06.2007	LH			RM Heizwasserpumpe mit Betrieb überbrückt 
 		08.08.2007	LH			Fehlerbehebung Überbrückung Vorschmierzeit für Notstr. 
V230	16.01.2008	LH			Letzte Änderung wieder rückgängig gemacht
 								(Probleme im Handbetrieb) 
 		15.02.2008	LH			Behebung Fehlauslösung "Störung Hilfsbetriebe"
V2.50.0	03.03.2009	lettenb.	FG_HBT1-x was IN_AG.tRelAux.Di
V3.10.0	15.03.2010	lettenb.	UB_VORS: sel_black_start_15s, other_gen_parallel added (steiger joh.)	
V3.99.0	14.02.2013	lettenb.	IN_AG.bGasMix_Ref(M_GM_Ref) removed, not supported from MM gas mixer
V3.99   28.02.2013	Pankaj		Generated for modular software with changes for V3.30
V3.99.1 15.03.2013	pankajrodey	Changes for V3.40
V3.99.2	20.03.2013	Denk		IN_AG.bER_VentColdCountryMode --> Para.bER_VentColdCountryMode
								IN_AG.bGasMix_Ref deleted
		28.05.2013	lettenb.	bTestEnabled Para -> loc.var
V4.01.0	25.06.2014				ZM_HBT2: AND NOT IN_AG.bEng_Bloc_SGM added(ex M_GM_Ref, sondergasmischer);
V4.01.1 13.02.2015	lettenb.	920 oilskid + blowby integration
V4.03.0 25.07.2015	Plattner	ZM_HBT2 added IN_AG.tAuxV_ModIf_ok.Di AND IN_AG.tAuxV_Aux_ok.Di for release auxiliaries
V4.04.0 23.01.2017  Stary       line 84-89: modified release auxiliaries depending on louvers
V4.05.0 30.06.2017	lettenb.	ZM_HBT2: IN_AG.bFS_Act added, fast start preparation, cleanup
V4.05.1 19.03.2018				xTON_MonFS added, monitoring for fast start					
V4.06.0	19.06.2018	Perktold,	Louvers closed messages in case of fast start integrated
V4.07.0	09.08.2018	Schmid		ZM_HBT3: IN_AG.tCC2WP_Op.Di added - 2nd low temperature charge cooling circuit
		25.02.2019	Stary/lett. bAuxRel_FireProtFlaps: FireProtFlap feedback signals included in aux.release, safety case
V4.10.0	20.07.2020	Schmid		allow fast start without ECWP_Op feedback
v4.13.0	21.11.2023 	Tinello		BugFix #1236 no engine start in preheating mode
		07.12.2023 	Tinello		BugFix #918  Consider different types of in- and outlet louvers
		28.10.2024 	Nagy		QC2509 Start preparation keeps running issue fix
V4.14.0	06.02.2025	Tinello		SafetyPLC: Gas leakage control behaves now differently
V4.25.0	23.11.2025	Tinello		SafetyPLC: Gas leakage control extended with gas train 3, 4 and DCGA (Decentral gas addition)

Instructions for use:
--------------------

Outstandings:
------------
*********************************************************************************************)
PROGRAM _CYCLIC
	
	(* Safe reset when closing Gas valve *)
	xF_TRIG_GV_On(CLK:= IN_AG.bGV_On);
	
	(* auxilary operation missing *)
	xTON_AT26(IN:= IN_AG.bEng_Aux_Dem, PT:= T#175s);
	AT26 := xTON_AT26.Q;
	
	xTON_AT26_PB(IN:= NOT xF_TRIG_GV_On.Q AND IN_AG.bEng_Aux_Dem, PT:= T#175s);
	AT26_PB := xTON_AT26_PB.Q;
	
	(* elongation start speed signal *)
	xTOF_V_DREHZ(IN:= M_DREHZ, PT:= T#60s);
	V_DREHZ := xTOF_V_DREHZ.Q;
	
	(* delayed release during switch over from OFF->HAND/AUTO *)
	xTON_T114(IN := bOMSS_MAT	OR ( 		 IN_AG.bGT1_Check 
									 AND NOT IN_AG.bMsg1027 
									 AND     IN_AG.bGT2_Check 
									 AND NOT IN_AG.bMsg1029 
									 AND NOT V_DREHZ
									 AND NOT IN_AG.bMsg3359
									 AND NOT IN_AG.bMsg3360 
									 AND NOT IN_AG.bMsg3361 ), PT:= T#30s);
	bT114 := xTON_T114.Q;
	
	(* check safety loop ok *)(* T94 *)
	xTON_SafetyLoopEngOk(IN:= IN_AG.tSafetyLoop_Eng.Di, PT:= T#5s); 
	bSafetyLoopEngOk := xTON_SafetyLoopEngOk.Q;
	
	(* delayed monitoring after faststart *)
	xTON_MonFS(IN:= IN_AG.bEng_Aux_Dem, PT:= T#30s);

	(* Release with Auxilary operation (without monitoring) *)
	IF Para.bER_VentColdCountryMode THEN 
		bAuxRel_Louvers := IN_AG.tOutAirER_LouOpened.Di;
		bAuxRel_FireProtFlaps := IN_AG.tFireProtFlap1_OutlAir_Opened.Di AND IN_AG.tFireProtFlap2_OutlAir_Opened.Di;
	ELSE								 
		IF IN_AG.bFS_Act AND NOT xTON_MonFS.Q THEN
			bAuxRel_Louvers := (IN_AG.tOutAirER_LouOpened.Di OR NOT IN_AG.tOutAirER_LouClosed.Di OR IN_AG.Pos_OutlLou1_OK OR IN_AG.Pos_OutlLou2_OK) AND 
												(IN_AG.tInAirER_Lou1Opened.Di OR NOT IN_AG.tInAirER_Lou1Closed.Di OR IN_AG.Pos_InlLou1_OK  OR IN_AG.Pos_InlLou2_OK);
			bAuxRel_FireProtFlaps := (IN_AG.tFireProtFlap1_InlAir_Opened.Di OR NOT IN_AG.tFireProtFlap1_InlAir_Closed.Di) AND
									 (IN_AG.tFireProtFlap2_InlAir_Opened.Di OR NOT IN_AG.tFireProtFlap2_InlAir_Closed.Di) AND 
									 (IN_AG.tFireProtFlap1_OutlAir_Opened.Di OR NOT IN_AG.tFireProtFlap1_OutlAir_Closed.Di) AND 
									 (IN_AG.tFireProtFlap2_OutlAir_Opened.Di OR NOT IN_AG.tFireProtFlap2_OutlAir_Closed.Di);
		ELSE
			bAuxRel_Louvers := (IN_AG.tOutAirER_LouOpened.Di OR IN_AG.Pos_OutlLou1_OK OR IN_AG.Pos_OutlLou2_OK) AND
												(IN_AG.tInAirER_Lou1Opened.Di OR IN_AG.Pos_InlLou1_OK  OR IN_AG.Pos_InlLou2_OK);
			bAuxRel_FireProtFlaps := IN_AG.tFireProtFlap1_InlAir_Opened.Di AND IN_AG.tFireProtFlap2_InlAir_Opened.Di AND 
															IN_AG.tFireProtFlap1_OutlAir_Opened.Di AND IN_AG.tFireProtFlap2_OutlAir_Opened.Di;
		END_IF;
	END_IF;

	ZM_HBT2 :=		IN_AG.tRelAuxNoMon.Di 
			AND	  ((IN_AG.tRelAux.Di AND IN_AG.tAuxV_ModIf_ok.Di AND IN_AG.tAuxV_Aux_ok.Di) OR bNoMon4BlackStart)
			AND     bAuxRel_Louvers		
			AND		bAuxRel_FireProtFlaps
            AND    (IN_AG.bEG_ByVaOpened OR     IN_AG.bEG_BoVaOpened  OR (IN_AG.bFS_Act AND NOT xTON_MonFS.Q))
			AND    (IN_AG.bGT_Rel        OR NOT IN_AG.bGT_TypSwhActive) 
			AND NOT IN_AG.bEng_Bloc_SGM;

	
	(* delayed monitoring after faststart *)
	xTON_ECWP_MonFS(IN:= IN_AG.bEng_Aux_Dem, PT:= T#10s);
	
	(* Release with Auxilary operation (sep.monitored) *)
	ZM_HBT3 :=	ZM_HBT2	AND(   (IN_AG.tCCWP_Op.Di AND IN_AG.tCC2WP_Op.Di AND IN_AG.tHWP_Op.Di	AND IN_AG.tECWP_Op.Di)
	                        OR (IN_AG.tEng_Run.Do												AND IN_AG.tECWP_Op.Di)
	                        OR	bNoMon4BlackStart
							OR (IN_AG.bFS_Act AND NOT xTON_ECWP_MonFS.Q));
	
	OUT_AG.bEngAuxMon := ZM_HBT2 AND (ZM_HBT3 OR IN_AG.tEng_Run.Do);

	//11
	(* The feedback from the gas leakage check is now interrupted by opening the gas valve *)												(* SAFETY PLC *)
	ZM_HBT4 :=  ZM_HBT3 AND (IN_AG.bGT1_SafeDevOK    		OR 	   IN_AG.bSafetyPLC_Active OR IN_AG.bGT1_CheckOK OR IN_AG.tGV1_Open.Do)		(* SAFETY PLC *)
	                    AND (IN_AG.tGT2_SafeDevOK.Di 		OR 	   IN_AG.bSafetyPLC_Active OR IN_AG.bGT2_CheckOK OR IN_AG.tGV2_Open.Do)		(* SAFETY PLC *)
			    		AND (IN_AG.bSafeOUT_GT1_SafeDevOK	OR NOT IN_AG.bSafetyPLC_Active 						 OR IN_AG.tGV1_Open.Do)		(* SAFETY PLC *)
	                    AND (IN_AG.bSafeOUT_GT2_SafeDevOK	OR NOT IN_AG.bSafetyPLC_Active 						 OR IN_AG.tGV2_Open.Do)		(* SAFETY PLC *)
	                    AND (IN_AG.bSafeOUT_GT3_SafeDevOK	OR NOT IN_AG.bSafetyPLC_Active 						 OR IN_AG.tGV3_Open.Do)		(* SAFETY PLC *)
	                    AND (IN_AG.bSafeOUT_GT4_SafeDevOK	OR NOT IN_AG.bSafetyPLC_Active 						 OR IN_AG.tGV4_Open.Do)		(* SAFETY PLC *)
	                    AND (IN_AG.bSafeOUT_DCGA_SafeDevOK	OR NOT IN_AG.bSafetyPLC_Active 						 OR IN_AG.tDCGA_GV_Open.Do);(* SAFETY PLC *)

	//12
	IF xEngType.Type9 THEN
		ZM_HBT5_Temp1 :=  ZM_HBT4 AND (IN_AG.bRelEngOp_OilSkid OR M_DREHZ OR IN_AG.bFS_Act);
		ZM_HBT5_Temp2 := (IN_AG.tN2_GV1_Closed.Di AND (IN_AG.tN2_GV2_Closed.Di OR NOT Para.bSel_TwoN2Valves)) OR NOT IN_AG.bRel_ScavN2;
		ZM_HBT5 := ZM_HBT5_Temp1 AND ZM_HBT5_Temp2;
	ELSIF (xEngType.Type2 OR xEngType.Type3 OR xEngType.Type4 OR xEngType.Type6) THEN
		ZM_HBT5_Temp1 :=  ZM_HBT4 AND (IN_AG.tMainsStartDevOk.Di OR M_DREHZ);
		ZM_HBT5_Temp2 := (IN_AG.tN2_GV1_Closed.Di AND (IN_AG.tN2_GV2_Closed.Di OR NOT Para.bSel_TwoN2Valves)) OR NOT IN_AG.bRel_ScavN2;
		ZM_HBT5 := ZM_HBT5_Temp1 AND ZM_HBT5_Temp2;
	END_IF;
	
	(* bypass prelubrication time in case of emergency power demand *)
	IF (xEngType.Type2 OR xEngType.Type3 OR xEngType.Type4) THEN
		UB_VORS_Temp1 := (Para.bBS_Acc_Active AND NOT IN_AG.bOtherGenParallel) OR NOT IN_AG.bOnly_Island;
		OUT_AG.bJmpPLTime := ((IN_AG.bEng_Dem_EPS AND UB_VORS_Temp1) OR OUT_AG.bJmpPLTime) AND IN_AG.bEng_Aux_Dem;	
	END_IF;
	
	IF xEngType.Type9 THEN
			xTOF_T6(IN:= 	ZM_HBT5
						AND(M_HDREHZ OR bPreLube_EngStaRel OR OUT_AG.bPreL_FS_EngStaRel)
						AND(M_HDREHZ OR IN_AG.tBbBlower_FC_Rdy.Di) 
						AND bT114 
						AND bSafetyLoopEngOk 
						AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#12s);
		IF NOT IN_AG.bEng_Aux_Dem OR (NOT bPreLube_EngStaRel AND NOT M_HDREHZ AND NOT OUT_AG.bPreL_FS_EngStaRel) THEN	//reset
			xTOF_T6(IN:= FALSE, PT:= T#0s);
		END_IF;

		OUT_AG.bRelEngOp_Aux := xTOF_T6.Q;

	ELSIF xEngType.Type6 THEN
			xTOF_T6(IN:= 	ZM_HBT5
						AND(M_HDREHZ OR bPreLube_EngStaRel) 
						AND bT114 
						AND bSafetyLoopEngOk 
						AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#12s);
		IF NOT IN_AG.bEng_Aux_Dem THEN	//reset
			xTOF_T6(IN:= FALSE, PT:= T#0s);
		END_IF;

		OUT_AG.bRelEngOp_Aux := xTOF_T6.Q;

	ELSIF (xEngType.Type2 OR xEngType.Type3) THEN
			xTOF_T6(IN:= 	ZM_HBT5 		(* Elongated Release Auxilary operation *)
						AND(M_HDREHZ OR bPreLube_EngStaRel OR OUT_AG.bJmpPLTime OR NOT Para.bEngTyp3_Prelub_Active) 
						AND bT114 
						AND bSafetyLoopEngOk 
						AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#12s);
		IF NOT IN_AG.bEng_Aux_Dem THEN	//reset
			xTOF_T6(IN:= FALSE, PT:= T#0s);
		END_IF;

		OUT_AG.bRelEngOp_Aux := xTOF_T6.Q;
	
	ELSIF (xEngType.Type4) THEN
			xTOF_T6(IN:= 	ZM_HBT5 		(* Elongated Release Auxilary operation *)
						AND(M_HDREHZ OR bPreLube_EngStaRel OR OUT_AG.bJmpPLTime) 
						AND bT114 
						AND bSafetyLoopEngOk 
						AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#12s);
		IF NOT IN_AG.bEng_Aux_Dem THEN	//reset
			xTOF_T6(IN:= FALSE, PT:= T#0s);
		END_IF;

		OUT_AG.bRelEngOp_Aux := xTOF_T6.Q;
	END_IF;
	MM2VIS.bRelEngOp_Aux		:= OUT_AG.bRelEngOp_Aux;


END_PROGRAM                                                           