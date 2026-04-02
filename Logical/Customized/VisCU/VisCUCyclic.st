(*******************************************************************************
vis			visualization

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.90.0	04.06.2013	Zengerer	new
V4.03.0	09.11.2015	Zengerer	Add Init file
V4.04.0	20.06.2016  Weitzer		add at MM2VIS & VIS2MM types rCustVis[33..50], bCustVis[33..50]

Instructions FOR use:
--------------------
Placeholders as reminder for VIS-tags from other tasks;
Add aditional function here as needed customized

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* VIS2MM *)
	(*Counter inputs for user edit*)
	VIS2MM.iCount1;
	VIS2MM.iCount20;
	VIS2MM.iMaintenanceCount1;	
	VIS2MM.iMaintenanceCount8;		
	
	(*---------------------------------------------------------------------------*)
	(* MM2VIS *)
	(* Counters: *)
	MM2VIS.iCount1;
	MM2VIS.iCount2;
	MM2VIS.iCount3;
	MM2VIS.iCount4;
	MM2VIS.iCount5;
	MM2VIS.iCount6;
	MM2VIS.iCount7;
	MM2VIS.iCount8;
	MM2VIS.iCount9;
	MM2VIS.iCount10;
	MM2VIS.iCount11;
	MM2VIS.iCount12;
	MM2VIS.iCount13;
	MM2VIS.iCount14;
	MM2VIS.iCount15;
	MM2VIS.iCount16;
	MM2VIS.iCount17;
	MM2VIS.iCount18;
	MM2VIS.iCount19;
	MM2VIS.iCount20;
	
	MM2VIS.iMaintenanceCount1;
	MM2VIS.iMaintenanceCount2;
	MM2VIS.iMaintenanceCount3;
	MM2VIS.iMaintenanceCount4;
	MM2VIS.iMaintenanceCount5;
	MM2VIS.iMaintenanceCount6;
	MM2VIS.iMaintenanceCount7;
	MM2VIS.iMaintenanceCount8;

	(*Reserve alarms and warnings*)
	MM2VIS.bCustAlarm_Tripped[1];
	MM2VIS.bCustAlarm_Tripped[16];
	MM2VIS.bCustWarn_Tripped[1];
	MM2VIS.bCustWarn_Tripped[16];
	
	(*Reserve analog input channels*)
	MM2VIS.rCustAnaIn[1];
	MM2VIS.rCustAnaIn[2];
	MM2VIS.rCustAnaIn[3];
	MM2VIS.rCustAnaIn[4];
	MM2VIS.rCustAnaIn[5];
	MM2VIS.rCustAnaIn[6];
	MM2VIS.rCustAnaIn[7];
	MM2VIS.rCustAnaIn[8];
	MM2VIS.rCustAnaIn[9];
	MM2VIS.rCustAnaIn[10];
	MM2VIS.rCustAnaIn[11];
	MM2VIS.rCustAnaIn[12];
	MM2VIS.rCustAnaIn[13];
	MM2VIS.rCustAnaIn[14];
	MM2VIS.rCustAnaIn[15];
	MM2VIS.rCustAnaIn[16];
	MM2VIS.rCustAnaIn[32];
	
	(*CustomerIO channels*)
	MM2VIS.bUniDig[1];
	MM2VIS.rUniAna[1];


	(*-----------------------------------------------------------------------------*)
	(* 50 spare analog variables from PLC --> VISU *)
	MM2VIS.rCustVis[1];
	MM2VIS.rCustVis[2];
	MM2VIS.rCustVis[3];
	(*.....*)

	(* 50 spare digital variables from PLC --> VISU *)
	MM2VIS.bCustVis[1];
	MM2VIS.bCustVis[2];
	MM2VIS.bCustVis[3];
	(*.....*)
	
	(* 50 spare analog variables from VISU --> PLC *)
	VIS2MM.rCustVis[1];
	VIS2MM.rCustVis[2];
	VIS2MM.rCustVis[3];
	(*.....*)
	
	(* 50 spare digital variables from VISU --> PLC *)
	VIS2MM.bCustVis[1];
	VIS2MM.bCustVis[2];
	VIS2MM.bCustVis[3];	
	(*.....*)


	(* Display process step info and remaining step time information at VIS   (Prototype) *)
	xOpMode(in:= IN_CU.iSt_OpMode);				(*get local representation of operating state*)


	IN_CU.iProcessStepTime;		(* 	Step Time Display	new with V4.04, 2016	*)
 	IN_CU.iIdx_ProcessStep;		(*	Step Time Display	new with V4.04, 2016 	*)

	OUT_CU.iIdx_ProcessStep_CU := IN_CU.iIdx_ProcessStep_AG; 	(*	 	Optional step information to display on VIS from module AG	 	*)
	OUT_CU.iProcessStepTime_CU := IN_CU.iProcessStepTime_AG; 	(*	 	Optional step time  info to display on VIS from module AG	 	 *)

	
	IF IN_CU.iIdx_ProcessStep > 0 THEN 	
		OUT_CU.iIdx_ProcessStep_CU := IN_CU.iIdx_ProcessStep;
		OUT_CU.iProcessStepTime_CU := IN_CU.iProcessStepTime; 
	END_IF	// ELSE 	OUT_CU.iIdx_ProcessStep := IN_CU.iSt_OpMode;  END_IF

	(*-> See also MM Opstate: Para.iProcessStepInfo_Type[35];				=Parameter Array to control Step Info Visibility and Style 0=invisible; 1= allways visible; (+future options possible, e.g. user level?) *)
	

	//Task part was MOVED TO MM Opstate:	
//	IF IN_CU.iProcessStepTime > 0 THEN
//		MM2VIS.iProcessStepTime := IN_CU.iProcessStepTime;
//	ELSE
//		IF MM2VIS.iIdx_ProcessStep = iIdx_ProcessStep_Last AND			(* detect state change*)
//		   NOT IN_CU.tImp_OpHour.Do	THEN					   			(* detect new operating hour *)
//			MM2VIS.iProcessStepTime := MM2VIS.iProcessStepTime + BOOL_TO_DINT(bSecondTic);	(* count seconds in same state *)
//		ELSE
//			MM2VIS.iProcessStepTime := 0;
//			iIdx_ProcessStep_Last := MM2VIS.iIdx_ProcessStep;	
//		END_IF
//	END_IF
//
//	IF tRealTime.second = iRealTime_LastSecond THEN						(*to generate second tic*)
//		bSecondTic := FALSE;
//	ELSE
//		bSecondTic := TRUE;
//		iRealTime_LastSecond := tRealTime.second;
//	END_IF
//	
//
//
//	MM2VIS.iIdx_ProcessStep;		(*ToDo: add custoized modifications here *)
//	MM2VIS.iProcessStepTime;		(*ToDo: add custoized modifications here *)
//	
//	iProcessStepInfo_Last;

END_PROGRAM
