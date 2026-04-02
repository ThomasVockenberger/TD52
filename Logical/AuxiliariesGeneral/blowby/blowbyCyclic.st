(*******************************************************************************
AGGR: blowby			Blow by  (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------

History:
-------
V3.20.0			13.04.2010	koppm.		new
V3.59.0 		04.06.2014	Tinello 	new spezification
V4.00.0  		29.01.2015	Mari 		Porting J920 FOR XT4 
				13.05.2015	lettenb.	release FOR error monitoring: bParaSetupOk added to avoid err.msg at plc startup
V4.00.1			25.06.2015	lettenb.	twice declared param.removed(bPr_CC_Exist,rP_CC_MonActive,rPr_CC_HiHi)
				22.07.2015				adaption for BR6 
V4.03.0			02.10.2015	lettenb.	blowby filter pressure monitoring added	acc. spec.(CM&U)		
V4.04.0			16.06.2016	Tinello.	Doppelte Anbindung W2653 entfernt
V4.05.0			08.05.2017	lettenb.	Para.bBbOp_EOP added (request holecek)
V4.05.1			21.02.2018				xTOF_EOP: NOT added, fan operation only with closed oil valve, bugfix
V4.10.0			11.11.2020	Schmid		blow-by blower off in full load operation
V4.11.0			02.02.2022	Schmid		suppress crankcase pressure max trip in case of load rejection or grid code event
V4.13.0			28.06.2023	Tinello		Blow-by fan needs to be operated when oil pump is running
							   
Instructions for use:
--------------------

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC

	(*----------------------------------*)
	(* RESET of alarms and warnings 	*)
	(*----------------------------------*)
	bAMM_BbBlower_Not_Rdy		:= FALSE;
	bAMM_Pc_BbBlower_Hi 		:= FALSE;

	bAMM_Pr_f_BbFilt_Ms			:= FALSE;
	bAMM_Pr_f_BbFilt_A_Ms		:= FALSE;
	bAMM_Pr_f_BbFilt_B_Ms		:= FALSE;
	bAMM_Pr_a_BbFilt_Ms			:= FALSE;
	bAMM_Pr_a_BbFilt_A_Ms		:= FALSE;
	bAMM_Pr_a_BbFilt_B_Ms		:= FALSE;

	bAMM_DPr_BbFilt_Hi			:= FALSE;
	bAMM_DPr_BbFilt_A_Hi		:= FALSE;
	bAMM_DPr_BbFilt_B_Hi		:= FALSE;
	bAMM_DPr_BbFilt_Lo			:= FALSE;
	bAMM_DPr_BbFilt_A_Lo		:= FALSE;
	bAMM_DPr_BbFilt_B_Lo		:= FALSE;
	bAMM_Pr_CC_MsMs				:= FALSE;
	bAMM_Pr_CC_Lo				:= FALSE;
	bAMM_Pr_CC_Hi				:= FALSE;
	bAMM_Pr_CC_HiHi				:= FALSE;


	(*----------------------------------*)
	(* Blow by blower				 	*)
	(*----------------------------------*)
	xTOF_EOP(IN:= OUT_AG.tEOP1AC_Dem.Do OR OUT_AG.tTC_EOP_On.Do, PT:= T#5m);

	xGR_MAXR_P_Act_Norm_Filt(In:= IN_AG.rP_Act_Norm_Filt, Gw:= Para.rP_Norm_BbBlower_off, Hy:= 0.02);
	xGR_MAXR_P_Set_Norm(In:= IN_AG.rP_Set_Norm, Gw:= Para.rP_Norm_BbBlower_off, Hy:= 0.02);
	xGR_MINR_Pr_CC(In:= IN_AG.tPr_CC.Ai, Gw:= -0.005, Hy:= 0.003);
	xTON_BbBlower_SS(IN:= xGR_MAXR_P_Act_Norm_Filt.Q AND xGR_MAXR_P_Set_Norm.Q AND xGR_MINR_Pr_CC.Q, PT:= T#10s);
	
	bBbBlower_Off := xTON_BbBlower_SS.Q AND IN_AG.bEng_Aux_Dem AND Para.bBbBlower_Off_Active;
	
	OUT_AG.tBbBlower.Do 		:=	(IN_AG.bEng_Aux_Dem_CDR OR (Para.bBbOp_EOP AND xTOF_EOP.Q))
								AND	NOT bBbBlower_Off;		

	IF MM2VIS.bMsg3323 	THEN			(* crank case pressure - measurement signal failure *)
		OUT_AG.tBbBlower_y.Ao 	:= LIMIT(0, IN_AG.rP_Act_Norm_Filt, rPc_BbBlower_Save);	(* crank case controller output *)
	ELSE	
		OUT_AG.tBbBlower_y.Ao 	:= rPc_BbBlower;
		rPc_BbBlower_Save		:= rPc_BbBlower;
	END_IF;
	
	
	(*--------------------------------------*)
	(* Blow by filter difference pressure	*)
	(*--------------------------------------*)
	(* Calculation of blow-by filter difference pressure *)
	rDPr_BbFilt		:= ABS(IN_AG.tPr_a_BbFilt.Ai   - IN_AG.tPr_f_BbFilt.Ai);
	rDPr_BbFilt_A	:= ABS(IN_AG.tPr_a_BbFilt_A.Ai - IN_AG.tPr_f_BbFilt_A.Ai);
	rDPr_BbFilt_B	:= ABS(IN_AG.tPr_a_BbFilt_B.Ai - IN_AG.tPr_f_BbFilt_B.Ai);
 
		
	(*--------------------------------------*)
	(* crank case pressure monitoring       *)
	(*--------------------------------------*)
	xTOF_BlocTrip_Pr_CC_HiHi.IN	:=	EDGEPOS(IN_AG.bLR_ActSat_CBV OR IN_AG.bGrC_HBErr_AUS); (* load rejection or grid code event *)
	xTOF_BlocTrip_Pr_CC_HiHi.PT	:=	T#30s;
	xTOF_BlocTrip_Pr_CC_HiHi();
	
	(*--------------------------------------------------*)	
	(* release for error monitoring 					*)
	(*--------------------------------------------------*)	
	IF bOMSS_MAT AND IN_AG.tPB2MM.bParaSetupOk THEN
		(*------------------------------------------------------------------*)	
		(* measurement signal failure 										*)
		(*------------------------------------------------------------------*)	
		bAMM_Pr_CC_MsMs 		:= Para.bPr_CC_MS_Exist	   		AND NOT IN_AG.tPr_CC.GoodQual; 			(* A3323 *)
		(* pressure before blow by filter *)
		bAMM_Pr_f_BbFilt_Ms		:= Para.bPr_f_BbFilt_Exist 		AND NOT IN_AG.tPr_f_BbFilt.GoodQual; 	(* W2651 *)
		bAMM_Pr_f_BbFilt_A_Ms	:= Para.bPr_f_BbFilt_A_Exist 	AND NOT IN_AG.tPr_f_BbFilt_A.GoodQual;	(* W2754 *)
		bAMM_Pr_f_BbFilt_B_Ms	:= Para.bPr_f_BbFilt_B_Exist 	AND NOT IN_AG.tPr_f_BbFilt_B.GoodQual;	(* W2755 *)
		(* pressure after blow by filter *)
		bAMM_Pr_a_BbFilt_Ms 	:= Para.bPr_a_BbFilt_Exist 		AND NOT IN_AG.tPr_a_BbFilt.GoodQual;	(* W2652 *)
		bAMM_Pr_a_BbFilt_A_Ms	:= Para.bPr_a_BbFilt_A_Exist 	AND NOT IN_AG.tPr_a_BbFilt_A.GoodQual;	(* W2756 *)
		bAMM_Pr_a_BbFilt_B_Ms	:= Para.bPr_a_BbFilt_B_Exist 	AND NOT IN_AG.tPr_a_BbFilt_B.GoodQual;	(* W2757 *)


		(* Release monitoring	*)
		xTOF_AMM_Pr_CC_MsMs      (IN:= bAMM_Pr_CC_MsMs, 	  PT:= T#10s);
		xTOF_AMM_Pr_f_BbFilt_Ms  (IN:= bAMM_Pr_f_BbFilt_Ms,   PT:= T#10s);	(* TOF because of filtered signals *)
		xTOF_AMM_Pr_f_BbFilt_A_Ms(IN:= bAMM_Pr_f_BbFilt_A_Ms, PT:= T#10s);
		xTOF_AMM_Pr_f_BbFilt_B_Ms(IN:= bAMM_Pr_f_BbFilt_B_Ms, PT:= T#10s);
		xTOF_AMM_Pr_a_BbFilt_Ms  (IN:= bAMM_Pr_a_BbFilt_Ms,   PT:= T#10s);
		xTOF_AMM_Pr_a_BbFilt_A_Ms(IN:= bAMM_Pr_a_BbFilt_A_Ms, PT:= T#10s);
		xTOF_AMM_Pr_a_BbFilt_B_Ms(IN:= bAMM_Pr_a_BbFilt_B_Ms, PT:= T#10s);

		bRelMon_Pr_CC			:= Para.bPr_CC_MS_Exist			AND NOT xTOF_AMM_Pr_CC_MsMs.Q;
		bRelMon_Pr_f_BbFilt		:= Para.bPr_f_BbFilt_Exist 		AND NOT xTOF_AMM_Pr_f_BbFilt_Ms.Q;
		bRelMon_Pr_f_BbFilt_A	:= Para.bPr_f_BbFilt_A_Exist 	AND NOT xTOF_AMM_Pr_f_BbFilt_A_Ms.Q;
		bRelMon_Pr_f_BbFilt_B	:= Para.bPr_f_BbFilt_B_Exist 	AND NOT xTOF_AMM_Pr_f_BbFilt_B_Ms.Q;
		bRelMon_Pr_a_BbFilt		:= Para.bPr_a_BbFilt_Exist 		AND NOT xTOF_AMM_Pr_a_BbFilt_Ms.Q;
		bRelMon_Pr_a_BbFilt_A	:= Para.bPr_a_BbFilt_A_Exist 	AND NOT xTOF_AMM_Pr_a_BbFilt_A_Ms.Q;
		bRelMon_Pr_a_BbFilt_B	:= Para.bPr_a_BbFilt_B_Exist 	AND NOT xTOF_AMM_Pr_a_BbFilt_B_Ms.Q;


		(*------------------------------------------------------------------*)	
		(* monitoring blow-by filter difference pressure 					*)
		(*------------------------------------------------------------------*)	
		IF 	(IN_AG.rP_Act_Norm_Filt > Para.rDPr_BbFilt_Pstart) 	AND		(* monitoring according to actual power *)	
			IN_AG.bEng_Aux_Dem_CDR										(* engine is running *)
		THEN										
			(* interpolation of MAXIMAL tolerated blow-by filter difference pressure *)
			xSigScal_R_DPrHi.X	:= IN_AG.rP_Act_Norm_Filt; 
			xSigScal_R_DPrHi.X1 := Para.rDPr_BbFilt_Pstart; 
			xSigScal_R_DPrHi.Y1 := Para.rDPr_BbFilt_Hi_P1; 
			xSigScal_R_DPrHi.X2 := 1.0; 						(* 100% = nominal power *) 
			xSigScal_R_DPrHi.Y2 := Para.rDPr_BbFilt_Hi_P2;
			xSigScal_R_DPrHi();			
			

			(* interpolation of MINIMAL tolerated blow-by filter difference pressure *)
			xSigScal_R_DPrLo.X	:= IN_AG.rP_Act_Norm_Filt; 
			xSigScal_R_DPrLo.X1 := Para.rDPr_BbFilt_Pstart; 
			xSigScal_R_DPrLo.Y1 := Para.rDPr_BbFilt_Lo_P1; 
			xSigScal_R_DPrLo.X2 := 1.0; 						(* 100% = nominal power *) 
			xSigScal_R_DPrLo.Y2 := Para.rDPr_BbFilt_Lo_P2;
			xSigScal_R_DPrLo();
			

			IF (bRelMon_Pr_a_BbFilt AND bRelMon_Pr_f_BbFilt) THEN
				bAMM_DPr_BbFilt_Hi		:= (rDPr_BbFilt   >  xSigScal_R_DPrHi.Y_SCAL);									(* W2653 *)
				bAMM_DPr_BbFilt_Lo		:= (rDPr_BbFilt   < (xSigScal_R_DPrLo.Y_SCAL * 0.75));							(* W2654 *)
			END_IF;
			
			IF (bRelMon_Pr_a_BbFilt_A AND bRelMon_Pr_f_BbFilt_A) THEN
				bAMM_DPr_BbFilt_A_Hi	:= (rDPr_BbFilt_A >  xSigScal_R_DPrHi.Y_SCAL);									(* W2758 *)
				bAMM_DPr_BbFilt_A_Lo	:= (rDPr_BbFilt_A < (xSigScal_R_DPrLo.Y_SCAL * 0.75));							(* W2760 *)
			END_IF;
			
			IF (bRelMon_Pr_a_BbFilt_B AND bRelMon_Pr_f_BbFilt_B) THEN
				bAMM_DPr_BbFilt_B_Hi	:= (rDPr_BbFilt_B >  xSigScal_R_DPrHi.Y_SCAL);									(* W2759 *)
				bAMM_DPr_BbFilt_B_Lo	:= (rDPr_BbFilt_B < (xSigScal_R_DPrLo.Y_SCAL * 0.75));							(* W2761 *)
			END_IF;
		END_IF;


		(*------------------------------------------------------------------*)	
		(* Blow by blower			 										*)
		(*------------------------------------------------------------------*)	
		(* error by DI *)
		bAMM_BbBlower_Not_Rdy	:= NOT IN_AG.tBbBlower_FC_Rdy.Di; 			(* M.03-M-001 *)							(* W2650 *)

		(* error blow by blower SPEED max *)
		bAMM_Pc_BbBlower_Hi 	:= (rPc_BbBlower > Para.rPc_BbBlower_Hi) AND OUT_AG.tBbBlower.Do AND Para.bCtr_CC;		(* W2591 *)



		(*----------------------------------------------------------------------*)	
		(* monitoring crank case pressure according to actual power				*)
		(*----------------------------------------------------------------------*)	
		IF 	bRelMon_Pr_CC AND (IN_AG.rP_Act_Norm_Filt > Para.rP_CC_MonActive_LimHi) 
		THEN
			(*--------------------------------------------------*)	
			(* crank case pressure MIN 					  		*)
			(*--------------------------------------------------*)	
			bAMM_Pr_CC_Lo 		:= IN_AG.tPr_CC.Ai < Para.rPr_CC_Lo;													(* W2649 *)

			(*--------------------------------------------------*)	
			(* crank case pressure MAX / POWER REDUCTION  		*)
			(*--------------------------------------------------*)	
			bAMM_Pr_CC_Hi 		:= IN_AG.tPr_CC.Ai > Para.rPr_CC_Hi;													(* W2558 *)
		

			IF xEngType.Type9 THEN
				(* power reduction from actual power step by step *)													(* B2875 *)
				xTON_Pr_CC_Hi(IN:= (IN_AG.tPr_CC.Ai >= Para.rPr_CC_Hi) AND NOT xTON_Pr_CC_Hi.Q, PT:= Para.tiPr_CC_Hi);
				
				IF xTON_Pr_CC_Hi.Q THEN
					OUT_AG.rP_Red_Pr_CC_Norm 	:= LIMIT(0, rP_Act_Norm_Save - Para.rP_Red_CC, 1.0); 
				ELSE
					rP_Act_Norm_Save			:= IN_AG.rP_Act_Norm_Filt;		(* save actual power *)
				END_IF;
	
				(* Reset power reduction step by step *)
				xTON_Pr_CC_OK(IN:= (IN_AG.tPr_CC.Ai < Para.rPr_CC_Hi) AND (OUT_AG.rP_Red_Pr_CC_Norm < 1.0) AND NOT xTON_Pr_CC_OK.Q, 
							  PT:= T#60s);
	
				IF xTON_Pr_CC_OK.Q THEN
					OUT_AG.rP_Red_Pr_CC_Norm	:= LIMIT(0, OUT_AG.rP_Red_Pr_CC_Norm + Para.rP_Red_CC, 1.0);
				END_IF;
			ELSE
				(* Reset power reduction *)
				xTON_Pr_CC_Hi(IN:= FALSE);
				xTON_Pr_CC_OK(IN:= FALSE);
				OUT_AG.rP_Red_Pr_CC_Norm 		:= 1.0;			(* release full load - no reduction *)
			END_IF;

			(*--------------------------------------------------*)	
			(* crank case pressure MAX / SHUT DOWN		  		*)
			(*--------------------------------------------------*)	
			xTON_Pr_CC_HiHi(IN	:= IN_AG.tPr_CC.Ai > Para.rPr_CC_LimHiHi, PT:= Para.tiPr_CC_HiHi);
			bAMM_Pr_CC_HiHi 	:= xTON_Pr_CC_HiHi.Q AND NOT xTOF_BlocTrip_Pr_CC_HiHi.Q;								(* A3322 *)
		ELSE
			(* Reset power reduction *)
			xTON_Pr_CC_Hi	(IN:= FALSE);
			xTON_Pr_CC_OK	(IN:= FALSE);
			xTON_Pr_CC_HiHi	(IN:= FALSE);
			OUT_AG.rP_Red_Pr_CC_Norm 		:= 1.0;			(* release full load - no reduction *)
		END_IF;

		(*----------------------------------------------------------------------*)	
		(* monitoring crank case pressure independent to actual power			*)
		(*----------------------------------------------------------------------*)	
		(*--------------------------------------------------*)	
		(* crank case pressure MAX / SHUT DOWN		  		*)
		(*--------------------------------------------------*)	
		bAMM_Pr_CC_HiHi 	:=	((IN_AG.tPr_CC.Ai > (Para.rPr_CC_LimHiHi + 0.002) AND bRelMon_Pr_CC) OR bAMM_Pr_CC_HiHi)	(* A3322 *)
							AND	NOT xTOF_BlocTrip_Pr_CC_HiHi.Q;

	ELSE
		(* Reset monitoring TOF	*)
		xTOF_AMM_Pr_CC_MsMs      (IN:= FALSE, PT:= T#0s);
		xTOF_AMM_Pr_f_BbFilt_Ms  (IN:= FALSE, PT:= T#0s);
		xTOF_AMM_Pr_f_BbFilt_A_Ms(IN:= FALSE, PT:= T#0s);
		xTOF_AMM_Pr_f_BbFilt_B_Ms(IN:= FALSE, PT:= T#0s);
		xTOF_AMM_Pr_a_BbFilt_Ms  (IN:= FALSE, PT:= T#0s);
		xTOF_AMM_Pr_a_BbFilt_A_Ms(IN:= FALSE, PT:= T#0s);
		xTOF_AMM_Pr_a_BbFilt_B_Ms(IN:= FALSE, PT:= T#0s);
		
		(* Reset power reduction *)
		xTON_Pr_CC_Hi	(IN:= FALSE);
		xTON_Pr_CC_OK	(IN:= FALSE);
		xTON_Pr_CC_HiHi	(IN:= FALSE);
		OUT_AG.rP_Red_Pr_CC_Norm	:= 1.0;					(* release full load - no reduction *)
	END_IF;

END_PROGRAM