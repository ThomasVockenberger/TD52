(*******************************************************************************
AGGR: read AND write DIA.NE XT parameter TO flash memory	(cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- every 10 seconds or at write once the parameter values are copied to the structure pm
- every 10 seconds the checksum of the parameter structure is calculate
- if checksum has changed or write once is set the structure pm is written to 
	the permanent memory data module

Customized modifications: -
------------------------
 
History:
---
-after successful prem write, all further write attempts will be delayed for 10min to reduce flash wear----
V04.09.00.00	28-05-2019	Waldhart,	generated
				10.09.2019	Zengerer	Basisupdate01 from V4.07 implemented: Changed Perm Storage Handling for reduced file write cycle -10min delay after successful prem write


 *
 * Customized modifications: -
 * ------------------------
 * This is the customized Version for METAMODULE CB
 *
 * Outstandings:
 * ------------
 *
 ********************************************************************)

(***********************************************************************************************************)
(* CYCLIC **************************************************************************************************)
(***********************************************************************************************************

Instructions FOR use:
--------------------
(* MODULE SPECIFIC CHANGES IN CYCLIC PART: 
 * Confgure IN_CU and OUT_CU Structure names in cyclic task.
 * Configure optional checking for necessary Parameter in cyclic task.

(**********************************************************************************************************)

PROGRAM _CYCLIC

	(* participate in parasave environment to use system status messages: *)
	(* Connection from tParaIntern structure to IN and OUT structures INSTRUCTION: EDIT 1xIN_ and 2xOUT_ STRUCTURE NAMES FOR THIS MODULE HERE! *)
	tParaIntern.tParaBase2MM	:= IN_CB.tPB2MM;
	(*OUT_CB.tCB2PB.				:= tParaIntern.tMM2ParaBase.;  DO NOT CONNECT ParaOUT STRUCTURE HERE in Perm task! *)

(********************************************************************************************************)
(* Every 10 seconds OR at write once the parameter values are copied TO the 							*)
(* structure pm. Afterwards the structure pm is written TO the permanent memory							*)
(* module IF the checksum OF the parameter struct has been changed.										*)
(**********************************************************************************************************)
	(* 10 seconds timer *)
	TON_WritePMEM(IN := NOT TON_WritePMEM.Q, PT:= T#10s);
	TON_BlockMinFileAge(IN := bBlock_MinFileAge, PT:= T#10m);			(*V4.07.1 reduced Perm file write intervall*)
	IF TON_BlockMinFileAge.Q  THEN bBlock_MinFileAge := FALSE; END_IF	(*V4.07.1 reduced Perm file write intervall*)
	
	(* every 10 seconds or at write once the parameter values are copied to the structure pm *)
	IF TON_WritePMEM.Q OR write_once THEN
	
	(************ Permanent structure ************)
		pmm				:= Perm;
		
		pmm.iSpare_5	:= iPM_WriteCnt;		(*Perm diagnosis value implemented in V4.07.1; may be removed and used for other topics later on, if necessary *)

	END_IF;
	
	(* cyclic calcualtion of parameter checksum	*)
	IF TON_WritePMEM.Q THEN
		ulChecksum := 0;
	
		FOR ulPMPointer := ADR(pmm) TO (ADR(pmm) + pm_len - SIZEOF(ulChkValue)) DO
			memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));
			ulChecksum := (ulChecksum XOR ulChkValue)+ulChkValue;
		END_FOR;
	
		IF ulChecksumOld <> ulChecksum THEN	(* if checksum has changed 		*)
			ulChecksumOld := ulChecksum;	(* save last cheksum value		*)
			bWriteDataObj := TRUE;			(* set flag for write checksum	*)
		END_IF;
	
	END_IF
	
	
	(* write structure pm to the permanent memory module  	changed with bBlock_MinFileAge V4.07.1, for reduced Perm file write intervall*)
	IF ( (bWriteDataObj AND NOT bBlock_MinFileAge) OR write_once ) AND tParaIntern.tParaBase2MM.bSaveParaAllowed AND NOT tParaIntern.tParaBase2MM.bDownloadDetected THEN
		
		DatObjWrite_01();									(* run data object write fub 				*)
	
		IF DatObjWrite_01.status <> ERR_FUB_BUSY THEN		(* wait if data object write fub is busy 	*)
			bWriteDataObj 	:= FALSE;						(* reset data object write flag				*)
			write_once 		:= FALSE;						(* reset write_once flag 					*)
			iPM_WriteCnt 	:= iPM_WriteCnt  + 1;			(* former usPMWriteCnt: counter for done data object module writes *)
	
			
				
			IF OUT_CB.tCB2PB.iPermStatus >=0 THEN 												(* new V4.06: if not already on error state, then transmit this perm status info *)
				OUT_CB.tCB2PB.iPermStatus := LIMIT(2, OUT_CB.tCB2PB.iPermStatus + 1, 999);		(* new V4.06: transmit OK= positive perm status info *)
				IF OUT_CB.tCB2PB.iPermStatus = 999 THEN OUT_CB.tCB2PB.iPermStatus := 2; END_IF	(* new V4.06: transmit OK= positive perm status info *)
				OUT_CB.tCB2PB.bPermSetupOk := TRUE	;											(* new V4.06: transmit perm status info *)
			END_IF

			IF DatObjWrite_01.status = ERR_NOERROR THEN		(* if error status NO ERROR, then start timer to block forther write requests for some time to avoid CF wear down	*)
				bBlock_MinFileAge := TRUE;	
			ELSE											(* if error status not no error 			*)
				pm_Error := 1004;							(* set data object write error state		*)
			END_IF;
		END_IF;
	
	END_IF;
	
//OLD	(* set RPS warning if no access to SysRom file is possible *)	
//OLD	TON_WarnDelay(IN := pm_Error > 3 OR NOT tParaIntern.tParaBase2MM.bSaveParaAllowed, PT:= T#15s);
//OLD	tParaIntern.tMM2ParaBase.bMyParaMissing	:= TON_WarnDelay.Q; 	(*replacement for RPSW[1] := *)

	(* Forward Perm Error - new V4.06 *)
//	IF (pm_Error > 0) AND (OUT_CB.tCB2PB.iPermStatus <= 0) THEN OUT_AG.tAG2PB.iPermStatus := LIMIT(-999999,-pm_Error ,-1) ;	END_IF		(*no CYCLIC! new V4.06: transmit error as negative perm status info *)
	IF (pm_Error > 0) AND (OUT_CB.tCB2PB.iPermStatus >= 0) THEN 	OUT_CB.tCB2PB.iPermStatus :=LIMIT(-999999,-UINT_TO_DINT(pm_Error) ,-1);	END_IF		(* new V4.06: transmit error as negative perm status info *)
	IF (OUT_CB.tCB2PB.iPermStatus < 0) THEN 	OUT_CB.tCB2PB.bPermSetupOk := FALSE	;	END_IF			(* new V4.06: transmit perm status info *)


	
END_PROGRAM


(***********************************************************************************************************)
PROGRAM _EXIT

	tParaIntern.tMM2ParaBase.bMySys_Run := FALSE;				(* local 'RUN' and 'run_plc' clearing*)
	//REMOVED IF NOT bOpt_PermDataWrite_Continuous THEN			(* alternative attempt to write perm file only on EXIT*)

END_PROGRAM