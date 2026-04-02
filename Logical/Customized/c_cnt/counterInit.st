(*******************************************************************************
AGGR: counter.st - connection and processing of counters (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- set actual software version of engine controller

Customized modifications: -
------------------------
 
History:
-------
V0.1	05-03-2002	Weitzer, generated from zaehler.c / V0.1
...
V3.20	03-11-2010	Weitzer, change to version 3.20
	
Instructions for use:
--------------------

!! Task MOVED TO op_state!!
  
Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT
	(*Predefinition of new added maintenance counters 5-8*)
	IF 	VIS2MM.iMaintenanceCount5 = 0 AND
		VIS2MM.iMaintenanceCount6 = 0 AND
		VIS2MM.iMaintenanceCount7 = 0 AND
		VIS2MM.iMaintenanceCount8 = 0 
	THEN
		VIS2MM.iMaintenanceCount5 := 500000;
		VIS2MM.iMaintenanceCount6 := 600000;
		VIS2MM.iMaintenanceCount7 := 700000;
		VIS2MM.iMaintenanceCount8 := 800000;						
	END_IF

		
	(* set actual software version of engine controller *)
//	prog_vers := 390;	(*Set displayed PLC version number here*)  (* ?ALT? *)
	
	
	(* global tags for other task *)
//	ucCodeComplete;  	(* wer hat das angelegt? wofür? *)
//	bLogOK;				(* wer hat das angelegt? wofür? *)
//	usVisTempID;		(* wer hat das angelegt? wofür? *)
//	ulTempID;			(* wer hat das angelegt? wofür? *)

END_PROGRAM
