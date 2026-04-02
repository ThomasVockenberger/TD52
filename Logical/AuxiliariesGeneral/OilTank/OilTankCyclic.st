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
		08-11-2022 Zengerer   changed to tanktypes 2-5, with additional type 1, according to spec. 	
		15-11-2022 Lang		  changes from testing, implementation improvements 
		06-03-2023 Lang		  Finding after pilotphase, Scaling issue with different sensor-types 

Instructions for use:
--------------------
...

Outstandings:
------------

*******************************************************************************)

		
PROGRAM _CYCLIC	

	(*----------------------------------------------------------------------------------------*)
	(*Configuration tank types*)
	(*Type 1: direct volume measurement in [L]  *)
	(*Type 2: oil tank cylinder horizontal*)
	(*Type 3: oil tank cylinder vertical*)
	(*Type 4: oil tank cubicle or rectangle*)
	(*Type 5: oil tank with Volume table*)
	(*----------------------------------------------------------------------------------------*)
		
	IF NOT Para.bOilTankMonitoring THEN 
		MM2VIS.rL_FreshOilTank		:= 0;
		MM2VIS.rL_WasteOilTank		:= 0;
		MM2VIS.rL_DayOilTank		:= 0;
		MM2VIS.rV_FreshOilTank		:= 0;
		MM2VIS.rV_WasteOilTank		:= 0;
		MM2VIS.rV_DayOilTank		:= 0;
		MM2VIS.rV_FreshOilTank_Rel	:= 0;
		MM2VIS.rV_WasteOilTank_Rel	:= 0;
		MM2VIS.rV_DayOilTank_Rel	:= 0;
		RETURN ; 
	END_IF

	
	(*------------------------ FRESH OIL TANK --------------------------------------------------*)
	
	IF 	Para.rFreshOilTank_Type > 1 THEN 																			// Sensor represents level height in millimeter 
		rFresh_OilTank_level 			:= MAX(0,Para.rFreshOilTank_SensorPos - IN_AG.tL_FreshOilTank.Ai) / 1000; 	// mm --> m
	ELSE																											// Sensor represents content in Liters
		rFresh_OilTank_level 			:= IN_AG.tL_FreshOilTank.Ai;  										
	END_IF
				
		xFreshOilTank.Height 			:= Para.rFreshOilTank_Height / 1000;		// mm --> m
		xFreshOilTank.Length			:= Para.rFreshOilTank_Length / 1000;		// mm --> m
		xFreshOilTank.Sensor_level		:= rFresh_OilTank_level;					// m oder Liter
		xFreshOilTank.WidthOrDiameter 	:= Para.rFreshOilTank_Witdh / 1000;			// mm --> m
		xFreshOilTank.Type				:= REAL_TO_INT(Para.rFreshOilTank_Type);
		xFreshOilTank.rV_MAX			:= Para.rFreshOilTank_VolumeTotal ;	
		xFreshOilTank();
		
		MM2VIS.rL_FreshOilTank			:= 	xFreshOilTank.Level_Act_height * 1000;  // m --> mm
		MM2VIS.rV_FreshOilTank			:=  xFreshOilTank.Volume_Act_Liter;			// calc./measured FLUID VOLUME in tank
		MM2VIS.rV_FreshOilTank_Max 		:=	xFreshOilTank.Volume_Total_Liter;		// maximum Tank capacity		
	
	IF 	MM2VIS.rV_FreshOilTank_Max > 0 THEN
			MM2VIS.rV_FreshOilTank_Rel 	:=	MM2VIS.rV_FreshOilTank / MM2VIS.rV_FreshOilTank_Max ; 
	ELSE
			MM2VIS.rV_FreshOilTank_Rel 	:= 0.000001;
	END_IF			


	(*------------------------ WASTE OIL TANK --------------------------------------------------*)

	IF 	Para.rWasteOilTank_Type > 1 THEN 																			// Sensor represents level height in millimeter 
		rWaste_OilTank_level 			:= MAX(0,Para.rWasteOilTank_SensorPos - IN_AG.tL_WasteOilTank.Ai) / 1000; 	// mm --> m
	ELSE																											// Sensor represents content in Liters
		rWaste_OilTank_level 			:= IN_AG.tL_WasteOilTank.Ai;  										
	END_IF
	
		xWasteOilTank.Height 			:= Para.rWasteOilTank_Height / 1000;		// mm --> m
		xWasteOilTank.Length			:= Para.rWasteOilTank_Length / 1000;		// mm --> m
		xWasteOilTank.Sensor_level		:= rWaste_OilTank_level;					// m oder Liter
		xWasteOilTank.WidthOrDiameter 	:= Para.rWasteOilTank_Witdh / 1000;			// mm --> m
		xWasteOilTank.Type				:= REAL_TO_INT(Para.rWasteOilTank_Type);
		xWasteOilTank.rV_MAX			:= Para.rWasteOilTank_VolumeTotal ;	
		xWasteOilTank();
	
		MM2VIS.rL_WasteOilTank			:= 	xWasteOilTank.Level_Act_height * 1000;  // m --> mm
		MM2VIS.rV_WasteOilTank			:=  xWasteOilTank.Volume_Act_Liter;			// calc./measured FLUID VOLUME in tank
		MM2VIS.rV_WasteOilTank_Max 		:=	xWasteOilTank.Volume_Total_Liter;		// maximum Tank capacity		

	IF 	MM2VIS.rV_WasteOilTank_Max > 0 THEN
			MM2VIS.rV_WasteOilTank_Rel	:=	MM2VIS.rV_WasteOilTank / MM2VIS.rV_WasteOilTank_Max ; 
	ELSE
			MM2VIS.rV_WasteOilTank_Rel 	:= 0.000001;
	END_IF	
	
	
	(*------------------------ DAY OIL TANK --------------------------------------------------*)

	IF 	Para.rDayOilTank_Type > 1 THEN 																				// Sensor represents level height in millimeter 
		rDay_OilTank_level	 			:= MAX(0,Para.rDayOilTank_SensorPos - IN_AG.tL_DayOilTank.Ai) / 1000; 		// mm --> m
	ELSE																											// Sensor represents content in Liters
		rDay_OilTank_level 				:= IN_AG.tL_DayOilTank.Ai;  										
	END_IF
	
		xDayOilTank.Height 				:= Para.rDayOilTank_Height / 1000;			// mm --> m
		xDayOilTank.Length				:= Para.rDayOilTank_Length / 1000;			// mm --> m
		xDayOilTank.Sensor_level		:= rDay_OilTank_level;						// m oder Liter
		xDayOilTank.WidthOrDiameter 	:= Para.rDayOilTank_Witdh / 1000;			// mm --> m
		xDayOilTank.Type				:= REAL_TO_INT(Para.rDayOilTank_Type);
		xDayOilTank.rV_MAX				:= Para.rDayOilTank_VolumeTotal ;	
		xDayOilTank();
		
		MM2VIS.rL_DayOilTank			:= 	xDayOilTank.Level_Act_height * 1000;  	// m --> mm
		MM2VIS.rV_DayOilTank			:=  xDayOilTank.Volume_Act_Liter;			// calc./measured FLUID VOLUME in tank
		MM2VIS.rV_DayOilTank_Max 		:=	xDayOilTank.Volume_Total_Liter;			// maximum Tank capacity		
	
	IF 	MM2VIS.rV_DayOilTank_Max > 0 THEN
			MM2VIS.rV_DayOilTank_Rel 	:=	MM2VIS.rV_DayOilTank / MM2VIS.rV_DayOilTank_Max ; 
	ELSE
			MM2VIS.rV_DayOilTank_Rel 	:= 0.000001;
	END_IF			
	
END_PROGRAM