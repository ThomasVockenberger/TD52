(*******************************************************************************
mcb				mains circuit breaker control 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V1.10	12.01.2006	lettenb.	new
V1.11	16.03.2006	lettenb.	scb[1].on/off replaced with tie_on/off 
V2.12	24.04.2006	LH			adapted for esy new
		11.11.2006	LH			revised after Para.bMSy test
		20.11.2006	LH			revised for final release esy new
V2.20	07.02.2007	LH			adapted for supporting customer mcb
		27.04.2007	LH			update according to changes Para.bMSy:
								-mcb[x].command_on: tof_mcb_man_off[x].Q was mcb[x].command_off
								-ton_mcb_mrc[x] added
V2.60.0 13.08.2009	lettenb.	any_gcb_opf_bb changed by gcb[0].alm_opf, gcb_opf_delay
V3.30.0	10.10.2011	lettenb.	ton_mcb_dmnd_sy[1].IN: mcb.rdy added
V3.99.0	27.02.2013	lettenb.	cleanup
V4.09.0 05.02.2020	lettenb.	mcb[1].release_trip ruhestrom -> arbeitsstrom for mcb contr.by cust, missing change from V3.40.0 added
		20.04.2020	lettenb.	ton_mcb_dmnd_sy.IN:	mcb controlled by customer, bugfix(heim, Referenzanlage AB85)
		01.10.2020	lettenb.	ton_mcb_dmnd_sy.IN:	mcb controlled by customer, MCB_DVS also with bSyOMSS_Man, bu
V4.10.0	16.10.2020	Weitzer		mcb.man_on commented, IN_SY.bCust_Dem_RSy from CU added to ton_mcb_dmnd_sy ELSE part
V4.12.0 29.06.2022	lettenb.	dead bb synch added

Instructions for use:
--------------------

Outstandings:
------------
release mcb1 (old hardware design) to delete after testing
*******************************************************************************)
PROGRAM _CYCLIC	
	
	IF	Para.bSyActive	THEN
		(*----------------------------------------------------------------------------*)
		(* mcb demand synchronization (OUT_SY.bMCB_DemSy) *)
		IF Para.bMCB_Enable THEN										(* mcb controlled by esy *)
			ton_mcb_dmnd_sy.IN :=  (bSyOMSS_Aut
								OR (bSyOMSS_Man AND	NOT	mcb.man_off AND (mcb.man_on OR ton_mcb_dmnd_sy.IN)))
							AND		mcb.remote
							AND	   (bSyOMSS_Man OR bMainsReturn)
							AND    (mains.ok    OR bMainsReturn)
							AND		mcb.release
							AND	NOT mcb.alarm
	
							AND 	mcb.rdy
							AND	NOT mcb.on
							AND	   (bb_alive OR any_eng_oper_and_gcb_on_bb)
							AND	NOT	Para.bMCB_ReSw2Mns_Enable
							AND	NOT	MM2VIS.bMsg3412;
	
		ELSE															(* mcb controlled by customer *)
			ton_mcb_dmnd_sy.IN :=  (bSyOMSS_Man OR bSyOMSS_Aut)
							AND		bMainsReturn
							AND	NOT	gcb.dmnd_sy
	
							AND 	mcb.rdy
							AND	NOT mcb.on
							AND	   (bb_alive OR any_eng_oper_and_gcb_on_bb)
							AND	NOT	Para.bMCB_ReSw2Mns_Enable
							AND	NOT	MM2VIS.bMsg3412
							AND	IN_SY.bCust_Dem_RSy;		(* release by customer *)	
	
		END_IF;
		
		ton_mcb_dmnd_sy.PT := T#1s;
		ton_mcb_dmnd_sy();
		
		mcb.dmnd_sy	:=	ton_mcb_dmnd_sy.Q;
		
		(*----------------------------------------------------------------------------*)
		(* release trip mcb1 *)
		IF Para.bMCB_Enable THEN										(* mcb controlled by esy *)
			tof_mcb_rel_trip.IN :=	mcb.remote
								AND	bDem_Island
								AND	any_eng_run_bb;
	
		ELSE															(* mcb controlled by customer *)
			tof_mcb_rel_trip.IN :=	bDem_Island
								AND(IN_SY.tRel_Sync_Load.Do OR any_eng_run_bb);
	
		END_IF;
			
		tof_mcb_rel_trip.PT := T#1s;
		tof_mcb_rel_trip();
		
		mcb.rel_trip :=	tof_mcb_rel_trip.Q	AND	IN_SY.tPB2MM.bSys_Run;
	


		IF Para.bMCB_Enable THEN
			(*----------------------------------------------------------------------------*)
			(* monitoring release mcb *)
			mcb.mon_release :=	NOT mcb.alm_0sf
							AND	NOT	mcb.alm_1sf
							AND	NOT	mcb.alm_cf
							AND	NOT	mcb.alm_opf
							AND	NOT	mcb.alm_ol
							AND NOT ccb.alm_opf
							AND	NOT gcb_opf_delay;
			
			(*----------------------------------------------------------------------------*)
			(* release mcb *) 
			mcb.release	:=	mcb.mon_release
					AND	NOT	OUT_SY.bOnly_Island
					AND		TRUE;										(* include additional release conditions *)
			
			(*----------------------------------------------------------------------------*)
			(* extend manual off command mcb *)
			tof_mcb_man_off(IN:= mcb.man_off, PT:= T#6s);
			
			(* extend demand synchronize mcb *)
			tof_mcb_dmnd_sy(IN:= mcb.dmnd_sy, PT:= T#100ms);

			
			(*----------------------------------------------------------------------------*)
			(* release close mcb *)
			ton_mcb_mrc.IN :=	NOT	MM2VIS.bMsg1216
							AND	NOT	gcb.dmnd_sy
							AND	NOT	any_gcb_psf_bb
							AND	NOT	mcb.alm_psf
							AND		IN_SY.tPB2MM.bSys_Run;
		
			ton_mcb_mrc.PT := T#6s;
			ton_mcb_mrc();
			
			mcb.mrc		  := ton_mcb_mrc.Q;
			
			(*----------------------------------------------------------------------------*)
//			VKE7			:=	all_gcb_off_bb
//						AND	NOT	mcb.on
//						AND		Para.bMCB_ReSw2Mns_Enable;
		
//			VKE8			:= (Para.bMCB_ReSw2Mns_Enable AND NOT mcb.on AND all_gcb_off_bb)
//							OR	bb_dead;
		
			(* manuell on mcb1 to dead busbar *)
			mcb_man_on2dead_bb :=	bSyOMSS_Man
							AND 	mcb.release
							AND 	mcb.remote
							AND 	mcb.rdy
							AND 	mcb.mrc
							AND 	mains.ok
							AND 	mcb.man_on
							AND	NOT	tof_mcb_man_off.Q
							AND	   (bb_dead OR (Para.bMCB_ReSw2Mns_Enable AND NOT mcb.on AND all_gcb_off_bb))
							AND NOT IN_SY.tDemGenExcOff.Di
							AND		IN_SY.tPB2MM.bSys_Run;
		
			mcb.man_on2dead_bb :=	mcb_man_on2dead_bb
							AND		rel_mcb_on2d_bb;
			
			(* automatic on mcb to dead busbar *)
			mcb_aut_on2dead_bb :=	bSyOMSS_Aut
							AND 	mcb.release
							AND 	mcb.remote
							AND 	mcb.rdy
							AND 	mcb.mrc
							AND 	mains.ok
							AND	   (bb_dead OR (Para.bMCB_ReSw2Mns_Enable AND NOT mcb.on AND all_gcb_off_bb))
							AND NOT IN_SY.tDemGenExcOff.Di
							AND		IN_SY.tPB2MM.bSys_Run;
		
			mcb.aut_on2dead_bb :=	mcb_aut_on2dead_bb
							AND		rel_mcb_on2d_bb;
			
			(*----------------------------------------------------------------------------*)
			(* release sy_puls mcb *)
			IF	Para.bMCB_ReSw2Mns_Enable THEN								(* reswitch  to mains *)
				mcb.rel_sy_puls :=	FALSE;
			ELSE															(* synchronization to mains *)
				mcb.rel_sy_puls :=	mcb.release
							AND		mcb.remote
							AND		tof_mcb_dmnd_sy.Q
							AND		IN_SY.tPB2MM.bSys_Run;
			END_IF;
			
			(*----------------------------------------------------------------------------*)
			(* command mcb off *)											(* OUT_SY.tMCB_COf.Do *)
			mcb.dmnd_off 	:=	mcb.remote
						AND(NOT mcb.release OR (tof_mcb_man_off.Q AND NOT bSyOMSS_Aut))
						AND		IN_SY.tPB2MM.bSys_Run;
		
			mcb.command_off :=	mcb.dmnd_off
						AND	NOT	mcb.off;


			(*----------------------------------------------------------------------------*)
			(* command mcb on *)
			mcb.dmnd_on		:=	mcb.remote
						AND		mcb.release
						AND    (mcb.aut_on2dead_bb OR mcb.man_on2dead_bb)
						AND		IN_SY.tPB2MM.bSys_Run;
			
			mcb.command_on	:=	mcb.dmnd_on
						AND	NOT	mcb.on
						AND	NOT	tof_mcb_man_off.Q;
			
			(*----------------------------------------------------------------------------*)
			(* release mcb1 (old hardware design) to delete after testing *)
		//	ton_einprns.IN :=
		//					NOT	mcb[3].release
		//				AND	NOT	mcb.signal_mon;
		//	ton_einprns.PT := T#5s;
		//	ton_einprns();
		//
		//	mcb[3].release	:=	mcb.monitoring_release
		//				AND(
		//				   (	mcb.mns_ok		OR	NOT	mcb.release_trip	)
		//				AND(	ton_einprns.Q	OR		mcb[3].release		)
		//				OR (
		//				   (NOT	mcb.remote		OR	NOT	IN_SY.tPB2MM.bSys_Run					)
		//				AND		all_gcb_off_bb									));
		//
		//	(* command mcb1 off (old hardware design) *)
		//	mcb[3].command_off :=
		//				   (	mcb[3].release		AND		bSyOMSS_Aut				)
		//				OR (	mcb[3].release		AND	NOT	tof_mcb_man_off.Q)
		//				OR (
		//				   (NOT	mcb.remote		OR	NOT	IN_SY.tPB2MM.bSys_Run					)
		//				AND		all_gcb_off_bb									);
		
			(*----------------------------------------------------------------------------*)
		
		END_IF;
	END_IF;

END_PROGRAM
