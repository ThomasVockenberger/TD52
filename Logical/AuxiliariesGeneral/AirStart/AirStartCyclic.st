(****************************************************************************************************************************************
AirStart		pressurized air starters (CYCLIC)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.20.0	26.07.2010 koppm.	new
		13.08.2010 koppm.	slowturn wieder freigegeben
		25.10.2012 TinelloM	Nach einem SlowTurn muss die Drehzahl zuerst wieder unter 14 Umdrehungen gehen, bevor durchgestartet wird.	
							Pausenzeit zwischen Slowturn und Durchstarten der Maschine im INIT
V3.50.0	22.10.2013 TinelloM	added  NOT xTON_SlowturnPassed.Q
							added bRelEngTurn_OilSkid
		08.04.2014 lettenb.	xTON_O2Start_M: FGDRPS added
V3.59.0 30.12.2014 TinelloM	New Spezi; Anpassung an XT4
V4.00.0	06.02.2015 Walid Mari Code-Portierung in XT4
V4.00.1 18.03.2015 lettenb.	bugfix (sky global ib) / Release monitoring -> NOT entfernt
		21.05.2015 lettenb.	rCnt_N_AirStarterOld > iCnt_N_AirStarterOld (REAL > DINT) TO avoid overflow(tinello)
							OUT_AG.bSlowturn_Active added FOR statistics
V4.03.0 17.09.2015 			M_STRT_TEMP6/7: starter ON FOR N2 scavenging + ignition selftest added 
V4.04.0	29.06.2016 TinelloM	trip prevention in CASE OF starter stop
		18.11.2016 TinelloM	xTON_DelayStart.PT, xTON_DelayManStart.PT: 6->0s start delay removed(fahringer)
		18.01.2017 TinelloM airstarter speed convert TO UINT
V4.05.0 21.04.2017 lettenb.	airstarter SWAT920/2.2
V4.05.1 14.06.2017 lettenb.	fast start added
V4.05.1 14.12.2017 lettenb.	spare para removed
V4.07.0 26.04.2018 lettenb.	slowturn removed, SWAT920/5
        13.06.2018 lettenb.	IN_AG.bFS_Act := TRUE -> FALSE; // activation only for 30s faststart, with 4 starters and preengagement
		29.06.2018			bFS4_Act added, 4 starters configuration
V4.09.0	11.12.2019 Schmid	new air starter logic
V4.10.0	29.01.2021 Schmid	manual start stop buttons from Opstate instead of VIS

Instructions FOR use:
--------------------

Outstandings:
------------
bFS4_Act parameter ? standardization 4 starters variant ?
renaming Do's for 4 starter configuration
(****************************************************************************************************************************************)
PROGRAM _CYCLIC

	IF NOT xEngType.Type9 THEN RETURN;		(* Avoid running Airstart and EleStart in same time *)
	END_IF;

	(*--------------------------------------------------------------*)	
	(* RESET of alarms and warnings 								*)
	(*--------------------------------------------------------------*)	
	bAMM_Pr_AirStarter_Tank_Ms		:= FALSE;
	bAMM_Pr_AirStarter_Tank_Lo		:= FALSE;
	bAMM_Pr_AirStarter_Tank_LoLo	:= FALSE;

	bAMM_Pr_AirStarter_Supply_MsMs	:= FALSE;
	bAMM_Pr_AirStarter_Supply_LoLo	:= FALSE;
	bAMM_Pr_AirStarter_Supply_HiHi	:= FALSE;

	bAMM_AirStarter_StartUp			:= FALSE;

	bAMM_Pr_AirST_Engage_Lo			:= FALSE;
	bAMM_Pr_AirST_Engage_Ms			:= FALSE;
	

	(* air starter speed [rpm]							E.00-SI-006 *)	 
	IF xEngType.NumberOfTeeth > 0 THEN (* 920: 398 *)
		
		iN_AirSt  	  	:= DINT_TO_UINT(IN_AG.tCnt_N_AirStarter.Ai);

		IF iN_AirSt >= iN_AirSt_old THEN	iN_AirStDiff	:= iN_AirSt - iN_AirSt_old;
									ELSE	iN_AirStDiff	:= (65535   - iN_AirSt_old) + iN_AirSt;
		END_IF;

		rN_AirStarter 	:= LIMIT(0, UINT_TO_REAL(iN_AirStDiff) * 300 / UINT_TO_REAL(xEngType.NumberOfTeeth), 2000);
												(* 300 = 600(Umrechnung von 100ms auf min) : 2(jede Flanke wird gezählt)	*)
 	ELSE
 		rN_AirStarter 	:= 0;
 	END_IF;	
 
	iN_AirSt_old 		:= DINT_TO_UINT(IN_AG.tCnt_N_AirStarter.Ai);


	(* check fly wheel movement with: *)	
	IF OUT_AG.tAirST_ValEngage.Do THEN
		(* count gear slopes (teeth) that the starter speed sensor detects during engagement phase *)
		iCnt_AirST_MovingFlyW := iCnt_AirST_MovingFlyW + iN_AirStDiff;
		
		(* if number does not change for >1min: trigger reset of tooth counter *)
		IF iCnt_AirST_MovingFlyW <> iCnt_AirST_MovingFlyW_old THEN
			iCnt_AirST_MovingFlyW_old	 := iCnt_AirST_MovingFlyW;
			xTON_MovingFlyW_Cnt_Reset.IN := FALSE;	
		ELSE
			xTON_MovingFlyW_Cnt_Reset.IN := NOT xTON_MovingFlyW_Cnt_Reset.Q;
		END_IF;
		
		(* reset tooth counter *)
		IF xTON_MovingFlyW_Cnt_Reset.Q THEN
			iCnt_AirST_MovingFlyW		:= 0;
			iCnt_AirST_MovingFlyW_old	:= 0;
		END_IF;
		
	(* reset tooth counter after engine start or no engagement command *)
	ELSIF NOT bComEngage THEN
		iCnt_AirST_MovingFlyW		 := 0;
		iCnt_AirST_MovingFlyW_old	 := 0;
		xTON_MovingFlyW_Cnt_Reset.IN := FALSE;
	END_IF;
	
	xTON_MovingFlyW_Cnt_Reset.PT	:= T#1m;
	xTON_MovingFlyW_Cnt_Reset();
	
	bAirST_Engaged_MovingFlyW	:= (iCnt_AirST_MovingFlyW > 8);		(* tolerate movement of up to 4 teeth (8 gear slopes) during engagement *)
	
	(* end check fly wheel movement *)		
	
	
	
	(****************************************************************************************************************************************************)
	(************************         		     					  error monitoring		 	       		      	           **************************)
	(****************************************************************************************************************************************************)
	IF IN_AG.tPB2MM.bParaSetupOk THEN
	
		(* measurement signal failure 								*)
		bAMM_Pr_AirStarter_Tank_Ms			:= Para.bPr_AirStarter_Tank_Exist 	AND NOT IN_AG.tPr_AirStarter_Tank.GoodQual;						(* W2559 *)
		bAMM_Pr_AirStarter_Supply_MsMs		:= Para.bPr_AirStarter_Supply_Exist	AND NOT IN_AG.tPr_AirStarter_Supply.GoodQual AND NOT M_DREHZ;	(* W2557 - was A3370 -> desensitized *)
		xTON_Pr_AirST_Engage_Ms(IN:= NOT IN_AG.tPr_AirST_Engage.GoodQual, PT:= T#1s);
		bAMM_Pr_AirST_Engage_Ms				:= xTON_Pr_AirST_Engage_Ms.Q;																		(* W9303 *)
	
		(* release monitoring	*)
		xTOF_Pr_AirStarter_Tank(IN	:= bAMM_Pr_AirStarter_Tank_Ms, 		PT:= T#10s);		(* TOF because of filtered signals *)		
		xTOF_Pr_AirStarter_Supply(IN:= bAMM_Pr_AirStarter_Supply_MsMs, 	PT:= T#10s);			

		bRelMon_Pr_AirStarter_Tank		:= Para.bPr_AirStarter_Tank_Exist	AND NOT xTOF_Pr_AirStarter_Tank.Q;
		bRelMon_Pr_AirStarter_Supply	:= Para.bPr_AirStarter_Supply_Exist	AND NOT xTOF_Pr_AirStarter_Supply.Q;

		(* tank pressure											*)
		IF M_DREHZ THEN bAMM_Pr_AirStarter_Tank_Lo	 := (IN_AG.tPr_AirStarter_Tank.Ai < Para.rPr_AirStarter_Tank_Lo) AND bRelMon_Pr_AirStarter_Tank;		(* W2560 *)
		ELSE			bAMM_Pr_AirStarter_Tank_LoLo := (IN_AG.tPr_AirStarter_Tank.Ai < Para.rPr_AirStarter_Tank_Lo) AND bRelMon_Pr_AirStarter_Tank;		(* A2268 *)
		END_IF;
	
		(* supply pressure											*)
		IF NOT M_DREHZ AND bRelMon_Pr_AirStarter_Supply THEN			
			bAMM_Pr_AirStarter_Supply_LoLo	:= (IN_AG.tPr_AirStarter_Supply.Ai < Para.rPr_AirStarter_Supply_LoLo);								(* A2269 *)
			bAMM_Pr_AirStarter_Supply_HiHi	:= (IN_AG.tPr_AirStarter_Supply.Ai > Para.rPr_AirStarter_Supply_HiHi);								(* A2267 *)
		END_IF;

		(* engagement pressure sensor											*)
		bPr_AirST_Engage_Lo := (IN_AG.tPr_AirST_Engage.Ai < 5.0);
		xTON_Pr_AirST_Engage_Lo(IN:= OUT_AG.tAirST_ValEngage.Do AND bPr_AirST_Engage_Lo, PT:= T#2s);
		bAMM_Pr_AirST_Engage_Lo		:= xTON_Pr_AirST_Engage_Lo.Q;			(* W2425 air starter engaging error - pressure at pressure sensor low*)															

	
		IF Para.bN_AirStarter_Exist THEN
			(* starter engagement condition dep. on OMSS ----------*)
			IF		bOMSS_Aut THEN	bAirST_Engage_OMSS :=	TRUE;				(* pre-engagement for fast start *)
			ELSIF	bOMSS_Man THEN	bAirST_Engage_OMSS :=	IN_AG.bEng_Aux_Dem;	(* engagement with start preparation *)
			ELSIF	bOMSS_Off THEN	bAirST_Engage_OMSS :=	M_STRT_TEMP7;		(* start scavenging request from ignition selftest *)
			ELSE  					bAirST_Engage_OMSS :=	FALSE;
			END_IF;
			
			(* starter engagement command -------------------------*)
			bComEngage :=	bAirST_Engage_OMSS
						AND NOT M_DREHZ
						AND NOT bGnlTrip
						AND NOT IN_AG.bEng_Bloc;
						
			IF EDGEPOS(bComEngage) THEN
				iStepCnt 		:= 10;
				iCntEng			:= 0;
			ELSIF NOT bComEngage THEN
				iStepCnt 		:= 0;
				iCntEng			:= 0;
			END_IF;
			
			
			xTON_EngStop(IN:= ((IN_AG.rN_EngAct < 0.1) AND (rN_AirStarter < 0.1)), PT:= T#10s); //engine stopped

		(*----------------------------------------------------------------*)
			CASE iStepCnt OF
				0:	bAirST_ValEngage	:= FALSE;
					bAirST_ValStart	:= FALSE;
					bAMM_EngageErr			:= FALSE;
					xTON_AirST_ValEngage(IN:= FALSE, PT:= T#0s);
					xTON_AirST_ValEngageOff(IN:= FALSE, PT:= T#0s);
	
				10: (* Step 1: Open engagement valve *)
					xTON_AirST_ValEngage(IN:= bAirST_ValEngage, PT:= T#2s);
					bAirST_ValEngage := xTON_EngStop.Q OR bAirST_ValEngage;
					IF xTON_AirST_ValEngage.Q THEN
						iStepCnt := iStepCnt + 10;
						xTON_AirST_ValEngage(IN:= FALSE, PT:= T#0s);//reset ton
					END_IF;
	
				20: (* Step 2: Check engagement pressure *)
					IF NOT bPr_AirST_Engage_Lo AND bAirST_ValEngage THEN
							iStepCnt := iStepCnt + 10;
					ELSE
						xTON_AirST_ValEngageOff(IN:= NOT bAirST_ValEngage, PT:= Para.tiReEngage);
						bAirST_ValEngage := FALSE;
						IF xTON_AirST_ValEngageOff.Q THEN
								iStepCnt := iStepCnt + 1; //repeat_engagement ?;
								iCntEng  := iCntEng  + 1;
								xTON_AirST_ValEngageOff(IN:= FALSE, PT:= T#0s); //reset ton
						END_IF;
					END_IF;
	
				21: (* Step 2.1: Further engagement attempt *)
					IF (iCntEng >= 3)			THEN bAMM_EngageErr := TRUE;  END_IF;	//A3375
					IF (rN_AirStarter > 0.0)	THEN bAMM_EngageErr := TRUE;  END_IF;	//A3375
					IF (IN_AG.rN_EngAct > 0.0)	THEN bAMM_EngageErr := TRUE; 	        //A3375
					ELSE iStepCnt := 10;											//next engagement
					END_IF;
						
				30: (* Step 3: Move check/waiting for start command *)
					IF (bAirST_Engaged_MovingFlyW OR (IN_AG.rN_EngAct > 0.0))	THEN bAMM_EngageErr := TRUE;			//A3375
					ELSIF bPr_AirST_Engage_Lo									THEN bAMM_Pr_AirST_Engage_Lo := TRUE;	//W2425
																					 iStepCnt := 20;
					ELSIF OUT_AG.bEng_Start										THEN bAirST_ValStart := TRUE;
																					 iStepCnt := iStepCnt + 10;
					END_IF;
						
				40: (* Step 4: Check starter speed up *)		
					IF (IN_AG.tEng_Run.Do OR M_DREHZ) THEN iStepCnt := 0;
					ELSE	
						bAirST_ValStart := OUT_AG.bEng_Start AND NOT xTP_AirST_ValStart_Interrupt.Q;
					END_IF;
	
				ELSE iStepCnt := 0;
			END_CASE;

		END_IF;

		(*----------------------------------------------------------*)	
		(* start up failure	*)
		xTON_FailedAirST(IN:= (rN_AirStarter < 40) AND OUT_AG.tAirST_ValStart.Do AND OUT_AG.bEng_Start, PT:= Para.tiAirST_Interrupt);
		xTP_AirST_ValStart_Interrupt(IN:= xTON_FailedAirST.Q AND (IN_AG.rN_EngAct < 40.0), PT:= T#1s);

		(* safi safety loop *)
		xTOF_STP_STRT(IN:= OUT_AG.bEng_Start AND (xTON_FailedAirST.Q OR xTOF_STP_STRT.IN), PT:= T#10s);
		OUT_AG.STP_STRT := xTOF_STP_STRT.Q;
		
		xF_TRIG_Eng_Start(CLK:= OUT_AG.bEng_Start);
		IF EDGEPOS(xTP_AirST_ValStart_Interrupt.Q)	THEN iCntSt := iCntSt + 1; (* 3 start up (N > 40 rpm) attempts *)
		ELSIF (RESET OR xF_TRIG_Eng_Start.Q)		THEN iCntSt := 0;
		END_IF;

		bAMM_AirStarter_StartUp   := OUT_AG.bEng_Start AND (IN_AG.rN_EngAct < 40) AND (iCntSt >= 3); (* A3369 startup failure air starter            (N<40)*)

	END_IF;
				
	(****************************************************************************************************************************************************)
	(************************         		     			Handling of starter - similar to EleStart  				           **************************)
	(****************************************************************************************************************************************************)
	(* start stop button info from Opstate *)
	bStart 	:= IN_AG.bStart;
	bStop 	:= IN_AG.bStop;
	
	(* delay automatic start *)
	xTON_DelayStart(IN:= IN_AG.bEng_SU_Aut AND NOT bOMSS_Man, PT:= T#0s);
	OUT_AG.bEngAutStartDelay := xTON_DelayStart.Q;

	(* second button push in manual start after short 120s prelubrication time *)
	IF bStart AND xTOF_ShortPreLubeTime_Delay.Q 	THEN ZM_bStartMan := TRUE;
	ELSIF ZM_HSTART	OR NOT IN_AG.bEng_Dem			THEN ZM_bStartMan := FALSE;			
	END_IF;

	(* manual start *)
	ZM_HSTART	:= 	(bStart OR ZM_HSTART OR ZM_bStartMan)
			AND		bOMSS_Man 
			AND 	(AN_VSD1 OR AN_VSD2)
			AND 	bPr_OTC_Prelub
			AND 	IN_AG.bEng_SU_Man 
			AND(NOT IN_AG.bBlocDelay_ManStart OR     OUT_AG.bEng_Start)
			AND    	(IN_AG.bScavFinished      OR NOT IN_AG.bRel_ScavN2)
			AND NOT xTP_StarterOFF.Q
			AND NOT bStop;


	(* delay manual start *)
	xTON_DelayManStart(IN:= ZM_HSTART AND bOMSS_Man, PT:= T#0s);

	(* starter pulse ON-time *)
	T7_TEMP1 := (IN_AG.bEng_Dem_EPS AND NOT IN_AG.bOnly_Island) OR OUT_AG.bEngAutStartDelay;
	xTP_StarterON.PT := Para.tiAirStarter_OnTime;
	
	IF NOT IN_AG.bEng_Dem_EPS AND NOT ZM_HSTART AND NOT IN_AG.bEng_SU_Aut THEN (* reset timer *)
		xTP_StarterON(IN:= FALSE, PT:= T#0s);
	ELSIF IN_AG.bEng_SU_Man THEN
		xTP_StarterON(IN:= xTON_DelayManStart.Q AND NOT xTP_StarterOFF.Q);	
	ELSIF IN_AG.bEng_SU_Aut THEN
		xTP_StarterON(IN:= T7_TEMP1             AND NOT xTP_StarterOFF.Q);	
	ELSE
		xTP_StarterON(IN:= FALSE, PT:= T#0s);
	END_IF;
	bTP_StarterON := xTP_StarterON.Q ; 

	(* starter puls OFF-time *)	
	xTP_StarterOFF(IN:= NOT bTP_StarterON, PT:= T#60s); 		


	(*---------------------------------------------------------------------------------------------*)
	(* monitoring start *)
	xR_TRIG_Reset1(CLK:= IN_AG.tEng_Run.Do);
	xR_TRIG_Reset2(CLK:= IN_AG.bEng_Dem_Man_SUpF);
	xR_TRIG_Reset3(CLK:= IN_AG.bEng_Dem_Aut_SUpF);
	RESET := xR_TRIG_Reset1.Q OR xR_TRIG_Reset2.Q OR xR_TRIG_Reset3.Q;

	xF_TRIG_Start(CLK:= bTP_StarterON);

	(* start counter *)										
	xCTD_Start(CD:= xF_TRIG_Start.Q, LOAD:= RESET, PV:= 3);
	OUT_AG.iStartCount	:= LIMIT(1, xCTD_Start.PV - xCTD_Start.CV + 1, xCTD_Start.PV);  //Number of Start for OpState
	
	(* man + auto start error *)
	xTON_StartErr(IN:= xCTD_Start.Q AND NOT M_DREHZ AND(IN_AG.bEng_Dem_Aut_SUpF OR IN_AG.bEng_Dem_Man_SUpF), PT:= T#12s); (* delay = min.starter off interval time *)
	bStartErr := xTON_StartErr.Q AND NOT MM2VIS.bMsg3369;		(* A1023 engine start up failure (n>40)*)

	(*---------------------------------------------------------------------------------------------*)
	(* starter ON for N2 scavenging *) (* -> NOT ACTIVE FOR NOW *)
	M_STRT_TEMP6 := IN_AG.bN2_ScavCoStarterOn  AND IN_AG.bRel_ScavN2
				AND OUT_AG.bPr_EOP_Prelub1 AND IN_AG.bRelEngTurn_OilSkid AND NOT M_DREHZ;

	(* starter ON for ignition selftest *) 
	M_STRT_TEMP7 := IN_AG.b_ST_DemIgn         
				AND OUT_AG.bPr_EOP_Prelub1 AND IN_AG.bRelEngTurn_OilSkid AND NOT M_DREHZ;

	(*---------------------------------------------------------------------------------------------*)
	(* start *)
	ZM_STRT   := IN_AG.bEng_Rel AND NOT M_DREHZ AND OUT_AG.bRelEngOp_Aux;
	OUT_AG.bEng_Start := (ZM_STRT AND bTP_StarterON) 						(* Equal to M_STRT in XT3 *) 
//					  OR  M_STRT_TEMP6
					  OR  M_STRT_TEMP7;

	(*---------------------------------------------------------------------------------------------*)
	(* start scavenging time with blocked ignition -> no scavenging for 920 *)	
	OUT_AG.bRel_IgnOn := OUT_AG.bEng_Start;	

	(* start scavenging time with blocked gas valves -> no scavenging for 920 *)	
	OUT_AG.bGV_Start_ScaveBlock := FALSE;
	
	(* disable direct air injection on starter tank pressure low*)
	OUT_AG.bAMM_Pr_AirStarter_Tank_Lo := bAMM_Pr_AirStarter_Tank_Lo;

	(* safi safety loop - thooth to thooth/engagement failed *)
//	xTOF_STP_STRT(IN:= OUT_AG.bEng_Start, PT:= T#15s);
//	OUT_AG.STP_STRT	:= xTOF_STP_STRT.Q;	
//	xTON_ZAZ(IN := OUT_AG.tAirStarter_ValveOn.Do AND (IN_AG.rN_EngAct < 40), PT:= Para.tiReEngage);
//	OUT_AG.STP_STRT := xTON_ZAZ.Q OR ;

	(****************************************************************************************************************************************************)
	(************************              						 air starter valves		 	             			           **************************)
	(****************************************************************************************************************************************************)
	OUT_AG.tAirST_ValEngage.Do	:=  bAirST_ValEngage; 					(* engaging valve    *)
	OUT_AG.tAirST_ValStart.Do	:=  bAirST_ValStart; 	 				(* start    valve    *)

	(****************************************************************************************************************************************************)
	(************************      		        	RELEASE of engine turn equipment (Durchdrehvorrichtung)   			       **************************)
	(****************************************************************************************************************************************************)
	xTON_TURN(IN:= NOT IN_AG.bEng_RPSDem AND NOT IN_AG.bGV_On, PT:= T#1m);  	(* No release of barring gear if engine demand or gasvalve opened *)
	OUT_AG.tTurnRel.Do	:= xTON_TURN.Q AND IN_AG.bRelEngTurn_OilSkid;	

END_PROGRAM
