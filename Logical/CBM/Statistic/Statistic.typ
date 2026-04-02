(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: Statistic
 * File: Statistic.typ
 * Author: 502423184
 * Created: May 18, 2015
 ********************************************************************
 * Data types of package Statistic
 ********************************************************************)

TYPE
	_pmCBM : 	STRUCT 
		Stat : _StatBuffer;
		Err : _ErrStat;
	END_STRUCT;
	_ErrStat : 	STRUCT 
		tTS_Reset : tTimeStamp_typ;
		Size : UINT;
		iCnt_OH_Reset : DINT;
		xErr : ARRAY[0..ErrCntSize]OF ErrCnt_FUB;
	END_STRUCT;
	_StrData : 	STRUCT 
		str : STRING[30];
	END_STRUCT;
	_StringData : 	STRUCT 
		Name : STRING[NameSize];
		Data : ARRAY[0..StatSize]OF _StrData;
		Skip : BOOL;
	END_STRUCT;
	_BoolData : 	STRUCT 
		Name : STRING[NameSize];
		Data : ARRAY[0..StatSize]OF BOOL;
		Skip : BOOL;
	END_STRUCT;
	_UsintData : 	STRUCT 
		Name : STRING[NameSize];
		Unit : STRING[UnitSize];
		Data : ARRAY[0..StatSize]OF USINT;
		Skip : BOOL;
	END_STRUCT;
	_RealData : 	STRUCT 
		Name : STRING[NameSize];
		Unit : STRING[UnitSize];
		Deci : USINT;
		Data : ARRAY[0..StatSize]OF REAL;
		Skip : BOOL;
	END_STRUCT;
	_NameErr : 	STRUCT 
		str : STRING[21];
	END_STRUCT;
	_StatBuffer : 	STRUCT 
		r : ARRAY[0..StatRealSize]OF _RealData; (*real data*)
		rSize : USINT;
		b : ARRAY[0..StatBoolSize]OF _BoolData; (*boolean data*)
		bSize : USINT;
		i : ARRAY[0..StatIntSize]OF _UsintData; (*unsigned short integer data*)
		iSize : USINT;
		s : ARRAY[0..StatStrSize]OF _StringData; (*String data*)
		sSize : USINT;
		iIdx : USINT; (*current data Index*)
		bFilled : BOOL; (*is buffer filled?*)
	END_STRUCT;
END_TYPE
