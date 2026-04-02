(*******************************************************************************
T_CD		temperature condensor circuit

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V4.03.0	27.07.2015	Plattner	task created

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)


PROGRAM _CYCLIC
	(*-----------------------------------------------------------------------------*)
	(* condensor circuit supply temperature *)
	(* high *)
	xGRMAX_T_CD_Su_Hi(Gw:= Para.rT_CD_Su_LimHi, Hy:= Para.rT_CD_Su_HyHi, In:= IN_HC.tT_CD_Su.Ai);
	xTON_T_CD_Su_Hi(IN:= xGRMAX_T_CD_Su_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk AND Para.bT_CD_Su_Active, PT:= T#2s);
	bT_CD_Su_Hi := xTON_T_CD_Su_Hi.Q;	 


	(*-----------------------------------------------------------------------------*)
	(* condensor circuit temperature *)
	(* high *)
	xGRMAX_T_CD_Re_Hi(In:= IN_HC.tT_CD_Re.Ai, Gw:= Para.rT_CD_Re_LimHi, Hy:= Para.rT_CD_Re_HyHi);
	xTON_T_CD_Re_Hi(IN := xGRMAX_T_CD_Re_Hi.Q AND IN_HC.tPB2MM.bParaSetupOk AND Para.bT_CD_Re_Active, PT := T#2s);
	bT_CD_Re_Hi := xTON_T_CD_Re_Hi.Q;	
		
	(*-----------------------------------------------------------------------------*)

	
END_PROGRAM
