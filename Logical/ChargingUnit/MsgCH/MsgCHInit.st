(*******************************************************************************
Msg_CH	 			 alarms generation MM_Charging

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
														
Instructions for use:
--------------------
1) declare alarm with function block "Msg"

2) use template to create a new alarm, substitue 0000 by message number:

	xMsg0000.Num		:=	0000;					alarm number
	xMsg0000.AmmSysAdr	:=  iAdrAmmBase2MM;			do not change
	xMsg0000.AmmOutAdr	:=  iAdrMM2AmmBase;			do not change

3) 	set alarm number
	
(*******************************************************************************)
PROGRAM _INIT
		
	iAdrAmmBase2MM		:= ADR(IN_CH.tAB2CH);
	iAdrMM2AmmBase		:= ADR(OUT_CH.tCH2AB);
		
	(*---------------------------------------------------------------------------*)

	xMsg1040.Num		:= 1040;
	xMsg1040.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg1040.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg1077.Num		:= 1077;
	xMsg1077.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg1077.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg1078.Num		:= 1078;
	xMsg1078.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg1078.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg1105.Num		:= 1105;
	xMsg1105.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg1105.AmmOutAdr	:= iAdrMM2AmmBase;		
	
	xMsg1114.Num		:= 1114;
	xMsg1114.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg1114.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2215.Num		:= 2215;
	xMsg2215.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2215.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2216.Num		:= 2216;
	xMsg2216.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2216.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2217.Num		:= 2217;
	xMsg2217.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2217.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2218.Num		:= 2218;
	xMsg2218.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2218.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2219.Num		:= 2219;
	xMsg2219.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2219.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2220.Num		:= 2220;
	xMsg2220.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2220.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2221.Num		:= 2221;
	xMsg2221.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2221.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2222.Num		:= 2222;
	xMsg2222.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2222.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2223.Num		:= 2223;
	xMsg2223.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2223.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2225.Num		:= 2225;
	xMsg2225.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2225.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2226.Num		:= 2226;
	xMsg2226.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2226.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2236.Num		:= 2236;
	xMsg2236.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2236.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2237.Num		:= 2237;
	xMsg2237.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2237.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2239.Num		:= 2239;
	xMsg2239.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2239.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2258.Num		:= 2258;
	xMsg2258.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2258.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2259.Num		:= 2259;
	xMsg2259.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2259.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2278.Num		:= 2278;
	xMsg2278.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2278.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2279.Num		:= 2279;
	xMsg2279.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2279.AmmOutAdr	:= iAdrMM2AmmBase;		
	
	xMsg2280.Num		:= 2280;
	xMsg2280.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2280.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2317.Num		:= 2317;
	xMsg2317.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2317.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2318.Num		:= 2318;
	xMsg2318.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2318.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2324.Num		:= 2324;
	xMsg2324.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2324.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2325.Num		:= 2325;
	xMsg2325.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2325.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2326.Num		:= 2326;
	xMsg2326.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2326.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2327.Num		:= 2327;
	xMsg2327.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2327.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2368.Num		:= 2368;
	xMsg2368.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2368.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2369.Num		:= 2369;
	xMsg2369.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2369.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2370.Num		:= 2370;
	xMsg2370.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2370.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2407.Num		:= 2407;
	xMsg2407.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2407.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg2408.Num		:= 2408;
	xMsg2408.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2408.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg2409.Num		:= 2409;
	xMsg2409.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2409.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg2410.Num		:= 2410;
	xMsg2410.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2410.AmmOutAdr	:= iAdrMM2AmmBase;		
	
	xMsg2411.Num		:= 2411;
	xMsg2411.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2411.AmmOutAdr	:= iAdrMM2AmmBase;		
	
	xMsg2412.Num		:= 2412;
	xMsg2412.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2412.AmmOutAdr	:= iAdrMM2AmmBase;		
	
	xMsg2413.Num		:= 2413;
	xMsg2413.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2413.AmmOutAdr	:= iAdrMM2AmmBase;		
	
	xMsg2414.Num		:= 2414;
	xMsg2414.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2414.AmmOutAdr	:= iAdrMM2AmmBase;		
		
	xMsg2436.Num		:= 2436;
	xMsg2436.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2436.AmmOutAdr	:= iAdrMM2AmmBase;		
		
	xMsg2437.Num		:= 2437;
	xMsg2437.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2437.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2460.Num		:= 2460;
	xMsg2460.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2460.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2461.Num		:= 2461;
	xMsg2461.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2461.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2477.Num		:= 2477;
	xMsg2477.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2477.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2478.Num		:= 2478;
	xMsg2478.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2478.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2479.Num		:= 2479;
	xMsg2479.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2479.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2480.Num		:= 2480;
	xMsg2480.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2480.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2481.Num		:= 2481;
	xMsg2481.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2481.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2482.Num		:= 2482;
	xMsg2482.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2482.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2483.Num		:= 2483;
	xMsg2483.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2483.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2484.Num		:= 2484;
	xMsg2484.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2484.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2485.Num		:= 2485;
	xMsg2485.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2485.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2486.Num		:= 2486;
	xMsg2486.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2486.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2489.Num		:= 2489;
	xMsg2489.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2489.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2490.Num		:= 2490;
	xMsg2490.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2490.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2491.Num		:= 2491;
	xMsg2491.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2491.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2510.Num		:= 2510;
	xMsg2510.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2510.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2511.Num		:= 2511;
	xMsg2511.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2511.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2512.Num		:= 2512;
	xMsg2512.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2512.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2513.Num		:= 2513;
	xMsg2513.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2513.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2525.Num		:= 2525;
	xMsg2525.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2525.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2526.Num		:= 2526;
	xMsg2526.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2526.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2527.Num		:= 2527;
	xMsg2527.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2527.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2528.Num		:= 2528;
	xMsg2528.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2528.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2529.Num		:= 2529;
	xMsg2529.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2529.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2530.Num		:= 2530;
	xMsg2530.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2530.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2531.Num		:= 2531;
	xMsg2531.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2531.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2532.Num		:= 2532;
	xMsg2532.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2532.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg2533.Num		:= 2533;
	xMsg2533.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2533.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2539.Num		:= 2539;
	xMsg2539.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2539.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2540.Num		:= 2540;
	xMsg2540.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2540.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2541.Num		:= 2541;
	xMsg2541.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2541.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2543.Num		:= 2543;
	xMsg2543.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2543.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2548.Num		:= 2548;
	xMsg2548.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2548.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2550.Num		:= 2550;
	xMsg2550.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2550.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2563.Num		:= 2563;
	xMsg2563.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2563.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2564.Num		:= 2564;
	xMsg2564.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2564.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2565.Num		:= 2565;
	xMsg2565.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2565.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2566.Num		:= 2566;
	xMsg2566.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2566.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2611.Num		:= 2611;
	xMsg2611.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2611.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2612.Num		:= 2612;
	xMsg2612.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2612.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2614.Num		:= 2614;
	xMsg2614.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2614.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2615.Num		:= 2615;
	xMsg2615.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2615.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2616.Num		:= 2616;
	xMsg2616.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2616.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2617.Num		:= 2617;
	xMsg2617.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2617.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2618.Num		:= 2618;
	xMsg2618.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2618.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2619.Num		:= 2619;
	xMsg2619.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2619.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2620.Num		:= 2620;
	xMsg2620.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2620.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2621.Num		:= 2621;
	xMsg2621.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2621.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2626.Num		:= 2626;
	xMsg2626.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2626.AmmOutAdr	:= iAdrMM2AmmBase;	

    xMsg2668.Num		:= 2668;
	xMsg2668.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2668.AmmOutAdr	:= iAdrMM2AmmBase;		

    xMsg2669.Num		:= 2669;
	xMsg2669.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2669.AmmOutAdr	:= iAdrMM2AmmBase;		

    xMsg2670.Num		:= 2670;
	xMsg2670.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2670.AmmOutAdr	:= iAdrMM2AmmBase;	

    xMsg2671.Num		:= 2671;
	xMsg2671.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2671.AmmOutAdr	:= iAdrMM2AmmBase;

    xMsg2672.Num		:= 2672;
	xMsg2672.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2672.AmmOutAdr	:= iAdrMM2AmmBase;	

    xMsg2673.Num		:= 2673;
	xMsg2673.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2673.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2700.Num		:= 2700;
	xMsg2700.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2700.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2779.Num		:= 2779;
	xMsg2779.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2779.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2780.Num		:= 2780;
	xMsg2780.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2780.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3411.Num		:= 3411;
	xMsg3411.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg3411.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg3522.Num		:= 3522;
	xMsg3522.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg3522.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg3523.Num		:= 3523;
	xMsg3523.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg3523.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg3524.Num		:= 3524;
	xMsg3524.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg3524.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg3562.Num		:= 3562;
	xMsg3562.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg3562.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3597.Num		:= 3597;
	xMsg3597.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3597.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3598.Num		:= 3598;
	xMsg3598.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3598.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3599.Num		:= 3599;
	xMsg3599.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3599.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3600.Num		:= 3600;
	xMsg3600.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3600.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9237.Num		:= 9237;
	xMsg9237.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9237.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9238.Num		:= 9238;
	xMsg9238.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9238.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9239.Num		:= 9239;
	xMsg9239.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9239.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9240.Num		:= 9240;
	xMsg9240.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9240.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9241.Num		:= 9241;
	xMsg9241.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9241.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9242.Num		:= 9242;
	xMsg9242.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9242.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9243.Num		:= 9243;
	xMsg9243.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9243.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9370.Num		:= 9370;
	xMsg9370.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9370.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg9399.Num		:= 9399;
	xMsg9399.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9399.AmmOutAdr	:= iAdrMM2AmmBase;
END_PROGRAM

