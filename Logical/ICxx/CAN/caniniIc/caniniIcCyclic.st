(*******************************************************************************
AGGR: intiate CAN communication (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V0.1		31-08-2001	Fahringer, generated from caninit.c V0.2
			31-08-2001	Fahringer, last modification	
V0.21		14-10-2003	Weitzer,   transfer all CAN and CMS FUBs to caninit task
V0.40		14-02-2007  Weitzer,   change to new standard IF (SL1.SS1.IF2)
							   	   delete MMD (multimeasure device)
V0.50		07-09-2007	Weitzer,   SAFI added
							       main FUB´s moved to canmain program
V0.60		23-02-2010	Weitzer,   SAFI2 (prot injection) added	
V4.00.03	10-07-2014	Denk,      AND ic900_vis added
V4.00.05	15-07-2015	Weitzer,   move CMS main Fub to SpeedIC task
V4.12.00	08-09-2022	Andre	   Select the engine speed from the ICxx module also if SEMIC is active

Instructions for use:
--------------------
-initiate the CAN-Bus communictation controller
-initiate CAN CMS manager

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	IF IN_IC.iCANIdent <> 0 AND NOT bInitOK AND (ic900_vis OR Para.bSEMIC_Active) THEN	(* check if CAN open was successful *)
	
		(*initiate CMS manager Ignition *)
		CMSIgn_Init(enable:=1, us_ident:=IN_IC.iCANIdent, user_type:=0, queue_cnt:=0, modul_name:=ADR('cmsign'));
		(* initiate CMS main function for send and receive Ignition CAN messages *)
		CMSmain_Ign.enable    := TRUE;
		CMSmain_Ign.cms_ident := CMSIgn_Init.cms_ident;
		CMSmain_Ign.cms_mode  := 2;
		
		IF CMSIgn_Init.status = 0 THEN
			bInitOK := TRUE;
		END_IF
	END_IF
		
	
END_PROGRAM