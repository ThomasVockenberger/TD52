(*******************************************************************************
CUSTOMIZED: c_scal 		reserve scaling blocks (init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V4.00	29.09.2021	Heim Markus generated, new
V4.11.0	07.12.2021	Zengerer	integrate initial version, ParaFactoryDefault

		
Instructions for use:
--------------------
-
Outstandings:
------------
-

*******************************************************************************)

PROGRAM _INIT

	(*initial Type = 0*)
	FOR n := 1 TO 30 BY 1 DO
		xScalBlock[n].Type := 0;
		
		ParaFactoryDefault.rCust_ScalingBlock_X2[n] := 1.0;		(* default before first parameter load *)
		ParaFactoryDefault.rCust_ScalingBlock_Y2[n] := 1.0; 	(* default before first parameter load *)
	END_FOR

END_PROGRAM

