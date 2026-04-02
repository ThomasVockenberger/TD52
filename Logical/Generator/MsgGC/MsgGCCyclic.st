(*******************************************************************************
MsgGC	 			 alarms generation MM_generator

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2025

Customized modifications: -
------------------------
 
History:
-------
V0.01.0	02.11.2011	lettenb.	new
V0.01.0	22.04.2013	Denk		xMsg3319.Prio := 3; 	deleted (Copy-paste failure)
		27.05.2013	Lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
V0.02.0 21.06.2013	Zengerer	W3566 added		
V4.00.0 04.03.2014	lettenb.	logger added
V4.00.1	19.05.2014	lettenb.	3566 bugfix
		30.05.2014				1037 prio4 -> 2, bugfix	
V4.00.2	09.12.2014				1036.Enable := TRUE -> IN_GC.tPB2MM.bSys_Run(920 stapelfeld)
								1110 Aktivierung bei BR9 wenn n_nenn 20sec > 750rpm für (Einfahrprogramm 500rpm)(920 stapelfeld)
								1126,2277 bei BR9 nur aktiv wenn n_nenn > 750rpm	(wegen Einfahrprogramm)(920 stapelfeld)	
								2202,2203,2204,2205,2206,2207,2502,2503,2504,2631,2632,2633,2634,2637 added (920)
V4.03.0	22.07.2015	lettenb.	1038,1073,1109,1110,1111,1112,1126,1127,1143,1144 modif. 2690,2691,3393 new, dyn.gridcode III(thaler)
								_TC2 var.removed(bugfix vvm maping failure)
V4.04.0	10.05.2016	lettenb.	1127 monitoring activation acc.specification(kru) removed(bU_Gen_Mon_Ena)
								3468 added(T_GenAirIn2)
		23.02.2017				3440 TON 2s hinzu, unterdrückung 3440 bei wiedereinschaltung hauptschalter/schutzschalter
		28.07.2017	502423184	A2202 AND A2203 disabled due TO SWAT 920 # 3
V4.05.0	06.12.2017	lettenb.	W3566 disabled(->3593/update gridcode functions)
								2316 added, 2277 bMMD_GenAlarmTestOn added, grid code logic(thaler)
		09.04.2018				1036 bParaSetupOk added to avoid alarm at plc startup, bugfix
V4.07.0	19.10.2018	lettenb.	3468 bParaSetupOk added to avoid alarm at plc startup, bugfix
		29.11.2018	lettenb.	2505 delay 10s->120s,3428 delay 120s, 3431 delay 120s, 2998 added
		15.02.2019	lettenb.	3429,3432 delay 0s->120s
		04.03.2019	lettenb.	1038,1144 IN_GC.tP_GenRev_Ext.Di / IN_GC.tI_GenAsy_Ext.Di - DIs act directly on alarms without delay
V4.07.1	04.06.2019	lettenb.	2336 added, 3573 disabled
V4.09.0	02.12.2019	lettenb.	9311 added, acc.VDE-AR-N 4110 / 10.2.3.1(thaler), protection test mapping
		03.02.2020	lettenb.	2156,2157,2998 write max.1x per minute, bugfix
		04.05.2020	lettenb.	xTON_SecTick added for cycle time undependency, bugfix
V4.10.0	22.12.2020	lettenb.	1112: RiskClass setting corr.acc.TI 1100-0111
V4.11.0	25.01.2020	MayerR		9285,9351 added, voltage droop, tU_SetExt_Norm -> tU_SetExtAI_Norm renamed
V4.12.0	21.11.2022	lettenb.	9365,9366,9367,9368 added, automatic bearing greasing system
								1109,1110: avoid alarm during gen.dexcitation and gcb closing to dead bb(DUB15 BF43),#912
		19.12.2022	Perktold	added comments for sr-code (EN 13849-1 / 4.6.3) for A1038
V4.13.0	12.06.2023	Rimal		2371 and 2372 added, oilskid
		04.07.2023	Perktold	A2373 and W9372 added, earth fault protection via MMD signals
V4.14.0	17.10.2024	Theobald	Alarm 1112,1121,1122,1123,1124,1125,1143,1144 priority changed from 2 to 3 (2024-223)
		25.10.2024	Farre		Reverse power status OUT_GC.bPact_Rev to SY (2024-241)
		18.11.2024	Farre		Enable "unbalance current monitoring A1144" based on Para.bCAsym_Ena (2024-234)
		04.03.2025	Perktold	Alarm 1144 priority changed back to 2 (from 3)

Instructions for use:
--------------------
1) declare alarm with function block "Alm"
	declare buffert alarm bit MM2VIS.bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	MM2VIS.bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	

3)  expand INIT
			
