(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: CheckMap
 * File: CheckMap.typ
 * Author: havlovect
 * Created: September 27, 2011
 ********************************************************************
 * Local data types of program CheckMap
 ********************************************************************)

TYPE
	TableEntry : 	STRUCT 
		sourceName : STRING[255]; (*Name der Quell PV*)
		sourceFlags : USINT;
		sinkName : STRING[255]; (*Name der Ziel PV*)
		sinkFlags : USINT;
	END_STRUCT;
END_TYPE
