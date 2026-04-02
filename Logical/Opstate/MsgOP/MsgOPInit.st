(*******************************************************************************
Msg_VE	 			 alarms generation MM_ventilation

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new
V0.11.0	22.12.2021	Andre		added B2935 Power reduction by CAN communication failure for half or more SAFI or too many SAFI reboots

														
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
		
	iAdrAmmBase2MM		:=  ADR(IN_OP.tAB2OP);
	iAdrMM2AmmBase		:=  ADR(OUT_OP.tOP2AB);
		
	(*---------------------------------------------------------------------------*)

	xMsg1108.Num		:=	1108;
	xMsg1108.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1108.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3506.Num		:=	3506;
	xMsg3506.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3506.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2082.Num		:=	2082;
	xMsg2082.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2082.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1188.Num		:=	1188;
	xMsg1188.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1188.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2097.Num		:=	2097;
	xMsg2097.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2097.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1225.Num		:=	1225;
	xMsg1225.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1225.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1226.Num		:=	1226;
	xMsg1226.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1226.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1227.Num		:=	1227;
	xMsg1227.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1227.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1228.Num		:=	1228;
	xMsg1228.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1228.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1229.Num		:=	1229;
	xMsg1229.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1229.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1230.Num		:=	1230;
	xMsg1230.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1230.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1231.Num		:=	1231;
	xMsg1231.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1231.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1232.Num		:=	1232;
	xMsg1232.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1232.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1233.Num		:=	1233;
	xMsg1233.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1233.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1234.Num		:=	1234;
	xMsg1234.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1234.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1237.Num		:=	1237;
	xMsg1237.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1237.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1238.Num		:=	1238;
	xMsg1238.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1238.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1241.Num		:=	1241;
	xMsg1241.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1241.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1242.Num		:=	1242;
	xMsg1242.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1242.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1243.Num		:=	1243;
	xMsg1243.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1243.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1244.Num		:=	1244;
	xMsg1244.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1244.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1245.Num		:=	1245;
	xMsg1245.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1245.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1246.Num		:=	1246;
	xMsg1246.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1246.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1247.Num		:=	1247;
	xMsg1247.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1247.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1248.Num		:=	1248;
	xMsg1248.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1248.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2122.Num		:=	2122;
	xMsg2122.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2122.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2123.Num		:=	2123;
	xMsg2123.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2123.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2124.Num		:=	2124;
	xMsg2124.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2124.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2125.Num		:=	2125;
	xMsg2125.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2125.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2126.Num		:=	2126;
	xMsg2126.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2126.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2127.Num		:=	2127;
	xMsg2127.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2127.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2128.Num		:=	2128;
	xMsg2128.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2128.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2129.Num		:=	2129;
	xMsg2129.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2129.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2130.Num		:=	2130;
	xMsg2130.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2130.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2131.Num		:=	2131;
	xMsg2131.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2131.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2132.Num		:=	2132;
	xMsg2132.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2132.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2140.Num		:=	2140;
	xMsg2140.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2140.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2143.Num		:=	2143;
	xMsg2143.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2143.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2144.Num		:=	2144;
	xMsg2144.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2144.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2146.Num		:=	2146;
	xMsg2146.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2146.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2147.Num		:=	2147;
	xMsg2147.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2147.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2148.Num		:=	2148;
	xMsg2148.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2148.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2149.Num		:=	2149;
	xMsg2149.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2149.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2150.Num		:=	2150;
	xMsg2150.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2150.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2152.Num		:=	2152;
	xMsg2152.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2152.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2153.Num		:=	2153;
	xMsg2153.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2153.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2154.Num		:=	2154;
	xMsg2154.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2154.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2155.Num		:=	2155;
	xMsg2155.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2155.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2158.Num		:=	2158;
	xMsg2158.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2158.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2159.Num		:=	2159;
	xMsg2159.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2159.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2160.Num		:=	2160;
	xMsg2160.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2160.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2161.Num		:=	2161;
	xMsg2161.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2161.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2163.Num		:=	2163;
	xMsg2163.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2163.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2164.Num		:=	2164;
	xMsg2164.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2164.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2168.Num 		:= 	2168;	
	xMsg2168.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg2168.AmmOutAdr 	:= iAdrMM2AmmBase;
		
	xMsg2169.Num		:=	2169;
	xMsg2169.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2169.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2170.Num		:=	2170;
	xMsg2170.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2170.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2803.Num		:=	2803;
	xMsg2803.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2803.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2875.Num 		:= 	2875;	
	xMsg2875.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg2875.AmmOutAdr 	:= iAdrMM2AmmBase;
	
	xMsg2925.Num		:=	2925;
	xMsg2925.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2925.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2936.Num		:=	2936;
	xMsg2936.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2936.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2961.Num 		:= 	2961;	
	xMsg2961.AmmInAdr 	:=  iAdrAmmBase2MM;
	xMsg2961.AmmOutAdr 	:=  iAdrMM2AmmBase;
	
	xMsg3229.Num		:=	3229;
	xMsg3229.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3229.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3230.Num		:=	3230;
	xMsg3230.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3230.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3231.Num		:=	3231;
	xMsg3231.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3231.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2982.Num		:=	2982;
	xMsg2982.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2982.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2989.Num		:=	2989;
	xMsg2989.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2989.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9284.Num		:=	9284;
	xMsg9284.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9284.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2972.Num		:=	2972;
	xMsg2972.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2972.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2973.Num		:=	2973;
	xMsg2973.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2973.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9051.Num		:=	9051;
	xMsg9051.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9051.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9052.Num		:=	9052;
	xMsg9052.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9052.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9061.Num		:=	9061;
	xMsg9061.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9061.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9062.Num		:=	9062;
	xMsg9062.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9062.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9063.Num		:=	9063;
	xMsg9063.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9063.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9064.Num		:=	9064;
	xMsg9064.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9064.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2935.Num		:=	2935;
	xMsg2935.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2935.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9072.Num		:=	9072;
	xMsg9072.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9072.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9075.Num		:=	9075;
	xMsg9075.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9075.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9076.Num		:=	9076;
	xMsg9076.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9076.AmmOutAdr	:=  iAdrMM2AmmBase;

END_PROGRAM

