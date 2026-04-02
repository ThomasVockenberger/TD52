(*******************************************************************************
EG_Scav			exhaust gas scavenging + N2 scavenging 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V06		24.03.2000	PA			erstellt
V11		04.07.2000	Pa			Stoerungsaufbereitung von p10 verschoben
V160	13.12.2001	LH			Ansteuerung Spuelventilator auch mit Gasventile offen
V170	04.02.2002	LH			Moeglichkeit Spuelung manuell zu starten
V190	10.05.2004	LH			Anpassung fuer CODINOX
 								Fehler bei manueller Spuelung ausgebessert
V212	06.06.2006	LH			angepasst an ESY-NEU
V230	12.12.2007	TW			Spuelzeit ist nun Parameter (ssTW_T_SPUEL) 
	 	30.01.2008	LH			Untergrenze für Spülzeit ist 47sec
V3.20.0	04.11.2010	lettenb.	purgecycle added, task spuelung renamed to spuelung_6
		14.01.2011 				sel_EGScav_if_AuxV_ok added, release exhaust gas scavenging depending on auxiliaries voltage

V1.70.1	20.03.2003	ThJ			Erweiterung auf N2-Spuelung
V1.70.2	04.05.2004	ThJ			Erweiterung N2-Spuelung von Baureihe 6 auf alle Baureihen
V1.70.3	10.11.2004	ThJ			steps 5 + 8: M_SPUELV hinzu fuer BR234
V1.70.4	15.05.2006	ThJ			Vorbelegung Option "two N2 valves" mit FALSE.
       		              		xx_T71 --> xx_TOF71, xx_T_SPUEL --> xx_TON_SPUEL.
V1.70.5	28.07.2006	ThJ			TwoN2Valves --> global, ANF_SPLV_MAN added,
       		              		N2 gas valves output, N2 valves position faulure modified.
V1.70.6	22.11.2007	ThJ			timer for reset SP_EIN / LUE100
                        		T1_SCAV_RUN: timer 80 --> 75 sec
                        		SCAV_RUN_STOE with filter BWS_A
                        		reset SCAV_RUN at BWS_H by STOP
V1.70.7 03.12.2008	lettenb. 	sel_N2, sel_TwoN2Valves added
V3.40.0	19.12.2012  lettenb.	T1_SCAV_RUN: SCAV_RUN --> STARTER_SC, PT: 75s --> 5s
.								(ueberwachung nun nicht mehr abhaengig von vorschmierzeit/motortemp...., test: SACC, leitner christian)
V3.90.0	25.10.2012	lettenb.	xTON_AuxDemDelayed, Para.bEGScav_Active added
V3.99.0	17.04.2012	lettenb.	EG scav.with all time running fan
		14.05.2013				EG scav.activation for BR6,9 added 								
		23.10.2013				624: delayed auxiliaries demand with EG scavenging
		28.10.2013				changes from V3.40.1 included, saver case (open flap and fan not demanded) solved
								reset manual scavenging from engine stop button changed > scav.stop button
								N2 scavenging and exhaust gas scavenging merged
		16.01.2014	lettenb.	V3.50 exh.gas scavenging after engine stop with gas train test added
		26.02.2014				tAuxV_Eng_ok.Di added, bugfix
V4.00.0	22.05.2014	lettenb.	T1_STSPKL: scav.valve monitoring open/closed status added, bugfix
V4.00.1 14.07.2014				NoScavFlap, NoScavFan: default = FALSE for EG scav.
		06.08.2014				reset VIS2MM.bN2ScavStart/Stop buttons added
		12.09.2014				SPUEL_ST: AND NOT OUT_EX.bScavFinished added(purge cycle: lock scav.during eng.oper.with eng.dem. off/on)
V4.00.2 30.10.2014	lettenb.	SPUEL_ST: OUT_EX.bScavFinished -> M_DREHZ (purge cycle: lock scav.during eng.oper.)
V4.00.3	20.03.2015	lettenb.	ScavValve opens after bScavFanOp=TRUE, ScavFanCoOn if ScavValve=open or not closed,
								3366 during purge -> close ScavValve(safety case:PW-ER-2015-0062-001)
		14.04.2015				corr.from test EG_Scav with purgecycle and/or purge before start(panian,glantschnig) 
		30.04.2015 				OUT_EX.tScavFanCoOn.Do:	IN_EX.tPB2MM.bSys_Run added to avoid bMsg1277 at cold restart
V4.03.0	18.09.2015				IN_EX.bRelEngTurn_OilSkid added for 920
		23.12.2015	lettenb.	OUT_EX.tScavFanCoOn.Do Para.bSel_N2 added, break running scavenging cycle in case of mains break down added,
								to avoid bMsg3366 after mains failure(restart ability)
        02.05.2016              xR_TRIG_M_AGFD: AND NOT M_DREHZ added, to avoid engine shutdown with demand off/on during running engine
V4.04.0 19.09.2016  lettenb.	T1_SCAV_RUN: SCAV_RUN --> STARTER_SC, PT: 75s --> 5s, bugfix, transfer xt4
                                bT1_STN2V: VIS2MM.bEGScavStop -> StopM, bugfix								
		14.03.2017	lettenb.	bN2_GASV: OR (NoScavFan AND NoScavFlap) added for BR234(sascha tonauer: U891)
V4.05.0 29.05.2017  lettenb.	fast start preparation: short EG  scavenging(50s) / init EG scavenging if not finished
		12.07.2017  Messner		rT_bScavValve plausibility check added
V4.05.1	16.03.2018	lettenb.	short scavenging only for 920 and only in MAN/AUT, bugfix
		30.07.2018	lettenb.	auto scavenging preparation for faststart
V4.06.0	04.07.2018	Perktold	don't start EGScav for fast start prep. if W3417 is present
V4.07.0 03.12.2018	lettenb.	option NoScavFan completed(SAFER Case ID: PWR-ER-2018-0159), bugfix for option N2 scav.without scav.fan
		13.05.2019	lettenb.	short scavenging only for 920FS for first start sequence, bugfix(request burkhardt wolfg.)
V4.10.0	14.12.2020	lettenb.	TON,TOF reset added to avoid time overrun, cleanup
V4.11.0	14.02.2022	lettenb.	in case of Eng_Dem_EPS wait until running scavenging cycle is finished to avoid engine start with open scavenging flap, bugfix
V4.12.0	14.12.2022	lettenb.	SPUEL_ST: start scavenging when engine is ready4autostart, to avoid scav. at engine demand, #875
								xR_TRIG_M_AGFD: with N2 always scav.before start, #811
								xTON_AB_SPUELV.PT:= T#13s -> 0s (removed in alignment with system owner/burkhart, flap closing is monitored with temp.sensor) 
								short scavenging time for FS preparation disabled(not allowed for standard!/TUEV germany)
								calculation of scavenging rest time prepared for HMI display for future(cleanup and learnings from saarbruecken AA46/wasserer)
V4.13.0	05.12.2023	Bacci		Added ventilation demand and release before starting the exhaust scavenging. Reset scavenging procedure when alarm 2295 occurs
V4.14.0	25.11.2024	Bacci		T6 Start procedure with purge start (2024-219): scavenging fan removal

Instructions for use:
--------------------
scavenging fan is always demanded with running engine for cooling of the scav.flap

scavenging functions without N2:
- EG scavenging after  every engine stop
- EG scavenging before every engine start interval if selected
- EG scavenging manual initiated by button
- no EG scavenging after engine stop with emergency stop OR firealarm
 
scavenging functions with N2:
- EG scavenging before every engine start interval
- EG scavenging manual initiated by button
- N2 scavenging after engine stop
- N2 scavenging after engine startup failure
- N2 scavenging with stopped engine manual initiated by button

observe options: NoScavFlap, NoScavFan, NoPrelube (for engine type 2,3,4)

double ignition: Logical\Ignition\2xzuend\2xzuendCyclic.st
add "AND NOT T_N2_GASV" to avoid ignition failure during stand still N2 scavenging
		(* Ignition 1 error 
		xTONIgn1FaultDelay(IN:= NOT IN_IG.bIgn_Dem AND IN_IG.tIgn_Run_Hal.Di, PT:=T#4s);
		ZEST_1 :=  (xTONIgn1FaultDelay.Q AND NOT T_N2_GASV)
				OR (IN_IG.bGV_On AND NOT IN_IG.bMsg1026 AND IN_IG.bIgn_Dem AND NOT IN_IG.tIgn_Run_Hal.Di);
			
		(* Ignition 2 error 
		xTONIgn2FaultDelay(IN:= NOT IN_IG.bIgn_Dem AND IN_IG.tIgn2_Run_Hal.Di, PT:=T#4s);
		ZEST_2 :=  (xTONIgn2FaultDelay.Q AND NOT T_N2_GASV)
				OR (IN_IG.bGV_On AND NOT IN_IG.bMsg1026 AND IN_IG.bIgn_Dem AND NOT IN_IG.tIgn2_Run_Hal.Di);

		(* flag for deactivating gas pressure monitoring 
		xTOF_T_N2_GASV(IN:= OUT_EX.tN2_ScavGV_CoOpen.Do, PT:= T#5s);
		T_N2_GASV := xTOF_T_N2_GASV.Q; 

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* Engine speed is below 50 rpm *)
	IF (IN_EX.rN_EngAct < 50.0) THEN	StopM := TRUE;	
	ELSE								StopM := FALSE;
	END_IF;
	
	(* prelube oil pressure 1 *)
	xGR_MAXR_VSD1(In:= IN_EX.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel1EOP_LimHi, Hy:= Para.rPr_Prel1EOP_HyHi);
	xTON_VSD1(IN:= xGR_MAXR_VSD1.Q AND IN_EX.tPB2MM.bParaSetupOk, PT:= T#2s);
	AN_VSD1 := xTON_VSD1.Q;
	
	(* speed limit *)
	xGR_MAXR_D1400(In:= IN_EX.rN_EngAct, Gw:= (Para.rN_EngNom - 100.0), Hy:= 10.0);
	M_D1400	:= xGR_MAXR_D1400.Q;
	
	(* Monitoring engine start speed  *)
	xGR_MAXR_MonEngStaSpeed(In:= IN_EX.rN_EngAct, Gw:= Para.rN_EngStartMon_LimHi, Hy:= Para.rN_EngStartMon_HyHi);
	AN_STRDRE :=  IN_EX.tPB2MM.bParaSetupOk AND xGR_MAXR_MonEngStaSpeed.Q;
	
	(* engine start speed *)
	xGR_MAXR_EngStaSpeed(In:= IN_EX.rN_EngAct, Gw:= Para.rN_EngStart_LimHi, Hy:= Para.rN_EngStart_HyHi);
	xTOF_MDREHZ(IN:= IN_EX.tPB2MM.bParaSetupOk AND xGR_MAXR_EngStaSpeed.Q, PT:= T#10s);
	M_DREHZ    := xTOF_MDREHZ.Q;
		
		
	(*-----------------------------------------------------------------------------------------------------*)
	(*-----------------------------------------------------------------------------------------------------*)
	(* manual demand exhaust gas scavenging *)
	VIS2MM.bEGScavStart;	VIS2MM.bEGScavStop;

	(* manual demand N2 gas scavenging *)
	VIS2MM.bN2ScavStart;	VIS2MM.bN2ScavStop;

	(* scavenging valve feedback signals *)		
	bScavVaIsOpened :=	IN_EX.tScavVaOpened.Di AND NOT IN_EX.tScavVaClosed.Di; (* scav.valve = opened *)
	bScavVaIsClosed :=	IN_EX.tScavVaClosed.Di AND NOT IN_EX.tScavVaOpened.Di; (* scav.valve = closed *)

	(* scavenging fan operating *)(**)
	bScavFanOp :=	(NOT xEngType.Type9 AND(IN_EX.tScavFanOp.Di OR NoScavFan))
				OR	(    xEngType.Type9 AND(IN_EX.tScavFanFC_Rdy.Di AND NOT IN_EX.tScavFanFC_P_Lo.Di));		      

	(*-----------------------------------------------------------------------------------------------------*)
	IF Para.bEGScav_Active OR Para.bSel_N2 OR xEngType.Type9  THEN	(* exhaust gas scavenging with N2 *)	
	
		OUT_EX.bRel_ScavN2 :=	Para.bSel_N2
						AND(    IN_EX.bGT2_Select OR NOT Para.bN2_NoScavGas1) 
						AND(NOT IN_EX.bGT2_Select OR NOT Para.bN2_NoScavGas2);
	
		(* option: no scavenging fan/flap *)
		NoScavFlap := FALSE;	//xEngType.Type2 OR xEngType.Type3 OR xEngType.Type4;
		NoScavFan  := FALSE;	//xEngType.Type2 OR xEngType.Type3 OR xEngType.Type4;
	
		(* option: no prelubrication *)
		NoPrelube  := xEngType.Type3 AND NOT Para.bEngTyp3_Prelub_Active;

		(* scavenging initiated by startup failure/error *)
		SCAV_RUN_STOE := IN_EX.bMsg1023 AND bOMSS_Aut;	
					 
		FG_SCAV_RUN :=	OUT_EX.bRel_ScavN2
				AND NOT M_DREHZ
				AND NOT IN_EX.bMsg1031
				AND NOT IN_EX.bMsg1054 
				AND NOT IN_EX.bMsg1060
			    AND NOT IN_EX.bMsg1108
				AND NOT IN_EX.bMsg1084
				AND NOT IN_EX.bMsg1056;
		
		FG_SCAV_RUN_2 :=	FG_SCAV_RUN 
					AND 	StopM 
					AND	  ((bOMSS_Scav AND VIS2MM.bN2ScavStart) OR (SCAV_RUN_STOE AND NOT M_SCAV_RUN));
					   
		xTON_SCR_OFF1(IN:= OUT_EX.bN2_ScavCoStarterOn, PT:= T#20s);
		
		IF     (NOT FG_SCAV_RUN 
			OR (    bOMSS_Scav AND     VIS2MM.bN2ScavStop)	
			OR (NOT bOMSS_Scav AND NOT bOMSS_MAT)
			OR (    bOMSS_Man  AND     VIS2MM.bN2ScavStop)
			OR (    bOMSS_Aut  AND NOT SCAV_RUN_STOE)
			OR	    T2_SCAV_RUN
			OR	    xTON_SCR_OFF1.Q) THEN	SCAV_RUN := FALSE;
		ELSIF FG_SCAV_RUN_2 THEN			SCAV_RUN := TRUE;
			IF SCAV_RUN_STOE THEN			M_SCAV_RUN := TRUE;
			END_IF;		 	
		END_IF;		
	
		IF NOT SCAV_RUN_STOE THEN
			M_SCAV_RUN := FALSE;
		END_IF;

	
		(*-------------------------------------------------------------------*)
		(* lockout scavenging after engine stop in case of: *)
		bNoScavAftEngStop := 	IN_EX.bMsg1031 
							OR	IN_EX.bMsg1054;

		(* short scavenging time for FS preparation *)
		IF IN_EX.tEng_Run.Do       THEN bFS_ScavTime := FALSE; (* not allowed for standard! *)
//		IF IN_EX.tEng_Run.Do       THEN bFS_ScavTime := TRUE;  (* enable only with special release, incl. risk analysis approval *)
		ELSIF IN_EX.bGV_On         THEN bFS_ScavTime := FALSE;
		END_IF;

		(* set/reset purge credit bit = bScavFinished *)
		xF_TRIG_M_GASV(CLK:= IN_EX.bGV_On);
		xR_TRIG_M_AGFD(CLK:= IN_EX.bEng_Dem AND NOT M_DREHZ AND (Para.bScavBeStart_Active OR Para.bSel_N2));
	
		IF 	  IN_EX.bEng_Dem_EPS AND(NOT Para.bEGScav_ifAuxV_ok OR NOT IN_EX.tAuxV_Eng_ok.Di) AND (StepCnt = 0)
														THEN OUT_EX.bScavFinished := 1; (*needed for emerg.power supply after plc-restart ! *)
		ELSIF bNoScavAftEngStop 						THEN OUT_EX.bScavFinished := 0; (* scavening after engine stop not released *)
															 bFS_ScavTime := FALSE;
		ELSIF xF_TRIG_M_GASV.Q							THEN OUT_EX.bScavFinished := 0; (* gas valves closed *)
		ELSIF xR_TRIG_M_AGFD.Q							THEN OUT_EX.bScavFinished := 0; (* scavenging before start *)
		ELSIF MM2VIS.bMsg3417   AND NOT IN_EX.bEng_Dem	THEN OUT_EX.bScavFinished := 0; (* pre chamber diff.press.high during engine stop (exh.gas scav.required before next start)*)
															 bFS_ScavTime := FALSE;
		ELSIF EDGEPOS(IN_EX.bMsg1084)					THEN OUT_EX.bScavFinished := 0;	(* signal failure prechamber gas pressure *)
															 bFS_ScavTime := FALSE;
		ELSIF EDGEPOS(IN_EX.bMsg1056)					THEN OUT_EX.bScavFinished := 0; (* safety loop engine *)
															 bFS_ScavTime := FALSE;
		ELSIF EDGEPOS(IN_EX.bMsg1027)					THEN OUT_EX.bScavFinished := 0; (* failure gas train 1 -(line 1)*)
															 bFS_ScavTime := FALSE;
		ELSIF EDGEPOS(IN_EX.bMsg3361)					THEN OUT_EX.bScavFinished := 0; (* failure gas train 1 - line 4 *)
															 bFS_ScavTime := FALSE;
		ELSIF EDGEPOS(IN_EX.bMsg3360)					THEN OUT_EX.bScavFinished := 0; (* failure gas train 1 - line 3 *)
															 bFS_ScavTime := FALSE;
		ELSIF EDGEPOS(IN_EX.bMsg3359)					THEN OUT_EX.bScavFinished := 0; (* failure gas train 1 - line 2 *)
															 bFS_ScavTime := FALSE;
		ELSIF EDGEPOS(IN_EX.bMsg1029)					THEN OUT_EX.bScavFinished := 0; (* failure gas train 2 *)
															 bFS_ScavTime := FALSE;
		ELSIF MM2VIS.bMsg3366							THEN OUT_EX.bScavFinished := 0; (* exhaust gas scavening fan failure BR2346 *)
															 bFS_ScavTime := FALSE;
		ELSIF MM2VIS.bMsg1165							THEN OUT_EX.bScavFinished := 0; (* exhaust gas scavening fan failure BR9 *)
															 bFS_ScavTime := FALSE;
		ELSIF MM2VIS.bMsg1092							THEN OUT_EX.bScavFinished := 0; (* exhaust gas scavening valve failure *)
															 bFS_ScavTime := FALSE;
		ELSIF EDGEPOS(IN_EX.tPB2MM.bSys_Run)			THEN OUT_EX.bScavFinished := 0; (* plc restart *)
															 bFS_ScavTime := FALSE;
		END_IF; 

		
		(*-------------------------------------------------------------------*)
		IF bOMSS_MAT AND NOT M_DREHZ AND (IN_EX.tEGScavStart_Ext.Di OR VIS2MM.bEGScavStart) THEN
			MAN_SPUEL := TRUE;		
		END_IF; 
		xTOF_MAN_SPUEL(IN:= MAN_SPUEL, PT:= T#2s);

		xTON_AutStartPrep(IN:= bOMSS_Aut AND NOT bGnlTrip AND NOT IN_EX.bEng_Dem AND NOT Para.bScavBeStart_Active AND NOT Para.bSel_N2, PT:= T#60s); (* do scavenging for auto start preparation *)

		(* scavenging start *)
 		SPUEL_ST :=	   (bOMSS_MAT 
				AND NOT	MM2VIS.bMsg1165 
				AND NOT MM2VIS.bMsg3417 
				AND    (IN_EX.bEng_Dem
					OR  xTON_AutStartPrep.Q
					OR (IN_EX.bFS_Act AND bOMSS_Aut)) 
				AND NOT OUT_EX.bScavFinished 
				AND    (IN_EX.bPurgeER_Rdy OR NOT Para.bPurgecycle_Active))
			OR  xTOF_MAN_SPUEL.Q;		

		(* scavenging before engine start *)
		SCAV_BEF :=		SPUEL_ST
				AND NOT M_DREHZ
				AND(NOT IN_EX.bEng_Dem_EPS OR (Para.bEGScav_ifAuxV_ok AND IN_EX.tAuxV_Eng_ok.Di)); 	(* no scav.in case of demand emergency supply *)

				
		(* scavenging after engine stop *)
		SCAV_AFT := FALSE;			
		IF (T1_StopM AND FG_SCAV_AFT AND NOT SCAV_RUN) THEN
			SCAV_AFT    := T1_StopM AND FG_SCAV_AFT AND NOT SCAV_RUN AND NOT bNoScavAftEngStop;		
			FG_SCAV_AFT := FALSE;
		ELSIF (NOT StopM AND (M_DREHZ OR SCAV_RUN) AND (OUT_EX.bRel_ScavN2 OR TRUE)) THEN
			FG_SCAV_AFT := TRUE;	
		END_IF;	
	   

		(*-------------------------------------------------------------*)
		IF EDGEPOS(SCAV_BEF OR SCAV_AFT) AND NOT bNoScavAftEngStop THEN	
			OUT_EX.bScavFinished := FALSE;				(* = engine start release = purge credit bit *)
			StepCnt 		:= 10;
		ELSIF NOT IN_EX.tAuxV_Eng_ok.Di THEN			(* break running scavenging cycle in case of mains break down during scavenging*)
			StepCnt 		:= 0;
		ELSIF IN_EX.bMsg1031 OR IN_EX.bMsg1054 OR MM2VIS.bMsg1092 OR MM2VIS.bMsg3366 OR IN_EX.bMsg2295 THEN	(* break running scavenging cycle *)
			StepCnt 		:= 0;
		ELSIF MAN_SPUEL AND VIS2MM.bEGScavStop THEN		(* break running man.scavenging cycle *)
			StepCnt 		:= 0;		
		END_IF;
	
	
		(*----------------------------------------------------------------*)
		IF StepCnt = 0 THEN
			M_SPUELV			:= FALSE;
			OUT_EX.bDemScavVa	:= FALSE;
			MAN_SPUEL			:= FALSE;
			xTON_T_SPUEL(IN:= FALSE, PT:= T#0s); (* reset timer out of stepper loop *)
			xTON_AB_SPUELV(IN:= FALSE, PT:= T#0s); (* reset timer out of stepper loop *)
			xTON_P_SPUEL(IN:= FALSE, PT:= T#0s); (* reset timer out of stepper loop *)
		END_IF;

		(*----------------------------------------------------------------*)
		(* Step 1: Open scavenging valve *)
		IF StepCnt = 10 THEN
			M_SPUELV 			:= TRUE;(**)

			IF bScavFanOp OR NoScavFan THEN
				OUT_EX.bDemScavVa := TRUE;
				StepCnt := StepCnt + 10;
			END_IF;
		END_IF;
 		
		(*----------------------------------------------------------------*)
		(* Step 2: Scavenging period *)
		IF StepCnt = 20 THEN

			IF (IN_EX.bFS_Act AND xEngType.Type9 AND bFS_ScavTime) THEN
					xTON_T_SPUEL.PT:= T#50s;			(* fast start scavenging time *)
					xTON_T_SPUEL(IN:=	OUT_EX.bDemScavVa
									AND	M_SPUELV);
			ELSE	xTON_T_SPUEL.PT:= Para.tiEGScavMin; (* standard   scavenging time *)
					xTON_T_SPUEL(IN:=	OUT_EX.bDemScavVa
									AND(bScavVaIsOpened OR NoScavFlap)
									AND	M_SPUELV);
			END_IF;	
			IF xTON_T_SPUEL.Q THEN
				OUT_EX.bDemScavVa := FALSE;
				StepCnt := StepCnt + 10;
			END_IF;
		END_IF;
	
		(*----------------------------------------------------------------*)
		(* Step 3: waiting period until scavenging valve is completly closed*)
		(*         scavenging fan off *)
		IF StepCnt = 30 THEN
			IF (IN_EX.bFS_Act AND xEngType.Type9 AND bFS_ScavTime) THEN
					xTON_AB_SPUELV.PT:= T#0s;  (* fast start scavenging *)
			ELSE	xTON_AB_SPUELV.PT:= T#0s;  (* standard   scavenging *)
			END_IF;
			xTON_AB_SPUELV(IN:= NOT OUT_EX.bDemScavVa AND (    bScavVaIsClosed OR NoScavFlap));
			xTON_CloScavVa(IN:= NOT OUT_EX.bDemScavVa AND (NOT bScavVaIsClosed OR NoScavFlap), PT:=T#15s); (* scav.flap estimated closing time for rest time calculation *)
			IF xTON_AB_SPUELV.Q THEN
				M_SPUELV := FALSE;
				StepCnt := StepCnt + 10;
			END_IF;
		END_IF;
	
		(*----------------------------------------------------------------*)
		(* Step 4: exhaust gas scavenging completed, release engine startup *)
		IF StepCnt = 40 THEN
			IF (IN_EX.bFS_Act AND xEngType.Type9 AND bFS_ScavTime) THEN
					xTON_P_SPUEL.PT:= T#0s; (* fast start scavenging *)
			ELSE	xTON_P_SPUEL.PT:= T#2s; (* standard   scavenging *)
			END_IF;
			xTON_P_SPUEL(IN:= NOT OUT_EX.bDemScavVa AND(bScavVaIsClosed OR NoScavFlap));

			IF xTON_P_SPUEL.Q AND (xTON_SCAV_OFF.Q OR NOT Para.bSel_N2) THEN (* +60s room ventilation at 100% when N2 scavenging *)
				OUT_EX.bScavFinished := TRUE;(* no scav.fan+valve failure! -> scav.is done*)(**)
				StepCnt := 0;
			END_IF;
		END_IF;

		(* calculation of scavenging rest time *)
		MM2VIS.bScavRun := xTON_T_SPUEL.IN OR OUT_EX.bDemScavVa OR (xTON_SCAV_OFF.IN AND Para.bSel_N2);
		IF MM2VIS.bScavRun THEN MM2VIS.tiScavRestTime := ((xTON_T_SPUEL.PT   - xTON_T_SPUEL.ET  )/1000)
								                       + ((xTON_AB_SPUELV.PT - xTON_AB_SPUELV.ET)/1000)
													   +(((xTON_CloScavVa.PT - xTON_CloScavVa.ET)/1000) * BOOL_TO_INT(NOT bScavVaIsClosed))
													   +(((xTON_SCAV_OFF.PT  - xTON_SCAV_OFF.ET )/1000) * BOOL_TO_INT(Para.bSel_N2));
		ELSE
			MM2VIS.tiScavRestTime := 0;
		END_IF

		(*----------------------------------------------------------------*)
		(*----------------------------------------------------------------*)
		(* command open/close scavenging valve  *)
		bScavVaCoOpen  := NOT MM2VIS.bMsg1092 AND     OUT_EX.bDemScavVa AND NOT bScavVaCoClose;
		bScavVaCoClose := NOT MM2VIS.bMsg1092 AND NOT OUT_EX.bDemScavVa AND NOT bScavVaCoOpen;
	   
		xTON_SPKAUF(IN:= bScavVaCoOpen,  PT:= T#0.5s);
		xTON_SPKZU (IN:= bScavVaCoClose, PT:= T#0.5s);

		OUT_EX.tScavVaCoOpen.Do  := xTON_SPKAUF.Q;
		OUT_EX.tScavVaCoClose.Do := xTON_SPKZU.Q;   

	   
		(* scavenging valve failure*)
		xTON_T1_STSPKL(IN:= IN_EX.tPB2MM.bSys_Run
					AND     IN_EX.tPB2MM.bParaSetupOk
					AND	  ((OUT_EX.tScavVaCoOpen.Do  AND NOT NoScavFlap AND NOT bScavVaIsOpened) 
						OR (OUT_EX.tScavVaCoOpen.Do  AND NOT NoScavFlap AND     bScavVaIsClosed)
						OR (OUT_EX.tScavVaCoClose.Do AND NOT NoScavFlap AND NOT bScavVaIsClosed)
						OR (OUT_EX.tScavVaCoClose.Do AND NOT NoScavFlap AND     bScavVaIsOpened)), PT:= T#35s); 
		T1_STSPKL := xTON_T1_STSPKL.Q; (* valve runtime monitoring *)
	
		xTON_T2_STSPKL(IN:= NOT IN_EX.tScavVaFailure.Di AND NOT NoScavFlap, PT:= T#2s);
		T2_STSPKL := xTON_T2_STSPKL.Q; (* temperature monitoring *)	

	
		(* scavenging fan at engine operation *)
		IF    IN_EX.bGV_On  OR SCAV_RUN THEN	BETR_SPUELV := TRUE;
		ELSIF T2_StopM AND NOT SCAV_RUN THEN	BETR_SPUELV := FALSE;
		END_IF;
		
		OUT_EX.bInLouDemEX :=			IN_EX.tPB2MM.bSys_Run (* inlet louver demand *)
								AND	NOT	NoScavFan 
								AND		(M_SPUELV OR(BETR_SPUELV AND Para.bSel_N2) OR(NOT NoScavFlap AND(IN_EX.tScavVaOpened.Di OR NOT IN_EX.tScavVaClosed.Di)));


		(* DO scavenging fan on *)
		OUT_EX.tScavFanCoOn.Do :=	(OUT_EX.bInLouDemEX AND IN_EX.bInLouRelVE) OR
									(IN_EX.tPB2MM.bSys_Run AND NOT NoScavFan AND IN_EX.bGV_On) OR
									(IN_EX.tPB2MM.bSys_Run AND NOT NoScavFan AND (NOT NoScavFlap AND(IN_EX.tScavVaOpened.Di OR NOT IN_EX.tScavVaClosed.Di)));
		
		(* Signal lamp scavenging *)	
		(* Engine room ventilation at 100% *)
		xTON_SCAV_OFF(IN:= T2_StopM AND NOT SCAV_RUN, PT:= T#60s);

		IF (SCAV_RUN OR M_SPUELV OR (NOT StopM AND M_DREHZ AND NOT IN_EX.bGV_On)) THEN 
			OUT_EX.tN2_ScavSigLampOn.Do := TRUE;
			OUT_EX.bInAirER_FanSet100   := TRUE;
		ELSIF (NOT M_SPUELV AND xTON_SCAV_OFF.Q) THEN 
			OUT_EX.tN2_ScavSigLampOn.Do := FALSE;
			OUT_EX.bInAirER_FanSet100   := FALSE;
		END_IF;	

		
		(* N2 gas valves for scavenging *)
		(* time delay for waiting during closing time of the gas valves *)
		bZM_N2_GASV :=	   (IN_EX.tScavVaClosed.Di OR NoScavFlap)  
					AND	NOT OUT_EX.bPr_N2_LoTon 
					AND 	OUT_EX.bRel_ScavN2 
					AND	   (IN_EX.tEG_ByVaOpened.Di OR IN_EX.tEG_BoVaOpened.Di); 
		

		(* N2 gas valves not for BR2,3,4 if nominal speed was reached (V1.70.2)*) 
		xTON_DREHZ_N2(IN:= M_DREHZ AND M_D1400, PT:= T#10s);
		IF xTON_DREHZ_N2.Q THEN M_DREHZ_N2 := TRUE;	// xSR_FA_M_DREHZ_N2 --> M_DREHZ_N2
		ELSIF NOT M_DREHZ  THEN M_DREHZ_N2 := FALSE;
		END_IF;

		bN2_GASV := 	bZM_N2_GASV 
				AND NOT StopM 
				AND NOT IN_EX.bGV_On
				AND    (SCAV_RUN OR (M_DREHZ  AND (NOT M_DREHZ_N2
                                                   OR  xEngType.Type6
                                                   OR  xEngType.Type9
                                                   OR (NoScavFan AND NoScavFlap))));//BR234
		
		xTON_N2_GASV(IN:= bN2_GASV, PT:= T#1s);
			
		(* switch N2 Gas Valve with reset as priority *)	
		IF     (StopM   
			OR  IN_EX.bGV_On 
			OR (NOT IN_EX.tScavVaClosed.Di AND NOT NoScavFlap) 
			OR  OUT_EX.bPr_N2_LoTon 
			OR  NOT OUT_EX.bRel_ScavN2 
			OR (NOT IN_EX.tEG_ByVaOpened.Di AND NOT IN_EX.tEG_BoVaOpened.Di)) THEN
		    OUT_EX.tN2_ScavGV_CoOpen.Do := FALSE;
		ELSIF xTON_N2_GASV.Q THEN
			OUT_EX.tN2_ScavGV_CoOpen.Do := TRUE;	
		END_IF;
		
		(* flag for deactivating gas pressure monitoring *)
		xTOF_T_N2_GASV(IN:= OUT_EX.tN2_ScavGV_CoOpen.Do, PT:= T#5s);
		T_N2_GASV := xTOF_T_N2_GASV.Q;	
		
		(* scavenging run of the engine (prelub. + starter) *)
		IF NOT SCAV_RUN THEN	
			OUT_EX.bN2_ScavCoStarterOn := FALSE;
			IF T1_StopM THEN
				OUT_EX.bN2_ScavCoPrelubeOn := FALSE;
			END_IF;
			xTON_START_SC(IN:= FALSE, PT:= T#0s);
		ELSE	
			OUT_EX.bN2_ScavCoPrelubeOn := TRUE;
			IF xEngType.Type9 THEN 	xTON_START_SC(IN:=  AN_VSD1 AND IN_EX.bRelEngTurn_OilSkid, PT:= T#60s);
			ELSE					xTON_START_SC(IN:=  AN_VSD1 OR NoPrelube,                  PT:= T#60s);
			END_IF;

			IF xTON_START_SC.Q THEN
				OUT_EX.bN2_ScavCoStarterOn := TRUE;
			END_IF;
		END_IF;	
		
		
		(* monitoring --------------------------------------------------*)
		(* N2 valves position failure *)
		IF Para.bSel_TwoN2Valves THEN
			bN2_GV_AnyClosed :=     IN_EX.tN2_GV1_Closed.Di OR      IN_EX.tN2_GV2_Closed.Di;
			bN2_GV_AnyOpened := NOT IN_EX.tN2_GV1_Closed.Di OR  NOT IN_EX.tN2_GV2_Closed.Di;
		ELSE
			bN2_GV_AnyClosed :=     IN_EX.tN2_GV1_Closed.Di;
			bN2_GV_AnyOpened := NOT IN_EX.tN2_GV1_Closed.Di;
		END_IF;

		bT1_STN2V	 := 	OUT_EX.bRel_ScavN2 
					AND NOT StopM
					AND 	M_DREHZ 
					AND NOT IN_EX.bGV_On
					AND(NOT M_DREHZ_N2 OR xEngType.Type6 OR xEngType.Type9);
		
		xTON_T1_STN2V(IN:= (	OUT_EX.tN2_ScavGV_CoOpen.Do AND bN2_GV_AnyClosed)
						OR (	bT1_STN2V					AND bN2_GV_AnyClosed)
						OR (NOT OUT_EX.tN2_ScavGV_CoOpen.Do AND bN2_GV_AnyOpened), PT:= T#5s);

		xTON_T2_STN2V(IN:=	IN_EX.bGV_On AND bN2_GV_AnyOpened, PT:= T#500ms);
		
		T1_STN2V := xTON_T1_STN2V.Q OR xTON_T2_STN2V.Q OR (NOT IN_EX.tEG_ByVaOpened.Di AND NOT IN_EX.tEG_BoVaOpened.Di);

		
		(* monitoring N2 gas valves position *)
		xTON_T1_SCAV_RUN(IN:= OUT_EX.bN2_ScavCoStarterOn AND bN2_GV_AnyClosed, PT:= T#5s);
		T1_SCAV_RUN := xTON_T1_SCAV_RUN.Q;
		
		(* monitoring scavenging time *)
		xTON_T2_SCAV_RUN(IN:= SCAV_RUN, PT:= T#120s);
		T2_SCAV_RUN := xTON_T2_SCAV_RUN.Q;	
		
		(* N2 gas pressure minimum *)
		xTON_GDMI_N2(IN:= NOT IN_EX.tPr_N2_Lo.Di, PT:= T#5s);
		OUT_EX.bPr_N2_LoTon := xTON_GDMI_N2.Q;	
		
		(* timer for engine standstill time from 50 rpm -> 0 rpm *)
		xTON_T1_StopM(IN:= StopM, PT:= T#4s);
		T1_StopM := xTON_T1_StopM.Q;	
		
		(* Timer for overlapping with the start of "scavenging after engine stop" *)
		xTON_T2_StopM(IN:= StopM, PT:= Para.tiEGScavMin);
		T2_StopM := xTON_T2_StopM.Q;

		
	(*-----------------------------------------------------------------------------------------------------*)
		(* Scavenging fan set-point *)
		IF (OUT_EX.tScavFanCoOn.Do AND IN_EX.tScavVaClosed.Di) THEN
			OUT_EX.tScavFan_Sp.Ao := 0.0;
		ELSE
			OUT_EX.tScavFan_Sp.Ao := 1.0;
		END_IF;	


	(*-----------------------------------------------------------------------------------------------------*)
	ELSE (* no exhaust gas scavenging *)
		xTON_SCR_OFF1(IN:= FALSE, PT:= T#0s);
		xTON_T_SPUEL(IN:= FALSE, PT:= T#0s);
		xTON_AB_SPUELV(IN:= FALSE, PT:= T#0s);
		xTON_P_SPUEL(IN:= FALSE, PT:= T#0s);
		xTON_SPKAUF(IN:= FALSE,  PT:= T#0s);
		xTON_SPKZU(IN:= FALSE, PT:= T#0s);
		xTON_T1_STSPKL(IN:= FALSE, PT:= T#0s);
		xTON_T2_STSPKL(IN:= FALSE, PT:= T#0s);
		xTON_SCAV_OFF(IN:= FALSE, PT:= T#0s);
		xTON_DREHZ_N2(IN:= FALSE, PT:= T#0s);
		xTON_N2_GASV(IN:= FALSE, PT:= T#0s);
		xTON_START_SC(IN:= FALSE, PT:= T#0s);
		xTON_T1_STN2V(IN:= FALSE, PT:= T#0s);
		xTON_T2_STN2V(IN:= FALSE, PT:= T#0s);
		xTON_T1_SCAV_RUN(IN:= FALSE, PT:= T#0s);
		xTON_T2_SCAV_RUN(IN:= FALSE, PT:= T#0s);
		xTON_GDMI_N2(IN:= FALSE, PT:= T#0s);
		xTON_T1_StopM(IN:= FALSE, PT:= T#0s);
		xTON_T2_StopM(IN:= FALSE, PT:= T#0s);

		xTOF_MAN_SPUEL(IN:= FALSE, PT:= T#0s);
		xTOF_T_N2_GASV(IN:= FALSE, PT:= T#0s);

		OUT_EX.bRel_ScavN2 := FALSE;
		OUT_EX.bScavFinished := TRUE;
	   	
	END_IF; 


	(*---------------------------------------------------------------------------------------*)
	(* delayed auxiliaries demand with EG scavenging --> MM_OP *)
	IF xEngType.Type9 THEN	
		IF Para.tiEGScavMin <= T#60s THEN	xTON_AuxDemDelayed.PT := T#0s;
		ELSE								xTON_AuxDemDelayed.PT := Para.tiEGScavMin - T#60s;
		END_IF;
	ELSIF Para.iEng_Motortype = 624 THEN	
		IF Para.tiEGScavMin <= T#120s THEN	xTON_AuxDemDelayed.PT := T#0s;
		ELSE								xTON_AuxDemDelayed.PT := Para.tiEGScavMin - T#120s;
		END_IF;
	ELSE
		IF Para.tiEGScavMin <= T#60s THEN	xTON_AuxDemDelayed.PT := T#0s;
		ELSE								xTON_AuxDemDelayed.PT := Para.tiEGScavMin - T#60s;
		END_IF;
	END_IF;	

	xTON_AuxDemDelayed(IN:= IN_EX.bEng_Dem);

	OUT_EX.bEGScav_Rdy := xTON_AuxDemDelayed.Q OR OUT_EX.bScavFinished;
	

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* Measuring Signal Plausibility Check - air temperature before exhaust gas scavening valve (Functional Safety) *)

	(* Timer for Engine Run and Engine Stop *)
	xTON_EngRun (IN:= IN_EX.tEng_Run.Do, PT:= T#10m);
	xTON_EGScav	(IN:= bTON_EngRun AND bScavVaIsOpened, PT:= T#25s);

	
	(* Set and Reset - Engine Run State *)
	IF xTON_EngRun.Q 			THEN bTON_EngRun := TRUE;	END_IF;	(* Engine Running for given time *)
	IF EDGENEG(bScavVaIsOpened) THEN bTON_EngRun := FALSE; 	END_IF;	(* Falling Edge om Scavenging Fan ON *) 
	
	
	(* Rising Edge on Engine Timer *)
	xR_TRIG_StorePreEGScavValue (CLK:= IN_EX.tPB2MM.bSys_Run AND bTON_EngRun AND OUT_EX.tScavVaCoOpen.Do);
	xR_TRIG_StoreAftEGScavValue (CLK:= IN_EX.tPB2MM.bSys_Run AND xTON_EGScav.Q);

	
	(* Save Variables on lokal Storage *)
	IF xR_TRIG_StorePreEGScavValue.Q 	THEN rT_bScavValve_PreEGScavValue := IN_EX.tT_bScavValve.Ai;	
	END_IF;
	IF xR_TRIG_StoreAftEGScavValue.Q 	THEN rT_bScavValve_AftEGScavValue := IN_EX.tT_bScavValve.Ai;	
	END_IF;
	
	
	(* Reset Saved Values if Warning Reset*)
	IF bT_bScavValve_PcheckFail AND IN_EX.tAB2EX.bResetWarning THEN 
		rT_bScavValve_PreEGScavValue 	:= 0.0; 
		rT_bScavValve_AftEGScavValue 	:= 0.0;
	END_IF;

	
	(* Set Trigger Variable *)
	IF MM2VIS.bMsg2468 THEN															bT_bScavValve_PcheckFail := FALSE;
	ELSIF (rT_bScavValve_PreEGScavValue = 0.0) THEN									bT_bScavValve_PcheckFail := FALSE; 	(* value not valid *)
	ELSIF (rT_bScavValve_AftEGScavValue = 0.0) THEN									bT_bScavValve_PcheckFail := FALSE; 	(* value not valid *)
	ELSE
		IF (rT_bScavValve_PreEGScavValue - rT_bScavValve_AftEGScavValue) < 5 THEN	bT_bScavValve_PcheckFail := TRUE;	(* Air temperature changed less then 5°C *)
		END_IF;
		
		IF xR_TRIG_StoreAftEGScavValue.Q THEN			(* Reset saved temperatures - Valve closes *) 
			rT_bScavValve_PreEGScavValue 	:= 0.0; 
			rT_bScavValve_AftEGScavValue 	:= 0.0;
		END_IF;
	END_IF; 
	
	
	(*---------------------------------------------------------------------------------------*)
	(* reset VIS2MM var. *)
	VIS2MM.bEGScavStart := FALSE;	
	VIS2MM.bEGScavStop  := FALSE;
	VIS2MM.bN2ScavStart := FALSE;	
	VIS2MM.bN2ScavStop  := FALSE;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)

	
END_PROGRAM
