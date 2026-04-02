(*******************************************************************************
Msg_AB	 			 alarms generation 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new
V3.99.0	07.03.2013	lettenb.	cleanup
V4.13.0	04.12.2023	Bencze		Risk Class 10 for remote reset of safety trips 

														
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
		
	iAdrAmmBase2MM		:=  ADR(tAB2MM);//ADR(OUT_AB.tAB2MM);
	iAdrMM2AmmBase		:=  ADR(tMM2AB);//ADR(IN_AB.tMM2AB);
		
	(*---------------------------------------------------------------------------*)

	xMsg1239.Num		:=	1239;
	xMsg1239.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1239.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1240.Num		:=	1240;
	xMsg1240.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1240.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1253.Num		:=	1253;
	xMsg1253.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1253.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1254.Num		:=	1254;
	xMsg1254.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1254.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg1256.Num		:=	1256;
	xMsg1256.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg1256.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3252.Num		:=	3252;
	xMsg3252.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3252.AmmOutAdr	:=  iAdrMM2AmmBase;

	xMsg3003.Num		:=	3003;
	xMsg3003.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3003.AmmOutAdr	:=  iAdrMM2AmmBase;

	(* W9389 Remote acknowledgement not possible, too many or safety trip *)
	xMsg9389.Num		:=	9389;
	xMsg9389.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9389.AmmOutAdr	:=  iAdrMM2AmmBase;
	
	(* template
	xMsg.Num		:=	;
	xMsg.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg.AmmOutAdr	:=  iAdrMM2AmmBase;
	*)
		
END_PROGRAM

