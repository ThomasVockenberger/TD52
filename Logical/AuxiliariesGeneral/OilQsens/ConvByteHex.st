FUNCTION_BLOCK HexStr2ByteArr
	pCurrArrPos	:= pByteArray;
	
	FOR idxByte := 0 TO iLenByteWr-1 DO	// selected byte
		iByte	:=	0;
		FOR idxChar	:=	0 TO 1 DO			// selected config string characters
			idxRead	:= idxByte*2 + idxChar + iOffsetStrRd;
			IF idxRead < iLenStrRd THEN
				brsmemcpy(ADR(sChar), pHexStr + idxRead, 1);
			ELSE
				sChar	:=	'';
			END_IF;
			
			IF 		sChar = '0' THEN	iByte	:=	iByte	+	TRUNC(0	* 16 ** (1-idxChar));
			ELSIF	sChar = '1' THEN	iByte	:=	iByte	+	TRUNC(1	* 16 ** (1-idxChar));
			ELSIF	sChar = '2' THEN	iByte	:=	iByte	+	TRUNC(2	* 16 ** (1-idxChar));
			ELSIF	sChar = '3' THEN	iByte	:=	iByte	+	TRUNC(3	* 16 ** (1-idxChar));
			ELSIF	sChar = '4' THEN	iByte	:=	iByte	+	TRUNC(4	* 16 ** (1-idxChar));
			ELSIF	sChar = '5' THEN	iByte	:=	iByte	+	TRUNC(5	* 16 ** (1-idxChar));
			ELSIF	sChar = '6' THEN	iByte	:=	iByte	+	TRUNC(6	* 16 ** (1-idxChar));
			ELSIF	sChar = '7' THEN	iByte	:=	iByte	+	TRUNC(7	* 16 ** (1-idxChar));
			ELSIF	sChar = '8' THEN	iByte	:=	iByte	+	TRUNC(8	* 16 ** (1-idxChar));
			ELSIF	sChar = '9' THEN	iByte	:=	iByte	+	TRUNC(9	* 16 ** (1-idxChar));
			ELSIF	sChar = 'A' THEN	iByte	:=	iByte	+	TRUNC(10* 16 ** (1-idxChar));
			ELSIF	sChar = 'B' THEN	iByte	:=	iByte	+	TRUNC(11* 16 ** (1-idxChar));
			ELSIF	sChar = 'C' THEN	iByte	:=	iByte	+	TRUNC(12* 16 ** (1-idxChar));
			ELSIF	sChar = 'D' THEN	iByte	:=	iByte	+	TRUNC(13* 16 ** (1-idxChar));
			ELSIF	sChar = 'E' THEN	iByte	:=	iByte	+	TRUNC(14* 16 ** (1-idxChar));
			ELSIF	sChar = 'F' THEN	iByte	:=	iByte	+	TRUNC(15* 16 ** (1-idxChar));
			ELSE						iByte	:=	0;
			END_IF;
		END_FOR;
		
		IF (pCurrArrPos - pByteArray) < iLenByteWr THEN
			pCurrArrPos	:=	brsmemset(pCurrArrPos, UINT_TO_USINT(iByte), 1);
		END_IF;
	END_FOR;
END_FUNCTION_BLOCK

FUNCTION_BLOCK ByteArr2HexStr
	pCurrArrPos	:= pHexStr + iOffsetStrWr;
	
	FOR idxByte := 0 TO iLenByteRd-1 DO	// selected byte
		iByte	:=	0;
	
		idxRead	:= idxByte + iOffsetByteRd;
		IF idxRead < iLenStrWr/2 THEN
			brsmemcpy(ADR(iByte), pByteArray + idxRead, 1);
		ELSE
			iByte	:=	0;
		END_IF;
		FOR idxNibble	:=	0 TO 1 DO			// selected 4 bit (nibble) byte subgroup
			IF idxNibble = 0 THEN
				iNibble	:=	SHR(iByte, 4);
			ELSE
				iNibble	:=	iByte MOD 16;
			END_IF;
		
			IF 		iNibble = 0		THEN	sChar := '0';
			ELSIF	iNibble = 1		THEN	sChar := '1';
			ELSIF	iNibble = 2		THEN	sChar := '2';
			ELSIF	iNibble = 3		THEN	sChar := '3';
			ELSIF	iNibble = 4		THEN	sChar := '4';
			ELSIF	iNibble = 5		THEN	sChar := '5';
			ELSIF	iNibble = 6		THEN	sChar := '6';
			ELSIF	iNibble = 7		THEN	sChar := '7';
			ELSIF	iNibble = 8		THEN	sChar := '8';
			ELSIF	iNibble = 9		THEN	sChar := '9';
			ELSIF	iNibble = 10	THEN	sChar := 'A';
			ELSIF	iNibble = 11	THEN	sChar := 'B';
			ELSIF	iNibble = 12	THEN	sChar := 'C';
			ELSIF	iNibble = 13	THEN	sChar := 'D';
			ELSIF	iNibble = 14	THEN	sChar := 'E';
			ELSIF	iNibble = 15	THEN	sChar := 'F';
			ELSE							sChar := '0';
			END_IF;

			IF (pCurrArrPos - pHexStr) < iLenStrWr THEN
				pCurrArrPos	:= brsmemcpy(pCurrArrPos, ADR(sChar), 1);
			END_IF;
		END_FOR;
	END_FOR;
END_FUNCTION_BLOCK

