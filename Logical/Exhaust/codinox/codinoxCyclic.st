(*******************************************************************************
codinox		codinox control

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	27.06.2001/LH		erstellt
V0.2	14.02.2003/Wa		Drehmomentschalter entfernt, Ausgabe WatchDog, 
 							Umschaltung CODINOX, Sammelstörung CO2
V190	29.07.2004/LH		überarbeitet für Modulisierung
V220	19.02.2007/LH		angepasst für X20-Einführung
V220.1	10.07.2007/Wa		-Vorbereitung für pneumatische CO2-Klappe
 							-Variante für Temp. nach WT2 über Pt100
 							-Deaktivierung der Störungen,
 			 				 wenn CODINOX über Parameter deaktiviert wird
 							-Blockierung CO2-Klappe hinzu
 							-Anzeige der Abgastemp in P50 aktivieren,
 			 				 falls kein Codinox vorhanden
V2.20.2	29.08.2008/PN		-Anzeige der Abgastemp in P50 entfernt,
 			 				da Anzeige im Bild P_312
V3.20.0	30.09.2010/MM(BuR)	M_GSEIN durch GCB_ON ersetzt
		30.09.2010/MM(BuR) 	gen_sch durch GCB_ON_TC1 ersetzt
		01.10.2010 MM(BuR) 	net_sch durch MCB_ON ersetzt
		17.12.2010 lettenb.	RESET_COV, RESET_CO2 removed, autoreset in task: alarms35xx
V4.00.0	18.02.2014			start/stop part load operation from new DI(gridcode)
V4.00.1	24.09.2014			tCO2_Alarm.Do,tCO2_Rdy.Do: old var changed, bugfix
V4.03.0	12.11.2015 Denk		Manual operating auxiliaries control - Handbedienebene for BEL/HOL

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* Variation codinox with pneumatic CO2 valve *)
	Para.bCO2_PneumVal;

	
	(* digital in from gridcode *)
								IN_EX.tP_GenC_SetEUCOn.Di; 		(* DI: request power value from EU - on (activate) *) (* OldName: DI_GCP_P_S; Cycle:HALioDi_Type; *)
								IN_EX.tP_GenC_SetEUCOf.Di; 		(* DI: request power value from EU - off (deactivate) *) (* OldName: DI_GCP_P_R; Cycle:HALioDi_Type; *)
	P_GenC_SetFixEU[1]		:=	IN_EX.tP_GenC_SetFix1EU.Di; 	(* DI: power value - P- fixvalue 1 from EU *) (* OldName: DI_GCP_P_FIX1; Cycle:HALioDi_Type; *)
	P_GenC_SetFixEU[2]		:=	IN_EX.tP_GenC_SetFix2EU.Di; 	(* DI: power value - P- fixvalue 2 from EU *) (* OldName: DI_GCP_P_FIX2; Cycle:HALioDi_Type; *)
	P_GenC_SetFixEU[3]		:=	IN_EX.tP_GenC_SetFix3EU.Di; 	(* DI: power value - P- fixvalue 3 from EU *) (* OldName: DI_GCP_P_FIX3; Cycle:HALioDi_Type; *)
	P_GenC_SetFixEU[4]		:=	IN_EX.tP_GenC_SetFix4EU.Di; 	(* DI: power value - P- fixvalue 4 from EU *) (* OldName: DI_GCP_P_FIX4; Cycle:HALioDi_Type; *)
	P_GenC_SetFixEU[5]		:=	IN_EX.tP_GenC_SetFix5EU.Di; 	(* DI: power value - P- fixvalue 5 from EU *) (* OldName: DI_GCP_P_FIX5; Cycle:HALioDi_Type; *)
								IN_EX.tPLim_GenC_SetEUCOn.Di; 	(* DI: setpoint power limitation (Plim) from EU - on (activate) *) (* OldName: DI_GCP_Plim_S; Cycle:HALioDi_Type; *)
								IN_EX.tPLim_GenC_SetEUCOf.Di; 	(* DI: setpoint power limitation (Plim) from EU - off (deactivate) *) (* OldName: DI_GCP_Plim_R; Cycle:HALioDi_Type; *)
	PLim_GenC_SetEUPFix[1]	:=	IN_EX.tPLim_GenC_SetEUPFix1.Di;	(* DI: power limitation fixvalue 1 *) (* OldName: DI_EVU_1; Cycle:HALioDi_Type; *)
	PLim_GenC_SetEUPFix[2]	:=	IN_EX.tPLim_GenC_SetEUPFix2.Di;	(* DI: power limitation fixvalue 2 *) (* OldName: DI_EVU_2; Cycle:HALioDi_Type; *)
	PLim_GenC_SetEUPFix[3]	:=	IN_EX.tPLim_GenC_SetEUPFix3.Di;	(* DI: power limitation fixvalue 3 *) (* OldName: DI_EVU_3; Cycle:HALioDi_Type; *)
	PLim_GenC_SetEUPFix[4]	:=	IN_EX.tPLim_GenC_SetEUPFix4.Di;	(* DI: power limitation fixvalue 4 *) (* OldName: DI_EVU_4; Cycle:HALioDi_Type; *)
	PLim_GenC_SetEUPFix[5]	:=	IN_EX.tPLim_GenC_SetEUPFix5.Di;	(* DI: power limitation fixvalue 5 *) (* OldName: DI_EVU_5; Cycle:HALioDi_Type; *)

	
	(* Codinox available *)
	IF NOT Para.bCodinox_Active THEN
	
		IN_EX.tT_CO2_Hi.Di        := FALSE;	
		CO2KLST_W 				  := FALSE;
		CO2KLST_A 				  := FALSE;
		IN_EX.tCO2_FanFailure.Di  := FALSE;
		IN_EX.tCO2_DevFailure.Di  := FALSE;

		OUT_EX.tCO2_Rdy.Do        := FALSE;	
		
	ELSE
	    (* Notification CO2_Exh flap closed  *)
	    M_KZU := IN_EX.tCO2_VaClosed.Di;
	
	    (* Notification CO2_Exh flap opened  *)
	    M_KAUF := IN_EX.tCO2_VaOpened.Di;
	
	    (* Release for CO2_Exh *)
	    FG_CO2 := Para.bCodinox_Active AND IN_EX.tGCB_On.Di AND NOT bGnlTrip AND NOT MM2VIS.bMsg3511;

		(* start/end part load operation *)
		bStartPartLoad := FALSE;
		bStopPartLoad  := FALSE;
	
		FOR x:=1 TO 5 DO
			xR_TRIG_P_GenC_SetFixEU[x](CLK:= P_GenC_SetFixEU[x]);
			xF_TRIG_P_GenC_SetFixEU[x](CLK:= P_GenC_SetFixEU[x]);
			xR_TRIG_PLim_GenC_SetEUPFix[x](CLK:= PLim_GenC_SetEUPFix[x]);
			xF_TRIG_PLim_GenC_SetEUPFix[x](CLK:= PLim_GenC_SetEUPFix[x]);
			
			IF xR_TRIG_P_GenC_SetFixEU[x].Q OR xR_TRIG_PLim_GenC_SetEUPFix[x].Q THEN bStartPartLoad := TRUE;
			END_IF;
			IF xF_TRIG_P_GenC_SetFixEU[x].Q OR xF_TRIG_PLim_GenC_SetEUPFix[x].Q THEN bStopPartLoad := TRUE;
			END_IF;
		END_FOR;
		
		(* interrupt demand codinox at start part load operation for xx sec *)
	    xTP_TEILLAST_START(IN:= bStartPartLoad, PT:= Para.tiCO2_ExPSp_StartOffTime);
		TEILLAST_START := xTP_TEILLAST_START.Q AND AUTO AND AWS_F;
			
	    (* interrupt demand codinox at end part load operation for xx sec *)
	    xTP_TEILLAST_ENDE(IN:= bStopPartLoad, PT:= Para.tiCO2_ExPSp_StopOffTime);
		TEILLAST_ENDE := xTP_TEILLAST_ENDE.Q AND AUTO AND AWS_F;
	
	    (* Demand CO2_Exh *)
	    xTON_AFCO2(IN:= FG_CO2 AND IN_EX.tCO2_Demand.Di AND NOT TEILLAST_START AND NOT TEILLAST_ENDE, PT:= T#5s);
		AF_CO2 := xTON_AFCO2.Q;
	
	    (* Demand CODINOX *)
	    xRS_ANF_CODI.SET := xTON_AFCO2.Q;
		xRS_ANF_CODI.RESET1 := NOT AF_CO2 AND (M_KZU OR MM2VIS.bMsg3314);	
		xRS_ANF_CODI();
	    OUT_EX.tCO2_DemCodinox.Do := xRS_ANF_CODI.Q1 
									 OR IN_EX.tManAuxCtr.bCO2_DemCodinox;	(* Manual operating auxiliaries control - Handbedienebene *)
	
	    (* Demand CO2_Exh flap advance open *)
	    xTOF_AFKAUF(IN:= AF_CO2 AND IN_EX.tCodinox_Rdy.Di AND NOT IN_EX.tCO2_VaLockout.Di, PT:= T#1s);
		AF_KAUF := xTOF_AFKAUF.Q;
	
	    (* command CO2_Exh flap open *)
		B_KAUF := 	Para.bCodinox_Active 
			AND NOT MM2VIS.bMsg3314 
			AND NOT MM2VIS.bMsg3512 
			AND 	AF_KAUF 
			AND NOT B_KZU 
			AND(NOT M_KAUF OR Para.bCO2_PneumVal);
	
	    (* command CO2 flap close *)
		B_KZU :=	Para.bCodinox_Active 
			AND NOT MM2VIS.bMsg3314 
			AND NOT AF_KAUF 
			AND NOT B_KAUF 
			AND NOT M_KZU;
	
	    (* Command CO2 flap open *)
		xTON_CO2KAUF(IN := B_KAUF, PT := T#0.5s);
		OUT_EX.tCO2_VaCoOpen.Do := xTON_CO2KAUF.Q;
	
	    (* Command CO2 flap close *)
	    xTON_CO2KZU(IN:= B_KZU, PT:= T#0.5s);
		OUT_EX.tCO2_VaCoClose.Do := xTON_CO2KZU.Q;
	
	    (* CO2 Fan ON *)
	    OUT_EX.tCO2_FanCoOn.Do := AF_KAUF AND M_KAUF AND NOT MM2VIS.bMsg3510;
		
	    (* CO2 Flap disturbance *)
	    xTON_KLST_a(IN:= NOT M_KZU AND OUT_EX.tCO2_VaCoClose.Do, PT:= T#35s);
		ZM_KLSTA := xTON_KLST_a.Q;
	
	    xTON_KLST_b(IN := NOT IN_EX.tCO2_VaFailure.Di, PT:= T#2s);
		HM_KLST  := xTON_KLST_b.Q;
	
	    (* CO2 Flap disturbance with Flap-Close command stoppage *)
	    CO2KLST_A := ZM_KLSTA OR (HM_KLST AND M_KAUF);
	
	    (* Flap disturbance stoppage *)
		xTON_KLST(IN:= NOT M_KAUF AND OUT_EX.tCO2_VaCoOpen.Do, PT:= T#35s);
		CO2KLST_W := xTON_KLST.Q OR (HM_KLST AND NOT M_KAUF);
	
	    (* Warning flap disturbance *)
	    OUT_EX.tCO2_MPMode.Do := Para.bCodinox_Active AND IN_EX.tGCB_On.Di AND IN_EX.tMCB_On.Di;
	
	    (* WatchDog *)
	    OUT_EX.tCO2_WD.Do := IN_EX.tCodinox_Rdy.Di;
	
	    (*Störung CO2_Exh*)
	    OUT_EX.tCO2_Alarm.Do := MM2VIS.bMsg3313 OR MM2VIS.bMsg3314 OR MM2VIS.bMsg3510 OR MM2VIS.bMsg3511 OR MM2VIS.bMsg3512;
	    OUT_EX.tCO2_Rdy.Do   := NOT OUT_EX.tCO2_Alarm.Do;
	    CODINOX := TRUE;
	
	END_IF;
	
	
	(* out interfaces *)	
	OUT_EX.rT_EGaHE1 := IN_EX.tT_EGaHE1.Ai;
	OUT_EX.rT_EGaHE2 := IN_EX.tT_EGaHE2.Ai;


END_PROGRAM
