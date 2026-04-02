(*******************************************************************************
sy_in				Switch standard-inputs from DI to internal variables

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V2.12	24.04.2006	LH			adapted for esy new
		31.10.2006	LH			new: general release gcb from Para.bMSy
		11.11.2006	LH			revised after Para.bMSy test
		20.11.2006	LH			revised for final release esy new
V2.20	07.02.2007	LH			adapted for supporting customer mcb
								enable signals from customer at any time
		27.02.2007	LH			simulate AUEB2 for old hardware
V2.30	18.01.2008	LH			adapted for test-bench run
V2.60.0	12.08.2009	lettenb.	ton_ccb_psf added
								gcb[0].IN_SY.bOtherGenParallel added
V3.20.0	30.09.2010	maier (BuR)	IN_SY.tGCB_On.Di changed to bGCB_ON
					maier (BuR)	IN_SY.tGCB_On.Di replaced with IN_SY.tGCB_On.Di
		01.10.2010	maier (BuR) OUT_SY.bMCB_On changed to bMCB_ON
					maier (BuR) IN_SY.tMCB_On.Di replaced with OUT_SY.bMCB_On
V3.90.0	13.11.2012	lettenb.	parts from pb17_en included
V3.99.0	26.02.2013	lettenb.	cleanup	
		19.04.2013				mcb.on, mcb.rdy: Para.bMCB_Enable removed, active for all variants
								mcb.off: OR (NOT Para.bMCB_Enable AND NOT IN_SY.tMCB_Off.GoodQual AND NOT mcb.on) 									
										 added, if only MCB_On.Di exists
		18.07.2013				mains.enable included from setting_SY(task removed)
		21.11.2013				gcb.all_other_gcb_off: bTestBenchModeIsland added
V4.00.0	12.06.2014 lettenb.		changes after bTestBenchModeIsland test
V4.00.1	25.06.2015 lettenb.		rel_mcb_on2d_bb, rel_gcb_on2d_bb: gcb.esl, gcb.edc -> ccb.esl, ccb.edc /bugfix
V4.03.0	01.10.2015 lettenb.		Para.bGCB_MainsCutOff_Active added(reqisition request)
V4.07.0 17.05.2019 lettenb.		version, comment
V4.10.0 15.10.2020 lettenb.		sel_gcb_mains_cut_off: MIF only active, when island is not released, bugfix
V4.13.0 29.11.2023 Goenczi		bGCB_OGP_Bus other genset paralell bit via bus

Instructions for use:
--------------------
Define variants, where marked.

Outstandings:
------------
comment variants
*******************************************************************************)

