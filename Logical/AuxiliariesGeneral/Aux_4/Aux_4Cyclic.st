(********************************************************************
pb4_4	BR4: auxiliaries control 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2024
 
Customized modifications: -
------------------------
 
History:
-------
V11		03.07.2000	Pa			eigener Baustein für BR4 wegen Vorschmierung
V14		23.04.2001	Pa			Eigener Zeitwert für wegschaltung Ölnachfüllung
V160	29.11.2001	LH			Ölstandsüberwachung/Nachfüllung rückgebaut auf BR3/6
 		30.11.2001	LH			Ansteuerung Motorkühlwasserpumpe und Vorwärmpumpe geändert!
V170	03.04.2002	LH			Aktivierung Öldrucküberwachung in pb10 verlegt
V181	06.06.2003	LH			Ansteuerung Vorwärmheizung richtiggestellt
 								Minimumlaufzeit 5 min für Turboladernachschmierung
 								(NOT-AUS nicht mehr aktiv)
V182	02.10.2003	LH			Nachkühlung auch bei Leistungsdifferenz maximum
 								und Ölstand minimum wenn Level wieder überschritten
V2071	07.02.2005	LH			Verzögerung Freigabe Ölnachfüllventil
V230	19.03.2008	TM			NW5 bBlockOel_Bh hinzu
 		31.03.2008	TM			NW5 variable name changed to IN_AG.b_OilRefillBlocked
V2.50.0 28.01.2009	lettenb.	calm: TW_T117 removed, different time for BRx
        23.02.2009              IN_AG.bRelPrelubEng logic changed, FA_T85 removed
V2.60.0	26.11.2009	lettenb. 	var.TPS changed to var.BR3_VS_aktiv 	
V3.10.1	02.08.2010	Wa			Erweiterungen für BR4 mit wassergekühlten Turbo
V3.20.0	15.09.2010	MM (BuR)	IN_AG.bEO_PrelubeDemIgn included 	
		07.12.2010	lettenb.	ton_T117: IN_AG.bEO_PrelubeDemIgn added
		08.11.2010	lettenb.	standardizing water cooled TC for BR4, ZM_OMAX moved to alarms10xx
						 		IN_AG.tAuxV_Eng_ok.Di, IN_AG.tFS_ECW.Di added
V3.90.0	05.12.2012	lettenb.	IN_AG.bECW_PreH_Dem_Customized added (for testbench P3)
V3.99   28.02.2013  pankajrodey	Generated for modular software with changes for V3.30
V3.99.1 15.03.2013	pankajrodey	Changes for V3.40, additinal logic for bMsg2284
		04.06.2013	lettenb.	bEmLubDem: emergency lubrication with el.oil pumps added
V4.00.0	23.02.2015	lettenb.	Para.tiTC_Postlub added
V4.03.0	29.07.2015	lettenb.	xTOF_Eng_MonOff moved from OP -> AG
        07.08.2015  Denk		Manual operating auxiliaries control functionality added
V4.06.0	19.06.2018	Perktold,	permanent prelubification added
								demand DC pump to assist AC permanent prelube pump reaching pressure level
		09.10.2018	Schmid,		changed time for xTOF_DemPermPreLube24 to 2s, renamed xTP_FS_PermPreLube24
		25.10.2018				variable names adapted to coding guidelines
V4.07.0	17.12.2018	Schmid		hydraulic ECW pre-heating added
		22.03.2018	Schmid		stop turbo charger cool down run if emergency stop button is pressed
		26.04.2019	Schmid		A1031 safety loop emergency stop push button AND A1054 fire alarm split on HW side - adaptations TO preserve prior functionality
V4.09.0	30.09.2019	Schmid		perm. prelube interrupted by A1018 engine oil level low
V4.10.0	23.12.2020	Schmid		ManAuxCtr prelube pump, prelube time parameter, A1060 monitoring activation delay after A1018 for oil exchange
V4.11.0	05.11.2021	Schmid		OUT_AG.bECW_Gnl_PreH_Dem interface added for generator preheating
		02.02.2022	Schmid		stop preheating (pump+heater) in case of A1050 ECW pressure maximum
V4.12.0	17.02.2023	Tinello		QCase 1361: new parameter for turbocharger post cooling intervall / Para iTC_Type deleted
V4.13.0	21.11.2023	Tinello		Demand engine preheating water pump if ECW pump not operating
		08.03.2024	Tinello		QC3111 oil pre-heating to avoid high oil pressure at engine start (2023-197)
V4.14.0	04.12.2024	Zengerer	fill valve demand extension for pump stop time (->QC2360)
		10.12.2024	Nagy		bAMM_9513 added for Oil Refill Failure (2024-225)

Instructions for use:
--------------------
prelubrication:					turbo chargers(TC's) don't need separate prelubrication, 
								the lubrication is done by the mechanical oil pump beginning with turning engine 

cool down for oil cooled TC:	with electr.prelubrication pump [VSP_400, VSP_24)
								(cool down = lubrication after operation/nachschmierung)

cool down for water cooled TC:	cool down TC with engine preheating pump(vorwärmpumpe) [OUT_AG.tECWP_PreH_Dem.Do)
								and engine cooling water pump

lubrication after operat. TC:	with TC oil pump or prelubrication pump (only relevant for water cooled TC)
____________________________
engine 			412/416/420
____________________________
TC				ABB/PBST
TC cooling		water		(Para.bTC_watercooled)
cool down time	30'
postlub			1.5'		(Para.tiTC_Postlub)
____________________________


Outstandings:
------------
*******************************************************************************]  *)
PROGRAM _CYCLIC

