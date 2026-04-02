
TYPE
	tHmiDiagnosticVariables : 	STRUCT  (*Holds variables needed for the HMI Force Screen Logic*)
		rInternalSignals : ARRAY[0..15]OF REAL;
		rExternalSignals : ARRAY[0..15]OF REAL;
		iIO_Typ : USINT;
		iIO_Typ_Dir : USINT;
		iIO_Typ_Dir_Num : USINT;
		iStartIdx : USINT;
		bForceActive : ARRAY[0..15]OF REAL;
		iDisplayNr : ARRAY[0..15]OF USINT;
		rForceValue : ARRAY[0..15]OF REAL;
		iCommentNr : UINT;
		iForcedValueCntGlobal : USINT;
		iAnaSigCntE2E : USINT;
		iDiagTableSize : USINT;
		iAnaSigCntE2M : USINT;
		iDigSigCntE2M : USINT;
		iDigSigCntE2E : USINT;
		iCommentOffset : UINT;
		bSelectionChange : BOOL;
		iForcedValueCntAsset_HMI : USINT;
	END_STRUCT;
END_TYPE
