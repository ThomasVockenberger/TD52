
TYPE
	MDiagAddModuleInfo_typ : 	STRUCT 
		BusModuleId : UDINT;
		ModeOfOperation : UDINT;
		ModeOfOperationChangeTime : UDINT;
		NrOfInits : UDINT;
		NrOfInitsChangeTime : UDINT;
		NrOfResets : UDINT;
		NrOfResetsChangeTime : UDINT;
		NrOfFwUpdates : UDINT;
		NrOfFwUpdatesChangeTime : UDINT;
		ModuleNoComm : UDINT;
		ModuleNoCommChangeTime : UDINT;
		ModuleCommError : UDINT;
		ModuleCommErrorChangeTime : UDINT;
	END_STRUCT;
	MDiagDPData_typ : 	STRUCT 
		Name : STRING[32];
		ValueTextDec : STRING[12];
		ValueTextHex : STRING[12];
		ValueTextBin : STRING[44];
		Value : UDINT;
		DefaultValue : UDINT;
		ForceValue : UDINT;
		ForceOn : BOOL;
		ForceNew : BOOL;
		ForceActive : BOOL;
		DPActive : BOOL;
		RealDatatype : USINT;
		IOType : USINT;
	END_STRUCT;
	MDiagInfoGeneralInternal_typ : 	STRUCT 
		Path : STRING[40];
		OrderCodeConfig : STRING[20];
		OrderCodePlug : STRING[20];
		Bussystem : STRING[10];
		FamilyCode : USINT;
		UseType : USINT;
		State : USINT;
		ModuleNo : USINT;
		HWModulName : STRING[40];
	END_STRUCT;
	MDiagInfoServiceDPInternal_typ : 	STRUCT 
		DP_Serialnr : STRING[60];
		DP_ModuleID : STRING[60];
		DP_HWVariant : STRING[60];
		DP_FWVersion : STRING[60];
		AddServiceDP : MDiagInfoAddServiceDPIntern_typ;
	END_STRUCT;
	MDiagInfoCyclicDPInternal_typ : 	STRUCT 
		NbDPs : UINT;
		DP_IOs : ARRAY[0..100]OF STRING[80];
	END_STRUCT;
	MDiagDataInternal_typ : 	STRUCT 
		InfoGeneral : MDiagInfoGeneralInternal_typ;
		InfoServiceDP : MDiagInfoServiceDPInternal_typ;
		InfoCyclicDP : MDiagInfoCyclicDPInternal_typ;
	END_STRUCT;
	MDiagErrAddInfo_typ : 	STRUCT 
		ErrorText : STRING[80];
	END_STRUCT;
	MDiagModGrpInfoInternal_typ : 	STRUCT 
		pMem : UDINT;
		MemLen : UDINT;
	END_STRUCT;
	MDiagModGrpInfo_typ : 	STRUCT 
		NbModules : UINT;
		NodeNr : UINT;
		Name : STRING[20];
	END_STRUCT;
	MDiagInfoAddServiceDPIntern_typ : 	STRUCT 
		DP_BusModuleId : STRING[60];
		DP_ModeOfOperation : STRING[60];
		DP_ModeOfOperationChangeTime : STRING[60];
		DP_NrOfInits : STRING[60];
		DP_NrOfInitsChangeTime : STRING[60];
		DP_NrOfResets : STRING[60];
		DP_NrOfResetsChangeTime : STRING[60];
		DP_NrOfFwUpdates : STRING[60];
		DP_NrOfFwUpdatesChangeTime : STRING[60];
		DP_ModuleNoComm : STRING[60];
		DP_ModuleNoCommChangeTime : STRING[60];
		DP_ModuleCommError : STRING[60];
		DP_ModuleCommErrorChangeTime : STRING[60];
	END_STRUCT;
	MDiagModInfo_typ : 	STRUCT 
		Name : STRING[40];
		Path : STRING[40];
		SerialNr : UDINT;
		ModuleID : UDINT;
		HWVariant : UDINT;
		FWVersion : UDINT;
		SlotNr : USINT;
		SubslotNr : USINT;
		State : USINT;
		NbDatapoints : USINT;
		NameConfigured : STRING[40];
		NamePlugged : STRING[40];
		AddInfo : MDiagAddModuleInfo_typ;
	END_STRUCT;
END_TYPE
