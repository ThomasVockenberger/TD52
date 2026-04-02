
TYPE
	MM2VIS_sPLC_Struct : 	STRUCT 
		bCompletion_Busy : BOOL;
		bCompletion_Done : BOOL;
		bCompletion_Error : BOOL;
		bConnect_Active : BOOL;
		bConnect_Busy : BOOL;
		bConnect_Error : BOOL;
		bControl_Busy : BOOL;
		bControl_Done : BOOL;
		bControl_Error : BOOL;
		bExchange_Busy : BOOL;
		bExchange_Done : BOOL;
		bExchange_Error : BOOL;
		bF02_DI_Ign_Run : BOOL; (*Function 02 - Digital Input - Feedback Ignition*)
		bF07_DI_GCB_Off : BOOL; (*Function 07 - Digital Input - Generator circuit breaker opened*)
		bF07_DI_GCB_On : BOOL; (*Function 07 - Digital Input - Generator circuit breaker closed*)
		bF07_DO_GCB_RUC : BOOL; (*Function 07 - Digital Output - GCB - Release undervoltage coil*)
		bF07_DO_Rel_Sync_Load : BOOL; (*Function 07 - Digital Output - Release synchronizing and load*)
		bF09_DI_ERV_INL1_Fan_Run : BOOL; (*Function 09 - Group 1 - Inlet air fan operating - Digital input*)
		bF09_DI_ERV_INL1_Lou_CL : BOOL; (*Function 09 - Group 1 - Inlet air louvre closed - Digital input*)
		bF09_DI_ERV_INL1_Lou_OP : BOOL; (*Function 09 - Group 1 - Inlet air louvre opened - Digital input*)
		bF09_DI_ERV_INL2_Fan_Run : BOOL; (*Function 09 - Group 2 - Inlet air fan operating - Digital input*)
		bF09_DI_ERV_INL2_Lou_CL : BOOL; (*Function 09 - Group 2 - Inlet air louvre closed - Digital input*)
		bF09_DI_ERV_INL2_Lou_OP : BOOL; (*Function 09 - Group 2 - Inlet air louvre opened - Digital input*)
		bF09_DI_ERV_INL3_Fan_Run : BOOL; (*Function 09 - Group 3 - Inlet air fan operating - Digital input*)
		bF09_DI_ERV_INL3_Lou_CL : BOOL; (*Function 09 - Group 3 - Inlet air louvre closed - Digital input*)
		bF09_DI_ERV_INL3_Lou_OP : BOOL; (*Function 09 - Group 3 - Inlet air louvre opened - Digital input*)
		bF09_DI_ERV_INL4_Fan_Run : BOOL; (*Function 09 - Group 4 - Inlet air fan operating - Digital input*)
		bF09_DI_ERV_INL4_Lou_CL : BOOL; (*Function 09 - Group 4 - Inlet air louvre closed - Digital input*)
		bF09_DI_ERV_INL4_Lou_OP : BOOL; (*Function 09 - Group 4 - Inlet air louvre opened - Digital input*)
		bF09_DI_ERV_INL5_Fan_Run : BOOL; (*Function 09 - Group 5 - Inlet air fan operating - Digital input*)
		bF09_DI_ERV_INL5_Lou_CL : BOOL; (*Function 09 - Group 5 - Inlet air louvre closed - Digital input*)
		bF09_DI_ERV_INL5_Lou_OP : BOOL; (*Function 09 - Group 5 - Inlet air louvre opened - Digital input*)
		bF09_DI_ERV_INL6_Fan_Run : BOOL; (*Function 09 - Group 6 - Inlet air fan operating - Digital input*)
		bF09_DI_ERV_INL6_Lou_CL : BOOL; (*Function 09 - Group 6 - Inlet air louvre closed - Digital input*)
		bF09_DI_ERV_INL6_Lou_OP : BOOL; (*Function 09 - Group 6 - Inlet air louvre opened - Digital input*)
		bF09_DI_ERV_OTL1_Lou_CL : BOOL; (*Function 09 - Group 1 - Outlet air louvre closed - Digital input*)
		bF09_DI_ERV_OTL1_Lou_OP : BOOL; (*Function 09 - Group 1 - Outlet air louvre opened - Digital input*)
		bF09_DI_ERV_OTL2_Lou_CL : BOOL; (*Function 09 - Group 2 - Outlet air louvre closed - Digital input*)
		bF09_DI_ERV_OTL2_Lou_OP : BOOL; (*Function 09 - Group 2 - Outlet air louvre opened - Digital input*)
		bF09_DI_ERV_OTL3_Lou_CL : BOOL; (*Function 09 - Group 3 - Outlet air louvre closed - Digital input*)
		bF09_DI_ERV_OTL3_Lou_OP : BOOL; (*Function 09 - Group 3 - Outlet air louvre opened - Digital input*)
		bF09_DI_ERV_OTL4_Lou_CL : BOOL; (*Function 09 - Group 4 - Outlet air louvre closed - Digital input*)
		bF09_DI_ERV_OTL4_Lou_OP : BOOL; (*Function 09 - Group 4 - Outlet air louvre opened - Digital input*)
		bF09_DI_ERV_OTL5_Lou_CL : BOOL; (*Function 09 - Group 5 - Outlet air louvre closed - Digital input*)
		bF09_DI_ERV_OTL5_Lou_OP : BOOL; (*Function 09 - Group 5 - Outlet air louvre opened - Digital input*)
		bF09_DI_ERV_OTL6_Lou_CL : BOOL; (*Function 09 - Group 6 - Outlet air louvre closed - Digital input*)
		bF09_DI_ERV_OTL6_Lou_OP : BOOL; (*Function 09 - Group 6 - Outlet air louvre opened - Digital input*)
		bF09_DI_ER_Door_CL : BOOL; (*Function 09 - Doors closed - Digital input*)
		bF09_ERV_ColdCountry : BOOL; (*Function 09 - Engine room ventilation - Cold country mode active*)
		bF10_Exist_EmStop_AUX : BOOL; (*Function 10 - Emergency stop push button exists - Auxiliaries control panel*)
		bF10_Exist_EmStop_EGAT : BOOL; (*Function 10 - Emergency stop push button exists - Exhaust gas after treatment control panel*)
		bF10_Exist_EmStop_ER1 : BOOL; (*Function 10 - Emergency stop push button exists - Engine room button 1*)
		bF10_Exist_EmStop_ER2 : BOOL; (*Function 10 - Emergency stop push button exists - Engine room button 2*)
		bF10_Exist_EmStop_ER3 : BOOL; (*Function 10 - Emergency stop push button exists - Engine room button 3*)
		bF10_Exist_EmStop_ER4 : BOOL; (*Function 10 - Emergency stop push button exists - Engine room button 4*)
		bF10_Exist_EmStop_EXT : BOOL; (*Function 10 - Emergency stop push button exists - External*)
		bF10_Exist_EmStop_IP : BOOL; (*Function 10 - Emergency stop push button exists - Interlock control panel*)
		bF10_Exist_EmStop_MC : BOOL; (*Function 10 - Emergency stop push button exists - Module control panel (+A/+MC)*)
		bF10_Exist_EmStop_MCP : BOOL; (*Function 10 - Emergency stop push button exists - Master control panel*)
		bF10_Exist_EmStop_PCGC : BOOL; (*Function 10 - Emergency stop push button exists - Prechamber gas compressor*)
		bF10_Exist_EmStop_TR : BOOL; (*Function 10 - Emergency stop push button exists - Thermal reactor control panel*)
		bF12_DO_DCGA_GV_Open : BOOL; (*Function 12 - Digital Output - Demand gas valves from DCGA*)
		bF12_DO_GV1_Open : BOOL; (*Function 12 - Digital Output - Demand gas valves from gas train 1*)
		bF12_DO_GV2_Open : BOOL; (*Function 12 - Digital Output - Demand gas valves from gas train 2*)
		bF12_DO_GV3_Open : BOOL; (*Function 12 - Digital Output - Demand gas valves from gas train 3*)
		bF12_DO_GV4_Open : BOOL; (*Function 12 - Digital Output - Demand gas valves from gas train 4*)
		bInfoSafeAppl_Ack : BOOL;
		bInfoSafeAppl_Exist : BOOL;
		bInfoSafeComm_Ack : BOOL;
		bInfoSafeComm_Exist : BOOL;
		bInfoStatus_FWExchanged : BOOL;
		bInfoStatus_SetupModeActive : BOOL;
		bInfoStatus_SKExchanged : BOOL;
		bInfoStatus_SNExchanged : BOOL;
		bInfo_Busy : BOOL;
		bInfo_Done : BOOL;
		bInfo_Error : BOOL;
		bLoadSafeOpt_Busy : BOOL;
		bLoadSafeOpt_Done : BOOL;
		bLoadSafeOpt_Error : BOOL;
		bParaSafe_DCGA_Exist : BOOL; (*From SafetyPLC - PARA [15196]: Gas train for decentral gas addition existing*)
		bParaSafe_ERV_ColdCountry_Active : BOOL; (*From SafetyPLC - PARA [15189]: Cold country mode active*)
		bParaSafe_ERV_Cust_Active : BOOL; (*From SafetyPLC - PARA [15188]: Customer room ventilation - Monitoring active*)
		bParaSafe_ER_Door_MonActive : BOOL; (*From SafetyPLC - PARA [15212]: Door switch - Monitoring active*)
		bParaSafe_FS_HWHT_Lo_Exist : BOOL; (*From SafetyPLC - PARA [15117]: High temperature heating water - Minimum flow switch available*)
		bParaSafe_FS_HWLT_Lo_Exist : BOOL; (*From SafetyPLC - PARA [15125]: Low temperature heating water - Minimum flow switch available*)
		bParaSafe_GT2_Exist : BOOL; (*From SafetyPLC - PARA [15082]: Gas train 2 existing*)
		bParaSafe_GT3_Exist : BOOL; (*From SafetyPLC - PARA [15083]: Gas train 3 existing*)
		bParaSafe_GT4_Exist : BOOL; (*From SafetyPLC - PARA [15103]: Gas train 4 existing*)
		bParaSafe_HWcirc_Cust_Exist : BOOL; (*From SafetyPLC - PARA [15108]: Customer heating water circuit - Monitoring active*)
		bParaSafe_LS_HWHT_Lo_Exist : BOOL; (*From SafetyPLC - PARA [15110]: High temperature heating water - Minimum level switch available*)
		bParaSafe_LS_HWLT_Lo_Exist : BOOL; (*From SafetyPLC - PARA [15118]: Low temperature heating water - Minimum level switch available*)
		bParaSafe_Pr_EG_sMonActive : BOOL; (*From SafetyPLC - PARA [15085]: Exhaust gas backpressure - Safety monitoring active*)
		bParaSafe_PS1_HWHT_Hi_Exist : BOOL; (*From SafetyPLC - PARA [15111]: High temperature heating water - Maximum pressure switch 1 available*)
		bParaSafe_PS1_HWHT_Lo_Exist : BOOL; (*From SafetyPLC - PARA [15113]: High temperature heating water - Minimum pressure switch 1 available*)
		bParaSafe_PS1_HWLT_Hi_Exist : BOOL; (*From SafetyPLC - PARA [15119]: Low temperature heating water - Maximum pressure switch 1 available*)
		bParaSafe_PS1_HWLT_Lo_Exist : BOOL; (*From SafetyPLC - PARA [15121]: Low temperature heating water - Minimum pressure switch 1 available*)
		bParaSafe_PS2_HWHT_Hi_Exist : BOOL; (*From SafetyPLC - PARA [15112]: High temperature heating water - Maximum pressure switch 2 available*)
		bParaSafe_PS2_HWHT_Lo_Exist : BOOL; (*From SafetyPLC - PARA [15114]: High temperature heating water - Minimum pressure switch 2 available*)
		bParaSafe_PS2_HWLT_Hi_Exist : BOOL; (*From SafetyPLC - PARA [15120]: Low temperature heating water - Maximum pressure switch 2 available*)
		bParaSafe_PS2_HWLT_Lo_Exist : BOOL; (*From SafetyPLC - PARA [15122]: Low temperature heating water - Minimum pressure switch 2 available*)
		bParaSafe_PS_HW_Lo_MuteActive : BOOL; (*From SafetyPLC - PARA [15109]: Muting heating water minimum pressure switches at engine standstill active*)
		bParaSafe_SafetyLoop_A2_Exist : BOOL; (*From SafetyPLC - PARA [15143]: Safety loop 2 in the module control panel existing*)
		bParaSafe_SysPurge_MonActive : BOOL; (*From SafetyPLC - PARA [15107]: System purge - Monitoring active*)
		bParaSafe_TS1_HWHT_Hi_Exist : BOOL; (*From SafetyPLC - PARA [15115]: High temperature heating water - Maximum temperature switch 1 available*)
		bParaSafe_TS1_HWLT_Hi_Exist : BOOL; (*From SafetyPLC - PARA [15123]: Low temperature heating water - Maximum temperature switch 1 available*)
		bParaSafe_TS2_HWHT_Hi_Exist : BOOL; (*From SafetyPLC - PARA [15116]: High temperature heating water - Maximum temperature switch 2 available*)
		bParaSafe_TS2_HWLT_Hi_Exist : BOOL; (*From SafetyPLC - PARA [15124]: Low temperature heating water - Maximum temperature switch 2 available*)
		bRead_CRC : BOOL; (*CRC readout of SafetyPLC is active*)
		bSafeModuleOK_101 : BOOL; (*Safe communication channel - Node 101 OK*)
		bSafeModuleOK_102 : BOOL; (*Safe communication channel - Node 102 OK*)
		bSafeModuleOK_103 : BOOL; (*Safe communication channel - Node 103 OK*)
		bSafeModuleOK_104 : BOOL; (*Safe communication channel - Node 104 OK*)
		bSafeModuleOK_105 : BOOL; (*Safe communication channel - Node 105 OK*)
		bSafeModuleOK_201 : BOOL; (*Safe communication channel - Node 201 OK*)
		bSafeModuleOK_202 : BOOL; (*Safe communication channel - Node 202 OK*)
		bSafeModuleOK_203 : BOOL; (*Safe communication channel - Node 203 OK*)
		bSafeModuleOK_204 : BOOL; (*Safe communication channel - Node 204 OK*)
		bSafeModuleOK_205 : BOOL; (*Safe communication channel - Node 205 OK*)
		bSafeModuleOK_206 : BOOL; (*Safe communication channel - Node 206 OK*)
		bSafeModuleOK_207 : BOOL; (*Safe communication channel - Node 207 OK*)
		bSafeModuleOK_208 : BOOL; (*Safe communication channel - Node 208 OK*)
		bSafeModuleOK_209 : BOOL; (*Safe communication channel - Node 209 OK*)
		bSafeModuleOK_210 : BOOL; (*Safe communication channel - Node 210 OK*)
		bSafeModuleOK_300 : BOOL; (*Safe communication channel - Node 300 OK*)
		bSafeModuleOK_301 : BOOL; (*Safe communication channel - Node 301 OK*)
		bSafeOUT_F01_N_DiffOK : BOOL; (*From SafetyPLC - Function 01 - Speed difference OK*)
		bSafeOUT_F01_N_Nom90 : BOOL; (*From SafetyPLC - Function 01 - Actual engine speed >= 90% of nominal speed*)
		bSafeOUT_F01_OK : BOOL; (*From SafetyPLC - Function 01 - Speed measurement OK*)
		bSafeOUT_F02_OK : BOOL; (*From SafetyPLC - Function 02 - Ignition is operating*)
		bSafeOUT_F02_OK_PC : BOOL; (*From SafetyPLC - Function 02 - Ignition plausibility check - OK*)
		bSafeOUT_F03_OK : BOOL; (*From SafetyPLC - Function 03 - Oil pressure MIN OK*)
		bSafeOUT_F03_Pr_EO_DiffOK : BOOL; (*From SafetyPLC - Function 03 - Oil pressure difference OK*)
		bSafeOUT_F04_OK : BOOL; (*From SafetyPLC - Function 04 - Oil pressure MAX OK*)
		bSafeOUT_F05_OK : BOOL; (*From SafetyPLC - Function 05 - Engine cooling water pressure MIN OK*)
		bSafeOUT_F05_Pr_ECW_DiffOK : BOOL; (*From SafetyPLC - Function 05 - Engine cooling water pressure difference OK*)
		bSafeOUT_F06_OK : BOOL; (*From SafetyPLC - Function 06 - Engine cooling water pressure MAX OK*)
		bSafeOUT_F07_GCB_RUC : BOOL; (*From SafetyPLC - Function 07 - GCB - Release undervoltage coil*)
		bSafeOUT_F07_GCB_RUC_PS : BOOL; (*From SafetyPLC - Function 07 - GCB - Release undervoltage coil - Physical state*)
		bSafeOUT_F07_OK : BOOL; (*From SafetyPLC - Function 07 - Grid disconnection OK*)
		bSafeOUT_F07_Rel_Sync_Load : BOOL; (*From SafetyPLC - Function 07 - Release synchronizing and load*)
		bSafeOUT_F07_Rel_Sync_Load_PS : BOOL; (*From SafetyPLC - Function 07 - Release synchronizing and load - Physical state*)
		bSafeOUT_F08_GenPrctTrip_OK : BOOL; (*From SafetyPLC - Function 08 - Generator protection trip OK*)
		bSafeOUT_F08_OlShortCirc_OK : BOOL; (*From SafetyPLC - Function 08 - Generator overload/short circuit OK*)
		bSafeOUT_F09_Cust_OK : BOOL; (*From SafetyPLC - Function 09 - Room ventilation operating*)
		bSafeOUT_F09_Cust_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Room ventilation plausibility check OK*)
		bSafeOUT_F09_DI_ERV_Cust : BOOL; (*From SafetyPLC - Function 09 - Room ventilation operating - Digital input*)
		bSafeOUT_F09_Door_OK : BOOL; (*From SafetyPLC - Function 09 - Doors closed*)
		bSafeOUT_F09_INL1_Fan_OK : BOOL; (*From SafetyPLC - Function 09 - Group 1 - Inlet air fan operating*)
		bSafeOUT_F09_INL1_Fan_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 1 - Inlet air fan plausibility check OK*)
		bSafeOUT_F09_INL1_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 1 - Inlet air louvre OK*)
		bSafeOUT_F09_INL1_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 1 - Inlet air louvre plausibility check OK*)
		bSafeOUT_F09_INL2_Fan_OK : BOOL; (*From SafetyPLC - Function 09 - Group 2 - Inlet air fan operating*)
		bSafeOUT_F09_INL2_Fan_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 2 - Inlet air fan plausibility check OK*)
		bSafeOUT_F09_INL2_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 2 - Inlet air louvre OK*)
		bSafeOUT_F09_INL2_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 2 - Inlet air louvre plausibility check OK*)
		bSafeOUT_F09_INL3_Fan_OK : BOOL; (*From SafetyPLC - Function 09 - Group 3 - Inlet air fan operating*)
		bSafeOUT_F09_INL3_Fan_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 3 - Inlet air fan plausibility check OK*)
		bSafeOUT_F09_INL3_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 3 - Inlet air louvre OK*)
		bSafeOUT_F09_INL3_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 3 - Inlet air louvre plausibility check OK*)
		bSafeOUT_F09_INL4_Fan_OK : BOOL; (*From SafetyPLC - Function 09 - Group 4 - Inlet air fan operating*)
		bSafeOUT_F09_INL4_Fan_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 4 - Inlet air fan plausibility check OK*)
		bSafeOUT_F09_INL4_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 4 - Inlet air louvre OK*)
		bSafeOUT_F09_INL4_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 4 - Inlet air louvre plausibility check OK*)
		bSafeOUT_F09_INL5_Fan_OK : BOOL; (*From SafetyPLC - Function 09 - Group 5 - Inlet air fan operating*)
		bSafeOUT_F09_INL5_Fan_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 5 - Inlet air fan plausibility check OK*)
		bSafeOUT_F09_INL5_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 5 - Inlet air louvre OK*)
		bSafeOUT_F09_INL5_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 5 - Inlet air louvre plausibility check OK*)
		bSafeOUT_F09_INL6_Fan_OK : BOOL; (*From SafetyPLC - Function 09 - Group 6 - Inlet air fan operating*)
		bSafeOUT_F09_INL6_Fan_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 6 - Inlet air fan plausibility check OK*)
		bSafeOUT_F09_INL6_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 6 - Inlet air louvre OK*)
		bSafeOUT_F09_INL6_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 6 - Inlet air louvre plausibility check OK*)
		bSafeOUT_F09_OTL1_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 1 - Outlet air louvre OK*)
		bSafeOUT_F09_OTL1_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 1 - Outlet air louvre plausibility check OK*)
		bSafeOUT_F09_OTL2_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 2 - Outlet air louvre OK*)
		bSafeOUT_F09_OTL2_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 2 - Outlet air louvre plausibility check OK*)
		bSafeOUT_F09_OTL3_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 3 - Outlet air louvre OK*)
		bSafeOUT_F09_OTL3_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 3 - Outlet air louvre plausibility check OK*)
		bSafeOUT_F09_OTL4_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 4 - Outlet air louvre OK*)
		bSafeOUT_F09_OTL4_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 4 - Outlet air louvre plausibility check OK*)
		bSafeOUT_F09_OTL5_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 5 - Outlet air louvre OK*)
		bSafeOUT_F09_OTL5_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 5 - Outlet air louvre plausibility check OK*)
		bSafeOUT_F09_OTL6_Lou_OK : BOOL; (*From SafetyPLC - Function 09 - Group 6 - Outlet air louvre OK*)
		bSafeOUT_F09_OTL6_Lou_OK_PC : BOOL; (*From SafetyPLC - Function 09 - Group 6 - Outlet air louvre plausibility check OK*)
		bSafeOUT_F10_DO_EmStop : BOOL; (*From SafetyPLC - Function 10 - DO Emergency stop signalling*)
		bSafeOUT_F10_DO_EmStop_PS : BOOL; (*From SafetyPLC - Function 10 - DO Emergency stop signalling - Physical state*)
		bSafeOUT_F10_EmStop_M_OK : BOOL; (*From SafetyPLC - Function 10 - Emergency stop push button - Module interface panel*)
		bSafeOUT_F10_EmStop_OK : BOOL; (*From SafetyPLC - Function 10 - Emergency stop push button*)
		bSafeOUT_F11_OK : BOOL; (*From SafetyPLC - Function 11 - RESERVE*)
		bSafeOUT_F11_SafetyLoop_A1_OK : BOOL; (*From SafetyPLC - Function 11 - Safety loop 1 - module control panel OK*)
		bSafeOUT_F11_SafetyLoop_A2_OK : BOOL; (*From SafetyPLC - Function 11 - Safety loop 2 - module control panel OK*)
		bSafeOUT_F11_SafetyLoop_M_OK : BOOL; (*From SafetyPLC - Function 11 - Safety loop - module interface panel OK*)
		bSafeOUT_F12_DCGA_OK : BOOL; (*From SafetyPLC - Function 12 - Gas supply interruption OK - DCGA (Decentral gas addition)*)
		bSafeOUT_F12_DCGA_SD_Dem : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - DCGA*)
		bSafeOUT_F12_DCGA_SD_Dem_PS : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - DCGA - Physical state*)
		bSafeOUT_F12_DI_DCGA_SafeDevOK : BOOL; (*From SafetyPLC - Function 12 - Digital Input - Gas safety device OK - DCGA*)
		bSafeOUT_F12_DI_GT1_SafeDevOK : BOOL; (*From SafetyPLC - Function 12 - Digital Input - Gas safety device OK - Gastrain 1*)
		bSafeOUT_F12_DI_GT2_SafeDevOK : BOOL; (*From SafetyPLC - Function 12 - Digital Input - Gas safety device OK - Gastrain 2*)
		bSafeOUT_F12_DI_GT3_SafeDevOK : BOOL; (*From SafetyPLC - Function 12 - Digital Input - Gas safety device OK - Gastrain 3*)
		bSafeOUT_F12_DI_GT4_SafeDevOK : BOOL; (*From SafetyPLC - Function 12 - Digital Input - Gas safety device OK - Gastrain 4*)
		bSafeOUT_F12_GT1_OK : BOOL; (*From SafetyPLC - Function 12 - Gas supply interruption OK - Gas train 1*)
		bSafeOUT_F12_GT1_SD_Dem : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - Gastrain 1*)
		bSafeOUT_F12_GT1_SD_Dem_PS : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - Gastrain 1 - Physical state*)
		bSafeOUT_F12_GT2_OK : BOOL; (*From SafetyPLC - Function 12 - Gas supply interruption OK - Gas train 2*)
		bSafeOUT_F12_GT2_SD_Dem : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - Gastrain 2*)
		bSafeOUT_F12_GT2_SD_Dem_PS : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - Gastrain 2 - Physical state*)
		bSafeOUT_F12_GT3_OK : BOOL; (*From SafetyPLC - Function 12 - Gas supply interruption OK - Gas train 3*)
		bSafeOUT_F12_GT3_SD_Dem : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - Gastrain 3*)
		bSafeOUT_F12_GT3_SD_Dem_PS : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - Gastrain 3 - Physical state*)
		bSafeOUT_F12_GT4_OK : BOOL; (*From SafetyPLC - Function 12 - Gas supply interruption OK - Gas train 4*)
		bSafeOUT_F12_GT4_SD_Dem : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - Gastrain 4*)
		bSafeOUT_F12_GT4_SD_Dem_PS : BOOL; (*From SafetyPLC - Function 12 - Demand gas safety device - Gastrain 4 - Physical state*)
		bSafeOUT_F12_Rel_GV1 : BOOL; (*From SafetyPLC - Function 12 - Gas valves from gas train 1 released*)
		bSafeOUT_F12_Rel_GV1a_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve 1a - Physical state*)
		bSafeOUT_F12_Rel_GV1b_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve 1b - Physical state*)
		bSafeOUT_F12_Rel_GV2 : BOOL; (*From SafetyPLC - Function 12 - Gas valves from gas train 2 released*)
		bSafeOUT_F12_Rel_GV2a_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve 2a - Physical state*)
		bSafeOUT_F12_Rel_GV2b_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve 2b - Physical state*)
		bSafeOUT_F12_Rel_GV3 : BOOL; (*From SafetyPLC - Function 12 - Gas valves from gas train 3 released*)
		bSafeOUT_F12_Rel_GV3a_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve 3a - Physical state*)
		bSafeOUT_F12_Rel_GV3b_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve 3b - Physical state*)
		bSafeOUT_F12_Rel_GV4 : BOOL; (*From SafetyPLC - Function 12 - Gas valves from gas train 4 released*)
		bSafeOUT_F12_Rel_GV4a_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve 4a - Physical state*)
		bSafeOUT_F12_Rel_GV4b_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve 4b - Physical state*)
		bSafeOUT_F12_Rel_GVa_DCGA_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve a for DCGA - Physical state*)
		bSafeOUT_F12_Rel_GVb_DCGA_PS : BOOL; (*From SafetyPLC - Function 12 - Gas valve b for DCGA - Physical state*)
		bSafeOUT_F12_Rel_GV_DCGA : BOOL; (*From SafetyPLC - Function 12 - Gas valves from DCGA released*)
		bSafeOUT_F16_DI_ScavFlapClosed : BOOL; (*From SafetyPLC - Function 20 - Scavenging flap closed OK*)
		bSafeOUT_F16_ScavFlapPos_OK : BOOL; (*From SafetyPLC - Function 20 - Scavenging flap position OK*)
		bSafeOUT_F16_ScavFlapPos_OK_PC : BOOL; (*From SafetyPLC - Function 20 - Scavenging flap position - plausibility check  OK*)
		bSafeOUT_F16_TS_ScavFlap_OK : BOOL; (*From SafetyPLC - Function 20 - Scavenging flap temperature switch  OK*)
		bSafeOUT_F20_FS_HWHT_Lo_DI : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water flow minimum - DI OK*)
		bSafeOUT_F20_FS_HWHT_Lo_OK : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water flow minimum OK*)
		bSafeOUT_F20_FS_HWHT_Lo_OK_PC : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water flow minimum - plausibility check OK*)
		bSafeOUT_F20_FS_HWLT_Lo_DI : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water flow minimum - DI OK*)
		bSafeOUT_F20_FS_HWLT_Lo_OK : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water flow minimum OK*)
		bSafeOUT_F20_FS_HWLT_Lo_OK_PC : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water flow minimum - plausibility check OK*)
		bSafeOUT_F20_HWcirc_Cust_OK : BOOL; (*From SafetyPLC - Function 20 - Customer heating water circuit OK*)
		bSafeOUT_F20_LS_HWHT_Lo_OK : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water level minimum OK*)
		bSafeOUT_F20_LS_HWLT_Lo_OK : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water level minimum OK*)
		bSafeOUT_F20_PS1_HWHT_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water pressure 1 maximum OK*)
		bSafeOUT_F20_PS1_HWHT_Lo_DI : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water pressure 1 minimum - DI OK*)
		bSafeOUT_F20_PS1_HWHT_Lo_OK : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water pressure 1 minimum OK*)
		bSafeOUT_F20_PS1_HWLT_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water pressure 1 maximum OK*)
		bSafeOUT_F20_PS1_HWLT_Lo_DI : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water pressure 1 minimum - DI OK*)
		bSafeOUT_F20_PS1_HWLT_Lo_OK : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water pressure 1 minimum OK*)
		bSafeOUT_F20_PS2_HWHT_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water pressure 2 maximum OK*)
		bSafeOUT_F20_PS2_HWHT_Lo_DI : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water pressure 2 minimum - DI OK*)
		bSafeOUT_F20_PS2_HWHT_Lo_OK : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water pressure 2 minimum OK*)
		bSafeOUT_F20_PS2_HWLT_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water pressure 2 maximum OK*)
		bSafeOUT_F20_PS2_HWLT_Lo_DI : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water pressure 2 minimum - DI OK*)
		bSafeOUT_F20_PS2_HWLT_Lo_OK : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water pressure 2 minimum OK*)
		bSafeOUT_F20_TS1_HWHT_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water temperature 1 maximum OK*)
		bSafeOUT_F20_TS1_HWLT_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water temperature 1 maximum OK*)
		bSafeOUT_F20_TS2_HWHT_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - High temperature heating water temperature 2 maximum OK*)
		bSafeOUT_F20_TS2_HWLT_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - Low temperature heating water temperature 2 maximum OK*)
		bSafeOUT_F21_Pr_EG_Hi_OK : BOOL; (*From SafetyPLC - Function 20 - Exhaust gas backpressure high OK*)
		bSafeOUT_F99_Rel_SF_OK : BOOL; (*From SafetyPLC - Function 99 - Release safety functions OK*)
		bSafeOUT_F99_Rel_SF_OK_A_PS : BOOL; (*From SafetyPLC - Function 99 - Release safety functions - Module control panel - Physical state*)
		bSafeOUT_F99_Rel_SF_OK_M_PS : BOOL; (*From SafetyPLC - Function 99 - Release safety functions - Module interface panel - Physical state*)
		bSafeOUT_SafetyPLC_Exist : BOOL; (*From SafetyPLC - IF hardware SL8100 exist -> SafetyPLC exist*)
		bSaveSafeOpt_Busy : BOOL;
		bSaveSafeOpt_Done : BOOL;
		bSaveSafeOpt_Error : BOOL;
		bSetSafeNodeAvail_Busy : BOOL;
		bSetSafeNodeAvail_Done : BOOL;
		bSetSafeNodeAvail_Error : BOOL;
		bSetSafeOptBool_Busy : BOOL;
		bSetSafeOptBool_Done : BOOL;
		bSetSafeOptBool_Error : BOOL;
		bSetSafeOptInt_Busy : BOOL;
		bSetSafeOptInt_Done : BOOL;
		bSetSafeOptInt_Error : BOOL;
		bTransfer_Busy : BOOL;
		bTransfer_Done : BOOL;
		bTransfer_Error : BOOL;
		iComError : DINT; (*Commissioning - Error*)
		iCompletion_StatusID : INT;
		iComStep : StepEnum; (*Commissioning - Step*)
		iConnect_PermLevel : INT;
		iConnect_SafeDomainID : INT;
		iConnect_StatusID : INT;
		iConnect_UDID_high : INT;
		iConnect_UDID_low : INT;
		iControl_StatusID : INT;
		iDownloadStep : INT;
		iExchange_StatusID : INT;
		iInfoSafeComm_CRC : INT;
		iInfoStatus_NoFWExchanged : INT;
		iInfoStatus_NoSafeNODEs : INT;
		iInfoStatus_NoSNExchanged : INT;
		iInfoStatus_OpModeState : INT;
		iInfoStatus_SafeComUnused : INT;
		iInfoStatus_SafeNodesState : INT;
		iInfoStatus_SafeOSState : INT;
		iInfoStatus_SystemState : INT;
		iInfo_StatusID : INT;
		iLoadSafeOpt_CRC : INT;
		iLoadSafeOpt_StatusID : INT;
		iNode_sPLC : UINT; (*SafetyPLC node*)
		iParaSafe_Eng_Motortype : INT; (*From SafetyPLC - PARA [15084]: Motortype*)
		iParaSafe_NrMaxErr_ERV_INL_Fan : INT; (*From SafetyPLC - PARA [15193]: Maximum allowed number of failed inlet air fans*)
		iParaSafe_NrMaxErr_ERV_INL_Lou : INT; (*From SafetyPLC - PARA [15194]: Maximum allowed number of failed inlet air louvres*)
		iParaSafe_NrMaxErr_ERV_OTL_Lou : INT; (*From SafetyPLC - PARA [15195]: Maximum allowed number of failed outlet air louvres*)
		iParaSafe_Nr_ERV_INL_Fan : INT; (*From SafetyPLC - PARA [15190]: Number of inlet air fans*)
		iParaSafe_Nr_ERV_INL_Lou : INT; (*From SafetyPLC - PARA [15191]: Number of inlet air louvres*)
		iParaSafe_Nr_ERV_OTL_Lou : INT; (*From SafetyPLC - PARA [15192]: Number of outlet air louvres*)
		iSafeOUT_F09_Nr_PC_NotDone : INT; (*From SafetyPLC - Function 09 - Number of plausibility checks not performed*)
		iSafeOUT_FwVers_sPLC : UDINT; (*From SafetyPLC - Actual firmware version*)
		iSaveSafeOpt_CRC : INT;
		iSaveSafeOpt_StatusID : INT;
		iSetSafeNodeAvail_StatusID : INT;
		iSetSafeNodeAvail_Value : INT;
		iSetSafeOptBool_StatusID : INT;
		iSetSafeOptInt_StatusID : INT;
		iSetSafeOptInt_Value : INT;
		iTransfer_Progress : INT;
		iTransfer_StatusID : INT;
		rParaSafe_DPr_ECWP_LoLo : REAL; (*From SafetyPLC - PARA [15104]: Engine cooling water pump - Difference pressure minimum [bar]*)
		rParaSafe_N_EngAct_HiHi_Diff : REAL; (*From SafetyPLC - PARA [15086]: Speed - Maximum deviation to ignition speed [rpm]*)
		rParaSafe_N_EngNom : REAL; (*From SafetyPLC - PARA [15087]: Speed - Nominal speed [rpm]*)
		rParaSafe_N_Pr_EO_LoLo_Lim1 : REAL; (*From SafetyPLC - PARA [15088]: Oil pressure - Minimum - Speed point 1 [rpm]*)
		rParaSafe_N_Pr_EO_LoLo_Lim2 : REAL; (*From SafetyPLC - PARA [15089]: Oil pressure - Minimum - Speed point 2 [rpm]*)
		rParaSafe_Pr_ECWaP_HiHi : REAL; (*From SafetyPLC - PARA [15093]: Engine cooling water pressure after pump - Maximum [mbar]*)
		rParaSafe_Pr_ECW_HiHi_Check : REAL; (*From SafetyPLC - PARA [15090]: Engine cooling water pressure - Maximum (sensor drift) [mbar]*)
		rParaSafe_Pr_ECW_HiHi_Diff : REAL; (*From SafetyPLC - PARA [15091]: Engine cooling water pressure - Maximum deviation between the sensors [mbar]*)
		rParaSafe_Pr_ECW_LoLo : REAL; (*From SafetyPLC - PARA [15092]: Engine cooling water pressure - Minimum [mbar]*)
		rParaSafe_Pr_EOaP_Diff_EngStop : REAL; (*From SafetyPLC - PARA [15100]: Oil pressure after pump - Minimum difference to standstill [mbar]*)
		rParaSafe_Pr_EOaP_HiHi : REAL; (*From SafetyPLC - PARA [15101]: Oil pressure after pump - Maximum [mbar]*)
		rParaSafe_Pr_EOaP_HiHi_EngStop : REAL; (*From SafetyPLC - PARA [15102]: Oil pressure after pump - Maximum at standstill [mbar]*)
		rParaSafe_Pr_EO_Diff_EngStop : REAL; (*From SafetyPLC - PARA [15094]: Oil pressure - Minimum difference to standstill [mbar]*)
		rParaSafe_Pr_EO_HiHi_Check : REAL; (*From SafetyPLC - PARA [15095]: Oil pressure - Maximum (sensor drift) [mbar]*)
		rParaSafe_Pr_EO_HiHi_Diff : REAL; (*From SafetyPLC - PARA [15096]: Oil pressure - Maximum deviation between the sensors [mbar]*)
		rParaSafe_Pr_EO_HiHi_EngStop : REAL; (*From SafetyPLC - PARA [15097]: Oil pressure - Maximum at standstill [mbar]*)
		rParaSafe_Pr_EO_LoLo_LimN1 : REAL; (*From SafetyPLC - PARA [15098]: Oil pressure - Minimum at speed point 1 [mbar]*)
		rParaSafe_Pr_EO_LoLo_LimN2 : REAL; (*From SafetyPLC - PARA [15099]: Oil pressure - Minimum at speed point 2 [mbar]*)
		rParaSafe_Vol_SysPurge_MinAir : REAL; (*From SafetyPLC - PARA [15106]: System purge - Minimum air volume [l]*)
		rParaSafe_Vol_SysPurge_Stroke : REAL; (*From SafetyPLC - PARA [15105]: System purge - Stroke volume per crankshaft turn [l/turn]*)
		rSafeOUT_F01_N_EngAct : REAL; (*From SafetyPLC - Function 01 - Actual engine speed [rpm]*)
		rSafeOUT_F01_N_EngAct_Diff : REAL; (*From SafetyPLC - Function 01 - Speed difference [rpm]*)
		rSafeOUT_F03_Pr_EO : REAL; (*From SafetyPLC - Function 03 - Actual oil pressure at last lubrication point [bar]*)
		rSafeOUT_F03_Pr_EO_Diff : REAL; (*From SafetyPLC - Function 03 - Oil pressure difference [bar]*)
		rSafeOUT_F03_Pr_EO_Standstill : REAL; (*From SafetyPLC - Function 03 - Oil pressure at last lubrication point - At standstill [bar]*)
		rSafeOUT_F04_Pr_EOaP : REAL; (*From SafetyPLC - Function 04 - Actual oil pressure after pump [bar]*)
		rSafeOUT_F04_Pr_EOaP_Standstill : REAL; (*From SafetyPLC - Function 04 - Oil pressure after pump - At standstill [bar]*)
		rSafeOUT_F05_Pr_ECW : REAL; (*From SafetyPLC - Function 05 - Actual engine cooling water pressure [bar]*)
		rSafeOUT_F05_Pr_ECW_Diff : REAL; (*From SafetyPLC - Function 05 - Engine cooling water pressure difference [bar]*)
		rSafeOUT_F06_Pr_ECWaP : REAL; (*From SafetyPLC - Function 06 - Actual engine cooling water pressure after pump [bar]*)
		szConnect_CurrentUser : STRING[80];
		szInfoSafeAppl_CRC : STRING[80]; (*From SafetyPLC - CRC*)
		szInfoSafeAppl_Name : STRING[80]; (*From SafetyPLC - Application name*)
		szInfoSafeAppl_TimeStamp : STRING[80]; (*From SafetyPLC - Time stamp*)
		szInfoSafeAppl_UserName : STRING[80]; (*From SafetyPLC - User name*)
		szInfoSafeComm_Name : STRING[80];
		szInfoSafeComm_TimeStamp : STRING[80];
		szInfoSafeComm_UserName : STRING[80];
		szSafeOUT_F09_CRC : STRING[80]; (*From SafetyPLC - Function 09 - CRC for ventilation*)
		szSafeOUT_F20_CRC : STRING[80]; (*From SafetyPLC - Function 20 - CRC for heating water*)
		szSetSafeNodeAvail_OptionID : STRING[80];
		szSetSafeOptBool_OptionID : STRING[80];
		szSetSafeOptInt_OptionID : STRING[80];
		tiSafeOUT_F01_N_Nom90_10s_ET : TIME; (*From SafetyPLC - Function 01 - Speed >= 90% of nominal speed - Elipsed time*)
		tiSafeOUT_F01_SDC_30s_ET : TIME; (*From SafetyPLC - Function 01 - Speed difference check - Elipsed time*)
		tiSafeOUT_F01_Standstill_1m_ET : TIME; (*From SafetyPLC - Function 01 - Speed < 80rpm - Elipsed time*)
		tiSafeOUT_F03_Pr_EO_Fr_1m_ET : TIME; (*From SafetyPLC - Function 03 - Oil pressure frozen - Elipsed time*)
		tiSafeOUT_F04_EO_PumpsOff_2m_ET : TIME; (*From SafetyPLC - Function 04 - Oil pumps off for 120s - Elipsed time*)
		tiSafeOUT_F04_Pr_EOaP_Fr_1m_ET : TIME; (*From SafetyPLC - Function 04 - Oil pressure after pump frozen - Elipsed time*)
		tiSafeOUT_F05_Pr_ECW_Fr_1m_ET : TIME; (*From SafetyPLC - Function 05 - Engine cooling water pressure frozen - Elipsed time*)
		tiSafeOUT_F06_ECW_PumpsOff_2m_ET : TIME; (*From SafetyPLC - Function 06 - Engine cooling water pumps off for 120s - Elipsed time*)
		tiSafeOUT_F06_Pr_ECWaP_Fr_1m_ET : TIME; (*From SafetyPLC - Function 06 - Engine cooling water pressure after pump frozen - Elipsed time*)
		tiSafeOUT_F07_GCB_On_10s_ET : TIME; (*From SafetyPLC - Function 07 - Generator circuit breaker ON for 10s - Elipsed time*)
		tiSafeOUT_F07_GCB_On_60s_ET : TIME; (*From SafetyPLC - Function 07 - Generator circuit breaker ON for 60s - Elipsed time*)
		tiSafeOUT_F09_Cust_OK_15s_ET : TIME; (*From SafetyPLC - Function 09 - Room ventilation not operating - Elapsed time*)
		tiSafeOUT_F09_Cust_PC_ET : TIME; (*From SafetyPLC - Function 09 - Room ventilation plausibility check - Elapsed time*)
		tiSafeOUT_F09_Door_OK_15s_ET : TIME; (*From SafetyPLC - Function 09 - Doors not closed - Elapsed time*)
		tiSafeOUT_F09_INL1_Fan_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 1 - Inlet air fan not operating - Elapsed time*)
		tiSafeOUT_F09_INL1_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 1 - Inlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_INL2_Fan_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 2 - Inlet air fan not operating - Elapsed time*)
		tiSafeOUT_F09_INL2_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 2 - Inlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_INL3_Fan_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 3 - Inlet air fan not operating - Elapsed time*)
		tiSafeOUT_F09_INL3_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 3 - Inlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_INL4_Fan_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 4 - Inlet air fan not operating - Elapsed time*)
		tiSafeOUT_F09_INL4_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 4 - Inlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_INL5_Fan_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 5 - Inlet air fan not operating - Elapsed time*)
		tiSafeOUT_F09_INL5_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 5 - Inlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_INL6_Fan_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 6 - Inlet air fan not operating - Elapsed time*)
		tiSafeOUT_F09_INL6_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 6 - Inlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_OTL1_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 1 - Outlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_OTL2_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 2 - Outlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_OTL3_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 3 - Outlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_OTL4_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 4 - Outlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_OTL5_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 5 - Outlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F09_OTL6_Lou_OK_1m_ET : TIME; (*From SafetyPLC - Function 09 - Group 6 - Outlet air louvre not OK - Elapsed time*)
		tiSafeOUT_F12_DCGA_LC_130s_ET : TIME; (*From SafetyPLC - Function 12 - DCGA - Gas leakage check 130s - Elipsed time*)
		tiSafeOUT_F12_GT1_LC_130s_ET : TIME; (*From SafetyPLC - Function 12 - Gas train 1 - Gas leakage check 130s - Elipsed time*)
		tiSafeOUT_F12_GT2_LC_130s_ET : TIME; (*From SafetyPLC - Function 12 - Gas train 2 - Gas leakage check 130s - Elipsed time*)
		tiSafeOUT_F12_GT3_LC_130s_ET : TIME; (*From SafetyPLC - Function 12 - Gas train 3 - Gas leakage check 130s - Elipsed time*)
		tiSafeOUT_F12_GT4_LC_130s_ET : TIME; (*From SafetyPLC - Function 12 - Gas train 4 - Gas leakage check 130s - Elipsed time*)
		tiSafeOUT_F12_GV_Open_60s_ET : TIME; (*From SafetyPLC - Function 12 - Gas valves open for 60s - Elipsed time*)
		tiSafeOUT_F16_ScavFlapPos_PC_ET : TIME; (*From SafetyPLC - Function 20 - Scavenging flap position - plausibility check - Elipsed time OK*)
		tiSafeOUT_F20_FS_HWHT_Lo_OK_ET : TIME; (*From SafetyPLC - Function 20 - High temperature heating water flow minimum - Elipsed time OK*)
		tiSafeOUT_F20_FS_HWHT_Lo_PC_ET : TIME; (*From SafetyPLC - Function 20 - High temperature heating water flow minimum - plausibility check - Elipsed time OK*)
		tiSafeOUT_F20_FS_HWLT_Lo_OK_ET : TIME; (*From SafetyPLC - Function 20 - Low temperature heating water flow minimum - Elipsed time OK*)
		tiSafeOUT_F20_FS_HWLT_Lo_PC_ET : TIME; (*From SafetyPLC - Function 20 - Low temperature heating water flow minimum - plausibility check - Elipsed time OK*)
		tiSafeOUT_F20_PS1_HWHT_Lo_OK_ET : TIME; (*From SafetyPLC - Function 20 - High temperature heating water pressure 1 minimum - Elipsed time OK*)
		tiSafeOUT_F20_PS1_HWLT_Lo_OK_ET : TIME; (*From SafetyPLC - Function 20 - Low temperature heating water pressure 1 minimum - Elipsed time OK*)
		tiSafeOUT_F20_PS2_HWHT_Lo_OK_ET : TIME; (*From SafetyPLC - Function 20 - High temperature heating water pressure 2 minimum - Elipsed time OK*)
		tiSafeOUT_F20_PS2_HWLT_Lo_OK_ET : TIME; (*From SafetyPLC - Function 20 - Low temperature heating water pressure 2 minimum - Elipsed time OK*)
	END_STRUCT;
	VIS2MM_sPLC_struct : 	STRUCT 
		bComDataCorrect : BOOL; (*Commissioning - Acknowledge data read from SafeDOMAIN is correct*)
		bComStartCmd : BOOL; (*Commissioning - Start command*)
		bConnect_UDID_Ack : BOOL;
		bControl_Execute_Dem : BOOL;
		bControl_Reboot_sPLC_Dem : BOOL; (*Demand - Reboot of SafetyPLC*)
		bExchange_Ack : BOOL;
		szConnect_UserName : STRING[80]; (*User Name*)
		szConnect_UserPassword : STRING[80]; (*User Password*)
	END_STRUCT;
	StepEnum : 
		( (*Steps for safety PLC commissioning*)
		WAIT,
		CONNECT, (*Connection to the SafeDOMAIN*)
		LOAD_FILE, (*Load SafeCOMMISSIONING file*)
		PARA_SET, (*Set parameters to SafeCOMMISSIONING file*)
		NODE_AV, (*Set node availability to SafeCOMMISSIONING file*)
		SAVE_FILE, (*Save SafeCOMMISSIONING file*)
		TRANSFER, (*Transfer the SafeAPPLICATION and SafeCOMMISSIONING to the SafeDOMAIN*)
		READ_INFO, (*Read information from the SafeDOMAIN*)
		WAIT_ACK, (*Wait for acknowledgment*)
		COMPLETION, (*Completion Download*)
		DISCONNECT (*Disconnect from the SafeDOMAIN*)
		);
END_TYPE
