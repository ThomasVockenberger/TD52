(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Programm: c_ana
 * Datei: c_anaInit.st
 * Autor: zengeres
 * Erstellt: 30. Januar 2014
 ********************************************************************
 *
 * ALL SETTINGS IN THIS INIT ARE OPTIONAL. 
 *
 * If you do not now a special reason, you should NOT SET ANYTHING HERE,
 * since all these settings will be done out of parameter files also.
 *
 ********************************************************************)

PROGRAM _INIT
	(* this parameter defaults will be read only once at first boot, if no Par_CU.dat file exists on the plc*)

	(********************************************)
	(*                                          *)
	(*           ANALOG INPUT SECTION           *)
	(*                                          *)
	(********************************************)

	(*-----------------------------------------------------------------------------*)
	(* Some example lines for intentional disabling of AI warning messages *)
	bBlockW13[03] := FALSE;   (* TRUE will disable Reserve ANALOG IN 1 Warning Signal Error –NUMBER W1177 (rerouted to historical designed message number) *)
	bBlockW13[06] := FALSE;   (* TRUE will disable Reserve ANALOG IN 2 Warning Signal Error –NUMBER W1178 (rerouted to historical designed message number) *)
	bBlockW13[09] := FALSE;   (* TRUE will disable Reserve ANALOG IN 3 Warning Signal Error –NUMBER W1179 (rerouted to historical designed message number) *)
	bBlockW13[12] := FALSE;   (* TRUE will disable Reserve ANALOG IN 4 Warning Signal Error –NUMBER W1180 (rerouted to historical designed message number) *)
	bBlockW13[15] := FALSE;   (* TRUE will disable Reserve ANALOG IN 5 Warning Signal Error –NUMBER W1181 (rerouted to historical designed message number) *)
	bBlockW13[18] := FALSE;   (* TRUE will disable Reserve ANALOG IN 6 Warning Signal Error –NUMBER W1182 (rerouted to historical designed message number) *)
	bBlockW13[21] := FALSE;   (* TRUE will disable Reserve ANALOG IN 7 Warning Signal Error –NUMBER W1183 (rerouted to historical designed message number) *)
	bBlockW13[24] := FALSE;   (* TRUE will disable Reserve ANALOG IN 8 Warning Signal Error –NUMBER W1184 (rerouted to historical designed message number) *)
	(*---*)
	bBlockW13[27] := FALSE;   (* TRUE will disable Reserve ANALOG IN 9 Warning Signal Error –NUMBER W1327*)
	bBlockW13[30] := FALSE;   (* TRUE will disable Reserve ANALOG IN10 Warning Signal Error –NUMBER W1330*)
	bBlockW13[33] := FALSE;   (* TRUE will disable Reserve ANALOG IN11 Warning Signal Error –NUMBER W1333*)
	bBlockW13[36] := FALSE;   (* TRUE will disable Reserve ANALOG IN12 Warning Signal Error –NUMBER W1336*)
	bBlockW13[39] := FALSE;   (* TRUE will disable Reserve ANALOG IN13 Warning Signal Error –NUMBER W1339*)
	bBlockW13[42] := FALSE;   (* TRUE will disable Reserve ANALOG IN14 Warning Signal Error –NUMBER W1342*)
	bBlockW13[45] := FALSE;   (* TRUE will disable Reserve ANALOG IN15 Warning Signal Error –NUMBER W1345*)
	bBlockW13[48] := FALSE;   (* TRUE will disable Reserve ANALOG IN16 Warning Signal Error –NUMBER W1348*)
	(*---*)	
	bBlockW13[51] := FALSE;   (* TRUE will disable Reserve ANALOG IN17 Warning Signal Error –NUMBER W1351*)
	bBlockW13[54] := FALSE;   (* TRUE will disable Reserve ANALOG IN18 Warning Signal Error –NUMBER W1354*)
	bBlockW13[57] := FALSE;   (* TRUE will disable Reserve ANALOG IN19 Warning Signal Error –NUMBER W1357*)
	bBlockW13[60] := FALSE;   (* TRUE will disable Reserve ANALOG IN20 Warning Signal Error –NUMBER W1360*)
	bBlockW13[63] := FALSE;   (* TRUE will disable Reserve ANALOG IN21 Warning Signal Error –NUMBER W1363*)
	bBlockW13[66] := FALSE;   (* TRUE will disable Reserve ANALOG IN22 Warning Signal Error –NUMBER W1366*)
	bBlockW13[69] := FALSE;   (* TRUE will disable Reserve ANALOG IN23 Warning Signal Error –NUMBER W1369*)	
	bBlockW13[72] := FALSE;   (* TRUE will disable Reserve ANALOG IN24 Warning Signal Error –NUMBER W1372*)		
	(*---*)	
	bBlockW13[75] := FALSE;   (* TRUE will disable Reserve ANALOG IN25 Warning Signal Error –NUMBER W1375*)
	bBlockW13[78] := FALSE;   (* TRUE will disable Reserve ANALOG IN26 Warning Signal Error –NUMBER W1378*)
	bBlockW13[81] := FALSE;   (* TRUE will disable Reserve ANALOG IN27 Warning Signal Error –NUMBER W1381*)
	bBlockW13[84] := FALSE;   (* TRUE will disable Reserve ANALOG IN28 Warning Signal Error –NUMBER W1384*)
	bBlockW13[87] := FALSE;   (* TRUE will disable Reserve ANALOG IN29 Warning Signal Error –NUMBER W1387*)
	bBlockW13[90] := FALSE;   (* TRUE will disable Reserve ANALOG IN30 Warning Signal Error –NUMBER W1390*)
	bBlockW13[93] := FALSE;   (* TRUE will disable Reserve ANALOG IN31 Warning Signal Error –NUMBER W1393*)	
	bBlockW13[96] := FALSE;   (* TRUE will disable Reserve ANALOG IN32 Warning Signal Error –NUMBER W1396*)	
	(*---*)		
	bBlockW13[99] := FALSE;   (* TRUE will disable Reserve ANALOG IN33 Warning Signal Error –NUMBER W1399*)	
	bBlockW14[02] := FALSE;   (* TRUE will disable Reserve ANALOG IN34 Warning Signal Error –NUMBER W1402*)		(*!	 W1400-W1498 USED for Analog In Cannel 34-66 with separate Min and Max and Signalerror Warnings *)
	bBlockW14[05] := FALSE;   (* TRUE will disable Reserve ANALOG IN35 Warning Signal Error –NUMBER W1405*)
	bBlockW14[08] := FALSE;   (* TRUE will disable Reserve ANALOG IN36 Warning Signal Error –NUMBER W1408*)
	bBlockW14[11] := FALSE;   (* TRUE will disable Reserve ANALOG IN37 Warning Signal Error –NUMBER W1411*)
	bBlockW14[14] := FALSE;   (* TRUE will disable Reserve ANALOG IN38 Warning Signal Error –NUMBER W1414*)
	bBlockW14[17] := FALSE;   (* TRUE will disable Reserve ANALOG IN39 Warning Signal Error –NUMBER W1417*)
	bBlockW14[20] := FALSE;   (* TRUE will disable Reserve ANALOG IN40 Warning Signal Error –NUMBER W1420*)
	(*---*)		
	bBlockW14[23] := FALSE;   (* TRUE will disable Reserve ANALOG IN41 Warning Signal Error –NUMBER W1423*)	
	bBlockW14[26] := FALSE;   (* TRUE will disable Reserve ANALOG IN42 Warning Signal Error –NUMBER W1426*)	
	bBlockW14[29] := FALSE;   (* TRUE will disable Reserve ANALOG IN43 Warning Signal Error –NUMBER W1429*)
	bBlockW14[32] := FALSE;   (* TRUE will disable Reserve ANALOG IN44 Warning Signal Error –NUMBER W1432*)
	bBlockW14[35] := FALSE;   (* TRUE will disable Reserve ANALOG IN45 Warning Signal Error –NUMBER W1435*)
	bBlockW14[38] := FALSE;   (* TRUE will disable Reserve ANALOG IN46 Warning Signal Error –NUMBER W1438*)
	bBlockW14[41] := FALSE;   (* TRUE will disable Reserve ANALOG IN47 Warning Signal Error –NUMBER W1441*)
	bBlockW14[44] := FALSE;   (* TRUE will disable Reserve ANALOG IN48 Warning Signal Error –NUMBER W1444*)
	(*---*)		
	bBlockW14[47] := FALSE;   (* TRUE will disable Reserve ANALOG IN49 Warning Signal Error –NUMBER W1447*)	
	bBlockW14[50] := FALSE;   (* TRUE will disable Reserve ANALOG IN50 Warning Signal Error –NUMBER W1450*)	
	bBlockW14[53] := FALSE;   (* TRUE will disable Reserve ANALOG IN51 Warning Signal Error –NUMBER W1453*)
	bBlockW14[56] := FALSE;   (* TRUE will disable Reserve ANALOG IN52 Warning Signal Error –NUMBER W1456*)
	bBlockW14[59] := FALSE;   (* TRUE will disable Reserve ANALOG IN53 Warning Signal Error –NUMBER W1459*)
	bBlockW14[62] := FALSE;   (* TRUE will disable Reserve ANALOG IN54 Warning Signal Error –NUMBER W1462*)
	bBlockW14[65] := FALSE;   (* TRUE will disable Reserve ANALOG IN55 Warning Signal Error –NUMBER W1465*)
	bBlockW14[68] := FALSE;   (* TRUE will disable Reserve ANALOG IN56 Warning Signal Error –NUMBER W1468*)
	(*---*)		
	bBlockW14[71] := FALSE;   (* TRUE will disable Reserve ANALOG IN57 Warning Signal Error –NUMBER W1471*)	
	bBlockW14[74] := FALSE;   (* TRUE will disable Reserve ANALOG IN58 Warning Signal Error –NUMBER W1474*)	
	bBlockW14[77] := FALSE;   (* TRUE will disable Reserve ANALOG IN59 Warning Signal Error –NUMBER W1477*)
	bBlockW14[80] := FALSE;   (* TRUE will disable Reserve ANALOG IN60 Warning Signal Error –NUMBER W1480*)
	(*...continue as needed, if more than 60 AI get activated*)
	(*-----------------------------------------------------------------------------*)

	(* EXAMPLES FOR OPTIONAL HARDCODED CONFIGURATION DEFAULTS:  *)
