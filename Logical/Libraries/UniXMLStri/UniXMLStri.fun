(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: UniXMLStri
 * File: UniDecoXML.fun
 * Author: ZengereS
 * Created: November 02, 2010
 ********************************************************************
 * Functions and function blocks of library UniXMLStri
 ********************************************************************)

FUNCTION_BLOCK xUniCodString
	VAR_INPUT
		bEnable : BOOL; (*TRUE = enable FUB*)
		ulXMLDataAdress : UDINT;
		ulXMLDataSize : UDINT;
	END_VAR
	VAR_OUTPUT
		bErrUniXMLRead : BOOL;
		usErrorCode : UINT; (*0=OK, ready*)
		bUniAnaFileReadDone : BOOL;
	END_VAR
	VAR
		bUniXMLWrite : BOOL;
		step : USINT; (*Internal step counter*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK xUniDecoString
	VAR_INPUT
		bEnable : BOOL; (*TRUE = enable FUB*)
		szConfigString : STRING[300];
		szSeparator : STRING[16]; (*Enter a combination of detectable separator characters here ( * = position will be ignored)*)
		ucStartPos : USINT; (*position of first character in string to start searching*)
	END_VAR
	VAR_OUTPUT
		usErrorCode : UINT; (*0=OK, ready*)
		usFoundPos : UINT; (*position of first data character after the found separator*)
		usFoundLenght : UINT; (*lenght of data in characters after the found separator*)
		bLastData : BOOL; (*TRUE, if no more separators will follow afther the found one*)
	END_VAR
	VAR
		CNr : UINT; (*Internal*)
		szCNr : STRING[1]; (*Internal*)
		usUniStringLen : UINT; (*Internal*)
		usUniSepaLen : UINT; (*Internal*)
		bFound : BOOL; (*Internal*)
		szWildcard : ARRAY[0..1] OF STRING[1]; (*Internal*)
		Sepa : UINT; (*Internal*)
		szSepar : ARRAY[0..16] OF STRING[1]; (*Internal*)
		ucFoundSlashs : USINT; (*Internal: count max number of following / characters*)
		ucFoundWildcards : USINT; (*Internal: count max. number of following wildcard characters*)
		CNrStartDetailSearch : UINT; (*internal*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK xUniCalcCheckSumm
	VAR_INPUT
		bEnable : BOOL; (*TRUE = enable FUB*)
		InString : STRING[300]; (*input string to calculate checksumm from*)
		usChecksummMode : USINT; (*0=alternating checksumm (dafeult), 1= prepared for later use...*)
		InMemAdress : UDINT; (*ALTERNATIVE INPUT to InString: enter memory adress in here to check*)
		InMemLenght : UINT; (*ALTERNATIVE INPUT to InString: enter memory lenght to check in combination with adress*)
	END_VAR
	VAR_OUTPUT
		ssChecksumm : INT; (*calculated checksumm from InString*)
		usChecksumm : UINT; (*calculated checksumm from InString without negative results*)
		usErrorCode : UINT; (*0=OK, ready*)
	END_VAR
	VAR
		CNr : UINT; (*Internal*)
		ulADRString : UDINT; (*internal*)
		usUniStringLen : UINT; (*internal*)
		bPair : BOOL; (*internal*)
		ucByteValue : REFERENCE TO USINT; (*internal*)
		ssByteValue : INT; (*internal*)
	END_VAR
END_FUNCTION_BLOCK
