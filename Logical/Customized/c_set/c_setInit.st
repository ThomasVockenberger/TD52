(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Programm: c_set
 * Datei: c_setInit.st
 * Autor: ZengereS
 * Erstellt: 2. April 2013
 ********************************************************************
 * Implementierung des Programms c_set
 ********************************************************************)

PROGRAM _INIT

	
	 IN_CU.tP_Set_ExtAI_Norm.Ai :=	1.0;
//	 IN_CU.tN_Set_ExtAI_Norm.Ai :=	1.0;

	(*----------------------------------------------------------------------------------*)
	(* Prototype usage and predifinition of all outputs: *)
	OUT_CU.bP_Set_ExtDI_Enable := 	FALSE ; (* *)  	(*OldName: AW_EXPSH_DI; Cycle: 5;*)
	//OUT_CU.rP_Set_ExtDI_Norm :=		1.0;	(* *) 	(*OldName: Dig_P_SOLL; Cycle: 5;*)  (*REMOVE SETPOINTS HERE, AS SOON AS THEIR FUNCTIONALITY IS PROVIDED BY GRID CODE LOGIC*)

	OUT_CU.bP_Set_ExtAI_Enable := 	FALSE ; (* *) 	(*OldName: AW_EXPSH_AI; Cycle: 5;*)
	OUT_CU.rP_Set_ExtAI_Norm := 	1.0;	(* *) 	(*OldName: ssNominalPowerAnalog		; Cycle: 5;*)
	OUT_CU.bN_Set_ExtAI_Enable := 	FALSE ; (* *) 	(*OldName: AW_EXDSH; Cycle: 5;*)
	OUT_CU.rN_Set_ExtAI_Norm := 	1.0;	(* *) 	(*OldName: Dig_N_SOLL; Cycle: 5;*)	
	
	(*OLD Varnames, Do not use anymore - soon o be deleted:*)
	sel_PowerSetpointLimit ; 	(*(Varname Old for compatibility)*)
	bPowerSetpointLimit ; 		(*(Varname Old for compatibility)*)
	ssPowerSetpointLimit ; 		(*(Varname Old for compatibility)*)

	IF Para.rN_EngNom = 0 THEN Para.rN_EngNom := 1500.1;	END_IF		(*Fallback for missing parameter AdditionalPLCTag*)

END_PROGRAM
