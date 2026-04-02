(*******************************************************************************
MsgAG	 			 messages auxiliaries general

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2026

Customized modifications: -
------------------------
 
History:
-------
V0.01.0	02.11.2011	lettenb.	new
V3.99.1 15.03.2013	pankajrodey	Changes for V3.40, added logic for bMsg2284, change in logic for 
								bMsg1129, bMsg2242, bMsg1059, bMsg2597
V3.99.2	20.03.2013	Denk		IN_AG.bPreLubeDem --> bPreLubeDem (modulglobal)
		04.04.2013	lettenb.	cleanup from merging OL into AG
		13.05.2013				2284 reactivated		
		23.05.2013				1100,2587,2608,2613,3350,3351,3574,3578,3579,3587,3588 added, acc.version V3.30/V3.40
		24.05.2013				reset OUT_xx.txx2AB.bGnlTripx changed
		28.05.2013	lettenb.	bTestEnabled Para -> loc.var
		08.07.2013				Para.rF_BlowbyFan_HyHi, Para.rF_BlowbyFan_HyLo removed(not specified)
		23.07.2013				2213 logic corr.for universal use, DI negated bugfix, Para.bPr_OTCaF_Active added
								1059,2233,2554 adaped for BR9(logic moved from oil_c_9)
		29.07.2013				1043 engine oil temp.high monitoring moved from T_EO_EG -> MsgAG
V3.99.3	21.08.2013	Denk		bMsg2587 oil quality measurement signal failure added
		02.12.2013	lettenb.	2591,2992: Para.rF_BlowbyFan_HyHi/Lo added
V4.00.0	29.01.2014	lettenb.	1017,1018,1023,1051,3322 ULdepended reset 624
		27.02.2014				logger added
V4.00.1	12.05.2014				3322 xTON_PrCC_HiHi: xGR_MAX_PrCC_Hi.Q -> xGR_MAX_PrCC_HiHi.Q, bugfix	
V4.00.2	01.08.2014	Tinello		OUT_AG.bMsg1120 added	
		18.11.2014	lettenb.	2263 modif. 920
V4.00.3	02.02.2015				2265,2590,2594,2595,2596,2598,2599,2600,2602,2603,2604,2605,2606,2636,2642,2643,2644,2645,2646,2666 new for 920
								2103,3323 enable with IN_AG.tPB2MM.bSys_Run
								1257,1258,1259,1260,1261,1262,1263,1264,1281,1282 added
		19.03.2015				1090 tECWP_FC_Rdy.Di, tECWP_FC_PowLo.Di removed(substituted with current relay)
									 HBT_3 with IN_AG.tECWP_Op.Di to avoid alarm with ramping FU(920)
		15.04.2015				3401 disabled acc.XT3(since 04/2008/LH), bugfix(porting failure)
		07.05.2015				2554 speed limits (895,1495)substituted with Para.rN_EngNom - 5, -> universal for all engine types
V4.03.0 25.07.2015	Plattner	W2737, auxiliaries switch module interface tripped; W2738, release auxiliaries from auxiliaries panel is missing
        06.08.2015  Stary       2722-2729 added (oil system failure-messages)
		07.08.2015  Denk		Manual operating auxiliaries control functionality added
		05.10.2015	lettenb.	2754,2755,2756,2757,2758,2759,2760,2761 added, blowby(cm&u)
		02.12.2015				2242 xEngType.Type9 added, bugfix
		09.12.2015				1043 xTON_OTMA.PT BR234: T#3600s war T#900s, BR69: T#900s war T#3600s, bugfix
		15.01.2016				2597 FC substituted by OUT_AG.bEOP_AC_PowSupOk(TCA-redesign)
                                2263,2810 bECW_PreHV_Active added(TCA-redesign)
V4.04.0	10.05.2016	lettenb.	2291,2292,3495,3496 added(oil pressure after pump)
		19.05.2016				2627,2628,2629 added(oil filter unit)
		20.06.2016				3322 only active if not GnlTrip1/2 active(TPSD/holecek)
								2591 IN_AG.tAuxV_Eng_ok.Di added(tinello)
		04.07.2016				2778,2781,2782,2783,2784 added
		07.09.2016	Tinello		2785 - 2789 added
		04.10.2016				2791,2792 added
		11.10.2016	Perktold	Para.bGridCode_Active replaced BY IN_AG.bGridCode_ON
		24.10.2016	Lettenb.	2762 Functional Safety EN 13849
		07.11.2016				xMsg1129.RiskClass := 4 -> 0, bugfix
		09.11.2016				tL_OilSump3Hi.Di added(requisition/wörgötter)
		17.11.2016				2304,2421 added, preparation for V4.05
		22.11.2016	Tinello		2422 added
		16.01.2016	lettenb.	2689 added, prepared for future
		22.03.2017				1101: IN_AG.tPB2MM.bSys_Run added, for cold start restistance
V4.05.0	27.02.2017	lettenb.	2260,2263,2265,2267 disabled, 1020,1059,2224,2242 disabled for 920, 2423,2431,2432 added, SWAT920/1
								xMsg2264.Set: AND OUT_AG.tECW_PreH_Dem.Do added, SWAT920/1
								2269: xMsg2268.RiskClass -> xMsg2269.RiskClass := 4; bugfix
		27.03.2017				2427,2434 added, perm.prelub.for BR6/9 fast start
		10.04.2017				2424,2425,2426,2557 added, 2266 logic changed, air starter SWAT920/2
		21.04.2017				2233 TON 5s->180s, 2613 Gw:= Para.rPr_TCOF_Max -(0.30->0.20), 1051 logic changed, 2435 added, SWAT920/2
								2524 GR_MAX_OIL_STARTFG from Aux_9 moved to OpState and MsgAG
		24.05-2017				1264 only for BR9, bugfix
		08.08.2017				2434 BR6 monitoring with existing press.sensor after TC oil filter
		07.08.2017	Messner		Starter battery voltage monitoring (W1148 & W2473)
		25.09.2017	Messner		Pre-librication pump brush wear monitoring (W2475)
		07.08.2017	502423184	due TO SWAT #3: no block OF the pre-heating due TO measuring failure OF oil pan temperatur AND
									use enigne oil inlet temperature as a fall-back signal FOR the pre-heating
		20.09.2017	Messner		Active Cooling Program operation messages (B2931, B2932, B2933) added
		19.12.2017	Messner		Oil preheating valve operation messages (B2956, B2957) added
		22.12.2017	lettenb.	comment added: Safety-related application software source code (EN 13849-1 / 4.6.3)
								.LockReset removed (cleanup)
		22.01.2018	lettenb.	1101,3496 bSys_Run -> bParaSetupOk to avoid message at plc startup
V4.05.1 14.02.2018	Weitzer		add good qual at W1148 starter battery voltage low to detect source of monitoring
								add second DI at W2475 Maintenance interval prelubrication pump + OUT_AG.tEOP1DC_Dem.Do
		26.03.2018	lettenb.	1017 reverted for BR2-6 to version before SWAT#3, bugfix
		09.04.2018				2770-2784 bParaSetupOk added to avoid alarm at plc startup,bugfix 
		07.05.2018				xMsg1018 .Set space removed, cosmetic
		05.06.2018				1148 NOT into brackets, bugfix
		13.06.2018	Weitzer		correct W1148, warning was always active if analogue sensor was used
		28.06.2018	lettenb.	2432 xEngType.Type9 added, only for 920, bugfix
		18.09.2018				2432 disabled for BR2-6, 2233 delay 180s only for BR9, bu
V4.06.0	19.07.2018	Schmid		permanent prelubrication for faststart added
		23.07.2018	Schmid		9221-9222, 9224-9225 added for permanent prelubrication for faststart
		09.10.2018				W9222+W9225: set trigger delay to 10s
		18.10.2018				W2434 deactivated FOR J624 (replaced BY W9221), W2434 remains active for BR9
		25.10.2018				variable names adapted TO coding guidelines
		08.11.2018	lettenb.	2613 SWAT change only for BR9, bugfix
V4.07.0 20.02.2018	lettenb.	3216,1043 logic changed, Para.rT_EO_LimHiHi added, SWAT920/5
                                1090 delay 10 -> 30s, SWAT920/5
								2266,2424,2426 disabled, 9214 added, SWAT920/5
		26.04.2018	lettenb.	9220 added, SWAT920/5a,b
		05.06.2018	lettenb.	GR_MAX_OIL_STARTFG -> GR_MIN_OIL_STARTFG, bugfix
		09.08.2018	Schmid		9227 added for 2nd low temperature charge cooling circuit
		17.12.2018	Schmid		9254 added for hydraulic ECW pre-heating
		08.01.2019	Schmid		W9255-W9258 added and W2118 (CCWP), W3519 (HWP), W9227 (CC2WP) modified for redundant pump control
		10.01.2019	Schmid		A2332 Boiler failure + A2333 Seismic alarm added
		11.03.2019	Schmid		W2524: OUT_AG.bMsg2524 added for start blocking (BR9)
		18.03.2019	Schmid		W9279: new warning for emergency cooler circuit pump 1 (necessary due to new naming convention)
		22.03.2019	Schmid		removed unused variables xTOF_1017_rel, M_ODRA_point2
		08.05.2019	Schmid		W1159: only enabled if IN_AG.tPB2MM.bParaSetupOk - avoid that warning is triggered with cold start
					Schmid		B1264 only FOR BR9, bugfix
		15.05.2019	lettenb.	A1139 lockout engine with PLC startup added, (Maschinendirektive (2006/42/EG)
V4.07.1	24.06.2019	Schmid		W2627, W2628 measurement signal failure always active (not only with oil filter unit pump operation)
								W2786 measurement signal failure always active (not only with oil filter unit centrifuge operation)
V4.09.0	05.07.2019	Schmidt		W9280,W9281,W9282,W9283 added for turbocharger post-cooling function
		02.12.2019	Schmid		W9316, W9317, A1090 difference pressure monitoring for ECWP added
		11.12.2019	Schmid		new air starter design: A2267 reactivated, W9303 MSF for engagement pressure
V4.10.0	20.07.2020	Schmid		allow fast start without ECWP_Op feedback, failure triggers A1090 during start-up, W3497 failure in safety loop extended
		19.11.2020	lettenb.	2348,2349,2350,2351,2352,2353,2355,2359,2360 added
		22.12.2020	lettenb.	1018,1023,1091,1120 : RiskClass setting corr.acc.TI 1100-0111
		03.12.2020	Perktold	9332,9333,9001,9002,9003,9004 added for oil and coolant management
		18.01.2021	Schmid		2361 added for additional oil tank leakage detection
		11.03.2021	lettenb.	9004->9048, Msg# already used, bugfix
V4.11.0	25.11.2021	Schmid		W9279 only active if emergency cooler pump demanded
		02.02.2022	Schmid		W2791 suppressed in case of black start
V4.11.2	22.02.2022	Schmid		oil quality sensor modifications from validation
V4.12.0	14.11.2022	Zengerer 	oil tank Msg1159, 2722, 1160,9323, 2739; new W9362, W9363, W9364
		19.12.2022	Perktold	added comments for sr-code (EN 13849-1 / 4.6.3) for W3507
		21.12.2022	Perktold	added W9369 Failure auxiliaries supply voltage engine
V4.12.0 22.12.2022	Bacci		W9074 added. Tooth to tooth position
		06.02.2023	Tinello		W2597 engine prelube pump failure: activated also for Enginetype 6 / Changed W2427
		17.03.2023	Bacci		B1249 and B1250 adjustment for different engine types
V4.13.0	28.09.2023	Bacci		xMsg2587.Set and xMsg2587.Enable set to FALSE
		03.10.2023	Tinello		Bugfix #1266 Heat water pump with softstarter
		03.10.2023	Tinello		Bugfix #1267 Demand for emergency cooling circuit pump was missing
		08.11.2023	Tinello		warning engine oil level high and oil refill volume maximum added
								ECW pump difference pressure monitoring for all engine types available
		20.11.2023  Bacci		A2377, A2378, A2379, B9089, B9090 and B9091 added.
		21.07.2023	Bacci		added A2376 and B9088 scavenging by starter motor monitoring 
		13.12.2023	Tinello		QC3111 oil pre-heating: new warning and extension of existing warnings (2023-197)
		05.03.2024	Tinello		Oil filter diff pressure monitoring (2023-184) - including issue #1122 and Fracas #3216 
		05.03.2024	Bacci		Changes on trip 1120 added
V4.14.0	25.11.2024 	Bacci		T6 Start procedure with purge start (2024-219): changes in A2376, B9088, A1120. Added A2382, B9096, B9097, W9221, W9222, W9224, W9225
		10.12.2024 	Nagy		W9513 Oil refilling failure added, A1043 modified (2024-225)
		08.04.2025	Tinello		SafetyPLC: Deactivated W3497 in case of existing SAFETY-PLC
V4.25.0	01.07.2025	Tinello		SafetyPLC: Changed behavior of A1053 and A1054 in case of existing SAFETY-PLC / added gas and fire system failure
		15.01.2026	Tinello		SafetyPLC: Bugfix for 1090 because of mechanical pump

Instructions FOR use:
--------------------
1) declare alarm with function block "Msg"
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
	bMsg0000_Test		:=	xMsg0000.Test; alarm bypass active

3)  expand INIT

			
(*******************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)
	OUT_AG.tAG2AB.bGnlTrip1		:=	FALSE;
	OUT_AG.tAG2AB.bGnlTrip2		:=	FALSE;
	OUT_AG.tAG2AB.bGnlTrip3		:=	FALSE;
	OUT_AG.tAG2AB.bGnlWarning	:=	FALSE;
	OUT_AG.tAG2AB.bTriptype1	:=	FALSE;
	OUT_AG.tAG2AB.bTriptype2	:=	FALSE;
	OUT_AG.tAG2AB.bTriptype3	:=	FALSE;


	(*-------------------------------------------------------------------------*)

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* A1017 oil pressure low *)
	xMsg1017.Enable	   := TRUE;
	IF xEngType.Type9 THEN 														//SWAT920/5b	
		xMsg1017.Set := Z_ODR 
					AND (AN_ODRA     OR NOT IN_AG.tPr_EngLubOil.GoodQual) 	    (* both sensors have to drop for a shut down ... SWAT#3 *)
					AND (AN_OD_AF_RA OR NOT IN_AG.tPr_EOF_After.GoodQual)   	(* ... just in case of no measuring signal failure *)//SWAT920/5b
					AND (IN_AG.tPr_EngLubOil.GoodQual OR IN_AG.tPr_EOF_After.GoodQual);
	ELSE
        xMsg1017.Set := Z_ODR AND AN_ODRA;
	END_IF;
	xMsg1017.PT		   := T#0s;
	xMsg1017.Prio 	   := 2;
	xMsg1017.RiskClass := 10;
	xMsg1017.Reset	   := FALSE;
	xMsg1017();
	MM2VIS.bMsg1017 	:= xMsg1017.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	
	(* A1018 engine oil level low *)
	M_OMIN_DREHZ := xMsg1018.Q AND(M_DREHZ OR M_OMIN_DREHZ);

	xMsg1018.Enable	   := TRUE;
	xMsg1018.Set 	   := OUT_AG.bEngOilLevel_Lo;
	xMsg1018.PT	       := T#0s;
	xMsg1018.Prio 	   := 3;
	xMsg1018.RiskClass := 2;
	xMsg1018.Reset 	   := FALSE;	
	xMsg1018();
	MM2VIS.bMsg1018    := xMsg1018.Q;


	(* A1020 engine cooling water level low (W3403)*)
	xMsg1020.Enable	   := NOT xEngType.Type9;//SWAT920/1
	xMsg1020.Set 	   := NOT IN_AG.tL_ECW_LoLo.Di;
	xMsg1020.PT	       := T#0s;
	xMsg1020.Prio 	   := 2;
	xMsg1020.RiskClass := 4;
	xMsg1020.Reset 	   := FALSE;	
	xMsg1020();
	MM2VIS.bMsg1020    := xMsg1020.Q;


	(* A1023 engine start up failure *)
	xMsg1023.Enable	   := TRUE;
	xMsg1023.Set 	   := 	bStartErr
 						OR (OUT_AG.bLockAckStarter AND xMsg1023.Set AND NOT xMsg1023.Test)
 						OR (IN_AG.tEngStartFailure.Di AND Para.bVISA)
						OR bStartErr_ST_UntRelDur_High;
	xMsg1023.PT	       := T#0s;
	IF Para.bVISA THEN 
		xMsg1023.Prio  := 2;
	ELSE
		xMsg1023.Prio  := 3;
	END_IF;	
	xMsg1023.RiskClass := 1;
	xMsg1023.Reset 	   := FALSE;	
	xMsg1023();
	MM2VIS.bMsg1023    := xMsg1023.Q;
	OUT_AG.bMsg1023    := xMsg1023.Q;


	(* A1043 engine oil temperature high (W3216)*)//SWAT920/5---begin
	xGR_MAXR_OTMA(In:= IN_AG.tT_EO.Ai, Gw:= Para.rT_EOP_LimMax, Hy:= Para.rT_EOP_HyMax);
	xTON_OT(IN:= IN_AG.tPB2MM.bParaSetupOk AND xGR_MAXR_OTMA.Q, PT:= T#300s);
	AN_OTMA := xTON_OT.Q;
	
	IF xEngType.Type6 THEN
		xGR_MAXR_OTMA_Prio2(In:= IN_AG.tT_EO.Ai, Gw:= Para.rT_EOP_LimMax + 7.0 , Hy:= Para.rT_EOP_HyMax);
	ELSE
		xGR_MAXR_OTMA_Prio2(In:= IN_AG.tT_EO.Ai, Gw:= Para.rT_EOP_LimMax + 4.0 , Hy:= Para.rT_EOP_HyMax);
	END_IF;
	xTON_OT_Prio2(IN:= IN_AG.tPB2MM.bParaSetupOk AND xGR_MAXR_OTMA_Prio2.Q, PT:= T#2s);
	AN_OTMA_Prio2 := xTON_OT_Prio2.Q;
	
	
	IF xEngType.Type6 THEN xTON_OTMA.PT:= T#900s;
	ELSE                   xTON_OTMA.PT:= T#3600s;
	END_IF;
	xTON_OTMA(IN:= AN_OTMA);
	T_OTMA := xTON_OTMA.Q;

	IF xEngType.Type6 THEN xGR_MAXR_OTMAA(In:= IN_AG.tT_EO.Ai, Gw:= Para.rT_EOP_LimMax + 5.0, Hy:= Para.rT_EOP_HyMax);
	ELSE                   xGR_MAXR_OTMAA(In:= IN_AG.tT_EO.Ai, Gw:= Para.rT_EOP_LimMax + 2.0, Hy:= Para.rT_EOP_HyMax);
	END_IF;
	xTON_OTMAA(IN:= IN_AG.tPB2MM.bParaSetupOk AND xGR_MAXR_OTMAA.Q, PT:= T#2s);
	AN_OTMAA := xTON_OTMAA.Q;

	(* Enable monitoring after engine operation + 60s *)
	xTON_BRTB_60s(IN:= IN_AG.tEng_Run.Do, PT:= T#60s);
	BTRB_60s := xTON_BRTB_60s.Q;

	xMsg1043.Enable	   := TRUE;
	IF xEngType.Type9 THEN xMsg1043.Set := (IN_AG.tT_EO.Ai > Para.rT_EO_LimHiHi) AND NOT MM2VIS.bMsg2102 AND IN_AG.tEng_Run.Do;//SWAT920/5
	ELSE                   xMsg1043.Set := (T_OTMA OR AN_OTMAA OR AN_OTMA_Prio2) AND NOT MM2VIS.bMsg2102 AND BTRB_60s;
	END_IF;
	xMsg1043.PT		   := T#0s;
	IF AN_OTMA_Prio2 THEN
		xMsg1043.Prio	   := 2;
	ELSE
		xMsg1043.Prio	   := 3;
	END_IF;
	xMsg1043.RiskClass := 1;
	xMsg1043.Reset	   := FALSE;
	xMsg1043();
	MM2VIS.bMsg1043	   := xMsg1043.Q;//SWAT920/5---end

	
	(* A1051 engine oil level high (W2435) *)
	xMsg1051.Enable	   := TRUE;
	IF xEngType.Type9 THEN xMsg1051.Set := NOT IN_AG.tEO_Level_Hi.Di//SWAT920/2.2
                                       OR     (bEO_Level_Hi AND (IN_AG.rN_EngAct > 900))
					                   OR     (IN_AG.tEO_Level.Ai >= 1.0);
	ELSE                   xMsg1051.Set := NOT IN_AG.tEO_Level_Hi.Di 
                                       OR      bEO_Level_Hi;
	END_IF;
	xMsg1051.PT		   := T#10s;
	xMsg1051.Prio	   := 3;
	xMsg1051.RiskClass := 4;
	xMsg1051.Reset	   := FALSE;
	xMsg1051();
	MM2VIS.bMsg1051	   := xMsg1051.Q;
		
	
	(* A1052 gas pre alarm *)	
	xMsg1052.Enable	   := TRUE;
	xMsg1052.Set 	   := NOT IN_AG.tGasPreAlarm.Di;
	xMsg1052.PT	       := T#0s;
	xMsg1052.Prio 	   := 2;
	xMsg1052.RiskClass := 4;
	xMsg1052.Reset	   := FALSE;	
	xMsg1052();
	MM2VIS.bMsg1052    := xMsg1052.Q;
	OUT_AG.bMsg1052    := xMsg1052.Q;


	(* A1053 gas alarm *)	
	xMsg1053.Enable	   := TRUE;
	xMsg1053.Set 	   := NOT IN_AG.tGasAlarm.Di;

IF IN_AG.bSafetyPLC_Active THEN			(* SAFETY PLC *)
	xMsg1053.PT	       := T#1s;
	xMsg1053.Prio 	   := 3;
ELSE
	xMsg1053.PT	       := T#0s;
	xMsg1053.Prio 	   := 2;
END_IF

	xMsg1053.RiskClass := 4;
	xMsg1053.Reset	   := FALSE;
	xMsg1053();
	MM2VIS.bMsg1053    := xMsg1053.Q;
	OUT_AG.bMsg1053    := xMsg1053.Q;


	(* A1054 fire alarm *)	
	xMsg1054.Enable	   := TRUE;
	
	xMsg1054.Set 	   := NOT IN_AG.tFireAlarm.Di;

IF IN_AG.bSafetyPLC_Active THEN			(* SAFETY PLC *)
	xMsg1054.PT	       := T#1s;
	xMsg1054.Prio 	   := 3;
ELSE
	xMsg1054.PT	       := T#0s;
	xMsg1054.Prio 	   := 2;
END_IF

	xMsg1054.RiskClass := 4;
	xMsg1054.Reset	   := FALSE;
	xMsg1054();
	MM2VIS.bMsg1054    := xMsg1054.Q;	
	OUT_AG.bMsg1054    := xMsg1054.Q;


	(* A1059 Oil filter differential pressure maximum *)
	xMsg1059.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg1059.Set       := M_DREHZ_5s AND (NOT IN_AG.tEOF_DiffMax.Di OR bAMM_DPr_EOF_Lim3);
	xMsg1059.PT		   := T#10s;
	xMsg1059.Prio	   := 2;
	xMsg1059.RiskClass := 3;
	xMsg1059.Reset	   := FALSE;
	xMsg1059();
	MM2VIS.bMsg1059	   := xMsg1059.Q;


	(* A1060 prelube oil pressure failure *)	
	xMsg1060.Enable	   := TRUE;
	xMsg1060.Set 	   := 	bPr_PreLub_Lo 
					AND NOT xTOF_ShortPreLubeTime_Delay.Q;  (* manual mode short prelubrication time with 3s off cycle delay *)
	xMsg1060.PT	       := T#5s;
	xMsg1060.Prio 	   := 2;
	xMsg1060.RiskClass := 4;
	xMsg1060.Reset	   := FALSE;
	xMsg1060();
	MM2VIS.bMsg1060    := xMsg1060.Q;	
	OUT_AG.bMsg1060    := xMsg1060.Q;

	
	(* A1090 engine cooling water pump failure *)	
 	IF xEngType.Type9 THEN xTOF_MKWP_op(IN:= IN_AG.tECWP_Op.Di OR bNoMon4BlackStart, PT:= T#30s);//SWAT920/5
	ELSE				   xTOF_MKWP_op(IN:= IN_AG.tECWP_Op.Di OR bNoMon4BlackStart, PT:= T#10s);
	END_IF;
	T_ST_MKWP := xTOF_MKWP_op.Q;
	
	HBT_3 := IN_AG.tECWP_Op.Di OR (IN_AG.bEng_Aux_Dem AND HBT_3);

			(* monitoring ECWP via cooling water pressure over pump *)
		
			(* activate monitoring after ECWP demand *)
			xTON_DPr_ECWP_MonRel(IN:= ((OUT_AG.tECWP1Dem.Do OR OUT_AG.tECWP2Dem.Do) AND NOT xEngType.Type2 AND NOT xEngType.Type3) OR M_HDREHZ, (* Type 2/3 have a mechanical pump *)
								 PT:= T#30s);
		
			(* calculate difference pressure over pumps:			*)
			(* 				M.04-PI-010/011	minus  M.04-PI-001		*)
			(*				after pump		minus  before pump		*)
			rDPr_ECWP1 :=	IN_AG.tPr_ECWaP1.Ai	- IN_AG.tPr_ECW.Ai;
			rDPr_ECWP2 :=	IN_AG.tPr_ECWaP2.Ai	- IN_AG.tPr_ECW.Ai;
		
			(* ECWP monitoring - difference pressure minimum *)
			xTON_DPr_ECWP_LoLo(IN:= ((rDPr_ECWP1 < Para.rDPr_ECWP_LoLo AND IN_AG.tPr_ECWaP1.GoodQual) OR
							 		 (rDPr_ECWP2 < Para.rDPr_ECWP_LoLo AND IN_AG.tPr_ECWaP2.GoodQual)   ) AND IN_AG.tPr_ECW.GoodQual,
							   PT:= T#5s);
			
			(* ECWP operation status if monitoring via difference pressure*)
			bECWP_Op_DPr_Mon :=	(OUT_AG.tECWP1Dem.Do OR OUT_AG.tECWP2Dem.Do) AND NOT xTON_DPr_ECWP_LoLo.Q;

	xMsg1090.Enable	   := TRUE;
	xMsg1090.Set 	   :=	((AT26 OR HBT_3 OR (xTON_ECWP_MonFS.Q AND IN_AG.bFS_Act)) AND NOT T_ST_MKWP)
						OR	(Para.bDPr_ECWP_Mon_Active
							AND (xTON_ECWP_MonFS.Q OR NOT IN_AG.bFS_Act)
							AND	((xTON_DPr_ECWP_MonRel.Q AND xTON_DPr_ECWP_LoLo.Q AND NOT bNoMon4BlackStart) OR
								 ((MM2VIS.bMsg9316 OR NOT IN_AG.tPr_ECWaP1.Exist) AND
								  (MM2VIS.bMsg9317 OR NOT IN_AG.tPr_ECWaP2.Exist)	 )							));
	xMsg1090.PT	       := T#0s;
	xMsg1090.Prio 	   := 2;
	xMsg1090.RiskClass := 1;
	xMsg1090.Reset	   := FALSE;
	xMsg1090();
	MM2VIS.bMsg1090    := xMsg1090.Q;


	(* A1091 charge cooling water pump failure (W2118) *)	
	xMsg1091.Enable	   := FALSE;
	xMsg1091.Set 	   := FALSE;
	xMsg1091.PT	       := T#0s;
	xMsg1091.Prio 	   := 2;
	xMsg1091.RiskClass := 4;
	xMsg1091.Reset	   := FALSE;
	xMsg1091();
	MM2VIS.bMsg1091    := xMsg1091.Q;


	(* A1100 water ingress into inlet manifold *)	
	xMsg1100.Enable	   := TRUE;
	xMsg1100.Set 	   := IN_AG.tL_InMa_Hi.Di AND NOT IN_AG.tL_InMa_NotHi.Di AND NOT IN_AG.tEng_Run.Do;
	xMsg1100.PT	       := T#0s;
	xMsg1100.Prio 	   := 3;
	xMsg1100.RiskClass := 4;
	xMsg1100.Reset	   := FALSE;
	xMsg1100();
	MM2VIS.bMsg1100    := xMsg1100.Q;


	(* A1101 transformator failure *)
	xMsg1101.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg1101.Set 	   := NOT IN_AG.tTransformerTrip.Di;
	xMsg1101.PT	       := T#0s;
	xMsg1101.Prio 	   := 2;
	xMsg1101.RiskClass := 4;
	xMsg1101.Reset	   := FALSE;
	xMsg1101();
	MM2VIS.bMsg1101    := xMsg1101.Q;


	(* A1120 speed measuring signal failure *)
	xTON_1120(IN:= IN_AG.bIgn_Run, PT:= T#1s);
	xGR_MAXR_1120(In:= IN_AG.rN_EngAct, Gw:= 20.0, Hy:= 10.0);

	xMsg1120.Enable	   := TRUE;
	xMsg1120.Set 	   := xTON_1120.Q AND NOT xGR_MAXR_1120.Q AND (IN_AG.tEng_Run.Do OR IN_AG.bEng_Dem) AND
						  NOT (xEngType.Type3 AND IN_AG.bTOF_HwBypassDigitalTwin AND (NOT OUT_AG.tEleStarter_Dem.Do) AND (NOT bStartScavBgn)) AND	(* trip deactivation to allow scavenging at the end of start attempt T3 *)
						  NOT (xEngType.Type6 AND IN_AG.bTOF_HwBypassDigitalTwin);
	xMsg1120.PT	       := T#0s;
	xMsg1120.Prio 	   := 2;
	xMsg1120.RiskClass := 1;
	xMsg1120.Reset	   := FALSE;
	xMsg1120();
	MM2VIS.bMsg1120    := xMsg1120.Q;
	OUT_AG.bMsg1120    := xMsg1120.Q;


	(* A1129 failure auxiliaries *)	
	xTOF_EngAuxMon(IN := OUT_AG.bEngAuxMon, PT:= T#10s);
	T57      := xTOF_EngAuxMon.Q;
	ZM_STHBT := AT26_PB AND NOT T57;

	xMsg1129.Enable	   := TRUE;
	xMsg1129.Set 	   := (ZM_STHBT OR NOT IN_AG.tAuxFail.Di) AND
						   (NOT IN_AG.bGrC_HBErr_AUS OR NOT IN_AG.bGridCode_ON);
	xMsg1129.PT	       := T#0s;
	xMsg1129.Prio 	   := 2;
	xMsg1129.RiskClass := 0;
	xMsg1129.Reset	   := FALSE;
	xMsg1129();
	MM2VIS.bMsg1129    := xMsg1129.Q;


	(* A1137 mains start device failure *)	
	xMsg1137.Enable	   := TRUE;
	xMsg1137.Set 	   := NOT IN_AG.tMainsStartDevFail.Di AND NOT M_DREHZ;	
	xMsg1137.PT	       := T#0s;
	xMsg1137.Prio 	   := 3;
	xMsg1137.RiskClass := 4;
	xMsg1137.Reset	   := FALSE;
	xMsg1137();
	MM2VIS.bMsg1137    := xMsg1137.Q;


	(* A1139 module control panel circuit breaker tripped "All in One" (W3405)*)
    (*       lockout engine with PLC startup *) 	
	xMsg1139.Enable	   := TRUE;
	xMsg1139.Set 	   := NOT IN_AG.tCP_CBTrip.Di
					  OR  NOT bPLC_Startup;	
	xMsg1139.PT	       := T#0s;
	xMsg1139.Prio 	   := 2;
	xMsg1139.RiskClass := 4;
	xMsg1139.Reset	   := FALSE;
	xMsg1139();
	MM2VIS.bMsg1139    := xMsg1139.Q;

	bPLC_Startup := TRUE; (* have to be placed after xMsg1139 *)


	(* A1140 interface control panel circuit breaker tripped *)
	xMsg1140.Enable	   := TRUE;
	xMsg1140.Set 	   := NOT IN_AG.tIFCP_CBTrip.Di;	
	xMsg1140.PT	       := T#0s;
	xMsg1140.Prio 	   := 2;
	xMsg1140.RiskClass := 4;
	xMsg1140.Reset	   := FALSE;
	xMsg1140();
	MM2VIS.bMsg1140    := xMsg1140.Q;

	
	(* W1148 Starter battery voltage low *)	
	xMsg1148.Enable	   := IN_AG.tPB2MM.bSys_Run;
	xMsg1148.Set 	   := bAMM_U_StarterBat_Lo;
	xMsg1148.PT	       := T#0s;
	xMsg1148.Prio 	   := 4;
	xMsg1148.RiskClass := 4;
	xMsg1148.Reset	   := FALSE;
	xMsg1148();
	MM2VIS.bMsg1148    := xMsg1148.Q;


	(* W1159 fresh oil tank level low *)  
	xMsg1159.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg1159.Set 	   := (IN_AG.tL_FreshOilTank_Lo.GoodQual AND IN_AG.tL_FreshOilTank_Lo.Di)
					   OR (IN_AG.tL_FreshOilTank.GoodQual AND (MM2VIS.rV_FreshOilTank < Para.rV_FreshOilTank_LimLo) AND (Para.rV_FreshOilTank_LimLo > 0)) ;		(*New at V4.12*)
	xMsg1159.PT	       := T#0s;
	xMsg1159.Prio 	   := 4;
	xMsg1159.RiskClass := 4;
	xMsg1159.Reset	   := FALSE;
	xMsg1159();
	MM2VIS.bMsg1159    := xMsg1159.Q;


	(* W1160 waste oil tank level high *) 
	xMsg1160.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg1160.Set 	   := (IN_AG.tL_WasteOilTank_Hi.GoodQual AND NOT IN_AG.tL_WasteOilTank_Hi.Di)
					   OR (IN_AG.tL_WasteOilTank.GoodQual AND (MM2VIS.rV_WasteOilTank > Para.rV_WasteOilTank_LimHi) AND (Para.rV_WasteOilTank_LimHi > 0));		(*New at V4.12*)
	xMsg1160.PT	       := T#0s;
	xMsg1160.Prio 	   := 4;
	xMsg1160.RiskClass := 4;
	xMsg1160.Reset	   := FALSE;
	xMsg1160();
	MM2VIS.bMsg1160    := xMsg1160.Q;

	
	(* W1166 failure engine oil supply *)	
	xMsg1166.Enable    := TRUE;
	xMsg1166.Set       := NOT IN_AG.tEO_Supply_Fail.Di;
	xMsg1166.PT        := T#0s;
	xMsg1166.Prio      := 4;
	xMsg1166.RiskClass := 4;
	xMsg1166.Reset     := FALSE;
	xMsg1166();
	MM2VIS.bMsg1166    := xMsg1166.Q;
	

	(* W2102 engine oil temperature measuring signal failure *)
	xMsg2102.Enable	   := TRUE;
	xMsg2102.Set 	   :=  (NOT IN_AG.tT_EO.GoodQual AND IN_AG.tPB2MM.bParaSetupOk) 
						OR (xMsg2102.Set AND IN_AG.bMsg3003 AND bOMSS_MAT);
	xMsg2102.PT		   := T#0s;
	xMsg2102.Prio 	   := 4;
	xMsg2102.RiskClass := 4;
	xMsg2102.Reset	   := FALSE;
	xMsg2102();
	MM2VIS.bMsg2102 	:= xMsg2102.Q;
	OUT_AG.bMsg2102		:= xMsg2102.Q;
	
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* W2103 Engine oil pressure measuring signal failure *)
	xMsg2103.Enable	   := IN_AG.tPB2MM.bSys_Run;
	xMsg2103.Set 	   :=  (NOT IN_AG.tPr_EngLubOil.GoodQual) 
						OR (xMsg2103.Set AND IN_AG.bMsg3003 AND bOMSS_MAT);
	xMsg2103.PT		   := T#300ms;
	xMsg2103.Prio 	   := 4;
	xMsg2103.RiskClass := 4;
	xMsg2103.Reset	   := FALSE;
	xMsg2103();
	MM2VIS.bMsg2103 	:= xMsg2103.Q;
	OUT_AG.bMsg2103		:= xMsg2103.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)


	(* W2114 preheating pump failure *)	
	(* release monitoring engine cooling water preheating pump *)
	xTON_ECWP_PreH_Mon(IN:= OUT_AG.tECWP_PreH_Dem.Do AND (NOT IN_AG.tECWP_Op.Di OR (NOT M_DREHZ AND Para.bECWP_MechDriven) OR (NOT bECWP_Op_DPr_Mon AND Para.bDPr_ECWP_Mon_Active)) AND IN_AG.tPB2MM.bSys_Run, PT:= T#10s);
	xTOF_ECWP_PreH_FS(IN:= IN_AG.tFS_ECW.Di, PT:= T#10s); (* flow switch only if water cooled turbo chargers, for TC cooldown *)

	HBT_5 := 	xTOF_ECWP_PreH_FS.Q OR (OUT_AG.tECWP_PreH_Dem.Do AND HBT_5)
		AND	(	NOT IN_AG.tECWP_Op.Di
			 OR	(NOT M_DREHZ AND Para.bECWP_MechDriven)
			 OR	(NOT bECWP_Op_DPr_Mon AND Para.bDPr_ECWP_Mon_Active)	); 

	xMsg2114.Enable	   := TRUE;
	xMsg2114.Set 	   := (xTON_ECWP_PreH_Mon.Q OR HBT_5) AND NOT xTOF_ECWP_PreH_FS.Q;
	xMsg2114.PT	       := T#0s;
	xMsg2114.Prio 	   := 4;
	xMsg2114.RiskClass := 4;
	xMsg2114.Reset	   := FALSE;
	xMsg2114();
	MM2VIS.bMsg2114    := xMsg2114.Q;


	(* W2118 failure charge cooler pump (A1091) *)	
	xTOF_CCWP_Fail(IN:= IN_AG.tCCWP_Op.Di OR bNoMon4BlackStart, PT:= T#10s);
	HBT_4 := xTOF_CCWP_Fail.Q OR (IN_AG.bEng_Aux_Dem AND HBT_4);

	xMsg2118.Enable	   := TRUE;
	IF NOT Para.bRedCCWP_Active THEN
		xMsg2118.Set   := (AT26 OR HBT_4) AND NOT xTOF_CCWP_Fail.Q;
	ELSE
		xMsg2118.Set   := bRedCCWP_Fail AND ((iRedCCWP_Fail = 1) OR (iRedCCWP_Fail = 3));
	END_IF;
	xMsg2118.PT	       := T#0s;
	xMsg2118.Prio 	   := 4;
	xMsg2118.RiskClass := 4;
	xMsg2118.Reset	   := FALSE;
	xMsg2118();
	MM2VIS.bMsg2118    := xMsg2118.Q;

	
	(* A2201 Engine turn equipment active (W9214)*)	
	xMsg2201.Enable	   := FALSE;//SWAT920/5
	xMsg2201.Set 	   := NOT IN_AG.tEngTurn.Di OR IN_AG.tEngTurn2.Di;
	xMsg2201.PT	       := T#0s;
	xMsg2201.Prio 	   := 2;
	xMsg2201.RiskClass := 4;
	xMsg2201.Reset	   := FALSE;
	xMsg2201();
	MM2VIS.bMsg2201    := xMsg2201.Q;


	(* A2213 Turbo charger oil filter differential pressure maximum *)
	xMsg2213.Enable    := TRUE;
	xMsg2213.Set       := M_DREHZ_5s AND NOT IN_AG.tPr_TCOF_EOF_DiffMax.Di;
	xMsg2213.PT        := T#10s;
	xMsg2213.Prio      := 3;
	xMsg2213.RiskClass := 4;
	xMsg2213.Reset     := FALSE;
	xMsg2213();
	MM2VIS.bMsg2213    := xMsg2213.Q;
	
	
	(* A2224 measuring signal failure pressure after turbocharger oil filter (W2433)*)
	xMsg2224.Enable	   := Para.bPr_TCOaF_Active AND NOT xEngType.Type9;//SWAT920/1
	xMsg2224.Set 	   := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_TC_EOF_After.GoodQual;
	xMsg2224.PT		   := T#0s;
	xMsg2224.Prio 	   := 3;
	xMsg2224.RiskClass := 4;
	xMsg2224.Reset	   := FALSE;
	xMsg2224();
	MM2VIS.bMsg2224    := xMsg2224.Q;
	
	
	(* A2233 oil pressure after turbocharger filter high *)
	IF xEngType.Type9 THEN	xGR_MAXR_Pr_TCO_hihi.In := tPr_TCLubOil_Max.Ai;
	ELSE					xGR_MAXR_Pr_TCO_hihi.In := IN_AG.tPr_TC_EOF_After.Ai;
	END_IF;
	xGR_MAXR_Pr_TCO_hihi(Gw:= Para.rPr_TCOF_Max, Hy:= Para.rPr_TCOF_HyMax);
	xTON_Pr_TCO_Mon(IN:= M_DREHZ, PT:= T#60s);

	xMsg2233.Enable		:= Para.bPr_TCOaF_Active OR Para.bPr_Oil_LPTC_In_A OR Para.bPr_Oil_LPTC_In_B OR Para.bPr_TCO_Active;
	IF xEngType.Type9 THEN
		xMsg2233.Set	:= xGR_MAXR_Pr_TCO_hihi.Q AND tPr_TCLubOil_Max.GoodQual AND xTON_Pr_TCO_Mon.Q;
		xMsg2233.PT		:= T#180s;//SWAT920/2.2
	ELSE
		xMsg2233.Set	:= xGR_MAXR_Pr_TCO_hihi.Q AND IN_AG.tPr_TC_EOF_After.GoodQual AND xTON_Pr_TCO_Mon.Q;
		xMsg2233.PT		:= T#5s;
	END_IF;
	xMsg2233.Prio		:= 3;
	xMsg2233.RiskClass	:= 4;
	xMsg2233.Reset		:= FALSE;
	xMsg2233();
	MM2VIS.bMsg2233		:= xMsg2233.Q;
	
	
	(* A2234 oil pressure after turbocharger filter low *)
	xMsg2234.Enable	   := Para.bPr_TCOaF_Active OR Para.bPr_Oil_LPTC_In_A OR Para.bPr_Oil_LPTC_In_B OR Para.bPr_TCO_Active;
	xMsg2234.Set       := OilPress_a_ATL_min_A;
	xMsg2234.PT		   := T#0s;
	xMsg2234.Prio	   := 2;
	xMsg2234.RiskClass := 4;
	xMsg2234.Reset	   := FALSE;
	xMsg2234();
	MM2VIS.bMsg2234	   := xMsg2234.Q;

	
	(* A2238 turbocharger pre-lube oil pressure low *)
	xR_TRIG_N_TCO_FS(CLK:= (IN_AG.rN_EngAct >= Para.rN_TCO_FS));

	xMsg2238.Enable	   := Para.bPr_TCOaF_Active OR Para.bPr_TCO_Active OR Para.bPr_Oil_LPTC_In_A OR Para.bPr_Oil_LPTC_In_B;
	IF IN_AG.bPermPreLube_Dem AND xEngType.Type9 THEN 
		xMsg2238.Set := (tPr_TCLubOil_Min.Ai < Para.rPr_TCO_FSPreL_LimLo) (* faststart with perm.prelubrication *)
                    AND xR_TRIG_N_TCO_FS.Q
					AND IN_AG.tPB2MM.bParaSetupOk
                    AND tPr_TCLubOil_Min.GoodQual; 
    ELSE            
		xMsg2238.Set := OilPress_a_ATL_min_A_prel
                    AND	(	(IN_AG.tPr_TC_EOF_After.GoodQual AND NOT xEngType.Type9)	 	(* standard *)
						 OR (tPr_TCLubOil_Min.GoodQual		 AND	 xEngType.Type9)	)
					AND NOT xTOF_ShortPreLubeTime_Delay.Q;	(* manual mode short prelubrication time with 3s off cycle delay *)
	END_IF;
	xMsg2238.PT	       := T#0s;
	xMsg2238.Prio	   := 2;
	xMsg2238.RiskClass := 4;
	xMsg2238.Reset	   := FALSE;
	xMsg2238();
	MM2VIS.bMsg2238    := xMsg2238.Q;
		

	(* A2242 Measuring signal failure oil pressure before oil filter *)
	xMsg2242.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg2242.Set 	   := bAMM_Pr_bEOF_Ms;
	xMsg2242.PT		   := T#10s;
	xMsg2242.Prio 	   := 3;
	xMsg2242.RiskClass := 4;
	xMsg2242.Reset	   := FALSE;
	xMsg2242();
	MM2VIS.bMsg2242    := xMsg2242.Q;
	
	
	(* A2260 Measuring signal failure oil pressure after oil filter (W2432)*)
	xMsg2260.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg2260.Set 	   := bAMM_Pr_aEOF_Ms AND bAMM_Pr_EngLubOil_Ms; //SWAT920/5
	xMsg2260.PT		   := T#0s;
	xMsg2260.Prio 	   := 3;
	xMsg2260.RiskClass := 4;
	xMsg2260.Reset	   := FALSE;
	xMsg2260();
	MM2VIS.bMsg2260	   := xMsg2260.Q;
	
	
	(* A2263 preheating flap position signal failure (W2431) *)	
	xMsg2263.Enable	   := xEngType.Type9 AND bECW_PreHV_Active AND FALSE;//SWAT920/1
	xMsg2263.Set 	   :=  (    IN_AG.tECW_PreHV_Opened.Di   AND     IN_AG.tECW_PreHV_Closed.Di) 
						OR (NOT IN_AG.tECW_PreHV_Opened.Di   AND NOT IN_AG.tECW_PreHV_Closed.Di) 
						OR (    OUT_AG.tECW_PreHV_CoOpen.Do  AND NOT IN_AG.tECW_PreHV_Opened.Di) 
						OR (    OUT_AG.tECW_PreHV_CoClose.Do AND NOT IN_AG.tECW_PreHV_Closed.Di);
	xMsg2263.PT	       := T#60s;
	xMsg2263.Prio 	   := 2;
	xMsg2263.RiskClass := 4;
	xMsg2263.Reset	   := FALSE;
	xMsg2263();
	MM2VIS.bMsg2263    := xMsg2263.Q;

	
	(* A2264 engine cooling water preheating temperature high M.04-TI-026*)	
	xMsg2264.Enable	   := xEngType.Type9;
	xMsg2264.Set 	   := IN_AG.tT_ECW_PreH_HiHi.Di;	// AND OUT_AG.tECW_PreH_Dem.Do;//ex SWAT920/1
	xMsg2264.PT	       := T#0s;
	xMsg2264.Prio 	   := 3;
	xMsg2264.RiskClass := 4;
	xMsg2264.Reset	   := FALSE;
	xMsg2264();
	MM2VIS.bMsg2264    := xMsg2264.Q;

	
	(* A2265 engine oil preheating temperature high (W2423)*)
	xMsg2265.Enable	   := xEngType.Type9;	// AND FALSE;//ex SWAT920/1
	xMsg2265.Set       := IN_AG.tT_EO_PreH_HiHi.Di;
	xMsg2265.PT		   := T#0s;
	xMsg2265.Prio	   := 3;
	xMsg2265.RiskClass := 4;
	xMsg2265.Reset	   := FALSE;
	xMsg2265();
	MM2VIS.bMsg2265	   := xMsg2265.Q;


	(*	A2266 Anlaufstörung Wasserschlag	-	Start up failure hydraulic shock	*)	
	xMsg2266.Enable	   := FALSE;//SWAT920/5
	xMsg2266.Set	   := FALSE;//bAMM_AirStarter_StartUpHyd AND NOT MM2VIS.bMsg2557;//SWAT920/2 
	xMsg2266.PT		   := T#0s; 	
	xMsg2266.Prio	   := 3;
	xMsg2266.RiskClass := 4;
 	xMsg2266.Reset	   := FALSE; 	
	xMsg2266();	
	MM2VIS.bMsg2266	   := xMsg2266.Q;


	(*	A2267 Luftstarter Versorgungsdruck Maximum	-	Air starter supply pressure high	*)	
	xMsg2267.Enable	   := TRUE;//deactivated by SWAT920/1 - REACTIVATED for new air starter design
	xMsg2267.Set	   := bAMM_Pr_AirStarter_Supply_HiHi;	
	xMsg2267.PT		   := T#1s; 		
	xMsg2267.Prio	   := 3; 	
	xMsg2267.RiskClass := 4;
 	xMsg2267.Reset	   := FALSE; 	
	xMsg2267();	
	MM2VIS.bMsg2267	   := xMsg2267.Q;


	(*	A2268 Luftstarter Kesseldruck Minimum	-	Air starter tank pressure low	*)
	xMsg2268.Enable	   := Para.bPr_AirStarter_Tank_Exist;
	xMsg2268.Set	   := bAMM_Pr_AirStarter_Tank_LoLo AND NOT MM2VIS.bMsg2559;//SWAT920/2
	xMsg2268.PT		   := T#1s; 		
	xMsg2268.Prio	   := 3;
	xMsg2268.RiskClass := 4;
 	xMsg2268.Reset	   := FALSE; 	
	xMsg2268();	
	MM2VIS.bMsg2268    := xMsg2268.Q;


	(*	A2269 Luftstarter Versorgungsdruck Minimum	-	Air starter supply pressure low	*)	
	xMsg2269.Enable	   := Para.bPr_AirStarter_Supply_Exist;
	xMsg2269.Set	   := bAMM_Pr_AirStarter_Supply_LoLo AND NOT MM2VIS.bMsg2557;//SWAT920/2
	xMsg2269.PT		   := T#1s; 		
	xMsg2269.Prio	   := 3;
	xMsg2269.RiskClass := 4;
	xMsg2269.Reset	   := FALSE;
	xMsg2269();	
	MM2VIS.bMsg2269	   := xMsg2269.Q;


	(* A2284 level engine oil sump high *)
	xMsg2284.Enable	   := TRUE;
	xMsg2284.Set 	   := NOT IN_AG.tL_OilSumpHi.Di OR NOT IN_AG.tL_OilSump2Hi.Di OR NOT IN_AG.tL_OilSump3Hi.Di;
	xMsg2284.PT	       := T#10s;
	xMsg2284.Prio 	   := 3;
	xMsg2284.RiskClass := 4;
	xMsg2284.Reset 	   := FALSE;
	xMsg2284();
	MM2VIS.bMsg2284    := xMsg2284.Q;

	(* A2291 pressure engine oil after pump high *)
	xMsg2291.Enable	   := Para.bPr_EOaP_Active;
	xMsg2291.Set 	   := IN_AG.tPr_EOaP.Ai > Para.rPr_EOaP_LimHiHi;
	xMsg2291.PT	       := T#0s;
	xMsg2291.Prio 	   := 2;
	xMsg2291.RiskClass := 4;
	xMsg2291.Reset 	   := FALSE;
	xMsg2291();
	MM2VIS.bMsg2291    := xMsg2291.Q;

	(* A2292 pressure engine oil after pump high (safety switch)*)
	xMsg2292.Enable	   := TRUE;
	xMsg2292.Set 	   := IN_AG.tPS_EOaP_HiHi.Di;
	xMsg2292.PT	       := T#0s;
	xMsg2292.Prio 	   := 2;
	xMsg2292.RiskClass := 4;
	xMsg2292.Reset 	   := FALSE;
	xMsg2292();
	MM2VIS.bMsg2292    := xMsg2292.Q;

	(* A2304 Oil pressure before oil filter maximum *)
	xMsg2304.Enable	   := xEngType.Type9 AND Para.b_EOF_DiffMonActive AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg2304.Set       := IN_AG.tPr_EOF_DiffMon.Ai > Para.rPr_EObF_LimHiHi;
	xMsg2304.PT		   := T#0s;
	xMsg2304.Prio	   := 1;
	xMsg2304.RiskClass := 4;
	xMsg2304.Reset	   := FALSE;
	xMsg2304();
	MM2VIS.bMsg2304	   := xMsg2304.Q;

	(* A2332 Boiler failure *)
	xMsg2332.Enable	   := TRUE;
	xMsg2332.Set       := NOT IN_AG.tBoilerFailure.Di;
	xMsg2332.PT		   := T#1s;
	xMsg2332.Prio	   := 2;
	xMsg2332.RiskClass := 4;
	xMsg2332.Reset	   := FALSE;
	xMsg2332();
	MM2VIS.bMsg2332	   := xMsg2332.Q;

	(* A2333 Seismic alarm *)
	xMsg2333.Enable	   := TRUE;
	xMsg2333.Set       := NOT IN_AG.tSeismicAlarm.Di;
	xMsg2333.PT		   := T#1s;
	xMsg2333.Prio	   := 2;
	xMsg2333.RiskClass := 4;
	xMsg2333.Reset	   := FALSE;
	xMsg2333();
	MM2VIS.bMsg2333	   := xMsg2333.Q;

	(* A2348 auxiliaries power supply circuit breaker module control panel tripped *)
	xMsg2348.Enable	   := TRUE;
	xMsg2348.Set       := NOT IN_AG.tMCP_AuxPS_CB_Trip.Di;
	xMsg2348.PT		   := T#0s;
	xMsg2348.Prio	   := 2;
	xMsg2348.RiskClass := 4;
	xMsg2348.Reset	   := FALSE;
	xMsg2348();
	MM2VIS.bMsg2348	   := xMsg2348.Q;

	(* A2349 auxiliaries power supply circuit breaker module control panel opened *)
	xMsg2349.Enable	   := TRUE;
	xMsg2349.Set       := NOT IN_AG.tMCP_AuxPS_CB_On.Di;
	xMsg2349.PT		   := T#0s;
	xMsg2349.Prio	   := 2;
	xMsg2349.RiskClass := 4;
	xMsg2349.Reset	   := FALSE;
	xMsg2349();
	MM2VIS.bMsg2349	   := xMsg2349.Q;

	(* A2350 Earth fault auxiliaries power supply module control panel *)
	xMsg2350.Enable	   := TRUE;
	xMsg2350.Set       := NOT IN_AG.tMCP_AuxPS_GndFault.Di;
	xMsg2350.PT		   := T#0s;
	xMsg2350.Prio	   := 2;
	xMsg2350.RiskClass := 4;
	xMsg2350.Reset	   := FALSE;
	xMsg2350();
	MM2VIS.bMsg2350	   := xMsg2350.Q;

	(* A2351 Earth fault frequency converter module control panel *)
	xMsg2351.Enable	   := TRUE;
	xMsg2351.Set       := NOT IN_AG.tMCP_FC_GndFault.Di;
	xMsg2351.PT		   := T#0s;
	xMsg2351.Prio	   := 2;
	xMsg2351.RiskClass := 4;
	xMsg2351.Reset	   := FALSE;
	xMsg2351();
	MM2VIS.bMsg2351	   := xMsg2351.Q;

	(* A2352 Earth fault frequency converter module interface panel *)
	xMsg2352.Enable	   := TRUE;
	xMsg2352.Set       := NOT IN_AG.tMIP_FC_GndFault.Di;
	xMsg2352.PT		   := T#0s;
	xMsg2352.Prio	   := 2;
	xMsg2352.RiskClass := 4;
	xMsg2352.Reset	   := FALSE;
	xMsg2352();
	MM2VIS.bMsg2352	   := xMsg2352.Q;

	(* A2353 Earth fault frequency converter auxiliaries control panel*)
	xMsg2353.Enable	   := TRUE;
	xMsg2353.Set       := NOT IN_AG.tAuxCP_FC_GndFault.Di;
	xMsg2353.PT		   := T#0s;
	xMsg2353.Prio	   := 2;
	xMsg2353.RiskClass := 4;
	xMsg2353.Reset	   := FALSE;
	xMsg2353();
	MM2VIS.bMsg2353	   := xMsg2353.Q;

	(* A2355 Earth fault auxiliaries power supply auxiliaries control panel*)
	xMsg2355.Enable	   := TRUE;
	xMsg2355.Set       := NOT IN_AG.tAuxCP_AuxPS_GndFault.Di;
	xMsg2355.PT		   := T#0s;
	xMsg2355.Prio	   := 2;
	xMsg2355.RiskClass := 4;
	xMsg2355.Reset	   := FALSE;
	xMsg2355();
	MM2VIS.bMsg2355	   := xMsg2355.Q;

	(* A2359 auxiliaries power supply circuit breaker auxiliaries control panel tripped *)
	xMsg2359.Enable	   := TRUE;
	xMsg2359.Set       := NOT IN_AG.tAuxCP_AuxPS_CB_Trip.Di;
	xMsg2359.PT		   := T#0s;
	xMsg2359.Prio	   := 2;
	xMsg2359.RiskClass := 4;
	xMsg2359.Reset	   := FALSE;
	xMsg2359();
	MM2VIS.bMsg2359	   := xMsg2359.Q;

	(* A2360 auxiliaries power supply circuit breaker auxiliaries control panel opened *)
	xMsg2360.Enable	   := TRUE;
	xMsg2360.Set       := NOT IN_AG.tAuxCP_AuxPS_CB_On.Di;
	xMsg2360.PT		   := T#0s;
	xMsg2360.Prio	   := 2;
	xMsg2360.RiskClass := 4;
	xMsg2360.Reset	   := FALSE;
	xMsg2360();
	MM2VIS.bMsg2360	   := xMsg2360.Q;
	
	(* A2361 Leakage in additional external oil tank *)
	xMsg2361.Enable	   := TRUE;
	xMsg2361.Set       := NOT IN_AG.tLeak_OilExtensionTank1.Di OR NOT IN_AG.tLeak_OilExtensionTank2.Di OR NOT IN_AG.tLeak_OilExtensionTank3.Di;
	xMsg2361.PT		   := T#5s;
	xMsg2361.Prio	   := 3;
	xMsg2361.RiskClass := 4;
	xMsg2361.Reset	   := FALSE;
	xMsg2361();
	MM2VIS.bMsg2361	   := xMsg2361.Q;

	(* A2376 Purge cranking cycle unsuccessful *)
	IF IN_AG.tAB2AG.bResetTrip AND (bStartScavUnsfl OR bFail_PurgeCrk) THEN 		(* trip acknowledged *)
		bStartScavUnsfl		:= FALSE;
		bStartScavFail		:= FALSE;							(* variable reset to avoid trip loop *)
		bFail_PurgeCrk		:= FALSE;
		bMsg2376_T6_set		:= FALSE;
	END_IF;
	
	xMsg2376.Enable	   := TRUE;
	xMsg2376.Set 	   := (bStartScavUnsfl AND xEngType.Type3) OR (bMsg2376_T6_set AND xEngType.Type6);
	xMsg2376.PT	       := T#0s;
	xMsg2376.Prio 	   := 2;
	xMsg2376.RiskClass := 4;
	xMsg2376.Reset	   := FALSE;
	xMsg2376();
	MM2VIS.bMsg2376    := xMsg2376.Q;

	(* A2377 Measuring signal failure voltage start motor 1 *)
	xTON_EleStarter_Dem	(IN := OUT_AG.tEleStarter_Dem.Do, PT:= Para.tiStarterFunDuration);			(* Starter MSF detection after starter demand *)
	xRT_EleStarter_Dem	(CLK:= xTON_EleStarter_Dem.Q);												(* Starter MSF detection trigger *)

	xMsg2377.Enable		:= IN_AG.tU_Starter_engage1.GoodQual AND Para.rU_StarterMon_LimLo <> 0.0;
	xMsg2377.Set		:= xRT_EleStarter_Dem.Q AND IN_AG.tU_Starter_engage1.Ai < 5.0;				(* starter terminal 45 voltage below 5V *)
	xMsg2377.PT			:= T#0s;
	xMsg2377.Prio		:= 2;
	xMsg2377.RiskClass	:= 4;
	xMsg2377.Reset		:= FALSE;
	xMsg2377();
	MM2VIS.bMsg2377		:= xMsg2377.Q;

	(* A2378 Measuring signal failure voltage start motor 2 *)
	xMsg2378.Enable		:= IN_AG.tU_Starter_engage2.GoodQual AND Para.rU_StarterMon_LimLo <> 0.0;
	xMsg2378.Set		:= xRT_EleStarter_Dem.Q AND IN_AG.tU_Starter_engage2.Ai < 5.0;
	xMsg2378.PT			:= T#0s;
	xMsg2378.Prio		:= 2;
	xMsg2378.RiskClass	:= 4;
	xMsg2378.Reset		:= FALSE;
	xMsg2378();
	MM2VIS.bMsg2378		:= xMsg2378.Q;

	(* A2379 Measuring signal failure voltage start motor 3 *)
	xMsg2379.Enable		:= IN_AG.tU_Starter_engage3.GoodQual AND Para.rU_StarterMon_LimLo <> 0.0;
	xMsg2379.Set		:= xRT_EleStarter_Dem.Q AND IN_AG.tU_Starter_engage3.Ai < 5.0;
	xMsg2379.PT			:= T#0s;
	xMsg2379.Prio		:= 2;
	xMsg2379.RiskClass	:= 4;
	xMsg2379.Reset		:= FALSE;
	xMsg2379();
	MM2VIS.bMsg2379		:= xMsg2379.Q;

	(* A2382 Start attempt failed minimum speed *)
	IF IN_AG.tAB2AG.bResetTrip AND bFail_StartAtt THEN 		(* trip acknowledged *)
		bFail_StartAtt := FALSE;
		bMsg2382_set := FALSE;
	END_IF;
	
	xMsg2382.Enable	   := TRUE;
	xMsg2382.Set 	   := bMsg2382_set AND xEngType.Type6;
	xMsg2382.PT	       := T#0s;
	xMsg2382.Prio 	   := 2;
	xMsg2382.RiskClass := 4;
	xMsg2382.Reset	   := FALSE;
	xMsg2382();
	MM2VIS.bMsg2382    := xMsg2382.Q;

	(* W2421 Oil pressure before oil filter maximum *)
	xMsg2421.Enable	   := xEngType.Type9 AND Para.b_EOF_DiffMonActive AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg2421.Set       := IN_AG.tPr_EOF_DiffMon.Ai > Para.rPr_EObF_LimHi;
	xMsg2421.PT		   := T#0s;
	xMsg2421.Prio	   := 4;
	xMsg2421.RiskClass := 4;
	xMsg2421.Reset	   := FALSE;
	xMsg2421();
	MM2VIS.bMsg2421	   := xMsg2421.Q;
	
	(* W2422 Oil filter maintenance (oil filter unit) *)
	xMsg2422.Enable	   := TRUE;
	xMsg2422.Set       := bAMM_DPr_OFU_Filt_HiHi;
	xMsg2422.PT		   := T#0s;
	xMsg2422.Prio	   := 4;
	xMsg2422.RiskClass := 4;
	xMsg2422.Reset	   := FALSE;
	xMsg2422();
	MM2VIS.bMsg2422	   := xMsg2422.Q;

	(* W2423 engine oil preheating temperature high high(A2265)*)
	xMsg2423.Enable	   := xEngType.Type9 AND FALSE;	//SWATex 920/1
	xMsg2423.Set       := IN_AG.tT_EO_PreH_HiHi.Di;
	xMsg2423.PT		   := T#0s;
	xMsg2423.Prio	   := 4;
	xMsg2423.RiskClass := 4;
	xMsg2423.Reset	   := FALSE;
	xMsg2423();
	MM2VIS.bMsg2423	   := xMsg2423.Q;
	
	(* W2424 turning fly wheel during engagement *)
	xMsg2424.Enable	   := FALSE;//SWAT920/5  //SWAT920/2
	xMsg2424.Set       := FALSE;//bAMM_AirStarter_PrReducer;
	xMsg2424.PT		   := T#0s;
	xMsg2424.Prio	   := 4;
	xMsg2424.RiskClass := 4;
	xMsg2424.Reset	   := FALSE;
	xMsg2424();
	MM2VIS.bMsg2424	   := xMsg2424.Q;
	
	(* W2425 air starter engaging error - no air pressure at pressure switch *)
	xMsg2425.Enable	   := xEngType.Type9;//SWAT920/2
	xMsg2425.Set       := bAMM_Pr_AirST_Engage_Lo;
	xMsg2425.PT		   := T#0s;
	xMsg2425.Prio	   := 4;
	xMsg2425.RiskClass := 4;
	xMsg2425.Reset	   := FALSE;
	xMsg2425();
	MM2VIS.bMsg2425	   := xMsg2425.Q;
	
	(* W2426 start speed pickup signal missing *)
	xMsg2426.Enable	   := FALSE;//SWAT920/5  //SWAT920/2
	xMsg2426.Set       := FALSE;//bAMM_AirStarter_PickupFailure;
	xMsg2426.PT		   := T#0s;
	xMsg2426.Prio	   := 4;
	xMsg2426.RiskClass := 4;
	xMsg2426.Reset	   := FALSE;
	xMsg2426();
	MM2VIS.bMsg2426	   := xMsg2426.Q;
	
	(* W2427 Engine oil pressure low - During permanent pre-lubrication or pre-heating *)
	xMsg2427.Enable	   := TRUE;
	xMsg2427.Set       := IN_AG.tPB2MM.bParaSetupOk
                      AND ((bPreLubeDemFS OR bPreHeatDem)
                      AND(IN_AG.tPr_EngLubOil.Ai < Para.rPr_EO_FSPreL_LimLo)) OR bAMM_MaxDC_Time;
	IF bAMM_MaxDC_Time
	THEN
		xMsg2427.PT	   := T#0s;
	ELSE
		xMsg2427.PT	   := T#100s;
	END_IF
	xMsg2427.Prio	   := 4;
	xMsg2427.RiskClass := 4;
	xMsg2427.Reset	   := FALSE;
	xMsg2427();
	MM2VIS.bMsg2427	   := xMsg2427.Q;

	(* W2431 preheating flap position signal failure (A2263) *)	
	xMsg2431.Enable	   := xEngType.Type9 AND bECW_PreHV_Active;//SWAT920/1
	xMsg2431.Set 	   :=  (    IN_AG.tECW_PreHV_Opened.Di   AND     IN_AG.tECW_PreHV_Closed.Di) 
						OR (NOT IN_AG.tECW_PreHV_Opened.Di   AND NOT IN_AG.tECW_PreHV_Closed.Di) 
						OR (    OUT_AG.tECW_PreHV_CoOpen.Do  AND NOT IN_AG.tECW_PreHV_Opened.Di) 
						OR (    OUT_AG.tECW_PreHV_CoClose.Do AND NOT IN_AG.tECW_PreHV_Closed.Di);
	xMsg2431.PT	       := T#60s;
	xMsg2431.Prio 	   := 4;
	xMsg2431.RiskClass := 4;
	xMsg2431.Reset	   := FALSE;
	xMsg2431();
	MM2VIS.bMsg2431    := xMsg2431.Q;
	
	(* W2432 Measuring signal failure oil pressure after oil filter (A2260)*)
	xMsg2432.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg2432.Set 	   := bAMM_Pr_aEOF_Ms;
	xMsg2432.PT		   := T#0s;
	xMsg2432.Prio 	   := 4;
	xMsg2432.RiskClass := 4;
	xMsg2432.Reset	   := FALSE;
	xMsg2432();
	MM2VIS.bMsg2432	   := xMsg2432.Q;
	
	(* W2433 measuring signal failure pressure after turbocharger oil filter (A2224)*)
	xMsg2433.Enable	   := Para.bPr_TCOaF_Active;//SWAT920/1
	xMsg2433.Set 	   := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_TC_EOF_After.GoodQual;
	xMsg2433.PT		   := T#0s;
	xMsg2433.Prio 	   := 4;
	xMsg2433.RiskClass := 4;
	xMsg2433.Reset	   := FALSE;
	xMsg2433();
	MM2VIS.bMsg2433    := xMsg2433.Q;

	(* W2434 turbo charger oil valve failure (turbo charger oil pressure high during permanent prelubrication) *)
	xMsg2434.Enable	   := xEngType.Type9;
	xMsg2434.Set 	   := IN_AG.tPB2MM.bParaSetupOk
				  AND     bPreLubeDemFS
				  AND NOT bOCTC_CoDoRun
                  AND NOT M_DREHZ
                  AND    (tPr_TCLubOil_Max.Ai > Para.rPr_TCO_FSPreL_LimHi) (* pref.: M.03-PI-101/201 / else: M.03-PI-063/062 *)
                  AND     tPr_TCLubOil_Max.GoodQual;
	xMsg2434.PT		   := T#100s;
	xMsg2434.Prio 	   := 4;
	xMsg2434.RiskClass := 4;
	xMsg2434.Reset	   := FALSE;
	xMsg2434();
	MM2VIS.bMsg2434	   := xMsg2434.Q;

	(* W2435 engine oil level high (A1051) *)//SWAT920/2.2
	xMsg2435.Enable	   := TRUE;
	xMsg2435.Set 	   := bEO_Level_W_Hi OR (xEngType.Type9 AND bEO_Level_Hi AND IN_AG.rN_EngAct < 900);
	xMsg2435.PT		   := T#10s;
	xMsg2435.Prio	   := 4;
	xMsg2435.RiskClass := 4;
	xMsg2435.Reset	   := FALSE;
	xMsg2435();
	MM2VIS.bMsg2435	   := xMsg2435.Q;

	(* W2459 measuring signal failure turbocharger oil pressure *)
	xMsg2459.Enable	   := Para.bPr_TCO_Active;
	xMsg2459.Set 	   := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_TCO.GoodQual;
	xMsg2459.PT		   := T#0s;
	xMsg2459.Prio 	   := 4;
	xMsg2459.RiskClass := 4;
	xMsg2459.Reset	   := FALSE;
	xMsg2459();
	MM2VIS.bMsg2459    := xMsg2459.Q;
	
	(* W2473 starter battery voltage maximum *)	
	xMsg2473.Enable	   := IN_AG.tPB2MM.bSys_Run;
	xMsg2473.Set 	   := xTON_StarterBat_Hi.Q;
	xMsg2473.PT	       := T#0s;
	xMsg2473.Prio 	   := 4;
	xMsg2473.RiskClass := 4;
	xMsg2473.LockReset := IN_AG.tEng_Run.Do;
	xMsg2473();
	MM2VIS.bMsg2473    := xMsg2473.Q;
	

	(* W2475 Maintenance interval prelubrication pump *)	
	xMsg2475.Enable	   := IN_AG.tPB2MM.bSys_Run AND Para.bEOP_DC_Visible AND IN_AG.tEOP_BWS.GoodQual AND NOT OUT_AG.tEOP1DC_Dem.Do;
	xMsg2475.Set 	   := NOT(IN_AG.tEOP_BWS.Di AND IN_AG.tEOP_BWS2.Di);
	xMsg2475.PT	       := T#10s;
	xMsg2475.Prio 	   := 4;
	xMsg2475.RiskClass := 4;
	xMsg2475.Reset	   := FALSE;
	xMsg2475();
	MM2VIS.bMsg2475    := xMsg2475.Q;

	(* W2524 engine oil preheating temperature min / no start release *)
	GR_MIN_OIL_STARTFG(In:= OUT_AG.rT_EO_PreH, Gw:= Para.rT_EO_LimMin, Hy:= Para.rT_EO_LimHyMin);
	xMsg2524.Enable	   := xEngType.Type9 AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg2524.Set       := GR_MIN_OIL_STARTFG.Q;
	xMsg2524.PT		   := T#100s;
	xMsg2524.Prio	   := 4;
	xMsg2524.RiskClass := 4;
	xMsg2524.Reset	   := FALSE;
	xMsg2524();
	MM2VIS.bMsg2524	   := xMsg2524.Q;
	OUT_AG.bMsg2524    := xMsg2524.Q;
	
	
	(* W2534 Oil filter differential pressure maximum *) 			(* --> NOT USED *)
	xMsg2534.Enable	   := FALSE;	
	xMsg2534.Set       := FALSE;
	xMsg2534.PT		   := T#0s;
	xMsg2534.Prio	   := 4;
	xMsg2534.RiskClass := 4;
	xMsg2534.Reset	   := FALSE;
	xMsg2534();
	MM2VIS.bMsg2534	   := xMsg2534.Q;
		
	
	(* W2545 startup failure starter *)				(* --> NOT USED *)
	xMsg2545.Enable	   := FALSE;
	xMsg2545.Set 	   := FALSE;
	xMsg2545.PT	       := T#0s;
	xMsg2545.Prio 	   := 4;
	xMsg2545.RiskClass := 4;
	xMsg2545.Reset	   := FALSE;
	xMsg2545();
	MM2VIS.bMsg2545    := xMsg2545.Q;

	
	(* W2554 pressure after turbocharger oil filter low *)
	IF xEngType.Type9 THEN	xGR_MIN_Pr_TCO_Lo.In :=	tPr_TCLubOil_Min.Ai;
	ELSE					xGR_MIN_Pr_TCO_Lo.In :=	IN_AG.tPr_TC_EOF_After.Ai;
	END_IF;
	xGR_MIN_Pr_TCO_Lo(Gw:= Para.rPr_TCOF_MinWarn, Hy:= Para.rPr_TCOF_HyMinWarn);
	
	xMsg2554.Enable	   := 	Para.bPr_TCOaF_Active OR Para.bPr_Oil_LPTC_In_A OR Para.bPr_Oil_LPTC_In_B OR Para.bPr_TCO_Active;
	xMsg2554.Set       :=	xGR_MIN_Pr_TCO_Lo.Q
						AND	(IN_AG.rN_EngAct > (Para.rN_EngNom - 5))
						AND	(	(IN_AG.tPr_TC_EOF_After.GoodQual AND NOT xEngType.Type9)	 	(* standard *)
						 	 OR (tPr_TCLubOil_Min.GoodQual		 AND	 xEngType.Type9)	);
	xMsg2554.PT		   := T#1s;
	xMsg2554.Prio	   := 4;
	xMsg2554.RiskClass := 4;
	xMsg2554.Reset	   := FALSE;
	xMsg2554();
	MM2VIS.bMsg2554	   := xMsg2554.Q;		
	
	(* W2557 Messsignalstörung Luftstarter Versorgungsdruck	- Measuring signal failure air starter supply pressure (A3370) *)	
	xMsg2557.Enable    := TRUE; //SWAT920/2.2
	xMsg2557.Set       := bAMM_Pr_AirStarter_Supply_MsMs;	
	xMsg2557.PT        := T#1s; 		
	xMsg2557.Prio      := 4;
	xMsg2557.RiskClass := 4;
	xMsg2557.Reset     := FALSE;
 	xMsg2557();	
	MM2VIS.bMsg2557    := xMsg2557.Q;
	
	(* W2558 crank case pressure high *)	
	xMsg2558.Enable	   := TRUE;
	xMsg2558.Set 	   := bAMM_Pr_CC_Hi;
	xMsg2558.PT	       := Para.tiPr_CC_HiWarn;
	xMsg2558.Prio 	   := 4;
	xMsg2558.RiskClass := 4;
	xMsg2558.Reset	   := FALSE;
	xMsg2558();
	MM2VIS.bMsg2558    := xMsg2558.Q;


	(*W2559 Messsignalstörung Luftstarter Kesseldruck	-	Measuring signal failure air starter tank pressure	*)
	xMsg2559.Enable	:=	TRUE ;
	xMsg2559.Set	:=	bAMM_Pr_AirStarter_Tank_Ms;
	xMsg2559.PT		:=	T#1s; 		
	xMsg2559.Prio	:=	4; 	
	xMsg2559.Reset	:=	FALSE; 	
	xMsg2559();	
	MM2VIS.bMsg2559	:=	xMsg2559.Q;


	(*W2560 Luftstarter Kesseldruck Minimum	-	Air starter tank pressure low	*)	
	xMsg2560.Enable	:=	TRUE;	
	xMsg2560.Set	:=	bAMM_Pr_AirStarter_Tank_Lo;	
	xMsg2560.PT		:=	T#1s; 		
	xMsg2560.Prio	:=	4; 	
	xMsg2560.Reset	:=	FALSE;
	xMsg2560();	
	MM2VIS.bMsg2560 := xMsg2560.Q;

	
	(* W2571 failure over voltage protection auxiliaries power supply *)
	xMsg2571.Enable	   := TRUE;
	xMsg2571.Set 	   := NOT IN_AG.tAuxOverVoltProt_Ok.Di;
	xMsg2571.PT	       := T#0s;
	xMsg2571.Prio 	   := 4;
	xMsg2571.RiskClass := 4;
	xMsg2571.Reset	   := FALSE;
	xMsg2571();
	MM2VIS.bMsg2571    := xMsg2571.Q;


	(* W2572 failure uninterrupted power supply *)
	xMsg2572.Enable	   := TRUE;
	xMsg2572.Set 	   := NOT IN_AG.tUPS_Ok.Di;
	xMsg2572.PT	       := T#0s;
	xMsg2572.Prio 	   := 4;
	xMsg2572.RiskClass := 4;
	xMsg2572.Reset	   := FALSE;
	xMsg2572();
	MM2VIS.bMsg2572    := xMsg2572.Q;


	(* W2576 signal failure oilfill level *)
	xMsg2576.Enable	   := Para.bEO_Level_Active;
	xMsg2576.Set 	   := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tEO_Level.GoodQual;
	xMsg2576.PT		   := T#0s;
	xMsg2576.Prio 	   := 4;
	xMsg2576.RiskClass := 4;
	xMsg2576.Reset	   := FALSE;
	xMsg2576();
	MM2VIS.bMsg2576    := xMsg2576.Q;
	

	(* W2579 Oilpressure min for oilpreheating  *)	
	xTON_OilPreH_Of(IN:= (IN_AG.tPr_EngLubOil.Ai < Para.rPr_LimHeatRel) AND VORW_OIL, PT:= T#2m);
	xTON_OilPreH_On(IN:= (IN_AG.tPr_EngLubOil.Ai < Para.rPr_LimHeatRel) AND OUT_AG.tEO_Preheat1.Do, PT:= T#40s);

	xMsg2579.Enable	   := xEngType.Type9;
	xMsg2579.Set       := xTON_OilPreH_Of.Q OR xTON_OilPreH_On.Q;
	xMsg2579.PT		   := T#0s;
	xMsg2579.Prio	   := 4;
	xMsg2579.RiskClass := 4;
	xMsg2579.Reset	   := FALSE;
	xMsg2579();
	MM2VIS.bMsg2579	   := xMsg2579.Q;
	

	(* W2582 Pump switchover: cooldown oil pressure not achieved  *)
	xMsg2582.Enable	   := TRUE;
	xMsg2582.Set       := ODR_NKUEHL;
	xMsg2582.PT		   := T#10s;
	xMsg2582.Prio	   := 4;
	xMsg2582.RiskClass := 4;
	xMsg2582.Reset	   := FALSE;
	xMsg2582();
	MM2VIS.bMsg2582	   := xMsg2582.Q;
	
		
	(* W2587 signal failure oil quality sensor - Not used anymore *)
	xMsg2587.Enable	   := FALSE;
	xMsg2587.Set       := FALSE;
	xMsg2587.PT		   := T#0s;
	xMsg2587.Prio	   := 4;
	xMsg2587.RiskClass := 4;
	xMsg2587.Reset	   := FALSE;
	xMsg2587();
	MM2VIS.bMsg2587	   := xMsg2587.Q;
	
		
	(* W2589 engine cooling water preheating temperature high M.04-TI-081*)	
	xMsg2589.Enable	   := xEngType.Type9;
	xMsg2589.Set 	   := IN_AG.tT_ECW_PreH_Hi.Di;
	xMsg2589.PT	       := T#0s;
	xMsg2589.Prio 	   := 4;
	xMsg2589.RiskClass := 4;
	xMsg2589.Reset	   := FALSE;
	xMsg2589();
	MM2VIS.bMsg2589    := xMsg2589.Q;

	
	(* W2590 engine oil pre heating temperature high *)	
	xMsg2590.Enable	   := xEngType.Type9;
	xMsg2590.Set 	   := IN_AG.tT_EO_PreH_Hi.Di;
	xMsg2590.PT	       := T#0s;
	xMsg2590.Prio 	   := 4;
	xMsg2590.RiskClass := 4;
	xMsg2590.Reset	   := FALSE;
	xMsg2590();
	MM2VIS.bMsg2590    := xMsg2590.Q;
	
	(* W2591 blowby fan speed high *)	
	xMsg2591.Enable	   := TRUE;
	xMsg2591.Set 	   := bAMM_Pc_BbBlower_Hi AND IN_AG.tAuxV_Eng_ok.Di;
	xMsg2591.PT	       := T#60s;
	xMsg2591.Prio 	   := 4;
	xMsg2591.RiskClass := 4;
	xMsg2591.Reset	   := FALSE;
	xMsg2591();
	MM2VIS.bMsg2591    := xMsg2591.Q;

	(* W2592 blowby fan speed low *)		(* --> NOT USED *)	
	xMsg2592.Enable	   := FALSE;
	xMsg2592.Set 	   := FALSE;
	xMsg2592.PT	       := T#0s;
	xMsg2592.Prio 	   := 4;
	xMsg2592.RiskClass := 4;
	xMsg2592.Reset	   := FALSE;
	xMsg2592();
	MM2VIS.bMsg2592    := xMsg2592.Q;

	(* W2594 control voltage low - engine *)	
	xMsg2594.Enable	   := TRUE;
	xMsg2594.Set 	   := NOT IN_AG.tCV_Eng_Low.Di;
	xMsg2594.PT	       := T#60s;
	xMsg2594.Prio 	   := 4;
	xMsg2594.RiskClass := 4;
	xMsg2594.Reset	   := FALSE;
	xMsg2594();
	MM2VIS.bMsg2594    := xMsg2594.Q;

	(* W2595 control voltage low - turbo charger aux. *)	
	xMsg2595.Enable	   := TRUE;
	xMsg2595.Set 	   := NOT IN_AG.tCV_TCA_Low.Di;
	xMsg2595.PT	       := T#60s;
	xMsg2595.Prio 	   := 4;
	xMsg2595.RiskClass := 4;
	xMsg2595.Reset	   := FALSE;
	xMsg2595();
	MM2VIS.bMsg2595    := xMsg2595.Q;

	(* W2596 control voltage low - module control panel *)	
	xMsg2596.Enable	   := TRUE;
	xMsg2596.Set 	   := NOT IN_AG.tCV_MCP_Low.Di;
	xMsg2596.PT	       := T#60s;
	xMsg2596.Prio 	   := 4;
	xMsg2596.RiskClass := 4;
	xMsg2596.Reset	   := FALSE;
	xMsg2596();
	MM2VIS.bMsg2596    := xMsg2596.Q;

	(* W2597 engine prelub pump failure *)
	xMsg2597.Enable	   := xEngType.Type9 OR xEngType.Type6;
	xMsg2597.Set       := OUT_AG.tEOP1AC_Dem.Do AND NOT OUT_AG.bEOP_AC_PowSupOk;
	xMsg2597.PT		   := T#5s;
	xMsg2597.Prio	   := 4;
	xMsg2597.RiskClass := 4;
	xMsg2597.Reset	   := FALSE;
	xMsg2597();
	MM2VIS.bMsg2597	   := xMsg2597.Q;

	(* W2598 prelubrication pump turbo charger circuit breaker tripped *)
	xMsg2598.Enable	   := TRUE;
	xMsg2598.Set 	   := NOT IN_AG.tTCOP_CB_On.Di;
	xMsg2598.PT	       := T#0s;
	xMsg2598.Prio 	   := 4;
	xMsg2598.RiskClass := 4;
	xMsg2598.Reset	   := FALSE;
	xMsg2598();
	MM2VIS.bMsg2598    := xMsg2598.Q;

	(* W2599 prelubrication pump turbo charger USV circuit breaker tripped *)
	xMsg2599.Enable	   := TRUE;
	xMsg2599.Set 	   := NOT IN_AG.tTCOP_UPS_CB_On.Di;
	xMsg2599.PT	       := T#0s;
	xMsg2599.Prio 	   := 4;
	xMsg2599.RiskClass := 4;
	xMsg2599.Reset	   := FALSE;
	xMsg2599();
	MM2VIS.bMsg2599    := xMsg2599.Q;

	(* W2600 preheating pump circuit breaker tripped *)
	xMsg2600.Enable	   := TRUE;
	xMsg2600.Set 	   := NOT IN_AG.tECWP_PreH_CB_On.Di;
	xMsg2600.PT	       := T#0s;
	xMsg2600.Prio 	   := 4;
	xMsg2600.RiskClass := 4;
	xMsg2600.Reset	   := FALSE;
	xMsg2600();
	MM2VIS.bMsg2600    := xMsg2600.Q;

	(*  2602 charging unit turbo charger auxiliaries circuit breaker tripped *)
	xMsg2602.Enable	   := TRUE;
	xMsg2602.Set 	   := NOT IN_AG.tChUnit1_CB_On.Di OR NOT IN_AG.tChUnit2_CB_On.Di;
	xMsg2602.PT	       := T#0s;
	xMsg2602.Prio 	   := 4;
	xMsg2602.RiskClass := 4;
	xMsg2602.Reset	   := FALSE;
	xMsg2602();
	MM2VIS.bMsg2602    := xMsg2602.Q;

	(*  2603 charging unit engine interface panel circuit breaker tripped *)
	xMsg2603.Enable	   := TRUE;
	xMsg2603.Set 	   := NOT IN_AG.tChUnit3_CB_On.Di OR NOT IN_AG.tChUnit4_CB_On.Di;
	xMsg2603.PT	       := T#0s;
	xMsg2603.Prio 	   := 4;
	xMsg2603.RiskClass := 4;
	xMsg2603.Reset	   := FALSE;
	xMsg2603();
	MM2VIS.bMsg2603    := xMsg2603.Q;

	(*  2604 power supply engine interface panel circuit breaker tripped *)
	xMsg2604.Enable	   := TRUE;
	xMsg2604.Set 	   := NOT IN_AG.tPS_EI_CB_On.Di;
	xMsg2604.PT	       := T#0s;
	xMsg2604.Prio 	   := 4;
	xMsg2604.RiskClass := 4;
	xMsg2604.Reset	   := FALSE;
	xMsg2604();
	MM2VIS.bMsg2604    := xMsg2604.Q;

	(*  2605 control voltage transformer circuit breaker tripped *)
	xMsg2605.Enable	   := TRUE;
	xMsg2605.Set 	   := NOT IN_AG.tSTT_CB_On.Di;
	xMsg2605.PT	       := T#0s;
	xMsg2605.Prio 	   := 4;
	xMsg2605.RiskClass := 4;
	xMsg2605.Reset	   := FALSE;
	xMsg2605();
	MM2VIS.bMsg2605    := xMsg2605.Q;

	(*  2606 service cooling water pump circuit breaker tripped *)
	xMsg2606.Enable	   := TRUE;
	xMsg2606.Set 	   := NOT IN_AG.tECWP_Service_CB_On.Di;
	xMsg2606.PT	       := T#0s;
	xMsg2606.Prio 	   := 4;
	xMsg2606.RiskClass := 4;
	xMsg2606.Reset	   := FALSE;
	xMsg2606();
	MM2VIS.bMsg2606    := xMsg2606.Q;

	(* W2608 engine AC prelubrication pump ciruit breaker tripped *)
	xMsg2608.Enable	   := TRUE;
	xMsg2608.Set       := NOT IN_AG.tEOP1AC_CB_trip.Di;
	xMsg2608.PT		   := T#0s;
	xMsg2608.Prio	   := 4;
	xMsg2608.RiskClass := 4;
	xMsg2608.Reset	   := FALSE;
	xMsg2608();
	MM2VIS.bMsg2608	   := xMsg2608.Q;
	
	
	(* W2613 oil pressure after turbo charger oil filter high *)
	IF xEngType.Type9 THEN xGR_MAXR_Pr_TCO_hi(In:= tPr_TCLubOil_Max.Ai,			Gw:= Para.rPr_TCOF_Max - 1.00, Hy:= Para.rPr_TCOF_HyMax);//SWAT920/2.2
	ELSE                   xGR_MAXR_Pr_TCO_hi(In:= IN_AG.tPr_TC_EOF_After.Ai,	Gw:= Para.rPr_TCOF_Max - 0.30, Hy:= Para.rPr_TCOF_HyMax);
	END_IF;
	xMsg2613.Enable	   := Para.bPr_TCOaF_Active OR Para.bPr_Oil_LPTC_In_A OR Para.bPr_Oil_LPTC_In_B OR Para.bPr_TCO_Active;
	xMsg2613.Set       :=	 xGR_MAXR_Pr_TCO_hi.Q
						 AND xTON_Pr_TCO_Mon.Q
						 AND (	(IN_AG.tPr_TC_EOF_After.GoodQual AND NOT xEngType.Type9)
						 	 OR	(tPr_TCLubOil_Max.GoodQual 		 AND	 xEngType.Type9)	);
	xMsg2613.PT		   := T#5s;
	xMsg2613.Prio	   := 4;
	xMsg2613.RiskClass := 4;
	xMsg2613.Reset	   := FALSE;
	xMsg2613();
	MM2VIS.bMsg2613	   := xMsg2613.Q;


	(* W2624 Oil pressure LP turbo charger A signal failure (inlet) (TC unit: general alarm via bus) *)
	xMsg2624.Enable	   := Para.bPr_Oil_LPTC_In_A;
	xMsg2624.Set       := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_Oil_LPTC_In_A.GoodQual;
	xMsg2624.PT		   := T#1s;
	xMsg2624.Prio	   := 4;
	xMsg2624.RiskClass := 4;
	xMsg2624.Reset	   := FALSE;
	xMsg2624();
	MM2VIS.bMsg2624	   := xMsg2624.Q;

	(* W2625 Oil pressure LP turbo charger B signal failure (inlet) (TC unit: general alarm via bus) *)
	xMsg2625.Enable	   := Para.bPr_Oil_LPTC_In_B;
	xMsg2625.Set       := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_Oil_LPTC_In_B.GoodQual;
	xMsg2625.PT		   := T#1s;
	xMsg2625.Prio	   := 4;
	xMsg2625.RiskClass := 4;
	xMsg2625.Reset	   := FALSE;
	xMsg2625();
	MM2VIS.bMsg2625	   := xMsg2625.Q;

	(* W2627 pressure oil filter unit before filter signal failure *)
	xMsg2627.Enable	   := Para.bOilFiltUnit_Exist AND Para.bPr_OFUbFilt_Active;
	xMsg2627.Set       := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_OFUbFilt.GoodQual;
	xMsg2627.PT		   := T#10s;
	xMsg2627.Prio	   := 4;
	xMsg2627.RiskClass := 4;
	xMsg2627.Reset	   := FALSE;
	xMsg2627();
	MM2VIS.bMsg2627	   := xMsg2627.Q;

	(* W2628 pressure oil filter unit after filter signal failure *)
	xMsg2628.Enable	   := Para.bOilFiltUnit_Exist AND Para.bPr_OFUaFilt_Active;
	xMsg2628.Set       := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_OFUaFilt.GoodQual;
	xMsg2628.PT		   := T#10s;
	xMsg2628.Prio	   := 4;
	xMsg2628.RiskClass := 4;
	xMsg2628.Reset	   := FALSE;
	xMsg2628();
	MM2VIS.bMsg2628	   := xMsg2628.Q;

	(* W2629 oilfilter difference pressure (oil filter unit) high *)
	xMsg2629.Enable	   := TRUE;
	xMsg2629.Set       := bAMM_DPr_OFU_Filt_Hi;
	xMsg2629.PT		   := T#0s;
	xMsg2629.Prio	   := 4;
	xMsg2629.RiskClass := 4;
	xMsg2629.Reset	   := FALSE;
	xMsg2629();
	MM2VIS.bMsg2629	   := xMsg2629.Q;

	(* W2636 engine interface panel AC power supply circuit breaker tripped *)
	xMsg2636.Enable	   := TRUE;
	xMsg2636.Set       := NOT IN_AG.tPS400V_ENGIA_CB_On.Di;
	xMsg2636.PT		   := T#0s;
	xMsg2636.Prio	   := 4;
	xMsg2636.RiskClass := 4;
	xMsg2636.Reset	   := FALSE;
	xMsg2636();
	MM2VIS.bMsg2636	   := xMsg2636.Q;

	(* W2642 engine oil temperature oil pan signal failure *)
	xMsg2642.Enable	   := Para.bT_EO_Pan_Active;
	xMsg2642.Set       := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tT_EO_Pan.GoodQual;
	xMsg2642.PT		   := T#0s;
	xMsg2642.Prio	   := 4;
	xMsg2642.RiskClass := 4;
	xMsg2642.Reset	   := FALSE;
	xMsg2642();
	MM2VIS.bMsg2642	   := xMsg2642.Q;

	(* W2643 oil temperature after pump signal failure *)
	xMsg2643.Enable	   := Para.bT_EOaPump_Active;
	xMsg2643.Set       := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tT_EOP_After.GoodQual;
	xMsg2643.PT		   := T#0s;
	xMsg2643.Prio	   := 4;
	xMsg2643.RiskClass := 4;
	xMsg2643.Reset	   := FALSE;
	xMsg2643();
	MM2VIS.bMsg2643	   := xMsg2643.Q;

	(* W2644 UPS circuit breaker tripped *)
	xMsg2644.Enable	   := TRUE;
	xMsg2644.Set       := NOT IN_AG.tUPS_CB_On.Di;
	xMsg2644.PT		   := T#0s;
	xMsg2644.Prio	   := 4;
	xMsg2644.RiskClass := 4;
	xMsg2644.Reset	   := FALSE;
	xMsg2644();
	MM2VIS.bMsg2644	   := xMsg2644.Q;

	(* W2645 engine interface panel circuit breaker tripped *)
	xMsg2645.Enable	   := TRUE;
	xMsg2645.Set       := NOT IN_AG.tENGIA_CB_On.Di;
	xMsg2645.PT		   := T#0s;
	xMsg2645.Prio	   := 4;
	xMsg2645.RiskClass := 4;
	xMsg2645.Reset	   := FALSE;
	xMsg2645();
	MM2VIS.bMsg2645	   := xMsg2645.Q;

	(* W2646 engine interface panel UPS supply circuit breaker tripped *)
	xMsg2646.Enable	   := TRUE;
	xMsg2646.Set       := NOT IN_AG.tENGIA_UPS_CB_On.Di;
	xMsg2646.PT		   := T#0s;
	xMsg2646.Prio	   := 4;
	xMsg2646.RiskClass := 4;
	xMsg2646.Reset	   := FALSE;
	xMsg2646();
	MM2VIS.bMsg2646	   := xMsg2646.Q;

	(* W2648 measuring signal failure pressure before turbocharger oil filter *)
	xMsg2648.Enable	:=	Para.bPr_TCObF_Active;	
	xMsg2648.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_TC_EOF_Before.GoodQual;	
	xMsg2648.PT		:=	T#0s; 
	xMsg2648.Prio	:=	4; 	
	xMsg2648.Reset	:=	FALSE; 	
	xMsg2648();	
	MM2VIS.bMsg2648	:= 	xMsg2648.Q;	


	(*W2649 Crank case pressure low  *)	
	xMsg2649.Enable	:=	TRUE;	
	xMsg2649.Set	:=	bAMM_Pr_CC_Lo;	
	xMsg2649.PT		:=	T#0s; 
	xMsg2649.Prio	:=	4; 	
	xMsg2649.Reset	:=	FALSE; 	
	xMsg2649();	
	MM2VIS.bMsg2649	:= 	xMsg2649.Q;	


	(*W2650 Blow by blower not ready  *)	
	xMsg2650.Enable	:=	TRUE;
	xMsg2650.Set	:=	bAMM_BbBlower_Not_Rdy AND IN_AG.tAuxV_Eng_ok.Di;
	xMsg2650.PT		:=	T#10s; 
	xMsg2650.Prio	:=	4;
	xMsg2650.Reset	:=	FALSE; 	
	xMsg2650();	
	MM2VIS.bMsg2650	:= 	xMsg2650.Q;


	(*W2651 Measuring signal failure pressure before blow by filter  *)	
	xMsg2651.Enable	:=	TRUE;
	xMsg2651.Set	:=	bAMM_Pr_f_BbFilt_Ms;	
	xMsg2651.PT		:=	T#10s; 		
	xMsg2651.Prio	:=	4;
	xMsg2651.Reset	:=	FALSE;
	xMsg2651();	
	MM2VIS.bMsg2651	:= xMsg2651.Q;


	(*W2652 Measuring signal failure pressure after blow by filter  *)	
	xMsg2652.Enable	:=	TRUE;
	xMsg2652.Set	:=	bAMM_Pr_a_BbFilt_Ms;	
	xMsg2652.PT		:=	T#10s; 
	xMsg2652.Prio	:=	4;
	xMsg2652.Reset	:=	FALSE;
	xMsg2652();	
	MM2VIS.bMsg2652	:= 	xMsg2652.Q;


	(*W2653 Blow by filter difference pressure high - maintenance  *)
	xMsg2653.Enable	:=	TRUE;
	xMsg2653.Set	:=	bAMM_DPr_BbFilt_Hi;
	xMsg2653.PT		:=	T#120s; 
	xMsg2653.Prio	:=	4; 	
	xMsg2653.Reset	:=	FALSE;
	xMsg2653();	
	MM2VIS.bMsg2653	:= 	xMsg2653.Q;


	(*W2654 Blow by filter difference pressure low  *)	
	xMsg2654.Enable	:=	TRUE;	
	xMsg2654.Set	:=	bAMM_DPr_BbFilt_Lo;
	xMsg2654.PT		:=	T#120s;		
	xMsg2654.Prio	:=	4;
	xMsg2654.Reset	:=	FALSE;
	xMsg2654();	
	MM2VIS.bMsg2654	:= 	xMsg2654.Q;

	
	(* W2666 Preheating flap failure *)	
	xMsg2666.Enable	:=	TRUE;	
	xMsg2666.Set	:=	IN_AG.tECWV_Fail.Di;
	xMsg2666.PT		:=	T#2s;		
	xMsg2666.Prio	:=	4;
	xMsg2666.Reset	:=	FALSE;
	xMsg2666();	
	MM2VIS.bMsg2666	:= 	xMsg2666.Q;

	
	(* W2689 Permanent prelubrication failure *)	
	xMsg2689.Enable	:=	TRUE;	
	xMsg2689.Set	:=	FALSE;	(* preparation for future *)
	xMsg2689.PT		:=	T#2s;		
	xMsg2689.Prio	:=	4;
	xMsg2689.Reset	:=	FALSE;
	xMsg2689();	
	MM2VIS.bMsg2689	:= 	xMsg2689.Q;

	
	(* W2722 freshoil tank level high *)	
	xMsg2722.Enable    := IN_AG.tPB2MM.bParaSetupOk;
	xMsg2722.Set       := (IN_AG.tL_FreshOilTank_Hi.GoodQual AND NOT IN_AG.tL_FreshOilTank_Hi.Di)
					   OR (IN_AG.tL_FreshOilTank.GoodQual AND (MM2VIS.rV_FreshOilTank > Para.rV_FreshOilTank_LimHi) AND (Para.rV_FreshOilTank_LimHi > 0));		(*New at V4.12*)
	xMsg2722.PT        := T#0s;
	xMsg2722.Prio      := 4;
	xMsg2722.RiskClass := 4;
	xMsg2722.Reset     := FALSE;
	xMsg2722();
	MM2VIS.bMsg2722    := xMsg2722.Q;
	
		
	(* W2723 overfill prevention device fresh oil tank tripped *)	
	xMsg2723.Enable    := TRUE;
	xMsg2723.Set       := NOT IN_AG.tOF_FreshOilTank.Di;
	xMsg2723.PT        := T#0s;
	xMsg2723.Prio      := 4;
	xMsg2723.RiskClass := 4;
	xMsg2723.Reset     := FALSE;
	xMsg2723();
	MM2VIS.bMsg2723    := xMsg2723.Q;
	
	
	(* W2724 leakage fresh oil pump *)	
	xMsg2724.Enable    := TRUE;
	xMsg2724.Set       := NOT IN_AG.tLeak_FreshOilPump.Di;
	xMsg2724.PT        := T#0s;
	xMsg2724.Prio      := 4;
	xMsg2724.RiskClass := 4;
	xMsg2724.Reset     := FALSE;
	xMsg2724();
	MM2VIS.bMsg2724    := xMsg2724.Q;
		
		
	(* W2725 leakage fresh oil tank *)	
	xMsg2725.Enable    := TRUE;
	xMsg2725.Set       := NOT IN_AG.tLeak_FreshOilTank.Di;
	xMsg2725.PT        := T#0s;
	xMsg2725.Prio      := 4;
	xMsg2725.RiskClass := 4;
	xMsg2725.Reset     := FALSE;
	xMsg2725();
	MM2VIS.bMsg2725    := xMsg2725.Q;
		
	
	(* W2726 overfill prevention device waste oil tank tripped *)	
	xMsg2726.Enable    := TRUE;
	xMsg2726.Set       := NOT IN_AG.tOF_WasteOilTank.Di;
	xMsg2726.PT        := T#0s;
	xMsg2726.Prio      := 4;
	xMsg2726.RiskClass := 4;
	xMsg2726.Reset     := FALSE;
	xMsg2726();
	MM2VIS.bMsg2726    := xMsg2726.Q;
	
	
	(* W2727 leakage waste oil pump *)	
	xMsg2727.Enable    := TRUE;
	xMsg2727.Set       := NOT IN_AG.tLeak_WasteOilPump.Di;
	xMsg2727.PT        := T#0s;
	xMsg2727.Prio      := 4;
	xMsg2727.RiskClass := 4;
	xMsg2727.Reset     := FALSE;
	xMsg2727();
	MM2VIS.bMsg2727    := xMsg2727.Q;
		
		
	(* W2728 leakage waste oil tank *)	
	xMsg2728.Enable    := TRUE;
	xMsg2728.Set       := NOT IN_AG.tLeak_WasteOilTank.Di;
	xMsg2728.PT        := T#0s;
	xMsg2728.Prio      := 4;
	xMsg2728.RiskClass := 4;
	xMsg2728.Reset     := FALSE;
	xMsg2728();
	MM2VIS.bMsg2728    := xMsg2728.Q;
	
	
	(* W2729 general failure oil system *)	
	xMsg2729.Enable    := TRUE;
	xMsg2729.Set       := NOT IN_AG.tGF_OilSystem.Di;
	xMsg2729.PT        := T#0s;
	xMsg2729.Prio      := 4;
	xMsg2729.RiskClass := 4;
	xMsg2729.Reset     := FALSE;
	xMsg2729();
	MM2VIS.bMsg2729    := xMsg2729.Q;
		
	
	(* W2737 auxiliaries switch module interface tripped *)	
	xMsg2737.Enable    := TRUE;
	xMsg2737.Set       := NOT IN_AG.tAuxV_ModIf_ok.Di;
	xMsg2737.PT        := T#0s;
	xMsg2737.Prio      := 4;
	xMsg2737.RiskClass := 4;
	xMsg2737.Reset     := FALSE;
	xMsg2737();
	MM2VIS.bMsg2737    := xMsg2737.Q;

	
	(* W2738 release auxiliaries from auxiliaries panel *)	
	xMsg2738.Enable    := TRUE;
	xMsg2738.Set       := NOT IN_AG.tAuxV_Aux_ok.Di;
	xMsg2738.PT        := T#0s;
	xMsg2738.Prio      := 4;
	xMsg2738.RiskClass := 4;
	xMsg2738.Reset     := FALSE;
	xMsg2738();
	MM2VIS.bMsg2738    := xMsg2738.Q;

	
	(* W2739 day oil tank maximum *)	
	xMsg2739.Enable    := IN_AG.tPB2MM.bParaSetupOk;
	xMsg2739.Set       := (IN_AG.tL_DayOilTank_Hi.GoodQual AND NOT IN_AG.tL_DayOilTank_Hi.Di)
					   OR (IN_AG.tL_DayOilTank.GoodQual AND (MM2VIS.rV_DayOilTank > Para.rV_DayOilTank_LimHi) AND (Para.rV_DayOilTank_LimHi > 0));		(*New at V4.12*)
	xMsg2739.PT        := T#0s;
	xMsg2739.Prio      := 4;
	xMsg2739.RiskClass := 4;
	xMsg2739.Reset     := FALSE;
	xMsg2739();
	MM2VIS.bMsg2739    := xMsg2739.Q;

	
	(* W2740 leckage day oil tnak *)	
	xMsg2740.Enable    := TRUE;
	xMsg2740.Set       := NOT IN_AG.tDayOilTank_Leck.Di;
	xMsg2740.PT        := T#0s;
	xMsg2740.Prio      := 4;
	xMsg2740.RiskClass := 4;
	xMsg2740.Reset     := FALSE;
	xMsg2740();
	MM2VIS.bMsg2740    := xMsg2740.Q;

	
	(* W2741 day tank oil collector pan maximum *)	
	xMsg2741.Enable    := TRUE;
	xMsg2741.Set       := NOT IN_AG.tL_DayOilSump_Hi.Di;
	xMsg2741.PT        := T#0s;
	xMsg2741.Prio      := 4;
	xMsg2741.RiskClass := 4;
	xMsg2741.Reset     := FALSE;
	xMsg2741();
	MM2VIS.bMsg2741    := xMsg2741.Q;

	
	(* W2742 run time fresh oil pump high *)	
	TON_FOP(IN := IN_AG.tFOP_Op.Di, PT := Para.tiFreshOilPump_RTC_Time);
	bFOP_LZ_max 		:= TON_FOP.Q;	
	
	xMsg2742.Enable    := TRUE;
	xMsg2742.Set       := bFOP_LZ_max;
	xMsg2742.PT        := T#0s;
	xMsg2742.Prio      := 4;
	xMsg2742.RiskClass := 4;
	xMsg2742.Reset     := FALSE;
	xMsg2742();
	MM2VIS.bMsg2742    := xMsg2742.Q;


	(*W2754 Measuring signal failure pressure before blow by filter A *)	
	xMsg2754.Enable	:=	TRUE;
	xMsg2754.Set	:=	bAMM_Pr_f_BbFilt_A_Ms;	
	xMsg2754.PT		:=	T#10s; 		
	xMsg2754.Prio	:=	4;
	xMsg2754.Reset	:=	FALSE;
	xMsg2754();	
	MM2VIS.bMsg2754	:= xMsg2754.Q;


	(*W2755 Measuring signal failure pressure before blow by filter B *)	
	xMsg2755.Enable	:=	TRUE;
	xMsg2755.Set	:=	bAMM_Pr_f_BbFilt_B_Ms;	
	xMsg2755.PT		:=	T#10s; 		
	xMsg2755.Prio	:=	4;
	xMsg2755.Reset	:=	FALSE;
	xMsg2755();	
	MM2VIS.bMsg2755	:= xMsg2755.Q;


	(*W2756 Measuring signal failure pressure after blow by filter A *)	
	xMsg2756.Enable	:=	TRUE;
	xMsg2756.Set	:=	bAMM_Pr_a_BbFilt_A_Ms;	
	xMsg2756.PT		:=	T#10s; 		
	xMsg2756.Prio	:=	4;
	xMsg2756.Reset	:=	FALSE;
	xMsg2756();	
	MM2VIS.bMsg2756	:= xMsg2756.Q;


	(*W2757 Measuring signal failure pressure after blow by filter B *)	
	xMsg2757.Enable	:=	TRUE;
	xMsg2757.Set	:=	bAMM_Pr_a_BbFilt_B_Ms;	
	xMsg2757.PT		:=	T#10s; 		
	xMsg2757.Prio	:=	4;
	xMsg2757.Reset	:=	FALSE;
	xMsg2757();	
	MM2VIS.bMsg2757	:= xMsg2757.Q;


	(*W2758 differenzial pressure high blow by filter A - maintenance *)
	xMsg2758.Enable	:=	TRUE;
	xMsg2758.Set	:=	bAMM_DPr_BbFilt_A_Hi;	
	xMsg2758.PT		:=	T#120s; 		
	xMsg2758.Prio	:=	4;
	xMsg2758.Reset	:=	FALSE;
	xMsg2758();	
	MM2VIS.bMsg2758	:= xMsg2758.Q;


	(*W2759 differenzial pressure high blow by filter B - maintenance *)
	xMsg2759.Enable	:=	TRUE;
	xMsg2759.Set	:=	bAMM_DPr_BbFilt_B_Hi;	
	xMsg2759.PT		:=	T#120s; 		
	xMsg2759.Prio	:=	4;
	xMsg2759.Reset	:=	FALSE;
	xMsg2759();	
	MM2VIS.bMsg2759	:= xMsg2759.Q;


	(*W2760 differenzial pressure low blow by filter A *)
	xMsg2760.Enable	:=	TRUE;
	xMsg2760.Set	:=	bAMM_DPr_BbFilt_A_Lo;	
	xMsg2760.PT		:=	T#120s; 		
	xMsg2760.Prio	:=	4;
	xMsg2760.Reset	:=	FALSE;
	xMsg2760();	
	MM2VIS.bMsg2760	:= xMsg2760.Q;

	(*W2761 differenzial pressure low blow by filter B *)
	xMsg2761.Enable	:=	TRUE;
	xMsg2761.Set	:=	bAMM_DPr_BbFilt_B_Lo;	
	xMsg2761.PT		:=	T#120s; 		
	xMsg2761.Prio	:=	4;
	xMsg2761.Reset	:=	FALSE;
	xMsg2761();	
	MM2VIS.bMsg2761	:= xMsg2761.Q;

	(* W2762 plausibility check measuring signal engine oil pressure (Functional Safety EN 13849) *)//SWAT920/5b
	xMsg2762.Enable		:=	IN_AG.tPB2MM.bSys_Run;
	xMsg2762.Set 		:= 	bPr_EO_PcheckFail;
	xMsg2762.PT			:=	T#0s;
	xMsg2762.Prio		:=	4;
	xMsg2762.RiskClass	:=	4;	
	xMsg2762.Reset		:=	FALSE;
	xMsg2762();
	MM2VIS.bMsg2762     := xMsg2762.Q;
	
	(*W2770 Control voltage missing generator interface (+GENI)*)
	xMsg2770.Enable	:=	TRUE;
	xMsg2770.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_GENI_Ok.Di;
	xMsg2770.PT		:=	T#0s; 		
	xMsg2770.Prio	:=	4;
	xMsg2770.Reset	:=	FALSE;
	xMsg2770();	
	MM2VIS.bMsg2770	:= xMsg2770.Q;

	(*W2771 Control voltage missing engine interface bank B (+ENGIB)*)
	xMsg2771.Enable	:=	TRUE;
	xMsg2771.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_ENGIB_Ok.Di;
	xMsg2771.PT		:=	T#0s; 		
	xMsg2771.Prio	:=	4;
	xMsg2771.Reset	:=	FALSE;
	xMsg2771();	
	MM2VIS.bMsg2771	:= xMsg2771.Q;

	(*W2772 Control voltage missing turbo charger module interface cabinet (+TCMI)*)
	xMsg2772.Enable	:=	TRUE;
	xMsg2772.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_TCMI_Ok.Di;
	xMsg2772.PT		:=	T#0s; 		
	xMsg2772.Prio	:=	4;
	xMsg2772.Reset	:=	FALSE;
	xMsg2772();	
	MM2VIS.bMsg2772	:= xMsg2772.Q;

	(*W2773 Control voltage missing turbo charger unit sensor cabinet (+TCUS)*)
	xMsg2773.Enable	:=	TRUE;
	xMsg2773.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_TCUS_Ok.Di;
	xMsg2773.PT		:=	T#0s; 		
	xMsg2773.Prio	:=	4;
	xMsg2773.Reset	:=	FALSE;
	xMsg2773();	
	MM2VIS.bMsg2773	:= xMsg2773.Q;

	(*W2774 Control voltage missing jacket water module interface (+JWMI)*)
	xMsg2774.Enable	:=	TRUE;
	xMsg2774.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_JWMI_Ok.Di;
	xMsg2774.PT		:=	T#0s; 		
	xMsg2774.Prio	:=	4;
	xMsg2774.Reset	:=	FALSE;
	xMsg2774();	
	MM2VIS.bMsg2774	:= xMsg2774.Q;

	(*W2775 Control voltage missing oil module interface (+OILMI)*)
	xMsg2775.Enable	:=	TRUE;
	xMsg2775.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_OILMI_Ok.Di;
	xMsg2775.PT		:=	T#0s; 		
	xMsg2775.Prio	:=	4;
	xMsg2775.Reset	:=	FALSE;
	xMsg2775();	
	MM2VIS.bMsg2775	:= xMsg2775.Q;

	(*W2776 Control voltage missing module interface cabinet*)
	xMsg2776.Enable	:=	TRUE;
	xMsg2776.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_M_Ok.Di;
	xMsg2776.PT		:=	T#0s; 		
	xMsg2776.Prio	:=	4;
	xMsg2776.Reset	:=	FALSE;
	xMsg2776();	
	MM2VIS.bMsg2776	:= xMsg2776.Q;

	(*W2777 Control voltage missing module control cabinet*)
	xMsg2777.Enable	:=	TRUE;
	xMsg2777.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_A_Ok.Di;
	xMsg2777.PT		:=	T#0s; 		
	xMsg2777.Prio	:=	4;
	xMsg2777.Reset	:=	FALSE;
	xMsg2777();	
	MM2VIS.bMsg2777	:= xMsg2777.Q;

	(*W2778 Control voltage missing auxiliaries control cabinet 1*)
	xMsg2778.Enable	:=	TRUE;
	xMsg2778.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_AUX_Ok[1].Di;
	xMsg2778.PT		:=	T#0s; 		
	xMsg2778.Prio	:=	4;
	xMsg2778.Reset	:=	FALSE;
	xMsg2778();	
	MM2VIS.bMsg2778	:= xMsg2778.Q;

	(*W2781 Control voltage missing auxiliaries control cabinet 2*)
	xMsg2781.Enable	:=	TRUE;
	xMsg2781.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_AUX_Ok[2].Di;
	xMsg2781.PT		:=	T#0s; 		
	xMsg2781.Prio	:=	4;
	xMsg2781.Reset	:=	FALSE;
	xMsg2781();	
	MM2VIS.bMsg2781	:= xMsg2781.Q;

	(*W2782 Control voltage missing auxiliaries control cabinet 3*)
	xMsg2782.Enable	:=	TRUE;
	xMsg2782.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_AUX_Ok[3].Di;
	xMsg2782.PT		:=	T#0s; 		
	xMsg2782.Prio	:=	4;
	xMsg2782.Reset	:=	FALSE;
	xMsg2782();	
	MM2VIS.bMsg2782	:= xMsg2782.Q;

	(*W2783 Control voltage missing auxiliaries control cabinet 4*)
	xMsg2783.Enable	:=	TRUE;
	xMsg2783.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_AUX_Ok[4].Di;
	xMsg2783.PT		:=	T#0s; 		
	xMsg2783.Prio	:=	4;
	xMsg2783.Reset	:=	FALSE;
	xMsg2783();	
	MM2VIS.bMsg2783	:= xMsg2783.Q;

	(*W2784 Control voltage missing auxiliaries control cabinet 5*)
	xMsg2784.Enable	:=	TRUE;
	xMsg2784.Set	:=	IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tCV_AUX_Ok[5].Di;
	xMsg2784.PT		:=	T#0s; 		
	xMsg2784.Prio	:=	4;
	xMsg2784.Reset	:=	FALSE;
	xMsg2784();	
	MM2VIS.bMsg2784	:= xMsg2784.Q;

	(* W2785 Oil pressure before filter (oil filter unit) maximum *)
	xMsg2785.Enable	   := TRUE;
	xMsg2785.Set       := bAMM_Pr_OFUbFilt_Hi AND OUT_AG.tOFUP_Filter.Do;
	xMsg2785.PT		   := T#2s;
	xMsg2785.Prio	   := 4;
	xMsg2785.RiskClass := 4;
	xMsg2785.Reset	   := FALSE;
	xMsg2785();
	MM2VIS.bMsg2785	   := xMsg2785.Q;

	(* W2786 Oil pressure before centrifuge (oil filter unit) signal failure *)
	xMsg2786.Enable	   := Para.bOilFiltUnit_Exist AND Para.bPr_OFUbCentrifuge_Active;
	xMsg2786.Set       := IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.tPr_OFUbCentrifuge.GoodQual;
	xMsg2786.PT		   := T#10s;
	xMsg2786.Prio	   := 4;
	xMsg2786.RiskClass := 4;
	xMsg2786.Reset	   := FALSE;
	xMsg2786();
	MM2VIS.bMsg2786	   := xMsg2786.Q;
 
	(* W2787 Oil pressure before centrifuge (oil filter unit) maximum *)
	xMsg2787.Enable	   := TRUE;
	xMsg2787.Set       := bAMM_Pr_OFUbCentrifuge_Hi AND OUT_AG.tOFUP_Centrifuge.Do;
	xMsg2787.PT		   := T#2s;
	xMsg2787.Prio	   := 4;
	xMsg2787.RiskClass := 4;
	xMsg2787.Reset	   := FALSE;
	xMsg2787();
	MM2VIS.bMsg2787	   := xMsg2787.Q;

	(* W2788 Oil centrifuge interrupted power supply (oil filter unit) *)
	xMsg2788.Enable	   := Para.bOilFiltUnit_Exist;
	xMsg2788.Set       := IN_AG.tPB2MM.bParaSetupOk AND bOMSS_MAT AND NOT IN_AG.tOFUP_Centrifuge_CB.Di;
	xMsg2788.PT		   := T#0s;
	xMsg2788.Prio	   := 4;
	xMsg2788.RiskClass := 4;
	xMsg2788.Reset	   := FALSE;
	xMsg2788();
	MM2VIS.bMsg2788	   := xMsg2788.Q;

	(* W2789 Oil filter pump interrupted power supply (oil filter unit) *)
	xMsg2789.Enable	   := Para.bOilFiltUnit_Exist;
	xMsg2789.Set       := IN_AG.tPB2MM.bParaSetupOk AND bOMSS_MAT AND NOT IN_AG.tOFUP_Filter_CB.Di;
	xMsg2789.PT		   := T#0s;
	xMsg2789.Prio	   := 4;
	xMsg2789.RiskClass := 4;
	xMsg2789.Reset	   := FALSE;
	xMsg2789();
	MM2VIS.bMsg2789	   := xMsg2789.Q;

	(* W2791 engine cooling water pump not ready *)	
	xMsg2791.Enable	   := TRUE;
	xMsg2791.Set 	   := NOT IN_AG.tECWP_FC_Rdy.Di AND NOT bNoMon4BlackStart;
	xMsg2791.PT	       := T#10s;
	xMsg2791.Prio 	   := 4;
	xMsg2791.RiskClass := 4;
	xMsg2791.Reset	   := FALSE;
	xMsg2791();
	MM2VIS.bMsg2791    := xMsg2791.Q;

	(* W2792 engine prelube oil pump not ready *)	
	xMsg2792.Enable	   := TRUE;
	xMsg2792.Set 	   := NOT IN_AG.tEOP_FC_Rdy.Di;
	xMsg2792.PT	       := T#10s;
	xMsg2792.Prio 	   := 4;
	xMsg2792.RiskClass := 4;
	xMsg2792.Reset	   := FALSE;
	xMsg2792();
	MM2VIS.bMsg2792    := xMsg2792.Q;

	(* W3216 engine oil temperature high (A1043)*)
	xMsg3216.Enable	   := TRUE;
	IF xEngType.Type9 THEN xMsg3216.Set :=(IN_AG.tT_EO.Ai > Para.rT_EOP_LimMax) AND IN_AG.tEng_Run.Do //SWAT920/5
	                               AND NOT MM2VIS.bMsg1043 AND NOT MM2VIS.bMsg2102;
	                       xMsg3216.PT  := T#180s;
	ELSE                   xMsg3216.Set := AN_OTMA AND BTRB_60s
	                               AND NOT MM2VIS.bMsg1043 AND NOT MM2VIS.bMsg2102;
	                       xMsg3216.PT  := T#0s;
	END_IF;
	xMsg3216.Prio	   := 4;
	xMsg3216.RiskClass := 4;
	xMsg3216.Reset	   := FALSE;
	xMsg3216();
	MM2VIS.bMsg3216	   := xMsg3216.Q;	

	
	(* W3218 engine oil pressure low *)
	xMsg3218.Enable	   := TRUE;
	xMsg3218.Set 	   := FG_ODRUW AND AN_ODRW AND IN_AG.tPr_EngLubOil.GoodQual;
	xMsg3218.PT		   := T#0s;
	xMsg3218.Prio	   := 4;
	xMsg3218.RiskClass := 4;
	xMsg3218.Reset	   := FALSE;
	xMsg3218();
	MM2VIS.bMsg3218	   := xMsg3218.Q;
	
	
	(* A3301 purge cycle - gas safety loop tripped *)
//	ton10ms_Gas_SL(IN:= GASV1 AND NOT DI_Gas_SL, PT:=15);	(* 1 cycle delay for amm 
//	xTON_3301(IN:= GASV1 AND NOT DI_Gas_SL, PT:=15);		(* 1 cycle delay for amm 

	xMsg3301.Enable	   := Para.bPurgecycle_Active;
	xMsg3301.Set 	   := IN_AG.tGV1_Open.Do AND NOT IN_AG.tSafetyLoop_Gas.Di;
	xMsg3301.PT	       := T#150ms;				(* 1 cycle delay for amm *)
	xMsg3301.Prio 	   := 2;
	xMsg3301.RiskClass := 4;
	xMsg3301.Reset	   := FALSE;
	xMsg3301();
	MM2VIS.bMsg3301    := xMsg3301.Q;


	(* W3304 gear oil pressure low *)	
	xTON_PrGO_Rel(IN:= IN_AG.tEng_Run.Do, PT:= T#10s);
	xTON_PrGO_Lo(IN:= NOT IN_AG.tPr_EO_Gear_Min.Di, PT:= T#2s);
	
	xMsg3304.Enable    := TRUE;
	xMsg3304.Set       := xTON_PrGO_Lo.Q AND xTON_PrGO_Rel.Q;
	xMsg3304.PT        := T#0s;
	xMsg3304.Prio      := 2;
	xMsg3304.RiskClass := 4;
	xMsg3304.Reset     := FALSE;
	xMsg3304();
	MM2VIS.bMsg3304    := xMsg3304.Q;	
	
	
	(* W3305 gear oil temperature high *)	
	xMsg3305.Enable    := TRUE;
	xMsg3305.Set       := NOT IN_AG.tT_EO_Gear_Max.Di;
	xMsg3305.PT        := T#2s;
	xMsg3305.Prio      := 3;
	xMsg3305.RiskClass := 4;
	xMsg3305.Reset     := FALSE;
	xMsg3305();
	MM2VIS.bMsg3305    := xMsg3305.Q;
	

	(* A3322 crank case pressure high *)	
	xMsg3322.Enable	   := TRUE; 
	xMsg3322.Set 	   := bAMM_Pr_CC_HiHi 
				  AND NOT IN_AG.tAB2AG.bGnlTrip1
				  AND NOT IN_AG.tAB2AG.bGnlTrip2;
	xMsg3322.PT	       := T#0s;
	xMsg3322.Prio 	   := 2; 	
	xMsg3322.RiskClass := 4;
	xMsg3322.Reset	   := FALSE;
	xMsg3322();
	MM2VIS.bMsg3322    := xMsg3322.Q;

	
	(* A3323 crank case pressure measuring signal failure *) 
	xMsg3323.Enable	   := IN_AG.tPB2MM.bSys_Run; 
	xMsg3323.Set 	   := bAMM_Pr_CC_MsMs;
	xMsg3323.PT	       := T#2s;
	xMsg3323.Prio 	   := 3;
	xMsg3323.Reset	   := FALSE;
	xMsg3323.RiskClass := 4;
	xMsg3323();
	MM2VIS.bMsg3323    := xMsg3323.Q;

	
	(* A3350 CO alarm *)	
	xMsg3350.Enable	   := TRUE;
	xMsg3350.Set 	   := NOT IN_AG.tCO_Alarm.Di;
	xMsg3350.PT	       := T#0s;
	xMsg3350.Prio 	   := 2;
	xMsg3350.RiskClass := 4;
	xMsg3350();
	MM2VIS.bMsg3350    := xMsg3350.Q;

	
	(* A3351 active filter alarm *)	
	xMsg3351.Enable	   := TRUE;
	xMsg3351.Set 	   := NOT IN_AG.tActFiltAlarm.Di;
	xMsg3351.PT	       := T#0s;
	xMsg3351.Prio 	   := 2;
	xMsg3351.RiskClass := 4;
	xMsg3351();
	MM2VIS.bMsg3351    := xMsg3351.Q;

	
	(*A3369 Anlaufstörung Luftstarter	-	Air starter supply pressure low	*)	
	xMsg3369.Enable	:=	TRUE;	
	xMsg3369.Set	:=	bAMM_AirStarter_StartUp;
	xMsg3369.PT		:=	T#1s; 		
	xMsg3369.Prio	:=	3; 
	xMsg3369.Reset	:=	FALSE;
	xMsg3369();	
	MM2VIS.bMsg3369	:= 	xMsg3369.Q;


	(* A3370 Messsignalstörung Luftstarter Versorgungsdruck	-	Measuring signal failure air starter supply pressure (W2557)*)	
	xMsg3370.Enable	:=	FALSE; //SWAT920/2.2
	xMsg3370.Set	:=	bAMM_Pr_AirStarter_Supply_MsMs;	
	xMsg3370.PT		:=	T#1s; 		
	xMsg3370.Prio	:=	3;
	xMsg3370.Reset	:=	FALSE;
 	xMsg3370();	
	MM2VIS.bMsg3370	:=	xMsg3370.Q;


	(*	A3375 Luftstarter Einspurstörung	-	Air starter engaging error	*)	
	xMsg3375.Enable	:=	TRUE; //REACTIVATED for fast start
	xMsg3375.Set	:=  bAMM_EngageErr;
	xMsg3375.PT		:=	T#0s; 		
	xMsg3375.Prio	:=	3; 
	xMsg3375.Reset	:=	FALSE;
 	xMsg3375();	
	MM2VIS.bMsg3375	:=	xMsg3375.Q;


	(* W3401 engine oil level low *)	
	IF xEngType.Motortype < 900 THEN
		xMsg3401.Enable	   := FALSE;
		xMsg3401.Set 	   := IN_AG.tEO_Refill.Di AND IN_AG.tEng_Run.Do AND NOT xEngType.Type2; 
		xMsg3401.PT	       := T#3h;
	ELSE
		xMsg3401.Enable	   := TRUE;
		xMsg3401.Set 	   := OUT_AG.bEngOilLevel_W_Lo; (* changed for SWAT #3 *) 
		xMsg3401.PT	       := T#0s;
	END_IF
	xMsg3401.Prio 	   := 4;
	xMsg3401.RiskClass := 4;
	xMsg3401.Reset	   := FALSE;
	xMsg3401();
	MM2VIS.bMsg3401    := xMsg3401.Q;		


	(* W3403 engine cooling water level low (A1020)*)
	xMsg3403.Enable	   := TRUE;
	xMsg3403.Set 	   := NOT IN_AG.tL_ECW_Lo.Di;
	xMsg3403.PT	       := T#0s;
	xMsg3403.Prio 	   := 4;
	xMsg3403.RiskClass := 4;
	xMsg3403.Reset 	   := FALSE;	
	xMsg3403();
	MM2VIS.bMsg3403    := xMsg3403.Q;


	(* W3405 module control panel circuit breaker tripped (A1139)*)	
	xMsg3405.Enable	   := TRUE;
	xMsg3405.Set 	   := NOT IN_AG.tMCP_CBTrip.Di;	
	xMsg3405.PT	       := T#0s;
	xMsg3405.Prio 	   := 4;
	xMsg3405.RiskClass := 4;
	xMsg3405.Reset	   := FALSE;
	xMsg3405();
	MM2VIS.bMsg3405    := xMsg3405.Q;


	(* W3413 Measuring signal failure oil pressure before oil filter *)		(* --> NOT USED *)
	xMsg3413.Enable	   := FALSE;		
	xMsg3413.Set	   := FALSE;
	xMsg3413.PT		   := T#0s;		
	xMsg3413.Prio	   := 4;			
	xMsg3413.RiskClass := 4;			
	xMsg3413.Reset	   := FALSE;	
	xMsg3413();															
	MM2VIS.bMsg3413	   := xMsg3413.Q;	
		
		
	(* W3414 Oil filter differential pressure - Oil filter achieves service life limit *)
	xMsg3414.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg3414.Set       := bAMM_DPr_EOF_Lim1;
	xMsg3414.PT		   := T#60s;
	xMsg3414.Prio	   := 4;
	xMsg3414.RiskClass := 4;
	xMsg3414.Reset	   := FALSE;
	xMsg3414();
	MM2VIS.bMsg3414	   := xMsg3414.Q;

	
	(* W3415 Oil filter differential pressure - Oil filter to be replaced *)
	xMsg3415.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg3415.Set       := bAMM_DPr_EOF_Lim2;
	xMsg3415.PT		   := T#60s;
	xMsg3415.Prio	   := 4;
	xMsg3415.RiskClass := 4;
	xMsg3415.Reset	   := FALSE;
	xMsg3415();
	MM2VIS.bMsg3415	   := xMsg3415.Q;
	

	(* W3416 Oil filter differential pressure - Maximum *)				(* --> NOT USED *)
	xMsg3416.Enable	   := FALSE;
	xMsg3416.Set       := FALSE;
	xMsg3416.PT		   := T#0s;
	xMsg3416.Prio	   := 4;
	xMsg3416.RiskClass := 4;
	xMsg3416.Reset	   := FALSE;
	xMsg3416();
	MM2VIS.bMsg3416	   := xMsg3416.Q;

	(* W3495 pressure engine oil after pump high *)
	xMsg3495.Enable	   := Para.bPr_EOaP_Active;
	xMsg3495.Set 	   := IN_AG.tPr_EOaP.Ai > Para.rPr_EOaP_LimHi;
	xMsg3495.PT	       := T#0s;
	xMsg3495.Prio 	   := 4;
	xMsg3495.RiskClass := 4;
	xMsg3495.Reset 	   := FALSE;
	xMsg3495();
	MM2VIS.bMsg3495    := xMsg3495.Q;

	(* W3496 pressure engine oil after pump signal failure *)
	xMsg3496.Enable	   := IN_AG.tPB2MM.bParaSetupOk AND Para.bPr_EOaP_Active;
	xMsg3496.Set 	   := NOT IN_AG.tPr_EOaP.GoodQual;
	xMsg3496.PT	       := T#0s;
	xMsg3496.Prio 	   := 4;
	xMsg3496.RiskClass := 4;
	xMsg3496.Reset 	   := FALSE;
	xMsg3496();
	MM2VIS.bMsg3496    := xMsg3496.Q;

	(* W3497 failure in the safety loop *)
	(*		 monitoring safety loop: emergency stop button has to be pushed for reset 3497 *)
	bHWC_SL_Active			:=	IN_AG.tSafetyLoop_HWC.GoodQual;	(* tSafetyLoop_HWC.Di existing ?*)

	bAnyHWC_SL_FailActive	:= 	IN_AG.tT_HW_Hi.Di		
						OR 		IN_AG.tT_HW_Hi1.Di
						OR		IN_AG.tPr_HW_Lo.Di
						OR		IN_AG.tPr_HW_Hi.Di
						OR		IN_AG.tPr_HW_Hi1.Di
						OR		IN_AG.tT_HW_EGHE_Hi.Di
						OR		IN_AG.tT_HW_EGCD_Hi.Di
						OR		IN_AG.tCust_HW_Ext_Trip.Di
						OR	NOT IN_AG.tSafetyLoop_EmStop.Di;

//	RUHE			IN_AG.tSafetyLoop_Eng.Di
//	RM_HK			IN_AG.tSafetyLoop_HWC.Di	
//	HWC_MonActive	IN_AG.tSafetyLoop_HWC.GoodQual

	xMsg3497.Enable	   := NOT IN_AG.bSafetyPLC_Active AND NOT IN_AG.bSimWinMOD_Active;										(* SAFETY PLC *)
	xMsg3497.Set 	   :=  (bHWC_SL_Active AND     IN_AG.tSafetyLoop_HWC.Di AND IN_AG.tSafetyLoop_Eng.Di) 
						OR (bHWC_SL_Active AND NOT IN_AG.tSafetyLoop_HWC.Di AND bAnyHWC_SL_FailActive) 
						OR (					   IN_AG.tSafetyLoop_Eng.Di AND bAnyHWC_SL_FailActive)
						OR (xMsg3497.Q	   AND 	   IN_AG.tSafetyLoop_EmStop.Di);
	xMsg3497.PT	       := T#5s;
	xMsg3497.Prio 	   := 4; 	(* !special reset conditions! *)
	xMsg3497.RiskClass := 4;
	xMsg3497.Reset	   := FALSE;
	xMsg3497();
	MM2VIS.bMsg3497    := xMsg3497.Q;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)

	(* W3507 engine oil pressure high *)
	xMsg3507.Enable	   := TRUE;
	xMsg3507.Set       := AN_ODR_MAX AND UW_ODR_MAX;
	xMsg3507.PT		   := T#0s;
	xMsg3507.Prio	   := 4;
	xMsg3507.RiskClass := 4;
	xMsg3507.Reset	   := FALSE;
	xMsg3507();
	MM2VIS.bMsg3507    := xMsg3507.Q;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	(* W3515 air conditioning unit failure in module interface panel *)
	xMsg3515.Enable	   := TRUE;
	xMsg3515.Set 	   := NOT IN_AG.tT_AirIFCP_Hi.Di;
	xMsg3515.PT	       := T#0s;
	xMsg3515.Prio 	   := 4;
	xMsg3515.RiskClass := 4;
	xMsg3515.Reset 	   := FALSE;	
	xMsg3515();
	MM2VIS.bMsg3515    := xMsg3515.Q;


	(* W3519 heat water pump failure *)
	xTOF_EngDemEPS(IN:= IN_AG.bEng_Dem_EPS AND NOT IN_AG.tGCB_On.Di, PT:= T#60s);
	bNoMon4BlackStart := xTOF_EngDemEPS.Q AND IN_AG.bEng_Dem_EPS; //T14

	xTOF_HWP_Fail(IN:= IN_AG.tHWP_Op.Di OR bNoMon4BlackStart, PT:= T#10s);
	HBT_6 := xTOF_HWP_Fail.Q OR (OUT_AG.tHWP_Dem.Do AND HBT_6);
	xTON_HWP_Fail(IN:= OUT_AG.tHWP_Dem.Do, PT:= T#175s);

	xMsg3519.Enable		:=	TRUE;
	IF NOT Para.bRedHWP_Active THEN
		xMsg3519.Set 	:= (xTON_HWP_Fail.Q OR HBT_6) AND NOT xTOF_HWP_Fail.Q;
	ELSE
		xMsg3519.Set 	:= bRedHWP_Fail AND ((iRedHWP_Fail = 1) OR (iRedHWP_Fail = 3));
	END_IF;
	xMsg3519.PT			:=	T#15s;
	xMsg3519.Prio		:=	4;
	xMsg3519.RiskClass	:=	4;
	xMsg3519.Reset		:=	FALSE;
	xMsg3519();
	MM2VIS.bMsg3519     := xMsg3519.Q;


	(* W3572 transformer failure *)
	xMsg3572.Enable	   := TRUE;
	xMsg3572.Set 	   := NOT IN_AG.tTransformerWarning.Di;
	xMsg3572.PT	       := T#0s;
	xMsg3572.Prio 	   := 4;
	xMsg3572.RiskClass := 4;
	xMsg3572.Reset 	   := FALSE;
	xMsg3572();
	MM2VIS.bMsg3572    := xMsg3572.Q;


	(* W3574 active filter warning *)	
	xMsg3574.Enable	   := TRUE;
	xMsg3574.Set 	   := NOT IN_AG.tActFiltWarn.Di;
	xMsg3574.PT	       := T#0s;
	xMsg3574.Prio 	   := 4;
	xMsg3574.RiskClass := 4;
	xMsg3574.Reset 	   := FALSE;
	xMsg3574();
	MM2VIS.bMsg3574    := xMsg3574.Q;

	
	(* W3578 auxiliaries failure *)	(* france *)
	xMsg3578.Enable	   := TRUE;
	xMsg3578.Set 	   := NOT IN_AG.tAuxErrWarn.Di;
	xMsg3578.PT	       := T#0s;
	xMsg3578.Prio 	   := 4;
	xMsg3578.RiskClass := 4;
	xMsg3578.Reset 	   := FALSE;
	xMsg3578();
	MM2VIS.bMsg3578    := xMsg3578.Q;

	
	(* W3579 CO prealarm *)	
	xMsg3579.Enable	   := TRUE;
	xMsg3579.Set 	   := NOT IN_AG.tCO_PreAlarm.Di;
	xMsg3579.PT	       := T#0s;
	xMsg3579.Prio 	   := 4;
	xMsg3579.RiskClass := 4;
	xMsg3579.Reset 	   := FALSE;
	xMsg3579();
	MM2VIS.bMsg3579    := xMsg3579.Q;


	(* W3587 water ingress into inlet manifold *)	
	xMsg3587.Enable	   := TRUE;
	xMsg3587.Set 	   := IN_AG.tL_InMa_Hi.Di AND NOT IN_AG.tL_InMa_NotHi.Di AND IN_AG.tEng_Run.Do;
	xMsg3587.PT	       := T#0s;
	xMsg3587.Prio 	   := 4;
	xMsg3587.RiskClass := 4;
	xMsg3587.Reset 	   := FALSE;
	xMsg3587();
	MM2VIS.bMsg3587    := xMsg3587.Q;


	(* W3588 inlet manifold fill sensor inactive *)	
	xMsg3588.Enable	   := TRUE;
	xMsg3588.Set 	   :=  (	IN_AG.tL_InMa_Hi.Di AND     IN_AG.tL_InMa_NotHi.Di) 
						OR (NOT	IN_AG.tL_InMa_Hi.Di AND NOT IN_AG.tL_InMa_NotHi.Di);
	xMsg3588.PT	       := T#1s;
	xMsg3588.Prio 	   := 4;
	xMsg3588.RiskClass := 4;
	xMsg3588.Reset 	   := FALSE;
	xMsg3588();
	MM2VIS.bMsg3588    := xMsg3588.Q;

	(* W9214 Engine turn equipment active (A2201) - lock engine start *)//SWAT920/5
	xMsg9214.Enable	   := xEngType.Type9;
	xMsg9214.Set 	   := NOT IN_AG.tEngTurn.Di OR IN_AG.tEngTurn2.Di;
	xMsg9214.PT	       := T#0s;
	xMsg9214.Prio 	   := 4;
	xMsg9214.RiskClass := 4;
	xMsg9214.Reset	   := FALSE;
	xMsg9214();
	MM2VIS.bMsg9214    := xMsg9214.Q;
	OUT_AG.bMsg9214    := xMsg9214.Q;

	(* W9220 plausibility check measuring signal engine oil pressure after filter(Functional Safety EN 13849) *)//SWAT920/5a
	xMsg9220.Enable		:=	IN_AG.tPB2MM.bSys_Run;
	xMsg9220.Set 		:= 	bPr_EOaF_PcheckFail;
	xMsg9220.PT			:=	T#0s;
	xMsg9220.Prio		:=	4;
	xMsg9220.RiskClass	:=	4;	
	xMsg9220.Reset		:=	FALSE;
	xMsg9220();
	MM2VIS.bMsg9220     := xMsg9220.Q;


	(* W9221 pressure after turbocharger oil filter high - permanent prelubrication *)
	xMsg9221.Enable	   := Para.bPr_TCOaF_Active AND xEngType.Type6;		(* J624 *)
	xMsg9221.Set 	   := 	IN_AG.tPB2MM.bParaSetupOk
					AND     bPreLubeDemFS
					AND NOT bPreLubeDem
					AND NOT bEmLubDem
					AND NOT bOCTC_CoDoRun
					AND NOT bTC_PostLub
					AND NOT IN_AG.bN2_ScavCoPrelubeOn
					AND NOT IN_AG.bEO_PrelubeDemIgn
					AND NOT M_DREHZ
					AND NOT OUT_AG.bEleStarter_Dem_PurgeCrkCyl
					AND		bPr_TCLubOil_PreL_FS_Hi 		(* M.03-PI-063 *)
					AND     IN_AG.tPr_TC_EOF_After.GoodQual;
				
	xMsg9221.PT	       := T#30s;
	xMsg9221.Prio 	   := 4;
	xMsg9221.RiskClass := 4;
	xMsg9221.Reset 	   := FALSE;
	xMsg9221();
	MM2VIS.bMsg9221    := xMsg9221.Q;

	
	(* W9222 Oil pressure after TC oil filter high - Permanent pre-lubrication or pre-heating OFF *)	
	xTP_StartFail(IN := EDGENEG(OUT_AG.bEng_Start), PT := T#5s);
	xTON_Msg9222(IN	:= MM2VIS.bMsg9222 AND NOT xMsg9222.Set AND Para.bEO_PreH_Active, PT:= T#120s);		(* auto reset *)
	
	xMsg9222.Enable		:= Para.bPr_TCOaF_Active AND (xEngType.Type6 OR xEngType.Type4);	(* J624 *)
	xMsg9222.Set		:= 	IN_AG.tPB2MM.bParaSetupOk
					AND	   (bPreLubeDemFS OR bPreHeatDem)
					AND NOT bPreLubeDem
					AND NOT bEmLubDem
					AND NOT bOCTC_CoDoRun
					AND NOT bTC_PostLub
					AND NOT IN_AG.bN2_ScavCoPrelubeOn
					AND NOT IN_AG.bEO_PrelubeDemIgn
					AND NOT M_DREHZ
					AND NOT xTP_StartFail.Q
					AND NOT OUT_AG.bEleStarter_Dem_PurgeCrkCyl
					AND		bPr_TCLubOil_PreL_FS_HiHi		(* M.03-PI-063 *)
					AND     IN_AG.tPr_TC_EOF_After.GoodQual;

	xMsg9222.PT	       := T#30s;
	xMsg9222.Prio 	   := 4;
	xMsg9222.RiskClass := 4;
	xMsg9222.Reset 	   := xTON_Msg9222.Q;
	xMsg9222();
	MM2VIS.bMsg9222    := xMsg9222.Q;


	(* W9224 engine oil pressure high - permanent prelubrication *)	
	xMsg9224.Enable	   := NOT Para.bPr_TCOaF_Active AND xEngType.Type6;		(* J6xx *)
	xMsg9224.Set 	   :=   IN_AG.tPB2MM.bParaSetupOk
					AND     bPreLubeDemFS
					AND NOT bPreLubeDem
					AND NOT bEmLubDem
					AND NOT bOCTC_CoDoRun
					AND NOT bTC_PostLub
					AND NOT IN_AG.bN2_ScavCoPrelubeOn
					AND NOT IN_AG.bEO_PrelubeDemIgn
					AND NOT M_DREHZ
					AND NOT OUT_AG.bEleStarter_Dem_PurgeCrkCyl
					AND		bPr_TCLubOil_PreL_FS_Hi		(* M.03-PI-001 *)
					AND     IN_AG.tPr_EngLubOil.GoodQual;

	xMsg9224.PT	       := T#30s;
	xMsg9224.Prio 	   := 4;
	xMsg9224.RiskClass := 4;
	xMsg9224.Reset 	   := FALSE;
	xMsg9224();
	MM2VIS.bMsg9224    := xMsg9224.Q;

	
	(* W9225 Engine oil pressure high - Permanent pre-lubrication or pre-heating OFF *)	
	xTON_Msg9225(IN	:= MM2VIS.bMsg9225 AND NOT xMsg9225.Set AND Para.bEO_PreH_Active, PT:= T#120s);		(* auto reset *)

	xMsg9225.Enable		:= NOT Para.bPr_TCOaF_Active AND (xEngType.Type6 OR xEngType.Type4);	(* J6xx *)
	xMsg9225.Set		:= 	IN_AG.tPB2MM.bParaSetupOk
					AND	   (bPreLubeDemFS OR bPreHeatDem)
					AND NOT bPreLubeDem
					AND NOT bEmLubDem
					AND NOT bOCTC_CoDoRun
					AND NOT bTC_PostLub
					AND NOT IN_AG.bN2_ScavCoPrelubeOn
					AND NOT IN_AG.bEO_PrelubeDemIgn
					AND NOT M_DREHZ
					AND NOT xTP_StartFail.Q
					AND NOT OUT_AG.bEleStarter_Dem_PurgeCrkCyl
					AND		bPr_TCLubOil_PreL_FS_HiHi	(* M.03-PI-001 *)
					AND     IN_AG.tPr_EngLubOil.GoodQual;

	xMsg9225.PT	       := T#30s;
	xMsg9225.Prio 	   := 4;
	xMsg9225.RiskClass := 4;
	xMsg9225.Reset 	   := xTON_Msg9225.Q;
	xMsg9225();
	MM2VIS.bMsg9225    := xMsg9225.Q;

	(* W9227 Failure low temperature circuit pump 2 (charge cooler 2 pump) *)	
	xTOF_CC2WP_Fail(IN:= IN_AG.tCC2WP_Op.Di OR bNoMon4BlackStart, PT:= T#10s);
	HBT_7 := xTOF_CC2WP_Fail.Q OR (IN_AG.bEng_Aux_Dem AND HBT_7);

	xMsg9227.Enable	   := TRUE;
	IF NOT Para.bRedCC2WP_Active THEN
		xMsg9227.Set   := (AT26 OR HBT_7) AND NOT xTOF_CC2WP_Fail.Q;
	ELSE
		xMsg9227.Set   := bRedCC2WP_Fail AND ((iRedCC2WP_Fail = 1) OR (iRedCC2WP_Fail = 3));
	END_IF;
	xMsg9227.PT	       := T#0s;
	xMsg9227.Prio 	   := 4;
	xMsg9227.RiskClass := 4;
	xMsg9227.Reset	   := FALSE;
	xMsg9227();
	MM2VIS.bMsg9227    := xMsg9227.Q;
	
	(* W9254 Engine cooling water hydraulic pre-heating failure *)	
	xMsg9254.Enable	   :=	(xEngType.Type3 OR xEngType.Type4 OR xEngType.Type6)
					AND		Para.bT_HW_Su_PreH_ECW_Active
					AND	(	(Para.iECW_PreH_Int_Visible = 5)					(* el.+hydr. pre-heating available *)
						 OR (	(Para.iECW_PreH_Int_Visible = 3)				(* only hydr. pre-heating available *)
							 AND NOT (Para.rT_ECW_HydrPreH_LimLo = 0.0)	)	);	(* monitoring deactivated if hydr. pre-heating only and Para.rT_ECW_HydrPreH_LimLo = 0.0 *)
	xMsg9254.Set 	   := 	IN_AG.tPB2MM.bParaSetupOk
					AND		bECW_HydrPreH_Dem
					AND (	((IN_AG.tT_ECW.Ai < rT_ECW_HydrPreH_LimLo) AND xSR_PreH_HeatUpDone.Q1)
						 OR	((IN_AG.tT_HW_Su_PreH_ECW.Ai < MM2VIS.rT_HW_Su_PreH_ECW_LimLo) AND IN_AG.tT_HW_Su_PreH_ECW.GoodQual)
						 OR	((IN_AG.tT_HW_Su_PreH_ECW.Ai > MM2VIS.rT_HW_Su_PreH_ECW_LimHi) AND IN_AG.tT_HW_Su_PreH_ECW.GoodQual)	);
	xMsg9254.PT	       := T#0s;
	xMsg9254.Prio 	   := 4;
	xMsg9254.RiskClass := 4;
	xMsg9254.Reset 	   := FALSE;
	xMsg9254();
	MM2VIS.bMsg9254    := xMsg9254.Q;

	(* W9255 Failure high temperature circuit pump 2 (redundant heating water pump) *)	
	xMsg9255.Enable	   := Para.bRedHWP_Active;
	xMsg9255.Set 	   := bRedHWP_Fail AND ((iRedHWP_Fail = 2) OR (iRedHWP_Fail = 3));
	xMsg9255.PT	       := T#0s;
	xMsg9255.Prio 	   := 4;
	xMsg9255.RiskClass := 4;
	xMsg9255.Reset	   := FALSE;
	xMsg9255();
	MM2VIS.bMsg9255    := xMsg9255.Q;

	(* W9256 Failure low temperature circuit pump 3 (redundant charge cooler pump) *)	
	xMsg9256.Enable	   := Para.bRedCCWP_Active;
	xMsg9256.Set 	   := bRedCCWP_Fail AND ((iRedCCWP_Fail = 2) OR (iRedCCWP_Fail = 3));
	xMsg9256.PT	       := T#0s;
	xMsg9256.Prio 	   := 4;
	xMsg9256.RiskClass := 4;
	xMsg9256.Reset	   := FALSE;
	xMsg9256();
	MM2VIS.bMsg9256    := xMsg9256.Q;

	(* W9257 Failure low temperature circuit pump 4 (redundant charge cooler 2 pump) *)	
	xMsg9257.Enable	   := Para.bRedCC2WP_Active;
	xMsg9257.Set 	   := bRedCC2WP_Fail AND ((iRedCC2WP_Fail = 2) OR (iRedCC2WP_Fail = 3));
	xMsg9257.PT	       := T#0s;
	xMsg9257.Prio 	   := 4;
	xMsg9257.RiskClass := 4;
	xMsg9257.Reset	   := FALSE;
	xMsg9257();
	MM2VIS.bMsg9257    := xMsg9257.Q;

	(* W9258 Failure emergency cooling circuit pump 2 (redundant emergency cooler pump) *)	
	xMsg9258.Enable	   := Para.bRedEmCWP_Active;
	xMsg9258.Set 	   := bRedEmCWP_Fail AND ((iRedEmCWP_Fail = 2) OR (iRedEmCWP_Fail = 3));
	xMsg9258.PT	       := T#0s;
	xMsg9258.Prio 	   := 4;
	xMsg9258.RiskClass := 4;
	xMsg9258.Reset	   := FALSE;
	xMsg9258();
	MM2VIS.bMsg9258    := xMsg9258.Q;

	(* W9279 Failure emergency cooling circuit pump 1 (emergency cooler pump) *)	
	xTOF_EmCWP_Fail(IN:= IN_AG.tEmCWP_Op.Di OR bNoMon4BlackStart, PT:= T#10s);			(*pump operation feedback has to disappear for 10s to trigger warning, ignore feedback in case of black start*)
	xTON_EmCWP_Dem(IN:= IN_AG.bEmCWP_Dem, PT:= T#175s);
	HBT_8 := xTOF_EmCWP_Fail.Q OR (IN_AG.bEng_Aux_Dem AND IN_AG.bEmCWP_Dem AND HBT_8);	(*case 1: HBT_8 -> monitoring activated as soon as pump operation feedback is active for the first time*)

	xMsg9279.Enable	   := TRUE;
	IF NOT Para.bRedEmCWP_Active THEN
		xMsg9279.Set   := (xTON_EmCWP_Dem.Q OR HBT_8) AND NOT xTOF_EmCWP_Fail.Q AND IN_AG.bEmCWP_Dem;		(*case 2: xTON_EmCWP_Dem -> monitoring activated with delay after pump demand*)
	ELSE
		xMsg9279.Set   := bRedEmCWP_Fail AND ((iRedEmCWP_Fail = 1) OR (iRedEmCWP_Fail = 3));
	END_IF;
	xMsg9279.PT	       := T#2s;
	xMsg9279.Prio 	   := 4;
	xMsg9279.RiskClass := 4;
	xMsg9279.Reset	   := FALSE;
	xMsg9279();
	MM2VIS.bMsg9279    := xMsg9279.Q;

	(* W9280 Maximum number of failed post coolings for turbocharger exceeded; inspection of turbocharger required *)	
	xMsg9280.Enable	   := FALSE AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9280.Set 	   := iCnt_TC_rel_A >= Para.iCnt_TC_Inspection_Hi;			(* if only one TC, counter for bank A is used *)
	xMsg9280.PT	       := T#0s;
	xMsg9280.Prio 	   := 4;
	xMsg9280.RiskClass := 4;
	xMsg9280.Reset	   := FALSE;
	xMsg9280();
	MM2VIS.bMsg9280    := xMsg9280.Q;

	(* W9281 Maximum number of failed post coolings for turbocharger at bank A exceeded; inspection of turbocharger required *)	
	xMsg9281.Enable	   := xEngType.Type9 AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9281.Set 	   := iCnt_TC_rel_A >= Para.iCnt_TC_Inspection_Hi;
	xMsg9281.PT	       := T#0s;
	xMsg9281.Prio 	   := 4;
	xMsg9281.RiskClass := 4;
	xMsg9281.Reset	   := FALSE;
	xMsg9281();
	MM2VIS.bMsg9281    := xMsg9281.Q;

	(* W9282 Maximum number of failed post coolings for turbocharger at bank B exceeded; inspection of turbocharger required *)	
	xMsg9282.Enable	   := xEngType.Type9 AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9282.Set 	   := iCnt_TC_rel_B >= Para.iCnt_TC_Inspection_Hi;
	xMsg9282.PT	       := T#0s;
	xMsg9282.Prio 	   := 4;
	xMsg9282.RiskClass := 4;
	xMsg9282.Reset	   := FALSE;
	xMsg9282();
	MM2VIS.bMsg9282    := xMsg9282.Q;

	(* W9283 Failed post cooling for turbocharger detected *)	
	xMsg9283.Enable	   := NOT xEngType.Type2 AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9283.Set 	   := (EDGEPOS(IN_AG.tPB2MM.bSys_Run) AND iSt_TC_PwrInterrupt.0) OR EDGENEG(bTC_CoolDownInterrupt);
	xMsg9283.PT	       := T#0s;
	xMsg9283.Prio 	   := 4;
	xMsg9283.RiskClass := 4;
	xMsg9283.Reset	   := FALSE;
	xMsg9283();
	MM2VIS.bMsg9283    := xMsg9283.Q;
	
	(* W9303 Measuring signal failure air starter engagement pressure *)	
	xMsg9303.Enable	   := xEngType.Type9;
	xMsg9303.Set 	   := bAMM_Pr_AirST_Engage_Ms;
	xMsg9303.PT	       := T#0s;
	xMsg9303.Prio 	   := 4;
	xMsg9303.RiskClass := 4;
	xMsg9303.Reset	   := FALSE;
	xMsg9303();
	MM2VIS.bMsg9303    := xMsg9303.Q;
	
	(* W9314 Engine cooling water pump circuit breaker tripped *)	
	xMsg9314.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg9314.Set 	   := NOT IN_AG.tECWP_CB_On.Di;
	xMsg9314.PT	       := T#1s;
	xMsg9314.Prio 	   := 4;
	xMsg9314.RiskClass := 4;
	xMsg9314.Reset	   := FALSE;
	xMsg9314();
	MM2VIS.bMsg9314    := xMsg9314.Q;

	(* W9316 Measuring signal failure cooling water pressure after ECW pump 1 *)	
	xMsg9316.Enable	   := Para.bDPr_ECWP_Mon_Active AND IN_AG.tPr_ECWaP1.Exist;
	xMsg9316.Set 	   := NOT IN_AG.tPr_ECWaP1.GoodQual;
	xMsg9316.PT	       := T#1s;
	xMsg9316.Prio 	   := 4;
	xMsg9316.RiskClass := 4;
	xMsg9316.Reset	   := FALSE;
	xMsg9316();
	MM2VIS.bMsg9316    := xMsg9316.Q;

	(* W9317 Measuring signal failure cooling water pressure after ECW pump 2 *)	
	xMsg9317.Enable	   := Para.bDPr_ECWP_Mon_Active AND IN_AG.tPr_ECWaP2.Exist;
	xMsg9317.Set 	   := NOT IN_AG.tPr_ECWaP2.GoodQual;
	xMsg9317.PT	       := T#1s;
	xMsg9317.Prio 	   := 4;
	xMsg9317.RiskClass := 4;
	xMsg9317.Reset	   := FALSE;
	xMsg9317();
	MM2VIS.bMsg9317    := xMsg9317.Q;
	
	(* W9322 Fresh oil tank level low (2nd level switch) *)	
	xMsg9322.Enable	   := IN_AG.tL_FreshOilTank_LoLo.GoodQual;
	xMsg9322.Set 	   := NOT IN_AG.tL_FreshOilTank_LoLo.Di;
	xMsg9322.PT	       := T#0s;
	xMsg9322.Prio 	   := 4;
	xMsg9322.RiskClass := 4;
	xMsg9322.Reset	   := FALSE;
	xMsg9322();
	MM2VIS.bMsg9322    := xMsg9322.Q;
	
	(* W9323 Fresh oil day tank level low *)	
	xMsg9323.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg9323.Set 	   := (IN_AG.tL_DayOilTank_Lo.GoodQual AND NOT IN_AG.tL_DayOilTank_Lo.Di)
					   OR (IN_AG.tL_DayOilTank.GoodQual AND (MM2VIS.rV_DayOilTank < Para.rV_DayOilTank_LimLo) AND (Para.rV_DayOilTank_LimLo > 0)) ;		(*New at V4.12*)
	xMsg9323.PT	       := T#0s;
	xMsg9323.Prio 	   := 4;
	xMsg9323.RiskClass := 4;
	xMsg9323.Reset	   := FALSE;
	xMsg9323();
	MM2VIS.bMsg9323    := xMsg9323.Q;
	
	(* W9324 Fresh oil day tank level low (2nd level switch) *)	
	xMsg9324.Enable	   := IN_AG.tL_DayOilTank_LoLo.GoodQual;
	xMsg9324.Set 	   := NOT IN_AG.tL_DayOilTank_LoLo.Di;
	xMsg9324.PT	       := T#0s;
	xMsg9324.Prio 	   := 4;
	xMsg9324.RiskClass := 4;
	xMsg9324.Reset	   := FALSE;
	xMsg9324();
	MM2VIS.bMsg9324    := xMsg9324.Q;
	
	(* W9325 Overfill prevention device fresh oil day tank tripped *)	
	xMsg9325.Enable	   := IN_AG.tOF_DayOilTank.GoodQual;
	xMsg9325.Set 	   := NOT IN_AG.tOF_DayOilTank.Di;
	xMsg9325.PT	       := T#0s;
	xMsg9325.Prio 	   := 4;
	xMsg9325.RiskClass := 4;
	xMsg9325.Reset	   := FALSE;
	xMsg9325();
	MM2VIS.bMsg9325    := xMsg9325.Q;
	
	(* W9326 Waste oil day tank level high *)	
	xMsg9326.Enable	   := IN_AG.tL_WasteOilDayTank_Hi.GoodQual;
	xMsg9326.Set 	   := NOT IN_AG.tL_WasteOilDayTank_Hi.Di;
	xMsg9326.PT	       := T#0s;
	xMsg9326.Prio 	   := 4;
	xMsg9326.RiskClass := 4;
	xMsg9326.Reset	   := FALSE;
	xMsg9326();
	MM2VIS.bMsg9326    := xMsg9326.Q;
	
	(* W9327 Overfill prevention device waste oil day tank tripped *)	
	xMsg9327.Enable	   := IN_AG.tOF_WasteOilDayTank.GoodQual;
	xMsg9327.Set 	   := NOT IN_AG.tOF_WasteOilDayTank.Di;
	xMsg9327.PT	       := T#0s;
	xMsg9327.Prio 	   := 4;
	xMsg9327.RiskClass := 4;
	xMsg9327.Reset	   := FALSE;
	xMsg9327();
	MM2VIS.bMsg9327    := xMsg9327.Q;
	
	(* W9328 Fresh oil pump oil pressure maximum *)	
	xMsg9328.Enable	   := IN_AG.tPS_FreshOilPump_Hi.GoodQual;
	xMsg9328.Set 	   := NOT IN_AG.tPS_FreshOilPump_Hi.Di;
	xMsg9328.PT	       := T#0s;
	xMsg9328.Prio 	   := 4;
	xMsg9328.RiskClass := 4;
	xMsg9328.Reset	   := FALSE;
	xMsg9328();
	MM2VIS.bMsg9328    := xMsg9328.Q;
	
	(* W9332 Take oil sample *)	
	xMsg9332.Enable	   := Para.bEO_Management_Active AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9332.Set 	   := bMsg9332_set;
	xMsg9332.PT	       := T#0s;
	xMsg9332.Prio 	   := 4;
	xMsg9332.RiskClass := 4;
	xMsg9332.Reset	   := TRUE;
	xMsg9332();
	MM2VIS.bMsg9332    := xMsg9332.Q;

	(* W9333 Take coolant sample *)	
	xMsg9333.Enable	   := Para.bCW_Management_Active AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9333.Set 	   := bMsg9333_set;
	xMsg9333.PT	       := T#0s;
	xMsg9333.Prio 	   := 4;
	xMsg9333.RiskClass := 4;
	xMsg9333.Reset	   := TRUE;
	xMsg9333();
	MM2VIS.bMsg9333    := xMsg9333.Q;

	(* W9334 Buffer battery 1 voltage low *)	
	xMsg9334.Enable	   := IN_AG.tPB2MM.bParaSetupOk AND ((Para.iBatMon_Mode = 1) OR (Para.iBatMon_Mode = 2));
	xMsg9334.Set 	   := bAMM_U_BufferBat1_Lo;
	xMsg9334.PT	       := T#0s;
	xMsg9334.Prio 	   := 4;
	xMsg9334.RiskClass := 4;
	xMsg9334.Reset	   := FALSE;
	xMsg9334();
	MM2VIS.bMsg9334    := xMsg9334.Q;
	
	(* W9335 Buffer battery 2 voltage low *)	
	xMsg9335.Enable	   := IN_AG.tPB2MM.bParaSetupOk AND (Para.iBatMon_Mode = 2);
	xMsg9335.Set 	   := bAMM_U_BufferBat2_Lo;
	xMsg9335.PT	       := T#0s;
	xMsg9335.Prio 	   := 4;
	xMsg9335.RiskClass := 4;
	xMsg9335.Reset	   := FALSE;
	xMsg9335();
	MM2VIS.bMsg9335    := xMsg9335.Q;
	
	(* W9336 Battery charging device malfunction *)	
	xMsg9336.Enable	   := IN_AG.tPB2MM.bParaSetupOk;
	xMsg9336.Set 	   := NOT IN_AG.tBatChargeDev_Ok.Di;
	xMsg9336.PT	       := T#10s;
	xMsg9336.Prio 	   := 4;
	xMsg9336.RiskClass := 4;
	xMsg9336.Reset	   := FALSE;
	xMsg9336();
	MM2VIS.bMsg9336    := xMsg9336.Q;
	
	(* W9352 Oil quality sensor - Measurement signal failure, return to regular sampling interval *)
	xMsg9352.Enable	   := (Para.iOQS_Config = 1) AND IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.bSimWinMOD_Active;
	xMsg9352.Set 	   := bAMM_OQS_OC_MSF;
	xMsg9352.PT	       := T#0s;
	xMsg9352.Prio 	   := 4;
	xMsg9352.RiskClass := 4;
	xMsg9352.Reset	   := FALSE;
	xMsg9352();
	MM2VIS.bMsg9352    := xMsg9352.Q;
	
	(* W9353 Oil quality sensor - Oil quality warning, return to regular sampling interval *)
	xMsg9353.Enable	   := (Para.iOQS_Config = 1) AND IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.bSimWinMOD_Active;
	xMsg9353.Set 	   := bAMM_OQS_OC_ValueLo;
	xMsg9353.PT	       := T#0s;
	xMsg9353.Prio 	   := 4;
	xMsg9353.RiskClass := 4;
	xMsg9353.Reset	   := FALSE;
	xMsg9353();
	MM2VIS.bMsg9353    := xMsg9353.Q;
	
	(* W9354 Oil quality sensor  Critical oil quality warning, return to regular sampling interval *)
	xMsg9354.Enable	   := (Para.iOQS_Config = 1) AND IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.bSimWinMOD_Active;
	xMsg9354.Set 	   := bAMM_OQS_OC_ValueLo1;
	xMsg9354.PT	       := T#0s;
	xMsg9354.Prio 	   := 4;
	xMsg9354.RiskClass := 4;
	xMsg9354.Reset	   := FALSE;
	xMsg9354();
	MM2VIS.bMsg9354    := xMsg9354.Q;
	
	(* W9355 Oil quality sensor  Increased oil aging, return to regular sampling interval *)
	xMsg9355.Enable	   := (Para.iOQS_Config = 1) AND IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.bSimWinMOD_Active;
	xMsg9355.Set 	   := bAMM_OQS_OC_TendencyHi;
	xMsg9355.PT	       := T#0s;
	xMsg9355.Prio 	   := 4;
	xMsg9355.RiskClass := 4;
	xMsg9355.Reset	   := FALSE;
	xMsg9355();
	MM2VIS.bMsg9355    := xMsg9355.Q;
	
	(* W9356 Oil quality sensor - Critical oil aging, return to regular sampling interval *)
	xMsg9356.Enable	   := (Para.iOQS_Config = 1) AND IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.bSimWinMOD_Active;
	xMsg9356.Set 	   := bAMM_OQS_OC_TendencyHi1;
	xMsg9356.PT	       := T#0s;
	xMsg9356.Prio 	   := 4;
	xMsg9356.RiskClass := 4;
	xMsg9356.Reset	   := FALSE;
	xMsg9356();
	MM2VIS.bMsg9356    := xMsg9356.Q;
	
	(* W9357 Control battery voltage low *)
	xMsg9357.Enable	   := IN_AG.tPB2MM.bParaSetupOk AND (iNr_CtrlBat_Used > 0);
	xMsg9357.Set 	   := bAMM_U_CtrlBat_Lo_Coll;
	xMsg9357.PT	       := T#0s;
	xMsg9357.Prio 	   := 4;
	xMsg9357.RiskClass := 4;
	xMsg9357.Reset	   := FALSE;
	xMsg9357();
	MM2VIS.bMsg9357    := xMsg9357.Q;
	
	(* W9358 Control battery charging device malfunction *)
	bAMM_CtrlBat_ChargeDev_Fail		:=	FALSE;
	FOR iIdx_CtrlBat := 1 TO iNum_CtrlBatMon DO
		bAMM_CtrlBat_ChargeDev_Fail	:=	NOT IN_AG.tCtrlBat_ChargeDev_Ok[iIdx_CtrlBat].Di OR bAMM_CtrlBat_ChargeDev_Fail;
		IF NOT IN_AG.tCtrlBat_ChargeDev_Ok[iIdx_CtrlBat].Di THEN
			MM2VIS.sCtrlBat_ChargeDev_LocFault	:=	IN_AG.sLocIdent_CtrlBatMon[iIdx_CtrlBat];
		END_IF;
	END_FOR;
	xMsg9358.Enable	   := IN_AG.tPB2MM.bParaSetupOk AND (iNr_CtrlBat_Used > 0);
	xMsg9358.Set 	   := bAMM_CtrlBat_ChargeDev_Fail;
	xMsg9358.PT	       := T#10s;
	xMsg9358.Prio 	   := 4;
	xMsg9358.RiskClass := 4;
	xMsg9358.Reset	   := FALSE;
	xMsg9358();
	MM2VIS.bMsg9358    := xMsg9358.Q;
	
	(* W9359 Oil pressure before centrifuge (oil filter unit) minimum *)	
	xMsg9359.Enable	   := Para.bOilFiltUnit_Exist AND Para.bPr_OFUbCentrifuge_Active;
	xMsg9359.Set 	   := bAMM_Pr_OFUbCentrifuge_Lo;
	xMsg9359.PT	       := T#2s;
	xMsg9359.Prio 	   := 4;
	xMsg9359.RiskClass := 4;
	xMsg9359.Reset	   := FALSE;
	xMsg9359();
	MM2VIS.bMsg9359    := xMsg9359.Q;

	
	(*W9362 Fresh Oil Tank Signal Failure V4.12 *)
	xMsg9362.Enable		:=  Para.bOilTankMonitoring AND Para.rFreshOilTank_Type > 0;
	xMsg9362.Set 	   := NOT IN_AG.tL_FreshOilTank.GoodQual;
	xMsg9362.PT	       := T#2s;
	xMsg9362.Prio 	   := 4;
	xMsg9362.RiskClass := 4;
	xMsg9362.Reset	   := FALSE;
	xMsg9362();
	MM2VIS.bMsg9362    := xMsg9362.Q;

	(*W9363 Waste Oil Tank Signal Failure V4.12 *)
	xMsg9363.Enable		:=  Para.bOilTankMonitoring AND Para.rWasteOilTank_Type > 0;
	xMsg9363.Set 	   := NOT IN_AG.tL_WasteOilTank.GoodQual;
	xMsg9363.PT	       := T#2s;
	xMsg9363.Prio 	   := 4;
	xMsg9363.RiskClass := 4;
	xMsg9363.Reset	   := FALSE;
	xMsg9363();
	MM2VIS.bMsg9363    := xMsg9363.Q;
	
	(*W9364 Fresh Oil Tank Signal Failure V4.12 *)
	xMsg9364.Enable		:=  Para.bOilTankMonitoring AND Para.rDayOilTank_Type > 0;
	xMsg9364.Set 	   := NOT IN_AG.tL_DayOilTank.GoodQual;
	xMsg9364.PT	       := T#2s;
	xMsg9364.Prio 	   := 4;
	xMsg9364.RiskClass := 4;
	xMsg9364.Reset	   := FALSE;
	xMsg9364();
	MM2VIS.bMsg9364    := xMsg9364.Q;
	
	(*W9369 Failure auxiliaries supply voltage engine V4.12 *)
	xMsg9369.Enable		:= IN_AG.tPB2MM.bParaSetupOk;
	xMsg9369.Set		:= (NOT IN_AG.tAuxV_Eng_ok.Di) AND IN_AG.tAuxV_Eng_ok.GoodQual AND IN_AG.tMnsOk.Di AND IN_AG.tMnsOk.GoodQual;
	xMsg9369.PT			:= T#1m;
	xMsg9369.Prio		:= 4;
	xMsg9369.RiskClass	:= 4;
	xMsg9369.Reset		:= FALSE;
	xMsg9369();
	MM2VIS.bMsg9369    := xMsg9369.Q;

	(*W9378 Oil refill volume maximum *)
	xMsg9378.Enable		:= IN_AG.tPB2MM.bParaSetupOk;
	xMsg9378.Set		:= bAMM_Vol_OilRefill_Hi;
	xMsg9378.PT			:= T#0s;
	xMsg9378.Prio		:= 4;
	xMsg9378.RiskClass	:= 4;
	xMsg9378.Reset		:= FALSE;
	xMsg9378();
	MM2VIS.bMsg9378    	:= xMsg9378.Q;


	(*W9390 Oil temperature before engine start too low *)
	xMsg9390.Enable		:= IN_AG.tPB2MM.bParaSetupOk;
	xMsg9390.Set		:= bAMM_T_EO_PreH_EngStart_Lo;
	xMsg9390.PT			:= T#0s;
	xMsg9390.Prio		:= 4;
	xMsg9390.RiskClass	:= 4;
	xMsg9390.Reset		:= NOT bAMM_T_EO_PreH_EngStart_Lo;
	xMsg9390();
	MM2VIS.bMsg9390    	:= xMsg9390.Q;


	(* A9435 Fire detection system - System failure *)						
	xMsg9435.Enable	   	:= IN_AG.tPB2MM.bParaSetupOk AND IN_AG.bSafetyPLC_Active;			(* SAFETY PLC *)
	xMsg9435.Set	  	:= NOT IN_AG.tFireSysErr.Di;			
	xMsg9435.PT	       	:= T#240s;			
	xMsg9435.Prio	   	:= 3;			
	xMsg9435.RiskClass	:= 4;				
	xMsg9435.Reset	   	:= FALSE;			
	xMsg9435();					
	MM2VIS.bMsg9435		:= xMsg9435.Q;			
							
	(* A9436 Gas detection system - System failure *)						
	xMsg9436.Enable	   	:= IN_AG.tPB2MM.bParaSetupOk AND IN_AG.bSafetyPLC_Active;			(* SAFETY PLC *)
	xMsg9436.Set	  	:= NOT IN_AG.tGasSysErr.Di;			
	xMsg9436.PT	       	:= T#240s;			
	xMsg9436.Prio	   	:= 3;			
	xMsg9436.RiskClass	:= 4;				
	xMsg9436.Reset	   	:= FALSE;			
	xMsg9436();						
	MM2VIS.bMsg9436		:= xMsg9436.Q;			

	(* W9560 Fire detection system - System failure *)						
	xMsg9560.Enable	   	:= IN_AG.tPB2MM.bParaSetupOk AND IN_AG.bSafetyPLC_Active;			(* SAFETY PLC *)
	xMsg9560.Set	  	:= NOT IN_AG.tFireSysErr.Di;			
	xMsg9560.PT	       	:= T#0s;			
	xMsg9560.Prio	   	:= 4;			
	xMsg9560.RiskClass	:= 4;				
	xMsg9560.Reset	   	:= FALSE;			
	xMsg9560();					
	MM2VIS.bMsg9560		:= xMsg9560.Q;			
							
	(* W9561 Gas detection system - System failure *)						
	xMsg9561.Enable	   	:= IN_AG.tPB2MM.bParaSetupOk AND IN_AG.bSafetyPLC_Active;			(* SAFETY PLC *)
	xMsg9561.Set	  	:= NOT IN_AG.tGasSysErr.Di;			
	xMsg9561.PT	       	:= T#0s;			
	xMsg9561.Prio	   	:= 4;			
	xMsg9561.RiskClass	:= 4;				
	xMsg9561.Reset	   	:= FALSE;			
	xMsg9561();						
	MM2VIS.bMsg9561		:= xMsg9561.Q;			
	
	

	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)

	(* B1249 starter engine on *)
	xMsg1249.Enable		:=	TRUE;
	xMsg1249.Set		:= 	(OUT_AG.bEng_Start AND xEngType.Type9) OR (OUT_AG.tEleStarter_Dem.Do AND NOT xEngType.Type9);	
	xMsg1249.Reset		:=	TRUE;
	xMsg1249();
	MM2VIS.bMsg1249		:=	xMsg1249.Q;
	
	(* B1250 starter engine off *)
	xMsg1250.Enable		:=	IN_AG.tPB2MM.bSys_Run;
	xMsg1250.Set		:=	NOT MM2VIS.bMsg1249;
	xMsg1250.Reset		:=	TRUE;
	xMsg1250();
	MM2VIS.bMsg1250		:= xMsg1250.Q;

	(* B1257 demand engine cooling water pump on *)
	xMsg1257.Enable		:=	TRUE;
	xMsg1257.Set		:=	    OUT_AG.tECWP1Dem.Do;
	xMsg1257.Reset		:=	TRUE;
	xMsg1257();
	MM2VIS.bMsg1257		:= xMsg1257.Q;

	(* B1258 demand engine cooling water pump off *)
	xMsg1258.Enable		:=	IN_AG.tPB2MM.bSys_Run;
	xMsg1258.Set		:=	NOT OUT_AG.tECWP1Dem.Do;
	xMsg1258.Reset		:=	TRUE;
	xMsg1258();
	MM2VIS.bMsg1258		:= xMsg1258.Q;

	(* B1259 demand oil pump on *)
	xMsg1259.Enable		:=	TRUE;
	xMsg1259.Set		:=	OUT_AG.tEOP1AC_Dem.Do;
	xMsg1259.Reset		:=	TRUE;
	xMsg1259();
	MM2VIS.bMsg1259		:= xMsg1259.Q;

	(* B1260 demand oil pump off *)
	xMsg1260.Enable		:=	IN_AG.tPB2MM.bSys_Run;
	xMsg1260.Set		:=	NOT OUT_AG.tEOP1AC_Dem.Do;
	xMsg1260.Reset		:=	TRUE;
	xMsg1260();
	MM2VIS.bMsg1260		:= xMsg1260.Q;

	(* B1261 demand oil pump (DC) on *)
	xMsg1261.Enable		:=	NOT xEngType.Type9;
	xMsg1261.Set		:=	    OUT_AG.tEOP1DC_Dem.Do;
	xMsg1261.Reset		:=	TRUE;
	xMsg1261();
	MM2VIS.bMsg1261		:= xMsg1261.Q;

	(* B1262 demand oil pump (DC) off *)
	xMsg1262.Enable		:=	IN_AG.tPB2MM.bSys_Run AND NOT xEngType.Type9;
	xMsg1262.Set		:=	NOT OUT_AG.tEOP1DC_Dem.Do;
	xMsg1262.Reset		:=	TRUE;
	xMsg1262();
	MM2VIS.bMsg1262		:= xMsg1262.Q;

	(* B1263 demand turbo charger oil pump on *)
	xMsg1263.Enable		:=	TRUE;
	xMsg1263.Set		:=  OUT_AG.tTC_EOP_On.Do OR OUT_AG.tTC_EOP_OnUSV.Do;
	xMsg1263.Reset		:=	TRUE;
	xMsg1263();
	MM2VIS.bMsg1263		:= xMsg1263.Q;

	(* B1264 demand turbo charger oil pump off *)
	xMsg1264.Enable		:=	IN_AG.tPB2MM.bSys_Run AND xEngType.Type9;
	xMsg1264.Set		:=	NOT OUT_AG.tTC_EOP_On.Do AND NOT OUT_AG.tTC_EOP_OnUSV.Do;
	xMsg1264.Reset		:=	TRUE;
	xMsg1264();
	MM2VIS.bMsg1264		:= xMsg1264.Q;

	(* B1281 demand engine cooling water preheating pump on *)
	xMsg1281.Enable		:=	TRUE;
	xMsg1281.Set		:=	    OUT_AG.tECWP_PreH_Dem.Do;
	xMsg1281.Reset		:=	TRUE;
	xMsg1281();
	MM2VIS.bMsg1281		:= xMsg1281.Q;

	(* B1282 demand engine cooling water preheating pump off *)
	xMsg1282.Enable		:=	IN_AG.tPB2MM.bSys_Run;
	xMsg1282.Set		:=	NOT OUT_AG.tECWP_PreH_Dem.Do;
	xMsg1282.Reset		:=	TRUE;
	xMsg1282();
	MM2VIS.bMsg1282		:= xMsg1282.Q;

	(* B1292 Manual operating auxiliaries control (Handbedienebene) active *)
	xMsg1292.Enable		:=	IN_AG.tPB2MM.bSys_Run;
	xMsg1292.Set		:=	bMsg1292_Set;
	xMsg1292.Reset		:=	TRUE;
	xMsg1292();
	MM2VIS.bMsg1292		:= xMsg1292.Q;
	
	(* B2809 preheating valve opened *)
	xMsg2809.Enable		:=	IN_AG.tPB2MM.bSys_Run;
	xMsg2809.Set		:=	IN_AG.tECW_PreHV_Opened.Di;
	xMsg2809.Reset		:=	TRUE;
	xMsg2809();
	MM2VIS.bMsg2809		:= xMsg2809.Q;
	
	(* B2810 Preheating valve closed *)
	xMsg2810.Enable		:=	bECW_PreHV_Active;
	xMsg2810.Set		:=	IN_AG.tECW_PreHV_Closed.Di;
	xMsg2810.Reset		:=	TRUE;
	xMsg2810();
	MM2VIS.bMsg2810		:= xMsg2810.Q;
	
	(* B2931 Active Cooling Program in operation *)
	xMsg2931.Enable		:=	Para.bACP_Enable;
	xMsg2931.Set		:=	bACP_Start AND NOT bACP_Cmp;
	xMsg2931.Reset		:=	TRUE;
	xMsg2931();
	MM2VIS.bMsg2931		:= xMsg2931.Q;
	
	(* B2932 Active Cooling Program finished *)
	xMsg2932.Enable		:=	Para.bACP_Enable;
	xMsg2932.Set		:=	bACP_Cmp;
	xMsg2932.Reset		:=	TRUE;
	xMsg2932();
	MM2VIS.bMsg2932		:= xMsg2932.Q;
	
	(* B2933 Active Cooling Program cancelled *)
	xF_TRIG_ACP_Start(CLK := bACP_Start);
	xMsg2933.Enable		:=	Para.bACP_Enable;
	xMsg2933.Set		:=	xF_TRIG_ACP_Start.Q AND NOT bACP_Cmp;
	xMsg2933.Reset		:=	TRUE;
	xMsg2933();
	MM2VIS.bMsg2933		:= xMsg2933.Q;
	
	(* B2956 Demand engine oil preheating valve open *)
	xMsg2956.Enable		:=	IN_AG.tPB2MM.bSys_Run
						AND xEngType.Type9;
	xMsg2956.Set		:=	OUT_AG.tEOF_PreheatRel.Do;
	xMsg2956.Reset		:=	TRUE;
	xMsg2956();
	MM2VIS.bMsg2956		:= xMsg2956.Q;
	
	(* B2957 Demand engine oil preheating valve close *)
	xMsg2957.Enable		:=	IN_AG.tPB2MM.bSys_Run
						AND xEngType.Type9;
	xMsg2957.Set		:=	NOT OUT_AG.tEOF_PreheatRel.Do;
	xMsg2957.Reset		:=	TRUE;
	xMsg2957();
	MM2VIS.bMsg2957		:= xMsg2957.Q;
	
	(* B2978 Blow-by blower on *)	
	xMsg2978.Enable		:=	xEngType.Type9;
	xMsg2978.Set		:=	OUT_AG.tBbBlower.Do;
	xMsg2978.Reset		:=	TRUE;
	xMsg2978();
	MM2VIS.bMsg2978		:= xMsg2978.Q;
	
	(* B2979 Blow-by blower off *)	
	xMsg2979.Enable		:=	xEngType.Type9;
	xMsg2979.Set		:=	NOT OUT_AG.tBbBlower.Do;
	xMsg2979.Reset		:=	TRUE;
	xMsg2979();
	MM2VIS.bMsg2979		:= xMsg2979.Q;

	(* B3300 blocking acknowledgement by starter temperature *)	
	xMsg3300.Enable		:=	TRUE;
	xMsg3300.Set		:=	OUT_AG.bLockAckStarter;
	xMsg3300.Reset		:=	TRUE;
	xMsg3300();
	MM2VIS.bMsg3300		:= xMsg3300.Q;
	
	(* B9001 Oil sample taken *)	
	xMsg9001.Enable		:=	Para.bEO_Management_Active AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9001.Set		:=	bMsg9001_set;
	xMsg9001.Reset		:=	TRUE;
	xMsg9001();
	MM2VIS.bMsg9001		:= xMsg9001.Q;
	
	(* B9002 Oil exchanged *)	
	xMsg9002.Enable		:=	Para.bEO_Management_Active AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9002.Set		:=	bMsg9002_set;
	xMsg9002.Reset		:=	TRUE;
	xMsg9002();
	MM2VIS.bMsg9002		:= xMsg9002.Q;
	
	(* B9003 Coolant sample taken *)	
	xMsg9003.Enable		:=	Para.bCW_Management_Active AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9003.Set		:=	bMsg9003_set;
	xMsg9003.Reset		:=	TRUE;
	xMsg9003();
	MM2VIS.bMsg9003		:= xMsg9003.Q;

	(* B9048 Coolant exchanged *)	
	xMsg9048.Enable		:=	Para.bCW_Management_Active AND IN_AG.tPB2MM.bParaSetupOk;
	xMsg9048.Set		:=	bMsg9048_set;
	xMsg9048.Reset		:=	TRUE;
	xMsg9048();
	MM2VIS.bMsg9048		:= xMsg9048.Q;
	
	(* B9067 Oil sampling interval extended *)	
	xMsg9067.Enable		:=	(Para.iOQS_Config = 1) AND IN_AG.tPB2MM.bParaSetupOk AND NOT IN_AG.bSimWinMOD_Active;
	xMsg9067.Set		:=	bOpMsg_ExtendOilSampleOh;
	xMsg9067.Reset		:=	TRUE;
	xMsg9067();
	MM2VIS.bMsg9067		:= xMsg9067.Q;
	
	(* B9069 Buffer battery test in progress *)
	xMsg9069.Enable		:= IN_AG.tPB2MM.bParaSetupOk AND (Para.iBatMon_Mode > 0);
	xMsg9069.Set		:= MM2VIS.bBatMon_TestRunning;
	xMsg9069.Reset		:= TRUE;
	xMsg9069();
	MM2VIS.bMsg9069		:= xMsg9069.Q;
	
	(* B9070 Control battery test in progress *)
	xMsg9070.Enable		:= IN_AG.tPB2MM.bParaSetupOk AND (iNr_CtrlBat_Used > 0);
	xMsg9070.Set		:= MM2VIS.bCtrlBatMon_TestRunning;
	xMsg9070.Reset		:= TRUE;
	xMsg9070();
	MM2VIS.bMsg9070		:= xMsg9070.Q;

	(* B9074 Tooth to tooth position *)
	xMsg9074.Enable		:= IN_AG.tPB2MM.bParaSetupOk;
	xMsg9074.Set		:= FALSE; // warning message for tooth to tooth detection. Not used yet, already set up in the HMI 
	xMsg9074.Reset		:= TRUE;
	xMsg9074();
	MM2VIS.bMsg9074		:= xMsg9074.Q;
	
	(* B9088 Purge cranking cycle successful *)
	xMsg9088.Enable		:= IN_AG.tPB2MM.bParaSetupOk;
	xMsg9088.Set		:= (bStartScavSflMsg AND xEngType.Type3) OR (bMsg9088_T6_set AND xEngType.Type6);
	xMsg9088.Reset		:= TRUE;
	xMsg9088();
	MM2VIS.bMsg9088 	:= xMsg9088.Q;
	
	(* B9089 Starter motor 1 did not engage *)
	xMsg9089.Enable		:= IN_AG.tPB2MM.bParaSetupOk AND Para.rU_StarterMon_LimLo <> 0.0;
	xMsg9089.Set		:= bEleStarterFail_Num[1];
	xMsg9089.Reset		:= TRUE;
	xMsg9089();
	MM2VIS.bMsg9089		:= xMsg9089.Q;

	(* B9090 Starter motor 2 did not engage *)
	xMsg9090.Enable		:= IN_AG.tPB2MM.bParaSetupOk AND Para.rU_StarterMon_LimLo <> 0.0;
	xMsg9090.Set		:= bEleStarterFail_Num[2];
	xMsg9090.Reset		:= TRUE;
	xMsg9090();
	MM2VIS.bMsg9090		:= xMsg9090.Q;

	(* B9091 Starter motor 3 did not engage *)
	xMsg9091.Enable		:= IN_AG.tPB2MM.bParaSetupOk AND Para.rU_StarterMon_LimLo <> 0.0;
	xMsg9091.Set		:= bEleStarterFail_Num[3];
	xMsg9091.Reset		:= TRUE;
	xMsg9091();
	MM2VIS.bMsg9091		:= xMsg9091.Q;

	(* B9096 Starter overheated *)
	xMsg9096.Enable		:= IN_AG.tPB2MM.bParaSetupOk AND xEngType.Type6;
	xMsg9096.Set		:= bMsg9096_set AND bMsg9096_enable;
	xMsg9096.Reset		:= TRUE;
	xMsg9096();
	MM2VIS.bMsg9096		:= xMsg9096.Q;
	MM2VIS.iNum_Msg9096	:= bMsg9096_iTi_ST_UntRelDur;

	(* B9097 Purge cranking cycle initiated *)
	xMsg9097.Enable		:= IN_AG.tPB2MM.bParaSetupOk AND xEngType.Type6;
	xMsg9097.Set		:= bMsg9097_set;
	xMsg9097.Reset		:= TRUE;
	xMsg9097();
	MM2VIS.bMsg9097		:= xMsg9097.Q;

	(*W9513 Failure engine oil refilling *)
	xMsg9513.Enable 	:= IN_AG.tPB2MM.bParaSetupOk ;
	xMsg9513.Set 		:= bAMM_9513;								
	xMsg9513.PT 		:= Para.tiEO_Refill_TimeMax;
	xMsg9513.Prio 		:= 4;
	xMsg9513.Reset 		:= FALSE;
	xMsg9513();
	MM2VIS.bMsg9513 	:= xMsg9513.Q;

	(* B template 
	xMsg.Enable		:=	TRUE;
	xMsg.Set		:=	bBool;
	xMsg.Reset		:=	TRUE;
	xMsg();
	MM2VIS.bMsg		:=	xMsg.Q;
	*)

	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1		:= OUT_AG.tAG2AB.bGnlTrip1   OR IN_AG.tAB2AG.bGnlTrip1;
	bGnlTrip2		:= OUT_AG.tAG2AB.bGnlTrip2   OR IN_AG.tAB2AG.bGnlTrip2;
	bGnlTrip3		:= OUT_AG.tAG2AB.bGnlTrip3   OR IN_AG.tAB2AG.bGnlTrip3;
	bGnlWarning		:= OUT_AG.tAG2AB.bGnlWarning OR IN_AG.tAB2AG.bGnlWarning;

	bGnlTrip		:= bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
	(*******************************************************************************)
	
	
END_PROGRAM
