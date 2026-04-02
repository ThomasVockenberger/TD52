(*******************************************************************************
T_Ch 		temperature charge air/mixture 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.99.0	21.02.2013	lettenb.	new for MM_HC 
V4.07.0	09.08.2018	Schmid		2nd low temperature charge cooling circuit added
		
Instructions for use:
--------------------	

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(* charge temperature t2' *)
	(* high 1 *)
	xGRMAX_T_Ch_Hi1(In:= IN_HC.rT_Ch_T2s_Avg, Gw:= Para.rT_Ch_LimHi1, Hy:= Para.rT_Ch_HyHi1);
	bT_Ch_Hi1 := xGRMAX_T_Ch_Hi1.Q AND IN_HC.tPB2MM.bParaSetupOk;

	(* high 2 *)
	xGRMAX_T_Ch_Hi2(In:= IN_HC.rT_Ch_T2s_Avg, Gw:= Para.rT_Ch_LimHi2, Hy:= Para.rT_Ch_HyHi2);
	bT_Ch_Hi2 := xGRMAX_T_Ch_Hi2.Q AND IN_HC.tPB2MM.bParaSetupOk;


	(* charge temperature before high-pressure turbo charger T1-HP - 2nd LT cooling circuit*)
	(* high 1 *)
	xGRMAX_T_Ch_T1HP_Hi1(In:= IN_HC.rT_Ch_T1HP_Avg, Gw:= Para.rT_Ch_T1HP_LimHi1, Hy:= Para.rT_Ch_T1HP_HyHi1);
	bT_Ch2_Hi1 := xGRMAX_T_Ch_T1HP_Hi1.Q AND IN_HC.tPB2MM.bParaSetupOk;

	(* high 2 *)
	xGRMAX_T_Ch_T1HP_Hi2(In:= IN_HC.rT_Ch_T1HP_Avg, Gw:= Para.rT_Ch_T1HP_LimHi2, Hy:= Para.rT_Ch_T1HP_HyHi2);
	bT_Ch2_Hi2 := xGRMAX_T_Ch_T1HP_Hi2.Q AND IN_HC.tPB2MM.bParaSetupOk;
    
END_PROGRAM
