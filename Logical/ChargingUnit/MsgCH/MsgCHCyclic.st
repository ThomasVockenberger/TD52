(*******************************************************************************
Msg_CH	 			 alarms generation MM_Charging

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	11.09.2012	Tinello		new
V04.00.00.00	27.05.2013	lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
V04.00.01.00	08.08.2014	lettenb.	OUT_CH.bMsg1078 added
V04.04.00.00	19.02.2016	Diercks		xMsg2626, xMsg2668 to xMsg2673 added
				22.06.2016	Tinello		1176 entfernt; 2700, 2779, 2780 und 3597-3600 hinzu
				27.10.2016	Tinello		change of TC speed deviation function
				31.10.2016	Tinello		2407-2410 hinzu --> Spec. pressure (c)
				02.11.2016	Tinello		2411-2414 hinzu --> Spec. temperature (c)
V04.05.00.00	02.03.2017	lettenb.	2216,2219 disabled, SWAT920/1
                21.03.2017  lettenb.    2217,2220,2278,2279,2280 disabled, SWAT920/2
				19.04.2017	Weitzer		2460, 2461 added, SWAT920/2
                27.04.2017  lettenb.    1114 disabled for 920, SWAT920/2
				23.01.2018	Tinello		Temp and TC speed modifications
V04.05.01.00	05.03.2018	Tinello		2324-2327 hinzugefügt
V04.05.04.00	27.09.2018	Tinello		detection of low-pressure TC exist changed, bu
V04.07.00.00	23.10.2018	Tinello		2530 minimal angepasst; 9237-9243 hinzu
V04.12.00.00	19.01.2023	Tinello		Deleted 2223, 2317, 2324, 2412, 2478, 2533 / Added 2368-2370, 9370
V04.14.00.00    20.06.2024	Soto		Added 9399
V04.14.00.00	12.11.2024	Theobald	Alarm 2280, 2318 there is no trip during engine operation. [2024-224]

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
	OUT_CH.tCH2AB.bGnlTrip1		:= FALSE;
	OUT_CH.tCH2AB.bGnlTrip2		:= FALSE;
	OUT_CH.tCH2AB.bGnlTrip3		:= FALSE;
	OUT_CH.tCH2AB.bGnlWarning	:= FALSE;
	OUT_CH.tCH2AB.bTriptype1	:= FALSE;
	OUT_CH.tCH2AB.bTriptype2	:= FALSE;
	OUT_CH.tCH2AB.bTriptype3	:= FALSE;	


	(*---------------------------------------------------------------------------*)	
	(* A1040 Charge temperature t2' maximum  *)
	xMsg1040.Enable	   	:= TRUE;	
	xMsg1040.Set       	:= bAMM_T_Ch_T2s_HiHi;
	xMsg1040.PT		   	:= T#0s;
	xMsg1040.Prio	   	:= 2;
	xMsg1040.RiskClass 	:= 1;
	xMsg1040.Reset	   	:= FALSE;
	xMsg1040();
	MM2VIS.bMsg1040		:= xMsg1040.Q;

	(* A1077 Measuring signal failure charge pressure p2 (before trottle valve) *)
	xMsg1077.Enable	   	:= TRUE;
	xMsg1077.Set       	:= bAMM_Pr_Ch_P2_MsMs;	
	xMsg1077.PT		   	:= T#0s;
	xMsg1077.Prio	   	:= 2;
	xMsg1077.RiskClass 	:= 4;
	xMsg1077.Reset	   	:= FALSE;
	xMsg1077();
	MM2VIS.bMsg1077		:= xMsg1077.Q;

	(* A1078 Measuring signal failure charge pressure   *)
	xMsg1078.Enable	   	:= TRUE;
	xMsg1078.Set       	:= bAMM_Pr_Ch_P2s_MsMs OR bAMM_Pr_Ch_P2_Sum_MsMs;			
	xMsg1078.PT		   	:= T#0s;
	xMsg1078.Prio	   	:= 2;
	xMsg1078.RiskClass 	:= 4;
	xMsg1078.Reset	   	:= FALSE;
	xMsg1078();
	MM2VIS.bMsg1078		:= xMsg1078.Q;
	OUT_CH.bMsg1078		:= xMsg1078.Q;

	(* A1105 Speed of charge temperature t2' change maximum *)
	xMsg1105.Enable	   	:= TRUE;	
	xMsg1105.Set       	:= bAMM_T_Ch_T2s_RocHiHi;
	xMsg1105.PT		   	:= T#0s;
	xMsg1105.Prio	   	:= 2;
	xMsg1105.RiskClass 	:= 2;
	xMsg1105.Reset	   	:= FALSE;
	xMsg1105();
	MM2VIS.bMsg1105		:= xMsg1105.Q;

	(* A1114 Measuring signal failure charge temperature t2'*)
	xMsg1114.Enable	   	:= NOT xEngType.Type9;		//SWAT920/2					
	xMsg1114.Set       	:= bAMM_T_Ch_T2s_MsMs;
	xMsg1114.PT		   	:= T#0s;
	xMsg1114.Prio	   	:= 3;
	xMsg1114.RiskClass 	:= 4;
	xMsg1114.Reset	   	:= FALSE;
	xMsg1114();
	MM2VIS.bMsg1114		:= xMsg1114.Q;

	(* A2215 Measuring signal failure charge temperature t2' A *)			(* NOT USED *)
	xMsg2215.Enable	   	:= FALSE;					
	xMsg2215.Set       	:= FALSE;
	xMsg2215.PT		   	:= T#0s;
	xMsg2215.Prio	   	:= 3;
	xMsg2215.RiskClass 	:= 4;
	xMsg2215.Reset	   	:= FALSE;
	xMsg2215();
	MM2VIS.bMsg2215		:= xMsg2215.Q;
	
	(* A2216 Charge temperature t2' A maximum *)
	xMsg2216.Enable	   	:= NOT xEngType.Type9;			//SWAT920/1
	xMsg2216.Set       	:= bAMM_T_Ch_T2s_A_HiHi;
	xMsg2216.PT		   	:= T#0s;
	xMsg2216.Prio	   	:= 2;
	xMsg2216.RiskClass 	:= 4;
	xMsg2216.Reset	   	:= FALSE;
	xMsg2216();
	MM2VIS.bMsg2216		:= xMsg2216.Q;

	(* A2217 Speed of charge temperature t2' A change maximum *)
	xMsg2217.Enable	   	:= NOT xEngType.Type9;			//SWAT920/2
	xMsg2217.Set       	:= bAMM_T_Ch_T2s_A_RocHiHi;
	xMsg2217.PT		   	:= T#0s;
	xMsg2217.Prio	   	:= 2;
	xMsg2217.RiskClass 	:= 4;
	xMsg2217.Reset	   	:= FALSE;
	xMsg2217();
	MM2VIS.bMsg2217		:= xMsg2217.Q;

	(* A2218 Measuring signal failure charge temperature t2' B *)			(* NOT USED *)
	xMsg2218.Enable	   	:= FALSE;	
	xMsg2218.Set       	:= FALSE;
	xMsg2218.PT		   	:= T#0s;
	xMsg2218.Prio	   	:= 3;
	xMsg2218.RiskClass 	:= 4;
	xMsg2218.Reset	   	:= FALSE;
	xMsg2218();
	MM2VIS.bMsg2218		:= xMsg2218.Q;

	(* A2219 Charge temperature t2' B maximum *)
	xMsg2219.Enable	   	:= NOT xEngType.Type9;			//SWAT920/1			
	xMsg2219.Set       	:= bAMM_T_Ch_T2s_B_HiHi;
	xMsg2219.PT		   	:= T#0s;
	xMsg2219.Prio	   	:= 2;
	xMsg2219.RiskClass 	:= 4;
	xMsg2219.Reset	   	:= FALSE;
	xMsg2219();
	MM2VIS.bMsg2219		:= xMsg2219.Q;

	(* A2220 Speed of charge temperature t2' B change maximum *)
	xMsg2220.Enable	   	:= NOT xEngType.Type9;			//SWAT920/2
	xMsg2220.Set       	:= bAMM_T_Ch_T2s_B_RocHiHi;
	xMsg2220.PT		   	:= T#0s;
	xMsg2220.Prio	   	:= 2;
	xMsg2220.RiskClass 	:= 4;
	xMsg2220.Reset	   	:= FALSE;
	xMsg2220();
	MM2VIS.bMsg2220		:= xMsg2220.Q;

	(* A2221 Measuring signal failure charge temperature before high-pressure TC A   *)	(* NOT USED  *)
	xMsg2221.Enable	   	:= FALSE;
	xMsg2221.Set       	:= FALSE;
	xMsg2221.PT		   	:= T#0s;
	xMsg2221.Prio	   	:= 3;
	xMsg2221.RiskClass 	:= 4;
	xMsg2221.Reset	   	:= FALSE;
	xMsg2221();
	MM2VIS.bMsg2221		:= xMsg2221.Q;

	(* A2222 Measuring signal failure charge temperature before high-pressure TC B	*)	(* NOT USED  *)
	xMsg2222.Enable	   	:= FALSE;
	xMsg2222.Set       	:= FALSE;
	xMsg2222.PT		   	:= T#0s;
	xMsg2222.Prio	   	:= 3;
	xMsg2222.RiskClass 	:= 4;
	xMsg2222.Reset	   	:= FALSE;
	xMsg2222();
	MM2VIS.bMsg2222		:= xMsg2222.Q;

	(* A2223 Charge temperature before high-pressure TC maximum *)							(* NOT USED >= v4.12 *)
	xMsg2223.Enable	   	:= FALSE;
	xMsg2223.Set       	:= FALSE;
	xMsg2223.PT		   	:= T#2s;
	xMsg2223.Prio	   	:= 3;
	xMsg2223.RiskClass 	:= 4;
	xMsg2223.Reset	   	:= FALSE;
	xMsg2223();
	MM2VIS.bMsg2223		:= xMsg2223.Q;
	
	(* A2225 High pressure turbocharger speed deviation maximum *)
	xMsg2225.Enable	   	:= TRUE;
	xMsg2225.Set       	:= bAMM_N_TCHP_Diff_HiHi AND Para.bTSTC_Exist;
	xMsg2225.PT		   	:= T#60s;
	xMsg2225.Prio	   	:= 3;
	xMsg2225.RiskClass 	:= 4;
	xMsg2225.Reset	   	:= FALSE;
	xMsg2225();
	MM2VIS.bMsg2225		:= xMsg2225.Q;

	(* A2226 Low pressure turbocharger speed deviation maximum *)
	xMsg2226.Enable	   	:= TRUE;
	xMsg2226.Set       	:= bAMM_N_TCLP_Diff_HiHi;
	xMsg2226.PT		   	:= T#60s;
	xMsg2226.Prio	   	:= 3;
	xMsg2226.RiskClass 	:= 4;
	xMsg2226.Reset	   	:= FALSE;
	xMsg2226();
	MM2VIS.bMsg2226		:= xMsg2226.Q;

	(* A2236 Charge pressure p2' deviation maximum   *)
	xMsg2236.Enable	   	:= TRUE;
	xMsg2236.Set       	:= bAMM_DPr_Ch_P2s_HiHi;
	xMsg2236.PT		   	:= T#0s;
	xMsg2236.Prio	   	:= 3;
	xMsg2236.RiskClass 	:= 4;
	xMsg2236.Reset	   	:= FALSE;
	xMsg2236();
	MM2VIS.bMsg2236		:= xMsg2236.Q;

	(* A2237 High pressure turbocharger speed maximum *)
	xMsg2237.Enable	   	:= TRUE;
	xMsg2237.Set   	 	:= bAMM_N_TCHP_HiHi AND Para.bTSTC_Exist;
	xMsg2237.PT			:= T#0s;
	xMsg2237.Prio	   	:= 3;
	xMsg2237.RiskClass 	:= 4;
	xMsg2237.Reset	   	:= FALSE;
	xMsg2237();
	MM2VIS.bMsg2237		:= xMsg2237.Q;

	(* A2239 Low pressure turbocharger speed maximum *)
	xMsg2239.Enable	   	:= TRUE;
	xMsg2239.Set       	:= bAMM_N_TCLP_HiHi;		
	xMsg2239.PT		   	:= T#0s;
	xMsg2239.Prio	   	:= 3;
	xMsg2239.RiskClass 	:= 4;
	xMsg2239.Reset	   	:= FALSE;
	xMsg2239();
	MM2VIS.bMsg2239		:= xMsg2239.Q;

	(* A2258 Measuring signal failure charge temperature t2(before trottle valve) A *)	(* NOT USED *)
	xMsg2258.Enable	   	:= FALSE;
	xMsg2258.Set       	:= FALSE;
	xMsg2258.PT		   	:= T#0s;
	xMsg2258.Prio	   	:= 3;
	xMsg2258.RiskClass 	:= 4;
	xMsg2258.Reset	   	:= FALSE;
	xMsg2258();
	MM2VIS.bMsg2258		:= xMsg2258.Q;

	(* A2259 Measuring signal failure charge temperature t2(before trottle valve) B *)	(* NOT USED *)
	xMsg2259.Enable	   	:= FALSE;
	xMsg2259.Set       	:= FALSE;
	xMsg2259.PT		   	:= T#0s;
	xMsg2259.Prio	   	:= 3;
	xMsg2259.RiskClass 	:= 4;
	xMsg2259.Reset	   	:= FALSE;
	xMsg2259();
	MM2VIS.bMsg2259		:= xMsg2259.Q;

	(* A2278  turbocharger speed maximum  *) 
	xMsg2278.Enable	   	:= TRUE;
	xMsg2278.Set       	:= bAMM_N_TCHP_HiHi AND NOT Para.bTSTC_Exist;
	xMsg2278.PT		   	:= T#0s;
	xMsg2278.Prio	   	:= 3;
	xMsg2278.RiskClass 	:= 4;
	xMsg2278.Reset	   	:= FALSE;
	xMsg2278();
	MM2VIS.bMsg2278		:= xMsg2278.Q;	

	(* A2279  turbocharger speed deviation maximum  *) 
	xMsg2279.Enable	   	:= TRUE;
	xMsg2279.Set       	:= bAMM_N_TCHP_Diff_HiHi AND NOT Para.bTSTC_Exist;
	xMsg2279.PT		   	:= T#60s;
	xMsg2279.Prio	   	:= 3;
	xMsg2279.RiskClass 	:= 4;
	xMsg2279.Reset	   	:= FALSE;
	xMsg2279();
	MM2VIS.bMsg2279		:= xMsg2279.Q;	

	(* A2280 Measuring signal failure charge temperature before high-pressure TC	*) 
	xMsg2280.Enable	   	:= NOT xEngType.Type9;		//SWAT920/2
	xMsg2280.Set       	:= bAMM_T_Ch_T1HP_MsMs AND Para.bTSTC_Exist AND NOT IN_CH.tEng_Run.Do;
	xMsg2280.PT		   	:= T#0s;
	xMsg2280.Prio	   	:= 3;
	xMsg2280.RiskClass 	:= 4;
	xMsg2280.Reset	   	:= FALSE;
	xMsg2280();
	MM2VIS.bMsg2280		:= xMsg2280.Q;	

	(* A2317 Charge temperature before TC maximum (only if no low-pressure TC exist) *)		(* NOT USED >= v4.12 *)
	xMsg2317.Enable	   	:= FALSE;
	xMsg2317.Set      	:= FALSE;
	xMsg2317.PT		  	:= T#2s;
	xMsg2317.Prio	  	:= 3;
	xMsg2317.RiskClass	:= 4;
	xMsg2317.Reset	  	:= FALSE;
	xMsg2317();
	MM2VIS.bMsg2317		:= xMsg2317.Q;

	(* A2318 Measuring signal failure charge temperature before TC (only if no low-pressure TC exist) *) 
	xMsg2318.Enable	   	:= TRUE;
	xMsg2318.Set       	:= bAMM_T_Ch_T1HP_MsMs AND NOT Para.bTSTC_Exist AND NOT IN_CH.tEng_Run.Do;
	xMsg2318.PT		   	:= T#0s;
	xMsg2318.Prio	   	:= 3;
	xMsg2318.RiskClass 	:= 4;
	xMsg2318.Reset	   	:= FALSE;
	xMsg2318();
	MM2VIS.bMsg2318		:= xMsg2318.Q;	

	(* A2324 Charge temperature before turbocharger (air intake) maximum *)					(* NOT USED >= v4.12 *)
	xMsg2324.Enable	   	:= FALSE;
	xMsg2324.Set       	:= FALSE;
	xMsg2324.PT		   	:= T#2s;
	xMsg2324.Prio	   	:= 3;
	xMsg2324.RiskClass 	:= 4;
	xMsg2324.Reset	   	:= FALSE;
	xMsg2324();
	MM2VIS.bMsg2324		:= xMsg2324.Q;	

	(* A2325 Measuring signal failure, turbocharger speed (only if no low-pressure TC exist) *)
	xMsg2325.Enable	   	:= TRUE;
	xMsg2325.Set       	:= bAMM_N_TCHP_MsMs AND NOT Para.bTSTC_Exist;
	xMsg2325.PT		   	:= T#10s;
	xMsg2325.Prio	   	:= 3;
	xMsg2325.RiskClass 	:= 4;
	xMsg2325.Reset	   	:= FALSE;
	xMsg2325();
	MM2VIS.bMsg2325		:= xMsg2325.Q;	

	(* A2326 Measuring signal failure, high pressure turbocharger speed *)
	xMsg2326.Enable	   	:= TRUE;
	xMsg2326.Set       	:= bAMM_N_TCHP_MsMs AND 	Para.bTSTC_Exist;
	xMsg2326.PT		   	:= T#10s;
	xMsg2326.Prio	   	:= 3;
	xMsg2326.RiskClass 	:= 4;
	xMsg2326.Reset	   	:= FALSE;
	xMsg2326();
	MM2VIS.bMsg2326		:= xMsg2326.Q;	

	(* A2327 Measuring signal failure, low pressure turbocharger speed *)
	xMsg2327.Enable	   	:= TRUE;
	xMsg2327.Set       	:= bAMM_N_TCLP_MsMs;
	xMsg2327.PT		   	:= T#10s;
	xMsg2327.Prio	   	:= 3;
	xMsg2327.RiskClass 	:= 4;
	xMsg2327.Reset	   	:= FALSE;
	xMsg2327();
	MM2VIS.bMsg2327		:= xMsg2327.Q;	

	(* A2368 Charge temperature after high-pressure TC maximum *)
	xMsg2368.Enable	   	:= bStartSpd;
	xMsg2368.Set       	:= bAMM_T_Ch_T2HP_HiHi AND Para.bTSTC_Exist;
	xMsg2368.PT		   	:= T#60s;
	xMsg2368.Prio	   	:= 3;
	xMsg2368.RiskClass 	:= 4;
	xMsg2368.Reset	   	:= FALSE;
	xMsg2368();
	MM2VIS.bMsg2368		:= xMsg2368.Q;

	(* A2369 Charge temperature after TC maximum *)
	xMsg2369.Enable	   	:= bStartSpd;
	xMsg2369.Set       	:= bAMM_T_Ch_T2HP_HiHi AND NOT Para.bTSTC_Exist;
	xMsg2369.PT		   	:= T#60s;
	xMsg2369.Prio	   	:= 3;
	xMsg2369.RiskClass 	:= 4;
	xMsg2369.Reset	   	:= FALSE;
	xMsg2369();
	MM2VIS.bMsg2369		:= xMsg2369.Q;

	(* A2370 Charge temperature after low-pressure TC maximum *)
	xMsg2370.Enable	   	:= bStartSpd;
	xMsg2370.Set       	:= bAMM_T_Ch_T2LP_HiHi;
	xMsg2370.PT		   	:= T#60s;
	xMsg2370.Prio	   	:= 3;
	xMsg2370.RiskClass 	:= 4;
	xMsg2370.Reset	   	:= FALSE;
	xMsg2370();
	MM2VIS.bMsg2370		:= xMsg2370.Q;

	(* W2407 Measuring signal failure charge pressure after high-pressure turbocharger A *)
	xMsg2407.Enable	   	:= TRUE;
	xMsg2407.Set       	:= bAMM_Pr_Ch_P2HP_A_Ms AND Para.bTSTC_Exist;
	xMsg2407.PT		   	:= T#0s;
	xMsg2407.Prio	   	:= 4;
	xMsg2407.RiskClass 	:= 4;
	xMsg2407.Reset	   	:= FALSE;
	xMsg2407();
	MM2VIS.bMsg2407		:= xMsg2407.Q;	
		
	(* W2408 Measuring signal failure charge pressure after high-pressure turbocharger B *)
	xMsg2408.Enable	   	:= TRUE;
	xMsg2408.Set       	:= bAMM_Pr_Ch_P2HP_B_Ms AND Para.bTSTC_Exist;
	xMsg2408.PT		   	:= T#0s;
	xMsg2408.Prio	   	:= 4;
	xMsg2408.RiskClass 	:= 4;
	xMsg2408.Reset	   	:= FALSE;
	xMsg2408();
	MM2VIS.bMsg2408		:= xMsg2408.Q;	
		
	(* W2409 Measuring signal failure charge pressure after low-pressure turbocharger A	*)
	xMsg2409.Enable	   	:= TRUE;
	xMsg2409.Set       	:= bAMM_Pr_Ch_P2LP_A_Ms;
	xMsg2409.PT		   	:= T#0s;
	xMsg2409.Prio	   	:= 4;
	xMsg2409.RiskClass 	:= 4;
	xMsg2409.Reset	   	:= FALSE;
	xMsg2409();
	MM2VIS.bMsg2409		:= xMsg2409.Q;	
		
	(* W2410 Measuring signal failure charge pressure after low-pressure turbocharger B	*)
	xMsg2410.Enable	   	:= TRUE;
	xMsg2410.Set       	:= bAMM_Pr_Ch_P2LP_B_Ms;
	xMsg2410.PT		   	:= T#0s;
	xMsg2410.Prio	   	:= 4;
	xMsg2410.RiskClass 	:= 4;
	xMsg2410.Reset	   	:= FALSE;
	xMsg2410();
	MM2VIS.bMsg2410		:= xMsg2410.Q;	

	(* W2411 Measuring signal failure, charge temperature before turbocharger (air intake)	*)
	xMsg2411.Enable	   	:= TRUE;
	xMsg2411.Set       	:= bAMM_T_Ch_T1LP_Ms;
	xMsg2411.PT		   	:= T#0s;
	xMsg2411.Prio	   	:= 4;
	xMsg2411.RiskClass 	:= 4;
	xMsg2411.Reset	   	:= FALSE;
	xMsg2411();
	MM2VIS.bMsg2411		:= xMsg2411.Q;	

	(* W2412 Charge temperature before turbocharger (air intake) maximum *)					(* NOT USED >= v4.12 *)
	xMsg2412.Enable	   	:= FALSE;
	xMsg2412.Set       	:= FALSE;
	xMsg2412.PT		   	:= T#2s;
	xMsg2412.Prio	   	:= 4;
	xMsg2412.RiskClass 	:= 4;
	xMsg2412.Reset	   	:= FALSE;
	xMsg2412();
	MM2VIS.bMsg2412		:= xMsg2412.Q;	

	(* W2413 Measuring signal failure, charge temperature before turbocharger (air intake) A *)
	xMsg2413.Enable	   	:= TRUE;
	xMsg2413.Set       	:= bAMM_T_Ch_T1LP_A_Ms;
	xMsg2413.PT		   	:= T#0s;
	xMsg2413.Prio	   	:= 4;
	xMsg2413.RiskClass 	:= 4;
	xMsg2413.Reset	   	:= FALSE;
	xMsg2413();
	MM2VIS.bMsg2413		:= xMsg2413.Q;	

	(* W2414 Measuring signal failure, charge temperature before turbocharger (air intake) B *)
	xMsg2414.Enable	   	:= TRUE;
	xMsg2414.Set       	:= bAMM_T_Ch_T1LP_B_Ms;
	xMsg2414.PT		   	:= T#0s;
	xMsg2414.Prio	   	:= 4;
	xMsg2414.RiskClass 	:= 4;
	xMsg2414.Reset	   	:= FALSE;
	xMsg2414();
	MM2VIS.bMsg2414		:= xMsg2414.Q;	

	(* W2436 Charge temperature t2' A maximum *)	(* NOT USED *)
	xMsg2436.Enable	   	:= FALSE;
	xMsg2436.Set       	:= FALSE;
	xMsg2436.PT		   	:= T#0s;
	xMsg2436.Prio	   	:= 4;
	xMsg2436.RiskClass 	:= 4;
	xMsg2436.Reset	   	:= FALSE;
	xMsg2436();
	MM2VIS.bMsg2436		:= xMsg2436.Q;
	
	(* W2437 Charge temperature t2' B maximum *)	(* NOT USED *)
	xMsg2437.Enable	   	:= FALSE;
	xMsg2437.Set       	:= FALSE;
	xMsg2437.PT		   	:= T#0s;
	xMsg2437.Prio	   	:= 4;
	xMsg2437.RiskClass 	:= 4;
	xMsg2437.Reset	   	:= FALSE;
	xMsg2437();
	MM2VIS.bMsg2437		:= xMsg2437.Q;	
	
	(* W2460 Measuring signal failure charge temperature before high-pressure TC A *)
	xMsg2460.Enable	   	:= TRUE;			
	xMsg2460.Set       	:= bAMM_T_Ch_T1HP_A_Ms AND Para.bTSTC_Exist;
	xMsg2460.PT		   	:= T#0s;
	xMsg2460.Prio	   	:= 4;
	xMsg2460.RiskClass 	:= 4;
	xMsg2460.Reset	   	:= FALSE;
	xMsg2460();
	MM2VIS.bMsg2460		:= xMsg2460.Q;
	
	(* W2461 Measuring signal failure charge temperature before high-pressure TC B *)
	xMsg2461.Enable	   	:= TRUE;			
	xMsg2461.Set       	:= bAMM_T_Ch_T1HP_B_Ms AND Para.bTSTC_Exist;
	xMsg2461.PT		   	:= T#0s;
	xMsg2461.Prio	   	:= 4;
	xMsg2461.RiskClass 	:= 4;
	xMsg2461.Reset	   	:= FALSE;
	xMsg2461();
	MM2VIS.bMsg2461		:= xMsg2461.Q;

	(* W2477 Charge temperature before TC minimum (only if no low-pressure TC exist) *)
	xMsg2477.Enable	   	:= TRUE;
	xMsg2477.Set       	:= bAMM_T_Ch_T1HP_Lo AND NOT Para.bTSTC_Exist;
	xMsg2477.PT		   	:= T#2s;
	xMsg2477.Prio	   	:= 4;
	xMsg2477.RiskClass 	:= 4;
	xMsg2477.Reset	   	:= FALSE;
	xMsg2477();
	MM2VIS.bMsg2477		:= xMsg2477.Q;
	
	(* W2478 Charge temperature before TC maximum (only if no low-pressure TC exist) *)		(* NOT USED >= v4.12 *)
	xMsg2478.Enable	   	:= FALSE;
	xMsg2478.Set       	:= FALSE;
	xMsg2478.PT		   	:= T#2s;
	xMsg2478.Prio	   	:= 4;
	xMsg2478.RiskClass 	:= 4;
	xMsg2478.Reset	   	:= FALSE;
	xMsg2478();
	MM2VIS.bMsg2478		:= xMsg2478.Q;
		
	(* W2479 Measuring signal failure charge temperature before TC A (only if no low-pressure TC exist) *)
	xMsg2479.Enable	   	:= TRUE;
	xMsg2479.Set       	:= bAMM_T_Ch_T1HP_A_Ms AND NOT Para.bTSTC_Exist;
	xMsg2479.PT		   	:= T#0s;
	xMsg2479.Prio	   	:= 4;
	xMsg2479.RiskClass 	:= 4;
	xMsg2479.Reset	   	:= FALSE;
	xMsg2479();
	MM2VIS.bMsg2479		:= xMsg2479.Q;	

	(* W2480 Measuring signal failure charge temperature before TC B (only if no low-pressure TC exist) *)
	xMsg2480.Enable	   	:= TRUE;
	xMsg2480.Set       	:= bAMM_T_Ch_T1HP_B_Ms AND NOT Para.bTSTC_Exist;
	xMsg2480.PT		   	:= T#0s;
	xMsg2480.Prio	   	:= 4;
	xMsg2480.RiskClass 	:= 4;
	xMsg2480.Reset	   	:= FALSE;
	xMsg2480();
	MM2VIS.bMsg2480		:= xMsg2480.Q;	

	(* W2481 Measuring signal failure charge temperature after low-pressure TC A *) 
	xMsg2481.Enable	   	:= TRUE;
	xMsg2481.Set       	:= bAMM_T_Ch_T2LP_A_Ms;
	xMsg2481.PT		   	:= T#0s;
	xMsg2481.Prio	   	:= 4;
	xMsg2481.RiskClass 	:= 4;
	xMsg2481.Reset	   	:= FALSE;
	xMsg2481();
	MM2VIS.bMsg2481		:= xMsg2481.Q;	

	(* W2482 Measuring signal failure charge temperature after low-pressure TC B *) 
	xMsg2482.Enable	   	:= TRUE;
	xMsg2482.Set       	:= bAMM_T_Ch_T2LP_B_Ms;
	xMsg2482.PT		   	:= T#0s;
	xMsg2482.Prio	   	:= 4;
	xMsg2482.RiskClass 	:= 4;
	xMsg2482.Reset	   	:= FALSE;
	xMsg2482();
	MM2VIS.bMsg2482		:= xMsg2482.Q;	

	(* W2483 Measuring signal failure charge temperature after high-pressure TC A *) 
	xMsg2483.Enable	   	:= TRUE;
	xMsg2483.Set       	:= bAMM_T_Ch_T2HP_A_Ms AND Para.bTSTC_Exist;
	xMsg2483.PT		   	:= T#0s;
	xMsg2483.Prio	   	:= 4;
	xMsg2483.RiskClass 	:= 4;
	xMsg2483.Reset	   	:= FALSE;
	xMsg2483();
	MM2VIS.bMsg2483		:= xMsg2483.Q;	

	(* W2484 Measuring signal failure charge temperature after high-pressure TC B *) 
	xMsg2484.Enable	   	:= TRUE;
	xMsg2484.Set       	:= bAMM_T_Ch_T2HP_B_Ms AND Para.bTSTC_Exist;
	xMsg2484.PT		   	:= T#0s;
	xMsg2484.Prio	   	:= 4;
	xMsg2484.RiskClass 	:= 4;
	xMsg2484.Reset	   	:= FALSE;
	xMsg2484();
	MM2VIS.bMsg2484		:= xMsg2484.Q;	
	
	(* W2485 Measuring signal failure charge temperature after TC A (only if no low-pressure TC exist) *) 
	xMsg2485.Enable	   	:= TRUE;
	xMsg2485.Set       	:= bAMM_T_Ch_T2HP_A_Ms AND NOT Para.bTSTC_Exist;
	xMsg2485.PT		   	:= T#0s;
	xMsg2485.Prio	   	:= 4;
	xMsg2485.RiskClass 	:= 4;
	xMsg2485.Reset	   	:= FALSE;
	xMsg2485();
	MM2VIS.bMsg2485		:= xMsg2485.Q;	

	(* W2486 Measuring signal failure charge temperature after TC B (only if no low-pressure TC exist) *) 
	xMsg2486.Enable	   	:= TRUE;
	xMsg2486.Set       	:= bAMM_T_Ch_T2HP_B_Ms AND NOT Para.bTSTC_Exist;
	xMsg2486.PT		   	:= T#0s;
	xMsg2486.Prio	   	:= 4;
	xMsg2486.RiskClass 	:= 4;
	xMsg2486.Reset	   	:= FALSE;
	xMsg2486();
	MM2VIS.bMsg2486		:= xMsg2486.Q;	

	(* W2489 Measuring signal failure charge temperature after low-pressure TC *) 
	xMsg2489.Enable	   	:= TRUE;
	xMsg2489.Set       	:= bAMM_T_Ch_T2LP_Ms;
	xMsg2489.PT		   	:= T#0s;
	xMsg2489.Prio	   	:= 4;
	xMsg2489.RiskClass 	:= 4;
	xMsg2489.Reset	   	:= FALSE;
	xMsg2489();
	MM2VIS.bMsg2489		:= xMsg2489.Q;	
	
	(* W2490 Measuring signal failure charge temperature after high-pressure TC *) 
	xMsg2490.Enable	   	:= TRUE;
	xMsg2490.Set       	:= bAMM_T_Ch_T2HP_Ms AND Para.bTSTC_Exist;
	xMsg2490.PT		   	:= T#0s;
	xMsg2490.Prio	   	:= 4;
	xMsg2490.RiskClass 	:= 4;
	xMsg2490.Reset	   	:= FALSE;
	xMsg2490();
	MM2VIS.bMsg2490		:= xMsg2490.Q;		
	
	(* W2491 Measuring signal failure charge temperature after TC (only if no low-pressure TC exist) *) 
	xMsg2491.Enable	   	:= TRUE;
	xMsg2491.Set       	:= bAMM_T_Ch_T2HP_Ms AND NOT Para.bTSTC_Exist;
	xMsg2491.PT		   	:= T#0s;
	xMsg2491.Prio	   	:= 4;
	xMsg2491.RiskClass 	:= 4;
	xMsg2491.Reset	   	:= FALSE;
	xMsg2491();
	MM2VIS.bMsg2491		:= xMsg2491.Q;			
	
	(* W2510 Charge temperature t2' A minimum	*)
	xMsg2510.Enable	   	:= TRUE;
	xMsg2510.Set       	:= bAMM_T_Ch_T2s_A_Lo;
	xMsg2510.PT		   	:= T#0s;
	xMsg2510.Prio	   	:= 4;
	xMsg2510.RiskClass 	:= 4;
	xMsg2510.Reset	   	:= FALSE;
	xMsg2510();
	MM2VIS.bMsg2510		:= xMsg2510.Q;

	(* W2511 Charge temperature t2' A maximum *)
	xMsg2511.Enable	   	:= TRUE;	
	xMsg2511.Set       	:= bAMM_T_Ch_T2s_A_Hi;
	xMsg2511.PT		   	:= T#0s;
	xMsg2511.Prio	   	:= 4;
	xMsg2511.RiskClass 	:= 4;
	xMsg2511.Reset	   	:= FALSE;
	xMsg2511();
	MM2VIS.bMsg2511		:= xMsg2511.Q;

	(* W2512 Charge temperature t2' B minimum *)
	xMsg2512.Enable	   	:= TRUE;			
	xMsg2512.Set       	:= bAMM_T_Ch_T2s_B_Lo;
	xMsg2512.PT		   	:= T#0s;
	xMsg2512.Prio	   	:= 4;
	xMsg2512.RiskClass 	:= 4;
	xMsg2512.Reset	   	:= FALSE;
	xMsg2512();
	MM2VIS.bMsg2512		:= xMsg2512.Q;

	(* W2513 Charge temperature t2' B maximum *)
	xMsg2513.Enable	   	:= TRUE;			
	xMsg2513.Set       	:= bAMM_T_Ch_T2s_B_Hi;
	xMsg2513.PT		   	:= T#0s;
	xMsg2513.Prio	   	:= 4;
	xMsg2513.RiskClass 	:= 4;
	xMsg2513.Reset	   	:= FALSE;
	xMsg2513();
	MM2VIS.bMsg2513		:= xMsg2513.Q;

	(* W2525 Charge temperature t2' deviation maximum *)
	xMsg2525.Enable	   	:= TRUE;
	xMsg2525.Set       	:= bAMM_T_Ch_T2s_DiffHi;
	xMsg2525.PT		   	:= T#0s;
	xMsg2525.Prio	   	:= 4;
	xMsg2525.RiskClass 	:= 4;
	xMsg2525.Reset	   	:= FALSE;
	xMsg2525();
	MM2VIS.bMsg2525		:= xMsg2525.Q;

	(* W2526 High pressure turbocharger speed maximum *)
	xMsg2526.Enable	   	:= TRUE;
	xMsg2526.Set       	:= bAMM_N_TCHP_Hi AND Para.bTSTC_Exist;
	xMsg2526.PT		   	:= T#0s;
	xMsg2526.Prio	   	:= 4;
	xMsg2526.RiskClass 	:= 4;
	xMsg2526.Reset	   	:= FALSE;
	xMsg2526();
	MM2VIS.bMsg2526		:= xMsg2526.Q;

	(* W2527 Low pressure turbocharger speed maximum *)
	xMsg2527.Enable	   	:= TRUE;
	xMsg2527.Set       	:= bAMM_N_TCLP_Hi;
	xMsg2527.PT		   	:= T#0s;
	xMsg2527.Prio	   	:= 4;
	xMsg2527.RiskClass 	:= 4;
	xMsg2527.Reset	   	:= FALSE;
	xMsg2527();
	MM2VIS.bMsg2527		:= xMsg2527.Q;

	(* W2528 High pressure turbocharger speed deviation maximum *)
	xMsg2528.Enable	   	:= TRUE;
	xMsg2528.Set       	:= bAMM_N_TCHP_Diff_Hi AND Para.bTSTC_Exist;
	xMsg2528.PT		   	:= T#5s;
	xMsg2528.Prio	   	:= 4;
	xMsg2528.RiskClass 	:= 4;
	xMsg2528.Reset	   	:= FALSE;
	xMsg2528();
	MM2VIS.bMsg2528		:= xMsg2528.Q;

	(* W2529 Low pressure turbocharger speed deviation maximum *)
	xMsg2529.Enable	   	:= TRUE;
	xMsg2529.Set       	:= bAMM_N_TCLP_Diff_Hi;
	xMsg2529.PT		   	:= T#5s;
	xMsg2529.Prio	   	:= 4;
	xMsg2529.RiskClass 	:= 4;
	xMsg2529.Reset	   	:= FALSE;
	xMsg2529();
	MM2VIS.bMsg2529		:= xMsg2529.Q;

	(* W2530 Charge pressure deviation high *)
	xMsg2530.Enable	   	:= TRUE;
	xMsg2530.Set       	:= bAMM_DPr_Ch_P2_Hi OR bAMM_DPr_Ch_P2s_Hi;
	xMsg2530.PT		   	:= T#0s;
	xMsg2530.Prio	   	:= 4;
	xMsg2530.RiskClass 	:= 4;
	xMsg2530.Reset	   	:= FALSE;
	xMsg2530();
	MM2VIS.bMsg2530		:= xMsg2530.Q;

	(* W2531 Charge temperature before high-pressure TC minimum *)
	xMsg2531.Enable	   	:= TRUE;
	xMsg2531.Set       	:= bAMM_T_Ch_T1HP_Lo AND Para.bTSTC_Exist;
	xMsg2531.PT		   	:= T#2s;
	xMsg2531.Prio	   	:= 4;
	xMsg2531.RiskClass 	:= 4;
	xMsg2531.Reset	   	:= FALSE;
	xMsg2531();
	MM2VIS.bMsg2531		:= xMsg2531.Q;

	(* W2532 Charge temperature before high-pressure TC inclination maximum *)	(* NOT USED *)
	xMsg2532.Enable	   	:= FALSE;
	xMsg2532.Set       	:= FALSE;
	xMsg2532.PT		   	:= T#0s;
	xMsg2532.Prio	   	:= 4;
	xMsg2532.RiskClass 	:= 4;
	xMsg2532.Reset	   	:= FALSE;
	xMsg2532();
	MM2VIS.bMsg2532		:= xMsg2532.Q;	
	
	(* W2533 Charge temperature before high-pressure TC maximum *)							(* NOT USED >= v4.12 *)
	xMsg2533.Enable	   	:= FALSE;
	xMsg2533.Set       	:= FALSE;
	xMsg2533.PT		   	:= T#2s;
	xMsg2533.Prio	   	:= 4;
	xMsg2533.RiskClass 	:= 4;
	xMsg2533.Reset	   	:= FALSE;
	xMsg2533();
	MM2VIS.bMsg2533		:= xMsg2533.Q;

	(* W2539 Measuring signal failure charge pressure p2' A *)
	xMsg2539.Enable	   	:= TRUE;
	xMsg2539.Set       	:= bAMM_Pr_Ch_P2s_A_Ms;
	xMsg2539.PT		   	:= T#0s;
	xMsg2539.Prio	   	:= 4;
	xMsg2539.RiskClass 	:= 4;
	xMsg2539.Reset	   	:= FALSE;
	xMsg2539();
	MM2VIS.bMsg2539		:= xMsg2539.Q;

	(* W2540 Measuring signal failure charge pressure p2' B *)
	xMsg2540.Enable	   	:= TRUE;
	xMsg2540.Set       	:= bAMM_Pr_Ch_P2s_B_Ms;
	xMsg2540.PT		   	:= T#0s;
	xMsg2540.Prio	   	:= 4;
	xMsg2540.RiskClass 	:= 4;
	xMsg2540.Reset	   	:= FALSE;
	xMsg2540();
	MM2VIS.bMsg2540		:= xMsg2540.Q;

	(* W2541 Measuring signal failure charge pressure p2 (before trottle valve) A *)
	xMsg2541.Enable	   	:= TRUE;
	xMsg2541.Set       	:= bAMM_Pr_Ch_P2_A_Ms;
	xMsg2541.PT		   	:= T#0s;
	xMsg2541.Prio	   	:= 4;
	xMsg2541.RiskClass 	:= 4;
	xMsg2541.Reset	   	:= FALSE;
	xMsg2541();
	MM2VIS.bMsg2541		:= xMsg2541.Q;

	(* W2543 Measuring signal failure charge pressure p2 (before trottle valve) B *)
	xMsg2543.Enable	   	:= TRUE;
	xMsg2543.Set       	:= bAMM_Pr_Ch_P2_B_Ms;
	xMsg2543.PT		   	:= T#0s;
	xMsg2543.Prio	   	:= 4;
	xMsg2543.RiskClass 	:= 4;
	xMsg2543.Reset	   	:= FALSE;
	xMsg2543();
	MM2VIS.bMsg2543		:= xMsg2543.Q;

	(* W2548 Measuring signal failure air inlet filter difference pressure A *)
	xMsg2548.Enable	   	:= TRUE;
	xMsg2548.Set       	:= bAMM_DPr_AirFilt_A_Ms;
	xMsg2548.PT		   	:= T#10s;
	xMsg2548.Prio	   	:= 4;
	xMsg2548.RiskClass 	:= 4;
	xMsg2548.Reset	   	:= FALSE;
	xMsg2548();
	MM2VIS.bMsg2548		:= xMsg2548.Q;

	(* W2550 Measuring signal failure air inlet filter difference pressure B *)
	xMsg2550.Enable	   	:= TRUE;
	xMsg2550.Set       	:= bAMM_DPr_AirFilt_B_Ms;
	xMsg2550.PT		   	:= T#10s;
	xMsg2550.Prio	   	:= 4;
	xMsg2550.RiskClass 	:= 4;
	xMsg2550.Reset	   	:= FALSE;
	xMsg2550();
	MM2VIS.bMsg2550		:= xMsg2550.Q;

	(* W2563 Measuring signal failure high-pressure turbocharger speed A *)
	xMsg2563.Enable	   	:= TRUE;
	xMsg2563.Set       	:= bAMM_N_TCHP_A_Ms AND Para.bTSTC_Exist;
	xMsg2563.PT		   	:= T#10s;
	xMsg2563.Prio	   	:= 4;
	xMsg2563.RiskClass 	:= 4;
	xMsg2563.Reset	   	:= FALSE;
	xMsg2563();
	MM2VIS.bMsg2563		:= xMsg2563.Q;

	(* W2564 Measuring signal failure high-pressure turbocharger speed B *)
	xMsg2564.Enable	   	:= TRUE;
	xMsg2564.Set       	:= bAMM_N_TCHP_B_Ms AND Para.bTSTC_Exist;
	xMsg2564.PT		   	:= T#10s;
	xMsg2564.Prio	   	:= 4;
	xMsg2564.RiskClass 	:= 4;
	xMsg2564.Reset	   	:= FALSE;
	xMsg2564();
	MM2VIS.bMsg2564		:= xMsg2564.Q;

	(* W2565 Measuring signal failure low-pressure turbocharger speed A *)
	xMsg2565.Enable	   	:= TRUE;
	xMsg2565.Set       	:= bAMM_N_TCLP_A_Ms;
	xMsg2565.PT		   	:= T#10s;
	xMsg2565.Prio	   	:= 4;
	xMsg2565.RiskClass 	:= 4;
	xMsg2565.Reset	   	:= FALSE;
	xMsg2565();
	MM2VIS.bMsg2565		:= xMsg2565.Q;

	(* W2566 Measuring signal failure low-pressure turbocharger speed B *)
	xMsg2566.Enable	   	:= TRUE;
	xMsg2566.Set       	:= bAMM_N_TCLP_B_Ms;
	xMsg2566.PT		   	:= T#10s;
	xMsg2566.Prio	   	:= 4;
	xMsg2566.RiskClass 	:= 4;
	xMsg2566.Reset	   	:= FALSE;
	xMsg2566();
	MM2VIS.bMsg2566		:= xMsg2566.Q;

	(* W2611 Measuring signal failure charge pressure before high-pressure TC A *)
	xMsg2611.Enable	   	:= TRUE;
	xMsg2611.Set       	:= bAMM_Pr_Ch_P1HP_A_Ms AND Para.bTSTC_Exist;
	xMsg2611.PT		   	:= T#0s;
	xMsg2611.Prio	   	:= 4;
	xMsg2611.RiskClass 	:= 4;
	xMsg2611.Reset	   	:= FALSE;
	xMsg2611();
	MM2VIS.bMsg2611		:= xMsg2611.Q;

	(* W2612 Measuring signal failure charge pressure before high-pressure TC B *)
	xMsg2612.Enable	   	:= TRUE;
	xMsg2612.Set       	:= bAMM_Pr_Ch_P1HP_B_Ms AND Para.bTSTC_Exist;
	xMsg2612.PT		   	:= T#0s;
	xMsg2612.Prio	   	:= 4;
	xMsg2612.RiskClass 	:= 4;
	xMsg2612.Reset	   	:= FALSE;
	xMsg2612();
	MM2VIS.bMsg2612		:= xMsg2612.Q;

	(* W2614 turbocharger speed deviation maximum *)
	xMsg2614.Enable	   	:= TRUE;
	xMsg2614.Set       	:= bAMM_N_TCHP_Diff_Hi AND NOT Para.bTSTC_Exist;
	xMsg2614.PT		   	:= T#5s;
	xMsg2614.Prio	   	:= 4;
	xMsg2614.RiskClass 	:= 4;
	xMsg2614.Reset	   	:= FALSE;
	xMsg2614();
	MM2VIS.bMsg2614		:= xMsg2614.Q;

	(* W2615 Measuring signal failure turbocharger speed	*)
	xMsg2615.Enable	   	:= TRUE;
	xMsg2615.Set       	:= bAMM_N_TCHP_Ms AND NOT Para.bTSTC_Exist;
	xMsg2615.PT		   	:= T#10s;
	xMsg2615.Prio	   	:= 4;
	xMsg2615.RiskClass 	:= 4;
	xMsg2615.Reset	   	:= FALSE;
	xMsg2615();
	MM2VIS.bMsg2615		:= xMsg2615.Q;

	(* W2616 Measuring signal failure high-pressure turbocharger speed	*)
	xMsg2616.Enable	   	:= TRUE;
	xMsg2616.Set       	:= bAMM_N_TCHP_Ms AND Para.bTSTC_Exist;
	xMsg2616.PT		   	:= T#10s;
	xMsg2616.Prio	   	:= 4;
	xMsg2616.RiskClass 	:= 4;
	xMsg2616.Reset	   	:= FALSE;
	xMsg2616();
	MM2VIS.bMsg2616		:= xMsg2616.Q;

	(* W2617 Measuring signal failure low-pressure turbocharger speed *)
	xMsg2617.Enable	   	:= TRUE;
	xMsg2617.Set       	:= bAMM_N_TCLP_Ms;
	xMsg2617.PT		   	:= T#10s;
	xMsg2617.Prio	   	:= 4;
	xMsg2617.RiskClass 	:= 4;
	xMsg2617.Reset	   	:= FALSE;
	xMsg2617();
	MM2VIS.bMsg2617		:= xMsg2617.Q;

	(* W2618 Measuring signal failure charge pressure before high-pressure TC *)
	xMsg2618.Enable	   	:= TRUE;
	xMsg2618.Set       	:= bAMM_Pr_Ch_P1HP_Ms AND Para.bTSTC_Exist;
	xMsg2618.PT		   	:= T#0s;
	xMsg2618.Prio	   	:= 4;
	xMsg2618.RiskClass 	:= 4;
	xMsg2618.Reset	   	:= FALSE;
	xMsg2618();
	MM2VIS.bMsg2618		:= xMsg2618.Q;

	(* W2619 Measuring signal failure charge temperature t2' A *)
	xMsg2619.Enable	   	:= TRUE;
	xMsg2619.Set       	:= bAMM_T_Ch_T2s_A_Ms;
	xMsg2619.PT		   	:= T#0s;
	xMsg2619.Prio	   	:= 4;
	xMsg2619.RiskClass 	:= 4;
	xMsg2619.Reset	   	:= FALSE;
	xMsg2619();
	MM2VIS.bMsg2619		:= xMsg2619.Q;

	(* W2620 Measuring signal failure charge temperature t2' B *)
	xMsg2620.Enable	   	:= TRUE;
	xMsg2620.Set       	:= bAMM_T_Ch_T2s_B_Ms;
	xMsg2620.PT		   	:= T#0s;
	xMsg2620.Prio	   	:= 4;
	xMsg2620.RiskClass 	:= 4;
	xMsg2620.Reset	   	:= FALSE;
	xMsg2620();
	MM2VIS.bMsg2620		:= xMsg2620.Q;

	(* W2621  Measuring signal failure charge air filter difference pressure  *)
	xMsg2621.Enable	   	:= TRUE;
	xMsg2621.Set       	:= bAMM_DPr_AirFilt_Ms;
	xMsg2621.PT		   	:= T#10s;
	xMsg2621.Prio	   	:= 4;
	xMsg2621.RiskClass 	:= 4;
	xMsg2621.Reset	   	:= FALSE;
	xMsg2621();
	MM2VIS.bMsg2621		:= xMsg2621.Q;	

	(* W2626  Charge air filter difference pressure low  *)
	xMsg2626.Enable	   	:= TRUE;
	xMsg2626.Set       	:= bAMM_DPr_AirFilt_Lo;
	xMsg2626.PT		   	:= T#2m;
	xMsg2626.Prio	   	:= 4;
	xMsg2626.RiskClass 	:= 4;
	xMsg2626.Reset	   	:= FALSE;
	xMsg2626();
	MM2VIS.bMsg2626		:= xMsg2626.Q;	
	
    (* W2668  Measuring signal failure charge pressure after low-pressure turbocharger  *)
	xMsg2668.Enable	   	:= TRUE;
	xMsg2668.Set       	:= bAMM_Pr_Ch_P2LP_Ms;
	xMsg2668.PT		   	:= T#0s;
	xMsg2668.Prio	   	:= 4;
	xMsg2668.RiskClass 	:= 4;
	xMsg2668.Reset	   	:= FALSE;
	xMsg2668();
	MM2VIS.bMsg2668		:= xMsg2668.Q;	
	
    (* W2669  Measuring signal failure charge pressure after high-pressure turbocharger  *)
	xMsg2669.Enable	   	:= TRUE;
	xMsg2669.Set       	:= bAMM_Pr_Ch_P2HP_Ms AND Para.bTSTC_Exist;
	xMsg2669.PT		   	:= T#0s;
	xMsg2669.Prio	   	:= 4;
	xMsg2669.RiskClass 	:= 4;
	xMsg2669.Reset	   	:= FALSE;
	xMsg2669();
	MM2VIS.bMsg2669		:= xMsg2669.Q;	
	
    (* W2670  Measuring signal failure charge pressure before flame arrester  *)
	xMsg2670.Enable	   	:= TRUE;
	xMsg2670.Set       	:= bAMM_Pr_Ch_P2bFA_Ms;
	xMsg2670.PT		   	:= T#0s;
	xMsg2670.Prio	   	:= 4;
	xMsg2670.RiskClass 	:= 4;
	xMsg2670.Reset	   	:= FALSE;
	xMsg2670();
	MM2VIS.bMsg2670		:= xMsg2670.Q;	
	
    (* W2671  Differential pressure over low-pressure charge cooler - Maximum  *)
	xMsg2671.Enable	   	:= TRUE;
	xMsg2671.Set       	:= bAMM_DPr_Ch_LPCooler_Hi;
	xMsg2671.PT		   	:= T#0s;
	xMsg2671.Prio	   	:= 4;
	xMsg2671.RiskClass 	:= 4;
	xMsg2671.Reset	   	:= FALSE;
	xMsg2671();
	MM2VIS.bMsg2671		:= xMsg2671.Q;
	
    (* W2672  Differential pressure over high-pressure charge cooler - Maximum  *)
	xMsg2672.Enable	   	:= TRUE;
	xMsg2672.Set       	:= bAMM_DPr_Ch_HPCooler_Hi AND Para.bTSTC_Exist;
	xMsg2672.PT		   	:= T#0s;
	xMsg2672.Prio	   	:= 4;
	xMsg2672.RiskClass 	:= 4;
	xMsg2672.Reset	   	:= FALSE;
	xMsg2672();
	MM2VIS.bMsg2672		:= xMsg2672.Q;	
	
    (* W2673  Differential pressure over flame arrester - Maximum  *)
	xMsg2673.Enable	   	:= TRUE;
	xMsg2673.Set       	:= bAMM_DPr_Ch_FA_Hi;
	xMsg2673.PT		   	:= T#0s;
	xMsg2673.Prio	   	:= 4;
	xMsg2673.RiskClass 	:= 4;
	xMsg2673.Reset	   	:= FALSE;
	xMsg2673();
	MM2VIS.bMsg2673		:= xMsg2673.Q;

	(* W2700 Charge air filter difference pressure high *)
	xMsg2700.Enable	   	:= TRUE;
	xMsg2700.Set       	:= bAMM_DPr_AirFilt_Hi;
	xMsg2700.PT		   	:= T#2m;
	xMsg2700.Prio	   	:= 4;
	xMsg2700.RiskClass 	:= 4;
	xMsg2700.Reset	   	:= FALSE;
	xMsg2700();
	MM2VIS.bMsg2700		:= xMsg2700.Q;

	(* W2779 Charge pressure before low-pressure turbocharger measuring signal failure A *)
	xMsg2779.Enable	   	:= TRUE;
	xMsg2779.Set       	:= bAMM_Pr_Ch_P1LP_A_Ms;
	xMsg2779.PT		   	:= T#0s;
	xMsg2779.Prio	   	:= 4;
	xMsg2779.RiskClass 	:= 4;
	xMsg2779.Reset	   	:= FALSE;
	xMsg2779();
	MM2VIS.bMsg2779		:= xMsg2779.Q;

	(* W2780 Charge pressure before low-pressure turbocharger measuring signal failure B *)
	xMsg2780.Enable	   	:= TRUE;
	xMsg2780.Set       	:= bAMM_Pr_Ch_P1LP_B_Ms;
	xMsg2780.PT		   	:= T#0s;
	xMsg2780.Prio	   	:= 4;
	xMsg2780.RiskClass 	:= 4;
	xMsg2780.Reset	   	:= FALSE;
	xMsg2780();
	MM2VIS.bMsg2780		:= xMsg2780.Q;
	
	(* W3411 Charge temperature t2' maximum *)
	xMsg3411.Enable	   	:= TRUE;			
	xMsg3411.Set       	:= bAMM_T_Ch_T2s_Hi;
	xMsg3411.PT		   	:= T#0s;
	xMsg3411.Prio	   	:= 4;
	xMsg3411.RiskClass 	:= 4;
	xMsg3411.Reset	   	:= FALSE;
	xMsg3411();
	MM2VIS.bMsg3411		:= xMsg3411.Q;

	(* W3522 Measuring signal failure turbocharger speed A  *)
	xMsg3522.Enable	   	:= TRUE;
	xMsg3522.Set       	:= bAMM_N_TCHP_A_Ms AND NOT Para.bTSTC_Exist;
	xMsg3522.PT		   	:= T#10s;
	xMsg3522.Prio	   	:= 4;
	xMsg3522.RiskClass 	:= 4;
	xMsg3522.Reset	   	:= FALSE;
	xMsg3522();
	MM2VIS.bMsg3522		:= xMsg3522.Q;

	(* W3523 Measuring signal failure turbocharger speed B *)
	xMsg3523.Enable	   	:= TRUE;
	xMsg3523.Set       	:= bAMM_N_TCHP_B_Ms AND NOT Para.bTSTC_Exist;
	xMsg3523.PT		   	:= T#10s;
	xMsg3523.Prio	   	:= 4;
	xMsg3523.RiskClass 	:= 4;
	xMsg3523.Reset	   	:= FALSE;
	xMsg3523();
	MM2VIS.bMsg3523		:= xMsg3523.Q;

	(* W3524 Turbocharger speed maximum  *)
	xMsg3524.Enable	   	:= TRUE;
	xMsg3524.Set       	:= bAMM_N_TCHP_Hi AND NOT Para.bTSTC_Exist;
	xMsg3524.PT		   	:= T#0s;
	xMsg3524.Prio	   	:= 4;
	xMsg3524.RiskClass 	:= 4;
	xMsg3524.Reset	   	:= FALSE;
	xMsg3524();
	MM2VIS.bMsg3524		:= xMsg3524.Q;

	(* W3562 Charge temperature t2' minimum *)
	xMsg3562.Enable	   	:= TRUE;					
	xMsg3562.Set       	:= bAMM_T_Ch_T2s_Lo;
	xMsg3562.PT		   	:= T#0s;
	xMsg3562.Prio	   	:= 4;
	xMsg3562.RiskClass 	:= 4;
	xMsg3562.Reset	   	:= FALSE;
	xMsg3562();
	MM2VIS.bMsg3562		:= xMsg3562.Q;

	(* W3597 Charge air filter difference pressure  low A *)
	xMsg3597.Enable	   	:= TRUE;					
	xMsg3597.Set       	:= bAMM_DPr_AirFilt_A_Lo;
	xMsg3597.PT		   	:= T#2m;
	xMsg3597.Prio	   	:= 4;
	xMsg3597.RiskClass 	:= 4;
	xMsg3597.Reset	   	:= FALSE;
	xMsg3597();
	MM2VIS.bMsg3597		:= xMsg3597.Q;

	(* W3598 Charge air filter difference pressure high A *)
	xMsg3598.Enable	   	:= TRUE;					
	xMsg3598.Set       	:= bAMM_DPr_AirFilt_A_Hi;
	xMsg3598.PT		   	:= T#2m;
	xMsg3598.Prio	   	:= 4;
	xMsg3598.RiskClass 	:= 4;
	xMsg3598.Reset	   	:= FALSE;
	xMsg3598();
	MM2VIS.bMsg3598		:= xMsg3598.Q;

	(* W3599 Charge air filter difference pressure  low B *)
	xMsg3599.Enable	   	:= TRUE;					
	xMsg3599.Set       	:= bAMM_DPr_AirFilt_B_Lo;
	xMsg3599.PT		   	:= T#2m;
	xMsg3599.Prio	   	:= 4;
	xMsg3599.RiskClass 	:= 4;
	xMsg3599.Reset	   	:= FALSE;
	xMsg3599();
	MM2VIS.bMsg3599		:= xMsg3599.Q;

	(* W3600 Charge air filter difference pressure high B *)
	xMsg3600.Enable	   	:= TRUE;					
	xMsg3600.Set       	:= bAMM_DPr_AirFilt_B_Hi;
	xMsg3600.PT		   	:= T#2m;
	xMsg3600.Prio	   	:= 4;
	xMsg3600.RiskClass 	:= 4;
	xMsg3600.Reset	   	:= FALSE;
	xMsg3600();
	MM2VIS.bMsg3600		:= xMsg3600.Q;

    (* W9237 Measuring signal failure, charge pressure after turbocharger *)
	xMsg9237.Enable	   	:= TRUE;
	xMsg9237.Set       	:= bAMM_Pr_Ch_P2HP_Ms AND NOT Para.bTSTC_Exist;
	xMsg9237.PT		   	:= T#0s;
	xMsg9237.Prio	   	:= 4;
	xMsg9237.RiskClass 	:= 4;
	xMsg9237.Reset	   	:= FALSE;
	xMsg9237();
	MM2VIS.bMsg9237		:= xMsg9237.Q;

	(* W9238 Measuring signal failure, charge pressure after turbocharger A *)
	xMsg9238.Enable	   	:= TRUE;
	xMsg9238.Set       	:= bAMM_Pr_Ch_P2HP_A_Ms AND NOT Para.bTSTC_Exist;
	xMsg9238.PT		   	:= T#0s;
	xMsg9238.Prio	   	:= 4;
	xMsg9238.RiskClass 	:= 4;
	xMsg9238.Reset	   	:= FALSE;
	xMsg9238();
	MM2VIS.bMsg9238		:= xMsg9238.Q;
		
	(* W9239 Measuring signal failure, charge pressure after turbocharger B *)
	xMsg9239.Enable	   	:= TRUE;
	xMsg9239.Set       	:= bAMM_Pr_Ch_P2HP_B_Ms AND NOT Para.bTSTC_Exist;
	xMsg9239.PT		   	:= T#0s;
	xMsg9239.Prio	   	:= 4;
	xMsg9239.RiskClass 	:= 4;
	xMsg9239.Reset	   	:= FALSE;
	xMsg9239();
	MM2VIS.bMsg9239		:= xMsg9239.Q;

	(* W9240 Measuring signal failure, charge pressure before turbocharger *)
	xMsg9240.Enable	   	:= TRUE;
	xMsg9240.Set       	:= bAMM_Pr_Ch_P1HP_Ms AND NOT Para.bTSTC_Exist;
	xMsg9240.PT		   	:= T#0s;
	xMsg9240.Prio	   	:= 4;
	xMsg9240.RiskClass 	:= 4;
	xMsg9240.Reset	   	:= FALSE;
	xMsg9240();
	MM2VIS.bMsg9240		:= xMsg9240.Q;

	(* W9241 Measuring signal failure, charge pressure before turbocharger A *)
	xMsg9241.Enable	   	:= TRUE;
	xMsg9241.Set       	:= bAMM_Pr_Ch_P1HP_A_Ms AND NOT Para.bTSTC_Exist;
	xMsg9241.PT		   	:= T#0s;
	xMsg9241.Prio	   	:= 4;
	xMsg9241.RiskClass 	:= 4;
	xMsg9241.Reset	   	:= FALSE;
	xMsg9241();
	MM2VIS.bMsg9241		:= xMsg9241.Q;

	(* W9242 Measuring signal failure, charge pressure before turbocharger B *)
	xMsg9242.Enable	   	:= TRUE;
	xMsg9242.Set       	:= bAMM_Pr_Ch_P1HP_B_Ms AND NOT Para.bTSTC_Exist;
	xMsg9242.PT		   	:= T#0s;
	xMsg9242.Prio	   	:= 4;
	xMsg9242.RiskClass 	:= 4;
	xMsg9242.Reset	   	:= FALSE;
	xMsg9242();
	MM2VIS.bMsg9242		:= xMsg9242.Q;

    (* W9243  Charge cooler differential pressure high  *)
	xMsg9243.Enable	   	:= TRUE;
	xMsg9243.Set       	:= bAMM_DPr_Ch_HPCooler_Hi AND NOT Para.bTSTC_Exist;
	xMsg9243.PT		   	:= T#0s;
	xMsg9243.Prio	   	:= 4;
	xMsg9243.RiskClass 	:= 4;
	xMsg9243.Reset	   	:= FALSE;
	xMsg9243();
	MM2VIS.bMsg9243		:= xMsg9243.Q;	

    (* W9370 Intercooler inlet temperature not definable  *)
	xMsg9370.Enable	   	:= bRelModul_Sys_Run;
	xMsg9370.Set       	:= bAMM_T_Ch_T2_Calc;
	xMsg9370.PT		   	:= T#0s;
	xMsg9370.Prio	   	:= 4;
	xMsg9370.RiskClass 	:= 4;
	xMsg9370.Reset	   	:= FALSE;
	xMsg9370();
	MM2VIS.bMsg9370		:= xMsg9370.Q;	

	(* W9399 Charge pressure signal not plausible *)
	xMsg9399.Enable 	:= TRUE;
	xMsg9399.Set		:= bAMM_Pr_Ch_OoR;
	xMsg9399.PT 		:= T#2s;
	xMsg9399.Prio 		:= 4;
	xMsg9399.RiskClass 	:= 4;
	xMsg9399.Reset 		:= FALSE;
	xMsg9399();
	MM2VIS.bMsg9399		:= xMsg9399.Q;

	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1 	:= OUT_CH.tCH2AB.bGnlTrip1 		OR IN_CH.tAB2CH.bGnlTrip1;
	bGnlTrip2 	:= OUT_CH.tCH2AB.bGnlTrip2 		OR IN_CH.tAB2CH.bGnlTrip2;
	bGnlTrip3 	:= OUT_CH.tCH2AB.bGnlTrip3 		OR IN_CH.tAB2CH.bGnlTrip3;
	bGnlWarning := OUT_CH.tCH2AB.bGnlWarning 	OR IN_CH.tAB2CH.bGnlWarning;
	bGnlTrip	:= bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	(*****************************************************************************)
	
END_PROGRAM
