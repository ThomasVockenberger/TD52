(************************************************************************************************************************************
CH_dpAirIn	 			 Charging air inlet filter difference pressure  

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	03.12.2012	Tinello		restructured 
V04.04.00.00	01.06.2016	Tinello		E_FILTER entfernt
				14.11.2016	Tinello		Spec.(c) and (d) added
V04.05.00.00	15.05.2017	Tinello		Liefergradumschaltung zw. BR9 und Rest
V04.05.04.00	16.08.2018	Tinello		Stable power below 1% Pnenn instead of gradient, bu
V04.07.00.00	07.03.2019	Tinello		MsErr active with op.switch OFF mode, consideration of the dynamic pressure component 
										in case of no pitot tube -> specification f
V04.07.01.00	04.10.2019	Tinello		reduced perm file write interval, bu1
V04.10.00.00	28.01.2021	Tinello		BugFix: Timer-FuB's / other FuB's

(************************************************************************************************************************************)
PROGRAM _CYCLIC	

	(*--------------------------------------------------*)
	(* RESET 											*)
	(*--------------------------------------------------*)
	bAMM_DPr_AirFilt_Ms		:= FALSE;
	bAMM_DPr_AirFilt_A_Ms	:= FALSE;
	bAMM_DPr_AirFilt_B_Ms	:= FALSE;

	bAMM_DPr_AirFilt_Lo		:= FALSE;
	bAMM_DPr_AirFilt_A_Lo	:= FALSE;
	bAMM_DPr_AirFilt_B_Lo	:= FALSE;
	
	bAMM_DPr_AirFilt_Hi		:= FALSE;
	bAMM_DPr_AirFilt_A_Hi	:= FALSE;
	bAMM_DPr_AirFilt_B_Hi	:= FALSE;

	rVol_Ch_Engine_Norm		:= 0;
	rVol_Ch_Air_Norm		:= 0;
	rVol_Ch_Air				:= 0;
	rPos_Ch_CBV_Reserve		:= 0;

	MM2VIS.rDPr_AirFilt		:= 0;
	MM2VIS.rDPr_AirFilt_A	:= 0;
	MM2VIS.rDPr_AirFilt_B	:= 0;


	(* ---------------------------------------------------------------------------------------------------------------------------- *)
	(* 											Calculating air volume flow															*)
	(* ---------------------------------------------------------------------------------------------------------------------------- *)
	IF 	(OUT_CH.rT_Ch_T2s_Avg + 273.15) <> 0 	AND										(* to avoid division by 0 *)
		NOT OUT_CH.bAMM_Pr_Ch_P2s_Avg 			AND										(* collective warning *)
		NOT OUT_CH.bAMM_T_Ch_T2s_Avg
	THEN
		rVol_Ch_Hub			:= 3.14159 * UINT_TO_REAL(xEngType.Bore)**2 * UINT_TO_REAL(xEngType.Stroke) / 4 / 1000000000;

	  	IF xEngType.Type9 THEN	rLiefer_Local := IN_CH.rVE_Eng;							(* J920	  *)
						  ELSE	rLiefer_Local := USINT_TO_REAL(Para.ucLiefer) / 100;
		END_IF

		rVol_Ch_Engine_Norm	:= IN_CH.rN_EngAct / 2 * rVol_Ch_Hub * USINT_TO_REAL(xEngType.NumberOfCylinder) *
							   rLiefer_Local							* 
							   OUT_CH.rPr_Ch_P2s_Avg / 1.01325 			*
							   273.15 / (OUT_CH.rT_Ch_T2s_Avg + 273.15) * 
							   60;														(* Nm³/min --> Nm³/h *)

		rVol_Ch_Air_Norm	:= rVol_Ch_Engine_Norm - IN_CH.rVol_TotalGas_Norm;

		IF 	NOT OUT_CH.bAMM_T_Ch_T1LP_Avg AND 
			IN_CH.rPr_Baro_Internal <> 0
		THEN
			rVol_Ch_Air		:= rVol_Ch_Air_Norm * (OUT_CH.rT_Ch_T1LP_Avg + 273.15) / 273.15 *
							   101325 / (IN_CH.rPr_Baro_Internal * 100000);				(* 1bar = 100.000 Pascal *)
		END_IF
	END_IF

	OUT_CH.rVol_Ch_Engine_Norm	:= rVol_Ch_Engine_Norm;
	MM2VIS.rVol_Ch_Engine_Norm	:= rVol_Ch_Engine_Norm;


	(********************************************************************************************************************************)
	(* GE JENBACHER - filter box																									*)
	(********************************************************************************************************************************)
	IF (Para.bDPr_AirFilt_Exist	OR Para.bDPr_AirFilt_A_Exist OR Para.bDPr_AirFilt_B_Exist) AND
		bRelModul_ParaSetupOk AND IN_CH.tPB2MM.bSys_Run
	THEN
		(* ------------------------------------------------ *)
		(* monitoring of measurement signal failure 		*)
		(* ------------------------------------------------ *)
		bAMM_DPr_AirFilt_Ms 	:= Para.bDPr_AirFilt_Exist 	 AND NOT IN_CH.tDPr_AirFilt.GoodQual;							(* W2621 *)
		bAMM_DPr_AirFilt_A_Ms	:= Para.bDPr_AirFilt_A_Exist AND NOT IN_CH.tDPr_AirFilt_A.GoodQual;							(* W2548 *)
		bAMM_DPr_AirFilt_B_Ms 	:= Para.bDPr_AirFilt_B_Exist AND NOT IN_CH.tDPr_AirFilt_B.GoodQual;							(* W2550 *)

			(* release monitoring	*)
			xTON_RelMon_DPr_AirFilt(IN	:= Para.bDPr_AirFilt_Exist   AND NOT bAMM_DPr_AirFilt_Ms,	PT:= T#10s);
			xTON_RelMon_DPr_AirFilt_A(IN:= Para.bDPr_AirFilt_A_Exist AND NOT bAMM_DPr_AirFilt_A_Ms, PT:= T#10s);
			xTON_RelMon_DPr_AirFilt_B(IN:= Para.bDPr_AirFilt_B_Exist AND NOT bAMM_DPr_AirFilt_B_Ms, PT:= T#10s);

			bRelMon_DPr_AirFilt			:= xTON_RelMon_DPr_AirFilt.Q;				(* delayed reswitch to valid meas.value *)
			bRelMon_DPr_AirFilt_A		:= xTON_RelMon_DPr_AirFilt_A.Q;
			bRelMon_DPr_AirFilt_B		:= xTON_RelMon_DPr_AirFilt_B.Q;


		(* ------------------------------------------------ *)
		(* VISU										 		*)
		(* ------------------------------------------------ *)
		IF Para.bDPr_AirFilt_PitotTube_Exist THEN									(* measurement with pitot tube (Staudruckrohr) *)
			
			MM2VIS.rDPr_AirFilt			:= IN_CH.tDPr_AirFilt.Ai;
			MM2VIS.rDPr_AirFilt_A		:= IN_CH.tDPr_AirFilt_A.Ai;
			MM2VIS.rDPr_AirFilt_B		:= IN_CH.tDPr_AirFilt_B.Ai;
		ELSE
			(* Consideration of the dynamic pressure component *)			
			IF IN_CH.rP_Nom <> 0 THEN			
				rDPr_AirFilt_DynPress	:= Para.rDPr_AirFilt_DynPress * (IN_CH.tP_Act[1].Ai / IN_CH.rP_Nom)**2 - 0.0007;
			ELSE	
				rDPr_AirFilt_DynPress	:= 0;
			END_IF			

			MM2VIS.rDPr_AirFilt			:= IN_CH.tDPr_AirFilt.Ai   + rDPr_AirFilt_DynPress;
			MM2VIS.rDPr_AirFilt_A		:= IN_CH.tDPr_AirFilt_A.Ai + rDPr_AirFilt_DynPress;
			MM2VIS.rDPr_AirFilt_B		:= IN_CH.tDPr_AirFilt_B.Ai + rDPr_AirFilt_DynPress;
		END_IF



		(* ------------------------------------------------------------------------------------------------------------------------ *)
		(* monitoring of MIN and MAX difference pressure																			*)
		(* ------------------------------------------------------------------------------------------------------------------------ *)
		IF	IN_CH.rP_Act_Norm_Filt >= 0.4													(* actual power > 40% of nominal power *)
		THEN
			(* Stable power over 5 minutes *)
			xLCRMovAvgFlt_P_Act(enable:= TRUE, x:= IN_CH.tP_Act[1].Ai, base:= 50);			(* 5s filter *)
			xTON_P_Act_stable(IN	  := ABS(IN_CH.tP_Act[1].Ai - xLCRMovAvgFlt_P_Act.y) < (IN_CH.rP_Nom * 0.01), 
							  PT	  := T#5m);

			IF 	xTON_P_Act_stable.Q AND ((IN_CH.iCnt_OpHours > (iCnt_OpHours_LastCalib + 100)) OR iCnt_OpHours_LastCalib = 0)
			THEN
				rVol_Ch_Air_Range	:= rVol_Ch_Air 		  - 0;
				rP_Act_Range		:= IN_CH.tP_Act[1].Ai - 0;

				IF 	rP_Act_Range <> 0 AND IN_CH.tP_Act[1].Ai > rP_Act_LastCalib
				THEN
					(* Extrapolation of air volume flow at nominal power *)
					rVol_Ch_AirFilt_Pnom	:= (rVol_Ch_Air_Range / rP_Act_Range) * (IN_CH.rP_Nom - 0) + 0;
	
					IF IN_CH.tP_Act[1].Ai >= IN_CH.rP_Nom	THEN	iCnt_OpHours_LastCalib	:= IN_CH.iCnt_OpHours;
																	rP_Act_LastCalib		:= 0;
															ELSE	rP_Act_LastCalib		:= IN_CH.tP_Act[1].Ai;
					END_IF
				END_IF
			END_IF


			(* Extrapolation of air volume flow DONE *)
			IF  (rVol_Ch_AirFilt_Pnom > 0) THEN						

				(*----------------------------------------------*)
				(* difference pressure MIN	 					*)
				(*----------------------------------------------*)

				(* interpolation of MINIMAL tolerated air filter difference pressure *)
				xSigScal_R_DPrLo.X	:= rVol_Ch_Air; 
				xSigScal_R_DPrLo.X1	:= 0; 
				xSigScal_R_DPrLo.Y1	:= 0; 
				xSigScal_R_DPrLo.X2	:= rVol_Ch_AirFilt_Pnom;
				xSigScal_R_DPrLo.Y2	:= Para.rDPr_AirFilt_Lo;
				xSigScal_R_DPrLo();

				bAMM_DPr_AirFilt_Lo		:= MM2VIS.rDPr_AirFilt   > (xSigScal_R_DPrLo.Y_SCAL * 0.75) AND bRelMon_DPr_AirFilt;	(* W2626 *)
				bAMM_DPr_AirFilt_A_Lo	:= MM2VIS.rDPr_AirFilt_A > (xSigScal_R_DPrLo.Y_SCAL * 0.75) AND	bRelMon_DPr_AirFilt_A;	(* W3597 *)
				bAMM_DPr_AirFilt_B_Lo	:= MM2VIS.rDPr_AirFilt_B > (xSigScal_R_DPrLo.Y_SCAL * 0.75) AND	bRelMon_DPr_AirFilt_B;	(* W3599 *)


				(*----------------------------------------------*)
				(* difference pressure MAX	 					*)
				(*----------------------------------------------*)

				(* interpolation of MAXIMAL tolerated air filter difference pressure *)
				IF 	((xEngType.Type6 AND FIND(IN_CH.szEng_Motorversion, 'H') <> 1) OR		(* BR6 ohne Typ H *)
  				  	  xEngType.Type4												 ) 	AND	(* BR4	  *)
					(OUT_CH.rT_Ch_T2s_Avg + 273.15) <> 0 								AND	(* to avoid division by 0 *)
					NOT OUT_CH.bAMM_Pr_Ch_P2s_Avg 										AND	(* collective warning *)
					NOT OUT_CH.bAMM_T_Ch_T2s_Avg 			
				THEN
						(* Interpolation DIANE position -> real position *)
						(* Woodward valve with DM 48mm / Typ F-Series 48 *)
						tCBV_CurvePoints[0].x				:= 0;
						tCBV_CurvePoints[0].y				:= 0;

						tCBV_CurvePoints[1].x				:= 12.5;
						tCBV_CurvePoints[1].y				:= 2.9;

						tCBV_CurvePoints[2].x				:= 18.8;
						tCBV_CurvePoints[2].y				:= 6.6;

						tCBV_CurvePoints[3].x				:= 56.3;
						tCBV_CurvePoints[3].y				:= 59.3;

						tCBV_CurvePoints[4].x				:= 100.0;
						tCBV_CurvePoints[4].y				:= 100.0;

						xLCRCurveByPoints_CBV.NoOfPoints	:= 5;							(* number of interpolation points *)
						xLCRCurveByPoints_CBV.ptr_table  	:= ADR(tCBV_CurvePoints);		(* interpolations parameter 	*)
						xLCRCurveByPoints_CBV.x			 	:= IN_CH.rPos_CBV * 100;		(* Turbobypass-Position DIANE 	*)
						xLCRCurveByPoints_CBV();

					rPos_Ch_CBV			:= xLCRCurveByPoints_CBV.y;							(* Turbobypass-Position REAL *)

					rCD					:= (-0.0000000003842 *  rPos_Ch_CBV ** 5 +
											 0.000000090749  *	rPos_Ch_CBV ** 4 -
											 0.0000068764 	 *	rPos_Ch_CBV ** 3 +
											 0.00026481 	 * 	rPos_Ch_CBV ** 2 -
										 	 0.00012437 	 *  rPos_Ch_CBV		 +
											 0.0090585							  ) * rNum_Ch_CBV_Valve;

					rVol_Ch_CBV_Norm	:= rCD * 0.4825 *
										   (2 * OUT_CH.rPr_Ch_P2s_Avg * 100000 *
										    (1.2588 * OUT_CH.rPr_Ch_P2s_Avg / 1.01325 *
										     273.15 / (OUT_CH.rT_Ch_T2s_Avg + 273.15)  )) ** 0.5 *
										   1.8095 / 1000 / 1.2588 * 3600;

				ELSIF  ((xEngType.Type6 AND FIND(IN_CH.szEng_Motorversion, 'H') = 1) OR 	(* J624 H *)
	  				  	 xEngType.Type9												  ) AND	(* J920	  *)
						(OUT_CH.rT_Ch_T2s_Avg + 273.15) <> 0 							AND	(* to avoid division by 0 *)
						NOT OUT_CH.bAMM_Pr_Ch_P2s_Avg 									AND	(* collective warning *)
						NOT OUT_CH.bAMM_T_Ch_T2s_Avg 		
				THEN
					rPos_Ch_CBV 		:= IN_CH.rPos_CBV * 100;		 	  				(* Turbobypass-Position DIANE = REAL *)

					rCD					:= (-0.000000000345  * 	rPos_Ch_CBV ** 5 +
											 0.0000000865 	 *	rPos_Ch_CBV ** 4 -
											 0.00004607 	 * 	rPos_Ch_CBV ** 3 +
											 0.000184 		 * 	rPos_Ch_CBV ** 2 +
											 0.00195 		 *	rPos_Ch_CBV		 +
											 0.00637							  ) * rNum_Ch_CBV_Valve;

					rVol_Ch_CBV_Norm	:= rCD * 0.4825 *
										   (2 * OUT_CH.rPr_Ch_P2s_Avg * 100000 *
										    (1.2588 * OUT_CH.rPr_Ch_P2s_Avg / 1.01325 *
										     273.15 / (OUT_CH.rT_Ch_T2s_Avg + 273.15)  )) ** 0.5 *
										   5.6745 / 1000 / 1.2588 * 3600;
				ELSE																		(* other engine type *)
					rVol_Ch_CBV_Norm	:= 0;
				END_IF

				IF 	(rVol_Ch_Engine_Norm + rVol_Ch_CBV_Norm) <> 0 							(* to avoid division by 0 *)
				THEN
					rPos_Ch_CBV_Reserve	:= rVol_Ch_CBV_Norm / (rVol_Ch_Engine_Norm + rVol_Ch_CBV_Norm);
				END_IF

				(* Adaption limit reffered to acutal bypass reserve - Umblase Reserve *)
				IF 	  rPos_Ch_CBV_Reserve > 0.05 THEN
					xSigScal_R_DPrHi.Y2	:= Para.rDPr_AirFilt_Hi + Para.rDPr_AirFilt_Hi_incr;

				ELSIF rPos_Ch_CBV_Reserve > 0.04 THEN
					xSigScal_R_DPrHi.Y2	:= Para.rDPr_AirFilt_Hi + Para.rDPr_AirFilt_Hi_incr * ((rPos_Ch_CBV_Reserve - 0.04) /
																							   (0.05 - 0.04)		 		 );
				ELSE
					xSigScal_R_DPrHi.Y2	:= Para.rDPr_AirFilt_Hi;
				END_IF

				xSigScal_R_DPrHi.X		:= rVol_Ch_Air;
				xSigScal_R_DPrHi.X1 	:= 0;
				xSigScal_R_DPrHi.Y1 	:= 0;
				xSigScal_R_DPrHi.X2		:= rVol_Ch_AirFilt_Pnom;
				xSigScal_R_DPrHi();

				(* Warning if maximum difference pressure exceed *)
				bAMM_DPr_AirFilt_Hi		:= MM2VIS.rDPr_AirFilt   < (xSigScal_R_DPrHi.Y_SCAL * 0.95) AND	bRelMon_DPr_AirFilt;	(* W2700 *)
				bAMM_DPr_AirFilt_A_Hi	:= MM2VIS.rDPr_AirFilt_A < (xSigScal_R_DPrHi.Y_SCAL * 0.95) AND	bRelMon_DPr_AirFilt_A;	(* W3598 *)
				bAMM_DPr_AirFilt_B_Hi	:= MM2VIS.rDPr_AirFilt_B < (xSigScal_R_DPrHi.Y_SCAL * 0.95) AND	bRelMon_DPr_AirFilt_B;	(* W3600 *)
			END_IF
		ELSE
			xLCRMovAvgFlt_P_Act(enable	:= FALSE);
			xTON_P_Act_stable(IN		:= FALSE);
		END_IF
	(* END of GE Jenbacher - filter box *)



	(********************************************************************************************************************************)
	(* External intake (Außenansaugung)																								*)
	(********************************************************************************************************************************)
	ELSIF 	(Para.bPr_Ch_P1LP_A_Exist OR Para.bPr_Ch_P1LP_B_Exist) 	AND
			(OUT_CH.rPr_Ch_P1LP_Avg + IN_CH.rPr_Baro_Internal) <> 0	AND								(* to avoid division by 0 *)
			(OUT_CH.rT_Ch_T1LP_Avg  + 273.15) 				   <> 0	AND								(* to avoid division by 0 *)
			  IN_CH.rPr_Baro_Internal <> 0							AND
			NOT OUT_CH.bAMM_Pr_Ch_P1LP_Avg 							AND								(* collective warning *)
			NOT OUT_CH.bAMM_T_Ch_T1LP_Avg							AND
			bRelModul_ParaSetupOk
	THEN
		rSpd_Ch_IntakePipe		:= (rVol_Ch_Air_Norm / 3600) / 										(* convert Nm³/h --> Nm³/s *)
				   					2 * 															(* number of air intake pipes *)
								    1.01325 / (OUT_CH.rPr_Ch_P1LP_Avg + IN_CH.rPr_Baro_Internal) *
				  					((OUT_CH.rT_Ch_T1LP_Avg + 273.15) / 273.15) /
									(rDia_Ch_IntakePipe**2 * 3.1416 / 4);							(* area of a circle *)

		rRho_Ch_R1LP			:= 1.29   * 
								  (OUT_CH.rPr_Ch_P1LP_Avg + IN_CH.rPr_Baro_Internal) / 1.01325 *
						 	 	   273.15 / (OUT_CH.rT_Ch_T1LP_Avg  + 273.15);

		rPr_Ch_P1LP_Dyn			:= 0.5 * rRho_Ch_R1LP * rSpd_Ch_IntakePipe**2 / 100;


		(* ------------------------------------------------------------------------------------------------------------------------ *)
		(* 													VISU																	*)
		(* ------------------------------------------------------------------------------------------------------------------------ *)
		MM2VIS.rDPr_AirFilt_A	:= IN_CH.tPr_Ch_P1LP_A.Ai + rPr_Ch_P1LP_Dyn;
		MM2VIS.rDPr_AirFilt_B	:= IN_CH.tPr_Ch_P1LP_B.Ai + rPr_Ch_P1LP_Dyn;


		(* ------------------------------------------------------------------------------------------------------------------------ *)
		(* 													Monitoring																*)
		(* ------------------------------------------------------------------------------------------------------------------------ *)
		IF	IN_CH.rP_Act_Norm_Filt >= 0.2													(* actual power > 20% of nominal power *)
		THEN
			(*----------------------------------------------*)
			(* difference pressure MAX	 					*)
			(*----------------------------------------------*)
			bAMM_DPr_AirFilt_A_Hi	:= MM2VIS.rDPr_AirFilt_A < Para.rDPr_AirFilt_Hi AND										(* W3598 *)
									   NOT bAMM_Pr_Ch_P1LP_A_Ms AND Para.bPr_Ch_P1LP_A_Exist;
	
			bAMM_DPr_AirFilt_B_Hi	:= MM2VIS.rDPr_AirFilt_B < Para.rDPr_AirFilt_Hi AND										(* W3600 *)
									   NOT bAMM_Pr_Ch_P1LP_B_Ms AND Para.bPr_Ch_P1LP_B_Exist;
		END_IF

		xTON_RelMon_DPr_AirFilt(IN	:= FALSE);
		xTON_RelMon_DPr_AirFilt_A(IN:= FALSE);
		xTON_RelMon_DPr_AirFilt_B(IN:= FALSE);
		xTON_P_Act_stable(IN		:= FALSE);
		xLCRMovAvgFlt_P_Act(enable	:= FALSE);
	ELSE
		xTON_RelMon_DPr_AirFilt(IN	:= FALSE);
		xTON_RelMon_DPr_AirFilt_A(IN:= FALSE);
		xTON_RelMon_DPr_AirFilt_B(IN:= FALSE);
		xTON_P_Act_stable(IN		:= FALSE);
		xLCRMovAvgFlt_P_Act(enable	:= FALSE);
	END_IF




	(********************************************************************************************************************************)
	(* Save values to PERMANENT MEMORY 																								*)
	(********************************************************************************************************************************)

	(* 10 seconds timer *)
	TON_WritePMEM(IN := NOT TON_WritePMEM.Q, PT:= T#10s);
	TON_BlockMinFileAge(IN := bBlock_MinFileAge, PT:= T#10m);			(*V4.07.01 reduced perm file write interval*)
	IF TON_BlockMinFileAge.Q  THEN bBlock_MinFileAge := FALSE; END_IF

	(* every 10 seconds or at write once the parameter values are copied to the structure pm *)
	IF TON_WritePMEM.Q OR write_once THEN

		(* ------------- V4.04 ---------------- *)
		pmAirF.rVol_Ch_AirFilt_Pnom	    := rVol_Ch_AirFilt_Pnom;		(* copy parameter value to structure pm *)
		pmAirF.iCnt_OpHours_LastCalib	:= iCnt_OpHours_LastCalib;
		pmAirF.rP_Act_LastCalib			:= rP_Act_LastCalib;
	END_IF


	(* cyclic calcualtion of parameter checksum	*)
	IF TON_WritePMEM.Q THEN
		ulChecksum := 0;

		FOR ulPMPointer := ADR(pmAirF) TO (ADR(pmAirF) + pm_len - SIZEOF(ulChkValue)) DO
			memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));
			ulChecksum := (ulChecksum XOR ulChkValue)+ulChkValue;
		END_FOR

		IF ulChecksumOld <> ulChecksum THEN					(* if checksum has changed 		*)
			ulChecksumOld := ulChecksum;					(* save last cheksum value		*)
			bWriteDataObj := TRUE;							(* set flag for write checksum	*)
		END_IF
	END_IF


	(* write structure pmAirF to the permanent memory module *)
	IF ( (bWriteDataObj AND NOT bBlock_MinFileAge) OR write_once )  THEN

		DatObjWrite_01();									(* run data object write fub 					*)

		IF DatObjWrite_01.status <> ERR_FUB_BUSY THEN		(* wait if data object write fub is busy 		*)
			bWriteDataObj 	:= FALSE;						(* reset data object write flag					*)
			write_once 		:= FALSE;						(* reset write_once flag 						*)
			iPM_WriteCnt 	:= iPM_WriteCnt  + 1;			(* counter for done data object module writes	*)

			IF DatObjWrite_01.status = ERR_NOERROR THEN		(* if status = NO ERROR -> block further write requests for 10min to avoid CF wear down	*)
				bBlock_MinFileAge := TRUE;	
			ELSE											(* if error status not no error 				*)
				pm_Error := 4;								(* set data object write error state			*)
			END_IF
		END_IF
	END_IF


	(* set RPS warning if no access to SysRom file is possible *)
	TON_WarnDelay(IN := pm_Error > 3 OR NOT IN_CH.tPB2MM.bParaSetupOk, PT:= T#15s); 
	bErrPermAirF := TON_WarnDelay.Q;
	
END_PROGRAM
