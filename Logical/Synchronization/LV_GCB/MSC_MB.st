(********************************************************************
 * COPYRIGHT -- INNIO, MSC
 ********************************************************************
 * Library: MSC_MB
 * File: MSC_MB.st
 * Author: Hohensinner Michael
 * Created: April 29, 2021
 ********************************************************************
 * Functions and function blocks of library MSC_MB
 ********************************************************************)
(* ModBus Master function block 4 easy use *)
FUNCTION MSC_MB_RegUpdate
	MSC_MB_RegUpdate := 0;
	bError := FALSE;
	IF tSlave.bSkip THEN
		iWrite	:=	0;
		iRead	:=	0;
		FOR x:=0 TO _MB_CMD_MAX DO
			tSlave.tLine[x].tIF.bExec	:=	FALSE;
		END_FOR
		RETURN;
	END_IF
	FOR x:=0 TO _MB_CMD_MAX DO
		IF tSlave.tLine[x].tDef.pDest > 0 THEN
			CASE tSlave.tLine[x].tDef.iFC OF
				1,2,5,15:	iByteSize := 2 * REAL_TO_UINT(brmceil((UINT_TO_REAL(tSlave.tLine[x].tDef.iLen) + USINT_TO_REAL(tSlave.tLine[x].tDef.iBitOffs))/16.0));		//Bitwise
				3,4,6,16:	iByteSize := 2 * REAL_TO_UINT(brmceil(UINT_TO_REAL(tSlave.tLine[x].tDef.iLen) + USINT_TO_REAL(tSlave.tLine[x].tDef.iBitOffs)/16.0));		//Wordwise
				ELSE
					MSC_MB_RegUpdate := 1;
					RETURN;	// Wrong function code
			END_CASE	
			IF SIZEOF(iTemp) < iByteSize THEN
				MSC_MB_RegUpdate := 2;
				RETURN;	// To small temporary register				
			END_IF
			IF iByteSize < 2 THEN
				MSC_MB_RegUpdate := 3;
				RETURN;	// To small, at least a word to copy (should not happen)				
			END_IF
			brsmemcpy(ADR(iTemp),tSlave.tLine[x].tDef.pDest,iByteSize);	
			
			CASE tSlave.tLine[x].tDef.iFC OF
				1..4:
					IF GET_BIT_UINT_ARRAY(x,ADR(iRead)) THEN
						tSlave.tLine[x].tIF.bExec	:=	bEnaRead;
					END_IF
				5,6,15,16:
					IF GET_BIT_UINT_ARRAY(x,ADR(iWrite)) THEN
						tSlave.tLine[x].tIF.bExec	:=	bEnaWrite;
					END_IF				
			END_CASE
			IF tSlave.tLine[x].tIF.iStatus <> 0 AND tSlave.tLine[x].tIF.iStatus <> 65535 THEN
				bError := TRUE;			
				iError := tSlave.tLine[x].tIF.iStatus;
			END_IF
			
			CASE tSlave.tLine[x].tDef.iFC OF
				1,2:
					FOR i:= 0 TO  MAX(0,tSlave.tLine[x].tDef.iLen-1) DO
						IF i > _MB_BIN_MAX THEN
							MSC_MB_RegUpdate := tSlave.tLine[x].tDef.iFC * 10 + 1;
							RETURN;	// OUT OF BINARY BOUNDS
						END_IF
						SET_BIT_UINT_ARRAY(tSlave.tLine[x].tIF.bData[i],i + tSlave.tLine[x].tDef.iBitOffs,ADR(iTemp));
					END_FOR			
					brsmemcpy(tSlave.tLine[x].tDef.pDest,ADR(iTemp),iByteSize);
				3,4:
					IF tSlave.tLine[x].tDef.iBitOffs = 0 THEN
						brsmemcpy(tSlave.tLine[x].tDef.pDest,ADR(tSlave.tLine[x].tIF.iData),tSlave.tLine[x].tDef.iLen*2);	
					ELSE
						FOR i:= 0 TO MAX(0,tSlave.tLine[x].tDef.iLen*16-1) DO
							IF i/16 > _MB_REG_MAX THEN
								MSC_MB_RegUpdate := tSlave.tLine[x].tDef.iFC * 10 + 1;
								RETURN;	// OUT OF REGISTER BOUNDS
							END_IF
							SET_BIT_UINT_ARRAY(GET_BIT_UINT_ARRAY(i,ADR(tSlave.tLine[x].tIF.iData)),i + tSlave.tLine[x].tDef.iBitOffs,ADR(iTemp));
						END_FOR		
						brsmemcpy(tSlave.tLine[x].tDef.pDest,ADR(iTemp),iByteSize);				
					END_IF
					
				5,15:
					IF tSlave.tLine[x].tDef.iFC = 5 THEN
						tSlave.tLine[x].tIF.bData[0] := GET_BIT_UINT_ARRAY(tSlave.tLine[x].tDef.iBitOffs,ADR(iTemp));
					ELSIF tSlave.tLine[x].tDef.iFC = 15 THEN
						FOR i:= 0 TO MAX(0, tSlave.tLine[x].tDef.iLen-1) DO
							IF i > _MB_BIN_MAX THEN
								MSC_MB_RegUpdate := tSlave.tLine[x].tDef.iFC * 10 + 1;
								RETURN;	// OUT OF BINARY BOUNDS
							END_IF
							tSlave.tLine[x].tIF.bData[i]	:=	GET_BIT_UINT_ARRAY(i+tSlave.tLine[x].tDef.iBitOffs,ADR(iTemp));
						END_FOR
					END_IF

				6,16:		
					IF tSlave.tLine[x].tDef.iBitOffs = 0 THEN
						FOR i:= 0 TO MAX(0,tSlave.tLine[x].tDef.iLen-1) DO
							IF i > _MB_REG_MAX THEN
								MSC_MB_RegUpdate := tSlave.tLine[x].tDef.iFC * 10;
								RETURN;	// OUT OF REGISTER BOUNDS
							END_IF
							tSlave.tLine[x].tIF.iData[i]	:=	iTemp[i];
						END_FOR
					ELSE
						FOR i:= 0 TO MAX(0,tSlave.tLine[x].tDef.iLen*16-1) DO
							IF i/16 > _MB_REG_MAX THEN
								MSC_MB_RegUpdate := tSlave.tLine[x].tDef.iFC * 10 + 1;
								RETURN;	// OUT OF REGISTER BOUNDS
							END_IF
							SET_BIT_UINT_ARRAY(GET_BIT_UINT_ARRAY(i+tSlave.tLine[x].tDef.iBitOffs,ADR(iTemp)),i,ADR(tSlave.tLine[x].tIF.iData));	
						END_FOR	
					END_IF
			END_CASE
		END_IF
	END_FOR
	IF NOT bError THEN	
		iError	:=	0;
	END_IF
	iWrite	:=	0;
	iRead	:=	0;
	RETURN;
