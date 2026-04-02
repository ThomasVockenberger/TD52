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
		
	iAdrAmmBase2MM		:=  ADR(IN_SY.tAB2SY);
	iAdrMM2AmmBase		:=  ADR(OUT_SY.tSY2AB);
		
	(*---------------------------------------------------------------------------*)
	xMsg1039.Num		:=  1039;
	xMsg1039.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1039.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1041.Num		:=  1041;
	xMsg1041.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1041.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1042.Num		:=  1042;
	xMsg1042.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1042.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1109.Num		:=  1109;
	xMsg1109.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1109.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1175.Num		:=  1175;
	xMsg1175.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1175.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1189.Num		:=  1189;
	xMsg1189.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1189.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1209.Num		:=  1209;
	xMsg1209.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1209.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1210.Num		:=  1210;
	xMsg1210.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1210.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1211.Num		:=  1211;
	xMsg1211.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1211.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1212.Num		:=  1212;
	xMsg1212.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1212.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1213.Num		:=  1213;
	xMsg1213.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1213.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg1214.Num		:=  1214;
	xMsg1214.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1214.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1216.Num		:=  1216;
	xMsg1216.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1216.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1217.Num		:=  1217;
	xMsg1217.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1217.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1218.Num		:=  1218;
	xMsg1218.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1218.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1219.Num		:=  1219;
	xMsg1219.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1219.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1220.Num		:=  1220;
	xMsg1220.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1220.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1221.Num		:=  1221;	
	xMsg1221.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1221.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg1222.Num		:=  1222;
	xMsg1222.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1222.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1235.Num		:=	1235;
	xMsg1235.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1235.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1236.Num		:=	1236;
	xMsg1236.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1236.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2139.Num		:=	2139;
	xMsg2139.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2139.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2330.Num		:=	2330;
	xMsg2330.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2330.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2354.Num		:=	2354;
	xMsg2354.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2354.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2366.Num		:=	2366;
	xMsg2366.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2366.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2688.Num		:=	2688;
	xMsg2688.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2688.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2692.Num		:=	2692;
	xMsg2692.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2692.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg2693.Num		:=	2693;
	xMsg2693.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2693.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2730.Num		:=	2730;
	xMsg2730.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2730.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2801.Num		:=  2801;
	xMsg2801.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2801.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2901.Num		:=  2901;
	xMsg2901.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2901.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2902.Num		:=  2902;
	xMsg2902.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2902.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2903.Num		:=  2903;
	xMsg2903.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2903.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2934.Num		:=  2934;
	xMsg2934.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2934.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3253.Num		:=  3253;
	xMsg3253.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3253.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3254.Num		:=  3254;
	xMsg3254.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3254.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3263.Num		:=  3263;
	xMsg3263.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3263.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3264.Num		:=  3264;
	xMsg3264.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3264.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3265.Num		:=  3265;
	xMsg3265.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3265.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3266.Num		:=  3266;
	xMsg3266.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3266.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3267.Num		:=  3267;
	xMsg3267.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3267.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3269.Num		:=  3269;
	xMsg3269.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3269.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3296.Num		:=  3296;
	xMsg3296.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3296.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3297.Num		:=  3297;
	xMsg3297.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3297.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3329.Num		:=  3329;
	xMsg3329.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3329.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3352.Num		:=  3352;
	xMsg3352.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3352.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3400.Num		:=  3400;
	xMsg3400.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3400.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3412.Num		:=  3412;
	xMsg3412.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3412.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3575.Num		:=  3575;
	xMsg3575.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3575.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3576.Num		:=  3576;
	xMsg3576.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3576.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3577.Num		:=  3577;
	xMsg3577.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3577.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9244.Num		:=  9244;
	xMsg9244.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9244.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9245.Num		:=  9245;
	xMsg9245.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9245.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9304.Num		:=  9304;
	xMsg9304.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9304.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9331.Num		:=  9331;
	xMsg9331.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9331.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9083.Num		:=  9083;
	xMsg9083.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9083.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9084.Num		:=  9084;
	xMsg9084.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9084.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9085.Num		:=  9085;
	xMsg9085.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9085.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9382.Num		:=  9382;
	xMsg9382.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9382.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9383.Num		:=  9383;
	xMsg9383.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9383.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	(* template
	xMsg.Num		:=	;
	xMsg.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg.AmmOutAdr	:=  iAdrMM2AmmBase;
	*)
END_PROGRAM

