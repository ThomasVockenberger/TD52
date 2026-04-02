(*******************************************************************************
T_HW		temperature heat water

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.99.0	20.02.2013	lettenb.	from task vltp, rltp, rltp_nk, rlt_m
								p_limitHC included
		14.03.2012	lettenb.	p_lim --> p_red (power red.from act.frozen power value) request: systems/thummer mathias
V4.00.0	01.07.2014	lettenb.	bT_HW_Su_Hi/HiHi: AND Para.bT_HW_Su_Active added, bugfix
V4.03.0	29.07.2015	plattner	heat circuit temperature added
V4.04.0 29.07.2016	lettenb.	2nd bT_HW_ReBeEng_Hi building removed, cleanup
		12.09.2016				comment removed
V4.05.0 13.06.2017	lettenb.	rP_Red_T_ECW_Low_Norm added, SWAT920/3

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)


PROGRAM _CYCLIC
	(*-----------------------------------------------------------------------------*)
	(* heat water supply temperature *)
	(* high *) (* W2430 *)
	xGRMAX_T_HW_Su_Hi(Gw:= Para.rT_HW_Su_LimHi, Hy:= Para.rT_HW_Su_HyHi, In:= IN_HC.tT_HW_Su.Ai);
	xTON_T_HW_Su_Hi(IN:= xGRMAX_T_HW_Su_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk AND Para.bT_HW_Su_Active, PT:= T#2s);
	bT_HW_Su_Hi := xTON_T_HW_Su_Hi.Q;	 
	
	(* high high *) (* A1063 *)
	xGRMAX_T_HW_Su_HiHi(Gw:= Para.rT_HW_Su_LimHiHi, Hy:= Para.rT_HW_Su_HyHiHi, In:= IN_HC.tT_HW_Su.Ai);
	xTON_T_HW_Su_HiHi(IN := xGRMAX_T_HW_Su_HiHi.Q AND IN_HC.tPB2MM.bParaSetupOk AND Para.bT_HW_Su_Active, PT := T#2s);
	bT_HW_Su_HiHi := xTON_T_HW_Su_HiHi.Q;	


	(*-----------------------------------------------------------------------------*)
	(* heat water return temperature *)
	(* high *)
	xGRMAX_T_HW_Re_Hi(In:= IN_HC.tT_HW_Re.Ai, Gw:= Para.rT_HW_Re_LimHi, Hy:= Para.rT_HW_Re_HyHi);
	xTON_T_HW_Re_Hi(IN := xGRMAX_T_HW_Re_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk AND Para.bT_HW_Re_Active, PT := T#2s);
	bT_HW_Re_Hi := xTON_T_HW_Re_Hi.Q;	

	(* high high *)
	xGRMAX_T_HW_Re_HiHi(In := IN_HC.tT_HW_Re.Ai, Gw := Para.rT_HW_Re_LimHiHi, Hy := Para.rT_HW_Re_HyHiHi);
	xTON_T_HW_Re_HiHi(IN:= xGRMAX_T_HW_Re_HiHi.Q AND IN_HC.tPB2MM.bParaSetupOk AND Para.bT_HW_Re_Active, PT:= T#2s);
	bT_HW_Re_HiHi := xTON_T_HW_Re_HiHi.Q;	


	(*-----------------------------------------------------------------------------*)
	(* heat water return temperature after emergency cooler *)
	(* high *)
	xGRMAX_T_HW_ReAfEC_Hi(In:= IN_HC.tT_HW_ReAfEC.Ai, Gw:= Para.rT_HW_ReAfEC_LimHi, Hy:= Para.rT_HW_ReAfEC_HyHi);
	xTON_T_HW_ReAfEC_Hi(IN:= xGRMAX_T_HW_ReAfEC_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
	bT_HW_ReAfEC_Hi := xTON_T_HW_ReAfEC_Hi.Q;	

	(* high high *)
	xGRMAX_T_HW_ReAfEC_HiHi(In:= IN_HC.tT_HW_ReAfEC.Ai, Gw:= Para.rT_HW_ReAfEC_LimHiHi, Hy:= Para.rT_HW_ReAfEC_HyHiHi);
	xTON_T_HW_ReAfEC_HiHi(IN:= xGRMAX_T_HW_ReAfEC_HiHi.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
	bT_HW_ReAfEC_HiHi := xTON_T_HW_ReAfEC_HiHi.Q;	
	

	(*-----------------------------------------------------------------------------*)
	(* heat water return temperature before engine *)
	(* high *)		
	xGRMAX_T_HW_ReBeEng_Hi(In:= IN_HC.tT_HW_ReBeEng.Ai, Gw:= Para.rT_HW_ReBeEng_LimHi, Hy:= Para.rT_HW_ReBeEng_HyHi, );
	xTON_T_HW_ReBeEng_Hi(IN:= xGRMAX_T_HW_ReBeEng_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
	bT_HW_ReBeEng_Hi := xTON_T_HW_ReBeEng_Hi.Q;

	(* high high *)(* reserve *)	
	xGRMAX_T_HW_ReBeEng_HiHi(In:= IN_HC.tT_HW_ReBeEng.Ai, Gw:= Para.rT_HW_ReBeEng_LimHiHi, Hy:= Para.rT_HW_ReBeEng_HyHiHi, );
	xTON_T_HW_ReBeEng_HiHi(IN:= xGRMAX_T_HW_ReBeEng_HiHi.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
	bT_HW_ReBeEng_HiHi := xTON_T_HW_ReBeEng_HiHi.Q;
	
	
	(*-----------------------------------------------------------------------------*)
	(* heat circuit temperature *)
	(* high *)
	xGRMAX_T_HW_HC_Re_Hi(Gw:= Para.rT_HW_HC_Re_LimHi, Hy:= Para.rT_HW_HC_Re_HyHi, In:= IN_HC.tT_HW_HC_Re.Ai);
	xTON_T_HW_HC_Re_Hi(IN:= xGRMAX_T_HW_HC_Re_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk AND Para.bT_HW_HC_Re_Active, PT:= T#2s);
	bT_HW_HC_Re_Hi := xTON_T_HW_HC_Re_Hi.Q;	 


	(*-----------------------------------------------------------------------------*)
	(* power reduction by heat water return temperature high *)
	(* selection *)
	CASE Para.iPred_T_HW_Re_Sel OF 
		0:	rT_HW_Re := 0;						(* disabled	*)
		1:	rT_HW_Re := IN_HC.tT_HW_Re.Ai;		(* P.06(04)-TI-012	(NUT12) *)
		2:	rT_HW_Re := IN_HC.tT_HW_ReAfEC.Ai;	(* P.06(04)-TI-015	(NUT15) *)
		3:	rT_HW_Re := IN_HC.tT_HW_ReBeEng.Ai;	(* M.06(04)-TI-001	(NUT56) *)
		ELSE
			rT_HW_Re :=0;
	END_CASE;

	IF rT_HW_Re <= Para.rT_Pred_HW_Re_Start THEN
		rP_Act_Norm_frozen := IN_HC.rP_Act_Norm_Filt;		
	END_IF;	

	IF Para.iPred_T_HW_Re_Sel <> 0 AND rT_HW_Re > Para.rT_Pred_HW_Re_Start THEN
		OUT_HC.rP_Red_T_HWR_Norm := LIMIT(0.5, rP_Act_Norm_frozen - ((rT_HW_Re - Para.rT_Pred_HW_Re_Start) * Para.rPred_T_HW_Re_Rate), 1.0);
	ELSE
		OUT_HC.rP_Red_T_HWR_Norm := 1.0;
	END_IF;


	(* power reduction by engine cooling water return temperature low - warm up operation *)
	IF IN_HC.tT_ECW.Ai < Para.rT_ECW_PwrRamp_LimLo AND bOMSS_Man AND xEngType.Type9 THEN
		OUT_HC.rP_Red_T_ECW_Low_Norm := 0.40;//%Pnom(10MW) = ca.4MW
	ELSE
		OUT_HC.rP_Red_T_ECW_Low_Norm := 1.0;
	END_IF;


	(* power reduction by engine cooling water temperature high *)
	OUT_HC.rP_Red_T_ECW_Norm := LIMIT(0.5, 1.0 - ((IN_HC.tT_ECW.Ai - Para.rT_Pred_ECW_Start) * Para.rPred_ECW_Rate), 1.0);

	
	(*-----------------------------------------------------------------------------*)

	
	(*-----------------------------------------------------------------------------*)

	
END_PROGRAM
