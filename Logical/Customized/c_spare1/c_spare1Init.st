(*******************************************************************************
CUSTOMIZED: c_spare1 			init to customized task placeholder

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
Instructions for use:
--------------------
USE THIS TASK TO ADD CODE SNIPPETS AFTER ENGINE DELIVERY

Outstandings:
------------

*******************************************************************************)
PROGRAM _INIT	

	bDoNothing := TRUE; 	
	(*insert your code here*)

//	(*-----------------------------------------------------------------------------*)
//	(* Some example lines FOR TASK c_ana, for intentional disabling of AI warning messages *)
//	bBlockW13[03] := FALSE;   (* TRUE will disable Reserve ANALOG IN 1 Warning Signal Error –NUMBER W1177*)
//	bBlockW13[06] := FALSE;   (* TRUE will disable Reserve ANALOG IN 2 Warning Signal Error –NUMBER W1178*)
//	bBlockW13[09] := FALSE;   (* TRUE will disable Reserve ANALOG IN 3 Warning Signal Error –NUMBER W1179*)
//	bBlockW13[12] := FALSE;   (* TRUE will disable Reserve ANALOG IN 4 Warning Signal Error –NUMBER W1180*)
//	bBlockW13[15] := FALSE;   (* TRUE will disable Reserve ANALOG IN 5 Warning Signal Error –NUMBER W1181*)
//	bBlockW13[18] := FALSE;   (* TRUE will disable Reserve ANALOG IN 6 Warning Signal Error –NUMBER W1182*)
//	bBlockW13[21] := FALSE;   (* TRUE will disable Reserve ANALOG IN 7 Warning Signal Error –NUMBER W1183*)
//	bBlockW13[24] := FALSE;   (* TRUE will disable Reserve ANALOG IN 8 Warning Signal Error –NUMBER W1184*)
//	(*---*)
//	bBlockW13[27] := FALSE;   (* TRUE will disable Reserve ANALOG IN 9 Warning Signal Error –NUMBER W1327*)
//	bBlockW13[30] := FALSE;   (* TRUE will disable Reserve ANALOG IN10 Warning Signal Error –NUMBER W1330*)
//	bBlockW13[33] := FALSE;   (* TRUE will disable Reserve ANALOG IN11 Warning Signal Error –NUMBER W1333*)
//	(*...continue as needed*)
//	(*-----------------------------------------------------------------------------*)	

	(*-----------------------------------------------------------------------------*)
	bNoInitDetected := FALSE; 	 (* Insert this into every tasks INIT code to activate download detection *)
END_PROGRAM