Outstandings:
------------
sort msg by number
(*******************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)		
	OUT_GC.tGC2AB.bGnlTrip1		:=	FALSE;
	OUT_GC.tGC2AB.bGnlTrip2		:=	FALSE;
	OUT_GC.tGC2AB.bGnlTrip3		:=	FALSE;
	OUT_GC.tGC2AB.bGnlWarning	:=	FALSE;
	OUT_GC.tGC2AB.bTriptype1	:=	FALSE;
	OUT_GC.tGC2AB.bTriptype2	:=	FALSE;
	OUT_GC.tGC2AB.bTriptype3	:=	FALSE;	


	(*------------------------------------------------------------------------------*)
	xGR_MAX_M_D_1400(In := IN_GC.rN_EngAct,Gw := Para.rN_EngNom - 100.0, Hy := 10);
	M_D1400 := xGR_MAX_M_D_1400.Q AND IN_GC.tPB2MM.bParaSetupOk;
	
	xTON_FG_GENUW(IN := M_D1400 AND NOT IN_GC.tGenDeexitDem.Do, PT := T#20s);
	bU_Gen_Mon_Ena := xTON_FG_GENUW.Q;
    
	xTON_Eng_Run_10s(IN := IN_GC.tEng_Run.Do , PT := T#10s);
	bEng_Run_10s := xTON_Eng_Run_10s.Q;
	
	xTON_Eng_Run_20s(IN := IN_GC.tEng_Run.Do , PT := T#20s);
	bEng_Run_20s := xTON_Eng_Run_20s.Q;	
	
	xGR_MAXR_M_HDREHZ(In := IN_GC.rN_EngAct , Gw := Para.rN_EngStart_LimHiHi, Hy := Para.rN_EngStart_HyHiHi );
	M_HDREHZ := xGR_MAXR_M_HDREHZ.Q AND IN_GC.tPB2MM.bParaSetupOk;
	
	xTON_AT24.IN := (IN_GC.tGCB_On.Di OR M_HDREHZ) AND (IN_GC.tEng_Run.Do OR (NOT IN_GC.tEng_SUExc_Rel.Di));
	xTON_AT24.PT := Para.tiP_Gen_Reverse;
	xTON_AT24();
	bP_Gen_Reverse := xTON_AT24.Q;
	
	xTP_RLSG_W.IN := IN_GC.bEng_Dem_EPS;	
	xTP_RLSG_W.PT := Para.tiP_Reverse_Mon_Ena;
	xTP_RLSG_W();
	bP_Reverse_Mon_Ena := xTP_RLSG_W.Q;

	
	(* A1036 Generator overload/short circuit *)
	xMsg1036.Enable    := IN_GC.tPB2MM.bParaSetupOk;
	xMsg1036.Set       := NOT IN_GC.tOlShortCirc.Di;
	xMsg1036.PT        := T#0s;
	xMsg1036.RiskClass := 4;
	xMsg1036.Prio      := 2;
	xMsg1036.Reset     := FALSE;
	xMsg1036(); 
	OUT_GC.bMsg1036    := xMsg1036.Q;
	MM2VIS.bMsg1036    := xMsg1036.Q;

	(* A1037 generator winding temperature high (kaltleiter) *)
	xMsg1037.Enable    := NOT Para.bT_Gen_Wind_Ena;
	xMsg1037.Set       := bT_Gen_Wind_Max AND NOT MM2VIS.bMsg2105;
	xMsg1037.PT        := T#0s;
	xMsg1037.RiskClass := 4;
	xMsg1037.Prio      := 2;
	xMsg1037.Reset     := FALSE;
	xMsg1037();
	MM2VIS.bMsg1037    := xMsg1037.Q;	
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)

	(* A1038 Generator reverse power *)
	xTON_GSEIN(IN := IN_GC.tGCB_On.Di, PT := T#1m);
	SY_1m_rlsg := xTON_GSEIN.Q;	
	
	xGR_MIN_AN_RLSG(In := IN_GC.rP_Act_Norm_Filt * IN_GC.rP_Nom, Gw := Para.rP_Reverse , Hy := Para.rP_Reverse_Hy);
	AN_RLSG := IN_GC.tPB2MM.bParaSetupOk AND xGR_MIN_AN_RLSG.Q;
	OUT_GC.bPact_Rev := AN_RLSG;	

	IF IN_GC.bMMD_GenAlarmTestOn THEN	xTON_T28(IN:= AN_RLSG, PT:= Para.tiP_Gen_Reverse2);
	ELSE								xTON_T28(IN:= AN_RLSG AND bP_Gen_Reverse AND NOT bP_Reverse_Mon_Ena, PT:= Para.tiP_Gen_Reverse2);
	END_IF;

	T28 := xTON_T28.Q AND (NOT IN_GC.bSCO_Active OR NOT Para.bGlowIgnPrevActive);	 
	
	OUT_GC.bGCB_Off_RP := T28 AND (NOT MM2VIS.bMsg1038);	
	
	(* Detect when GCB_Off_RP turns TRUE *)
	xR_TRIG_GCB_Off_RP(CLK := OUT_GC.bGCB_Off_RP);	
		
	(* B3298 gcb opened by generator reverse power *)
	xTOF_GCB_Off_RP(IN := xR_TRIG_GCB_Off_RP.Q, PT:=T#10s);
	MM2VIS.bMsg3298 := xTOF_GCB_Off_RP.Q;	
	
	xR_TRIG_T28(CLK := T28);
	
	IF xMsg1038.Q THEN
		xTP_RLSG2(IN := FALSE, PT := T#0s);
	ELSE		
		xTP_RLSG2(IN := xR_TRIG_T28.Q AND RLSG1_arise, PT := T#60m);
	END_IF;	
	
	RLSG2_arise := xTP_RLSG2.Q;	
				
	IF xMsg1038.Q THEN
		xTP_RLSG1(IN := FALSE, PT := T#0s);
	ELSE		
		xTP_RLSG1(IN := xR_TRIG_T28.Q, PT := T#60m);
	END_IF;
	
	RLSG1_arise := xTP_RLSG1.Q;			
	
	xCTD_RLSG2(CD := T28, LOAD := NOT RLSG2_arise, PV := 3);
	xCTD_RLSG1(CD := T28, LOAD := NOT RLSG1_arise, PV := 3);	
	STO_RLSG := xCTD_RLSG1.Q OR xCTD_RLSG2.Q;	

	xMsg1038.Enable    := TRUE;
	xMsg1038.Set       := (T28 AND ((IN_GC.tGCB_On.Di AND (NOT IN_GC.tMCB_On.Di)) OR SY_1m_rlsg))
	                OR     STO_RLSG 
					OR    (IN_GC.bMMD_GenAlarmTestOn AND xTON_T28.Q)
					OR NOT IN_GC.tP_GenRev_Ext.Di;
	xMsg1038.PT        := T#0s;
	xMsg1038.RiskClass := 10;
	xMsg1038.Prio      := 2;
	xMsg1038.Reset     := FALSE;
	xMsg1038(); 
	OUT_GC.bMsg1038    := xMsg1038.Q;
	MM2VIS.bMsg1038    := xMsg1038.Q;
	MM2VIS.bMsg1038Set := xMsg1038.Set;
	OUT_GC.bMsg1038Set := xMsg1038.Set;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	(* A1062 Measurement signal Excitation voltage (--> generally deactivated) *) 
	xMsg1062.Enable    := FALSE;
	xMsg1062.Set       := NOT IN_GC.tU_Gen_Exc.GoodQual AND FALSE;
	xMsg1062.PT        := T#0s;
	xMsg1062.RiskClass := 4;
	xMsg1062.Prio      := 2;
	xMsg1062.Reset     := FALSE;
	xMsg1062();
	MM2VIS.bMsg1062    := xMsg1062.Q;
	
	(* A1073 Multi measurement device: generator overload/short circuit *)
	xMsg1073.Enable    := TRUE;
	xMsg1073.Set       := NOT IN_GC.tI_MMD_LimHi.Di;
	xMsg1073.PT        := T#0s;
	xMsg1073.RiskClass := 4;
	xMsg1073.Prio      := 2;
	xMsg1073.Reset     := FALSE;
	xMsg1073(); 
	OUT_GC.bMsg1073    := xMsg1073.Q;
	MM2VIS.bMsg1073    := xMsg1073.Q;
	
	(* A1109 generator loss of excitation *)
	xTOF_GenDeexitDem(IN:= IN_GC.tGenDeexitDem.Do, PT:= T#5s); (* no monitoring during generator deexcitation *)
	xTP_gcb_on2dead_bb(IN:= IN_GC.bGCB_aut_on2dead_bb, PT:= T#5s);

	xMsg1109.Enable    := TRUE;
	xMsg1109.Set       := NOT xTOF_GenDeexitDem.Q
                  AND     (bPF_CosPCtr_Trip         AND bP_Gen_Reverse AND NOT bP_Reverse_Mon_Ena)
					OR(NOT IN_GC.tGenLossExc_Ext.Di AND bP_Gen_Reverse AND NOT bP_Reverse_Mon_Ena)
					OR    (bPF_CosPCtr_Trip AND IN_GC.bMMD_GenAlarmTestOn);

	IF NOT xTP_gcb_on2dead_bb.Q THEN xMsg1109.PT := T#100ms;
	ELSE                        	 xMsg1109.PT := T#3s;
	END_IF;

	xMsg1109.RiskClass := 2;
	xMsg1109.Prio      := 2;
	xMsg1109.Reset     := FALSE;
	xMsg1109();
	MM2VIS.bMsg1109    := xMsg1109.Q;	
	MM2VIS.bMsg1109Set := xMsg1109.Set;
	OUT_GC.bMsg1109Set := xMsg1109.Set;	
	
	(* A1110 Generator frequency too low *)
	xTON_N_EngNom750(IN:= (Para.rN_EngNom > 750), PT:= T#20s);  // Deaktivierung für Einfahrprogramm BR9 500rpm
	xTON_Eng_Run_48s(IN:= IN_GC.tEng_Run.Do, PT:= T#48s);
	bEng_Run_48s := xTON_Eng_Run_48s.Q;	

	xMsg1110.Enable    := TRUE;
	IF IN_GC.bMMD_GenAlarmTestOn THEN	xMsg1110.Set := NOT IN_GC.tF_MMD_LimLo[1].Di;
	ELSIF xEngType.Type9         THEN	xMsg1110.Set := NOT IN_GC.tF_MMD_LimLo[1].Di AND NOT xTOF_GenDeexitDem.Q AND bEng_Run_48s AND NOT bP_Reverse_Mon_Ena AND xTON_N_EngNom750.Q;
	ELSE								xMsg1110.Set := NOT IN_GC.tF_MMD_LimLo[1].Di AND NOT xTOF_GenDeexitDem.Q AND bEng_Run_20s AND NOT bP_Reverse_Mon_Ena;
	END_IF;

	IF NOT xTP_gcb_on2dead_bb.Q THEN xMsg1110.PT := T#100ms;
	ELSE                        	 xMsg1110.PT := T#3s;
	END_IF;

	xMsg1110.RiskClass := 1;
	xMsg1110.Prio      := 2;
	xMsg1110.Reset     := FALSE;
	xMsg1110(); 
	MM2VIS.bMsg1110    := xMsg1110.Q;
	MM2VIS.bMsg1110Set := xMsg1110.Set;
	OUT_GC.bMsg1110Set := xMsg1110.Set;
	
	(* A1111 Generator frequency too high *)
	xMsg1111.Enable    := TRUE;
	xMsg1111.Set       := (NOT IN_GC.tF_MMD_LimHi[1].Di AND bP_Gen_Reverse AND NOT bP_Reverse_Mon_Ena)
					   OR (NOT IN_GC.tF_MMD_LimHi[1].Di AND IN_GC.bMMD_GenAlarmTestOn);
	xMsg1111.PT        := T#0s;
	xMsg1111.RiskClass := 4;
	xMsg1111.Prio      := 2;
	xMsg1111.Reset     := FALSE;
	xMsg1111(); 
	MM2VIS.bMsg1111    := xMsg1111.Q;
	MM2VIS.bMsg1111Set := xMsg1111.Set;
	OUT_GC.bMsg1111Set := xMsg1111.Set;
	
	(* A1112 Neutral current maximum *)
	xMsg1112.Enable    := TRUE;
	xMsg1112.Set       := NOT IN_GC.tI_MMD_Neutr_LimHi[1].Di;
	xMsg1112.PT        := T#0s;
	xMsg1112.RiskClass := 2;
	xMsg1112.Prio      := 3;
	xMsg1112.Reset     := FALSE;
	xMsg1112(); 
	MM2VIS.bMsg1112    := xMsg1112.Q;
	MM2VIS.bMsg1112Set := xMsg1112.Set;
	OUT_GC.bMsg1112Set := xMsg1112.Set;
	
	(* A1113 Generator power measuring signal failure - for gen.power from Ai *)
	xMsg1113.Enable    := FALSE; (* true for mech.drive !!*)
	xMsg1113.Set       := NOT IN_GC.tP_Act[1].GoodQual AND bOMSS_Man AND NOT bP_Reverse_Mon_Ena;
	xMsg1113.PT        := T#1s;
	xMsg1113.RiskClass := 1;
	xMsg1113.Prio      := 2;
	xMsg1113.Reset     := FALSE;
	xMsg1113(); 
	MM2VIS.bMsg1113    := xMsg1113.Q;		
	
	(* A1121 Generator winding temperature L1 Maximum *)
	xMsg1121.Enable    := Para.bT_Gen_Wind_Ena;
	xMsg1121.Set       := bT_Gen_Wind_L1_Max AND NOT MM2VIS.bMsg2106;
	xMsg1121.PT        := T#0s;
	xMsg1121.RiskClass := 4;
	xMsg1121.Prio      := 3;
	xMsg1121.Reset     := FALSE;
	xMsg1121();
	MM2VIS.bMsg1121    := xMsg1121.Q;

	(* A1122 Generator winding temperature L2 Maximum *)
	xMsg1122.Enable    := Para.bT_Gen_Wind_Ena;
	xMsg1122.Set       := bT_Gen_Wind_L2_Max AND NOT MM2VIS.bMsg2107;
	xMsg1122.PT        := T#0s;
	xMsg1122.RiskClass := 4;
	xMsg1122.Prio      := 3;
	xMsg1122.Reset     := FALSE;
	xMsg1122();
	MM2VIS.bMsg1122    := xMsg1122.Q;

	(* A1123 Generator winding temperature L3 Maximum *)
	xMsg1123.Enable    := Para.bT_Gen_Wind_Ena;	
	xMsg1123.Set       := bT_Gen_Wind_L3_Max AND NOT MM2VIS.bMsg2108;
	xMsg1123.PT        := T#0s;
	xMsg1123.RiskClass := 4;
	xMsg1123.Prio      := 3;
	xMsg1123.Reset     := FALSE;
	xMsg1123();
	MM2VIS.bMsg1123    := xMsg1123.Q;	
	
	(* A1124 Generator bearing temperature A maximum *)
	xMsg1124.Enable    := Para.bT_Gen_Bear_A_Ena;
	xMsg1124.Set       := bT_Gen_Bear_A_Max AND NOT MM2VIS.bMsg2109;
	xMsg1124.PT        := T#0s;
	xMsg1124.RiskClass := 4;
	xMsg1124.Prio      := 3;
	xMsg1124.Reset     := FALSE;
	xMsg1124();
	MM2VIS.bMsg1124    := xMsg1124.Q;


	(* A1125 Generator bearing temperature B maximum *)
	xMsg1125.Enable    := Para.bT_Gen_Bear_B_Ena;
	xMsg1125.Set       := bT_Gen_Bear_B_Max AND NOT MM2VIS.bMsg2110;
	xMsg1125.PT        := T#0s; 
	xMsg1125.RiskClass := 4;
	xMsg1125.Prio      := 3;
	xMsg1125.Reset     := FALSE;
	xMsg1125();
	MM2VIS.bMsg1125    := xMsg1125.Q;	
	
	(* A1126 Generator voltage low *)
	xMsg1126.Enable    := TRUE;
	IF IN_GC.bMMD_GenAlarmTestOn THEN	xMsg1126.Set := NOT IN_GC.tU_Gen_LimLo[1].Di;
	ELSIF xEngType.Type9 		 THEN	xMsg1126.Set := NOT IN_GC.tU_Gen_LimLo[1].Di AND bU_Gen_Mon_Ena AND(Para.rN_EngNom > 750);// Deaktivierung für Einfahrprogramm BR9 500rpm
	ELSE								xMsg1126.Set := NOT IN_GC.tU_Gen_LimLo[1].Di AND bU_Gen_Mon_Ena;
	END_IF;
	xMsg1126.PT        := T#0s;
	xMsg1126.RiskClass := 4;
	xMsg1126.Prio      := 2;
	xMsg1126.Reset     := FALSE; 
	xMsg1126(); 
	MM2VIS.bMsg1126    := xMsg1126.Q;
	MM2VIS.bMsg1126Set := xMsg1126.Set;
	OUT_GC.bMsg1126Set := xMsg1126.Set;
	
	(* A1127 Generator voltage high *)
	xMsg1127.Enable    := TRUE;
	xMsg1127.Set       :=  NOT IN_GC.tU_Gen_LimHi[1].Di;
	xMsg1127.PT        := T#0s;
	xMsg1127.RiskClass := 4;
	xMsg1127.Prio      := 2;
	xMsg1127.Reset     := FALSE;
	xMsg1127(); 
	MM2VIS.bMsg1127    := xMsg1127.Q;
	MM2VIS.bMsg1127Set := xMsg1127.Set;
	OUT_GC.bMsg1127Set := xMsg1127.Set;
	
	(* A1132 Differential protection *)
	xSR_FG_DIFFUW(SET1  := M_D1400,
				  RESET := IN_GC.bEng_Start OR (NOT M_D1400 AND NOT IN_GC.bGV_On AND NOT IN_GC.bEng_Dem AND NOT IN_GC.tGCB_On.Di));	
	xMsg1132.Enable    := TRUE;
	xMsg1132.Set       := NOT IN_GC.tDiffPrct.Di AND (xSR_FG_DIFFUW.Q1  OR (NOT Para.bPF_CosPCtr_Diff_Ena));
	xMsg1132.PT        := T#0s;
	xMsg1132.RiskClass := 4;
	xMsg1132.Prio      := 2;
	xMsg1132.Reset     := FALSE; 
	xMsg1132(); 
	OUT_GC.bMsg1132    := xMsg1132.Q;
	MM2VIS.bMsg1132    := xMsg1132.Q;
	
	(* A1134 Earth failure generator *)(* W9311 *)
	xMsg1134.Enable    := TRUE;
	xMsg1134.Set       := NOT IN_GC.tGndFailure.Di;
	xMsg1134.PT        := T#0s;
	xMsg1134.RiskClass := 4;
	xMsg1134.Prio      := 2;
	xMsg1134.Reset     := FALSE; 
	xMsg1134(); 
	OUT_GC.bMsg1134    := xMsg1134.Q;
	MM2VIS.bMsg1134    := xMsg1134.Q;

	
	(* A1143 Voltage negative sequence *)
	xGR_MAXR_DREHZ(In := IN_GC.rN_EngAct, Gw := 0.933 * Para.rN_EngNom, Hy := 0.0);
	FG_UASY := IN_GC.tEng_Run.Do AND xGR_MAXR_DREHZ.Q;
	
	xTON_UASY    (IN := NOT IN_GC.tU_MMD_Asy[1].Di AND FG_UASY,PT := T#3s);
	xTON_UASY_Ext(IN := NOT IN_GC.tU_GenAsy_Ext.Di AND FG_UASY,PT := T#3s);
	
	xMsg1143.Enable    := TRUE;
	xMsg1143.Set       := (NOT IN_GC.tU_MMD_Asy[1].Di AND FG_UASY AND xTON_UASY.Q)
					   OR (NOT IN_GC.tU_GenAsy_Ext.Di AND FG_UASY AND xTON_UASY_Ext.Q)	
					   OR (NOT IN_GC.tU_MMD_Asy[1].Di AND IN_GC.bMMD_GenAlarmTestOn);
 	xMsg1143.PT        := T#0s;
	xMsg1143.RiskClass := 4;
	xMsg1143.Prio      := 3;
	xMsg1143.Reset     := FALSE; 
	xMsg1143(); 
	MM2VIS.bMsg1143    := xMsg1143.Q;
	MM2VIS.bMsg1143Set := xMsg1143.Set;
	OUT_GC.bMsg1143Set := xMsg1143.Set;

	
	(* A1144 Current negative sequence *)
	xTON_GSEIN(IN := IN_GC.tGCB_On.Di , PT := T#1m);
	SY_1m_iasy          := xTON_GSEIN.Q;	
	
	bIASY               := (NOT IN_GC.tI_MMD_Asy[1].Di  AND bEng_Run_10s);	
	OUT_GC.bGCB_Off_CNS := Para.bCAsym_Ena AND bIASY AND (NOT MM2VIS.bMsg1144);
	
	(* Detect when GCB_Off_CNS turns TRUE *)
	xR_TRIG_GCB_Off_CNS(CLK := OUT_GC.bGCB_Off_CNS);
	
	(* B3299 Generator circuit breaker opened by current negative sequence *)	
	xTOF_GCB_Off_CNS(IN := xR_TRIG_GCB_Off_CNS.Q, PT := T#10s);
	MM2VIS.bMsg3299 := xTOF_GCB_Off_CNS.Q;
	
	xR_TRIG_bIASY(CLK := bIASY);
	IF xMsg1144.Q THEN
		xTP_IASY2(IN := FALSE, PT := T#0s);	
	ELSE		
		xTP_IASY2(IN := xR_TRIG_bIASY.Q AND IASY1_arise, PT := T#60m);					
	END_IF;	
	
	IASY2_arise := xTP_IASY2.Q;
	
	IF xMsg1144.Q THEN
		xTP_IASY1(IN := FALSE, PT := T#0s);
	ELSE		
		xTP_IASY1(IN := xR_TRIG_bIASY.Q, PT := T#60m);
	END_IF;
	
	IASY1_arise := xTP_IASY1.Q;
		
	xCTD_IASY1(CD := bIASY, LOAD := NOT IASY1_arise, PV := 3);	
	xCTD_IASY2(CD := bIASY, LOAD := NOT IASY2_arise, PV := 3);
	STO_IASY      := xCTD_IASY1.Q OR xCTD_IASY2.Q;
	
	xMsg1144.Enable := TRUE;
	xMsg1144.Set    := Para.bCAsym_Ena
						AND ((bIASY AND ((IN_GC.tGCB_On.Di AND NOT IN_GC.tMCB_On.Di) OR SY_1m_iasy))
							OR  STO_IASY 
							OR (NOT IN_GC.tI_MMD_Asy[1].Di AND IN_GC.bMMD_GenAlarmTestOn)
							OR  NOT IN_GC.tI_GenAsy_Ext.Di);	
	xMsg1144.PT        := T#0s;
	xMsg1144.RiskClass := 4;
	xMsg1144.Prio      := 2;
	xMsg1144.Reset     := FALSE; 
	xMsg1144(); 
	MM2VIS.bMsg1144    := xMsg1144.Q;
	MM2VIS.bMsg1144Set := xMsg1144.Set;
	OUT_GC.bMsg1144Set := xMsg1144.Set;
	
	(* W1154 Winding temperature L1 maximum *)
	xMsg1154.Enable    := Para.bT_Gen_Wind_Ena;
	xMsg1154.Set       := bT_Gen_Wind_L1_Lim AND NOT MM2VIS.bMsg2106;
	xMsg1154.PT        := T#0s;
	xMsg1154.RiskClass := 4;
	xMsg1154.Prio      := 4;
	xMsg1154.Reset     := FALSE;
	xMsg1154();
	MM2VIS.bMsg1154    := xMsg1154.Q;	

	(* W1155 Winding temperature L2 maximum *)
	xMsg1155.Enable    := Para.bT_Gen_Wind_Ena;
	xMsg1155.Set       := bT_Gen_Wind_L2_Lim AND NOT MM2VIS.bMsg2107;
	xMsg1155.PT        := T#0s;
	xMsg1155.RiskClass := 4;
	xMsg1155.Prio      := 4;
	xMsg1155.Reset     := FALSE;
	xMsg1155();
	MM2VIS.bMsg1155    := xMsg1155.Q;	
	
	(* W1156 Winding temperature L3 maximum *)
	xMsg1156.Enable    := Para.bT_Gen_Wind_Ena;
	xMsg1156.Set       := bT_Gen_Wind_L3_Lim AND NOT MM2VIS.bMsg2108;
	xMsg1156.PT        := T#0s;
	xMsg1156.RiskClass := 4;
	xMsg1156.Prio      := 4;
	xMsg1156.Reset     := FALSE;
	xMsg1156();
	MM2VIS.bMsg1156    := xMsg1156.Q;	
	
	(* W1157 Bearing temperature A maximum *)
	xMsg1157.Enable    := Para.bT_Gen_Bear_A_Ena;
	xMsg1157.Set       := bT_Gen_Bear_A_Lim AND NOT MM2VIS.bMsg2109;
	xMsg1157.PT        := T#0s;
	xMsg1157.RiskClass := 4;
	xMsg1157.Prio      := 4;
	xMsg1157.Reset     := FALSE;
	xMsg1157();
	MM2VIS.bMsg1157    := xMsg1157.Q;	
	
	(* W1158 Bearing temperature B maximum *)
	xMsg1158.Enable    := Para.bT_Gen_Bear_B_Ena; 
	xMsg1158.Set       := bT_Gen_Bear_B_Lim AND NOT MM2VIS.bMsg2110;
	xMsg1158.PT        := T#0s;
	xMsg1158.RiskClass := 4;
	xMsg1158.Prio      := 4;
	xMsg1158.Reset     := FALSE;
	xMsg1158();
	MM2VIS.bMsg1158    := xMsg1158.Q;
	
	(* W1185 Winding temperature maximum *)
	xMsg1185.Enable    := NOT Para.bT_Gen_Wind_Ena;
	xMsg1185.Set       := bT_Gen_Wind_Lim AND NOT MM2VIS.bMsg2105;
	xMsg1185.PT        := T#0s;
	xMsg1185.RiskClass := 4;
	xMsg1185.Prio      := 4;
	xMsg1185.Reset     := FALSE;
	xMsg1185();
	MM2VIS.bMsg1185    := xMsg1185.Q;
	
	(* W2100 Differential protection relay failure *)
	xMsg2100.Enable    := TRUE;
	xMsg2100.Set       := NOT IN_GC.tI_Diff.Di;
	xMsg2100.PT        := T#0s;
	xMsg2100.RiskClass := 4;
	xMsg2100.Prio      := 4;
	xMsg2100.Reset     := FALSE; 
	xMsg2100(); 
	MM2VIS.bMsg2100    := xMsg2100.Q;

	(* W2105 Measurement signal Generator winding temperature *)
	xMsg2105.Enable    := NOT Para.bT_Gen_Wind_Ena;
	xMsg2105.Set       := NOT IN_GC.tT_Gen_Wind.GoodQual AND IN_GC.tPB2MM.bParaSetupOk;
	xMsg2105.PT        := T#0s;
	xMsg2105.RiskClass := 4;
	xMsg2105.Prio      := 4;
	xMsg2105.Reset     := FALSE;
	xMsg2105();
	MM2VIS.bMsg2105    := xMsg2105.Q;
	
	(* W2106 Measurement signal Generator winding temperature L1 *)
	xMsg2106.Enable    := Para.bT_Gen_Wind_Ena;
	xMsg2106.Set       := NOT IN_GC.tT_Gen_Wind_Act_L1.GoodQual AND IN_GC.tPB2MM.bParaSetupOk;
	xMsg2106.PT        := T#0s;
	xMsg2106.RiskClass := 4;
	xMsg2106.Prio      := 4;
	xMsg2106.Reset     := FALSE;
	xMsg2106();
	MM2VIS.bMsg2106    := xMsg2106.Q;
	
	(* W2107 Measurement signal Generator winding temperature L2 *)
	xMsg2107.Enable    := Para.bT_Gen_Wind_Ena;
	xMsg2107.Set       := NOT IN_GC.tT_Gen_Wind_Act_L2.GoodQual AND IN_GC.tPB2MM.bParaSetupOk;
	xMsg2107.PT        := T#0s;
	xMsg2107.RiskClass := 4;
	xMsg2107.Prio      := 4;
	xMsg2107.Reset     := FALSE;
	xMsg2107();
	MM2VIS.bMsg2107    := xMsg2107.Q;	
	
	(* W2108 Measurement signal Generator winding temperature L3 *)
	xMsg2108.Enable    := Para.bT_Gen_Wind_Ena;
	xMsg2108.Set       := NOT IN_GC.tT_Gen_Wind_Act_L3.GoodQual AND IN_GC.tPB2MM.bParaSetupOk;
	xMsg2108.PT        := T#0s;
	xMsg2108.RiskClass := 4;
	xMsg2108.Prio      := 4;
	xMsg2108.Reset     := FALSE;
	xMsg2108();
	MM2VIS.bMsg2108    := xMsg2108.Q;	
	
	(* W2109 Measurement signal Generator bearing A temperature *)
	xMsg2109.Enable    := Para.bT_Gen_Bear_A_Ena;
	xMsg2109.Set       := NOT IN_GC.tT_Gen_Bear_A_Act.GoodQual AND IN_GC.tPB2MM.bParaSetupOk;
	xMsg2109.PT        := T#0s;
	xMsg2109.RiskClass := 4;
	xMsg2109.Prio      := 4;
	xMsg2109.Reset     := FALSE;
	xMsg2109();
	MM2VIS.bMsg2109    := xMsg2109.Q;	
	
	(* W2110 Measurement signal Generator bearing B temperature *)
	xMsg2110.Enable    := Para.bT_Gen_Bear_B_Ena;
	xMsg2110.Set       := NOT IN_GC.tT_Gen_Bear_B_Act.GoodQual AND IN_GC.tPB2MM.bParaSetupOk;
	xMsg2110.PT        := T#0s;
	xMsg2110.RiskClass := 4;
	xMsg2110.Prio      := 4;
	xMsg2110.Reset     := FALSE;
	xMsg2110();
	MM2VIS.bMsg2110    := xMsg2110.Q;	
		
	(* W2115 Generator voltage regulator failure *)
	xTON_GENREG_F(IN := ((    IN_GC.tU_Gen_Contr_Fail.Di AND NOT Para.bU_Gen_Contr_Sel) OR 
	                     (NOT IN_GC.tU_Gen_Contr_Fail.Di AND     Para.bU_Gen_Contr_Sel)) , PT := Para.ti_Gen_VoltReg_Fail);
	ZM_GENREG_F        := xTON_GENREG_F.Q;
	
	xMsg2115.Enable    := TRUE;
	xMsg2115.Set       := ZM_GENREG_F AND bEng_Run_10s;
	xMsg2115.PT        := T#0s;
	xMsg2115.RiskClass := 4;
	xMsg2115.Prio      := 4;
	xMsg2115.Reset     := FALSE; 
	xMsg2115(); 
	MM2VIS.bMsg2115    :=  xMsg2115.Q;

	(*  2202 generator DE bearing displacement trip *)
	xGR_MAX_F_GenBearDE1_HiHi(In:= IN_GC.tF_GenBear_DE1.Ai, Gw:= Para.rF_GenBear_HiHi, Hy:= 0.0);
	xGR_MAX_F_GenBearDE2_HiHi(In:= IN_GC.tF_GenBear_DE2.Ai, Gw:= Para.rF_GenBear_HiHi, Hy:= 0.0);

	xMsg2202.Enable    := FALSE; //SWAT920#3;
	xMsg2202.Set       := (xGR_MAX_F_GenBearDE1_HiHi.Q AND IN_GC.tF_GenBear_DE1.GoodQual)
					   OR (xGR_MAX_F_GenBearDE2_HiHi.Q AND IN_GC.tF_GenBear_DE2.GoodQual);
	xMsg2202.PT        := Para.tiF_GenBear_HiHi;
	xMsg2202.RiskClass := 4;
	xMsg2202.Prio      := 3;
	xMsg2202.Reset     := FALSE;
	xMsg2202();
	MM2VIS.bMsg2202    := xMsg2202.Q;
	
	(*  2203 generator NDE bearing displacement trip *)
	xGR_MAX_F_GenBearNDE1_HiHi(In:= IN_GC.tF_GenBear_NDE1.Ai, Gw:= Para.rF_GenBear_HiHi, Hy:= 0.0);
	xGR_MAX_F_GenBearNDE2_HiHi(In:= IN_GC.tF_GenBear_NDE2.Ai, Gw:= Para.rF_GenBear_HiHi, Hy:= 0.0);

	xMsg2203.Enable    := FALSE; //SWAT920#3;
	xMsg2203.Set       := (xGR_MAX_F_GenBearNDE1_HiHi.Q AND IN_GC.tF_GenBear_NDE1.GoodQual)
					   OR (xGR_MAX_F_GenBearNDE2_HiHi.Q AND IN_GC.tF_GenBear_NDE2.GoodQual);
	xMsg2203.PT        := Para.tiF_GenBear_HiHi;
	xMsg2203.RiskClass := 4;
	xMsg2203.Prio      := 3;
	xMsg2203.Reset     := FALSE;
	xMsg2203();
	MM2VIS.bMsg2203    := xMsg2203.Q;

	(*  2204 measuring signal failure displacement sensor 1 generator DE bearing (W2631) *)
	xMsg2204.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND Para.bF_GenBear_DE1_Active AND FALSE;
	xMsg2204.Set       := NOT IN_GC.tF_GenBear_DE1.GoodQual;
	xMsg2204.PT        := T#0s;
	xMsg2204.RiskClass := 4;
	xMsg2204.Prio      := 3;
	xMsg2204.Reset     := FALSE; 
	xMsg2204(); 
	MM2VIS.bMsg2204    :=  xMsg2204.Q;

	(*  2205 measuring signal failure displacement sensor 2 generator DE bearing (W2632) *)
	xMsg2205.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND Para.bF_GenBear_DE2_Active AND FALSE;
	xMsg2205.Set       := NOT IN_GC.tF_GenBear_DE2.GoodQual;
	xMsg2205.PT        := T#0s;
	xMsg2205.RiskClass := 4;
	xMsg2205.Prio      := 3;
	xMsg2205.Reset     := FALSE; 
	xMsg2205(); 
	MM2VIS.bMsg2205    :=  xMsg2205.Q;

	(*  2206 measuring signal failure displacement sensor 1 generator NDE bearing (W2633) *)
	xMsg2206.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND Para.bF_GenBear_NDE1_Active AND FALSE;
	xMsg2206.Set       := NOT IN_GC.tF_GenBear_NDE1.GoodQual;
	xMsg2206.PT        := T#0s;
	xMsg2206.RiskClass := 4;
	xMsg2206.Prio      := 3;
	xMsg2206.Reset     := FALSE; 
	xMsg2206(); 
	MM2VIS.bMsg2206    :=  xMsg2206.Q;

	(*  2207 measuring signal failure displacement sensor 2 generator NDE bearing (W2634) *)
	xMsg2207.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND Para.bF_GenBear_NDE2_Active AND FALSE;
	xMsg2207.Set       := NOT IN_GC.tF_GenBear_NDE2.GoodQual;
	xMsg2207.PT        := T#0s;
	xMsg2207.RiskClass := 4;
	xMsg2207.Prio      := 3;
	xMsg2207.Reset     := FALSE; 
	xMsg2207(); 
	MM2VIS.bMsg2207    :=  xMsg2207.Q;



	(* A2208 Oilskid tank oil level low *)		
	xMsg2208.Enable		:= TRUE;	
	xMsg2208.Set		:= bAMM_Lev_OilSkid_Tank_LoLo;	
	xMsg2208.PT			:= T#0s; 		
	xMsg2208.Prio		:= 3; 	
	xMsg2208.Reset		:= FALSE; 	
	xMsg2208();	
	MM2VIS.bMsg2208 	:= xMsg2208.Q;
	bMsg2208_Test		:= xMsg2208.Test;


	MM2VIS.bMsg2209; (*  2209 generator LOS oil outlet pressure low *)	(* --> NOT USED *)
	MM2VIS.bMsg2210; (*  2210 generator both LOS AC oil pumps failed *)	(* --> NOT USED *)
	MM2VIS.bMsg2211; (*  2211 generator LOS oil temperature high *)		(* --> NOT USED *)
	MM2VIS.bMsg2212; (*  2212 generator both JOS AC oil pumps failed *)	(* --> NOT USED *)
	MM2VIS.bMsg2213; (*  2213 ? *)	(* --> NOT USED *)
	MM2VIS.bMsg2235; (*  2235 ? *)	(* --> NOT USED *)


	(* A2277 Generator voltage too low 2*)
	xMsg2277.Enable    := TRUE;
	IF IN_GC.bMMD_GenAlarmTestOn THEN xMsg2277.Set := NOT IN_GC.tU_Gen_LimLo2[1].Di;
	ELSIF xEngType.Type9         THEN xMsg2277.Set := NOT IN_GC.tU_Gen_LimLo2[1].Di AND bU_Gen_Mon_Ena AND(Para.rN_EngNom > 750);// Deaktivierung für Einfahrprogramm BR9 500rpm
	ELSE		                      xMsg2277.Set := NOT IN_GC.tU_Gen_LimLo2[1].Di AND bU_Gen_Mon_Ena;
	END_IF;
	xMsg2277.PT        := T#0s;
	xMsg2277.RiskClass := 4;
	xMsg2277.Prio      := 2;
	xMsg2277.Reset     := FALSE;
	xMsg2277();
	MM2VIS.bMsg2277    := xMsg2277.Q;
	MM2VIS.bMsg2277Set := xMsg2277.Set;
	OUT_GC.bMsg2277Set := xMsg2277.Set;
	
	(* A2316 Generator voltage high 2 *)
	xMsg2316.Enable    := TRUE;
	xTON2316Set(IN:=   (IN_GC.tU_L1L2[1].Ai >= Para.rU_Gen_Nom[1] * Para.rV_Over2[1]) 
					OR (IN_GC.tU_L2L3[1].Ai >= Para.rU_Gen_Nom[1] * Para.rV_Over2[1])
					OR (IN_GC.tU_L3L1[1].Ai >= Para.rU_Gen_Nom[1] * Para.rV_Over2[1]),
				PT:= REAL_TO_TIME(Para.rTi_V_Over2[1] * 1000));
	xMsg2316.Set       := xTON2316Set.Q;
	xMsg2316.PT        := T#0s;
	xMsg2316.RiskClass := 4;
	xMsg2316.Prio      := 2;
	xMsg2316.Reset     := FALSE;
	xMsg2316(); 
	MM2VIS.bMsg2316    := xMsg2316.Q;
	MM2VIS.bMsg2316Set := xMsg2316.Set;
	OUT_GC.bMsg2316Set := xMsg2316.Set;

	(* A2336 Failure Generator lubricating oil - Cooling *)
	xMsg2336.Enable    := TRUE;
	xMsg2336.Set       := NOT IN_GC.tGen_LO_CoolingSys_Fail.Di;
	xMsg2336.PT        := T#0s;
	xMsg2336.RiskClass := 4;
	xMsg2336.Prio      := 3;
	xMsg2336.Reset     := FALSE;
	xMsg2336();
	MM2VIS.bMsg2336    := xMsg2336.Q;
	
	(* A2371 Oil skid Oil flow to DE bearing Low *)
	xMsg2371.Enable    := TRUE;
	xMsg2371.Set       := (IN_GC.tFlow_OilSkid_DE.Ai < 2.0) AND (IN_GC.rN_EngAct > 500) AND bRelMon_Flow_DE;
	xMsg2371.PT        := T#60s;
	xMsg2371.RiskClass := 4;
	xMsg2371.Prio      := 3;
	xMsg2371.Reset     := FALSE;
	xMsg2371();
	MM2VIS.bMsg2371    := xMsg2371.Q;
	
	(* A2372 Oil skid Oil flow to NDE bearing Low *)
	xMsg2372.Enable    := TRUE;
	xMsg2372.Set       := (IN_GC.tFlow_OilSkid_NDE.Ai < 2.0) AND (IN_GC.rN_EngAct > 500) AND bRelMon_Flow_NDE;
	xMsg2372.PT        := T#60s;
	xMsg2372.RiskClass := 4;
	xMsg2372.Prio      := 3;
	xMsg2372.Reset     := FALSE;
	xMsg2372();
	MM2VIS.bMsg2372    := xMsg2372.Q;

	(* A2373 Earth failure generator (MMD) *)
	xMsg2373.Enable	:= 	NOT IN_GC.bSimWinMOD_Active;
	xMsg2373.Set 	:=	bMsg2373_set;
	xMsg2373.PT 	:=	T#0s;
	xMsg2373.Prio	:= 	2;
	xMsg2373.Reset	:= 	FALSE;
	xMsg2373();
	MM2VIS.bMsg2373	:= xMsg2373.Q;

	(* W2501 Generator rotating diode failure *)
	xMsg2501.Enable    := TRUE;
	xMsg2501.Set       :=(IN_GC.tU_GenDiode_Fail.Di OR IN_GC.tU_GenDiode_Trip.Di) AND bEng_Run_10s;
	xMsg2501.PT        := T#5s;
	xMsg2501.RiskClass := 4;
	xMsg2501.Prio      := 4;
	xMsg2501.Reset     := FALSE; 
	xMsg2501(); 
	MM2VIS.bMsg2501    := xMsg2501.Q;

	(*  2502 generator DE bearing displacement *)
	xGR_MAX_F_GenBearDE1_Hi(In:= IN_GC.tF_GenBear_DE1.Ai, Gw:= Para.rF_GenBear_Hi, Hy:= 0.0);
	xGR_MAX_F_GenBearDE2_Hi(In:= IN_GC.tF_GenBear_DE2.Ai, Gw:= Para.rF_GenBear_Hi, Hy:= 0.0);

	xMsg2502.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND(Para.bF_GenBear_DE1_Active OR Para.bF_GenBear_DE2_Active);
	xMsg2502.Set       := (xGR_MAX_F_GenBearDE1_Hi.Q AND IN_GC.tF_GenBear_DE1.GoodQual)
					   OR (xGR_MAX_F_GenBearDE2_Hi.Q AND IN_GC.tF_GenBear_DE2.GoodQual);
	xMsg2502.PT        := Para.tiF_GenBear_Hi;
	xMsg2502.RiskClass := 4;
	xMsg2502.Prio      := 4;
	xMsg2502.Reset     := FALSE;
	xMsg2502();
	MM2VIS.bMsg2502    := xMsg2502.Q;
	
	(*  2503 generator NDE bearing displacement *)
	xGR_MAX_F_GenBearNDE1_Hi(In:= IN_GC.tF_GenBear_NDE1.Ai, Gw:= Para.rF_GenBear_Hi, Hy:= 0.0);
	xGR_MAX_F_GenBearNDE2_Hi(In:= IN_GC.tF_GenBear_NDE2.Ai, Gw:= Para.rF_GenBear_Hi, Hy:= 0.0);

	xMsg2503.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND(Para.bF_GenBear_NDE1_Active OR Para.bF_GenBear_NDE2_Active);
	xMsg2503.Set       := (xGR_MAX_F_GenBearNDE1_Hi.Q AND IN_GC.tF_GenBear_NDE1.GoodQual)
					   OR (xGR_MAX_F_GenBearNDE2_Hi.Q AND IN_GC.tF_GenBear_NDE2.GoodQual);
	xMsg2503.PT        := Para.tiF_GenBear_Hi;
	xMsg2503.RiskClass := 4;
	xMsg2503.Prio      := 4;
	xMsg2503.Reset     := FALSE;
	xMsg2503();
	MM2VIS.bMsg2503    := xMsg2503.Q;
	
	(* W2504 Generator AVR panel MCB trip *)
	xMsg2504.Enable    := TRUE;
	xMsg2504.Set       := NOT IN_GC.tGenCtr_CktBkr_Trip.Di;
	xMsg2504.PT        := T#0s;
	xMsg2504.RiskClass := 4;
	xMsg2504.Prio      := 4;
	xMsg2504.Reset     := FALSE;
	xMsg2504();
	MM2VIS.bMsg2504    := xMsg2504.Q;
	
	(* W2505 Oilskid low pressure oil filter clogged *)
	xMsg2505.Enable		:= TRUE;	
	xMsg2505.Set		:= bAMM_DPr_OilSkid_FiltLP_Hi;	
	xMsg2505.PT			:= T#120s;
	xMsg2505.Prio		:= 4; 	
	xMsg2505.Reset		:= FALSE; 	
	xMsg2505();	
	MM2VIS.bMsg2505		:= xMsg2505.Q;

	MM2VIS.bMsg2506 ; (*W2506 Oilskid  --> NOT USED *)
	MM2VIS.bMsg2507 ; (*W2507 Oilskid  --> NOT USED *)

	(* W2508 Oilskid high pressure oil filter DE clogged *)		
	xMsg2508.Enable		:= TRUE;	
	xMsg2508.Set		:= bAMM_DPr_OilSkid_FiltHP_DE_Hi;	
	xMsg2508.PT			:= T#10s; 		
	xMsg2508.Prio		:= 4; 	
	xMsg2508.Reset		:= FALSE; 	
	xMsg2508();	
	MM2VIS.bMsg2508		:= xMsg2508.Q;

	(* W2555 measuring signal failure generator air inlet temperature *)
	xMsg2555.Enable    := Para.bT_GenAirIn_Active;
	xMsg2555.Set       := IN_GC.tPB2MM.bParaSetupOk AND NOT IN_GC.tGen_T_In.GoodQual;
	xMsg2555.PT        := T#0s;
	xMsg2555.RiskClass := 4;
	xMsg2555.Prio      := 4;
	xMsg2555.Reset     := FALSE; 
	xMsg2555(); 
	MM2VIS.bMsg2555    :=  xMsg2555.Q;

	(* W2556 measuring signal failure generator air outlet temperature *)
	xMsg2556.Enable    := Para.bT_GenAirOut_Active;
	xMsg2556.Set       := IN_GC.tPB2MM.bParaSetupOk AND NOT IN_GC.tT_GenAirOut.GoodQual;
	xMsg2556.PT        := T#0s;
	xMsg2556.RiskClass := 4;
	xMsg2556.Prio      := 4;
	xMsg2556.Reset     := FALSE; 
	xMsg2556(); 
	MM2VIS.bMsg2556    :=  xMsg2556.Q;

	(* W2573 Overvoltage protection generator failure *)
	xMsg2573.Enable    := TRUE;
	xMsg2573.Set       := NOT IN_GC.tU_GenOverVolt.Di;
	xMsg2573.PT        := T#0s;
	xMsg2573.RiskClass := 4;
	xMsg2573.Prio      := 4;
	xMsg2573.Reset     := FALSE; 
	xMsg2573(); 
	MM2VIS.bMsg2573    :=  xMsg2573.Q;

	(*  2631 measuring signal vibration sensor 1 gen.drive end DE bearing *)
	xMsg2631.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND Para.bF_GenBear_DE1_Active;
	xMsg2631.Set       := NOT IN_GC.tF_GenBear_DE1.GoodQual;
	xMsg2631.PT        := T#0s;
	xMsg2631.RiskClass := 4;
	xMsg2631.Prio      := 4;
	xMsg2631.Reset     := FALSE; 
	xMsg2631(); 
	MM2VIS.bMsg2631    :=  xMsg2631.Q;

	(*  2632 measuring signal vibration sensor 2 gen.drive end DE bearing *)
	xMsg2632.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND Para.bF_GenBear_DE2_Active;
	xMsg2632.Set       := NOT IN_GC.tF_GenBear_DE2.GoodQual;
	xMsg2632.PT        := T#0s;
	xMsg2632.RiskClass := 4;
	xMsg2632.Prio      := 4;
	xMsg2632.Reset     := FALSE; 
	xMsg2632(); 
	MM2VIS.bMsg2632    :=  xMsg2632.Q;

	(*  2633 measuring signal vibration sensor 1 gen.non-drive end NDE bearing *)
	xMsg2633.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND Para.bF_GenBear_NDE1_Active;
	xMsg2633.Set       := NOT IN_GC.tF_GenBear_NDE1.GoodQual;
	xMsg2633.PT        := T#0s;
	xMsg2633.RiskClass := 4;
	xMsg2633.Prio      := 4;
	xMsg2633.Reset     := FALSE; 
	xMsg2633(); 
	MM2VIS.bMsg2633    :=  xMsg2633.Q;

	(*  2634 measuring signal vibration sensor 2 gen.non-drive end NDE bearing *)
	xMsg2634.Enable    := IN_GC.tPB2MM.bParaSetupOk	AND Para.bF_GenBear_NDE2_Active;
	xMsg2634.Set       := NOT IN_GC.tF_GenBear_NDE2.GoodQual;
	xMsg2634.PT        := T#0s;
	xMsg2634.RiskClass := 4;
	xMsg2634.Prio      := 4;
	xMsg2634.Reset     := FALSE; 
	xMsg2634(); 
	MM2VIS.bMsg2634    :=  xMsg2634.Q;

	(*  2637 Generator interface panel circuit breaker tripped *)
	xMsg2637.Enable    := TRUE;
	xMsg2637.Set       := NOT IN_GC.tGenIF_CB_On.Di;
	xMsg2637.PT        := T#0s;
	xMsg2637.RiskClass := 4;
	xMsg2637.Prio      := 4;
	xMsg2637.Reset     := FALSE; 
	xMsg2637(); 
	MM2VIS.bMsg2637    :=  xMsg2637.Q;

	(*  2665 Generator heater circuit breaker tripped *)
	xMsg2665.Enable    := TRUE;
	xMsg2665.Set       := NOT IN_GC.tGenHeat_CB_On.Di;
	xMsg2665.PT        := T#0s;
	xMsg2665.RiskClass := 4;
	xMsg2665.Prio      := 4;
	xMsg2665.Reset     := FALSE; 
	xMsg2665(); 
	MM2VIS.bMsg2665    :=  xMsg2665.Q;
	
	(* W2690 rotor earth fault *)
	xMsg2690.Enable		:= TRUE;
	xMsg2690.Set		:= NOT IN_GC.tGenRotorEarthFault.Di;
	xMsg2690.PT			:= T#0s;
	xMsg2690.Prio		:= 4;
	xMsg2690.RiskClass	:= 4;
	xMsg2690.Reset		:= FALSE;	
	xMsg2690();
	MM2VIS.bMsg2690		:= xMsg2690.Q;
	
	(* W2691 reactive power/undervoltage protection (Q-U-protection) *)
	xMsg2691.Enable		:= TRUE;
	xMsg2691.Set		:= NOT IN_GC.tQ_GenUnderVoltProt.Di;
	xMsg2691.PT			:= T#0s;
	xMsg2691.Prio		:= 4;
	xMsg2691.RiskClass	:= 4;
	xMsg2691.Reset		:= FALSE;	
	xMsg2691();
	MM2VIS.bMsg2691		:= xMsg2691.Q;
	
	(* W3219 excitation voltage low *)	
	xMsg3219.Enable    := TRUE;
	xMsg3219.Set       := bU_Gen_Exc_Min AND bU_Gen_Mon_Ena;
	xMsg3219.PT        := T#0s;
	xMsg3219.RiskClass := 4;
	xMsg3219.Prio      := 4;
	xMsg3219.Reset     := FALSE;
	xMsg3219();
	MM2VIS.bMsg3219    := xMsg3219.Q;	
	
	(* A3319 Generator protection trip *)
	xMsg3319.Enable    := TRUE;
	xMsg3319.Set       := NOT IN_GC.tGenPrctTrip.Di AND IN_GC.tGenPrctTrip.GoodQual;
	xMsg3319.PT        := T#0s;
	xMsg3319.RiskClass := 4;
	xMsg3319.Prio      := 2;
	xMsg3319.Reset     := FALSE;
	xMsg3319();
	OUT_GC.bMsg3319    := xMsg3319.Q;
	MM2VIS.bMsg3319    := xMsg3319.Q;
	
	(* A3393 generator overexcitation *)
	xMsg3393.Enable		:= TRUE;
	xMsg3393.Set		:= NOT IN_GC.tGenOverExc.Di;
	xMsg3393.PT			:= T#0s;
	xMsg3393.Prio		:= 2;
	xMsg3393.RiskClass	:= 4;
	xMsg3393.Reset		:= FALSE;	
	xMsg3393();
	MM2VIS.bMsg3393		:= xMsg3393.Q;
   
	(* W3418 Oilskid oil in oil sump *)		
	xMsg3418.Enable		:= TRUE;	
	xMsg3418.Set		:= bAMM_Lev_OilSkid_Sump_Hi;	
	xMsg3418.PT			:= T#0s; 		
	xMsg3418.Prio		:= 4; 	
	xMsg3418.Reset		:= FALSE; 	
	xMsg3418();	
	MM2VIS.bMsg3418		:= xMsg3418.Q;

	(* W3419 Oilskid tank oil level measuring signal failure *)		
	xMsg3419.Enable		:= TRUE;	
	xMsg3419.Set		:= bAMM_Lev_OilSkid_Tank_Ms;	
	xMsg3419.PT			:= T#10s; 		
	xMsg3419.Prio		:= 4; 	
	xMsg3419.Reset		:= FALSE; 	
	xMsg3419();	
	MM2VIS.bMsg3419 	:= xMsg3419.Q;

	(* W3420 Oilskid tank oil level low *)
	xMsg3420.Enable		:= TRUE;
	xMsg3420.Set		:= bAMM_Lev_OilSkid_Tank_Lo;
	xMsg3420.PT			:= T#120s; 
	xMsg3420.Prio		:= 4; 	
	xMsg3420.Reset		:= FALSE; 	
	xMsg3420();	
	MM2VIS.bMsg3420		:= xMsg3420.Q;

	(* W3421 Oilskid tank oil temperature measuring signal failure *)		
	xMsg3421.Enable		:= TRUE;	
	xMsg3421.Set		:= bAMM_T_OilSkid_Tank_Ms;	
	xMsg3421.PT			:= T#10s; 		
	xMsg3421.Prio		:= 4; 	
	xMsg3421.Reset		:= FALSE; 	
	xMsg3421();	
	MM2VIS.bMsg3421		:= xMsg3421.Q;

	(* W3422 Oilskid tank oil temperature low *)
	xMsg3422.Enable		:= TRUE;
	xMsg3422.Set		:= bAMM_T_OilSkid_Tank_Lo;
	xMsg3422.PT			:= T#0s; 	
	xMsg3422.Prio		:= 4; 	
	xMsg3422.Reset		:= FALSE; 	
	xMsg3422();	
	MM2VIS.bMsg3422		:= xMsg3422.Q;

	(* W3423 Oilskid oil supply temperature measuring signal failure *)		
	xMsg3423.Enable		:= TRUE;	
	xMsg3423.Set		:= bAMM_T_OilSkid_Supply_Ms;	
	xMsg3423.PT			:= T#10s; 	
	xMsg3423.Prio		:= 4; 	
	xMsg3423.Reset		:= FALSE; 	
	xMsg3423();	
	MM2VIS.bMsg3423		:= xMsg3423.Q;

	(* W3424 Oilskid oil supply temperature low *)		
	xMsg3424.Enable		:= TRUE;	
	xMsg3424.Set		:= bAMM_T_OilSkid_Supply_Lo;	
	xMsg3424.PT			:= T#0s; 	
	xMsg3424.Prio		:= 4; 	
	xMsg3424.Reset		:= FALSE; 	
	xMsg3424();	
	MM2VIS.bMsg3424		:= xMsg3424.Q;

	(* W3425 Oilskid oil supply temperature high *)		
	xMsg3425.Enable		:= TRUE;	
	xMsg3425.Set		:= bAMM_T_OilSkid_Supply_Hi;	
	xMsg3425.PT			:= T#0s; 
	xMsg3425.Prio		:= 4; 	
	xMsg3425.Reset		:= FALSE; 	
	xMsg3425();	
	MM2VIS.bMsg3425		:= xMsg3425.Q;

	(* W3426 Oilskid low pressure oil pump circuit breaker tripped *)		
	xMsg3426.Enable		:= TRUE;	
	xMsg3426.Set		:= bAMM_OilSkid_PumpLP_CB;	
	xMsg3426.PT			:= T#0s; 		
	xMsg3426.Prio		:= 4; 	
	xMsg3426.Reset		:= FALSE; 	
	xMsg3426();	
	MM2VIS.bMsg3426		:= xMsg3426.Q;

	(* W3427 Oilskid oil flow TO DE bearing measuring signal failure *)		
	xMsg3427.Enable		:= TRUE;	
	xMsg3427.Set		:= bAMM_Flow_OilSkid_DE_Ms;	
	xMsg3427.PT			:= T#10s; 	
	xMsg3427.Prio		:= 4; 	
	xMsg3427.Reset		:= FALSE; 	
	xMsg3427();	
	MM2VIS.bMsg3427		:= xMsg3427.Q;

	(* W3428 Oilskid oil flow TO DE bearing low *)		
	xMsg3428.Enable		:= TRUE;	
	xMsg3428.Set		:= bAMM_Flow_OilSkid_DE_Lo;	
	xMsg3428.PT			:= T#120s; 	
	xMsg3428.Prio		:= 4; 	
	xMsg3428.Reset		:= FALSE; 	
	xMsg3428();	
	MM2VIS.bMsg3428		:= xMsg3428.Q;

	(* W3429 Oilskid oil flow TO DE bearing high *)		
	xMsg3429.Enable		:= TRUE;	
	xMsg3429.Set		:= bAMM_Flow_OilSkid_DE_Hi;	
	xMsg3429.PT			:= T#120s; 		
	xMsg3429.Prio		:= 4; 	
	xMsg3429.Reset		:= FALSE; 	
	xMsg3429();	
	MM2VIS.bMsg3429		:= xMsg3429.Q;

	(* W3430 Oilskid oil flow TO NDE bearing measuring signal failure *)		
	xMsg3430.Enable		:= TRUE;	
	xMsg3430.Set		:= bAMM_Flow_OilSkid_NDE_Ms;	
	xMsg3430.PT			:= T#10s;		
	xMsg3430.Prio		:= 4; 	
	xMsg3430.Reset		:= FALSE; 	
	xMsg3430();	
	MM2VIS.bMsg3430		:= xMsg3430.Q;

	(* W3431 Oilskid oil flow TO NDE bearing low *)		
	xMsg3431.Enable		:= TRUE;	
	xMsg3431.Set		:= bAMM_Flow_OilSkid_NDE_Lo;	
	xMsg3431.PT			:= T#120s; 	
	xMsg3431.Prio		:= 4; 	
	xMsg3431.Reset		:= FALSE; 	
	xMsg3431();	
	MM2VIS.bMsg3431		:= xMsg3431.Q;

	(* W3432 Oilskid oil flow TO NDE bearing high *)		
	xMsg3432.Enable		:= TRUE;	
	xMsg3432.Set		:= bAMM_Flow_OilSkid_NDE_Hi;	
	xMsg3432.PT			:= T#120s; 		
	xMsg3432.Prio		:= 4; 	
	xMsg3432.Reset		:= FALSE; 	
	xMsg3432();	
	MM2VIS.bMsg3432		:= xMsg3432.Q;

	(* W3433 Oilskid high pressure oil pump circuit breaker tripped *)		
	xMsg3433.Enable		:= TRUE;	
	xMsg3433.Set		:= bAMM_OilSkid_PumpHP_CB;	
	xMsg3433.PT			:= T#0s; 
	xMsg3433.Prio		:= 4; 	
	xMsg3433.Reset		:= FALSE; 	
	xMsg3433();	
	MM2VIS.bMsg3433		:= xMsg3433.Q;

	(* W3434 Oilskid high pressure oil pump circuit breaker tripped - UPS *)		
	xMsg3434.Enable		:= TRUE;	
	xMsg3434.Set		:= bAMM_OilSkid_PumpHP_CB_UPS;
	xMsg3434.PT			:= T#0s; 	
	xMsg3434.Prio		:= 4; 	
	xMsg3434.Reset		:= FALSE; 	
	xMsg3434();	
	MM2VIS.bMsg3434		:= xMsg3434.Q;

	(* W3435 Oilskid oil pressure TO DE bearing measuring signal failure *)		
	xMsg3435.Enable		:= TRUE;
	xMsg3435.Set		:= bAMM_Pr_OilSkid_HP_DE_Ms;
	xMsg3435.PT			:= T#10s; 
	xMsg3435.Prio		:= 4; 	
	xMsg3435.Reset		:= FALSE; 
	xMsg3435();	
	MM2VIS.bMsg3435		:= xMsg3435.Q;

	(* W3436 Oilskid oil pressure TO DE bearing low *)	
	xMsg3436.Enable		:= TRUE;	
	xMsg3436.Set		:= bAMM_Pr_OilSkid_HP_DE_Lo;	
	xMsg3436.PT			:= T#0s;	
	xMsg3436.Prio		:= 4; 	
	xMsg3436.Reset		:= FALSE; 
	xMsg3436();	
	MM2VIS.bMsg3436		:= xMsg3436.Q;

	(* W3437 Oilskid fan circuit breaker tripped*)		
	xMsg3437.Enable		:= TRUE;	
	xMsg3437.Set		:= bAMM_OilSkid_Fan_CB;	
	xMsg3437.PT			:= T#0s; 	
	xMsg3437.Prio		:= 4; 	
	xMsg3437.Reset		:= FALSE; 	
	xMsg3437();	
	MM2VIS.bMsg3437		:= xMsg3437.Q;

	(* W3438 Oilskid heater circuit breaker tripped *)	
	xMsg3438.Enable		:= TRUE;	
	xMsg3438.Set		:= bAMM_OilSkid_Heater_CB;	
	xMsg3438.PT			:= T#0s; 		
	xMsg3438.Prio		:= 4; 	
	xMsg3438.Reset		:= FALSE; 	
	xMsg3438();	
	MM2VIS.bMsg3438		:= xMsg3438.Q;

	(* W3439 Oilskid main switch auxiliaries opened *)	
	xMsg3439.Enable		:= TRUE;
	xMsg3439.Set		:= bAMM_OilSkid_MCB;
	xMsg3439.PT			:= T#0s; 		
	xMsg3439.Prio		:= 4; 	
	xMsg3439.Reset		:= FALSE; 	
	xMsg3439();	
	MM2VIS.bMsg3439		:= xMsg3439.Q;

	(* W3440 Oilskid auxiliaries voltage NOT available *) 		
	xMsg3440.Enable		:= TRUE;	
	xMsg3440.Set		:= bAMM_OilSkid_AuxV;	
	xMsg3440.PT			:= T#2s; 	
	xMsg3440.Prio		:= 4; 	
	xMsg3440.Reset		:= FALSE; 	
	xMsg3440();	
	MM2VIS.bMsg3440		:= xMsg3440.Q;

	(* W3441 Oilskid auxiliaries voltage NOT available - UPS *)		
	xMsg3441.Enable		:= TRUE;	
	xMsg3441.Set		:= bAMM_OilSkid_AuxV_UPS;	
	xMsg3441.PT			:= T#0s; 	
	xMsg3441.Prio		:= 4; 	
	xMsg3441.Reset		:= FALSE; 	
	xMsg3441();	
	MM2VIS.bMsg3441		:= xMsg3441.Q;

	(* W3442 Oilskid oil pressure TO NDE bearing measuring signal failure *)		
	xMsg3442.Enable		:= TRUE;	
	xMsg3442.Set		:= bAMM_Pr_OilSkid_HP_NDE_Ms;	
	xMsg3442.PT			:= T#10s;
	xMsg3442.Prio		:= 4; 	
	xMsg3442.Reset		:= FALSE; 
	xMsg3442();	
	MM2VIS.bMsg3442		:= xMsg3442.Q;

	(* W3443 Oilskid oil pressure TO NDE bearing low *)		
	xMsg3443.Enable		:= TRUE;	
	xMsg3443.Set		:= bAMM_Pr_OilSkid_HP_NDE_Lo;	
	xMsg3443.PT			:= T#0s; 		
	xMsg3443.Prio		:= 4; 	
	xMsg3443.Reset		:= FALSE; 	
	xMsg3443();	
	MM2VIS.bMsg3443		:= xMsg3443.Q;

	(* W3446 Oilskid high pressure oil filter NDE clogged *)		
	xMsg3446.Enable		:= TRUE;	
	xMsg3446.Set		:= bAMM_DPr_OilSkid_FiltHP_NDE_Hi;
	xMsg3446.PT			:= T#10s; 	
	xMsg3446.Prio		:= 4; 
	xMsg3446.Reset		:= FALSE; 	
	xMsg3446();	
	MM2VIS.bMsg3446		:= xMsg3446.Q;

	(* W3447 Oilskid circulation pump circuit breaker tripped *)		
	xMsg3447.Enable		:= TRUE;	
	xMsg3447.Set		:= bAMM_OilSkid_PumpC_CB;	
	xMsg3447.PT			:= T#0s; 		
	xMsg3447.Prio		:= 4; 	
	xMsg3447.Reset		:= FALSE; 	
	xMsg3447();	
	MM2VIS.bMsg3447		:= xMsg3447.Q;
	
	(* W3468 generator air inlet temperature 2 signal failure *)
	xMsg3468.Enable		:= Para.bT_GenAirIn2_Active;	
	xMsg3468.Set		:= IN_GC.tPB2MM.bParaSetupOk AND NOT IN_GC.tGen_T_In2.GoodQual;	
	xMsg3468.PT			:= T#0s; 		
	xMsg3468.Prio		:= 4; 	
	xMsg3468.Reset		:= FALSE; 	
	xMsg3468();	
	MM2VIS.bMsg3468		:= xMsg3468.Q;
	
	(* W3516 Excitation voltage high *)
	xMsg3516.Enable    := TRUE;
	xMsg3516.Set       := bU_Gen_Exc_Max AND IN_GC.tEng_Run.Do;
	xMsg3516.PT        := T#0s;
	xMsg3516.RiskClass := 4;
	xMsg3516.Prio      := 4;
	xMsg3516.Reset     := FALSE;
	xMsg3516();
	MM2VIS.bMsg3516    := xMsg3516.Q;

	(* W3563 Generator lubrication failure *) 
	xMsg3563.Enable    := TRUE;
	xMsg3563.Set       := IN_GC.bIgn_Dem AND NOT IN_GC.tFlow_Gen_Lube.Di;
	xMsg3563.PT        := T#5s;
	xMsg3563.RiskClass := 4;
	xMsg3563.Prio      := 4;
	xMsg3563.Reset     := FALSE; 
	xMsg3563(); 
	MM2VIS.bMsg3563    :=  xMsg3563.Q;	
	
	(* W3566 Messignalstörung Generator Leistungsfaktorsollwert *)
	xMsg3566.Enable    := FALSE;(*->3593*)
	xMsg3566.Set       := FALSE;
	xMsg3566.PT        := T#0s;
	xMsg3566.Prio      := 4;
	xMsg3566.Reset     := FALSE;
	xMsg3566();
	MM2VIS.bMsg3566    := xMsg3566.Q;	
			
	(* W3573 Failure Generator lubricating oil - Cooling *)(* A2336 *)
	xMsg3573.Enable    := FALSE;
	xMsg3573.Set       := NOT IN_GC.tGen_LO_CoolingSys_Fail.Di;
	xMsg3573.PT        := T#0s;
	xMsg3573.RiskClass := 4;
	xMsg3573.Prio      := 4;
	xMsg3573.Reset     := FALSE;
	xMsg3573();
	MM2VIS.bMsg3573    := xMsg3573.Q;

	(* W9311 Earth failure generator *)(* A1134 *)
	xMsg9311.Enable    := TRUE;
	xMsg9311.Set       := NOT IN_GC.tGndFaultW.Di;
	xMsg9311.PT        := T#0s;
	xMsg9311.RiskClass := 4;
	xMsg9311.Prio      := 4;
	xMsg9311.Reset     := FALSE; 
	xMsg9311(); 
	MM2VIS.bMsg9311    := xMsg9311.Q;

	(* counter Earth fault with running engine *)
	xTON_SecTick(IN:= NOT xTON_SecTick.Q, PT:= T#800ms);(*800ms! = 1s tick*)

	IF ((NOT IN_GC.tGndFaultW.Di) OR bMsg9372_set) AND IN_GC.tEng_Run.Do AND xTON_SecTick.Q AND IN_GC.tPB2MM.bParaSetupOk THEN
		iOpS_GndFailure	:= iOpS_GndFailure + 1;
	END_IF;
	
	IF iOpS_GndFailure >= 60 THEN
		iOpS_GndFailure	:= 0;
		iOpM_GndFailure	:= iOpM_GndFailure + 1;
	END_IF;
	
	IF iOpM_GndFailure >= 60 THEN
		iOpM_GndFailure	:= 0;
		VIS2MM.iOpH_GndFailure := VIS2MM.iOpH_GndFailure + 1;
	END_IF;

	(* check limits *)
	IF VIS2MM.iOpH_GndFailure >= 1000000000 THEN
		VIS2MM.iOpH_GndFailure := VIS2MM.iOpH_GndFailure - 1000000000;		(* check upper limit *)
	ELSIF VIS2MM.iOpH_GndFailure <= -1000000000 THEN
		VIS2MM.iOpH_GndFailure := VIS2MM.iOpH_GndFailure + 1000000000;		(* check lower limit *)
	END_IF;

	(* W9285 Measuring signal failure external voltage setpoint *)
	xMsg9285.Enable := 	IN_GC.tU_SetExtAI_Norm.Exist AND IN_GC.tPB2MM.bParaSetupOk;
	xMsg9285.Set := 	bMsg9285;
	xMsg9285.PT := 		T#1s;
	xMsg9285.Prio := 	4;
	xMsg9285.Reset := 	FALSE;
	xMsg9285();
	OUT_GC.bMsg9285 :=	xMsg9285.Q;

	(* W9351 Measuring signal failure external reactive power set point for voltage droop mode *)
	xMsg9351.Enable := 	IN_GC.tQ_Droop_Set.Exist AND IN_GC.tPB2MM.bParaSetupOk;
	xMsg9351.Set := 	bMsg9351;  
	xMsg9351.PT := 		T#1s;
	xMsg9351.Prio := 	4;
	xMsg9351.Reset := 	FALSE;
	xMsg9351();
	MM2VIS.bMsg9351    := xMsg9351.Q;

	(* W9365 Automatic generator greasing system error (drive end DE bearing) *)
	xMsg9365.Enable	:= 	TRUE;
	xMsg9365.Set 	:=	IN_GC.bEng_Dem AND IN_GC.tEng_Run.Do AND NOT IN_GC.tGenBearGreasSys2DE.Di;
	xMsg9365.PT 	:=	T#5s;
	xMsg9365.Prio	:= 	4;
	xMsg9365.Reset	:= 	FALSE;
	xMsg9365();
	MM2VIS.bMsg9365	:= xMsg9365.Q;

	(* W9366 Automatic generator greasing system error (non-drive end NDE bearing) *)
	xMsg9366.Enable	:= 	TRUE;
	xMsg9366.Set 	:=	IN_GC.bEng_Dem AND IN_GC.tEng_Run.Do AND NOT IN_GC.tGenBearGreasSys2NDE.Di;  
	xMsg9366.PT 	:=	T#5s;
	xMsg9366.Prio	:= 	4;
	xMsg9366.Reset	:= 	FALSE;
	xMsg9366();
	MM2VIS.bMsg9366	:= xMsg9366.Q;

	(* W9367 Automatic generator greasing system - lubrication cartridge empty (drive end DE bearing) *)
	xMsg9367.Enable	:= 	TRUE;
	xMsg9367.Set 	:=	IN_GC.tGenBearGreasSys2DE.Di AND IN_GC.tGenBearGreasSys4DE.Di;
	xMsg9367.PT 	:=	T#5s;
	xMsg9367.Prio	:= 	4;
	xMsg9367.Reset	:= 	FALSE;
	xMsg9367();
	MM2VIS.bMsg9367	:= xMsg9367.Q;

	(* W9368 Automatic generator greasing system - lubrication cartridge empty (non-drive end NDE bearing) *)
	xMsg9368.Enable	:= 	TRUE;
	xMsg9368.Set 	:=	IN_GC.tGenBearGreasSys2NDE.Di AND IN_GC.tGenBearGreasSys4NDE.Di;
	xMsg9368.PT 	:=	T#5s;
	xMsg9368.Prio	:= 	4;
	xMsg9368.Reset	:= 	FALSE;
	xMsg9368();
	MM2VIS.bMsg9368	:= xMsg9368.Q;

	(* W9372 Earth failure generator (MMD) *)
	xMsg9372.Enable	:= 	NOT IN_GC.bSimWinMOD_Active;
	xMsg9372.Set 	:=	bMsg9372_set;
	xMsg9372.PT 	:=	T#0s;
	xMsg9372.Prio	:= 	4;
	xMsg9372.Reset	:= 	FALSE;
	xMsg9372();
	MM2VIS.bMsg9372	:= xMsg9372.Q;

	(*---------------------------------------------------------------------------*)
	(* Operating messages *)

	(* B2156 Q reduction by gen.winding temp. (diagn.msg RPS) *)
	xTP_Msg2156(IN:= bMsg2156, PT := T#60s);		

 	xMsg2156.Enable    := TRUE;
	xMsg2156.Set       := xTP_Msg2156.Q;
	xMsg2156.Reset     := TRUE;
	xMsg2156();
	MM2VIS.bMsg2156    := xMsg2156.Q;

	(* B2157 Q reduction by polradwinkel (diagn.msg RPS) *)
	xTP_Msg2157(IN:= bMsg2157, PT := T#60s);		
	
	xMsg2157.Enable    := TRUE;
	xMsg2157.Set       := xTP_Msg2157.Q;
	xMsg2157.Reset     := TRUE;
	xMsg2157();
	MM2VIS.bMsg2157    := xMsg2157.Q;

	(* B2827 Generator Lube Oil System/ Jacket Oil system ready for start and operation *)	(* --> NOT USED *)
	xMsg2827.Enable		:=	FALSE;
	xMsg2827.Set		:=	FALSE;
	xMsg2827.Reset		:=	TRUE;
	xMsg2827();
	MM2VIS.bMsg2827		:=	xMsg2827.Q;
	
	(* B2828 Generator Lube Oil System - Oil outlet pressure ok *)							(* --> NOT USED *)
	xMsg2828.Enable		:=	FALSE;
	xMsg2828.Set		:=	FALSE;
	xMsg2828.Reset		:=	TRUE;
	xMsg2828();
	MM2VIS.bMsg2828		:=	xMsg2828.Q;
	
	(* B2829 Generator Lube Oil System - drive end bearing oil flow ok*)					(* --> NOT USED *)
	xMsg2829.Enable		:=	FALSE;
	xMsg2829.Set		:=	FALSE;
	xMsg2829.Reset		:=	TRUE;
	xMsg2829();
	MM2VIS.bMsg2829		:=	xMsg2829.Q;
	
	(* B2830 Generator Lube Oil System - non drive end bearing oil flow ok*)				(* --> NOT USED *)
	xMsg2830.Enable		:=	FALSE;
	xMsg2830.Set		:=	FALSE;
	xMsg2830.Reset		:=	TRUE;
	xMsg2830();
	MM2VIS.bMsg2830		:=	xMsg2830.Q;

	(* B2998 reactive power limitation by under voltage *) 
	xTP_Msg2998(IN:= bMsg2998, PT := T#60s);		

	xMsg2998.Enable		:=	TRUE;
	xMsg2998.Set		:=	xTP_Msg2998.Q;
	xMsg2998.Reset		:=	TRUE;
	xMsg2998();
	MM2VIS.bMsg2998		:=	xMsg2998.Q;

	(* B template 
	xMsg.Enable		:=	TRUE;
	xMsg.Set		:=	bBool;
	xMsg.Reset		:=	TRUE;
	xMsg();
	MM2VIS.bMsg		:=	xMsg.Q;	*)
	
	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1   := OUT_GC.tGC2AB.bGnlTrip1   OR IN_GC.tAB2GC.bGnlTrip1;
	bGnlTrip2   := OUT_GC.tGC2AB.bGnlTrip2   OR IN_GC.tAB2GC.bGnlTrip2;
	bGnlTrip3   := OUT_GC.tGC2AB.bGnlTrip3   OR IN_GC.tAB2GC.bGnlTrip3;
	bGnlWarning := OUT_GC.tGC2AB.bGnlWarning OR IN_GC.tAB2GC.bGnlWarning;

	bGnlTrip	:= bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
	(*******************************************************************************)

	
END_PROGRAM