IF (xEngType.Type4) THEN

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
					AND NOT IN_AG.bMsg1050
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054;

	OUT_AG.tECWP_PreH_Dem.Do	:=	(A_VORW_TEMP1
								AND NOT	(Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECWP_PreH_COf))		(* Manual operating auxiliaries control - Handbedienebene *)
								OR	bWCTC_CoDoRun;

	(* engine preheating *) 
	OUT_AG.bECW_Gnl_PreH_Dem	:=	(bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized) 
								AND 	OUT_AG.tECWP_PreH_Dem.Do 
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
	xTON_BTRB(IN:= IN_AG.tEng_Run.Do, PT:= T#30m);
	BTRB_30M := xTON_BTRB.Q;

	(* oil refill valve *)
	bEOVal_DemOpen			 :=	M_DREHZ AND IN_AG.bEng_Dem			//old:	OUT_AG.tEOVal_DemOpen.Do :=	M_DREHZ AND IN_AG.bEng_Dem
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


	(*---------------------------------------------------------------------------*)
	(* prelube oil pressure limit for 1 pump operation *)
	xGR_MAXR_VSD1(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel1EOP_LimHi, Hy:= Para.rPr_Prel1EOP_HyHi);
	xTON_VSD1(IN:= xGR_MAXR_VSD1.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#2s);
	AN_VSD1 := xTON_VSD1.Q;

	(* permanent prelubrication for fast start *)
	bFS_Req	:= bOMSS_Aut AND IN_AG.bPermPreLube_Dem AND Para.bFSPreL_Act;
	OUT_AG.bPreL_FS_Act := Para.bFSPreL_Act; (* -> EC *)
	
	(* release engine faststart - perm.prelubrication *)
	xTON_Pr_EO_FSPreL(IN:= (IN_AG.tPr_EngLubOil.Ai > Para.rPr_EO_FSPreL_LimLo), PT:= Para.tiFSPreL);

	(* activate release when PermPreLube is activated and pressure > limit for def. time and no min warning  *)	
   	IF bFS_Req AND NOT MM2VIS.bMsg2427 AND xTON_Pr_EO_FSPreL.Q THEN
		OUT_AG.bPreL_FS_EngStaRel := TRUE;
	END_IF;

	(* generate pulse for max time window to demand DC pump assist *)
	tiFS_PermPreLube24 := T#45s;
	xTP_FS_PermPreLube24(IN := (EDGEPOS(bPreLubeDemFS) AND NOT(IN_AG.tPr_EngLubOil.Ai > Para.rPr_EO_FSPreL_LimLo) AND NOT OUT_AG.bPreL_FS_EngStaRel), PT := tiFS_PermPreLube24);
	
	(* demand DC pump to assist AC permanent prelube pump reaching pressure level *)
	xTOF_DemPermPreLube24.IN 	:=		bPreLubeDemFS
								AND 	xTP_FS_PermPreLube24.Q
								AND NOT(IN_AG.tPr_EngLubOil.Ai > Para.rPr_EO_FSPreL_LimLo)
								AND NOT OUT_AG.bPreL_FS_EngStaRel;
	xTOF_DemPermPreLube24.PT	:= T#2s;
	xTOF_DemPermPreLube24();
	
	bDem_FS_PermPreLube24	:= xTOF_DemPermPreLube24.Q;

	(* deactivate release when pressure below Limit, PermPreLube not activated or OMS OFF *)
	IF NOT Para.bFSPreL_Act OR (IN_AG.iIdx_OMSS = 0) OR (IN_AG.tPr_EngLubOil.Ai < Para.rPr_EO_FSPreL_LimLo) THEN
		OUT_AG.bPreL_FS_EngStaRel := FALSE;
	END_IF;

	(* permanent lubrication - temperature dependent - if min warning is present *)
	xLCRScal_PermLube(x := LIMIT(15, IN_AG.tT_EO.Ai, 25), x1 := 15, y1 := 20, x2 := 25, y2 := 5);
	tiPermLube :=  REAL_TO_TIME(LIMIT(5.0, xLCRScal_PermLube.y, 20.0) * 1000);

	IF bFS_Req AND MM2VIS.bMsg2427  THEN		
		xTON_PreLube(IN:= xGR_MAXR_VSD1.Q, PT:= tiPermLube);
	ELSIF bFS_Req THEN
		xTON_PreLube(IN:= xGR_MAXR_VSD1.Q, PT:= T#1s);
	ELSE
		xTON_PreLube(IN:= xGR_MAXR_VSD1.Q, PT:= MAX(T#2s, Para.tiPreLube));
	END_IF;
	OUT_AG.bNoExtendedPrelube := TRUE;


	(*----------------------------------------------------------------------------*)
	(* engine start release from prelubrication pump *)	(* T85 *)
	bPreLube_EngStaRel	:=	IN_AG.bEng_Aux_Dem 
					AND NOT M_HDREHZ 
					AND NOT IN_AG.bMsg1031 
					AND NOT MM2VIS.bMsg1054 
					AND 	bPreLubeDem 
					AND 	(AN_VSD1 OR bFS_Req)
					AND 	xTON_PreLube.Q;

	(* maximum prelube time *)
	xTON_MaxPreLubeTime(IN:= IN_AG.bEng_Aux_Dem AND NOT M_HDREHZ, PT:= T#20m);	
	OUT_AG.bMaxPreLubeTime := xTON_MaxPreLubeTime.Q;

	(* prelubrication ON *)
	bPreLubeDem := 	IN_AG.bEng_Aux_Dem 
			AND NOT M_HDREHZ 
			AND NOT xTON_MaxPreLubeTime.Q 
			AND NOT IN_AG.bMsg1031 
			AND NOT MM2VIS.bMsg1054;

	(* permanent lubrication ON *)
	bPreLubeDemFS := bOMSS_Aut 
			AND 	bFS_Req
			AND NOT IN_AG.bServiceMode
			AND NOT M_HDREHZ
			AND NOT bOCTC_CoDoRun
			AND NOT IN_AG.bMsg1031 
			AND NOT MM2VIS.bMsg1054
			AND NOT MM2VIS.bMsg1018
			AND NOT MM2VIS.bMsg2427;

	(* emergency lubrication ON with lag run *)
	xTOF_EmLubDem(IN:= M_DREHZ, PT:= T#120s);
	bEmLubDem	:=	MM2VIS.bMsg1017
			AND		xTOF_EmLubDem.Q 
			AND NOT IN_AG.bMsg1031 
			AND NOT MM2VIS.bMsg1054;

	(*----------------------------------------------------------------------------*)
	(* oil cooled turbo charger - cool down time *)(* T97 *)
	xTOF_OCTC_CoolDown(IN:= (xTOF_OCTC_CoolDown.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= Para.tiPostLub_Continuous);

	(* water cooled turbo charger - cool down time *)(* T98 *)
	xTOF_WCTC_CoolDown(IN:= (xTOF_WCTC_CoolDown.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= T#30m);

	(* water cooled turbo charger - post lube time *)
	xTOF_WCTC_PostLub(IN:= (xTOF_WCTC_PostLub.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= Para.tiTC_Postlub);

	(*----------------------------------------------------------------------------*)
	(* TC cool down *)
	bOCTC_CoDoRun :=	NOT	Para.bTC_watercooled	
					AND		xTOF_OCTC_CoolDown.Q 
					AND    (IN_AG.bEng_Aux_Dem_TOF OR NOT OMIN_NK)
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054 
					AND NOT M_HDREHZ;

	bWCTC_CoDoRun :=		Para.bTC_watercooled
					AND		xTOF_WCTC_CoolDown.Q 
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
	VSP_24		:=	bPreLubeDem 
				OR  bPreHeatDem
				OR	bEmLubDem
				OR	bOCTC_CoDoRun
				OR  bTC_PostLub 
				OR (IN_AG.bN2_ScavCoPrelubeOn		AND	IN_AG.bRel_ScavN2) 
				OR	IN_AG.bEO_PrelubeDemIgn
				OR  bDem_FS_PermPreLube24
				OR (OUT_AG.tManAuxCtr.bEOP_DemPump	AND	Para.bManAuxCtr_Active);

	OUT_AG.tEOP1DC_Dem.Do := VSP_24;


	(*----------------------------------------------------------------------------*)
	(* demand engine oil pump AC *)
	VSP_400		:= bPreLubeDemFS;

	OUT_AG.tEOP1AC_Dem.Do := VSP_400;

		
	(*----------------------------------------------------------------------------*)
	(* release prelube oil pressure monitoring *)
	xTON_EOP1DC(IN:= VSP_24, PT:= T#5s); (* T77 *)

	xRS_Pr_PreLub_Lo(SET:= MM2VIS.bMsg1018, RESET1:= OUT_AG.bEng_Start OR IN_AG.tEng_Run.Do OR bTC_CoolDownRun);
	IF xRS_Pr_PreLub_Lo.Q1 THEN	xTON_Pr_PreLub.PT := T#200s;		(* extend monitoring activation time in case *)
	ELSE						xTON_Pr_PreLub.PT := T#100s;		(* of A1018 oil level minimum -> oil exchange *)
	END_IF;
	
	xTON_Pr_PreLub(IN:=(bOCTC_CoDoRun AND xTON_EOP1DC.Q) (* T117 *)
					OR	bPreLubeDem 
					OR	bTC_PostLub
					OR (IN_AG.bN2_ScavCoPrelubeOn AND IN_AG.bRel_ScavN2)
					OR	IN_AG.bEO_PrelubeDemIgn);


	(* 1060 prelube oil pressure low *)
	bPr_PreLub_Lo := 	xTON_Pr_PreLub.Q 
						AND NOT AN_VSD1 
						AND (bOCTC_CoDoRun 
						OR	bPreLubeDem 
						OR	bTC_PostLub
						OR (IN_AG.bN2_ScavCoPrelubeOn AND IN_AG.bRel_ScavN2) 
						OR	IN_AG.bEO_PrelubeDemIgn);


	(*--- TC oil pressure max. monitoring for permanent prelube (W9221-W9225) ---*)
	IF Para.bPr_TCOaF_Active THEN
		rPr_TCLubOil := IN_AG.tPr_TC_EOF_After.Ai;
		rPr_TCLubOil_LimHi_Low_T_EO := 1.4;	(* measurement at M.03-PI-063 *)
	ELSE
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


	(*----------------------------------------------------------------------------*)
	(* water cool down after main failure *)(* T100 *)
	xTOF_CoDoAfMnsFail(IN:=	bTC_CoolDownRun 
					AND(NOT IN_AG.bMainsReturn    OR     IN_AG.bOnly_Island) 
					AND(NOT IN_AG.tAuxV_Eng_ok.Di OR NOT IN_AG.bOnly_Island), PT:= T#20m);

	bCoDoAfMnsFail := xTOF_CoDoAfMnsFail.Q AND NOT M_HDREHZ;


	(* demand engine cooling water pump *)
	A_MKWP_TEMP1 :=	   (IN_AG.bEng_Aux_Dem_CDR OR M_DREHZ)
				AND NOT IN_AG.bMsg1019
				AND(NOT IN_AG.bMsg1031	OR M_DREHZ)
				AND(NOT MM2VIS.bMsg1054	OR M_DREHZ);

	A_MKWP_TEMP2 := 	bWCTC_CoDoRun	OR  bCoDoAfMnsFail;
	A_MKWP_TEMP3 :=((IN_AG.bMainsReturn AND NOT IN_AG.bOnly_Island) OR (IN_AG.tAuxV_Eng_ok.Di AND IN_AG.bOnly_Island)) AND Para.bTC_watercooled;

	OUT_AG.tECWP1Dem.Do := A_MKWP_TEMP1 OR (A_MKWP_TEMP2 AND A_MKWP_TEMP3);


END_IF

END_PROGRAM