END_FUNCTION

FUNCTION_BLOCK MSC_MBMaster
	IF bEnable THEN
		CASE eState OF
			_MB_DEFAULT:
				IF tCmd.bOpen THEN
					tCmd.bOpen	:=	FALSE;
					eState		:=	_MB_OPEN;
				END_IF
			_MB_OPEN:
				xMBMOpen.enable		:= TRUE;
				xMBMOpen.pDevice	:= ADR(tCfg.sDevice);
				xMBMOpen.pMode		:= ADR(tCfg.sMode);
				xMBMOpen.pConfig	:= ADR(tCfg.sFile);
				xMBMOpen.timeout	:= tCfg.iTimeOut;
				xMBMOpen.ascii		:= BOOL_TO_USINT(tCfg.bASCII);
				xMBMOpen();
				IF (xMBMOpen.status <> ERR_FUB_BUSY) THEN
					IF (xMBMOpen.status = ERR_OK) THEN
						xMBMaster.enable	:=	TRUE;
						xMBMaster.ident		:=	xMBMOpen.ident;							
						eState				:=	_MB_RUN;
					ELSE
						eError				:=	eState;
						iError				:=	xMBMOpen.status;
						eState				:=	_MB_ERROR;
					END_IF
				END_IF
			_MB_RUN:
				IF tCmd.bClose THEN
					tCmd.bClose			:=	FALSE;
					xMBMaster.enable	:=	FALSE;
					xMBMClose.enable	:=	TRUE;
					xMBMClose.ident		:=	xMBMOpen.ident;
					eState 				:=	_MB_CLOSE;
				ELSE
					xMBMaster();
				END_IF		
			_MB_CLOSE:
				xMBMClose();
				IF (xMBMClose.status <> ERR_FUB_BUSY) THEN
					IF (xMBMClose.status = ERR_OK) THEN
						eState		:=	_MB_DEFAULT;
					ELSE
						eError		:=	eState;
						iError		:=	xMBMOpen.status;						
						eState		:=	_MB_ERROR;
					END_IF
				END_IF
			_MB_ERROR:
				IF tCmd.bAckn THEN
					tCmd.bAckn		:=	FALSE;
					eState			:=	_MB_DEFAULT;
				END_IF
		END_CASE
	END_IF
	bExec	:=	xMBMaster.execute;
	iRecNum	:=	xMBMaster.recordnum;
	iStatus	:=	xMBMaster.status;
