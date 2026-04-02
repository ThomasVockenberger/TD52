(*******************************************************************************
MsgVE	 			ventilation messages

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V0.01.0	02.11.2011	lettenb.	new
		18.09.2012	lettenb.	rT_AirER_Customized added (request zengerer) 
V3.40.0	17.12.2012	lettenb.	1138 DI_ERV_Op added, preparation for air flow sensor, ATEX
								3224 .PTON := T#0s -> 2s; (W3223 MS & W3224 comes at the same time) bugfix
V3.99.0	19.02.2013	lettenb.	update
		24.05.2013				reset OUT_xx.txx2AB.bGnlTripx changed
V4.00.0	31.01.2014				3367 added, eng.room vent.monit.V3.50
V4.00.1	14.05.2014	lettenb.	1138 var 3/4: FG_FU, ZLVST1 added (MRL kalte laender)
		12.06.2014				3224 xTON_GCB_On.PT:= T#30s -> 300s, bugfix
V4.00.2	16.02.2015				3152,3223 enable with IN_VE.tPB2MM.bSys_Run
V4.03.0 03.08.2015  Stary       added new alarms 2701-2709 FOR controlled louvers
					lettenb.	xMsg2704.Enable: Para.bInlVent_Ctr_OutlLou_Active -> Para.bOutlVent_Ctr_OutlLou_Active, bugfix
		30.09.2015  Stary       2120 tAuxV_Aux_ok added
		23.12.2015	lettenb.	1138 M_DREHZ -> (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do) to avoid msg after mains failure(restart ability)
V4.04.0 07.07.2016	lettenb.	2630 added(substitution for 1176 in wrong module(CH) tDPr_InAirFilt_Hi -> tDPr_InAirFiltERV_Hi), bugfix
V4.04.0 27.09.2016  Stary       splitted up existing summarized alarms 1138+2120 for ventilation and added single alarms for inlet/outlet --> new messages 2295,2296,2795-2798
		02.11.2016	Tinello		3223 und 3224 deleted --> moved to modul CH
V4.04.0 25.01.2017  Stary   	bugfix after pilot-engines:    
								Enable of bMsg2701-bMsg2704 --> deleted Para.bInlVent_Ctr_InlLou_Active cause measuring singnal failure now indepedend OF ventilation type
		01.02.2017	lettenb.	xTON_MonAuxV double function call removed
V4.05.0 30.06.2017	lettenb.	bAuxRel_Louvers added acc. faststart option
		21.12.2017	lettenb.	1138, 2295, 2296 enable alarms depending on existing Di's (stary), bugfix
		22.12.2017	lettenb.	comment added: Safety-related application software source code (EN 13849-1 / 4.6.3)
		22.01.2018	lettenb.	1138 Pos_InlLou1_OK, Pos_InlLou2_OK, Pos_OutlLou1_OK, Pos_OutlLou2_OK added, bugfix
		22.01.2018	lettenb.	3152 bParaSetupOk added TO avoid message at plc startup
		30.01.2018	lettenb.	2706,2707 time delay 10s(fahringer/stary)
V4.06.0	16.07.2018	Perktold,	2968 and 2969 Air inlet/outlet louver status signal failure added
V4.07.0 25.02.2019	Stary/lett. 1138,2295,2296 bAuxRel_FireProtFlaps: FireProtFlap feedback signals included in aux.release, safety case
								2295,2296 bAuxRel_Louvers_... added(same as 1138), xTON_MonAuxV double function call removed, bugfix
V4.10.0 25.01.2021	lettenb.	engine room ventilation not ready - block engine start as long as failure is active, added from task Vent_ER (request fahringer), bugfix
								2120,2795,2796 safety code remark added (request fahringer)
V4.12.0 07.12.2022	lettenb.	2706: IN_VE.tEng_Run.Do added, aggreko -> jenb.standard, #954
V4.13.0 18.03.2024	Bacci		2295: trip used when inlet louvers demanded but not responding (90s)
V4.14.0 10.12.2024	Nagy		New warning 2472 High Temperature Warning and Alarm 9401 Louvers 2024-226 


Instructions for use:
--------------------
1) declare alarm with function block "Alm"
	declare buffert alarm bit bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset acc.TI 1100-0111
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	


