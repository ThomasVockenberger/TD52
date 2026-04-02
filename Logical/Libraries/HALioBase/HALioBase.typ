(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: HALioBase
 * File: HALioBase.typ
 * Author: froehlichw
 * Created: October 03, 2011
 ********************************************************************
 * Data types of library HALioBase
 *
 * History:
 * 03.01.2012  V0.00.0 froehlichw
 *      (new)  created
 * 07.03.2012  V0.10.0 froehlichw
 *   (change)  Qual to GoodQual
 *             in HALioAi_Type, HALioAi_INT_Type and HALioDi_Type
 * 30.07.2018  V0.13.1 Hohensinner
 *   (added)  Exist
 * 25.01.2023  V0.22.0 Perktold
 *    (change) Filter from INT to UINT in HALioExtern_Type
 * 31.01.2024  V0.23.0 Astner
 *    (change) Added Exist to DI,AO,DO; added GoodQual to AO,DO
 ********************************************************************)

TYPE
	HALioAi_Type : 	STRUCT 
		Ai : REAL;
		Unfilt : REAL;
		GoodQual : BOOL;
		Exist : BOOL;
	END_STRUCT;
	HALioAi_INT_Type : 	STRUCT 
		Ai : DINT;
		Unfilt : DINT;
		GoodQual : BOOL;
		Exist : BOOL;
	END_STRUCT;
	HALioDi_Type : 	STRUCT 
		Di : BOOL;
		GoodQual : BOOL;
		Exist : BOOL;
	END_STRUCT;
	HALioAo_Type : 	STRUCT 
		Ao : REAL;
		GoodQual : BOOL;
	END_STRUCT;
	HALioDo_Type : 	STRUCT 
		Do : BOOL;
		GoodQual : BOOL;
	END_STRUCT;
	HALioExtern_Type : 	STRUCT 
		Qual_Min : INT;
		Qual_Max : INT;
		Scal_X1 : DINT;
		Scal_X2 : DINT;
		Scal_Y1 : REAL;
		Scal_Y2 : REAL;
		Filter : UINT;
		HW_Type : USINT;
	END_STRUCT;
	HALioReaderPara_Type : 	STRUCT 
		nodeName : STRING[99];
		nodeValue : STRING[99];
		nodeType : UDINT;
		nodeDepth : UDINT;
		attributeCount : UDINT;
		attributeIndex : UDINT;
		attributeMax : UDINT;
		attribute : ARRAY[0..3]OF HALioXmlAttribute_Type;
		checkType : HALioCheckType_Enum;
		checkPar : HALioCheckPar_Enum;
		pvAppName : STRING[39];
		pvName : STRING[39];
		pvAdr : UDINT;
		pvLen : UDINT;
		actIoChannel : UINT;
		pvParChecked : UINT;
		empty : BOOL;
		versionChecked : BOOL;
		pvChecked : BOOL;
		pvAllParChecked : BOOL;
	END_STRUCT;
	HALioXmlAttribute_Type : 	STRUCT 
		name : STRING[99];
		value : STRING[99];
	END_STRUCT;
	HALioFubStep_Enum : 
		(
		halSTP_INIT := 0, (* init FUB *)
		halSTP_GET_CONFIG := 5, (* get config module *)
		halSTP_CREATE_READER := 10, (* create XML reader *)
		halSTP_READ_NODE := 20, (* read XML node *)
		halSTP_READ_ATTRIBUTE := 25, (* read XML attribute *)
		halSTP_CHECK_DATA := 30, (* check data *)
		halSTP_ERROR := 90, (* error *)
		halSTP_CLOSE_READER := 99, (* close reader *)
		halSTP_FINISHED := 100 (* finished *)
		);
	HALioCheckType_Enum : 
		(
		halCHK_VERSION := 0,
		halCHK_PV_NAME,
		halCHK_PV_PAR,
		halCHK_NOTHING := 99
		);
	HALioCheckPar_Enum : 
		(
		halCHK_PAR_ACTIVE := 0,
		halCHK_PAR_TYPE,
		halCHK_PAR_QUAL_MIN,
		halCHK_PAR_QUAL_MAX,
		halCHK_PAR_MSG_NUM,
		halCHK_PAR_SCAL_X1,
		halCHK_PAR_SCAL_X2,
		halCHK_PAR_SCAL_Y1,
		halCHK_PAR_SCAL_Y2,
		halCHK_PAR_FILTER,
		halCHK_PAR_NOTHING := 99
		);
END_TYPE
