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

PROGRAM _CYCLIC
	
	(* Parameters and Configuration Status for customized module *)
	OUT_HA.bPlantComCfgOk 		:= MM2VIS.tPlantComm.bCfg_OK;
		(* Start ANSL Configuration when parameter is set *)
	IF (EDGEPOS(Para.tPlantComm.bActive)) THEN
		MM2VIS.tPlantComm.bCfg_Err := FALSE;
		MM2VIS.tPlantComm.bCfg_OK := FALSE;
		MM2VIS.tPlantComm.bCfg_Rst := FALSE;
		iSTEP := GET_MODULE_NR;
	(* Stop ANSL Communication when parameter is unset *)
	ELSIF (EDGENEG(Para.tPlantComm.bActive)) THEN
		iSTEP := STOP_ANSL_COM;
		(* Exit Programm if parameter is not set *)
	ELSIF (NOT Para.tPlantComm.bActive AND NOT bPlantCommStopInProgress) THEN
		RETURN;
	END_IF;
	
	CASE iSTEP OF
		DATAOBJ_ERROR:
			(* Set HMI Diagnostics Error *)
			MM2VIS.tPlantComm.bCfg_Err := TRUE;
			MM2VIS.tPlantComm.bCfg_OK := FALSE;
			MM2VIS.tPlantComm.bCfg_Rst := FALSE;
			RETURN;
		ANSL_ERROR:
			(* Set HMI Diagnostics Error *)
			MM2VIS.tPlantComm.bCfg_Err := TRUE;
			MM2VIS.tPlantComm.bCfg_OK := FALSE;
			MM2VIS.tPlantComm.bCfg_Rst := FALSE;
			RETURN;
		GET_MODULE_NR:
			(* Set Engine Number to 1 for WinMOD Simulation *)
			IF (OUT_HA.bSimWinMOD_Active) THEN
				iThisEngineNr := 1;
				itoa(iThisEngineNr, ADR(strThisEngineNr));
				(* Reset Error bits*)
				MM2VIS.tPlantComm.bCfg_Err := FALSE;
				MM2VIS.tPlantComm.bCfg_OK := FALSE;
				MM2VIS.tPlantComm.bCfg_Rst := FALSE;
				(* Go to the next step *)
				iSTEP := PREP_DATAOBJ;	
				RETURN;
			END_IF;
			(* Use Engine Number from HMI *)
			IF (IN_HA.iModule >= 1 AND IN_HA.iModule <= 32) THEN
				iThisEngineNr := IN_HA.iModule;
				itoa(iThisEngineNr, ADR(strThisEngineNr));
			ELSE
				MM2VIS.tPlantComm.bCfg_Err := TRUE;
				MM2VIS.tPlantComm.bCfg_OK := FALSE;
				MM2VIS.tPlantComm.bCfg_Rst := FALSE;
				RETURN;
			END_IF;
			IF (Para.tPlantComm.iEng_Num_Min = 0 AND Para.tPlantComm.iEng_Num_Max = 0) THEN
				bEng2EngComEnabled := FALSE;
			ELSIF (Para.tPlantComm.iEng_Num_Min > Para.tPlantComm.iEng_Num_Max) THEN
				MM2VIS.tPlantComm.bCfg_Err := TRUE;
				MM2VIS.tPlantComm.bCfg_OK := FALSE;
				MM2VIS.tPlantComm.bCfg_Rst := FALSE;
				RETURN;
			(* Out of bounds check *)
			ELSIF (Para.tPlantComm.iEng_Num_Min < 1 OR Para.tPlantComm.iEng_Num_Min > 32 OR Para.tPlantComm.iEng_Num_Max < 1 OR Para.tPlantComm.iEng_Num_Max > 32) THEN
				MM2VIS.tPlantComm.bCfg_Err := TRUE;
				MM2VIS.tPlantComm.bCfg_OK := FALSE;
				MM2VIS.tPlantComm.bCfg_Rst := FALSE;
				RETURN;
			ELSE
				bEng2EngComEnabled := TRUE;
				iEngNumMin := Para.tPlantComm.iEng_Num_Min;
				iEngNumMax := Para.tPlantComm.iEng_Num_Max;
			END_IF;
			IF (Para.tPlantComm.iMas_Num_Min = 0 AND Para.tPlantComm.iMas_Num_Max = 0) THEN
				bEng2MasComEnabled := FALSE;
			ELSIF (Para.tPlantComm.iMas_Num_Min > Para.tPlantComm.iMas_Num_Max) THEN
				MM2VIS.tPlantComm.bCfg_Err := TRUE;
				MM2VIS.tPlantComm.bCfg_OK := FALSE;
				MM2VIS.tPlantComm.bCfg_Rst := FALSE;
				RETURN;
			ELSE
				bEng2MasComEnabled := TRUE;
				iMasNumMin := Para.tPlantComm.iMas_Num_Min;
				iMasNumMax := Para.tPlantComm.iMas_Num_Max;
			END_IF;
			
			(* Reset Error bits and continue with the next step *)
			MM2VIS.tPlantComm.bCfg_Err := FALSE;
			MM2VIS.tPlantComm.bCfg_OK := FALSE;
			MM2VIS.tPlantComm.bCfg_Rst := FALSE;
			iSTEP := PREP_DATAOBJ;	
			
		PREP_DATAOBJ:
			(*** Creation of the ANSL Configuration Data Object ***)
			
			(* ANSL Header *)
			strcat(pANSL_config, ADR('<?xml version ="1.0" encoding="utf-8"?>'));
			strcat(pANSL_config, ADR('<AnslClient>'));
			strcat(pANSL_config, ADR('<Diag TimeStamp="HalIO::tDiagClient.TimeStamp" ClientConn="HalIO::tDiagClient.Conn" ClientConnErr="HalIO::tDiagClient.ConnErr"/>'));
			
			(********************************************************************)
			(*																	*)
			(*                   Communication to Master						*)
			(*																	*)
			(********************************************************************)
			
			IF (bEng2MasComEnabled) THEN
				IF (NOT bRedundantMasterEnabled) THEN
					(* Add configured Masters to communication *)
					FOR x:=iMasNumMin TO iMasNumMax DO
						(* Check length of config object *)
						IF strlen(pANSL_config) > iANSL_config_length_max - 1000 THEN 
							iSTEP := DATAOBJ_ERROR;
							RETURN; 
						END_IF;
						(* Convert current asset numbers to strings *)
						strCurrentAssetNum 	:= '';
						strCurrentAssetSub 	:= '';
						strCurrentAssetIP 	:= '';
						itoa(x, ADR(strCurrentAssetNum));
						itoa(iMastersSUB[x], ADR(strCurrentAssetSub));
						itoa(iMastersIP[x], ADR(strCurrentAssetIP));
						
						//Line 1
						strcat(pANSL_config, ADR('<Connection ConnName="Master'));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('" TargetAddr="192.168.'));
						strcat(pANSL_config, ADR(strCurrentAssetSub));
						strcat(pANSL_config, ADR('.'));
						strcat(pANSL_config, ADR(strCurrentAssetIP));
						strcat(pANSL_config, ADR('" AnslPort="11179" Timeout="5000" SendDelay="2" BfSize="65536" ConnMode="0" EnableSSL="1" SSLConfig="SSL_Eng'));
						strcat(pANSL_config, ADR(strThisEngineNr));
						strcat(pANSL_config, ADR('" PW="'));
						strcat(pANSL_config, ADR(strAnsl_Com_Pw));
						strcat(pANSL_config, ADR('">'));
						// Line 2
						strcat(pANSL_config, ADR('<Diag ConnErr="HalIO::tDiagMaster['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('].Err" ConnPvWrite="HalIO::tDiagMaster['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('].PvWrite" ConnPvWriteErr="HalIO::tDiagMaster['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('].PvWriteErr" ConnPvReadErr="HalIO::tDiagMaster['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('].PvReadErr"/>'));
						// Line 3		
						strcat(pANSL_config, ADR('<PVS>'));
						// Line 4		
						strcat(pANSL_config, ADR('<Read LocalPvName="HalIO::tPlantCom_M2E_In_100ms['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR(']" RemotePvName="HalIO::tPlantCom_M2E_Out_100ms['));
						strcat(pANSL_config, ADR(strThisEngineNr));
						strcat(pANSL_config, ADR(']" DefaultValue="0" SyncPv="0" RefreshRate="100" Hysteresis="0"/>'));
						// Line 5		
						strcat(pANSL_config, ADR('<Read LocalPvName="HalIO::tPlantCom_M2E_In_10ms['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR(']" RemotePvName="HalIO::tPlantCom_M2E_Out_10ms['));
						strcat(pANSL_config, ADR(strThisEngineNr));
						strcat(pANSL_config, ADR(']" DefaultValue="0" SyncPv="0" RefreshRate="10" Hysteresis="0"/>'));		
						// Line 6
						strcat(pANSL_config, ADR('</PVS>'));		
						// Line 7
						strcat(pANSL_config, ADR('</Connection>'));	
					END_FOR
				ELSE
					(********************************************************************)
					(*																	*)
					(*                 Communication to Redundant Master				*)
					(*																	*)
					(********************************************************************)
					
					(* Check length of config object *)
					IF strlen(pANSL_config) > iANSL_config_length_max - 1000 THEN 
						iSTEP := DATAOBJ_ERROR;
						RETURN; 
					END_IF;
					(* Convert current asset numbers to strings *)
					strCurrentAssetNum 	:= '';
					strCurrentAssetSub 	:= '';
					strCurrentAssetIP 	:= '';
					itoa(1, ADR(strCurrentAssetNum));
					itoa(iMastersSUB[1], ADR(strCurrentAssetSub));
					itoa(iMastersIP[1], ADR(strCurrentAssetIP));
						
					//Line 1
					strcat(pANSL_config, ADR('<Connection ConnName="Master'));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR('" TargetAddr="192.168.'));
					strcat(pANSL_config, ADR(strCurrentAssetSub));
					strcat(pANSL_config, ADR('.'));
					strcat(pANSL_config, ADR(strCurrentAssetIP));
					strcat(pANSL_config, ADR('" AnslPort="11169" Timeout="5000" SendDelay="2" BfSize="65536" ConnMode="1" EnableSSL="0" SSLConfig="SSL_Eng'));
					strcat(pANSL_config, ADR(strThisEngineNr));
					strcat(pANSL_config, ADR('" PW="'));
					strcat(pANSL_config, ADR(strAnsl_Com_Pw));
					strcat(pANSL_config, ADR('">'));
					// Line 2
					strcat(pANSL_config, ADR('<Diag ConnErr="HalIO::tDiagMaster['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR('].Err" ConnPvWrite="HalIO::tDiagMaster['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR('].PvWrite" ConnPvWriteErr="HalIO::tDiagMaster['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR('].PvWriteErr" ConnPvReadErr="HalIO::tDiagMaster['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR('].PvReadErr" RedConnActIpAddr="HalIO::tDiagMaster['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR('].RedConnActIpAddr" RedConnAct="HalIO::tDiagMaster['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR('].RedConnAct" RedConnState="HalIO::tDiagMaster['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR('].RedConnState"/>'));
					// Line 3		
					strcat(pANSL_config, ADR('<PVS>'));
					// Line 4		
					strcat(pANSL_config, ADR('<Read LocalPvName="HalIO::tPlantCom_M2E_In_100ms['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR(']" RemotePvName="HalIO::tPlantCom_M2E_Out_100ms['));
					strcat(pANSL_config, ADR(strThisEngineNr));
					strcat(pANSL_config, ADR(']" DefaultValue="0" SyncPv="0" RefreshRate="100" Hysteresis="0"/>'));
					// Line 5		
					strcat(pANSL_config, ADR('<Read LocalPvName="HalIO::tPlantCom_M2E_In_10ms['));
					strcat(pANSL_config, ADR(strCurrentAssetNum));
					strcat(pANSL_config, ADR(']" RemotePvName="HalIO::tPlantCom_M2E_Out_10ms['));
					strcat(pANSL_config, ADR(strThisEngineNr));
					strcat(pANSL_config, ADR(']" DefaultValue="0" SyncPv="0" RefreshRate="10" Hysteresis="0"/>'));		
					// Line 6
					strcat(pANSL_config, ADR('</PVS>'));		
					// Line 7
					strcat(pANSL_config, ADR('</Connection>'));	
				END_IF
			END_IF
			
			(********************************************************************)
			(*																	*)
			(*                   Communication to Engines						*)
			(*																	*)
			(********************************************************************)
			
			IF (bEng2EngComEnabled) THEN
				(* Add configured Engines to communication *)
				FOR x:=iEngNumMin TO iEngNumMax DO
					(* Check length of config object *)
					IF strlen(pANSL_config) > iANSL_config_length_max - 1000 THEN 
						iSTEP := DATAOBJ_ERROR;
						RETURN; 
					END_IF;
					
					IF (x <> iThisEngineNr) THEN
						(* Convert current asset numbers to strings *)
						strCurrentAssetNum 	:= '';
						strCurrentAssetSub 	:= '';
						strCurrentAssetIP 	:= '';
						itoa(x, ADR(strCurrentAssetNum));
						itoa(iEnginesSUB[x], ADR(strCurrentAssetSub));
						itoa(iEnginesIP[x], ADR(strCurrentAssetIP));
						
						//Line 1
						strcat(pANSL_config, ADR('<Connection ConnName="Engine'));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('" TargetAddr="192.168.'));
						strcat(pANSL_config, ADR(strCurrentAssetSub));
						strcat(pANSL_config, ADR('.'));
						strcat(pANSL_config, ADR(strCurrentAssetIP));
						strcat(pANSL_config, ADR('" AnslPort="11179" Timeout="5000" SendDelay="2" BfSize="65536" ConnMode="0" EnableSSL="1" SSLConfig="SSL_Eng'));
						strcat(pANSL_config, ADR(strThisEngineNr));
						strcat(pANSL_config, ADR('"> PW="'));
						strcat(pANSL_config, ADR(strAnsl_Com_Pw));
						strcat(pANSL_config, ADR('"'));
					
						// Line 2
						strcat(pANSL_config, ADR('<Diag ConnErr="HalIO::tDiagEngine['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('].Err" ConnPvWrite="HalIO::tDiagEngine['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('].PvWrite" ConnPvWriteErr="HalIO::tDiagEngine['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('].PvWriteErr" ConnPvReadErr="HalIO::tDiagEngine['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR('].PvReadErr"/>'));
						// Line 3		
						strcat(pANSL_config, ADR('<PVS>'));
						// Line 4		
						strcat(pANSL_config, ADR('<Read LocalPvName="HalIO::tPlantCom_E2E_In_100ms['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR(']" RemotePvName="HalIO::tPlantCom_E2E_Out_100ms" DefaultValue="0" SyncPv="0" RefreshRate="100" Hysteresis="0"/>'));
						// Line 5		
						strcat(pANSL_config, ADR('<Read LocalPvName="HalIO::tPlantCom_E2E_In_10ms['));
						strcat(pANSL_config, ADR(strCurrentAssetNum));
						strcat(pANSL_config, ADR(']" RemotePvName="HalIO::tPlantCom_E2E_Out_10ms" DefaultValue="0" SyncPv="0" RefreshRate="10" Hysteresis="0"/>'));		
						// Line 6
						strcat(pANSL_config, ADR('</PVS>'));		
						// Line 7
						strcat(pANSL_config, ADR('</Connection>'));	
					END_IF
				END_FOR
			END_IF
			
			(* ANSL Footer*)
			strcat(pANSL_config, ADR('</AnslClient>'));
			
			(* Reset Error bits and continue with the next step *)
			MM2VIS.tPlantComm.bCfg_Err 				:= FALSE;
			MM2VIS.tPlantComm.bCfg_OK 				:= FALSE;
			MM2VIS.tPlantComm.bCfg_Rst 				:= FALSE;
			iSTEP := PREP_CHECK_DATAOBJ_STATUS;
		PREP_CHECK_DATAOBJ_STATUS:
			(* Prepare DataObjInfo Function Block *)
			xDatObjInfo_Ansl_Cfg.enable 			:= TRUE;
			xDatObjInfo_Ansl_Cfg.pName 				:= ADR(strAnslDataObjName);
			iSTEP := CHECK_DATAOBJ_STATUS;
		CHECK_DATAOBJ_STATUS:
			(* Check if DataObj already exists or has another error *)
			xDatObjInfo_Ansl_Cfg();
			(* Data object already exists *)
			IF (xDatObjInfo_Ansl_Cfg.status = ERR_OK) THEN
				xDatObjDelete_Ansl_Cfg.enable 		:= TRUE;
				xDatObjDelete_Ansl_Cfg.ident 		:= xDatObjInfo_Ansl_Cfg.ident;
				iSTEP := DELETE_DATAOBJ;
			ELSIF (xDatObjInfo_Ansl_Cfg.status = doERR_MODULNOTFOUND) THEN
				xDatObjCreate_Ansl_Cfg.enable 		:= TRUE;
				xDatObjCreate_Ansl_Cfg.pName 		:= ADR(strAnslDataObjName);
				xDatObjCreate_Ansl_Cfg.pCpyData 	:= pANSL_config;
				xDatObjCreate_Ansl_Cfg.MemType 		:= doUSRROM;
				xDatObjCreate_Ansl_Cfg.len 			:= strlen(pANSL_config);
				iSTEP 								:= CREATE_DATAOBJ;
			ELSIF (xDatObjInfo_Ansl_Cfg.status <> ERR_FUB_BUSY) THEN
				iSTEP 							:= DATAOBJ_ERROR;
			END_IF;
		DELETE_DATAOBJ:
			(* Delete Dataobj *)
			xDatObjDelete_Ansl_Cfg();
			IF (xDatObjDelete_Ansl_Cfg.status = ERR_OK) THEN
				xDatObjCreate_Ansl_Cfg.enable		:= TRUE;
				iSTEP 								:= CREATE_DATAOBJ;
			ELSIF (xDatObjDelete_Ansl_Cfg.status <> ERR_FUB_BUSY) THEN
				iSTEP						 		:= DATAOBJ_ERROR;
			END_IF;
		CREATE_DATAOBJ:
			IF (xDatObjCreate_Ansl_Cfg.len = 0) THEN
				iSTEP := PREP_DATAOBJ;
				RETURN;
			END_IF
			xDatObjCreate_Ansl_Cfg();
			IF (xDatObjCreate_Ansl_Cfg.status = ERR_OK) THEN
				strANSL_config 					:= '';
				xANSLClientStart.enable 		:= TRUE;
				xANSLClientStart.dataObjName 	:= strAnslDataObjName;
				iSTEP 							:= START_ANSL_COM;
			ELSIF (xDatObjCreate_Ansl_Cfg.status <> ERR_FUB_BUSY) THEN
				iSTEP						 	:= DATAOBJ_ERROR;
			END_IF;
		START_ANSL_COM:
			(* Only start ANSL Communication after all Software modules are loaded and running *)
			xANSLClientStart();
			IF (xANSLClientStart.status = ERR_OK) THEN
				xDatObjCreate_Ansl_Cfg.enable := FALSE;
				xDatObjDelete_Ansl_Cfg.enable := FALSE;
				xDatObjInfo_Ansl_Cfg.enable 	:= FALSE;
				MM2VIS.tPlantComm.bCfg_OK 	:= TRUE;
				iSTEP := PREP_ANSL_DIAGNOSTICS;
			ELSIF (xANSLClientStart.status <> ERR_FUB_BUSY) THEN
				iSTEP 						:= ANSL_ERROR;
			END_IF
		STOP_ANSL_COM:
			// todo test behaviour 
			bPlantCommStopInProgress 			:= TRUE;
			xANSLClientStop.enable 				:= TRUE;
			xANSLClientStop.dataObjName 		:= strAnslDataObjName;
			xANSLClientStop();
			IF (xANSLClientStop.status = ERR_OK OR xANSLClientStop.status = asANSL_ERR_CLIENT_NOT_EXIST) THEN
				MM2VIS.tPlantComm.bCfg_OK 		:= FALSE;
				bPlantCommStopInProgress 		:= FALSE;
				(* Reset FUBs *)
				xANSLClientStart.dataObjName 	:= '';
				xANSLClientStart.enable			:= FALSE;
				xDatObjCreate_Ansl_Cfg.enable	:= FALSE;
				xDatObjCreate_Ansl_Cfg.len		:= 0;
				xDatObjCreate_Ansl_Cfg.pCpyData	:= 0;
				xDatObjInfo_Ansl_Cfg.enable		:= FALSE;
				xDatObjInfo_Ansl_Cfg.pName		:= 0;
				xDatObjDelete_Ansl_Cfg.enable	:= FALSE;
				xDatObjDelete_Ansl_Cfg.ident	:= 0;
				iSTEP := GET_MODULE_NR;
			ELSIF (xANSLClientStop.status <> ERR_FUB_BUSY) THEN
				iSTEP 							:= ANSL_ERROR;
			END_IF;
		PREP_ANSL_DIAGNOSTICS:
			iSTEP := ANSL_DIAGNOSTICS;
		ANSL_DIAGNOSTICS:
			(* Check for configuration changes *)
			IF (iEngNumMin <> Para.tPlantComm.iEng_Num_Min OR
				iEngNumMax <> Para.tPlantComm.iEng_Num_Max OR
				iMasNumMin <> Para.tPlantComm.iMas_Num_Min OR
				iMasNumMax <> Para.tPlantComm.iMas_Num_Max) THEN
				iSTEP := STOP_ANSL_COM;
			END_IF
			(* Evaluate Masters *)
			iNum_InterruptedMasters := 0;
			FOR x:=iMasNumMin TO iMasNumMax DO
				MM2VIS.tPlantComm.bMas_Ena[x] := tDiagMaster[x].Err = 0 AND tDiagMaster[x].PvReadErr = 0;
				IF (tDiagMaster[x].Err <> 0 OR tDiagMaster[x].PvReadErr <> 0) THEN
					iNum_InterruptedMasters := iNum_InterruptedMasters + 1;
				END_IF
			END_FOR
		
			(* Evaluate Engines *)
			iNum_InterruptedEngines := 0;
			FOR x:=iEngNumMin TO iEngNumMax DO
				IF (x = iThisEngineNr) THEN
					MM2VIS.tPlantComm.bEng_Ena[x] := TRUE;
				ELSE
					MM2VIS.tPlantComm.bEng_Ena[x] := tDiagEngine[x].Err = 0 AND tDiagEngine[x].PvReadErr = 0 AND x <> iThisEngineNr;
					IF (tDiagEngine[x].Err <> 0 OR tDiagEngine[x].PvReadErr <> 0) THEN
						iNum_InterruptedEngines := iNum_InterruptedEngines + 1;
					END_IF
				END_IF
			END_FOR
			
			(* Set warning variable *)
			bPlantComm_interrupted := iNum_InterruptedEngines <> 0 OR iNum_InterruptedMasters <> 0;
		
			(* Set/Unset GoodQual Values on connection interuptions/establishment *)
			FOR x:= iEngNumMin TO iEngNumMax DO
				IF (EDGENEG(MM2VIS.tPlantComm.bEng_Ena[x])) THEN
					FOR idx:=0 TO iDigArrayMax100ms DO
						tPlantCom_E2E_In_100ms[x].digitalSignals[idx].GoodQual := FALSE;
					END_FOR
					FOR idx:=0 TO iDigArrayMax10ms DO
						tPlantCom_E2E_In_10ms[x].digitalSignals[idx].GoodQual := FALSE;
					END_FOR
					FOR idx:=0 TO iAnaArrayMax100ms DO
						tPlantCom_E2E_In_100ms[x].analogSignals[idx].GoodQual := FALSE;
					END_FOR
					FOR idx:=0 TO iAnaArrayMax10ms DO
						tPlantCom_E2E_In_10ms[x].analogSignals[idx].GoodQual := FALSE;
					END_FOR
				END_IF
			END_FOR
			FOR x:= iMasNumMin TO iMasNumMax DO
				IF (EDGENEG(MM2VIS.tPlantComm.bMas_Ena[x])) THEN
					FOR idx:=0 TO iDigArrayMax100ms DO
						tPlantCom_M2E_In_100ms[x].digitalSignals[idx].GoodQual := FALSE;
					END_FOR
					FOR idx:=0 TO iDigArrayMax10ms DO
						tPlantCom_M2E_In_10ms[x].digitalSignals[idx].GoodQual := FALSE;
					END_FOR
					FOR idx:=0 TO iAnaArrayMax100ms DO
						tPlantCom_M2E_In_100ms[x].analogSignals[idx].GoodQual := FALSE;
					END_FOR
					FOR idx:=0 TO iAnaArrayMax10ms DO
						tPlantCom_M2E_In_10ms[x].analogSignals[idx].GoodQual := FALSE;
					END_FOR
				END_IF
			END_FOR
	END_CASE
END_PROGRAM
