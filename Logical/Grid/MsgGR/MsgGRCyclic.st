(*******************************************************************************
Msg_GR	 			 alarms generation MM_Grid

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V0.01.0	02.11.2011	lettenb.	new
		27.05.2013	lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
V4.00.0 22-08-2013  Maxhera,    implementation of the module for modular software
		04.03.2014	lettenb.	logger added
		16.06.2015	caks,		clean up
V4.03.0	15-12-2015	Perktold,	Reset fuer alle Warnungen auf TRUE gesetzt + ERDF Meldungen implementiert
								B2812 geaendert fuer HAND Betrieb
V4.03.1	13-06-2016	Gwiggner	Hinzufuegen CustAnaIn[2].Goodqual zu A3385 measuring signal failure P0
V4.04.0	06-10-2016	Perktold	W2799 added changed ERDF to DEIE
V4.04.1	29-03-2017	Gwiggner	add operational messages 2171 and 2172 for frequency control function
V4.05.0 07-12-2017  Farre,		addition op messages from 2940 to 2955 for P and Q functionalities
V4.07.0 28-05-2019	Zuschnig, 	Added A2331, W9261 - W9274 and B3000 B9008 - 9023   
V4.10.0	28-09-2020	Zuschnig, 	Changed A2331 logic - NC contact is used
		12.11.2020	lettenb.	2344,2345 added(G99)
V4.11.0	17.01.2022	lettenb.	2812 IN_GR.bEng_Block_EVU added, bugfix
V4.13.0	28.11.2023	Farre,		Enable/disable messages for ILF are added (9093 & 9094)
					Goenczi		2344,2345 Block via BUS added
V4.14.0	17.10.2024	Theobald	Alarm2331 priority changed from 2 to 3 [2024-223]
												
Instructions for use:
--------------------
1) declare alarm with function block "Alm"
	declare buffert alarm bit bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	


3)  expand INIT