//	(*Reserve analog input x *)								(* (CONFIGURATION EXAMPLE) *)
//	ParaFactoryDefault.bCustAnaIn_Active[x] :=		FALSE;	(*SET HERE HARDCODED OPTIONALY (runtime changeable)  *)
//	ParaFactoryDefault.rCustAnaIn_ScalMin[x] := 	0.0;	(*SET HERE HARDCODED OPTIONALY (runtime changeable); Active only, when EPLAN definition is set 0-0 *)
//	ParaFactoryDefault.rCustAnaIn_ScalMax[x] := 	1.0;	(*SET HERE HARDCODED OPTIONALY (runtime changeable); Active only, when EPLAN definition is set 0-0 *)
//	ParaFactoryDefault.bCustAnaIn_Set4mA[x] := 		TRUE;	(*OLD, REMOVED*)
//	
//	ParaFactoryDefault.iCustAnaIn_MinMaxActive[x] := 3;		(*change customized: 0=no limit messages, 1=activate warning Lo, 2=activate warning hi,  3=activate warning Lo+Hi, (5=activate warning+alarm Lo,  10=activate warning+alarm Hi), 32=alle Störungen und Warnungen EIN   *)
//	ParaFactoryDefault.rCustAnaIn_LimLo[x]	:=		0.1;	(*SET ALARM LIMIT HERE HARDCODED OPTIONALY (runtime changeable)  *)
//	ParaFactoryDefault.rCustAnaIn_LimHi[x]	:=		0.9;	(*set ALARM LIMIT here hardcoded OPTIONALY (runtime changeable)  *)
//	ParaFactoryDefault.rCustAnaIn_Hy[x] := 			0.003; 	(*set hysterese here hardcoded OPTIONALY (runtime changeable)  *)		


	(*Reserve analog input 1*)
	ParaFactoryDefault.bCustAnaIn_Active[1] :=		FALSE;	
	ParaFactoryDefault.rCustAnaIn_ScalMin[1] := 	0.0;
	ParaFactoryDefault.rCustAnaIn_ScalMax[1] := 	1.0;
	
	ParaFactoryDefault.iCustAnaIn_MinMaxActive[1] := 3;	
	ParaFactoryDefault.rCustAnaIn_LimLo[1]	:=		0.1;
	ParaFactoryDefault.rCustAnaIn_LimHi[1]	:=		0.9;
	ParaFactoryDefault.rCustAnaIn_Hy[1] := 			0.003; 		


	(*Reserve analog input 2*)
	ParaFactoryDefault.bCustAnaIn_Active[2] :=		FALSE;	
	ParaFactoryDefault.rCustAnaIn_ScalMin[2] := 	0.0;
	ParaFactoryDefault.rCustAnaIn_ScalMax[2] := 	1.0;
	
	ParaFactoryDefault.iCustAnaIn_MinMaxActive[2] := 3;	
	ParaFactoryDefault.rCustAnaIn_LimLo[2]	:=		0.1;
	ParaFactoryDefault.rCustAnaIn_LimHi[2]	:=		0.9;
	ParaFactoryDefault.rCustAnaIn_Hy[2] := 			0.003; 	


	(*Reserve analog input 3*)
	ParaFactoryDefault.bCustAnaIn_Active[3] :=		FALSE;	
	ParaFactoryDefault.rCustAnaIn_ScalMin[3] := 	0.0;
	ParaFactoryDefault.rCustAnaIn_ScalMax[3] := 	1.0;
	
	ParaFactoryDefault.iCustAnaIn_MinMaxActive[3] := 3;	
	ParaFactoryDefault.rCustAnaIn_LimLo[3]	:=		0.1;
	ParaFactoryDefault.rCustAnaIn_LimHi[3]	:=		0.9;
	ParaFactoryDefault.rCustAnaIn_Hy[3] := 			0.003; 	


	(*Reserve analog input 4*)
	ParaFactoryDefault.bCustAnaIn_Active[4]		:= FALSE;

	(* ... *)

	(*Reserve analog input 60*)
	ParaFactoryDefault.bCustAnaIn_Active[60]	:= FALSE;



	(********************************************)
	(*                                          *)
	(*           ANALOG OUTPUT SECTION          *)
	(*                                          *)
	(********************************************)

	(*outputs (only scaling, no activation bit necessary) *)
	ParaFactoryDefault.rCustAnaOut_ScalMax[1] :=	4.0;	(*[mA]; SET HERE HARDCODED OPTIONALY (runtime changeable); Active only, when EPLAN definition is set 0-0 *)
	ParaFactoryDefault.rCustAnaOut_ScalMin[1] :=	20.0;	(*[mA]; SET HERE HARDCODED OPTIONALY (runtime changeable); Active only, when EPLAN definition is set 0-0 *)
	

	(* ... *)

	(* ...	change or extend this init file customized, if needed.	*)

	(*Check declared array sizze for all AO related types*)  (*iNoOf_AnaOut := 60;*)
	iNoOf_AnaOut_checked[0] := 	iNoOf_AnaOut ;
	iNoOf_AnaOut_checked[1] := SIZEOF(MM2VIS.rCustAnaOut) / SIZEOF(MM2VIS.rCustAnaOut[1]) - 1;									(*Get last element number of declared array*) 
	iNoOf_AnaOut_checked[2] := SIZEOF(OUT_CU.tCustAnaOut) / SIZEOF(OUT_CU.tCustAnaOut[1]) - 1;				(*Get last element number of declared array*) 
	iNoOf_AnaOut_checked[3] := SIZEOF(Para.rCustAnaOut_ScalMin) / SIZEOF(Para.rCustAnaOut_ScalMin[1]) - 1;	(*Get last element number of declared array*) 
	iNoOf_AnaOut_checked[4] := SIZEOF(Para.rCustAnaOut_ScalMax) / SIZEOF(Para.rCustAnaOut_ScalMax[1]) - 1;	(*Get last element number of declared array*) 
	iNoOf_AnaOut_checked[5] := SIZEOF(Para.bCustAnaOut_Active) / SIZEOF(Para.bCustAnaOut_Active[1]) - 1;		(*Get last element number of declared array*) 
	iNoOf_AnaOut_checked[6] := SIZEOF(Para.rI_CustAnaOut_ScalMin) / SIZEOF(Para.rI_CustAnaOut_ScalMin[1]) - 1;	(*Get last element number of declared array*) 
	iNoOf_AnaOut_checked[7] := SIZEOF(Para.rI_CustAnaOut_ScalMax) / SIZEOF(Para.rI_CustAnaOut_ScalMax[1]) - 1;	(*Get last element number of declared array*) 
	FOR i := 1 TO 7 DO
		iNoOf_AnaOut_checked[0] := MIN(iNoOf_AnaOut_checked[0] , iNoOf_AnaOut_checked[i] );
	END_FOR
	bErr_NoOf_AnaOut := iNoOf_AnaOut <> iNoOf_AnaOut_checked[0] ;

	
	(********************************************)
	(*                                          *)
	(*         CONTROLLER OUTPUT SECTION        *)
	(*                                          *)
	(********************************************)

	(*controller outputs (only scaling, no activation bit necessary) *)
	ParaFactoryDefault.rCtr_CustOut_ScalMax[1] :=	4.0;	(*[mA]; SET HERE HARDCODED OPTIONALY (runtime changeable); Active only, when EPLAN definition is set 0-0 *)
	ParaFactoryDefault.rCtr_CustOut_ScalMin[1] :=	20.0;	(*[mA]; SET HERE HARDCODED OPTIONALY (runtime changeable); Active only, when EPLAN definition is set 0-0 *)

	(* ... *)

	(* ...	change or extend this init file customized, if needed.	*)			






