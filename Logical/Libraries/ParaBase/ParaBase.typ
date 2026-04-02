
TYPE
	MM2ParaBase_type : 	STRUCT 
		bMySys_Run : BOOL; (*module is loaded and running on plc*)
		bMyParaSetupOk : BOOL; (*Modul confirms its OWN parameter to be OK with TRUE; USED FOR PERMANENT PART MODULES*)
		bMyParaMissing : BOOL; (*optional- Modul can indicate essentilal parameter errors with this bit to ParaBase (normaly the inversion of bMyParaSetupOk)  USE FOR FLEXIBLE PART MODULES*)
		bModuleMandatory : BOOL; (*optional- TRUE on this bit signals the ParaBase system, that engine operation is not allowed without this modules parameter OK (=change module to PERMANENT PART)*)
		iMyOwnModuleID : UDINT; (*Module ID code of a module with mandatory parameter missing*)
		iMyErrorInfo : UDINT; (*error status output of this single module*)
		iMyStateInfo : DINT; (*status output of this single module*)
		tMyProg_Vers : Revision_type; (*replacement for prog_vers, for this single module*)
		tClaimVisVersion : Revision_type; (*corequisite VISU version for this module*)
		iPermStatus : DINT; (*V4.06 - Debug Information: positive= checked perm items or files, negative= missed check info*)
		bPermSetupOk : BOOL; (*V4.06 - confirms (MODULE OWN) permanent data to be OK *)
	END_STRUCT;
	ParaBase2MM_type : 	STRUCT 
		bParaSetupOk : BOOL; (*ALL mandatory modules signaled PARAMETER OK*)
		bSys_Run : BOOL; (*ALL modules are loaded and running on plc*)
		bDownloadDetected : BOOL; (*a program download was detected since last reboot, so paramter values may have been compromised and will not be stored*)
		bSaveParaAllowed : BOOL; (*no problems in parameter module, cyclic parameter saving is active*)
		bParaMissing : BOOL; (*Any mandatory module failed to confirm parameter OK status*)
		bParaWarning : BOOL; (*Any minor module failed to confirm parameter OK status*)
		iProg_Vers_Min : UDINT; (*replacement for prog_vers, LOWEST single module version*)
		iProg_Vers_Max : UDINT; (*info: max. prog_vers (to confirm newest update)*)
		iParaBaseExtensionAdress : UDINT; (*optional: prepared access point for unlisted modules*)
		iParaBaseExtensionCommand : UDINT; (*optional: prepared access point for unlisted modules*)
	END_STRUCT;
	ParaHandler_typ : 	STRUCT 
		szMetaModuleName : STRING[2];
		bParaSetupOk : BOOL; (*confirms (OWN) parameter to be OK *)
		bThisParaCheckdOk : BOOL; (*confirms the actual selected parameter to be OK *)
		iParaOkChecked : UDINT; (*Debug Information: positive checked parameter lines*)
		tParaBase2MM : ParaBase2MM_type;
		tMM2ParaBase : MM2ParaBase_type;
	END_STRUCT;
	Revision_type : 	STRUCT 
		xx : USINT; (*MAIN VERSION with HARD COMPATIBILE INTERFACE AREA*)
		yy : USINT; (*Versions with DOWNWARDS COMPATIBLE Interface*)
		zz : USINT; (*Version with internal changes only. NO INTERFACE CHANGES*)
		cc : USINT; (*cc=customized version*)
		aaaaa : UDINT; (*(optional) Build Number for exact revision reference OR for basisupdate versions*)
	END_STRUCT;
	ModuleInfo_type : 	STRUCT 
		szMetaModuleName : STRING[2];
		bSysRun : BOOL; (*module states to be running*)
		bParaSetupOk : BOOL; (*confirms (MODULE OWN) parameter to be OK *)
		bModuleMandatory : BOOL; (*True= actualy NO engine operation without this module ok*)
		bModuleDownloadDetected : BOOL; (*True= download detected (module parameter relevant)*)
		iParaOkChecked : DINT; (*Debug Information: positive checked parameter lines V4,06 DINT replaces UDINT*)
		tRevision : Revision_type; (*xx.yy.cc.zz(.aaaaa) and BU*)
		tMM2ParaBase : MM2ParaBase_type; (*internal*)
	END_STRUCT;
	ParaCommand : 
		(
		eSaveDataObjContentNow := 1,
		eRestoreDataObjContent := 2,
		eRestoreBackupDataObj := 3, (*Old! Do not use anymore, command is no longer supported*)
		eDeleteBackupDataObj := 4, (*Old! Do not use anymore, command is no longer supported*)
		eReadOutMETAContentNow := 5, (*fromV4.4*)
		eClearParaCommands := 8,
		eClearParaErrors := 9
		);
END_TYPE
