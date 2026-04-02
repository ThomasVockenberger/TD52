(*******************************************************************************
MsgGT	 			 alarms generation

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2025

Customized modifications: -
------------------------
 
History:
-------
V0.01.0		02.11.2011	lettenb.	new
V3.90.1 	29.10.2012	Denk 		xMsg1095.Enable	:= Para.bPr_PCG_GC_Active;		BEFORE always TRUE
V3.90.2 	22.02.2013	Denk 		v3.30 alarms integrated bMsg3353 - bMsg3361 
V3.90.3		25.02.2013	Denk 		v3.30 bMsg3320 added 
			23.04.2013	lettenb.	logic for 1085, 3315 included from CommomGT	
			27.05.2013	lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
			28.05.2013	lettenb.	bTestEnabled Para -> loc.var, 3362,3363,3364,3365 acc.V3.40 added
									3308,3309: Para.bPr_PCGComp_Active added
			22.11.2013	lettenb.	V3.50 OUT_GT.bMsg1084 added
V4.00.00	04.03.2014	lettenb.	logger added
V4.00.01	09.05.2014	Denk		Bugfix, bMsg1095 Bracket condition wrong
V4.00.02	14.05.2014	Denk		Bugfix, bMsg1084 Prio.3 --> Prio.2
									bMsg3308,3309: Deleted Para.bPr_PCGComp_Active; New Para.bPr_PCG_GC_Active; 
V4.01.00	15.07.2014	Denk		Bugfix Prio. bMsg3356,bMsg3357,bMsg3358
V4.01.01 	07.10.2014	Denk		Adicom Pre-chamber gas compressor logic added
V4.03.00 	04.11.2014	Denk		bMsg1084, Para.bPr_PC_Active added
			13.11.2014  Mari 		Porting J920 for XT4
			02.03.2015  Denk 		Messages 1265 - 1272 added
			31.03.2015  Denk    	Message 1057,1058,1095, Para.bPurgecycle_Active added
			01.04.2015  Denk		Bugfix, xMsg2578.Set := NOT IN_GT.tT_PCGT.GoodQual; 
			02.07.2015	Denk 		Backfire device for 4 gaslines and prechamber, bMsg3387-3392, bMsg2694-2696 added
			05.10.2015	Denk		Prechamber gas train failure bMsg3398
			02.12.2015	Denk		Bugfix, activation 2250,2251
			08.06.2015	Denk		Bugfix/Issue, 1095 with Adikomp gas compressor 
V4.04.00.	04.07.2016	Denk		Change 2240 delay time from 0s to 10s
									bMsg2753 added 	
			21.09.2016	Denk		1267,1268 Enable changed: AND Para.iNum_GT > 1;
			20.10.2016	Tinello		2271 deleted
			15.11.2016	Denk		Blow-off valve defect, change from warning W2674 to alarm A2301
V4.05.00	21.02.2017	Denk		SWAFT 920 Rel.1, trip 2243,2250 deleted 
									SWAT 920 Rel.2, trip 2248,2249 delay time adjusted 0s->300ms; 2231,2272 disabled, new 2443,2444; 2241,2245 disabled	
			24.04.2017	Denk		SWAT 920 Rel.2, A2247 deleted, W2462 new, B2927 new
									SWAT 920 Rel.2, trip 3004 inactive, warning 2463 new. For type6 no change, still a trip.
			10.07.2017	Denk		SWAT 920 Rel.3, A2257 deleted, W2465 new, B2928 new
									SWAT 920 Rel.3, W2466 new, A1084 only for type6, A2314 new, A3377 additonal time PT#5s added, IN_GT.bPBC_Active added, A1094 Set logic changed for type9, 
			26.10.2017	Denk		WinMOD simulation, bMsg3004 inactive when fast start macro is active
			21.01.2018	Denk		bmsg3320, IN_IC.tPB2MM.bParaSetupOk added 
V4.07.00	30.04.2018	Denk	 	SWAT Rel.5, change A2289 to W2570
									SWAT Rel.5, W3445 delay time
									SWAT Rel.5, A1095 deleted for type9
									SWAT Rel.5, A1085 delay time for type 9 changed to 3s
			25.03.2019	Zengerer 	new W9259- and  B2990-	Gas Valves Messages, tiGV_Feedback_Delay_max
V04.09.00	27.06.2019	Denk		Additional measurements in natural gas train
			29.11.2019	Zengerer	Option bMEGA_GasTrain operating message: extended compressor demand for gas leakage check, B2997,  A3326 exception, enable update: 9259, 9260 
V4.10.00	22.11.2020	Zuschnig    Included power reduction for Tecjet differential pressure
			28.01.2021	Denk		Alarm deactivation when DGS/WinMOD Simulation is active (2261, 3376, 3377, 3444, 3445).	
V4.11.00	22.06.2021	Arnold		Activate gas rail pressure messages for all PI engines
			21.10.2021	Zuschnig	Removed prechamber gas pressure minimum monitoring via parameter, changed A1095 from 2s to 500ms 
			20.01.2022  Zuschnig 	Enabled A2243 - added aditional trigger for difference of gas pressure after filter to gas rail pressure - set alarm delay time to zero
								 	Enabled A2289 - set alarm delay time to zero
V4.12.00	22.01.2023	Zuschnig	Include W9360, W9361 and A2364
V4.13.00	20.06.2023	Zuschnig	Include W9371 - Measuring signal failure setpoint - Gas mixing
			21.07.2023	Bacci		Gas valves open (B9086) and gas valves closed (B9087) operating messages added		
			05.12.2023	Zuschnig	Include W9387 - Prechamber gas pressure low
			28.02.2024	Zuschnig	Include Para.bGCActive for setting A3326
V4.14.00	25.11.2024	Abe			Added W9509 - Pre chamber gas bypass valve malfunction
			28.11.2024	Nagy		Modified A1084,A1085, A3003 - 2024-222 GasTrain Desensitization
V4.25.00	20.11.2025	Tinello		SafetyPLC: Modified B1265,B1266,B1267,B1268
																							
Instructions for use:
--------------------
1) declare alarm with function block "Alm"
	declare buffert alarm bit bMsg<messGTe number>

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
-TESTING: V4.09.01	xx-09-2019	Zengerer	Option bMEGA_GasTrain operating message: extended compressor demand for gas leakage check 


