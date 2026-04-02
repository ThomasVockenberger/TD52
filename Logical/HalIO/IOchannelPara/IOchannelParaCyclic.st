(*******************************************************************************
AGGR: swet IO parameter	(cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2025

- set scaling of IO accoring to parameter values

Customized modifications: -
------------------------
 
History:
-------
V4.12.0	10-03-2022	Weitzer, generated from IOChannel
V4.13.0	27.08.2023	Bacci	 removed QOS scaling parameters: OQS_Conduct, OQS_Dielect, OQS_Temp, OQS_Visco
		21.11.2023	Tinello	 added urea tank level parameters
		21.11.2023	Heim,M.	 add hardware signal scaling for ctr 9,10,11,12,14,15,16,17,21,22,23,24,25,26,27,30,31,34 outputs
		07.03.2024	Farre	 issue #890, #1089: define settings and scale analog input signals sent to GR and GC
V4.14.0 27.11.2024	Maran	 added scaling parameters for Thermal reactor 2 - inlet/outlet pressure
		22.01.2025	Zengerer issue #1706 define para and settings for analog temp input variants: T_HW_Re, T_HW_ReAfEC, T_HW_Su and T_EGaHE1, T_EGaHE2, T_EGaTC, T_PlateHE

Instructions for use:
--------------------
- none

Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC

	
	(* mapping of parameter to external config structure*) 
	(*Netzbezugsregler Basisupdate V4.4 01*)
	IF xP_Mns_AnaIn.HW_Type = 0 THEN
		xP_Mns_AnaIn.Scal_X1 	:= 	BOOL_TO_DINT(Para.bP_Mns_AnaIn_Set4mA) * W_4mA;			(*Parameter 	scaling 4-20 mA aktiv *)
		xP_Mns_AnaIn.Scal_X2 	:= 	W_20mA;
		xP_Mns_AnaIn.Scal_Y1 	:=	Para.rP_Mns_AnaIn_ScalMin;		(*Parameter 	scale minimum *)
		xP_Mns_AnaIn.Scal_Y2 	:=	Para.rP_Mns_AnaIn_ScalMax;		(*Parameter 	scale maximum *)
		
		IF Para.bP_Mns_AnaIn_Set4mA THEN
			xP_Mns_AnaIn.Qual_Min	:= W_3mA;
			xP_Mns_AnaIn.Qual_Max	:= 32767;
		ELSE
			xP_Mns_AnaIn.Qual_Min	:= 0;
			xP_Mns_AnaIn.Qual_Max	:= 32767;
		END_IF;
	ELSE	
		xP_Mns_AnaIn.Scal_X1 	:= 	BOOL_TO_DINT(Para.bP_Mns_AnaIn_Set4mA) * W_4mA_UR20;	(*Parameter 	scaling 4-20 mA aktiv *)
		xP_Mns_AnaIn.Scal_X2 	:= 	W_20mA_UR20;
		xP_Mns_AnaIn.Scal_Y1 	:=	Para.rP_Mns_AnaIn_ScalMin;		(*Parameter 	scale minimum *)
		xP_Mns_AnaIn.Scal_Y2 	:=	Para.rP_Mns_AnaIn_ScalMax;		(*Parameter 	scale maximum *)
		
		IF Para.bP_Mns_AnaIn_Set4mA THEN
			xP_Mns_AnaIn.Qual_Min	:= W_3mA_UR20;
			xP_Mns_AnaIn.Qual_Max	:= W_20_5mA_UR20;
		ELSE
			xP_Mns_AnaIn.Qual_Min	:= 0;
			xP_Mns_AnaIn.Qual_Max	:= W_20_5mA_UR20;
		END_IF;
	END_IF;	
	
	IF xCtr_Mns_Anain_Setp_W_ext.HW_Type = 0 THEN	
		xCtr_Mns_Anain_Setp_W_ext.Scal_X1 := 	BOOL_TO_DINT(Para.bCtr_Mns_Setp_Set4mA) * W_4mA ;	(*Parameter for tCtr_Mns_Anain_Setp_W_ext	scaling 4-20 mA aktiv *)
		xCtr_Mns_Anain_Setp_W_ext.Scal_X2 := 	W_20mA ;
		xCtr_Mns_Anain_Setp_W_ext.Scal_Y1 :=	Para.rCtr_Mns_Setp_ScalMin;		(*Parameter 	scale minimum *)
		xCtr_Mns_Anain_Setp_W_ext.Scal_Y2 :=	Para.rCtr_Mns_Setp_ScalMax;		(*Parameter 	scale maximum *)
	
		IF Para.bCtr_Mns_Setp_Set4mA THEN
			xCtr_Mns_Anain_Setp_W_ext.Qual_Min	:= W_3mA;
			xCtr_Mns_Anain_Setp_W_ext.Qual_Max	:= 32767;
		ELSE
			xCtr_Mns_Anain_Setp_W_ext.Qual_Min	:= 0;
			xCtr_Mns_Anain_Setp_W_ext.Qual_Max	:= 32767;
		END_IF;
	ELSE
		xCtr_Mns_Anain_Setp_W_ext.Scal_X1 := 	BOOL_TO_DINT(Para.bCtr_Mns_Setp_Set4mA) * W_4mA_UR20 ;	(*Parameter for tCtr_Mns_Anain_Setp_W_ext	scaling 4-20 mA aktiv *)
		xCtr_Mns_Anain_Setp_W_ext.Scal_X2 := 	W_20mA_UR20;
		xCtr_Mns_Anain_Setp_W_ext.Scal_Y1 :=	Para.rCtr_Mns_Setp_ScalMin;		(*Parameter 	scale minimum *)
		xCtr_Mns_Anain_Setp_W_ext.Scal_Y2 :=	Para.rCtr_Mns_Setp_ScalMax;		(*Parameter 	scale maximum *)

		IF Para.bCtr_Mns_Setp_Set4mA THEN
			xCtr_Mns_Anain_Setp_W_ext.Qual_Min	:= W_3mA_UR20;
			xCtr_Mns_Anain_Setp_W_ext.Qual_Max	:= W_20_5mA_UR20;
		ELSE
			xCtr_Mns_Anain_Setp_W_ext.Qual_Min	:= 0;
			xCtr_Mns_Anain_Setp_W_ext.Qual_Max	:= W_20_5mA_UR20;
		END_IF;
	END_IF;
	
	(**  Power factor setpoint (COS PHI) from EU **)
	IF xPF_GenC_SetEU.HW_Type = 0 THEN	
		xPF_GenC_SetEU.Scal_X1	:= REAL_TO_DINT(Para.rPF_GrC_SetEUI1 * W_20mA / 20.0);
		xPF_GenC_SetEU.Scal_X2	:= REAL_TO_DINT(Para.rPF_GrC_SetEUI2 * W_20mA / 20.0);
		xPF_GenC_SetEU.Qual_Min	:= W_3mA;
		xPF_GenC_SetEU.Qual_Max	:= 32767;
	ELSE
		xPF_GenC_SetEU.Scal_X1	:= REAL_TO_DINT(Para.rPF_GrC_SetEUI1 * W_20mA_UR20 / 20.0);
		xPF_GenC_SetEU.Scal_X2	:= REAL_TO_DINT(Para.rPF_GrC_SetEUI2 * W_20mA_UR20 / 20.0);
		xPF_GenC_SetEU.Qual_Min	:= W_3mA_UR20;
		xPF_GenC_SetEU.Qual_Max	:= W_20_5mA_UR20;
	END_IF;
	
	IF Para.rPF_GrC_SetEUP1	< 0 THEN	
		xPF_GenC_SetEU.Scal_Y1	:= Para.rPF_GrC_SetEUP1 + 2;
	ELSE
		xPF_GenC_SetEU.Scal_Y1	:= Para.rPF_GrC_SetEUP1;
	END_IF;
	IF Para.rPF_GrC_SetEUP2 < 0 THEN
		xPF_GenC_SetEU.Scal_Y2	:= Para.rPF_GrC_SetEUP2 + 2;	
	ELSE
		xPF_GenC_SetEU.Scal_Y2	:= Para.rPF_GrC_SetEUP2;
	END_IF;
		
	(**  Reactive power setpoint from EU **)
	IF xQ_GenC_SetEU.HW_Type = 0 THEN	
		xQ_GenC_SetEU.Scal_X1	:= REAL_TO_DINT(Para.rQ_GrC_SetEUI1 * W_20mA / 20.0);
		xQ_GenC_SetEU.Scal_X2	:= REAL_TO_DINT(Para.rQ_GrC_SetEUI2 * W_20mA / 20.0);
		xQ_GenC_SetEU.Qual_Min	:= W_3mA;
		xQ_GenC_SetEU.Qual_Max	:= 32767;
	ELSE
		xQ_GenC_SetEU.Scal_X1	:= REAL_TO_DINT(Para.rQ_GrC_SetEUI1 * W_20mA_UR20 / 20.0);
		xQ_GenC_SetEU.Scal_X2	:= REAL_TO_DINT(Para.rQ_GrC_SetEUI2 * W_20mA_UR20 / 20.0);
		xQ_GenC_SetEU.Qual_Min	:= W_3mA_UR20;
		xQ_GenC_SetEU.Qual_Max	:= W_20_5mA_UR20;
	END_IF;
	xQ_GenC_SetEU.Scal_Y1 := Para.rQ_GrC_SetEUP1;
	xQ_GenC_SetEU.Scal_Y2 := Para.rQ_GrC_SetEUP2;	
		
	(**  Reactive power limit setpoint from EU **)
	IF xQLim_GenC_SetEU.HW_Type = 0 THEN	
		xQLim_GenC_SetEU.Scal_X1	:= REAL_TO_DINT(Para.rQ_GrC_SetEUI1_Lim * W_20mA / 20.0);
		xQLim_GenC_SetEU.Scal_X2	:= REAL_TO_DINT(Para.rQ_GrC_SetEUI2_Lim * W_20mA / 20.0);
		xQLim_GenC_SetEU.Qual_Min	:= W_3mA;
		xQLim_GenC_SetEU.Qual_Max	:= 32767;
	ELSE
		xQLim_GenC_SetEU.Scal_X1	:= REAL_TO_DINT(Para.rQ_GrC_SetEUI1_Lim * W_20mA_UR20 / 20.0);
		xQLim_GenC_SetEU.Scal_X2	:= REAL_TO_DINT(Para.rQ_GrC_SetEUI2_Lim * W_20mA_UR20 / 20.0);
		xQLim_GenC_SetEU.Qual_Min	:= W_3mA_UR20;
		xQLim_GenC_SetEU.Qual_Max	:= W_20_5mA_UR20;
	END_IF;
	xQLim_GenC_SetEU.Scal_Y1 := Para.rQ_GrC_SetEUP1_Lim;
	xQLim_GenC_SetEU.Scal_Y2 := Para.rQ_GrC_SetEUP2_Lim;
				
	(**  Voltage setpoint for reactive power control from EU **)
	IF xQU_GenC_Set.HW_Type = 0 THEN	
		xQU_GenC_Set.Scal_X1 	:= REAL_TO_DINT(Para.rU_GrC_SetEUI1 * W_20mA / 20.0);
		xQU_GenC_Set.Scal_X2 	:= REAL_TO_DINT(Para.rU_GrC_SetEUI2 * W_20mA / 20.0);
		xQU_GenC_Set.Qual_Min	:= W_3mA;
		xQU_GenC_Set.Qual_Max	:= 32767;
	ELSE
		xQU_GenC_Set.Scal_X1 	:= REAL_TO_DINT(Para.rU_GrC_SetEUI1 * W_20mA_UR20 / 20.0);
		xQU_GenC_Set.Scal_X2 	:= REAL_TO_DINT(Para.rU_GrC_SetEUI2 * W_20mA_UR20 / 20.0);
		xQU_GenC_Set.Qual_Min	:= W_3mA_UR20;
		xQU_GenC_Set.Qual_Max	:= W_20_5mA_UR20;
	END_IF;
	xQU_GenC_Set.Scal_Y1 := Para.rU_GrC_SetEUP1;
	xQU_GenC_Set.Scal_Y2 := Para.rU_GrC_SetEUP2;
			
	(**  Power setpoint from EU **)
	IF xP_GenC_SetEU.HW_Type = 0 THEN	
		xP_GenC_SetEU.Scal_X1 	:= REAL_TO_DINT(Para.rP_GrC_SetEUI1 * W_20mA / 20.0);
		xP_GenC_SetEU.Scal_X2	:= REAL_TO_DINT(Para.rP_GrC_SetEUI2 * W_20mA / 20.0);
		xP_GenC_SetEU.Qual_Min	:= W_3mA;
		xP_GenC_SetEU.Qual_Max	:= 32767;
	ELSE
		xP_GenC_SetEU.Scal_X1	:= REAL_TO_DINT(Para.rP_GrC_SetEUI1 * W_20mA_UR20 / 20.0);
		xP_GenC_SetEU.Scal_X2 	:= REAL_TO_DINT(Para.rP_GrC_SetEUI2 * W_20mA_UR20 / 20.0);
		xP_GenC_SetEU.Qual_Min	:= W_3mA_UR20;
		xP_GenC_SetEU.Qual_Max	:= W_20_5mA_UR20;
	END_IF;
	xP_GenC_SetEU.Scal_Y1 := Para.rP_GrC_SetEUP1;
	xP_GenC_SetEU.Scal_Y2 := Para.rP_GrC_SetEUP2;
			
	(**  Power limit setpoint from EU **)
	IF xPLim_GenC_SetEU.HW_Type = 0 THEN	
		xPLim_GenC_SetEU.Scal_X1 	:= REAL_TO_DINT(Para.rP_GrC_SetEUI1_Lim * W_20mA / 20.0);
		xPLim_GenC_SetEU.Scal_X2 	:= REAL_TO_DINT(Para.rP_GrC_SetEUI2_Lim * W_20mA / 20.0);
		xPLim_GenC_SetEU.Qual_Min	:= W_3mA;
		xPLim_GenC_SetEU.Qual_Max	:= 32767;
	ELSE
		xPLim_GenC_SetEU.Scal_X1 	:= REAL_TO_DINT(Para.rP_GrC_SetEUI1_Lim * W_20mA_UR20 / 20.0);
		xPLim_GenC_SetEU.Scal_X2 	:= REAL_TO_DINT(Para.rP_GrC_SetEUI2_Lim * W_20mA_UR20 / 20.0);
		xPLim_GenC_SetEU.Qual_Min	:= W_3mA_UR20;
		xPLim_GenC_SetEU.Qual_Max	:= W_20_5mA_UR20;
	END_IF;
	xPLim_GenC_SetEU.Scal_Y1 := Para.rP_GrC_SetEUP1_Lim;
	xPLim_GenC_SetEU.Scal_Y2 := Para.rP_GrC_SetEUP2_Lim;
	
	(**  Voltage setpoint **)
	IF xU_SetExtAI_Norm.HW_Type = 0 THEN	
		xU_SetExtAI_Norm.Scal_X1 	:= REAL_TO_DINT(Para.rU_SetExtAI_SetI1 * W_20mA / 20.0);
		xU_SetExtAI_Norm.Scal_X2 	:= REAL_TO_DINT(Para.rU_SetExtAI_SetI2 * W_20mA / 20.0);
		xU_SetExtAI_Norm.Qual_Min	:= W_3mA;
		xU_SetExtAI_Norm.Qual_Max	:= 32767;
	ELSE
		xU_SetExtAI_Norm.Scal_X1 	:= REAL_TO_DINT(Para.rU_SetExtAI_SetI1 * W_20mA_UR20 / 20.0);
		xU_SetExtAI_Norm.Scal_X2 	:= REAL_TO_DINT(Para.rU_SetExtAI_SetI2 * W_20mA_UR20 / 20.0);
		xU_SetExtAI_Norm.Qual_Min	:= W_3mA_UR20;
		xU_SetExtAI_Norm.Qual_Max	:= W_20_5mA_UR20;
	END_IF;
	xU_SetExtAI_Norm.Scal_Y1 := Para.rU_SetExtAI_SetP1;
	xU_SetExtAI_Norm.Scal_Y2 := Para.rU_SetExtAI_SetP2;
	xU_SetExtAI_Norm.Filter	 := 1000;
	
	(**  Reactive power droop offset setpoint **)
	IF xQ_Droop_Set.HW_Type = 0 THEN	
		xQ_Droop_Set.Scal_X1 	:= REAL_TO_DINT(Para.rQ_Droop_Set_SetI1 * W_20mA / 20.0);
		xQ_Droop_Set.Scal_X2 	:= REAL_TO_DINT(Para.rQ_Droop_Set_SetI2 * W_20mA / 20.0);
		xQ_Droop_Set.Qual_Min	:= W_3mA;
		xQ_Droop_Set.Qual_Max	:= 32767;
	ELSE
		xQ_Droop_Set.Scal_X1 	:= REAL_TO_DINT(Para.rQ_Droop_Set_SetI1 * W_20mA_UR20 / 20.0);
		xQ_Droop_Set.Scal_X2 	:= REAL_TO_DINT(Para.rQ_Droop_Set_SetI2 * W_20mA_UR20 / 20.0);
		xQ_Droop_Set.Qual_Min	:= W_3mA_UR20;
		xQ_Droop_Set.Qual_Max	:= W_20_5mA_UR20;
	END_IF;
	xQ_Droop_Set.Scal_Y1 := Para.rQ_Droop_Set_SetP1;
	xQ_Droop_Set.Scal_Y2 := Para.rQ_Droop_Set_SetP2;
	xQ_Droop_Set.Filter	 := 1000;
	
	xGT_CH4.Scal_Y1 := Para.rGT_CH4ScalMin;
	xGT_CH4.Scal_Y2 := Para.rGT_CH4ScalMax;
	
	xGT_H2.Scal_Y1 := Para.rGT_H2ScalMin;
	xGT_H2.Scal_Y2 := Para.rGT_H2ScalMax;
	
	xGT_O2.Scal_Y1 := Para.rGT_O2ScalMin;
	xGT_O2.Scal_Y2 := Para.rGT_O2ScalMax;
	
	xVol_GT.Scal_Y1 := Para.rVol_GT_ScalMin;
	xVol_GT.Scal_Y2 := Para.rVol_GT_ScalMax;
	
	xT_GT.Scal_Y1 := Para.rT_GT_ScalMin;
	xT_GT.Scal_Y2 := Para.rT_GT_ScalMax;
	
	xPr_GT_Gas.Scal_Y1 := Para.rPr_GT_GasPrScalMin;
	xPr_GT_Gas.Scal_Y2 := Para.rPr_GT_GasPrScalMax;
	
	xGT_CV.Scal_Y1 := Para.rGT_CVScalMin;
	xGT_CV.Scal_Y2 := Para.rGT_CVScalMax;

	xPr_GT_Suct.Scal_Y1 := Para.rPr_GT_SuctPrScalMin;
	xPr_GT_Suct.Scal_Y2 := Para.rPr_GT_SuctPrScalMax;

	IF xP_Red_Norm.HW_Type = 0 THEN	
		xP_Red_Norm.Scal_X1 := REAL_TO_DINT(Para.rP_Red_NormScalMinI * W_20mA / 20);
		xP_Red_Norm.Scal_X2 := REAL_TO_DINT(Para.rP_Red_NormScalMaxI * W_20mA / 20);
	ELSE
		xP_Red_Norm.Scal_X1 := REAL_TO_DINT(Para.rP_Red_NormScalMinI * W_20mA_UR20 / 20);
		xP_Red_Norm.Scal_X2 := REAL_TO_DINT(Para.rP_Red_NormScalMaxI * W_20mA_UR20 / 20);
	END_IF;	
	xP_Red_Norm.Scal_Y1 := Para.rP_Red_NormScalMinP;
	xP_Red_Norm.Scal_Y2 := Para.rP_Red_NormScalMaxP;

	xPr_EngLubOil.Scal_Y1 := 0;
	xPr_EngLubOil.Scal_Y2 := Para.rPr_EngLubOilScalMax;
	
	xPr_ECW.Scal_Y1  := 0;
	xPr_ECW.Scal_Y2  := Para.rPr_ECWScalMax;
	
	xPr_Ch_P2s.Scal_Y1 := Para.rPr_Ch_P2sScalMin;
	xPr_Ch_P2s.Scal_Y2 := Para.rPr_Ch_P2sScalMax;

	xPr_Ch_P2.Scal_Y1 := Para.rPr_Ch_P2ScalMin;
	xPr_Ch_P2.Scal_Y2 := Para.rPr_Ch_P2ScalMax;
	
	xPr_Ch_P2_A.Scal_Y1 := Para.rPr_Ch_P2ScalMin;
	xPr_Ch_P2_A.Scal_Y2 := Para.rPr_Ch_P2ScalMax;
	
	xPr_Ch_P2_B.Scal_Y1 := Para.rPr_Ch_P2ScalMin;
	xPr_Ch_P2_B.Scal_Y2 := Para.rPr_Ch_P2ScalMax;
	
	xPr_Ch_P2s_A.Scal_Y1 := Para.rPr_Ch_P2sScalMin;
	xPr_Ch_P2s_A.Scal_Y2 := Para.rPr_Ch_P2sScalMax;
	
	xPr_Ch_P2s_B.Scal_Y1 := Para.rPr_Ch_P2sScalMin;
	xPr_Ch_P2s_B.Scal_Y2 := Para.rPr_Ch_P2sScalMax;	

	xPr_Ch_P2LP.Scal_Y1 	:= Para.rPr_Ch_P2LPScalMin;
	xPr_Ch_P2LP.Scal_Y2 	:= Para.rPr_Ch_P2LPScalMax;	

	xPr_Ch_P2LP_A.Scal_Y1 	:= Para.rPr_Ch_P2LPScalMin;
	xPr_Ch_P2LP_A.Scal_Y2 	:= Para.rPr_Ch_P2LPScalMax;	

	xPr_Ch_P2LP_B.Scal_Y1 	:= Para.rPr_Ch_P2LPScalMin;
	xPr_Ch_P2LP_B.Scal_Y2 	:= Para.rPr_Ch_P2LPScalMax;	

	xPr_Ch_P2HP.Scal_Y1 	:= Para.rPr_Ch_P2HPScalMin;
	xPr_Ch_P2HP.Scal_Y2 	:= Para.rPr_Ch_P2HPScalMax;	

	xPr_Ch_P2HP_A.Scal_Y1 	:= Para.rPr_Ch_P2HPScalMin;
	xPr_Ch_P2HP_A.Scal_Y2 	:= Para.rPr_Ch_P2HPScalMax;	

	xPr_Ch_P2HP_B.Scal_Y1 	:= Para.rPr_Ch_P2HPScalMin;
	xPr_Ch_P2HP_B.Scal_Y2 	:= Para.rPr_Ch_P2HPScalMax;	

	xPr_Ch_P2bFA.Scal_Y1 := Para.rPr_Ch_P2bFAScalMin;
	xPr_Ch_P2bFA.Scal_Y2 := Para.rPr_Ch_P2bFAScalMax;
	
	xPr_CC.Scal_Y1 := Para.rPr_CCScalMin;
	xPr_CC.Scal_Y2 := Para.rPr_CCScalMax;

	xPr_f_BbFilt.Scal_Y1   := Para.rPr_f_BbFiltScalMin;
	xPr_f_BbFilt.Scal_Y2   := Para.rPr_f_BbFiltScalMax;
	xPr_f_BbFilt_A.Scal_Y1 := Para.rPr_f_BbFiltScalMin;
	xPr_f_BbFilt_A.Scal_Y2 := Para.rPr_f_BbFiltScalMax;
	xPr_f_BbFilt_B.Scal_Y1 := Para.rPr_f_BbFiltScalMin;
	xPr_f_BbFilt_B.Scal_Y2 := Para.rPr_f_BbFiltScalMax;

	xPr_a_BbFilt.Scal_Y1   := Para.rPr_a_BbFiltScalMin;
	xPr_a_BbFilt.Scal_Y2   := Para.rPr_a_BbFiltScalMax;
	xPr_a_BbFilt_A.Scal_Y1 := Para.rPr_a_BbFiltScalMin;
	xPr_a_BbFilt_A.Scal_Y2 := Para.rPr_a_BbFiltScalMax;
	xPr_a_BbFilt_B.Scal_Y1 := Para.rPr_a_BbFiltScalMin;
	xPr_a_BbFilt_B.Scal_Y2 := Para.rPr_a_BbFiltScalMax;
	
	xPr_EOF_DiffMon.Scal_Y1 := Para.rPr_EOF_DiffMonScalMin;
	xPr_EOF_DiffMon.Scal_Y2 := Para.rPr_EOF_DiffMonScalMax;

	xT_HW_Re.Scal_Y1 := Para.rT_HW_ReScalMin;			(* NewPV V4.14 caution: Para.iT_HW_Re_SensorType handling is not yet implemented (according to Spec) *)
	xT_HW_Re.Scal_Y2 := Para.rT_HW_ReScalMax;			(* TEMP INPUT, NOT A mA INPUT IN STANDARD CONFIG- this scaling gets only valid at mA variant activation! *)	

	
	xT_HW_ReAfEC.Scal_Y1 := Para.rT_HW_ReAfECScalMin;	(* NewPV V4.14 caution: Para.iT_HW_Re_SensorType handling is not yet implemented (according to Spec) *)
	xT_HW_ReAfEC.Scal_Y2 := Para.rT_HW_ReAfECScalMax;	(* TEMP INPUT, NOT A mA INPUT IN STANDARD CONFIG- this scaling gets only valid at mA variant activation! *)	

	
	xT_HW_Su.Scal_Y1 := Para.rT_HW_SuScalMin;			(* NewPV V4.14 caution: Para.iT_HW_Re_SensorType handling is not yet implemented (according to Spec) *)
	xT_HW_Su.Scal_Y2 := Para.rT_HW_SuScalMax;			(* TEMP INPUT, NOT A mA INPUT IN STANDARD CONFIG- this scaling gets only valid at mA variant activation! *)	


	xCA_IgnP_Set.Scal_Y1 := Para.rCA_IgnP_SetScalMin;
	xCA_IgnP_Set.Scal_Y2 := Para.rCA_IgnP_SetScalMax;
	IF xCA_IgnP_Set.HW_Type = 0 THEN	
		xCA_IgnP_Set.Scal_X1 := REAL_TO_DINT(Para.rI_IgnP_SetScalMin * W_20mA / 20);
		xCA_IgnP_Set.Scal_X2 := REAL_TO_DINT(Para.rI_IgnP_SetScalMax * W_20mA / 20);
	ELSE	
		xCA_IgnP_Set.Scal_X1 := REAL_TO_DINT(Para.rI_IgnP_SetScalMin * W_20mA_UR20 / 20);
		xCA_IgnP_Set.Scal_X2 := REAL_TO_DINT(Para.rI_IgnP_SetScalMax * W_20mA_UR20 / 20);
	END_IF;
	
	xDPr_AirFilt.Scal_Y1 	:= Para.rDPr_AirFiltScalMin;
	xDPr_AirFilt.Scal_Y2 	:= Para.rDPr_AirFiltScalMax;	
	xDPr_AirFilt_A.Scal_Y1 	:= Para.rDPr_AirFiltScalMin;
	xDPr_AirFilt_A.Scal_Y2 	:= Para.rDPr_AirFiltScalMax;
	xDPr_AirFilt_B.Scal_Y1 	:= Para.rDPr_AirFiltScalMin;
	xDPr_AirFilt_B.Scal_Y2 	:= Para.rDPr_AirFiltScalMax;	
	
	xN_TCHP.Scal_Y1   := Para.rN_TCHPScalMin;
	xN_TCHP.Scal_Y2   := Para.rN_TCHPScalMax;
	xN_TCHP_A.Scal_Y1 := Para.rN_TCHPScalMin;
	xN_TCHP_A.Scal_Y2 := Para.rN_TCHPScalMax;
	xN_TCHP_B.Scal_Y1 := Para.rN_TCHPScalMin;
	xN_TCHP_B.Scal_Y2 := Para.rN_TCHPScalMax;
	
	xN_TCLP.Scal_Y1   := Para.rN_TCLPScalMin;
	xN_TCLP.Scal_Y2   := Para.rN_TCLPScalMax;
	xN_TCLP_A.Scal_Y1 := Para.rN_TCLPScalMin;
	xN_TCLP_A.Scal_Y2 := Para.rN_TCLPScalMax;
	xN_TCLP_B.Scal_Y1 := Para.rN_TCLPScalMin;
	xN_TCLP_B.Scal_Y2 := Para.rN_TCLPScalMax;
	
	xPr_Ch_P1LP_A.Scal_Y1 := Para.rPr_Ch_P1LPScalMin;
	xPr_Ch_P1LP_A.Scal_Y2 := Para.rPr_Ch_P1LPScalMax;
	xPr_Ch_P1LP_B.Scal_Y1 := Para.rPr_Ch_P1LPScalMin;
	xPr_Ch_P1LP_B.Scal_Y2 := Para.rPr_Ch_P1LPScalMax;

	xPr_Ch_P1HP.Scal_Y1   := Para.rPr_Ch_P1HPScalMin;
	xPr_Ch_P1HP.Scal_Y2   := Para.rPr_Ch_P1HPScalMax;
	xPr_Ch_P1HP_A.Scal_Y1 := Para.rPr_Ch_P1HPScalMin;
	xPr_Ch_P1HP_A.Scal_Y2 := Para.rPr_Ch_P1HPScalMax;
	xPr_Ch_P1HP_B.Scal_Y1 := Para.rPr_Ch_P1HPScalMin;
	xPr_Ch_P1HP_B.Scal_Y2 := Para.rPr_Ch_P1HPScalMax;
	
	xPr_PC.Scal_Y1 := Para.rPr_PCScalMin;
	xPr_PC.Scal_Y2 := Para.rPr_PCScalMax;
	
	xPr_PC_Diff.Scal_Y1 := Para.rPr_PCScalMin;
	xPr_PC_Diff.Scal_Y2 := Para.rPr_PCScalMax;
	
	xPr_PCGT.Scal_Y1 := Para.rPr_PCGTScalMin;
	xPr_PCGT.Scal_Y2 := Para.rPr_PCGTScalMax;
	
	xPr_Baro.Scal_Y1 := Para.rPr_BaroScalMin;
	xPr_Baro.Scal_Y2 := Para.rPr_BaroScalMax;
	
	xPr_GT1.Scal_Y1 := Para.rPr_GT1ScalMin;
	xPr_GT1.Scal_Y2 := Para.rPr_GT1ScalMax;

	xP_Act_AO.Scal_Y1 := Para.rP_Act_AOScalMin;
	xP_Act_AO.Scal_Y2 := Para.rP_Act_AOScalMax;
	
	IF xP_Red_AI_Norm.HW_Type = 0 THEN
		xP_Red_AI_Norm.Scal_X1 := REAL_TO_DINT(Para.rI_P_Red_AI_NormScalMin * W_20mA / 20);
		xP_Red_AI_Norm.Scal_X2 := REAL_TO_DINT(Para.rI_P_Red_AI_NormScalMax * W_20mA / 20);
	ELSE
		xP_Red_AI_Norm.Scal_X1 := REAL_TO_DINT(Para.rI_P_Red_AI_NormScalMin * W_20mA_UR20 / 20);
		xP_Red_AI_Norm.Scal_X2 := REAL_TO_DINT(Para.rI_P_Red_AI_NormScalMax * W_20mA_UR20 / 20);
	END_IF;	
	xP_Red_AI_Norm.Scal_Y1 := Para.rP_Red_AI_NormScalMin;
	xP_Red_AI_Norm.Scal_Y2 := Para.rP_Red_AI_NormScalMax;

	IF xP_Set_ExtAI_Norm.HW_Type = 0 THEN	
		xP_Set_ExtAI_Norm.Scal_X1 := REAL_TO_DINT(Para.rI_P_Set_ExtAI_NormScalMin * W_20mA / 20);
		xP_Set_ExtAI_Norm.Scal_X2 := REAL_TO_DINT(Para.rI_P_Set_ExtAI_NormScalMax * W_20mA / 20);
	ELSE
		xP_Set_ExtAI_Norm.Scal_X1 := REAL_TO_DINT(Para.rI_P_Set_ExtAI_NormScalMin * W_20mA_UR20 / 20);
		xP_Set_ExtAI_Norm.Scal_X2 := REAL_TO_DINT(Para.rI_P_Set_ExtAI_NormScalMax * W_20mA_UR20 / 20);
	END_IF;	
	xP_Set_ExtAI_Norm.Scal_Y1 := Para.rP_Set_ExtAI_NormScalMin;
	xP_Set_ExtAI_Norm.Scal_Y2 := Para.rP_Set_ExtAI_NormScalMax;

	IF xN_Set_ExtAI_Norm.HW_Type = 0 THEN
		xN_Set_ExtAI_Norm.Scal_X1 := REAL_TO_DINT(Para.rI_N_Set_ExtAI_NormScalMin * W_20mA / 20);
		xN_Set_ExtAI_Norm.Scal_X2 := REAL_TO_DINT(Para.rI_N_Set_ExtAI_NormScalMax * W_20mA / 20);
	ELSE
		xN_Set_ExtAI_Norm.Scal_X1 := REAL_TO_DINT(Para.rI_N_Set_ExtAI_NormScalMin * W_20mA_UR20 / 20);
		xN_Set_ExtAI_Norm.Scal_X2 := REAL_TO_DINT(Para.rI_N_Set_ExtAI_NormScalMax * W_20mA_UR20 / 20);
	END_IF;
	xN_Set_ExtAI_Norm.Scal_Y1 := Para.rN_Set_ExtAI_NormScalMin;
	xN_Set_ExtAI_Norm.Scal_Y2 := Para.rN_Set_ExtAI_NormScalMax;


	xPr_HW_Su_LT.Scal_Y1 := 0;
	xPr_HW_Su_LT.Scal_Y2 := Para.rPr_HW_Su_LT_ScalMax;
	
	xPr_HW_Su_HT.Scal_Y1 := 0;
	xPr_HW_Su_HT.Scal_Y2 := Para.rPr_HW_Su_HT_ScalMax;             

	xPr_MGT_a_Filt.Scal_Y1 := Para.rPr_GT1ScalMin;
	xPr_MGT_a_Filt.Scal_Y2 := Para.rPr_GT1ScalMax;
	
	xPr_PCGT_Out.Scal_Y1 := Para.rPr_PCGT_OutScalMin;
	xPr_PCGT_Out.Scal_Y2 := Para.rPr_PCGT_OutScalMax;
	
	xPr_GR_I.Scal_Y1 := Para.rPr_GR_IScalMin;
	xPr_GR_I.Scal_Y2 :=	Para.rPr_GR_IScalMax;
	
	xPr_GR_II.Scal_Y1 := Para.rPr_GR_IScalMin;
	xPr_GR_II.Scal_Y2 := Para.rPr_GR_IScalMax;
	
	xPr_MGT_sp.Scal_Y1 := Para.rPr_MGT_spScalMin;
	xPr_MGT_sp.Scal_Y2 := Para.rPr_MGT_spScalMax;
	
	xPr_PCGT_sp.Scal_Y1 := Para.rPr_PCGT_spScalMin;
	xPr_PCGT_sp.Scal_Y2 := Para.rPr_PCGT_spScalMax;
	
	xF_GenBear_DE1.Scal_Y1 := Para.rF_GenBear_ScalMin;
	xF_GenBear_DE1.Scal_Y2 := Para.rF_GenBear_ScalMax;
	
	xF_GenBear_DE2.Scal_Y1 := Para.rF_GenBear_ScalMin;
	xF_GenBear_DE2.Scal_Y2 := Para.rF_GenBear_ScalMax;
	
	xF_GenBear_NDE1.Scal_Y1 := Para.rF_GenBear_ScalMin;
	xF_GenBear_NDE1.Scal_Y2 := Para.rF_GenBear_ScalMax;
	
	xF_GenBear_NDE2.Scal_Y1 := Para.rF_GenBear_ScalMin;	
	xF_GenBear_NDE2.Scal_Y2 := Para.rF_GenBear_ScalMax;	
	
	xPr_ECWaEng.Scal_Y1 := 0;
	xPr_ECWaEng.Scal_Y2 := Para.rPr_ECWaEng_ScalMax;
	
	xPr_EOF_After.Scal_Y1 := Para.rPr_EOF_After_ScalMin;
	xPr_EOF_After.Scal_Y2 := Para.rPr_EOF_After_ScalMax;
	
	xPr_TC_EOF_Before.Scal_Y1 := Para.rPr_TCObF_ScalMin;
	xPr_TC_EOF_Before.Scal_Y2 := Para.rPr_TCObF_ScalMax;   

	xFlow_OilSkid_DE.Scal_Y1 	:= Para.rFlow_OilSkid_DEScalMin;
	xFlow_OilSkid_DE.Scal_Y2 	:= Para.rFlow_OilSkid_DEScalMax;
		
	xFlow_OilSkid_NDE.Scal_Y1	:= Para.rFlow_OilSkid_NDEScalMin;
	xFlow_OilSkid_NDE.Scal_Y2	:= Para.rFlow_OilSkid_NDEScalMax;
	
	xLev_OilSkid_Tank.Scal_Y1	:= Para.rLev_OilSkid_TankScalMin;
	xLev_OilSkid_Tank.Scal_Y2	:= Para.rLev_OilSkid_TankScalMax;
	
	xT_OilSkid_Tank.Scal_Y1		:= Para.rT_OilSkid_TankScalMin;
	xT_OilSkid_Tank.Scal_Y2		:= Para.rT_OilSkid_TankScalMax;
	
	xPr_OilSkid_HP_NDE.Scal_Y1		:= Para.rPr_OilSkid_HPScalMin;
	xPr_OilSkid_HP_NDE.Scal_Y2		:= Para.rPr_OilSkid_HPScalMax;

	xPr_OilSkid_HP_DE.Scal_Y1		:= Para.rPr_OilSkid_HPScalMin;
	xPr_OilSkid_HP_DE.Scal_Y2		:= Para.rPr_OilSkid_HPScalMax;
	
	xT_OilSkid_Supply.Scal_Y1	:= Para.rT_OilSkid_SupplyScalMin;
	xT_OilSkid_Supply.Scal_Y2	:= Para.rT_OilSkid_SupplyScalMax;
	
	xPr_AirStarter_Tank.Scal_Y1	:= Para.rPr_AirStarter_TankScalMin;
	xPr_AirStarter_Tank.Scal_Y2	:= Para.rPr_AirStarter_TankScalMax;

	xPr_AirStarter_Supply.Scal_Y1:= Para.rPr_AirStarter_SupplyScalMin;
	xPr_AirStarter_Supply.Scal_Y2:= Para.rPr_AirStarter_SupplyScalMax;

	xPr_AirST_Engage.Scal_Y1	:=	0;
	xPr_AirST_Engage.Scal_Y2	:=	Para.rPr_AirST_Engage_ScalMax;
	
	xPr_ECWaP1.Scal_Y1 := 0.0;
	xPr_ECWaP1.Scal_Y2 := Para.rPr_ECWaP1_ScalMax;

	xPr_ECWaP2.Scal_Y1 := 0.0;
	xPr_ECWaP2.Scal_Y2 := Para.rPr_ECWaP2_ScalMax;


	(*SCR*)
	xT_SCR_CatIn.Scal_Y1			:= Para.rT_SCR_CatScalMin;
	xT_SCR_CatIn.Scal_Y2			:= Para.rT_SCR_CatScalMax;
	
	xT_SCR_CatOut.Scal_Y1			:= Para.rT_SCR_CatScalMin;
	xT_SCR_CatOut.Scal_Y2			:= Para.rT_SCR_CatScalMax;
	
	xPr_SCR_CatIn.Scal_Y1			:= Para.rPr_SCR_CatScalMin;
	xPr_SCR_CatIn.Scal_Y2			:= Para.rPr_SCR_CatScalMax;
	
	xPr_SCR_CatOut.Scal_Y1			:= Para.rPr_SCR_CatScalMin;
	xPr_SCR_CatOut.Scal_Y2			:= Para.rPr_SCR_CatScalMax;
	
	xNO_SCR_EMLine1.Scal_Y1			:= Para.rNO_SCR_EMLine1ScalMin;
	xNO_SCR_EMLine1.Scal_Y2			:= Para.rNO_SCR_EMLine1ScalMax;
	
	xNO2_SCR_EMLine1.Scal_Y1		:= Para.rNO2_SCR_EMLine1ScalMin;
	xNO2_SCR_EMLine1.Scal_Y2		:= Para.rNO2_SCR_EMLine1ScalMax;
	
	xCO_SCR_EMLine1.Scal_Y1			:= Para.rCO_SCR_EMLine1ScalMin;
	xCO_SCR_EMLine1.Scal_Y2			:= Para.rCO_SCR_EMLine1ScalMax;
	
	xO2_SCR_EMLine1.Scal_Y1			:= Para.rO2_SCR_EMLine1ScalMin;
	xO2_SCR_EMLine1.Scal_Y2			:= Para.rO2_SCR_EMLine1ScalMax;

	xNO_SCR_EMLine2.Scal_Y1			:= Para.rNO_SCR_EMLine2ScalMin;
	xNO_SCR_EMLine2.Scal_Y2			:= Para.rNO_SCR_EMLine2ScalMax;

	xNO2_SCR_EMLine2.Scal_Y1		:= Para.rNO2_SCR_EMLine2ScalMin;
	xNO2_SCR_EMLine2.Scal_Y2		:= Para.rNO2_SCR_EMLine2ScalMax;

	xPr_SCR_UreaDosingIn.Scal_Y1	:= Para.rPr_SCR_UreaDosingInScalMin;
	xPr_SCR_UreaDosingIn.Scal_Y2	:= Para.rPr_SCR_UreaDosingInScalMax;

	xPr_SCR_UreaDosingOut.Scal_Y1	:= Para.rPr_SCR_UreaDosingOutScalMin;
	xPr_SCR_UreaDosingOut.Scal_Y2	:= Para.rPr_SCR_UreaDosingOutScalMax;
	
	xFlow_SCR_UreaDosingOut.Scal_Y1	:= Para.rFlow_SCR_UreaDosingOutScalMin;
	xFlow_SCR_UreaDosingOut.Scal_Y2	:= Para.rFlow_SCR_UreaDosingOutScalMax;
	
	xPr_SCR_ComprAirSupply.Scal_Y1	:= Para.rPr_SCR_ComprAirSupplyScalMin;
	xPr_SCR_ComprAirSupply.Scal_Y2	:= Para.rPr_SCR_ComprAirSupplyScalMax;

	xLev_SCR_UreaTank.Scal_Y1		:= Para.rLev_SCR_UreaTankScalMin;
	xLev_SCR_UreaTank.Scal_Y2		:= Para.rLev_SCR_UreaTankScalMax;
	(*SCR ENDE*)

	(*Thermal reactor - begin*)
	xPr_ThR2_Inlet.Scal_Y1			:= Para.rPr_ThR2_InletOutlet_ScalMin;
	xPr_ThR2_Inlet.Scal_Y2			:= Para.rPr_ThR2_InletOutlet_ScalMax;
	
	xPr_ThR2_Outlet.Scal_Y1			:= Para.rPr_ThR2_InletOutlet_ScalMin;
	xPr_ThR2_Outlet.Scal_Y2			:= Para.rPr_ThR2_InletOutlet_ScalMax;
	(*Thermal reactor - end*)
	
	xPos_InlLou1.Scal_Y1		:=  Para.rPos_InlLou1_ScalMin;
	xPos_InlLou1.Scal_Y2        :=  Para.rPos_InlLou1_ScalMax;
	
	xPos_InlLou2.Scal_Y1		:=  Para.rPos_InlLou2_ScalMin;
	xPos_InlLou2.Scal_Y2        :=  Para.rPos_InlLou2_ScalMax;
	
	xPos_OutlLou1.Scal_Y1		:=  Para.rPos_OutlLou1_ScalMin;
	xPos_OutlLou1.Scal_Y2       :=  Para.rPos_OutlLou1_ScalMax;
	
	xPos_OutlLou2.Scal_Y1		:=  Para.rPos_OutlLou2_ScalMin;
	xPos_OutlLou2.Scal_Y2       :=  Para.rPos_OutlLou2_ScalMax;
	
	xPos_CircLou1.Scal_Y1		:=  Para.rPos_CircLou1_ScalMin;
	xPos_CircLou1.Scal_Y2       :=  Para.rPos_CircLou1_ScalMax;
	
	xPos_CircLou2.Scal_Y1		:=  Para.rPos_CircLou2_ScalMin;
	xPos_CircLou2.Scal_Y2       :=  Para.rPos_CircLou2_ScalMax;
	
	xPrDiff_ER.Scal_Y1           :=  Para.rPrDiff_ER_ScalMin;
	xPrDiff_ER.Scal_Y2           :=  Para.rPrDiff_ER_ScalMax;
	
	xPos_HW_ReValve.Scal_Y1     :=  Para.rPos_HW_ReValve_ScalMin;
	xPos_HW_ReValve.Scal_Y2     :=  Para.rPos_HW_ReValve_ScalMax;
	
	xPos_HW_EC_ReValve.Scal_Y1  :=  Para.rPos_HW_EC_ReValve_ScalMin;
	xPos_HW_EC_ReValve.Scal_Y2  :=  Para.rPos_HW_EC_ReValve_ScalMax;
	
	xPos_ChC_Valve.Scal_Y1      :=  Para.rPos_ChC_Valve_ScalMin;
	xPos_ChC_Valve.Scal_Y2      :=  Para.rPos_ChC_Valve_ScalMax;
	
	xPos_ChC2_Valve.Scal_Y1		:=  Para.rPos_ChC2_Valve_ScalMin;
	xPos_ChC2_Valve.Scal_Y2		:=  Para.rPos_ChC2_Valve_ScalMax;

	xP_Heat.Scal_Y1             :=  Para.rP_Heat_ScalMin;
	xP_Heat.Scal_Y2             :=  Para.rP_Heat_ScalMax;

	xPr_EO_Mod_Out.Scal_Y1		:=  Para.rPr_EO_Mod_Out_ScalMin;
	xPr_EO_Mod_Out.Scal_Y2		:=  Para.rPr_EO_Mod_Out_ScalMax;

	xPr_HW_Re_LT.Scal_Y1		:=  Para.rPr_HW_Re_LT_ScalMin;
	xPr_HW_Re_LT.Scal_Y2		:=  Para.rPr_HW_Re_LT_ScalMax;

	xPr_HW_Re_HT.Scal_Y1		:=  Para.rPr_HW_Re_HT_ScalMin;
	xPr_HW_Re_HT.Scal_Y2		:=  Para.rPr_HW_Re_HT_ScalMax;

	xPr_HW_Re_PreH_ECW.Scal_Y1	:=  Para.rPr_HW_Re_PreH_ECW_ScalMin;
	xPr_HW_Re_PreH_ECW.Scal_Y2	:=  Para.rPr_HW_Re_PreH_ECW_ScalMax;

	xPr_HW_Re_PreH_EO.Scal_Y1	:=  Para.rPr_HW_Re_PreH_EO_ScalMin;
	xPr_HW_Re_PreH_EO.Scal_Y2	:=  Para.rPr_HW_Re_PreH_EO_ScalMax;

	xPr_OFUbFilt.Scal_Y1		:=  Para.rPr_OFUbFilt_ScalMin;
	xPr_OFUbFilt.Scal_Y2		:=  Para.rPr_OFUbFilt_ScalMax;

	xPr_OFUaFilt.Scal_Y1		:=  Para.rPr_OFUaFilt_ScalMin;
	xPr_OFUaFilt.Scal_Y2		:=  Para.rPr_OFUaFilt_ScalMax;

	xPr_OFUbCentrifuge.Scal_Y1	:=  Para.rPr_OFUbCentrifuge_ScalMin;
	xPr_OFUbCentrifuge.Scal_Y2	:=  Para.rPr_OFUbCentrifuge_ScalMax;

	xP_DEIE.Scal_Y1 			:=	Para.rP_DEIE_ScalMin;
	xP_DEIE.Scal_Y2 			:=	Para.rP_DEIE_ScalMax;

	xPr_TCO.Scal_Y1 			:=	Para.rPr_TCO_ScalMin;
	xPr_TCO.Scal_Y2 			:=	Para.rPr_TCO_ScalMax;
	
	xT_EGbCat.Scal_Y1			:= 	Para.rT_OXIcat_In_ScalMin;
	xT_EGbCat.Scal_Y2			:= 	Para.rT_OXIcat_In_ScalMax;
	
	xT_EGaCat.Scal_Y1			:= 	Para.rT_OXIcat_Out_ScalMin;
	xT_EGaCat.Scal_Y2			:= 	Para.rT_OXIcat_Out_ScalMax;
	
	xPr_OXIcat_In.Scal_Y1		:= 	Para.rPr_OXIcat_In_ScalMin;
	xPr_OXIcat_In.Scal_Y2		:= 	Para.rPr_OXIcat_In_ScalMax;
	
	xPr_OXIcat_Out.Scal_Y1		:= 	Para.rPr_OXIcat_Out_ScalMin;
	xPr_OXIcat_Out.Scal_Y2		:= 	Para.rPr_OXIcat_Out_ScalMax;
	
	xPr_EG_Deflag_Fast.Scal_Y1	:= 	Para.rPr_OXIcat_In_Fast_ScalMin;	(* parameters from OXIcat inlet pressure fast reused *)
	xPr_EG_Deflag_Fast.Scal_Y2	:= 	Para.rPr_OXIcat_In_Fast_ScalMax;	(* Pr_EG_Deflag_Fast fully replaces Pr_OXIcat_In_Fast *)

	xT_GT_NG.Scal_Y1			:=  Para.rT_GT_NG_ScalMin;
	xT_GT_NG.Scal_Y2			:=  Para.rT_GT_NG_ScalMax;

	xPr_GT_NG.Scal_Y1			:=  Para.rPr_GT_NG_ScalMin;
	xPr_GT_NG.Scal_Y2			:=  Para.rPr_GT_NG_ScalMax;

	xVol_GT_NG.Scal_Y1			:=  Para.rVol_GT_NG_ScalMin;
	xVol_GT_NG.Scal_Y2			:=  Para.rVol_GT_NG_ScalMax;


	(* V4.12 Spec 2022-112 Oil Tank Manageent BEGINN *)
		CASE Para.iFreshOilTank_SensorType OF				(*V4.12 Spec 2022-112 Type of Sensor coupling used (INT) *)
			1:     (* 0-20mA *)

				IF xL_FreshOilTank.HW_Type = 0 THEN
					xL_FreshOilTank.Scal_X1 := W_0mA;
					xL_FreshOilTank.Scal_X2 := W_20mA;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
	             
					xL_FreshOilTank.Qual_Min := -200;
					xL_FreshOilTank.Qual_Max := W_20mA;
				ELSE
					xL_FreshOilTank.Scal_X1 := W_0mA;
					xL_FreshOilTank.Scal_X2 := W_20mA_UR20;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
	             
					xL_FreshOilTank.Qual_Min := -200;
					xL_FreshOilTank.Qual_Max := W_20_5mA_UR20;				
				END_IF;

			2:     (* 4-20mA *)

				IF xL_FreshOilTank.HW_Type = 0 THEN
					xL_FreshOilTank.Scal_X1 := W_4mA;
					xL_FreshOilTank.Scal_X2 := W_20mA;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
	             
					xL_FreshOilTank.Qual_Min := W_3mA;
					xL_FreshOilTank.Qual_Max := W_20mA;
				ELSE
					xL_FreshOilTank.Scal_X1 := W_4mA_UR20;
					xL_FreshOilTank.Scal_X2 := W_20mA_UR20;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
	             
					xL_FreshOilTank.Qual_Min := W_3mA_UR20;
					xL_FreshOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;	

			3:     (* 0-10V *)

				IF xL_FreshOilTank.HW_Type = 0 THEN
					xL_FreshOilTank.Scal_X1 := W_0mA;
					xL_FreshOilTank.Scal_X2 := W_20mA;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
             
					xL_FreshOilTank.Qual_Min := -200;
					xL_FreshOilTank.Qual_Max := W_20mA;
				ELSE
					xL_FreshOilTank.Scal_X1 := W_0mA;
					xL_FreshOilTank.Scal_X2 := W_20mA_UR20;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
             
					xL_FreshOilTank.Qual_Min := -200;
					xL_FreshOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;						
					
			4:     (* 2-10V *)

				IF xL_FreshOilTank.HW_Type = 0 THEN						
					xL_FreshOilTank.Scal_X1 := W_4mA;
					xL_FreshOilTank.Scal_X2 := W_20mA;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
	             
					xL_FreshOilTank.Qual_Min := W_3mA;
					xL_FreshOilTank.Qual_Max := W_20mA;
				ELSE		
					xL_FreshOilTank.Scal_X1 := W_4mA_UR20;
					xL_FreshOilTank.Scal_X2 := W_20mA_UR20;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
            
					xL_FreshOilTank.Qual_Min := W_3mA_UR20;
					xL_FreshOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;								
							
		//	5:     (* PT100*)
                           
		//	6:     (* NiCrNi *)
                    
			7:     (* 0-5V *)
              
				IF xL_FreshOilTank.HW_Type = 0 THEN
					xL_FreshOilTank.Scal_X1 := 0;
					xL_FreshOilTank.Scal_X2 := W_20mA / 2;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
	                     
					xL_FreshOilTank.Qual_Min := -100;
					xL_FreshOilTank.Qual_Max := W_20mA / 2;
				ELSE
					xL_FreshOilTank.Scal_X1 := 0;
					xL_FreshOilTank.Scal_X2 := W_20mA_UR20 / 2;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
                  
					xL_FreshOilTank.Qual_Min := -100;
					xL_FreshOilTank.Qual_Max := W_20_5mA_UR20 / 2;
				END_IF;	
					
			8:     (* -10/10V *)
              
				IF xL_FreshOilTank.HW_Type = 0 THEN
					xL_FreshOilTank.Scal_X1 := 0 - W_20mA;
					xL_FreshOilTank.Scal_X2 := W_20mA;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
	                     
					xL_FreshOilTank.Qual_Min := 0 - W_20mA;
					xL_FreshOilTank.Qual_Max := W_20mA;
				ELSE
					xL_FreshOilTank.Scal_X1 := 0 - W_20mA_UR20;
					xL_FreshOilTank.Scal_X2 := W_20mA_UR20;
					xL_FreshOilTank.Scal_Y1 := Para.rFreshOilTank_ScalMin;
					xL_FreshOilTank.Scal_Y2 := Para.rFreshOilTank_ScalMax;
                
					xL_FreshOilTank.Qual_Min := 0 - W_20_5mA_UR20;
					xL_FreshOilTank.Qual_Max := W_20_5mA_UR20;											
				END_IF;	
                		
			ELSE   (* NO custom signal type usefull -> refuse parameter change *)
                Para.iFreshOilTank_SensorType := 1;          
                 
		END_CASE;
		
		

		CASE Para.iWasteOilTank_SensorType OF				(*V4.12 Spec 2022-112 Type of Sensor coupling used (INT) *)
			1:     (* 0-20mA *)

				IF xL_WasteOilTank.HW_Type = 0 THEN
					xL_WasteOilTank.Scal_X1 := W_0mA;
					xL_WasteOilTank.Scal_X2 := W_20mA;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
	             
					xL_WasteOilTank.Qual_Min := -200;
					xL_WasteOilTank.Qual_Max := W_20mA;
				ELSE
					xL_WasteOilTank.Scal_X1 := W_0mA;
					xL_WasteOilTank.Scal_X2 := W_20mA_UR20;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
	             
					xL_WasteOilTank.Qual_Min := -200;
					xL_WasteOilTank.Qual_Max := W_20_5mA_UR20;				
				END_IF;

			2:     (* 4-20mA *)

				IF xL_WasteOilTank.HW_Type = 0 THEN
					xL_WasteOilTank.Scal_X1 := W_4mA;
					xL_WasteOilTank.Scal_X2 := W_20mA;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
	             
					xL_WasteOilTank.Qual_Min := W_3mA;
					xL_WasteOilTank.Qual_Max := W_20mA;
				ELSE
					xL_WasteOilTank.Scal_X1 := W_4mA_UR20;
					xL_WasteOilTank.Scal_X2 := W_20mA_UR20;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
	             
					xL_WasteOilTank.Qual_Min := W_3mA_UR20;
					xL_WasteOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;	

			3:     (* 0-10V *)

				IF xL_WasteOilTank.HW_Type = 0 THEN
					xL_WasteOilTank.Scal_X1 := W_0mA;
					xL_WasteOilTank.Scal_X2 := W_20mA;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
             
					xL_WasteOilTank.Qual_Min := -200;
					xL_WasteOilTank.Qual_Max := W_20mA;
				ELSE
					xL_WasteOilTank.Scal_X1 := W_0mA;
					xL_WasteOilTank.Scal_X2 := W_20mA_UR20;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
             
					xL_WasteOilTank.Qual_Min := -200;
					xL_WasteOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;						
					
			4:     (* 2-10V *)

				IF xL_WasteOilTank.HW_Type = 0 THEN						
					xL_WasteOilTank.Scal_X1 := W_4mA;
					xL_WasteOilTank.Scal_X2 := W_20mA;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
	             
					xL_WasteOilTank.Qual_Min := W_3mA;
					xL_WasteOilTank.Qual_Max := W_20mA;
				ELSE		
					xL_WasteOilTank.Scal_X1 := W_4mA_UR20;
					xL_WasteOilTank.Scal_X2 := W_20mA_UR20;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
            
					xL_WasteOilTank.Qual_Min := W_3mA_UR20;
					xL_WasteOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;								
							
		//	5:     (* PT100*)
                           
		//	6:     (* NiCrNi *)
                    
			7:     (* 0-5V *)
              
				IF xL_WasteOilTank.HW_Type = 0 THEN
					xL_WasteOilTank.Scal_X1 := 0;
					xL_WasteOilTank.Scal_X2 := W_20mA / 2;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
	                     
					xL_WasteOilTank.Qual_Min := -100;
					xL_WasteOilTank.Qual_Max := W_20mA / 2;
				ELSE
					xL_WasteOilTank.Scal_X1 := 0;
					xL_WasteOilTank.Scal_X2 := W_20mA_UR20 / 2;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
                  
					xL_WasteOilTank.Qual_Min := -100;
					xL_WasteOilTank.Qual_Max := W_20_5mA_UR20 / 2;
				END_IF;	
					
			8:     (* -10/10V *)
              
				IF xL_WasteOilTank.HW_Type = 0 THEN
					xL_WasteOilTank.Scal_X1 := 0 - W_20mA;
					xL_WasteOilTank.Scal_X2 := W_20mA;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
	                     
					xL_WasteOilTank.Qual_Min := 0 - W_20mA;
					xL_WasteOilTank.Qual_Max := W_20mA;
				ELSE
					xL_WasteOilTank.Scal_X1 := 0 - W_20mA_UR20;
					xL_WasteOilTank.Scal_X2 := W_20mA_UR20;
					xL_WasteOilTank.Scal_Y1 := Para.rWasteOilTank_ScalMin;
					xL_WasteOilTank.Scal_Y2 := Para.rWasteOilTank_ScalMax;
                
					xL_WasteOilTank.Qual_Min := 0 - W_20_5mA_UR20;
					xL_WasteOilTank.Qual_Max := W_20_5mA_UR20;											
				END_IF;	
                
				
			ELSE   (* NO custom signal type usefull -> refuse parameter change *)
                Para.iWasteOilTank_SensorType := 1;          
		END_CASE;



		CASE Para.iDayOilTank_SensorType OF				(*V4.12 Spec 2022-112 Type of Sensor coupling used (INT) *)
			1:     (* 0-20mA *)

				IF xL_DayOilTank.HW_Type = 0 THEN
					xL_DayOilTank.Scal_X1 := W_0mA;
					xL_DayOilTank.Scal_X2 := W_20mA;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
	             
					xL_DayOilTank.Qual_Min := -200;
					xL_DayOilTank.Qual_Max := W_20mA;
				ELSE
					xL_DayOilTank.Scal_X1 := W_0mA;
					xL_DayOilTank.Scal_X2 := W_20mA_UR20;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
	             
					xL_DayOilTank.Qual_Min := -200;
					xL_DayOilTank.Qual_Max := W_20_5mA_UR20;				
				END_IF;

			2:     (* 4-20mA *)

				IF xL_DayOilTank.HW_Type = 0 THEN
					xL_DayOilTank.Scal_X1 := W_4mA;
					xL_DayOilTank.Scal_X2 := W_20mA;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
	             
					xL_DayOilTank.Qual_Min := W_3mA;
					xL_DayOilTank.Qual_Max := W_20mA;
				ELSE
					xL_DayOilTank.Scal_X1 := W_4mA_UR20;
					xL_DayOilTank.Scal_X2 := W_20mA_UR20;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
	             
					xL_DayOilTank.Qual_Min := W_3mA_UR20;
					xL_DayOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;	

			3:     (* 0-10V *)

				IF xL_DayOilTank.HW_Type = 0 THEN
					xL_DayOilTank.Scal_X1 := W_0mA;
					xL_DayOilTank.Scal_X2 := W_20mA;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
             
					xL_DayOilTank.Qual_Min := -200;
					xL_DayOilTank.Qual_Max := W_20mA;
				ELSE
					xL_DayOilTank.Scal_X1 := W_0mA;
					xL_DayOilTank.Scal_X2 := W_20mA_UR20;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
             
					xL_DayOilTank.Qual_Min := -200;
					xL_DayOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;						
					
			4:     (* 2-10V *)

				IF xL_DayOilTank.HW_Type = 0 THEN						
					xL_DayOilTank.Scal_X1 := W_4mA;
					xL_DayOilTank.Scal_X2 := W_20mA;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
	             
					xL_DayOilTank.Qual_Min := W_3mA;
					xL_DayOilTank.Qual_Max := W_20mA;
				ELSE		
					xL_DayOilTank.Scal_X1 := W_4mA_UR20;
					xL_DayOilTank.Scal_X2 := W_20mA_UR20;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
            
					xL_DayOilTank.Qual_Min := W_3mA_UR20;
					xL_DayOilTank.Qual_Max := W_20_5mA_UR20;
				END_IF;								
							
		//	5:     (* PT100*)
                           
		//	6:     (* NiCrNi *)
                    
			7:     (* 0-5V *)
              
				IF xL_DayOilTank.HW_Type = 0 THEN
					xL_DayOilTank.Scal_X1 := 0;
					xL_DayOilTank.Scal_X2 := W_20mA / 2;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
	                     
					xL_DayOilTank.Qual_Min := -100;
					xL_DayOilTank.Qual_Max := W_20mA / 2;
				ELSE
					xL_DayOilTank.Scal_X1 := 0;
					xL_DayOilTank.Scal_X2 := W_20mA_UR20 / 2;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
                  
					xL_DayOilTank.Qual_Min := -100;
					xL_DayOilTank.Qual_Max := W_20_5mA_UR20 / 2;
				END_IF;	
					
			8:     (* -10/10V *)
              
				IF xL_DayOilTank.HW_Type = 0 THEN
					xL_DayOilTank.Scal_X1 := 0 - W_20mA;
					xL_DayOilTank.Scal_X2 := W_20mA;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
	                     
					xL_DayOilTank.Qual_Min := 0 - W_20mA;
					xL_DayOilTank.Qual_Max := W_20mA;
				ELSE
					xL_DayOilTank.Scal_X1 := 0 - W_20mA_UR20;
					xL_DayOilTank.Scal_X2 := W_20mA_UR20;
					xL_DayOilTank.Scal_Y1 := Para.rDayOilTank_ScalMin;
					xL_DayOilTank.Scal_Y2 := Para.rDayOilTank_ScalMax;
                
					xL_DayOilTank.Qual_Min := 0 - W_20_5mA_UR20;
					xL_DayOilTank.Qual_Max := W_20_5mA_UR20;											
				END_IF;	
                
				
			ELSE   (* NO custom signal type usefull -> refuse parameter change *)
                Para.iDayOilTank_SensorType := 1;          
   
		END_CASE;


	(***************************************************************)
	(*V4.14 define para and settings for analog temp input variants*)
		CASE Para.iT_EGaHE1_SensorType OF				(*V4.14 Spec 2024-11 Type of Sensor coupling used (INT) old: Para.iT_EGaHE1_SignalType *)
			1:     (* 0-20mA *)
				xT_EGaHE1.Scal_Y1 	:= Para.rT_EGaHE1_ScalMin;
				xT_EGaHE1.Scal_Y2 	:= Para.rT_EGaHE1_ScalMax;
				IF xT_EGaHE1.HW_Type = 0 THEN
					xT_EGaHE1.Scal_X1 := W_0mA;
					xT_EGaHE1.Scal_X2 := W_20mA;

					xT_EGaHE1.Qual_Min := -200;
					xT_EGaHE1.Qual_Max := W_20mA;
				ELSE
					xT_EGaHE1.Scal_X1 := W_0mA;
					xT_EGaHE1.Scal_X2 := W_20mA_UR20;
	             
					xT_EGaHE1.Qual_Min := -200;
					xT_EGaHE1.Qual_Max := W_20_5mA_UR20;				
				END_IF;

			2:     (* 4-20mA *)
				xT_EGaHE1.Scal_Y1 	:= Para.rT_EGaHE1_ScalMin;
				xT_EGaHE1.Scal_Y2 	:= Para.rT_EGaHE1_ScalMax;				
				IF xT_EGaHE1.HW_Type = 0 THEN
					xT_EGaHE1.Scal_X1 := W_4mA;
					xT_EGaHE1.Scal_X2 := W_20mA;
	             
					xT_EGaHE1.Qual_Min := W_3mA;
					xT_EGaHE1.Qual_Max := W_20mA;
				ELSE
					xT_EGaHE1.Scal_X1 := W_4mA_UR20;
					xT_EGaHE1.Scal_X2 := W_20mA_UR20;
	             
					xT_EGaHE1.Qual_Min := W_3mA_UR20;
					xT_EGaHE1.Qual_Max := W_20_5mA_UR20;
				END_IF;	

		//	3:     (* 0-10V 	VARIANT NOT IMPLEMENTED!*)			
		//	4:     (* 2-10V		VARIANT NOT IMPLEMENTED!*)					
			5:     (* PT100*)
					xT_EGaHE1.Scal_X1 	:= -2730;
					xT_EGaHE1.Scal_X2 	:= 32760;
					xT_EGaHE1.Scal_Y1 	:= -273;
					xT_EGaHE1.Scal_Y2 	:= 3276;
					
					xT_EGaHE1.Qual_Min := -200;
					xT_EGaHE1.Qual_Max :=  1400;
			6:     (* NiCrNi *)
					xT_EGaHE1.Scal_X1 	:= -2730;
					xT_EGaHE1.Scal_X2 	:= 32760;
					xT_EGaHE1.Scal_Y1 	:= -273;
					xT_EGaHE1.Scal_Y2 	:= 3276;

					xT_EGaHE1.Qual_Min := -500;
					xT_EGaHE1.Qual_Max := 15000;
                    
		//	7:     (* 0-5V		VARIANT NOT IMPLEMENTED!*)   				
		//	8:     (* -10/10V	VARIANT NOT IMPLEMENTED!*)  
			
			ELSE   (* NO custom signal type usefull -> refuse parameter change *)
                Para.iT_EGaHE1_SensorType    := 6;  	(*Fallback for missing type value is NiCrNi, as used in previous versions <=4.13 *)               
		END_CASE;



		
		CASE Para.iT_EGaHE2_SensorType OF				(*V4.14 Spec 2024-11 Type of Sensor coupling used (INT) old: Para.iT_EGaHE1_SignalType *)
			1:     (* 0-20mA *)
				xT_EGaHE2.Scal_Y1 	:= Para.rT_EGaHE2_ScalMin;
				xT_EGaHE2.Scal_Y2 	:= Para.rT_EGaHE2_ScalMax;
				IF xT_EGaHE2.HW_Type = 0 THEN
					xT_EGaHE2.Scal_X1 := W_0mA;
					xT_EGaHE2.Scal_X2 := W_20mA;
	             
					xT_EGaHE2.Qual_Min := -200;
					xT_EGaHE2.Qual_Max := W_20mA;
				ELSE
					xT_EGaHE2.Scal_X1 := W_0mA;
					xT_EGaHE2.Scal_X2 := W_20mA_UR20;
				             
					xT_EGaHE2.Qual_Min := -200;
					xT_EGaHE2.Qual_Max := W_20_5mA_UR20;				
				END_IF;

			2:     (* 4-20mA *)
				xT_EGaHE2.Scal_Y1 	:= Para.rT_EGaHE2_ScalMin;
				xT_EGaHE2.Scal_Y2 	:= Para.rT_EGaHE2_ScalMax;
				IF xT_EGaHE2.HW_Type = 0 THEN
					xT_EGaHE2.Scal_X1 := W_4mA;
					xT_EGaHE2.Scal_X2 := W_20mA;
	             
					xT_EGaHE2.Qual_Min := W_3mA;
					xT_EGaHE2.Qual_Max := W_20mA;
				ELSE
					xT_EGaHE2.Scal_X1 := W_4mA_UR20;
					xT_EGaHE2.Scal_X2 := W_20mA_UR20;
	             
					xT_EGaHE2.Qual_Min := W_3mA_UR20;
					xT_EGaHE2.Qual_Max := W_20_5mA_UR20;
				END_IF;	

		//	3:     (* 0-10V 	VARIANT NOT IMPLEMENTED!*)			
		//	4:     (* 2-10V		VARIANT NOT IMPLEMENTED!*)
			5:     (* PT100*)
					xT_EGaHE2.Scal_X1 	:= -2730;
					xT_EGaHE2.Scal_X2 	:= 32760;
					xT_EGaHE2.Scal_Y1 	:= -273;
					xT_EGaHE2.Scal_Y2 	:= 3276;
					
					xT_EGaHE2.Qual_Min := -200;
					xT_EGaHE2.Qual_Max :=  1400;
			6:     (* NiCrNi *)
					xT_EGaHE2.Scal_X1 	:= -2730;
					xT_EGaHE2.Scal_X2 	:= 32760;
					xT_EGaHE2.Scal_Y1 	:= -273;
					xT_EGaHE2.Scal_Y2 	:= 3276;

					xT_EGaHE2.Qual_Min := -500;
					xT_EGaHE2.Qual_Max := 15000;                    
		//	7:     (* 0-5V		VARIANT NOT IMPLEMENTED!*)   				
		//	8:     (* -10/10V	VARIANT NOT IMPLEMENTED!*)
              
			ELSE   (* NO custom signal type usefull -> refuse parameter change *)
                Para.iT_EGaHE2_SensorType    := 6;    	(*Fallback for missing type value is NiCrNi, as used in previous versions <=4.13 *)                  
		END_CASE;



		CASE Para.iT_EGaTC_SensorType  OF				(*V4.14 Spec 2024-11 Type of Sensor coupling used (INT) old: Para.iT_EGaTC_SignalType *)
			1:     (* 0-20mA *)
				xT_EGaTC.Scal_Y1 	:= Para.rT_EGaTC_ScalMin;
				xT_EGaTC.Scal_Y2 	:= Para.rT_EGaTC_ScalMax;
				IF xT_EGaTC.HW_Type = 0 THEN
					xT_EGaTC.Scal_X1 := W_0mA;
					xT_EGaTC.Scal_X2 := W_20mA;
	             
					xT_EGaTC.Qual_Min := -200;
					xT_EGaTC.Qual_Max := W_20mA;
				ELSE
					xT_EGaTC.Scal_X1 := W_0mA;
					xT_EGaTC.Scal_X2 := W_20mA_UR20;
	             
					xT_EGaTC.Qual_Min := -200;
					xT_EGaTC.Qual_Max := W_20_5mA_UR20;				
				END_IF;

			2:     (* 4-20mA *)
				xT_EGaTC.Scal_Y1 	:= Para.rT_EGaTC_ScalMin;
				xT_EGaTC.Scal_Y2 	:= Para.rT_EGaTC_ScalMax;
				IF xT_EGaTC.HW_Type = 0 THEN
					xT_EGaTC.Scal_X1 := W_4mA;
					xT_EGaTC.Scal_X2 := W_20mA;
	             
					xT_EGaTC.Qual_Min := W_3mA;
					xT_EGaTC.Qual_Max := W_20mA;
				ELSE
					xT_EGaTC.Scal_X1 := W_4mA_UR20;
					xT_EGaTC.Scal_X2 := W_20mA_UR20;
	             
					xT_EGaTC.Qual_Min := W_3mA_UR20;
					xT_EGaTC.Qual_Max := W_20_5mA_UR20;
				END_IF;	

		//	3:     (* 0-10V 	VARIANT NOT IMPLEMENTED!*)			
		//	4:     (* 2-10V		VARIANT NOT IMPLEMENTED!*)
			5:     (* PT100*)
					xT_EGaTC.Scal_X1 	:= -2730;
					xT_EGaTC.Scal_X2 	:= 32760;
					xT_EGaTC.Scal_Y1 	:= -273;
					xT_EGaTC.Scal_Y2 	:= 3276;
					
					xT_EGaTC.Qual_Min := -200;
					xT_EGaTC.Qual_Max :=  1400;
			6:     (* NiCrNi *)
					xT_EGaTC.Scal_X1 	:= -2730;
					xT_EGaTC.Scal_X2 	:= 32760;
					xT_EGaTC.Scal_Y1 	:= -273;
					xT_EGaTC.Scal_Y2 	:= 3276;

					xT_EGaTC.Qual_Min := -500;
					xT_EGaTC.Qual_Max := 15000;
                    
		//	7:     (* 0-5V		VARIANT NOT IMPLEMENTED!*)   				
		//	8:     (* -10/10V	VARIANT NOT IMPLEMENTED!*)

			ELSE   (* NO custom signal type usefull -> refuse parameter change *)
                Para.iT_EGaTC_SensorType    := 6; 		(*Fallback for missing type value is NiCrNi, as used in previous versions <=4.13 *)                              
		END_CASE;




		CASE Para.iT_PlateHE_SensorType  OF				(*V4.14 Spec 2024-11 Type of Sensor coupling used (INT) old: Para.iT_PlateHE_SignalType *)
			1:     (* 0-20mA *)
				xT_PlateHE.Scal_Y1		:= Para.rT_PlateHE_ScalMin;
				xT_PlateHE.Scal_Y2 		:= Para.rT_PlateHE_ScalMax;
				IF xT_PlateHE.HW_Type = 0 THEN
					xT_PlateHE.Scal_X1 	:= W_0mA;
					xT_PlateHE.Scal_X2 	:= W_20mA;
	             
					xT_PlateHE.Qual_Min := -200;
					xT_PlateHE.Qual_Max := W_20mA;
				ELSE
					xT_PlateHE.Scal_X1 	:= W_0mA;
					xT_PlateHE.Scal_X2 	:= W_20mA_UR20;
		             
					xT_PlateHE.Qual_Min := -200;
					xT_PlateHE.Qual_Max := W_20_5mA_UR20;				
				END_IF;

			2:     (* 4-20mA *)
				xT_PlateHE.Scal_Y1 		:= Para.rT_PlateHE_ScalMin;
				xT_PlateHE.Scal_Y2 		:= Para.rT_PlateHE_ScalMax;
				IF xT_PlateHE.HW_Type = 0 THEN
					xT_PlateHE.Scal_X1	:= W_4mA;
					xT_PlateHE.Scal_X2	:= W_20mA;
	             
					xT_PlateHE.Qual_Min	:= W_3mA;
					xT_PlateHE.Qual_Max	:= W_20mA;
				ELSE
					xT_PlateHE.Scal_X1	:= W_4mA_UR20;
					xT_PlateHE.Scal_X2	:= W_20mA_UR20;
	             
					xT_PlateHE.Qual_Min := W_3mA_UR20;
					xT_PlateHE.Qual_Max := W_20_5mA_UR20;
				END_IF;	
		//	3:     (* 0-10V 	VARIANT NOT IMPLEMENTED!*)			
		//	4:     (* 2-10V		VARIANT NOT IMPLEMENTED!*)			
			5:     (* PT100*)
					xT_PlateHE.Scal_X1 	:= -2730;
					xT_PlateHE.Scal_X2 	:= 32760;
					xT_PlateHE.Scal_Y1 	:= -273;
					xT_PlateHE.Scal_Y2 	:= 3276;
					
					xT_PlateHE.Qual_Min := -200;
					xT_PlateHE.Qual_Max :=  1400;
			6:     (* NiCrNi *)
					xT_PlateHE.Scal_X1 	:= -2730;
					xT_PlateHE.Scal_X2 	:= 32760;
					xT_PlateHE.Scal_Y1 	:= -273;
					xT_PlateHE.Scal_Y2 	:= 3276;

					xT_PlateHE.Qual_Min := -500;
					xT_PlateHE.Qual_Max := 15000;          
		//	7:     (* 0-5V		VARIANT NOT IMPLEMENTED!*)   				
		//	8:     (* -10/10V	VARIANT NOT IMPLEMENTED!*)
			
			ELSE   (* NO custom signal type usefull -> refuse parameter change *)
                Para.iT_PlateHE_SensorType    := 6; 		(*Fallback for missing type value is NiCrNi, as used in previous versions <=4.13 *)                             
		END_CASE;
	(********************************************************************************)





	(* Customized analog values *)	

	(*     INFO MSS CustAnaIn         *)
	(* 1:  0-20mA      -200 ..  32760 *)
	(* 2:  4-20mA      4914 ..  32760 *)
	(* 3:  0-10V       -200 ..  32760 *)
	(* 4:  2-10V       4914 ..  32760 *)
	(* 5:  PT100      -20°C ..  500°C *)     
	(* 6:  NiCrNi    -200°C .. 1000°C *)
	(* 7:  0-5V        -100 ..  16380 *)
	(* 8:  -10-10V   -32760 ..  32760 *)
	(* 0:  custom       no monitoring *)
		
	(* INFO scaling								 *)
	(*   Current	X20 raw		UR20 raw *)
	(*   20.5 mA   		***		   28340 *)
	(*   20.0 mA	  32767		   27648 *)
	(*	  4.0 mA	   6552 		5530 *)
	(*    3.0 mA       4914 		4147 *)
	(*    2.0 mA	   3276 		2765 *)

	(* Customized analog input *)
	FOR ucCount := 1 TO 120 DO
	
		CASE Para.iCustAnaIn_Typ[ucCount] OF
		
			1:     (* 0-20mA *)
				xCustAnaIn[ucCount].Scal_Y1 	:= Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2 	:= Para.rCustAnaIn_ScalMax[ucCount];
				IF xCustAnaIn[ucCount].HW_Type = 0 THEN
					xCustAnaIn[ucCount].Scal_X1 := W_0mA;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA;
	             
					xCustAnaIn[ucCount].Qual_Min := -200;
					xCustAnaIn[ucCount].Qual_Max := W_20mA;
				ELSE
					xCustAnaIn[ucCount].Scal_X1 := W_0mA;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA_UR20;
	             
					xCustAnaIn[ucCount].Qual_Min := -200;
					xCustAnaIn[ucCount].Qual_Max := W_20_5mA_UR20;				
				END_IF;

			2:     (* 4-20mA *)
				xCustAnaIn[ucCount].Scal_Y1 	:= Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2 	:= Para.rCustAnaIn_ScalMax[ucCount];
				IF xCustAnaIn[ucCount].HW_Type = 0 THEN
					xCustAnaIn[ucCount].Scal_X1 := W_4mA;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA;
	             
					xCustAnaIn[ucCount].Qual_Min := W_3mA;
					xCustAnaIn[ucCount].Qual_Max := W_20mA;
				ELSE
					xCustAnaIn[ucCount].Scal_X1 := W_4mA_UR20;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA_UR20;
	             
					xCustAnaIn[ucCount].Qual_Min := W_3mA_UR20;
					xCustAnaIn[ucCount].Qual_Max := W_20_5mA_UR20;
				END_IF;	

			3:     (* 0-10V *)
				xCustAnaIn[ucCount].Scal_Y1 := Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2 := Para.rCustAnaIn_ScalMax[ucCount];
				IF xCustAnaIn[ucCount].HW_Type = 0 THEN
					xCustAnaIn[ucCount].Scal_X1 := W_0mA;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA;
             
					xCustAnaIn[ucCount].Qual_Min := -200;
					xCustAnaIn[ucCount].Qual_Max := W_20mA;
				ELSE
					xCustAnaIn[ucCount].Scal_X1 := W_0mA;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA_UR20;
             
					xCustAnaIn[ucCount].Qual_Min := -200;
					xCustAnaIn[ucCount].Qual_Max := W_20_5mA_UR20;
				END_IF;						
					
			4:     (* 2-10V *)
				xCustAnaIn[ucCount].Scal_Y1 	:= Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2		:= Para.rCustAnaIn_ScalMax[ucCount];
				IF xCustAnaIn[ucCount].HW_Type = 0 THEN						
					xCustAnaIn[ucCount].Scal_X1 := W_4mA;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA;
	             
					xCustAnaIn[ucCount].Qual_Min := W_3mA;
					xCustAnaIn[ucCount].Qual_Max := W_20mA;
				ELSE		
					xCustAnaIn[ucCount].Scal_X1 := W_4mA_UR20;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA_UR20;
            
					xCustAnaIn[ucCount].Qual_Min := W_3mA_UR20;
					xCustAnaIn[ucCount].Qual_Max := W_20_5mA_UR20;
				END_IF;								
							
			5:     (* PT100*)
				xCustAnaIn[ucCount].Scal_X1 := REAL_TO_INT(LIMIT(-32760,Para.rCustAnaIn_ScalMin[ucCount]*10,32760));
				xCustAnaIn[ucCount].Scal_X2 := REAL_TO_INT(LIMIT(-32760,Para.rCustAnaIn_ScalMax[ucCount]*10,32760));
				xCustAnaIn[ucCount].Scal_Y1 := Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2 := Para.rCustAnaIn_ScalMax[ucCount];
                          
				xCustAnaIn[ucCount].Qual_Min := -200;
				xCustAnaIn[ucCount].Qual_Max := 5000;
                    
			6:     (* NiCrNi *)
				xCustAnaIn[ucCount].Scal_X1 := REAL_TO_INT(LIMIT(-32760,Para.rCustAnaIn_ScalMin[ucCount]*10,32760));
				xCustAnaIn[ucCount].Scal_X2 := REAL_TO_INT(LIMIT(-32760,Para.rCustAnaIn_ScalMax[ucCount]*10,32760));
				xCustAnaIn[ucCount].Scal_Y1 := Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2 := Para.rCustAnaIn_ScalMax[ucCount];
                          
				xCustAnaIn[ucCount].Qual_Min := -2000;
				xCustAnaIn[ucCount].Qual_Max := 10000;
                           
			7:     (* 0-5V *)
				xCustAnaIn[ucCount].Scal_Y1 	:= Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2 	:= Para.rCustAnaIn_ScalMax[ucCount];
				IF xCustAnaIn[ucCount].HW_Type = 0 THEN
					xCustAnaIn[ucCount].Scal_X1 := 0;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA / 2;
	                     
					xCustAnaIn[ucCount].Qual_Min := -100;
					xCustAnaIn[ucCount].Qual_Max := W_20mA / 2;
				ELSE
					xCustAnaIn[ucCount].Scal_X1 := 0;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA_UR20 / 2;
                  
					xCustAnaIn[ucCount].Qual_Min := -100;
					xCustAnaIn[ucCount].Qual_Max := W_20_5mA_UR20 / 2;
				END_IF;	
					
			8:     (* -10/10V *)
 				xCustAnaIn[ucCount].Scal_Y1 	:= Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2 	:= Para.rCustAnaIn_ScalMax[ucCount];             
				IF xCustAnaIn[ucCount].HW_Type = 0 THEN
					xCustAnaIn[ucCount].Scal_X1 := 0 - W_20mA;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA;
	                     
					xCustAnaIn[ucCount].Qual_Min := 0 - W_20mA;
					xCustAnaIn[ucCount].Qual_Max := W_20mA;
				ELSE
					xCustAnaIn[ucCount].Scal_X1 := 0 - W_20mA_UR20;
					xCustAnaIn[ucCount].Scal_X2 := W_20mA_UR20;
                
					xCustAnaIn[ucCount].Qual_Min := 0 - W_20_5mA_UR20;
					xCustAnaIn[ucCount].Qual_Max := W_20_5mA_UR20;											
				END_IF;	
                
				
			ELSE   (* custom signal type *)
                           
				xCustAnaIn[ucCount].Scal_X1 := REAL_TO_INT(LIMIT(-32760,Para.rCustAnaIn_ScalMin[ucCount],32760));
				xCustAnaIn[ucCount].Scal_X2 := REAL_TO_INT(LIMIT(-32760,Para.rCustAnaIn_ScalMax[ucCount],32760));
				xCustAnaIn[ucCount].Scal_Y1 := Para.rCustAnaIn_ScalMin[ucCount];
				xCustAnaIn[ucCount].Scal_Y2 := Para.rCustAnaIn_ScalMax[ucCount];
       
				xCustAnaIn[ucCount].Qual_Min := 0;
				xCustAnaIn[ucCount].Qual_Max := 0;
                     
		END_CASE;
		
		
		(* limit input signal to scaling Y1 / Y2 *)
		IF Para.rCustAnaIn_ScalMin[ucCount] <= Para.rCustAnaIn_ScalMax[ucCount] THEN
			tCustAnaIn[ucCount].Ai		:= LIMIT(Para.rCustAnaIn_ScalMin[ucCount], tCustAnaIn[ucCount].Ai, Para.rCustAnaIn_ScalMax[ucCount]);
			tCustAnaIn[ucCount].Unfilt	:= LIMIT(Para.rCustAnaIn_ScalMin[ucCount], tCustAnaIn[ucCount].Unfilt, Para.rCustAnaIn_ScalMax[ucCount]);
		ELSE
			tCustAnaIn[ucCount].Ai		:= LIMIT(Para.rCustAnaIn_ScalMax[ucCount], tCustAnaIn[ucCount].Ai, Para.rCustAnaIn_ScalMin[ucCount]);
			tCustAnaIn[ucCount].Unfilt	:= LIMIT(Para.rCustAnaIn_ScalMax[ucCount], tCustAnaIn[ucCount].Unfilt, Para.rCustAnaIn_ScalMin[ucCount]);
		END_IF;
		
	END_FOR;	

	
	(* Customized analog output *)			
	FOR ucCount := 1 TO 60 DO							(*V4.11 Array declarations extended for import HMI Extension *)
		//		IF Para.bCustAnaOut_Set4mA[ucCount] THEN  (*OLD: 4mA BIT?, NO simply set Para.rCustAnaOut_ScalMin[] to 4.0 for the 4mA value *)
		IF xCustAnaOut[ucCount].HW_Type = 0 THEN
			xCustAnaOut[ucCount].Scal_X1 := REAL_TO_DINT(Para.rI_CustAnaOut_ScalMin[ucCount] * W_20mA / 20);			(* 'hardware side' of scaling *)
			xCustAnaOut[ucCount].Scal_X2 := REAL_TO_DINT(Para.rI_CustAnaOut_ScalMax[ucCount] * W_20mA / 20);			(* 'hardware side' of scaling *)
		ELSE
			xCustAnaOut[ucCount].Scal_X1 := REAL_TO_DINT(Para.rI_CustAnaOut_ScalMin[ucCount] * W_20mA_UR20 / 20);			(* 'hardware side' of scaling *)
			xCustAnaOut[ucCount].Scal_X2 := REAL_TO_DINT(Para.rI_CustAnaOut_ScalMax[ucCount] * W_20mA_UR20 / 20);			(* 'hardware side' of scaling *)
		END_IF;
			
		xCustAnaOut[ucCount].Scal_Y1 := Para.rCustAnaOut_ScalMin[ucCount];		(* 'software side' of scaling *)
		xCustAnaOut[ucCount].Scal_Y2 := Para.rCustAnaOut_ScalMax[ucCount];		(* 'software side' of scaling *)
	END_FOR;			
			
			
	(* Customized plant controller output *)			
	FOR ucCount := 1 TO 45 DO		(*changed: 8*)
		(*REMOVED: 4mA BIT Para.bCtr_CustOut_Set4mA, simply set Para.rCtr_CustOut_ScalMin[] to 4.0 for the 4mA value *)
		IF xCtr_CustOut[ucCount].HW_Type = 0 THEN
			xCtr_CustOut[ucCount].Scal_X1 := REAL_TO_DINT(Para.rI_Ctr_CustOut_ScalMin[ucCount] * W_20mA / 20.0);		(* 'hardware side' of scaling *) (* noch Ändern auf ...Para.rCtr_CustOut_ScalMinI... *)
			xCtr_CustOut[ucCount].Scal_X2 := REAL_TO_DINT(Para.rI_Ctr_CustOut_ScalMax[ucCount] * W_20mA / 20.0);		(* 'hardware side' of scaling *)	
		ELSE
			xCtr_CustOut[ucCount].Scal_X1 := REAL_TO_DINT(Para.rI_Ctr_CustOut_ScalMin[ucCount] * W_20mA_UR20 / 20.0);		(* 'hardware side' of scaling *) (* noch Ändern auf ...Para.rCtr_CustOut_ScalMinI... *)
			xCtr_CustOut[ucCount].Scal_X2 := REAL_TO_DINT(Para.rI_Ctr_CustOut_ScalMax[ucCount] * W_20mA_UR20 / 20.0);		(* 'hardware side' of scaling *)	
		END_IF;
		
		xCtr_CustOut[ucCount].Scal_Y1 := 0.0;		(* 'software side' of scaling  (Para.rCtr_CustOut_ScalMin[] obsolete) *)
		xCtr_CustOut[ucCount].Scal_Y2 := 1.0;		(* 'software side' of scaling  (Para.rCtr_CustOut_ScalMax[] obsolete) *)
	END_FOR;


	(* Controller 9 - Charge temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_ChC_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_ChC_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_ChC_Set_ScalMin * iHW_Factor);
	xCtr_ChC_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_ChC_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_ChC_Set.Scal_Y1 := 0.0;
	xCtr_ChC_Set.Scal_Y2 := 1.0;


	(* Controller 10 - Return water temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_HWRe_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_HWRe_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_HWRe_Set_ScalMin * iHW_Factor);
	xCtr_HWRe_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_HWRe_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_HWRe_Set.Scal_Y1 := 0.0;
	xCtr_HWRe_Set.Scal_Y2 := 1.0;


	(* Controller 11 - Return water temperature after cooler *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_EC_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_EC_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_EC_Set_ScalMin * iHW_Factor);
	xCtr_EC_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_EC_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_EC_Set.Scal_Y1 := 0.0;
	xCtr_EC_Set.Scal_Y2 := 1.0;


	(* Controller 12 - Room temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xER_FC_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xER_FC_Set.Scal_X1 := REAL_TO_DINT(Para.rER_FC_Set_ScalMin * iHW_Factor);
	xER_FC_Set.Scal_X2 := REAL_TO_DINT(Para.rER_FC_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xER_FC_Set.Scal_Y1 := 0.0;
	xER_FC_Set.Scal_Y2 := 1.0;


	(* Controller 14 - Supply water temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_HWSu_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_HWSu_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_HWSu_Set_ScalMin * iHW_Factor);
	xCtr_HWSu_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_HWSu_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_HWSu_Set.Scal_Y1 := 0.0;
	xCtr_HWSu_Set.Scal_Y2 := 1.0;


	(* Controller 15 - Charge temperature ventilation - fan *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_ChCV_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_ChCV_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_ChCV_Set_ScalMin * iHW_Factor);
	xCtr_ChCV_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_ChCV_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_ChCV_Set.Scal_Y1 := 0.0;
	xCtr_ChCV_Set.Scal_Y2 := 1.0;


	(* Controller 16 - Engine cooling water temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_ECW_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_ECW_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_ECW_Set_ScalMin * iHW_Factor);
	xCtr_ECW_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_ECW_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_ECW_Set.Scal_Y1 := 0.0;
	xCtr_ECW_Set.Scal_Y2 := 1.0;


	(* Controller 17 - Charge cooler temperature - high pressure *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_ChCHP_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_ChCHP_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_ChCHP_Set_ScalMin * iHW_Factor);
	xCtr_ChCHP_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_ChCHP_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_ChCHP_Set.Scal_Y1 := 0.0;
	xCtr_ChCHP_Set.Scal_Y2 := 1.0;


	(* Controller 21 - Gas compressor *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_GC_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_GC_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_GC_Set_ScalMin * iHW_Factor);
	xCtr_GC_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_GC_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_GC_Set.Scal_Y1 := 0.0;
	xCtr_GC_Set.Scal_Y2 := 1.0;


	(* Controller 22 - Oil temperature controller low temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xEOVal_LT_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xEOVal_LT_Set.Scal_X1 := REAL_TO_DINT(Para.rEOVal_LT_Set_ScalMin * iHW_Factor);
	xEOVal_LT_Set.Scal_X2 := REAL_TO_DINT(Para.rEOVal_LT_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xEOVal_LT_Set.Scal_Y1 := 0.0;
	xEOVal_LT_Set.Scal_Y2 := 1.0;


	(* Controller 23 - Inlet louvre - Room temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_InlLou_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_InlLou_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_InlLou_Set_ScalMin * iHW_Factor);
	xCtr_InlLou_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_InlLou_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_InlLou_Set.Scal_Y1 := 0.0;
	xCtr_InlLou_Set.Scal_Y2 := 1.0;


	(* Controller 24 - Outlet louvre - Room temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_OutlLou_RT_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_OutlLou_RT_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_OutlLou_RT_Set_ScalMin * iHW_Factor);
	xCtr_OutlLou_RT_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_OutlLou_RT_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_OutlLou_RT_Set.Scal_Y1 := 0.0;
	xCtr_OutlLou_RT_Set.Scal_Y2 := 1.0;


	(* Controller 25 - Outlet louvre - Room difference pressure *)
		
	(* detecting hardware type in HalIO *)
	IF xCtr_OutlLou_RDP_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_OutlLou_RDP_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_OutlLou_RDP_Set_ScalMin * iHW_Factor);
	xCtr_OutlLou_RDP_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_OutlLou_RDP_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_OutlLou_RDP_Set.Scal_Y1 := 0.0;
	xCtr_OutlLou_RDP_Set.Scal_Y2 := 1.0;


	(* Controller 26 - Circulation louvre - Intake air temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_CircLou_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_CircLou_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_CircLou_Set_ScalMin * iHW_Factor);
	xCtr_CircLou_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_CircLou_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_CircLou_Set.Scal_Y1 := 0.0;
	xCtr_CircLou_Set.Scal_Y2 := 1.0;


	(* Controller 27 - Supply water temperature condenser *)	
	
	(* detecting hardware type in HalIO *)
	IF xCtr_CDSu_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_CDSu_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_CDSu_Set_ScalMin * iHW_Factor);
	xCtr_CDSu_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_CDSu_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_CDSu_Set.Scal_Y1 := 0.0;
	xCtr_CDSu_Set.Scal_Y2 := 1.0;


	(* Controller 30 - Outlet air fan - Room temperature *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_OutlVE_RT_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_OutlVE_RT_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_OutlVE_RT_Set_ScalMin * iHW_Factor);
	xCtr_OutlVE_RT_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_OutlVE_RT_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_OutlVE_RT_Set.Scal_Y1 := 0.0;
	xCtr_OutlVE_RT_Set.Scal_Y2 := 1.0;


	(* Controller 31 - Outlet air fan - Room difference pressure *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_OutlVE_RDP_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_OutlVE_RDP_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_OutlVE_RDP_Set_ScalMin * iHW_Factor);
	xCtr_OutlVE_RDP_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_OutlVE_RDP_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_OutlVE_RDP_Set.Scal_Y1 := 0.0;
	xCtr_OutlVE_RDP_Set.Scal_Y2 := 1.0;


	(* Controller 34 - Charge temperature before HP TC (T1) *)
	
	(* detecting hardware type in HalIO *)
	IF xCtr_ChC2_Valve_Set.HW_Type = 0 THEN iHW_Factor := W_20mA; ELSE iHW_Factor := W_20mA_UR20; END_IF
	(* hardware side of scaling in percentage on HMI *)
	xCtr_ChC2_Valve_Set.Scal_X1 := REAL_TO_DINT(Para.rCtr_ChC2_Valve_Set_ScalMin * iHW_Factor);
	xCtr_ChC2_Valve_Set.Scal_X2 := REAL_TO_DINT(Para.rCtr_ChC2_Valve_Set_ScalMax * iHW_Factor);
	(* software side of scaling *)
	xCtr_ChC2_Valve_Set.Scal_Y1 := 0.0;
	xCtr_ChC2_Valve_Set.Scal_Y2 := 1.0;


END_PROGRAM


