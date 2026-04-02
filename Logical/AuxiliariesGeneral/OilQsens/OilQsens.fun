FUNCTION_BLOCK HexStr2ByteArr
	VAR_INPUT
		pHexStr : UDINT;
		iLenStrRd : UINT;
		pByteArray : UDINT;
		iLenByteWr : UINT;
		iOffsetStrRd : UINT;
	END_VAR
	VAR
		idxByte : UINT;
		idxChar : UINT;
		idxRead : UINT;
		iByte : UINT;
		sChar : STRING[1];
		pCurrArrPos : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ByteArr2HexStr
	VAR_INPUT
		pByteArray : UDINT;
		iLenByteRd : UINT;
		pHexStr : UDINT;
		iLenStrWr : UINT;
		iOffsetByteRd : UINT;
		iOffsetStrWr : UINT;
	END_VAR
	VAR
		idxNibble : UINT;
		idxByte : UINT;
		idxRead : UINT;
		iByte : UINT;
		iNibble : UINT;
		sChar : STRING[1];
		pCurrArrPos : UDINT;
	END_VAR
END_FUNCTION_BLOCK