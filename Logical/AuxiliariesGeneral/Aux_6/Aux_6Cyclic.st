(*******************************************************************************
Aux_6	BR6: auxiliaries control 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
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
 								Minimumlaufzeit 5 min für Turboladernachschmierung
 								(NOT-AUS nicht mehr aktiv)
 								Nachkühlzeit 20 min --> 40 min
V182	02.10.2003	LH			Nachkühlzeit 40 min --> 20 min (Entwicklung!)
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
V230	15.01.2008	LH			Einstellung Para.bTC_watercooled --> settings
 		19.03.2008	TM			NW8 bBlockOel_Bh hinzu
 		31.03.2008	TM			NW8 variable name changed to IN_AG.b_OilRefillBlocked
V2.50.0	28.01.2009	lettenb.	calm: TW_T117 removed, different time for BRx
                                IN_AG.bRelPrelubEng logic changed, VSP_24 logic changed
		23.02.2009				FA_T85 removed
V3.20.0	15.09.2010	MM (BuR)	IN_AG.bEO_PrelubeDemIgn included
		07.12.2010	lettenb.	ton_T117: IN_AG.bEO_PrelubeDemIgn added
		30.09.2010	MM (BuR)	gen_sch replaced with IN_AG.bGCB_On_TC1
		01.10.2010	MM (BuR)	net_sch replaced with IN_AG.bMCB_On
		21.10.2010	lettenb.	624TSTC: NKUEHL_OIL_H2O added
		08.11.2010 				ZM_OMAX moved to alarms10xx, IN_AG.tAuxV_Eng_ok.Di, IN_AG.tFS_ECW.Di added
		09.03.2011				QUITT_AB substituted by reset_alarm[1094] for alarm bypass
V3.30.0	14.09.2011	lettenb.	A_MKWP2 added (624), 
								A_VORWH: A_MKWP added (A_VORWH+A_MKWP is not alowed to run together - high power consumption!)
		20.10.2011				p_OTC_prel added (release engine start from TC prelube oil pressure)
		24.10.2011	lettenb.	TC_postlub added, postlubrication for water cooled TC
								DO_EOP1DC: PreLUBE_SC + PRELUBE_IgnST added (to reach prelube oil pressure)
V3.90.0	05.12.2012	lettenb.	IN_AG.bECW_PreH_Dem_Customized added (for testbench P3)
V3.99   28.02.2013  pankajrodey	Generated for modular software with changes for V3.30
V3.99.1 15.03.2013	pankajrodey	Changes for V3.40, additional logic for bMsg2284
		04.06.2013	lettenb.	bEmLubDem: emergency lubrication with el.oil pumps added
		23.07.2013				oil_c_TSTC moved to Aux_6, MM2VIS.bMsg1060 --> xTON_Pr_Prelub.Q bugfix
		23.10.2013	lettenb.	624: change prelube time for 2 starts after 1018 'engine oil level low' or restart plc
		20.01.2014				EG_Scav after engine stop -> min.prelube time 60s(earlier EG_scav.time)
V4.00.1 08.05.2013				OUT_AG.tECW_PreH_Dem.Do: AND NOT OUT_AG.tECWP1Dem.Do added, acc.a_v3500
V4.00.2 12.02.2013				Para.tiTC_Postlub added
V4.03.0	29.07.2015	lettenb.	xTOF_Eng_MonOff moved from OP -> AG
		07.08.2015  Denk		Manual operating auxiliaries control functionality added
V4.04.0	27.10.2016	lettenb.	bServicePrelube added
V4.05.0	27.03.2017	lettenb.	permanent prelubrication for fast start added
V4.05.1 21.03.2018				bWCTC_CoDoRun 30 -> 40min.for 624 with 2x KBB watercooled added
V4.06.0	19.07.2018	Schmid		permanent prelubrification for faststart added
		09.10.2018				open TC oil valve (OUT_AG.tTCOV_CoClose.Do) with IN_AG.bEng_Aux_Dem if installed
		18.10.2018				MM2VIS.bMsg2434 removed from bPreLubeDemFS (W2434 deactivated for BR6, replaced by W9221+W9224)
		25.10.2018				variable names adapted TO coding guidelines
V4.07.0	03.02.2019	Perktold	BugFix: FS release for type 6 SSTC - dont wait for 2x4min (only for 624)
		22.03.2018	Schmid		stop turbo charger cool down run if emergency stop button is pressed
		26.04.2019	Schmid		A1031 safety loop emergency stop push button AND A1054 fire alarm split on HW side - adaptations TO preserve prior functionality
V4.07.1	19.06.2019	Schmid		bugfix: FS release from perm. prelube too early in case OMSS Off->Auto and immediate engine start request
V4.09.0	30.09.2019	Schmid		perm. prelube interrupted by A1018 engine oil level low
		02.12.2019	Schmid		ECWP monitoring via difference pressure (J624 for 60Hz market)
V4.10.0	23.12.2020	Schmid		ManAuxCtr prelube pump, prelube time parameter, A1060 monitoring activation delay after A1018 for oil exchange
								perm. prelube activation above ECW temperature limit, TC oil pressure monitoring in perm. prelube relaxed
V4.10.1	09.03.2021	Schmid		A1060 prelube pressure low: changed for IN_AG.bEng_Dem_EPS - limit AN_VSD1 instead of AN_VSD2 (decision by OUT_AG.bEOP_AC_PowSupOk)
V4.11.0	05.11.2021	Schmid		hydraulic ECW preheating added (identical to T3+T4)
		02.02.2022	Schmid		stop preheating (pump+heater) in case of A1050 ECW pressure maximum
V4.12.0	06.02.2023	Tinello		time of continuous engine run for release oil refill set to 10 min
								permanent prelubrication with DC pump in case of mains failure for max 30min
		07.03.2023	Tinello		QCase 1361: 4 new parameters for turbocharger post cooling intervall / Para iTC_Type deleted
V4.13.0	21.11.2023	Tinello		ECW pump difference pressure monitoring removed from here -> now available for all engine types
		08.03.2024	Tinello		QC3111 oil pre-heating to avoid high oil pressure at engine start (2023-197)
V4.14.0	25.11.2024	Bacci		T6 Start procedure with purge start (2024-219): engine preheating water pump compatibility when scavenging flap not installed, stop prelubrication when starter overheated
		04.12.2024	Zengerer	fill valve demand extension for pump stop time (->QC2360)
		10.12.2024	Nagy		bAMM_9513 added for Oil Refill Failure (2024-225)
		19.03.2025	Tinello		Issue #1694 Each TC of an overhauled engine, should be able to be cooled with oil

Instructions for use:
--------------------
prelubrication:					SSTC:	turbo chargers(TC's) don't need separate prelubrication, 
								TSTC:	turbo chargers(TC's) need prelubrication, TC prelub.pressure is monitored as part of the start release procedure,
								the lubrication is done by the mechanical oil pump beginning with turning engine

cool down for oil cooled TC:	with electr.prelubrication pump [VSP_400, VSP_24)
								(cool down = lubrication after operation/nachschmierung)

cool down for water cooled TC:	cool down TC with engine preheating pump(vorwärmpumpe) [OUT_AG.tECWP_PreH_Dem.Do)
								and engine cooling water pump

lubrication after operat. TC:	with TC oil pump or prelubrication pump (only relevant for water cooled TC)
____________________________________________________
engine 			612/616/620		624			624
____________________________________________________
TC				ABB				ABB		 	KBB	
TC cooling		water			oil/water	2xwater	(Para.bTC_watercooled)
cool down time	30'				20'/30'	 	0'
postlub			1.5'						1.5'	(Para.tiTC_Postlub)
twin stage		false			true		true	(Para.bTSTC_Exist)
____________________________________________________


Outstandings:
------------
*******************************************************************************] *)
PROGRAM _CYCLIC

IF(xEngType.Type6) THEN

	(*----------------------------------------------------------------------------*)
	(* auxiliary voltage available -> mains supply *)
	xTON_SPG_N(IN:= IN_AG.tAuxV_Eng_ok.Di, PT:= T#1s);
	OUT_AG.tAuxPoSuMains.Do := xTON_SPG_N.Q;


	(* no auxiliary voltage -> Switch to Inverter *) 
	xTON_SPG_W(IN:= NOT IN_AG.tAuxV_Eng_ok.Di, PT:= T#1s);
	OUT_AG.tAuxPoSuUPS.Do := xTON_SPG_W.Q;


	(*----------------------------------------------------------------------------*)
	(* engine preheating water pump *) 
	A_VORW_TEMP1 :=        (IN_AG.bEng_Aux_Dem_TOF OR     bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized) 
					AND(NOT IN_AG.bEng_Aux_Dem_CDR OR NOT IN_AG.tECWP_Op.Di OR (NOT bECWP_Op_DPr_Mon AND Para.bDPr_ECWP_Mon_Active)) 
					AND NOT IN_AG.bMsg1019
					AND	NOT	IN_AG.bMsg1050
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054;

	OUT_AG.tECWP_PreH_Dem.Do	:=	((A_VORW_TEMP1
								AND NOT (Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECWP_PreH_COf))		(* Manual operating auxiliaries control - Handbedienebene *)
								OR	bWCTC_CoDoRun)
								AND	(IN_AG.tAuxV_Eng_ok.Di OR ((NOT IN_AG.bDemScavVa AND IN_AG.tScavVaClosed.Di) OR NOT Para.bEGScav_Active));


	(* engine preheating *) 
	OUT_AG.bECW_Gnl_PreH_Dem	:= (bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized) 
								AND 	OUT_AG.tECWP_PreH_Dem.Do 
								AND NOT OUT_AG.tECWP1Dem.Do
								AND NOT AN_VORW 
								AND 	IN_AG.tPB2MM.bParaSetupOk 
								AND    (T_RM_VWP OR NOT Para.bTC_watercooled);

	(* engine preheating water pump ready for operation *)
	(* flow switch only if water cooled turbo chargers, for TC cooldown *)
	xTON_RM_VWP(IN:= IN_AG.tFS_ECW.Di, PT:= T#5s);
	T_RM_VWP := xTON_RM_VWP.Q;

	(* hydraulic engine cooling water pre-heating M.04-W-003 *)
	rT_ECW_HydrPreH_LimLo := Para.rT_ECW_PreH_LimOFF - Para.rT_ECW_PreH_HyOFF - Para.rT_ECW_HydrPreH_LimLo;
	xSR_PreH_HeatUpDone(SET1:= IN_AG.tT_ECW.Ai >= rT_ECW_HydrPreH_LimLo, RESET:= NOT OUT_AG.tECWP_PreH_Dem.Do OR (IN_AG.tAB2AG.bResetWarning AND (Para.iECW_PreH_Int_Visible = 3)));

	bECW_HydrPreH_Dem	:=	OUT_AG.bECW_Gnl_PreH_Dem
						AND NOT	(Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECW_HydrPreH_COf)	(* Manual operating auxiliaries control - Handbedienebene *)
						AND	(	(Para.iECW_PreH_Int_Visible = 3)		//only hydr. pre-heating available
							 OR	(Para.iECW_PreH_Int_Visible = 5)	)	//el.+hydr. pre-heating available
						AND	(	(Para.bT_HW_Su_PreH_ECW_Active
								AND NOT (MM2VIS.bMsg9254 OR IN_AG.bMsg2684)	)
							 OR	((Para.rT_ECW_HydrPreH_LimLo = 0.0) AND (Para.iECW_PreH_Int_Visible = 3))	);	//unmonitored hydr. pre-heating mode

	xTON_ECW_HydrPreH_Dem(IN:= bECW_HydrPreH_Dem, PT:= T#2s);
	xTOF_ECW_HydrPreH_Dem(IN:= bECW_HydrPreH_Dem, PT:= T#2s);
	OUT_AG.tECW_HydrPreH_Pump_Dem.Do	:= xTON_ECW_HydrPreH_Dem.Q;
	OUT_AG.tECW_HydrPreH_Val_DemOpen.Do	:= xTOF_ECW_HydrPreH_Dem.Q;

	(* electric engine cooling water pre-heating M.04-W-002 *)
	OUT_AG.tECW_PreH_Dem.Do	:=	OUT_AG.bECW_Gnl_PreH_Dem
							AND NOT	(Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECW_PreH_COf)	(* Manual operating auxiliaries control - Handbedienebene *)
							AND	(NOT (bECW_HydrPreH_Dem	OR (Para.iECW_PreH_Int_Visible = 3) )		//hydraulic pre-heating preferred			 
								OR (	 (Para.iECW_PreH_Int_Visible = 5)							//if el.+hydr. pre-heating available:
									AND (	(Para.bECW_PreH_Fast AND NOT xSR_PreH_HeatUpDone.Q1)	//	combined (el.+hydr.) heat up
										OR MM2VIS.bMsg9254 OR IN_AG.bMsg2684	)	)	);			//	el. as back-up


	(*----------------------------------------------------------------------------*)
	(* release oil refill *)
	xTON_BTRB(IN:= IN_AG.tEng_Run.Do, PT:= T#10m);
	BTRB_30M := xTON_BTRB.Q;

	(* oil refill valve *)
	bEOVal_DemOpen			 :=	M_DREHZ AND IN_AG.bEng_Dem			//changed in V4.14; old:	OUT_AG.tEOVal_DemOpen.Do :=	M_DREHZ AND IN_AG.bEng_Dem
						AND 	IN_AG.tEO_Level_Hi.Di 
						AND 	IN_AG.tEO_Refill.Di 
						AND 	BTRB_30M 
						AND NOT b_OilRefillBlocked
						AND NOT MM2VIS.bMsg2284;
	xTOF_EOVal_DemOpen (IN:= bEOVal_DemOpen, PT:= Para.tiFreshOilPump_Delay );  // PT:= T#5s		);		(*fill valve demand extension for pump stop time*) 
	OUT_AG.tEOVal_DemOpen.Do :=	(  xTOF_EOVal_DemOpen.Q																		(*normal oil refill with fill valve time extension*)
								OR (MM2VIS.bInitialOilFill_DemOpen AND (IN_AG.tEO_Refill.Di OR VIS2MM.bDem_Oil_Filling)) )	(*initial engine oil filling*)
						AND 	IN_AG.tEO_Level_Hi.Di 				(*oil level indicator*)
						AND NOT MM2VIS.bMsg2284						(*level engine oil sump is ok*)
						AND	NOT	MM2VIS.bMsg1054						(*BAL*)
						AND	NOT	IN_AG.bMsg1056	;					(*RUHE*)

	bAMM_9513 := OUT_AG.tEOVal_DemOpen.Do AND IN_AG.tEO_Refill.Di;
		
	(* engine oil level low *)
	xTOF_Eng_MonOff(IN:= OUT_AG.bEng_Start, PT:= T#10s);	(* engine monitoring off during start /ex T9 *)

	xTON_OMIN(IN:= NOT IN_AG.tEO_Level_Lo.Di AND NOT xTOF_Eng_MonOff.Q, PT:= T#10s);
	OUT_AG.bEngOilLevel_Lo := xTON_OMIN.Q;

	OMIN_NK 	:= (OUT_AG.bEngOilLevel_Lo OR (OMIN_NK AND MM2VIS.bMsg1018) ) 
			AND NOT IN_AG.bEng_Aux_Dem_TOF;


	(*----------------------------------------------------------------------------*)

	(* power supply prelube pump OK *)
	OUT_AG.bEOP_AC_PowSupOk	:= IN_AG.tAuxV_Eng_ok.Di AND IN_AG.tEOP1AC_CB_trip.Di;


	(*---------------------------------------------------------------------------*)
	(* prelube oil pressure limit for 1 pump operation *)
	xGR_MAXR_VSD1(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel1EOP_LimHi, Hy:= Para.rPr_Prel1EOP_HyHi);
	xTON_VSD1(IN:= xGR_MAXR_VSD1.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#2s);
	AN_VSD1 := xTON_VSD1.Q;

	(* prelube oil pressure limit for 2 pumps operation *)
	xGR_MAXR_VSD2(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel2EOP_LimHi, Hy:= Para.rPr_Prel2EOP_HyHi);
	xTON_VSD2(IN:= xGR_MAXR_VSD2.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#2s);
	AN_VSD2 := xTON_VSD2.Q;

	(* turbo charger oil pressure prelubrication: release engine start *)
	xGR_MINR_Pr_OTC(In:= IN_AG.tPr_TC_EOF_After.Ai, Gw:= Para.rPr_TCOF_PrelubMin , Hy:= Para.rPr_TCOF_PrelubHyMin);
	xTON_Pr_OTC(IN:= NOT xGR_MINR_Pr_OTC.Q AND (VSP_24 OR VSP_400), PT:= T#2s);
	bPr_OTC_Prelub := xTON_Pr_OTC.Q;


	(*----------------------------------------------------------------------------*)
	(* engine start release: prelube pressure ok *)
	IF OUT_AG.bEOP_AC_PowSupOk THEN
		bPr_PreLubeOk	:=	IN_AG.bEng_Aux_Dem 
					AND NOT M_HDREHZ 
					AND NOT IN_AG.bMsg1031 
					AND NOT MM2VIS.bMsg1054 
					AND 	bPreLubeDem 
					AND    (AN_VSD2 OR OUT_AG.bPreL_FS_EngStaRel)
					AND	   (bPr_OTC_Prelub OR NOT Para.bTSTC_Exist);
	ELSE
		bPr_PreLubeOk	:=	IN_AG.bEng_Aux_Dem 
					AND NOT M_HDREHZ 
					AND NOT IN_AG.bMsg1031 
					AND NOT MM2VIS.bMsg1054 
					AND 	bPreLubeDem 
					AND 	AN_VSD1
					AND	   (bPr_OTC_Prelub OR NOT Para.bTSTC_Exist);
	END_IF;

	(* change prelube time for first start after 1018 'engine oil level low' or restart plc *)
	xTP_Pulse(IN := EDGEPOS(xTON_Pr_EO_FSPreL4m.Q) AND (xCTD_Prelube.CV > 0), PT := T#5s);
	xR_TRIG_RUN(CLK:= IN_AG.tPB2MM.bSys_Run);
	xCTD_Prelube(CD:= (bPreLube_EngStaRel OR xTP_Pulse.Q), LOAD:= MM2VIS.bMsg1018 OR xR_TRIG_RUN.Q, PV:= 1);
	
	
	(* engine start release from prelubrication *)	(* T85 *)		
	IF Para.iEng_Motortype = 624 THEN
		IF xCTD_Prelube.Q THEN
			IF bFS_Req THEN xTON_Prelube(IN:= bPr_PreLubeOk AND OUT_AG.bPreL_FS_EngStaRel, PT:= T#0s);
							OUT_AG.bNoExtendedPrelube := TRUE;
			ELSE 			xTON_Prelube(IN:= bPr_PreLubeOk, PT:= MAX(T#30s, Para.tiPreLube));
							OUT_AG.bNoExtendedPrelube := TRUE;
			END_IF;
		ELSE                xTON_Prelube(IN:= bPr_PreLubeOk, PT:= T#4m);
							OUT_AG.bNoExtendedPrelube := FALSE;
		END_IF;
	ELSE	                
			IF bFS_Req THEN	xTON_Prelube(IN:= bPr_PreLubeOk AND OUT_AG.bPreL_FS_EngStaRel, PT:= T#0s);
			ELSE			xTON_Prelube(IN:= bPr_PreLubeOk, PT:= MAX(T#30s, Para.tiPreLube));
			END_IF;
			OUT_AG.bNoExtendedPrelube := TRUE;
	END_IF;		
	bPreLube_EngStaRel := xTON_Prelube.Q;

	(* maximum prelube time *)
	xTON_MaxPreLubeTime(IN:= IN_AG.bEng_Aux_Dem AND NOT M_HDREHZ AND NOT bPreLubeOff_STT, PT:= T#20m);	
	OUT_AG.bMaxPreLubeTime := xTON_MaxPreLubeTime.Q;

	//-----------------------------------------------------------------------------------------------------------//P19
	(* permanent prelubrication for fast start *)
	Para.bFSPreL_Act;
	Para.tiFSPreL;
	Para.rPr_EO_FSPreL_LimLo;
	Para.rPr_TCO_FSPreL_LimHi;
	Para.rPr_TCO_FSPreL_LimLo;
	
	bFS_Req	:= bOMSS_Aut AND Para.bFSPreL_Act AND IN_AG.bPermPreLube_Dem;
	OUT_AG.bPreL_FS_Act := Para.bFSPreL_Act; (* -> EC *)

	(* release engine faststart - perm.prelubrication *)
	xTON_Pr_EO_FSPreL  (IN:= (IN_AG.tPr_EngLubOil.Ai > Para.rPr_EO_FSPreL_LimLo), PT:= Para.tiFSPreL);
	xTON_Pr_EO_FSPreL4m(IN:= (xTON_Pr_EO_FSPreL.IN AND bFS_Req AND NOT MM2VIS.bMsg2427), PT:= T#4m);

	(* activate release when PermPreLube is activated and pressure > limit for def. time and no min warning  *)	
	IF bFS_Req AND NOT MM2VIS.bMsg2427 AND xTON_Pr_EO_FSPreL.Q AND (xCTD_Prelube.Q OR NOT (Para.iEng_Motortype = 624)) THEN
		OUT_AG.bPreL_FS_EngStaRel := TRUE;
	END_IF;
		
	(* deactivate release when pressure below Limit, PermPreLube not activated or OMS OFF *)
	xTON_AuxSupOFF(IN := (IN_AG.tPr_EngLubOil.Ai < Para.rPr_EO_FSPreL_LimLo), PT := tiAuxSupOFF_Pr_EO);	(* short drop below the limit could occur 
																											by switching from AC to DC pump *)
	IF NOT Para.bFSPreL_Act OR (IN_AG.iIdx_OMSS = 0) OR xTON_AuxSupOFF.Q THEN
		OUT_AG.bPreL_FS_EngStaRel := FALSE;
	END_IF;
	
	(* permanent prelubrication activation above certain ECW temperature *)
	xGR_MAXR_PreL_FS_T_ECW(In:= IN_AG.tT_ECW.Ai, Gw:= Para.rT_ECW_PreH_LimOFF - 10.0, Hy:= 3.0);
	

	bPreLubeDemFS :=	bOMSS_Aut
				AND		bFS_Req
				AND NOT IN_AG.bServiceMode
			(*	AND		OUT_AG.bEOP_AC_PowSupOk*)						(* permanent prelubrication with DC pump in case of mains failure*)
				AND NOT M_DREHZ
				AND NOT bOCTC_CoDoRun
				AND NOT bTC_PostLub
				AND NOT IN_AG.bMsg1031 
				AND NOT MM2VIS.bMsg1054
				AND NOT MM2VIS.bMsg1018
				AND NOT MM2VIS.bMsg2427
				AND NOT MM2VIS.bMsg9222	//624 TSTC
				AND NOT MM2VIS.bMsg9225	//6xx SSTC
				AND		xGR_MAXR_PreL_FS_T_ECW.Q;


	OUT_AG.tTCOV_CoClose.Do := bPreLubeDemFS AND NOT IN_AG.bEng_Aux_Dem;(* not used anymore *)(* 1 = TC oil valve command close = energiesed valve = closed valve *)
	//-----------------------------------------------------------------------------------------------------------//P19
	(* for 1 cycle prevent demand of prelube when the engine is demanded in auto *)
	xR_TRIG_bEng_Dem_Aut(CLK := IN_AG.bEng_Dem_Aut AND NOT M_DREHZ);
	IF xR_TRIG_bEng_Dem_Aut.Q AND NOT IN_AG.bEng_Dem_Man THEN
		bPreLubeOff_STT := TRUE;
	END_IF;

	(* prelubrication ON *)
	bPreLubeDem := 	IN_AG.bEng_Aux_Dem 
			AND NOT M_HDREHZ 
			AND NOT xTON_MaxPreLubeTime.Q 
			AND NOT IN_AG.bMsg1031 
			AND NOT MM2VIS.bMsg1054
			AND NOT bPreLubeOff_STT;

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
	IF 		Para.iEng_Motortype 	 <> 624 THEN xTOF_WCTC_CoolDown.PT	:= T#30m;
	ELSIF	Para.tiPostLub_Continuous = 0	THEN xTOF_WCTC_CoolDown.PT	:= T#40m;
											ELSE xTOF_WCTC_CoolDown.PT	:= T#20m;
	END_IF

	xTOF_WCTC_CoolDown(IN:= (xTOF_WCTC_CoolDown.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do);

	(* water cooled turbo charger - post lube time *)
	xTOF_WCTC_PostLub(IN:= (xTOF_WCTC_PostLub.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= Para.tiTC_Postlub);

	(*----------------------------------------------------------------------------*)
	(* TC cool down  *)
	IF 								Para.tiPostLub_Continuous <> 0
								AND	xTOF_OCTC_CoolDown.Q 	
								AND 	(IN_AG.bEng_Aux_Dem_TOF OR NOT OMIN_NK)
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
	(* TC post lubrication *)
	bTC_PostLub	:=			Para.bTC_PostLub_Active
					AND		Para.bTC_watercooled
					AND		xTOF_WCTC_PostLub.Q
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054
					AND NOT	M_HDREHZ;


	(*-------------------------------------------------------------------------------*)	
	(* engine oil preheating *)
	xGR_MAXR_T_ECW_PreH_Rel(In	:= IN_AG.tT_ECW.Ai, Gw:= Para.rT_ECW_PreH_LimOFF - 10.0, Hy:= 5);
    xGR_MINR_T_EO_PreH_Rel(In	:= IN_AG.tT_EO.Ai, 	Gw:= Para.rT_EO_PreH_EngStart,  	 Hy:= 7);
    xGR_MINR_T_EO_PreH_Lo(In	:= IN_AG.tT_EO.Ai, 	Gw:= Para.rT_EO_PreH_EngStart - 1.0, Hy:= 1);

	bPreHeatDem	:= 		A_VORW_TEMP1				AND
						IN_AG.tPB2MM.bSys_Run		AND
						IN_AG.tPB2MM.bParaSetupOk 	AND
				   NOT  IN_AG.bEng_Aux_Dem			AND
				   NOT  IN_AG.bMsg1031				AND
				   NOT  IN_AG.bMsg2101		 		AND
				   NOT MM2VIS.bMsg1018				AND
				   NOT MM2VIS.bMsg1052				AND
				   NOT MM2VIS.bMsg1053				AND
				   NOT MM2VIS.bMsg1054				AND
				   NOT MM2VIS.bMsg2102				AND
				   NOT MM2VIS.bMsg2103				AND
				   NOT MM2VIS.bMsg2224				AND
				   NOT MM2VIS.bMsg2427				AND
				   NOT MM2VIS.bMsg9222				AND			//624 TSTC
				   NOT MM2VIS.bMsg9225				AND 		//6xx SSTC
				   xGR_MAXR_T_ECW_PreH_Rel.Q 		AND
				   xGR_MINR_T_EO_PreH_Rel.Q 		AND
				   Para.bEO_PreH_Active;

	bAMM_T_EO_PreH_EngStart_Lo	:= xGR_MINR_T_EO_PreH_Lo.Q AND Para.bEO_PreH_Active AND bOMSS_MAT AND NOT MM2VIS.bMsg2102 AND NOT M_DREHZ;	(* W9390 *)


	(*----------------------------------------------------------------------------*)
	(* demand engine oil pump DC *)
	xTON_MaxDC_Time(IN	:= bPreLubeDemFS AND NOT OUT_AG.bEOP_AC_PowSupOk, PT:= T#30m);					(* maximum prelube time with DC pump *)
	bAMM_MaxDC_Time		:= xTON_MaxDC_Time.Q;															(* W2427 *)

	VSP_24		:= (bPreLubeDem						AND     OUT_AG.bEOP_AC_PowSupOk AND NOT AN_VSD2) 
				OR (bPreLubeDem						AND NOT OUT_AG.bEOP_AC_PowSupOk)
				OR (bPreLubeDem 					AND 	bServicePrelube)
				OR (xTON_MaxDC_Time.IN			 	AND NOT bAMM_MaxDC_Time)							(* permanent prelubrication with DC pump *)
				OR  bEmLubDem
				OR (bOCTC_CoDoRun					AND NOT OUT_AG.bEOP_AC_PowSupOk)
				OR (bTC_PostLub						AND NOT OUT_AG.bEOP_AC_PowSupOk) 
				OR (IN_AG.bN2_ScavCoPrelubeOn		AND     IN_AG.bRel_ScavN2) 
				OR	IN_AG.bEO_PrelubeDemIgn
				OR (OUT_AG.tManAuxCtr.bEOP_DemPump	AND NOT	OUT_AG.bEOP_AC_PowSupOk	 AND Para.bManAuxCtr_Active);

	OUT_AG.tEOP1DC_Dem.Do := VSP_24;


	(*----------------------------------------------------------------------------*)
	(* demand engine oil pump AC *)
	VSP_400		:=	bPreLubeDem
				OR  bPreLubeDemFS
				OR  bEmLubDem
				OR (bPreHeatDem						AND 	OUT_AG.bEOP_AC_PowSupOk)
				OR (bOCTC_CoDoRun					AND 	OUT_AG.bEOP_AC_PowSupOk)
				OR (bTC_PostLub						AND 	OUT_AG.bEOP_AC_PowSupOk) 
				OR (IN_AG.bN2_ScavCoPrelubeOn		AND     IN_AG.bRel_ScavN2) 
				OR	IN_AG.bEO_PrelubeDemIgn
				OR (OUT_AG.tManAuxCtr.bEOP_DemPump	AND		OUT_AG.bEOP_AC_PowSupOk	 AND Para.bManAuxCtr_Active);

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
					OR	bTC_PostLub
					OR	bPreLubeDem 
					OR (IN_AG.bN2_ScavCoPrelubeOn AND IN_AG.bRel_ScavN2)
					OR	IN_AG.bEO_PrelubeDemIgn);


	(* 1060 prelube oil pressure low *)
	bPr_PreLub_Lo :=   (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND bOCTC_CoDoRun)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND bPreLubeDem 				AND NOT OUT_AG.bEOP_AC_PowSupOk)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND bTC_PostLub)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND IN_AG.bN2_ScavCoPrelubeOn 	AND 	IN_AG.bRel_ScavN2)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD1 AND IN_AG.bEO_PrelubeDemIgn)
					OR (xTON_Pr_PreLub.Q AND NOT AN_VSD2 AND bPreLubeDem 				AND 	OUT_AG.bEOP_AC_PowSupOk);


	(*--- TC oil pressure max. monitoring for permanent prelube (W9221-W9225) ---*)
	IF Para.bPr_TCOaF_Active THEN	(* J624 *)
		rPr_TCLubOil := IN_AG.tPr_TC_EOF_After.Ai;
		rPr_TCLubOil_LimHi_Low_T_EO := 1.4;	(* measurement at M.03-PI-063 *)
	ELSE							(* J6xx *)
		rPr_TCLubOil := IN_AG.tPr_EngLubOil.Ai;
		rPr_TCLubOil_LimHi_Low_T_EO := 1.5;	(* measurement at M.03-PI-001 -> 0.1bar offset to TC oil pressure *)
	END_IF;
		
	IF (IN_AG.tT_EO.Ai >= 40.0) THEN	(* high oil temperature limits*)
		xTON_Pr_TCLubOil_PreL_FS_Hi		(IN:= FALSE, PT:= T#59m30s);
		xTON_Pr_TCLubOil_PreL_FS_HiHi	(IN:= FALSE, PT:= T#1h59m30s);
		bPr_TCLubOil_PreL_FS_Hi		:=	(rPr_TCLubOil > Para.rPr_TCO_FSPreL_LimHi);
		bPr_TCLubOil_PreL_FS_HiHi	:=	(rPr_TCLubOil > Para.rPr_TCO_FSPreL_LimHi + 0.1);
	ELSE								(* low oil temperature limits*)
		xTON_Pr_TCLubOil_PreL_FS_Hi		(IN:= (rPr_TCLubOil > Para.rPr_TCO_FSPreL_LimHi),		PT:= T#59m30s);
		xTON_Pr_TCLubOil_PreL_FS_HiHi	(IN:= (rPr_TCLubOil > Para.rPr_TCO_FSPreL_LimHi + 0.1),	PT:= T#1h59m30s);
		bPr_TCLubOil_PreL_FS_Hi		:=	(rPr_TCLubOil > rPr_TCLubOil_LimHi_Low_T_EO)		OR xTON_Pr_TCLubOil_PreL_FS_Hi.Q;
		bPr_TCLubOil_PreL_FS_HiHi	:=	(rPr_TCLubOil > rPr_TCLubOil_LimHi_Low_T_EO + 0.1)	OR xTON_Pr_TCLubOil_PreL_FS_HiHi.Q;
	END_IF;


	(************************FROM oil_c_TSTC********************************************)
	IF Para.bTSTC_Exist THEN
	
		(*-------------------------------------------------------------------------------*)
		(* turbo charger prelubrication oil pressure after filter low trip - A2238 *)
		xGR_MIN_Pr_TCOaF_Prelub_Lo(In:= IN_AG.tPr_TC_EOF_After.Ai, Gw:= Para.rPr_TCOF_PrelubMin, Hy:= Para.rPr_TCOF_PrelubHyMin);
		xTON_Pr_TCOaF_Prelub_Lo(IN:= xGR_MIN_Pr_TCOaF_Prelub_Lo.Q AND(OUT_AG.tEOP1DC_Dem.Do OR OUT_AG.tEOP1AC_Dem.Do) AND xTON_Pr_PreLub.Q, PT:= T#5s);
		OilPress_a_ATL_min_A_prel := xTON_Pr_TCOaF_Prelub_Lo.Q AND IN_AG.tPr_TC_EOF_After.GoodQual;
		
		(*-------------------------------------------------------------------------------*)
		(* turbo charger oil pressure after filter low trip - A2234 (speed depending) *)
		xSigScal_TC_Oilpress(X:= IN_AG.rN_EngAct, X1:=Para.rN_TCOF_Lim1, Y1:= Para.rPr_TCOF_LimSpeed1, X2:= Para.rN_TCOF_Lim2, Y2:= Para.rPr_TCOF_LimSpeed2);
		EGW_ODRA_TC := xSigScal_TC_Oilpress.Y_SCAL;
		
		(* activate speed depending pressure monitoring at engine speed > 200 *)
		xTON_N_TCO_PrMon(IN:= (IN_AG.rN_EngAct > 200.0), PT:= T#3s);

		
		IF xTON_N_TCO_PrMon.Q THEN
	 		GR_MIN_AtlOilPress(In:= IN_AG.tPr_TC_EOF_After.Ai, Gw:= EGW_ODRA_TC,             Hy:=Para.rPr_TCOF_HyMin); 
		ELSE
			GR_MIN_AtlOilPress(In:= IN_AG.tPr_TC_EOF_After.Ai, Gw:= Para.rPr_TCOF_LimSpeed1, Hy:=Para.rPr_TCOF_HyMin);
		END_IF;
		
	
	
	
		OilPress_a_ATL_min_A := GR_MIN_AtlOilPress.Q AND IN_AG.tPr_TC_EOF_After.GoodQual AND (IN_AG.rN_EngAct > 200.0); (* A2234 *)
	
		(*end of oil_c_tstc--------------------------------------------------------------*)
	END_IF;




	(*----------------------------------------------------------------------------*)
	(* water cool down after main failure *)(* T100 *)
	xTOF_CoDoAfMnsFail(IN:=	bTC_CoolDownRun 
					AND(NOT IN_AG.bMainsReturn    OR     IN_AG.bOnly_Island) 
					AND(NOT IN_AG.tAuxV_Eng_ok.Di OR NOT IN_AG.bOnly_Island), PT:= T#20m);

	bCoDoAfMnsFail := xTOF_CoDoAfMnsFail.Q AND NOT M_HDREHZ;


	(* demand engine cooling water pump 1 *)
	A_MKWP_TEMP1 :=	   (IN_AG.bEng_Aux_Dem_CDR OR M_DREHZ)
				AND NOT IN_AG.bMsg1019
				AND(NOT IN_AG.bMsg1031	OR M_DREHZ)
				AND(NOT MM2VIS.bMsg1054	OR M_DREHZ);

	A_MKWP_TEMP2 := 	bWCTC_CoDoRun	OR  bCoDoAfMnsFail;
	A_MKWP_TEMP3 :=((IN_AG.bMainsReturn AND NOT IN_AG.bOnly_Island) OR (IN_AG.tAuxV_Eng_ok.Di AND IN_AG.bOnly_Island)) AND Para.bTC_watercooled;

	OUT_AG.tECWP1Dem.Do := A_MKWP_TEMP1 OR (A_MKWP_TEMP2 AND A_MKWP_TEMP3);


	(* demand engine cooling water pump 2 with delay *)
	xTON_ECWP2Dem(IN:= OUT_AG.tECWP1Dem.Do, PT:= T#3s);
	OUT_AG.tECWP2Dem.Do := xTON_ECWP2Dem.Q;
	
END_IF;

END_PROGRAM
