(*******************************************************************************
default		value set

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0	19.10.2012	Graus,		new
V4.00.0 11.02.2014 	Graus,		change Version TO 4.0
V4.00.0 17.11.2016 	Gwiggner,	change Version TO 4.04
		02.02.2017	lettenb.	OUT_OP.bEng_Bloc: ...FC_Rdy included(sky)
V4.07.0 03.12.2018	lettenb.	tScavVaClosed added, bugfix for option N2 scavenging without scav.flap
V4.10.0 03.08.2020	lettenb.	tScavFanCB_trip, tGenIF_CB_On added	
																																	
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	IN_OP.tRel_MasCtr.Di		:=	IN_OP.tRel_MasCtr.Di		OR	NOT IN_OP.tRel_MasCtr.GoodQual;

	IN_OP.tScavFanFC_Rdy.Di		:=	IN_OP.tScavFanFC_Rdy.Di		OR	NOT IN_OP.tScavFanFC_Rdy.GoodQual;
	IN_OP.tECWP_FC_Rdy.Di		:=	IN_OP.tECWP_FC_Rdy.Di		OR	NOT IN_OP.tECWP_FC_Rdy.GoodQual;
	IN_OP.tEOP_FC_Rdy.Di		:=	IN_OP.tEOP_FC_Rdy.Di		OR	NOT IN_OP.tEOP_FC_Rdy.GoodQual;
	IN_OP.tBbBlower_FC_Rdy.Di	:=	IN_OP.tBbBlower_FC_Rdy.Di	OR	NOT IN_OP.tBbBlower_FC_Rdy.GoodQual;
	IN_OP.tScavVaClosed.Di		:=	IN_OP.tScavVaClosed.Di		OR	NOT IN_OP.tScavVaClosed.GoodQual;
	IN_OP.tScavFanCB_trip.Di	:=	IN_OP.tScavFanCB_trip.Di	OR	NOT	IN_OP.tScavFanCB_trip.GoodQual;
	IN_OP.tGenIF_CB_On.Di		:=	IN_OP.tGenIF_CB_On.Di		OR	NOT	IN_OP.tGenIF_CB_On.GoodQual;
	IN_OP.tECWP_CB_On.Di		:=	IN_OP.tECWP_CB_On.Di		OR	NOT	IN_OP.tECWP_CB_On.GoodQual;

END_PROGRAM
