(*******************************************************************************
VisOP	 			 VISU and bus coupling variables 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V0.1.0	13.09.2012	Graus		new
V0.1.1	23.04.2013	Graus		MM2VIS.rP_Set_Min in AUTO and TEST to Para-value, otherwise is 0
V4.00.0 11.02.2014 	Graus,		change Version TO 4.0
V4.00.1	19.02.2014 zengerer		iIdx_OMSS, iIdx_RSS changed to DINT because of OPC UA troubles
V4.00.2 05.03.2014 	Graus,		add progress indication OF engine operation FOR VIS (iSt_VIS_Porgress)
V4.00.3 14.03.2014 	Graus,		add bEng_Rdy_Aut to MM2VIS structure and assign it for visualization
V4.01.0 19.05.2014  Denk		IN_OP.rP_RedDI_EU_Norm changed
V4.02.0 02.07.2014  Graus,		add MM2VIS.bP_Red_Sp_Lim1Act, 2 and 3
V4.02.1	15.10.2014	Caks,		added glow ignition power reduction
V4.02.2	17.02.2015	Graus,		add visu interface for power reduction by hierarchy controller
V4.02.3	04.05.2015	Denk,		add visu interfaces for OPC
V4.04.0	08.07.2016	Zengerer	BETA: Step Time Display Information
		17.11.2016	Gomez Ortiz	Addition of B2168 generator air inlet temperature power reduction
		21.12.2016  Denk		Modification for WinMOD simulation
V4.05.0 14.06.2017	Gomez Ortiz Addition of power limitation due to low engine cooling water temperature, Spec_Start_Load_release_manual_start.doc
V4.05.0 19.10.2017  Gomez Ortiz Addition of bImp_UnitOpHour to the MM2VIS struct
		24.10.2017	Zingerle	SWAT 920 Rel.5, power reduction with difference pressure minimum
		21.01.2018	Perktold,	hardware operation mode switch added
V4.07.0	11.10.2018	lettenb.	Di: tF_N_DI_Inc/Dec added for diagnosis
V4.07.4	29.03.2019	Hohensinner	Bugfixing: added missing interface to VIS for PRed CppInt
		26.04.2019	Hohensinner	Set minimum time for speed pulses for HMI to 2sec
V4.10.0 10.12.2020  Zuschnig	Included power reduction for Tecjet differential pressure
		18.01.2021	Perktold	included spec. gas p.red in MM2VIS
		25.01.2021	Zuschnig	Change MM2VIS.P_UNRED from Norm to kW
V4.11.0	20.08.2021 	Keller		Add Messages bMsg9057 - bMsg9060
		22.11.2021	Perktold,	added myPlant Remote Status computation
		22.12.2021	Andre		added Power reduction by CAN communication failure for half or more SAFI or too many SAFI reboots
V4.12.0	12.01.2023	Tinello		Deleted power reduction by T1HP / Added power reduction by T2HP and T2LP
		22.01.2023  Zuschnig	Include power reduction H2 content
		24.03.2023	Perktold	Write on PRed-MM2VIS variables just when ParaSetupOk is true - mitigation for wrong values on HMI
V4.13.0	05.07.2023	Zuschnig	Removed Step Time Display Information
  		26.01.2024 	Zuschnig 	Split of power reduction FPR

Instructions for use:
--------------------
			
Outstandings:
------------

(*******************************************************************************)

PROGRAM _CYCLIC


	(* Output: MM2VIS *)
	(* myPlant Remote Status computation *)
	IF bParaSetupOk_2s AND NOT bGnlTrip AND NOT bRequest_Bloc AND NOT OUT_OP.bEng_Bloc AND bOMSS_AUTO AND bRSS_REM AND (IN_OP.iIdx_SyOMSS = 2) AND Para.bRemoteReqMyPlantActive THEN
		MM2VIS.iMyPlant_Remote_Ready		:= 2;
	ELSE
		(* Reset myPlant demand in following cases, trip, engine blocking active, engine not in AUTO + REMOTE mode or function not active*)
		IF VIS2MM.bRemoteReq_myPlant THEN
			VIS2MM.bRemoteReq_myPlant 		:= FALSE;
		END_IF;
		IF Para.bRemoteReqMyPlantActive THEN
			MM2VIS.iMyPlant_Remote_Ready	:= 1;
		ELSE
			MM2VIS.iMyPlant_Remote_Ready	:= 0;
		END_IF;
	END_IF;

	MM2VIS.M_ANF := 			M_ANF;
	MM2VIS.iSt_OpMode_Main := 	iSt_OpMode_Main;
	MM2VIS.rN_Set := 			OUT_OP.rN_Set_Norm * Para.rN_EngNom;
	MM2VIS.rP_Act_Filt := 		OUT_OP.rP_Act_Norm_Filt * OUT_OP.rP_Nom;
	MM2VIS.rP_Set := 			OUT_OP.rP_Set_Norm * OUT_OP.rP_Nom;
	MM2VIS.P_UNRED := 			OUT_OP.rP_Set_Unred_Norm * OUT_OP.rP_Nom;

	MM2VIS.bP_Red_Active := 	OUT_OP.bP_Red_Active OR xTP_bP_Red_Active.Q;
	xTP_bP_Red_Active(IN := 	MM2VIS.bP_Red_Active, PT := T#1s);				(*min 1s TRUE to mitigate wrong values on HMI*)

	MM2VIS.RedPower := 			RedPower_Norm * OUT_OP.rP_Nom;
	MM2VIS.iIdx_Eng_State := 	iIdx_Eng_State;
	MM2VIS.iIdx_Pred_Type := 	OUT_OP.iIdx_Pred_Type;
	MM2VIS.iSt_OpMode_Sub := 	iSt_OpMode_Sub;
	MM2VIS.iSt_OpMode_Deg := 	iSt_OpMode_Deg;
	MM2VIS.bMsg2125 := 		bMsg2125;
	MM2VIS.bMsg2126 := 		bMsg2126;
	MM2VIS.bMsg2127 := 		bMsg2127;
	MM2VIS.bMsg2128 := 		bMsg2128;
	MM2VIS.bMsg2129 := 		bMsg2129;
	MM2VIS.bMsg2130 := 		bMsg2130;
	MM2VIS.bMsg2131 := 		bMsg2131;
	MM2VIS.bMsg2132 := 		bMsg2132;
	MM2VIS.bMsg2143 := 		bMsg2143;
	MM2VIS.bMsg2144 := 		bMsg2144;
	MM2VIS.bMsg2146 := 		bMsg2146;
	MM2VIS.bMsg2147 := 		bMsg2147;
	MM2VIS.bMsg2148 := 		bMsg2148;
	MM2VIS.bMsg2149 := 		bMsg2149;
	MM2VIS.bMsg2150 := 		bMsg2150;
	MM2VIS.bMsg2152 := 		bMsg2152;
	MM2VIS.bMsg2153 :=		bMsg2153;
	MM2VIS.bMsg2154 :=		bMsg2154;
	MM2VIS.bMsg2155 :=		bMsg2155;
	MM2VIS.bMsg2158 :=		bMsg2158;
	MM2VIS.bMsg2159 :=		bMsg2159;
	MM2VIS.bMsg2160 :=		bMsg2160;
	MM2VIS.bMsg2161 :=		bMsg2161;
	MM2VIS.bMsg2163 :=		bMsg2163;
	MM2VIS.bMsg2164 :=		bMsg2164;
	MM2VIS.bMsg2803 :=		bMsg2803;
	MM2VIS.bMsg3229 :=		bMsg3229;
	MM2VIS.bMsg3230 :=		bMsg3230;
	MM2VIS.bMsg3231 :=		bMsg3231;
	MM2VIS.bMsg2140 :=		bMsg2140;
	MM2VIS.bMsg3506 :=		bMsg3506;
	MM2VIS.bMsg2082 :=		bMsg2082;
	MM2VIS.bMsg1188 :=		bMsg1188;
	MM2VIS.bMsg2097 :=		bMsg2097;
	MM2VIS.bMsg1108 :=		bMsg1108;
	MM2VIS.bEng_RPSDem :=		OUT_OP.bEng_RPSDem;
	MM2VIS.bEng_Rdy_Aut_Exc :=	OUT_OP.bEng_Rdy_Aut_Exc;
	MM2VIS.rP_Ramp_IncGrad_All_Norm := OUT_OP.rP_Ramp_IncGrad_All_Norm;
	MM2VIS.rP_Ramp_DecGrad_All_Norm := OUT_OP.rP_Ramp_DecGrad_All_Norm;
 
	MM2VIS.bMsg1225 :=	bMsg1225;
	MM2VIS.bMsg1226 :=	bMsg1226;
	MM2VIS.bMsg1227 :=	bMsg1227;
	MM2VIS.bMsg1228 :=	bMsg1228;
	MM2VIS.bMsg1229 :=	bMsg1229;
	MM2VIS.bMsg1230 :=	bMsg1230;
	MM2VIS.bMsg1231 :=	bMsg1231;
	MM2VIS.bMsg1232 :=	bMsg1232;
	MM2VIS.bMsg1233 :=	bMsg1233;
	MM2VIS.bMsg1234 :=	bMsg1234;
	MM2VIS.bMsg1237 :=	bMsg1237;
	MM2VIS.bMsg1238 :=	bMsg1238;
	MM2VIS.bMsg1241 :=	bMsg1241;
	MM2VIS.bMsg1242 :=	bMsg1242;
	MM2VIS.bMsg1243 :=	bMsg1243;
	MM2VIS.bMsg1244 :=	bMsg1244;

	MM2VIS.bMsg2170 :=	bMsg2170;
	MM2VIS.bMsg2936 :=	bMsg2936;

	(* from HAL IO *)
	(* to HAL IO *)
	MM2VIS.bEng_Aux_Dem_CDR :=	OUT_OP.tEng_Aux_Dem_CDR.Do;
	MM2VIS.bEng_Run :=			OUT_OP.tEng_Run.Do;
	
	(* Input: VIS2MM *)
	bStart := 			VIS2MM.bStart;
	VIS2MM.bStart := 	FALSE;	(* reset VIS button *)
	bStop := 			VIS2MM.bStop;
	VIS2MM.bStop := 	FALSE;	(* reset VIS button *)

	(* HARDWARE OPERATION MODE SWITCHES *)
	IF IN_OP.tHW_Switches.bGoodQual THEN
		OUT_OP.iIdx_OMSS			:= IN_OP.tHW_Switches.iIdx_OMS_Hw;
		OUT_OP.iIdx_RSS 			:= IN_OP.tHW_Switches.iIdx_RMS_Hw;
		VIS2MM.iIdx_OMSS			:= INT_TO_DINT(IN_OP.tHW_Switches.iIdx_OMS_Hw);
		VIS2MM.iIdx_RSS				:= INT_TO_DINT(IN_OP.tHW_Switches.iIdx_RMS_Hw);
		MM2VIS.bDont_show_switches	:= TRUE;	(* DON'T show switches on HMI *)
	ELSE	(* OPERATION MODE SWITCHES ON HMI *)
		OUT_OP.iIdx_OMSS 			:= DINT_TO_INT(VIS2MM.iIdx_OMSS);
		OUT_OP.iIdx_RSS 			:= DINT_TO_INT(VIS2MM.iIdx_RSS);
		MM2VIS.bDont_show_switches	:= FALSE;	(* show switches on HMI *)
	END_IF;

	OUT_OP.bStart	:= 	bStart;		(* to AuxiliariesGeneral starter tasks *)
	OUT_OP.bStop	:= 	bStop;		(* to AuxiliariesGeneral starter tasks *)

	MM2VIS.bMainMode_Idle := xOpMode.Idle;
	MM2VIS.bMainMode_Grid := xOpMode.NetP;
	MM2VIS.bMainMode_Island := xOpMode.Island;

	xTON_ParaOK_1s(IN := IN_OP.tPB2MM.bParaSetupOk, PT := T#1s);	(*Delay to mitigate wrong values on HMI*)
	IF xTON_ParaOK_1s.Q THEN
		
		MM2VIS.rP_Nom			:=		OUT_OP.rP_Nom;
		
		MM2VIS.rP_RedDelta_Knck_Norm		:= 1.0 - IN_OP.rP_Red_Knck_Norm;
		MM2VIS.rP_RedDelta_Ch_T2s_Norm		:= 1.0 - IN_OP.rP_Red_Ch_T2s_Norm_TC5;
		MM2VIS.rP_RedDelta_Misf_Norm		:= 1.0 - IN_OP.rP_Red_Misf_Norm;
		MM2VIS.rP_RedDelta_EGT_Norm			:= 1.0 - IN_OP.rP_Red_EGT_Norm;
		MM2VIS.rP_RedDelta_T_InAirER_Norm	:= 1.0 - IN_OP.rP_Red_T_InAirER_Norm;
		MM2VIS.rP_RedDelta_Leanox_Norm		:= 1.0 - IN_OP.rP_Red_Leanox_Norm;
		MM2VIS.rP_RedDelta_CH4_Norm			:= 1.0 - IN_OP.rP_Red_CH4_Norm;
		MM2VIS.rP_RedDelta_GasPr_Norm		:= 1.0 - IN_OP.rP_Red_GasPr_Norm;
		MM2VIS.rP_RedDelta_SuctPr_Norm		:= 1.0 - IN_OP.rP_Red_SuctPr_Norm;
		MM2VIS.rP_RedDelta_TC_Norm			:= 1.0 - IN_OP.rP_Red_TC_Norm;
		MM2VIS.rP_RedDelta_T_HWR_Norm		:= 1.0 - IN_OP.rP_Red_T_HWR_Norm;
		MM2VIS.rP_RedDelta_T_ECW_Norm		:= 1.0 - IN_OP.rP_Red_T_ECW_Norm;
		MM2VIS.rP_RedDelta_T_Oil_Norm		:= 1.0 - IN_OP.rP_Red_T_Oil_Norm;
		MM2VIS.rP_RedDelta_Pr_PCGT_Norm		:= 1.0 - IN_OP.rP_Red_Pr_PCGT_Norm;
		MM2VIS.rP_RedDelta_CosPCtr_U_Norm 	:= 1.0 - IN_OP.rP_Red_CosPCtr_U_Norm;
		MM2VIS.rP_RedDelta_CosPCtr_F_Norm 	:= 1.0 - IN_OP.rP_Red_CosPCtr_F_Norm;
		MM2VIS.rP_RedDelta_CosPCtr_T_Norm 	:= 1.0 - IN_OP.rP_Red_CosPCtr_T_Norm;
		MM2VIS.rP_RedDelta_Sp_Lim1_Norm		:= 1.0 - IN_OP.rP_Red_Sp_Lim1_Norm;
		MM2VIS.rP_RedDelta_Sp_Lim2_Norm		:= 1.0 - IN_OP.rP_Red_Sp_Lim2_Norm;
		MM2VIS.rP_RedDelta_Sp_Lim3_Norm		:= 1.0 - IN_OP.rP_Red_Sp_Lim3_Norm;
		MM2VIS.rP_RedDelta_EVU_Norm			:= 1.0 - IN_OP.rP_RedDI_EU_Norm;
		MM2VIS.rP_RedDelta_AI_Norm			:= 1.0 - IN_OP.rP_Red_AI_Norm;
		MM2VIS.rP_RedDelta_ExtBus_Norm		:= 1.0 - IN_OP.rP_Red_ExtBus_Norm;
		MM2VIS.rP_RedDelta_Hum_Norm			:= 1.0 - IN_OP.rP_Red_Hum_Norm;
		MM2VIS.rP_RedDelta_PBC_Norm 		:= 1.0 - IN_OP.rP_Red_PBC_Norm;
		MM2VIS.rP_RedDelta_Knck_Opti_Norm	:= 1.0 - IN_OP.rP_Red_Knck_Opti_Norm;
		MM2VIS.rP_RedDelta_SG_Norm			:= 1.0 - MIN(IN_OP.rP_Red_SG_Norm_Pred, IN_OP.rP_Red_SG_Norm_FPR); 
		MM2VIS.rP_RedDelta_Pr_CC_Norm		:= 1.0 - IN_OP.rP_Red_Pr_CC_Norm;
		MM2VIS.rP_RedDelta_HiCtr_Norm		:= 1.0 - IN_OP.rP_Red_HiCtr_Norm;
		MM2VIS.rP_RedDelta_T_Transformer_Norm		:= 1.0 - IN_OP.rP_Red_TransformerWarning_Norm;
		MM2VIS.rP_RedDelta_T_GenSwitchCab_Norm		:= 1.0 - IN_OP.rP_Red_TempMax_GenCB_Norm;
		MM2VIS.rP_RedDelta_T_GenAirIn_Norm	:= 1.0 - IN_OP.rP_Red_T_GenAirIn_Norm;
		MM2VIS.rP_RedDelta_Pr_GR_Norm		:= 1.0 - IN_OP.rP_Red_Pr_GR_Norm;
		MM2VIS.rP_RedDelta_CppInt_Norm		:= 1.0 - IN_OP.rP_Red_CppInt_Norm;
		MM2VIS.rP_RedDelta_CV_Norm			:= 1.0 - IN_OP.rP_Red_CV_Norm;
		MM2VIS.rP_RedDelta_Eta_Gen_Norm		:= 1.0 - IN_OP.rP_Red_Eta_Gen_Norm;
		MM2VIS.rP_RedDelta_SAErr_Norm		:= 1.0 - IN_OP.rP_Red_SAErr_Norm;
		MM2VIS.rP_RedDelta_SG_Norm			:= 1.0 - MIN(IN_OP.rP_Red_SG_Norm_Pred, IN_OP.rP_Red_SG_Norm_FPR); 
		MM2VIS.rP_RedDelta_DPr_TJ_Norm		:= 1.0 - IN_OP.rP_Red_TJDiffPr_Norm;
		MM2VIS.rP_RedDelta_Ch_T2HP_Norm		:= 1.0 - IN_OP.rP_Red_Ch_T2HP_Norm;
		MM2VIS.rP_RedDelta_Ch_T2LP_Norm		:= 1.0 - IN_OP.rP_Red_Ch_T2LP_Norm;
		MM2VIS.rP_RedDelta_H2_Norm			:= 1.0 - IN_OP.rP_Red_H2_Norm;
	END_IF;
	
	xTON_ParaOK_2s(IN := IN_OP.tPB2MM.bParaSetupOk, PT := T#2s);		(*Delay to mitigate wrong values on HMI*)
	IF xTON_ParaOK_2s.Q THEN

		MM2VIS.rP_Red_EGT		:=		IN_OP.rP_Red_EGT_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Misf		:=		IN_OP.rP_Red_Misf_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Leanox	:=		IN_OP.rP_Red_Leanox_Norm *	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_CH4		:=		IN_OP.rP_Red_CH4_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_EVU		:=		IN_OP.rP_RedDI_EU_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_GasPr		:=		IN_OP.rP_Red_GasPr_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_SuctPr	:=		IN_OP.rP_Red_SuctPr_Norm *	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_AI		:=		IN_OP.rP_Red_AI_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_CosPCtr_F	:=		IN_OP.rP_Red_CosPCtr_F_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_CosPCtr_U	:=		IN_OP.rP_Red_CosPCtr_U_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_CosPCtr_T	:=		IN_OP.rP_Red_CosPCtr_T_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_TC		:=		IN_OP.rP_Red_TC_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Sp_Lim1	:=		IN_OP.rP_Red_Sp_Lim1_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Sp_Lim2	:=		IN_OP.rP_Red_Sp_Lim2_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Sp_Lim3	:=		IN_OP.rP_Red_Sp_Lim3_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Knck		:=		IN_OP.rP_Red_Knck_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Ch_T2s	:=		IN_OP.rP_Red_Ch_T2s_Norm_TC5	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_T_HWR		:=		IN_OP.rP_Red_T_HWR_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_T_ECW		:=		IN_OP.rP_Red_T_ECW_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_T_Oil		:=		IN_OP.rP_Red_T_Oil_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Pr_PCGT	:=		IN_OP.rP_Red_Pr_PCGT_Norm *	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_ExtBus	:=		IN_OP.rP_Red_ExtBus_Norm *	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_T_InAirER	:=		IN_OP.rP_Red_T_InAirER_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Hum		:= 		IN_OP.rP_Red_Hum_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_PBC		:= 		IN_OP.rP_Red_PBC_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Knck_Opti	:= 		IN_OP.rP_Red_Knck_Opti_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_SG		:= 		MIN(IN_OP.rP_Red_SG_Norm_Pred, IN_OP.rP_Red_SG_Norm_FPR) * OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Pr_CC		:=		IN_OP.rP_Red_Pr_CC_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_HiCtr		:=		IN_OP.rP_Red_HiCtr_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_T_Transformer		:=	IN_OP.rP_Red_TransformerWarning_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_T_GenSwitchCab	:=	IN_OP.rP_Red_TempMax_GenCB_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_T_GenAirIn	:=	IN_OP.rP_Red_T_GenAirIn_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.bP_Red_Sp_Lim1Act	:= 	IN_OP.bP_Red_Sp_Lim1Act;
		MM2VIS.bP_Red_Sp_Lim2Act	:= 	IN_OP.bP_Red_Sp_Lim2Act;
		MM2VIS.bP_Red_Sp_Lim3Act	:= 	IN_OP.bP_Red_Sp_Lim3Act;
		MM2VIS.rP_Red_Pr_GR			:= 	IN_OP.rP_Red_Pr_GR_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_CppInt		:= 	IN_OP.rP_Red_CppInt_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_CV			:= 	IN_OP.rP_Red_CV_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Eta_Gen		:=	IN_OP.rP_Red_Eta_Gen_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_SAErr			:=	IN_OP.rP_Red_SAErr_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_SG_Norm		:=	MIN(IN_OP.rP_Red_SG_Norm_Pred, IN_OP.rP_Red_SG_Norm_FPR) * OUT_OP.rP_Nom;
		MM2VIS.rP_Red_DPr_TJ		:= 	IN_OP.rP_Red_TJDiffPr_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_H2			:= 	IN_OP.rP_Red_H2_Norm	*	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Ch_T2HP		:=	IN_OP.rP_Red_Ch_T2HP_Norm *	OUT_OP.rP_Nom;
		MM2VIS.rP_Red_Ch_T2LP		:=	IN_OP.rP_Red_Ch_T2LP_Norm *	OUT_OP.rP_Nom;
		
		IF (OUT_OP.iIdx_OMSS = 2)(*AUTO*) OR (OUT_OP.iIdx_OMSS = 3)(*TEST*) THEN
			MM2VIS.rP_Set_Min	:=		OUT_OP.rP_Set_Min_Norm	*	OUT_OP.rP_Nom;
		ELSE
			MM2VIS.rP_Set_Min	:= 		0;
		END_IF;
	END_IF;		

	MM2VIS.bMsg2122 :=	bMsg2122;
	MM2VIS.bMsg2123 :=	bMsg2123;
	MM2VIS.bMsg2124 :=	bMsg2124;
	MM2VIS.bMsg2133 :=	bMsg2133;
	MM2VIS.bMsg2134 :=	bMsg2134;
	MM2VIS.bMsg2135 :=	bMsg2135;
	MM2VIS.bMsg2136 :=	bMsg2136;
	MM2VIS.bMsg2137 :=	bMsg2137;
	MM2VIS.bMsg2138 :=	bMsg2138;
	MM2VIS.bMsg2813 :=	bMsg2813;
	MM2VIS.bMsg9057 := 	bIsland_NoffsCust;	(* B9057 - Isolated operation - external speed reference mode *)
	MM2VIS.bMsg9058 := 	bPset_Droop_Bus;	(* B9058 - message power setpoint by Bus input Droop *)
	MM2VIS.bMsg9059 := 	bPset_Droop_AI;		(* B9059 - message power setpoint by analog input Droop *)
	MM2VIS.bMsg9060 := 	bPset_Droop_Man;	(* B9060 - message power setpoint by internal HMI value Droop *)

	
	IF (OUT_OP.rP_Act_Norm >=0.95) THEN (* The engine operates at 95% load or higher *)
		MM2VIS.iSt_VIS_Porgress := 6;
	ELSIF IN_OP.bLeanox_Active THEN		(* leanox controller activatd *)
		MM2VIS.iSt_VIS_Porgress := 5;
	ELSIF xOpMode.NetP OR xOpMode.Island THEN (* mains parallel or isolated operation mode *)
		MM2VIS.iSt_VIS_Porgress := 4;
	ELSIF xOpMode.Idle THEN				(* idle mode *)
		MM2VIS.iSt_VIS_Porgress := 3;
	ELSIF (iIdx_Eng_State = 10) THEN	(* engine start up *)
		MM2VIS.iSt_VIS_Porgress := 2;
	ELSIF (M_ANF = TRUE) THEN			(* module has been activated *)
		MM2VIS.iSt_VIS_Porgress := 1;
	ELSE								(* module has not been activated *)
		MM2VIS.iSt_VIS_Porgress := 0;
	END_IF
	
	MM2VIS.bEng_Rdy_Aut := OUT_OP.bEng_Rdy_Aut;
	MM2VIS.bEng_Rdy_Rem := OUT_OP.tEng_Rdy_Rem.Do;
	MM2VIS.bEng_Aux_Dem := OUT_OP.bEng_Aux_Dem;
	MM2VIS.bImp_OpHour  := OUT_OP.tImp_OpHour.Do;
	MM2VIS.bImp_UnitOpHour  := OUT_OP.bImp_UnitOpHour;
	MM2VIS.bImp_Start	:= OUT_OP.bImp_Start;

	xTP_F_N_DI_Inc(IN:= EDGEPOS(IN_OP.tF_N_DI_Inc.Di), PT:= T#2s);	(* DI synch.increase speed *)
	MM2VIS.bF_N_DI_Inc		:= xTP_F_N_DI_Inc.Q;

	xTP_F_N_DI_Dec(IN:= EDGEPOS(IN_OP.tF_N_DI_Dec.Di), PT:= T#2s);	(* DI synch.decrease speed *)
	MM2VIS.bF_N_DI_Dec		:= xTP_F_N_DI_Dec.Q;


END_PROGRAM
