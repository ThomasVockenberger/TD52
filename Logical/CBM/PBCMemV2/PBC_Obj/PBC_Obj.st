(*******************************************************************************
AGGR: read and write DIA.NE XT parameter to flash memory	(cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019


Customized modifications: -
------------------------
 
History:
-------
V3.50.3		05-11-2014	Caks,		generated
			18-11-2014	Caks,		added File-Read Check
			03-12-2014	Caks,		added: Rod and Main bearing temperature
			05-12-2014	Caks,		added: Time to Structure and File
V3.50.4		12-12-2014	Perktold,	set bWrite to FALSE in case of byStep = 7
			17-12-2014	Perktod, 	Bugfix Timestamp
V3.50.5		08-01-2015	Perktold,	Aenderung Dateinamen
			09-02-2015	Perktold,	Z636 - "+13"
V4.02.0		09-03-2015	Caks,		ported to XT4
V4.04.0		28-06-2016	502423184	added EXIT routine
V4.05.0		28-09-2016	502423184	new Version, created from old file
V4.06.0		30-10-2017	502423184	added all changes from spec, also added improved(faster and secure) strcat function
			29-01-2018	502423184	bugfix of time and slow cycle data regarding not filled buffer
			24-04-2018	502423184	new easy way setting up triggers in one line
V4.06.1		16-11-2018	502423184	release version, removed clock_ms()
V4.07.0		21-03-2019	Waldhart	footer increased
			29-03-2023	Kafka,		CBM HMI Handshake for ECBMem Files

Instructions for use:
--------------------

100ms Task class

Outstandings:
------------
*******************************************************************************)


PROGRAM _INIT

(** A: Version *)
	strVersion			:=	'4.14.00';

(** B: Initialize variables *)
	bECB_Lock		:=	FALSE;
	aT				:=	ADR(szTemp);
	aData			:=	ADR(szData);
	iStep 			:=	_IDLE;

	strcpy(ADR(ModulName),ADR('CBM::PBCMem'));

	pm_len			:=	SIZEOF(DerString);	(* define data length of permenent memory  		*)

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
	DatObjWrite_01.pSource		:=	ADR(DerString);	(* set permanent memory data module name            	*)
	DatObjWrite_01.len			:=	pm_len;			(* set length ofpermanent memory data module        	*)

(** C: Functionality test and validation *)
	TON_15min.PT 	:= T#15m;
	bTest_Ena		:=	FALSE;

(** D: ATD extension *)
	iLogicSize_1	:=	MAX(0,UDINT_TO_INT(SIZEOF(logicMatrix_1) / MAX(1, SIZEOF(logicMatrix_1[0]))) - 1);
	iLogicSize_2	:=	MAX(0,UDINT_TO_INT(SIZEOF(logicMatrix_2) / MAX(1, SIZEOF(logicMatrix_2[0]))) - 1);

END_PROGRAM


PROGRAM _CYCLIC

(** 1: Test and Validation *)
	IF bTest_Ena THEN
		TON_15min.IN := NOT TON_15min.Q;
		TON_15min();
	
		IF TON_15min.Q THEN
			iStep := _BEGIN;
		END_IF
	END_IF

(** 2: if recording of the buffer is done then initialiate file write *)
	IF EDGENEG(bPBC_Record) AND bPBC_Write AND bPBC_Mem_Ena THEN
		iStep 		:=	_BEGIN;
		bWrite		:=	TRUE;
	END_IF	
	
(** 3: when write process is done then reset event bit *)
	IF EDGENEG(bWrite) THEN
		bPBC_Write		:=	FALSE;
	END_IF

(** 4: State Machine *)
	CASE iStep OF
(** 4.1: create filename *)
	_BEGIN:
		strFile			:=	'';																				(* Set Filename *)
		WRITE_Date(ADR(strFile),tRealTime);																		(* Date *)
		strcat(ADR(strFile), ADR('_ECB'));																		(* _Name *)
		strcat(ADR(strFile), ADR('_'));	strcat(ADR(strFile), ADR(IN_CB.szOrderID));								(* _OrderID *)
		strcat(ADR(strFile), ADR('_'));	itoa(IN_CB.iEngID, 	 ADR(strTemp));	strcat(ADR(strFile), ADR(strTemp));	(* _EngineID *)				
		strcat(ADR(strFile), ADR('_'));	strcat(ADR(strFile), ADR(Buffer.TrigMode[iPBC_Trigger].Name));			(* _Mode *)
		strcat(ADR(strFile), ADR('.csv'));																		(* .csv *)
		iStep		:=	_HEAD;
(** 4.1: create specific header *)
	_HEAD:
		szHeader		:=	'';
		aH				:=	ADR(szHeader);
		FOR iCnt:=0 TO Buffer.iCnt_HS DO																	(* StringData 		*)
			strcat(aH,ADR(Buffer.HeaderS[iCnt].Name));		strcat(aH,ADR(';'));								(* Name;		*)
			strcat(aH,ADR(Buffer.HeaderS[iCnt].Value));		strcat(aH,ADR(';$n'));								(* Value; Return*)	
		END_FOR
		FOR iCnt:=0 TO Buffer.iCnt_H12 DO																	(* Array Data 12 	*)
			strcat(aH,ADR(Buffer.Header12[iCnt].Name));		strcat(aH,ADR(';'));								(* Name;		*)	
			strcat(aH,ADR(Buffer.Header12[iCnt].Unit));		strcat(aH,ADR(';'));								(* Unit;		*)	
			FOR i:= 1 TO xEngType.NumberOfCylinder/2 DO
				WRITE_REAL(Buffer.Header12[iCnt].Value[i], Buffer.Header12[iCnt].Co, aH);						(* Value;		*)	
			END_FOR
			strcat(aH,ADR('$n'));																				(* Return		*)	
		END_FOR	
		FOR iCnt:=0 TO Buffer.iCnt_H DO																		(* standart data 	*)
			strcat(aH,ADR(Buffer.Header[iCnt].Name));		strcat(aH,ADR(';'));								(* Name;		*)	
			WRITE_REAL(Buffer.Header[iCnt].Value, Buffer.Header[iCnt].Co, aH);									(* Value;		*)	
			strcat(aH,ADR(Buffer.Header[iCnt].Unit));		strcat(aH,ADR(';$n'));								(* Unit; Return	*)	
		END_FOR
		strcat(aH, ADR(strLine));																			(* ------------ *)
		iStep		:=	_HEAD1;
(** 4.2: create header for continous data *)
	_HEAD1,_HEAD2:
		bName	:=	iStep = _HEAD1;																			(* Name / Unit		*)	
		IF bName THEN		strcat(aH,ADR('Time;'));															(* Time;		*)	
		ELSE				strcat(aH,ADR('s;'));																(* s;			*)	
		END_IF
		FOR iCnt_B:=0 TO iBits_Max DO																		(* single bits 		*)
			FOR iCnt:=0 TO USINT_TO_INT(Buffer.Bits[iCnt_B].used)-1 DO
				IF bName THEN	strcat(aH,ADR(Buffer.Bits[iCnt_B].Info[iCnt].Name));	END_IF					(* Name			*)	
				strcat(aH,ADR(';'));																			(* ;			*)	
			END_FOR
		END_FOR
		IF Buffer.iCnt_pattern > 0 THEN
			FOR iCnt:=0 TO Buffer.iCnt_pattern DO																(* bit patterns 	*)
				FOR iCyl:=1 TO xEngType.NumberOfCylinder DO
					IF bName THEN strcat(aH,ADR(Buffer.pattern[iCnt].Name)); itoa(iCyl,aT); strcat(aH,aT); END_IF	(* Name_Cyl		*)	
					strcat(aH,ADR(';'));																			(* ;			*)	
				END_FOR
			END_FOR
		END_IF
		FOR iCnt:=0 TO Buffer.iCnt_ui16_H DO																(* task cycle data 	*)
			IF bName THEN	strcat(aH,ADR(Buffer.ui16_H[iCnt].Name));	strcat(aH,ADR('_Min;'));				(* Name_Min;	*)	
							strcat(aH,ADR(Buffer.ui16_H[iCnt].Name));	strcat(aH,ADR('_Max;'));				(* Name_Max;	*)	
			ELSE			strcat(aH,ADR(Buffer.ui16_H[iCnt].Unit));	strcat(aH,ADR(';'));					(* Unit;		*)	
							strcat(aH,ADR(Buffer.ui16_H[iCnt].Unit));	strcat(aH,ADR(';'));					(* Unit;		*)	
			END_IF
		END_FOR
		FOR iCnt:=0 TO Buffer.iCnt_ui16 DO																	(* engine cycle data *)
			IF bName THEN	strcat(aH,ADR(Buffer.ui16[iCnt].Name));		strcat(aH,ADR(';'));					(* Name;		*)
			ELSE			strcat(aH,ADR(Buffer.ui16[iCnt].Unit));		strcat(aH,ADR(';'));					(* Unit;		*)	
			END_IF
		END_FOR
		FOR iCnt:=0 TO Buffer.iCnt_ui16_low DO																(* slow changing data *)
			IF bName THEN	strcat(aH,ADR(Buffer.ui16_low[iCnt].Name));	strcat(aH,ADR(';'));					(* Name;		*)
			ELSE			strcat(aH,ADR(Buffer.ui16_low[iCnt].Unit));	strcat(aH,ADR(';'));					(* Unit;		*)	
			END_IF
		END_FOR
		strcat(aH,ADR('$n'));																				(* Return		*)	
		IF bName THEN		iStep	:=	_HEAD2;																(* next Line Units *)
		ELSE				iStep	:=	_LOCK;																(* next step *)
		END_IF
(** 4.3: waiting for TCBMem if in write process *)
	_LOCK:
		IF NOT bTCB_Lock THEN
			iStep		:=	_STR;
			bECB_Lock	:=	TRUE;
		END_IF
(** 4.4: fill data string with header *)
	_STR:
		szData		:=	'';
		strcat(aData, ADR('<PBC_NAME>'));																						(* ------------ *)
		strcat(aData, ADR(strFile));																							(* file name *)
		strcat(aData, ADR('</PBC_NAME><PBC_FILE>'));																			(* ------------ *)
		strcat(aData, ADR(strGEProp));																							(* GE prop info *)
		strcat(aData, ADR(strLine));																							(* ------------ *)
		strcat(aData, ADR('File_Version;'));	WRITE_STRING(ADR(strVersion),aData);				strcat(aData, ADR('$n'));	(* File version *)
		strcat(aData, ADR('Creation_Date;'));	WRITE_TS(tTimeStamp, aData);						strcat(aData, ADR('$n'));	(* Date & Time *)
		strcat(aData, ADR('J_Number;'));		WRITE_STRING(ADR(IN_CB.szOrderID),aData);			strcat(aData, ADR('$n'));	(* J Number *)
		strcat(aData, ADR('Motor_Number;'));	WRITE_DINT(IN_CB.iEngID,aData);						strcat(aData, ADR('$n'));	(* Serial ID *)
		strcat(aData, ADR('Engine_Type;'));		WRITE_DINT(xEngType.Motortype,aData);				strcat(aData, ADR('$n'));	(* Engine Type *)
		strcat(aData, ADR('Engine_Version;'));	WRITE_STRING(ADR(IN_CB.szEng_Motorversion),aData);	strcat(aData, ADR('$n'));	(* Engine Version *)
		strcat(aData, ADR('Trigger_Event;'));	WRITE_DINT(iPBC_Trigger,aData);						strcat(aData, ADR('$n'));	(* Trigger *)
		strcat(aData, ADR(strLine));																							(* ------------ *)

		DerString		:=	'';
		iSize_String	:=	SIZEOF(DerString);
		iPointer		:=	ADR(DerString);
		iPointer		:=	save_strcat(ADR(DerString), iSize_String, iPointer, aData);											(* write std. header *)
		iPointer		:=	save_strcat(ADR(DerString), iSize_String, iPointer, aH);											(* write spec. header *)
		iZeile			:=	0;																									(* reset lines *)
		iStep			:=	_DATA;																								(* next step *)

		tiMax	:= -T#24h;
		tiMin	:=	T#24h;
		bFilled	:=	TRUE;
		FOR iCnt:=0 TO iBufferSize-1 DO 
			IF Buffer.timer[iCnt] = T#0ms THEN
				bFilled	:=	FALSE;
			ELSE
				tiMax := MAX(tiMax, Buffer.timer[iCnt]);
				tiMin := MIN(tiMin, Buffer.timer[iCnt]);
			END_IF			
		END_FOR

		IF tiMax > T#23h59m59s AND tiMin < T#1s THEN								(* wenn Tagwechsel *)
			FOR iCnt:=0 TO iBufferSize-1 DO 
				IF Buffer.timer[iCnt] <> T#0ms AND Buffer.timer[iCnt] < T#1h THEN	(* erhoehe alle niederen um 24Stunden *)
					Buffer.timer[iCnt]	:=	Buffer.timer[iCnt] + T#24h;	
				END_IF	
			END_FOR			
		END_IF

		IF NOT bFilled THEN															(* find Index 1, if buffer is not filled *)
			FOR iCnt:=0 TO iBufferSize DO
				IF Buffer.timer[(iCnt_Cycle + iCnt) MOD (iBufferSize)] > T#0s THEN EXIT; END_IF
			END_FOR
			iIdx1	:=	(iCnt_Cycle  + iCnt) MOD (iBufferSize);
		ELSE
			iIdx1	:=	(iCnt_Cycle ) MOD (iBufferSize);
		END_IF

(** 4.5: fill data string with data *)
	_DATA:
		FOR iAccel := 0 TO 2 DO																							(* write accelerator *)
		szData	:=	'';																										(* delete previous data line *)
		iIdx	:=	(iCnt_Cycle + iZeile) MOD (iBufferSize);																(* calculate ring buffer index *)
		iIdx10	:=	((iCnt_Cycle - (iCnt_Cycle MOD 10) +10 )/10 + UDINT_TO_INT((iZeile)/10)) MOD (iBufferSize/10);			(* calculate small ring buffer index *)
		bSCD_Ena:=	Buffer.timer[iIdx] > T#0s;
		IF bSCD_Ena THEN	WRITE_REAL(DINT_TO_REAL(TIME_TO_DINT(Buffer.timer[iIdx] - Buffer.timer[iIdx1]))/1000, 3, aData);				(* Time; *)
		ELSE				WRITE_REAL(0.0, 3, aData);																						(* 0.000; if empty *)																						
		END_IF
		FOR iCnt_B:=0 TO iBits_Max DO																										(* data bits *)
			IF Buffer.Bits[iCnt_B].used > 0 THEN WRITE_BIT(Buffer.Bits[iCnt_B].ucData[iIdx].0,aData);	END_IF									(* 0/1; *)
			IF Buffer.Bits[iCnt_B].used > 1 THEN WRITE_BIT(Buffer.Bits[iCnt_B].ucData[iIdx].1,aData);	END_IF									(* 0/1; *)
			IF Buffer.Bits[iCnt_B].used > 2 THEN WRITE_BIT(Buffer.Bits[iCnt_B].ucData[iIdx].2,aData);	END_IF									(* 0/1; *)
			IF Buffer.Bits[iCnt_B].used > 3 THEN WRITE_BIT(Buffer.Bits[iCnt_B].ucData[iIdx].3,aData);	END_IF									(* 0/1; *)
			IF Buffer.Bits[iCnt_B].used > 4 THEN WRITE_BIT(Buffer.Bits[iCnt_B].ucData[iIdx].4,aData);	END_IF									(* 0/1; *)
			IF Buffer.Bits[iCnt_B].used > 5 THEN WRITE_BIT(Buffer.Bits[iCnt_B].ucData[iIdx].5,aData);	END_IF									(* 0/1; *)
			IF Buffer.Bits[iCnt_B].used > 6 THEN WRITE_BIT(Buffer.Bits[iCnt_B].ucData[iIdx].6,aData);	END_IF									(* 0/1; *)
			IF Buffer.Bits[iCnt_B].used > 7 THEN WRITE_BIT(Buffer.Bits[iCnt_B].ucData[iIdx].7,aData);	END_IF									(* 0/1; *)
		END_FOR
		IF Buffer.iCnt_pattern > 0 THEN
			FOR iCnt:=0 TO Buffer.iCnt_pattern DO																								(* bit patterns *)
				FOR iCyl:=1 TO xEngType.NumberOfCylinder DO
					WRITE_BIT(UDINT_TO_BOOL(Buffer.pattern[iCnt].BitPattern[iIdx] AND REAL_TO_UDINT(2.0 ** (USINT_TO_REAL(iCyl)-1.0))),aData);		(* 0/1; *)
				END_FOR
			END_FOR
		END_IF
		FOR iCnt:=0 TO Buffer.iCnt_ui16_H DO																								(* task cycle data *)
			IF Buffer.ui16_H[iCnt].Signed THEN
				WRITE_REAL(INT_TO_REAL(UINT_TO_INT(Buffer.ui16_H[iCnt].Lo[iIdx]))/MAX(Buffer.ui16_H[iCnt].Co, 0.001), DECI(Buffer.ui16_H[iCnt].Co), aData);	(* Signed Value; *)
				WRITE_REAL(INT_TO_REAL(UINT_TO_INT(Buffer.ui16_H[iCnt].Hi[iIdx]))/MAX(Buffer.ui16_H[iCnt].Co, 0.001), DECI(Buffer.ui16_H[iCnt].Co), aData);	(* Signed Value; *)					
			ELSE	WRITE_REAL(UINT_TO_REAL(Buffer.ui16_H[iCnt].Lo[iIdx])/MAX(Buffer.ui16_H[iCnt].Co, 0.001), DECI(Buffer.ui16_H[iCnt].Co), aData);			(* Unsigned Value; *)	
					WRITE_REAL(UINT_TO_REAL(Buffer.ui16_H[iCnt].Hi[iIdx])/MAX(Buffer.ui16_H[iCnt].Co, 0.001), DECI(Buffer.ui16_H[iCnt].Co), aData);			(* Unsigned Value; *)	
			END_IF
		END_FOR
		FOR iCnt:=0 TO Buffer.iCnt_ui16 DO																									(* engine cycle data *)
			IF Buffer.ui16[iCnt].Signed THEN
					WRITE_REAL(INT_TO_REAL(UINT_TO_INT(Buffer.ui16[iCnt].Data[iIdx]))/MAX(Buffer.ui16[iCnt].Co, 0.001), DECI(Buffer.ui16[iCnt].Co), aData);	(* Signed Value; *)			
			ELSE	WRITE_REAL(UINT_TO_REAL(Buffer.ui16[iCnt].Data[iIdx])/MAX(Buffer.ui16[iCnt].Co, 0.001), DECI(Buffer.ui16[iCnt].Co), aData);				(* Unsigned Value; *)
			END_IF
		END_FOR
		FOR iCnt:=0 TO Buffer.iCnt_ui16_low DO																								(* slow changing data *)
			IF NOT bSCD_Ena THEN		WRITE_REAL(0.0, DECI(Buffer.ui16_low[iCnt].Co), aData);													(*0.0; if empty *)
			ELSIF Buffer.ui16_low[iCnt].Signed THEN
				WRITE_REAL(INT_TO_REAL(UINT_TO_INT(Buffer.ui16_low[iCnt].Data[iIdx10]))/MAX(Buffer.ui16_low[iCnt].Co, 0.001), DECI(Buffer.ui16_low[iCnt].Co), aData);	(* Signed Value; *)						
			ELSE	WRITE_REAL(UINT_TO_REAL(Buffer.ui16_low[iCnt].Data[iIdx10])/MAX(Buffer.ui16_low[iCnt].Co, 0.001), DECI(Buffer.ui16_low[iCnt].Co), aData);			(* Unsigned Value; *)
			END_IF
		END_FOR										
		strcat(aData, ADR('$n'));																											(* Return		*)	
		iPointer	:=	save_strcat(ADR(DerString), iSize_String, iPointer, aData);															(* write data line *)
		iZeile	:=	MIN(iZeile+1,iBufferSize);																								(* increase line counter *)
		IF iZeile >= iBufferSize THEN
			iStep	:=	_FOOT;																												(* next step *)
			iAccel	:=	1000;																												(* break out of accelerator loop *)
		END_IF
		END_FOR
(** 4.6: fill data string with footer *)
	_FOOT:
		szData		:=	'';
		IF iPBC_Trigger = 1 THEN																						(* write SDT if engine trips *)
			szData		:=	'Slow down time; ';		WRITE_REAL(IN_CB.rSDT, 2, aData);	strcat(aData, ADR('s;$n'));			(* Slow down time;XXX;s; *)
		END_IF

		(**** ATD BEGIN ****)
		IF xEngType.Type9 THEN								//ATD experimental
			strcat(aData, ADR('<ATD>$n'));

			strcat(aData, ADR('logicMatrix_1; '));	
			FOR iCnt:=0 TO iLogicSize_1 DO		WRITE_REAL(logicMatrix_1[iCnt], 0, aData);	END_FOR
			strcat(aData, ADR('$n'));	

			strcat(aData, ADR('logicMatrix_2; '));	
			FOR iCnt:=0 TO iLogicSize_2 DO		WRITE_REAL(logicMatrix_2[iCnt], 0, aData);	END_FOR
			strcat(aData, ADR('$n'));	

			strcat(aData, ADR('splitVec; '));	
			FOR iCnt:=0 TO iError_Channels DO	WRITE_REAL(LREAL_TO_REAL(splitVec[iCnt]), 0, aData);	END_FOR
			strcat(aData, ADR('$n'));

			FOR iCnt:=0 TO iError_Channels DO
				strcat(aData, ADR('FAM_struct.tCHL_'));
				WRITE_REAL(INT_TO_REAL(iCnt), 0, aData);
				FOR iCnt2:=0 TO iError_Depth DO	WRITE_REAL(USINT_TO_REAL(FAM_struct.tCHL[iCnt].chl[iCnt2]), 0, aData);	END_FOR
				strcat(aData, ADR('$n'));
			END_FOR

			strcat(aData, ADR('FAM_struct.mcc; '));	
			FOR iCnt:=0 TO iError_Channels DO	WRITE_REAL(FAM_struct.mcc[iCnt], 4, aData);	END_FOR
			strcat(aData, ADR('$n'));

			strcat(aData, ADR('FAM_struct.cost_repair; '));	
			FOR iCnt:=0 TO iError_Channels DO	WRITE_REAL(LREAL_TO_REAL(FAM_struct.cost_repair[iCnt]), 0, aData);	END_FOR
			strcat(aData, ADR('$n'));

			strcat(aData, ADR('FAM_struct.cost_not_repair; '));	
			FOR iCnt:=0 TO iError_Channels DO	WRITE_REAL(LREAL_TO_REAL(FAM_struct.cost_not_repair[iCnt]), 0, aData);	END_FOR
			strcat(aData, ADR('$n'));

			strcat(aData, ADR('Pr_Knck_TH_MDN; '));				WRITE_REAL(FDT_value.Pr_Knck_TH_MDN,			2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_Knck_TH_MDN_CNT; '));			WRITE_REAL(FDT_value.Pr_Knck_TH_MDN_CNT,		0, aData);	strcat(aData, ADR('$n'));	

			strcat(aData, ADR('Pr_49bTDC_TH_MDN; '));			WRITE_REAL(FDT_value.Pr_49bTDC_TH_MDN,			2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_49bTDC_TH_MDN_CNT; '));		WRITE_REAL(FDT_value.Pr_49bTDC_TH_MDN_CNT,		0, aData);	strcat(aData, ADR('$n'));

			strcat(aData, ADR('Pr_49aTDC_TH_MDN; '));			WRITE_REAL(FDT_value.Pr_49aTDC_TH_MDN,			2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_49aTDC_TH_MDN_CNT; '));		WRITE_REAL(FDT_value.Pr_49aTDC_TH_MDN_CNT,		0, aData);	strcat(aData, ADR('$n'));

			strcat(aData, ADR('Pmax_TH_MDN; '));				WRITE_REAL(FDT_value.Pmax_TH_MDN,				2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pmax_TH_MDN_CNT; '));			WRITE_REAL(FDT_value.Pmax_TH_MDN_CNT,			0, aData);	strcat(aData, ADR('$n'));
	
			strcat(aData, ADR('IMEP_TH_MDN; '));				WRITE_REAL(FDT_value.IMEP_TH_MDN,				2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('IMEP_TH_MDN_CNT; '));			WRITE_REAL(FDT_value.IMEP_TH_MDN_CNT,			0, aData);	strcat(aData, ADR('$n'));	

			strcat(aData, ADR('T_Exh_TH_MDN; '));				WRITE_REAL(FDT_value.T_Exh_TH_MDN,				2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('T_Exh_TH_MDN_CNT; '));			WRITE_REAL(FDT_value.T_Exh_TH_MDN_CNT,			0, aData);	strcat(aData, ADR('$n'));

			strcat(aData, ADR('IT_TH_MDN; '));					WRITE_REAL(FDT_value.IT_TH_MDN,					2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('IT_TH_MDN_CNT; '));				WRITE_REAL(FDT_value.IT_TH_MDN_CNT,				0, aData);	strcat(aData, ADR('$n'));

			strcat(aData, ADR('AI50_TH_MDN; '));				WRITE_REAL(FDT_value.AI50_TH_MDN,				2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('AI50_TH_MDN_CNT; '));			WRITE_REAL(FDT_value.AI50_TH_MDN_CNT,			0, aData);	strcat(aData, ADR('$n'));

			strcat(aData, ADR('CA_PI_Duration_TH_MDN; '));		WRITE_REAL(FDT_value.CA_PI_Duration_TH_MDN,		2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('CA_PI_Duration_TH_MDN_CNT; '));	WRITE_REAL(FDT_value.CA_PI_Duration_TH_MDN_CNT,	0, aData);	strcat(aData, ADR('$n'));

			strcat(aData, ADR('T_Rod_TH_MDN; '));				WRITE_REAL(FDT_value.T_Rod_TH_MDN,				2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('T_Rod_TH_MDN_CNT; '));			WRITE_REAL(FDT_value.T_Rod_TH_MDN_CNT,			0, aData);	strcat(aData, ADR('$n'));	

			strcat(aData, ADR('PBCSlowDriftCheck_CNT; '));		WRITE_REAL(FDT_value.PBCSlowDriftCheck_CNT,		0, aData);	strcat(aData, ADR('$n'));	

			strcat(aData, ADR('integrator_increment; '));		WRITE_REAL(FDT_value.integrator_increment,		2, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('integrator_decay; '));			WRITE_REAL(FDT_value.integrator_decay,			2, aData);	strcat(aData, ADR('$n'));

			strcat(aData, ADR('filter_INT1_TH; '));				WRITE_REAL(FDT_value.filter_INT1_TH,			2, aData);	strcat(aData, ADR('$n'));

			(* P_Set *)
			strcat(aData, ADR('P_Set_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.P_Set_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('P_Set_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.P_Set_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('P_Set_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.P_Set_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('P_Set_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.P_Set_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));
			(* P_Act *)	
			strcat(aData, ADR('P_Act_Min_TH_REF; '));			WRITE_REAL(FDT_value.P_Act_Min_TH_REF,			2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('P_Act_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.P_Act_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('P_Act_Min_TH_REF_CNT; '));		WRITE_REAL(FDT_value.P_Act_Min_TH_REF_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('P_Act_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.P_Act_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('P_Act_Max_TH_REF; '));			WRITE_REAL(FDT_value.P_Act_Max_TH_REF,			2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('P_Act_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.P_Act_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('P_Act_Max_TH_REF_CNT; '));		WRITE_REAL(FDT_value.P_Act_Max_TH_REF_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('P_Act_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.P_Act_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));

			(* P2s_A *)
			strcat(aData, ADR('Pr_P2s_A_Min_TH_REF; '));		WRITE_REAL(FDT_value.Pr_P2s_A_Min_TH_REF,		1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_A_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_P2s_A_Min_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_A_Min_TH_REF_CNT; '));	WRITE_REAL(FDT_value.Pr_P2s_A_Min_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_A_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_P2s_A_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_A_Max_TH_REF; '));		WRITE_REAL(FDT_value.Pr_P2s_A_Max_TH_REF,		1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_A_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_P2s_A_Max_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_A_Max_TH_REF_CNT; '));	WRITE_REAL(FDT_value.Pr_P2s_A_Max_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_A_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_P2s_A_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	

			(* P2s_B *)
			strcat(aData, ADR('Pr_P2s_B_Min_TH_REF; '));		WRITE_REAL(FDT_value.Pr_P2s_B_Min_TH_REF,		1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_B_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_P2s_B_Min_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_P2s_B_Min_TH_REF_CNT; '));	WRITE_REAL(FDT_value.Pr_P2s_B_Min_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_B_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_P2s_B_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('Pr_P2s_B_Max_TH_REF; '));		WRITE_REAL(FDT_value.Pr_P2s_B_Max_TH_REF,		1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_B_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_P2s_B_Max_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_B_Max_TH_REF_CNT; '));	WRITE_REAL(FDT_value.Pr_P2s_B_Max_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_P2s_B_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_P2s_B_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	

			(* Pr_Leanox *)
			strcat(aData, ADR('Pr_Leanox_Set_Min_TH_s1_MAX; '));	WRITE_REAL(FDT_value.Pr_Leanox_Set_Min_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_Leanox_Set_Min_TH_s1_CNT; '));	WRITE_REAL(FDT_value.Pr_Leanox_Set_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('Pr_Leanox_Set_Max_TH_s1_MAX; '));	WRITE_REAL(FDT_value.Pr_Leanox_Set_Max_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_Leanox_Set_Max_TH_s1_CNT; '));	WRITE_REAL(FDT_value.Pr_Leanox_Set_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	

			(* GR_Set *)
			strcat(aData, ADR('Pr_GR_Set_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_GR_Set_Min_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('Pr_GR_Set_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_GR_Set_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_GR_Set_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_GR_Set_Max_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_GR_Set_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_GR_Set_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));
			(* GR_Act *)
			strcat(aData, ADR('Pr_GR_Act_Min_TH_REF; '));			WRITE_REAL(FDT_value.Pr_GR_Act_Min_TH_REF,		1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_GR_Act_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_GR_Act_Min_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_GR_Act_Min_TH_REF_CNT; '));		WRITE_REAL(FDT_value.Pr_GR_Act_Min_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_GR_Act_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_GR_Act_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_GR_Act_Max_TH_REF; '));			WRITE_REAL(FDT_value.Pr_GR_Act_Max_TH_REF,		1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_GR_Act_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_GR_Act_Max_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('Pr_GR_Act_Max_TH_REF_CNT; '));		WRITE_REAL(FDT_value.Pr_GR_Act_Max_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_GR_Act_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_GR_Act_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));

			(* PC_Set *)
			strcat(aData, ADR('Pr_PC_Set_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_PC_Set_Min_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_PC_Set_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_PC_Set_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_PC_Set_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_PC_Set_Max_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_PC_Set_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_PC_Set_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			(* PC_Act *)
			strcat(aData, ADR('Pr_PC_Act_Min_TH_REF; '));			WRITE_REAL(FDT_value.Pr_PC_Act_Min_TH_REF,		1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_PC_Act_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_PC_Act_Min_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_PC_Act_Min_TH_REF_CNT; '));		WRITE_REAL(FDT_value.Pr_PC_Act_Min_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_PC_Act_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_PC_Act_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pr_PC_Act_Max_TH_REF; '));			WRITE_REAL(FDT_value.Pr_PC_Act_Max_TH_REF,		1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_PC_Act_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Pr_PC_Act_Max_TH_s1_MAX,	0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('Pr_PC_Act_Max_TH_REF_CNT; '));		WRITE_REAL(FDT_value.Pr_PC_Act_Max_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pr_PC_Act_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Pr_PC_Act_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));

			(* Pos_CBV *)
			strcat(aData, ADR('Pos_CBV_Set_Min_TH_s1_MAX; '));	WRITE_REAL(FDT_value.Pos_CBV_Set_Min_TH_s1_MAX,	1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_Set_Max_TH_s1_MAX; '));	WRITE_REAL(FDT_value.Pos_CBV_Set_Max_TH_s1_MAX,	1, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pos_CBV_Set_Min_TH_s1_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_Set_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_Set_Max_TH_s1_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_Set_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	
	
			strcat(aData, ADR('Pos_CBV_A1_Min_TH_REF; '));		WRITE_REAL(FDT_value.Pos_CBV_A1_Min_TH_REF,		2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_A1_Min_TH_s1_MAX; '));	WRITE_REAL(FDT_value.Pos_CBV_A1_Min_TH_s1_MAX,	1, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pos_CBV_A1_Min_TH_REF_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_A1_Min_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_A1_Min_TH_s1_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_A1_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_A1_Max_TH_REF; '));		WRITE_REAL(FDT_value.Pos_CBV_A1_Max_TH_REF,		2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_A1_Max_TH_s1_MAX; '));	WRITE_REAL(FDT_value.Pos_CBV_A1_Max_TH_s1_MAX,	1, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pos_CBV_A1_Max_TH_REF_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_A1_Max_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_A1_Max_TH_s1_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_A1_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	
	
			strcat(aData, ADR('Pos_CBV_B1_Min_TH_REF; '));		WRITE_REAL(FDT_value.Pos_CBV_B1_Min_TH_REF,		2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_B1_Min_TH_s1_MAX; '));	WRITE_REAL(FDT_value.Pos_CBV_B1_Min_TH_s1_MAX,	1, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pos_CBV_B1_Min_TH_REF_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_B1_Min_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_B1_Min_TH_s1_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_B1_Min_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_B1_Max_TH_REF; '));		WRITE_REAL(FDT_value.Pos_CBV_B1_Max_TH_REF,		2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_B1_Max_TH_s1_MAX; '));	WRITE_REAL(FDT_value.Pos_CBV_B1_Max_TH_s1_MAX,	1, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Pos_CBV_B1_Max_TH_REF_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_B1_Max_TH_REF_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Pos_CBV_B1_Max_TH_s1_CNT; '));	WRITE_REAL(FDT_value.Pos_CBV_B1_Max_TH_s1_CNT,	0, aData);	strcat(aData, ADR('$n'));	

			(* Speed *)
			strcat(aData, ADR('Speed_NOM; '));					WRITE_REAL(FDT_value.Speed_NOM,					0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Speed_Min_TH_NOM; '));			WRITE_REAL(FDT_value.Speed_Min_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Speed_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Speed_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('Speed_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.Speed_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Speed_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Speed_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Speed_Max_TH_NOM; '));			WRITE_REAL(FDT_value.Speed_Max_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Speed_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Speed_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Speed_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.Speed_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Speed_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Speed_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
	
			(* T2s *)
			strcat(aData, ADR('T_T2s_NOM; '));					WRITE_REAL(FDT_value.T_T2s_NOM,					0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('T_T2s_TH_NOM; '));				WRITE_REAL(FDT_value.T_T2s_TH_NOM,				1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('T_T2s_TH_s1_MAX; '));			WRITE_REAL(FDT_value.T_T2s_TH_s1_MAX,			0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('T_T2s_TH_NOM_CNT; '));			WRITE_REAL(FDT_value.T_T2s_TH_NOM_CNT,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('T_T2s_TH_s1_CNT; '));			WRITE_REAL(FDT_value.T_T2s_TH_s1_CNT,			0, aData);	strcat(aData, ADR('$n'));

			(* Lam_Set *)	
			strcat(aData, ADR('Lam_Set_Min_NOM; '));			WRITE_REAL(FDT_value.Lam_Set_Min_NOM,			0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Lam_Set_Min_TH_NOM; '));			WRITE_REAL(FDT_value.Lam_Set_Min_TH_NOM,		2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Lam_Set_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Lam_Set_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('Lam_Set_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.Lam_Set_Min_TH_NOM_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Lam_Set_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Lam_Set_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Lam_Set_Max_NOM; '));			WRITE_REAL(FDT_value.Lam_Set_Max_NOM,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Lam_Set_Max_TH_NOM; '));			WRITE_REAL(FDT_value.Lam_Set_Max_TH_NOM,		2, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Lam_Set_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.Lam_Set_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Lam_Set_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.Lam_Set_Max_TH_NOM_CNT,	0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Lam_Set_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.Lam_Set_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));

			(* U_L1L2 *)	
			strcat(aData, ADR('U_L1L2_Min_NOM; '));				WRITE_REAL(FDT_value.U_L1L2_Min_NOM,			0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('U_L1L2_Min_TH_NOM; '));			WRITE_REAL(FDT_value.U_L1L2_Min_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L1L2_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.U_L1L2_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('U_L1L2_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.U_L1L2_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L1L2_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.U_L1L2_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L1L2_Max_NOM; '));				WRITE_REAL(FDT_value.U_L1L2_Max_NOM,			0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('U_L1L2_Max_TH_NOM; '));			WRITE_REAL(FDT_value.U_L1L2_Max_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L1L2_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.U_L1L2_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('U_L1L2_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.U_L1L2_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L1L2_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.U_L1L2_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	

			(* U_L2L3 *)
			strcat(aData, ADR('U_L2L3_Min_NOM; '));				WRITE_REAL(FDT_value.U_L2L3_Min_NOM,			0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('U_L2L3_Min_TH_NOM; '));			WRITE_REAL(FDT_value.U_L2L3_Min_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L2L3_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.U_L2L3_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L2L3_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.U_L2L3_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L2L3_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.U_L2L3_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L2L3_Max_NOM; '));				WRITE_REAL(FDT_value.U_L2L3_Max_NOM,			0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('U_L2L3_Max_TH_NOM; '));			WRITE_REAL(FDT_value.U_L2L3_Max_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('U_L2L3_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.U_L2L3_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L2L3_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.U_L2L3_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L2L3_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.U_L2L3_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));
	
			(* U_L3L1 *)
			strcat(aData, ADR('U_L3L1_Min_NOM; '));				WRITE_REAL(FDT_value.U_L3L1_Min_NOM,			0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('U_L3L1_Min_TH_NOM; '));			WRITE_REAL(FDT_value.U_L3L1_Min_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L3L1_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.U_L3L1_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('U_L3L1_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.U_L3L1_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L3L1_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.U_L3L1_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L3L1_Max_NOM; '));				WRITE_REAL(FDT_value.U_L3L1_Max_NOM,			0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('U_L3L1_Max_TH_NOM; '));			WRITE_REAL(FDT_value.U_L3L1_Max_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L3L1_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.U_L3L1_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('U_L3L1_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.U_L3L1_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('U_L3L1_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.U_L3L1_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	

			(* I_L1 *)
			strcat(aData, ADR('I_L1_Min_NOM; '));				WRITE_REAL(FDT_value.I_L1_Min_NOM,				0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L1_Min_TH_NOM; '));			WRITE_REAL(FDT_value.I_L1_Min_TH_NOM,			3, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L1_Min_TH_s1_MAX; '));			WRITE_REAL(FDT_value.I_L1_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L1_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.I_L1_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L1_Min_TH_s1_CNT; '));			WRITE_REAL(FDT_value.I_L1_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('I_L1_Max_NOM; '));				WRITE_REAL(FDT_value.I_L1_Max_NOM,				0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L1_Max_TH_NOM; '));			WRITE_REAL(FDT_value.I_L1_Max_TH_NOM,			3, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L1_Max_TH_s1_MAX; '));			WRITE_REAL(FDT_value.I_L1_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('I_L1_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.I_L1_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L1_Max_TH_s1_CNT; '));			WRITE_REAL(FDT_value.I_L1_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	

			(* I_L2 *)
			strcat(aData, ADR('I_L2_Min_NOM; '));				WRITE_REAL(FDT_value.I_L2_Min_NOM,				0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('I_L2_Min_TH_NOM; '));			WRITE_REAL(FDT_value.I_L2_Min_TH_NOM,			3, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L2_Min_TH_s1_MAX; '));			WRITE_REAL(FDT_value.I_L2_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('I_L2_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.I_L2_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L2_Min_TH_s1_CNT; '));			WRITE_REAL(FDT_value.I_L2_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('I_L2_Max_NOM; '));				WRITE_REAL(FDT_value.I_L2_Max_NOM,				0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('I_L2_Max_TH_NOM; '));			WRITE_REAL(FDT_value.I_L2_Max_TH_NOM,			3, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L2_Max_TH_s1_MAX; '));			WRITE_REAL(FDT_value.I_L2_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('I_L2_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.I_L2_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L2_Max_TH_s1_CNT; '));			WRITE_REAL(FDT_value.I_L2_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	

			(* I_L3 *)
			strcat(aData, ADR('I_L3_Min_NOM; '));				WRITE_REAL(FDT_value.I_L3_Min_NOM,				0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('I_L3_Min_TH_NOM; '));			WRITE_REAL(FDT_value.I_L3_Min_TH_NOM,			3, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L3_Min_TH_s1_MAX; '));			WRITE_REAL(FDT_value.I_L3_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L3_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.I_L3_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L3_Min_TH_s1_CNT; '));			WRITE_REAL(FDT_value.I_L3_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L3_Max_NOM; '));				WRITE_REAL(FDT_value.I_L3_Max_NOM,				0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('I_L3_Max_TH_NOM; '));			WRITE_REAL(FDT_value.I_L3_Max_TH_NOM,			3, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L3_Max_TH_s1_MAX; '));			WRITE_REAL(FDT_value.I_L3_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('I_L3_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.I_L3_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('I_L3_Max_TH_s1_CNT; '));			WRITE_REAL(FDT_value.I_L3_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	

			(* Q *)
			strcat(aData, ADR('Q_Min_NOM; '));					WRITE_REAL(FDT_value.Q_Min_NOM,					0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Q_Min_TH_NOM; '));				WRITE_REAL(FDT_value.Q_Min_TH_NOM,				1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Q_Min_TH_s1_MAX; '));			WRITE_REAL(FDT_value.Q_Min_TH_s1_MAX,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Q_Min_TH_NOM_CNT; '));			WRITE_REAL(FDT_value.Q_Min_TH_NOM_CNT,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Q_Min_TH_s1_CNT; '));			WRITE_REAL(FDT_value.Q_Min_TH_s1_CNT,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Q_Max_NOM; '));					WRITE_REAL(FDT_value.Q_Max_NOM,					0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Q_Max_TH_NOM; '));				WRITE_REAL(FDT_value.Q_Max_TH_NOM,				1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Q_Max_TH_s1_MAX; '));			WRITE_REAL(FDT_value.Q_Max_TH_s1_MAX,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Q_Max_TH_NOM_CNT; '));			WRITE_REAL(FDT_value.Q_Max_TH_NOM_CNT,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Q_Max_TH_s1_CNT; '));			WRITE_REAL(FDT_value.Q_Max_TH_s1_CNT,			0, aData);	strcat(aData, ADR('$n'));	

			(* F *)
			strcat(aData, ADR('Freq_Min_NOM; '));				WRITE_REAL(FDT_value.Freq_Min_NOM,				0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Freq_Min_TH_NOM; '));			WRITE_REAL(FDT_value.Freq_Min_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Freq_Min_TH_s1_MAX; '));			WRITE_REAL(FDT_value.Freq_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Freq_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.Freq_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Freq_Min_TH_s1_CNT; '));			WRITE_REAL(FDT_value.Freq_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Freq_Max_NOM; '));				WRITE_REAL(FDT_value.Freq_Max_NOM,				0, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('Freq_Max_TH_NOM; '));			WRITE_REAL(FDT_value.Freq_Max_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Freq_Max_TH_s1_MAX; '));			WRITE_REAL(FDT_value.Freq_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Freq_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.Freq_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('Freq_Max_TH_s1_CNT; '));			WRITE_REAL(FDT_value.Freq_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	

			(* CosPhi *)
			strcat(aData, ADR('CosPhi_Min_NOM; '));				WRITE_REAL(FDT_value.CosPhi_Min_NOM,			3, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('CosPhi_Min_TH_NOM; '));			WRITE_REAL(FDT_value.CosPhi_Min_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('CosPhi_Min_TH_s1_MAX; '));		WRITE_REAL(FDT_value.CosPhi_Min_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('CosPhi_Min_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.CosPhi_Min_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('CosPhi_Min_TH_s1_CNT; '));		WRITE_REAL(FDT_value.CosPhi_Min_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('CosPhi_Max_NOM; '));				WRITE_REAL(FDT_value.CosPhi_Max_NOM,			3, aData);	strcat(aData, ADR('$n'));
			strcat(aData, ADR('CosPhi_Max_TH_NOM; '));			WRITE_REAL(FDT_value.CosPhi_Max_TH_NOM,			1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('CosPhi_Max_TH_s1_MAX; '));		WRITE_REAL(FDT_value.CosPhi_Max_TH_s1_MAX,		0, aData);	strcat(aData, ADR('$n'));		
			strcat(aData, ADR('CosPhi_Max_TH_NOM_CNT; '));		WRITE_REAL(FDT_value.CosPhi_Max_TH_NOM_CNT,		0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('CosPhi_Max_TH_s1_CNT; '));		WRITE_REAL(FDT_value.CosPhi_Max_TH_s1_CNT,		0, aData);	strcat(aData, ADR('$n'));

			(* T_Main *)
			strcat(aData, ADR('T_Main_NOM; '));
			FOR iCnt:=0 TO 10 DO	WRITE_REAL(FDT_value.T_Main_NOM[iCnt],	3, aData);	END_FOR
			strcat(aData, ADR('$n'));	
			strcat(aData, ADR('T_Main_TH_NOM; '));				WRITE_REAL(FDT_value.T_Main_TH_NOM,				1, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('T_Main_TH_s1_MAX; '));			WRITE_REAL(FDT_value.T_Main_TH_s1_MAX,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('T_Main_TH_NOM_CNT; '));			WRITE_REAL(FDT_value.T_Main_TH_NOM_CNT,			0, aData);	strcat(aData, ADR('$n'));	
			strcat(aData, ADR('T_Main_TH_s1_CNT; '));			WRITE_REAL(FDT_value.T_Main_TH_s1_CNT,			0, aData);	strcat(aData, ADR('$n'));
			
			(* new with V4.7 *)
			strcat(aData, ADR('Lam_Set_Min_filter_H_MAX; ')); 	WRITE_REAL(FDT_value.Lam_Set_Min_filter_H_MAX, 		3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Lam_Set_Min_filter_H_Tconst; ')); WRITE_REAL(FDT_value.Lam_Set_Min_filter_H_Tconst, 	0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Lam_Set_Max_filter_H_MAX; ')); 	WRITE_REAL(FDT_value.Lam_Set_Max_filter_H_MAX , 	3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Lam_Set_Max_filter_H_Tconst; ')); WRITE_REAL(FDT_value.Lam_Set_Max_filter_H_Tconst , 0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('U_Ign_TH_MDN; ')); 				WRITE_REAL(FDT_value.U_Ign_TH_MDN , 				3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('U_Ign_TH_MDN_CNT; ')); 			WRITE_REAL(FDT_value.U_Ign_TH_MDN_CNT , 			0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('U_Ign_TH_s1_MAX; ')); 			WRITE_REAL(FDT_value.U_Ign_TH_s1_MAX , 				0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('U_Ign_TH_s1_CNT; ')); 			WRITE_REAL(FDT_value.U_Ign_TH_s1_CNT , 				0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('I_L_jumpThresh; ')); 			WRITE_REAL(FDT_value.I_L_jumpThresh , 				0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('I_L_jumpTol; ')); 				WRITE_REAL(FDT_value.I_L_jumpTol , 					0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('P_Act_jumpThresh; ')); 			WRITE_REAL(FDT_value.P_Act_jumpThresh , 			0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_IMEP_rangeThresh; ')); 		WRITE_REAL(FDT_value.Pr_IMEP_rangeThresh , 			0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('P_Set_Max_TH_SP; ')); 			WRITE_REAL(FDT_value.P_Set_Max_TH_SP , 				3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('P_Set_Max_TH_SP_CNT; ')); 		WRITE_REAL(FDT_value.P_Set_Max_TH_SP_CNT , 			0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_Peak_TH_MDN; ')); 			WRITE_REAL(FDT_value.Pr_Peak_TH_MDN , 				3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_Peak_TH_MDN_CNT; ')); 		WRITE_REAL(FDT_value.Pr_Peak_TH_MDN_CNT , 			0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_Peak2_TH_MDN; ')); 			WRITE_REAL(FDT_value.Pr_Peak2_TH_MDN , 				3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_Peak2_TH_MDN_CNT; ')); 		WRITE_REAL(FDT_value.Pr_Peak2_TH_MDN_CNT , 			0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('IMEP2_TH_MDN; ')); 				WRITE_REAL(FDT_value.IMEP2_TH_MDN , 				3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('IMEP2_TH_MDN_CNT; ')); 			WRITE_REAL(FDT_value.IMEP2_TH_MDN_CNT , 			0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_GR_Act_Max2_TH_REF; ')); 		WRITE_REAL(FDT_value.Pr_GR_Act_Max2_TH_REF , 		3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_GR_Act_Max2_TH_REF_CNT; ')); 	WRITE_REAL(FDT_value.Pr_GR_Act_Max2_TH_REF_CNT , 	0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('CA_PI_Duration2_TH_MDN; ')); 	WRITE_REAL(FDT_value.CA_PI_Duration2_TH_MDN , 		3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('CA_PI_Duration2_TH_MDN_CNT; ')); WRITE_REAL(FDT_value.CA_PI_Duration2_TH_MDN_CNT , 	0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('CA_PI_Dur_PID_Offs_TH_s1_MAX; ')); 	WRITE_REAL(FDT_value.CA_PI_Dur_PID_Offs_TH_s1_MAX , 3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('CA_PI_Dur_PID_Offs_TH_s1_MAX_CNT; ')); 	WRITE_REAL(FDT_value.CA_PI_Dur_PID_Offs_TH_s1_MAX_CNT , 0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_Peak_TH_LIM; ')); 			WRITE_REAL(FDT_value.Pr_Peak_TH_LIM , 				0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('Pr_Peak_TH_LIM_CNT; ')); 		WRITE_REAL(FDT_value.Pr_Peak_TH_LIM_CNT , 			0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('N_TCHP_A_Max_TH_REF; ')); 		WRITE_REAL(FDT_value.N_TCHP_A_Max_TH_REF , 			3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('N_TCHP_A_Max_TH_REF_CNT; ')); 	WRITE_REAL(FDT_value.N_TCHP_A_Max_TH_REF_CNT , 		0, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('N_TCLP_A_Max_TH_REF; ')); 		WRITE_REAL(FDT_value.N_TCLP_A_Max_TH_REF , 			3, aData);	strcat(aData, ADR('$n')); 
			strcat(aData, ADR('N_TCLP_A_Max_TH_REF_CNT; ')); 	WRITE_REAL(FDT_value.N_TCLP_A_Max_TH_REF_CNT , 		0, aData);	strcat(aData, ADR('$n')); 

			strcat(aData, ADR('</ATD>$n'));
		END_IF		
		(**** ATD- END  ****)

		strcat(aData, ADR('END OF FILE $n'));																							(* end of file *)
		iPointer	:=	save_strcat(ADR(DerString), iSize_String, iPointer, aData);														(* write line *)
		iPointer	:=	save_strcat(ADR(DerString), iSize_String, iPointer, ADR('</PBC_FILE>'));
		bWrite	:=	FALSE;																												(* buffer can start *)
		iStep	:=	_EXIST;																												(* next step *)
(** 4.8: check for existing permanent memory data module *)			
	_EXIST:
			DatObjInfo_01();
			CASE  DatObjInfo_01.status OF
			_BUSY: 	iStep;
			_OKAY:	bPBC_GetFile:=	TRUE;
					iStep 		:= _WRITE;
					DatObjWrite_01.ident   	:= DatObjInfo_01.ident;	
					DatObjWrite_01.len		:= pm_len;	
			_DONF:	iStep		:=	_CREATE;
			ELSE	iErrorStep	:=	iStep;
					iStep		:=	_ERROR;
					iError		:=	DatObjInfo_01.status;
			END_CASE
(** 4.10: create permanent memory data module *)	
	_CREATE:					
		DatObjCreate_01();             			(* repeat until generation of permanent memory data module is ready *)
		CASE  DatObjCreate_01.status OF
		_BUSY:	iStep;
		_OKAY:	DatObjWrite_01.ident   	:= DatObjCreate_01.ident;		(* set identifier of permanent memory data module     	*)
				DatObjWrite_01.len		:= pm_len;	
				iStep		:=	_WRITE;	
		ELSE	iErrorStep	:=	iStep;
				iStep		:=	_ERROR;
				iError		:=	DatObjCreate_01.status;
		END_CASE
(** 4.10: write permanent memory data module *)
	_WRITE:		
		DatObjWrite_01(); 
	 	CASE DatObjWrite_01.status OF
		_BUSY:	iStep;	(*mach nix*)
    	_OKAY:	iStep		:=	_HMI;
				iECB_HMI	:=	0;
				bPBC_GetFile:=	TRUE;
		ELSE	iErrorStep	:=	iStep;
				iStep		:=	_ERROR;
				iError		:=	DatObjWrite_01.status;
		END_CASE
(** 4.11.: waiting for HMI to pickup file, unlock 'DerString' *)
	_HMI:
		bECB_Lock		:=	FALSE;
		iECB_HMI		:=	iECB_HMI + 100;
		MM2VIS.bECBMem_isCreated	:= TRUE;	
		IF iECB_HMI >= TIME_TO_UDINT(tiHMI_Delay) OR VIS2MM.bECBMem_isRead THEN
			iStep		:=	_DONE;
			MM2VIS.bECBMem_isCreated	:= FALSE;
			VIS2MM.bECBMem_isRead		:= FALSE;	
		END_IF
(** 4.12: done *)
	_DONE:	iStep		:=	_IDLE;

(** 4.13: idle, waiting for triggers *)
	_IDLE:	iZeile		:=	0;
			iErrorStep	:=	0;
			iError		:=	0;
(** 4.14: error, waiting for cold start *)
	_ERROR:	iStep;
			bECB_Lock	:=	FALSE;
	
	END_CASE

(** 5: HMI Links *)

	MM2VIS.ECB.bSave	:=	iStep <> _IDLE;
	MM2VIS.ECB.bBuff	:=	bPBC_Record;
	MM2VIS.ECB.bLock	:=	iStep <> _IDLE OR bPBC_Write;
	IF bPBC_Write AND bPBC_Record AND iStep = _IDLE THEN
		MM2VIS.ECB.iStep	:=	_WAIT;
	ELSE
		MM2VIS.ECB.iStep	:=	iStep;
	END_IF

	IF tiHMI_Delay <> T#0s THEN
		rHMI_Delay	:=	LIMIT(0.0, UDINT_TO_REAL(iECB_HMI) / TIME_TO_REAL(tiHMI_Delay), 1.0);
	ELSE
		rHMI_Delay	:=	0;
	END_IF

	IF iStep = _DONE THEN
		MM2VIS.ECB.rSave	:=	1.0;
	ELSIF iStep <> _HMI THEN
		MM2VIS.ECB.rSave	:=	0.5 * INT_TO_REAL(iZeile)/INT_TO_REAL(iBufferSize);
	ELSIF iStep = _HMI THEN
		MM2VIS.ECB.rSave	:=	0.5 + 0.5 * rHMI_Delay;
	END_IF

	MM2VIS.ECB.bWarn	:=	iTC_Max = INT_TO_UINT(Buffer.iCnt_ui16_H) OR
							iEC_Max = INT_TO_UINT(Buffer.iCnt_ui16) OR
							iSC_Max = INT_TO_UINT(Buffer.iCnt_ui16_low) OR
							iPC_Max = INT_TO_UINT(Buffer.iCnt_pattern);

END_PROGRAM
