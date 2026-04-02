(*******************************************************************************
Hmi Logic for the Plant Communication Diagnostics and Forcing screen

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
	
	IF (NOT Para.tPlantComm.bActive) THEN
		FOR x := 1 TO 4 DO	
			MM2VIS.tPlantComm.bMas_Ena[x] := FALSE; 
		END_FOR
		FOR x := 1 TO 32 DO	
			MM2VIS.tPlantComm.bEng_Ena[x] := FALSE; 
		END_FOR	
	END_IF;	
	
	(* Exit if configuration fails or not active *)
	IF (NOT MM2VIS.tPlantComm.bCfg_OK OR NOT Para.tPlantComm.bActive) THEN
		RETURN;
	END_IF;
	
	IF (Para.tPlantComm.iEng_Num_Min > Para.tPlantComm.iEng_Num_Max) THEN
		Para.tPlantComm.iEng_Num_Max := Para.tPlantComm.iEng_Num_Min;
	END_IF;
	IF (Para.tPlantComm.iMas_Num_Min > Para.tPlantComm.iMas_Num_Max) THEN
		Para.tPlantComm.iMas_Num_Max := Para.tPlantComm.iMas_Num_Min;
	END_IF;
	iEngNumMin := Para.tPlantComm.iEng_Num_Min;
	iEngNumMax := Para.tPlantComm.iEng_Num_Max;
	iMasNumMin := Para.tPlantComm.iMas_Num_Min;
	iMasNumMax := Para.tPlantComm.iMas_Num_Max;

	(**********************************************************)
	(*      			HMI Diagnostics					      *)
	(**********************************************************)
	
	tHmiDiag.bSelectionChange := FALSE;
			
	(*Signal Type changed in the Diagnostic screen selection *)
	IF (VIS2MM.tPlantComm.iIO_Typ <> tHmiDiag.iIO_Typ) THEN
		(* Set the IO Type: AI, DI, AO, DO *)
		tHmiDiag.iIO_Typ := VIS2MM.tPlantComm.iIO_Typ;
		
		(* Reset the direction selection on the HMI *)
		VIS2MM.tPlantComm.iIO_Typ_Dir := NO_SELECTION;
		VIS2MM.tPlantComm.iIO_Typ_Dir_Num := NO_SELECTION;
		VIS2MM.tPlantComm.iNum_Start := 0;
		tHmiDiag.iIO_Typ_Dir := NO_SELECTION;
		tHmiDiag.iIO_Typ_Dir_Num := NO_SELECTION;
		tHmiDiag.iStartIdx := NO_SELECTION;
		
		tHmiDiag.bSelectionChange := TRUE;
	END_IF;
	
	(* Signal Direction changed in the Diagnostic screen selection *)
	IF (VIS2MM.tPlantComm.iIO_Typ_Dir <> tHmiDiag.iIO_Typ_Dir) THEN
		(* Set the Signal Direction: FROM Master/Engine TO Master/Engine *)
		IF (tHmiDiag.iIO_Typ = PlantComm_AI OR tHmiDiag.iIO_Typ = PlantComm_DI) THEN // Input only allows Signals FROM Master/Engine
			IF (VIS2MM.tPlantComm.iIO_Typ_Dir = FROM_MASTER OR VIS2MM.tPlantComm.iIO_Typ_Dir = FROM_ENGINE) THEN
				tHmiDiag.iIO_Typ_Dir := VIS2MM.tPlantComm.iIO_Typ_Dir;
			ELSE
				NO_SELECTION;
				tHmiDiag.iIO_Typ_Dir := NO_SELECTION;
				VIS2MM.tPlantComm.iIO_Typ_Dir := NO_SELECTION;
			END_IF
		ELSIF (tHmiDiag.iIO_Typ = PlantComm_AO OR tHmiDiag.iIO_Typ = PlantComm_DO) THEN // Output only allows Signals TO Master/Engine
			IF (VIS2MM.tPlantComm.iIO_Typ_Dir = TO_MASTER OR VIS2MM.tPlantComm.iIO_Typ_Dir = TO_ENGINE) THEN
				tHmiDiag.iIO_Typ_Dir := VIS2MM.tPlantComm.iIO_Typ_Dir;
			ELSE
				NO_SELECTION;
				tHmiDiag.iIO_Typ_Dir := NO_SELECTION;
				VIS2MM.tPlantComm.iIO_Typ_Dir := NO_SELECTION;
			END_IF
		ELSE
			VIS2MM.tPlantComm.iIO_Typ_Dir := tHmiDiag.iIO_Typ_Dir;
		END_IF;
		(* Set the Dir_Num limits *)
		IF (VIS2MM.tPlantComm.iIO_Typ_Dir = FROM_MASTER OR VIS2MM.tPlantComm.iIO_Typ_Dir = TO_MASTER) THEN
			MM2VIS.tPlantComm.iIO_Typ_Dir_Num_Max := iMasNumMax;
			MM2VIS.tPlantComm.iIO_Typ_Dir_Num_Min := iMasNumMin;
			VIS2MM.tPlantComm.iIO_Typ_Dir_Num	  := iMasNumMin;
		ELSIF (VIS2MM.tPlantComm.iIO_Typ_Dir = FROM_ENGINE OR VIS2MM.tPlantComm.iIO_Typ_Dir = TO_ENGINE) THEN
			MM2VIS.tPlantComm.iIO_Typ_Dir_Num_Max := iEngNumMax;
			MM2VIS.tPlantComm.iIO_Typ_Dir_Num_Min := iEngNumMin;
			VIS2MM.tPlantComm.iIO_Typ_Dir_Num	  := iEngNumMin;
		END_IF
		(* Reset the Asset Selection *)
		VIS2MM.tPlantComm.iNum_Start := NO_SELECTION;
		VIS2MM.tPlantComm.bFrc_Act := FALSE;
		VIS2MM.tPlantComm.bFrc_Gbl := FALSE;
		tHmiDiag.iIO_Typ_Dir_Num := VIS2MM.tPlantComm.iIO_Typ_Dir_Num;
		tHmiDiag.iStartIdx := NO_SELECTION;
		tHmiDiag.bSelectionChange := TRUE;
	END_IF
	
	(* Dir_Num Selection changed*)
	IF (VIS2MM.tPlantComm.iIO_Typ_Dir_Num <> tHmiDiag.iIO_Typ_Dir_Num) THEN
		(* Set the asset selection *)
		IF (tHmiDiag.iIO_Typ_Dir = FROM_MASTER OR tHmiDiag.iIO_Typ_Dir = TO_MASTER) THEN 
			IF (VIS2MM.tPlantComm.iIO_Typ_Dir_Num >= iMasNumMin AND VIS2MM.tPlantComm.iIO_Typ_Dir_Num <= iMasNumMax) THEN
				tHmiDiag.iIO_Typ_Dir_Num := VIS2MM.tPlantComm.iIO_Typ_Dir_Num;	
				tHmiDiag.bSelectionChange := TRUE;
			ELSE 
				VIS2MM.tPlantComm.iIO_Typ_Dir_Num := tHmiDiag.iIO_Typ_Dir_Num;
			END_IF
		ELSIF (tHmiDiag.iIO_Typ_Dir = FROM_ENGINE OR tHmiDiag.iIO_Typ_Dir = TO_ENGINE) THEN
			IF (VIS2MM.tPlantComm.iIO_Typ_Dir_Num >= iEngNumMin AND VIS2MM.tPlantComm.iIO_Typ_Dir_Num <= iEngNumMax) THEN
				tHmiDiag.iIO_Typ_Dir_Num := VIS2MM.tPlantComm.iIO_Typ_Dir_Num;
				tHmiDiag.bSelectionChange := TRUE;
			ELSE 
				VIS2MM.tPlantComm.iIO_Typ_Dir_Num := tHmiDiag.iIO_Typ_Dir_Num;
			END_IF
		ELSE
			VIS2MM.tPlantComm.iIO_Typ_Dir_Num := tHmiDiag.iIO_Typ_Dir_Num;	
		END_IF
		VIS2MM.tPlantComm.iNum_Start := NO_SELECTION;
		tHmiDiag.iStartIdx := NO_SELECTION;
	END_IF
	(* Start Index Changed *)
	IF (VIS2MM.tPlantComm.iNum_Start <> tHmiDiag.iStartIdx) THEN	
		tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
		tHmiDiag.bSelectionChange := TRUE;
	END_IF
	
	(* Unforce all Asset *)
	IF (VIS2MM.tPlantComm.bFrc_Act) THEN
		(* Reset HMI Selection of Force Active *)
		FOR x:=0 TO tHmiDiag.iDiagTableSize-1 DO	
			VIS2MM.tPlantComm.bFrc[x] := FALSE;
		END_FOR
		(* Unforce all of the selected Asset *)
		IF (tHmiDiag.iIO_Typ_Dir = FROM_MASTER OR tHmiDiag.iIO_Typ_Dir = TO_MASTER) THEN
			IF (tHmiDiag.iIO_Typ_Dir_Num >= 1 AND tHmiDiag.iIO_Typ_Dir_Num <= 4) THEN
				(* Unforce Analog Inputs/Outputs *)
				FOR x:=0 TO tHmiDiag.iAnaSigCntE2M - 1 DO
					tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[x] := FALSE;
					tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[x] := FALSE;
				END_FOR
				(* Unforce Digital Inputs/Outputs *)
				FOR x:=0 TO tHmiDiag.iDigSigCntE2M - 1 DO
					tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[x] := FALSE;
					tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[x] := FALSE;
				END_FOR
				(* Set counter for forced signals to zero*)
				tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues 	:= 0;
				tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues  	:= 0;
			END_IF
		ELSIF (tHmiDiag.iIO_Typ_Dir = FROM_ENGINE) THEN
			IF (tHmiDiag.iIO_Typ_Dir_Num >= 1 AND tHmiDiag.iIO_Typ_Dir_Num <= 32) THEN
				(* Unforce Analog Inputs *)
				FOR x:=0 TO tHmiDiag.iAnaSigCntE2E - 1 DO
					tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[x] := FALSE;
				END_FOR
				(* Unforce Digital Inputs *)
				FOR x:=0 TO tHmiDiag.iDigSigCntE2E - 1 DO
					tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[x] := FALSE;
				END_FOR
				tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := 0;
			END_IF
		ELSIF (tHmiDiag.iIO_Typ_Dir = TO_ENGINE) THEN
			(* Unforce Analog Outputs *)
			FOR x:=0 TO tHmiDiag.iAnaSigCntE2E - 1 DO
				tPlantCom_E2E_Out_Hmi.bAnaForceActive[x] := FALSE;
			END_FOR
			(* Unforce Digital Outputs *)
			FOR x:=0 TO tHmiDiag.iDigSigCntE2E - 1 DO
				tPlantCom_E2E_Out_Hmi.bDigForceActive[x] := FALSE;
			END_FOR
			tPlantCom_E2E_Out_Hmi.iNum_ForcedValues	:= 0;
		END_IF
		VIS2MM.tPlantComm.bFrc_Act := FALSE;
	END_IF
	
	(* Unforce all Global *)
	IF (VIS2MM.tPlantComm.bFrc_Gbl) THEN
		(* Reset HMI Selection of Force Active *)
		FOR x:=0 TO tHmiDiag.iDiagTableSize-1 DO	
			VIS2MM.tPlantComm.bFrc[x] := FALSE;
		END_FOR
		(* Unforce all Signals from/to all Masters*)
		FOR iAssetNum:=1 TO 4 DO
			(* Unforce Analog Inputs/Outputs *)
			FOR x:=0 TO tHmiDiag.iAnaSigCntE2M - 1 DO
				tPlantCom_M2E_In_Hmi[iAssetNum].bAnaForceActive[x] := FALSE;
				tPlantCom_E2M_Out_Hmi[iAssetNum].bAnaForceActive[x] := FALSE;
			END_FOR
			(* Unforce Digital Inputs/Outputs *)
			FOR x:=0 TO tHmiDiag.iDigSigCntE2M - 1 DO
				tPlantCom_M2E_In_Hmi[iAssetNum].bDigForceActive[x] := FALSE;
				tPlantCom_E2M_Out_Hmi[iAssetNum].bDigForceActive[x] := FALSE;
			END_FOR	
			(* Set counter for forced signals to zero*)
			tPlantCom_M2E_In_Hmi[iAssetNum].iNum_ForcedValues 		:= 0;
			tPlantCom_E2M_Out_Hmi[iAssetNum].iNum_ForcedValues  	:= 0;
		END_FOR
		(* Unforce all Signals from/to all Engines *)
		FOR iAssetNum:=1 TO 32 DO
			(* Unforce Analog Inputs/Outputs *)
			FOR x:=0 TO tHmiDiag.iAnaSigCntE2E - 1 DO
				tPlantCom_E2E_In_Hmi[iAssetNum].bAnaForceActive[x] := FALSE;
				tPlantCom_E2E_Out_Hmi.bAnaForceActive[x] := FALSE;
			END_FOR
			(* Unforce Digital Inputs/Outputs *)
			FOR x:=0 TO tHmiDiag.iDigSigCntE2E - 1 DO
				tPlantCom_E2E_In_Hmi[iAssetNum].bDigForceActive[x] := FALSE;
				tPlantCom_E2E_Out_Hmi.bDigForceActive[x] := FALSE;
			END_FOR
			(* Set counter for forced signals to zero*)
			tPlantCom_E2E_In_Hmi[iAssetNum].iNum_ForcedValues 		:= 0;
			tPlantCom_E2E_Out_Hmi.iNum_ForcedValues  				:= 0;				
		END_FOR
		VIS2MM.tPlantComm.bFrc_Gbl := FALSE;
	END_IF
	
	// evaluate number of datapoints depending on the selection to interate over the stored hmi values
	iNum_Datapoints := 0;
	
	(* Copy the selected Data to the internal diagnostic arrays to be displayed on the HMI *)
	CASE tHmiDiag.iIO_Typ_Dir OF
		NO_SELECTION: (* No Selection *)
		FROM_MASTER: (* Signals from Master *)
			IF (tHmiDiag.iIO_Typ_Dir_Num >= 1 AND tHmiDiag.iIO_Typ_Dir_Num <= 4) THEN
				CASE tHmiDiag.iIO_Typ OF
					
					NO_SELECTION: (* No Selection default *)
						
					PlantComm_AI: (* Analog Input *)
						
						(* Validate Start Index *)
						IF (VIS2MM.tPlantComm.iNum_Start > tHmiDiag.iAnaSigCntE2M - tHmiDiag.iDiagTableSize) THEN
							tHmiDiag.iStartIdx := tHmiDiag.iAnaSigCntE2M - tHmiDiag.iDiagTableSize;
							VIS2MM.tPlantComm.iNum_Start := tHmiDiag.iStartIdx;
						ELSE
							tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
						END_IF
						
						iNum_Datapoints := tHmiDiag.iAnaSigCntE2M;
						tHmiDiag.iCommentOffset := INT_TO_UINT(400);
						
						FOR x:=0 TO tHmiDiag.iDiagTableSize - 1 DO
							(* HMI Selection Change *)
							IF (tHmiDiag.bSelectionChange) THEN
								(* Force Active *)
								VIS2MM.tPlantComm.bFrc[x] := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x];
								(* Force Value *)
								VIS2MM.tPlantComm.rFrc_Int[x] := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx+x];
								(* Signal Number *)
								MM2VIS.tPlantComm.iNum[x] := tHmiDiag.iStartIdx + x;
								(* Comment Nr *)
								MM2VIS.tPlantComm.iComment[x] := tHmiDiag.iCommentOffset + tHmiDiag.iStartIdx + x;
							END_IF
							(* No HMI Selection Change *)
							IF(NOT tHmiDiag.bSelectionChange) THEN
								(* Force changes from inactive to active *)
								IF (NOT tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] AND VIS2MM.tPlantComm.bFrc[x]) THEN
									tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues + 1;
									(* Force changes from active to inactive *)
								ELSIF (tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] AND NOT VIS2MM.tPlantComm.bFrc[x]) THEN
									tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues - 1;
								END_IF
								(* Store Force Variables *)
								tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc[x];
								tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.rFrc_Int[x];
							END_IF
							
							(* Display Foced Value as Internal and Bus Value as External Signal when Signal is forced *)
							IF (VIS2MM.tPlantComm.bFrc[x]) THEN
								MM2VIS.tPlantComm.rInt[x] := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx+x];
								MM2VIS.tPlantComm.rExt[x] := tPlantCom_M2E_In_Bus[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
							ELSE
							(* Display Bus Value as Externals and Internal Signal when Signal is not forced *)
								MM2VIS.tPlantComm.rExt[x] := tPlantCom_M2E_In_Bus[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
								MM2VIS.tPlantComm.rInt[x] := tPlantCom_M2E_In_Plc[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
							END_IF
						END_FOR
						
					PlantComm_DI: (* Digital Input *)
						(* Validate Start Index *)
						IF (VIS2MM.tPlantComm.iNum_Start > tHmiDiag.iDigSigCntE2M - tHmiDiag.iDiagTableSize) THEN
							tHmiDiag.iStartIdx := tHmiDiag.iDigSigCntE2M - tHmiDiag.iDiagTableSize;
							VIS2MM.tPlantComm.iNum_Start := tHmiDiag.iStartIdx;
						ELSE
							tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
						END_IF
						
						iNum_Datapoints := tHmiDiag.iDigSigCntE2M;
						tHmiDiag.iCommentOffset := INT_TO_UINT(100);
						
						FOR x:=0 TO tHmiDiag.iDiagTableSize - 1 DO
							(* Hmi Selection Change *)
							IF (tHmiDiag.bSelectionChange) THEN
								(* Force Active*)
								VIS2MM.tPlantComm.bFrc[x] := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x];
								(* Force Value *)
								VIS2MM.tPlantComm.bFrc_Int[x] := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx+x];
								(* Signal Number *)
								MM2VIS.tPlantComm.iNum[x] := tHmiDiag.iStartIdx + x;
								(* Comment Nr *)
								MM2VIS.tPlantComm.iComment[x] := tHmiDiag.iCommentOffset + tHmiDiag.iStartIdx + x;
							END_IF
							(* No HMI Selection change *)
							IF (NOT tHmiDiag.bSelectionChange) THEN
								(* Force changes from inactive to active *)
								IF (NOT tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] AND VIS2MM.tPlantComm.bFrc[x]) THEN
									tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues + 1;
									(* Force changes from active to inactive *)
								ELSIF (tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] AND NOT VIS2MM.tPlantComm.bFrc[x]) THEN
									tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues - 1;
								END_IF
								(* Store Force Values *)
								tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc[x];
								tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc_Int[x];
							END_IF
							
							(* Display Foced Value as Internal and Bus Value as External Signal when Signal is forced *)
							IF (VIS2MM.tPlantComm.bFrc[x]) THEN
								MM2VIS.tPlantComm.rInt[x] := BOOL_TO_REAL(tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx+x]);
								MM2VIS.tPlantComm.rExt[x] := BOOL_TO_REAL(tPlantCom_M2E_In_Bus[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
							ELSE
								(* Display Bus Value as Externals and Internal Signal when Signal is not forced *)
								MM2VIS.tPlantComm.rExt[x] := BOOL_TO_REAL(tPlantCom_M2E_In_Bus[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
								MM2VIS.tPlantComm.rInt[x] := BOOL_TO_REAL(tPlantCom_M2E_In_Plc[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
							END_IF
						END_FOR
						
					PlantComm_AO: (* Analog Output n/a *)
						
					PlantComm_DO: (* Digital Output n/a *)
				END_CASE
			END_IF
		FROM_ENGINE: (* Signals from Engine *)
			IF (tHmiDiag.iIO_Typ_Dir_Num >= 1 AND tHmiDiag.iIO_Typ_Dir_Num <= 32) THEN
				CASE tHmiDiag.iIO_Typ OF
					NO_SELECTION: (* No Selection default *)
						
					PlantComm_AI: (* Analog Input *)
						(* Validate Start Index *)
						IF (VIS2MM.tPlantComm.iNum_Start > tHmiDiag.iAnaSigCntE2E - tHmiDiag.iDiagTableSize) THEN
							tHmiDiag.iStartIdx := tHmiDiag.iAnaSigCntE2E - tHmiDiag.iDiagTableSize;
							VIS2MM.tPlantComm.iNum_Start := tHmiDiag.iStartIdx;
						ELSE
							tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
						END_IF;
						
						tHmiDiag.iCommentOffset := INT_TO_UINT(500);
						iNum_Datapoints := tHmiDiag.iAnaSigCntE2E;
						
						FOR x:=0 TO tHmiDiag.iDiagTableSize - 1 DO
							(* HMI Selection Change *)
							IF (tHmiDiag.bSelectionChange) THEN 
								(* Signal Number *)
								MM2VIS.tPlantComm.iNum[x] := tHmiDiag.iStartIdx + x;
								(* Force Active *)
								VIS2MM.tPlantComm.bFrc[x] := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx + x];
								(* Force Value *)
								VIS2MM.tPlantComm.rFrc_Int[x] := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx + x];
								(* Comment Nr *)
								MM2VIS.tPlantComm.iComment[x] := tHmiDiag.iCommentOffset + tHmiDiag.iStartIdx + x;
							END_IF
							(* No HMI Selection Change *)
							IF (NOT tHmiDiag.bSelectionChange) THEN
								(* Force changes from inactive to active *)
								IF (NOT tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] AND VIS2MM.tPlantComm.bFrc[x]) THEN
									tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues + 1;
								(* Force changes from active to inactive *)
								ELSIF (tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] AND NOT VIS2MM.tPlantComm.bFrc[x]) THEN
									tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues - 1;
								END_IF
								
								(* Store Force Values *)
								tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc[x];
								tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.rFrc_Int[x];
							END_IF
							
							(* Display Foced Value as Internal and Bus Value as External Signal when Signal is forced *)
							IF (VIS2MM.tPlantComm.bFrc[x]) THEN
								MM2VIS.tPlantComm.rInt[x] := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx+x];
								MM2VIS.tPlantComm.rExt[x] := tPlantCom_E2E_In_Bus[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
							ELSE
								(* Display Bus Value as Externals and Internal Signal when Signal is not forced *)
								MM2VIS.tPlantComm.rExt[x] := tPlantCom_E2E_In_Bus[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
								MM2VIS.tPlantComm.rInt[x] := tPlantCom_E2E_In_Plc[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
							END_IF
						END_FOR
						
					PlantComm_DI: (* Digital Input *)
						(* Evaluate Start Index *)
						IF (VIS2MM.tPlantComm.iNum_Start > tHmiDiag.iDigSigCntE2E - tHmiDiag.iDiagTableSize) THEN
							tHmiDiag.iStartIdx := tHmiDiag.iDigSigCntE2E - tHmiDiag.iDiagTableSize;
							VIS2MM.tPlantComm.iNum_Start := tHmiDiag.iStartIdx;
						ELSE
							tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
						END_IF
					
						iNum_Datapoints := tHmiDiag.iDigSigCntE2E;
						tHmiDiag.iCommentOffset := INT_TO_UINT(200);
						
						FOR x:=0 TO tHmiDiag.iDiagTableSize - 1 DO
							(* HMI Selection Change *)
							IF (tHmiDiag.bSelectionChange) THEN
								(* Signal Number *)
								MM2VIS.tPlantComm.iNum[x] := tHmiDiag.iStartIdx + x;
								(* Force Active *)
								VIS2MM.tPlantComm.bFrc[x] := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx + x];
								(* Force Value BOOL *)
								VIS2MM.tPlantComm.bFrc_Int[x] := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx + x];
								(* Comment Nr *)
								MM2VIS.tPlantComm.iComment[x] := tHmiDiag.iCommentOffset + tHmiDiag.iStartIdx + x;
							END_IF
							(* No HMI Selection Change *)
							IF (NOT tHmiDiag.bSelectionChange) THEN
								(* Force changes from inactive to active *)
								IF (NOT tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] AND VIS2MM.tPlantComm.bFrc[x]) THEN
									tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues + 1;
									(* Force changes from active to inactive *)
								ELSIF (tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] AND NOT VIS2MM.tPlantComm.bFrc[x]) THEN
									tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues - 1;
								END_IF
								
								(* Store Force Values *)
								tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc[x];
								tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc_Int[x];
							END_IF

							(* Display Foced Value as Internal and Bus Value as External Signal when Signal is forced *)
							IF (VIS2MM.tPlantComm.bFrc[x]) THEN
								MM2VIS.tPlantComm.rInt[x] := BOOL_TO_REAL(tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx+x]);
								MM2VIS.tPlantComm.rExt[x] := BOOL_TO_REAL(tPlantCom_E2E_In_Bus[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
							ELSE
								(* Display Bus Value as Externals and Internal Signal when Signal is not forced *)
								MM2VIS.tPlantComm.rExt[x] := BOOL_TO_REAL(tPlantCom_E2E_In_Bus[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
								MM2VIS.tPlantComm.rInt[x] := BOOL_TO_REAL(tPlantCom_E2E_In_Plc[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
							END_IF	
						END_FOR
						
					PlantComm_AO: (* Analog Output n/a *)
					PlantComm_DO: (* Digital Output n/a *)
				END_CASE
			END_IF
			
			
		
		TO_MASTER: (* Signals to Master *)

			CASE tHmiDiag.iIO_Typ OF
				NO_SELECTION: (* No Selection default *)
						
				PlantComm_AI: (* Analog Input n/a *)
						
				PlantComm_DI: (* Digital Input n/a *)
						
				PlantComm_AO: (* Analog Output *)
					(* Validate Start Index *)
					IF (VIS2MM.tPlantComm.iNum_Start > tHmiDiag.iAnaSigCntE2M - tHmiDiag.iDiagTableSize) THEN
						tHmiDiag.iStartIdx := tHmiDiag.iAnaSigCntE2M - tHmiDiag.iDiagTableSize;
						VIS2MM.tPlantComm.iNum_Start := tHmiDiag.iStartIdx;
					ELSE
						tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
					END_IF;
						
					iNum_Datapoints := tHmiDiag.iAnaSigCntE2M;
					tHmiDiag.iCommentOffset := INT_TO_UINT(300);
						
					FOR x:=0 TO tHmiDiag.iDiagTableSize - 1 DO
						(* HMI Selection Change*)
						IF (tHmiDiag.bSelectionChange) THEN
							(* Force Active *)
							VIS2MM.tPlantComm.bFrc[x] := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x];
							(* Force Value *)
							VIS2MM.tPlantComm.rFrc_Int[x] := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx+x];								
							(* Signal Number *)
							MM2VIS.tPlantComm.iNum[x] := tHmiDiag.iStartIdx + x;
							(* Comment Nr *)
							MM2VIS.tPlantComm.iComment[x] := tHmiDiag.iCommentOffset + tHmiDiag.iStartIdx + x;
						END_IF
						(* No HMI Selection Change *)
						IF (NOT tHmiDiag.bSelectionChange) THEN
							(* Force changes from inactive to active *)
							IF (NOT tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] AND VIS2MM.tPlantComm.bFrc[x]) THEN
								tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues + 1;
							(* Force changes from active to inactive *)
							ELSIF (tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] AND NOT VIS2MM.tPlantComm.bFrc[x]) THEN
								tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues - 1;
							END_IF
							(* Store Force Value from HMI*)
							tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc[x];
							tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.rFrc_Int[x];
						END_IF
						
						IF (VIS2MM.tPlantComm.bFrc[x]) THEN
							MM2VIS.tPlantComm.rExt[x] := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].rForceValue[tHmiDiag.iStartIdx+x];
							MM2VIS.tPlantComm.rInt[x] := tPlantCom_E2M_Out_Plc[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
						ELSE
							MM2VIS.tPlantComm.rExt[x] := tPlantCom_E2M_Out_Bus[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
							MM2VIS.tPlantComm.rInt[x] := tPlantCom_E2M_Out_Plc[tHmiDiag.iIO_Typ_Dir_Num].analogSignals[tHmiDiag.iStartIdx+x].Value;
						END_IF
					END_FOR
					
				PlantComm_DO: (* Digital Output *)
					(* Validate Start Index *)
					IF (VIS2MM.tPlantComm.iNum_Start > tHmiDiag.iDigSigCntE2M - tHmiDiag.iDiagTableSize) THEN
						tHmiDiag.iStartIdx := tHmiDiag.iDigSigCntE2M - tHmiDiag.iDiagTableSize;
						VIS2MM.tPlantComm.iNum_Start := tHmiDiag.iStartIdx;
					ELSE
						tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
					END_IF
						
					iNum_Datapoints := tHmiDiag.iDigSigCntE2M;
					tHmiDiag.iCommentOffset := INT_TO_UINT(0);
						
					FOR x:=0 TO tHmiDiag.iDiagTableSize - 1 DO
						(* HMI Selection Change *)
						IF (tHmiDiag.bSelectionChange) THEN
							(* Signal Number *)
							MM2VIS.tPlantComm.iNum[x] := tHmiDiag.iStartIdx + x;
							(* Force Active *)
							VIS2MM.tPlantComm.bFrc[x] := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx + x];
							(* Force Value BOOL *)
							VIS2MM.tPlantComm.bFrc_Int[x] := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx + x];
							(* Comment Nr *)
							MM2VIS.tPlantComm.iComment[x] := tHmiDiag.iCommentOffset + tHmiDiag.iStartIdx + x;
						END_IF
						(* No HMI Selection Change *)
						IF (NOT tHmiDiag.bSelectionChange) THEN
							(* Force changes from inactive to active *)
							IF (NOT tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] AND VIS2MM.tPlantComm.bFrc[x]) THEN
								tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues + 1;
								(* Force changes from active to inactive *)
							ELSIF (tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] AND NOT VIS2MM.tPlantComm.bFrc[x]) THEN
								tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues := tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].iNum_ForcedValues - 1;
							END_IF
							(* Store Force Values *)
							tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc[x];
							tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc_Int[x];	
						END_IF					
						
						IF (VIS2MM.tPlantComm.bFrc[x]) THEN
							MM2VIS.tPlantComm.rExt[x] := BOOL_TO_REAL(tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bForceValue[tHmiDiag.iStartIdx+x]);
							MM2VIS.tPlantComm.rInt[x] := BOOL_TO_REAL(tPlantCom_E2M_Out_Plc[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
						ELSE
							MM2VIS.tPlantComm.rExt[x] := BOOL_TO_REAL(tPlantCom_E2M_Out_Bus[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
							MM2VIS.tPlantComm.rInt[x] := BOOL_TO_REAL(tPlantCom_E2M_Out_Plc[tHmiDiag.iIO_Typ_Dir_Num].digitalSignals[tHmiDiag.iStartIdx+x].Value);
						END_IF
					END_FOR
			END_CASE			
		TO_ENGINE: (* Signals to Engine*)
			CASE tHmiDiag.iIO_Typ OF
				NO_SELECTION: (* No Selection default *)
					
				PlantComm_AI: (* Analog Input n/a*)
					
				PlantComm_DI: (* Digital Input n/a*)
					
				PlantComm_AO: (* Analog Output *)
					(* Validate Start Index *)
					IF (VIS2MM.tPlantComm.iNum_Start > tHmiDiag.iAnaSigCntE2E - tHmiDiag.iDiagTableSize) THEN
						tHmiDiag.iStartIdx := tHmiDiag.iAnaSigCntE2E - tHmiDiag.iDiagTableSize;
						VIS2MM.tPlantComm.iNum_Start := tHmiDiag.iStartIdx;
					ELSE
						tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
					END_IF
					
					iNum_Datapoints := tHmiDiag.iAnaSigCntE2E;
					tHmiDiag.iCommentOffset := INT_TO_UINT(500);
					
					FOR x:=0 TO tHmiDiag.iDiagTableSize - 1 DO
						(* HMI Selection Change *)
						IF (tHmiDiag.bSelectionChange) THEN 
							(* Force Active *)
							VIS2MM.tPlantComm.bFrc[x] := tPlantCom_E2E_Out_Hmi.bAnaForceActive[tHmiDiag.iStartIdx+x];
							(* Force Value *)
							VIS2MM.tPlantComm.rFrc_Int[x] := tPlantCom_E2E_Out_Hmi.rForceValue[tHmiDiag.iStartIdx+x];
							(* Signal Number *)
							MM2VIS.tPlantComm.iNum[x] := tHmiDiag.iStartIdx + x;
							(* Comment Nr *)
							MM2VIS.tPlantComm.iComment[x] := tHmiDiag.iCommentOffset + tHmiDiag.iStartIdx + x;
						END_IF
						(* No HMI Selection Change *)
						IF (NOT tHmiDiag.bSelectionChange) THEN
							(* Force changes from inactive to active *)
							IF (NOT tPlantCom_E2E_Out_Hmi.bAnaForceActive[tHmiDiag.iStartIdx+x] AND VIS2MM.tPlantComm.bFrc[x]) THEN
								tPlantCom_E2E_Out_Hmi.iNum_ForcedValues := tPlantCom_E2E_Out_Hmi.iNum_ForcedValues + 1;
							(* Force changes from active to inactive *)
							ELSIF (tPlantCom_E2E_Out_Hmi.bAnaForceActive[tHmiDiag.iStartIdx+x] AND NOT VIS2MM.tPlantComm.bFrc[x]) THEN
								tPlantCom_E2E_Out_Hmi.iNum_ForcedValues := tPlantCom_E2E_Out_Hmi.iNum_ForcedValues - 1;
							END_IF
							(* Store Forced Values *)
							tPlantCom_E2E_Out_Hmi.bAnaForceActive[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc[x];
							tPlantCom_E2E_Out_Hmi.rForceValue[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.rFrc_Int[x];
						END_IF
						
						IF (VIS2MM.tPlantComm.bFrc[x]) THEN
							MM2VIS.tPlantComm.rExt[x] := tPlantCom_E2E_Out_Hmi.rForceValue[tHmiDiag.iStartIdx+x];
							MM2VIS.tPlantComm.rInt[x] := tPlantCom_E2E_Out_Plc.analogSignals[tHmiDiag.iStartIdx+x].Value;
						ELSE
							MM2VIS.tPlantComm.rExt[x] := tPlantCom_E2E_Out_Bus.analogSignals[tHmiDiag.iStartIdx+x].Value;
							MM2VIS.tPlantComm.rInt[x] := tPlantCom_E2E_Out_Plc.analogSignals[tHmiDiag.iStartIdx+x].Value;
						END_IF
					END_FOR
					
				PlantComm_DO: (* Digital Output *)
					(* Evaluate Start Index *)
					IF (VIS2MM.tPlantComm.iNum_Start > tHmiDiag.iDigSigCntE2E - tHmiDiag.iDiagTableSize) THEN
						tHmiDiag.iStartIdx := tHmiDiag.iDigSigCntE2E - tHmiDiag.iDiagTableSize;
						VIS2MM.tPlantComm.iNum_Start := tHmiDiag.iStartIdx;
					ELSE
						tHmiDiag.iStartIdx := VIS2MM.tPlantComm.iNum_Start;
					END_IF
					
					iNum_Datapoints := tHmiDiag.iDigSigCntE2E;
					tHmiDiag.iCommentOffset := INT_TO_UINT(200);
					
					FOR x:=0 TO tHmiDiag.iDiagTableSize - 1 DO
						IF (tHmiDiag.bSelectionChange) THEN
							(* Force Active *)
							VIS2MM.tPlantComm.bFrc[x] := tPlantCom_E2E_Out_Hmi.bDigForceActive[tHmiDiag.iStartIdx+x];
							(* Force Value *)
							VIS2MM.tPlantComm.bFrc_Int[x] := tPlantCom_E2E_Out_Hmi.bForceValue[tHmiDiag.iStartIdx+x];
							(* Signal Number *)
							MM2VIS.tPlantComm.iNum[x] := tHmiDiag.iStartIdx + x;
							(* Comment Nr *)
							MM2VIS.tPlantComm.iComment[x] := tHmiDiag.iCommentOffset + tHmiDiag.iStartIdx + x;
						END_IF
						(* No HMI Selection Change *)
						IF (NOT tHmiDiag.bSelectionChange) THEN
							(* Force changes from inactive to active *)
							IF (NOT tPlantCom_E2E_Out_Hmi.bDigForceActive[tHmiDiag.iStartIdx+x] AND VIS2MM.tPlantComm.bFrc[x]) THEN
								tPlantCom_E2E_Out_Hmi.iNum_ForcedValues := tPlantCom_E2E_Out_Hmi.iNum_ForcedValues + 1;
							(* Force changes from active to inactive *)
							ELSIF (tPlantCom_E2E_Out_Hmi.bDigForceActive[tHmiDiag.iStartIdx+x] AND NOT VIS2MM.tPlantComm.bFrc[x]) THEN
								tPlantCom_E2E_Out_Hmi.iNum_ForcedValues := tPlantCom_E2E_Out_Hmi.iNum_ForcedValues - 1;
							END_IF
							(* Store Force Value *)
							tPlantCom_E2E_Out_Hmi.bDigForceActive[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc[x];
							tPlantCom_E2E_Out_Hmi.bForceValue[tHmiDiag.iStartIdx+x] := VIS2MM.tPlantComm.bFrc_Int[x];
						END_IF
						
						IF (VIS2MM.tPlantComm.bFrc[x]) THEN
							MM2VIS.tPlantComm.rExt[x] := BOOL_TO_REAL(tPlantCom_E2E_Out_Hmi.bForceValue[tHmiDiag.iStartIdx+x]);
							MM2VIS.tPlantComm.rInt[x] := BOOL_TO_REAL(tPlantCom_E2E_Out_Plc.digitalSignals[tHmiDiag.iStartIdx+x].Value);
						ELSE
							MM2VIS.tPlantComm.rExt[x] := BOOL_TO_REAL(tPlantCom_E2E_Out_Bus.digitalSignals[tHmiDiag.iStartIdx+x].Value);
							MM2VIS.tPlantComm.rInt[x] := BOOL_TO_REAL(tPlantCom_E2E_Out_Plc.digitalSignals[tHmiDiag.iStartIdx+x].Value);
						END_IF
					END_FOR
			END_CASE
	END_CASE
	
	(* Calculate the number of forced values for the selected Asset *)
	MM2VIS.tPlantComm.iFrc_Act := 0;
	(* Check if an Asset is selected *)
	IF (tHmiDiag.iIO_Typ_Dir_Num >= 1 AND tHmiDiag.iIO_Typ_Dir_Num <= 4) THEN
		IF (tHmiDiag.iIO_Typ_Dir = FROM_MASTER OR tHmiDiag.iIO_Typ_Dir = TO_MASTER) THEN
			(* Number of Forced Analog Inputs/Outputs *)
			FOR x:=0 TO tHmiDiag.iAnaSigCntE2M - 1 DO
				IF (tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[x]) THEN
					MM2VIS.tPlantComm.iFrc_Act := MM2VIS.tPlantComm.iFrc_Act + 1;
				END_IF
				IF (tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[x]) THEN
					MM2VIS.tPlantComm.iFrc_Act := MM2VIS.tPlantComm.iFrc_Act + 1;
				END_IF
			END_FOR
			(* Number of Forced Digital Inputs/Outputs *)
			FOR x:=0 TO tHmiDiag.iDigSigCntE2M - 1 DO	
				IF (tPlantCom_M2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[x]) THEN
					MM2VIS.tPlantComm.iFrc_Act := MM2VIS.tPlantComm.iFrc_Act + 1;
				END_IF

				IF (tPlantCom_E2M_Out_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[x]) THEN
					MM2VIS.tPlantComm.iFrc_Act := MM2VIS.tPlantComm.iFrc_Act + 1;
				END_IF
			END_FOR
		ELSIF (tHmiDiag.iIO_Typ_Dir = FROM_ENGINE OR tHmiDiag.iIO_Typ_Dir = TO_ENGINE) THEN
			(* Number of Forced Analog Inputs/Outputs *)
			FOR x:=0 TO tHmiDiag.iAnaSigCntE2E - 1 DO
				IF (tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bAnaForceActive[x]) THEN
					MM2VIS.tPlantComm.iFrc_Act := MM2VIS.tPlantComm.iFrc_Act + 1;
				END_IF
				IF (tPlantCom_E2E_Out_Hmi.bAnaForceActive[x]) THEN
					MM2VIS.tPlantComm.iFrc_Act := MM2VIS.tPlantComm.iFrc_Act + 1;
				END_IF
			END_FOR
			(* Number of Forced Digital Inputs/Outputs *)
			FOR x:=0 TO tHmiDiag.iDigSigCntE2E - 1 DO
				IF (tPlantCom_E2E_In_Hmi[tHmiDiag.iIO_Typ_Dir_Num].bDigForceActive[x]) THEN
					MM2VIS.tPlantComm.iFrc_Act := MM2VIS.tPlantComm.iFrc_Act + 1;
				END_IF
				IF (tPlantCom_E2E_Out_Hmi.bDigForceActive[x]) THEN
					MM2VIS.tPlantComm.iFrc_Act := MM2VIS.tPlantComm.iFrc_Act + 1;
				END_IF
			END_FOR
		END_IF
	END_IF
	
	(* Calculate the number of global forced values *)
	tHmiDiag.iForcedValueCntGlobal := 0;
	FOR x:=iMasNumMin TO iMasNumMax DO
		IF (x >= 1 AND x <= 4) THEN
			tHmiDiag.iForcedValueCntGlobal := tHmiDiag.iForcedValueCntGlobal + tPlantCom_M2E_In_Hmi[x].iNum_ForcedValues;
			tHmiDiag.iForcedValueCntGlobal := tHmiDiag.iForcedValueCntGlobal + tPlantCom_E2M_Out_Hmi[x].iNum_ForcedValues;
		END_IF
	END_FOR;
	
	FOR x:=iEngNumMin TO iEngNumMax DO
		IF (x >= 1 AND x <= 32) THEN
			tHmiDiag.iForcedValueCntGlobal := tHmiDiag.iForcedValueCntGlobal + tPlantCom_E2E_In_Hmi[x].iNum_ForcedValues;
		END_IF
	END_FOR;
	tHmiDiag.iForcedValueCntGlobal := tHmiDiag.iForcedValueCntGlobal + tPlantCom_E2E_Out_Hmi.iNum_ForcedValues;
	MM2VIS.tPlantComm.iFrc_Gbl := tHmiDiag.iForcedValueCntGlobal;
	
	(* Initial Value of the comment column on the hmi when nothing is selected *)
	IF (VIS2MM.tPlantComm.iIO_Typ = 0 OR VIS2MM.tPlantComm.iIO_Typ_Dir = 0) THEN
		FOR x:=0 TO tHmiDiag.iDiagTableSize-1 DO
			MM2VIS.tPlantComm.iFrc_Act := 0;
			MM2VIS.tPlantComm.iNum[x] := 0;
			MM2VIS.tPlantComm.rInt[x] := 0.0;
			MM2VIS.tPlantComm.rExt[x] := 0.0;
			MM2VIS.tPlantComm.iComment[x] := 99;
			VIS2MM.tPlantComm.bFrc[x] := FALSE;
			VIS2MM.tPlantComm.bFrc_Int[x] := FALSE;
			VIS2MM.tPlantComm.rFrc_Int[x] := 0.0;
		END_FOR
	END_IF
	
END_PROGRAM