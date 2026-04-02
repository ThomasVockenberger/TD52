(*******************************************************************************
AGGR: read and write start statistic to windows file system	(cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2025


Customized modifications: -
------------------------
 
History:
-------
V4.06.00 	13-03-2018 	502423184	generated out of Stat_File
V4.06.01	20-07-2018	502423184	Erweitert um: LastRunInfo, TiAuxRel, Update(skip data info)
V4.12.00	29-03-2023	Kafka,		CBM HMI Handshake for Statistic Files
V4.13.0		30-10-2023	Kafka,		solve special sign issue
V4.14.0		27-02-2025	Perktold	added Ti_Purge_Dur to start statistic (new strVersion 4.14.0)

Instructions for use:
--------------------
Update Version number in the INIT program part and in history above!
Always increase the Version Number +0.00.01, if changes are made.

100ms+ Task class (TC6)

Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT
(** A: Version Number *)
	strVersion			:=	'4.14.00';				(* Always increase the Version Number +0.00.01, if changes are made. *)

(** B: Initialize variables *)
	bOK 			:=	FALSE;
	aData			:=	ADR(szData);
	aTemp			:=	ADR(strTemp);
	lines			:=	1;
	strcpy(ADR(ModulName),ADR('CBM::Statistic'));
	
	pm_len			:=	SIZEOF(DerString_Stat);		(* define data length of permenent memory				*)
	
	DatObjInfo_01.enable		:=	TRUE;
	DatObjInfo_01.pName			:=	ADR(ModulName);
	
	DatObjCreate_01.enable		:=	TRUE;			(* enable create permanent memory data module FUB 		*)
	DatObjCreate_01.grp			:=	0;				(* must to be set to zero                  				*)
	DatObjCreate_01.pName		:=	ADR(ModulName);	(* set permanent memory data module name             	*)
	DatObjCreate_01.len			:=	pm_len;			(* set length of permanent memory data module         	*)
	DatObjCreate_01.MemType		:=	doUSRROM;		(* create permanent memory data module at USERROM   	*)
	DatObjCreate_01.Option		:=	0;				(* cyclic checksum monitoring is on            			*)
	DatObjCreate_01.pCpyData	:=	0;				(* no data will be copied do the perm. mem. data module	*)
	
	DatObjWrite_01.enable		:=	TRUE;			(* enable permanent memory data module read FUB 		*)
	DatObjWrite_01.Offset		:=	0;				(* start at memory offest zero                  		*)
	DatObjWrite_01.pSource		:=	ADR(DerString_Stat);	(* set permanent memory data module name		*)
	DatObjWrite_01.len			:=	pm_len;			(* set length ofpermanent memory data module        	*)

(** C: Functionality test and validation *)
	TON_Test.PT		:=	T#1m;
	bTest_Ena		:=	FALSE;

END_PROGRAM


PROGRAM _CYCLIC

(** 0: Functionality test and validation *)
	IF bTest_Ena THEN
		TON_Test.IN := NOT TON_Test.Q;
		TON_Test();
	
		IF TON_Test.Q THEN
			bStat_Write := TRUE;
			test_cnt	:=	(1 + test_cnt) MOD 3;
			iStat_Mode	:=	1 + test_cnt;
			CASE iStat_Mode OF
				1,2: 	lines			:=	StatSize;
				3:		lines			:=	Err.Size;
			END_CASE
		END_IF
	END_IF

(** 1: Triggers *)

(** 1.1: Statistic Triggers: manual trigger / automatic trigger every 100 starts *)
	IF iStep = _IDLE THEN
		IF VIS2MM.Stat.bTrig THEN
			bStat_Write		:=	TRUE;
			iStat_Mode		:=	MAN;
			lines			:=	StatSize;
		END_IF
		IF bStat_Trigger THEN
			bStat_Write		:=	TRUE;
			iStat_Mode		:=	AUTO;
			lines			:=	StatSize;
		END_IF
		VIS2MM.Stat.bTrig	:=	FALSE;
		bStat_Trigger		:=	FALSE;
	END_IF

(** 1.2: daily trigger for error counter myPlant *)
	IF NOT IN_CB.tPB2MM.bParaSetupOk THEN
		day_old			:=	tRealTime.day;
	END_IF
	IF tRealTime.day <> day_old THEN
		day_old			:=	tRealTime.day;
		bDaily_Trigger	:=	Para.iDailyTrigger_Ena > 0;
	END_IF

(** 1.3: Error Counter Trigger *)
	IF Para.bSA_PBC_Active AND iStep = _IDLE THEN
		IF VIS2MM.ErrCnt.bTrig OR bDaily_Trigger THEN
			bStat_Write		:=	TRUE;
			iStat_Mode		:=	ERRCNT;
			lines			:=	Err.Size;
		END_IF
		VIS2MM.ErrCnt.bTrig	:=	FALSE;
		bDaily_Trigger		:=	FALSE;
	END_IF

(** 2: initialiate file write *)
IF EDGEPOS(bStat_Write) THEN
	iStep 		:=	_BEGIN;
	bWrite		:=	TRUE;
	iZeile		:=	0;
	iOffset		:=	0;
	strFile			:=	'';																			(* create filename *)
	WRITE_Date(ADR(strFile),tRealTime);																(* Date *)
	IF iStat_Mode = ERRCNT THEN		strcat(ADR(strFile), ADR('_ErrCnt'));							(* _Name *)
	ELSE							strcat(ADR(strFile), ADR('_Statistic'));	END_IF
	strcat(ADR(strFile), ADR('_'));	strcat(ADR(strFile), ADR(IN_CB.szOrderID));						(* _OrderID *)
	strcat(ADR(strFile), ADR('_'));	itoa(IN_CB.iEngID, 	 aTemp);	strcat(ADR(strFile), aTemp);	(* _EngineID *)				
	IF iStat_Mode = AUTO THEN		strcat(ADR(strFile), ADR('_Auto'));								(* _Mode *)
	ELSIF iStat_Mode = MAN THEN		strcat(ADR(strFile), ADR('_Man'));			END_IF
	strcat(ADR(strFile), ADR('.csv'));																(* .csv *)
END_IF	

(** 3: when write process is done then reset event bit *)
	IF EDGENEG(bWrite) THEN
		bStat_Write	:=	FALSE;
	END_IF

(** 4: State machine *)
	CASE iStep OF
(** 4.1: write filename and version *)
	_BEGIN:
		szData		:=	'';
		strcat(aData, ADR('<STATS_NAME>'));																						(* ------------ *)
		strcat(aData, ADR(strFile));																							(* file name *)
		strcat(aData, ADR('</STATS_NAME><STATS_FILE>'));																		(* ------------ *)
		strcat(aData, ADR(strGEProp));																							(* GE prop info *)
		strcat(aData, ADR(strLine));																							(* ------------ *)
		strcat(aData, ADR('File_Version;'));	WRITE_STRING(ADR(strVersion),aData);				strcat(aData, ADR('$n'));	(* File version *)
		strcat(aData, ADR('Creation_Date;'));	WRITE_TS(tTimeStamp, aData);						strcat(aData, ADR('$n'));	(* Date & Time *)
		strcat(aData, ADR('J_Number;'));		WRITE_STRING(ADR(IN_CB.szOrderID),aData);			strcat(aData, ADR('$n'));	(* J Number *)
		strcat(aData, ADR('Motor_Number;'));	WRITE_DINT(IN_CB.iEngID,aData);						strcat(aData, ADR('$n'));	(* Serial ID *)
		strcat(aData, ADR('Engine_Type;'));		WRITE_DINT(xEngType.Motortype,aData);				strcat(aData, ADR('$n'));	(* Engine Type *)
		strcat(aData, ADR('Engine_Version;'));	WRITE_STRING(ADR(IN_CB.szEng_Motorversion),aData);	strcat(aData, ADR('$n'));	(* Engine Version *)
		strcat(aData, ADR('Trigger_Event;'));	WRITE_DINT(iStat_Mode,aData);						strcat(aData, ADR('$n'));	(* Trigger *)
		strcat(aData, ADR(strLine));																							(* ------------ *)

		DerString_Stat := '';
		iStrSize	:=	SIZEOF(DerString_Stat);
		iPointer	:=	ADR(DerString_Stat);
		iPointer	:=	save_strcat(ADR(DerString_Stat), iStrSize, iPointer, aData);					(* write data line *)
		iStep		:=	_HEAD;																			(* next step *)

(** 4.2: write file header *) 
	_HEAD:
		szData		:=	'';
		IF iStat_Mode = AUTO OR iStat_Mode = MAN THEN													(* Statistic Header *)
			FOR i:=0 TO Stat.iSize DO	IF NOT Stat.i[i].Skip THEN	WRITE_STRING(ADR(Stat.i[i].Name), aData);	END_IF	END_FOR	(* Integer Names *)
			FOR i:=0 TO Stat.sSize DO	IF NOT Stat.s[i].Skip THEN	WRITE_STRING(ADR(Stat.s[i].Name), aData);	END_IF	END_FOR	(* String Names *)
			FOR i:=0 TO Stat.bSize DO	IF NOT Stat.b[i].Skip THEN	WRITE_STRING(ADR(Stat.b[i].Name), aData);	END_IF	END_FOR	(* Boolean Names *)
			FOR i:=0 TO Stat.rSize DO	IF NOT Stat.r[i].Skip THEN	WRITE_STRING(ADR(Stat.r[i].Name), aData);	END_IF	END_FOR	(* Real Names *)
			strcat(aData, ADR('$n'));
			FOR i:=0 TO Stat.iSize DO	IF NOT Stat.i[i].Skip THEN	WRITE_STRING(ADR(Stat.i[i].Unit), aData);	END_IF	END_FOR	(* Integer Units *)
			FOR i:=0 TO Stat.sSize DO	IF NOT Stat.s[i].Skip THEN	strcat(aData, ADR(';'));					END_IF	END_FOR	(* no Units *)
			FOR i:=0 TO Stat.bSize DO	IF NOT Stat.b[i].Skip THEN	strcat(aData, ADR(';'));					END_IF	END_FOR	(* no Units *)
			FOR i:=0 TO Stat.rSize DO	IF NOT Stat.r[i].Skip THEN	WRITE_STRING(ADR(Stat.r[i].Unit), aData);	END_IF	END_FOR	(* Real Units *)
			strcat(aData, ADR('$n'));
		ELSIF iStat_Mode = ERRCNT THEN																	(* ErrCounter Header *)
			strcat(aData, ADR('Reset date; '));			WRITE_TS(Err.tTS_Reset, aData);
			strcat(aData, ADR('$nReset OpHours; '));	itoa(Err.iCnt_OH_Reset,aTemp);	strcat(aData, aTemp);
			strcat(aData, ADR('$nWrite date; '));		WRITE_TS(tTimeStamp, aData);
			strcat(aData, ADR('$nWrite OpHours; '));	itoa(IN_CB.iCnt_OpHours,aTemp);	strcat(aData, aTemp);
			strcat(aData, ADR('$nErrorBit / Measurement; '));
			strcat(aData, ADR('Cyl / SAFI; '));
			strcat(aData, ADR('Counter; '));
			strcat(aData, ADR('First date; '));
			strcat(aData, ADR('Last date; '));
			strcat(aData, ADR('$n'));
		END_IF
		iPointer	:=	save_strcat(ADR(DerString_Stat), iStrSize, iPointer, aData);					(* write data line *)
		iStep		:=	_DATA;																			(* next step *)

(** 4.3: create data lines *)
	_DATA:
		szData		:=	'';																				(* clear previous data *)
		IF iStat_Mode = AUTO OR iStat_Mode = MAN THEN													(* Statistic Data *)
			iIdx	:=	(USINT_TO_INT(Stat.iIdx) - UDINT_TO_INT(iZeile) + USINT_TO_INT(StatSize + 1))MOD (StatSize + 1); (* calculate ring buffer index *)
			FOR i:=0 TO Stat.iSize DO	IF NOT Stat.i[i].Skip THEN	WRITE_DINT(Stat.i[i].Data[iIdx], 					aData);	END_IF	END_FOR
			FOR i:=0 TO Stat.sSize DO	IF NOT Stat.s[i].Skip THEN	WRITE_STRING(ADR(Stat.s[i].Data[iIdx].str), 		aData);	END_IF	END_FOR
			FOR i:=0 TO Stat.bSize DO	IF NOT Stat.b[i].Skip THEN	WRITE_BIT(Stat.b[i].Data[iIdx],						aData);	END_IF	END_FOR
			FOR i:=0 TO Stat.rSize DO	IF NOT Stat.r[i].Skip THEN	WRITE_REAL(Stat.r[i].Data[iIdx], Stat.r[i].Deci,	aData);	END_IF	END_FOR
		ELSIF iStat_Mode = ERRCNT THEN																	(* ErrCounter Data *)
			WRITE_STRING(ADR(ErrName[Err.xErr[iZeile].Name].str), 	aData);
			WRITE_DINT(Err.xErr[iZeile].iNum_Cyl, 					aData);
			WRITE_DINT(UDINT_TO_DINT(Err.xErr[iZeile].iCnt), 		aData);
			WRITE_TS(Err.xErr[iZeile].tTS_First,					aData);
			WRITE_TS(Err.xErr[iZeile].tTS_Last,						aData);
		END_IF
		strcat(aData, ADR('$n'));																		(* Line End *)
		iPointer	:=	save_strcat(ADR(DerString_Stat), iStrSize, iPointer, aData);					(* write data line *)
		IF iZeile < lines THEN			iZeile		:=	MIN(iZeile + 1, lines);							(* next line *)
		ELSE							iStep		:=	_FOOT;											(* next step *)
		END_IF

(** 4.4: create file footer *)
	_FOOT:
		iPointer	:=	save_strcat(ADR(DerString_Stat), iStrSize, iPointer, ADR('END OF FILE $n'));	(* last line *)
		iPointer	:=	save_strcat(ADR(DerString_Stat), iStrSize, iPointer, ADR('</STATS_FILE>'));		(* file end *)
		bWrite		:=	FALSE;																			(* write end *)
		iStep		:=	_EXIST;																			(* next step *)

(** 4.5: check for existing permanent memory data module *)		
	_EXIST:
		DatObjInfo_01();
		CASE  DatObjInfo_01.status OF
		_BUSY: 	iStep;																					(* waiting *)
		_OKAY:	iStep 			:= _WRITE;																(* next step --> write the content to the flash disk	*)
				DatObjWrite_01.ident   	:= DatObjInfo_01.ident;											(* set identifier of permanent memory data module		*)
				DatObjWrite_01.len		:= pm_len;	
		_DONF:	iStep		:=	_CREATE;																(* next step --> create permanent memory data module	*)
		ELSE	iErrorStep	:=	iStep;
				iStep		:=	_ERROR;
				iError		:=	DatObjInfo_01.status;
		END_CASE

(** 4.6: create permanent memory data module *)	
	_CREATE:					
		DatObjCreate_01();            
		CASE  DatObjCreate_01.status OF
		_BUSY:	iStep;																					(* repeat until generation of permanent memory data module is ready *)
		_OKAY:	DatObjWrite_01.ident   	:= DatObjCreate_01.ident;										(* set identifier of permanent memory data module     	*)
				DatObjWrite_01.len		:= pm_len;	
				iStep		:=	_WRITE;																	(* next step --> write the content to the flash disk	*)
		ELSE	iErrorStep	:=	iStep;
				iStep		:=	_ERROR;
				iError		:=	DatObjCreate_01.status;
		END_CASE

(** 4.7: write the content to the flash disk *)	
	_WRITE:		
		DatObjWrite_01(); 
	 	CASE DatObjWrite_01.status OF
		_BUSY:	iStep;																					(* repeat until write process of permanent memory data module is done *)
	   	_OKAY:	iStep				:=	_HMI;															(* next step --> wait for HMI to fetch file	*)
				xTON_HMI_Delay.IN	:=	TRUE;
		ELSE	iErrorStep			:=	iStep;
				iStep				:=	_ERROR;
				iError				:=	DatObjWrite_01.status;
		END_CASE

(** 4.8: wait FOR HMI TO fetch file	*)
	_HMI:
		MM2VIS.bStat_isCreated	:= TRUE;	
		IF xTON_HMI_Delay.Q OR VIS2MM.bStat_isRead THEN
			iStep				:=	_DONE;																(* next step *)
			xTON_HMI_Delay.IN	:=	FALSE;
			MM2VIS.bStat_isCreated	:=	FALSE;
			VIS2MM.bStat_isRead		:=	FALSE;	
		END_IF

(** 4.9: done, go to idle mode	*)
	_DONE:	iStep		:=	_IDLE;

(** 4.10: idle, reset lines	*)
	_IDLE:	iZeile		:=	0;
			iErrorStep	:=	0;

(** 4.11: error step, wait for cold start *)
	_ERROR: iStep;

(** 4.12: catch unexpected states *)
	ELSE	iErrorStep	:=	iStep;
			iStep		:=	_ERROR;		
	END_CASE

(** 5: HMI Delay and out interfaces *)
	xTON_HMI_Delay.PT	:=	tiHMI_Delay;
	xTON_HMI_Delay();

	IF xTON_HMI_Delay.PT <> T#0s THEN
		rHMI_Delay	:=	LIMIT(0.0, TIME_TO_REAL(xTON_HMI_Delay.ET) / TIME_TO_REAL(xTON_HMI_Delay.PT), 1.0);
	ELSE
		rHMI_Delay	:=	0;
	END_IF

	IF iStep = _DONE THEN
		MM2VIS.Stat.rSave	:=	1.0;
	ELSIF iStep <> _HMI AND lines <> 0 THEN
		MM2VIS.Stat.rSave	:=	0.5 * UDINT_TO_REAL(iZeile)/UINT_TO_REAL(lines);
	ELSIF iStep = _HMI AND lines <> 0 THEN
		MM2VIS.Stat.rSave	:=	0.5 + 0.5 * rHMI_Delay;
	ELSIF iStep = _HMI AND lines = 0 THEN
		MM2VIS.Stat.rSave	:=	rHMI_Delay;
	END_IF

	MM2VIS.ErrCnt.rSave			:=	MM2VIS.Stat.rSave;

	MM2VIS.Stat.bSave			:=	iStep <> _IDLE AND lines = StatSize;
	MM2VIS.ErrCnt.bSave			:=	iStep <> _IDLE AND lines = Err.Size;

	IF iStep = _IDLE THEN
		MM2VIS.Stat.iStep			:=	USINT_TO_INT(_RDY);
		MM2VIS.ErrCnt.iStep			:=	USINT_TO_INT(_RDY);
	ELSE
		MM2VIS.Stat.iStep			:=	USINT_TO_INT(iStep) * BOOL_TO_INT(lines = StatSize) + _LOCK * BOOL_TO_INT(lines <> StatSize);
		MM2VIS.ErrCnt.iStep			:=	USINT_TO_INT(iStep) * BOOL_TO_INT(lines = Err.Size) + _LOCK * BOOL_TO_INT(lines <> Err.Size);
	END_IF

	MM2VIS.Stat.bLock			:=	iStep <> _IDLE;
	MM2VIS.ErrCnt.bLock			:=	iStep <> _IDLE;

END_PROGRAM