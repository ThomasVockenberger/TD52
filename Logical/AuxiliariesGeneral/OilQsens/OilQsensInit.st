(*******************************************************************************
AGGR: Oil condition monitoring (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019 

- scale the analog input signals
- supervise the analog signals
- counter handling

Customized modifications: -
------------------------
 
History:
-------
V0.01	04-05-2010	Waldhart, generated
V4.11.0	05.11.2021	Schmid		new oil quality sensor with CAN readout added
V4.11.1	12.10.2022	Bacci		oil quality sensor modification in accordance with TANDELTA firmware 4.03
					 
Instructions for use:
--------------------
- 
							
Outstandings:
------------
-
*******************************************************************************)

PROGRAM _INIT

	bReceive_OC			:= TRUE;
	bSend_OC			:= TRUE;
	bAck_OC				:= FALSE;
	iOQS_OC_ComState	:= _READ_CONFIG; // to get the oil configuration when the PLC starts
	iOQS_OC_ComStateOld	:= _READ_CONFIG; // to get the oil configuration when the PLC starts
	
	iSendMsgID_OC		:= 16#600 + iSensorID_OC;
	iRecMsgID_OC		:= 16#580 + iSensorID_OC;
	iSendMsgCnt			:= 0;
	
	tDataSend_OC[0]	:= 16#40;
	tDataSend_OC[1]	:= 16#30;
	tDataSend_OC[2]	:= 16#61;
	tDataSend_OC[3]	:= 16#01;
	tDataSend_OC[4]	:= 16#00;
	tDataSend_OC[5]	:= 16#00;
	tDataSend_OC[6]	:= 16#00;
	tDataSend_OC[7]	:= 16#00;
	iDataLength_OC	:= 8;

	rOilQual_OQS_OC_Old		:= -999.9;
	rOilQual_OQS_OC_1mAvg	:= -999.9;
	rOilQual_OQS_OC_1hAvg	:= -999.9;
	rOQS_OC_alpha			:= 0.0198;
	iOQS_OC_Status			:= _iOilQual_New;
	iOQS_OC_StatusOld		:= _iOilQual_New;
	xR_TRIG_OQS_OC_Status_Dec(CLK:= (iOQS_OC_Status <> _iOilQual_New));	// call once in init to avoid status change detection at PLC start up
	xR_TRIG_OQS_OC_Status_Inc(CLK:= (iOQS_OC_Status = _iOilQual_New));	// call once in init to avoid status change detection at PLC start up
	
	(* default oil type configuration strings *)
	FOR idxTyp := 1 TO iNum_StdOilCfg DO	// default oil type
		xHexStr2ByteArr.pHexStr			:=	ADR(sStdOilCfg[idxTyp]);
		xHexStr2ByteArr.pByteArray		:=	ADR(tStdOilCfg[idxTyp,1]);
		xHexStr2ByteArr.iLenByteWr		:=	iOQS_OC_OilCfg_ByteSize;
		xHexStr2ByteArr.iLenStrRd		:=	iOQS_OC_OilCfg_CharSize;
		xHexStr2ByteArr.iOffsetStrRd	:=	0;
		xHexStr2ByteArr();
	END_FOR;
	
	
	(*================ BEGIN PERMANENT DATA MODULE FOR OIL TYPE CONFIG STRING ================*)
	(* set some init parameters *)
	xTON_WritePMEM(IN := FALSE, PT:= T#10s);					(* reset used timer function blocks 		*)
	
	pm_Error 	:= ERR_NOERROR;								(* reset permanent memory error	status			*)
	write_once 	:= FALSE;				 					(* reset flag for write permanent memory once	*)
	pm_len 		:= SIZEOF(pmOQS);							(* define data length of permenent memory		*)
	strcpy(ADR(ModulName),ADR('AuxiliariesGeneral::OQS_perm'));		(* define name of permanent memory data module	*)
	
	
	(* check for existing permanent memory data module	*)
	DatObjInfo_01.enable:= TRUE;							(* enable FUB									*)
	DatObjInfo_01.pName := ADR(ModulName);					(* set permanent memory data module name 		*)
	DatObjInfo_01();										(* run data object info FUB						*)
	
	(* check error status of data object info FUB	*)
	IF DatObjInfo_01.status = ERR_NOERROR THEN				(* if no error	--> permanent memory data module exists	*)
		pm_id 	:= DatObjInfo_01.ident;						(* copy permanent memory data module ident			*)
		pm_p 	:= DatObjInfo_01.pDatObjMem;				(* copy permanent memory data module memory adres	*)
	ELSE
		bCreateDataObj := TRUE;								(* set flag for create new data object	*)
		pm_Error := 3001;									(* set permanent memory error status	*)
	END_IF;
	
	
	(* check length of parameter struct with length of data object *)
	
	CASE DatObjInfo_01.len OF
	792:	perm_oqs_vers  := 411;							(* 792 = length of perm_par V4.11 *)
			OUT_AG.tAG2PB.iPermStatus := OUT_AG.tAG2PB.iPermStatus + perm_oqs_vers	;	(* new V4.06: transmit perm status info *)
		//  OUT_AG.tAG2PB.bPermSetupOk := TRUE	;				(* new V4.06: transmit perm status info *)

			(* insert new perm_par Version here
			(* 		   bCreateDataObj := TRUE;						(* set flag for create new data object	*)
			(* xxxx:   perm_oqs_vers  := yyy;						(* xxxx = length of perm_par Vy.yy *)
	
	ELSE
			bCreateDataObj := TRUE;								(* set flag for create new data object	*)
			OUT_AG.tAG2PB.bPermSetupOk := FALSE	;				(* new V4.06: transmit perm status info *)
			OUT_AG.tAG2PB.iPermStatus := OUT_AG.tAG2PB.iPermStatus  - 1000 ;			(*Perm Error*)
	END_CASE;
	
	
	(* if permanent memory data module exist read data and copy to structure pm	*)
	IF pm_Error = ERR_NOERROR THEN							(* permanent memory data module exist 				*)
		DatObjRead_01.enable 		:= TRUE;				(* enable read permanent memory module data 		*)
		DatObjRead_01.ident 		:= pm_id;				(* set identifier of permanent memory data module	*)
		DatObjRead_01.Offset 		:= 0;					(* start at memory offest zero 						*)
		DatObjRead_01.pDestination 	:= ADR(pmOQS);			(* set permanent data destination adress			*)
		DatObjRead_01.len 			:= DatObjInfo_01.len;	(* set length of permanent data module				*)
	
		REPEAT	(* repeat until data of permanent memory data module have been read *)
			DatObjRead_01();								(* FUB read data from permanent data module 		*)
			UNTIL	DatObjRead_01.status <> ERR_FUB_BUSY	(* wait if FUB is busy 	*)
		END_REPEAT;
	
		IF DatObjRead_01.status <> ERR_NOERROR THEN			(* if status of read permanent data moduel is not OK 	*)
			pm_Error :=	3002;								(* set permanent memory error status					*)
		END_IF;
	END_IF;
	
	
	(* if permanent memory data module exist --> copy data from structure pm to program parameter *)
	IF pm_Error = ERR_NOERROR THEN
	
		(* ------------- V4.11 ---------------- *)
		tOilConfig.sData_OilCfgActive	:= pmOQS.sData_OilCfgActive;
		tOilConfig.sData_OilCfgUpd		:= pmOQS.sData_OilCfgUpd;

		IF OUT_AG.tAG2PB.iPermStatus >= 0 THEN 													(* new V4.06: transmit perm status info *)
			OUT_AG.tAG2PB.iPermStatus	:= LIMIT(2, OUT_AG.tAG2PB.iPermStatus + pm_len, 999999);	(* new V4.06: transmit perm status info *)
			OUT_AG.tAG2PB.bPermSetupOk	:= TRUE;												(* new V4.06: transmit perm status info *)
		END_IF;																					(* new V4.06: transmit perm status info *)
	END_IF;
	
	
	(* create new permanent memory data module	*)
	IF bCreateDataObj THEN
	
		(* try to delete old data module *)
		DatObjDelete_PermMem.enable := TRUE;
		DatObjDelete_PermMem.ident 	:= pm_id;
	
		REPEAT	(* repeat until delete of permanent memory data module is ready *)
			DatObjDelete_PermMem();						(* FUB for delete permanent memory data module *)
			UNTIL	DatObjDelete_PermMem.status <> ERR_FUB_BUSY		(* wait if FUB is busy 	*)
		END_REPEAT;
	
		(* create new one *)
		DatObjCreate_01.enable	 := TRUE;				(* enable create permanent memory data module FUB 	*)
		DatObjCreate_01.grp 	 := 0;					(* must to be set to zero							*)
		DatObjCreate_01.pName 	 := ADR(ModulName);		(* set permanent memory data module name 			*)
		DatObjCreate_01.len 	 := pm_len;				(* set length ofpermanent memory data module		*)
		DatObjCreate_01.MemType  := doUSRROM;			(* create permanent memory data module at USERROM	*)
		DatObjCreate_01.Option 	 := 0;					(* cyclic checksum monitoring is on					*)
		DatObjCreate_01.pCpyData := 0;					(* no data will be copied do the perm. mem. data module *)
	
		pm_Error:= 3003;								(* set permanent memory error status	*)
	
		REPEAT	(* repeat until generation of permanent memory data module is ready *)
			DatObjCreate_01();							(* FUB for create permanent memory data module 		*)
			UNTIL	DatObjCreate_01.status <> ERR_FUB_BUSY		(* wait if FUB is busy 	*)
		END_REPEAT;
	
		IF DatObjCreate_01.status = ERR_NOERROR THEN	(* is creation of permanent memory data module OK 	*)
			pm_p 	:= DatObjCreate_01.pDatObjMem;		(* set memory adress of permanent memory data module*)
			pm_id 	:= DatObjCreate_01.ident;			(* set identifier of permanent memory data module 	*)
		ELSE
			pm_Error:= 3004;							(* set permanent memory error status	*)
		END_IF;
	END_IF;
	
	
	(* prepare parameter for permanent memory data write in cyclic task *)
	IF pm_Error < 3004 THEN								(* permanent memory data module exist or has been created	*)
		DatObjWrite_01.enable 	:= TRUE;				(* enable permanent memory data module read FUB 	*)
		DatObjWrite_01.ident 	:= pm_id;				(* set identifier of permanent memory data module 	*)
		DatObjWrite_01.Offset 	:= 0;					(* start at memory offest zero 						*)
		DatObjWrite_01.pSource 	:= ADR(pmOQS);			(* set permanent memory data module name 			*)
		DatObjWrite_01.len 		:= pm_len;				(* set length ofpermanent memory data module		*)
	END_IF;
	
	
	(* calcualte actual checksum of parameter structure	*)
	ulChecksumOld := 0;									(* reset checksum value *)
	
	FOR ulPMPointer := ADR(pmOQS) TO (ADR(pmOQS) + pm_len - SIZEOF(ulChkValue)) DO
		memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));
		ulChecksumOld := ulChecksumOld XOR ulChkValue;
	END_FOR

	(**Forward Perm Error - new V4.06 *)
	IF (pm_Error > 0) AND (OUT_AG.tAG2PB.iPermStatus >= 0) THEN 	OUT_AG.tAG2PB.iPermStatus := LIMIT(-999999,-UINT_TO_DINT(pm_Error) ,-1)	;	END_IF		(* new V4.06: transmit error as negative perm status info *)
	IF (OUT_AG.tAG2PB.iPermStatus < 0) THEN 	OUT_AG.tAG2PB.bPermSetupOk := FALSE	;	END_IF			(* new V4.06: transmit perm status info *)

	(*================ END PERMANENT DATA MODULE FOR OIL TYPE CONFIG STRING ================*)

	
END_PROGRAM

