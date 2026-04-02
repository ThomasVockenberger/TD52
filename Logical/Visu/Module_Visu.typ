
TYPE
	IN_VI_Struct : 	STRUCT 
		tPB2MM : ParaBase2MM_type; (*Data exchange structure to ParaBase*) (*OldName:new PV; Cycle:5;*)
		tAB2VI : AmmBase2MM; (*AMM structure*) (*OldName:QUITT_WA; Cycle:2;*)
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
		bSimWinMOD_Active : BOOL; (*WinMode simulation active *) (* OldName:new PV; Cycle:5*)
		szMBTCP_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP*)
		bEng_Rdy_Aut : BOOL; (* ready for automatic mode *) (*OldName:M_BERAUT;Cycle:2;*)
		bPanelSelection_Bus : BOOL; (*Controls lock of local operation for additional touch panels - Demand from bus system*)
		iT_CFast2 : UINT; (*Temperature IPC CFast 2*) (*OldName:new PV; Cycle:5;*)
		iPanelSelection_Cust : INT; (*Controls lock of local operation for additional touch panels - Customized*)
		bPanelSelection_Cust : BOOL; (*Controls lock of local operation for additional touch panels - Customized*)
	END_STRUCT;
	OUT_VI_Struct : 	STRUCT 
		tVI2PB : MM2ParaBase_type; (*Data exchange structure to ParaBase*) (*OldName:new PV; Cycle:5;*)
		tVI2AB : MM2AmmBase; (*AMM structure*) (*OldName:new PV; Cycle:5;*)
		iPassLevel : INT; (*User roles level*) (*OldName:ucPassLevel; Cycle:5;*)
		iPanelSelection : INT; (*Controls lock of local operation for additional touch panels*)
		bGnlWarningHMI : BOOL; (*Internal HMI messsages for building group alarm*)
	END_STRUCT;
	MM2VIS_Struct : 	STRUCT  (*OPC variables from module to VIS*)
		bMsg9007 : BOOL; (*Hourly message for monitoring communication with DIA.NE VIS server*) (*OldName:bWinServerOn; Cycle:;*)
		bMsg3517 : BOOL; (*Dead communication with DIA.NE VIS server*) (*OldName:bWinServerOn; Cycle:;*)
		bWatchdogVIS2MM : BOOL; (*Watchdog observation connection VIS --> PLC*) (*OldName:bWinServerOn; Cycle:;*)
		bWatchdogMM2VIS : BOOL; (*Watchdog observation connection PLC --> VIS*) (*OldName:bWinServerOn; Cycle:;*)
		rCPU_IdleRate : REAL; (*CPU ARwin Idle rate in %*) (*OldName: newPV; Cycle:;*)
		rCPU_IdleTime : REAL; (*CPU ARwin Idle time in microseconds*) (*OldName: newPV; Cycle:;*)
		bAvTrackNoDemand : BOOL; (*Engine availability*) (*OldName:new PV; Cycle:5;*)
		bAvTtackMaintenance : BOOL; (*Engine availability*) (*OldName:new PV; Cycle:5;*)
		bAvTrackFailure : BOOL; (*Engine availability*) (*OldName:new PV; Cycle:5;*)
		iSerialNumber_CPU : DINT; (*Serial number of CPU board*) (*OldName:new PV; Cycle:5;*)
		iModulID_CPU : DINT; (*Module ID of CPU board*) (*OldName:new PV; Cycle:5;*)
		iPowerOnCycles_CPU : DINT; (*PowerOnCycles of CPU board*) (*OldName:new PV; Cycle:5;*)
		iOperatingHours_CPU : DINT; (*Operating hours of CPU board [h]*) (*OldName:new PV; Cycle:5;*)
		bBatterieOK : BOOL; (*Battery status CPU (0 = battery low or missing, 1 = battery ok)*) (*OldName:new PV; Cycle:5;*)
		rT_CPU : REAL; (*Ambient temperature of the processor [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_CPU_PLC : REAL; (*Ambient temperature of the X20CP368xX processor [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_Board : REAL; (*Temperature of board [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_Chipset : REAL; (*Temperature of chipset area [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_PS : REAL; (*Temperature of board power supply area [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_CFast : REAL; (*Temperature of CFast area [degC]*) (*OldName:new PV; Cycle:5;*)
		bMsg2401 : BOOL; (*bMsg*)
		bMsg2402 : BOOL; (*bMsg*)
		bMsg2403 : BOOL; (*bMsg*)
		bMsg2404 : BOOL; (*bMsg*)
		bMsg2405 : BOOL; (*bMsg*)
		bMsg2406 : BOOL; (*bMsg*)
		bMsg9029 : BOOL; (*bMsg*)
		bMsg9030 : BOOL; (*bMsg*)
		bMsg9031 : BOOL; (*bMsg*)
		bMsg9032 : BOOL; (*bMsg*)
		bMsg9033 : BOOL; (*bMsg*)
		bMsg9034 : BOOL; (*bMsg*)
		bMsg9035 : BOOL; (*bMsg*)
		bMsg9036 : BOOL; (*bMsg*)
		bMsg9037 : BOOL; (*bMsg*)
		rT_CFast2 : REAL; (*Temperature of CFast2 area [degC]*) (*OldName:new PV; Cycle:5;*)
		iPanelSelection : INT; (*Controls lock of local operation for additional touch panels*)
		bPanelSelection_Cust : BOOL; (*Controls lock of local operation for additional touch panels - Customized*)
		rCPULoad : REAL; (* PLC CPU Load 0.4 = 40 percent load *)
		bMpBackupCmdBusy : BOOL;
		bMpBackupCmdDone : BOOL;
		bMpBackupError : BOOL;
		bPort_PVI_Open : BOOL;	(* PVI ports 11169 (TCP), 11159 (UDP)	open *)
		bPort_FTP_Open : BOOL;	(* FTP port     21 (TCP)				open *)
		bPort_SDM_Open : BOOL;	(* SDM port   8080 (TCP)				open *)
	END_STRUCT;
	VIS2MM_Struct : 	STRUCT  (*OPC variables from module to VIS*)
		iPassLevel : INT; (*Actual DIA.NE VIS user level*) (*OldName:ucPassLevel; Cycle:;*)
		bMsg9100 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bMsg9101 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bMsg9102 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bMsg9103 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bMsg9104 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bMsg9105 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bMsg9106 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bMsg9107 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bMsg9108 : BOOL; (*SX12, Test for engine availability*) (*OldName:new PV; Cycle:5;*)
		bRAM_Troubleshooting : BOOL; (*RAM Troubleshooting*)
		bRAM_Maintenance : BOOL; (*RAM Maintenance*)
		bRAM_DeactivShutdown : BOOL; (*RAM Deactivated Shutdown *)
		bRAM_ResetTimer : BOOL; (*RAM reset timer*)
		iCnt_RAM : INT; (*RAM timer value*)
		iPanelSelection : INT; (*Controls lock of local operation for additional touch panels*)
		bMsg9337 : BOOL; (*Used database size reached critical size*)
		bMsg9338 : BOOL; (*Free disk space of C: reached critical size*)
		bMsg9344 : BOOL; (*CFast lifetime of C: almost reached*)
		bMsg9345 : BOOL; (*CFast lifetime of D: almost reached*)
		bMsg9346 : BOOL; (*Datalogging outage*)
		bMpBackupCreate : BOOL;
		bMpBackupRestore : BOOL;
		sMpBackupName : STRING[80];
		bPort_PVI_Act : BOOL; 	(* PVI ports 11169 (TCP), 11159 (UDP)	active (cmd open) *)
		bPort_FTP_Act : BOOL; 	(* FTP port     21 (TCP)				active (cmd open) *)
		bPort_SDM_Act : BOOL; 	(* SDM port   8080 (TCP)				active (cmd open) *)
		iTi_TimeZoneOffset : INT; (* Local time offset to UTC time [min] *)
	END_STRUCT;
	PARA_VI_Struct : 	STRUCT 
		bAvailabilityTrackingOn : BOOL; (*PARA [13240]: RAM on/off*) (*OldName:new PV; Cycle:5;*)
		Dummy2 : BOOL;
		Dummy3 : BOOL;
		Dummy1 : BOOL;
		rT_IPC_CPU_LimHi : REAL; (*PARA [13751]: Ambient temperature of the processor warning [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_IPC_Board_LimHi : REAL; (*PARA [13752]: Temperature of board warning [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_IPC_Chipset_LimHi : REAL; (*PARA [13753]: Temperature of chipset area warning [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_IPC_PS_LimHi : REAL; (*PARA [13754]: Temperature of board power supply area warning [degC]*) (*OldName:new PV; Cycle:5;*)
		rT_IPC_CFast_LimHi : REAL; (*PARA [13755]: Temperature of CFast area warning [degC]*) (*OldName:new PV; Cycle:5;*)
		tiAvailabilityTracking_Max : TIME; (*PARA [14380]: RAM timer max.*) (*OldName:new PV; Cycle:5;*)
		bAddPanel1_Enabled : BOOL; (*PARA [14429]: First additional panel enabled*)
		bAddPanel2_Enabled : BOOL; (*PARA [14430]: Second additional panel enabled*)
		bExternalPanelLock_Enabled : BOOL; (*PARA [14431]: External lock local operation*)
		bExtPGCT : BOOL; (*PARA [14970]: Extend PGCT*)
	END_STRUCT;
	PERM_VI_struct : 	STRUCT  (*DO NOT SORT PERM STRUCTURE! Do not change structure order or overall size of structure!*)
		iPanelSelection : INT; (*Perm: Controls lock of local operation for additional touch panels*) (*Oldname: New PV*)
		rTB_PermValue2 : REAL;
		rTB_PermValue3 : REAL;
		rTB_PermValue4 : REAL;
		rTB_PermValue5 : REAL;
		rTB_PermValue6 : REAL;
		rTB_PermValue7 : REAL;
		rTB_PermValue8 : REAL;
		rTB_PermValue9 : REAL;
		rTB_PermValue10 : REAL;
	END_STRUCT;
	tOilCounter : 	STRUCT 
		day : UINT;
		month : UINT;
		year : UINT;
		hour : UINT;
		minute : UINT;
		second : UINT;
	END_STRUCT;
END_TYPE
