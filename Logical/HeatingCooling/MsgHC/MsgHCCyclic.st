(*******************************************************************************
MsgHC	 			 messages

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2025

Customized modifications: -
------------------------
 
History:
-------
V0.01.0	02.11.2011	lettenb.	new
V3.30.0 14.09.2011	lettenb.	2119 xTON_ChC_FanRdy added
V3.99.0	20.02.2013	lettenb.	3303,3521,3590 IN_HC.tT_HW_Re_LT.Ai added (V3.40)
		27.05.2013				3521 Para.bT_HW_Re_LT_Active added
		27.05.2013	Lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
		31.01.2014	lettenb.	1063 BWS_HA added(1063 NOT resetable in CASE OF sensor fail.)V350	
V4.00.0	02.06.2014	lettenb.	3509 AND NOT MM2VIS.bMsg3312 added(hi-alarm in case of ms failure)
		16.06.2014	lettenb.	2104 xTP_2104, PT:= 0->1" added, acc.xt3 bugfix	
V4.00.1 15.09.2014	lettenb.	1063 Para.bT_HW_Su_Active added
V4.00.2 17.11.2014				2638,2639,2640,2641,2647,2667 added, 920	 											
								2104 enable with IN_HC.tPB2MM.bSys_Run	
V4.00.3	19.03.2015				1021 STB active for 920+visa
		02.04.2015				2119 bugfix(portation failure from xt3)	
V4.03.0 06.07.2015				920 ECW + EO module signals added(TCA redesign)
		25.07.2015	Plattner	2731-2736,2750,2751 failure boiler house ventilator added
		30.09.2015				2119 tAuxV_Aux_ok added
		17.03.2016	lettenb.	1021 KTMA_VISA added (920 umschaltung prio)
V4.04.0 07.04.2016	lettenb.	3492,3493,3494 added (TCA redesign2), 2640 disabled(double coded, 3590)
								2732,2734,2751 MS added + T#0s -> 2s, bugfix
		24.10.2016				2763 Functional Safety EN 13849
V4.05.0 27.02.2017	lettenb.	1032,1033 disabled for BR9 -> 2428,2429 added, SWAT920/1
		04.12.2017	Waldhart	1032,1033 enabled FOR BR9 -> 2428,2429 disabled, SWAT920/4
		22.12.2017	lettenb.	comment added: Safety-related application software source code (EN 13849-1 / 4.6.3)
		22.01.2018	lettenb.	1145,1186,1187,3407,3508,3526,3590 bParaSetupOk added TO avoid message at plc startup
V4.07.0	09.08.2018	Schmid		2nd low temperature charge cooling circuit added (W9226, W9228-W9232)
		08.10.2018	lettenb.	1063,1070,1071,1186,1187,2430,3312,3321,3508,3526,3590,9232 :bOMSS... removed, signal failure active in stop-mode
		11.10.2018	lettenb.	2720: enable Para.bT_Re_SecCirc_Active, bugfix
		17.12.2018	Schmid		OUT_HC.bMsg2684 -> AG vvm added
		06.06.2019	lettenb.	2733,2736,2752,3492,3493,3494 bParaSetupOk added to avoid alarm at plc-startup
V4.10.0	20.07.2020	Schmid		2341, 2342, 2343 additional heating water circuit monitoring
V4.11.0	17.01.2022	lettenb.	2736 delay 2s added, bugfix	
V4.14.0 08.11.2024	Bacci		9098, 9099 added
		11.12.2024	Nagy		1019,1021,1050,3402 modified (2024-225)
V4.25.0	10.07.2025	Tinello		SafetyPLC: Added monitoring for heating water supply temperature unit W9588, W9589

Instructions for use:
--------------------
1) declare alarm with function block "Msg"
	declare buffert alarm bit bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset acc.TI 1100-0111
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	
	bMsg0000_Test		:=	xMsg0000.Test; alarm bypass active

