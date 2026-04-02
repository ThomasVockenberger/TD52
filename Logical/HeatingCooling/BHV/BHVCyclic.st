(*******************************************************************************
BHV	Boiler house ventilation

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.03.0	25.07.2015	Plattner Johannes
V4.11.0	17.01.2022	lettenb.	bFail_BHV: tBHV_Dem.Do added to avoid warning at standstill, bugfix	

Instructions FOR use:
--------------------

Boiler house ventilation, activation AND demand

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	
	(* boiler house ventilation aktive*)
	(*----------------------------------------------------------------------------*)
	IF Para.bBHV_Active THEN
		
		OUT_HC.tBHV_Dem.Do	:= (IN_HC.tDemnd_BHV.Di AND NOT IN_HC.tManAuxCtr.bBHV_Dem_Man)
							   OR IN_HC.tManAuxCtr.bBHV_Dem;	(* Manual operating auxiliaries control - Handbedienebene *)
		bFail_BHV		:= NOT IN_HC.tBHV_Op.Di AND OUT_HC.tBHV_Dem.Do;
		(*----------------------------------------------------------------------------*)
		
		(* boiler house ventilation inaktive*)
		(*----------------------------------------------------------------------------*)
	ELSE
		
		OUT_HC.tBHV_Dem.Do	:= FALSE;
		bFail_BHV			:= FALSE;
		
	END_IF;
	(*----------------------------------------------------------------------------*)
	

END_PROGRAM