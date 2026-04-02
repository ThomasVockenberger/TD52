(*******************************************************************************
MsgEX	 			 alarms, messages MM_EX

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2025

Customized modifications: -
------------------------
 
History:
-------
V3.99.0	04.06.2012	lettenb.	new	
		20.03.2013				para.cleanup
		23.04.2013				reset OUT_EX.tEX2AB.bGnlWarning added
		16.05.2013				3349,3580,3581,3582 added from V3.30.x
		23.05.2013				2847,2848 added
		24.05.2013				reset OUT_xx.txx2AB.bGnlTripx changed
		28.05.2013				2622,2623 for 424tstc added
		04.06.2013				1163,1171 var.names changed(EGbHE -> EGaTC)
								1172 limit var.changed, bugfix
		23.07.2013				2576,2577 enabled if sensor active
		17.01.2014				3366,3417 added, 1165 disabled (exh.gas scav. after engine stop)
V4.00.0	26.02.2014				logger entries added
V4.00.1	09.04.2014				3417 disabled for engines without EGScav
V4.00.2	14.05.2014				1172 KK_AUF AND BTRB added, ton 0s->120s (anforderung requisition/poppe,a_v3500) 
		27.05.2014				1172 KK_AUF -> OUT_EX.EG_BoVaOpened (universal for combi valves)
		23.06.2014				2098 logic in case of Para.bSel_EGVa_Combi separated, bugfix
		08.08.2014				3417 IN_EX.bMsg1078 added, to avoid alarm in case of signal failure
V4.00.3 21.01.2015 lettenb.		2655-2664 added(Gen2 engine controller)
		11.02.2015				1165,3366 prepared FOR blackstart, 
								3510 logic corr.(bugfix)
								1163 enable with IN_VE.tPB2MM.bSys_Run
								1273-1280 added
V4.03.0 27.07.2015 Plattner		2743 - 2748 & 3397 added. differential pressure exhaust gas cooler and filter limits and msf
								1288 - 1291 added operations message from CO2 flap
        05.08.2015 Stary        added 3394+3395 & 3490+3491
		14.07.2016 lettenb.		3491 xGR_MAXR_T_EGaHE2_LimHi_Warn: Ai+Para changed, 3394,3395,3490,3491 TON 0->2s, double 3395 removed, bugfix
		22.09.2016 lettenb.		1291 NOT added, bugfix
		04.10.2016				2793 added, FC monitoring
		09.02.2017				3417 trip prio corr. 3 -> 4
V4.05.0 21.03.2017 lettenb.     3100 disabled for 920, SWAT920/2
		28.06.2017				2847,2848 N2 gas valve open/closed changed, bugfix
		12.07.2017 Messner		A2315, W2468, W2469 added and W3417 para added
		09.10.2017 Weitzer		3100 enable for 920 again! Increase time delay from 2s TO 120s. SWAT920/x
		02.08.2017				2847,2848 N2 valves open/closed changed, synch.acc.VIS, bu09
		04.12.2017 Messner		Oxidation catalyst added
								Old KAT Disabled: A1045, A1069; W1161, W1162,  W1169, W1170, W1174, W2112;
								New OXIcat Added: A2319, A2320; W2494, W2495, W2496, W2497, W2498, W2499, W2500;
		22.05.2017	TinelloM	SCR deleted
		20.12.2017	lettenb.	A3397 prio: 4->3, bugfix
		02.01.2017	lettenb.	3417 disabled for 920 with common gas train(main and prechamber)(not for ACEA,sky,rosenheim,stapelfeld)
		18.01.2018				2310,2311,2312,2313 added, 1171,2546,2547:Para.rT_EGaTC_HyHi removed(burkhart)
		22.01.2018	lettenb.	1163,1164,2793 bSys_Run -> bParaSetupOk to avoid message at plc startup
V4.05.1 19.03.2018	lettenb.    2320,2500 delay 1s added to avoid alarm with siganl failure, bugfix
V4.07.0 26.04.2018	lettenb.	9215 added, 1165 enabled for BR9, 3366 disabled for BR9, SWAT920/5
		08.10.2018	lettenb.	3214, :bOMSS... removed, signal failure active in stop-mode
		31.10.2018	lettenb.	2321,2322 added, (burkhart)
		03.12.2018	lettenb.	1165,3366,1279,1280 NoScavFan added, bugfix for option N2 scav.without scav.fan
		14.01.2019	Schmid		A2340+W9249 added, W2498+W2497 deactivated, "exhaust gas pressure fast" fully replaces "OXIcat inlet pressure fast"
		18.03.2019	lettenb.	2497,2498 cleanup unused code
		13.06.2019	lettenb.	1171,2310,2311,2546,2547: MM2VIS.bMsg2312/2313/2322 added to avoid hi-alarm with MS, bugfix
		03.10.2019	lettenb.	9310 added, 2319 disabled, OXIcat monitoring, bu
V4.09.0	02.08.2019	lettenb.	2337,2338,9305-9308: temperature exhaust gas pressure relief valve 1/2 added
		13.07.2020	lettenb.	2496 time delay 60s added, bu
V4.11.0 04.03.2021	lettenb.	9347,9348 added, exhaust gas flap monitoring
V4.12.0	19.12.2022	Perktold	added comments for sr-code (EN 13849-1 / 4.6.3) for A1092,A2315 & W3528
V4.13.0	19.10.2023	Heim Markus	add A2374 (defined as safety critical no remote reset possible (riskclass 10)
V4.14.0	16.10.2024	VighM		W9249 set by bad signal quality, delay cleanup.
V4.14.0	06.11.2024	Theobald	At alarm 1092 only temperature sensor cause trip while the engine is running and at alarm 3366 there is no trip during engine operation.
		25.11.2024	Bacci		T6 Start procedure with purge start (2024-219): scavenging fan removal
V4.25.0	10.07.2025	Tinello	 	SafetyPLC: Disabled W3528 in case of Safety gas backpressure monitoring active

Instructions for use:
--------------------
1) declare alarm with FUNCTION block "Alm"
	declare buffert alarm bit bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	
	bMsg0000_Test		:=	xMsg0000.Test; alarm bypass active

3)  expand INIT

