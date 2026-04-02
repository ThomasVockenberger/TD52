(*******************************************************************************
Msg_CU	 			 alarms generation MM_Customized

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new
V4.07.1	29.03.2019	Hohensinner	added Warnings: W9285, W9286, W9287
V4.11.1	20.01.2022	Zengerer	added Arrays: B67xx, B68xx, W87xx

														
Instructions for use:
--------------------
1) declare alarm with function block "Msg"

2) use template to create a new alarm, substitue 0000 by message number:

	xMsg0000.Num		:=	0000;					alarm number
	xMsg0000.AmmSysAdr	:=  iAdrAmmBase2MM;			do not change
	xMsg0000.AmmOutAdr	:=  iAdrMM2AmmBase;			do not change

3) 	set alarm number
	

			
Outstandings:
------------
(*******************************************************************************)
PROGRAM _INIT
		
	iAdrAmmBase2MM		:=  ADR(IN_CU.tAB2CU);
	iAdrMM2AmmBase		:=  ADR(OUT_CU.tCU2AB);
		
	(*---------------------------------------------------------------------------*)
	xMsg1001.Num		:=	1001;	
	xMsg1001.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1001.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1002.Num		:=	1002;	
	xMsg1002.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1002.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1003.Num		:=	1003;	
	xMsg1003.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1003.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1004.Num		:=	1004;	
	xMsg1004.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1004.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1005.Num		:=	1005;	
	xMsg1005.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1005.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1006.Num		:=	1006;	
	xMsg1006.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1006.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1007.Num		:=	1007;	
	xMsg1007.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1007.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1008.Num		:=	1008;	
	xMsg1008.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1008.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1009.Num		:=	1009;	
	xMsg1009.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1009.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1010.Num		:=	1010;	
	xMsg1010.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1010.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1011.Num		:=	1011;	
	xMsg1011.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1011.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1012.Num		:=	1012;	
	xMsg1012.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1012.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1013.Num		:=	1013;	
	xMsg1013.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1013.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1014.Num		:=	1014;	
	xMsg1014.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1014.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1015.Num		:=	1015;	
	xMsg1015.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1015.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1016.Num		:=	1016;	
	xMsg1016.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1016.AmmOutAdr	:=  iAdrMM2AmmBase;

	
	xMsg1177.Num		:=	1177;			(* W1177 Signal fail: reserve analog in 1 *)
	xMsg1177.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1177.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1178.Num		:=	1178;			(* W1178 Signal fail: reserve analog in 2 *)
	xMsg1178.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1178.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1179.Num		:=	1179;			(* W1179 Signal fail: reserve analog in 3 *)
	xMsg1179.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1179.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1180.Num		:=	1180;			(* W1180 Signal fail: reserve analog in 4 *)
	xMsg1180.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1180.AmmOutAdr	:=  iAdrMM2AmmBase;		
	
	xMsg1181.Num		:=	1181;			(* W1181 Signal fail: reserve analog in 5 *)
	xMsg1181.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1181.AmmOutAdr	:=  iAdrMM2AmmBase;		

	xMsg1182.Num		:=	1182;			(* W1182 Signal fail: reserve analog in 6 *)
	xMsg1182.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1182.AmmOutAdr	:=  iAdrMM2AmmBase;		
	
	xMsg1183.Num		:=	1183;			(* W1183 Signal fail: reserve analog in 7 *)
	xMsg1183.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1183.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg1184.Num		:=	1184;			(* W1184 Signal fail: reserve analog in 8 *)
	xMsg1184.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1184.AmmOutAdr	:=  iAdrMM2AmmBase;		
		
				

	xMsg1193.Num		:=	1193;	
	xMsg1193.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1193.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1194.Num		:=	1194;	
	xMsg1194.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1194.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1195.Num		:=	1195;	
	xMsg1195.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1195.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1196.Num		:=	1196;	
	xMsg1196.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1196.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1197.Num		:=	1197;	
	xMsg1197.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1197.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1198.Num		:=	1198;	
	xMsg1198.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1198.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1199.Num		:=	1199;	
	xMsg1199.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1199.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1200.Num		:=	1200;	
	xMsg1200.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1200.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1201.Num		:=	1201;	
	xMsg1201.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1201.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1202.Num		:=	1202;	
	xMsg1202.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1202.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1203.Num		:=	1203;	
	xMsg1203.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1203.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1204.Num		:=	1204;	
	xMsg1204.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1204.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1205.Num		:=	1205;	
	xMsg1205.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1205.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg1206.Num		:=	1206;	
	xMsg1206.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1206.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg1207.Num		:=	1207;	
	xMsg1207.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1207.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg1208.Num		:=	1208;	
	xMsg1208.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1208.AmmOutAdr	:=  iAdrMM2AmmBase;


	
	(*W1300, W1301 - W1399 Reserve AnalogIN 1-30*)
	(*moved*)
	(*W1400, W1401 - W1499 Reserve AnalogIN ...*)
	(*moved*)
	
	
	(*A1601, A1602 - A1700 additional Reserve ALARMS *)
	FOR cnt := 0 TO 100 DO								(*remark: index 0 element is not in use, but called here also, to avoid possible watch errors in some AS- versions *)
		xMsg16[cnt].Num			:=	1600+cnt;	
		xMsg16[cnt].AmmInAdr	:=  iAdrAmmBase2MM;
		xMsg16[cnt].AmmOutAdr	:=  iAdrMM2AmmBase;
	END_FOR 

	(*W1701, W1702 - W1800 additional Reserve WARNINGS *)
	FOR cnt := 0 TO 100 DO								(*remark: index 0 element is not in use, but called here also, to avoid possible watch errors in some AS- versions *)
		xMsg17[cnt].Num			:=	1700+cnt;	
		xMsg17[cnt].AmmInAdr	:=  iAdrAmmBase2MM;
		xMsg17[cnt].AmmOutAdr	:=  iAdrMM2AmmBase;
	END_FOR 

		

	xMsg2087.Num		:=	2087;	
	xMsg2087.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2087.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2088.Num		:=	2088;	
	xMsg2088.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2088.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2089.Num		:=	2089;	
	xMsg2089.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2089.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2090.Num		:=	2090;	
	xMsg2090.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2090.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2091.Num		:=	2091;	
	xMsg2091.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2091.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2092.Num		:=	2092;	
	xMsg2092.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2092.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2093.Num		:=	2093;	
	xMsg2093.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2093.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2094.Num		:=	2094;	
	xMsg2094.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2094.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2095.Num		:=	2095;	
	xMsg2095.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2095.AmmOutAdr	:=  iAdrMM2AmmBase;



	xMsg2096.Num		:=	2096;	
	xMsg2096.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2096.AmmOutAdr	:=  iAdrMM2AmmBase;

	
	
	(*- NETZBEZUGSREGLER --------------------------------------------------------------------*)

	xMsg2302.Num		:=	2302;	
	xMsg2302.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2302.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2303.Num		:=	2303;	
	xMsg2303.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2303.AmmOutAdr	:=  iAdrMM2AmmBase;

	
	xMsg2415.Num		:=	2415;	
	xMsg2415.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2415.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2416.Num		:=	2416;	
	xMsg2416.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2416.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2417.Num		:=	2417;	
	xMsg2417.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2417.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2418.Num		:=	2418;	
	xMsg2418.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2418.AmmOutAdr	:=  iAdrMM2AmmBase;

	
	xMsg2419.Num		:=	2419;	
	xMsg2419.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2419.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2420.Num		:=	2420;	
	xMsg2420.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2420.AmmOutAdr	:=  iAdrMM2AmmBase;

	
	(*************)

	xMsg3232.Num		:=	3232;	
	xMsg3232.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3232.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3233.Num		:=	3233;	
	xMsg3233.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3233.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3234.Num		:=	3234;	
	xMsg3234.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3234.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3235.Num		:=	3235;	
	xMsg3235.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3235.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3236.Num		:=	3236;	
	xMsg3236.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3236.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3237.Num		:=	3237;	
	xMsg3237.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3237.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3250.Num		:=	3250;	
	xMsg3250.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3250.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3251.Num		:=	3251;	
	xMsg3251.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3251.AmmOutAdr	:=  iAdrMM2AmmBase;

	(*************)

	xMsg3565.Num		:=	3565;	
	xMsg3565.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3565.AmmOutAdr	:=  iAdrMM2AmmBase;

	(*************)
	
	(*A8966 - A8999 Reserve AnalogIN Alarms *)	
	(*moved*)	

	(*************)

	(*B3601 - 3699 additional Reserve op.messages *)
	FOR cnt := 0 TO 100 DO								(*remark: index 0 element is not in use, but called here also, to avoid possible watch errors in some AS- versions *)
		xMsg36[cnt].Num			:=	3600+cnt;			(* bugfix 2018! *)
		xMsg36[cnt].AmmInAdr	:=  iAdrAmmBase2MM;
		xMsg36[cnt].AmmOutAdr	:=  iAdrMM2AmmBase;
	END_FOR 

	xMsg3700.Num		:=	3700;	
	xMsg3700.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3700.AmmOutAdr	:=  iAdrMM2AmmBase;

	(*B6701 - 6800 additional Reserve op.messages *)	(*import HMI Extension *)
	FOR cnt := 0 TO 100 DO								(*remark: index 0 element is not in use, but called here also, to avoid possible watch errors in some AS- versions *)
		xMsg67[cnt].Num			:=	6700+cnt;
		xMsg67[cnt].AmmInAdr	:=  iAdrAmmBase2MM;
		xMsg67[cnt].AmmOutAdr	:=  iAdrMM2AmmBase;
	END_FOR 
	
	(*B6800 - 6899 additional Reserve op.messages *)	(*import HMI Extension *)
	FOR cnt := 0 TO 99 DO								(*remark: index 100 element is not in use, but called here also, to avoid possible watch errors in some AS- versions *)
		xMsg68[cnt].Num			:=	6800+cnt;
		xMsg68[cnt].AmmInAdr	:=  iAdrAmmBase2MM;
		xMsg68[cnt].AmmOutAdr	:=  iAdrMM2AmmBase;
	END_FOR 
	
	(*B8701 - 8799 additional Reserve WARNINGS *)		(*import HMI Extension *)
	FOR cnt := 0 TO 99 DO								(*remark: index 100 element is not in use, but called here also, to avoid possible watch errors in some AS- versions *)
		xMsg87[cnt].Num			:=	8700+cnt;
		xMsg87[cnt].AmmInAdr	:=  iAdrAmmBase2MM;
		xMsg87[cnt].AmmOutAdr	:=  iAdrMM2AmmBase;
	END_FOR 
	
	(*************)

	xMsg9286.Num		:=	9286;	
	xMsg9286.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9286.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9287.Num		:=	9287;	
	xMsg9287.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9287.AmmOutAdr	:=  iAdrMM2AmmBase;

	(*************)

	(* OPERATING MESSAGES: *)	
		OUT_CU.bMsg3232 :=		FALSE;	(* B3232 reserve operating message 1 *)
		OUT_CU.bMsg3233 :=		FALSE;	(* B3233 reserve operating message 2 *)
		OUT_CU.bMsg3234 :=		FALSE;	(* B3234 reserve operating message 3 *)
		OUT_CU.bMsg3235 :=		FALSE;	(* B3235 reserve operating message 4 *)
		OUT_CU.bMsg3236 := 		FALSE;	(* B3236 reserve operating message 5 *)
		OUT_CU.bMsg3237 := 		FALSE;	(* B3237 reserve operating message 6 *)
	
		OUT_CU.bMsg3250 := 		FALSE;	(* B3250 reserve operating message 7 *)
		OUT_CU.bMsg3251 := 		FALSE;	(* B3251 reserve operating message 8 *)
	
	
		OUT_CU.bMsg3601 := 		FALSE;	(* B3601 reserve operating message 9 *)
		OUT_CU.bMsg3602 := 		FALSE;	(* B3602 reserve operating message 10 *)
		OUT_CU.bMsg3603 := 		FALSE;	(* B3603 reserve operating message 11 *)
		OUT_CU.bMsg3604 := 		FALSE;	(* B3604 reserve operating message 12 *)
		OUT_CU.bMsg3605 := 		FALSE;	(* B3605 reserve operating message 13 *)
		OUT_CU.bMsg3606 := 		FALSE;	(* B3606 reserve operating message 14 *)
		OUT_CU.bMsg3607 := 		FALSE;	(* B3607 reserve operating message 15 *)
		OUT_CU.bMsg3608 := 		FALSE;	(* B3608 reserve operating message 16 *)
		OUT_CU.bMsg3609 := 		FALSE;	(* B3609 reserve operating message 17 *)
		OUT_CU.bMsg3610 := 		FALSE;	(* B3610 reserve operating message 18 *)

		OUT_CU.bMsg3611 := 		FALSE;	(* B3611 reserve operating message 19 *)
		OUT_CU.bMsg3612 := 		FALSE;	(*  	 reserve operating message 20 *)
		OUT_CU.bMsg3613 := 		FALSE;	(* 		 reserve operating message 21 *)
		OUT_CU.bMsg3614 := 		FALSE;	(* 		 reserve operating message 22 *)
		OUT_CU.bMsg3615 := 		FALSE;	(* 		 reserve operating message 23 *)
		OUT_CU.bMsg3616 := 		FALSE;	(* 		 reserve operating message 24 *)
		OUT_CU.bMsg3617 := 		FALSE;	(* 		 reserve operating message 25 *)
		OUT_CU.bMsg3618 := 		FALSE;	(* 		 reserve operating message 26 *)
		OUT_CU.bMsg3619 := 		FALSE;	(* 		 reserve operating message 27 *)
		OUT_CU.bMsg3620 := 		FALSE;	(* 		 reserve operating message 28 *)
	
	
		OUT_CU.bMsg3621 := 		FALSE;	(* B3621 reserve operating message 29 *)
		OUT_CU.bMsg3622 := 		FALSE;	(* 		 reserve operating message 30 *)
		OUT_CU.bMsg3623 := 		FALSE;	(* 		 reserve operating message 31 *)
		OUT_CU.bMsg3624 := 		FALSE;	(* 		 reserve operating message 32 *)
		OUT_CU.bMsg3625 := 		FALSE;	(* 		 reserve operating message 33 *)
		OUT_CU.bMsg3626 := 		FALSE;	(* 		 reserve operating message 34 *)
		OUT_CU.bMsg3627 := 		FALSE;	(* 		 reserve operating message 35 *)
		OUT_CU.bMsg3628 := 		FALSE;	(* 		 reserve operating message 36 *)
		OUT_CU.bMsg3629 := 		FALSE;	(* 		 reserve operating message 37 *)
		OUT_CU.bMsg3630 := 		FALSE;	(* 		 reserve operating message 38 *)
		
		OUT_CU.bMsg3631 := 		FALSE;	(* 		 reserve operating message 39 *)
		OUT_CU.bMsg3632 := 		FALSE;	(* 		 reserve operating message 40 *)
		OUT_CU.bMsg3633 := 		FALSE;	(* 		 reserve operating message 41 *)
		OUT_CU.bMsg3634 := 		FALSE;	(* 		 reserve operating message 42 *)
		OUT_CU.bMsg3635 := 		FALSE;	(* 		 reserve operating message 43 *)
		OUT_CU.bMsg3636 := 		FALSE;	(* 		 reserve operating message 44 *)
		OUT_CU.bMsg3637 := 		FALSE;	(* 		 reserve operating message 45 *)
		OUT_CU.bMsg3638 := 		FALSE;	(* 		 reserve operating message 46 *)
		OUT_CU.bMsg3639 := 		FALSE;	(* 		 reserve operating message 47 *)
		OUT_CU.bMsg3640 := 		FALSE;	(* 		 reserve operating message 48 *)
	
	
		OUT_CU.bMsg3641 := 		FALSE;	(* B3641 reserve operating message 49 *)
		OUT_CU.bMsg3642 := 		FALSE;	(* 		 reserve operating message 50 *)
		OUT_CU.bMsg3643 := 		FALSE;	(* 		 reserve operating message 51 *)
		OUT_CU.bMsg3644 := 		FALSE;	(* 		 reserve operating message 52 *)
		OUT_CU.bMsg3645 := 		FALSE;	(* 		 reserve operating message 53 *)
		OUT_CU.bMsg3646 := 		FALSE;	(* 		 reserve operating message 54 *)
		OUT_CU.bMsg3647 := 		FALSE;	(* 		 reserve operating message 55 *)
		OUT_CU.bMsg3648 := 		FALSE;	(* 		 reserve operating message 56 *)
		OUT_CU.bMsg3649 := 		FALSE;	(* 		 reserve operating message 57 *)
		OUT_CU.bMsg3650 := 		FALSE;	(* 		 reserve operating message 58 *)
		
		OUT_CU.bMsg3651 := 		FALSE;	(* 		 reserve operating message 59 *)
		OUT_CU.bMsg3652 := 		FALSE;	(* 		 reserve operating message 60 *)
		OUT_CU.bMsg3653 := 		FALSE;	(* 		 reserve operating message 61 *)
		OUT_CU.bMsg3654 := 		FALSE;	(* 		 reserve operating message 62 *)
		OUT_CU.bMsg3655 := 		FALSE;	(* 		 reserve operating message 63 *)
		OUT_CU.bMsg3656 := 		FALSE;	(* 		 reserve operating message 64 *)
		OUT_CU.bMsg3657 := 		FALSE;	(* 		 reserve operating message 65 *)
		OUT_CU.bMsg3658 := 		FALSE;	(* 		 reserve operating message 66 *)
		OUT_CU.bMsg3659 := 		FALSE;	(* 		 reserve operating message 67 *)
		OUT_CU.bMsg3660 := 		FALSE;	(* 		 reserve operating message 68 *)
	
	
		OUT_CU.bMsg3661 := 		FALSE;	(* B3661 reserve operating message 69 *)
		OUT_CU.bMsg3662 := 		FALSE;	(* 		 reserve operating message 70 *)
		OUT_CU.bMsg3663 := 		FALSE;	(* 		 reserve operating message 71 *)
		OUT_CU.bMsg3664 := 		FALSE;	(* 		 reserve operating message 72 *)
		OUT_CU.bMsg3665 := 		FALSE;	(* 		 reserve operating message 73 *)
		OUT_CU.bMsg3666 := 		FALSE;	(* 		 reserve operating message 74 *)
		OUT_CU.bMsg3667 := 		FALSE;	(* 		 reserve operating message 75 *)
		OUT_CU.bMsg3668 := 		FALSE;	(* 		 reserve operating message 76 *)
		OUT_CU.bMsg3669 := 		FALSE;	(* 		 reserve operating message 77 *)
		OUT_CU.bMsg3670 := 		FALSE;	(* 		 reserve operating message 78 *)
		
		OUT_CU.bMsg3671 := 		FALSE;	(* 		 reserve operating message 79 *)
		OUT_CU.bMsg3672 := 		FALSE;	(* 		 reserve operating message 80 *)
		OUT_CU.bMsg3673 := 		FALSE;	(* 		 reserve operating message 81 *)
		OUT_CU.bMsg3674 := 		FALSE;	(* 		 reserve operating message 82 *)
		OUT_CU.bMsg3675 := 		FALSE;	(* 		 reserve operating message 83 *)
		OUT_CU.bMsg3676 := 		FALSE;	(* 		 reserve operating message 84 *)
		OUT_CU.bMsg3677 := 		FALSE;	(* 		 reserve operating message 85 *)
		OUT_CU.bMsg3678 := 		FALSE;	(* 		 reserve operating message 86 *)
		OUT_CU.bMsg3679 := 		FALSE;	(* 		 reserve operating message 87 *)
		OUT_CU.bMsg3680 := 		FALSE;	(* 		 reserve operating message 88 *)

	
		OUT_CU.bMsg3681 := 		FALSE;	(* B3681 reserve operating message 89 *)
		OUT_CU.bMsg3682 := 		FALSE;	(* 		 reserve operating message 90 *)
		OUT_CU.bMsg3683 := 		FALSE;	(* 		 reserve operating message 91 *)
		OUT_CU.bMsg3684 := 		FALSE;	(* 		 reserve operating message 92 *)
		OUT_CU.bMsg3685 := 		FALSE;	(* 		 reserve operating message 93 *)
		OUT_CU.bMsg3686 := 		FALSE;	(* 		 reserve operating message 94 *)
		OUT_CU.bMsg3687 := 		FALSE;	(* 		 reserve operating message 95 *)
		OUT_CU.bMsg3688 := 		FALSE;	(* 		 reserve operating message 96 *)
		OUT_CU.bMsg3689 := 		FALSE;	(* 		 reserve operating message 97 *)
		OUT_CU.bMsg3690 := 		FALSE;	(* 		 reserve operating message 98 *)
		
		OUT_CU.bMsg3691 := 		FALSE;	(* 		 reserve operating message 99 *)
		OUT_CU.bMsg3692 := 		FALSE;	(* 		 reserve operating message 100 *)
		OUT_CU.bMsg3693 := 		FALSE;	(* 		 reserve operating message 101 *)
		OUT_CU.bMsg3694 := 		FALSE;	(* 		 reserve operating message 102 *)
		OUT_CU.bMsg3695 := 		FALSE;	(* 		 reserve operating message 103 *)
		OUT_CU.bMsg3696 := 		FALSE;	(* 		 reserve operating message 104 *)
		OUT_CU.bMsg3697 := 		FALSE;	(* 		 reserve operating message 105 *)
		OUT_CU.bMsg3698 := 		FALSE;	(* 		 reserve operating message 106 *)
		OUT_CU.bMsg3699 := 		FALSE;	(* 		 reserve operating message 107 *)
		OUT_CU.bMsg3700 := 		FALSE;	(* 		 reserve operating message 108 *)

		OUT_CU.bMsg6701 := 		FALSE;	(* B6701 reserve operating message 109 *) (*import HMI Extension *)
		OUT_CU.bMsg6702 := 		FALSE;	(* B6702 reserve operating message 110 *) (*import HMI Extension *)
		OUT_CU.bMsg6703 := 		FALSE;	(* B6703 reserve operating message 111 *) (*import HMI Extension *)
		OUT_CU.bMsg6704 := 		FALSE;	(* B6704 reserve operating message 112 *) (*import HMI Extension *)
		OUT_CU.bMsg6705 := 		FALSE;	(* B6705 reserve operating message 113 *) (*import HMI Extension *)
		OUT_CU.bMsg6706 := 		FALSE;	(* B6706 reserve operating message 114 *) (*import HMI Extension *)
		OUT_CU.bMsg6707 := 		FALSE;	(* B6707 reserve operating message 115 *) (*import HMI Extension *)
		OUT_CU.bMsg6708 := 		FALSE;	(* B6708 reserve operating message 116 *) (*import HMI Extension *)
		OUT_CU.bMsg6709 := 		FALSE;	(* B6709 reserve operating message 117 *) (*import HMI Extension *)
		OUT_CU.bMsg6710 := 		FALSE;	(* B6710 reserve operating message 118 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6711 := 		FALSE;	(* B6711 reserve operating message 119 *) (*import HMI Extension *)
		OUT_CU.bMsg6712 := 		FALSE;	(* B6712 reserve operating message 120 *) (*import HMI Extension *)
		OUT_CU.bMsg6713 := 		FALSE;	(* B6713 reserve operating message 121 *) (*import HMI Extension *)
		OUT_CU.bMsg6714 := 		FALSE;	(* B6714 reserve operating message 122 *) (*import HMI Extension *)
		OUT_CU.bMsg6715 := 		FALSE;	(* B6715 reserve operating message 123 *) (*import HMI Extension *)
		OUT_CU.bMsg6716 := 		FALSE;	(* B6716 reserve operating message 124 *) (*import HMI Extension *)
		OUT_CU.bMsg6717 := 		FALSE;	(* B6717 reserve operating message 125 *) (*import HMI Extension *)
		OUT_CU.bMsg6718 := 		FALSE;	(* B6718 reserve operating message 126 *) (*import HMI Extension *)
		OUT_CU.bMsg6719 := 		FALSE;	(* B6719 reserve operating message 127 *) (*import HMI Extension *)
		OUT_CU.bMsg6720 := 		FALSE;	(* B6720 reserve operating message 128 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6721 := 		FALSE;	(* B6721 reserve operating message 129 *) (*import HMI Extension *)
		OUT_CU.bMsg6722 := 		FALSE;	(* B6722 reserve operating message 130 *) (*import HMI Extension *)
		OUT_CU.bMsg6723 := 		FALSE;	(* B6723 reserve operating message 131 *) (*import HMI Extension *)
		OUT_CU.bMsg6724 := 		FALSE;	(* B6724 reserve operating message 132 *) (*import HMI Extension *)
		OUT_CU.bMsg6725 := 		FALSE;	(* B6725 reserve operating message 133 *) (*import HMI Extension *)
		OUT_CU.bMsg6726 := 		FALSE;	(* B6726 reserve operating message 134 *) (*import HMI Extension *)
		OUT_CU.bMsg6727 := 		FALSE;	(* B6727 reserve operating message 135 *) (*import HMI Extension *)
		OUT_CU.bMsg6728 := 		FALSE;	(* B6728 reserve operating message 136 *) (*import HMI Extension *)
		OUT_CU.bMsg6729 := 		FALSE;	(* B6729 reserve operating message 137 *) (*import HMI Extension *)
		OUT_CU.bMsg6730 := 		FALSE;	(* B6730 reserve operating message 138 *) (*import HMI Extension *)
		
		OUT_CU.bMsg6731 := 		FALSE;	(* B6731 reserve operating message 139 *) (*import HMI Extension *)
		OUT_CU.bMsg6732 := 		FALSE;	(* B6732 reserve operating message 140 *) (*import HMI Extension *)
		OUT_CU.bMsg6733 := 		FALSE;	(* B6733 reserve operating message 141 *) (*import HMI Extension *)
		OUT_CU.bMsg6734 := 		FALSE;	(* B6734 reserve operating message 142 *) (*import HMI Extension *)
		OUT_CU.bMsg6735 := 		FALSE;	(* B6735 reserve operating message 143 *) (*import HMI Extension *)
		OUT_CU.bMsg6736 := 		FALSE;	(* B6736 reserve operating message 144 *) (*import HMI Extension *)
		OUT_CU.bMsg6737 := 		FALSE;	(* B6737 reserve operating message 145 *) (*import HMI Extension *)
		OUT_CU.bMsg6738 := 		FALSE;	(* B6738 reserve operating message 146 *) (*import HMI Extension *)
		OUT_CU.bMsg6739 := 		FALSE;	(* B6739 reserve operating message 147 *) (*import HMI Extension *)
		OUT_CU.bMsg6740 := 		FALSE;	(* B6740 reserve operating message 148 *) (*import HMI Extension *)
		
		OUT_CU.bMsg6741 := 		FALSE;	(* B6741 reserve operating message 149 *) (*import HMI Extension *)
		OUT_CU.bMsg6742 := 		FALSE;	(* B6742 reserve operating message 150 *) (*import HMI Extension *)
		OUT_CU.bMsg6743 := 		FALSE;	(* B6743 reserve operating message 151 *) (*import HMI Extension *)
		OUT_CU.bMsg6744 := 		FALSE;	(* B6744 reserve operating message 152 *) (*import HMI Extension *)
		OUT_CU.bMsg6745 := 		FALSE;	(* B6745 reserve operating message 153 *) (*import HMI Extension *)
		OUT_CU.bMsg6746 := 		FALSE;	(* B6746 reserve operating message 154 *) (*import HMI Extension *)
		OUT_CU.bMsg6747 := 		FALSE;	(* B6747 reserve operating message 155 *) (*import HMI Extension *)
		OUT_CU.bMsg6748 := 		FALSE;	(* B6748 reserve operating message 156 *) (*import HMI Extension *)
		OUT_CU.bMsg6749 := 		FALSE;	(* B6749 reserve operating message 157 *) (*import HMI Extension *)
		OUT_CU.bMsg6750 := 		FALSE;	(* B6750 reserve operating message 158 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6751 := 		FALSE;	(* B6751 reserve operating message 159 *) (*import HMI Extension *)
		OUT_CU.bMsg6752 := 		FALSE;	(* B6752 reserve operating message 160 *) (*import HMI Extension *)
		OUT_CU.bMsg6753 := 		FALSE;	(* B6753 reserve operating message 161 *) (*import HMI Extension *)
		OUT_CU.bMsg6754 := 		FALSE;	(* B6754 reserve operating message 162 *) (*import HMI Extension *)
		OUT_CU.bMsg6755 := 		FALSE;	(* B6755 reserve operating message 163 *) (*import HMI Extension *)
		OUT_CU.bMsg6756 := 		FALSE;	(* B6756 reserve operating message 164 *) (*import HMI Extension *)
		OUT_CU.bMsg6757 := 		FALSE;	(* B6757 reserve operating message 165 *) (*import HMI Extension *)
		OUT_CU.bMsg6758 := 		FALSE;	(* B6758 reserve operating message 166 *) (*import HMI Extension *)
		OUT_CU.bMsg6759 := 		FALSE;	(* B6759 reserve operating message 167 *) (*import HMI Extension *)
		OUT_CU.bMsg6760 := 		FALSE;	(* B6760 reserve operating message 168 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6761 := 		FALSE;	(* B6761 reserve operating message 169 *) (*import HMI Extension *)
		OUT_CU.bMsg6762 := 		FALSE;	(* B6762 reserve operating message 170 *) (*import HMI Extension *)
		OUT_CU.bMsg6763 := 		FALSE;	(* B6763 reserve operating message 171 *) (*import HMI Extension *)
		OUT_CU.bMsg6764 := 		FALSE;	(* B6764 reserve operating message 172 *) (*import HMI Extension *)
		OUT_CU.bMsg6765 := 		FALSE;	(* B6765 reserve operating message 173 *) (*import HMI Extension *)
		OUT_CU.bMsg6766 := 		FALSE;	(* B6766 reserve operating message 174 *) (*import HMI Extension *)
		OUT_CU.bMsg6767 := 		FALSE;	(* B6767 reserve operating message 175 *) (*import HMI Extension *)
		OUT_CU.bMsg6768 := 		FALSE;	(* B6768 reserve operating message 176 *) (*import HMI Extension *)
		OUT_CU.bMsg6769 := 		FALSE;	(* B6769 reserve operating message 177 *) (*import HMI Extension *)
		OUT_CU.bMsg6770 := 		FALSE;	(* B6770 reserve operating message 178 *) (*import HMI Extension *)
		
		OUT_CU.bMsg6771 := 		FALSE;	(* B6771 reserve operating message 179 *) (*import HMI Extension *)
		OUT_CU.bMsg6772 := 		FALSE;	(* B6772 reserve operating message 180 *) (*import HMI Extension *)
		OUT_CU.bMsg6773 := 		FALSE;	(* B6773 reserve operating message 181 *) (*import HMI Extension *)
		OUT_CU.bMsg6774 := 		FALSE;	(* B6774 reserve operating message 182 *) (*import HMI Extension *)
		OUT_CU.bMsg6775 := 		FALSE;	(* B6775 reserve operating message 183 *) (*import HMI Extension *)
		OUT_CU.bMsg6776 := 		FALSE;	(* B6776 reserve operating message 184 *) (*import HMI Extension *)
		OUT_CU.bMsg6777 := 		FALSE;	(* B6777 reserve operating message 185 *) (*import HMI Extension *)
		OUT_CU.bMsg6778 := 		FALSE;	(* B6778 reserve operating message 186 *) (*import HMI Extension *)
		OUT_CU.bMsg6779 := 		FALSE;	(* B6779 reserve operating message 187 *) (*import HMI Extension *)
		OUT_CU.bMsg6780 := 		FALSE;	(* B6780 reserve operating message 188 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6781 := 		FALSE;	(* B6781 reserve operating message 189 *) (*import HMI Extension *)
		OUT_CU.bMsg6782 := 		FALSE;	(* B6782 reserve operating message 190 *) (*import HMI Extension *)
		OUT_CU.bMsg6783 := 		FALSE;	(* B6783 reserve operating message 191 *) (*import HMI Extension *)
		OUT_CU.bMsg6784 := 		FALSE;	(* B6784 reserve operating message 192 *) (*import HMI Extension *)
		OUT_CU.bMsg6785 := 		FALSE;	(* B6785 reserve operating message 193 *) (*import HMI Extension *)
		OUT_CU.bMsg6786 := 		FALSE;	(* B6786 reserve operating message 194 *) (*import HMI Extension *)
		OUT_CU.bMsg6787 := 		FALSE;	(* B6787 reserve operating message 195 *) (*import HMI Extension *)
		OUT_CU.bMsg6788 := 		FALSE;	(* B6788 reserve operating message 196 *) (*import HMI Extension *)
		OUT_CU.bMsg6789 := 		FALSE;	(* B6789 reserve operating message 197 *) (*import HMI Extension *)
		OUT_CU.bMsg6790 := 		FALSE;	(* B6790 reserve operating message 198 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6791 := 		FALSE;	(* B6791 reserve operating message 199 *) (*import HMI Extension *)
		OUT_CU.bMsg6792 := 		FALSE;	(* B6792 reserve operating message 200 *) (*import HMI Extension *)
		OUT_CU.bMsg6793 := 		FALSE;	(* B6793 reserve operating message 201 *) (*import HMI Extension *)
		OUT_CU.bMsg6794 := 		FALSE;	(* B6794 reserve operating message 202 *) (*import HMI Extension *)
		OUT_CU.bMsg6795 := 		FALSE;	(* B6795 reserve operating message 203 *) (*import HMI Extension *)
		OUT_CU.bMsg6796 := 		FALSE;	(* B6796 reserve operating message 204 *) (*import HMI Extension *)
		OUT_CU.bMsg6797 := 		FALSE;	(* B6797 reserve operating message 205 *) (*import HMI Extension *)
		OUT_CU.bMsg6798 := 		FALSE;	(* B6798 reserve operating message 206 *) (*import HMI Extension *)
		OUT_CU.bMsg6799 := 		FALSE;	(* B6799 reserve operating message 207 *) (*import HMI Extension *)
		OUT_CU.bMsg6800 := 		FALSE;	(* B6800 reserve operating message 208 *) (*import HMI Extension *)
		
		OUT_CU.bMsg6801 := 		FALSE;	(* B6801 reserve operating message 209 *) (*import HMI Extension *)
		OUT_CU.bMsg6802 := 		FALSE;	(* B6802 reserve operating message 210 *) (*import HMI Extension *)
		OUT_CU.bMsg6803 := 		FALSE;	(* B6803 reserve operating message 211 *) (*import HMI Extension *)
		OUT_CU.bMsg6804 := 		FALSE;	(* B6804 reserve operating message 212 *) (*import HMI Extension *)
		OUT_CU.bMsg6805 := 		FALSE;	(* B6805 reserve operating message 213 *) (*import HMI Extension *)
		OUT_CU.bMsg6806 := 		FALSE;	(* B6806 reserve operating message 214 *) (*import HMI Extension *)
		OUT_CU.bMsg6807 := 		FALSE;	(* B6807 reserve operating message 215 *) (*import HMI Extension *)
		OUT_CU.bMsg6808 := 		FALSE;	(* B6808 reserve operating message 216 *) (*import HMI Extension *)
		OUT_CU.bMsg6809 := 		FALSE;	(* B6809 reserve operating message 217 *) (*import HMI Extension *)
		OUT_CU.bMsg6810 := 		FALSE;	(* B6810 reserve operating message 218 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6811 := 		FALSE;	(* B6811 reserve operating message 219 *) (*import HMI Extension *)
		OUT_CU.bMsg6812 := 		FALSE;	(* B6812 reserve operating message 220 *) (*import HMI Extension *)
		OUT_CU.bMsg6813 := 		FALSE;	(* B6813 reserve operating message 221 *) (*import HMI Extension *)
		OUT_CU.bMsg6814 := 		FALSE;	(* B6814 reserve operating message 222 *) (*import HMI Extension *)
		OUT_CU.bMsg6815 := 		FALSE;	(* B6815 reserve operating message 223 *) (*import HMI Extension *)
		OUT_CU.bMsg6816 := 		FALSE;	(* B6816 reserve operating message 224 *) (*import HMI Extension *)
		OUT_CU.bMsg6817 := 		FALSE;	(* B6817 reserve operating message 225 *) (*import HMI Extension *)
		OUT_CU.bMsg6818 := 		FALSE;	(* B6818 reserve operating message 226 *) (*import HMI Extension *)
		OUT_CU.bMsg6819 := 		FALSE;	(* B6819 reserve operating message 227 *) (*import HMI Extension *)
		OUT_CU.bMsg6820 := 		FALSE;	(* B6820 reserve operating message 228 *) (*import HMI Extension *)

		OUT_CU.bMsg6821 := 		FALSE;	(* B6821 reserve operating message 229 *) (*import HMI Extension *)
		OUT_CU.bMsg6822 := 		FALSE;	(* B6822 reserve operating message 230 *) (*import HMI Extension *)
		OUT_CU.bMsg6823 := 		FALSE;	(* B6823 reserve operating message 231 *) (*import HMI Extension *)
		OUT_CU.bMsg6824 := 		FALSE;	(* B6824 reserve operating message 232 *) (*import HMI Extension *)
		OUT_CU.bMsg6825 := 		FALSE;	(* B6825 reserve operating message 233 *) (*import HMI Extension *)
		OUT_CU.bMsg6826 := 		FALSE;	(* B6826 reserve operating message 234 *) (*import HMI Extension *)
		OUT_CU.bMsg6827 := 		FALSE;	(* B6827 reserve operating message 235 *) (*import HMI Extension *)
		OUT_CU.bMsg6828 := 		FALSE;	(* B6828 reserve operating message 236 *) (*import HMI Extension *)
		OUT_CU.bMsg6829 := 		FALSE;	(* B6829 reserve operating message 237 *) (*import HMI Extension *)
		OUT_CU.bMsg6830 := 		FALSE;	(* B6830 reserve operating message 238 *) (*import HMI Extension *)
		
		OUT_CU.bMsg6831 := 		FALSE;	(* B6831 reserve operating message 239 *) (*import HMI Extension *)
		OUT_CU.bMsg6832 := 		FALSE;	(* B6832 reserve operating message 240 *) (*import HMI Extension *)
		OUT_CU.bMsg6833 := 		FALSE;	(* B6833 reserve operating message 241 *) (*import HMI Extension *)
		OUT_CU.bMsg6834 := 		FALSE;	(* B6834 reserve operating message 242 *) (*import HMI Extension *)
		OUT_CU.bMsg6835 := 		FALSE;	(* B6835 reserve operating message 243 *) (*import HMI Extension *)
		OUT_CU.bMsg6836 := 		FALSE;	(* B6836 reserve operating message 244 *) (*import HMI Extension *)
		OUT_CU.bMsg6837 := 		FALSE;	(* B6837 reserve operating message 245 *) (*import HMI Extension *)
		OUT_CU.bMsg6838 := 		FALSE;	(* B6838 reserve operating message 246 *) (*import HMI Extension *)
		OUT_CU.bMsg6839 := 		FALSE;	(* B6839 reserve operating message 247 *) (*import HMI Extension *)
		OUT_CU.bMsg6840 := 		FALSE;	(* B6840 reserve operating message 248 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6841 := 		FALSE;	(* B6841 reserve operating message 249 *) (*import HMI Extension *)
		OUT_CU.bMsg6842 := 		FALSE;	(* B6842 reserve operating message 250 *) (*import HMI Extension *)
		OUT_CU.bMsg6843 := 		FALSE;	(* B6843 reserve operating message 251 *) (*import HMI Extension *)
		OUT_CU.bMsg6844 := 		FALSE;	(* B6844 reserve operating message 252 *) (*import HMI Extension *)
		OUT_CU.bMsg6845 := 		FALSE;	(* B6845 reserve operating message 253 *) (*import HMI Extension *)
		OUT_CU.bMsg6846 := 		FALSE;	(* B6846 reserve operating message 254 *) (*import HMI Extension *)
		OUT_CU.bMsg6847 := 		FALSE;	(* B6847 reserve operating message 255 *) (*import HMI Extension *)
		OUT_CU.bMsg6848 := 		FALSE;	(* B6848 reserve operating message 256 *) (*import HMI Extension *)
		OUT_CU.bMsg6849 := 		FALSE;	(* B6849 reserve operating message 257 *) (*import HMI Extension *)
		OUT_CU.bMsg6850 := 		FALSE;	(* B6850 reserve operating message 258 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6851 := 		FALSE;	(* B6851 reserve operating message 259 *) (*import HMI Extension *)
		OUT_CU.bMsg6852 := 		FALSE;	(* B6852 reserve operating message 260 *) (*import HMI Extension *)
		OUT_CU.bMsg6853 := 		FALSE;	(* B6853 reserve operating message 261 *) (*import HMI Extension *)
		OUT_CU.bMsg6854 := 		FALSE;	(* B6854 reserve operating message 262 *) (*import HMI Extension *)
		OUT_CU.bMsg6855 := 		FALSE;	(* B6855 reserve operating message 263 *) (*import HMI Extension *)
		OUT_CU.bMsg6856 := 		FALSE;	(* B6856 reserve operating message 264 *) (*import HMI Extension *)
		OUT_CU.bMsg6857 := 		FALSE;	(* B6857 reserve operating message 265 *) (*import HMI Extension *)
		OUT_CU.bMsg6858 := 		FALSE;	(* B6858 reserve operating message 266 *) (*import HMI Extension *)
		OUT_CU.bMsg6859 := 		FALSE;	(* B6859 reserve operating message 267 *) (*import HMI Extension *)
		OUT_CU.bMsg6860 := 		FALSE;	(* B6860 reserve operating message 268 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6861 := 		FALSE;	(* B6861 reserve operating message 269 *) (*import HMI Extension *)
		OUT_CU.bMsg6862 := 		FALSE;	(* B6862 reserve operating message 270 *) (*import HMI Extension *)
		OUT_CU.bMsg6863 := 		FALSE;	(* B6863 reserve operating message 271 *) (*import HMI Extension *)
		OUT_CU.bMsg6864 := 		FALSE;	(* B6864 reserve operating message 272 *) (*import HMI Extension *)
		OUT_CU.bMsg6865 := 		FALSE;	(* B6865 reserve operating message 273 *) (*import HMI Extension *)
		OUT_CU.bMsg6866 := 		FALSE;	(* B6866 reserve operating message 274 *) (*import HMI Extension *)
		OUT_CU.bMsg6867 := 		FALSE;	(* B6867 reserve operating message 275 *) (*import HMI Extension *)
		OUT_CU.bMsg6868 := 		FALSE;	(* B6868 reserve operating message 276 *) (*import HMI Extension *)
		OUT_CU.bMsg6869 := 		FALSE;	(* B6869 reserve operating message 277 *) (*import HMI Extension *)
		OUT_CU.bMsg6870 := 		FALSE;	(* B6870 reserve operating message 278 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6871 := 		FALSE;	(* B6871 reserve operating message 279 *) (*import HMI Extension *)
		OUT_CU.bMsg6872 := 		FALSE;	(* B6872 reserve operating message 280 *) (*import HMI Extension *)
		OUT_CU.bMsg6873 := 		FALSE;	(* B6873 reserve operating message 281 *) (*import HMI Extension *)
		OUT_CU.bMsg6874 := 		FALSE;	(* B6874 reserve operating message 282 *) (*import HMI Extension *)
		OUT_CU.bMsg6875 := 		FALSE;	(* B6875 reserve operating message 283 *) (*import HMI Extension *)
		OUT_CU.bMsg6876 := 		FALSE;	(* B6876 reserve operating message 284 *) (*import HMI Extension *)
		OUT_CU.bMsg6877 := 		FALSE;	(* B6877 reserve operating message 285 *) (*import HMI Extension *)
		OUT_CU.bMsg6878 := 		FALSE;	(* B6878 reserve operating message 286 *) (*import HMI Extension *)
		OUT_CU.bMsg6879 := 		FALSE;	(* B6879 reserve operating message 287 *) (*import HMI Extension *)
		OUT_CU.bMsg6880 := 		FALSE;	(* B6880 reserve operating message 288 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6881 := 		FALSE;	(* B6881 reserve operating message 289 *) (*import HMI Extension *)
		OUT_CU.bMsg6882 := 		FALSE;	(* B6882 reserve operating message 290 *) (*import HMI Extension *)
		OUT_CU.bMsg6883 := 		FALSE;	(* B6883 reserve operating message 291 *) (*import HMI Extension *)
		OUT_CU.bMsg6884 := 		FALSE;	(* B6884 reserve operating message 292 *) (*import HMI Extension *)
		OUT_CU.bMsg6885 := 		FALSE;	(* B6885 reserve operating message 293 *) (*import HMI Extension *)
		OUT_CU.bMsg6886 := 		FALSE;	(* B6886 reserve operating message 294 *) (*import HMI Extension *)
		OUT_CU.bMsg6887 := 		FALSE;	(* B6887 reserve operating message 295 *) (*import HMI Extension *)
		OUT_CU.bMsg6888 := 		FALSE;	(* B6888 reserve operating message 296 *) (*import HMI Extension *)
		OUT_CU.bMsg6889 := 		FALSE;	(* B6889 reserve operating message 297 *) (*import HMI Extension *)
		OUT_CU.bMsg6890 := 		FALSE;	(* B6890 reserve operating message 298 *) (*import HMI Extension *)
	
		OUT_CU.bMsg6891 := 		FALSE;	(* B6891 reserve operating message 299 *) (*import HMI Extension *)
		OUT_CU.bMsg6892 := 		FALSE;	(* B6892 reserve operating message 300 *) (*import HMI Extension *)
		OUT_CU.bMsg6893 := 		FALSE;	(* B6893 reserve operating message 301 *) (*import HMI Extension *)
		OUT_CU.bMsg6894 := 		FALSE;	(* B6894 reserve operating message 302 *) (*import HMI Extension *)
		OUT_CU.bMsg6895 := 		FALSE;	(* B6895 reserve operating message 303 *) (*import HMI Extension *)
		OUT_CU.bMsg6896 := 		FALSE;	(* B6896 reserve operating message 304 *) (*import HMI Extension *)
		OUT_CU.bMsg6897 := 		FALSE;	(* B6897 reserve operating message 305 *) (*import HMI Extension *)
		OUT_CU.bMsg6898 := 		FALSE;	(* B6898 reserve operating message 306 *) (*import HMI Extension *)
		OUT_CU.bMsg6899 := 		FALSE;	(* B6899 reserve operating message 307 *) (*import HMI Extension *)
//OLD do not use		OUT_CU.bMsg4200 := 		FALSE;	(* B4200 reserve operating message 308 *) (*import HMI Extension *)

END_PROGRAM

