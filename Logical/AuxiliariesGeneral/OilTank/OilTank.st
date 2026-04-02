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
V4.12.0	15-11-2022 Lang   	new, based on TKE spec 2022-123 and AD72 pilot 	
		17-11-2022 Zengerer	integration 

Instructions for use:
--------------------
...

Outstandings:
------------

*******************************************************************************)

FUNCTION_BLOCK OilTank_Obj
(* ----------------------------------------------------------------------------------------
	INPUT
		Type : 					Tank Configuration
		Length : 				[m]
		WidthOrDiameter : 		[m]
		Height :  				[m]
		Sensor_level :			[m]
		tVolumeTable : 			ARRAY [mm] <<>> [Liter]
		iTablePoints : 			Number of curve points
		rV_MAX :  				[Liter]
		
	OUTPUT
		Volume_Total_Liter :  	[Liter]
		Level_Act_height :  	[m]
		Volume_Act_Liter : 		[Liter]
		Volume_Act_pu : 		[pu]
		
	VAR
		Radius : [m]
		xTable : LCRCurveByPoints;

	
	Calculation of oiltank volume dependent on Tank configuration:
	
		Type 1 is direct volume measurement in [L]  
		Type 2 is oil tank cylinder horizontal
		Type 3 is oil tank cylinder vertical
		Type 4 is oil tank cubicle or rectangle
		Type 5 is oil tank with Volume table
---------------------------------------------------------------------------------------- *)		

	Radius := WidthOrDiameter / 2;
	
(* Type 1 measurement direct in Liters *)	
	IF Type = 1 THEN			
		
		Volume_Act_Liter 	:= MIN(Sensor_level,rV_MAX);
		Volume_Total_Liter	:= rV_MAX;
		
(* Type 2 is oil tank cylinder horizontal *)		
	ELSIF Type = 2 THEN 		
		
		Volume_Total_Liter	:= (brmPI * (Radius * Radius) * Length) * 1000;
		Level_Act_height	:= MIN(Sensor_level, WidthOrDiameter);		(*limit Oil tank level to tank diameter*)
		IF Radius > 0.0 THEN 
			Volume_Act_Liter	:= Length * (((Radius * Radius)* ACOS((Radius - Level_Act_height) / Radius))-((Radius - Level_Act_height) * (SQRT(2.0 * (Radius * Level_Act_height) - (Level_Act_height * Level_Act_height))))) * 1000;
		ELSE
			Volume_Act_Liter	:= 0;
		END_IF
		
(* Type 3 is oil tank cylinder vertical *)			
	ELSIF Type = 3 THEN 
		
		Level_Act_height	:= MIN(Sensor_level, Length);		(*limit Oil tank level to tank length*)	
		Volume_Total_Liter 	:= (brmPI * (Radius * Radius) * Length) * 1000;
		Volume_Act_Liter 	:= (brmPI * (Radius * Radius) * Level_Act_height) * 1000;

		
(* Type 4 is oil tank cubicle or rectangle *)			
	ELSIF Type = 4 THEN	
		
		Level_Act_height	:= MIN(Sensor_level, Height);		(*limit Oil tank level to tank height*)	
		Volume_Total_Liter := (Length * WidthOrDiameter * Height) * 1000;
		Volume_Act_Liter := (Length * WidthOrDiameter * Level_Act_height) * 1000;

(* Type 5 is oil tank special shape - volume table *)		
	ELSIF Type = 5 THEN		
		
		Level_Act_height	:= MIN(Sensor_level, tVolumeTable[iTablePoints - 1].x / 1000);		(*limit Oil tank level to tank height - out of volume table*)
			
		xTable.NoOfPoints  	:= iTablePoints;
		xTable.ptr_table   	:= ADR(tVolumeTable);
		xTable.x			:= LIMIT(tVolumeTable[0].x, Sensor_level * 1000, tVolumeTable[iTablePoints - 1].x); // m --> mm  Volume table shows level-height in mm vs. Liter
		xTable();
		Volume_Total_Liter	:= tVolumeTable[iTablePoints - 1].y;
		Volume_Act_Liter	:= xTable.y;
				
	END_IF;	
		
		Volume_Act_pu 		:= Volume_Act_Liter / MAX(Volume_Total_Liter,0.000001);

END_FUNCTION_BLOCK
