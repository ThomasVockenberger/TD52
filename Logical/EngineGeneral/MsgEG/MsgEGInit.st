(*******************************************************************************
Msg_EG	 			 alarms generation MM_EngineGeneral

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Instructions FOR use:
--------------------
1) declare alarm with function block "Msg"

2) use template to create a new alarm, substitue 0000 by message number:

	xMsg0000.Num		:=	0000;					alarm number
	xMsg0000.AmmSysAdr	:=  iAdrAmmBase2MM;			do not change
	xMsg0000.AmmOutAdr	:=  iAdrMM2AmmBase;			do not change

3) 	set alarm number
	

(*******************************************************************************)
PROGRAM _INIT
		
	iAdrAmmBase2MM		:= ADR(IN_EG.tAB2EG);
	iAdrMM2AmmBase		:= ADR(OUT_EG.tEG2AB);
		
	(*---------------------------------------------------------------------------*)

	xMsg1026.Num		:= 1026;
	xMsg1026.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg1026.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg1031.Num		:= 1031;
	xMsg1031.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg1031.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg1056.Num		:= 1056;
	xMsg1056.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg1056.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg1168.Num		:= 1168;
	xMsg1168.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg1168.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2190.Num		:= 2190;
	xMsg2190.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2190.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2191.Num		:= 2191;
	xMsg2191.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2191.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2192.Num		:= 2192;
	xMsg2192.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2192.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2193.Num		:= 2193;
	xMsg2193.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2193.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2194.Num		:= 2194;
	xMsg2194.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2194.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2195.Num		:= 2195;
	xMsg2195.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2195.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2196.Num		:= 2196;
	xMsg2196.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2196.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2197.Num		:= 2197;
	xMsg2197.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2197.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2198.Num		:= 2198;
	xMsg2198.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2198.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2199.Num		:= 2199;
	xMsg2199.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2199.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2200.Num		:= 2200;
	xMsg2200.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2200.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2227.Num		:= 2227;
	xMsg2227.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2227.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2228.Num		:= 2228;
	xMsg2228.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2228.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2229.Num		:= 2229;
	xMsg2229.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2229.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2230.Num		:= 2230;
	xMsg2230.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2230.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2232.Num		:= 2232;
	xMsg2232.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2232.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2270.Num		:= 2270;
	xMsg2270.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2270.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2285.Num		:= 2285;
	xMsg2285.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2285.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2286.Num		:= 2286;
	xMsg2286.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2286.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2300.Num		:= 2300;
	xMsg2300.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2300.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2362.Num		:= 2362;
	xMsg2362.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2362.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2383.Num		:= 2383;
	xMsg2383.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2383.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2384.Num		:= 2384;
	xMsg2384.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2384.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2385.Num		:= 2385;
	xMsg2385.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2385.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2386.Num		:= 2386;
	xMsg2386.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2386.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2387.Num		:= 2387;
	xMsg2387.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2387.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2388.Num		:= 2388;
	xMsg2388.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2388.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2389.Num		:= 2389;
	xMsg2389.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2389.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2390.Num		:= 2390;
	xMsg2390.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2390.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2391.Num		:= 2391;
	xMsg2391.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2391.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2392.Num		:= 2392;
	xMsg2392.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2392.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2393.Num		:= 2393;
	xMsg2393.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2393.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2394.Num		:= 2394;
	xMsg2394.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2394.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2395.Num		:= 2395;
	xMsg2395.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2395.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2396.Num		:= 2396;
	xMsg2396.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2396.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2397.Num		:= 2397;
	xMsg2397.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2397.AmmOutAdr	:= iAdrMM2AmmBase;
		
	xMsg2398.Num		:= 2398;
	xMsg2398.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2398.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2542.Num		:= 2542;
	xMsg2542.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2542.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2544.Num		:= 2544;
	xMsg2544.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2544.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2552.Num		:= 2552;
	xMsg2552.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2552.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2553.Num		:= 2553;
	xMsg2553.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2553.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2561.Num		:= 2561;
	xMsg2561.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2561.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2790.Num		:= 2790;
	xMsg2790.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2790.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2794.Num		:= 2794;
	xMsg2794.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2794.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2804.Num		:= 2804;
	xMsg2804.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2804.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2805.Num		:= 2805;
	xMsg2805.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2805.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2806.Num		:= 2806;
	xMsg2806.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2806.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2807.Num		:= 2807;
	xMsg2807.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2807.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2822.Num		:= 2822;
	xMsg2822.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2822.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2904.Num		:= 2904;
	xMsg2904.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2904.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2905.Num		:= 2905;
	xMsg2905.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2905.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2909.Num		:= 2909;
	xMsg2909.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2909.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2958.Num		:= 2958;
	xMsg2958.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2958.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2959.Num		:= 2959;
	xMsg2959.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2959.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2981.Num		:= 2981;
	xMsg2981.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2981.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3368.Num		:= 3368;
	xMsg3368.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3368.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3378.Num		:= 3378;
	xMsg3378.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3378.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3396.Num		:= 3396;
	xMsg3396.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3396.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg3449.Num		:= 3449;
	xMsg3449.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3449.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3559.Num		:= 3559;
	xMsg3559.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3559.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9038.Num		:= 9038;
	xMsg9038.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9038.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9217.Num		:= 9217;
	xMsg9217.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9217.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9218.Num		:= 9218;
	xMsg9218.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9218.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9219.Num		:= 9219;
	xMsg9219.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9219.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9408.Num		:= 9408;
	xMsg9408.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9408.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9409.Num		:= 9409;
	xMsg9409.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9409.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9410.Num		:= 9410;
	xMsg9410.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9410.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9411.Num		:= 9411;
	xMsg9411.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9411.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9412.Num		:= 9412;
	xMsg9412.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9412.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9413.Num		:= 9413;
	xMsg9413.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9413.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9414.Num		:= 9414;
	xMsg9414.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9414.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9415.Num		:= 9415;
	xMsg9415.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9415.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9416.Num		:= 9416;
	xMsg9416.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9416.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9417.Num		:= 9417;
	xMsg9417.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9417.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9418.Num		:= 9418;
	xMsg9418.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9418.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9419.Num		:= 9419;
	xMsg9419.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9419.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9420.Num		:= 9420;
	xMsg9420.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9420.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9421.Num		:= 9421;
	xMsg9421.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9421.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9422.Num		:= 9422;
	xMsg9422.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9422.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9423.Num		:= 9423;
	xMsg9423.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9423.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg9424.Num		:= 9424;
	xMsg9424.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9424.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9425.Num		:= 9425;
	xMsg9425.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9425.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9426.Num		:= 9426;
	xMsg9426.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9426.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9427.Num		:= 9427;
	xMsg9427.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9427.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9428.Num		:= 9428;
	xMsg9428.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9428.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9429.Num		:= 9429;
	xMsg9429.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9429.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9430.Num		:= 9430;
	xMsg9430.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9430.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9431.Num		:= 9431;
	xMsg9431.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9431.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9433.Num		:= 9433;
	xMsg9433.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9433.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg9434.Num		:= 9434;
	xMsg9434.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9434.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9437.Num		:= 9437;
	xMsg9437.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9437.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9438.Num		:= 9438;
	xMsg9438.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9438.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9439.Num		:= 9439;
	xMsg9439.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9439.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9440.Num		:= 9440;
	xMsg9440.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9440.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9441.Num		:= 9441;
	xMsg9441.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9441.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9442.Num		:= 9442;
	xMsg9442.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9442.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9443.Num		:= 9443;
	xMsg9443.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9443.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9444.Num		:= 9444;
	xMsg9444.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9444.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9445.Num		:= 9445;
	xMsg9445.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9445.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9446.Num		:= 9446;
	xMsg9446.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9446.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9447.Num		:= 9447;
	xMsg9447.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9447.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9448.Num		:= 9448;
	xMsg9448.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9448.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9449.Num		:= 9449;
	xMsg9449.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9449.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9450.Num		:= 9450;
	xMsg9450.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9450.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9451.Num		:= 9451;
	xMsg9451.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9451.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9452.Num		:= 9452;
	xMsg9452.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9452.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9453.Num		:= 9453;
	xMsg9453.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9453.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9454.Num		:= 9454;
	xMsg9454.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9454.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9455.Num		:= 9455;
	xMsg9455.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9455.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9456.Num		:= 9456;
	xMsg9456.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9456.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9457.Num		:= 9457;
	xMsg9457.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9457.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9458.Num		:= 9458;
	xMsg9458.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9458.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9459.Num		:= 9459;
	xMsg9459.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9459.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9460.Num		:= 9460;
	xMsg9460.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9460.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9461.Num		:= 9461;
	xMsg9461.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9461.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9462.Num		:= 9462;
	xMsg9462.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9462.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9463.Num		:= 9463;
	xMsg9463.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9463.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9464.Num		:= 9464;
	xMsg9464.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9464.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9465.Num		:= 9465;
	xMsg9465.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9465.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9466.Num		:= 9466;
	xMsg9466.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9466.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9467.Num		:= 9467;
	xMsg9467.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9467.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9468.Num		:= 9468;
	xMsg9468.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9468.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9469.Num		:= 9469;
	xMsg9469.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9469.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9470.Num		:= 9470;
	xMsg9470.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9470.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9471.Num		:= 9471;
	xMsg9471.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9471.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9480.Num		:= 9480;
	xMsg9480.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9480.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9481.Num		:= 9481;
	xMsg9481.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9481.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9482.Num		:= 9482;
	xMsg9482.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9482.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9483.Num		:= 9483;
	xMsg9483.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9483.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9484.Num		:= 9484;
	xMsg9484.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9484.AmmOutAdr	:= iAdrMM2AmmBase;	


	xMsg9508.Num		:= 9508;
	xMsg9508.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9508.AmmOutAdr	:= iAdrMM2AmmBase;	
		
	xMsg9514.Num		:= 9514;
	xMsg9514.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9514.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9515.Num		:= 9515;
	xMsg9515.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9515.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9516.Num		:= 9516;
	xMsg9516.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9516.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9517.Num		:= 9517;
	xMsg9517.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9517.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9518.Num		:= 9518;
	xMsg9518.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9518.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9519.Num		:= 9519;
	xMsg9519.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9519.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9520.Num		:= 9520;
	xMsg9520.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9520.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9521.Num		:= 9521;
	xMsg9521.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9521.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9522.Num		:= 9522;
	xMsg9522.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9522.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9523.Num		:= 9523;
	xMsg9523.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9523.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9524.Num		:= 9524;
	xMsg9524.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9524.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9525.Num		:= 9525;
	xMsg9525.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9525.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9526.Num		:= 9526;
	xMsg9526.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9526.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9527.Num		:= 9527;
	xMsg9527.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9527.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9528.Num		:= 9528;
	xMsg9528.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9528.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9529.Num		:= 9529;
	xMsg9529.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9529.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9530.Num		:= 9530;
	xMsg9530.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9530.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9531.Num		:= 9531;
	xMsg9531.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9531.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9532.Num		:= 9532;
	xMsg9532.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9532.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9533.Num		:= 9533;
	xMsg9533.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9533.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9534.Num		:= 9534;
	xMsg9534.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9534.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9535.Num		:= 9535;
	xMsg9535.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9535.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9536.Num		:= 9536;
	xMsg9536.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9536.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9537.Num		:= 9537;
	xMsg9537.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9537.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9538.Num		:= 9538;
	xMsg9538.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9538.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9539.Num		:= 9539;
	xMsg9539.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9539.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9540.Num		:= 9540;
	xMsg9540.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9540.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9541.Num		:= 9541;
	xMsg9541.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9541.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9542.Num		:= 9542;
	xMsg9542.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9542.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9543.Num		:= 9543;
	xMsg9543.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9543.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9544.Num		:= 9544;
	xMsg9544.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9544.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9545.Num		:= 9545;
	xMsg9545.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9545.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9546.Num		:= 9546;
	xMsg9546.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9546.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9547.Num		:= 9547;
	xMsg9547.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9547.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9548.Num		:= 9548;
	xMsg9548.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9548.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9549.Num		:= 9549;
	xMsg9549.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9549.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9550.Num		:= 9550;
	xMsg9550.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9550.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9551.Num		:= 9551;
	xMsg9551.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9551.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9552.Num		:= 9552;
	xMsg9552.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9552.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9553.Num		:= 9553;
	xMsg9553.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9553.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9554.Num		:= 9554;
	xMsg9554.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9554.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9555.Num		:= 9555;
	xMsg9555.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9555.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9556.Num		:= 9556;
	xMsg9556.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9556.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9562.Num		:= 9562;
	xMsg9562.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9562.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9563.Num		:= 9563;
	xMsg9563.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9563.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9564.Num		:= 9564;
	xMsg9564.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9564.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9565.Num		:= 9565;
	xMsg9565.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9565.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9566.Num		:= 9566;
	xMsg9566.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9566.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9567.Num		:= 9567;
	xMsg9567.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9567.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9568.Num		:= 9568;
	xMsg9568.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9568.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9569.Num		:= 9569;
	xMsg9569.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9569.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9570.Num		:= 9570;
	xMsg9570.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9570.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9571.Num		:= 9571;
	xMsg9571.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9571.AmmOutAdr	:= iAdrMM2AmmBase;	
				
	xMsg9572.Num		:= 9572;
	xMsg9572.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9572.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9573.Num		:= 9573;
	xMsg9573.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9573.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9574.Num		:= 9574;
	xMsg9574.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9574.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9575.Num		:= 9575;
	xMsg9575.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9575.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9576.Num		:= 9576;
	xMsg9576.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9576.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9577.Num		:= 9577;
	xMsg9577.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9577.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg9578.Num		:= 9578;
	xMsg9578.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9578.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9579.Num		:= 9579;
	xMsg9579.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9579.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9580.Num		:= 9580;
	xMsg9580.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9580.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9581.Num		:= 9581;
	xMsg9581.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9581.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9582.Num		:= 9582;
	xMsg9582.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9582.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9583.Num		:= 9583;
	xMsg9583.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9583.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9584.Num		:= 9584;
	xMsg9584.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9584.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9585.Num		:= 9585;
	xMsg9585.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9585.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9586.Num		:= 9586;
	xMsg9586.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9586.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9587.Num		:= 9587;
	xMsg9587.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9587.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9593.Num		:= 9593;
	xMsg9593.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9593.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9597.Num		:= 9597;
	xMsg9597.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9597.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9598.Num		:= 9598;
	xMsg9598.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9598.AmmOutAdr	:= iAdrMM2AmmBase;	
		
	xMsg9600.Num		:= 9600;
	xMsg9600.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9600.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9627.Num		:= 9627;
	xMsg9627.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9627.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9628.Num		:= 9628;
	xMsg9628.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9628.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9629.Num		:= 9629;
	xMsg9629.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9629.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9630.Num		:= 9630;
	xMsg9630.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9630.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9631.Num		:= 9631;
	xMsg9631.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9631.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9632.Num		:= 9632;
	xMsg9632.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9632.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9633.Num		:= 9633;
	xMsg9633.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9633.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9634.Num		:= 9634;
	xMsg9634.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9634.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9635.Num		:= 9635;
	xMsg9635.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9635.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9636.Num		:= 9636;
	xMsg9636.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9636.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9637.Num		:= 9637;
	xMsg9637.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9637.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9638.Num		:= 9638;
	xMsg9638.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9638.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9639.Num		:= 9639;
	xMsg9639.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9639.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9640.Num		:= 9640;
	xMsg9640.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9640.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9641.Num		:= 9641;
	xMsg9641.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9641.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9642.Num		:= 9642;
	xMsg9642.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9642.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg9643.Num		:= 9643;
	xMsg9643.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9643.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9644.Num		:= 9644;
	xMsg9644.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9644.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9645.Num		:= 9645;
	xMsg9645.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9645.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9646.Num		:= 9646;
	xMsg9646.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9646.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9647.Num		:= 9647;
	xMsg9647.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9647.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9648.Num		:= 9648;
	xMsg9648.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9648.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9649.Num		:= 9649;
	xMsg9649.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9649.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9650.Num		:= 9650;
	xMsg9650.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9650.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9651.Num		:= 9651;
	xMsg9651.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9651.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9652.Num		:= 9652;
	xMsg9652.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9652.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg9653.Num		:= 9653;
	xMsg9653.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9653.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9654.Num		:= 9654;
	xMsg9654.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9654.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9655.Num		:= 9655;
	xMsg9655.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9655.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9656.Num		:= 9656;
	xMsg9656.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9656.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9657.Num		:= 9657;
	xMsg9657.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9657.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9658.Num		:= 9658;
	xMsg9658.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9658.AmmOutAdr	:= iAdrMM2AmmBase;	
	
	xMsg9659.Num		:= 9659;
	xMsg9659.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9659.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9660.Num		:= 9660;
	xMsg9660.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9660.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9661.Num		:= 9661;
	xMsg9661.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9661.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9662.Num		:= 9662;
	xMsg9662.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9662.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9663.Num		:= 9663;
	xMsg9663.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9663.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9664.Num		:= 9664;
	xMsg9664.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9664.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9665.Num		:= 9665;
	xMsg9665.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9665.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9666.Num		:= 9666;
	xMsg9666.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9666.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9667.Num		:= 9667;
	xMsg9667.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9667.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9668.Num		:= 9668;
	xMsg9668.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9668.AmmOutAdr	:= iAdrMM2AmmBase;	
		
	xMsg9669.Num		:= 9669;
	xMsg9669.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9669.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9670.Num		:= 9670;
	xMsg9670.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9670.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9671.Num		:= 9671;
	xMsg9671.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9671.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9672.Num		:= 9672;
	xMsg9672.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9672.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9673.Num		:= 9673;
	xMsg9673.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9673.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9674.Num		:= 9674;
	xMsg9674.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9674.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg9675.Num		:= 9675;
	xMsg9675.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9675.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9676.Num		:= 9676;
	xMsg9676.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9676.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9677.Num		:= 9677;
	xMsg9677.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9677.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9678.Num		:= 9678;
	xMsg9678.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9678.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9679.Num		:= 9679;
	xMsg9679.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9679.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9680.Num		:= 9680;
	xMsg9680.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9680.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9681.Num		:= 9681;
	xMsg9681.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9681.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9682.Num		:= 9682;
	xMsg9682.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9682.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9683.Num		:= 9683;
	xMsg9683.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9683.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9684.Num		:= 9684;
	xMsg9684.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9684.AmmOutAdr	:= iAdrMM2AmmBase;	
				
	xMsg9685.Num		:= 9685;
	xMsg9685.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9685.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9686.Num		:= 9686;
	xMsg9686.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9686.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9687.Num		:= 9687;
	xMsg9687.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9687.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9688.Num		:= 9688;
	xMsg9688.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9688.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9689.Num		:= 9689;
	xMsg9689.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9689.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9690.Num		:= 9690;
	xMsg9690.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9690.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9691.Num		:= 9691;
	xMsg9691.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9691.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9692.Num		:= 9692;
	xMsg9692.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9692.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9693.Num		:= 9693;
	xMsg9693.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9693.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9694.Num		:= 9694;
	xMsg9694.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9694.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9695.Num		:= 9695;
	xMsg9695.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9695.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9696.Num		:= 9696;
	xMsg9696.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9696.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9697.Num		:= 9697;
	xMsg9697.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9697.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9698.Num		:= 9698;
	xMsg9698.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9698.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9699.Num		:= 9699;
	xMsg9699.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9699.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9700.Num		:= 9700;
	xMsg9700.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9700.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9701.Num		:= 9701;
	xMsg9701.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9701.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9702.Num		:= 9702;
	xMsg9702.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9702.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9703.Num		:= 9703;
	xMsg9703.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9703.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9704.Num		:= 9704;
	xMsg9704.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9704.AmmOutAdr	:= iAdrMM2AmmBase;		
END_PROGRAM

