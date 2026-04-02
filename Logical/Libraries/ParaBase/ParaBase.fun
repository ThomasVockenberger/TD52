
FUNCTION GetModuleCode : UDINT
	VAR_INPUT
		NameStringAdr : UDINT;
	END_VAR
	VAR CONSTANT
		ParaFUB_InAdr_Err : UDINT := 333333; (*error code: IN ADRESS IS MISSING*)
	END_VAR
END_FUNCTION

FUNCTION GetModuleName : UDINT (*FEHLT NOCH! (STRING[2] geht nicht?*)
	VAR_INPUT
	END_VAR
END_FUNCTION

FUNCTION DataCheckSumm : DINT
	VAR_INPUT
		tiEnableTime : DINT; (*FUNCTION ENABLE with >0; optional other values than 1 may be used  for error state returns*)
		iDataAdr : UDINT;
		iDataLenght : UDINT;
		iModuleCode : DINT; (*IN/OUT*)
	END_VAR
	VAR
		ulChecksum1 : UDINT;
		ulChecksum2 : UDINT;
		ulChecksum3 : UDINT;
		ulChkValue : UDINT;
		ulPMPointer : UDINT;
	END_VAR
	VAR CONSTANT
		ParaFUB_InAdr_Err : UDINT := 333333; (*error code: IN ADRESS IS MISSING*)
	END_VAR
END_FUNCTION

FUNCTION_BLOCK ParaCheckFUB (*FUB to check parameter value to be withhin defined range*)
	VAR_INPUT
		Enable : BOOL; (*Paracheck FUB enable*)
		Para : REAL; (*Adress of common modulecheck input object*)
		ParaRangeMIN : REAL; (*minimum value for parameter to check*)
		ParaRangeMAX : REAL; (*maximum value for parameter to check*)
		_ParaSysAdr : UDINT; (*internal*)
	END_VAR
	VAR_OUTPUT
		_ParaState : UDINT; (*debug info only; NORMALY USE OUTPUTS in  struct MM2ParaBase, e.g. .bMyParaSetupOk*)
	END_VAR
	VAR
		_tParaSys : REFERENCE TO ParaHandler_typ; (*internal (containing MM2ParaBase and ParaBase2MM Structures)*)
		_bAdressErr : BOOL; (*internal*)
	END_VAR
	VAR CONSTANT
		ParaFUB_SysAdr_Err : UDINT := 555555; (*error code: SYS ADRESS IS MISSING*)
		ParaFUB_SysRun_Err : UDINT := 888888; (*error code: necessary precondition to do ParaCheck is missing*)
		ParaFUB_Disabeled_Err : UDINT := 999999; (*error code: FUNCTION DISABELED *)
	END_VAR
END_FUNCTION_BLOCK
