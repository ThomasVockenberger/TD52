(*******************************************************************************
blackstart		blackout start 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V2.12	24.04.2006	LH			adapted for esy new
		02.10.2006	LH			modification of anti-detonation logic
		16.10.2006	LH			for execution load shedding:
								dmnd_load_shedd --> dmnd_black_start
		31.10.2006	LH			adaption of island release coming from Para.bMSy
		11.11.2006	LH			revised after Para.bMSy test
		20.11.2006	LH			revised for final release esy new
V2.20	27.04.2007	LH			update according to last changes mcb(s)
V2.20.1	08.08.2007	LH			termination of island power monitoring
V2.30	18.01.2008	LH			adapted for test-bench run
V3.99.0	04.03.2013	lettenb.	adapted for pilot engine 612, update anti detonation logic
		04.07.2013				IN_SY.tP_MnsImp_Act --> IN_SY.rP_MainsImport from MM_CU
V4.00.0 12.06.2014	lettenb.	test bTestBenchModeIsland	
V4.03.0 18.11.2015  zengerer	BUGFIX NULLDIVISIONEN AND IN_SY.rP_Nom > 0 
		11.04.2016	lettenb.	ton_dmnd_bs_over.Q -> dmnd_bs_over, bugfix	
V4.12.0 29.06.2022	lettenb.	dead bb synch
V4.13.0 23.05.2023	Goenczi		code array view, interfaces from CU	
				
Instructions for use:
--------------------

Outstandings:
------------
monitoring pmin in island operation ? (in v3.40 not active)
*******************************************************************************)
FUNCTION AND_Array
	memcpy(ADR(Arrayx),Adress,MIN(40,Size) + 1);
	AND_Array	:=	 TRUE;
	FOR i:= 0 TO MIN(40,Size) DO
		AND_Array	:=	AND_Array AND Arrayx[i];
	END_FOR
END_FUNCTION

FUNCTION OR_Array
	memcpy(ADR(Arrayx),Adress,MIN(40,Size) + 1);
	OR_Array	:=	 FALSE;
	FOR i:= 0 TO MIN(40,Size) DO
		OR_Array	:=	OR_Array OR Arrayx[i];
	END_FOR
END_FUNCTION

