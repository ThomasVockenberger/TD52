(*******************************************************************************
Coupling:    computer link control

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	17.07.2012	froehlichw	new
V4.04.0 09.03.2017	Denk 		init part, ucTeiler := 0
V4.07.0 26.03.2019	Denk 		ucTeiler variable assignment with Para.iComm_MB_Factor

Instructions for use:
--------------------
check link type and enable data receive.

Outstandings:
------------

(*******************************************************************************)

PROGRAM _CYCLIC

	(*--------------------------------------------------------------------*)
	(* link 1: release data receive from parameter *)
	bKopl1EmpfFrg:= Para.bComm1_Ena;
	               (*0 = not released
	                 1 = released *)
	(*--------------------------------------------------------------------*)

	(*--------------------------------------------------------------------*)
	(* link 2: release data receive from parameter *)
	bKopl2EmpfFrg:= Para.bComm2_Ena;
	               (*0 = not released
	                 1 = released *)
	(*--------------------------------------------------------------------*)

	(* check link 1: typ *)
	CASE Para.iIdx_Comm1_type OF
		comNO_LINK,
		comMODBUS_RTU,
		comMODBUS_TCP,
		comPROFIBUS_DP,
		comPROFIBUS_DPold,
		comPROFINET:
			;
		ELSE
			Para.iIdx_Comm1_type:= comNO_LINK;
	END_CASE;
	
	(* check link 2: typ *)
	CASE Para.iIdx_Comm2_type OF
		comNO_LINK,
		comMODBUS_RTU,
		comPROFIBUS_DP,
		comPROFIBUS_DPold,
		comPROFINET: ;

		comMODBUS_TCP: ;
			

		ELSE
			Para.iIdx_Comm2_type:= comNO_LINK;
	END_CASE;
	
	(*------------------------------------------------------------------*)
	(* cycle divider for coupling task *)
	ucTeiler:= INT_TO_USINT(Para.iComm_MB_Factor);

END_PROGRAM
