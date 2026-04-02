(*******************************************************************************
Msg_EM	 			 alarms generation MM_emission

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new
V4.00.0 22-08-2013  Maxhera,    implementation of the module for modular software
V4.05.0	22.05.2017	Tinello		SCR added
		29.01.2018	Tinello		NOx warnings added
												
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

	iAdrAmmBase2MM		:=  ADR(IN_EM.tAB2EM);
	iAdrMM2AmmBase		:=  ADR(OUT_EM.tEM2AB);

	xMsg2276.Num		:= 2276;
	xMsg2276.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2276.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2446.Num		:= 2446;
	xMsg2446.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2446.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2447.Num		:= 2447;
	xMsg2447.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2447.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2448.Num		:= 2448;
	xMsg2448.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2448.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2449.Num		:= 2449;
	xMsg2449.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2449.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2450.Num		:= 2450;
	xMsg2450.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2450.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2451.Num		:= 2451;
	xMsg2451.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2451.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2452.Num		:= 2452;
	xMsg2452.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2452.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2453.Num		:= 2453;
	xMsg2453.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2453.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2454.Num		:= 2454;
	xMsg2454.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2454.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2455.Num		:= 2455;
	xMsg2455.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2455.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2456.Num		:= 2456;
	xMsg2456.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2456.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2457.Num		:= 2457;
	xMsg2457.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2457.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2458.Num		:= 2458;
	xMsg2458.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2458.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2464.Num		:= 2464;
	xMsg2464.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2464.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2607.Num		:= 2607;
	xMsg2607.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2607.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2609.Num		:= 2609;
	xMsg2609.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2609.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2610.Num		:= 2610;
	xMsg2610.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2610.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2697.Num		:=	2697;
	xMsg2697.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2697.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2766.Num		:=	2766;
	xMsg2766.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2766.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2769.Num		:=	2769;
	xMsg2769.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2769.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2877.Num 		:= 2877;
	xMsg2877.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2877.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg2878.Num 		:= 2878;
	xMsg2878.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2878.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg2879.Num 		:= 2879;
	xMsg2879.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2879.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg2884.Num 		:= 2884;
	xMsg2884.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2884.AmmOutAdr	:= iAdrMM2AmmBase;			

	xMsg2885.Num 		:= 2885;
	xMsg2885.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2885.AmmOutAdr	:= iAdrMM2AmmBase;			

	xMsg2923.Num 		:= 2923;
	xMsg2923.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2923.AmmOutAdr	:= iAdrMM2AmmBase;			

	xMsg2924.Num 		:= 2924;
	xMsg2924.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2924.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg2971.Num 		:= 2971;
	xMsg2971.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2971.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2974.Num 		:= 2974;
	xMsg2974.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2974.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2977.Num 		:= 2977;
	xMsg2977.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2977.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg2980.Num 		:= 2980;
	xMsg2980.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg2980.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3379.Num 		:= 3379;
	xMsg3379.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3379.AmmOutAdr	:= iAdrMM2AmmBase;	

	xMsg3380.Num 		:= 3380;
	xMsg3380.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3380.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3381.Num 		:= 3381;
	xMsg3381.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3381.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3383.Num 		:= 3383;
	xMsg3383.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3383.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3450.Num 		:= 3450;
	xMsg3450.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3450.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3451.Num 		:= 3451;
	xMsg3451.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3451.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3452.Num 		:= 3452;
	xMsg3452.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3452.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3453.Num 		:= 3453;
	xMsg3453.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3453.AmmOutAdr	:= iAdrMM2AmmBase;			

	xMsg3454.Num 		:= 3454;	
	xMsg3454.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3454.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3455.Num 		:= 3455;
	xMsg3455.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3455.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3456.Num 		:= 3456;
	xMsg3456.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3456.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3457.Num 		:= 3457;
	xMsg3457.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3457.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3458.Num 		:= 3458;
	xMsg3458.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3458.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3459.Num 		:= 3459;
	xMsg3459.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3459.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3460.Num 		:= 3460;
	xMsg3460.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3460.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3461.Num 		:= 3461;
	xMsg3461.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3461.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3462.Num 		:= 3462;
	xMsg3462.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3462.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3463.Num 		:= 3463;
	xMsg3463.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3463.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3464.Num 		:= 3464;
	xMsg3464.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3464.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3465.Num 		:= 3465;
	xMsg3465.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3465.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3466.Num 		:= 3466;
	xMsg3466.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3466.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3467.Num 		:= 3467;
	xMsg3467.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3467.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg3469.Num 		:= 3469;
	xMsg3469.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3469.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3470.Num 		:= 3470;
	xMsg3470.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3470.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3471.Num 		:= 3471;
	xMsg3471.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3471.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3472.Num 		:= 3472;
	xMsg3472.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3472.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3473.Num 		:= 3473;
	xMsg3473.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3473.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3474.Num 		:= 3474;
	xMsg3474.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3474.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3475.Num 		:= 3475;
	xMsg3475.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3475.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3476.Num 		:= 3476;
	xMsg3476.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3476.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3477.Num 		:= 3477;
	xMsg3477.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3477.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3478.Num 		:= 3478;
	xMsg3478.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3478.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3479.Num 		:= 3479;
	xMsg3479.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3479.AmmOutAdr	:= iAdrMM2AmmBase;				
	
	xMsg3480.Num 		:= 3480;
	xMsg3480.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3480.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3481.Num 		:= 3481;
	xMsg3481.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3481.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3482.Num 		:= 3482;
	xMsg3482.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3482.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3483.Num 		:= 3483;
	xMsg3483.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3483.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3484.Num 		:= 3484;
	xMsg3484.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3484.AmmOutAdr	:= iAdrMM2AmmBase;			

	xMsg3485.Num 		:= 3485;
	xMsg3485.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3485.AmmOutAdr	:= iAdrMM2AmmBase;			
	
	xMsg3486.Num 		:= 3486;
	xMsg3486.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3486.AmmOutAdr	:= iAdrMM2AmmBase;			

	xMsg3487.Num 		:= 3487;
	xMsg3487.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3487.AmmOutAdr	:= iAdrMM2AmmBase;			

	xMsg3488.Num 		:= 3488;
	xMsg3488.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3488.AmmOutAdr	:= iAdrMM2AmmBase;			

	xMsg3489.Num 		:= 3489;
	xMsg3489.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg3489.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9077.Num 		:= 9077;
	xMsg9077.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9077.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9079.Num 		:= 9079;
	xMsg9079.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9079.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9080.Num 		:= 9080;
	xMsg9080.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9080.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9081.Num 		:= 9081;
	xMsg9081.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9081.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9082.Num 		:= 9082;
	xMsg9082.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9082.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg9201.Num 		:= 9201;
	xMsg9201.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9201.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9202.Num 		:= 9202;
	xMsg9202.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9202.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9203.Num 		:= 9203;
	xMsg9203.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9203.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9204.Num 		:= 9204;
	xMsg9204.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9204.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9205.Num 		:= 9205;
	xMsg9205.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9205.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9206.Num 		:= 9206;
	xMsg9206.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9206.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9207.Num 		:= 9207;
	xMsg9207.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9207.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9208.Num 		:= 9208;
	xMsg9208.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9208.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9209.Num 		:= 9209;
	xMsg9209.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9209.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9210.Num 		:= 9210;
	xMsg9210.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9210.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9211.Num 		:= 9211;
	xMsg9211.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9211.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9212.Num 		:= 9212;
	xMsg9212.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9212.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9233.Num 		:= 9233;
	xMsg9233.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9233.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9234.Num 		:= 9234;
	xMsg9234.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9234.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9235.Num 		:= 9235;
	xMsg9235.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9235.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9236.Num 		:= 9236;
	xMsg9236.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9236.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9250.Num 		:= 9250;
	xMsg9250.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9250.AmmOutAdr	:= iAdrMM2AmmBase;
	
	xMsg9251.Num 		:= 9251;
	xMsg9251.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9251.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9252.Num 		:= 9252;
	xMsg9252.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9252.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9277.Num 		:= 9277;
	xMsg9277.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9277.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9278.Num 		:= 9278;
	xMsg9278.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9278.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9379.Num 		:= 9379;
	xMsg9379.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9379.AmmOutAdr	:= iAdrMM2AmmBase;

	xMsg9380.Num 		:= 9380;
	xMsg9380.AmmInAdr	:= iAdrAmmBase2MM;
	xMsg9380.AmmOutAdr	:= iAdrMM2AmmBase;
END_PROGRAM