PROGRAM _CYCLIC	
	
	IF	Para.bSyActive	THEN
		(*----------------------------------------------------------------------------*)
		(* general release island operation *)
		xTON_Sys_Run(IN:= IN_SY.tPB2MM.bSys_Run, PT:= T#10s);
		
		bIsl_mode[0]	:=	gcb.rel_island AND gcb.eng_oper AND gcb.other_gen_parallel AND	NOT	tof_mns_connection.Q;
		bIsl_mode[1]	:=	gcb.rel_island AND NOT OUT_SY.bSmoothDischarge;
		bIsl_mode[2]	:=	OUT_SY.bOnly_Island;

		bIsland_mode	:=	OR_Array(ADR(bIsl_mode),2);

		bRel_Isl[0]	:=	Para.bIslandOp_Enable OR Para.bOnlyIsland_Enable OR Para.bMSy OR Para.bMCB_Ctr_Cust	OR OUT_SY.bTestBenchModeIsland;
		bRel_Isl[1]	:=	IN_SY.tRel_I.Di;	(* release island extern (OUT_SY.bRel_Island)   *)
		bRel_Isl[2]	:=	xTON_Sys_Run.Q;
		bRel_Isl[3]	:=	bIsland_mode;
		bRel_Isl[4]	:=	IN_SY.bRel_I_Bus;	(*release island via Bus*)
		bRel_Isl[5]	:=	IN_SY.bCust_Rel_I;	(*custom release from CU*)
		
		bRelease_Island	:=	AND_Array(ADR(bRel_Isl),5);
	
		(* release island operation busbar: false = mains-cut-off with gcb *)
		bRel_Isl_BB[0]	:=	gcb.on AND bDem_Island AND NOT mcb.on;
		bRel_Isl_BB[1]	:=	gcb.on AND NOT sel_gcb_mains_cut_off AND NOT MM2VIS.bMsg3412;
		bRel_Isl_BB[2]	:=	other_gcb_on;
		bRel_Isl_BB[3]	:=	dmnd_black_start;
		bRel_Isl_BB[4]	:=	IN_SY.bCust_RelI_BB; 	(*new Aggreko release from CU*)
		bRel_Isl_BB[5]	:=	FALSE;
		
		bRelease_Isl_BB	:=	OR_Array(ADR(bRel_Isl_BB),5);
	
		bRel_VKE10[0]	:=	bRelease_Isl_BB;
		bRel_VKE10[1]	:=	bRelease_Island;
		bRel_VKE10[2]	:=	NOT	mcb.alm_psf OR	OUT_SY.bTestBenchModeIsland;
		bRel_VKE10[3]	:=	NOT	mcb.alm_opf;
		bRel_VKE10[4]	:=	NOT	any_gcb_opf_bb;
		
		bRelease_VKE10	:=	AND_Array(ADR(bRel_VKE10),4);
	
		(* demand island operation (INSEL) *)
		bDem_Isl[0]	:=	bRelease_VKE10;
		bDem_Isl[1]	:=	rel_i_adl OR NOT Para.bADL_Enable; (* release from anti-detonation logic *)

		bDem_Island	:=	AND_Array(ADR(bDem_Isl),1);
		
		(*----------------------------------------------------------------------------*)
		(* release black-out start *)
		rel_black_start	:= (Para.bBS_Enable OR Para.bOnlyIsland_Enable OR Para.bMSy	OR OUT_SY.bTestBenchModeIsland)
					AND		IN_SY.tRel_BS.Di;			(* release black-out extern (BL_OUT) *)

	
		(*----------------------------------------------------------------------------*)
		(* demand black-out start (BLOUT) *)
		black_status_bb := (all_gcb_off_bb OR IN_SY.tDemGenExcOff.Di)
					AND		mcb.off;

		(*----------------------------------------------------------------------------*)
		IF NOT Para.bMCB_ReSw2Mns_Enable THEN
			dmnd_black_start :=	bRelease_Island					(* BLOUT *)
						AND		rel_black_start
						AND	   (bSyOMSS_Man OR	NOT	Para.bBS_OnlyMan)
						AND	   (bOMSS_Man   OR	NOT	Para.bBS_OnlyMan)
						AND(NOT bMainsReturn					    OR black_status_bb)
						AND	   (mcb.off     OR  NOT MM2VIS.bMsg3412 OR black_status_bb)
						AND   	mcb.remote
						AND(NOT	mcb.alarm   OR	    OUT_SY.bTestBenchModeIsland)
						AND NOT any_gcb_alarm_bb
						AND NOT	dmnd_bs_over;

		ELSIF Para.bMCB_ReSw2Mns_Enable THEN
			dmnd_black_start :=	bRelease_Island					(* BLOUT *)
						AND		rel_black_start
						AND	   (bSyOMSS_Man OR	NOT	Para.bBS_OnlyMan)
						AND	   (bOMSS_Man   OR	NOT	Para.bBS_OnlyMan)
						AND	NOT bMainsReturn
						AND	   (mcb.off     OR  NOT MM2VIS.bMsg3412)
						AND   	mcb.remote
						AND(NOT	mcb.alarm   OR	    OUT_SY.bTestBenchModeIsland)
						AND NOT any_gcb_alarm_bb
						AND NOT	dmnd_bs_over;	
		END_IF;
		
	
		(*----------------------------------------------------------------------------*)		
		(* black-out start procedure finished *)
		dmnd_bs_over	:= (dmnd_black_start OR	dmnd_bs_over)
					AND		gcb.eng_oper
					AND		gcb.on;

		
		(*----------------------------------------------------------------------------*)
		(* demand load shedding *)
		dmnd_load_shedd	:=	black_status_bb
					AND		bRelease_Island
					AND		rel_black_start
					AND		dmnd_black_start;
	
		(* load shedding ok *)
		ton_ls_ok(IN:= dmnd_load_shedd AND IN_SY.tRel_LS.Di, PT:= T#5s);
		
		rel_load_shedd	:=	ton_ls_ok.Q;		(* load shedding is done (LAST_AB) *)
	
	
		(******************************************************************************)
		(* anti detonation logic *)
		(*----------------------------------------------------------------------------*)
		tof_mns_connection(IN:= mcb.on, PT:= T#5s);	(* mains connected to busbar	 *)
		ton_gcb_on        (IN:=	gcb.on, PT:= T#5s);	(* generator connected to busbar *)
	
		(*----------------------------------------------------------------------------*)
		IN_SY.rP_Nom;						(* engine nominal generator power [kW] *)
		IN_SY.rP_Act_Norm_Filt;				(* engine actual  generator power [kW] *)

		rPchange_max	:=	40.0;			(* maximum allowed loss of gen. power *)
		rPgen_min		:=	15.0;			(* minimum required island power      *)
		
		(*----------------------------------------------------------------------------*)
		(* generator power supplied to busbar *)
		IF gcb.on THEN	rP_Gen_Act_Norm := IN_SY.rP_Act_Norm_Filt;	
		ELSE			rP_Gen_Act_Norm := 0.0;
		END_IF;

		(* mains power to busbar in % Pnom engine *)
		IF mcb.on AND IN_SY.rP_Nom > 0  THEN	rP_Mns_Act_Norm := IN_SY.rP_MainsImport / IN_SY.rP_Nom;
		ELSE			rP_Mns_Act_Norm := 0.0;
		END_IF;
		
		(* consumer load on busbar *)
		rP_Csm_Act_Norm := rP_Gen_Act_Norm + rP_Mns_Act_Norm;
	
		(*----------------------------------------------------------------------------*)		
		(* release for island operation *)
		IF (Para.bMSy AND mcb.on AND bRelease_VKE10) OR NOT mcb.on THEN
			rel_i_adl		:=	TRUE;
		ELSIF NOT VKE41 AND mcb.on	THEN
			rel_i_adl		:=	TRUE;					(* cond. to change into island are ok *)
		ELSE
			rel_i_adl		:=	FALSE;					(* change into island is not allowed  *)
		END_IF;
		
		(*----------------------------------------------------------------------------*)
		(* monitoring change of generator power in case of opening mcb *)
		VKE40			:=	VKE41						(* maintained lock command            *)
					AND	NOT	gcb.on
					AND		gcb.eng_run;

		VKE41			:=	VKE40						(* --> lock module after opening xcb  *)
					OR	   (rPchange > rPchange_max);	(* because of too much loss of power  *)

		(* --> no load expected because:  *)  
		bPcalc		:=		mcb.on								(* - no connection to mains          *)
					AND		bRelease_VKE10						(* - no island operation selected    *)
					AND		(IN_SY.rP_MainsImport <> -999999.0)	(* - no mains power signal, value if signal not connected = -999999 from MM_CU *)
					AND		other_gcb_off;						(* - Pcsm calculation  not possible	*)
		
		IF	bPcalc	THEN
			rP_I_Act_Norm_Expected := rP_Csm_Act_Norm;	(* gen.load will be consumer load   *)
		ELSE
			rP_I_Act_Norm_Expected := 0;				(* no load expected at opening xcb    *)
		END_IF;
		
		(* change of gen. power at opening xcb = generator power supplied to busbar - expect.load in case of opening mcb*)
		rPchange	:=	IN_SY.rP_Act_Norm_Filt - rP_I_Act_Norm_Expected;
	
		(*----------------------------------------------------------------------------*)
	
	END_IF;

END_PROGRAM
