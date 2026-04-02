(*******************************************************************************
OilTank: plant auxiliaries oil tank handling for Fresh Oil Tank + Day Tank + Waste Oil Tank

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V4.12.0	15-09-2022 Zengerer   new, based on TKE spec 2022-123 and AD72 pilot 	

Instructions for use:
--------------------
...

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT	

(* ---- volume table FRESH OIL TANK --> tank configuration type = 5 ---- *)
	
	(*volume table oil tank Hamer LS300+*)
	rFreshOil_VolTable_Height[0]	:= 0;
	rFreshOil_VolTable_Height[1]	:= 120;
	rFreshOil_VolTable_Height[2]	:= 240;
	rFreshOil_VolTable_Height[3]	:= 360;
	rFreshOil_VolTable_Height[4]	:= 480;
	rFreshOil_VolTable_Height[5]	:= 600;
	rFreshOil_VolTable_Height[6]	:= 720;
	rFreshOil_VolTable_Height[7]	:= 840;
	rFreshOil_VolTable_Height[8]	:= 960;
	rFreshOil_VolTable_Height[9] 	:= 1080;
	rFreshOil_VolTable_Height[10]	:= 1120;

	rFreshOil_VolTable_Volume[0]	:= 0;
	rFreshOil_VolTable_Volume[1]	:= 13.9;
	rFreshOil_VolTable_Volume[2]	:= 36.3;
	rFreshOil_VolTable_Volume[3]	:= 69.3;
	rFreshOil_VolTable_Volume[4]	:= 112;
	rFreshOil_VolTable_Volume[5]	:= 154;
	rFreshOil_VolTable_Volume[6]	:= 195;
	rFreshOil_VolTable_Volume[7]	:= 236;
	rFreshOil_VolTable_Volume[8]	:= 279;
	rFreshOil_VolTable_Volume[9]	:= 322;
	rFreshOil_VolTable_Volume[10]	:= 334;
	
	
	(* Reference values for the characteristic curve *)
	FOR i := 0 TO MIN(iFreshOil_VolTable_Array,iVolTableArray_MAX) DO
		xFreshOilTank.tVolumeTable[i].x := rFreshOil_VolTable_Height[i];
		xFreshOilTank.tVolumeTable[i].y := rFreshOil_VolTable_Volume[i];
	END_FOR
		
	(* Parameters for characteristic curve *)
	xFreshOilTank.iTablePoints := iFreshOil_VolTable_NrOfPoints;

	
(* ---- volume table WASTE OIL TANK --> tank configuration type = 5 ----- *)

	rWasteOil_VolTable_Height[0]	:= 0;
	rWasteOil_VolTable_Height[1]	:= 120;
	rWasteOil_VolTable_Height[2]	:= 240;
	rWasteOil_VolTable_Height[3]	:= 360;
	rWasteOil_VolTable_Height[4]	:= 480;
	rWasteOil_VolTable_Height[5]	:= 600;
	rWasteOil_VolTable_Height[6]	:= 720;
	rWasteOil_VolTable_Height[7]	:= 840;
	rWasteOil_VolTable_Height[8]	:= 960;
	rWasteOil_VolTable_Height[9] 	:= 1080;
	rWasteOil_VolTable_Height[10]	:= 1120;

	rWasteOil_VolTable_Volume[0]	:= 0;
	rWasteOil_VolTable_Volume[1]	:= 13.9;
	rWasteOil_VolTable_Volume[2]	:= 36.3;
	rWasteOil_VolTable_Volume[3]	:= 69.3;
	rWasteOil_VolTable_Volume[4]	:= 112;
	rWasteOil_VolTable_Volume[5]	:= 154;
	rWasteOil_VolTable_Volume[6]	:= 195;
	rWasteOil_VolTable_Volume[7]	:= 236;
	rWasteOil_VolTable_Volume[8]	:= 279;
	rWasteOil_VolTable_Volume[9]	:= 322;
	rWasteOil_VolTable_Volume[10]	:= 334;
	
	
	(* Reference values for the characteristic curve *)
	FOR i := 0 TO MIN(iWasteOil_VolTable_Array,iVolTableArray_MAX) DO
		xWasteOilTank.tVolumeTable[i].x := rWasteOil_VolTable_Height[i];
		xWasteOilTank.tVolumeTable[i].y := rWasteOil_VolTable_Volume[i];
	END_FOR
		
	(* Parameters for characteristic curve *)
	xWasteOilTank.iTablePoints := iWasteOil_VolTable_NrOfPoints;


(* ---- volume table Day OIL TANK --> tank configuration type = 5 ---- *)

	rDayOil_VolTable_Height[0]	:= 0;
	rDayOil_VolTable_Height[1]	:= 120;
	rDayOil_VolTable_Height[2]	:= 240;
	rDayOil_VolTable_Height[3]	:= 360;
	rDayOil_VolTable_Height[4]	:= 480;
	rDayOil_VolTable_Height[5]	:= 600;
	rDayOil_VolTable_Height[6]	:= 720;
	rDayOil_VolTable_Height[7]	:= 840;
	rDayOil_VolTable_Height[8]	:= 960;
	rDayOil_VolTable_Height[9] 	:= 1080;
	rDayOil_VolTable_Height[10]	:= 1120;

	rDayOil_VolTable_Volume[0]	:= 0;
	rDayOil_VolTable_Volume[1]	:= 13.9;
	rDayOil_VolTable_Volume[2]	:= 36.3;
	rDayOil_VolTable_Volume[3]	:= 69.3;
	rDayOil_VolTable_Volume[4]	:= 112;
	rDayOil_VolTable_Volume[5]	:= 154;
	rDayOil_VolTable_Volume[6]	:= 195;
	rDayOil_VolTable_Volume[7]	:= 236;
	rDayOil_VolTable_Volume[8]	:= 279;
	rDayOil_VolTable_Volume[9]	:= 322;
	rDayOil_VolTable_Volume[10]	:= 334;
	
	
	(* Reference values for the characteristic curve *)
	FOR i := 0 TO MIN(iDayOil_VolTable_Array,iVolTableArray_MAX) DO
		xDayOilTank.tVolumeTable[i].x := rDayOil_VolTable_Height[i];
		xDayOilTank.tVolumeTable[i].y := rDayOil_VolTable_Volume[i];
	END_FOR
		
	(* Parameters for characteristic curve *)
	xDayOilTank.iTablePoints := iDayOil_VolTable_NrOfPoints;
	
	
	
	
	
END_PROGRAM