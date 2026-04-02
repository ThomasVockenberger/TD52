(*PlantCommunication Diagnostic Structures*)

TYPE
	DiagClient_Struct : 	STRUCT  (*ANSL Client Diagnostics Data*)
		Conn : UDINT;
		ConnErr : UDINT;
		TimeStamp : AsANSLTimeStampType;
	END_STRUCT;
	DiagConn_Struct : 	STRUCT  (*ANSL Connection Diagnostics Data*)
		Err : UDINT;
		PvWrite : UDINT;
		PvWriteErr : UDINT;
		PvReadErr : UDINT;
		RedConnActIpAddr : UDINT;
		RedConnAct : UDINT;
		RedConnState : UDINT;
	END_STRUCT;
END_TYPE

(*PlantCommunication Data Structures*)

TYPE
	tData_E2M_100ms_Struct : 	STRUCT  (*Slow Data sent from Engine to Master*)
		digitalSignals : ARRAY[0..iDigArrayMax100ms]OF tDigitalSignal_Struct; (*Digital Outputs with GoodQual*)
		analogSignals : ARRAY[0..iAnaArrayMax100ms]OF tAnalogSignal_Struct; (*Analog Inputs with GoodQual*)
	END_STRUCT;
	tData_M2E_100ms_Struct : 	STRUCT  (*Slow Data sent from Master to Engine*)
		digitalSignals : ARRAY[0..iDigArrayMax100ms]OF tDigitalSignal_Struct; (*Digital Inputs with GoodQual*)
		analogSignals : ARRAY[0..iAnaArrayMax100ms]OF tAnalogSignal_Struct; (*Analog Inputs with GoodQual*)
	END_STRUCT;
	tData_E2E_100ms_Struct : 	STRUCT  (*Slow Data set from Engine to Engine*)
		digitalSignals : ARRAY[0..iDigArrayMax100ms]OF tDigitalSignal_Struct; (*Digital Signals with GoodQual*)
		analogSignals : ARRAY[0..iAnaArrayMax100ms]OF tAnalogSignal_Struct; (*Analog Signals with GoodQual*)
	END_STRUCT;
	tData_E2M_10ms_Struct : 	STRUCT  (*Fast Data sent from Engine to Master*)
		digitalSignals : ARRAY[0..iDigArrayMax10ms]OF tDigitalSignal_Struct; (*Digital Outputs with GoodQual*)
		analogSignals : ARRAY[0..iAnaArrayMax10ms]OF tAnalogSignal_Struct; (*Analog Inputs with GoodQual*)
	END_STRUCT;
	tData_M2E_10ms_Struct : 	STRUCT  (*Fast Data sent from Master to Engine*)
		digitalSignals : ARRAY[0..iDigArrayMax10ms]OF tDigitalSignal_Struct; (*Digital Inputs with GoodQual*)
		analogSignals : ARRAY[0..iAnaArrayMax10ms]OF tAnalogSignal_Struct; (*Analog Inputs with GoodQual*)
	END_STRUCT;
	tData_E2E_10ms_Struct : 	STRUCT  (*Fast Data set from Engine to Engine*)
		digitalSignals : ARRAY[0..iDigArrayMax10ms]OF tDigitalSignal_Struct; (*Digital Signals with GoodQual*)
		analogSignals : ARRAY[0..iAnaArrayMax10ms]OF tAnalogSignal_Struct; (*Analog Signals with GoodQual*)
	END_STRUCT;
	tHmiDiagnosticData : 	STRUCT  (*HMI Diagnostics Data*)
		bDigForceActive : ARRAY[0..iDigArrayMaxAll]OF BOOL;
		bAnaForceActive : ARRAY[0..iAnaArrayMaxAll]OF BOOL;
		rForceValue : ARRAY[0..iAnaArrayMaxAll]OF REAL;
		bForceValue : ARRAY[0..iDigArrayMaxAll]OF BOOL;
		iCommentNr : USINT;
		iNum_ForcedValues : USINT;
	END_STRUCT;
	tPlantComData_EngEng_Struct : 	STRUCT  (*Data shared between the Engines*)
		digitalSignals : ARRAY[0..iDigArrayMaxAll]OF tDigitalSignal_Struct;
		analogSignals : ARRAY[0..iAnaArrayMaxAll]OF tAnalogSignal_Struct;
	END_STRUCT;
	tPlantComData_EngMas_Struct : 	STRUCT  (*Data shared between the Master and the Engines*)
		digitalSignals : ARRAY[0..iDigArrayMaxAll]OF tDigitalSignal_Struct;
		analogSignals : ARRAY[0..iAnaArrayMaxAll]OF tAnalogSignal_Struct;
	END_STRUCT;
	tPlantComActive_EngEng_Struct : 	STRUCT 
		digitalSignalActive : ARRAY[0..iDigArrayMaxAll]OF BOOL;
		analogSignalActive : ARRAY[0..iAnaArrayMaxAll]OF BOOL;
	END_STRUCT;
	tPlantComActive_EngMas_Struct : 	STRUCT 
		digitalSignalActive : ARRAY[0..iDigArrayMaxAll]OF BOOL;
		analogSignalActive : ARRAY[0..iAnaArrayMaxAll]OF BOOL;
	END_STRUCT;
END_TYPE
