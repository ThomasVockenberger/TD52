(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: HAL_IO
 * File: HAL_IO.typ
 * Author: 105046866
 * Created: August 23, 2011
 ********************************************************************
 * Data types of package HAL_IO
 ********************************************************************)

TYPE
	tVIS2MM : 	STRUCT 
		rP_WorkAct : ARRAY[0..2]OF REAL; (* counter for last produced work  *) (* OldName:slWorkAct; Cycle: *)
		rQ_WorkReac : ARRAY[0..2]OF REAL; (* counter last reactive engine work *) (* OldName:slWorkReac; Cycle: *)
		rP_WorkActRet : ARRAY[0..2]OF REAL; (* counter for last received work  *) (* OldName:slWorkActRet; Cycle: *)
		rQ_WorkReacRet : ARRAY[0..2]OF REAL; (* counter last received reactive engine work  *) (* OldName:slWorkReacRet; Cycle: *)
		bMMD2_Reset_Vis : BOOL; (* Reset of saved max values of MMDsynch 2 from visualization *) (* OldName:bResetMMU2Vis; Cycle: *)
		iEngID : DINT; (*Para: engine ID number*) (*OldName:new PV; Cycle: *)
		bCANCntReset : BOOL; (* CAN error counter value reset *)
		bMMD_UnbLoadReset : BOOL; (*Unbalanced load meter counter reset*) (*OldName:new PV; Cycle:*)
		tPlantComm : tPlantComm_VIS2MM; (*Datapoints for the Plant Communication*)
	END_STRUCT;
	tMM2VIS : 	STRUCT 
		rI_MaxL1 : ARRAY[0..2]OF REAL; (* max. generator current phase 1 [A]  *) (* OldName:ssIMaxL1; Cycle: *)
		rI_MaxL2 : ARRAY[0..2]OF REAL; (* max. generator current phase 2 [A]  *) (* OldName:ssIMaxL2; Cycle: *)
		rI_MaxL3 : ARRAY[0..2]OF REAL; (* max. generator current phase 3 [A]  *) (* OldName:ssIMaxL3; Cycle: *)
		rP_ActMax : ARRAY[0..2]OF REAL; (* max. electric power [kW] *) (* OldName:ssPActMax; Cycle: *)
		rI_NMax : ARRAY[0..2]OF REAL; (* max. neutral current [A]  *) (* OldName:ssINMax; Cycle: *)
		rI_GenUnbalanced : ARRAY[0..2]OF REAL; (* unbalanced generator current [1/10 %]  *) (* OldName:ssIGenUnbalanced; Cycle: *)
		rF_MMD : ARRAY[0..2]OF REAL; (* frequency multi measure device *) (* OldName:ssFreq; Cycle: *)
		rF_MMD_Diff : ARRAY[0..2]OF REAL; (* frequency differenz system 1 / 2 *) (* OldName:ssFreqDiff; Cycle: *)
		rF_MMD_Synch1 : ARRAY[0..2]OF REAL; (* frequency sync-system 1  *) (* OldName:usSynch1Frequency; Cycle: *)
		rF_MMD_Synch2 : ARRAY[0..2]OF REAL; (* frequency sync-system 2 *) (* OldName:usSynch2Frequency; Cycle: *)
		rF_MMD_BusBar : ARRAY[0..2]OF REAL; (* frequency bus bar *) (* OldName:newPv; Cycle: *)
		rI_L1 : ARRAY[0..2]OF REAL; (* current 1 *) (* OldName:ssIL1; Cycle: *)
		rI_L2 : ARRAY[0..2]OF REAL; (* current 2 *) (* OldName:ssIL2; Cycle: *)
		rI_L3 : ARRAY[0..2]OF REAL; (* current 3 *) (* OldName:ssIL3; Cycle: *)
		rI_Avg : ARRAY[0..2]OF REAL; (* current average *) (* OldName:ssIAvg; Cycle: *)
		rI_Dyn : ARRAY[0..2]OF REAL; (* current dynamic *) (* OldName:usIDyn; Cycle: *)
		rI_N : ARRAY[0..2]OF REAL; (* current neutral *) (* OldName:ssIN; Cycle: *)
		rP_Act : ARRAY[0..2]OF REAL; (* power active */all *) (* OldName:ssPAct; Cycle: *)
		rP_ActUnfilt : ARRAY[0..2]OF REAL; (* power active */all *) (* OldName:ssPAct; Cycle: *)
		rS_Act : ARRAY[0..2]OF REAL; (* power apperent *) (* OldName:ssPApper; Cycle: *)
		rQ_Act : ARRAY[0..2]OF REAL; (* power reactive *) (* OldName:ssPReac; Cycle: *)
		rPF_Act : ARRAY[0..2]OF REAL; (* power factor *) (* OldName:ssCosPhi; Cycle: *)
		rU_L1N : ARRAY[0..2]OF REAL; (* voltage 1 *) (* OldName:ssUL1N; Cycle: *)
		rU_L1L2 : ARRAY[0..2]OF REAL; (* voltage 12 *) (* OldName:ssUL1L2; Cycle: *)
		rU_L2N : ARRAY[0..2]OF REAL; (* voltage 2 *) (* OldName:ssUL2N; Cycle: *)
		rU_L2L3 : ARRAY[0..2]OF REAL; (* voltage 23 *) (* OldName:ssUL2L3; Cycle: *)
		rU_L3N : ARRAY[0..2]OF REAL; (* voltage 3 *) (* OldName:ssUL3N; Cycle: *)
		rU_L3L1 : ARRAY[0..2]OF REAL; (* voltage 31 *) (* OldName:ssUL3L1; Cycle: *)
		rU_Avg : ARRAY[0..2]OF REAL; (* voltage average *) (* OldName:ssUAvg; Cycle: *)
		rAng_MMD_Diff : ARRAY[0..2]OF REAL; (* angle deviation synchronization *) (* OldName:ssSynchAngleDeviation; Cycle: *)
		iIdx_MMD_SynchMode : ARRAY[0..2]OF INT; (* synchronization mode *) (* OldName:usVisSynchMode; Cycle: *)
		rMMD_HW_Version : ARRAY[0..2]OF REAL; (* program version MMD *) (* OldName:usMMUSynchHWVariant; Cycle: *)
		rMMD_FW_Version : ARRAY[0..2]OF REAL; (* program version MMD firmware *) (* OldName:usMMUSynchFWVers; Cycle: *)
		rU_MMD_Diff : ARRAY[0..2]OF REAL; (* votage deviation synchronization *) (* OldName:ssSynchVoltDeviation; Cycle: *)
		rU_MMD_Synch1 : ARRAY[0..2]OF REAL; (* synchronization voltage 1 *) (* OldName:ssSynch1Volt; Cycle: *)
		rU_MMD_Synch2 : ARRAY[0..2]OF REAL; (* synchronization voltage 2 *) (* OldName:ssSynch2Volt; Cycle: *)
		rU_Bus_L1_2 : ARRAY[0..2]OF REAL; (* bus bar voltage 1 2 *) (* OldName:ssBusVoltPh1_2; Cycle: *)
		rU_Bus_L2_3 : ARRAY[0..2]OF REAL; (* bus bar voltage 2 3 *) (* OldName:ssBusVoltPh2_3; Cycle: *)
		rU_Bus_L3_1 : ARRAY[0..2]OF REAL; (* bus bar voltage 3 1 *) (* OldName:ssBusVoltPh3_1; Cycle: *)
		rU_Bus_L1N : ARRAY[0..2]OF REAL; (* bus bar voltage 1 *) (* OldName:ssBusVoltPh1_N; Cycle: *)
		rU_Bus_L2N : ARRAY[0..2]OF REAL; (* bus bar voltage 2 *) (* OldName:ssBusVoltPh2_N; Cycle: *)
		rU_Bus_L3N : ARRAY[0..2]OF REAL; (* bus bar voltage 3 *) (* OldName:ssBusVoltPh3_N; Cycle: *)
		bMMD_SynchDO : ARRAY[0..2]OF BOOL; (* feedback synch DO *) (* OldName:new PV; Cycle: *)
		bMsg3311 : BOOL; (* IO Channel Failure *) (* OldName:bAllModulesOK; Cycle: *)
		bMsg2399 : BOOL; (* A2399 - Shut down test bench priority 2 *)
		bMsg2400 : BOOL; (* A2400 - Shut down test bench priority 3 *)
		bMsg9400 : BOOL; (* W9400 - Warning test bench *)
		bMsg9384 : BOOL; (*Plant Communication Configuration failed*)
		bMsg9386 : BOOL; (*Plant Communication Interrupted*)
		bMsg9391 : BOOL; (*Plant Communication force active*)
		rUDiffMaxScale : ARRAY[0..2]OF REAL; (* Max scale value for voltage difference for synchronization *) (* OldName:new PV; Cycle: *)
		rF_DiffMaxScale : ARRAY[0..2]OF REAL; (* Max scale value for  frequence difference for synchronization *) (* OldName:new PV; Cycle: *)
		rF_DiffMinScale : ARRAY[0..2]OF REAL; (* Min scale value for  frequence difference for synchronization *) (* OldName:new PV; Cycle: *)
		bMO_SaftyLoop : BOOL; (* MORIS Safety loop signal *) (* OldName:new PV; Cycle: *)
		iCAN_HW_Slot : INT; (* CAN Module Socket Position Index *)
		sCAN_HW_WG : STRING[50]; (* Slot CAN Module - Wastegate actuators*)
		sCAN_HW_NOxS_IF1 : STRING[50]; (* Slot CAN Module - NOx sensor interface 1*)
		sCAN_HW_NOxS_IF2 : STRING[50]; (* Slot CAN Module - NOx sensor interface 2*)
		sCAN_HW_NOxS_IF3 : STRING[50]; (* Slot CAN Module - NOx sensor interface 3*)
		sCAN_HW_Slot_IPC : STRING[50]; (* Slot CAN Module - IPC PPC900 *)
		sCAN_HW_Slot_IPC_CMaU : STRING[50]; (* Slot CAN Module - IPC CM&U *)
		sCAN_HW_Slot_IPC_GE_IP : STRING[50]; (* Slot CAN Module - IPC GE-IP *)
		sCAN_HW_Slot_IPC_J920 : STRING[50]; (* Slot CAN Module - IPC J920 *)
		sCAN_HW_Slot_IPC_GE_IP_J920 : STRING[50]; (* Slot CAN Module - IPC GE-IP J920 *)
		sCAN_HW_Slot_IPC_3100 : STRING[50]; (* Slot CAN Module - IPC PPC3100 *)
		sCAN_HW_Slot_IPC_3100_J920 : STRING[50]; (* Slot CAN Module - IPC PPC3100 J920 *)
		sCAN_HW_Slot_X20CP368xX : STRING[50]; (* Slot CAN Module - X20CP368xX *)
		sCAN_HW_Slot_X20CP368xX_J920 : STRING[50]; (* Slot CAN Module - X20CP368xX J920 *)
		iCANopen_CMS_status : UINT; (* CAN Module Open CMS Status *)
		iCANopen_CMS_info : UINT; (* CAN Module Open CMS Info *)
		iCANopen_WG_status : UINT; (* CAN open status - Wastegate actuators*)
		iCANopen_NOxS_IF1_status : UINT; (* CAN open status - NOx sensor interface 1*)
		iCANopen_NOxS_IF2_status : UINT; (* CAN open status - NOx sensor interface 2*)
		iCANopen_NOxS_IF3_status : UINT; (* CAN open status - NOx sensor interface 3 *)
		iCMSmain_Init_status : UINT; (* CAN Module Main Init Status *)
		iSAFI_AllErrEventMax : UINT; (* SAFI All Modules Communication Error Event Max *)
		iSAFI_AllErrMaxCur : UINT; (* SAFI All Modules Communication Error Max Current *)
		iSAFI_AllErrMax : UINT; (* SAFI All Modules Communication Error Max All *)
		iSAFI_AllPhaseCntMax : UINT; (* SAFI All Modules Phase Counter Max *)
		iSAFI_AllErrAvgMax : UINT; (* SAFI All Modules Communication Error Average *)
		iSAFI_ErrEventMax : ARRAY[0..12]OF UINT; (* SAFI Communication Error Event Max *)
		iSAFI_ErrMaxCur : ARRAY[0..12]OF DINT; (* SAFI Communication Error Max Current *)
		iSAFI_ErrMax : ARRAY[0..12]OF UINT; (* SAFI Communication Error Max All *)
		iSAFI_PhaseCnt : ARRAY[0..12]OF UINT; (* SAFI Communication Phase Count *)
		iSAFI_ErrAvgCnt : ARRAY[0..12]OF UINT; (* SAFI Communication Error Average Count per Hour *)
		iTecJet_AllErrEventMax : UINT; (* TecJet All Modules Communication Error Event Max *)
		iTecJet_AllErrCount : UINT; (* TecJet All Modules Communication Error Count *)
		iTecJet_AllErrSlowMax : UINT; (* TecJet All Modules Communication Error Slow Max *)
		iTecJet_AllSlowPhaseCnt : UINT; (* TecJet All Modules Slow Phase Count *)
		iTecJet_AllErrSlowAvg : UINT; (* TecJet All Modules Communication Error Average *)
		iTecJet_ErrEventMax : ARRAY[0..4]OF UINT; (* TecJet Communication Error Event Max *)
		iTecJet_ErrMaxCur : ARRAY[0..4]OF UINT; (* TecJet Communication Error Max Current *)
		iTecJet_ErrMax : ARRAY[0..4]OF UINT; (* TecJet Communication Error Max All *)
		iTecJet_PhaseCnt : ARRAY[0..4]OF UINT; (* TecJet Communication Phase Count *)
		iTecJet_ErrAvgCnt : ARRAY[0..4]OF UINT; (* TecJet Communication Error Average Count per hour *)
		iKLS98_AllErrEventMax : UINT; (* KLS98 All Modules Communication Error Event Max *)
		iKLS98_AllErrMaxCur : UINT; (* KLS98 All Modules Communication Error Max Current *)
		iKLS98_AllErrMax : UINT; (* KLS98 All Modules Communication Error Max *)
		iKLS98_AllPhaseCntMax : UINT; (* KLS98 All Modules Phase Count Max *)
		iKLS98_AllErrAvgMax : UINT; (* KLS98 All Modules Communication Error Average Max *)
		iKLS98_ErrEventMax : ARRAY[0..24]OF UINT; (* KLS98 Communication Error Event Max *)
		iKLS98_ErrMaxCur : ARRAY[0..24]OF UINT; (* KLS98 Communication Error Max Current *)
		iKLS98_ErrMax : ARRAY[0..24]OF UINT; (* KLS98 Communication Error Max All *)
		iKLS98_PhaseCnt : ARRAY[0..24]OF UINT; (* KLS98 Communication Phase Count *)
		iKLS98_ErrAvgCnt : ARRAY[0..24]OF UINT; (* KLS98 Communication Error Average Count per hour *)
		iIC900_AllErrEventMax : UINT; (* IC900 All Modules Communication Error Event Max *)
		iIC900_AllErrCount : UINT; (* IC900 All Modules Communication Error Count *)
		iIC900_AllErrMax : UINT; (* IC900 All Modules Communication Error Max *)
		iIC900_AllPhaseCnt : UINT; (* IC900 All Modules Phase Count *)
		iIC900_AllErrAvg : UINT; (* IC900 All Modules Communication Error Average *)
		iMonic_AllErrEventMax : UINT; (* Monic All Modules Communication Error Event Max *)
		iMonic_AllErrCount : UINT; (* Monic All Modules Communication Error Max Current *)
		iMonic_AllErrMax : UINT; (* Monic All Modules Communication Error Max *)
		iMonic_AllPhaseCnt : UINT; (* Monic All Modules Phase Count *)
		iMonic_AllErrAvg : UINT; (* Monic All Modules Communication Error Average *)
		rUnbLoadMeter : ARRAY[0..2]OF REAL; (* unbalanced load meter [%] *) (* OldName:newPV; Cycle: *)
		sMMD_SerialNumber : ARRAY[0..2]OF STRING[11]; (* MMD Serial number *)
		iNum_CyleTimeViolCnt : UINT; (*Number of cylic time violations of TC#1*)
		tPlantComm : tPlantComm_MM2VIS; (*Datapoints for the Plant Communication*)
	END_STRUCT;
	ModulCfg_typ : 	STRUCT 
		Used : BOOL;
		OK : BOOL;
		SlotNr : USINT;
		SubslotNr : USINT;
		StatusInfo : UINT;
		StatusWait : UINT;
		NodeNr : UINT;
		pModulOkPv : UDINT;
	END_STRUCT;
	ModulOK_typ : 	STRUCT 
		ModuleOK : ARRAY[0..253]OF BOOL;
	END_STRUCT;
	StationCfg_typ : 	STRUCT 
		Modul : ARRAY[0..49]OF ModulCfg_typ;
	END_STRUCT;
	CanDeviceGo : 	STRUCT 
		CANDevGo : ARRAY[0..1]OF USINT;
		ECANDevGo : USINT;
	END_STRUCT;
	ModulID_Type : 	STRUCT 
		iID : INT;
		iXX : INT;
		iYY : INT;
		iZZ : INT;
		iCC : INT;
	END_STRUCT;
	OUT_HA_struct : 	STRUCT 
		tHA2AB : MM2AmmBase; (* HalIO module to AMM base data transfer *) (* OldName:new PV; Cycle:2 *)
		iECanDevGo : USINT; (* event status CAN device go *) (* OldName:new PV; Cycle:2 *)
		iCANIdent : UDINT; (* CAN open ident *) (* OldName:new PV; Cycle:2 *)
		iCANIdentIGN2 : UDINT; (* CAN open ident *) (* OldName:new PV; Cycle:2 *)
		tHA2PB : MM2ParaBase_type; (* Data exchange structure to ParaBase *) (* OldName:new PV; Cycle:5 *)
		iGM1_MStepActPos : DINT; (*gasmixer 1 - Actual position from SM1426-Module [Microsteps]*) (*OldName: slGM1_MStepActPos_TC1; Cycle: 5;*)
		iGM1_Status : UINT; (*gasmixer 1 - Status Word from SM1426-Module*) (*OldName: usGM1_Status_TC1; Cycle: 5;*)
		iGM2_MStepActPos : DINT; (*gasmixer 2 - Actual position from SM1426-Module [Microsteps]*) (*OldName: slGM2_MStepActPos_TC1; Cycle: 5;*)
		iGM2_Status : UINT; (*gasmixer 2 - Status Word from SM1426-Module*) (*OldName: usGM2_Status_TC1; Cycle: 5;*)
		tModulID : ModulID_Type; (* HalIO module ID *) (* OldName:new PV; Cycle:5 *)
		iCAN_CB_us_ident : UDINT; (*CAN user ident for conrod bearing system*) (* OldName:new PV; Cycle:8*)
		bSimWinMOD_Active : BOOL; (* WinMode simulation active *) (* OldName:new PV; Cycle:5*)
		szEng_Motorversion : STRING[17]; (* Para: Engine version *) (* OldName:new PV; Cycle:8*)
		szOrderID : STRING[17]; (*Para: application ID string*) (* OldName:szApplication; Cycle:8*)
		iEngID : DINT; (*Para: engine ID number*) (* OldName:new PV; Cycle:8*)
		iCAN_NOxS_IF1_us_ident : UDINT; (*User ident for NOx sensor CAN interface 1*) (* OldName:new PV; Cycle:8*)
		rI_MaxL1 : ARRAY[0..2]OF REAL; (* max. generator current phase 1 [A]  *) (* OldName:ssIMaxL1; Cycle: 5*)
		rI_MaxL2 : ARRAY[0..2]OF REAL; (* max. generator current phase 2 [A]  *) (* OldName:ssIMaxL2; Cycle: 5*)
		rI_MaxL3 : ARRAY[0..2]OF REAL; (* max. generator current phase 3 [A]  *) (* OldName:ssIMaxL3; Cycle: 5*)
		iCAN_NOxS_IF2_us_ident : UDINT; (*User ident for NOx sensor CAN interface 2*) (* OldName:new PV; Cycle:8*)
		iCAN_NOxS_IF3_us_ident : UDINT; (*User ident for NOx sensor CAN interface 3*) (* OldName:new PV; Cycle:8*)
		szPB1_DeviceName : STRING[40]; (*Device adress from I/O Module Profibus slave 1*) (* OldName:new PV; Cycle:8*)
		szPB2_DeviceName : STRING[40]; (*Device adress from I/O Module Profibus slave 1*) (* OldName:new PV; Cycle:8*)
		szPN_DeviceName : STRING[40]; (*Device adress from I/O Module Profinet*) (* OldName:new PV; Cycle:8*)
		szMBRTU_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus RTU*) (* OldName:new PV; Cycle:8*)
		szMBTCP_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP*) (* OldName:new PV; Cycle:8*)
		bSimWinMOD_FastStart : BOOL; (* WinMode fast start of engine*) (* OldName:new PV; Cycle:5*)
		iSerialNumber_CPU : UDINT; (*Serial number CPU*) (*OldName:new PV; Cycle:5;*)
		iModulID_CPU : UINT; (*Modul ID CPU*) (*OldName:new PV; Cycle:5;*)
		iPowerOnCycles : UDINT; (*Power On cycles CPU*) (*OldName:new PV; Cycle:5;*)
		iOperatingHours_CPU : UDINT; (*Operating hours CPU*) (*OldName:new PV; Cycle:5;*)
		iBatterieStatus : USINT; (*Batterie Status IPC*) (*OldName:new PV; Cycle:5;*)
		iT_CPU : UINT; (*Temperature CPU*) (*OldName:new PV; Cycle:5;*)
		iT_CPU_PLC : UINT; (*Temperature X20CP368xX CPU*) (*OldName:new PV; Cycle:5;*)
		iT_Board : UINT; (*Temperature Board*) (*OldName:new PV; Cycle:5;*)
		iT_Chipset : UINT; (*Temperature Chipset*) (*OldName:new PV; Cycle:5;*)
		iT_PS : UINT; (*Temperature IPC board power supply*) (*OldName:new PV; Cycle:5;*)
		iT_CFast : UINT; (*Temperature IPC CFast*) (*OldName:new PV; Cycle:5;*)
		bSimWinMOD_withoutBus_Active : BOOL; (*WinMode simulation without Bus Hardware active *) (*OldName:new PV; Cycle:5*)
		bCANCntReset : BOOL; (* CAN error counter value reset *) (*OldName: bCANCounterReset; Cycle:5;*)
		rAng_MMD_Diff : ARRAY[0..2]OF REAL; (* angle deviation synchronization *) (* OldName:ssSynchAngleDeviation; Cycle: 1*)
		tHW_Switches : OpMode_Switches; (*Hardware operation mode switches*)
		rCustomizedHA : ARRAY[0..300]OF REAL; (*New customizable interface 2017  - BETA PHASE, use only in coordination with TPSS*)
		rI_Dyn : ARRAY[0..2]OF REAL; (* current dynamic *) (* OldName:usIDyn; Cycle: *)
		rI_GenUnbalanced : ARRAY[0..2]OF REAL; (* unbalanced generator current [1/10 %]  *) (* OldName:ssIGenUnbalanced; Cycle: *)
		rU_MMD_Diff : ARRAY[0..2]OF REAL; (* votage deviation synchronization *) (* OldName:ssSynchVoltDeviation; Cycle: *)
		iIdx_MMD_SynchMode : ARRAY[0..2]OF INT; (* synchronization mode *) (* OldName:usVisSynchMode; Cycle: *)
		iT_CFast2 : UINT; (*Temperature IPC CFast 2*) (*OldName:new PV; Cycle:5;*)
		iSystemTime : DINT; (*System time for exception task logic*)
		iCAN_OQS_OC_us_ident : UDINT; (*User ident for OQS OC sensor CAN interface*) (* OldName:new PV; Cycle:2*)
		iCAN_WG_us_ident : UDINT; (*User ident for WasteGate CAN interface*)
		szMBTCP1_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP*)
		szMBTCP2_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP Slave coupling 2*) (* OldName:new PV; Cycle:8*)
		szMBTCP3_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP Master *) (* OldName:new PV; Cycle:8*)
		bTOF_HwBypassDigitalTwin : BOOL; (*Hardware bypass digital twin - T3 adaptive cranking time*)
		tPlantCom_M2E_In_Cust100ms : ARRAY[0..4]OF tPlantComData_Cust100ms; (*PlantCom Customized Data M2E_In_100ms*)
		tPlantCom_E2E_In_Cust100ms : ARRAY[0..32]OF tPlantComData_Cust100ms; (*PlantCom Customized Data E2E_In_100ms*)
		tPlantCom_E2E_In_Cust10ms : ARRAY[0..32]OF tPlantComData_Cust10ms; (*PlantCom Customized Data E2E_In_10ms*)
		tPlantCom_M2E_In_Cust10ms : ARRAY[0..4]OF tPlantComData_Cust10ms; (*PlantCom Customized Data M2E_In_10ms*)
		bPlantComCfgOk : BOOL;
	END_STRUCT;
	IN_HA_struct : 	STRUCT 
		bEng_Dem : BOOL; (* module demanded *) (* OldName:M_AGFD; Cycle:5 *)
		tAB2HA : AmmBase2MM; (* AMM base to SAFI data transfer *) (* OldName:QUITT_WA; Cycle:2 *)
		tEng_Run : HALioDo_Type; (* engine operating state *) (* OldName:M_BTRB; Cycle:5 *)
		bMMD2_Reset : BOOL; (* Reset of saved max values of MMDsynch 2 *) (* OldName:bResetMMU2; Cycle:5 *)
		bSyncSlipMode : ARRAY[0..2]OF BOOL; (* MMD synchronization with slip mode *) (* OldName:bSyncSlipMode; Cycle:5 *)
		tMonic_CanGo : CanDeviceGo; (* CAN device initializing *) (* OldName:new PV; Cycle:5 *)
		tSAFI_CanGo : CanDeviceGo; (* CAN device initializing *) (* OldName:new PV; Cycle:5 *)
		tICxx_CanGo : CanDeviceGo; (* CAN device initializing *) (* OldName:new PV; Cycle:5 *)
		tKLS98_CanGo : CanDeviceGo; (* CAN device initializing *) (* OldName:new PV; Cycle:5 *)
		tGasMeteringUnit_CanGo : CanDeviceGo; (* CAN device initializing *) (* OldName:new PV; Cycle:5 *)
		tPB2MM : ParaBase2MM_type; (* Data exchange structure to ParaBase *) (* OldName:new PV; Cycle:5 *)
		iGM1_Control : UINT; (*gasmixer 1 - Handover Control Word to SM1426-Module*) (*OldName: usGM1_Control_TC1; Cycle: 5;*)
		iGM1_Mode : SINT; (*gasmixer 1 - Handover Mode to SM1426-Module*) (*OldName: scGM1_Mode_TC1; Cycle: 5;*)
		iGM1_MStepSetPos : DINT; (*gasmixer 1 - Handover Set position to SM1426-Module [Microsteps]*) (*OldName: slGM1_MStepSetPos_TC1; Cycle: 5;*)
		iGM2_Control : UINT; (*gasmixer 2 - Handover Control Word to SM1426-Module*) (*OldName: usGM2_Control_TC1; Cycle: 5;*)
		iGM2_Mode : SINT; (*gasmixer 2 - Handover Mode to SM1426-Module*) (*OldName: scGM2_Mode_TC1; Cycle: 5;*)
		iGM2_MStepSetPos : DINT; (*gasmixer 2 - Handover Set position to SM1426-Module [Microsteps]*) (*OldName: slGM2_MStepSetPos_TC1; Cycle: 5;*)
		rN_EngAct : REAL; (*Engine Speed (1/min)*) (*OldName:ZDGSpeed; Cycle:5;*)
		bGCB_DemSy : BOOL; (*Demand synchronization generator circuit breaker *) (*OldName:ASYANW,gcb[1].dmnd_sy; Cycle:5;*)
		tILF_SOn : HALioDo_Type; (* DO: ILF switched on*)
		tILF_SOf : HALioDo_Type; (* DO: ILF switched off*)
		tFC_SOn : HALioDo_Type; (* DO: frequency control switched on*)
		tFC_SOf : HALioDo_Type; (* DO: frequency control switched off*)
		tPU_SOn : HALioDo_Type; (* DO: P(U) switched on*)
		tPU_SOf : HALioDo_Type; (* DO: P(U) switched off*)
		iCnt_OpHours : DINT; (* operating hours counter *) (*OldName:betrieb_h;Cycle:2;*)
		iIC900CommErrCount : USINT; (* comm. error counter *)
		iMonicCommErrCount : USINT; (* counter Communication error monic *)
		iTecJetCommErrCount : USINT; (* CAN TecJet All Modules Communication Error Count *)
		iE_IgnStat : USINT; (* events igniton system status *)
		iEMonStatus : USINT; (* event monic status *)
		tE_TEC : ARRAY[0..4]OF _tEventTEC; (* CAN events gas inject valve param. *)
		iTecErrCntMax : ARRAY[0..4]OF USINT; (* CAN TecJet Modules Communication max value for wrong gas flow trans *)
		iTecErrCnt : ARRAY[0..4]OF USINT; (* CAN TecJet Modules Communication counter for wrong gas flow transm. *)
		tE_KLS : ARRAY[0..24]OF _tEventKLS; (* CAN events KLS98 *)
		tE_SAFI : ARRAY[0..12]OF _tEventSAFI; (* SAFI CAN Events *)
		iCnt_SA_ComErr : ARRAY[0..12]OF DINT; (* SAFI communication error counter *) (* OldName:usSAFIComErrCnt; Cycle:  *)
		iKLS98CommErrCount : ARRAY[0..24]OF USINT; (* CAN KLS98 All Module Communication Error Count*)
		rCustomizedHA : ARRAY[0..300]OF REAL; (*New customizable interface 2017  - BETA PHASE, use only in coordination with TPSS*)
		iIdx_OMSS : INT; (*Index of operation mode selector switch 0  OFF, 1  MANUAL, 2  AUTOMATIC, 3 Test (Optional)*) (*OldName:BWS_HA,PROBE; Cycle:5;*)
		iIdx_OMSS_TC7 : INT; (*Index of operation mode selector switch 0  OFF, 1  MANUAL, 2  AUTOMATIC, 3 Test (Optional)*) (*OldName:BWS_HA,PROBE; Cycle:7;*)
		bMMD_GenAlarmTestOn : BOOL; (* MMD_Gen alarm test On *) (*OldName:newPv; Cycle:5;*)
		iSt_OpMode : UDINT; (*engine operation status*) (*OldName:newPv; Cycle:2;*)
		bFSync_NarrowSyncWin : BOOL; (* use narrow sync window if fast-sync controller is active *) (*OldName:newPv; Cycle:5;*)
		iModule : USINT; (*Engine Module Number*)
		iIdx_RSS : INT; (*Request Selector Switch*)
		iIdx_SyOMSS : INT; (*Synchronization Selector Switch*)
		rP_Nom : REAL; (*nominal electric power [KW], depends on gastype *)
		tPlantCom_E2E_Out_Cust100ms : tPlantComData_Cust100ms; (*PlantCom Customized Data E2E_Out_100ms*)
		tPlantCom_E2M_Out_Cust100ms : ARRAY[0..4]OF tPlantComData_Cust100ms; (*PlantCom Customized Data E2M_Out_100ms*)
		tPlantCom_E2E_Out_Cust10ms : tPlantComData_Cust10ms; (*PlantCom Customized Data E2E_Out_10ms*)
		tPlantCom_E2M_Out_Cust10ms : ARRAY[0..4]OF tPlantComData_Cust10ms; (*PlantCom Customized Data E2M_Out_10ms*)
		bSafetyPLC_Active : BOOL; (*SAFETY PLC: SafetyPLC is active*) (*OldName: new PV; Cycle: 5;*) (*V04.25.00.00*)
		bSafeOUT_SafetyLoop_EmStop : BOOL; (*SAFETY PLC: Safety loop - Emergency stop push button OK*) (*OldName: new PV; Cycle: 5;*) (*V04.25.00.00*)
		bSafeOUT_SafetyLoop_Eng : BOOL; (*SAFETY PLC: Safety loop - Engine OK*) (*OldName: new PV; Cycle: 5;*) (*V04.25.00.00*)
	END_STRUCT;
	_tEventTEC : 	STRUCT 
		Conf : ARRAY[0..8]OF USINT;
		Data : ARRAY[0..5]OF USINT;
		Contr : ARRAY[0..1]OF USINT;
		Status : ARRAY[0..5]OF USINT;
	END_STRUCT;
	_tEventKLS : 	STRUCT 
		conf : ARRAY[0..99]OF USINT;
	END_STRUCT;
	_tEventSAFI : 	STRUCT 
		conf : ARRAY[0..35]OF USINT;
		zuend : ARRAY[0..1]OF USINT;
		error : USINT;
		sdata : ARRAY[0..4]OF USINT;
		idata : ARRAY[0..30]OF USINT;
		kdata : ARRAY[0..30]OF USINT;
		ddata : ARRAY[0..53]OF USINT;
		dmdata1 : ARRAY[0..5]OF USINT;
		kmdata : ARRAY[0..7]OF USINT;
		dmdata2 : ARRAY[0..15]OF USINT;
		smdata : ARRAY[0..9]OF USINT;
		status : ARRAY[0..11]OF USINT;
		bez : USINT;
		ref : USINT;
		cur : USINT;
		diag : ARRAY[0..18]OF USINT;
	END_STRUCT;
	OpMode_Switches : 	STRUCT 
		iIdx_OMS_Hw : INT; (* index of hardware operation mode selector switch *)
		iIdx_RMS_Hw : INT; (* index of hardware request mode selector switch *)
		iIdx_SyOMS_Hw : INT; (* index of hardware synchronisation operation mode selector switch *)
		bGoodQual : BOOL; (* Global GoodQual Bit for all 3 hw-switches *)
	END_STRUCT;
	HALIO2CUSTOM_Struct : 	STRUCT 
		tSet_LFSMO_DB_COn : HALioDi_Type; (*DI: Activation of LFSMO Deadband via AI*)
		tSet_LFSMO_DB_COf : HALioDi_Type; (*DI: De-activation of LFSMO Deadband via AI*)
		tSet_LFSMU_DB_COn : HALioDi_Type; (*DI: Activation of LFSMU Deadband via AI*)
		tSet_LFSMU_DB_COf : HALioDi_Type; (*DI: De-activation of LFSMU Deadband via AI*)
		tSet_LFSMO_Droop_COn : HALioDi_Type; (*DI: Activation of LFSMO Droop via AI*)
		tSet_LFSMO_Droop_COf : HALioDi_Type; (*DI: De-activation of LFSMO Droop via AI*)
		tSet_LFSMU_Droop_COn : HALioDi_Type; (*DI: Activation of LFSMO Droop via AI*)
		tSet_LFSMU_Droop_COf : HALioDi_Type; (*DI: De-activation of LFSMO Droop via AI*)
		tSet_FSMU_Droop_COn : HALioDi_Type; (*DI: Activation of FSMU Droop via AI*)
		tSet_FSMU_Droop_COf : HALioDi_Type; (*DI: De-activation of FSMU Droop via AI*)
		tSet_FSMO_Droop_COn : HALioDi_Type; (*DI: Activation of FSMO Droop via AI*)
		tSet_FSMO_Droop_COf : HALioDi_Type; (*DI: De-activation of FSMO Droop via AI*)
		tSet_FSMU_DB_COn : HALioDi_Type; (*DI: Activation of FSMU Deadband via AI*)
		tSet_FSMU_DB_COf : HALioDi_Type; (*DI: De-activation of FSMO Deadband via AI*)
		tSet_FSMO_DB_COn : HALioDi_Type; (*DI: Activation of FSMO Deadband via AI*)
		tSet_FSMO_DB_COf : HALioDi_Type; (*DI: De-activation of FSMO Deadband via AI*)
		tSet_FSM_RMC_Up_COn : HALioDi_Type; (*DI: Activation of positive Margin FSM via AI*)
		tSet_FSM_RMC_Up_COf : HALioDi_Type; (*DI: De-activation of positive Margin FSM via AI*)
		tSet_FSM_RMC_Down_COn : HALioDi_Type; (*DI: Activation of negative Margin FSM via AI*)
		tSet_FSM_RMC_Down_COf : HALioDi_Type; (*DI: De-activation of negative Margin FSM via AI*)
		tSet_U_Droop_COn : HALioDi_Type; (*DI: Activation of droop U via AI*)
		tSet_U_Droop_COf : HALioDi_Type; (*DI: De-activation of droop U via AI*)
		tSet_FSM_Rmp_COn : HALioDi_Type; (*DI: Activation of Ramp rate via AI*)
		tSet_FSM_Rmp_COf : HALioDi_Type; (*DI: De-activation of Ramp rate via AI*)
		tSet_F_Ref_FSM_COn : HALioDi_Type; (*DI: Activation of Reference frequency for FSM/LFSM via AI*)
		tSet_F_Ref_FSM_COf : HALioDi_Type; (*DI:De-activation of Reference frequency for FSM/LFSM via AI*)
		bCheck_HA2CU : BOOL; (* Controlbit for HALio to Custom structure *)
	END_STRUCT;
	HALIO2GRID_Struct : 	STRUCT 
		tF_LFSMO_DB : HALioAi_Type; (* LFSMO Deadband from EU [Hz] *)
		tF_LFSMU_DB : HALioAi_Type; (* LFSMU Deadband from EU [Hz] *)
		tF_LFSMO_Droop : HALioAi_Type; (* LFSMO Droop from EU [Hz] *)
		tF_LFSMU_Droop : HALioAi_Type; (* LFSMU Droop from EU [Hz] *)
		tF_FSMU_Droop : HALioAi_Type; (* FSMU Droop from EU [Hz] *)
		tF_FSMO_Droop : HALioAi_Type; (* FSMO Droop from EU [Hz] *)
		tF_FSMU_DB : HALioAi_Type; (* FSMU Deadband from EU [Hz] *)
		tF_FSMO_DB : HALioAi_Type; (* FSMO Deadband from EU [Hz] *)
		tP_FSM_RMC_Up : HALioAi_Type; (* Positive Margin FSM from EU [%Pnom] *)
		tP_FSM_RMC_Down : HALioAi_Type; (* Negative Margin FSM from EU [%Pnom] *)
		tU_Droop : HALioAi_Type; (* U droop from EU [%] *)
		tFSM_Rmp_Up : HALioAi_Type; (* Ramp rate UP from EU [%Pnom/s] *)
		tFSM_Rmp_Down : HALioAi_Type; (* Ramp rate DOWN from EU [%Pnom/s] *)
		tF_Ref_FSM : HALioAi_Type; (* Reference frequency for FSM/LFSM from EU [Hz] *)
		tJunctionBox_GnlAlm : HALioDi_Type; (* DI:General Alarm from junction box *)
		bCheck_HA2GR : BOOL; (* Controlbit for HALio to Grid structure *)
	END_STRUCT;
	tPlantComm_MM2VIS : 	STRUCT 
		iIO_Typ_Dir_Num_Min : USINT; (*First Asset of the Communication (Selection lower bound)*)
		iIO_Typ_Dir_Num_Max : USINT; (*Last Asset of the Communication (Selection upper bound)*)
		iFrc_Gbl : USINT; (*Numer of forced Signals from/to all assets*)
		iFrc_Act : USINT; (*Numer of forced Signals from/to the selected asset*)
		rInt : ARRAY[0..15]OF REAL; (*Intern Value (Processed by PLC) of the signal*)
		rExt : ARRAY[0..15]OF REAL; (*Extern Value (Transfered via OpcUA) of the signal*)
		iNum : ARRAY[0..15]OF USINT; (*Signal Number (Index)*)
		iComment : ARRAY[0..15]OF UINT; (*Signal Description e.g. Watchdog => Textenum*)
		bMas_Ena : ARRAY[0..4]OF BOOL; (*Bus Diagnostic: Master communication available*)
		bEng_Ena : ARRAY[0..32]OF BOOL; (*Bus Diagnostic: Engine communication available*)
		bCfg_OK : BOOL; (*OpcUA Confiugration OK*)
		bCfg_Err : BOOL; (*OpcUA Configuration Error*)
		bCfg_Rst : BOOL; (*OpcUA Configuration Change: Reboot Required*)
	END_STRUCT;
	tPlantComm_VIS2MM : 	STRUCT 
		iIO_Typ : USINT; (*Selected IO Type: (AI, DI, AO, DO)*)
		iIO_Typ_Dir : USINT; (*Selected Signal Direction: From/To Master/Engine*)
		iIO_Typ_Dir_Num : USINT; (*Selected Asset e.g. Engine 3*)
		iNum_Start : USINT; (*First Signal to be displayed in the diagnostics table (Offset)*)
		bFrc_Gbl : BOOL; (*Unforce all Signals from/to all the assets*)
		bFrc_Act : BOOL; (*Unforce all Signals from/to the selected asset*)
		bFrc : ARRAY[0..15]OF BOOL; (*Force Active/Inactive of the displayed signals*)
		bFrc_Int : ARRAY[0..15]OF BOOL; (*Force Value for digital Signals*)
		rFrc_Int : ARRAY[0..15]OF REAL; (*Force Value for analog Signals*)
	END_STRUCT;
	tPlantComm_Para : 	STRUCT 
		iMas_Num_Min : USINT; (*[Para 15022] First Master in the Communication*)
		iMas_Num_Max : USINT; (*[Para 15023] Last Master in the Communication*)
		iEng_Num_Min : USINT; (*[Para 15024] First Engine in the Communication*)
		iEng_Num_Max : USINT; (*[Para 15025] Last Engine in the Communication*)
		bActive : BOOL; (*[Para 15021] Plant Communication active*)
	END_STRUCT;
	tPlantComData_Cust10ms : 	STRUCT 
		digitalSignals : ARRAY[0..15]OF tDigitalSignal_Struct;
		analogSignals : ARRAY[0..7]OF tAnalogSignal_Struct;
	END_STRUCT;
	tPlantComData_Cust100ms : 	STRUCT 
		digitalSignals : ARRAY[0..31]OF tDigitalSignal_Struct;
		analogSignals : ARRAY[0..15]OF tAnalogSignal_Struct;
	END_STRUCT;
	tDigitalSignal_Struct : 	STRUCT 
		Value : BOOL;
		GoodQual : BOOL;
	END_STRUCT;
	tAnalogSignal_Struct : 	STRUCT 
		Value : REAL;
		GoodQual : BOOL;
	END_STRUCT;
END_TYPE
