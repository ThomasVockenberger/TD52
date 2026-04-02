(*******************************************************************************
MsgSY	 			 messages 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V2.12	24.04.2006	LH			adapted for esy new
V2.20	07.02.2007	LH			adapted for supporting customer mcb
		26.04.2007	LH			closing failure gcb (5th try was successful):
					               - gcb on + 10 sec --> reset counter
					               - dalay closing fail. = 11 sec
		09.05.2007	LH			0/1-sign. fail. mcbx: activation with RUN in case of old hardware
V2.30	18.01.2008	LH			adapted for test-bench run
		14.02.2008	LH			reset moved from end to begin
		28.03.2008	LH			gcb not closed and load > 10% --> gcb position failure
		07.04.2008	LH			new gcb position monitoring active with release from engine control
V2.311a	13.05.2008	LH			set delay time new gcb position failure up to 2 sec.
V2.33.0	16.07.2008	lettenb.	mcb[1].alm_psf disabled with PRF_I (circuitus)
V2.60.0	13.08.2009	lettenb.	ton_gcb_opf	for opening mcb with delay addedf
V3.20.0	14.04.2010	lettenb.	change to new global structure ALM
		11.11.2010				1216 enable busbar 1 voltage sensor failure	if not bSynch
		07.12.2010				1219 ctd_gcb_cf[1].LOAD	mit quitt_wa
								(reset ctd_gcb_cf[1] funktioniert nicht wenn eng[1].sy_rdy = false)
V3.99.0	25.02.2012	lettenb.	3329,3352,3575,3576,3577 added (integration V3.30-V3.40)
		24.05.2013				reset OUT_xx.txx2AB.bGnlTripx changed
		18.06.2013				2140 removed (made in MM_OP), 2139 logic changed, xMsg2139+xMsg2140 removed
V4.00.0	27.02.2014				logger added
		06.03.2014				Para.bGlowIgnPrevent -> Para.bGlowIgnPrevActive
		20.06.2014				VIS2MM.bServiceBegin --> IN_SY.bServiceMode (no 2nd plc-tag)
V4.00.1	19.11.2014				1042 generator power signal overload, without delay, new parameter(920 stapelfeld), 
								1041 generator power signal missing (920 stapelfeld)
								1175,1216,1217,1220 enable with IN_SY.tPB2MM.bSys_Run
								1039 xTOF_SYANW removed, bugfix
V4.03.0	22.07.2015				2692,2693,2801 new, dyn.gridcode III(thaler)
                                2730 Temperature max generator switch gear
								init: xMsg1038 removed(see MM_GC)
		21.09.2015				2688 added + bugfix 1.5 -> 0.5
        04.02.2016				1041 xTON_LSA.PT for 920 from 0s -> 300ms to avoid 1041 at grid code event
V4.04.0	04.07.2016				2901-2903 added, tLockEng_ClosCond.Do added
		13.09.2016				1041 xGR_MAX_LSA_LD.Gw 1.5 -> 2.0 bar for 920(request: spyra klaus)
		28.09.2016				3400 added, holland/belgien standard, plattner joh.
		07.10.2016				2801 logic changed acc.kiel validation(thalerj)
		30.03.2017				1210 AND NOT IN_SY.tMns_MDF.Di -> AND IN_SY.tMns_MDF.Di, bugfix
		07.04.2017				gcb.alarm MM2VIS.bMsg1214 removed, bugfix
V4.05.0 31.05.2017  lettenb.    reservation for mcb2/mains2 messages removed(comment)
                                2934 added, grid code logic
		22.01.2018	lettenb.	1175,1189,1216,3329 bParaSetupOk added TO avoid message at plc startup
		24.01.2018				1214 mcb.remote, 5" delay added(to avoid mcb-off at plc startup),(glantschnig)
V4.05.1	09.03.2018	Perktold,	delayed A1042 trip (only HiHi part), 100ms normal, 500ms when LVRT Event is detected (for 5s)
V4.06.0 21.09.2018  Perktold,   A1042 implemented 110% overload step 3s delay excluded bBDC_Emergency_OFF
		11.10.2018				A1041 generator power signal missing --> 1s delay for NOT Type9 and GEN2
V4.07.0	31.10.2018	lettenb.	2330,9244,9245 added
		12.02.2019				9244 delay 0s->30s	
		26.02.2019	Perktold	Update A1042, removed 120% overload case (ECR E18-00283)
		02.05.2019	lettenb.	1237,1238 removed(not used/->OP), clean up
V4.09.0	17.10.2019	lettenb.	9304 added, protection test mapping
		16.03.2020	lettenb.	2688 only active with synch.pulse(not with gcb closing to dead busbar), bugfix
V4.10.0	23.11.2020	lettenb.	9331,2354 added
		22.12.2020	lettenb.	1041: RiskClass setting corr.acc.TI 1100-0111
		22.02.2021	Arnold		1042: include 120% 500ms overload trip in island mode
V4.11.0	07.07.2021	lettenb.	init xMsg2692.Num: 2693->2692, bugfix
		29.09.2021	lettenb.	9304 delay 100->300ms for correct assistant value transfer, bugfix 
V4.12.0	02.05.2022	Schmidt		W2688 (high sync current) threshold increased from 50% to 75% of nominal current
		15.06.2022	lettenb.	3269,3296,3297 added, dead bb synch
		10.03.2023	lettenb.	2366: detection of multiple short GCB OnOff events(BR6: puffmini causes engine stop/restart)
V4.13.0	17.08.2023	lettenb.	dead bb synch, bugfixes(BR21/wasserer,schwab,lettenb.)
		26.09.2023	Farre,		LCB operating message when open (B9083) or closed (B9084)
		07.11.2023	Hohensinner	added LV GCB op messages and warnings: B9085, W9382 and W9383
		29.11.2023	Goenczi,	W1175,W1189,W3412 reset, W1209 enable, W3412 set condition standardized
V4.14.0	25.10.2024	Farre,		GCB Opening Failure - W1217 and reverse power connected to GCB_OpF command (2024-241)

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
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	


3)  expand INIT

4)	include datapoint into OPC configuration for vis

