(*******************************************************************************
GeneralGM		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	23.01.2013 	Tinello 	Created initial structured text code
V04.05.00.00	22.01.2018	Tinello		Release Module added

(*******************************************************************************)

PROGRAM _CYCLIC

	(* Release Module if ParaSetupOk = TRUE *)
	xTON_ParaSetupOk(IN		:= IN_GM.tPB2MM.bParaSetupOk, PT:= T#20s);
	bRelModul_ParaSetupOk	:= xTON_ParaSetupOk.Q;


	(* Operation mode selector switch *)
	bOMSS_MAT := (IN_GM.iIdx_OMSS = 1) OR (IN_GM.iIdx_OMSS = 2) OR (IN_GM.iIdx_OMSS = 3); (* 1= manual; 2= auto; 3= test mode *)	

	
	(* call function for the state machine - engine operation mode *)
	xOpMode(in 	:= IN_GM.iSt_OpMode);	
	
END_PROGRAM
