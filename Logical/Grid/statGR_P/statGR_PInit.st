(*******************************************************************************
AGGR: static GridCode - frequency control (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- alle Funktionen welche im Rahmen des statischen GridCodes auf die Wirkleistung einwirken

Customized modifications: -
------------------------
 
History:
-------
V3.40.0	14-02-2013	Perktold,  generated
V4.0.0  22-08-2013  Maxhera,   implementation of the module for modular software
V4.03.0	15-03-2016	Perktold,  update FOR 4.3.0.0
V4.07.0 25-03-2019      Zuschnig,  initialization FNom und FAct

Instructions for use:
--------------------
- 

Outstandings:
------------
-

*******************************************************************************)
PROGRAM _INIT
	VIS2MM.rFNom_FSM_ManualTest := 50;
	VIS2MM.rFAct_FSM_ManualTest := 50;	
END_PROGRAM