(********************** no changes bejond this line ****************************)

(*******************************************************************************)
(*   Compatibility code section below. NO NEED TO CHANGE on new XT4 engines!   *)
(*******************************************************************************)																			rReplaceMeWithLocaleVarName;		(* this statements mark places all over the code, that shoud be edited according to customer needs, but PLEASE leaf this occurence here unchanged for internal purposes*)
	(**OLD**)
	(*Old extension for analog inputs: Signal-Typ *)
	ParaFactoryDefault.iCustAnaIn_Typ[1] ; //:= 15;	 		(*(PARTLY OBSOLETE). ONLY USED TO ACTIVATE AN ADDITIONAL SCALING (without HAL changes) or for COMPATIBILITY WITH OLD XT and XT3 ENGINES *)
	(*0 ... mA oder +V	1 ... Pt100	2 ... NiCr-Ni	4 ... 4mA to 20mA  	(OBSOLETE TYPE CODES, numbers below 10 are here stated only for compatibility)
	Additional Scaling:	10... mA oder +V to paravalues scaled	15... Normed to paravalues scaled?		16...paravalues scaled to Normed?*)

	(*Old extension for analog inputs: physical unit display code for VIS  *)  
	ParaFactoryDefault.iCustAnaIn_Unit[1];	// := 0;		(*OBSOLETE. _Unit parameter is ONLY STATED HERE FOR COMPATIBILITY WITH OLD XT and XT3 ENGINES. Do not use on new engines.*)
	(*	1  = °C		2  = bar		3  = mbar	4  = kW		5  = kVAr		6  = mV		7  = V			8  = mA		9  = A			10 = kWh
	11 = MWh	12 = 0,1 MWh	13 = kVArh	14 = MVArh	15 = 0,1 MVArh	16 = m3		17 = 1000 m3	18 = Nm3	19 = 1000 Nm3	20 = m3/h
	21 = Nm3/h	22 = %			23 = 1/min	24 = Hz		25 = s			26 = h		27 = l			28 = °F		29 = psi		30 = mpsi	0  = none	*)
	(**/OLD**)

END_PROGRAM




