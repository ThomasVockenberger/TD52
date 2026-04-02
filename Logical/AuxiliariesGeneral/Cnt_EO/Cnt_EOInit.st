(*******************************************************************************
AGGR: oil consumption counting and saving data (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- set some init parameters
- check for existing permanent memory data module
- if permanent memory data module doesn´t exists, or length of data module and
  parameter struct is different create permanent memory data module
- prepare parameter for permanent memory data write in cyclic task
- if permanent memory data module exist read data and copy to structure pm
- if permanent memory data module exist copy data from structure pm to program parameter

Customized modifications: -
------------------------
 
History:
-------
V2.30	31-03-2008	TinelloM,	generated from perm_par
V3.99.0	??						Add Metamodule name to_perm name
V3.99.1	06.11.2014	Zengerer	USERROM, changed from SYSROM due to VIS reasons
V4.06.0 005 05.10.2018 Zengerer beta: OUT_AG.tAG2PB.bPermSetupOk,  transmit perm status info, pm_Error +1000


Instructions for use:
--------------------
The parameter are stored in a data module which is stored on flash memory.
At start up the parameter will be readed from the flash memory and copied to
the parameter variables. If the data module does not exist or the length of
data module and parameter struct is different, the data module will be created.

Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT
	
	
	(* set oil counter counting direction to positive *)
	ucModeRegister1 := 14;		
		
	(* set some init parameters *)
	xTON_WritePMEM(IN := FALSE, PT:= T#10s);					(* reset used timer function blocks 			*)
	xTP_OilExchange.PT 	:= T#5s;
	xTP_OilSample.PT 	:= T#5s;
	xTP_CWExchange.PT 	:= T#5s;
	xTP_CWSample.PT 	:= T#5s;
	xTON_OilExchange.PT := T#1s500ms;
	xTON_OilSample.PT 	:= T#1s500ms;
	xTON_CWExchange.PT 	:= T#1s500ms;
	xTON_CWSample.PT 	:= T#1s500ms;
	
	pm_Error 	:= ERR_NOERROR;								(* reset permanent memory error	status			*)
	write_once 	:= FALSE;				 					(* reset flag for write permanent memory once	*)
	pm_len 		:= SIZEOF(pmOil);							(* define data length of permenent memory		*)
	strcpy(ADR(ModulName),ADR('AuxiliariesGeneral::oil_perm'));		(* define name of permanent memory data module	*)
	
	
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
		pm_Error := 1001;									(* set permanent memory error status	*)
	END_IF;
	
	
	(* check length of parameter struct with length of data object *)
	
	CASE DatObjInfo_01.len OF

//(*488:   perm_oil_vers  := 230;							(  488 = length of perm_par V2.30 !DISABELED! Do not allow old data files to force rebuild with latest file format !*)	
//(*	   OUT_AG.tAG2PB.iPermStatus := OUT_AG.tAG2PB.iPermStatus + perm_oil_vers	;	( new V4.06: transmit perm status info *)
		// OUT_AG.tAG2PB.bPermSetupOk := TRUE	;				(* new V4.06: transmit perm status info *)

	728:   perm_oil_vers  := 390;							(* 728 = length of perm_par V3.90 *)
		   OUT_AG.tAG2PB.iPermStatus := OUT_AG.tAG2PB.iPermStatus + perm_oil_vers	;	(* new V4.06: transmit perm status info *)
		// OUT_AG.tAG2PB.bPermSetupOk := TRUE	;				(* new V4.06: transmit perm status info *)

	(* insert new perm_par Version here
	(* 		   bCreateDataObj := TRUE;						(* set flag for create new data object	*)
	(* xxxx:   perm_oil_vers  := yyy;						(* xxxx = length of perm_par Vy.yy *)
	
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
		DatObjRead_01.pDestination 	:= ADR(pmOil);			(* set permanent data destination adress			*)
		DatObjRead_01.len 			:= DatObjInfo_01.len;	(* set length of permanent data module				*)
	
		REPEAT	(* repeat until data of permanent memory data module have been read *)
			DatObjRead_01();								(* FUB read data from permanent data module 		*)
			UNTIL	DatObjRead_01.status <> ERR_FUB_BUSY	(* wait if FUB is busy 	*)
		END_REPEAT;
	
		IF DatObjRead_01.status <> ERR_NOERROR THEN			(* if status of read permanent data moduel is not OK 	*)
			pm_Error :=	1002;								(* set permanent memory error status					*)
		END_IF
	END_IF;
	
	
	(* if permanent memory data module exist --> copy data from structure pm to program parameter *)
	IF pm_Error = ERR_NOERROR THEN
	
		(* ------------- V2.30 ---------------- *)
		kwh						:= pmOil.kwh;					
		ucIndexOil				:= pmOil.ucIndexOil;			
		OilCounter				:= pmOil.OilCounter;			


		(* ------------- V1.xx--------------- *)
		(* perm_oil_vers >= 240 THEN
		*)

		   IF OUT_AG.tAG2PB.iPermStatus >=0 THEN 													(* new V4.06: transmit perm status info *)
				OUT_AG.tAG2PB.iPermStatus := LIMIT(2, OUT_AG.tAG2PB.iPermStatus + pm_len, 999999);		(* new V4.06: transmit perm status info *)
		   		OUT_AG.tAG2PB.bPermSetupOk := TRUE	;												(* new V4.06: transmit perm status info *)
			END_IF																					(* new V4.06: transmit perm status info *)
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
		DatObjCreate_01.MemType  := doUSRROM;			(* create permanent memory data module at USERROM (changed from doSYSROM due to VIS reasons)	*)
		DatObjCreate_01.Option 	 := 0;					(* cyclic checksum monitoring is on					*)
		DatObjCreate_01.pCpyData := 0;					(* no data will be copied do the perm. mem. data module *)
	
		pm_Error:= 1003;								(* set permanent memory error status	*)
	
		REPEAT	(* repeat until generation of permanent memory data module is ready *)
			DatObjCreate_01();							(* FUB for create permanent memory data module 		*)
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
	IF pm_Error < 1004 THEN								(* permanent memory data module exist or has been created	*)
		DatObjWrite_01.enable 	:= TRUE;				(* enable permanent memory data module read FUB 	*)
		DatObjWrite_01.ident 	:= pm_id;				(* set identifier of permanent memory data module 	*)
		DatObjWrite_01.Offset 	:= 0;					(* start at memory offest zero 						*)
		DatObjWrite_01.pSource 	:= ADR(pmOil);			(* set permanent memory data module name 			*)
		DatObjWrite_01.len 		:= pm_len;				(* set length ofpermanent memory data module		*)
	END_IF;
	
	
	(* calcualte actual checksum of parameter structure	*)
	ulChecksumOld := 0;									(* reset checksum value *)
	
	FOR ulPMPointer := ADR(pmOil) TO (ADR(pmOil) + pm_len - SIZEOF(ulChkValue)) DO
		memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));
		ulChecksumOld := ulChecksumOld XOR ulChkValue;
	END_FOR

	(**Forward Perm Error - new V4.06 *)
	IF (pm_Error > 0) AND (OUT_AG.tAG2PB.iPermStatus >= 0) THEN 	OUT_AG.tAG2PB.iPermStatus := LIMIT(-999999,-UINT_TO_DINT(pm_Error) ,-1)	;	END_IF		(* new V4.06: transmit error as negative perm status info *)
	IF (OUT_AG.tAG2PB.iPermStatus < 0) THEN 	OUT_AG.tAG2PB.bPermSetupOk := FALSE	;	END_IF			(* new V4.06: transmit perm status info *)


END_PROGRAM