(*		basic configuration:
		--------------------

	                           mains
	                             |               
	                            mcb 
	                             |      bb      	
	                        +----+---------------+----+
	                             |               |	
	                            gcb             ccb = customer cb(generator)	
	                             |               |	
	                             |               |	
	                             G               G	

---------------------------------------------------------------------------------------------
 		
		V3.40			V3.99		variante:	+MCB			+CCB			GSy
										immer			ESy+Msy  		noSy			AB_Sy
---------------------------------------------------------------------------------------------
immer	DI_GCB_ON_TC1	tGCB_On																
		DI_GCB_OFF		tGCB_Off																	
		DI_GCB_RDY		tGCB_Rdy																																
		DI_GCB_RAC		tGCB_Rac																
		DI_GCB_OL_TC1	tGCB_OL																
		DI_GCB_SM1		tGCB_SM1																
		DI_GCB_SM2		tGCB_SM2																	

		DI_MNS_OK_TC1	tMnsOk																
		DI_MNS_MDF		tMns_MDF			

MCB		DI_MCB_ON_TC1	tMCB_On																
		DI_MCB_OFF		tMCB_Off																				
		DI_MCB_RDY		tMCB_Rdy																				
		DI_MCB_RAC		tMCB_Rac																				
		DI_MCB_OL		tMCB_OL																				
		DI_MCB_REM		tMCB_Rem																				
		DI_MCB_SM		tMCB_SM																				

CCB		DI_C_CB_ON		tC_CB_On																							
		DI_C_CB_OFF		tC_CB_Off																								
		DI_C_CB_EDC		tC_CB_EDC																								
		DI_C_CB_ESL		tC_CB_ESL																								

msy		DI_ENG_DI		tEngDemIsland																	
		DI_ENG_D		IN_SY.bEng_RPSDem;
		DI_GCB_MDL		tGCB_MDL																						
		DI_GCB_MRC		tGCB_MRC																						
		DI_GCB_AGO		tGCB_AGO																						
		DI_GCB_RI		tGCB_RI																						
		DI_GCB_OGP		tGCB_OGP																						
		DI_GCB_DVM		IN_GC.tGCB_DVM	(used in MM_GC)																
		DI_ONLY_ISL		tOnly_Island																					

no msy	DI_REL_I		tRel_I																
		DI_REL_BS		tRel_BS																

AB/SYonsite		
		DI_GCB_DSY		tGCB_DSY																
		SynchNH/L		tF_N_DI_Inc.Di/F_N_DI_Dec.Di															
		DI_u_plus/minus	tU_Adj_Plus.Di/tU_Adj_Minus.Di
						tU_Gen_Inc.Di/tU_Gen_Dec.Di
	
option	DI_DMND_PM		tReq_PowMod	
		LIN_EIN			tLineCB_On														
		F_BLO			tRelEngOpFromGSy
		FRG_RS			tGCB_DRM
						IN_SY.bRelSyFromCU
	
engine	DO_SY_LFG		IN_SY.tRel_Sync_Load.Do;	
		DI_IN_RDY		IN_SY.bEng_Rdy_Aut_Exc;
	
*)
PROGRAM _CYCLIC	
	(*-----------------------------------------------------------------------------*)
	(* reset gcb/mcb on/off button from vis *)
	IF bGCB_MOn THEN VIS2MM.bGCB_MOn := FALSE;	END_IF;
	IF bGCB_MOf THEN VIS2MM.bGCB_MOf := FALSE;	END_IF;

	bGCB_MOn := VIS2MM.bGCB_MOn;
	bGCB_MOf := VIS2MM.bGCB_MOf;

	IF bMCB_MOn THEN VIS2MM.bMCB_MOn := FALSE;	END_IF;
	IF bMCB_MOf THEN VIS2MM.bMCB_MOf := FALSE;	END_IF;

	bMCB_MOn := VIS2MM.bMCB_MOn;
	bMCB_MOf := VIS2MM.bMCB_MOf;


	(*-----------------------------------------------------------------------------*)
	IF	Para.bSyActive	THEN
		IF	IN_SY.tGCB_AGO.Di AND (IN_SY.tGCB_OGP.Di OR IN_SY.bGCB_OGP_Bus) THEN
			IN_SY.tGCB_AGO.Di	:=	FALSE;				(* MSY other gcb on *)
		END_IF;
	END_IF;


	IF	NOT Para.bSyActive	THEN
		gcb.on	:= IN_SY.tGCB_On.Di;					(* for onsite SY *)	
	END_IF;

	
	(*----------------------------------------------------------------------------*)
	(*----------------------------------------------------------------------------*)		
	mains.enable			:=	Para.bMns_Enable	(* enable mains = IN_SY.tMnsOk.Di existing*)
							OR	Para.bMSy
							OR	Para.bMCB_Ctr_Cust
							OR	OUT_SY.bTestBenchModeParallel;	
	
	sel_gcb_mains_cut_off	:= (Para.bBS_OnlyMan OR	(Para.bMIF_Enable AND NOT IN_SY.tGCB_RI.Di) OR Para.bGCB_MainsCutOff_Active) 
						AND NOT Para.bMSy;


	(*----------------------------------------------------------------------------*)

	IF	Para.bSyActive	THEN
	
		(* general -------------------------------------------------------------------*)
		bb_alive	:=      IN_SY.tBB_Alive.Di	(* busbar alive = voltage high *)
					OR (NOT IN_SY.tBB_Dead_MMD[1].Di AND IN_SY.tBB_Dead_MMD[1].GoodQual);	
		
		
		
		IN_SY.tRel_I.Di;								(* release island/isolated operation *)
		IN_SY.tRel_BS.Di;								(* release black-out start   *)
		IN_SY.tRel_LS.Di;								(* load shedd ok = load shedding is done *)
	
	
		(* generator circuit breaker -------------------------------------------------*)
		gcb.eng_run				:=		bN_EngStart; 										(* engine rotating *)	//A_DREHZ;
		gcb.eng_oper			:=		IN_SY.tEng_Run.Do;									(* engine operation *)	//BTRB;	
		gcb.eng_demanded 		:=		IN_SY.bEng_RPSDem; 									(* engine demanded *)	//A_AGFD;
		gcb.racked_in 			:=		IN_SY.tGCB_Rac.Di;									(* gcb racked in *)
	
		xTOF_gcb_rdy(IN:= IN_SY.tGCB_Rdy.Di, PT:= T#500ms);
		gcb.rdy					:=		xTOF_gcb_rdy.Q		AND		gcb.racked_in;			(* gcb ready for closing *)
		gcb.on					:=		IN_SY.tGCB_On.Di	AND		gcb.racked_in;			(* gcb closed *)
		gcb.off					:=		IN_SY.tGCB_Off.Di	OR	NOT gcb.racked_in;			(* gcb open *)
		gcb.man_off				:=		bGCB_MOf; 											(* gcb manual off command button *)
		gcb.man_on				:=		bGCB_MOn; 											(* gcb manual on  command button *)
		gcb.mdl					:=		IN_SY.tGCB_MDL.Di;									(* Para.bMSy *)
		gcb.mrc					:=		IN_SY.tGCB_MRC.Di 	OR OUT_SY.bTestBenchModeIsland;	(* Para.bMSy *)
		gcb.rel_island			:= 	   (IN_SY.tGCB_RI.Di  	OR OUT_SY.bTestBenchModeIsland)	AND	NOT	OUT_SY.bTestBenchModeParallel;	(* Para.bMSy *)
		gcb.all_other_gcb_off	:=		IN_SY.tGCB_AGO.Di	OR OUT_SY.bTestBenchModeIsland;
		gcb.other_gcb_on 		:=	NOT gcb.all_other_gcb_off;
		gcb.other_gen_parallel  :=		IN_SY.tGCB_OGP.Di OR IN_SY.bGCB_OGP_Bus;

	
		(* mains ---------------------------------------------------------------------*)
		mains.ok		:=		mains.enable	AND		IN_SY.tMnsOk.Di;				(* mains ok *)
	
	
		(* mains circuit breaker -----------------------------------------------------*)
		mcb.racked_in 	:=		IN_SY.tMCB_Rac.Di;										(* mcb racked in *)
		
		xTOF_mcb_rdy(IN:= IN_SY.tMCB_Rdy.Di, PT:= T#500ms);
		mcb.rdy			:=		xTOF_mcb_rdy.Q   AND mcb.racked_in;(* mcb ready for closing *)
		mcb.on			:=		IN_SY.tMCB_On.Di AND mcb.racked_in;(* mcb closed *)
	
		IF Para.bMSy OR OUT_SY.bTestBenchModeIsland THEN
			mcb.off		:=	   (Para.bIslandOp_Enable OR Para.bOnlyIsland_Enable OR Para.bMSy OR OUT_SY.bTestBenchModeIsland)	
						AND	NOT	Para.bMCB_Ctr_Cust										(* mcb opened simulated (MSy) *)
						AND NOT	mcb.on;
		ELSE
			mcb.off		:= (NOT	Para.bMCB_Enable AND NOT Para.bIslandOp_Enable AND NOT Para.bOnlyIsland_Enable AND NOT Para.bMSy AND NOT Para.bMCB_Ctr_Cust)
						OR (NOT Para.bMCB_Enable AND NOT IN_SY.tMCB_Off.GoodQual AND NOT mcb.on)	
						OR		IN_SY.tMCB_Off.Di
						OR	NOT	mcb.racked_in;											(* mcb opened from input *)
		END_IF;


		mcb.remote		:=		IN_SY.tMCB_Rem.Di;										(* mcb operation mode remote *)
		mcb.man_off		:=		bMCB_MOf 			AND 	Para.bMCB_Enable;			(* mcb manual off command *)
		mcb.man_on		:=		bMCB_MOn 			AND 	Para.bMCB_Enable;			(* mcb manual on command *)

	
		(* customer circuit breaker/external unit  -------------------------------------------------------------*)
		IF Para.bMSy THEN
			ccb.eng_demanded 		:=	FALSE;											(* external engine demanded *)
			ccb.eng_run				:=	FALSE;											(* external engine running  *)
			ccb.eng_oper			:=	FALSE;											(* external engine operation *)
			ccb.on					:=	FALSE;											(* external cb closed *)
			ccb.off					:=	TRUE;											(* external cb open *)
			ccb.alm_psf				:=	FALSE;											(* external cb position signal failure *)
			ccb.opf					:=	FALSE;											(* external cb opening failure *)
			ccb.esl					:=	FALSE;											(* external cb locked *)
			ccb.edc_in				:=	FALSE;											(* external cb demand closing to dead busbar *)
			ccb.other_gen_parallel  :=	FALSE;											(* external cb other gen parallel *)				
	
		ELSE
			ccb.eng_demanded 		:=	IN_SY.tC_CB_On.Di OR FALSE;						(* external engine demanded *)
			ccb.eng_run				:=	IN_SY.tC_CB_On.Di;								(* external engine running  *)
	
			xTON_c_eng_op(IN:= ccb.eng_run, PT:= T#0s);
	
			ccb.eng_oper			:=	xTON_c_eng_op.Q;								(* external engine operating *)
			ccb.on					:=	IN_SY.tC_CB_On.Di;								(* external cb closed *)
			ccb.off					:=	IN_SY.tC_CB_Off.Di	OR	NOT	Para.bC_CB_Enable;	(* external cb open *)
	
			xTON_ccb_psf(IN:=   (	ccb.on	AND		ccb.off)
					 		OR (NOT ccb.on	AND	NOT ccb.off), PT:= T#3s);
	
			ccb.alm_psf				:=	xTON_ccb_psf.Q AND Para.bC_CB_Enable;			(* external cb position signal failure *)
			ccb.opf					:=	FALSE AND Para.bC_CB_Enable;					(* external cb opening failure, set TRUE if signal available *)
			ccb.esl					:=	IN_SY.tC_CB_ESL.Di;								(* external cb locked *)
			ccb.edc_in				:=	IN_SY.tC_CB_EDC.Di;								(* external cb demand closing to dead busbar *)
			ccb.other_gen_parallel  :=	FALSE AND Para.bC_CB_Enable;					(* external cb other gen parallel, set TRUE if signal available *)
		END_IF;
	
		
		(*----------------------------------------------------------------------------*)
		(* external unit demand lock gcb *)		(* ANF_BLO *)
		ccb.edc 		:=	Para.bC_CB_Enable		(* demand close from external gcb *)	
					AND		bb_dead					
					AND		ccb.edc_in;	

		any_gcb_edc_bb	:=	ccb.edc;
		
	
		(*----------------------------------------------------------------------------*)
		(* MSY/external unit status cb locked 	(FRG_AES) *)
		(* release closing mcb to dead busbar *)
		rel_mcb_on2d_bb	:= (NOT Para.bC_CB_Enable AND NOT Para.bMCB_Ctr_Cust) OR (ccb.esl AND NOT ccb.edc);


		(* release closing gcb to dead busbar *)
		rel_gcb_on2d_bb :=((NOT Para.bC_CB_Enable AND NOT Para.bMCB_Ctr_Cust) OR (ccb.esl AND NOT ccb.edc))
						AND		gcb.mrc				(* release closing from MSy *)
						AND	NOT	gcb.mdl;			(* no lock from MSy         *)


		(*----------------------------------------------------------------------------*)
	END_IF;

END_PROGRAM