3)  expand INIT

			
Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC	


	(* reset general trip *)
	OUT_HC.tHC2AB.bGnlTrip1		:=	FALSE;
	OUT_HC.tHC2AB.bGnlTrip2		:=	FALSE;
	OUT_HC.tHC2AB.bGnlTrip3		:=	FALSE;
	OUT_HC.tHC2AB.bGnlWarning	:=	FALSE;
	OUT_HC.tHC2AB.bTriptype1	:=	FALSE;
	OUT_HC.tHC2AB.bTriptype2	:=	FALSE;
	OUT_HC.tHC2AB.bTriptype3	:=	FALSE;	


	(*---------------------------------------------------------------------------*)
	xTON_EngRunAnd10s(IN:= IN_HC.tEng_Run.Do, PT:= T#10s);
	xTON_EngRunAnd60s(IN:= IN_HC.tEng_Run.Do, PT:= T#60s);

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	
	(*  1019 engine cooling water pressure low *)
	xTP_1019(IN:= IN_HC.tECWP1Dem.Do, PT:= T#10s);	(* lock monitoring *)

	xMsg1019.Enable		:=	TRUE;
	xMsg1019.Set		:=	(bPr_ECW_LoLo OR bPr_ECW_LoLoPrio2) AND NOT xTP_1019.Q;
	xMsg1019.PT			:=	T#0s;
	IF bPr_ECW_LoLoPrio2 THEN
		xMsg1019.Prio		:=	2;
	ELSE
		xMsg1019.Prio		:=	3;
	END_IF;
	xMsg1019.RiskClass	:=	10;	
	xMsg1019.Reset		:=	FALSE;
	xMsg1019();
	MM2VIS.bMsg1019     := xMsg1019.Q;
	OUT_HC.bMsg1019     := xMsg1019.Q;
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)


	(* A1021 engine cooling water temperature high *)
	xTON_1021(IN:= OUT_HC.bT_ECW_Hi, PT:= T#2h);
	
	xMsg1021.Enable		:=	TRUE;
	xMsg1021.Set		:= ((xTON_1021.Q OR bT_ECW_HiHi OR bT_ECW_HiHiPrio2) AND xTON_EngRunAnd60s.Q AND NOT MM2VIS.bMsg2101)
						OR  IN_HC.tT_ECW_Ext_Hi.Di; (*STB: VISA + 920*)
	xMsg1021.PT			:=	T#0s;
	KTMA_VISA := IN_HC.tT_ECW_Ext_Hi.Di OR (KTMA_VISA AND xMsg1021.Q);
	IF (Para.bVISA OR xEngType.Type9) AND KTMA_VISA OR bT_ECW_HiHiPrio2 THEN	(* umschaltung prio nur bei abstellung durch STB(sicherheitsschleife) *) 
		xMsg1021.Prio	:=	2;
	ELSE
		xMsg1021.Prio	:=	3;
	END_IF;
	xMsg1021.RiskClass	:=	0;	
	xMsg1021.Reset		:=	FALSE;
	xMsg1021();
	MM2VIS.bMsg1021     := xMsg1021.Q;


	(* A1032 heat water flow low (W2428)*)
	xTOF_EngDemEPS(IN:= IN_HC.bEng_Dem_EPS AND NOT IN_HC.tGCB_On.Di, PT:= T#60s);
	bNoMon4BlackStart := xTOF_EngDemEPS.Q AND IN_HC.bEng_Dem_EPS; //T14
	
	xMsg1032.Enable		:=	TRUE;//SWAT920/4
	xMsg1032.Set 		:=	NOT IN_HC.tFlow_HW_Lo.Di
						AND NOT bNoMon4BlackStart AND IN_HC.tEng_Run.Do;
	xMsg1032.PT			:=	T#10s;
	xMsg1032.Prio		:=	3;
	xMsg1032.RiskClass	:=	4;
	xMsg1032.Reset		:=	FALSE;
	xMsg1032();
	MM2VIS.bMsg1032     := xMsg1032.Q;

	
	(* A1033 heat water temperature high (W2429)*)
	xMsg1033.Enable		:=	TRUE;//SWAT920/4
	xMsg1033.Set 		:=	IN_HC.tT_HW_Hi.Di OR IN_HC.tT_HW_Hi1.Di;
	xMsg1033.PT			:=	T#0s;
	xMsg1033.Prio		:=	2;
	xMsg1033.RiskClass	:=	4;
	xMsg1033.Reset		:=	FALSE;
	xMsg1033();
	MM2VIS.bMsg1033     := xMsg1033.Q;
	
	
	(* A1034 heat water pressure low *)
	xMsg1034.Enable		:=	TRUE;
	xMsg1034.Set 		:=  IN_HC.tPr_HW_Lo.Di;
	xMsg1034.PT			:=	T#0s;
	xMsg1034.Prio		:=	2;
	xMsg1034.RiskClass	:=	4;
	xMsg1034.Reset		:=	FALSE;
	xMsg1034();
	MM2VIS.bMsg1034     := xMsg1034.Q;
	
	
	(* A1035 heat water pressure high *)
	xMsg1035.Enable		:=	TRUE;
	xMsg1035.Set 		:=  IN_HC.tPr_HW_Hi.Di OR IN_HC.tPr_HW_Hi1.Di;
	xMsg1035.PT			:=	T#0s;
	xMsg1035.Prio		:=	2;
	xMsg1035.RiskClass	:=	4;
	xMsg1035.Reset		:=	FALSE;
	xMsg1035();
	MM2VIS.bMsg1035     := xMsg1035.Q;
	

	(* A1050 engine cooling water pressure high *)
	(* lock monitoring jacket water pressure high at engine start. (reference: W3406)
	(in case of rising jacket water pressure with rising oil pressure.
	caused by pressure transfered from oil circuit to water circuit by the plate heat exchanger)*)
	xTP_1050(IN:= bN_EngStart, PT:= T#20s);

	xMsg1050.Enable		:=	TRUE;
	xMsg1050.Set := (bPr_ECW_HiHi OR bPr_ECW_HiHiPrio2) AND NOT xTP_1050.Q;
	xMsg1050.PT			:=	T#0s;
	IF bPr_ECW_HiHiPrio2 THEN
		xMsg1050.Prio		:=	2;
	ELSE
		xMsg1050.Prio		:=	3;
	END_IF;
	xMsg1050.RiskClass	:=	2;	
	xMsg1050.Reset		:=	FALSE;
	xMsg1050();
	MM2VIS.bMsg1050     := xMsg1050.Q;
	OUT_HC.bMsg1050		:= xMsg1050.Q;
	

	(* A1063 heat water supply temperature high (W2430)*)
	xMsg1063.Enable		:=	Para.bT_HW_Su_Active;
	xMsg1063.Set 		:=  bT_HW_Su_HiHi AND NOT MM2VIS.bMsg1071 AND NOT MM2VIS.bMsg1187;
	xMsg1063.PT			:=	T#2s;
	xMsg1063.Prio		:=	3;
	xMsg1063.RiskClass	:=	0;
	xMsg1063.Reset		:=	FALSE;
	xMsg1063();
	MM2VIS.bMsg1063     := xMsg1063.Q;


	(* A1070 heat water return temperature signal failure trip (W1186)*)
	xMsg1070.Enable		:=	Para.bT_HW_Re_Active AND Para.bT_HW_Re_SF_Trip;
	xMsg1070.Set 		:=	NOT IN_HC.tT_HW_Re.GoodQual;
	xMsg1070.PT			:=	T#0s;
	xMsg1070.Prio		:=	3;
	xMsg1070.RiskClass	:=	4;	
	xMsg1070.Reset		:=	FALSE;
	xMsg1070();
	MM2VIS.bMsg1070     := xMsg1070.Q;


	(* A1071 heat water supply temperature signal failure trip (W1187)*)
	xMsg1071.Enable		:=	Para.bT_HW_Su_Active AND Para.bT_HW_Su_SF_Trip;
	xMsg1071.Set 		:=  NOT IN_HC.tT_HW_Su.GoodQual;
	xMsg1071.PT			:=	T#0s;
	xMsg1071.Prio		:=	3;
	xMsg1071.RiskClass	:=	4;	
	xMsg1071.Reset		:=	FALSE;
	xMsg1071();
	MM2VIS.bMsg1071     := xMsg1071.Q;


	(* A1130 charge cooler water pressure low (W2117)*)
	xMsg1130.Enable		:=	FALSE;
	xMsg1130.Set		:=	NOT IN_HC.tPr_ChC_Lo.Di;
	xMsg1130.PT			:=	T#0s;
	xMsg1130.Prio		:=	3;
	xMsg1130.RiskClass	:=	4;	
	xMsg1130.Reset		:=	FALSE;
	xMsg1130();
	MM2VIS.bMsg1130     := xMsg1130.Q;
	
	
	(* W1145 engine cooling water temperature low *)
	xMsg1145.Enable		:=	IN_HC.tPB2MM.bParaSetupOk;
	xMsg1145.Set 		:=  OUT_HC.bT_ECW_Lo;
	xMsg1145.PT			:=	T#0s;
	xMsg1145.Prio		:=	4;
	xMsg1145.RiskClass	:=	4;	
	xMsg1145.Reset		:=	FALSE;
	xMsg1145();
	MM2VIS.bMsg1145     := xMsg1145.Q;


	(* W1167  heat water return temperature high *)
	xTON_1167(IN:= NOT MM2VIS.bMsg1186 AND NOT MM2VIS.bMsg1070 AND bT_HW_Re_Hi, PT:= T#10s);

	xMsg1167.Enable		:=	Para.bT_HW_Re_Active;
	xMsg1167.Set 		:=  xTON_EngRunAnd10s.Q AND xTON_1167.Q;
	xMsg1167.PT			:=	T#0s;
	xMsg1167.Prio		:=	4;
	xMsg1167.RiskClass	:=	4;	
	xMsg1167.Reset		:=	FALSE;
	xMsg1167();
	MM2VIS.bMsg1167     := xMsg1167.Q;


	(* W1186 heat water return temperature signal failure (A1070)*)
	xMsg1186.Enable		:=	Para.bT_HW_Re_Active AND NOT Para.bT_HW_Re_SF_Trip AND IN_HC.tPB2MM.bParaSetupOk;
	xMsg1186.Set 		:=  NOT IN_HC.tT_HW_Re.GoodQual;
	xMsg1186.PT			:=	T#0s;
	xMsg1186.Prio		:=	4;
	xMsg1186.RiskClass	:=	4;	
	xMsg1186.Reset		:=	FALSE;
	xMsg1186();
	MM2VIS.bMsg1186     := xMsg1186.Q;


	(* W1187 heat water supply temperature signal failure (A1071)*)
	xMsg1187.Enable		:=	Para.bT_HW_Su_Active AND NOT Para.bT_HW_Su_SF_Trip AND IN_HC.tPB2MM.bParaSetupOk;
	xMsg1187.Set 		:=  NOT IN_HC.tT_HW_Su.GoodQual;
	xMsg1187.PT			:=	T#0s;
	xMsg1187.Prio		:=	4;
	xMsg1187.RiskClass	:=	4;	
	xMsg1187.Reset		:=	FALSE;
	xMsg1187();
	MM2VIS.bMsg1187     := xMsg1187.Q;


	(* W2101 engine cooling water temperature signal failure *)
	xMsg2101.Enable		:=	TRUE;
	xMsg2101.Set		:= (NOT IN_HC.tT_ECW.GoodQual AND IN_HC.tPB2MM.bParaSetupOk)
						OR (xMsg2101.Set AND IN_HC.bMsg3003 AND bOMSS_MAT);
	xMsg2101.PT			:=	T#0s;
	xMsg2101.Prio		:=	4;
	xMsg2101.RiskClass	:=	4;	
	xMsg2101.Reset		:=	FALSE;
	xMsg2101();
	MM2VIS.bMsg2101     := xMsg2101.Q;
	OUT_HC.bMsg2101     := xMsg2101.Q;


	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* W2104 engine cooling water pressure signal failure *)
	xTP_2104(IN:= IN_HC.tECWP1Dem.Do, PT:= T#10s);	(* lock monitoring *)

	xMsg2104.Enable		:=	IN_HC.tPB2MM.bSys_Run;
	xMsg2104.Set		:= (NOT IN_HC.tPr_ECW.GoodQual AND NOT xTP_2104.Q)
						OR (xMsg2104.Set AND IN_HC.bMsg3003 AND bOMSS_MAT);
	xMsg2104.PT			:=	T#1s;
	xMsg2104.Prio		:=	4;
	xMsg2104.RiskClass	:=	4;	
	xMsg2104.Reset		:=	FALSE;
	xMsg2104();
	MM2VIS.bMsg2104     := xMsg2104.Q;
	OUT_HC.bMsg2104     := xMsg2104.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)


	(* W2116 emergency cooler failure *)
	xMsg2116.Enable		:=	TRUE;
	xMsg2116.Set		:=	NOT IN_HC.tEC_Failure.Di AND NOT bNoMon4BlackStart;
	xMsg2116.PT			:=	T#0s;
	xMsg2116.Prio		:=	4;
	xMsg2116.RiskClass	:=	4;	
	xMsg2116.Reset		:=	FALSE;
	xMsg2116();
	MM2VIS.bMsg2116     := xMsg2116.Q;


	(* W2117 charge cooler water pressure low (A1130)*)
	xMsg2117.Enable		:=	TRUE;
	xMsg2117.Set		:=	NOT IN_HC.tPr_ChC_Lo.Di;
	xMsg2117.PT			:=	T#10s;
	xMsg2117.Prio		:=	4;
	xMsg2117.RiskClass	:=	4;	
	xMsg2117.Reset		:=	FALSE;
	xMsg2117();
	MM2VIS.bMsg2117     := xMsg2117.Q;
	OUT_HC.bMsg2117     := xMsg2117.Q;


	(* W2119 charge cooler failure *)
	xTON_ChC_FanRdy(IN:= (IN_HC.tAuxV_Supply_Ok.Di AND IN_HC.tAuxV_Aux_ok.Di) AND NOT IN_HC.tChC_FanRdy.Di, PT:= T#10s);		(*PJ*)

	xMsg2119.Enable		:=	TRUE;
	xMsg2119.Set		:=	NOT bNoMon4BlackStart AND(xTON_ChC_FanRdy.Q OR NOT IN_HC.tChC_Failure.Di);
	xMsg2119.PT			:=	T#0s;
	xMsg2119.Prio		:=	4;
	xMsg2119.RiskClass	:=	4;	
	xMsg2119.Reset		:=	FALSE;
	xMsg2119();
	MM2VIS.bMsg2119     := xMsg2119.Q;

	(* A2341 Heating water temperature maximum - exhaust gas cooler *)
	xMsg2341.Enable		:=	IN_HC.tT_HW_EGHE_Hi.GoodQual;
	xMsg2341.Set 		:=	IN_HC.tT_HW_EGHE_Hi.Di;
	xMsg2341.PT			:=	T#0s;
	xMsg2341.Prio		:=	2;
	xMsg2341.RiskClass	:=	4;
	xMsg2341.Reset		:=	FALSE;
	xMsg2341();
	MM2VIS.bMsg2341     := xMsg2341.Q;
	
	(* A2342 Heating water temperature maximum - exhaust gas condenser *)
	xMsg2342.Enable		:=	IN_HC.tT_HW_EGCD_Hi.GoodQual;
	xMsg2342.Set 		:=	IN_HC.tT_HW_EGCD_Hi.Di;
	xMsg2342.PT			:=	T#0s;
	xMsg2342.Prio		:=	2;
	xMsg2342.RiskClass	:=	4;
	xMsg2342.Reset		:=	FALSE;
	xMsg2342();
	MM2VIS.bMsg2342     := xMsg2342.Q;
	
	(* A2343 External heating water circuit monitoring tripped *)
	xMsg2343.Enable		:=	IN_HC.tCust_HW_Ext_Trip.GoodQual;
	xMsg2343.Set 		:=	IN_HC.tCust_HW_Ext_Trip.Di;
	xMsg2343.PT			:=	T#0s;
	xMsg2343.Prio		:=	2;
	xMsg2343.RiskClass	:=	4;
	xMsg2343.Reset		:=	FALSE;
	xMsg2343();
	MM2VIS.bMsg2343     := xMsg2343.Q;
	
	(* W2428 heat water flow low (A1032)*)
	xMsg2428.Enable		:=	FALSE;//SWAT920/4
	xMsg2428.Set 		:=	NOT IN_HC.tFlow_HW_Lo.Di
						AND NOT bNoMon4BlackStart AND IN_HC.tEng_Run.Do;
	xMsg2428.PT			:=	T#10s;
	xMsg2428.Prio		:=	4;
	xMsg2428.RiskClass	:=	4;
	xMsg2428.Reset		:=	FALSE;
	xMsg2428();
	MM2VIS.bMsg2428     := xMsg2428.Q;

	(* W2429 heat water temperature high (A1033)*)
	xMsg2429.Enable		:=	FALSE;//SWAT920/4
	xMsg2429.Set 		:=	IN_HC.tT_HW_Hi.Di OR IN_HC.tT_HW_Hi1.Di;
	xMsg2429.PT			:=	T#0s;
	xMsg2429.Prio		:=	4;
	xMsg2429.RiskClass	:=	4;
	xMsg2429.Reset		:=	FALSE;
	xMsg2429();
	MM2VIS.bMsg2429     := xMsg2429.Q;

	(* W2430 heat water supply temperature high (A1063)*)//SWAT920/1
	xMsg2430.Enable		:=	Para.bT_HW_Su_Active;
	xMsg2430.Set 		:=  bT_HW_Su_Hi AND NOT MM2VIS.bMsg1071 AND NOT MM2VIS.bMsg1187;
	xMsg2430.PT			:=	T#2s;
	xMsg2430.Prio		:=	4;
	xMsg2430.RiskClass	:=	0;
	xMsg2430.Reset		:=	FALSE;
	xMsg2430();
	MM2VIS.bMsg2430     := xMsg2430.Q;
	
	(* W2638 heat water supply pressure LT circuit signal failure *)
	xMsg2638.Enable		:=	Para.bPr_HW_Su_LT_Active;
	xMsg2638.Set		:=	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPr_HW_Su_LT.GoodQual;
	xMsg2638.PT			:=	T#0s;
	xMsg2638.Prio		:=	4;
	xMsg2638.RiskClass	:=	4;	
	xMsg2638.Reset		:=	FALSE;
	xMsg2638();
	MM2VIS.bMsg2638     := xMsg2638.Q;

	(* W2639 heat water supply pressure HT circuit signal failure *)
	xMsg2639.Enable		:=	Para.bPr_HW_Su_HT_Active;
	xMsg2639.Set		:=	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPr_HW_Su_HT.GoodQual;
	xMsg2639.PT			:=	T#0s;
	xMsg2639.Prio		:=	4;
	xMsg2639.RiskClass	:=	4;	
	xMsg2639.Reset		:=	FALSE;
	xMsg2639();
	MM2VIS.bMsg2639     := xMsg2639.Q;

	(* W2640 heat water return temperature LT circuit signal failure *)(* -> 3590 *)
	xMsg2640.Enable		:=	Para.bT_HW_Re_LT_Active AND FALSE;
	xMsg2640.Set		:=	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_HW_Re_LT.GoodQual;
	xMsg2640.PT			:=	T#0s;
	xMsg2640.Prio		:=	4;
	xMsg2640.RiskClass	:=	4;	
	xMsg2640.Reset		:=	FALSE;
	xMsg2640();
	MM2VIS.bMsg2640     := xMsg2640.Q;

	(* W2641 heat water supply temperature LT circuit signal failure *)
	xMsg2641.Enable		:=	Para.bT_HW_Su_LT_Active;
	xMsg2641.Set		:=	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_HW_Su_LT.GoodQual;
	xMsg2641.PT			:=	T#0s;
	xMsg2641.Prio		:=	4;
	xMsg2641.RiskClass	:=	4;	
	xMsg2641.Reset		:=	FALSE;
	xMsg2641();
	MM2VIS.bMsg2641     := xMsg2641.Q;

	(* W2647 engine cooling water pressure after engine signal failure *)
	xMsg2647.Enable	   := Para.bPr_ECWaEng_Active;
	xMsg2647.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPr_ECWaEng.GoodQual;
	xMsg2647.PT		   := T#0s;
	xMsg2647.Prio	   := 4;
	xMsg2647.RiskClass := 4;
	xMsg2647.Reset	   := FALSE;
	xMsg2647();
	MM2VIS.bMsg2647	   := xMsg2647.Q;

	(* W2667 engine cooling water temperature before engine signal failure *)
	xMsg2667.Enable	   := Para.bT_ECWbEng_Active;
	xMsg2667.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_ECWbEng.GoodQual;
	xMsg2667.PT		   := T#0s;
	xMsg2667.Prio	   := 4;
	xMsg2667.RiskClass := 4;
	xMsg2667.Reset	   := FALSE;
	xMsg2667();
	MM2VIS.bMsg2667	   := xMsg2667.Q;

	(* W2675 Pressure heat water return low temperature circuit return signal failure *)
	xMsg2675.Enable	   := Para.bPr_HW_Re_LT_Active;
	xMsg2675.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPr_HW_Re_LT.GoodQual;
	xMsg2675.PT		   := T#0s;
	xMsg2675.Prio	   := 4;
	xMsg2675.RiskClass := 4;
	xMsg2675.Reset	   := FALSE;
	xMsg2675();
	MM2VIS.bMsg2675	   := xMsg2675.Q;

	(* W2676 Pressure heat water return high temperature circuit signal failure *)
	xMsg2676.Enable	   := Para.bPr_HW_Re_HT_Active;
	xMsg2676.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPr_HW_Re_HT.GoodQual;
	xMsg2676.PT		   := T#0s;
	xMsg2676.Prio	   := 4;
	xMsg2676.RiskClass := 4;
	xMsg2676.Reset	   := FALSE;
	xMsg2676();
	MM2VIS.bMsg2676	   := xMsg2676.Q;

	(* W2677 Pressure heat water return hydraulic engine cooling water preheating signal failure *)
	xMsg2677.Enable	   := Para.bPr_HW_Re_PreH_ECW_Active;
	xMsg2677.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPr_HW_Re_PreH_ECW.GoodQual;
	xMsg2677.PT		   := T#0s;
	xMsg2677.Prio	   := 4;
	xMsg2677.RiskClass := 4;
	xMsg2677.Reset	   := FALSE;
	xMsg2677();
	MM2VIS.bMsg2677	   := xMsg2677.Q;

	(* W2678 Pressure heat water return hydraulic oil preheating signal failure *)
	xMsg2678.Enable	   := Para.bPr_HW_Re_PreH_EO_Active;
	xMsg2678.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPr_HW_Re_PreH_EO.GoodQual;
	xMsg2678.PT		   := T#0s;
	xMsg2678.Prio	   := 4;
	xMsg2678.RiskClass := 4;
	xMsg2678.Reset	   := FALSE;
	xMsg2678();
	MM2VIS.bMsg2678	   := xMsg2678.Q;

	(* W2679 Pressure oil module oil outlet signal failure *)
	xMsg2679.Enable	   := Para.bPr_EO_Mod_Out_Active;
	xMsg2679.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPr_EO_Mod_Out.GoodQual;
	xMsg2679.PT		   := T#0s;
	xMsg2679.Prio	   := 4;
	xMsg2679.RiskClass := 4;
	xMsg2679.Reset	   := FALSE;
	xMsg2679();
	MM2VIS.bMsg2679	   := xMsg2679.Q;

	(* W2680 Temperature engine cooling water module inlet  signal failure *)
	xMsg2680.Enable	   := Para.bT_ECW_Mod_In_Active;
	xMsg2680.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_ECW_Mod_In.GoodQual;
	xMsg2680.PT		   := T#0s;
	xMsg2680.Prio	   := 4;
	xMsg2680.RiskClass := 4;
	xMsg2680.Reset	   := FALSE;
	xMsg2680();
	MM2VIS.bMsg2680	   := xMsg2680.Q;

	(* W2681 Temperature engine cooling water module outlet  signal failure *)
	xMsg2681.Enable	   := Para.bT_ECW_Mod_Out_Active;
	xMsg2681.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_ECW_Mod_Out.GoodQual;
	xMsg2681.PT		   := T#0s;
	xMsg2681.Prio	   := 4;
	xMsg2681.RiskClass := 4;
	xMsg2681.Reset	   := FALSE;
	xMsg2681();
	MM2VIS.bMsg2681	   := xMsg2681.Q;

	(* W2682 Temperature oil module oil inlet signal failure *)
	xMsg2682.Enable	   := Para.bT_EO_Mod_In_Active;
	xMsg2682.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_EO_Mod_In.GoodQual;
	xMsg2682.PT		   := T#0s;
	xMsg2682.Prio	   := 4;
	xMsg2682.RiskClass := 4;
	xMsg2682.Reset	   := FALSE;
	xMsg2682();
	MM2VIS.bMsg2682	   := xMsg2682.Q;

	(* W2683 Temperature oil module oil outlet  signal failure *)
	xMsg2683.Enable	   := Para.bT_EO_Mod_Out_Active;
	xMsg2683.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_EO_Mod_Out.GoodQual;
	xMsg2683.PT		   := T#0s;
	xMsg2683.Prio	   := 4;
	xMsg2683.RiskClass := 4;
	xMsg2683.Reset	   := FALSE;
	xMsg2683();
	MM2VIS.bMsg2683	   := xMsg2683.Q;

	(* W2684 Temperature heat water supply hydraulic engine cooling water preheating signal failure *)
	xMsg2684.Enable	   := Para.bT_HW_Su_PreH_ECW_Active;
	xMsg2684.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_HW_Su_PreH_ECW.GoodQual;
	xMsg2684.PT		   := T#0s;
	xMsg2684.Prio	   := 4;
	xMsg2684.RiskClass := 4;
	xMsg2684.Reset	   := FALSE;
	xMsg2684();
	MM2VIS.bMsg2684	   := xMsg2684.Q;
	OUT_HC.bMsg2684    := xMsg2684.Q;

	(* W2685 Temperature heat water return hydraulic engine cooling water preheating signal failure *)
	xMsg2685.Enable	   := Para.bT_HW_Re_PreH_ECW_Active;
	xMsg2685.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_HW_Re_PreH_ECW.GoodQual;
	xMsg2685.PT		   := T#0s;
	xMsg2685.Prio	   := 4;
	xMsg2685.RiskClass := 4;
	xMsg2685.Reset	   := FALSE;
	xMsg2685();
	MM2VIS.bMsg2685	   := xMsg2685.Q;

	(* W2686 Temperature heat water supply hydraulic oil preheating signal failure *)
	xMsg2686.Enable	   := Para.bT_HW_Su_PreH_EO_Active;
	xMsg2686.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_HW_Su_PreH_EO.GoodQual;
	xMsg2686.PT		   := T#0s;
	xMsg2686.Prio	   := 4;
	xMsg2686.RiskClass := 4;
	xMsg2686.Reset	   := FALSE;
	xMsg2686();
	MM2VIS.bMsg2686	   := xMsg2686.Q;

	(* W2687 Temperature heat water return hydraulic oil preheating signal failure *)
	xMsg2687.Enable	   := Para.bT_HW_Re_PreH_EO_Active;
	xMsg2687.Set       := IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_HW_Re_PreH_EO.GoodQual;
	xMsg2687.PT		   := T#0s;
	xMsg2687.Prio	   := 4;
	xMsg2687.RiskClass := 4;
	xMsg2687.Reset	   := FALSE;
	xMsg2687();
	MM2VIS.bMsg2687	   := xMsg2687.Q;
	
	(* W2710 measuring signal failure position control valve heat water return temperature *)
	xMsg2710.Enable		:=	Para.bPos_HW_ReValve;
	xMsg2710.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPos_HW_ReValve.GoodQual;
	xMsg2710.PT			:=	T#0s;
	xMsg2710.Prio		:=	4;
	xMsg2710.RiskClass	:=	4;	
	xMsg2710.Reset		:=	FALSE;
	xMsg2710();
	MM2VIS.bMsg2710     := xMsg2710.Q;
	
	(* W2711 measuring signal failure position control valve heat water return temperature after cooler *)
	xMsg2711.Enable		:=	Para.bPos_HW_EC_ReValve;
	xMsg2711.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPos_HW_EC_ReValve.GoodQual;
	xMsg2711.PT			:=	T#0s;
	xMsg2711.Prio		:=	4;
	xMsg2711.RiskClass	:=	4;	
	xMsg2711.Reset		:=	FALSE;
	xMsg2711();
	MM2VIS.bMsg2711     := xMsg2711.Q;
	
	(* W2712 measuring signal failure position control valve charge cooler circuit temperature *)
	xMsg2712.Enable		:=	Para.bPos_ChCValve;
	xMsg2712.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPos_ChC_Valve.GoodQual;
	xMsg2712.PT			:=	T#0s;
	xMsg2712.Prio		:=	4;
	xMsg2712.RiskClass	:=	4;	
	xMsg2712.Reset		:=	FALSE;
	xMsg2712();
	MM2VIS.bMsg2712     := xMsg2712.Q;
	
	(* W2713 measuring signal failure supply water temperature primary circuit *)
	xMsg2713.Enable		:=	Para.bT_Su_PriCirc_Active;
	xMsg2713.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_Su_PriCirc.GoodQual;
	xMsg2713.PT			:=	T#0s;
	xMsg2713.Prio		:=	4;
	xMsg2713.RiskClass	:=	4;	
	xMsg2713.Reset		:=	FALSE;
	xMsg2713();
	MM2VIS.bMsg2713     := xMsg2713.Q;
	
	(* W2714 measuring signal failure return water temperature primary circuit *)
	xMsg2714.Enable		:=	Para.bT_Re_PriCirc_Active;
	xMsg2714.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_Re_PriCirc.GoodQual;
	xMsg2714.PT			:=	T#0s;
	xMsg2714.Prio		:=	4;
	xMsg2714.RiskClass	:=	4;	
	xMsg2714.Reset		:=	FALSE;
	xMsg2714();
	MM2VIS.bMsg2714     := xMsg2714.Q;
	
	(* W2715 measuring signal failure supply water temperature secondary circuit *)
	xMsg2715.Enable		:=	Para.bT_Su_SecCirc_Active;
	xMsg2715.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_Su_SecCirc.GoodQual;
	xMsg2715.PT			:=	T#0s;
	xMsg2715.Prio		:=	4;
	xMsg2715.RiskClass	:=	4;	
	xMsg2715.Reset		:=	FALSE;
	xMsg2715();
	MM2VIS.bMsg2715     := xMsg2715.Q;
	
	(* W2716 measuring signal failure return water temperature secondary circuit *)
	xMsg2716.Enable		:=	Para.bT_Re_SecCirc_Active;
	xMsg2716.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_Re_SecCirc.GoodQual;
	xMsg2716.PT			:=	T#0s;
	xMsg2716.Prio		:=	4;
	xMsg2716.RiskClass	:=	4;	
	xMsg2716.Reset		:=	FALSE;
	xMsg2716();
	MM2VIS.bMsg2716     := xMsg2716.Q;
	
	(* W2717 supply water temperature high primary circuit *)
	xGRMAX_T_Su_PriCirc(In:= IN_HC.tT_Su_PriCirc.Ai, Gw:= Para.rT_Su_PriCirc_LimHi, Hy:= Para.rT_Su_PriCirc_HyLimHi);
	bT_Su_PriCirc_Hi := xGRMAX_T_Su_PriCirc.Q;
	
	xMsg2717.Enable		:=	Para.bT_Su_PriCirc_Active;
	xMsg2717.Set 		:= 	bT_Su_PriCirc_Hi AND NOT MM2VIS.bMsg2713;
	xMsg2717.PT			:=	T#0s;
	xMsg2717.Prio		:=	4;
	xMsg2717.RiskClass	:=	4;	
	xMsg2717.Reset		:=	FALSE;
	xMsg2717();
	MM2VIS.bMsg2717     := xMsg2717.Q;
	
	(* W2718 return water temperature high primary circuit *)
	xGRMAX_T_Re_PriCirc(In:= IN_HC.tT_Re_PriCirc.Ai, Gw:= Para.rT_Re_PriCirc_LimHi, Hy:= Para.rT_Re_PriCirc_HyLimHi);
	bT_Re_PriCirc_Hi := xGRMAX_T_Re_PriCirc.Q;
	
	xMsg2718.Enable		:=	Para.bT_Re_PriCirc_Active;
	xMsg2718.Set 		:= 	bT_Re_PriCirc_Hi AND NOT MM2VIS.bMsg2714;
	xMsg2718.PT			:=	T#0s;
	xMsg2718.Prio		:=	4;
	xMsg2718.RiskClass	:=	4;	
	xMsg2718.Reset		:=	FALSE;
	xMsg2718();
	MM2VIS.bMsg2718     := xMsg2718.Q;
	
	(* W2719 supply water temperature high secondary circuit *)
	xGRMAX_T_Su_SecCirc(In:= IN_HC.tT_Su_SecCirc.Ai, Gw:= Para.rT_Su_SecCirc_LimHi, Hy:= Para.rT_Su_SecCirc_HyLimHi);
	bT_Su_SecCirc_Hi := xGRMAX_T_Su_SecCirc.Q;
	
	xMsg2719.Enable		:=	Para.bT_Su_SecCirc_Active;
	xMsg2719.Set 		:= 	bT_Su_SecCirc_Hi AND NOT MM2VIS.bMsg2715;
	xMsg2719.PT			:=	T#0s;
	xMsg2719.Prio		:=	4;
	xMsg2719.RiskClass	:=	4;	
	xMsg2719.Reset		:=	FALSE;
	xMsg2719();
	MM2VIS.bMsg2719     := xMsg2719.Q;
	
	(* W2720 return water temperature high secondary circuit *)
	xGRMAX_T_Re_SecCirc(In:= IN_HC.tT_Re_SecCirc.Ai, Gw:= Para.rT_Re_SecCirc_LimHi, Hy:= Para.rT_Re_SecCirc_HyLimHi);
	bT_Re_SecCirc_Hi := xGRMAX_T_Re_SecCirc.Q;
	
	xMsg2720.Enable		:=	Para.bT_Re_SecCirc_Active; 
	xMsg2720.Set 		:= 	bT_Re_SecCirc_Hi AND NOT MM2VIS.bMsg2716;
	xMsg2720.PT			:=	T#0s;
	xMsg2720.Prio		:=	4;
	xMsg2720.RiskClass	:=	4;	
	xMsg2720.Reset		:=	FALSE;
	xMsg2720();
	MM2VIS.bMsg2720     := xMsg2720.Q;
	
	(* W2721 measuring signal failure heating power engine heat water circuit *)
	xMsg2721.Enable		:=	Para.bP_Heat_Active;
	xMsg2721.Set 		:= 	NOT IN_HC.tP_Heat.GoodQual;
	xMsg2721.PT			:=	T#0s;
	xMsg2721.Prio		:=	4;
	xMsg2721.RiskClass	:=	4;	
	xMsg2721.Reset		:=	FALSE;
	xMsg2721();
	MM2VIS.bMsg2721     := xMsg2721.Q;
		
	(* W2731 measuring signal failure condensor circuit supply temperature *)
	xMsg2731.Enable		:=	Para.bT_CD_Su_Active;
	xMsg2731.Set 		:= 	NOT IN_HC.tT_CD_Su.GoodQual;
	xMsg2731.PT			:=	T#0s;
	xMsg2731.Prio		:=	4;
	xMsg2731.RiskClass	:=	4;	
	xMsg2731.Reset		:=	FALSE;
	xMsg2731();
	MM2VIS.bMsg2731     := xMsg2731.Q;
	
	(* W2732 supply temperature condensor circuit maximum *)
	xMsg2732.Enable		:=	Para.bT_CD_Su_Active;
	xMsg2732.Set 		:= 	bT_CD_Su_Hi AND NOT MM2VIS.bMsg2731;
	xMsg2732.PT			:=	T#2s;
	xMsg2732.Prio		:=	4;
	xMsg2732.RiskClass	:=	4;	
	xMsg2732.Reset		:=	FALSE;
	xMsg2732();
	MM2VIS.bMsg2732     := xMsg2732.Q;
	

	(* W2733 measuring signal failure return temperature condensor circuit *)
	xMsg2733.Enable		:=	Para.bT_CD_Re_Active;
	xMsg2733.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_CD_Re.GoodQual;
	xMsg2733.PT			:=	T#0s;
	xMsg2733.Prio		:=	4;
	xMsg2733.RiskClass	:=	4;	
	xMsg2733.Reset		:=	FALSE;
	xMsg2733();
	MM2VIS.bMsg2733     := xMsg2733.Q;
	

	(* W2734 return temperature condensor circuit maximum *)
	xMsg2734.Enable		:=	Para.bT_CD_Re_Active;
	xMsg2734.Set 		:= 	bT_CD_Re_Hi AND NOT MM2VIS.bMsg2733;
	xMsg2734.PT			:=	T#2s;
	xMsg2734.Prio		:=	4;
	xMsg2734.RiskClass	:=	4;	
	xMsg2734.Reset		:=	FALSE;
	xMsg2734();
	MM2VIS.bMsg2734     := xMsg2734.Q;
	

	(* W2735 failure condensor pump *)
	xTOF_CDP_Fail(IN:= IN_HC.tCDP_Op.Di OR bNoMon4BlackStart, PT:= T#10s);
	HBT_1 := xTOF_CDP_Fail.Q OR (IN_HC.tCDP_Dem.Do AND HBT_1);
	xTON_CDP_Fail(IN:= IN_HC.tCDP_Dem.Do, PT:= T#175s);

	xMsg2735.Enable		:=	TRUE;
	xMsg2735.Set 		:= 	(xTON_CDP_Fail.Q OR HBT_1) AND NOT xTOF_CDP_Fail.Q;
	xMsg2735.PT			:=	T#0s;
	xMsg2735.Prio		:=	4;
	xMsg2735.RiskClass	:=	4;	
	xMsg2735.Reset		:=	FALSE;
	xMsg2735();
	MM2VIS.bMsg2735     := xMsg2735.Q;
	

	(* W2736 failure boiler house ventilation*)
	xMsg2736.Enable		:=	TRUE;
	xMsg2736.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND bFail_BHV;
	xMsg2736.PT			:=	T#2s;
	xMsg2736.Prio		:=	4;
	xMsg2736.RiskClass	:=	4;	
	xMsg2736.Reset		:=	FALSE;
	xMsg2736();
	MM2VIS.bMsg2736     := xMsg2736.Q;
	

	(* W2750 failure heating circuit flap *)
	xMsg2750.Enable		:=	TRUE;
	xMsg2750.Set 		:= 	NOT IN_HC.tHWF_Fail.Di;
	xMsg2750.PT			:=	T#0s;
	xMsg2750.Prio		:=	4;
	xMsg2750.RiskClass	:=	4;	
	xMsg2750.Reset		:=	FALSE;
	xMsg2750();
	MM2VIS.bMsg2750     := xMsg2750.Q;
	

	(* W2751 heat circuit return temperature high *)
	xMsg2751.Enable		:=	TRUE;
	xMsg2751.Set 		:= 	bT_HW_HC_Re_Hi AND NOT MM2VIS.bMsg2752;
	xMsg2751.PT			:=	T#2s;
	xMsg2751.Prio		:=	4;
	xMsg2751.RiskClass	:=	4;	
	xMsg2751.Reset		:=	FALSE;
	xMsg2751();
	MM2VIS.bMsg2751     := xMsg2751.Q;
	
	
	(* W2752 signal failur heat circuit return temperature *)
	xMsg2752.Enable		:=	Para.bT_HW_HC_Re_Active;
	xMsg2752.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_HW_HC_Re.GoodQual;
	xMsg2752.PT			:=	T#0s;
	xMsg2752.Prio		:=	4;
	xMsg2752.RiskClass	:=	4;	
	xMsg2752.Reset		:=	FALSE;
	xMsg2752();
	MM2VIS.bMsg2752     := xMsg2752.Q;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* W2763 plausibility check measuring signal engine cooling water pressure (Functional Safety) *)
	xMsg2763.Enable		:=	IN_HC.tPB2MM.bSys_Run;
	xMsg2763.Set 		:= 	bPr_ECW_PcheckFail;
	xMsg2763.PT			:=	T#0s;
	xMsg2763.Prio		:=	4;
	xMsg2763.RiskClass	:=	4;	
	xMsg2763.Reset		:=	FALSE;
	xMsg2763();
	MM2VIS.bMsg2763     := xMsg2763.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	(* W3220 engine cooling water temperature high *)
	xMsg3220.Enable		:=	TRUE;
	xMsg3220.Set		:=	OUT_HC.bT_ECW_Hi AND xTON_EngRunAnd60s.Q AND NOT MM2VIS.bMsg1021 AND NOT MM2VIS.bMsg2101;
	xMsg3220.PT			:=	T#0s;
	xMsg3220.Prio		:=	4;
	xMsg3220.RiskClass	:=	4;	
	xMsg3220.Reset		:=	FALSE;
	xMsg3220();
	MM2VIS.bMsg3220     := xMsg3220.Q;


	(* A3303 charge cooling water temperature high *)
	(*       temperature heat water return - low temp circuit *)
	xMsg3303.Enable		:=	FALSE;
	xMsg3303.Set 		:=	FALSE; 	(* actual not used *)
	xMsg3303.PT			:=	T#0s;
	xMsg3303.Prio		:=	3;
	xMsg3303.RiskClass	:=	4;	
	xMsg3303.Reset		:=	FALSE;
	xMsg3303();
	MM2VIS.bMsg3303     := xMsg3303.Q;

	
	(* A3312 heat water return temperature after dump radiator signal failure trip (W3508)*)
	xMsg3312.Enable		:=	Para.bT_HW_ReAfEC_Active AND Para.bT_HW_ReAfEC_SF_Trip;
	xMsg3312.Set 		:=  NOT IN_HC.tT_HW_ReAfEC.GoodQual;
	xMsg3312.PT			:=	T#0s;
	xMsg3312.Prio		:=	3;
	xMsg3312.RiskClass	:=	4;	
	xMsg3312.Reset		:=	FALSE;
	xMsg3312();
	MM2VIS.bMsg3312     := xMsg3312.Q;


	(* A3321 heat water return temperature before engine signal failure (W3526)*)
	xMsg3321.Enable		:=	Para.bT_HW_ReBeEng_Active AND Para.bT_HW_ReBeEng_SF_Trip;
	xMsg3321.Set 		:=  NOT IN_HC.tT_HW_ReBeEng.GoodQual;
	xMsg3321.PT			:=	T#0s;
	xMsg3321.Prio		:=	3;
	xMsg3321.RiskClass	:=	4;	
	xMsg3321.Reset		:=	FALSE;
	xMsg3321();
	MM2VIS.bMsg3321     := xMsg3321.Q;


	(* W3402 engine cooling water pressure low *)
	xMsg3402.Enable		:=	TRUE;
	xMsg3402.Set		:=	(bPr_ECW_LimOp AND IN_HC.tT_ECW.Ai > 80.0) OR bPr_ECW_Lo AND NOT MM2VIS.bMsg1019;
	xMsg3402.PT			:=	T#0s;
	xMsg3402.Prio		:=	4;
	xMsg3402.RiskClass	:=	4;	
	xMsg3402.Reset		:=	FALSE;
	xMsg3402();
	MM2VIS.bMsg3402     := xMsg3402.Q;


	(* W3404 water pressure cooler circuit low *)
	xMsg3404.Enable		:=	TRUE;
	xMsg3404.Set		:=	NOT IN_HC.tPr_CCircuit_Lo.Di;
	xMsg3404.PT			:=	T#10s;
	xMsg3404.Prio		:=	4;
	xMsg3404.RiskClass	:=	4;	
	xMsg3404.Reset		:=	FALSE;
	xMsg3404();
	MM2VIS.bMsg3404     := xMsg3404.Q;
	OUT_HC.bMsg3404		:= xMsg3404.Q;


	(* W3406 engine cooling water pressure high *)
	xTP_3406(IN:= bN_EngStart, PT:= T#20s);

	xMsg3406.Enable		:=	TRUE;
	xMsg3406.Set 		:=  bPr_ECW_Hi AND NOT xTP_3406.Q;
	xMsg3406.PT			:=	T#0s;
	xMsg3406.Prio		:=	4;
	xMsg3406.RiskClass	:=	4;	
	xMsg3406.Reset		:=	FALSE;
	xMsg3406();
	MM2VIS.bMsg3406     := xMsg3406.Q;


	(* W3407 outdoor temperature measuring signal failure *)
	xMsg3407.Enable		:=	Para.bT_AirOutdoor_Active AND IN_HC.tPB2MM.bParaSetupOk;			
	xMsg3407.Set		:=	NOT IN_HC.tT_AirOutdoor.GoodQual;
	xMsg3407.PT			:=	T#0s;			
	xMsg3407.Prio		:=	4;				
	xMsg3407.RiskClass	:=	4;
	xMsg3407.Reset		:=	FALSE;
	xMsg3407();
	MM2VIS.bMsg3407		:=	xMsg3407.Q;


	(* W3492 temperature engine cooling water before charge cooler signal failure  *)
	xMsg3492.Enable		:=	Para.bT_ECW_bChC_HT_Active;			
	xMsg3492.Set		:=	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_ECW_bChC_HT.GoodQual;
	xMsg3492.PT			:=	T#0s;			
	xMsg3492.Prio		:=	4;				
	xMsg3492.RiskClass	:=	4;
	xMsg3492.Reset		:=	FALSE;
	xMsg3492();
	MM2VIS.bMsg3492		:=	xMsg3492.Q;


	(* W3493 temperature engine cooling water before oil cooler signal failure *)
	xMsg3493.Enable		:=	Para.bT_ECW_bOilC_Active;			
	xMsg3493.Set		:=	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_ECW_bOilC.GoodQual;
	xMsg3493.PT			:=	T#0s;			
	xMsg3493.Prio		:=	4;				
	xMsg3493.RiskClass	:=	4;
	xMsg3493.Reset		:=	FALSE;
	xMsg3493();
	MM2VIS.bMsg3493		:=	xMsg3493.Q;


	(* W3494 temperature engine cooling water before engine cooling water cooler signal failure  *)
	xMsg3494.Enable		:=	Para.bT_ECW_bECWC_Active;			
	xMsg3494.Set		:=	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_ECW_bECWC.GoodQual;
	xMsg3494.PT			:=	T#0s;			
	xMsg3494.Prio		:=	4;				
	xMsg3494.RiskClass	:=	4;
	xMsg3494.Reset		:=	FALSE;
	xMsg3494();
	MM2VIS.bMsg3494		:=	xMsg3494.Q;


	(* W3508 heat water return temperature after dump radiator signal failure (A3312)*)
	xMsg3508.Enable		:=	Para.bT_HW_ReAfEC_Active AND NOT Para.bT_HW_ReAfEC_SF_Trip AND IN_HC.tPB2MM.bParaSetupOk;
	xMsg3508.Set 		:=  NOT IN_HC.tT_HW_ReAfEC.GoodQual;
	xMsg3508.PT			:=	T#0s;
	xMsg3508.Prio		:=	4;
	xMsg3508.RiskClass	:=	4;	
	xMsg3508.Reset		:=	FALSE;
	xMsg3508();
	MM2VIS.bMsg3508     := xMsg3508.Q;


	(* W3509 heat water return temperature after dump radiator high *)
	xMsg3509.Enable		:=	Para.bT_HW_ReAfEC_Active;	
	xMsg3509.Set 		:=	bT_HW_ReAfEC_Hi AND NOT MM2VIS.bMsg3508 AND NOT MM2VIS.bMsg3312;
	xMsg3509.PT			:=	T#0s;
	xMsg3509.Prio		:=	4;
	xMsg3509.RiskClass	:=	4;	
	xMsg3509.Reset		:=	FALSE;
	xMsg3509();
	MM2VIS.bMsg3509     := xMsg3509.Q;


	(* W3521 charge cooling water temperature high *)
	xGRMAX_T_HW_Re_LT_Hi(In:= IN_HC.tT_HW_Re_LT.Ai, Gw:= Para.rT_HW_Re_LT_LimHi, Hy:= Para.rT_HW_Re_LT_HyHi);
	xTON_3521(IN:= (xGRMAX_T_HW_Re_LT_Hi.Q AND Para.bT_HW_Re_LT_Active AND NOT xMsg3590.Q) OR NOT IN_HC.tT_ChCW_Hi.Di, PT:= T#10s);

	xMsg3521.Enable		:=	TRUE;
	xMsg3521.Set 		:=  xTON_3521.Q AND xTON_EngRunAnd10s.Q;
	xMsg3521.PT			:=	T#0s;
	xMsg3521.Prio		:=	4;
	xMsg3521.RiskClass	:=	4;	
	xMsg3521.Reset		:=	FALSE;
	xMsg3521();
	MM2VIS.bMsg3521     := xMsg3521.Q;


	(* W3526 heating water return temperature before engine signal failure (A3321)*)
	xMsg3526.Enable		:=	Para.bT_HW_ReBeEng_Active AND NOT Para.bT_HW_ReBeEng_SF_Trip AND IN_HC.tPB2MM.bParaSetupOk;
	xMsg3526.Set 		:=  NOT IN_HC.tT_HW_ReBeEng.GoodQual;
	xMsg3526.PT			:=	T#0s;
	xMsg3526.Prio		:=	4;
	xMsg3526.RiskClass	:=	4;	
	xMsg3526.Reset		:=	FALSE;
	xMsg3526();
	MM2VIS.bMsg3526     := xMsg3526.Q;


	(* W3527 heating water return temperature before engine high *)
	xTON_3527(IN:= bT_HW_ReBeEng_Hi AND IN_HC.tT_HW_ReBeEng.GoodQual, PT:= T#10s);

	xMsg3527.Enable		:=	Para.bT_HW_ReBeEng_Active;
	xMsg3527.Set 		:=  xTON_EngRunAnd10s.Q AND xTON_3527.Q;
	xMsg3527.PT			:=	T#0s;
	xMsg3527.Prio		:=	4;
	xMsg3527.RiskClass	:=	4;	
	xMsg3527.Reset		:=	FALSE;
	xMsg3527();
	MM2VIS.bMsg3527     := xMsg3527.Q;
	

	(* W3590 signal failure charge cooling water temperature - low temp circuit *)
	(*       temperature heat water return - low temp circuit *)
	xMsg3590.Enable		:=	Para.bT_HW_Re_LT_Active AND IN_HC.tPB2MM.bParaSetupOk;
	xMsg3590.Set 		:=  NOT IN_HC.tT_HW_Re_LT.GoodQual;
	xMsg3590.PT			:=	T#0s;
	xMsg3590.Prio		:=	4;
	xMsg3590.RiskClass	:=	4;	
	xMsg3590.Reset		:=	FALSE;
	xMsg3590();
	MM2VIS.bMsg3590     := xMsg3590.Q;


	(* W9226 Charge cooler 2 water pressure low *)
	xMsg9226.Enable		:=	TRUE;
	xMsg9226.Set		:=	NOT IN_HC.tPr_ChC2_Lo.Di;
	xMsg9226.PT			:=	T#10s;
	xMsg9226.Prio		:=	4;
	xMsg9226.RiskClass	:=	4;	
	xMsg9226.Reset		:=	FALSE;
	xMsg9226();
	MM2VIS.bMsg9226     := xMsg9226.Q;
	OUT_HC.bMsg9226     := xMsg9226.Q;


	(* W9228 Charge cooler 2 failure *)
	xTON_ChC2_FanRdy(IN:= (IN_HC.tAuxV_Supply_Ok.Di AND IN_HC.tAuxV_Aux_ok.Di) AND NOT IN_HC.tChC2_FanRdy.Di, PT:= T#10s);

	xMsg9228.Enable		:=	TRUE;
	xMsg9228.Set		:=	NOT bNoMon4BlackStart AND(xTON_ChC2_FanRdy.Q OR NOT IN_HC.tChC2_Failure.Di);
	xMsg9228.PT			:=	T#0s;
	xMsg9228.Prio		:=	4;
	xMsg9228.RiskClass	:=	4;	
	xMsg9228.Reset		:=	FALSE;
	xMsg9228();
	MM2VIS.bMsg9228     := xMsg9228.Q;

	
	(* W9229 Charge cooler 2 water temperature high *)
	xGRMAX_T_ChC2_Re_LT_Hi(In:= IN_HC.tT_ChC2_Re_LT.Ai, Gw:= Para.rT_ChC2_Re_LT_LimHi, Hy:= Para.rT_ChC2_Re_LT_HyHi);
	xTON_9229(IN:= (xGRMAX_T_ChC2_Re_LT_Hi.Q AND Para.bT_ChC2_Re_LT_Active AND NOT xMsg9232.Q) OR NOT IN_HC.tT_ChC2W_Hi.Di, PT:= T#10s);

	xMsg9229.Enable		:=	TRUE;
	xMsg9229.Set 		:=  xTON_9229.Q AND xTON_EngRunAnd10s.Q;
	xMsg9229.PT			:=	T#0s;
	xMsg9229.Prio		:=	4;
	xMsg9229.RiskClass	:=	4;	
	xMsg9229.Reset		:=	FALSE;
	xMsg9229();
	MM2VIS.bMsg9229     := xMsg9229.Q;


	(* W9230 Measuring signal failure position temperature-control-valve charge cooler 2 circuit *)
	xMsg9230.Enable		:=	Para.bPos_ChC2_Valve;
	xMsg9230.Set 		:= 	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tPos_ChC2_Valve.GoodQual;
	xMsg9230.PT			:=	T#0s;
	xMsg9230.Prio		:=	4;
	xMsg9230.RiskClass	:=	4;	
	xMsg9230.Reset		:=	FALSE;
	xMsg9230();
	MM2VIS.bMsg9230     := xMsg9230.Q;


	(* W9231 Measuring signal failure supply water temperature charge cooler 2 circuit *)
	xMsg9231.Enable		:=	Para.bT_ChC2_Su_LT_Active;
	xMsg9231.Set		:=	IN_HC.tPB2MM.bParaSetupOk AND NOT IN_HC.tT_ChC2_Su_LT.GoodQual;
	xMsg9231.PT			:=	T#0s;
	xMsg9231.Prio		:=	4;
	xMsg9231.RiskClass	:=	4;	
	xMsg9231.Reset		:=	FALSE;
	xMsg9231();
	MM2VIS.bMsg9231     := xMsg9231.Q;


	(* W9232 Measuring signal failure return water temperature charge cooler 2 circuit *)
	(*       return temperature - 2nd low temp circuit *)
	xMsg9232.Enable		:=	Para.bT_ChC2_Re_LT_Active AND IN_HC.tPB2MM.bParaSetupOk;
	xMsg9232.Set 		:=  NOT IN_HC.tT_ChC2_Re_LT.GoodQual;
	xMsg9232.PT			:=	T#0s;
	xMsg9232.Prio		:=	4;
	xMsg9232.RiskClass	:=	4;	
	xMsg9232.Reset		:=	FALSE;
	xMsg9232();
	MM2VIS.bMsg9232     := xMsg9232.Q;

	
	(* W9588 Heating water supply temperature unit maximum *)						(* SAFETY PLC *)
	xMsg9588.Enable	   	:= Para.bT_HW_Su_Unit_Active;
	xMsg9588.Set	  	:= IN_HC.tT_HW_Su_Unit.Ai > Para.rT_HW_Su_Unit_LimHi;			
	xMsg9588.PT	       	:= T#0s;			
	xMsg9588.Prio	   	:= 4;			
	xMsg9588.RiskClass	:= 4;				
	xMsg9588.Reset	   	:= FALSE;			
	xMsg9588();						
	MM2VIS.bMsg9588		:= xMsg9588.Q;			

							
	(* W9589 Heating water supply temperature unit measuring signal failure *)		(* SAFETY PLC *)
	xMsg9589.Enable	   	:= Para.bT_HW_Su_Unit_Active;
	xMsg9589.Set	  	:= NOT IN_HC.tT_HW_Su_Unit.GoodQual;			
	xMsg9589.PT	       	:= T#0s;			
	xMsg9589.Prio	   	:= 4;			
	xMsg9589.RiskClass	:= 4;				
	xMsg9589.Reset	   	:= FALSE;			
	xMsg9589();						
	MM2VIS.bMsg9589		:= xMsg9589.Q;			


	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)
	(* B9098 Valve heating in operation *)
	xMsg9098.Enable		:=	bValHeater_Dem_Exist;
	xMsg9098.Set		:= 	OUT_HC.tValHeater_Dem.Do;	
	xMsg9098.Reset		:=	TRUE;
	xMsg9098();
	MM2VIS.bMsg9098		:=	xMsg9098.Q;

	(* B9099 Ring heater for cooling fan in operation *)
	xMsg9099.Enable		:=	bFanRingHeater_Dem_Exist;
	xMsg9099.Set		:= 	OUT_HC.tFanRingHeater_Dem.Do;	
	xMsg9099.Reset		:=	TRUE;
	xMsg9099();
	MM2VIS.bMsg9099		:=	xMsg9099.Q;

	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1   := OUT_HC.tHC2AB.bGnlTrip1   OR IN_HC.tAB2HC.bGnlTrip1;
	bGnlTrip2   := OUT_HC.tHC2AB.bGnlTrip2   OR IN_HC.tAB2HC.bGnlTrip2;
	bGnlTrip3   := OUT_HC.tHC2AB.bGnlTrip3   OR IN_HC.tAB2HC.bGnlTrip3;
	bGnlWarning := OUT_HC.tHC2AB.bGnlWarning OR IN_HC.tAB2HC.bGnlWarning;

	bGnlTrip    := bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
(*******************************************************************************)
END_PROGRAM
