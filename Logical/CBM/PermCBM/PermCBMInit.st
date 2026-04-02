(*******************************************************************************
AGGR: read AND write DIA.NE XT parameter TO flash memory	(init)

This code is confidential AND proprietary TO the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission OF the INNIO Company.
Copyright, INNIO Company, 2019

- every 10 seconds OR at write once the parameter values are copied TO the structure pm
- every 10 seconds the checksum OF the parameter structure is calculate
- IF checksum has changed OR write once is set the structure pm is written TO 
	the permanent memory data module

Customized modifications: -
------------------------
 
History:
-------
V04.09.00.00	28-05-2019	Waldhart,	generated
				10.09.2019	Zengerer	Basisupdate01 from V4.07 implemented: Changed Perm Storage Handling for reduced file write cycle -10min delay after successful prem write


Instructions FOR use:
--------------------
(init)
The parameter are stored in a data module which is stored on flash memory.
At start up the parameter will be readed from the flash memory AND copied TO
the parameter variables. If the data module does NOT exist OR the length OF
data module AND parameter struct is different, the data module will be created.
(cyclic)
Every 10 seconds OR at write once the parameter values are copied TO the 
structure pm. Afterwards the structure pm is written TO the permanent memory
module IF the checksum OF the parameter struct has been changed.

Add new tags only at the end OF the structure AND check/INSERT new data module lenght!

Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT


	(* set some init parameters *)
	TON_WritePMEM(IN := FALSE, PT:= T#10s);			(* reset used timer function blocks 			*)
	
	pm_Error 	:= ERR_NOERROR;						(* reset permanent memory error	status			*)
	write_once 	:= FALSE;				 			(* reset flag for write permanent memory once	*)
	pm_len 		:= SIZEOF(pmm);						(* define data length of permenent memory		*)
	strcpy(ADR(ModuleName),ADR('CBM::CBM_perm'));			(* define name of permanent memory data module	*)
	
	

	(* check for existing permanent memory data module	*)
	DatObjInfo_01.enable:= TRUE;					(* enable FUB									*)
	DatObjInfo_01.pName := ADR(ModuleName);			(* set permanent memory data module name 		*)
	DatObjInfo_01();								(* run data object info FUB						*)
	
	(* check error status of data object info FUB	*)
	IF DatObjInfo_01.status = ERR_NOERROR THEN		(* if no error	--> permanent memory data module exists	*)
		pm_id 	:= DatObjInfo_01.ident;				(* copy permanent memory data module ident			*)
		pm_p 	:= DatObjInfo_01.pDatObjMem;		(* copy permanent memory data module memory adres	*)
	ELSE
		bCreateDataObj := TRUE;						(* set flag for create new data object	*)
		pm_Error := 1001;							(* set permanent memory error status	*)
	END_IF;
	
	
	(* check length of parameter struct with length of data object *)
	
	IF DatObjInfo_01.len = pm_len THEN	
			perm_par_vers  := 409;			(* 409 = length of perm_par V4.09.0 *) //update FS structure 
	
	ELSE
			bCreateDataObj := TRUE;			(* set flag for create new data object	*)
	END_IF
	
	(* if permanent memory data module exist read data and copy to structure pm	*)
	IF pm_Error = ERR_NOERROR THEN					(* permanent memory data module exist 				*)
		DatObjRead_01.enable 		:= TRUE;		(* enable read permanent memory module data 		*)
		DatObjRead_01.ident 		:= pm_id;		(* set identifier of permanent memory data module	*)
		DatObjRead_01.Offset 		:= 0;			(* start at memory offest zero 						*)
		DatObjRead_01.pDestination := ADR(pmm);		(* set permanent data destination adress			*)
		DatObjRead_01.len 			:= DatObjInfo_01.len;	(* set length of permanent data module		*)
	
		REPEAT	(* repeat until data of permanent memory data module have been read *)
			DatObjRead_01();						(* FUB read data from permanent data module 		*)
			UNTIL	DatObjRead_01.status <> ERR_FUB_BUSY		(* wait if FUB is busy 	*)
		END_REPEAT;
	
		IF DatObjRead_01.status <> ERR_NOERROR THEN	(* if status of read permanent data moduel is not OK 	*)
			pm_Error := 1002;						(* set permanent memory error status					*)
		ELSE
			IF OUT_CB.tCB2PB.iPermStatus >=0 THEN 													(* new V4.06: transmit perm status info *)
				OUT_CB.tCB2PB.iPermStatus := LIMIT(2, OUT_CB.tCB2PB.iPermStatus + pm_len, 999999);	(* new V4.06: transmit perm status info *)
				OUT_CB.tCB2PB.bPermSetupOk := TRUE	;												(* new V4.06: transmit perm status info *)
			END_IF																					(* new V4.06: transmit perm status info *)
		END_IF
	END_IF
	
	
	(* if permanent memory data module exist --> copy data from structure pm to program parameter *)
	IF pm_Error = ERR_NOERROR THEN

		(*************************)
		Perm						:= pmm;				(* overall copy of values from stored structure 'pm' to active structure 'Perm'  *)

		iPM_WriteCnt				:= pmm.iSpare_5;	(* Perm diagnosis value implemented in V4.07.1; may be removed and used for other topics later on, if necessary*)
	
		   IF OUT_CB.tCB2PB.iPermStatus >=0 THEN 												(* new V4.06: transmit perm status info *)
				OUT_CB.tCB2PB.iPermStatus := LIMIT(2, OUT_CB.tCB2PB.iPermStatus + pm_len, 999);	(* new V4.06: transmit perm status info *)
		   		OUT_CB.tCB2PB.bPermSetupOk := TRUE	;											(* new V4.06: transmit perm status info *)
			END_IF																				(* new V4.06: transmit perm status info *)


		(*************************)

	END_IF;
	
	
	(* create new permanent memory data module	*)
	IF bCreateDataObj THEN
	
//		(* try to delete old data module *)
//		DatObjDelete_PermMem.enable := TRUE;		(*OLD! NOT POSSIBLE IN SYSROM! *)
	
		(* create new one *)
		DatObjCreate_01.enable	 := TRUE;			(* enable create permanent memory data module FUB 	*)
		DatObjCreate_01.grp 	 := 0;				(* must to be set to zero							*)
		DatObjCreate_01.pName 	 := ADR(ModuleName);	(* set permanent memory data module name 			*)
		DatObjCreate_01.len 	 := pm_len;			(* set length ofpermanent memory data module		*)
		DatObjCreate_01.MemType  := doUSRROM;		(* create permanent memory data module at USERROM (changed from doSYSROM due to VIS reasons)	*)
		DatObjCreate_01.Option 	 := 0;				(* cyclic checksum monitoring is on					*)
		DatObjCreate_01.pCpyData := 0;				(* no data will be copied do the permanent memory data module *)
	
		pm_Error:= 1003;							(* set permanent memory error status	*)
	
		REPEAT	(* repeat until generation of permanent memory data module is ready *)
			DatObjCreate_01();						(* FUB for create permanent memory data module 		*)
			UNTIL	DatObjCreate_01.status <> ERR_FUB_BUSY		(* wait if FUB is busy 	*)
		END_REPEAT;
	
		IF DatObjCreate_01.status = ERR_NOERROR THEN	(* is creation of permanent memory data module OK 	*)
			pm_p 	:= DatObjCreate_01.pDatObjMem;		(* set memory adress of permanent memory data module*)
			pm_id 	:= DatObjCreate_01.ident;			(* set identifier of permanent memory data module 	*)
		ELSE
			pm_Error:= 1004;							(* set permanent memory error status	*)
		END_IF;
	END_IF;
	
	
	(* prepare parameter for permanent memory data write in cyclic task *)
	IF pm_Error < 4 THEN							(* permanent memory data module exist or has been created	*)
		DatObjWrite_01.enable 	:= TRUE;			(* enable permanent memory data module read FUB 	*)
		DatObjWrite_01.ident 	:= pm_id;			(* set identifier of permanent memory data module 	*)
		DatObjWrite_01.Offset 	:= 0;				(* start at memory offest zero 						*)
		DatObjWrite_01.pSource 	:= ADR(pmm);		(* set permanent memory data module name 			*)
		DatObjWrite_01.len 		:= pm_len;			(* set length ofpermanent memory data module		*)
	END_IF;
	
	
	(* calcualte actual checksum of parameter structure	*)
	ulChecksumOld := 0;			(* reset checksum value *)
	
	FOR ulPMPointer := ADR(pmm) TO (ADR(pmm) + pm_len - SIZEOF(ulChkValue)) DO
		memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));
		ulChecksumOld := ulChecksumOld XOR ulChkValue;
	END_FOR;

	(**Forward Perm Error - new V4.06 *)
	IF (pm_Error > 0) AND (OUT_CB.tCB2PB.iPermStatus = 0) THEN 	OUT_CB.tCB2PB.iPermStatus := - pm_Error	;	END_IF		(* new V4.06: transmit error as negative perm status info *)
	IF (OUT_CB.tCB2PB.iPermStatus < 0) THEN 	OUT_CB.tCB2PB.bPermSetupOk := FALSE	;	END_IF			(* new V4.06: transmit perm status info *)



END_PROGRAM

