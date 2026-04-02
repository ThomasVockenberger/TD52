(*******************************************************************************
AGGR: copy OUT PVs for module HalIO (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V3.99	06-03-2013	Weitzer, generated FOR modular software
V4.00	14-02-2014	Weitzer, change version number	
V4.05	21-01-2018	Perktold,hardware operation mode switch added
V4.07	15-05-2019	Zengerer Init call for detection of missing tHA2GR items in init

							   
Instructions for use:
--------------------
-

Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT
	
	(* call to get a addresses for the HalIO Fub of OUT HAL_IO VIS variables *)
	
	PF_Act; 			(* power factor *)		
	I_Avg;				(* current average *)
	P_Act; 				(*  actual electric power [kW] *)		
	Q_Act; 				(* reactive power [kVar] *)
	S_Act; 				(* power apperent *)
	U_MMD_Synch1; 		(* synchronization voltage 1 *)
	U_MMD_Synch2; 		(* synchronization voltage 2 *) 		
	U_Avg; 				(* voltage average *)
	U_L1N; 				(* voltage 1 *)
	U_L1L2;				(* voltage 12 *)
	U_L2N; 				(* voltage 2 *)
	U_L2L3; 			(* voltage 23 *)
	U_L3N; 				(* voltage 3 *)
	U_L3L1;				(* voltage 31 *)
	F_MMD;				(* frequency multi measure device *)
	F_MMD_Synch1; 		(* Frequency Sync-network 1 *)
	F_MMD_Synch2; 		(* Frequency Sync-network 2 *)	
	MMD_FW_Version;		(*program version MMD firmware*)		

	xTON_OMS.PT		:= T#1s; 	(* Delaytime for changing position of HW-switch *)
	xTON_RMS.PT 	:= T#1s;	(* Delaytime for changing position of HW-switch *)
	xTON_SyOMS.PT 	:= T#1s;	(* Delaytime for changing position of HW-switch *)

	(*Init call for detection of missing tHA2GR items *)
	tHA2GR.bCheck_HA2GR ;	
	tHA2GR.tU_Droop.GoodQual ;	

	tHA2CU.tSet_U_Droop_COn.GoodQual ;	
	
END_PROGRAM