END_FUNCTION_BLOCK
(* ModBus Slave function block 4 easy use *)
FUNCTION_BLOCK MSC_MBSlave
	IF bEnable THEN
		CASE eState OF
			_MB_DEFAULT:
				IF tCmd.bOpen THEN
					tCmd.bOpen	:=	FALSE;
					eState		:=	_MB_OPEN;
				END_IF
			_MB_OPEN:
				xMBSOpen.enable		:= TRUE;
				xMBSOpen.pDevice	:= ADR(tCfg.sDevice);
				xMBSOpen.pMode		:= ADR(tCfg.sMode);
				xMBSOpen.own_ID		:= tCfg.iID;
				xMBSOpen.timeout	:= tCfg.iTimeOut;
				xMBSOpen.pCoilStat	:= tCfg.pCoilStat;
				xMBSOpen.pHoldingReg:= tCfg.pHoldReg;
				xMBSOpen.pInputReg	:= tCfg.pInReg;
				xMBSOpen.pInputStat	:= tCfg.pInStat;
				xMBSOpen();
				IF (xMBSOpen.status <> ERR_FUB_BUSY) THEN
					IF (xMBSOpen.status = ERR_OK) THEN
						xMBSlave.enable	:=	TRUE;
						xMBSlave.ident		:=	xMBSOpen.ident;							
						eState				:=	_MB_RUN;
					ELSE
						eError				:=	eState;
						iError				:=	xMBSOpen.status;
						eState				:=	_MB_ERROR;
					END_IF
				END_IF
			_MB_RUN:
				IF tCmd.bClose THEN
					tCmd.bClose			:=	FALSE;
					xMBSlave.enable		:=	FALSE;
					xMBSClose.enable	:=	TRUE;
					xMBSClose.ident		:=	xMBSOpen.ident;
					eState 				:=	_MB_CLOSE;
				ELSE
					xMBSlave();
				END_IF		
			_MB_CLOSE:
				xMBSClose();
				IF (xMBSClose.status <> ERR_FUB_BUSY) THEN
					IF (xMBSClose.status = ERR_OK) THEN
						eState		:=	_MB_DEFAULT;
					ELSE
						eError		:=	eState;
						iError		:=	xMBSOpen.status;						
						eState		:=	_MB_ERROR;
					END_IF
				END_IF
			_MB_ERROR:
				IF tCmd.bAckn THEN
					tCmd.bAckn		:=	FALSE;
					eState			:=	_MB_DEFAULT;
				END_IF
		END_CASE
	END_IF
END_FUNCTION_BLOCK

