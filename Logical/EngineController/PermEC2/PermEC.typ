(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: PermEC
 * File: PermEC.typ
 * Author: WaldharM
 * Created: October 16, 2012
 ********************************************************************
 * Local data types of program PermEC
 ********************************************************************)

TYPE
	ParaEC2_typ : 	STRUCT 
		Map : Map_Struct;
		Perm : Perm_Struct;
		iCnt_TC_Surge : DINT;
		iCnt_GrCEvent : DINT;
	END_STRUCT;
END_TYPE
