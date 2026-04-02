(*******************************************************************************
AGGR: static GridCode - frequency control (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2022

- alle Funktionen welche im Rahmen des statischen GridCodes auf die Wirkleistung einwirken

Customized modifications: -
------------------------
 
History:
-------
V3.40.0	14-02-2013	Perktold,  generated
V4.0.0 22-08-2013   Maxhera,   implementation of the module for modular software
V4.0.0 06-11-2013   Waldhard/Maxhera external power setpoint via digital input related to rP_Nom  
									 power limitation according external request from utility (EU)
									 EU P-Limitierung ueber Analogsignal bzw. BUS einschleifen
									 limits for feedback signals to utility
									 Freigabe schnelle Lastrampe bei EU Zugriff auf Leistungsvorgabe
		15.06.2015	Caks,		changed names
V4.03.0 12-11-2015 	Zengerer	REMOVE OUT_GR.rP_Set_ExtDI_Norm	:=	1.0; here, since this FUNCTION IS MOVED BACK TO MM Customized
		30-11-2015	Caks,		bugfix laut Lukas Vogl
		15-12-2015	Perktold, 	diverse Korrekturen nach Validierung am 412er TC
		12-01-2016	Perktold, 	Hysterese fuer Rueckmeldesignale der Leistungsreduktionen von 1 auf 5% Pnom gesteigert
V4.04.0	06-10-2016	Perktold	changed ERDF to DEIE
V4.04.1 02-11-2016  Gwiggner    add frequency control logic
V4.04.2 12-09-2017  Gwiggner    update for frequency control
V4.05.0 12-07-2017  Farre,		FC: Introduction Neg Margine Parameter FOR Standard Input & Power step recovery after dead-band (Italian grid code)
        10-08-2017  Farre,		FC: Bug fix - delta Frequency for internal operation should not be limited
		20-10-2017  Farre, 		FC: Remove Power Minimum limitation for activating and de-activating the FC function
								FC: connect actual frequency to the 15-MA filter defined in c-fc task
		07-12-2017	Farre,		Addtion new function P(U), modification function arbitration between LFSMO - LFSMU - FSM - P(U)
		06-02-2018	Farre,		Addition of 10min timer using slow ramp after LFSM de-activation
V4.05.1	08-03-2018	Farre,		Modification of LFSM ramp para, after LFSM ramp para and para limitations (VDE Jan'18)
		12-06-2018	502423184	Added Interface OUT_GR.bPRamp_GrC_SetErr
V4.06.0	06-08-2018	Zuschnig,	added signal loss function for P_Set and P_Lim
V4.07.0 25-03-2019  Zuschnig,   Added Parameter from AI or Bus
		09.10.2019	lettenb.	div.by zero bugfix, bu01
V4.09.0	20.11.2019	lettenb.	parameter for power ramp rate after EU added, PLim deadband 0.5% to avoid Pred.display due to mA jitter
		24.04.2020	Zuschnig,	Change limitation of parametervalue for FSM/LFSM and U-Droop
V4.10.0	28.09.2020	Zuschnig,	Set default value of external power setpoint via digital input
		12.11.2020	Lettenb.	ramp after grid connection added
		14.12.2020	lettenb.	Para.rPRamp_GrC_SetLFSMPar replaced by Para.rPRampDown_LFSMU, Para.rPRampDown_LFSMO, Para.rPRampUp_LFSMU, Para.rPRampUp_LFSMO
								engine type depending PRamp limitation removed
		21.01.2021	lettenb.	MM2VIS.rGCP_Plim_AI-> MM2VIS.rGCP_PLim_AI corr.for VIS diagnosis, bugfix
V4.11.0 29.11.2021	lettenb.	Para.bLFSM_StaticFSMDeadband added, use FSM border value for start LFSMO/U(romania)
								bLFSM_TestEnable: avoid LFSM_TestStop during test by autoreset iPassLevel
								IN_GR.tDI_Dem_EU_Block.Di: IN_GR.bEng_Block_EVU(blocking via bus/AB energy) added, bugfix
V4.12.0 19.12.2022	lettenb.	power setpoint change during active FSM mode not allowed, bugfix #924(Aggreko/Dumbarton)
		21.12.2022	lettenb.	xTON_RelCalc_PRamp_FC added, delayed use of calculated power ramp after engine demand, #925(blumendorf)
								Para.bPRamp_FC_ExtInp removed, because not anymore visible on HMI, cleanup
V4.13.0 02.08.2023	Farre,		FSM delta P limitation positive and negative via parameters
		20.11.2023	Farre,		Remote FSM & FSM dead band limit. Replaced Para.rP_Set_Min_Norm by interface coming from OP. (2023-168)
		28.11.2023	Farre,		ILF (local frequency integrator) functionality added
		30.11.2023	Goenczi		Add FSM test interfaces via BUS initiation
								bPFC_SOn_Bus, bPFC_SOf_Bus added, bugfix
		22.12.2023	Farre,		issue #1332: Wrong power set ramp used when FSM enabled but Op. Point in FSM dead-band
		07.03.2024	Farre,		issue #890, #1089: delete scaling analog input signals and shifted to HalIO

Instructions for use:
--------------------
- 

Outstandings:
-------------

*******************************************************************************)
PROGRAM _CYCLIC

	(********************************************************************************************)
	(************************* Parameter External************************************************)
	(********************************************************************************************)
	(************************* Deadband LFSMO ***************************************************)
	(* Frequency Limit LFSMO on/off from Digital inputs *)
	xSR_LFMSO_GRC_DB_pos(SET1 := IN_GR.tCU2GR.bLFSMO_DB_AI_COn, RESET := IN_GR.tCU2GR.bLFSMO_DB_AI_COf);
	bGCP_LFMSO_GRC_DB_pos  := xSR_LFMSO_GRC_DB_pos.Q1;

	(* request Deadband LFSMO from bus - on/off	*)
	xSR_BC_LFMSO_GRC_DB_pos(SET1 := IN_GR.tCU2GR.bLFSMO_DB_BC_COn, RESET := IN_GR.tCU2GR.bLFSMO_DB_BC_COf); 
	bBC_GCP_LFMSO_GRC_DB_pos := xSR_BC_LFMSO_GRC_DB_pos.Q1;

	IF bGCP_LFMSO_GRC_DB_pos AND IN_GR.tHA2GR.tF_LFSMO_DB.GoodQual THEN
		rF_LFSMO_GrC_DB_pos := LIMIT(0.1, IN_GR.tHA2GR.tF_LFSMO_DB.Ai, 4.0);
	ELSIF bBC_GCP_LFMSO_GRC_DB_pos AND NOT IN_GR.tCU2GR.bLFSMO_DB_BC_SetErr AND NOT IN_GR.tCU2GR.bLFSMO_DB_AI_COn THEN
	 	rF_LFSMO_GrC_DB_pos := LIMIT(0.1, IN_GR.tCU2GR.rF_LFSMO_DB_BC, 4.0);
	ELSE
		rF_LFSMO_GrC_DB_pos := Para.rF_LFSMO_GrC_DeadBand_pos;
	END_IF;	
	
	IF (bGCP_LFMSO_GRC_DB_pos AND NOT IN_GR.tHA2GR.tF_LFSMO_DB.GoodQual) OR (bBC_GCP_LFMSO_GRC_DB_pos AND IN_GR.tCU2GR.bLFSMO_DB_BC_SetErr) THEN
		bMsg9261 := TRUE;
	ELSE
		bMsg9261 := FALSE;
	END_IF;
	(************************* Deadband LFSMU****************************************************)
	(* Frequency Limit LFSMU on/off from Digital inputs *)
	xSR_LFMSU_GRC_DB_neg(SET1 := IN_GR.tCU2GR.bLFSMU_DB_AI_COn, RESET := IN_GR.tCU2GR.bLFSMU_DB_AI_COf);
	bGCP_LFMSU_GRC_DB_neg  := xSR_LFMSU_GRC_DB_neg.Q1;

	(* request Deadband LFSMU from bus - on/off	*)
	xSR_BC_LFMSU_GRC_DB_neg(SET1 := IN_GR.tCU2GR.bLFSMU_DB_BC_COn, RESET := IN_GR.tCU2GR.bLFSMU_DB_BC_COf);
	bBC_GCP_LFMSU_GRC_DB_neg := xSR_BC_LFMSU_GRC_DB_neg.Q1;

	IF bGCP_LFMSU_GRC_DB_neg AND IN_GR.tHA2GR.tF_LFSMU_DB.GoodQual THEN
		rF_LFSMU_GrC_DB_neg := LIMIT(-3.0, IN_GR.tHA2GR.tF_LFSMU_DB.Ai, -0.1);
	ELSIF bBC_GCP_LFMSU_GRC_DB_neg AND NOT IN_GR.tCU2GR.bLFSMU_DB_BC_SetErr AND NOT IN_GR.tCU2GR.bLFSMU_DB_AI_COn THEN
	 	rF_LFSMU_GrC_DB_neg := LIMIT(-3.0, IN_GR.tCU2GR.rF_LFSMU_DB_BC, -0.1);
	ELSE
		rF_LFSMU_GrC_DB_neg := Para.rF_LFSMU_GrC_DeadBand_neg;
	END_IF;	
	
	IF (bGCP_LFMSU_GRC_DB_neg AND NOT IN_GR.tHA2GR.tF_LFSMU_DB.GoodQual) OR (bBC_GCP_LFMSU_GRC_DB_neg AND IN_GR.tCU2GR.bLFSMU_DB_BC_SetErr) THEN
		bMsg9262 := TRUE;
	ELSE
		bMsg9262 := FALSE;
	END_IF;
	(************************* Positive droop LFSMO********************************************)
	(* Positive droop LFSMO on/off from Digital inputs *)
	xSR_Droop_GrC_LFSMO_pos(SET1 := IN_GR.tCU2GR.bLFSMO_Droop_AI_COn, RESET := IN_GR.tCU2GR.bLFSMO_Droop_AI_COf);
	bGCP_Droop_GrC_LFSMO_pos  := xSR_Droop_GrC_LFSMO_pos.Q1;

	(* request Positive droop LFSMO from bus - on/off	*)
	xSR_BC_Droop_GrC_LFSMO_pos(SET1 := IN_GR.tCU2GR.bLFSMO_Droop_BC_COn, RESET := IN_GR.tCU2GR.bLFSMO_Droop_BC_COf);
	bBC_Droop_GrC_LFSMO_pos := xSR_BC_Droop_GrC_LFSMO_pos.Q1;

	IF bGCP_Droop_GrC_LFSMO_pos AND IN_GR.tHA2GR.tF_LFSMO_Droop.GoodQual THEN
		rDroop_GrC_LFSMO_pos := LIMIT(0.4, IN_GR.tHA2GR.tF_LFSMO_Droop.Ai, 20.0) / 100;
	ELSIF bBC_Droop_GrC_LFSMO_pos AND NOT IN_GR.tCU2GR.bLFSMO_Droop_BC_SetErr AND NOT IN_GR.tCU2GR.bLFSMO_Droop_AI_COn THEN
	 	rDroop_GrC_LFSMO_pos := LIMIT(0.4, IN_GR.tCU2GR.rP_LFSMO_Droop_BC, 20.0) / 100;
	ELSE
		rDroop_GrC_LFSMO_pos := MAX(0.001, Para.rDroop_GrC_LFSMO_pos);
	END_IF;	
	
	IF (bGCP_Droop_GrC_LFSMO_pos AND NOT IN_GR.tHA2GR.tF_LFSMO_Droop.GoodQual) OR (bBC_Droop_GrC_LFSMO_pos AND IN_GR.tCU2GR.bLFSMO_Droop_BC_SetErr) THEN
		bMsg9263 := TRUE;
	ELSE
		bMsg9263 := FALSE;
	END_IF;
	(************************* Negative droop LFSMU********************************************)
	(* Negative droop LFSMU on/off from Digital inputs *)
	xSR_Droop_GrC_LFSMU_neg(SET1 := IN_GR.tCU2GR.bLFSMU_Droop_AI_COn, RESET := IN_GR.tCU2GR.bLFSMU_Droop_AI_COf);
	bGCP_Droop_GrC_LFSMU_neg  := xSR_Droop_GrC_LFSMU_neg.Q1;

	(* request Negative droop LFSMU from bus - on/off	*)
	xSR_BC_Droop_GrC_LFSMU_neg(SET1 := IN_GR.tCU2GR.bLFSMU_Droop_BC_COn, RESET := IN_GR.tCU2GR.bLFSMU_Droop_BC_COf);
	bBC_Droop_GrC_LFSMU_neg := xSR_BC_Droop_GrC_LFSMU_neg.Q1;

	IF bGCP_Droop_GrC_LFSMU_neg AND IN_GR.tHA2GR.tF_LFSMU_Droop.GoodQual THEN
		rDroop_GrC_LFSMU_neg := LIMIT(0.4, IN_GR.tHA2GR.tF_LFSMU_Droop.Ai, 20.0) / 100;
	ELSIF bBC_Droop_GrC_LFSMU_neg AND NOT IN_GR.tCU2GR.bLFSMU_Droop_BC_SetErr AND NOT IN_GR.tCU2GR.bLFSMU_Droop_AI_COn THEN
	 	rDroop_GrC_LFSMU_neg := LIMIT(0.4, IN_GR.tCU2GR.rP_LFSMU_Droop_BC, 20.0) / 100;
	ELSE
		rDroop_GrC_LFSMU_neg := MAX(0.001, Para.rDroop_GrC_LFSMU_neg);
	END_IF;	
		
	IF (bGCP_Droop_GrC_LFSMU_neg AND NOT IN_GR.tHA2GR.tF_LFSMU_Droop.GoodQual) OR (bBC_Droop_GrC_LFSMU_neg AND IN_GR.tCU2GR.bLFSMU_Droop_BC_SetErr) THEN
		bMsg9264 := TRUE;
	ELSE
		bMsg9264 := FALSE;
	END_IF;
	(************************* Droop FSMU********************************************************)
	(* Droop FSMU on/off from Digital inputs *)
	xSR_Droop_GrC_FSMU(SET1 := IN_GR.tCU2GR.bFSMU_Droop_AI_COn, RESET := IN_GR.tCU2GR.bFSMU_Droop_AI_COf);
	bGCP_Droop_GrC_FSMU  := xSR_Droop_GrC_FSMU.Q1;

	(* request Droop FSMU from bus - on/off	*)
	xSR_BC_Droop_GrC_FSMU(SET1 := IN_GR.tCU2GR.bFSMU_Droop_BC_COn, RESET := IN_GR.tCU2GR.bFSMU_Droop_BC_COf);
	bBC_Droop_GrC_FSMU := xSR_BC_Droop_GrC_FSMU.Q1;

	IF bGCP_Droop_GrC_FSMU AND IN_GR.tHA2GR.tF_FSMU_Droop.GoodQual THEN
		OUT_GR.tGR2CU.rDroop_GrC_FSMU := LIMIT(2.0, IN_GR.tHA2GR.tF_FSMU_Droop.Ai, 12.0) / 100;
	ELSIF bBC_Droop_GrC_FSMU AND NOT IN_GR.tCU2GR.bFSMU_Droop_BC_SetErr AND NOT IN_GR.tCU2GR.bFSMU_Droop_AI_COn THEN
	 	OUT_GR.tGR2CU.rDroop_GrC_FSMU := LIMIT(2.0, IN_GR.tCU2GR.rP_FSMU_Droop_BC, 12.0) / 100;
	ELSE
		OUT_GR.tGR2CU.rDroop_GrC_FSMU := MAX(0.001, Para.rDroop_FC_pos);
	END_IF;	
			
	IF (bGCP_Droop_GrC_FSMU AND NOT IN_GR.tHA2GR.tF_FSMU_Droop.GoodQual) OR (bBC_Droop_GrC_FSMU AND IN_GR.tCU2GR.bFSMU_Droop_BC_SetErr) THEN
		bMsg9265 := TRUE;
	ELSE
		bMsg9265 := FALSE;
	END_IF;
	(************************* Droop FSMO********************************************************)
	(* Droop FSMO on/off from Digital inputs *)
	xSR_Droop_GrC_FSMO(SET1 := IN_GR.tCU2GR.bFSMO_Droop_AI_COn, RESET := IN_GR.tCU2GR.bFSMO_Droop_AI_COf);
	bGCP_Droop_GrC_FSMO  := xSR_Droop_GrC_FSMO.Q1;

	(* request Droop FSMO from bus - on/off	*)
	xSR_BC_Droop_GrC_FSMO(SET1 := IN_GR.tCU2GR.bFSMO_Droop_BC_COn, RESET := IN_GR.tCU2GR.bFSMO_Droop_BC_COf);
	bBC_Droop_GrC_FSMO := xSR_BC_Droop_GrC_FSMO.Q1;

	IF bGCP_Droop_GrC_FSMO AND IN_GR.tHA2GR.tF_FSMO_Droop.GoodQual THEN
		OUT_GR.tGR2CU.rDroop_GrC_FSMO := LIMIT(2.0, IN_GR.tHA2GR.tF_FSMO_Droop.Ai, 12.0) / 100;
	ELSIF bBC_Droop_GrC_FSMO AND NOT IN_GR.tCU2GR.bFSMO_Droop_BC_SetErr AND NOT IN_GR.tCU2GR.bFSMO_Droop_AI_COn THEN
	 	OUT_GR.tGR2CU.rDroop_GrC_FSMO := LIMIT(2.0, IN_GR.tCU2GR.rP_FSMO_Droop_BC, 12.0) / 100;
	ELSE
		OUT_GR.tGR2CU.rDroop_GrC_FSMO := MAX(0.001, Para.rDroop_FC_neg);
	END_IF;	
				
	IF (bGCP_Droop_GrC_FSMO AND NOT IN_GR.tHA2GR.tF_FSMO_Droop.GoodQual) OR (bBC_Droop_GrC_FSMO AND IN_GR.tCU2GR.bFSMO_Droop_BC_SetErr) THEN
		bMsg9266 := TRUE;
	ELSE
		bMsg9266 := FALSE;
	END_IF;
	(************************* Dead band FSMU********************************************************)
	(* Dead band FSMU on/off from Digital inputs *)
	xSR_FSMU_GRC_DB(SET1 := IN_GR.tCU2GR.bFSMU_DB_AI_COn, RESET := IN_GR.tCU2GR.bFSMU_DB_AI_COf);
	bGCP_FSMU_GRC_DB  := xSR_FSMU_GRC_DB.Q1;

	(* request Dead band FSMU from bus - on/off	*)
	xSR_BC_FSMU_GRC_DB(SET1 := IN_GR.tCU2GR.bFSMU_DB_BC_COn, RESET := IN_GR.tCU2GR.bFSMU_DB_BC_COf);
	bBC_FSMU_GRC_DB := xSR_BC_FSMU_GRC_DB.Q1;

	(* FSM & LFSM remote dead band limit needed by Microgrid applications *)
	IF IN_GR.bDroopDB_Active THEN
		rDB_FSM_LFSM_Max := LIMIT(0.0, IN_GR.rDB_FSM_LFSM, MAX(1.0, 0.02 * IN_GR.rF_Ref));
	ELSE
		rDB_FSM_LFSM_Max := 0.5; // Hz (i.e. the standard/default limit)
	END_IF
	
	IF bGCP_FSMU_GRC_DB AND IN_GR.tHA2GR.tF_FSMU_DB.GoodQual THEN
		OUT_GR.tGR2CU.rFSMU_GRC_DB := LIMIT(0.0, IN_GR.tHA2GR.tF_FSMU_DB.Ai, rDB_FSM_LFSM_Max);
	ELSIF bBC_FSMU_GRC_DB AND NOT IN_GR.tCU2GR.bFSMU_DB_BC_SetErr AND NOT IN_GR.tCU2GR.bFSMU_DB_AI_COn THEN
	 	OUT_GR.tGR2CU.rFSMU_GRC_DB := LIMIT(0.0, IN_GR.tCU2GR.rF_FSMU_DB_BC, rDB_FSM_LFSM_Max);
	ELSE
		OUT_GR.tGR2CU.rFSMU_GRC_DB := Para.rF_FC_Deadband_pos;
	END_IF;	
					
	IF (bGCP_FSMU_GRC_DB AND NOT IN_GR.tHA2GR.tF_FSMU_DB.GoodQual) OR (bBC_FSMU_GRC_DB AND IN_GR.tCU2GR.bFSMU_DB_BC_SetErr) THEN
		bMsg9267 := TRUE;
	ELSE
		bMsg9267 := FALSE;
	END_IF;
	(************************* Dead band FSMO********************************************************)
	(* Dead band FSMO on/off from Digital inputs *)
	xSR_FSMO_GRC_DB(SET1 := IN_GR.tCU2GR.bFSMO_DB_AI_COn, RESET := IN_GR.tCU2GR.bFSMO_DB_AI_COf);
	bGCP_FSMO_GRC_DB  := xSR_FSMO_GRC_DB.Q1;

	(* request Dead band FSMO from bus - on/off	*)
	xSR_BC_FSMO_GRC_DB(SET1 := IN_GR.tCU2GR.bFSMO_DB_BC_COn, RESET := IN_GR.tCU2GR.bFSMO_DB_BC_COf);
	bBC_FSMO_GRC_DB := xSR_BC_FSMO_GRC_DB.Q1;

	IF bGCP_FSMO_GRC_DB AND IN_GR.tHA2GR.tF_FSMO_DB.GoodQual THEN
		OUT_GR.tGR2CU.rFSMO_GRC_DB := LIMIT(0.0, IN_GR.tHA2GR.tF_FSMO_DB.Ai, rDB_FSM_LFSM_Max);
	ELSIF bBC_FSMO_GRC_DB AND NOT IN_GR.tCU2GR.bFSMO_DB_BC_SetErr AND NOT IN_GR.tCU2GR.bFSMO_DB_AI_COn THEN
	 	OUT_GR.tGR2CU.rFSMO_GRC_DB := LIMIT(0.0, IN_GR.tCU2GR.rF_FSMO_DB_BC, rDB_FSM_LFSM_Max);
	ELSE
		OUT_GR.tGR2CU.rFSMO_GRC_DB := Para.rF_FC_Deadband_neg;
	END_IF;	
						
	IF (bGCP_FSMO_GRC_DB AND NOT IN_GR.tHA2GR.tF_FSMO_DB.GoodQual) OR (bBC_FSMO_GRC_DB AND IN_GR.tCU2GR.bFSMO_DB_BC_SetErr) THEN
		bMsg9268 := TRUE;
	ELSE
		bMsg9268 := FALSE;
	END_IF;
	(************************* Positive Margin FSM********************************************************)
	(* Positive Margin FSM on/off from Digital inputs *)
	xSR_Marg_GrC_FSM_Pos(SET1 := IN_GR.tCU2GR.bFSM_RMC_Up_AI_COn, RESET := IN_GR.tCU2GR.bFSM_RMC_Up_AI_COf);
	bGCP_Marg_GrC_FSM_Pos  := xSR_Marg_GrC_FSM_Pos.Q1;

	(* request Positive Margin FSM from bus - on/off	*)
	xSR_BC_Marg_GrC_FSM_Pos(SET1 := IN_GR.tCU2GR.bFSM_RMC_Up_BC_COn, RESET := IN_GR.tCU2GR.bFSM_RMC_Up_BC_COf);
	bBC_Marg_GrC_FSM_Pos := xSR_BC_Marg_GrC_FSM_Pos.Q1;

	IF bGCP_Marg_GrC_FSM_Pos AND IN_GR.tHA2GR.tP_FSM_RMC_Up.GoodQual THEN
		OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos := LIMIT(0.0, IN_GR.tHA2GR.tP_FSM_RMC_Up.Ai, 0.3);
	ELSIF bBC_Marg_GrC_FSM_Pos AND NOT IN_GR.tCU2GR.bFSM_RMC_Up_BC_SetErr AND NOT IN_GR.tCU2GR.bFSM_RMC_Up_AI_COn THEN
	 	OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos := LIMIT(0.0, IN_GR.tCU2GR.rP_FSM_RMC_Up_BC, 0.3);
	ELSE
		OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos := Para.rSetMarg_FC_StaInp;
	END_IF;	
							
	IF (bGCP_Marg_GrC_FSM_Pos AND NOT IN_GR.tHA2GR.tP_FSM_RMC_Up.GoodQual) OR (bBC_Marg_GrC_FSM_Pos AND IN_GR.tCU2GR.bFSM_RMC_Up_BC_SetErr) THEN
		bMsg9269 := TRUE;
	ELSE
		bMsg9269 := FALSE;
	END_IF;
	(************************* Negative Margin FSM********************************************************)
	(* Negative Margin FSM on/off from Digital inputs *)
	xSR_Marg_GrC_FSM_Neg(SET1 := IN_GR.tCU2GR.bFSM_RMC_Down_AI_COn, RESET := IN_GR.tCU2GR.bFSM_RMC_Down_AI_COf);
	bGCP_Marg_GrC_FSM_Neg  := xSR_Marg_GrC_FSM_Neg.Q1;

	(* request Negative Margin FSM from bus - on/off	*)
	xSR_BC_Marg_GrC_FSM_Neg(SET1 := IN_GR.tCU2GR.bFSM_RMC_Down_BC_COn, RESET := IN_GR.tCU2GR.bFSM_RMC_Down_BC_COf);
	bBC_Marg_GrC_FSM_Neg := xSR_BC_Marg_GrC_FSM_Neg.Q1;

	IF bGCP_Marg_GrC_FSM_Neg AND IN_GR.tHA2GR.tP_FSM_RMC_Down.GoodQual THEN
		OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg := LIMIT(0.0, IN_GR.tHA2GR.tP_FSM_RMC_Down.Ai, 0.3);
	ELSIF bBC_Marg_GrC_FSM_Neg AND NOT IN_GR.tCU2GR.bFSM_RMC_Down_BC_SetErr AND NOT IN_GR.tCU2GR.bFSM_RMC_Down_AI_COn THEN
	 	OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg := LIMIT(0.0, IN_GR.tCU2GR.rP_FSM_RMC_Down_BC, 0.3);
	ELSE
		OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg := Para.rSetMarg_FC_StaInp_Neg;
	END_IF;	
								
	IF (bGCP_Marg_GrC_FSM_Neg AND NOT IN_GR.tHA2GR.tP_FSM_RMC_Down.GoodQual) OR (bBC_Marg_GrC_FSM_Neg AND IN_GR.tCU2GR.bFSM_RMC_Down_BC_SetErr) THEN
		bMsg9270 := TRUE;
	ELSE
		bMsg9270 := FALSE;
	END_IF;
	(************************* U droop********************************************************)
	(* U droop on/off from Digital inputs *)
	xSR_Droop_GrC_U(SET1 := IN_GR.tCU2GR.bU_Droop_AI_COn, RESET := IN_GR.tCU2GR.bU_Droop_AI_COf);
	bGCP_Droop_GrC_U  := xSR_Droop_GrC_U.Q1;

	(* request U droop from bus - on/off	*)
	xSR_BC_Droop_GrC_U(SET1 := IN_GR.tCU2GR.bU_Droop_BC_COn, RESET := IN_GR.tCU2GR.bU_Droop_BC_COf);
	bBC_Droop_GrC_U := xSR_BC_Droop_GrC_U.Q1;

	IF bGCP_Droop_GrC_U AND IN_GR.tHA2GR.tU_Droop.GoodQual THEN
		rDroop_GrC_U := LIMIT(-20.0, IN_GR.tHA2GR.tU_Droop.Ai, 20.0) / 100;
	ELSIF bBC_Droop_GrC_U AND NOT IN_GR.tCU2GR.bU_Droop_BC_SetErr AND NOT IN_GR.tCU2GR.bU_Droop_AI_COn THEN
	 	rDroop_GrC_U := LIMIT(-20.0, IN_GR.tCU2GR.rU_Droop_BC, 20.0) / 100;
	ELSE
		rDroop_GrC_U := Para.rU_droop;
	END_IF;	
									
	IF (bGCP_Droop_GrC_U AND NOT IN_GR.tHA2GR.tU_Droop.GoodQual) OR (bBC_Droop_GrC_U AND IN_GR.tCU2GR.bU_Droop_BC_SetErr) THEN
		bMsg9271 := TRUE;
	ELSE
		bMsg9271 := FALSE;
	END_IF;
	(************************* Rampe rate ************************************************************)
	(* Rampe rate UP on/off from Digital inputs *)
	xSR_Ramp_GrC(SET1 := IN_GR.tCU2GR.bFSM_Rmp_AI_COn, RESET := IN_GR.tCU2GR.bFSM_Rmp_AI_COf);
	bGCP_Ramp_GrC  := xSR_Ramp_GrC.Q1;

	(* request Rampe rate UP from bus - on/off	*)
	xSR_BC_Ramp_GrC(SET1 := IN_GR.tCU2GR.bFSM_Rmp_BC_COn, RESET := IN_GR.tCU2GR.bFSM_Rmp_BC_COf);
	bBC_Ramp_GrC := xSR_BC_Ramp_GrC.Q1;

	IF bGCP_Ramp_GrC AND IN_GR.tHA2GR.tFSM_Rmp_Up.GoodQual THEN
		rRamp_GrC_IncGrad := LIMIT(0.001, IN_GR.tHA2GR.tFSM_Rmp_Up.Ai, 0.3);
	ELSIF bBC_Ramp_GrC AND NOT IN_GR.tCU2GR.bFSM_Rmp_BC_SetErr AND NOT IN_GR.tCU2GR.bFSM_Rmp_AI_COn THEN
	 	rRamp_GrC_IncGrad := LIMIT(0.001, IN_GR.tCU2GR.rP_FSM_Rmp_Up_BC, 0.3);
	ELSE
		rRamp_GrC_IncGrad := LIMIT(0.001, IN_GR.rP_Ramp_IncGrad_Norm, 0.3);  
	END_IF;	
	
	IF bGCP_Ramp_GrC AND IN_GR.tHA2GR.tFSM_Rmp_Down.GoodQual THEN
		rRamp_GrC_DecGrad := LIMIT(0.001, IN_GR.tHA2GR.tFSM_Rmp_Down.Ai, 0.3);
	ELSIF bBC_Ramp_GrC AND NOT IN_GR.tCU2GR.bFSM_Rmp_BC_SetErr AND NOT IN_GR.tCU2GR.bFSM_Rmp_AI_COn THEN
		rRamp_GrC_DecGrad := LIMIT(0.001, IN_GR.tCU2GR.rP_FSM_Rmp_Down_BC, 0.3);
	ELSE
		rRamp_GrC_DecGrad := LIMIT(0.001, IN_GR.rP_Ramp_DecGrad_Norm, 0.3);  
	END_IF;		
									
	IF (bGCP_Ramp_GrC AND NOT IN_GR.tHA2GR.tFSM_Rmp_Up.GoodQual) OR (bBC_Ramp_GrC AND IN_GR.tCU2GR.bFSM_Rmp_BC_SetErr) THEN
		bMsg9272 := TRUE;
	ELSE
		bMsg9272 := FALSE;
	END_IF;
										
	IF (bGCP_Ramp_GrC AND NOT IN_GR.tHA2GR.tFSM_Rmp_Down.GoodQual) OR (bBC_Ramp_GrC AND IN_GR.tCU2GR.bFSM_Rmp_BC_SetErr) THEN
		bMsg9273 := TRUE;
	ELSE
		bMsg9273 := FALSE;
	END_IF;	
	(************************* Frequency reference for FSM/LFSM********************************************************)
	(* Frequency reference on/off from Digital inputs *)
	xSR_FNom_LFSM_Ref(SET1 := IN_GR.tCU2GR.bF_Ref_FSM_AI_COn, RESET := IN_GR.tCU2GR.bF_Ref_FSM_AI_COf);
	bGCP_FNom_LFSM_Ref  := xSR_FNom_LFSM_Ref.Q1;

	(* Frequency reference from bus - on/off	*)
	xSR_BC_FNom_LFSM_Ref(SET1 := IN_GR.tCU2GR.bF_Ref_FSM_BC_COn, RESET := IN_GR.tCU2GR.bF_Ref_FSM_BC_COf);
	bBC_FNom_LFSM_Ref := xSR_BC_FNom_LFSM_Ref.Q1;

	IF bGCP_FNom_LFSM_Ref AND IN_GR.tHA2GR.tF_Ref_FSM.GoodQual THEN
		OUT_GR.tGR2CU.rFNom_LFSM_Ref := LIMIT(45, IN_GR.tHA2GR.tF_Ref_FSM.Ai, 65);
	ELSIF bBC_FNom_LFSM_Ref AND NOT IN_GR.tCU2GR.bF_Ref_FSM_BC_SetErr AND NOT IN_GR.tCU2GR.bF_Ref_FSM_AI_COn THEN
	 	OUT_GR.tGR2CU.rFNom_LFSM_Ref := LIMIT(45, IN_GR.tCU2GR.rF_Ref_FSM_BC, 65);
	ELSE
		OUT_GR.tGR2CU.rFNom_LFSM_Ref := MAX(1, Para.rFNom_LFSM_Ref);  
	END_IF;	
	
	IF (bGCP_FNom_LFSM_Ref AND NOT IN_GR.tHA2GR.tF_Ref_FSM.GoodQual) OR (bBC_FNom_LFSM_Ref AND IN_GR.tCU2GR.bF_Ref_FSM_BC_SetErr) THEN
		bMsg9274 := TRUE;
	ELSE
		bMsg9274 := FALSE;
	END_IF;
	(******************************************************************************************************************)
	(************************* Control bit for blocking module*********************************************************)	
	OUT_GR.tGR2CU.bCheck_GR2CU := TRUE;
	OUT_GR.bEng_Bloc_GR	:= NOT (IN_GR.tCU2GR.bCheck_CU2GR AND IN_GR.tHA2GR.bCheck_HA2GR);
	(******************************************************************************************************************)
	
	(* Testbutton *)
	
	VIS2MM.bLFSM_TestStart;		VIS2MM.bLFSM_TestStop;
	
	IF (IN_GR.iPassLevel >= 20 OR IN_GR.bLFSM_Test_Enabled OR OUT_GR.tGR2CU.bLFSM_Test_On) AND IN_GR.tGCB_On.Di THEN //Le avoid LFSM_TestStop during test by autoreset iPassLevel
		bLFSM_TestEnable	 			:= TRUE;
	ELSE
		VIS2MM.bLFSM_TestStart			:= FALSE;
		VIS2MM.bLFSM_TestStop			:= TRUE;
		bLFSM_TestEnable 				:= FALSE;		
		VIS2MM.rFNom_FSM_ManualTest 	:= OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		VIS2MM.rFAct_FSM_ManualTest 	:= OUT_GR.tGR2CU.rFNom_LFSM_Ref;
	END_IF;
	
	R_LFSM_TRIG_Start(CLK := (VIS2MM.bLFSM_TestStart OR IN_GR.bSet_LFSM_Test_COn) AND bLFSM_TestEnable);							
	IF R_LFSM_TRIG_Start.Q THEN
		OUT_GR.tGR2CU.bLFSM_Test_On		:= TRUE;
		VIS2MM.bLFSM_TestStart			:= TRUE;
		VIS2MM.bLFSM_TestStop			:= FALSE;
	END_IF;
	R_LFSM_TRIG_Stop(CLK := VIS2MM.bLFSM_TestStop OR NOT IN_GR.bSet_LFSM_Test_COn OR IN_GR.tCU2GR.bLFSM_TestStop);
	IF R_LFSM_TRIG_Stop.Q THEN	
		OUT_GR.tGR2CU.bLFSM_Test_On		:= FALSE;
		VIS2MM.bLFSM_TestStart 			:= FALSE;
		VIS2MM.bLFSM_TestStop 			:= TRUE;
		VIS2MM.rFNom_FSM_ManualTest 	:= OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		VIS2MM.rFAct_FSM_ManualTest 	:= OUT_GR.tGR2CU.rFNom_LFSM_Ref;
	END_IF;	
	
	(* Correct Testmode on HMI when activation via BUS *)
	IF OUT_GR.tGR2CU.bLFSM_Test_On AND IN_GR.bLFSM_Test_Enabled AND IN_GR.bSet_LFSM_Test_COn THEN
		VIS2MM.iSet_FC_Testmode := 4;
		VIS2MM.rFAct_FSM_ManualTest := IN_GR.rF_Act_FSM_Test_Ext;
		bSetback_FC_Testmode := TRUE;
	ELSE
		bSetback_FC_Testmode := FALSE;	
	END_IF;
	
	F_LFSM_TRIG_Testmode(CLK := bSetback_FC_Testmode);
	
	IF F_LFSM_TRIG_Testmode.Q THEN
		VIS2MM.iSet_FC_Testmode := 0;
	END_IF;
	
	(* Send to c_fc *)
	OUT_GR.tGR2CU.iSet_FC_Testmode := VIS2MM.iSet_FC_Testmode;
	OUT_GR.tGR2CU.rFNom_FSM_ManualTest:= VIS2MM.rFNom_FSM_ManualTest;
	IF OUT_GR.tGR2CU.iSet_FC_Testmode = 4 AND IN_GR.bSet_LFSM_Test_COn THEN
		OUT_GR.tGR2CU.rFAct_FSM_ManualTest:= IN_GR.rF_Act_FSM_Test_Ext;		
	ELSE
	OUT_GR.tGR2CU.rFAct_FSM_ManualTest:= VIS2MM.rFAct_FSM_ManualTest;
	END_IF;
	
	(* call function for the state machine *)
	xOpMode(in 	:= IN_GR.iSt_OpMode);
	
	(****************************************)
	(*********** Power setpoint  ************)
	(****************************************)
	(* Set default value for Opstate module *)
	OUT_GR.rP_Set_ExtDI_Norm := 1.0;
	
	(* request power value from DIs - on/off	*)
	xSR_P(SET1 := IN_GR.bP_GenC_SetEUCOn, RESET := IN_GR.bP_GenC_SetEUCOf);
	bGCP_P	   := xSR_P.Q1;

	(* request power value from bus - on/off	*)
	xSR_BC_P(SET1 := IN_GR.bGenC_PBC_SetCOn, RESET := IN_GR.bGenC_PBC_SetCOf);
	bBC_GCP_P	  := xSR_BC_P.Q1;

	OUT_GR.bP_Set_EU_Enable 	:= FALSE;
	rGCP_P						:= 0.00;
	
	(* External setpoint scaling P - EU - Hardware *)
	IF Para.bP_GrC_SetEUCOn THEN
	(* Generating measurment signal failure *)
		IF Para.rP_GrC_SetEUI1 >= 4.0 AND Para.rP_GrC_SetEUI2 >= 4.0 AND IN_GR.tP_GenC_SetEU.GoodQual AND Para.bRelFreeze_Pset_EU THEN
			rBuffer_Pset_EU[x_Pset] := LIMIT(0, IN_GR.tP_GenC_SetEU.Ai, IN_GR.rP_Nom);
			x_Pset := x_Pset + 1;
			IF x_Pset > 9 THEN											
				x_Pset := 0;
				bBuffer_Pset_EU := TRUE;				// Check if Buffer is filled							
			END_IF
		END_IF
		
		IF NOT bBuffer_Pset_EU THEN						// When buffer is not filled use hard coded backup value										
			rLCRLimScal_PAct_old := IN_GR.rP_Nom * 0.5;	
		END_IF;	

		TON_GoodQual_Pset_EU(IN := IN_GR.tP_GenC_SetEU.GoodQual, PT := tGoodQual);		// External signal must be valid for five seconds
		
		IF Para.rP_GrC_SetEUI1 >= 4.0 AND Para.rP_GrC_SetEUI2 >= 4.0 AND NOT TON_GoodQual_Pset_EU.Q THEN
			bMsg3592	:= TRUE;
			IF Para.bRelFreeze_Pset_EU AND bBuffer_Pset_EU THEN												
				rGCP_P := rLCRLimScal_PAct_old;
			END_IF
		ELSE
			bMsg3592	:= FALSE;		
			rGCP_P		:= LIMIT(0, IN_GR.tP_GenC_SetEU.Ai, IN_GR.rP_Nom);
			IF Para.bRelFreeze_Pset_EU THEN												// If frozen value is activated use value from one second before signal loss
				z_Pset := x_Pset - 8;
				IF bBuffer_Pset_EU THEN
					IF z_Pset >= 0 THEN
						rLCRLimScal_PAct_old := rBuffer_Pset_EU[z_Pset];
					ELSE
						rLCRLimScal_PAct_old := rBuffer_Pset_EU[z_Pset + 9];
					END_IF
				ELSE
					rLCRLimScal_PAct_old := IN_GR.rP_Nom * 0.5;
				END_IF
			END_IF
			IF bGCP_P THEN 
				OUT_GR.bP_Set_EU_Enable	:= TRUE; 
			END_IF;
		END_IF;	
	ELSE
		rGCP_P		    := 0.00;
		bMsg3592		:= FALSE;
	END_IF;

	(********************************************************)
	(* active power selection of external setpoint utility  *)
	(********************************************************)
	IF bGCP_P THEN
		IF IN_GR.P_GenC_SetFix5 THEN
			rGCP_P			:= Para.rExtPwrSetEUP5 * IN_GR.rP_Nom;
			OUT_GR.bP_Set_EU_Enable	:= TRUE;
		ELSIF IN_GR.P_GenC_SetFix4	THEN
			rGCP_P			:= Para.rExtPwrSetEUP4 * IN_GR.rP_Nom;
			OUT_GR.bP_Set_EU_Enable	:= TRUE;
		ELSIF IN_GR.P_GenC_SetFix3	THEN
			rGCP_P			:= Para.rExtPwrSetEUP3 * IN_GR.rP_Nom;
			OUT_GR.bP_Set_EU_Enable	:= TRUE;
		ELSIF IN_GR.P_GenC_SetFix2	THEN
			rGCP_P			:= Para.rExtPwrSetEUP2 * IN_GR.rP_Nom;
			OUT_GR.bP_Set_EU_Enable	:= TRUE;
		ELSIF IN_GR.P_GenC_SetFix1	THEN
			rGCP_P			:= Para.rExtPwrSetEUP1 * IN_GR.rP_Nom;
			OUT_GR.bP_Set_EU_Enable	:= TRUE;
		END_IF;	
	END_IF;	
	
	// bus
	IF bBC_GCP_P AND NOT IN_GR.bP_GenC_SetErr AND NOT OUT_GR.bP_Set_EU_Enable THEN
		rGCP_P			:= LIMIT(0, IN_GR.rGenC_PBC, IN_GR.rP_Nom);
		OUT_GR.bP_Set_EU_Enable	:= TRUE;	
	END_IF;	
	
	IF OUT_GR.bP_Set_EU_Enable THEN
		IF IN_GR.rP_Nom <> 0 THEN (* division durch NULL vermeiden *)
			OUT_GR.rP_Set_EU_Norm	:= rGCP_P / IN_GR.rP_Nom;
		END_IF	
	ELSE
			OUT_GR.rP_Set_EU_Norm	:= 1.0;
	END_IF;

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

	MM2VIS.bGCP_P					:= bGCP_P;
	MM2VIS.bBC_GCP_P				:= bBC_GCP_P;
	MM2VIS.rGCP_P_AI				:= LIMIT(0, IN_GR.tP_GenC_SetEU.Ai, IN_GR.rP_Nom); (*AI*)
	MM2VIS.rGCP_P_BUS				:= LIMIT(0, IN_GR.rGenC_PBC, IN_GR.rP_Nom);(*BUS*)
	MM2VIS.rGCP_P					:= rGCP_P;
	MM2VIS.rP_Set_EU_kW				:= OUT_GR.rP_Set_EU_Norm * IN_GR.rP_Nom;
	MM2VIS.rP_Set_EU_Norm			:= OUT_GR.rP_Set_EU_Norm;
	MM2VIS.bLFSMO_active 			:= Para.bSet_GrC_LFSMO_COn; 
	MM2VIS.rDroop_LFSMO 			:= rDroop_GrC_LFSMO_pos; 
	MM2VIS.bLFSMU_active 			:= Para.bSet_GrC_LFSMU_COn; 
	MM2VIS.rDroop_LFSMU 			:= rDroop_GrC_LFSMU_neg; 
	MM2VIS.bFSM_active 				:= OUT_GR.tGR2CU.bSet_GrC_FSM; 
	MM2VIS.rDroop_FSMO 				:= OUT_GR.tGR2CU.rDroop_GrC_FSMO; 
	MM2VIS.rDroop_FSMU 				:= OUT_GR.tGR2CU.rDroop_GrC_FSMU; 
	MM2VIS.rF_FSM_Deadband_pos 		:= OUT_GR.tGR2CU.rFSMU_GRC_DB; 
	MM2VIS.rF_FSM_Deadband_neg 		:= OUT_GR.tGR2CU.rFSMO_GRC_DB; 
	MM2VIS.rF_LFSMO_Deadband_pos 	:= rF_LFSMO_GrC_DB_pos; 
	MM2VIS.rF_LFSMO_Deadband_neg   	:= rF_LFSMU_GrC_DB_neg; 
	MM2VIS.bILF_Active 				:= OUT_GR.tGR2CU.bSet_GrC_ILF;

	(***********************)
	(******** R M C ********)
	(***********************)
//	Para.rRMC_GrC_SetMargCOn;
//	Para.iPFCRMC_GrC_SetCur;
//	Para.bPFCRMC_GrC_SetRelaCOn;
	
	(*RMC activate / deactivate from Digital inputs *)
	xSR_RMC(SET1 := IN_GR.bRMC_SetCOn, RESET := IN_GR.bRMC_SetCOf);
	bGCP_RMC	:= xSR_RMC.Q1;

	(*RMC activate / deactivate from bus *)
	xSR_BC_RMC(SET1 := IN_GR.bGenC_RMCBC_SetCOn, RESET := IN_GR.bGenC_RMCBC_SetCOf);
	bBC_GCP_RMC	:= xSR_BC_RMC.Q1;

	(* Release regulation margine control  *)
	IF bstatGC_rel AND (bGCP_RMC OR bBC_GCP_RMC) THEN
		OUT_GR.bP_Red_RMC_Enable			:= TRUE;
		OUT_GR.rP_Red_RMC_Norm	:= 1.0; // - Para.rRMC_GrC_SetMargCOn ; (* set normalised power reduction *)
	ELSE (* release of the power reduction *)
		OUT_GR.bP_Red_RMC_Enable	:= FALSE; 
		OUT_GR.rP_Red_RMC_Norm		:= 1.0;
	END_IF;	

	(*Generate hardware signals *)
	OUT_GR.tRMC_SOn.Do	:= OUT_GR.bP_Red_RMC_Enable;
	OUT_GR.tRMC_SOf.Do	:= NOT OUT_GR.bP_Red_RMC_Enable;

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

		MM2VIS.bGCP_RMC			:= bGCP_RMC;
		MM2VIS.bBC_GCP_RMC		:= bBC_GCP_RMC;
		MM2VIS.rP_Red_RMC_Norm	:= OUT_GR.rP_Red_RMC_Norm;


	(************************************)
	(******* power limitation     *******)
	(************************************)
	(* power limit on/off from Digital inputs *)
	xSR_PLim(SET1 := IN_GR.bPLim_GenC_SetEUCOn, RESET := IN_GR.bPLim_GenC_SetEUCOf);
	bGCP_PLim	  := xSR_PLim.Q1;

	(* power limit on/off from bus *)
	xSR_BC_PLim(SET1 := IN_GR.bGenC_PLimBC_SetCOn, RESET := IN_GR.bGenC_PLimBC_SetCOf);
	bBC_GCP_PLim	:= xSR_BC_PLim.Q1;

	(* power limitation from bus or from digital inputs *)
	OUT_GR.bP_Red_EU_Enable := bBC_GCP_PLim OR bGCP_PLim;
	
	Para.rP_GrC_EUAct_Lim_BU;

	rGCP_PLim		:= IN_GR.rP_Nom;

	(* Scaling external P-reduction EU - Hardware *)
	IF Para.bP_GrC_SetEUCOn_Lim THEN
		(*Generation measurement signal interference *)
		IF Para.rP_GrC_SetEUI1_Lim >= 4.0 AND Para.rP_GrC_SetEUI2_Lim >= 4.0 AND IN_GR.tPLim_GenC_SetEU.GoodQual AND Para.bRelFreeze_PLim_EU THEN
			rBuffer_PLim_EU[x_PLim] := LIMIT(0, IN_GR.tPLim_GenC_SetEU.Ai, IN_GR.rP_Nom);
			x_PLim := x_PLim + 1;
			IF x_PLim > 9 THEN
				x_PLim := 0;
				bBuffer_PLim_EU := TRUE;
			END_IF
		END_IF
		
		IF NOT bBuffer_PLim_EU THEN
			rLCRLimScal_PLim_old := IN_GR.rP_Nom;
		END_IF;			

		TON_GoodQual_PLim_EU(IN := IN_GR.tPLim_GenC_SetEU.GoodQual, PT := tGoodQual);
		
		IF Para.rP_GrC_SetEUI1_Lim >= 4.0 AND Para.rP_GrC_SetEUI2_Lim >= 4.0 AND NOT TON_GoodQual_PLim_EU.Q THEN
			bMsg3591	:= TRUE;
			IF Para.bRelFreeze_PLim_EU AND bBuffer_PLim_EU THEN	
				rGCP_PLim := rLCRLimScal_PLim_old;
			END_IF
		ELSE
			bMsg3591	:= FALSE;

			IF IN_GR.tPLim_GenC_SetEU.Ai >= IN_GR.rP_Nom * 0.995 THEN (* deadband 0.5% to avoid Pred.display due to mA jitter *)//LE
				rGCP_PLim := IN_GR.rP_Nom;
			ELSE
				rGCP_PLim := LIMIT(0, IN_GR.tPLim_GenC_SetEU.Ai, IN_GR.rP_Nom);
			END_IF;
			IF Para.bRelFreeze_PLim_EU THEN	
				z_PLim := x_PLim - 8;
				IF bBuffer_PLim_EU THEN
					IF z_PLim >= 0 THEN
						rLCRLimScal_PLim_old := rBuffer_PLim_EU[z_PLim];
					ELSE
						rLCRLimScal_PLim_old := rBuffer_PLim_EU[z_PLim + 9];
					END_IF
				ELSE
					rLCRLimScal_PLim_old := IN_GR.rP_Nom;
				END_IF
			END_IF
		END_IF;	

	ELSE
		rGCP_PLim	:= IN_GR.rP_Nom;
		bMsg3591	:= FALSE;
	END_IF;
	
	IF bGCP_PLim AND Para.bP_GrC_SetEUCOn_Lim AND (MM2VIS.bMsg3591 AND NOT Para.bRelFreeze_PLim_EU) THEN
		rGCP_PLim		:= LIMIT(0, Para.rP_GrC_EUAct_Lim_BU, IN_GR.rP_Nom);
	END_IF;
	
	(* !A====================================================================================*)	
	(* power limitation according external request from utility (EU) *)
	IF (IN_GR.tDI_Dem_EU_Block.Di OR IN_GR.bEng_Block_EVU) AND bGCP_PLim AND IN_GR.tMCB_On.Di THEN	(* lockout module *)
		OUT_GR.rP_RedDI_EU_Norm := 1.0 ; 
		IF (IN_GR.iIdx_OMSS = 1) THEN
			OUT_GR.rP_RedDI_EU_Norm := IN_GR.rP_Set_Min_Norm;
		END_IF;
	ELSIF IN_GR.PLim_GenC_SetEUPFix5 AND IN_GR.tMCB_On.Di THEN			(* stage 5 *)
		OUT_GR.rP_RedDI_EU_Norm	:= Para.rP_GrC_SetExtUt5_Lim; 
	ELSIF IN_GR.PLim_GenC_SetEUPFix4 AND IN_GR.tMCB_On.Di THEN			(* stage 4 *)
		OUT_GR.rP_RedDI_EU_Norm	:= Para.rP_GrC_SetExtUt4_Lim; 
	ELSIF IN_GR.PLim_GenC_SetEUPFix3 AND IN_GR.tMCB_On.Di THEN			(* stage 3 *)
		OUT_GR.rP_RedDI_EU_Norm	:= Para.rP_GrC_SetExtUt3_Lim;
	ELSIF IN_GR.PLim_GenC_SetEUPFix2 AND IN_GR.tMCB_On.Di THEN			(* stage 2 *)
		OUT_GR.rP_RedDI_EU_Norm	:= Para.rP_GrC_SetExtUt2_Lim; 
	ELSIF IN_GR.PLim_GenC_SetEUPFix1 AND IN_GR.tMCB_On.Di THEN			(* stage 1 *)
		OUT_GR.rP_RedDI_EU_Norm	:= Para.rP_GrC_SetExtUt1_Lim; 
	ELSE
		OUT_GR.rP_RedDI_EU_Norm	:= 1.0; (* no power limitation *) 
	END_IF;

	IF (IN_GR.iIdx_OMSS = 1) THEN
		IF OUT_GR.rP_RedDI_EU_Norm < IN_GR.rP_Set_Min_Norm THEN
			OUT_GR.rP_RedDI_EU_Norm := IN_GR.rP_Set_Min_Norm;
		END_IF;
	END_IF;

	(* ====================================================================================E!*)	

	(* !A====================================================================================*)	
	(* EU P-Limitierung ueber Analogsignal bzw. BUS einschleifen *)
	IF OUT_GR.bP_Red_EU_Enable THEN
		OUT_GR.rP_Red_EU_Norm := MIN(OUT_GR.rP_RedDI_EU_Norm, OUT_GR.rP_Red_EU_Norm);
	ELSE
		OUT_GR.rP_Red_EU_Norm := 1.0;
	END_IF;
	(* ====================================================================================E!*)	

	(* !A====================================================================================*)	
	//	Abforderung generieren wenn Reduktion unter Limit und ueber Zeitlimit
	rP_Red_Max	:= 1.0;
	IF OUT_GR.rP_RedDI_EU_Norm < rP_Red_Max THEN 	rP_Red_Max := OUT_GR.rP_RedDI_EU_Norm;	END_IF;
	IF OUT_GR.rP_Red_PFC_Norm < rP_Red_Max THEN 	rP_Red_Max := OUT_GR.rP_Red_PFC_Norm;	END_IF;
	IF OUT_GR.rP_Red_EU_Norm < rP_Red_Max THEN 		rP_Red_Max := OUT_GR.rP_Red_EU_Norm;	END_IF;
	OUT_GR.rP_RedDI_EU_Norm	:= rP_Red_Max;	//for Visu of power reduction in PLimit Pic
	IF OUT_GR.rP_Set_EU_Norm < rP_Red_Max THEN 		rP_Red_Max := OUT_GR.rP_Set_EU_Norm;	END_IF;
	IF (OUT_GR.rP_Set_PFC_Norm < rP_Red_Max) AND (iFCMode = 1) THEN 	rP_Red_Max := OUT_GR.rP_Set_PFC_Norm;	END_IF; //FC should be excluded from shut down

	IF (IN_GR.iIdx_OMSS = 1) THEN
		IF rP_Red_Max < IN_GR.rP_Set_Min_Norm THEN
			rP_Red_Max := IN_GR.rP_Set_Min_Norm;
		END_IF;
	END_IF;

	xGR_MIN_Plim(In := 	rP_Red_Max, Gw := Para.rP_GrC_SetPar_Lim - 0.001, Hy := Para.rP_GrC_SetPar_Hy);
	xTON_Plim(IN := xGR_MIN_Plim.Q, PT :=  Para.tiP_GrC_SetPar);
	bEU_RM_BLOCK_INT	:= xTON_Plim.Q;
	OUT_GR.tP_GenC_Bloc.Do  := bEU_RM_BLOCK_INT;

	(* ====================================================================================E!*)	
	
	(* !A====================================================================================*)	
	(* limits for feedback signals to utility *)
	xTON_RM_EU[0](IN:= NOT IN_GR.PLim_GenC_SetEUPFix1 AND NOT IN_GR.PLim_GenC_SetEUPFix2
	AND NOT IN_GR.PLim_GenC_SetEUPFix3 AND NOT IN_GR.PLim_GenC_SetEUPFix4
	AND NOT IN_GR.PLim_GenC_SetEUPFix5 AND NOT IN_GR.tDI_Dem_EU_Block.Di AND NOT IN_GR.bEng_Block_EVU AND IN_GR.tMCB_On.Di, PT:= T#10s);
	
	OUT_GR.tP_GenC_Fix0SOn.Do :=xTON_RM_EU[0].Q;		(* no power limit.and no lockout module *)

	IF IN_GR.rP_Nom <> 0 THEN  (* division durch NULL vermeiden *)
		xPLim_lo[1](In:= IN_GR.tP_Act[1].Ai /IN_GR.rP_Nom, Gw:= (Para.rP_GrC_SetExtUt1_Lim), Hy:= 0.05);
	END_IF;
	xTON_RM_EU[1](IN:= xPLim_lo[1].Q AND IN_GR.PLim_GenC_SetEUPFix1, PT:= T#30s);
	OUT_GR.tP_GenC_Fix1SOn.Do := xTON_RM_EU[1].Q; (*plimit.stage 1 *)

	
	IF IN_GR.rP_Nom <> 0 THEN  (* division durch NULL vermeinden *)
		xPLim_lo[2](In:= IN_GR.tP_Act[1].Ai / IN_GR.rP_Nom, Gw:= (Para.rP_GrC_SetExtUt2_Lim ), Hy:= 0.05);
	END_IF;	
	xTON_RM_EU[2](IN:= xPLim_lo[2].Q AND IN_GR.PLim_GenC_SetEUPFix2, PT:= T#30s);
	OUT_GR.tP_GenC_Fix2SOn.Do := xTON_RM_EU[2].Q; (*plimit.stage 2 *)

	IF IN_GR.rP_Nom <> 0 THEN  (* division durch NULL vermeinden *)
		xPLim_lo[3](In:= IN_GR.tP_Act[1].Ai / IN_GR.rP_Nom, Gw:= (Para.rP_GrC_SetExtUt3_Lim ), Hy:= 0.05);
	END_IF;	
	xTON_RM_EU[3](IN:= xPLim_lo[3].Q AND IN_GR.PLim_GenC_SetEUPFix3, PT:= T#30s);
	OUT_GR.tP_GenC_Fix3SOn.Do := xTON_RM_EU[3].Q; (*plimit.stage 3 *)
	
	IF IN_GR.rP_Nom <> 0 THEN  (* division durch NULL vermeinden *)
		xPLim_lo[4](In:= IN_GR.tP_Act[1].Ai / IN_GR.rP_Nom, Gw:= (Para.rP_GrC_SetExtUt4_Lim ), Hy:= 0.05);
	END_IF;	
	xTON_RM_EU[4](IN:= xPLim_lo[4].Q AND IN_GR.PLim_GenC_SetEUPFix4, PT:= T#30s);
	OUT_GR.tP_GenC_Fix4SOn.Do := xTON_RM_EU[4].Q; (*plimit.stage 4 *)
	
	
	IF IN_GR.rP_Nom <> 0 THEN  (* division durch NULL vermeinden *)
		xPLim_lo[6](In:= IN_GR.tP_Act[1].Ai / IN_GR.rP_Nom, Gw:= (Para.rP_GrC_SetExtUt5_Lim ), Hy:= 0.05);
	END_IF; 		
	xTON_RM_EU[6](IN:= xPLim_lo[6].Q AND IN_GR.PLim_GenC_SetEUPFix5, PT:= T#30s);
	OUT_GR.tP_GenC_Fix5SOn.Do := xTON_RM_EU[6].Q; (*plimit.stage 5 *)
	
	xTON_RM_EU[5](IN:= (IN_GR.tDI_Dem_EU_Block.Di OR IN_GR.bEng_Block_EVU) AND NOT IN_GR.tGCB_On.Di,  PT:= T#30s);	(* set feedback of the block signal when the engine is separated from the grid *)
	OUT_GR.tEU_RM_BLOCK.Do := xTON_RM_EU[5].Q;		(* lockout module *)

//	OUT_CU.bEng_Block_EVU := OUT_CU.tDO_Eng_Block_EVU.Do  ;	(* lockout module *)	(* == BLOCK_EVU *)

	(*Generate hardware signals *)
	OUT_GR.tP_GenC_SOn.Do	:= OUT_GR.bP_Set_EU_Enable;
	OUT_GR.tP_GenC_SOf.Do	:= NOT OUT_GR.bP_Set_EU_Enable;
	(* ====================================================================================E!*)		

	(* !A====================================================================================*)	
	(* powerlimit Bus *)
	IF bBC_GCP_PLim THEN	
		IF NOT IN_GR.bP_GenC_SetErrPlim THEN
			rGCP_PLim	:= MIN(rGCP_PLim, LIMIT(0, IN_GR.rGenC_PLimBC, IN_GR.rP_Nom));
		ELSE
			rGCP_PLim	:= MIN(rGCP_PLim, LIMIT(0, Para.rP_GrC_EUAct_Lim_BU, IN_GR.rP_Nom));
		END_IF;
	END_IF;
	(* ====================================================================================E!*)		

	(* !A====================================================================================*)	
	(* powerlimit from DIs or Bus *)
	IF bGCP_PLim OR bBC_GCP_PLim THEN
		IF IN_GR.rP_Nom <> 0 THEN  (* division durch NULL vermeinden *)
			OUT_GR.rP_Red_EU_Norm	:= rGCP_PLim / IN_GR.rP_Nom;
		END_IF	
	    ELSE
			OUT_GR.rP_Red_EU_Norm	:= 1.0;
	END_IF;
	(* ====================================================================================E!*)		

	(* !A=25.05.2014==========================================================================*)	
	(* powerlimit from ERDF *)
	IF (bGCP_PLim AND OUT_GR.bOpMsg_Plim_ERDF_SOnOf) OR IN_GR.tP0_BLOCK_DEIE.Di THEN
			OUT_GR.rP_Red_EU_Norm	:= rP_Red_ERDF_Lim ;
		ELSE
			;
	END_IF;
	(* =25.05.2014==========================================================================E!*)	

	(* !A====================================================================================*)	//LE_a 27.11.2019	
	(* Pset, PLim - LIMITIERUNG DER SOLL LEISTUNG *)	
	IF OUT_GR.bP_Red_EU_Enable OR OUT_GR.bP_Set_EU_Enable THEN
		IF (EDGENEG((IN_GR.iIdx_Pred_Type = 25) OR (IN_GR.iIdx_Pred_Type = 31))) THEN 	(* activate slow power ramp after PLim intervention *)
			bSlowRampafterPLim := TRUE; 						(* activate slow power ramp *)
		END_IF;
	END_IF;	
		
	(* =====================================================================================E!*)//LE_e 27.11.2019		
	(*- - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - - - - - - - -  *)
	IF (IN_GR.PLim_GenC_SetEUPFix5 OR IN_GR.PLim_GenC_SetEUPFix4 OR IN_GR.PLim_GenC_SetEUPFix3 OR 
		IN_GR.PLim_GenC_SetEUPFix2 OR IN_GR.PLim_GenC_SetEUPFix1 OR bGCP_PLim OR bBC_GCP_PLim) AND NOT IN_GR.tP0_BLOCK_DEIE.Di THEN
			OUT_GR.tPLim_GenC_SOn.Do	:= TRUE;
			OUT_GR.tPLim_GenC_SOf.Do	:= FALSE;
	ELSE
			OUT_GR.tPLim_GenC_SOn.Do	:= FALSE;
			OUT_GR.tPLim_GenC_SOf.Do	:= TRUE;		
	END_IF;	

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

		MM2VIS.bGCP_PLim			:= bGCP_PLim;
		MM2VIS.bBC_GCP_PLim			:= bBC_GCP_PLim;
		MM2VIS.bP_GenC_Lim1SOn		:= OUT_GR.tP_GenC_Fix1SOn.Do;
		MM2VIS.bP_GenC_Lim2SOn		:= OUT_GR.tP_GenC_Fix2SOn.Do;
		MM2VIS.bP_GenC_Lim3SOn		:= OUT_GR.tP_GenC_Fix3SOn.Do;
		MM2VIS.bP_GenC_Lim4SOn		:= OUT_GR.tP_GenC_Fix4SOn.Do;
		MM2VIS.bP_GenC_Lim5SOn		:= OUT_GR.tP_GenC_Fix5SOn.Do;
		MM2VIS.rGCP_PLim_AI			:= LIMIT(0, IN_GR.tPLim_GenC_SetEU.Ai, IN_GR.rP_Nom); (*AI*)
		MM2VIS.rGCP_Plim_BUS		:= LIMIT(0, IN_GR.rGenC_PLimBC, IN_GR.rP_Nom);(*BUS*)
		MM2VIS.rGCP_Plim_Norm		:= OUT_GR.rP_RedDI_EU_Norm;
		MM2VIS.rPlim_EU_kW			:= OUT_GR.rP_Set_EU_Norm * IN_GR.rP_Nom;
		MM2VIS.rPlim_EU_Norm		:= OUT_GR.rP_Set_EU_Norm;
		MM2VIS.bEU_RM_BLOCK_INT		:= bEU_RM_BLOCK_INT;

	(******************************)
	(******** LFSM (P F C) ********)
	(******************************)
	(* primary frequency control - on/off from  digital inputs *)
	xSR_PFC(SET1 := IN_GR.bPFC_SetCOn, RESET := IN_GR.bPFC_SetCOf);
	bGCP_PFC	:= xSR_PFC.Q1;

	(* primary frequency control - on/off from bus *)
	xSR_BC_PFC(SET1 := IN_GR.bGenC_PFCBC_SetCOn, RESET := IN_GR.bGenC_PFCBC_SetCOf);
	bBC_GCP_PFC	:= xSR_BC_PFC.Q1;
	
	(* release primary frequency control LFSM from digital inputs or bus and general release  *)
	IF (bGCP_PFC OR bBC_GCP_PFC OR Para.bSet_GrC_LFSMO_COn OR Para.bSet_GrC_LFSMU_COn) AND IN_GR.tMCB_On.Di AND IN_GR.iIdx_OMSS = 2 THEN
		OUT_GR.bP_Red_PFC_Enable	:= TRUE;
	ELSE
		OUT_GR.bP_Red_PFC_Enable	:= FALSE;
	END_IF;		

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

		MM2VIS.bGCP_PFC			:= bGCP_PFC;
		MM2VIS.bBC_GCP_PFC		:= bBC_GCP_PFC;

	(* !A====================================================================================*)		
	(* PFC im ABSOLUTMODUS AKTIV - LIMITIERUNG DER MOEGLICHEN LEISTUNG *)
//	IF OUT_GR.bP_Red_PFC_Enable AND NOT Para.bPFCRMC_GrC_SetRelaCOn THEN		
//		IF EDGEPOS (OUT_GR.rP_Red_PFC_Norm < 1.0) THEN (* activate the slow power rampe after PFC intervention *)
//			bSlowRampafterPFC := TRUE; (* activate the slow power rampe *)
//		END_IF
//	END_IF;	
		
	(* Ende neu ============================================================================ *)	
	
	(* !A====================================================================================*)		
	(* PFC im RELATIVMODUS AKTIV - LIMITIERUNG DER SOLL LEISTUNG *)	//added 09.06.15
	IF OUT_GR.bP_Red_PFC_Enable THEN //AND Para.bPFCRMC_GrC_SetRelaCOn THEN
		IF (EDGENEG (OUT_GR.bP_Set_PFC_Enable) AND (iFCMode_old = 1)) OR ((iFCMode_old = 1) AND (iFCMode = 3)) THEN 	(* activate the slow power ramp after relative PFC intervention *)
			bSlowRampafterPFC := TRUE; 						(* activate the slow power ramp *)
		END_IF
	END_IF;	
		
	(* Ende neu ============================================================================ *)	


	(* Generate hardware signals *)
	OUT_GR.tPFC_SOn.Do	:= OUT_GR.bPFC_SOn_Bus := OUT_GR.bP_Red_PFC_Enable;
	OUT_GR.tPFC_SOf.Do	:= OUT_GR.bPFC_SOf_Bus := NOT OUT_GR.bP_Red_PFC_Enable;
	
	(*************************************)
	(* 	   FSM (FC) Frequency control    *)						
	(*************************************)	

	
	(* frequency control - on/off from  digital inputs *)
	xSR_FC(SET1 := IN_GR.bFC_SetCOn, RESET := IN_GR.bFC_SetCOf);
	bGCP_FC	:= xSR_FC.Q1;

	(* frequency control - on/off from bus *)
	xSR_BC_FC(SET1 := IN_GR.bSet_FC_COn_Bus, RESET := IN_GR.bSet_FC_COf_Bus);
	bBC_GCP_FC	:= xSR_BC_FC.Q1;
	
	IF (bGCP_FC AND Para.iSet_GrC_FSM = 2) OR (bBC_GCP_FC AND Para.iSet_GrC_FSM = 3) OR (Para.iSet_GrC_FSM = 1 AND NOT Para.bSet_FC_Input) THEN
		OUT_GR.tGR2CU.bSet_GrC_FSM := TRUE;
	ELSE
		OUT_GR.tGR2CU.bSet_GrC_FSM := FALSE;
	END_IF;
	
	(* release frequency control from digital inputs or bus and general release  *)
	IF OUT_GR.tGR2CU.bSet_GrC_FSM AND (IN_GR.tMCB_On.Di OR (IN_GR.bBypassMCB_FSM AND xOpMode.NetP)) AND IN_GR.iIdx_OMSS = 2 THEN
		OUT_GR.bP_Set_FC_Enable	:= TRUE;
	ELSE
		OUT_GR.bP_Set_FC_Enable	:= FALSE;
	END_IF;
	
	(* Generate hardware signals *)
	OUT_GR.tFC_SOn.Do := OUT_GR.bFC_SOn_Bus := OUT_GR.bP_Set_FC_Enable;
	OUT_GR.tFC_SOf.Do := OUT_GR.bFC_SOf_Bus := NOT OUT_GR.bP_Set_FC_Enable;
	
	(*****************************************)
	(* 	   ILF - Local Frequency Integrator  *)						
	(*****************************************)	

	(* ILF - on/off from  digital inputs *)
	xSR_ILF(SET1 := IN_GR.bILF_SetCOn, RESET := IN_GR.bILF_SetCOf);
	bGCP_ILF	:= xSR_ILF.Q1;

	(* ILF - on/off from bus *)
	xSR_BC_ILF(SET1 := IN_GR.bSet_ILF_COn_Bus, RESET := IN_GR.bSet_ILF_COf_Bus);
	bBC_GCP_ILF	:= xSR_BC_ILF.Q1;
	
	IF (bGCP_ILF OR bBC_GCP_ILF OR Para.bILF_ena) THEN
		OUT_GR.tGR2CU.bSet_GrC_ILF := TRUE;
	ELSE
		OUT_GR.tGR2CU.bSet_GrC_ILF := FALSE;
	END_IF;
	
	(* release ILF from digital inputs or bus and general release  *)
	IF OUT_GR.tGR2CU.bSet_GrC_ILF AND IN_GR.tMCB_On.Di AND IN_GR.iIdx_OMSS = 2 THEN
		OUT_GR.bP_Act_ILF_Enable	:= TRUE;
	ELSE
		OUT_GR.bP_Act_ILF_Enable	:= FALSE;
	END_IF;
	
	(* Generate hardware signals *)
	OUT_GR.tILF_SOn.Do := OUT_GR.bILF_SOn_Bus := OUT_GR.bP_Act_ILF_Enable;
	OUT_GR.tILF_SOf.Do := OUT_GR.bILF_SOf_Bus := NOT OUT_GR.bP_Act_ILF_Enable;
		
	(****************** ok bis hier  - Parametercheck notwendig *******************)

(*	IN_GR.bBus_Dem	:= IN_GR.bBus_Dem OR bBus_Dem_Sim;	for simulation only *) 
	
	(* Parameter *)
	
	Para.bSet_FC_Input;
	Para.rDroop_FC_pos;
	Para.rDroop_FC_neg;
	Para.rSetMarg_FC_StaInp;
	Para.rSetMarg_FC_StaInp_Neg;
	Para.iSet_FC_ExtInp;
	Para.rSetMarg_FC_pos;
	Para.rSetMarg_FC_neg;
	Para.bSet_FC_StepOn;

		
	(* Inputs *)
	
	IN_GR.rP_RMC_FC_pos;
	IN_GR.rP_RMC_FC_neg;
	IN_GR.rDroop_FC_pos;
	IN_GR.rDroop_FC_neg;
	IN_GR.bFC_SetCOn;
	IN_GR.bFC_SetCOf;
	IN_GR.bSet_FC_COn_Bus;
	

	OUT_GR.rP_Set_Min := rP_Set_Min := IN_GR.rP_Set_Min_Norm * IN_GR.rP_Nom;

	
	(* calculation of maximal power output for standard input *)	
		
	OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos := LIMIT(0.0, OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos, 0.3);
	OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg := LIMIT(0.0, OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg, 0.3);

	IF OUT_GR.tGR2CU.bSet_GrC_FSM AND NOT Para.bSet_FC_Input THEN
		IF (NOT Para.bSet_FC_TimeActFunctCOn) THEN
			rP_FC_SetMax := ((IN_GR.rP_Nom - (OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos * IN_GR.rP_Nom)) / MAX(1, IN_GR.rP_Nom));						
			rP_FC_SetMin := ((rP_Set_Min   + (OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg * IN_GR.rP_Nom)) / MAX(1, IN_GR.rP_Nom));						
		ELSE 
			rP_FC_SetMax := ((IN_GR.rP_Nom - (Para.rP_SetMarg_FC_TAF * IN_GR.rP_Nom))          / MAX(1, IN_GR.rP_Nom));					
			rP_FC_SetMin := ((rP_Set_Min   + (Para.rP_SetMarg_FC_TAF * IN_GR.rP_Nom))          / MAX(1, IN_GR.rP_Nom));					
		END_IF;
	END_IF;
		                                        
	
	(* calcualtion of maximal and minimal power output for external input *)
		
	IF OUT_GR.tGR2CU.bSet_GrC_FSM AND Para.bSet_FC_Input THEN
		IF OUT_GR.bP_Set_FC_Enable THEN
			CASE Para.iSet_FC_ExtInp OF 
				1: (* e2m over Bus *)
					IF IN_GR.bSet_FC_COn_Bus AND IN_GR.bBus_Dem THEN														
						rP_FC_SetMax := (IN_GR.rP_Nom - IN_GR.rP_RMC_FC_pos)  / MAX(1, IN_GR.rP_Nom);												
						rP_FC_SetMin := (rP_Set_Min   + IN_GR.rP_RMC_FC_neg)  / MAX(1, IN_GR.rP_Nom);
					ELSE
						rP_FC_SetMax := (IN_GR.rP_Nom - Para.rSetMarg_FC_pos) / MAX(1, IN_GR.rP_Nom);			
						rP_FC_SetMin := (rP_Set_Min   + Para.rSetMarg_FC_neg) / MAX(1, IN_GR.rP_Nom);
					END_IF	


				2: (* e2m over hardwire *)
					IF IN_GR.bFC_SetCOn AND (IN_GR.rP_RMC_FC_pos > 0 OR IN_GR.rP_RMC_FC_neg > 0) THEN												
						rP_FC_SetMax := (IN_GR.rP_Nom         - IN_GR.rP_RMC_FC_pos) / MAX(1, IN_GR.rP_Nom);			
						rP_FC_SetMin := (IN_GR.rP_Set_Min_Norm + IN_GR.rP_RMC_FC_neg) / MAX(1, IN_GR.rP_Nom);
					ELSE
						rP_FC_SetMax := 1.0                  - Para.rSetMarg_FC_pos;			
						rP_FC_SetMin := IN_GR.rP_Set_Min_Norm + Para.rSetMarg_FC_neg;
					END_IF


				3: (* next-Box over Bus *)
					IF IN_GR.bSet_FC_COn_Bus AND IN_GR.bBus_Dem THEN												
						rP_FC_SetMax := 1.00;			
						rP_FC_SetMin := rP_Set_Min / MAX(1, IN_GR.rP_Nom);										
					END_IF
		
				4: (* next-Box over hardwire *)
					IF IN_GR.bFC_SetCOn THEN												
						rP_FC_SetMax := 1.00;			
						rP_FC_SetMin := rP_Set_Min / MAX(1, IN_GR.rP_Nom);										
					END_IF

			END_CASE;
		END_IF
	END_IF			
	
	(* Maximum Positive and Negative FSM deltaP Limitation for internal and external input *)
	IF Para.rP_FSM_DeltaLimPos <> 0.0 AND OUT_GR.tGR2CU.bSet_GrC_FSM THEN
		rP_FC_Delta_MxPos := Para.rP_FSM_DeltaLimPos;
	ELSE
		rP_FC_Delta_MxPos := 1.0;					
	END_IF
	IF Para.rP_FSM_DeltaLimNeg <> 0.0 AND OUT_GR.tGR2CU.bSet_GrC_FSM THEN
		rP_FC_Delta_MxNeg := Para.rP_FSM_DeltaLimNeg;
	ELSE
		rP_FC_Delta_MxNeg := -1.0;					
	END_IF

	(* new power point calculation for internal input *) 	
		
	IF NOT Para.bSet_FC_Input AND (Para.iSet_GrC_FSM > 0) THEN// VVP not active
		IF VIS2MM.iSet_FC_Testmode < 5 THEN
			rF_Delta := IN_GR.rF_Ref - IN_GR.rF_Act;
		ELSE
			rF_Delta := OUT_GR.tGR2CU.rFNom_LFSM_Ref - IN_GR.tF_MMD_BusBar[1].Ai;     //rF_FC_Delta 09.01.2017
		END_IF

		rF_Delta_FSMO := rF_LFSMO_GrC_DB_pos - OUT_GR.tGR2CU.rFSMO_GRC_DB;
		rF_Delta_FSMU := rF_LFSMU_GrC_DB_neg + OUT_GR.tGR2CU.rFSMU_GRC_DB;
	
		rF_DeltaCap := LIMIT (- OUT_GR.tGR2CU.rFSMO_GRC_DB, rF_Delta, OUT_GR.tGR2CU.rFSMU_GRC_DB);
			// rF_Delta := LIMIT (- Para.rF_FC_Dlt_neg, rF_Delta, Para.rF_FC_Dlt_pos); //Bug fix of limitation for internal purposes

		rP_FC_Delta	:= 0;
	
		IF (OUT_GR.tGR2CU.rFNom_LFSM_Ref <> 0) AND IN_GR.rP_Nom > 0 THEN
			IF (ABS(rF_Delta) <= ABS(rF_DeltaCap)) OR (NOT Para.bSet_FC_StepOn) THEN
				IF (rF_Delta < 0) AND (IN_GR.rDroop_FC_neg <> 0) THEN//FSMO
					rP_FC_Delta   := ((rF_Delta      * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) - (rF_DeltaCap * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100)) / IN_GR.rP_Nom;		
					rP_Delta_FSMO := -(rF_Delta_FSMO * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) / IN_GR.rP_Nom;
				ELSIF (rF_Delta > 0) AND IN_GR.rDroop_FC_pos <> 0 THEN//FSMU
					rP_FC_Delta   := ((rF_Delta      * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) - (rF_DeltaCap * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100)) / IN_GR.rP_Nom; 
					rP_Delta_FSMU := -(rF_Delta_FSMU * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) / IN_GR.rP_Nom;
				ELSE
					rP_FC_Delta := 0.0;
					rP_Delta_FSMU := 0.0;
					rP_Delta_FSMO := 0.0;
				END_IF;
			ELSE
				IF (rF_Delta < 0) AND IN_GR.rDroop_FC_neg <> 0 THEN//FSMO
					rP_FC_Delta   :=   (rF_Delta      * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) / IN_GR.rP_Nom;
					rP_Delta_FSMO := -((rF_Delta_FSMO * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) - (rF_DeltaCap * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100)) / IN_GR.rP_Nom;
				ELSIF (rF_Delta > 0) AND IN_GR.rDroop_FC_pos <> 0 THEN//FSMU
					rP_FC_Delta   :=   (rF_Delta      * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) / IN_GR.rP_Nom;
					rP_Delta_FSMU := -((rF_Delta_FSMU * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) - (rF_DeltaCap * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100)) / IN_GR.rP_Nom;		
				ELSE
					rP_FC_Delta := 0.0;
					rP_Delta_FSMU := 0.0;
					rP_Delta_FSMO := 0.0;
				END_IF;					
			END_IF;
		ELSE
			rP_FC_Delta := 0.0;
			rP_Delta_FSMU := 0.0;
			rP_Delta_FSMO := 0.0;
		END_IF;
			(* Limit FSM delta *)
			rP_FC_Delta := LIMIT (rP_FC_Delta_MxNeg, rP_FC_Delta, rP_FC_Delta_MxPos);
			rP_Delta_FSMO := MAX(rP_FC_Delta_MxNeg, rP_Delta_FSMO);
			rP_Delta_FSMU := MIN(rP_FC_Delta_MxPos, rP_Delta_FSMU);

			OUT_GR.rP_Set_FC_Norm := LIMIT (rP_FC_SetMin, rP_Set_Unred_Freeze, rP_FC_SetMax) + rP_FC_Delta;
			OUT_GR.rP_FC_ContOutput := rP_FC_Delta * IN_GR.rP_Nom;

	END_IF;

	(* new power point calculation for external input *) 
	
	IF Para.bSet_FC_Input THEN// VVP active

			CASE Para.iSet_FC_ExtInp OF 												
			1,2: (* e2m *)			
	
				rF_Delta := OUT_GR.tGR2CU.rFNom_LFSM_Ref - IN_GR.tF_MMD_BusBar[1].Ai; 				//rF_FC_Delta 09.01.2017
				

				IF VIS2MM.iSet_FC_Testmode < 5 THEN
					rF_Delta := IN_GR.rF_Ref - IN_GR.rF_Act;
				ELSE
					rF_Delta := OUT_GR.tGR2CU.rFNom_LFSM_Ref - IN_GR.tF_MMD_BusBar[1].Ai; 
				END_IF

				rF_Delta_FSMO := rF_LFSMO_GrC_DB_pos - OUT_GR.tGR2CU.rFSMO_GRC_DB;
				rF_Delta_FSMU := rF_LFSMU_GrC_DB_neg + OUT_GR.tGR2CU.rFSMU_GRC_DB;

				rF_DeltaCap := LIMIT (- OUT_GR.tGR2CU.rFSMO_GRC_DB, rF_Delta, OUT_GR.tGR2CU.rFSMU_GRC_DB);
				rF_Delta 	:= LIMIT (- Para.rF_FC_Dlt_neg, rF_Delta, Para.rF_FC_Dlt_pos);		

				rP_FC_Delta	:= 0;

				IF (OUT_GR.tGR2CU.rFNom_LFSM_Ref <> 0) AND IN_GR.rP_Nom > 0 THEN				
					IF (ABS(rF_Delta) <= ABS(rF_DeltaCap)) OR (NOT Para.bSet_FC_StepOn) THEN
						IF (rF_Delta < 0) AND (IN_GR.rDroop_FC_neg <> 0) THEN//FSMO
							rP_FC_Delta   := ((rF_Delta      * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) - (rF_DeltaCap * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100)) / IN_GR.rP_Nom;		
							rP_Delta_FSMO := -(rF_Delta_FSMO * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) / IN_GR.rP_Nom;
						ELSIF (rF_Delta > 0) AND IN_GR.rDroop_FC_pos <> 0 THEN//FSMU
							rP_FC_Delta   := ((rF_Delta      * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) - (rF_DeltaCap * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100)) / IN_GR.rP_Nom; 
							rP_Delta_FSMU := -(rF_Delta_FSMU * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) / IN_GR.rP_Nom;
						ELSE
							rP_FC_Delta := 0.0;
							rP_Delta_FSMU := 0.0;
							rP_Delta_FSMO := 0.0;
						END_IF;
					ELSE
						IF (rF_Delta < 0) AND IN_GR.rDroop_FC_neg <> 0 THEN//FSMO
							rP_FC_Delta   :=   (rF_Delta      * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) / IN_GR.rP_Nom;
							rP_Delta_FSMO := -((rF_Delta_FSMO * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) - (rF_DeltaCap * IN_GR.rP_Nom / IN_GR.rDroop_FC_neg / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100)) / IN_GR.rP_Nom;
						ELSIF (rF_Delta > 0) AND IN_GR.rDroop_FC_pos <> 0 THEN//FSMU
							rP_FC_Delta   :=   (rF_Delta      * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) / IN_GR.rP_Nom;
							rP_Delta_FSMU := -((rF_Delta_FSMU * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100) - (rF_DeltaCap * IN_GR.rP_Nom / IN_GR.rDroop_FC_pos / OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100)) / IN_GR.rP_Nom;		
						ELSE
							rP_FC_Delta := 0.0;
							rP_Delta_FSMU := 0.0;
							rP_Delta_FSMO := 0.0;
						END_IF;
					END_IF;
				ELSE
					rP_FC_Delta := 0.0;
				END_IF;
				(* Limit FSM delta *)
				rP_FC_Delta := LIMIT (rP_FC_Delta_MxNeg, rP_FC_Delta, rP_FC_Delta_MxPos); 
				rP_Delta_FSMO := MAX(rP_FC_Delta_MxNeg, rP_Delta_FSMO);
				rP_Delta_FSMU := MIN(rP_FC_Delta_MxPos, rP_Delta_FSMU);
				
				OUT_GR.rP_Set_FC_Norm := LIMIT (rP_FC_SetMin, rP_Set_Unred_Freeze, rP_FC_SetMax) + rP_FC_Delta;
	
				IF OUT_GR.bP_Set_FC_Enable THEN
					OUT_GR.rP_FC_ContOutput := rP_FC_Delta * IN_GR.rP_Nom;
				ELSE
					OUT_GR.rP_FC_ContOutput := 0.0;
				END_IF

			
			3,4: (* next-Box over Bus *)	

				rP_Set_FC_ExtCalc_Norm := IN_GR.rP_Set_FC / MAX(1, IN_GR.rP_Nom);	

				IF IN_GR.rP_Nom > 0 THEN
					OUT_GR.rP_Set_FC_Norm := LIMIT (rP_FC_SetMin, rP_Set_FC_ExtCalc_Norm, rP_FC_SetMax);
				END_IF

			END_CASE;			
	END_IF	

	IF IN_GR.iIdx_Pset_Type = 5 AND rP_FC_Delta <> 0 THEN             	//In case of powerchange from FSM/LFSM change filtertime of power trajectory GEN2
		bPowerAdjust_LFSM := TRUE;
	ELSE
		bPowerAdjust_LFSM := FALSE;
	END_IF;

	xTOF_FRed.PT := T#10s;												//Use TOF of 10 seconds to switch back to standard filtertime of power trajectory GEN2
	xTOF_FRed.IN := bPowerAdjust_LFSM;
	xTOF_FRed();

	OUT_GR.bGEN2_UsePowtraj_LFSM := xTOF_FRed.Q;	

	OUT_GR.rP_Set_FC_Norm	:= LIMIT(0.0, OUT_GR.rP_Set_FC_Norm, 1.0);

	(**************************************************)
	(******** ILF (Local Frequency Integrator) ********)
	(**************************************************)

	xTON_ILF_DeActive(IN := NOT(bILF_Active), PT := T#300s);

	IF xOpMode.Stop THEN
		bTtrig_Start := FALSE;
	END_IF;
	
	IF OUT_GR.bP_Act_ILF_Enable THEN
		(* read reference and actual frequency - same as FSM functionality *)
		IF VIS2MM.iSet_FC_Testmode < 5 THEN
			rF_Delta_ILF := IN_GR.rF_Ref - IN_GR.rF_Act;
		ELSE
			rF_Delta_ILF := OUT_GR.tGR2CU.rFNom_LFSM_Ref - IN_GR.tF_MMD_BusBar[1].Ai;
		END_IF
		
		(* increase & decrease ramp for ILF - standard engine power ramps *)
		rRamp_ILF_IncGrad_Norm := LIMIT(0.001, IN_GR.rP_Ramp_IncGrad_Norm, 0.3);
		rPRamp_ILF_IncGrad_Norm := rRamp_ILF_IncGrad_Norm / 10; (* Increase Ramp 1/s in a 100ms task *)
		rRamp_ILF_DecGrad_Norm := LIMIT(0.001, IN_GR.rP_Ramp_DecGrad_Norm, 0.3);
		rPRamp_ILF_DecGrad_Norm := rRamp_ILF_DecGrad_Norm / 10; (* Decrease Ramp 1/s in a 100ms task *)
		
		(* Activation/de-activation of ILF *)
		IF (ABS(rF_Delta_ILF) > Para.rF_errActive) THEN
			bILF_Active := TRUE;
			IF NOT bTtrig_Start THEN 
				bTtrig_Start:= TRUE;
			END_IF;
		ELSIF (ABS(rF_Delta_ILF) <= Para.rF_errDeActive) THEN
			bILF_Active := FALSE;
		ELSIF (ABS(rF_Delta_ILF) > Para.rF_errDeActive) AND NOT(xTON_ILF_DeActive.Q) AND bTtrig_Start THEN
			bILF_Active := TRUE;
		END_IF;
		(* DeltaP Integrator calculation *)
		IF bILF_Active AND (IN_GR.rP_Nom > 0.0) THEN
			IF rF_Delta_ILF > 0 AND // positive frequency error (Fact-Fnom)
				((OUT_GR.bP_Set_PFC_Enable AND (OUT_GR.rP_Set_PFC_Norm < 1.0)) OR // FSM, LFSM
				(OUT_GR.bP_Set_PU_Enable AND (OUT_GR.rP_Set_PU_Norm < 1.0)))THEN // PU, use P_set_PU
				(* ILF operation range calculation - consider effect from FSM, LFSM, PU, only ILF *)
					rP_Delta_ILF_Min := 0.0;
					rP_Delta_ILF_Max := (1 - rP_Set_Min / IN_GR.rP_Nom);
					rP_Delta_ILF_Norm := LIMIT(rP_Delta_ILF_Min, rP_Delta_ILF_Norm + rPRamp_ILF_IncGrad_Norm, rP_Delta_ILF_Max);
			ELSIF rF_Delta_ILF < 0 AND // negative frequency error (Fact-Fnom)
				((OUT_GR.bP_Set_PFC_Enable AND (OUT_GR.rP_Set_PFC_Norm > (rP_Set_Min / IN_GR.rP_Nom))) OR // FSM, LFSM
				(OUT_GR.bP_Set_PU_Enable AND (OUT_GR.rP_Set_PU_Norm > (rP_Set_Min / IN_GR.rP_Nom)))) THEN // PU, use P_set_PU
				(* ILF operation range calculation - consider effect from FSM, LFSM, PU, only ILF *)			
					rP_Delta_ILF_Min := -(1 - rP_Set_Min / IN_GR.rP_Nom);
					rP_Delta_ILF_Max := 0.0;
					rP_Delta_ILF_Norm := LIMIT(rP_Delta_ILF_Min, rP_Delta_ILF_Norm - rPRamp_ILF_DecGrad_Norm, rP_Delta_ILF_Max);
			END_IF;
		ELSIF NOT bILF_Active AND xTON_ILF_DeActive.Q THEN
			(* reset integrator if 5min timer is over and not activated *)
			rP_Delta_ILF_Norm := 0.0;
			rP_Delta_ILF_Min := 0.0;
			rP_Delta_ILF_Max := 0.0;
		END_IF;
	ELSE
		rP_Delta_ILF_Norm := 0.0;
		bILF_Active := 0;
		rP_Delta_ILF_Min := 0.0;
		rP_Delta_ILF_Max := 0.0;
	END_IF;	

	(*********************************)
	(******** P(U) Austria ********)
	(*********************************)
	(* P(U) - on/off from  digital inputs *)
	xSR_PU(SET1 := IN_GR.bPU_SetCOn, RESET := IN_GR.bPU_SetCOf);
	bGCP_PU	:= xSR_PU.Q1;

	(* P(U) - on/off from bus *)
	xSR_BC_PU(SET1 := IN_GR.bGenC_PUBC_SetCOn, RESET := IN_GR.bGenC_PUBC_SetCOf);
	bBC_GCP_PU	:= xSR_BC_PU.Q1;
	
	(* release P(U) from HMI bit and general release  *)
	IF (bGCP_PU OR bBC_GCP_PU OR Para.bPU_GrC_SetCOn) AND IN_GR.tMCB_On.Di AND IN_GR.iIdx_OMSS = 2 THEN  
		OUT_GR.bP_Red_PU_Enable	:= TRUE;
	ELSE
		OUT_GR.bP_Red_PU_Enable	:= FALSE;
	END_IF;
	
	IF OUT_GR.bP_Red_PU_Enable THEN
		IF (rUAct_to_URef_Pro >= Para.rPU_GrC_Uknick) AND (Para.rPU_GrC_Ugrenz > Para.rPU_GrC_Uknick) THEN
			rPU_GrC_PsetDelta := (rUAct_to_URef_Pro - Para.rPU_GrC_Uknick)/(Para.rPU_GrC_Ugrenz - Para.rPU_GrC_Uknick);
		ELSE
			rPU_GrC_PsetDelta := 0.0;
		END_IF;
		rPU_GrC_Pset_norm := 1.0 - rPU_GrC_PsetDelta;
	ELSE
		rPU_GrC_PsetDelta := 0.0;
		rPU_GrC_Pset_norm := 1.0;
	END_IF;

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
	
	(*feedback signals*)
	OUT_GR.tPU_SOn.Do	:= 	OUT_GR.bP_Red_PU_Enable;
	OUT_GR.tPU_SOf.Do	:= NOT 	OUT_GR.bP_Red_PU_Enable;
	(****************************************************)
	(** Definition Reference Power to PFC, P(U) and FC **)
	(****************************************************)
	
	iFCMode_old	:= iFCMode;
	IF OUT_GR.bP_Red_PFC_Enable AND rP_LFSM_Delta_c <> 0 THEN (* PFC power setpoint *)
		iFCMode						:=  1;
	ELSIF OUT_GR.bP_Red_PU_Enable AND rPU_GrC_PsetDelta <> 0 THEN 	(* PU power setpoint *)
		iFCMode						:=  2;
	ELSIF OUT_GR.bP_Set_FC_Enable THEN	(* FC set point *)
		iFCMode						:=  3;
	ELSE
		iFCMode						:=  0;
	END_IF;

	IF (iFCMode > 0) AND (iFCMode_old <> iFCMode) AND (iFCMode_old > 0) THEN
		IF IN_GR.bP_Red_Active THEN
			rP_Set_Unred_Freeze	:= IN_GR.rP_Red_Norm;
		ELSE
			IF (iFCMode = 1) THEN 	//von FC nach PFC oder von PU nach PFC
				IF Para.bLFSM_StaticFSMDeadband THEN rP_Set_Unred_Freeze := IN_GR.rP_Set_Unred_Norm_ohne_FC;(*use FSM border power value for start LFSMO/U, romania?*)
				ELSE                                 rP_Set_Unred_Freeze := IN_GR.rP_Set_Unred_Norm;(*use actual power value for start LFSMO/U, standard*)
				END_IF;
			ELSIF (iFCMode = 2) THEN //von FC nach PU oder von PFC nach PU
				IF Para.bLFSM_StaticFSMDeadband THEN rP_Set_Unred_Freeze := IN_GR.rP_Set_Unred_Norm_ohne_FC;(*use FSM border value for start LFSMO/U, romania?*)
				ELSE                                 rP_Set_Unred_Freeze := IN_GR.rP_Set_Unred_Norm;(*use actual power value for start LFSMO/U, standard*)
				END_IF;
			ELSIF (iFCMode = 3) THEN //von PFC nach FC oder von PU nach FC
				                                     rP_Set_Unred_Freeze := IN_GR.rP_Set_Unred_Norm_ohne_FC;
			END_IF;	
		END_IF;
	END_IF;
	
	(******************************************)
	(** Arbitration between PFC, P(U) and FC **)
	(******************************************)

	OUT_GR.rP_Red_PFC_Norm	   	:=	1.0;	//absolute mode - power reduction - is not valid anymore from 4.5
	
	TP_FC_ResetPulse(IN := (OUT_GR.bP_Red_EU_Enable AND (ABS(rP_Red_EU_Norm_old - OUT_GR.rP_Red_EU_Norm) > 0.01)), PT := tFC_dPset);(* new Pset if Plim changes more then 1% *)
	rP_Red_EU_Norm_old := OUT_GR.rP_Red_EU_Norm;
	rP_Set_Unred_Norm_ohne_FC_old := IN_GR.rP_Set_Unred_Norm_ohne_FC;

	IF OUT_GR.bP_Red_PFC_Enable AND rP_LFSM_Delta <> 0 THEN		(* PFC power setpoint *)
		IF (NOT Para.bLFSM_GrC_Pref) AND (rP_LFSM_Delta < 0.0) THEN (* Reference power is the power set existing when the frequency exceeds the frequency threshold *)
			rP_ref_LFSM := rP_Set_Unred_Freeze;
		ELSE (* Reference power is the nominal power *)
			rP_ref_LFSM := 1.0;
		END_IF;
		IF Para.bLFSM_StaticFSMDeadband THEN
			IF rP_LFSM_Delta > 0.0 THEN OUT_GR.rP_Set_PFC_Norm := LIMIT(0.0, rP_Set_Unred_Freeze + (rP_ref_LFSM * rP_LFSM_Delta) + rP_Delta_FSMU + rP_Delta_ILF_Norm, 1.0);//use FSM border value for start LFSMU
			ELSE						OUT_GR.rP_Set_PFC_Norm := LIMIT(0.0, rP_Set_Unred_Freeze + (rP_ref_LFSM * rP_LFSM_Delta) + rP_Delta_FSMO + rP_Delta_ILF_Norm, 1.0);//use FSM border value for start LFSMO
			END_IF;
		ELSE
			                            OUT_GR.rP_Set_PFC_Norm := LIMIT(0.0, rP_Set_Unred_Freeze + (rP_ref_LFSM * rP_LFSM_Delta) + rP_Delta_ILF_Norm, 1.0); (*standard*)
		END_IF;
		OUT_GR.bP_Set_PFC_Enable	:=	TRUE;
		OUT_GR.bP_Set_PU_Enable		:=  FALSE;
	ELSIF OUT_GR.bP_Red_PU_Enable AND rPU_GrC_PsetDelta <> 0 THEN 	(* PU power setpoint *)						
		OUT_GR.rP_Set_PU_Norm		:= 	LIMIT(IN_GR.rP_Set_Min_Norm, rP_Set_Unred_Freeze * rPU_GrC_Pset_norm  + rP_Delta_ILF_Norm, 1.0);
		OUT_GR.bP_Set_PU_Enable 	:= 	TRUE;	
		OUT_GR.bP_Set_PFC_Enable	:=	FALSE;
	ELSIF OUT_GR.bP_Set_FC_Enable THEN 	(* FC power setpoint *)
		IF TP_FC_ResetPulse.Q THEN
			rP_Set_Unred_Freeze	:= IN_GR.rP_Set_Unred_Norm_ohne_FC;
		END_IF;
		IF rP_FC_Delta = 0 THEN
			rP_Set_Unred_Freeze	:= IN_GR.rP_Set_Unred_Norm_ohne_FC;
		END_IF;
		OUT_GR.rP_Set_PFC_Norm		:=  LIMIT(IN_GR.rP_Set_Min_Norm, OUT_GR.rP_Set_FC_Norm + rP_Delta_ILF_Norm, 1.0);
		OUT_GR.bP_Set_PFC_Enable	:=	TRUE;
		OUT_GR.bP_Set_PU_Enable		:=  FALSE;
	ELSIF OUT_GR.bP_Act_ILF_Enable THEN (* only ILF active*)
		OUT_GR.rP_Set_PFC_Norm 		:= 	LIMIT(IN_GR.rP_Set_Min_Norm, rP_Set_Unred_Freeze + rP_Delta_ILF_Norm, 1.0);
		OUT_GR.bP_Set_PFC_Enable	:=	TRUE;
		OUT_GR.bP_Set_PU_Enable		:=  FALSE;
	ELSE
		rP_Set_Unred_Freeze			:=	IN_GR.rP_Set_Norm;
		OUT_GR.rP_Set_PFC_Norm		:=	1.0;
		OUT_GR.bP_Set_PFC_Enable	:=	FALSE;
		OUT_GR.rP_Set_PU_Norm		:=	1.0;
		OUT_GR.bP_Set_PU_Enable		:=	FALSE;
	END_IF;
	
	IF NOT IN_GR.tGCB_On.Di THEN 
		rP_Set_Unred_Freeze	:= IN_GR.rP_Set_Unred_Norm_ohne_FC;
	END_IF;	
	(***** Interfaces to HMI  *****)
	
	MM2VIS.rP_Set_Unred_Freeze	:= rP_Set_Unred_Freeze;
	MM2VIS.rP_Red_PFC_Norm		:= OUT_GR.rP_Red_PFC_Norm;
	MM2VIS.rP_Set_PFC_Norm		:= OUT_GR.rP_Set_PFC_Norm;
	MM2VIS.bP_Set_PFC_Enable	:= OUT_GR.bP_Set_PFC_Enable;
	
	(***************************************)

			(* calculation of new power ramp *)

			Para.bPRamp_FC_SetCOn;									// Para: activation frequency control power ramp 
			Para.bPRamp_FC_ExtInp;									// Para: activation frequency control external input for power ramp 
			Para.rPRamp_FC_IncGrad_Norm;							// Para: power ramp increase frequency control [%Pnom/s]
			Para.rPRamp_FC_DecGrad_Norm;							// Para: power ramp decrease frequency control [%Pnom/s]
			Para.bCalc_PRamp_FC_active;								// Para: calculation of power ramp active
			Para.tiSetTime_FC_PRamp;								// Para: power ramp pass-through time

			(* Ende neu ============================================================================ *)	

	(* Freigabe schnelle Lastrampe bei EU Zugriff auf Leistungsvorgabe *)
	//	Para.bGridCode_Active;		(* schnelle Rampe generell aktiv Para.bGridCode_Active = TRUE *) (*  brauchen wir nicht 28.11.2013 *)
	IN_GR.rP_Act_Norm_Filt;			(* Istleistung >= 50% Nennleistung HYSTERESE? 50%/5%HY *)
	xGR_MAX_RampEU(In := IN_GR.rP_Act_Norm_Filt , Gw := IN_GR.rP_Set_Min_Norm, Hy := 0.05);
	xF_TRIG_Start(CLK := xOpMode.Stop);

	(* EU greift wirklich aktiv auf die Leistung zu *)
	IN_GR.iIdx_Pset_Type;(* Fall 1: Aktueller Sollwert kommt vom EU usPowerSetpTyp = 6 *)					// old: 5;
	IN_GR.iIdx_Pred_Type; (* Fall 2: Leistungsreduktion EU wirkt usPowerRedTyp = 25 and 31 *)				// old: 25;
	Para.rPRamp_GrC_SetEUPar;(* ACHTUNG: Umrechnung in [kW/s] noetig! *)
		
	(* FC greift wirklich aktiv auf die Leistung zu *)
	IN_GR.iIdx_Pset_Type;(* Fall 1: Aktueller Sollwert nach FC usPowerSetpTyp = 5 *)
	IN_GR.iIdx_Pred_Type; (* Fall 2: Leistungsreduktion nach FC wirkt usPowerRedTyp = 5 and 32 *)
	Para.rPRamp_FC_DecGrad_Norm;(* ACHTUNG: Umrechnung in [kW/s] noetig! *)
	Para.rPRamp_FC_IncGrad_Norm;(* ACHTUNG: Umrechnung in [kW/s] noetig! *)
	Para.tiSetTime_FC_PRamp;
	IN_GR.rP_Act_Norm_Filt;			(* Istleistung >= 50% Nennleistung HYSTERESE? 50%/5%HY *)
	xGR_MAX_RampFC(In := IN_GR.rP_Act_Norm_Filt , Gw := IN_GR.rP_Set_Min_Norm, Hy := 0.05);
	xF_TRIG_Start(CLK := xOpMode.Stop);
			
	(* Freigabe langsame Belastungsrampe nach Netzfehler *)			
	xTON_FGDRPS(IN := IN_GR.tPB2MM.bParaSetupOk, PT := T#100s); 
	IF xTON_FGDRPS.Q THEN
		xTON_lRamp.PT := Para.tiP_GrC_SetNOK;  (* Time delay after mains ok message [s]*)	
	ELSE
		xTON_lRamp.PT := T#5s;				(* just a default value *)
	END_IF;
	
	xTON_lRamp.IN := IN_GR.tMnsOk.Di; 	(* hand over the input signal from main monitoring unit *)
	xTON_lRamp(); 	(* holding time after grid failure for gridcode rules *)

	(* power ramp after grid connection *)
	xTON_Mp.PT := REAL_TO_TIME((30 + (1 / MAX(0.0001, Para.rPRamp_GrC_AftGridConn))) * 1000);
	xTON_Mp.IN := IN_GR.tGCB_On.Di AND IN_GR.tMCB_On.Di AND IN_GR.tPB2MM.bParaSetupOk;
	xTON_Mp();

	IF    IN_GR.tPB2MM.bParaSetupOk AND NOT IN_GR.tMCB_On.Di THEN bPRampAftGridConn := TRUE;
	ELSIF xTON_Mp.Q                                          THEN bPRampAftGridConn := FALSE;
	END_IF;

	(* delayed use of calculated power ramp after engine demand, to reach power setpoint for primaere regelenergie within 5 minutes *)
	xTON_RelCalc_PRamp_FC(IN:= IN_GR.bEng_Dem, PT:= T#300s);
				
	(********************************************************************************)
	//	Prioritaet der unterschiedlichen Rampen:
	//  1. Rampe von extern EVU (Rise AND Sink - Aktivierung mit Parameter 11627)
	//	2. Langsame Belastungsrampe nach Netzfehler (nur Rise - Aktivierung mit Parameter 11626) 
	//  3. Lastrampe nach Uebergang von LFSM nach FSM (Rise AND Sink - Aktivierung mit Parameter 11628)
	//	4. Lastrampe im LFSM Bereich (Rise AND Sink - Aktivierung mit Parameter 14173)
   	//	5. Lastrampe wenn EVU auf Leistungsvorgabe aktiv eingreift (Rise AND Sink - Aktivierung mit Parameter 11627)
	//	6. Lastrampe nach EVU Eingriff auf Leistungsvorgabe (Rise AND Sink - Aktivierung mit Parameter .....)//LE
	//  7. Rampe im FSM Bereich (Rise AND Sink - Aktivierung mit Parameter 13455)
	//	8. power ramp after grid connection (GCB_On+MCB_On) - parameter#14479,14480
	//	9. Aktuelle Lastrampe (Bestand)

	OUT_GR.bP_Ramp_DecGrad_GR_Enable		:=FALSE;
	OUT_GR.bP_Ramp_IncGrad_GR_Enable		:=FALSE;
	OUT_GR.rP_Ramp_IncGrad_GR_Norm			:= Para.rPRamp_GrC_SetEUPar;								// power decrease ramp from EU
	OUT_GR.rP_Ramp_DecGrad_GR_Norm			:= Para.rPRamp_GrC_SetEUPar;								// power increase ramp from EU	
	OUT_GR.bPRamp_GrC_SetErr				:= FALSE;

	IF Para.bPowerRampEU_Ena AND (bGCP_Ramp_GrC OR bBC_Ramp_GrC) THEN   
		OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
		OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= rRamp_GrC_IncGrad;									// power decrease ramp from external	
		OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
		OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= rRamp_GrC_DecGrad;									// power increase ramp from external
	ELSIF (Para.bPRamp_GrC_SetErrCOn AND NOT xTON_lRamp.Q) THEN
		OUT_GR.bP_Ramp_IncGrad_GR_Enable	:= TRUE;
		OUT_GR.bPRamp_GrC_SetErr			:= TRUE;
		OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= Para.rPRamp_GrC_SetErr; // slow power ramp after mains failure (only increase ramp)
	ELSIF (Para.bPRamp_GrC_SetPFCCOn AND bSlowRampafterPFC) THEN
		OUT_GR.bP_Ramp_IncGrad_GR_Enable	:= TRUE;
		OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= Para.rPRamp_GrC_SetNachLFSM; // slow power ramp PFC function (increase and decrease)
		IF (IN_GR.bEng_Dem) THEN
			OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
			OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= Para.rPRamp_GrC_SetNachLFSM;
		END_IF;
	ELSIF Para.bPRamp_GrC_SetLFSMCOn AND xGR_MAX_RampEU.Q AND ((IN_GR.iIdx_Pred_Type = 32) OR ((IN_GR.iIdx_Pset_Type = 5) AND rP_LFSM_Delta <> 0) OR (IN_GR.iIdx_Pset_Type = 8)) THEN
		OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
		OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
		IF    rP_LFSM_Delta < 0 THEN (* LFSMO = active *)
			OUT_GR.rP_Ramp_DecGrad_GR_Norm	:= Para.rPRampDown_LFSMO;								// power decrease ramp for PFC
			OUT_GR.rP_Ramp_IncGrad_GR_Norm	:= Para.rPRampUp_LFSMO;									// power increase ramp for PFC
		ELSIF rP_LFSM_Delta > 0 THEN (* LFSMU = active *)
			OUT_GR.rP_Ramp_DecGrad_GR_Norm	:= Para.rPRampDown_LFSMU;								// power decrease ramp for PFC
			OUT_GR.rP_Ramp_IncGrad_GR_Norm	:= Para.rPRampUp_LFSMU;									// power increase ramp for PFC
		ELSE
			OUT_GR.rP_Ramp_DecGrad_GR_Norm	:= Para.rPRamp_GrC_SetEUPar;							// power decrease ramp for PFC
			OUT_GR.rP_Ramp_IncGrad_GR_Norm	:= Para.rPRamp_GrC_SetEUPar;							// power increase ramp for PFC
		END_IF;
	ELSIF Para.bPRamp_GrC_SetEUCOn AND xGR_MAX_RampEU.Q AND ((IN_GR.iIdx_Pset_Type = 6) OR (IN_GR.iIdx_Pred_Type = 25) OR (IN_GR.iIdx_Pred_Type = 31) OR IN_GR.tDI_Dem_EU_Block.Di OR IN_GR.bEng_Block_EVU) THEN
		OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
		OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= Para.rPRamp_GrC_SetEUPar;								// power decrease ramp from EU
		OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
		OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= Para.rPRamp_GrC_SetEUPar;								// power increase ramp from EU
	ELSIF Para.bPRamp_GrC_AftPLim_Active AND bSlowRampafterPLim THEN //LE_a 27.11.2019
		OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
		OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= Para.rPRamp_GrC_AftPLim; // slow power ramp after PLim function (increase and decrease)
		IF (IN_GR.bEng_Dem) THEN
			OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
			OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= Para.rPRamp_GrC_AftPLim;
		END_IF; //LE_e

	ELSIF Para.bPRamp_FC_SetCOn AND xGR_MAX_RampFC.Q AND (((IN_GR.iIdx_Pset_Type = 5) AND (rP_FC_Delta <> 0)) OR (IN_GR.iIdx_Pred_Type = 32) OR ((IN_GR.iIdx_Pred_Type = 5) OR (IN_GR.iIdx_Pred_Type = 34)) OR IN_GR.tDI_Dem_EU_Block.Di OR IN_GR.bEng_Block_EVU) THEN
		IF Para.bCalc_PRamp_FC_active AND Para.tiSetTime_FC_PRamp <> 0 AND IN_GR.rP_Nom <> 0 THEN
			IF xTON_RelCalc_PRamp_FC.Q THEN
				IF (IN_GR.bSet_FC_COn_Bus AND IN_GR.bBus_Dem) OR (IN_GR.bFC_SetCOn AND (IN_GR.rP_RMC_FC_neg > 0.0 OR IN_GR.rP_RMC_FC_pos > 0.0)) THEN 
					OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
					rP_Ramp_DecGrad_GR_Temp_Norm		:= MAX (IN_GR.rP_RMC_FC_pos, IN_GR.rP_RMC_FC_neg) / IN_GR.rP_Nom / TIME_TO_REAL(Para.tiSetTime_FC_PRamp) * 1000.0;		// power decrease ramp calculated for FC	
					OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= rP_Ramp_DecGrad_GR_Temp_Norm;		// power decrease ramp calculated for FC	
					OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
					rP_Ramp_IncGrad_GR_Temp_Norm		:= MAX (IN_GR.rP_RMC_FC_pos, IN_GR.rP_RMC_FC_neg) / IN_GR.rP_Nom / TIME_TO_REAL(Para.tiSetTime_FC_PRamp) * 1000.0;		// power increase ramp calculated for FC	
					OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= rP_Ramp_IncGrad_GR_Temp_Norm;
				ELSE
					OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
					OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= Para.rPRamp_FC_DecGrad_Norm;								// power decrease ramp from parameter for FC	
					OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
					OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= Para.rPRamp_FC_IncGrad_Norm;								// power increase ramp from parameter for FC
				END_IF;
			ELSE
				OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
				OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= Para.rPRamp_FC_DecGrad_Norm;								// power decrease ramp from parameter for FC	
				OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
				OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= Para.rPRamp_FC_IncGrad_Norm;								// power increase ramp from parameter for FC
			END_IF;
		ELSE 
			OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
			OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= Para.rPRamp_FC_DecGrad_Norm;									// power decrease ramp from parameter for FC	
			OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
			OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= Para.rPRamp_FC_IncGrad_Norm;									// power increase ramp from parameter for FC	
		END_IF;


	ELSIF Para.bPRamp_GrC_AftGridConn_Active AND bPRampAftGridConn THEN
		OUT_GR.bP_Ramp_IncGrad_GR_Enable 	:= TRUE;
		OUT_GR.rP_Ramp_IncGrad_GR_Norm		:= Para.rPRamp_GrC_AftGridConn;
		OUT_GR.bP_Ramp_DecGrad_GR_Enable 	:= TRUE;
		OUT_GR.rP_Ramp_DecGrad_GR_Norm		:= Para.rPRamp_GrC_AftGridConn;
	
	END_IF;

	OUT_GR.bP_Ramp_IncGrad_GR_Enable;
	OUT_GR.rP_Ramp_IncGrad_GR_Norm;
	OUT_GR.bP_Ramp_DecGrad_GR_Enable;
	OUT_GR.rP_Ramp_DecGrad_GR_Norm;
	(* Ende  ============================================= *)
	
	(* reset of the slow power ramp after PLim intervention *);//LE_a 27.11.2019
	TON_SlowRampafterPLim(IN := bSlowRampafterPLim, PT := tiWaitPLim);
	IF (((Para.bPRamp_GrC_AftPLim_Active AND IN_GR.bP_Ramp_Target_Reached) OR NOT bstatGC_rel) AND TON_SlowRampafterPLim.Q) OR NOT IN_GR.tGCB_On.Di THEN (* reset after sucessful finish or if gridcode is active  *)
		bSlowRampafterPLim := FALSE;
	END_IF;//LE_e


	//	TP_SlowRampafterPFC(IN := bSlowRampafterPFC, PT := tVerz);
	TON_SlowRampafterPFC(IN := bSlowRampafterPFC, PT := tWaitPFC);
	
	(* reset of the slow power ramp after PFC intervention *)
	IF (((Para.bPRamp_GrC_SetPFCCOn AND IN_GR.bP_Ramp_Target_Reached) OR NOT bstatGC_rel) AND TON_SlowRampafterPFC.Q) OR (iFCMode = 1) THEN (* reset after sucessful finish or if gridcode is active  *)
		bSlowRampafterPFC 	:= FALSE;
	END_IF
	
	(* Trigger for the FC *)

                rF_FC_Delta := OUT_GR.tGR2CU.rFNom_LFSM_Ref - IN_GR.tF_MMD_BusBar[1].Ai;     //frequency deviation 
		bFC_Trigger := ABS(rF_FC_Delta) > Para.rF_FC_Deadband_TAF_pos;


	
	
		(* Reset of the releases *)
		OUT_GR.bP_Red_POR_Enable 	:= FALSE;
		OUT_GR.bP_Red_SOR_Enable 	:= FALSE;
		OUT_GR.bP_Red_TOR1_Enable 	:= FALSE;
		OUT_GR.bP_Red_TOR2_Enable 	:= FALSE;
		OUT_GR.bP_Red_RR_Enable 	:= FALSE;
		OUT_GR.bP_Red_SR_Enable 	:= FALSE;
		OUT_GR.bP_Red_HFC_Enable	:= FALSE;
			
		(* Time delays for the FC states *)
		TON_POR(PT := Para.tiSetTime_FC_POR);									(*Para:POR (Primary Operational Reserve) time*)
		TON_SOR(PT := Para.tiSetTime_FC_SOR);									(*Para:SOR (Secondary Operational Reserve) time*)
		TON_TOR1(PT := Para.tiSetTime_FC_TOR);									(*Para:TOR (Tertiary Operational Reserve) time*)
		TON_TOR2(PT := Para.tiSetTime_FC_TOR2);									(*Para:TOR 2 (Tertiary 2 Operational Reserve) time*)
		TON_RR(PT := Para.tiSetTime_FC_RR);										(*Para:RR (Replacement Reserve) time*)
		TON_SR(PT := Para.tiSetTime_FC_SR);										(*Para:SR (Substitute Reserve) time*)
			
		(* reset of the time delays *)
		TON_POR.IN 	:= TON_SOR.IN	:= TON_TOR1.IN	:= TON_TOR2.IN	:= TON_RR.IN	:= TON_SR.IN := FALSE; 
	
		IF (NOT bFC_Trigger) OR (NOT IN_GR.tMCB_On.Di) OR (NOT IN_GR.tGCB_On.Di) OR (NOT IN_GR.iIdx_OMSS = 2) THEN
				iFC_State := 0; 		(* reset of AFC state machine *)
		END_IF
		
		iFC_State_int	:= 	iFC_State;	
		
		(* HFC *)		
		IF Para.bSet_FC_HFRCOn THEN 		// Para.bSet_FC_TimeActFunctCOn	 09.01.2017
			IF (Para.rF_Nom[1] + Para.rF_FC_Deadband_TAF_pos) < IN_GR.tF_MMD_BusBar[1].Ai THEN  // OR ((Para.rF_Nom[1] - Para.rF_FC_Deadband_neg) > IN_GR.tF_MMD[1].Ai) THEN					// 09.01.2017	!!CHECK again!!
				iFC_State := 5; (* jump straight into the HFC Mode *)
			END_IF	
		END_IF		

		CASE iFC_State OF
		0: 	(* normal operation *)
			(* change to PFC *)
			IF Para.bSet_FC_PORCOn AND Para.tiSetTime_FC_POR <> 0 THEN 	(* check if the function is active  *)								
				IF bFC_Trigger THEN 			(* check the AFC trigger *)
					iFC_State := 10; 			(* change to PFC *)
				ELSE
					iFC_State := 0; 			(* change to normal operation *)	
				END_IF
			END_IF
		5: 	(*  HFC Mode*)	
			OUT_GR.bP_Red_HFC_Enable := TRUE;
			IF ((Para.rF_Nom[1] + OUT_GR.tGR2CU.rFSMU_GRC_DB) > IN_GR.tF_MMD_BusBar[1].Ai) THEN
				iFC_State := 0; 			(* change to normal operation *)	
			END_IF
		10: (* primary operation reserve *)
			(* release primary operation reserve from digital inputs or bus and general release  *)
			OUT_GR.bP_Red_POR_Enable := TRUE;
			
			(* start the time delay *)
			TON_POR.IN := TRUE;
	
			(* change to SOR *)
			IF TON_POR.Q THEN 					(* check the time delay of PFC *)
				IF Para.bSet_FC_SORCOn AND Para.tiSetTime_FC_SOR <> 0 THEN																		
					iFC_State := 20; 			(* change to SOR *)	
				ELSE
					iFC_State := 0; 			(* change to normal operation *)	
				END_IF
			END_IF
	
		20: (* secondary operation reserve *)	
			(* release secondary operation reserve from digital inputs or bus and general release  *)
			OUT_GR.bP_Red_SOR_Enable := TRUE;
		
			(* start the time delay *)
			TON_SOR.IN := TRUE;
					
			(* change to TOR1 *)
			IF TON_SOR.Q THEN 				(* check the time delay of SOR *)
				IF Para.bSet_FC_TORCOn AND Para.tiSetTime_FC_TOR <> 0 THEN																		
					iFC_State := 30; 			(* change to TOR1 *)
				ELSE
					iFC_State := 0; 				(* change to normal operation *)	
				END_IF
			END_IF
		30: (* tertiary 1 operation reserve *)
			(* release tertiary 1 operation reserve from digital inputs or bus and general release  *)
			OUT_GR.bP_Red_TOR1_Enable := TRUE;
			
			(* start the time delay *)
			TON_TOR1.IN := TRUE;
	
			(* change to TOR2 *)
			IF TON_TOR1.Q THEN 				(* check the time delay of TOR1 *)
				IF Para.bSet_FC_TOR2COn AND Para.tiSetTime_FC_TOR2 <> 0 THEN																		
					iFC_State := 40; 			(* change to TOR2 *)
				ELSE
					iFC_State := 0; 				(* change to normal operation *)	
				END_IF
			END_IF
		40: (* tertiary 2 operation reserve *)
			(* release tertiary 2 operation reserve from digital inputs or bus and general release  *)
			OUT_GR.bP_Red_TOR2_Enable := TRUE;
			
			(* start the time delay *)
			TON_TOR2.IN := TRUE;
	
			(* change to RR *)
			IF TON_TOR2.Q THEN 				(* check the time delay of TOR2 *)
				IF Para.bSet_FC_RRCOn AND Para.tiSetTime_FC_RR <> 0 THEN																		
					iFC_State := 50; 			(* change to RR *)
				ELSE
					iFC_State := 0; 				(* change to normal operation *)
				END_IF	
			END_IF
	
		50: (* replacement reserve *)
			(* release replacement operation reserve from digital inputs or bus and general release  *)
			OUT_GR.bP_Red_RR_Enable := TRUE;
		
			(* start the time delay *)
			TON_RR.IN := TRUE;
	
			(* change to RR *)
			IF TON_RR.Q THEN 				(* check the time delay of RR *)
				IF Para.bSet_FC_SRCOn AND Para.tiSetTime_FC_SR <> 0 THEN																			
					iFC_State := 60; 			(* change to SR *)
				ELSE
					iFC_State := 0; 				(* change to normal operation *)
				END_IF	
			END_IF
	
		60: (* substitute reserve *)
			(* release substitute operation reserve from digital inputs or bus and general release  *)
			OUT_GR.bP_Red_SR_Enable := TRUE;
		
			(* start the time delay *)
			TON_SR.IN := TRUE;
	
			(* change to normal operation *)
			IF TON_SR.Q THEN 				(* check the time delay of SR *)
				iFC_State := 0; 				(* change to normal operation *)	
			END_IF
		ELSE	
			iFC_State := 0; (* just a default value *)
		END_CASE	
END_PROGRAM
