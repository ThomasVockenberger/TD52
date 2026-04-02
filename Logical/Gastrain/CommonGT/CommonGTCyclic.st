(*******************************************************************************
CommonGT	 			 common functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V3.99		21-09-2013	Ganguly/Denk, 	generated for modular software 
			23.04.2013	lettenb.		logic for 1085, 3315 moved to MsgGT
V04.00.01	11.03.2014	Denk			gas type 123 Display changed 1=1, 3=3,..!
V04.03.00 	03.02.2015  Denk			Porting J920 FOR XT4
V04.04.00	21.07.2016	Denk			Bugfix, Display on Visu
V04.11.00	21.10.2021	Zuschnig		Update prechamber gas train power reduction
V04.13.00	05.12.2023	Zuschnig		Update prechamber gas train power reduction in island mode
V04.14.00	11.12.2024	Zuschnig		Prechamber gas train power reduction in island mode - W9387 only if reduced power < 1

Instructions for use:
--------------------
			
Outstandings:
------------

(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Motortype *)
	xEngType.Motortype := INT_TO_UINT(Para.iEng_Motortype);
	xEngType();
	
	(* Engine operating mode *)
	xOpMode(in := IN_GT.iSt_OpMode);
	
	(* Operation mode selector switch in manual, auto or probe mode*)
	bOMSS_MAT := (IN_GT.iIdx_OMSS = 1) OR (IN_GT.iIdx_OMSS = 2) OR (IN_GT.iIdx_OMSS = 3);
	
	(* M_DREHZ signal generation *)
	xGR_MAXR_FA_AN_DREHZ.In := IN_GT.rN_EngAct;
	xGR_MAXR_FA_AN_DREHZ.Hy := Para.rN_EngStart_HyHi;
	xGR_MAXR_FA_AN_DREHZ.Gw := Para.rN_EngStart_LimHi;
	xGR_MAXR_FA_AN_DREHZ();
	xTOF_FA_M_DREHZ.IN := xGR_MAXR_FA_AN_DREHZ.Q AND IN_GT.tPB2MM.bParaSetupOk;
	xTOF_FA_M_DREHZ.PT := T#10s;
	xTOF_FA_M_DREHZ();
	M_DREHZ := xTOF_FA_M_DREHZ.Q;
	
	(* Release gas pressure monitoring - include relese gas monitoring form external set customized logic for FG_GDRUW_ext *)
	FG_GDRUW := IN_GT.tEng_Run.Do 
			OR (IN_GT.bEng_Aux_Dem AND NOT IN_GT.bEng_Start AND NOT OUT_GT.bGV_On AND bP_GT_RelMonExt);
			
	(* Selection of gassort in dependence of the gassort bit´s *)    
	TON_SecondTick(IN:=NOT TON_SecondTick.Q, PT:= T#800ms);							(* timer for 1 second tick  = 800ms + 2 task class cycles *)
		
	IF		(IN_GT.bGasTypMix1_2_Act AND NOT IN_GT.bGasTyp3_Act)	THEN	OUT_GT.iIdx_Gtyp_Dem := 0;			(* gassort 0 *) 
	ELSIF	IN_GT.bGasTyp2_Act = TRUE 								THEN	OUT_GT.iIdx_Gtyp_Dem := 2;			(* gassort 2 *)
	ELSIF 	IN_GT.bGasTyp3_Act = TRUE								THEN	OUT_GT.iIdx_Gtyp_Dem := 3;			(* gassort 3 *)
	ELSIF 	IN_GT.bGasTyp4_Act = TRUE								THEN	OUT_GT.iIdx_Gtyp_Dem := 4;			(* gassort 4 *)
	ELSE 	OUT_GT.iIdx_Gtyp_Dem := 1;																			(* otherwise gassort 1 *)
	END_IF;
	IF bCrossOver THEN													
		OUT_GT.iIdx_Gtyp_Dem := 0;				(* gassort 0 *)
	END_IF;

	(* Gastype selection for VISU display *)						 	
	(* create extended gas type selection *)
	CASE OUT_GT.iIdx_Gtyp_Dem OF
	1:	MM2VIS.iIdx_Gtyp_Act := 1;				(* gas type 1 *)		
	2:	MM2VIS.iIdx_Gtyp_Act := 2;				(* gas type 2 *)		
	3:	MM2VIS.iIdx_Gtyp_Act := 3;				(* gas type 3 *)	
	4:	MM2VIS.iIdx_Gtyp_Act := 4;				(* gas type 4 *)		
	ELSE
		IF OUT_GT.bGasMixingActive THEN
			IF OUT_GT.bGT_Ipol12Active THEN
				MM2VIS.iIdx_Gtyp_Act := 123;	(* gas type 1_2/3 *)	
			ELSE
				MM2VIS.iIdx_Gtyp_Act := 13;		(* gas type 1/3 *)		
			END_IF;
		ELSE
			IF IN_GT.bGasTyp3_Act = TRUE THEN
				MM2VIS.iIdx_Gtyp_Act := 3;		(* gas type 3 *)
			ELSE		
				MM2VIS.iIdx_Gtyp_Act := 12;		(* gas type 1_2 *)		
			END_IF;
		END_IF;
	END_CASE;

	(* power reduction according low pressure in pre chamber gas train *)
	OUT_GT.rPr_P2s_demand_PCGT	:=	IN_GT.tPr_PCGT.Ai + IN_GT.rPr_Baro_Internal - Para.rDPr_PCGT_Set - rPr_PCGT_PipeLoss;

	IF Para.bP_Red_Pr_PCG AND Para.bPr_PCGT_Active AND IN_GT.tPr_PCGT.GoodQual AND OUT_GT.tPCG_GV_Open.Do THEN
		OUT_GT.rP_Red_Pr_PCGT_Norm := LIMIT(0, (IN_GT.rP_el_max_red_PCGT / MAX(1, IN_GT.rP_Nom)), 1.0);
	ELSE
		OUT_GT.rP_Red_Pr_PCGT_Norm := 1.0;
	END_IF;

	IF xOpMode.NetP AND Para.bPr_PCGT_Active AND (OUT_GT.rP_Red_Pr_PCGT_Norm < IN_GT.rP_Set_Min_Norm) THEN
		bPowerMin_PCGT	:= TRUE;
	ELSIF xOpMode.Island AND Para.bPr_PCGT_Active AND (IN_GT.rPr_Ch_P2s_Avg > (IN_GT.tPr_PCGT.Ai + IN_GT.rPr_Baro_Internal - Para.rDPr_PCGT_Set)) AND NOT Para.bSA_PI_Active THEN
		bPowerMin_PCGT	:= TRUE;
	ELSE
		bPowerMin_PCGT	:= FALSE;
	END_IF;

	IF xOpMode.Island AND Para.bPr_PCGT_Active AND (OUT_GT.rP_Red_Pr_PCGT_Norm < IN_GT.rP_Act_Norm_Filt) AND NOT Para.bSA_PI_Active AND (OUT_GT.rP_Red_Pr_PCGT_Norm < 1.0) THEN
		bMsg9387_Set := TRUE;
	ELSE
		bMsg9387_Set := FALSE;
	END_IF;

	(* release main gas valve *)	
	FG_HGV := NOT IN_GT.bMsg1053 AND NOT IN_GT.bMsg1052 AND NOT IN_GT.bMsg1054 AND NOT IN_GT.bMsg1031	
			AND IN_GT.tRelMainGVext.Di;		  

	(* Check if velocity is zero *)
	IF IN_GT.rN_EngAct > -0.01 AND IN_GT.rN_EngAct < 0.01 THEN
		bN_EngAct_IsZero := TRUE; 
	ELSE 
		bN_EngAct_IsZero := FALSE; 		
	END_IF;

END_PROGRAM