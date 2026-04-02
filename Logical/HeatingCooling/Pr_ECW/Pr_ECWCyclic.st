(*******************************************************************************
Pr_ECW			pressure engine cooling water 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2023
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	20.10.1998	Pa			erstellt
 		24.11.1998	Pa			Korrekturlesung
V1.80	06.03.2003	LH			VISU-Grenzwerte erst aktiv wenn Rezepte auf Steuerung sind
 		18.03.2003	LH			Einlesen Analogeingang --> pb17
V2.06	01.07.2004	LH			Messignalstörung mit 2mA verzögert
V2.07	03.09.2004	LH			getrennte Verzögerungen für Messignalstörung eingeführt
V1.90	29.03.2004	LH			GW Kühlwasserdruck minimum warnend (Abstellung + 0,2bar)
 								GW Kühlwasserdruck maximum warnend (Abstellung - 0,4bar)
V2.20	24.04.2007	LH			Filter: 200ms --> 500ms (Hirzinger)
V2.50.0 28.01.2009	lettenb.	calm: GW_KDMI_W, HY_KDMI_W new parameter
V3.30.0	15.12.2011	lettenb.	GW_KDMA_W = GW_KDMA - 20 (war 40) (anforderung christian lang)	
V3.99.0 21.02.2013	lettenb.	kwd -> Pr_ECW renamed, cleaning
V4.04.0	25.10.2016	lettenb.	measuring signal plausibility check (Functional Safety EN 13849)
		03.02.2017				bTON_EngRun added (validation just for 1 time)
		21.02.2017				2763: 0,1 -> 0,01 bar(acc.spec.thummer)
V4.05.0	22.12.2017	lettenb.	comment added: Safety-related application software source code (EN 13849-1 / 4.6.3)
		31.01.2018				2763 new logic(false alarms after long engine stand still time)(gfoeller)
V4.11.0	05.11.2021	Schmid		new Pr_ECW plausibility check logic
V4.12.0	28.03.2023	Perktold	variant mech Pump: Pr_ECW paus. check 10s longer monitoring, pressure limit 15mbar (former 20mbar)
V4.14.0 10.12.2024	Nagy		Added bPr_ECW_LoLoPrio2, bPr_ECW_HiHiPrio2 (2024-225)
Instructions for use:
--------------------

Outstandings:
------------
(*******************************************************************************)

PROGRAM _CYCLIC

(*---------------------------------------------------------------------------*)
	(* engine cooling water pressure *)

	(* low *)
	xGRMIN_Pr_ECW_Lo(In:= IN_HC.tPr_ECW.Ai, Gw:= Para.rPr_ECW_LimLo, Hy:= Para.rPr_ECW_HyLo);
    xTON_Pr_ECW_Lo(IN:= xGRMIN_Pr_ECW_Lo.Q AND IN_HC.tPB2MM.bParaSetupOk AND IN_HC.tPr_ECW.GoodQual, PT:= T#20s); 
    bPr_ECW_Lo := xTON_Pr_ECW_Lo.Q;
	(* low during operation*)
	xGRMIN_Pr_ECW_LimOp(In:= IN_HC.tPr_ECW.Ai, Gw:= Para.rPr_ECW_LimLo_EngOp, Hy:= Para.rPr_ECW_HyLo);
	xTON_Pr_ECW_LimOp(IN:= xGRMIN_Pr_ECW_LimOp.Q AND IN_HC.tPB2MM.bParaSetupOk AND IN_HC.tPr_ECW.GoodQual, PT:= T#20s); 
	bPr_ECW_LimOp := xTON_Pr_ECW_LimOp.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* low low *)
	xGRMIN_Pr_ECW_LoLo(In:= IN_HC.tPr_ECW.Ai, Gw:= Para.rPr_ECW_LimLoLo, Hy:= Para.rPr_ECW_HyLoLo);
    xTON_Pr_ECW_LoLo(IN:= xGRMIN_Pr_ECW_LoLo.Q AND IN_HC.tPB2MM.bParaSetupOk AND IN_HC.tPr_ECW.GoodQual, PT:= T#3s); 
    bPr_ECW_LoLo := xTON_Pr_ECW_LoLo.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	(* low low Prio2 *)
	xGRMIN_Pr_ECW_LoLoPrio2(In:= IN_HC.tPr_ECW.Ai, Gw:= Para.rPr_ECW_LimLoLo - 0.2);
	xTON_Pr_ECW_LoLoPrio2(IN:= xGRMIN_Pr_ECW_LoLoPrio2.Q AND IN_HC.tPB2MM.bParaSetupOk AND IN_HC.tPr_ECW.GoodQual, PT:= T#3s); 
	bPr_ECW_LoLoPrio2 := xTON_Pr_ECW_LoLoPrio2.Q;
	
	(* low 1 *)(* for custom use *)
	xGRMIN_Pr_ECW_Lo1(In:= IN_HC.tPr_ECW.Ai, Gw:= Para.rPr_ECW_LimLo1, Hy:= Para.rPr_ECW_HyLo1);
    xTON_Pr_ECW_Lo1(IN:= xGRMIN_Pr_ECW_Lo1.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#3s);
    OUT_HC.bPr_ECW_Lo1 := xTON_Pr_ECW_Lo1.Q;
	
	(* high *)
	xGRMAX_Pr_ECW_Hi(In:= IN_HC.tPr_ECW.Ai, Gw:= Para.rPr_ECW_LimHiHi - 0.20, Hy:= Para.rPr_ECW_HyHiHi);
    xTON_Pr_ECW_Hi(IN:= xGRMAX_Pr_ECW_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#10s);
	bPr_ECW_Hi := xTON_Pr_ECW_Hi.Q;
	
	(* high high *)
	xGRMAX_Pr_ECW_HiHi(In:= IN_HC.tPr_ECW.Ai, Gw:= Para.rPr_ECW_LimHiHi, Hy:= Para.rPr_ECW_HyHiHi);
    xTON_Pr_ECW_HiHi(IN:= xGRMAX_Pr_ECW_HiHi.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#10s);
	bPr_ECW_HiHi := xTON_Pr_ECW_HiHi.Q;
	
	(* high high Prio2 *)
	xGRMAX_Pr_ECW_HiHiPrio2(In:= IN_HC.tPr_ECW.Ai, Gw:= Para.rPr_ECW_LimHiHi + 0.2);
	bPr_ECW_HiHiPrio2 := xGRMAX_Pr_ECW_HiHiPrio2.Q AND IN_HC.tPB2MM.bParaSetupOk;

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* measuring signal plausibility check - engine cooling water pressure (Functional Safety) *)	
	
	(* reset saved pressure values *)
	IF xF_TRIG_Pcheck_Meas.Q THEN
		rPr_ECW_MaxValue		:=	0.0;
		rPr_ECW_MinValue		:=	100.0;
	END_IF;

	(* determine point when ECWP starts *)
	rN_ThresSpeedUp		:=	900.0;
	rN_ThresEngStop		:=	5.0;
	IF IN_HC.bECWP_MechDriven THEN	xR_TRIG_ECWP_start.CLK	:=	(IN_HC.rN_EngAct > rN_ThresEngStop);	// problem of failed start attempt!
	ELSE							xR_TRIG_ECWP_start.CLK	:=	IN_HC.tECWP1Dem.Do;
	END_IF;
	xR_TRIG_ECWP_start();
	xTP_Pr_ECW_Min_ECWP_start(IN:= xR_TRIG_ECWP_start.Q, PT:= T#10s);
	IF NOT IN_HC.tECWP1Dem.Do THEN	xTP_Pr_ECW_Min_ECWP_start(IN:= FALSE, PT:= T#0s);
	END_IF;
	
	(* define time window for tracking minimum ECW pressure *)
	xTON_NEng_Exc_Thres(IN := (IN_HC.rN_EngAct > rN_ThresSpeedUp), PT := T#10s);								//10s delay after speed up rpm reached before monitoring stop
	xRS_Pr_ECW_Min_Meas.SET		:=	xR_TRIG_ECWP_start.Q;
	IF IN_HC.bECWP_MechDriven THEN	xRS_Pr_ECW_Min_Meas.RESET1	:=	xTON_NEng_Exc_Thres.Q						// speed up rpm reached + 10s TON
																OR	(IN_HC.rN_EngAct < rN_ThresEngStop);		// interrupt with failed start attempt
	ELSE							xRS_Pr_ECW_Min_Meas.RESET1	:=	NOT xTP_Pr_ECW_Min_ECWP_start.Q;
	END_IF;
	xRS_Pr_ECW_Min_Meas();
	
	(* determine minimum ECW pressure during time window *)
	IF xRS_Pr_ECW_Min_Meas.Q1 THEN
		IF (IN_HC.tPr_ECW.Ai < rPr_ECW_MinValue) THEN	rPr_ECW_MinValue	:=	IN_HC.tPr_ECW.Ai;
		END_IF;
		IF (IN_HC.tPr_ECW.Ai > rPr_ECW_MaxValue) THEN	rPr_ECW_MaxValue	:=	IN_HC.tPr_ECW.Ai;
		END_IF;
	END_IF;
	
	(* mute plausibility check after ECWP operation *)
	IF IN_HC.bECWP_MechDriven THEN	xTOF_Pcheck_MonDeact.IN	:=	(IN_HC.rN_EngAct > rN_ThresEngStop);		// delay w.r.t. engine coming to standstill
	ELSE							xTOF_Pcheck_MonDeact.IN	:=	IN_HC.tECWP1Dem.Do;
	END_IF;
	xTOF_Pcheck_MonDeact(PT:= T#60s);
	bPcheck_Pr_ECW_MonRel	:=	NOT (xTOF_Pcheck_MonDeact.Q AND NOT xTOF_Pcheck_MonDeact.IN)	// mute for fast ECWP or engine restart
							AND	IN_HC.bEng_Aux_Dem												// check only active when engine/auxiliaries demanded
							AND	IN_HC.tPB2MM.bParaSetupOk;										// scaling parameters for Pr_ECW loaded
	
	(* trigger check evaluation *)
	xF_TRIG_Pcheck_Meas(CLK:= xRS_Pr_ECW_Min_Meas.Q1);
	
	IF xF_TRIG_Pcheck_Meas.Q AND bPcheck_Pr_ECW_MonRel THEN		bPr_ECW_PcheckFail	:=	((rPr_ECW_MaxValue - rPr_ECW_MinValue) < 0.015);
	ELSE														bPr_ECW_PcheckFail	:=	FALSE;
	END_IF;

	IF MM2VIS.bMsg2104 OR NOT IN_HC.tECWP_Op.Di THEN						bPr_ECW_PcheckFail := FALSE;
	ELSIF (rPr_ECW_MaxValue = 0.0) THEN										bPr_ECW_PcheckFail := FALSE; (* value not valid *)
	ELSIF (rPr_ECW_MinValue  = 0.0) OR (rPr_ECW_MinValue  = 100.0) THEN		bPr_ECW_PcheckFail := FALSE; (* value not valid *)
	END_IF;	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)



END_PROGRAM                                                                                                                                                                                                                                                                                                                               
