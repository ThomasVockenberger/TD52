(*******************************************************************************
Mapping from Bus Arrays to Plc Arrays with force logic

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2024

Customized modifications: -
------------------------
 
History:
-------
V4.14.0	26.11.2024	Astner	Created Task

						
Instructions for use: -
--------------------

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC
	(* Exit if configuration fails or not active *)
	IF (NOT MM2VIS.tPlantComm.bCfg_OK OR NOT Para.tPlantComm.bActive) THEN
		RETURN;
	END_IF;
	(****************************************)
	(* Merge data from slow bus input array *)
	(****************************************)
	
	(*** Input from Engines  ***)
	FOR x:=iEngNumMin TO iEngNumMax DO
		memcpy(ADR(tPlantCom_E2E_In_Bus[x].digitalSignals[0]), ADR(tPlantCom_E2E_In_100ms[x].digitalSignals[0]), (iDigArrayMax100ms+1) * SIZEOF(tPlantCom_E2E_In_100ms[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_E2E_In_Bus[x].analogSignals[0]), ADR(tPlantCom_E2E_In_100ms[x].analogSignals[0]), (iAnaArrayMax100ms+1) * SIZEOF(tPlantCom_E2E_In_100ms[x].analogSignals[0]));
	END_FOR
	
	
	(*** Input from Masters  ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		memcpy(ADR(tPlantCom_M2E_In_Bus[x].digitalSignals[0]), ADR(tPlantCom_M2E_In_100ms[x].digitalSignals[0]), (iDigArrayMax100ms+1) * SIZEOF(tPlantCom_M2E_In_100ms[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_M2E_In_Bus[x].analogSignals[0]), ADR(tPlantCom_M2E_In_100ms[x].analogSignals[0]), (iAnaArrayMax100ms+1) * SIZEOF(tPlantCom_M2E_In_100ms[x].analogSignals[0]));
	END_FOR
	
	(***************************)
	(* Copy Data to Plc Arrays *)
	(***************************)
	
	(*** Input from Engines  ***)
	FOR x:=iEngNumMin TO iEngNumMax DO
		memcpy(ADR(tPlantCom_E2E_In_Plc[x].digitalSignals[0]), ADR(tPlantCom_E2E_In_Bus[x].digitalSignals[0]), (iDigArrayMax100ms+1) * SIZEOF(tPlantCom_E2E_In_Plc[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_E2E_In_Plc[x].analogSignals[0]), ADR(tPlantCom_E2E_In_Bus[x].analogSignals[0]), (iAnaArrayMax100ms+1) * SIZEOF(tPlantCom_E2E_In_Plc[x].analogSignals[0]));
	END_FOR
	
	
	(*** Input from Masters  ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		memcpy(ADR(tPlantCom_M2E_In_Plc[x].digitalSignals[0]), ADR(tPlantCom_M2E_In_Bus[x].digitalSignals[0]), (iDigArrayMax100ms+1) * SIZEOF(tPlantCom_M2E_In_Plc[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_M2E_In_Plc[x].analogSignals[0]), ADR(tPlantCom_M2E_In_Bus[x].analogSignals[0]), (iAnaArrayMax100ms+1) * SIZEOF(tPlantCom_M2E_In_Plc[x].analogSignals[0]));
	END_FOR;
	
	(* Skip overwriting with forced values if no signal is forced *)
	IF (MM2VIS.tPlantComm.iFrc_Gbl = 0) THEN
		RETURN;
	END_IF
	
	(***********************************************)
	(* Overwrite forced inputs with value from HMI *)
	(***********************************************)
	FOR x:=iEngNumMin TO iEngNumMax DO
		IF (tPlantCom_E2E_In_Hmi[x].iNum_ForcedValues > 0) THEN
			(* Digital Signals *)
			FOR idx:=0 TO iDigArrayMax100ms DO
				IF (tPlantCom_E2E_In_Hmi[x].bDigForceActive[idx]) THEN
					tPlantCom_E2E_In_Plc[x].digitalSignals[idx].Value := tPlantCom_E2E_In_Hmi[x].bForceValue[idx];
					tPlantCom_E2E_In_Plc[x].digitalSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
			(* Analog Signals *)
			FOR idx:=0 TO iAnaArrayMax100ms DO
				IF (tPlantCom_E2E_In_Hmi[x].bAnaForceActive[idx]) THEN
					tPlantCom_E2E_In_Plc[x].analogSignals[idx].Value := tPlantCom_E2E_In_Hmi[x].rForceValue[idx];
					tPlantCom_E2E_In_Plc[x].analogSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
		END_IF
	END_FOR
	
	FOR x:=iMasNumMin TO iMasNumMax DO
		IF (tPlantCom_M2E_In_Hmi[x].iNum_ForcedValues > 0) THEN
			(* Digital Signals *)
			FOR idx:=0 TO iDigArrayMax100ms DO
				IF (tPlantCom_M2E_In_Hmi[x].bDigForceActive[idx]) THEN
					tPlantCom_M2E_In_Plc[x].digitalSignals[idx].Value := tPlantCom_M2E_In_Hmi[x].bForceValue[idx];
					tPlantCom_M2E_In_Plc[x].digitalSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
			(* Analog Signals *)
			FOR idx:=0 TO iAnaArrayMax100ms DO
				IF (tPlantCom_M2E_In_Hmi[x].bAnaForceActive[idx]) THEN
					tPlantCom_M2E_In_Plc[x].analogSignals[idx].Value := tPlantCom_M2E_In_Hmi[x].rForceValue[idx];
					tPlantCom_M2E_In_Plc[x].analogSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
		END_IF
	END_FOR
END_PROGRAM
