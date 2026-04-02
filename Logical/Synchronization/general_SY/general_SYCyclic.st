(*******************************************************************************
general		general functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V3.90.0	17.10.2012	lettenb.	new
V3.99.0	07.03.2013	lettenb.	INIT: iEngNr added
		24.04.2013				changeover SyOMSS through status OFF added	
V4.00.0	26.02.2014				OUT_SY.iIdx_SyOMSS FOR opstate added
V4.05.0 11.12.2017	lettenb.	check para setup added
		21.01.2018	Perktold,	hardware operation mode switch added
V4.07.1	23.07.2019	Denk,		Init: error handling for CfgGetIPAddr_ArWin.status added
V4.09.0	30.01.2020  lettenb.	bResetWarning added for gcbTC1
V4.10.0	25.02.2021	lettenb.	VIS2MM.iModule added(read IP-adr. not available for B&R IPC, removed), bugfix
V4.12.0	04.07.2022	lettenb.	OUT_SY.tSyOMSS_Man/Aut.Do added, dead bus synch
																															
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* check para setup *)
	IN_SY.tPB2MM.bParaSetupOk;
	Para.iEng_Motortype;    (* MIN= 208   MAX= 920    *)
	Para.rN_EngStart_LimHi; (* MIN= 50.0  MAX= 2200.0 *)

	
	(* engine type defnition *)
	xEngType.Motortype := INT_TO_UINT(Para.iEng_Motortype);
	xEngType();				(* use: xEngType.Type2 as BOOL, ....*)


	(* engine operating mode selection *)
	bOMSS_Stop := FALSE;
	bOMSS_Man  := FALSE;
	bOMSS_Aut  := FALSE;
	bOMSS_Test := FALSE;
	bOMSS_Scav := FALSE;
	bOMSS_MAT  := FALSE;
	
	CASE IN_SY.iIdx_OMSS OF
	0:	bOMSS_Stop := TRUE;
	1:	bOMSS_Man  := TRUE;
		bOMSS_MAT  := TRUE;
	2:	bOMSS_Aut  := TRUE;
		bOMSS_MAT  := TRUE;
	3:	bOMSS_Test := TRUE;
		bOMSS_MAT  := TRUE;
	4:	bOMSS_Scav := TRUE;	
	END_CASE;

	(* synchronization operating mode selection *)
	IF IN_SY.tHW_Switches.bGoodQual THEN
	(* HARDWARE OPERATION MODE SWITCHES *)
		OUT_SY.iIdx_SyOMSS	:= IN_SY.tHW_Switches.iIdx_SyOMS_Hw;

		xTON_SyOMSS_Man(IN:= OUT_SY.iIdx_SyOMSS = 1, PT:= T#200ms);
		xTON_SyOMSS_Aut(IN:= OUT_SY.iIdx_SyOMSS = 2, PT:= T#200ms);
	
		VIS2MM.iIdx_SyOMSS	:= INT_TO_DINT(OUT_SY.iIdx_SyOMSS);
	ELSE
	(* OPERATION MODE SWITCHES ON HMI *)
		OUT_SY.iIdx_SyOMSS := DINT_TO_INT(VIS2MM.iIdx_SyOMSS);
		
		xTON_SyOMSS_Man(IN:= VIS2MM.iIdx_SyOMSS = 1, PT:= T#200ms);
		xTON_SyOMSS_Aut(IN:= VIS2MM.iIdx_SyOMSS = 2, PT:= T#200ms);
	END_IF;

	bSyOMSS_Man :=     xTON_SyOMSS_Man.Q;
	bSyOMSS_Aut :=     xTON_SyOMSS_Aut.Q;
	bSyOMSS_Off := NOT bSyOMSS_Man AND NOT bSyOMSS_Aut;

	OUT_SY.tSyOMSS_Man.Do := bSyOMSS_Man;
	OUT_SY.tSyOMSS_Aut.Do := bSyOMSS_Aut;

	(* engine operating mode *)
	xOpMode(in:= IN_SY.iSt_OpMode);
	

	(* plc running *)
	IN_SY.tPB2MM.bSys_Run;


	(* reset *)
	bResetWarning := IN_SY.tAB2SY.bResetWarning;

	(*------------------------------------------------------------------------------------*)	
	(* engine start speed limit *)		
	xGR_MAXR_N_EngStart(In:= IN_SY.rN_EngAct, Gw:= Para.rN_EngStart_LimHi, Hy:= Para.rN_EngStart_HyHi);
	xTOF_N_EngStart(IN:= xGR_MAXR_N_EngStart.Q AND IN_SY.tPB2MM.bParaSetupOk, PT:= T#10s);
	bN_EngStart := xTOF_N_EngStart.Q;
	(*------------------------------------------------------------------------------------*)	

	(* module number *)
	iEngNr := VIS2MM.iModule;
	OUT_SY.iModule := INT_TO_USINT(iEngNr);
END_PROGRAM
