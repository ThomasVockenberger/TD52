(*******************************************************************************
AGGR: check CAN communication (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019 

- get memory adresses of local counter pv´s
- error phase detection

Customized modifications: -
------------------------
 
History:
-------
V4.05.00	27.07.2017	Messner		generated FOR modular software	
					 								 
							 
Instructions for use:
--------------------
- 
							
Outstandings:
------------
-
*******************************************************************************)

PROGRAM _INIT
	
	(* error phase detection *)
	ucCanErrLevFastHi := 3;
	ucCanErrLevFastLo := 1;
	
	ucCanErrLevSlowHi := 5;
	ucCanErrLevSlowLo := 2;
	
END_PROGRAM