3)	include datapoint into OPC configuration for vis

			
Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC	
	(* reset general trip *)
	OUT_GR.tGR2AB.bGnlTrip1		:=	FALSE;
	OUT_GR.tGR2AB.bGnlTrip2		:=	FALSE;
	OUT_GR.tGR2AB.bGnlTrip3		:=	FALSE;
	OUT_GR.tGR2AB.bGnlWarning	:=	FALSE;
	OUT_GR.tGR2AB.bTriptype1	:=	FALSE;
	OUT_GR.tGR2AB.bTriptype2	:=	FALSE;
	OUT_GR.tGR2AB.bTriptype3	:=	FALSE;	

	(*---------------------------------------------------------------------------*)
	(* Trips > AMM *)

	(* A2344 module blocked from grid operator - shutdown *)
	xMsg2344.Enable	   := TRUE;
	xMsg2344.Set	   := IN_GR.tDem_EU_Block2.Di OR IN_GR.bDem_EU_Block2_Bus;
	xMsg2344.PT	   	   := T#0s;
	xMsg2344.Prio 	   := 2;
	xMsg2344.RiskClass := 4;
	xMsg2344.Reset	   := NOT Para.bEU_BlockResetMan; (* autoreset *)
	xMsg2344();
	MM2VIS.bMsg2344    := xMsg2344.Q;
	OUT_GR.tEU_RM_BLOCK2.Do := xMsg2344.Q;

	(* A2345 module blocked from grid operator - demand off *)
	xMsg2345.Enable	   := TRUE;
	xMsg2345.Set	   := IN_GR.tDem_EU_Block3.Di OR IN_GR.bDem_EU_Block3_Bus;
	xMsg2345.PT	   	   := T#0s;
	xMsg2345.Prio 	   := 3;
	xMsg2345.RiskClass := 4;
	xMsg2345.Reset	   := NOT Para.bEU_BlockResetMan; (* autoreset *)
	xMsg2345();
	MM2VIS.bMsg2345    := xMsg2345.Q;
	OUT_GR.tEU_RM_BLOCK3.Do := xMsg2345.Q;
	
	(* A3384 DEIE fast decoupling *)
	xMsg3384.Enable	   := Para.bDEIE_Active;
	xMsg3384.Set	   := OUT_GR.bOpAlm_DecQu;
	xMsg3384.PT	       := T#0s;
	xMsg3384.Prio 	   := 2;
	xMsg3384.RiskClass := 4;
	xMsg3384();
	MM2VIS.bMsg3384    := xMsg3384.Q;
	
	(* A3385 measuring signal failure P0 *)
	xMsg3385.Enable	   := Para.bDEIE_Active;
	xMsg3385.Set	   := OUT_GR.bOpAlm_MSF_P0 AND NOT IN_GR.tP_DEIE.GoodQual;
	xMsg3385.PT	       := T#0s;
	xMsg3385.Prio 	   := 3;
	xMsg3385.RiskClass := 4;
	xMsg3385();
	MM2VIS.bMsg3385    := xMsg3385.Q;

	(* A3386 Waiting release for SY DEIE *)
	xMsg3386.Enable	   := Para.bDEIE_Active;
	xMsg3386.Set	   := NOT OUT_GR.bOpAlm_ERDF_SY;
	xMsg3386.Reset	   := IN_GR.tMCB_Rel_Sync.Di;
	xMsg3386.PT	       := T#0s;
	xMsg3386.Prio 	   := 3;
	xMsg3386.RiskClass := 4;
	xMsg3386();
	MM2VIS.bMsg3386    := xMsg3386.Q;

	(* A2331 Surge suppressor has reached critical pressure *)
	IN_GR.tHA2GR.tJunctionBox_GnlAlm.Di := IN_GR.tHA2GR.tJunctionBox_GnlAlm.Di OR NOT IN_GR.tHA2GR.tJunctionBox_GnlAlm.GoodQual;
	xMsg2331.Enable	   := TRUE;
	xMsg2331.Set	   := NOT IN_GR.tHA2GR.tJunctionBox_GnlAlm.Di;
	xMsg2331.Reset	   := FALSE;
	xMsg2331.PT	       := T#0s; 
	xMsg2331.Prio 	   := 3;
	xMsg2331.RiskClass := 4;
	xMsg2331();
	MM2VIS.bMsg2331    := xMsg2331.Q;

	(*---------------------------------------------------------------------------*)
	(* Warnings > AMM *)

	(* W3591 - Power limitation by utility operator measuring signal failure *)
	xMsg3591.Enable	   := TRUE;
	xMsg3591.Set	   := bMsg3591;
	xMsg3591.Reset	   := TRUE;
	xMsg3591.PT	       := T#0s;
	xMsg3591.Prio 	   := 4;
	xMsg3591.RiskClass := 4;
	xMsg3591();
	MM2VIS.bMsg3591    := xMsg3591.Q;
	
	(* W3592 - Power setpoint by utility operator measuring signal failure *)
	xMsg3592.Enable	   := TRUE;
	xMsg3592.Set	   := bMsg3592;
	xMsg3592.Reset	   := TRUE;
	xMsg3592.PT	       := T#0s;
	xMsg3592.Prio 	   := 4;
	xMsg3592.RiskClass := 4;
	xMsg3592();
	MM2VIS.bMsg3592    := xMsg3592.Q;
	
	(* W3593 - Power factor setpoint by utility operator measuring signal failure *)
	xMsg3593.Enable	   := TRUE;
	xMsg3593.Set	   := bMsg3593;
	xMsg3593.Reset	   := TRUE;
	xMsg3593.PT	       := T#0s;
	xMsg3593.Prio 	   := 4;
	xMsg3593.RiskClass := 4;
	xMsg3593();
	MM2VIS.bMsg3593    := xMsg3593.Q;
	
	(* W3594 - Reactive power setpoint by utility operator measuring signal failure *)
	xMsg3594.Enable	   := TRUE;
	xMsg3594.Set	   := bMsg3594;
	xMsg3594.Reset	   := TRUE;
	xMsg3594.PT		   := T#0s;
	xMsg3594.Prio 	   := 4;
	xMsg3594.RiskClass := 4;
	xMsg3594();
	MM2VIS.bMsg3594    := xMsg3594.Q;
	
	(* W3595 - Reactive power limitation by utility operator measuring signal failure *)
	xMsg3595.Enable	   := TRUE;
	xMsg3595.Set	   := bMsg3595;
	xMsg3595.Reset	   := TRUE;
	xMsg3595.PT	   	   := T#0s;
	xMsg3595.Prio 	   := 4;
	xMsg3595.RiskClass := 4;
	xMsg3595();
	MM2VIS.bMsg3595    := xMsg3595.Q;
	
	(* W3596 - Voltage setpoint by utility operator measuring signal failure *)
	xMsg3596.Enable	   := TRUE;
	xMsg3596.Set	   := bMsg3596;
	xMsg3596.Reset	   := TRUE;
	xMsg3596.PT	   	   := T#0s;
	xMsg3596.Prio 	   := 4;
	xMsg3596.RiskClass := 4;
	xMsg3596();
	MM2VIS.bMsg3596    := xMsg3596.Q;

	(* W2799 - P0 DEIE measuring signal failure *)
	xMsg2799.Enable	   := Para.bDEIE_Active;
	xMsg2799.Set	   := NOT IN_GR.tP_DEIE.GoodQual; (*AND NOT IN_GR.tP0_BLOCK_DEIE.Di;*)
	xMsg2799.Reset	   := TRUE;
	xMsg2799.PT	       := T#0s;
	xMsg2799.Prio 	   := 4;
	xMsg2799.RiskClass := 4;
	xMsg2799();
	MM2VIS.bMsg2799    := xMsg2799.Q;

	(* W9261 - Deadband LFSM-O by utility operator measuring signal failure *)
	xMsg9261.Enable	   := TRUE;
	xMsg9261.Set	   := bMsg9261;
	xMsg9261.Reset	   := TRUE;
	xMsg9261.PT	       := T#0s;
	xMsg9261.Prio 	   := 4;
	xMsg9261.RiskClass := 4;
	xMsg9261();
	MM2VIS.bMsg9261    := xMsg9261.Q;

	(* W9262 - Deadband LFSM-U by utility operator measuring signal failure *)
	xMsg9262.Enable	   := TRUE;
	xMsg9262.Set	   := bMsg9262;
	xMsg9262.Reset	   := TRUE;
	xMsg9262.PT	       := T#0s;
	xMsg9262.Prio 	   := 4;
	xMsg9262.RiskClass := 4;
	xMsg9262();
	MM2VIS.bMsg9262    := xMsg9262.Q;

	(* W9263 - Positive droop LFSM-O by utility operator measuring signal failure *)
	xMsg9263.Enable	   := TRUE;
	xMsg9263.Set	   := bMsg9263;
	xMsg9263.Reset	   := TRUE;
	xMsg9263.PT	       := T#0s;
	xMsg9263.Prio 	   := 4;
	xMsg9263.RiskClass := 4;
	xMsg9263();
	MM2VIS.bMsg9263    := xMsg9263.Q;

	(* W9264 - Negative droop LFSM-U by utility operator measuring signal failure *)
	xMsg9264.Enable	   := TRUE;
	xMsg9264.Set	   := bMsg9264;
	xMsg9264.Reset	   := TRUE;
	xMsg9264.PT	       := T#0s;
	xMsg9264.Prio 	   := 4;
	xMsg9264.RiskClass := 4;
	xMsg9264();
	MM2VIS.bMsg9264    := xMsg9264.Q;

	(* W9265 - Droop FSM-U by utility operator measuring signal failure *)
	xMsg9265.Enable	   := TRUE;
	xMsg9265.Set	   := bMsg9265;
	xMsg9265.Reset	   := TRUE;
	xMsg9265.PT	       := T#0s;
	xMsg9265.Prio 	   := 4;
	xMsg9265.RiskClass := 4;
	xMsg9265();
	MM2VIS.bMsg9265    := xMsg9265.Q;

	(* W9266 - Droop FSM-O by utility operator measuring signal failure *)
	xMsg9266.Enable	   := TRUE;
	xMsg9266.Set	   := bMsg9266;
	xMsg9266.Reset	   := TRUE;
	xMsg9266.PT	       := T#0s;
	xMsg9266.Prio 	   := 4;
	xMsg9266.RiskClass := 4;
	xMsg9266();
	MM2VIS.bMsg9266    := xMsg9266.Q;

	(* W9267 - Dead band FSM-U by utility operator measuring signal failure *)
	xMsg9267.Enable	   := TRUE;
	xMsg9267.Set	   := bMsg9267;
	xMsg9267.Reset	   := TRUE;
	xMsg9267.PT	       := T#0s;
	xMsg9267.Prio 	   := 4;
	xMsg9267.RiskClass := 4;
	xMsg9267();
	MM2VIS.bMsg9267    := xMsg9267.Q;

	(* W9268 - Dead band FSM-O by utility operator measuring signal failure *)
	xMsg9268.Enable	   := TRUE;
	xMsg9268.Set	   := bMsg9268;
	xMsg9268.Reset	   := TRUE;
	xMsg9268.PT	   	   := T#0s;
	xMsg9268.Prio 	   := 4;
	xMsg9268.RiskClass := 4;
	xMsg9268();
	MM2VIS.bMsg9268    := xMsg9268.Q;

	(* W9269 - Positive Margin FSM by utility operator measuring signal failure *)
	xMsg9269.Enable	   := TRUE;
	xMsg9269.Set	   := bMsg9269;
	xMsg9269.Reset	   := TRUE;
	xMsg9269.PT	       := T#0s;
	xMsg9269.Prio 	   := 4;
	xMsg9269.RiskClass := 4;
	xMsg9269();
	MM2VIS.bMsg9269    := xMsg9269.Q;

	(* W9270 - Negative Margin FSM by utility operator measuring signal failure *)
	xMsg9270.Enable	   := TRUE;
	xMsg9270.Set	   := bMsg9270;
	xMsg9270.Reset	   := TRUE;
	xMsg9270.PT	       := T#0s;
	xMsg9270.Prio 	   := 4;
	xMsg9270.RiskClass := 4;
	xMsg9270();
	MM2VIS.bMsg9270    := xMsg9270.Q;

	(* W9271 - U droop by utility operator measuring signal failure *)
	xMsg9271.Enable	   := TRUE;
	xMsg9271.Set	   := bMsg9271;
	xMsg9271.Reset	   := TRUE;
	xMsg9271.PT	       := T#0s;
	xMsg9271.Prio 	   := 4;
	xMsg9271.RiskClass := 4;
	xMsg9271();
	MM2VIS.bMsg9271    := xMsg9271.Q;

	(* W9272 - Ramp rate up by utility operator measuring signal failure *)
	xMsg9272.Enable	   := TRUE;
	xMsg9272.Set	   := bMsg9272;
	xMsg9272.Reset	   := TRUE;
	xMsg9272.PT	       := T#0s;
	xMsg9272.Prio 	   := 4;
	xMsg9272.RiskClass := 4;
	xMsg9272();
	MM2VIS.bMsg9272    := xMsg9272.Q;

	(* W9273 - Ramp rate down by utility operator measuring signal failure *)
	xMsg9273.Enable	   := TRUE;
	xMsg9273.Set	   := bMsg9273;
	xMsg9273.Reset	   := TRUE;
	xMsg9273.PT	   := T#0s;
	xMsg9273.Prio 	   := 4;
	xMsg9273.RiskClass := 4;
	xMsg9273();
	MM2VIS.bMsg9273    := xMsg9273.Q;

	(* W9274 - Reference Frequency FSM/LFSM by utility operator measuring signal failure *)
	xMsg9274.Enable	   := TRUE;
	xMsg9274.Set	   := bMsg9274;
	xMsg9274.Reset	   := TRUE;
	xMsg9274.PT	       := T#0s;
	xMsg9274.Prio 	   := 4;
	xMsg9274.RiskClass := 4;
	xMsg9274();
	MM2VIS.bMsg9274    := xMsg9274.Q;

	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)

	(* B2171 - FC response enabled *)
	xMsg2171.Enable		:=	OUT_GR.tGR2CU.bSet_GrC_FSM;
	xMsg2171.Set		:=	OUT_GR.bP_Set_FC_Enable;
	xMsg2171.Reset		:=	TRUE;
	xMsg2171();
	MM2VIS.bMsg2171		:=	xMsg2171.Q;

	(* B2172 - FC response disabled *)
	xMsg2172.Enable		:=	OUT_GR.tGR2CU.bSet_GrC_FSM;
	xMsg2172.Set		:=	NOT OUT_GR.bP_Set_FC_Enable;
	xMsg2172.Reset		:=	TRUE;
	xMsg2172();
	MM2VIS.bMsg2172		:=	xMsg2172.Q;

	(* B2173 - HFR (high frequency response)response enabled *)
	xMsg2173.Enable		:=	Para.bAFC_manual;
	xMsg2173.Set		:=	OUT_GR.bP_Red_POR_Enable;
	xMsg2173.Reset		:=	TRUE;
	xMsg2173();
	MM2VIS.bMsg2173		:=	xMsg2173.Q;

	(* B2174 - HFR response disabled *)
	xMsg2174.Enable		:=	Para.bAFC_manual;
	xMsg2174.Set		:=	NOT OUT_GR.bP_Red_POR_Enable;
	xMsg2174.Reset		:=	TRUE;
	xMsg2174();
	MM2VIS.bMsg2174		:=	xMsg2174.Q;

	(* B2175 - POR response enabled *)
	xMsg2175.Enable		:=	Para.bAFC_manual;
	xMsg2175.Set		:=	OUT_GR.bP_Red_POR_Enable;
	xMsg2175.Reset		:=	TRUE;
	xMsg2175();
	MM2VIS.bMsg2175		:=	xMsg2175.Q;

	(* B2176 - POR response disabled *)
	xMsg2176.Enable		:=	Para.bAFC_manual;
	xMsg2176.Set		:=	NOT OUT_GR.bP_Red_POR_Enable;
	xMsg2176.Reset		:=	TRUE;
	xMsg2176();
	MM2VIS.bMsg2176		:=	xMsg2176.Q;

	(* B2177 - SOR response enabled *)
	xMsg2177.Enable		:=	Para.bAFC_manual;
	xMsg2177.Set		:=	OUT_GR.bP_Red_SOR_Enable;
	xMsg2177.Reset		:=	TRUE;
	xMsg2177();
	MM2VIS.bMsg2177		:=	xMsg2177.Q;

	(* B2178 - SOR response disabled *)
	xMsg2178.Enable		:=	Para.bAFC_manual;
	xMsg2178.Set		:=	NOT OUT_GR.bP_Red_SOR_Enable;
	xMsg2178.Reset		:=	TRUE;
	xMsg2178();
	MM2VIS.bMsg2178		:=	xMsg2178.Q;

	(* B2179 - TOR1 response enabled *)
	xMsg2179.Enable		:=	Para.bAFC_manual;
	xMsg2179.Set		:=	OUT_GR.bP_Red_TOR1_Enable;
	xMsg2179.Reset		:=	TRUE;
	xMsg2179();
	MM2VIS.bMsg2179		:=	xMsg2179.Q;

	(* B2180 - TOR1 response disabled *)
	xMsg2180.Enable		:=	Para.bAFC_manual;
	xMsg2180.Set		:=	NOT OUT_GR.bP_Red_TOR1_Enable;
	xMsg2180.Reset		:=	TRUE;
	xMsg2180();
	MM2VIS.bMsg2180		:=	xMsg2180.Q;

	(* B2181 - TOR2 response enabled *)
	xMsg2181.Enable		:=	Para.bAFC_manual;
	xMsg2181.Set		:=	OUT_GR.bP_Red_TOR2_Enable;
	xMsg2181.Reset		:=	TRUE;
	xMsg2181();
	MM2VIS.bMsg2181		:=	xMsg2181.Q;

	(* B2182 - TOR2 response disabled *)
	xMsg2182.Enable		:=	Para.bAFC_manual;
	xMsg2182.Set		:=	NOT OUT_GR.bP_Red_TOR2_Enable;
	xMsg2182.Reset		:=	TRUE;
	xMsg2182();
	MM2VIS.bMsg2182		:=	xMsg2182.Q;

	(* B2183 - RR response enabled *)
	xMsg2183.Enable		:=	Para.bAFC_manual;
	xMsg2183.Set		:=	OUT_GR.bP_Red_RR_Enable;
	xMsg2183.Reset		:=	TRUE;
	xMsg2183();
	MM2VIS.bMsg2183		:=	xMsg2183.Q;

	(* B2184 - RR response disabled *)
	xMsg2184.Enable		:=	Para.bAFC_manual;
	xMsg2184.Set		:=	NOT OUT_GR.bP_Red_RR_Enable;
	xMsg2184.Reset		:=	TRUE;
	xMsg2184();
	MM2VIS.bMsg2184		:=	xMsg2184.Q;

	(* B2185 - SR response enabled *)
	xMsg2185.Enable		:=	Para.bAFC_manual;
	xMsg2185.Set		:=	OUT_GR.bP_Red_SR_Enable;
	xMsg2185.Reset		:=	TRUE;
	xMsg2185();
	MM2VIS.bMsg2185		:=	xMsg2185.Q;

	(* B2186 - SR response disabled *)
	xMsg2186.Enable		:=	Para.bAFC_manual;
	xMsg2186.Set		:=	NOT OUT_GR.bP_Red_SR_Enable;
	xMsg2186.Reset		:=	TRUE;
	xMsg2186();
	MM2VIS.bMsg2186		:=	xMsg2186.Q;

	(* B2811 power limitation by utility *)
	xMsg2811.Enable		:=	TRUE;
	xMsg2811.Set		:=	IN_GR.PLim_GenC_SetEUPFix1 OR IN_GR.PLim_GenC_SetEUPFix2 OR
							IN_GR.PLim_GenC_SetEUPFix3 OR IN_GR.PLim_GenC_SetEUPFix4 OR
							IN_GR.PLim_GenC_SetEUPFix5;
	xMsg2811.Reset		:=	TRUE;
	xMsg2811();
	MM2VIS.bMsg2811		:=	xMsg2811.Q;
	
	(* B2812 module blocked by utility *)
	xMsg2812.Enable		:=	TRUE;
	xMsg2812.Set		:=	((IN_GR.tDI_Dem_EU_Block.Di OR IN_GR.bEng_Block_EVU) AND NOT (IN_GR.iIdx_OMSS = 1)) OR bEU_RM_BLOCK_INT OR OUT_GR.tERDF_BLOCK.Do ;
	xMsg2812.Reset		:=	TRUE;
	xMsg2812();
	MM2VIS.bMsg2812		:=	xMsg2812.Q;
	
	(* B2853 - RMC enabled *) 
	xMsg2853.Enable		:=	TRUE;
	xMsg2853.Set		:=	OUT_GR.bP_Red_RMC_Enable;
	xMsg2853.Reset		:=	TRUE;
	xMsg2853();
	MM2VIS.bMsg2853		:=	xMsg2853.Q;

	(* B2854 - RMC disabled *)
	xTP_RMC(IN := EDGENEG(OUT_GR.bP_Red_RMC_Enable), PT := T#10s);

	xMsg2854.Enable		:=	TRUE;
	xMsg2854.Set		:=	xTP_RMC.Q;
	xMsg2854.Reset		:=	TRUE;
	xMsg2854();
	MM2VIS.bMsg2854		:=	xMsg2854.Q;

	(* B2855 - PFC enabled *)
	xMsg2855.Enable		:=	FALSE; (*not in use anymore*)
	xMsg2855.Set		:=	OUT_GR.bP_Red_PFC_Enable;
	xMsg2855.Reset		:=	TRUE;
	xMsg2855();
	MM2VIS.bMsg2855		:=	xMsg2855.Q;
	
	(* B2856 - PFC disabled *)
	xTP_PFC(IN := EDGENEG(OUT_GR.bP_Red_PFC_Enable), PT := T#10s);

	xMsg2856.Enable		:=	FALSE; (*not in use anymore*)
	xMsg2856.Set		:=	xTP_PFC.Q;
	xMsg2856.Reset		:=	TRUE;
	xMsg2856();
	MM2VIS.bMsg2856		:=	xMsg2856.Q;
	
	(* B2857 - Power setpoint by utility operator *)
	xMsg2857.Enable		:=	TRUE;
	xMsg2857.Set		:=	OUT_GR.bP_Set_EU_Enable;
	xMsg2857.Reset		:=	TRUE;
	xMsg2857();
	MM2VIS.bMsg2857		:=	xMsg2857.Q;
	
	(* B2858 - Power factor setpoint by utility operator enabled *)
	xMsg2858.Enable		:=	TRUE;
	xMsg2858.Set		:=	(OUT_GR.iGCQ_Fun_Act = 1);
	xMsg2858.Reset		:=	TRUE;
	xMsg2858();
	MM2VIS.bMsg2858		:=	xMsg2858.Q;
	
	(* B2859 - Power factor setpoint by utility operator disabled *)
	xTP_PFSet(IN := EDGENEG(OUT_GR.iGCQ_Fun_Act = 1), PT := T#10s);

	xMsg2859.Enable		:=	TRUE;
	xMsg2859.Set		:=	xTP_PFSet.Q;;
	xMsg2859.Reset		:=	TRUE;
	xMsg2859();
	MM2VIS.bMsg2859		:=	xMsg2859.Q;

	(* B2860 - Reactive power setpoint by utility operator enabled *)
	xMsg2860.Enable		:=	TRUE;
	xMsg2860.Set		:=	(OUT_GR.iGCQ_Fun_Act = 6);
	xMsg2860.Reset		:=	TRUE;
	xMsg2860();
	MM2VIS.bMsg2860		:=	xMsg2860.Q;
	
	(* B2861 - Reactive power setpoint by utility operator disabled *)
	xTP_QSet(IN := EDGENEG(OUT_GR.iGCQ_Fun_Act = 6), PT := T#10s);

	xMsg2861.Enable		:=	TRUE;
	xMsg2861.Set		:=	xTP_QSet.Q;
	xMsg2861.Reset		:=	TRUE;
	xMsg2861();
	MM2VIS.bMsg2861		:=	xMsg2861.Q;

	(* B2862 - Reactive power limitation BY utility operator *)
	xMsg2862.Enable		:=	TRUE;
	xMsg2862.Set		:=	bQLim_Greift;
	xMsg2862.Reset		:=	TRUE;
	xMsg2862();
	MM2VIS.bMsg2862		:=	xMsg2862.Q;
	
	(* B2863 - Reactive power limitation BY utility operator enabled *)
	xMsg2863.Enable		:=	TRUE;
	xMsg2863.Set		:=	OUT_GR.bQLim_Aktiv ; 
	xMsg2863.Reset		:=	TRUE;
	xMsg2863();
	MM2VIS.bMsg2863		:=	xMsg2863.Q;
	
	(* B2864 - Reactive power limitation BY utility operator disabled *)
	xTP_QLim(IN := EDGENEG(OUT_GR.bQLim_Aktiv), PT := T#10s);

	xMsg2864.Enable		:=	TRUE;
	xMsg2864.Set		:=	xTP_QLim.Q;
	xMsg2864.Reset		:=	TRUE;
	xMsg2864();
	MM2VIS.bMsg2864		:=	xMsg2864.Q;
	
	(* B2865 - cos phi (P) enabled *)
	xMsg2865.Enable		:=	TRUE;
	xMsg2865.Set		:=	(OUT_GR.iGCQ_Fun_Act = 2);
	xMsg2865.Reset		:=	TRUE;
	xMsg2865();
	MM2VIS.bMsg2865		:=	xMsg2865.Q;
	
	(* B2866 - cos phi (P) disabled *)
	xTP_PFP(IN := EDGENEG(OUT_GR.iGCQ_Fun_Act = 2), PT := T#10s);

	xMsg2866.Enable		:=	TRUE;
	xMsg2866.Set		:=	xTP_PFP.Q;
	xMsg2866.Reset		:=	TRUE;
	xMsg2866();
	MM2VIS.bMsg2866		:=	xMsg2866.Q;
	
	(* B2867 - cos phi (U) enabled *)
	xMsg2867.Enable		:=	TRUE;
	xMsg2867.Set		:=	(OUT_GR.iGCQ_Fun_Act = 3);
	xMsg2867.Reset		:=	TRUE;
	xMsg2867();
	MM2VIS.bMsg2867		:=	xMsg2867.Q;
	
	(* B2868 - cos phi (U) disabled *)
	xTP_PFU(IN := EDGENEG(OUT_GR.iGCQ_Fun_Act = 3), PT := T#10s);

	xMsg2868.Enable		:=	TRUE;
	xMsg2868.Set		:=	xTP_PFU.Q;
	xMsg2868.Reset		:=	TRUE;
	xMsg2868();
	MM2VIS.bMsg2868		:=	xMsg2868.Q;
	
	(* B2869 - Q(U) enabled *)
	xMsg2869.Enable		:=	TRUE;
	xMsg2869.Set		:=	(OUT_GR.iGCQ_Fun_Act = 4); 
	xMsg2869.Reset		:=	TRUE;
	xMsg2869();
	MM2VIS.bMsg2869		:=	xMsg2869.Q;
	
	(* B2870 - Q(U) disabled *)
	xTP_QU(IN := EDGENEG(OUT_GR.iGCQ_Fun_Act = 4), PT := T#10s);

	xMsg2870.Enable		:=	TRUE;
	xMsg2870.Set		:=	xTP_QU.Q;
	xMsg2870.Reset		:=	TRUE;
	xMsg2870();
	MM2VIS.bMsg2870		:=	xMsg2870.Q;
	
	(* B2940 - Q customized enabled *)
	xMsg2940.Enable		:=	TRUE;
	xMsg2940.Set		:=	(OUT_GR.iGCQ_Fun_Act = 0) AND (iPrio_Akt = 9);
	xMsg2940.Reset		:=	TRUE;
	xMsg2940();
	MM2VIS.bMsg2940		:=	xMsg2940.Q;
	
	(* B2941 - Q customized disabled *)
	xTP_QCus(IN := EDGENEG((OUT_GR.iGCQ_Fun_Act = 0) AND (iPrio_Akt = 9)), PT := T#10s);

	xMsg2941.Enable		:=	TRUE;
	xMsg2941.Set		:=	xTP_QCus.Q;
	xMsg2941.Reset		:=	TRUE;
	xMsg2941();
	MM2VIS.bMsg2941		:=	xMsg2941.Q;
	
	(* B2942 - Voltage control function enabled *)
	xMsg2942.Enable		:=	TRUE;
	xMsg2942.Set		:=	(OUT_GR.iGCQ_Fun_Act = 7);
	xMsg2942.Reset		:=	TRUE;
	xMsg2942();
	MM2VIS.bMsg2942		:=	xMsg2942.Q;
	
	(* B2943 - Voltage control function  disabled *)
	xTP_UCtrl(IN := EDGENEG(OUT_GR.iGCQ_Fun_Act = 7), PT := T#10s);

	xMsg2943.Enable		:=	TRUE;
	xMsg2943.Set		:=	xTP_UCtrl.Q;
	xMsg2943.Reset		:=	TRUE;
	xMsg2943();
	MM2VIS.bMsg2943		:=	xMsg2943.Q;
	
	(* B2944 - Q(P) enabled *)
	xMsg2944.Enable		:=	TRUE;
	xMsg2944.Set		:=	(OUT_GR.iGCQ_Fun_Act = 5);
	xMsg2944.Reset		:=	TRUE;
	xMsg2944();
	MM2VIS.bMsg2944		:=	xMsg2944.Q;
	
	(* B2945 - Q(P) disabled *)
	xTP_QP(IN := EDGENEG(OUT_GR.iGCQ_Fun_Act = 5), PT := T#10s);

	xMsg2945.Enable		:=	TRUE;
	xMsg2945.Set		:=	xTP_QP.Q;
	xMsg2945.Reset		:=	TRUE;
	xMsg2945();
	MM2VIS.bMsg2945		:=	xMsg2945.Q;
	
	(* B2946 - Function pf-time table enabled *)
	xMsg2946.Enable		:=	TRUE;
	xMsg2946.Set		:=	(OUT_GR.iGCQ_Fun_Act = 8);
	xMsg2946.Reset		:=	TRUE;
	xMsg2946();
	MM2VIS.bMsg2946		:=	xMsg2946.Q;
	
	(* B2947 - Function pf-time table disabled *)
	xTP_PFP(IN := EDGENEG(OUT_GR.iGCQ_Fun_Act = 8), PT := T#10s);

	xMsg2947.Enable		:=	TRUE;
	xMsg2947.Set		:=	xTP_PFP.Q;
	xMsg2947.Reset		:=	TRUE;
	xMsg2947();
	MM2VIS.bMsg2947		:=	xMsg2947.Q;
	
	(* B2948 - Test function Q(U), cosphi(U) active *)
	xMsg2948.Enable		:=	TRUE;
	xMsg2948.Set		:=	bSimu_QU_PFU_HMI;
	xMsg2948.Reset		:=	TRUE;
	xMsg2948();
	MM2VIS.bMsg2948		:=	xMsg2948.Q;
	
	(* B2949 - Q-reduction: Q(U) limitation *)
	xMsg2949.Enable		:=	TRUE;
	xMsg2949.Set		:=	bQ_Lim_QU_Rel;
	xMsg2949.Reset		:=	TRUE;
	xMsg2949();
	MM2VIS.bMsg2949		:=	xMsg2949.Q;
	
	(* B2950 - LFSM-O activated *)
	xMsg2950.Enable		:=	TRUE;
	xMsg2950.Set		:=	(OUT_GR.bP_Red_PFC_Enable AND Para.bSet_GrC_LFSMO_COn);
	xMsg2950.Reset		:=	TRUE;
	xMsg2950();
	MM2VIS.bMsg2950		:=	xMsg2950.Q;
	
	(* B2951 - LFSM-O deactivated *)
	xTP_LFSMO(IN := EDGENEG(OUT_GR.bP_Red_PFC_Enable AND Para.bSet_GrC_LFSMO_COn), PT := T#10s);

	xMsg2951.Enable		:=	TRUE;
	xMsg2951.Set		:=	xTP_LFSMO.Q;
	xMsg2951.Reset		:=	TRUE;
	xMsg2951();
	MM2VIS.bMsg2951		:=	xMsg2951.Q;
	
	(* B2952 - LFSM-U activated *)
	xMsg2952.Enable		:=	TRUE;
	xMsg2952.Set		:=	(OUT_GR.bP_Red_PFC_Enable AND Para.bSet_GrC_LFSMU_COn);
	xMsg2952.Reset		:=	TRUE;
	xMsg2952();
	MM2VIS.bMsg2952		:=	xMsg2952.Q;
	
	(* B2953 - LFSM-U deactivated *)
	xTP_LFSMU(IN := EDGENEG(OUT_GR.bP_Red_PFC_Enable AND Para.bSet_GrC_LFSMU_COn), PT := T#10s);

	xMsg2953.Enable		:=	TRUE;
	xMsg2953.Set		:=	xTP_LFSMU.Q;
	xMsg2953.Reset		:=	TRUE;
	xMsg2953();
	MM2VIS.bMsg2953		:=	xMsg2953.Q;
	
	(* B2954 - P(U) activated *)
	xMsg2954.Enable		:=	TRUE;
	xMsg2954.Set		:=	(OUT_GR.bP_Red_PU_Enable);
	xMsg2954.Reset		:=	TRUE;
	xMsg2954();
	MM2VIS.bMsg2954		:=	xMsg2954.Q;
	
	(* B2955 - P(U) deactivated *)
	xTP_PU(IN := EDGENEG(OUT_GR.bP_Red_PU_Enable), PT := T#10s);

	xMsg2955.Enable		:=	TRUE;
	xMsg2955.Set		:=	xTP_PU.Q;
	xMsg2955.Reset		:=	TRUE;
	xMsg2955();
	MM2VIS.bMsg2955		:=	xMsg2955.Q;

	(* B3000 - Module blocked by Grid module, data structure failure *)
	xMsg3000.Enable		:=	TRUE;
	xMsg3000.Set		:=	OUT_GR.bEng_Bloc_GR;
	xMsg3000.Reset		:=	TRUE;	
	xMsg3000();
	MM2VIS.bMsg3000		:=	xMsg3000.Q;

	(* B9008 - LFSMO Droop by utility operator enabled *)
	xMsg9008.Enable		:=	TRUE;
	xMsg9008.Set		:=	bGCP_Droop_GrC_LFSMO_pos OR bBC_Droop_GrC_LFSMO_pos;
	xMsg9008.Reset		:=	TRUE;
	xMsg9008();
	MM2VIS.bMsg9008		:=	xMsg9008.Q;
	
	(* B9009 - LFSMO Droop by utility operator disabled  *)
	xMsg9009.Enable		:=	TRUE;
	xMsg9009.Set		:=	NOT bGCP_Droop_GrC_LFSMO_pos AND NOT bBC_Droop_GrC_LFSMO_pos;
	xMsg9009.Reset		:=	TRUE;
	xMsg9009();
	MM2VIS.bMsg9009		:=	xMsg9009.Q;
	
	(* B9010 - LFSMU Droop by utility operator enabled *)
	xMsg9010.Enable		:=	TRUE;
	xMsg9010.Set		:=	bGCP_Droop_GrC_LFSMU_neg OR bBC_Droop_GrC_LFSMU_neg;
	xMsg9010.Reset		:=	TRUE;
	xMsg9010();
	MM2VIS.bMsg9010		:=	xMsg9010.Q;
	
	(* B9011 - LFSMU Droop by utility operator disabled *)
	xMsg9011.Enable		:=	TRUE;
	xMsg9011.Set		:=	NOT bGCP_Droop_GrC_LFSMU_neg AND NOT bBC_Droop_GrC_LFSMU_neg;
	xMsg9011.Reset		:=	TRUE;
	xMsg9011();
	MM2VIS.bMsg9011		:=	xMsg9011.Q;
	
	(* B9012 - FSMO Droop by utility operator enabled *)
	xMsg9012.Enable		:=	TRUE;
	xMsg9012.Set		:=	bGCP_Droop_GrC_FSMO OR bBC_Droop_GrC_FSMO;
	xMsg9012.Reset		:=	TRUE;
	xMsg9012();
	MM2VIS.bMsg9012		:=	xMsg9012.Q;
	
	(* B9013 - FSMO Droop by utility operator disabled *)
	xMsg9013.Enable		:=	TRUE;
	xMsg9013.Set		:=	NOT bGCP_Droop_GrC_FSMO AND NOT bBC_Droop_GrC_FSMO;
	xMsg9013.Reset		:=	TRUE;
	xMsg9013();
	MM2VIS.bMsg9013		:=	xMsg9013.Q;
	
	(* B9014 - FSMU Droop by utility operator enabled *)
	xMsg9014.Enable		:=	TRUE;
	xMsg9014.Set		:=	bGCP_Droop_GrC_FSMU OR bBC_Droop_GrC_FSMU;
	xMsg9014.Reset		:=	TRUE;
	xMsg9014();
	MM2VIS.bMsg9014		:=	xMsg9014.Q;
	
	(* B9015 - FSMU Droop by utility operator disabled *)
	xMsg9015.Enable		:=	TRUE;
	xMsg9015.Set		:=	NOT bGCP_Droop_GrC_FSMU AND NOT bBC_Droop_GrC_FSMU;
	xMsg9015.Reset		:=	TRUE;
	xMsg9015();
	MM2VIS.bMsg9015		:=	xMsg9015.Q;
	
	(* B9016 - FSMO Deadband by utility operator enabled *)
	xMsg9016.Enable		:=	TRUE;
	xMsg9016.Set		:=	bGCP_FSMO_GRC_DB OR bBC_FSMO_GRC_DB;
	xMsg9016.Reset		:=	TRUE;
	xMsg9016();
	MM2VIS.bMsg9016		:=	xMsg9016.Q;
	
	(* B9017 - FSMO Deadband by utility operator disabled *)
	xMsg9017.Enable		:=	TRUE;
	xMsg9017.Set		:=  NOT	bGCP_FSMO_GRC_DB AND NOT bBC_FSMO_GRC_DB;
	xMsg9017.Reset		:=	TRUE;
	xMsg9017();
	MM2VIS.bMsg9017		:=	xMsg9017.Q;
	
	(* B9018 - FSMU Deadband by utility operator enabled *)
	xMsg9018.Enable		:=	TRUE;
	xMsg9018.Set		:=	bGCP_FSMU_GRC_DB OR bBC_FSMU_GRC_DB;
	xMsg9018.Reset		:=	TRUE;
	xMsg9018();
	MM2VIS.bMsg9018		:=	xMsg9018.Q;
	
	(* B9019 - FSMU Deadband by utility operator disabled *)
	xMsg9019.Enable		:=	TRUE;
	xMsg9019.Set		:=  NOT	bGCP_FSMU_GRC_DB AND NOT bBC_FSMU_GRC_DB;
	xMsg9019.Reset		:=	TRUE;
	xMsg9019();
	MM2VIS.bMsg9019		:=	xMsg9019.Q;
	
	(* B9020 - LFSMO Deadband by utility operator enabled *)
	xMsg9020.Enable		:=	TRUE;
	xMsg9020.Set		:=	bGCP_LFMSO_GRC_DB_pos OR bBC_GCP_LFMSO_GRC_DB_pos;
	xMsg9020.Reset		:=	TRUE;
	xMsg9020();
	MM2VIS.bMsg9020		:=	xMsg9020.Q;
	
	(* B9021 - LFSMO Deadband by utility operator disabled *)
	xMsg9021.Enable		:=	TRUE;
	xMsg9021.Set		:=	NOT bGCP_LFMSO_GRC_DB_pos AND NOT bBC_GCP_LFMSO_GRC_DB_pos;
	xMsg9021.Reset		:=	TRUE;
	xMsg9021();
	MM2VIS.bMsg9021		:=	xMsg9021.Q;
	
	(* B9022 - LFSMU Deadband by utility operator enabled *)
	xMsg9022.Enable		:=	TRUE;
	xMsg9022.Set		:=	bGCP_LFMSU_GRC_DB_neg OR bBC_GCP_LFMSU_GRC_DB_neg;
	xMsg9022.Reset		:=	TRUE;
	xMsg9022();
	MM2VIS.bMsg9022		:=	xMsg9022.Q;
	
	(* B9023 - LFSMU Deadband by utility operator disabled *)
	xMsg9023.Enable		:=	TRUE;
	xMsg9023.Set		:=	NOT bGCP_LFMSU_GRC_DB_neg AND NOT bBC_GCP_LFMSU_GRC_DB_neg;
	xMsg9023.Reset		:=	TRUE;
	xMsg9023();
	MM2VIS.bMsg9023		:=	xMsg9023.Q;
	
	(* B9093 - ILF enabled *)
	xMsg9093.Enable		:=	TRUE;
	xMsg9093.Set		:=	OUT_GR.bP_Act_ILF_Enable;
	xMsg9093.Reset		:=	TRUE;
	xMsg9093();
	MM2VIS.bMsg9093		:=	xMsg9093.Q;
	
	(* B9094 - ILF disable *)
	xTP_ILF(IN := EDGENEG(OUT_GR.bP_Act_ILF_Enable), PT := T#10s);
	
	xMsg9094.Enable		:=	TRUE;
	xMsg9094.Set		:=	xTP_ILF.Q;
	xMsg9094.Reset		:=	TRUE;
	xMsg9094();
	MM2VIS.bMsg9094		:=	xMsg9094.Q;
	
	IF Para.bDEIE_Active THEN
	
		xTP_P0(IN := EDGENEG(OUT_GR.bOpMsg_Plim_ERDF_SOnOf), PT := T#15s);

		(* B2886 P0 DEIE activ *)
		MM2VIS.bMsg2886	:= OUT_GR.bOpMsg_Plim_ERDF_SOnOf;
	
		(* B2887 Q0 DEIE activ *)
		MM2VIS.bMsg2887	:= FALSE; 	(*Standardmeldungen verwerdet*)
	
		(* B2888 DEIE Release to synchronise *)
		MM2VIS.bMsg2888	:= bMsg2888;

		(* B2889 Q0 not activ *)
		MM2VIS.bMsg2889	:= FALSE;	(*Standardmeldungen verwerdet*)
	
		(* B2890 RSE activ *)
		MM2VIS.bMsg2890	:= OUT_GR.bOpMsg_RSE_SOnOf;
	
		(* B2891 P0 not activ *)
		MM2VIS.bMsg2891	:= xTP_P0.Q;
	
		(* B2892 customer switch on *)
		MM2VIS.bMsg2892	:= OUT_GR.bOpMsg_P0_BLOCK_DEIE_SOnOf;
	
		(* B2893 customer switch off *)
		MM2VIS.bMsg2893	:= NOT OUT_GR.bOpMsg_P0_BLOCK_DEIE_SOnOf;
	
	ELSE
		MM2VIS.bMsg2886	:= FALSE;
		MM2VIS.bMsg2887	:= FALSE;
		MM2VIS.bMsg2888	:= FALSE;
		MM2VIS.bMsg2889	:= FALSE;
		MM2VIS.bMsg2890	:= FALSE;
		MM2VIS.bMsg2891	:= FALSE;
		MM2VIS.bMsg2892	:= FALSE;
		MM2VIS.bMsg2893	:= FALSE;
	END_IF;

//	MM2VIS.bMsg2171	:= FALSE;
//	MM2VIS.bMsg2172	:= FALSE;
	MM2VIS.bMsg2173	:= FALSE;
	MM2VIS.bMsg2174	:= FALSE;
	MM2VIS.bMsg2175	:= FALSE;
	MM2VIS.bMsg2176	:= FALSE;
	MM2VIS.bMsg2177	:= FALSE;
	MM2VIS.bMsg2178	:= FALSE;
	MM2VIS.bMsg2179	:= FALSE;
	MM2VIS.bMsg2180	:= FALSE;
	MM2VIS.bMsg2181	:= FALSE;
	MM2VIS.bMsg2182	:= FALSE;
	MM2VIS.bMsg2183	:= FALSE;
	MM2VIS.bMsg2184	:= FALSE;
	MM2VIS.bMsg2185	:= FALSE;
	MM2VIS.bMsg2186	:= FALSE;
	
	(* B template 
	xMsg.Enable		:=	TRUE;
	xMsg.Set		:=	bBool;
	xMsg.Reset		:=	TRUE;
	xMsg();
	MM2VIS.bMsg		:=	xMsg.Q;	*)
	
	(*--------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1	:= OUT_GR.tGR2AB.bGnlTrip1   OR IN_GR.tAB2GR.bGnlTrip1;
	bGnlTrip2	:= OUT_GR.tGR2AB.bGnlTrip2   OR IN_GR.tAB2GR.bGnlTrip2;
	bGnlTrip3	:= OUT_GR.tGR2AB.bGnlTrip3   OR IN_GR.tAB2GR.bGnlTrip3;
	bGnlWarning	:= OUT_GR.tGR2AB.bGnlWarning OR IN_GR.tAB2GR.bGnlWarning;

	bGnlTrip	:=	bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;

	(*******************************************************************************)
END_PROGRAM
