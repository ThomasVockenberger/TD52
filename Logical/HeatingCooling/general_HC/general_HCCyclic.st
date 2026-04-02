(*******************************************************************************
general_HC		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0	25.04.2012	lettenb.	new
V3.99.0 21.02.2013	lettenb.	cleanup
V4.03.0 11.01.2015	Denk		Bugfix, OUT_HC.tHWF_Dem.Do not implemented
		15.03.2016	Denk		Bugfix, Handbedienebene. OR IN_HC.tManAuxCtr.bHWF_Dem;
V4.05.0 11.12.2017	lettenb.	check para setup added
V4.14.0 08.11.2024	Bacci		OUT_HC.tECW_ShutOffVal_Dem.Do, OUT_HC.tValHeater_Dem.Do, OUT_HC.tFanRingHeater_Dem.Do added
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT

	xECW_ShutOffVal_Dem_Active.enable := TRUE;
	xECW_ShutOffVal_Dem_Active.pPVstring := ADR('HalIO::ECW_ShutOffVal_Dem');
	xECW_ShutOffVal_Dem_Active();
	bECW_ShutOffVal_Dem_Exist := xECW_ShutOffVal_Dem_Active.exist;

	xValHeater_Dem_Active.enable := TRUE;
	xValHeater_Dem_Active.pPVstring := ADR('HalIO::ValHeater_Dem');
	xValHeater_Dem_Active();
	bValHeater_Dem_Exist := xValHeater_Dem_Active.exist;

	xFanRingHeater_Dem_Active.enable := TRUE;
	xFanRingHeater_Dem_Active.pPVstring := ADR('HalIO::FanRingHeater_Dem');
	xFanRingHeater_Dem_Active();
	bFanRingHeater_Dem_Exist := xFanRingHeater_Dem_Active.exist;

END_PROGRAM

PROGRAM _CYCLIC

	(* check para setup *)
	IN_HC.tPB2MM.bParaSetupOk;
	Para.iEng_Motortype;    (* MIN= 208   MAX= 920    *)
	Para.rN_EngStart_LimHi; (* MIN= 50.0  MAX= 2200.0 *)

	(* engine type defnition *)
	xEngType.Motortype := INT_TO_UINT(Para.iEng_Motortype);
	xEngType();

	(* engine operating mode selection *)
	bOMSS_Stop := FALSE;
	bOMSS_Man  := FALSE;
	bOMSS_Aut  := FALSE;
	bOMSS_Test := FALSE;
	bOMSS_Scav := FALSE;
	bOMSS_MAT  := FALSE;
	
	CASE IN_HC.iIdx_OMSS OF
	0:	bOMSS_Stop := TRUE;
	1:	bOMSS_Man  := TRUE;
		bOMSS_MAT  := TRUE;
	2:	bOMSS_Aut  := TRUE;
		bOMSS_MAT  := TRUE;
	3:	bOMSS_Test := TRUE;
		bOMSS_MAT  := TRUE;
	4:	bOMSS_Scav := TRUE;	
	END_CASE;

	(* engine operating mode *)
	xOpMode(in:= IN_HC.iSt_OpMode);

	
	(*----------------------------------------------------------------------------------*)
	(* engine start speed *) 
	xGR_MAXR_N_EngStart(In:= IN_HC.rN_EngAct, Gw:= Para.rN_EngStart_LimHi, Hy:= Para.rN_EngStart_HyHi);
	xTOF_N_EngStart(IN:= xGR_MAXR_N_EngStart.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#10s);
	bN_EngStart := xTOF_N_EngStart.Q;
	
	
	(*----------------------------------------------------------------------------------*)
	(* demand heating circuit flap *)
	OUT_HC.tHWF_Dem.Do := (IN_HC.bEng_Aux_Dem_CDR AND NOT IN_HC.bMsg1053 AND NOT IN_HC.bMsg1054 AND NOT IN_HC.bMsg1031)
						   OR IN_HC.tManAuxCtr.bHWF_Dem;
	
	
	(*----------------------------------------------------------------------------------*)
	(* demand 2-way shut off valve engine jacket water circuit (P.04(06)-YCS-029) *)
	OUT_HC.tECW_ShutOffVal_Dem.Do := IN_HC.bEng_Aux_Dem_CDR;


	(*----------------------------------------------------------------------------------*)
	(* demand 3-way valve heater (P.04/06/07-H-001) *)
	OUT_HC.tValHeater_Dem.Do := (NOT bT_AirOutdoor_Hi1 AND Para.bT_AirOutdoor_Active)
							 	 AND NOT IN_HC.bMsg1031
								 AND NOT IN_HC.bMsg1053
								 AND NOT IN_HC.bMsg1054;


	(*----------------------------------------------------------------------------------*)
	(* demand fan ring heater (P.04/06/07/09H-100) *)
	OUT_HC.tFanRingHeater_Dem.Do := (NOT bT_AirOutdoor_Hi1 AND Para.bT_AirOutdoor_Active)
							 		 AND NOT IN_HC.bMsg1031
									 AND NOT IN_HC.bMsg1053
									 AND NOT IN_HC.bMsg1054;


END_PROGRAM

