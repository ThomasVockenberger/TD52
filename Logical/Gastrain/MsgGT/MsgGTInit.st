(*******************************************************************************
Msg_VE	 			 alarms generation MM_ventilation

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new

														
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
		
	iAdrAmmBase2MM		:=  ADR(IN_GT.tAB2GT);
	iAdrMM2AmmBase		:=  ADR(OUT_GT.tGT2AB);
		
	(*---------------------------------------------------------------------------*)
	xMsg1027.Num		:=  1027;
	xMsg1027.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1027.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1028.Num		:=  1028;
	xMsg1028.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1028.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1029.Num		:=  1029;
	xMsg1029.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1029.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1030.Num		:=  1030;
	xMsg1030.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1030.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg1057.Num		:=  1057;
	xMsg1057.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1057.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1058.Num		:=  1058;
	xMsg1058.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1058.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1084.Num		:=  1084;
	xMsg1084.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1084.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1085.Num		:=  1085;
	xMsg1085.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1085.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1086.Num		:=  1086;
	xMsg1086.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1086.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1087.Num		:=  1087;
	xMsg1087.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1087.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1088.Num		:=  1088;
	xMsg1088.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1088.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1094.Num		:=  1094;
	xMsg1094.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1094.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1095.Num		:=  1095;
	xMsg1095.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1095.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1128.Num		:=  1128;
	xMsg1128.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1128.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1251.Num		:=  1251;
	xMsg1251.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1251.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1252.Num		:=  1252;
	xMsg1252.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1252.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2243.Num		:=  2243;
	xMsg2243.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2243.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2246.Num		:=  2246;
	xMsg2246.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2246.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2247.Num		:=  2247;
	xMsg2247.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2247.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2250.Num		:=  2250;
	xMsg2250.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2250.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2251.Num		:=  2251;
	xMsg2251.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2251.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2257.Num		:=  2257;
	xMsg2257.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2257.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2535.Num		:=  2535;
	xMsg2535.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2535.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2536.Num		:=  2536;
	xMsg2536.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2536.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2537.Num		:=  2537;
	xMsg2537.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2537.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2538.Num		:=  2538;
	xMsg2538.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2538.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2578.Num		:=  2578;
	xMsg2578.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2578.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2674.Num		:=  2674;
	xMsg2674.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2674.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3004.Num		:=  3004;
	xMsg3004.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3004.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3153.Num		:=  3153;
	xMsg3153.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3153.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3154.Num		:=  3154;
	xMsg3154.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3154.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3155.Num		:=  3155;
	xMsg3155.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3155.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3156.Num		:=  3156;
	xMsg3156.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3156.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3157.Num		:=  3157;
	xMsg3157.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3157.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3158.Num		:=  3158;
	xMsg3158.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3158.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3159.Num		:=  3159;
	xMsg3159.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3159.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3160.Num		:=  3160;
	xMsg3160.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3160.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3221.Num		:=  3221;
	xMsg3221.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3221.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3222.Num		:=  3222;
	xMsg3222.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3222.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3227.Num		:=	3227;
	xMsg3227.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3227.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3257.Num		:=	3257;
	xMsg3257.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3257.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3258.Num		:=	3258;
	xMsg3258.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3258.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3259.Num		:=	3259;
	xMsg3259.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3259.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3260.Num		:=	3260;
	xMsg3260.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3260.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3261.Num		:=	3261;
	xMsg3261.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3261.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3262.Num		:=	3262;
	xMsg3262.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3262.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3308.Num		:=  3308;
	xMsg3308.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3308.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3309.Num		:=  3309;
	xMsg3309.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3309.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3315.Num		:=  3315;
	xMsg3315.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3315.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3316.Num		:=  3316;
	xMsg3316.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3316.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3317.Num		:=  3317;
	xMsg3317.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3317.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3318.Num		:=  3318;
	xMsg3318.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3318.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3320.Num		:=  3320;
	xMsg3320.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3320.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3324.Num		:=  3324;
	xMsg3324.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3324.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3325.Num		:=  3325;
	xMsg3325.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3325.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3326.Num		:=  3326;
	xMsg3326.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3326.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3327.Num		:=  3327;
	xMsg3327.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3327.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3328.Num		:=  3328;
	xMsg3328.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3328.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3353.Num		:=  3353;
	xMsg3353.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3353.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3354.Num		:=  3354;
	xMsg3354.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3354.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3355.Num		:=  3355;
	xMsg3355.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3355.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3356.Num		:=  3356;
	xMsg3356.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3356.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3357.Num		:=  3357;
	xMsg3357.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3357.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3358.Num		:=  3358;
	xMsg3358.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3358.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3359.Num		:=  3359;
	xMsg3359.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3359.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3360.Num		:=  3360;
	xMsg3360.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3360.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3361.Num		:=  3361;
	xMsg3361.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3361.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3362.Num		:=  3362;
	xMsg3362.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3362.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3363.Num		:=  3363;
	xMsg3363.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3363.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3364.Num		:=  3364;
	xMsg3364.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3364.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3365.Num		:=  3365;
	xMsg3365.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3365.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3520.Num		:=  3520;
	xMsg3520.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3520.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3567.Num		:=  3567;
	xMsg3567.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3567.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3568.Num		:=  3568;
	xMsg3568.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3568.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3569.Num		:=  3569;
	xMsg3569.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3569.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3570.Num		:=  3570;
	xMsg3570.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3570.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3525.Num		:=  3525;
	xMsg3525.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3525.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2247.Num		:=  2247;
	xMsg2247.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2247.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2257.Num		:=  2257;
	xMsg2257.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2257.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3448.Num		:=  3448;
	xMsg3448.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3448.AmmOutAdr	:=  iAdrMM2AmmBase;


	xMsg3444.Num		:=  3444;
	xMsg3444.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3444.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3376.Num		:=  3376;
	xMsg3376.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3376.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3445.Num		:=  3445;
	xMsg3445.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3445.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2289.Num		:=  2289;
	xMsg2289.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2289.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2271.Num		:=  2271;
	xMsg2271.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2271.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2261.Num		:=  2261;
	xMsg2261.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2261.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3377.Num		:=  3377;
	xMsg3377.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3377.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2272.Num		:=  2272;
	xMsg2272.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2272.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2231.Num		:=  2231;
	xMsg2231.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2231.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2240.Num		:=  2240;
	xMsg2240.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2240.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2241.Num		:=  2241;
	xMsg2241.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2241.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2248.Num		:=  2248;
	xMsg2248.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2248.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2249.Num		:=  2249;
	xMsg2249.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2249.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2273.Num		:=  2273;
	xMsg2273.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2273.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2567.Num		:=  2567;
	xMsg2567.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2567.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2568.Num		:=  2568;
	xMsg2568.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2568.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2569.Num		:=  2569;
	xMsg2569.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2569.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2580.Num		:=  2580;
	xMsg2580.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2580.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2581.Num		:=  2581;
	xMsg2581.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2581.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2244.Num		:=  2244;
	xMsg2244.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2244.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2245.Num		:=  2245;
	xMsg2245.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2245.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1265.Num		:=  1265;
	xMsg1265.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg1265.AmmOutAdr	:=  iAdrMM2AmmBase;	
			
	xMsg1266.Num		:=  1266;
	xMsg1266.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg1266.AmmOutAdr	:=  iAdrMM2AmmBase;	
			
	xMsg1267.Num		:=  1267;
	xMsg1267.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg1267.AmmOutAdr	:=  iAdrMM2AmmBase;	
			
	xMsg1268.Num		:=  1268;
	xMsg1268.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg1268.AmmOutAdr	:=  iAdrMM2AmmBase;		
		
	xMsg1269.Num		:=  1269;
	xMsg1269.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg1269.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1270.Num		:=  1270;
	xMsg1270.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg1270.AmmOutAdr	:=  iAdrMM2AmmBase;	
			
	xMsg1271.Num		:=  1271;
	xMsg1271.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg1271.AmmOutAdr	:=  iAdrMM2AmmBase;	
			
	xMsg1272.Num		:=  1272;
	xMsg1272.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg1272.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3387.Num		:=  3387;
	xMsg3387.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg3387.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3388.Num		:=  3388;
	xMsg3388.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg3388.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3389.Num		:=  3389;
	xMsg3389.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg3389.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3390.Num		:=  3390;
	xMsg3390.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg3390.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3391.Num		:=  3391;
	xMsg3391.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg3391.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3392.Num		:=  3392;
	xMsg3392.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg3392.AmmOutAdr	:=  iAdrMM2AmmBase;

	
	xMsg2694.Num		:=  2694;
	xMsg2694.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2694.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2695.Num		:=  2695;
	xMsg2695.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2695.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2696.Num		:=  2696;
	xMsg2696.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2696.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3398.Num		:=  3398;
	xMsg3398.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg3398.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2753.Num		:=  2753;
	xMsg2753.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2753.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2301.Num		:=  2301;
	xMsg2301.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2301.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2443.Num		:=  2443;
	xMsg2443.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2443.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2444.Num		:=  2444;
	xMsg2444.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2444.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2445.Num		:=  2445;
	xMsg2445.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2445.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2309.Num		:=  2309;
	xMsg2309.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2309.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2462.Num		:=  2462;
	xMsg2462.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2462.AmmOutAdr	:=  iAdrMM2AmmBase;	
		
	xMsg2927.Num		:=  2927;
	xMsg2927.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2927.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2463.Num		:=  2463;
	xMsg2463.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2463.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2465.Num		:=  2465;
	xMsg2465.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2465.AmmOutAdr	:=  iAdrMM2AmmBase;	
		
	xMsg2928.Num		:=  2928;
	xMsg2928.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2928.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2466.Num		:=  2466;
	xMsg2466.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2466.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2467.Num		:=  2467;
	xMsg2467.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2467.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2314.Num		:=  2314;
	xMsg2314.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2314.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2570.Num		:=  2570;
	xMsg2570.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2570.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	
	(*BETA V4.07*) 
	xMsg2990.Num		:=  2990;
	xMsg2990.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2990.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2991.Num		:=  2991;
	xMsg2991.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2991.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2992.Num		:=  2992;
	xMsg2992.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2992.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2993.Num		:=  2993;
	xMsg2993.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2993.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2994.Num		:=  2994;
	xMsg2994.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2994.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2995.Num		:=  2995;
	xMsg2995.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2995.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2996.Num		:=  2996;
	xMsg2996.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2996.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2997.Num		:=  2997;
	xMsg2997.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2997.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	
	(*BETA V4.07*) 
	xMsg9259.Num		:=  9259;
	xMsg9259.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9259.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9260.Num		:=  9260;
	xMsg9260.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9260.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9275.Num		:=  9275;	
	xMsg9275.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9275.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9276.Num		:=  9276;					(*Gas Temp max*)
	xMsg9276.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9276.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9300.Num		:=  9300;					
	xMsg9300.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9300.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9301.Num		:=  9301;					
	xMsg9301.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9301.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9302.Num		:=  9302;					
	xMsg9302.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9302.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2346.Num		:=  2346;					
	xMsg2346.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2346.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2976.Num		:=  2976;					
	xMsg2976.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2976.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9360.Num		:=  9360;					
	xMsg9360.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9360.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9361.Num		:=  9361;					
	xMsg9361.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9361.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2364.Num		:=  2364;					
	xMsg2364.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg2364.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9371.Num		:=  9371;					
	xMsg9371.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9371.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9387.Num		:=  9387;					
	xMsg9387.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9387.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9086.Num		:=  9086;					
	xMsg9086.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9086.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9087.Num		:=  9087;					
	xMsg9087.AmmInAdr	:=  iAdrAmmBase2MM;	
	xMsg9087.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9509.Num		:=  9509;
	xMsg9509.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9509.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	(* template
	xMsg.Num		:=	;
	xMsg.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg.AmmOutAdr	:=  iAdrMM2AmmBase;
	*)	
	
END_PROGRAM

