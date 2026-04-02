(*******************************************************************************
c_red 			customized power reductions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V3.90.0	03.07.2012 Zengerer		new, (function moved from task gasum )
V4.02.0 ??.??.2015  ??			cleanup, separated INI file
V4.03.0	10.11.2015 Zengerer		cleanup
V4.04.0	08.03.2017 Zengerer		replace IN_CU.tCustAnaIn[1].Ai by a neutral IN_CU.tCustAnaIn[0].Ai default, to avoid conflicts when task is not used
V4.11.0	16.08.2021 Weitzer 		Delete W_XXmA constant variables
																
Instructions for use:
--------------------
connect var for customized spare power redutions   

! ALL REDUCTIONS HAVE TO BE NORMED FROM 0 to 1 EQUALS 0 to P nominal


Outstandings:
------------
adopt this task according customer needs
replace [0] with actual used channel numbers IN_CU.tCustAnaIn[0].Ai;

*******************************************************************************)

PROGRAM _CYCLIC	

	(*-----------------------------------------------------------------------------------------*)
	(*                                        TASK INPUTS                                      *)
	(*-----------------------------------------------------------------------------------------*)
 	OUT_CU.bP_Red_Sp_Lim1Act :=	FALSE;						(* CONNNECT REDUCTION ACTIVATION BIT HERE *)						
	xSigScalR_Lim1Act.X := 		IN_CU.tCustAnaIn[0].Ai;		(* CONNNECT REDUCTION VALUE for customer spare power reduction, e.g. IN_CU.tCustAnaIn[1].Ai;	 *)
															(*hint: connect xSigScalR_Lim1Act.X1 and x2 also to available spare parameter*)

	OUT_CU.bP_Red_Sp_Lim2Act  	:= FALSE;					(* CONNNECT REDUCTION ACTIVATION BIT HERE *)
	xSigScalR_Lim2Act.X := 		IN_CU.tCustAnaIn[0].Ai;		(* CONNNECT REDUCTION VALUE for customer spare power reduction, e.g. IN_CU.tCustAnaIn[2].Ai; *)
															(*hint: connect xSigScalR_Lim2Act.X1 and x2 also to available spare parameter*)

	OUT_CU.bP_Red_Sp_Lim3Act  	:= FALSE;					(* CONNNECT REDUCTION ACTIVATION BIT HERE *)
	xSigScalR_Lim3Act.X := 		IN_CU.tCustAnaIn[0].Ai;		(* CONNNECT REDUCTION VALUE for customer spare power reduction, e.g. IN_CU.tCustAnaIn[3].Ai; *)
															(*hint: connect xSigScalR_Lim3Act.X1 and x2 also to available spare parameter*)



	(*-----------------------------------------------------------------------------------------*)
	(* Customer spare power reductions
	(*-----------------------------------------------------------------------------------------*)
	(* Reserve reduction #1 *)
	OUT_CU.bP_Red_Sp_Lim1Act; //:= FALSE;					
	xSigScalR_Lim1Act.X; //		:= IN_CU.tCustAnaIn[x].Ai;	
	xSigScalR_Lim1Act.X1 		:= Para.rCust_SparePara[0];		(* CONNNECT REDUCTION START VALUE, e.g. Para.rCust_SparePara[1]; *)
	xSigScalR_Lim1Act.Y1		:= 1.00;
	xSigScalR_Lim1Act.X2		:= Para.rCust_SparePara[0];		(* CONNNECT REDUCTION END VALUE, e.g. Para.rCust_SparePara[2];	 *)
	xSigScalR_Lim1Act.Y2		:= 0.50;
	xSigScalR_Lim1Act();	
	IF OUT_CU.bP_Red_Sp_Lim1Act THEN
		OUT_CU.rP_Red_Sp_Lim1_Norm	:= LIMIT(0,xSigScalR_Lim1Act.Y_SCAL,1.0);
	ELSE
		OUT_CU.rP_Red_Sp_Lim1_Norm	:= 1.0;
	END_IF;	

	(* Reserve reduction #2 *)
	OUT_CU.bP_Red_Sp_Lim2Act; //:= FALSE;									
	xSigScalR_Lim2Act.X; //		:= IN_CU.tCustAnaIn[x].Ai;	
	xSigScalR_Lim2Act.X1 		:= Para.rCust_SparePara[0];		(* CONNNECT REDUCTION START VALUE, e.g. Para.rCust_SparePara[1]; *)
	xSigScalR_Lim2Act.Y1		:= 1.00;
	xSigScalR_Lim2Act.X2		:= Para.rCust_SparePara[0];		(* CONNNECT REDUCTION END VALUE, e.g. Para.rCust_SparePara[2];	 *)	
	xSigScalR_Lim2Act.Y2		:= 0.50;
	xSigScalR_Lim2Act();	
	IF OUT_CU.bP_Red_Sp_Lim2Act THEN
		OUT_CU.rP_Red_Sp_Lim2_Norm	:= LIMIT(0,xSigScalR_Lim2Act.Y_SCAL,1.0);
	ELSE
		OUT_CU.rP_Red_Sp_Lim2_Norm	:= 1.0;
	END_IF;		
		
	(* Reserve reduction #3 *)
	OUT_CU.bP_Red_Sp_Lim3Act; //:= FALSE;					
	xSigScalR_Lim3Act.X	; //	:= IN_CU.tCustAnaIn[x].Ai;	
	xSigScalR_Lim3Act.X1 		:= Para.rCust_SparePara[0];		(* CONNNECT REDUCTION START VALUE, e.g. Para.rCust_SparePara[1]; *)
	xSigScalR_Lim3Act.Y1		:= 1.00;
	xSigScalR_Lim3Act.X2		:= Para.rCust_SparePara[0];		(* CONNNECT REDUCTION END VALUE, e.g. Para.rCust_SparePara[2];	 *)
	xSigScalR_Lim3Act.Y2		:= 0.50;
	xSigScalR_Lim3Act();	
	IF OUT_CU.bP_Red_Sp_Lim3Act THEN
		OUT_CU.rP_Red_Sp_Lim3_Norm	:= LIMIT(0,xSigScalR_Lim3Act.Y_SCAL,1.0);
	ELSE
		OUT_CU.rP_Red_Sp_Lim3_Norm	:= 1.0;
	END_IF;	
	

	(*----------------------------------------------------------------------------------*)
	(* external utility(evu) request power reduction = iIdx_Pred_Type	:= neu25(31) *)
	(*----------------------------------------------------------------------------------*)
	(* Functionality MOVED TO MM GRID Code! *)



	(*----------------------------------------------------------------------------------*)	
	(* limits for feedback signals to utility *)
	(*----------------------------------------------------------------------------------*)
	ton_RM_EVU[0](IN:= NOT IN_CU.tDI_Dem_P_Red_EVU_Stage1.Di AND NOT IN_CU.tDI_Dem_P_Red_EVU_Stage2.Di AND NOT IN_CU.tDI_Dem_P_Red_EVU_Stage3.Di AND IN_CU.bMCB_On , PT:= T#10s);	(* MCB_ON? -> to clarify...*)
	OUT_CU.tDO_P_Red_EVU_Stage0.Do := ton_RM_EVU[0].Q;		(* no power limit.and no lockout module *)
	
	lim_lo[1]( In:= IN_CU.rP_Act[1], Gw:= (Para.rP_Red_EVU_Stage1 + 0.01), Hy:= 0.01 );	(*OLD: lim_lo[1](In:= DINT_TO_INT((INT_TO_DINT(P_IST) * 1000)/ PN_GASART), Gw:= (ssPowRed_Utility_1 +10), Hy:= 10);*)
	ton_RM_EVU[1]( IN:= lim_lo[1].Q AND IN_CU.tDI_Dem_P_Red_EVU_Stage1.Di, PT:= T#30s );	(**)
	OUT_CU.tDO_P_Red_EVU_Stage1.Do := ton_RM_EVU[1].Q;		(* power limit.stage 1 (small reduction) *)
	
	lim_lo[2]( In:= IN_CU.rP_Act[1], Gw:= (Para.rP_Red_EVU_Stage2 + 0.01), Hy:= 0.01 );  (*OLD: lim_lo[2](In:= DINT_TO_INT((INT_TO_DINT(P_IST) * 1000)/ PN_GASART), Gw:= (ssPowRed_Utility_2 +10), Hy:= 10);*)
	ton_RM_EVU[2]( IN:= lim_lo[2].Q AND IN_CU.tDI_Dem_P_Red_EVU_Stage2.Di, PT:= T#30s );	(**)
	OUT_CU.tDO_P_Red_EVU_Stage2.Do := ton_RM_EVU[2].Q;		(* power limit.stage 2 (more reduction) *)
	
	lim_lo[3]( In:= IN_CU.rP_Act[1], Gw:= (Para.rP_Red_EVU_Stage3 + 0.01), Hy:= 0.01 );  (*OLD: lim_lo[3](In:= DINT_TO_INT((INT_TO_DINT(P_IST) * 1000)/ PN_GASART), Gw:= (ssPowRed_Utility_3 +10), Hy:= 10);*)
	ton_RM_EVU[3]( IN:= lim_lo[3].Q AND IN_CU.tDI_Dem_P_Red_EVU_Stage3.Di, PT:= T#30s );	(**)
	OUT_CU.tDO_P_Red_EVU_Stage3.Do := ton_RM_EVU[3].Q;		(* power limit.stage 3 (more reduction) *)

	lim_lo[4]( In:= IN_CU.rP_Act[1], Gw:= (Para.rP_Red_EVU_Stage4 + 0.01), Hy:= 0.01 );  (*OLD: lim_lo[4](In:= DINT_TO_INT((INT_TO_DINT(P_IST) * 1000)/ PN_GASART), Gw:= (ssPowRed_Utility_4 +10), Hy:= 10);*)
	ton_RM_EVU[4]( IN:= lim_lo[4].Q AND IN_CU.tDI_Dem_P_Red_EVU_Stage4.Di, PT:= T#30s );	(**)
	OUT_CU.tDO_P_Red_EVU_Stage4.Do := ton_RM_EVU[4].Q;		(* power limit.stage 4 (more reduction) *)
	
	lim_lo[5]( In:= IN_CU.rP_Act[1], Gw:= (Para.rP_Red_EVU_Stage5 + 0.01), Hy:= 0.01 );  (*OLD: lim_lo[?6?](In:= DINT_TO_INT((INT_TO_DINT(P_IST) * 1000)/ PN_GASART), Gw:= (ssPowRed_Utility_5 +10), Hy:= 10);*)
	ton_RM_EVU[5]( IN:= lim_lo[5].Q AND IN_CU.tDI_Dem_P_Red_EVU_Stage5.Di, PT:= T#30s );	(**)
	OUT_CU.tDO_P_Red_EVU_Stage5.Do := ton_RM_EVU[5].Q;		(*  (=most reduction)*)



	(*------------------------------------------------------------------------------------------*)
	(* generator: power factor controller dependent power reductions ??							*)
	(*------------------------------------------------------------------------------------------*)
	(* FUNCTION MOVED TO MODUL GENERATOR! *)

	
	(*-----------------------------------------------------------------------------------------*)
	(* power reduction for Extern – Analog (analog_dp):
	(*-----------------------------------------------------------------------------------------*)

	IF IN_CU.rP_Nom > 0 THEN 
		rP_Red_AI_Norm := IN_CU.tP_Red_AI_Norm.Ai / IN_CU.rP_Nom;		(* parameter are entered in KW, so convert setpoint to Norm here    *)
	ELSE
		rP_Red_AI_Norm := 1.0;
	END_IF
			(* scaling (DISABELED HERE! NO additional scaling, allready done in the HAL (with customized parameter) *)		
			Para.rI_P_Red_AI_NormScalMin;	Para.rI_P_Red_AI_NormScalMax;
			Para.rP_Red_AI_NormScalMin;		Para.rP_Red_AI_NormScalMax;

	(* power reduction on RSS Remote: (AFW_F)*)
	IF (IN_CU.iIdx_RSS = 2) AND IN_CU.tP_Red_AI_Norm.GoodQual THEN		(* locale representation of old AWS_F from IN_CU.iIdx_RSS = 2  *)
		OUT_CU.rP_Red_AI_Norm := LIMIT(0.5, rP_Red_AI_Norm, 1.0);		(*= analog power limit value *)		
		OUT_CU.bP_Red_AI_Enable := TRUE ;
	ELSE
		OUT_CU.rP_Red_AI_Norm := 1.0;
		OUT_CU.bP_Red_AI_Enable := FALSE ; 
	END_IF
	

	(*-----------------------------------------------------------------------------------------*)
	(*                                        TASK OUTPUTS                                     *)
	(*-----------------------------------------------------------------------------------------*)
	(* Prototype usage of all outputs: *)
	OUT_CU.bP_Red_Sp_Lim1Act ; 		(* power setpoint limit 1 activ *) (*OldName: bPowerSetpointLimit1; Cycle: 5;*)
	OUT_CU.bP_Red_Sp_Lim2Act ; 		(* power setpoint limit 2 activ *) (*OldName: bPowerSetpointLimit2; Cycle: 5;*)
	OUT_CU.bP_Red_Sp_Lim3Act ; 		(* power setpoint limit 3 activ *) (*OldName: bPowerSetpointLimit3; Cycle: 5;*)
	OUT_CU.rP_Red_Sp_Lim1_Norm ; 	(* power setpoint limit 1  related to rP_Nom *) (*OldName: ssPowerSetpointLimit1; Cycle: 5;*)
	OUT_CU.rP_Red_Sp_Lim2_Norm ; 	(* power setpoint limit 2  related to rP_Nom] *) (*OldName: ssPowerSetpointLimit2; Cycle: 5;*)
	OUT_CU.rP_Red_Sp_Lim3_Norm ; 	(* power setpoint limit 3  related to rP_Nom *) (*OldName: ssPowerSetpointLimit3; Cycle: 5;*)
	OUT_CU.bP_Red_EVU_Enable ; 		(* *) (*OldName: RED_EVU_Aktiv; Cycle: 5;*)
	OUT_CU.rP_Red_EVU_Norm ; 		(* power redutcion by utility *) (*OldName: RED_EVU; Cycle: 5;*)
	OUT_CU.rP_Red_AI_Norm ; 		(* power reduction by analog input *) (*OldName: ssPowerRedAnalog; Cycle: 5;*)

END_PROGRAM