(* ModBus Data Object single line *)
FUNCTION_BLOCK MSC_MB_DataLine
	(* clear old data if previously used *)	
	FOR iBegin:=0 TO _MB_DATALINE_MAX DO
		iData[iBegin]	:=	0;
	END_FOR
	bError	:=	FALSE;
	iBegin	:=	0;
	iStrLen	:=	0;
	sData	:=	'';
	(* Execution variable BEGIN *)
	brsstrcat(ADR(sData),ADR('"'));
	IF pName_Module > 0 THEN
		brsstrcat(ADR(sData),pName_Module);
		brsstrcat(ADR(sData),ADR('::'));
	END_IF
	IF pName_Task > 0 THEN
		brsstrcat(ADR(sData),pName_Task);
		brsstrcat(ADR(sData),ADR(':'));
	END_IF
	IF pName_Struct > 0 THEN	
		brsstrcat(ADR(sData),pName_Struct);
	ELSE
		brsstrcat(ADR(sData),ADR('tSlave'));
	END_IF
	brsitoa(iIdx_Slave,ADR(sTemp));
	brsstrcat(ADR(sData),ADR('['));
	brsstrcat(ADR(sData),ADR(sTemp));
	brsstrcat(ADR(sData),ADR(']'));

	brsstrcat(ADR(sData),ADR('.tLine'));
	brsitoa(iIdx_Line,ADR(sTemp));
	brsstrcat(ADR(sData),ADR('['));
	brsstrcat(ADR(sData),ADR(sTemp));
	brsstrcat(ADR(sData),ADR('].tIF.bExec"'));
	
	iStrLen := brsstrlen(ADR(sData))-2;
	IF iStrLen < _MB_DATALINE_MAX THEN
		brsmemcpy(ADR(iData[0]),ADR(sData)+1,iStrLen);
	ELSE
		bError	:=	TRUE;
	END_IF
	(* Execution variable END *)
	
	(* Spacing *)
	iData[iStrLen] := 0;
	(* Functional code *)
	iData[iStrLen+1] := iFC;
	(* Address of slave *)
	iData[iStrLen+2] := iAdr_Slave;		
	iBegin := iStrLen+3;

	(* Data variable BEGIN *)
	sData := '';
	brsstrcat(ADR(sData),ADR('"'));	
	IF pName_Module > 0 THEN
		brsstrcat(ADR(sData),pName_Module);
		brsstrcat(ADR(sData),ADR('::'));
	END_IF
	IF pName_Task > 0 THEN
		brsstrcat(ADR(sData),pName_Task);
		brsstrcat(ADR(sData),ADR(':'));
	END_IF
	IF pName_Struct > 0 THEN	
		brsstrcat(ADR(sData),pName_Struct);
	ELSE
		brsstrcat(ADR(sData),ADR('tSlave'));
	END_IF

	brsitoa(iIdx_Slave,ADR(sTemp));
	brsstrcat(ADR(sData),ADR('['));
	brsstrcat(ADR(sData),ADR(sTemp));
	brsstrcat(ADR(sData),ADR(']'));

	brsstrcat(ADR(sData),ADR('.tLine'));
	brsitoa(iIdx_Line,ADR(sTemp));
	brsstrcat(ADR(sData),ADR('['));
	brsstrcat(ADR(sData),ADR(sTemp));
	brsstrcat(ADR(sData),ADR('].tIF.'));
	
	CASE iFC OF
		1,2,15:	brsstrcat(ADR(sData),ADR('bData'));	
		3,4,16:	brsstrcat(ADR(sData),ADR('iData'));
		5:	brsstrcat(ADR(sData),ADR('bData[0]'));
		6:	brsstrcat(ADR(sData),ADR('iData[0]'));
		ELSE
			brsstrcat(ADR(sData),ADR('bNA'));	//through error here
	END_CASE	
	brsstrcat(ADR(sData),ADR('"'));
	iStrLen := brsstrlen(ADR(sData))-2;
	IF iBegin + iStrLen + 4 < _MB_DATALINE_MAX THEN
		brsmemcpy(ADR(iData[iBegin]),ADR(sData)+1,iStrLen);
		(* Data variable END *)
		
		(* Spacing *)	
		iData[iBegin + iStrLen] := 0;
		
		(* Offset *)		
		iData[iBegin + iStrLen + 1] := UDINT_TO_USINT(iOffset MOD 256);	
		iData[iBegin + iStrLen + 2] := UDINT_TO_USINT(iOffset / 256);
		iStrLen	:=	iBegin + iStrLen + 2 + 1;
		
		(* Length *)		
		iData[iStrLen] := UDINT_TO_USINT(iLength MOD 256);	
		iData[iStrLen+1] := UDINT_TO_USINT(iLength / 256);	
		iStrLen	:=	iStrLen + 2;
	ELSE
		bError	:=	TRUE;
	END_IF	
	
