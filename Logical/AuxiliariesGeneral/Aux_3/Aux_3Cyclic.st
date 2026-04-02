(*******************************************************************************
pb4_3	BR3: auxiliaries control 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2023
 
Customized modifications: -
------------------------
 
History:
-------
V01		06.07.2098	Pa			erstellt
 		24.11.2098	Pa			korrekturlesung
V06		24.03.2000	Pa			FRG Kühlwasserdrucküberwachung
 		28.03.2000	Pa			wieder raus damit
V11		04.07.2000	Pa			eigener Baustein für BR3
V160	30.11.2001	LH			Ansteuerung Vorwärmpumpe für 208-er geändert!
 		30.11.2001	LH			Ansteuerung Motorkühlwasserpumpe für 208-er!
V170	03.04.2002	LH			Aktivierung Öldrucküberwachung in pb10 verlegt
V180	22.01.2003	LH			Vorschmierung für 320-er mit TPS-Lader
 		18.02.2003	LH			eigene Variable für Baureihe 2
 								Turbonachkühlzeit 15 min --> 20 min
V181	06.06.2003	LH			Ansteuerung Vorwärmheizung richtiggestellt
 								Minimumlaufzeit 5 min für Turboladernachschmierung
 								(NOT-AUS nicht mehr aktiv)
V182	02.10.2003	LH			Nachkühlung auch bei P-diff. max. wenn TPS-Lader
 								und Ölstand minimum wenn Level wieder überschritten
V183	09.12.2003	LH			Vorschmierdrucküberwachung bei TPS-Lader angepasst
V207	02.11.2004	LH			Position Nachkühlzeit verlegt (Verwendung auch bei Raumlüftung!)
V2071	07.02.2005	LH			Verzögerung Freigabe Ölnachfüllventil
 		02.02.2005	LH			Position T86 verlegt (Verwendung auch bei Startvorbereitung!)
V2073	04.04.2006	LH			Turbonachkühlzeit für 320-er: 20 min --> 40 min
 								"ZM"-Bereinigung
V190	22.03.2004	LH			Turboladerschmierung aktiv für VISU
V212	06.06.2006	LH			angepasst für ESY-NEU 
V2201	23.07.2007	LH			Berichtigung Visualisierung Turboladernachschmierung 
V230	15.01.2008	LH			Einstellungen für TPS und KBB --> settings
 		19.03.2008	TM			NW11 bBlockOel_Bh hinzu
 		31.03.2008	TM			NW11 variable name changed to bBlockOil_Bh
V2.50.0	28.01.2009	lettenb.	calm: TW_T117 removed, different time for BRx
        23.02.2009                TW_T85  removed, different time for BRx 
V2.60.0	04.08.2009	lettenb.	turbo charger cool down time, selection by parameter added
		26.11.2009          	var.TPS changed to var.BR3_VS_aktiv (=activating prelubrication depending on engine and turbo charger)
		12.10.2010 				detection motortyp moved to pb17_en, ZM_OMAX moved to alarms10xx
V3.20.2	06.06.2011	lettenb. 	TC cool down with oilpump for water cooled TC(312/316) removed
V3.90.0	05.12.2012	lettenb.	IN_AG.bECW_PreH_Dem_Customized added (for testbench P3)
V3.99   28.02.2013  pankajrodey	Generated for modular software with changes for V3.30
V3.99.1 15.03.2013	pankajrodey	Changes for V3.40, additinal logic for bMsg2284 and RM_MKWP
V3.99.1	17.04.2013	LE, DE		AND(NOT IN_AG.bEng_Aux_Dem_CDR OR NOT IN_AG.tECWP_Op.Di) changed
		03.05.2013	lettenb.	reset VIS2MM.bEOP_DemMan added
		28.05.2013	lettenb.	bTestEnabled Para -> loc.var
		04.06.2013	lettenb.	bEmLubDem: emergency lubrication with el.oil pumps added
V4.00.1	14.05.2014	lettenb.	A_VORW_TEMP1: var.el.ECWP added(requisition/pfluger)
		29.07.2015	lettenb.	xTOF_OCTC_CoolDown.PT from param.corr. - bugfix
V4.03.0	29.07.2015	lettenb.	xTOF_Eng_MonOff moved from OP -> AG
		07.08.2015  Denk		Manual operating auxiliaries control functionality added
		23.10.2015	lettenb.	TC_PostLub added(ann-cristin ruess/systems)
V4.07.0	17.12.2018	Schmid		hydraulic ECW pre-heating added
		22.03.2018	Schmid		stop turbo charger cool down run if emergency stop button is pressed, code clean up
		26.04.2019	Schmid		A1031 safety loop emergency stop push button AND A1054 fire alarm split on HW side - adaptations TO preserve prior functionality
V4.09.0	06.11.2019	Schmid		added FS_ECW for type 3 (intro WCTC ABB TPS52-H/failed TC post-cooling detection)
V4.10.0	23.12.2020	Schmid		ManAuxCtr prelube pump, prelube time parameter, A1060 monitoring activation delay after A1018 for oil exchange
V4.11.0	05.11.2021	Schmid		OUT_AG.bECW_Gnl_PreH_Dem interface added for generator preheating
		02.02.2022	Schmid		stop preheating (pump+heater) in case of A1050 ECW pressure maximum
V4.12.0	17.02.2023	Tinello		QCase 1361: new parameter for turbocharger post cooling intervall / Para iTC_Type deleted
V4.13.0	21.11.2023	Tinello		Demand engine preheating water pump if ECW pump not operating
V4.14.0	04.12.2024	Zengerer	fill valve demand extension for pump stop time (->QC2360)
		10.12.2024	Nagy		bAMM_9513 added for Oil Refill Failure (2024-225)

Instructions for use:
--------------------
prelubrication:					turbo chargers(TC's) don't need separate prelubrication, 
								the lubrication is done by the mechanical oil pump beginning with turning engine 

cool down for oil cooled TC:	cool down TC with electr.prelube pump [VSP_400, VSP_24)
								(cool down = lubrication after operation/nachschmierung)

cool down for water cooled TC:	cool down TC with engine preheating pump(vorwärmpumpe) [OUT_AG.tECWP_PreH_Dem.Do)
								and engine cooling water pump
								
lubrication after operat. TC:	with TC oil pump or prelubrication pump (only relevant for water cooled TC)

oil pump for 312/316 is needed for filling oilsystem [NKOP], only by manual operation!
____________________________________________________________________
engine 			208		312/316		320			320		320
____________________________________________________________________
TC				B.W.	PBST		ABB			KBB		ABB
									TPS52-D/E			TPS52-H	
TC cooling		oil		water		oil			oil		water		(Para.bTC_watercooled)
cool down time	20'		20'			20'			40'		20'
postlub					1.5'							1.5'		(Para.tiTC_Postlub)
____________________________________________________________________


Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

IF ((xEngType.Type3) OR (xEngType.Type2)) THEN
		
	(*----------------------------------------------------------------------------*)
	(* engine preheating water pump *) 
	IF xEngType.Type2 THEN
		A_VORW_TEMP1 :=    (IN_AG.bEng_Aux_Dem_TOF OR bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized) 
					AND(NOT IN_AG.bEng_Aux_Dem_CDR OR NOT IN_AG.tECWP_Op.Di OR (NOT bECWP_Op_DPr_Mon AND Para.bDPr_ECWP_Mon_Active)) 
					AND NOT IN_AG.bMsg1019
					AND	NOT	IN_AG.bMsg1050
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054;	
	ELSIF xEngType.Type3 AND     Para.bECWP_MechDriven THEN
		A_VORW_TEMP1 :=    (IN_AG.bEng_Aux_Dem_TOF OR bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized) 
					AND NOT M_DREHZ
					AND NOT IN_AG.bMsg1019
					AND	NOT	IN_AG.bMsg1050
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054;
	ELSIF xEngType.Type3 AND NOT Para.bECWP_MechDriven THEN
		A_VORW_TEMP1 :=    (IN_AG.bEng_Aux_Dem_TOF OR bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized) 
					AND (NOT IN_AG.tECWP_Op.Di OR (NOT bECWP_Op_DPr_Mon AND Para.bDPr_ECWP_Mon_Active))
					AND NOT IN_AG.bMsg1019
					AND	NOT	IN_AG.bMsg1050
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054;
	END_IF;

	OUT_AG.tECWP_PreH_Dem.Do	:=	(A_VORW_TEMP1
								AND	NOT (Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECWP_PreH_COf))		(* Manual operating auxiliaries control - Handbedienebene *)
								OR	bWCTC_CoDoRun;

	(* engine preheating *) 
	OUT_AG.bECW_Gnl_PreH_Dem	:=	(bOMSS_MAT OR IN_AG.bECW_PreH_Dem_Customized)
								AND		OUT_AG.tECWP_PreH_Dem.Do 
								AND NOT AN_VORW 
								AND 	IN_AG.tPB2MM.bParaSetupOk
								AND		(T_RM_VWP OR NOT Para.bTC_watercooled);

	(* engine preheating water pump ready for operation *)
	(* flow switch only if water cooled turbo chargers, for TC cooldown *)
	xTON_RM_VWP(IN:= IN_AG.tFS_ECW.Di, PT:= T#5s);
	T_RM_VWP := xTON_RM_VWP.Q;

	(* hydraulic engine cooling water pre-heating M.04-W-003 *)
	rT_ECW_HydrPreH_LimLo := Para.rT_ECW_PreH_LimOFF - Para.rT_ECW_PreH_HyOFF - Para.rT_ECW_HydrPreH_LimLo;
	xSR_PreH_HeatUpDone(SET1:= IN_AG.tT_ECW.Ai >= rT_ECW_HydrPreH_LimLo, RESET:= NOT OUT_AG.tECWP_PreH_Dem.Do OR (IN_AG.tAB2AG.bResetWarning AND (Para.iECW_PreH_Int_Visible = 3)));

	bECW_HydrPreH_Dem	:=	OUT_AG.bECW_Gnl_PreH_Dem
						AND	NOT	(Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECW_HydrPreH_COf)	(* Manual operating auxiliaries control - Handbedienebene *)
					 	AND	(	(Para.iECW_PreH_Int_Visible = 3)		//only hydr. pre-heating available
							 OR (Para.iECW_PreH_Int_Visible = 5)	)	//el.+hydr. pre-heating available
					 	AND	(	(Para.bT_HW_Su_PreH_ECW_Active
								 AND NOT (MM2VIS.bMsg9254 OR IN_AG.bMsg2684)	)
							 OR ((Para.rT_ECW_HydrPreH_LimLo = 0.0) AND (Para.iECW_PreH_Int_Visible = 3))	);	//unmonitored hydr. pre-heating mode

	xTON_ECW_HydrPreH_Dem(IN:= bECW_HydrPreH_Dem, PT:= T#2s);
	xTOF_ECW_HydrPreH_Dem(IN:= bECW_HydrPreH_Dem, PT:= T#2s);
	OUT_AG.tECW_HydrPreH_Pump_Dem.Do	:= xTON_ECW_HydrPreH_Dem.Q;
	OUT_AG.tECW_HydrPreH_Val_DemOpen.Do := xTOF_ECW_HydrPreH_Dem.Q;

	(* electric engine cooling water pre-heating M.04-W-002 *)
	OUT_AG.tECW_PreH_Dem.Do	:=	OUT_AG.bECW_Gnl_PreH_Dem
							AND NOT	(Para.bManAuxCtr_Active AND OUT_AG.tManAuxCtr.bECW_PreH_COf)	(* Manual operating auxiliaries control - Handbedienebene *)
							AND (NOT (bECW_HydrPreH_Dem OR (Para.iECW_PreH_Int_Visible = 3) )		//hydraulic pre-heating preferred		
								 OR (	 (Para.iECW_PreH_Int_Visible = 5)							//if el.+hydr. pre-heating available:
									 AND (	(Para.bECW_PreH_Fast AND NOT xSR_PreH_HeatUpDone.Q1)	//	combined (el.+hydr.) heat up
							 			  OR MM2VIS.bMsg9254 OR IN_AG.bMsg2684	)	)	);			//	el. as back-up


	(*----------------------------------------------------------------------------*)
	(* release oil refill *)
	xTON_BTRB(IN:= IN_AG.tEng_Run.Do, PT:= T#30m);
	BTRB_30M := xTON_BTRB.Q;

	(* oil refill valve *)
	bEOVal_DemOpen			 :=	M_DREHZ AND IN_AG.bEng_Dem			//changed in V4.14; old:	OUT_AG.tEOVal_DemOpen.Do :=	M_DREHZ AND IN_AG.bEng_Dem
						AND 	IN_AG.tEO_Level_Hi.Di 
						AND 	IN_AG.tEO_Refill.Di 
						AND 	BTRB_30M 
						AND NOT b_OilRefillBlocked
						AND NOT MM2VIS.bMsg2284;
	xTOF_EOVal_DemOpen (IN:= bEOVal_DemOpen, PT:= Para.tiFreshOilPump_Delay );  // PT:= T#5s		);						(*fill valve demand extension for pump stop time*) 
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


	(*----------------------------------------------------------------------------*)
	(* engine start release from prelubrication pump *)	(* T85 *)
	xTON_PreLube(IN:=	IN_AG.bEng_Aux_Dem 
				AND NOT M_HDREHZ 
				AND NOT IN_AG.bMsg1031 
				AND NOT MM2VIS.bMsg1054, PT:= MAX(T#2s, Para.tiPreLube));
	OUT_AG.bNoExtendedPrelube := TRUE;

	bPreLube_EngStaRel := xTON_PreLube.Q;

	(* maximum prelube time *)
	xTON_MaxPreLubeTime(IN:= IN_AG.bEng_Aux_Dem AND NOT M_HDREHZ, PT:= T#20m);
	OUT_AG.bMaxPreLubeTime := xTON_MaxPreLubeTime.Q;

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
	xTOF_OCTC_CoolDown(IN:= (xTOF_OCTC_CoolDown.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= Para.tiPostLub_Continuous); 

	(* water cooled turbo charger - cool down time *)(* T98 *)
	xTOF_WCTC_CoolDown(IN:= (xTOF_WCTC_CoolDown.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= T#20m);

	(* water cooled turbo charger - post lube time *)
	xTOF_WCTC_PostLub(IN:= (xTOF_WCTC_PostLub.Q AND M_HDREHZ) OR IN_AG.tEng_Run.Do, PT:= Para.tiTC_Postlub);

	(*----------------------------------------------------------------------------*)
	(* TC cool down *)
	bOCTC_CoDoRun :=	NOT Para.bTC_watercooled
					AND		xTOF_OCTC_CoolDown.Q 
					AND    (IN_AG.bEng_Aux_Dem_TOF OR NOT OMIN_NK)
					AND NOT IN_AG.bMsg1031
					AND NOT MM2VIS.bMsg1054 
					AND NOT M_HDREHZ;

	bWCTC_CoDoRun :=		Para.bTC_watercooled
					AND 	xTOF_WCTC_CoolDown.Q
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


	(*----------------------------------------------------------------------------*)
	(* demand engine oil pump DC *)
	VSP_24		:= (bPreLubeDem						AND	Para.bEngTyp3_Prelub_Active)
				OR	bEmLubDem
				OR  bOCTC_CoDoRun  
				OR  bTC_PostLub
				OR (OUT_AG.tManAuxCtr.bEOP_DemPump	AND	Para.bManAuxCtr_Active);



	(*----------------------------------------------------------------------------*)
	(* release prelube oil pressure monitoring *)
	xTON_EOP1DC(IN:= VSP_24, PT:= T#5s); (* T77 *)

	xRS_Pr_PreLub_Lo(SET:= MM2VIS.bMsg1018, RESET1:= OUT_AG.bEng_Start OR IN_AG.tEng_Run.Do OR bTC_CoolDownRun);
	IF xRS_Pr_PreLub_Lo.Q1 THEN	xTON_Pr_PreLub.PT := T#200s;		(* extend monitoring activation time in case *)
	ELSE						xTON_Pr_PreLub.PT := T#50s;			(* of A1018 oil level minimum -> oil exchange *)
	END_IF;
	
	xTON_Pr_PreLub(IN:=(bTC_CoolDownRun AND xTON_EOP1DC.Q) (* T117 *)
					OR	bPreLubeDem);


	(* 1060 prelube oil pressure low *)
	bPr_PreLub_Lo := 	Para.bEngTyp3_Prelub_Active 
					AND (bTC_CoolDownRun OR bPreLubeDem) 
					AND NOT IN_AG.tEOP_Op.Di
					AND xTON_Pr_PreLub.Q;


	(*----------------------------------------------------------------------------*)
	(* manual demand engine oil pump for refill oilsystem after oil change *)
	xTP_EOP_ManDem(IN:= (IN_AG.tEOP_DemExt.Di OR VIS2MM.bEOP_DemMan) AND NOT bOMSS_MAT, PT:= T#15m);
	
	IF VIS2MM.bEOP_DemMan THEN VIS2MM.bEOP_DemMan := FALSE; END_IF;	(* reset vis data point  *)


	(*----------------------------------------------------------------------------*)
	(* manual demand engine oil pump AC/DC for TC cool down (Nachkühlölpumpe NPO5) *)
	NKOP :=		xTP_EOP_ManDem.Q 
		AND NOT bOMSS_MAT 
		AND NOT IN_AG.bMsg1031 
		AND NOT OUT_AG.bMsg1054 
		AND NOT M_DREHZ
		AND(NOT OMIN_NK OR IN_AG.bEng_Aux_Dem_TOF);


	(*----------------------------------------------------------------------------*)
	(* engine oil pump AC/DC ON *)
	OUT_AG.tEOP1DC_Dem.Do := VSP_24 OR NKOP;
	OUT_AG.tEOP1AC_Dem.Do := VSP_24 OR NKOP;


	(*----------------------------------------------------------------------------*)
	(* turbo charger lubrication active for VIS *)
	MM2VIS.bTCOP_Dem := NKOP OR VSP_24;


	(*----------------------------------------------------------------------------*)
	(* demand engine cooling water pump *) 
	IF xEngType.Type2 THEN
		OUT_AG.tECWP1Dem.Do := (IN_AG.bEng_Aux_Dem_CDR OR M_DREHZ OR OUT_AG.tECWP_PreH_Dem.Do) 
						AND NOT IN_AG.bMsg1019 
						AND(NOT IN_AG.bMsg1031	OR M_DREHZ)
						AND(NOT MM2VIS.bMsg1054	OR M_DREHZ);
	ELSE
		OUT_AG.tECWP1Dem.Do := (IN_AG.bEng_Aux_Dem_CDR OR M_DREHZ) 
						AND NOT IN_AG.bMsg1019 
						AND(NOT IN_AG.bMsg1031	OR M_DREHZ)
						AND(NOT MM2VIS.bMsg1054	OR M_DREHZ);	
	END_IF;	

END_IF;

END_PROGRAM
