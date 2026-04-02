(*******************************************************************************
AGGR: copy OUT PVs for module HalIO (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V3.99	14-06-2012	Weitzer, generated FOR modular software
V4.00	14-02-2014	Weitzer, change version number
V4.00.1	29.10.2014	Weitzer, set Pact to 0 if GCB is open and -10kW < P < 10kW
V4.03	11-02-2015	Weitzer, add OUT_HA.szEng_Motorversion
		20-04-2015	Weitzer, add MORIS safety loop to MM2VIS structure
		16-09-2015	Weitzer, add MM2VIS.rP_ActUnfilt[1] for hi-res trending
		21-09-2015	Weitzer, add rI_MaxL1..3 to OUT_HA for monitoring
V4.04	17-01-2017	Denk, add IPC status OUT variables
V4.04.1	23-02-2017	Weitzer, correct current dynamic calculation
V4.05	12-09-2017	Denk, add OUT_HA.bSimWinMOD_withoutBus_Active
		27-07-2017	Messner, CAN Diagnosis Variables added
		20-12-2017	Weitzer, change bus bar voltages to standard IO format	
		21-01-2018	Perktold,hardware operation mode switch added
		12.02.2018	lettenb. MM2VIS.rF_MMD_BusBar[] added
V4.05.1 14-02-2018	Weitzer, change TJ overview CAN diag. data to FAST comm.
V4.05.2 19-03-2018	Denk, WinMOD simulation ON/OFF logic added
V4.07.0	24-01-2019	Schmid, MM2VIS for MMD serial number added
V4.08	18-07-2019	Denk, IPC status logic changed because of new PPC3100 (new OUT_HA.iT_CFast2)
V4.11.0	18-03-2022	Perktold, tiTimeout von 2s auf 5s erhöht (erhöhte DGS Stabilität)
V4.12	28-10-2022	Weitzer, added auto detect multiplier for bus bar and synch voltages > 30kV
V4.14	19-11-2024	Farre,	 added auto detect multiplier for grid voltage (2024-236)

Instructions for use:
--------------------
-

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(* Visu out *)
	FOR ucCount := 1 TO 2 DO

		(* OUT VISU *)
		MM2VIS.rI_L1[ucCount] 			:= tI_L1[ucCount].Ai; 					(* current 1 *)
		MM2VIS.rI_L2[ucCount]			:= tI_L2[ucCount].Ai; 					(* current 2 *)
		MM2VIS.rI_L3[ucCount] 			:= tI_L3[ucCount].Ai; 					(* current 3 *)
		MM2VIS.rI_Dyn[ucCount]	 		:= UINT_TO_REAL(usIDyn[ucCount])/1000; 	(* current dynamic *)
		IF Para.rI_GenNom[ucCount] <> 0 THEN
			MM2VIS.rI_Dyn[ucCount] := UINT_TO_REAL(usIDyn[ucCount])/Para.rI_GenNom[ucCount]; 	(* current dynamic *)
		END_IF;		
		MM2VIS.rI_N[ucCount] 			:= INT_TO_REAL(ssIN[ucCount]); 			(* current neutral *)		
		IF ssSynchAngleDeviation[ucCount] > 1800 THEN 	(* angle deviation synchronization  +180° - -180° *)		
			MM2VIS.rAng_MMD_Diff[ucCount] 	:= INT_TO_REAL(ssSynchAngleDeviation[ucCount]-3600)/10; 
		ELSE
			MM2VIS.rAng_MMD_Diff[ucCount] 	:= INT_TO_REAL(ssSynchAngleDeviation[ucCount])/10; 			
		END_IF;
		
		(* visualisation of synchronization mode *)
		IF bSyncSlipMode[ucCount] THEN
			MM2VIS.iIdx_MMD_SynchMode[ucCount] := 1;
		ELSIF bSyncCheckMode[ucCount] THEN
			MM2VIS.iIdx_MMD_SynchMode[ucCount] := 2;
		ELSIF bSyncDeadBusMode[ucCount] THEN
			MM2VIS.iIdx_MMD_SynchMode[ucCount] := 3;
		ELSE
			MM2VIS.iIdx_MMD_SynchMode[ucCount] := 0;
		END_IF;	
				
		MM2VIS.rMMD_HW_Version[ucCount]	:= UINT_TO_REAL(usMMDSynchHWVariant[ucCount])/100;			(* program version MMD *)
		MM2VIS.rU_MMD_Diff[ucCount] 	:= INT_TO_REAL(ssSynchVoltDeviation[ucCount]) * rMul_MMD_U_Synch[ucCount]; 		(* votage deviation synchronization *)	
		sMMD_SerialNumber				:= UDINT_TO_STRING(ulMMDSerialNumber[ucCount]);
		MM2VIS.sMMD_SerialNumber[ucCount]	:= REPLACE(	IN1:= '00000000000', 						(* SerialNumber MMD *)
														IN2:= sMMD_SerialNumber,
														L:= LEN(sMMD_SerialNumber), P:= 11 - LEN(sMMD_SerialNumber) + 1);
		iMMD_ModuleID					:= usMMDModuleID[ucCount];
		IF iMMD_ModuleID <= 9999 THEN
			sMMD_ModuleID := UINT_TO_STRING(iMMD_ModuleID);
			sMMD_ModuleID := REPLACE(IN1:= '0000', IN2:= sMMD_ModuleID, L:= LEN(sMMD_ModuleID), P:= 4 - LEN(sMMD_ModuleID) + 1);
			MM2VIS.sMMD_SerialNumber[ucCount] := REPLACE(	IN1:= MM2VIS.sMMD_SerialNumber[ucCount], 				(* ModuleID MMD *)
															IN2:= sMMD_ModuleID,
															L:= 4, P:= 1);
		ELSE
			sMMD_ModuleID := '0000';
			FOR iIdx_ModuleID := 3 TO 0 BY -1 DO
				iMMD_ModuleID_Char	:= TRUNC(UINT_TO_REAL(iMMD_ModuleID)/16**iIdx_ModuleID);
				CASE iMMD_ModuleID_Char OF
					15:		sMMD_ModuleID	:= REPLACE(IN1:= sMMD_ModuleID, IN2:= 'F', L:= 1, P:= (4 - iIdx_ModuleID));
					14:		sMMD_ModuleID	:= REPLACE(IN1:= sMMD_ModuleID, IN2:= 'E', L:= 1, P:= (4 - iIdx_ModuleID));
					13:		sMMD_ModuleID	:= REPLACE(IN1:= sMMD_ModuleID, IN2:= 'D', L:= 1, P:= (4 - iIdx_ModuleID));
					12:		sMMD_ModuleID	:= REPLACE(IN1:= sMMD_ModuleID, IN2:= 'C', L:= 1, P:= (4 - iIdx_ModuleID));
					11:		sMMD_ModuleID	:= REPLACE(IN1:= sMMD_ModuleID, IN2:= 'B', L:= 1, P:= (4 - iIdx_ModuleID));
					10:		sMMD_ModuleID	:= REPLACE(IN1:= sMMD_ModuleID, IN2:= 'A', L:= 1, P:= (4 - iIdx_ModuleID));
					ELSE	sMMD_Temp		:= INT_TO_STRING(iMMD_ModuleID_Char);
							sMMD_ModuleID	:= REPLACE(IN1:= sMMD_ModuleID, IN2:= sMMD_Temp, L:= 1, P:= (4 - iIdx_ModuleID));
				END_CASE;
				iMMD_ModuleID		:= iMMD_ModuleID MOD REAL_TO_UINT(16**iIdx_ModuleID);
			END_FOR;
			MM2VIS.sMMD_SerialNumber[ucCount] := REPLACE(IN1:= MM2VIS.sMMD_SerialNumber[ucCount], IN2:= sMMD_ModuleID, L:= 4, P:= 1);
		END_IF;
		
		MM2VIS.rU_Bus_L1_2[ucCount] 	:= tU_Bus_L1_2[ucCount].Ai * rMul_MMD_U_Bus[ucCount]; 		(* bus bar voltage 1 2 *)
		MM2VIS.rU_Bus_L2_3[ucCount] 	:= tU_Bus_L2_3[ucCount].Ai * rMul_MMD_U_Bus[ucCount]; 		(* bus bar voltage 2 3 *)
		MM2VIS.rU_Bus_L3_1[ucCount] 	:= tU_Bus_L3_1[ucCount].Ai * rMul_MMD_U_Bus[ucCount]; 		(* bus bar voltage 3 1 *)
		MM2VIS.rU_Bus_L1N[ucCount] 		:= tU_Bus_L1N[ucCount].Ai  * rMul_MMD_U_Bus[ucCount]; 		(* bus bar voltage 1 *)
		MM2VIS.rU_Bus_L2N[ucCount] 		:= tU_Bus_L2N[ucCount].Ai  * rMul_MMD_U_Bus[ucCount]; 		(* bus bar voltage 2 *)
		MM2VIS.rU_Bus_L3N[ucCount] 		:= tU_Bus_L3N[ucCount].Ai  * rMul_MMD_U_Bus[ucCount]; 		(* bus bar voltage 3 *)	

		(* OUT HAL_IO VIS *)
		MM2VIS.rPF_Act[ucCount]			:= tPF_Act[ucCount].Ai; 									(* power factor *)		
		MM2VIS.rI_Avg[ucCount] 			:= tI_Avg[ucCount].Ai;										(* current average *)
		MM2VIS.rP_Act[ucCount]			:= tP_Act[ucCount].Ai * rMul_MMD_U_Gen[ucCount]; 			(*  actual electric power [kW] *)
		MM2VIS.rP_ActUnfilt[ucCount]	:= tP_Act[ucCount].Unfilt * rMul_MMD_U_Gen[ucCount];		(*  actual unfiltered electric power [kW] *)		
		(* set to 0 kW when generator switch is open *)
		IF NOT tGCB_On.Di THEN                                                                         
			IF (MM2VIS.rP_Act[1] > -10) AND (MM2VIS.rP_Act[1] < 10) THEN	(* and actual power within +/- 10 kW *)
				MM2VIS.rP_Act[1]       := 0;
				MM2VIS.rP_ActUnfilt[1] := 0;
	 		END_IF;
		END_IF;		
					
		MM2VIS.rQ_Act[ucCount]			:= tQ_Act[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount];		(* reactive power [kVar] *)
		MM2VIS.rS_Act[ucCount]			:= tS_Act[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount];		(* power apperent *)
		MM2VIS.rU_MMD_Synch1[ucCount] 	:= tU_MMD_Synch1[ucCount].Ai * rMul_MMD_U_Synch[ucCount];	(* synchronization voltage 1 *)
		MM2VIS.rU_MMD_Synch2[ucCount] 	:= tU_MMD_Synch2[ucCount].Ai * rMul_MMD_U_Synch[ucCount];	(* synchronization voltage 2 *) 		
		MM2VIS.rU_Avg[ucCount] 			:= tU_Avg[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount];		(* voltage average *)
		MM2VIS.rU_L1N[ucCount]			:= tU_L1N[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount];		(* voltage 1 *)
		MM2VIS.rU_L1L2[ucCount]			:= tU_L1L2[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount];		(* voltage 12 *)
		MM2VIS.rU_L2N[ucCount]			:= tU_L2N[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount];		(* voltage 2 *)
		MM2VIS.rU_L2L3[ucCount]			:= tU_L2L3[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount];		(* voltage 23 *)
		MM2VIS.rU_L3N[ucCount]			:= tU_L3N[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount];		(* voltage 3 *)
		MM2VIS.rU_L3L1[ucCount]			:= tU_L3L1[ucCount].Ai 		 * rMul_MMD_U_Gen[ucCount]; 	(* voltage 31 *)
		MM2VIS.rF_MMD[ucCount] 			:= tF_MMD[ucCount].Ai;										(* frequency multi measure device *)
		MM2VIS.rF_MMD_Synch1[ucCount] 	:= tF_MMD_Synch1[ucCount].Ai; 								(* Frequency Sync-network 1 *)
		MM2VIS.rF_MMD_Synch2[ucCount] 	:= tF_MMD_Synch2[ucCount].Ai; 								(* Frequency Sync-network 2 *)	
		MM2VIS.rF_MMD_BusBar[ucCount] 	:= tF_MMD_BusBar[ucCount].Ai; 								(* frequency bus bar *)
		MM2VIS.rMMD_FW_Version[ucCount]	:= DINT_TO_REAL(tMMD_FW_Version[ucCount].Ai)/100;			(*program version MMD firmware*)

		(* feedback synch DO *)
		TOF_SyImp[ucCount](IN := bMMD_SynchDO[ucCount],PT := T#2s);
		MM2VIS.bMMD_SynchDO[ucCount] := TOF_SyImp[ucCount].Q;						
		
		(* U diff bar graphs MAX value (limit times 2) *)
		MM2VIS.rUDiffMaxScale[ucCount] := Para.rU_DiffMax[ucCount] * Para.rU_SyncNom[ucCount] * 2;
		
		(* f diff bar graphs MIN and MAX value (limit times 2) *)					
		MM2VIS.rF_DiffMaxScale[ucCount] := Para.rF_DiffMax[ucCount] * 2;
		MM2VIS.rF_DiffMinScale[ucCount] := Para.rF_DiffMin[ucCount] * 2;

		(* copy maximum current values to out structure *)
		OUT_HA.rI_MaxL1[ucCount] := MM2VIS.rI_MaxL1[ucCount];
		OUT_HA.rI_MaxL2[ucCount] := MM2VIS.rI_MaxL2[ucCount];
		OUT_HA.rI_MaxL3[ucCount] := MM2VIS.rI_MaxL3[ucCount];
		
	END_FOR;

	
	(* Status MORIS safety loop for visualization *)
	MM2VIS.bMO_SaftyLoop := tMO_SaftyLoop.Di;
	
	
	(* gasmixer stepper card B&R X20 SM1426 *)
	OUT_HA.iGM1_MStepActPos; 	(*gasmixer 1 - Actual position from SM1426-Module [Microsteps]*)	(*OldName: slGM1_MStepActPos_TC1; Cycle: 5;*)
	OUT_HA.iGM1_Status;			(*gasmixer 1 - Status Word from SM1426-Module*)						(*OldName: usGM1_Status_TC1; Cycle: 5;*)
	OUT_HA.iGM2_MStepActPos;	(*gasmixer 2 - Actual position from SM1426-Module [Microsteps]*)	(*OldName: slGM2_MStepActPos_TC1; Cycle: 5;*)
	OUT_HA.iGM2_Status;			(*gasmixer 2 - Status Word from SM1426-Module*)						(*OldName: usGM2_Status_TC1; Cycle: 5;*)		
	
	(* Copy motor version string to out structure *)
	OUT_HA.szEng_Motorversion := Para.szEng_Motorversion;
	
	(* Copy order ID string to out structure *)
	OUT_HA.szOrderID := Para.szOrderID;
	
	(* Copy order ID string to out structure *)
	OUT_HA.iEngID := VIS2MM.iEngID;
	
	
	(* IPC status *)
		
	OUT_HA.iSerialNumber_CPU;	(*Serial number CPU*)
	OUT_HA.iModulID_CPU;		(*Modul ID CPU*) 
	OUT_HA.iPowerOnCycles;		(*Power On cycles CPU*) 
	OUT_HA.iOperatingHours_CPU; (*Operating hours CPU*) 
	OUT_HA.iBatterieStatus; 	(*Batterie Status IPC*) 
	OUT_HA.iT_CPU; 				(*Temperature CPU*) 
	OUT_HA.iT_CPU_PLC; 			(*Temperature PLC X20CP368xX CPU*) 
	OUT_HA.iT_Board; 			(*Temperature Board*) 
	OUT_HA.iT_Chipset;			(*Temperature Chipset*) 
	OUT_HA.iT_PS; 				(*Temperature IPC board power supply*) 
	OUT_HA.iT_CFast; 			(*Temperature IPC CFast*)
	OUT_HA.iT_CFast2; 			(*Temperature IPC CFast2*)
	
	(* WinMOD simulation for IPC status *)		
	IF OUT_HA.bSimWinMOD_Active THEN
		OUT_HA.iBatterieStatus := TRUE;	
	END_IF;
	
	(* WinMOD simulation with/without bus hardware *)		
	OUT_HA.bSimWinMOD_withoutBus_Active; 	(* TRUE = without bus hardware *)
	
	(* WinMOD simulation ON/OFF *)
	xTON_WatchdogSIM2AR0(IN:= NOT bWatchdogSIM2AR, PT:= tiTimeout);
	xTON_WatchdogSIM2AR1(IN:= bWatchdogSIM2AR, PT:= tiTimeout);
	IF (xTON_WatchdogSIM2AR0.Q OR xTON_WatchdogSIM2AR1.Q) THEN 
		OUT_HA.bSimWinMOD_Active := FALSE;
	ELSE
		OUT_HA.bSimWinMOD_Active := TRUE;	
	END_IF;
	
	(* Status CAN BUS for Visualization *) 
	MM2VIS.iCANopen_CMS_status 	:= CANopen_CMS.status;
	MM2VIS.iCANopen_CMS_info 	:= CANopen_CMS.info;
	MM2VIS.iCMSmain_Init_status	:= MAX(CMSmain_Init.status, CMSmain_Init2.status);
	
	
	(* Status CAN IC900 all Modules for Visualization *) 
	MM2VIS.iIC900_AllErrEventMax 	:= IN_HA.iE_IgnStat;
	MM2VIS.iIC900_AllErrCount 		:= IN_HA.iIC900CommErrCount;
	MM2VIS.iIC900_AllErrMax 		:= ucIC900CommErrMax;
	MM2VIS.iIC900_AllPhaseCnt 		:= usIC900PhaseCnt;
	MM2VIS.iIC900_AllErrAvg			:= usIC900CommErrAvg;	 
	
	
	(* Status CAN Monic all Modules for Visualization *) 
	MM2VIS.iMonic_AllErrEventMax 	:= IN_HA.iEMonStatus;
	MM2VIS.iMonic_AllErrCount 		:= IN_HA.iMonicCommErrCount;
	MM2VIS.iMonic_AllErrMax 		:= ucMonicCommErrMax;
	MM2VIS.iMonic_AllPhaseCnt 		:= usMonicPhaseCnt;
	MM2VIS.iMonic_AllErrAvg			:= usMonicCommErrAvg;	 
	
	
	(* Status CAN TecJet all Modules for Visualization - SLOW monitoring not needed *) 
//	MM2VIS.iTecJet_AllErrEventMax 	:= ucTecJetCommErrEventMax;
//	MM2VIS.iTecJet_AllErrCount 		:= IN_HA.iTecJetCommErrCount;
//	MM2VIS.iTecJet_AllErrSlowMax 	:= ucTecJetCommErrSlowMax;
//	MM2VIS.iTecJet_AllSlowPhaseCnt 	:= usTecJetSlowPhaseCnt;
//	MM2VIS.iTecJet_AllErrSlowAvg	:= usTecJetCommErrSlowAvg;	 
	
	(* Status CAN TecJet individual Modules for Visualization *)
	MM2VIS.iTecJet_AllErrEventMax 	:= 0;
	MM2VIS.iTecJet_AllErrCount 		:= 0;
	MM2VIS.iTecJet_AllErrSlowMax 	:= 0;
	MM2VIS.iTecJet_AllSlowPhaseCnt 	:= 0;
	MM2VIS.iTecJet_AllErrSlowAvg	:= 0;
	FOR ucLoopCnt := 1 TO 4 DO
		MM2VIS.iTecJet_ErrEventMax[ucLoopCnt] 	:= IN_HA.tE_TEC[ucLoopCnt].Contr[0];
		MM2VIS.iTecJet_ErrMaxCur[ucLoopCnt]		:= IN_HA.iTecErrCnt[ucLoopCnt];
		MM2VIS.iTecJet_ErrMax[ucLoopCnt] 		:= usTecJetCommErrFastMax[ucLoopCnt];
		MM2VIS.iTecJet_PhaseCnt[ucLoopCnt] 		:= usTecJetFastPhaseCnt[ucLoopCnt];
		MM2VIS.iTecJet_ErrAvgCnt[ucLoopCnt] 	:= usTecJetCommErrFastAvg[ucLoopCnt];

		MM2VIS.iTecJet_AllErrEventMax 	:= MAX(MM2VIS.iTecJet_AllErrEventMax , MM2VIS.iTecJet_ErrEventMax[ucLoopCnt]);
		MM2VIS.iTecJet_AllErrCount 		:= MAX(MM2VIS.iTecJet_AllErrCount    , MM2VIS.iTecJet_ErrMaxCur[ucLoopCnt]);
		MM2VIS.iTecJet_AllErrSlowMax 	:= MAX(MM2VIS.iTecJet_AllErrSlowMax  , MM2VIS.iTecJet_ErrMax[ucLoopCnt]);
		MM2VIS.iTecJet_AllSlowPhaseCnt 	:= MAX(MM2VIS.iTecJet_AllSlowPhaseCnt, MM2VIS.iTecJet_PhaseCnt[ucLoopCnt]);
		MM2VIS.iTecJet_AllErrSlowAvg	:= MAX(MM2VIS.iTecJet_AllErrSlowAvg  , MM2VIS.iTecJet_ErrAvgCnt[ucLoopCnt]);	
	END_FOR;
	
	
	(* Status CAN KLS98 all Modules for Visualization *)
	MM2VIS.iKLS98_AllErrEventMax 	:= ucKLS98CommErrEventMax;
	MM2VIS.iKLS98_AllErrMaxCur 		:= ucKLS98CommErrMaxCur;
	MM2VIS.iKLS98_AllErrMax 		:= ucKLS98CommErrMaxAll;
	MM2VIS.iKLS98_AllPhaseCntMax 	:= usKLS98PhaseCntMax;
	MM2VIS.iKLS98_AllErrAvgMax		:= usKLS98CommErrAvgMax;
	
	(* Status CAN KLS98 individual Modules for Visualization *)
	FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
		MM2VIS.iKLS98_ErrEventMax[ucLoopCnt] 	:= IN_HA.tE_KLS[ucLoopCnt].conf[99];
		MM2VIS.iKLS98_ErrMaxCur[ucLoopCnt]		:= IN_HA.iKLS98CommErrCount[ucLoopCnt];
		MM2VIS.iKLS98_ErrMax[ucLoopCnt] 		:= ucKLS98CommErrMax[ucLoopCnt];
		MM2VIS.iKLS98_PhaseCnt[ucLoopCnt] 		:= usKLS98PhaseCnt[ucLoopCnt];
		MM2VIS.iKLS98_ErrAvgCnt[ucLoopCnt] 		:= usKLS98CommErrAvg[ucLoopCnt];
	END_FOR;
	
	
	(* Status CAN SAFI all Modules for Visualization *) 
	MM2VIS.iSAFI_AllErrEventMax := ucSAFICommErrEventMax;
	MM2VIS.iSAFI_AllErrMaxCur 	:= usSAFICommErrMaxCur;
	MM2VIS.iSAFI_AllErrMax		:= usSAFICommErrMaxAll;
	MM2VIS.iSAFI_AllPhaseCntMax	:= usSAFIPhaseCntMax;
	MM2VIS.iSAFI_AllErrAvgMax	:= usSAFICommErrAvgMaxCnt;
	
	(* Status CAN SAFI individual Modules for Visualization *)
	FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder/2 DO
		MM2VIS.iSAFI_ErrEventMax[ucLoopCnt] := IN_HA.tE_SAFI[ucLoopCnt].sdata[1];
		MM2VIS.iSAFI_ErrMaxCur[ucLoopCnt]	:= IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100;
		MM2VIS.iSAFI_ErrMax[ucLoopCnt] 		:= usSAFICommErrMax[ucLoopCnt];
		MM2VIS.iSAFI_PhaseCnt[ucLoopCnt] 	:= usSAFIPhaseCnt[ucLoopCnt];
		MM2VIS.iSAFI_ErrAvgCnt[ucLoopCnt] 	:= usSAFICommErrAvgCnt[ucLoopCnt];
	END_FOR;

	(* H A R D W A R E   S W I T C H E S *)
	(* GoodQual for HMI *)
	OUT_HA.tHW_Switches.bGoodQual	:=  tDI_OMS_Man.GoodQual AND tDI_OMS_Auto.GoodQual AND tDI_RMS_On.GoodQual AND tDI_RMS_Remote.GoodQual AND tDI_SyOMS_Man.GoodQual AND tDI_SyOMS_Auto.GoodQual;
	(* Hardware operation mode switch *)
	xTON_OMS.IN := NOT tDI_OMS_Man.Di AND NOT tDI_OMS_Auto.Di;
	xTON_OMS();
	IF NOT tDI_OMS_Man.Di AND NOT tDI_OMS_Auto.Di AND xTON_OMS.Q THEN
		OUT_HA.tHW_Switches.iIdx_OMS_Hw 	:= 0;
	ELSIF tDI_OMS_Man.Di AND NOT tDI_OMS_Auto.Di THEN
		OUT_HA.tHW_Switches.iIdx_OMS_Hw 	:= 1;
	ELSIF NOT tDI_OMS_Man.Di AND tDI_OMS_Auto.Di THEN
		OUT_HA.tHW_Switches.iIdx_OMS_Hw 	:= 2;
	END_IF;
	
	(* Hardware request mode switch *)
	xTON_RMS.IN := NOT tDI_RMS_On.Di AND NOT tDI_RMS_Remote.Di;
	xTON_RMS();
	IF NOT tDI_RMS_On.Di AND NOT tDI_RMS_Remote.Di AND xTON_RMS.Q THEN
		OUT_HA.tHW_Switches.iIdx_RMS_Hw 	:= 0;
	ELSIF tDI_RMS_On.Di AND NOT tDI_RMS_Remote.Di THEN
		OUT_HA.tHW_Switches.iIdx_RMS_Hw 	:= 1;
	ELSIF NOT tDI_RMS_On.Di AND tDI_RMS_Remote.Di THEN
		OUT_HA.tHW_Switches.iIdx_RMS_Hw 	:= 2;
	END_IF;	

	(* Hardware synchronisation operation mode switch *)
	xTON_SyOMS.IN := NOT tDI_SyOMS_Man.Di AND NOT tDI_SyOMS_Auto.Di;
	xTON_SyOMS();
	IF NOT tDI_SyOMS_Man.Di AND NOT tDI_SyOMS_Auto.Di AND xTON_SyOMS.Q THEN
		OUT_HA.tHW_Switches.iIdx_SyOMS_Hw 	:= 0;
	ELSIF tDI_SyOMS_Man.Di AND NOT tDI_SyOMS_Auto.Di THEN
		OUT_HA.tHW_Switches.iIdx_SyOMS_Hw 	:= 1;
	ELSIF NOT tDI_SyOMS_Man.Di AND tDI_SyOMS_Auto.Di THEN
		OUT_HA.tHW_Switches.iIdx_SyOMS_Hw 	:= 2;
	END_IF;	

	(* MMU Information for custom module (bus applications) *)
	OUT_HA.rI_Dyn 				:=	MM2VIS.rI_Dyn;
	OUT_HA.rI_GenUnbalanced 	:=	MM2VIS.rI_GenUnbalanced;
	OUT_HA.rU_MMD_Diff 			:=	MM2VIS.rU_MMD_Diff;
	OUT_HA.iIdx_MMD_SynchMode 	:=	MM2VIS.iIdx_MMD_SynchMode;

END_PROGRAM
