(*******************************************************************************
AGGR: intiate CAN communication (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.1	31-08-2001	Fahringer, generated from caninit.c V0.2
		31-08-2001	Fahringer, last modification	
V0.21	14-10-2003	Weitzer,   transfer all CAN and CMS FUBs to caninit task
V0.40	14-02-2007  Weitzer,   change to new standard IF (SL1.SS1.IF2)
							   delete MMD (multimeasure device)
V0.50	07-09-2007	Weitzer,   SAFI added
							   main FUB´s moved to canmain program
V0.60	23-02-2010	Weitzer,   SAFI2 (prot injection) added								   
							   
Instructions for use:
--------------------
-initiate the CAN-Bus communictation controller
-initiate CAN CMS manager

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	IF IN_MO.iCANIdent <>  0  AND NOT bInitOK THEN		(* check if CAN open was successful *)
	
		(*initiate CMS manager Monic *)
		CMSMonic_Init(enable:=1, us_ident:=IN_MO.iCANIdent, user_type:=0, queue_cnt:=0, modul_name:=ADR('cmsmonic'));
		(* initiate CMS main function for send and receive Monic CAN messages *)
		CMSmain_Monic.enable    := TRUE;
		CMSmain_Monic.cms_ident := CMSMonic_Init.cms_ident;
		CMSmain_Monic.cms_mode  := 2;
				
		IF CMSMonic_Init.status = 0 THEN
			bInitOK := TRUE;
		END_IF
	END_IF
	
	(* cyclic call of CAN devices  *)
	IF monic_vis AND IN_MO.iCANIdent <>  0 AND bInitOK THEN		(* check if CAN open was successful *)
		CMSmain_Monic;			(* call Monic *)
	END_IF
		
END_PROGRAM
