(*******************************************************************************
Ansl configuration for the Plant Communication

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2024

Customized modifications: -
------------------------
 
History:
-------
V4.14.0	26.11.2024	Astner	Created Task

						
Instructions for use:
--------------------
The Configuration of the ANSL Communication is executed automatically when valid Parameter Values are configured.
If the Communication to the Master Control is redundant, set the variable bRedundantMasterEnabled in the Init Task.

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT
	(* Master 1 is redundant *)
	bRedundantMasterEnabled := FALSE;
	
	(* Default diagnostic bits *)
	MM2VIS.tPlantComm.bCfg_Err := FALSE;
	MM2VIS.tPlantComm.bCfg_OK  := FALSE;
	MM2VIS.tPlantComm.bCfg_Rst := FALSE;
	
	(* IP & SUBNET Masks *)
	FOR x:=1 TO 4 DO
		iMastersSUB[x]	:=	122;
		iMastersIP[x] 	:= 	30 + x;
	END_FOR
	
	FOR x:=1 TO 32 DO
		iEnginesSUB[x]	:=	122;
		iEnginesIP[x] 	:= 	10 + x;
	END_FOR	
	(* Initialize Configuration Strings and Pointers *)
	strAnslDataObjName := 'HalIO::ANSLCom';
	strThisEngineNr := '';
	strCurrentAssetIP := '';
	strCurrentAssetSub := '';
	strCurrentAssetNum := '';
	strANSL_config := '';
	pANSL_config := ADR(strANSL_config);
	strAnsl_Com_Pw := 'vvsZKl2WtfuUhIlKaiANBLBnqHMr7jLXo7MDs/K0/P5wtUylYnR+0YUUjcfS9T0G';
	
	iSTEP := GET_MODULE_NR;
	
	tDiagClient;
	tDiagMaster;
	tDiagEngine;
	
END_PROGRAM