(*******************************************************************************
vis_SY			visualization

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V3.90.0	17.10.2012	lettenb.	new
V3.99.0	04.03.2013	lettenb.	new version
V4.07.0	11.10.2018	lettenb.	DI/DO dataitems for diagnosis added
 		25.04.2019	lettenb.	dataitem changed IN_SY.tGCB_DVM.Di, bugfix
		01.10.2020	lettenb.	MM2VIS.bDSyMCB, mcb controlled by customer, bugfix(heim, Referenzanlage AB85), bu
V4.12.0	14.09.2022	lettenb.	MM2VIS.bDemGenExcOff, MM2VIS.bGenExcOff added, dead bb synch
V4.13.0	29.11.2023	Goenczi		bGCB_OGP_Bus other genset paralell bit via bus

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	MM2VIS.bMnsOk			:=		OUT_SY.bMnsOk;		(* mains ok *)
	MM2VIS.bNotMainsReturn	:=	NOT	bMainsReturn;		(* not mains return *) 

	MM2VIS.bGCB_On			:=		IN_SY.tGCB_On.Di;	(* gcb closed for report time measuring *)
	MM2VIS.bGCB_GnlWarning	:=		bGCB_GnlWarning;	(* gcb general failure *)
	MM2VIS.bDSyGCB			:=		gcb.dmnd_sy;		(* gcb demand synchronization *)

	MM2VIS.bMCB_On			:=		OUT_SY.bMCB_On;		(* mcb closed for report time measuring *)
	MM2VIS.bMCB_GnlWarning	:=		bMCB_GnlWarning;	(* mcb general failure *)
	MM2VIS.bDSyMCB			:=		mcb.dmnd_sy AND Para.bMCB_Enable;	(* mcb demand synchronization *)

	MM2VIS.bEngDemIsland 	:=		IN_SY.tEngDemIsland.Di;	(* DI engine demand for island operation *)
	MM2VIS.bOnly_Island		:=		IN_SY.tOnly_Island.Di;	(* DI only island operation *)
	MM2VIS.bGCB_MDL			:=		IN_SY.tGCB_MDL.Di;		(* DI generator circuit breaker master demand lock (for closing other GCB to dead BB) *)
	MM2VIS.bGCB_MRC			:=		IN_SY.tGCB_MRC.Di;		(* DI generator circuit breaker master release close (to dead busbar) *)
	MM2VIS.bGCB_AGO			:=		IN_SY.tGCB_AGO.Di;		(* DI all other generator circuit breaker off *)
	MM2VIS.bGCB_RI			:=		IN_SY.tGCB_RI.Di;		(* DI generator circuit breaker reelase island *)
	MM2VIS.bGCB_OGP			:=		IN_SY.tGCB_OGP.Di OR IN_SY.bGCB_OGP_Bus;		(* DI generator circuit breaker other generator parallel *)
	MM2VIS.bGCB_DVM			:=		IN_SY.tGCB_DVM.Di;		(* DI voltage matching for synchronization *)
	MM2VIS.bGCB_DSY			:=		IN_SY.tGCB_DSY.Di;		(* DI generator circuit breaker demand synchronization (synchline) *)
//	MM2VIS.bF_N_DI_Inc		:=		IN_OP.tF_N_DI_Inc.Di;	(* DI synch.increase speed *)
//	MM2VIS.bF_N_DI_Dec		:=		IN_OP.tF_N_DI_Dec.Di;	(* DI synch.decrease speed *)
//	MM2VIS.bU_Gen_Inc		:=		IN_GC.tU_Gen_Inc.Di;	(* DI voltage adjustment external (increasing)*)
//	MM2VIS.bU_Gen_Dec		:=		IN_GC.tU_Gen_Dec.Di;	(* DI voltage adjustment external (decreasing)*)

	MM2VIS.bRdy_MSy			:=		OUT_SY.tRdy_MSy.Do;		(* DO engine ready    for MSY/GSY *)
	MM2VIS.bEng_Run_Sy		:=		OUT_SY.tEng_Run_Sy.Do;	(* DO engine rotating for MSY/GSY *)
	MM2VIS.bEng_Dem			:=		OUT_SY.tEng_Dem.Do;		(* DO engine demanded for MSY/GSY *)
	MM2VIS.bGCB_OpF			:=		OUT_SY.tGCB_OpF.Do;		(* DO alarm gcb opening failure *)
	MM2VIS.bGCB_EDC			:=		OUT_SY.tGCB_EDC.Do;		(* DO ESY demand lock all other cb's connected to dead busbar *)
	MM2VIS.bGCB_ESL			:=		OUT_SY.tGCB_ESL.Do;		(* DO ESY status gcb locked *)

//	MM2VIS.bImp_OpHour  	:= 		OUT_OP.tImp_OpHour.Do;	(* DO Impulse for operation hour counter *)
//	MM2VIS.bEng_Rdy_Rem 	:= 		OUT_OP.tEng_Rdy_Rem.Do;	(* DO Ready for Remote Operation *)
//	MM2VIS.bEng_Run 		:=		OUT_OP.tEng_Run.Do;		(* DO Engine in operation*)

	MM2VIS.bDemGenExcOff	:=		IN_SY.tDemGenExcOff.Di;	(* DI demand generator excitation off*)
	MM2VIS.bGenExcOff		:=		OUT_SY.tGenExcOff.Do;	(* DO generator excitation off*)

END_PROGRAM
