(*************************************************************************************************************************************
CH_Press	 		 Charging pressures 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2021


Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	19.09.2012	Tinello		restructured 
V04.04.00.00	31.10.2016	Tinello		add Pr_Ch_P1LP,Pr_Ch_P2LP, Pr_Ch_P2HP, Pr_Ch_P2bFA -> Spec. (b) & (c)
V04.05.00.00	12.07.2017	Tinello		SWAT 3/J920 -> Spec (d)
V04.05.02.00	16.04.2018	Tinello		enable P2s value forwarding to other SW modules also in op.switch OFF mode
V04.07.00.00	24.03.2019	Tinello		MsErr active with op.switch OFF mode / Calculation of difference pressure adjusted 
										Pressure average values forwarding to other SW modules -> Spec (e)
V04.10.00.00	27.01.2021	Tinello		BugFix: Timer-FuB's
V04.12.00.00	25.01.2023	Tinello		Pressure maximum values forwarding to other SW modules
V04.14.00.00    20.06.2024	Soto		Pressure signals plausibility check during standstill

(************************************************************************************************************************************)
PROGRAM _INIT
	rPr_Ch_Max 		:= 1.3;
	rPr_Ch_Min 		:= 0.8; 
	rPr_Ch_devMax 	:= 0.08;
	iPr_Ch_lgt 		:= 18;
	tPr_Ch[0].Tag 	:= 'E.08-PI-001';		
	tPr_Ch[1].Tag 	:= 'M.05-PI-150';
	tPr_Ch[2].Tag 	:= 'M.05-PI-250';
	tPr_Ch[3].Tag 	:= 'E.08-PI-002';
	tPr_Ch[4].Tag 	:= 'M.05-PI-151';
	tPr_Ch[5].Tag 	:= 'M.05-PI-251';
	tPr_Ch[6].Tag 	:= 'M.08-PI-011';	
	tPr_Ch[7].Tag 	:= 'M.05-PI-147';
	tPr_Ch[8].Tag 	:= 'M.05-PI-247';
	tPr_Ch[9].Tag 	:= 'E.08-PI-003';
	tPr_Ch[10].Tag 	:= 'E.08-PI-004';
	tPr_Ch[11].Tag 	:= 'M.05-PI-149';
	tPr_Ch[12].Tag 	:= 'M.05-PI-249';
	tPr_Ch[13].Tag 	:= 'M.08-PI-007';
	tPr_Ch[14].Tag 	:= 'M.08-PI-007/M.05-PI-148';
	tPr_Ch[15].Tag 	:= 'M.08-PI-008/M.05-PI-248';
	tPr_Ch[16].Tag 	:= 'M.05-PI-146';
	tPr_Ch[17].Tag 	:= 'M.05-PI-246';
END_PROGRAM

PROGRAM _CYCLIC	

	(*--------------------------------------------------*)
	(* RESET of alarms and warnings 					*)
	(*--------------------------------------------------*)
	xTON_200msTick(IN:= NOT xTON_200msTick.Q, PT:= T#180ms);							(* 180ms + 2x cycle time = 200 ms *)

	IF xTON_200msTick.Q THEN															(* to notice the alarm in 100ms Task *)
	    bAMM_Pr_Ch_P1LP_A_Ms	:= FALSE;
	    bAMM_Pr_Ch_P1LP_B_Ms	:= FALSE;

		bAMM_Pr_Ch_P2LP_Ms		:= FALSE;
		bAMM_Pr_Ch_P2LP_A_Ms	:= FALSE;
	    bAMM_Pr_Ch_P2LP_B_Ms	:= FALSE;

		bAMM_Pr_Ch_P1HP_Ms		:= FALSE;
		bAMM_Pr_Ch_P1HP_A_Ms	:= FALSE;
		bAMM_Pr_Ch_P1HP_B_Ms	:= FALSE;
		
		bAMM_Pr_Ch_P2HP_Ms		:= FALSE;
		bAMM_Pr_Ch_P2HP_A_Ms	:= FALSE;
		bAMM_Pr_Ch_P2HP_B_Ms	:= FALSE;

	    bAMM_Pr_Ch_P2bFA_Ms		:= FALSE;

		bAMM_Pr_Ch_P2_MsMs		:= FALSE;
		bAMM_Pr_Ch_P2_A_Ms		:= FALSE;
		bAMM_Pr_Ch_P2_B_Ms		:= FALSE;
		bAMM_Pr_Ch_P2_Sum_MsMs	:= FALSE;

		bAMM_Pr_Ch_P2s_MsMs		:= FALSE;
		bAMM_Pr_Ch_P2s_A_Ms		:= FALSE;
		bAMM_Pr_Ch_P2s_B_Ms		:= FALSE;
		
		bAMM_DPr_Ch_P2_Hi		:= FALSE;
		bAMM_DPr_Ch_P2s_Hi		:= FALSE;
		bAMM_DPr_Ch_P2s_HiHi	:= FALSE;

		bAMM_DPr_Ch_LPCooler_Hi	:= FALSE;
		bAMM_DPr_Ch_HPCooler_Hi	:= FALSE;
		bAMM_DPr_Ch_FA_Hi		:= FALSE;
	END_IF

	OUT_CH.bAMM_Pr_Ch_P2s_Avg	:= FALSE;								(* collective warning *)
	OUT_CH.bAMM_Pr_Ch_P2_Avg	:= FALSE;
	OUT_CH.bAMM_Pr_Ch_P2HP_Avg	:= FALSE;
	OUT_CH.bAMM_Pr_Ch_P1HP_Avg	:= FALSE;
	OUT_CH.bAMM_Pr_Ch_P2LP_Avg	:= FALSE;
	OUT_CH.bAMM_Pr_Ch_P1LP_Avg	:= FALSE;


	(*--------------------------------------------------*)
	(* VISU var of module 								*)
	(*--------------------------------------------------*)
	MM2VIS.rPr_Ch_P1LP_A		:= IN_CH.tPr_Ch_P1LP_A.Ai;
	MM2VIS.rPr_Ch_P1LP_B		:= IN_CH.tPr_Ch_P1LP_B.Ai;

	MM2VIS.rPr_Ch_P2LP      	:= IN_CH.tPr_Ch_P2LP.Ai;
	MM2VIS.rPr_Ch_P2LP_A      	:= IN_CH.tPr_Ch_P2LP_A.Ai;
	MM2VIS.rPr_Ch_P2LP_B      	:= IN_CH.tPr_Ch_P2LP_B.Ai;

	MM2VIS.rPr_Ch_P1HP			:= IN_CH.tPr_Ch_P1HP.Ai;
	MM2VIS.rPr_Ch_P1HP_A		:= IN_CH.tPr_Ch_P1HP_A.Ai;
	MM2VIS.rPr_Ch_P1HP_B		:= IN_CH.tPr_Ch_P1HP_B.Ai;

	MM2VIS.rPr_Ch_P2HP			:= IN_CH.tPr_Ch_P2HP.Ai;
	MM2VIS.rPr_Ch_P2HP_A		:= IN_CH.tPr_Ch_P2HP_A.Ai;
	MM2VIS.rPr_Ch_P2HP_B		:= IN_CH.tPr_Ch_P2HP_B.Ai;

	MM2VIS.rPr_Ch_P2bFA			:= IN_CH.tPr_Ch_P2bFA.Ai;

	MM2VIS.rPr_Ch_P2			:= IN_CH.tPr_Ch_P2.Ai;
	MM2VIS.rPr_Ch_P2_A			:= IN_CH.tPr_Ch_P2_A.Ai;
	MM2VIS.rPr_Ch_P2_B			:= IN_CH.tPr_Ch_P2_B.Ai;

	MM2VIS.rPr_Ch_P2s			:= IN_CH.tPr_Ch_P2s.Ai;
	MM2VIS.rPr_Ch_P2s_A			:= IN_CH.tPr_Ch_P2s_A.Ai;
	MM2VIS.rPr_Ch_P2s_B			:= IN_CH.tPr_Ch_P2s_B.Ai;
	MM2VIS.rPr_Ch_P2s_UF		:= IN_CH.tPr_Ch_P2s.Unfilt;				(* Only for trending *)
	MM2VIS.rPr_Ch_P2s_A_UF		:= IN_CH.tPr_Ch_P2s_A.Unfilt;			(* Only for trending *)
	MM2VIS.rPr_Ch_P2s_B_UF		:= IN_CH.tPr_Ch_P2s_B.Unfilt;			(* Only for trending *)

	MM2VIS.rDPr_Ch_LPCooler		:= 0;
	MM2VIS.rDPr_Ch_HPCooler		:= 0;
	MM2VIS.rDPr_Ch_FA			:= 0;


	(*------------------------------------------------------------------------------------------------------------------------------*)
	(* release for error monitoring 																								*)
	(*------------------------------------------------------------------------------------------------------------------------------*)
	IF bRelModul_ParaSetupOk AND IN_CH.tPB2MM.bSys_Run THEN

		(*----------------------------------------------*)
		(* measurement signal failure 					*)
		(*----------------------------------------------*)
		(* charge pressure p1 before low pressure TC *)
		bAMM_Pr_Ch_P1LP_A_Ms		:= Para.bPr_Ch_P1LP_A_Exist	AND NOT IN_CH.tPr_Ch_P1LP_A.GoodQual;						(* W2779 *)
		bAMM_Pr_Ch_P1LP_B_Ms		:= Para.bPr_Ch_P1LP_B_Exist	AND NOT IN_CH.tPr_Ch_P1LP_B.GoodQual;						(* W2780 *)

			(* release monitoring - delayed reswitch to valid meas.value *)
			xTON_RelMon_P1LP_A(IN	:= Para.bPr_Ch_P1LP_A_Exist AND NOT bAMM_Pr_Ch_P1LP_A_Ms, 	PT:= T#10s);
			xTON_RelMon_P1LP_B(IN	:= Para.bPr_Ch_P1LP_B_Exist AND NOT bAMM_Pr_Ch_P1LP_B_Ms, 	PT:= T#10s);
			bRelMon_P1LP_A			:= xTON_RelMon_P1LP_A.Q;
			bRelMon_P1LP_B			:= xTON_RelMon_P1LP_B.Q;


		(* charge pressure p2 after low pressure TC *)
	    bAMM_Pr_Ch_P2LP_Ms			:= Para.bPr_Ch_P2LP_Exist  	AND NOT IN_CH.tPr_Ch_P2LP.GoodQual;							(* W2668 *)
	    bAMM_Pr_Ch_P2LP_A_Ms		:= Para.bPr_Ch_P2LP_A_Exist AND NOT IN_CH.tPr_Ch_P2LP_A.GoodQual;						(* W2409 *)
	    bAMM_Pr_Ch_P2LP_B_Ms		:= Para.bPr_Ch_P2LP_B_Exist AND NOT IN_CH.tPr_Ch_P2LP_B.GoodQual;						(* W2410 *)

			(* release monitoring - delayed reswitch to valid meas.value *)
			xTON_RelMon_P2LP(IN		:= Para.bPr_Ch_P2LP_Exist   AND NOT bAMM_Pr_Ch_P2LP_Ms,  	PT:= T#10s);
			xTON_RelMon_P2LP_A(IN	:= Para.bPr_Ch_P2LP_A_Exist AND NOT bAMM_Pr_Ch_P2LP_A_Ms, 	PT:= T#10s);
			xTON_RelMon_P2LP_B(IN	:= Para.bPr_Ch_P2LP_B_Exist AND NOT bAMM_Pr_Ch_P2LP_B_Ms, 	PT:= T#10s);
			bRelMon_P2LP			:= xTON_RelMon_P2LP.Q;
			bRelMon_P2LP_A			:= xTON_RelMon_P2LP_A.Q;
			bRelMon_P2LP_B			:= xTON_RelMon_P2LP_B.Q;


		(* charge pressure p1 before high pressure TC *)
		bAMM_Pr_Ch_P1HP_Ms	 		:= Para.bPr_Ch_P1HP_Exist	AND NOT IN_CH.tPr_Ch_P1HP.GoodQual;				(* W2618 *)	(* W9240 *)
		bAMM_Pr_Ch_P1HP_A_Ms		:= Para.bPr_Ch_P1HP_A_Exist	AND NOT IN_CH.tPr_Ch_P1HP_A.GoodQual;			(* W2611 *)	(* W9241 *)
		bAMM_Pr_Ch_P1HP_B_Ms 		:= Para.bPr_Ch_P1HP_B_Exist	AND NOT IN_CH.tPr_Ch_P1HP_B.GoodQual;			(* W2612 *)	(* W9242 *)

			(* release monitoring - delayed reswitch to valid meas.value *)
			xTON_RelMon_P1HP(IN		:= Para.bPr_Ch_P1HP_Exist   AND NOT bAMM_Pr_Ch_P1HP_Ms,  	PT:= T#10s);
			xTON_RelMon_P1HP_A(IN	:= Para.bPr_Ch_P1HP_A_Exist AND NOT bAMM_Pr_Ch_P1HP_A_Ms, 	PT:= T#10s);
			xTON_RelMon_P1HP_B(IN	:= Para.bPr_Ch_P1HP_B_Exist AND NOT bAMM_Pr_Ch_P1HP_B_Ms, 	PT:= T#10s);
			bRelMon_P1HP			:= xTON_RelMon_P1HP.Q;
			bRelMon_P1HP_A			:= xTON_RelMon_P1HP_A.Q;
			bRelMon_P1HP_B			:= xTON_RelMon_P1HP_B.Q;


		(* charge pressure p2 after high pressure TC *)
	    bAMM_Pr_Ch_P2HP_Ms			:= Para.bPr_Ch_P2HP_Exist  	AND NOT IN_CH.tPr_Ch_P2HP.GoodQual;				(* W2669 *)	(* W9237 *)
	    bAMM_Pr_Ch_P2HP_A_Ms		:= Para.bPr_Ch_P2HP_A_Exist AND NOT IN_CH.tPr_Ch_P2HP_A.GoodQual;			(* W2407 *)	(* W9238 *)
	    bAMM_Pr_Ch_P2HP_B_Ms		:= Para.bPr_Ch_P2HP_B_Exist AND NOT IN_CH.tPr_Ch_P2HP_B.GoodQual;			(* W2408 *)	(* W9239 *)

			(* release monitoring - delayed reswitch to valid meas.value *)
			xTON_RelMon_P2HP(IN		:= Para.bPr_Ch_P2HP_Exist   AND NOT bAMM_Pr_Ch_P2HP_Ms,  	PT:= T#10s);
			xTON_RelMon_P2HP_A(IN	:= Para.bPr_Ch_P2HP_A_Exist AND NOT bAMM_Pr_Ch_P2HP_A_Ms, 	PT:= T#10s);
			xTON_RelMon_P2HP_B(IN	:= Para.bPr_Ch_P2HP_B_Exist AND NOT bAMM_Pr_Ch_P2HP_B_Ms, 	PT:= T#10s);
			bRelMon_P2HP			:= xTON_RelMon_P2HP.Q;
			bRelMon_P2HP_A			:= xTON_RelMon_P2HP_A.Q;
			bRelMon_P2HP_B			:= xTON_RelMon_P2HP_B.Q;


		(* charge pressure p2 before flame arrester *)
	    bAMM_Pr_Ch_P2bFA_Ms			:= Para.bPr_Ch_P2bFA_Exist 	AND NOT IN_CH.tPr_Ch_P2bFA.GoodQual;						(* W2670 *)

			(* release monitoring - delayed reswitch to valid meas.value *)
			xTON_RelMon_P2bFA(IN	:= Para.bPr_Ch_P2bFA_Exist	AND NOT bAMM_Pr_Ch_P2bFA_Ms,  	PT:= T#10s);
			bRelMon_P2bFA			:= xTON_RelMon_P2bFA.Q;


		(* charge pressure p2 *)
		bAMM_Pr_Ch_P2_MsMs 			:= Para.bPr_Ch_P2_Exist		AND NOT IN_CH.tPr_Ch_P2.GoodQual;							(* A1077 *)
		bAMM_Pr_Ch_P2_A_Ms 			:= Para.bPr_Ch_P2_A_Exist	AND NOT IN_CH.tPr_Ch_P2_A.GoodQual;							(* W2541 *)
		bAMM_Pr_Ch_P2_B_Ms			:= Para.bPr_Ch_P2_B_Exist	AND NOT IN_CH.tPr_Ch_P2_B.GoodQual;							(* W2543 *)

			(* release monitoring - delayed reswitch to valid meas.value *)
			xTON_RelMon_P2(IN		:= Para.bPr_Ch_P2_Exist   	AND NOT bAMM_Pr_Ch_P2_MsMs,  	PT:= T#10s);
			xTON_RelMon_P2_A(IN		:= Para.bPr_Ch_P2_A_Exist 	AND NOT bAMM_Pr_Ch_P2_A_Ms, 	PT:= T#10s);
			xTON_RelMon_P2_B(IN		:= Para.bPr_Ch_P2_B_Exist 	AND NOT bAMM_Pr_Ch_P2_B_Ms, 	PT:= T#10s);
			bRelMon_P2				:= xTON_RelMon_P2.Q;
			bRelMon_P2_A			:= xTON_RelMon_P2_A.Q;
			bRelMon_P2_B			:= xTON_RelMon_P2_B.Q;


		(* charge pressure p2' *)
		bAMM_Pr_Ch_P2s_MsMs 		:= Para.bPr_Ch_P2s_Exist	AND NOT IN_CH.tPr_Ch_P2s.GoodQual;							(* A1078 *)
		bAMM_Pr_Ch_P2s_A_Ms 		:= Para.bPr_Ch_P2s_A_Exist	AND NOT IN_CH.tPr_Ch_P2s_A.GoodQual;						(* W2539 *)
		bAMM_Pr_Ch_P2s_B_Ms 		:= Para.bPr_Ch_P2s_B_Exist	AND NOT IN_CH.tPr_Ch_P2s_B.GoodQual;						(* W2540 *)

			(* release monitoring	*)
			xTON_RelMon_P2s(IN		:= Para.bPr_Ch_P2s_Exist   	AND NOT bAMM_Pr_Ch_P2s_MsMs,  	PT:= T#10s);
			xTON_RelMon_P2s_A(IN	:= Para.bPr_Ch_P2s_A_Exist 	AND NOT bAMM_Pr_Ch_P2s_A_Ms, 	PT:= T#10s);
			xTON_RelMon_P2s_B(IN	:= Para.bPr_Ch_P2s_B_Exist 	AND NOT bAMM_Pr_Ch_P2s_B_Ms, 	PT:= T#10s);
			bRelMon_P2s				:= xTON_RelMon_P2s.Q;
			bRelMon_P2s_A			:= xTON_RelMon_P2s_A.Q;
			bRelMon_P2s_B			:= xTON_RelMon_P2s_B.Q;



		(* sum failure after a time delay of 48 hours in case of p2 or p2' measuring failure *)
		xTON_ErrMs(IN 				:= bAMM_Pr_Ch_P2s_A_Ms OR bAMM_Pr_Ch_P2s_B_Ms OR bAMM_Pr_Ch_P2_A_Ms OR bAMM_Pr_Ch_P2_B_Ms, 
				   PT 				:= T#48h);

		bAMM_Pr_Ch_P2_Sum_MsMs  	:= (xTON_ErrMs.Q AND NOT xEngType.Type9) OR												(* A1078 *)
									   (* measuring failure at all p2 and p2' sensors *)
									   ((bAMM_Pr_Ch_P2s_MsMs   	OR NOT Para.bPr_Ch_P2s_Exist)	AND
										(bAMM_Pr_Ch_P2s_A_Ms 	OR NOT Para.bPr_Ch_P2s_A_Exist) AND
										(bAMM_Pr_Ch_P2s_B_Ms 	OR NOT Para.bPr_Ch_P2s_B_Exist) AND
										(bAMM_Pr_Ch_P2_MsMs		OR NOT Para.bPr_Ch_P2_Exist)	AND
										(bAMM_Pr_Ch_P2_A_Ms  	OR NOT Para.bPr_Ch_P2_A_Exist)  AND
										(bAMM_Pr_Ch_P2_B_Ms		OR NOT Para.bPr_Ch_P2_B_Exist)	   );



		(*----------------------------------------------*)
		(* charge pressure deviation (Spreizung)		*)
		(*----------------------------------------------*)
		bDPr_P2_Hi			:= (ABS(IN_CH.tPr_Ch_P2_A.Ai  - IN_CH.tPr_Ch_P2_B.Ai)  > Para.rPr_Ch_P2s_Diff_HiHi)	AND
							   	bRelMon_P2_A							   	 									AND
								bRelMon_P2_B;

		bDPr_P2s_Hi			:= (ABS(IN_CH.tPr_Ch_P2s_A.Ai - IN_CH.tPr_Ch_P2s_B.Ai) > Para.rPr_Ch_P2s_Diff_HiHi) AND
							    bRelMon_P2s_A 						     										AND
								bRelMon_P2s_B;

		IF bP_Nom10_60s THEN
			bAMM_DPr_Ch_P2_Hi		:=  bDPr_P2_Hi;																			(* W2530 *)
			bAMM_DPr_Ch_P2s_Hi		:= (bDPr_P2s_Hi AND 	xEngType.Type9);												(* W2530 *)
			bAMM_DPr_Ch_P2s_HiHi	:= (bDPr_P2s_Hi AND NOT xEngType.Type9) OR 												(* A2236 *)
									   (bDPr_P2_Hi  AND (bAMM_Pr_Ch_P2s_A_Ms OR bAMM_Pr_Ch_P2s_B_Ms));
		END_IF



		(*--------------------------------------------------------------------------------------------------------------------------*)
		(* Handover charge pressure to other modules																				*)
		(*--------------------------------------------------------------------------------------------------------------------------*)
		(* charge pressure p2' *)
		IF 		bRelMon_P2s 		 THEN 	OUT_CH.rPr_Ch_P2s_Avg 		:= IN_CH.tPr_Ch_P2s.Ai;
											OUT_CH.rPr_Ch_P2s_Max		:= IN_CH.tPr_Ch_P2s.Ai;
											OUT_CH.rPr_Ch_P2s_A 		:= 0;
											OUT_CH.rPr_Ch_P2s_B 		:= 0;
											OUT_CH.rPr_Ch_P2s_Avg_UF 	:= IN_CH.tPr_Ch_P2s.Unfilt;
											OUT_CH.rPr_Ch_P2s_A_UF 		:= 0;
											OUT_CH.rPr_Ch_P2s_B_UF 		:= 0;
		ELSE
			IF 	bRelMon_P2s_A 	 	THEN
				IF bRelMon_P2s_B 	THEN	OUT_CH.rPr_Ch_P2s_Avg		:=(IN_CH.tPr_Ch_P2s_A.Ai + IN_CH.tPr_Ch_P2s_B.Ai) / 2;
											OUT_CH.rPr_Ch_P2s_Max		:= MAX(IN_CH.tPr_Ch_P2s_A.Ai, IN_CH.tPr_Ch_P2s_B.Ai);
											OUT_CH.rPr_Ch_P2s_A 		:= IN_CH.tPr_Ch_P2s_A.Ai;
											OUT_CH.rPr_Ch_P2s_B 		:= IN_CH.tPr_Ch_P2s_B.Ai;
											OUT_CH.rPr_Ch_P2s_Avg_UF	:=(IN_CH.tPr_Ch_P2s_A.Unfilt + IN_CH.tPr_Ch_P2s_B.Unfilt) /2;
											OUT_CH.rPr_Ch_P2s_A_UF 		:= IN_CH.tPr_Ch_P2s_A.Unfilt;
											OUT_CH.rPr_Ch_P2s_B_UF 		:= IN_CH.tPr_Ch_P2s_B.Unfilt;
									ELSE	OUT_CH.rPr_Ch_P2s_Avg 		:= IN_CH.tPr_Ch_P2s_A.Ai;
											OUT_CH.rPr_Ch_P2s_Max		:= IN_CH.tPr_Ch_P2s_A.Ai;
											OUT_CH.rPr_Ch_P2s_A 		:= IN_CH.tPr_Ch_P2s_A.Ai;
											OUT_CH.rPr_Ch_P2s_B 		:= IN_CH.tPr_Ch_P2s_A.Ai;
											OUT_CH.rPr_Ch_P2s_Avg_UF 	:= IN_CH.tPr_Ch_P2s_A.Unfilt;
											OUT_CH.rPr_Ch_P2s_A_UF 		:= IN_CH.tPr_Ch_P2s_A.Unfilt;
											OUT_CH.rPr_Ch_P2s_B_UF 		:= IN_CH.tPr_Ch_P2s_A.Unfilt;
				END_IF
			ELSE
				IF bRelMon_P2s_B 	THEN	OUT_CH.rPr_Ch_P2s_Avg 		:= IN_CH.tPr_Ch_P2s_B.Ai;
											OUT_CH.rPr_Ch_P2s_Max		:= IN_CH.tPr_Ch_P2s_B.Ai;
											OUT_CH.rPr_Ch_P2s_A 		:= IN_CH.tPr_Ch_P2s_B.Ai;
											OUT_CH.rPr_Ch_P2s_B 		:= IN_CH.tPr_Ch_P2s_B.Ai;
											OUT_CH.rPr_Ch_P2s_Avg_UF 	:= IN_CH.tPr_Ch_P2s_B.Unfilt;
											OUT_CH.rPr_Ch_P2s_A_UF 		:= IN_CH.tPr_Ch_P2s_B.Unfilt;
											OUT_CH.rPr_Ch_P2s_B_UF 		:= IN_CH.tPr_Ch_P2s_B.Unfilt;
									ELSE	OUT_CH.rPr_Ch_P2s_Avg 		:= 0;
											OUT_CH.rPr_Ch_P2s_Max		:= 0;
											OUT_CH.rPr_Ch_P2s_A 		:= 0;
											OUT_CH.rPr_Ch_P2s_B 		:= 0;
											OUT_CH.rPr_Ch_P2s_Avg_UF 	:= 0;
											OUT_CH.rPr_Ch_P2s_A_UF 		:= 0;
											OUT_CH.rPr_Ch_P2s_B_UF 		:= 0;
											OUT_CH.bAMM_Pr_Ch_P2s_Avg	:= TRUE;
				END_IF
			END_IF
		END_IF
	
		MM2VIS.rPr_Ch_P2s_Avg	:= OUT_CH.rPr_Ch_P2s_Avg;					(* VISU *)
	
	
		(* charge pressure p2 *)
		IF 		bRelMon_P2 	 		THEN 	OUT_CH.rPr_Ch_P2_Avg 		:= IN_CH.tPr_Ch_P2.Ai;
											OUT_CH.rPr_Ch_P2_Max		:= IN_CH.tPr_Ch_P2.Ai;
		ELSE
			IF 	bRelMon_P2_A 		THEN
				IF bRelMon_P2_B		THEN	OUT_CH.rPr_Ch_P2_Avg		:=(IN_CH.tPr_Ch_P2_A.Ai + IN_CH.tPr_Ch_P2_B.Ai) / 2;
											OUT_CH.rPr_Ch_P2_Max		:= MAX(IN_CH.tPr_Ch_P2_A.Ai, IN_CH.tPr_Ch_P2_B.Ai);
							 		ELSE	OUT_CH.rPr_Ch_P2_Avg 		:= IN_CH.tPr_Ch_P2_A.Ai;
											OUT_CH.rPr_Ch_P2_Max		:= IN_CH.tPr_Ch_P2_A.Ai;
				END_IF
			ELSE
				IF bRelMon_P2_B 	THEN	OUT_CH.rPr_Ch_P2_Avg 		:= IN_CH.tPr_Ch_P2_B.Ai;
											OUT_CH.rPr_Ch_P2_Max		:= IN_CH.tPr_Ch_P2_B.Ai;
									ELSE	OUT_CH.rPr_Ch_P2_Avg 		:= 0;
											OUT_CH.rPr_Ch_P2_Max		:= 0;
											OUT_CH.bAMM_Pr_Ch_P2_Avg	:= TRUE;
				END_IF
			END_IF
		END_IF
	
		MM2VIS.rPr_Ch_P2_Avg	:= OUT_CH.rPr_Ch_P2_Avg;					(* VISU *)
	
	
		(* charge pressure after high-pressure TC *)
		IF 		bRelMon_P2HP 	 	THEN 	OUT_CH.rPr_Ch_P2HP_Avg 		:= IN_CH.tPr_Ch_P2HP.Ai;
											OUT_CH.rPr_Ch_P2HP_Max		:= IN_CH.tPr_Ch_P2HP.Ai;
		ELSE
			IF 	bRelMon_P2HP_A 		THEN
				IF bRelMon_P2HP_B	THEN	OUT_CH.rPr_Ch_P2HP_Avg		:=(IN_CH.tPr_Ch_P2HP_A.Ai + IN_CH.tPr_Ch_P2HP_B.Ai) / 2;
											OUT_CH.rPr_Ch_P2HP_Max		:= MAX(IN_CH.tPr_Ch_P2HP_A.Ai, IN_CH.tPr_Ch_P2HP_B.Ai);
							 		ELSE	OUT_CH.rPr_Ch_P2HP_Avg 		:= IN_CH.tPr_Ch_P2HP_A.Ai;
											OUT_CH.rPr_Ch_P2HP_Max		:= IN_CH.tPr_Ch_P2HP_A.Ai;
				END_IF
			ELSE
				IF bRelMon_P2HP_B 	THEN	OUT_CH.rPr_Ch_P2HP_Avg 		:= IN_CH.tPr_Ch_P2HP_B.Ai;
											OUT_CH.rPr_Ch_P2HP_Max		:= IN_CH.tPr_Ch_P2HP_B.Ai;
									ELSE	OUT_CH.rPr_Ch_P2HP_Avg 		:= 0;
											OUT_CH.rPr_Ch_P2HP_Max		:= 0;
											OUT_CH.bAMM_Pr_Ch_P2HP_Avg	:= TRUE;
				END_IF
			END_IF
		END_IF
	
		MM2VIS.rPr_Ch_P2HP_Avg	:= OUT_CH.rPr_Ch_P2HP_Avg;					(* VISU *)
	
	
		(* charge pressure before high-pressure TC *)
		IF 		bRelMon_P1HP 	 	THEN 	OUT_CH.rPr_Ch_P1HP_Avg 		:= IN_CH.tPr_Ch_P1HP.Ai;
											OUT_CH.rPr_Ch_P1HP_Max		:= IN_CH.tPr_Ch_P1HP.Ai;
		ELSE
			IF 	bRelMon_P1HP_A 		THEN
				IF bRelMon_P1HP_B	THEN	OUT_CH.rPr_Ch_P1HP_Avg		:=(IN_CH.tPr_Ch_P1HP_A.Ai + IN_CH.tPr_Ch_P1HP_B.Ai) / 2;
											OUT_CH.rPr_Ch_P1HP_Max		:= MAX(IN_CH.tPr_Ch_P1HP_A.Ai, IN_CH.tPr_Ch_P1HP_B.Ai);
							 		ELSE	OUT_CH.rPr_Ch_P1HP_Avg 		:= IN_CH.tPr_Ch_P1HP_A.Ai;
											OUT_CH.rPr_Ch_P1HP_Max		:= IN_CH.tPr_Ch_P1HP_A.Ai;
				END_IF
			ELSE
				IF bRelMon_P1HP_B 	THEN	OUT_CH.rPr_Ch_P1HP_Avg 		:= IN_CH.tPr_Ch_P1HP_B.Ai;
											OUT_CH.rPr_Ch_P1HP_Max		:= IN_CH.tPr_Ch_P1HP_B.Ai;
									ELSE	OUT_CH.rPr_Ch_P1HP_Avg 		:= 0;
											OUT_CH.rPr_Ch_P1HP_Max		:= 0;
											OUT_CH.bAMM_Pr_Ch_P1HP_Avg	:= TRUE;
				END_IF
			END_IF
		END_IF
	
		MM2VIS.rPr_Ch_P1HP_Avg	:= OUT_CH.rPr_Ch_P1HP_Avg;					(* VISU *)
	
	
		(* charge pressure after low-pressure TC *)
		IF 		bRelMon_P2LP 	 	THEN 	OUT_CH.rPr_Ch_P2LP_Avg		:= IN_CH.tPr_Ch_P2LP.Ai;
											OUT_CH.rPr_Ch_P2LP_Max		:= IN_CH.tPr_Ch_P2LP.Ai;
		ELSE
			IF 	bRelMon_P2LP_A 	 	THEN
				IF bRelMon_P2LP_B 	THEN	OUT_CH.rPr_Ch_P2LP_Avg		:=(IN_CH.tPr_Ch_P2LP_A.Ai + IN_CH.tPr_Ch_P2LP_B.Ai) / 2;
											OUT_CH.rPr_Ch_P2LP_Max		:= MAX(IN_CH.tPr_Ch_P2LP_A.Ai, IN_CH.tPr_Ch_P2LP_B.Ai);
								 	ELSE	OUT_CH.rPr_Ch_P2LP_Avg 		:= IN_CH.tPr_Ch_P2LP_A.Ai;
											OUT_CH.rPr_Ch_P2LP_Max		:= IN_CH.tPr_Ch_P2LP_A.Ai;
				END_IF
			ELSE
				IF bRelMon_P2LP_B 	THEN	OUT_CH.rPr_Ch_P2LP_Avg 		:= IN_CH.tPr_Ch_P2LP_B.Ai;
											OUT_CH.rPr_Ch_P2LP_Max		:= IN_CH.tPr_Ch_P2LP_B.Ai;
								 	ELSE	OUT_CH.rPr_Ch_P2LP_Avg 		:= 0;
											OUT_CH.rPr_Ch_P2LP_Max		:= 0;
											OUT_CH.bAMM_Pr_Ch_P2LP_Avg	:= TRUE;
				END_IF
			END_IF
		END_IF
	
		MM2VIS.rPr_Ch_P2LP_Avg	:= OUT_CH.rPr_Ch_P2LP_Avg;					(* VISU *)
	
	
		(*charge pressure before low-pressure TC *)
		IF 		bRelMon_P1LP_A 		THEN
			IF 	bRelMon_P1LP_B		THEN	OUT_CH.rPr_Ch_P1LP_Avg		:=(IN_CH.tPr_Ch_P1LP_A.Ai + IN_CH.tPr_Ch_P1LP_B.Ai) / 2;
											OUT_CH.rPr_Ch_P1LP_Max		:= MAX(IN_CH.tPr_Ch_P1LP_A.Ai, IN_CH.tPr_Ch_P1LP_B.Ai);
									ELSE	OUT_CH.rPr_Ch_P1LP_Avg 		:= IN_CH.tPr_Ch_P1LP_A.Ai;
											OUT_CH.rPr_Ch_P1LP_Max		:= IN_CH.tPr_Ch_P1LP_A.Ai;
			END_IF
		ELSIF 	bRelMon_P1LP_B		THEN	OUT_CH.rPr_Ch_P1LP_Avg 		:= IN_CH.tPr_Ch_P1LP_B.Ai;
											OUT_CH.rPr_Ch_P1LP_Max		:= IN_CH.tPr_Ch_P1LP_B.Ai;
									ELSE	OUT_CH.rPr_Ch_P1LP_Avg 		:= 0;
											OUT_CH.rPr_Ch_P1LP_Max		:= 0;
											OUT_CH.bAMM_Pr_Ch_P1LP_Avg	:= TRUE;
		END_IF
	
		MM2VIS.rPr_Ch_P1LP_Avg	:= OUT_CH.rPr_Ch_P1LP_Avg;					(* VISU *)
	


		(*--------------------------------------------------------------------------------------------------------------------------*)
		(* Difference pressure over cooler and flame arrester																		*)
		(*--------------------------------------------------------------------------------------------------------------------------*)
		IF 	  NOT OUT_CH.bAMM_Pr_Ch_P2LP_Avg AND NOT OUT_CH.bAMM_Pr_Ch_P1HP_Avg
		THEN
			MM2VIS.rDPr_Ch_LPCooler	:=  MM2VIS.rPr_Ch_P2LP_Avg  - MM2VIS.rPr_Ch_P1HP_Avg;
			bAMM_DPr_Ch_LPCooler_Hi	:= (MM2VIS.rDPr_Ch_LPCooler > Para.rDPr_Ch_LPCooler_Hi) AND bOMSS_MAT;					(* W2671 *)
		END_IF								
	
		IF 	  NOT OUT_CH.bAMM_Pr_Ch_P2HP_Avg AND bRelMon_P2bFA
		THEN
			MM2VIS.rDPr_Ch_HPCooler	:=  MM2VIS.rPr_Ch_P2HP_Avg  - MM2VIS.rPr_Ch_P2bFA;
			bAMM_DPr_Ch_HPCooler_Hi	:= (MM2VIS.rDPr_Ch_HPCooler > Para.rDPr_Ch_HPCooler_Hi)	AND bOMSS_MAT;		(* W2672 *)	(* W9243 *)

		ELSIF NOT OUT_CH.bAMM_Pr_Ch_P2HP_Avg AND NOT OUT_CH.bAMM_Pr_Ch_P2_Avg AND NOT Para.bPr_Ch_P2bFA_Exist
		THEN
			MM2VIS.rDPr_Ch_HPCooler	:=  MM2VIS.rPr_Ch_P2HP_Avg  - MM2VIS.rPr_Ch_P2_Avg;
			bAMM_DPr_Ch_HPCooler_Hi	:= (MM2VIS.rDPr_Ch_HPCooler > Para.rDPr_Ch_HPCooler_Hi)	AND bOMSS_MAT;		(* W2672 *)	(* W9243 *)
		END_IF
	
		IF 	  NOT OUT_CH.bAMM_Pr_Ch_P2_Avg   AND bRelMon_P2bFA
		THEN
			MM2VIS.rDPr_Ch_FA		:=  MM2VIS.rPr_Ch_P2bFA 	- MM2VIS.rPr_Ch_P2_Avg;
			bAMM_DPr_Ch_FA_Hi		:= (MM2VIS.rDPr_Ch_FA	    > Para.rDPr_Ch_FA_Hi) 		AND bOMSS_MAT;					(* W2673 *)
		END_IF

		
		(*---------------------------------------------------------------------------------------------------------------------------*)
		(* Monitoring pressures in standstill operation -----------------------------------------------------------------------------*)
		(*---------------------------------------------------------------------------------------------------------------------------*)
		tPr_Ch[0].GoodQual	:= IN_CH.tPr_Ch_P2s.GoodQual;
		tPr_Ch[0].ParaExist	:= Para.bPr_Ch_P2s_Exist;
		tPr_Ch[0].Value 	:= IN_CH.tPr_Ch_P2s.Ai;
		
		tPr_Ch[1].GoodQual	:= IN_CH.tPr_Ch_P2s_A.GoodQual;
		tPr_Ch[1].ParaExist	:= Para.bPr_Ch_P2s_A_Exist;
		tPr_Ch[1].Value 	:= IN_CH.tPr_Ch_P2s_A.Ai;
		
		tPr_Ch[2].GoodQual	:= IN_CH.tPr_Ch_P2s_B.GoodQual;
		tPr_Ch[2].ParaExist	:= Para.bPr_Ch_P2s_B_Exist;
		tPr_Ch[2].Value		:= IN_CH.tPr_Ch_P2s_B.Ai;
		
		tPr_Ch[3].GoodQual	:= IN_CH.tPr_Ch_P2.GoodQual;
		tPr_Ch[3].ParaExist	:= Para.bPr_Ch_P2_Exist;
		tPr_Ch[3].Value		:= IN_CH.tPr_Ch_P2.Ai;
	
		tPr_Ch[4].GoodQual	:= IN_CH.tPr_Ch_P2_A.GoodQual;
		tPr_Ch[4].ParaExist	:= Para.bPr_Ch_P2_A_Exist;
		tPr_Ch[4].Value 	:= IN_CH.tPr_Ch_P2_A.Ai;
		
		tPr_Ch[5].GoodQual	:= IN_CH.tPr_Ch_P2_B.GoodQual;
		tPr_Ch[5].ParaExist	:= Para.bPr_Ch_P2_B_Exist;
		tPr_Ch[5].Value 	:= IN_CH.tPr_Ch_P2_B.Ai;
	
		tPr_Ch[6].GoodQual	:= IN_CH.tPr_Ch_P2LP.GoodQual;
		tPr_Ch[6].ParaExist	:= Para.bPr_Ch_P2LP_Exist;
		tPr_Ch[6].Value 	:= IN_CH.tPr_Ch_P2LP.Ai;

		tPr_Ch[7].GoodQual	:= IN_CH.tPr_Ch_P2LP_A.GoodQual;
		tPr_Ch[7].ParaExist	:= Para.bPr_Ch_P2LP_A_Exist;
		tPr_Ch[7].Value 	:= IN_CH.tPr_Ch_P2LP_A.Ai;
		
		tPr_Ch[8].GoodQual	:= IN_CH.tPr_Ch_P2LP_B.GoodQual;
		tPr_Ch[8].ParaExist	:= Para.bPr_Ch_P2LP_B_Exist;
		tPr_Ch[8].Value 	:= IN_CH.tPr_Ch_P2LP_B.Ai;

		tPr_Ch[9].GoodQual	:= IN_CH.tPr_Ch_P2bFA.GoodQual;
		tPr_Ch[9].ParaExist	:= Para.bPr_Ch_P2bFA_Exist;
		tPr_Ch[9].Value 	:= IN_CH.tPr_Ch_P2bFA.Ai;
		
		tPr_Ch[10].GoodQual	:= IN_CH.tPr_Ch_P2HP.GoodQual;
		tPr_Ch[10].ParaExist:= Para.bPr_Ch_P2HP_Exist;
		tPr_Ch[10].Value 	:= IN_CH.tPr_Ch_P2HP.Ai;

		tPr_Ch[11].GoodQual	:= IN_CH.tPr_Ch_P2HP_A.GoodQual;
		tPr_Ch[11].ParaExist:= Para.bPr_Ch_P2HP_A_Exist;
		tPr_Ch[11].Value 	:= IN_CH.tPr_Ch_P2HP_A.Ai;
		
		tPr_Ch[12].GoodQual	:= IN_CH.tPr_Ch_P2HP_B.GoodQual;
		tPr_Ch[12].ParaExist:= Para.bPr_Ch_P2HP_B_Exist;
		tPr_Ch[12].Value 	:= IN_CH.tPr_Ch_P2HP_B.Ai;

		tPr_Ch[13].GoodQual	:= IN_CH.tPr_Ch_P1HP.GoodQual;
		tPr_Ch[13].ParaExist:= Para.bPr_Ch_P1HP_Exist;
		tPr_Ch[13].Value 	:= IN_CH.tPr_Ch_P1HP.Ai;
	
		tPr_Ch[14].GoodQual	:= IN_CH.tPr_Ch_P1HP_A.GoodQual;
		tPr_Ch[14].ParaExist:= Para.bPr_Ch_P1HP_A_Exist;
		tPr_Ch[14].Value 	:= IN_CH.tPr_Ch_P1HP_A.Ai;

		tPr_Ch[15].GoodQual	:= IN_CH.tPr_Ch_P1HP_B.GoodQual;
		tPr_Ch[15].ParaExist:= Para.bPr_Ch_P1HP_B_Exist;
		tPr_Ch[15].Value 	:= IN_CH.tPr_Ch_P1HP_B.Ai;
		
		tPr_Ch[16].GoodQual	:= IN_CH.tPr_Ch_P1LP_A.GoodQual;
		tPr_Ch[16].ParaExist:= Para.bPr_Ch_P1LP_A_Exist;
		tPr_Ch[16].Value 	:= IN_CH.tPr_Ch_P1LP_A.Ai;

		tPr_Ch[17].GoodQual	:= IN_CH.tPr_Ch_P1LP_B.GoodQual;
		tPr_Ch[17].ParaExist:= Para.bPr_Ch_P1LP_B_Exist;
		tPr_Ch[17].Value 	:= IN_CH.tPr_Ch_P1LP_B.Ai;
			
		(* release monitoring charge pressures in standstill *)
		xTON_1sTick(IN := NOT xTON_1sTick.Q, PT:= T#1s);				(* Function executes every 1 second *)
		
		IF (IN_CH.rN_EngAct = 0) AND (xTON_1sTick.Q) THEN 				(* Engine stopped *)
			iPr_Ch_Out_lgt 	:= 0;
			iPr_Ch_Ok_lgt 	:= 0;

	 		bAMM_Pr_Ch_OoR 	:= FALSE;
			szPr_Ch_OoR		:= '';
					
			FOR i := 0 TO iPr_Ch_lgt -1 DO								(* For each possible boost pressures *)
				IF  tPr_Ch[i].GoodQual AND tPr_Ch[i].ParaExist THEN		(* Check if it is available *)
					
			(* First out of range detection *)
					IF tPr_Ch[i].Value < rPr_Ch_Max AND 
					   tPr_Ch[i].Value > rPr_Ch_Min
					THEN
						tPr_Ch_Ok[iPr_Ch_Ok_lgt]	:= tPr_Ch[i];
						iPr_Ch_Ok_lgt 				:= iPr_Ch_Ok_lgt + 1;	
					ELSE
						tPr_Ch_Out[iPr_Ch_Out_lgt] 	:= tPr_Ch[i];
						iPr_Ch_Out_lgt 				:= iPr_Ch_Out_lgt + 1;
					END_IF
				END_IF		
			END_FOR	
			
			(* Start outlier detection method *)
			IF iPr_Ch_Ok_lgt >1 THEN
				FOR i := 1 TO iPr_Ch_Ok_lgt-1 DO						(* Sort pressures from min to max *)
					j := i;
					WHILE (j > 0) DO
						IF (tPr_Ch_Ok[j-1].Value > tPr_Ch_Ok[j].Value) THEN
							tPr_Ch_Tmp 		:= tPr_Ch_Ok[j-1];
							tPr_Ch_Ok[j-1] 	:= tPr_Ch_Ok[j];
							tPr_Ch_Ok[j] 	:= tPr_Ch_Tmp;
							j 				:= j-1;
						ELSE
							EXIT; // End while statement
						END_IF
					END_WHILE
				END_FOR	
						
				IF INT_TO_BOOL(iPr_Ch_Ok_lgt MOD 2) THEN				(* Find median value*)
					rPr_Ch_Ok_medVal := tPr_Ch_Ok[(iPr_Ch_Ok_lgt+1) / 2 - 1].Value;		// odd
				ELSE 																	
					rPr_Ch_Ok_medVal := (tPr_Ch_Ok[iPr_Ch_Ok_lgt / 2 - 1].Value + 
										 tPr_Ch_Ok[iPr_Ch_Ok_lgt / 2].Value) / 2;		// even
				END_IF
					
					iTmp_Pr_Ch_Out_lgt := 0;
					iTmp_Pr_Ch_rest_lgt := 0;

				FOR i := 0 TO iPr_Ch_Ok_lgt-1 DO										(* Tolerance: median +- rPr_Ch_devMax *)
					IF tPr_Ch_Ok[i].Value < (rPr_Ch_Ok_medVal - rPr_Ch_devMax) OR
					   tPr_Ch_Ok[i].Value > (rPr_Ch_Ok_medVal + rPr_Ch_devMax)
					THEN
						tPr_Ch_Out[iPr_Ch_Out_lgt] 	:= tPr_Ch_Ok[i];  					(* Add the values into the outliers array *)
						iPr_Ch_Out_lgt 				:= iPr_Ch_Out_lgt + 1;
						iTmp_Pr_Ch_Out_lgt 			:= iTmp_Pr_Ch_Out_lgt + 1;
					ELSE
						tTmp_Pr_Ch_rest[iTmp_Pr_Ch_rest_lgt] := tPr_Ch_Ok[i];  			(* Add the values into the outliers array *)
						iTmp_Pr_Ch_rest_lgt 		:= iTmp_Pr_Ch_rest_lgt + 1;
					END_IF
				END_FOR
			END_IF
					
			(* When only 1 value is out, apply outlier detection method in the rest of the array *)
			IF (iTmp_Pr_Ch_Out_lgt = 1) AND (iTmp_Pr_Ch_rest_lgt > 2) THEN
				IF INT_TO_BOOL(iTmp_Pr_Ch_rest_lgt MOD 2) THEN			(* Find median value*)
					rPr_Ch_Ok_medVal := tTmp_Pr_Ch_rest[(iTmp_Pr_Ch_rest_lgt+1)/2 -1].Value;	// odd
				ELSE 																			// even
					rPr_Ch_Ok_medVal := (tTmp_Pr_Ch_rest[iTmp_Pr_Ch_rest_lgt/2 -1].Value 
									   + tTmp_Pr_Ch_rest[iTmp_Pr_Ch_rest_lgt/2].Value)/2;
				END_IF

				FOR i := 0 TO iTmp_Pr_Ch_rest_lgt-1 DO										(* Tolerance: median +- rPr_Ch_devMax *)
					IF  tTmp_Pr_Ch_rest[i].Value < (rPr_Ch_Ok_medVal - rPr_Ch_devMax) OR 
						tTmp_Pr_Ch_rest[i].Value > (rPr_Ch_Ok_medVal + rPr_Ch_devMax)
					THEN
						tPr_Ch_Out[iPr_Ch_Out_lgt]	:= tPr_Ch_Ok[i];  						(* Add the pressure into the outliers array *)
						iPr_Ch_Out_lgt 				:= iPr_Ch_Out_lgt + 1;
					END_IF
				END_FOR
			END_IF
			
			(* Warning management *)
			IF iPr_Ch_Out_lgt > 0 THEN
				bAMM_Pr_Ch_OoR 		 := TRUE;

				(* Update associated message *)
				szPr_Ch_OoR := tPr_Ch_Out[0].Tag;				
				IF iPr_Ch_Out_lgt > 1 THEN
					FOR i := 1 TO iPr_Ch_Out_lgt-1 DO
						szPr_Ch_OoR := CONCAT(szPr_Ch_OoR, ', ');
						szPr_Ch_OoR := CONCAT(szPr_Ch_OoR, tPr_Ch_Out[i].Tag);
					END_FOR
				END_IF
			END_IF

			MM2VIS.szPr_Ch_OoR 	:= szPr_Ch_OoR;
		END_IF
		
	ELSE
		xTON_RelMon_P1LP_A(IN	:= FALSE);
		xTON_RelMon_P1LP_B(IN	:= FALSE);
		xTON_RelMon_P2LP(IN		:= FALSE);
		xTON_RelMon_P2LP_A(IN	:= FALSE);
		xTON_RelMon_P2LP_B(IN	:= FALSE);
		xTON_RelMon_P1HP(IN		:= FALSE);
		xTON_RelMon_P1HP_A(IN	:= FALSE);
		xTON_RelMon_P1HP_B(IN	:= FALSE);
		xTON_RelMon_P2HP(IN		:= FALSE);
		xTON_RelMon_P2HP_A(IN	:= FALSE);
		xTON_RelMon_P2HP_B(IN	:= FALSE);
		xTON_RelMon_P2bFA(IN	:= FALSE);
		xTON_RelMon_P2(IN		:= FALSE);
		xTON_RelMon_P2_A(IN		:= FALSE);
		xTON_RelMon_P2_B(IN		:= FALSE);
		xTON_RelMon_P2s(IN		:= FALSE);
		xTON_RelMon_P2s_A(IN	:= FALSE);
		xTON_RelMon_P2s_B(IN	:= FALSE);
		xTON_ErrMs(IN 			:= FALSE);
		xTON_1sTick(IN			:= FALSE);
	END_IF

END_PROGRAM
