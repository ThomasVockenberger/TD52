(*******************************************************************************
gcb 		generator circuit breaker control

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2020

Customized modifications: -
------------------------
 
History:
-------
V1.10	12-01-2006	lettenb.	new
V1.11	16-03-2006	lettenb.	scb[1].on/off replaced with tie_on/off 
V2.12	24.04.2006				LH	mcb1 imported from MSY
								mcb1 --> gcb
								adapted for esy new
		22.09.2006	LH			extented release gcb
		11.11.2006	LH			revised after Para.bMSy test
		20.11.2006	LH			revised for final release esy new
V2.20	07.02.2007	LH			-bridging gcb ready signal while winding up spring
								-demand synchronization: gcb.alarm --> gcb.monitoring_release
								-gcb on to dead busbar: alarm_voltage_sensor_bb1 integrated
								-advanced software documentation
V2.201	12.09.2007	LH			correction of network comments (FG_GSUW)
V2.30	18.01.2008	LH			adapted for test-bench run
		28.03.2008	LH			lock gcb in case of any position failure on busbar
V2.34.0	28.10.2008	lettenb.	Para.bBS_Acc_Active added
V2.50.0 28.01.2009	lettenb.	calm: IN_SY.bGCB_Off_RP, IN_SY.bGCB_Off_CNS added
V2.50.3 08.10.2009	lettenb.	tof_gcb_command_on added (extend gcb command on signal)
		30.11.2009  lettenb.	gcb.dmnd_sy:  n > 1400min-1 added
								(360min-1 + ton10"=IN_SY.tEng_Run.Do: ist zu früh!bei schlechter motoreinstellung
								 od. schlechter gasqualität)
V3.20.0	07.12.2010	lettenb.	P10proz added, selbsthaltung limit 10%Pnenn unterschritten wenn keine anford.
								(flackerndes limit setzt und löscht immer wieder on/off-command gcb (OUT_SY.tGCB_Cof.Do!))
V3.30.0	04.11.2011	lettenb.	gcb.release: IN_SY.tGCB_RGC.Do added	
V3.90.0	25.10.2012	lettenb.	Para.bGridCode_Active added
V3.99.0 24.06.2013	lettenb.	tof_gcb_man_off: only active with NOT bSyOMSS_Aut
								(to avoid gcb opening at SyOMSS_Aut->Man, within 6" after pressed gcb.man_off) 
								xGR_MAXR_P_HiNoManOff: Gw: 50.0 -> 0.5, bugfix
		23.06.2015	Graus,		type 6 load rejection - open gcb at full load
V4.03.0	29.07.2015	lettenb.	ton_gcb_dmnd_sy.PT := T#5s; removed(standardisierung für schnellstart/greenfrog)
                    plattner    temperature MAX generator switch gear power reduction and set, 
V4.04.0	22.09.2016	lettenb.	Para.rP_Red_TempMax_GenCB_Rate   /100 removed and logic changed, bugfix 
		11.10.2016	Perktold, 	Para.bGridCode_Active replaced by IN_SY.bGridCode_ON
		13.09.2018	lettenb.	ton_EINPF_2 moved for sequential arrangement, bu01
V4.07.0	17.12.2018	lettenb.	ton_gcb_dmnd_sy.IN: bGnlTrip added to avoid B2139"request synchr.",after gcb-opening by external protection(caused by removal of ton_gcb_dmnd_sy.PT), bugfix 
V4.10.0	16.10.2020	Weitzer		IN_SY.bCust_Dem_Sy added to GCB demand sy
					lettenb.	GCB_OnCnt added
V4.11.0	24.06.2021	Arnold		Open GCB in island on underfrequency IN_SY.bGCB_DCon_EC
V4.12.0	07.12.2022	lettenb.	ton_gcb_dmnd_sy.PT: T#0s -> 100ms, to avoid B2139 caused by time overlap,#890
								OUT_SY.bGCB_aut_on2dead_bb added,#912
								ton_gcb_dmnd_sy.IN: bOMSS_Man removed(as validated with saarbrücken AA46/wasserer)
V4.13.0	17.08.2023	lettenb.	dead bb synch, bugfixes(BR21/wasserer,schwab,lettenb.)
		29.11.2023	Goenczi		GCB demand synch conditions extended to command from BUS

Instructions FOR use:
--------------------
task have to be operated after MsgSY

Outstandings:
------------
remove ton_gcb_dmnd_sy
*******************************************************************************)
PROGRAM _CYCLIC

	IF	Para.bSyActive	THEN
		(*----------------------------------------------------------------------------*)
		(* gcb demand synchronization (OUT_SY.bGCB_DemSy) *)
		gcb_dmnd_IN1 :=  	(   bSyOMSS_Aut             AND (NOT IN_SY.bBus_Active OR NOT IN_SY.bOM_Bus));	(*gcb auto on command *)
		gcb_dmnd_IN2 :=		   (IN_SY.bSetAutControlMode AND     IN_SY.bOM_Bus AND NOT IN_SY.bSetGCB2Open);		(*gcb auto on command from bus*)
		gcb_dmnd_IN3 :=   	   (bSyOMSS_Man									(* gcb manual on command *)
							AND		bOMSS_Man 
							AND	NOT gcb.man_off
							AND	   (gcb.man_on OR ANW_ENTR OR ton_gcb_dmnd_sy.IN));
		gcb_dmnd_IN4 :=      (IN_SY.bOM_Bus 								(* gcb manual on command from bus *)
							AND NOT IN_SY.bSetAutControlMode
							AND     IN_SY.bSetManControlMode 
							AND NOT IN_SY.bSetGCB2Open
							AND    (IN_SY.bSetGCB2Close OR ANW_ENTR OR ton_gcb_dmnd_sy.IN))  ;

		ton_gcb_dmnd_sy.IN :=  (gcb_dmnd_IN1 OR gcb_dmnd_IN2 OR gcb_dmnd_IN3 OR gcb_dmnd_IN4  )  	(* synchronization selected *)
					AND    (IN_SY.rN_EngAct > (Para.rN_EngNom * 0.933))  		(* n > 1400 *)
					AND		IN_SY.tRel_Sync_Load.Do								(* engine ready for load (IN_SY.tRel_Sync_Load.Do) *)
					AND		gcb.eng_demanded									(* engine demanded (IN_SY.bEng_RPSDem) *)
					AND 	gcb.rdy												(* gcb ready for closing *)
					AND NOT gcb.on												(* gcb is open *)
					AND 	gcb.mon_release										(* monitoring release gcb *)
					AND NOT	mcb.dmnd_sy											(* no mcb demand synchronization (OUT_SY.bMCB_DemSy) *)
					AND	NOT	mcb_man_on2dead_bb									(* no manual closing mcb1 to dead busbar *)
					AND	NOT	mcb_aut_on2dead_bb									(* no automatic closing mcb1 to dead busbar *)
					AND NOT	any_gcb_edc_bb										(* no lock from external unit *)
					AND	NOT	gcb.mdl												(* no lock from Para.bMSy *)
					AND	NOT	bGen_DeExc_Err										(* no de-excitation failure *)
					AND    (IN_SY.tGrC_DCon.Do OR NOT IN_SY.bGridCode_ON)		(* gridcode release (LVRT) *)
					AND NOT bGnlTrip
	 				AND		IN_SY.bCust_Dem_Sy									(* release by customer - external synchronisation *)		
					AND		TRUE;												(* include additional release conditions *)

		ton_gcb_dmnd_sy.PT := T#100ms;
		ton_gcb_dmnd_sy();
		
		gcb.dmnd_sy	:=	ton_gcb_dmnd_sy.Q;										(* demand synchronization (OUT_SY.bGCB_DemSy) *)

		
		(*----------------------------------------------------------------------------*)
		(* release trip gcb *)
		ton_gcb_rel_trip(IN:= bDem_Island AND gcb.eng_oper, PT:= T#1s);
		
		gcb.rel_trip :=	ton_gcb_rel_trip.Q;										(* release trip gcb in case of mains failure *)
		
		
		(*----------------------------------------------------------------------------*)
		(* monitoring release gcb (FG_GSUW) *)
		gcb.mon_release :=	NOT gcb.alm_0sf										(* 0-signal failure gcb *)
						AND NOT gcb.alm_1sf										(* 1-signal failure gcb *)
						AND NOT gcb.alm_cf										(* closing failure gcb *)
						AND NOT any_gcb_opf_bb									(* gcb with opening failure *)
						AND NOT any_gcb_psf_bb									(* gcb with position failure *)
						AND	NOT	mcb.alm_opf										(* mains cb with opening failure *)
						AND	NOT	mcb.alm_psf										(* mains cb with position failure *)
						AND		mcb.remote										(* all mcb remote *)
						AND		IN_SY.tPB2MM.bSys_Run;							(* PLC running *)
		
		(*----------------------------------------------------------------------------*)
		(* release gcb *)
		ton_EINPF_1(IN:= NOT gcb.release             AND NOT IN_SY.tGCB_SM1.Di, PT:= T#5s);(* output signal test *)

		bSM1TestOk		:=	gcb.release
					OR	   (gcb.dmnd_sy AND ton_EINPF_1.Q);						(* digital output signal test ok *)
		(*-------------------------------------------------------------*)
	
		sy_lfg			:=	ton_EINPF_2.Q										(* relais contact signal test *)
					OR	   (sy_lfg AND IN_SY.tRel_Sync_Load.Do);

		ton_EINPF_2(IN:= NOT IN_SY.tRel_Sync_Load.Do AND     IN_SY.tGCB_SM2.Di, PT:= T#5s);(* relais contact signal test, this line have to be situated after building of sy_lfg! *)	
	
		bSM2TestOk		:= (sy_lfg AND OUT_SY.tGCB_RUC.Do)						(* relais contact signal test ok *)
					OR		SY_LFG_THJ;					
	
		SY_LFG_THJ		:=	sy_lfg;												(* extended load release (1 cycle) *)
		(*-------------------------------------------------------------*)

		bMnsConnection 	:=  mcb.on AND mains.ok AND	NOT	MM2VIS.bMsg3412;		(* mains connection ok *)							

		NWK_RS			:=	Para.bMCB_ReSw2Mns_Enable
					AND	NOT	mcb.on												(* mcb open *)
					AND		bMainsReturn;										(* mains return (OUT_SY.bMainsReturn(1)) *)
		
		bRS2Mains		:=	NWK_RS												(* mains ok for reswitch to mains for customer *)
					AND		IN_SY.tGCB_DRM.Di;									(* release for reswitch to mains from customer *)
		
		gcb.release		:=	gcb.mon_release										(* monitoring release gcb  *)
					AND		bSM1TestOk											(* digital output signal test ok *)
					AND		bSM2TestOk											(* relais contact signal test ok *)
					AND    (gcb.rdy        OR gcb.on)							(* gcb ready for closing *)
					AND	   (bMnsConnection OR gcb.rel_trip) 					(* no decoupling from mains *)
					AND	NOT	bRS2Mains											(* no reswitch to mains *)
					AND	NOT	any_gcb_edc_bb										(* no lock from customer *)
					AND	NOT	gcb.mdl												(* no lock from Para.bMSy *)
					AND	NOT	IN_SY.bGCB_Off_RP									(* gcb off by gen.reverse power *)
					AND	NOT	IN_SY.bGCB_Off_CNS									(* gcb off by asym.current *)
					AND    (IN_SY.tGrC_DCon.Do OR NOT IN_SY.bGridCode_ON)		(* LVRT failure *)
					AND	NOT IN_SY.bGCB_DCon_EC									(* GCB open command from EngineController *)
					AND		TRUE;												(* include additional release conditions *)
		
		
		(*----------------------------------------------------------------------------*)
		tof_gcb_man_off(IN:= gcb.man_off AND bOMSS_Man AND NOT bSyOMSS_Aut, PT:= T#6s);	(* extended manual off command gcb *)
		tof_gcb_dmnd_sy(IN:= gcb.dmnd_sy, PT:= T#100ms);						(* extended demand synchronize gcb *)
		
		(*----------------------------------------------------------------------------*)
		(* gcb on to dead busbar (GS_AES/GS_1) *)
		gcb.aut_on2dead_bb := (bSyOMSS_Aut OR bSyOMSS_Man)						(* synchronization is active *)
					AND 	gcb.release											(* release gcb *)
					AND 	gcb.dmnd_sy											(* gcb demand synchronization (OUT_SY.bGCB_DemSy) *)
					AND( 	bb_dead	OR(IN_SY.tDemGenExcOff.Di AND NOT bb_alive))(* dead busbar (OUT_SY.bBB_dead) *)
					AND(NOT	MM2VIS.bMsg1216 OR	OUT_SY.bTestBenchModeIsland)	(* no busbar voltage sensor failure *)
					AND	NOT	any_gcb_psf_bb										(* no gcb with position failure *)
					AND(NOT	mcb.alm_psf OR OUT_SY.bTestBenchModeIsland)			(* no mains cb with position failure *)
					AND 	gcb.edc												(* demand closing gcb to dead busbar *)
					AND		rel_gcb_on2d_bb										(* release closing gcb to dead busbar *)
					AND		rel_load_shedd										(* load shedding ok *)
					AND	   (bGen_DeExc_Rdy OR NOT Para.bGenDeexit_Enable);		(* generator de-excited *)
		
		OUT_SY.bGCB_aut_on2dead_bb := gcb.aut_on2dead_bb;

		(*----------------------------------------------------------------------------*)
		(* release sy-puls gcb (SY) *)
		gcb.rel_sy_puls :=	gcb.release
					AND		tof_gcb_dmnd_sy.Q									(* extended demand synchronize gcb (T74) *)
					AND	   (bSyOMSS_Aut	OR (bSyOMSS_Man AND	NOT	tof_gcb_man_off.Q))
					AND NOT IN_SY.tDemGenExcOff.Di
					AND     bb_alive;
		
		(*----------------------------------------------------------------------------*)
		(* command gcb off *)
		bP_Lo_Hold		:=  (gcb.eng_demanded OR  bP_Lo_Hold) AND NOT bP_Lo;	(* hold P_Lo in case of flickering signal*) 
		xGR_MAXR_P_HiNoManOff(In:= IN_SY.rP_Act_Norm_Filt, Gw:= 0.5, Hy:= 0.0); (* lockout manual gcb off command *)
																				(* with bOMSS_Aut + SyOMS_MAN: gcb can not be opened manually -> general topic *)
		gcb.dmnd_off 	:=	NOT gcb.release	
						OR 	   (bOMSS_Man	AND		tof_gcb_man_off.Q	AND (NOT	xGR_MAXR_P_HiNoManOff.Q OR (Para.bP_LoadReject_Active AND IN_SY.bType6_Update_Rel)))
					    OR     (bOMSS_Aut	AND NOT gcb.eng_demanded 	AND(	NOT gcb.on 
																			OR	NOT	bP_Lo_Hold 
																			OR (NOT OUT_SY.bOtherGenParallel AND NOT mcb.on)))
					    OR     (bOMSS_Test	AND NOT gcb.eng_demanded 	AND(	NOT gcb.on 
																			OR	NOT	bP_Lo_Hold 
																			OR (NOT OUT_SY.bOtherGenParallel AND NOT mcb.on)))
						OR     (IN_SY.bOM_Bus AND IN_SY.bSetGCB2Open);			(*demand off from bus - Aggreko*)
	
		gcb.command_off :=	gcb.dmnd_off OR NOT IN_SY.tPB2MM.bSys_Run;			(* true = command off *)
		
		
		(*----------------------------------------------------------------------------*)
		(* command gcb on to dead busbar *)
		gcb.dmnd_on	:=	gcb.aut_on2dead_bb;
		
		tof_gcb_command_on(IN:= gcb.dmnd_on	AND	NOT	gcb.on AND NOT gcb.command_off AND IN_SY.tPB2MM.bSys_Run, PT:= T#100ms);
		
		gcb.command_on:= tof_gcb_command_on.Q;


		(*----------------------------------------------------------------------------*)
		
	END_IF;


	(* added from pb10 *)
	(*----------------------------------------------------------------------------*)
	(* Collective alarm Prio. 1 -> Switch OFF OUT_SY.tGCB_RUC.Do with new motor Off strategy *)
	xTP_GnlTrip1(IN:= bGnlTrip1, PT:= T#5s);
	
	(* gcb release under voltage coil *)
	OUT_SY.tGCB_RUC.Do := 	NOT IN_SY.bMsg1038 									(* generator reverse power	*)
						AND(NOT IN_SY.bMsg1026	OR IN_SY.bMsg1026_Test)			(* shutdown failure			*)
						AND(NOT MM2VIS.bMsg1041	OR       bMsg1041_Test)			(* power signal missing		*)
						AND(NOT MM2VIS.bMsg1042 OR       bMsg1042_Test)			(* power signal overload	*)
						AND NOT MM2VIS.bMsg1217									(* gcb status signal failure*)
						AND NOT MM2VIS.bMsg1219									(* gcb closing failure		*)
						AND NOT xTP_GnlTrip1.Q;

	
	(*----------------------------------------------------------------------------*)
	(* Temperature max generator switch gear (Power reduction) *)
	IF Para.bP_Red_TempMax_GenCB_Active AND NOT IN_SY.tTempMax_GenCB.Di THEN
		OUT_SY.bP_Red_TempMax_GenCB_Sel	:= TRUE;
		OUT_SY.rP_Red_TempMax_GenCB_Norm := LIMIT(0.5, Para.rP_Red_TempMax_GenCB_Rate, 1.0);
	ELSE(* Temperature max generator switch gear (Power reduction) inaktive*)
		OUT_SY.bP_Red_TempMax_GenCB_Sel	:= FALSE;
		OUT_SY.rP_Red_TempMax_GenCB_Norm := 1.0;
	END_IF;


	(*----------------------------------------------------------------------------*)
	(* gcb on counter *)
	IF EDGEPOS(gcb.on) THEN
		VIS2MM.iGCB_OnCnt := (VIS2MM.iGCB_OnCnt + 1) MOD 100000;	(* counter, check limits *)
	END_IF;


	(*----------------------------------------------------------------------------*)

END_PROGRAM
