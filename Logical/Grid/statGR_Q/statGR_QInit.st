(*******************************************************************************
AGGR: static GridCode - voltage control (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- alle Funktionen welche im Rahmen des statischen GridCodes auf die Blindleistung/cos phi einwirken

Customized modifications: -
------------------------
 
History:
-------
V3.40.0	14-02-2013	Perktold,  	generated
V4.00.0 22-08-2013  Maxhera,	implementation of the module for modular software
V4.03.0	15-12-2015	Perktold, 	Skalierung für xLCScREAL_QU_Cust geändert
V4.05.0 07-12-2017  Farre,      Filter settings for Q setpoint PT1 filter

Instructions for use:
--------------------
- 

Outstandings:
------------
-

*******************************************************************************)
PROGRAM _INIT


	xLCScREAL_PF_AO.x1 := 1050; xLCScREAL_PF_AO.y1 := -0.5;
	xLCScREAL_PF_AO.x2 := 800; xLCScREAL_PF_AO.y2 := 2;
	
//(*!!! Q = f(U) Skalierung  *)	
//	xLCScREAL_QU_Cust.x1:= 6552; 	
//	xLCScREAL_QU_Cust.y1:= 0.95;
//	xLCScREAL_QU_Cust.x2:= 32760;
//	xLCScREAL_QU_Cust.y2:= 1.05;
//	
	xLCRPT1_Qset.enable := TRUE;
	xLCRPT1_Qset.t		:= 1;
	xLCRPT1_Qset.y_set	:= 0;
	xLCRPT1_Qset.set	:= TRUE;
	xLCRPT1_Qset.x		:= 0;
	xLCRPT1_Qset();
	xLCRPT1_Qset.set	:= FALSE;
	
END_PROGRAM

