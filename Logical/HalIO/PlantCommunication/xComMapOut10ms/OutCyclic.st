(*******************************************************************************
Mapping from Plc Arrays to Bus Arrays with force logic

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

	(***************************)
	(* Copy Data to Bus Arrays *)
	(***************************)
	
	(*** Output to Engines  ***)
	memcpy(ADR(tPlantCom_E2E_Out_Bus.digitalSignals[iDigArrayMax100ms+1]), ADR(tPlantCom_E2E_Out_Plc.digitalSignals[iDigArrayMax100ms+1]), (iDigArrayMax10ms+1) * SIZEOF(tPlantCom_E2E_Out_Bus.digitalSignals[0]));
	memcpy(ADR(tPlantCom_E2E_Out_Bus.analogSignals[iAnaArrayMax100ms+1]), ADR(tPlantCom_E2E_Out_Plc.analogSignals[iAnaArrayMax100ms+1]), (iAnaArrayMax10ms+1) * SIZEOF(tPlantCom_E2E_Out_Bus.analogSignals[0]));

	
	(*** Outputs to Masters  ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		memcpy(ADR(tPlantCom_E2M_Out_Bus[x].digitalSignals[iDigArrayMax100ms+1]), ADR(tPlantCom_E2M_Out_Plc[x].digitalSignals[iDigArrayMax100ms+1]), (iDigArrayMax10ms+1) * SIZEOF(tPlantCom_E2M_Out_Bus[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_E2M_Out_Bus[x].analogSignals[iAnaArrayMax100ms+1]), ADR(tPlantCom_E2M_Out_Plc[x].analogSignals[iAnaArrayMax100ms+1]), (iAnaArrayMax10ms+1) * SIZEOF(tPlantCom_E2M_Out_Bus[x].analogSignals[0]));
	END_FOR
	
	(************************************************)
	(* Overwrite forced outputs with value from HMI *)
	(************************************************)
	
	IF (MM2VIS.tPlantComm.iFrc_Gbl > 0) THEN
		IF (tPlantCom_E2E_Out_Hmi.iNum_ForcedValues > 0) THEN
			(* Digital Signals *)
			FOR idx:=iDigArrayMax100ms+1 TO iDigArrayMaxAll DO
				IF (tPlantCom_E2E_Out_Hmi.bDigForceActive[idx]) THEN
					tPlantCom_E2E_Out_Bus.digitalSignals[idx].Value := tPlantCom_E2E_Out_Hmi.bForceValue[idx];
					tPlantCom_E2E_Out_Bus.digitalSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
			(* Analog Signals *)
			FOR idx:=iAnaArrayMax100ms+1 TO iAnaArrayMaxAll DO
				IF (tPlantCom_E2E_Out_Hmi.bAnaForceActive[idx]) THEN
					tPlantCom_E2E_Out_Bus.analogSignals[idx].Value := tPlantCom_E2E_Out_Hmi.rForceValue[idx];
					tPlantCom_E2E_Out_Bus.analogSignals[idx].GoodQual := TRUE;
				END_IF
			END_FOR
		END_IF
	
		FOR x:=iMasNumMin TO iMasNumMax DO
			IF (tPlantCom_E2M_Out_Hmi[x].iNum_ForcedValues > 0) THEN
				(* Digital Signals *)
				FOR idx:=iDigArrayMax100ms+1 TO iDigArrayMaxAll DO
					IF (tPlantCom_E2M_Out_Hmi[x].bDigForceActive[idx]) THEN
						tPlantCom_E2M_Out_Bus[x].digitalSignals[idx].Value := tPlantCom_E2M_Out_Hmi[x].bForceValue[idx];
						tPlantCom_E2M_Out_Bus[x].digitalSignals[idx].GoodQual := TRUE;
					END_IF
				END_FOR
				(* Analog Signals *)
				FOR idx:=iAnaArrayMax100ms TO iAnaArrayMaxAll DO
					IF (tPlantCom_E2M_Out_Hmi[x].bAnaForceActive[idx]) THEN
						tPlantCom_E2M_Out_Bus[x].analogSignals[idx].Value := tPlantCom_E2M_Out_Hmi[x].rForceValue[idx];
						tPlantCom_E2M_Out_Bus[x].analogSignals[idx].GoodQual := TRUE;
					END_IF
				END_FOR
			END_IF
		END_FOR
	END_IF	
	
	(***************************************)
	(* Split data to 10ms and 100ms arrays *)
	(***************************************)
	
	(*** Output to Engines  ***)
	memcpy(ADR(tPlantCom_E2E_Out_10ms.digitalSignals), ADR(tPlantCom_E2E_Out_Bus.digitalSignals[iDigArrayMax100ms+1]), (iDigArrayMax10ms+1) * SIZEOF(tPlantCom_E2E_Out_10ms.digitalSignals[0]));
	memcpy(ADR(tPlantCom_E2E_Out_10ms.analogSignals), ADR(tPlantCom_E2E_Out_Bus.analogSignals[iAnaArrayMax100ms+1]), (iAnaArrayMax10ms+1) * SIZEOF(tPlantCom_E2E_Out_10ms.analogSignals[0]));
	
	(*** Output to Masters  ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		memcpy(ADR(tPlantCom_E2M_Out_10ms[x].digitalSignals), ADR(tPlantCom_E2M_Out_Bus[x].digitalSignals[iDigArrayMax100ms+1]), (iDigArrayMax10ms+1) * SIZEOF(tPlantCom_E2M_Out_10ms[x].digitalSignals[0]));
		memcpy(ADR(tPlantCom_E2M_Out_10ms[x].analogSignals), ADR(tPlantCom_E2M_Out_Bus[x].analogSignals[iAnaArrayMax100ms+1]), (iAnaArrayMax10ms+1) * SIZEOF(tPlantCom_E2M_Out_10ms[x].analogSignals[0]));
	END_FOR;
	
END_PROGRAM
