	(*******************************************************************************
	Msg_CU	 			 alarms generation MM_Customized
	
	This code is confidential and proprietary to the INNIO Company.
	It may not be used in any form, or reproduced in any manner,
	without written permission of the INNIO Company.
	Copyright, INNIO Company, 2022
	
	Customized modifications: -
	------------------------
	
	History:
	-------
	V0.01.0	02.11.2011	lettenb.	new
	V3.90.0 05.12.2012  zengerer	adopted for module customized
	...
	V4.00.0	05.03.2014	lettenb.	logger added
	V4.00.1	10.04.2014	lettenb.	making of bGnlTripX added(as information for custom.software designers)
	V4.02.0	11.08.2015  zengerer	xMsg17[ ].Q typo, error corr., message enable := TRUE as default
	V4.03.0	23.10.2015  zengerer	relesae for 4.3, fix 2087
	V4.04.0 09.11.2016	zengerer	mains power controller messages
	V4.05.0 05.09.2017	zengerer	bCustAlarm_Tripped[17]+ff. corr; + nachziehen der Netzbezugsregler Änderungen von Schwab Christoph / Caks Michael aus File Bugs&Solution_MnsCtrl.zip
	V4.05.0	17.10.2017	Zengerer	W2416 mains import controller Messsignalstörung Netzbezugs- Istwert
						lettenb.	W3566 removed, cleanup
	V4.05.1	29.01.2018	Zengerer	bParaSetupOk as enable condition for all AI alarms + messages, xMsg36[cnt].Num bugfix in Init
	V4.05.2	02.03.2018	Zengerer	Alarm A2302 is only active in Ctr_Mns mode, +Para.iCtr_Mns_Options INTERNAL parameter to set developer options
	V4.05.5	21.03.2018	Zengerer	OpMsg Autoreset time delay iDelay_MsgAutoReset_100ms as 'Message Hold Time' to avoid log clathering by repeated OpMsg entries (PROTOTYPES), iDelay_MsgAutoReset_100ms hardcoded again
	V4.05.5 18.04.2018	Schwab Christoph bMsg2302_Enable-- bMsg2418_Enable Version
	V4.07.0	12.11.2018	Zengerer	Typo corr. 3251
	V4.07.1	29.03.2019	Hohensinner	added Warnings: W9285, W9286, W9287
	V4.07.2	13.05.2019	Zengerer	Alarms A2416 ff. is only active with bParaSetupOk,   remove duplicate MM2VIS handling 1601-
	V4.11.0 21.01.2022  MayerR		Warning 9285 (Measuring signal failure external voltage setpoint moved to Generator module (v_ctrl)
			30.11.2021	Heim M.		Preparation for import HMI Extension :  reserve warnings 127 - 226 --> use Vis import HMI Extension  also, when Extension is used!
			20.01.2022	Zengerer	W4201ff changed to W8701ff reserve warnings 127 - 225 to avoid range conflicts
			31.01.2022	Zengerer	remove remains from moved bMsg9285 (follow up to 21.01.2022  MayerR) 
			09.03.2022	Zengerer	Msg2302/Msg2303 autoreset removed as default- activate reset only on customer demand
	V4.13.0	09.11.2023	Zengerer	bErr_NoOf_AnaOut display removed
						
	Instructions FOR use:
	--------------------
	 - bind alarm trigger to function element xMsgXXXX.set := 
	 - set the other function parameter hardcoded or connect spare parameter
	 - sw_confi: task have to be placed before of task: MsgCUInternal	
	
				
	Outstandings:
	------------

	(*******************************************************************************)
	
	
	PROGRAM _CYCLIC

	(* reset general trip *)
	OUT_CU.tCU2AB.bGnlTrip1		:=	FALSE;
	OUT_CU.tCU2AB.bGnlTrip2		:=	FALSE;
	OUT_CU.tCU2AB.bGnlTrip3		:=	FALSE;
	OUT_CU.tCU2AB.bGnlWarning	:=	FALSE;
	OUT_CU.tCU2AB.bTriptype1	:=	FALSE;
	OUT_CU.tCU2AB.bTriptype2	:=	FALSE;
	OUT_CU.tCU2AB.bTriptype3	:=	FALSE;			
	(*--------------------------------------------------------------------------*)
	
	
	(* A1001 reserve alarm 1 *)
	xMsg1001.Enable := 		 IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg1001.Set  := 		 FALSE;			(* <-connect alarm condition for reserve warning 27 here,  e.g. := DI_CUST_GAL;  *)
	xMsg1001.PT  := 		 T#0s;			(*alarm delay time*)
	xMsg1001.Prio  := 		 3;				(*alarm priority: 1-3 = trip, 4 = warning*)
	xMsg1001.RiskClass := 	 4;				(*risk class for remote alarm reset*)
	xMsg1001.Reset := 		 FALSE;			(*FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4, set TRUE only for autoreset alarms *)
	
	xMsg1001();
	
	OUT_CU.bCustAlarm_Tripped[1] :=	xMsg1001.Q;
	MM2VIS.bMsg1001 :=				xMsg1001.Q;
		

	
	
	(* A1002 reserve alarm 2 *)
	xMsg1002.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg1002.Set := 		FALSE;			
	xMsg1002.PT := 			T#0s;			
	xMsg1002.Prio := 		3;
	xMsg1002.RiskClass := 	4;
	xMsg1002.Reset :=		FALSE;
	
	xMsg1002();
	
	OUT_CU.bCustAlarm_Tripped[2] :=	xMsg1002.Q;
	MM2VIS.bMsg1002 := 				xMsg1002.Q;
	

	
	
	(* A1003 reserve alarm 3 *)
	xMsg1003.Enable := 		 IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1003.Set := 		FALSE;
	xMsg1003.PT := 			T#0s;
	xMsg1003.Prio := 		3;
	xMsg1003.RiskClass :=	4;
	xMsg1003.Reset := 		FALSE;
	
	xMsg1003();
	
	OUT_CU.bCustAlarm_Tripped[3] :=	xMsg1003.Q;
	MM2VIS.bMsg1003 := 		 		xMsg1003.Q;
	
	
	
	
	(* A1004 reserve alarm 4 *)
	xMsg1004.Enable := 		 IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1004.Set := 		FALSE;
	xMsg1004.PT := 			T#0s;
	xMsg1004.Prio := 		3;
	xMsg1004.RiskClass := 	4;
	xMsg1004.Reset := 		FALSE;
	
	xMsg1004();
	
	OUT_CU.bCustAlarm_Tripped[4] :=	xMsg1004.Q;
	MM2VIS.bMsg1004 := 				xMsg1004.Q;
	
	
	
	
	(* A1005 reserve alarm 5 *)
	xMsg1005.Enable := 		 IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1005.Set := 		FALSE;
	xMsg1005.PT := 			T#0s;
	xMsg1005.Prio := 		3;
	xMsg1005.RiskClass := 	4;
	xMsg1005.Reset := 		FALSE;
	
	xMsg1005();
	
	OUT_CU.bCustAlarm_Tripped[5] :=	xMsg1005.Q;
	MM2VIS.bMsg1005 :=				xMsg1005.Q;
	
	
	
	
	(* A1006 reserve alarm 6 *)
	xMsg1006.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1006.Set := 		FALSE;
	xMsg1006.PT := 			T#0s;
	xMsg1006.Prio := 		3;
	xMsg1006.RiskClass := 	4;
	xMsg1006.Reset := 		FALSE;
	
	xMsg1006();
	
	OUT_CU.bCustAlarm_Tripped[6] :=	xMsg1006.Q;
	MM2VIS.bMsg1006 :=				xMsg1006.Q;
	
	
	
	
	(* A1007 reserve alarm 7 *)
	xMsg1007.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1007.Set := 		FALSE;
	xMsg1007.PT := 			T#0s;
	xMsg1007.Prio := 		3;
	xMsg1007.RiskClass := 	4;
	xMsg1007.Reset := 		FALSE;
	
	xMsg1007();
	
	OUT_CU.bCustAlarm_Tripped[7] :=	xMsg1007.Q;
	MM2VIS.bMsg1007 :=				xMsg1007.Q;
	
	
	
	(* A1008 reserve alarm 8 *)
	xMsg1008.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1008.Set := 		FALSE;
	xMsg1008.PT := 			T#0s;
	xMsg1008.Prio := 		3;
	xMsg1008.RiskClass := 	4;
	xMsg1008.Reset := 		FALSE;
	
	xMsg1008();
	
	OUT_CU.bCustAlarm_Tripped[8] :=	xMsg1008.Q;
	MM2VIS.bMsg1008 :=				xMsg1008.Q;
	
	
	
	
	(* A1009 reserve alarm 9 *)
	xMsg1009.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1009.Set := 		FALSE;
	xMsg1009.PT := 			T#0s;
	xMsg1009.Prio := 		3;
	xMsg1009.RiskClass := 	4;
	xMsg1009.Reset := 		FALSE;

	
	xMsg1009();
	
	OUT_CU.bCustAlarm_Tripped[9] :=	xMsg1009.Q;
	MM2VIS.bMsg1009 :=				xMsg1009.Q;
	
	
	
	
	(* A1010 reserve alarm 10 *)
	xMsg1010.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1010.Set := 		FALSE;
	xMsg1010.PT := 			T#0s;
	xMsg1010.Prio := 		3;
	xMsg1010.RiskClass := 	4;
	xMsg1010.Reset := 		FALSE;
	
	xMsg1010();
	
	OUT_CU.bCustAlarm_Tripped[10] :=	xMsg1010.Q;
	MM2VIS.bMsg1010 :=					xMsg1010.Q;
	
	
	
	
	(* A1011 reserve alarm 11 *)
	xMsg1011.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1011.Set := 		FALSE;
	xMsg1011.PT := 			T#0s;
	xMsg1011.Prio := 		3;
	xMsg1011.RiskClass := 	4;
	xMsg1011.Reset := 		FALSE;
	
	xMsg1011();
	
	OUT_CU.bCustAlarm_Tripped[11] :=	xMsg1011.Q;
	MM2VIS.bMsg1011 :=					xMsg1011.Q;
	
	
	
	(* A1012 reserve alarm 12 *)
	xMsg1012.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1012.Set := 		FALSE;
	xMsg1012.PT := 			T#0s;
	xMsg1012.Prio := 		3;
	xMsg1012.RiskClass := 	4;
	xMsg1012.Reset := 		FALSE;
	
	xMsg1012();
	
	OUT_CU.bCustAlarm_Tripped[12] :=	xMsg1012.Q;
	MM2VIS.bMsg1012 :=					xMsg1012.Q;
	
	
	
	(* A1013 reserve alarm 13 *)
	xMsg1013.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1013.Set := 		FALSE;
	xMsg1013.PT := 			T#0s;
	xMsg1013.Prio := 		3;
	xMsg1013.RiskClass := 	4;
	xMsg1013.Reset := 		FALSE;
	
	xMsg1013();
	
	OUT_CU.bCustAlarm_Tripped[13] :=	xMsg1013.Q;
	MM2VIS.bMsg1013 :=					xMsg1013.Q;
	
	
	
	(* A1014 reserve alarm 14 *)
	xMsg1014.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1014.Set := 		FALSE;
	xMsg1014.PT := 			T#0s;
	xMsg1014.Prio := 		3;
	xMsg1014.RiskClass := 	4;
	xMsg1014.Reset := 		FALSE;
	
	xMsg1014();
	
	OUT_CU.bCustAlarm_Tripped[14] :=	xMsg1014.Q;
	MM2VIS.bMsg1014 :=					xMsg1014.Q;
	
	
	
	
	(* A1015 reserve alarm 15 *)
	xMsg1015.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1015.Set := 		FALSE;
	xMsg1015.PT := 			T#0s;
	xMsg1015.Prio := 		3;
	xMsg1015.RiskClass := 	4;
	xMsg1015.Reset := 		FALSE;
	
	xMsg1015();
	
	OUT_CU.bCustAlarm_Tripped[15] :=	xMsg1015.Q;
	MM2VIS.bMsg1015 :=					xMsg1015.Q;
	
	
	
	(* A1016 reserve alarm 16 *)
	xMsg1016.Enable := 		IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1016.Set := 		FALSE;
	xMsg1016.PT := 			T#0s;
	xMsg1016.Prio := 		3;
	xMsg1016.RiskClass := 	4;
	xMsg1016.Reset := 		FALSE;
	
	xMsg1016();
	
	OUT_CU.bCustAlarm_Tripped[16] :=	xMsg1016.Q;
	MM2VIS.bMsg1016 :=					xMsg1016.Q;
	

	

	(* A1601 to A1700:  reserve alarms 17 - 116 *)
	(********************************************)
	(* A1601 reserve alarm  17 *)			
	xMsg16[01].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[01].Set ;//:=			FALSE;			
	xMsg16[01].PT :=			T#0s;			
	xMsg16[01].Prio :=			3;		
	xMsg16[01].RiskClass := 	4;	
	xMsg16[01].Reset :=			FALSE;			
	xMsg16[01]();			
				
	OUT_CU.bCustAlarm_Tripped[17] :=	xMsg16[01].Q;			
	MM2VIS.bMsg1601 :=					xMsg16[01].Q;			
				
		
			
	(* A1602 reserve alarm  18 *)			
	xMsg16[02].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[02].Set ;//:=			FALSE;			
	xMsg16[02].PT :=			T#0s;			
	xMsg16[02].Prio :=			3;		
	xMsg16[02].RiskClass := 	4;		
	xMsg16[02].Reset :=			FALSE;			
	xMsg16[02]();			
				
	OUT_CU.bCustAlarm_Tripped[18] :=	xMsg16[02].Q;			
	MM2VIS.bMsg1602 :=					xMsg16[02].Q;			
				
		
			
	(* A1603 reserve alarm  19 *)			
	xMsg16[03].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[03].Set :=			FALSE;			
	xMsg16[03].PT :=			T#0s;			
	xMsg16[03].Prio :=			3;		
	xMsg16[03].RiskClass := 	4;	
	xMsg16[03].Reset :=			FALSE;			
	xMsg16[03]();			
				
	OUT_CU.bCustAlarm_Tripped[19] :=	xMsg16[03].Q;			
	MM2VIS.bMsg1603 :=					xMsg16[03].Q;			
			
		
				
	(* A1604 reserve alarm  20 *)			
	xMsg16[04].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[04].Set :=			FALSE;			
	xMsg16[04].PT :=			T#0s;			
	xMsg16[04].Prio :=			3;
	xMsg16[04].RiskClass := 	4;			
	xMsg16[04].Reset :=			FALSE;			
	xMsg16[04]();			
				
	OUT_CU.bCustAlarm_Tripped[20] :=	xMsg16[04].Q;			
	MM2VIS.bMsg1604 :=					xMsg16[04].Q;			
				
		
			
	(* A1605 reserve alarm  21 *)			
	xMsg16[05].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[05].Set :=			FALSE;			
	xMsg16[05].PT :=			T#0s;			
	xMsg16[05].Prio :=			3;	
	xMsg16[05].RiskClass := 	4;		
	xMsg16[05].Reset :=			FALSE;			
	xMsg16[05]();			
				
	OUT_CU.bCustAlarm_Tripped[21] :=	xMsg16[05].Q;			
	MM2VIS.bMsg1605 :=					xMsg16[05].Q;			
		
			
				
	(* A1606 reserve alarm  22 *)			
	xMsg16[06].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[06].Set :=			FALSE;			
	xMsg16[06].PT :=			T#0s;			
	xMsg16[06].Prio :=			3;	
	xMsg16[06].RiskClass := 	4;		
	xMsg16[06].Reset :=			FALSE;			
	xMsg16[06]();			
				
	OUT_CU.bCustAlarm_Tripped[22] :=	xMsg16[06].Q;			
	MM2VIS.bMsg1606 :=					xMsg16[06].Q;			
			
		
				
	(* A1607 reserve alarm  23 *)			
	xMsg16[07].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[07].Set :=			FALSE;			
	xMsg16[07].PT :=			T#0s;			
	xMsg16[07].Prio :=			3;	
	xMsg16[07].RiskClass := 	4;		
	xMsg16[07].Reset :=			FALSE;			
	xMsg16[07]();			
				
	OUT_CU.bCustAlarm_Tripped[23] :=	xMsg16[07].Q;			
	MM2VIS.bMsg1607 :=					xMsg16[07].Q;			
		
			
				
	(* A1608 reserve alarm  24 *)			
	xMsg16[08].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[08].Set :=			FALSE;			
	xMsg16[08].PT :=			T#0s;			
	xMsg16[08].Prio :=			3;
	xMsg16[08].RiskClass := 	4;			
	xMsg16[08].Reset :=			FALSE;			
	xMsg16[08]();			
				
	OUT_CU.bCustAlarm_Tripped[24] :=	xMsg16[08].Q;			
	MM2VIS.bMsg1608 :=					xMsg16[08].Q;			
				
				
	
	(* A1609 reserve alarm  25 *)			
	xMsg16[09].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[09].Set :=			FALSE;			
	xMsg16[09].PT :=			T#0s;			
	xMsg16[09].Prio :=			3;
	xMsg16[09].RiskClass := 	4;			
	xMsg16[09].Reset :=			FALSE;			
	xMsg16[09]();			
				
	OUT_CU.bCustAlarm_Tripped[25] :=	xMsg16[09].Q;			
	MM2VIS.bMsg1609 :=					xMsg16[09].Q;			
				
	
				
	(* A1610 reserve alarm  26 *)			
	xMsg16[10].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[10].Set :=			FALSE;			
	xMsg16[10].PT :=			T#0s;			
	xMsg16[10].Prio :=			3;
	xMsg16[10].RiskClass := 	4;			
	xMsg16[10].Reset :=			FALSE;			
	xMsg16[10]();			
				
	OUT_CU.bCustAlarm_Tripped[26] :=	xMsg16[10].Q;			
	MM2VIS.bMsg1610 :=					xMsg16[10].Q;			
				
	
				
	(* A1611 reserve alarm  27 *)			
	xMsg16[11].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[11].Set :=			FALSE;			
	xMsg16[11].PT :=			T#0s;			
	xMsg16[11].Prio :=			3;	
	xMsg16[11].RiskClass := 	4;			
	xMsg16[11].Reset :=			FALSE;			
	xMsg16[11]();			
				
	OUT_CU.bCustAlarm_Tripped[27] :=	xMsg16[11].Q;			
	MM2VIS.bMsg1611 :=					xMsg16[11].Q;			
				
	
				
	(* A1612 reserve alarm  28 *)			
	xMsg16[12].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[12].Set :=			FALSE;			
	xMsg16[12].PT :=			T#0s;			
	xMsg16[12].Prio :=			3;	
	xMsg16[12].RiskClass := 	4;			
	xMsg16[12].Reset :=			FALSE;			
	xMsg16[12]();			
				
	OUT_CU.bCustAlarm_Tripped[28] :=	xMsg16[12].Q;			
	MM2VIS.bMsg1612 :=					xMsg16[12].Q;			
				
			
		
	(* A1613 reserve alarm  29 *)			
	xMsg16[13].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[13].Set :=			FALSE;			
	xMsg16[13].PT :=			T#0s;			
	xMsg16[13].Prio :=			3;		
	xMsg16[13].RiskClass := 	4;		
	xMsg16[13].Reset :=			FALSE;			
	xMsg16[13]();			
				
	OUT_CU.bCustAlarm_Tripped[29] :=	xMsg16[13].Q;			
	MM2VIS.bMsg1613 :=					xMsg16[13].Q;			
			
		
				
	(* A1614 reserve alarm  30 *)			
	xMsg16[14].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[14].Set :=			FALSE;			
	xMsg16[14].PT :=			T#0s;			
	xMsg16[14].Prio :=			3;	
	xMsg16[14].RiskClass := 	4;			
	xMsg16[14].Reset :=			FALSE;			
	xMsg16[14]();			
				
	OUT_CU.bCustAlarm_Tripped[30] :=	xMsg16[14].Q;			
	MM2VIS.bMsg1614 :=					xMsg16[14].Q;			
			
		
				
	(* A1615 reserve alarm  31 *)			
	xMsg16[15].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[15].Set :=			FALSE;			
	xMsg16[15].PT :=			T#0s;			
	xMsg16[15].Prio :=			3;	
	xMsg16[15].RiskClass := 	4;			
	xMsg16[15].Reset :=			FALSE;			
	xMsg16[15]();			
				
	OUT_CU.bCustAlarm_Tripped[31] :=	xMsg16[15].Q;			
	MM2VIS.bMsg1615 :=					xMsg16[15].Q;			
				
			
		
	(* A1616 reserve alarm  32 *)			
	xMsg16[16].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[16].Set :=			FALSE;			
	xMsg16[16].PT :=			T#0s;			
	xMsg16[16].Prio :=			3;	
	xMsg16[16].RiskClass := 	4;			
	xMsg16[16].Reset :=			FALSE;			
	xMsg16[16]();			
				
	OUT_CU.bCustAlarm_Tripped[32] :=	xMsg16[16].Q;			
	MM2VIS.bMsg1616 :=					xMsg16[16].Q;			
			
		
				
	(* A1617 reserve alarm  33 *)			
	xMsg16[17].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[17].Set :=			FALSE;			
	xMsg16[17].PT :=			T#0s;			
	xMsg16[17].Prio :=			3;	
	xMsg16[17].RiskClass := 	4;			
	xMsg16[17].Reset :=			FALSE;			
	xMsg16[17]();			
				
	OUT_CU.bCustAlarm_Tripped[33] :=	xMsg16[17].Q;			
	MM2VIS.bMsg1617 :=					xMsg16[17].Q;			
			
		
				
	(* A1618 reserve alarm  34 *)			
	xMsg16[18].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[18].Set :=			FALSE;			
	xMsg16[18].PT :=			T#0s;			
	xMsg16[18].Prio :=			3;	
	xMsg16[18].RiskClass := 	4;			
	xMsg16[18].Reset :=			FALSE;			
	xMsg16[18]();			
				
	OUT_CU.bCustAlarm_Tripped[34] :=	xMsg16[18].Q;			
	MM2VIS.bMsg1618 :=					xMsg16[18].Q;			

					
				
	(* A1619 reserve alarm  35 *)			
	xMsg16[19].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[19].Set :=			FALSE;			
	xMsg16[19].PT :=			T#0s;			
	xMsg16[19].Prio :=			3;	
	xMsg16[19].RiskClass := 	4;			
	xMsg16[19].Reset :=			FALSE;			
	xMsg16[19]();			
				
	OUT_CU.bCustAlarm_Tripped[35] :=	xMsg16[19].Q;			
	MM2VIS.bMsg1619 :=					xMsg16[19].Q;			
				

					
	(* A1620 reserve alarm  36 *)			
	xMsg16[20].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[20].Set :=			FALSE;			
	xMsg16[20].PT :=			T#0s;			
	xMsg16[20].Prio :=			3;	
	xMsg16[20].RiskClass := 	4;			
	xMsg16[20].Reset :=			FALSE;			
	xMsg16[20]();			
				
	OUT_CU.bCustAlarm_Tripped[36] :=	xMsg16[20].Q;			
	MM2VIS.bMsg1620 :=					xMsg16[20].Q;			
				

					
	(* A1621 reserve alarm  37 *)			
	xMsg16[21].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[21].Set :=			FALSE;			
	xMsg16[21].PT :=			T#0s;			
	xMsg16[21].Prio :=			3;	
	xMsg16[21].RiskClass := 	4;			
	xMsg16[21].Reset :=			FALSE;			
	xMsg16[21]();			
				
	OUT_CU.bCustAlarm_Tripped[37] :=	xMsg16[21].Q;			
	MM2VIS.bMsg1621 :=					xMsg16[21].Q;			
				

					
	(* A1622 reserve alarm  38 *)			
	xMsg16[22].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[22].Set :=			FALSE;			
	xMsg16[22].PT :=			T#0s;			
	xMsg16[22].Prio :=			3;	
	xMsg16[22].RiskClass := 	4;			
	xMsg16[22].Reset :=			FALSE;			
	xMsg16[22]();			
				
	OUT_CU.bCustAlarm_Tripped[38] :=	xMsg16[22].Q;			
	MM2VIS.bMsg1622 :=					xMsg16[22].Q;			

					
				
	(* A1623 reserve alarm  39 *)			
	xMsg16[23].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[23].Set :=			FALSE;			
	xMsg16[23].PT :=			T#0s;			
	xMsg16[23].Prio :=			3;	
	xMsg16[23].RiskClass := 	4;			
	xMsg16[23].Reset :=			FALSE;			
	xMsg16[23]();			
				
	OUT_CU.bCustAlarm_Tripped[39] :=	xMsg16[23].Q;			
	MM2VIS.bMsg1623 :=					xMsg16[23].Q;			

					
				
	(* A1624 reserve alarm  40 *)			
	xMsg16[24].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[24].Set :=			FALSE;			
	xMsg16[24].PT :=			T#0s;			
	xMsg16[24].Prio :=			3;	
	xMsg16[24].RiskClass := 	4;			
	xMsg16[24].Reset :=			FALSE;			
	xMsg16[24]();			
				
	OUT_CU.bCustAlarm_Tripped[40] :=	xMsg16[24].Q;			
	MM2VIS.bMsg1624 :=					xMsg16[24].Q;			

					
				
	(* A1625 reserve alarm  41 *)			
	xMsg16[25].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[25].Set :=			FALSE;			
	xMsg16[25].PT :=			T#0s;			
	xMsg16[25].Prio :=			3;	
	xMsg16[25].RiskClass := 	4;			
	xMsg16[25].Reset :=			FALSE;			
	xMsg16[25]();			
				
	OUT_CU.bCustAlarm_Tripped[41] :=	xMsg16[25].Q;			
	MM2VIS.bMsg1625 :=					xMsg16[25].Q;			

					
				
	(* A1626 reserve alarm  42 *)			
	xMsg16[26].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[26].Set :=			FALSE;			
	xMsg16[26].PT :=			T#0s;			
	xMsg16[26].Prio :=			3;	
	xMsg16[26].RiskClass := 	4;			
	xMsg16[26].Reset :=			FALSE;			
	xMsg16[26]();			
				
	OUT_CU.bCustAlarm_Tripped[42] :=	xMsg16[26].Q;			
	MM2VIS.bMsg1626 :=					xMsg16[26].Q;			

	
					
	(* A1627 reserve alarm  43 *)			
	xMsg16[27].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[27].Set :=			FALSE;			
	xMsg16[27].PT :=			T#0s;			
	xMsg16[27].Prio :=			3;	
	xMsg16[27].RiskClass := 	4;			
	xMsg16[27].Reset :=			FALSE;			
	xMsg16[27]();			
				
	OUT_CU.bCustAlarm_Tripped[43] :=	xMsg16[27].Q;			
	MM2VIS.bMsg1627 :=					xMsg16[27].Q;			
				
	
				
	(* A1628 reserve alarm  44 *)			
	xMsg16[28].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[28].Set :=			FALSE;			
	xMsg16[28].PT :=			T#0s;			
	xMsg16[28].Prio :=			3;	
	xMsg16[28].RiskClass := 	4;			
	xMsg16[28].Reset :=			FALSE;			
	xMsg16[28]();			
				
	OUT_CU.bCustAlarm_Tripped[44] :=	xMsg16[28].Q;			
	MM2VIS.bMsg1628 :=					xMsg16[28].Q;			

					
				
	(* A1629 reserve alarm  45 *)			
	xMsg16[29].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[29].Set :=			FALSE;			
	xMsg16[29].PT :=			T#0s;			
	xMsg16[29].Prio :=			3;	
	xMsg16[29].RiskClass := 	4;			
	xMsg16[29].Reset :=			FALSE;			
	xMsg16[29]();			
				
	OUT_CU.bCustAlarm_Tripped[45] :=	xMsg16[29].Q;			
	MM2VIS.bMsg1629 :=					xMsg16[29].Q;			

	
					
	(* A1630 reserve alarm  46 *)			
	xMsg16[30].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[30].Set :=			FALSE;			
	xMsg16[30].PT :=			T#0s;			
	xMsg16[30].Prio :=			3;	
	xMsg16[30].RiskClass := 	4;			
	xMsg16[30].Reset :=			FALSE;			
	xMsg16[30]();			
				
	OUT_CU.bCustAlarm_Tripped[46] :=	xMsg16[30].Q;			
	MM2VIS.bMsg1630 :=					xMsg16[30].Q;			

					
				
	(* A1631 reserve alarm  47 *)			
	xMsg16[31].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[31].Set :=			FALSE;			
	xMsg16[31].PT :=			T#0s;			
	xMsg16[31].Prio :=			3;	
	xMsg16[31].RiskClass := 	4;			
	xMsg16[31].Reset :=			FALSE;			
	xMsg16[31]();			
				
	OUT_CU.bCustAlarm_Tripped[47] :=	xMsg16[31].Q;			
	MM2VIS.bMsg1631 :=					xMsg16[31].Q;			

					
				
	(* A1632 reserve alarm  48 *)			
	xMsg16[32].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[32].Set :=			FALSE;			
	xMsg16[32].PT :=			T#0s;			
	xMsg16[32].Prio :=			3;	
	xMsg16[32].RiskClass := 	4;			
	xMsg16[32].Reset :=			FALSE;			
	xMsg16[32]();			
				
	OUT_CU.bCustAlarm_Tripped[48] :=	xMsg16[32].Q;			
	MM2VIS.bMsg1632 :=					xMsg16[32].Q;			

					
				
	(* A1633 reserve alarm  49 *)			
	xMsg16[33].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[33].Set :=			FALSE;			
	xMsg16[33].PT :=			T#0s;			
	xMsg16[33].Prio :=			3;	
	xMsg16[33].RiskClass := 	4;			
	xMsg16[33].Reset :=			FALSE;			
	xMsg16[33]();			
				
	OUT_CU.bCustAlarm_Tripped[49] :=	xMsg16[33].Q;			
	MM2VIS.bMsg1633 :=					xMsg16[33].Q;			

					
				
	(* A1634 reserve alarm  50 *)			
	xMsg16[34].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[34].Set :=			FALSE;			
	xMsg16[34].PT :=			T#0s;			
	xMsg16[34].Prio :=			3;	
	xMsg16[34].RiskClass := 	4;			
	xMsg16[34].Reset :=			FALSE;			
	xMsg16[34]();			
				
	OUT_CU.bCustAlarm_Tripped[50] :=	xMsg16[34].Q;			
	MM2VIS.bMsg1634 :=					xMsg16[34].Q;			

					
				
	(* A1635 reserve alarm  51 *)			
	xMsg16[35].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[35].Set :=			FALSE;			
	xMsg16[35].PT :=			T#0s;			
	xMsg16[35].Prio :=			3;		
	xMsg16[35].RiskClass := 	4;		
	xMsg16[35].Reset :=			FALSE;			
	xMsg16[35]();			
				
	OUT_CU.bCustAlarm_Tripped[51] :=	xMsg16[35].Q;			
	MM2VIS.bMsg1635 :=					xMsg16[35].Q;			
				

					
	(* A1636 reserve alarm  52 *)			
	xMsg16[36].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[36].Set :=			FALSE;			
	xMsg16[36].PT :=			T#0s;			
	xMsg16[36].Prio :=			3;		
	xMsg16[36].RiskClass := 	4;		
	xMsg16[36].Reset :=			FALSE;			
	xMsg16[36]();			
				
	OUT_CU.bCustAlarm_Tripped[52] :=	xMsg16[36].Q;			
	MM2VIS.bMsg1636 :=					xMsg16[36].Q;			
				
				

	(* A1637 reserve alarm  53 *)			
	xMsg16[37].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[37].Set :=			FALSE;			
	xMsg16[37].PT :=			T#0s;			
	xMsg16[37].Prio :=			3;		
	xMsg16[37].RiskClass := 	4;		
	xMsg16[37].Reset :=			FALSE;			
	xMsg16[37]();			
				
	OUT_CU.bCustAlarm_Tripped[53] :=	xMsg16[37].Q;			
	MM2VIS.bMsg1637 :=					xMsg16[37].Q;			
				
				

	(* A1638 reserve alarm  54 *)			
	xMsg16[38].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[38].Set :=			FALSE;			
	xMsg16[38].PT :=			T#0s;			
	xMsg16[38].Prio :=			3;	
	xMsg16[38].RiskClass := 	4;			
	xMsg16[38].Reset :=			FALSE;			
	xMsg16[38]();			
				
	OUT_CU.bCustAlarm_Tripped[54] :=	xMsg16[38].Q;			
	MM2VIS.bMsg1638 :=					xMsg16[38].Q;			
				
				

	(* A1639 reserve alarm  55 *)			
	xMsg16[39].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[39].Set :=			FALSE;			
	xMsg16[39].PT :=			T#0s;			
	xMsg16[39].Prio :=			3;	
	xMsg16[39].RiskClass := 	4;			
	xMsg16[39].Reset :=			FALSE;			
	xMsg16[39]();			
				
	OUT_CU.bCustAlarm_Tripped[55] :=	xMsg16[39].Q;			
	MM2VIS.bMsg1639 :=					xMsg16[39].Q;			
				
				

	(* A1640 reserve alarm  56 *)			
	xMsg16[40].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[40].Set :=			FALSE;			
	xMsg16[40].PT :=			T#0s;			
	xMsg16[40].Prio :=			3;	
	xMsg16[40].RiskClass := 	4;			
	xMsg16[40].Reset :=			FALSE;			
	xMsg16[40]();			
				
	OUT_CU.bCustAlarm_Tripped[56] :=	xMsg16[40].Q;			
	MM2VIS.bMsg1640 :=					xMsg16[40].Q;			
				
				

	(* A1641 reserve alarm  57 *)			
	xMsg16[41].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[41].Set :=			FALSE;			
	xMsg16[41].PT :=			T#0s;			
	xMsg16[41].Prio :=			3;	
	xMsg16[41].RiskClass := 	4;			
	xMsg16[41].Reset :=			FALSE;			
	xMsg16[41]();			
				
	OUT_CU.bCustAlarm_Tripped[57] :=	xMsg16[41].Q;			
	MM2VIS.bMsg1641 :=					xMsg16[41].Q;			
				
				

	(* A1642 reserve alarm  58 *)			
	xMsg16[42].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[42].Set :=			FALSE;			
	xMsg16[42].PT :=			T#0s;			
	xMsg16[42].Prio :=			3;	
	xMsg16[42].RiskClass := 	4;			
	xMsg16[42].Reset :=			FALSE;			
	xMsg16[42]();			
				
	OUT_CU.bCustAlarm_Tripped[58] :=	xMsg16[42].Q;			
	MM2VIS.bMsg1642 :=					xMsg16[42].Q;			
				

					
	(* A1643 reserve alarm  59 *)			
	xMsg16[43].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[43].Set :=			FALSE;			
	xMsg16[43].PT :=			T#0s;			
	xMsg16[43].Prio :=			3;	
	xMsg16[43].RiskClass := 	4;			
	xMsg16[43].Reset :=			FALSE;			
	xMsg16[43]();			
				
	OUT_CU.bCustAlarm_Tripped[59] :=	xMsg16[43].Q;			
	MM2VIS.bMsg1643 :=					xMsg16[43].Q;			
				

					
	(* A1644 reserve alarm  60 *)			
	xMsg16[44].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[44].Set :=			FALSE;			
	xMsg16[44].PT :=			T#0s;			
	xMsg16[44].Prio :=			3;	
	xMsg16[44].RiskClass := 	4;			
	xMsg16[44].Reset :=			FALSE;			
	xMsg16[44]();			
				
	OUT_CU.bCustAlarm_Tripped[60] :=	xMsg16[44].Q;			
	MM2VIS.bMsg1644 :=					xMsg16[44].Q;			

					
				
	(* A1645 reserve alarm  61 *)			
	xMsg16[45].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[45].Set :=			FALSE;			
	xMsg16[45].PT :=			T#0s;			
	xMsg16[45].Prio :=			3;	
	xMsg16[45].RiskClass := 	4;			
	xMsg16[45].Reset :=			FALSE;			
	xMsg16[45]();			
				
	OUT_CU.bCustAlarm_Tripped[61] :=	xMsg16[45].Q;			
	MM2VIS.bMsg1645 :=					xMsg16[45].Q;			
				

					
	(* A1646 reserve alarm  62 *)			
	xMsg16[46].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[46].Set :=			FALSE;			
	xMsg16[46].PT :=			T#0s;			
	xMsg16[46].Prio :=			3;	
	xMsg16[46].RiskClass := 	4;			
	xMsg16[46].Reset :=			FALSE;			
	xMsg16[46]();			
				
	OUT_CU.bCustAlarm_Tripped[62] :=	xMsg16[46].Q;			
	MM2VIS.bMsg1646 :=					xMsg16[46].Q;			

					
				
	(* A1647 reserve alarm  63 *)			
	xMsg16[47].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[47].Set :=			FALSE;			
	xMsg16[47].PT :=			T#0s;			
	xMsg16[47].Prio :=			3;	
	xMsg16[47].RiskClass := 	4;			
	xMsg16[47].Reset :=			FALSE;			
	xMsg16[47]();			
				
	OUT_CU.bCustAlarm_Tripped[63] :=	xMsg16[47].Q;			
	MM2VIS.bMsg1647 :=					xMsg16[47].Q;			

					
				
	(* A1648 reserve alarm  64 *)			
	xMsg16[48].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[48].Set :=			FALSE;			
	xMsg16[48].PT :=			T#0s;			
	xMsg16[48].Prio :=			3;	
	xMsg16[48].RiskClass := 	4;			
	xMsg16[48].Reset :=			FALSE;			
	xMsg16[48]();			
				
	OUT_CU.bCustAlarm_Tripped[64] :=	xMsg16[48].Q;			
	MM2VIS.bMsg1648 :=					xMsg16[48].Q;			
				

					
	(* A1649 reserve alarm  65 *)			
	xMsg16[49].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[49].Set :=			FALSE;			
	xMsg16[49].PT :=			T#0s;			
	xMsg16[49].Prio :=			3;	
	xMsg16[49].RiskClass := 	4;			
	xMsg16[49].Reset :=			FALSE;			
	xMsg16[49]();			
				
	OUT_CU.bCustAlarm_Tripped[65] :=	xMsg16[49].Q;			
	MM2VIS.bMsg1649 :=					xMsg16[49].Q;			
				

					
	(* A1650 reserve alarm  66 *)			
	xMsg16[50].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[50].Set :=			FALSE;			
	xMsg16[50].PT :=			T#0s;			
	xMsg16[50].Prio :=			3;	
	xMsg16[50].RiskClass := 	4;			
	xMsg16[50].Reset :=			FALSE;			
	xMsg16[50]();			
				
	OUT_CU.bCustAlarm_Tripped[66] :=	xMsg16[50].Q;			
	MM2VIS.bMsg1650 :=					xMsg16[50].Q;			
				
	
				
	(* A1651 reserve alarm  67 *)			
	xMsg16[51].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[51].Set;// :=			FALSE;			
	xMsg16[51].PT :=			T#0s;			
	xMsg16[51].Prio :=			3;	
	xMsg16[51].RiskClass := 	4;			
	xMsg16[51].Reset :=			FALSE;			
	xMsg16[51]();			
				
	OUT_CU.bCustAlarm_Tripped[67] :=	xMsg16[51].Q;			
	MM2VIS.bMsg1651 :=					xMsg16[51].Q;			

					
				
	(* A1652 reserve alarm  68 *)			
	xMsg16[52].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[52].Set;// :=			FALSE;			
	xMsg16[52].PT :=			T#0s;			
	xMsg16[52].Prio :=			3;	
	xMsg16[52].RiskClass := 	4;			
	xMsg16[52].Reset :=			FALSE;			
	xMsg16[52]();			
				
	OUT_CU.bCustAlarm_Tripped[68] :=	xMsg16[52].Q;			
	MM2VIS.bMsg1652 :=					xMsg16[52].Q;			
				

					
	(* A1653 reserve alarm  69 *)			
	xMsg16[53].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[53].Set ;//:=			FALSE;			
	xMsg16[53].PT :=			T#0s;			
	xMsg16[53].Prio :=			3;		
	xMsg16[53].RiskClass := 	4;		
	xMsg16[53].Reset :=			FALSE;			
	xMsg16[53]();			
				
	OUT_CU.bCustAlarm_Tripped[69] :=	xMsg16[53].Q;			
	MM2VIS.bMsg1653 :=					xMsg16[53].Q;			
				

					
	(* A1654 reserve alarm  70 *)			
	xMsg16[54].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[54].Set ;//:=			FALSE;			
	xMsg16[54].PT :=			T#0s;			
	xMsg16[54].Prio :=			3;	
	xMsg16[54].RiskClass := 	4;			
	xMsg16[54].Reset :=			FALSE;			
	xMsg16[54]();			
				
	OUT_CU.bCustAlarm_Tripped[70] :=	xMsg16[54].Q;			
	MM2VIS.bMsg1654 :=					xMsg16[54].Q;			
				

					
	(* A1655 reserve alarm  71 *)			
	xMsg16[55].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[55].Set :=			FALSE;			
	xMsg16[55].PT :=			T#0s;			
	xMsg16[55].Prio :=			3;	
	xMsg16[55].RiskClass := 	4;			
	xMsg16[55].Reset :=			FALSE;			
	xMsg16[55]();			
				
	OUT_CU.bCustAlarm_Tripped[71] :=	xMsg16[55].Q;			
	MM2VIS.bMsg1655 :=					xMsg16[55].Q;			
				

					
	(* A1656 reserve alarm  72 *)			
	xMsg16[56].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[56].Set :=			FALSE;			
	xMsg16[56].PT :=			T#0s;			
	xMsg16[56].Prio :=			3;	
	xMsg16[56].RiskClass := 	4;			
	xMsg16[56].Reset :=			FALSE;			
	xMsg16[56]();			
				
	OUT_CU.bCustAlarm_Tripped[72] :=	xMsg16[56].Q;			
	MM2VIS.bMsg1656 :=					xMsg16[56].Q;			
				

					
	(* A1657 reserve alarm  73 *)			
	xMsg16[57].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[57].Set :=			FALSE;			
	xMsg16[57].PT :=			T#0s;			
	xMsg16[57].Prio :=			3;	
	xMsg16[57].RiskClass := 	4;			
	xMsg16[57].Reset :=			FALSE;			
	xMsg16[57]();			
				
	OUT_CU.bCustAlarm_Tripped[73] :=	xMsg16[57].Q;			
	MM2VIS.bMsg1657 :=					xMsg16[57].Q;			

					
				
	(* A1658 reserve alarm  74 *)			
	xMsg16[58].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[58].Set :=			FALSE;			
	xMsg16[58].PT :=			T#0s;			
	xMsg16[58].Prio :=			3;	
	xMsg16[58].RiskClass := 	4;			
	xMsg16[58].Reset :=			FALSE;			
	xMsg16[58]();			
				
	OUT_CU.bCustAlarm_Tripped[74] :=	xMsg16[58].Q;			
	MM2VIS.bMsg1658 :=					xMsg16[58].Q;			
				

					
	(* A1659 reserve alarm  75 *)			
	xMsg16[59].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[59].Set :=			FALSE;			
	xMsg16[59].PT :=			T#0s;			
	xMsg16[59].Prio :=			3;		
	xMsg16[59].RiskClass := 	4;		
	xMsg16[59].Reset :=			FALSE;			
	xMsg16[59]();			
				
	OUT_CU.bCustAlarm_Tripped[75] :=	xMsg16[59].Q;			
	MM2VIS.bMsg1659 :=					xMsg16[59].Q;			
				

					
	(* A1660 reserve alarm  76 *)			
	xMsg16[60].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[60].Set :=			FALSE;			
	xMsg16[60].PT :=			T#0s;			
	xMsg16[60].Prio :=			3;	
	xMsg16[60].RiskClass := 	4;			
	xMsg16[60].Reset :=			FALSE;			
	xMsg16[60]();			
				
	OUT_CU.bCustAlarm_Tripped[76] :=	xMsg16[60].Q;			
	MM2VIS.bMsg1660 :=					xMsg16[60].Q;			

					
				
	(* A1661 reserve alarm  77 *)			
	xMsg16[61].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[61].Set :=			FALSE;			
	xMsg16[61].PT :=			T#0s;			
	xMsg16[61].Prio :=			3;	
	xMsg16[61].RiskClass := 	4;			
	xMsg16[61].Reset :=			FALSE;			
	xMsg16[61]();			
				
	OUT_CU.bCustAlarm_Tripped[77] :=	xMsg16[61].Q;			
	MM2VIS.bMsg1661 :=					xMsg16[61].Q;			

					
				
	(* A1662 reserve alarm  78 *)			
	xMsg16[62].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[62].Set :=			FALSE;			
	xMsg16[62].PT :=			T#0s;			
	xMsg16[62].Prio :=			3;	
	xMsg16[62].RiskClass := 	4;			
	xMsg16[62].Reset :=			FALSE;			
	xMsg16[62]();			
				
	OUT_CU.bCustAlarm_Tripped[78] :=	xMsg16[62].Q;			
	MM2VIS.bMsg1662 :=					xMsg16[62].Q;			

					
				
	(* A1663 reserve alarm  79 *)			
	xMsg16[63].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[63].Set :=			FALSE;			
	xMsg16[63].PT :=			T#0s;			
	xMsg16[63].Prio :=			3;	
	xMsg16[63].RiskClass := 	4;			
	xMsg16[63].Reset :=			FALSE;			
	xMsg16[63]();			
				
	OUT_CU.bCustAlarm_Tripped[79] :=	xMsg16[63].Q;			
	MM2VIS.bMsg1663 :=					xMsg16[63].Q;			

					
				
	(* A1664 reserve alarm  80 *)			
	xMsg16[64].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[64].Set :=			FALSE;			
	xMsg16[64].PT :=			T#0s;			
	xMsg16[64].Prio :=			3;	
	xMsg16[64].RiskClass := 	4;			
	xMsg16[64].Reset :=			FALSE;			
	xMsg16[64]();			
				
	OUT_CU.bCustAlarm_Tripped[80] :=	xMsg16[64].Q;			
	MM2VIS.bMsg1664 :=					xMsg16[64].Q;			

					
				
	(* A1665 reserve alarm  81 *)			
	xMsg16[65].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[65].Set :=			FALSE;			
	xMsg16[65].PT :=			T#0s;			
	xMsg16[65].Prio :=			3;	
	xMsg16[65].RiskClass := 	4;			
	xMsg16[65].Reset :=			FALSE;			
	xMsg16[65]();			
				
	OUT_CU.bCustAlarm_Tripped[81] :=	xMsg16[65].Q;			
	MM2VIS.bMsg1665 :=					xMsg16[65].Q;			

					
				
	(* A1666 reserve alarm  82 *)			
	xMsg16[66].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[66].Set :=			FALSE;			
	xMsg16[66].PT :=			T#0s;			
	xMsg16[66].Prio :=			3;	
	xMsg16[66].RiskClass := 	4;			
	xMsg16[66].Reset :=			FALSE;			
	xMsg16[66]();			
				
	OUT_CU.bCustAlarm_Tripped[82] :=	xMsg16[66].Q;			
	MM2VIS.bMsg1666 :=					xMsg16[66].Q;			

					
				
	(* A1667 reserve alarm  83 *)			
	xMsg16[67].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[67].Set :=			FALSE;			
	xMsg16[67].PT :=			T#0s;			
	xMsg16[67].Prio :=			3;	
	xMsg16[67].RiskClass := 	4;			
	xMsg16[67].Reset :=			FALSE;			
	xMsg16[67]();			
				
	OUT_CU.bCustAlarm_Tripped[83] :=	xMsg16[67].Q;			
	MM2VIS.bMsg1667 :=					xMsg16[67].Q;			

					
				
	(* A1668 reserve alarm  84 *)			
	xMsg16[68].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[68].Set :=			FALSE;			
	xMsg16[68].PT :=			T#0s;			
	xMsg16[68].Prio :=			3;	
	xMsg16[68].RiskClass := 	4;			
	xMsg16[68].Reset :=			FALSE;			
	xMsg16[68]();			
				
	OUT_CU.bCustAlarm_Tripped[84] :=	xMsg16[68].Q;			
	MM2VIS.bMsg1668 :=					xMsg16[68].Q;			

					
				
	(* A1669 reserve alarm  85 *)			
	xMsg16[69].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[69].Set :=			FALSE;			
	xMsg16[69].PT :=			T#0s;			
	xMsg16[69].Prio :=			3;	
	xMsg16[69].RiskClass := 	4;			
	xMsg16[69].Reset :=			FALSE;			
	xMsg16[69]();			
				
	OUT_CU.bCustAlarm_Tripped[85] :=	xMsg16[69].Q;			
	MM2VIS.bMsg1669 :=					xMsg16[69].Q;			
				


	(* A1670 reserve alarm  86 *)			
	xMsg16[70].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[70].Set :=			FALSE;			
	xMsg16[70].PT :=			T#0s;			
	xMsg16[70].Prio :=			3;	
	xMsg16[70].RiskClass := 	4;			
	xMsg16[70].Reset :=			FALSE;			
	xMsg16[70]();			
				
	OUT_CU.bCustAlarm_Tripped[86] :=	xMsg16[70].Q;			
	MM2VIS.bMsg1670 :=					xMsg16[70].Q;			

					
				
	(* A1671 reserve alarm  87 *)			
	xMsg16[71].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[71].Set :=			FALSE;			
	xMsg16[71].PT :=			T#0s;			
	xMsg16[71].Prio :=			3;	
	xMsg16[71].RiskClass := 	4;			
	xMsg16[71].Reset :=			FALSE;			
	xMsg16[71]();			
				
	OUT_CU.bCustAlarm_Tripped[87] :=	xMsg16[71].Q;			
	MM2VIS.bMsg1671 :=					xMsg16[71].Q;			

					
				
	(* A1672 reserve alarm  88 *)			
	xMsg16[72].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[72].Set :=			FALSE;			
	xMsg16[72].PT :=			T#0s;			
	xMsg16[72].Prio :=			3;	
	xMsg16[72].RiskClass := 	4;			
	xMsg16[72].Reset :=			FALSE;			
	xMsg16[72]();			
				
	OUT_CU.bCustAlarm_Tripped[88] :=	xMsg16[72].Q;			
	MM2VIS.bMsg1672 :=					xMsg16[72].Q;			
				

					
	(* A1673 reserve alarm  89 *)			
	xMsg16[73].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[73].Set :=			FALSE;			
	xMsg16[73].PT :=			T#0s;			
	xMsg16[73].Prio :=			3;	
	xMsg16[73].RiskClass := 	4;			
	xMsg16[73].Reset :=			FALSE;			
	xMsg16[73]();			
				
	OUT_CU.bCustAlarm_Tripped[89] :=	xMsg16[73].Q;			
	MM2VIS.bMsg1673 :=					xMsg16[73].Q;			
				

					
	(* A1674 reserve alarm  90 *)			
	xMsg16[74].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[74].Set :=			FALSE;			
	xMsg16[74].PT :=			T#0s;			
	xMsg16[74].Prio :=			3;	
	xMsg16[74].RiskClass := 	4;			
	xMsg16[74].Reset :=			FALSE;			
	xMsg16[74]();			
				
	OUT_CU.bCustAlarm_Tripped[90] :=	xMsg16[74].Q;			
	MM2VIS.bMsg1674 :=					xMsg16[74].Q;			
				

					
	(* A1675 reserve alarm  91 *)			
	xMsg16[75].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[75].Set :=			FALSE;			
	xMsg16[75].PT :=			T#0s;			
	xMsg16[75].Prio :=			3;		
	xMsg16[75].RiskClass := 	4;		
	xMsg16[75].Reset :=			FALSE;			
	xMsg16[75]();			
				
	OUT_CU.bCustAlarm_Tripped[91] :=	xMsg16[75].Q;			
	MM2VIS.bMsg1675 :=					xMsg16[75].Q;			

					
				
	(* A1676 reserve alarm  92 *)			
	xMsg16[76].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[76].Set :=			FALSE;			
	xMsg16[76].PT :=			T#0s;			
	xMsg16[76].Prio :=			3;	
	xMsg16[76].RiskClass := 	4;			
	xMsg16[76].Reset :=			FALSE;			
	xMsg16[76]();			
				
	OUT_CU.bCustAlarm_Tripped[92] :=	xMsg16[76].Q;			
	MM2VIS.bMsg1676 :=					xMsg16[76].Q;			
				

					
	(* A1677 reserve alarm  93 *)			
	xMsg16[77].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[77].Set :=			FALSE;			
	xMsg16[77].PT :=			T#0s;			
	xMsg16[77].Prio :=			3;	
	xMsg16[77].RiskClass := 	4;			
	xMsg16[77].Reset :=			FALSE;			
	xMsg16[77]();			
				
	OUT_CU.bCustAlarm_Tripped[93] :=	xMsg16[77].Q;			
	MM2VIS.bMsg1677 :=					xMsg16[77].Q;			

					
				
	(* A1678 reserve alarm  94 *)			
	xMsg16[78].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[78].Set :=			FALSE;			
	xMsg16[78].PT :=			T#0s;			
	xMsg16[78].Prio :=			3;	
	xMsg16[78].RiskClass := 	4;			
	xMsg16[78].Reset :=			FALSE;			
	xMsg16[78]();			
				
	OUT_CU.bCustAlarm_Tripped[94] :=	xMsg16[78].Q;			
	MM2VIS.bMsg1678 :=					xMsg16[78].Q;			

					
				
	(* A1679 reserve alarm  95 *)			
	xMsg16[79].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[79].Set :=			FALSE;			
	xMsg16[79].PT :=			T#0s;			
	xMsg16[79].Prio :=			3;	
	xMsg16[79].RiskClass := 	4;			
	xMsg16[79].Reset :=			FALSE;			
	xMsg16[79]();			
				
	OUT_CU.bCustAlarm_Tripped[95] :=	xMsg16[79].Q;			
	MM2VIS.bMsg1679 :=					xMsg16[79].Q;			

	
					
	(* A1680 reserve alarm  96 *)			
	xMsg16[80].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[80].Set :=			FALSE;			
	xMsg16[80].PT :=			T#0s;			
	xMsg16[80].Prio :=			3;	
	xMsg16[80].RiskClass := 	4;			
	xMsg16[80].Reset :=			FALSE;			
	xMsg16[80]();			
				
	OUT_CU.bCustAlarm_Tripped[96] :=	xMsg16[80].Q;			
	MM2VIS.bMsg1680 :=					xMsg16[80].Q;			

					
				
	(* A1681 reserve alarm  97 *)			
	xMsg16[81].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[81].Set :=			FALSE;			
	xMsg16[81].PT :=			T#0s;			
	xMsg16[81].Prio :=			3;	
	xMsg16[81].RiskClass := 	4;			
	xMsg16[81].Reset :=			FALSE;			
	xMsg16[81]();			
				
	OUT_CU.bCustAlarm_Tripped[97] :=	xMsg16[81].Q;			
	MM2VIS.bMsg1681 :=					xMsg16[81].Q;			

					
				
	(* A1682 reserve alarm  98 *)			
	xMsg16[82].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[82].Set :=			FALSE;			
	xMsg16[82].PT :=			T#0s;			
	xMsg16[82].Prio :=			3;	
	xMsg16[82].RiskClass := 	4;			
	xMsg16[82].Reset :=			FALSE;			
	xMsg16[82]();			
				
	OUT_CU.bCustAlarm_Tripped[98] :=	xMsg16[82].Q;			
	MM2VIS.bMsg1682 :=					xMsg16[82].Q;			

					
				
	(* A1683 reserve alarm  99 *)			
	xMsg16[83].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[83].Set :=			FALSE;			
	xMsg16[83].PT :=			T#0s;			
	xMsg16[83].Prio :=			3;	
	xMsg16[83].RiskClass := 	4;			
	xMsg16[83].Reset :=			FALSE;			
	xMsg16[83]();			
				
	OUT_CU.bCustAlarm_Tripped[99] :=	xMsg16[83].Q;			
	MM2VIS.bMsg1683 :=					xMsg16[83].Q;			
				

					
	(* A1684 reserve alarm  100 *)			
	xMsg16[84].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[84].Set :=			FALSE;			
	xMsg16[84].PT :=			T#0s;			
	xMsg16[84].Prio :=			3;	
	xMsg16[84].RiskClass := 	4;			
	xMsg16[84].Reset :=			FALSE;			
	xMsg16[84]();			
				
	OUT_CU.bCustAlarm_Tripped[100] :=	xMsg16[84].Q;			
	MM2VIS.bMsg1684 :=					xMsg16[84].Q;			
				

					
	(* A1685 reserve alarm  101 *)			
	xMsg16[85].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[85].Set :=			FALSE;			
	xMsg16[85].PT :=			T#0s;			
	xMsg16[85].Prio :=			3;	
	xMsg16[85].RiskClass := 	4;			
	xMsg16[85].Reset :=			FALSE;			
	xMsg16[85]();			
				
	OUT_CU.bCustAlarm_Tripped[101] :=	xMsg16[85].Q;			
	MM2VIS.bMsg1685 :=					xMsg16[85].Q;			
				

					
	(* A1686 reserve alarm  102 *)			
	xMsg16[86].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[86].Set :=			FALSE;			
	xMsg16[86].PT :=			T#0s;			
	xMsg16[86].Prio :=			3;	
	xMsg16[86].RiskClass := 	4;			
	xMsg16[86].Reset :=			FALSE;			
	xMsg16[86]();			
				
	OUT_CU.bCustAlarm_Tripped[102] :=	xMsg16[86].Q;			
	MM2VIS.bMsg1686 :=					xMsg16[86].Q;			
				

					
	(* A1687 reserve alarm  103 *)			
	xMsg16[87].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[87].Set :=			FALSE;			
	xMsg16[87].PT :=			T#0s;			
	xMsg16[87].Prio :=			3;	
	xMsg16[87].RiskClass := 	4;			
	xMsg16[87].Reset :=			FALSE;			
	xMsg16[87]();			
				
	OUT_CU.bCustAlarm_Tripped[103] :=	xMsg16[87].Q;			
	MM2VIS.bMsg1687 :=					xMsg16[87].Q;			
				

					
	(* A1688 reserve alarm  104 *)			
	xMsg16[88].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[88].Set :=			FALSE;			
	xMsg16[88].PT :=			T#0s;			
	xMsg16[88].Prio :=			3;		
	xMsg16[88].RiskClass := 	4;		
	xMsg16[88].Reset :=			FALSE;			
	xMsg16[88]();			
				
	OUT_CU.bCustAlarm_Tripped[104] :=	xMsg16[88].Q;			
	MM2VIS.bMsg1688 :=					xMsg16[88].Q;			
				

					
	(* A1689 reserve alarm  105 *)			
	xMsg16[89].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[89].Set :=			FALSE;			
	xMsg16[89].PT :=			T#0s;			
	xMsg16[89].Prio :=			3;	
	xMsg16[89].RiskClass := 	4;			
	xMsg16[89].Reset :=			FALSE;			
	xMsg16[89]();			
				
	OUT_CU.bCustAlarm_Tripped[105] :=	xMsg16[89].Q;			
	MM2VIS.bMsg1689 :=					xMsg16[89].Q;			

					
				
	(* A1690 reserve alarm  106 *)			
	xMsg16[90].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[90].Set :=			FALSE;			
	xMsg16[90].PT :=			T#0s;			
	xMsg16[90].Prio :=			3;	
	xMsg16[90].RiskClass := 	4;			
	xMsg16[90].Reset :=			FALSE;			
	xMsg16[90]();			
				
	OUT_CU.bCustAlarm_Tripped[106] :=	xMsg16[90].Q;			
	MM2VIS.bMsg1690 :=					xMsg16[90].Q;			
				

					
	(* A1691 reserve alarm  107 *)			
	xMsg16[91].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[91].Set :=			FALSE;			
	xMsg16[91].PT :=			T#0s;			
	xMsg16[91].Prio :=			3;		
	xMsg16[91].RiskClass := 	4;		
	xMsg16[91].Reset :=			FALSE;			
	xMsg16[91]();			
				
	OUT_CU.bCustAlarm_Tripped[107] :=	xMsg16[91].Q;			
	MM2VIS.bMsg1691 :=					xMsg16[91].Q;			
				

					
	(* A1692 reserve alarm  108 *)			
	xMsg16[92].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[92].Set :=			FALSE;			
	xMsg16[92].PT :=			T#0s;			
	xMsg16[92].Prio :=			3;		
	xMsg16[92].RiskClass := 	4;		
	xMsg16[92].Reset :=			FALSE;			
	xMsg16[92]();			
				
	OUT_CU.bCustAlarm_Tripped[108] :=	xMsg16[92].Q;			
	MM2VIS.bMsg1692 :=					xMsg16[92].Q;			

					
				
	(* A1693 reserve alarm  109 *)			
	xMsg16[93].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[93].Set :=			FALSE;			
	xMsg16[93].PT :=			T#0s;			
	xMsg16[93].Prio :=			3;		
	xMsg16[93].RiskClass := 	4;		
	xMsg16[93].Reset :=			FALSE;			
	xMsg16[93]();			
				
	OUT_CU.bCustAlarm_Tripped[109] :=	xMsg16[93].Q;			
	MM2VIS.bMsg1693 :=					xMsg16[93].Q;			

					
				
	(* A1694 reserve alarm  110 *)			
	xMsg16[94].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[94].Set :=			FALSE;			
	xMsg16[94].PT :=			T#0s;			
	xMsg16[94].Prio :=			3;		
	xMsg16[94].RiskClass := 	4;		
	xMsg16[94].Reset :=			FALSE;			
	xMsg16[94]();			
				
	OUT_CU.bCustAlarm_Tripped[110] :=	xMsg16[94].Q;			
	MM2VIS.bMsg1694 :=					xMsg16[94].Q;			
				

					
	(* A1695 reserve alarm  111 *)			
	xMsg16[95].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[95].Set :=			FALSE;			
	xMsg16[95].PT :=			T#0s;			
	xMsg16[95].Prio :=			3;		
	xMsg16[95].RiskClass := 	4;		
	xMsg16[95].Reset :=			FALSE;			
	xMsg16[95]();			
				
	OUT_CU.bCustAlarm_Tripped[111] :=	xMsg16[95].Q;			
	MM2VIS.bMsg1695 :=					xMsg16[95].Q;			

	
					
	(* A1696 reserve alarm  112 *)			
	xMsg16[96].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[96].Set :=			FALSE;			
	xMsg16[96].PT :=			T#0s;			
	xMsg16[96].Prio :=			3;		
	xMsg16[96].RiskClass := 	4;		
	xMsg16[96].Reset :=			FALSE;			
	xMsg16[96]();			
				
	OUT_CU.bCustAlarm_Tripped[112] :=	xMsg16[96].Q;			
	MM2VIS.bMsg1696 :=					xMsg16[96].Q;			
				

					
	(* A1697 reserve alarm  113 *)			
	xMsg16[97].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[97].Set :=			FALSE;			
	xMsg16[97].PT :=			T#0s;			
	xMsg16[97].Prio :=			3;		
	xMsg16[97].RiskClass := 	4;		
	xMsg16[97].Reset :=			FALSE;			
	xMsg16[97]();			
				
	OUT_CU.bCustAlarm_Tripped[113] :=	xMsg16[97].Q;			
	MM2VIS.bMsg1697 :=					xMsg16[97].Q;			

					
				
	(* A1698 reserve alarm  114 *)			
	xMsg16[98].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[98].Set :=			FALSE;			
	xMsg16[98].PT :=			T#0s;			
	xMsg16[98].Prio :=			3;		
	xMsg16[98].RiskClass := 	4;		
	xMsg16[98].Reset :=			FALSE;			
	xMsg16[98]();			
				
	OUT_CU.bCustAlarm_Tripped[114] :=	xMsg16[98].Q;			
	MM2VIS.bMsg1698 :=					xMsg16[98].Q;			

					
				
	(* A1699 reserve alarm  115 *)			
	xMsg16[99].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[99].Set :=			FALSE;			
	xMsg16[99].PT :=			T#0s;			
	xMsg16[99].Prio :=			3;		
	xMsg16[99].RiskClass := 	4;		
	xMsg16[99].Reset :=			FALSE;			
	xMsg16[99]();			
				
	OUT_CU.bCustAlarm_Tripped[115] :=	xMsg16[99].Q;			
	MM2VIS.bMsg1699 :=					xMsg16[99].Q;			

	
	
	(* A1700 reserve alarm  116 *)			
	xMsg16[100].Enable :=		IN_CU.tPB2MM.bParaSetupOk ;			
	xMsg16[100].Set :=			FALSE;	
	xMsg16[100].PT :=			T#0s;			
	xMsg16[100].Prio :=			3;	
	xMsg16[100].RiskClass := 	4;			
	xMsg16[100].Reset :=		FALSE;			
	xMsg16[100]();			
				
	OUT_CU.bCustAlarm_Tripped[116] :=	xMsg16[100].Q;			
	MM2VIS.bMsg1700 :=					xMsg16[100].Q;			
	

	
	
	(*----------------------------------------------------------------------------*)
	(* W1193 reserve warning 1  - Use for  W1193 Mains import max with IN_CU.tCustDigIn[3].Di? *)
	xMsg1193.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1193.Set := 	FALSE;
	xMsg1193.PT := 		T#0s;
	xMsg1193.Prio := 	4;
	xMsg1193.Reset := 	FALSE;
	
	xMsg1193();
	
	OUT_CU.bCustWarn_Tripped[1] :=	xMsg1193.Q;
	MM2VIS.bMsg1193 :=				xMsg1193.Q;
	
	
	
	(* W1194 reserve warning 2 *)
	xMsg1194.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1194.Set := 	FALSE;
	xMsg1194.PT := 		T#0s;
	xMsg1194.Prio := 	4;
	xMsg1194.Reset := 	FALSE;
	
	xMsg1194();
	
	OUT_CU.bCustWarn_Tripped[2] :=	xMsg1194.Q;
	MM2VIS.bMsg1194 :=				xMsg1194.Q;
	
	
	(* W1195 reserve warning 3 *)
	xMsg1195.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1195.Set := 	FALSE;
	xMsg1195.PT := 		T#0s;
	xMsg1195.Prio := 	4;
	xMsg1195.Reset := 	FALSE;
	
	xMsg1195();
	
	OUT_CU.bCustWarn_Tripped[3] :=	xMsg1195.Q;
	MM2VIS.bMsg1195 :=				xMsg1195.Q;
	
	
	(* W1196 reserve warning 4 *)
	xMsg1196.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1196.Set := 	FALSE;
	xMsg1196.PT := 		T#0s;
	xMsg1196.Prio := 	4;
	xMsg1196.Reset := 	FALSE;
	
	xMsg1196();
	
	OUT_CU.bCustWarn_Tripped[4] :=	xMsg1196.Q;
	MM2VIS.bMsg1196 :=				xMsg1196.Q;
	
	
	(* W1197 reserve warning 5 *)
	xMsg1197.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1197.Set := 	FALSE;
	xMsg1197.PT := 		T#0s;
	xMsg1197.Prio := 	4;
	xMsg1197.Reset := 	FALSE;
	
	xMsg1197();
	
	OUT_CU.bCustWarn_Tripped[5] :=	xMsg1197.Q;
	MM2VIS.bMsg1197 :=				xMsg1197.Q;
	
	
	
	(* W1198 reserve warning 6 *)
	xMsg1198.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1198.Set := 	FALSE;
	xMsg1198.PT := 		T#0s;
	xMsg1198.Prio := 	4;
	xMsg1198.Reset := 	FALSE;
	
	xMsg1198();
	
	OUT_CU.bCustWarn_Tripped[6] :=	xMsg1198.Q;
	MM2VIS.bMsg1198 :=				xMsg1198.Q;
	
	
	
	(* W1199 reserve warning 7 *)
	xMsg1199.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1199.Set := 	FALSE;
	xMsg1199.PT := 		T#0s;
	xMsg1199.Prio := 	4;
	xMsg1199.Reset := 	FALSE;
	
	xMsg1199();
	
	OUT_CU.bCustWarn_Tripped[7] :=	xMsg1199.Q;
	MM2VIS.bMsg1199 :=				xMsg1199.Q;
	
	
	
	(* W1200 reserve warning 8 *)
	xMsg1200.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1200.Set := 	FALSE;
	xMsg1200.PT := 		T#0s;
	xMsg1200.Prio := 	4;
	xMsg1200.Reset := 	FALSE;
	
	xMsg1200();
	
	OUT_CU.bCustWarn_Tripped[8] :=	xMsg1200.Q;
	MM2VIS.bMsg1200 :=				xMsg1200.Q;
	
	
	
	(* W1201 reserve warning 9 *)
	xMsg1201.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1201.Set := 	FALSE;
	xMsg1201.PT := 		T#0s;
	xMsg1201.Prio := 	4;
	xMsg1201.Reset := 	FALSE;
	
	xMsg1201();
	
	OUT_CU.bCustWarn_Tripped[9] :=	xMsg1201.Q;
	MM2VIS.bMsg1201 :=				xMsg1201.Q;
	
	
	
	(* W1202 reserve warning 10 *)
	xMsg1202.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1202.Set := 	FALSE;
	xMsg1202.PT := 		T#0s;
	xMsg1202.Prio := 	4;
	xMsg1202.Reset := 	FALSE;
	
	xMsg1202();
	
	OUT_CU.bCustWarn_Tripped[10] :=	xMsg1202.Q;
	MM2VIS.bMsg1202 :=				xMsg1202.Q;
	
	
	(* W1203 reserve warning 11 *)
	xMsg1203.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1203.Set := 	FALSE;
	xMsg1203.PT := 		T#0s;
	xMsg1203.Prio := 	4;
	xMsg1203.Reset := 	FALSE;
	
	xMsg1203();
	
	OUT_CU.bCustWarn_Tripped[11] :=	xMsg1203.Q;
	MM2VIS.bMsg1203 :=				xMsg1203.Q;
	
	
	
	(* W1204 reserve warning 12 *)
	xMsg1204.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1204.Set := 	FALSE;
	xMsg1204.PT := 		T#0s;
	xMsg1204.Prio := 	4;
	xMsg1204.Reset := 	FALSE;
	
	xMsg1204();
	
	OUT_CU.bCustWarn_Tripped[12] :=	xMsg1204.Q;
	MM2VIS.bMsg1204 :=				xMsg1204.Q;
	
	
	(* W1205 reserve warning 13 *)
	xMsg1205.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1205.Set := 	FALSE;
	xMsg1205.PT := 		T#0s;
	xMsg1205.Prio := 	4;
	xMsg1205.Reset := 	FALSE;
	
	xMsg1205();
	
	OUT_CU.bCustWarn_Tripped[13] :=	xMsg1205.Q;
	MM2VIS.bMsg1205 :=				xMsg1205.Q;
	
	
	
	(* W1206 reserve warning 14 *)
	xMsg1206.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1206.Set := 	FALSE;
	xMsg1206.PT := 		T#0s;
	xMsg1206.Prio := 	4;
	xMsg1206.Reset := 	FALSE;
	
	xMsg1206();
	
	OUT_CU.bCustWarn_Tripped[14] :=	xMsg1206.Q;
	MM2VIS.bMsg1206 :=				xMsg1206.Q;
	
	
	
	(* W1207 reserve warning 15 *)
	xMsg1207.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1207.Set := 	FALSE;
	xMsg1207.PT := 		T#0s;
	xMsg1207.Prio := 	4;
	xMsg1207.Reset := 	FALSE;
	
	xMsg1207();
	
	OUT_CU.bCustWarn_Tripped[15] :=	xMsg1207.Q;
	MM2VIS.bMsg1207 :=				xMsg1207.Q;
		
		
	
	(* W1208 reserve warning 16 *)
	xMsg1208.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg1208.Set := 	FALSE;
	xMsg1208.PT := 		T#0s;
	xMsg1208.Prio := 	4;
	xMsg1208.Reset := 	FALSE;
	
	xMsg1208();
	
	OUT_CU.bCustWarn_Tripped[16] :=	xMsg1208.Q;
	MM2VIS.bMsg1208 :=				xMsg1208.Q;
	
	
	
	(*----------------------------------------------------------------------------*)
	(* W2087 reserve warning 17 *)
	(*
	ALM[2087].ENABLE := 	IN_CU.tPB2MM.bParaSetupOk ;
	ALM[2087].SET := 		FALSE;
	ALM[2087].PTON := 		T#0s;
	ALM[2087].PRIO := 		4;
	bPv			 := 		MM2VIS.bMsg2087;
	*)
	
	
	
	
	(* W2087 reserve warning 17 *)
	xMsg2087.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2087.Set := 	FALSE;
	xMsg2087.PT := 		T#0s;
	xMsg2087.Prio := 	4;
	xMsg2087.Reset := 	FALSE;
	
	xMsg2087();
	
	OUT_CU.bMsg2087 :=	xMsg2087.Q;																	(*fix Hasenburger*)
	MM2VIS.bMsg2087 :=	xMsg2087.Q;
	
	

	(* W2088 reserve warning 18 *)
	xMsg2088.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2088.Set := 	FALSE;
	xMsg2088.PT := 		T#0s;
	xMsg2088.Prio := 	4;
	xMsg2088.Reset := 	FALSE;
	
	xMsg2088();
	
	OUT_CU.bMsg2088 :=	xMsg2088.Q;
	MM2VIS.bMsg2088 :=	xMsg2088.Q;	
	
	
	
	(* W2089 reserve warning 19 *)
	xMsg2089.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2089.Set := 	FALSE;
	xMsg2089.PT := 		T#0s;
	xMsg2089.Prio := 	4;
	xMsg2089.Reset := 	FALSE;
	
	xMsg2089();
	
	OUT_CU.bMsg2089 :=	xMsg2089.Q;
	MM2VIS.bMsg2089 :=	xMsg2089.Q;	
	
	
	
	(* W2090 reserve warning 20 *)
	xMsg2090.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2090.Set := 	FALSE;
	xMsg2090.PT := 		T#0s;
	xMsg2090.Prio := 	4;
	xMsg2090.Reset := 	FALSE;
	
	xMsg2090();
	
	OUT_CU.bMsg2090 :=	xMsg2090.Q;
	MM2VIS.bMsg2090 :=	xMsg2090.Q;
	
	
	
	
	(* W2091 reserve warning 21 *)
	xMsg2091.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2091.Set := 	FALSE;
	xMsg2091.PT := 		T#0s;
	xMsg2091.Prio := 	4;
	xMsg2091.Reset := 	FALSE;
	
	xMsg2091();
	
	OUT_CU.bMsg2091 :=	xMsg2091.Q;
	MM2VIS.bMsg2091 :=	xMsg2091.Q;
	
	
	
	
	(* W2092 reserve warning 22 *)
	xMsg2092.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2092.Set := 	FALSE;
	xMsg2092.PT := 		T#0s;
	xMsg2092.Prio := 	4;
	xMsg2092.Reset := 	FALSE;
	
	xMsg2092();
	
	OUT_CU.bMsg2092 :=	xMsg2092.Q;
	MM2VIS.bMsg2092 :=	xMsg2092.Q;
	
	
	
	
	(* W2093 reserve warning 23 *)
	xMsg2093.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2093.Set := 	FALSE;
	xMsg2093.PT := 		T#0s;
	xMsg2093.Prio := 	4;
	xMsg2093.Reset := 	FALSE;
	
	xMsg2093();
	
	OUT_CU.bMsg2093 :=	xMsg2093.Q;
	MM2VIS.bMsg2093 :=	xMsg2093.Q;
	
	
	
	
	(* W2094 reserve warning 24 *)
	xMsg2094.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2094.Set := 	FALSE;
	xMsg2094.PT := 		T#0s;
	xMsg2094.Prio := 	4;
	xMsg2094.Reset := 	FALSE;
	
	xMsg2094();
	
	OUT_CU.bMsg2094 :=	xMsg2094.Q;
	MM2VIS.bMsg2094 :=	xMsg2094.Q;
	
	
	
	
	(* W2095 reserve warning 25 *)
	xMsg2095.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2095.Set := 	FALSE;
	xMsg2095.PT := 		T#0s;
	xMsg2095.Prio := 	4;
	xMsg2095.Reset := 	FALSE;
	
	xMsg2095();
	
	OUT_CU.bMsg2095 :=	xMsg2095.Q;
	MM2VIS.bMsg2095 :=	xMsg2095.Q;
	
	
	
	
	(* W2096 reserve warning 26 *)
	xMsg2096.Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg2096.Set := 	FALSE;
	xMsg2096.PT := 		T#0s;
	xMsg2096.Prio := 	4;
	xMsg2096.Reset := 	FALSE;
	
	xMsg2096();
	
	OUT_CU.bMsg2096 :=	xMsg2096.Q;
	MM2VIS.bMsg2096 :=	xMsg2096.Q;


	(* W1701 to W1800:  reserve warnings 27 - 126 *)
	FOR cnt := 01 TO 100 DO
		(*set standard message options*)
		xMsg17[cnt].Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
		xMsg17[cnt].PT := 		T#1s;
		xMsg17[cnt].Prio := 	4;
		xMsg17[cnt].Reset := 	FALSE;

		(*please do not use case structure, this causes troubles with further automatisation*)
		(*set possible exceptions for W1701 here*)
		xMsg17[01].PT := 		T#2s;		(*e.g. delay*)
		
		(*set possible exceptions for W1702 here*)
		xMsg17[02].PT := 		T#2s;		(*e.g. delay*)
			
		(* ..continue as needed.. *)
			
		(*set possible exceptions for W1800 here*)
		xMsg17[100].Reset := 	TRUE;		(*e.g. autoreset*)
	END_FOR
	
	xMsg17[01].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 27 here*)
	xMsg17[02].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 28 here*)
	xMsg17[03].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 29 here*)
	xMsg17[04].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 30 here*)
	xMsg17[05].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 31 here*)
	xMsg17[06].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 32 here*)
	xMsg17[07].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 33 here*)
	xMsg17[08].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 34 here*)
	xMsg17[09].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 35 here*)
	xMsg17[10].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 36 here*)
				
	xMsg17[11].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 37 here*)
	xMsg17[12].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 38 here*)
	xMsg17[13].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 39 here*)
	xMsg17[14].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 40 here*)
	xMsg17[15].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 41 here*)
	xMsg17[16].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 42 here*)
	xMsg17[17].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 43 here*)
	xMsg17[18].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 44 here*)
	xMsg17[19].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 45 here*)
	xMsg17[20].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 46 here*)
				
				
	xMsg17[21].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 47 here*)
	xMsg17[22].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 48 here*)
	xMsg17[23].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 49 here*)
	xMsg17[24].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 50 here*)
	xMsg17[25].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 51 here*)
	xMsg17[26].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 52 here*)
	xMsg17[27].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 53 here*)
	xMsg17[28].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 54 here*)
	xMsg17[29].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 55 here*)
	xMsg17[30].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 56 here*)
				
	xMsg17[31].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 57 here*)
	xMsg17[32].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 58 here*)
	xMsg17[33].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 59 here*)
	xMsg17[34].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 60 here*)
	xMsg17[35].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 61 here*)
	xMsg17[36].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 62 here*)
	xMsg17[37].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 63 here*)
	xMsg17[38].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 64 here*)
	xMsg17[39].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 65 here*)
	xMsg17[40].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 66 here*)
				
				
	xMsg17[41].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 67 here*)
	xMsg17[42].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 68 here*)
	xMsg17[43].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 69 here*)
	xMsg17[44].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 70 here*)
	xMsg17[45].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 71 here*)
	xMsg17[46].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 72 here*)
	xMsg17[47].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 73 here*)
	xMsg17[48].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 74 here*)
	xMsg17[49].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 75 here*)
	xMsg17[50].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 76 here*)
				
	xMsg17[51].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 77 here*)
	xMsg17[52].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 78 here*)
	xMsg17[53].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 79 here*)
	xMsg17[54].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 80 here*)
	xMsg17[55].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 81 here*)
	xMsg17[56].Set := 	bDumpRadiator_WarningMsg[0];		(* <-connect alarm condition for reserve warning 82 here - Dump Radiator 1 Clutch Warning *)
	xMsg17[57].Set := 	bDumpRadiator_WarningMsg[1];	 	(* <-connect alarm condition for reserve warning 83 here - Dump Radiator 2 Clutch Warning *)
	xMsg17[58].Set := 	bDumpRadiator_WarningMsg[2];		(* <-connect alarm condition for reserve warning 84 here - Dump Radiator 3 Clutch Warning *)
	xMsg17[59].Set := 	bDumpRadiator_WarningMsg[3];		(* <-connect alarm condition for reserve warning 85 here - Dump Radiator 4 Clutch Warning *)
	xMsg17[60].Set := 	bAirInFan_WarningMsg[0];		(* <-connect alarm condition for reserve warning 86 here - Air Inlet Fan 1 Clutch Warning *)
				
				
	xMsg17[61].Set := 	bAirInFan_WarningMsg[1];		(* <-connect alarm condition for reserve warning 87 here - Air Inlet Fan 2 Clutch Warning *)
	xMsg17[62].Set := 	bAirInFan_WarningMsg[2];	  	(* <-connect alarm condition for reserve warning 88 here - Air Inlet Fan 3 Clutch Warning *)
	xMsg17[63].Set := 	bAirInFan_WarningMsg[3];		(* <-connect alarm condition for reserve warning 89 here - Air Inlet Fan 4 Clutch Warning *)
	xMsg17[64].Set := 	bDumpRadiator_CANWarningMsg;		(* <-connect alarm condition for reserve warning 90 here - Dump Radiator Clutch CAN communication not working*)
	xMsg17[65].Set := 	bAirInFan_CANWarningMsg;		(* <-connect alarm condition for reserve warning 91 here - Airet Fan Clutch CAN communication not working *)
	xMsg17[66].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 92 here*)
	xMsg17[67].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 93 here*)
	xMsg17[68].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 94 here*)
	xMsg17[69].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 95 here*)
	xMsg17[70].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 96 here*)
				
	xMsg17[71].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 97 here*)
	xMsg17[72].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 98 here*)
	xMsg17[73].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 99 here*)
	xMsg17[74].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 100 here*)
	xMsg17[75].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 101 here*)
	xMsg17[76].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 102 here*)
	xMsg17[77].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 103 here*)
	xMsg17[78].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 104 here*)
	xMsg17[79].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 105 here*)
	xMsg17[80].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 106 here*)
				
				
	xMsg17[81].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 107 here*)
	xMsg17[82].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 108 here*)
	xMsg17[83].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 109 here*)
	xMsg17[84].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 110 here*)
	xMsg17[85].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 111 here*)
	xMsg17[86].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 112 here*)
	xMsg17[87].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 113 here*)
	xMsg17[88].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 114 here*)
	xMsg17[89].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 115 here*)
	xMsg17[90].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 116 here*)
				
	xMsg17[91].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 117 here*)
	xMsg17[92].Set := 	FALSE;	  	(* <-connect alarm condition for reserve warning 118 here*)
	xMsg17[93].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 119 here*)
	xMsg17[94].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 120 here*)
	xMsg17[95].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 121 here*)
	xMsg17[96].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 122 here*)
	xMsg17[97].Set := 	FALSE;	 	(* <-connect alarm condition for reserve warning 123 here*)
	xMsg17[98].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 124 here*)
	xMsg17[99].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 125 here*)
	xMsg17[100].Set := 	FALSE;		(* <-connect alarm condition for reserve warning 126 here*)
	

	FOR cnt := 01 TO 100 DO
		xMsg17[cnt];	(*function call*)
	END_FOR	
	
	(* W8701 to W8799:  reserve warnings 127 - 225 *) (*import HMI Extension *)
	FOR cnt := 01 TO 99 DO
		(*set standard message options*)
		xMsg87[cnt].Enable := 	IN_CU.tPB2MM.bParaSetupOk ;
		xMsg87[cnt].PT := 		T#1s;
		xMsg87[cnt].Prio := 	4;
		xMsg87[cnt].Reset := 	FALSE;
		xMsg87[cnt]();	(*function call*)
		
		(*please do not use case structure, this causes troubles with further automatisation*)
		(*set possible exceptions for W8701 here*)
		xMsg87[01].PT := 		T#2s;		(*e.g. delay*)
			
		(* ..continue as needed.. *)
			
		(*set possible exceptions for W8799 here*)
		xMsg87[99].Reset := 	FALSE; //TRUE;		(*e.g. autoreset*)
	END_FOR	
	
	xMsg87[01].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 127 here*)	 (*import HMI Extension *)
	xMsg87[02].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 128 here*)	 (*import HMI Extension *)
	xMsg87[03].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 129 here*)	 (*import HMI Extension *)
	xMsg87[04].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 130 here*)	 (*import HMI Extension *)
	xMsg87[05].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 131 here*)	 (*import HMI Extension *)
	xMsg87[06].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 132 here*)	 (*import HMI Extension *)
	xMsg87[07].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 133 here*)	 (*import HMI Extension *)
	xMsg87[08].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 134 here*)	 (*import HMI Extension *)
	xMsg87[09].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 135 here*)	 (*import HMI Extension *)
	xMsg87[10].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 136 here*)	 (*import HMI Extension *)
	 
	xMsg87[11].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 137 here*)	 (*import HMI Extension *)
	xMsg87[12].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 138 here*)	 (*import HMI Extension *)
	xMsg87[13].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 139 here*)	 (*import HMI Extension *)
	xMsg87[14].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 140 here*)	 (*import HMI Extension *)
	xMsg87[15].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 141 here*)	 (*import HMI Extension *)
	xMsg87[16].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 142 here*)	 (*import HMI Extension *)
	xMsg87[17].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 143 here*)	 (*import HMI Extension *)
	xMsg87[18].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 144 here*)	 (*import HMI Extension *)
	xMsg87[19].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 145 here*)	 (*import HMI Extension *)
	xMsg87[20].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 146 here*)	 (*import HMI Extension *)
	 
	xMsg87[21].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 147 here*)	 (*import HMI Extension *)
	xMsg87[22].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 148 here*)	 (*import HMI Extension *)
	xMsg87[23].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 149 here*)	 (*import HMI Extension *)
	xMsg87[24].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 150 here*)	 (*import HMI Extension *)
	xMsg87[25].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 151 here*)	 (*import HMI Extension *)
	xMsg87[26].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 152 here*)	 (*import HMI Extension *)
	xMsg87[27].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 153 here*)	 (*import HMI Extension *)
	xMsg87[28].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 154 here*)	 (*import HMI Extension *)
	xMsg87[29].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 155 here*)	 (*import HMI Extension *)
	xMsg87[30].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 156 here*)	 (*import HMI Extension *)
	 
	xMsg87[31].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 157 here*)	 (*import HMI Extension *)
	xMsg87[32].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 158 here*)	 (*import HMI Extension *)
	xMsg87[33].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 159 here*)	 (*import HMI Extension *)
	xMsg87[34].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 160 here*)	 (*import HMI Extension *)
	xMsg87[35].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 161 here*)	 (*import HMI Extension *)
	xMsg87[36].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 162 here*)	 (*import HMI Extension *)
	xMsg87[37].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 163 here*)	 (*import HMI Extension *)
	xMsg87[38].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 164 here*)	 (*import HMI Extension *)
	xMsg87[39].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 165 here*)	 (*import HMI Extension *)
	xMsg87[40].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 166 here*)	 (*import HMI Extension *)
	 
	xMsg87[41].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 167 here*)	 (*import HMI Extension *)
	xMsg87[42].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 168 here*)	 (*import HMI Extension *)
	xMsg87[43].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 169 here*)	 (*import HMI Extension *)
	xMsg87[44].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 170 here*)	 (*import HMI Extension *)
	xMsg87[45].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 171 here*)	 (*import HMI Extension *)
	xMsg87[46].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 172 here*)	 (*import HMI Extension *)
	xMsg87[47].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 173 here*)	 (*import HMI Extension *)
	xMsg87[48].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 174 here*)	 (*import HMI Extension *)
	xMsg87[49].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 175 here*)	 (*import HMI Extension *)
	xMsg87[50].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 176 here*)	 (*import HMI Extension *)
 
	xMsg87[51].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 177 here*)	 (*import HMI Extension *)
	xMsg87[52].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 178 here*)	 (*import HMI Extension *)
	xMsg87[53].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 179 here*)	 (*import HMI Extension *)
	xMsg87[54].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 180 here*)	 (*import HMI Extension *)
	xMsg87[55].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 181 here*)	 (*import HMI Extension *)
	xMsg87[56].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 182 here*)	 (*import HMI Extension *)
	xMsg87[57].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 183 here*)	 (*import HMI Extension *)
	xMsg87[58].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 184 here*)	 (*import HMI Extension *)
	xMsg87[59].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 185 here*)	 (*import HMI Extension *)
	xMsg87[60].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 186 here*)	 (*import HMI Extension *)
 
	xMsg87[61].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 187 here*)	 (*import HMI Extension *)
	xMsg87[62].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 188 here*)	 (*import HMI Extension *)
	xMsg87[63].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 189 here*)	 (*import HMI Extension *)
	xMsg87[64].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 190 here*)	 (*import HMI Extension *)
	xMsg87[65].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 191 here*)	 (*import HMI Extension *)
	xMsg87[66].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 192 here*)	 (*import HMI Extension *)
	xMsg87[67].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 193 here*)	 (*import HMI Extension *)
	xMsg87[68].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 194 here*)	 (*import HMI Extension *)
	xMsg87[69].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 195 here*)	 (*import HMI Extension *)
	xMsg87[70].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 196 here*)	 (*import HMI Extension *)
 
	xMsg87[71].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 197 here*)	 (*import HMI Extension *)
	xMsg87[72].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 198 here*)	 (*import HMI Extension *)
	xMsg87[73].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 199 here*)	 (*import HMI Extension *)
	xMsg87[74].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 200 here*)	 (*import HMI Extension *)
	xMsg87[75].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 201 here*)	 (*import HMI Extension *)
	xMsg87[76].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 202 here*)	 (*import HMI Extension *)
	xMsg87[77].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 203 here*)	 (*import HMI Extension *)
	xMsg87[78].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 204 here*)	 (*import HMI Extension *)
	xMsg87[79].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 205 here*)	 (*import HMI Extension *)
	xMsg87[80].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 206 here*)	 (*import HMI Extension *)
 
	xMsg87[81].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 207 here*)	 (*import HMI Extension *)
	xMsg87[82].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 208 here*)	 (*import HMI Extension *)
	xMsg87[83].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 209 here*)	 (*import HMI Extension *)
	xMsg87[84].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 210 here*)	 (*import HMI Extension *)
	xMsg87[85].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 211 here*)	 (*import HMI Extension *)
	xMsg87[86].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 212 here*)	 (*import HMI Extension *)
	xMsg87[87].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 213 here*)	 (*import HMI Extension *)
	xMsg87[88].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 214 here*)	 (*import HMI Extension *)
	xMsg87[89].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 215 here*)	 (*import HMI Extension *)
	xMsg87[90].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 216 here*)	 (*import HMI Extension *)
 
	xMsg87[91].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 217 here*)	 (*import HMI Extension *)
	xMsg87[92].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 218 here*)	 (*import HMI Extension *)
	xMsg87[93].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 219 here*)	 (*import HMI Extension *)
	xMsg87[94].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 220 here*)	 (*import HMI Extension *)
	xMsg87[95].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 221 here*)	 (*import HMI Extension *)
	xMsg87[96].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 222 here*)	 (*import HMI Extension *)
	xMsg87[97].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 223 here*)	 (*import HMI Extension *)
	xMsg87[98].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 224 here*)	 (*import HMI Extension *)
	xMsg87[99].Set :=	FALSE;		(* <-connect alarm condition for reserve warning 225 here*)	 (*import HMI Extension *)
