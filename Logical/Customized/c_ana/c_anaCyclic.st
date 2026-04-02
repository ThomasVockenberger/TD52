(*******************************************************************************
CUSTOMIZED: c_ana 		hardcoded customized analog inputs

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V3.90.0	??-??-2012  pankayrodney  	converted from LD	
...
V4.01.0	13.11.2014 	zengerer		ADD AnalogIn Para.rCustAnaIn_LimLoLo[] and _HiHi[] and Alarm debug links
V4.02.0	24.06.2015 	zengerer		Cleanup, prototype entry[x] for documentation comments
V4.04.0 20-06-2016	Weitzer,		add CustAnaOut[17..50]
									add reserve controller output [41 .. 45]
V4.07.0 21.01.2019	zengerer		add some example lines in init to disable Reserve ANALOG IN Warning Signal Errors – NUMBER W1177 -
V4.07.1 09.05.2019	zengerer		add more bBlock[] example lines in init to disable Reserve ANALOG IN Warning Signal Errors W1336 - W1480
V4.11.1 31.01.2022	zengerer		new extended array ranges ONLY FOR USE WITH HMI Extension Package import!
V4.12.0 22.12.2022	zengerer		Outdated declarations removed: ParaFactoryDefault.bCustAnaIn_Set4mA[x], tUniAnaConf[x]
V4.13.0 21.09.2023	zengerer		Prepared spare analog output signal for VIS display (with unchanged scaling), constant for array declaration +check AO arrays 
		
Instructions for use:
--------------------
	

AVOID HARDCODED Para.xxx VALUES!
You MAYBE want to enter SOME factory default values in the INIT section, but ONLY TO THE Para_FactoryDefault.xxx STRUCTURE!
._FactoryDefault values get read out only once at first controller startup, until the par_XX.dat files are automatically generated.
By this way the parameter values in Para.xxx would stay acessible according to XT4 parameter management process.


Outstandings:
------------


*******************************************************************************)

PROGRAM _CYCLIC

	(************************************************************)
	(*                                                          *)
	(*                   ANALOG INPUT SECTION                   *)
	(*                                                          *)
	(************************************************************)

