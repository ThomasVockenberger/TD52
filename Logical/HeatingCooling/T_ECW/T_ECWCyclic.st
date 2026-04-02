(*******************************************************************************
T_ECW			temperature engine cooling water 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	01.10.1998	Pa			erstellt
		24.11.1998	Pa			korrekturlesung
V170	03.04.2002	LH			Verzögerung Kühlwassertemperatur max. => 5min
								Grenzwert Kühlwassertemperatur max. + 2°C (Abstellung)
V180	06.03.2003	LH			VISU-Grenzwerte erst aktiv wenn Rezepte auf Steuerung sind
		18.03.2003	LH			Einlesen Analogeingang --> pb17
V3.99.0	20.02.2013	lettenb.	kwtp renamed T_ECW, cleaning
								new param.for cooling water bypass valve		
V4.00.0 19.03.2015				xGRMIN_T_ECW_Lo: avoid bMsg1145 at cold restart within hysteresis
		
Instructions for use:
--------------------

Outstandings:
------------
(*******************************************************************************)

PROGRAM _CYCLIC

(*---------------------------------------------------------------------------*)
	(* engine cooling water temperature *) 
	
	(* low *)
	IF IN_HC.tPB2MM.bParaSetupOk THEN (* avoid bMsg1145 at cold restart within hysteresis *)
		 xGRMIN_T_ECW_Lo(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_LimLo, Hy:= Para.rT_ECW_HyLo);
	ELSE xGRMIN_T_ECW_Lo(In:= 1.0, Gw:= 0.0, Hy:= 0.0);
	END_IF;
	xTON_T_ECW_Lo(IN:= xGRMIN_T_ECW_Lo.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
    OUT_HC.bT_ECW_Lo := xTON_T_ECW_Lo.Q;

	(*high preheating off *)
	xGRMAX_T_ECW_PreH_OFF(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_PreH_LimOFF, Hy:= Para.rT_ECW_PreH_HyOFF);
    xTON_T_ECW_PreH_OFF(IN:= xGRMAX_T_ECW_PreH_OFF.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
    OUT_HC.bT_ECW_PreH_OFF := xTON_T_ECW_PreH_OFF.Q;

	(* high synch/load release *)
	xGRMAX_T_ECW_RelLoad(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_LimRelLoad, Hy:= Para.rT_ECW_HyRelLoad);
    xTON_T_ECW_RelLoad(IN:= xGRMAX_T_ECW_RelLoad.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
    OUT_HC.bT_ECW_RelLoad := xTON_T_ECW_RelLoad.Q;

	(* high *)
	xGRMAX_T_ECW_Hi(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_LimHi, Hy:= Para.rT_ECW_HyHi);
    xTON_T_ECW_Hi(IN:= xGRMAX_T_ECW_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#300s);
    OUT_HC.bT_ECW_Hi := xTON_T_ECW_Hi.Q;

	(* high high *)
	xGRMAX_T_ECW_HiHi(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_LimHi + 2.0, Hy:= Para.rT_ECW_HyHi);
    xTON_T_ECW_HiHi(IN:= xGRMAX_T_ECW_HiHi.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
    bT_ECW_HiHi := xTON_T_ECW_HiHi.Q;

	(* high P2 *)
	xGRMAX_T_ECW_HiHiPrio2(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_LimHi + 5.0, Hy:= Para.rT_ECW_HyHi);
	xTON_T_ECW_HiHiPrio2(IN:= xGRMAX_T_ECW_HiHiPrio2.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
	bT_ECW_HiHiPrio2 := xTON_T_ECW_HiHiPrio2.Q;	
	
	(* high 1 *)
	xGRMAX_T_ECW_Hi1(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_LimHi1, Hy:= Para.rT_ECW_HyHi1);
    xTON_T_ECW_Hi1(IN:= xGRMAX_T_ECW_Hi1.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
    bT_ECW_Hi1 := xTON_T_ECW_Hi1.Q;    

	(* high 2 *)
	xGRMAX_T_ECW_Hi2(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_LimHi2, Hy:= Para.rT_ECW_HyHi2);
    xTON_T_ECW_Hi2(IN:= xGRMAX_T_ECW_Hi2.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
    bT_ECW_Hi2 := xTON_T_ECW_Hi2.Q;


	(*---------------------------------------------------------------------------*)
	(* engine cooling water temperature - bypass valve *)
	xGRMIN_T_ECW_BpV(In:= IN_HC.tT_ECW.Ai, Gw:= Para.rT_ECW_LimBpV, Hy:= Para.rT_ECW_HyBpV);		
	xTON_T_ECW_BpV(IN:= xGRMIN_T_ECW_BpV.Q, PT:= T#2s);
	
	bECW_DemBpV := (	IN_HC.bEng_Aux_Dem AND xTON_T_ECW_BpV.Q)
    			OR (NOT IN_HC.bEng_Aux_Dem AND IN_HC.bEng_Aux_Dem_CDR);
    OUT_HC.tECW_DemBpV.Do 	:= bECW_DemBpV;

	(*---------------------------------------------------------------------------*)
	(*	engine cooling water bypass pump *)
    bECW_DemBpP 			:= bECW_DemBpV;
    OUT_HC.tECW_DemBpP.Do 	:= bECW_DemBpP;
	
(*---------------------------------------------------------------------------*)

END_PROGRAM
