(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: HALioBase
 * File: HALioCfg.st
 * Author: froehlichw
 * Created: October 03, 2011
 ********************************************************************
 * Implementation of function block HALioCfg
 *
 * History:
 * 04.01.2012  V0.00.0 froehlichw
 *      (new)  created
 * 17.10.2012  V0.12.0 froehlichw
 *      (new)  check if signal PV lenght match signal type
 *             check length of external parameter PV
 * 19.02.2012  V0.13.0 Weitzer T
 *			   increase max filter value from 1000 to 5000
 * 16.08.2021  V0.20.0 Weitzer
 *   (change)  UR20 types added
 *******************************************************************)

FUNCTION_BLOCK HALioCfg
	pCfgModDevice;    (* not used *)

	pEmptyString:= ADR('');

	(* reset step *)
	IF EDGEPOS(enable) OR (enable = FALSE) THEN
		stepFub:= halSTP_INIT;
	END_IF;

	(*=================================================================
	* state machine main
	*================================================================*)
	CASE stepFub OF
		(****************************************************
		* init FUB
		****************************************************)
		halSTP_INIT:
			para.actIoChannel:= 0;

			(* set FUB outputs *)
			ParOK:= FALSE;
			ActNumIoChannels:= para.actIoChannel;
			CfgModError:= FALSE;
			pErrInfo1:= pEmptyString;
			pErrInfo2:= pEmptyString;
			pErrInfo3:= pEmptyString;

			IF (enable) THEN
				stepFub:= halSTP_GET_CONFIG;
				status:= halERR_FUB_BUSY;
				(* initialize FUB *)
				DatObjInfo_0.enable:= TRUE;
				DatObjInfo_0.pName:= pCfgModName;
				(* initialize data *)
				para.attributeMax:= SIZEOF(para.attribute)/SIZEOF(para.attribute[0]);
				para.versionChecked:= FALSE;
				para.pvChecked:= FALSE;
				para.pvAllParChecked:= FALSE;
				para.pvParChecked:= 0;
				(* inputs are OK? *)
				IF (pHALioSignal = 0) OR (MaxNumIoChannels = 0) THEN
					(* set error *)
					stepFub:= halSTP_ERROR;
					status:= halERR_INP_pHALIOSIGNAL_NV;
				END_IF;
			ELSE
				status:= halERR_FUB_NOT_ENABLED;
			END_IF;

		(****************************************************
		* get config module data
		****************************************************)
		halSTP_GET_CONFIG:
			DatObjInfo_0();     (* call FUB *)

			(* set FUB outputs *)
			ParOK:= FALSE;
			ActNumIoChannels:= para.actIoChannel;
			CfgModError:= FALSE;
			pErrInfo1:= pEmptyString;
			pErrInfo2:= pEmptyString;
			pErrInfo3:= pEmptyString;
			status:= halERR_FUB_BUSY;

			IF (DatObjInfo_0.status = halERR_NO_ERROR) THEN
				stepFub:= halSTP_CREATE_READER;
				(* initialize FUB *)
				xmlCreateMemoryReader_0.enable:= TRUE;
				xmlCreateMemoryReader_0.pXmlMemory:= DatObjInfo_0.pDatObjMem;
				xmlCreateMemoryReader_0.memorySize:= DatObjInfo_0.len;
				(* ignore possible fill bytes at end of data module *)
				pVal ACCESS DatObjInfo_0.pDatObjMem + DatObjInfo_0.len - 1;
				IF (pVal = 0) THEN
					xmlCreateMemoryReader_0.memorySize:= xmlCreateMemoryReader_0.memorySize - 1;
					pVal ACCESS DatObjInfo_0.pDatObjMem + DatObjInfo_0.len - 2;
					IF (pVal = 0) THEN
						xmlCreateMemoryReader_0.memorySize:= xmlCreateMemoryReader_0.memorySize - 1;
						pVal ACCESS DatObjInfo_0.pDatObjMem + DatObjInfo_0.len - 3;
						IF (pVal = 0) THEN
							xmlCreateMemoryReader_0.memorySize:= xmlCreateMemoryReader_0.memorySize - 1;
						END_IF;
					END_IF;
				END_IF;
				xmlCreateMemoryReader_0();     (* call FUB *)
			ELSIF (DatObjInfo_0.status <> halERR_FUB_BUSY) THEN
				(* set error *)
				stepFub:= halSTP_ERROR;
				CfgModError:= TRUE;
				itoa(DatObjInfo_0.status, ADR(strErrNb));
				pErrInfo1:= ADR(strErrNb);
				status:= halERR_CFG_MODULE_NOT_FOUND;
			END_IF;

		(****************************************************
		* create XML reader
		****************************************************)
		halSTP_CREATE_READER:
			xmlCreateMemoryReader_0();     (* call FUB *)

			(* set FUB outputs *)
			ParOK:= FALSE;
			ActNumIoChannels:= para.actIoChannel;
			CfgModError:= FALSE;
			pErrInfo1:= pEmptyString;
			pErrInfo2:= pEmptyString;
			pErrInfo3:= pEmptyString;
			status:= halERR_FUB_BUSY;

			IF (xmlCreateMemoryReader_0.status = halERR_NO_ERROR) THEN
				(* all OK => read nade *)
				stepFub:= halSTP_READ_NODE;
				(* initialize FUB *)
				xmlReadNextNode_0.enable:= TRUE;
				xmlReadNextNode_0.ident:= xmlCreateMemoryReader_0.ident;
				xmlReadNextNode_0.forceRead:= 0;
				xmlReadNextNode_0.skipSubtree:= FALSE;
				xmlReadNextNode_0.pName := ADR(para.nodeName);
	   		xmlReadNextNode_0.pValue := ADR(para.nodeValue);
				xmlReadNextNode_0.nameSize := SIZEOF(para.nodeName) - 1;
	   		xmlReadNextNode_0.valueSize := SIZEOF(para.nodeValue) - 1;
				(* initialize FUB *)
				xmlReadAttributeNr_0.enable:= TRUE;
				xmlReadAttributeNr_0.ident:= xmlCreateMemoryReader_0.ident;
				(* initialize FUB *)
				xmlCloseMemoryReader_0.enable:= TRUE;
				xmlCloseMemoryReader_0.ident:= xmlCreateMemoryReader_0.ident;
			ELSIF (xmlCreateMemoryReader_0.status <> halERR_FUB_BUSY) THEN
				(* set error *)
				stepFub:= halSTP_ERROR;
				CfgModError:= TRUE;
				itoa(xmlCreateMemoryReader_0.status, ADR(strErrNb));
				pErrInfo1:= ADR(strErrNb);
				status:= halERR_XML_READER;
			END_IF;

		(****************************************************
		* read node
		* read attributes
		* check data
		****************************************************)
		halSTP_READ_NODE:
			(**************************************************
			* read node
			**************************************************)
			xmlReadNextNode_0();     (* call FUB *)

			(* set FUB outputs *)
			ParOK:= FALSE;
			ActNumIoChannels:= para.actIoChannel;
			CfgModError:= FALSE;
			pErrInfo1:= pEmptyString;
			pErrInfo2:= pEmptyString;
			pErrInfo3:= pEmptyString;
			status:= halERR_FUB_BUSY;

			IF (xmlReadNextNode_0.status = halERR_NO_ERROR) THEN
				para.nodeType:= xmlReadNextNode_0.nodeType;
				para.nodeDepth:= xmlReadNextNode_0.depth;
				para.empty:= xmlReadNextNode_0.isEmpty;
				para.attributeCount:= xmlReadNextNode_0.attributeCount;
				(* check element type *)
				IF (para.nodeType = xmlNODE_TYPE_ELEMENT) THEN
					(* it is a node element *)
					(* check max attributes of node element *)
					IF (para.attributeCount > para.attributeMax) THEN
						(* set error *)
						stepFub:= halSTP_ERROR;
						CfgModError:= TRUE;
						pErrInfo1:= ADR(para.pvName);
						pErrInfo2:= ADR(para.nodeName);
						status:= halERR_TOO_MANY_ATTRIBUTES;
					ELSIF (para.attributeCount = 0) THEN
						(* no attributes => read next node *)
						stepFub:= halSTP_READ_NODE;
					ELSE
						(* all OK => read attributes *)
						stepFub:= halSTP_READ_ATTRIBUTE;
					END_IF;
				ELSIF (para.nodeType = xmlNODE_TYPE_ENDELEMENT) THEN
					(* it is a node end element *)
					stepFub:= halSTP_READ_NODE;
					IF (strcmp(ADR(para.nodeName), ADR(halNODE_GROUP)) = 0) THEN
						(* end group => was attribute of group PV_Name? *)
						IF (para.pvChecked = TRUE) THEN
							(* yes => all parameter of group (PV) checked? *)
							IF (para.pvAllParChecked = TRUE) THEN
								(* yes => increment actIoChannel 
								       => reset PV and parameter checked *)
								para.actIoChannel:= para.actIoChannel + 1;
								para.pvChecked:= FALSE;
								para.pvAllParChecked:= FALSE;
								para.pvParChecked:= 0;
							ELSE
								(* no => set error *)
								stepFub:= halSTP_ERROR;
								CfgModError:= TRUE;
								pErrInfo1:= ADR(para.pvName);
								(* define missing parameter *)
								IF (para.pvParChecked.halPAR_ACTIVE = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_ACTIVE);
								ELSIF (para.pvParChecked.halPAR_TYPE = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_TYPE);
								ELSIF (para.pvParChecked.halPAR_QUAL_MIN = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_QUAL_MIN);
								ELSIF (para.pvParChecked.halPAR_QUAL_MAX = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_QUAL_MAX);
								ELSIF (para.pvParChecked.halPAR_MSG_NUM = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_MSG_NUM);
								ELSIF (para.pvParChecked.halPAR_SCAL_X1 = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_SCAL_X1);
								ELSIF (para.pvParChecked.halPAR_SCAL_X2 = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_SCAL_X2);
								ELSIF (para.pvParChecked.halPAR_SCAL_Y1 = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_SCAL_Y1);
								ELSIF (para.pvParChecked.halPAR_SCAL_Y2 = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_SCAL_Y2);
								ELSIF (para.pvParChecked.halPAR_FILTER = FALSE) THEN
									pErrInfo2:= ADR(halATTR_ID_FILTER);
								END_IF;
								status:= halERR_PARAMETER_MISSING;
							END_IF;
						END_IF;
					END_IF;
				ELSE
					(* all other node types *)
					stepFub:= halSTP_READ_NODE;
				END_IF;
			ELSIF (xmlReadNextNode_0.status = xmlERR_NO_FURTHER_XML_NODE) THEN
				(* no further nodes => finished *)
				stepFub:= halSTP_CLOSE_READER;
			ELSIF (xmlReadNextNode_0.status <> halERR_FUB_BUSY) THEN
				(* error reading node => set error *)
				stepFub:= halSTP_ERROR;
				CfgModError:= TRUE;
				pErrInfo1:= ADR(para.pvName);
				pErrInfo2:= ADR(para.nodeName);
				itoa(xmlCreateMemoryReader_0.status, ADR(strErrNb));
				pErrInfo3:= ADR(strErrNb);
				status:= halERR_READ_NODE;
			END_IF;

			(**************************************************
			* read attributes
			**************************************************)
			IF (stepFub = halSTP_READ_ATTRIBUTE) THEN
				para.attributeIndex:= 0;
				(* reset previous attributes *)
				memset(ADR(para.attribute), 0, SIZEOF(para.attribute));
				FOR para.attributeIndex:= 0 TO para.attributeCount - 1 DO
					xmlReadAttributeNr_0.index:= para.attributeIndex;
					xmlReadAttributeNr_0.pName:= ADR(para.attribute[para.attributeIndex].name);
		   		xmlReadAttributeNr_0.pValue:= ADR(para.attribute[para.attributeIndex].value);
		   		xmlReadAttributeNr_0.nameSize:= SIZEOF(para.attribute[para.attributeIndex].name) - 1;
   				xmlReadAttributeNr_0.valueSize:= SIZEOF(para.attribute[para.attributeIndex].value) - 1;
					xmlReadAttributeNr_0();     (* call FUB *)
					IF (xmlReadAttributeNr_0.status = halERR_NO_ERROR) THEN
						(* all OK => check data *)
						stepFub:= halSTP_CHECK_DATA;
					ELSIF (xmlReadAttributeNr_0.status <> halERR_FUB_BUSY) THEN
						(* error reading attribute => set error *)
						stepFub:= halSTP_ERROR;
						CfgModError:= TRUE;
						pErrInfo1:= ADR(para.pvName);
						pErrInfo2:= ADR(para.nodeName);
						itoa(xmlCreateMemoryReader_0.status, ADR(strErrNb));
						pErrInfo3:= ADR(strErrNb);
						status:= halERR_READ_ATTRIBUTE;
						EXIT;
					END_IF;
				END_FOR;
			END_IF;

			(**************************************************
			* check data
			**************************************************)
			IF (stepFub = halSTP_CHECK_DATA) THEN
				stepFub:= halSTP_READ_NODE;
				(* check max number of IO channels *)
				IF (para.actIoChannel < MaxNumIoChannels) THEN
					HALioSignal_0 ACCESS pHALioSignal + (SIZEOF(HALioSignal_0) * para.actIoChannel);
					
					(* set default task class *)
					IF HALioSignal_0.TaskClass = 0 THEN
						HALioSignal_0.TaskClass := 1;
					END_IF

					para.checkType:= halCHK_NOTHING;
					(* root node => check version *)
					IF (strcmp(ADR(para.nodeName), ADR(halNODE_ROOT)) = 0) AND (para.versionChecked = FALSE) THEN
						(* check if attribute name is Version *)
						IF (strcmp(ADR(para.attribute[0].name), ADR(halATTR_VERSION)) = 0) THEN
							(* attribute name OK => check attribute value *)
							para.checkType:= halCHK_VERSION;
						END_IF;
					END_IF;

					(* node group => check PV_Name *)
					IF (strcmp(ADR(para.nodeName), ADR(halNODE_GROUP)) = 0) THEN
						IF (para.versionChecked = TRUE) THEN
							(* check if attribute name is PV_Name *)
							IF (strcmp(ADR(para.attribute[0].name), ADR(halATTR_PV_NAME)) = 0) THEN
								(* attribute name OK => check attribute value *)
								para.checkType:= halCHK_PV_NAME;
							END_IF;
						ELSE
							(* version not checked yet => set error *)
							stepFub:= halSTP_ERROR;
							CfgModError:= TRUE;
							status:= halERR_VERSION_NV;
						END_IF;
					END_IF;
		
					(* node parameter => check parameter *)
					IF (strcmp(ADR(para.nodeName), ADR(halNODE_PARAMETER)) = 0) THEN
						IF (para.pvChecked = TRUE) THEN
							(* check if attribute names are ID and Value *)
							IF (strcmp(ADR(para.attribute[0].name), ADR(halATTR_ID)) = 0) AND (strcmp(ADR(para.attribute[1].name), ADR(halATTR_VALUE)) = 0) THEN
								(* attribute names OK => check attribute values *)
								para.checkType:= halCHK_PV_PAR;
							END_IF;
						ELSE
							(* PV_Name not checked yet => do nothing *)
							para.checkType:= halCHK_NOTHING;
						END_IF;
					END_IF;
	
					(*=======================================================
					* state machine check node type
					*======================================================*)
					CASE para.checkType OF
						(******************************************
						* check version and
						* application module name
						******************************************)
						halCHK_VERSION:
							IF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_VERSION_VAL_1_0_00)) = 0) THEN
								(* version OK *)
								stepFub:= halSTP_READ_NODE;
								para.versionChecked:= TRUE;
		
								(* get application module name *)
								strLenMax:= UDINT_TO_UINT(SIZEOF(para.pvAppName) - 1);
								IF (pAppModName = 0) THEN
									strLen:= 0;
								ELSE
									strLen:= strlen(pAppModName);
								END_IF;
								IF (strLen = 0) THEN
									(* no application module name defined => reset name *)
									nextAdr:= strcpy(ADR(para.pvAppName), ADR(''));
								ELSIF (strLenMax > strLen + 2) THEN
									(* set application module name *)
									nextAdr:= strcpy(ADR(para.pvAppName), pAppModName);
									nextAdr:= strcat(nextAdr, ADR('::'));
								ELSE
									(* application module name too long => set error *)
									stepFub:= halSTP_ERROR;
									CfgModError:= TRUE;
									pErrInfo1:= pAppModName;
									status:= halERR_PV_NAME_TOO_LONG;
								END_IF;
							ELSE
								(* Version not OK => set error *)
								stepFub:= halSTP_ERROR;
								CfgModError:= TRUE;
								pErrInfo1:= ADR(para.attribute[0].value);
								status:= halERR_VERSION_NV;
							END_IF;
	
						(******************************************
						* check PV name and get address
						******************************************)
						halCHK_PV_NAME:
							(* get PV name *)
							strLenMax:= UDINT_TO_UINT(SIZEOF(para.pvName) - 1);
							strLen:= strlen(ADR(para.attribute[0].value));
							IF (strLenMax > strLen) THEN
								nextAdr:= strcpy(ADR(para.pvName), ADR(para.attribute[0].value));
							ELSE
								(* PV name too long => set error *)
								stepFub:= halSTP_ERROR;
								CfgModError:= TRUE;
								pErrInfo1:= ADR(para.attribute[0].value);
								status:= halERR_PV_NAME_TOO_LONG;
							END_IF;
		
							(* get PV address *)
							IF (status = halERR_FUB_BUSY) THEN
								nextAdr:= strcpy(ADR(pvName), ADR(para.pvAppName));
								nextAdr:= strcat(nextAdr, ADR(para.pvName));
								status_PV_xgetadr:= PV_xgetadr(ADR(pvName), ADR(para.pvAdr), ADR(para.pvLen));
								IF (status_PV_xgetadr = halERR_NO_ERROR) THEN
									(* all OK => read next node *)
									stepFub:= halSTP_READ_NODE;
									HALioSignal_0.pPV_Name:= para.pvAdr;
									para.pvChecked:= TRUE;
								ELSE
									(* PV address not found => set error *)
									stepFub:= halSTP_ERROR;
									CfgModError:= TRUE;
									pErrInfo1:= ADR(para.pvName);
									pErrInfo2:= ADR(pvName);
									itoa(status_PV_xgetadr, ADR(strErrNb));
									pErrInfo3:= ADR(strErrNb);
									status:= halERR_PV_NOT_FOUND;
								END_IF;
							END_IF;
	
						(******************************************
						* check PV parameter
						******************************************)
						halCHK_PV_PAR:
							(* check attribute ID values *)
							IF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_ACTIVE)) = 0) AND (para.pvParChecked.halPAR_ACTIVE = FALSE) THEN
								para.checkPar:= halCHK_PAR_ACTIVE;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_TYPE)) = 0) AND (para.pvParChecked.halPAR_TYPE = FALSE) THEN
								para.checkPar:= halCHK_PAR_TYPE;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_QUAL_MIN)) = 0) AND (para.pvParChecked.halPAR_QUAL_MIN = FALSE) THEN
								para.checkPar:= halCHK_PAR_QUAL_MIN;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_QUAL_MAX)) = 0) AND (para.pvParChecked.halPAR_QUAL_MAX = FALSE) THEN
								para.checkPar:= halCHK_PAR_QUAL_MAX;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_MSG_NUM)) = 0) AND (para.pvParChecked.halPAR_MSG_NUM = FALSE) THEN
								para.checkPar:= halCHK_PAR_MSG_NUM;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_SCAL_X1)) = 0) AND (para.pvParChecked.halPAR_SCAL_X1 = FALSE) THEN
								para.checkPar:= halCHK_PAR_SCAL_X1;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_SCAL_X2)) = 0) AND (para.pvParChecked.halPAR_SCAL_X2 = FALSE) THEN
								para.checkPar:= halCHK_PAR_SCAL_X2;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_SCAL_Y1)) = 0) AND (para.pvParChecked.halPAR_SCAL_Y1 = FALSE) THEN
								para.checkPar:= halCHK_PAR_SCAL_Y1;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_SCAL_Y2)) = 0) AND (para.pvParChecked.halPAR_SCAL_Y2 = FALSE) THEN
								para.checkPar:= halCHK_PAR_SCAL_Y2;
							ELSIF (strcmp(ADR(para.attribute[0].value), ADR(halATTR_ID_FILTER)) = 0) AND (para.pvParChecked.halPAR_FILTER = FALSE) THEN
								para.checkPar:= halCHK_PAR_FILTER;
							ELSE
								(* not a valid attribute ID => nothing to check *)
								para.checkPar:= halCHK_PAR_NOTHING;
							END_IF;
		
							(*=================================================
							* state machine check paramter ID
							*================================================*)
							CASE para.checkPar OF
								(******************************************
								* check parameter ID = Active
								******************************************)
								halCHK_PAR_ACTIVE:
									IF (strcmp(ADR(para.attribute[1].value), ADR('0')) = 0) THEN
										HALioSignal_0.Active:= FALSE;
										para.pvParChecked.halPAR_ACTIVE:= TRUE;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('1')) = 0) THEN
										HALioSignal_0.Active:= TRUE;
										para.pvParChecked.halPAR_ACTIVE:= TRUE;
									ELSE
										(* not a correct value => set error *)
										stepFub:= halSTP_ERROR;
										CfgModError:= TRUE;
										pErrInfo1:= ADR(para.pvName);
										pErrInfo2:= ADR(para.attribute[0].value);
										pErrInfo3:= ADR(para.attribute[1].value);
										status:= halERR_PARAMETER_VALUE_NV;
									END_IF;
		
								(******************************************
								* check parameter ID = Type
								* get address of external parameter PV
								* get address of signal PV
								******************************************)
								halCHK_PAR_TYPE:
									IF (strcmp(ADR(para.attribute[1].value), ADR('DI_NORMAL')) = 0) THEN
										Type:= DI_NORMAL;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('DI_NORMAL_INV')) = 0) THEN
										Type:= DI_NORMAL_INV;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('DO_NORMAL')) = 0) THEN
										Type:= DO_NORMAL;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_0_20mA_INT16')) = 0) THEN
										Type:= AI_0_20mA_INT16;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_0_10V_INT16')) = 0) THEN
										Type:= AI_0_10V_INT16;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_10_10V_INT16')) = 0) THEN
										Type:= AI_10_10V_INT16;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_TEMP_1_10C')) = 0) THEN
										Type:= AI_TEMP_1_10C;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_INT8')) = 0) THEN
										Type:= AI_INT8;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_INT16')) = 0) THEN
										Type:= AI_INT16;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_INT32')) = 0) THEN
										Type:= AI_INT32;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AO_0_20mA_INT16')) = 0) THEN
										Type:= AO_0_20mA_INT16;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AO_0_10V_INT16')) = 0) THEN
										Type:= AO_0_10V_INT16;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AO_10_10V_INT16')) = 0) THEN
										Type:= AO_10_10V_INT16;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('DI_NORMAL_UR20')) = 0) THEN
										Type:= DI_NORMAL_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('DI_NORMAL_INV_UR20')) = 0) THEN
										Type:= DI_NORMAL_INV_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('DO_NORMAL_UR20')) = 0) THEN	
										Type:= DO_NORMAL_UR20;										
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_0_20mA_INT16_UR20')) = 0) THEN
										Type:= AI_0_20mA_INT16_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_0_10V_INT16_UR20')) = 0) THEN
										Type:= AI_0_10V_INT16_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_10_10V_INT16_UR20')) = 0) THEN
										Type:= AI_10_10V_INT16_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_TEMP_1_10C_UR20')) = 0) THEN
										Type:= AI_TEMP_1_10C_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_INT8_UR20')) = 0) THEN
										Type:= AI_INT8_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_INT16_UR20')) = 0) THEN
										Type:= AI_INT16_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AI_INT32_UR20')) = 0) THEN
										Type:= AI_INT32_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AO_0_20mA_INT16_UR20')) = 0) THEN
										Type:= AO_0_20mA_INT16_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AO_0_10V_INT16_UR20')) = 0) THEN
										Type:= AO_0_10V_INT16_UR20;
									ELSIF (strcmp(ADR(para.attribute[1].value), ADR('AO_10_10V_INT16_UR20')) = 0) THEN
										Type:= AO_10_10V_INT16_UR20;
									ELSE
										(* not a valid type => set dummy type *)
										Type:= halERR_FUB_BUSY;
									END_IF;
									
									IF (Type <> halERR_FUB_BUSY) THEN
										(* type OK *)
										HALioSignal_0.Type:= Type;
		
										(* get address of external parameter PV *)
										nextAdr:= strcpy(ADR(pvName), ADR(para.pvAppName));
										(* add prefix of PV name *)
										nextAdr:= strcat(nextAdr, ADR('x'));
										nextAdr:= strcat(nextAdr, ADR(para.pvName));
										status_PV_xgetadr:= PV_xgetadr(ADR(pvName), ADR(para.pvAdr), ADR(para.pvLen));
										IF (status_PV_xgetadr = halERR_NO_ERROR) THEN
											(* check length of external parameter PV *)
											IF (para.pvLen = SIZEOF(sigExtPar)) THEN
												(* all OK *)
												HALioSignal_0.pExtern:= para.pvAdr;
											ELSE
												(* external parameter PV length does not match => set error *)
												stepFub:= halSTP_ERROR;
												CfgModError:= TRUE;
												pErrInfo1:= ADR(para.pvName);
												pErrInfo2:= ADR(pvName);
												pErrInfo3:= pEmptyString;
												status:= halERR_PARPV_LENGTH_NOT_MATCHING;
											END_IF;
										ELSE
											(* no external parameter PV defined *)
											HALioSignal_0.pExtern:= 0;
										END_IF;

										IF (status = halERR_FUB_BUSY) THEN
											(* get address of signal PV *)
											nextAdr:= strcpy(ADR(pvName), ADR(para.pvAppName));
											(* add prefix of PV name *)
											nextAdr:= strcat(nextAdr, ADR('t'));
											nextAdr:= strcat(nextAdr, ADR(para.pvName));
											status_PV_xgetadr:= PV_xgetadr(ADR(pvName), ADR(para.pvAdr), ADR(para.pvLen));
											IF (status_PV_xgetadr = halERR_NO_ERROR) THEN
												(* Check if signal PV lenght match signal type *)
												CASE Type OF
													DI_NORMAL, DI_NORMAL_INV,
													DI_NORMAL_UR20, DI_NORMAL_INV_UR20:
														IF (para.pvLen <> SIZEOF(sigDi)) THEN
															stepFub:= halSTP_ERROR;
														END_IF;
													DO_NORMAL,
													DO_NORMAL_UR20:
														IF (para.pvLen <> SIZEOF(sigDo)) THEN
															stepFub:= halSTP_ERROR;
														END_IF;
													AI_0_20mA_INT16, AI_0_10V_INT16, AI_10_10V_INT16, AI_TEMP_1_10C,
													AI_0_20mA_INT16_UR20, AI_0_10V_INT16_UR20, AI_10_10V_INT16_UR20, AI_TEMP_1_10C_UR20:
														IF (para.pvLen <> SIZEOF(sigAi)) THEN
															stepFub:= halSTP_ERROR;
														END_IF;
													AI_INT8, AI_INT16, AI_INT32,
													AI_INT8_UR20, AI_INT16_UR20, AI_INT32_UR20:
														IF (para.pvLen <> SIZEOF(sigAi_INT)) THEN
															stepFub:= halSTP_ERROR;
														END_IF;
													AO_0_20mA_INT16, AO_0_10V_INT16, AO_10_10V_INT16,
													AO_0_20mA_INT16_UR20, AO_0_10V_INT16_UR20, AO_10_10V_INT16_UR20:
														IF (para.pvLen <> SIZEOF(sigAo)) THEN
															stepFub:= halSTP_ERROR;
														END_IF;
												END_CASE;
												IF (stepFub = halSTP_ERROR) THEN
													(* signal PV lenght does not match signal type => set error *)
													CfgModError:= TRUE;
													pErrInfo1:= ADR(para.pvName);
													pErrInfo2:= ADR(pvName);
													itoa(Type, ADR(strErrNb));
													pErrInfo3:= ADR(strErrNb);
													status:= halERR_SIGPV_LENGTH_NOT_MATCHING;
												ELSE
													(* all OK *)
													HALioSignal_0.pSignal:= para.pvAdr;
													para.pvParChecked.halPAR_TYPE:= TRUE;
												END_IF;
											ELSE
												(* signal PV not found => set error *)
												stepFub:= halSTP_ERROR;
												CfgModError:= TRUE;
												pErrInfo1:= ADR(para.pvName);
												pErrInfo2:= ADR(pvName);
												itoa(status_PV_xgetadr, ADR(strErrNb));
												pErrInfo3:= ADR(strErrNb);
												status:= halERR_PV_NOT_FOUND;
											END_IF;
										END_IF;
									ELSE
										(* not a valid type => set error *)
										stepFub:= halSTP_ERROR;
										CfgModError:= TRUE;
										pErrInfo1:= ADR(para.pvName);
										pErrInfo2:= ADR(para.attribute[0].value);
										pErrInfo3:= ADR(para.attribute[1].value);
										status:= halERR_PARAMETER_VALUE_NV;
									END_IF;
	
								(******************************************
								* check parameter ID = Qual_Min
								******************************************)
								halCHK_PAR_QUAL_MIN:
									iVal:= atoi(ADR(para.attribute[1].value));
									IF (iVal >= -32768) AND (iVal <= 32767) THEN
										(* all OK *)
										HALioSignal_0.Qual_Min:= DINT_TO_INT(iVal);
										para.pvParChecked.halPAR_QUAL_MIN:= TRUE;
									ELSE
										(* not a correct value => set error *)
										stepFub:= halSTP_ERROR;
										CfgModError:= TRUE;
										pErrInfo1:= ADR(para.pvName);
										pErrInfo2:= ADR(para.attribute[0].value);
										pErrInfo3:= ADR(para.attribute[1].value);
										status:= halERR_PARAMETER_VALUE_NV;
									END_IF;
	
								(******************************************
								* check parameter ID = Qual_Max
								******************************************)
								halCHK_PAR_QUAL_MAX:
									iVal:= atoi(ADR(para.attribute[1].value));
									IF (iVal >= -32768) AND (iVal <= 32767) THEN
										(* all OK *)
										HALioSignal_0.Qual_Max:= DINT_TO_INT(iVal);
										para.pvParChecked.halPAR_QUAL_MAX:= TRUE;
									ELSE
										(* not a correct value => set error *)
										stepFub:= halSTP_ERROR;
										CfgModError:= TRUE;
										pErrInfo1:= ADR(para.pvName);
										pErrInfo2:= ADR(para.attribute[0].value);
										pErrInfo3:= ADR(para.attribute[1].value);
										status:= halERR_PARAMETER_VALUE_NV;
									END_IF;
	
								(******************************************
								* check parameter ID = Msg_Num
								******************************************)
								halCHK_PAR_MSG_NUM:
									iVal:= atoi(ADR(para.attribute[1].value));
									IF (iVal = 0) AND (strcmp(ADR(para.attribute[1].value) , ADR('0')) = 0) THEN
										(* no message defined *)
										HALioSignal_0.pMsg:= 0;
										para.pvParChecked.halPAR_MSG_NUM:= TRUE;
										
									ELSIF (iVal >= 1) AND (iVal <= 8) THEN
										(* interpret message number as task class *)
										HALioSignal_0.pMsg:= 0;
										HALioSignal_0.TaskClass := iVal;
										para.pvParChecked.halPAR_MSG_NUM:= TRUE;
										
									ELSIF (iVal >= 1000) AND (iVal <= 9999) THEN
										(* correct message number *)
										nextAdr:= strcpy(ADR(pvName), ADR(para.pvAppName));
										nextAdr:= strcat(nextAdr, ADR('Msg'));
										nextAdr:= strcat(nextAdr, ADR(para.attribute[1].value));
										status_PV_xgetadr:= PV_xgetadr(ADR(pvName), ADR(para.pvAdr), ADR(para.pvLen));
										IF (status_PV_xgetadr = halERR_NO_ERROR) THEN
											(* all OK *)
											HALioSignal_0.pMsg:= para.pvAdr;
											para.pvParChecked.halPAR_MSG_NUM:= TRUE;
										ELSE
											(* message PV not found => set error *)
											stepFub:= halSTP_ERROR;
											CfgModError:= TRUE;
											pErrInfo1:= ADR(para.pvName);
											pErrInfo2:= ADR(pvName);
											itoa(status_PV_xgetadr, ADR(strErrNb));
											pErrInfo3:= ADR(strErrNb);
											status:= halERR_PV_NOT_FOUND;
										END_IF;
									ELSE
										(* not a correct value => set error *)
										stepFub:= halSTP_ERROR;
										CfgModError:= TRUE;
										pErrInfo1:= ADR(para.pvName);
										pErrInfo2:= ADR(para.attribute[0].value);
										pErrInfo3:= ADR(para.attribute[1].value);
										status:= halERR_PARAMETER_VALUE_NV;
									END_IF;
	
								(******************************************
								* check parameter ID = Scal_X1
								******************************************)
								halCHK_PAR_SCAL_X1:
									iVal:= atoi(ADR(para.attribute[1].value));
									IF (iVal >= -32768) AND (iVal <= 32767) THEN
										(* all OK *)
										HALioSignal_0.Scal_X1:= iVal;
										para.pvParChecked.halPAR_SCAL_X1:= TRUE;
									ELSE
										(* not a correct value => set error *)
										stepFub:= halSTP_ERROR;
										CfgModError:= TRUE;
										pErrInfo1:= ADR(para.pvName);
										pErrInfo2:= ADR(para.attribute[0].value);
										pErrInfo3:= ADR(para.attribute[1].value);
										status:= halERR_PARAMETER_VALUE_NV;
									END_IF;
	
								(******************************************
								* check parameter ID = Scal_X2
								******************************************)
								halCHK_PAR_SCAL_X2:
									iVal:= atoi(ADR(para.attribute[1].value));
									IF (iVal >= -32768) AND (iVal <= 32767) THEN
										(* all OK *)
										HALioSignal_0.Scal_X2:= iVal;
										para.pvParChecked.halPAR_SCAL_X2:= TRUE;
									ELSE
										(* not a correct value => set error *)
										stepFub:= halSTP_ERROR;
										CfgModError:= TRUE;
										pErrInfo1:= ADR(para.pvName);
										pErrInfo2:= ADR(para.attribute[0].value);
										pErrInfo3:= ADR(para.attribute[1].value);
										status:= halERR_PARAMETER_VALUE_NV;
									END_IF;
	
								(******************************************
								* check parameter ID = Scal_Y1
								******************************************)
								halCHK_PAR_SCAL_Y1:
									rVal:= atof(ADR(para.attribute[1].value));
									HALioSignal_0.Scal_Y1:= rVal;
									para.pvParChecked.halPAR_SCAL_Y1:= TRUE;
	
								(******************************************
								* check parameter ID = Scal_Y2
								******************************************)
								halCHK_PAR_SCAL_Y2:
									rVal:= atof(ADR(para.attribute[1].value));
									HALioSignal_0.Scal_Y2:= rVal;
									para.pvParChecked.halPAR_SCAL_Y2:= TRUE;
	
								(******************************************
								* check parameter ID = Filter
								******************************************)
								halCHK_PAR_FILTER:
									iVal:= atoi(ADR(para.attribute[1].value));
									IF (iVal >= 0) AND (iVal <= 5000) THEN
										(* all OK *)
										HALioSignal_0.Filter:= DINT_TO_UINT(iVal);
										para.pvParChecked.halPAR_FILTER:= TRUE;
									ELSE
										(* not a correct value => set error *)
										stepFub:= halSTP_ERROR;
										CfgModError:= TRUE;
										pErrInfo1:= ADR(para.pvName);
										pErrInfo2:= ADR(para.attribute[0].value);
										pErrInfo3:= ADR(para.attribute[1].value);
										status:= halERR_PARAMETER_VALUE_NV;
									END_IF;
	
								(******************************************
								* not a valid parameter ID => check nothing
								******************************************)
								halCHK_PAR_NOTHING:
									IF (stepFub <> halSTP_ERROR) THEN
										stepFub:= halSTP_READ_NODE;
									END_IF;
	
							(*=================================================
							* END of state machine check paramter ID
							*================================================*)
							END_CASE; (* para.checkPar *)
	
							(* all parameters checked? *)
							IF (stepFub <> halSTP_ERROR) THEN
								stepFub:= halSTP_READ_NODE;
								IF para.pvParChecked.halPAR_ACTIVE AND
								   para.pvParChecked.halPAR_TYPE AND
								   para.pvParChecked.halPAR_QUAL_MIN AND
								   para.pvParChecked.halPAR_QUAL_MAX AND
								   para.pvParChecked.halPAR_MSG_NUM AND
								   para.pvParChecked.halPAR_SCAL_X1 AND
								   para.pvParChecked.halPAR_SCAL_X2 AND
								   para.pvParChecked.halPAR_SCAL_Y1 AND
								   para.pvParChecked.halPAR_SCAL_Y2 AND
								   para.pvParChecked.halPAR_FILTER THEN
									para.pvAllParChecked:= TRUE;
								END_IF;
							END_IF;
	
						(******************************************
						* not a valid node type => check nothing
						******************************************)
						halCHK_NOTHING:
							IF (stepFub <> halSTP_ERROR) THEN
								stepFub:= halSTP_READ_NODE;
							END_IF;
		
					(*=======================================================
					* END of state machine check node type
					*======================================================*)
					END_CASE; (* para.checkType *)
	
				ELSE
					(* max number of IO Channels exceeded => set error *)
					stepFub:= halSTP_ERROR;
					status:= halERR_MAX_NUM_IOS_TOO_LOW;
				END_IF;
			END_IF;
			