//	(*Reserve analog input x *)									(* (CONFIGURATION EXAMPLE) *)
//	(*Reserveanalogwert x    *)									(* (KONFIGURATIONSBEISPIEL)*)
//	(*************************)
//	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[x].Ai;		(*edit according to project needs*) 														(*eigene Variable für Kundenanpassung hier anbinden*)
//	OUT_CU.rCustAnaIn[x] ;										(*Use this value for plant specific extensions in other metamodules (needs .vvm edit)*)		(*OUT- Modulschnittstelle zur möglichen Verwendung in anderer Module (.vvm editieren)*)
//	
//	(*scaling parameter watch*)									(*scaling parameter are used in HAL only IF NO EPLAN SCALING DATA IS PROVIDED!	*)
//	Para.rCustAnaIn_ScalMin[x]	; 	MM2VIS.bMsg1177;			(* statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.rCustAnaIn_ScalMax[x]	;								(* statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//
//	(*warning and alarm limit watch*)
//	Para.rCustAnaIn_LimLoLo[x]	;	MM2VIS.bMsg8966;			(* Alarm HiHi and LoLo, statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.rCustAnaIn_LimLo[x]	;	MM2VIS.bMsg1301;			(* Warning, statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.rCustAnaIn_LimHi[x]	; 	MM2VIS.bMsg1302;			(* Warning, statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.rCustAnaIn_LimHiHi[x]	; 								(* 						statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.rCustAnaIn_Hy[x]	; 									(* 						statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.iCustAnaIn_MinMaxActive[x];							(* see task header for settings in Para File or in INIT Para_FactoryDefault.iCustAnaIn_MinMaxActive; statement here is for watch info only. *)
//  --> see also Documents - 'CustomizedSpareRegulars' for hints on repeatedly used customisations

	(*Reserve analog input 1 *)
	(*Reserveanalogwert 1    *)
	(*************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[1].Ai;		(*edit according to project needs*)
	OUT_CU.rCustAnaIn[1] ;	
	
	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[1]	; 	MM2VIS.bMsg1177;
	Para.rCustAnaIn_ScalMax[1]	;				
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimHiHi[1]	; 	MM2VIS.bMsg8966;
	Para.rCustAnaIn_LimLo[1]	;	MM2VIS.bMsg1301; 
	Para.rCustAnaIn_LimHi[1]	; 	MM2VIS.bMsg1302;
	Para.rCustAnaIn_LimLoLo[1]	;	MM2VIS.bMsg8966;
	Para.rCustAnaIn_Hy[1]	; 	
	Para.iCustAnaIn_MinMaxActive[1];

		

	(*Reserve analog input 2 *)
	(*Reserveanalogwert 2    *)
	(*************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[2].Ai;
	OUT_CU.rCustAnaIn[2] ;	

	(*scaling parameter watch*)	
	Para.rCustAnaIn_ScalMin[2]	;	MM2VIS.bMsg1178;
	Para.rCustAnaIn_ScalMax[2]	;					
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimHiHi[2]	; 	MM2VIS.bMsg8967;
	Para.rCustAnaIn_LimLo[2]	;	MM2VIS.bMsg1304;
	Para.rCustAnaIn_LimHi[2]	; 	MM2VIS.bMsg1305;
	Para.rCustAnaIn_LimLoLo[2]	;	MM2VIS.bMsg8967;
	Para.rCustAnaIn_Hy[2]	; 	
	Para.iCustAnaIn_MinMaxActive[2];
		

	(*Reserve analog input 3 *)
	(*Reserveanalogwert 3    *)
	(*************************)
	rReplaceMeWithLocaleVarName := IN_CU.tCustAnaIn[3].Ai;
	OUT_CU.rCustAnaIn[3] ;		
	
	Para.rCustAnaIn_ScalMin[3]	;	MM2VIS.bMsg1179; 
	Para.rCustAnaIn_ScalMax[3]	;					
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[3]	;	MM2VIS.bMsg1307;
	Para.rCustAnaIn_LimHi[3]	; 	MM2VIS.bMsg1308;
	Para.rCustAnaIn_LimLoLo[3]	;	MM2VIS.bMsg8968;
	Para.rCustAnaIn_LimHiHi[3]	; 	
	Para.rCustAnaIn_Hy[3]	; 	
	Para.iCustAnaIn_MinMaxActive[3];
		

	(*Reserve analog input 4 *)
	(*Reserveanalogwert 4    *)
	(*************************)
	rReplaceMeWithLocaleVarName := IN_CU.tCustAnaIn[4].Ai;
	OUT_CU.rCustAnaIn[4] ;		

	(*scaling parameter watch*)	
	Para.rCustAnaIn_ScalMin[4]	;	 MM2VIS.bMsg1180;
	Para.rCustAnaIn_ScalMax[4]	;					
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[4]	;	MM2VIS.bMsg1310;
	Para.rCustAnaIn_LimHi[4]	; 	MM2VIS.bMsg1311;
	Para.rCustAnaIn_LimLoLo[4]	;	MM2VIS.bMsg8969;
	Para.rCustAnaIn_LimHiHi[4]	;
	Para.rCustAnaIn_Hy[4]	; 	
	Para.iCustAnaIn_MinMaxActive[4];


	(*Reserve analog input 5 *)
	(*Reserveanalogwert 5    *)
	(*************************)
	rReplaceMeWithLocaleVarName := IN_CU.tCustAnaIn[5].Ai;
	OUT_CU.rCustAnaIn[5] ;		

	(*scaling parameter watch*)	
	Para.rCustAnaIn_ScalMin[5]	;	 MM2VIS.bMsg1181;
	Para.rCustAnaIn_ScalMax[5]	;					
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[5]	;	MM2VIS.bMsg1313;
	Para.rCustAnaIn_LimHi[5]	; 	MM2VIS.bMsg1314;
	Para.rCustAnaIn_LimLoLo[5]	;	MM2VIS.bMsg8970;
	Para.rCustAnaIn_LimHiHi[5]	;


	(*Reserveanalogwert 6 *)
	(**********************)
	rReplaceMeWithLocaleVarName := IN_CU.tCustAnaIn[6].Ai;
	OUT_CU.rCustAnaIn[6] ;	

	(*scaling parameter watch*)	
	Para.rCustAnaIn_ScalMin[6]	;	 MM2VIS.bMsg1182;
	Para.rCustAnaIn_ScalMax[6]	;	
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[6]	;	MM2VIS.bMsg1316;
	Para.rCustAnaIn_LimHi[6]	; 	MM2VIS.bMsg1317;
	Para.rCustAnaIn_LimLoLo[6]	;	MM2VIS.bMsg8971;
	Para.rCustAnaIn_LimHiHi[6]	;				
		

	(*Reserveanalogwert 7 *)
	(**********************)
	rReplaceMeWithLocaleVarName := IN_CU.tCustAnaIn[7].Ai;
	OUT_CU.rCustAnaIn[7] ;		
	
	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[7]	;	 MM2VIS.bMsg1183;
	Para.rCustAnaIn_ScalMax[7]	;	
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[7]	;	MM2VIS.bMsg1319;
	Para.rCustAnaIn_LimHi[7]	; 	MM2VIS.bMsg1320;
	Para.rCustAnaIn_LimLoLo[7]	;	MM2VIS.bMsg8972;
	Para.rCustAnaIn_LimHiHi[7]	;				
		

	(*Reserveanalogwert 8 *)
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[8].Ai;
	OUT_CU.rCustAnaIn[8] ;		

	(*scaling parameter watch*)	
	Para.rCustAnaIn_ScalMin[8]	;	 MM2VIS.bMsg1184;
	Para.rCustAnaIn_ScalMax[8]	;	
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[8]	;	MM2VIS.bMsg1322;
	Para.rCustAnaIn_LimHi[8]	; 	MM2VIS.bMsg1323;
	Para.rCustAnaIn_LimLoLo[8]	;	MM2VIS.bMsg8973;
	Para.rCustAnaIn_LimHiHi[8]	;				
		

	(*Reserveanalogwert 9 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[9].Ai;	
	OUT_CU.rCustAnaIn[9] := 0;	
	MM2VIS.bMsg1327;			

	(*scaling parameter watch*)	
	Para.rCustAnaIn_ScalMin[9]	;	MM2VIS.bMsg1327;	(*!change in numbering pattern!*)
	Para.rCustAnaIn_ScalMax[9]	;	
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[9]	;	MM2VIS.bMsg1325;
	Para.rCustAnaIn_LimHi[9]	; 	MM2VIS.bMsg1326;
	Para.rCustAnaIn_LimLoLo[9]	;	MM2VIS.bMsg8974;
	Para.rCustAnaIn_LimHiHi[9]	; 				

	(*Reserveanalogwert 10 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[10].Ai;	
	OUT_CU.rCustAnaIn[10] := 0;	
	MM2VIS.bMsg1330;				

	(*scaling parameter watch*)	
	Para.rCustAnaIn_ScalMin[10]	;	MM2VIS.bMsg1330;
	Para.rCustAnaIn_ScalMax[10]	;	
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[10]	;	MM2VIS.bMsg1328;
	Para.rCustAnaIn_LimHi[10]	; 	MM2VIS.bMsg1329;
	Para.rCustAnaIn_LimLoLo[10]	;	MM2VIS.bMsg8975;
	Para.rCustAnaIn_LimHiHi[10]	; 	
	Para.rCustAnaIn_Hy[10]	; 	
	Para.iCustAnaIn_MinMaxActive[10];			

	(*Reserveanalogwert 11 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[11].Ai;	
	OUT_CU.rCustAnaIn[11] := 0;	
	MM2VIS.bMsg1333;			

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[11]	;	MM2VIS.bMsg1333;
	Para.rCustAnaIn_ScalMax[11]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[11]	;	MM2VIS.bMsg1331;
	Para.rCustAnaIn_LimHi[11]	; 	MM2VIS.bMsg1332;
	Para.rCustAnaIn_LimLoLo[11]	;	MM2VIS.bMsg8976;
	Para.rCustAnaIn_LimHiHi[11]	; 		


	(*Reserveanalogwert 12 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[12].Ai;	
	OUT_CU.rCustAnaIn[12] := 0;	
	MM2VIS.bMsg1336;			
	(*...*)


	(*Reserveanalogwert 13 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[13].Ai;	
	OUT_CU.rCustAnaIn[13] := 0;	
	MM2VIS.bMsg1339;		
	

	(*Reserveanalogwert 14 *)  
	(**********************)
	rReplaceMeWithLocaleVarName := IN_CU.tCustAnaIn[14].Ai;	
	OUT_CU.rCustAnaIn[14] := 0;	
	MM2VIS.bMsg1342;		
	

	(*Reserveanalogwert 15 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[15].Ai;	
	OUT_CU.rCustAnaIn[15] := 0;	
	MM2VIS.bMsg1345;	
	

	(*Reserveanalogwert 16 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[16].Ai;	
	OUT_CU.rCustAnaIn[16] := 0;	
	MM2VIS.bMsg1348;		


	(*Reserveanalogwert 17 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[17].Ai;	
	OUT_CU.rCustAnaIn[17] := 0;	
	MM2VIS.bMsg1351;		


	(*Reserveanalogwert 18 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[18].Ai;	
	OUT_CU.rCustAnaIn[18] := 0;	
	MM2VIS.bMsg1354;		


	(*Reserveanalogwert 19 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[19].Ai;	
	OUT_CU.rCustAnaIn[19] := 0;	
	MM2VIS.bMsg1357;			


	(*Reserveanalogwert 20 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[20].Ai;	
	OUT_CU.rCustAnaIn[20] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[20]	;	MM2VIS.bMsg1360;
	Para.rCustAnaIn_ScalMax[20]	;	
	(*warning and alarm limit watch*)				
	Para.rCustAnaIn_LimLo[20]	;	MM2VIS.bMsg1358;
	Para.rCustAnaIn_LimHi[20]	; 	MM2VIS.bMsg1359;
	Para.rCustAnaIn_LimLoLo[20]	;	MM2VIS.bMsg8985;
	Para.rCustAnaIn_LimHiHi[20]	; 	
	Para.rCustAnaIn_Hy[20]	; 	
	Para.iCustAnaIn_MinMaxActive[20];


	(*Reserveanalogwert 21 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[21].Ai;	
	OUT_CU.rCustAnaIn[21] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[21]	;	MM2VIS.bMsg1363;
	Para.rCustAnaIn_ScalMax[21]	;	
	(*warning and alarm limit watch*)				
	Para.rCustAnaIn_LimLo[21]	;	MM2VIS.bMsg1361;
	Para.rCustAnaIn_LimHi[21]	; 	MM2VIS.bMsg1362;
	Para.rCustAnaIn_LimLoLo[21]	;	MM2VIS.bMsg8986;
	Para.rCustAnaIn_LimHiHi[21]	; 
	Para.rCustAnaIn_Hy[21]	; 	
	Para.iCustAnaIn_MinMaxActive[21];
	

	(*Reserveanalogwert 22 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[22].Ai;	
	OUT_CU.rCustAnaIn[22] := 0;	
	MM2VIS.bMsg1366;			


	(*Reserveanalogwert 23 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[23].Ai;	
	OUT_CU.rCustAnaIn[23] := 0;	
	MM2VIS.bMsg1369;			


	(*Reserveanalogwert 24 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[24].Ai;	
	OUT_CU.rCustAnaIn[24] := 0;	
	

	(*Reserveanalogwert 25 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[25].Ai;	
	OUT_CU.rCustAnaIn[25] := 0;	


	(*Reserveanalogwert 26 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[26].Ai;	
	OUT_CU.rCustAnaIn[26] := 0;	
	

	(*Reserveanalogwert 27 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[27].Ai;	
	OUT_CU.rCustAnaIn[27] := 0;	


	(*Reserveanalogwert 28 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[28].Ai;	
	OUT_CU.rCustAnaIn[28] := 0;	
	

	(*Reserveanalogwert 29 *)  
	(**********************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[29].Ai;	
	OUT_CU.rCustAnaIn[29] := 0;	
	

	(*Reserve analog value  30 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[30].Ai;	
	OUT_CU.rCustAnaIn[30] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[30]	;	MM2VIS.bMsg1390;	 	(* ANALOG IN 30 Warning Signal Error. statement here is for watch info only. *)
	Para.rCustAnaIn_ScalMax[30]	;
	(*warning and alarm limit watch*)					
	Para.rCustAnaIn_LimLo[30]	;	MM2VIS.bMsg1388;
	Para.rCustAnaIn_LimHi[30]	; 	MM2VIS.bMsg1389;
	Para.rCustAnaIn_LimLoLo[30]	;	MM2VIS.bMsg8995;
	Para.rCustAnaIn_LimHiHi[30]	; 	
	Para.rCustAnaIn_Hy[30]	; 	
	Para.iCustAnaIn_MinMaxActive[30];


	(*Reserve analog value  31 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[31].Ai;	
	OUT_CU.rCustAnaIn[31] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[31]	;	MM2VIS.bMsg1393;		(* ANALOG IN 31 Warning Signal Error. statement here is for watch info only. *)
	Para.rCustAnaIn_ScalMax[31]	;
	(*warning limit watch*)
	Para.rCustAnaIn_LimLo[31]	;	MM2VIS.bMsg1391;  		(* ANALOG IN 31 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[31]	; 	MM2VIS.bMsg1392;  		(* ANALOG IN 31 Warning Limit HIGH, statement here is for watch info only.   *)
(*!*)Para.rCustAnaIn_LimLoLo[31];	MM2VIS.bMsg8998;		(*!	Collective Alarm for Analog inputs 31-60:  limit alarms LoLo ! *)	(* Statement here for watch info only *)
(*!*)Para.rCustAnaIn_LimHiHi[31];	MM2VIS.bMsg8999;		(*!	Collective Alarm for Analog inputs 31-60:  limit alarms HiHi  Statement here for watch info only *)
	Para.rCustAnaIn_Hy[31]	; 	
	Para.iCustAnaIn_MinMaxActive[31];


	(*Reserve analog value  32 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[32].Ai;	
	OUT_CU.rCustAnaIn[32] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[32]	;	MM2VIS.bMsg1396;		(* ANALOG IN 32 Warning Signal Error. statement here is for watch info only. *)
	Para.rCustAnaIn_ScalMax[32]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[32]	;	MM2VIS.bMsg1394;  		(* ANALOG IN 32 Warning Limit LOW,  statement here is for watch info only.   *) 
	Para.rCustAnaIn_LimHi[32]	; 	MM2VIS.bMsg1395;  		(* ANALOG IN 32 Warning Limit HIGH, statement here is for watch info only.   *) 
	Para.rCustAnaIn_Hy[32]	; 	
	Para.iCustAnaIn_MinMaxActive[32];


	(*Reserve analog value  33 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[33].Ai;	
	OUT_CU.rCustAnaIn[33] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[33]	;	MM2VIS.bMsg1399;	
	Para.rCustAnaIn_ScalMax[33]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[33]	;	MM2VIS.bMsg1397; 
	Para.rCustAnaIn_LimHi[33]	; 	MM2VIS.bMsg1398; 
	Para.rCustAnaIn_Hy[33]	; 	
	Para.iCustAnaIn_MinMaxActive[33];
	

	(*Reserve analog value  34 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[34].Ai;	
	OUT_CU.rCustAnaIn[34] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[34]	;	MM2VIS.bMsg1402;	
	Para.rCustAnaIn_ScalMax[34]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[34]	;	MM2VIS.bMsg1400; 
	Para.rCustAnaIn_LimHi[34]	; 	MM2VIS.bMsg1401; 
	Para.rCustAnaIn_Hy[34]	; 	
	Para.iCustAnaIn_MinMaxActive[34];
	

	(*Reserve analog value  35 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[35].Ai;	
	OUT_CU.rCustAnaIn[35] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[35]	;	MM2VIS.bMsg1405;	
	Para.rCustAnaIn_ScalMax[35]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[35]	;	MM2VIS.bMsg1403; 
	Para.rCustAnaIn_LimHi[35]	; 	MM2VIS.bMsg1404; 
	Para.rCustAnaIn_Hy[35]	; 	
	Para.iCustAnaIn_MinMaxActive[35];


	(*Reserve analog value  36 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[36].Ai;	
	OUT_CU.rCustAnaIn[36] := 0;	
	

	(*Reserve analog value  37 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[37].Ai;	
	OUT_CU.rCustAnaIn[37] := 0;	


	(*Reserve analog value  38 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[38].Ai;	
	OUT_CU.rCustAnaIn[38] := 0;	
	

	(*Reserve analog value  39 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[39].Ai;	
	OUT_CU.rCustAnaIn[39] := 0;	
	
	
	(*Reserve analog value  40 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[40].Ai;	
	OUT_CU.rCustAnaIn[40] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[40]	;	MM2VIS.bMsg1420;		(* ANALOG IN 40 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[40]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[40]	;	MM2VIS.bMsg1418; 		(* ANALOG IN 40 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[40]	; 	MM2VIS.bMsg1419; 		(* ANALOG IN 40 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[40]	; 	
	Para.iCustAnaIn_MinMaxActive[40];



	(*Reserve analog value  41 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[41].Ai;	
	OUT_CU.rCustAnaIn[41] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[41]	;	MM2VIS.bMsg1423;		(* ANALOG IN 41 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[41]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[41]	;	MM2VIS.bMsg1421; 		(* ANALOG IN 41 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[41]	; 	MM2VIS.bMsg1422; 		(* ANALOG IN 41 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[41]	; 	
	Para.iCustAnaIn_MinMaxActive[41];


	(*Reserve analog value  42 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[42].Ai;	
	OUT_CU.rCustAnaIn[42] := 0;	


	(*Reserve analog value  43 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[43].Ai;	
	OUT_CU.rCustAnaIn[43] := 0;	
	

	(*Reserve analog value  44 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[44].Ai;	
	OUT_CU.rCustAnaIn[44] := 0;	
	

	(*Reserve analog value  45 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[45].Ai;	
	OUT_CU.rCustAnaIn[45] := 0;	


	(*Reserve analog value  46 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[46].Ai;	
	OUT_CU.rCustAnaIn[46] := 0;	
	

	(*Reserve analog value  47 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[47].Ai;	
	OUT_CU.rCustAnaIn[47] := 0;	


	(*Reserve analog value  48 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[48].Ai;	
	OUT_CU.rCustAnaIn[48] := 0;	
	

	(*Reserve analog value  49 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[49].Ai;	
	OUT_CU.rCustAnaIn[49] := 0;	


	(*Reserve analog value  50 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[50].Ai;	
	OUT_CU.rCustAnaIn[50] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[50]	;	MM2VIS.bMsg1450;		(* ANALOG IN 50 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[50]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[50]	;	MM2VIS.bMsg1448;			(* ANALOG IN 50 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[50]	; 	MM2VIS.bMsg1449;			(* ANALOG IN 50 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[50]	; 	
	Para.iCustAnaIn_MinMaxActive[50];


	(*Reserve analog value  51 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[51].Ai;	
	OUT_CU.rCustAnaIn[51] := 0;	
	

	(*Reserve analog value  52 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[52].Ai;	
	OUT_CU.rCustAnaIn[52] := 0;	


	(*Reserve analog value  53 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[53].Ai;	
	OUT_CU.rCustAnaIn[53] := 0;	
	

	(*Reserve analog value  54 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[54].Ai;	
	OUT_CU.rCustAnaIn[54] := 0;	
	

	(*Reserve analog value  55 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[55].Ai;	
	OUT_CU.rCustAnaIn[55] := 0;	


	(*Reserve analog value  56 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[56].Ai;	
	OUT_CU.rCustAnaIn[56] := 0;	
	

	(*Reserve analog value  57 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[57].Ai;	
	OUT_CU.rCustAnaIn[57] := 0;	


	(*Reserve analog value  58 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[58].Ai;	
	OUT_CU.rCustAnaIn[58] := 0;	
	

	(*Reserve analog value  59 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[59].Ai;	
	OUT_CU.rCustAnaIn[59] := 0;	


	(*Reserve analog value 60 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[60].Ai;	
	OUT_CU.rCustAnaIn[60] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[60]	;	MM2VIS.bMsg1480;		(* ANALOG IN 60 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[60]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[60]	;MM2VIS.bMsg1478 ;			(* ANALOG IN 60 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[60]	;MM2VIS.bMsg1479 ;			(* ANALOG IN 60 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[60]	; 	
	Para.iCustAnaIn_MinMaxActive[60];	

	(********************************************************************************************************************************************)
	(* Reserve analog input 61 and above are not prepared in HMI default! - FOR USE ONLY WITH `HMI_Extension` Package! *)  	
	(* Analog inputs 61- and above have no alarm messages and HMI display prepared in default and need HMI_Update packets imported for function! *)
	(*********************************************************************************************************************************************)
	(*Reserve analog value  61 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[61].Ai;	
	OUT_CU.rCustAnaIn[61] := 0;	
	

	(*Reserve analog value  62 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[62].Ai;	
	OUT_CU.rCustAnaIn[62] := 0;	


	(*Reserve analog value  63 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[63].Ai;	
	OUT_CU.rCustAnaIn[63] := 0;	
	

	(*Reserve analog value  64 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[64].Ai;	
	OUT_CU.rCustAnaIn[64] := 0;	
	

	(*Reserve analog value  66 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[65].Ai;	
	OUT_CU.rCustAnaIn[65] := 0;	


	(*Reserve analog value  66 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[66].Ai;	
	OUT_CU.rCustAnaIn[66] := 0;	
	

	(*Reserve analog value  67 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[67].Ai;	
	OUT_CU.rCustAnaIn[67] := 0;	


	(*Reserve analog value  68 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[68].Ai;	
	OUT_CU.rCustAnaIn[68] := 0;	
	

	(*Reserve analog value  69 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[69].Ai;	
	OUT_CU.rCustAnaIn[69] := 0;	


	(*Reserve analog value 70 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[70].Ai;	
	OUT_CU.rCustAnaIn[70] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[70]	;	MM2VIS.bMsg3810;		(* ANALOG IN 70 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[70]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[70]	;MM2VIS.bMsg3808 ;			(* ANALOG IN 70 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[70]	;MM2VIS.bMsg3809 ;			(* ANALOG IN 70 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[70]	; 	
	Para.iCustAnaIn_MinMaxActive[70];
	
	
	(*Reserve analog value  71 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[71].Ai;	
	OUT_CU.rCustAnaIn[71] := 0;	
	

	(*Reserve analog value  72 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[72].Ai;	
	OUT_CU.rCustAnaIn[72] := 0;	


	(*Reserve analog value  73 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[73].Ai;	
	OUT_CU.rCustAnaIn[73] := 0;	
	

	(*Reserve analog value  74 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[74].Ai;	
	OUT_CU.rCustAnaIn[74] := 0;	
	

	(*Reserve analog value  75 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[75].Ai;	
	OUT_CU.rCustAnaIn[75] := 0;	


	(*Reserve analog value  76 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[76].Ai;	
	OUT_CU.rCustAnaIn[76] := 0;	
	

	(*Reserve analog value  77 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[77].Ai;	
	OUT_CU.rCustAnaIn[77] := 0;	


	(*Reserve analog value  78 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[78].Ai;	
	OUT_CU.rCustAnaIn[78] := 0;	
	

	(*Reserve analog value  79 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[79].Ai;	
	OUT_CU.rCustAnaIn[79] := 0;	


	(*Reserve analog value 80 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[80].Ai;	
	OUT_CU.rCustAnaIn[80] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[80]	;	MM2VIS.bMsg3840;		(* ANALOG IN 80 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[80]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[80]	;MM2VIS.bMsg3838 ;			(* ANALOG IN 80 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[80]	;MM2VIS.bMsg3839 ;			(* ANALOG IN 80 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[80]	; 	
	Para.iCustAnaIn_MinMaxActive[80];
	
	(*Reserve analog value  81 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[81].Ai;	
	OUT_CU.rCustAnaIn[81] := 0;	
	

	(*Reserve analog value  82 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[82].Ai;	
	OUT_CU.rCustAnaIn[82] := 0;	


	(*Reserve analog value  83 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[83].Ai;	
	OUT_CU.rCustAnaIn[83] := 0;	
	

	(*Reserve analog value  84 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[84].Ai;	
	OUT_CU.rCustAnaIn[84] := 0;	
	

	(*Reserve analog value  85 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[85].Ai;	
	OUT_CU.rCustAnaIn[85] := 0;	


	(*Reserve analog value  86 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[86].Ai;	
	OUT_CU.rCustAnaIn[86] := 0;	
	

	(*Reserve analog value  87 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[87].Ai;	
	OUT_CU.rCustAnaIn[87] := 0;	


	(*Reserve analog value  88 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[88].Ai;	
	OUT_CU.rCustAnaIn[88] := 0;	
	

	(*Reserve analog value  89 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[89].Ai;	
	OUT_CU.rCustAnaIn[89] := 0;	


	(*Reserve analog value 90 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[90].Ai;	
	OUT_CU.rCustAnaIn[90] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[90]	;	MM2VIS.bMsg3870;		(* ANALOG IN 90 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[90]	;
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[90]	;MM2VIS.bMsg3868 ;			(* ANALOG IN 90 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[90]	;MM2VIS.bMsg3869 ;			(* ANALOG IN 90 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[90]	; 	
	Para.iCustAnaIn_MinMaxActive[90];
	
	
	(*Reserve analog value  91 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[91].Ai;	
	OUT_CU.rCustAnaIn[91] := 0;	
	

	(*Reserve analog value  92 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[92].Ai;	
	OUT_CU.rCustAnaIn[92] := 0;	


	(*Reserve analog value  93 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[93].Ai;	
	OUT_CU.rCustAnaIn[93] := 0;	
	

	(*Reserve analog value  94 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[94].Ai;	
	OUT_CU.rCustAnaIn[94] := 0;	
	

	(*Reserve analog value  95 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[95].Ai;	
	OUT_CU.rCustAnaIn[95] := 0;	


	(*Reserve analog value  96 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[96].Ai;	
	OUT_CU.rCustAnaIn[96] := 0;	
	

	(*Reserve analog value  97 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[97].Ai;	
	OUT_CU.rCustAnaIn[97] := 0;	


	(*Reserve analog value  98 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[98].Ai;	
	OUT_CU.rCustAnaIn[98] := 0;	
	

	(*Reserve analog value  99 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[99].Ai;	
	OUT_CU.rCustAnaIn[99] := 0;	


	(*Reserve analog value 100 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[100].Ai;	
	OUT_CU.rCustAnaIn[100] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[100];	MM2VIS.bMsg3900;		(* ANALOG IN 100 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[100];
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[100]	;MM2VIS.bMsg3898 ;			(* ANALOG IN 100 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[100]	;MM2VIS.bMsg3899 ;			(* ANALOG IN 100 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[100]	; 	
	Para.iCustAnaIn_MinMaxActive[100];
	
	
	(*Reserve analog value  101 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[101].Ai;	
	OUT_CU.rCustAnaIn[101] := 0;	
	

	(*Reserve analog value  102 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[102].Ai;	
	OUT_CU.rCustAnaIn[102] := 0;	


	(*Reserve analog value  103 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[103].Ai;	
	OUT_CU.rCustAnaIn[103] := 0;	
	

	(*Reserve analog value  104 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[104].Ai;	
	OUT_CU.rCustAnaIn[104] := 0;	
	

	(*Reserve analog value  105 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[105].Ai;	
	OUT_CU.rCustAnaIn[105] := 0;	


	(*Reserve analog value  106 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[106].Ai;	
	OUT_CU.rCustAnaIn[106] := 0;	
	

	(*Reserve analog value  107 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[107].Ai;	
	OUT_CU.rCustAnaIn[107] := 0;	


	(*Reserve analog value  108 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[108].Ai;	
	OUT_CU.rCustAnaIn[108] := 0;	
	

	(*Reserve analog value  109 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[109].Ai;	
	OUT_CU.rCustAnaIn[109] := 0;	


	(*Reserve analog value 110 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[110].Ai;	
	OUT_CU.rCustAnaIn[110] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[110];	MM2VIS.bMsg3930;		(* ANALOG IN 110 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[110];
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[110]	;MM2VIS.bMsg3928 ;			(* ANALOG IN 110 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[110]	;MM2VIS.bMsg3929 ;			(* ANALOG IN 110 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[110]	; 	
	Para.iCustAnaIn_MinMaxActive[110];
	
	
	(*Reserve analog value  111 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[111].Ai;	
	OUT_CU.rCustAnaIn[111] := 0;	
	

	(*Reserve analog value  112 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[112].Ai;	
	OUT_CU.rCustAnaIn[112] := 0;	


	(*Reserve analog value  113 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[113].Ai;	
	OUT_CU.rCustAnaIn[113] := 0;	
	

	(*Reserve analog value  114 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[114].Ai;	
	OUT_CU.rCustAnaIn[114] := 0;	
	

	(*Reserve analog value  115 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[115].Ai;	
	OUT_CU.rCustAnaIn[115] := 0;	


	(*Reserve analog value  116 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[116].Ai;	
	OUT_CU.rCustAnaIn[116] := 0;	
	

	(*Reserve analog value  117 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[117].Ai;	
	OUT_CU.rCustAnaIn[117] := 0;	


	(*Reserve analog value  118 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[118].Ai;	
	OUT_CU.rCustAnaIn[118] := 0;	
	

	(*Reserve analog value  119 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[119].Ai;	
	OUT_CU.rCustAnaIn[119] := 0;	


	(*Reserve analog value 120 *)  
	(**************************)
	rReplaceMeWithLocaleVarName	:= IN_CU.tCustAnaIn[120].Ai;	
	OUT_CU.rCustAnaIn[120] := 0;	

	(*scaling parameter watch*)
	Para.rCustAnaIn_ScalMin[120];	MM2VIS.bMsg3960;		(* ANALOG IN 120 Warning Signal Error. statement here is for watch info only. *)	
	Para.rCustAnaIn_ScalMax[120];
	(*warning and alarm limit watch*)
	Para.rCustAnaIn_LimLo[120];		MM2VIS.bMsg3958 ;			(* ANALOG IN 120 Warning Limit LOW,  statement here is for watch info only.   *)
	Para.rCustAnaIn_LimHi[120];		MM2VIS.bMsg3959 ;			(* ANALOG IN 120 Warning Limit HIGH, statement here is for watch info only.   *)
	Para.rCustAnaIn_Hy[120]; 	
	Para.iCustAnaIn_MinMaxActive[120];
	
	
	(*********************************************************************************************************************************)


	(*********************************************************************************************************************************)

	(********************************************************)
	(*                                                      *)
	(*                 ANALOG OUTPUT SECTION                *)
	(*                                                      *)
	(********************************************************)

//	(***************************)
//	(* Reserve analog output x *)								(* (CONFIGURATION EXAMPLE) *)
//	(* Reserveanalogausgang x  *)								(* (KONFIGURATIONSBEISPIEL)*)
//	(***************************)
//	OUT_CU.tCustAnaOut[x].Ao	:= rConnectYourVariableHere ;	(*eigene Variable für Kundenanpassung hier anbeinden*)	(*edit according to project needs*)
//	
//	(*scaling parameter watch*)									(* scaling parameter are used in HAL only IF NO EPLAN SCALING DATA IS PROVIDED!	*)
//	Para.rCustAnaOut_ScalMin[x]	; 								(*[Customer Unit] 'software side' of scaling;	statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.rCustAnaOut_ScalMax[x]	;								(*[Customer Unit] 'software side' of scaling;	statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.rI_CustAnaOut_ScalMin[x] ; 	(* := 4; *)				(*[mA] 'hardware side' of scaling;				statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
//	Para.rI_CustAnaOut_ScalMin[x] ;		(* := 20; *)			(*[mA] 'hardware side' of scaling;				statement here is for watch info only. AVOID HARDCODED PARA VALUES *)
																

	(* reserve analog output 1 *)
	OUT_CU.tCustAnaOut[1].Ao	:= rConnectYourVariableHere ;	(* change customized *)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[1]	;
	Para.rCustAnaOut_ScalMax[1]	;	
	Para.rI_CustAnaOut_ScalMin[1] ;
	Para.rI_CustAnaOut_ScalMax[1] ;
	MM2VIS.rCustAnaOut[1] ; 								(*Example call of prepared spare analog output for VIS service display; OLD: MM2VIS.rCustAnaOut_Norm[1]  *)


	(* reserve analog output 2 *)
	OUT_CU.tCustAnaOut[2].Ao	:= rConnectYourVariableHere ;
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[2]	;	
	Para.rCustAnaOut_ScalMax[2]	;
	Para.rI_CustAnaOut_ScalMin[2] ; 
	Para.rI_CustAnaOut_ScalMax[2] ;
 

	(* reserve analog output 3 *)
	OUT_CU.tCustAnaOut[3].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[3]	;	
	Para.rCustAnaOut_ScalMax[3]	;
	Para.rI_CustAnaOut_ScalMin[3] ; 
	Para.rI_CustAnaOut_ScalMax[3] ;
 

	(* reserve analog output 4 *)
	OUT_CU.tCustAnaOut[4].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[4]	;	
	Para.rCustAnaOut_ScalMax[4]	;
	Para.rI_CustAnaOut_ScalMin[4] ; 
	Para.rI_CustAnaOut_ScalMax[4] ;

	(* reserve analog output 5 *)
//	OUT_CU.tCustAnaOut[5].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[5]	;	
	Para.rCustAnaOut_ScalMax[5]	;
	Para.rI_CustAnaOut_ScalMin[5] ; 
	Para.rI_CustAnaOut_ScalMax[5] ;

	(* reserve analog output 6 *)
	OUT_CU.tCustAnaOut[6].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[6]	;	
	Para.rCustAnaOut_ScalMax[6]	;
	Para.rI_CustAnaOut_ScalMin[6] ; 
	Para.rI_CustAnaOut_ScalMax[6] ;

	(* reserve analog output 7 *)
//	OUT_CU.tCustAnaOut[7].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[7]	;	
	Para.rCustAnaOut_ScalMax[7]	;
	Para.rI_CustAnaOut_ScalMin[7] ; 
	Para.rI_CustAnaOut_ScalMax[7] ;

	(* reserve analog output 8 *)
//	OUT_CU.tCustAnaOut[8].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[8]	;	
	Para.rCustAnaOut_ScalMax[8]	;
	Para.rI_CustAnaOut_ScalMin[8] ; 
	Para.rI_CustAnaOut_ScalMax[8] ;

	(* reserve analog output 9 *)
//	OUT_CU.tCustAnaOut[9].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[9]	;	
	Para.rCustAnaOut_ScalMax[9]	;
	Para.rI_CustAnaOut_ScalMin[9] ; 
	Para.rI_CustAnaOut_ScalMax[9] ;

	(* reserve analog output 10 *)
//	OUT_CU.tCustAnaOut[10].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[10] ;	
	Para.rCustAnaOut_ScalMax[10] ;
	Para.rI_CustAnaOut_ScalMin[10] ; 
	Para.rI_CustAnaOut_ScalMax[10] ;

	(* reserve analog output 11 *)
//	OUT_CU.tCustAnaOut[11].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[11] ;	
	Para.rCustAnaOut_ScalMax[11] ;
	Para.rI_CustAnaOut_ScalMin[11] ; 
	Para.rI_CustAnaOut_ScalMax[11] ;

	(* reserve analog output 12 *)
//	OUT_CU.tCustAnaOut[12].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[12] ;	
	Para.rCustAnaOut_ScalMax[12] ;
	Para.rI_CustAnaOut_ScalMin[12] ; 
	Para.rI_CustAnaOut_ScalMax[12] ;

	(* reserve analog output 13 *)
//	OUT_CU.tCustAnaOut[13].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[13] ;	
	Para.rCustAnaOut_ScalMax[13] ;
	Para.rI_CustAnaOut_ScalMin[13] ; 
	Para.rI_CustAnaOut_ScalMax[13] ;

	(* reserve analog output 14 *)
//	OUT_CU.tCustAnaOut[14].Ao	:= rConnectYourVariableHere ;	 	(*VSofti*)
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[14] ;	
	Para.rCustAnaOut_ScalMax[14] ;
	Para.rI_CustAnaOut_ScalMin[14] ; 
	Para.rI_CustAnaOut_ScalMax[14] ;

	(* reserve analog output 15 *)
	OUT_CU.tCustAnaOut[15].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[15] ;	
	Para.rCustAnaOut_ScalMax[15] ;
	Para.rI_CustAnaOut_ScalMin[15] ; 
	Para.rI_CustAnaOut_ScalMax[15] ;

	(* reserve analog output 16 *)
	OUT_CU.tCustAnaOut[16].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[16]	;	
	Para.rCustAnaOut_ScalMax[16]	;
	Para.rI_CustAnaOut_ScalMin[16] ; 
	Para.rI_CustAnaOut_ScalMax[16] ;
	
	(********************************************************************************************************************************************)
	(* Reserve analog output 17 and above are not prepared in HMI default! - FOR USE ONLY WITH `HMI_Extension` Package! *)  
	(* Analog outputs 17- and above have no parameter values prepared in HMI display default and need HMI_Update packets imported for function! *)
	(*********************************************************************************************************************************************)

	(* reserve analog output 17 *)
	OUT_CU.tCustAnaOut[17].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[17]	;	
	Para.rCustAnaOut_ScalMax[17]	;
	Para.rI_CustAnaOut_ScalMin[17] ; 
	Para.rI_CustAnaOut_ScalMax[17] ;
	
	(* reserve analog output 18 *)
	OUT_CU.tCustAnaOut[18].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[18]	;	
	Para.rCustAnaOut_ScalMax[18]	;
	Para.rI_CustAnaOut_ScalMin[18] ; 
	Para.rI_CustAnaOut_ScalMax[18] ;
	
	(* reserve analog output 19 *)
	OUT_CU.tCustAnaOut[19].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[19]	;	
	Para.rCustAnaOut_ScalMax[19]	;
	Para.rI_CustAnaOut_ScalMin[19] ; 
	Para.rI_CustAnaOut_ScalMax[19] ;
	
	(* reserve analog output 20 *)
	OUT_CU.tCustAnaOut[20].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[20]	;	
	Para.rCustAnaOut_ScalMax[20]	;
	Para.rI_CustAnaOut_ScalMin[20] ; 
	Para.rI_CustAnaOut_ScalMax[20] ;
	
	(* reserve analog output 21 *)
	OUT_CU.tCustAnaOut[21].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[21]	;	
	Para.rCustAnaOut_ScalMax[21]	;
	Para.rI_CustAnaOut_ScalMin[21] ; 
	Para.rI_CustAnaOut_ScalMax[21] ;
	
	(* reserve analog output 22 *)
	OUT_CU.tCustAnaOut[22].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[22]	;	
	Para.rCustAnaOut_ScalMax[22]	;
	Para.rI_CustAnaOut_ScalMin[22] ; 
	Para.rI_CustAnaOut_ScalMax[22] ;
	
	(* reserve analog output 23 *)
	OUT_CU.tCustAnaOut[23].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[23]	;	
	Para.rCustAnaOut_ScalMax[23]	;
	Para.rI_CustAnaOut_ScalMin[23] ; 
	Para.rI_CustAnaOut_ScalMax[23] ;
	
	(* reserve analog output 24 *)
	OUT_CU.tCustAnaOut[24].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[24]	;	
	Para.rCustAnaOut_ScalMax[24]	;
	Para.rI_CustAnaOut_ScalMin[24] ; 
	Para.rI_CustAnaOut_ScalMax[24] ;
	
	(* reserve analog output 25 *)
	OUT_CU.tCustAnaOut[25].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[25]	;	
	Para.rCustAnaOut_ScalMax[25]	;
	Para.rI_CustAnaOut_ScalMin[25] ; 
	Para.rI_CustAnaOut_ScalMax[25] ;
	
	(* reserve analog output 26 *)
	OUT_CU.tCustAnaOut[26].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[26]	;	
	Para.rCustAnaOut_ScalMax[26]	;
	Para.rI_CustAnaOut_ScalMin[26] ; 
	Para.rI_CustAnaOut_ScalMax[26] ;
	
	(* reserve analog output 27 *)
	OUT_CU.tCustAnaOut[27].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[27]	;	
	Para.rCustAnaOut_ScalMax[27]	;
	Para.rI_CustAnaOut_ScalMin[27] ; 
	Para.rI_CustAnaOut_ScalMax[27] ;
	
	(* reserve analog output 28 *)
	OUT_CU.tCustAnaOut[28].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[28]	;	
	Para.rCustAnaOut_ScalMax[28]	;
	Para.rI_CustAnaOut_ScalMin[28] ; 
	Para.rI_CustAnaOut_ScalMax[28] ;
	
	(* reserve analog output 29 *)
	OUT_CU.tCustAnaOut[29].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[29]	;	
	Para.rCustAnaOut_ScalMax[29]	;
	Para.rI_CustAnaOut_ScalMin[29] ; 
	Para.rI_CustAnaOut_ScalMax[29] ;
	
	(* reserve analog output 30 *)
	OUT_CU.tCustAnaOut[30].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[30]	;	
	Para.rCustAnaOut_ScalMax[30]	;
	Para.rI_CustAnaOut_ScalMin[30] ; 
	Para.rI_CustAnaOut_ScalMax[30] ;
	
	(* reserve analog output 31 *)
	OUT_CU.tCustAnaOut[31].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[31]	;	
	Para.rCustAnaOut_ScalMax[31]	;
	Para.rI_CustAnaOut_ScalMin[31] ; 
	Para.rI_CustAnaOut_ScalMax[31] ;
	
	(* reserve analog output 32 *)
	OUT_CU.tCustAnaOut[32].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[32]	;	
	Para.rCustAnaOut_ScalMax[32]	;
	Para.rI_CustAnaOut_ScalMin[32] ; 
	Para.rI_CustAnaOut_ScalMax[32] ;
	
	(* reserve analog output 33 *)
	OUT_CU.tCustAnaOut[33].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[33]	;	
	Para.rCustAnaOut_ScalMax[33]	;
	Para.rI_CustAnaOut_ScalMin[33] ; 
	Para.rI_CustAnaOut_ScalMax[33] ;
	
	(* reserve analog output 34 *)
	OUT_CU.tCustAnaOut[34].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[34]	;	
	Para.rCustAnaOut_ScalMax[34]	;
	Para.rI_CustAnaOut_ScalMin[34] ; 
	Para.rI_CustAnaOut_ScalMax[34] ;
	
	(* reserve analog output 35 *)
	OUT_CU.tCustAnaOut[35].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[35]	;	
	Para.rCustAnaOut_ScalMax[35]	;
	Para.rI_CustAnaOut_ScalMin[35] ; 
	Para.rI_CustAnaOut_ScalMax[35] ;
	
	(* reserve analog output 36 *)
	OUT_CU.tCustAnaOut[36].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[36]	;	
	Para.rCustAnaOut_ScalMax[36]	;
	Para.rI_CustAnaOut_ScalMin[36] ; 
	Para.rI_CustAnaOut_ScalMax[36] ;
	
	(* reserve analog output 37 *)
	OUT_CU.tCustAnaOut[37].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[37]	;	
	Para.rCustAnaOut_ScalMax[37]	;
	Para.rI_CustAnaOut_ScalMin[37] ; 
	Para.rI_CustAnaOut_ScalMax[37] ;
	
	(* reserve analog output 38 *)
	OUT_CU.tCustAnaOut[38].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[38]	;	
	Para.rCustAnaOut_ScalMax[38]	;
	Para.rI_CustAnaOut_ScalMin[38] ; 
	Para.rI_CustAnaOut_ScalMax[38] ;
	
	(* reserve analog output 39 *)
	OUT_CU.tCustAnaOut[39].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[39]	;	
	Para.rCustAnaOut_ScalMax[39]	;
	Para.rI_CustAnaOut_ScalMin[39] ; 
	Para.rI_CustAnaOut_ScalMax[39] ;
	
	(* reserve analog output 40 *)
	OUT_CU.tCustAnaOut[40].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[40]	;	
	Para.rCustAnaOut_ScalMax[40]	;
	Para.rI_CustAnaOut_ScalMin[40] ; 
	Para.rI_CustAnaOut_ScalMax[40] ;
	
	(* reserve analog output 41 *)
	OUT_CU.tCustAnaOut[41].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[41]	;	
	Para.rCustAnaOut_ScalMax[41]	;
	Para.rI_CustAnaOut_ScalMin[41] ; 
	Para.rI_CustAnaOut_ScalMax[41] ;
	
	(* reserve analog output 42 *)
	OUT_CU.tCustAnaOut[42].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[42]	;	
	Para.rCustAnaOut_ScalMax[42]	;
	Para.rI_CustAnaOut_ScalMin[42] ; 
	Para.rI_CustAnaOut_ScalMax[42] ;
	
	(* reserve analog output 43 *)
	OUT_CU.tCustAnaOut[43].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[43]	;	
	Para.rCustAnaOut_ScalMax[43]	;
	Para.rI_CustAnaOut_ScalMin[43] ; 
	Para.rI_CustAnaOut_ScalMax[43] ;
	
	(* reserve analog output 44 *)
	OUT_CU.tCustAnaOut[44].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[44]	;	
	Para.rCustAnaOut_ScalMax[44]	;
	Para.rI_CustAnaOut_ScalMin[44] ; 
	Para.rI_CustAnaOut_ScalMax[44] ;
	
	(* reserve analog output 45 *)
	OUT_CU.tCustAnaOut[45].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[45]	;	
	Para.rCustAnaOut_ScalMax[45]	;
	Para.rI_CustAnaOut_ScalMin[45] ; 
	Para.rI_CustAnaOut_ScalMax[45] ;
	
	(* reserve analog output 46 *)
	OUT_CU.tCustAnaOut[46].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[46]	;	
	Para.rCustAnaOut_ScalMax[46]	;
	Para.rI_CustAnaOut_ScalMin[46] ; 
	Para.rI_CustAnaOut_ScalMax[46] ;
	
	(* reserve analog output 47 *)
	OUT_CU.tCustAnaOut[47].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[47]	;	
	Para.rCustAnaOut_ScalMax[47]	;
	Para.rI_CustAnaOut_ScalMin[47] ; 
	Para.rI_CustAnaOut_ScalMax[47] ;
	
	(* reserve analog output 48 *)
	OUT_CU.tCustAnaOut[48].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[48]	;	
	Para.rCustAnaOut_ScalMax[48]	;
	Para.rI_CustAnaOut_ScalMin[48] ; 
	Para.rI_CustAnaOut_ScalMax[48] ;
	
	(* reserve analog output 49 *)
	OUT_CU.tCustAnaOut[49].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[49]	;	
	Para.rCustAnaOut_ScalMax[49]	;
	Para.rI_CustAnaOut_ScalMin[49] ; 
	Para.rI_CustAnaOut_ScalMax[49] ;
	
	(* reserve analog output 50 *)
	OUT_CU.tCustAnaOut[50].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[50]	;	
	Para.rCustAnaOut_ScalMax[50]	;
	Para.rI_CustAnaOut_ScalMin[50] ; 
	Para.rI_CustAnaOut_ScalMax[50] ;
	
	(*********************************************************************************************************************************)
	(* Reserve analog output 51 and above prepared from V4.11 on in PLC - FOR USE ONLY WITH `HMI_Extension` Package! *)  

	(* reserve analog output 51 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[51].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[51]	;
	Para.rCustAnaOut_ScalMax[51]	;
	Para.rI_CustAnaOut_ScalMin[51]	;
	Para.rI_CustAnaOut_ScalMax[51]	;
	
	(* reserve analog output 52 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[52].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[52]	;
	Para.rCustAnaOut_ScalMax[52]	;
	Para.rI_CustAnaOut_ScalMin[52]	;
	Para.rI_CustAnaOut_ScalMax[52]	;
	
	(* reserve analog output 53 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[53].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[53]	;	
	Para.rCustAnaOut_ScalMax[53]	;
	Para.rI_CustAnaOut_ScalMin[53]	; 
	Para.rI_CustAnaOut_ScalMax[53]	;
	
	(* reserve analog output 54 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[54].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[54]	;	
	Para.rCustAnaOut_ScalMax[54]	;
	Para.rI_CustAnaOut_ScalMin[54]	; 
	Para.rI_CustAnaOut_ScalMax[54]	;
	
	(* reserve analog output 55 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[55].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[55]	;	
	Para.rCustAnaOut_ScalMax[55]	;
	Para.rI_CustAnaOut_ScalMin[55]	; 
	Para.rI_CustAnaOut_ScalMax[55]	;
	
	(* reserve analog output 56 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[56].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[56]	;	
	Para.rCustAnaOut_ScalMax[56]	;
	Para.rI_CustAnaOut_ScalMin[56]	; 
	Para.rI_CustAnaOut_ScalMax[56]	;
	
	(* reserve analog output 57 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[57].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[57]	;	
	Para.rCustAnaOut_ScalMax[57]	;
	Para.rI_CustAnaOut_ScalMin[57]	; 
	Para.rI_CustAnaOut_ScalMax[57]	;
	
	(* reserve analog output 58 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[58].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[58]	;
	Para.rCustAnaOut_ScalMax[58]	;
	Para.rI_CustAnaOut_ScalMin[58]	; 
	Para.rI_CustAnaOut_ScalMax[58]	;
	
	(* reserve analog output 59 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[59].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[59]	;
	Para.rCustAnaOut_ScalMax[59]	;
	Para.rI_CustAnaOut_ScalMin[59]	; 
	Para.rI_CustAnaOut_ScalMax[59]	;
	
	(* reserve analog output 60 - ONLY USE WITH HMI Extension Package import! *)
	OUT_CU.tCustAnaOut[60].Ao	:= rConnectYourVariableHere ;	
	(*scaling parameter watch*)	
	Para.rCustAnaOut_ScalMin[60]	;
	Para.rCustAnaOut_ScalMax[60]	;
	Para.rI_CustAnaOut_ScalMin[60]	; 
	Para.rI_CustAnaOut_ScalMax[60]	;
	MM2VIS.rCustAnaOut[60] ; 								(*Example call of prepared spare analog output for VIS service display*)

	
	(*********************************************************************************************************************************)
	(* VIS service display values for the  prepared spare analog outputs *)
	FOR iCnt_AnaOut := 1 TO iNoOf_AnaOut DO
		MM2VIS.rCustAnaOut[iCnt_AnaOut] := OUT_CU.tCustAnaOut[iCnt_AnaOut].Ao; 		(*prepared spare analog output for VIS service display; signal scaling unchanged *)
	END_FOR
	(*********************************************************************************************************************************)

	

	(**********************************************************)
	(*                                                        *)
	(*                CONTROLLER OUTPUT SECTION               *)
	(*                                                        *)
	(**********************************************************)
															
	
//	(**********************************)
//	(* reserve controller output x    *)							(* (CONFIGURATION EXAMPLE)  *)
//	(* Reserveregler- Analogausgang x *)							(* (KONFIGURATIONSBEISPIEL) *)
//	(**********************************)	
//	OUT_CU.tCtr_CustOut[x].Ao		:= OUT_CU.tCtr_Cust1_Out.Y;		(* most times no change necessary *)
//	(*scaling parameter watch*)	
//	Para.rCtr_CustOut_ScalMin[x]	;								(* old, not used anymore *)
//	Para.rCtr_CustOut_ScalMax[x]	;								(* old, not used anymore *)
//	Para.rI_Ctr_CustOut_ScalMin[x]	;	(* := 4; *)					(*[mA]. For watch info only. AVOID HARDCODED PARA VALUES; scaling parameter are used in HAL only IF NO EPLAN SCALING DATA IS PROVIDED!	*)
//	Para.rI_Ctr_CustOut_ScalMax[x]	;	(* := 20; *)				(*[mA]. For watch info only. AVOID HARDCODED PARA VALUES; scaling parameter are used in HAL only IF NO EPLAN SCALING DATA IS PROVIDED!  *)


	(* reserve controller output 1 *)
	OUT_CU.tCtr_CustOut[1].Ao		:= OUT_CU.tCtr_Cust1_Out.Y;		(* most times no change necessary *)
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[1]	;
	Para.rI_Ctr_CustOut_ScalMax[1]	;

	(* reserve controller output 2 *)
	OUT_CU.tCtr_CustOut[2].Ao		:= OUT_CU.tCtr_Cust2_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[2]	;	
	Para.rI_Ctr_CustOut_ScalMax[2]	;


	(* reserve controller output 3 *)
	OUT_CU.tCtr_CustOut[3].Ao		:= OUT_CU.tCtr_Cust3_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[3]	;	
	Para.rI_Ctr_CustOut_ScalMax[3]	;


	(* reserve controller output 4 *)
	OUT_CU.tCtr_CustOut[4].Ao		:= OUT_CU.tCtr_Cust4_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[4]	;	
	Para.rI_Ctr_CustOut_ScalMax[4]	;


	(* reserve controller output 5 *)
	OUT_CU.tCtr_CustOut[5].Ao		:= OUT_CU.tCtr_Cust5_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[5]	;	
	Para.rI_Ctr_CustOut_ScalMax[5]	;


	(* reserve controller output 6 *)
	OUT_CU.tCtr_CustOut[6].Ao		:= OUT_CU.tCtr_Cust6_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[6]	;	
	Para.rI_Ctr_CustOut_ScalMax[6]	;

	
	(* reserve controller output 7 *)
	OUT_CU.tCtr_CustOut[7].Ao		:= OUT_CU.tCtr_Cust7_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[7]	;	
	Para.rI_Ctr_CustOut_ScalMax[7]	;

	
	(* reserve controller output 8 *)
	OUT_CU.tCtr_CustOut[8].Ao		:= OUT_CU.tCtr_Cust8_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[8]	;	
	Para.rI_Ctr_CustOut_ScalMax[8]	;

	
	(***********************************************************)	


	(* reserve controller output 41 *)
	OUT_CU.tCtr_CustOut[41].Ao		:= OUT_CU.tCtr_Cust41_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[41]	;	
	Para.rI_Ctr_CustOut_ScalMax[41]	;	

	
	(* reserve controller output 42 *)
	OUT_CU.tCtr_CustOut[42].Ao		:= OUT_CU.tCtr_Cust42_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[42]	;	
	Para.rI_Ctr_CustOut_ScalMax[42]	;
	
	
	(* reserve controller output 43 *)
	OUT_CU.tCtr_CustOut[43].Ao		:= OUT_CU.tCtr_Cust43_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[43]	;	
	Para.rI_Ctr_CustOut_ScalMax[43]	;
	
	
	(* reserve controller output 44 *)
	OUT_CU.tCtr_CustOut[44].Ao		:= OUT_CU.tCtr_Cust44_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[44]	;	
	Para.rI_Ctr_CustOut_ScalMax[44]	;
	
	
	(* reserve controller output 45 *)
	OUT_CU.tCtr_CustOut[45].Ao		:= OUT_CU.tCtr_Cust45_Out.Y;
	(*scaling parameter watch*)	
	Para.rI_Ctr_CustOut_ScalMin[45]	;	
	Para.rI_Ctr_CustOut_ScalMax[45]	;
	
	
	(*********************************************************************************************************************************)


END_PROGRAM
