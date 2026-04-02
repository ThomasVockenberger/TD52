(*******************************************************************************
MsgOG	 			 alarms generation MM_Opstate

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V3.99.0	xx-03-2012	Graus		new
		27.05.2013	Lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
		05.10.2013	Graus,		add messages bMsg2122, bMsg2123, bMsg2124
V4.00.0 11.02.2014 	Graus,		change Version TO 4.0
		04.03.2014	lettenb.	logger added
V4.01.0	18.07.2014	Graus,		use both staticGR power reductions for same operation message (bP_Red_EVU OR bP_Red_EU)
V4.04.0 11.02.2014 	Graus,		change Version TO 4.04
V4.04.0 17.11.2016	Gomez Ortiz	Addition of B2168 generator air inlet temperature power reduction	
V4.05.0 14.06.2017	Gomez Ortiz Addition OF power limitation due TO low engine cooling water temperature, Spec_Start_Load_release_manual_start.doc
V4.05.1	25.09.2017  Gomez Ortiz Removal of UW_PDIFF_A (engine type dependency) from the Alarm 1108 and Alarm 2097
V4.05.2	24.10.2017	Zingerle	SWAT 920 Rel.5, power reduction with difference pressure minimum (bMsg2936)
V4.07.0	11.07.2018	Messner,	CPP Integrator - B2961 added
		23.10.2018	Maran,		implemented B2983 - B2985 for request selector switch positions
V4.07.4	29.03.2019	Hohensinner	Bugfixing: added W9284 
V4.07.5	15.05.2019	Hohensinner	added EngBlock_PlantCtr DI to W1188
V4.09.0 03.02.2020	Zuschnig	included TOF (60s) for operation message B1283 to B1287
		12.02.2020	Zuschnig	included B2972 and B2973 - Power Mode on/off and ParaSetupOk plus 2 sec for B2140
V4.11.0	23.04.2021  Zuschnig	Bugfix - B2154 triggered with high frequency bit
        20.08.2021 	Keller		Add Messages 9051, 9052, 9061, 9062 
		22.11.2021	Perktold,	added B9063, B9064
		22.12.2021	Andre		added B2935 Power reduction by CAN communication failure for half or more SAFI or too many SAFI reboots
		01.04.2022	Zuschnig 	TOF with 60s for messages 2130, 2152, 2153 and 2154 to prevent too many messages
V4.12.0	12.01.2023  Tinello		Deleted power reduction by T1HP (2803) / Added power reduction by T2HP (9075) and T2LP (9076)
    	16.01.2023  Zuschnig	TOF with 60s for message 2989 to prevent too many messages
		22.01.2023  Zuschnig	Include B9072 - Power reduction by H2 content
						
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
	OUT_OP.tOP2AB.bGnlTrip1			:=	FALSE;
	OUT_OP.tOP2AB.bGnlTrip2			:=	FALSE;
	OUT_OP.tOP2AB.bGnlTrip3			:=	FALSE;
	OUT_OP.tOP2AB.bGnlWarning		:=	FALSE;
	OUT_OP.tOP2AB.bTriptype1		:=	FALSE;
	OUT_OP.tOP2AB.bTriptype2		:=	FALSE;
	OUT_OP.tOP2AB.bTriptype3		:=	FALSE;	


	(*---------------------------------------------------------------------------*)
	// Alarms and warnings

	(* A1108 actual power deviation maximum *)
	xMsg1108.Enable		:=	FALSE;
	xMsg1108.Set		:=	AN_PDIFF AND T99;			(*Gomez Ortiz, no more engine type dependency for this alarm setting*)
	xMsg1108.PT			:=	T#0s;	
	xMsg1108.Prio		:=	3;
	xMsg1108.RiskClass	:=	4;
	xMsg1108.Reset		:=	FALSE;
	xMsg1108();
	bMsg1108			:= xMsg1108.Q;
	OUT_OP.bMsg1108 	:= xMsg1108.Q;

	(* W3506 Power reduction in isolated operation *)
	xMsg3506.Enable		:=	TRUE;
	xMsg3506.Set		:=	bPRed_Active AND xOpMode.Island;
	xMsg3506.PT			:=	T#0s;	
	xMsg3506.Prio		:=	4;
	xMsg3506.RiskClass	:=	4;
	xMsg3506.Reset		:=	FALSE;
	xMsg3506();
	bMsg3506			:= xMsg3506.Q;

	(* W2082 Warning: Parameters missing *)
	xMsg2082.Enable		:=	TRUE;
	xMsg2082.Set		:=	RPSW_1;
	xMsg2082.PT			:=	T#0s;	
	xMsg2082.Prio		:=	4;
	xMsg2082.RiskClass	:=	4;
	xMsg2082.Reset		:=	FALSE;
	xMsg2082();
	bMsg2082			:= xMsg2082.Q;

	(* W1188 release by station missing *)					
	xMsg1188.Enable		:=	TRUE;
	xMsg1188.Set		:=	NOT AT27 OR bEng_Block_PlantCtr;
	xMsg1188.PT			:=	T#0s;	
	xMsg1188.Prio		:=	4;
	xMsg1188.RiskClass	:=	4;
	xMsg1188.Reset		:=	IN_OP.tEngBlock_PlantCtr.GoodQual;
	xMsg1188();
	bMsg1188			:= xMsg1188.Q;

	(* W2097 Leistungsistwertabweichung Maximum *)
	xMsg2097.Enable		:=	TRUE;
	xMsg2097.Set		:=	AN_PDIFF AND T99;	(*Gomez Ortiz, no more engine type dependency for this alarm setting*)
	xMsg2097.PT			:=	T#0s;	
	xMsg2097.Prio		:=	4;
	xMsg2097.RiskClass	:=	4;
	xMsg2097.Reset		:=	FALSE;
	xMsg2097();
	bMsg2097			:= xMsg2097.Q;

	(* W9284 Measuring signal failure External power set point for Speed droop mode *)
	xMsg9284.Enable		:=	IN_OP.tPB2MM.bParaSetupOk AND IN_OP.tP_Droop_Set.Exist AND (IN_OP.iSource_F_N_OffsSet = 1);
	xMsg9284.Set		:=	NOT IN_OP.tP_Droop_Set.GoodQual;
	xMsg9284.PT			:=	T#1s;	
	xMsg9284.Prio		:=	4;
	xMsg9284.RiskClass	:=	4;
	xMsg9284.Reset		:=	FALSE;
	xMsg9284();
	MM2VIS.bMsg9284		:= xMsg9284.Q;

	(*-----------------------------------------------------------------------*)
	(* operating messages > AMM *)

	(* B2125 P reduction by knocking (diagn.msg RPS) *)	
	xMsg2125.Enable		:=	TRUE;
	xMsg2125.Set		:=	xPRed[_Knck].Q; 
	xMsg2125.Reset		:=	TRUE;
	xMsg2125();
	bMsg2125			:=	xMsg2125.Q;
	
	(* B2126 P reduction by mixture temp. (diagn.msg RPS) *)
	xMsg2126.Enable		:=	TRUE;
	xMsg2126.Set		:=	xPRed[_TMix].Q AND IN_OP.tGCB_On.Di;
	xMsg2126.Reset		:=	TRUE;
	xMsg2126();
	bMsg2126			:=	xMsg2126.Q;

	(* B2127 P reduction by misfiring (diagn.msg RPS) *)
	xMsg2127.Enable		:=	TRUE;
	xMsg2127.Set		:=	xPRed[_Misf].Q;
	xMsg2127.Reset		:=	TRUE;
	xMsg2127();
	bMsg2127			:=	xMsg2127.Q;
	
	(* B2128 P reduction by external(analoge) (diagn.msg RPS) *) 
	xMsg2128.Enable		:=	TRUE;
	xMsg2128.Set		:=	xPRed[_AI].Q;
	xMsg2128.Reset		:=	TRUE;
	xMsg2128();
	bMsg2128			:=	xMsg2128.Q;
	
	(* B2129 P reduction by external(bus) (diagn.msg RPS) *)
	xMsg2129.Enable		:=	TRUE;
	xMsg2129.Set		:=	xPRed[_EBus].Q;
	xMsg2129.Reset		:=	TRUE;
	xMsg2129();
	bMsg2129			:=	xMsg2129.Q;
	
	(* B2130 P reduction by frequency low (diagn.msg RPS) *)
	xTOF_Msg2130(IN:= xPRed[_F_Lo].Q, PT := T#60s);
	
	xMsg2130.Enable		:=	TRUE;
	xMsg2130.Set		:=	xTOF_Msg2130.Q;
	xMsg2130.Reset		:=	TRUE;
	xMsg2130();
	bMsg2130			:=	xMsg2130.Q;
	
	(* B2131 maximum output limit *)
	xMsg2131.Enable		:=	TRUE;
	xMsg2131.Set		:=	xPRed[_PMax].Q;
	xMsg2131.Reset		:=	TRUE;
	xMsg2131();
	bMsg2131			:=	xMsg2131.Q;
	
	(* B2132 P reduction by cyl.temp. (diagn.msg RPS) *)
	xMsg2132.Enable		:=	TRUE;
	xMsg2132.Set		:=	xPRed[_EGT].Q;
	xMsg2132.Reset		:=	TRUE;
	xMsg2132();
	bMsg2132			:=	xMsg2132.Q;
	
	(* B2140 demand for island operation *)
	xMsg2140.Enable		:=	TRUE;
	xMsg2140.Set		:=	OUT_OP.bEng_Dem_EPS AND NOT IN_OP.bOnly_Island AND bParaSetupOk_2s;(* M_NANF AND NOT REIN_INSEL *)
	xMsg2140.Reset		:=	TRUE;
	xMsg2140();
	bMsg2140			:=	xMsg2140.Q;
	
	(*B2143 P reduction by air intake temp. (diagn.msg RPS) *)
	xMsg2143.Enable		:=	TRUE;
	xMsg2143.Set		:=	xPRed[_T1LP].Q;
	xMsg2143.Reset		:=	TRUE;
	xMsg2143();
	bMsg2143			:=	xMsg2143.Q;
	
	(* B2144 P reduction by turbo charger speed high (diagn.msg RPS) *)
	xMsg2144.Enable		:=	TRUE;
	xMsg2144.Set		:=	xPRed[_N_TC].Q;
	xMsg2144.Reset		:=	TRUE;
	xMsg2144();
	bMsg2144			:=	xMsg2144.Q;
	
	(* B2146 PBC power reduction *)
	xMsg2146.Enable		:=	TRUE;
	xMsg2146.Set		:=	xPRed[_PBC].Q;
	xMsg2146.Reset		:=	TRUE;
	xMsg2146();
	bMsg2146			:=	xMsg2146.Q;
	
	(* B2147 P reduction by leanox ctrl.deviation high (diagn.msg RPS) *)
	xMsg2147.Enable		:=	TRUE;
	xMsg2147.Set		:=	xPRed[_LX].Q;
	xMsg2147.Reset		:=	TRUE;
	xMsg2147();
	bMsg2147			:=	xMsg2147.Q;
	
	(* B2148 diagn.msg RPS 28 *)
	xMsg2148.Enable		:=	TRUE;
	xMsg2148.Set		:=	xPRed[_SP1].Q;
	xMsg2148.Reset		:=	TRUE;
	xMsg2148();
	bMsg2148			:=	xMsg2148.Q;
	
	(* B2149 diagn.msg RPS 29 *)
	xMsg2149.Enable		:=	TRUE;
	xMsg2149.Set		:=	xPRed[_SP2].Q;
	xMsg2149.Reset		:=	TRUE;
	xMsg2149();
	bMsg2149			:=	xMsg2149.Q;
	
	(* B2150 diagn.msg RPS 30 *)
	xMsg2150.Enable		:=	TRUE;
	xMsg2150.Set		:=	xPRed[_SP3].Q;
	xMsg2150.Reset		:=	TRUE;
	xMsg2150();
	bMsg2150			:=	xMsg2150.Q;
	
	(* B2152 P reduction by voltage low  (diagn.msg RPS) *)
	xTOF_Msg2152(IN:= xPRed[_U_Lo].Q, PT := T#60s);

	xMsg2152.Enable		:=	TRUE;
	xMsg2152.Set		:=	xTOF_Msg2152.Q;
	xMsg2152.Reset		:=	TRUE;
	xMsg2152();
	bMsg2152			:=	xMsg2152.Q;
	
	(* B2153 P reduction by voltage high (diagn.msg RPS) *)
	xTOF_Msg2153(IN:= xPRed[_U_Hi].Q, PT := T#60s);

	xMsg2153.Enable		:=	TRUE;
	xMsg2153.Set		:=	xTOF_Msg2153.Q;
	xMsg2153.Reset		:=	TRUE;
	xMsg2153();
	bMsg2153			:=	xMsg2153.Q;
	
	(* B2154 P reduction by frequency high (diagn.msg RPS) *)
	xTOF_Msg2154(IN:= xPRed[_F_Hi].Q, PT := T#60s);

	xMsg2154.Enable		:=	TRUE;
	xMsg2154.Set		:=	xTOF_Msg2154.Q;
	xMsg2154.Reset		:=	TRUE;
	xMsg2154();
	bMsg2154			:=	xMsg2154.Q;
	
	(* B2155 P reduction by gen.winding temp. (diagn.msg RPS) *)
	xMsg2155.Enable		:=	TRUE;
	xMsg2155.Set		:=	xPRed[_GWT].Q;
	xMsg2155.Reset		:=	TRUE;
	xMsg2155();
	bMsg2155			:=	xMsg2155.Q;
	
	(* B2158 P reduction by jacket water temperature (diagn.msg RPS) *)
	xMsg2158.Enable		:=	TRUE;
	xMsg2158.Set		:=	xPRed[_JWT].Q;
	xMsg2158.Reset		:=	TRUE;
	xMsg2158();
	bMsg2158			:=	xMsg2158.Q;
	
	(* B2159 P reduction by oil temperature (diagn.msg RPS) *)
	xMsg2159.Enable		:=	TRUE;
	xMsg2159.Set		:=	xPRed[_OILT].Q;
	xMsg2159.Reset		:=	TRUE;
	xMsg2159();
	bMsg2159			:=	xMsg2159.Q;
	
	(* B2160 P reduction by heating water return temperature (diagn.msg RPS) *) 
	xMsg2160.Enable		:=	TRUE;
	xMsg2160.Set		:=	xPRed[_RWT].Q;
	xMsg2160.Reset		:=	TRUE;
	xMsg2160();
	bMsg2160			:=	xMsg2160.Q;
	
	(* B2161 P reduction by pressure pre chamber gas train (diagn.msg RPS) *)
	xMsg2161.Enable		:=	TRUE;
	xMsg2161.Set		:=	xPRed[_PCGT].Q;
	xMsg2161.Reset		:=	TRUE;
	xMsg2161();
	bMsg2161			:=	xMsg2161.Q;
	
	(* B2163 Power reduction by utility *)
	xMsg2163.Enable		:=	TRUE;
	xMsg2163.Set		:=	xPRed[_EVU].Q OR xPRed[_EU].Q;
	xMsg2163.Reset		:=	TRUE;
	xMsg2163();
	bMsg2163			:=	xMsg2163.Q;
	
	(* B2164 Power limitation by air humidity *)
	xMsg2164.Enable		:=	TRUE;
	xMsg2164.Set		:=	xPRed[_Hum].Q;
	xMsg2164.Reset		:=	TRUE;
	xMsg2164();
	bMsg2164			:=	xMsg2164.Q;
	
	(* B2170 power redutcion by hierarchy controller *)
	xMsg2170.Enable		:=	TRUE;
	xMsg2170.Set		:=	xPRed[_HiCtr].Q;
	xMsg2170.Reset		:=	TRUE;
	xMsg2170();
	bMsg2170			:=	xMsg2170.Q;
	
	(* B2169 power redutcion by  timing point optimizing *)
	xMsg2169.Enable		:=	TRUE;
	xMsg2169.Set		:=	xPRed[_IPOpt].Q;
	xMsg2169.Reset		:=	TRUE;
	xMsg2169();
	bMsg2169			:=	xMsg2169.Q;
	
	(* B2803 power reduction by charge temp.before HP TC *)			(* --> NOT USED >= v4.12 *)
	xMsg2803.Enable		:=	FALSE;
	xMsg2803.Set		:=	FALSE;
	xMsg2803.Reset		:=	TRUE;
	xMsg2803();
	bMsg2803			:=	xMsg2803.Q;
	
	(* B2936 Power reduction by pressure gas train min  *)
	xMsg2936.Enable		:=	TRUE;
	xMsg2936.Set		:=	xPRed[_PrGR].Q;
	xMsg2936.Reset		:=	TRUE;
	xMsg2936();
	bMsg2936			:=	xMsg2936.Q;
		
	(* B3229 P reduction by CH4 content  (diagn.msg RPS) *)
	xMsg3229.Enable		:=	TRUE;
	xMsg3229.Set		:=	xPRed[_CH4].Q;
	xMsg3229.Reset		:=	TRUE;
	xMsg3229();
	bMsg3229			:=	xMsg3229.Q;
	
	(* B3230 P reduction by gas pressure (diagn.msg RPS) *)
	xMsg3230.Enable		:=	TRUE;
	xMsg3230.Set		:=	xPRed[_GasPr].Q;
	xMsg3230.Reset		:=	TRUE;
	xMsg3230();
	bMsg3230			:=	xMsg3230.Q;
	
	(* B3231 P reduction by suction pressure (diagn.msg RPS) *)
	xMsg3231.Enable		:=	TRUE;
	xMsg3231.Set		:=	xPRed[_Suct].Q;
	xMsg3231.Reset		:=	TRUE;
	xMsg3231();
	bMsg3231			:=	xMsg3231.Q;
	
	(* op_msg *)
	
	(* B1225 service seletion switch off *)
	xMsg1225.Enable		:=	TRUE;
	xMsg1225.Set		:=	(OUT_OP.iIdx_OMSS = 0);
	xMsg1225.Reset		:=	TRUE;
	xMsg1225();
	bMsg1225			:=	xMsg1225.Q;
	
	(* B1226 service seletion switch manual *)
	xMsg1226.Enable		:=	TRUE;
	xMsg1226.Set		:=	(OUT_OP.iIdx_OMSS = 1);
	xMsg1226.Reset		:=	TRUE;
	xMsg1226();
	bMsg1226			:=	xMsg1226.Q;
	
	(*B1227 service seletion switch automatic *)
	xMsg1227.Enable		:=	TRUE;
	xMsg1227.Set		:=	(OUT_OP.iIdx_OMSS = 2);
	xMsg1227.Reset		:=	TRUE;
	xMsg1227();
	bMsg1227			:=	xMsg1227.Q;
	
	(* B1228 service seletion switch test *)
	xMsg1228.Enable		:=	TRUE;
	xMsg1228.Set		:=	(OUT_OP.iIdx_OMSS = 3);
	xMsg1228.Reset		:=	TRUE;
	xMsg1228();
	bMsg1228			:=	xMsg1228.Q;
	
	(* B1229 engine ready for automatic on  *)
	xMsg1229.Enable		:=	TRUE;
	xMsg1229.Set		:=	OUT_OP.bEng_Rdy_Aut;
	xMsg1229.Reset		:=	TRUE;
	xMsg1229();
	bMsg1229			:=	xMsg1229.Q;
	
	(* B1230 engine ready for automatic off *)
	xMsg1230.Enable		:=	TRUE;
	xMsg1230.Set		:=	NOT	OUT_OP.bEng_Rdy_Aut;
	xMsg1230.Reset		:=	TRUE;
	xMsg1230();
	bMsg1230			:=	xMsg1230.Q;
	
	(* B1231 engine demand on  *)
	xMsg1231.Enable		:=	TRUE;
	xMsg1231.Set		:=	OUT_OP.bEng_Dem;
	xMsg1231.Reset		:=	TRUE;
	xMsg1231();
	bMsg1231			:=	xMsg1231.Q;
	
	(* B1232 engine demand off *)
	xMsg1232.Enable		:=	TRUE;
	xMsg1232.Set		:=	NOT OUT_OP.bEng_Dem;
	xMsg1232.Reset		:=	TRUE;
	xMsg1232();
	bMsg1232			:=	xMsg1232.Q;
	
	(* B1233 engine operation on  *)
	xMsg1233.Enable		:=	TRUE;
	xMsg1233.Set		:=	OUT_OP.tEng_Run.Do;
	xMsg1233.Reset		:=	TRUE;
	xMsg1233();
	bMsg1233			:=	xMsg1233.Q;
	
	(* B1234 engine operation off *)
	xMsg1234.Enable		:=	TRUE;
	xMsg1234.Set		:=	NOT OUT_OP.tEng_Run.Do;
	xMsg1234.Reset		:=	TRUE;
	xMsg1234();
	bMsg1234			:=	xMsg1234.Q;
	
	(* B1237 demand for island operation on  *)
	xMsg1237.Enable		:=	TRUE;
	xMsg1237.Set		:=	OUT_OP.bEng_Dem_EPS AND FALSE;
	xMsg1237.Reset		:=	TRUE;
	xMsg1237();
	bMsg1237			:=	xMsg1237.Q;
	
	(* B1238 demand for island operation off *)
	xMsg1238.Enable		:=	TRUE;
	xMsg1238.Set		:=	NOT OUT_OP.bEng_Dem_EPS AND FALSE;
	xMsg1238.Reset		:=	TRUE;
	xMsg1238();
	bMsg1238			:=	xMsg1238.Q;
	
	(* B1241 selection gas type 1  *)
	xMsg1241.Enable		:=	TRUE;
	xMsg1241.Set		:=	OUT_OP.bGasTyp1_Act AND (IN_OP.iIdx_Gtyp_Dem = 1);
	xMsg1241.Reset		:=	TRUE;
	xMsg1241();
	bMsg1241			:=	xMsg1241.Q;
	
	(* B1242 selection gas type 2  *)
	xMsg1242.Enable		:=	TRUE;
	xMsg1242.Set		:=	OUT_OP.bGasTyp2_Act;
	xMsg1242.Reset		:=	TRUE;
	xMsg1242();
	bMsg1242			:=	xMsg1242.Q;
	
	(*  B1243 selection gas type 3  *)
	xMsg1243.Enable		:=	TRUE;
	xMsg1243.Set		:=	OUT_OP.bGasTyp3_Act;
	xMsg1243.Reset		:=	TRUE;
	xMsg1243();
	bMsg1243			:=	xMsg1243.Q;
	
	(* B1244 selection gas type 4  *)
	xMsg1244.Enable		:=	TRUE;
	xMsg1244.Set		:=	OUT_OP.bGasTyp4_Act;
	xMsg1244.Reset		:=	TRUE;
	xMsg1244();
	bMsg1244			:=	xMsg1244.Q;

	(* B1245 selection ign.point 1 *)
	xMsg1245.Enable		:=	TRUE;
	xMsg1245.Set		:=	OUT_OP.bGasTyp1_Act AND (IN_OP.iIdx_Gtyp_Dem = 1);
	xMsg1245.Reset		:=	TRUE;
	xMsg1245();
	bMsg1245			:=	xMsg1245.Q;
	
	(* B1246 selection ign.point 2 *)
	xMsg1246.Enable		:=	TRUE;
	xMsg1246.Set		:=	OUT_OP.bGasTyp2_Act;
	xMsg1246.Reset		:=	TRUE;
	xMsg1246();
	bMsg1246			:=	xMsg1246.Q;
	
	(* B1247 selection ign.point 3 *)
	xMsg1247.Enable		:=	TRUE;
	xMsg1247.Set		:=	OUT_OP.bGasTyp3_Act;
	xMsg1247.Reset		:=	TRUE;
	xMsg1247();
	bMsg1247			:=	xMsg1247.Q;
	
	(* B1248 selection ign.point 4 *)
	xMsg1248.Enable		:=	TRUE;
	xMsg1248.Set		:=	OUT_OP.bGasTyp4_Act;
	xMsg1248.Reset		:=	TRUE;
	xMsg1248();
	bMsg1248			:=	xMsg1248.Q;

	(* B2122 *)
	xMsg2122.Enable		:=	TRUE;//NOT(Para.bP_SetCorr_FreqDroop AND IN_OP.iSource_F_N_OffsSet = 1) AND NOT(Para.bP_SetCorr_extNoffset AND IN_OP.iSource_F_N_OffsSet = 2);
	xMsg2122.Set		:=	xOpMode.NetP;
	xMsg2122.Reset		:=	TRUE;
	xMsg2122();
	bMsg2122			:=	xMsg2122.Q;
	
	(* B2123 *) 
	xMsg2123.Enable		:=	TRUE;
	xMsg2123.Set		:=	xOpMode.Island;
	xMsg2123.Reset		:=	TRUE;
	xMsg2123();
	bMsg2123			:=	xMsg2123.Q;
	
	(* B2124 *)
	xMsg2124.Enable		:=	TRUE;
	xMsg2124.Set		:=	xOpMode.Idle;
	xMsg2124.Reset		:=	TRUE;
	xMsg2124();
	bMsg2124			:=	xMsg2124.Q;
	
	(* B2875 Power reduction by crank case pressure  *)	
	xMsg2875.Enable		:=	TRUE;
	xMsg2875.Set		:=	xPRed[_CC].Q;	
	xMsg2875.Reset		:=	TRUE;
	xMsg2875();	
	MM2VIS.bMsg2875		:= 	xMsg2875.Q;		
	
	(* B2168 generator air inlet temperature power reduction  *)	
	xMsg2168.Enable		:=	TRUE;
	xMsg2168.Set		:=	xPRed[_GIAT].Q;	
	xMsg2168.Reset		:=	TRUE;
	xMsg2168();	
	MM2VIS.bMsg2168		:= 	xMsg2168.Q;	
	
	(* B2925 Warm Up Operation *)
	xMsg2925.Enable		:=	TRUE;
	xMsg2925.Set		:=	bWarmUpOperation;
	xMsg2925.Reset		:=	TRUE;
	xMsg2925();
	MM2VIS.bMsg2925		:=	xMsg2925.Q;

	(* B2961 Power reduction by Cylinder Peak Pressure Integrator *)
	xMsg2961.Enable		:=	TRUE;
	xMsg2961.Set		:=	xPRed[_CPP].Q;
	xMsg2961.Reset		:=	TRUE;
	xMsg2961();
	MM2VIS.bMsg2961		:=	xMsg2961.Q;

	(* B2982 Power reduction calorific value *)
	xMsg2982.Enable		:=	TRUE;
	xMsg2982.Set		:=	xPRed[_CV].Q;
	xMsg2982.Reset		:=	TRUE;
	xMsg2982();	
	MM2VIS.bMsg2982		:=	xMsg2982.Q;

	(* B2989 Power reduction by Generator Power Factor *)
	xTOF_Msg2989(IN:= xPRed[_GPF].Q, PT := T#60s);

	xMsg2989.Enable		:=	TRUE;
	xMsg2989.Set		:=	xTOF_Msg2989.Q;
	xMsg2989.Reset		:=	TRUE;
	xMsg2989();	
	MM2VIS.bMsg2989		:=	xMsg2989.Q;

	(* B2972 Power Mode on *)
	xMsg2972.Enable		:=	TRUE;
	xMsg2972.Set		:=	bMsg2972;
	xMsg2972.Reset		:=	TRUE;
	xMsg2972();	
	MM2VIS.bMsg2972		:=	xMsg2972.Q;
	
	(* B2973 Power Mode off *)
	xMsg2973.Enable		:=	TRUE;
	xMsg2973.Set		:=	bMsg2973;
	xMsg2973.Reset		:=	TRUE;
	xMsg2973();	
	MM2VIS.bMsg2973		:=	xMsg2973.Q;	
	
	(* B2935 Power reduction by CAN communication failure for half or more SAFI or too many SAFI reboots *)
	xMsg2935.Enable		:=	TRUE;
	xMsg2935.Set		:=	xPRed[_SAErr].Q;
	xMsg2935.Reset		:=	TRUE;
	xMsg2935();	
	MM2VIS.bMsg2935		:=	xMsg2935.Q;

	MM2VIS.bMsg2162	:=	xPRed[_Trafo].Q;
	MM2VIS.bMsg2167	:=	xPRed[_GenCB].Q;
	
	MM2VIS.bMsg9024	:=	bIsland_Speed; 	(* B9024 - Isolated operation - Speed / Isochronous Mode *)
	MM2VIS.bMsg9025	:=	bIsland_Droop; 	(* B9025 - Isolated operation - Droop Mode *)
	MM2VIS.bMsg9026	:=	bIsland_LSL; 	(* B9026 - Isolated operation - Load sharing line *)

	(* B1283 B1284 B1285 B1286 B1287 Loadstep X reached with 1% hysterese - TOF 60s *)
	MM2VIS.bMsg1283	:=	TOF_LimitSon_Gh[0].Q AND Para.bP_GhStep_Ena;
	MM2VIS.bMsg1284	:=	TOF_LimitSon_Gh[1].Q AND Para.bP_GhStep_Ena;
	MM2VIS.bMsg1285	:=	TOF_LimitSon_Gh[2].Q AND Para.bP_GhStep_Ena;
	MM2VIS.bMsg1286	:=	TOF_LimitSon_Gh[3].Q AND Para.bP_GhStep_Ena;
	MM2VIS.bMsg1287	:=	TOF_LimitSon_Gh[4].Q AND Para.bP_GhStep_Ena;
	
	(* Request mode switch OFF, ON, REMOTE operating messages *)
	MM2VIS.bMsg2983 := OUT_OP.iIdx_RSS = 0;		(* Request mode switch OFF *)
	MM2VIS.bMsg2984 := OUT_OP.iIdx_RSS = 1;		(* Request mode switch ON *)
	MM2VIS.bMsg2985 := OUT_OP.iIdx_RSS = 2;		(* Request mode switch REMOTE *)
	
	(* B9051 Droop Mode for Power Controller *)
	xMsg9051.Enable		:=	TRUE;
	xMsg9051.Set		:=	bMsg9051;//xOpMode.NetP AND Para.bP_SetCorr_FreqDroop AND IN_OP.iSource_F_N_OffsSet = 1;
	xMsg9051.Reset		:=	TRUE;
	xMsg9051();	
	MM2VIS.bMsg9051		:=	xMsg9051.Q;	
	
	(* B9052 external speed reference offset Mode for Power Controller *)
	xMsg9052.Enable		:=	TRUE;
	xMsg9052.Set		:=	bMsg9052;//xOpMode.NetP AND Para.bP_SetCorr_extNoffset AND IN_OP.iSource_F_N_OffsSet = 2;
	xMsg9052.Reset		:=	TRUE;
	xMsg9052();	
	MM2VIS.bMsg9052		:=	xMsg9052.Q;
	
	(* B9061 Activation Speed Setpoint Reduction due to overload of engine  *)
	xMsg9061.Enable		:=	TRUE;
	xMsg9061.Set		:=	Para.bN_SpdSetRed_Overload;
	xMsg9061.Reset		:=	TRUE;
	xMsg9061();	
	MM2VIS.bMsg9061		:=	xMsg9061.Q;	
	
	(* B9062 Deactivation Speed Setpoint Reduction due to overload of engine *)
	xMsg9062.Enable		:=	TRUE;
	xMsg9062.Set		:=	NOT Para.bN_SpdSetRed_Overload;
	xMsg9062.Reset		:=	TRUE;
	xMsg9062();	
	MM2VIS.bMsg9062		:=	xMsg9062.Q;
		
	(* B9063 Power setpoint input external (myPlant) *)
	xMsg9063.Enable		:=	TRUE;
	xMsg9063.Set		:=	(OUT_OP.iIdx_Pset_Type = 18);
	xMsg9063.Reset		:=	TRUE;
	xMsg9063();	
	MM2VIS.bMsg9063		:=	xMsg9063.Q;
		
	(* B9064 Request module on (myPlant) *)
	xMsg9064.Enable		:=	TRUE;
	xMsg9064.Set		:=	MM2VIS.bReq_Dem[7] AND OUT_OP.bEng_Dem;
	xMsg9064.Reset		:=	TRUE;
	xMsg9064();	
	MM2VIS.bMsg9064		:=	xMsg9064.Q;

	(* B9072 Power reduction by H2 content *)
	xMsg9072.Enable		:=	TRUE;
	xMsg9072.Set		:=	xPRed[_H2].Q;
	xMsg9072.Reset		:=	TRUE;
	xMsg9072();
	MM2VIS.bMsg9072		:=	xMsg9072.Q;

	(* B9075 power reduction by charge temp. after HP TC *)
	xMsg9075.Enable		:=	TRUE;
	xMsg9075.Set		:=	xPRed[_T2HP].Q;
	xMsg9075.Reset		:=	TRUE;
	xMsg9075();
	MM2VIS.bMsg9075		:=	xMsg9075.Q;

	(* B9076 power reduction by charge temp. after LP TC *)
	xMsg9076.Enable		:=	TRUE;
	xMsg9076.Set		:=	xPRed[_T2LP].Q;
	xMsg9076.Reset		:=	TRUE;
	xMsg9076();
	MM2VIS.bMsg9076		:=	xMsg9076.Q;

		
	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1   := OUT_OP.tOP2AB.bGnlTrip1   OR IN_OP.tAB2OP.bGnlTrip1;
	bGnlTrip2   := OUT_OP.tOP2AB.bGnlTrip2   OR IN_OP.tAB2OP.bGnlTrip2;
	bGnlTrip3   := OUT_OP.tOP2AB.bGnlTrip3   OR IN_OP.tAB2OP.bGnlTrip3;
	bGnlWarning := OUT_OP.tOP2AB.bGnlWarning OR IN_OP.tAB2OP.bGnlWarning;

	bGnlTrip	:=	bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
(*******************************************************************************)
END_PROGRAM
