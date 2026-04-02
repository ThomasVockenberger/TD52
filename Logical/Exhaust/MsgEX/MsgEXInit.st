(*******************************************************************************
Msg_EX	 			 alarms generation

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new
V4.13.0	19.10.2023	Heim Markus	add 2374

														
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
	
	iAdrAmmBase2MM		:=  ADR(IN_EX.tAB2EX);
	iAdrMM2AmmBase		:=  ADR(OUT_EX.tEX2AB);
	(*---------------------------------------------------------------------------*)

	xMsg1045.Num		:=	1045;
	xMsg1045.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1045.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1046.Num		:=	1046;
	xMsg1046.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1046.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1069.Num		:=	1069;
	xMsg1069.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1069.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1092.Num		:=	1092;
	xMsg1092.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1092.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1104.Num		:=	1104;
	xMsg1104.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1104.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1106.Num		:=	1106;
	xMsg1106.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1106.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1161.Num		:=	1161;
	xMsg1161.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1161.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1162.Num		:=	1162;
	xMsg1162.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1162.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1163.Num		:=	1163;
	xMsg1163.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1163.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1164.Num		:=	1164;
	xMsg1164.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1164.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1165.Num		:=	1165;
	xMsg1165.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1165.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1169.Num		:=	1169;
	xMsg1169.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1169.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1170.Num		:=	1170;
	xMsg1170.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1170.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1171.Num		:=	1171;
	xMsg1171.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1171.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1172.Num		:=	1172;
	xMsg1172.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1172.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1173.Num		:=	1173;
	xMsg1173.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1173.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1174.Num		:=	1174;
	xMsg1174.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1174.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1273.Num		:=	1273;
	xMsg1273.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1273.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1274.Num		:=	1274;
	xMsg1274.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1274.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1275.Num		:=	1275;
	xMsg1275.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1275.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1276.Num		:=	1276;
	xMsg1276.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1276.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1277.Num		:=	1277;
	xMsg1277.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1277.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1278.Num		:=	1278;
	xMsg1278.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1278.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1279.Num		:=	1279;
	xMsg1279.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1279.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1280.Num		:=	1280;
	xMsg1280.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1280.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1288.Num		:=	1288;
	xMsg1288.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1288.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1289.Num		:=	1289;
	xMsg1289.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1289.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1290.Num		:=	1290;
	xMsg1290.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1290.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1291.Num		:=	1291;
	xMsg1291.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1291.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2098.Num		:=	2098;
	xMsg2098.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2098.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2112.Num		:=	2112;
	xMsg2112.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2112.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2113.Num		:=	2113;
	xMsg2113.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2113.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2310.Num		:=	2310;
	xMsg2310.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2310.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2311.Num		:=	2311;
	xMsg2311.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2311.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2312.Num		:=	2312;
	xMsg2312.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2312.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2313.Num		:=	2313;
	xMsg2313.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2313.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2315.Num		:=	2315;
	xMsg2315.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2315.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2319.Num		:=	2319;
	xMsg2319.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2319.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2320.Num		:=	2320;
	xMsg2320.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2320.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2321.Num		:=	2321;
	xMsg2321.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2321.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2322.Num		:=	2322;
	xMsg2322.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2322.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2337.Num		:=	2337;
	xMsg2337.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2337.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2338.Num		:=	2338;
	xMsg2338.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2338.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2340.Num		:=	2340;
	xMsg2340.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2340.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2374.Num		:=	2374;
	xMsg2374.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2374.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2468.Num		:=	2468;
	xMsg2468.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2468.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2469.Num		:=	2469;
	xMsg2469.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2469.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2494.Num		:=	2494;
	xMsg2494.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2494.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2495.Num		:=	2495;
	xMsg2495.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2495.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2496.Num		:=	2496;
	xMsg2496.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2496.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2497.Num		:=	2497;
	xMsg2497.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2497.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2498.Num		:=	2498;
	xMsg2498.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2498.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2499.Num		:=	2499;
	xMsg2499.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2499.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2500.Num		:=	2500;
	xMsg2500.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2500.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2546.Num		:=	2546;
	xMsg2546.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2546.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2547.Num		:=	2547;
	xMsg2547.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2547.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2549.Num		:=	2549;
	xMsg2549.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2549.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2551.Num		:=	2551;
	xMsg2551.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2551.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2601.Num		:=	2601;
	xMsg2601.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2601.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2622.Num		:=	2622;
	xMsg2622.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2622.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2623.Num		:=	2623;
	xMsg2623.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2623.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2655.Num		:=	2655;
	xMsg2655.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2655.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2656.Num		:=	2656;
	xMsg2656.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2656.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2657.Num		:=	2657;
	xMsg2657.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2657.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2658.Num		:=	2658;
	xMsg2658.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2658.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2659.Num		:=	2659;
	xMsg2659.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2659.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2660.Num		:=	2660;
	xMsg2660.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2660.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2661.Num		:=	2661;
	xMsg2661.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2661.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2662.Num		:=	2662;
	xMsg2662.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2662.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2663.Num		:=	2663;
	xMsg2663.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2663.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2664.Num		:=	2664;
	xMsg2664.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2664.AmmOutAdr	:=  iAdrMM2AmmBase;	

	

	xMsg2743.Num		:=	2743;
	xMsg2743.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2743.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2744.Num		:=	2744;
	xMsg2744.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2744.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2745.Num		:=	2745;
	xMsg2745.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2745.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2746.Num		:=	2746;
	xMsg2746.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2746.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2747.Num		:=	2747;
	xMsg2747.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2747.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2748.Num		:=	2748;
	xMsg2748.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2748.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2793.Num		:=	2793;
	xMsg2793.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2793.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2847.Num		:=	2847;
	xMsg2847.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2847.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2848.Num		:=	2848;
	xMsg2848.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2848.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3100.Num		:=	3100;
	xMsg3100.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3100.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3214.Num		:=	3214;
	xMsg3214.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3214.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3215.Num		:=	3215;
	xMsg3215.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3215.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3313.Num		:=	3313;
	xMsg3313.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3313.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3314.Num		:=	3314;
	xMsg3314.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3314.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3349.Num		:=	3349;
	xMsg3349.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3349.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3366.Num		:=	3366;
	xMsg3366.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3366.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3394.Num		:=	3394;    (*STM*)
	xMsg3394.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3394.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3395.Num		:=	3395;    (*STM*)
	xMsg3395.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3395.AmmOutAdr	:=  iAdrMM2AmmBase;	
		
	xMsg3397.Num		:=	3397;
	xMsg3397.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3397.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3417.Num		:=	3417;
	xMsg3417.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3417.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3490.Num		:=	3490;    (*STM*)
	xMsg3490.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3490.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3491.Num		:=	3491;    (*STM*)
	xMsg3491.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3491.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3510.Num		:=	3510;
	xMsg3510.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3510.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3511.Num		:=	3511;
	xMsg3511.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3511.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3512.Num		:=	3512;
	xMsg3512.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3512.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3513.Num		:=	3513;
	xMsg3513.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3513.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3514.Num		:=	3514;
	xMsg3514.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3514.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3528.Num		:=	3528;
	xMsg3528.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3528.AmmOutAdr	:=  iAdrMM2AmmBase;	
		
	xMsg3580.Num		:=	3580;
	xMsg3580.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3580.AmmOutAdr	:=  iAdrMM2AmmBase;	
		
	xMsg3581.Num		:=	3581;
	xMsg3581.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3581.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3582.Num		:=	3582;
	xMsg3582.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3582.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9215.Num		:=	9215;//SWAT920/5
	xMsg9215.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9215.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9249.Num		:=	9249;
	xMsg9249.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9249.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9305.Num		:=	9305;
	xMsg9305.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9305.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9306.Num		:=	9306;
	xMsg9306.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9306.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9307.Num		:=	9307;
	xMsg9307.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9307.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9308.Num		:=	9308;
	xMsg9308.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9308.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9310.Num		:=	9310;
	xMsg9310.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9310.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9347.Num		:=	9347;
	xMsg9347.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9347.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9348.Num		:=	9348;
	xMsg9348.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9348.AmmOutAdr	:=  iAdrMM2AmmBase;	

	(* template
	xMsg.Num		:=	;
	xMsg.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg.AmmOutAdr	:=  iAdrMM2AmmBase;
	*)
END_PROGRAM

