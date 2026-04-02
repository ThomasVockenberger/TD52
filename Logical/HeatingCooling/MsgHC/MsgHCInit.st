(*******************************************************************************
Msg_HC	 			 alarms generation heating cooling

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
		
	iAdrAmmBase2MM		:=  ADR(IN_HC.tAB2HC);
	iAdrMM2AmmBase		:=  ADR(OUT_HC.tHC2AB);
	
	(*---------------------------------------------------------------------------*)

	xMsg1019.Num		:=	1019;
	xMsg1019.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1019.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1021.Num		:=	1021;
	xMsg1021.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1021.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1032.Num		:=	1032;
	xMsg1032.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1032.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1033.Num		:=	1033;
	xMsg1033.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1033.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1034.Num		:=	1034;
	xMsg1034.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1034.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1035.Num		:=	1035;
	xMsg1035.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1035.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1050.Num		:=	1050;
	xMsg1050.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1050.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1063.Num		:=	1063;
	xMsg1063.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1063.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1070.Num		:=	1070;
	xMsg1070.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1070.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1071.Num		:=	1071;
	xMsg1071.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1071.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1130.Num		:=	1130;
	xMsg1130.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1130.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1145.Num		:=	1145;
	xMsg1145.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1145.AmmOutAdr	:=  iAdrMM2AmmBase;	
		
	xMsg1167.Num		:=	1167;
	xMsg1167.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1167.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg1186.Num		:=	1186;
	xMsg1186.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1186.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg1187.Num		:=	1187;
	xMsg1187.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1187.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2101.Num		:=	2101;
	xMsg2101.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2101.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2104.Num		:=	2104;
	xMsg2104.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2104.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2116.Num		:=	2116;
	xMsg2116.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2116.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2117.Num		:=	2117;
	xMsg2117.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2117.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2119.Num		:=	2119;
	xMsg2119.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2119.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2341.Num		:=	2341;
	xMsg2341.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2341.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2342.Num		:=	2342;
	xMsg2342.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2342.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2343.Num		:=	2343;
	xMsg2343.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2343.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2428.Num		:=	2428;//SWAT920/1
	xMsg2428.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2428.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2429.Num		:=	2429;//SWAT920/1
	xMsg2429.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2429.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2430.Num		:=	2430;//SWAT920/1
	xMsg2430.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2430.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2638.Num		:=	2638;
	xMsg2638.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2638.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2639.Num		:=	2639;
	xMsg2639.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2639.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2640.Num		:=	2640;
	xMsg2640.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2640.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2641.Num		:=	2641;
	xMsg2641.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2641.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2647.Num 		:= 	2647;	
	xMsg2647.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2647.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2667.Num 		:= 	2667;	
	xMsg2667.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2667.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2675.Num 		:= 	2675;	
	xMsg2675.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2675.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2676.Num 		:= 	2676;	
	xMsg2676.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2676.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2677.Num 		:= 	2677;	
	xMsg2677.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2677.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2678.Num 		:= 	2678;	
	xMsg2678.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2678.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2679.Num 		:= 	2679;	
	xMsg2679.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2679.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2680.Num 		:= 	2680;	
	xMsg2680.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2680.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2681.Num 		:= 	2681;	
	xMsg2681.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2681.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2682.Num 		:= 	2682;	
	xMsg2682.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2682.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2683.Num 		:= 	2683;	
	xMsg2683.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2683.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2684.Num 		:= 	2684;	
	xMsg2684.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2684.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2685.Num 		:= 	2685;	
	xMsg2685.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2685.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2686.Num 		:= 	2686;	
	xMsg2686.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2686.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2687.Num 		:= 	2687;	
	xMsg2687.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2687.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2710.Num 		:= 	2710;
	xMsg2710.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2710.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2711.Num 		:= 	2711;
	xMsg2711.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2711.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2712.Num 		:= 	2712;
	xMsg2712.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2712.AmmOutAdr 	:=  iAdrMM2AmmBase;
		
	xMsg2713.Num 		:= 	2713;
	xMsg2713.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2713.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2714.Num 		:= 	2714;
	xMsg2714.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2714.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2715.Num 		:= 	2715;
	xMsg2715.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2715.AmmOutAdr 	:=  iAdrMM2AmmBase;
		
	xMsg2716.Num 		:= 	2716;
	xMsg2716.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2716.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2717.Num 		:= 	2717;
	xMsg2717.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2717.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2718.Num 		:= 	2718;
	xMsg2718.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2718.AmmOutAdr 	:=  iAdrMM2AmmBase;
		
	xMsg2719.Num 		:= 	2719;
	xMsg2719.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2719.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2720.Num 		:= 	2720;
	xMsg2720.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2720.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2721.Num 		:= 	2721;
	xMsg2721.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2721.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2731.Num 		:= 	2731;	
	xMsg2731.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2731.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2732.Num 		:= 	2732;	
	xMsg2732.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2732.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2733.Num 		:= 	2733;	
	xMsg2733.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2733.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2734.Num 		:= 	2734;	
	xMsg2734.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2734.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2735.Num 		:= 	2735;	
	xMsg2735.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2735.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2736.Num 		:= 	2736;	
	xMsg2736.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2736.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2750.Num 		:= 	2750;	
	xMsg2750.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2750.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2751.Num 		:= 	2751;	
	xMsg2751.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2751.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2752.Num 		:= 	2752;	
	xMsg2752.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2752.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg2763.Num 		:= 	2763;	
	xMsg2763.AmmInAdr 	:=  iAdrAmmBase2MM;			
	xMsg2763.AmmOutAdr 	:=  iAdrMM2AmmBase;

	xMsg3220.Num		:=	3220;
	xMsg3220.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3220.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3303.Num		:=	3303;
	xMsg3303.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3303.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3312.Num		:=	3312;
	xMsg3312.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3312.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3321.Num		:=	3321;
	xMsg3321.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3321.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3402.Num		:=	3402;
	xMsg3402.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3402.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3404.Num		:=	3404;
	xMsg3404.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3404.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3406.Num		:=	3406;
	xMsg3406.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3406.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3407.Num		:=	3407;			
    xMsg3407.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3407.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3492.Num		:=	3492;			
    xMsg3492.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3492.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3493.Num		:=	3493;			
    xMsg3493.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3493.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3494.Num		:=	3494;			
    xMsg3494.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3494.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3508.Num		:=	3508;
	xMsg3508.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3508.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3509.Num		:=	3509;
	xMsg3509.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3509.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3521.Num		:=	3521;
	xMsg3521.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3521.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3526.Num		:=	3526;
	xMsg3526.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3526.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3527.Num		:=	3527;
	xMsg3527.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3527.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3590.Num		:=	3590;
	xMsg3590.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3590.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9226.Num		:=	9226;
	xMsg9226.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9226.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9098.Num		:=	9098;
	xMsg9098.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9098.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9099.Num		:=	9099;
	xMsg9099.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9099.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9228.Num		:=	9228;
	xMsg9228.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9228.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9229.Num		:=	9229;
	xMsg9229.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9229.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9230.Num		:=	9230;
	xMsg9230.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9230.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9231.Num		:=	9231;
	xMsg9231.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9231.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9232.Num		:=	9232;
	xMsg9232.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9232.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9588.Num		:= 9588;
	xMsg9588.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9588.AmmOutAdr	:= iAdrMM2AmmBase;	
			
	xMsg9589.Num		:= 9589;
	xMsg9589.AmmInAdr	:= iAdrAmmBase2MM;	
	xMsg9589.AmmOutAdr	:= iAdrMM2AmmBase;	
END_PROGRAM

