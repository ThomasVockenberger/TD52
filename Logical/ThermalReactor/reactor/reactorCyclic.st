 (*******************************************************************************
reactor		THERMOREACTOR

This code is confidential AND proprietary TO the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission OF the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------

History:
-------
V15 	27-09-2001	Thaler, generated
V180	06-03-2003	Thaler, TR_ON_moduleTR, TR_OPER_moduleTR added. Connection to recipe REACTOR.
                            FGDRPS_moduleTR from FRG_GASREG_moduleTR --> reactor_a.
                            reactor_a --> TRW08.
V203	05-09-2003	Thaler, Modifications so that compatible with DIA.NE XT:
							y_HE_ramp INT --> UINT (reason: AS V2.3)
							Filter: 3 --> 10 (reason: AT664)
							DI_x: Value defined (reason: disabling #40 at Package Test).
							TK1, TK2 local --> global (reason: diagnosis for Development).
V210	28-09-2004	Thaler, TempInTR_moduleTR, TempOutTR_moduleTR, y_HE_Prom_moduleTR added.
							TK_GAS_OFF added.
							FG_HEIZG_moduleTR local --> global.
							TK_GAS.IN   := TK1_TK2_MIN; (war TK1_TK2_MIT).
							AN_PGW1 --> FG_TH_moduleTR.
V210.1	23-05-2006	Thaler, bExhReactor_moduleTR, Spuelluft-Ventil added.
V220    21-12-2007  Thaler, --> X20: variables declaration,
                            calculation Tvgl_moduleTR, iAT6402ETCreactor_moduleTR. 
V220.2  27-05-2008  Thaler, DO_HE_xy added, TP_BTRB 180" --> DO_GAS_MINUS_moduleTR, ...
V250    12-03-2009  Thaler, UM_E_NEU_moduleTR: new position switches added.
                            TK_GAS_OFF settings changed.
V2.50.1 08-07-2009  Thaler, Spuelluft-Ventil modified.
                            Compensation_AI_TK_moduleTR added.
V3.20.0 11-03-2011  Thaler, with/without gas injection added:
                              sel_woGas: TK_w, TKx_y_HI_Gw, FRG_GASREG_moduleTR, PTON_KL_AUS
                              TK_w_woGas: TK_w
                              set_PT_KL_Pinc: PTON_KL_AUS
                              PT_KL_Pinc: PTON_KL_AUS.
                            alarm reset:
                              alarms unlatched for XT_Version_32x added
                              DI_QUITT_LT deleted (used for stand alone version only).
                            replaced variables:
                              M_GS_EIN --> DI_GCB_ON_moduleTR, NS_EIN -->  DI_MCB_ON_moduleTR
                            Spuelluft-Ventil modified: 
                              TON_SPLU_AKT_AUS/EIN: 60s --> 10s
                              TON_SPLU_DEAKT: 60s --> 30s
V3.20.1 10-06-2011  Thaler, variabled deleted for simplifying Modular Software.
    	10-06-2011	Thaler, last modification
                            NOT compatible with other XT Versions !!
   	
V04.00.00.00 	03-04-2014  Ganguly		HALio signals for 5 postion feedback and 4 postion feedback have same name,
							 			 in case of 4 position Mid-position feedback remains unconnected.
V04.03.00.00	25-09-2014	Denk		Bugfix, Flap switching time (INT/REAL casting)
										 Bugfix, KL_EIN renamed with OUT_TR.bThR_Val_SetIn
										 TRW01 : "FUEHLERBRUCH", TRW01_TempInOut and TRW01_Tvgl deleted
										 Bugfix, Sammelstoerung Reaktor Stop und Reaktor Stop + Motor Stop
V04.07.00.00	27-05-2019	Denk		Adjustments regarding new library versions (JEW_LIB1, JEW_LIB2, JEW_LIB3)
V04.09.00.00	09-03-2020	Denk		Bugfix, input variable changed in function xTON_TK1_DIF()
V04.12.00.00	19-05-2022	Maran		Bugfix: updated electrical heating elements switching logic and trigger signal for hour counter,
										 Bugfix: absolute value used for max. temperature difference detection in reactor vessel n.2,
										 Bugfix: HMI para used for aux.gas injection min. temperature hysteresis instead of fixed value,
										 removed unused TON for electrical heating thresholds detection
				14-06-2022	Maran		Removed unused TON for min.temperature detection to release auxiliary gas injection,
										 removed unused block of auxiliary gas injection release based on upper temperature bound
										 added A2356, A2357, A2358 in collective panel fault indication 
V04.13.00.00	27-03-2023	Maran		Updated operating temperature definition and maximum temperature difference monitoring in TK1 and in TK2 (W3503)
				28-11-2023	Maran		Added W9374, W9375, W9376, W9377, W9381 in collective panel fault indication
V04.14.00.00	27-11-2024	Maran		Added auxiliary gas stop due to sufficient temperature,
										 temperature setpoint reference used in task changed from heating controller out structure value to HMI parameter value
				27-11-2024	Maran		Updates for thermal reactor 2nd generation (ThR2): revision of reactor chamber reference temperature,
										 added control of auxiliary gas solenoid valve before 4-way flap, adapted W3504 and blocked W3503, 
										 added ThR2 chamber temperature signal fault to th.reactor bypass conditions, added ThR2 electrical heating control

Instructions for use:
--------------------

Outstandings:
------------
	FUB fuer ls und ls_t inkl. EN (ENABLE)
*******************************************************************************)
PROGRAM _CYCLIC
	
	xTON_INIT (IN:= TRUE, PT:= T#1m);
	OUT_TR.bThR_Active := xTON_INIT.Q AND IN_TR.tPB2MM.bParaSetupOk AND Para.bThR_Active;
	
	(* TK_moduleTR setpoint *)
	IF Para.bThR_woGas THEN
		TK_w := Para.rT_ThR_SetwoGas;    (* 0,1°C; without gas injection: see task "reac_set" *)
	ELSE
		TK_w := Para.tCtrTR_Heater.W_set;     (* Thermal reactor gas heating controller setpoint parameter *)
	END_IF;
	
	(* Temperature Limits [FB33] *)
	IF Para.bThR_woGas THEN
		TKx_y_HI_Gw       := 850.0;  (* 0,1°C; without gas injection: 850,0°C *)
	ELSE
		TKx_y_HI_Gw       := 800.0;  (* 0,1°C; with gas injection Standard: 800,0°C *)
	END_IF;	
	
	
	(* Klappenumschaltzeit [FB40] *)
	(* Flap switching time *)	
	PT_KL.x1 := REAL_TO_INT(TK_w + Para.rT_ThR_Val_x1);		(* von Rezept, 0,1°C; Standard: 20,0°C *)
	PT_KL.x2 := REAL_TO_INT(TK_w + Para.rT_ThR_Val_x2);		(* von Rezept, 0,1°C; Standard: 40,0°C *)
	PT_KL.y1 := TIME_TO_INT(Para.ti_ThR_Val_y1/1000);		(* von Rezept, Sekunden bei x1; Standard: 180s *)
	PT_KL.y2 := TIME_TO_INT(Para.ti_ThR_Val_y2/1000);		(* von Rezept, Sekunden bei x2; Standard: 360s *)
	
	
	(* Tvgl20_moduleTR von Rezept, 0,1°C; Standard: 0,0°C
	   Hier wird jener Wert angegeben,
	   den das Vergleichsstellenmessgeraet
	   bei 20° Umgebungstemperatur ausgibt. *)
	
	
	(******************************************************************************)
	(* Thermal Reactor temperature failure, min, max *)
	IF NOT Para.bThR2_Ena THEN //with Thermal reactor 1st generation
		MS_TK := (NOT IN_TR.tT_ThR_Chamber1_1.GoodQual) OR
				 (NOT IN_TR.tT_ThR_Chamber1_2.GoodQual) OR
				 (NOT IN_TR.tT_ThR_Chamber2_1.GoodQual) OR
				 (NOT IN_TR.tT_ThR_Chamber2_2.GoodQual);
				
		TK1 := (IN_TR.tT_ThR_Chamber1_1.Ai + IN_TR.tT_ThR_Chamber1_2.Ai)/2;
		TK2 := (IN_TR.tT_ThR_Chamber2_1.Ai + IN_TR.tT_ThR_Chamber2_2.Ai)/2;
	ELSE
		MS_TK := FALSE;
	END_IF
	IF Para.bThR2_Ena THEN //with Thermal reactor 2nd generation
		// individual measurement signal faults are defined with Thermal reactor 2, faults on left and right chamber are also used for reactor bypass
		bThR2_T_fault_ReactChamber := (NOT IN_TR.tThR2_T_UnitOk_RightCh.Di OR NOT IN_TR.tT_ThR2_RightChamber.GoodQual) OR
										(NOT IN_TR.tThR2_T_UnitOk_LeftCh.Di OR NOT IN_TR.tT_ThR2_LeftChamber.GoodQual);
	
		TK1 := IN_TR.tT_ThR2_RightChamber.Ai;
		TK2 := IN_TR.tT_ThR2_LeftChamber.Ai;
	ELSE
		bThR2_T_fault_ReactChamber := FALSE;
	END_IF
	
	TK1_TK2_MIT := (TK1 + TK2) / 2;
	TK1_TK2_MIN := MIN (TK1, TK2);
	TK1_TK2_MAX := MAX (TK1, TK2);
	(******************************************************************************)
	
	(* Steuerprogramm (aus PB4) *)
	
	(* Freigabe Thermoreaktor von Modulsteuerung *)
	(* Release Thermal Reactor from Module controller *)
	xTON_FG_TH (IN:= ((bThR_Rel AND IN_TR.tGCB_On.Di AND IN_TR.tMCB_On.Di) OR bThR_RelTest), PT:= T#30s);
	
	(* Freigabe Abgasklappen-Umschaltung und el. Heizung *)
	FG_KLUM						:= OUT_TR.bThR_Active AND xTON_FG_TH.Q AND
								    IN_TR.tThR_Swth_On.Di AND NOT ST_R_ST AND NOT ST_RM_ST;
	FG_HEIZG_moduleTR			:= FG_KLUM;
	OUT_TR.tThR_Contactor.Do	:= FG_HEIZG_moduleTR;
	OUT_TR.bThR_RelHeat			:= FG_HEIZG_moduleTR;
	
	(* Thermal Reactor auxiliary gas stop due to sufficient temperature *)
	bThr_AuxGasStopT_Ena := NOT Para.bThR_woGas AND Para.bThR_auxGasMonitor AND Para.bCtrThR_Heater_Active AND (TK_w > Para.rT_ThR_LimGas); (* check on parameters consistency *)
	
	xTON_Thr_AuxGasStopT_set(IN := OUT_TR.bThR_RelGas AND (IN_TR.tPos_ThR_AuxGasCV_Act.Ai < rPos_ThR_GasCV_AuxGasStop_max) (*CV essentially closed *) AND
	 IN_TR.tPos_ThR_AuxGasCV_Act.GoodQual AND (TK_moduleTR > TK_w + rT_Thr_AuxGasStopT_rel), PT := tiTON_Thr_AuxGasStopT_set);
	xRS_Thr_AuxGasStopT.SET := xTON_Thr_AuxGasStopT_set.Q; (* activation *)
	
	xTON_Thr_AuxGasStopT_reset(IN := (TK_moduleTR < TK_w), PT := tiTON_Thr_AuxGasStopT_reset);
	xRS_Thr_AuxGasStopT.RESET1 := xTON_Thr_AuxGasStopT_reset.Q OR NOT FG_HEIZG_moduleTR OR NOT bThr_AuxGasStopT_Ena; (* deactivation *)
	
	xRS_Thr_AuxGasStopT();
	
	(* Freigabe Einduesung *)
	OUT_TR.bThR_RelGas     := FG_HEIZG_moduleTR AND xTK_GAS.QH AND NOT Para.bThR_woGas AND NOT xRS_Thr_AuxGasStopT.Q1;
	OUT_TR.tThR_GT_COn1.Do := OUT_TR.bThR_RelGas;
	OUT_TR.tThR_GT_COn2.Do := OUT_TR.bThR_RelGas;
	OUT_TR.bThR_RelGas_Tmin	:= xTK_GAS.QH; (* minimum temperature for gas injection reached *)
	
	(* Betriebsmeldung *)
	OUT_TR.tThR_RunLamp.Do := (FG_KLUM AND (SEK_TAKT OR xTK_OPER.QH)) OR IN_TR.tThR_LampTest.Di;
	
	(* Betriebsmeldungen fuer auftragsbezogene Verwendung *)
	OUT_TR.bThR_Run         := FG_KLUM;               	    (* Reaktor eingeschaltet *)
	OUT_TR.bThR_RunReacTemp := FG_KLUM AND xTK_OPER.QH;	(* Reaktor eingeschaltet, Reaktionstemp. erreicht *)
	
	(* Ansteuerung Spuelluft-Stopp-Ventil, neu hinzu 07-2009 *)
	(* Aktivierung Spuelluft vor Durchfuehrung der Klappenbewegung *)
	PTON_SPLU_AKT_AUS := LIMIT (0, PTON_KL_AUS - T#10s, PTON_KL_AUS);
	PTON_SPLU_AKT_EIN := LIMIT (0, PTON_KL_EIN - T#10s, PTON_KL_EIN);
	xTON_SPLU_AKT_AUS (IN:= OUT_TR.bThR_Val_SetOut, PT:= PTON_SPLU_AKT_AUS);
	xTON_SPLU_AKT_EIN (IN:= OUT_TR.bThR_Val_SetIn, PT:= PTON_SPLU_AKT_EIN);
	
	(* Ansteuerung Spuelluft-Stopp-Ventil, neu hinzu 05-2006, modifiziert 07-2009 *)
	(* Deaktivierung Spuelluft nach Durchfuehrung der Klappenbewegung *)
	xTON_SPLU_DEAKT (IN:= (NOT FG_KLUM OR RM_KL_END), PT := T#30s);
	
	IF xTON_SPLU_DEAKT.Q THEN
		SPLU_AKT := FALSE;
	END_IF;
		
	(* IF FG_KLUM AND NOT OUT_TR.b_ThR_Val_SetIn AND NOT OUT_TR.b_ThR_Val_SetOut THEN *)
	IF (FG_KLUM AND NOT RM_KL_END) OR
	   (FG_KLUM AND (xTON_SPLU_AKT_AUS.Q OR xTON_SPLU_AKT_EIN.Q)) THEN
		SPLU_AKT := TRUE;
	END_IF;
	
	xTOF_W_INT (IN:= (IN_TR.tThR_Swth_On.Di AND xTON_W_ACT.Q), PT := T#10050m);	  (* weekly SPLU interval *)
	xTON_W_ACT (IN:= (IN_TR.tThR_Swth_On.Di AND NOT xTOF_W_INT.Q), PT := T#30m);  (* weekly SPLU active *)
	
	OUT_TR.tThR_Val_Air.Do := NOT (SPLU_AKT OR (IN_TR.tThR_Swth_On.Di AND NOT xTOF_W_INT.Q));	(* Ausgang fuer Spuelluft-Stopp-Ventil, TRUE bei STOP *)
	
	
	(* Klappensteuerung (aus OB13, FB35, FB36) *)
	
	(* Abgasklappe Mittelstellung: *)
	(* Im spannungslosen Zustand der Ansteuerventile geht die Klappe auf Mittelstellung. *)
	IF NOT FG_KLUM AND NOT Para.bSel_FlapActEl THEN
		OUT_TR.tThR_Val_CCylIn.Do  := FALSE;
		OUT_TR.tThR_Val_CCylOut.Do := FALSE;
	END_IF;
	
	(* Klappe Mittelstellung erreicht *)
	RM_KL_MIT :=          IN_TR.tPos_ThR_Val_Mid.Di
	              AND NOT IN_TR.tPos_ThR_Val_In1.Di
		          AND NOT IN_TR.tPos_ThR_Val_In2.Di
		          AND NOT IN_TR.tPos_ThR_Val_Out1.Di
				  AND NOT IN_TR.tPos_ThR_Val_Out2.Di;
	
	(* Abgasklappe Umschaltung: *)
	IF FG_KLUM THEN
		xR_TRIG_KL_AUS (CLK:= OUT_TR.bThR_Val_SetOut);
		xR_TRIG_KL_EIN (CLK:= OUT_TR.bThR_Val_SetIn);
	
		(* Bei positiver Flanke von KL_EIN_moduleTR oder KL_AUS_moduleTR sowie wenn KL_EIN_moduleTR und KL_AUS_moduleTR
		   nicht anstehen, wird die Mittelstellung aktiviert. *)
		IF (xR_TRIG_KL_AUS.Q OR xR_TRIG_KL_EIN.Q OR (OUT_TR.bThR_Val_SetOut AND OUT_TR.bThR_Val_SetIn)) THEN
			OUT_TR.tThR_Val_CCylIn.Do  := FALSE;
			OUT_TR.tThR_Val_CCylOut.Do := FALSE;
		END_IF;
	
		(* Klappe Ausfahren:
		   - Anfahren Mittelstellung durch Y1=0, Y2=0
		   - Rueckmeldung Mittelstellung erreicht: Ausfahren durch Aktivieren von Y2
		   - Ueberwachung:
		     Falls nach 10" die Endlage nicht erreicht wird,
		       "Stoerung Abgasklappe Ende" mit Reaktorabschaltung und
		       Befehl Abgasklappe Mittelstellung.
		     Falls 5" danach die Mittelstellung nicht erreicht wird,
		       "Stoerung Abgasklappe Mittelstellung" mit Gasmotorabstellung. *)
		IF OUT_TR.bThR_Val_SetOut THEN
			OUT_TR.tThR_Val_CCylIn.Do := FALSE;
		END_IF;
			
		IF (OUT_TR.bThR_Val_SetOut AND RM_KL_MIT) THEN
			OUT_TR.tThR_Val_CCylOut.Do := TRUE;
		END_IF;
	
		(* Klappe Einfahren:
		   - Anfahren Mittelstellung durch Y1=0, Y2=0
	   	   - Rueckmeldung Mittelstellung erreicht: Einfahren durch Aktivieren von Y1
		   - Ueberwachung:
		     Falls nach 10" die Endlage nicht erreicht wird,
		       "Stoerung Abgasklappe Ende" mit Reaktorabschaltung und
		       Befehl Abgasklappe Mittelstellung.
		     Falls 5" danach die Mittelstellung nicht erreicht wird,
		       "Stoerung Abgasklappe Mittelstellung" mit Gasmotorabstellung. *)
		IF OUT_TR.bThR_Val_SetIn THEN
			OUT_TR.tThR_Val_CCylOut.Do := FALSE;
		END_IF;
			
		IF (OUT_TR.bThR_Val_SetIn AND RM_KL_MIT) THEN
			OUT_TR.tThR_Val_CCylIn.Do := TRUE;
		END_IF;
	END_IF;
	
	(* Klappe Endlage erreicht *)
	RM_KL_END     := (	OUT_TR.bThR_Val_SetOut
					AND IN_TR.tPos_ThR_Val_Out1.Di
					AND IN_TR.tPos_ThR_Val_Out2.Di
					AND NOT IN_TR.tPos_ThR_Val_In1.Di
					AND NOT IN_TR.tPos_ThR_Val_In2.Di
					AND NOT IN_TR.tPos_ThR_Val_Mid.Di)
				  OR
					(	OUT_TR.bThR_Val_SetIn
					AND IN_TR.tPos_ThR_Val_In1.Di
					AND IN_TR.tPos_ThR_Val_In2.Di
					AND NOT IN_TR.tPos_ThR_Val_Out1.Di
					AND NOT IN_TR.tPos_ThR_Val_Out2.Di
					AND NOT IN_TR.tPos_ThR_Val_Mid.Di);
	
	RM_KL_END_AUS := (  IN_TR.tPos_ThR_Val_Out1.Di
					AND IN_TR.tPos_ThR_Val_Out2.Di
					AND NOT IN_TR.tPos_ThR_Val_In1.Di
					AND NOT IN_TR.tPos_ThR_Val_In2.Di
					AND NOT IN_TR.tPos_ThR_Val_Mid.Di);
	
	RM_KL_END_EIN := (  IN_TR.tPos_ThR_Val_In1.Di
					AND IN_TR.tPos_ThR_Val_In2.Di
					AND NOT IN_TR.tPos_ThR_Val_Out1.Di
					AND NOT IN_TR.tPos_ThR_Val_Out2.Di
					AND NOT IN_TR.tPos_ThR_Val_Mid.Di);
		
		
	(* Abgasklappe Einschaltung Schütze mit E-Antrieb: *)
	(* Abgasklappe Mittelstellung mit E-Antrieb: *)
	IF NOT FG_KLUM AND Para.bSel_FlapActEl THEN
		R_TRIG_KL_AUS_M (CLK:= KL_AUS_M);
		R_TRIG_KL_EIN_M (CLK:= KL_EIN_M);
		OUT_TR.tThR_Val_CCylOut.Do := R_TRIG_KL_AUS_M.Q;
		OUT_TR.tThR_Val_CCylIn.Do  := R_TRIG_KL_EIN_M.Q;
	END_IF;
	(* Anmerkung: Selbsthaltung extern mit Schütz, Absteuerung mit Endschalter Mittelstellung *)
	
	(* Abgasklappe Umschaltung mit E-Antrieb: *)
	IF FG_KLUM AND Para.bSel_FlapActEl THEN
	
		(* Klappe Ausfahren:
	   	   - Rueckmeldung Endlage_Eingefahren oder Mittelstellung erreicht:
	         Ausfahren durch Dauerbefehl *)
	
		(* Dauerbefehl fuer Richtungswechsel *)
		IF (OUT_TR.bThR_Val_SetOut AND (RM_KL_MIT OR RM_KL_END_EIN)) THEN
			OUT_TR.tThR_Val_CCylOut.Do := TRUE;
		END_IF;
	
		(* Klappe Einfahren:
	   	   - Rueckmeldung Endlage_Ausgefahren oder Mittelstellung erreicht:
	         Einfahren durch Dauerbefehl *)
	
		(* Dauerbefehl fuer Richtungswechsel *)
		IF (OUT_TR.bThR_Val_SetIn AND (RM_KL_MIT OR RM_KL_END_AUS)) THEN
			OUT_TR.tThR_Val_CCylIn.Do := TRUE;
		END_IF;
	END_IF;
	
	
	
	(* Zeittakte Abgasklappe Umschaltung *)
	OUT_TR.bThR_Val_SetOut  := FG_KLUM 
							AND (NOT xTON_KL_AUS.Q) 
							AND (NOT OUT_TR.bThR_Val_SetIn)
							AND (OUT_TR.bThR_Val_SetOut OR NOT KL_AUS_S);
	
	IF OUT_TR.bThR_Val_SetOut THEN
		KL_AUS_S   := TRUE;
		KL_AUS_M_S := TRUE;
		KL_EIN_S   := FALSE;
		KL_EIN_M_S := FALSE;
	END_IF;
	xTON_KL_AUS (IN:= OUT_TR.bThR_Val_SetOut, PT:= PTON_KL_AUS);
	
	OUT_TR.bThR_Val_SetIn := FG_KLUM
						AND (NOT xTON_KL_EIN.Q)
						AND (NOT OUT_TR.bThR_Val_SetOut)
						AND TRUE;
	
	IF OUT_TR.bThR_Val_SetIn THEN
		KL_EIN_S   := TRUE;
		KL_EIN_M_S := TRUE;
		KL_AUS_S   := FALSE;
		KL_AUS_M_S := FALSE;
	END_IF;
	xTON_KL_EIN (IN:= OUT_TR.bThR_Val_SetIn, PT:= PTON_KL_EIN);
	
	
	
	(* Abgasklappe Mittelstellung mit E-Antrieb: *)
	(* Zeittakte Abgasklappe für Anfahren Mittelstellung mit E-Antrieb: *)
	xTOF_S_EIN (IN:= (Para.bThR_Active AND IN_TR.tThR_Swth_On.Di), PT:= T#15s);
	xTON_FG_KL_M (IN:= (xTOF_S_EIN.Q AND NOT FG_KLUM AND NOT RM_KL_MIT AND NOT xTRA01M.Q1), PT:= T#1s);
	FG_KL_M := xTON_FG_KL_M.Q;
	
	KL_AUS_M := FG_KL_M AND NOT xTON_KL_AUS_M.Q AND NOT KL_EIN_M AND
				(KL_AUS_M OR NOT KL_AUS_M_S OR RM_KL_END_EIN);
	IF KL_AUS_M THEN
		KL_AUS_M_S := TRUE;
		KL_EIN_M_S := FALSE;
	END_IF;
	xTON_KL_AUS_M (IN:= KL_AUS_M, PT:= T#5s);
	
	KL_EIN_M := FG_KL_M AND NOT xTON_KL_EIN_M.Q AND NOT KL_AUS_M AND TRUE;
	IF KL_EIN_M THEN
		KL_EIN_M_S := TRUE;
		KL_AUS_M_S := FALSE;
	END_IF;
	xTON_KL_EIN_M (IN:= KL_EIN_M, PT:= T#5s);
	
	(* Abgasklappe Umschaltung mit E-Antrieb: *)
	IF FG_KLUM AND Para.bSel_FlapActEl THEN
	
		(* Klappe Ausfahren:
	       - Rueckmeldung Endlage_Eingefahren oder Mittelstellung erreicht:
	         Ausfahren durch Dauerbefehl (siehe oberhalb)
	       - Rueckmeldung Endlage_Ausgefahren: Beendigung Dauerbefehl
	       - Ueberwachung:
	         Falls nach 10" die Endlage nicht erreicht wird,
	         "Stoerung Abgasklappe Ende" mit Reaktorabschaltung und
	         Befehl Abgasklappe Mittelstellung.
	         Falls 5" danach die Mittelstellung nicht erreicht wird,
	         "Stoerung Abgasklappe Mittelstellung" mit Gasmotorabstellung. *)
	
		(* Absteuerung *)
		IF (OUT_TR.bThR_Val_SetOut AND RM_KL_END_AUS) OR NOT OUT_TR.bThR_Val_SetOut THEN
			OUT_TR.tThR_Val_CCylOut.Do := FALSE;
		END_IF;
	
		(* Klappe Einfahren:
	   	   - Rueckmeldung Endlage_Ausgefahren oder Mittelstellung erreicht:
	      	 Einfahren durch Dauerbefehl (siehe oberhalb)
	   	   - Rueckmeldung Endlage_Eingefahren: Beendigung Dauerbefehl
	   	   - Ueberwachung:
	     	 Falls nach 10" die Endlage nicht erreicht wird,
	       	 "Stoerung Abgasklappe Ende" mit Reaktorabschaltung und
	       	 Befehl Abgasklappe Mittelstellung.
	     	 Falls 5" danach die Mittelstellung nicht erreicht wird,
	       	 "Stoerung Abgasklappe Mittelstellung" mit Gasmotorabstellung. *)
	
		(* Absteuerung *)
		IF (OUT_TR.bThR_Val_SetIn AND RM_KL_END_EIN) OR NOT OUT_TR.bThR_Val_SetIn THEN
			OUT_TR.tThR_Val_CCylIn.Do  := FALSE;
		END_IF;
	END_IF;	
	
	
	(* Abgasklappe Verriegelung mit E-Antrieb: *)
	IF Para.bSel_FlapActEl THEN
		IF OUT_TR.bThR_Val_SetOut OR KL_AUS_M THEN
			OUT_TR.tThR_Val_CCylIn.Do  := FALSE;
		END_IF;
		IF OUT_TR.bThR_Val_SetIn OR KL_EIN_M THEN
			OUT_TR.tThR_Val_CCylOut.Do  := FALSE;
		END_IF;
	END_IF;
	
	(* Abgasklappe Mittelstellung mit Druckluft-Anztrieb: *)
	(* Im spannungslosen Zustand der Ansteuerventile geht die Klappe auf Mittelstellung. *)
	IF NOT FG_KLUM AND NOT Para.bSel_FlapActEl THEN
		OUT_TR.tThR_Val_CCylIn.Do  := FALSE;
		OUT_TR.tThR_Val_CCylOut.Do := FALSE;
	END_IF;
	
	
	(* Abgasklappe Umschaltung mit Druckluft-Antrieb: *)
	IF FG_KLUM AND NOT Para.bSel_FlapActEl THEN
		R_TRIG_KL_AUS (CLK:= OUT_TR.bThR_Val_SetOut);
		R_TRIG_KL_EIN (CLK:= OUT_TR.bThR_Val_SetIn);
	
		(* Bei positiver Flanke von KL_EIN oder KL_AUS sowie wenn KL_EIN und KL_AUS
	    nicht anstehen, wird die Mittelstellung aktiviert. *)
		IF (R_TRIG_KL_AUS.Q OR R_TRIG_KL_EIN.Q OR (OUT_TR.bThR_Val_SetOut AND OUT_TR.bThR_Val_SetIn)) THEN
			OUT_TR.tThR_Val_CCylIn.Do  := FALSE;
			OUT_TR.tThR_Val_CCylOut.Do := FALSE;
		END_IF;
	
		(* Klappe Ausfahren:
	       - Anfahren Mittelstellung durch Y1=0, Y2=0
	       - Rueckmeldung Mittelstellung erreicht: Ausfahren durch Aktivieren von Y2
	       - Ueberwachung:
	       Falls nach 10" die Endlage nicht erreicht wird,
	       "Stoerung Abgasklappe Ende" mit Reaktorabschaltung und
	       Befehl Abgasklappe Mittelstellung.
	       Falls 5" danach die Mittelstellung nicht erreicht wird,
	       "Stoerung Abgasklappe Mittelstellung" mit Gasmotorabstellung. *)
		IF OUT_TR.bThR_Val_SetOut THEN
			OUT_TR.tThR_Val_CCylIn.Do := FALSE;
		END_IF;
		IF (OUT_TR.bThR_Val_SetOut AND RM_KL_MIT) THEN
			OUT_TR.tThR_Val_CCylOut.Do := TRUE;
		END_IF;
	
		(* Klappe Einfahren:
	   	   - Anfahren Mittelstellung durch Y1=0, Y2=0
	  	   - Rueckmeldung Mittelstellung erreicht: Einfahren durch Aktivieren von Y1
	       - Ueberwachung:
	     		Falls nach 10" die Endlage nicht erreicht wird,
	       		"Stoerung Abgasklappe Ende" mit Reaktorabschaltung und
	            Befehl Abgasklappe Mittelstellung.
	     		Falls 5" danach die Mittelstellung nicht erreicht wird,
	       		"Stoerung Abgasklappe Mittelstellung" mit Gasmotorabstellung. *)
		IF OUT_TR.bThR_Val_SetIn THEN
			OUT_TR.tThR_Val_CCylOut.Do := FALSE;
		END_IF;
		IF (OUT_TR.bThR_Val_SetIn AND RM_KL_MIT) THEN
			OUT_TR.tThR_Val_CCylIn.Do := TRUE;
		END_IF;
	END_IF;
	
	(* Thermal Reactor auxiliary gas solenoid valve - ThR2 *)
	IF Para.bThR2_Ena THEN
		IF OUT_TR.bThR_RelGas THEN
			//update blockage function inputs before 4-way flap switching request depending on last end-position
			IF iThr2_lastFlapEndPosIndex = 1 THEN
				xSR_Thr2_AuxGasValve_Block.SET1 := xTON_KL_EIN.PT - xTON_KL_EIN.ET <= tiThR2_AuxGasValve_Block;
				xSR_Thr2_AuxGasValve_Block.RESET := RM_KL_END_AUS;
			ELSIF iThr2_lastFlapEndPosIndex = -1 THEN
				xSR_Thr2_AuxGasValve_Block.SET1 := xTON_KL_AUS.PT - xTON_KL_AUS.ET <= tiThR2_AuxGasValve_Block;
				xSR_Thr2_AuxGasValve_Block.RESET := RM_KL_END_EIN;
			END_IF
		ELSE //reinitialize blockage function inputs in case of Th.Reactor aux.gas system stop
			xSR_Thr2_AuxGasValve_Block.SET1 := FALSE;
			xSR_Thr2_AuxGasValve_Block.RESET := TRUE;
		END_IF
		xSR_Thr2_AuxGasValve_Block();
		OUT_TR.tThR2_AuxGasShutOffValve_Dem.Do := OUT_TR.bThR_RelGas AND RM_KL_END AND (NOT xSR_Thr2_AuxGasValve_Block.Q1);
	ELSE
		//reset SR in IF block
		xSR_Thr2_AuxGasValve_Block.SET1 := FALSE;
		xSR_Thr2_AuxGasValve_Block.RESET := TRUE;
		//reset output signal gas solenoid valve - ThR2
		OUT_TR.tThR2_AuxGasShutOffValve_Dem.Do := FALSE;
	END_IF
	IF OUT_TR.bThR_RelGas THEN //record last end-position reached by 4-way flap during aux. gas. injection operation
		IF RM_KL_END_EIN THEN
			iThr2_lastFlapEndPosIndex := 1; //right position
		ELSIF RM_KL_END_AUS THEN
			iThr2_lastFlapEndPosIndex := -1; //left position
		END_IF
	ELSE
		iThr2_lastFlapEndPosIndex := 0; //reset position index
	END_IF

	//block the auxiliary gas heating controller if corresponding solenoid valve is closed
	bThr2_AuxGasValve_CtrlBlock := Para.bThR2_Ena AND OUT_TR.bThR_RelGas AND NOT OUT_TR.tThR2_AuxGasShutOffValve_Dem.Do;
	
	(******************************************************************************)
	(******************************************************************************)
	
	(* Ueberwachungen [PB45] *)
	
	(* TRA01 : "STOERUNG ABGASKLAPPE MITTELSTELLUNG" *)
	xTON_ST_KLM.IN := OUT_TR.bThR_Active AND NOT FG_KLUM AND NOT RM_KL_MIT AND NOT xTON_ST_KLM.Q AND NOT xTRA01M.RESET;
	xTON_ST_KLM.PT := T#15s;
	xTON_ST_KLM;
	xTRA01.SET1  := xTON_ST_KLM.Q;
	xTRA01.RESET := NOT xTRA01.SET1;
	xTRA01();
	xTRA01M.SET1  := xTON_ST_KLM.Q;
	xTRA01M.RESET := IN_TR.tAB2TR.bResetTrip;
	xTRA01M();
	
	(* TRA02 : "SICHERHEITSSCHLEIFE THERMOREAKTOR", aktiv nur bei RIO *)
	xTRA02.SET1  := IN_TR.tThR_SL.Di;
	xTRA02.RESET := NOT xTRA02.SET1;
	xTRA02();
	
	(* TRW01 : "FUEHLERBRUCH" *)
	xTRW01_TK.SET1  := MS_TK;
	xTRW01_TK.RESET := NOT xTRW01_TK.SET1;
	xTRW01_TK();
	xTRW01.SET1  := xTRW01_TK.Q1;
	xTRW01.RESET := NOT xTRW01.SET1;
	xTRW01();
	
	(* TRW02 : "STOERUNG DRUCKLUFTVERSORGUNG" *)
	xTOF_PS_LUFT (IN:= IN_TR.tPr_ThR_AirLo.Di  AND NOT Para.bSel_FlapActEl, PT := T#10s);
	xTRW02.SET1  := Para.bThR_Active AND NOT xTOF_PS_LUFT.Q AND NOT Para.bSel_FlapActEl;
	xTRW02.RESET := NOT xTRW02.SET1;
	xTRW02();
	
	(* TRW03 : "STOERUNG ABGASKLAPPE ENDLAGE" *)
	xTON_ST_KLE (IN:= ((OUT_TR.bThR_Val_SetOut AND NOT RM_KL_END_AUS) OR 
					   (OUT_TR.bThR_Val_SetIn  AND NOT RM_KL_END_EIN)), PT:= T#10s);
	xTRW03.SET1  := xTON_ST_KLE.Q;
	xTRW03.RESET := NOT xTRW03.SET1;
	xTRW03();
	
	(* TRW04 : "AUFHEIZZEIT UEBERSCHRITTEN" *)
	xTON_AUFHEIZG_GES (IN:= (FG_KLUM AND NOT xTK_OPER.QH), PT:= T#600m);
	xTON_AUFHEIZG_GAS (IN:= (OUT_TR.bThR_RelGas AND NOT xTK_OPER.QH), PT:= T#300m);
	xTRW04.SET1  := xTON_AUFHEIZG_GES.Q OR xTON_AUFHEIZG_GAS.Q;
	xTRW04.RESET := NOT xTRW04.SET1;
	xTRW04();
	
	(* TRW05 : "SCHALTSCHRANKTEMPERATUR MAXIMUM" *)
	xTRW05.SET1  := OUT_TR.bThR_Active AND NOT IN_TR.tT_ThR_Swg_Hi.Di;
	xTRW05.RESET := NOT xTRW05.SET1;
	xTRW05();
	
	(* TRW06 : "ZULAESSIGE DIFFERENZ VON TEMPERATUREN TK1/TK2 UEBER MAXIMUM" *)
	xTRW06.SET1  := xTK1_DIF_HI.QH OR xTK2_DIF_HI.QH;
	xTRW06.RESET := NOT xTRW06.SET1;
	xTRW06();
	
	(* TRW07 : "TEMPERATUR REAKTIONSKAMMER TK1/TK2 MAXIMUM" *)
	IF NOT Para.bThR2_Ena THEN //with Thermal reactor 1st generation
		xTRW07.SET1  := xTK1_1_HI.QH OR xTK1_2_HI.QH OR xTK2_1_HI.QH OR xTK2_2_HI.QH;
	END_IF
	IF Para.bThR2_Ena THEN //with Thermal reactor 2nd generation
	   (*************** temperature threshold check for TRW07 - ThR2 ***************)
		xGRMax_ThR2_T_LeftChamber_Hi(Gw := TKx_y_HI_Gw, Hy := TKx_y_HI_Hy, In := IN_TR.tT_ThR2_LeftChamber.Ai);
		xTON_ThR2_T_LeftChamber_Hi(IN := xGRMax_ThR2_T_LeftChamber_Hi.Q, PT := ti_TKx_y_HI_PTHI);
		
		xGRMax_ThR2_T_RightChamber_Hi(Gw := TKx_y_HI_Gw, Hy := TKx_y_HI_Hy, In := IN_TR.tT_ThR2_RightChamber.Ai);
		xTON_ThR2_T_RightChamber_Hi(IN := xGRMax_ThR2_T_RightChamber_Hi.Q, PT := ti_TKx_y_HI_PTHI);
		
		xTRW07.SET1  := xTON_ThR2_T_LeftChamber_Hi.Q OR xTON_ThR2_T_RightChamber_Hi.Q;
	ELSE //reset TON in IF block
		xTON_ThR2_T_LeftChamber_Hi(IN := FALSE, PT := ti_TKx_y_HI_PTHI);
		xTON_ThR2_T_RightChamber_Hi(IN := FALSE, PT := ti_TKx_y_HI_PTHI);
	END_IF
	xTRW07.RESET := NOT xTRW07.SET1;
	xTRW07();
	
	(* TRW08 : "TEMPERATUR REAKTIONSKAMMER MINIMUM" *)
	xTRW08.SET1  := OUT_TR.bThR_Active AND NOT IN_TR.tT_ThR_ChamberLo.Di;
	xTRW08.RESET := NOT xTRW08.SET1;
	xTRW08();
	
	(* Sammelstoerung Reaktor Stop *)
	IF IN_TR.tAB2TR.bResetWarning THEN
		ST_R_ST := FALSE;
	END_IF;
	
	IF (xTRW01_TK.Q1
		OR bThR2_T_fault_ReactChamber
		OR xTRW02.Q1
		OR xTRW03.Q1
		OR xTRW04.Q1
		OR xTRW05.Q1
		OR xTRW06.Q1
		OR xTRW07.Q1
		OR xTRW08.Q1) THEN
		ST_R_ST := TRUE;
	END_IF;
	
	(* Sammelstoerung Reaktor + Motor Stop *)
	IF IN_TR.tAB2TR.bResetTrip THEN
		ST_RM_ST := FALSE;
	END_IF;
	
	IF FALSE (* priority 3 alarms from Th.Reactor to be included here *) THEN
		 ST_RM_ST := TRUE;
	END_IF;
	
	(* H2: "Reaktor Sammelstoerung", aktiv nur bei RIO *)
	OUT_TR.tThR_ErrLamp.Do 
		:= xTRA01.Q1
		OR xTRA02.Q1
		OR MM2VIS.bMsg2356
		OR MM2VIS.bMsg2357
		OR MM2VIS.bMsg2358
		OR xTRW01.Q1
		OR bThR2_T_fault_ReactChamber
		OR xTRW02.Q1
		OR xTRW03.Q1
		OR xTRW04.Q1
		OR xTRW05.Q1
		OR xTRW06.Q1
		OR xTRW07.Q1
		OR xTRW08.Q1
		OR MM2VIS.bMsg9374
		OR MM2VIS.bMsg9375
		OR MM2VIS.bMsg9376
		OR MM2VIS.bMsg9377
		OR MM2VIS.bMsg9381
		OR IN_TR.tThR_LampTest.Di;
	
	
	(******************************************************************************)
	(* Auswahl der Reaktionstemperatur in Abhaengigkeit der Stroemungsrichtung [FB66] *)
	TK_moduleTR := TK1_TK2_MAX;
	
	(* Sekundentakt [FB3] 
	CTU_SEK_TAKT (CU := FALSE, RESET := CTU_SEK_TAKT.Q, PV := 10);
	CTU_SEK_TAKT (CU := TRUE, RESET := CTU_SEK_TAKT.Q, PV := 10);
	SEK_TAKT := (CTU_SEK_TAKT.CV >= 5) AND (CTU_SEK_TAKT.CV <= 10);
	*)
	
	xTON_reactor_01.IN := NOT(SEK_TAKT);
	xTON_reactor_01.PT := T#300ms;
	xTON_reactor_01();
	
	IF (xTON_reactor_01.Q = 1) THEN
		SEK_TAKT := 1;
	END_IF;
	
	xTON_reactor_02.IN := SEK_TAKT;
	xTON_reactor_02.PT := T#600ms;
	xTON_reactor_02();
	
	IF (xTON_reactor_02.Q = 1) THEN
		SEK_TAKT := 0;
	END_IF;
	
	IF NOT Para.bThR2_Ena THEN // El. heating with Thermal reactor 1st generation
		(* Heizstabsteuerung [FB45, FB56]
		   Periodendauer = 4*100ms.
		   Impulsdauer   = 0...4*100ms. *)
		xCTD_HE_1 (CD := FALSE, LOAD := xCTD_HE_1.Q, PV := 4);
		xCTD_HE_1 (CD := TRUE, LOAD := xCTD_HE_1.Q, PV := 4);
		
		(* Phasenverschiebung 2*100ms *)
		xCTD_HE_2 (CD := FALSE, LOAD := xCTD_HE_1.CV = 1, PV := 4);
		xCTD_HE_2 (CD := TRUE, LOAD := FALSE, PV := 4);
		
		(* Phasenverschiebung 3*100ms *)
		xCTD_HE_3 (CD := FALSE, LOAD := xCTD_HE_1.CV = 0, PV := 4);
		xCTD_HE_3 (CD := TRUE, LOAD := FALSE, PV := 4);
		
		IF FG_HEIZG_moduleTR = FALSE OR xTK_E00.QH THEN
			y_HE := 0;
		ELSIF FG_HEIZG_moduleTR AND NOT(xTK_E00.QH) AND xTK_E25.QH THEN
			y_HE := 1;
		ELSIF FG_HEIZG_moduleTR AND NOT(xTK_E00.QH) AND NOT(xTK_E25.QH) AND xTK_E50.QH THEN
			y_HE := 2;
		ELSIF FG_HEIZG_moduleTR AND NOT(xTK_E00.QH) AND NOT(xTK_E25.QH) AND NOT(xTK_E50.QH) AND xTK_E75.QH THEN
			y_HE := 3;
		ELSIF FG_HEIZG_moduleTR AND NOT(xTK_E00.QH) AND NOT(xTK_E25.QH) AND NOT(xTK_E50.QH) AND NOT(xTK_E75.QH) THEN
			y_HE := 4;
		ELSE
			y_HE := 0;
		END_IF;
		
		(* RAMP FUNCTION *)
		P_ramp[0].In         := REAL_TO_INT(y_HE * 1000);      (* "PV_In": use "PV Name" of "In" *)
		P_ramp[0].In_ref     := 1;                (* reference value, units like "In" *)
		P_ramp[0].mode       := 0;                (* 1: dOut=Ki*(In-Out)/In_ref, 0: dOut=Ki *)
		P_ramp[0].Ki_plus    := 333;              (* 0,1 units "In"/s *)
		P_ramp[0].Ki_minus   := 10000;            (* 0,1 units "In"/s *)
		P_ramp[0].dOut_max_p := 10000;            (* 0,1 units "In"/s *)
		P_ramp[0].dOut_max_m := 10000;            (* 0,1 units "In"/s *)
		P_ramp[0].Out_min    := 0;                (* units like "In" *)
		P_ramp[0].Out_max    := P_ramp[0].In;     (* units like "In" *)
		y_HE_ramp := REAL_TO_UINT(P_ramp[0].Out) / 1000;	(* "PV_Out": use "PV Name" of "Out", units like "In" *)
		
		
		rThR_EH_pulse := LIMIT(0, UINT_TO_REAL(y_HE_ramp * 100) - 10, 290);	// limit pulse duration from 0% to 75% of time interval
		tThR_EH_pulse:= REAL_TO_TIME(rThR_EH_pulse);
		xTP_EH11(IN := xCTD_HE_1.Q, PT:= tThR_EH_pulse);
		xTP_EH21(IN := xCTD_HE_2.Q, PT:= tThR_EH_pulse);
		xTP_EH31(IN := xCTD_HE_3.Q, PT:= tThR_EH_pulse);
		OUT_TR.tThR_EH11.Do := xTP_EH11.Q;	
		OUT_TR.tThR_EH21.Do := xTP_EH21.Q;
		OUT_TR.tThR_EH31.Do := xTP_EH31.Q;
		IF y_HE_ramp = 4 THEN 												// overwrite pulse signal for 100% heating output request
			OUT_TR.tThR_EH11.Do := OUT_TR.tThR_EH21.Do := OUT_TR.tThR_EH31.Do := 1;
		END_IF
		IF y_HE_ramp = 0 THEN 												// overwrite pulse signal for no heating output request
			OUT_TR.tThR_EH11.Do := OUT_TR.tThR_EH21.Do := OUT_TR.tThR_EH31.Do := 0;
		END_IF
		
		OUT_TR.tThR_EH12.Do := OUT_TR.tThR_EH11.Do;
		OUT_TR.tThR_EH13.Do := OUT_TR.tThR_EH11.Do;
		
		OUT_TR.tThR_EH22.Do := OUT_TR.tThR_EH21.Do;
		OUT_TR.tThR_EH23.Do := OUT_TR.tThR_EH21.Do;
		
		OUT_TR.tThR_EH32.Do := OUT_TR.tThR_EH31.Do;
		OUT_TR.tThR_EH33.Do := OUT_TR.tThR_EH31.Do;
		
		IF FG_HEIZG_moduleTR THEN
			CASE y_HE_ramp OF
				0: OUT_TR.rP_ThR_EH := 0;
				1: OUT_TR.rP_ThR_EH := 250;
				2: OUT_TR.rP_ThR_EH := 500;
				3: OUT_TR.rP_ThR_EH := 750;
				4: OUT_TR.rP_ThR_EH := 1000;
			ELSE
				OUT_TR.rP_ThR_EH := 0;
			END_CASE;
		ELSE
			OUT_TR.rP_ThR_EH := 0;
		END_IF;
		
	ELSE
		//reset ramps/timer blocks in IF block
		P_ramp[0].Out_internal := 0;
		P_ramp[1].Out_internal := 0; //P_ramp[1] never used, reinitialized for completeness
		xTP_EH11(IN := FALSE);
		xTP_EH21(IN := FALSE);
		xTP_EH31(IN := FALSE);
	END_IF
	IF Para.bThR2_Ena THEN // El. heating with Thermal reactor 2nd generation
		//definition of five el.heating power levels
		xGRMax_ThR2_EH_pw00(Gw := Para.rT_ThR2_EH_Lim00, Hy := rT_ThR2_EH_PwLevHy, In := TK_moduleTR);
		xGRMax_ThR2_EH_pw20(Gw := Para.rT_ThR2_EH_Lim20, Hy := rT_ThR2_EH_PwLevHy, In := TK_moduleTR);
		xGRMax_ThR2_EH_pw40(Gw := Para.rT_ThR2_EH_Lim40, Hy := rT_ThR2_EH_PwLevHy, In := TK_moduleTR);
		xGRMax_ThR2_EH_pw60(Gw := Para.rT_ThR2_EH_Lim60, Hy := rT_ThR2_EH_PwLevHy, In := TK_moduleTR);
		xGRMax_ThR2_EH_pw80(Gw := Para.rT_ThR2_EH_Lim80, Hy := rT_ThR2_EH_PwLevHy, In := TK_moduleTR);
		
		IF FG_HEIZG_moduleTR = FALSE OR xGRMax_ThR2_EH_pw00.Q THEN
			iThR2_EH_PwLev := 0;
		ELSIF FG_HEIZG_moduleTR AND NOT(xGRMax_ThR2_EH_pw00.Q) AND xGRMax_ThR2_EH_pw20.Q THEN
			iThR2_EH_PwLev := 1;
		ELSIF FG_HEIZG_moduleTR AND NOT(xGRMax_ThR2_EH_pw00.Q) AND NOT(xGRMax_ThR2_EH_pw20.Q) AND xGRMax_ThR2_EH_pw40.Q THEN
			iThR2_EH_PwLev := 2;
		ELSIF FG_HEIZG_moduleTR AND NOT(xGRMax_ThR2_EH_pw00.Q) AND NOT(xGRMax_ThR2_EH_pw20.Q) AND NOT(xGRMax_ThR2_EH_pw40.Q) AND xGRMax_ThR2_EH_pw60.Q THEN
			iThR2_EH_PwLev := 3;
		ELSIF FG_HEIZG_moduleTR AND NOT(xGRMax_ThR2_EH_pw00.Q) AND NOT(xGRMax_ThR2_EH_pw20.Q) AND NOT(xGRMax_ThR2_EH_pw40.Q) AND NOT(xGRMax_ThR2_EH_pw60.Q) AND xGRMax_ThR2_EH_pw80.Q THEN
			iThR2_EH_PwLev := 4;
		ELSIF FG_HEIZG_moduleTR AND NOT(xGRMax_ThR2_EH_pw00.Q) AND NOT(xGRMax_ThR2_EH_pw20.Q) AND NOT(xGRMax_ThR2_EH_pw40.Q) AND NOT(xGRMax_ThR2_EH_pw60.Q) AND NOT(xGRMax_ThR2_EH_pw80.Q) THEN
			iThR2_EH_PwLev := 5;
		ELSE
			iThR2_EH_PwLev := 0;
		END_IF;
		
		//time ramp for el.heating power level
		xRamp_ThR2_EH_PwLev.In := INT_TO_REAL(iThR2_EH_PwLev);
		xRamp_ThR2_EH_PwLev();
		iThR2_EH_PwLev_ramp := TRUNC(xRamp_ThR2_EH_PwLev.Out);
		OUT_TR.rP_ThR_EH := INT_TO_REAL(iThR2_EH_PwLev_ramp) / 5 * 1000; (* 5 el.heating power levels, 1000 HMI display scaling factor *)
		
		//monitoring of heating elements groups availability depending on max.temperature
		xTON_ThR2_EH_gr1_T_GoodQual(IN := IN_TR.tT_ThR2_EH_group1.GoodQual, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		xTON_ThR2_EH_gr2_T_GoodQual(IN := IN_TR.tT_ThR2_EH_group2.GoodQual, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		xTON_ThR2_EH_gr3_T_GoodQual(IN := IN_TR.tT_ThR2_EH_group3.GoodQual, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		xTON_ThR2_EH_gr4_T_GoodQual(IN := IN_TR.tT_ThR2_EH_group4.GoodQual, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		xTON_ThR2_EH_gr5_T_GoodQual(IN := IN_TR.tT_ThR2_EH_group5.GoodQual, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		
		xGRMax_ThR2_EH_group1_T(Gw := rT_ThR2_EH_thres_GroupHi, Hy := rT_ThR2_EH_thres_GroupHi_Hy, In := IN_TR.tT_ThR2_EH_group1.Ai);
		bThR2_EH_gr1_T_blocked := xGRMax_ThR2_EH_group1_T.Q AND xTON_ThR2_EH_gr1_T_GoodQual.Q;
		bThR2_EH_groupT_Ok[1] := NOT bThR2_EH_gr1_T_blocked;
		xGRMax_ThR2_EH_group2_T(Gw := rT_ThR2_EH_thres_GroupHi, Hy := rT_ThR2_EH_thres_GroupHi_Hy, In := IN_TR.tT_ThR2_EH_group2.Ai);
		bThR2_EH_gr2_T_blocked := xGRMax_ThR2_EH_group2_T.Q AND xTON_ThR2_EH_gr2_T_GoodQual.Q;
		bThR2_EH_groupT_Ok[2] := NOT bThR2_EH_gr2_T_blocked;
		xGRMax_ThR2_EH_group3_T(Gw := rT_ThR2_EH_thres_GroupHi, Hy := rT_ThR2_EH_thres_GroupHi_Hy, In := IN_TR.tT_ThR2_EH_group3.Ai);
		bThR2_EH_gr3_T_blocked := xGRMax_ThR2_EH_group3_T.Q AND xTON_ThR2_EH_gr3_T_GoodQual.Q;
		bThR2_EH_groupT_Ok[3] := NOT bThR2_EH_gr3_T_blocked;
		xGRMax_ThR2_EH_group4_T(Gw := rT_ThR2_EH_thres_GroupHi, Hy := rT_ThR2_EH_thres_GroupHi_Hy, In := IN_TR.tT_ThR2_EH_group4.Ai);
		bThR2_EH_gr4_T_blocked := xGRMax_ThR2_EH_group4_T.Q AND xTON_ThR2_EH_gr4_T_GoodQual.Q;
		bThR2_EH_groupT_Ok[4] := NOT bThR2_EH_gr4_T_blocked;
		xGRMax_ThR2_EH_group5_T(Gw := rT_ThR2_EH_thres_GroupHi, Hy := rT_ThR2_EH_thres_GroupHi_Hy, In := IN_TR.tT_ThR2_EH_group5.Ai);
		bThR2_EH_gr5_T_blocked := xGRMax_ThR2_EH_group5_T.Q AND xTON_ThR2_EH_gr5_T_GoodQual.Q;
		bThR2_EH_groupT_Ok[5] := NOT bThR2_EH_gr5_T_blocked;
		
		
		//definition of heating elements groups order based on flap position
		IF RM_KL_END THEN //flap in one of the end-positions with request
			IF RM_KL_END_EIN THEN //end-position right: heating element energization order right to left
				iThR2_EH_groupFirst := 5;
				iThR2_EH_groupLast := 1;
				iThR2_EH_groupIndexIncr := -1;
			ELSIF RM_KL_END_AUS THEN //end-position left: heating element energization order left to right
				iThR2_EH_groupFirst := 1;
				iThR2_EH_groupLast := 5;
				iThR2_EH_groupIndexIncr := 1;
			END_IF
			
			//set of heating elements groups status based on power level
			iThR2_EH_PwLevCounter := 0;
			FOR iThR2_EH_groupIndex := iThR2_EH_groupFirst TO iThR2_EH_groupLast BY iThR2_EH_groupIndexIncr DO
				IF bThR2_EH_groupT_Ok[iThR2_EH_groupIndex] AND (iThR2_EH_PwLevCounter < iThR2_EH_PwLev_ramp) THEN
					bThR2_EH_group_On[iThR2_EH_groupIndex] := TRUE;
					iThR2_EH_PwLevCounter := iThR2_EH_PwLevCounter + 1;
				ELSE
					bThR2_EH_group_On[iThR2_EH_groupIndex] := FALSE;
				END_IF
			END_FOR
			OUT_TR.tThR2_EH_group1_Dem.Do := bThR2_EH_group_On[1];
			OUT_TR.tThR2_EH_group2_Dem.Do := bThR2_EH_group_On[2];
			OUT_TR.tThR2_EH_group3_Dem.Do := bThR2_EH_group_On[3];
			OUT_TR.tThR2_EH_group4_Dem.Do := bThR2_EH_group_On[4];
			OUT_TR.tThR2_EH_group5_Dem.Do := bThR2_EH_group_On[5];
		ELSE
			OUT_TR.tThR2_EH_group1_Dem.Do := OUT_TR.tThR2_EH_group2_Dem.Do := OUT_TR.tThR2_EH_group3_Dem.Do := OUT_TR.tThR2_EH_group4_Dem.Do := OUT_TR.tThR2_EH_group5_Dem.Do := FALSE;
		END_IF
	ELSE
		//reset ramp in IF block
		xRamp_ThR2_EH_PwLev.In := 0;
		xRamp_ThR2_EH_PwLev();
		//reset timers in IF block
		xTON_ThR2_EH_gr1_T_GoodQual(IN := FALSE, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		xTON_ThR2_EH_gr2_T_GoodQual(IN := FALSE, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		xTON_ThR2_EH_gr3_T_GoodQual(IN := FALSE, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		xTON_ThR2_EH_gr4_T_GoodQual(IN := FALSE, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		xTON_ThR2_EH_gr5_T_GoodQual(IN := FALSE, PT := tiTON_ThR2_EH_gr_T_GoodQual);
		//reset all output signals to heating elements ThR2
		OUT_TR.tThR2_EH_group1_Dem.Do := OUT_TR.tThR2_EH_group2_Dem.Do := OUT_TR.tThR2_EH_group3_Dem.Do := OUT_TR.tThR2_EH_group4_Dem.Do := OUT_TR.tThR2_EH_group5_Dem.Do := FALSE;
	END_IF
	bThR_elHeating := OUT_TR.rP_ThR_EH > 0;

	(* Temperature Limits [FB33] *)
	
	(*
		IF (rP_Act_Norm_Filt >= 75) THEN bQ0 := 1;
	    ELSIF (rP_Act_Norm_Filt < 70) THEN bQ0 := 0;
		END_IF
	    
		xTON_P_75(IN := bQ0, PT := T#2s);
		AN_P_75 := xTON_P_75.Q;	
	
	*)
	
	(*************** temperature threshold check for TRW07 - ThR ***************)
	xGRMax_TK11(Gw := TKx_y_HI_Gw, Hy := TKx_y_HI_Hy, In := IN_TR.tT_ThR_Chamber1_1.Ai);
	
	xTON_TK1_1(IN := xGRMax_TK11.Q, PT := ti_TKx_y_HI_PTHI);
	xTK1_1_HI.QH  := xTON_TK1_1.Q;
	
	(****************************************)
	xGRMax_TK12(Gw := TKx_y_HI_Gw, Hy := TKx_y_HI_Hy, In := IN_TR.tT_ThR_Chamber1_2.Ai);
	
	xTON_TK1_2(IN := xGRMax_TK12.Q, PT := ti_TKx_y_HI_PTHI);
	xTK1_2_HI.QH   := xTON_TK1_2.Q;
	
	(****************************************)
	xGRMax_TK21(Gw := TKx_y_HI_Gw, Hy := TKx_y_HI_Hy, In := IN_TR.tT_ThR_Chamber2_1.Ai);
	
	xTON_TK2_1(IN := xGRMax_TK21.Q, PT := ti_TKx_y_HI_PTHI);
	xTK2_1_HI.QH  := xTON_TK2_1.Q;
	
	(****************************************)
	xGRMax_TK22(Gw := TKx_y_HI_Gw, Hy := TKx_y_HI_Hy, In := IN_TR.tT_ThR_Chamber2_2.Ai);
	
	xTON_TK2_2(IN := xGRMax_TK22.Q, PT := ti_TKx_y_HI_PTHI);
	xTK2_2_HI.QH  := xTON_TK2_2.Q;
	
	(*************** chamber temperature difference check for TRW06 - ThR ***************)
	IF FG_KLUM AND NOT Para.bThR2_Ena THEN
		TK1_DIF := ABS(IN_TR.tT_ThR_Chamber1_1.Ai  - IN_TR.tT_ThR_Chamber1_2.Ai);
	ELSE
		TK1_DIF := 0;
	END_IF;
	
	xGRMax_TK1DIF(Gw := rT_ThR_ChamberDiff, Hy := rT_ThR_ChamberDiffHy, In := TK1_DIF);
	xTON_TK1_DIF(IN := xGRMax_TK1DIF.Q, PT := ti_ThR_ChamberDiff);
	
	xGRMax_TK1Diff_switch(Gw := rT_ThR_ChDiff_switch, Hy := rT_ThR_ChDiff_switchHy, In := TK1_DIF);
	xTON_TK1_Diff_switch(IN := xGRMax_TK1Diff_switch.Q, PT := Para.ti_ThR_Val_y1);
	
	xTK1_DIF_HI.QH := xTON_TK1_DIF.Q OR xTON_TK1_Diff_switch.Q;
	
	(****************************************)
	IF FG_KLUM AND NOT Para.bThR2_Ena THEN
		TK2_DIF := ABS(IN_TR.tT_ThR_Chamber2_1.Ai - IN_TR.tT_ThR_Chamber2_2.Ai);
	ELSE
		TK2_DIF := 0;
	END_IF;
	
	xGRMax_TK2DIF(Gw := rT_ThR_ChamberDiff, Hy := rT_ThR_ChamberDiffHy, In := TK2_DIF);
	xTON_TK2_DIF(IN := xGRMax_TK2DIF.Q, PT := ti_ThR_ChamberDiff);
	
	xGRMax_TK2Diff_switch(Gw := rT_ThR_ChDiff_switch, Hy := rT_ThR_ChDiff_switchHy, In := TK2_DIF);
	xTON_TK2_Diff_switch(IN := xGRMax_TK2Diff_switch.Q, PT := Para.ti_ThR_Val_y1);
	
	xTK2_DIF_HI.QH := xTON_TK2_DIF.Q OR xTON_TK2_Diff_switch.Q;
	
	(*************** electrical heating temperature threshold check - ThR ***************)
	xGRMax_TK75(Gw := Para.rT_ThR_EH_Lim75, Hy := rT_ThR_EH_Lim75Hy, In := TK_moduleTR);
	xTK_E75.QH     := xGRMax_TK75.Q;
	
	(****************************************)
	xGRMax_TK50(Gw := Para.rT_ThR_EH_Lim50, Hy := rT_ThR_EH_Lim50Hy, In := TK_moduleTR);
	xTK_E50.QH     := xGRMax_TK50.Q;
	
	(****************************************)
	xGRMax_TK25(Gw := Para.rT_ThR_EH_Lim25, Hy := rT_ThR_EH_Lim25Hy, In := TK_moduleTR);
	xTK_E25.QH     := xGRMax_TK25.Q;	
	
	(****************************************)
	xGRMax_TK00(Gw := Para.rT_ThR_EH_Lim00, Hy := rT_ThR_EH_Lim00Hy, In := TK_moduleTR);
	xTK_E00.QH     := xGRMax_TK00.Q;
	
	(*************** aux.gas release temperature threshold check ***************)
	xGRMax_TKG(Gw := Para.rT_ThR_LimGas, Hy := Para.rT_ThR_LimGasHy, In := TK1_TK2_MIN);
	xTK_GAS.QH     := xGRMax_TKG.Q;
	
	(*************** operating temperature threshold check ***************)
	xGRMax_ThR_OperTemp(Gw := TK_w + rT_ThR_OperTemp_rel, Hy := rT_ThR_OperTempHy, In := TK_moduleTR);
	xTK_OPER.QH := xGRMax_ThR_OperTemp.Q;
	
	(********************************************************************)
	
	(* Klappenumschaltzeit [FB40] *)
	IF (Para.bThR_woGas AND set_PT_KL_Pinc) THEN	(* set the flap flap switching interval on load increase value *)
		PTON_KL_AUS := Para.ti_ThR_ValIntervalPInc; (* Seconds --> Milliseconds --> TIME *)
		PTON_KL_EIN := PTON_KL_AUS;
	ELSE
		d := REAL_TO_DINT(polyg_2hl (REAL_TO_INT(TK1_TK2_MAX), ADR(PT_KL)));	(* Seconds *)
		PTON_KL_AUS := DINT_TO_TIME (d * 1000);    	(* Seconds --> Milliseconds --> TIME *)
		PTON_KL_EIN := PTON_KL_AUS;
	END_IF;
	
	
	(* Ansteuerung Gasregelventil [FB66] *)
	
	IF OUT_TR.bThR_RelGas THEN	// control valve close command timer selection for stop of aux. gas system
		tiTP_NFRG_GASREG := T#180s;	//default timer
	END_IF
	IF (NOT OUT_TR.bThR_RelGas AND xRS_Thr_AuxGasStopT.Q1) THEN
		tiTP_NFRG_GASREG := tiTON_Thr_AuxGasStopT_reset;	//reduced timer
	END_IF
	
	xTP_NFRG_GASREG (IN := NOT OUT_TR.bThR_RelGas, PT := tiTP_NFRG_GASREG);
	xTP_BTRB (IN := IN_TR.tEng_Run.Do, PT := T#180s);
	
	IF xTP_NFRG_GASREG.Q THEN
		OUT_TR.tThR_CV_CDec.Do := TRUE;
		OUT_TR.tThR_CV_CInc.Do := FALSE;
	ELSIF xTP_BTRB.Q THEN
		OUT_TR.tThR_CV_CDec.Do := TRUE;
		OUT_TR.tThR_CV_CInc.Do := FALSE;
	ELSIF OUT_TR.bThR_RelGas THEN
		OUT_TR.tThR_CV_CDec.Do := bCtrl_ThR_CDec;
		OUT_TR.tThR_CV_CInc.Do := bCtrl_ThR_CInc;
	ELSE
		OUT_TR.tThR_CV_CDec.Do := FALSE;
		OUT_TR.tThR_CV_CInc.Do := FALSE;
	END_IF;
	
	(******************************************************************************)
	(******************************************************************************)
	
	(* IntegralElement *)
	
	FOR x := 0 TO 1 BY 1 DO
	
		(* output:               Out: units "In"
		   internal calculation: Out_internal: units "In" *100
		                         dOut: 0,1 units "In"/s = 0,01 units "In"/0,1s
		                                                = 0,01 units "In"/sample *)
		
		IF P_ramp[x].mode = 1 THEN
			P_ramp[x].dOut_plus  :=
				(P_ramp[x].Ki_plus  * (P_ramp[x].In - P_ramp[x].Out)) / P_ramp[x].In_ref;
			P_ramp[x].dOut_minus :=
				(P_ramp[x].Ki_minus * (P_ramp[x].Out - P_ramp[x].In)) / P_ramp[x].In_ref;
		ELSE
			P_ramp[x].dOut_plus  := P_ramp[x].Ki_plus;
			P_ramp[x].dOut_minus := P_ramp[x].Ki_minus;
		END_IF;
		
		IF P_ramp[x].dOut_plus  < 1 THEN
			P_ramp[x].dOut_plus  := 1;
		ELSIF P_ramp[x].dOut_plus  > P_ramp[x].dOut_max_p THEN
			P_ramp[x].dOut_plus  := P_ramp[x].dOut_max_p;
		END_IF;
		
		IF P_ramp[x].dOut_minus < 1 THEN
			P_ramp[x].dOut_minus := 1;
		ELSIF P_ramp[x].dOut_minus > P_ramp[x].dOut_max_m THEN
			P_ramp[x].dOut_minus  := P_ramp[x].dOut_max_m;
		END_IF;	
		
		P_ramp[x].In_internal := P_ramp[x].In;
		P_ramp[x].In_internal := P_ramp[x].In_internal * 100;
		
		(* Out > In: decrease Out *)
		IF P_ramp[x].Out_internal > P_ramp[x].In_internal THEN
			P_ramp[x].Out_internal := P_ramp[x].Out_internal - P_ramp[x].dOut_minus;
			IF P_ramp[x].Out_internal < P_ramp[x].In_internal THEN
				P_ramp[x].Out_internal := P_ramp[x].In_internal;
			END_IF;
		
		(* Out < In: increase Out *)
		ELSIF P_ramp[x].Out_internal < P_ramp[x].In_internal THEN
			P_ramp[x].Out_internal := P_ramp[x].Out_internal + P_ramp[x].dOut_plus;
			IF P_ramp[x].Out_internal > P_ramp[x].In_internal THEN
				P_ramp[x].Out_internal := P_ramp[x].In_internal;
			END_IF;
		END_IF;
		
		(* LIMIT Out_min, Out_max [units "In"]: *)
		IF P_ramp[x].Out_min < 0 THEN
			P_ramp[x].Out_min := 0;
		ELSIF P_ramp[x].Out_min > 32767 THEN
			P_ramp[x].Out_min := 32767;
		END_IF;
		IF P_ramp[x].Out_max < P_ramp[x].Out_min THEN
			P_ramp[x].Out_max := P_ramp[x].Out_min;
		ELSIF P_ramp[x].Out_max > 32767 THEN
			P_ramp[x].Out_max := 32767;
		END_IF;
		
		(* LIMIT Out_internal [units "In" *100]: *)
		IF P_ramp[x].Out_internal < (P_ramp[x].Out_min * 100) THEN
			P_ramp[x].Out_internal := P_ramp[x].Out_min * 100;
		ELSIF P_ramp[x].Out_internal > (P_ramp[x].Out_max * 100) THEN
			P_ramp[x].Out_internal := P_ramp[x].Out_max * 100;
		END_IF;
		
		P_ramp[x].Out := INT_TO_REAL(i32_t_i16 (REAL_TO_DINT(P_ramp[x].Out_internal)/100));	(* [units "In"] *)
	
	END_FOR;
	
END_PROGRAM
