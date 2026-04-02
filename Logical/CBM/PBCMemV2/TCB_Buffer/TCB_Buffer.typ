(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: TCB_Buffer
 * File: TCB_Buffer.typ
 * Author: 502423184
 * Created: January 29, 2018
 ********************************************************************
 * Local data types of program TCB_Buffer
 ********************************************************************)

TYPE
	_TracerIn : 	STRUCT
		Name : STRING[21];
		Unit : STRING[6];
		Format : USINT;
		Convert : REAL;
		Adress : STRING[100];
		Typdef : USINT;
		Record : BOOL;
	END_STRUCT;
	_TracerOut : 	STRUCT 
		Adress : UDINT;
		Length : UDINT;
		rValue : REAL;
	END_STRUCT;
	_Tracer : 	STRUCT
		In : _TracerIn;
		Out : _TracerOut;
	END_STRUCT;
END_TYPE
