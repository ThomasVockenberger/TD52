(*******************************************************************************
sy_out		control outputs  

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V2.12	24.04.2006	LH			gcb1 imported from MSY
								gcb1 --> sy_out
								adapted for esy new
		31.10.2006	LH			insert release gcb from Para.bMSy
		11.11.2006	LH			revised after Para.bMSy test
		20.11.2006	LH			revised for final release esy new
V2.20	07.02.2007	LH			new: lock command for customer mcb
		19.02.2007	LH			adapted for X20-system
								advanced software documentation
		04.04.2007	LH			correction of OUT_SY.bRel_IslandAfMITime in case of mcb controlled by customer
V2.201	22.05.2007	TW			change MMU variables to array (ex task: DO)
V2.30	16.01.2008	LH			building OUT_SY.bRel_IslandAfMITime to prevent engine shutdown 
								during waiting time for island demand
		18.01.2008	LH			adapted for test-bench run
V2.30	22.02.2008	LH			change output gcb opening failure (ex task: DO)
		26.02.2008	LH			connect gcb position sig. fail. to engine control
		05.03.2008	LH			change gcb position sig. fail. to engine control 
								to undelayed tripping
		28.03.2008	LH			connect gcb closing failure to engine control
V2.34.0	19.12.2008	lettenb.	OUT_SY.bRelEngOpFromSY: gcb.mdl removed
V2.60.0	13.08.2009	lettenb.	gcb_opf_delay for opening mcb with delay added (ex task: DO)
V2.60.0	08.10.2009	lettenb.	ton_dmnd_synchline added (delay for activating synch.device
 								after switching on the voltage signals to the synch.device.
								MMUsynch needs some time until frequence measuring is ok)
V3.20.0	01.07.2010	lettenb.	BR9_B added
		13.01.2011	lettenb.	Para.bEngOpAfterMIF_Enable added
V3.20.0	04.11.2010	lettenb.	bSyncSlipMode[2], bMMU2syMCB added for synchr.mcb with MMU2 (ex task: DO)
V3.30.0 02.02.2012	lettenb.	OUT_SY.bEng_Dem_EPS_Sy: Para.bIslandOp_Enable	added(to avoid message 'demand emerg.operation'
								in case of mains break down and no island operation is selected)
V3.90.0	13.11.2012	lettenb.	parts from pb17_en included
V3.99.0 26.02.2013	lettenb.	task DO included, iEngNr added
V3.99.1	25.03.2013	Denk		bRelSyFromCU changed to bRelSy_Customized
		27.06.2013	lettenb.	bRelEng4OnlyI_Op: brackets added, bugfix
V4.00.0 11.06.2014	lettenb.	bRelEng4I_Op: logic, ton_BLO_AES.PT case iEngNr, bugfix
		16.06.2014	lettenb.	OUT_SY.bRelEngOpFromSy: IN_SY.tMCB_Rel_Sync_SOn.Do ERDF lockout added (grid)
V4.04.0 31.10.2016				ton_esl.IN: ... AND FALSE) (* FALSE=econ_lock; added, acc.a_V3.59, wasserer/rosenheim)
        05.12.2016				OUT_SY.tRdy_MSy.Do,OUT_SY.tEng_Run_Sy.Do,OUT_SY.tEng_Dem.Do always active for GSY
		01.10.2020	lettenb.	OUT_SY.bMCB_DemSy, mcb controlled by customer, bugfix(heim, Referenzanlage AB85), bu
V4.10.0 15.12.2020	lettenb.	BR6 release island after MIF: bRel_IslandAfMITime in case of Para.bP_LoadReject_Active AND IN_SY.bType6_Update_Rel
V4.12.0 24.11.2020	lettenb.	WaitingTime_CloseGCB2DeadBB_too_long issue#911
								xTOF_RelEng4I_Op added, avoid loss of RelEng4I_Op for 1 cycle at OMSS change to OFF in island, issue#957
V4.13.0	17.08.2023	lettenb.	dead bb synch, bugfixes(BR21/wasserer,schwab,lettenb.)
		19.07.2023	Goenczi		Added Para.bSel_Customer to bRelEng4I_Op to bypass Dem_Island for Aggreko
								bEng_Dem_EPS_Sy condition from CU module added
								
