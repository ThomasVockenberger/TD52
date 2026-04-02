(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: c_modIF
 * File: c_modIFInit.st
 * Author: ZengereS
 * Created: May 30, 2015
 ********************************************************************
 * Implementation of program c_modIF
 ********************************************************************)

PROGRAM _INIT
	IN_CU_ThisPlant.ReplaceMeWithYourVariableName;	(*Placeholder for possible new dataitems for plant specific customisations *)

	MM2VIS_ThisPlant.ReplaceMeWithYourVariableName;	(*Placeholder for possible new dataitems for plant specific customisations *)
	VIS2MM_ThisPlant.ReplaceMeWithYourVariableName;	(*Placeholder for possible new dataitems for plant specific customisations *)

	Para_ThisPlant.ReplaceMeWithYourVariableName;	(*Placeholder for possible new dataitems for plant specific customisations *)

	OUT_CU_ThisPlant.ReplaceMeWithYourVariableName;	(*Placeholder for possible new dataitems for plant specific customisations *)

	(*set default values for the Modul Gastrain customisation here in this OUT Interface for hardcoded settings *) 
	OUT_CU.tCU2GT.tiGT_TestDuration 		:= T#120s ;		(* optional prepared customizable interface  - Prepared for BETA PHASE, use only in coordination with TPSS	:= T#1m= old behavior *)
	OUT_CU.tCU2GT.tiGCPulse_Duration_min 	:= T#100ms; ; 	(* optional prepared customizable interface  - BETA PHASE, use only in coordination with TPSS	:= T#1s= old behavior, in case of new troubles *)
	OUT_CU.tCU2GT.tiGV_Feedback_Delay_max 	:= T#60s ;		(* optional prepared customizable interface  - BETA PHASE, use only in coordination with TPSS	:= T#1m= old behavior, in case of new troubles *)
	OUT_CU.tCU2GT.iGC_Select_Option 		:= 0;			(* optional prepared customizable interface  - BETA PHASE, use only in coordination with TPSS	bit7 == 128 = back to old gascounter behavior, in case of new troubles *)
	OUT_CU.tCU2GT.tIF_Revision.xx :=4; OUT_CU.tCU2GT.tIF_Revision.yy :=07;  (*for information*)


	(* Release syncronising command customized *)
	OUT_CU.bRelSy_Customized := TRUE;

	OUT_CU.rT_AirER_Customized := -3270;			(*show signal error value as common, if no customer signal is provided in this plant specific code*)

END_PROGRAM

