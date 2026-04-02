(*******************************************************************************
AGGR: 	gas train 1 with 4 lines

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company. 
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V3.30.0	10.11.2011		glantschnig	new Implementation
V03.90.00.00	20.02.2013	Denk	V3.30 changes inserted in modular software
V04.01.00.00	15.07.2014	Denk	bugfix M_STGAS1
							   
Instructions for use:
--------------------

Outstandings:
------------
- 
*******************************************************************************)
PROGRAM _CYCLIC

	Para.iNum_GT1_Lines;							//Anzahl Gaslinien auswählen

	Para.iNum_GT1_Lines := LIMIT(1,Para.iNum_GT1_Lines,4);
	
	IF Para.iNum_GT1_Lines = 1 THEN					//Bei einer Gaslinien, 2-4 deaktivieren
		AKT_Gastrecke1_2 := FALSE;					
		AKT_Gastrecke1_3 := FALSE;
		AKT_Gastrecke1_4 := FALSE;
	ELSIF Para.iNum_GT1_Lines = 2 THEN				//Bei zwei Gaslinien, 3-4 deaktivieren
		AKT_Gastrecke1_2 := TRUE;
		AKT_Gastrecke1_3 := FALSE;
		AKT_Gastrecke1_4 := FALSE;
	ELSIF Para.iNum_GT1_Lines = 3 THEN				//Bei drei Gaslinien, 4 deaktivieren
		AKT_Gastrecke1_2 := TRUE;
		AKT_Gastrecke1_3 := TRUE;
		AKT_Gastrecke1_4 := FALSE;
	ELSIF Para.iNum_GT1_Lines = 4 THEN				//Bei vier Gaslinien, 2-4 aktivieren
		AKT_Gastrecke1_2 := TRUE;
		AKT_Gastrecke1_3 := TRUE;
		AKT_Gastrecke1_4 := TRUE;
	END_IF
	
	IF Para.iNum_GT1_Lines < 2 THEN   				(* Para.iNum_GT1_Lines  < 2 is NOT active (default)	*)
		RETURN; 									(* Para.iNum_GT1_Lines  > 1     active      			*)
	END_IF;
	
	(* Common OUT for Gastrain 1 safety device OK *)
	bGT1_SafeDevOK :=	(IN_GT.tGT1_1_SafeDevOK.Di 								//Release from Gastrain 1 lines 1 - 4
					AND (IN_GT.tGT1_2_SafeDevOK.Di OR NOT AKT_Gastrecke1_2) 
					AND (IN_GT.tGT1_3_SafeDevOK.Di OR NOT AKT_Gastrecke1_3) 
					AND (IN_GT.tGT1_4_SafeDevOK.Di OR NOT AKT_Gastrecke1_4));	
	
	OUT_GT.tGT1_1_SafeDevice.Do := OUT_GT.tGT1_SafeDevice.Do;							//Anforderung Gasdichtekontrollgerät Gasstrecke 1 - Linie 1
	OUT_GT.tGT1_2_SafeDevice.Do := OUT_GT.tGT1_SafeDevice.Do AND AKT_Gastrecke1_2;		//Anforderung Gasdichtekontrollgerät Gasstrecke 1 - Linie 2
	OUT_GT.tGT1_3_SafeDevice.Do := OUT_GT.tGT1_SafeDevice.Do AND AKT_Gastrecke1_3;		//Anforderung Gasdichtekontrollgerät Gasstrecke 1 - Linie 3
	OUT_GT.tGT1_4_SafeDevice.Do := OUT_GT.tGT1_SafeDevice.Do AND AKT_Gastrecke1_4;		//Anforderung Gasdichtekontrollgerät Gasstrecke 1 - Linie 4

END_PROGRAM
