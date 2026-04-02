(*******************************************************************************
T_EO			engine oil temperature

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.99.0	20.02.2013	lettenb.	new from task: otp
		
Instructions for use:
--------------------

Outstandings:
------------
(*******************************************************************************)

PROGRAM _CYCLIC

	(* engine oil temperature high 1 *)
	xGR_MAXR_T_EO_Hi1(In:= IN_HC.tT_EO.Ai, Gw:= Para.rT_EO_LimHi1, Hy:= Para.rT_EO_HyHi1);
	xTON_T_EO_Hi1(IN:= xGR_MAXR_T_EO_Hi1.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
	bT_EO_Hi1 := xTON_T_EO_Hi1.Q;	

	(* engine oil temperature high 2 *)
	xGR_MAXR_T_EO_Hi2(In:= IN_HC.tT_EO.Ai, Gw:= Para.rT_EO_LimHi2, Hy:= Para.rT_EO_HyHi2);
	xTON_T_EO_Hi2(IN:= xGR_MAXR_T_EO_Hi2.Q AND IN_HC.tPB2MM.bParaSetupOk, PT:= T#2s);
	bT_EO_Hi2 := xTON_T_EO_Hi2.Q;

END_PROGRAM
