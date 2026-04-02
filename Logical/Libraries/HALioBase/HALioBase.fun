(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: HALioBase
 * File: HALioBase.fun
 * Author: froehlichw
 * Created: October 03, 2011
 ********************************************************************
 * Functions and function blocks of library HALioBase
 *
 * History:
 * 05.01.2012  V0.00.0 froehlichw
 *      (new)  created
 * 02.02.2022  V0.21.0 Schmid
 *    (added)  Reset
 *             in HALioFilter, HALioFilterR
 * 25.01.2023  V0.22.0 Perktold
 *    (added)  TaskClass and CycleTimeMs in HALioSignal
 *    (change) Filter from UINT to REAL in HALioFilterR
 *    (added)  evalHALioSignal
 ********************************************************************)

FUNCTION_BLOCK HALioCfg (* configurates inputs of HALioSignal *)
	VAR_INPUT
		enable : BOOL;
		pCfgModDevice : UDINT;
		pCfgModName : UDINT;
		pAppModName : UDINT;
		pHALioSignal : UDINT;
		MaxNumIoChannels : UINT;
	END_VAR
	VAR_OUTPUT
		ParOK : BOOL;
		ActNumIoChannels : UINT;
		CfgModError : BOOL;
		pErrInfo1 : UDINT;
		pErrInfo2 : UDINT;
		pErrInfo3 : UDINT;
		status : UINT;
	END_VAR
	VAR
		stepFub : HALioFubStep_Enum;
		para : HALioReaderPara_Type;
		HALioSignal_0 : REFERENCE TO HALioSignal;
		DatObjInfo_0 : DatObjInfo;
		xmlCreateMemoryReader_0 : xmlCreateMemoryReader;
		xmlReadNextNode_0 : xmlReadNextNode;
		xmlReadAttributeNr_0 : xmlReadAttributeNr;
		xmlCloseMemoryReader_0 : xmlCloseMemoryReader;
		nextAdr : UDINT;
		pEmptyString : UDINT;
		pvName : STRING[99];
		strErrNb : STRING[15];
		status_PV_xgetadr : UINT;
		strLen : UINT;
		strLenMax : UINT;
		Type : UINT;
		iVal : DINT;
		rVal : REAL;
		pVal : REFERENCE TO USINT;
		sigAi : HALioAi_Type;
		sigAi_INT : HALioAi_INT_Type;
		sigAo : HALioAo_Type;
		sigDi : HALioDi_Type;
		sigDo : HALioDo_Type;
		sigExtPar : HALioExtern_Type;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK HALioSignal (* signal processing *)
	VAR_INPUT
		ParOK : BOOL;
		HwOK : BOOL;
		Active : BOOL;
		Type : UINT;
		Qual_Min : INT;
		Qual_Max : INT;
		Scal_X1 : DINT;
		Scal_X2 : DINT;
		Scal_Y1 : REAL;
		Scal_Y2 : REAL;
		Filter : UINT;
		pExtern : UDINT;
		pPV_Name : UDINT;
		pMsg : UDINT;
		pSignal : UDINT;
		TaskClass : UDINT;
		CycleTimeMs : REAL;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		sigAi : REFERENCE TO HALioAi_Type;
		sigAi_INT : REFERENCE TO HALioAi_INT_Type;
		sigAo : REFERENCE TO HALioAo_Type;
		sigDi : REFERENCE TO HALioDi_Type;
		sigDo : REFERENCE TO HALioDo_Type;
		ain : REFERENCE TO INT;
		ain_INT8 : REFERENCE TO SINT;
		ain_INT16 : REFERENCE TO INT;
		ain_INT32 : REFERENCE TO DINT;
		ainVal : DINT;
		aout : REFERENCE TO INT;
		din : REFERENCE TO BOOL;
		dout : REFERENCE TO BOOL;
		msg : REFERENCE TO BOOL;
		isInput : BOOL;
		isOutput : BOOL;
		aiMinMax : BOOL;
		extPar : REFERENCE TO HALioExtern_Type;
		parUse : HALioExtern_Type;
		HALioFilter_0 : HALioFilter;
		HALioFilterR_0 : HALioFilterR;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK HALioFilter (* filter with PT1 behaivior and DINT in/output *)
	VAR_INPUT
		In : DINT;
		Filter : UINT;
		Reset : BOOL;
	END_VAR
	VAR_OUTPUT
		Out : DINT;
	END_VAR
	VAR
		mw : DINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK HALioFilterR (* filter with PT1 behaivior and REAL in/output *)
	VAR_INPUT
		In : REAL;
		Filter : REAL;
		Reset : BOOL;
	END_VAR
	VAR_OUTPUT
		Out : REAL;
	END_VAR
	VAR
		mw : LREAL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION HALioSigscal : DINT (* signal scaling In DINT / Out DINT *)
	VAR_INPUT
		In : DINT;
		X1 : DINT;
		X2 : DINT;
		Y1 : DINT;
		Y2 : DINT;
	END_VAR
END_FUNCTION

FUNCTION HALioSigscalR : REAL (* signal scaling In DINT / Out REAL *)
	VAR_INPUT
		In : DINT;
		X1 : DINT;
		X2 : DINT;
		Y1 : REAL;
		Y2 : REAL;
	END_VAR
END_FUNCTION

FUNCTION HALioSigscalRInv : DINT (* signal scaling In REAL / Out DINT *)
	VAR_INPUT
		In : REAL;
		X1 : REAL;
		X2 : REAL;
		Y1 : DINT;
		Y2 : DINT;
	END_VAR
END_FUNCTION

FUNCTION evalHALioSignal : UINT (*evaluate IO signal*)
	VAR_INPUT
		ParOK : BOOL;
		HwOK : BOOL;
		ActNumIoChannels : UINT;
		CycleTimeMs : REAL;
	END_VAR
	VAR_IN_OUT
		xHALioSignal : ARRAY[0..1299] OF HALioSignal;
		SignalError : UINT;
		SignalErrorIdx : UINT;
	END_VAR
	VAR
		idx : UINT;
	END_VAR
END_FUNCTION
