(*******************************************************************************
Pr_EG_TC1	Fast exhaust gas pressure sensor operations

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V4.05.0	29.11.2017	Messner		new created
		04.12.2017	Messner		OXicat inlet pressure fast sensor operation added
V4.07.0	14.01.2019	Schmid		exhaust gas pressure fast (deflagration detection) fully replaces OXIcat inlet pressure fast sensor
								TASK RENAMED: New name: Pr_EG_TC1 - Fast exhaust gas pressure sensor operations
										 (Old name: CAT - Oxidation Catalyst sensor operations)
								-> functionality identical, parameters + MM2VIS vars reused, local vars renamed and new IO label
		18.03.2019	lettenb.	IN_EX.bEng_Start -> IN_EX.bEng_Start_TC1, tPr_EG_Deflag_Fast -> tPr_EG_Deflag_Fast_TC1, mapping + taskclass corr.
V4.14.0	16.10.2024	VighM		Deflagration set cleanup and warning update, minimum peak detection added
																															
Instructions FOR use:
--------------------
- Used for fast sensor operations (Cyclic #1 - at least 5ms)

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(*===========================================================================*)	
	(* Exhaust gas pressure fast operation (deflagration detection) *)
	(*===========================================================================*)	
	
	(* Rising Edge on exhaust gas pressure maximum *)
	xR_TRIG_Pr_EG_Deflag_Fast(CLK:= Para.bPr_OXIcat_In_Fast_Exist		(*Parameter from "OXIcat inlet pressure fast" reused*) 
								AND IN_EX.tPr_EG_Deflag_Fast_TC1.GoodQual AND NOT MM2VIS.bMsg9249	(*Good signal quality and no signal warning*)
								AND IN_EX.tPr_EG_Deflag_Fast_TC1.Ai >= Para.rPr_EG_Deflag_Fast_HiHi	(*Exceeding pressure limit*)
								AND ((IN_EX.rN_EngAct_TC1 > 0) OR IN_EX.bEng_Start_TC1)				(*Engine demand or engine moving*)
								AND NOT bPr_EG_Deflag_Fast);										(*Deflagration detected based on first pressure limit exceeding*)
	
	(* set exhaust gas pressure fast maximum trigger *)
	IF 	xR_TRIG_Pr_EG_Deflag_Fast.Q	THEN
		
		(* set Msg trigger *)
		bPr_EG_Deflag_Fast := TRUE;
		
	END_IF;
	
	
	(*---------------------------------------------------------------------------*)
	(* Exhaust gas pressure fast peak detection *)
	xTOF_Pr_EG_Deflag_Fast(IN := xR_TRIG_Pr_EG_Deflag_Fast.Q, PT := T#200ms);
	
	(* continous maximum peak detection *)
	IF 		xTOF_Pr_EG_Deflag_Fast.Q 
		AND IN_EX.tPr_EG_Deflag_Fast_TC1.Ai > MM2VIS.rPr_OXIcat_In_Fast_Peak THEN
		
		(* set new peak pressure value *)
		MM2VIS.rPr_OXIcat_In_Fast_Peak := IN_EX.tPr_EG_Deflag_Fast_TC1.Ai;	(*MM2VIS variable from "OXIcat inlet pressure fast" reused*)
	END_IF;
	
	(*continous minimum detection*)
	IF 		xTOF_Pr_EG_Deflag_Fast.Q 
		AND IN_EX.tPr_EG_Deflag_Fast_TC1.Ai < MM2VIS.rPr_OXIcat_In_Fast_Minimum THEN
		
		(* set new peak pressure value *)
		MM2VIS.rPr_OXIcat_In_Fast_Minimum := IN_EX.tPr_EG_Deflag_Fast_TC1.Ai;
	END_IF;
	
	
	(*---------------------------------------------------------------------------*)
	(* reset exhaust gas pressure fast maximum trigger variables - continuous set is prevented in alarm set condition*)
	IF bPr_EG_Deflag_Fast AND EDGENEG(MM2VIS.bMsg2340) THEN
		bPr_EG_Deflag_Fast := FALSE;
	END_IF;

	(* delayed reset of exhaust gas pressure fast maximum MM2VIS variables *)
	(* to ensure registration of peak values on myPlant *)
	xTOF_Pr_EG_Deflag_Fast_VisReset(IN:= EDGENEG(xTOF_Pr_EG_Deflag_Fast.Q), PT:= T#1m);
	IF EDGENEG(xTOF_Pr_EG_Deflag_Fast_VisReset.Q) THEN
		MM2VIS.rPr_OXIcat_In_Fast_Peak	:= 0;		(*MM2VIS variable from "OXIcat inlet pressure fast" reused*)
		MM2VIS.rPr_OXIcat_In_Fast_Minimum	:= Para.rPr_OXIcat_In_Fast_ScalMax;	(*Update minimum monitoring value to deflagration pressure limit*)
	ELSIF NOT (xTOF_Pr_EG_Deflag_Fast.Q) AND NOT (xTOF_Pr_EG_Deflag_Fast_VisReset.Q) THEN
		MM2VIS.rPr_OXIcat_In_Fast_Minimum	:= Para.rPr_OXIcat_In_Fast_ScalMax;	(*Update minimum monitoring value to deflagration pressure limit*)
	END_IF;

END_PROGRAM
