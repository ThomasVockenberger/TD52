(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: MSCcsv
 * File: MSCcsv.typ
 * Author: 502423184
 * Created: May 18, 2015
 ********************************************************************
 * Data types of library MSCcsv
 ********************************************************************)

TYPE
	tTimeStamp_typ : STRUCT
		Year : USINT;
		Month : USINT;
		Day : USINT;
		Hour : USINT;
		Minute : USINT;
		Second : USINT;
	END_STRUCT;
	_rtctime_typ : 	STRUCT 
		year : UINT;
		month : USINT;
		day : USINT;
		reserve : USINT;
		hour : USINT;
		minute : USINT;
		second : USINT;
		millisec : UINT;
		microsec : UINT;
	END_STRUCT;
END_TYPE
