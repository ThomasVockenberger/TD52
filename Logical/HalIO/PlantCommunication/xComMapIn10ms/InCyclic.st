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
	END_IF
	
	(*************************************)
	(* Merge data from fast input arrays *)
	(*************************************)
	
	(*** Input from Engines  ***)
	FOR x:=iEngNumMin TO iEngNumMax DO
		memcpy(ADR(tPlantCom_E2E_In_Bus[x].digitalSignals[iDigArrayMax100ms+1]), ADR(tPlantCom_E2E_In_10ms[x].digitalSignals[0]), (iDigArrayMax10ms+1) * SIZEOF(tPlantCom_E2E_In_10ms[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_E2E_In_Bus[x].analogSignals[iAnaArrayMax100ms+1]), ADR(tPlantCom_E2E_In_10ms[x].analogSignals[0]), (iAnaArrayMax10ms+1) * SIZEOF(tPlantCom_E2E_In_10ms[x].analogSignals[0]));
	END_FOR;
	
	
	(*** Input from Masters  ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		memcpy(ADR(tPlantCom_M2E_In_Bus[x].digitalSignals[iDigArrayMax100ms+1]), ADR(tPlantCom_M2E_In_10ms[x].digitalSignals[0]), (iDigArrayMax10ms+1) * SIZEOF(tPlantCom_M2E_In_10ms[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_M2E_In_Bus[x].analogSignals[iAnaArrayMax100ms+1]), ADR(tPlantCom_M2E_In_10ms[x].analogSignals[0]), (iAnaArrayMax10ms+1) * SIZEOF(tPlantCom_M2E_In_10ms[x].analogSignals[0]));
	END_FOR;
	
	(***************************)
	(* Copy Data to Plc Arrays *)
	(***************************)
	
	(*** Fast Inputs from Engines  ***)
	FOR x:=iEngNumMin TO iEngNumMax DO
		memcpy(ADR(tPlantCom_E2E_In_Plc[x].digitalSignals[iDigArrayMax100ms+1]), ADR(tPlantCom_E2E_In_Bus[x].digitalSignals[iDigArrayMax100ms+1]), (iDigArrayMax10ms+1) * SIZEOF(tPlantCom_E2E_In_Plc[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_E2E_In_Plc[x].analogSignals[iAnaArrayMax100ms+1]), ADR(tPlantCom_E2E_In_Bus[x].analogSignals[iAnaArrayMax100ms+1]), (iAnaArrayMax10ms+1) * SIZEOF(tPlantCom_E2E_In_Plc[x].analogSignals[0]));
	END_FOR
	
	
	(*** Fast Inputs from Masters  ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		memcpy(ADR(tPlantCom_M2E_In_Plc[x].digitalSignals[iDigArrayMax100ms+1]), ADR(tPlantCom_M2E_In_Bus[x].digitalSignals[iDigArrayMax100ms+1]), (iDigArrayMax10ms+1) * SIZEOF(tPlantCom_M2E_In_Bus[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_M2E_In_Plc[x].analogSignals[iAnaArrayMax100ms+1]), ADR(tPlantCom_M2E_In_Bus[x].analogSignals[iAnaArrayMax100ms+1]), (iAnaArrayMax10ms+1) * SIZEOF(tPlantCom_M2E_In_Bus[x].analogSignals[0]));
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
			(* Fast Digital Signals *)
			FOR idx:=iDigArrayMax100ms+1 TO iDigArrayMaxAll DO
				IF (tPlantCom_E2E_In_Hmi[x].bDigForceActive[idx]) THEN
					tPlantCom_E2E_In_Plc[x].digitalSignals[idx].Value := tPlantCom_E2E_In_Hmi[x].bForceValue[idx];
					tPlantCom_E2E_In_Plc[x].digitalSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
			(* Fast Analog Signals *)
			FOR idx:=iAnaArrayMax100ms+1 TO iAnaArrayMaxAll DO
				IF (tPlantCom_E2E_In_Hmi[x].bAnaForceActive[idx]) THEN
					tPlantCom_E2E_In_Plc[x].analogSignals[idx].Value := tPlantCom_E2E_In_Hmi[x].rForceValue[idx];
					tPlantCom_E2E_In_Plc[x].analogSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
		END_IF
	END_FOR
	
	FOR x:=iMasNumMin TO iMasNumMax DO
		IF (tPlantCom_M2E_In_Hmi[x].iNum_ForcedValues > 0) THEN
			(* Fast Digital Signals *)
			FOR idx:=iDigArrayMax100ms+1 TO iDigArrayMaxAll DO
				IF (tPlantCom_M2E_In_Hmi[x].bDigForceActive[idx]) THEN
					tPlantCom_M2E_In_Plc[x].digitalSignals[idx].Value := tPlantCom_M2E_In_Hmi[x].bForceValue[idx];
					tPlantCom_M2E_In_Plc[x].digitalSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
			(* Fast Analog Signals *)
			FOR idx:=iAnaArrayMax100ms+1 TO iAnaArrayMaxAll DO
				IF (tPlantCom_M2E_In_Hmi[x].bAnaForceActive[idx]) THEN
					tPlantCom_M2E_In_Plc[x].analogSignals[idx].Value := tPlantCom_M2E_In_Hmi[x].rForceValue[idx];
					tPlantCom_M2E_In_Plc[x].analogSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
		END_IF
	END_FOR
END_PROGRAM