(******************************************************************************
alarms overview:
W 1209 - 1215	mcb alarms
W 1216			general alarms sy
W 1217 - 1224	gcb alarms 
*****************************************************************************	
		
Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)
	OUT_SY.tSY2AB.bGnlTrip1		:=	FALSE;
	OUT_SY.tSY2AB.bGnlTrip2		:=	FALSE;
	OUT_SY.tSY2AB.bGnlTrip3		:=	FALSE;
	OUT_SY.tSY2AB.bGnlWarning	:=	FALSE;
	OUT_SY.tSY2AB.bTriptype1	:=	FALSE;
	OUT_SY.tSY2AB.bTriptype2	:=	FALSE;
	OUT_SY.tSY2AB.bTriptype3	:=	FALSE;
	
	
	(*---------------------------------------------------------------------------*)
	(* A1039 synchronizing failure *)
	xTON_SYST1(IN:=(OUT_SY.bSynchDem OR gcb.dmnd_sy OR mcb.dmnd_sy)
			AND 	IN_SY.tRel_Sync_Load.Do
			AND NOT IN_SY.tGCB_On.Di 
			AND NOT bGnlTrip, PT:= T#600s);  // AT16

	xTON_SYST2(IN:= IN_SY.tEng_Run.Do AND NOT IN_SY.tGCB_On.Di, PT:= T#1200s); // AT32
		
	xMsg1039.Enable		:= TRUE;
	xMsg1039.Set		:= xTON_SYST1.Q OR xTON_SYST2.Q;
	xMsg1039.PT			:= T#0s;
	xMsg1039.Prio		:= 2;
	xMsg1039.RiskClass	:= 0;
	xMsg1039.Reset		:= FALSE;	
	xMsg1039();
	MM2VIS.bMsg1039		:= xMsg1039.Q;


	(* A1041 generator power signal missing *)
 	(* generator power low *)
	xGR_MINR_P_Lo(In:= IN_SY.rP_Act_Norm, Gw:= Para.rP_LimLo, Hy:= Para.rP_HyLo);
	bP_Lo  := xGR_MINR_P_Lo.Q AND IN_SY.tPB2MM.bParaSetupOk; 

	xTOF_bGen2_Act(IN := IN_SY.bGen2_Act, PT := T#5s);		//GEN2 Controller running + TOF delay for shutdown

	IF IN_SY.bMMD_GenAlarmTestOn THEN
		IF xEngType.Type9 THEN 
			xTON_LSA(IN:= bP_Lo,                          										PT:= T#300ms);
		ELSIF NOT xEngType.Type9 AND xTOF_bGen2_Act.Q THEN
			xTON_LSA(IN:= bP_Lo,                                           						PT:= T#1s);
		ELSE
			xTON_LSA(IN:= bP_Lo,                                                               	PT:= T#15s);
		END_IF;
	ELSE
		IF xEngType.Type9 THEN
			xTON_LSA(IN:= bP_Lo AND NOT IN_SY.bEng_Dem_EPS AND bOMSS_Aut AND IN_SY.tGCB_On.Di, PT:= T#300ms);
		ELSIF NOT xEngType.Type9 AND xTOF_bGen2_Act.Q THEN
			xTON_LSA(IN:= bP_Lo AND NOT IN_SY.bEng_Dem_EPS AND bOMSS_Aut AND IN_SY.tGCB_On.Di, PT:= T#1s);
		ELSE
			xTON_LSA(IN:= bP_Lo AND NOT IN_SY.bEng_Dem_EPS AND bOMSS_Aut AND IN_SY.tGCB_On.Di, PT:= T#15s);
		END_IF;
	END_IF;

	(* Charge pressure higher than 1.5 bar / 2.0 bar(920) *)
	IF xEngType.Type9 THEN xGR_MAX_LSA_LD(In:= MAX(IN_SY.tPr_Ch_P2s.Ai, MAX(IN_SY.tPr_Ch_P2s_A.Ai, IN_SY.tPr_Ch_P2s_B.Ai)), Gw:= 2.0, Hy:= 0.01);
	ELSE                   xGR_MAX_LSA_LD(In:= MAX(IN_SY.tPr_Ch_P2s.Ai, MAX(IN_SY.tPr_Ch_P2s_A.Ai, IN_SY.tPr_Ch_P2s_B.Ai)), Gw:= 1.5, Hy:= 0.01);
	END_IF;
	xTON_LSA_LD(IN:= xGR_MAX_LSA_LD.Q, PT:= T#1s);

	xMsg1041.Enable		:= TRUE;		
	IF IN_SY.bMMD_GenAlarmTestOn THEN	xMsg1041.Set :=	xTON_LSA.Q;
	ELSIF xEngType.Type9 OR xTOF_bGen2_Act.Q THEN	xMsg1041.Set :=	xTON_LSA.Q 
											 		AND NOT bGnlTrip1
													AND NOT bGnlTrip2
								            		AND 	xTON_LSA_LD.Q 
											 		AND(NOT IN_SY.bSCO_Active OR NOT Para.bGlowIgnPrevActive);	
	ELSE									xMsg1041.Set :=	xTON_LSA.Q 
								            		AND 	xTON_LSA_LD.Q 
											 		AND(NOT IN_SY.bSCO_Active OR NOT Para.bGlowIgnPrevActive);
	END_IF;
	xMsg1041.PT			:= T#0s;
	xMsg1041.Prio		:= 2;
	xMsg1041.RiskClass	:= 3;
	xMsg1041.Reset		:= FALSE;	
	xMsg1041();
	MM2VIS.bMsg1041 	:= xMsg1041.Q;
	bMsg1041_Test		:= xMsg1041.Test;		
	MM2VIS.bMsg1041Set 	:= xMsg1041.Set;	
	OUT_SY.bMsg1041Set  := xMsg1041.Set;	


	(* A1042 generator power signal overload *)	

	(*110% overload step 3s delay*)
	xGR_MAXR_P_Hi110  (In:= IN_SY.rP_Act_Norm_Filt, Gw:= 1.1,   Hy:= 0.01);
	xTON_P_Hi110(IN:= xGR_MAXR_P_Hi110.Q, PT:= T#3s);

	(*105% overload step 15s delay*)
	xGR_MAXR_P_Hi  (In:= IN_SY.rP_Act_Norm_Filt, Gw:= Para.rP_LimHi,   Hy:= Para.rP_HyHi);
	xTON_P_Hi(IN:= xGR_MAXR_P_Hi.Q, PT:= T#15s);

	(* 120% overload step 500ms delay - only in island mode*)
	xTON_ParaInit_P_LimHiHi(IN := IN_SY.tPB2MM.bParaSetupOk AND Para.rP_LimHiHi 		<= 0.0,	PT := T#1s500ms);
	xTON_ParaInit_Ti_P_LimHiHi(IN := IN_SY.tPB2MM.bParaSetupOk AND Para.ti_P_LimHiHi 	<= T#0s, PT := T#1s500ms);
	IF xTON_ParaInit_P_LimHiHi.Q THEN		Para.rP_LimHiHi 	:= 1.2;			END_IF;
	IF xTON_ParaInit_Ti_P_LimHiHi.Q THEN	Para.ti_P_LimHiHi 	:= T#500ms;		END_IF;

	xGR_MAXR_P_HiHi(In:= IN_SY.rP_Act_Norm,      Gw:= Para.rP_LimHiHi, Hy:= Para.rP_HyHi);
	xTON_P_HiHi(IN:= xGR_MAXR_P_HiHi.Q AND xOpMode.Island, PT:= Para.ti_P_LimHiHi);

	xMsg1042.Enable		:=	TRUE;		
	xMsg1042.Set		:= IN_SY.tPB2MM.bParaSetupOk AND(xTON_P_Hi.Q OR xTON_P_Hi110.Q OR xTON_P_HiHi.Q);
	xMsg1042.PT			:=	T#0s;
	xMsg1042.Prio		:=	2;
	xMsg1042.RiskClass	:=	4;
	xMsg1042.Reset		:=	FALSE;	
	xMsg1042();
	MM2VIS.bMsg1042		:=	xMsg1042.Q;
	bMsg1042_Test		:=	xMsg1042.Test;
	MM2VIS.bMsg1042Set	:=	xMsg1042.Set;
	OUT_SY.bMsg1042Set  :=  xMsg1042.Set;


	(* W1175 mains failure *)
	xMsg1175.Enable		:= IN_SY.tPB2MM.bParaSetupOk;
	xMsg1175.Set		:=(NOT OUT_SY.bMainsReturn OR NOT OUT_SY.bMnsOk) AND NOT OUT_SY.bRel_Island;
	xMsg1175.PT			:= T#0s;
	xMsg1175.Prio		:= 4;
	xMsg1175.RiskClass	:= 4;
	xMsg1175.Reset		:= IN_SY.bSetIslandMode;	
	xMsg1175();
	MM2VIS.bMsg1175		:= xMsg1175.Q;


	(* W1189 release from synchronization missing *)
	xMsg1189.Enable		:= IN_SY.tPB2MM.bParaSetupOk;
	xMsg1189.Set		:= 		IN_SY.tPB2MM.bSys_Run
						AND NOT OUT_SY.bRelEngOpFromSy
						AND(	NOT OUT_SY.bOnly_Island 
						  	OR		IN_SY.bEng_RPSDem
	                       	OR	NOT bN_EngStart1);
	xMsg1189.PT			:= T#0s;
	xMsg1189.Prio		:= 4;
	xMsg1189.RiskClass	:= 4;
	xMsg1189.Reset		:= IN_SY.bSetFixedPwrMode;	
	xMsg1189();
	MM2VIS.bMsg1189		:= xMsg1189.Q;

	bN_EngStart1 := bN_EngStart;	(* delay of 1 cycle, to avoid alarm 1189 at normal shutdown with only island operation *)
	

	(* W1209 main circuit breaker position signal failure*)
	xMsg1209.Enable		:=  Para.bSyActive
					AND	   (Para.bMCB_Enable OR Para.bMCB_Ctr_Cust OR Para.bIslandOp_Enable OR Para.bOnlyIsland_Enable OR Para.bMSy)
					AND NOT OUT_SY.bTestBenchModeIsland
					AND NOT (Para.iSel_Customer = 2);
	xMsg1209.Set		:= IN_SY.tPB2MM.bSys_Run
					AND(   (    mcb.on AND     mcb.off)
						OR (NOT	mcb.on AND NOT mcb.off));
	xMsg1209.PT			:= T#5s;
	xMsg1209.Prio		:= 4;
	xMsg1209.RiskClass	:= 4;
	xMsg1209.Reset		:= FALSE;	
	xMsg1209();
	MM2VIS.bMsg1209		:= xMsg1209.Q;


	(* W1210 main circuit breaker opening failure *)
	xMsg1210.Enable		:= Para.bSyActive AND Para.bMCB_Enable;
	xMsg1210.Set		:= mcb.on
					AND	NOT	MM2VIS.bMsg1210
					AND(	mcb.command_off 
						OR (mcb.rel_trip AND IN_SY.tMns_MDF.Di AND NOT mains.ok));

	xMsg1210.PT			:= T#5s;
	xMsg1210.Prio		:= 4;
	xMsg1210.RiskClass	:= 4;
	xMsg1210.Reset		:= FALSE;	
	xMsg1210();
	MM2VIS.bMsg1210		:= xMsg1210.Q;	


	(* W1211 main circuit breaker switch closing failure *)
	r_trig_mcb_on(CLK:= mcb.command_on OR mcb.on);
	
	ton_mcb_on(IN:= mcb.on, PT:= T#60s);

	r_trig_mcb_ct(CLK:=	ton_mcb_on.Q
					OR	NOT	IN_SY.tPB2MM.bSys_Run
					OR	NOT	mcb.remote
					OR     (mcb.alm_cf	AND	IN_SY.tAB2SY.bResetWarning));

	ctd_mcb_cf.CD	:=	r_trig_mcb_on.Q	AND	mcb.remote;
	ctd_mcb_cf.LOAD	:=	r_trig_mcb_ct.Q;
	ctd_mcb_cf.PV	:=	5;
	ctd_mcb_cf();

	ton_ctd_mcb(IN := ctd_mcb_cf.Q, PT:= T#1s);
	ton_mcb_cf(IN:= mcb.rel_sy_puls AND NOT mcb.on, PT := T#600s);
	ton_mcb_cf1(IN:= mcb.command_on AND NOT mcb.on, PT := T#6s);
	
	xMsg1211.Enable		:= Para.bSyActive AND Para.bMCB_Enable;
	xMsg1211.Set		:= ton_ctd_mcb.Q	OR	ton_mcb_cf.Q	OR	ton_mcb_cf1.Q;
	xMsg1211.PT			:= T#0s;
	xMsg1211.Prio		:= 4;
	xMsg1211.RiskClass	:= 4;
	xMsg1211.Reset		:= FALSE;	
	xMsg1211();
	MM2VIS.bMsg1211		:= xMsg1211.Q;


	(* W1212 mains circuit breaker 0-signal failure *)
	xMsg1212.Enable		:= Para.bSyActive AND Para.bMCB_Enable;
	xMsg1212.Set		:= 	IN_SY.tMCB_SM.Di
					AND		mcb.remote  
					AND NOT mcb.rel_sy_puls 
					AND NOT mcb.command_on;

	xMsg1212.PT			:= T#5s;
	xMsg1212.Prio		:= 4;
	xMsg1212.RiskClass	:= 4;
	xMsg1212.Reset		:= FALSE;	
	xMsg1212();
	MM2VIS.bMsg1212		:= xMsg1212.Q;


	(* W1213 mains circuit breaker 1-signal failure *)
	xMsg1213.Enable		:= Para.bSyActive AND Para.bMCB_Enable;
	xMsg1213.Set		:=	NOT	IN_SY.tMCB_SM.Di
						AND		mcb.remote
						AND    (mcb.rel_sy_puls OR mcb.command_on);

	xMsg1213.PT			:= T#5s;
	xMsg1213.Prio		:= 4;
	xMsg1213.RiskClass	:= 4;
	xMsg1213.Reset		:= FALSE;	
	xMsg1213();
	MM2VIS.bMsg1213		:= xMsg1213.Q;


	(* W1214 main circuit breaker overload/short-circuit *)
	xMsg1214.Enable		:= Para.bMCB_Enable OR Para.bMCB_Ctr_Cust;
	xMsg1214.Set		:=	NOT IN_SY.tMCB_OL.Di
				 		AND		mcb.remote;
	xMsg1214.PT			:= T#5s;
	xMsg1214.Prio		:= 4;
	xMsg1214.RiskClass	:= 4;
	xMsg1214.Reset		:= FALSE;	
	xMsg1214();
	MM2VIS.bMsg1214		:= xMsg1214.Q;	


	(* W1216 bus bar voltage sensor failure *)
	xMsg1216.Enable		:= IN_SY.tPB2MM.bParaSetupOk;
	xTOF1216(IN:= gcb.mdl OR IN_SY.tDemGenExcOff.Di, PT:= T#5s);
	IF Para.bSyActive THEN
		xMsg1216.Set	:= 	NOT	bb_alive
						AND(   (mcb.on				AND		mains.ok)
							OR (any_gcb_on_bb		AND	NOT	OUT_SY.bGen_Exc_Off AND NOT xTOF1216.Q));
	ELSE
		xMsg1216.Set	:=	NOT	IN_SY.tBB_Alive.Di
						AND(   (mcb.on				AND		mains.ok)
							OR (IN_SY.tGCB_On.Di	AND	NOT	OUT_SY.bGen_Exc_Off AND NOT xTOF1216.Q)
							OR  IN_SY.tC_CB_On.Di);
	END_IF;							
	xMsg1216.PT			:= T#5s;
	xMsg1216.Prio		:= 4;
	xMsg1216.RiskClass	:= 4;
	xMsg1216.Reset		:= FALSE;	
	xMsg1216();
	MM2VIS.bMsg1216		:= xMsg1216.Q;


	(* W1217 Generator circuit breaker position signal failure *)
	ton_gcb_psf(IN:=   (    gcb.on	AND		gcb.off)
					OR (NOT	gcb.on	AND	NOT gcb.off), PT:= T#3s);
	
	xMsg1217.Enable		:= Para.bSyActive AND IN_SY.tPB2MM.bSys_Run;
	xMsg1217.Set		:=  ton_gcb_psf.Q 
					OR (NOT	gcb.on 	AND	NOT	bP_Lo AND IN_SY.tPB2MM.bParaSetupOk);
	xMsg1217.PT			:= T#2s;
	xMsg1217.Prio		:= 4;
	xMsg1217.RiskClass	:= 4;
	xMsg1217.Reset		:= FALSE;	
	xMsg1217();
	MM2VIS.bMsg1217		:= xMsg1217.Q;

	OUT_SY.bGCB_psf_EngStop	:=	MM2VIS.bMsg1217 AND xOpMode.Stop;	(* send GCB position signal failure to Opstate - Block module release sync missing *)

	(* W1218 generator circuit breaker opening failure *)
	xTON_gcb_psf_P_rev	(IN:= IN_SY.bPact_Rev AND xMsg1217.Q, PT:= T#5s);	(* Pact negative and gcb position failure detected *)
	
	xMsg1218.Enable		:= Para.bSyActive;
	xMsg1218.Set		:=  (gcb.on AND (gcb.command_off	OR	NOT	IN_SY.tRel_Sync_Load.Do))
						OR	xTON_gcb_psf_P_rev.Q;			(* include in opening failure when reverse power is measured *)

	xMsg1218.PT			:= T#5s;
	xMsg1218.Prio		:= 4;
	xMsg1218.RiskClass	:= 4;
	xMsg1218.Reset		:= FALSE;	
	xMsg1218();
	MM2VIS.bMsg1218		:= xMsg1218.Q;

	gcb.alm_opf			:= xMsg1218.Q;

	ton_gcb_opf.IN 		:= 	(gcb.alm_opf AND NOT gcb.off) 	(* GCB opening failure - gcb_on and command_off but gcb_off response is false *)
						OR 	xTON_gcb_psf_P_rev.Q;			(* GCB position failure - gcb_on and gcb_off or not gcb_on and not gcb_off, when reverse power *)
	ton_gcb_opf.PT 		:= 	T#2s;
	ton_gcb_opf();
	gcb_opf_delay		:=	ton_gcb_opf.Q;	(* opening mcb after delay *)
	

	(* W1219 generator circuit breaker closing failure *)
	r_trig_gcb_on(CLK:= IN_SY.tGCB_SM1.Di);
	ton_gcb_on(IN:=	gcb.on, PT:= T#10s);
	r_trig_gcb_ct(CLK:= NOT IN_SY.tRel_Sync_Load.Do OR ton_gcb_on.Q);
	
	ctd_gcb_cf.CD	:=	r_trig_gcb_on.Q;
	ctd_gcb_cf.LOAD	:=	r_trig_gcb_ct.Q OR IN_SY.tAB2SY.bResetWarning;
	ctd_gcb_cf.PV	:=	5;
	ctd_gcb_cf();
	
	ton_ctd_gcb(IN:=	ctd_gcb_cf.Q, PT:= T#11s);
	ton_gcb_cf1(IN:=	gcb.command_on AND NOT gcb.on, PT:= T#5s);
		
	xMsg1219.Enable		:= Para.bSyActive;
	xMsg1219.Set		:= (ton_ctd_gcb.Q OR ton_gcb_cf1.Q) AND NOT MM2VIS.bMsg2366;
	xMsg1219.PT			:= T#0s;
	xMsg1219.Prio		:= 4;
	xMsg1219.RiskClass	:= 4;
	xMsg1219.Reset		:= FALSE;	
	xMsg1219();
	MM2VIS.bMsg1219		:= xMsg1219.Q;

	
	(* W1220 generator circuit breaker 0-signal failure *)
	xMsg1220.Enable		:= Para.bSyActive AND IN_SY.tPB2MM.bSys_Run;
	xMsg1220.Set		:= (	IN_SY.tGCB_SM1.Di	    AND NOT	gcb.release)												(* SM1 *)
						OR (NOT	IN_SY.tRel_Sync_Load.Do AND	NOT	gcb.dmnd_sy AND	NOT	gcb.release AND	NOT	IN_SY.tGCB_SM2.Di);	(* SM2 *)
	xMsg1220.PT			:= T#5s;
	xMsg1220.Prio		:= 4;
	xMsg1220.RiskClass	:= 4;
	xMsg1220.Reset		:= FALSE;	
	xMsg1220();
	MM2VIS.bMsg1220		:= xMsg1220.Q;

	
	(* W1221 generator circuit breaker 1-signal failure *)
	xMsg1221.Enable		:= Para.bSyActive;	
	xMsg1221.Set		:= (gcb.on AND NOT gcb.command_off AND NOT IN_SY.tGCB_SM1.Di)
						OR (IN_SY.tRel_Sync_Load.Do	AND	IN_SY.tGCB_SM2.Di);
	xMsg1221.PT			:= T#5s;
	xMsg1221.Prio		:= 4;
	xMsg1221.RiskClass	:= 4;
	xMsg1221.Reset		:= FALSE;	
	xMsg1221();
	MM2VIS.bMsg1221		:= xMsg1221.Q;

	
	(* W1222 generator manual circuit breaker opened *)
	xMsg1222.Enable		:= FALSE;
	xMsg1222.Set		:= NOT gcb.rdy;
	xMsg1222.PT			:= T#0s;
	xMsg1222.Prio		:= 4;
	xMsg1222.RiskClass	:= 4;
	xMsg1222.Reset		:= FALSE;	
	xMsg1222();
	MM2VIS.bMsg1222		:= xMsg1222.Q;

    (* A2330 mid voltage CB failure *)
	xMsg2330.Enable		:= TRUE;
	xMsg2330.Set		:= NOT IN_SY.tMidVoltCB_Failure.Di;
	xMsg2330.PT			:= T#0s;
	xMsg2330.Prio		:= 2;
	xMsg2330.RiskClass	:= 4;
	xMsg2330.Reset		:= FALSE;	
	xMsg2330();
	MM2VIS.bMsg2330		:= xMsg2330.Q;

	(* A2354 Earth fault bus bar *)
	xMsg2354.Enable    := TRUE;
	xMsg2354.Set       := NOT IN_SY.tGndFault_BB.Di;
	xMsg2354.PT        := T#0s;
	xMsg2354.RiskClass := 4;
	xMsg2354.Prio      := 2;
	xMsg2354.Reset     := FALSE;
	xMsg2354();
	MM2VIS.bMsg2354    := xMsg2354.Q;

	(* A2366 Generator circuit breaker closing failure *)
	(* detection of multiple short GCB OnOff events (BR6: puffmini causes engine stop/restart) *)
	xTP_gcb_on (IN:=     IN_SY.tGCB_On.Di, PT:= T#1s);
	xF_TRIG_gcb_on(CLK:= IN_SY.tGCB_On.Di);
	xR_TRIG_gcb_OnOffct(CLK:= ton_gcb_on.Q);
	
	xCTD_gcb_OnOffEvent.CD   :=	xTP_gcb_on.Q AND xF_TRIG_gcb_on.Q;
	xCTD_gcb_OnOffEvent.LOAD :=	xR_TRIG_gcb_OnOffct.Q OR MM2VIS.bMsg2366 OR EDGEPOS(IN_SY.tPB2MM.bParaSetupOk);
	xCTD_gcb_OnOffEvent.PV   :=	5;
	xCTD_gcb_OnOffEvent();
	
	xMsg2366.Enable    := IN_SY.tPB2MM.bParaSetupOk;
	xMsg2366.Set       := xCTD_gcb_OnOffEvent.Q;
	xMsg2366.PT        := T#0s;
	xMsg2366.RiskClass := 4;
	xMsg2366.Prio      := 3;
	xMsg2366.Reset     := FALSE;
	xMsg2366();
	MM2VIS.bMsg2366    := xMsg2366.Q;
	
	(* W2688 Generator current at synchronization too high *)
	xTP_GCB_On(IN:= IN_SY.tGCB_On.Di, PT:= T#10s);
	xTP_MMD_SynchDO(IN:= IN_SY.bMMD_SynchDO[1], PT:= T#10s);
	
	xMsg2688.Enable    := TRUE;
	xMsg2688.Set       := xTP_GCB_On.Q
					AND   xTP_MMD_SynchDO.Q
				    AND ((IN_SY.rI_MaxL1[1] > (0.75 * Para.rI_GenNom[1]))
					  OR (IN_SY.rI_MaxL2[1] > (0.75 * Para.rI_GenNom[1]))
					  OR (IN_SY.rI_MaxL3[1] > (0.75 * Para.rI_GenNom[1])));
	xMsg2688.PT        := T#0s;
	xMsg2688.RiskClass := 4;
	xMsg2688.Prio      := 4;
	xMsg2688.Reset     := FALSE; 
	xMsg2688(); 
	MM2VIS.bMsg2688    :=  xMsg2688.Q;

	
	(* W2692 mains circuit breaker opening failure *)
	xMsg2692.Enable		:= TRUE;
	xMsg2692.Set		:= NOT IN_SY.tMCB_OpF_Ext.Di;
	xMsg2692.PT			:= T#0s;
	xMsg2692.Prio		:= 4;
	xMsg2692.RiskClass	:= 4;
	xMsg2692.Reset		:= FALSE;	
	xMsg2692();
	MM2VIS.bMsg2692		:= xMsg2692.Q;
	
	
	(* W2693 generator circuit breaker opening failure *)
	xMsg2693.Enable		:= TRUE;
	xMsg2693.Set		:= NOT IN_SY.tGCB_OpF_Ext.Di;
	xMsg2693.PT			:= T#0s;
	xMsg2693.Prio		:= 4;
	xMsg2693.RiskClass	:= 4;
	xMsg2693.Reset		:= FALSE;	
	xMsg2693();
	MM2VIS.bMsg2693		:= xMsg2693.Q;


        (* W2730 low voltage CB failure *)	(* high temperature NLD / BEL specific *)
	xMsg2730.Enable		:= Para.bP_Red_TempMax_GenCB_Active;
	xMsg2730.Set		:= NOT IN_SY.tTempMax_GenCB.Di;
	xMsg2730.PT			:= T#0s;
	xMsg2730.Prio		:= 4;
	xMsg2730.RiskClass	:= 4;
	xMsg2730.Reset		:= FALSE;	
	xMsg2730();
	MM2VIS.bMsg2730		:= xMsg2730.Q;
	
	(* W3329 earth circuit breaker closed *)	(* france country specific *)
	xMsg3329.Enable		:= IN_SY.tPB2MM.bParaSetupOk;
	xMsg3329.Set		:= NOT IN_SY.tEarthCB_Off.Di;
	xMsg3329.PT			:= T#0s;
	xMsg3329.Prio		:= 2;
	xMsg3329.RiskClass	:= 4;
	xMsg3329.Reset		:= FALSE;	
	xMsg3329();
	MM2VIS.bMsg3329		:= xMsg3329.Q;

	
	(* W3352 earth circuit breaker opened *)	(* france country specific *)
	xMsg3352.Enable		:= TRUE;
	xMsg3352.Set		:= NOT IN_SY.tIsoCB_Off.Di;
	xMsg3352.PT			:= T#0s;
	xMsg3352.Prio		:= 2;
	xMsg3352.RiskClass	:= 4;
	xMsg3352.Reset		:= FALSE;	
	xMsg3352();
	MM2VIS.bMsg3352		:= xMsg3352.Q;
	
	(* A3400 module blocked by no operating release from sy or cooling water temp.low *)
	xMsg3400.Enable		:= (Para.iCountry = iHolland);
	xMsg3400.Set		:=  NOT OUT_SY.bRelEngOpFromSy 
						OR( 	bOMSS_Aut AND IN_SY.bT_ECW_Lo);
	xMsg3400.PT			:= T#0s;
	xMsg3400.Prio		:= 0;	 (* special for holland/plattner joh. *)
	xMsg3400.RiskClass	:= 4;
	xMsg3400.Reset		:= TRUE; (* auto reset *)	
	xMsg3400();
	MM2VIS.bMsg3400		:= xMsg3400.Q;

	(* W3412 mains monitoring device failure/ generator protection relay failure *)
	xMsg3412.Enable		:= TRUE;
	xMsg3412.Set		:= NOT IN_SY.tMns_MDF.Di AND NOT IN_SY.bSetIslandMode;
	xMsg3412.PT			:= T#0s;
	xMsg3412.Prio		:= 4;
	xMsg3412.RiskClass	:= 4;
	xMsg3412.Reset		:= IN_SY.bSetIslandMode;	
	xMsg3412();
	MM2VIS.bMsg3412		:= xMsg3412.Q;


	(* W3575 mains failure GTE2666 *)	(* france country specific *)
	xMsg3575.Enable		:= TRUE;
	xMsg3575.Set		:= NOT IN_SY.tMnsOk_GTE.Di;
	xMsg3575.PT			:= T#0s;
	xMsg3575.Prio		:= 4;
	xMsg3575.RiskClass	:= 4;
	xMsg3575.Reset		:= FALSE;	
	xMsg3575();
	MM2VIS.bMsg3575		:= xMsg3575.Q;


	(* W3576 mains failure C13.100 *)	(* france country specific *)
	xMsg3576.Enable		:= TRUE;
	xMsg3576.Set		:= NOT IN_SY.tMnsOk_TGS.Di;
	xMsg3576.PT			:= T#0s;
	xMsg3576.Prio		:= 4;
	xMsg3576.RiskClass	:= 4;
	xMsg3576.Reset		:= FALSE;	
	xMsg3576();
	MM2VIS.bMsg3576		:= xMsg3576.Q;


	(* W3577 earth circuit breaker opened *)	(* france country specific *)
	xMsg3577.Enable		:= TRUE;
	xMsg3577.Set		:= NOT IN_SY.tMnsOk_C13100.Di;
	xMsg3577.PT			:= T#0s;
	xMsg3577.Prio		:= 4;
	xMsg3577.RiskClass	:= 4;
	xMsg3577.Reset		:= FALSE;	
	xMsg3577();
	MM2VIS.bMsg3577		:= xMsg3577.Q;

	(* W9244 generator circuit breaker not ready *)
	xMsg9244.Enable		:= TRUE;
	xMsg9244.Set		:= NOT IN_SY.tGCB_Rdy.Di;
	xMsg9244.PT			:= T#30s;
	xMsg9244.Prio		:= 4;
	xMsg9244.RiskClass	:= 4;
	xMsg9244.Reset		:= FALSE;	
	xMsg9244();
	MM2VIS.bMsg9244		:= xMsg9244.Q;

	(* W9245 generator circuit breaker not racked-in *)
	xMsg9245.Enable		:= TRUE;
	xMsg9245.Set		:= NOT IN_SY.tGCB_Rac.Di;
	xMsg9245.PT			:= T#0s;
	xMsg9245.Prio		:= 4;
	xMsg9245.RiskClass	:= 4;
	xMsg9245.Reset		:= FALSE;	
	xMsg9245();
	MM2VIS.bMsg9245		:= xMsg9245.Q;

	(* W9304 generator circuit breaker closing time deviation high *)
	xMsg9304.Enable		:= Para.bMMDSynch_Act[1] AND IN_SY.tPB2MM.bParaSetupOk;
	xMsg9304.Set		:= bGCBctd;
	xMsg9304.PT			:= T#300ms;(* delay needed for assistant value transfer(tiGCB_ClosTimeOld) to HMI *)
	xMsg9304.Prio		:= 4;
	xMsg9304.RiskClass	:= 4;
	xMsg9304.Reset		:= TRUE;(* autoreset, because reset is done in task: gcbTC1 *)	
	xMsg9304();
	MM2VIS.bMsg9304		:= xMsg9304.Q;

	(* W9331 maintenance request generator circuit breaker *)
	xMsg9331.Enable		:= IN_SY.tPB2MM.bParaSetupOk AND (Para.rU_Gen_Nom[1] < 1000);
	xMsg9331.Set		:= (VIS2MM.iGCB_OnCnt >= Para.iGCB_OnCnt_LimHi);
	xMsg9331.PT			:= T#0s;
	xMsg9331.Prio		:= 4;
	xMsg9331.RiskClass	:= 4;
	xMsg9331.Reset		:= FALSE;
	xMsg9331();
	MM2VIS.bMsg9331		:= xMsg9331.Q;

	(* W9382 GCB contact wear over 80% *)
	xMsg9382.Enable		:= IN_SY.tPB2MM.bSys_Run;
	xMsg9382.Set		:= bW9382_GCB_Wear80;
	xMsg9382.PT			:= T#0s;
	xMsg9382.Prio		:= 4;
	xMsg9382.RiskClass	:= 4;
	xMsg9382.Reset		:= FALSE;
	xMsg9382();
	MM2VIS.bMsg9382		:= xMsg9382.Q;

	(* W9383 GCB contact wear over 95% *)
	xMsg9383.Enable		:= IN_SY.tPB2MM.bSys_Run;
	xMsg9383.Set		:= bW9383_GCB_Wear95;
	xMsg9383.PT			:= T#0s;
	xMsg9383.Prio		:= 4;
	xMsg9383.RiskClass	:= 4;
	xMsg9383.Reset		:= FALSE;
	xMsg9383();
	MM2VIS.bMsg9383		:= xMsg9383.Q;
	
	(*---------------------------------------------------------------------------*)
	(* mains circuit breaker alarms *)
	mcb.alm_psf		:=		MM2VIS.bMsg1209;
	mcb.alm_opf		:=		MM2VIS.bMsg1210;
	mcb.alm_cf		:=		MM2VIS.bMsg1211;
	mcb.alm_0sf 	:=		MM2VIS.bMsg1212;
	mcb.alm_1sf 	:=		MM2VIS.bMsg1213;
	mcb.alm_ol		:=		MM2VIS.bMsg1214;

	mcb.alarm		:=		MM2VIS.bMsg1209
						OR	MM2VIS.bMsg1210
						OR	MM2VIS.bMsg1211
						OR	MM2VIS.bMsg1212
						OR	MM2VIS.bMsg1213
						OR	MM2VIS.bMsg1214;

	
	(* generator circuit breaker alarms *)
	gcb.alm_psf		:=		MM2VIS.bMsg1217;
	gcb.alm_opf		:=		MM2VIS.bMsg1218;
	gcb.alm_cf		:=		MM2VIS.bMsg1219;
	gcb.alm_0sf 	:=		MM2VIS.bMsg1220;
	gcb.alm_1sf 	:=		MM2VIS.bMsg1221;
	gcb.alm_ol;

	gcb.alarm		:=		MM2VIS.bMsg1217
						OR	MM2VIS.bMsg1218
						OR	MM2VIS.bMsg1219
						OR	MM2VIS.bMsg1220
						OR	MM2VIS.bMsg1221
						OR	MM2VIS.bMsg1222;
	

	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)

	(* B1235 generator circuit breaker closed *)
	xMsg1235.Enable		:=	TRUE;
	xMsg1235.Set		:=		IN_SY.tGCB_On.Di;	
	xMsg1235.Reset		:=	TRUE;
	xMsg1235();
	MM2VIS.bMsg1235		:= xMsg1235.Q;

	(* B1236 generator circuit breaker opened *)
	xMsg1236.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg1236.Set		:=	NOT IN_SY.tGCB_On.Di;
	xMsg1236.Reset		:=	TRUE;
	xMsg1236();
	MM2VIS.bMsg1236		:= xMsg1236.Q;

	(* B2139 synchronizing running  *)
	xMsg2139.Enable		:=	TRUE;
	xMsg2139.Set		:=	OUT_SY.bGCB_DemSy  AND NOT OUT_SY.bBB_dead;
	xMsg2139.Reset		:=	TRUE;
	xMsg2139();
	MM2VIS.bMsg2139		:= xMsg2139.Q;
	
	(* B2801 Module blocked by grid connection conditions *)
	xMsg2801.Enable		:=	TRUE;
//	xMsg2801.Set		:=  NOT bBBClosCond_Fault
//						AND	NOT bAMM_ClosCond_Ok 
//						AND   ((IN_SY.bEng_Bloc AND NOT bN_EngStart)(* = iIdx_Eng_State = 19 = blocking module *)
//							OR  IN_SY.bMMD_BB_AlarmTestOn);

	xMsg2801.Set		:= (NOT bAMM_ClosCond_Ok AND NOT bBBClosCond_Fault AND(IN_SY.bEng_Bloc AND NOT bN_EngStart))(* = iIdx_Eng_State = 19 = blocking module *)
						OR (NOT bAMM_ClosCond_Ok AND     IN_SY.bMMD_BB_AlarmTestOn);

	xMsg2801.Reset		:=	TRUE;
	xMsg2801();
	MM2VIS.bMsg2801		:= xMsg2801.Q;
	OUT_SY.tLockEng_ClosCond.Do	:= NOT MM2VIS.bMsg2801;	//acc.kiel validation
	MM2VIS.bMsg2801Set	:= xMsg2801.Set;
	OUT_SY.bMsg2801Set  := xMsg2801.Set;

	(* B2901 synchronization selection OFF *)
	xMsg2901.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg2901.Set		:=	bSyOMSS_Off;
	xMsg2901.Reset		:=	TRUE;
	xMsg2901();
	MM2VIS.bMsg2901		:= xMsg2901.Q;
	
	(* B2902 synchronization selection MAN *)
	xMsg2902.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg2902.Set		:=	bSyOMSS_Man;
	xMsg2902.Reset		:=	TRUE;
	xMsg2902();
	MM2VIS.bMsg2902		:= xMsg2902.Q;
	
	(* B2903 synchronization selection AUT *)
	xMsg2903.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg2903.Set		:=	bSyOMSS_Aut;
	xMsg2903.Reset		:=	TRUE;
	xMsg2903();
	MM2VIS.bMsg2903		:= xMsg2903.Q;
	
	(* B2934 Module blocked by grid connection conditions - after mains failure *)
	xMsg2934.Enable		:=	TRUE;
//	xMsg2934.Set		:=  bBBClosCond_Fault
//					AND NOT bAMM_ClosCond_Ok 
//					AND   ((IN_SY.bEng_Bloc AND NOT bN_EngStart)(* = iIdx_Eng_State = 19 = blocking module *)
//	OR  IN_SY.bMMD_BB_AlarmTestOn);

	xMsg2934.Set		:= (NOT bAMM_AfMnsF_ClosCond_Ok AND bBBClosCond_Fault AND(IN_SY.bEng_Bloc AND NOT bN_EngStart))(* = iIdx_Eng_State = 19 = blocking module *)
						OR (NOT bAMM_AfMnsF_ClosCond_Ok AND IN_SY.bMMD_BB_AlarmTestOn);
	
	xMsg2934.Reset		:=	TRUE;
	xMsg2934();
	MM2VIS.bMsg2934		:= xMsg2934.Q;
	OUT_SY.tAfMnsF_LockEng_ClosCond.Do := NOT MM2VIS.bMsg2934;
	MM2VIS.bMsg2934Set	:= xMsg2934.Set;
	OUT_SY.bMsg2934Set	:= xMsg2934.Set;

	(* B3253 begin of maintenance/testbench mode *)
	xMsg3253.Enable		:=	TRUE;
	xMsg3253.Set		:=	bTestBenchMode OR IN_SY.bServiceMode;
	xMsg3253.Reset		:=	TRUE;
	xMsg3253();
	MM2VIS.bMsg3253		:=	xMsg3253.Q;

	(* B3254 end of maintenance/testbench mode *)
	xMsg3254.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg3254.Set		:=	NOT bTestBenchMode AND NOT IN_SY.bServiceMode;
	xMsg3254.Reset		:=	TRUE;
	xMsg3254();
	MM2VIS.bMsg3254		:=	xMsg3254.Q;

	(* B3263 mains circuit breaker closed *)
	xMsg3263.Enable		:=	TRUE;
	xMsg3263.Set		:=		OUT_SY.bMCB_On;
	xMsg3263.Reset		:=	TRUE;
	xMsg3263();
	MM2VIS.bMsg3263		:=	xMsg3263.Q;

	(* B3264 mains circuit breaker opened *)
	xMsg3264.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg3264.Set		:=	NOT OUT_SY.bMCB_On;
	xMsg3264.Reset		:=	TRUE;
	xMsg3264();
	MM2VIS.bMsg3264		:=	xMsg3264.Q;

	(* B3265 demand close GCB *)
	xMsg3265.Enable		:=	TRUE;
	xMsg3265.Set		:=	ton_gcb_dmnd_sy.IN AND OUT_SY.bBB_dead;
	xMsg3265.Reset		:=	TRUE;
	xMsg3265();
	MM2VIS.bMsg3265		:=	xMsg3265.Q;

	(* B3266 mains failure on *)
	xMsg3266.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg3266.Set		:=	NOT OUT_SY.bMnsOk;
	xMsg3266.Reset		:=	TRUE;
	xMsg3266();
	MM2VIS.bMsg3266		:=	xMsg3266.Q;

	(* B3267 mains failure off *)
	xMsg3267.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg3267.Set		:=		OUT_SY.bMnsOk;
	xMsg3267.Reset		:=	TRUE;
	xMsg3267();
	MM2VIS.bMsg3267		:=	xMsg3267.Q;

	(* B3269 generator de-energized *)
	xMsg3269.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg3269.Set		:=	bGen_DeExc_Rdy;
	xMsg3269.Reset		:=	TRUE;
	xMsg3269();
	MM2VIS.bMsg3269		:=	xMsg3269.Q;

	(* B3296 demand generator excitation off *)
	xMsg3296.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg3296.Set		:=	bGenDeexitDem;
	xMsg3296.Reset		:=	TRUE;
	xMsg3296();
	MM2VIS.bMsg3296		:=	xMsg3296.Q;

	(* B3297 demand generator excitation on *)
	xMsg3297.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg3297.Set		:=	NOT bGenDeexitDem;
	xMsg3297.Reset		:=	TRUE;
	xMsg3297();
	MM2VIS.bMsg3297		:=	xMsg3297.Q;
	
	(* B9083 Line circuit breaker opened *)
	xMsg9083.Enable		:=	IN_SY.tLineCB_On.GoodQual;
	xMsg9083.Set		:=	NOT IN_SY.tLineCB_On.Di;
	xMsg9083.Reset		:=	TRUE;
	xMsg9083();
	MM2VIS.bMsg9083		:=	xMsg9083.Q;
	
	(* B9084 Line circuit breaker closed *)
	xTP_B9084(IN:= IN_SY.tLineCB_On.Di, PT:= T#20s);

	xMsg9084.Enable		:=	IN_SY.tLineCB_On.GoodQual;
	xMsg9084.Set		:=	xTP_B9084.Q;
	xMsg9084.Reset		:=	TRUE;
	xMsg9084();
	MM2VIS.bMsg9084		:=	xMsg9084.Q;

	(* B9085 Parameters saved to the GCB *)
	xMsg9085.Enable		:=	IN_SY.tPB2MM.bSys_Run;
	xMsg9085.Set		:=	bB9085_GCB_ParaSaved;
	xMsg9085.Reset		:=	TRUE;
	xMsg9085();
	MM2VIS.bMsg9085		:=	xMsg9085.Q;
	
(* B template 
	xMsg.Enable		:=	TRUE;
	xMsg.Set		:=	bBool;
	xMsg.Reset		:=	TRUE;
	xMsg();
	MM2VIS.bMsg		:=	xMsg.Q;
	*)

	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1		:=	OUT_SY.tSY2AB.bGnlTrip1   OR IN_SY.tAB2SY.bGnlTrip1;
	bGnlTrip2		:=	OUT_SY.tSY2AB.bGnlTrip2   OR IN_SY.tAB2SY.bGnlTrip2;
	bGnlTrip3		:=	OUT_SY.tSY2AB.bGnlTrip3   OR IN_SY.tAB2SY.bGnlTrip3;
	bGnlWarning		:=	OUT_SY.tSY2AB.bGnlWarning OR IN_SY.tAB2SY.bGnlWarning;

	bGnlTrip		:=	bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
(*******************************************************************************)
END_PROGRAM
