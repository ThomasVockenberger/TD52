(*******************************************************************************
reset			general reset alarms	
				definition remote reset capability for each individual alarm (according TI 1100-0111)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V0.1	19-06-2009	Brindlinger, new
V3.10.0	12.01.2010	lettenb.	corr.for version 3.10.0
		15.02.2010	lettenb.	DO_W_QUITT, DO_A_QUITT added from task: pb8
		02.03.2010	lettenb.	extended remote reset command with T_FQUITT (was M_FQUITT)
								(needed for reset exhaust temp.alarms generated from task: exhaust)
V3.20.0	24.03.2010	lettenb.	amm numbers br9 (2201-2300) added
		21.05.2010				reset_alarm[1022,1056]: QUITT2_RUHE added
		27.05.2010				AMM test mode added, dianeblau software parts removed
		14.10.2010				NumAmmTest limited, loops reduced to 3999
V3.99.0	06.03.2013	lettenb.	adaption for pilot engine 6	
								AB2MM.bResetRiskClass. added
V4.00.0 04.06.2014	lettenb.	write on VIS2MM.iNumAlarmTest removed(asynchr.running VIS do not change input field value!)
								(in case of illegal alarm nr.: alarm nr will NOT be changed, timer will NOT be started/=diff.to XT3)
		17.06.2014	lettenb.	iNumAlarmTestRun: set to 0 after alarmtest
V4.00.1 04.06.2014	lettenb.	bRemResMem: logic corr., rem.reset counter(5 resets)
V4.00.2 16.02.2015				warm-/cold restart message generation moved to MsgAB
V4.03.0 16.02.2015				protection test (gridcode III) schutzprüfung added
V4.04.0 03.11.2016				IN_AB.bResetRemBus added, prepared for future(wasserer-rosenheim)
		16.11.2016				bResetTrip: xTP_RemResCmd.Q removed, bugfix(reset all risk classes)
V4.05.1 07.03.2018	lettenb.	xR_TRIG_Run: bRun -> IN_AB.tPB2MM.bSys_Run, to avoid 1056 at PLC startup, bugfix
		21.03.2018				protection test mode: passlevel 30->15, request thaler
V4.07.1	24.06.2019	Schmid		valid alarm number space for alarm test/bypass increased from 3999 to 9999 
V4.08.0	24.10.2019	Schmid		test bit for dry test bench added
V4.13.0	04.12.2023	Bencze		Risk Class 10 for remote reset of safety trips
		13.12.2023	Perktold	added A2374 as safety trip without remote reset
V4.14.0	16.12.2024	Maran		bugfix: reset of temporary alarm bypass when the Service button is switched off from HMI (issue #1621)
					   		
Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(*-----------------------------------------------------------------------------------------*)
	bResetLocVis			:=	VIS2MM.bResetLocVis;			(* local  reset from VIS  *)(* vis-button: 0>1 in moment of button release! *)
	bResetRemVis			:=	VIS2MM.bResetRemVis;			(* remote reset from VIS  *)(* vis-button: 0>1 in moment of button release! *)
	xF_TRIG_ResetRemExt(CLK	:=  IN_AB.tResetRemoteExt.Di		(* remote reset from DI   *)(* falling trigger according TÜV requirement *)
						    OR  IN_AB.bResetRemBus);			(* remote reset from fieldbus *)
	bResetRemExt			:=	xF_TRIG_ResetRemExt.Q;			(* falling trigger according TÜV requirement *)

	IF VIS2MM.bResetLocVis THEN VIS2MM.bResetLocVis := FALSE; END_IF;	(* reset vis data point  *)
	IF VIS2MM.bResetRemVis THEN VIS2MM.bResetRemVis := FALSE; END_IF;	(* reset vis data point *)


	(*-----------------------------------------------------------------------------------------*)
	QUITT		:=	bResetLocVis;								(* local  reset from VIS  *)
	VIS_FQUITT	:=	bResetRemVis;								(* remote reset from VIS *)
	E_FQUITT	:=	bResetRemExt;								(* remote reset from DI  *)


	(* remote reset ---------------------------------------------------------------------------*)
	bRemResIn	:= (E_FQUITT 	AND Para.bResetRemActive)		(* remote reset from DI  *)
				OR (VIS_FQUITT	AND Para.bResetRemActive);		(* remote reset from VIS *)

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	
	(* If one of these alarms is ON, Remote Reset is deactivated *)
	IF OUT_AB.iMsg[1017]>0 OR		(* A1017 oil pressure low *) 
		OUT_AB.iMsg[1019]>0 OR		(* A1019 engine cooling water pressure low *) 
		OUT_AB.iMsg[1022]>0 OR		(* A1022 overspeed (relay) *)
		OUT_AB.iMsg[1026]>0 OR		(* A1026 shutdown failure *)
		OUT_AB.iMsg[1038]>0 OR		(* A1038 Generator reverse power *)
		OUT_AB.iMsg[1047]>0 OR		(* A1047: Misfiring failure *)
		(xEngType.Type6 AND OUT_AB.iMsg[1048]>0) OR		(* A1048 Knocking failure KLS90 *)
		OUT_AB.iMsg[1092]>0 OR		(* A1092 exhaust gas scavenging valve failure *)
		OUT_AB.iMsg[1131]>0 OR		(*  prepared spare - risk class 10 and this is only for trips 1,2 or 3. Remote reset is deactivated *)			
		OUT_AB.iMsg[2295]>0 OR		(* A2295 engine room ventilation failure inlet air *)
		OUT_AB.iMsg[2296]>0 OR		(* A2296 engine room ventilation failure outlet air *)
		OUT_AB.iMsg[2315]>0 OR		(* A2315 air temperature before exhaust gas scavening valve maximum *)
		OUT_AB.iMsg[2337]>0 OR		(* A2337 temperature high exhaust gas pressure relief valve 1 *)
		OUT_AB.iMsg[2338]>0 OR		(* A2338 temperature high exhaust gas pressure relief valve 2 *)
		OUT_AB.iMsg[2374]>0	OR		(* A2374 Bursting disc triggered *)
		OUT_AB.iMsg[3330]>0 OR 		(* A3330 SAFI hardware failure *)	
		OUT_AB.iMsg[3336]>0	OR		(* A3336 SAFI trigger signal missing *)
		OUT_AB.iMsg[3337]>0 OR		(* A3337 SAFI CAM / RESET pickup signal missing *)		
		(xEngType.Type6 AND OUT_AB.iMsg[3339]>0) OR		(* A3339 Knocking failure *)
		(xEngType.Type6 AND OUT_AB.iMsg[3342]>0) OR		(* A3342 Knock sensor measuring sensor failure *)
		OUT_AB.iMsg[3343]>0 OR		(* A3343 ignition hardware failure *)
		OUT_AB.iMsg[3366]>0			(* A3366 exhaust gas scavenging fan failure *)
	THEN			
		bRemResIn := FALSE;
                bRemResWarning := TRUE;
	END_IF;	
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	bRemResMem	:=	bRemResIn									(* remote reset memory,  unlock after: *)
				OR (bRemResMem 	AND NOT ton_FQ_timeout.Q		(* 6 h             					or *) 
								AND NOT ton_oper.Q 				(* 1 h operation with closed GCB 	or *)
								AND(NOT bResetWarning OR bOMSS_MAT));(* local reset					       *)

	ton_oper(IN:= bRemResMem AND IN_AB.tGCB_On.Di AND IN_AB.tEng_Run.Do, PT:= T#1h);	(* reset after 1h load operation *)
	ton_FQ_timeout(IN:= bRemResMem, PT:=T#6h);											(* reset after 6h *)

	xR_TRIG_CD(CLK:=     bRemResIn);
	xR_TRIG_LD(CLK:= NOT bRemResMem);

	xTP_RemResCmd(IN:=  bRemResIn AND NOT xCTD_RRC.Q, PT:= T#1s);
	bRemResCmd := xTP_RemResCmd.Q;								(* remote reset command *)

	xCTD_RRC(CD:= xR_TRIG_CD.Q, LOAD:= xR_TRIG_LD.Q, PV:= 5);	(* count 5 avail.remote reset commands within 6h *)
	
	IF xCTD_RRC.CV=0 THEN	bRemResWarning := TRUE;				(* reached the available 5 remote reset within 1h/6h *)
	END_IF;
	(* if remote reset risk class lower than 0, the risk level is limited to 0 *)
	(* if remote reset risk class higher than 4, the risk level is limited to 4 *)
	IF Para.iResetRemRiskClass < 0 THEN Para.iResetRemRiskClass := 0;
	ELSIF Para.iResetRemRiskClass > 4 THEN Para.iResetRemRiskClass := 4;
	END_IF;
	
	(*-----------------------------------------------------------------------------------------*)
	xTP_Reset(IN:= QUITT OR E_QUITT, PT:= T#100ms);
	IF bDryTB_AB THEN
		xTP_DryTB_AB(IN:= bDryTB_AB, PT:= T#8h);
	ELSE
		xTP_DryTB_AB(IN:= FALSE, PT:= T#0s);
	END_IF;

	bResetWarning	:=	xTP_Reset.Q;
	bResetTrip		:=	bResetWarning AND (NOT bOMSS_MAT OR xTP_DryTB_AB.Q);

	(* remote reset commands *)	
	CASE Para.iResetRemRiskClass OF
		0:	bResetRiskClass0 :=	bRemResCmd;
		1:	bResetRiskClass1 :=	bRemResCmd;
		2:	bResetRiskClass2 :=	bRemResCmd;
		3:	bResetRiskClass3 :=	bRemResCmd;
		4:	bResetRiskClass4 :=	bRemResCmd;
	END_CASE;
	
	(*-----------------------------------------------------------------------------------------*)
	(* monitoring on pulse (safety loop) *)  
                                                        (* falling trigger according TÜV requirement *)
	xR_TRIG_Run(CLK:= IN_AB.tPB2MM.bSys_Run);			(* EN ISO 13849-1 / 5.2.2, = reset after push button release) *)
	xTP_MonOn(IN:= (xR_TRIG_Run.Q AND     IN_AB.tGCB_RUC.Do) 
			    OR (QUITT         AND NOT IN_AB.tSafetyLoop_Eng.Di AND NOT bN_EngStart AND (NOT bOMSS_MAT OR xTP_DryTB_AB.Q)), PT:= T#1s);

	OUT_AB.tMonitoringOn.Do := xTP_MonOn.Q;				(* ex UW_EIN *)

	f_trig_UW_EIN(CLK:= xTP_MonOn.Q);					(* 2nd reset for safety loop *)
	QUITT2_RUHE	:= f_trig_UW_EIN.Q;
	(*-----------------------------------------------------------------------------------------*)
	

	IF bResetTrip OR QUITT2_RUHE THEN
		bGnlTrip1  := FALSE;
		bGnlTrip2  := FALSE;
		bGnlTrip3  := FALSE;
	
		bTriptype1 := FALSE;
		bTriptype2 := FALSE;
		bTriptype3 := FALSE;
	END_IF;
	
	IF bResetWarning THEN
		bGnlWarning := FALSE;
		bRemResWarning := FALSE;
	END_IF;


	(*-----------------------------------------------------------------------------------------*)
	xTP_ResetWarning(IN:= bResetWarning, PT:= T#1s);		(* DO's for acknowledgement *)
	OUT_AB.tResetWarning.Do := xTP_ResetWarning.Q;
	
	xTP_ResetTrip(IN:= bResetTrip, PT:= T#1s);
	OUT_AB.tResetTrip.Do    := xTP_ResetTrip.Q;	
	
	(*-----------------------------------------------------------------------------------------*)	
	(* ----------------------------------------------------------------------------------------*)
	(* AMM test mode *)
	//	in:		iNumAlarmTest	bAlarmTestStart		bAlarmTestStop
	//			iPassLevel		bServiceBegin		
	//	out:	bAlarmTestOn	bAlarmTestEnable	iAlarmTestRestTime	[in s]

	(* service mode on/off *)
	xTON_ServiceTimeOut(IN:= (IN_AB.tGCB_On.Di AND VIS2MM.bServiceBegin), PT:= T#2h);	(* reset timer - after 2 hours with closed gen-c.b. reset service button *)

	IF xTON_ServiceTimeOut.Q THEN	
		VIS2MM.bServiceBegin := FALSE;			(* reset timer from ctr *)
	ELSE
		VIS2MM.bServiceBegin;					(* set/reset timer from vis *)
	END_IF;
	
	OUT_AB.bServiceMode := VIS2MM.bServiceBegin;
	
	(*-----------------------------------------------------------------------------------*)	
	VIS2MM.bAlarmTestStart;
	iNumAlarmTest	:= VIS2MM.iNumAlarmTest;//LIMIT(VIS2MM.iNumAlarmTest,1001,3999);		
	VIS2MM.bAlarmTestStop;


	IF OUT_AB.bServiceMode AND IN_AB.iPassLevel >= 30 THEN
		bAlarmTestEnable := TRUE;
		(*-----------------------------------------------------------------------------------*)
		IF Para.bVISA THEN
			CASE iNumAlarmTest OF 
				1021:	iNumAlarmTest := 0;
				1023:	iNumAlarmTest := 0;
				1028:	iNumAlarmTest := 0;
				1030:	iNumAlarmTest := 0;
				1135:	iNumAlarmTest := 0;
				1057:	iNumAlarmTest := 0;
				1058:	iNumAlarmTest := 0;
			END_CASE;
		END_IF;

		CASE iNumAlarmTest OF 
			1022:	iNumAlarmTest := 0;
			1026:	iNumAlarmTest := 0;
			1031:	iNumAlarmTest := 0;
			1033:	iNumAlarmTest := 0;
			1034:	iNumAlarmTest := 0;
			1035:	iNumAlarmTest := 0;
			1038:	iNumAlarmTest := 0;
			1041:	iNumAlarmTest := 0;
			1042:	iNumAlarmTest := 0;
			1053:	iNumAlarmTest := 0;
			1054:	iNumAlarmTest := 0;
			1056:	iNumAlarmTest := 0;	(* ruhestromschleife unterbrochen	*)
			1061:	iNumAlarmTest := 0;	(* zündung gestört					*)
			3025:	iNumAlarmTest := 0;
			3026:	iNumAlarmTest := 0;		
			3027:	iNumAlarmTest := 0;		
			3028:	iNumAlarmTest := 0;
			3029:	iNumAlarmTest := 0;		
			3310:	iNumAlarmTest := 0;
			3330:	iNumAlarmTest := 0;
			3333:	iNumAlarmTest := 0;
			3335:	iNumAlarmTest := 0;
			3336:	iNumAlarmTest := 0;
			3337:	iNumAlarmTest := 0;
			3344:	iNumAlarmTest := 0;
			3345:	iNumAlarmTest := 0;
		END_CASE;

		IF    iNumAlarmTest < 1001 THEN iNumAlarmTest := 0;
		ELSIF iNumAlarmTest > 9999 THEN iNumAlarmTest := 0;
		END_IF;
		
		IF    iNumAlarmTest <> 0   THEN NumAmmTestValid := TRUE;
		ELSE					        NumAmmTestValid := FALSE;
		END_IF;

		(*-----------------------------------------------------------------------------------*)
		(* start alarm test from visu-button *)
		r_trig_SetAmmTestStart(CLK:= VIS2MM.bAlarmTestStart AND NumAmmTestValid);
		IF r_trig_SetAmmTestStart.Q THEN
			tp_AmmTestReset(IN:= FALSE, PT:=T#0s);
			tp_AmmTestReset.IN:= VIS2MM.bAlarmTestStart;
			tp_AmmTestReset.PT:= T#300s;
			iNumAlarmTestX    := iNumAlarmTest;
		END_IF;
		VIS2MM.bAlarmTestStart := FALSE;	(* reset vis datapoint *)

		tp_AmmTestReset();

		IF VIS2MM.bAlarmTestStop THEN
			tp_AmmTestReset(IN:= FALSE, PT:=T#0s);
		END_IF;
		VIS2MM.bAlarmTestStop := FALSE;		(* reset vis datapoint *)

		bAlarmTestOn			:= tp_AmmTestReset.Q;

		(* alarm test rest time for visu *)
		IF bAlarmTestOn THEN			
			iNumAlarmTest      	:= iNumAlarmTestX;
			iNumAlarmTestRun	:= iNumAlarmTestX;		(* number alarm test running > meta modules *)
			iAlarmTestRestTime	:= DINT_TO_INT(TIME_TO_DINT(tp_AmmTestReset.PT - tp_AmmTestReset.ET)/1000);
		ELSE
			iNumAlarmTestRun   	:= 0;
			iAlarmTestRestTime	:= 0;
		END_IF;

	ELSE
		VIS2MM.bAlarmTestStart	:= FALSE;
		VIS2MM.bAlarmTestStop	:= FALSE;
		bAlarmTestEnable 		:= FALSE;		
		bAlarmTestOn			:= FALSE;
		iNumAlarmTest			:= 0;
		iNumAlarmTestRun		:= 0;
		iAlarmTestRestTime		:= 0;
		tp_AmmTestReset(IN:= FALSE, PT:=T#0s);
	END_IF;

	MM2VIS.bNumAmmTestValid := NumAmmTestValid;


	(*-----------------------------------------------------------------------------------*)
	(* protection test (gridcode III) schutzprüfung -------------------------------------*)	
	VIS2MM.bMMD_GenAlarmTestStart;		VIS2MM.bMMD_GenAlarmTestStop;
	VIS2MM.bMMD_BB_AlarmTestStart;		VIS2MM.bMMD_BB_AlarmTestStop;

	(* protection test mode on/off *)
	IF 		 	IN_AB.iPassLevel >= 15 
		AND 	bOMSS_Stop
		AND 	xOpMode.Stop	THEN	bMMD_GenAlarmTestEnable := TRUE;
										bMMD_BB_AlarmTestEnable := TRUE;

		(*-----------------------------------------------------------------------------------*)
		(* start GenAlarmTest from visu-button *)
		r_trig_SetMMD_GenAmmTestStart(CLK:= VIS2MM.bMMD_GenAlarmTestStart AND bMMD_GenAlarmTestEnable);
		IF r_trig_SetMMD_GenAmmTestStart.Q THEN
			tp_MMD_GenAmmTestReset(IN:= FALSE, PT:=T#0s);
			tp_MMD_GenAmmTestReset.IN:= VIS2MM.bMMD_GenAlarmTestStart;
			tp_MMD_GenAmmTestReset.PT:= T#30m;
		END_IF;
		VIS2MM.bMMD_GenAlarmTestStart := FALSE;	(* reset vis datapoint *)

		tp_MMD_GenAmmTestReset();

		IF VIS2MM.bMMD_GenAlarmTestStop THEN
			tp_MMD_GenAmmTestReset(IN:= FALSE, PT:=T#0s);
		END_IF;
		VIS2MM.bMMD_GenAlarmTestStop := FALSE;		(* reset vis datapoint *)

		bMMD_GenAlarmTestOn		:= tp_MMD_GenAmmTestReset.Q;

		(* alarm test rest time for visu *)
		IF bMMD_GenAlarmTestOn THEN			
			iMMD_GenAlarmTestRestTime	:= DINT_TO_INT(TIME_TO_DINT(tp_MMD_GenAmmTestReset.PT - tp_MMD_GenAmmTestReset.ET)/1000);
		ELSE
			iMMD_GenAlarmTestRestTime	:= 0;
		END_IF;

		(*-----------------------------------------------------------------------------------*)
		(* start BB_AlarmTest from visu-button *)
		r_trig_SetMMD_BB_AmmTestStart(CLK:= VIS2MM.bMMD_BB_AlarmTestStart AND bMMD_BB_AlarmTestEnable);
		IF r_trig_SetMMD_BB_AmmTestStart.Q THEN
			tp_MMD_BB_AmmTestReset(IN:= FALSE, PT:=T#0s);
			tp_MMD_BB_AmmTestReset.IN:= VIS2MM.bMMD_BB_AlarmTestStart;
			tp_MMD_BB_AmmTestReset.PT:= T#30m;
		END_IF;
		VIS2MM.bMMD_BB_AlarmTestStart := FALSE;	(* reset vis datapoint *)

		tp_MMD_BB_AmmTestReset();

		IF VIS2MM.bMMD_BB_AlarmTestStop THEN
			tp_MMD_BB_AmmTestReset(IN:= FALSE, PT:=T#0s);
		END_IF;
		VIS2MM.bMMD_BB_AlarmTestStop := FALSE;		(* reset vis datapoint *)

		bMMD_BB_AlarmTestOn		:= tp_MMD_BB_AmmTestReset.Q;

		(* BB_AlarmTest rest time for visu *)
		IF bMMD_BB_AlarmTestOn THEN			
			iMMD_BB_AlarmTestRestTime	:= DINT_TO_INT(TIME_TO_DINT(tp_MMD_BB_AmmTestReset.PT - tp_MMD_BB_AmmTestReset.ET)/1000);
		ELSE
			iMMD_BB_AlarmTestRestTime	:= 0;
		END_IF;


	ELSE
		VIS2MM.bMMD_GenAlarmTestStart	:= FALSE;
		VIS2MM.bMMD_GenAlarmTestStop	:= FALSE;
		bMMD_GenAlarmTestEnable 		:= FALSE;		
		bMMD_GenAlarmTestOn				:= FALSE;
		tp_MMD_GenAmmTestReset(IN:= FALSE, PT:=T#0s);
		iMMD_GenAlarmTestRestTime		:= 0;

		VIS2MM.bMMD_BB_AlarmTestStart	:= FALSE;
		VIS2MM.bMMD_BB_AlarmTestStop	:= FALSE;
		bMMD_BB_AlarmTestEnable 		:= FALSE;		
		bMMD_BB_AlarmTestOn				:= FALSE;
		tp_MMD_BB_AmmTestReset(IN:= FALSE, PT:=T#0s);
		iMMD_BB_AlarmTestRestTime		:= 0;
	END_IF;

	OUT_AB.bMMD_GenAlarmTestOn := bMMD_GenAlarmTestOn;
	OUT_AB.bMMD_BB_AlarmTestOn := bMMD_BB_AlarmTestOn;
	(*-----------------------------------------------------------------------------------*)
END_PROGRAM
