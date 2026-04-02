(********************************************************************
Aux_9	BR9: auxiliaries control 

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2023
 
Customized modifications: -
------------------------
 
History:
-------
V01		06.07.1998	Pa			erstellt
 		24.11.1998	Pa			korrekturlesung
V06		24.03.2000	Pa			FRG Kühlwasserdrucküberwachung
 		28.03.2000	Pa			wieder raus damit
V11		04.07.2000	Pa			Eigener Baustein für BR6
V160	30.11.2001	LH			Ansteuerung Motorkühlwasserpumpe und Vorwärmpumpe geändert!
V170	03.04.2002	LH			Aktivierung Öldrucküberwachung in pb10 verlegt
V172	19.09.2002	LH			Kontaktplanfehler behoben
V181	06.06.2003	LH			Ansteuerung Vorwärmheizung richtiggestellt
 								Minimumlaufzeit 5 MIN für Turboladernachschmierung
 								(NOT-AUS nicht mehr aktiv)
 								Nachkühlzeit 20 MIN --> 40 MIN
V182	02.10.2003	LH			Nachkühlzeit 40 MIN --> 20 MIN (Entwicklung!)
 								Nachkühlung auch bei Leistungsdifferenz maximum 
 								und Ölstand minimum wenn Level wieder überschritten
V207	23.09.2004	LH			Variante Turbolader mit Wasserkühlung
V2071	07.02.2005	LH			Verzögerung Freigabe Ölnachfüllventil
 								Umschaltung Spannung für Hilfsbetriebe
 		02.02.2005	LH			Analogwert Vorkammerdifferenzdruck eingeführt
V2071b	28.06.2005	LH			TW_ZUEND_PUFF ... 500ms --> 200ms
V210	18.04.2005	LH			Deaktivierung Verpuffungsschutz nur bei XT
V220	19.02.2007	LH			angepasst für X20-Einführung 
 		10.05.2007	LH			Abschaltmöglichkeit Vorwärmheizung bei überwachter Vorwärmpumpe 
V230	15.01.2008	LH			Einstellung ATL_H2O --> settings
 		19.03.2008	TM			NW8 bBlockOel_Bh hinzu
 		31.03.2008	TM			NW8 variable name changed TO bBlockOil_Bh
V2.50.0	28.01.2009	lettenb.	calm: TW_T117 removed, different time FOR BRx
                                T85 logic changed, VSP_24 logic changed
        23.02.2009				FA_T85 removed
V3.20	20.07.2010	Kopp		A_MKWP nur wenn NVW1 offen, Variabelen aus analogen Füllstandssensor angebunden
		27.07.2010	lettenb		TON_prelube added, anforderung vorschmierung sofort mit M_AGFD
		15.09.2010	MM (BuR)	PRELUBE_IgnST included
		07.12.2010	lettenb.	ton_T117: PRELUBE_IgnST added
		27.10.2010	MM (BuR)	gen_sch replaced with GCB_ON_TC1
		27.10.2010	MM (BuR)	net_sch replaced with MCB_ON
		08.11.2010 	ZM_OMAX 	moved TO alarms10xx, DI_AuxV_Eng_ok, DI_FS_ECW added
		09.03.2011				QUITT_AB substituted BY reset_alarm[1094] FOR alarm bypass
		13.08.2010	koppm.		preheating flap can NOT be closed with engine cooling water pump active
								postion signal failure time increased from 1s TO 25s
V3.90.0	05.12.2012	lettenb.	IN_AG.bECW_PreH_Dem_Customized added (for testbench P3)
V3.99   28.02.2013  pankajrodey	Generated FOR modular software with changes FOR V3.30
V3.99.1 15.03.2013	pankajrodey	Changes FOR V3.40, additinal logic FOR bMsg2284
		28.05.2013	lettenb.	bTestEnabled Para -> loc.var
		04.06.2013	lettenb.	bEmLubDem: emergency lubrication with el.oil pumps added
		23.07.2013				oil_c_9 moved TO Aux_9, MM2VIS.bMsg1060 --> xTON_Pr_Prelub.Q bugfix
		02.12.2013				MM2VIS.rTC_EOP_On -> MM2VIS.bTC_EOP_On datatype changed, bugfix
		18.11.2014				check FOR 920 acc.a_v359
v4.00.0	13.01.2015	lettenb.	oil refill: IN_AG.tEO_Level.GoodQual added instead off default value in CASE OF MS failure
		22.01.2015				OUT_AG.tECWP_PreH_Dem.Do: NOT IN_AG.tECWP_Op.Di, bTC_CoolDownRun removed (920 stapelfeld)
		18.03.2015	lettenb.	bugfix (920 sky), Para.rPr_Prel2EOP_LimHi removed FOR var.1 oil pump
		23.04.2015				VORW_OIL: AND NOT MM2VIS.bMsg2642 added, lockout preheating at sig.fail.oil pan temp. 
		26.06.2015				tECWP_PreH_Dem.Do: MM2VIS.bMsg2600(preheating pump circuit breaker tripped)added
								tECW_PreH_Dem.Do: MM2VIS.bMsg2264/bMsg2589(engine cooling water preheat.temp.high)added
V4.03.0	21.07.2015	lettenb.	TC_EOP_OnUSV.Do removed, 24VDC TC_oilpump FOR cooldown new
								M_OP: IN_AG.tTCOP_Grid.Di added, no demand 400V engine oil pump together with 24VDC TC_pump(pfluger) 
		29.07.2015	lettenb.	xTOF_Eng_MonOff moved from OP -> AG
 		07.08.2015  Denk		Manual operating auxiliaries control functionality added
		16.10.2015	lettenb.	interval TC cooldown, 24VDC TC oil pump version added
		21.10.2015				xTOF_EO_PrelubeDemIgn: ignition selftest postlube time added
		01.12.2015				bEO_PreH_MonRel,bEOP_PreH added, bugfix oil pump lag run
		12.01.2016	lettenb.	bPr_PreLub_Lo: adapted FOR 1 oilpump without FC
		15.01.2016				OUT_AG.tECWP1Dem.Do: bECW_PreHV_Active added FOR TCA-redesign
V4.04.0	11.05.2016	lettenb.	tEOF_PreheatRel.Do: bEOP_PreH added (release valve opening only during preheating)
								VSP_400, OUT_AG.tTC_EOP_On.Do, bEO_PreH_MonRel: AND NOT MM2VIS.bMsg1054 added (no oil pumps/preheating at fire alarm/ralf kätscher)
		25.10.2016				OUT_AG.tEOVal_DemOpen.Do: IN_AG.tT_EO_Pan > 70.0 added (feyrsinger)
		24.11.2016				xTON_TL_OP_Ein.PT, xTOF_OCTC_CoolDown.PT oil pump FU setpoint 100% FOR interval cool down, bugfix  
		21.02.2017				xTON_Pr_TCOaF_Prelub_Lo: bTC_CollDownRun -> bOCTC_CoDoRun (no monitoring in interval pause, glantschnig)
V4.05.0 28.02.2017	lettenb.	EO_PreH locked with 2590,2423,2265, SWAT920/1
        27.03.2017              permanent prelubrication FOR fast start added, GR_MAX_OIL_STARTFG moved to OpState and MsgAG
V4.05	18.07.2017	Messner		Oil circuit fast start V2 - manual mode start (bShortPreLubeTime), interval pre lubrication (bPreLubeDem_Interval), timed preheating deleted
		07.08.2017	502423184	due TO SWAT #3: no block OF the pre-heating due TO measuring failure OF oil pan temperatur AND
										use enigne oil inlet temperature as a fall-back signal FOR the pre-heating
		18.07.2017	Messner		Active Cooling Program (ACP) pump contol added
		24.01.2018	lettenb.	bOCTC_CoDoRun: (IN_AG.bEng_Aux_Dem_TOF OR NOT OMIN_NK) removed(causes low oilpump speed after 5' cool down in case of oil level low), bugfix 
V4.06.0	23.07.2018	Schmid		bFS_Req logic changed from bOMSS_MAT to bOMSS_Aut (synchronised with BR6)
V4.07.0	25.04.2018	lettenb.	workaround eng.oil pressure min.monitoring
		29.06.2018				interval prelubrication reset with eng.demand, bugfix
		01.08.2018	lettenb.	jump min prelube time in case of intervall prelub.for faststart
		25.10.2018	Schmid		OUT_AG.tEOVal_DemOpen.Do: swapped IN_AG.tEO_Refill.Di with bEO_Refill, bugfix
		06.03.2019	Schmid		Bugfix: ManAuxCtr for ECWP off corrected (was connected to ManAuxCtr of ECW heating element off)
		22.03.2018	Schmid		stop turbo charger cool down run if emergency stop button is pressed
		01.04.2019	lettenb.	OUT_AG.bPreL_FS_EngStaRel := FALSE for interval prelubrication (engine start only when VSD2 is reached), bugfix 
		26.04.2019	Schmid		A1031 safety loop emergency stop push button AND A1054 fire alarm split on HW side - adaptations TO preserve prior functionality
V4.07.1	05.06.2019	Schmid		decided on conditions for permanent prelube (30s fast start)/interval prelube (300s fast start)
V4.09.0	30.09.2019	Schmid		perm. prelube interrupted by A1018 engine oil level low
V4.10.0	20.08.2020	Schmid		bugfix failed TC post cooling counter - ensure correct monitoring time
		23.12.2020	Schmid		ManAuxCtr prelube pump, prelube time parameter, A1060 monitoring activation delay after A1018 for oil exchange
V4.11.0	02.02.2022	Schmid		stop preheating (pump+heater) in case of A1050 ECW pressure maximum
V4.11.2	23.02.2022	Schmid		bugfix: start prelube with auxiliaries demand instead of engine demand
V4.12.0	17.02.2023	Tinello		QCase 1361: 4 new parameters for turbocharger post cooling intervall
V4.13.0	03.08.2023	Tinello		BugFix #1236 no engine start in preheating mode
		08.11.2023	Tinello		oil refill monitoring, oil level high warning (W2435), bus signal for stopping external EO refill pump
V4.14.0	04.12.2024	Zengerer	oil fill valve demand extension for pump stop time (->QC2360)
		10.12.2024	Nagy		bAMM_9513 added for Oil Refill Failure (2024-225)

Instructions FOR use:
--------------------
prelubrication: turbo chargers(TC's) need prelubrication, 
				TC prelub.pressure is monitored as part of the start release procedure,
				the lubrication is done by the mechanical oil pump beginning with turning engine.

cool down for oil cooled TC's(920):	continuous cool down phase followed by interval cool down,
									with 400VAC oil pump (cool down AND post lubrication after engine stop)
									  OR  24VDC oil pump in CASE OF mains failure	
__________________________________________________
engine 			920					920		
__________________________________________________
TC				ABB	Power2-550		ABB Power2-650
TC cooling		oil					oil				(Para.bTC_watercooled)
cool down time	20'/80'				30'/90'			(continuous cool down phase directly after engine stop - after: pulses of interval cooldown)
twin stage		true				true			(Para.bTSTC_Exist)
____________________________________________________


Outstandings:
------------

interval prelubrication FOR 300s faststart
------------------------------------------

permanent prelubrication FOR 30s faststart
------------------------------------------
IN_AG.bPermPreLube_Dem
OUT_AG.bPreL_FS_EngStaRel

OUT_AG.tTCOV_CoClose.Do								M.03-YCS-003

IN_AG.tPr_TCO.Ai				TC oil pressure		M.03-PI-063
Para.bPr_TCO_Active
Para.rPr_TCO_ScalMin
Para.rPr_TCO_ScalMax

Para.rT_EO_PreH_FS_Min
Para.rT_EO_PreH_FS_HyMin

Para.rPr_EO_FSPreL_LimLo
Para.rPr_TCO_FSPreL_LimHi
Para.rPr_TCO_FSPreL_LimLo

rPr_TCO_FSPreL_LimHi : (*Para: pressure oil before turbo charger limit high - permanent prelubrication [bar]
rN_TCO_FS : (*Para: speed point fast start [rpm]
rPr_EO_PreH_LimLo : REAL; (*Para: engine oil pressure limit low preheating [bar]


W2427 permanent prelubrication - engine oil pressure low
A2311 permanent prelubrication - turbo charger oil pressure high = turbo charger oil valve failure


*********************************************************************************************)

PROGRAM _CYCLIC

IF (xEngType.Type9) THEN
	(*---------------------------------------------------------------------------*)
	(* preliminary settings for TCA-redesign *)
	bECW_PreHV_Active := FALSE; (* TCA-redesign: no valve! *)
	                            (* rosenheim, stapelfeld, sky, acea: with valve! *)
		
	(*----------------------------------------------------------------------------*)
	(* auxiliary voltage available -> mains supply *)
	xTON_SPG_N(IN:= IN_AG.tAuxV_Eng_ok.Di, PT:= T#1s);
	OUT_AG.tAuxPoSuMains.Do := xTON_SPG_N.Q;


	(* no auxiliary voltage -> Switch to Inverter *) 
	xTON_SPG_W(IN:= NOT IN_AG.tAuxV_Eng_ok.Di, PT:= T#1s);
	OUT_AG.tAuxPoSuUPS.Do := xTON_SPG_W.Q;


	(*----------------------------------------------------------------------------*)
	(* engine preheating water pump *) 
	A_VORW_TEMP1 :=        (IN_AG.bEng_Aux_Dem_TOF OR bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized) 
					AND NOT IN_AG.bEng_Aux_Dem_CDR 
					AND NOT IN_AG.bMsg1019
					AND	NOT	IN_AG.bMsg1050
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054
					AND NOT MM2VIS.bMsg2600
					AND NOT bACP_Start;									(* Active Cooling Oil active *)

	OUT_AG.tECWP_PreH_Dem.Do :=     A_VORW_TEMP1 AND NOT (Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECWP_PreH_COf)
								AND(IN_AG.tAuxV_Eng_ok.Di OR (NOT IN_AG.bDemScavVa AND IN_AG.tScavVaClosed.Di));


	(* engine preheating *) 
	OUT_AG.tECW_PreH_Dem.Do	:= (bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized) 
						AND 	OUT_AG.tECWP_PreH_Dem.Do 
						AND NOT AN_VORW 
						AND NOT MM2VIS.bMsg2589
						AND NOT MM2VIS.bMsg2264
						AND 	IN_AG.tPB2MM.bParaSetupOk 
						AND    (T_RM_VWP OR NOT Para.bTC_watercooled)
						AND NOT (Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECW_PreH_COf);

	(* engine preheating water pump ready for operation *)
	(* flow switch only if water cooled turbo chargers, for TC cooldown *)
	xTON_RM_VWP(IN:= IN_AG.tFS_ECW.Di, PT:= T#5s);
	T_RM_VWP := xTON_RM_VWP.Q;


	(*----------------------------------------------------------------------------*)
	(* release oil refill *)
	xTON_BTRB(IN:= IN_AG.tEng_Run.Do, PT:= T#30m);
	BTRB_30M := xTON_BTRB.Q;

	(* engine oil level high alarm *)
	xGR_MAX_OMAX(In:= IN_AG.tEO_Level.Ai, Gw:= Para.r_EO_LevelLimMax, Hy:= Para.r_EO_LevelHyLimMax);
	bEO_Level_Hi := xGR_MAX_OMAX.Q AND IN_AG.tEO_Level.GoodQual;

	(* engine oil level high warning *)
	xGR_MAXR_OMAX_W(In:= IN_AG.tEO_Level.Ai, Gw:= Para.r_EO_W_LevelLimMax, Hy:= Para.r_EO_LevelHyLimMax);
	bEO_Level_W_Hi := xGR_MAXR_OMAX_W.Q AND IN_AG.tEO_Level.GoodQual;

	(* oil overfill protection -> engine oil level max signal for customer bus *)
	OUT_AG.bCust_EO_Level_Hi	:= MM2VIS.bMsg1051 OR MM2VIS.bMsg2435;

	(* engine oil level low alarm *)
	xGR_MIN_OMIN(In:= IN_AG.tEO_Level.Ai, Gw:= Para.r_EO_LevelLimMin, Hy:= Para.r_EO_LevelHyLimMin);  
	xTON_OilMin(IN:= IN_AG.tPB2MM.bSys_Run, PT:= T#1m);			(* delay after cold restart(IN_AG.tEO_Level.Ai strong filtered) *)
	bEO_Level_Lo := xGR_MIN_OMIN.Q AND IN_AG.tEO_Level.GoodQual AND xTON_OilMin.Q;

	(* engine oil level low warnung *) (* SWAT #3 *) 
	xGR_MINR_OMIN_W(In:= IN_AG.tEO_Level.Ai, Gw:= Para.r_EO_W_LevelLimMin, Hy:= Para.r_EO_LevelHyLimMin);
	xTON_OilMin_W(IN:= IN_AG.tPB2MM.bSys_Run, PT:= T#1m);			(* delay after cold restart(IN_AG.tEO_Level.Ai strong filtered) *)
	bEO_Level_W_Lo := xGR_MINR_OMIN_W.Q AND IN_AG.tEO_Level.GoodQual AND xTON_OilMin_W.Q;

	(* open/close engine oil refill valve *)
	xGR_MAX_OELVZ(In:= IN_AG.tEO_Level.Ai, Gw:= Para.r_OV_LimClose, Hy:= Para.r_OV_HyLimClose);
	xGR_MIN_OELVA(In:= IN_AG.tEO_Level.Ai, Gw:= Para.r_OV_LimOpen , Hy:= Para.r_OV_HyLimOpen);
	
	IF NOT IN_AG.tEO_Level.GoodQual			THEN bEO_Refill := FALSE;
	ELSIF xGR_MIN_OELVA.Q AND BTRB_30M		THEN bEO_Refill := TRUE;
	ELSIF xGR_MAX_OELVZ.Q		  			THEN bEO_Refill := FALSE;
	END_IF;			

	(* engine oil refill valve *)
	bEOVal_DemOpen			 :=	M_DREHZ AND IN_AG.bEng_Dem			//changed in V4.14; old:	OUT_AG.tEOVal_DemOpen.Do :=	M_DREHZ AND IN_AG.bEng_Dem
						AND	  ((IN_AG.tT_EO_Pan.Ai > 70.0) OR MM2VIS.bMsg2642 OR NOT Para.bT_EO_Pan_Active)
						AND 	IN_AG.tEO_Level_Hi.Di
						AND NOT (bEO_Level_Hi OR bEO_Level_W_Hi)
						AND	  ((bEO_Refill AND NOT MM2VIS.bMsg2576) OR IN_AG.tEO_Refill.Di)
						AND 	BTRB_30M
						AND NOT b_OilRefillBlocked
						AND NOT MM2VIS.bMsg9378
						AND NOT MM2VIS.bMsg2284;
	xTOF_EOVal_DemOpen (IN:= bEOVal_DemOpen, PT:= Para.tiFreshOilPump_Delay );  // PT:= T#5s		);		(*fill valve demand extension for pump stop time*) 
	OUT_AG.tEOVal_DemOpen.Do :=	(  xTOF_EOVal_DemOpen.Q																		(*normal oil refill with fill valve time extension*)
								OR (MM2VIS.bInitialOilFill_DemOpen AND (IN_AG.tEO_Refill.Di OR VIS2MM.bDem_Oil_Filling)) )	(*initial engine oil filling*)
						AND 	IN_AG.tEO_Level_Hi.Di 				(*oil level indicator*)
						AND NOT MM2VIS.bMsg2284						(*level engine oil sump is ok*)
						AND NOT MM2VIS.bMsg9378						(*limit oil refill volume is ok (T9 existing)*)
						AND	NOT	MM2VIS.bMsg1054						(*BAL*)
						AND	NOT	IN_AG.bMsg1056	;					(*RUHE*)

	bAMM_9513 := OUT_AG.tEOVal_DemOpen.Do AND IN_AG.tEO_Refill.Di;	
		
	(* engine oil level low *)
	xTOF_Eng_MonOff(IN:= OUT_AG.bEng_Start, PT:= T#10s);	(* engine monitoring off during start /ex T9 *)

	xTON_OMIN(IN:= (NOT IN_AG.tEO_Level_Lo.Di OR bEO_Level_Lo)	AND NOT xTOF_Eng_MonOff.Q, PT:= T#10s);
	OUT_AG.bEngOilLevel_Lo := xTON_OMIN.Q;

	(* engine oil level low warnung *) (* SWAT #3 *) 
	xTON_W_OMIN(IN:= (bEO_Level_W_Lo) AND NOT IN_AG.bEng_MonOff, PT:= T#10s);
	OUT_AG.bEngOilLevel_W_Lo := xTON_W_OMIN.Q;

	OMIN_NK 	:= (OUT_AG.bEngOilLevel_Lo OR (OMIN_NK AND MM2VIS.bMsg1018) ) 
			AND NOT IN_AG.bEng_Aux_Dem_TOF;


	(*----------------------------------------------------------------------------*)

	(* power supply prelube pump OK *)
	OUT_AG.bEOP_AC_PowSupOk := IN_AG.tAuxV_Eng_ok.Di AND IN_AG.tEOP_FC_Rdy.Di AND IN_AG.tEOP1AC_CB_trip.Di;

	(*---------------------------------------------------------------------------*)
	(* prelube oil pressure limit for 1 pump operation *)
	(* SWAT#3 adation *)
	xGR_MAXR_VSD1(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel1EOP_LimHi, Hy:= Para.rPr_Prel1EOP_HyHi);
	xGR_MAXR_VSD1_2(In:= IN_AG.tPr_EOF_After.Ai, Gw:= Para.rPr_Prel1EOP_LimHi, Hy:= Para.rPr_Prel1EOP_HyHi);
	xTON_VSD1(IN:=      (xGR_MAXR_VSD1.Q   OR (NOT IN_AG.tPr_EngLubOil.GoodQual))	(* SWAT920/5b *)
					AND (xGR_MAXR_VSD1_2.Q OR (NOT IN_AG.tPr_EOF_After.GoodQual))	(* SWAT920/5b *)
					AND IN_AG.tPB2MM.bParaSetupOk , PT:= T#2s);						
	AN_VSD1 := xTON_VSD1.Q;

	(* prelube oil pressure limit for 2 pumps operation *)
//	xGR_MAXR_VSD2(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel2EOP_LimHi, Hy:= Para.rPr_Prel2EOP_HyHi); (* var: 2 pumps - future *)
	(* SWAT#3 adation *)
	xGR_MAXR_VSD2(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel1EOP_LimHi, Hy:= Para.rPr_Prel2EOP_HyHi); (* var: 1 pump  Para.rPr_Prel2EOP_LimHi not relevant *)
	xGR_MAXR_VSD2_2(In:= IN_AG.tPr_EOF_After.Ai, Gw:= Para.rPr_Prel1EOP_LimHi, Hy:= Para.rPr_Prel2EOP_HyHi); (* var: 1 pump  Para.rPr_Prel2EOP_LimHi not relevant *)
	xTON_VSD2(IN:= 		(xGR_MAXR_VSD2.Q   OR (NOT IN_AG.tPr_EngLubOil.GoodQual))	(* SWAT920/5b *)
					AND (xGR_MAXR_VSD2_2.Q OR (NOT IN_AG.tPr_EOF_After.GoodQual))	(* SWAT920/5b *)
					AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#2s);
	AN_VSD2 := xTON_VSD2.Q;

	(* turbo charger oil pressure prelubrication: release engine start *)
	xTON_Pr_Oil_LPTC_In_A_RelMon(IN:= IN_AG.tPr_Oil_LPTC_In_A.GoodQual, PT:= T#2s);
	xTON_Pr_Oil_LPTC_In_B_RelMon(IN:= IN_AG.tPr_Oil_LPTC_In_B.GoodQual, PT:= T#2s);
	IF (xTON_Pr_Oil_LPTC_In_A_RelMon.Q AND Para.bPr_Oil_LPTC_In_A) AND (xTON_Pr_Oil_LPTC_In_B_RelMon.Q AND Para.bPr_Oil_LPTC_In_B) THEN
		tPr_TCLubOil_Min.Ai	:= rPr_Oil_LPTC_In_Min	:= MIN(IN_AG.tPr_Oil_LPTC_In_A.Ai, IN_AG.tPr_Oil_LPTC_In_B.Ai);
		tPr_TCLubOil_Max.Ai	:= rPr_Oil_LPTC_In_Max	:= MAX(IN_AG.tPr_Oil_LPTC_In_A.Ai, IN_AG.tPr_Oil_LPTC_In_B.Ai);
		tPr_TCLubOil_Min.GoodQual := tPr_TCLubOil_Max.GoodQual := TRUE;
	ELSIF (xTON_Pr_Oil_LPTC_In_A_RelMon.Q AND Para.bPr_Oil_LPTC_In_A) THEN
		tPr_TCLubOil_Min.Ai	:= rPr_Oil_LPTC_In_Min	:= IN_AG.tPr_Oil_LPTC_In_A.Ai;
		tPr_TCLubOil_Max.Ai	:= rPr_Oil_LPTC_In_Max	:= IN_AG.tPr_Oil_LPTC_In_A.Ai;
		tPr_TCLubOil_Min.GoodQual := tPr_TCLubOil_Max.GoodQual := TRUE;
	ELSIF (xTON_Pr_Oil_LPTC_In_B_RelMon.Q AND Para.bPr_Oil_LPTC_In_B) THEN
		tPr_TCLubOil_Min.Ai	:= rPr_Oil_LPTC_In_Min	:= IN_AG.tPr_Oil_LPTC_In_B.Ai;
		tPr_TCLubOil_Max.Ai	:= rPr_Oil_LPTC_In_Max	:= IN_AG.tPr_Oil_LPTC_In_B.Ai;
		tPr_TCLubOil_Min.GoodQual := tPr_TCLubOil_Max.GoodQual := TRUE;
	ELSE
		rPr_Oil_LPTC_In_Min := 0.0;
		rPr_Oil_LPTC_In_Max := 0.0;
		IF (IN_AG.tPr_TCO.GoodQual AND Para.bPr_TCO_Active) THEN
			tPr_TCLubOil_Min.Ai			:= tPr_TCLubOil_Max.Ai			:= IN_AG.tPr_TCO.Ai;
			tPr_TCLubOil_Min.GoodQual	:= tPr_TCLubOil_Max.GoodQual	:= TRUE;
		ELSE
			tPr_TCLubOil_Min.Ai			:= tPr_TCLubOil_Max.Ai			:= 0.0;
			tPr_TCLubOil_Min.GoodQual	:= tPr_TCLubOil_Max.GoodQual	:= FALSE;
		END_IF;
	END_IF;
	
	xGR_MINR_Pr_OTC(In:= tPr_TCLubOil_Min.Ai, Gw:= Para.rPr_TCOF_PrelubMin, Hy:= Para.rPr_TCOF_PrelubHyMin);
	xTON_Pr_OTC(IN:= NOT xGR_MINR_Pr_OTC.Q AND bPreLubeDem, PT:= T#2s);
	bPr_OTC_Prelub := xTON_Pr_OTC.Q;


	(*----------------------------------------------------------------------------*)
	(* engine manual start mode - short prelubrication time (120s) *)
	xR_TRIG_ShortPreLubeTime (CLK := IN_AG.bEng_Dem_Man AND NOT M_HDREHZ); 
	
	IF 			xR_TRIG_ShortPreLubeTime.Q 		THEN bShortPreLubeTime := TRUE;			// engine just manually demanded
	ELSIF 		bShortPreLubeTime AND bStart 	THEN bShortPreLubeTime := FALSE;		// engine manually demanded and second start button push				
	ELSIF 	NOT IN_AG.bEng_Dem	 				THEN bShortPreLubeTime := FALSE;		// engine not demanded 				
	END_IF	
	
	xTOF_ShortPreLubeTime_Delay	(IN := bShortPreLubeTime AND xTON_ShortPreLubeTime.Q, PT := T#6s);		
	xTON_ShortPreLubeTime 		(IN := bShortPreLubeTime, PT := T#120s);	

	(* minimum prelube time for release engine start *)
	xTON_MinPreLubeTime(IN		:= VSP_400 AND (bShortPreLubeTime OR (OUT_AG.tEOP_FC_Set.Ao = Para.rEOP_PreLube_Set)), PT:= MAX(T#30s, Para.tiPreLube));	
	OUT_AG.bNoExtendedPrelube 	:= TRUE;
		
	(* engine start release from prelubrication pump *)	(* T85 *)
	IF OUT_AG.bEOP_AC_PowSupOk THEN
		bPreLube_EngStaRel	:=	IN_AG.bEng_Dem 
						AND NOT M_HDREHZ 
						AND NOT IN_AG.bMsg1031 
						AND NOT MM2VIS.bMsg1054 
						AND 	bPreLubeDem 
						AND    (AN_VSD2 OR OUT_AG.bPreL_FS_EngStaRel OR xTOF_ShortPreLubeTime_Delay.Q) 
						AND	   (xTON_MinPreLubeTime.Q OR M_DREHZ OR bPreLube_Interval_On)
						AND	   (bPr_OTC_Prelub OR xTOF_ShortPreLubeTime_Delay.Q); 
	ELSE
		bPreLube_EngStaRel	:=	IN_AG.bEng_Dem 
						AND NOT M_HDREHZ 
						AND NOT IN_AG.bMsg1031 
						AND NOT MM2VIS.bMsg1054 
						AND 	bPreLubeDem 
						AND    (AN_VSD1 OR xTOF_ShortPreLubeTime_Delay.Q)
						AND	   (xTON_MinPreLubeTime.Q OR M_DREHZ)
						AND	   (bPr_OTC_Prelub OR xTOF_ShortPreLubeTime_Delay.Q)
						AND		FALSE;
	END_IF;

	(* maximum prelube time *)
	xTON_MaxPreLubeTime(IN:= IN_AG.bEng_Dem AND NOT M_HDREHZ, PT:= T#20m);	
	OUT_AG.bMaxPreLubeTime := xTON_MaxPreLubeTime.Q;

	//-----------------------------------------------------------------------------------------------------------//
	(* 30s/300s fast start - permanent/interval prelubrication *)
	//-----------------------------------------------------------------------------------------------------------//
	(* permanent prelubrication for 30s fast start *)
	Para.bFSPreL_Act;
	Para.tiFSPreL;
	Para.rPr_EO_FSPreL_LimLo;
	Para.rPr_TCO_FSPreL_LimHi;
	Para.rPr_TCO_FSPreL_LimLo;
	
	xTON_Pr_EO_FSPreL(IN:= (IN_AG.tPr_EngLubOil.Ai > Para.rPr_EO_FSPreL_LimLo), PT:= Para.tiFSPreL); (* minimum runtime permanent prelubrication *)
		
	IF Para.bFSPreL_Act AND NOT Para.bPreLub_Interval_Enable THEN
		bFS_Req	:= bOMSS_Aut AND IN_AG.bPermPreLube_Dem;	(* 30s faststart requested *)
		OUT_AG.bPreL_FS_EngStaRel := bFS_Req AND xTON_Pr_EO_FSPreL.Q AND NOT MM2VIS.bMsg2427;	(* release engine faststart - perm.prelubrication *)
	ELSIF Para.bPreLub_Interval_Enable THEN
		bFS_Req	:= bOMSS_Aut AND IN_AG.bFS_Act;				(* 300s faststart requested *)
		OUT_AG.bPreL_FS_EngStaRel := FALSE;					(* only for perm.prelube *)
	ELSE
		bFS_Req	:= FALSE;
		OUT_AG.bPreL_FS_EngStaRel := FALSE;
	END_IF;
		
	OUT_AG.bPreL_FS_Act := Para.bFSPreL_Act; (* -> EC *)
	
	bPreLubeDemFS :=	bOMSS_Aut
				AND		bFS_Req
				AND		Para.bFSPreL_Act
				AND	NOT	Para.bPreLub_Interval_Enable
				AND		OUT_AG.bEOP_AC_PowSupOk
				AND NOT M_DREHZ
				AND	NOT	IN_AG.bEng_Aux_Dem
				AND NOT IN_AG.bMsg1031 
				AND NOT MM2VIS.bMsg1054
				AND NOT MM2VIS.bMsg1018
				AND NOT MM2VIS.bMsg2427
				AND NOT MM2VIS.bMsg2434;
	
	OUT_AG.tTCOV_CoClose.Do := bPreLubeDemFS AND NOT bOCTC_CoDoRun; (* 1 = TC oil valve command close = energiesed valve = closed valve *)

	//-----------------------------------------------------------------------------------------------------------//
	(* intervall prelubrication for 300s fast start *)
	Para.bPreLub_Interval_Enable;

	(* interval prelubrication *) 
	xTON_PreLubeTime_Interval(IN := bOMSS_Aut
							AND 	Para.bPreLub_Interval_Enable
							AND NOT xTON_PreLubeTime_Interval.Q,
						  PT := Para.tiPreLub_Interval);		
		
	bPreLubeDem_Interval := (xTON_PreLubeTime_Interval.Q OR bPreLubeDem_Interval)
					AND NOT ((IN_AG.tPr_EngLubOil.Ai >= Para.rPr_PreLub_Interval_Lim) AND (tPr_TCLubOil_Min.Ai >= Para.rPr_PreLub_Interval_Lim))
					AND		bOMSS_Aut
					AND 	Para.bPreLub_Interval_Enable
					AND NOT IN_AG.bEng_Dem
					AND NOT bPreLubeDemFS
					AND NOT M_HDREHZ
					AND	NOT bEOP_PreH 
					AND NOT bOCTC_CoDoRun;
	
	bPreLube_Interval_On := bOMSS_Aut
					AND 	bFS_Req
					AND 	Para.bPreLub_Interval_Enable
					AND NOT M_HDREHZ
					AND  (((IN_AG.tPr_EngLubOil.Ai >= Para.rPr_PreLub_Interval_Lim) AND (tPr_TCLubOil_Min.Ai >= Para.rPr_PreLub_Interval_Lim))
						OR	bPreLube_Interval_On);
	//-----------------------------------------------------------------------------------------------------------//


	(* prelubrication ON *)
	bPreLubeDem := 	IN_AG.bEng_Aux_Dem
			AND NOT M_HDREHZ 
			AND NOT xTON_MaxPreLubeTime.Q 
			AND NOT IN_AG.bMsg1031 
			AND NOT MM2VIS.bMsg1054;

	(* emergency lubrication ON with lag run *)
	xTOF_EmLubDem(IN:= M_DREHZ, PT:= T#120s);
	bEmLubDem	:=	MM2VIS.bMsg1017
			AND		xTOF_EmLubDem.Q 
			AND NOT IN_AG.bMsg1031 
			AND NOT MM2VIS.bMsg1054;


	(*----------------------------------------------------------------------------*)
	(* oil cooled turbo charger - cool down time *)(* T97 *)
	xTOF_OCTC_CoolDown.PT:=	Para.tiPostLub_Continuous +														(* Time of continuous phase *)
							REAL_TO_TIME(Para.iNum_PostLub_Interval * 										(* Number of pulses *)
										 TIME_TO_REAL(Para.tiPostLub_PumpOn + Para.tiPostLub_PumpOff));		(* Length pump ON + OFF *)

	xTOF_OCTC_CoolDown(IN:= (xTOF_OCTC_CoolDown.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do);

	(* water cooled turbo charger - cool down time *)(* T98 *)
	xTOF_WCTC_CoolDown(IN:= (xTOF_WCTC_CoolDown.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= T#30m);

	(* water cooled turbo charger - post lube time *)
//	xTOF_WCTC_PostLub(IN:= (xTOF_WCTC_PostLub.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= Para.tiTC_Postlub);

	(* N2 scavenging - lag run time *)
	xTOF_N2_ScavCoPrelubeOn(IN:= IN_AG.bN2_ScavCoPrelubeOn, PT:= T#60s);

	(* ignition selftest - lag run time *)
	xTOF_EO_PrelubeDemIgn(IN:= IN_AG.bEO_PrelubeDemIgn, PT:= T#60s);

	(*----------------------------------------------------------------------------*)
	(* TC cool down  *)
	IF NOT Para.bTC_watercooled	AND		xTOF_OCTC_CoolDown.Q 	
								AND	NOT IN_AG.bMsg1031
								AND	NOT MM2VIS.bMsg1054
								AND	NOT M_HDREHZ
	THEN	
		(* TC with interval cool down *)
		IF 		xTON_TL_OP_Ein.Q THEN	iCnt_TL := 1;
		ELSIF	xTON_TL_OP_Aus.Q THEN	iCnt_TL := 2;
		END_IF

		CASE iCnt_TL OF
			0:	bOCTC_CoDoRun		:= TRUE;					(* pump on  - continuous phase *)
			1: 	bOCTC_CoDoRun		:= FALSE;					(* pump off - pause *)
			2: 	bOCTC_CoDoRun		:= TRUE;					(* pump on  - pulse *)
				xTON_TL_OP_Ein.PT	:= Para.tiPostLub_PumpOn;
		END_CASE

		xTON_TL_OP_Ein(IN	:= 	   bOCTC_CoDoRun);
		xTON_TL_OP_Aus(IN	:= NOT bOCTC_CoDoRun);
	ELSE
		iCnt_TL				:= 0;
		bOCTC_CoDoRun		:= FALSE;
		xTON_TL_OP_Ein(IN	:= FALSE, PT := Para.tiPostLub_Continuous);
		xTON_TL_OP_Aus(IN	:= FALSE, PT := Para.tiPostLub_PumpOff);
	END_IF

	
	bWCTC_CoDoRun	:= Para.bTC_watercooled	AND		xTOF_WCTC_CoolDown.Q
											AND NOT IN_AG.bMsg1031
											AND NOT MM2VIS.bMsg1054
											AND NOT M_HDREHZ;

	bTC_CoolDownRun := bOCTC_CoDoRun OR bWCTC_CoDoRun;


	(*----------------------------------------------------------------------------*)
	(* demand engine oil pump DC *)
	VSP_24	:= (bPreLubeDem						AND     OUT_AG.bEOP_AC_PowSupOk AND NOT AN_VSD2) 
			OR (bPreLubeDem						AND NOT OUT_AG.bEOP_AC_PowSupOk)
			OR	bEmLubDem 
			OR (bOCTC_CoDoRun					AND NOT OUT_AG.bEOP_AC_PowSupOk)
			OR (OUT_AG.tManAuxCtr.bEOP_DemPump	AND	NOT	OUT_AG.bEOP_AC_PowSupOk AND Para.bManAuxCtr_Active);

	OUT_AG.tEOP1DC_Dem.Do := VSP_24;


	(*----------------------------------------------------------------------------*)
	(* demand engine oil pump AC NPO602, M.03-M-003 *)
	VSP_400	:=	NOT MM2VIS.bMsg2597
			AND NOT IN_AG.bMsg1031	
			AND NOT MM2VIS.bMsg1054
			AND    (bPreLubeDem				  						(* vorschmierung *)
				OR	bPreLubeDemFS									(* permanent prelubrication *)
				OR  bPreLubeDem_Interval							(* interval prelubrication *) 
				OR	bEmLubDem										(* notschmierung *)
				OR  bOCTC_CoDoRun									(* nachkühlung TL *)
				OR (xTOF_N2_ScavCoPrelubeOn.Q AND IN_AG.bRel_ScavN2)(* vorschmierung für N2 spülung *) 
				OR	xTOF_EO_PrelubeDemIgn.Q							(* vorschmierung für zündungsselbsttest *)
				OR	bEOP_PreH										(* ölvorwärmung mit pumpennachlauf *)
				OR (bACP_Start AND NOT bACP_EO_Cmp)					(* Active Cooling activated *)
				OR (OUT_AG.tManAuxCtr.bEOP_DemPump AND Para.bManAuxCtr_Active));	(* Manual auxiliaries control panel *)
		
	OUT_AG.tEOP1AC_Dem.Do := VSP_400;


	(*----------------------------------------------------------------------------*)
	(* release prelube oil pressure monitoring *)
	xTON_EOP1DC(IN:= VSP_24,  PT:= T#5s); (* T77 *)
	xTON_EOP1AC(IN:= VSP_400, PT:= T#5s); (* T78 *)

	xRS_Pr_PreLub_Lo(SET:= MM2VIS.bMsg1018, RESET1:= OUT_AG.bEng_Start OR IN_AG.tEng_Run.Do OR bTC_CoolDownRun);
	IF xRS_Pr_PreLub_Lo.Q1 THEN	xTON_Pr_PreLub.PT := T#200s;		(* extend monitoring activation time in case *)
	ELSE						xTON_Pr_PreLub.PT := T#100s;		(* of A1018 oil level minimum -> oil exchange *)
	END_IF;
	
	xTON_Pr_PreLub(IN:=(bOCTC_CoDoRun AND xTON_EOP1DC.Q) (* T117 *)
					OR (bOCTC_CoDoRun AND xTON_EOP1AC.Q)
					OR	xTOF_WCTC_PostLub.Q
					OR	bPreLubeDem 
					OR (xTOF_N2_ScavCoPrelubeOn.Q AND IN_AG.bRel_ScavN2)
					OR	xTOF_EO_PrelubeDemIgn.Q);


	(* 1060 prelube oil pressure low *)


	bPr_PreLub_Lo :=   (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND bOCTC_CoDoRun 				AND     OUT_AG.bEOP_AC_PowSupOk)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND bPreLubeDem)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND xTOF_WCTC_PostLub.Q 		AND     OUT_AG.bEOP_AC_PowSupOk)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND xTOF_N2_ScavCoPrelubeOn.Q 	AND 	IN_AG.bRel_ScavN2)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND xTOF_EO_PrelubeDemIgn.Q);
//					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD2 AND bPreLubeDem 				AND 	OUT_AG.bEOP_AC_PowSupOk)
//					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD2 AND bPreLubeDem 				AND 	IN_AG.bEng_Dem_EPS);



	(************************FROM oil_c_9********************************************)
	(*-------------------------------------------------------------------------------*)
	(* release TC oil pressure monitoring *)
	xTON_TCOP(IN:= OUT_AG.tTC_EOP_On.Do, PT:= T#5s);

	(* turbo charger oil pressure after filter low trip (prelubrication / TC cool down) - A2238 *)
	xGR_MIN_Pr_TCOaF_Prelub_Lo(In:= tPr_TCLubOil_Min.Ai, Gw:= Para.rPr_TCOF_PrelubMin, Hy:= Para.rPr_TCOF_PrelubHyMin);
	xTON_Pr_TCOaF_Prelub_Lo(IN:= xGR_MIN_Pr_TCOaF_Prelub_Lo.Q AND (bPreLubeDem OR bOCTC_CoDoRun) AND (xTON_Pr_PreLub.Q OR xTON_TCOP.Q), PT:= T#5s);
	OilPress_a_ATL_min_A_prel := xTON_Pr_TCOaF_Prelub_Lo.Q AND tPr_TCLubOil_Min.GoodQual;

	(* speed depending pressure monitoring turbo charger oil pressure after filter low trip - A2234 (speed depending) *)
	xTON_N_TCO_PrMon(IN:= (IN_AG.rN_EngAct > 200.0), PT:= T#3s);
	xSigScal_TC_Oilpress(X:= IN_AG.rN_EngAct, X1:=Para.rN_TCOF_Lim1, Y1:= Para.rPr_TCOF_LimSpeed1, X2:= Para.rN_TCOF_Lim2, Y2:= Para.rPr_TCOF_LimSpeed2);
	GR_MIN_AtlOilPress(In:= tPr_TCLubOil_Min.Ai, Gw:= xSigScal_TC_Oilpress.Y_SCAL, Hy:=Para.rPr_TCOF_HyMin);
	OilPress_a_ATL_min_A := GR_MIN_AtlOilPress.Q AND xTON_N_TCO_PrMon.Q AND tPr_TCLubOil_Min.GoodQual;


	(*-------------------------------------------------------------------------------*)
	(* turbo charger oil pumps control NPO601, M.03-M-002 *)
	OUT_AG.tTC_EOP_On.Do	:=	(	bOCTC_CoDoRun 									(* TC oil pump DC *)
								OR	(OUT_AG.tManAuxCtr.bEOP_DemPump	AND Para.bManAuxCtr_Active)	)	(* Manual auxiliaries control panel *)
							AND(NOT OUT_AG.bEOP_AC_PowSupOk OR MM2VIS.bMsg2597)
							AND NOT IN_AG.bMsg1031
							AND NOT MM2VIS.bMsg1054;
	MM2VIS.bTCOP_Dem 		:=  OUT_AG.tTC_EOP_On.Do;						(* TC oil pump operation -> visu *)
	OUT_AG.tTCOP_GridOk.Do	:=	OUT_AG.bEOP_AC_PowSupOk; 					(* AC oil pump aux.voltage ok (OLMI -> TCMI), change over 24VDC supply *)


	(*-------------------------------------------------------------------------------*)
	(* Sollwert für FU der Motorölpumpe *)
	IF      	(bPreLubeDem 										(* prelubrication *)
		OR		 bPreLubeDemFS										(* permanent prelubrication *)			
		OR		 bTC_CoolDownRun									(* TC after cooling *)
		OR		 xTOF_EO_PrelubeDemIgn.Q 							(* prelubrication ignition selftest *)
		OR 	    (IN_AG.bN2_ScavCoPrelubeOn AND IN_AG.bRel_ScavN2)	(* prelubrication N2 scavenging *)
		OR		(OUT_AG.tManAuxCtr.bEOP_DemPump	AND Para.bManAuxCtr_Active))	(* Manual auxiliaries control panel *)
		AND NOT  xTON_ShortPreLubeTime.Q							(* engine manual start after short pre lubrication time *)	
		AND NOT  bPreLubeDem_Interval								(* interval prelubrication *)	
	THEN OUT_AG.tEOP_FC_Set.Ao := Para.rEOP_PreLube_Set;
	ELSE OUT_AG.tEOP_FC_Set.Ao := Para.rEOP_PreHeat_Set; 			(* pre heating *)
	END_IF;


	(*-------------------------------------------------------------------------------*)	
	(* engine oil preheating *) (* SWAT #3 *) 
	IF FALSE THEN
		OUT_AG.rT_EO_PreH := IN_AG.tT_EO_Preheating.Ai;  
	ELSIF NOT MM2VIS.bMsg2642 THEN 		  
		OUT_AG.rT_EO_PreH := IN_AG.tT_EO_Pan.Ai; (*  *)
	ELSE
		OUT_AG.rT_EO_PreH := IN_AG.tT_EO.Ai; (* SWAT #3 use engine oil inlet temperature (M.03.TI.001) in case of measuring signale failure *)
	END_IF;

	IF bFS_Req THEN xGR_MIN_OIL_VORW(In:= OUT_AG.rT_EO_PreH, Gw:= Para.rT_EO_PreH_FS_Min, Hy:= Para.rT_EO_PreH_FS_HyMin);//faststart
	ELSE            xGR_MIN_OIL_VORW(In:= OUT_AG.rT_EO_PreH, Gw:= Para.rT_EO_PreheatMin,  Hy:= Para.rT_EO_PreheatHyMin);
	END_IF;
	xTOF_OIL_VORW(IN:= xGR_MIN_OIL_VORW.Q AND IN_AG.tPB2MM.bSys_Run, PT:= T#5m);	(* lag run preheating oil pump *)
	
	(* engine oil preheating - monitoring release *)
	bEO_PreH_MonRel :=	IN_AG.tPB2MM.bSys_Run
				AND 	IN_AG.tPB2MM.bParaSetupOk 
				AND NOT IN_AG.bMsg1031  		
				AND NOT MM2VIS.bMsg1018
				AND NOT MM2VIS.bMsg1054
				AND NOT MM2VIS.bMsg2576
				AND NOT MM2VIS.bMsg2579;  (* SWAT #3 *) 

	(* engine oil preheating - oil pump *)			
	bEOP_PreH := (bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized)
		AND		bEO_PreH_MonRel
		AND NOT IN_AG.bEng_Aux_Dem_CDR 
		AND 	xTOF_OIL_VORW.Q;

	(* engine oil preheating - temperature demand*)
	VORW_OIL := (bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized)
		AND		bEO_PreH_MonRel
		AND NOT IN_AG.bEng_Aux_Dem_CDR 
		AND 	xGR_MIN_OIL_VORW.Q
		AND NOT MM2VIS.bMsg2590		//SWAT920/1
		AND NOT MM2VIS.bMsg2423		//SWAT920/1
		AND NOT MM2VIS.bMsg2265;	//SWAT920/1
		
	(* engine oil preheating on *)
	xTON_Heizfreigabe(IN:= VORW_OIL AND VSP_400 AND NOT MM2VIS.bMsg2597, PT:= T#2m);		
	OUT_AG.tEO_Preheat1.Do := xTON_Heizfreigabe.Q;
	OUT_AG.tEO_Preheat2.Do := xTON_Heizfreigabe.Q;
	OUT_AG.tEO_Preheat3.Do := xTON_Heizfreigabe.Q;

	(* engine oil preheating valve M.03-YCS.002 *)
	OUT_AG.tEOF_PreheatRel.Do := (bEOP_PreH												(* preheating demanded *)
							 OR  bPreLubeDem_Interval 									(* interval prelubrication demanded *)
							 OR  xTON_ShortPreLubeTime.Q 								(* short prelubrication time 120s finished *) 
							 OR (bACP_Start AND NOT bACP_EO_Cmp))						(* Active Cooling Program activated *)
							 AND NOT((IN_AG.bEng_Aux_Dem_CDR AND NOT xTON_ShortPreLubeTime.Q)
								 OR (IN_AG.rN_EngAct > 0)
								 OR  bTC_CoolDownRun
								 OR  xTOF_EO_PrelubeDemIgn.Q 							(* prelub.ignition selftest *)
								 OR (IN_AG.bN2_ScavCoPrelubeOn AND IN_AG.bRel_ScavN2)	(* prelub.N2 scavening *)
								 OR  bFS_Req);                                          (* fast start *)

	(*----------------------------------------------------------------------------*)
	(* water cool down after mains failure *)(* T100 *)
	xTOF_CoDoAfMnsFail(IN:=	bTC_CoolDownRun 
					AND(NOT IN_AG.bMainsReturn    OR     IN_AG.bOnly_Island) 
					AND(NOT IN_AG.tAuxV_Eng_ok.Di OR NOT IN_AG.bOnly_Island), PT:= T#20m);

	bCoDoAfMnsFail := xTOF_CoDoAfMnsFail.Q AND NOT M_HDREHZ;


	(* demand engine cooling water pump *)
	A_MKWP_TEMP1 :=	   (IN_AG.bEng_Aux_Dem_CDR OR M_DREHZ) 
				AND NOT IN_AG.bMsg1019 
				AND(NOT IN_AG.bMsg1031	OR M_DREHZ)
				AND(NOT MM2VIS.bMsg1054	OR M_DREHZ);

	A_MKWP_TEMP2 :=     bWCTC_CoDoRun 	OR bCoDoAfMnsFail;
	A_MKWP_TEMP3 :=((IN_AG.bMainsReturn AND NOT IN_AG.bOnly_Island) OR (IN_AG.tAuxV_Eng_ok.Di AND IN_AG.bOnly_Island)) AND Para.bTC_watercooled;


	OUT_AG.tECWP1Dem.Do := ((A_MKWP_TEMP1 OR (A_MKWP_TEMP2 AND A_MKWP_TEMP3))
						AND (IN_AG.tECW_PreHV_Opened.Di OR NOT bECW_PreHV_Active))
						OR (bACP_Start AND NOT bACP_ECW_Cmp);

	(*----------------------------------------------------------------------------*)
	(* set point for engine cooling water pump M.04-M-001 *)
	OUT_AG.tN_ECWP_Set.Ao := Para.rN_ECWP_Set;


	(*from mkw_c------------------------------------------------------------------*)
	(* engine cooling water control valve, tcv2 open: M.04-YCS-002 *)
	IF OUT_AG.tCtr_ECW_Set.Ao > 0.05 THEN (* >5% = open *)
		bECW_CV_Open := TRUE;
 	ELSE
		bECW_CV_Open := FALSE;
	END_IF;
	

	(* control heating element  *)	
	OUT_AG.tECW_PreH1Dem.Do := OUT_AG.tECW_PreH_Dem.Do;  
	OUT_AG.tECW_PreH2Dem.Do := OUT_AG.tECW_PreH_Dem.Do;  
	OUT_AG.tECW_PreH3Dem.Do := OUT_AG.tECW_PreH_Dem.Do;
	
	(* control valve for engine cooling water preheating *)	
	xTON_ANF_VWKL(IN:= (OUT_AG.tECWP_PreH_Dem.Do AND NOT OUT_AG.tECWP1Dem.Do), PT:= T#10s);	(* delay time for close valve, due to stop of water flow *)
	xTON_ECW_PreHV_CoClose(IN:=     xTON_ANF_VWKL.Q, PT:= T#1s);							(* change over delay time 1s between open/close command *)
	xTON_ECW_PreHV_CoOpen (IN:= NOT xTON_ANF_VWKL.Q, PT:= T#1s);

	OUT_AG.tECW_PreHV_CoClose.Do := xTON_ECW_PreHV_CoClose.Q;   							(* close valve when preheating pump is demanded *)
	OUT_AG.tECW_PreHV_CoOpen.Do  := xTON_ECW_PreHV_CoOpen.Q;


	(* engine cooling water service pump *)
	OUT_AG.tECWP_Service.Do := NOT IN_AG.bEng_RPSDem AND NOT IN_AG.tEng_Run.Do AND IN_AG.tECWP_Service_COn.Di;


END_IF;

END_PROGRAM