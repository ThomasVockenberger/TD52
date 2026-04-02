(*******************************************************************************
General		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0	25.04.2012	lettenb.	new
V3.99.0	07.03.2013	lettenb.	cleanup
V4.05.0	31.10.2016				parameter check FOR diagnosis added
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* check para setup *)
	IN_AB.tPB2MM.bParaSetupOk;
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
	
	CASE IN_AB.iIdx_OMSS OF
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
	xOpMode(in:= IN_AB.iSt_OpMode);

	(* PLC Running *) 
	IN_AB.tPB2MM.bSys_Run;

	(* engine start speed exceeded *)
	xGR_MAX_N_EngStart(In:= IN_AB.rN_EngAct, Gw:= Para.rN_EngStart_LimHi, Hy:= Para.rN_EngStart_HyHi);
	xTOF_N_EngStart(IN := xGR_MAX_N_EngStart.Q AND IN_AB.tPB2MM.bParaSetupOk, PT:= T#10s);
	bN_EngStart := xTOF_N_EngStart.Q;
	




END_PROGRAM
