(*******************************************************************************
gas_train

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.30.0		06.11.2014  Tinello	NEW specification
V4.03.00  	13.11.2014  Mari 		Porting J920 FOR XT4
			09.02.2014  Denk 		Bugfix, monitoring OF load rejection
			02.06.2015  Denk		MM2VIS.rPr_PCGT_sp, MM2VIS.rPr_MGT_sp now in gas_train task
V4.04.00	03.07.2016	Denk		Blow off valve Open, Spec. change: gasrail pressure > baro pressure + 80mbar (IN_GT.rPr_Baro_Internal + 0.08)
			04.08.2016	Denk		Bugfix, Filterung charge pressure
			15.09.2016	Denk 		set/actual gas pressure comparison, hard coded values changed
			20.10.2016	Tinello		A2271 deleted / A2261 change limit from 60mbar to 100mbar
V4.05.00	24.04.2017	Denk		SWAT 920 Rel.2, A2247 deleted, W2462 new, B2927 new, OUT_GT.bAMM_Pr_MGT_a_Filt_BlockStart new
									SWAT 920 Rel.2, A3377 active > 2MW
			10.07.2017	Denk		SWAT 920 Rel.3, A2257 deleted, W2465 new, B2928 new, OUT_GT.bAMM_Pr_PCGT_a_Filt_BlockStart new
V4.07.00	30.04.2018	Denk		SWAT 920 Rel.5, change A2289 to W2570
									SWAT 920 Rel.5,	deactivation of A3376 when pressure based control is active
									SWAT 920 Rel.5,	W3445 delay time
V4.07.00	10.12.2018	Zengerer 	Gas valve position detection for Requisition standardisation
V4.07.01	28.08.2019	Zengerer 	Upstream Gas valve tGV_Upstream_Open
V4.09.00BETA 02.10./10.07.2019	Ze 	iGasTrain_Upstream_Type.0 corr. basisupdate
		 	21.08.2019	Zengerer 	Alternative path, if NO selection bit from Para.iGasTrain_Upstream_Type is active 
		 	19.11.2019	Zengerer 	Customer Main Gas Valve control and position feedback according to updated spec from Lang Thomas
V4.10.00    05.08.2020  Zuschnig    Added control of dome blow off valve  		
			07.12.2020	Zengerer	IN_GT.tFastStartReq for change according to issue # 
V4.11.00	22.06.2021	Arnold		data center serialization: calculation of rPr_MGT_sp based on IN_GT.rPr_Leanox_Set; DBOV different hysteresis and time delay
			20.01.2022	Zuschnig	Update A2289 - Compressed air supply failure
			11.02.2022 	Zuschnig	Remove engine demand for release of upstream gas valve
V4.12.00	22.01.2023	Zuschnig	Add H2 content processing and detection of measurement failure 
V4.14.00	06.11.2024	Kafka		fast gastrain for Gen2 type9 
				
Instructions for use:
--------------------
Use UPSTREAM MAIN GAS VALVE OPTION 0 or 1 only (OUT_GT.tGV_Upstream_Open)
UPSTREAM MAIN GAS VALVE OPTION 2  HAS TO BE IMPLEMENTED ACCORDING TO CUSTOMIZED NEEDS in V4.07!
(not global released in V4.07, until sufficient pilot plant installation and testing, according email Hirzinger- Unterrainer, 28.05.2019)

ToDo:
-----


*******************************************************************************)
PROGRAM _CYCLIC

	(*--------------------------------------------------------------*)	
	(* RESET of alarms and warnings and pre-settings				*)
	(*--------------------------------------------------------------*)	
	bAMM_GT_AirSupply_Lo		:= FALSE;
	bAMM_GT_AirSupply_LoLo		:= FALSE;

	bAMM_DPr_GR_Baro_HiHi		:= FALSE;	(* A2261 *)

	bAMM_Pr_PCGT_Out_MS			:= FALSE;	(* W3448 *)

	bAMM_Pr_MGT_a_Filt_MS		:= FALSE;	(* W2462 *)
	bAMM_Pr_MGT_a_Filt_Lo		:= FALSE;	(* W2535 *)
	bAMM_Pr_MGT_a_Filt_LoLo		:= FALSE;	(* A2243 *)
	bAMM_Pr_MGT_a_Filt_Hi		:= FALSE;	(* W2536 *)
	bAMM_Pr_MGT_a_Filt_HiHi		:= FALSE;	(* A2246 *)
	bAMM_DPr_MGT_SetAct_Hi		:= FALSE;	(* W3444 *)
	bAMM_DPr_MGT_SetAct_HiHi	:= FALSE;	(* A3376 *)

	bAMM_Pr_PCGT_a_Filt_MS		:= FALSE;	(* W2465 *)
	bAMM_Pr_PCGT_a_Filt_Lo		:= FALSE;	(* W2537 *)	(*nicht verwendet*)
	bAMM_Pr_PCGT_a_Filt_LoLo	:= FALSE;	(* A2250 *)	(*nicht verwendet*)
	bAMM_Pr_PCGT_a_Filt_Hi		:= FALSE;	(* W2538 *)
	bAMM_Pr_PCGT_a_Filt_HiHi	:= FALSE;	(* A2251 *)
	bAMM_DPr_PCGT_SetAct_Hi		:= FALSE;	(* W3445 *)
	bAMM_DPr_PCGT_SetAct_HiHi	:= FALSE;	(* A3377 *)
	
	(* Reset set-/actual-pressure deviation calculation *)
	rDPr_MGT_SetAct				:= 0;	
	rDPr_PCGT_SetAct			:= 0;

	(* Mapping of previous parameter for compatibility of visu *)
	Para.bPr_MGT_a_Filt_Exist	:= Para.bPr_GT1_Active;
	Para.rPr_MGT_a_Filt_Hi		:= Para.rPr_GT1_LimHi2; 	
	Para.rPr_MGT_a_Filt_HiHi	:= Para.rPr_GT1_LimHi1;	
	Para.rPr_MGT_a_Filt_Lo		:= Para.rPr_GT1_LimLo2;	
	Para.rPr_MGT_a_Filt_LoLo	:= Para.rPr_GT1_LimLo1;	

	Para.bPr_PCGT_a_Filt_Exist  := Para.bPr_PCGT_Active;
	Para.rPr_PCGT_a_Filt_Hi		:= Para.rPr_PCGT_LimHi2;
	Para.rPr_PCGT_a_Filt_HiHi	:= Para.rPr_PCGT_LimHi1;
	Para.rPr_PCGT_a_Filt_Lo		:= Para.rPr_PCGT_LimLo2;
	Para.rPr_PCGT_a_Filt_LoLo	:= Para.rPr_PCGT_LimLo1;


	(*--------------------------------------------------------------*)	
	(* gas valve			 		 								*)
	(*--------------------------------------------------------------*)	
	xTON_GASV_08s(IN:= OUT_GT.tGV1_Open.Do,	PT:= T#8s); 
	xTON_GASV_20s(IN:= OUT_GT.tGV1_Open.Do, PT:= T#20s); 
	
	bGASV_Open_8s	:= xTON_GASV_08s.Q;											(* valve opened for  8 seconds *)
	bGASV_Open_20s	:= xTON_GASV_20s.Q;											(* valve opened for 20 seconds *)

	
	(*--------------------------------------------------------------*)	
	(* Filterung charge pressure			 		 								*)
	(*--------------------------------------------------------------*)
	xFILTER_R_P2s_200ms(In := IN_GT.rPr_Ch_P2s_Avg_UF, Filter := 20);
	xFILTER_R_P2s_50ms(In := IN_GT.rPr_Ch_P2s_Avg_UF, Filter := 5);
	xFILTER_R_P2s_500ms(In := IN_GT.rPr_Ch_P2s_Avg_UF, Filter := 50);
	xFILTER_R_P2s_160ms(In := IN_GT.rPr_Ch_P2s_Avg_UF, Filter := 16);
	
	(*--------------------------------------------------------------*)	
	(* Filtering H2 content			 		 								*)
	(*--------------------------------------------------------------*)
	IF Para.bGT_H2Active THEN
		bMSF_H2 := (NOT IN_GT.tGT_H2.GoodQual AND IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.bH2_Bus_Active) OR
				   (NOT IN_GT.bH2_Bus_MSF AND IN_GT.tPB2MM.bParaSetupOk AND IN_GT.bH2_Bus_Active);  
		(* Measurement signal failure H2 content self-retain *)
		bS_MSF_H2 := bMSF_H2 OR (bS_MSF_H2 AND NOT IN_GT.tAB2GT.bResetWarning);
	ELSE
		bMSF_H2 				:= FALSE;
		bS_MSF_H2				:= FALSE;
	END_IF;
	
	IF Para.tiFilterConst_H2 = 0 THEN
		xLCRPT1_H2.t := 0.001; (* Filter time constant [s] *)
	ELSE
		xLCRPT1_H2.t := TIME_TO_REAL(Para.tiFilterConst_H2) /1000; (* Filter time constant [s] *)
	END_IF;
	IF NOT Para.bGT_H2Active THEN	(* Switch to zero H2 value in case H2 content measurement is not active *)
		xLCRPT1_H2.x := 0;
	ELSIF bS_MSF_H2 THEN			(* Switch to default H2 value in case of measurement signal failure H2 content *)
		xLCRPT1_H2.x := Para.rGT_H2_DefVal;
	ELSIF NOT IN_GT.bH2_Bus_Active THEN 
		xLCRPT1_H2.x := LIMIT(0, IN_GT.tGT_H2.Unfilt, 1);
	ELSE
		xLCRPT1_H2.x := LIMIT(0, IN_GT.rH2_Bus, 1);
	END_IF;
	xLCRPT1_H2();
	
	(************************************************************************************************************************************)
	(************************              				  error monitoring		 	             	           **************************)
	(************************************************************************************************************************************)
	IF IN_GT.tPB2MM.bParaSetupOk THEN
	
		(*----------------------------------------------------------*)	
		(* measurement signal failure 								*)
		(*----------------------------------------------------------*)	
		bAMM_Pr_MGT_a_Filt_MS		:= Para.bPr_MGT_a_Filt_Exist 	AND NOT IN_GT.tPr_MGT_a_Filt.GoodQual;						(* W2462 *)
		bAMM_Pr_PCGT_a_Filt_MS		:= Para.bPr_PCGT_a_Filt_Exist	AND NOT IN_GT.tPr_PCGT_a_Filt.GoodQual;						(* W2465 *)
		bAMM_Pr_PCGT_Out_MS			:= Para.bPr_PCGT_Out_Exist 		AND NOT IN_GT.tPr_PCGT_Out.GoodQual;						(* W3448 *)
	
		(* Release monitoring *)
		xTOF_AMM_Pr_MGT_a_Filt_MS(IN := bAMM_Pr_MGT_a_Filt_MS, 	PT:= T#10s);	(* TOF because of filtered signals *)	
		xTOF_AMM_Pr_PCGT_a_Filt_MS(IN:= bAMM_Pr_PCGT_a_Filt_MS, PT:= T#10s);
		xTOF_AMM_Pr_PCGT_Out_MS(IN 	 := bAMM_Pr_PCGT_Out_MS, 	PT:= T#10s);

		bRelMon_Pr_MGT_a_Filt	:= Para.bPr_MGT_a_Filt_Exist   	AND NOT xTOF_AMM_Pr_MGT_a_Filt_MS.Q;
		bRelMon_Pr_PCGT_a_Filt	:= Para.bPr_PCGT_a_Filt_Exist   AND NOT xTOF_AMM_Pr_PCGT_a_Filt_MS.Q;
		bRelMon_Pr_PCGT_Out		:= Para.bPr_PCGT_Out_Exist   	AND NOT xTOF_AMM_Pr_PCGT_Out_MS.Q;

		(* Block engine start after 5 times W2462 *) (* SWAT Rel.2 *)										
		xCTD_Start(CD:= IN_GT.bEng_Start_TC2, LOAD:= NOT MM2VIS.bMsg2462, PV:= 5);	
		xSR_Block(SET1:= xCTD_Start.Q AND EDGENEG(IN_GT.tEng_Run.Do), RESET:= NOT MM2VIS.bMsg2462);
		OUT_GT.bAMM_Pr_MGT_a_Filt_BlockStart := xSR_Block.Q1;
		
		(* Block engine start after 5 times W2465 *) (* SWAT Rel.3 *)										
		xCTD_Start2465(CD:= IN_GT.bEng_Start_TC2, LOAD:= NOT MM2VIS.bMsg2465, PV:= 5);	
		xSR_Block2465(SET1:= xCTD_Start2465.Q AND EDGENEG(IN_GT.tEng_Run.Do), RESET:= NOT MM2VIS.bMsg2465);
		OUT_GT.bAMM_Pr_PCGT_a_Filt_BlockStart := xSR_Block2465.Q1;
		
		(*----------------------------------------------------------*)	
		(* deviation gas rail pressure from barometric pressure MAX	*)
		(*----------------------------------------------------------*)	
		xTON_FGDRPS(IN:= IN_GT.tPB2MM.bParaSetupOk, PT:= T#60s); 	(* because of barometric ramp up *)
		
		IF bN_EngAct_IsZero AND NOT IN_GT.tEng_Run.Do AND xTON_FGDRPS.Q THEN 
			bAMM_DPr_GR_Baro_HiHi	:= rPr_GR_Avg > (IN_GT.rPr_Baro_Internal + 0.100) AND bRelMon_Pr_GR_Avg;(* 100 mbar *)		(* A2261 *)
		END_IF
		
		
		(*----------------------------------------------------------*)	
		(* main gas train pressure after filter 					*)
		(*----------------------------------------------------------*)	
		xGR_MINR_MGT_a_Filt(In	:= IN_GT.tPr_MGT_a_Filt.Ai, Gw:= Para.rPr_MGT_a_Filt_Lo, Hy:= 0.1);		(* hyst. = 100 mbar *)		
		xGR_MAXR_MGT_a_Filt(In	:= IN_GT.tPr_MGT_a_Filt.Ai,	Gw:= Para.rPr_MGT_a_Filt_Hi, Hy:= 0.1);		(* hyst. = 100 mbar *)		

		bAMM_Pr_MGT_a_Filt_Lo		:= xGR_MINR_MGT_a_Filt.Q 								AND bRelMon_Pr_MGT_a_Filt;			(* W2535 *)
		bAMM_Pr_MGT_a_Filt_Hi		:= xGR_MAXR_MGT_a_Filt.Q 								AND bRelMon_Pr_MGT_a_Filt;			(* W2536 *)
		bAMM_Pr_MGT_a_Filt_LoLo		:= (IN_GT.tPr_MGT_a_Filt.Ai < Para.rPr_MGT_a_Filt_LoLo)	AND bRelMon_Pr_MGT_a_Filt;			(* A2243 *)
		bAMM_Pr_MGT_a_Filt_HiHi		:= (IN_GT.tPr_MGT_a_Filt.Ai > Para.rPr_MGT_a_Filt_HiHi) AND bRelMon_Pr_MGT_a_Filt;			(* A2246 *)


		(*----------------------------------------------------------*)	
		(* prechamber gas train pressure after filter 				*)
		(*----------------------------------------------------------*)	
		xGR_MINR_PCGT_a_Filt(In	:= IN_GT.tPr_PCGT_a_Filt.Ai, Gw:= Para.rPr_PCGT_a_Filt_Lo, Hy:= 0.1);	(* hyst. = 100 mbar *)		
		xGR_MAXR_PCGT_a_Filt(In	:= IN_GT.tPr_PCGT_a_Filt.Ai, Gw:= Para.rPr_PCGT_a_Filt_Hi, Hy:= 0.1);	(* hyst. = 100 mbar *)		

		bAMM_Pr_PCGT_a_Filt_Lo		:= xGR_MINR_PCGT_a_Filt.Q 									AND bRelMon_Pr_PCGT_a_Filt;		(* W2537 *)
		bAMM_Pr_PCGT_a_Filt_Hi		:= xGR_MAXR_PCGT_a_Filt.Q 									AND bRelMon_Pr_PCGT_a_Filt;		(* W2538 *)
		bAMM_Pr_PCGT_a_Filt_LoLo	:= (IN_GT.tPr_PCGT_a_Filt.Ai < Para.rPr_PCGT_a_Filt_LoLo)	AND bRelMon_Pr_PCGT_a_Filt;		(* A2250 *)
		bAMM_Pr_PCGT_a_Filt_HiHi	:= (IN_GT.tPr_PCGT_a_Filt.Ai > Para.rPr_PCGT_a_Filt_HiHi)	AND bRelMon_Pr_PCGT_a_Filt;		(* A2251 *)
		
		
		(*----------------------------------------------------------*)	
		(* gas train compressed air supply 							*)
		(*----------------------------------------------------------*)	
		bAMM_GT_AirSupply_Lo		:= NOT IN_GT.tGT_AirSupply_LoLo.Di; 														(* W2570 - SWAT5 new *)															(* A2289 *)
	END_IF

	(************************************************************************************************************************************)
    (************************                                monitoring of load rejection                      **************************)
    (************************************************************************************************************************************)
    xTP_LoadReject(IN:= (p_ist_Old - (IN_GT.rP_Nom * IN_GT.rP_Act_Norm_Filt)) > 500.0, PT:= T#60s);
                              
    (* Save actual power every second *)
    xTON_1000ms(IN:= NOT xTON_1000ms.Q, PT:= T#1000ms);
                              
    IF xTON_1000ms.Q THEN p_ist_Old := (IN_GT.rP_Nom * IN_GT.rP_Act_Norm_Filt);	END_IF

	(************************************************************************************************************************************)
	(************************           					  main gas train  					 		       **************************)
	(************************************************************************************************************************************)

	(*--------------------------------------------------------------*)	
	(* gas pressure SETPOINT calculation							*)
	(*--------------------------------------------------------------*)	
	xRAMPE_R_DPr_MGT_P1(In		:= Para.rDPr_MGT_P1);			(* The parameters are delivered to the calculation via ramp *)
	xRAMPE_R_DPr_MGT_P2(In		:= Para.rDPr_MGT_P2);			(* ramp = 10 mbar/s *)				
	xRAMPE_R_DPr_MGT_Ch_P1(In	:= Para.rDPr_MGT_Ch_P1);
	xRAMPE_R_DPr_MGT_Ch_P2(In	:= Para.rDPr_MGT_Ch_P2);

	IF NOT xEngType.Type9 THEN
		xSigScal_R_DPr_MGT_sp.X		:= IN_GT.rPr_Ch_P2s_Avg;
	ELSE
		xSigScal_R_DPr_MGT_sp.X		:= xFILTER_R_P2s_160ms.Out;
	END_IF
	
	xSigScal_R_DPr_MGT_sp.X1	:= xRAMPE_R_DPr_MGT_Ch_P1.Out;	
	xSigScal_R_DPr_MGT_sp.X2	:= xRAMPE_R_DPr_MGT_Ch_P2.Out;
	xSigScal_R_DPr_MGT_sp.Y1	:= xRAMPE_R_DPr_MGT_P1.Out;
	xSigScal_R_DPr_MGT_sp.Y2	:= xRAMPE_R_DPr_MGT_P2.Out;
	xSigScal_R_DPr_MGT_sp();

	(* absolute --> relative *)
	IF xEngType.Type6 AND IN_GT.bGen2_Act AND IN_GT.tGCB_On.Di THEN
		rPr_MGT_sp				:= MIN(MAX(xFILTER_R_P2s_500ms.Out , IN_GT.rPr_Leanox_Set), (xFILTER_R_P2s_500ms.Out  + rPr_max_P2s_Offset)) + xSigScal_R_DPr_MGT_sp.Y_SCAL - IN_GT.rPr_Baro_Internal;	
	ELSIF xEngType.Type9 AND IN_GT.bGen2_Act AND IN_GT.tGCB_On.Di THEN
		rPr_MGT_sp				:= MIN(MAX(xFILTER_R_P2s_160ms.Out , IN_GT.rPr_Leanox_Set), (xFILTER_R_P2s_160ms.Out  + rPr_max_P2s_Offset)) + xSigScal_R_DPr_MGT_sp.Y_SCAL - IN_GT.rPr_Baro_Internal;			
	ELSE
		rPr_MGT_sp				:= xFILTER_R_P2s_500ms.Out + xSigScal_R_DPr_MGT_sp.Y_SCAL - IN_GT.rPr_Baro_Internal;		
	END_IF;
	
	MM2VIS.rPr_MGT_sp			:= rPr_MGT_sp;	(* VISU *)

	(*--------------------------------------------------------------*)	
	(* calculated gas pressure after main gas pressure regulator	*)
	(*--------------------------------------------------------------*)	
	xSigScal_R_MGT_PipeLoss.X	:= IN_GT.rPr_Ch_P2s_Avg;
	xSigScal_R_MGT_PipeLoss.X1	:= Para.rPr_MGT_PipeLoss_Ch_P1;	
	xSigScal_R_MGT_PipeLoss.X2	:= Para.rPr_MGT_PipeLoss_Ch_P2;
	xSigScal_R_MGT_PipeLoss.Y1	:= Para.rPr_MGT_PipeLoss_P1;
	xSigScal_R_MGT_PipeLoss.Y2	:= Para.rPr_MGT_PipeLoss_P2;
	xSigScal_R_MGT_PipeLoss();

	(* absolute --> relative *)
	IF OUT_GT.tGV1_Open.Do THEN  
		rPr_MGT_Out_Calc		:= rPr_GR_Avg + xSigScal_R_MGT_PipeLoss.Y_SCAL - IN_GT.rPr_Baro_Internal;			(* VISU *)
	ELSE
		rPr_MGT_Out_Calc		:= 0;
	END_IF

	(*--------------------------------------------------------------*)	
	(* set/actual gas pressure comparison							*)
	(*--------------------------------------------------------------*)	
	(* calculation of set/actual gas pressure deviation *)
	IF OUT_GT.tGV1_Open.Do AND bRelMon_Pr_GR_Avg THEN 
		rDPr_MGT_SetAct	:= rPr_MGT_Out_Calc - rPr_MGT_sp; 											(* VISU *)
	END_IF

	(* monitoring of set/actual gas pressure deviation *)
	IF bGASV_Open_20s AND NOT xTP_LoadReject.Q THEN 
		bAMM_DPr_MGT_SetAct_Hi 		:= ABS(rDPr_MGT_SetAct) > 0.2 OR bMGT_SetActAdjust_Windup;		(* 200 mbar *)		(* W3444 *)
		bAMM_DPr_MGT_SetAct_HiHi	:= (ABS(rDPr_MGT_SetAct) > 0.4) AND NOT IN_GT.bPBC_Active; 		(* 400 mbar *)		(* A3376 *)		(* SWAT Rel. 5 *)
	END_IF

	IF IN_GT.tPB2MM.bParaSetupOk THEN
		bAMM_GT_AirSupply_LoLo		:= bAMM_DPr_MGT_SetAct_Hi AND NOT IN_GT.tGT_AirSupply_LoLo.Di;  (* A2289 *)	 		                    
	END_IF;	

	(*--------------------------------------------------------------*)	
	(* set/actual gas pressure adjustment							*)
	(*--------------------------------------------------------------*)	
	(* On-/off-switching of function only if engine isn't running *)
	IF bN_EngAct_IsZero THEN	bMGT_SetActAdjustActive_Save := Para.bMGT_SetActAdjustActive; END_IF		
	
	IF IN_GT.tPB2MM.bParaSetupOk THEN	Para.bMGT_SetActAdjustActive := bMGT_SetActAdjustActive_Save; END_IF	(* parameter only changeable if engine isn't running *)

	IF Para.bMGT_SetActAdjustActive THEN			

		(* time until next run of controller - Integralverstärkung *)		
		xTON_MGT_SetActAdjust(IN:= bRel_MGT_SetActAdjust, PT:= T#1s);	
		bRel_MGT_SetActAdjust	:= TRUE;

		(* duration of set/actual gas pressure adjustment *)
		xTP_MGT_SetActAdjust(IN	:= bGASV_Open_8s, 		  PT:= T#10s);		
		
		IF 	xTP_MGT_SetActAdjust.Q 	AND	OUT_GT.tGV1_Open.Do AND 
			xTON_MGT_SetActAdjust.Q			  				AND
			NOT bMGT_SetActAdjust_Windup 	  				AND 
			bRelMon_Pr_GR_Avg			 
		THEN
			(* calculation of set/actual gas pressure deviation *)
			rDPr_MGT_SetAct_GR			:= (rPr_MGT_sp + IN_GT.rPr_Baro_Internal) - rPr_GR_Avg; 

			(* Der maximal zulässige Ausgleichsauf- bzw. -abschlag beträgt 400mbar *)
			Perm.rDPr_MGT_SetActAdjust	:= LIMIT(-0.405, Perm.rDPr_MGT_SetActAdjust + (rDPr_MGT_SetAct_GR * 0.5), 0.405);
			bRel_MGT_SetActAdjust		:= FALSE;
		END_IF
	ELSE
		Perm.rDPr_MGT_SetActAdjust	:= 0;		(* RESET *)
	END_IF


	(*--------------------------------------------------------------*)	
	(* FIXED gas pressure setpoint in case of emergency stop		*)
	(*--------------------------------------------------------------*)	
	xTP_Pr_MGT_sp_fix(IN:= EDGENEG(OUT_GT.tGV1_Open.Do) AND (bGnlTrip1 OR bGnlTrip2), PT:= T#10s);

	IF xTP_Pr_MGT_sp_fix.Q	THEN 		(* fixed gas pressure of 130 mbar *)
		rPr_MGT_sp := 0.130;				
		MM2VIS.rPr_MGT_sp := 0.130;
	ELSIF NOT OUT_GT.tGV1_Open.Do THEN 	(* engine is not running *)
		rPr_MGT_sp := 0;
		MM2VIS.rPr_MGT_sp := 0;										
	ELSE 								(* controlled gas pressure setpoint *)
		rPr_MGT_sp := rPr_MGT_sp + Perm.rDPr_MGT_SetActAdjust;	
	END_IF

	(*--------------------------------------------------------------*)	
	(* handover gas pressure setpoint to AO		 					*)
	(*--------------------------------------------------------------*)		
	OUT_GT.tPr_MGT_sp.Ao 		:=  rPr_MGT_sp - Para.rPr_MGT_sp_offset;
	bMGT_SetActAdjust_Windup	:= (OUT_GT.tPr_MGT_sp.Ao <= Para.rPr_MGT_spScalMin) OR (OUT_GT.tPr_MGT_sp.Ao >= Para.rPr_MGT_spScalMax); 

	(************************************************************************************************************************************)
	(************************           			  main gas train - blow off valve			  		       **************************)
	(************************************************************************************************************************************)
	xTP_MGT_BOV_Open_Min(IN:= EDGENEG(OUT_GT.tGV1_Open.Do), PT:= Para.tiBOV_Open_Min);		(* mimimum opening time at shut down *)
	xTP_MGT_BOV_Open_Max(IN:= EDGENEG(OUT_GT.tGV1_Open.Do), PT:= Para.tiBOV_Open_Max);		(* maximum opening time at shut down *)

	(*--------------------------------------------------------------*)	
	(* Deviation gas rail pressure from charging pressure			*)
	(*--------------------------------------------------------------*)	
	IF IN_GT.bGT_GrC_Bloc THEN
		rDPr_GR_BOV_Open := 2.5;
	ELSE
		rDPr_GR_BOV_Open := Para.rDPr_GR_BOV_Open;
	END_IF;
	xGR_MAXR_DPr_GR_P2s(In:= rPr_GR_Avg - xFILTER_R_P2s_50ms.Out, Gw:= rDPr_GR_BOV_Open, Hy:= Para.rDPr_GR_BOV_Open_Hy); 

	(* Gasrail is not allowed to be lower than the barometric pressure otherwise air could flow into the GasRail-> flammable mix *)
	IF (rPr_GR_Avg > IN_GT.rPr_Baro_Internal) THEN				
		OUT_GT.tMGT_BOV.Do	:= 		xGR_MAXR_DPr_GR_P2s.Q  OR (* open on differential pressure between boost pressure and gas rail pressure *)
									(xTP_MGT_BOV_Open_Max.Q AND (* limit the opening duration to a maximum time *)
									(xTP_MGT_BOV_Open_Min.Q OR  (* limit the opening duration to a minimum time *)
									(rPr_GR_Avg > (IN_GT.rPr_Baro_Internal + 0.08)))); (* close on reaching barometric pressure plus offset *)
	ELSE
		OUT_GT.tMGT_BOV.Do	:= FALSE;
	END_IF

	(************************************************************************************************************************************)
	(************************            main gas train - pressure regulator dome blow off valve	            *************************)
	(************************************************************************************************************************************)
	
	(* Hysteresis for activating dome blow off valve on the gas rail set-act pressure deviation *)
	IF xEngType.Type6 THEN
		rDPr_MGT_DBOV_SetAct_GR_Hy := 0.25;
		rDPr_MGT_DBOV_SetAct_GR_Th := 0.30;
	ELSIF xEngType.Type9 THEN		
		rDPr_MGT_DBOV_SetAct_GR_Hy := 0.05;
		rDPr_MGT_DBOV_SetAct_GR_Th := 0.50;
	ELSE
		rDPr_MGT_DBOV_SetAct_GR_Hy := 0.05;
		rDPr_MGT_DBOV_SetAct_GR_Th := 0.30;
	END_IF;

	xSR_DPr_MGT_DBOV_GR_SetAct.SET1 	:= rPr_MGT_Out_Calc - rPr_MGT_sp >= rDPr_MGT_DBOV_SetAct_GR_Th AND NOT IN_GT.bGT_GrC_Bloc;
	xSR_DPr_MGT_DBOV_GR_SetAct.RESET 	:= rPr_MGT_Out_Calc - rPr_MGT_sp < 	rDPr_MGT_DBOV_SetAct_GR_Th - rDPr_MGT_DBOV_SetAct_GR_Hy OR xTON_MGT_DBOV.Q OR IN_GT.bGT_GrC_Bloc;
	xSR_DPr_MGT_DBOV_GR_SetAct();
	xTON_MGT_DBOV(IN := xSR_DPr_MGT_DBOV_GR_SetAct.Q1);
	
	(* Activate dome blow off valve on positive edge of the main blow off valve for a certain time *)
	xSR_DBOV_MBOV_Logic_Ena(SET1 := EDGEPOS(xTP_LoadReject.Q), RESET := EDGENEG(xTP_LoadReject.Q) OR EDGENEG(OUT_GT.tMGT_BOV.Do));
	xTOF_POS_EDGE_MGT_BOV(IN := EDGEPOS(OUT_GT.tMGT_BOV.Do) AND xSR_DBOV_MBOV_Logic_Ena.Q1);
	
	(* Gasrail is not allowed to be lower than the barometric pressure otherwise air could flow into the GasRail-> flammable mix *)
	IF (rPr_GR_Avg > IN_GT.rPr_Baro_Internal) THEN
		OUT_GT.tMGT_DBOV.Do := 	(xSR_DPr_MGT_DBOV_GR_SetAct.Q1						(* open on set-act deviation of gas rail pressure *)
								OR xTOF_POS_EDGE_MGT_BOV.Q							(* open on positive edge of MBOV for a certain time *)
								OR IN_GT.bLR_Act_DBOV)								(* open on load rejection detection *)
								AND NOT IN_GT.bGT_GrC_Bloc;							(* disable during grid code event *)
	ELSE
		OUT_GT.tMGT_DBOV.Do	:= FALSE;
	END_IF

	(************************************************************************************************************************************)
	(************************           				  prechamber gas train  				 		       **************************)
	(************************************************************************************************************************************)

	(*--------------------------------------------------------------*)	
	(* gas pressure SETPOINT calculation							*)
	(*--------------------------------------------------------------*)	
	xRAMPE_R_DPr_PCGT_P1(In		:= Para.rDPr_PCGT_P1);			(* The parameters are delivered to the calculation via ramp *)
	xRAMPE_R_DPr_PCGT_P2(In		:= Para.rDPr_PCGT_P2);			(* ramp = 10 mbar/s *)				
	xRAMPE_R_DPr_PCGT_Ch_P1(In	:= Para.rDPr_PCGT_Ch_P1);
	xRAMPE_R_DPr_PCGT_Ch_P2(In	:= Para.rDPr_PCGT_Ch_P2);

	xSigScal_R_DPr_PCGT_sp.X	:= IN_GT.rPr_Ch_P2s_Avg;
	xSigScal_R_DPr_PCGT_sp.X1	:= xRAMPE_R_DPr_PCGT_Ch_P1.Out;	
	xSigScal_R_DPr_PCGT_sp.X2	:= xRAMPE_R_DPr_PCGT_Ch_P2.Out;
	xSigScal_R_DPr_PCGT_sp.Y1	:= xRAMPE_R_DPr_PCGT_P1.Out;
	xSigScal_R_DPr_PCGT_sp.Y2	:= xRAMPE_R_DPr_PCGT_P2.Out;
	xSigScal_R_DPr_PCGT_sp();

	(* absolute --> relative *)
	rPr_PCGT_sp					:= IN_GT.rPr_Ch_P2s_Avg + xSigScal_R_DPr_PCGT_sp.Y_SCAL - IN_GT.rPr_Baro_Internal;	
	MM2VIS.rPr_PCGT_sp			:= IN_GT.rPr_Ch_P2s_Avg + xSigScal_R_DPr_PCGT_sp.Y_SCAL - IN_GT.rPr_Baro_Internal;	(* VISU *)	


	(*--------------------------------------------------------------*)	
	(* set/actual gas pressure comparison							*)
	(*--------------------------------------------------------------*)	
	(* calculation of set/actual gas pressure deviation *)
	IF OUT_GT.tGV1_Open.Do AND bRelMon_Pr_PCGT_Out THEN 
		rDPr_PCGT_SetAct		:= IN_GT.tPr_PCGT_Out.Ai - rPr_PCGT_sp; 											(* VISU *)
	END_IF
	
	(* monitoring of  set/actual gas pressure deviation *)
	xTON_bMsg3377_Active(IN:= (IN_GT.rP_Nom * IN_GT.rP_Act_Norm_Filt) > 2000, PT:= T#120s);		(* SWAT Rel.2 *)	
	xSR_bMsg3377_Active(SET1:= IN_GT.bEng_Start_TC2, RESET:= xTON_bMsg3377_Active.Q);				(* SWAT Rel.2 *)
	IF bGASV_Open_20s AND NOT xTP_LoadReject.Q THEN 
		xSigScal_R_SetAct_Hi.X		:= IN_GT.rPr_Ch_P2s_Avg;
		xSigScal_R_SetAct_Hi.X1		:= 0.5;			(*  500 mbar(abs) *)
		xSigScal_R_SetAct_Hi.X2		:= 7.0;			(* 7000 mbar(abs) *)
		xSigScal_R_SetAct_Hi.Y1		:= 0.2;			(*  200 mbar *)
		xSigScal_R_SetAct_Hi.Y2		:= 0.3;			(*  300 mbar *)
		xSigScal_R_SetAct_Hi();

		xSigScal_R_SetAct_HiHi.X	:= IN_GT.rPr_Ch_P2s_Avg;
		xSigScal_R_SetAct_HiHi.X1	:= 0.5;			(*  500 mbar(abs) *)
		xSigScal_R_SetAct_HiHi.X2	:= 7.0;			(* 7000 mbar(abs) *)
		xSigScal_R_SetAct_HiHi.Y1	:= 0.25;		(*  250 mbar *)
		xSigScal_R_SetAct_HiHi.Y2	:= 0.4;			(*  400 mbar *)
		xSigScal_R_SetAct_HiHi();

		bAMM_DPr_PCGT_SetAct_Hi 	:= ABS(rDPr_PCGT_SetAct) > xSigScal_R_SetAct_Hi.Y_SCAL OR bPCGT_SetActAdjust_Windup;		(* W3445 *)				   
		bAMM_DPr_PCGT_SetAct_HiHi	:= (ABS(rDPr_PCGT_SetAct) > xSigScal_R_SetAct_HiHi.Y_SCAL) AND xSR_bMsg3377_Active.Q1;		(* A3377 *)								    		
	END_IF
	
	(* Delay time of W3445 *) (* SWAT Rel.5 *)									
	xTON_DelayTrigger(IN:= IN_GT.tGCB_On.Di AND (IN_GT.rP_Act_Norm_Filt * IN_GT.rP_Nom) > 2000, PT:= T#120s); 
	xSR_DelayTime(SET1:= xTON_DelayTrigger.Q, RESET:= IN_GT.bEng_Start);
	IF xSR_DelayTime.Q1 THEN
		tiDPr_PCGT_SetAct_Hi := T#250s;
	ELSE
		tiDPr_PCGT_SetAct_Hi := T#5s;
	END_IF	
	
	(*--------------------------------------------------------------*)	
	(* set/actual gas pressure adjustment							*)
	(*--------------------------------------------------------------*)	
	(* On-/off-switching of function only if engine isn't running *)
	IF bN_EngAct_IsZero THEN	bPCGT_SetActAdjustActive_Save := Para.bPCGT_SetActAdjustActive;	END_IF
		
	IF IN_GT.tPB2MM.bParaSetupOk THEN	Para.bPCGT_SetActAdjustActive := bPCGT_SetActAdjustActive_Save; END_IF	(* parameter only changeable if engine isn't running *)
			
	IF Para.bPCGT_SetActAdjustActive THEN	
		
		(* time until next run of controller - Integralverstärkung *)		
		xTON_PCGT_SetActAdjust(IN:= bRel_PCGT_SetActAdjust, PT:= T#1s);	
		bRel_PCGT_SetActAdjust	 := TRUE;

		(* duration of set/actual gas pressure adjustment *)
		xTP_PCGT_SetActAdjust(IN := bGASV_Open_8s, 			PT:= T#10s);		
		
		IF 	xTP_PCGT_SetActAdjust.Q  AND OUT_GT.tGV1_Open.Do AND
			xTON_PCGT_SetActAdjust.Q 						 AND
			NOT bPCGT_SetActAdjust_Windup 					 AND
			bRelMon_Pr_PCGT_Out 
		THEN
			(* calculation of set/actual gas pressure deviation *)
			rDPr_PCGT_SetAct_PCGT_Out	:= rPr_PCGT_sp - IN_GT.tPr_PCGT_Out.Ai;

			(* Der maximal zulässige Ausgleichsauf- bzw. -abschlag beträgt 400mbar *)
			Perm.rDPr_PCGT_SetActAdjust	:= LIMIT(-0.405, Perm.rDPr_PCGT_SetActAdjust + (rDPr_PCGT_SetAct_PCGT_Out * 0.5), 0.405);
			bRel_PCGT_SetActAdjust		:= FALSE;
		END_IF

	ELSE
		Perm.rDPr_PCGT_SetActAdjust	:= 0;		(* RESET *)
	END_IF

	(*--------------------------------------------------------------*)	
	(* FIXED gas pressure setpoint in case of engine stop			*)
	(*--------------------------------------------------------------*)	
	IF NOT OUT_GT.tGV1_Open.Do THEN		(* engine is not running *)
		rPr_PCGT_sp := 0;
		MM2VIS.rPr_PCGT_sp := 0;													
	ELSE 								(* controlled gas pressure setpoint *)
		rPr_PCGT_sp := rPr_PCGT_sp + Perm.rDPr_PCGT_SetActAdjust;	
	END_IF

	(*--------------------------------------------------------------*)	
	(* handover gas pressure setpoint to AO		 					*)
	(*--------------------------------------------------------------*)	
	OUT_GT.tPr_PCGT_sp.Ao 	  := rPr_PCGT_sp - Para.rPr_PCGT_sp_offset;
	bPCGT_SetActAdjust_Windup := (OUT_GT.tPr_PCGT_sp.Ao <= Para.rPr_PCGT_spScalMin) OR (OUT_GT.tPr_PCGT_sp.Ao >= Para.rPr_PCGT_spScalMax); 		
	
	(*--------------------------------------------------------------*)	
	(* Option: gas valve position feedback		 					*) (* V4.07 *)
	(*--------------------------------------------------------------*)	
	tGV_struct[1].alm_1sf := (	  OUT_GT.tGV1_Open.Do AND (NOT IN_GT.tGV1_Opened.Di AND IN_GT.tGV1_Opened.GoodQual) ) ;			(* Gas valve position detection opening failure (->error bit 1) *)
	tGV_struct[1].alm_0sf := (NOT OUT_GT.tGV1_Open.Do AND (NOT IN_GT.tGV1_Closed.Di AND IN_GT.tGV1_Closed.GoodQual) );			(* Gas valve position detection closing failure (->error bit 2)*)
	tGV_struct[1].alm_psf := ( (IN_GT.tGV1_Opened.Di AND IN_GT.tGV1_Opened.GoodQual) AND (IN_GT.tGV1_Closed.Di AND IN_GT.tGV1_Closed.GoodQual) );	(* Gas valve position detection failure (->error bit 3) *)
	tGV_struct[1].gv_status :=	BOOL_TO_DINT(tGV_struct[1].alm_1sf) *2 +			(* forward status for alarms and VIS: any value >1=failure message *) 
								BOOL_TO_DINT(tGV_struct[1].alm_0sf) *4 +
								BOOL_TO_DINT(tGV_struct[1].alm_psf) *8 ;
	
	tGV_struct[2].alm_1sf := (	  OUT_GT.tGV2_Open.Do AND (NOT IN_GT.tGV2_Opened.Di AND IN_GT.tGV2_Opened.GoodQual) ) ;			(* Gas valve position detection opening failure (->error bit 1) *)
	tGV_struct[2].alm_0sf := (NOT OUT_GT.tGV2_Open.Do AND (NOT IN_GT.tGV2_Closed.Di AND IN_GT.tGV2_Closed.GoodQual) );			(* Gas valve position detection closing failure (->error bit 2) *)
	tGV_struct[2].alm_psf := ( (IN_GT.tGV2_Opened.Di AND IN_GT.tGV2_Opened.GoodQual) AND (IN_GT.tGV2_Closed.Di AND IN_GT.tGV2_Closed.GoodQual) );	(* Gas valve position detection failure (->error bit 3) *)
	tGV_struct[2].gv_status:=	BOOL_TO_DINT(tGV_struct[2].alm_1sf) *2 +			(* forward status for alarms and VIS: any value >1=failure message *)  
								BOOL_TO_DINT(tGV_struct[2].alm_0sf) *4 +
								BOOL_TO_DINT(tGV_struct[2].alm_psf) *8 ;

	
	(* gv_Struct : 	STRUCT for local 'function like' processing in an array loop, without need for external .fun file    (*VERSION V4.07*)
	//enable : BOOL; (*from Parameter*)
	//on : BOOL; (*real position status*)
	//off : BOOL; (*real position status*)
	//man_off : BOOL; (*optional manual command*)
	//man_on : BOOL; (*optional manual command*)
	//command_on : BOOL; (*command to valve*)
	//command_off : BOOL; (*command to valve*)
	//...


	(*--------------------------------------------------------------------------*)	
	(* Option: Upstream Customer Main Gas Valve control and position feedback	*) (*V4.09*)
	(*--------------------------------------------------------------------------*)	
	OUT_GT.tGV_Upstream_Release.Do := (IN_GT.bEng_Aux_Dem_CDR 				(* Demanded Engine OR COOL DOWN RUN OR	*)
									OR IN_GT.tFastStartReq.Di )				(* V4.10 change issue #51  *)
								//	OR IN_GT.bReady4FastStart 
								//	OR IN_GT.bReady4VeryFastStart) 			(* IF 562 OR IF563 Ready for fast start *)
								AND NOT IN_GT.bMsg1031			(* emergency stop *)
								AND NOT IN_GT.bMsg1052			(* gas prealarm  *)
								AND NOT IN_GT.bMsg1053			(* gas alarm *)
								AND NOT IN_GT.bMsg1054;			(* fire prealarm *)

	
	(* Para Option selective part for Upstream Customer Main Gas Valve *)
	IF Para.iGasTrain_Upstream_Type = 1 THEN		(* Para value '1' == Gas Valve Type with permanent release and feedback signals, e.g. Valpes/Bernard  (=option bit0) *)

		OUT_GT.tGV_Upstream_Open.Do := FALSE; //:= IN_GT.bEng_Aux_Dem_CDR   		(*  COOL DOWN RUN Verknüpfung 	Do open External Customer Gasvalve 	 *) (*OldName: NewPV *)	
									
		tGV_struct[0].command_on	:= 	   OUT_GT.tGV_Upstream_Release.Do;  		(* FEHLT NOCH: COOL DOWN RUN Verknüpfung 	Do open External Customer Gasvalve 	 *) (*OldName: NewPV *)
	//	tGV_struct[0].command_off	:= NOT OUT_GT.tGV_Upstream_Open.Do;	
	
		tGV_struct[0].on 	:=  IN_GT.tGV_Upstream_Opened.Di AND IN_GT.tGV_Upstream_Opened.GoodQual ;												(*	DI Gasvalve position status	 *) (*OldName: NewPV *)
		tGV_struct[0].off	:= (IN_GT.tGV_Upstream_Closed.Di AND IN_GT.tGV_Upstream_Closed.GoodQual)
						OR (NOT IN_GT.tGV_Upstream_Opened.Di AND IN_GT.tGV_Upstream_Opened.GoodQual AND NOT IN_GT.tGV_Upstream_Closed.GoodQual) ;	(*	DI Gasvalve position status	 *) (*OldName: NewPV *)
	
		tGV_struct[0].alm_1sf := (	  tGV_struct[0].command_on AND (NOT tGV_struct[0].on  AND IN_GT.tGV_Upstream_Opened.GoodQual) ); 	(* valve position detection opening failure(2) *)
		tGV_struct[0].alm_0sf := (NOT tGV_struct[0].command_on AND (NOT tGV_struct[0].off AND IN_GT.tGV_Upstream_Closed.GoodQual) ); 	(* valve position detection closing failure(4) *)
		tGV_struct[0].alm_psf := (    tGV_struct[0].on  AND tGV_struct[0].off  );														(* valve position detection failure (8) *)
		
	ELSIF Para.iGasTrain_Upstream_Type = 2 THEN 	(* Para value '2' == Gas Valve Type with permanent release +open pulse commands, e.g.Kromschroeter (=option bit1) *)		
		xTON_MGV_Pos_Pulse(IN := OUT_GT.tGV_Upstream_Release.Do   		(*  Do Open External Customer Gasvalve continuous pulsing	 *)
									AND NOT IN_GT.tGV_Upstream_Opened.Di
									AND NOT xTON_MGV_Neg_Pulse.Q, PT := T#10s); 
		xTON_MGV_Neg_Pulse(IN := xTON_MGV_Pos_Pulse.Q, PT :=  t#2s );
		OUT_GT.tGV_Upstream_Open.Do := xTON_MGV_Pos_Pulse.Q
								AND NOT IN_GT.bMsg1031			(* emergency stop *)
								AND NOT IN_GT.bMsg1052			(* gas prealarm  *)
								AND NOT IN_GT.bMsg1053			(* gas alarm *)
								AND NOT IN_GT.bMsg1054;			(* fire prealarm *)
		
		tGV_struct[0].command_on	:= 	   OUT_GT.tGV_Upstream_Release.Do;  		(* forward output state to display and supervise External Customer Gasvalve state	 *) 
	//	tGV_struct[0].command_off	:= NOT OUT_GT.tGV_Upstream_Open.Do;	
			
		tGV_struct[0].on 	:=  IN_GT.tGV_Upstream_Opened.Di AND IN_GT.tGV_Upstream_Opened.GoodQual ;								(*	DI Gasvalve position status	 *) 
//		tGV_struct[0].off	:= (IN_GT.tGV_Upstream_Closed.Di AND IN_GT.tGV_Upstream_Closed.GoodQual)
//		OR (NOT IN_GT.tGV_Upstream_Opened.Di AND IN_GT.tGV_Upstream_Opened.GoodQual AND NOT IN_GT.tGV_Upstream_Closed.GoodQual)   ;	(*	DI Gasvalve position status	 *) 
	
		tGV_struct[0].alm_1sf := (	  tGV_struct[0].command_on AND (NOT tGV_struct[0].on  AND IN_GT.tGV_Upstream_Opened.GoodQual) ); 	(* valve position detection opening failure (2) *)
//		tGV_struct[0].alm_0sf := (NOT tGV_struct[0].command_on AND (NOT tGV_struct[0].off AND IN_GT.tGV_Upstream_Closed.GoodQual) ); 	(* valve position detection closing failure (4) *)
//		tGV_struct[0].alm_psf := (    tGV_struct[0].on  AND tGV_struct[0].off  );  														(* valve position detection failure (8) *)

	
								
	ELSIF Para.iGasTrain_Upstream_Type = 4 THEN		(* parameter value = '4' == Customized Gas Valve Type ? for further use -  CURRENTLY UNDEFINED  (=option bit2)*)
		(* ToDo: Enter code variants for additional gasvalve designs here in future ! *) 
	
	ELSE	(*V4.07.1 alternative path, if NO option bit selected (from Para.iGasTrain_Upstream_Type = '0') *)
		OUT_GT.tGV_Upstream_Release.Do	:= FALSE;		
		OUT_GT.tGV_Upstream_Open.Do 	:= FALSE;
		tGV_struct[0].command_on		:= FALSE;
		tGV_struct[0].on 				:= FALSE ;	
		tGV_struct[0].off				:= FALSE ;	 
		tGV_struct[0].alm_1sf 			:= FALSE ;	
		tGV_struct[0].alm_0sf			:= FALSE ;	
		tGV_struct[0].alm_psf			:= FALSE ;
		tGV_struct[0].gv_status			:= 0;
	END_IF
	
	(*status summary for VIS messages*)
	tGV_struct[0].gv_status:=	BOOL_TO_DINT(tGV_struct[0].command_on) + 		(* forward status for alarms and VIS: 0=closed, 1=open *)
								BOOL_TO_DINT(tGV_struct[0].alm_1sf) *2 +		(* forward status for alarms and VIS: any other value >1=failure message *) 
								BOOL_TO_DINT(tGV_struct[0].alm_0sf) *4 +
								BOOL_TO_DINT(tGV_struct[0].alm_psf) *8 ;
		
END_PROGRAM