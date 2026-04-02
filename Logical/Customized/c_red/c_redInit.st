(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Programm: c_red
 * Datei: c_redInit.st
 * Autor: ZengereS
 * Erstellt: 24.Juni 2015
 ********************************************************************)

PROGRAM _INIT

	OUT_CU.rP_Red_EVU_Norm := 	1.0;	(*	ssExtPwrSetP4 ? *)
	
	OUT_CU.rP_Red_AI_Norm := 	1.0; 	(* power reduction by analog input *) (*OldName: ssPowerRedAnalog *)
	


	(* This factory default definition is only a backuü fallback solution. *)
	(* Set parameter values for normal operation in parameter file! *)
	ParaFactoryDefault.rP_Red_EVU_Stage1 := 		0.1;	(* [1/ P nom] *)
	ParaFactoryDefault.rP_Red_EVU_Stage2 := 		0.2;	(* [1/ P nom] *)
	ParaFactoryDefault.rP_Red_EVU_Stage3 := 		0.3;	(* [1/ P nom] *)
	ParaFactoryDefault.rP_Red_EVU_Stage4 := 		0.4;	(* [1/ P nom] *)
	ParaFactoryDefault.rP_Red_EVU_Stage5 := 		0.5;	(* [1/ P nom] *)	


END_PROGRAM
