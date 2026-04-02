(***************************************************************************
loadshed			functions  

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	10.07.1998 Pa			erstellt
 		24.11.1998 Pa			korrekturlesung
V170	08.03.2002 LH			Anforderung Netzstartgerät
 								Anforderung Entregung
 								Anforderung Lastabwurf
V180	21.03.2003 LH			Zuschaltung COSPHI-Regler geändert
V206	22.06.2004 LH			Freigabe Gemischregler über Parameter
V2071c	20.09.2005 LH			neu: Generator ohne Spannung
 								neu: Freigabe Spannungsanwahl LS-Generator
V2072	16.11.2005 LH			Grenzwert Generatorspannung auf Prozent Nennspannung bezogen
V190	14.04.2004 LH			Anforderung Lastabwurf angepasst
 		06.06.2006 LH			neu: Spannungsverstellung Generator
V2102	22.11.2006 LH			Lastabwurf durch Anforderung P-Reduktion im Inselbetrieb
 								GW Generatorspannung: 12,5% --> 30,0%
V212	16.10.2006 LH			Anpassungen für ESY-NEU
V220	19.02.2007 LH			E_LSHK nur noch für GSY aktiv
 								neu: Anforderung Heizwasserpumpe
 								neu: Quittierung Warnung
 		23.03.2007 LH			Aktivierung LSHK für CUN1 AvK-Generator (Plattner)
 		20.04.2007 LH			Eingabe Generator-Nennspannung --> settings 
 		11.05.2007 LH			keine Entregung mehr beim Abstellvorgang (Kruckenhauser)
V2201	04.06.2007 LH			Anforderung Heizwasserpumpe --> Heizwasserpumpe EIN
V2225	23.04.2008 LH			Erweiterungen für Pakistan
V2.34.0	14.10.2008 lettenb.		generator deexcitation A_ENTR: M_GEN_PT added
V2.50.0	28.01.2009 lettenb.		M_MMD_OL added
								DO_DMND_LS: M_BTRB added for PAK
V2.60.0	07.08.2009 lettenb.		FA_A_QUITT from VISA added
V3.10.0	07.08.2009 lettenb.		A_COSPHI: PAK removed (country specific selection removed/steiger joh.)
								FG_KT: AN_RLT_M added (demand cooling tower/steiger/pfister)
V3.20.0	30.09.2010 maier(BuR)	M_GSEIN replaced with GCB_ON
								NS_EIN replaced with MCB_ON
		07.12.2010 lettenb.		DO_A_QUITT, DO_W_QUITT moved to task reset
		07.02.2011				FG_HGV, FG_HGV_ext release main gas valve added (moved from task biogas)
V3.30.0	20.10.2011 lettenb.		DMND_ICF added: demand charge cooler ventilation(intercooler fan)
V3.90.0	08.11.2011 lettenb.		new from pb8
V4.13.0 20.11.2023 Farre,		added IN_SY.bBypassMCB_LoadShed and request power mode interfaces from CU needed for Microgrid (2023-168)

Instructions for use:
--------------------

Outstandings:
------------
***************************************************************************)

PROGRAM _CYCLIC
	(*------------------------------------------------------------------------------------*)	
	(* power maximum for load shedding *)
	xGR_MAXR_P_LS_Hi(In:= IN_SY.rP_Act_Norm_Filt, Gw:= Para.rP_LS_LimHi, Hy:= Para.rP_LS_HyHi);
	xTON_P_LS_Hi(IN:= xGR_MAXR_P_LS_Hi.Q AND IN_SY.tPB2MM.bParaSetupOk, PT:= Para.tiP_LS_LimHi);
	P_MAX := xTON_P_LS_Hi.Q;

	
	(*------------------------------------------------------------------------------------*)	
	(* generator power low for load shedding warning *)
	xGR_MINR_P_LS_Lo(In:= IN_SY.rP_Act_Norm_Filt, Gw:= Para.rP_LS_LimLo, Hy:= Para.rP_LS_HyLo);
	xTON_P_LS_Lo(IN:= xGR_MINR_P_LS_Lo.Q AND IN_SY.tPB2MM.bParaSetupOk AND xOpMode.Island, PT:= Para.tiP_LS_LimLo);
	P_MIN_W := xTON_P_LS_Lo.Q; 


	(*------------------------------------------------------------------------------------*)	
	(* generator power low for load shedding trip *)	
	xGR_MINR_P_LS_LoLo(In:= IN_SY.rP_Act_Norm_Filt, Gw:= Para.rP_LS_LimLoLo, Hy:= Para.rP_LS_HyLoLo);
	xTON_P_LS_LoLo(IN:= xGR_MINR_P_LS_LoLo.Q AND IN_SY.tPB2MM.bParaSetupOk AND xOpMode.Island, PT:= Para.tiP_LS_LimLoLo);
	P_MIN_A := xTON_P_LS_LoLo.Q; 

	
	(*------------------------------------------------------------------------------------*)	
	(* load shedding - engine speed limit low *)
	xGR_MINR_N_LS_Lo(In:= IN_SY.rN_EngAct, Gw:= Para.rN_LS_LimLo, Hy:= Para.rN_LS_HyLo);
	xTON_N_LS_Lo(IN:= xGR_MINR_N_LS_Lo.Q AND IN_SY.tPB2MM.bParaSetupOk, PT:= Para.tiN_LS_LimLo);
	DR_MIN := xTON_N_LS_Lo.Q;

	
	(*------------------------------------------------------------------------------------*)	
	(*------------------------------------------------------------------------------*)				
	OUT_SY.tN_EngStart.Do 	:= bN_EngStart;		(* M_DREHZ *)					
	OUT_SY.tP_Lo.Do 		:= NOT bP_Lo;		// AN_LSA;
	

	(*------------------------------------------------------------------------------*) 
	(* load shedding demand for island operation*)
	bLS4I_Dem :=	IN_SY.tGCB_On.Di
			AND ( NOT OUT_SY.bMCB_On OR IN_SY.bBypassMCB_LoadShed)
			AND(    P_MAX 				 OR     DR_MIN                   OR     IN_SY.bP_Red_Active)
			AND(NOT IN_SY.bReq_PowMod OR NOT OUT_SY.bOtherGenParallel OR NOT(Para.iCountry = iPakistan)); 

	(* load shedding demand for blackout start *)
	bLS4BL_Dem :=	BLOUT 
			AND NOT OUT_SY.bOtherGenParallel 
			AND    (IN_SY.tEng_Run.Do OR NOT (Para.iCountry = iPakistan));  	
	
	(* load shedding demand *)
	OUT_SY.tLS_Dem.Do := bLS4I_Dem OR bLS4BL_Dem;


	(*------------------------------------------------------------------------------*)

										
END_PROGRAM
