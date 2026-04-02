(*******************************************************************************
AGGR: Modbus RTU connection to LV GCB  (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V4.13	14-11-2023	Hohensinner	created
							   
Instructions for use:
--------------------
Caution!
- X20CS1030_xxx_xx_GCB should not be in "cyclic stream" mode, instead it should be set to "stream".
- Also the modules name must be ending with "_GCB" to be found in the init part.

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(** 1: waiting for parasetup okay *)	
	xTON_ParaSetup_Ok(IN:= TRUE AND NOT bError_Conf, PT:= tiParaSetup_Ok);
	IF NOT xTON_ParaSetup_Ok.Q OR bDeactivate_Task OR DiagCpuIsSimulated() THEN RETURN; END_IF
	
	(** 2: running the modbus master *)		
	xTON_Rel_MBMaster(IN:= xTON_ParaSetup_Ok.Q, PT:=tiRel_MBMaster);
	xMBDO_Master[0].bEnable	:=	xTON_Rel_MBMaster.Q;
	xMBDO_Master[0]();
	
	(** 3: State Machine of LV GCB connection *)
	CASE eState_GCB OF
		_GCB_INIT:
			eState_GCB := _GCB_TRY_ABB;
		_GCB_TRY_ABB:
			(* Init *)
			IF bInit THEN			
				tSlave[0].tLine[0].tIF.bExec	:=	TRUE;	//make first contact
			END_IF
			(* Wait *)
			xWAIT(IN:=1);
			(* Exit *)
			IF xWAIT.Q THEN
				IF 	NOT tSlave[0].tLine[0].tIF.bExec AND tSlave[0].tLine[0].tIF.iStatus = 0 THEN
					eState_GCB := _GCB_IDLE;
					MM2VIS.tGCB[1].iType	:= 1;
				ELSIF tSlave[0].tLine[0].tIF.bExec AND tSlave[0].tLine[0].tIF.iStatus <> ERR_FUB_BUSY THEN
					eState_GCB := _GCB_TRY_SE;
					tSlave[0].tLine[0].tIF.bExec	:=	FALSE;	//end first contact
				END_IF
			END_IF
		_GCB_TRY_SE:
			(* Init *)
			IF bInit THEN
				tSlave[1].tLine[0].tIF.bExec	:=	TRUE;	//make first contact
			END_IF
			(* Wait *)
			xWAIT(IN:=1);
			(* Exit *)
			IF xWAIT.Q THEN				
				IF 	NOT tSlave[1].tLine[0].tIF.bExec AND tSlave[1].tLine[0].tIF.iStatus = 0 THEN
					eState_GCB := _GCB_IDLE;
					MM2VIS.tGCB[1].iType	:= 2;
				ELSIF tSlave[1].tLine[0].tIF.bExec AND tSlave[1].tLine[0].tIF.iStatus <> ERR_FUB_BUSY THEN
					eState_GCB := _GCB_WAIT;
					tSlave[1].tLine[0].tIF.bExec	:=	FALSE;	//end first contact
				END_IF
			END_IF
		_GCB_WAIT:
			(* Wait *)
			xWAIT(IN:=100);
			(* Exit *)
			IF xWAIT.Q THEN	
				eState_GCB := _GCB_TRY_ABB;			
			END_IF
		_GCB_CALC:
			FOR i:=0 TO 60 DO
				rFactors := 0.4 + UINT_TO_REAL(i) * 0.01;
				IF VIS2MM.tGCB[1].rI_GenNom * 1.1 <= rFactors * MM2VIS.tGCB[1].rI_Nom THEN
					EXIT;
				END_IF
			END_FOR
			VIS2MM.tGCB[1].rI1	:=	MM2VIS.tGCB[1].rI_Nom * rFactors;
			IF bSE THEN
				VIS2MM.tGCB[1].rt1	:=	1;
			ELSIF bABB THEN
				VIS2MM.tGCB[1].rt1	:=	3;
			END_IF
			VIS2MM.tGCB[1].rI2	:=	MM2VIS.tGCB[1].rI_Nom * 2;
			VIS2MM.tGCB[1].rt2	:=	0.3;
			VIS2MM.tGCB[1].rI3	:=	MM2VIS.tGCB[1].rI_Nom * 10;
			eState_GCB := _GCB_IDLE;
		_ABB_LOAD:
			(* Init *)
			IF bInit THEN
				VIS2MM.tGCB[1].rI_GenNom := Para.rI_GenNom[1];
				tSlave[0].tLine[6].tIF.bExec	:=	TRUE;
				tSlave[0].tLine[7].tIF.bExec	:=	TRUE;	
				tSlave[0].tLine[8].tIF.bExec	:=	TRUE;
				tSlave[0].tLine[12].tIF.bExec	:=	TRUE;
			END_IF
			(* Wait *)
			xWAIT(IN:=1);
			MM2VIS.tGCB[1].rLoad	:=	BOOL_TO_REAL(NOT tSlave[0].tLine[6].tIF.bExec)/4
									+	BOOL_TO_REAL(NOT tSlave[0].tLine[7].tIF.bExec)/4
									+	BOOL_TO_REAL(NOT tSlave[0].tLine[8].tIF.bExec)/4
									+	BOOL_TO_REAL(NOT tSlave[0].tLine[12].tIF.bExec)/4;
			(* Exit *)
			IF NOT tSlave[0].tLine[6].tIF.bExec AND NOT tSlave[0].tLine[7].tIF.bExec AND
				NOT tSlave[0].tLine[8].tIF.bExec AND NOT tSlave[0].tLine[12].tIF.bExec AND xWAIT.Q THEN
				MM2VIS.tGCB[1].rI_Nom			:=	UINT_TO_REAL(tSlave[0].tLine[12].tIF.iData[0]);
				VIS2MM.tGCB[1].rI1				:=	MM2VIS.tGCB[1].rI_Nom * UINT_TO_REAL(tSlave[0].tLine[6].tIF.iData[1])/1000;
				VIS2MM.tGCB[1].rt1				:=	UINT_TO_REAL(tSlave[0].tLine[6].tIF.iData[2])/100;
				VIS2MM.tGCB[1].rI2				:=	MM2VIS.tGCB[1].rI_Nom * UINT_TO_REAL(tSlave[0].tLine[7].tIF.iData[1])/100;
				VIS2MM.tGCB[1].rt2				:=	UINT_TO_REAL(tSlave[0].tLine[7].tIF.iData[2])/100;	
				VIS2MM.tGCB[1].rI3				:=	MM2VIS.tGCB[1].rI_Nom * UINT_TO_REAL(tSlave[0].tLine[8].tIF.iData[1])/100;
				eState_GCB := _ABB_READ;
			END_IF
		_ABB_READ:
			(* Init *)
			IF bInit THEN
				tSlave[0].tLine[0].tIF.bExec	:=	TRUE;	
				tSlave[0].tLine[2].tIF.bExec	:=	TRUE;	
				tSlave[0].tLine[3].tIF.bExec	:=	TRUE;	
				tSlave[0].tLine[4].tIF.bExec	:=	TRUE;		
				tSlave[0].tLine[11].tIF.bExec	:=	TRUE;	
				tSlave[0].tLine[12].tIF.bExec	:=	TRUE;
			END_IF
			(* Wait *)
			xWAIT(IN:=1);
			(* Exit *)				
			IF 	NOT tSlave[0].tLine[0].tIF.bExec AND
				NOT tSlave[0].tLine[2].tIF.bExec AND
				NOT tSlave[0].tLine[3].tIF.bExec AND
				NOT tSlave[0].tLine[4].tIF.bExec AND	
				NOT tSlave[0].tLine[11].tIF.bExec AND
				NOT tSlave[0].tLine[12].tIF.bExec AND xWAIT.Q THEN
				MM2VIS.tGCB[1].rWear			:=	UINT_TO_REAL(tSlave[0].tLine[0].tIF.iData[0])/65000;	
				MM2VIS.tGCB[1].iNumOp			:=	UINT_TO_DINT(tSlave[0].tLine[0].tIF.iData[1]);
				MM2VIS.tGCB[1].iNumPT			:=	UINT_TO_DINT(tSlave[0].tLine[0].tIF.iData[3]);
				MM2VIS.tGCB[1].rI_Act_L1		:=	(UINT_TO_REAL(tSlave[0].tLine[2].tIF.iData[0])+UINT_TO_REAL(tSlave[0].tLine[2].tIF.iData[1])*65536)/10;
				MM2VIS.tGCB[1].rI_Act_L2		:=	(UINT_TO_REAL(tSlave[0].tLine[2].tIF.iData[2])+UINT_TO_REAL(tSlave[0].tLine[2].tIF.iData[3])*65536)/10;
				MM2VIS.tGCB[1].rI_Act_L3		:=	(UINT_TO_REAL(tSlave[0].tLine[2].tIF.iData[4])+UINT_TO_REAL(tSlave[0].tLine[2].tIF.iData[5])*65536)/10;	
				MM2VIS.tGCB[1].rU_Act			:=	UINT_TO_REAL(tSlave[0].tLine[3].tIF.iData[0])/10/3
												+	UINT_TO_REAL(tSlave[0].tLine[3].tIF.iData[1])/10/3
												+	UINT_TO_REAL(tSlave[0].tLine[3].tIF.iData[2])/10/3;
				MM2VIS.tGCB[1].rU_Nom			:=	UINT_TO_REAL(tSlave[0].tLine[4].tIF.iData[0]);
				MM2VIS.tGCB[1].bClosed			:=	tSlave[0].tLine[11].tIF.iData[0].0;
				MM2VIS.tGCB[1].bRacked			:=	tSlave[0].tLine[11].tIF.iData[0].1;
				MM2VIS.tGCB[1].bFail			:=	tSlave[0].tLine[11].tIF.iData[0].13
												OR	tSlave[0].tLine[11].tIF.iData[0].7
												OR NOT tSlave[0].tLine[11].tIF.iData[0].8
												OR	tSlave[0].tLine[11].tIF.iData[0].10
												OR	tSlave[0].tLine[11].tIF.iData[0].5;
				MM2VIS.tGCB[1].rI_Nom			:=	UINT_TO_REAL(tSlave[0].tLine[12].tIF.iData[0]);
				bABB_Remote						:= tSlave[0].tLine[11].tIF.iData[0].8;
				eState_GCB := _GCB_IDLE;			
			END_IF				
		_ABB_SAVE_OPEN:
			(* Init *)
			IF bInit THEN
				tSlave[0].tLine[13].tIF				:=	tIF_ABB_Open;
				MM2VIS.tGCB[1].rSave				:=	0.33;
			END_IF
			(* Wait *)
			xWAIT(IN:=1);
			(* Exit *)			
			IF NOT tSlave[0].tLine[13].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _ABB_SAVE_DATA;
			END_IF
		_ABB_SAVE_DATA:		
			(* Init *)
			IF bInit THEN																												//LOW	HIGH	STEP
				tSlave[0].tLine[14].tIF.iData[0]	:=	LIMIT(REAL_TO_UINT(VIS2MM.tGCB[1].rI1/MM2VIS.tGCB[1].rI_Nom*1000),400,1000);	//400	1000	1 
				tSlave[0].tLine[14].tIF.iData[1]	:=	LIMIT(REAL_TO_UINT(VIS2MM.tGCB[1].rt1),3,144)*100;								//300	14400	100 
				tSlave[0].tLine[9].tIF.iData[0]		:=	LIMIT(REAL_TO_UINT(VIS2MM.tGCB[1].rI2/MM2VIS.tGCB[1].rI_Nom*10),6,100)*10;		//60	1000	10 
				tSlave[0].tLine[9].tIF.iData[1]		:=	LIMIT(REAL_TO_UINT(VIS2MM.tGCB[1].rt2*100),5,80);								//5		80		1 
				tSlave[0].tLine[10].tIF.iData[0]	:=	LIMIT(REAL_TO_UINT(VIS2MM.tGCB[1].rI3/MM2VIS.tGCB[1].rI_Nom*10),15,150)*10;		//150	1500	10 
				tSlave[0].tLine[14].tIF.bExec		:=	TRUE;		
				tSlave[0].tLine[9].tIF.bExec		:=	TRUE;	
				tSlave[0].tLine[10].tIF.bExec		:=	TRUE;
				MM2VIS.tGCB[1].rSave				:=	0.66;
			END_IF
			(* Wait *)
			xWAIT(IN:=1);
			(* Exit *)
			IF NOT tSlave[0].tLine[14].tIF.bExec AND NOT tSlave[0].tLine[9].tIF.bExec AND NOT tSlave[0].tLine[10].tIF.bExec AND xWAIT.Q THEN		
				eState_GCB := _ABB_SAVE_CLOSE;	
			END_IF
		_ABB_SAVE_CLOSE:
			(* Init *)
			IF bInit THEN
				tSlave[0].tLine[13].tIF		:=	tIF_ABB_Close;
			END_IF
			(* Wait *)
			xWAIT(IN:=1);
			(* Exit *)
			IF NOT tSlave[0].tLine[13].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _ABB_LOAD;
				MM2VIS.tGCB[1].rSave				:=	1.00;
			END_IF		
		_SE_LOAD:
			(* Init Load *)
			IF bInit THEN
				VIS2MM.tGCB[1].rI_GenNom := Para.rI_GenNom[1];
				tSlave[1].tLine[4].tIF.bExec	:=	TRUE;	//to load I_Nom
				tSlave[1].tLine[6].tIF.bExec	:=	TRUE;
				tSlave[1].tLine[7].tIF.bExec	:=	TRUE;	
				tSlave[1].tLine[8].tIF.bExec	:=	TRUE;
			END_IF
			(* Wait Load *)
			xWAIT(IN:=1);
			MM2VIS.tGCB[1].rLoad	:=	BOOL_TO_REAL(NOT tSlave[1].tLine[4].tIF.bExec)/4
									+	BOOL_TO_REAL(NOT tSlave[1].tLine[6].tIF.bExec)/4
									+	BOOL_TO_REAL(NOT tSlave[1].tLine[7].tIF.bExec)/4
									+	BOOL_TO_REAL(NOT tSlave[1].tLine[8].tIF.bExec)/4;
			(* Exit Load *)
			IF NOT tSlave[1].tLine[4].tIF.bExec AND NOT tSlave[1].tLine[6].tIF.bExec AND NOT tSlave[1].tLine[7].tIF.bExec AND NOT tSlave[1].tLine[8].tIF.bExec AND xWAIT.Q THEN
				MM2VIS.tGCB[1].rI_Nom	:=	UINT_TWO_REAL(tSlave[1].tLine[4].tIF.iData[2],tSlave[1].tLine[4].tIF.iData[3]);		
				VIS2MM.tGCB[1].rI1	:=	UINT_TWO_REAL(tSlave[1].tLine[6].tIF.iData[0],tSlave[1].tLine[6].tIF.iData[1]);
				VIS2MM.tGCB[1].rt1	:=	UINT_TWO_REAL(tSlave[1].tLine[6].tIF.iData[2],tSlave[1].tLine[6].tIF.iData[3]);	
				rFactor_Isd			:=	UINT_TWO_REAL(tSlave[1].tLine[7].tIF.iData[0],tSlave[1].tLine[7].tIF.iData[1]);
				VIS2MM.tGCB[1].rI2	:=	rFactor_Isd*VIS2MM.tGCB[1].rI1;
				VIS2MM.tGCB[1].rt2	:=	UINT_TWO_REAL(tSlave[1].tLine[7].tIF.iData[2],tSlave[1].tLine[7].tIF.iData[3]);		
				rFactor_Ii			:=	UINT_TWO_REAL(tSlave[1].tLine[8].tIF.iData[1],tSlave[1].tLine[8].tIF.iData[2]);
				VIS2MM.tGCB[1].rI3	:=	rFactor_Ii*MM2VIS.tGCB[1].rI_Nom;
				eState_GCB := _SE_READ;
			END_IF
		_SE_READ:
			(* Init Read *)
			IF bInit THEN
				tSlave[1].tLine[0].tIF.bExec	:=	TRUE;
				tSlave[1].tLine[1].tIF.bExec	:=	TRUE;	
				tSlave[1].tLine[2].tIF.bExec	:=	TRUE;	
				tSlave[1].tLine[3].tIF.bExec	:=	TRUE;	
				tSlave[1].tLine[4].tIF.bExec	:=	TRUE;	
				tSlave[1].tLine[5].tIF.bExec	:=	TRUE;
//				tSlave[1].tLine[9].tIF.bExec	:=	TRUE;		//falls SE racked in / out IO interface besitzt aktivieren
			END_IF
			(* Wait Read *)
			xWAIT(IN:=1);
			(* Exit Read *)
			IF 	NOT tSlave[1].tLine[0].tIF.bExec AND
				NOT tSlave[1].tLine[1].tIF.bExec AND
				NOT tSlave[1].tLine[2].tIF.bExec AND
				NOT tSlave[1].tLine[3].tIF.bExec AND
				NOT tSlave[1].tLine[4].tIF.bExec AND	
				NOT tSlave[1].tLine[5].tIF.bExec AND
				NOT tSlave[1].tLine[9].tIF.bExec AND xWAIT.Q THEN
				MM2VIS.tGCB[1].iNumOp			:=	UDINT_TO_DINT(UINT_TWO_UDINT(tSlave[1].tLine[0].tIF.iData[0],tSlave[1].tLine[0].tIF.iData[1]));
				MM2VIS.tGCB[1].iNumPT			:=	UDINT_TO_DINT(UINT_TWO_UDINT(tSlave[1].tLine[0].tIF.iData[2],tSlave[1].tLine[0].tIF.iData[3]));
				MM2VIS.tGCB[1].rI_Act_L1		:=	UINT_TWO_REAL(tSlave[1].tLine[2].tIF.iData[0],tSlave[1].tLine[2].tIF.iData[1]);		
				MM2VIS.tGCB[1].rI_Act_L2		:=	UINT_TWO_REAL(tSlave[1].tLine[2].tIF.iData[2],tSlave[1].tLine[2].tIF.iData[3]);	
				MM2VIS.tGCB[1].rI_Act_L3		:=	UINT_TWO_REAL(tSlave[1].tLine[2].tIF.iData[4],tSlave[1].tLine[2].tIF.iData[5]);	
				MM2VIS.tGCB[1].rU_Act			:=	UINT_TWO_REAL(tSlave[1].tLine[3].tIF.iData[0],tSlave[1].tLine[3].tIF.iData[1]);
				MM2VIS.tGCB[1].rU_Nom			:=	UINT_TWO_REAL(tSlave[1].tLine[4].tIF.iData[0],tSlave[1].tLine[4].tIF.iData[1]);
				MM2VIS.tGCB[1].rI_Nom			:=	UINT_TWO_REAL(tSlave[1].tLine[4].tIF.iData[2],tSlave[1].tLine[4].tIF.iData[3]);			
				MM2VIS.tGCB[1].rWear			:=	UINT_TWO_REAL(tSlave[1].tLine[5].tIF.iData[0],tSlave[1].tLine[5].tIF.iData[1]);
				MM2VIS.tGCB[1].bClosed			:=	tSlave[1].tLine[1].tIF.iData[1].0;
				MM2VIS.tGCB[1].bRacked			:=	tSlave[1].tLine[9].tIF.iData[0].9;
				eState_GCB := _GCB_IDLE;					
			END_IF
		_SE_SAVE_CHECK:												 //Check if no session is open
			(* Init Check *)
			IF bInit THEN
				tSlave[1].tLine[11].tIF.bExec		:=	TRUE;
				MM2VIS.tGCB[1].rSave				:=	0.1;
			END_IF
			(* Wait Check *)
			xWAIT(IN:=1);
			(* Exit Check *)
			IF NOT tSlave[1].tLine[11].tIF.bExec AND xWAIT.Q THEN
				IF (tSlave[1].tLine[11].tIF.iData[3] <> 0 OR tSlave[1].tLine[11].tIF.iData[4] <> 0) AND tSlave[1].tLine[11].tIF.iData[0]<>1933 THEN
					iSessionKey0 := tSlave[1].tLine[11].tIF.iData[3];
					iSessionKey1 := tSlave[1].tLine[11].tIF.iData[4];
					eState_GCB := _SE_SAVE_CLOSE_OLD;
				ELSE
					eState_GCB := _SE_SAVE_OPEN;							
				END_IF
			END_IF
		_SE_SAVE_CLOSE_OLD:								//close old session
			(* Init Close *)
			IF bInit THEN
				tSlave[1].tLine[10].tIF 			:=	tIF_Session_Close;
				tSlave[1].tLine[10].tIF.iData[6]	:=	iSessionKey0;
				tSlave[1].tLine[10].tIF.iData[7]	:=	iSessionKey1;
				MM2VIS.tGCB[1].rSave				:=	0.2;
			END_IF
			(* Wait Close *)
			xWAIT(IN:=1);
			(* Exit Close *)
			IF NOT tSlave[1].tLine[10].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _SE_SAVE_OPEN;
			END_IF
		_SE_SAVE_OPEN:										//open new session
			(* Init Open *)
			IF bInit THEN
				tSlave[1].tLine[10].tIF 			:=	tIF_Session_Open;
				MM2VIS.tGCB[1].rSave				:=	0.3;
			END_IF
			(* Wait Open *)
			xWAIT(IN:=1);
			(* Exit Open *)
			IF NOT tSlave[1].tLine[10].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _SE_SAVE_ID;
			END_IF
		_SE_SAVE_ID:										//ask for new session ID
			(* Init ID *)
			IF bInit THEN
				tSlave[1].tLine[11].tIF.bExec		:=	TRUE;
				MM2VIS.tGCB[1].rSave				:=	0.4;
			END_IF
			(* Wait ID *)
			xWAIT(IN:=1);
			(* Exit ID *)		
			IF NOT tSlave[1].tLine[11].tIF.bExec THEN
				IF tSlave[1].tLine[11].tIF.iData[1] = 0 AND tSlave[1].tLine[11].tIF.iData[2] = 4 AND xWAIT.Q THEN
					iSessionKey0 := tSlave[1].tLine[11].tIF.iData[3];
					iSessionKey1 := tSlave[1].tLine[11].tIF.iData[4];
					eState_GCB := _SE_SAVE_DATA1;
				ELSE
					iSessionKey0 := tSlave[1].tLine[11].tIF.iData[3];
					iSessionKey1 := tSlave[1].tLine[11].tIF.iData[4];
					eState_GCB := _SE_SAVE_CLOSE_OLD;						
				END_IF
			END_IF
		_SE_SAVE_DATA1:											//change Dataset 1
			(* Init Data1 *)
			IF bInit THEN			
				tSlave[1].tLine[10].tIF				:=	tIF_Session_Change1;
				tSlave[1].tLine[10].tIF.iData[6]	:=	iSessionKey0;
				tSlave[1].tLine[10].tIF.iData[7]	:=	iSessionKey1;
				rTemp := STEP(VIS2MM.tGCB[1].rI1,0.1);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[10]),ADR(rTemp)+2,2);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[11]),ADR(rTemp),2);
				rTemp := LIMIT(STEP(VIS2MM.tGCB[1].rt1,0.5),0.5,24.0);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[12]),ADR(rTemp)+2,2);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[13]),ADR(rTemp),2);
				MM2VIS.tGCB[1].rSave				:=	0.5;
			END_IF
			(* Wait Data1 *)
			xWAIT(IN:=1);
			(* Exit Data1 *)
			IF NOT tSlave[1].tLine[10].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _SE_SAVE_DATA2;
			END_IF
		_SE_SAVE_DATA2:											//change Dataset 2
			(* Init Data2 *)
			IF bInit THEN
				tSlave[1].tLine[10].tIF				:=	tIF_Session_Change2;
				tSlave[1].tLine[10].tIF.iData[6]	:=	iSessionKey0;
				tSlave[1].tLine[10].tIF.iData[7]	:=	iSessionKey1;
				rTemp := LIMIT(STEP(VIS2MM.tGCB[1].rI2/VIS2MM.tGCB[1].rI1,0.1),1.5,10.0);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[10]),ADR(rTemp)+2,2);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[11]),ADR(rTemp),2);
				rTemp := LIMIT(STEP(VIS2MM.tGCB[1].rt2,0.1),0.0,0.4);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[12]),ADR(rTemp)+2,2);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[13]),ADR(rTemp),2);
				MM2VIS.tGCB[1].rSave				:=	0.6;
			END_IF
			(* Wait Data2 *)
			xWAIT(IN:=1);
			(* Exit Data2 *)
			IF NOT tSlave[1].tLine[10].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _SE_SAVE_DATA3;
			END_IF
		_SE_SAVE_DATA3:										//change Dataset 3
			(* Init Data3 *)
			IF bInit THEN
				tSlave[1].tLine[10].tIF				:=	tIF_Session_Change3;
				tSlave[1].tLine[10].tIF.iData[6]	:=	iSessionKey0;
				tSlave[1].tLine[10].tIF.iData[7]	:=	iSessionKey1;
				rTemp := LIMIT(STEP(VIS2MM.tGCB[1].rI3/MM2VIS.tGCB[1].rI_Nom,0.1),2.0,15.0);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[9]),ADR(rTemp)+2,2);
				brsmemcpy(ADR(tSlave[1].tLine[10].tIF.iData[10]),ADR(rTemp),2);
				MM2VIS.tGCB[1].rSave				:=	0.7;
			END_IF
			(* Wait Data3 *)
			xWAIT(IN:=1);
			(* Exit Data3 *)
			IF NOT tSlave[1].tLine[10].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _SE_SAVE_APPLY;
			END_IF
		_SE_SAVE_APPLY:										//apply changes
			(* Init Apply *)
			IF bInit THEN
				tSlave[1].tLine[10].tIF				:=	tIF_Session_Apply;
				tSlave[1].tLine[10].tIF.iData[6]	:=	iSessionKey0;
				tSlave[1].tLine[10].tIF.iData[7]	:=	iSessionKey1;
				MM2VIS.tGCB[1].rSave				:=	0.8;
			END_IF
			(* Wait Apply *)
			xWAIT(IN:=1);
			(* Exit Apply *)
			IF NOT tSlave[1].tLine[10].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _SE_SAVE_CLOSE;
			END_IF
		_SE_SAVE_CLOSE:										//close session
			(* Init Close *)
			IF bInit THEN
				tSlave[1].tLine[10].tIF 			:=	tIF_Session_Close;
				tSlave[1].tLine[10].tIF.iData[6]	:=	iSessionKey0;
				tSlave[1].tLine[10].tIF.iData[7]	:=	iSessionKey1;
				MM2VIS.tGCB[1].rSave				:=	0.9;
			END_IF
			(* Wait Close *)
			xWAIT(IN:=1);
			(* Exit Close *)
			IF NOT tSlave[1].tLine[10].tIF.bExec AND xWAIT.Q THEN
				eState_GCB := _SE_SAVE_CLOSE_CHECK;
			END_IF
		_SE_SAVE_CLOSE_CHECK:								 //Check if session is closed
			(* Init Check *)
			IF bInit THEN
				tSlave[1].tLine[11].tIF.bExec		:=	TRUE;
			END_IF
			(* Wait Check *)
			xWAIT(IN:=25);
			(* Exit Check *)
			IF NOT tSlave[1].tLine[11].tIF.bExec AND xWAIT.Q THEN
				IF tSlave[1].tLine[11].tIF.iData[0] = 1933 THEN
					eState_GCB := _SE_LOAD;
					MM2VIS.tGCB[1].rSave				:=	1.0;
				END_IF
			END_IF
		_GCB_CLEAR:
			MM2VIS.tGCB[1].iNumOp		:=	0;
			MM2VIS.tGCB[1].iNumPT		:=	0;
			MM2VIS.tGCB[1].rI_Act_L1	:=	0;	
			MM2VIS.tGCB[1].rI_Act_L2	:=	0;
			MM2VIS.tGCB[1].rI_Act_L3	:=	0;
			MM2VIS.tGCB[1].rU_Act		:=	0;
			MM2VIS.tGCB[1].rU_Nom		:=	0;
			MM2VIS.tGCB[1].rI_Nom		:=	0;		
			MM2VIS.tGCB[1].rWear		:=	0;
			MM2VIS.tGCB[1].bClosed		:=	0;
			MM2VIS.tGCB[1].bRacked		:=	0;
			MM2VIS.tGCB[1].bFail		:=	0;
			VIS2MM.tGCB[1].rI1			:=	0;
			VIS2MM.tGCB[1].rt1			:=	0;
			VIS2MM.tGCB[1].rI2			:=	0;
			VIS2MM.tGCB[1].rt2			:=	0;	
			VIS2MM.tGCB[1].rI3			:=	0;

			IF bSE THEN		eState_GCB	:=	_SE_LOAD;
			ELSIF bABB THEN	eState_GCB	:=	_ABB_LOAD; 
			ELSE			eState_GCB	:=	_GCB_IDLE;
			END_IF				
		_GCB_IDLE:
			(* Wait Idle *)
			xWAIT(IN:=100);
			bABB	:=	MM2VIS.tGCB[1].iType = 1;
			bSE		:=	MM2VIS.tGCB[1].iType = 2;
			IF xWAIT.CNT > 30 THEN
				MM2VIS.tGCB[1].rSave	:= 0.0;
				MM2VIS.tGCB[1].rLoad	:= 0.0;
			END_IF
			(* Exit Idle *)
			IF bClear THEN
				bClear		:=	FALSE;
				eState_GCB	:=	_GCB_CLEAR;			
			ELSIF VIS2MM.tGCB[1].bCalc THEN
				VIS2MM.tGCB[1].bCalc := FALSE;
				eState_GCB := _GCB_CALC;
			ELSIF VIS2MM.tGCB[1].bSave THEN
				VIS2MM.tGCB[1].bSave := FALSE;
				IF xOpMode.Stop THEN
					IF bSE THEN		eState_GCB := _SE_SAVE_CHECK; END_IF
					IF bABB AND bABB_Remote THEN	eState_GCB := _ABB_SAVE_OPEN; END_IF
				END_IF
			ELSIF VIS2MM.tGCB[1].bLoad THEN
				VIS2MM.tGCB[1].bLoad := FALSE;
				IF bSE THEN		eState_GCB := _SE_LOAD; END_IF
				IF bABB THEN	eState_GCB := _ABB_LOAD; END_IF
			ELSIF xWAIT.Q THEN
				IF bSE THEN		eState_GCB := _SE_READ; END_IF
				IF bABB THEN	eState_GCB := _ABB_READ; END_IF

			END_IF
	END_CASE
	
	(** 4: State Machine Helper *)	
	IF eState_GCB <> eState_GCB_Old THEN
		bInit := TRUE;						//trigger init routine if state changed
		xWAIT(IN:=0);						//reset cyclic timer for new state
		xTIMEOUT(IN:=0);					//reset time out counter for new state;
		eState_GCB_Old := eState_GCB;
	ELSE
		bInit := FALSE;						//disable init routine after first run trough
		xTIMEOUT(IN:=1000);
		IF xTIMEOUT.Q THEN
			eState_GCB_TO	:=	eState_GCB;
			eState_GCB		:=	_GCB_IDLE;
		END_IF
	END_IF
	IF MM2VIS.tGCB[1].iType <> iType_Old THEN
		iType_Old	:=	MM2VIS.tGCB[1].iType;
		bClear	:=	TRUE;
	END_IF
	
	(** 5: Error Diagnostics *)
	IF bABB THEN
		MM2VIS.tGCB[1].iError	:=	xMBDO_Master[0].iLog[0];
	ELSIF bSE THEN
		MM2VIS.tGCB[1].iError	:=	xMBDO_Master[0].iLog[1];		
	END_IF
	memcpy(ADR(MM2VIS.tGCB[1].iState),ADR(eState_GCB),2);
	
	(** 6: Operating Messages and Warnings *)
	(** 6.1: B9085 Parameters saved to the GCB *)
	xTOF_ParaSaved_5s.IN	:=	(bSE AND tSlave[1].tLine[11].tIF.iData[0] = 1933 AND eState_GCB_Old = _SE_SAVE_CLOSE_CHECK)
							OR	(bABB AND tSlave[0].tLine[13].tIF.iStatus = 0 AND eState_GCB_Old = _ABB_SAVE_CLOSE);
	xTOF_ParaSaved_5s.PT	:=	T#5s;
	xTOF_ParaSaved_5s();
	bB9085_GCB_ParaSaved := xTOF_ParaSaved_5s.Q;
	(** 6.2: W9382 GCB contact wear over 80% *)
	IF EDGEPOS(MM2VIS.tGCB[1].rWear >= 0.80) THEN
		bW9382_GCB_Wear80	:=	TRUE;
	END_IF
	IF IN_SY.tAB2SY.bResetWarning THEN
		bW9382_GCB_Wear80	:=	FALSE;
	END_IF
	(** 6.3: W9383 GCB contact wear over 95% *)
	bW9383_GCB_Wear95	:=	MM2VIS.tGCB[1].rWear >= 0.95;
	
END_PROGRAM