(*******************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)
	OUT_GT.tGT2AB.bGnlTrip1		:=	FALSE;
	OUT_GT.tGT2AB.bGnlTrip2		:=	FALSE;
	OUT_GT.tGT2AB.bGnlTrip3		:=	FALSE;
	OUT_GT.tGT2AB.bGnlWarning	:=	FALSE;
	OUT_GT.tGT2AB.bTriptype1	:=	FALSE;
	OUT_GT.tGT2AB.bTriptype2	:=	FALSE;
	OUT_GT.tGT2AB.bTriptype3	:=	FALSE;	
	
	(*---------------------------------------------------------------------------*)
	(* A1027 Gas train 1 failure *)
	xMsg1027.Enable	   := TRUE;
	xMsg1027.Set 	   := M_STGAS1;
	xMsg1027.PT	       := T#0s;
	xMsg1027.Prio 	   := 3;
	xMsg1027.RiskClass := 4;
	xMsg1027.Reset 	   := FALSE;
	xMsg1027();
	MM2VIS.bMsg1027    := xMsg1027.Q;	
	OUT_GT.bMsg1027    := xMsg1027.Q;
	
	(* A1028 gas pressure low gas train 1 *)
	xMsg1028.Enable	   := TRUE;
	xMsg1028.Set 	   := bMsg1028_Set;
	xMsg1028.PT	       := T#0s;
	xMsg1028.Prio 	   := 2;
	xMsg1028.RiskClass := 1;
	xMsg1028.Reset 	   := FALSE;
	xMsg1028();
	MM2VIS.bMsg1028    := xMsg1028.Q;
	
	(* A1029 Gas train 2 failure *)
	xMsg1029.Enable	   := TRUE;
	xMsg1029.Set 	   := M_STGAS2;
	xMsg1029.PT	       := T#0s;
	xMsg1029.Prio 	   := 3;
	xMsg1029.RiskClass := 4;
	xMsg1029.Reset 	   := FALSE;
	xMsg1029();
	MM2VIS.bMsg1029    := xMsg1029.Q;
	OUT_GT.bMsg1029    := xMsg1029.Q;
    
    (* A1030 Gas train 2 gas pressure low *)
	xMsg1030.Enable	   := TRUE;
	xMsg1030.Set 	   := bMsg1030_Set;
	xMsg1030.PT	       := T#0s;
	xMsg1030.Prio 	   := 2;
	xMsg1030.RiskClass := 1;
	xMsg1030.Reset 	   := FALSE;
	xMsg1030();
	MM2VIS.bMsg1030    := xMsg1030.Q;	
	
	(* A1057 as train 1 gas pressure high *)
	xMsg1057.Enable	   := TRUE;
	xMsg1057.Set 	   := bMsg1057_Set;
	xMsg1057.PT	       := T#0s;
	IF Para.bVISA OR Para.bPurgecycle_Active THEN
		xMsg1057.Prio 	   := 2;   
	ELSE
		xMsg1057.Prio 	   := 3;
	END_IF;
	xMsg1057.RiskClass := 4;
	xMsg1057.Reset 	   := FALSE;
	xMsg1057();
	MM2VIS.bMsg1057    := xMsg1057.Q;
	
	(* A1058 gas train 2 gas pressure high *)
	xMsg1058.Enable	   := TRUE;
	xMsg1058.Set 	   := bMsg1058_Set;
	xMsg1058.PT	       := T#0s;
	IF Para.bVISA OR Para.bPurgecycle_Active THEN
		xMsg1058.Prio  :=  2;  
	ELSE
		xMsg1058.Prio  :=  3;
	END_IF;
	xMsg1058.RiskClass := 4;
	xMsg1058.Reset 	   := FALSE;
	xMsg1058();
	MM2VIS.bMsg1058    := xMsg1058.Q;
	
	(* A1084 Measuring signal failure prechamber gas pressure - SWAT 920 Rel.3 changed *)
	xMsg1084.Enable	   := xEngType.Type6 AND IN_GT.tPB2MM.bSys_Run;
	xMsg1084.Set 	   := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tPr_PC.GoodQual AND Para.bPr_PC_Active;
	xMsg1084.PT	       := T#0s;
	xMsg1084.Prio 	   := 3;
	xMsg1084.RiskClass := 4;
	xMsg1084.Reset 	   := FALSE;
	xMsg1084();
	MM2VIS.bMsg1084    := xMsg1084.Q;
	OUT_GT.bMsg1084    := xMsg1084.Q;
	
	(* A1085 Pre-chamber pressure maximum *)
	xGR_MAX_LDR(In:= pl_ist, Gw:= 1.1, Hy:= 0.01);
	xTOF_UW_VKDR(IN:= xGR_MAX_LDR.Q, PT:= T#3s);
 
	IF xEngType.Type9 THEN	(* SWAT Rel.5 *)
		tiTON_UW_PDIFF:= T#6s;
	END_IF;
	IF xEngType.Type6 THEN
		tiTON_UW_PDIFF:= T#3s;
	END_IF;	
	
	xTON_UW_PDIFF(IN:= OUT_GT.tPCG_GV_Open.Do, PT:= tiTON_UW_PDIFF);
	UW_PDIFF := xTON_UW_PDIFF.Q;
	
	UW_VKDR      := UW_PDIFF AND NOT xTOF_UW_VKDR.Q;

	xMsg1085.Enable	   := TRUE; 
	xMsg1085.Set 	   := AN_VKDR_MX AND UW_VKDR AND NOT xMsg1084.Q;
	xMsg1085.PT	       := T#0s;
	xMsg1085.Prio 	   := 2;
	xMsg1085.RiskClass := 4;
	xMsg1085.Reset 	   := FALSE;
	xMsg1085();
	MM2VIS.bMsg1085    := xMsg1085.Q;
	
	(* A1086 CH4 content low *)
	xMsg1086.Enable	   := TRUE;
	xMsg1086.Set 	   := CH4_MIN_A;
	xMsg1086.PT	       := T#0s;
	xMsg1086.Prio 	   := 2;
	xMsg1086.RiskClass := 4;
	xMsg1086.Reset 	   := FALSE;
	xMsg1086();
	MM2VIS.bMsg1086    := xMsg1086.Q;
		
	(* A1087 O2 content high *)
	xMsg1087.Enable	   := TRUE;
	xMsg1087.Set 	   := O2_MAX;
	xMsg1087.PT	       := T#0s;
	xMsg1087.Prio 	   := 2;
	xMsg1087.RiskClass := 4;
	xMsg1087.Reset 	   := FALSE;
	xMsg1087();
	MM2VIS.bMsg1087    := xMsg1087.Q;
	
	(* A1088 Measuring signal failure O2 content *)
	xMsg1088.Enable	   := TRUE;
	xMsg1088.Set 	   := MS_O2_A;
	xMsg1088.PT	       := T#0s;
	xMsg1088.Prio 	   := 2;
	xMsg1088.RiskClass := 4;
	xMsg1088.Reset 	   := FALSE;
	xMsg1088();
	MM2VIS.bMsg1088    := xMsg1088.Q;	
	
	(* A1094 Deflagration protection - SWAT 920 Rel.3 changed *)
	xMsg1094.Enable	   := TRUE;
	xMsg1094.Set 	   := (xEngType.Type6 AND T_PUFF_1 AND T_PUFF_2 AND T_PUFF_3) OR (xEngType.Type9 AND NOT IN_GT.bPBC_Active AND AN_FGPUFF AND T_PUFF_1 AND T_PUFF_2 AND T_PUFF_3);
	xMsg1094.PT	       := T#0s;
	xMsg1094.Prio 	   := 3;
	xMsg1094.RiskClass := 4;
	xMsg1094.Reset 	   := FALSE;
	xMsg1094();
	MM2VIS.bMsg1094    := xMsg1094.Q;	
		
	(* A1095 Prechamber gas pressure low *)
	xMsg1095.Enable	   := NOT xEngType.Type9;	(* SWAT Rel.5 *)			
	xMsg1095.Set 	   := VKGD_MIN OR													(* Prechamber gas compressor control P.14-PI-001[01] [NUP2], Label rPr_GCG *)
	                      ((NOT IN_GT.tPr_PCG_Min.Di OR bPowerMin_PCGT) AND					(* Gas pressure prechamber gas train P.14-PS-101 or P.14-PI-102 [NUP13] *)	
						  (UW_VKDR OR IN_GT.tEng_Run.Do));					   
	IF Para.bPurgecycle_Active THEN					   
		xMsg1095.PT	   := T#0s;  
	ELSE
		xMsg1095.PT    := T#500ms;
	END_IF;
	xMsg1095.Prio  	   := 2;
	xMsg1095.RiskClass := 4;
	xMsg1095.Reset 	   := FALSE;
	xMsg1095();
	MM2VIS.bMsg1095    := xMsg1095.Q;
			
	(* A1128 Antibackfire device - gastrain 1 *)
	xMsg1128.Enable	   := TRUE;
	xMsg1128.Set 	   := NOT IN_GT.tGT_BackFireDev.Di; 
	xMsg1128.PT	       := T#0s;
	xMsg1128.Prio 	   := 2;
	xMsg1128.RiskClass := 3;
	xMsg1128.Reset 	   := FALSE;
	xMsg1128();
	MM2VIS.bMsg1128    := xMsg1128.Q;
	
	(* A2231 Measuring signal failure gas rail pressure I - SWAT 920 Rel.2 deleted *)
	xMsg2231.Enable	   := FALSE;
	xMsg2231.Set 	   := bAMM_Pr_GR_I_MS;
	xMsg2231.PT	       := T#0s;
	xMsg2231.Prio 	   := 1;
	xMsg2231.RiskClass := 4;
	xMsg2231.Reset 	   := FALSE;
	xMsg2231();
	MM2VIS.bMsg2231    := xMsg2231.Q;	

	(* A2240 Gas rail temperature high - SWAT 920 Rel.2 changed *)
	xMsg2240.Enable	   := Para.bT_GR_Exist;
	xMsg2240.Set 	   := bAMM_T_GR_HiHi; 
	xMsg2240.PT	       := T#60s;
	xMsg2240.Prio 	   := 3;
	xMsg2240.RiskClass := 4;
	xMsg2240.Reset 	   := FALSE;
	xMsg2240();
	MM2VIS.bMsg2240    := xMsg2240.Q;

	(* A2241 Gas rail temperature low - SWAT 920 Rel.2 deleted *)
	xMsg2241.Enable	   := FALSE;
	xMsg2241.Set 	   := bAMM_T_GR_LoLo; 
	xMsg2241.PT	       := T#0s;
	xMsg2241.Prio 	   := 3;
	xMsg2241.RiskClass := 4;
	xMsg2241.Reset 	   := FALSE;
	xMsg2241();
	MM2VIS.bMsg2241    := xMsg2241.Q;

	(* A2243 gas train 1 gas pressure after filter low *)
	xMsg2243.Enable	   := TRUE;
	xMsg2243.Set 	   := bAMM_Pr_MGT_a_Filt_LoLo OR bAMM_Pr_MGT_a_Filt_Min; 
	xMsg2243.PT	       := T#0s;
	xMsg2243.Prio 	   := 2;
	xMsg2243.RiskClass := 4;
	xMsg2243.Reset 	   := FALSE;
	xMsg2243();
	MM2VIS.bMsg2243    := xMsg2243.Q;
	
	(* A2244 gas rail pressure high *)
	xMsg2244.Enable	   := TRUE;
	xMsg2244.Set 	   := bAMM_Pr_GR_I_HiHi; 
	xMsg2244.PT	       := T#0s;
	xMsg2244.Prio 	   := 3;
	xMsg2244.RiskClass := 4;
	xMsg2244.Reset 	   := FALSE;
	xMsg2244();
	MM2VIS.bMsg2244    := xMsg2244.Q;

	(* A2245 gas rail pressure low - SWAT 920, deleted 21.02.2017 *)
	xMsg2245.Enable	   := FALSE;
	xMsg2245.Set 	   := bAMM_Pr_GR_I_LoLo; 
	xMsg2245.PT	       := T#0s;
	xMsg2245.Prio 	   := 3;
	xMsg2245.RiskClass := 4;
	xMsg2245.Reset 	   := FALSE;
	xMsg2245();
	MM2VIS.bMsg2245    := xMsg2245.Q;

	(* A2246 gas train 1 gas pressure after filter high *)
	xMsg2246.Enable	   := TRUE;  
	xMsg2246.Set 	   := bAMM_Pr_MGT_a_Filt_HiHi; 
	xMsg2246.PT	       := T#2s;
	xMsg2246.Prio 	   := 1;
	xMsg2246.RiskClass := 4;
	xMsg2246.Reset 	   := FALSE;
	xMsg2246();
	MM2VIS.bMsg2246    := xMsg2246.Q;	
		
	(* A2247 measuring signal failure gas pressure after filter in main gas train - deleted SWAT920 24.04.2017 *)
	xMsg2247.Enable	   := FALSE;
	xMsg2247.Set 	   := bAMM_Pr_MGT_a_Filt_MS;
	xMsg2247.PT	       := T#2s;
	xMsg2247.Prio 	   := 3;
	xMsg2247.RiskClass := 4;
	xMsg2247.Reset 	   := FALSE;
	xMsg2247();
	MM2VIS.bMsg2247    := xMsg2247.Q;
	
	(* A2248 Gas rail differential pressure high - SWAT 920 Rel.2 changed *)
	xMsg2248.Enable	   := Para.bPr_GR_I_Exist;
	xMsg2248.Set 	   := bAMM_DPr_GR_I_HiHi;
	xMsg2248.PT	       := T#300ms;
	xMsg2248.Prio 	   := 2;
	xMsg2248.RiskClass := 4;
	xMsg2248.Reset 	   := FALSE;
	xMsg2248();
	MM2VIS.bMsg2248    := xMsg2248.Q;

	(* A2249 Gas rail differential pressure low - SWAT 920 Rel.2 changed *)
	xMsg2249.Enable	   := Para.bPr_GR_I_Exist;
	xMsg2249.Set 	   := bAMM_DPr_GR_I_LoLo;
	xMsg2249.PT	       := T#300ms;
	xMsg2249.Prio 	   := 3;
	xMsg2249.RiskClass := 4;
	xMsg2249.Reset 	   := FALSE;
	xMsg2249();
	MM2VIS.bMsg2249    := xMsg2249.Q;

	(* A2250 prechamber gas train gas pressure after filter low - SWAT 920, deleted 21.02.2017 *)
	xMsg2250.Enable	   := FALSE;
	xMsg2250.Set 	   := bAMM_Pr_PCGT_a_Filt_LoLo; 
	xMsg2250.PT	       := T#2s;
	xMsg2250.Prio 	   := 2;
	xMsg2250.RiskClass := 4;
	xMsg2250.Reset 	   := FALSE;
	xMsg2250();
	MM2VIS.bMsg2250    := xMsg2250.Q;	
	
	(* A2251 pre chamber gas train gas pressure after filter high *)
	xMsg2251.Enable	   := xEngType.Type9;
	xMsg2251.Set 	   := bAMM_Pr_PCGT_a_Filt_HiHi; 
	xMsg2251.PT	       := T#2s;
	xMsg2251.Prio 	   := 1;
	xMsg2251.RiskClass := 4;
	xMsg2251.Reset 	   := FALSE;
	xMsg2251();
	MM2VIS.bMsg2251    := xMsg2251.Q;

	(* A2257 measuring signal failure gas pressure after filter in prechamber gas train - SWAT 920 Rel.3, deleted 14.07.2017*)
	xMsg2257.Enable	   := FALSE;
	xMsg2257.Set 	   := bAMM_Pr_PCGT_a_Filt_MS;
	xMsg2257.PT	       := T#2s;
	xMsg2257.Prio 	   := 3;
	xMsg2257.RiskClass := 4;
	xMsg2257.Reset 	   := FALSE;
	xMsg2257();
	MM2VIS.bMsg2257    := xMsg2257.Q;
	
	(* A2261 Gas rail pressure higher than barometric pressure *)
	xMsg2261.Enable	   := TRUE AND NOT IN_GT.bSimWinMOD_Active;
	xMsg2261.Set 	   := bAMM_DPr_GR_Baro_HiHi;
	xMsg2261.PT	       := T#60s;
	xMsg2261.Prio 	   := 3;
	xMsg2261.RiskClass := 4;
	xMsg2261.Reset 	   := FALSE;
	xMsg2261();
	MM2VIS.bMsg2261    := xMsg2261.Q;
	
	(* A2271 Gas rail pressure lower than barometric pressure *)		(* --> NOT USED *)
	xMsg2271.Enable	   := FALSE;
	xMsg2271.Set 	   := FALSE;
	xMsg2271.PT	       := T#0s;
	xMsg2271.Prio 	   := 3;
	xMsg2271.RiskClass := 4;
	xMsg2271.Reset 	   := FALSE;
	xMsg2271();
	MM2VIS.bMsg2271    := xMsg2271.Q;
		
	(* A2272 Measuring signal failure gas rail pressure II - SWAT 920 Rel.2 deleted *)
	xMsg2272.Enable	   := FALSE;
	xMsg2272.Set 	   := bAMM_Pr_GR_II_MS;
	xMsg2272.PT	       := T#0s;
	xMsg2272.Prio 	   := 1;
	xMsg2272.RiskClass := 4;
	xMsg2272.Reset 	   := FALSE;
	xMsg2272();
	MM2VIS.bMsg2272    := xMsg2272.Q;
	
	(* A2273 Deviation gas rail pressure --> SWAT 920 Rel.2, Changed to warning 8.3.2017 *)
	xMsg2273.Enable	   := FALSE;
	xMsg2273.Set 	   := bDevP_GR_TooHigh;
	xMsg2273.PT	       := T#0s;
	xMsg2273.Prio 	   := 1;
	xMsg2273.RiskClass := 4;
	xMsg2273.Reset 	   := FALSE;
	xMsg2273();
	MM2VIS.bMsg2273    := xMsg2273.Q;
	
	(* A2289 Gas train: Compressed air supply failure *)
	xMsg2289.Enable	   := TRUE;
	xMsg2289.Set 	   := bAMM_GT_AirSupply_LoLo;
	xMsg2289.PT	       := T#0s;
	xMsg2289.Prio 	   := 2;
	xMsg2289.RiskClass := 4;
	xMsg2289.Reset 	   := FALSE;
	xMsg2289();
	MM2VIS.bMsg2289    := xMsg2289.Q;
	
	(* A2301 blow-off valve defect *)
	xMsg2301.Enable	   := TRUE;
	xMsg2301.Set 	   := bBlowOff_PrHi_Err;
	xMsg2301.PT	       := T#200ms;
	xMsg2301.Prio 	   := 1;
	xMsg2301.RiskClass := 4;
	xMsg2301.Reset 	   := FALSE;
	xMsg2301();
	MM2VIS.bMsg2301    := xMsg2301.Q;
	
 	(* A2309 Measuring signal failure gas rail pressure A and B - SWAT 920 Rel.2 new *)
	xMsg2309.Enable	   := xEngType.Type9;
	xMsg2309.Set 	   := bAMM_Pr_GR_I_II_MS;
	xMsg2309.PT	       := T#0s;
	xMsg2309.Prio 	   := 1;
	xMsg2309.RiskClass := 4;
	xMsg2309.Reset 	   := FALSE;
	xMsg2309();
	MM2VIS.bMsg2309    := xMsg2309.Q;
	
	(* A2314 Measuring signal failure pre chamber gas pressure and gas pressure after pre chamber gas pressure regulator *) (* SWAT Rel.3 *)
	xMsg2314.Enable	   := xEngType.Type9 AND IN_GT.tPB2MM.bSys_Run;
	xMsg2314.Set 	   := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tPr_PC.GoodQual AND Para.bPr_PC_Active AND NOT IN_GT.tPr_PCGT_Out.GoodQual AND NOT IN_GT.bPBC_Active;
	xMsg2314.PT	       := T#0s;
	xMsg2314.Prio 	   := 2;
	xMsg2314.RiskClass := 4;
	xMsg2314.Reset 	   := FALSE;
	xMsg2314();
	MM2VIS.bMsg2314    := xMsg2314.Q;
	
	(* A2346 Gas proportioning valve differential pressure minimum *)
	xMsg2346.Enable	   := Para.iTJ_DPress_PowRed_Mode = 1 OR Para.iTJ_DPress_PowRed_Mode = 2;
	xMsg2346.Set 	   := bPr_TecJetDP_Min;
	xMsg2346.PT	       := T#0s;
	xMsg2346.Prio 	   := 3;
	xMsg2346.RiskClass := 4;
	xMsg2346.Reset 	   := FALSE;
	xMsg2346();
	MM2VIS.bMsg2346    := xMsg2346.Q;
	
	(* W2443 Measuring signal failure gas rail pressure A - SWAT 920 Rel.2 new *)
	xMsg2443.Enable	   := Para.bSA_PI_Active;
	xMsg2443.Set 	   := bAMM_Pr_GR_I_MS;
	xMsg2443.PT	       := T#0s;
	xMsg2443.Prio 	   := 4;
	xMsg2443.RiskClass := 4;
	xMsg2443.Reset 	   := FALSE;
	xMsg2443();
	MM2VIS.bMsg2443    := xMsg2443.Q;
	
	(* W2444 Measuring signal failure gas rail pressure B - SWAT 920 Rel.2 new *) 
	xMsg2444.Enable	   := Para.bSA_PI_Active;
	xMsg2444.Set 	   := bAMM_Pr_GR_II_MS;
	xMsg2444.PT	       := T#0s;
	xMsg2444.Prio 	   := 4;
	xMsg2444.RiskClass := 4;
	xMsg2444.Reset 	   := FALSE;
	xMsg2444();
	MM2VIS.bMsg2444    := xMsg2444.Q;
		
	(* W2445 Deviation gas pressure - SWAT 920 Rel.2 new *)
	xMsg2445.Enable	   := Para.bSA_PI_Active;
	xMsg2445.Set 	   := bDevP_GR_TooHigh;
	xMsg2445.PT	       := T#0s;
	xMsg2445.Prio 	   := 4;
	xMsg2445.RiskClass := 4;
	xMsg2445.Reset 	   := FALSE;
	xMsg2445();
	MM2VIS.bMsg2445    := xMsg2445.Q;
	
	(* W2462 measuring signal failure gas pressure after filter in main gas train - SWAT 920 Rel.2 new *)
	xMsg2462.Enable	   := Para.bSA_PI_Active;
	xMsg2462.Set 	   := bAMM_Pr_MGT_a_Filt_MS;
	xMsg2462.PT	       := T#2s;
	xMsg2462.Prio 	   := 4;
	xMsg2462.RiskClass := 4;
	xMsg2462.Reset 	   := FALSE;
	xMsg2462();
	MM2VIS.bMsg2462    := xMsg2462.Q;
	
	(* W2463 Difference pressure prechamber minimum - SWAT920 Rel.2,trip deactive for type9 only warning 2463 *)
	xMsg2463.Enable	   := xEngType.Type9;
	xMsg2463.Set 	   := AN_PDIFF_MN AND UW_PDIFF AND IN_GT.tEng_Run.Do AND NOT MM2VIS.bMsg2466;
	xMsg2463.PT	       := T#0s;
	xMsg2463.Prio 	   := 4;
	xMsg2463.RiskClass := 4;
	xMsg2463.Reset 	   := FALSE;
	xMsg2463();
	MM2VIS.bMsg2463    := xMsg2463.Q;
	
	(* W2465 measuring signal failure gas pressure after filter in prechamber gas train *)	(* SWAT Rel.3 *)
	xMsg2465.Enable	   := xEngType.Type9;
	xMsg2465.Set 	   := bAMM_Pr_PCGT_a_Filt_MS;
	xMsg2465.PT	       := T#2s;
	xMsg2465.Prio 	   := 4;
	xMsg2465.RiskClass := 4;
	xMsg2465.Reset 	   := FALSE;
	xMsg2465();
	MM2VIS.bMsg2465    := xMsg2465.Q;
	
	(* W2466 Measuring signal failure prechamber gas pressure *) (* SWAT Rel.3 *)
	xMsg2466.Enable	   := xEngType.Type9 AND IN_GT.tPB2MM.bSys_Run;
	xMsg2466.Set 	   := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tPr_PC.GoodQual AND Para.bPr_PC_Active;
	xMsg2466.PT	       := T#0s;
	xMsg2466.Prio 	   := 4;
	xMsg2466.RiskClass := 4;
	xMsg2466.Reset 	   := FALSE;
	xMsg2466();
	MM2VIS.bMsg2466    := xMsg2466.Q;
	
	(* W2467 Deflagration protection *) (* SWAT Rel.3 *)
	xMsg2467.Enable	   := Para.bSA_PI_Active;
	xMsg2467.Set 	   := T_PUFF_1 AND T_PUFF_2 AND T_PUFF_3 AND IN_GT.bPBC_Active AND NOT MM2VIS.bMsg2466;
	xMsg2467.PT	       := T#0s;
	xMsg2467.Prio 	   := 4;
	xMsg2467.RiskClass := 4;
	xMsg2467.Reset 	   := FALSE;
	xMsg2467();
	MM2VIS.bMsg2467    := xMsg2467.Q;
	
	(* W2535 gas train 1 gas pressure after filter low *)
	xMsg2535.Enable	   := TRUE;
	xMsg2535.Set 	   := bAMM_Pr_MGT_a_Filt_Lo; 
	xMsg2535.PT	       := T#2s;
	xMsg2535.Prio 	   := 4;
	xMsg2535.RiskClass := 4;
	xMsg2535.Reset 	   := FALSE;
	xMsg2535();
	MM2VIS.bMsg2535    := xMsg2535.Q;	
	
	(* W2536 gas train 1 gas pressure after filter high *)
	xMsg2536.Enable	   := TRUE;
	xMsg2536.Set 	   := bAMM_Pr_MGT_a_Filt_Hi; 
	xMsg2536.PT	       := T#2s;
	xMsg2536.Prio 	   := 4;
	xMsg2536.RiskClass := 4;
	xMsg2536.Reset 	   := FALSE;
	xMsg2536();
	MM2VIS.bMsg2536    := xMsg2536.Q;
	
	(* W2537 pre chamber gas train gas pressure after filter low *)
	xMsg2537.Enable    := xEngType.Type9;
	xMsg2537.Set       := bAMM_Pr_PCGT_a_Filt_Lo; 
	xMsg2537.PT        := T#2s;
	xMsg2537.Prio      := 4;
	xMsg2537.RiskClass := 4;
	xMsg2537.Reset     := FALSE;
	xMsg2537();
	MM2VIS.bMsg2537	   := xMsg2537.Q;		
	
	(* W2538 pre chamber gas train gas pressure after filter high *)
	xMsg2538.Enable	   := xEngType.Type9;
	xMsg2538.Set 	   := bAMM_Pr_PCGT_a_Filt_Hi; 
	xMsg2538.PT	       := T#2s;
	xMsg2538.Prio 	   := 4;
	xMsg2538.RiskClass := 4;
	xMsg2538.Reset 	   := FALSE;
	xMsg2538();
	MM2VIS.bMsg2538    := xMsg2538.Q;	
	
	(* W2567 Measuring signal failure gas rail temperature *)
	xMsg2567.Enable	   := TRUE;		
	xMsg2567.Set 	   := bAMM_T_GR_MS;
	xMsg2567.PT	       := T#0s;
	xMsg2567.Prio 	   := 4;
	xMsg2567.RiskClass := 4;
	xMsg2567.Reset 	   := FALSE;
	xMsg2567();
	MM2VIS.bMsg2567    := xMsg2567.Q;

	(* W2568 Gas rail temperature high - SWAT 920 Rel.2 changed *)
	xMsg2568.Enable	   := TRUE;		
	xMsg2568.Set 	   := bAMM_T_GR_Hi;
	xMsg2568.PT	       := T#60s;
	xMsg2568.Prio 	   := 4;
	xMsg2568.RiskClass := 4;
	xMsg2568.Reset 	   := FALSE;
	xMsg2568();
	MM2VIS.bMsg2568    := xMsg2568.Q;

	(* W2569 Gas rail temperature low *)
	xMsg2569.Enable	   := TRUE;		
	xMsg2569.Set 	   := bAMM_T_GR_Lo;
	xMsg2569.PT	       := T#60s;
	xMsg2569.Prio 	   := 4;
	xMsg2569.RiskClass := 4;
	xMsg2569.Reset 	   := FALSE;
	xMsg2569();
	MM2VIS.bMsg2569    := xMsg2569.Q;
	
	(* W2570 Gas train: Compressed air supply failure (* SWAT Rel.5 *)
	xMsg2570.Enable	   := TRUE;
	xMsg2570.Set 	   := bAMM_GT_AirSupply_Lo;
	xMsg2570.PT	       := T#2s;
	xMsg2570.Prio 	   := 4;
	xMsg2570.RiskClass := 4;
	xMsg2570.Reset 	   := FALSE;
	xMsg2570();
	MM2VIS.bMsg2570    := xMsg2570.Q;
		
	(* W2578 Temperature pre chamber gas measuring signal failure *)
	xMsg2578.Enable	   := Para.bT_PCGT_Active AND IN_GT.tPB2MM.bSys_Run;	
	xMsg2578.Set 	   := NOT IN_GT.tT_PCGT.GoodQual;
	xMsg2578.PT	       := T#0s;
	xMsg2578.Prio 	   := 4;
	xMsg2578.RiskClass := 4;
	xMsg2578.Reset 	   := FALSE;
	xMsg2578();
	MM2VIS.bMsg2578    := xMsg2578.Q;

	(* W2580 Gas rail differential pressure high *)
	xMsg2580.Enable	   := TRUE;		
	xMsg2580.Set 	   := bAMM_DPr_GR_I_Hi;
	xMsg2580.PT	       := T#0s;
	xMsg2580.Prio 	   := 4;
	xMsg2580.RiskClass := 4;
	xMsg2580.Reset 	   := FALSE;
	xMsg2580();
	MM2VIS.bMsg2580    := xMsg2580.Q;

	(* W2581 Gas rail differential pressure low *)
	xMsg2581.Enable	   := TRUE;		
	xMsg2581.Set 	   := bAMM_DPr_GR_I_Lo;
	xMsg2581.PT	       := T#0s;
	xMsg2581.Prio 	   := 4;
	xMsg2581.RiskClass := 4;
	xMsg2581.Reset 	   := FALSE;
	xMsg2581();
	MM2VIS.bMsg2581    := xMsg2581.Q;

	(* W2674 blow-off valve defect - with v4.04 changed to alarm 2301 *)
	xMsg2674.Enable	   := FALSE;
	xMsg2674.Set 	   := bBlowOff_PrHi_Err;
	xMsg2674.PT	       := T#200ms;
	xMsg2674.Prio 	   := 4;
	xMsg2674.RiskClass := 4;
	xMsg2674.Reset 	   := FALSE;
	xMsg2674();
	MM2VIS.bMsg2674    := xMsg2674.Q;

	(* W2694 Gas pressure minimum Gas train 1 line 2 *)
	xMsg2694.Enable	   := TRUE;
	xMsg2694.Set 	   := bMsg2694_Set;
	xMsg2694.PT	       := T#0s;
	xMsg2694.Prio 	   := 4;
	xMsg2694.RiskClass := 4;
	xMsg2694.Reset 	   := FALSE;
	xMsg2694();
	MM2VIS.bMsg2694    := xMsg2694.Q;

	(* W2695 Gas pressure minimum Gas train 1 line 3 *)
	xMsg2695.Enable	   := TRUE;
	xMsg2695.Set 	   := bMsg2695_Set;
	xMsg2695.PT	       := T#0s;
	xMsg2695.Prio 	   := 4;
	xMsg2695.RiskClass := 4;
	xMsg2695.Reset 	   := FALSE;
	xMsg2695();
	MM2VIS.bMsg2695    := xMsg2695.Q;

	(* W2696 Gas pressure minimum Gas train 1 line 4 *)
	xMsg2696.Enable	   := TRUE;
	xMsg2696.Set 	   := bMsg2696_Set;
	xMsg2696.PT	       := T#0s;
	xMsg2696.Prio 	   := 4;
	xMsg2696.RiskClass := 4;
	xMsg2696.Reset 	   := FALSE;
	xMsg2696();
	MM2VIS.bMsg2696    := xMsg2696.Q;

	(* W2753 Blow-off system supply circuit breaker tripped *)
	xMsg2753.Enable	   := TRUE;
	xMsg2753.Set 	   := NOT IN_GT.tSIFA_BOV.Di;
	xMsg2753.PT	       := T#2s;
	xMsg2753.Prio 	   := 4;
	xMsg2753.RiskClass := 4;
	xMsg2753.Reset 	   := FALSE;
	xMsg2753();
	MM2VIS.bMsg2753    := xMsg2753.Q;
	
	(* A3004 Difference pressure prechamber minimum - SWAT920 Rel.2,trip deactive for type9 only warning 2463 *)
	xMsg3004.Enable	   := xEngType.Type6; 
	xMsg3004.Set 	   := (AN_PDIFF_MN AND UW_PDIFF AND IN_GT.tEng_Run.Do) AND NOT IN_GT.bSimWinMOD_FastStart AND NOT xMsg1084.Q;
	xMsg3004.PT	       := T#0s;
	xMsg3004.Prio 	   := 2;
	xMsg3004.RiskClass := 4;
	xMsg3004.Reset 	   := FALSE;
	xMsg3004();
	MM2VIS.bMsg3004    := xMsg3004.Q;	
	
	(* W3153 Release from Gas station missing *)
	xMsg3153.Enable	   := TRUE;
	xMsg3153.Set 	   := NOT FGGAS;
	xMsg3153.PT	       := T#0s;
	xMsg3153.Prio 	   := 4;
	xMsg3153.RiskClass := 4;
	xMsg3153.Reset 	   := FALSE;
	xMsg3153();
	MM2VIS.bMsg3153    := xMsg3153.Q;	
	
	(* W3154 CH4-content minimum *)
	xMsg3154.Enable	   := TRUE;
	xMsg3154.Set 	   := CH4_MIN_W;
	xMsg3154.PT	       := T#0s;
	xMsg3154.Prio 	   := 4;
	xMsg3154.RiskClass := 4;
	xMsg3154.Reset 	   := FALSE;
	xMsg3154();
	MM2VIS.bMsg3154    := xMsg3154.Q;	
	
	(* W3155 Measurement signal failure - CH4 *)
	xMsg3155.Enable	   := TRUE;
	xMsg3155.Set 	   := MS_CH4;
	xMsg3155.PT	       := T#0s;
	xMsg3155.Prio 	   := 4;
	xMsg3155.RiskClass := 4;
	xMsg3155.Reset 	   := FALSE;
	xMsg3155();
	MM2VIS.bMsg3155    := xMsg3155.Q;	
	
	(* W3156 Measurement signal failure - Gas pressure *)
	xMsg3156.Enable	   := TRUE;
	xMsg3156.Set 	   := MS_GD;
	xMsg3156.PT	       := T#0s;
	xMsg3156.Prio 	   := 4;
	xMsg3156.RiskClass := 4;
	xMsg3156.Reset 	   := FALSE;
	xMsg3156();
	MM2VIS.bMsg3156    := xMsg3156.Q;
	
	(* W3157 Measurement signal failure - Suction pressure *)
	xMsg3157.Enable	   := TRUE;
	xMsg3157.Set 	   := MS_SD;
	xMsg3157.PT	       := T#0s;
	xMsg3157.Prio 	   := 4;
	xMsg3157.RiskClass := 4;
	xMsg3157.Reset 	   := FALSE;
	xMsg3157();
	MM2VIS.bMsg3157    := xMsg3157.Q;	
	
	(* W3158 Measure signal failure - O2 warning *)
	xMsg3158.Enable	   := TRUE;
	xMsg3158.Set 	   := MS_O2_W;
	xMsg3158.PT	       := T#0s;
	xMsg3158.Prio 	   := 4;
	xMsg3158.RiskClass := 4;
	xMsg3158.Reset 	   := FALSE;
	xMsg3158();
	MM2VIS.bMsg3158    := xMsg3158.Q;
	
	(* W3159 Measuring signal failure - Gas temperature *)
	xMsg3159.Enable	   := TRUE;
	xMsg3159.Set 	   := MS_GT;
	xMsg3159.PT	       := T#0s;
	xMsg3159.Prio 	   := 4;
	xMsg3159.RiskClass := 4;
	xMsg3159.Reset 	   := FALSE;
	xMsg3159();
	MM2VIS.bMsg3159    := xMsg3159.Q;
	
	(* W3160 Measurement signal failure - Gas  quantity *)
	xMsg3160.Enable	   := TRUE;
	xMsg3160.Set 	   := MS_GM;
	xMsg3160.PT	       := T#0s;
	xMsg3160.Prio 	   := 4;
	xMsg3160.RiskClass := 4;
	xMsg3160.Reset 	   := FALSE;
	xMsg3160();
	MM2VIS.bMsg3160    := xMsg3160.Q;		
	
	(* W3221 Gas pressure minimum Gas train 1 *)
	xMsg3221.Enable	   := TRUE;
	xMsg3221.Set 	   := bMsg3221_Set;
	xMsg3221.PT	       := T#0s;
	xMsg3221.Prio 	   := 4;
	xMsg3221.RiskClass := 4;
	xMsg3221.Reset 	   := FALSE;
	xMsg3221();
	MM2VIS.bMsg3221    := xMsg3221.Q;
		
	(* W3222 Gas pressure minimum Gas train 2 *)
	xMsg3222.Enable	   := TRUE;
	xMsg3222.Set 	   := bMsg3222_Set;
	xMsg3222.PT	       := T#0s;
	xMsg3222.Prio 	   := 4;
	xMsg3222.RiskClass := 4;
	xMsg3222.Reset 	   := FALSE;
	xMsg3222();
	MM2VIS.bMsg3222    := xMsg3222.Q;	
		
	(* A3308 Pressure pre chamber gas compressor measuring signal failure *)
	xMsg3308.Enable	   := Para.bPr_PCG_GC_Active;		//Changed with module version 04.03.00.00. Before: Para.bPr_PCGComp_Active;
	xMsg3308.Set 	   := NOT IN_GT.tPr_PCG.GoodQual;
	xMsg3308.PT	       := T#0s;
	xMsg3308.Prio 	   := 2;
	xMsg3308.RiskClass := 4;
	xMsg3308.Reset 	   := FALSE;
	xMsg3308();
	MM2VIS.bMsg3308    := xMsg3308.Q;
	
	(* A3309 Pressure pre chamber gas compressor high *)
	xMsg3309.Enable	   := Para.bPr_PCG_GC_Active;		//Changed with module version 04.03.00.00. Before: Para.bPr_PCGComp_Active;
	xMsg3309.Set 	   := VKGD_MAX;
	xMsg3309.PT	       := T#0s;
	xMsg3309.Prio 	   := 2;
	xMsg3309.RiskClass := 4;
	xMsg3309.Reset 	   := FALSE;
	xMsg3309();
	MM2VIS.bMsg3309    := xMsg3309.Q;
	
	(* A3315 pre chamber gas compressor oil level low *)
	xMsg3315.Enable	   := TRUE;
	xMsg3315.Set 	   := NOT IN_GT.tPCG_GC_Oil_Min.Di;
	xMsg3315.PT	       := T#2s;
	xMsg3315.Prio 	   := 3;
	xMsg3315.RiskClass := 4;
	xMsg3315.Reset 	   := FALSE;
	xMsg3315();
	MM2VIS.bMsg3315    := xMsg3315.Q;	
	
	(* A3316 Failure Gas compressor *)
	xMsg3316.Enable	   := TRUE;
	xMsg3316.Set 	   := bMsg3316_Set;
	xMsg3316.PT	       := T#0s;
	xMsg3316.Prio 	   := 2;
	xMsg3316.RiskClass := 4;
	xMsg3316.Reset 	   := FALSE;
	xMsg3316();
	MM2VIS.bMsg3316    := xMsg3316.Q;
	
	(* A3317 Gas temperature maximum *)
	xMsg3317.Enable	   := TRUE;
	xMsg3317.Set 	   := bMsg3317_Set;
	xMsg3317.PT	       := T#0s;
	xMsg3317.Prio 	   := 2;
	xMsg3317.RiskClass := 4;
	xMsg3317.Reset 	   := FALSE;
	xMsg3317();
	MM2VIS.bMsg3317    := xMsg3317.Q;
	
	(* A3318 Gas pressure minimum before compressor *)
	xMsg3318.Enable	   := Para.bBiogasActive;
	xMsg3318.Set 	   := bMsg3318_Set;
	xMsg3318.PT	       := T#0s;
	xMsg3318.Prio 	   := 2;
	xMsg3318.RiskClass := 4;
	xMsg3318.Reset 	   := FALSE;
	xMsg3318();
	MM2VIS.bMsg3318    := xMsg3318.Q;
	
	(* A3320 pressure pre chamber gas train measuring signal failure *)
	xMsg3320.Enable	   := Para.bPr_PCGT_Active AND xEngType.Type6 AND IN_GT.tPB2MM.bParaSetupOk;
	xMsg3320.Set 	   := NOT IN_GT.tPr_PCGT.GoodQual;
	xMsg3320.PT	       := T#0s;
	xMsg3320.Prio 	   := 3;
	xMsg3320.RiskClass := 4;
	xMsg3320.Reset 	   := FALSE;
	xMsg3320();
	MM2VIS.bMsg3320    := xMsg3320.Q;

	(* A3324 Failure pre chamber gas compressor *)
	xMsg3324.Enable	   := TRUE;
	xMsg3324.Set 	   := NOT IN_GT.tPCG_GC_Fail.Di;
	xMsg3324.PT	       := T#0s;
	xMsg3324.Prio 	   := 3;
	xMsg3324.RiskClass := 4;
	xMsg3324.Reset 	   := FALSE;
	xMsg3324();
	MM2VIS.bMsg3324    := xMsg3324.Q;
	
	(* A3325 Gas pressure high - backfire *)
	xMsg3325.Enable	   := TRUE;
	xMsg3325.Set 	   := NOT IN_GT.tP_GT_Max_Backfire.Di;
	xMsg3325.PT	       := T#0s;
	xMsg3325.Prio 	   := 2;
	xMsg3325.RiskClass := 4;
	xMsg3325.Reset 	   := FALSE;
	xMsg3325();
	MM2VIS.bMsg3325    := xMsg3325.Q;
		
	(* A3326 monitoring idle operation time gas compressor maximum - V4.09 exception for Gas Compressor prolonged demand while Megagas Valve Check*)
	xMsg3326.Enable	   := TRUE;
	xMsg3326.Set 	   := bMsg3326_Set AND NOT bMsg2997_Set AND Para.bGCActive;
	IF bTestEnabled THEN xMsg3326.PT:= T#5s;		
	ELSE				 xMsg3326.PT:= T#8m;
	END_IF;
	xMsg3326.Prio 	   := 3;
	xMsg3326.RiskClass := 4;
	xMsg3326.Reset 	   := FALSE;
	xMsg3326();
	MM2VIS.bMsg3326    := xMsg3326.Q;
		
	(* A3327 Measurement signal failure Gas pressure before compressor *)
	xMsg3327.Enable	   := Para.bBiogasActive;
	xMsg3327.Set 	   := bMsg3327_Set;
	xMsg3327.PT	       := T#0s;
	xMsg3327.Prio 	   := 2;
	xMsg3327.RiskClass := 4;
	xMsg3327.Reset 	   := FALSE;
	xMsg3327();
	MM2VIS.bMsg3327    := xMsg3327.Q;
	
	(* A3328 Measurement signal failure Gas temperature *)
	xMsg3328.Enable	   := Para.bBiogasActive;
	xMsg3328.Set 	   := bMsg3328_Set;
	xMsg3328.PT	       := T#0s;
	xMsg3328.Prio 	   := 2;
	xMsg3328.RiskClass := 4;
	xMsg3328.Reset 	   := FALSE;
	xMsg3328();
	MM2VIS.bMsg3328    := xMsg3328.Q;
	
	(* A3353 gas pressure low gas train 1 - line 2 *)
	xMsg3353.Enable		:=	AKT_Gastrecke1_2;		
	xMsg3353.Set		:=	bMsg3353_Set;	
	xMsg3353.PT			:=	T#0s;		
	xMsg3353.Prio		:=	2;			
	xMsg3353.RiskClass	:=	4;		
	xMsg3353.Reset		:=	FALSE;	
	xMsg3353();
	MM2VIS.bMsg3353		:= xMsg3353.Q;												
		
	(* A3354 gas pressure low gas train 1 - line 3 *)
	xMsg3354.Enable		:=	AKT_Gastrecke1_3;		
	xMsg3354.Set		:=	bMsg3354_Set;	
	xMsg3354.PT			:=	T#0s;		
	xMsg3354.Prio		:=	2;			
	xMsg3354.RiskClass	:=	4;		
	xMsg3354.Reset		:=	FALSE;	
	xMsg3354();
	MM2VIS.bMsg3354		:= xMsg3354.Q;	
	
	(* A3355 gas pressure low gas train 1 - line 4 *)
	xMsg3355.Enable		:=	AKT_Gastrecke1_4;		
	xMsg3355.Set		:=	bMsg3355_Set;	
	xMsg3355.PT			:=	T#0s;		
	xMsg3355.Prio		:=	2;			
	xMsg3355.RiskClass	:=	4;		
	xMsg3355.Reset		:=	FALSE;	
	xMsg3355();
	MM2VIS.bMsg3355		:= xMsg3355.Q;	
	
	(* A3356 gas train 1 gas pressure high - line 2 *)
	xMsg3356.Enable		:=	AKT_Gastrecke1_2;		
	xMsg3356.Set		:=	bMsg3356_Set;	
	xMsg3356.PT			:=	T#0s;
	IF Para.bPurgecycle_Active THEN
		xMsg3356.Prio   :=  2;  
	ELSE
		xMsg3356.Prio	:=	3;
	END_IF;					
	xMsg3356.RiskClass	:=	4;		
	xMsg3356.Reset		:=	FALSE;	
	xMsg3356();
	MM2VIS.bMsg3356		:= xMsg3356.Q;
	
	(* A3357 gas train 1 gas pressure high - line 3 *)
	xMsg3357.Enable		:=	AKT_Gastrecke1_3;		
	xMsg3357.Set		:=	bMsg3357_Set;	
	xMsg3357.PT			:=	T#0s;		
	IF Para.bPurgecycle_Active THEN
		xMsg3357.Prio   :=  2;  
	ELSE
		xMsg3357.Prio	:=	3;
	END_IF;			
	xMsg3357.RiskClass	:=	4;		
	xMsg3357.Reset		:=	FALSE;	
	xMsg3357();
	MM2VIS.bMsg3357		:= xMsg3357.Q;
	
	(* A3358 gas train 1 gas pressure high - line 4 *)
	xMsg3358.Enable		:=	AKT_Gastrecke1_4;		
	xMsg3358.Set		:=	bMsg3358_Set;	
	xMsg3358.PT			:=	T#0s;		
	IF Para.bPurgecycle_Active THEN
		xMsg3358.Prio   :=  2;  
	ELSE
		xMsg3358.Prio	:=	3;
	END_IF;			
	xMsg3358.RiskClass	:=	4;		
	xMsg3358.Reset		:=	FALSE;	
	xMsg3358();
	MM2VIS.bMsg3358		:= xMsg3358.Q;
	
	(* A3359 failure gas train 1 - line 2 *)
	xMsg3359.Enable		:=	TRUE;		
	xMsg3359.Set		:=	M_STGAS1_2;	
	xMsg3359.PT			:=	T#0s;		
	xMsg3359.Prio		:=	3;			
	xMsg3359.RiskClass	:=	4;		
	xMsg3359.Reset		:=	FALSE;	
	xMsg3359();
	MM2VIS.bMsg3359		:= xMsg3359.Q;
	OUT_GT.bMsg3359		:= xMsg3359.Q;	

	(* A3360 failure gas train 1 - line 3 *)
	xMsg3360.Enable		:=	TRUE;		
	xMsg3360.Set		:=	M_STGAS1_3;	
	xMsg3360.PT			:=	T#0s;		
	xMsg3360.Prio		:=	3;			
	xMsg3360.RiskClass	:=	4;		
	xMsg3360.Reset		:=	FALSE;	
	xMsg3360();
	MM2VIS.bMsg3360		:= xMsg3360.Q;
	OUT_GT.bMsg3360		:= xMsg3360.Q;

	(* A3361 failure gas train 1 - line 4 *)
	xMsg3361.Enable		:=	TRUE;		
	xMsg3361.Set		:=	M_STGAS1_4;	
	xMsg3361.PT			:=	T#0s;		
	xMsg3361.Prio		:=	3;			
	xMsg3361.RiskClass	:=	4;		
	xMsg3361.Reset		:=	FALSE;	
	xMsg3361();
	MM2VIS.bMsg3361		:= xMsg3361.Q;
	OUT_GT.bMsg3361		:= xMsg3361.Q;

	(* A3362 suction pressure prechamber gas compressor high *)
	xMsg3362.Enable		:=	TRUE;		
	xMsg3362.Set		:=	NOT IN_GT.tPr_PCGBefComp_Lo.Di;
	xMsg3362.PT			:=	T#0s;		
	xMsg3362.Prio		:=	2;			
	xMsg3362.RiskClass	:=	4;		
	xMsg3362.Reset		:=	FALSE;	
	xMsg3362();
	MM2VIS.bMsg3362		:= xMsg3362.Q;

	(* A3363 temperature prechamber gas compressor outlet high *)
	xMsg3363.Enable		:=	TRUE;		
	xMsg3363.Set		:=	NOT IN_GT.tT_PCGAfComp_Hi.Di;
	xMsg3363.PT			:=	T#0s;		
	xMsg3363.Prio		:=	2;			
	xMsg3363.RiskClass	:=	4;		
	xMsg3363.Reset		:=	FALSE;	
	xMsg3363();
	MM2VIS.bMsg3363		:= xMsg3363.Q;

	(* A3364 temperature prechamber gas after cooler high *)
	xGRMAX_T_PCGAfCo_Hi(In:= IN_GT.tT_PCGAfCo.Ai, Gw:= Para.rT_PCGAfCo_LimHi, Hy:= Para.rT_PCGAfCo_HyHi);

	xMsg3364.Enable		:=	Para.bT_PCGAfCo_Active;
	xMsg3364.Set		:=	xGRMAX_T_PCGAfCo_Hi.Q;
	xMsg3364.PT			:=	T#2s;		
	xMsg3364.Prio		:=	2;			
	xMsg3364.RiskClass	:=	4;		
	xMsg3364.Reset		:=	FALSE;	
	xMsg3364();
	MM2VIS.bMsg3364		:= xMsg3364.Q;

	(* A3365 signal failure temperature prechamber gas after cooler *)
	xMsg3365.Enable		:=	Para.bT_PCGAfCo_Active;
	xMsg3365.Set		:=	NOT IN_GT.tT_PCGAfCo.GoodQual;
	xMsg3365.PT			:=	T#0s;		
	xMsg3365.Prio		:=	2;			
	xMsg3365.RiskClass	:=	4;		
	xMsg3365.Reset		:=	FALSE;	
	xMsg3365();
	MM2VIS.bMsg3365		:= xMsg3365.Q;
	
	(* A3376 Main gas train set- to actual-gas pressure deviation	*)
	xMsg3376.Enable	   := TRUE AND NOT IN_GT.bSimWinMOD_Active;
	xMsg3376.Set 	   := bAMM_DPr_MGT_SetAct_HiHi;
	xMsg3376.PT	       := T#5s;
	xMsg3376.Prio 	   := 2;
	xMsg3376.RiskClass := 4;
	xMsg3376.Reset 	   := FALSE;
	xMsg3376();
	MM2VIS.bMsg3376    := xMsg3376.Q;
	
	(* A3377 Pre chamber gas train set- to actual-gas pressure deviation - SWAT Rel.3 *)
	xMsg3377.Enable	   := TRUE AND NOT IN_GT.bSimWinMOD_Active;
	xMsg3377.Set 	   := bAMM_DPr_PCGT_SetAct_HiHi;
	IF MM2VIS.bMsg2466 AND NOT IN_GT.bPBC_Active THEN
		xMsg3377.PT	       := T#0.5s;
	ELSE
		xMsg3377.PT	       := T#5s;
	END_IF;
	xMsg3377.Prio 	   := 2;
	xMsg3377.RiskClass := 4;
	xMsg3377.Reset 	   := FALSE;
	xMsg3377();
	MM2VIS.bMsg3377    := xMsg3377.Q;

	(* A3398 Pre chamber gas train failure *)
	xMsg3398.Enable	   := TRUE;
	xMsg3398.Set 	   := M_STPch;
	xMsg3398.PT	       := T#0s;
	xMsg3398.Prio 	   := 3;
	xMsg3398.RiskClass := 4;
	xMsg3398.Reset 	   := FALSE;
	xMsg3398();
	MM2VIS.bMsg3398    := xMsg3398.Q;

	(* W3444 Main gas train set- to actual-gas pressure deviation	*)
	xMsg3444.Enable	   := Para.bSA_PI_Active AND NOT IN_GT.bSimWinMOD_Active;
	xMsg3444.Set 	   := bAMM_DPr_MGT_SetAct_Hi;
	xMsg3444.PT	       := T#5s;
	xMsg3444.Prio 	   := 4;
	xMsg3444.RiskClass := 4;
	xMsg3444.Reset 	   := FALSE;
	xMsg3444();
	MM2VIS.bMsg3444    := xMsg3444.Q;
	
	(* W3445 Pre chamber gas train set- to actual-gas pressure deviation *) (* SWAT Rel.5 *)
	xMsg3445.Enable	   := xEngType.Type9 AND NOT IN_GT.bSimWinMOD_Active;
	xMsg3445.Set 	   := bAMM_DPr_PCGT_SetAct_Hi;
	xMsg3445.PT	       := tiDPr_PCGT_SetAct_Hi;
	xMsg3445.Prio 	   := 4;
	xMsg3445.RiskClass := 4;
	xMsg3445.Reset 	   := FALSE;
	xMsg3445();
	MM2VIS.bMsg3445    := xMsg3445.Q;
	
	(* W3448 Measuring signal failure gas pressure after pre chamber gas pressure regulator *)
	xMsg3448.Enable	   := TRUE;
	xMsg3448.Set 	   := bAMM_Pr_PCGT_Out_MS ;
	xMsg3448.PT	       := T#2s;
	xMsg3448.Prio 	   := 4;
	xMsg3448.RiskClass := 4;
	xMsg3448.Reset 	   := FALSE;
	xMsg3448();
	MM2VIS.bMsg3448    := xMsg3448.Q;

	(* W3520 Failure Torch *)
	xMsg3520.Enable	   := TRUE;
	xMsg3520.Set 	   := bMsg3520_Set;
	xMsg3520.PT	       := T#0s;
	xMsg3520.Prio 	   := 4;
	xMsg3520.RiskClass := 4;
	xMsg3520.Reset 	   := FALSE;
	xMsg3520();
	MM2VIS.bMsg3520    := xMsg3520.Q;
		
	(* W3525 Measurement signal failure Calorific value measuring signal failure *)
	xMsg3525.Enable	   := TRUE;
	xMsg3525.Set 	   := MS_CV;
	xMsg3525.PT	       := T#0s;
	xMsg3525.Prio 	   := 4;
	xMsg3525.RiskClass := 4;
	xMsg3525.Reset 	   := FALSE;
	xMsg3525();
	MM2VIS.bMsg3525    := xMsg3525.Q;

	(* W3567 Disturbance Gas compressor *)
	xMsg3567.Enable	   := Para.bBiogasActive;
	xMsg3567.Set 	   := bMsg3567_Set;
	xMsg3567.PT	       := T#0s;
	xMsg3567.Prio 	   := 4;
	xMsg3567.RiskClass := 4;
	xMsg3567.Reset 	   := FALSE;
	xMsg3567();
	MM2VIS.bMsg3567    := xMsg3567.Q;
		
	(* W3568 Gastemperatur maximum enable alarm *)
	xMsg3568.Enable	   := Para.bBiogasActive;
	xMsg3568.Set 	   := bMsg3568_Set;
	xMsg3568.PT	       := T#0s;
	xMsg3568.Prio 	   := 4;
	xMsg3568.RiskClass := 4;
	xMsg3568.Reset 	   := FALSE;
	xMsg3568();
    MM2VIS.bMsg3568    := xMsg3568.Q;
	
	(* W3569 Gas pressure minimum before compressor maximum *)
	xMsg3569.Enable	   := Para.bBiogasActive;
	xMsg3569.Set 	   := bMsg3569_Set;
	xMsg3569.PT	       := T#0s;
	xMsg3569.Prio 	   := 4;
	xMsg3569.RiskClass := 4;
	xMsg3569.Reset 	   := FALSE;
	xMsg3569();
	MM2VIS.bMsg3569    := xMsg3569.Q;
	
	(* W3570 Measurement signal failure Gas pressure before compressor *)
	xMsg3570.Enable	   := Para.bBiogasActive;
	xMsg3570.Set 	   := bMsg3570_Set;
	xMsg3570.PT	       := T#0s;
	xMsg3570.Prio 	   := 4;
	xMsg3570.RiskClass := 4;
	xMsg3570.Reset 	   := FALSE;
	xMsg3570();
	MM2VIS.bMsg3570    := xMsg3570.Q;

	(* A3387 Antibackfire device gas train 1 - line 1 *)
	xMsg3387.Enable	   := TRUE;
	xMsg3387.Set 	   := NOT IN_GT.tGT1_1_BackFireDev.Di; 
	xMsg3387.PT	       := T#0s;
	xMsg3387.Prio 	   := 2;
	xMsg3387.RiskClass := 3;
	xMsg3387.Reset 	   := FALSE;
	xMsg3387();
	MM2VIS.bMsg3387    := xMsg3387.Q;

	(* A3388 Antibackfire device gas train 1 - line 2 *)
	xMsg3388.Enable	   := TRUE;
	xMsg3388.Set 	   := NOT IN_GT.tGT1_2_BackFireDev.Di; 
	xMsg3388.PT	       := T#0s;
	xMsg3388.Prio 	   := 2;
	xMsg3388.RiskClass := 3;
	xMsg3388.Reset 	   := FALSE;
	xMsg3388();
	MM2VIS.bMsg3388    := xMsg3388.Q;

	(* A3389 Antibackfire device gas train 1 - line 3 *)
	xMsg3389.Enable	   := TRUE;
	xMsg3389.Set 	   := NOT IN_GT.tGT1_3_BackFireDev.Di; 
	xMsg3389.PT	       := T#0s;
	xMsg3389.Prio 	   := 2;
	xMsg3389.RiskClass := 3;
	xMsg3389.Reset 	   := FALSE;
	xMsg3389();
	MM2VIS.bMsg3389    := xMsg3389.Q;

	(* A3390 Antibackfire device gas train 1 - line 4 *)
	xMsg3390.Enable	   := TRUE;
	xMsg3390.Set 	   := NOT IN_GT.tGT1_4_BackFireDev.Di; 
	xMsg3390.PT	       := T#0s;
	xMsg3390.Prio 	   := 2;
	xMsg3390.RiskClass := 3;
	xMsg3390.Reset 	   := FALSE;
	xMsg3390();
	MM2VIS.bMsg3390    := xMsg3390.Q;

	(* A3391 Antibackfire device prechamper before compressor *)
	xMsg3391.Enable	   := TRUE;
	xMsg3391.Set 	   := NOT IN_GT.tPCbComp_BackFireDev.Di; 
	xMsg3391.PT	       := T#0s;
	xMsg3391.Prio 	   := 2;
	xMsg3391.RiskClass := 3;
	xMsg3391.Reset 	   := FALSE;
	xMsg3391();
	MM2VIS.bMsg3391    := xMsg3391.Q;

	(* A3392 Antibackfire device prechamper after compressor *)
	xMsg3392.Enable	   := TRUE;
	xMsg3392.Set 	   := NOT IN_GT.tPCaComp_BackFireDev.Di;
	xMsg3392.PT	       := T#0s;
	xMsg3392.Prio 	   := 2;
	xMsg3392.RiskClass := 3;
	xMsg3392.Reset 	   := FALSE;
	xMsg3392();
	MM2VIS.bMsg3392    := xMsg3392.Q;
	
	(* W9259: Position Feedback Error Gas Valve 1  *)
	xMsg9259.Enable	   := IN_GT.tGV1_Opened.GoodQual OR IN_GT.tGV1_Closed.GoodQual ;		(*V4.09 update: replaces ...Para.bGVStatus_Active; *)
	xMsg9259.Set 	   := tGV_struct[1].gv_status > 1;
	xMsg9259.PT	       := IN_GT.tCU2GT.tiGV_Feedback_Delay_max;
	xMsg9259.Prio 	   := 4;
	xMsg9259.RiskClass := 4;
	xMsg9259.Reset 	   := FALSE;
	xMsg9259();
	MM2VIS.bMsg9259    := xMsg9259.Q;
	MM2VIS.tGV1_struct :=  tGV_struct[1];

	(* W9260: Position Feedback Error Gas Valve 2  *)
	xMsg9260.Enable	   := IN_GT.tGV2_Opened.GoodQual OR IN_GT.tGV2_Closed.GoodQual ;		(*V4.09 update: replaces ...Para.bGVStatus_Active; *)
	xMsg9260.Set 	   := tGV_struct[2].gv_status > 1;
	xMsg9260.PT	       := IN_GT.tCU2GT.tiGV_Feedback_Delay_max;
	xMsg9260.Prio 	   := 4;
	xMsg9260.RiskClass := 4;
	xMsg9260.Reset 	   := FALSE;
	xMsg9260();
	MM2VIS.bMsg9260    := xMsg9260.Q;
	MM2VIS.tGV2_struct :=  tGV_struct[2];		

	(* W9275: Customer Main Gas Valve Position Feedback Error    	Hauptgasventil Kunde Stellungsrückmeldung gestört *)
	xMsg9275.Enable	   := Para.iGasTrain_Upstream_Type > 0 ;					//  := tGV_struct[0].rel_trip AND tGV_struct[0].gv_status <99999;		
	xMsg9275.Set 	   := tGV_struct[0].gv_status > 1;
	xMsg9275.PT	       := IN_GT.tCU2GT.tiGV_Feedback_Delay_max;
	xMsg9275.Prio 	   := 4;
	xMsg9275.RiskClass := 4;
	xMsg9275.Reset 	   := FALSE;
	xMsg9275();
	MM2VIS.bMsg9275    := xMsg9275.Q;
	MM2VIS.tGV_Upstream_struct :=  tGV_struct[0];
	
	(* Warning W9276: Gas Temp max. *)
	xMsg9276.Enable	   := TRUE;	
	xMsg9276.Set 	   := FALSE;  //FEHLT NOCH 
	xMsg9276.PT	       := T#0s;
	xMsg9276.Prio 	   := 4;
	xMsg9276.RiskClass := 4;
	xMsg9276.Reset 	   := FALSE;
	xMsg9276();
	MM2VIS.bMsg9276    := xMsg9276.Q;
	
	(* 9300 Natural gas temperature measurement signal failure *)
	xMsg9300.Enable	   := Para.bT_GT_NG_Exist;
	xMsg9300.Set 	   := NOT IN_GT.tT_GT_NG.GoodQual;
	xMsg9300.PT	       := T#0s;
	xMsg9300.Prio 	   := 4;
	xMsg9300.RiskClass := 4;
	xMsg9300.Reset 	   := FALSE;
	xMsg9300();
	MM2VIS.bMsg9300    := xMsg9300.Q;

	(* 9301 Natural gas pressure measurement signal failure *)
	xMsg9301.Enable	   := Para.bPr_GT_NG_Exist;
	xMsg9301.Set 	   := NOT IN_GT.tPr_GT_NG.GoodQual;
	xMsg9301.PT	       := T#0s;
	xMsg9301.Prio 	   := 4;
	xMsg9301.RiskClass := 4;
	xMsg9301.Reset 	   := FALSE;
	xMsg9301();
	MM2VIS.bMsg9301    := xMsg9301.Q;

	(* 9302 Natural gas volume measurement signal failure *)
	xMsg9302.Enable	   := Para.bVol_GT_NG_Exist;
	xMsg9302.Set 	   := NOT IN_GT.tVol_GT_NG.GoodQual;
	xMsg9302.PT	       := T#0s;
	xMsg9302.Prio 	   := 4;
	xMsg9302.RiskClass := 4;
	xMsg9302.Reset 	   := FALSE;
	xMsg9302();
	MM2VIS.bMsg9302    := xMsg9302.Q;

	(* W9360 H2 content measuring signal failure *)
	xMsg9360.Enable	   := TRUE;
	xMsg9360.Set 	   := bMSF_H2;
	xMsg9360.PT	       := T#0s;
	xMsg9360.Prio 	   := 4;
	xMsg9360.RiskClass := 4;
	xMsg9360.Reset 	   := FALSE;
	xMsg9360();
	MM2VIS.bMsg9360    := xMsg9360.Q;

	(* W9361 H2 content high *)
	xMsg9361.Enable	   := TRUE;
	xMsg9361.Set 	   := bH2_MAX_W;
	xMsg9361.PT	       := T#5s;
	xMsg9361.Prio 	   := 4;
	xMsg9361.RiskClass := 4;
	xMsg9361.Reset 	   := FALSE;
	xMsg9361();
	MM2VIS.bMsg9361    := xMsg9361.Q;	

	(* A2364 H2 content high *)
	xMsg2364.Enable	   := TRUE;
	xMsg2364.Set 	   := bH2_MAX_A;
	xMsg2364.PT	       := T#5s;
	xMsg2364.Prio 	   := 2;
	xMsg2364.RiskClass := 3;
	xMsg2364.Reset 	   := FALSE;
	xMsg2364();
	MM2VIS.bMsg2364    := xMsg2364.Q;

	(* W9371 Measuring signal failure setpoint - Gas mixing *)
	xMsg9371.Enable	   := TRUE;		
	xMsg9371.Set 	   := bMsg9371_Set;
	xMsg9371.PT	       := T#0s;
	xMsg9371.Prio 	   := 4;
	xMsg9371.RiskClass := 4;
	xMsg9371.Reset 	   := FALSE;
	xMsg9371();
	MM2VIS.bMsg9371    := xMsg9371.Q;

	(* W9387 Prechamber gas pressure low *)
	xMsg9387.Enable	   := TRUE;		
	xMsg9387.Set 	   := bMsg9387_Set;
	xMsg9387.PT	       := T#0s;
	xMsg9387.Prio 	   := 4;
	xMsg9387.RiskClass := 4;
	xMsg9387.Reset 	   := FALSE;
	xMsg9387();
	MM2VIS.bMsg9387    := xMsg9387.Q;
	
	(* W9509 Pre chamber gas bypass valve malfunction *)
	xMsg9509.Enable	   := Para.bPCG_BPV_Active;		
	xMsg9509.Set 	   := bMsg9509_Set;
	xMsg9509.PT	       := T#0s;
	xMsg9509.Prio 	   := 4;
	xMsg9509.RiskClass := 4;
	xMsg9509.Reset 	   := FALSE;
	xMsg9509();
	MM2VIS.bMsg9509    := xMsg9509.Q;
	
	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)	
	
	(* B1251 selection gas type 1_2 *)
	xMsg1251.Enable		:=	TRUE;
	xMsg1251.Set		:=	IN_GT.bGasTypMix1_2_Act AND (MM2VIS.iIdx_Gtyp_Act = 12);
	xMsg1251.Reset		:=	TRUE;
	xMsg1251();
	MM2VIS.bMsg1251		:=	xMsg1251.Q;

	(* B1252 selection ign.point 1_2 *)
	xMsg1252.Enable		:=	TRUE;
	xMsg1252.Set		:=	IN_GT.bGasTypMix1_2_Act AND (MM2VIS.iIdx_Gtyp_Act = 12);
	xMsg1252.Reset		:=	TRUE;
	xMsg1252();
	MM2VIS.bMsg1252		:=	xMsg1252.Q;

	(* B1265 Demand gas leakage check gas train 1 *)			
	xMsg1265.Enable		:=	TRUE;
	xMsg1265.Set		:=	(NOT OUT_GT.tGT1_SafeDevice.Do 		AND NOT IN_GT.bSafetyPLC_Active) OR 		(* SAFETY PLC *)
							(NOT IN_GT.bSafeOUT_GT1_SD_Dem_PS	AND		IN_GT.bSafetyPLC_Active);			(* SAFETY PLC *)
	xMsg1265.Reset		:=	TRUE;
	xMsg1265();			
	MM2VIS.bMsg1265		:=	xMsg1265.Q;
				
	(* B1266 Release from gas leakage check gas train 1 *)			
	xMsg1266.Enable		:=	IN_GT.tPB2MM.bSys_Run;
	xMsg1266.Set		:=	IN_GT.tGT1_SafeDevOK.Di OR IN_GT.bSafeOUT_GT1_SafeDevOK;						(* SAFETY PLC *)
	xMsg1266.Reset		:=	TRUE;
	xMsg1266();			
	MM2VIS.bMsg1266		:=	xMsg1266.Q;
				
	(* B1267 Demand gas leakage check gas train 2 *)			
	xMsg1267.Enable		:=	IN_GT.tPB2MM.bSys_Run AND Para.iNum_GT > 1;
	xMsg1267.Set		:=	(NOT OUT_GT.tGT2_SafeDevice.Do 		AND NOT IN_GT.bSafetyPLC_Active) OR 		(* SAFETY PLC *)
							(NOT IN_GT.bSafeOUT_GT2_SD_Dem_PS	AND		IN_GT.bSafetyPLC_Active);			(* SAFETY PLC *)
	xMsg1267.Reset		:=	TRUE;
	xMsg1267();			
	MM2VIS.bMsg1267		:=	xMsg1267.Q;
				
	(* B1268 Release from gas leakage check gas train 2 *)			
	xMsg1268.Enable		:=	IN_GT.tPB2MM.bSys_Run AND Para.iNum_GT > 1;
	xMsg1268.Set		:=	IN_GT.tGT2_SafeDevOK.Di OR IN_GT.bSafeOUT_GT2_SafeDevOK;						(* SAFETY PLC *)
	xMsg1268.Reset		:=	TRUE;
	xMsg1268();			
	MM2VIS.bMsg1268		:=	xMsg1268.Q;

	(* B1269 Demand from gas leakage check gas train 3 *)			
	xMsg1269.Enable		:=	FALSE;
	xMsg1269.Set		:=	FALSE;
	xMsg1269.Reset		:=	TRUE;
	xMsg1269();			
	MM2VIS.bMsg1269		:=	xMsg1269.Q;
				
	(* B1270 Release from gas leakage check gas train 3 *)			
	xMsg1270.Enable		:=	FALSE;
	xMsg1270.Set		:=	FALSE;
	xMsg1270.Reset		:=	TRUE;
	xMsg1270();			
	MM2VIS.bMsg1270		:=	xMsg1270.Q;
				
	(* B1271 Demand from gas leakage check gas train 4 *)			
	xMsg1271.Enable		:=	FALSE;
	xMsg1271.Set		:=	FALSE;
	xMsg1271.Reset		:=	TRUE;
	xMsg1271();			
	MM2VIS.bMsg1271		:=	xMsg1271.Q;
				
	(* B1272 Release from gas leakage check gas train 4 *)			
	xMsg1272.Enable		:=	FALSE;
	xMsg1272.Set		:=	FALSE;
	xMsg1272.Reset		:=	TRUE;
	xMsg1272();			
	MM2VIS.bMsg1272		:=	xMsg1272.Q;
	
	(* B2927 measuring signal failure gas pressure after filter in main gas train *) (* SWAT Rel.2 *)
	xTP_2927_from2462(IN:= EDGEPOS(MM2VIS.bMsg2462), PT:= T#10s);
	xTP_2927_EngStart(IN:= EDGENEG(IN_GT.bEng_Start), PT:= T#10s);		//EDGENEG, weil die IN Schnittstelle in Cyclic#5 gemappt wird. "MsgGT" hat den aktuellen Wert vor "gas_train" im Eingangsabbild.
	xMsg2927.Enable		:=	TRUE;
	xMsg2927.Set		:=  xTP_2927_from2462.Q OR (MM2VIS.bMsg2462 AND xTP_2927_EngStart.Q);
	xMsg2927.Reset		:=	TRUE;
	xMsg2927();
	MM2VIS.bMsg2927		:=	xMsg2927.Q;	  
	MM2VIS.iMsg2927	    :=  UINT_TO_INT(xCTD_Start.CV);

	(* B2928 measuring signal failure gas pressure after filter in prechamber gas train *)	(* SWAT Rel.3 *)
	xTP_2928_from2465(IN:= EDGEPOS(MM2VIS.bMsg2465), PT:= T#10s);
	xTP_2928_EngStart(IN:= EDGENEG(IN_GT.bEng_Start), PT:= T#10s);		//EDGENEG, weil die IN Schnittstelle in Cyclic#5 gemappt wird. "MsgGT" hat den aktuellen Wert vor "gas_train" im Eingangsabbild.
	xMsg2928.Enable		:=	TRUE;
	xMsg2928.Set		:=  xTP_2928_from2465.Q OR (MM2VIS.bMsg2465 AND xTP_2928_EngStart.Q);
	xMsg2928.Reset		:=	TRUE;
	xMsg2928();
	MM2VIS.bMsg2928		:=	xMsg2928.Q;	  
	MM2VIS.iMsg2928	    :=  UINT_TO_INT(xCTD_Start2465.CV);
	
	(* B2990 Customer Main Gas Valve opened				Hauptgasventil Kunde offen V4.07	*)
	xMsg2990.Enable		:=	IN_GT.tPB2MM.bSys_Run;
	xMsg2990.Set		:=	IN_GT.tGV_Upstream_Opened.Di;
	xMsg2990.Reset		:=	TRUE;
	xMsg2990();			
	MM2VIS.bMsg2990		:=	xMsg2990.Q;
	
	(* B2991 Customer Main Gas Valve closed				Hauptgasventil Kunde geschlossen V4.07	*)
	xMsg2991.Enable		:=	IN_GT.tPB2MM.bSys_Run;
	xMsg2991.Set		:=	IN_GT.tGV_Upstream_Closed.Di;
	xMsg2991.Reset		:=	TRUE;
	xMsg2991();			
	MM2VIS.bMsg2991		:=	xMsg2991.Q;
	
	(* B2992	Gas Valve 1 reports open state			Gasventil 1 Hauptgasstrecke Statusmeldung offen 		V4.07	*)
	xMsg2992.Enable		:=	IN_GT.tPB2MM.bSys_Run;
	xMsg2992.Set		:=	IN_GT.tGV1_Opened.Di;
	xMsg2992.Reset		:=	TRUE;
	xMsg2992();			
	MM2VIS.bMsg2992		:=	xMsg2992.Q;
	
	(* B2993	Gas Valve 1 reports closed state		Gasventil 1 Hauptgasstrecke Statusmeldung geschlossen	 V4.07	*)
	xMsg2993.Enable		:=	IN_GT.tPB2MM.bSys_Run;
	xMsg2993.Set		:=	IN_GT.tGV1_Closed.Di;
	xMsg2993.Reset		:=	TRUE;
	xMsg2993();			
	MM2VIS.bMsg2993		:=	xMsg2993.Q;
	
	(* B2994	Gas Valve 2 reports open state			Gasventil 2 Hauptgasstrecke  Statusmeldung offen		 V4.07	*)
	xMsg2994.Enable		:=	IN_GT.tPB2MM.bSys_Run;
	xMsg2994.Set		:=	IN_GT.tGV2_Opened.Di;
	xMsg2994.Reset		:=	TRUE;
	xMsg2994();			
	MM2VIS.bMsg2994		:=	xMsg2994.Q;
	
	(* B2995	Gas Valve 2 reports closed state 		Gasventil 2 Hauptgasstrecke  Statusmeldung geschlossen	 V4.07	*)
	xMsg2995.Enable		:=	IN_GT.tPB2MM.bSys_Run;
	xMsg2995.Set		:=	IN_GT.tGV2_Closed.Di;
	xMsg2995.Reset		:=	TRUE;
	xMsg2995();			
	MM2VIS.bMsg2995		:=	xMsg2995.Q;
	
	(* B2996	Gas Valve closed BY manual command		Gasventil schließen Kommando manuell			 V4.07	*)
	xMsg2996.Enable		:=	FALSE;
	//FEHLT NOCH xMsg2996.Set		:=	IN_GT.tGV2_Closed.Di;
	xMsg2996.Reset		:=	TRUE;
	xMsg2996();			
	MM2VIS.bMsg2996		:=	xMsg2996.Q;
	
	(* B2997 Gas Compressor demand prolonged for Gas Valve Check  	Gaskompressor Anforderung verlängert für Gasdichteprüfung	 V4.09	*)
	xMsg2997.Enable		:=	IN_GT.tPB2MM.bSys_Run;
	xMsg2997.Set		:=	bMsg2997_Set;
	xMsg2997.Reset		:=	TRUE;
	xMsg2997();			
	MM2VIS.bMsg2997		:=	xMsg2997.Q;
	
	(* B3227 Backfire *)
	xMsg3227.Enable		:=	TRUE;
	xMsg3227.Set		:=	OUT_GT.bDeflagrationPrct AND (xEngType.Type6 OR xEngType.Type9); 
	xMsg3227.Reset		:=	TRUE;
	xMsg3227();
	MM2VIS.bMsg3227		:=	xMsg3227.Q;

	(* B3257 selection gas type 1/3 *)
	xMsg3257.Enable		:=	TRUE;
	xMsg3257.Set		:=	(MM2VIS.iIdx_Gtyp_Act = 13);
	xMsg3257.Reset		:=	TRUE;
	xMsg3257();
	MM2VIS.bMsg3257		:=	xMsg3257.Q;
	
	(* B3258 selection gas type 1-2/3 *)
	xMsg3258.Enable		:=	TRUE;
	xMsg3258.Set		:=	(MM2VIS.iIdx_Gtyp_Act = 123);
	xMsg3258.Reset		:=	TRUE;
	xMsg3258();
	MM2VIS.bMsg3258		:=	xMsg3258.Q;
	
	(* B3259 selection ignition point 1/3 *)
	xMsg3259.Enable		:=	TRUE;
	xMsg3259.Set		:=	(MM2VIS.iIdx_Gtyp_Act = 13);
	xMsg3259.Reset		:=	TRUE;
	xMsg3259();
	MM2VIS.bMsg3259		:=	xMsg3259.Q;
	
	(* B3260 selection ignition point 1-2/3 *)
	xMsg3260.Enable		:=	TRUE;
	xMsg3260.Set		:=	(MM2VIS.iIdx_Gtyp_Act = 123);
	xMsg3260.Reset		:=	TRUE;
	xMsg3260();
	MM2VIS.bMsg3260		:=	xMsg3260.Q;
	
	(* B3261 Selection gas quality manual *)
	xMsg3261.Enable		:=	TRUE;
	xMsg3261.Set		:=	bGT_QualMix_Man_Set;
	xMsg3261.Reset		:=	TRUE;
	xMsg3261();
	MM2VIS.bMsg3261		:=	xMsg3261.Q;
	
	(* B3262 Selection gas mixture manual *)
	xMsg3262.Enable		:=	TRUE;
	xMsg3262.Set		:=	bSetMix_Man;
	xMsg3262.Reset		:=	TRUE;
	xMsg3262();
	MM2VIS.bMsg3262		:=	xMsg3262.Q;

	(* B2976 Power reduction gas proportioning valve differential pressure minimum *)
	xMsg2976.Enable		:=	TRUE;
	xMsg2976.Set		:=	bPr_TecJetDP_P_Red;
	xMsg2976.Reset		:=	TRUE;
	xMsg2976();
	MM2VIS.bMsg2976		:=	xMsg2976.Q;

	(* B9086 Gas valves open *)
	xMsg9086.Enable		:=	TRUE;
	xMsg9086.Set		:=	MM2VIS.bGV_On;
	xMsg9086.Reset		:=	TRUE;
	xMsg9086();
	MM2VIS.bMsg9086		:=	xMsg9086.Q;	
	
	(* B9087 Gas valves closed *)
	xTP_9087_GVOff(IN:= NOT MM2VIS.bGV_On, PT:= T#10s);
	xMsg9087.Enable		:=	TRUE;
	xMsg9087.Set		:=	xTP_9087_GVOff.Q;
	xMsg9087.Reset		:=	TRUE;
	xMsg9087();
	MM2VIS.bMsg9087		:=	xMsg9087.Q;	
	
	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1   := OUT_GT.tGT2AB.bGnlTrip1   OR IN_GT.tAB2GT.bGnlTrip1;
	bGnlTrip2   := OUT_GT.tGT2AB.bGnlTrip2   OR IN_GT.tAB2GT.bGnlTrip2;
	bGnlTrip3   := OUT_GT.tGT2AB.bGnlTrip3   OR IN_GT.tAB2GT.bGnlTrip3;
	bGnlWarning := OUT_GT.tGT2AB.bGnlWarning OR IN_GT.tAB2GT.bGnlWarning;

	bGnlTrip	:=	bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
(*******************************************************************************)
END_PROGRAM
