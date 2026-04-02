(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: MSCcsv
 * File: MSCcsv.fun
 * Author: 502423184
 * Created: May 18, 2015
 ********************************************************************
 * Functions and function blocks of library MSCcsv
 ********************************************************************)

FUNCTION_BLOCK ErrCnt_FUB (* saves the error bit data *)
	VAR_INPUT
		bReset : BOOL;
		bError : BOOL;
		iNum_Cyl : USINT;
		Name : USINT;
		tTS : tTimeStamp_typ;
	END_VAR
	VAR_OUTPUT
		tTS_First : tTimeStamp_typ;
		tTS_Last : tTimeStamp_typ;
		iCnt : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION WRITE_TS : BOOL (*writes a TimeStamp to a STRING ending with ;*)
	VAR_INPUT
		In : tTimeStamp_typ;
		adrSTR : UDINT;
	END_VAR
	VAR
		szTemp : STRING[5];
	END_VAR
END_FUNCTION

FUNCTION WRITE_REAL : BOOL (*writes a REAL to a STRING ending with ;*)
	VAR_INPUT
		rInput : REAL;
		ucNachkomma : USINT;
		adrSTR : UDINT;
	END_VAR
	VAR
		szVorkomma : STRING[15];
		szNachkomma : STRING[10];
		iInput1 : DINT;
		iInput2 : DINT;
	END_VAR
END_FUNCTION

FUNCTION WRITE_BIT : BOOL (*writes a BIT to a STRING ending with ;*)
	VAR_INPUT
		BIT : BOOL;
		adrSTR : UDINT;
	END_VAR
END_FUNCTION

FUNCTION WRITE_STRING : BOOL (*writes a STRING to a STRING ending with ;*)
	VAR_INPUT
		adrInput : UDINT;
		adrSTR : UDINT;
	END_VAR
END_FUNCTION

FUNCTION WRITE_DINT : BOOL (*writes a DINT to a STRING ending with ;*)
	VAR_INPUT
		iInput : DINT;
		adrSTR : UDINT;
	END_VAR
	VAR
		szVorkomma : STRING[15];
	END_VAR
END_FUNCTION

FUNCTION BITS_TO_UDINT : UDINT (*converts a BOOL array[0..24] to a UDINT*)
	VAR_INPUT
		Bits : ARRAY[0..24] OF BOOL;
		iNum_Cyl : USINT;
	END_VAR
	VAR
		i : USINT;
	END_VAR
END_FUNCTION

FUNCTION UDINT_TO_BITS : BOOL (*converts a UDINT To a BOOL array[0..24]*)
	VAR_INPUT
		In : UDINT;
		iNum_Cyl : USINT;
	END_VAR
END_FUNCTION

FUNCTION save_strcat : UDINT
	VAR_INPUT
		pDest : UDINT;
		pDest_Size : UDINT;
		pDest_Start : UDINT;
		pSrc : UDINT;
	END_VAR
	VAR
		length : UDINT;
	END_VAR
END_FUNCTION

FUNCTION DECI : USINT
	VAR_INPUT
		In : REAL;
	END_VAR
END_FUNCTION

FUNCTION MED_VAL : REAL
	VAR_INPUT
		In : ARRAY[0..24] OF REAL;
		Size : USINT;
	END_VAR
	VAR
		Sort : ARRAY[0..24] OF REAL;
		i : USINT;
		j : USINT;
		rTemp : REAL;
	END_VAR
END_FUNCTION

FUNCTION MAX_VAL : REAL
	VAR_INPUT
		In : ARRAY[0..24] OF REAL;
		Size : USINT;
	END_VAR
	VAR
		i : USINT;
	END_VAR
END_FUNCTION

FUNCTION MIN_VAL : REAL
	VAR_INPUT
		In : ARRAY[0..24] OF REAL;
		Size : USINT;
	END_VAR
	VAR
		i : USINT;
	END_VAR
END_FUNCTION

FUNCTION MAX_POS : USINT
	VAR_INPUT
		In : ARRAY[0..24] OF REAL;
		Size : USINT;
	END_VAR
	VAR
		i : USINT;
		rTemp : REAL;
	END_VAR
END_FUNCTION

FUNCTION AVG_VAL : REAL
	VAR_INPUT
		In : ARRAY[0..24] OF REAL;
		Size : USINT;
	END_VAR
	VAR
		i : USINT;
	END_VAR
END_FUNCTION

FUNCTION MAX_POS_ADR : USINT
	VAR_INPUT
		In : UDINT;
		Size : USINT;
	END_VAR
	VAR
		i : USINT;
		rTemp : REAL;
		rTemp1 : REAL;
		In1 : UDINT;
	END_VAR
END_FUNCTION

FUNCTION TIME_TO_REAL_S : REAL
	VAR_INPUT
		In : TIME;
	END_VAR
END_FUNCTION
FUNCTION TIME_TO_REAL_M : REAL
	VAR_INPUT
		In : TIME;
	END_VAR
END_FUNCTION
FUNCTION TIME_TO_REAL_H : REAL
	VAR_INPUT
		In : TIME;
	END_VAR
END_FUNCTION

FUNCTION WRITE_YYYY : USINT
	VAR_INPUT
		adrFile : UDINT; (*Adress of Header*)
		xtRealTime : _rtctime_typ;
	END_VAR
	VAR
		szCopyCat : STRING[4]; (*Temp string*)
	END_VAR
END_FUNCTION
FUNCTION WRITE_MM : USINT
	VAR_INPUT
		adrFile : UDINT; (*Adress of Header*)
		xtRealTime : _rtctime_typ;
	END_VAR
	VAR
		szCopyCat : STRING[4]; (*Temp string*)
	END_VAR
END_FUNCTION
FUNCTION WRITE_DD : USINT
	VAR_INPUT
		adrFile : UDINT; (*Adress of Header*)
		xtRealTime : _rtctime_typ;
	END_VAR
	VAR
		szCopyCat : STRING[4]; (*Temp string*)
	END_VAR
END_FUNCTION
FUNCTION WRITE_HH : USINT
	VAR_INPUT
		adrFile : UDINT; (*Adress of Header*)
		xtRealTime : _rtctime_typ;
	END_VAR
	VAR
		szCopyCat : STRING[4]; (*Temp string*)
	END_VAR
END_FUNCTION
FUNCTION WRITE_mm : USINT
	VAR_INPUT
		adrFile : UDINT; (*Adress of Header*)
		xtRealTime : _rtctime_typ;
	END_VAR
	VAR
		szCopyCat : STRING[4]; (*Temp string*)
	END_VAR
END_FUNCTION
FUNCTION WRITE_YYYYMMDD : USINT
	VAR_INPUT
		adrFile : UDINT; (*Adress of Header*)
		xtRealTime : _rtctime_typ;
	END_VAR
END_FUNCTION
FUNCTION WRITE_HHmm : USINT
	VAR_INPUT
		adrFile : UDINT; (*Adress of Header*)
		xtRealTime : _rtctime_typ;
	END_VAR
END_FUNCTION
FUNCTION WRITE_Date : USINT
	VAR_INPUT
		adrFile : UDINT; (*Adress of Header*)
		xtRealTime : _rtctime_typ;
	END_VAR
END_FUNCTION
