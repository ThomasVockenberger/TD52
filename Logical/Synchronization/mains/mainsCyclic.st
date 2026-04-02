(*******************************************************************************
mains 			mains ok detection for sy-control

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V1.10	12.01.2006	lettenb.	new
V1.11	16.03.2006	lettenb.	scb[1].on/off replaced with tie_on/off 
V2.12	24.04.2006	LH			adapted for esy new
		11.11.2006	LH			revised after Para.bMSy test
V2.60.0	08.10.2009  lettenb.	ton_bb_dead: all_mcb_off     -> NOT any_mcb_on 
										  	  all_gcb_off_bb -> NOT any_gcb_on_bb 
								(->reset bb_dead with cb.on, 
								hold gcb.command_on until cb=closed (gcb.aut_on2dead_bb))
V3.90.0	14.09.2011	lettenb.	Para.tiMainsOkDelay as parameter
V4.03.0	22.07.2015				OUT_SY.bRelMainsConnect new, dyn.gridcode III(thaler)
		25.07.2015  Plattner	OUT_SY.tMCB_COf_GCB_OpF.Do added, for opening MCB in CASE OF openingfailure GCB after set time in parameters
		30.09.2015  Plattner	OUT_SY.tParallel_Op.Do and OUT_SY.tIsland_Op.Do added for feedback
V4.04.0	22.07.2015	lettenb.	OUT_SY.tLockEng_ClosCond.Do new, bBB_ClosCond_Ok logic chnaged, dyn.gridcode III(thaler)
		07.10.2016				bBB_ClosCond_Ok logic changed acc.kiel validation
V4.05.0	28.12.2017	lettenb.	ssBusVoltPh -> tU_Bus_L, mapping cleanup
        03.01.2018              bBB_AfMnsF_ClosCond_Ok added, grid code logic(thaler)
		09.02.2018				bBBClosCond_Fault: xOpMode.NetP -> tGCB_On.Di(thaler)
V4.05.1 11.04.2018	lettenb.	trig_plc_on added, reset ton_mns_ok to avoid 1175 mains failure + 1189 at plc startup
V4.10.0 15.10.2020	lettenb.	ton_mns_ok: MIF only active, when island is not released, bugfix
V4.12.0 09.12.2022	lettenb.	bBBClosCond_Fault: closing conditions ignored when param.#14136 = FALSE, #921
V4.13.0	20.11.2023	Farre,		added IN_SY.bBypassMCB_deadBB interface from CU needed for Microgrid (2023-168)
		29.11.2023	Goenczi		bMainsReturn condition - take over Aggreko condition to standard
							
Instructions for use:
--------------------

Outstandings:
------------
locking first switch on all cb's
*******************************************************************************)
PROGRAM _CYCLIC
		
	IF	Para.bSyActive	THEN
		(*----------------------------------------------------------------------------*)
		(* busbar dead (OUT_SY.bBB_dead) *)
		xTON_BB_Dead(IN:= NOT bb_alive AND (IN_SY.bBypassMCB_deadBB OR NOT mcb.on) AND NOT any_gcb_on_bb, PT:= T#2s);
		bb_dead		:=	xTON_BB_Dead.Q;
		
		
		(*----------------------------------------------------------------------------*)
		(* micro interruption filter (KU-filter) *)
		tof_mns_ok(IN:=	mains.ok, PT:= Para.tiMIF);				(* micro interruption filter time *)
		
		(* mains return (OUT_SY.bMainsReturn) *)
		IF	Para.bMIF_Enable AND NOT IN_SY.tGCB_RI.Di THEN
			ton_mns_ok(IN := tof_mns_ok.Q, PT:= Para.tiMainsOkDelay);	(* micro interruption filter     active *)
		ELSE
			ton_mns_ok(IN := mains.ok,     PT:= Para.tiMainsOkDelay);	(* micro interruption filter not active *)
		END_IF;

		
		IF	ton_mns_ok.IN AND NOT ton_mns_ok.Q	THEN				(* countdown *)
			mains.return_rest_time := TIME_TO_DINT(ton_mns_ok.PT - ton_mns_ok.ET);
		ELSE
			mains.return_rest_time := 0;
		END_IF;

		trig_mcb_on(CLK:=	mcb.on);
		trig_sss_man(CLK:=	NOT	bSyOMSS_Aut);
		trig_plc_on(CLK:=   mains.ok AND IN_SY.tPB2MM.bSys_Run AND NOT IN_SY.tPB2MM.bParaSetupOk);(* reset at plc startup *)
		
		IF	trig_mcb_on.Q OR trig_sss_man.Q	OR trig_plc_on.Q THEN
			ton_mns_ok(IN:=	TRUE, PT:= T#0s); 		// PT_zero;		(* reset delay time *)
		END_IF;
		
		bMainsReturn	:=	ton_mns_ok.Q OR (mains.ok AND IN_SY.bSetFixedPwrMode AND IN_SY.tEng_Run.Do);

		
		(*----------------------------------------------------------------------------*)
		(* pulse mains ok (T_NE_OK) *)
		tp_p_mns_ok(IN:= ton_p_mns_ok.Q, PT:= T#100ms);
		ton_p_mns_ok(IN:= NOT mains.ok AND NOT tp_p_mns_ok.Q, PT:= T#2s);
		
		OUT_SY.tPulseMainsOk.Do :=  tp_p_mns_ok.Q;
		
		
		(*----------------------------------------------------------------------------*)
		(* synch line pulse *)
		ton_sy_line_of(IN:= (gcb.dmnd_sy OR mcb.dmnd_sy) AND NOT ton_sy_line_on.Q, PT:= T#120s);
		ton_sy_line_on(IN:= (gcb.dmnd_sy OR mcb.dmnd_sy) AND     ton_sy_line_of.Q, PT:= T#120s);
		
		pulse_sy_line	  := ton_sy_line_of.Q;
		
		
		(*----------------------------------------------------------------------------*)
		
		
	END_IF;
	
	(*----------------------------------------------------------------------------*)
	(* Closing conditions for busbar - GRID Code III *)
	(*----------------------------------------------------------------------------*)
	(* Boundary conditions for busbar - norm voltage and frequency *)
	IF 	    (IN_SY.tU_Bus_L1_2[1].Ai >= (Para.rU_BusNom[1]*(Para.rU_BB_ClosCond_LimLo_Norm + Para.rU_BB_ClosCond_Hy_Norm))) 
		AND (IN_SY.tU_Bus_L2_3[1].Ai >= (Para.rU_BusNom[1]*(Para.rU_BB_ClosCond_LimLo_Norm + Para.rU_BB_ClosCond_Hy_Norm)))
		AND (IN_SY.tU_Bus_L3_1[1].Ai >= (Para.rU_BusNom[1]*(Para.rU_BB_ClosCond_LimLo_Norm + Para.rU_BB_ClosCond_Hy_Norm)))
		
		AND (IN_SY.tU_Bus_L1_2[1].Ai <= (Para.rU_BusNom[1]*(Para.rU_BB_ClosCond_LimHi_Norm - Para.rU_BB_ClosCond_Hy_Norm)))
		AND (IN_SY.tU_Bus_L2_3[1].Ai <= (Para.rU_BusNom[1]*(Para.rU_BB_ClosCond_LimHi_Norm - Para.rU_BB_ClosCond_Hy_Norm)))
		AND (IN_SY.tU_Bus_L3_1[1].Ai <= (Para.rU_BusNom[1]*(Para.rU_BB_ClosCond_LimHi_Norm - Para.rU_BB_ClosCond_Hy_Norm))) THEN
			
			bU_BB_ClosCond := TRUE;		
	
	ELSIF  (IN_SY.tU_Bus_L1_2[1].Ai > (Para.rU_BusNom[1]*Para.rU_BB_ClosCond_LimHi_Norm))
		OR (IN_SY.tU_Bus_L2_3[1].Ai > (Para.rU_BusNom[1]*Para.rU_BB_ClosCond_LimHi_Norm))
		OR (IN_SY.tU_Bus_L3_1[1].Ai > (Para.rU_BusNom[1]*Para.rU_BB_ClosCond_LimHi_Norm))
		
		OR (IN_SY.tU_Bus_L1_2[1].Ai < (Para.rU_BusNom[1]*Para.rU_BB_ClosCond_LimLo_Norm))
		OR (IN_SY.tU_Bus_L2_3[1].Ai < (Para.rU_BusNom[1]*Para.rU_BB_ClosCond_LimLo_Norm))
		OR (IN_SY.tU_Bus_L3_1[1].Ai < (Para.rU_BusNom[1]*Para.rU_BB_ClosCond_LimLo_Norm)) THEN
		
			bU_BB_ClosCond := FALSE;
		
	END_IF;
	
	bBB_ClosCond_Ok := (IN_SY.tMnsOk_ClosCond_Ok.Di 
			 	AND NOT(Para.bBB_ClosCondLimits_Active AND NOT IN_SY.tMnsOk_ClosCond_Skip.Di))         
		    OR (       (Para.bBB_ClosCondLimits_Active AND NOT IN_SY.tMnsOk_ClosCond_Skip.Di)
				 	AND IN_SY.tMnsOk_ClosCond_Ok.Di 
				 	AND bU_BB_ClosCond 
				 	AND bF_BB_ClosCond);

											
	(* Boundary conditions for busbar after mains failure - norm voltage and frequency *)
	IF 	    (IN_SY.tU_Bus_L1_2[1].Ai >= (Para.rU_BusNom[1]*(Para.rU_BB_AfMnsF_ClosCond_LimLo_Norm + Para.rU_BB_AfMnsF_ClosCond_Hy_Norm))) 
		AND (IN_SY.tU_Bus_L2_3[1].Ai >= (Para.rU_BusNom[1]*(Para.rU_BB_AfMnsF_ClosCond_LimLo_Norm + Para.rU_BB_AfMnsF_ClosCond_Hy_Norm)))
		AND (IN_SY.tU_Bus_L3_1[1].Ai >= (Para.rU_BusNom[1]*(Para.rU_BB_AfMnsF_ClosCond_LimLo_Norm + Para.rU_BB_AfMnsF_ClosCond_Hy_Norm)))
		
		AND (IN_SY.tU_Bus_L1_2[1].Ai <= (Para.rU_BusNom[1]*(Para.rU_BB_AfMnsF_ClosCond_LimHi_Norm - Para.rU_BB_AfMnsF_ClosCond_Hy_Norm)))
		AND (IN_SY.tU_Bus_L2_3[1].Ai <= (Para.rU_BusNom[1]*(Para.rU_BB_AfMnsF_ClosCond_LimHi_Norm - Para.rU_BB_AfMnsF_ClosCond_Hy_Norm)))
		AND (IN_SY.tU_Bus_L3_1[1].Ai <= (Para.rU_BusNom[1]*(Para.rU_BB_AfMnsF_ClosCond_LimHi_Norm - Para.rU_BB_AfMnsF_ClosCond_Hy_Norm))) THEN
			
			bU_BB_AfMnsF_ClosCond := TRUE;		
	
	ELSIF  (IN_SY.tU_Bus_L1_2[1].Ai > (Para.rU_BusNom[1]*Para.rU_BB_AfMnsF_ClosCond_LimHi_Norm))
		OR (IN_SY.tU_Bus_L2_3[1].Ai > (Para.rU_BusNom[1]*Para.rU_BB_AfMnsF_ClosCond_LimHi_Norm))
		OR (IN_SY.tU_Bus_L3_1[1].Ai > (Para.rU_BusNom[1]*Para.rU_BB_AfMnsF_ClosCond_LimHi_Norm))
		
		OR (IN_SY.tU_Bus_L1_2[1].Ai < (Para.rU_BusNom[1]*Para.rU_BB_AfMnsF_ClosCond_LimLo_Norm))
		OR (IN_SY.tU_Bus_L2_3[1].Ai < (Para.rU_BusNom[1]*Para.rU_BB_AfMnsF_ClosCond_LimLo_Norm))
		OR (IN_SY.tU_Bus_L3_1[1].Ai < (Para.rU_BusNom[1]*Para.rU_BB_AfMnsF_ClosCond_LimLo_Norm)) THEN
		
			bU_BB_AfMnsF_ClosCond := FALSE;
		
	END_IF;
	
	bBB_AfMnsF_ClosCond_Ok :=  (IN_SY.tAfMnsF_ClosCond_Ok.Di 
					 	AND NOT(Para.bBB_AfMnsF_ClosCondLimits_Active AND NOT IN_SY.tAfMnsF_ClosCond_Skip.Di))         
				    OR (       (Para.bBB_AfMnsF_ClosCondLimits_Active AND NOT IN_SY.tAfMnsF_ClosCond_Skip.Di)
						 	AND IN_SY.tAfMnsF_ClosCond_Ok.Di 
						 	AND bU_BB_AfMnsF_ClosCond 
						 	AND bF_BB_AfMnsF_ClosCond);
	
	(*----------------------------------------------------------------------------*)
	(* Delay time conditions *)
	IF Para.bBB_AfMnsF_ClosCondLimits_Active THEN
		IF NOT IN_SY.tMnsOk.Di THEN 
			bBBClosCond_Fault := TRUE;		(* status after mains failure ON *)
		ELSIF IN_SY.tGCB_On.Di THEN
			bBBClosCond_Fault := FALSE;		(* status after mains failure OFF *)
		END_IF;
	ELSE
		bBBClosCond_Fault := FALSE;
	END_IF;

	(* closing conditions mains ok (A) *)
	xTON_ClosCond(IN:= bBB_ClosCond_Ok, PT:= Para.tiBB_ClosCond_Delay);
	bAMM_ClosCond_Ok := xTON_ClosCond.Q; 
	OUT_SY.tClosCond.Do	:= bAMM_ClosCond_Ok;
	
	(* closing conditions after mains failure (B) *)
	xTON_AfMnsF_ClosCond(IN:= bBB_AfMnsF_ClosCond_Ok, PT:= Para.tiBB_ClosCondAftMnsFail_Delay);
	bAMM_AfMnsF_ClosCond_Ok := xTON_AfMnsF_ClosCond.Q;
	OUT_SY.tAfMnsF_ClosCond.Do := bAMM_AfMnsF_ClosCond_Ok;
	
	OUT_SY.bRelMainsConnect	:= (NOT bBBClosCond_Fault AND bAMM_ClosCond_Ok)
							OR (	bBBClosCond_Fault AND bAMM_AfMnsF_ClosCond_Ok);
	

	(*----------------------------------------------------------------------------*)
	(* BEL Standard *)
	(* opens MCB in case of GCB opening failure *)
	xTON_MCB_COf_GCB_OpF(IN:= NOT IN_SY.tGCB_Off.Di AND IN_SY.tMCB_On.Di AND MM2VIS.bMsg1218, PT:= Para.tiMCB_COf_GCB_OpF);
	
	OUT_SY.tMCB_COf_GCB_OpF.Do 	:= xTON_MCB_COf_GCB_OpF.Q;
	(*----------------------------------------------------------------------------*)

	(*----------------------------------------------------------------------------*)
	(* BEL Standard *)
	(* Feedback mains parallel operation *)
	OUT_SY.tParallel_Op.Do := IN_SY.tMCB_On.Di AND IN_SY.tGCB_On.Di;
	
	(* Feedback Island operation *)
	OUT_SY.tIsland_Op.Do := NOT IN_SY.tMCB_On.Di AND IN_SY.tGCB_On.Di AND NOT IN_SY.bEng_Dem_EPS;
	
	(* Feedback emergency operation *)
	OUT_SY.tIsland_Op.Do := NOT IN_SY.tMCB_On.Di AND IN_SY.tGCB_On.Di AND IN_SY.bEng_Dem_EPS;
	(*----------------------------------------------------------------------------*)


END_PROGRAM
