 (********************************************************************
EleStart		engine start/stop control: electrical starter equipment 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
Customized modifications: -
------------------------
 
History:
-------
V01		10.07.1998 Pa			erstellt
V2.20.3	30.11.2007 LH			Ausspuren Starter bei Zahn auf Zahn 
V2.30.0	16.01.2008 LH			Blockierung Modul angepasst für Insel nach Ablauf KU-Filter 
 		30.01.2008 LH			Ansteuerung MEGA-Gasventile 
 		02.04.2008 LH			1-maliges Absetzen von UW-EIN nach Kaltstart
V2.33.0	17.07.2008 lettenb.		sel_GlowIgnPrevent added
V2.34.0	22.10.2008 lettenb.		AT4_BLOCK added, block.ack.by starter temp.(op.message 3300)
								bs_15s_rel_oper added
		03.12.2008 lettenb.		ZM_GASV: M_GASV added	
V2.50.0	28.01.2009 lettenb.		ZM_M_BLOCK: M_ST_VORW removed
			   	            	puff_mini removed
		06.04.2009 lett./gföll./plattner	Vorschmierzeit fix mit 60 = ersatz für TW_T85
								überbrückung T_VERZ_ANF bei notstrom(M_NANF)
V2.60.0	07.08.2009 lettenb.		udp_dmnd, udp_comm removed, ANF_NB added
								ssExtPwrSetP1, ssExtPwrSetP2, DI_ExtPwrSetP1, DI_ExtPwrSetP2 added
								custom.counter1-4 moved to c_amm  
V3.10.0	19.01.2010 lettenb.		QUITT_TUEV reset pulse according EN ISO 13849-1 / 5.2.2
								(d.h. Ausgangsimpuls an UW_EIN erst wenn der RESET-Taster losgelassen wird)
V3.20.0	05.08.2010 lettenb.		ton_RESET_4 added reset counter for AT4_BLOCK after cool down
		15.09.2010 MM (BuR)  	STARTER_IgnST included
		30.09.2010 MM (BuR)  	GS_EIN replaced with GCB_ON
		30.09.2010 MM(BuR) 		NW20 deleted (GCB_ON --> GCB_ON)
		30.09.2010 MM(BuR) 		M_GSEIN replaced with GCB_ON
		21.10.2010 lettenb. 	AW_EXPSH, AW_EXPSB, B_P_SOLL, B_P_RED, AW_EXDSH, AW_EXDSB, B_N_SOLL
								sel.ext.power setpoint moved to task: p_limits 
		05.11.2010 lettenb.		purgecycle added
		07.12.2010 lettenb.		BLOCK_EVU added, ZUEND: contact STARTER_IgnST changed
		14.02.2011 lettenb.		selection duration start puls time added
V3.90.0	29.10.2012 lettenb.		logic for manual start prozedure changed
V3.99.0	14.02.2013 lettenb.		IN_AG.bGasMix_Ref(M_GM_Ref) removed, not supported from MM gas mixer
V3.99   28.02.2013 pankajrodey	Generated for modular software with changes for V3.30
V3.99.1	20.01.2014 lettenb.		man.start time 30" added
V3.99.2	05.12.2013 zengerer		ADAPTIVE maximum start time 22" to 35" with rTiFactor_Cylinders AND rTiFactor_Cylinders FOR series 4 deflagration, new OUT: bRel_Gasvalve for MM op_state
V3.99.3	09.12.2013 zengerer		CleanUp
V3.99.4	02.01.2014 zengerer		prepared FOR PILOT ENGINES: save statistic data of 200 starts in task Perm_AG
V3.99.5	29.01.2014 zengerer		bGV_Start_ScaveBlock, MM2VIS.rN_EngStart (and others) optional reactivated
V3.99.6	19.03.2014 zengerer		entered Para.bVISA to prevent use of new adoptive start, if VISA reglementation is selected
V4.00.1 09.05.2014 lettenb.		xEngType.Type4: OUT_AG.tChargeOff_Dem.Do added, bugfix
V4.00.1 19.05.2014 Denk			xTON_StartErr Startzeit von 20s --> 12s
V4.00.2 30.05.2014 lettenb.		startup failure counter also for man.starts, bugfix + cleanup
V4.00.3 30.06.2014 lettenb.		xEngType.Type2 added, bugfix
V4.00.4 01.10.2014 lettenb.		bugfix startup failure in combination with EG_Scav(BR3,4)
		03.11.2014				start duration times BR3,6 corr., bugfix
V4.00.5	03.02.2015				920 added
		20.04.2015				xTP_StarterON: phantomstart resolved
V4.04.0	18.11.2016				xTON_DelayStart.PT, xTON_DelayManStart.PT: 6->0s start delay removed(fahringer)
		21.12.2016 Denk			Modification for WinMOD simulation
V4.05.0	07.08.2017 Messner		Starter battery voltage monitoring
		01.02.2018 lettenb.		tiStarterOFF; define value at plc startup(when xCTD_Start.CV=0), bugfix(1st start too long/perktold)
V4.05.1	14.02.2018 Weitzerr		move starter battery voltage monitoring to task AuxGnl
		19.09.2018 lettenb.		switching off battery charge for BR2+3 identical to BR4(HW solution not working), bu
V4.06.0	19.09.2018 Perktold,	integrated OUT_AG.iStartCount
V4.07.0	25.10.2018 Schmid		xTON_RESET_4: only triggered with IN_AG.bEng_SU_Man, bugfix
V4.10.0	28.01.2021 Schmid		interface for ChargeOff_Dem for starter battery test added
		29.01.2021 Schmid		manual start stop buttons from Opstate instead of VIS
V4.12.0 21.12.2022 Bacci		Starter battery monitoring parameters added: Para.rN_StarterMonTtT_LimLo and Para.tiStarterMonDuration. W9074 added
		20.01.2023 Zengerer		Type3 flush start time preparation optional with bOptType3AdoptiveStartEnab
V4.13.0	21.07.2023 Bacci		Type3 new starting procedure and adaptive first start attempt (bOptType3AdoptiveStartEnab deleted)
		20.11.2023 Bacci		Starter/s correct engagement monitoring added
V4.14.0	25.11.2024 Bacci		T6 Start procedure with purge start (2024-219)
V4.25.0	10.09.2025 Bacci	 	Include purge air calculation via SafetyPLC (2025-260)

Instructions for use:
--------------------
Outstandings:
------------
(*********************************************************************)

PROGRAM _CYCLIC	
	
	(* Engine Type 9 - Return *)
	IF xEngType.Type9 THEN RETURN;
    END_IF;

	IF xEngType.Type6 THEN
		xR_TRIG_bParaSetupOk(CLK := IN_AG.tPB2MM.bParaSetupOk);
		IF xR_TRIG_bParaSetupOk.Q THEN
			rTi_ST_Active_zero := LIMIT(0, TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000 * (1 - (LIMIT(0.2, Para.rST_ReqOpTiAftCooldown, 1))), MAX(0,TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000));
		END_IF;
	ELSE
		rTi_ST_Active_zero := 0;
	END_IF;

	bAdoptiveStartEnab := (xEngType.Type4 OR xEngType.Type3) AND NOT Para.bVISA; 

	IF xEngType.Type6 THEN							(* BR6 *)(* No longer used (2024-219) *)
		tiStarterON1 :=	 T#25s; 	(* = Total start time incl. flush cranking time at 1st start attempt in automatic *)
		tiStarterON2 :=	 T#20s;		(* = Total start time incl. flush cranking time at 2nd start attempt in automatic *)
		tiStarterON3 :=	 T#20s; 	(* = Total start time incl. flush cranking time at 3rd start attempt in automatic *)
		tiStartScav1 :=	 T#2s;		(* = flush cranking time wthout gas, for 1st start attempt *)
		tiStartScav2 :=	 T#2s;  	(* = flush cranking time wthout gas, for 2nd start attempt *)
		tiStartScav3 :=	 T#2s;  	(* = flush cranking time wthout gas, for 3rd start attempt *)
		tiStarterOFF1 := T#14s; 	(* = N.C. not in use *)
		tiStarterOFF2 := T#14s; 	(* = delay time until 2nd start attempt *)
		tiStarterOFF3 := T#14s; 	(* = delay time until 3rd start attempt *)
	ELSIF xEngType.Type4 AND NOT Para.bVISA THEN 	(* BR4 *)
		tiStarterON1 :=	 T#22s;		(* = Total start time incl. flush cranking time, base time for 1st start attempt- ADAPTIVE maximum time 22" (max.35" *)
		tiStarterON2 :=	 T#30s;		(* = Total start time incl. flush cranking time, for 2nd start attempt *)
		tiStarterON3 :=	 T#30s;		(* = Total start time incl. flush cranking time, for 3rd start attempt *)
		tiStartScav1 :=	 T#0s;		(* = flush cranking time wthout gas, for 1st start attempt- ADAPTIVE maximum time 22" to 35" *)
		tiStartScav2 :=	 T#10s;		(* = flush cranking time wthout gas, for 2nd start attempt *)
		tiStartScav3 :=	 T#10s;		(* = flush cranking time wthout gas, for 3rd start attempt *)
		tiStarterOFF1 := T#15s;		(* = n.c. *)
		tiStarterOFF2 := T#12s;		(* = delay time until 2nd start attempt *)
		tiStarterOFF3 := T#301s;	(* = delay time until 3rd start attempt *)
	ELSIF xEngType.Type3 AND NOT Para.bVISA THEN 		(* BR3 option with flush hardware *)
		tiStarterON1 :=	 T#34s;		(* = Total start time incl. flush cranking time, base time for 1st start attempt- ADAPTIVE maximum time 34" (max.40" *)	
		tiStarterON2 :=	 T#30s;		(* = Total starg time incl. flush cranking time, time for 2nd start attempt *)
		tiStarterON3 :=	 T#30s;		(* = Total start time incl. flush cranking time, time for 3rd start attempt *)
		tiStartScav1 :=	 T#10s;		(* = flush cranking time wthout gas, for 1st start attempt- ADAPTIVE maximum time 22" to 35" *)
		tiStartScav2 :=	 T#10s;		(* = flush cranking time wthout gas, for 2nd start attempt *)
		tiStartScav3 :=	 T#10s;		(* = flush cranking time wthout gas, for 3rd start attempt *)
		tiStarterOFF1 := T#15s;		(* = n.c. *)
		tiStarterOFF2 := T#12s;		(* = delay time until 2nd start attempt *)
		tiStarterOFF3 := T#301s;	(* = delay time until 3rd start attempt *)
	ELSE											(* BR2,BR3 with standard hardware *)
		tiStarterON1 :=	 T#20s; 	(* = Total start time incl. flush cranking time, for 1st start attempt *)
		tiStarterON2 :=	 T#20s;		(* = Total start time incl. flush cranking time, for 2nd start attempt *)
		tiStarterON3 :=	 T#20s;		(* = Total start time incl. flush cranking time, for 3rd start attempt *)
		tiStartScav1 :=	 T#0s;		(* = flush cranking time wthout gas, for 1st start attempt *)
		tiStartScav2 :=	 T#0s;		(* = flush cranking time wthout gas, for 2nd start attempt *)
		tiStartScav3 :=	 T#0s;		(* = flush cranking time wthout gas, for 3rd start attempt *)
		tiStarterOFF1 := T#12s;		(* = n.c. *)
		tiStarterOFF2 := T#12s;		(* = delay time until 2nd start attempt *)
		tiStarterOFF3 := T#12s;		(* = delay time until 3rd start attempt *)
	END_IF;

									
	IF rTiFactor_Cylinders = 0 THEN	rTiFactor_Cylinders := 0.99; END_IF;
	IF rTiFactor_N_EngStart= 0 THEN	rTiFactor_N_EngStart:= 0.99; END_IF;

	(* start stop button info from Opstate *)
	bStart 	:= IN_AG.bStart;
	bStop 	:= IN_AG.bStop;
	
	(* -------------------------------------------------------------------------------------------------------------------------------------- *)
	(* New type 6 starting procedure *)

	(* ------------------------------------------------------------------------------------ *)
	(* EleStart cycle time *)
	RTInfo_CTR(enable := TRUE);
	tiCycleTime := UDINT_TO_TIME(RTInfo_CTR.cycle_time)/1000;		// time variable
	rCycleTime := UDINT_TO_REAL(RTInfo_CTR.cycle_time)/1000000;  	// real variable in seconds

	(* ------------------------------------------------------------------------------------ *)
	(* Set parameter 15074 "Minimum air volume required for system purge" based on parameter 11303 "exhaust gas scavenging active" and EPS demand *)
	IF xEngType.Type6 THEN
		IF NOT Para.bEGScav_Active THEN 				// Exhaust gas scavenging not active
			IF xEngType.Motortype = 612 THEN
				IF IN_AG.bEng_Dem_EPS THEN
					iVol_MinAirLim_SysPurge := 680;
				ELSE
					iVol_MinAirLim_SysPurge := MAX(680, Para.iVol_MinAir_SysPurge);
				END_IF;
			ELSIF xEngType.Motortype = 616 THEN
				IF IN_AG.bEng_Dem_EPS THEN
					iVol_MinAirLim_SysPurge := 750;
				ELSE
					iVol_MinAirLim_SysPurge := MAX(750, Para.iVol_MinAir_SysPurge);
				END_IF;
			ELSIF xEngType.Motortype = 620 THEN
				IF IN_AG.bEng_Dem_EPS THEN
					iVol_MinAirLim_SysPurge := 800;
				ELSE
					iVol_MinAirLim_SysPurge := MAX(800, Para.iVol_MinAir_SysPurge);
				END_IF;
			ELSIF xEngType.Motortype = 624 THEN
				IF IN_AG.bEng_Dem_EPS THEN
					iVol_MinAirLim_SysPurge := 1400;
				ELSE
					iVol_MinAirLim_SysPurge := MAX(1400, Para.iVol_MinAir_SysPurge);
				END_IF;
			END_IF;
		ELSIF Para.bEGScav_Active AND (IN_AG.bEng_Dem_EPS AND (NOT Para.bEGScav_ifAuxV_ok OR NOT IN_AG.tAuxV_Eng_ok.Di)) THEN 				// Exhaust gas scavenging active, but not executed during EPS
			IF xEngType.Motortype = 612 THEN
				iVol_MinAirLim_SysPurge := 680;
			ELSIF xEngType.Motortype = 616 THEN
				iVol_MinAirLim_SysPurge := 750;
			ELSIF xEngType.Motortype = 620 THEN
				iVol_MinAirLim_SysPurge := 800;
			ELSIF xEngType.Motortype = 624 THEN
				iVol_MinAirLim_SysPurge := 1400;
			END_IF;
		ELSE
			iVol_MinAirLim_SysPurge := 0;
		END_IF;
	ELSE
		iVol_MinAirLim_SysPurge := 0;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* Volume flow through the engine *)
	IF xEngType.Type6 THEN
		rVol_CylDis :=	((UINT_TO_REAL(xEngType.Bore)/1000/2) ** 2 * brmPI * UINT_TO_REAL(xEngType.Stroke)/1000) * 1000; 								// single cylinder displacement [lt], //	Volume [lt]	:=	(( radius [m] ) ^ 2 * PI * ( stroke [m] ))*1000
		IF IN_AG.rN_EngAct > 50 THEN
			rVolFlow_RunEng := LIMIT(0, Para.rVolEff_CrkSpeed * rVol_CylDis * UINT_TO_REAL(xEngType.NumberOfCylinder) * IN_AG.rN_EngAct/120, 20000);	// volume flow through the engine REAL [lt/s]
		ELSE
			rVolFlow_RunEng := 0;
		END_IF;
		iVolFlow_RunEng := REAL_TO_UDINT(rVolFlow_RunEng);																								// volume flow through the engine UDINT [lt/s]
	ELSE
		rVol_CylDis := 0;
		rVolFlow_RunEng := 0;
		iVolFlow_RunEng := 0;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* Volume of mixture calculation *)
	xTON_GVOpen_1s(IN:= IN_AG.bGV_On, PT:= T#1s);																								// gas valve open for more than 1 second

	IF xEngType.Type6 THEN
		//Fuel admition status
		IF xTON_GVOpen_1s.Q  THEN
			 rFuelAdm := 1;
		ELSE
			 rFuelAdm := (Para.rVolFlow_Marg - 1);
		END_IF;
	
		IF IN_AG.rN_EngAct = 0 OR OUT_AG.tEleStarter_Dem.Do THEN 																				// during engine standstill and during cranking phase
			rVol_Mx := LIMIT(0, rVol_Mx + rFuelAdm * rVolFlow_RunEng * rCycleTime, LIMIT(100, UDINT_TO_REAL(Para.iVol_TolUnbrtMxMax), 5000));	
		ELSIF IN_AG.rN_EngAct <> 0 AND NOT IN_AG.bGV_On AND NOT OUT_AG.tEleStarter_Dem.Do  THEN													// during shut down phase
			rVol_Mx := LIMIT(0, rVol_Mx + rFuelAdm * rVolFlow_RunEng * rCycleTime, UDINT_TO_REAL(Para.iVol_PremxInSys));
		ELSIF M_DREHZ AND IN_AG.bGV_On THEN 																									// during engine operation
			rVol_Mx := UDINT_TO_REAL(Para.iVol_PremxInSys);
		END_IF;
	ELSE
		rFuelAdm := 0;
		rVol_Mx := 0;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* Purge state identification *)
	IF xEngType.Type6 THEN
		(* Volume of purge air calculation *)
		IF IN_AG.bSafetyPLC_Active AND NOT Para.bEGScav_Active THEN 														//coming from safety PLC 	(* SAFETY PLC *)
			rVol_PurgeAir := IN_AG.rVol_PurgeAir_SafeOUT;																								(* SAFETY PLC *)
		ELSIF xTON_GVOpen_1s.Q OR bFail_PurgeCrk THEN																									(* SAFETY PLC *)
			rVol_PurgeAir := 0;
		ELSE
			rVol_PurgeAir := LIMIT(0, rVol_PurgeAir + rVolFlow_RunEng * (1 - Para.rVolFlow_Marg) * rCycleTime, 100000);		// volume of purge air REAL [lt]
		END_IF;
		iVol_PurgeAir := REAL_TO_UDINT(rVol_PurgeAir);																		// volume of purge air UDINT [lt]
	
		(* Purge state *)
		(* detect reset of emergancy operation demand  *)
		xF_TRIG_bEng_Dem_EPS(CLK := IN_AG.bEng_Dem_EPS);
		IF xF_TRIG_bEng_Dem_EPS.Q THEN
			bSt_Purge := FALSE;																								// set purge status to false after emergency operation demand reset
		END_IF;
	
		IF IN_AG.bSafetyPLC_Active AND NOT Para.bEGScav_Active THEN 														//coming from safety PLC 	(* SAFETY PLC *)
			bSt_Purge := IN_AG.bSafeOUT_Purge_OK;																										(* SAFETY PLC *)
		ELSIF xTON_GVOpen_1s.Q THEN 																													(* SAFETY PLC *)
			bSt_Purge := FALSE;
		ELSIF (rVol_PurgeAir >= UDINT_TO_REAL(iVol_MinAirLim_SysPurge)) THEN
			bSt_Purge := TRUE;
		END_IF;

		(* detect successful purge cranking cycle *)
		xR_TRIG_bSt_Purge(CLK := bSt_Purge);
	ELSE
		rVol_PurgeAir := 0;
		iVol_PurgeAir := 0;
		bSt_Purge := FALSE;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* Starter temperature monitoring *)
	IF xEngType.Type6 THEN
		(* detect beginning of starter cool down phase *)
		xF_TRIG_bEleStarter_Dem(CLK := OUT_AG.tEleStarter_Dem.Do);
		IF xF_TRIG_bEleStarter_Dem.Q THEN
			rTi_ST_Active_zero := rTi_ST_Active;
			rTi_ST_Cooldown := 0;
		END_IF;
	
		(* Cumulated starting time calculation REAL [s] *)
		IF OUT_AG.tEleStarter_Dem.Do THEN 
			rTi_ST_Active := LIMIT(0, rTi_ST_Active + Para.rST_Heatup_Fact * rCycleTime, MAX(0,TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000));																// Starter in use, heat up phase
		ELSE
			rTi_ST_Active := LIMIT(0, rTi_ST_Active_zero * EXP(-(rTi_ST_Cooldown / LIMIT(100, TIME_TO_REAL(Para.tiST_CooldownConst)/1000, 9000))), MAX(0,TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000));	// Starter not in use, cool down phase
			rTi_ST_Cooldown := rTi_ST_Cooldown + rCycleTime;
		END_IF;
	
		IF rTi_ST_Active < 1 AND NOT OUT_AG.tEleStarter_Dem.Do THEN 				// Rounding for small values
			rTi_ST_Active := 0;
			rTi_ST_Cooldown := 0;
			rTi_ST_Active_zero := 0;
		END_IF;
	
		(* Calculation of remaining starting time [s] *)
		rTi_ST_Res := TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000 - rTi_ST_Active;
		iTi_ST_Res := REAL_TO_INT(rTi_ST_Res);
		
		(* Calculation of starter temperature status *)
		xGR_MINR_bSt_STT (In:= rTi_ST_Res, Gw:= 0, Hy:= LIMIT(0, TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000 * (LIMIT(0.2, Para.rST_ReqOpTiAftCooldown, 1)), MAX(0,(TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000)-1)));
		bSt_STT := NOT xGR_MINR_bSt_STT.Q;
	ELSE
		rTi_ST_Active_zero := 0;
		rTi_ST_Cooldown := 0;
		rTi_ST_Active := 0;
		rTi_ST_Res := 0;
		iTi_ST_Res := 0;
		bSt_STT := FALSE;
	END_IF;

	//note: 
	//		1.	the division by zero in the exponential calculation has been prevented using the boundaries limits decided for Para.tiST_CooldownConst
	//		2.	The upper limit of xGR_MINR_bSt_STT is used to be able to set the starter temperature status to true when Para.rST_ReqOpTiAftCooldown is 100%.
	//			In such situation, since rTi_ST_Res is never higher than TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000,  xGR_MINR_bSt_STT would never go to FALSE
	//			The cumulated starting time is forced to 0 when it´s value is < than 1s. The same trashold has been used also on the remining starting time.
	//			When rTi_ST_Res is > maximunm starting duration - 1s  the starter temperature status is set to TRUE (xGR_MINR_bSt_STT goes to false)

	(* ------------------------------------------------------------------------------------ *)
	(* Manual request for purge cranking cycle and start attempt *)
	IF xEngType.Type6 THEN
		bEng_SU_Man_Req := 		(bStart OR bEng_SU_Man_Req)
								AND		 bOMSS_Man 
								AND 	 IN_AG.bEng_Dem_Man
								AND 	(IN_AG.bEng_SU_Man OR bSt_RelAuxOff_STT)								// retain during waiting time for starter release
								AND(NOT IN_AG.bBlocDelay_ManStart OR OUT_AG.bEng_Start OR bSt_RelAuxOff_STT)
								AND     (IN_AG.bScavFinished OR NOT IN_AG.bRel_ScavN2)
								AND NOT (xR_TRIG_bSt_Purge.Q AND xCTD_Start.CV <> xCTD_Start.PV)				// reset request when the purge done and first start 
								AND NOT xF_TRIG_bSt_RelAuxOff_STT.Q												// reset request when release form starter temperature is given 
								AND NOT bStop;
	ELSE
		bEng_SU_Man_Req := FALSE;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* fast start readiness from purge status and starter temperature capability *)
	IF xEngType.Type6 THEN
		OUT_AG.bFS_Rdy_STT_StPurge := ((rTi_ST_Res >= TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000 * (LIMIT(0.2, Para.rST_ReqOpTiAftCooldown, 1))) AND bSt_Purge);		// enough starter temperature capability and purge ok
	ELSE
		OUT_AG.bFS_Rdy_STT_StPurge := FALSE;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* demand to open inlet louvers before purge cranking cycle for fast start *)
	IF xEngType.Type6 THEN
		bFS_Req	:= bOMSS_Aut AND IN_AG.bEng_Rel AND Para.bFSPreL_Act AND IN_AG.bPermPreLube_Dem;
		OUT_AG.bInLouDemAG := (bFS_Req AND OUT_AG.bPreL_FS_EngStaRel AND NOT IN_AG.bEng_Bloc) AND NOT M_DREHZ AND NOT (bSt_Purge OR bStartAtt_Run);
	ELSE
		bFS_Req := FALSE;
		OUT_AG.bInLouDemAG := FALSE;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* Purge cranking cycle *)
	IF xEngType.Type6 THEN
		// Request purge cranking cycle
		bReq_PurgeCrk := (IN_AG.bEng_Dem_Aut AND NOT M_DREHZ AND (IN_AG.bEng_SU_Aut OR (bSt_RelAuxOff_STT AND bPurgeCrk_Run)) AND NOT (bSt_Purge OR bStartAtt_Run)) OR								// request during automatic start attempt
						 (IN_AG.bEng_Dem_Man AND NOT M_DREHZ AND bEng_SU_Man_Req AND (IN_AG.bEng_SU_Man OR (bSt_RelAuxOff_STT AND bPurgeCrk_Run)) AND NOT (bSt_Purge OR bStartAtt_Run)) OR		 	// request during manual start attempt 
						 ((bFS_Req AND OUT_AG.bPreL_FS_EngStaRel AND NOT IN_AG.bEng_Bloc) AND NOT M_DREHZ AND NOT (bSt_Purge OR bStartAtt_Run) AND IN_AG.bInLouRelVE);								// request from fast start
		
		IF bReq_PurgeCrk THEN														// function activation
			bPurgeCrk_Run := TRUE;													// purge cranking cycle running
			bReq_Rel_STT_PurgeCrk := TRUE; 											// starter temperature release function requested from purge cranking cycle 
			bGV_Block_PurgeCrk := TRUE; 											// GV blocked during purge cranking cycle
			bDem_ST_PurgeCrk := NOT bSt_RelAuxOff_STT; 								// starter demand from purge cranking
			IF bSpeedMon_PurgeCrkStartAtt THEN 										// purge cranking speed monitoring 
				IF NOT bFail_StartAtt THEN
					bFail_PurgeCrk := TRUE;											// A2376 purge cranking cycle unsuccessful
				END_IF;
				bPurgeCrk_Run := FALSE;
				bReq_Rel_STT_PurgeCrk := FALSE;
				bGV_Block_PurgeCrk := FALSE;
				bDem_ST_PurgeCrk := FALSE;
			END_IF;
		ELSIF xR_TRIG_bSt_Purge.Q AND bEleStarter_Dem_PurgeCrk THEN  				// purge cranking cycle completed. 
			bSfl_PurgeCrk := TRUE;													// B9088 purge cranking cycle successful
			bPurgeCrk_Run := FALSE;
			bReq_Rel_STT_PurgeCrk := FALSE;
			//bGV_Block_PurgeCrk := FALSE;											// for one extra cycle the starter is kept on and GV blocked
			//bDem_ST_PurgeCrk := FALSE;
			IF bSpeedMon_PurgeCrkStartAtt THEN 										// purge cranking speed monitoring active also during this cycle
				bFail_PurgeCrk := TRUE;												// A2376 purge cranking cycle unsuccessful
				bSfl_PurgeCrk := FALSE;
			END_IF;
		ELSE
			bPurgeCrk_Run := FALSE;
			bReq_Rel_STT_PurgeCrk := FALSE;
			bGV_Block_PurgeCrk := FALSE;
			bDem_ST_PurgeCrk := FALSE;
			bSfl_PurgeCrk := FALSE;
		END_IF;
	
		(* messages *)
		xTP_bSfl_PurgeCrk(IN := bSfl_PurgeCrk, PT:= T#5s);
		bMsg9097_set	:= bPurgeCrk_Run AND iVol_MinAirLim_SysPurge <> 0; 				// 9097 "purge cranking cycle initiated " 
		bMsg2376_T6_set	:= bFail_PurgeCrk; 												// 2376 for T6 "Purge cranking cycle unsuccessful" 
		bMsg9088_T6_set	:= xTP_bSfl_PurgeCrk.Q AND iVol_MinAirLim_SysPurge <> 0; 		// 9088 for T6 "Purge cranking cycle successful" active for 5s
	ELSE
		bReq_PurgeCrk := FALSE;
		bSfl_PurgeCrk := FALSE;
		bPurgeCrk_Run := FALSE;
		bReq_Rel_STT_PurgeCrk := FALSE;
		bGV_Block_PurgeCrk := FALSE;
		bDem_ST_PurgeCrk := FALSE;
		bFail_PurgeCrk := FALSE;
		xTP_bSfl_PurgeCrk(IN := FALSE, PT:= T#0s);
		bMsg9097_set := FALSE;
		bMsg2376_T6_set := FALSE;
		bMsg9088_T6_set := FALSE;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* Start attempt*)
	IF xEngType.Type6 THEN
		// Request starter temperature release before engine start attempt
		xR_TRIG_bReq_Rel_STT_StartAtt(CLK := ((IN_AG.bEng_SU_Aut AND NOT M_DREHZ AND bSt_Purge AND NOT xCTD_Start.Q) OR
									 		  (IN_AG.bEng_SU_Man AND bEng_SU_Man_Req AND NOT M_DREHZ AND bSt_Purge AND NOT xCTD_Start.Q)));

		IF xR_TRIG_bReq_Rel_STT_StartAtt.Q THEN
			bRel_STT_StartAtt := FALSE;
		END_IF;
		
		bReq_StartAtt := (IN_AG.bEng_Dem_Aut AND NOT M_DREHZ AND (IN_AG.bEng_SU_Aut AND (bSt_Purge OR bStartAtt_Run)) AND bRel_STT_StartAtt AND NOT xCTD_Start.Q) OR
						 (IN_AG.bEng_Dem_Man AND NOT M_DREHZ AND bEng_SU_Man_Req AND (IN_AG.bEng_SU_Man AND (bSt_Purge OR bStartAtt_Run)) AND bRel_STT_StartAtt AND NOT xCTD_Start.Q);
	
		xR_TRIG_bReq_StartAtt(CLK := bReq_StartAtt);
		(* detect engine demanded and purge cranking cycle done *)
		IF xR_TRIG_bReq_StartAtt.Q THEN
			rTiStartAttDur := 0;
			rVol_Mx := 0;
		END_IF;
	
	
		IF bReq_StartAtt THEN
			bStartAtt_Run := TRUE;											// start attempt running
			bDem_ST_StartAtt := TRUE; 										// starter demand from start attempt
			IF OUT_AG.tEleStarter_Dem.Do THEN 
				rTiStartAttDur := rTiStartAttDur + rCycleTime;				// start attempt duration when starter demanded
			END_IF;
			IF rTiStartAttDur > 30 OR rVol_Mx >= LIMIT(100, UDINT_TO_REAL(Para.iVol_TolUnbrtMxMax), 5000) OR bSpeedMon_PurgeCrkStartAtt THEN		// start attempt duration, volume of mixture, speed monitoring
				bStartAtt_Run := FALSE;
				//bDem_ST_StartAtt := FALSE;
					IF bSpeedMon_PurgeCrkStartAtt THEN
						bDem_ST_StartAtt := FALSE;
						bFail_StartAtt := TRUE;
					END_IF;
			END_IF;
		ELSE
			bStartAtt_Run := FALSE;
			bDem_ST_StartAtt := FALSE;
		END_IF;
	
		bMsg2382_set	:= bFail_StartAtt; 									// A2382 for T6 "Start attempt failed minimum speed" 
	ELSE
		bRel_STT_StartAtt := FALSE;
		bReq_StartAtt := FALSE;
		rTiStartAttDur := 0;
		bStartAtt_Run := FALSE;
		bDem_ST_StartAtt := FALSE;
		bFail_StartAtt := FALSE;
		bMsg2382_set := FALSE;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* Waiting for starter temperature release / pause of pre-lubrication pump *)
	IF xEngType.Type6 THEN
		rTi_ST_Active_AftCooldown := LIMIT(1, TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000 * (1-(LIMIT(0.2, Para.rST_ReqOpTiAftCooldown, 1))), MAX(1, TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000)); 		// cumulated starting time after cooldown phase [s]
		
		// Detect exhaust scavenging procedure needed after purge cycle
		xF_TRIG_GVopen_bEGScavAct(CLK:= IN_AG.bGV_On AND Para.bEGScav_Active AND 
										(NOT IN_AG.bEng_Dem_EPS OR (Para.bEGScav_ifAuxV_ok AND IN_AG.tAuxV_Eng_ok.Di)));

		// Request release from starter temperature
		bReq_Rel_STT := ((xR_TRIG_bEng_Dem_Aut.Q OR (IN_AG.bEng_Dem_Aut AND bSt_RelAuxOff_STT AND NOT M_DREHZ)) OR																		// Check for starter temperature release when engine demanded in automatic and retain function till the end of it
						(bReq_Rel_STT_PurgeCrk) OR 																																		// Check for starter temperature release during purge cranking cycle
						((xR_TRIG_bReq_Rel_STT_StartAtt.Q AND NOT xF_TRIG_GVopen_bEGScavAct.Q) OR ((IN_AG.bEng_Dem_Aut OR IN_AG.bEng_Dem_Man) AND bSt_RelAuxOff_STT AND NOT M_DREHZ)));	// Check for starter temperature release before automatic or manual start attempt and retain function till the end of it
	
	
		IF bReq_Rel_STT  THEN 																								// function activation
			bRel_STT_Ena := TRUE;																							// function enabled
			IF (bSt_STT AND (NOT bSt_Purge OR (bSt_Purge AND rTi_ST_Res >= (TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000 * (LIMIT(0.2, Para.rST_ReqOpTiAftCooldown, 1))))) OR IN_AG.bEng_Dem_EPS) THEN	
				bPreLubeOff_STT := FALSE;																					// signal to stop prelubrication (when true) due to starter overheat
				bSt_RelAuxOff_STT := FALSE; 																				// signal to deactivate the starter (when true) due to starter overheat
				bRel_STT_StartAtt := TRUE;
			ELSE
				IF IN_AG.rN_EngAct = 0 THEN
					bPreLubeOff_STT := TRUE;
				END_IF;
				bSt_RelAuxOff_STT := TRUE;
				IF NOT OUT_AG.tEleStarter_Dem.Do THEN 
					rTi_ST_UntRelDur := (-((LIMIT(100, TIME_TO_REAL(Para.tiST_CooldownConst)/1000, 9000)) * LN(rTi_ST_Active_AftCooldown / LIMIT (1, rTi_ST_Active_zero, MAX(1, TIME_TO_REAL(Para.tiST_MaxDur_OverheatPrev)/1000))))) - rTi_ST_Cooldown;		// duration in seconds till the release of the starter due to temperature
				END_IF;
			END_IF;
		ELSE
			bRel_STT_Ena := FALSE;
			bPreLubeOff_STT := FALSE;
			bSt_RelAuxOff_STT := FALSE;
		END_IF;
	
		(* messages *)
		(* 9096 "Starter overheated" *)
		xTON_bSt_RelAuxOff_STT(IN:= bSt_RelAuxOff_STT, PT:= T#1s);		//1s delay before setting the message 9096. to be sure that the additional information get stored with the operating message
	
		bMsg9096_enable := bRel_STT_Ena OR xTP_bMsg9096_set_retain.Q;
		bMsg9096_set := xTON_bSt_RelAuxOff_STT.Q OR xTP_bMsg9096_set_retain.Q;
		bMsg9096_iTi_ST_UntRelDur := REAL_TO_DINT(rTi_ST_UntRelDur);

		(* "Start up failure" when starter waiting time is higher than 600s *)
		bStartErr_ST_UntRelDur_High	:= bRel_STT_Ena AND bSt_Purge AND xTON_bSt_RelAuxOff_STT.Q AND rTi_ST_UntRelDur > 600;
	
		(* retain 9096 set for 20s when start up failure is activated *)
		xTP_bMsg9096_set_retain(IN:= bStartErr_ST_UntRelDur_High, PT:= T#20s);

		(* detect when the starter temperature release is given *)
		xF_TRIG_bSt_RelAuxOff_STT(CLK := bSt_RelAuxOff_STT);
	
		(* Starter request during start attempt *)
		bEleStarter_Dem_StartAtt := bDem_ST_StartAtt; 
	
		(* Starter request during purge cranking cycle and released form strater temperature monitoring *)
		bEleStarter_Dem_PurgeCrk := bDem_ST_PurgeCrk AND NOT bSt_RelAuxOff_STT;
		
		(* Starter temperature release off for op_state and CBM *)
		OUT_AG.bSt_RelAuxOff_STT_op	:= bSt_RelAuxOff_STT;
	ELSE
		rTi_ST_Active_AftCooldown := 1;
		bReq_Rel_STT := FALSE;
		bRel_STT_Ena := FALSE;
		bPreLubeOff_STT := FALSE;
		bSt_RelAuxOff_STT := FALSE;
		bRel_STT_StartAtt := FALSE;
		rTi_ST_UntRelDur := 0;
		bMsg9096_enable := FALSE;
		bMsg9096_set := FALSE;
		bMsg9096_iTi_ST_UntRelDur := FALSE;
		bStartErr_ST_UntRelDur_High := FALSE;
		bEleStarter_Dem_StartAtt := FALSE;
		bEleStarter_Dem_PurgeCrk := FALSE;
		OUT_AG.bSt_RelAuxOff_STT_op := FALSE;
	END_IF;

	//note: 
	//		1.	To avoid problem logaritm formula:
	//			The division by zero is avoided limiting cumulated starting time to a minimum value of 1s
	//			The wanted active starting time after cool down time (rTi_ST_Active_AftCooldown) has also been lower limited to 1s to avoid that the logaritm goes to infinite when Para.rST_ReqOpTiAftCooldown is set to 100%
		
	(* ------------------------------------------------------------------------------------ *)
	(* -------------------------------------------------------------------------------------------------------------------------------------- *)

	(* delay automatic start *)
	xTON_DelayStart(IN:= IN_AG.bEng_SU_Aut AND NOT bOMSS_Man, PT:= T#0s);
	OUT_AG.bEngAutStartDelay := xTON_DelayStart.Q;

	(* manual start *)
	ZM_HSTART	:= (bStart OR ZM_HSTART)
			AND		bOMSS_Man 
			AND 	IN_AG.bEng_SU_Man 
			AND(NOT IN_AG.bBlocDelay_ManStart OR     OUT_AG.bEng_Start)
			AND    (IN_AG.bScavFinished       OR NOT IN_AG.bRel_ScavN2)
			AND NOT xTP_StarterOFF.Q
			AND NOT bStop; 

	(* delay manual start *)
	xTON_DelayManStart(IN:= ZM_HSTART AND bOMSS_Man, PT:= T#0s);
	
	(* set starter pulse ON-time *)
	IF IN_AG.bEng_SU_Man THEN		(*active only for auto starts*)
		tiStarterON_Base		:=	T#30s;  (* manual start time 30" *)
		tiStartScav				:=	T#0s;	
		tiStarterOFF			:=	T#12s;
		bCalcAdaptiveStartTime	:=	FALSE;
	ELSE
		CASE xCTD_Start.CV OF 
			3: 	tiStarterON_Base := tiStarterON1;
				tiStartScav      := tiStartScav1;
				tiStarterOFF     := tiStarterOFF1;
				IF bAdoptiveStartEnab (*xEngType.Type4 AND NOT Para.bVISA AND bDebugStartActive*) THEN	// activation for series 4 engines and marked as pilot activation bit
					bCalcAdaptiveStartTime := TRUE;
				END_IF;
			2: 	tiStarterON_Base := tiStarterON2;
				tiStartScav      := tiStartScav2;
				tiStarterOFF     := tiStarterOFF2;		
				bCalcAdaptiveStartTime := FALSE;
			1: 	tiStarterON_Base := tiStarterON3;
				tiStartScav      := tiStartScav3;
				tiStarterOFF     := tiStarterOFF3;
				bCalcAdaptiveStartTime := FALSE;
			ELSE
				tiStarterON_Base := T#20s10ms;			(*check!*)
				tiStarterOFF     := tiStarterOFF1;
				bCalcAdaptiveStartTime := FALSE;
		END_CASE;
	END_IF;

	(* ------------------------------------------------------------------------------------ *)
	(* adopt starter puls ON-time for 1st. automatic start (Type4) *)
	bDebugStartActive := (IN_AG.rN_EngAct > 60);			(*detect turning starter *)

	xRT_bDebugStartActive(CLK:= bDebugStartActive);			(*detect turning starter delay*)
	IF xRT_bDebugStartActive.Q THEN 
		bDebugStartActive_Delay := xTON_H_STRT.ET;
	END_IF;

	xTON_StarterMeas2(IN:=bDebugStartActive, PT:= T#5s);
	bDebugTON_StarterMeas2 := xTON_StarterMeas2.Q;
	
	xTP_StarterMeas(IN:= xTON_StarterMeas2.Q, PT:= T#1s);	(*timer for 1 sec start speed measurement *)
	bTriggerStarterMeas := xTP_StarterMeas.Q;
	xF_TRIG_StarterMeas(CLK := xTP_StarterMeas.Q);			(*trigger moment for calculation*)
	
	IF bCalcAdaptiveStartTime AND OUT_AG.bEng_Start THEN 
		(* measure 1 sec speed average for calculation *)
		IF xTP_StarterMeas.Q  THEN
			rN_EngStartAvg := (rN_EngStartAvg * rCnt_EngStartAvg) +  IN_AG.rN_EngAct;  	(* speed average *)
			rCnt_EngStartAvg := rCnt_EngStartAvg + 1;
			IF rCnt_EngStartAvg > 0 THEN rN_EngStartAvg := rN_EngStartAvg / rCnt_EngStartAvg ; END_IF;		
		ELSE
			rCnt_EngStartAvg := 0;
		END_IF;

		(* factor for cylinder number ADAPTIVE maximum time" *)
		LCRScal_Cylinders(x := xEngType.NumberOfCylinder , x1 := 12, y1 := 1.27, x2 := 20, y2 := 1);
		rTiFactor_Cylinders := LCRScal_Cylinders.y ; 
	
	ELSE
		ti_EngStart_Max := 	xTP_StarterON.PT ;
	END_IF;
	
	
	IF bCalcAdaptiveStartTime AND xF_TRIG_StarterMeas.Q THEN
		MM2VIS.rN_EngStart :=	rN_EngStartAvg;		(*speed, for VIS*)
		rN_EngStart :=			rN_EngStartAvg;		(*speed, for VIS*)
						
		LCRScal_N_EngStart(x := rN_EngStartAvg, x1 := 130, y1 := 1.22, x2 := 170, y2 := 1);
		rTiFactor_N_EngStart :=  LIMIT(1.0, LCRScal_N_EngStart.y, 1.22);
		
		IF xEngType.Type3 THEN
			rStarterON_Max :=  LIMIT(24000, (TIME_TO_REAL(tiStarterON_Base - tiStartScav) * rTiFactor_Cylinders * rTiFactor_N_EngStart),38000) ;	(* 1. start ADAPTIVE maximum time 24" to 38" *)
			tiStarterON_Max := REAL_TO_TIME(rStarterON_Max) + tiStartScav;
		ELSE	
			rStarterON_Max :=  LIMIT(20000, (TIME_TO_REAL(tiStarterON_Base) * rTiFactor_Cylinders * rTiFactor_N_EngStart),35000) ;	(* 1. start ADAPTIVE maximum time 20" to 35" *)
			tiStarterON_Max := REAL_TO_TIME(rStarterON_Max);
		END_IF;
						
		xTP_StarterON.PT := tiStarterON_Base ;
		IF  (tiStarterON_Max - xTON_StarterMeas2.PT - xTP_StarterMeas.PT) > T#0s THEN 
			xTP_StarterON_Extended.PT := tiStarterON_Max - xTON_StarterMeas2.PT - xTP_StarterMeas.PT - bDebugStartActive_Delay;		(* 1. start additional maximum time 22" to 35" (type 4) 24" to 38" (type 3) *)
			xTP_StarterON_Extended.IN := bCalcAdaptiveStartTime;	 (*trigger the extended start time once*)
		ELSE
			xTP_StarterON_Extended.PT := 0;	
		END_IF;
		MM2VIS.rTi_EngStart_Max := TIME_TO_REAL(tiStarterON_Max);		(*for VIS*)		//OPTIONAL 2014; no visu display
		ti_EngStart_Max := 						tiStarterON_Max ;				
	ELSE
		IF NOT xTP_StarterON_Extended.Q THEN
			xTP_StarterON_Extended.PT := 0;
		END_IF;
	END_IF;
	xTP_StarterON_Extended();				(*timer FUB call for additional start time*)
	xTP_StarterON_Extended.IN := FALSE;			
	
	IF T_H_STRT THEN  						(*limit xTP_StarterON_Extended to max start time*)
		xTP_StarterON_Extended.PT := 0;
	END_IF;

	xTP_StarterON.PT := tiStarterON_Base + xTON_ChargeOff.PT;		(*adding the charge off delay to correct the starter time Perktold 17.03.2023*);

	(* ------------------------------------------------------------------------------------ *)
	(* starter pulse ON-time *)
	T7_TEMP1 := (IN_AG.bEng_Dem_EPS AND NOT IN_AG.bOnly_Island) OR OUT_AG.bEngAutStartDelay;

	IF NOT IN_AG.bEng_Dem_EPS AND NOT ZM_HSTART AND NOT IN_AG.bEng_SU_Aut THEN (* reset timer *)
		xTP_StarterON(IN:= FALSE, PT:= T#0s);
	ELSIF IN_AG.bEng_SU_Man THEN
		xTP_StarterON(IN:= xTON_DelayManStart.Q AND NOT xTP_StarterOFF.Q);	
	ELSIF IN_AG.bEng_SU_Aut THEN
		xTP_StarterON(IN:= T7_TEMP1             AND NOT xTP_StarterOFF.Q);	
	ELSE
		xTP_StarterON(IN:= FALSE, PT:= T#0s);
	END_IF;
	bTP_StarterON := xTP_StarterON.Q 
				OR	(xTP_StarterON_Extended.Q AND bCalcAdaptiveStartTime AND bAdoptiveStartEnab) ;  (*NEW 2014*)

	(* starter puls OFF-time *)	
	xTP_StarterOFF(IN:= NOT bTP_StarterON, PT:= tiStarterOFF); 		

	
	(* ------------------------------------------------------------------------------------ *)
	//monitoring start ton_RESET_4 time for starter cool down = same time as for OUT_AG.bLockAckStarter
	xR_TRIG_Reset1(CLK:= IN_AG.tEng_Run.Do);
	xR_TRIG_Reset2(CLK:= IN_AG.bEng_Dem_Man_SUpF);
	xR_TRIG_Reset3(CLK:= IN_AG.bEng_Dem_Aut_SUpF);

	(* start counter reset after long pause between start attempts in manual mode *)
	xTON_Reset4(IN := NOT OUT_AG.bEng_Start AND IN_AG.bEng_SU_Man, PT:= T#300s);	(* serie *)		
	xR_TRIG_Reset4(CLK:= xTON_Reset4.Q);
	
	RESET := xR_TRIG_Reset1.Q OR xR_TRIG_Reset2.Q OR xR_TRIG_Reset3.Q OR xR_TRIG_Reset4.Q;


	(*---------------------------------------------------------------------------------------------*)
	xF_TRIG_Start(CLK:= (bTP_StarterON AND NOT xEngType.Type6) OR (bStartAtt_Run AND xEngType.Type6));

	(* start counter *)										
	xCTD_Start(CD:= xF_TRIG_Start.Q, LOAD:= RESET, PV:= 3);	//serie, xF_TRIG_Start war xR_TRIG_Start ?
	OUT_AG.iStartCount	:= LIMIT(1, xCTD_Start.PV - xCTD_Start.CV + 1, xCTD_Start.PV);  //Number of Start for OpState
	
	(* man + auto start error *)
	xTON_StartErr(IN:= xCTD_Start.Q AND NOT M_DREHZ AND(IN_AG.bEng_Dem_Aut_SUpF OR IN_AG.bEng_Dem_Man_SUpF) AND (bSt_Purge OR NOT xEngType.Type6), PT:= T#12s); (* delay = min.starter off interval time *)
	bStartErr := xTON_StartErr.Q;

	
	(*---------------------------------------------------------------------------------------------*)
	//blocking acknowledgement by starter temperature (op.message 3300)
	IF (xEngType.Type3 OR xEngType.Type4 OR xEngType.Type2) THEN
		xR_TRIG_AutoStartErr(CLK:= bStartErr);	
		xTOF_LockAckStarter(IN:= xR_TRIG_AutoStartErr.Q, PT:= T#5m);
		IF IN_AG.bEng_Dem_EPS THEN
			xTOF_LockAckStarter(IN:= FALSE, PT:= T#0m);
		END_IF;	
		OUT_AG.bLockAckStarter := xTOF_LockAckStarter.Q;	
	ELSIF (xEngType.Type6) THEN
		OUT_AG.bLockAckStarter := FALSE;	
	END_IF;

	
	(*---------------------------------------------------------------------------------------------*)
	(* start *)
	ZM_STRT   := IN_AG.bEng_Rel AND NOT M_DREHZ AND OUT_AG.bRelEngOp_Aux;
	
	IF xEngType.Type2 OR xEngType.Type3 OR xEngType.Type4 THEN
//		M_STRT_TEMP1 := NOT IN_AG.bBlocDelay_ManStart OR OUT_AG.bEng_Start;

		(* start release from EG scavening *)
//		M_STRT_TEMP2 := IN_AG.bScavFinished OR NOT IN_AG.bRel_ScavN2;

		(* manual start *)
		M_STRT_TEMP3 := ZM_STRT AND bTP_StarterON AND ZM_HSTART AND NOT T_H_STRT ;

		(* automatic start *)
		M_STRT_TEMP4 := ZM_STRT AND bTP_StarterON AND (OUT_AG.bEngAutStartDelay OR IN_AG.bEng_Dem_EPS) AND NOT T_H_STRT ;	(*neu: max mit T_H_STRT*)

		(* start demand from N2_scavenging *)
		M_STRT_TEMP6 := IN_AG.bN2_ScavCoStarterOn AND NOT M_DREHZ AND IN_AG.bRel_ScavN2;	

		(* start demand from ignition selftest *)
		M_STRT_TEMP7 := IN_AG.b_ST_DemIgn         AND NOT M_DREHZ;
		
		bChargeOff_EngStart			:=	M_STRT_TEMP3 	(* man  start *)
									OR	M_STRT_TEMP4	(* auto start *)
									OR	M_STRT_TEMP6	(* N2_scavenging *)
									OR	M_STRT_TEMP7;	(* ignition selftest *)
		OUT_AG.tChargeOff_Dem.Do	:=	bChargeOff_EngStart OR bStarterBat_Disconnect;
		
		// Delay start relay after switching off battery charge
		xTON_ChargeOff(IN := bChargeOff_EngStart, PT := T#300ms);

		OUT_AG.bEng_Start         := xTON_ChargeOff.Q;

		xRT_EngStart(CLK:= OUT_AG.bEng_Start);						(* begin of start *)
		xFT_EngStart(CLK:= OUT_AG.bEng_Start);						(* end of start *)
		IF xRT_EngStart.Q AND b_EleStarter_EngageFail THEN
			b_EleStarter_EngageFail	:= FALSE;
			bEleStarterFail_Num[1]	:= FALSE;
			bEleStarterFail_Num[2]	:= FALSE;
			bEleStarterFail_Num[3]	:= FALSE;
		END_IF;

		OUT_AG.tEleStarter_Dem.Do := xTON_ChargeOff.Q AND NOT STP_STRT AND NOT b_EleStarter_EngageFail;

	ELSIF xEngType.Type6 THEN
		xTON_Nospeed15s(IN := IN_AG.rN_EngAct = 0.0, PT:= T#15s);			
		bRel_Nospeed := (xTON_Nospeed15s.Q OR OUT_AG.bEng_Start);

		M_STRT_TEMP4 := (bEleStarter_Dem_PurgeCrk OR bEleStarter_Dem_StartAtt) AND (bRel_Nospeed);
		M_STRT_TEMP5 := M_STRT_TEMP4 AND (ZM_STRT OR OUT_AG.bPreL_FS_EngStaRel); 									// during purge while fast start preparation the aux release for engine operation won´t be there, used permanent prelubrication feedback
		M_STRT_TEMP6 := IN_AG.bN2_ScavCoStarterOn AND NOT M_DREHZ AND IN_AG.bRel_ScavN2;
		M_STRT_TEMP7 := IN_AG.b_ST_DemIgn AND NOT M_DREHZ;

		bChargeOff_EngStart			:= M_STRT_TEMP5 OR M_STRT_TEMP6 OR M_STRT_TEMP7;

		OUT_AG.tChargeOff_Dem.Do	:= bChargeOff_EngStart OR bStarterBat_Disconnect;			
		
		// Delay start relay after switching off battery charge
		xTON_ChargeOff(IN := bChargeOff_EngStart, PT:= T#300ms);
		
		OUT_AG.bEng_Start         := xTON_ChargeOff.Q;

		xRT_EngStart(CLK:= OUT_AG.bEng_Start);						(* begin of start *)
		xFT_EngStart(CLK:= OUT_AG.bEng_Start);						(* end of start *)
		IF xRT_EngStart.Q AND b_EleStarter_EngageFail THEN
			b_EleStarter_EngageFail := FALSE;
			bEleStarterFail_Num[1]	:= FALSE;
			bEleStarterFail_Num[2]	:= FALSE;
			bEleStarterFail_Num[3]	:= FALSE;
		END_IF;

		OUT_AG.tEleStarter_Dem.Do := xTON_ChargeOff.Q AND NOT STP_STRT AND NOT b_EleStarter_EngageFail;

		(* starter demand during purge cranking cycle *)
		OUT_AG.bEleStarter_Dem_PurgeCrkCyl := OUT_AG.tEleStarter_Dem.Do AND bEleStarter_Dem_PurgeCrk;

		(* starer demanded during purge cranking cycle for fast start preparation *)
		IF OUT_AG.tEleStarter_Dem.Do AND bEleStarter_Dem_PurgeCrk AND bFS_Req AND NOT IN_AG.bEng_Dem THEN
			OUT_AG.bEleStarter_Dem_PurgeCrkCylFS := TRUE;
		ELSIF OUT_AG.bEleStarter_Dem_PurgeCrkCylFS AND (IN_AG.rN_EngAct = 0.0 OR IN_AG.bEng_Dem) THEN
			OUT_AG.bEleStarter_Dem_PurgeCrkCylFS := FALSE;
		END_IF;
	END_IF;	

	// Starter/s correct engagement monitoring 
	xTON_EleStarter_Mon	(IN := OUT_AG.tEleStarter_Dem.Do, PT := Para.tiStarterFunDuration);			(* starter/s correct engagement monitoring trigger *)
	xTP_EleStarter_Mon	(IN	:= xTON_EleStarter_Mon.Q, PT:= T#300ms);								(* 300ms timer for voltage measurement *)
	xFT_EleStarter_Mon	(CLK:= xTP_EleStarter_Mon.Q);												(* correct engagement monitoring evaluation instant *)

	IF OUT_AG.tEleStarter_Dem.Do AND xTP_EleStarter_Mon.Q THEN 
		rU_EleStarterAvg1 := (rU_EleStarterAvg1 * rCnt_EleStarterAvg) +  IN_AG.tU_Starter_engage1.Ai;
		rU_EleStarterAvg2 := (rU_EleStarterAvg2 * rCnt_EleStarterAvg) +  IN_AG.tU_Starter_engage2.Ai;
		rU_EleStarterAvg3 := (rU_EleStarterAvg3 * rCnt_EleStarterAvg) +  IN_AG.tU_Starter_engage3.Ai;

		rCnt_EleStarterAvg := rCnt_EleStarterAvg + 1;

		IF rCnt_EleStarterAvg > 0 THEN 
			rU_EleStarterAvg1 := rU_EleStarterAvg1 / rCnt_EleStarterAvg;    (* starter 1 terminal 45 average voltage *)
			rU_EleStarterAvg2 := rU_EleStarterAvg2 / rCnt_EleStarterAvg;  	(* starter 2 terminal 45 average voltage *)
			rU_EleStarterAvg3 := rU_EleStarterAvg3 / rCnt_EleStarterAvg;   	(* starter 3 terminal 45 average voltage *)
		END_IF;		
	ELSE
		rCnt_EleStarterAvg := 0;
	END_IF;

	IF Para.rU_StarterMon_LimLo <> 0 THEN 																								(* active monitoring if parameter different than zero *)
		IF xFT_EleStarter_Mon.Q AND OUT_AG.tEleStarter_Dem.Do THEN 																		(* measurement completed and starter demand still ON *)
			IF (IN_AG.tU_Starter_engage1.GoodQual AND NOT MM2VIS.bMsg2377 AND rU_EleStarterAvg1 < Para.rU_StarterMon_LimLo) THEN		(* average voltage too low *)
				b_EleStarter_EngageFail	:= TRUE;																						(* starter motor did not engage*)
				bEleStarterFail_Num[1]	:= TRUE;
			END_IF;
			IF (IN_AG.tU_Starter_engage2.GoodQual AND NOT MM2VIS.bMsg2378 AND rU_EleStarterAvg2 < Para.rU_StarterMon_LimLo) THEN
				b_EleStarter_EngageFail := TRUE;
				bEleStarterFail_Num[2]	:= TRUE;
			END_IF;
			IF (IN_AG.tU_Starter_engage3.GoodQual AND NOT MM2VIS.bMsg2379 AND rU_EleStarterAvg3 < Para.rU_StarterMon_LimLo) THEN
				b_EleStarter_EngageFail := TRUE;
				bEleStarterFail_Num[3]	:= TRUE;
			END_IF;
		END_IF; 
	ELSE
		b_EleStarter_EngageFail	:= FALSE;
		bEleStarterFail_Num[1]	:= FALSE;
		bEleStarterFail_Num[2]	:= FALSE;
		bEleStarterFail_Num[3]	:= FALSE; 	
	END_IF;
	
	// trip starter if tooth to tooth
	xTON_ZAZ(IN := OUT_AG.bEng_Start AND (IN_AG.rN_EngAct < Para.rN_StarterMonTtT_LimLo), PT := Para.tiStarterMonDuration);
	STP_STRT    := xTON_ZAZ.Q;
	
	(* Speed monioring during purge cranking cycle and start attempt *)
	xGR_MAXR_SpeedMon(In := IN_AG.rN_EngAct, Gw:= 62.0, Hy := 2.0);	// detect speed drop below 60 rpm
	xF_TRIG_SpeedMon(CLK:= xGR_MAXR_SpeedMon.Q);

	IF xEngType.Type6 THEN
		bSpeedMon_PurgeCrkStartAtt :=	((OUT_AG.bEng_Start AND (bEleStarter_Dem_PurgeCrk OR bEleStarter_Dem_StartAtt)) AND 		// engine start and purge cranking or start attempt running
										(xTON_ZAZ.Q OR 							// tooth to tooth detection
										xF_TRIG_SpeedMon.Q) OR					// speed drops below 60rpm
										bFail_PurgeCrk OR bFail_StartAtt); 		// retain when failed purge cycle or start attempt
	ELSE
		bSpeedMon_PurgeCrkStartAtt := FALSE;
	END_IF;

	(*---------------------------------------------------------------------------------------------*)
	(* maximum start time *)
	IF xEngType.Type2 THEN
		xTON_H_STRT(IN:= OUT_AG.bEng_Start, PT:= T#30s);
	ELSIF xEngType.Type3 THEN
		IF xEngType.NumberOfCylinder = 12 THEN
			xTON_H_STRT(IN:= OUT_AG.bEng_Start, PT:= T#48s);	
		ELSIF xEngType.NumberOfCylinder = 16 THEN
			xTON_H_STRT(IN:= OUT_AG.bEng_Start, PT:= T#44s);
		ELSIF xEngType.NumberOfCylinder = 20 THEN
			xTON_H_STRT(IN:= OUT_AG.bEng_Start, PT:= T#40s);
		ELSE
			xTON_H_STRT(IN:= OUT_AG.bEng_Start, PT:= T#40s);	
		END_IF;
	ELSIF xEngType.Type4 THEN
		xTON_H_STRT(IN:= OUT_AG.bEng_Start, PT:= T#35s);
	ELSIF xEngType.Type6 THEN
		xTON_H_STRT(IN:= OUT_AG.bEng_Start, PT:= T#30s);
	END_IF;
	T_H_STRT := xTON_H_STRT.Q;	


	(*---------------------------------------------------------------------------------------------*)
	(* start scavenging time with ignition on (only type 3 and 6)*)	
	IF xEngType.Type3 OR xEngType.Type6 THEN 		
		OUT_AG.bRel_IgnOn := OUT_AG.bEng_Start;
	ELSE
		xTON_StartScav(IN:= OUT_AG.bEng_Start, PT:= tiStartScav); 
		OUT_AG.bRel_IgnOn := xTON_StartScav.Q;	
	END_IF;

	(* set skip fire order for all cylinders while purging *)
	// detect starter demand off after purge cranking cycle 
	xF_TRIG_bEleStarter_DemOffPurge(CLK:= bEleStarter_Dem_PurgeCrk);
	IF xEngType.Type6 AND (xF_TRIG_bEleStarter_DemOffPurge.Q AND NOT OUT_AG.tEleStarter_Dem.Do) AND OUT_AG.bMissfCyl_PurgeCrk THEN
		bMissfCyl_AftPurgeCrk := TRUE;
	END_IF;
	IF bMissfCyl_AftPurgeCrk AND IN_AG.rN_EngAct = 0.0 THEN
		bMissfCyl_AftPurgeCrk := FALSE;
	END_IF;

	IF xEngType.Type6 AND ((OUT_AG.bEng_Start AND bEleStarter_Dem_PurgeCrk) OR bMissfCyl_AftPurgeCrk) THEN
		OUT_AG.iMissfCyl_PurgeCrk := xEngType.MisfireOrder[xEngType.NumberOfCylinder];						// switch off all cylinders
		OUT_AG.bMissfCyl_PurgeCrk := TRUE;
	ELSE
		OUT_AG.iMissfCyl_PurgeCrk := 0;
		OUT_AG.bMissfCyl_PurgeCrk := FALSE;
	END_IF;

	(*---------------------------------------------------------------------------------------------*)
	(* Start scavenging monitoring pt.1*)
	xRT_EngRun(CLK:= IN_AG.rN_EngAct > Para.rN_EngStart_LimHiHi);				(* engine running *)
	
	IF xRT_EngRun.Q AND bStartScavBgn THEN
		bStartScavBgn 			:= FALSE;										(* scavenging at the beginning of the starting procedure trigger reset *)
	END_IF;
	IF xRT_EngRun.Q AND bStartScavBgnFroce THEN 
		bStartScavBgnFroce 		:= FALSE;										(* forced anticipated scavenging reset *)
	END_IF;

	IF xRT_EngStart.Q AND (bStartScavFail OR bStartScavBgnFroce) THEN 
		bStartScavBgn 			:= TRUE;										(* scavenging at the beginning of the starting procedure activation *)
		bStartScavBgnFroce 		:= FALSE; 										(* forced anticipated scavenging variable reset *)
	END_IF;
	
	IF (xRT_EngStart.Q AND (M_STRT_TEMP3 OR M_STRT_TEMP4 OR M_STRT_TEMP5) AND NOT bStartScavBgn) THEN 	(* auto or manual starting procedure begins with gas valve open*)
		bStartScavBgnFroce 		:= TRUE; 																(* forced anticipated scavenging set*)
	END_IF;

	(*---------------------------------------------------------------------------------------------*)
	(* start scavenging time with blocked gas valves only during automatic or manual mode *)	
	xTON_PostStartScav	(IN:= OUT_AG.bEng_Start, PT:= MAX(xTP_StarterON.PT, xTP_StarterON_Extended.PT + xTON_StarterMeas2.PT + xTP_StarterMeas.PT + bDebugStartActive_Delay) - tiStartScav);	(* GV blocked at the end of starting procedure *)
	xTP_PreStartScav	(IN:= OUT_AG.bEng_Start, PT:= tiStartScav);																																(* GV blocked at the beginning of the starting procedure *)

	IF (NOT xEngType.Type6) AND (M_STRT_TEMP3 OR M_STRT_TEMP4 OR M_STRT_TEMP5) THEN 		(* automatic or manual start procedure *)
		IF	xEngType.Type3 AND NOT bStartScavBgn THEN 
			OUT_AG.bGV_Start_ScaveBlock := xTON_PostStartScav.Q; 
		ELSIF xEngType.Type3 AND bStartScavBgn THEN
			OUT_AG.bGV_Start_ScaveBlock := xTP_PreStartScav.Q;
		ELSE
			OUT_AG.bGV_Start_ScaveBlock := xTP_PreStartScav.Q AND NOT bCalcAdaptiveStartTime;
		END_IF;
	ELSIF xEngType.Type6 THEN
		OUT_AG.bGV_Start_ScaveBlock := bGV_Block_PurgeCrk;
	ELSE
		OUT_AG.bGV_Start_ScaveBlock := FALSE; 
	END_IF;

	(*---------------------------------------------------------------------------------------------*)
	(* Scavenging monitoring pt.2*)
	xR_TRIG_StartScav(CLK := OUT_AG.bEng_Start AND OUT_AG.bGV_Start_ScaveBlock); 	(* beginning of auto or manual start scavenging procedure *)
	xF_TRIG_StartScav(CLK := OUT_AG.bEng_Start AND OUT_AG.bGV_Start_ScaveBlock); 	(* end of auto or manual start scavenging procedure *)
	
	IF xR_TRIG_StartScav.Q THEN 
		bStartScavFail		:= FALSE;												(* scavenging procedure status reset *)
		bStartScavSflMsg	:= FALSE;												(* scavenging procedure failure detection reset *)
		bIgn_Run_CAN_Ok		:= FALSE;												(* ignition system running during scavenging ok reset *)
		bStartScavCmpl		:= FALSE;												(* 10 sec scavenging completed reset *)
	END_IF;
	
	IF xR_TRIG_StartScav.Q AND bStartScavBgnFroce THEN
		bStartScavBgnFroce := FALSE;												(* forced anticipated scavenging reset *)
	END_IF; 

	IF OUT_AG.bEng_Start AND OUT_AG.bGV_Start_ScaveBlock THEN 						(* average speed during auto or manual start scavenging procedure *)
		rN_EngStartScavAvg := (rN_EngStartScavAvg * rCnt_EngStartScavAvg) + IN_AG.rN_EngAct;
		rCnt_EngStartScavAvg := rCnt_EngStartScavAvg + 1;
		IF rCnt_EngStartScavAvg = 95 THEN
			bStartScavCmpl := TRUE;													(* 10 sec scavenging completed *)
		END_IF;
		IF rCnt_EngStartScavAvg > 0 THEN rN_EngStartScavAvg := rN_EngStartScavAvg / rCnt_EngStartScavAvg ; END_IF;		
	ELSE
		rCnt_EngStartScavAvg := 0;
	END_IF;
	
	xTON_Ign_Run_CAN(IN:= OUT_AG.bEng_Start AND OUT_AG.bGV_Start_ScaveBlock AND IN_AG.bIgn_Run_CAN, PT:= T#3s);
	IF OUT_AG.bEng_Start AND OUT_AG.bGV_Start_ScaveBlock THEN
		IF xTON_Ign_Run_CAN.Q THEN
			bIgn_Run_CAN_Ok := TRUE;												(* ignition system running during scavenging for at least 3s *)
		END_IF;
	END_IF;

	IF (xF_TRIG_StartScav.Q AND ((NOT bIgn_Run_CAN_Ok) OR							(* check at the end of auto or manual start scavenging procedure for ignition failure *)			
	   (IN_AG.rN_EngAct > Para.rN_EngStart_LimHi) OR								(* or engine starting during scavenging *)
	   (rN_EngStartScavAvg < Para.rN_EngStartMon_LimHi) OR							(* or insufficient average speed reached at the end of scavenging *)
		NOT bStartScavCmpl)) THEN													(* or 10 sec scavenging not completed *)	
		bStartScavFail := TRUE;														(* scavenging procedure failure *)
	END_IF;

	IF xEngType.Type3 AND xF_TRIG_StartScav.Q AND NOT bStartScavFail THEN			(* scavenging by starting system successful B9088 *)
		bStartScavSflMsg 	:= TRUE;
	END_IF;
	
	IF xEngType.Type3 AND bStartScavBgn AND bStartScavFail THEN						(* unsuccessful scavenging by starting system A2376 *)
		bStartScavUnsfl		:= TRUE;  
	END_IF;

	(*---------------------------------------------------------------------------------------------*)
	(* start time  statistics *)
	usStatus_gettime	:= RTC_gettime(ADR(tGetTime));			(* FuB aktuelle Zeit einlesen *)

	IF xRT_EngStart.Q THEN
		tiStartTime := tGetTime;
	END_IF;
	
	IF xF_TRIG_StarterMeas.Q THEN								(* Start speed measurement done *)	
		Perm.tStartStat[Perm.StatCnt].tiStarterON_Max :=	ti_EngStart_Max;
		Perm.tStartStat[Perm.StatCnt].tiStartScav :=		tiStartScav;
		Perm.tStartStat[Perm.StatCnt].rN_EngStart :=		rN_EngStart;			
	END_IF;
	
	IF xFT_EngStart.Q THEN
		Perm.tStartStat[Perm.StatCnt].tiStartTime := 		tGetTime;
			
		Perm.tStartStat[Perm.StatCnt].tiStartDuration := UDINT_TO_TIME((USINT_TO_UDINT(tGetTime.hour)*3600000 + tGetTime.minute * 60000 + tGetTime.second * 1000 + tGetTime.millisec) 
		- (tiStartTime.hour*3600000 + tiStartTime.minute*60000 + tiStartTime.second*1000 + tiStartTime.millisec));	(* actual used time to start *)
		MM2VIS.rTi_EngStart_Duration := TIME_TO_REAL(Perm.tStartStat[Perm.StatCnt].tiStartDuration) ;

		IF IN_AG.iCnt_Starts > 0 THEN 
			Perm.tStartStat[Perm.StatCnt].iStartID :=		IN_AG.iCnt_Starts;									(* BENÖTIGT ZUSÄTZLICHES MODULINTERFACE! *)	
		ELSE
			Perm.tStartStat[Perm.StatCnt].iStartID := 		(Perm.StatCnt + REAL_TO_DINT(Perm.rAG_PermValue1));	(*=Backuplösung bei fehlender Modulinterfaceerweiterung: in PermValue1 einmalig den korr. Startzählerstand eingeben *)
		END_IF;
		Perm.tStartStat[Perm.StatCnt].bStartSuccess :=		(IN_AG.rN_EngAct > (rN_EngStart * 1.1));	(* simplified condition to detect start ok -> TO VERIFY on pilot engines! *)
		Perm.tStartStat[Perm.StatCnt].tiStarterOFF :=		tiStarterOFF;		
		Perm.StatCnt := 	Perm.StatCnt +1;
		IF Perm.StatCnt > 200 THEN Perm.StatCnt := 0; END_IF;	

		MM2VIS.rTi_EngStart_Delay := TIME_TO_REAL(tiStarterOFF);
	END_IF;
	
	
	(*---------------------------------------------------------------------------------------------*)
	(* demand mains start device *) 
	OUT_AG.tMainsStartDevDem.Do := IN_AG.bEng_Dem AND NOT IN_AG.tEng_Run.Do;
	
END_PROGRAM

