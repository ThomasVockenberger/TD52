(*******************************************************************************
OilFill: plant auxiliaries oil filling and automatic refill handling for Fresh Oil Tank + Day Tank + Waste Oil Tank

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2024

Customized modifications: -
------------------------
 
History:
-------
V4.14.0	02-12-2024 Zengerer   new, based on reduced spec for V4.14	

Instructions for use:
--------------------
...

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT	

	(* ---- ToDO:  FRESH OIL ... configuration type ---- *)
	ParaFactoryDefault.iOilRefill_Type := 3 ;			(* 3=Customized implementation with interface to CU module *)	
	ParaFactoryDefault.tiFreshOilPump_Delay	:= T#5s;	(* Delay between valve opening and pump activation, to avoid pressure peaks in hydraulic system *)	

	
	bNoInitDetected := FALSE; 	 (* Insert this into every tasks INIT code to activate download detection *)
END_PROGRAM