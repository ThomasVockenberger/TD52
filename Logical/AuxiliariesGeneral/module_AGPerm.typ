(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Paket: AuxiliariesGeneral
 * Datei: module_AGPerm.typ
 * Autor: zengeres
 * Erstellt: 14. Oktober 2013
 ********************************************************************
 * Datentypen des Pakets AuxiliariesGeneral
 ********************************************************************)

TYPE
	tPerm_AG_typ : 	STRUCT 
		tStartStat : ARRAY[0..200]OF tStartStat_typ;
		StatCnt : DINT;
		rAG_PermValue1 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue2 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue3 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue4 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue5 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue6 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue7 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue8 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue9 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
		rAG_PermValue10 : REAL; (*spare permanent value - replace with new vars of same lenght, when needed*)
	END_STRUCT;
	tStartStat_typ : 	STRUCT 
		tiStartTime : RTCtime_typ;
		tiStarterON_Max : TIME;
		tiStarterOFF : TIME;
		tiStartScav : TIME;
		rN_EngStart : REAL;
		tiStartDuration : TIME;
		iStartID : DINT;
		bStartSuccess : BOOL;
	END_STRUCT;
END_TYPE
