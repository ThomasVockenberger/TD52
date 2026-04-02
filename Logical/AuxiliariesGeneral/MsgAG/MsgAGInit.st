(*******************************************************************************
Msg_AG	 			 alarms generation auxiliaries general

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new
V4.12.0	21.12.2022	Perktold	added W9369 Failure auxiliaries supply voltage engine

														
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

	bPLC_Startup := FALSE;
		
	iAdrAmmBase2MM		:=  ADR(IN_AG.tAB2AG);
	iAdrMM2AmmBase		:=  ADR(OUT_AG.tAG2AB);
		
	(*---------------------------------------------------------------------------*)
	xMsg1017.Num		:=	1017;
	xMsg1017.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1017.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1018.Num		:=  1018;
	xMsg1018.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1018.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1020.Num		:=  1020;
	xMsg1020.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1020.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1023.Num		:=  1023;
	xMsg1023.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1023.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1043.Num		:=	1043;
	xMsg1043.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1043.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1051.Num		:=	1051;
	xMsg1051.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1051.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg1052.Num		:=  1052;
	xMsg1052.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1052.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1053.Num		:=  1053;
	xMsg1053.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1053.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1054.Num		:=  1054;
	xMsg1054.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1054.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1059.Num		:=	1059;
	xMsg1059.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1059.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1060.Num		:=  1060;
	xMsg1060.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1060.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1090.Num		:=  1090;
	xMsg1090.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1090.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1091.Num		:=  1091;
	xMsg1091.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1091.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1100.Num		:=  1100;
	xMsg1100.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1100.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1101.Num		:=  1101;
	xMsg1101.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1101.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1120.Num		:=  1120;
	xMsg1120.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1120.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1129.Num		:=  1129;
	xMsg1129.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1129.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1137.Num		:=  1137;
	xMsg1137.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1137.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1139.Num		:=  1139;
	xMsg1139.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1139.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1140.Num		:=  1140;
	xMsg1140.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1140.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1148.Num		:=  1148;
	xMsg1148.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1148.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1159.Num		:=  1159;
	xMsg1159.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1159.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1160.Num		:=  1160;
	xMsg1160.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1160.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1166.Num		:=	1166;
	xMsg1166.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1166.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1249.Num		:=	1249;
	xMsg1249.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1249.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1250.Num		:=	1250;
	xMsg1250.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1250.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1257.Num		:=	1257;
	xMsg1257.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1257.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1258.Num		:=	1258;
	xMsg1258.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1258.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1259.Num		:=	1259;
	xMsg1259.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1259.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1260.Num		:=	1260;
	xMsg1260.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1260.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1261.Num		:=	1261;
	xMsg1261.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1261.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1262.Num		:=	1262;
	xMsg1262.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1262.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1263.Num		:=	1263;
	xMsg1263.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1263.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1264.Num		:=	1264;
	xMsg1264.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1264.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1281.Num		:=	1281;
	xMsg1281.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1281.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1282.Num		:=	1282;
	xMsg1282.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1282.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1292.Num		:=	1292;
	xMsg1292.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1292.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2102.Num		:=	2102;
	xMsg2102.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2102.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2103.Num		:=	2103;
	xMsg2103.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2103.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2114.Num		:=  2114;
	xMsg2114.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2114.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2118.Num		:=  2118;
	xMsg2118.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2118.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2201.Num		:=  2201;
	xMsg2201.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2201.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2213.Num		:=	2213;
	xMsg2213.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2213.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2224.Num		:=	2224;
	xMsg2224.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2224.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2233.Num		:=	2233;
	xMsg2233.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2233.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2234.Num		:=	2234;
	xMsg2234.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2234.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2238.Num		:=	2238;
	xMsg2238.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2238.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2242.Num		:=	2242;
	xMsg2242.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2242.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2260.Num		:=	2260;
	xMsg2260.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2260.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2263.Num		:=  2263;
	xMsg2263.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2263.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2264.Num		:=  2264;
	xMsg2264.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2264.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2265.Num		:=  2265;
	xMsg2265.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2265.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2266.Num		:=  2266;
	xMsg2266.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2266.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2267.Num		:=  2267;
	xMsg2267.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2267.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2268.Num		:=  2268;
	xMsg2268.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2268.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2269.Num		:=  2269;
	xMsg2269.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2269.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2284.Num		:=	2284;
	xMsg2284.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2284.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2291.Num		:=  2291;
	xMsg2291.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2291.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2292.Num		:=  2292;
	xMsg2292.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2292.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2304.Num		:=	2304;
	xMsg2304.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2304.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2332.Num		:=	2332;
	xMsg2332.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2332.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2333.Num		:=	2333;
	xMsg2333.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2333.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2348.Num		:=	2348;
	xMsg2348.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2348.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2349.Num		:=	2349;
	xMsg2349.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2349.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2350.Num		:=	2350;
	xMsg2350.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2350.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2351.Num		:=	2351;
	xMsg2351.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2351.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2352.Num		:=	2352;
	xMsg2352.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2352.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2353.Num		:=	2353;
	xMsg2353.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2353.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2355.Num		:=	2355;
	xMsg2355.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2355.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2359.Num		:=	2359;
	xMsg2359.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2359.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2360.Num		:=	2360;
	xMsg2360.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2360.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2361.Num		:=	2361;
	xMsg2361.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2361.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2376.Num		:=	2376;
	xMsg2376.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2376.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2377.Num		:=	2377;
	xMsg2377.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2377.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2378.Num		:=	2378;
	xMsg2378.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2378.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2379.Num		:=	2379;
	xMsg2379.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2379.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2382.Num		:=	2382;
	xMsg2382.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2382.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2421.Num		:=	2421;
	xMsg2421.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2421.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2422.Num		:=  2422;
	xMsg2422.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2422.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2423.Num		:=	2423;//SWAT920/1
	xMsg2423.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2423.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2424.Num		:=	2424;//SWAT920/2.2
	xMsg2424.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2424.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2425.Num		:=	2425;//SWAT920/2.2
	xMsg2425.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2425.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2426.Num		:=	2426;//SWAT920/2.2
	xMsg2426.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2426.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2427.Num		:=	2427;
	xMsg2427.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2427.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2431.Num		:=	2431;//SWAT920/1
	xMsg2431.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2431.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2432.Num		:=	2432;//SWAT920/1
	xMsg2432.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2432.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2433.Num		:=	2433;//SWAT920/1
	xMsg2433.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2433.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2434.Num		:=	2434;
	xMsg2434.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2434.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2435.Num		:=	2435;//SWAT920/2
	xMsg2435.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2435.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2459.Num		:=  2459;
	xMsg2459.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2459.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2473.Num		:=  2473;
	xMsg2473.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2473.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2475.Num		:=  2475;
	xMsg2475.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2475.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2524.Num		:=	2524;
	xMsg2524.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2524.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2534.Num		:=	2534;
	xMsg2534.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2534.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2545.Num		:=  2545;
	xMsg2545.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2545.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2554.Num		:=	2554;
	xMsg2554.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2554.AmmOutAdr	:=  iAdrMM2AmmBase;	
		
	xMsg2557.Num		:=	2557;//SWAT920/2.2
	xMsg2557.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2557.AmmOutAdr	:=  iAdrMM2AmmBase;	
		
	xMsg2558.Num		:=  2558;
	xMsg2558.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2558.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2559.Num 		:=  2559;	
	xMsg2559.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2559.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2560.Num		:=  2560;
	xMsg2560.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2560.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2571.Num		:=  2571;
	xMsg2571.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2571.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2572.Num		:=  2572;
	xMsg2572.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2572.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2576.Num		:=	2576;
	xMsg2576.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2576.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2579.Num		:=	2579;
	xMsg2579.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2579.AmmOutAdr	:=  iAdrMM2AmmBase;		

	xMsg2582.Num		:=	2582;
	xMsg2582.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2582.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2587.Num		:=	2587;
	xMsg2587.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2587.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2589.Num		:=  2589;
	xMsg2589.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2589.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2590.Num		:=  2590;
	xMsg2590.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2590.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2591.Num		:=  2591;
	xMsg2591.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2591.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2592.Num		:=  2592;
	xMsg2592.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2592.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2594.Num		:=  2594;
	xMsg2594.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2594.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2595.Num		:=  2595;
	xMsg2595.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2595.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2596.Num		:=  2596;
	xMsg2596.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2596.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2597.Num		:=	2597;
	xMsg2597.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2597.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2598.Num		:=	2598;
	xMsg2598.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2598.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2599.Num		:=	2599;
	xMsg2599.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2599.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2600.Num		:=	2600;
	xMsg2600.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2600.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2602.Num		:=	2602;
	xMsg2602.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2602.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2603.Num		:=	2603;
	xMsg2603.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2603.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2604.Num		:=	2604;
	xMsg2604.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2604.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2605.Num		:=	2605;
	xMsg2605.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2605.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2606.Num		:=	2606;
	xMsg2606.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2606.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2608.Num		:=	2608;
	xMsg2608.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2608.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2613.Num		:=	2613;
	xMsg2613.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2613.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2624.Num		:=	2624;
	xMsg2624.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2624.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2625.Num		:=	2625;
	xMsg2625.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2625.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2627.Num		:=	2627;
	xMsg2627.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2627.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2628.Num		:=	2628;
	xMsg2628.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2628.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2629.Num		:=	2629;
	xMsg2629.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2629.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2636.Num		:=	2636;
	xMsg2636.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2636.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2642.Num		:=	2642;
	xMsg2642.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2642.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2643.Num		:=	2643;
	xMsg2643.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2643.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2644.Num		:=	2644;
	xMsg2644.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2644.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2645.Num		:=	2645;
	xMsg2645.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2645.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2646.Num		:=	2646;
	xMsg2646.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2646.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2648.Num		:=	2648;
	xMsg2648.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2648.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2649.Num 		:= 	2649;	
	xMsg2649.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg2649.AmmOutAdr 	:= iAdrMM2AmmBase;

	xMsg2650.Num 		:= 	2650;	
	xMsg2650.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg2650.AmmOutAdr 	:= iAdrMM2AmmBase;
	
	xMsg2651.Num 		:= 	2651;	
	xMsg2651.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg2651.AmmOutAdr 	:= iAdrMM2AmmBase;
	
	xMsg2652.Num 		:= 	2652;	
	xMsg2652.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg2652.AmmOutAdr 	:= iAdrMM2AmmBase;
	
	xMsg2653.Num 		:= 	2653;	
	xMsg2653.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg2653.AmmOutAdr 	:= iAdrMM2AmmBase;
	
	xMsg2654.Num 		:= 	2654;	
	xMsg2654.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg2654.AmmOutAdr 	:= iAdrMM2AmmBase;

	xMsg2666.Num		:=	2666;
	xMsg2666.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2666.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2689.Num		:=	2689;
	xMsg2689.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2689.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2722.Num		:=	2722;
	xMsg2722.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2722.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2723.Num		:=	2723;
	xMsg2723.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2723.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2724.Num		:=	2724;
	xMsg2724.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2724.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2725.Num		:=	2725;
	xMsg2725.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2725.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2726.Num		:=	2726;
	xMsg2726.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2726.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2727.Num		:=	2727;
	xMsg2727.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2727.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2728.Num		:=	2728;
	xMsg2728.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2728.AmmOutAdr	:=  iAdrMM2AmmBase;	
			
	xMsg2729.Num		:=	2729;
	xMsg2729.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2729.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2737.Num		:=	2737;
	xMsg2737.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2737.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2738.Num		:=	2738;
	xMsg2738.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2738.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2739.Num		:=	2739;
	xMsg2739.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2739.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2740.Num		:=	2740;
	xMsg2740.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2740.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2741.Num		:=	2741;
	xMsg2741.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2741.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2742.Num		:=	2742;
	xMsg2742.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2742.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2754.Num		:=	2754;
	xMsg2754.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2754.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2755.Num		:=	2755;
	xMsg2755.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2755.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2756.Num		:=	2756;
	xMsg2756.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2756.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2757.Num		:=	2757;
	xMsg2757.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2757.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2758.Num		:=	2758;
	xMsg2758.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2758.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2759.Num		:=	2759;
	xMsg2759.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2759.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2760.Num		:=	2760;
	xMsg2760.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2760.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2761.Num		:=	2761;
	xMsg2761.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2761.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2762.Num		:=	2762;
	xMsg2762.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2762.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2770.Num		:=	2770;
	xMsg2770.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2770.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2771.Num		:=	2771;
	xMsg2771.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2771.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2772.Num		:=	2772;
	xMsg2772.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2772.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2773.Num		:=	2773;
	xMsg2773.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2773.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2774.Num		:=	2774;
	xMsg2774.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2774.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2775.Num		:=	2775;
	xMsg2775.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2775.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2776.Num		:=	2776;
	xMsg2776.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2776.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2777.Num		:=	2777;
	xMsg2777.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2777.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2778.Num		:=	2778;
	xMsg2778.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2778.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2781.Num		:=	2781;
	xMsg2781.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2781.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2782.Num		:=	2782;
	xMsg2782.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2782.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2783.Num		:=	2783;
	xMsg2783.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2783.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2784.Num		:=	2784;
	xMsg2784.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2784.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2785.Num		:=	2785;
	xMsg2785.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2785.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2786.Num		:=	2786;
	xMsg2786.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2786.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2787.Num		:=	2787;
	xMsg2787.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2787.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2788.Num		:=	2788;
	xMsg2788.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2788.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2789.Num		:=	2789;
	xMsg2789.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2789.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2791.Num		:=	2791;
	xMsg2791.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2791.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2792.Num		:=	2792;
	xMsg2792.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2792.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2809.Num		:=	2809;
	xMsg2809.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2809.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2810.Num		:=	2810;
	xMsg2810.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2810.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2931.Num		:=	2931;
	xMsg2931.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2931.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2932.Num		:=	2932;
	xMsg2932.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2932.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2933.Num		:=	2933;
	xMsg2933.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2933.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2956.Num		:=	2956;
	xMsg2956.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2956.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2957.Num		:=	2957;
	xMsg2957.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2957.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2978.Num		:=	2978;
	xMsg2978.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2978.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2979.Num		:=	2979;
	xMsg2979.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2979.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3216.Num		:=	3216;
	xMsg3216.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3216.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3218.Num		:=	3218;
	xMsg3218.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3218.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3300.Num		:=	3300;
	xMsg3300.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3300.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3301.Num		:=  3301;
	xMsg3301.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3301.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3304.Num		:=	3304;
	xMsg3304.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3304.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3305.Num		:=	3305;
	xMsg3305.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3305.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3322.Num		:=  3322;
	xMsg3322.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3322.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3323.Num		:=  3323;
	xMsg3323.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3323.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3350.Num		:=  3350;
	xMsg3350.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3350.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3351.Num		:=  3351;
	xMsg3351.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3351.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3369.Num 		:= 3369;	
	xMsg3369.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3369.AmmOutAdr 	:= iAdrMM2AmmBase;

	xMsg3370.Num 		:= 3370;	
	xMsg3370.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3370.AmmOutAdr 	:= iAdrMM2AmmBase;

	xMsg3375.Num 		:= 3375;	
	xMsg3375.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3375.AmmOutAdr 	:= iAdrMM2AmmBase;

	xMsg3401.Num		:=  3401;
	xMsg3401.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3401.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3403.Num		:=  3403;
	xMsg3403.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3403.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3405.Num		:=  3405;
	xMsg3405.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3405.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3413.Num		:=	3413;
	xMsg3413.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3413.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3414.Num		:=	3414;
	xMsg3414.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3414.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3415.Num		:=	3415;
	xMsg3415.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3415.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3416.Num		:=	3416;
	xMsg3416.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3416.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3495.Num		:=  3495;
	xMsg3495.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3495.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3496.Num		:=  3496;
	xMsg3496.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3496.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3497.Num		:=  3497;
	xMsg3497.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3497.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3507.Num		:=	3507;
	xMsg3507.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3507.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3515.Num		:=  3515;
	xMsg3515.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3515.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3519.Num		:=  3519;
	xMsg3519.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3519.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3572.Num		:=  3572;
	xMsg3572.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3572.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3574.Num		:=  3574;
	xMsg3574.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3574.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3578.Num		:=  3578;
	xMsg3578.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3578.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3579.Num		:=  3579;
	xMsg3579.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3579.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3587.Num		:=	3587;
	xMsg3587.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3587.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3588.Num		:=	3588;
	xMsg3588.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3588.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9001.Num		:=	9001;
	xMsg9001.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9001.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9002.Num		:=	9002;
	xMsg9002.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9002.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9003.Num		:=	9003;
	xMsg9003.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9003.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9048.Num		:=	9048;
	xMsg9048.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9048.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9067.Num		:=	9067;
	xMsg9067.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9067.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9069.Num		:=	9069;
	xMsg9069.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9069.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9070.Num		:=	9070;
	xMsg9070.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9070.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9074.Num		:=	9074;
	xMsg9074.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9074.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9088.Num		:=	9088;
	xMsg9088.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9088.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9089.Num		:=	9089;
	xMsg9089.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9089.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9090.Num		:=	9090;
	xMsg9090.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9090.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9091.Num		:=	9091;
	xMsg9091.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9091.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9096.Num		:=	9096;
	xMsg9096.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9096.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9097.Num		:=	9097;
	xMsg9097.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9097.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9214.Num		:=  9214;//SWAT920/5
	xMsg9214.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9214.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9220.Num		:=  9220;//SWAT920/5a
	xMsg9220.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9220.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9221.Num		:=	9221;
	xMsg9221.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9221.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9222.Num		:=	9222;
	xMsg9222.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9222.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9224.Num		:=	9224;
	xMsg9224.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9224.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9225.Num		:=	9225;
	xMsg9225.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9225.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9227.Num		:=	9227;
	xMsg9227.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9227.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9254.Num		:=	9254;
	xMsg9254.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9254.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9255.Num		:=	9255;
	xMsg9255.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9255.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9256.Num		:=	9256;
	xMsg9256.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9256.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9257.Num		:=	9257;
	xMsg9257.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9257.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9258.Num		:=	9258;
	xMsg9258.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9258.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9279.Num		:=	9279;
	xMsg9279.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9279.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9280.Num		:=	9280;
	xMsg9280.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9280.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9281.Num		:=	9281;
	xMsg9281.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9281.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9282.Num		:=	9282;
	xMsg9282.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9282.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9283.Num		:=	9283;
	xMsg9283.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9283.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9303.Num		:=	9303;
	xMsg9303.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9303.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9314.Num		:=	9314;
	xMsg9314.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9314.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9316.Num		:=	9316;
	xMsg9316.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9316.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9317.Num		:=	9317;
	xMsg9317.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9317.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9322.Num		:=	9322;
	xMsg9322.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9322.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9323.Num		:=	9323;
	xMsg9323.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9323.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9324.Num		:=	9324;
	xMsg9324.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9324.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9325.Num		:=	9325;
	xMsg9325.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9325.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9326.Num		:=	9326;
	xMsg9326.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9326.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9327.Num		:=	9327;
	xMsg9327.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9327.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9328.Num		:=	9328;
	xMsg9328.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9328.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9332.Num		:=	9332;
	xMsg9332.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9332.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9333.Num		:=	9333;
	xMsg9333.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9333.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9334.Num		:=	9334;
	xMsg9334.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9334.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9335.Num		:=	9335;
	xMsg9335.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9335.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9336.Num		:=	9336;
	xMsg9336.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9336.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9352.Num		:=	9352;
	xMsg9352.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9352.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9353.Num		:=	9353;
	xMsg9353.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9353.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9354.Num		:=	9354;
	xMsg9354.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9354.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9355.Num		:=	9355;
	xMsg9355.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9355.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9356.Num		:=	9356;
	xMsg9356.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9356.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9357.Num		:=	9357;
	xMsg9357.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9357.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9358.Num		:=	9358;
	xMsg9358.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9358.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9359.Num		:=	9359;
	xMsg9359.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9359.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg9362.Num		:=	9362;			(*V4.12 Oil Tank*)
	xMsg9362.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9362.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9363.Num		:=	9363;			(*V4.12 Oil Tank*)
	xMsg9363.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9363.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9364.Num		:=	9364;			(*V4.12 Oil Tank*)
	xMsg9364.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9364.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9369.Num		:=	9369;
	xMsg9369.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9369.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9378.Num		:=	9378;
	xMsg9378.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9378.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9390.Num		:=	9390;
	xMsg9390.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9390.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9435.Num		:=  9435;
	xMsg9435.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9435.AmmOutAdr	:=  iAdrMM2AmmBase;	
			
	xMsg9436.Num		:=  9436;
	xMsg9436.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9436.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9513.Num		:=	9513;
	xMsg9513.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9513.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9560.Num		:=  9560;
	xMsg9560.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9560.AmmOutAdr	:=  iAdrMM2AmmBase;	
			
	xMsg9561.Num		:=  9561;
	xMsg9561.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9561.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	(* template
	xMsg.Num		:=	;
	xMsg.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg.AmmOutAdr	:=  iAdrMM2AmmBase;
	*)
END_PROGRAM

