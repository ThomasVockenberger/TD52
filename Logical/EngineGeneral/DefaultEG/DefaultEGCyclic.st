(*******************************************************************************
DefaultEG		value set

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	18.03.2013	Tinello		new
V04.02.00		28.07.2015 	Plattner 	new
V4.14.0 		11.04.2025	Tinello		SAFETY related:	tSafetyLoop_EmStop added to get rid of problems during simulation

																																		
Instructions for use:
--------------------
- Default TRUE setting for not existing Di's

Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	IN_EG.tSafetyLoop_EmStop.Di 	:= IN_EG.tSafetyLoop_EmStop.Di 		OR NOT IN_EG.tSafetyLoop_EmStop.GoodQual; 	(* SAFETY PLC *)
	IN_EG.tSafetyLoop_Eng.Di 		:= IN_EG.tSafetyLoop_Eng.Di 		OR NOT IN_EG.tSafetyLoop_Eng.GoodQual;	(* old: RUHE *)		
	IN_EG.tEmStop_CoolRun.Di 		:= IN_EG.tEmStop_CoolRun.Di  		OR NOT IN_EG.tEmStop_CoolRun.GoodQual;	(* emergency stop with cool down run *)		
	
END_PROGRAM
