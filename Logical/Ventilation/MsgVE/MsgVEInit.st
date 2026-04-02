(*******************************************************************************
Msg_VE	 			 alarms generation 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new
V4.06.0	16.07.2018	Perktold,	2968 and 2969 Air inlet/outlet louver status signal failure added

														
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
		
	iAdrAmmBase2MM		:=  ADR(IN_VE.tAB2VE);
	iAdrMM2AmmBase		:=  ADR(OUT_VE.tVE2AB);
		
	(*---------------------------------------------------------------------------*)
	xMsg1135.Num		:=	1135;	
	xMsg1135.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1135.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1138.Num		:=	1138;	
	xMsg1138.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1138.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2120.Num		:=	2120;	
	xMsg2120.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2120.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2295.Num		:=	2295;	
	xMsg2295.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2295.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2296.Num		:=	2296;	
	xMsg2296.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2296.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2472.Num		:=	2472;	
	xMsg2472.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2472.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2630.Num		:=	2630;	
	xMsg2630.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2630.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2701.Num		:=	2701;
	xMsg2701.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2701.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2702.Num		:=	2702;
	xMsg2702.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2702.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2703.Num		:=	2703;
	xMsg2703.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2703.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2704.Num		:=	2704;
	xMsg2704.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2704.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2705.Num		:=	2705;
	xMsg2705.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2705.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2706.Num		:=	2706;
	xMsg2706.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2706.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2707.Num		:=	2707;
	xMsg2707.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2707.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2708.Num		:=	2708;
	xMsg2708.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2708.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2709.Num		:=	2709;
	xMsg2709.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2709.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2795.Num		:=	2795;
	xMsg2795.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2795.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2796.Num		:=	2796;
	xMsg2796.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2796.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2797.Num		:=	2797;
	xMsg2797.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2797.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg2798.Num		:=	2798;
	xMsg2798.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2798.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3152.Num		:=	3152;			
	xMsg3152.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3152.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3223.Num		:=	3223;			
	xMsg3223.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3223.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3224.Num		:=	3224;			
	xMsg3224.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3224.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3302.Num		:=	3302;			
	xMsg3302.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3302.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3367.Num		:=	3367;			
	xMsg3367.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3367.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3571.Num		:=	3571;			
	xMsg3571.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3571.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9401.Num		:=	9401;			
	xMsg9401.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9401.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
(* B2968 Air inlet louver position feedback not plausible *)
	xMsg2968.Num		:=	2968;			
	xMsg2968.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2968.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
(* B2969 Air outlet louver position feedback not plausible *)
	xMsg2969.Num		:=	2969;			
	xMsg2969.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2969.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
//	xMsg0000.Num		:=	0000;			
//	xMsg0000.AmmInAdr	:=  iAdrAmmBase2MM;
//	xMsg0000.AmmOutAdr	:=  iAdrMM2AmmBase;	

END_PROGRAM