END_FUNCTION_BLOCK

(* ModBus Data Object multiple lines *)
FUNCTION_BLOCK MSC_MB_DataSet
	(* clear old data if previously used *)
	iStrLen	:=	0;
	bError	:=	FALSE;
	FOR i:=0 TO _MB_DATASET_MAX DO
		iData[i]	:=	0;
	END_FOR
	
	(* handle over static slave data *)
	xLine.pName_Module	:=	pName_Module;
	xLine.pName_Task	:=	pName_Task;
	xLine.pName_Struct	:=	pName_Struct;
	xLine.iIdx_Slave	:=	iIdx_Slave;
	xLine.iAdr_Slave	:=	iAdr_Slave;
	bEmpty	:=	TRUE;
	
	(* handle over dynamic slave data, execute only if function code is legit *)
	FOR i:= 0 TO _MB_CMD_MAX DO
		IF (tLine[i].tDef.iFC >= 1 AND tLine[i].tDef.iFC <= 6) OR tLine[i].tDef.iFC = 15 OR tLine[i].tDef.iFC = 16	THEN
			xLine.iIdx_Line	:=	UDINT_TO_USINT(i);
			xLine.iFC		:=	tLine[i].tDef.iFC;	
			xLine.iOffset	:=	tLine[i].tDef.iOffs;
			xLine.iLength	:=	tLine[i].tDef.iLen;
	
			xLine();
			
			IF iStrLen + xLine.iStrLen < _MB_DATASET_MAX AND NOT xLine.bError THEN
				brsmemcpy(ADR(iData)+iStrLen,ADR(xLine.iData),xLine.iStrLen);
				iStrLen	:=	iStrLen + xLine.iStrLen;
				bEmpty	:=	FALSE;
			ELSE
				bError	:=	TRUE;
			END_IF
		END_IF
	END_FOR
	
END_FUNCTION_BLOCK


(* ModBus Data Object creator *)
FUNCTION_BLOCK MSC_MB_DOCreate
	
	CASE eState OF
		_MB_DEFAULT:
			xDatObjInfo.enable		:=	TRUE;
			xDatObjInfo.pName 		:=	pName;
			xDatObjDelete.enable	:=	TRUE;
			xDatObjCreate.enable	:=	TRUE;
			xDatObjCreate.pName		:=	pName;
			xDatObjCreate.pCpyData	:=	pCpyData;	
			xDatObjCreate.MemType	:=	iMemType;
			xDatObjCreate.len		:=	iLen;
			IF bEnable THEN
				eState	:=	_MB_INFO;
			END_IF
			bDone := FALSE;
		_MB_INFO:
			xDatObjInfo();
			IF	xDatObjInfo.status = ERR_OK THEN				eState	:=	_MB_DELETE;
			ELSIF xDatObjInfo.status = doERR_MODULNOTFOUND THEN	eState	:=	_MB_CREATE;
			ELSIF xDatObjInfo.status <>  ERR_FUB_BUSY THEN		eState	:=	_MB_ERROR;				
			END_IF
		_MB_DELETE:
			xDatObjDelete.ident		:=	xDatObjInfo.ident;
			xDatObjDelete();
			IF	xDatObjDelete.status = ERR_OK THEN				eState	:=	_MB_CREATE;
			ELSIF	xDatObjDelete.status <>  ERR_FUB_BUSY THEN	eState	:=	_MB_ERROR;				
			END_IF			
		_MB_CREATE:
			xDatObjCreate();
			IF	xDatObjCreate.status = ERR_OK THEN				eState	:=	_MB_DONE;			
			ELSIF	xDatObjCreate.status <>  ERR_FUB_BUSY THEN	eState	:=	_MB_ERROR;				
			END_IF			
		_MB_DONE:
			eState;
			bDone := TRUE;
		_MB_ERROR:
			eState;
	END_CASE
	
END_FUNCTION_BLOCK

