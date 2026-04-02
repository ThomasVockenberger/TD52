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
		
	iAdrAmmBase2MM		:=  ADR(IN_GC.tAB2GC);
	iAdrMM2AmmBase		:=  ADR(OUT_GC.tGC2AB);
		
	(*---------------------------------------------------------------------------*)
	xMsg1036.Num       := 1036;
	xMsg1036.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1036.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1037.Num       := 1037;
	xMsg1037.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1037.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1038.Num       := 1038;
	xMsg1038.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1038.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1062.Num       := 1062;
	xMsg1062.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1062.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1073.Num       := 1073;
	xMsg1073.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1073.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1109.Num       := 1109;
	xMsg1109.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1109.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1110.Num       := 1110;
	xMsg1110.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1110.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1111.Num       := 1111;
	xMsg1111.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1111.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1112.Num       := 1112;
	xMsg1112.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1112.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1113.Num       := 1113;
	xMsg1113.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1113.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1121.Num       := 1121;
	xMsg1121.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1121.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1122.Num       := 1122;
	xMsg1122.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1122.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1123.Num       := 1123;
	xMsg1123.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1123.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1124.Num       := 1124;
	xMsg1124.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1124.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1125.Num       := 1125;
	xMsg1125.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1125.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1126.Num       := 1126;
	xMsg1126.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1126.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1127.Num       := 1127;
	xMsg1127.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1127.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1132.Num       := 1132;
	xMsg1132.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1132.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1134.Num       := 1134;
	xMsg1134.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1134.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1143.Num       := 1143;
	xMsg1143.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1143.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1144.Num       := 1144;
	xMsg1144.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1144.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1154.Num       := 1154;
	xMsg1154.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1154.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1155.Num       := 1155;
	xMsg1155.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1155.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1156.Num       := 1156;
	xMsg1156.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1156.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1157.Num       := 1157;
	xMsg1157.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1157.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1158.Num       := 1158;
	xMsg1158.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1158.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg1185.Num       := 1185;
	xMsg1185.AmmInAdr  := iAdrAmmBase2MM;
	xMsg1185.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2100.Num       := 2100;
	xMsg2100.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2100.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2105.Num       := 2105;
	xMsg2105.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2105.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2106.Num       := 2106;
	xMsg2106.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2106.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2107.Num       := 2107;
	xMsg2107.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2107.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2108.Num       := 2108;
	xMsg2108.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2108.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2109.Num       := 2109;
	xMsg2109.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2109.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2110.Num       := 2110;
	xMsg2110.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2110.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2115.Num       := 2115;
	xMsg2115.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2115.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2156.Num       := 2156;
	xMsg2156.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2156.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2157.Num       := 2157;
	xMsg2157.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2157.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2202.Num       := 2202; 
	xMsg2202.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2202.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2203.Num       := 2203; 
	xMsg2203.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2203.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2204.Num       := 2204; 
	xMsg2204.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2204.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2205.Num       := 2205; 
	xMsg2205.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2205.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2206.Num       := 2206; 
	xMsg2206.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2206.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2207.Num       := 2207; 
	xMsg2207.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2207.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2208.Num 	   := 2208;	
	xMsg2208.AmmInAdr  := iAdrAmmBase2MM;			
	xMsg2208.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2277.Num       := 2277; 
	xMsg2277.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2277.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2316.Num       := 2316; 
	xMsg2316.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2316.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2336.Num       := 2336; 
	xMsg2336.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2336.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2371.Num	   := 2371;
	xMsg2371.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2371.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2372.Num	   := 2372;
	xMsg2372.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2372.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2373.Num	   := 2373;
	xMsg2373.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2373.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2501.Num       := 2501;
	xMsg2501.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2501.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2502.Num       := 2502; 
	xMsg2502.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2502.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2503.Num       := 2503; 
	xMsg2503.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2503.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2504.Num       := 2504; 
	xMsg2504.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2504.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2505.Num 	   := 2505;	
	xMsg2505.AmmInAdr  := iAdrAmmBase2MM;			
	xMsg2505.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2508.Num 	   := 2508;	
	xMsg2508.AmmInAdr  := iAdrAmmBase2MM;			
	xMsg2508.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2555.Num       := 2555; 
	xMsg2555.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2555.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2556.Num       := 2556; 
	xMsg2556.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2556.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2573.Num       := 2573;
	xMsg2573.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2573.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2631.Num       := 2631; 
	xMsg2631.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2631.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2632.Num       := 2632; 
	xMsg2632.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2632.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2633.Num       := 2633; 
	xMsg2633.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2633.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2634.Num       := 2634; 
	xMsg2634.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2634.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2637.Num       := 2637; 
	xMsg2637.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2637.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2665.Num       := 2665; 
	xMsg2665.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2665.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2690.Num		:=	2690;
	xMsg2690.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2690.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2691.Num		:=	2691;
	xMsg2691.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2691.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2827.Num	   := 2827;
	xMsg2827.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2827.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2828.Num	   := 2828;
	xMsg2828.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2828.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2829.Num	   := 2829;
	xMsg2829.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2829.AmmOutAdr := iAdrMM2AmmBase;

	xMsg2830.Num	   := 2830;
	xMsg2830.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2830.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg2998.Num	   := 2998;
	xMsg2998.AmmInAdr  := iAdrAmmBase2MM;
	xMsg2998.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg3219.Num       := 3219;
	xMsg3219.AmmInAdr  := iAdrAmmBase2MM;
	xMsg3219.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg3298.Num       := 3298;
	xMsg3298.AmmInAdr  := iAdrAmmBase2MM;
	xMsg3298.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg3299.Num       := 3299;
	xMsg3299.AmmInAdr  := iAdrAmmBase2MM;
	xMsg3299.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg3319.Num       := 3319;
	xMsg3319.AmmInAdr  := iAdrAmmBase2MM;
	xMsg3319.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg3393.Num		:=  3393;
	xMsg3393.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3393.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3418.Num 		:= 3418;	
	xMsg3418.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3418.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3419.Num 		:= 3419;
	xMsg3419.AmmInAdr 	:= iAdrAmmBase2MM;
	xMsg3419.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3420.Num 		:= 3420;	
	xMsg3420.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3420.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3421.Num 		:= 3421;	
	xMsg3421.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3421.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3422.Num 		:= 3422;	
	xMsg3422.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3422.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3423.Num 		:= 3423;	
	xMsg3423.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3423.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3424.Num 		:= 3424;	
	xMsg3424.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3424.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3425.Num 		:= 3425;	
	xMsg3425.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3425.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3426.Num 		:= 3426;	
	xMsg3426.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3426.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3427.Num 		:= 3427;	
	xMsg3427.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3427.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3428.Num 		:= 3428;	
	xMsg3428.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3428.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3429.Num 		:= 3429;	
	xMsg3429.AmmInAdr 	:= iAdrAmmBase2MM;		
	xMsg3429.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3430.Num 		:= 3430;	
	xMsg3430.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3430.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3431.Num 		:= 3431;	
	xMsg3431.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3431.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3432.Num 		:= 3432;	
	xMsg3432.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3432.AmmOutAdr 	:= iAdrMM2AmmBase;		
		
	xMsg3433.Num 		:= 3433;	
	xMsg3433.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3433.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3434.Num 		:= 3434;	
	xMsg3434.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3434.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3435.Num 		:= 3435;	
	xMsg3435.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3435.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3436.Num 		:= 3436;	
	xMsg3436.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3436.AmmOutAdr 	:= iAdrMM2AmmBase;		
		
	xMsg3437.Num 		:= 3437;	
	xMsg3437.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3437.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3438.Num 		:= 3438;	
	xMsg3438.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3438.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3439.Num 		:= 3439;	
	xMsg3439.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3439.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3440.Num 		:= 3440;	
	xMsg3440.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3440.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3441.Num 		:= 3441;	
	xMsg3441.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3441.AmmOutAdr 	:= iAdrMM2AmmBase;		

	xMsg3442.Num 		:= 3442;	
	xMsg3442.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3442.AmmOutAdr 	:= iAdrMM2AmmBase;		
	
	xMsg3443.Num 		:= 3443;	
	xMsg3443.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3443.AmmOutAdr 	:= iAdrMM2AmmBase;	

	xMsg3446.Num 		:= 3446;	
	xMsg3446.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3446.AmmOutAdr 	:= iAdrMM2AmmBase;
	
	xMsg3447.Num 		:= 3447;	
	xMsg3447.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3447.AmmOutAdr 	:= iAdrMM2AmmBase;		

	xMsg3468.Num 		:= 3468;	
	xMsg3468.AmmInAdr 	:= iAdrAmmBase2MM;			
	xMsg3468.AmmOutAdr 	:= iAdrMM2AmmBase;		

	xMsg3516.Num       := 3516;
	xMsg3516.AmmInAdr  := iAdrAmmBase2MM;
	xMsg3516.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg3563.Num       := 3563;
	xMsg3563.AmmInAdr  := iAdrAmmBase2MM;
	xMsg3563.AmmOutAdr := iAdrMM2AmmBase;
		
	xMsg3566.Num       := 3566;
	xMsg3566.AmmInAdr  := iAdrAmmBase2MM;
	xMsg3566.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg3573.Num       := 3573; 
	xMsg3573.AmmInAdr  := iAdrAmmBase2MM;
	xMsg3573.AmmOutAdr := iAdrMM2AmmBase;

	xMsg9285.Num       := 9285; 
	xMsg9285.AmmInAdr  := iAdrAmmBase2MM;
	xMsg9285.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg9311.Num       := 9311; 
	xMsg9311.AmmInAdr  := iAdrAmmBase2MM;
	xMsg9311.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg9351.Num       := 9351; 
	xMsg9351.AmmInAdr  := iAdrAmmBase2MM;
	xMsg9351.AmmOutAdr := iAdrMM2AmmBase;

	xMsg9365.Num       := 9365; 
	xMsg9365.AmmInAdr  := iAdrAmmBase2MM;
	xMsg9365.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg9366.Num       := 9366; 
	xMsg9366.AmmInAdr  := iAdrAmmBase2MM;
	xMsg9366.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg9367.Num       := 9367; 
	xMsg9367.AmmInAdr  := iAdrAmmBase2MM;
	xMsg9367.AmmOutAdr := iAdrMM2AmmBase;
	
	xMsg9368.Num       := 9368; 
	xMsg9368.AmmInAdr  := iAdrAmmBase2MM;
	xMsg9368.AmmOutAdr := iAdrMM2AmmBase;

	xMsg9372.Num       := 9372; 
	xMsg9372.AmmInAdr  := iAdrAmmBase2MM;
	xMsg9372.AmmOutAdr := iAdrMM2AmmBase;
	
END_PROGRAM

