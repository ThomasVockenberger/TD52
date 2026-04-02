
FUNCTION_BLOCK CreateSystemInfo
	VAR_INPUT
		Enable : BOOL;
		SearchMode : UDINT;
		SearchModuleType : USINT;
		AddModes : USINT;
	END_VAR
	VAR_OUTPUT
		NbModuleGroups : UINT;
		Ident : UDINT;
		Status : UINT;
		ErrAddInfo : MDiagErrAddInfo_typ;
	END_VAR
	VAR
		CreateInfoStep : UINT;
		ErrorStep : UINT;
		ErrorStatus : UINT;
		WarningStatus : UINT;
		Index : UDINT;
		InfoCode : UINT;
		DatenStr : STRING[80];
		ActModule : MDiagInfoGeneralInternal_typ;
		OldModule : MDiagInfoGeneralInternal_typ;
		EnEvaluation : BOOL;
		TmpPathStr : STRING[80];
		TmpCmpPathStr : STRING[80];
		TmpDPStr : STRING[80];
		TmpDPPathStr : STRING[80];
		PathChange : UINT;
		MaxPathChange : UINT;
		NewModGrp : BOOL;
		NewModule : BOOL;
		ModGrpLimitReached : BOOL;
		ModIdxLimitReached : BOOL;
		ModGrpCounter : UINT;
		ModIdxCounter : UINT;
		NbModules : UINT;
		ModuleFound : BOOL;
		NbDPsTotal : UINT;
		DPCounter : UINT;
		ActSeperator : INT;
		NewSeperator : INT;
		FirstSeperator : INT;
		LastSeperator : INT;
		pMemModGrpInfoData : UDINT;
		MemLenModGrpInfoData : UDINT;
		MemOffsetModGrpInfoData : UDINT;
		dynModGrpInfoData : REFERENCE TO MDiagModGrpInfoInternal_typ;
		pTmpMemModDiagData : UDINT;
		TmpMemLenModDiagData : UDINT;
		TmpMemOffsetModDiagData : UDINT;
		dynModuleDiagData : REFERENCE TO MDiagDataInternal_typ;
		StatusTMPalloc : UINT;
		StatusTMPfree : UINT;
		Shift : BOOL;
		DiagCreateInfo_0 : DiagCreateInfo;
		SafeLogicFound : BOOL;
		DiagGetStrInfo_0 : DiagGetStrInfo;
		DiagGetNumInfo_0 : DiagGetNumInfo;
		DiagDisposeInfo_0 : DiagDisposeInfo;
		AsIOListDP_0 : AsIOListDP;
		i : UINT;
		j : UINT;
		zzEdge00000 : BOOL;
		MDTest : ARRAY[0..9] OF USINT;
	END_VAR
	VAR CONSTANT
		asdiagHARDWARE_MODULE_NAME : UDINT := 1006;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK GetModuleGroupInfo
	VAR_INPUT
		Enable : BOOL;
		Ident : UDINT;
		ModuleGroupIndex : UINT;
	END_VAR
	VAR_OUTPUT
		ModuleGroupInfo : MDiagModGrpInfo_typ;
		Status : UINT;
	END_VAR
	VAR
		pMemModGrpInfoData : UDINT;
		MemOffsetModGrpInfoData : UDINT;
		dynModGrpInfoData : REFERENCE TO MDiagModGrpInfoInternal_typ;
		dynModuleDiagData : REFERENCE TO MDiagDataInternal_typ;
		TmpPathStr : STRING[80];
		TmpNodeStr : STRING[80];
		TmpNodeStrLen : INT;
		NodeNrFound : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK GetModuleInfo
	VAR_INPUT
		Enable : BOOL;
		Ident : UDINT;
		ModuleGroupIndex : UINT;
		ModuleIndex : UINT;
	END_VAR
	VAR_OUTPUT
		ModuleInfo : MDiagModInfo_typ;
		Status : UINT;
	END_VAR
	VAR
		pMemModGrpInfoData : UDINT;
		MemOffsetModGrpInfoData : UDINT;
		MemOffsetModDiagData : UDINT;
		dynModGrpInfoData : REFERENCE TO MDiagModGrpInfoInternal_typ;
		dynModuleDiagData : REFERENCE TO MDiagDataInternal_typ;
		NbModules : UINT;
		TmpPathStr : STRING[80];
		TmpSlotStr : STRING[80];
		TmpSlotStrLen : INT;
		SlotNrFound : BOOL;
		GetModInfoStep : UINT;
		AsIODPStatus_0 : AsIODPStatus;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK DPHandler
	VAR_INPUT
		Enable : BOOL;
		Ident : UDINT;
		ModuleGroupIndex : UINT;
		ModuleIndex : UINT;
		DPNo : USINT;
		pDPHandleData : UDINT;
		SizeDPHandleData : UDINT;
		pGlobalForceOff : UDINT;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		DPHandlerStep : UINT;
		pMemModGrpInfoData : UDINT;
		MemOffsetModGrpInfoData : UDINT;
		dynModGrpInfoData : REFERENCE TO MDiagModGrpInfoInternal_typ;
		dynModuleDiagData : REFERENCE TO MDiagDataInternal_typ;
		dynGlobalForceOff : REFERENCE TO BOOL;
		NbModules : UINT;
		MemOffsetModDiagData : UDINT;
		NbDPEntries : UINT;
		DPCounter : UINT;
		DPNoAbs : UINT;
		dynDPData : REFERENCE TO MDiagDPData_typ;
		DPHandleDataOffset : UDINT;
		DPDataLengthBit : USINT;
		i : UINT;
		NewSeperator : INT;
		TmpStrPos : INT;
		TmpValue : USINT;
		TmpStr : STRING[80];
		TmpStrValueBin : STRING[80];
		TmpStrValueHex : STRING[80];
		AsIODPStatus_0 : AsIODPStatus;
		AsIOEnableForcing_0 : AsIOEnableForcing;
		AsIODisableForcing_0 : AsIODisableForcing;
		AsIOSetForceValue_0 : AsIOSetForceValue;
		AsIOGlobalDisableForcing_0 : AsIOGlobalDisableForcing;
		EntryMode : USINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK GetPVInfo
	VAR_INPUT
		Enable : BOOL;
		Ident : UDINT;
		PVSearchMode : USINT;
		PVIndex : UDINT;
		ModuleGroupIndex : UINT;
		ModuleIndex : UINT;
		DPNo : USINT;
		pDPName : UDINT;
		SizeDPName : UDINT;
		pPVName : UDINT;
		SizePVName : UDINT;
		pPVContext : UDINT;
		SizePVContext : UDINT;
	END_VAR
	VAR_OUTPUT
		PVAdress : UDINT;
		PVType : USINT;
		PVIndexNext : UDINT;
		PVState : USINT;
		Status : UINT;
	END_VAR
	VAR
		PVInfoStep : UINT;
		pMemModGrpInfoData : UDINT;
		MemOffsetModGrpInfoData : UDINT;
		dynModGrpInfoData : REFERENCE TO MDiagModGrpInfoInternal_typ;
		dynModuleDiagData : REFERENCE TO MDiagDataInternal_typ;
		NbModules : UINT;
		MemOffsetModDiagData : UDINT;
		TmpChar : REFERENCE TO USINT;
		AsIOPVInfo_0 : AsIOPVInfo;
		TmpPVLen : UDINT;
		TmpPVDim : UINT;
		StatusInt : UINT;
		TmpStr : STRING[80];
		NewSeperator : INT;
		IntDPNo : USINT;
		IntModIdx : UINT;
		IntModGrpIdx : UINT;
		IntPVIdx : USINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION ReleaseGroupMem : UINT
	VAR_INPUT
		pIdent : UDINT;
	END_VAR
	VAR
		pMemModGrpInfoData : REFERENCE TO UDINT;
		MemOffsetModGrpInfoData : UDINT;
		dynModGrpInfoData : REFERENCE TO MDiagModGrpInfoInternal_typ;
		StatusTMPfree : UINT;
		i : UINT;
	END_VAR
END_FUNCTION