//OLD do not use line	xMsg87[100].

	
	(*********************************************************)
	(*V4.04.0 09.11.2016	zengerer	mains power controller messages *)


	(* A2302 mains export power limit: Shut down engine, if NEGATIVE Mains Import (= power export to the grid) is exceeding (<) the allowed limit (-Limit value)  *)
	xMsg2302.Enable := bMsg2302_Enable AND IN_CU.tPB2MM.bParaSetupOk;
	xMsg2302.Set 	:= bMsg2302_Set;	
	xMsg2302.PT 	:= T#5s;
	xMsg2302.Prio 	:= 3;
	IF xMsg2302.Set THEN iReset_Msg2302 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg2302 := LIMIT(0, iReset_Msg2302 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg2302.Reset := FALSE; 			// := iReset_Msg2302 < 1;		(* autoreset removed as default; activate by connecting iReset_Msg2302 here only on customer demand *)
	
	xMsg2302();

	OUT_CU.bMsg2302 :=	xMsg2302.Q;
	MM2VIS.bMsg2302 :=	xMsg2302.Q;
	
	
	(* A2303 mains import controller limit 2  ??? Why shut down the engine, if too few power is available  ???	*)
	xMsg2303.Enable := bMsg2303_Enable AND IN_CU.tPB2MM.bParaSetupOk;
	xMsg2303.Set 	:= bMsg2303_Set;	
	xMsg2303.PT 	:= T#5s;
	xMsg2303.Prio 	:= 3;
	IF xMsg2303.Set THEN iReset_Msg2303 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg2303 := LIMIT(0, iReset_Msg2303 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg2303.Reset := 	FALSE; 			// := iReset_Msg2303 < 1;	(* autoreset removed as default; activate only on customer demand. *) 	
	
	xMsg2303();
	
	OUT_CU.bMsg2303 :=	xMsg2303.Q;
	MM2VIS.bMsg2303 :=	xMsg2303.Q;
	

	
	(* W2415 mains import controller: Messsignalstörung Netzbezugs- Sollwert 	*)
	xMsg2415.Enable := bMsg2415_Enable AND IN_CU.tPB2MM.bParaSetupOk;
	xMsg2415.Set 	:= bMsg2415_Set;
	xMsg2415.PT 	:= T#1s;
	xMsg2415.Prio 	:= 4;
	xMsg2415.Reset 	:= FALSE;
	
	xMsg2415();

	OUT_CU.bMsg2415 :=	xMsg2415.Q;
	MM2VIS.bMsg2415 :=	xMsg2415.Q;
	
	(* W2416 mains import controller: Messsignalstörung Netzbezugs- Istwert	*)
//	Para.bP_Mns_AnaIn_Enable := NOT Para.bP_Mns_MMU_Enable	;						(*necessary, because bP_Mns_AnaIn_Enable is not a parameter on VIS anymore*)

	xMsg2416.Enable := bMsg2416_Enable AND IN_CU.tPB2MM.bParaSetupOk;
	xMsg2416.Set 	:= bMsg2416_Set;
//	NOT IN_CU.tP_Mns_AnaIn.GoodQual;
	xMsg2416.PT		:= T#1s;
	xMsg2416.Prio 	:= 4;
	xMsg2416.Reset 	:= FALSE;
	
	xMsg2416();

	OUT_CU.bMsg2416 :=	xMsg2416.Q;
	MM2VIS.bMsg2416 :=	xMsg2416.Q;
		
	
	
	(* W2417 mains export power limit: Warning, if NEGATIVE Mains Import (= power export to the grid) is exceeding (<) the allowed limit (-Limit value)  *)
	xMsg2417.Enable := bMsg2417_Enable AND IN_CU.tPB2MM.bParaSetupOk;
	xMsg2417.Set 	:= bMsg2417_Set; 	
	xMsg2417.PT 	:= T#1s;
	xMsg2417.Prio 	:= 4;
	xMsg2417.Reset 	:= FALSE;	
	xMsg2417();

	OUT_CU.bMsg2417 :=	xMsg2417.Q;
	MM2VIS.bMsg2417 :=	xMsg2417.Q;

	(* W2418  mains import controller limit 2:  Warning if positive Mains Import (= power drawn from the grid) is exceeding (>) the allowed limit (+Limit value)*)
	xMsg2418.Enable := bMsg2418_Enable AND IN_CU.tPB2MM.bParaSetupOk;	
	xMsg2418.Set 	:= bMsg2418_Set;
	xMsg2418.PT 	:= T#1s;
	xMsg2418.Prio 	:= 4;
	xMsg2418.Reset 	:= FALSE;
	
	xMsg2418();

	OUT_CU.bMsg2418 :=	xMsg2418.Q;
	MM2VIS.bMsg2418 :=	xMsg2418.Q;

	(* B2419 operating message mns import ctr: Engine Demand Off (ex.Warning W2419) *) 
	TP_EngDSS_Mains_Off(IN := NOT(OUT_CU.bEngDSS_Mains), PT := T#11s);
	xMsg2419.Enable := 	Para.bCtr_Mns_Enable;
	xMsg2419.Set := 	TP_EngDSS_Mains_Off.Q;
	xMsg2419.PT := 		T#1s;
	xMsg2419.Prio := 	5;
	IF xMsg2419.Set THEN iReset_Msg2419 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg2419 := LIMIT(0, iReset_Msg2419 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg2419.Reset := 	iReset_Msg2419 < 1;		//.Reset := TRUE;
//	
	xMsg2419();
//
	OUT_CU.bMsg2419 :=		xMsg2419.Q;	//  := TP_EngDSS_Mains_Off.Q;	// 	
	MM2VIS.bMsg2419 :=		xMsg2419.Q;	//	:= TP_EngDSS_Mains_Off.Q;	// 	

	(* B2420 operating message mns import ctr: Engine Demand On (ex. warning W2420)*) 
	TP_EngDSS_Mains(IN := OUT_CU.bEngDSS_Mains, PT := T#11s);
	xMsg2420.Enable := 	Para.bCtr_Mns_Enable;
	xMsg2420.Set := 	TP_EngDSS_Mains.Q;
	xMsg2420.PT := 		T#1s;
	xMsg2420.Prio := 	5;

	IF xMsg2420.Set THEN iReset_Msg2420 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg2420 := LIMIT(0, iReset_Msg2420 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg2420.Reset := 	iReset_Msg2420 < 1;		//.Reset := TRUE;
//	
	xMsg2420();
//
	OUT_CU.bMsg2420 :=		xMsg2420.Q;		// := TP_EngDSS_Mains.Q;		// 	
	MM2VIS.bMsg2420 :=		xMsg2420.Q;		// := TP_EngDSS_Mains.Q;		// 	



(*  Debug Info only (may be removed in tested versions)  *)
	bCtr_Mns_Options_2	:= Para.iCtr_Mns_Options.2;
	bCtr_Mns_Options_3	:= Para.iCtr_Mns_Options.3;
	bCtr_Mns_Options_4	:= Para.iCtr_Mns_Options.4;
	bCtr_Mns_Options_5	:= Para.iCtr_Mns_Options.5;
	bCtr_Mns_Options_6	:= Para.iCtr_Mns_Options.6;
	bCtr_Mns_Options_7	:= Para.iCtr_Mns_Options.7;
	bCtr_Mns_Options_8	:= Para.iCtr_Mns_Options.8;			bCtr_Mns_Options_1;	bCtr_Mns_Options_9;	bCtr_Mns_Options_0;
	R_TRIG_Options(CLK := (VIS2MM.tCtr_Mns_In.Tune_PI OR VIS2MM.tCtr_Mns_In.Tune_PID) AND VIS2MM.tCtr_Mns_In.Tune_quality>0);
	IF R_TRIG_Options.Q AND IN_CU.iIdx_OMSS=0 THEN Para.iCtr_Mns_Options := Para.iCtr_Mns_Options + BOOL_TO_INT(VIS2MM.tCtr_Mns_In.Tune_PI) * VIS2MM.tCtr_Mns_In.Tune_quality - BOOL_TO_INT(VIS2MM.tCtr_Mns_In.Tune_PID) * VIS2MM.tCtr_Mns_In.Tune_quality ; END_IF			(*Debug options*)

	(*********************************************************)
	
		(* W3565 Messsignalstörung Generator Leistungssollwert *)
		xMsg3565.Enable := 	(Para.rI_P_Set_ExtAI_NormScalMin >= 0.004);  (* if signal check is ok AND scaling parameter Min has to be set >4mA*) 	(*old V3.40: monitoring active, if parameter p_soll_i1 is setted to 4mA or higher *)
		xMsg3565.Set := 	NOT IN_CU.tP_Set_ExtAI_Norm.GoodQual;  
		xMsg3565.PT := 		T#2s;
		xMsg3565.Prio := 	4;
		xMsg3565.Reset := 	FALSE;
	
		xMsg3565();
	
		MM2VIS.bMsg3565 :=	xMsg3565.Q;
		OUT_CU.bMsg3565 :=	xMsg3565.Q;	

		(* W9285 Measuring signal failure external voltage setpoint *)
		MM2VIS.bMsg9285 :=	IN_CU.bMsg[9285];

		(* W9286 Measuring signal failure external speed setpoint (Isolated operation) *)
		xMsg9286.Enable := 	(Para.rI_N_Set_ExtAI_NormScalMin >= 0.004) AND IN_CU.tN_Set_ExtAI_Norm.Exist AND IN_CU.tPB2MM.bParaSetupOk;
		xMsg9286.Set := 	NOT IN_CU.tN_Set_ExtAI_Norm.GoodQual;  
		xMsg9286.PT := 		T#1s;
		xMsg9286.Prio := 	4;
		xMsg9286.Reset := 	FALSE;
	
		xMsg9286();
	
		MM2VIS.bMsg9286 :=	xMsg9286.Q;
		OUT_CU.bMsg9286 :=	xMsg9286.Q;	
		
		(* W9287 Failure external speed / voltage controller *)
		xMsg9287.Enable := 	IN_CU.tExtCtrOk.GoodQual AND IN_CU.tPB2MM.bParaSetupOk;
		xMsg9287.Set := 	NOT IN_CU.tExtCtrOk.Di;  
		xMsg9287.PT := 		T#1s;
		xMsg9287.Prio := 	4;
		xMsg9287.Reset := 	FALSE;
	
		xMsg9287();
	
		MM2VIS.bMsg9287 :=	xMsg9287.Q;
		OUT_CU.bMsg9287 :=	xMsg9287.Q;	
				
	(*----------------------------------------------------------------------------*)
	(* OPERATING MESSAGES: connect activation bits here customized 				  *)
	(*----------------------------------------------------------------------------*)
	
		OUT_CU.bMsg3232;// :=		FALSE;	(* B3232 reserve operating message 1 *)
		OUT_CU.bMsg3233;// :=		FALSE;	(* B3233 reserve operating message 2 *)
		OUT_CU.bMsg3234 ;// :=		FALSE;	(* B3234 reserve operating message 3 *)
		OUT_CU.bMsg3235 ;// :=		FALSE;	(* B3235 reserve operating message 4 *)
		OUT_CU.bMsg3236 ;// := 		FALSE;	(* B3236 reserve operating message 5 *)
		OUT_CU.bMsg3237 ;// := 		FALSE;	(* B3237 reserve operating message 6 *)
	
		OUT_CU.bMsg3250 ;// := 		FALSE;	(* B3250 reserve operating message 7 *)
		OUT_CU.bMsg3251 ;// := 		FALSE;	(* B3251 reserve operating message 8 *)
	
	
		OUT_CU.bMsg3601 ;// := 		FALSE;	(* B3601 reserve operating message 9 *)
		OUT_CU.bMsg3602 ;// := 		FALSE;	(* B3602 reserve operating message 10 *)
		OUT_CU.bMsg3603 ;// := 		FALSE;	(* B3603 reserve operating message 11 *)
		OUT_CU.bMsg3604 ;// := 		FALSE;	(* B3604 reserve operating message 12 *)
		OUT_CU.bMsg3605 ;// := 		FALSE;	(* B3605 reserve operating message 13 *)
		OUT_CU.bMsg3606 ;// := 		FALSE;	(* B3606 reserve operating message 14 *)
		OUT_CU.bMsg3607 ;// := 		FALSE;	(* B3607 reserve operating message 15 *)
		OUT_CU.bMsg3608 ;// := 		FALSE;	(* B3608 reserve operating message 16 *)
		OUT_CU.bMsg3609 ;// := 		FALSE;	(* B3609 reserve operating message 17 *)
		OUT_CU.bMsg3610 ;// := 		FALSE;	(* B3610 reserve operating message 18 *)

		OUT_CU.bMsg3611 ;// := 		FALSE;	(* B3611 reserve operating message 19 *)
		OUT_CU.bMsg3612 ;// := 		FALSE;	(*  	 reserve operating message 20 *)
		OUT_CU.bMsg3613 ;// := 		FALSE;	(* 		 reserve operating message 21 *)
		OUT_CU.bMsg3614 ;// := 		FALSE;	(* 		 reserve operating message 22 *)
		OUT_CU.bMsg3615 ;// := 		FALSE;	(* 		 reserve operating message 23 *)
		OUT_CU.bMsg3616 ;// := 		FALSE;	(* 		 reserve operating message 24 *)
		OUT_CU.bMsg3617 ;// := 		FALSE;	(* 		 reserve operating message 25 *)
		OUT_CU.bMsg3618 ;// := 		FALSE;	(* 		 reserve operating message 26 *)
		OUT_CU.bMsg3619 ;// := 		FALSE;	(* 		 reserve operating message 27 *)
		OUT_CU.bMsg3620 ;// := 		FALSE;	(* 		 reserve operating message 28 *)
	
		OUT_CU.bMsg3621 ;// := 		FALSE;	(* B3621 reserve operating message 29 *)
		OUT_CU.bMsg3622 ;// := 		FALSE;	(* 		 reserve operating message 30 *)
		OUT_CU.bMsg3623 ;// := 		FALSE;	(* 		 reserve operating message 31 *)
		OUT_CU.bMsg3624 ;// := 		FALSE;	(* 		 reserve operating message 32 *)
		OUT_CU.bMsg3625 ;// := 		FALSE;	(* 		 reserve operating message 33 *)
		OUT_CU.bMsg3626 ;// := 		FALSE;	(* 		 reserve operating message 34 *)
		OUT_CU.bMsg3627 ;// := 		FALSE;	(* 		 reserve operating message 35 *)
		OUT_CU.bMsg3628 ;// := 		FALSE;	(* 		 reserve operating message 36 *)
		OUT_CU.bMsg3629 ;// := 		FALSE;	(* 		 reserve operating message 37 *)
		OUT_CU.bMsg3630 ;// := 		FALSE;	(* 		 reserve operating message 38 *)
		
		OUT_CU.bMsg3631 ;// := 		FALSE;	(* 		 reserve operating message 39 *)
		OUT_CU.bMsg3632 ;// := 		FALSE;	(* 		 reserve operating message 40 *)
		OUT_CU.bMsg3633 ;// := 		FALSE;	(* 		 reserve operating message 41 *)
		OUT_CU.bMsg3634 ;// := 		FALSE;	(* 		 reserve operating message 42 *)
		OUT_CU.bMsg3635 ;// := 		FALSE;	(* 		 reserve operating message 43 *)
		OUT_CU.bMsg3636 ;// := 		FALSE;	(* 		 reserve operating message 44 *)
		OUT_CU.bMsg3637 ;// := 		FALSE;	(* 		 reserve operating message 45 *)
		OUT_CU.bMsg3638 ;// := 		FALSE;	(* 		 reserve operating message 46 *)
		OUT_CU.bMsg3639 ;// := 		FALSE;	(* 		 reserve operating message 47 *)
		OUT_CU.bMsg3640 ;// := 		FALSE;	(* 		 reserve operating message 48 *)
	
		OUT_CU.bMsg3641 ;// := 		FALSE;	(* B3641 reserve operating message 49 *)
		OUT_CU.bMsg3642 ;// := 		FALSE;	(* 		 reserve operating message 50 *)
		OUT_CU.bMsg3643 ;// := 		FALSE;	(* 		 reserve operating message 51 *)
		OUT_CU.bMsg3644 ;// := 		FALSE;	(* 		 reserve operating message 52 *)
		OUT_CU.bMsg3645 ;// := 		FALSE;	(* 		 reserve operating message 53 *)
		OUT_CU.bMsg3646 ;// := 		FALSE;	(* 		 reserve operating message 54 *)
		OUT_CU.bMsg3647 ;// := 		FALSE;	(* 		 reserve operating message 55 *)
		OUT_CU.bMsg3648 ;// := 		FALSE;	(* 		 reserve operating message 56 *)
		OUT_CU.bMsg3649 ;// := 		FALSE;	(* 		 reserve operating message 57 *)
		OUT_CU.bMsg3650 ;// := 		FALSE;	(* 		 reserve operating message 58 *)
		
		OUT_CU.bMsg3651 ;// := 		FALSE;	(* 		 reserve operating message 59 *)
		OUT_CU.bMsg3652 ;// := 		FALSE;	(* 		 reserve operating message 60 *)
		OUT_CU.bMsg3653 ;// := 		FALSE;	(* 		 reserve operating message 61 *)
		OUT_CU.bMsg3654 ;// := 		FALSE;	(* 		 reserve operating message 62 *)
		OUT_CU.bMsg3655 ;// := 		FALSE;	(* 		 reserve operating message 63 *)
		OUT_CU.bMsg3656 ;// := 		FALSE;	(* 		 reserve operating message 64 *)
		OUT_CU.bMsg3657 ;// := 		FALSE;	(* 		 reserve operating message 65 *)
		OUT_CU.bMsg3658 ;// := 		FALSE;	(* 		 reserve operating message 66 *)
		OUT_CU.bMsg3659 ;// := 		FALSE;	(* 		 reserve operating message 67 *)
		OUT_CU.bMsg3660 ;// := 		FALSE;	(* 		 reserve operating message 68 *)
	
		OUT_CU.bMsg3661 ;// := 		FALSE;	(* B3661 reserve operating message 69 *)
		OUT_CU.bMsg3662 ;// := 		FALSE;	(* 		 reserve operating message 70 *)
		OUT_CU.bMsg3663 ;// := 		FALSE;	(* 		 reserve operating message 71 *)
		OUT_CU.bMsg3664 ;// := 		FALSE;	(* 		 reserve operating message 72 *)
		OUT_CU.bMsg3665 ;// := 		FALSE;	(* 		 reserve operating message 73 *)
		OUT_CU.bMsg3666 ;// := 		FALSE;	(* 		 reserve operating message 74 *)
		OUT_CU.bMsg3667 ;// := 		FALSE;	(* 		 reserve operating message 75 *)
		OUT_CU.bMsg3668 ;// := 		FALSE;	(* 		 reserve operating message 76 *)
		OUT_CU.bMsg3669 ;// := 		FALSE;	(* 		 reserve operating message 77 *)
		OUT_CU.bMsg3670 ;// := 		FALSE;	(* 		 reserve operating message 78 *)
		
		OUT_CU.bMsg3671 ;// := 		FALSE;	(* 		 reserve operating message 79 *)
		OUT_CU.bMsg3672 ;// := 		FALSE;	(* 		 reserve operating message 80 *)
		OUT_CU.bMsg3673 ;// := 		FALSE;	(* 		 reserve operating message 81 *)
		OUT_CU.bMsg3674 ;// := 		FALSE;	(* 		 reserve operating message 82 *)
		OUT_CU.bMsg3675 ;// := 		FALSE;	(* 		 reserve operating message 83 *)
		OUT_CU.bMsg3676 ;// := 		FALSE;	(* 		 reserve operating message 84 *)
		OUT_CU.bMsg3677 ;// := 		FALSE;	(* 		 reserve operating message 85 *)
		OUT_CU.bMsg3678 ;// := 		FALSE;	(* 		 reserve operating message 86 *)
		OUT_CU.bMsg3679 ;// := 		FALSE;	(* 		 reserve operating message 87 *)
		OUT_CU.bMsg3680 ;// := 		FALSE;	(* 		 reserve operating message 88 *)

		OUT_CU.bMsg3681 ;// := 		FALSE;	(* B3681 reserve operating message 89 *)
		OUT_CU.bMsg3682 ;// := 		FALSE;	(* 		 reserve operating message 90 *)
		OUT_CU.bMsg3683 ;// := 		FALSE;	(* 		 reserve operating message 91 *)
		OUT_CU.bMsg3684 ;// := 		FALSE;	(* 		 reserve operating message 92 *)
		OUT_CU.bMsg3685 ;// := 		FALSE;	(* 		 reserve operating message 93 *)
		OUT_CU.bMsg3686 ;// := 		FALSE;	(* 		 reserve operating message 94 *)
		OUT_CU.bMsg3687 ;// := 		FALSE;	(* 		 reserve operating message 95 *)
		OUT_CU.bMsg3688 ;// := 		FALSE;	(* 		 reserve operating message 96 *)
		OUT_CU.bMsg3689 ;// := 		FALSE;	(* 		 reserve operating message 97 *)
		OUT_CU.bMsg3690 ;// := 		FALSE;	(* 		 reserve operating message 98 *)
		
		OUT_CU.bMsg3691 ;// := 		FALSE;	(* 		 reserve operating message 99 *)
		OUT_CU.bMsg3692 ;// := 		FALSE;	(* 		 reserve operating message 100 *)
		OUT_CU.bMsg3693 ;// := 		FALSE;	(* 		 reserve operating message 101 *)
		OUT_CU.bMsg3694 ;// := 		FALSE;	(* 		 reserve operating message 102 *)
		OUT_CU.bMsg3695 ;// := 		FALSE;	(* 		 reserve operating message 103 *)
		OUT_CU.bMsg3696 ;// := 		FALSE;	(* 		 reserve operating message 104 *)
		OUT_CU.bMsg3697 ;// := 		FALSE;	(* 		 reserve operating message 105 *)
		OUT_CU.bMsg3698 ;// := 		FALSE;	(* 		 reserve operating message 106 *)
		OUT_CU.bMsg3699 ;// := 		FALSE;	(* 		 reserve operating message 107 *)
		OUT_CU.bMsg3700 ;// := 		FALSE;	(* 		 reserve operating message 108 *)

		OUT_CU.bMsg6701 ;// := 		FALSE;	(* B6701 reserve operating message 109 *) (*import HMI Extension *)
		OUT_CU.bMsg6702 ;// := 		FALSE;	(* B6702 reserve operating message 110 *) (*import HMI Extension *)
		OUT_CU.bMsg6703 ;// := 		FALSE;	(* B6703 reserve operating message 111 *) (*import HMI Extension *)
		OUT_CU.bMsg6704 ;// := 		FALSE;	(* B6704 reserve operating message 112 *) (*import HMI Extension *)
		OUT_CU.bMsg6705 ;// := 		FALSE;	(* B6705 reserve operating message 113 *) (*import HMI Extension *)
		OUT_CU.bMsg6706 ;// := 		FALSE;	(* B6706 reserve operating message 114 *) (*import HMI Extension *)
		OUT_CU.bMsg6707 ;// := 		FALSE;	(* B6707 reserve operating message 115 *) (*import HMI Extension *)
		OUT_CU.bMsg6708 ;// := 		FALSE;	(* B6708 reserve operating message 116 *) (*import HMI Extension *)
		OUT_CU.bMsg6709 ;// := 		FALSE;	(* B6709 reserve operating message 117 *) (*import HMI Extension *)
		OUT_CU.bMsg6710 ;// := 		FALSE;	(* B6710 reserve operating message 118 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6711 ;// := 		FALSE;	(* B6711 reserve operating message 119 *) (*import HMI Extension *)
		OUT_CU.bMsg6712 ;// := 		FALSE;	(* B6712 reserve operating message 120 *) (*import HMI Extension *)
		OUT_CU.bMsg6713 ;// := 		FALSE;	(* B6713 reserve operating message 121 *) (*import HMI Extension *)
		OUT_CU.bMsg6714 ;// := 		FALSE;	(* B6714 reserve operating message 122 *) (*import HMI Extension *)
		OUT_CU.bMsg6715 ;// := 		FALSE;	(* B6715 reserve operating message 123 *) (*import HMI Extension *)
		OUT_CU.bMsg6716 ;// := 		FALSE;	(* B6716 reserve operating message 124 *) (*import HMI Extension *)
		OUT_CU.bMsg6717 ;// := 		FALSE;	(* B6717 reserve operating message 125 *) (*import HMI Extension *)
		OUT_CU.bMsg6718 ;// := 		FALSE;	(* B6718 reserve operating message 126 *) (*import HMI Extension *)
		OUT_CU.bMsg6719 ;// := 		FALSE;	(* B6719 reserve operating message 127 *) (*import HMI Extension *)
		OUT_CU.bMsg6720 ;// := 		FALSE;	(* B6720 reserve operating message 128 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6721 ;// := 		FALSE;	(* B6721 reserve operating message 129 *) (*import HMI Extension *)
		OUT_CU.bMsg6722 ;// := 		FALSE;	(* B6722 reserve operating message 130 *) (*import HMI Extension *)
		OUT_CU.bMsg6723 ;// := 		FALSE;	(* B6723 reserve operating message 131 *) (*import HMI Extension *)
		OUT_CU.bMsg6724 ;// := 		FALSE;	(* B6724 reserve operating message 132 *) (*import HMI Extension *)
		OUT_CU.bMsg6725 ;// := 		FALSE;	(* B6725 reserve operating message 133 *) (*import HMI Extension *)
		OUT_CU.bMsg6726 ;// := 		FALSE;	(* B6726 reserve operating message 134 *) (*import HMI Extension *)
		OUT_CU.bMsg6727 ;// := 		FALSE;	(* B6727 reserve operating message 135 *) (*import HMI Extension *)
		OUT_CU.bMsg6728 ;// := 		FALSE;	(* B6728 reserve operating message 136 *) (*import HMI Extension *)
		OUT_CU.bMsg6729 ;// := 		FALSE;	(* B6729 reserve operating message 137 *) (*import HMI Extension *)
		OUT_CU.bMsg6730 ;// := 		FALSE;	(* B6730 reserve operating message 138 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6731 ;// := 		FALSE;	(* B6731 reserve operating message 139 *) (*import HMI Extension *)
		OUT_CU.bMsg6732 ;// := 		FALSE;	(* B6732 reserve operating message 140 *) (*import HMI Extension *)
		OUT_CU.bMsg6733 ;// := 		FALSE;	(* B6733 reserve operating message 141 *) (*import HMI Extension *)
		OUT_CU.bMsg6734 ;// := 		FALSE;	(* B6734 reserve operating message 142 *) (*import HMI Extension *)
		OUT_CU.bMsg6735 ;// := 		FALSE;	(* B6735 reserve operating message 143 *) (*import HMI Extension *)
		OUT_CU.bMsg6736 ;// := 		FALSE;	(* B6736 reserve operating message 144 *) (*import HMI Extension *)
		OUT_CU.bMsg6737 ;// := 		FALSE;	(* B6737 reserve operating message 145 *) (*import HMI Extension *)
		OUT_CU.bMsg6738 ;// := 		FALSE;	(* B6738 reserve operating message 146 *) (*import HMI Extension *)
		OUT_CU.bMsg6739 ;// := 		FALSE;	(* B6739 reserve operating message 147 *) (*import HMI Extension *)
		OUT_CU.bMsg6740 ;// := 		FALSE;	(* B6740 reserve operating message 148 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6741 ;// := 		FALSE;	(* B6741 reserve operating message 149 *) (*import HMI Extension *)
		OUT_CU.bMsg6742 ;// := 		FALSE;	(* B6742 reserve operating message 150 *) (*import HMI Extension *)
		OUT_CU.bMsg6743 ;// := 		FALSE;	(* B6743 reserve operating message 151 *) (*import HMI Extension *)
		OUT_CU.bMsg6744 ;// := 		FALSE;	(* B6744 reserve operating message 152 *) (*import HMI Extension *)
		OUT_CU.bMsg6745 ;// := 		FALSE;	(* B6745 reserve operating message 153 *) (*import HMI Extension *)
		OUT_CU.bMsg6746 ;// := 		FALSE;	(* B6746 reserve operating message 154 *) (*import HMI Extension *)
		OUT_CU.bMsg6747 ;// := 		FALSE;	(* B6747 reserve operating message 155 *) (*import HMI Extension *)
		OUT_CU.bMsg6748 ;// := 		FALSE;	(* B6748 reserve operating message 156 *) (*import HMI Extension *)
		OUT_CU.bMsg6749 ;// := 		FALSE;	(* B6749 reserve operating message 157 *) (*import HMI Extension *)
		OUT_CU.bMsg6750 ;// := 		FALSE;	(* B6750 reserve operating message 158 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6751 ;// := 		FALSE;	(* B6751 reserve operating message 159 *) (*import HMI Extension *)
		OUT_CU.bMsg6752 ;// := 		FALSE;	(* B6752 reserve operating message 160 *) (*import HMI Extension *)
		OUT_CU.bMsg6753 ;// := 		FALSE;	(* B6753 reserve operating message 161 *) (*import HMI Extension *)
		OUT_CU.bMsg6754 ;// := 		FALSE;	(* B6754 reserve operating message 162 *) (*import HMI Extension *)
		OUT_CU.bMsg6755 ;// := 		FALSE;	(* B6755 reserve operating message 163 *) (*import HMI Extension *)
		OUT_CU.bMsg6756 ;// := 		FALSE;	(* B6756 reserve operating message 164 *) (*import HMI Extension *)
		OUT_CU.bMsg6757 ;// := 		FALSE;	(* B6757 reserve operating message 165 *) (*import HMI Extension *)
		OUT_CU.bMsg6758 ;// := 		FALSE;	(* B6758 reserve operating message 166 *) (*import HMI Extension *)
		OUT_CU.bMsg6759 ;// := 		FALSE;	(* B6759 reserve operating message 167 *) (*import HMI Extension *)
		OUT_CU.bMsg6760 ;// := 		FALSE;	(* B6760 reserve operating message 168 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6761 ;// := 		FALSE;	(* B6761 reserve operating message 169 *) (*import HMI Extension *)
		OUT_CU.bMsg6762 ;// := 		FALSE;	(* B6762 reserve operating message 170 *) (*import HMI Extension *)
		OUT_CU.bMsg6763 ;// := 		FALSE;	(* B6763 reserve operating message 171 *) (*import HMI Extension *)
		OUT_CU.bMsg6764 ;// := 		FALSE;	(* B6764 reserve operating message 172 *) (*import HMI Extension *)
		OUT_CU.bMsg6765 ;// := 		FALSE;	(* B6765 reserve operating message 173 *) (*import HMI Extension *)
		OUT_CU.bMsg6766 ;// := 		FALSE;	(* B6766 reserve operating message 174 *) (*import HMI Extension *)
		OUT_CU.bMsg6767 ;// := 		FALSE;	(* B6767 reserve operating message 175 *) (*import HMI Extension *)
		OUT_CU.bMsg6768 ;// := 		FALSE;	(* B6768 reserve operating message 176 *) (*import HMI Extension *)
		OUT_CU.bMsg6769 ;// := 		FALSE;	(* B6769 reserve operating message 177 *) (*import HMI Extension *)
		OUT_CU.bMsg6770 ;// := 		FALSE;	(* B6770 reserve operating message 178 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6771 ;// := 		FALSE;	(* B6771 reserve operating message 179 *) (*import HMI Extension *)
		OUT_CU.bMsg6772 ;// := 		FALSE;	(* B6772 reserve operating message 180 *) (*import HMI Extension *)
		OUT_CU.bMsg6773 ;// := 		FALSE;	(* B6773 reserve operating message 181 *) (*import HMI Extension *)
		OUT_CU.bMsg6774 ;// := 		FALSE;	(* B6774 reserve operating message 182 *) (*import HMI Extension *)
		OUT_CU.bMsg6775 ;// := 		FALSE;	(* B6775 reserve operating message 183 *) (*import HMI Extension *)
		OUT_CU.bMsg6776 ;// := 		FALSE;	(* B6776 reserve operating message 184 *) (*import HMI Extension *)
		OUT_CU.bMsg6777 ;// := 		FALSE;	(* B6777 reserve operating message 185 *) (*import HMI Extension *)
		OUT_CU.bMsg6778 ;// := 		FALSE;	(* B6778 reserve operating message 186 *) (*import HMI Extension *)
		OUT_CU.bMsg6779 ;// := 		FALSE;	(* B6779 reserve operating message 187 *) (*import HMI Extension *)
		OUT_CU.bMsg6780 ;// := 		FALSE;	(* B6780 reserve operating message 188 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6781 ;// := 		FALSE;	(* B6781 reserve operating message 189 *) (*import HMI Extension *)
		OUT_CU.bMsg6782 ;// := 		FALSE;	(* B6782 reserve operating message 190 *) (*import HMI Extension *)
		OUT_CU.bMsg6783 ;// := 		FALSE;	(* B6783 reserve operating message 191 *) (*import HMI Extension *)
		OUT_CU.bMsg6784 ;// := 		FALSE;	(* B6784 reserve operating message 192 *) (*import HMI Extension *)
		OUT_CU.bMsg6785 ;// := 		FALSE;	(* B6785 reserve operating message 193 *) (*import HMI Extension *)
		OUT_CU.bMsg6786 ;// := 		FALSE;	(* B6786 reserve operating message 194 *) (*import HMI Extension *)
		OUT_CU.bMsg6787 ;// := 		FALSE;	(* B6787 reserve operating message 195 *) (*import HMI Extension *)
		OUT_CU.bMsg6788 ;// := 		FALSE;	(* B6788 reserve operating message 196 *) (*import HMI Extension *)
		OUT_CU.bMsg6789 ;// := 		FALSE;	(* B6789 reserve operating message 197 *) (*import HMI Extension *)
		OUT_CU.bMsg6790 ;// := 		FALSE;	(* B6790 reserve operating message 198 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6791 ;// := 		FALSE;	(* B6791 reserve operating message 199 *) (*import HMI Extension *)
		OUT_CU.bMsg6792 ;// := 		FALSE;	(* B6792 reserve operating message 200 *) (*import HMI Extension *)
		OUT_CU.bMsg6793 ;// := 		FALSE;	(* B6793 reserve operating message 201 *) (*import HMI Extension *)
		OUT_CU.bMsg6794 ;// := 		FALSE;	(* B6794 reserve operating message 202 *) (*import HMI Extension *)
		OUT_CU.bMsg6795 ;// := 		FALSE;	(* B6795 reserve operating message 203 *) (*import HMI Extension *)
		OUT_CU.bMsg6796 ;// := 		FALSE;	(* B6796 reserve operating message 204 *) (*import HMI Extension *)
		OUT_CU.bMsg6797 ;// := 		FALSE;	(* B6797 reserve operating message 205 *) (*import HMI Extension *)
		OUT_CU.bMsg6798 ;// := 		FALSE;	(* B6798 reserve operating message 206 *) (*import HMI Extension *)
		OUT_CU.bMsg6799 ;// := 		FALSE;	(* B6799 reserve operating message 207 *) (*import HMI Extension *)
		OUT_CU.bMsg6800 ;// := 		FALSE;	(* B6800 reserve operating message 208 *) (*import HMI Extension *)

		OUT_CU.bMsg6801 ;// := 		FALSE;	(* B6801 reserve operating message 209 *) (*import HMI Extension *)
		OUT_CU.bMsg6802 ;// := 		FALSE;	(* B6802 reserve operating message 210 *) (*import HMI Extension *)
		OUT_CU.bMsg6803 ;// := 		FALSE;	(* B6803 reserve operating message 211 *) (*import HMI Extension *)
		OUT_CU.bMsg6804 ;// := 		FALSE;	(* B6804 reserve operating message 212 *) (*import HMI Extension *)
		OUT_CU.bMsg6805 ;// := 		FALSE;	(* B6805 reserve operating message 213 *) (*import HMI Extension *)
		OUT_CU.bMsg6806 ;// := 		FALSE;	(* B6806 reserve operating message 214 *) (*import HMI Extension *)
		OUT_CU.bMsg6807 ;// := 		FALSE;	(* B6807 reserve operating message 215 *) (*import HMI Extension *)
		OUT_CU.bMsg6808 ;// := 		FALSE;	(* B6808 reserve operating message 216 *) (*import HMI Extension *)
		OUT_CU.bMsg6809 ;// := 		FALSE;	(* B6809 reserve operating message 217 *) (*import HMI Extension *)
		OUT_CU.bMsg6810 ;// := 		FALSE;	(* B6810 reserve operating message 218 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6811 ;// := 		FALSE;	(* B6811 reserve operating message 219 *) (*import HMI Extension *)
		OUT_CU.bMsg6812 ;// := 		FALSE;	(* B6812 reserve operating message 220 *) (*import HMI Extension *)
		OUT_CU.bMsg6813 ;// := 		FALSE;	(* B6813 reserve operating message 221 *) (*import HMI Extension *)
		OUT_CU.bMsg6814 ;// := 		FALSE;	(* B6814 reserve operating message 222 *) (*import HMI Extension *)
		OUT_CU.bMsg6815 ;// := 		FALSE;	(* B6815 reserve operating message 223 *) (*import HMI Extension *)
		OUT_CU.bMsg6816 ;// := 		FALSE;	(* B6816 reserve operating message 224 *) (*import HMI Extension *)
		OUT_CU.bMsg6817 ;// := 		FALSE;	(* B6817 reserve operating message 225 *) (*import HMI Extension *)
		OUT_CU.bMsg6818 ;// := 		FALSE;	(* B6818 reserve operating message 226 *) (*import HMI Extension *)
		OUT_CU.bMsg6819 ;// := 		FALSE;	(* B6819 reserve operating message 227 *) (*import HMI Extension *)
		OUT_CU.bMsg6820 ;// := 		FALSE;	(* B6820 reserve operating message 228 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6821 ;// := 		FALSE;	(* B6821 reserve operating message 229 *) (*import HMI Extension *)
		OUT_CU.bMsg6822 ;// := 		FALSE;	(* B6822 reserve operating message 230 *) (*import HMI Extension *)
		OUT_CU.bMsg6823 ;// := 		FALSE;	(* B6823 reserve operating message 231 *) (*import HMI Extension *)
		OUT_CU.bMsg6824 ;// := 		FALSE;	(* B6824 reserve operating message 232 *) (*import HMI Extension *)
		OUT_CU.bMsg6825 ;// := 		FALSE;	(* B6825 reserve operating message 233 *) (*import HMI Extension *)
		OUT_CU.bMsg6826 ;// := 		FALSE;	(* B6826 reserve operating message 234 *) (*import HMI Extension *)
		OUT_CU.bMsg6827 ;// := 		FALSE;	(* B6827 reserve operating message 235 *) (*import HMI Extension *)
		OUT_CU.bMsg6828 ;// := 		FALSE;	(* B6828 reserve operating message 236 *) (*import HMI Extension *)
		OUT_CU.bMsg6829 ;// := 		FALSE;	(* B6829 reserve operating message 237 *) (*import HMI Extension *)
		OUT_CU.bMsg6830 ;// := 		FALSE;	(* B6830 reserve operating message 238 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6831 ;// := 		FALSE;	(* B6831 reserve operating message 239 *) (*import HMI Extension *)
		OUT_CU.bMsg6832 ;// := 		FALSE;	(* B6832 reserve operating message 240 *) (*import HMI Extension *)
		OUT_CU.bMsg6833 ;// := 		FALSE;	(* B6833 reserve operating message 241 *) (*import HMI Extension *)
		OUT_CU.bMsg6834 ;// := 		FALSE;	(* B6834 reserve operating message 242 *) (*import HMI Extension *)
		OUT_CU.bMsg6835 ;// := 		FALSE;	(* B6835 reserve operating message 243 *) (*import HMI Extension *)
		OUT_CU.bMsg6836 ;// := 		FALSE;	(* B6836 reserve operating message 244 *) (*import HMI Extension *)
		OUT_CU.bMsg6837 ;// := 		FALSE;	(* B6837 reserve operating message 245 *) (*import HMI Extension *)
		OUT_CU.bMsg6838 ;// := 		FALSE;	(* B6838 reserve operating message 246 *) (*import HMI Extension *)
		OUT_CU.bMsg6839 ;// := 		FALSE;	(* B6839 reserve operating message 247 *) (*import HMI Extension *)
		OUT_CU.bMsg6840 ;// := 		FALSE;	(* B6840 reserve operating message 248 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6841 ;// := 		FALSE;	(* B6841 reserve operating message 249 *) (*import HMI Extension *)
		OUT_CU.bMsg6842 ;// := 		FALSE;	(* B6842 reserve operating message 250 *) (*import HMI Extension *)
		OUT_CU.bMsg6843 ;// := 		FALSE;	(* B6843 reserve operating message 251 *) (*import HMI Extension *)
		OUT_CU.bMsg6844 ;// := 		FALSE;	(* B6844 reserve operating message 252 *) (*import HMI Extension *)
		OUT_CU.bMsg6845 ;// := 		FALSE;	(* B6845 reserve operating message 253 *) (*import HMI Extension *)
		OUT_CU.bMsg6846 ;// := 		FALSE;	(* B6846 reserve operating message 254 *) (*import HMI Extension *)
		OUT_CU.bMsg6847 ;// := 		FALSE;	(* B6847 reserve operating message 255 *) (*import HMI Extension *)
		OUT_CU.bMsg6848 ;// := 		FALSE;	(* B6848 reserve operating message 256 *) (*import HMI Extension *)
		OUT_CU.bMsg6849 ;// := 		FALSE;	(* B6849 reserve operating message 257 *) (*import HMI Extension *)
		OUT_CU.bMsg6850 ;// := 		FALSE;	(* B6850 reserve operating message 258 *) (*import HMI Extension *)

		OUT_CU.bMsg6851 ;// := 		FALSE;	(* B6851 reserve operating message 259 *) (*import HMI Extension *)
		OUT_CU.bMsg6852 ;// := 		FALSE;	(* B6852 reserve operating message 260 *) (*import HMI Extension *)
		OUT_CU.bMsg6853 ;// := 		FALSE;	(* B6853 reserve operating message 261 *) (*import HMI Extension *)
		OUT_CU.bMsg6854 ;// := 		FALSE;	(* B6854 reserve operating message 262 *) (*import HMI Extension *)
		OUT_CU.bMsg6855 ;// := 		FALSE;	(* B6855 reserve operating message 263 *) (*import HMI Extension *)
		OUT_CU.bMsg6856 ;// := 		FALSE;	(* B6856 reserve operating message 264 *) (*import HMI Extension *)
		OUT_CU.bMsg6857 ;// := 		FALSE;	(* B6857 reserve operating message 265 *) (*import HMI Extension *)
		OUT_CU.bMsg6858 ;// := 		FALSE;	(* B6858 reserve operating message 266 *) (*import HMI Extension *)
		OUT_CU.bMsg6859 ;// := 		FALSE;	(* B6859 reserve operating message 267 *) (*import HMI Extension *)
		OUT_CU.bMsg6860 ;// := 		FALSE;	(* B6860 reserve operating message 268 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6861 ;// := 		FALSE;	(* B6861 reserve operating message 269 *) (*import HMI Extension *)
		OUT_CU.bMsg6862 ;// := 		FALSE;	(* B6862 reserve operating message 270 *) (*import HMI Extension *)
		OUT_CU.bMsg6863 ;// := 		FALSE;	(* B6863 reserve operating message 271 *) (*import HMI Extension *)
		OUT_CU.bMsg6864 ;// := 		FALSE;	(* B6864 reserve operating message 272 *) (*import HMI Extension *)
		OUT_CU.bMsg6865 ;// := 		FALSE;	(* B6865 reserve operating message 273 *) (*import HMI Extension *)
		OUT_CU.bMsg6866 ;// := 		FALSE;	(* B6866 reserve operating message 274 *) (*import HMI Extension *)
		OUT_CU.bMsg6867 ;// := 		FALSE;	(* B6867 reserve operating message 275 *) (*import HMI Extension *)
		OUT_CU.bMsg6868 ;// := 		FALSE;	(* B6868 reserve operating message 276 *) (*import HMI Extension *)
		OUT_CU.bMsg6869 ;// := 		FALSE;	(* B6869 reserve operating message 277 *) (*import HMI Extension *)
		OUT_CU.bMsg6870 ;// := 		FALSE;	(* B6870 reserve operating message 278 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6871 ;// := 		FALSE;	(* B6871 reserve operating message 279 *) (*import HMI Extension *)
		OUT_CU.bMsg6872 ;// := 		FALSE;	(* B6872 reserve operating message 280 *) (*import HMI Extension *)
		OUT_CU.bMsg6873 ;// := 		FALSE;	(* B6873 reserve operating message 281 *) (*import HMI Extension *)
		OUT_CU.bMsg6874 ;// := 		FALSE;	(* B6874 reserve operating message 282 *) (*import HMI Extension *)
		OUT_CU.bMsg6875 ;// := 		FALSE;	(* B6875 reserve operating message 283 *) (*import HMI Extension *)
		OUT_CU.bMsg6876 ;// := 		FALSE;	(* B6876 reserve operating message 284 *) (*import HMI Extension *)
		OUT_CU.bMsg6877 ;// := 		FALSE;	(* B6877 reserve operating message 285 *) (*import HMI Extension *)
		OUT_CU.bMsg6878 ;// := 		FALSE;	(* B6878 reserve operating message 286 *) (*import HMI Extension *)
		OUT_CU.bMsg6879 ;// := 		FALSE;	(* B6879 reserve operating message 287 *) (*import HMI Extension *)
		OUT_CU.bMsg6880 ;// := 		FALSE;	(* B6880 reserve operating message 288 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6881 ;// := 		FALSE;	(* B6881 reserve operating message 289 *) (*import HMI Extension *)
		OUT_CU.bMsg6882 ;// := 		FALSE;	(* B6882 reserve operating message 290 *) (*import HMI Extension *)
		OUT_CU.bMsg6883 ;// := 		FALSE;	(* B6883 reserve operating message 291 *) (*import HMI Extension *)
		OUT_CU.bMsg6884 ;// := 		FALSE;	(* B6884 reserve operating message 292 *) (*import HMI Extension *)
		OUT_CU.bMsg6885 ;// := 		FALSE;	(* B6885 reserve operating message 293 *) (*import HMI Extension *)
		OUT_CU.bMsg6886 ;// := 		FALSE;	(* B6886 reserve operating message 294 *) (*import HMI Extension *)
		OUT_CU.bMsg6887 ;// := 		FALSE;	(* B6887 reserve operating message 295 *) (*import HMI Extension *)
		OUT_CU.bMsg6888 ;// := 		FALSE;	(* B6888 reserve operating message 296 *) (*import HMI Extension *)
		OUT_CU.bMsg6889 ;// := 		FALSE;	(* B6889 reserve operating message 297 *) (*import HMI Extension *)
		OUT_CU.bMsg6890 ;// := 		FALSE;	(* B6890 reserve operating message 298 *) (*import HMI Extension *)

		OUT_CU.bMsg6891 ;// := 		FALSE;	(* B6891 reserve operating message 299 *) (*import HMI Extension *)
		OUT_CU.bMsg6892 ;// := 		FALSE;	(* B6892 reserve operating message 300 *) (*import HMI Extension *)
		OUT_CU.bMsg6893 ;// := 		FALSE;	(* B6893 reserve operating message 301 *) (*import HMI Extension *)
		OUT_CU.bMsg6894 ;// := 		FALSE;	(* B6894 reserve operating message 302 *) (*import HMI Extension *)
		OUT_CU.bMsg6895 ;// := 		FALSE;	(* B6895 reserve operating message 303 *) (*import HMI Extension *)
		OUT_CU.bMsg6896 ;// := 		FALSE;	(* B6896 reserve operating message 304 *) (*import HMI Extension *)
		OUT_CU.bMsg6897 ;// := 		FALSE;	(* B6897 reserve operating message 305 *) (*import HMI Extension *)
		OUT_CU.bMsg6898 ;// := 		FALSE;	(* B6898 reserve operating message 306 *) (*import HMI Extension *)
		OUT_CU.bMsg6899 ;// := 		FALSE;	(* B6899 reserve operating message 307 *) (*import HMI Extension *)
//OLD do not use		OUT_CU.bMsg8700 ;// := 		FALSE;	(* B4200 reserve operating message 308 *) (*import HMI Extension *)
	
	(*----------------------------------------------------------------------------*)
	(* NO CHANGES BEYOND THIS LINE necessary  *)
	(*----------------------------------------------------------------------------*)
	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1 := 		OUT_CU.tCU2AB.bGnlTrip1   OR IN_CU.tAB2CU.bGnlTrip1;
	bGnlTrip2 := 		OUT_CU.tCU2AB.bGnlTrip2   OR IN_CU.tAB2CU.bGnlTrip2;
	bGnlTrip3 := 		OUT_CU.tCU2AB.bGnlTrip3   OR IN_CU.tAB2CU.bGnlTrip3;
	bGnlWarning:=		OUT_CU.tCU2AB.bGnlWarning OR IN_CU.tAB2CU.bGnlWarning;

	bGnlTrip := 		bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
	
	(*----------------------------------------------------------------------------*)
	(* MODULE OUTPUT INFO:  *)

//	OUT_CU.iCount1 := 		FALSE;	(* customized counter 1: ... *)
//	OUT_CU.iCount2 := 		FALSE;	(* customized counter 2: ... *)
//	OUT_CU.iCount3 := 		FALSE;	(* customized counter 3: ... *)
//	OUT_CU.iCount4 := 		FALSE;	(* customized counter 4: ... *)
//	(*...*)
//	OUT_CU.iCount19 := 		FALSE;	(* customized counter 19: ... *)
//	OUT_CU.iCount20 := 		FALSE;	(* customized counter 20: ... *)	
		
	(*----------------------------------------------------------------------------*)

	
	(* Forwarding of spare alarm messages: *)
(*	MM2VIS.bMsg1601 :=	xMsg16[01].Q; *)		OUT_CU.bMsg1601 :=	xMsg16[01].Q;    (*remove duplicate MM2VIS handling*)
												OUT_CU.bMsg1602 :=	xMsg16[02].Q;    (*remove duplicate MM2VIS handling*)
												OUT_CU.bMsg1603 :=	xMsg16[03].Q;    (*remove duplicate MM2VIS handling*)
												OUT_CU.bMsg1604 :=	xMsg16[04].Q;		//ToDo..
												OUT_CU.bMsg1605 :=	xMsg16[05].Q;
												OUT_CU.bMsg1606 :=	xMsg16[06].Q;
												OUT_CU.bMsg1607 :=	xMsg16[07].Q;
												OUT_CU.bMsg1608 :=	xMsg16[08].Q;
												OUT_CU.bMsg1609 :=	xMsg16[09].Q;
												OUT_CU.bMsg1610 :=	xMsg16[10].Q;
						
	MM2VIS.bMsg1611 :=	xMsg16[11].Q;			OUT_CU.bMsg1611 :=	xMsg16[11].Q;
	MM2VIS.bMsg1612 :=	xMsg16[12].Q;			OUT_CU.bMsg1612 :=	xMsg16[12].Q;
	MM2VIS.bMsg1613 :=	xMsg16[13].Q;			OUT_CU.bMsg1613 :=	xMsg16[13].Q;
	MM2VIS.bMsg1614 :=	xMsg16[14].Q;			OUT_CU.bMsg1614 :=	xMsg16[14].Q;
	MM2VIS.bMsg1615 :=	xMsg16[15].Q;			OUT_CU.bMsg1615 :=	xMsg16[15].Q;
	MM2VIS.bMsg1616 :=	xMsg16[16].Q;			OUT_CU.bMsg1616 :=	xMsg16[16].Q;
	MM2VIS.bMsg1617 :=	xMsg16[17].Q;			OUT_CU.bMsg1617 :=	xMsg16[17].Q;
	MM2VIS.bMsg1618 :=	xMsg16[18].Q;			OUT_CU.bMsg1618 :=	xMsg16[18].Q;
	MM2VIS.bMsg1619 :=	xMsg16[19].Q;			OUT_CU.bMsg1619 :=	xMsg16[19].Q;
	MM2VIS.bMsg1620 :=	xMsg16[20].Q;			OUT_CU.bMsg1620 :=	xMsg16[20].Q;
						
						
	MM2VIS.bMsg1621 :=	xMsg16[21].Q;			OUT_CU.bMsg1621 :=	xMsg16[21].Q;
	MM2VIS.bMsg1622 :=	xMsg16[22].Q;			OUT_CU.bMsg1622 :=	xMsg16[22].Q;
	MM2VIS.bMsg1623 :=	xMsg16[23].Q;			OUT_CU.bMsg1623 :=	xMsg16[23].Q;
	MM2VIS.bMsg1624 :=	xMsg16[24].Q;			OUT_CU.bMsg1624 :=	xMsg16[24].Q;
	MM2VIS.bMsg1625 :=	xMsg16[25].Q;			OUT_CU.bMsg1625 :=	xMsg16[25].Q;
	MM2VIS.bMsg1626 :=	xMsg16[26].Q;			OUT_CU.bMsg1626 :=	xMsg16[26].Q;
	MM2VIS.bMsg1627 :=	xMsg16[27].Q;			OUT_CU.bMsg1627 :=	xMsg16[27].Q;
	MM2VIS.bMsg1628 :=	xMsg16[28].Q;			OUT_CU.bMsg1628 :=	xMsg16[28].Q;
	MM2VIS.bMsg1629 :=	xMsg16[29].Q;			OUT_CU.bMsg1629 :=	xMsg16[29].Q;
	MM2VIS.bMsg1630 :=	xMsg16[30].Q;			OUT_CU.bMsg1630 :=	xMsg16[30].Q;
						
	MM2VIS.bMsg1631 :=	xMsg16[31].Q;			OUT_CU.bMsg1631 :=	xMsg16[31].Q;
	MM2VIS.bMsg1632 :=	xMsg16[32].Q;			OUT_CU.bMsg1632 :=	xMsg16[32].Q;
	MM2VIS.bMsg1633 :=	xMsg16[33].Q;			OUT_CU.bMsg1633 :=	xMsg16[33].Q;
	MM2VIS.bMsg1634 :=	xMsg16[34].Q;			OUT_CU.bMsg1634 :=	xMsg16[34].Q;
	MM2VIS.bMsg1635 :=	xMsg16[35].Q;			OUT_CU.bMsg1635 :=	xMsg16[35].Q;
	MM2VIS.bMsg1636 :=	xMsg16[36].Q;			OUT_CU.bMsg1636 :=	xMsg16[36].Q;
	MM2VIS.bMsg1637 :=	xMsg16[37].Q;			OUT_CU.bMsg1637 :=	xMsg16[37].Q;
	MM2VIS.bMsg1638 :=	xMsg16[38].Q;			OUT_CU.bMsg1638 :=	xMsg16[38].Q;
	MM2VIS.bMsg1639 :=	xMsg16[39].Q;			OUT_CU.bMsg1639 :=	xMsg16[39].Q;
	MM2VIS.bMsg1640 :=	xMsg16[40].Q;			OUT_CU.bMsg1640 :=	xMsg16[40].Q;
						
						
	MM2VIS.bMsg1641 :=	xMsg16[41].Q;			OUT_CU.bMsg1641 :=	xMsg16[41].Q;
	MM2VIS.bMsg1642 :=	xMsg16[42].Q;			OUT_CU.bMsg1642 :=	xMsg16[42].Q;
	MM2VIS.bMsg1643 :=	xMsg16[43].Q;			OUT_CU.bMsg1643 :=	xMsg16[43].Q;
	MM2VIS.bMsg1644 :=	xMsg16[44].Q;			OUT_CU.bMsg1644 :=	xMsg16[44].Q;
	MM2VIS.bMsg1645 :=	xMsg16[45].Q;			OUT_CU.bMsg1645 :=	xMsg16[45].Q;
	MM2VIS.bMsg1646 :=	xMsg16[46].Q;			OUT_CU.bMsg1646 :=	xMsg16[46].Q;
	MM2VIS.bMsg1647 :=	xMsg16[47].Q;			OUT_CU.bMsg1647 :=	xMsg16[47].Q;
	MM2VIS.bMsg1648 :=	xMsg16[48].Q;			OUT_CU.bMsg1648 :=	xMsg16[48].Q;
	MM2VIS.bMsg1649 :=	xMsg16[49].Q;			OUT_CU.bMsg1649 :=	xMsg16[49].Q;
	MM2VIS.bMsg1650 :=	xMsg16[50].Q;			OUT_CU.bMsg1650 :=	xMsg16[50].Q;
						
	MM2VIS.bMsg1651 :=	xMsg16[51].Q;			OUT_CU.bMsg1651 :=	xMsg16[51].Q;
	MM2VIS.bMsg1652 :=	xMsg16[52].Q;			OUT_CU.bMsg1652 :=	xMsg16[52].Q;
	MM2VIS.bMsg1653 :=	xMsg16[53].Q;			OUT_CU.bMsg1653 :=	xMsg16[53].Q;
	MM2VIS.bMsg1654 :=	xMsg16[54].Q;			OUT_CU.bMsg1654 :=	xMsg16[54].Q;
	MM2VIS.bMsg1655 :=	xMsg16[55].Q;			OUT_CU.bMsg1655 :=	xMsg16[55].Q;
	MM2VIS.bMsg1656 :=	xMsg16[56].Q;			OUT_CU.bMsg1656 :=	xMsg16[56].Q;
	MM2VIS.bMsg1657 :=	xMsg16[57].Q;			OUT_CU.bMsg1657 :=	xMsg16[57].Q;
	MM2VIS.bMsg1658 :=	xMsg16[58].Q;			OUT_CU.bMsg1658 :=	xMsg16[58].Q;
	MM2VIS.bMsg1659 :=	xMsg16[59].Q;			OUT_CU.bMsg1659 :=	xMsg16[59].Q;
	MM2VIS.bMsg1660 :=	xMsg16[60].Q;			OUT_CU.bMsg1660 :=	xMsg16[60].Q;
						
						
	MM2VIS.bMsg1661 :=	xMsg16[61].Q;			OUT_CU.bMsg1661 :=	xMsg16[61].Q;
	MM2VIS.bMsg1662 :=	xMsg16[62].Q;			OUT_CU.bMsg1662 :=	xMsg16[62].Q;
	MM2VIS.bMsg1663 :=	xMsg16[63].Q;			OUT_CU.bMsg1663 :=	xMsg16[63].Q;
	MM2VIS.bMsg1664 :=	xMsg16[64].Q;			OUT_CU.bMsg1664 :=	xMsg16[64].Q;
	MM2VIS.bMsg1665 :=	xMsg16[65].Q;			OUT_CU.bMsg1665 :=	xMsg16[65].Q;
	MM2VIS.bMsg1666 :=	xMsg16[66].Q;			OUT_CU.bMsg1666 :=	xMsg16[66].Q;
	MM2VIS.bMsg1667 :=	xMsg16[67].Q;			OUT_CU.bMsg1667 :=	xMsg16[67].Q;
	MM2VIS.bMsg1668 :=	xMsg16[68].Q;			OUT_CU.bMsg1668 :=	xMsg16[68].Q;
	MM2VIS.bMsg1669 :=	xMsg16[69].Q;			OUT_CU.bMsg1669 :=	xMsg16[69].Q;
	MM2VIS.bMsg1670 :=	xMsg16[70].Q;			OUT_CU.bMsg1670 :=	xMsg16[70].Q;
						
	MM2VIS.bMsg1671 :=	xMsg16[71].Q;			OUT_CU.bMsg1671 :=	xMsg16[71].Q;
	MM2VIS.bMsg1672 :=	xMsg16[72].Q;			OUT_CU.bMsg1672 :=	xMsg16[72].Q;
	MM2VIS.bMsg1673 :=	xMsg16[73].Q;			OUT_CU.bMsg1673 :=	xMsg16[73].Q;
	MM2VIS.bMsg1674 :=	xMsg16[74].Q;			OUT_CU.bMsg1674 :=	xMsg16[74].Q;
	MM2VIS.bMsg1675 :=	xMsg16[75].Q;			OUT_CU.bMsg1675 :=	xMsg16[75].Q;
	MM2VIS.bMsg1676 :=	xMsg16[76].Q;			OUT_CU.bMsg1676 :=	xMsg16[76].Q;
	MM2VIS.bMsg1677 :=	xMsg16[77].Q;			OUT_CU.bMsg1677 :=	xMsg16[77].Q;
	MM2VIS.bMsg1678 :=	xMsg16[78].Q;			OUT_CU.bMsg1678 :=	xMsg16[78].Q;
	MM2VIS.bMsg1679 :=	xMsg16[79].Q;			OUT_CU.bMsg1679 :=	xMsg16[79].Q;
	MM2VIS.bMsg1680 :=	xMsg16[80].Q;			OUT_CU.bMsg1680 :=	xMsg16[80].Q;
						
						
	MM2VIS.bMsg1681 :=	xMsg16[81].Q;			OUT_CU.bMsg1681 :=	xMsg16[81].Q;
	MM2VIS.bMsg1682 :=	xMsg16[82].Q;			OUT_CU.bMsg1682 :=	xMsg16[82].Q;
	MM2VIS.bMsg1683 :=	xMsg16[83].Q;			OUT_CU.bMsg1683 :=	xMsg16[83].Q;
	MM2VIS.bMsg1684 :=	xMsg16[84].Q;			OUT_CU.bMsg1684 :=	xMsg16[84].Q;
	MM2VIS.bMsg1685 :=	xMsg16[85].Q;			OUT_CU.bMsg1685 :=	xMsg16[85].Q;
	MM2VIS.bMsg1686 :=	xMsg16[86].Q;			OUT_CU.bMsg1686 :=	xMsg16[86].Q;
	MM2VIS.bMsg1687 :=	xMsg16[87].Q;			OUT_CU.bMsg1687 :=	xMsg16[87].Q;
	MM2VIS.bMsg1688 :=	xMsg16[88].Q;			OUT_CU.bMsg1688 :=	xMsg16[88].Q;
	MM2VIS.bMsg1689 :=	xMsg16[89].Q;			OUT_CU.bMsg1689 :=	xMsg16[89].Q;
	MM2VIS.bMsg1690 :=	xMsg16[90].Q;			OUT_CU.bMsg1690 :=	xMsg16[90].Q;
						
	MM2VIS.bMsg1691 :=	xMsg16[91].Q;			OUT_CU.bMsg1691 :=	xMsg16[91].Q;
	MM2VIS.bMsg1692 :=	xMsg16[92].Q;			OUT_CU.bMsg1692 :=	xMsg16[92].Q;
	MM2VIS.bMsg1693 :=	xMsg16[93].Q;			OUT_CU.bMsg1693 :=	xMsg16[93].Q;
	MM2VIS.bMsg1694 :=	xMsg16[94].Q;			OUT_CU.bMsg1694 :=	xMsg16[94].Q;
	MM2VIS.bMsg1695 :=	xMsg16[95].Q;			OUT_CU.bMsg1695 :=	xMsg16[95].Q;
	MM2VIS.bMsg1696 :=	xMsg16[96].Q;			OUT_CU.bMsg1696 :=	xMsg16[96].Q;
	MM2VIS.bMsg1697 :=	xMsg16[97].Q;			OUT_CU.bMsg1697 :=	xMsg16[97].Q;
	MM2VIS.bMsg1698 :=	xMsg16[98].Q;			OUT_CU.bMsg1698 :=	xMsg16[98].Q;
												OUT_CU.bMsg1699 :=	xMsg16[99].Q; 	(*remove duplicate MM2VIS handling*)
												OUT_CU.bMsg1700 :=	xMsg16[100].Q;  (*remove duplicate MM2VIS handling*)

	
	(* Forwarding of spare warning messages: *)
	MM2VIS.bMsg1701 :=	xMsg17[01].Q;			OUT_CU.bMsg1701 :=	xMsg17[01].Q;  	(*do not remove 1701-*)
	MM2VIS.bMsg1702 :=	xMsg17[02].Q;			OUT_CU.bMsg1702 :=	xMsg17[02].Q;
	MM2VIS.bMsg1703 :=	xMsg17[03].Q;			OUT_CU.bMsg1703 :=	xMsg17[03].Q;
	MM2VIS.bMsg1704 :=	xMsg17[04].Q;			OUT_CU.bMsg1704 :=	xMsg17[04].Q;
	MM2VIS.bMsg1705 :=	xMsg17[05].Q;			OUT_CU.bMsg1705 :=	xMsg17[05].Q;
	MM2VIS.bMsg1706 :=	xMsg17[06].Q;			OUT_CU.bMsg1706 :=	xMsg17[06].Q;
	MM2VIS.bMsg1707 :=	xMsg17[07].Q;			OUT_CU.bMsg1707 :=	xMsg17[07].Q;
	MM2VIS.bMsg1708 :=	xMsg17[08].Q;			OUT_CU.bMsg1708 :=	xMsg17[08].Q;
	MM2VIS.bMsg1709 :=	xMsg17[09].Q;			OUT_CU.bMsg1709 :=	xMsg17[09].Q;
	MM2VIS.bMsg1710 :=	xMsg17[10].Q;			OUT_CU.bMsg1710 :=	xMsg17[10].Q;
						
	MM2VIS.bMsg1711 :=	xMsg17[11].Q;			OUT_CU.bMsg1711 :=	xMsg17[11].Q;
	MM2VIS.bMsg1712 :=	xMsg17[12].Q;			OUT_CU.bMsg1712 :=	xMsg17[12].Q;
	MM2VIS.bMsg1713 :=	xMsg17[13].Q;			OUT_CU.bMsg1713 :=	xMsg17[13].Q;
	MM2VIS.bMsg1714 :=	xMsg17[14].Q;			OUT_CU.bMsg1714 :=	xMsg17[14].Q;
	MM2VIS.bMsg1715 :=	xMsg17[15].Q;			OUT_CU.bMsg1715 :=	xMsg17[15].Q;
	MM2VIS.bMsg1716 :=	xMsg17[16].Q;			OUT_CU.bMsg1716 :=	xMsg17[16].Q;
	MM2VIS.bMsg1717 :=	xMsg17[17].Q;			OUT_CU.bMsg1717 :=	xMsg17[17].Q;
	MM2VIS.bMsg1718 :=	xMsg17[18].Q;			OUT_CU.bMsg1718 :=	xMsg17[18].Q;
	MM2VIS.bMsg1719 :=	xMsg17[19].Q;			OUT_CU.bMsg1719 :=	xMsg17[19].Q;
	MM2VIS.bMsg1720 :=	xMsg17[20].Q;			OUT_CU.bMsg1720 :=	xMsg17[20].Q;
						
						
	MM2VIS.bMsg1721 :=	xMsg17[21].Q;			OUT_CU.bMsg1721 :=	xMsg17[21].Q;
	MM2VIS.bMsg1722 :=	xMsg17[22].Q;			OUT_CU.bMsg1722 :=	xMsg17[22].Q;
	MM2VIS.bMsg1723 :=	xMsg17[23].Q;			OUT_CU.bMsg1723 :=	xMsg17[23].Q;
	MM2VIS.bMsg1724 :=	xMsg17[24].Q;			OUT_CU.bMsg1724 :=	xMsg17[24].Q;
	MM2VIS.bMsg1725 :=	xMsg17[25].Q;			OUT_CU.bMsg1725 :=	xMsg17[25].Q;
	MM2VIS.bMsg1726 :=	xMsg17[26].Q;			OUT_CU.bMsg1726 :=	xMsg17[26].Q;
	MM2VIS.bMsg1727 :=	xMsg17[27].Q;			OUT_CU.bMsg1727 :=	xMsg17[27].Q;
	MM2VIS.bMsg1728 :=	xMsg17[28].Q;			OUT_CU.bMsg1728 :=	xMsg17[28].Q;
	MM2VIS.bMsg1729 :=	xMsg17[29].Q;			OUT_CU.bMsg1729 :=	xMsg17[29].Q;
	MM2VIS.bMsg1730 :=	xMsg17[30].Q;			OUT_CU.bMsg1730 :=	xMsg17[30].Q;
						
	MM2VIS.bMsg1731 :=	xMsg17[31].Q;			OUT_CU.bMsg1731 :=	xMsg17[31].Q;
	MM2VIS.bMsg1732 :=	xMsg17[32].Q;			OUT_CU.bMsg1732 :=	xMsg17[32].Q;
	MM2VIS.bMsg1733 :=	xMsg17[33].Q;			OUT_CU.bMsg1733 :=	xMsg17[33].Q;
	MM2VIS.bMsg1734 :=	xMsg17[34].Q;			OUT_CU.bMsg1734 :=	xMsg17[34].Q;
	MM2VIS.bMsg1735 :=	xMsg17[35].Q;			OUT_CU.bMsg1735 :=	xMsg17[35].Q;
	MM2VIS.bMsg1736 :=	xMsg17[36].Q;			OUT_CU.bMsg1736 :=	xMsg17[36].Q;
	MM2VIS.bMsg1737 :=	xMsg17[37].Q;			OUT_CU.bMsg1737 :=	xMsg17[37].Q;
	MM2VIS.bMsg1738 :=	xMsg17[38].Q;			OUT_CU.bMsg1738 :=	xMsg17[38].Q;
	MM2VIS.bMsg1739 :=	xMsg17[39].Q;			OUT_CU.bMsg1739 :=	xMsg17[39].Q;
	MM2VIS.bMsg1740 :=	xMsg17[40].Q;			OUT_CU.bMsg1740 :=	xMsg17[40].Q;
						
						
	MM2VIS.bMsg1741 :=	xMsg17[41].Q;			OUT_CU.bMsg1741 :=	xMsg17[41].Q;
	MM2VIS.bMsg1742 :=	xMsg17[42].Q;			OUT_CU.bMsg1742 :=	xMsg17[42].Q;
	MM2VIS.bMsg1743 :=	xMsg17[43].Q;			OUT_CU.bMsg1743 :=	xMsg17[43].Q;
	MM2VIS.bMsg1744 :=	xMsg17[44].Q;			OUT_CU.bMsg1744 :=	xMsg17[44].Q;
	MM2VIS.bMsg1745 :=	xMsg17[45].Q;			OUT_CU.bMsg1745 :=	xMsg17[45].Q;
	MM2VIS.bMsg1746 :=	xMsg17[46].Q;			OUT_CU.bMsg1746 :=	xMsg17[46].Q;
	MM2VIS.bMsg1747 :=	xMsg17[47].Q;			OUT_CU.bMsg1747 :=	xMsg17[47].Q;
	MM2VIS.bMsg1748 :=	xMsg17[48].Q;			OUT_CU.bMsg1748 :=	xMsg17[48].Q;
	MM2VIS.bMsg1749 :=	xMsg17[49].Q;			OUT_CU.bMsg1749 :=	xMsg17[49].Q;
	MM2VIS.bMsg1750 :=	xMsg17[50].Q;			OUT_CU.bMsg1750 :=	xMsg17[50].Q;
						
	MM2VIS.bMsg1751 :=	xMsg17[51].Q;			OUT_CU.bMsg1751 :=	xMsg17[51].Q;
	MM2VIS.bMsg1752 :=	xMsg17[52].Q;			OUT_CU.bMsg1752 :=	xMsg17[52].Q;
	MM2VIS.bMsg1753 :=	xMsg17[53].Q;			OUT_CU.bMsg1753 :=	xMsg17[53].Q;
	MM2VIS.bMsg1754 :=	xMsg17[54].Q;			OUT_CU.bMsg1754 :=	xMsg17[54].Q;
	MM2VIS.bMsg1755 :=	xMsg17[55].Q;			OUT_CU.bMsg1755 :=	xMsg17[55].Q;
	MM2VIS.bMsg1756 :=	xMsg17[56].Q;			OUT_CU.bMsg1756 :=	xMsg17[56].Q;
	MM2VIS.bMsg1757 :=	xMsg17[57].Q;			OUT_CU.bMsg1757 :=	xMsg17[57].Q;
	MM2VIS.bMsg1758 :=	xMsg17[58].Q;			OUT_CU.bMsg1758 :=	xMsg17[58].Q;
	MM2VIS.bMsg1759 :=	xMsg17[59].Q;			OUT_CU.bMsg1759 :=	xMsg17[59].Q;
	MM2VIS.bMsg1760 :=	xMsg17[60].Q;			OUT_CU.bMsg1760 :=	xMsg17[60].Q;
						
						
	MM2VIS.bMsg1761 :=	xMsg17[61].Q;			OUT_CU.bMsg1761 :=	xMsg17[61].Q;
	MM2VIS.bMsg1762 :=	xMsg17[62].Q;			OUT_CU.bMsg1762 :=	xMsg17[62].Q;
	MM2VIS.bMsg1763 :=	xMsg17[63].Q;			OUT_CU.bMsg1763 :=	xMsg17[63].Q;
	MM2VIS.bMsg1764 :=	xMsg17[64].Q;			OUT_CU.bMsg1764 :=	xMsg17[64].Q;
	MM2VIS.bMsg1765 :=	xMsg17[65].Q;			OUT_CU.bMsg1765 :=	xMsg17[65].Q;
	MM2VIS.bMsg1766 :=	xMsg17[66].Q;			OUT_CU.bMsg1766 :=	xMsg17[66].Q;
	MM2VIS.bMsg1767 :=	xMsg17[67].Q;			OUT_CU.bMsg1767 :=	xMsg17[67].Q;
	MM2VIS.bMsg1768 :=	xMsg17[68].Q;			OUT_CU.bMsg1768 :=	xMsg17[68].Q;
	MM2VIS.bMsg1769 :=	xMsg17[69].Q;			OUT_CU.bMsg1769 :=	xMsg17[69].Q;
	MM2VIS.bMsg1770 :=	xMsg17[70].Q;			OUT_CU.bMsg1770 :=	xMsg17[70].Q;
						
	MM2VIS.bMsg1771 :=	xMsg17[71].Q;			OUT_CU.bMsg1771 :=	xMsg17[71].Q;
	MM2VIS.bMsg1772 :=	xMsg17[72].Q;			OUT_CU.bMsg1772 :=	xMsg17[72].Q;
	MM2VIS.bMsg1773 :=	xMsg17[73].Q;			OUT_CU.bMsg1773 :=	xMsg17[73].Q;
	MM2VIS.bMsg1774 :=	xMsg17[74].Q;			OUT_CU.bMsg1774 :=	xMsg17[74].Q;
	MM2VIS.bMsg1775 :=	xMsg17[75].Q;			OUT_CU.bMsg1775 :=	xMsg17[75].Q;
	MM2VIS.bMsg1776 :=	xMsg17[76].Q;			OUT_CU.bMsg1776 :=	xMsg17[76].Q;
	MM2VIS.bMsg1777 :=	xMsg17[77].Q;			OUT_CU.bMsg1777 :=	xMsg17[77].Q;
	MM2VIS.bMsg1778 :=	xMsg17[78].Q;			OUT_CU.bMsg1778 :=	xMsg17[78].Q;
	MM2VIS.bMsg1779 :=	xMsg17[79].Q;			OUT_CU.bMsg1779 :=	xMsg17[79].Q;
	MM2VIS.bMsg1780 :=	xMsg17[80].Q;			OUT_CU.bMsg1780 :=	xMsg17[80].Q;
						
						
	MM2VIS.bMsg1781 :=	xMsg17[81].Q;			OUT_CU.bMsg1781 :=	xMsg17[81].Q;
	MM2VIS.bMsg1782 :=	xMsg17[82].Q;			OUT_CU.bMsg1782 :=	xMsg17[82].Q;
	MM2VIS.bMsg1783 :=	xMsg17[83].Q;			OUT_CU.bMsg1783 :=	xMsg17[83].Q;
	MM2VIS.bMsg1784 :=	xMsg17[84].Q;			OUT_CU.bMsg1784 :=	xMsg17[84].Q;
	MM2VIS.bMsg1785 :=	xMsg17[85].Q;			OUT_CU.bMsg1785 :=	xMsg17[85].Q;
	MM2VIS.bMsg1786 :=	xMsg17[86].Q;			OUT_CU.bMsg1786 :=	xMsg17[86].Q;
	MM2VIS.bMsg1787 :=	xMsg17[87].Q;			OUT_CU.bMsg1787 :=	xMsg17[87].Q;
	MM2VIS.bMsg1788 :=	xMsg17[88].Q;			OUT_CU.bMsg1788 :=	xMsg17[88].Q;
	MM2VIS.bMsg1789 :=	xMsg17[89].Q;			OUT_CU.bMsg1789 :=	xMsg17[89].Q;
	MM2VIS.bMsg1790 :=	xMsg17[90].Q;			OUT_CU.bMsg1790 :=	xMsg17[90].Q;
						
	MM2VIS.bMsg1791 :=	xMsg17[91].Q;			OUT_CU.bMsg1791 :=	xMsg17[91].Q;
	MM2VIS.bMsg1792 :=	xMsg17[92].Q;			OUT_CU.bMsg1792 :=	xMsg17[92].Q;
	MM2VIS.bMsg1793 :=	xMsg17[93].Q;			OUT_CU.bMsg1793 :=	xMsg17[93].Q;
	MM2VIS.bMsg1794 :=	xMsg17[94].Q;			OUT_CU.bMsg1794 :=	xMsg17[94].Q;
	MM2VIS.bMsg1795 :=	xMsg17[95].Q;			OUT_CU.bMsg1795 :=	xMsg17[95].Q;
	MM2VIS.bMsg1796 :=	xMsg17[96].Q;			OUT_CU.bMsg1796 :=	xMsg17[96].Q;
	MM2VIS.bMsg1797 :=	xMsg17[97].Q;			OUT_CU.bMsg1797 :=	xMsg17[97].Q;
	MM2VIS.bMsg1798 :=	xMsg17[98].Q;			OUT_CU.bMsg1798 :=	xMsg17[98].Q;
	MM2VIS.bMsg1799 :=	xMsg17[99].Q;			OUT_CU.bMsg1799 :=	xMsg17[99].Q;
	MM2VIS.bMsg1800 :=	xMsg17[100].Q;			OUT_CU.bMsg1800 :=	xMsg17[100].Q;		(*!corr.!*)
	
	MM2VIS.bMsg8701 :=	OUT_CU.bMsg8701 :=	xMsg87[01].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8702 :=	OUT_CU.bMsg8702 :=	xMsg87[02].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8703 :=	OUT_CU.bMsg8703 :=	xMsg87[03].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8704 :=	OUT_CU.bMsg8704 :=	xMsg87[04].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8705 :=	OUT_CU.bMsg8705 :=	xMsg87[05].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8706 :=	OUT_CU.bMsg8706 :=	xMsg87[06].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8707 :=	OUT_CU.bMsg8707 :=	xMsg87[07].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8708 :=	OUT_CU.bMsg8708 :=	xMsg87[08].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8709 :=	OUT_CU.bMsg8709 :=	xMsg87[09].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8710 :=	OUT_CU.bMsg8710 :=	xMsg87[10].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8711 :=	OUT_CU.bMsg8711 :=	xMsg87[11].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8712 :=	OUT_CU.bMsg8712 :=	xMsg87[12].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8713 :=	OUT_CU.bMsg8713 :=	xMsg87[13].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8714 :=	OUT_CU.bMsg8714 :=	xMsg87[14].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8715 :=	OUT_CU.bMsg8715 :=	xMsg87[15].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8716 :=	OUT_CU.bMsg8716 :=	xMsg87[16].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8717 :=	OUT_CU.bMsg8717 :=	xMsg87[17].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8718 :=	OUT_CU.bMsg8718 :=	xMsg87[18].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8719 :=	OUT_CU.bMsg8719 :=	xMsg87[19].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8720 :=	OUT_CU.bMsg8720 :=	xMsg87[20].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8721 :=	OUT_CU.bMsg8721 :=	xMsg87[21].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8722 :=	OUT_CU.bMsg8722 :=	xMsg87[22].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8723 :=	OUT_CU.bMsg8723 :=	xMsg87[23].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8724 :=	OUT_CU.bMsg8724 :=	xMsg87[24].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8725 :=	OUT_CU.bMsg8725 :=	xMsg87[25].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8726 :=	OUT_CU.bMsg8726 :=	xMsg87[26].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8727 :=	OUT_CU.bMsg8727 :=	xMsg87[27].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8728 :=	OUT_CU.bMsg8728 :=	xMsg87[28].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8729 :=	OUT_CU.bMsg8729 :=	xMsg87[29].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8730 :=	OUT_CU.bMsg8730 :=	xMsg87[30].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8731 :=	OUT_CU.bMsg8731 :=	xMsg87[31].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8732 :=	OUT_CU.bMsg8732 :=	xMsg87[32].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8733 :=	OUT_CU.bMsg8733 :=	xMsg87[33].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8734 :=	OUT_CU.bMsg8734 :=	xMsg87[34].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8735 :=	OUT_CU.bMsg8735 :=	xMsg87[35].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8736 :=	OUT_CU.bMsg8736 :=	xMsg87[36].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8737 :=	OUT_CU.bMsg8737 :=	xMsg87[37].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8738 :=	OUT_CU.bMsg8738 :=	xMsg87[38].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8739 :=	OUT_CU.bMsg8739 :=	xMsg87[39].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8740 :=	OUT_CU.bMsg8740 :=	xMsg87[40].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8741 :=	OUT_CU.bMsg8741 :=	xMsg87[41].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8742 :=	OUT_CU.bMsg8742 :=	xMsg87[42].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8743 :=	OUT_CU.bMsg8743 :=	xMsg87[43].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8744 :=	OUT_CU.bMsg8744 :=	xMsg87[44].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8745 :=	OUT_CU.bMsg8745 :=	xMsg87[45].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8746 :=	OUT_CU.bMsg8746 :=	xMsg87[46].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8747 :=	OUT_CU.bMsg8747 :=	xMsg87[47].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8748 :=	OUT_CU.bMsg8748 :=	xMsg87[48].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8749 :=	OUT_CU.bMsg8749 :=	xMsg87[49].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8750 :=	OUT_CU.bMsg8750 :=	xMsg87[50].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8751 :=	OUT_CU.bMsg8751 :=	xMsg87[51].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8752 :=	OUT_CU.bMsg8752 :=	xMsg87[52].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8753 :=	OUT_CU.bMsg8753 :=	xMsg87[53].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8754 :=	OUT_CU.bMsg8754 :=	xMsg87[54].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8755 :=	OUT_CU.bMsg8755 :=	xMsg87[55].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8756 :=	OUT_CU.bMsg8756 :=	xMsg87[56].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8757 :=	OUT_CU.bMsg8757 :=	xMsg87[57].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8758 :=	OUT_CU.bMsg8758 :=	xMsg87[58].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8759 :=	OUT_CU.bMsg8759 :=	xMsg87[59].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8760 :=	OUT_CU.bMsg8760 :=	xMsg87[60].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8761 :=	OUT_CU.bMsg8761 :=	xMsg87[61].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8762 :=	OUT_CU.bMsg8762 :=	xMsg87[62].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8763 :=	OUT_CU.bMsg8763 :=	xMsg87[63].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8764 :=	OUT_CU.bMsg8764 :=	xMsg87[64].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8765 :=	OUT_CU.bMsg8765 :=	xMsg87[65].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8766 :=	OUT_CU.bMsg8766 :=	xMsg87[66].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8767 :=	OUT_CU.bMsg8767 :=	xMsg87[67].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8768 :=	OUT_CU.bMsg8768 :=	xMsg87[68].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8769 :=	OUT_CU.bMsg8769 :=	xMsg87[69].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8770 :=	OUT_CU.bMsg8770 :=	xMsg87[70].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8771 :=	OUT_CU.bMsg8771 :=	xMsg87[71].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8772 :=	OUT_CU.bMsg8772 :=	xMsg87[72].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8773 :=	OUT_CU.bMsg8773 :=	xMsg87[73].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8774 :=	OUT_CU.bMsg8774 :=	xMsg87[74].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8775 :=	OUT_CU.bMsg8775 :=	xMsg87[75].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8776 :=	OUT_CU.bMsg8776 :=	xMsg87[76].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8777 :=	OUT_CU.bMsg8777 :=	xMsg87[77].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8778 :=	OUT_CU.bMsg8778 :=	xMsg87[78].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8779 :=	OUT_CU.bMsg8779 :=	xMsg87[79].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8780 :=	OUT_CU.bMsg8780 :=	xMsg87[80].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8781 :=	OUT_CU.bMsg8781 :=	xMsg87[81].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8782 :=	OUT_CU.bMsg8782 :=	xMsg87[82].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8783 :=	OUT_CU.bMsg8783 :=	xMsg87[83].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8784 :=	OUT_CU.bMsg8784 :=	xMsg87[84].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8785 :=	OUT_CU.bMsg8785 :=	xMsg87[85].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8786 :=	OUT_CU.bMsg8786 :=	xMsg87[86].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8787 :=	OUT_CU.bMsg8787 :=	xMsg87[87].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8788 :=	OUT_CU.bMsg8788 :=	xMsg87[88].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8789 :=	OUT_CU.bMsg8789 :=	xMsg87[89].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8790 :=	OUT_CU.bMsg8790 :=	xMsg87[90].Q;	 (*import HMI Extension *)
	
	MM2VIS.bMsg8791 :=	OUT_CU.bMsg8791 :=	xMsg87[91].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8792 :=	OUT_CU.bMsg8792 :=	xMsg87[92].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8793 :=	OUT_CU.bMsg8793 :=	xMsg87[93].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8794 :=	OUT_CU.bMsg8794 :=	xMsg87[94].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8795 :=	OUT_CU.bMsg8795 :=	xMsg87[95].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8796 :=	OUT_CU.bMsg8796 :=	xMsg87[96].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8797 :=	OUT_CU.bMsg8797 :=	xMsg87[97].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8798 :=	OUT_CU.bMsg8798 :=	xMsg87[98].Q;	 (*import HMI Extension *)
	MM2VIS.bMsg8799 :=	OUT_CU.bMsg8799 :=	xMsg87[99].Q;	 (*import HMI Extension *)
(*	MM2VIS.bMsg4300 :=	OUT_CU.bMsg4300 :=	xMsg87[100].Q;	 (*import HMI Extension  OLD do not use anymore *)
	
	(* forwarding of operating messages  *)
	
	xMsg3232.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3232.Set		:=	OUT_CU.bMsg3232;		(* B3232 reserve operating message 1 *)
	IF xMsg3232.Set THEN iReset_Msg3232 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3232 := LIMIT(0, iReset_Msg3232 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3232.Reset 		:= 	iReset_Msg3232 < 1;		//.Reset := TRUE;
	xMsg3232();
	MM2VIS.bMsg3232		:=	xMsg3232.Q;

	xMsg3233.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3233.Set		:=	OUT_CU.bMsg3233;		(* B3233 reserve operating message 2 *)
	IF xMsg3233.Set THEN iReset_Msg3233 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3233 := LIMIT(0, iReset_Msg3233 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3233.Reset 		:= 	iReset_Msg3233 < 1;		//.Reset := TRUE;
	xMsg3233();
	MM2VIS.bMsg3233		:=	xMsg3233.Q;
	
	xMsg3234.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3234.Set		:=	OUT_CU.bMsg3234;		(* B3234 reserve operating message 3 *)
	IF xMsg3234.Set THEN iReset_Msg3234 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3234 := LIMIT(0, iReset_Msg3234 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3234.Reset 		:= 	iReset_Msg3234 < 1;		//.Reset := TRUE;
	xMsg3234();
	MM2VIS.bMsg3234		:=	xMsg3234.Q;
	
	xMsg3235.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3235.Set		:=	OUT_CU.bMsg3235;		(* B3235 reserve operating message 4 *)
	IF xMsg3235.Set THEN iReset_Msg3235 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3235 := LIMIT(0, iReset_Msg3235 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3235.Reset 		:= 	iReset_Msg3235 < 1;		//.Reset := TRUE;
	xMsg3235();
	MM2VIS.bMsg3235		:=	xMsg3235.Q;

	xMsg3236.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3236.Set		:=	OUT_CU.bMsg3236;		(* B3236 reserve operating message 5 *)
	IF xMsg3236.Set THEN iReset_Msg3236 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3236 := LIMIT(0, iReset_Msg3236 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3236.Reset 		:= 	iReset_Msg3236 < 1;		//.Reset := TRUE;
	xMsg3236();
	MM2VIS.bMsg3236		:=	xMsg3236.Q;
	
	xMsg3237.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3237.Set		:=	OUT_CU.bMsg3237;		(* B3237 reserve operating message 6 *)
	IF xMsg3237.Set THEN iReset_Msg3237 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3237 := LIMIT(0, iReset_Msg3237 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3237.Reset 		:= 	iReset_Msg3237 < 1;		//.Reset := TRUE;
	xMsg3237();
	MM2VIS.bMsg3237		:=	xMsg3237.Q;
	(*----------------------------------------------------------------------*)	
	
	xMsg3250.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3250.Set		:=	OUT_CU.bMsg3250;		(* B3250 reserve operating message 7 *)
	IF xMsg3250.Set THEN iReset_Msg3250 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3250 := LIMIT(0, iReset_Msg3250 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3250.Reset 		:= 	iReset_Msg3250 < 1;		//.Reset := TRUE;
	xMsg3250();
	MM2VIS.bMsg3250		:=	xMsg3250.Q;

	xMsg3251.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3251.Set		:=	OUT_CU.bMsg3251;		(* B3251 reserve operating message 8 *)
	IF xMsg3251.Set THEN iReset_Msg3251 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3251 := LIMIT(0, iReset_Msg3251 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3251.Reset 		:= 	iReset_Msg3251 < 1;		//.Reset := TRUE;
	xMsg3251();
	MM2VIS.bMsg3251		:=	xMsg3251.Q;
	(*----------------------------------------------------------------------*)	
			
	xMsg36[01].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[01].Set		:=	OUT_CU.bMsg3601;		(* B3601 reserve operating message *)
	IF xMsg36[01].Set THEN iReset_Msg36[01] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[01] := LIMIT(0, iReset_Msg36[01] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[01].Reset	:= 	(iReset_Msg36[01] < 1);		//.Reset := TRUE;
	xMsg36[01]();
	MM2VIS.bMsg3601		:=	xMsg36[01].Q;


	xMsg36[02].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[02].Set		:=	OUT_CU.bMsg3602;			(* B3602 reserve operating message *)
	IF xMsg36[02].Set THEN iReset_Msg36[02] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[02] := LIMIT(0, iReset_Msg36[02] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[02].Reset 	:= 	(iReset_Msg36[02] < 1);		//.Reset := TRUE;
	xMsg36[02]();
	MM2VIS.bMsg3602		:=	xMsg36[02].Q;


	xMsg36[03].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[03].Set		:=	OUT_CU.bMsg3603;		(* B3603 reserve operating message *)
	IF xMsg36[03].Set THEN iReset_Msg36[03] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[03] := LIMIT(0, iReset_Msg36[03] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[03].Reset 	:= 	(iReset_Msg36[03] < 1);		//.Reset := TRUE;
	xMsg36[03]();
	MM2VIS.bMsg3603		:=	xMsg36[03].Q;


	xMsg36[04].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[04].Set		:=	OUT_CU.bMsg3604;		(* B3604 reserve operating message *)
	IF xMsg36[04].Set THEN iReset_Msg36[04] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[04] := LIMIT(0, iReset_Msg36[04] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[04].Reset 	:= 	(iReset_Msg36[04] < 1);		//.Reset := TRUE;
	xMsg36[04]();
	MM2VIS.bMsg3604		:=	xMsg36[04].Q;


	xMsg36[05].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[05].Set		:=	OUT_CU.bMsg3605;		(* B3605 reserve operating message *)
	IF xMsg36[05].Set THEN iReset_Msg36[05] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[05] := LIMIT(0, iReset_Msg36[05] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[05].Reset 	:= 	(iReset_Msg36[05] < 1);		//.Reset := TRUE;
	xMsg36[05]();
	MM2VIS.bMsg3605		:=	xMsg36[05].Q;


	xMsg36[06].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[06].Set		:=	OUT_CU.bMsg3606;		(* B3606 reserve operating message *)
	IF xMsg36[06].Set THEN iReset_Msg36[06] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[06] := LIMIT(0, iReset_Msg36[06] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[06].Reset 	:= 	(iReset_Msg36[06] < 1);		//.Reset := TRUE;
	xMsg36[06]();
	MM2VIS.bMsg3606		:=	xMsg36[06].Q;


	xMsg36[07].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[07].Set		:=	OUT_CU.bMsg3607;		(* B3607 reserve operating message *)
	IF xMsg36[07].Set THEN iReset_Msg36[07] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[07] := LIMIT(0, iReset_Msg36[07] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[07].Reset 	:= 	(iReset_Msg36[07] < 1);		//.Reset := TRUE;
	xMsg36[07]();
	MM2VIS.bMsg3607		:=	xMsg36[07].Q;


	xMsg36[08].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[08].Set		:=	OUT_CU.bMsg3608;		(* B3608 reserve operating message *)
	IF xMsg36[08].Set THEN iReset_Msg36[08] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[08] := LIMIT(0, iReset_Msg36[08] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[08].Reset 	:= 	(iReset_Msg36[08] < 1);		//.Reset := TRUE;
	xMsg36[08]();
	MM2VIS.bMsg3608		:=	xMsg36[08].Q;


	xMsg36[09].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[09].Set		:=	OUT_CU.bMsg3609;		(* B3609 reserve operating message *)
	IF xMsg36[09].Set THEN iReset_Msg36[09] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[09] := LIMIT(0, iReset_Msg36[09] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[09].Reset 	:= 	(iReset_Msg36[09] < 1);		//.Reset := TRUE;
	xMsg36[09]();
	MM2VIS.bMsg3609		:=	xMsg36[09].Q;


	xMsg36[10].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[10].Set		:=	OUT_CU.bMsg3610;		(* B3610 reserve operating message *)
	IF xMsg36[10].Set THEN iReset_Msg36[10] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[10] := LIMIT(0, iReset_Msg36[10] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[10].Reset 	:= 	(iReset_Msg36[10] < 1);		//.Reset := TRUE;
	xMsg36[10]();
	MM2VIS.bMsg3610		:=	xMsg36[10].Q;
	(*----------------------------------------------------------------------*)				

	xMsg36[11].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[11].Set		:=	OUT_CU.bMsg3611;(* B3611 reserve operating message *)
	IF xMsg36[11].Set THEN iReset_Msg36[11] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[11] := LIMIT(0, iReset_Msg36[11] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[11].Reset 	:= 	(iReset_Msg36[11] < 1);		//.Reset := TRUE;
	xMsg36[11]();
	MM2VIS.bMsg3611		:=	xMsg36[11].Q;

	xMsg36[12].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[12].Set		:=	OUT_CU.bMsg3612;(* B3612 reserve operating message *)
	IF xMsg36[12].Set THEN iReset_Msg36[12] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[12] := LIMIT(0, iReset_Msg36[12] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[12].Reset 	:= 	(iReset_Msg36[12] < 1);		//.Reset := TRUE;
	xMsg36[12]();
	MM2VIS.bMsg3612		:=	xMsg36[12].Q;

	xMsg36[13].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[13].Set		:=	OUT_CU.bMsg3613;(* B3613 reserve operating message *)
	IF xMsg36[13].Set THEN iReset_Msg36[13] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[13] := LIMIT(0, iReset_Msg36[13] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[13].Reset 	:= 	(iReset_Msg36[13] < 1);		//.Reset := TRUE;
	xMsg36[13]();
	MM2VIS.bMsg3613		:=	xMsg36[13].Q;

	xMsg36[14].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[14].Set		:=	OUT_CU.bMsg3614;(* B3614 reserve operating message *)
	IF xMsg36[14].Set THEN iReset_Msg36[14] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[14] := LIMIT(0, iReset_Msg36[14] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[14].Reset 	:= 	(iReset_Msg36[14] < 1);		//.Reset := TRUE;
	xMsg36[14]();
	MM2VIS.bMsg3614		:=	xMsg36[14].Q;

	xMsg36[15].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[15].Set		:=	OUT_CU.bMsg3615;(* B3615 reserve operating message *)
	IF xMsg36[15].Set THEN iReset_Msg36[15] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[15] := LIMIT(0, iReset_Msg36[15] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[15].Reset 	:= 	(iReset_Msg36[15] < 1);		//.Reset := TRUE;
	xMsg36[15]();
	MM2VIS.bMsg3615		:=	xMsg36[15].Q;

	xMsg36[16].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[16].Set		:=	OUT_CU.bMsg3616;(* B3616 reserve operating message *)
	IF xMsg36[16].Set THEN iReset_Msg36[16] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[16] := LIMIT(0, iReset_Msg36[16] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[16].Reset 	:= 	(iReset_Msg36[16] < 1);		//.Reset := TRUE;
	xMsg36[16]();
	MM2VIS.bMsg3616		:=	xMsg36[16].Q;

	xMsg36[17].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[17].Set		:=	OUT_CU.bMsg3617;(* B3617 reserve operating message *)
	IF xMsg36[17].Set THEN iReset_Msg36[17] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[17] := LIMIT(0, iReset_Msg36[17] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[17].Reset 	:= 	(iReset_Msg36[17] < 1);		//.Reset := TRUE;
	xMsg36[17]();
	MM2VIS.bMsg3617		:=	xMsg36[17].Q;

	xMsg36[18].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[18].Set		:=	OUT_CU.bMsg3618;(* B3618 reserve operating message *)
	IF xMsg36[18].Set THEN iReset_Msg36[18] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[18] := LIMIT(0, iReset_Msg36[18] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[18].Reset 	:= 	(iReset_Msg36[18] < 1);		//.Reset := TRUE;
	xMsg36[18]();
	MM2VIS.bMsg3618		:=	xMsg36[18].Q;

	xMsg36[19].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[19].Set		:=	OUT_CU.bMsg3619;(* B3619 reserve operating message *)
	IF xMsg36[19].Set THEN iReset_Msg36[19] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[19] := LIMIT(0, iReset_Msg36[19] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[19].Reset 	:= 	(iReset_Msg36[19] < 1);		//.Reset := TRUE;
	xMsg36[19]();
	MM2VIS.bMsg3619		:=	xMsg36[19].Q;

	xMsg36[20].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[20].Set		:=	OUT_CU.bMsg3620;(* B3620 reserve operating message *)
	IF xMsg36[20].Set THEN iReset_Msg36[20] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[20] := LIMIT(0, iReset_Msg36[20] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[20].Reset 	:= 	(iReset_Msg36[20] < 1);		//.Reset := TRUE;
	xMsg36[20]();
	MM2VIS.bMsg3620		:=	xMsg36[20].Q;
	(*----------------------------------------------------------------------*)				
				
	xMsg36[21].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[21].Set		:=	OUT_CU.bMsg3621;(* B3621 reserve operating message *)
	IF xMsg36[21].Set THEN iReset_Msg36[21] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[21] := LIMIT(0, iReset_Msg36[21] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[21].Reset 	:= 	(iReset_Msg36[21] < 1);		//.Reset := TRUE;
	xMsg36[21]();
	MM2VIS.bMsg3621		:=	xMsg36[21].Q;

	xMsg36[22].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[22].Set		:=	OUT_CU.bMsg3622;(* B3622 reserve operating message *)
	IF xMsg36[22].Set THEN iReset_Msg36[22] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[22] := LIMIT(0, iReset_Msg36[22] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[22].Reset 	:= 	(iReset_Msg36[22] < 1);		//.Reset := TRUE;
	xMsg36[22]();
	MM2VIS.bMsg3622		:=	xMsg36[22].Q;

	xMsg36[23].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[23].Set		:=	OUT_CU.bMsg3623;(* B3623 reserve operating message *)
	IF xMsg36[23].Set THEN iReset_Msg36[23] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[23] := LIMIT(0, iReset_Msg36[23] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[23].Reset 	:= 	(iReset_Msg36[23] < 1);		//.Reset := TRUE;
	xMsg36[23]();
	MM2VIS.bMsg3623		:=	xMsg36[23].Q;

	xMsg36[24].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[24].Set		:=	OUT_CU.bMsg3624;(* B3624 reserve operating message *)
	IF xMsg36[24].Set THEN iReset_Msg36[24] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[24] := LIMIT(0, iReset_Msg36[24] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[24].Reset 	:= 	(iReset_Msg36[24] < 1);		//.Reset := TRUE;
	xMsg36[24]();
	MM2VIS.bMsg3624		:=	xMsg36[24].Q;

	xMsg36[25].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[25].Set		:=	OUT_CU.bMsg3625;(* B3625 reserve operating message *)
	IF xMsg36[25].Set THEN iReset_Msg36[25] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[25] := LIMIT(0, iReset_Msg36[25] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[25].Reset 	:= 	(iReset_Msg36[25] < 1);		//.Reset := TRUE;
	xMsg36[25]();
	MM2VIS.bMsg3625		:=	xMsg36[25].Q;

	xMsg36[26].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[26].Set		:=	OUT_CU.bMsg3626;(* B3626 reserve operating message *)
	IF xMsg36[26].Set THEN iReset_Msg36[26] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[26] := LIMIT(0, iReset_Msg36[26] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[26].Reset 	:= 	(iReset_Msg36[26] < 1);		//.Reset := TRUE;
	xMsg36[26]();
	MM2VIS.bMsg3626		:=	xMsg36[26].Q;

	xMsg36[27].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[27].Set		:=	OUT_CU.bMsg3627;(* B3627 reserve operating message *)
	IF xMsg36[27].Set THEN iReset_Msg36[27] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[27] := LIMIT(0, iReset_Msg36[27] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[27].Reset 	:= 	(iReset_Msg36[27] < 1);		//.Reset := TRUE;
	xMsg36[27]();
	MM2VIS.bMsg3627		:=	xMsg36[27].Q;

	xMsg36[28].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[28].Set		:=	OUT_CU.bMsg3628;(* B3628 reserve operating message *)
	IF xMsg36[28].Set THEN iReset_Msg36[28] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[28] := LIMIT(0, iReset_Msg36[28] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[28].Reset 	:= 	(iReset_Msg36[28] < 1);		//.Reset := TRUE;
	xMsg36[28]();
	MM2VIS.bMsg3628		:=	xMsg36[28].Q;

	xMsg36[29].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[29].Set		:=	OUT_CU.bMsg3629;(* B3629 reserve operating message *)
	IF xMsg36[29].Set THEN iReset_Msg36[29] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[29] := LIMIT(0, iReset_Msg36[29] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[29].Reset 	:= 	(iReset_Msg36[29] < 1);		//.Reset := TRUE;
	xMsg36[29]();
	MM2VIS.bMsg3629		:=	xMsg36[29].Q;

	xMsg36[30].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[30].Set		:=	OUT_CU.bMsg3630;(* B3630 reserve operating message *)
	IF xMsg36[30].Set THEN iReset_Msg36[30] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[30] := LIMIT(0, iReset_Msg36[30] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[30].Reset 	:= 	(iReset_Msg36[30] < 1);		//.Reset := TRUE;
	xMsg36[30]();
	MM2VIS.bMsg3630		:=	xMsg36[30].Q;
	(*----------------------------------------------------------------------*)
				
	xMsg36[31].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[31].Set		:=	OUT_CU.bMsg3631;(* B3631 reserve operating message *)
	IF xMsg36[31].Set THEN iReset_Msg36[31] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[31] := LIMIT(0, iReset_Msg36[31] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[31].Reset 	:= 	(iReset_Msg36[31] < 1);		//.Reset := TRUE;
	xMsg36[31]();
	MM2VIS.bMsg3631		:=	xMsg36[31].Q;

	xMsg36[32].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[32].Set		:=	OUT_CU.bMsg3632;(* B3632 reserve operating message *)
	IF xMsg36[32].Set THEN iReset_Msg36[32] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[32] := LIMIT(0, iReset_Msg36[32] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[32].Reset 	:= 	(iReset_Msg36[32] < 1);		//.Reset := TRUE;
	xMsg36[32]();
	MM2VIS.bMsg3632		:=	xMsg36[32].Q;

	xMsg36[33].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[33].Set		:=	OUT_CU.bMsg3633;(* B3633 reserve operating message *)
	IF xMsg36[33].Set THEN iReset_Msg36[33] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[33] := LIMIT(0, iReset_Msg36[33] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[33].Reset 	:= 	(iReset_Msg36[33] < 1);		//.Reset := TRUE;
	xMsg36[33]();
	MM2VIS.bMsg3633		:=	xMsg36[33].Q;

	xMsg36[34].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[34].Set		:=	OUT_CU.bMsg3634;(* B3634 reserve operating message *)
	IF xMsg36[34].Set THEN iReset_Msg36[34] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[34] := LIMIT(0, iReset_Msg36[34] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[34].Reset 	:= 	(iReset_Msg36[34] < 1);		//.Reset := TRUE;
	xMsg36[34]();
	MM2VIS.bMsg3634		:=	xMsg36[34].Q;

	xMsg36[35].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[35].Set		:=	OUT_CU.bMsg3635;(* B3635 reserve operating message *)
	IF xMsg36[35].Set THEN iReset_Msg36[35] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[35] := LIMIT(0, iReset_Msg36[35] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[35].Reset 	:= 	(iReset_Msg36[35] < 1);		//.Reset := TRUE;
	xMsg36[35]();
	MM2VIS.bMsg3635		:=	xMsg36[35].Q;

	xMsg36[36].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[36].Set		:=	OUT_CU.bMsg3636;(* B3636 reserve operating message *)
	IF xMsg36[36].Set THEN iReset_Msg36[36] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[36] := LIMIT(0, iReset_Msg36[36] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[36].Reset 	:= 	(iReset_Msg36[36] < 1);		//.Reset := TRUE;
	xMsg36[36]();
	MM2VIS.bMsg3636		:=	xMsg36[36].Q;

	xMsg36[37].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[37].Set		:=	OUT_CU.bMsg3637;(* B3637 reserve operating message *)
	IF xMsg36[37].Set THEN iReset_Msg36[37] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[37] := LIMIT(0, iReset_Msg36[37] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[37].Reset 	:= 	(iReset_Msg36[37] < 1);		//.Reset := TRUE;
	xMsg36[37]();
	MM2VIS.bMsg3637		:=	xMsg36[37].Q;

	xMsg36[38].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[38].Set		:=	OUT_CU.bMsg3638;(* B3638 reserve operating message *)
	IF xMsg36[38].Set THEN iReset_Msg36[38] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[38] := LIMIT(0, iReset_Msg36[38] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[38].Reset 	:= 	(iReset_Msg36[38] < 1);		//.Reset := TRUE;
	xMsg36[38]();
	MM2VIS.bMsg3638		:=	xMsg36[38].Q;

	xMsg36[39].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[39].Set		:=	OUT_CU.bMsg3639;(* B3639 reserve operating message *)
	IF xMsg36[39].Set THEN iReset_Msg36[39] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[39] := LIMIT(0, iReset_Msg36[39] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[39].Reset 	:= 	(iReset_Msg36[39] < 1);		//.Reset := TRUE;
	xMsg36[39]();
	MM2VIS.bMsg3639		:=	xMsg36[39].Q;

	xMsg36[40].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[40].Set		:=	OUT_CU.bMsg3640;(* B3640 reserve operating message *)
	IF xMsg36[40].Set THEN iReset_Msg36[40] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[40] := LIMIT(0, iReset_Msg36[40] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[40].Reset 	:= 	(iReset_Msg36[40] < 1);		//.Reset := TRUE;
	xMsg36[40]();
	MM2VIS.bMsg3640		:=	xMsg36[40].Q;
	(*----------------------------------------------------------------------*)	
			
	xMsg36[41].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[41].Set		:=	OUT_CU.bMsg3641;(* B3641 reserve operating message *)
	IF xMsg36[41].Set THEN iReset_Msg36[41] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[41] := LIMIT(0, iReset_Msg36[41] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[41].Reset 	:= 	(iReset_Msg36[41] < 1);		//.Reset := TRUE;
	xMsg36[41]();
	MM2VIS.bMsg3641		:=	xMsg36[41].Q;

	xMsg36[42].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[42].Set		:=	OUT_CU.bMsg3642;(* B3642 reserve operating message *)
	IF xMsg36[42].Set THEN iReset_Msg36[42] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[42] := LIMIT(0, iReset_Msg36[42] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[42].Reset 	:= 	(iReset_Msg36[42] < 1);		//.Reset := TRUE;
	xMsg36[42]();
	MM2VIS.bMsg3642		:=	xMsg36[42].Q;

	xMsg36[43].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[43].Set		:=	OUT_CU.bMsg3643;(* B3643 reserve operating message *)
	IF xMsg36[43].Set THEN iReset_Msg36[43] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[43] := LIMIT(0, iReset_Msg36[43] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[43].Reset 	:= 	(iReset_Msg36[43] < 1);		//.Reset := TRUE;
	xMsg36[43]();
	MM2VIS.bMsg3643		:=	xMsg36[43].Q;

	xMsg36[44].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[44].Set		:=	OUT_CU.bMsg3644;(* B3644 reserve operating message *)
	IF xMsg36[44].Set THEN iReset_Msg36[44] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[44] := LIMIT(0, iReset_Msg36[44] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[44].Reset 	:= 	(iReset_Msg36[44] < 1);		//.Reset := TRUE;
	xMsg36[44]();
	MM2VIS.bMsg3644		:=	xMsg36[44].Q;

	xMsg36[45].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[45].Set		:=	OUT_CU.bMsg3645;(* B3645 reserve operating message *)
	IF xMsg36[45].Set THEN iReset_Msg36[45] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[45] := LIMIT(0, iReset_Msg36[45] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[45].Reset 	:= 	(iReset_Msg36[45] < 1);		//.Reset := TRUE;
	xMsg36[45]();
	MM2VIS.bMsg3645		:=	xMsg36[45].Q;

	xMsg36[46].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[46].Set		:=	OUT_CU.bMsg3646;(* B3646 reserve operating message *)
	IF xMsg36[46].Set THEN iReset_Msg36[46] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[46] := LIMIT(0, iReset_Msg36[46] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[46].Reset 	:= 	(iReset_Msg36[46] < 1);		//.Reset := TRUE;
	xMsg36[46]();
	MM2VIS.bMsg3646		:=	xMsg36[46].Q;

	xMsg36[47].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[47].Set		:=	OUT_CU.bMsg3647;(* B3647 reserve operating message *)
	IF xMsg36[47].Set THEN iReset_Msg36[47] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[47] := LIMIT(0, iReset_Msg36[47] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[47].Reset 	:= 	(iReset_Msg36[47] < 1);		//.Reset := TRUE;
	xMsg36[47]();
	MM2VIS.bMsg3647		:=	xMsg36[47].Q;

	xMsg36[48].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[48].Set		:=	OUT_CU.bMsg3648;(* B3648 reserve operating message *)
	IF xMsg36[48].Set THEN iReset_Msg36[48] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[48] := LIMIT(0, iReset_Msg36[48] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[48].Reset 	:= 	(iReset_Msg36[48] < 1);		//.Reset := TRUE;
	xMsg36[48]();
	MM2VIS.bMsg3648		:=	xMsg36[48].Q;

	xMsg36[49].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[49].Set		:=	OUT_CU.bMsg3649;(* B3649 reserve operating message *)
	IF xMsg36[49].Set THEN iReset_Msg36[49] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[49] := LIMIT(0, iReset_Msg36[49] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[49].Reset 	:= 	(iReset_Msg36[49] < 1);		//.Reset := TRUE;
	xMsg36[49]();
	MM2VIS.bMsg3649		:=	xMsg36[49].Q;

	xMsg36[50].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[50].Set		:=	OUT_CU.bMsg3650;(* B3650 reserve operating message *)
	IF xMsg36[50].Set THEN iReset_Msg36[50] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[50] := LIMIT(0, iReset_Msg36[50] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[50].Reset 	:= 	(iReset_Msg36[50] < 1);		//.Reset := TRUE;
	xMsg36[50]();
	MM2VIS.bMsg3650		:=	xMsg36[50].Q;			
	(*----------------------------------------------------------------------*)
				
	xMsg36[51].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[51].Set		:=	OUT_CU.bMsg3651;(* B3651 reserve operating message *)
	IF xMsg36[51].Set THEN iReset_Msg36[51] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[51] := LIMIT(0, iReset_Msg36[51] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[51].Reset 	:= 	(iReset_Msg36[51] < 1);		//.Reset := TRUE;
	xMsg36[51]();
	MM2VIS.bMsg3651		:=	xMsg36[51].Q;

	xMsg36[52].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[52].Set		:=	OUT_CU.bMsg3652;(* B3652 reserve operating message *)
	IF xMsg36[52].Set THEN iReset_Msg36[52] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[52] := LIMIT(0, iReset_Msg36[52] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[52].Reset 	:= 	(iReset_Msg36[52] < 1);		//.Reset := TRUE;
	xMsg36[52]();
	MM2VIS.bMsg3652		:=	xMsg36[52].Q;

	xMsg36[53].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[53].Set		:=	OUT_CU.bMsg3653;(* B3653 reserve operating message *)
	IF xMsg36[53].Set THEN iReset_Msg36[53] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[53] := LIMIT(0, iReset_Msg36[53] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[53].Reset 	:= 	(iReset_Msg36[53] < 1);		//.Reset := TRUE;
	xMsg36[53]();
	MM2VIS.bMsg3653		:=	xMsg36[53].Q;

	xMsg36[54].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[54].Set		:=	OUT_CU.bMsg3654;(* B3654 reserve operating message *)
	IF xMsg36[54].Set THEN iReset_Msg36[54] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[54] := LIMIT(0, iReset_Msg36[54] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[54].Reset 	:= 	(iReset_Msg36[54] < 1);		//.Reset := TRUE;
	xMsg36[54]();
	MM2VIS.bMsg3654		:=	xMsg36[54].Q;

	xMsg36[55].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[55].Set		:=	OUT_CU.bMsg3655;(* B3655 reserve operating message *)
	IF xMsg36[55].Set THEN iReset_Msg36[55] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[55] := LIMIT(0, iReset_Msg36[55] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[55].Reset 	:= 	(iReset_Msg36[55] < 1);		//.Reset := TRUE;
	xMsg36[55]();
	MM2VIS.bMsg3655		:=	xMsg36[55].Q;

	xMsg36[56].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[56].Set		:=	OUT_CU.bMsg3656;(* B3656 reserve operating message *)
	IF xMsg36[56].Set THEN iReset_Msg36[56] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[56] := LIMIT(0, iReset_Msg36[56] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[56].Reset 	:= 	(iReset_Msg36[56] < 1);		//.Reset := TRUE;
	xMsg36[56]();
	MM2VIS.bMsg3656		:=	xMsg36[56].Q;

	xMsg36[57].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[57].Set		:=	OUT_CU.bMsg3657;(* B3657 reserve operating message *)
	IF xMsg36[57].Set THEN iReset_Msg36[57] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[57] := LIMIT(0, iReset_Msg36[57] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[57].Reset 	:= 	(iReset_Msg36[57] < 1);		//.Reset := TRUE;
	xMsg36[57]();
	MM2VIS.bMsg3657		:=	xMsg36[57].Q;

	xMsg36[58].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[58].Set		:=	OUT_CU.bMsg3658;(* B3658 reserve operating message *)
	IF xMsg36[58].Set THEN iReset_Msg36[58] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[58] := LIMIT(0, iReset_Msg36[58] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[58].Reset 	:= 	(iReset_Msg36[58] < 1);		//.Reset := TRUE;
	xMsg36[58]();
	MM2VIS.bMsg3658		:=	xMsg36[58].Q;

	xMsg36[59].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[59].Set		:=	OUT_CU.bMsg3659;(* B3659 reserve operating message *)
	IF xMsg36[59].Set THEN iReset_Msg36[59] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[59] := LIMIT(0, iReset_Msg36[59] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[59].Reset 	:= 	(iReset_Msg36[59] < 1);		//.Reset := TRUE;
	xMsg36[59]();
	MM2VIS.bMsg3659		:=	xMsg36[59].Q;

	xMsg36[60].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[60].Set		:=	OUT_CU.bMsg3660;(* B3660 reserve operating message *)
	IF xMsg36[60].Set THEN iReset_Msg36[60] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[60] := LIMIT(0, iReset_Msg36[60] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[60].Reset 	:= 	(iReset_Msg36[60] < 1);		//.Reset := TRUE;
	xMsg36[60]();
	MM2VIS.bMsg3660		:=	xMsg36[60].Q;			
	(*----------------------------------------------------------------------*)				
				
	xMsg36[61].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[61].Set		:=	OUT_CU.bMsg3661;(* B3661 reserve operating message *)
	IF xMsg36[61].Set THEN iReset_Msg36[61] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[61] := LIMIT(0, iReset_Msg36[61] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[61].Reset 	:= 	(iReset_Msg36[61] < 1);		//.Reset := TRUE;
	xMsg36[61]();
	MM2VIS.bMsg3661		:=	xMsg36[61].Q;

	xMsg36[62].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[62].Set		:=	OUT_CU.bMsg3662;(* B3662 reserve operating message *)
	IF xMsg36[62].Set THEN iReset_Msg36[62] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[62] := LIMIT(0, iReset_Msg36[62] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[62].Reset 	:= 	(iReset_Msg36[62] < 1);		//.Reset := TRUE;
	xMsg36[62]();
	MM2VIS.bMsg3662		:=	xMsg36[62].Q;

	xMsg36[63].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[63].Set		:=	OUT_CU.bMsg3663;(* B3663 reserve operating message *)
	IF xMsg36[63].Set THEN iReset_Msg36[63] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[63] := LIMIT(0, iReset_Msg36[63] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[63].Reset 	:= 	(iReset_Msg36[63] < 1);		//.Reset := TRUE;
	xMsg36[63]();
	MM2VIS.bMsg3663		:=	xMsg36[63].Q;

	xMsg36[64].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[64].Set		:=	OUT_CU.bMsg3664;(* B3664 reserve operating message *)
	IF xMsg36[64].Set THEN iReset_Msg36[64] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[64] := LIMIT(0, iReset_Msg36[64] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[64].Reset 	:= 	(iReset_Msg36[64] < 1);		//.Reset := TRUE;
	xMsg36[64]();
	MM2VIS.bMsg3664		:=	xMsg36[64].Q;

	xMsg36[65].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[65].Set		:=	OUT_CU.bMsg3665;(* B3665 reserve operating message *)
	IF xMsg36[65].Set THEN iReset_Msg36[65] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[65] := LIMIT(0, iReset_Msg36[65] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[65].Reset 	:= 	(iReset_Msg36[65] < 1);		//.Reset := TRUE;
	xMsg36[65]();
	MM2VIS.bMsg3665		:=	xMsg36[65].Q;

	xMsg36[66].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[66].Set		:=	OUT_CU.bMsg3666;(* B3666 reserve operating message *)
	IF xMsg36[66].Set THEN iReset_Msg36[66] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[66] := LIMIT(0, iReset_Msg36[66] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[66].Reset 	:= 	(iReset_Msg36[66] < 1);		//.Reset := TRUE;
	xMsg36[66]();
	MM2VIS.bMsg3666		:=	xMsg36[66].Q;

	xMsg36[67].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[67].Set		:=	OUT_CU.bMsg3667;(* B3667 reserve operating message *)
	IF xMsg36[67].Set THEN iReset_Msg36[67] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[67] := LIMIT(0, iReset_Msg36[67] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[67].Reset 	:= 	(iReset_Msg36[67] < 1);		//.Reset := TRUE;
	xMsg36[67]();
	MM2VIS.bMsg3667		:=	xMsg36[67].Q;

	xMsg36[68].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[68].Set		:=	OUT_CU.bMsg3668;(* B3668 reserve operating message *)
	IF xMsg36[68].Set THEN iReset_Msg36[68] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[68] := LIMIT(0, iReset_Msg36[68] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[68].Reset 	:= 	(iReset_Msg36[68] < 1);		//.Reset := TRUE;
	xMsg36[68]();
	MM2VIS.bMsg3668		:=	xMsg36[68].Q;

	xMsg36[69].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[69].Set		:=	OUT_CU.bMsg3669;(* B3669 reserve operating message *)
	IF xMsg36[69].Set THEN iReset_Msg36[69] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[69] := LIMIT(0, iReset_Msg36[69] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[69].Reset 	:= 	(iReset_Msg36[69] < 1);		//.Reset := TRUE;
	xMsg36[69]();
	MM2VIS.bMsg3669		:=	xMsg36[69].Q;

	xMsg36[70].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[70].Set		:=	OUT_CU.bMsg3670;(* B3670 reserve operating message *)
	IF xMsg36[70].Set THEN iReset_Msg36[70] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[70] := LIMIT(0, iReset_Msg36[70] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[70].Reset 	:= 	(iReset_Msg36[70] < 1);		//.Reset := TRUE;
	xMsg36[70]();
	MM2VIS.bMsg3670		:=	xMsg36[70].Q;			
	(*----------------------------------------------------------------------*)	
			
	xMsg36[71].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[71].Set		:=	OUT_CU.bMsg3671;(* B3671 reserve operating message *)
	IF xMsg36[71].Set THEN iReset_Msg36[71] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[71] := LIMIT(0, iReset_Msg36[71] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[71].Reset 	:= 	(iReset_Msg36[71] < 1);		//.Reset := TRUE;
	xMsg36[71]();
	MM2VIS.bMsg3671		:=	xMsg36[71].Q;

	xMsg36[72].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[72].Set		:=	OUT_CU.bMsg3672;(* B3672 reserve operating message *)
	IF xMsg36[72].Set THEN iReset_Msg36[72] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[72] := LIMIT(0, iReset_Msg36[72] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[72].Reset 	:= 	(iReset_Msg36[72] < 1);		//.Reset := TRUE;
	xMsg36[72]();
	MM2VIS.bMsg3672		:=	xMsg36[72].Q;

	xMsg36[73].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[73].Set		:=	OUT_CU.bMsg3673;(* B3673 reserve operating message *)
	IF xMsg36[73].Set THEN iReset_Msg36[73] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[73] := LIMIT(0, iReset_Msg36[73] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[73].Reset 	:= 	(iReset_Msg36[73] < 1);		//.Reset := TRUE;
	xMsg36[73]();
	MM2VIS.bMsg3673		:=	xMsg36[73].Q;

	xMsg36[74].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[74].Set		:=	OUT_CU.bMsg3674;(* B3674 reserve operating message *)
	IF xMsg36[74].Set THEN iReset_Msg36[74] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[74] := LIMIT(0, iReset_Msg36[74] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[74].Reset 	:= 	(iReset_Msg36[74] < 1);		//.Reset := TRUE;
	xMsg36[74]();
	MM2VIS.bMsg3674		:=	xMsg36[74].Q;

	xMsg36[75].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[75].Set		:=	OUT_CU.bMsg3675;(* B3675 reserve operating message *)
	IF xMsg36[75].Set THEN iReset_Msg36[75] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[75] := LIMIT(0, iReset_Msg36[75] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[75].Reset 	:= 	(iReset_Msg36[75] < 1);		//.Reset := TRUE;
	xMsg36[75]();
	MM2VIS.bMsg3675		:=	xMsg36[75].Q;

	xMsg36[76].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[76].Set		:=	OUT_CU.bMsg3676;(* B3676 reserve operating message *)
	IF xMsg36[76].Set THEN iReset_Msg36[76] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[76] := LIMIT(0, iReset_Msg36[76] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[76].Reset 	:= 	(iReset_Msg36[76] < 1);		//.Reset := TRUE;
	xMsg36[76]();
	MM2VIS.bMsg3676		:=	xMsg36[76].Q;

	xMsg36[77].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[77].Set		:=	OUT_CU.bMsg3677;(* B3677 reserve operating message *)
	IF xMsg36[77].Set THEN iReset_Msg36[77] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[77] := LIMIT(0, iReset_Msg36[77] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[77].Reset 	:= 	(iReset_Msg36[77] < 1);		//.Reset := TRUE;
	xMsg36[77]();
	MM2VIS.bMsg3677		:=	xMsg36[77].Q;

	xMsg36[78].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[78].Set		:=	OUT_CU.bMsg3678;(* B3678 reserve operating message *)
	IF xMsg36[78].Set THEN iReset_Msg36[78] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[78] := LIMIT(0, iReset_Msg36[78] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[78].Reset 	:= 	(iReset_Msg36[78] < 1);		//.Reset := TRUE;
	xMsg36[78]();
	MM2VIS.bMsg3678		:=	xMsg36[78].Q;

	xMsg36[79].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[79].Set		:=	OUT_CU.bMsg3679;(* B3679 reserve operating message *)
	IF xMsg36[79].Set THEN iReset_Msg36[79] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[79] := LIMIT(0, iReset_Msg36[79] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[79].Reset 	:= 	(iReset_Msg36[79] < 1);		//.Reset := TRUE;
	xMsg36[79]();
	MM2VIS.bMsg3679		:=	xMsg36[79].Q;

	xMsg36[80].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[80].Set		:=	OUT_CU.bMsg3680;(* B3680 reserve operating message *)
	IF xMsg36[80].Set THEN iReset_Msg36[80] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[80] := LIMIT(0, iReset_Msg36[80] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[80].Reset 	:= 	(iReset_Msg36[80] < 1);		//.Reset := TRUE;
	xMsg36[80]();
	MM2VIS.bMsg3680		:=	xMsg36[80].Q;			
	(*----------------------------------------------------------------------*)				
				
	xMsg36[81].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[81].Set		:=	OUT_CU.bMsg3681;(* B3681 reserve operating message *)
	IF xMsg36[81].Set THEN iReset_Msg36[81] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[81] := LIMIT(0, iReset_Msg36[81] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[81].Reset 	:= 	(iReset_Msg36[81] < 1);		//.Reset := TRUE;
	xMsg36[81]();
	MM2VIS.bMsg3681		:=	xMsg36[81].Q;

	xMsg36[82].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[82].Set		:=	OUT_CU.bMsg3682;(* B3682 reserve operating message *)
	IF xMsg36[82].Set THEN iReset_Msg36[82] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[82] := LIMIT(0, iReset_Msg36[82] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[82].Reset 	:= 	(iReset_Msg36[82] < 1);		//.Reset := TRUE;
	xMsg36[82]();
	MM2VIS.bMsg3682		:=	xMsg36[82].Q;

	xMsg36[83].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[83].Set		:=	OUT_CU.bMsg3683;(* B3683 reserve operating message *)
	IF xMsg36[83].Set THEN iReset_Msg36[83] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[83] := LIMIT(0, iReset_Msg36[83] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[83].Reset 	:= 	(iReset_Msg36[83] < 1);		//.Reset := TRUE;
	xMsg36[83]();
	MM2VIS.bMsg3683		:=	xMsg36[83].Q;

	xMsg36[84].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[84].Set		:=	OUT_CU.bMsg3684;(* B3684 reserve operating message *)
	IF xMsg36[84].Set THEN iReset_Msg36[84] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[84] := LIMIT(0, iReset_Msg36[84] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[84].Reset 	:= 	(iReset_Msg36[84] < 1);		//.Reset := TRUE;
	xMsg36[84]();
	MM2VIS.bMsg3684		:=	xMsg36[84].Q;

	xMsg36[85].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[85].Set		:=	OUT_CU.bMsg3685;(* B3685 reserve operating message *)
	IF xMsg36[85].Set THEN iReset_Msg36[85] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[85] := LIMIT(0, iReset_Msg36[85] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[85].Reset 	:= 	(iReset_Msg36[85] < 1);		//.Reset := TRUE;
	xMsg36[85]();
	MM2VIS.bMsg3685		:=	xMsg36[85].Q;

	xMsg36[86].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[86].Set		:=	OUT_CU.bMsg3686;(* B3686 reserve operating message *)
	IF xMsg36[86].Set THEN iReset_Msg36[86] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[86] := LIMIT(0, iReset_Msg36[86] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[86].Reset 	:= 	(iReset_Msg36[86] < 1);		//.Reset := TRUE;
	xMsg36[86]();
	MM2VIS.bMsg3686		:=	xMsg36[86].Q;

	xMsg36[87].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[87].Set		:=	OUT_CU.bMsg3687;(* B3687 reserve operating message *)
	IF xMsg36[87].Set THEN iReset_Msg36[87] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[87] := LIMIT(0, iReset_Msg36[87] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[87].Reset 	:= 	(iReset_Msg36[87] < 1);		//.Reset := TRUE;
	xMsg36[87]();
	MM2VIS.bMsg3687		:=	xMsg36[87].Q;

	xMsg36[88].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[88].Set		:=	OUT_CU.bMsg3688;(* B3688 reserve operating message *)
	IF xMsg36[88].Set THEN iReset_Msg36[88] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[88] := LIMIT(0, iReset_Msg36[88] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[88].Reset 	:= 	(iReset_Msg36[88] < 1);		//.Reset := TRUE;
	xMsg36[88]();
	MM2VIS.bMsg3688		:=	xMsg36[88].Q;

	xMsg36[89].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[89].Set		:=	OUT_CU.bMsg3689;(* B3689 reserve operating message *)
	IF xMsg36[89].Set THEN iReset_Msg36[89] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[89] := LIMIT(0, iReset_Msg36[89] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[89].Reset 	:= 	(iReset_Msg36[89] < 1);		//.Reset := TRUE;
	xMsg36[89]();
	MM2VIS.bMsg3689		:=	xMsg36[89].Q;

	xMsg36[90].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[90].Set		:=	OUT_CU.bMsg3690;(* B3690 reserve operating message *)
	IF xMsg36[90].Set THEN iReset_Msg36[90] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[90] := LIMIT(0, iReset_Msg36[90] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[90].Reset 	:= 	(iReset_Msg36[90] < 1);		//.Reset := TRUE;
	xMsg36[90]();
	MM2VIS.bMsg3690		:=	xMsg36[90].Q;
	(*----------------------------------------------------------------------*)	
			
	xMsg36[91].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[91].Set		:=	OUT_CU.bMsg3691;(* B3691 reserve operating message *)
	IF xMsg36[91].Set THEN iReset_Msg36[91] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[91] := LIMIT(0, iReset_Msg36[91] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[91].Reset 	:= 	(iReset_Msg36[91] < 1);		//.Reset := TRUE;
	xMsg36[91]();
	MM2VIS.bMsg3691		:=	xMsg36[91].Q;

	xMsg36[92].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[92].Set		:=	OUT_CU.bMsg3692;(* B3692 reserve operating message *)
	IF xMsg36[92].Set THEN iReset_Msg36[92] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[92] := LIMIT(0, iReset_Msg36[92] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[92].Reset 	:= 	(iReset_Msg36[92] < 1);		//.Reset := TRUE;
	xMsg36[92]();
	MM2VIS.bMsg3692		:=	xMsg36[92].Q;

	xMsg36[93].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[93].Set		:=	OUT_CU.bMsg3693;(* B3693 reserve operating message *)
	IF xMsg36[93].Set THEN iReset_Msg36[93] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[93] := LIMIT(0, iReset_Msg36[93] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[93].Reset 	:= 	(iReset_Msg36[93] < 1);		//.Reset := TRUE;
	xMsg36[93]();
	MM2VIS.bMsg3693		:=	xMsg36[93].Q;

	xMsg36[94].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[94].Set		:=	OUT_CU.bMsg3694;(* B3694 reserve operating message *)
	IF xMsg36[94].Set THEN iReset_Msg36[94] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[94] := LIMIT(0, iReset_Msg36[94] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[94].Reset 	:= 	(iReset_Msg36[94] < 1);		//.Reset := TRUE;
	xMsg36[94]();
	MM2VIS.bMsg3694		:=	xMsg36[94].Q;

	xMsg36[95].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[95].Set		:=	OUT_CU.bMsg3695;(* B3695 reserve operating message *)
	IF xMsg36[95].Set THEN iReset_Msg36[95] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[95] := LIMIT(0, iReset_Msg36[95] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[95].Reset 	:= 	(iReset_Msg36[95] < 1);		//.Reset := TRUE;
	xMsg36[95]();
	MM2VIS.bMsg3695		:=	xMsg36[95].Q;

	xMsg36[96].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[96].Set		:=	OUT_CU.bMsg3696;(* B3696 reserve operating message *)
	IF xMsg36[96].Set THEN iReset_Msg36[96] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[96] := LIMIT(0, iReset_Msg36[96] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[96].Reset 	:= 	(iReset_Msg36[96] < 1);		//.Reset := TRUE;
	xMsg36[96]();
	MM2VIS.bMsg3696		:=	xMsg36[96].Q;

	xMsg36[97].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[97].Set		:=	OUT_CU.bMsg3697;(* B3697 reserve operating message *)
	IF xMsg36[97].Set THEN iReset_Msg36[97] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[97] := LIMIT(0, iReset_Msg36[97] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[97].Reset 	:= 	(iReset_Msg36[97] < 1);		//.Reset := TRUE;
	xMsg36[97]();
	MM2VIS.bMsg3697		:=	xMsg36[97].Q;

	xMsg36[98].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[98].Set		:=	OUT_CU.bMsg3698;(* B3698 reserve operating message *)
	IF xMsg36[98].Set THEN iReset_Msg36[98] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[98] := LIMIT(0, iReset_Msg36[98] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[98].Reset 	:= 	(iReset_Msg36[98] < 1);		//.Reset := TRUE;
	xMsg36[98]();
	MM2VIS.bMsg3698		:=	xMsg36[98].Q;

	xMsg36[99].Enable	:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg36[99].Set		:=	OUT_CU.bMsg3699;(* B3699 reserve operating message *)
	IF xMsg36[99].Set THEN iReset_Msg36[99] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg36[99] := LIMIT(0, iReset_Msg36[99] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg36[99].Reset 	:= 	(iReset_Msg36[99] < 1);		//.Reset := TRUE;
	xMsg36[99]();
	MM2VIS.bMsg3699		:=	xMsg36[99].Q;

	xMsg3700.Enable		:=	IN_CU.tPB2MM.bParaSetupOk ;
	xMsg3700.Set		:=	OUT_CU.bMsg3700;(* B3700 reserve operating message *)
	IF xMsg3700.Set THEN iReset_Msg3700 := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg3700 := LIMIT(0, iReset_Msg3700 -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
	xMsg3700.Reset 	:= 	(iReset_Msg3700 < 1);		//.Reset := TRUE;
	xMsg3700();
	MM2VIS.bMsg3700		:=	xMsg3700.Q;	
	
	(* W6701 to W6799:  reserve operating message 109 - 207 *) (*import HMI Extension *)
	FOR cnt := 01 TO 99 DO
		(*set standard message options*)
		xMsg67[cnt].Enable	:= 	IN_CU.tPB2MM.bParaSetupOk ;
		IF xMsg67[cnt].Set THEN iReset_Msg67[cnt] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg67[cnt] := LIMIT(0, iReset_Msg67[cnt] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
		xMsg67[cnt].Reset 	:= 	(iReset_Msg67[cnt] < 1);		//.Reset := TRUE;
		xMsg67[cnt]();	(*function call*)
	END_FOR	
	
	xMsg67[01].Set		:=	OUT_CU.bMsg6701;(* B6701 reserve operating message 109 *) (*import HMI Extension *)
	MM2VIS.bMsg6701		:=	xMsg67[01].Q;
			
	xMsg67[02].Set		:=	OUT_CU.bMsg6702;(* B6702 reserve operating message 110 *) (*import HMI Extension *)
	MM2VIS.bMsg6702		:=	xMsg67[02].Q;
			
	xMsg67[03].Set		:=	OUT_CU.bMsg6703;(* B6703 reserve operating message 111 *) (*import HMI Extension *)
	MM2VIS.bMsg6703		:=	xMsg67[03].Q;
			
	xMsg67[04].Set		:=	OUT_CU.bMsg6704;(* B6704 reserve operating message 112 *) (*import HMI Extension *)
	MM2VIS.bMsg6704		:=	xMsg67[04].Q;
			
	xMsg67[05].Set		:=	OUT_CU.bMsg6705;(* B6705 reserve operating message 113 *) (*import HMI Extension *)
	MM2VIS.bMsg6705		:=	xMsg67[05].Q;
			
	xMsg67[06].Set		:=	OUT_CU.bMsg6706;(* B6706 reserve operating message 114 *) (*import HMI Extension *)
	MM2VIS.bMsg6706		:=	xMsg67[06].Q;
			
	xMsg67[07].Set		:=	OUT_CU.bMsg6707;(* B6707 reserve operating message 115 *) (*import HMI Extension *)
	MM2VIS.bMsg6707		:=	xMsg67[07].Q;
			
	xMsg67[08].Set		:=	OUT_CU.bMsg6708;(* B6708 reserve operating message 116 *) (*import HMI Extension *)
	MM2VIS.bMsg6708		:=	xMsg67[08].Q;
			
	xMsg67[09].Set		:=	OUT_CU.bMsg6709;(* B6709 reserve operating message 117 *) (*import HMI Extension *)
	MM2VIS.bMsg6709		:=	xMsg67[09].Q;
			
	xMsg67[10].Set		:=	OUT_CU.bMsg6710;(* B6710 reserve operating message 118 *) (*import HMI Extension *)
	MM2VIS.bMsg6710		:=	xMsg67[10].Q;

	xMsg67[11].Set		:=	OUT_CU.bMsg6711;(* B6711 reserve operating message 119 *) (*import HMI Extension *)
	MM2VIS.bMsg6711		:=	xMsg67[11].Q;
			
	xMsg67[12].Set		:=	OUT_CU.bMsg6712;(* B6712 reserve operating message 120 *) (*import HMI Extension *)
	MM2VIS.bMsg6712		:=	xMsg67[12].Q;
			
	xMsg67[13].Set		:=	OUT_CU.bMsg6713;(* B6713 reserve operating message 121 *) (*import HMI Extension *)
	MM2VIS.bMsg6713		:=	xMsg67[13].Q;
			
	xMsg67[14].Set		:=	OUT_CU.bMsg6714;(* B6714 reserve operating message 122 *) (*import HMI Extension *)
	MM2VIS.bMsg6714		:=	xMsg67[14].Q;
			
	xMsg67[15].Set		:=	OUT_CU.bMsg6715;(* B6715 reserve operating message 123 *) (*import HMI Extension *)
	MM2VIS.bMsg6715		:=	xMsg67[15].Q;
			
	xMsg67[16].Set		:=	OUT_CU.bMsg6716;(* B6716 reserve operating message 124 *) (*import HMI Extension *)
	MM2VIS.bMsg6716		:=	xMsg67[16].Q;
			
	xMsg67[17].Set		:=	OUT_CU.bMsg6717;(* B6717 reserve operating message 125 *) (*import HMI Extension *)
	MM2VIS.bMsg6717		:=	xMsg67[17].Q;
			
	xMsg67[18].Set		:=	OUT_CU.bMsg6718;(* B6718 reserve operating message 126 *) (*import HMI Extension *)
	MM2VIS.bMsg6718		:=	xMsg67[18].Q;
			
	xMsg67[19].Set		:=	OUT_CU.bMsg6719;(* B6719 reserve operating message 127 *) (*import HMI Extension *)
	MM2VIS.bMsg6719		:=	xMsg67[19].Q;
			
	xMsg67[20].Set		:=	OUT_CU.bMsg6720;(* B6720 reserve operating message 128 *) (*import HMI Extension *)
	MM2VIS.bMsg6720		:=	xMsg67[20].Q;

	xMsg67[21].Set		:=	OUT_CU.bMsg6721;(* B6721 reserve operating message 129 *) (*import HMI Extension *)
	MM2VIS.bMsg6721		:=	xMsg67[21].Q;
			
	xMsg67[22].Set		:=	OUT_CU.bMsg6722;(* B6722 reserve operating message 130 *) (*import HMI Extension *)
	MM2VIS.bMsg6722		:=	xMsg67[22].Q;
			
	xMsg67[23].Set		:=	OUT_CU.bMsg6723;(* B6723 reserve operating message 131 *) (*import HMI Extension *)
	MM2VIS.bMsg6723		:=	xMsg67[23].Q;
			
	xMsg67[24].Set		:=	OUT_CU.bMsg6724;(* B6724 reserve operating message 132 *) (*import HMI Extension *)
	MM2VIS.bMsg6724		:=	xMsg67[24].Q;
			
	xMsg67[25].Set		:=	OUT_CU.bMsg6725;(* B6725 reserve operating message 133 *) (*import HMI Extension *)
	MM2VIS.bMsg6725		:=	xMsg67[25].Q;
			
	xMsg67[26].Set		:=	OUT_CU.bMsg6726;(* B6726 reserve operating message 134 *) (*import HMI Extension *)
	MM2VIS.bMsg6726		:=	xMsg67[26].Q;
			
	xMsg67[27].Set		:=	OUT_CU.bMsg6727;(* B6727 reserve operating message 135 *) (*import HMI Extension *)
	MM2VIS.bMsg6727		:=	xMsg67[27].Q;
			
	xMsg67[28].Set		:=	OUT_CU.bMsg6728;(* B6728 reserve operating message 136 *) (*import HMI Extension *)
	MM2VIS.bMsg6728		:=	xMsg67[28].Q;
			
	xMsg67[29].Set		:=	OUT_CU.bMsg6729;(* B6729 reserve operating message 137 *) (*import HMI Extension *)
	MM2VIS.bMsg6729		:=	xMsg67[29].Q;
			
	xMsg67[30].Set		:=	OUT_CU.bMsg6730;(* B6730 reserve operating message 138 *) (*import HMI Extension *)
	MM2VIS.bMsg6730		:=	xMsg67[30].Q;

	xMsg67[31].Set		:=	OUT_CU.bMsg6731;(* B6731 reserve operating message 139 *) (*import HMI Extension *)
	MM2VIS.bMsg6731		:=	xMsg67[31].Q;
			
	xMsg67[32].Set		:=	OUT_CU.bMsg6732;(* B6732 reserve operating message 140 *) (*import HMI Extension *)
	MM2VIS.bMsg6732		:=	xMsg67[32].Q;
			
	xMsg67[33].Set		:=	OUT_CU.bMsg6733;(* B6733 reserve operating message 141 *) (*import HMI Extension *)
	MM2VIS.bMsg6733		:=	xMsg67[33].Q;
			
	xMsg67[34].Set		:=	OUT_CU.bMsg6734;(* B6734 reserve operating message 142 *) (*import HMI Extension *)
	MM2VIS.bMsg6734		:=	xMsg67[34].Q;
			
	xMsg67[35].Set		:=	OUT_CU.bMsg6735;(* B6735 reserve operating message 143 *) (*import HMI Extension *)
	MM2VIS.bMsg6735		:=	xMsg67[35].Q;
			
	xMsg67[36].Set		:=	OUT_CU.bMsg6736;(* B6736 reserve operating message 144 *) (*import HMI Extension *)
	MM2VIS.bMsg6736		:=	xMsg67[36].Q;
			
	xMsg67[37].Set		:=	OUT_CU.bMsg6737;(* B6737 reserve operating message 145 *) (*import HMI Extension *)
	MM2VIS.bMsg6737		:=	xMsg67[37].Q;
			
	xMsg67[38].Set		:=	OUT_CU.bMsg6738;(* B6738 reserve operating message 146 *) (*import HMI Extension *)
	MM2VIS.bMsg6738		:=	xMsg67[38].Q;
			
	xMsg67[39].Set		:=	OUT_CU.bMsg6739;(* B6739 reserve operating message 147 *) (*import HMI Extension *)
	MM2VIS.bMsg6739		:=	xMsg67[39].Q;
			
	xMsg67[40].Set		:=	OUT_CU.bMsg6740;(* B6740 reserve operating message 148 *) (*import HMI Extension *)
	MM2VIS.bMsg6740		:=	xMsg67[40].Q;
	
	xMsg67[41].Set		:=	OUT_CU.bMsg6741;(* B6741 reserve operating message 149 *) (*import HMI Extension *)
	MM2VIS.bMsg6741		:=	xMsg67[41].Q;
			
	xMsg67[42].Set		:=	OUT_CU.bMsg6742;(* B6742 reserve operating message 150 *) (*import HMI Extension *)
	MM2VIS.bMsg6742		:=	xMsg67[42].Q;
			
	xMsg67[43].Set		:=	OUT_CU.bMsg6743;(* B6743 reserve operating message 151 *) (*import HMI Extension *)
	MM2VIS.bMsg6743		:=	xMsg67[43].Q;
			
	xMsg67[44].Set		:=	OUT_CU.bMsg6744;(* B6744 reserve operating message 152 *) (*import HMI Extension *)
	MM2VIS.bMsg6744		:=	xMsg67[44].Q;
			
	xMsg67[45].Set		:=	OUT_CU.bMsg6745;(* B6745 reserve operating message 153 *) (*import HMI Extension *)
	MM2VIS.bMsg6745		:=	xMsg67[45].Q;
			
	xMsg67[46].Set		:=	OUT_CU.bMsg6746;(* B6746 reserve operating message 154 *) (*import HMI Extension *)
	MM2VIS.bMsg6746		:=	xMsg67[46].Q;
			
	xMsg67[47].Set		:=	OUT_CU.bMsg6747;(* B6747 reserve operating message 155 *) (*import HMI Extension *)
	MM2VIS.bMsg6747		:=	xMsg67[47].Q;
			
	xMsg67[48].Set		:=	OUT_CU.bMsg6748;(* B6748 reserve operating message 156 *) (*import HMI Extension *)
	MM2VIS.bMsg6748		:=	xMsg67[48].Q;
			
	xMsg67[49].Set		:=	OUT_CU.bMsg6749;(* B6749 reserve operating message 157 *) (*import HMI Extension *)
	MM2VIS.bMsg6749		:=	xMsg67[49].Q;
			
	xMsg67[50].Set		:=	OUT_CU.bMsg6750;(* B6750 reserve operating message 158 *) (*import HMI Extension *)
	MM2VIS.bMsg6750		:=	xMsg67[50].Q;

	xMsg67[51].Set		:=	OUT_CU.bMsg6751;(* B6751 reserve operating message 159 *) (*import HMI Extension *)
	MM2VIS.bMsg6751		:=	xMsg67[51].Q;
			
	xMsg67[52].Set		:=	OUT_CU.bMsg6752;(* B6752 reserve operating message 160 *) (*import HMI Extension *)
	MM2VIS.bMsg6752		:=	xMsg67[52].Q;
			
	xMsg67[53].Set		:=	OUT_CU.bMsg6753;(* B6753 reserve operating message 161 *) (*import HMI Extension *)
	MM2VIS.bMsg6753		:=	xMsg67[53].Q;
			
	xMsg67[54].Set		:=	OUT_CU.bMsg6754;(* B6754 reserve operating message 162 *) (*import HMI Extension *)
	MM2VIS.bMsg6754		:=	xMsg67[54].Q;
			
	xMsg67[55].Set		:=	OUT_CU.bMsg6755;(* B6755 reserve operating message 163 *) (*import HMI Extension *)
	MM2VIS.bMsg6755		:=	xMsg67[55].Q;
			
	xMsg67[56].Set		:=	OUT_CU.bMsg6756;(* B6756 reserve operating message 164 *) (*import HMI Extension *)
	MM2VIS.bMsg6756		:=	xMsg67[56].Q;
			
	xMsg67[57].Set		:=	OUT_CU.bMsg6757;(* B6757 reserve operating message 165 *) (*import HMI Extension *)
	MM2VIS.bMsg6757		:=	xMsg67[57].Q;
			
	xMsg67[58].Set		:=	OUT_CU.bMsg6758;(* B6758 reserve operating message 166 *) (*import HMI Extension *)
	MM2VIS.bMsg6758		:=	xMsg67[58].Q;
			
	xMsg67[59].Set		:=	OUT_CU.bMsg6759;(* B6759 reserve operating message 167 *) (*import HMI Extension *)
	MM2VIS.bMsg6759		:=	xMsg67[59].Q;
			
	xMsg67[60].Set		:=	OUT_CU.bMsg6760;(* B6760 reserve operating message 168 *) (*import HMI Extension *)
	MM2VIS.bMsg6760		:=	xMsg67[60].Q;
	
	xMsg67[61].Set		:=	OUT_CU.bMsg6761;(* B6761 reserve operating message 169 *) (*import HMI Extension *)
	MM2VIS.bMsg6761		:=	xMsg67[61].Q;
			
	xMsg67[62].Set		:=	OUT_CU.bMsg6762;(* B6762 reserve operating message 170 *) (*import HMI Extension *)
	MM2VIS.bMsg6762		:=	xMsg67[62].Q;
			
	xMsg67[63].Set		:=	OUT_CU.bMsg6763;(* B6763 reserve operating message 171 *) (*import HMI Extension *)
	MM2VIS.bMsg6763		:=	xMsg67[63].Q;
			
	xMsg67[64].Set		:=	OUT_CU.bMsg6764;(* B6764 reserve operating message 172 *) (*import HMI Extension *)
	MM2VIS.bMsg6764		:=	xMsg67[64].Q;
			
	xMsg67[65].Set		:=	OUT_CU.bMsg6765;(* B6765 reserve operating message 173 *) (*import HMI Extension *)
	MM2VIS.bMsg6765		:=	xMsg67[65].Q;
			
	xMsg67[66].Set		:=	OUT_CU.bMsg6766;(* B6766 reserve operating message 174 *) (*import HMI Extension *)
	MM2VIS.bMsg6766		:=	xMsg67[66].Q;
			
	xMsg67[67].Set		:=	OUT_CU.bMsg6767;(* B6767 reserve operating message 175 *) (*import HMI Extension *)
	MM2VIS.bMsg6767		:=	xMsg67[67].Q;
			
	xMsg67[68].Set		:=	OUT_CU.bMsg6768;(* B6768 reserve operating message 176 *) (*import HMI Extension *)
	MM2VIS.bMsg6768		:=	xMsg67[68].Q;
			
	xMsg67[69].Set		:=	OUT_CU.bMsg6769;(* B6769 reserve operating message 177 *) (*import HMI Extension *)
	MM2VIS.bMsg6769		:=	xMsg67[69].Q;
			
	xMsg67[70].Set		:=	OUT_CU.bMsg6770;(* B6770 reserve operating message 178 *) (*import HMI Extension *)
	MM2VIS.bMsg6770		:=	xMsg67[70].Q;

	xMsg67[71].Set		:=	OUT_CU.bMsg6771;(* B6771 reserve operating message 179 *) (*import HMI Extension *)
	MM2VIS.bMsg6771		:=	xMsg67[71].Q;
			
	xMsg67[72].Set		:=	OUT_CU.bMsg6772;(* B6772 reserve operating message 180 *) (*import HMI Extension *)
	MM2VIS.bMsg6772		:=	xMsg67[72].Q;
			
	xMsg67[73].Set		:=	OUT_CU.bMsg6773;(* B6773 reserve operating message 181 *) (*import HMI Extension *)
	MM2VIS.bMsg6773		:=	xMsg67[73].Q;
			
	xMsg67[74].Set		:=	OUT_CU.bMsg6774;(* B6774 reserve operating message 182 *) (*import HMI Extension *)
	MM2VIS.bMsg6774		:=	xMsg67[74].Q;
			
	xMsg67[75].Set		:=	OUT_CU.bMsg6775;(* B6775 reserve operating message 183 *) (*import HMI Extension *)
	MM2VIS.bMsg6775		:=	xMsg67[75].Q;
			
	xMsg67[76].Set		:=	OUT_CU.bMsg6776;(* B6776 reserve operating message 184 *) (*import HMI Extension *)
	MM2VIS.bMsg6776		:=	xMsg67[76].Q;
			
	xMsg67[77].Set		:=	OUT_CU.bMsg6777;(* B6777 reserve operating message 185 *) (*import HMI Extension *)
	MM2VIS.bMsg6777		:=	xMsg67[77].Q;
			
	xMsg67[78].Set		:=	OUT_CU.bMsg6778;(* B6778 reserve operating message 186 *) (*import HMI Extension *)
	MM2VIS.bMsg6778		:=	xMsg67[78].Q;
			
	xMsg67[79].Set		:=	OUT_CU.bMsg6779;(* B6779 reserve operating message 187 *) (*import HMI Extension *)
	MM2VIS.bMsg6779		:=	xMsg67[79].Q;
			
	xMsg67[80].Set		:=	OUT_CU.bMsg6780;(* B6780 reserve operating message 188 *) (*import HMI Extension *)
	MM2VIS.bMsg6780		:=	xMsg67[80].Q;

	xMsg67[81].Set		:=	OUT_CU.bMsg6781;(* B6781 reserve operating message 189 *) (*import HMI Extension *)
	MM2VIS.bMsg6781		:=	xMsg67[81].Q;
			
	xMsg67[82].Set		:=	OUT_CU.bMsg6782;(* B6782 reserve operating message 190 *) (*import HMI Extension *)
	MM2VIS.bMsg6782		:=	xMsg67[82].Q;
			
	xMsg67[83].Set		:=	OUT_CU.bMsg6783;(* B6783 reserve operating message 191 *) (*import HMI Extension *)
	MM2VIS.bMsg6783		:=	xMsg67[83].Q;
			
	xMsg67[84].Set		:=	OUT_CU.bMsg6784;(* B6784 reserve operating message 192 *) (*import HMI Extension *)
	MM2VIS.bMsg6784		:=	xMsg67[84].Q;
			
	xMsg67[85].Set		:=	OUT_CU.bMsg6785;(* B6785 reserve operating message 193 *) (*import HMI Extension *)
	MM2VIS.bMsg6785		:=	xMsg67[85].Q;
			
	xMsg67[86].Set		:=	OUT_CU.bMsg6786;(* B6786 reserve operating message 194 *) (*import HMI Extension *)
	MM2VIS.bMsg6786		:=	xMsg67[86].Q;
			
	xMsg67[87].Set		:=	OUT_CU.bMsg6787;(* B6787 reserve operating message 195 *) (*import HMI Extension *)
	MM2VIS.bMsg6787		:=	xMsg67[87].Q;
			
	xMsg67[88].Set		:=	OUT_CU.bMsg6788;(* B6788 reserve operating message 196 *) (*import HMI Extension *)
	MM2VIS.bMsg6788		:=	xMsg67[88].Q;
			
	xMsg67[89].Set		:=	OUT_CU.bMsg6789;(* B6789 reserve operating message 197 *) (*import HMI Extension *)
	MM2VIS.bMsg6789		:=	xMsg67[89].Q;
			
	xMsg67[90].Set		:=	OUT_CU.bMsg6790;(* B6790 reserve operating message 198 *) (*import HMI Extension *)
	MM2VIS.bMsg6790		:=	xMsg67[90].Q;

	xMsg67[91].Set		:=	OUT_CU.bMsg6791;(* B6791 reserve operating message 199 *) (*import HMI Extension *)
	MM2VIS.bMsg6791		:=	xMsg67[91].Q;
			
	xMsg67[92].Set		:=	OUT_CU.bMsg6792;(* B6792 reserve operating message 200 *) (*import HMI Extension *)
	MM2VIS.bMsg6792		:=	xMsg67[92].Q;
			
	xMsg67[93].Set		:=	OUT_CU.bMsg6793;(* B6793 reserve operating message 201 *) (*import HMI Extension *)
	MM2VIS.bMsg6793		:=	xMsg67[93].Q;
			
	xMsg67[94].Set		:=	OUT_CU.bMsg6794;(* B6794 reserve operating message 202 *) (*import HMI Extension *)
	MM2VIS.bMsg6794		:=	xMsg67[94].Q;
			
	xMsg67[95].Set		:=	OUT_CU.bMsg6795;(* B6795 reserve operating message 203 *) (*import HMI Extension *)
	MM2VIS.bMsg6795		:=	xMsg67[95].Q;
			
	xMsg67[96].Set		:=	OUT_CU.bMsg6796;(* B6796 reserve operating message 204 *) (*import HMI Extension *)
	MM2VIS.bMsg6796		:=	xMsg67[96].Q;
			
	xMsg67[97].Set		:=	OUT_CU.bMsg6797;(* B6797 reserve operating message 205 *) (*import HMI Extension *)
	MM2VIS.bMsg6797		:=	xMsg67[97].Q;
			
	xMsg67[98].Set		:=	OUT_CU.bMsg6798;(* B6798 reserve operating message 206 *) (*import HMI Extension *)
	MM2VIS.bMsg6798		:=	xMsg67[98].Q;
			
	xMsg67[99].Set		:=	OUT_CU.bMsg6799;(* B6799 reserve operating message 207 *) (*import HMI Extension *)
	MM2VIS.bMsg6799		:=	xMsg67[99].Q;
			
//	xMsg67[100].Set		//	MOVED TO xMsg68[0].Set
//	MM2VIS.bMsg6800		//	MOVED TO xMsg68[0].Set
	
	(* W6800 to W6899:  reserve operating message 208 - 307 *) (*import HMI Extension *)
	FOR cnt := 00 TO 99 DO
		(*set standard message options*)
		xMsg68[cnt].Enable	:= 	IN_CU.tPB2MM.bParaSetupOk ;
		IF xMsg68[cnt].Set THEN iReset_Msg68[cnt] := iDelay_MsgAutoReset_100ms; ELSE iReset_Msg68[cnt] := LIMIT(0, iReset_Msg68[cnt] -1,32767); END_IF		(* activate 'Message Hold Time' to avoid log clathering by repeated OpMsg entries *)
		xMsg68[cnt].Reset 	:= 	(iReset_Msg68[cnt] < 1);		//.Reset := TRUE;
		xMsg68[cnt]();	(*function call*)
	END_FOR	


	xMsg68[0].Set		:=	OUT_CU.bMsg6800;(* B6800 reserve operating message 208 *) (*import HMI Extension *)
	MM2VIS.bMsg6800		:=	xMsg68[0].Q;
	
	xMsg68[01].Set		:=	OUT_CU.bMsg6801;(* B6801 reserve operating message 209 *) (*import HMI Extension *)
	MM2VIS.bMsg6801		:=	xMsg68[01].Q;
			
	xMsg68[02].Set		:=	OUT_CU.bMsg6802;(* B6802 reserve operating message 210 *) (*import HMI Extension *)
	MM2VIS.bMsg6802		:=	xMsg68[02].Q;
			
	xMsg68[03].Set		:=	OUT_CU.bMsg6803;(* B6803 reserve operating message 211 *) (*import HMI Extension *)
	MM2VIS.bMsg6803		:=	xMsg68[03].Q;
			
	xMsg68[04].Set		:=	OUT_CU.bMsg6804;(* B6804 reserve operating message 212 *) (*import HMI Extension *)
	MM2VIS.bMsg6804		:=	xMsg68[04].Q;
			
	xMsg68[05].Set		:=	OUT_CU.bMsg6805;(* B6805 reserve operating message 213 *) (*import HMI Extension *)
	MM2VIS.bMsg6805		:=	xMsg68[05].Q;
			
	xMsg68[06].Set		:=	OUT_CU.bMsg6806;(* B6806 reserve operating message 214 *) (*import HMI Extension *)
	MM2VIS.bMsg6806		:=	xMsg68[06].Q;
			
	xMsg68[07].Set		:=	OUT_CU.bMsg6807;(* B6807 reserve operating message 215 *) (*import HMI Extension *)
	MM2VIS.bMsg6807		:=	xMsg68[07].Q;
			
	xMsg68[08].Set		:=	OUT_CU.bMsg6808;(* B6808 reserve operating message 216 *) (*import HMI Extension *)
	MM2VIS.bMsg6808		:=	xMsg68[08].Q;
			
	xMsg68[09].Set		:=	OUT_CU.bMsg6809;(* B6809 reserve operating message 217 *) (*import HMI Extension *)
	MM2VIS.bMsg6809		:=	xMsg68[09].Q;
			
	xMsg68[10].Set		:=	OUT_CU.bMsg6810;(* B6810 reserve operating message 218 *) (*import HMI Extension *)
	MM2VIS.bMsg6810		:=	xMsg68[10].Q;

	xMsg68[11].Set		:=	OUT_CU.bMsg6811;(* B6811 reserve operating message 219 *) (*import HMI Extension *)
	MM2VIS.bMsg6811		:=	xMsg68[11].Q;
			
	xMsg68[12].Set		:=	OUT_CU.bMsg6812;(* B6812 reserve operating message 220 *) (*import HMI Extension *)
	MM2VIS.bMsg6812		:=	xMsg68[12].Q;
			
	xMsg68[13].Set		:=	OUT_CU.bMsg6813;(* B6813 reserve operating message 221 *) (*import HMI Extension *)
	MM2VIS.bMsg6813		:=	xMsg68[13].Q;
			
	xMsg68[14].Set		:=	OUT_CU.bMsg6814;(* B6814 reserve operating message 222 *) (*import HMI Extension *)
	MM2VIS.bMsg6814		:=	xMsg68[14].Q;
			
	xMsg68[15].Set		:=	OUT_CU.bMsg6815;(* B6815 reserve operating message 223 *) (*import HMI Extension *)
	MM2VIS.bMsg6815		:=	xMsg68[15].Q;
			
	xMsg68[16].Set		:=	OUT_CU.bMsg6816;(* B6816 reserve operating message 224 *) (*import HMI Extension *)
	MM2VIS.bMsg6816		:=	xMsg68[16].Q;
			
	xMsg68[17].Set		:=	OUT_CU.bMsg6817;(* B6817 reserve operating message 225 *) (*import HMI Extension *)
	MM2VIS.bMsg6817		:=	xMsg68[17].Q;
			
	xMsg68[18].Set		:=	OUT_CU.bMsg6818;(* B6818 reserve operating message 226 *) (*import HMI Extension *)
	MM2VIS.bMsg6818		:=	xMsg68[18].Q;
			
	xMsg68[19].Set		:=	OUT_CU.bMsg6819;(* B6819 reserve operating message 227 *) (*import HMI Extension *)
	MM2VIS.bMsg6819		:=	xMsg68[19].Q;
			
	xMsg68[20].Set		:=	OUT_CU.bMsg6820;(* B6820 reserve operating message 228 *) (*import HMI Extension *)
	MM2VIS.bMsg6820		:=	xMsg68[20].Q;

	xMsg68[21].Set		:=	OUT_CU.bMsg6821;(* B6821 reserve operating message 229 *) (*import HMI Extension *)
	MM2VIS.bMsg6821		:=	xMsg68[21].Q;
			
	xMsg68[22].Set		:=	OUT_CU.bMsg6822;(* B6822 reserve operating message 230 *) (*import HMI Extension *)
	MM2VIS.bMsg6822		:=	xMsg68[22].Q;
			
	xMsg68[23].Set		:=	OUT_CU.bMsg6823;(* B6823 reserve operating message 231 *) (*import HMI Extension *)
	MM2VIS.bMsg6823		:=	xMsg68[23].Q;
			
	xMsg68[24].Set		:=	OUT_CU.bMsg6824;(* B6824 reserve operating message 232 *) (*import HMI Extension *)
	MM2VIS.bMsg6824		:=	xMsg68[24].Q;
			
	xMsg68[25].Set		:=	OUT_CU.bMsg6825;(* B6825 reserve operating message 233 *) (*import HMI Extension *)
	MM2VIS.bMsg6825		:=	xMsg68[25].Q;
			
	xMsg68[26].Set		:=	OUT_CU.bMsg6826;(* B6826 reserve operating message 234 *) (*import HMI Extension *)
	MM2VIS.bMsg6826		:=	xMsg68[26].Q;
			
	xMsg68[27].Set		:=	OUT_CU.bMsg6827;(* B6827 reserve operating message 235 *) (*import HMI Extension *)
	MM2VIS.bMsg6827		:=	xMsg68[27].Q;
			
	xMsg68[28].Set		:=	OUT_CU.bMsg6828;(* B6828 reserve operating message 236 *) (*import HMI Extension *)
	MM2VIS.bMsg6828		:=	xMsg68[28].Q;
			
	xMsg68[29].Set		:=	OUT_CU.bMsg6829;(* B6829 reserve operating message 237 *) (*import HMI Extension *)
	MM2VIS.bMsg6829		:=	xMsg68[29].Q;
			
	xMsg68[30].Set		:=	OUT_CU.bMsg6830;(* B6830 reserve operating message 238 *) (*import HMI Extension *)
	MM2VIS.bMsg6830		:=	xMsg68[30].Q;

	xMsg68[31].Set		:=	OUT_CU.bMsg6831;(* B6831 reserve operating message 239 *) (*import HMI Extension *)
	MM2VIS.bMsg6831		:=	xMsg68[31].Q;
			
	xMsg68[32].Set		:=	OUT_CU.bMsg6832;(* B6832 reserve operating message 240 *) (*import HMI Extension *)
	MM2VIS.bMsg6832		:=	xMsg68[32].Q;
			
	xMsg68[33].Set		:=	OUT_CU.bMsg6833;(* B6833 reserve operating message 241 *) (*import HMI Extension *)
	MM2VIS.bMsg6833		:=	xMsg68[33].Q;
			
	xMsg68[34].Set		:=	OUT_CU.bMsg6834;(* B6834 reserve operating message 242 *) (*import HMI Extension *)
	MM2VIS.bMsg6834		:=	xMsg68[34].Q;
			
	xMsg68[35].Set		:=	OUT_CU.bMsg6835;(* B6835 reserve operating message 243 *) (*import HMI Extension *)
	MM2VIS.bMsg6835		:=	xMsg68[35].Q;
			
	xMsg68[36].Set		:=	OUT_CU.bMsg6836;(* B6836 reserve operating message 244 *) (*import HMI Extension *)
	MM2VIS.bMsg6836		:=	xMsg68[36].Q;
			
	xMsg68[37].Set		:=	OUT_CU.bMsg6837;(* B6837 reserve operating message 245 *) (*import HMI Extension *)
	MM2VIS.bMsg6837		:=	xMsg68[37].Q;
			
	xMsg68[38].Set		:=	OUT_CU.bMsg6838;(* B6838 reserve operating message 246 *) (*import HMI Extension *)
	MM2VIS.bMsg6838		:=	xMsg68[38].Q;
			
	xMsg68[39].Set		:=	OUT_CU.bMsg6839;(* B6839 reserve operating message 247 *) (*import HMI Extension *)
	MM2VIS.bMsg6839		:=	xMsg68[39].Q;
			
	xMsg68[40].Set		:=	OUT_CU.bMsg6840;(* B6840 reserve operating message 248 *) (*import HMI Extension *)
	MM2VIS.bMsg6840		:=	xMsg68[40].Q;

	xMsg68[41].Set		:=	OUT_CU.bMsg6841;(* B6841 reserve operating message 249 *) (*import HMI Extension *)
	MM2VIS.bMsg6841		:=	xMsg68[41].Q;
			
	xMsg68[42].Set		:=	OUT_CU.bMsg6842;(* B6842 reserve operating message 250 *) (*import HMI Extension *)
	MM2VIS.bMsg6842		:=	xMsg68[42].Q;
			
	xMsg68[43].Set		:=	OUT_CU.bMsg6843;(* B6843 reserve operating message 251 *) (*import HMI Extension *)
	MM2VIS.bMsg6843		:=	xMsg68[43].Q;
			
	xMsg68[44].Set		:=	OUT_CU.bMsg6844;(* B6844 reserve operating message 252 *) (*import HMI Extension *)
	MM2VIS.bMsg6844		:=	xMsg68[44].Q;
			
	xMsg68[45].Set		:=	OUT_CU.bMsg6845;(* B6845 reserve operating message 253 *) (*import HMI Extension *)
	MM2VIS.bMsg6845		:=	xMsg68[45].Q;
			
	xMsg68[46].Set		:=	OUT_CU.bMsg6846;(* B6846 reserve operating message 254 *) (*import HMI Extension *)
	MM2VIS.bMsg6846		:=	xMsg68[46].Q;
			
	xMsg68[47].Set		:=	OUT_CU.bMsg6847;(* B6847 reserve operating message 255 *) (*import HMI Extension *)
	MM2VIS.bMsg6847		:=	xMsg68[47].Q;
			
	xMsg68[48].Set		:=	OUT_CU.bMsg6848;(* B6848 reserve operating message 256 *) (*import HMI Extension *)
	MM2VIS.bMsg6848		:=	xMsg68[48].Q;
			
	xMsg68[49].Set		:=	OUT_CU.bMsg6849;(* B6849 reserve operating message 257 *) (*import HMI Extension *)
	MM2VIS.bMsg6849		:=	xMsg68[49].Q;
			
	xMsg68[50].Set		:=	OUT_CU.bMsg6850;(* B6850 reserve operating message 258 *) (*import HMI Extension *)
	MM2VIS.bMsg6850		:=	xMsg68[50].Q;

	xMsg68[51].Set		:=	OUT_CU.bMsg6851;(* B6851 reserve operating message 259 *) (*import HMI Extension *)
	MM2VIS.bMsg6851		:=	xMsg68[51].Q;
			
	xMsg68[52].Set		:=	OUT_CU.bMsg6852;(* B6852 reserve operating message 260 *) (*import HMI Extension *)
	MM2VIS.bMsg6852		:=	xMsg68[52].Q;
			
	xMsg68[53].Set		:=	OUT_CU.bMsg6853;(* B6853 reserve operating message 261 *) (*import HMI Extension *)
	MM2VIS.bMsg6853		:=	xMsg68[53].Q;
			
	xMsg68[54].Set		:=	OUT_CU.bMsg6854;(* B6854 reserve operating message 262 *) (*import HMI Extension *)
	MM2VIS.bMsg6854		:=	xMsg68[54].Q;
			
	xMsg68[55].Set		:=	OUT_CU.bMsg6855;(* B6855 reserve operating message 263 *) (*import HMI Extension *)
	MM2VIS.bMsg6855		:=	xMsg68[55].Q;
			
	xMsg68[56].Set		:=	OUT_CU.bMsg6856;(* B6856 reserve operating message 264 *) (*import HMI Extension *)
	MM2VIS.bMsg6856		:=	xMsg68[56].Q;
			
	xMsg68[57].Set		:=	OUT_CU.bMsg6857;(* B6857 reserve operating message 265 *) (*import HMI Extension *)
	MM2VIS.bMsg6857		:=	xMsg68[57].Q;
			
	xMsg68[58].Set		:=	OUT_CU.bMsg6858;(* B6858 reserve operating message 266 *) (*import HMI Extension *)
	MM2VIS.bMsg6858		:=	xMsg68[58].Q;
			
	xMsg68[59].Set		:=	OUT_CU.bMsg6859;(* B6859 reserve operating message 267 *) (*import HMI Extension *)
	MM2VIS.bMsg6859		:=	xMsg68[59].Q;
			
	xMsg68[60].Set		:=	OUT_CU.bMsg6860;(* B6860 reserve operating message 268 *) (*import HMI Extension *)
	MM2VIS.bMsg6860		:=	xMsg68[60].Q;

	xMsg68[61].Set		:=	OUT_CU.bMsg6861;(* B6861 reserve operating message 269 *) (*import HMI Extension *)
	MM2VIS.bMsg6861		:=	xMsg68[61].Q;
			
	xMsg68[62].Set		:=	OUT_CU.bMsg6862;(* B6862 reserve operating message 270 *) (*import HMI Extension *)
	MM2VIS.bMsg6862		:=	xMsg68[62].Q;
			
	xMsg68[63].Set		:=	OUT_CU.bMsg6863;(* B6863 reserve operating message 271 *) (*import HMI Extension *)
	MM2VIS.bMsg6863		:=	xMsg68[63].Q;
			
	xMsg68[64].Set		:=	OUT_CU.bMsg6864;(* B6864 reserve operating message 272 *) (*import HMI Extension *)
	MM2VIS.bMsg6864		:=	xMsg68[64].Q;
			
	xMsg68[65].Set		:=	OUT_CU.bMsg6865;(* B6865 reserve operating message 273 *) (*import HMI Extension *)
	MM2VIS.bMsg6865		:=	xMsg68[65].Q;
			
	xMsg68[66].Set		:=	OUT_CU.bMsg6866;(* B6866 reserve operating message 274 *) (*import HMI Extension *)
	MM2VIS.bMsg6866		:=	xMsg68[66].Q;
			
	xMsg68[67].Set		:=	OUT_CU.bMsg6867;(* B6867 reserve operating message 275 *) (*import HMI Extension *)
	MM2VIS.bMsg6867		:=	xMsg68[67].Q;
			
	xMsg68[68].Set		:=	OUT_CU.bMsg6868;(* B6868 reserve operating message 276 *) (*import HMI Extension *)
	MM2VIS.bMsg6868		:=	xMsg68[68].Q;
			
	xMsg68[69].Set		:=	OUT_CU.bMsg6869;(* B6869 reserve operating message 277 *) (*import HMI Extension *)
	MM2VIS.bMsg6869		:=	xMsg68[69].Q;
			
	xMsg68[70].Set		:=	OUT_CU.bMsg6870;(* B6870 reserve operating message 278 *) (*import HMI Extension *)
	MM2VIS.bMsg6870		:=	xMsg68[70].Q;

	xMsg68[71].Set		:=	OUT_CU.bMsg6871;(* B6871 reserve operating message 279 *) (*import HMI Extension *)
	MM2VIS.bMsg6871		:=	xMsg68[71].Q;
			
	xMsg68[72].Set		:=	OUT_CU.bMsg6872;(* B6872 reserve operating message 280 *) (*import HMI Extension *)
	MM2VIS.bMsg6872		:=	xMsg68[72].Q;
			
	xMsg68[73].Set		:=	OUT_CU.bMsg6873;(* B6873 reserve operating message 281 *) (*import HMI Extension *)
	MM2VIS.bMsg6873		:=	xMsg68[73].Q;
			
	xMsg68[74].Set		:=	OUT_CU.bMsg6874;(* B6874 reserve operating message 282 *) (*import HMI Extension *)
	MM2VIS.bMsg6874		:=	xMsg68[74].Q;
			
	xMsg68[75].Set		:=	OUT_CU.bMsg6875;(* B6875 reserve operating message 283 *) (*import HMI Extension *)
	MM2VIS.bMsg6875		:=	xMsg68[75].Q;
			
	xMsg68[76].Set		:=	OUT_CU.bMsg6876;(* B6876 reserve operating message 284 *) (*import HMI Extension *)
	MM2VIS.bMsg6876		:=	xMsg68[76].Q;
			
	xMsg68[77].Set		:=	OUT_CU.bMsg6877;(* B6877 reserve operating message 285 *) (*import HMI Extension *)
	MM2VIS.bMsg6877		:=	xMsg68[77].Q;
			
	xMsg68[78].Set		:=	OUT_CU.bMsg6878;(* B6878 reserve operating message 286 *) (*import HMI Extension *)
	MM2VIS.bMsg6878		:=	xMsg68[78].Q;
			
	xMsg68[79].Set		:=	OUT_CU.bMsg6879;(* B6879 reserve operating message 287 *) (*import HMI Extension *)
	MM2VIS.bMsg6879		:=	xMsg68[79].Q;
			
	xMsg68[80].Set		:=	OUT_CU.bMsg6880;(* B6880 reserve operating message 288 *) (*import HMI Extension *)
	MM2VIS.bMsg6880		:=	xMsg68[80].Q;

	xMsg68[81].Set		:=	OUT_CU.bMsg6881;(* B6881 reserve operating message 289 *) (*import HMI Extension *)
	MM2VIS.bMsg6881		:=	xMsg68[81].Q;
			
	xMsg68[82].Set		:=	OUT_CU.bMsg6882;(* B6882 reserve operating message 290 *) (*import HMI Extension *)
	MM2VIS.bMsg6882		:=	xMsg68[82].Q;
			
	xMsg68[83].Set		:=	OUT_CU.bMsg6883;(* B6883 reserve operating message 291 *) (*import HMI Extension *)
	MM2VIS.bMsg6883		:=	xMsg68[83].Q;
			
	xMsg68[84].Set		:=	OUT_CU.bMsg6884;(* B6884 reserve operating message 292 *) (*import HMI Extension *)
	MM2VIS.bMsg6884		:=	xMsg68[84].Q;
			
	xMsg68[85].Set		:=	OUT_CU.bMsg6885;(* B6885 reserve operating message 293 *) (*import HMI Extension *)
	MM2VIS.bMsg6885		:=	xMsg68[85].Q;
			
	xMsg68[86].Set		:=	OUT_CU.bMsg6886;(* B6886 reserve operating message 294 *) (*import HMI Extension *)
	MM2VIS.bMsg6886		:=	xMsg68[86].Q;
			
	xMsg68[87].Set		:=	OUT_CU.bMsg6887;(* B6887 reserve operating message 295 *) (*import HMI Extension *)
	MM2VIS.bMsg6887		:=	xMsg68[87].Q;
			
	xMsg68[88].Set		:=	OUT_CU.bMsg6888;(* B6888 reserve operating message 296 *) (*import HMI Extension *)
	MM2VIS.bMsg6888		:=	xMsg68[88].Q;
			
	xMsg68[89].Set		:=	OUT_CU.bMsg6889;(* B6889 reserve operating message 297 *) (*import HMI Extension *)
	MM2VIS.bMsg6889		:=	xMsg68[89].Q;
			
	xMsg68[90].Set		:=	OUT_CU.bMsg6890;(* B6890 reserve operating message 298 *) (*import HMI Extension *)
	MM2VIS.bMsg6890		:=	xMsg68[90].Q;

	xMsg68[91].Set		:=	OUT_CU.bMsg6891;(* B6891 reserve operating message 299 *) (*import HMI Extension *)
	MM2VIS.bMsg6891		:=	xMsg68[91].Q;
			
	xMsg68[92].Set		:=	OUT_CU.bMsg6892;(* B6892 reserve operating message 300 *) (*import HMI Extension *)
	MM2VIS.bMsg6892		:=	xMsg68[92].Q;
			
	xMsg68[93].Set		:=	OUT_CU.bMsg6893;(* B6893 reserve operating message 301 *) (*import HMI Extension *)
	MM2VIS.bMsg6893		:=	xMsg68[93].Q;
			
	xMsg68[94].Set		:=	OUT_CU.bMsg6894;(* B6894 reserve operating message 302 *) (*import HMI Extension *)
	MM2VIS.bMsg6894		:=	xMsg68[94].Q;
			
	xMsg68[95].Set		:=	OUT_CU.bMsg6895;(* B6895 reserve operating message 303 *) (*import HMI Extension *)
	MM2VIS.bMsg6895		:=	xMsg68[95].Q;
			
	xMsg68[96].Set		:=	OUT_CU.bMsg6896;(* B6896 reserve operating message 304 *) (*import HMI Extension *)
	MM2VIS.bMsg6896		:=	xMsg68[96].Q;
			
	xMsg68[97].Set		:=	OUT_CU.bMsg6897;(* B6897 reserve operating message 305 *) (*import HMI Extension *)
	MM2VIS.bMsg6897		:=	xMsg68[97].Q;
			
	xMsg68[98].Set		:=	OUT_CU.bMsg6898;(* B6898 reserve operating message 306 *) (*import HMI Extension *)
	MM2VIS.bMsg6898		:=	xMsg68[98].Q;
			
	xMsg68[99].Set		:=	OUT_CU.bMsg6899;(* B6899 reserve operating message 307 *) (*import HMI Extension *)
	MM2VIS.bMsg6899		:=	xMsg68[99].Q;
			
//OLD	xMsg68[100].Set		:=	OUT_CU.bMsgxxxx;(* B4200 reserve operating message 308 OLD, do not use*) (*import HMI Extension *)
//OLD	MM2VIS.bMsg4200		:=	xMsg41[100].Q;
	
	(*----------------------------------------------------------------------*)				
	iDelay_MsgAutoReset_100ms 	:= LIMIT(0, TIME_TO_INT(Para.tiDelay_MsgAutoReset / 100), 32767);	(*To Do: missing prototype parameter *)
	IF Para.tiDelay_MsgAutoReset = 0 THEN Para.tiDelay_MsgAutoReset := T#01m; END_IF				(*To Do: missing prototype parameter *)	
	(*----------------------------------------------------------------------*)	

END_PROGRAM



