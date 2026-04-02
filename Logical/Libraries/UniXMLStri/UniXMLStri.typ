(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: UniDecoXML
 * File: UniDecoXML.typ
 * Author: ZengereS
 * Created: November 02, 2010
 ********************************************************************
 * Data types of library UniDecoXML
 ********************************************************************)

TYPE
	tFoundSeparators_Type : 	STRUCT 
		Code : STRING[1]; (*XML code for datapoint*)
		Length : UINT;
		Pos : UINT;
	END_STRUCT;
	tSeparators_Type : 	STRUCT 
		Code : STRING[1]; (*XML code for datapoint*)
		VarName : STRING[32]; (*Variablename in TypeStructure (32characters signifikant)*)
		VarAdress : UDINT; (*Memory adress of variabe element in TypeStructure*)
		length : UDINT; (*size of variabe element in TypeStructure*)
		VarType : USINT; (*prepared for later use: variabe type of variabe element in TypeStructure*)
	END_STRUCT;
END_TYPE