3)  expand INIT

			
Outstandings:
------------
change bGnlTrip_VE --> bGnlTrip
(*******************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)
	OUT_VE.tVE2AB.bGnlTrip1		:=	FALSE;
	OUT_VE.tVE2AB.bGnlTrip2		:=	FALSE;
	OUT_VE.tVE2AB.bGnlTrip3		:=	FALSE;
	OUT_VE.tVE2AB.bGnlWarning	:=	FALSE;
	OUT_VE.tVE2AB.bTriptype1	:=	FALSE;
	OUT_VE.tVE2AB.bTriptype2	:=	FALSE;
	OUT_VE.tVE2AB.bTriptype3	:=	FALSE;	


	(*  1135 engine room temperature high *)
	xTON_RoomTemp.IN :=   ((NOT MM2VIS.bMsg3152) AND bT_AirER_Hi)
						OR (NOT Para.bVISA  AND NOT IN_VE.tT_AirER_Ext_Hi.Di);
	xTON_RoomTemp.PT :=  T#30s;
	xTON_RoomTemp();
	T_RTM := xTON_RoomTemp.Q;

	xMsg1135.Enable		:=	TRUE;
	xMsg1135.Set		:= (T_RTM      AND(NOT IN_VE.bEng_Dem_EPS OR IN_VE.bOnly_Island)) 
						OR (Para.bVISA AND NOT IN_VE.tT_AirER_Ext_Hi.Di);
	xMsg1135.PT			:=	T#0s;	

	RTM_VISA := NOT IN_VE.tT_AirER_Ext_Hi.Di  OR (RTM_VISA AND xMsg1135.Q);
	IF Para.bVISA AND RTM_VISA THEN
		xMsg1135.Prio	:=	2;
	ELSE						
		xMsg1135.Prio	:=	3;	
	END_IF;
	xMsg1135.RiskClass	:=	0;		(* TI 1100-0111 *)
	xMsg1135.Reset		:=	FALSE;
	xMsg1135();
	MM2VIS.bMsg1135	    :=	xMsg1135.Q;	

	(*  2472 engine room temperature high warning*)
	xMsg2472.Enable		:=	TRUE;
	xMsg2472.Set		:= bT_AirER_Hi_Wr AND (NOT IN_VE.bEng_Dem_EPS OR IN_VE.bOnly_Island)
	OR (Para.bVISA AND NOT IN_VE.tT_AirER_Ext_Hi.Di);
	xMsg2472.PT			:=	T#1s;	
	xMsg2472.Prio		:=	4;
	xMsg2472.RiskClass	:=	0;		(* TI 1100-0111 *)
	xMsg2472.Reset		:=	FALSE;
	xMsg2472();
	MM2VIS.bMsg2472	    :=	xMsg2472.Q;	
	

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(*  1138 engine room fan failure trip (W2120) *)
	bERV_AirFlowMon_Off :=	(IN_VE.tInAirER_Lou1Opened.Di OR IN_VE.tInAirER_Lou2Opened.Di OR IN_VE.tOutAirER_LouOpened.Di OR Pos_InlLou1_OK OR Pos_InlLou2_OK OR Pos_OutlLou1_OK OR Pos_OutlLou2_OK) 
					 AND NOT(IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do); 		(* monit.off for reason of natural air flow with open louvers *)
	xTON_StartERV(IN:= IN_VE.bEng_Aux_Dem_CDR, PT:= T#30s);				(* startverzoegerung fuer ueberwachung *)

	IF    Para.bERV_AirFlowMon_Active AND Para.bInAirER_Fan_FU THEN		
			(* var: flow sensor, stationaeranlage, container BR6	*)
			(* var: stationaeranlage, steuerung RL durch GEJ inkl. Rueckmeldung RL in Betrieb (flow switch od.IFL 56.32) *)
		xTON_ERV_On(IN:=      FG_FU                        AND NOT IN_VE.tERV_Op.Di AND NOT bERV_AirFlowMon_Off, PT:= T#15s);(* delay on:  eng.room vent.ok/air flow monitoring *)
		xTON_ERV_Of(IN:=  NOT FG_FU                        AND     IN_VE.tERV_Op.Di AND NOT bERV_AirFlowMon_Off, PT:= T#5m); (* delay off: change contact check *)
	ELSIF Para.bERV_AirFlowMon_Active AND NOT Para.bInAirER_Fan_FU THEN
		xTON_ERV_On(IN:=      OUT_VE.tInAirER_Fan1DemOn.Do AND NOT IN_VE.tERV_Op.Di AND NOT bERV_AirFlowMon_Off, PT:= T#15s);(* delay on:  eng.room vent.ok/air flow monitoring *)
		xTON_ERV_Of(IN:=  NOT OUT_VE.tInAirER_Fan1DemOn.Do AND     IN_VE.tERV_Op.Di AND NOT bERV_AirFlowMon_Off, PT:= T#5m); (* delay off: change contact check *)
	ELSIF Para.bInAirER_Fan_FU THEN
			(* var: FU=RUN, ohne luftstromwaechter *)
		xTON_ERV_On(IN:=      FG_FU   					   AND NOT IN_VE.tERV_Op.Di AND    (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do), PT:= T#15s);
		xTON_ERV_Of(IN:= FALSE, PT:= T#5m);
	ELSE	(* var: lueftung in betrieb, ohne FU, ohne luftstromwaechter *)
		xTON_ERV_On(IN:=      OUT_VE.tInAirER_Fan1DemOn.Do AND NOT IN_VE.tERV_Op.Di AND    (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do), PT:= T#15s);
		xTON_ERV_Of(IN:= FALSE, PT:= T#5m);
	END_IF;
			(* keine ERV: 	para bERV_AirFlowMon_Active (default =0) => OFF
							para bAirInVentF (default=1) n.r.,
							DI_ERV_Op (default = 1) nicht belegt *)


	bAuxRel_Louvers := (IN_VE.tOutAirER_LouOpened.Di AND IN_VE.tInAirER_Lou1Opened.Di) 
					OR((Pos_InlLou1_OK OR Pos_InlLou2_OK) AND (Pos_OutlLou1_OK OR Pos_OutlLou2_OK));

	bAuxRel_FireProtFlaps := IN_VE.tFireProtFlap1_InlAir_Opened.Di  AND IN_VE.tFireProtFlap2_InlAir_Opened.Di AND 
							 IN_VE.tFireProtFlap1_OutlAir_Opened.Di AND IN_VE.tFireProtFlap2_OutlAir_Opened.Di;
	
	xTOF_EngDemEPS(IN:= IN_VE.bEng_Dem_EPS AND NOT IN_VE.tGCB_On.Di, PT:= T#60s);
	bNoMon4BlackStart := xTOF_EngDemEPS.Q AND IN_VE.bEng_Dem_EPS; //T14

	xMsg1138.Enable		:=	IN_VE.tERV_Op.GoodQual;
	xMsg1138.Set		:= (NOT bNoMon4BlackStart AND  ((xTON_ERV_On.Q AND xTON_StartERV.Q) 
                                                     OR  xTON_ERV_Of.Q))
						OR (IN_VE.bFS_Act AND xTON_StartERV.Q AND NOT bAuxRel_Louvers)
						OR (IN_VE.bFS_Act AND xTON_StartERV.Q AND NOT bAuxRel_FireProtFlaps);
	xMsg1138.PT			:=	T#0s;			
	xMsg1138.Prio		:=	3;				
	xMsg1138.RiskClass	:=	4;
	xMsg1138.Reset		:=	FALSE;			
	xMsg1138();
	MM2VIS.bMsg1138 	:=	xMsg1138.Q;	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)			
	(*  2120 engine room fan failure *)
	xTON_MonAuxV(IN:= IN_VE.tGCB_On.Di, PT:= T#60s);		(* release monitoring engine room fan failure *)

	IF Para.bInAirER_Fan_FU THEN
		xTON_ERV.IN			:= (NOT IN_VE.tER_Ext_Err.Di AND     IN_VE.tAuxV_Supply_Ok.Di AND IN_VE.tAuxV_Aux_ok.Di) 
							OR (    xTON_MonAuxV.Q	     AND(NOT IN_VE.tAuxV_Supply_Ok.Di 
														  OR NOT IN_VE.tAuxV_Aux_ok.Di));
	ELSE
		xTON_ERV.IN			:=  NOT IN_VE.tER_Ext_Err.Di;
	END_IF;
	xTON_ERV(PT:= T#12s);

	xMsg2120.Enable		:=	TRUE;
	xMsg2120.Set		:=	xTON_ERV.Q;
	xMsg2120.PT			:=	T#0s;			
	xMsg2120.Prio		:=	4;				
	xMsg2120.RiskClass	:=	4;
	xMsg2120.Reset		:=	FALSE;			
	xMsg2120();
	MM2VIS.bMsg2120     :=	xMsg2120.Q;

	(* engine room ventilation not ready - block engine start as long as failure is active *)
	OUT_VE.bERV_NotRdy := xMsg2120.Set OR xMsg2795.Set OR xMsg2796.Set;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)	

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(*  2295 engine room ventilation failure inlet air *)
	bERV_InlAirFlowMon_Off := (IN_VE.tInAirER_Lou1Opened.Di OR IN_VE.tInAirER_Lou2Opened.Di OR Pos_InlLou1_OK OR Pos_InlLou2_OK)					
					  AND NOT (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do); 	(* monit.off for reason of natural air flow with open louvers *)
	xTON_StartERV(IN:= IN_VE.bEng_Aux_Dem_CDR, PT:= T#30s);				(* startverzoegerung fuer ueberwachung *)

	IF    Para.bERV_AirFlowMon_Active AND Para.bInAirER_Fan_FU THEN		
		(* var: flow sensor, stationaeranlage, container BR6	*)
		(* var: stationaeranlage, steuerung RL durch GEJ inkl. Rueckmeldung RL in Betrieb *)
		xTON_ERV_Inl_On(IN:=      FG_FU                        AND NOT IN_VE.tERV_InlAir_Op.Di AND NOT bERV_InlAirFlowMon_Off, PT:= T#15s);(* delay on:  eng.room inl.vent.ok/air flow monitoring *)
		xTON_ERV_Inl_Of(IN:=  NOT FG_FU                        AND     IN_VE.tERV_InlAir_Op.Di AND NOT bERV_InlAirFlowMon_Off, PT:= T#5m); (* delay off: change contact check *)
	ELSIF Para.bERV_AirFlowMon_Active AND NOT Para.bInAirER_Fan_FU THEN
		xTON_ERV_Inl_On(IN:=      OUT_VE.tInAirER_Fan1DemOn.Do AND NOT IN_VE.tERV_InlAir_Op.Di AND NOT bERV_InlAirFlowMon_Off, PT:= T#15s);(* delay on:  eng.room inl.vent.ok/air flow monitoring *)
		xTON_ERV_Inl_Of(IN:=  NOT OUT_VE.tInAirER_Fan1DemOn.Do AND     IN_VE.tERV_InlAir_Op.Di AND NOT bERV_InlAirFlowMon_Off, PT:= T#5m); (* delay off: change contact check *)
	ELSIF Para.bInAirER_Fan_FU THEN
		(* var: FU=RUN, ohne luftstromwaechter *)
		xTON_ERV_Inl_On(IN:=      FG_FU   					   AND NOT IN_VE.tERV_InlAir_Op.Di AND    (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do), PT:= T#15s);
		xTON_ERV_Inl_Of(IN:= FALSE, PT:= T#5m);
	ELSE	(* var: lueftung in betrieb, ohne FU, ohne luftstromwaechter *)
		xTON_ERV_Inl_On(IN:=      OUT_VE.tInAirER_Fan1DemOn.Do AND NOT IN_VE.tERV_InlAir_Op.Di AND    (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do), PT:= T#15s);
		xTON_ERV_Inl_Of(IN:= FALSE, PT:= T#5m);
	END_IF;

	bAuxRel_Louvers_InlAir       := IN_VE.tInAirER_Lou1Opened.Di OR Pos_InlLou1_OK OR Pos_InlLou2_OK;
	bAuxRel_FireProtFlaps_InlAir := IN_VE.tFireProtFlap1_InlAir_Opened.Di AND IN_VE.tFireProtFlap2_InlAir_Opened.Di;
	
	xTOF_EngDemEPS(IN:= IN_VE.bEng_Dem_EPS AND NOT IN_VE.tGCB_On.Di, PT:= T#60s);
	bNoMon4BlackStart := xTOF_EngDemEPS.Q AND IN_VE.bEng_Dem_EPS; //T14

	xTON_InAirER_LouFail(IN:= (OUT_VE.tInAirER_Lou1DemOpen.Do OR OUT_VE.tInAirER_Lou2DemOpen.Do OR OUT_VE.tCtr_InlLou_Set.Ao > 0.5) AND NOT OUT_VE.bInLouRelVE AND xOpMode.Stop,  PT:= T#90s);		(* Inlet louver required and not opened *)

	xMsg2295.Enable		:=	IN_VE.tERV_InlAir_Op.GoodQual OR (xOpMode.Stop AND (xTON_InAirER_LouFail.Q OR MM2VIS.bMsg2295));
	xMsg2295.Set		:=	(NOT bNoMon4BlackStart AND ((xTON_ERV_Inl_On.Q AND xTON_StartERV.Q) 
						    OR  xTON_ERV_Inl_Of.Q))
					        OR (IN_VE.bFS_Act AND xTON_StartERV.Q AND NOT bAuxRel_Louvers_InlAir)
	                        OR (IN_VE.bFS_Act AND xTON_StartERV.Q AND NOT bAuxRel_FireProtFlaps_InlAir)
							OR xTON_InAirER_LouFail.Q;
	xMsg2295.PT			:=	T#0s;			
	xMsg2295.Prio		:=	3;				
	xMsg2295.RiskClass	:=	10;
	xMsg2295.Reset		:=	FALSE;			
	xMsg2295();
	MM2VIS.bMsg2295	    :=	xMsg2295.Q;	
	OUT_VE.bMsg2295	    :=	xMsg2295.Q;	
	

	(*  2296 engine room ventilation failure outlet air *)
	bERV_OutlAirFlowMon_Off := (IN_VE.tOutAirER_LouOpened.Di OR Pos_OutlLou1_OK OR Pos_OutlLou2_OK)					
					   AND NOT (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do); (* monit.off for reason of natural air flow with open louvers *)
	xTON_StartERV(IN:= IN_VE.bEng_Aux_Dem_CDR, PT:= T#30s);				(* startverzoegerung fuer ueberwachung *)

	IF    Para.bERV_AirFlowMon_Active AND Para.bOutAirER_Fan_FU THEN		
		(* var: flow sensor, stationaeranlage, container BR6	*)
		(* var: stationaeranlage, steuerung RL durch GEJ inkl. Rueckmeldung RL in Betrieb *)
		xTON_ERV_Outl_On(IN:=      FG_FU                          AND NOT IN_VE.tERV_OutlAir_Op.Di AND NOT bERV_OutlAirFlowMon_Off, PT:= T#15s);(* delay on:  eng.room outl.vent.ok/air flow monitoring *)
		xTON_ERV_Outl_Of(IN:=  NOT FG_FU                          AND     IN_VE.tERV_OutlAir_Op.Di AND NOT bERV_OutlAirFlowMon_Off, PT:= T#5m); (* delay off: change contact check *)
	ELSIF Para.bERV_AirFlowMon_Active AND NOT Para.bOutAirER_Fan_FU THEN
		xTON_ERV_Outl_On(IN:=      OUT_VE.tOutAirER_LouDemOpen.Do AND NOT IN_VE.tERV_OutlAir_Op.Di AND NOT bERV_OutlAirFlowMon_Off, PT:= T#15s);(* delay on:  eng.room outl.vent.ok/air flow monitoring *)
		xTON_ERV_Outl_Of(IN:=  NOT OUT_VE.tOutAirER_LouDemOpen.Do AND     IN_VE.tERV_OutlAir_Op.Di AND NOT bERV_OutlAirFlowMon_Off, PT:= T#5m); (* delay off: change contact check *)
	ELSIF Para.bOutAirER_Fan_FU THEN
		(* var: FU=RUN, ohne luftstromwaechter *)
		xTON_ERV_Outl_On(IN:=      FG_FU   					      AND NOT IN_VE.tERV_OutlAir_Op.Di AND    (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do), PT:= T#15s);
		xTON_ERV_Outl_Of(IN:= FALSE, PT:= T#5m);
	ELSE	(* var: lueftung in betrieb, ohne FU, ohne luftstromwaechter *)
		xTON_ERV_Outl_On(IN:=      OUT_VE.tInAirER_Fan1DemOn.Do AND NOT IN_VE.tERV_OutlAir_Op.Di AND    (IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do), PT:= T#15s);
		xTON_ERV_Outl_Of(IN:= FALSE, PT:= T#5m);	
	END_IF;

	bAuxRel_Louvers_OutlAir       := IN_VE.tOutAirER_LouOpened.Di OR Pos_OutlLou1_OK OR Pos_OutlLou2_OK;
	bAuxRel_FireProtFlaps_OutlAir := IN_VE.tFireProtFlap1_OutlAir_Opened.Di AND IN_VE.tFireProtFlap2_OutlAir_Opened.Di;
	
	xTOF_EngDemEPS(IN:= IN_VE.bEng_Dem_EPS AND NOT IN_VE.tGCB_On.Di, PT:= T#60s);
	bNoMon4BlackStart := xTOF_EngDemEPS.Q AND IN_VE.bEng_Dem_EPS; //T14

	xMsg2296.Enable		:=	IN_VE.tERV_OutlAir_Op.GoodQual;
	xMsg2296.Set		:=	(NOT bNoMon4BlackStart AND ((xTON_ERV_Outl_On.Q AND xTON_StartERV.Q) 
							OR  xTON_ERV_Outl_Of.Q))
							OR (IN_VE.bFS_Act AND xTON_StartERV.Q AND NOT bAuxRel_Louvers_OutlAir)
							OR (IN_VE.bFS_Act AND xTON_StartERV.Q AND NOT bAuxRel_FireProtFlaps_OutlAir);
	xMsg2296.PT			:=	T#0s;			
	xMsg2296.Prio		:=	3;				
	xMsg2296.RiskClass	:=	10;
	xMsg2296.Reset		:=	FALSE;			
	xMsg2296();
	MM2VIS.bMsg2296	    :=	xMsg2296.Q;	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	

	(*  2630 Air inlet filter difference pressure maximum - engine room ventilation *)
	xMsg2630.Enable	   	:= TRUE;
	xMsg2630.Set       	:= NOT IN_VE.tDPr_InAirFiltERV_Hi.Di;
	xMsg2630.PT		   	:= T#0s;
	xMsg2630.Prio	   	:= 4;
	xMsg2630.RiskClass 	:= 4;
	xMsg2630.Reset	   	:= FALSE;
	xMsg2630();
	MM2VIS.bMsg2630		:= xMsg2630.Q;
	

	(*  2701 measuring signal failure position air inlet louver 1  *)
	xMsg2701.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPos_InlLou1_Active;
	xMsg2701.Set        := IN_VE.tPB2MM.bParaSetupOk AND NOT IN_VE.tPos_InlLou1.GoodQual;
	xMsg2701.PT			:=	T#0s;			
	xMsg2701.Prio		:=	4;				
	xMsg2701.RiskClass	:=	4;
	xMsg2701.Reset		:=	FALSE;
	xMsg2701();
	MM2VIS.bMsg2701		:=	xMsg2701.Q;
	OUT_VE.bMsg2701		:=	xMsg2701.Q;
	

	(*  2702 measuring signal failure position air inlet louver 2  *)
	xMsg2702.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPos_InlLou2_Active;
	xMsg2702.Set        := IN_VE.tPB2MM.bParaSetupOk AND NOT IN_VE.tPos_InlLou2.GoodQual;
	xMsg2702.PT			:=	T#0s;			
	xMsg2702.Prio		:=	4;				
	xMsg2702.RiskClass	:=	4;
	xMsg2702.Reset		:=	FALSE;
	xMsg2702();
	MM2VIS.bMsg2702		:=	xMsg2702.Q;
	OUT_VE.bMsg2702		:=	xMsg2702.Q;
	

	(*  2703 measuring signal failure position air outlet louver 1  *)
	xMsg2703.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPos_OutlLou1_Active;
	xMsg2703.Set        := IN_VE.tPB2MM.bParaSetupOk AND NOT IN_VE.tPos_OutlLou1.GoodQual;
	xMsg2703.PT			:=	T#0s;			
	xMsg2703.Prio		:=	4;				
	xMsg2703.RiskClass	:=	4;
	xMsg2703.Reset		:=	FALSE;
	xMsg2703();
	MM2VIS.bMsg2703		:=	xMsg2703.Q;
	OUT_VE.bMsg2703		:=	xMsg2703.Q;
	

	(*  2704 measuring signal failure position air outlet louver 2  *)
	xMsg2704.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPos_OutlLou2_Active;
	xMsg2704.Set        := IN_VE.tPB2MM.bParaSetupOk AND NOT IN_VE.tPos_OutlLou2.GoodQual;
	xMsg2704.PT			:=	T#0s;			
	xMsg2704.Prio		:=	4;				
	xMsg2704.RiskClass	:=	4;
	xMsg2704.Reset		:=	FALSE;
	xMsg2704();
	MM2VIS.bMsg2704		:=	xMsg2704.Q;
	OUT_VE.bMsg2704		:=	xMsg2704.Q;
	

	(*  2705 measuring signal failure engine room difference pressure  *)
	xMsg2705.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPrDiff_ER_Active;
	xMsg2705.Set        := IN_VE.tPB2MM.bParaSetupOk AND NOT IN_VE.tPrDiff_ER.GoodQual;
	xMsg2705.PT			:=	T#0s;			
	xMsg2705.Prio		:=	4;				
	xMsg2705.RiskClass	:=	4;
	xMsg2705.Reset		:=	FALSE;
	xMsg2705();
	MM2VIS.bMsg2705		:=	xMsg2705.Q;
	OUT_VE.bMsg2705		:=	xMsg2705.Q;
	

	(*  2706 engine room difference pressure low  *)
	xGR_MINR_PrDiff(In := IN_VE.tPrDiff_ER.Ai, Gw:= Para.rPrDiff_ER_Lim_Low, Hy:= Para.rPrDiff_ER_Lim_Low_Hy);
	bPrDiff_Lo := xGR_MINR_PrDiff.Q;
	
	xMsg2706.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPrDiff_ER_Active;
	xMsg2706.Set        := IN_VE.tPB2MM.bParaSetupOk AND bPrDiff_Lo AND IN_VE.tEng_Run.Do;
	xMsg2706.PT			:=	T#10s;			
	xMsg2706.Prio		:=	4;				
	xMsg2706.RiskClass	:=	4;
	xMsg2706.Reset		:=	FALSE;
	xMsg2706();
	MM2VIS.bMsg2706		:=	xMsg2706.Q;
	OUT_VE.bMsg2706		:=	xMsg2706.Q;


	(*  2707 engine room difference pressure high  *)
	xGR_MAXR_PrDiff(In := IN_VE.tPrDiff_ER.Ai, Gw:= Para.rPrDiff_ER_Lim_High, Hy:= Para.rPrDiff_ER_Lim_High_Hy);
	bPrDiff_Hi := xGR_MAXR_PrDiff.Q;
	
	xMsg2707.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPrDiff_ER_Active;
	xMsg2707.Set        := IN_VE.tPB2MM.bParaSetupOk AND bPrDiff_Hi;
	xMsg2707.PT			:=	T#10s;			
	xMsg2707.Prio		:=	4;				
	xMsg2707.RiskClass	:=	4;
	xMsg2707.Reset		:=	FALSE;
	xMsg2707();
	MM2VIS.bMsg2707		:=	xMsg2707.Q;
	OUT_VE.bMsg2707		:=	xMsg2707.Q;
	

	(*  2708 measuring signal failure position air circulation louver 1  *)
	xMsg2708.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPos_CircLou1_Active;
	xMsg2708.Set        := IN_VE.tPB2MM.bParaSetupOk AND NOT IN_VE.tPos_CircLou1.GoodQual;
	xMsg2708.PT			:=	T#0s;			
	xMsg2708.Prio		:=	4;				
	xMsg2708.RiskClass	:=	4;
	xMsg2708.Reset		:=	FALSE;
	xMsg2708();
	MM2VIS.bMsg2708		:=	xMsg2708.Q;
	OUT_VE.bMsg2708		:=	xMsg2708.Q;
	

	(*  2709 measuring signal failure position air circulation louver 2  *)
	xMsg2709.Enable     := IN_VE.tPB2MM.bSys_Run AND Para.bPos_CircLou2_Active;
	xMsg2709.Set        := IN_VE.tPB2MM.bParaSetupOk AND NOT IN_VE.tPos_CircLou2.GoodQual;
	xMsg2709.PT			:=	T#0s;			
	xMsg2709.Prio		:=	4;				
	xMsg2709.RiskClass	:=	4;
	xMsg2709.Reset		:=	FALSE;
	xMsg2709();
	MM2VIS.bMsg2709		:=	xMsg2709.Q;
	OUT_VE.bMsg2709		:=	xMsg2709.Q;
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(*  2795 engine room ventilation failure inlet air *)
	IF Para.bInAirER_Fan_FU THEN
		xTON_ERV_In.IN	:= (NOT IN_VE.tER_InlAir_Ext_Err.Di AND IN_VE.tAuxV_Supply_Ok.Di AND IN_VE.tAuxV_Aux_ok.Di) 
						OR (    xTON_MonAuxV.Q AND NOT IN_VE.tAuxV_Supply_Ok.Di) 
						OR (    xTON_MonAuxV.Q AND NOT IN_VE.tAuxV_Aux_ok.Di);
	ELSE
		xTON_ERV_In.IN	:=  NOT IN_VE.tER_InlAir_Ext_Err.Di;
	END_IF;
	xTON_ERV_In(PT:= T#12s);

	xMsg2795.Enable		:=	TRUE;
	xMsg2795.Set		:=	xTON_ERV_In.Q;
	xMsg2795.PT			:=	T#0s;			
	xMsg2795.Prio		:=	4;				
	xMsg2795.RiskClass	:=	4;
	xMsg2795.Reset		:=	FALSE;			
	xMsg2795();
	MM2VIS.bMsg2795     :=	xMsg2795.Q;
	OUT_VE.bMsg2795     :=  xMsg2795.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)		

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(*  2796 engine room ventilation failure outlet air *)
	IF Para.bOutAirER_Fan_FU THEN
		xTON_ERV_Out.IN	:= (NOT IN_VE.tER_OutlAir_Ext_Err.Di AND IN_VE.tAuxV_Supply_Ok.Di AND IN_VE.tAuxV_Aux_ok.Di) 
						OR (    xTON_MonAuxV.Q AND NOT IN_VE.tAuxV_Supply_Ok.Di)
						OR (    xTON_MonAuxV.Q AND NOT IN_VE.tAuxV_Aux_ok.Di);
	ELSE
		xTON_ERV_Out.IN	:=  NOT IN_VE.tER_OutlAir_Ext_Err.Di;
	END_IF;
	xTON_ERV_Out(PT:= T#12s);

	xMsg2796.Enable		:=	TRUE;
	xMsg2796.Set		:=	xTON_ERV_Out.Q;
	xMsg2796.PT			:=	T#0s;			
	xMsg2796.Prio		:=	4;				
	xMsg2796.RiskClass	:=	4;
	xMsg2796.Reset		:=	FALSE;			
	xMsg2796();
	MM2VIS.bMsg2796     :=	xMsg2796.Q;
	OUT_VE.bMsg2796     :=  xMsg2796.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)

	(*  2797 parameterization error air inlet louvers *)
	xMsg2797.Enable		:=	TRUE;
	xMsg2797.Set 		:=  NOT (iValueInlLou = 0 
							  OR iValueInlLou = 11
							  OR iValueInlLou = 12		
							  OR iValueInlLou = 21	
	                          OR iValueInlLou = 22); 
	xMsg2797.PT			:=	T#2s;			
	xMsg2797.Prio		:=	4;				
	xMsg2797.RiskClass	:=	4;
	xMsg2797.Reset		:=	FALSE;			
	xMsg2797();
	MM2VIS.bMsg2797     :=	xMsg2797.Q;
	OUT_VE.bMsg2797     :=  xMsg2797.Q;


	(*  2798 parameterization error air outlet louvers *)
	xMsg2798.Enable		:=	TRUE;
	xMsg2798.Set 		:=  NOT (iValueOutlLou = 0 
							  OR iValueOutlLou = 11
						      OR iValueOutlLou = 12		
	                          OR iValueOutlLou = 21	
	                          OR iValueOutlLou = 22); 
	xMsg2798.PT			:=	T#2s;			
	xMsg2798.Prio		:=	4;				
	xMsg2798.RiskClass	:=	4;
	xMsg2798.Reset		:=	FALSE;			
	xMsg2798();
	MM2VIS.bMsg2798     :=	xMsg2798.Q;
	OUT_VE.bMsg2798     :=  xMsg2798.Q;
	

	(*  3152 engine room air temperature signal failure *)
	xMsg3152.Enable		:=	IN_VE.tPB2MM.bParaSetupOk AND Para.bT_AirER_Active;			
	xMsg3152.Set		:= (NOT IN_VE.tT_AirER.GoodQual AND IN_VE.rT_AirER_Customized <= 0.0)
						OR (	xMsg3152.Q AND IN_VE.bMsg3003 AND bOMSS_MAT);
	xMsg3152.PT			:=	T#0s;			
	xMsg3152.Prio		:=	4;				
	xMsg3152.RiskClass	:=	4;
	xMsg3152.Reset		:=	FALSE;
	xMsg3152();
	MM2VIS.bMsg3152		:=	xMsg3152.Q;
	OUT_VE.bMsg3152		:=	xMsg3152.Q;


	(*  3223 engine room air inlet temperature signal failure *)						(* --> NOT USED *)
	xMsg3223.Enable		:=	FALSE;			
	xMsg3223.Set		:=	FALSE;        	
	xMsg3223.PT			:=	T#0s;			
	xMsg3223.Prio		:=	4;				
	xMsg3223.RiskClass	:=	4;
	xMsg3223.Reset		:=	FALSE;
	xMsg3223();
	MM2VIS.bMsg3223		:=	xMsg3223.Q;	


	(*  3224 engine room air inlet temperature high *)									(* --> NOT USED *)
	xMsg3224.Enable		:=	FALSE;			
	xMsg3224.Set		:=	FALSE;
	xMsg3224.PT			:=	T#0s;			
	xMsg3224.Prio		:=	4;				
	xMsg3224.RiskClass	:=	4;
	xMsg3224.Reset		:=	FALSE;
	xMsg3224();
	MM2VIS.bMsg3224	    :=	xMsg3224.Q;
	

	(*---------------------------------------------------------------------------*)
	(*  3302 purge cycle incomplete *)
	xTON_purge(IN:= dmnd_purge AND NOT OUT_VE.bPurgeER_Rdy, PT:= Para.tiPurgeTimeMax);

	xMsg3302.Enable		:=	Para.bPurgecycle_Active;
	xMsg3302.Set		:=	xTON_purge.Q
						OR (dmnd_purge AND IN_VE.tEng_Run.Do AND NOT OUT_VE.bPurgeER_Rdy);
	xMsg3302.PT			:=	T#0s;			
	xMsg3302.Prio		:=	2;				
	xMsg3302.RiskClass	:=	4;
	xMsg3302.Reset		:=	FALSE;
	xMsg3302();
	MM2VIS.bMsg3302		:=	xMsg3302.Q;
	

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(*  3367 engine room ventilation failure - doors *)
	xMsg3367.Enable		:=	TRUE;
	xMsg3367.Set		:=	(IN_VE.bEng_Dem OR IN_VE.tEng_Run.Do) AND NOT IN_VE.tER_DoorClosed.Di;
	xMsg3367.PT			:=	T#15s;			
	xMsg3367.Prio		:=	3;				
	xMsg3367.RiskClass	:=	4;
	xMsg3367.Reset		:=	FALSE;
	xMsg3367();
	MM2VIS.bMsg3367		:=	xMsg3367.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	

	(*---------------------------------------------------------------------------*)
	(*  3571 no release start module from purge cycle *)
	xTON_PurgeNoRel(IN:= IN_VE.bEng_Dem AND NOT IN_VE.tRel_ER_PurgeCycle.Di AND OUT_VE.bPurgeER_Rdy, PT:= T#200s);

	xMsg3571.Enable		:=	Para.bPurgecycle_Active;			
	xMsg3571.Set		:=	xTON_PurgeNoRel.Q AND NOT IN_VE.tEng_Run.Do;
	xMsg3571.PT			:=	T#0s;			
	xMsg3571.Prio		:=	4;				
	xMsg3571.RiskClass	:=	4;
	xMsg3571.Reset		:=	FALSE;
	xMsg3571();
	MM2VIS.bMsg3571		:=	xMsg3571.Q;

	(*---------------------------------------------------------------------------*)
	IF NOT IN_VE.tOutAirER_LouClosed.GoodQual THEN
		IN_VE.tOutAirER_LouClosed.Di  := 	NOT IN_VE.tOutAirER_LouOpened.Di;
	END_IF;
	IF NOT IN_VE.tInAirER_Lou1Closed.GoodQual THEN
		IN_VE.tInAirER_Lou1Closed.Di  :=	NOT IN_VE.tInAirER_Lou1Opened.Di;
	END_IF;
	IF NOT IN_VE.tInAirER_Lou2Closed.GoodQual THEN
		IN_VE.tInAirER_Lou2Closed.Di  :=	NOT IN_VE.tInAirER_Lou2Opened.Di;
	END_IF;

	(* B2968 Air inlet louver position feedback not plausible *)
	TON_InlLou_ssf(IN := IN_VE.tEng_Run.Do AND (
			(IN_VE.tInAirER_Lou1Closed.Di AND IN_VE.tInAirER_Lou1Opened.Di)
		 OR (NOT IN_VE.tInAirER_Lou1Closed.Di AND NOT IN_VE.tInAirER_Lou1Opened.Di)
		 OR (IN_VE.tInAirER_Lou2Closed.Di AND IN_VE.tInAirER_Lou2Opened.Di)
		 OR (NOT IN_VE.tInAirER_Lou2Closed.Di AND NOT IN_VE.tInAirER_Lou2Opened.Di)) , PT := T#2m);

	xMsg2968.Enable	:= TRUE;
	xMsg2968.Set 	:=	NOT Para.bPos_InlLou1_Active AND NOT Para.bPos_InlLou2_Active AND TON_InlLou_ssf.Q;
	xMsg2968.Reset 	:= TRUE;
	xMsg2968();
	MM2VIS.bMsg2968   := xMsg2968.Q;
	
	(* B2969 Air outlet louver position feedback not plausible *)
	TON_OutLou_ssf(IN := IN_VE.tEng_Run.Do AND ((IN_VE.tOutAirER_LouClosed.Di AND IN_VE.tOutAirER_LouOpened.Di)
		 OR ((NOT IN_VE.tOutAirER_LouClosed.Di AND NOT IN_VE.tOutAirER_LouOpened.Di))) , PT := T#2m);

	xMsg2969.Enable	:= TRUE;
	xMsg2969.Set 	:=	NOT Para.bPos_OutlLou1_Active AND NOT Para.bPos_OutlLou2_Active AND TON_OutLou_ssf.Q;
	xMsg2969.Reset := TRUE;
	xMsg2969();
	MM2VIS.bMsg2969   := xMsg2969.Q;
	(*---------------------------------------------------------------------------*)
	(*  9401 Louver failure *)
	
	IF Para.bER_VentColdCountryMode THEN 
		bLouvers := IN_VE.tOutAirER_LouOpened.Di;
	ELSE								 
		IF IN_VE.bFS_Act AND NOT xTON_MonFS.Q THEN
			bLouvers := (IN_VE.tOutAirER_LouOpened.Di OR NOT IN_VE.tOutAirER_LouClosed.Di OR Pos_OutlLou1_OK OR Pos_OutlLou2_OK) AND 
									(IN_VE.tInAirER_Lou1Opened.Di OR NOT IN_VE.tInAirER_Lou1Closed.Di OR Pos_InlLou1_OK  OR Pos_InlLou2_OK);
		ELSE
			bLouvers := (IN_VE.tOutAirER_LouOpened.Di OR Pos_OutlLou1_OK OR Pos_OutlLou2_OK) AND
									(IN_VE.tInAirER_Lou1Opened.Di OR Pos_InlLou1_OK  OR Pos_InlLou2_OK);
		END_IF;
	END_IF;
	
	(*  wait until louvers ready or 160s which is max time for the slowest SF24A-SR-S2 louver*)
	IF bLouvers THEN
		xTON_Wait_louver	(IN	:= IN_VE.bEng_Aux_Dem, PT:=T#0s);
	ELSE
		xTON_Wait_louver	(IN	:= IN_VE.bEng_Aux_Dem, PT:= T#160s);
	END_IF
		
	xMsg9401.Enable		:=	TRUE;			
	xMsg9401.Set		:=	xTON_Wait_louver.Q  AND (NOT bLouvers AND IN_VE.bEng_Aux_Dem);
	xMsg9401.PT			:=	T#0s;			
	xMsg9401.Prio		:=	3;				
	xMsg9401.RiskClass	:=	4;
	xMsg9401.Reset		:=	FALSE;
	xMsg9401();
	MM2VIS.bMsg9401		:=	xMsg9401.Q;
	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)
	// bMsg0000	:=	NOT TRUE;						(* Bxxxx operating message text *)
	// bMsg0001	:=		FALSE;						(* Bxxxx operating message text *)

	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1	:=	OUT_VE.tVE2AB.bGnlTrip1 	OR IN_VE.tAB2VE.bGnlTrip1;
	bGnlTrip2	:=	OUT_VE.tVE2AB.bGnlTrip2 	OR IN_VE.tAB2VE.bGnlTrip2;
	bGnlTrip3	:=	OUT_VE.tVE2AB.bGnlTrip3 	OR IN_VE.tAB2VE.bGnlTrip3;
	bGnlWarning :=	OUT_VE.tVE2AB.bGnlWarning 	OR IN_VE.tAB2VE.bGnlWarning;

	bGnlTrip	:= bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;	
	(*******************************************************************************)
END_PROGRAM
