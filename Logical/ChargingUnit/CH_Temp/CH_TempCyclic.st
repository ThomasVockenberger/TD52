(*******************************************************************************
CH_Temp	 			 Charging temperatures 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023


Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	30.11.2012	Tinello		restructured 
V04.01.00.00	19.05.2014	Tinello		gastype = 0 included 
				02.06.2014	Tinello 	bugfix power reduction
				07.08.2014	Tinello		Changed activation of charge temperature maximum monitoring
V04.04.00.00	18.05.2016 	Tinello 	bP_Nom10_600s added --> Spec Vers. c 
				02.11.2016 	Tinello		T1LP and monitoring added --> Spec Vers. c
				25.01.2017	Tinello		bugfix for AVG
V04.05.00.00	06.02.2017	Tinello		vvm cycle time correction
				19.04.2017	Weitzer		2460, 2461 added, SWAT920/2
										2221, 2222 modified, SWAT920/2
										2223 incl. P reduction modified, SWAT920/2
				27.04.2017	lettenb.	920: set OUT_CH.rT_Ch_T2s_x to Para.rT_Ch_T2s_Hi[gastype] in case of MS_A + MS_B, SWAT920/2
V04.05.01.00	10.10.2017	Zingerle	Spezifikation f komplett eingearbeitet und abgeglichen
				24.01.2018	Tinello		Cleanup and final modifications
V04.05.02.00	15.03.2018	Tinello		BugFix --> Anzeige Temp bei BWS aus
V04.05.03.00	19.03.2018	Tinello		Spezifikation g
V04.06.00.00	26.09.2018	Perktold	20s delay after SY until activation of T2s max monitoring - Spezifikation h
V04.07.00.00	15.05.2019	Tinello		Spezifikation i: MsErr active with op.switch OFF mode / Handover T1 before HP TC TO other modules
														 No warning	if speed sensors available
V04.12.00.00	24.04.2023 	Tinello		Deleted T1 maximum monitoring / Added calculation, monitoring and power red of T2 max

(*******************************************************************************)
PROGRAM _INIT
	(* ramp settings *)
	xRAMPE_R_P_Red_Ch_T2LP.TC_Time	:= TASK_TIME_10MS;
	xRAMPE_R_P_Red_Ch_T2LP.Rise		:= 0.001;		(*  0,1% Pnom/s *)
	xRAMPE_R_P_Red_Ch_T2LP.Sink		:= 0.1;			(* 10,0% Pnom/s *)

	xRAMPE_R_P_Red_Ch_T2HP.TC_Time	:= TASK_TIME_10MS;
	xRAMPE_R_P_Red_Ch_T2HP.Rise		:= 0.001;		(*  0,1% Pnom/s *)
	xRAMPE_R_P_Red_Ch_T2HP.Sink		:= 0.1;			(* 10,0% Pnom/s *)

END_PROGRAM


PROGRAM _CYCLIC	

	(*--------------------------------------------------*)
	(* RESET of alarms and warnings 					*)
	(*--------------------------------------------------*)
	xTON_200msTick(IN	:= NOT xTON_200msTick.Q, PT:= T#180ms);							(* 180ms + 2x cycle time = 200 ms *)

	IF xTON_200msTick.Q THEN															(* to notice the alarm in 100ms Task *)

		bAMM_T_Ch_T1LP_Ms		:= FALSE;		(* W2411 *)
		bAMM_T_Ch_T1LP_A_Ms		:= FALSE;		(* W2413 *)
		bAMM_T_Ch_T1LP_B_Ms		:= FALSE;		(* W2414 *)

		bAMM_T_Ch_T2LP_Ms		:= FALSE;		(* W2489 *)
		bAMM_T_Ch_T2LP_A_Ms		:= FALSE;		(* W2481 *)
		bAMM_T_Ch_T2LP_B_Ms		:= FALSE;		(* W2482 *)
		bAMM_T_Ch_T2LP_HiHi		:= FALSE;		(* A2370 *)
		bAMM_T_Ch_T2_Calc		:= FALSE;		(* W9370 *)
		
		bAMM_T_Ch_T1HP_MsMs		:= FALSE;		(* A2280 *) (* 2318 *)
		bAMM_T_Ch_T1HP_A_Ms		:= FALSE;		(* W2460 *) (* 2479 *)
		bAMM_T_Ch_T1HP_B_Ms		:= FALSE;		(* W2461 *) (* 2480 *)
		bAMM_T_Ch_T1HP_Lo		:= FALSE;		(* W2531 *) (* 2477 *)

		bAMM_T_Ch_T2HP_Ms		:= FALSE;		(* W2490 *) (* 2491 *)
		bAMM_T_Ch_T2HP_A_Ms		:= FALSE;		(* W2483 *) (* 2485 *)
		bAMM_T_Ch_T2HP_B_Ms		:= FALSE;		(* W2484 *) (* 2486 *)
		bAMM_T_Ch_T2HP_HiHi		:= FALSE;		(* A2368 *)	(* 2369 *)

		bAMM_T_Ch_T2s_MsMs		:= FALSE;		(* A1114 *)
		bAMM_T_Ch_T2s_A_Ms		:= FALSE;		(* W2619 *)
		bAMM_T_Ch_T2s_B_Ms		:= FALSE;		(* W2620 *)
		bAMM_T_Ch_T2s_Lo		:= FALSE;		(* W3562 *)
		bAMM_T_Ch_T2s_A_Lo		:= FALSE;		(* W2510 *)
		bAMM_T_Ch_T2s_B_Lo		:= FALSE;		(* W2512 *)
		bAMM_T_Ch_T2s_Hi		:= FALSE;		(* W3411 *)
		bAMM_T_Ch_T2s_A_Hi		:= FALSE;		(* W2511 *)
		bAMM_T_Ch_T2s_B_Hi		:= FALSE;		(* W2513 *)
		bAMM_T_Ch_T2s_HiHi		:= FALSE;		(* A1040 *)
		bAMM_T_Ch_T2s_A_HiHi	:= FALSE;		(* A2216 *)
		bAMM_T_Ch_T2s_B_HiHi	:= FALSE;		(* A2219 *)
		bAMM_T_Ch_T2s_RocHiHi	:= FALSE;		(* A1105 *)
		bAMM_T_Ch_T2s_A_RocHiHi	:= FALSE;		(* A2217 *)
		bAMM_T_Ch_T2s_B_RocHiHi	:= FALSE;		(* A2220 *)
		bAMM_T_Ch_T2s_DiffHi	:= FALSE;		(* W2525 *)
	END_IF

	rP_Red_Ch_T2s				:= 0;
	rP_Red_Ch_T2s_A				:= 0;
	rP_Red_Ch_T2s_B				:= 0;
	OUT_CH.rP_Red_Ch_T2s_Norm 	:= 1;													(* release full load - no reduction *)
	OUT_CH.rP_Red_Ch_T2HP_Norm 	:= 1;													(* release full load - no reduction *)
	OUT_CH.rP_Red_Ch_T2LP_Norm 	:= 1;													(* release full load - no reduction *)
	OUT_CH.bAMM_T_Ch_T2s_Avg	:= FALSE;												(* collective warning *)
	OUT_CH.bAMM_T_Ch_T1HP_Avg	:= FALSE;												(* collective warning *)
	OUT_CH.bAMM_T_Ch_T1LP_Avg	:= FALSE;												(* collective warning *)
	OUT_CH.bRelEngStart_Ch_T2	:= TRUE;												(* Startfreigabe *)


	(*--------------------------------------------------*)
	(* VISU var of module 								*)
	(*--------------------------------------------------*)
	MM2VIS.rT_Ch_T1LP			:= IN_CH.tT_Ch_T1LP.Ai;
	MM2VIS.rT_Ch_T1LP_A			:= IN_CH.tT_Ch_T1LP_A.Ai;
	MM2VIS.rT_Ch_T1LP_B			:= IN_CH.tT_Ch_T1LP_B.Ai;

	MM2VIS.rT_Ch_T2LP			:= IN_CH.tT_Ch_T2LP.Ai;
	MM2VIS.rT_Ch_T2LP_A			:= IN_CH.tT_Ch_T2LP_A.Ai;
	MM2VIS.rT_Ch_T2LP_B			:= IN_CH.tT_Ch_T2LP_B.Ai;

	MM2VIS.rT_Ch_T1HP			:= IN_CH.tT_Ch_T1HP.Ai;
	MM2VIS.rT_Ch_T1HP_A			:= IN_CH.tT_Ch_T1HP_A.Ai;
	MM2VIS.rT_Ch_T1HP_B			:= IN_CH.tT_Ch_T1HP_B.Ai;

	MM2VIS.rT_Ch_T2HP			:= IN_CH.tT_Ch_T2HP.Ai;
	MM2VIS.rT_Ch_T2HP_A			:= IN_CH.tT_Ch_T2HP_A.Ai;
	MM2VIS.rT_Ch_T2HP_B			:= IN_CH.tT_Ch_T2HP_B.Ai;

	MM2VIS.rT_Ch_T2s			:= IN_CH.tT_Ch_T2s.Ai;
	MM2VIS.rT_Ch_T2s_A			:= IN_CH.tT_Ch_T2s_A.Ai;
	MM2VIS.rT_Ch_T2s_B			:= IN_CH.tT_Ch_T2s_B.Ai;


	(*------------------------------------------------------------------*)
	(* Save actual value every second for RATE OF CHANGE calculation	*)
	(*------------------------------------------------------------------*)
	xTON_1000ms(IN:= NOT xTON_1000ms.Q, PT:= T#980ms);									(* 980ms + 2x cycle time = 1000 ms *)

	IF xTON_1000ms.Q THEN	rT_Ch_T2s_Old	:= IN_CH.tT_Ch_T2s.Ai;
							rT_Ch_T2s_A_Old	:= IN_CH.tT_Ch_T2s_A.Ai;
							rT_Ch_T2s_B_Old	:= IN_CH.tT_Ch_T2s_B.Ai;	END_IF



	(*--------------------------------------------------*)
	(* release for error monitoring 					*)
	(*--------------------------------------------------*)
	IF bRelModul_ParaSetupOk AND IN_CH.tPB2MM.bSys_Run THEN

		(*------------------------------------------------------------------*)
		(* measurement signal failure 										*)
		(*------------------------------------------------------------------*)
		(* charge temperature T1 before low pressure TC *)
		bAMM_T_Ch_T1LP_Ms 	:= Para.bT_Ch_T1LP_Exist   AND NOT IN_CH.tT_Ch_T1LP.GoodQual; 											(* W2411 *)
		bAMM_T_Ch_T1LP_A_Ms	:= Para.bT_Ch_T1LP_A_Exist AND NOT IN_CH.tT_Ch_T1LP_A.GoodQual;											(* W2413 *)
		bAMM_T_Ch_T1LP_B_Ms	:= Para.bT_Ch_T1LP_B_Exist AND NOT IN_CH.tT_Ch_T1LP_B.GoodQual;											(* W2414 *)

			(* release monitoring	*)
			xTON_RelMon_T1LP(IN	 := Para.bT_Ch_T1LP_Exist   AND NOT bAMM_T_Ch_T1LP_Ms, 	 PT:= T#10s);
			xTON_RelMon_T1LP_A(IN:= Para.bT_Ch_T1LP_A_Exist AND NOT bAMM_T_Ch_T1LP_A_Ms, PT:= T#10s);
			xTON_RelMon_T1LP_B(IN:= Para.bT_Ch_T1LP_B_Exist AND NOT bAMM_T_Ch_T1LP_B_Ms, PT:= T#10s);

			bRelMon_T1LP	:= xTON_RelMon_T1LP.Q;				(* delayed reswitch to valid meas.value *)
			bRelMon_T1LP_A	:= xTON_RelMon_T1LP_A.Q;
			bRelMon_T1LP_B	:= xTON_RelMon_T1LP_B.Q;


		(* charge temperature T2 after low pressure TC *)
		bAMM_T_Ch_T2LP_Ms 	:= Para.bT_Ch_T2LP_Exist   AND NOT IN_CH.tT_Ch_T2LP.GoodQual; 											(* W2489 *)
		bAMM_T_Ch_T2LP_A_Ms	:= Para.bT_Ch_T2LP_A_Exist AND NOT IN_CH.tT_Ch_T2LP_A.GoodQual;											(* W2481 *)
		bAMM_T_Ch_T2LP_B_Ms	:= Para.bT_Ch_T2LP_B_Exist AND NOT IN_CH.tT_Ch_T2LP_B.GoodQual;											(* W2482 *)

			(* release monitoring	*)
			xTON_RelMon_T2LP(IN	 := Para.bT_Ch_T2LP_Exist   AND NOT bAMM_T_Ch_T2LP_Ms, 	 PT:= T#10s);
			xTON_RelMon_T2LP_A(IN:= Para.bT_Ch_T2LP_A_Exist AND NOT bAMM_T_Ch_T2LP_A_Ms, PT:= T#10s);
			xTON_RelMon_T2LP_B(IN:= Para.bT_Ch_T2LP_B_Exist AND NOT bAMM_T_Ch_T2LP_B_Ms, PT:= T#10s);

			bRelMon_T2LP	:= xTON_RelMon_T2LP.Q;				(* delayed reswitch to valid meas.value *)
			bRelMon_T2LP_A	:= xTON_RelMon_T2LP_A.Q;
			bRelMon_T2LP_B	:= xTON_RelMon_T2LP_B.Q;


		(* charge temperature T1 before high pressure TC *)
		bAMM_T_Ch_T1HP_A_Ms	:=	  Para.bT_Ch_T1HP_A_Exist AND NOT IN_CH.tT_Ch_T1HP_A.GoodQual;							(* W2460 *)	(* W2479 *)
		bAMM_T_Ch_T1HP_B_Ms	:= 	  Para.bT_Ch_T1HP_B_Exist AND NOT IN_CH.tT_Ch_T1HP_B.GoodQual;							(* W2461 *)	(* W2480 *)
		bAMM_T_Ch_T1HP_MsMs := (  Para.bT_Ch_T1HP_Exist	  AND NOT IN_CH.tT_Ch_T1HP.GoodQual) OR 						(* A2280 *)	(* A2318 *)
							   (((Para.bT_Ch_T1HP_B_Exist AND NOT Para.bT_Ch_T1HP_A_Exist) OR bAMM_T_Ch_T1HP_A_Ms) AND 
							    ((Para.bT_Ch_T1HP_A_Exist AND NOT Para.bT_Ch_T1HP_B_Exist) OR bAMM_T_Ch_T1HP_B_Ms)	  );

			(* release monitoring	*)
			xTON_RelMon_T1HP(IN	 := Para.bT_Ch_T1HP_Exist   AND NOT bAMM_T_Ch_T1HP_MsMs, PT:= T#10s);
			xTON_RelMon_T1HP_A(IN:= Para.bT_Ch_T1HP_A_Exist AND NOT bAMM_T_Ch_T1HP_A_Ms, PT:= T#10s);
			xTON_RelMon_T1HP_B(IN:= Para.bT_Ch_T1HP_B_Exist AND NOT bAMM_T_Ch_T1HP_B_Ms, PT:= T#10s);

			bRelMon_T1HP	:= xTON_RelMon_T1HP.Q;				(* delayed reswitch to valid meas.value *)
			bRelMon_T1HP_A	:= xTON_RelMon_T1HP_A.Q;
			bRelMon_T1HP_B	:= xTON_RelMon_T1HP_B.Q;


		(* charge temperature T2 after high pressure TC *)
		bAMM_T_Ch_T2HP_Ms 	:= Para.bT_Ch_T2HP_Exist   AND NOT IN_CH.tT_Ch_T2HP.GoodQual; 								(* W2490 *)	(* W2491 *)
		bAMM_T_Ch_T2HP_A_Ms := Para.bT_Ch_T2HP_A_Exist AND NOT IN_CH.tT_Ch_T2HP_A.GoodQual;								(* W2483 *)	(* W2485 *)
		bAMM_T_Ch_T2HP_B_Ms	:= Para.bT_Ch_T2HP_B_Exist AND NOT IN_CH.tT_Ch_T2HP_B.GoodQual;								(* W2484 *)	(* W2486 *)

			(* release monitoring	*)
			xTON_RelMon_T2HP(IN	 := Para.bT_Ch_T2HP_Exist   AND NOT bAMM_T_Ch_T2HP_Ms,   PT:= T#10s);
			xTON_RelMon_T2HP_A(IN:= Para.bT_Ch_T2HP_A_Exist AND NOT bAMM_T_Ch_T2HP_A_Ms, PT:= T#10s);
			xTON_RelMon_T2HP_B(IN:= Para.bT_Ch_T2HP_B_Exist AND NOT bAMM_T_Ch_T2HP_B_Ms, PT:= T#10s);

			bRelMon_T2HP	:= xTON_RelMon_T2HP.Q;				(* delayed reswitch to valid meas.value *)
			bRelMon_T2HP_A	:= xTON_RelMon_T2HP_A.Q;
			bRelMon_T2HP_B	:= xTON_RelMon_T2HP_B.Q;


		(* charge temperature T2' *)
		bAMM_T_Ch_T2s_A_Ms 	:= 	  Para.bT_Ch_T2s_A_Exist AND NOT IN_CH.tT_Ch_T2s_A.GoodQual;										(* W2619 *)
		bAMM_T_Ch_T2s_B_Ms 	:= 	  Para.bT_Ch_T2s_B_Exist AND NOT IN_CH.tT_Ch_T2s_B.GoodQual;										(* W2620 *)
		bAMM_T_Ch_T2s_MsMs 	:= (  Para.bT_Ch_T2s_Exist   AND NOT IN_CH.tT_Ch_T2s.GoodQual) 	OR										(* A1114 *)
							   (((Para.bT_Ch_T2s_B_Exist AND NOT Para.bT_Ch_T2s_A_Exist) OR bAMM_T_Ch_T2s_A_Ms) AND 
							    ((Para.bT_Ch_T2s_A_Exist AND NOT Para.bT_Ch_T2s_B_Exist) OR bAMM_T_Ch_T2s_B_Ms)	  );

			(* release monitoring	*)
			xTON_RelMon_T2s(IN	:= Para.bT_Ch_T2s_Exist   AND NOT bAMM_T_Ch_T2s_MsMs, PT:= T#10s);
			xTON_RelMon_T2s_A(IN:= Para.bT_Ch_T2s_A_Exist AND NOT bAMM_T_Ch_T2s_A_Ms, PT:= T#10s);
			xTON_RelMon_T2s_B(IN:= Para.bT_Ch_T2s_B_Exist AND NOT bAMM_T_Ch_T2s_B_Ms, PT:= T#10s);

			bRelMon_T2s		:= xTON_RelMon_T2s.Q;				(* delayed reswitch to valid meas.value *)
			bRelMon_T2s_A	:= xTON_RelMon_T2s_A.Q;
			bRelMon_T2s_B	:= xTON_RelMon_T2s_B.Q;




		(*------------------------------------------------------------------*)
		(* temperature MIN		 											*)
		(*------------------------------------------------------------------*)
	  	(* charge temperature T1 before high pressure TC minimum *)
		IF bP_Nom10_300s THEN
			bAMM_T_Ch_T1HP_Lo	:= ((IN_CH.tT_Ch_T1HP.Ai   < Para.rT_Ch_T1HP_Lo) AND bRelMon_T1HP  ) OR					(* W2531 *)	(* W2477 *)
								   ((IN_CH.tT_Ch_T1HP_A.Ai < Para.rT_Ch_T1HP_Lo) AND bRelMon_T1HP_A) OR
						   		   ((IN_CH.tT_Ch_T1HP_B.Ai < Para.rT_Ch_T1HP_Lo) AND bRelMon_T1HP_B);
		END_IF


		(* charge temperature T2' minimum *)
		IF bP_Nom10_600s THEN
			bAMM_T_Ch_T2s_Lo 	:= (IN_CH.tT_Ch_T2s.Ai 	 < Para.rT_Ch_T2s_Lo) AND bRelMon_T2s;										(* W3562 *)
			bAMM_T_Ch_T2s_A_Lo 	:= (IN_CH.tT_Ch_T2s_A.Ai < Para.rT_Ch_T2s_Lo) AND bRelMon_T2s_A;									(* W2510 *)
			bAMM_T_Ch_T2s_B_Lo 	:= (IN_CH.tT_Ch_T2s_B.Ai < Para.rT_Ch_T2s_Lo) AND bRelMon_T2s_B;									(* W2512 *)
	  	END_IF




		(*------------------------------------------------------------------*)
		(* temperature MAX	 / POWER REDUCTION								*)
		(*------------------------------------------------------------------*)
		(* charge temperature T1 before low-pressure TC (air intake) - maximum *)
		IF bRelMon_T1LP OR bRelMon_T1LP_A 
						OR bRelMon_T1LP_B  		THEN rT_Ch_T1LP_Max			:= MAX(IN_CH.tT_Ch_T1LP.Ai   * BOOL_TO_REAL(bRelMon_T1LP),
																			 	   IN_CH.tT_Ch_T1LP_A.Ai * BOOL_TO_REAL(bRelMon_T1LP_A),
																			   	   IN_CH.tT_Ch_T1LP_B.Ai * BOOL_TO_REAL(bRelMon_T1LP_B));
												ELSE rT_Ch_T1LP_Max			:= 0;
													 bAMM_T_Ch_T2_Calc		:= Para.bTSTC_Exist AND		(* Engine start blocked *)	(* W9370 *)
																			   Para.bCh_T2Calc_Active;
		END_IF


		(* charge temperature T2 after low-pressure TC - maximum *)
		IF Para.bCh_T2Calc_Active 	AND NOT bRelMon_T2LP 
									AND NOT bRelMon_T2LP_A
									AND NOT bRelMon_T2LP_B
									AND 	Para.bTSTC_Exist
		THEN
			(* Find most suitable pressure close to TC *)
			IF	  NOT OUT_CH.bAMM_Pr_Ch_P2LP_Avg	THEN rPr_aLPTC			:= OUT_CH.rPr_Ch_P2LP_Max;
			ELSIF NOT OUT_CH.bAMM_Pr_Ch_P1HP_Avg	THEN rPr_aLPTC			:= OUT_CH.rPr_Ch_P1HP_Max + Para.rDPr_Ch_T2Calc_LP_Cooler;
													ELSE rPr_aLPTC			:= 0;
														 bAMM_T_Ch_T2_Calc	:= TRUE;					(* Engine start blocked *)	(* W9370 *)
			END_IF

			IF	  NOT OUT_CH.bAMM_Pr_Ch_P1LP_Avg	THEN rPr_bLPTC			:= OUT_CH.rPr_Ch_P1LP_Max;
			ELSIF NOT IN_CH.bAMM_Pr_Baro_Internal	THEN rPr_bLPTC			:= IN_CH.rPr_Baro_Internal  - Para.rDPr_Ch_T2Calc_AirFilt;
			ELSIF NOT bAMM_T_Ch_T2_Calc 	AND 
					  IN_CH.rN_EngAct < 10			THEN rPr_bLPTC			:= rPr_aLPTC 				- Para.rDPr_Ch_T2Calc_AirFilt;
			END_IF

			(* calculation - T2 after low-pressure TC *)
			IF 	NOT bAMM_T_Ch_T2_Calc 			AND														(* Engine start released *)
				Para.rPc_Ch_T2Calc_LP_Eff <> 0	AND														(* no division by zero *)
				rPr_bLPTC 				  <> 0		THEN rT_Ch_T2LP_Max		:= (rT_Ch_T1LP_Max + 273.15) / Para.rPc_Ch_T2Calc_LP_Eff *
								  											   ((rPr_aLPTC / rPr_bLPTC)**(0.38 / 1.38) - 1) + rT_Ch_T1LP_Max;
													ELSE rT_Ch_T2LP_Max		:= 0;
														 bAMM_T_Ch_T2_Calc	:= TRUE;					(* Engine start blocked *)	(* W9370 *)
			END_IF

			MM2VIS.rT_Ch_T2LP_Calc	:= rT_Ch_T2LP_Max * BOOL_TO_REAL(bStartSpd);						(* calculation only used during operation *)
		ELSE
			MM2VIS.rT_Ch_T2LP_Calc	:= 0;
			rT_Ch_T2LP_Max			:= MAX(IN_CH.tT_Ch_T2LP.Ai   * BOOL_TO_REAL(bRelMon_T2LP),
										   IN_CH.tT_Ch_T2LP_A.Ai * BOOL_TO_REAL(bRelMon_T2LP_A),
										   IN_CH.tT_Ch_T2LP_B.Ai * BOOL_TO_REAL(bRelMon_T2LP_B));
		END_IF

			(* power reduction of 4% per °C deviation to at least 80% *)
			xSigScal_R_P_Red_Ch_T2LP.X	:= rT_Ch_T2LP_Max;
			xSigScal_R_P_Red_Ch_T2LP.X1 := Para.rT_Ch_T2LP_HiHi - 5;
			xSigScal_R_P_Red_Ch_T2LP.X2	:= Para.rT_Ch_T2LP_HiHi;
			xSigScal_R_P_Red_Ch_T2LP.Y1 := 1.0;
			xSigScal_R_P_Red_Ch_T2LP.Y2 := 0.8;
			xSigScal_R_P_Red_Ch_T2LP();

			xRAMPE_R_P_Red_Ch_T2LP(In	:= xSigScal_R_P_Red_Ch_T2LP.Y_SCAL, enable := bStartSpd);

		IF Para.bCh_T2Calc_Active AND Para.bTSTC_Exist THEN
			OUT_CH.rP_Red_Ch_T2LP_Norm	:= LIMIT(0.8, xRAMPE_R_P_Red_Ch_T2LP.Out, 1);												(* B9075 *)
		END_IF
		
		bAMM_T_Ch_T2LP_HiHi				:= rT_Ch_T2LP_Max > Para.rT_Ch_T2LP_HiHi AND Para.bTSTC_Exist;								(* A2370 *)


		(* charge temperature T1 before high pressure TC maximum *)
		IF bRelMon_T1HP OR bRelMon_T1HP_A 
						OR bRelMon_T1HP_B		THEN rT_Ch_T1HP_Max			:= MAX(IN_CH.tT_Ch_T1HP.Ai   * BOOL_TO_REAL(bRelMon_T1HP),
									   											   IN_CH.tT_Ch_T1HP_A.Ai * BOOL_TO_REAL(bRelMon_T1HP_A),
																				   IN_CH.tT_Ch_T1HP_B.Ai * BOOL_TO_REAL(bRelMon_T1HP_B));
		ELSIF 	NOT Para.bTSTC_Exist 		AND
				NOT Para.bT_Ch_T1HP_Exist 	AND
				NOT Para.bT_Ch_T1HP_A_Exist AND
				NOT Para.bT_Ch_T1HP_B_Exist	AND
					(bRelMon_T1LP 	OR 
				 	 bRelMon_T1LP_A OR 
					 bRelMon_T1LP_B	  ) 		THEN rT_Ch_T1HP_Max			:= rT_Ch_T1LP_Max;			(* Use intake air temperature if T1HP is not available *)
												ELSE rT_Ch_T1HP_Max			:= 0;
													 bAMM_T_Ch_T2_Calc		:= Para.bCh_T2Calc_Active;	(* Engine start blocked *)	(* W9370 *)
		END_IF


		(* charge temperature T2 after high-pressure TC - maximum *)
		IF Para.bCh_T2Calc_Active 	AND NOT bRelMon_T2HP 
									AND NOT bRelMon_T2HP_A
									AND NOT bRelMon_T2HP_B
		THEN
			(* Find most suitable pressure close to TC *)
			IF	  NOT OUT_CH.bAMM_Pr_Ch_P2HP_Avg	THEN rPr_aHPTC			:= OUT_CH.rPr_Ch_P2HP_Max;
			ELSIF NOT OUT_CH.bAMM_Pr_Ch_P2_Avg		THEN rPr_aHPTC			:= OUT_CH.rPr_Ch_P2_Max  + Para.rDPr_Ch_T2Calc_HP_Cooler;
			ELSIF NOT OUT_CH.bAMM_Pr_Ch_P2s_Avg		THEN rPr_aHPTC			:= OUT_CH.rPr_Ch_P2s_Max + Para.rDPr_Ch_T2Calc_HP_Cooler;
													ELSE rPr_aHPTC			:= 0;
														 bAMM_T_Ch_T2_Calc	:= TRUE;					(* Engine start blocked *)	(* W9370 *)
				END_IF

			IF Para.bTSTC_Exist THEN
				IF	  NOT OUT_CH.bAMM_Pr_Ch_P1HP_Avg	THEN rPr_bHPTC		:= OUT_CH.rPr_Ch_P1HP_Max;
				ELSIF NOT OUT_CH.bAMM_Pr_Ch_P2LP_Avg	THEN rPr_bHPTC		:= OUT_CH.rPr_Ch_P2LP_Max - Para.rDPr_Ch_T2Calc_LP_Cooler;
														ELSE rPr_bHPTC		:= 0;
													 	 bAMM_T_Ch_T2_Calc	:= TRUE;					(* Engine start blocked *)	(* W9370 *)
				END_IF
			ELSE
				IF	  NOT OUT_CH.bAMM_Pr_Ch_P1HP_Avg	THEN rPr_bHPTC		:= OUT_CH.rPr_Ch_P1HP_Max;
				ELSIF NOT OUT_CH.bAMM_Pr_Ch_P1LP_Avg	THEN rPr_bHPTC		:= OUT_CH.rPr_Ch_P1LP_Max;
				ELSIF NOT IN_CH.bAMM_Pr_Baro_Internal	THEN rPr_bHPTC		:= IN_CH.rPr_Baro_Internal	- Para.rDPr_Ch_T2Calc_AirFilt;
				ELSIF NOT bAMM_T_Ch_T2_Calc 	AND 
						  IN_CH.rN_EngAct < 10			THEN rPr_bHPTC		:= rPr_aHPTC 				- Para.rDPr_Ch_T2Calc_AirFilt;
				END_IF
			END_IF

			(* calculation - T2 after high-pressure TC *)
			IF 	NOT bAMM_T_Ch_T2_Calc 			AND														(* Engine start released *)
				Para.rPc_Ch_T2Calc_HP_Eff <> 0	AND														(* no division by zero *)
				rPr_bHPTC 				  <> 0		THEN rT_Ch_T2HP_Max		:= (rT_Ch_T1HP_Max + 273.15) / Para.rPc_Ch_T2Calc_HP_Eff *
																			   ((rPr_aHPTC / rPr_bHPTC)**(0.38 / 1.38) - 1) + rT_Ch_T1HP_Max;
													ELSE rT_Ch_T2HP_Max		:= 0;
														 bAMM_T_Ch_T2_Calc	:= TRUE;					(* Engine start blocked *)	(* W9370 *)
			END_IF

			MM2VIS.rT_Ch_T2HP_Calc	:= rT_Ch_T2HP_Max * BOOL_TO_REAL(bStartSpd);						(* calculation only used during operation *)
		ELSE
			MM2VIS.rT_Ch_T2HP_Calc	:= 0;
			rT_Ch_T2HP_Max			:= MAX(IN_CH.tT_Ch_T2HP.Ai   * BOOL_TO_REAL(bRelMon_T2HP),
										   IN_CH.tT_Ch_T2HP_A.Ai * BOOL_TO_REAL(bRelMon_T2HP_A),
										   IN_CH.tT_Ch_T2HP_B.Ai * BOOL_TO_REAL(bRelMon_T2HP_B));
		END_IF

			(* power reduction of 4% per °C deviation to at least 80% *)
			xSigScal_R_P_Red_Ch_T2HP.X	:= rT_Ch_T2HP_Max;
			xSigScal_R_P_Red_Ch_T2HP.X1 := Para.rT_Ch_T2HP_HiHi - 5;
			xSigScal_R_P_Red_Ch_T2HP.X2	:= Para.rT_Ch_T2HP_HiHi;
			xSigScal_R_P_Red_Ch_T2HP.Y1 := 1.0;
			xSigScal_R_P_Red_Ch_T2HP.Y2 := 0.8;
			xSigScal_R_P_Red_Ch_T2HP();

			xRAMPE_R_P_Red_Ch_T2HP(In	:= xSigScal_R_P_Red_Ch_T2HP.Y_SCAL, enable := bStartSpd);

		IF Para.bCh_T2Calc_Active THEN
			OUT_CH.rP_Red_Ch_T2HP_Norm	:= LIMIT(0.8, xRAMPE_R_P_Red_Ch_T2HP.Out, 1);											(* B9075 *)
		END_IF
		
		bAMM_T_Ch_T2HP_HiHi				:= rT_Ch_T2HP_Max > Para.rT_Ch_T2HP_HiHi;										(* A2368 *)	(* A2369 *)
		OUT_CH.bRelEngStart_Ch_T2		:= NOT bAMM_T_Ch_T2_Calc;										(* Engine start released *)



		(* interpolation of T2' temperature max parameter *)
		Para.rT_Ch_T2s_Hi[0] 	:= Para.rT_Ch_T2s_Hi[1]  + (IN_CH.rGT_QualMix_1_2 * (Para.rT_Ch_T2s_Hi[2]  - Para.rT_Ch_T2s_Hi[1] ));
		Para.rP_Red_Ch_T2s[0]	:= Para.rP_Red_Ch_T2s[1] + (IN_CH.rGT_QualMix_1_2 * (Para.rP_Red_Ch_T2s[2] - Para.rP_Red_Ch_T2s[1]));

		Para.rT_Ch_T2s_Hi[0]	:= Para.rT_Ch_T2s_Hi[0]  + (IN_CH.rGT_RatioMix 	  * (Para.rT_Ch_T2s_Hi[3]  - Para.rT_Ch_T2s_Hi[0] ));
		Para.rP_Red_Ch_T2s[0] 	:= Para.rP_Red_Ch_T2s[0] + (IN_CH.rGT_RatioMix 	  * (Para.rP_Red_Ch_T2s[3] - Para.rP_Red_Ch_T2s[0]));

		(* charge temperature T2' maximum -> start power reduction *)
		IF bNetP_Island_20s 
		THEN
			bAMM_T_Ch_T2s_Hi 	:= (IN_CH.tT_Ch_T2s.Ai 	 > Para.rT_Ch_T2s_Hi[gastype]) AND bRelMon_T2s; 							(* W3411 *)
			bAMM_T_Ch_T2s_A_Hi	:= (IN_CH.tT_Ch_T2s_A.Ai > Para.rT_Ch_T2s_Hi[gastype]) AND bRelMon_T2s_A;							(* W2511 *)
			bAMM_T_Ch_T2s_B_Hi	:= (IN_CH.tT_Ch_T2s_B.Ai > Para.rT_Ch_T2s_Hi[gastype]) AND bRelMon_T2s_B;							(* W2513 *)
		END_IF

			(* Power reduction per °C inclination *) 																				(* B2126 *)
			IF bAMM_T_Ch_T2s_Hi OR bAMM_T_Ch_T2s_A_Hi OR bAMM_T_Ch_T2s_B_Hi	
			THEN
				IF bAMM_T_Ch_T2s_Hi	  THEN rP_Red_Ch_T2s   := (IN_CH.tT_Ch_T2s.Ai   - Para.rT_Ch_T2s_Hi[gastype]) *
																				 	  Para.rP_Red_Ch_T2s[gastype]; 	END_IF
				IF bAMM_T_Ch_T2s_A_Hi THEN rP_Red_Ch_T2s_A := (IN_CH.tT_Ch_T2s_A.Ai - Para.rT_Ch_T2s_Hi[gastype]) *
																				  	  Para.rP_Red_Ch_T2s[gastype]; 	END_IF
				IF bAMM_T_Ch_T2s_B_Hi THEN rP_Red_Ch_T2s_B := (IN_CH.tT_Ch_T2s_B.Ai - Para.rT_Ch_T2s_Hi[gastype]) *
																				  	  Para.rP_Red_Ch_T2s[gastype]; 	END_IF
				(* power reduction initiating at actual power *)
				OUT_CH.rP_Red_Ch_T2s_Norm := LIMIT(0, rP_Act_Norm_SaveT2s - MAX(rP_Red_Ch_T2s, rP_Red_Ch_T2s_A, rP_Red_Ch_T2s_B), 1);
			ELSE
				rP_Act_Norm_SaveT2s		  := IN_CH.rP_Act_Norm_Filt_TC2;				(* save actual power *)
			END_IF

		(* charge temperature T2' maximum -> ERROR *)
		IF bNetP_Island_20s 
		THEN
			bAMM_T_Ch_T2s_HiHi 		:= (IN_CH.tT_Ch_T2s.Ai 	 > Para.rT_Ch_T2s_HiHi) AND bRelMon_T2s;								(* A1040 *)
			bAMM_T_Ch_T2s_A_HiHi	:= (IN_CH.tT_Ch_T2s_A.Ai > Para.rT_Ch_T2s_HiHi) AND bRelMon_T2s_A;								(* A2216 *)
			bAMM_T_Ch_T2s_B_HiHi 	:= (IN_CH.tT_Ch_T2s_B.Ai > Para.rT_Ch_T2s_HiHi) AND bRelMon_T2s_B;								(* A2219 *)
		END_IF



		(*------------------------------------------------------------------*)
		(* temperature RATE OF CHANGE maximum (Änderungsgeschwindigkeit)	*)
		(*------------------------------------------------------------------*)
			(* Release monitoring	*)
			IF IN_CH.tEng_Run.Do 	THEN bRelMon_T2s_Roc := TRUE; 	END_IF
			IF NOT bStartSpd 		THEN bRelMon_T2s_Roc := FALSE; 	END_IF

		(* charge temperature T2' *)
		IF bRelMon_T2s_Roc THEN
			bAMM_T_Ch_T2s_RocHiHi	:= ((IN_CH.tT_Ch_T2s.Ai   - rT_Ch_T2s_Old) 	 > Para.rT_Ch_T2s_Roc_HiHi) AND bRelMon_T2s;		(* A1105 *)
			bAMM_T_Ch_T2s_A_RocHiHi	:= ((IN_CH.tT_Ch_T2s_A.Ai - rT_Ch_T2s_A_Old) > Para.rT_Ch_T2s_Roc_HiHi) AND bRelMon_T2s_A;		(* A2217 *)
			bAMM_T_Ch_T2s_B_RocHiHi	:= ((IN_CH.tT_Ch_T2s_B.Ai - rT_Ch_T2s_B_Old) > Para.rT_Ch_T2s_Roc_HiHi) AND bRelMon_T2s_B;		(* A2220 *)
		END_IF



		(*------------------------------------------------------------------*)
		(* temperature INCLINATION maximum (Spreizung)						*)
		(*------------------------------------------------------------------*)
		(* charge temperature T2' *)
		IF bP_Nom10_60s THEN
			bAMM_T_Ch_T2s_DiffHi 	:= (ABS(IN_CH.tT_Ch_T2s_A.Ai - IN_CH.tT_Ch_T2s_B.Ai) > Para.rT_Ch_T2s_Diff_Hi)	AND				(* W2525 *)
								   		bRelMon_T2s_A AND bRelMon_T2s_B;
		END_IF




		(*----------------------------------------------------------------------------------------------------------------------------------*)
		(* Handover charge temperature to other modules																						*)
		(*----------------------------------------------------------------------------------------------------------------------------------*)
		(* charge temperature before low-pressure TC *)
		IF 		bRelMon_T1LP	THEN  OUT_CH.rT_Ch_T1LP_Avg		:= IN_CH.tT_Ch_T1LP.Ai;
		ELSIF 	bRelMon_T1LP_A	THEN
			IF 	bRelMon_T1LP_B	THEN  OUT_CH.rT_Ch_T1LP_Avg		:=(IN_CH.tT_Ch_T1LP_A.Ai + IN_CH.tT_Ch_T1LP_B.Ai) / 2;
								ELSE  OUT_CH.rT_Ch_T1LP_Avg 	:= IN_CH.tT_Ch_T1LP_A.Ai;
			END_IF
		ELSIF 	bRelMon_T1LP_B	THEN  OUT_CH.rT_Ch_T1LP_Avg 	:= IN_CH.tT_Ch_T1LP_B.Ai;
								ELSE  OUT_CH.rT_Ch_T1LP_Avg 	:= 0;
									  OUT_CH.bAMM_T_Ch_T1LP_Avg	:= TRUE;
		END_IF

		MM2VIS.rT_Ch_T1LP_Avg	:= OUT_CH.rT_Ch_T1LP_Avg;				(* VISU *)


		(* charge temperature before high-pressure TC *)
		IF 		bRelMon_T1HP	THEN  OUT_CH.rT_Ch_T1HP_Avg		:= IN_CH.tT_Ch_T1HP.Ai;
		ELSIF 	bRelMon_T1HP_A	THEN
			IF 	bRelMon_T1HP_B	THEN  OUT_CH.rT_Ch_T1HP_Avg		:=(IN_CH.tT_Ch_T1HP_A.Ai + IN_CH.tT_Ch_T1HP_B.Ai) / 2;
								ELSE  OUT_CH.rT_Ch_T1HP_Avg 	:= IN_CH.tT_Ch_T1HP_A.Ai;
			END_IF
		ELSIF 	bRelMon_T1HP_B	THEN  OUT_CH.rT_Ch_T1HP_Avg 	:= IN_CH.tT_Ch_T1HP_B.Ai;
								ELSE  OUT_CH.rT_Ch_T1HP_Avg 	:= 0;
									  OUT_CH.bAMM_T_Ch_T1HP_Avg	:= TRUE;
		END_IF

		MM2VIS.rT_Ch_T1HP_Avg	:= OUT_CH.rT_Ch_T1HP_Avg;				(* VISU *)


		(* charge temperature t2' *)
		IF 	 bRelMon_T2s		THEN	OUT_CH.rT_Ch_T2s_Avg_UF	:= IN_CH.tT_Ch_T2s.Unfilt;
										OUT_CH.rT_Ch_T2s_Avg 	:= IN_CH.tT_Ch_T2s.Ai;
										OUT_CH.rT_Ch_T2s_A 		:= 0;
										OUT_CH.rT_Ch_T2s_B 		:= 0;
		ELSIF  	 bRelMon_T2s_A	THEN
			IF 	 bRelMon_T2s_B 	THEN 	OUT_CH.rT_Ch_T2s_Avg_UF	:=(IN_CH.tT_Ch_T2s_A.Unfilt + IN_CH.tT_Ch_T2s_B.Unfilt) / 2;
										OUT_CH.rT_Ch_T2s_Avg	:=(IN_CH.tT_Ch_T2s_A.Ai     + IN_CH.tT_Ch_T2s_B.Ai) 	/ 2;
										OUT_CH.rT_Ch_T2s_A 		:= IN_CH.tT_Ch_T2s_A.Ai;
										OUT_CH.rT_Ch_T2s_B 		:= IN_CH.tT_Ch_T2s_B.Ai;

								ELSE	OUT_CH.rT_Ch_T2s_Avg_UF	:= IN_CH.tT_Ch_T2s_A.Unfilt;
										OUT_CH.rT_Ch_T2s_Avg 	:= IN_CH.tT_Ch_T2s_A.Ai;
										OUT_CH.rT_Ch_T2s_A 		:= IN_CH.tT_Ch_T2s_A.Ai;
										OUT_CH.rT_Ch_T2s_B 		:= IN_CH.tT_Ch_T2s_A.Ai;
			END_IF

		ELSIF  	bRelMon_T2s_B 	THEN 	OUT_CH.rT_Ch_T2s_Avg_UF := IN_CH.tT_Ch_T2s_B.Unfilt;
										OUT_CH.rT_Ch_T2s_Avg 	:= IN_CH.tT_Ch_T2s_B.Ai;
										OUT_CH.rT_Ch_T2s_A 		:= IN_CH.tT_Ch_T2s_B.Ai;
										OUT_CH.rT_Ch_T2s_B 		:= IN_CH.tT_Ch_T2s_B.Ai;

								 ELSE	(* J920: Handover parameter-value if both sensors with error *)
										OUT_CH.rT_Ch_T2s_Avg_UF	:= Para.rT_Ch_T2s_Hi[gastype] * BOOL_TO_REAL(xEngType.Type9);
										OUT_CH.rT_Ch_T2s_Avg 	:= Para.rT_Ch_T2s_Hi[gastype] * BOOL_TO_REAL(xEngType.Type9);
										OUT_CH.rT_Ch_T2s_A 		:= Para.rT_Ch_T2s_Hi[gastype] * BOOL_TO_REAL(xEngType.Type9);
										OUT_CH.rT_Ch_T2s_B 		:= Para.rT_Ch_T2s_Hi[gastype] * BOOL_TO_REAL(xEngType.Type9);
										OUT_CH.bAMM_T_Ch_T2s_Avg:= NOT xEngType.Type9;
		END_IF

		MM2VIS.rT_Ch_T2s_Avg := OUT_CH.rT_Ch_T2s_Avg;					(* VISU *)

	ELSE
		xTON_RelMon_T1LP(IN	 := FALSE);
		xTON_RelMon_T1LP_A(IN:= FALSE);
		xTON_RelMon_T1LP_B(IN:= FALSE);
		xTON_RelMon_T2LP(IN	 := FALSE);
		xTON_RelMon_T2LP_A(IN:= FALSE);
		xTON_RelMon_T2LP_B(IN:= FALSE);
		xTON_RelMon_T1HP(IN	 := FALSE);
		xTON_RelMon_T1HP_A(IN:= FALSE);
		xTON_RelMon_T1HP_B(IN:= FALSE);
		xTON_RelMon_T2HP(IN	 := FALSE);
		xTON_RelMon_T2HP_A(IN:= FALSE);
		xTON_RelMon_T2HP_B(IN:= FALSE);
		xTON_RelMon_T2s(IN	 := FALSE);
		xTON_RelMon_T2s_A(IN := FALSE);
		xTON_RelMon_T2s_B(IN := FALSE);
	END_IF

END_PROGRAM
