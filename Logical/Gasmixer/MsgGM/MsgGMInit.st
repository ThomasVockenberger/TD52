(*******************************************************************************
Msg_GM	 			 alarms generation MM_GasMixer

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	23.01.2013 	Tinello 	new
														
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
		
	iAdrAmmBase2MM		:= ADR(IN_GM.tAB2GM);
	iAdrMM2AmmBase		:= ADR(OUT_GM.tGM2AB);
		
	(*---------------------------------------------------------------------------*)

	xMsg1083.Num		:= 1083;
	xMsg1083.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg1083.AmmOutAdr	:= iAdrMM2AmmBase;		

	xMsg2086.Num		:= 2086;
	xMsg2086.AmmInAdr	:= iAdrAmmBase2MM;		
	xMsg2086.AmmOutAdr	:= iAdrMM2AmmBase;		
	
END_PROGRAM

