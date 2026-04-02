(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: ParaBase
 * File: ParaBase.st
 * Author: zengerer
 * Created: August 01, 2012
 * V 0.12 2012-09-27 Ze,  Bugfix in bMyParaSetupOk 
 * V 3.90 2013-03-22 Ze	  Type declarations
 * V 4.13 2023-11-20 Ze	  FUNCTION DataCheckSumm
 ********************************************************************
 
 *-------------------------------------------------------------------
 * Implementation of library ParaBase
 ********************************************************************) 

(* Get module number coded from the 2-character module name *)
FUNCTION GetModuleCode
	IF NameStringAdr > 0 THEN
		(*get module code number from first 2 characters of module name*)
		memcpy(ADR(GetModuleCode), NameStringAdr,2); 		(*copy first 2 characters from clear text name to (ASCII) module code  *)
	ELSE
		GetModuleCode := ParaFUB_InAdr_Err;		(*Error message code*)

	END_IF
	
END_FUNCTION

(* Get 2-character module name from the module number coded  *)
FUNCTION GetModuleName		(* retired, never used *)

		GetModuleName := 33333;		(*Error message code*)

END_FUNCTION


(* Calculate Checksumm of Perm or Para Data Type  *)
FUNCTION DataCheckSumm		
	IF tiEnableTime > 0 AND iDataAdr > 0 AND iDataLenght > 0 THEN	// AND iDataLenght < 500 THEN	(* Function inputs ok check *)
			
		ulChecksum1 := 0;
		ulChecksum2 := 0;
		ulChecksum3 := 0;
	
				FOR ulPMPointer := iDataAdr TO (iDataAdr + iDataLenght - SIZEOF(ulChkValue)) BY SIZEOF(ulChkValue) DO
					memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));
					ulChecksum1 := ( ulChecksum1 XOR ulChkValue);
					ulChecksum2 := ( ulChecksum2 XOR ulChkValue) + ulChkValue  ;	(*test*)
					ulChecksum3 :=   ulChecksum3 XOR (ulChkValue * ulPMPointer);	(*test*)

				END_FOR;

				IF 	  iModuleCode = 2  THEN 		
					DataCheckSumm	:= ABS(ulChecksum2); 	(*allways output positive checksumm values*)
				ELSIF iModuleCode = 3 THEN
					DataCheckSumm	:= ABS(ulChecksum3);	(*allways output positive checksumm values*)
				ELSE
					DataCheckSumm	:= ABS(ulChecksum1);	(*allways output positive checksumm values*)
				END_IF
	ELSE
					DataCheckSumm :=  -ParaFUB_InAdr_Err;	(*Error message code, returned as negative value*)
	END_IF;		
		

	
END_FUNCTION



(*-----------------------------------------------------------------------------*)

(* Check, if a parameter value is withhin the valid range *)
FUNCTION_BLOCK ParaCheckFUB
	IF Enable THEN 
		(* Function Block state check *)
		IF _ParaSysAdr > 0 THEN
			_tParaSys ACCESS(_ParaSysAdr);		(*  Connect internal to global structure*)
			_bAdressErr	:= FALSE;
			_ParaState	:= 0;
		ELSE
			_bAdressErr	:= TRUE;
			_ParaState	:= ParaFUB_SysAdr_Err;		(*Error message code*)

		END_IF;
	
	
		IF _ParaState = 0 THEN 				(*Execute function ONLY WHEN ADRESSES ARE OK!*)
			(*-------------------------------------------------------------------------------*)
			IF _tParaSys.tParaBase2MM.bSys_Run THEN 				(* necessary precondition to do ParaCheck sucessfully*)

				(* parameter validity check *)
				_tParaSys.bThisParaCheckdOk :=        (Para >= ParaRangeMIN) AND (Para <= ParaRangeMAX);						(*checkpoint 'ParaOK' for only this instance of FUB*)
		
			ELSE
				_tParaSys.bThisParaCheckdOk := FALSE;
				_ParaState	:= ParaFUB_SysRun_Err;		(* necessary precondition to do ParaCheck sucessfully is missing*)
			END_IF

			_tParaSys.bParaSetupOk 					:= _tParaSys.bParaSetupOk 					AND _tParaSys.bThisParaCheckdOk;		(* checkpoint 'ParaOK' for ALL INSTANCES BEVORE AND INCLUDING THIS ONE !debug Info ONLY!*)
			_tParaSys.tMM2ParaBase.bMyParaSetupOk   := _tParaSys.tMM2ParaBase.bMyParaSetupOk  	AND _tParaSys.bThisParaCheckdOk;		(* checkpoint 'ParaOK' for ALL INSTANCES BEVORE AND INCLUDING THIS ONE !LIFE CONNECTED TAG!*)
						

			IF _tParaSys.tMM2ParaBase.bMyParaSetupOk	THEN _tParaSys.iParaOkChecked := _tParaSys.iParaOkChecked +1; END_IF			(* debug information *)

			(*--------------------------------------------------------------------------------*)
		END_IF

	ELSE
		_ParaState	:= ParaFUB_Disabeled_Err;				(* error code: FUNCTION DISABELED *)
	END_IF	
END_FUNCTION_BLOCK


