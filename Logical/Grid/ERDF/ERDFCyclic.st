(*********************************************************************************************
AGGR: ERDF task (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019


Customized modifications: -
------------------------
 
History:
-------
 V0.1:  Kirchler 02.05.2012: Anwahl Leistungsvorgabe durch ERDF aucb wenn Sollwert über BUS
 							 Signal Aggregat nicht verfügbar wird nicht gesetzt wenn A_ANF fehlt  
 V0.2:  Kirchler 17.07.2012: Komplett umgebaut laut vorgabe Clarke; Alle eingänge auf Impuls/flankenauswertung
 							 Leistungsvorgabe und Blindleistungsvorgabe als Reduktion (maximum)
							 RSE Signal implementiert		
 V0.3:	Kirchler 13.09.2012: ERDF Schnittstellen aktiv auch im Handbetrieb
 							 Merken der aktuell ausgewählten Cosphi Funktion und nach Beendigung Q0 LIMIT wieder auf alten Wert stellen	
							 Vereinfachungen Teil P0- und Q0-Limitierungen 
 V0.4:  Kirchler 25.10.2012: Q0 Limitierung Set nur möglich wenn Q0 inaktiv und Reset nur möglich wenn Q0 aktiv.
 							 Verhindert QPF Funktions-Parameter Überschreibungen 
							 Wenn Q0_max grösser aktuelle Blindleistung einfach auf alten Cosphi modus zurückschalten
 V0.5:  Adami 07.11.2012: 	 Fehler behoben mit der Netzstörung >50 Sek und der Entkopplung vom netz durch DEIE. Die 2 Funktionen blockierten sich gegenseitig, dadurch
 							 konnte man keine der beiden mehr resetten und die Maschine nicht mehr starten	(außer durch einen Neustart der Diane)
 							 Funktionsänderung der Variablen "DO_NotReady ". Dieser Ausgang dient jetzt als "watchdog", d.h der Ausgang soll immer "1" sein sobald die SPS läuft.
							 Anpassung Blindleistungsreduzierung
 V0.6   Kirchmair 06.02.2014:Erestzen der Variable DI_EVU_3 durch DI_EVU_BLOCK, da sich die Funktion der Variable DI_EVU_3 geändert hat (seit V3.4) und jetzt nicht mehr verwendbar ist.
 
 V4.00.0 28-04-2014 Maxhera/Waldhart,   implementation OF the module FOR modular software
 V4.03.0 15-03-2016	Perktold,	update FOR 4.3.0.0
 V4.04.0 06-10-2016	Perktold,	update FOR 4.4.0.0 (tiDelayDEIE, IN_GR.tPLim_DEIE.Ai)
		 09.10.2019	lettenb.	div.by zero bugfix, bu01

Instructions FOR use:
--------------------
- 
Outstandings:
-------------
*********************************************************************************************)

PROGRAM _CYCLIC

IF Para.bDEIE_Active THEN
(* requirement coupling / decoupling from EU (ERDF), Digital inputs *)
	xSR_MCB_Dcp(SET1 := IN_GR.tMCB_Dcp_SetEUCOn.Di, RESET := IN_GR.tMCB_Dcp_SetEUCOf.Di);
	bMCB_Dcp		 := xSR_MCB_Dcp.Q1;

(* feedback Receive requested Command form machine*)
	IF bMCB_Dcp THEN 						(* True --> hier wird der motor abgefordert *)
		OUT_GR.tMCB_SOn.Do 		:= TRUE;	(* rückmeldung für abforderung *)
		OUT_GR.tERDF_BLOCK.Do 	:= TRUE;   	(* TRUE = abforderung des Motors *)
 	ELSE									(* motor ist wieder freigegeben *)
		OUT_GR.tMCB_SOn.Do		:= FALSE;
		OUT_GR.tERDF_BLOCK.Do 	:= FALSE; 	(* FALSE = keine abforderung des motors durch erdf  *)
	END_IF;

(* =====================================================================*)

(* Freigabe Kopplung ans Netz durch ERDF / Release coupling to the grid by ERDF *)
	xTON_GTE(IN :=  NOT IN_GR.tMnsOk_GTE.Di, PT := Para.tiDelayDEIE);   (* network trouble after X[s]  *)
	xSR_MCB_RelSync(SET1 := IN_GR.tMCB_Rel_Sync.Di, RESET := xTON_GTE.Q);
	bMCB_RelSync := xSR_MCB_RelSync.Q1; (* FALSE = Motor soll blockieren *)

	TP_Msg2888(IN := bMCB_RelSync, PT := T#15s);
	bMsg2888	:= TP_Msg2888.Q;

	IF bMCB_RelSync THEN		(* True --> freigabe für sy erteilt --> keine blockierung *)
		OUT_GR.bOpAlm_ERDF_SY	:= OUT_GR.tMCB_Rel_Sync_SOn.Do := TRUE;	(* rückmeldung und betiebsmeldung abgesetzt *)
	ELSE
		OUT_GR.bOpAlm_ERDF_SY	:= OUT_GR.tMCB_Rel_Sync_SOn.Do := FALSE;
	END_IF;
(* =====================================================================*)

(*  DO: Generator ist eingeschaltet / Generator switch is on *) 
	OUT_GR.tGCB_SOn.Do 			:= IN_GR.tGCB_On.Di;
(* =====================================================================*)

(* Fast decoupled by ERDF / Schnelles entkoppeln durch ERDF	*)
(* requirement coupling / decoupling quickly from EU (ERDF), Digital inputs *)
	xSR_MCB_DcpQu(SET1 := IN_GR.tMCB_DcpQu_SetEUCOn.Di, RESET := IN_GR.tMCB_DcpQu_SetEUCOf.Di);
	bMCB_DcpQu	  := xSR_MCB_DcpQu.Q1;

	IF bMCB_DcpQu THEN
		OUT_GR.bOpAlm_DecQu 	:= TRUE;
		OUT_GR.tMCB_EDF_SOn.Do	:= TRUE;
	ELSE
		OUT_GR.bOpAlm_DecQu 	:= FALSE;
		OUT_GR.tMCB_EDF_SOn.Do	:= FALSE;
	END_IF;
(* =====================================================================*)

(*Customers switch for bridging P0 signal / Kundenschalter zur Überbrückung P0 Signal*)
	IF IN_GR.tP0_BLOCK_DEIE.Di THEN			
		IN_GR.tPLim_GenC_SetEU.Ai 	:= Para.rP_Set_ExtAI_NormScalMax;
	ELSE
		IN_GR.tPLim_GenC_SetEU.Ai  	:= IN_GR.tP_DEIE.Ai;
	END_IF;

	IF bGCP_PLim AND NOT IN_GR.tP0_BLOCK_DEIE.Di THEN
		OUT_GR.bOpMsg_Plim_ERDF_SOnOf	:= TRUE;
	END_IF;
	
	IF NOT bGCP_PLim OR  IN_GR.tP0_BLOCK_DEIE.Di THEN
		OUT_GR.bOpMsg_Plim_ERDF_SOnOf	:= FALSE;
	END_IF;


(* powerlimit from ERDF / Leistung reduktion von ERDF *)
	IF  OUT_GR.tPLim_GenC_SOn.Do AND  (IN_GR.tPLim_GenC_SetEU.Ai< (IN_GR.rP_Nom * 0.5)) THEN	(* abforderung des motors sollte die leistungsreduktion < 50% sein *)
		OUT_GR.bOpMsg_Plim_ERDF_ABF_SOnOf	:= TRUE;		(* true = abforderung des Motors *)
	ELSE
		OUT_GR.bOpMsg_Plim_ERDF_ABF_SOnOf 	:= FALSE;
		IN_GR.tPLim_GenC_SetEU.Ai	  		:= LIMIT ((IN_GR.rP_Nom * 0.5), IN_GR.tPLim_GenC_SetEU.Ai,IN_GR.rP_Nom);
		rP_Red_ERDF_Lim			 	  		:= IN_GR.tPLim_GenC_SetEU.Ai / MAX(1, IN_GR.rP_Nom);
	END_IF;
	IF NOT OUT_GR.tPLim_GenC_SOn.Do THEN					(* no powerlimit from ERDF / keine Leistung reduktion über ERDF *)
		rP_Red_ERDF_Lim						:= 1.0; 		(* maximum power / maximale Leistung *)
		OUT_GR.bOpMsg_Plim_ERDF_SOnOf  		:= FALSE;
	END_IF;


(* =====================================================================*)

	IF (bGenC_QLim_ExtRel  OR IN_GR.tP0_BLOCK_DEIE.Di) AND OUT_GR.tQLim_GenC_SOn.Do  THEN
		OUT_GR.bOpMsg_Qlim_ERDF_SOnOf	:= FALSE;
	END_IF

(* =====================================================================*)
// RSE
 (* requirement coupling / decoupling RSE from EU (ERDF), Digital inputs *)
	xSR_RSE(SET1 := IN_GR.tRSE_SetEUCOn.Di, RESET := IN_GR.tRSE_SetEUCOf.Di);
	bRSE	  := xSR_RSE.Q1;

	IF bRSE THEN
		OUT_GR.tRSE_SOn.Do := FALSE;
	ELSE
		OUT_GR.tRSE_SOn.Do := TRUE;
	END_IF;
(* =====================================================================*)

(* =====================================================================*)
	IF OUT_GR.tRSE_SOn.Do THEN
		OUT_GR.bOpMsg_RSE_SOnOf := FALSE;
	END_IF;

	IF NOT OUT_GR.tRSE_SOn.Do THEN
		OUT_GR.bOpMsg_RSE_SOnOf := TRUE;
	END_IF;

// Signal Aggregat verfügbar an ERDF 
// Achtung: war früher "Aggregat NICHT Verfügbar", die Logik musste aber umgedreht werden dass der Ausgang 1 ist wenn das Aggregat Verfügbar
// ist, das SPS Label blieb aber gleich damit man den ERDF TAsk einfach austauschen kann ohne die SPS Belegung ändern zu müssen!

	IF IN_GR.tPB2MM.bParaSetupOk THEN 
		OUT_GR.tEng_Ready.Do := TRUE;
	ELSE
		OUT_GR.tEng_Ready.Do := FALSE;
	END_IF;
(* =====================================================================*)
(* Output signals interface *)
	OUT_GR.bOpAlm_DecQu;
	OUT_GR.bOpAlm_MSF_P0 		:=	 OUT_GR.tPLim_GenC_SOn.Do AND NOT IN_GR.tP0_BLOCK_DEIE.Di;
	OUT_GR.bOpAlm_ERDF_SY;

	OUT_GR.bOpMsg_Plim_ERDF_SOnOf;
	OUT_GR.bOpMsg_Qlim_ERDF_SOnOf;
	
	TP_Msg2889(IN := NOT OUT_GR.bOpMsg_Qlim_ERDF_SOnOf, PT := T#15s);
	bMsg2889					:= TP_Msg2889.Q;

	OUT_GR.bOpMsg_RSE_SOnOf;
	OUT_GR.bOpMsg_P0_BLOCK_DEIE_SOnOf := IN_GR.tP0_BLOCK_DEIE.Di;
ELSE 
	OUT_GR.tMCB_Rel_Sync_SOn.Do := TRUE;	(* rückmeldung und betiebsmeldung abgesetzt *)
END_IF

END_PROGRAM


