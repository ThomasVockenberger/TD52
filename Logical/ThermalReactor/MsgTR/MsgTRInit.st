(*******************************************************************************
Msg_TR	 			 alarms generation MM_Thermal Reactor

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2020

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	01.11.2013	denk/ganguly	new

														
Instructions for use:
--------------------
1) declare alarm with function block "Msg"

2) use template to create a new alarm, substitue 0000 by message number:

	xMsg0000.Num		:=	0000;					alarm number
	xMsg0000.AmmInAdr	:=  iAdrAmmBase2MM;			do not change
	xMsg0000.AmmOutAdr	:=  iAdrMM2AmmBase;			do not change

3) 	set alarm number
	

			
Outstandings:
------------
(*******************************************************************************)
PROGRAM _INIT
	
	iAdrAmmBase2MM		:=  ADR(IN_TR.tAB2TR);
	iAdrMM2AmmBase		:=  ADR(OUT_TR.tTR2AB);
	
	(*******************************************************************************)
	
	xMsg2356.Num		:=	2356;
	xMsg2356.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2356.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2357.Num		:=	2357;
	xMsg2357.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2357.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg2358.Num		:=	2358;
	xMsg2358.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2358.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3306.Num		:=	3306;
	xMsg3306.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3306.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3307.Num		:=	3307;
	xMsg3307.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3307.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3498.Num		:=	3498;
	xMsg3498.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3498.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9501.Num		:=	9501;
	xMsg9501.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9501.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9502.Num		:=	9502;
	xMsg9502.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9502.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3499.Num		:=	3499;
	xMsg3499.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3499.AmmOutAdr	:=  iAdrMM2AmmBase;
		
	xMsg3500.Num		:=	3500;
	xMsg3500.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3500.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3501.Num		:=	3501;
	xMsg3501.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3501.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3502.Num		:=	3502;
	xMsg3502.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3502.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3503.Num		:=	3503;
	xMsg3503.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3503.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3504.Num		:=	3504;
	xMsg3504.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3504.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg3505.Num		:=	3505;
	xMsg3505.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3505.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9374.Num		:=	9374;
	xMsg9374.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9374.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9375.Num		:=	9375;
	xMsg9375.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9375.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9376.Num		:=	9376;
	xMsg9376.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9376.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9377.Num		:=	9377;
	xMsg9377.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9377.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9381.Num		:=	9381;
	xMsg9381.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9381.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9396.Num		:=	9396;
	xMsg9396.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9396.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg9397.Num		:=	9397;
	xMsg9397.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9397.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9398.Num		:=	9398;
	xMsg9398.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9398.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9503.Num		:=	9503;
	xMsg9503.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9503.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9500.Num		:=	9500;
	xMsg9500.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9500.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9504.Num		:=	9504;
	xMsg9504.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9504.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9505.Num		:=	9505;
	xMsg9505.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9505.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9309.Num		:=  9309;
	xMsg9309.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9309.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9042.Num		:=  9042;
	xMsg9042.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9042.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	xMsg9043.Num		:=  9043;
	xMsg9043.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9043.AmmOutAdr	:=  iAdrMM2AmmBase;
	
END_PROGRAM

