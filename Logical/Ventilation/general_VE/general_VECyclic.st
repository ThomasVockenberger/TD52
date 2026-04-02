(*******************************************************************************
general			general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.99.0	24.04.2012	lettenb.	new
V4.05.0 11.12.2017	lettenb.	check para setup added
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* check para setup *)
	IN_VE.tPB2MM.bParaSetupOk;
	Para.iEng_Motortype;    (* MIN= 208   MAX= 920    *)
	Para.rN_EngStart_LimHi; (* MIN= 50.0  MAX= 2200.0 *)

	(* engine type defnition *)
	xEngType.Motortype := INT_TO_UINT(Para.iEng_Motortype);
	xEngType();

	(* engine operating mode selection *)
	bOMSS_Man  := FALSE;
	bOMSS_Aut  := FALSE;
	bOMSS_Test := FALSE;
	bOMSS_Scav := FALSE;
	bOMSS_MAT  := FALSE;
	
	CASE IN_VE.iIdx_OMSS OF
	1:	bOMSS_Man  := TRUE;
		bOMSS_MAT  := TRUE;
	2:	bOMSS_Aut  := TRUE;
		bOMSS_MAT  := TRUE;
	3:	bOMSS_Test := TRUE;
		bOMSS_MAT  := TRUE;
	4:	bOMSS_Scav := TRUE;	
	END_CASE;

	(* engine operating mode *)
	xOpMode(in:= IN_VE.iSt_OpMode);


	(*---------------------------------------------------------------------------*)
	(* start speed exceeded *)
	xGR_MAXR_DREHZ(In:= IN_VE.rN_EngAct, Gw:= Para.rN_EngStart_LimHi, Hy:= Para.rN_EngStart_HyHi);
	xTOF_M_DREHZ(IN:= xGR_MAXR_DREHZ.Q AND IN_VE.tPB2MM.bParaSetupOk, PT:= T#10s);
	M_DREHZ := xTOF_M_DREHZ.Q;
	


END_PROGRAM