Instructions FOR use:
--------------------
						variante:	ESy		+Msy	+CCB	noSy	GSy		AB_Sy
	immer	A_USP
			DO_ENG_D
			DO_PUL_MNS_OK
			DO_GCB_REL
			DO_GCB_RSP
			DO_GCB_OPF
			DO_GCB_CON
			DO_GCB_COF
			DO_GCB_RT
	
	msy		DO_GCB_ESL
			DO_GCB_EDC
			DO_RDY_MSY
			DO_ENG_RUN		OUT_SY.tEng_Run.Do;
	
	mcb		DO_MCB_RSP
			DO_MCB_DVS
			DO_MCB_RT
			DO_MCB_CON
			DO_MCB_COF
	
	AB		A_SYANW
			A_RSYANW
	
	indon.	DO_DMND_LS
	

	
Outstandings:
------------
define variations by parameter-settings
*******************************************************************************)
PROGRAM _CYCLIC

	IF	Para.bSyActive	THEN
		(*----------------------------------------------------------------------------*)
		(* demand synchline *)			(* OUT_SY.bDSyLine *)
		ton_dmnd_synchline(IN:= (gcb.dmnd_sy OR mcb.dmnd_sy) AND NOT pulse_sy_line, PT:= T#2s);
	
		dmnd_synchline := ton_dmnd_synchline.Q;
	
	
		(*----------------------------------------------------------------------------*)
		(* ESy demand lock all other cb's for closing gcb to dead busbar *)		(* BLO_AES) *)
		ton_BLO_AES.IN	:= (ton_gcb_dmnd_sy.IN	OR ton_gcb_dmnd_sy.Q)
					AND(    bb_dead OR(IN_SY.tDemGenExcOff.Di AND NOT bb_alive))(* dead busbar (OUT_SY.bBB_dead) *)
					AND(NOT	MM2VIS.bMsg1216	OR	OUT_SY.bTestBenchModeIsland)	(* no busbar voltage sensor failure *)
					AND(NOT any_gcb_on_bb   OR  IN_SY.tDemGenExcOff.Di)			(* all gcb open - busbar *)
					AND	NOT any_gcb_psf_bb										(* no other gcb with position failure *)
					AND NOT any_gcb_opf_bb										(* no other gcb with opening failure *)
					AND NOT mcb.on												(* all mcb open *)
					AND(NOT mcb.alm_psf		OR	OUT_SY.bTestBenchModeIsland)	(* no mains cb with position failure *)
					AND		IN_SY.tPB2MM.bSys_Run;								(* CPU is alive *)
	
		IF Para.bMSy THEN
			ton_BLO_AES.PT	:=	T#1s;		(* gcb close2deadBB interlock is done MSy *)
		ELSE
			CASE iEngNr OF			
			1:	ton_BLO_AES.PT	:=	T#1s;	(* engine 1 *)
			2:	ton_BLO_AES.PT	:=	T#2s;
			3:	ton_BLO_AES.PT	:=	T#3s;
			4:	ton_BLO_AES.PT	:=	T#4s;
			5:	ton_BLO_AES.PT	:=	T#5s;
			6:	ton_BLO_AES.PT	:=	T#6s;
			7:	ton_BLO_AES.PT	:=	T#7s;
			8:	ton_BLO_AES.PT	:=	T#8s;
			9:	ton_BLO_AES.PT	:=	T#9s;
			10:	ton_BLO_AES.PT	:=	T#10s;
			11:	ton_BLO_AES.PT	:=	T#11s;
			12:	ton_BLO_AES.PT	:=	T#12s;
			13:	ton_BLO_AES.PT	:=	T#13s;
			14:	ton_BLO_AES.PT	:=	T#14s;
			15:	ton_BLO_AES.PT	:=	T#15s;
			16:	ton_BLO_AES.PT	:=	T#16s;
			ELSE
				ton_BLO_AES.PT	:=	T#17s;
			END_CASE;	
		END_IF;	
		ton_BLO_AES();
	
		gcb.edc		:=	ton_BLO_AES.Q									(* demand closing gcb to dead busbar *)
					OR	mcb_man_on2dead_bb								(* manual closing mcb1 to dead busbar *)
					OR	mcb_aut_on2dead_bb;								(* automatic closing mcb1 to dead busbar *)

	
		(* ESY demand lock customer mcb while running island operation *)
		BLOCK_NS		:=	ton_BLO_AES.Q								(* demand closing gcb to dead busbar *)
					OR(			BLOCK_NS 
						AND		any_gcb_on_bb							(* lock customer mcb will last until *)
						AND	NOT	mcb.dmnd_sy);							(* resynchronizing is initiated *)
	
		(* release closing cb to dead busbar to MSY/external unit (AES_FRG) *)
		ton_esl.IN		:= (bb_dead AND NOT	ton_gcb_dmnd_sy.IN AND IN_SY.tPB2MM.bSys_Run AND NOT gcb.release AND FALSE) (* FALSE= ex.econ_lock;	interlock cb's only with 1 signal ? *)
					OR	   (any_gcb_edc_bb	                   AND IN_SY.tPB2MM.bSys_Run AND NOT gcb.release)			(* demand closing ext. cb to dead busbar (ANF_BLO) *)
					OR	   (gcb.mdl                            AND IN_SY.tPB2MM.bSys_Run AND NOT gcb.release);			(* demand lock from MSy *)
		ton_esl(PT:= T#1s);												(* engine (gcb) status locked -> release gcb (FG_GS) *)
	
		gcb.esl		:=	ton_esl.Q;										(* release closing ext. cb to dead busbar (AES_FRG) *)
	
		(*----------------------------------------------------------------------------*)
		(* demand emergency operation (OUT_SY.bEng_Dem_EPS_Sy) *)
		OUT_SY.bEng_Dem_EPS_Sy	:= ((Para.bIslandOp_Enable OR Para.bOnlyIsland_Enable OR Para.bMSy OR Para.bMCB_Ctr_Cust)
							AND(NOT	mains.ok OR	NOT	mcb.on)
							AND IN_SY.bCust_Dem_EPS_Sy);
	
		(*----------------------------------------------------------------------------*)
		(* release engine operation from ESY (OUT_SY.bRelEngOpFromSY) *)
		bRelEng4NP_Op	:= (mains.ok OR gcb.eng_oper)					(* release for parallel operation *) (* mehrfachverwendung *)
					AND		mcb.on										(* mcb closed (NS(1)_EIN) *)
					AND		bMainsReturn								(* mains return (OUT_SY.bMainsReturn) *)
					AND	NOT	MM2VIS.bMsg3412;							(* mains monitoring device failure *)
	

		(*----------------------------------------------------------------------------*)
		(* hold release engine for island op. after mi-filter time *)
		xTOF_Rel_IslandAfMITime(IN:= mains.ok, PT:= T#60s);

		IF 			NOT	gcb.eng_oper									(* no engine operation (IN_SY.tEng_Run.Do) *)
				OR	NOT	Para.bMIF_Enable
				OR		Para.bBS_OnlyMan
				OR	NOT	Para.bEngOpAfterMIF_Enable
				OR	   (xEngType.Type6 AND (NOT Para.bP_LoadReject_Active OR NOT IN_SY.bType6_Update_Rel))
				OR		xEngType.Type9
		THEN 
			xTOF_Rel_IslandAfMITime(IN:= FALSE, PT:= T#0s); 			(* reset bridging *)
		END_IF;

		OUT_SY.bRel_IslandAfMITime	:=	xTOF_Rel_IslandAfMITime.Q;		(* prevention of engine shutdown (M_BLOCK) *)
		(*----------------------------------------------------------------------------*)


		(* hold release engine for island op. for reswitch to mains *)
		xTOF_Rel_Island4Resw2Mns(IN:= gcb.on, PT:= T#60s); 

		IF		NOT	gcb.eng_oper										(* no engine operation (IN_SY.tEng_Run.Do) *)
			OR	NOT	Para.bMCB_ReSw2Mns_Enable
			OR		Para.bBS_OnlyMan				
			OR	   (xEngType.Type6 AND (NOT Para.bP_LoadReject_Active OR NOT IN_SY.bType6_Update_Rel))
			OR		xEngType.Type9 					
		THEN 
			xTOF_Rel_Island4Resw2Mns(IN:= FALSE, PT:= T#0s);			(* reset bridging *)
		END_IF;

		bRel_Island4Resw2Mns := xTOF_Rel_Island4Resw2Mns.Q;


		(*----------------------------------------------------------------------------*)
		xTOF_RelEng4I_Op(IN	:= (Para.bIslandOp_Enable OR Para.bMSy OR Para.bMCB_Ctr_Cust OR OUT_SY.bTestBenchModeIsland)
						AND	   (rel_i_adl OR NOT Para.bADL_Enable)
						AND	   (OUT_SY.bRel_IslandAfMITime OR bRel_Island4Resw2Mns OR bDem_Island OR gcb.rel_trip OR Para.iSel_Customer = 2), PT:= T#200ms); 
		bRelEng4I_Op	:= xTOF_RelEng4I_Op.Q;
	
		bRelEng4OnlyI_Op:=	OUT_SY.bOnly_Island
					AND		mcb.off	
					AND	NOT	mcb.on
					AND	  ((OUT_SY.bRelEngOpFromSy AND(gcb.eng_oper OR gcb.eng_demanded)) OR NOT gcb.eng_run);
	
		bRelEng4Op		:=	mcb.remote
					AND		mcb.racked_in
					AND		gcb.racked_in
					AND  (((bRelEng4NP_Op OR bRelEng4I_Op) AND NOT OUT_SY.bOnly_Island) OR bRelEng4OnlyI_Op);	(* release for island/parallel operation *)

			
		OUT_SY.bRelEngOpFromSy := 	IN_SY.tLineCB_On.Di 
								AND IN_SY.bRelSy_Customized				(* from MM_CU *)
								AND bRelEng4Op
								AND IN_SY.tMCB_Rel_Sync_SOn.Do;			(* ERDF lockout *)
	ELSE

		OUT_SY.bRelEngOpFromSy := 	IN_SY.tLineCB_On.Di 
								AND IN_SY.bRelSy_Customized 			(* from MM_CU *)
								AND IN_SY.tRelEngOpFromGSy.Di
								AND IN_SY.tMCB_Rel_Sync_SOn.Do;			(* ERDF lockout *)
	END_IF;

	(*-----------------------------------------------------------------------------*)	
	(* diagnostics *)
	bRelEng4NP_Op;				(* release engine for net parallel *)
	bRelEng4I_Op;				(* release engine for island(emergency op.)*)
	bRelEng4OnlyI_Op;			(* release engine for only island *)
	OUT_SY.bRelEngOpFromSy;		(* release engine for operation from sy *)
	(*-----------------------------------------------------------------------------*)


	(*-----------------------------------------------------------------------------*)
	(* switch standard-inputs esy to required inputs engine control *)
		OUT_SY.bSynchDem		:=		IN_SY.tGCB_DSY.Di;				(* demand synchline *)

		(* general -------------------------------------------------------------------*)
		OUT_SY.tRdy_MSy.Do		:=		IN_SY.bEng_Rdy_Aut_Exc;			(* engine ready    for MSY/GSY *)
		OUT_SY.tEng_Run_Sy.Do	:=		bN_EngStart;					(* engine rotating for MSY/GSY *)
		OUT_SY.tEng_Dem.Do		:=		IN_SY.bEng_RPSDem;				(* engine demanded for MSY/GSY *)
		OUT_SY.tOMSS_Man.Do		:=		bOMSS_Man;						(* oper.mode man.  for     GSY *)
		OUT_SY.tOMSS_Aut.Do		:=		bOMSS_Aut;						(* oper.mode aut.  for     GSY *)

	IF	Para.bSyActive	THEN		
		OUT_SY.tDemandBB.Do		:=		gcb.dmnd_sy;					(* demand busbar *)
		
		OUT_SY.tGCB_ESL.Do		:=		gcb.esl;						(* ESY status gcb locked *)
		OUT_SY.tGCB_EDC.Do		:=		gcb.edc;						(* ESY demand lock all other cb's connected to dead busbar *)
		OUT_SY.tLock_C_MCB.Do	:=		BLOCK_NS;						(* demand lock customer mcb while running island operation *)
		OUT_SY.tGCB_OpF.Do		:=		gcb_opf_delay;					(* alarm gcb opening failure *)
		
		(* generator circuit breaker -------------------------------------------------*)
		OUT_SY.tGCB_Rel.Do		:=		gcb.release;					(* release closing gcb *)
		OUT_SY.tGCB_RSP.Do		:=		gcb.rel_sy_puls;				(* release sy pulse gcb *)
		OUT_SY.tGCB_COn.Do		:=		gcb.command_on;					(* command gcb on *) (* Do = true  = command ON  *)
		OUT_SY.tGCB_COf.Do		:=	NOT gcb.command_off;				(* command gcb off *)(* Do = false = command OFF, closed circuit principle *)
		OUT_SY.tGCB_RT.Do		:=		gcb.rel_trip;					(* release trip gcb *)
		OUT_SY.tGCB_DVS.Do		:=		gcb.dmnd_sy;					(* demand synchronization gcb - select voltage *)
	
		(* mains circuit breaker -----------------------------------------------------*)
		OUT_SY.tMCB_RSP.Do		:=	NOT Para.bMSy AND mcb.rel_sy_puls;	(* release sy pulse mcb1 *)
		OUT_SY.tMCB_COn.Do		:=	NOT Para.bMSy AND mcb.command_on;	(* command mcb1 on *)
		OUT_SY.tMCB_COf.Do		:=	NOT Para.bMSy AND mcb.command_off;	(* command mcb1 off *)
		OUT_SY.tMCB_RT.Do		:=	NOT Para.bMSy AND mcb.rel_trip;		(* release trip mcb1 *)
		OUT_SY.tMCB_DVS.Do		:=	NOT Para.bMSy AND mcb.dmnd_sy;		(* demand synchronization mcb1 - select voltage *)
	
		(* switch standard-outputs esy to standard-inputs engine control -------------*)
		OUT_SY.bMsg1217			:=		gcb.alm_psf;					(* alarm gcb position signal failure *)
		OUT_SY.bMsg1218			:=		gcb.alm_opf;					(* alarm gcb opening failure *)
		OUT_SY.bMsg1219			:=		gcb.alm_cf;						(* alarm gcb closing failure *)
		bGCB_GnlWarning			:=		gcb.alarm;						(* gcb general warning *)
		OUT_SY.bMsg1209			:=		mcb.alm_psf;					(* alarm mcb position signal failure *)
		bMCB_GnlWarning			:=		mcb.alarm;						(* mcb general warning *)
	
		OUT_SY.bGCB_DemSy		:=		gcb.dmnd_sy;					(* demand synchronization gcb for main loop display *)
		OUT_SY.bMCB_DemSy		:=		mcb.dmnd_sy AND Para.bMCB_Enable;(* demand synchronization mcb for main loop display *)
		OUT_SY.bDSyLine			:=		dmnd_synchline;					(* ESY demand synchline for synchronizing gcb *)
		OUT_SY.bMnsOk			:=		IN_SY.tMnsOk.Di;				(* mains ok       for W1175 *)
		OUT_SY.bMainsReturn		:=		bMainsReturn;					(* mains return   for W1175 and block engine *)
		OUT_SY.bBB_dead			:=		bb_dead;						(* busbar dead for main loop display and B2139/B3265 *)
		OUT_SY.bRel_Island		:=		bRelease_Island;				(* release island for W1175 and block engine *)
		BLOUT					:=		dmnd_black_start;				(* demand black-out start for demand load shedding *)
		OUT_SY.bOtherGenParallel:=		OUT_SY.bOtherGenParallel;		(* other engine parallel for demand emergency op. *)
	
	
		(* switch standard-outputs esy new to standard-inputs MMU/Sync ---------------*)
		OUT_SY.bSyncSlipMode[1] :=	   (OUT_SY.bMCB_DemSy	AND NOT Para.bMCB_SyMMD2)	(* synchronization with slip mode *)
									OR (OUT_SY.bGCB_DemSy	AND	NOT	bb_dead);
		OUT_SY.bSyncSlipMode[2] :=  	OUT_SY.bMCB_DemSy	AND 	Para.bMCB_SyMMD2;	(* synchronization with slip mode *)
	
	
		(*----------------------------------------------------------------------------*)
		(* synchronizing device on *)			(* SYG_EIN *)
		OUT_SY.bGen_SyD_Dem 	:= (gcb.dmnd_sy OR mcb.dmnd_sy) AND	bb_alive;		


		(* release synchronizing pulse *)		(* FG_SYIMP *)
		ton_dmnd_sy_device(IN:= OUT_SY.bGen_SyD_Dem, PT:= T#2s);
		rel_sy_puls				:=	ton_dmnd_sy_device.Q;


		(*----------------------------------------------------------------------------*)
	END_IF;	

END_PROGRAM
