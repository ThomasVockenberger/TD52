(*******************************************************************************
T_AirOutdoor		temperature air outdoor 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V2.10	18.05.2004	LH			erstellt
V3.99.0	21.02.2013	lettenb.	ult --> T_AirOutdoor renamed
		
Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(* outdoor air temperature *)
	
	(* high 1 *)	
	xGRMAX_T_AirOutdoor_Hi1(In:= IN_HC.tT_AirOutdoor.Ai, Gw:= Para.rT_AirOutdoor_LimHi1, Hy:= Para.rT_AirOutdoor_HyHi1);
	bT_AirOutdoor_Hi1 := IN_HC.tPB2MM.bParaSetupOk AND xGRMAX_T_AirOutdoor_Hi1.Q AND Para.bT_AirOutdoor_Active;
	
	(* high 2 *)	
	xGRMAX_T_AirOutdoor_Hi2(In:= IN_HC.tT_AirOutdoor.Ai, Gw:= Para.rT_AirOutdoor_LimHi2, Hy:= Para.rT_AirOutdoor_HyHi2);
	bT_AirOutdoor_Hi2 := IN_HC.tPB2MM.bParaSetupOk AND xGRMAX_T_AirOutdoor_Hi2.Q AND Para.bT_AirOutdoor_Active;   
	
	(* high 3 *)
	xGRMAX_T_AirOutdoor_Hi3(In:= IN_HC.tT_AirOutdoor.Ai, Gw:= Para.rT_AirOutdoor_LimHi3, Hy:= Para.rT_AirOutdoor_HyHi3);
	bT_AirOutdoor_Hi3 := IN_HC.tPB2MM.bParaSetupOk AND xGRMAX_T_AirOutdoor_Hi3.Q AND Para.bT_AirOutdoor_Active;

	(* high 4 *)
	xGRMAX_T_AirOutdoor_Hi4(In:= IN_HC.tT_AirOutdoor.Ai, Gw:= Para.rT_AirOutdoor_LimHi4, Hy:= Para.rT_AirOutdoor_HyHi4);
	bT_AirOutdoor_Hi4 := IN_HC.tPB2MM.bParaSetupOk AND xGRMAX_T_AirOutdoor_Hi4.Q AND Para.bT_AirOutdoor_Active;	



END_PROGRAM
