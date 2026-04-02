(*******************************************************************************
TC_Speed	 		 turbocharger speed

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

- turbocharger speed measuring
- speed and signal monitoring
- power reduction


Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	18.03.2013	Tinello		restructured 
V04.00.00.00	01.09.2014	Tinello		If engine speed = 0 and no measurement failure -> TC speed is set to 0
V04.04.00.00	27.10.2016	Tinello		change of speed deviation function -> Spec.(b)
V04.05.00.00	23.01.2018	Tinello		Release Monitoring hinzu und Warnmanagement vereinfacht
V04.05.01.00	15.03.2018	Tinello		Spezifikation c
V04.05.03.00	28.05.2018	Tinello		Bugfix: Quittierung der Ms-Sto
V04.07.00.00	13.06.2019	Tinello		MsErr active with op.switch OFF mode / interpolated speed max limit -> Spezifikation d
V04.10.00.00	26.01.2021	Tinello		2x out-interface for interpolated TC speed max limit / Use intake air temperature if T1HP is not available
										BugFix: Timer-FuB's
V04.12.00.00	17.01.2023 	Tinello		Extrapolation of TC speed limit
V04.14.00.00	18.03.2025	Theobald	Alarm 2325, 2326 and 2327 only appear when there is too low TC speed and the TC speed sensor is in good quality.

(*******************************************************************************)
PROGRAM _CYCLIC	

	xTON_1000ms(IN:= NOT xTON_1000ms.Q, PT:= T#800ms);											(* 800ms + 2x cycle time = 1000 ms *)

	(*------------------------------------------------------*)
	(* RESET of alarms and warnings 						*)
	(*------------------------------------------------------*)
	bAMM_N_TCLP_Ms			:= FALSE;
	bAMM_N_TCLP_MsMs		:= FALSE;
	bAMM_N_TCLP_A_Ms 		:= FALSE;
	bAMM_N_TCLP_B_Ms 		:= FALSE;
	bAMM_N_TCLP_Hi			:= FALSE;
	bAMM_N_TCLP_HiHi		:= FALSE;
	bAMM_N_TCLP_Diff_Hi		:= FALSE;
	bAMM_N_TCLP_Diff_HiHi	:= FALSE;

	bAMM_N_TCHP_Ms			:= FALSE;
	bAMM_N_TCHP_MsMs		:= FALSE;
	bAMM_N_TCHP_A_Ms 		:= FALSE;
	bAMM_N_TCHP_B_Ms 		:= FALSE;
	bAMM_N_TCHP_Hi			:= FALSE;
	bAMM_N_TCHP_HiHi		:= FALSE;
	bAMM_N_TCHP_Diff_Hi		:= FALSE;
	bAMM_N_TCHP_Diff_HiHi	:= FALSE;

	OUT_CH.rP_Red_TC_Norm 	:= 1;																(* release full load -> no reduction *)
	OUT_CH.rN_TCLP_HiHi		:= Para.rN_TCLP_HiHi;
	OUT_CH.rN_TCHP_HiHi		:= Para.rN_TCHP_HiHi;


	(*------------------------------------------------------*)
	(* VISU var of module									*)
	(*------------------------------------------------------*)
	(* In case of no engine speed and no measurement failure -> TC speed is set to 0 *)
	IF IN_CH.rN_EngAct > 10 OR (IN_CH.tN_TCLP.Ai   > 5000) OR (IN_CH.tN_TCLP.Ai   < -5000) 	THEN
		MM2VIS.rN_TCLP		:= IN_CH.tN_TCLP.Ai;
	ELSE
		MM2VIS.rN_TCLP		:= 0;
	END_IF

	IF IN_CH.rN_EngAct > 10 OR (IN_CH.tN_TCLP_A.Ai > 5000) OR (IN_CH.tN_TCLP_A.Ai < -5000)	THEN
		MM2VIS.rN_TCLP_A	:= IN_CH.tN_TCLP_A.Ai;
	ELSE
		MM2VIS.rN_TCLP_A	:= 0;
	END_IF

	IF IN_CH.rN_EngAct > 10 OR (IN_CH.tN_TCLP_B.Ai > 5000) OR (IN_CH.tN_TCLP_B.Ai < -5000)	THEN
		MM2VIS.rN_TCLP_B	:= IN_CH.tN_TCLP_B.Ai;
	ELSE
		MM2VIS.rN_TCLP_B	:= 0;
	END_IF


	IF IN_CH.rN_EngAct > 10 OR (IN_CH.tN_TCHP.Ai   > 5000) OR (IN_CH.tN_TCHP.Ai   < -5000)  THEN
		MM2VIS.rN_TCHP		:= IN_CH.tN_TCHP.Ai;
	ELSE
		MM2VIS.rN_TCHP		:= 0;
	END_IF

	IF IN_CH.rN_EngAct > 10 OR (IN_CH.tN_TCHP_A.Ai > 5000) OR (IN_CH.tN_TCHP_A.Ai < -5000)	THEN
		MM2VIS.rN_TCHP_A	:= IN_CH.tN_TCHP_A.Ai;
	ELSE
		MM2VIS.rN_TCHP_A	:= 0;
	END_IF

	IF IN_CH.rN_EngAct > 10 OR (IN_CH.tN_TCHP_B.Ai > 5000) OR (IN_CH.tN_TCHP_B.Ai < -5000)	THEN
		MM2VIS.rN_TCHP_B	:= IN_CH.tN_TCHP_B.Ai;
	ELSE
		MM2VIS.rN_TCHP_B	:= 0;
	END_IF



	(*------------------------------------------------------*)
	(* check if any turbocharger speed measuring is active 	*)
	(*------------------------------------------------------*)
	IF 	(Para.bN_TCHP_Exist OR Para.bN_TCHP_A_Exist OR Para.bN_TCHP_B_Exist OR					(* High pressure turbocharger exist *)
		 Para.bN_TCLP_Exist OR Para.bN_TCLP_A_Exist OR Para.bN_TCLP_B_Exist	  ) AND				(* Low  pressure turbocharger exist *)
		bRelModul_ParaSetupOk AND IN_CH.tPB2MM.bSys_Run
	THEN
		(*--------------------------------------------------*)
		(* measurement signal failure or signal too low		*)
		(*--------------------------------------------------*)
			(* Check if signal is too low --> TC speed < 60% of TC speed maximum and actual Power > 95% *)
			bN_TCLP_ErrMsLow		:= (IN_CH.tN_TCLP.Ai   < (Para.rN_TCLP_HiHi * 0.6)) AND (IN_CH.rP_Act_Norm_Filt > 0.95);
			bN_TCLP_A_ErrMsLow		:= (IN_CH.tN_TCLP_A.Ai < (Para.rN_TCLP_HiHi * 0.6)) AND (IN_CH.rP_Act_Norm_Filt > 0.95);
			bN_TCLP_B_ErrMsLow		:= (IN_CH.tN_TCLP_B.Ai < (Para.rN_TCLP_HiHi * 0.6)) AND (IN_CH.rP_Act_Norm_Filt > 0.95);

			bN_TCHP_ErrMsLow		:= (IN_CH.tN_TCHP.Ai   < (Para.rN_TCHP_HiHi * 0.6)) AND (IN_CH.rP_Act_Norm_Filt > 0.95);
			bN_TCHP_A_ErrMsLow		:= (IN_CH.tN_TCHP_A.Ai < (Para.rN_TCHP_HiHi * 0.6)) AND (IN_CH.rP_Act_Norm_Filt > 0.95);
			bN_TCHP_B_ErrMsLow		:= (IN_CH.tN_TCHP_B.Ai < (Para.rN_TCHP_HiHi * 0.6)) AND (IN_CH.rP_Act_Norm_Filt > 0.95);

		(* Low pressure turbocharger speed *)
		bAMM_N_TCLP_Ms 				:= (bN_TCLP_ErrMsLow   OR NOT IN_CH.tN_TCLP.GoodQual) 	AND Para.bN_TCLP_Exist;							(* W2617 *)
		bAMM_N_TCLP_A_Ms 			:= (bN_TCLP_A_ErrMsLow OR NOT IN_CH.tN_TCLP_A.GoodQual) AND Para.bN_TCLP_A_Exist;						(* W2565 *)
		bAMM_N_TCLP_B_Ms 			:= (bN_TCLP_B_ErrMsLow OR NOT IN_CH.tN_TCLP_B.GoodQual) AND Para.bN_TCLP_B_Exist;						(* W2566 *)
		bAMM_N_TCLP_MsMs			:=  bAMM_N_TCLP_A_Ms AND bAMM_N_TCLP_B_Ms AND IN_CH.tN_TCLP_A.GoodQual AND IN_CH.tN_TCLP_B.GoodQual;	(* A2327 *)

		(* turbocharger speed *)
		bAMM_N_TCHP_Ms				:= (bN_TCHP_ErrMsLow   OR NOT IN_CH.tN_TCHP.GoodQual) 	AND Para.bN_TCHP_Exist;							(* W2615 *)	(* W2616 *)
		bAMM_N_TCHP_A_Ms			:= (bN_TCHP_A_ErrMsLow OR NOT IN_CH.tN_TCHP_A.GoodQual) AND Para.bN_TCHP_A_Exist;						(* W3522 *)	(* W2563 *)
		bAMM_N_TCHP_B_Ms			:= (bN_TCHP_B_ErrMsLow OR NOT IN_CH.tN_TCHP_B.GoodQual) AND Para.bN_TCHP_B_Exist;						(* W3523 *)	(* W2564 *)
		bAMM_N_TCHP_MsMs			:=  bAMM_N_TCHP_A_Ms AND bAMM_N_TCHP_B_Ms AND IN_CH.tN_TCHP_A.GoodQual AND IN_CH.tN_TCHP_B.GoodQual;	(* A2325 *)	(* A2326 *)

			(* release monitoring	*)
			xTON_RelMon_N_TCLP(IN	:= Para.bN_TCLP_Exist   AND NOT bAMM_N_TCLP_Ms,   PT:= T#10s);
			xTON_RelMon_N_TCLP_A(IN	:= Para.bN_TCLP_A_Exist AND NOT bAMM_N_TCLP_A_Ms, PT:= T#10s);
			xTON_RelMon_N_TCLP_B(IN	:= Para.bN_TCLP_B_Exist AND NOT bAMM_N_TCLP_B_Ms, PT:= T#10s);

			xTON_RelMon_N_TCHP(IN	:= Para.bN_TCHP_Exist   AND NOT bAMM_N_TCHP_Ms,   PT:= T#10s);
			xTON_RelMon_N_TCHP_A(IN	:= Para.bN_TCHP_A_Exist AND NOT bAMM_N_TCHP_A_Ms, PT:= T#10s);
			xTON_RelMon_N_TCHP_B(IN	:= Para.bN_TCHP_B_Exist AND NOT bAMM_N_TCHP_B_Ms, PT:= T#10s);

			bRelMon_N_TCLP			:= xTON_RelMon_N_TCLP.Q;
			bRelMon_N_TCLP_A		:= xTON_RelMon_N_TCLP_A.Q;
			bRelMon_N_TCLP_B		:= xTON_RelMon_N_TCLP_B.Q;

			bRelMon_N_TCHP			:= xTON_RelMon_N_TCHP.Q;
			bRelMon_N_TCHP_A		:= xTON_RelMon_N_TCHP_A.Q;
			bRelMon_N_TCHP_B		:= xTON_RelMon_N_TCHP_B.Q;



		IF	bP_Nom10_60s THEN
			(*--------------------------------------------------*)
			(* turbocharger speed MAX 					  		*)
			(*--------------------------------------------------*)

			(* At least one low-pressure turbocharger speed > interpolated speed limit or max limit *)
				rN_TCLP_Max				:= MAX(IN_CH.tN_TCLP.Ai   * BOOL_TO_REAL(bRelMon_N_TCLP),
										 	   IN_CH.tN_TCLP_A.Ai * BOOL_TO_REAL(bRelMon_N_TCLP_A),
											   IN_CH.tN_TCLP_B.Ai * BOOL_TO_REAL(bRelMon_N_TCLP_B));

				xLCRScal_N_TCLP_Hi(x	:= rT_Ch_T1LP_Max,									(* inter- and extrapolation of allowed TC speed  *)
								   x1	:= Para.rT_Ch_T1LP_Hi,								(* depending on the inlet temperature *)
								   x2	:= Para.rT_Ch_T1LP_HiHi,
								   y1	:= Para.rN_TCLP_TempLimit_HiHi,
								   y2	:= Para.rN_TCLP_TempLimit_Hi);

				xLCRScal_N_TCLP_HiHi(x	:= rT_Ch_T1LP_Max,									(* inter- and extrapolation of allowed TC MAX speed  *)
								     x1	:= Para.rT_Ch_T1LP_Hi,								(* depending on the inlet temperature *)
								 	 x2	:= Para.rT_Ch_T1LP_HiHi,
									 y1	:= Para.rN_TCLP_HiHi,
									 y2	:= Para.rN_TCLP_Hi);

			bAMM_N_TCLP_DB				:= rN_TCLP_Max > LIMIT(0, xLCRScal_N_TCLP_Hi.y,   Para.rN_TCLP_TempLimit_HiHi) * 0.99;	(* deadband *)
			bAMM_N_TCLP_Hi				:= rN_TCLP_Max > LIMIT(0, xLCRScal_N_TCLP_Hi.y,   Para.rN_TCLP_TempLimit_HiHi);			(* -> power reduction *)(* W2527 *)
			bAMM_N_TCLP_HiHi			:= rN_TCLP_Max > LIMIT(0, xLCRScal_N_TCLP_HiHi.y, Para.rN_TCLP_HiHi);											(* A2239 *)

			OUT_CH.rN_TCLP_HiHi			:= LIMIT(0, xLCRScal_N_TCLP_HiHi.y, Para.rN_TCLP_HiHi);


			(* At least one high-pressure turbocharger speed > interpolated speed limit or max limit *)
				rN_TCHP_Max				:= MAX(IN_CH.tN_TCHP.Ai   * BOOL_TO_REAL(bRelMon_N_TCHP),
											   IN_CH.tN_TCHP_A.Ai * BOOL_TO_REAL(bRelMon_N_TCHP_A),
											   IN_CH.tN_TCHP_B.Ai * BOOL_TO_REAL(bRelMon_N_TCHP_B));

				xLCRScal_N_TCHP_Hi(  x	:= rT_Ch_T1HP_Max,									(* inter- and extrapolation of allowed TC speed  *)
								  	 x1	:= Para.rT_Ch_T1HP_Hi,								(* depending on the inlet temperature *)
								  	 x2	:= Para.rT_Ch_T1HP_HiHi,
								  	 y1	:= Para.rN_TCHP_TempLimit_HiHi,
								  	 y2	:= Para.rN_TCHP_TempLimit_Hi);

				xLCRScal_N_TCHP_HiHi(x	:= rT_Ch_T1HP_Max,									(* inter- and extrapolation of allowed TC speed  *)
									 x1	:= Para.rT_Ch_T1HP_Hi,								(* depending on the inlet temperature *)
								  	 x2	:= Para.rT_Ch_T1HP_HiHi,
								  	 y1	:= Para.rN_TCHP_HiHi,
								  	 y2	:= Para.rN_TCHP_Hi);

			bAMM_N_TCHP_DB				:= rN_TCHP_Max > LIMIT(0, xLCRScal_N_TCHP_Hi.y,   Para.rN_TCHP_TempLimit_HiHi) * 0.996;	(* deadband *)
			bAMM_N_TCHP_Hi				:= rN_TCHP_Max > LIMIT(0, xLCRScal_N_TCHP_Hi.y,   Para.rN_TCHP_TempLimit_HiHi);			(* -> power reduction*)	(* W3524 *)	(* W2526 *)
			bAMM_N_TCHP_HiHi			:= rN_TCHP_Max > LIMIT(0, xLCRScal_N_TCHP_HiHi.y, Para.rN_TCHP_HiHi);											(* A2278 *)	(* A2237 *)

			OUT_CH.rN_TCHP_HiHi			:= LIMIT(0, xLCRScal_N_TCHP_HiHi.y, Para.rN_TCHP_HiHi);



			(*--------------------------------------------------*)
			(* turbocharger speed deviation (Spreizung)			*)
			(*--------------------------------------------------*)
			IF 	bRelMon_N_TCHP_A AND bRelMon_N_TCHP_B
			THEN
				bAMM_N_TCHP_Diff_Hi		:= ABS(IN_CH.tN_TCHP_A.Ai - IN_CH.tN_TCHP_B.Ai) > Para.rN_TC_Diff_Hi;			(* W2614 *)	(* W2528 *)
				bAMM_N_TCHP_Diff_HiHi	:= ABS(IN_CH.tN_TCHP_A.Ai - IN_CH.tN_TCHP_B.Ai) > Para.rN_TC_Diff_Hi + 400;		(* A2279 *)	(* A2225 *)
			END_IF

			
			IF 	bRelMon_N_TCLP_A AND bRelMon_N_TCLP_B
			THEN
				bAMM_N_TCLP_Diff_Hi		:= ABS(IN_CH.tN_TCLP_A.Ai - IN_CH.tN_TCLP_B.Ai) > Para.rN_TC_Diff_Hi;						(* W2529 *)
				bAMM_N_TCLP_Diff_HiHi	:= ABS(IN_CH.tN_TCLP_A.Ai - IN_CH.tN_TCLP_B.Ai) > Para.rN_TC_Diff_Hi + 400;					(* A2226 *)
			END_IF




			(*--------------------------------------------------*)
			(* POWER REDUCTION and LIMITATION					*)																	(* B2144 *)
			(*--------------------------------------------------*)

			(* reduction by speed maximum 	*)
			IF xTON_1000ms.Q THEN																(* check every second *)

				IF 		   bAMM_N_TCHP_Hi OR bAMM_N_TCLP_Hi  THEN 	iTi_N_TC_P_Red_dur 			:= iTi_N_TC_P_Red_dur 	    + 1;
																	iTi_N_TC_P_Red_reset_dur	:= 0;
				ELSIF NOT (bAMM_N_TCHP_DB OR bAMM_N_TCLP_DB) 
					  AND rP_Red_N_TC_Max < 1		 		 THEN 	iTi_N_TC_P_Red_dur 			:= 0;
																	iTi_N_TC_P_Red_reset_dur	:= iTi_N_TC_P_Red_reset_dur + 1;
				ELSE
																	iTi_N_TC_P_Red_dur 			:= 0;
																	iTi_N_TC_P_Red_reset_dur	:= 0;
				END_IF
			END_IF

			IF iTi_N_TC_P_Red_dur >= 120 THEN
				bAMM_N_TCHP_HiHi	:= bAMM_N_TCHP_HiHi OR bAMM_N_TCHP_Hi;												(* A2278 *)	(* A2237 *)
				bAMM_N_TCLP_HiHi	:= bAMM_N_TCLP_HiHi OR bAMM_N_TCLP_Hi;															(* A2239 *)
			END_IF


			xTON_P_Red_TC_MaxInc(IN:= iTi_N_TC_P_Red_dur 	   > 0 AND NOT xTON_P_Red_TC_MaxInc.Q, PT:= T#30s);
			xTON_P_Red_TC_MaxDec(IN:= iTi_N_TC_P_Red_reset_dur > 0 AND NOT xTON_P_Red_TC_MaxDec.Q, PT:= T#30s);

			IF EDGEPOS(iTi_N_TC_P_Red_dur > 0) THEN	rP_Red_N_TC_Max	:= LIMIT(0.5, rP_Act_Norm_Save1 - Para.rP_Red_TC, 		1);	END_IF
			IF EDGEPOS(xTON_P_Red_TC_MaxInc.Q) THEN	rP_Red_N_TC_Max	:= LIMIT(0.5, rP_Red_N_TC_Max 	- Para.rP_Red_TC, 		1);	END_IF
			IF EDGEPOS(xTON_P_Red_TC_MaxDec.Q) THEN	rP_Red_N_TC_Max	:= LIMIT(0.5, rP_Red_N_TC_Max 	+ Para.rP_Red_TC_reset, 1);	END_IF

			IF iTi_N_TC_P_Red_dur = 0 THEN
				rP_Act_Norm_Save1	:= IN_CH.rP_Act_Norm_Filt;									(* save actual power *)
			END_IF

			OUT_CH.rP_Red_TC_Norm 	:= MIN(OUT_CH.rP_Red_TC_Norm, rP_Red_N_TC_Max);				(* Power reduction *)



			(* reduction by speed deviation - until user acknowledge *)
			IF 	MM2VIS.bMsg2614 OR																(*  			 TC speed deviation maximum *)
				MM2VIS.bMsg2528 OR																(* High pressure TC speed deviation maximum *)
				MM2VIS.bMsg2529																	(*  Low pressure TC speed deviation maximum *)
			THEN
				rP_Red_N_TC_Diff		:= LIMIT(0.5, rP_Act_Norm_Save - Para.rP_Red_TC, 1);	(* reduction start from actual power *)
				OUT_CH.rP_Red_TC_Norm 	:= MIN(OUT_CH.rP_Red_TC_Norm, rP_Red_N_TC_Diff);
			ELSE
				rP_Act_Norm_Save		:= IN_CH.rP_Act_Norm_Filt;								(* save actual power *)
			END_IF



			(* power limitation by signal failure or signal too low error *)
			xTON_P_Red_TC_Ms(IN	:= bAMM_N_TCHP_Ms OR bAMM_N_TCHP_A_Ms OR bAMM_N_TCHP_B_Ms OR
								   bAMM_N_TCLP_Ms OR bAMM_N_TCLP_A_Ms OR bAMM_N_TCLP_B_Ms,
							 PT	:= T#10s);

			IF xTON_P_Red_TC_Ms.Q THEN 
				OUT_CH.rP_Red_TC_Norm 	:= MIN(OUT_CH.rP_Red_TC_Norm, 0.7);						(* power-LIMITATION to 70% P nominal *)
			END_IF

		ELSE
			(* reset power reduction *)
			iTi_N_TC_P_Red_dur			:= 0;
			iTi_N_TC_P_Red_reset_dur	:= 0;
			rP_Red_N_TC_Max				:= 1;													(* release full load -> no reduction *)

			(* save actual power *)
			rP_Act_Norm_Save			:= IN_CH.rP_Act_Norm_Filt;
			rP_Act_Norm_Save1			:= IN_CH.rP_Act_Norm_Filt;

			(* reset timer *)
			xTON_P_Red_TC_MaxInc(IN		:= FALSE);
			xTON_P_Red_TC_MaxDec(IN		:= FALSE);
			xTON_P_Red_TC_Ms(IN			:= FALSE);
		END_IF
	ELSE
		(* reset power reduction *)
		iTi_N_TC_P_Red_dur				:= 0;
		iTi_N_TC_P_Red_reset_dur		:= 0;
		rP_Red_N_TC_Max					:= 1;													(* release full load -> no reduction *)

		(* save actual power *)
		rP_Act_Norm_Save				:= IN_CH.rP_Act_Norm_Filt;
		rP_Act_Norm_Save1				:= IN_CH.rP_Act_Norm_Filt;

		(* reset timer/release monitoring *)
		xTON_RelMon_N_TCLP(IN			:= FALSE);
		xTON_RelMon_N_TCLP_A(IN			:= FALSE);
		xTON_RelMon_N_TCLP_B(IN			:= FALSE);
		xTON_RelMon_N_TCHP(IN			:= FALSE);
		xTON_RelMon_N_TCHP_A(IN			:= FALSE);
		xTON_RelMon_N_TCHP_B(IN			:= FALSE);
		xTON_P_Red_TC_MaxInc(IN			:= FALSE);
		xTON_P_Red_TC_MaxDec(IN			:= FALSE);
		xTON_P_Red_TC_Ms(IN				:= FALSE);
		bRelMon_N_TCLP					:= FALSE;
		bRelMon_N_TCLP_A				:= FALSE;
		bRelMon_N_TCLP_B				:= FALSE;
		bRelMon_N_TCHP					:= FALSE;
		bRelMon_N_TCHP_A				:= FALSE;
		bRelMon_N_TCHP_B				:= FALSE;
	END_IF

END_PROGRAM