//		(****************************************************
//		* read attribute
//		* (not used any more, because it is done in step halSTP_READ_NODE)
//		****************************************************)
//		halSTP_READ_ATTRIBUTE:

//		(****************************************************
//		* check data
//		* (not used any more, because it is done in step halSTP_READ_NODE)
//		****************************************************)
//		halSTP_CHECK_DATA:

		(****************************************************
		* error occured
		****************************************************)
		halSTP_ERROR:
			(* set FUB outputs *)
			ParOK:= FALSE;
			ActNumIoChannels:= para.actIoChannel;
			CfgModError:= TRUE;

			IF (xmlCloseMemoryReader_0.enable) THEN
				xmlCloseMemoryReader_0();
				IF (xmlCloseMemoryReader_0.status <> halERR_FUB_BUSY) THEN
					xmlCloseMemoryReader_0.enable:= FALSE;
				END_IF;
			END_IF;

		(****************************************************
		* close XML reader
		****************************************************)
		halSTP_CLOSE_READER:
			xmlCloseMemoryReader_0();

			IF (xmlCloseMemoryReader_0.status <> halERR_FUB_BUSY) THEN
				stepFub:= halSTP_FINISHED;
			END_IF;

			(* set FUB outputs *)
			ParOK:= FALSE;
			ActNumIoChannels:= para.actIoChannel;
			CfgModError:= FALSE;
			pErrInfo1:= pEmptyString;
			pErrInfo2:= pEmptyString;
			pErrInfo3:= pEmptyString;
			status:= halERR_FUB_BUSY;

		(****************************************************
		* finished
		****************************************************)
		halSTP_FINISHED:
			(* set FUB outputs *)
			IF (para.actIoChannel <> 0) THEN
				ParOK:= TRUE;
			ELSE
				ParOK:= FALSE;
			END_IF;
			ActNumIoChannels:= para.actIoChannel;
			CfgModError:= FALSE;
			pErrInfo1:= pEmptyString;
			pErrInfo2:= pEmptyString;
			pErrInfo3:= pEmptyString;
			status:= halERR_NO_ERROR;

	(*=================================================================
	* END of state machine main
	*================================================================*)
	END_CASE; (* stepFub *)

END_FUNCTION_BLOCK