4)	include datapoint into OPC configuration for vis

			
Outstandings:
------------
logic FOR alarm 2622,2623 (424)
W exhaust gas scavenging before next start
(*******************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)
	OUT_EX.tEX2AB.bGnlTrip1		:=	FALSE;
	OUT_EX.tEX2AB.bGnlTrip2		:=	FALSE;
	OUT_EX.tEX2AB.bGnlTrip3		:=	FALSE;
	OUT_EX.tEX2AB.bGnlWarning	:=	FALSE;
	OUT_EX.tEX2AB.bTriptype1	:=	FALSE;
	OUT_EX.tEX2AB.bTriptype2	:=	FALSE;
	OUT_EX.tEX2AB.bTriptype3	:=	FALSE;	


	(*-------------------------------------------------------------------------*)
	(* A1045 catalyst temperature high (W1174) *) (* Disabled - OXIcat *)
	xMsg1045.Enable	   := FALSE;
	xMsg1045.Set	   := FALSE;
	xMsg1045.PT		   := T#0s;
	xMsg1045.Prio 	   := 2;
	xMsg1045.RiskClass := 4;
	xMsg1045.Reset     := FALSE;
	xMsg1045();
	MM2VIS.bMsg1045    := xMsg1045.Q;

	
	(* A1046 exhaust gas flap failure (--> W2098) *)
	xMsg1046.Enable	   := FALSE;
	xMsg1046.Set 	   := FALSE;
	xMsg1046.PT		   := T#0s;
	xMsg1046.Prio 	   := 3;
	xMsg1046.RiskClass := 3;
	xMsg1046.Reset     := FALSE;
	xMsg1046();
	MM2VIS.bMsg1046    := xMsg1046.Q;  

	
	(* A1069 catalyst temperature signal failure (W2112) *) (* Disabled - OXIcat *)
	xMsg1069.Enable	   := FALSE;
	xMsg1069.Set 	   := FALSE;
	xMsg1069.PT		   := T#0s;
	xMsg1069.Prio 	   := 3;
	xMsg1069.RiskClass := 2;
	xMsg1069.Reset     := FALSE;
	xMsg1069();
	MM2VIS.bMsg1069    := xMsg1069.Q;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	
	(* A1092 exhaust gas scavenging valve failure *)
	xMsg1092.Enable	   := TRUE;
	xMsg1092.Set 	   := (T1_STSPKL AND NOT IN_EX.tEng_Run.Do) OR T2_STSPKL;
	xMsg1092.PT		   := T#0s;
	xMsg1092.Prio 	   := 2;
	xMsg1092.RiskClass := 10;
	xMsg1092.Reset     := FALSE;
	xMsg1092();
	MM2VIS.bMsg1092    := xMsg1092.Q;  

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	(* A1104 plate temperature heat exchanger high *)
	xGR_MAXR_T_PlateHE_LimHiHi(In:= IN_EX.tT_PlateHE.Ai, Gw:= Para.rT_PlateHE_LimHiHi, Hy:= Para.rT_PlateHE_HyHi);
	
	xMsg1104.Enable	   := Para.bT_PlateHE_Active;
	xMsg1104.Set 	   := xGR_MAXR_T_PlateHE_LimHiHi.Q AND IN_EX.tPB2MM.bParaSetupOk AND NOT MM2VIS.bMsg2113;
	xMsg1104.PT		   := T#2s;
	xMsg1104.Prio 	   := 3;
	xMsg1104.RiskClass := 4;
	xMsg1104.Reset     := FALSE;
	xMsg1104();
	MM2VIS.bMsg1104    := xMsg1104.Q;

	
	(* A1106 plate temperature heat exchanger signal failure(--> W2113) *)
	xMsg1106.Enable	   := Para.bT_PlateHE_Active AND FALSE;
	xMsg1106.Set 	   := NOT IN_EX.tT_PlateHE.GoodQual;
	xMsg1106.PT		   := T#0s;
	xMsg1106.Prio 	   := 3;
	xMsg1106.RiskClass := 4;
	xMsg1106.Reset     := FALSE;
	xMsg1106();
	MM2VIS.bMsg1106    := xMsg1106.Q;	


	(* W1161 exhaust gas temperature before catalyst signal failure *) (* Disabled - OXIcat *)
	xMsg1161.Enable	   := FALSE;
	xMsg1161.Set 	   := FALSE;
	xMsg1161.PT		   := T#0s;
	xMsg1161.Prio 	   := 4;
	xMsg1161.RiskClass := 4;
	xMsg1161.Reset     := FALSE;
	xMsg1161();
	MM2VIS.bMsg1161    := xMsg1161.Q;  
	
	
	(* W1162 exhaust gas temperature after catalyst signal failure *) (* Disabled - OXIcat *)
	xMsg1162.Enable	   := FALSE;
	xMsg1162.Set 	   := FALSE;
	xMsg1162.PT		   := T#0s;
	xMsg1162.Prio 	   := 4;
	xMsg1162.RiskClass := 4;
	xMsg1162.Reset     := FALSE;
	xMsg1162();
	MM2VIS.bMsg1162    := xMsg1162.Q;  

	
	(* W1163 (A2322) exhaust gas temperature after turbo charger signal failure *)
	xMsg1163.Enable	   := Para.bT_EGaTC_Active AND IN_EX.tPB2MM.bParaSetupOk;
	xMsg1163.Set 	   := NOT IN_EX.tT_EGaTC.GoodQual AND NOT Para.bT_EGaLPTC_HiTrip;
	xMsg1163.PT		   := T#0s;
	xMsg1163.Prio 	   := 4;
	xMsg1163.RiskClass := 4;
	xMsg1163.Reset     := FALSE;
	xMsg1163();
	MM2VIS.bMsg1163    := xMsg1163.Q;  	

	
	(* W1164 exhaust gas temperature after heat exchanger signal failure *)
	xMsg1164.Enable	   := Para.bT_EGaHE_Active AND IN_EX.tPB2MM.bParaSetupOk;
	xMsg1164.Set 	   := NOT IN_EX.tT_EGaHE.GoodQual;
	xMsg1164.PT		   := T#0s;
	xMsg1164.Prio 	   := 4;
	xMsg1164.RiskClass := 4;
	xMsg1164.Reset     := FALSE;
	xMsg1164();
	MM2VIS.bMsg1164    := xMsg1164.Q;

	
   (* W1165 exhaust gas scavenging fan failure (A3366) *)
	xTOF_EngDemEPS(IN:= IN_EX.bEng_Dem_EPS AND NOT IN_EX.tGCB_On.Di, PT:= T#60s);
	bNoMon4BlackStart := xTOF_EngDemEPS.Q AND IN_EX.bEng_Dem_EPS; //T14

	xMsg1165.Enable	   := xEngType.Type9;//SWAT920/5
	xMsg1165.Set 	   :=	OUT_EX.tScavFanCoOn.Do
					AND NOT bNoMon4BlackStart
					AND(   (NOT xEngType.Type9 AND NOT IN_EX.tScavFanOp.Di AND NOT NoScavFan)
						OR (    xEngType.Type9 AND    (IN_EX.tScavFanFC_P_Lo.Di OR NOT IN_EX.tScavFanFC_Rdy.Di)));		                              
	xMsg1165.PT		   := T#10s;
	xMsg1165.Prio 	   := 4;
	xMsg1165.RiskClass := 4;
	xMsg1165.Reset     := FALSE;
	xMsg1165();
	MM2VIS.bMsg1165	   := xMsg1165.Q;
	OUT_EX.bMsg1165	   := xMsg1165.Q;//SWAT920/5

	
	(* W1169 exhaust gas temperature before catalyst high *) (* Disabled - OXIcat *)
	xMsg1169.Enable	   := FALSE;
	xMsg1169.Set 	   := FALSE;
	xMsg1169.PT		   := T#2s;
	xMsg1169.Prio 	   := 4;
	xMsg1169.RiskClass := 4;
	xMsg1169.Reset     := FALSE;
	xMsg1169();
	MM2VIS.bMsg1169    := xMsg1169.Q;  	

	
	(* W1170 exhaust gas temperature after catalyst high *) (* Disabled - OXIcat *)
	xMsg1170.Enable	   := FALSE;
	xMsg1170.Set 	   := FALSE;
	xMsg1170.PT		   := T#2s;
	xMsg1170.Prio 	   := 4;
	xMsg1170.RiskClass := 4;
	xMsg1170.Reset     := FALSE;
	xMsg1170();
	MM2VIS.bMsg1170    := xMsg1170.Q;  	

	
	(* W1171 (A2321) exhaust gas temperature after turbo charger high *)
	xGR_MAXR_T_EGaTC_LimHi(In:= IN_EX.tT_EGaTC.Ai, Gw:= Para.rT_EGaTC_LimHi, Hy:= 5.0);
	
	xMsg1171.Enable	   := Para.bT_EGaTC_Active;
	xMsg1171.Set 	   := xGR_MAXR_T_EGaTC_LimHi.Q AND IN_EX.tPB2MM.bParaSetupOk AND NOT MM2VIS.bMsg1163 AND NOT MM2VIS.bMsg2322;
	xMsg1171.PT		   := T#2s;
	xMsg1171.Prio 	   := 4;
	xMsg1171.RiskClass := 4;
	xMsg1171.Reset     := FALSE;
	xMsg1171();
	MM2VIS.bMsg1171    := xMsg1171.Q;  


	(* W1172 exhaust gas temperature after heat exchanger high *)
	xGR_MAXR_T_EGaHE_LimHi(In:= IN_EX.tT_EGaHE.Ai, Gw:= Para.rT_EGaHE_LimHi, Hy:= Para.rT_EGaHE_HyHi);
	
	xMsg1172.Enable	   := Para.bT_EGaHE_Active;
	xMsg1172.Set 	   := xGR_MAXR_T_EGaHE_LimHi.Q AND IN_EX.tPB2MM.bParaSetupOk AND NOT MM2VIS.bMsg1164
					  AND OUT_EX.bEG_BoVaOpened AND IN_EX.tEng_Run.Do;
	xMsg1172.PT		   := T#120s;
	xMsg1172.Prio 	   := 4;
	xMsg1172.RiskClass := 4;
	xMsg1172.Reset     := FALSE;
	xMsg1172();
	MM2VIS.bMsg1172    := xMsg1172.Q;  
	
	
	(* W1173 plate temperature heat exchanger high *)
	xGR_MAXR_T_PlateHE_LimHi(In:= IN_EX.tT_PlateHE.Ai, Gw:= Para.rT_PlateHE_LimHi, Hy:= Para.rT_PlateHE_HyHi);
	
	xMsg1173.Enable	   := Para.bT_PlateHE_Active;
	xMsg1173.Set 	   := xGR_MAXR_T_PlateHE_LimHi.Q AND IN_EX.tPB2MM.bParaSetupOk AND NOT MM2VIS.bMsg2113;
	xMsg1173.PT		   := T#2s;
	xMsg1173.Prio 	   := 4;
	xMsg1173.RiskClass := 4;
	xMsg1173.Reset     := FALSE;
	xMsg1173();
	MM2VIS.bMsg1173    := xMsg1173.Q;


	(* W1174 catalyst temperatur high (A1045) *) (* Disabled - OXIcat *)
	xMsg1174.Enable	   := FALSE;
	xMsg1174.Set 	   := FALSE;
	xMsg1174.PT		   := T#2s;
	xMsg1174.Prio 	   := 4;
	xMsg1174.RiskClass := 4;
	xMsg1174.Reset     := FALSE;
	xMsg1174();
	MM2VIS.bMsg1174    := xMsg1174.Q;

	
	(* W2098 exhaust gas flap failure *)
	IF Para.bSel_EGVa_Combi THEN
		xTON_2098a(IN:= (NOT IN_EX.tEG_ByVaOpened.Di AND NOT IN_EX.tEG_ByVaClosed.Di AND(B_BKAUF OR B_BKZU)), PT:= T#35s);
	ELSE
		xTON_2098a(IN:= (NOT IN_EX.tEG_ByVaOpened.Di AND NOT IN_EX.tEG_ByVaClosed.Di AND(B_BKAUF OR B_BKZU))
					 OR (NOT IN_EX.tEG_BoVaOpened.Di AND NOT IN_EX.tEG_BoVaClosed.Di AND(B_KKAUF OR B_KKZU)), PT:= T#35s);
	END_IF;
	xTON_2098b(IN:=  NOT IN_EX.tEG_BoVaFailure.Di OR NOT IN_EX.tEG_ByVaFailure.Di, PT:= T#2s);	
	
	xMsg2098.Enable	   := TRUE;
	xMsg2098.Set 	   := xTON_2098a.Q OR xTON_2098b.Q OR (NOT Para.bSel_EGVa_Combi AND NOT IN_EX.tEG_ByVaOpened.Di AND NOT IN_EX.tEG_BoVaOpened.Di);
	xMsg2098.PT		   := T#0s;
	xMsg2098.Prio 	   := 4;
	xMsg2098.RiskClass := 4;
	xMsg2098.Reset     := FALSE;
	xMsg2098();
	MM2VIS.bMsg2098    := xMsg2098.Q; 


	(* W2112 catalyst temperature signal failure (A1069) *) (* Disabled - OXIcat *)
	xMsg2112.Enable	   := FALSE;
	xMsg2112.Set 	   := FALSE;
	xMsg2112.PT		   := T#0s;
	xMsg2112.Prio 	   := 4;
	xMsg2112.RiskClass := 4;
	xMsg2112.Reset     := FALSE;
	xMsg2112();
	MM2VIS.bMsg2112    := xMsg2112.Q;

	
	(* W2113 plate temperature heat exchanger signal failure (A1106) *)
	xMsg2113.Enable	   := Para.bT_PlateHE_Active;
	xMsg2113.Set 	   := NOT IN_EX.tT_PlateHE.GoodQual;
	xMsg2113.PT		   := T#0s;
	xMsg2113.Prio 	   := 4;
	xMsg2113.RiskClass := 4;
	xMsg2113.Reset     := FALSE;
	xMsg2113();
	MM2VIS.bMsg2113    := xMsg2113.Q;	

	(* A2310 (W2546) exhaust gas temperature after low pressure turbo charger A high *)(* M.02-TI-168, M.02-TI-001 *)
	xMsg2310.Enable	   := Para.bT_EGaLPTC_A_Active AND Para.bT_EGaLPTC_HiTrip;
	xMsg2310.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND (IN_EX.tT_EGaLPTC_A.Ai > Para.rT_EGaTC_LimHiHi) AND NOT MM2VIS.bMsg2312;
	xMsg2310.PT		   := Para.tiEGaTC_LimHiHi;
	xMsg2310.Prio 	   := 2;
	xMsg2310.RiskClass := 4;
	xMsg2310.Reset     := FALSE;
	xMsg2310();
	MM2VIS.bMsg2310    := xMsg2310.Q;  
	
	(* A2311 (W2547) exhaust gas temperature after low pressure turbo charger B high *)(* M.02-TI-268, M.02-TI-002 *)
	xMsg2311.Enable	   := Para.bT_EGaLPTC_B_Active AND Para.bT_EGaLPTC_HiTrip;
	xMsg2311.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND (IN_EX.tT_EGaLPTC_B.Ai > Para.rT_EGaTC_LimHiHi) AND NOT MM2VIS.bMsg2313;
	xMsg2311.PT		   := Para.tiEGaTC_LimHiHi;
	xMsg2311.Prio 	   := 2;
	xMsg2311.RiskClass := 4;
	xMsg2311.Reset     := FALSE;
	xMsg2311();
	MM2VIS.bMsg2311    := xMsg2311.Q;  
	
	(* A2312 (W2549) exhaust gas temperature after low pressure turbo charger A signal failure *)(* M.02-TI-168, M.02-TI-001 *)
	xMsg2312.Enable	   := Para.bT_EGaLPTC_A_Active AND Para.bT_EGaLPTC_HiTrip;
	xMsg2312.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaLPTC_A.GoodQual;
	xMsg2312.PT		   := T#0s;
	xMsg2312.Prio 	   := 2;
	xMsg2312.RiskClass := 4;
	xMsg2312.Reset     := FALSE;
	xMsg2312();
	MM2VIS.bMsg2312    := xMsg2312.Q;  
	
	(* A2313 (W2551) exhaust gas temperature after low pressure turbo charger B signal failure *)(* M.02-TI-268, M.02-TI-002 *)
	xMsg2313.Enable	   := Para.bT_EGaLPTC_B_Active AND Para.bT_EGaLPTC_HiTrip;
	xMsg2313.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaLPTC_B.GoodQual;
	xMsg2313.PT		   := T#0s;
	xMsg2313.Prio 	   := 2;
	xMsg2313.RiskClass := 4;
	xMsg2313.Reset     := FALSE;
	xMsg2313();
	MM2VIS.bMsg2313    := xMsg2313.Q;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	
	(* A2315 air temperature before exhaust gas scavening valve maximum *)
	xMsg2315.Enable	   := Para.bT_bScavValve_Active;
	xMsg2315.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND  IN_EX.tT_bScavValve.GoodQual
													AND (IN_EX.rN_EngAct > 0)
													AND (IN_EX.tT_bScavValve.Ai > Para.rT_bScavValve_LimHi);
	xMsg2315.PT		   := T#2s;
	xMsg2315.Prio 	   := 2;
	xMsg2315.RiskClass := 10;
	xMsg2315.Reset     := FALSE;
	xMsg2315();
	MM2VIS.bMsg2315    := xMsg2315.Q;  
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	(* A2319 OXIcat Outlet temperature measurement signal failure *)(* W9310 *)
	xMsg2319.Enable	   := Para.bOXIcat_Exist 
					  AND Para.bT_OXIcat_Out_Exist
					  AND FALSE;
	xMsg2319.Set 	   := NOT IN_EX.tT_EGaCat.GoodQual
					  AND (IN_EX.rN_EngAct > 0);
	xMsg2319.PT		   := T#2s;
	xMsg2319.Prio 	   := 3;
	xMsg2319.RiskClass := 4;
	xMsg2319.Reset     := FALSE;
	xMsg2319();
	MM2VIS.bMsg2319    := xMsg2319.Q;  
	
	
	(* A2320 OXIcat Outlet temperature maximum *)
	xMsg2320.Enable	   := Para.bOXIcat_Exist 
					  AND Para.bT_OXIcat_Out_Exist;
	xMsg2320.Set 	   := IN_EX.tT_EGaCat.Ai >= Para.rT_OXIcat_Out_HiHi
					  AND (IN_EX.rN_EngAct > 0)
					  AND IN_EX.tT_EGaCat.GoodQual;
	xMsg2320.PT		   := T#1s;
	xMsg2320.Prio 	   := 2;
	xMsg2320.RiskClass := 4;
	xMsg2320.Reset     := FALSE;
	xMsg2320();
	MM2VIS.bMsg2320    := xMsg2320.Q;

	(* A2321 (W1171) exhaust gas temperature after turbo charger high *)(* M.02-TI-001 *)
	xMsg2321.Enable	   := Para.bT_EGaTC_Active AND Para.bT_EGaLPTC_HiTrip;
	xMsg2321.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND (IN_EX.tT_EGaTC.Ai > Para.rT_EGaTC_LimHiHi) AND NOT MM2VIS.bMsg2322;
	xMsg2321.PT		   := Para.tiEGaTC_LimHiHi;
	xMsg2321.Prio 	   := 2;
	xMsg2321.RiskClass := 4;
	xMsg2321.Reset     := FALSE;
	xMsg2321();
	MM2VIS.bMsg2321    := xMsg2321.Q;  
	
	(* A2322 (W1163) exhaust gas temperature after turbo charger signal failure *)(* M.02-TI-001 *)
	xMsg2322.Enable	   := Para.bT_EGaTC_Active AND Para.bT_EGaLPTC_HiTrip;
	xMsg2322.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaTC.GoodQual;
	xMsg2322.PT		   := T#0s;
	xMsg2322.Prio 	   := 2;
	xMsg2322.RiskClass := 4;
	xMsg2322.Reset     := FALSE;
	xMsg2322();
	MM2VIS.bMsg2322    := xMsg2322.Q;  

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	
	(* A2337 (W9305) temperature high exhaust gas pressure relief valve 1 *)(* P.02-TI-039 *)
	xMsg2337.Enable	   := Para.bT_EG_PrReliefVa1_Active;
	xMsg2337.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND(IN_EX.tT_EG_PrReliefVa1.Ai > Para.rT_EG_PrReliefVa_LimHiHi) AND NOT MM2VIS.bMsg9307;
	xMsg2337.PT		   := T#2s;
	xMsg2337.Prio 	   := 3;
	xMsg2337.RiskClass := 10;
	xMsg2337.Reset     := FALSE;
	xMsg2337();
	MM2VIS.bMsg2337    := xMsg2337.Q;

	(* A2338 (W9306) temperature high exhaust gas pressure relief valve 2 *)(* P.02-TI-040 *)
	xMsg2338.Enable	   := Para.bT_EG_PrReliefVa2_Active;
	xMsg2338.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND(IN_EX.tT_EG_PrReliefVa2.Ai > Para.rT_EG_PrReliefVa_LimHiHi) AND NOT MM2VIS.bMsg9308;
	xMsg2338.PT		   := T#2s;
	xMsg2338.Prio 	   := 3;
	xMsg2338.RiskClass := 10;
	xMsg2338.Reset     := FALSE;
	xMsg2338();
	MM2VIS.bMsg2338    := xMsg2338.Q;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	(* A2340 Exhaust gas pressure fast maximum (W2498) *)
	xMsg2340.Enable	   := Para.bPr_OXIcat_In_Fast_Exist;	
	xMsg2340.Set 	   := bPr_EG_Deflag_Fast
					  AND NOT xTOF_Pr_EG_Deflag_Fast.Q
					  AND ((IN_EX.rN_EngAct > 0) OR IN_EX.bEng_Start) // Prevents continuous setting of the alarm, while bPr_EG_Deflag_Fast remains active
					  AND NOT MM2VIS.bMsg9249;
	xMsg2340.PT		   := T#0s;
	xMsg2340.Prio 	   := 2;
	xMsg2340.RiskClass := 4;
	xMsg2340.Reset     := FALSE;
	xMsg2340();
	MM2VIS.bMsg2340    := xMsg2340.Q;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)

	(* A2374 Bursting disc triggered (P.02-GS-001/P.02-GS-002)*)
	xMsg2374.Enable	   := IN_EX.tPB2MM.bParaSetupOk;	
	xMsg2374.Set 	   := NOT IN_EX.tBurstingDisk1_Ok.Di
					   OR NOT IN_EX.tBurstingDisk2_Ok.Di;
	xMsg2374.PT		   := T#0s;
	xMsg2374.Prio 	   := 2;
	xMsg2374.RiskClass := 10;
	xMsg2374.Reset     := FALSE;
	xMsg2374();
	MM2VIS.bMsg2374    := xMsg2374.Q;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	(* W2468 air temperature before exhaust gas scavening valve signal failure *)
	xMsg2468.Enable	   := Para.bT_bScavValve_Active;
	xMsg2468.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_bScavValve.GoodQual;
	xMsg2468.PT		   := T#0s;
	xMsg2468.Prio 	   := 4;
	xMsg2468.RiskClass := 4;
	xMsg2468.Reset     := FALSE;
	xMsg2468();
	MM2VIS.bMsg2468    := xMsg2468.Q;  
	
	
	(* W2469 air temperature before exhaust gas scavening valve plausibility check *)
	xMsg2469.Enable	   := Para.bT_bScavValve_Active AND FALSE;//SWAT920/5
	xMsg2469.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND bT_bScavValve_PcheckFail;
	xMsg2469.PT		   := T#0s;
	xMsg2469.Prio 	   := 4;
	xMsg2469.RiskClass := 4;
	xMsg2469.Reset     := FALSE;
	xMsg2469();
	MM2VIS.bMsg2469    := xMsg2469.Q;


	(* W2494 OXIcat Inlet pressure measurement signal failure *)
	xMsg2494.Enable	   := Para.bOXIcat_Exist 
					  AND Para.bPr_OXIcat_In_Exist;
	xMsg2494.Set 	   := NOT IN_EX.tPr_OXIcat_In.GoodQual
					  AND (IN_EX.rP_Act_Norm_Filt >= 0.50);
	xMsg2494.PT		   := T#60s;
	xMsg2494.Prio 	   := 4;
	xMsg2494.RiskClass := 4;
	xMsg2494.Reset     := FALSE;
	xMsg2494();
	MM2VIS.bMsg2494    := xMsg2494.Q;  
	
	
	(* W2495 OXIcat Outlet pressure measurement signal failure *)
	xMsg2495.Enable	   := Para.bOXIcat_Exist 
					  AND Para.bPr_OXIcat_Out_Exist;
	xMsg2495.Set 	   := NOT IN_EX.tPr_OXIcat_Out.GoodQual
					  AND (IN_EX.rP_Act_Norm_Filt >= 0.50);
	xMsg2495.PT		   := T#60s;
	xMsg2495.Prio 	   := 4;
	xMsg2495.RiskClass := 4;
	xMsg2495.Reset     := FALSE;
	xMsg2495();
	MM2VIS.bMsg2495    := xMsg2495.Q;  
	
	
	(* W2496 OXIcat Differential pressure minimum *)
	xMsg2496.Enable	   := Para.bOXIcat_Exist 
					  AND Para.bPr_OXIcat_In_Exist
					  AND Para.bPr_OXIcat_Out_Exist;
	xMsg2496.Set 	   := MM2VIS.rPr_OXIcat_Diff <= Para.rPR_OXIcat_Diff_Hi
					  AND (IN_EX.rP_Act_Norm_Filt >= 0.50)
					  AND IN_EX.tPr_OXIcat_In.GoodQual
					  AND IN_EX.tPr_OXIcat_Out.GoodQual;
	xMsg2496.PT		   := T#60s;
	xMsg2496.Prio 	   := 4;
	xMsg2496.RiskClass := 4;
	xMsg2496.Reset     := FALSE;
	xMsg2496();
	MM2VIS.bMsg2496    := xMsg2496.Q;  
	
	
	(* W2497 OXIcat Exhaust gas inlet pressure fast measurement signal failure *)
	xMsg2497.Enable	   := FALSE;	(*v4.07*)
	xMsg2497.Set 	   := FALSE;
	xMsg2497.PT		   := T#60s;
	xMsg2497.Prio 	   := 4;
	xMsg2497.RiskClass := 4;
	xMsg2497.Reset     := FALSE;
	xMsg2497();
	MM2VIS.bMsg2497    := xMsg2497.Q;  
	
	
	(* W2498 OXIcat Exhaust gas inlet pressure fast maximum *)
	xMsg2498.Enable	   := FALSE;	(*v4.07*)
	xMsg2498.Set 	   := FALSE;
	xMsg2498.PT		   := T#0s;
	xMsg2498.Prio 	   := 4;
	xMsg2498.RiskClass := 4;
	xMsg2498.Reset     := FALSE;
	xMsg2498();
	MM2VIS.bMsg2498    := xMsg2498.Q;  
	
	
	(* W2499 OXIcat Inlet temperature measurement signal *)
	xMsg2499.Enable	   := Para.bOXIcat_Exist 
					  AND Para.bT_OXIcat_In_Exist;
	xMsg2499.Set 	   := NOT IN_EX.tT_EGbCat.GoodQual
					  AND (IN_EX.rN_EngAct > 0);
	xMsg2499.PT		   := T#60s;
	xMsg2499.Prio 	   := 4;
	xMsg2499.RiskClass := 4;
	xMsg2499.Reset     := FALSE;
	xMsg2499();
	MM2VIS.bMsg2499    := xMsg2499.Q;  
	
	
	(* W2500 OXIcat Inlet temperature high *)
	xMsg2500.Enable	   := Para.bOXIcat_Exist 
					  AND Para.bT_OXIcat_In_Exist;
	xMsg2500.Set 	   := IN_EX.tT_EGbCat.Ai >= Para.rT_OXIcat_In_Hi
					  AND (IN_EX.rN_EngAct > 0)
					  AND IN_EX.tT_EGbCat.GoodQual;
	xMsg2500.PT		   := T#1s;
	xMsg2500.Prio 	   := 4;
	xMsg2500.RiskClass := 4;
	xMsg2500.Reset     := FALSE;
	xMsg2500();
	MM2VIS.bMsg2500    := xMsg2500.Q;
	
	
	(* W2546 (A2310) exhaust gas temperature after low pressure turbo charger A high *)(* M.02-TI-168, M.02-TI-001 *)
	xGR_MAXR_T_EGaLPTC_A_LimHi(In:= IN_EX.tT_EGaLPTC_A.Ai, Gw:= Para.rT_EGaTC_LimHi, Hy:= 5.0);
	
	xMsg2546.Enable	   := Para.bT_EGaLPTC_A_Active;
	xMsg2546.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND xGR_MAXR_T_EGaLPTC_A_LimHi.Q AND Para.bT_EGaLPTC_A_Active AND NOT MM2VIS.bMsg2549 AND NOT MM2VIS.bMsg2312;
	xMsg2546.PT		   := T#2s;
	xMsg2546.Prio 	   := 4;
	xMsg2546.RiskClass := 4;
	xMsg2546.Reset     := FALSE;
	xMsg2546();
	MM2VIS.bMsg2546    := xMsg2546.Q;  

	
	(* W2547 (A2311) exhaust gas temperature after low pressure turbo charger B high *)(* M.02-TI-268, M.02-TI-002 *)
	xGR_MAXR_T_EGaLPTC_B_LimHi(In:= IN_EX.tT_EGaLPTC_B.Ai, Gw:= Para.rT_EGaTC_LimHi, Hy:= 5.0);

	xMsg2547.Enable	   := Para.bT_EGaLPTC_B_Active;
	xMsg2547.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND xGR_MAXR_T_EGaLPTC_B_LimHi.Q AND Para.bT_EGaLPTC_B_Active AND NOT MM2VIS.bMsg2551 AND NOT MM2VIS.bMsg2313;
	xMsg2547.PT		   := T#2s;
	xMsg2547.Prio 	   := 4;
	xMsg2547.RiskClass := 4;
	xMsg2547.Reset     := FALSE;
	xMsg2547();
	MM2VIS.bMsg2547    := xMsg2547.Q;  

	
	(* W2549 exhaust gas temperature after low pressure turbo charger A signal failure *)(* M.02-TI-168, M.02-TI-001 *)
	xMsg2549.Enable	   := Para.bT_EGaLPTC_A_Active AND NOT Para.bT_EGaLPTC_HiTrip;
	xMsg2549.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaLPTC_A.GoodQual;
	xMsg2549.PT		   := T#0s;
	xMsg2549.Prio 	   := 4;
	xMsg2549.RiskClass := 4;
	xMsg2549.Reset     := FALSE;
	xMsg2549();
	MM2VIS.bMsg2549    := xMsg2549.Q;  

	
	(* W2551 exhaust gas temperature after low pressure turbo charger B signal failure *)(* M.02-TI-268, M.02-TI-002 *)
	xMsg2551.Enable	   := Para.bT_EGaLPTC_B_Active AND NOT Para.bT_EGaLPTC_HiTrip;
	xMsg2551.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaLPTC_B.GoodQual;
	xMsg2551.PT		   := T#0s;
	xMsg2551.Prio 	   := 4;
	xMsg2551.RiskClass := 4;
	xMsg2551.Reset     := FALSE;
	xMsg2551();
	MM2VIS.bMsg2551    := xMsg2551.Q;

	
	(* W2601 exhaust gas scavenging fan circuit breaker tripped *)
	xMsg2601.Enable	   := TRUE;
	xMsg2601.Set 	   := NOT IN_EX.tScavFanCB_trip.Di;
	xMsg2601.PT		   := T#0s;
	xMsg2601.Prio 	   := 4;
	xMsg2601.RiskClass := 4;
	xMsg2601.Reset     := FALSE;
	xMsg2601();
	MM2VIS.bMsg2601    := xMsg2601.Q;  


	(* W2622 exhaust gas temperature high after low pressure turbo charger *)
	xMsg2622.Enable	   := TRUE;
	xMsg2622.Set 	   := FALSE;	(* 424tstc have to be specified *)
	xMsg2622.PT		   := T#0s;
	xMsg2622.Prio 	   := 4;
	xMsg2622.RiskClass := 4;
	xMsg2622.Reset     := FALSE;
	xMsg2622();
	MM2VIS.bMsg2622    := xMsg2622.Q;  


	(* W2623 signal failure exhaust gas temperature after low pressure turbo charger *)
	xMsg2623.Enable	   := TRUE;
	xMsg2623.Set 	   := FALSE;	(* 424tstc have to be specified *)
	xMsg2623.PT		   := T#0s;
	xMsg2623.Prio 	   := 4;
	xMsg2623.RiskClass := 4;
	xMsg2623.Reset     := FALSE;
	xMsg2623();
	MM2VIS.bMsg2623    := xMsg2623.Q;  


	(* W2655 signal failure exhaust gas temperature before high-pressure turbocharger A (M.02-TI-166)*)
	xMsg2655.Enable	   := Para.bT_EGbHPTC_A_Active;
	xMsg2655.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGbHPTC_A.GoodQual;
	xMsg2655.PT		   := T#0s;
	xMsg2655.Prio 	   := 4;
	xMsg2655.RiskClass := 4;
	xMsg2655.Reset     := FALSE;
	xMsg2655();
	MM2VIS.bMsg2655    := xMsg2655.Q;  


	(* W2656 signal failure exhaust gas temperature before high-pressure turbocharger B (M.02-TI-266)*)
	xMsg2656.Enable	   := Para.bT_EGbHPTC_B_Active;
	xMsg2656.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGbHPTC_B.GoodQual;
	xMsg2656.PT		   := T#0s;
	xMsg2656.Prio 	   := 4;
	xMsg2656.RiskClass := 4;
	xMsg2656.Reset     := FALSE;
	xMsg2656();
	MM2VIS.bMsg2656    := xMsg2656.Q;  


	(* W2657 signal failure exhaust gas temperatur after high-pressure turbocharger A (M.02-TI-167)*)
	xMsg2657.Enable	   := Para.bT_EGaHPTC_A_Active;
	xMsg2657.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaHPTC_A.GoodQual;
	xMsg2657.PT		   := T#0s;
	xMsg2657.Prio 	   := 4;
	xMsg2657.RiskClass := 4;
	xMsg2657.Reset     := FALSE;
	xMsg2657();
	MM2VIS.bMsg2657    := xMsg2657.Q;  


	(* W2658 signal failure exhaust gas temperatur after high-pressure turbocharger B (M.02-TI-267)*)
	xMsg2658.Enable	   := Para.bT_EGaHPTC_B_Active;
	xMsg2658.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaHPTC_B.GoodQual;
	xMsg2658.PT		   := T#0s;
	xMsg2658.Prio 	   := 4;
	xMsg2658.RiskClass := 4;
	xMsg2658.Reset     := FALSE;
	xMsg2658();
	MM2VIS.bMsg2658    := xMsg2658.Q;  


	(* W2659 signal failure exhaust gas pressure before high-pressure turbocharger A (M.02-PI-152)*)
	xMsg2659.Enable	   := Para.bPr_EGbHPTC_A_Active;
	xMsg2659.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tPr_EGbHPTC_A.GoodQual;
	xMsg2659.PT		   := T#0s;
	xMsg2659.Prio 	   := 4;
	xMsg2659.RiskClass := 4;
	xMsg2659.Reset     := FALSE;
	xMsg2659();
	MM2VIS.bMsg2659    := xMsg2659.Q;  


	(* W2660 exhaust gas pressure before high-pressure turbocharger B (M.02-PI-252)*)
	xMsg2660.Enable	   := Para.bPr_EGbHPTC_B_Active;
	xMsg2660.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tPr_EGbHPTC_B.GoodQual;
	xMsg2660.PT		   := T#0s;
	xMsg2660.Prio 	   := 4;
	xMsg2660.RiskClass := 4;
	xMsg2660.Reset     := FALSE;
	xMsg2660();
	MM2VIS.bMsg2660    := xMsg2660.Q;  


  	(* W2661 exhaust gas pressure after high-pressure turbocharger A (M.02-PI-153)*)
   	xMsg2661.Enable	   := Para.bPr_EGaHPTC_A_Active;
	xMsg2661.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tPr_EGaHPTC_A.GoodQual;
	xMsg2661.PT		   := T#0s;
	xMsg2661.Prio 	   := 4;
	xMsg2661.RiskClass := 4;
	xMsg2661.Reset     := FALSE;
	xMsg2661();
	MM2VIS.bMsg2661    := xMsg2661.Q;  


  	(* W2662 exhaust gas pressure after high-pressure turbocharger B (M.02-PI-253)*)
   	xMsg2662.Enable	   := Para.bPr_EGaHPTC_B_Active;
	xMsg2662.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tPr_EGaHPTC_B.GoodQual;
	xMsg2662.PT		   := T#0s;
	xMsg2662.Prio 	   := 4;
	xMsg2662.RiskClass := 4;
	xMsg2662.Reset     := FALSE;
	xMsg2662();
	MM2VIS.bMsg2662    := xMsg2662.Q;  


   	(* W2663 signal failure exhaust gas pressure after low-pressure turbocharger A (M.02-PI-154)*)
   	xMsg2663.Enable	   := Para.bPr_EGaLPTC_A_Active;
	xMsg2663.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tPr_EGaLPTC_A.GoodQual;
	xMsg2663.PT		   := T#0s;
	xMsg2663.Prio 	   := 4;
	xMsg2663.RiskClass := 4;
	xMsg2663.Reset     := FALSE;
	xMsg2663();
	MM2VIS.bMsg2663    := xMsg2663.Q;  


   	(* W2664 signal failure exhaust gas pressure after low-pressure turbocharger B (M.02-PI-254)*)
   	xMsg2664.Enable	   := Para.bPr_EGaLPTC_B_Active;
	xMsg2664.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tPr_EGaLPTC_B.GoodQual;
	xMsg2664.PT		   := T#0s;
	xMsg2664.Prio 	   := 4;
	xMsg2664.RiskClass := 4;
	xMsg2664.Reset     := FALSE;
	xMsg2664();
	MM2VIS.bMsg2664    := xMsg2664.Q;  


	(* W2743 meassuring signal failure differential pressure exhaust gas filter *)
	xMsg2743.Enable	   := Para.bPr_Diff_ExGFilter_Active;
	xMsg2743.Set 	   := NOT IN_EX.tPr_Diff_ExGFilter.GoodQual;
	xMsg2743.PT		   := T#0s;
	xMsg2743.Prio 	   := 4;
	xMsg2743.RiskClass := 4;
	xMsg2743.Reset     := FALSE;
	xMsg2743();
	MM2VIS.bMsg2743    := xMsg2743.Q;	


	(* W2744 meassuring signal failure differential pressure exhaust gas cooler *)
	xMsg2744.Enable	   := Para.bPr_Diff_ExGCooler_Active;
	xMsg2744.Set 	   := NOT IN_EX.tPr_Diff_ExGCooler.GoodQual;
	xMsg2744.PT		   := T#0s;
	xMsg2744.Prio 	   := 4;
	xMsg2744.RiskClass := 4;
	xMsg2744.Reset     := FALSE;
	xMsg2744();
	MM2VIS.bMsg2744    := xMsg2744.Q;	

	
	(* W2745 differential pressure exhaust gas ffilter maximum 1 *)
	xGR_MAXR_Pr_Diff_ExGFil_LimHi1(In:= IN_EX.tPr_Diff_ExGFilter.Ai, Gw:= Para.rPr_Diff_ExGFilter_Hi1, Hy:= Para.rPr_Diff_ExGFilter_HyHi);
	
	xMsg2745.Enable	   := Para.bPr_Diff_ExGFilter_Active;
	xMsg2745.Set 	   := xGR_MAXR_Pr_Diff_ExGFil_LimHi1.Q AND NOT MM2VIS.bMsg2743;
	xMsg2745.PT		   := T#2s;
	xMsg2745.Prio 	   := 4;
	xMsg2745.RiskClass := 4;
	xMsg2745.Reset     := FALSE;
	xMsg2745();
	MM2VIS.bMsg2745    := xMsg2745.Q;  

	
	(* W2746 differential pressure exhaust gas ffilter maximum 2 *)
	xGR_MAXR_Pr_Diff_ExGFil_LimHi2(In:= IN_EX.tPr_Diff_ExGFilter.Ai, Gw:= Para.rPr_Diff_ExGFilter_Hi2, Hy:= Para.rPr_Diff_ExGFilter_HyHi);
	
	xMsg2746.Enable	   := Para.bPr_Diff_ExGFilter_Active;
	xMsg2746.Set 	   := xGR_MAXR_Pr_Diff_ExGFil_LimHi2.Q AND NOT MM2VIS.bMsg2743;
	xMsg2746.PT		   := T#2s;
	xMsg2746.Prio 	   := 4;
	xMsg2746.RiskClass := 4;
	xMsg2746.Reset     := FALSE;
	xMsg2746();
	MM2VIS.bMsg2746    := xMsg2746.Q;  

	
	(* W2747 differential pressure exhaust gas ffilter minimum *)
	xGR_MINR_Pr_Diff_ExGFil_LimLo(In:= IN_EX.tPr_Diff_ExGFilter.Ai, Gw:= Para.rPr_Diff_ExGFilter_Lo, Hy:= Para.rPr_Diff_ExGFilter_HyHi);
	
	xMsg2747.Enable	   := Para.bPr_Diff_ExGFilter_Active;
	xMsg2747.Set 	   := xGR_MINR_Pr_Diff_ExGFil_LimLo.Q AND NOT MM2VIS.bMsg2743;
	xMsg2747.PT		   := T#2s;
	xMsg2747.Prio 	   := 4;
	xMsg2747.RiskClass := 4;
	xMsg2747.Reset     := FALSE;
	xMsg2747();
	MM2VIS.bMsg2747    := xMsg2747.Q;  

	
	(* W2748 differential pressure exhaust gas coller maximum *)
	xGR_MAXR_Pr_Diff_ExGCoo_LimHi(In:= IN_EX.tPr_Diff_ExGCooler.Ai, Gw:= Para.rPr_Diff_ExGCooler_Hi, Hy:= Para.rPr_Diff_ExGCooler_HyHi);
	
	xMsg2748.Enable	   := Para.bPr_Diff_ExGCooler_Active;
	xMsg2748.Set 	   := xGR_MAXR_Pr_Diff_ExGCoo_LimHi.Q AND NOT MM2VIS.bMsg2744;
	xMsg2748.PT		   := T#2s;
	xMsg2748.Prio 	   := 4;
	xMsg2748.RiskClass := 4;
	xMsg2748.Reset     := FALSE;
	xMsg2748();
	MM2VIS.bMsg2748    := xMsg2748.Q;  


	(* W2793 exhaust gas scavenging fan not ready *)
	xMsg2793.Enable	   := IN_EX.tPB2MM.bParaSetupOk;
	xMsg2793.Set 	   := NOT IN_EX.tScavFanFC_Rdy.Di;
	xMsg2793.PT		   := T#10s;
	xMsg2793.Prio 	   := 4;
	xMsg2793.RiskClass := 4;
	xMsg2793.Reset     := FALSE;
	xMsg2793();
	MM2VIS.bMsg2793    := xMsg2793.Q;


	(* A3100 exhaust gas temperature before turbo charger high *)
	xGR_MAXR_T_EGbTC_LimHiHi(In:= IN_EX.tT_EGbTC.Ai, Gw:= Para.rT_EGbTC_LimHiHi, Hy:= Para.rT_EGbTC_HyHiHi);

//	xMsg3100.Enable	   := Para.bT_EGbTC_Active AND NOT xEngType.Type9;//SWAT920/2 --> ELIMINATE SWAT MODIFICATION BACK TO OLD VERSION! 09.10.2017 TW
	xMsg3100.Enable	   := Para.bT_EGbTC_Active;
	xMsg3100.Set 	   := xGR_MAXR_T_EGbTC_LimHiHi.Q AND IN_EX.tPB2MM.bParaSetupOk AND NOT MM2VIS.bMsg3214;
//	xMsg3100.PT		   := T#2s;
	xMsg3100.PT		   := T#122s;	//SWAT920/x increase time delay from 2s to 120s! 09.10.2017 TW
	xMsg3100.Prio 	   := 3;
	xMsg3100.RiskClass := 4;
	xMsg3100.Reset     := FALSE;
	xMsg3100();
	MM2VIS.bMsg3100    := xMsg3100.Q;  

	
	(* W3214 exhaust gas temperature before turbo charger signal failure *)
	xMsg3214.Enable	   := Para.bT_EGbTC_Active;
	xMsg3214.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGbTC.GoodQual;
	xMsg3214.PT		   := T#0s;
	xMsg3214.Prio 	   := 4;
	xMsg3214.RiskClass := 4;
	xMsg3214.Reset     := FALSE;
	xMsg3214();
	MM2VIS.bMsg3214	   := xMsg3214.Q;  

	
	(* W3215 exhaust gas temperature before turbo charger high *)
	xGR_MAXR_T_EGbTC_LimHi(In:= IN_EX.tT_EGbTC.Ai, Gw:= Para.rT_EGbTC_LimHi, Hy:= Para.rT_EGbTC_HyHi);
	
	xMsg3215.Enable	   := Para.bT_EGbTC_Active;
	xMsg3215.Set 	   := xGR_MAXR_T_EGbTC_LimHi.Q AND IN_EX.tPB2MM.bParaSetupOk AND NOT MM2VIS.bMsg3214;
	xMsg3215.PT		   := T#2s;
	xMsg3215.Prio 	   := 4;
	xMsg3215.RiskClass := 4;
	xMsg3215.Reset     := FALSE;
	xMsg3215();
	MM2VIS.bMsg3215    := xMsg3215.Q;  

	
	(* A3313 CODINOX: CO2 reactor chamber temperature high *)    
	xMsg3313.Enable	   := Para.bCodinox_Active;
	xMsg3313.Set 	   := IN_EX.tT_CO2_Hi.Di;
	xMsg3313.PT		   := T#0s;
	xMsg3313.Prio 	   := 2;
	xMsg3313.RiskClass := 4;
	xMsg3313.Reset     := FALSE;
	xMsg3313();
	MM2VIS.bMsg3313    := xMsg3313.Q;  
	
	
   (* A3314 CODINOX: CO2 valve failure *)    
    xMsg3314.Enable	   := Para.bCodinox_Active;
	xMsg3314.Set 	   := CO2KLST_A;
	xMsg3314.PT		   := T#0s;
	xMsg3314.Prio 	   := 2;
	xMsg3314.RiskClass := 4;
	xMsg3314.Reset     := FALSE;
	xMsg3314();
	MM2VIS.bMsg3314    := xMsg3314.Q;  


    (* W3349 N2 gas valves position failure *)
    xMsg3349.Enable	   := Para.bSel_N2;
	xMsg3349.Set 	   := (bOMSS_MAT OR bOMSS_Scav) AND T1_STN2V;
	xMsg3349.PT		   := T#0s;
	xMsg3349.Prio 	   := 2;
	xMsg3349.RiskClass := 4;
	xMsg3349.Reset     := FALSE;
	xMsg3349();
	MM2VIS.bMsg3349    := xMsg3349.Q;
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	
	(* A3366 exhaust gas scavenging fan failure (W1165) *)
	xMsg3366.Enable	   := NOT xEngType.Type9;//SWAT920/5
	xMsg3366.Set 	   :=	OUT_EX.tScavFanCoOn.Do AND NOT IN_EX.tEng_Run.Do
					AND NOT bNoMon4BlackStart
				AND(	(NOT xEngType.Type9 AND NOT IN_EX.tScavFanOp.Di AND NOT NoScavFan)
					OR	(    xEngType.Type9 AND    (IN_EX.tScavFanFC_P_Lo.Di OR NOT IN_EX.tScavFanFC_Rdy.Di)));		                              
	xMsg3366.PT		   := T#10s;
	xMsg3366.Prio 	   := 3;
	xMsg3366.RiskClass := 10;
	xMsg3366.Reset     := FALSE;
	xMsg3366();
	MM2VIS.bMsg3366	   := xMsg3366.Q;  

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
				
	(* A3394 exhaust gas temperature after exhaust heat exchanger 1 high *) (*STM*)
	xGR_MAXR_T_EGaHE1_LimHi_Trip(In:= IN_EX.tT_EGaHE1.Ai, Gw:= Para.rT_EGaHE1_LimHi_Trip, Hy:= Para.rT_EGaHE1_HyHi_Trip);
	bT_EGaHE1_LimHi_Trip := xGR_MAXR_T_EGaHE1_LimHi_Trip.Q;
	
	xMsg3394.Enable	   := Para.bT_EGaHE1_Active;
	xMsg3394.Set 	   := bT_EGaHE1_LimHi_Trip AND NOT MM2VIS.bMsg3513; 
	xMsg3394.PT		   := T#2s;
	xMsg3394.Prio 	   := 3;
	xMsg3394.RiskClass := 4;
	xMsg3394.Reset     := FALSE;
	xMsg3394();
	MM2VIS.bMsg3394    := xMsg3394.Q;

	
	(* A3395 exhaust gas temperature after exhaust heat exchanger 2 high *) (*STM*)
	xGR_MAXR_T_EGaHE2_LimHi_Trip(In:= IN_EX.tT_EGaHE2.Ai, Gw:= Para.rT_EGaHE2_LimHi_Trip, Hy:= Para.rT_EGaHE2_HyHi_Trip);
	bT_EGaHE2_LimHi_Trip := xGR_MAXR_T_EGaHE2_LimHi_Trip.Q;
	
	xMsg3395.Enable	   := Para.bT_EGaHE2_Active;
	xMsg3395.Set 	   := bT_EGaHE2_LimHi_Trip AND NOT MM2VIS.bMsg3514; 
	xMsg3395.PT		   := T#2s;
	xMsg3395.Prio 	   := 3;
	xMsg3395.RiskClass := 4;
	xMsg3395.Reset     := FALSE;
	xMsg3395();
	MM2VIS.bMsg3395    := xMsg3395.Q;	

	
	(* A3397 differential pressure exhaust gas filter maximum *)
	xGR_MAXR_Pr_Diff_ExGFil_LimHiA(In:= IN_EX.tPr_Diff_ExGFilter.Ai, Gw:= Para.rPr_Diff_ExGFilter_Hi, Hy:= Para.rPr_Diff_ExGFilter_HyHi);
	
	xMsg3397.Enable	   := Para.bPr_Diff_ExGFilter_Active;
	xMsg3397.Set 	   := xGR_MAXR_Pr_Diff_ExGFil_LimHiA.Q AND NOT MM2VIS.bMsg2743;
	xMsg3397.PT		   := T#0s;
	xMsg3397.Prio 	   := 3;
	xMsg3397.RiskClass := 4;
	xMsg3397.Reset     := FALSE;
	xMsg3397();
	MM2VIS.bMsg3397    := xMsg3397.Q;	

	
	(* W3417 pre chamber diff.pressure high during  engine stop (exhaust gas scavenging required before next start) *)
	xTON_Pr_PC_Diff_MonRel(IN:= StopM, PT:= T#30s);
	rPr_PC_Diff := IN_EX.tPr_PC.Ai - MAX(IN_EX.tPr_Ch_P2s.Ai, MAX(IN_EX.tPr_Ch_P2s_A.Ai, IN_EX.tPr_Ch_P2s_B.Ai)); (* calc.pre chamber diff.pressure *)

	xMsg3417.Enable	   := (Para.bEGScav_Active OR Para.bSel_N2 OR xEngType.Type6)
				   AND NOT xEngType.Type9;
	xMsg3417.Set 	   := (rPr_PC_Diff > Para.rPr_PC_Diff_LimHi) AND xTON_Pr_PC_Diff_MonRel.Q AND NOT IN_EX.bMsg1078;
	xMsg3417.PT		   := T#5s;
	xMsg3417.Prio 	   := 4;
	xMsg3417.RiskClass := 4;
	xMsg3417.Reset     := FALSE;
	xMsg3417();
	MM2VIS.bMsg3417	   := xMsg3417.Q; 


	(* W3490 exhaust gas temperature after exhaust heat exchanger 1 high *) (*STM*)
	xGR_MAXR_T_EGaHE1_LimHi_Warn(In:= IN_EX.tT_EGaHE1.Ai, Gw:= Para.rT_EGaHE1_LimHi_Warn, Hy:= Para.rT_EGaHE1_HyHi_Warn);
	bT_EGaHE1_LimHi_Warn := xGR_MAXR_T_EGaHE1_LimHi_Warn.Q;
	
	xMsg3490.Enable	   := Para.bT_EGaHE1_Active;
	xMsg3490.Set 	   := bT_EGaHE1_LimHi_Warn AND NOT MM2VIS.bMsg3513; 
	xMsg3490.PT		   := T#2s;
	xMsg3490.Prio 	   := 4;
	xMsg3490.RiskClass := 4;
	xMsg3490.Reset     := FALSE;
	xMsg3490();
	MM2VIS.bMsg3490    := xMsg3490.Q;

	
	(* W3491 exhaust gas temperature after exhaust heat exchanger 2 high *) (*STM*)
	xGR_MAXR_T_EGaHE2_LimHi_Warn(In:= IN_EX.tT_EGaHE2.Ai, Gw:= Para.rT_EGaHE2_LimHi_Warn, Hy:= Para.rT_EGaHE2_HyHi_Warn);
	bT_EGaHE2_LimHi_Warn := xGR_MAXR_T_EGaHE2_LimHi_Warn.Q;
	
	xMsg3491.Enable	   := Para.bT_EGaHE2_Active;
	xMsg3491.Set 	   := bT_EGaHE2_LimHi_Warn AND NOT MM2VIS.bMsg3514; 
	xMsg3491.PT		   := T#2s;
	xMsg3491.Prio 	   := 4;
	xMsg3491.RiskClass := 4;
	xMsg3491.Reset     := FALSE;
	xMsg3491();
	MM2VIS.bMsg3491    := xMsg3491.Q;

	
	(* W3510 CODINOX: CO2 Ventilation fan failure *)    
	xMsg3510.Enable	   := Para.bCodinox_Active;
	xMsg3510.Set 	   := NOT IN_EX.tCO2_FanFailure.Di;
	xMsg3510.PT		   := T#0s;
	xMsg3510.Prio 	   := 4;
	xMsg3510.RiskClass := 4;
	xMsg3510.Reset     := TRUE;	(* autoreset customers request *)
	xMsg3510();
	MM2VIS.bMsg3510    := xMsg3510.Q;  
	
	
	(* W3511 CODINOX: CO2 station failure *)    
	xMsg3511.Enable	   := Para.bCodinox_Active;
	xMsg3511.Set 	   := NOT IN_EX.tCO2_DevFailure.Di;  
	xMsg3511.PT		   := T#0s;
	xMsg3511.Prio 	   := 4;
	xMsg3511.RiskClass := 4;
	xMsg3511.Reset     := TRUE;	(* autoreset customers request *)
	xMsg3511();
	MM2VIS.bMsg3511    := xMsg3511.Q;  
	
	
	(* W3512 CODINOX: CO2 valve failure *)    
	xMsg3512.Enable	   := Para.bCodinox_Active;
	xMsg3512.Set 	   := CO2KLST_W;
	xMsg3512.PT		   := T#0s;
	xMsg3512.Prio 	   := 4;
	xMsg3512.RiskClass := 4;
	xMsg3512.Reset     := FALSE;
	xMsg3512();
	MM2VIS.bMsg3512    := xMsg3512.Q;  
	
	
	(* W3513 CODINOX: exhaust gas temperature after heat exchanger 1 measuring signal failure *)    
	xMsg3513.Enable	   := Para.bT_EGaHE1_Active;
	xMsg3513.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaHE1.GoodQual;
	xMsg3513.PT		   := T#0s;
	xMsg3513.Prio 	   := 4;
	xMsg3513.RiskClass := 4;
	xMsg3513.Reset     := FALSE;
	xMsg3513();
	MM2VIS.bMsg3513    := xMsg3513.Q;  
	
   
	(* W3514 CODINOX: exhaust gas temperature after heat exchanger 2 measuring signal failure *)    
	xMsg3514.Enable	   := Para.bT_EGaHE2_Active;
	xMsg3514.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EGaHE2.GoodQual;
	xMsg3514.PT		   := T#0s;
	xMsg3514.Prio 	   := 4;
	xMsg3514.RiskClass := 4;
	xMsg3514.Reset     := FALSE;
	xMsg3514();
	MM2VIS.bMsg3514    := xMsg3514.Q;   

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)

	(* W3528 exhaust gas back pressure high *)
	xMsg3528.Enable	   := NOT Para.bSafe_Pr_EG_sMonActive; 						(* SAFETY PLC *)
	xMsg3528.Set 	   := NOT IN_EX.tPr_EG_Hi.Di;
	xMsg3528.PT		   := T#5s;
	xMsg3528.Prio 	   := 4;
	xMsg3528.RiskClass := 4;
	xMsg3528.Reset     := FALSE;
	xMsg3528();
	MM2VIS.bMsg3528    := xMsg3528.Q;	

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)

	(* W3580 N2 gas pressure low *)
	xMsg3580.Enable	   := Para.bSel_N2;
	xMsg3580.Set 	   := (bOMSS_MAT OR bOMSS_Scav) AND OUT_EX.bPr_N2_LoTon;
	xMsg3580.PT		   := T#0s;
	xMsg3580.Prio 	   := 4;
	xMsg3580.RiskClass := 4;
	xMsg3580.Reset     := FALSE;
	xMsg3580();
	MM2VIS.bMsg3580    := xMsg3580.Q;	


	(* W3581 N2 gas pressure high *)
	xMsg3581.Enable	   := Para.bSel_N2;
	xMsg3581.Set 	   := (bOMSS_MAT OR bOMSS_Scav) AND NOT IN_EX.tPr_N2_Hi.Di;
	xMsg3581.PT		   := T#5s;
	xMsg3581.Prio 	   := 4;
	xMsg3581.RiskClass := 4;
	xMsg3581.Reset     := FALSE;
	xMsg3581();
	MM2VIS.bMsg3581    := xMsg3581.Q;	


	(* W3582 N2 scavenging run failure *)
	xMsg3582.Enable	   := Para.bSel_N2;
	xMsg3582.Set 	   := (bOMSS_MAT OR bOMSS_Scav) AND (T1_SCAV_RUN OR T2_SCAV_RUN);
	xMsg3582.PT		   := T#0s;
	xMsg3582.Prio 	   := 4;
	xMsg3582.RiskClass := 4;
	xMsg3582.Reset     := FALSE;
	xMsg3582();
	MM2VIS.bMsg3582    := xMsg3582.Q;	

	(* W9215 air temperature before exhaust gas scavening valve maximum *)//SWAT920/5
	xMsg9215.Enable	   := Para.bT_bScavValve_Active;
	xMsg9215.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND  IN_EX.tT_bScavValve.GoodQual
													AND (IN_EX.tT_bScavValve.Ai > Para.rT_bScavValve_LimHi1);
	xMsg9215.PT		   := T#2s;
	xMsg9215.Prio 	   := 4;
	xMsg9215.RiskClass := 4;
	xMsg9215.Reset     := FALSE;
	xMsg9215();
	MM2VIS.bMsg9215    := xMsg9215.Q;  

	(* W9249 Exhaust gas pressure fast measurement signal failure (W2497) *)	//blocks engine restart if active
	
	xMsg9249.Enable	   := Para.bPr_OXIcat_In_Fast_Exist;	
	xMsg9249.Set 	   := NOT IN_EX.tPr_EG_Deflag_Fast.GoodQual;
	xMsg9249.PT		   := T#0s;
	xMsg9249.Prio 	   := 4;
	xMsg9249.RiskClass := 4;
	xMsg9249.Reset     := FALSE;
	xMsg9249();
	MM2VIS.bMsg9249    := xMsg9249.Q;  
	OUT_EX.bMsg9249    := xMsg9249.Q;
	
	(* W9305 (A2337) temperature high exhaust gas pressure relief valve 1 *)(* P.02-TI-039 *)
	xMsg9305.Enable	   := Para.bT_EG_PrReliefVa1_Active;
	xMsg9305.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND(IN_EX.tT_EG_PrReliefVa1.Ai > Para.rT_EG_PrReliefVa_LimHi) AND NOT MM2VIS.bMsg9307;
	xMsg9305.PT		   := T#2s;
	xMsg9305.Prio 	   := 4;
	xMsg9305.RiskClass := 4;
	xMsg9305.Reset     := FALSE;
	xMsg9305();
	MM2VIS.bMsg9305    := xMsg9305.Q;

	(* W9306 (A2338) temperature high exhaust gas pressure relief valve 2 *)(* P.02-TI-040 *)
	xMsg9306.Enable	   := Para.bT_EG_PrReliefVa2_Active;
	xMsg9306.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND(IN_EX.tT_EG_PrReliefVa2.Ai > Para.rT_EG_PrReliefVa_LimHi) AND NOT MM2VIS.bMsg9308;
	xMsg9306.PT		   := T#2s;
	xMsg9306.Prio 	   := 4;
	xMsg9306.RiskClass := 4;
	xMsg9306.Reset     := FALSE;
	xMsg9306();
	MM2VIS.bMsg9306    := xMsg9306.Q;

	(* W9307 temperature exhaust gas pressure relief valve 1 signal failure *)(* P.02-TI-039 *)
	xMsg9307.Enable	   := Para.bT_EG_PrReliefVa1_Active;
	xMsg9307.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EG_PrReliefVa1.GoodQual;
	xMsg9307.PT		   := T#0s;
	xMsg9307.Prio 	   := 4;
	xMsg9307.RiskClass := 4;
	xMsg9307.Reset     := FALSE;
	xMsg9307();
	MM2VIS.bMsg9307    := xMsg9307.Q;

	(* W9308 temperature exhaust gas pressure relief valve 2 signal failure *)(* P.02-TI-040 *)
	xMsg9308.Enable	   := Para.bT_EG_PrReliefVa2_Active;
	xMsg9308.Set 	   := IN_EX.tPB2MM.bParaSetupOk AND NOT IN_EX.tT_EG_PrReliefVa2.GoodQual;
	xMsg9308.PT		   := T#0s;
	xMsg9308.Prio 	   := 4;
	xMsg9308.RiskClass := 4;
	xMsg9308.Reset     := FALSE;
	xMsg9308();
	MM2VIS.bMsg9308    := xMsg9308.Q;

	(* W9310 OXIcat Outlet temperature measurement signal failure *)(* A2319 *)
	xMsg9310.Enable	   := Para.bOXIcat_Exist
					  AND Para.bT_OXIcat_Out_Exist;
	xMsg9310.Set 	   := NOT IN_EX.tT_EGaCat.GoodQual
					  AND (IN_EX.rN_EngAct > 0);
	xMsg9310.PT		   := T#60s;
	xMsg9310.Prio 	   := 4;
	xMsg9310.RiskClass := 4;
	xMsg9310.Reset     := FALSE;
	xMsg9310();
	MM2VIS.bMsg9310    := xMsg9310.Q;

	(* W9347 exhaust gas flaps - module standstill position not reached *)
	(*                          = bypass open, boiler closed *)
	xTON_9347(IN:= NOT IN_EX.tEng_Run.Do AND ((NOT IN_EX.tEG_ByVaOpened.Di AND IN_EX.tEG_ByVaOpened.GoodQual)
					  					  OR  (NOT IN_EX.tEG_BoVaClosed.Di AND IN_EX.tEG_BoVaClosed.GoodQual)), PT:= T#60s);
			
	xMsg9347.Enable	   := IN_EX.tPB2MM.bSys_Run;
	xMsg9347.Set 	   := xTON_9347.Q;
	xMsg9347.PT		   := T#0s;
	xMsg9347.Prio 	   := 4;
	xMsg9347.RiskClass := 4;
	xMsg9347.Reset     := FALSE;
	xMsg9347();
	MM2VIS.bMsg9347    := xMsg9347.Q;

	OUT_EX.bEngBloc_EX := xMsg9347.Set;

	(* W9348 exhaust gas flaps - status signal failure *)
	xMsg9348.Enable	   := IN_EX.tPB2MM.bSys_Run;
	xMsg9348.Set 	   := (    IN_EX.tEG_ByVaOpened.Di AND     IN_EX.tEG_ByVaClosed.Di AND IN_EX.tEG_ByVaOpened.GoodQual AND IN_EX.tEG_ByVaClosed.GoodQual)
					   OR (NOT IN_EX.tEG_ByVaOpened.Di AND NOT IN_EX.tEG_ByVaClosed.Di AND IN_EX.tEG_ByVaOpened.GoodQual AND IN_EX.tEG_ByVaClosed.GoodQual)
					   OR (    IN_EX.tEG_BoVaOpened.Di AND     IN_EX.tEG_BoVaClosed.Di AND IN_EX.tEG_BoVaOpened.GoodQual AND IN_EX.tEG_BoVaClosed.GoodQual)
					   OR (NOT IN_EX.tEG_BoVaOpened.Di AND NOT IN_EX.tEG_BoVaClosed.Di AND IN_EX.tEG_BoVaOpened.GoodQual AND IN_EX.tEG_BoVaClosed.GoodQual);
	xMsg9348.PT		   := T#60s;
	xMsg9348.Prio 	   := 4;
	xMsg9348.RiskClass := 4;
	xMsg9348.Reset     := FALSE;
	xMsg9348();
	MM2VIS.bMsg9348    := xMsg9348.Q;


	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)
	
	(* B1273 demand exhaust gas scavenging flap open *)
	xMsg1273.Enable		:=	xEngType.Type9 OR Para.bEGScav_Active;
	xMsg1273.Set		:=	OUT_EX.tScavVaCoOpen.Do;
	xMsg1273.Reset		:=	TRUE;
	xMsg1273();
	MM2VIS.bMsg1273		:=	xMsg1273.Q;

	(* B1274 demand exhaust gas scavenging flap close *)
	xMsg1274.Enable		:=	xEngType.Type9 OR Para.bEGScav_Active;
	xMsg1274.Set		:=	OUT_EX.tScavVaCoClose.Do AND IN_EX.tPB2MM.bSys_Run;
	xMsg1274.Reset		:=	TRUE;
	xMsg1274();
	MM2VIS.bMsg1274		:=	xMsg1274.Q;

	(* B1275 exhaust gas scavenging valve opened *)
	xMsg1275.Enable		:=	xEngType.Type9 OR Para.bEGScav_Active;
	xMsg1275.Set		:=	IN_EX.tScavVaOpened.Di AND NOT IN_EX.tScavVaClosed.Di;
	xMsg1275.Reset		:=	TRUE;
	xMsg1275();
	MM2VIS.bMsg1275		:=	xMsg1275.Q;

	(* B1276 exhaust gas scavenging valve closed *)
	xMsg1276.Enable		:=	xEngType.Type9 OR Para.bEGScav_Active;
	xMsg1276.Set		:=	IN_EX.tScavVaClosed.Di AND NOT IN_EX.tScavVaOpened.Di AND IN_EX.tPB2MM.bSys_Run;
	xMsg1276.Reset		:=	TRUE;
	xMsg1276();
	MM2VIS.bMsg1276		:=	xMsg1276.Q;

	(* B1277 demand exhaust gas scavenging fan on *)
	xMsg1277.Enable		:=	xEngType.Type9 OR Para.bEGScav_Active;
	xMsg1277.Set		:=	    OUT_EX.tScavFanCoOn.Do AND IN_EX.tPB2MM.bSys_Run;
	xMsg1277.Reset		:=	TRUE;
	xMsg1277();
	MM2VIS.bMsg1277		:=	xMsg1277.Q;

	(* B1278 demand exhaust gas scavenging fan off *)
	xMsg1278.Enable		:=	xEngType.Type9 OR Para.bEGScav_Active;
	xMsg1278.Set		:=	NOT OUT_EX.tScavFanCoOn.Do AND IN_EX.tPB2MM.bSys_Run;
	xMsg1278.Reset		:=	TRUE;
	xMsg1278();
	MM2VIS.bMsg1278		:=	xMsg1278.Q;

	(* B1279 exhaust gas scavenging fan operation on *)
	xMsg1279.Enable		:=	xEngType.Type9 OR Para.bEGScav_Active;
	IF xEngType.Type9 THEN xMsg1279.Set := IN_EX.tScavFanFC_Rdy.Di AND NOT IN_EX.tScavFanFC_P_Lo.Di AND OUT_EX.tScavFanCoOn.Do;
	ELSE				   xMsg1279.Set := IN_EX.tScavFanOp.Di AND NOT NoScavFan;
	END_IF;
	xMsg1279.Reset		:=	TRUE;
	xMsg1279();
	MM2VIS.bMsg1279		:=	xMsg1279.Q;

	(* B1280 exhaust gas scavenging fan operation off *)
	xMsg1280.Enable		:=	xEngType.Type9 OR Para.bEGScav_Active;
	IF xEngType.Type9 THEN xMsg1280.Set := IN_EX.tPB2MM.bSys_Run AND NOT xMsg1279.Set;
	ELSE				   xMsg1280.Set := IN_EX.tPB2MM.bSys_Run AND NOT IN_EX.tScavFanOp.Di AND NOT NoScavFan;
	END_IF;
	xMsg1280.Reset		:=	TRUE;
	xMsg1280();
	MM2VIS.bMsg1280		:=	xMsg1280.Q;

	(* B1288 CO2 flap open *)
	xMsg1288.Enable		:=	Para.bCodinox_Active;
	xMsg1288.Set		:=	IN_EX.tCO2_VaOpened.Di;
	xMsg1288.Reset		:=	TRUE;
	xMsg1288();
	MM2VIS.bMsg1288		:=	xMsg1288.Q;
	
	(* B1289 CO2 flap closed *)
	xMsg1289.Enable		:=	Para.bCodinox_Active;
	xMsg1289.Set		:=	IN_EX.tCO2_VaClosed.Di;
	xMsg1289.Reset		:=	TRUE;
	xMsg1289();
	MM2VIS.bMsg1289		:=	xMsg1289.Q;
	
	(* B1290 CO2 demand on *)
	xMsg1290.Enable		:=	Para.bCodinox_Active;
	xMsg1290.Set		:=	IN_EX.tCO2_Demand.Di;
	xMsg1290.Reset		:=	TRUE;
	xMsg1290();
	MM2VIS.bMsg1290		:=	xMsg1290.Q;
	
	(* B1291 CO2 demand off *)
	xMsg1291.Enable		:=	Para.bCodinox_Active;
	xMsg1291.Set		:=	NOT IN_EX.tCO2_Demand.Di;
	xMsg1291.Reset		:=	TRUE;
	xMsg1291();
	MM2VIS.bMsg1291:=	xMsg1291.Q;

	(* 2847 N2 gas valves closed *)
	xMsg2847.Enable	   := Para.bSel_N2;
	xMsg2847.Set 	   := NOT OUT_EX.tN2_ScavGV_CoOpen.Do;
	xMsg2847.Reset     := TRUE;
	xMsg2847();
	MM2VIS.bMsg2847    := xMsg2847.Q;
	
	(* 2848 N2 gas valves opened *)
	xMsg2848.Enable	   := Para.bSel_N2;
	xMsg2848.Set 	   :=     OUT_EX.tN2_ScavGV_CoOpen.Do;
	xMsg2848.Reset     := TRUE;
	xMsg2848();
	MM2VIS.bMsg2848    := xMsg2848.Q;


	(* B template 
	xMsg.Enable		:=	TRUE;
	xMsg.Set		:=	bBool;
	xMsg.Reset		:=	TRUE;
	xMsg();
	MM2VIS.bMsg		:=	xMsg.Q;	*)
	
	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1   := OUT_EX.tEX2AB.bGnlTrip1   OR IN_EX.tAB2EX.bGnlTrip1;
	bGnlTrip2   := OUT_EX.tEX2AB.bGnlTrip2   OR IN_EX.tAB2EX.bGnlTrip2;
	bGnlTrip3   := OUT_EX.tEX2AB.bGnlTrip3   OR IN_EX.tAB2EX.bGnlTrip3;
	bGnlWarning := OUT_EX.tEX2AB.bGnlWarning OR IN_EX.tAB2EX.bGnlWarning;

	bGnlTrip	:= bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
	(*******************************************************************************)
END_PROGRAM