(* ModBus Master function block 4 easiest use without data object *)
FUNCTION_BLOCK MSC_MBDOMaster
	CASE eState OF
		_MB_DEFAULT:
			eError	:=	eState;
			IF tCfg.iID > 0 THEN	eState	:=	_MB_START; END_IF
		_MB_START:
			eError	:=	eState;
			xMB_DataSet.pName_Module	:=	pName_Module;
			xMB_DataSet.pName_Task		:=	pName_Task;
			xMB_DataSet.pName_Struct	:=	pName_Struct;

			iLen	:=	0;
			bError	:=	FALSE;
			FOR i:=0 TO _MB_SLAVES_MAX DO
				IF tSlave[i].iMaster = tCfg.iID THEN
					xMB_DataSet.iIdx_Slave	:=	INT_TO_USINT(i);
					xMB_DataSet.iAdr_Slave	:=	tSlave[i].iAdr;
					xMB_DataSet.tLine		:=	tSlave[i].tLine;
					xMB_DataSet();
					
					IF iLen + xMB_DataSet.iStrLen < _MB_DATAOBJ_MAX AND NOT xMB_DataSet.bError AND xMB_DataSet.iStrLen > 0 AND NOT xMB_DataSet.bEmpty THEN
						brsmemcpy(ADR(iData[iLen]),ADR(xMB_DataSet.iData),xMB_DataSet.iStrLen-1);
						iLen					:=	iLen + xMB_DataSet.iStrLen;
					ELSIF NOT xMB_DataSet.bEmpty THEN
						bError	:=	TRUE;
					END_IF
				END_IF
			END_FOR
			IF NOT bError THEN
				xMB_DOCreate.bEnable		:=	TRUE;
				xMB_DOCreate.pName 			:=	ADR(tCfg.sFile);
				xMB_DOCreate.pCpyData		:=	ADR(iData);
				xMB_DOCreate.iLen			:=	iLen;
				xMB_DOCreate.iMemType		:=	iMemType;
				eState	:=	_MB_CREATE;
			ELSE
				eState	:=	_MB_ERROR;
			END_IF
		_MB_CREATE:
			eError	:=	eState;
			xMB_DOCreate();
			IF xMB_DOCreate.bDone THEN
				eState	:=	_MB_CONFIG;
			END_IF
			IF xMB_DOCreate.eState = _MB_ERROR THEN
				eState	:=	_MB_ERROR;
			END_IF				
		_MB_CONFIG:
			eError	:=	eState;
			xMB_Master.bEnable			:=	TRUE;
			xMB_Master.tCfg				:=	tCfg;
			xMB_Master.tCmd				:=	pCmd;
			iEntry						:=	0;
			bError						:=	FALSE;
			FOR i:=0 TO _MB_SLAVES_MAX DO
				IF tSlave[i].iMaster = tCfg.iID THEN
					FOR j:=0 TO _MB_CMD_MAX DO
						IF tSlave[i].tLine[j].tDef.iFC > 0 THEN
							iListSlave[iEntry]	:=	INT_TO_USINT(i);
							iListCmd[iEntry]	:=	INT_TO_USINT(j);
							IF iEntry + 1 <= _MB_ENTRIES_MAX THEN
								iEntry			:=	iEntry + 1;
							ELSE
								bError			:=	TRUE;
							END_IF
						END_IF
					END_FOR
				END_IF
			END_FOR
			IF bError OR iEntry = 0 THEN
				eState	:=	_MB_ERROR;
			ELSE
				eState	:=	_MB_WAIT;
			END_IF
		_MB_WAIT:
			eError	:=	eState;
			IF bEnable THEN	eState	:=	_MB_RUN; END_IF		
			FOR i:=0 TO _MB_SLAVES_MAX DO 
				iLog[i]	:=	0;
			END_FOR
		_MB_RUN:
			eError	:=	eState;
			FOR i:= 0 TO USINT_TO_INT(iEntry) DO						//skip command accelerator
				iRecNum_Old :=	xMB_Master.iRecNum;	
				xMB_Master();
				IF xMB_Master.iRecNum > 0 THEN
					tSlave[iListSlave[xMB_Master.iRecNum-1]].tLine[iListCmd[xMB_Master.iRecNum-1]].tIF.iStatus	:=	xMB_Master.iStatus;
					IF xMB_Master.iStatus > 0 AND xMB_Master.iStatus < ERR_FUB_BUSY THEN
						iLog[iListSlave[xMB_Master.iRecNum-1]]	:=	xMB_Master.iStatus;
					END_IF
					IF iRecNum_Old = xMB_Master.iRecNum THEN EXIT; END_IF
				ELSE
					EXIT;
				END_IF
			END_FOR
			FOR i:=0 TO _MB_SLAVES_MAX DO 
				IF xTON_Reset_Log[i].Q THEN
					iLog[i]	:=	0;
				END_IF
				xTON_Reset_Log[i](IN:= iLog[i] <> 0, PT:=T#5s);
			END_FOR
		_MB_ERROR:
			eState;
			eError;
	END_CASE
	bExec	:=	xMB_Master.bExec;
	iRecNum	:=	xMB_Master.iRecNum;
	iStatus	:=	xMB_Master.iStatus;
END_FUNCTION_BLOCK

FUNCTION MSC_MB_DataCheck
	MSC_MB_DataCheck	:=	0;
	FOR i:=0 TO _MB_SLAVES_MAX DO	
		//		IF tSlave[i].iMaster > _MB_DEVICES_MAX + 1 THEN
		//			MSC_MB_DataCheck	:=	99;
		//			RETURN;
		//		END_IF
		FOR j:=0 TO _MB_CMD_MAX DO
			CASE tSlave[i].tLine[j].tDef.iFC OF
				1,2,15:
					IF tSlave[i].tLine[j].tDef.iLen > _MB_BIN_MAX + 1 THEN
						MSC_MB_DataCheck	:=	tSlave[i].tLine[j].tDef.iFC;
						RETURN;
					END_IF
				3,4,16:	
					IF tSlave[i].tLine[j].tDef.iLen > _MB_REG_MAX + 1 THEN
						MSC_MB_DataCheck	:=	tSlave[i].tLine[j].tDef.iFC;
						RETURN;
					END_IF					
				5,6:
					IF tSlave[i].tLine[j].tDef.iLen <> 1 THEN
						MSC_MB_DataCheck	:=	20246;
						RETURN;
					END_IF
				ELSE
					IF tSlave[i].tLine[j].tDef.iFC > 0 THEN
						MSC_MB_DataCheck	:=	tSlave[i].tLine[j].tDef.iFC;
						RETURN;
					END_IF
			END_CASE
		END_FOR	
	END_FOR
	RETURN;
END_FUNCTION

FUNCTION UINT_TWO_UDINT
	UINT_TWO_UDINT := UINT_TO_UDINT(IN1)*65536+UINT_TO_UDINT(IN2);
	RETURN;
END_FUNCTION

FUNCTION UINT_TWO_REAL
	brsmemcpy(ADR(UINT_TWO_REAL)+2,ADR(IN1),2);
	brsmemcpy(ADR(UINT_TWO_REAL),ADR(IN2),2);
	RETURN;
END_FUNCTION

FUNCTION STEP
	STEP := DINT_TO_REAL(REAL_TO_DINT(IN/STEPSIZE))*STEPSIZE;
	RETURN;
END_FUNCTION

FUNCTION_BLOCK WAIT_CYCLIC
	IF IN = 0 THEN
		CNT := 0;
		Q := FALSE;
	ELSE
		Q := CNT > IN;
		CNT := CNT+1;
	END_IF
END_FUNCTION_BLOCK

FUNCTION GET_BIT_UINT_ARRAY
	GET_BIT_UINT_ARRAY	:=	(iArray[iBit / 16] AND SHL(1,UINT_TO_SINT(iBit MOD 16))) > 0;
	RETURN;
END_FUNCTION

FUNCTION SET_BIT_UINT_ARRAY
	IF iBit / 16 > _MB_DATA_ARRAY_MAX THEN
		SET_BIT_UINT_ARRAY := TRUE;
		RETURN;
	END_IF
	IF bSet THEN
		iArray[iBit / 16]	:=	iArray[iBit / 16] OR SHL(1,UINT_TO_SINT(iBit MOD 16));
	ELSE	
		iArray[iBit / 16]	:=	iArray[iBit / 16] AND NOT SHL(1,UINT_TO_SINT(iBit MOD 16));	
	END_IF
	RETURN;
END_FUNCTION