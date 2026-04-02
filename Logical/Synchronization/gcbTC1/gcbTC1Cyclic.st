(*******************************************************************************
gcbTC1 		generator circuit breaker monitoring

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V4.09.0	11.09.2019	lettenb.	new
		30.01.2020	lettenb.	bResetWarning from general_SY, added, JMAP cleanup
		11.04.2020	lettenb.	current limit 10 -> 2% I_GenNom, testbench validation
V4.11.0 05.11.2021	lettenb.	hold last value with reset, bugfix
V4.14.0 22.11.2024	Fahringer	Use generator current before GCB closure to check 2% change (2024-238)
								GCB closing time monitoring for more than 40ms (2024-238)
		22.11.2024	Farre		bMMD_SyncDO only when used for GCB (2024-238)

Instructions FOR use:
--------------------
task have to be operated in 1ms task class

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

IF Para.bMMDSynch_Act[1] AND IN_SY.tPB2MM.bParaSetupOk THEN

	(* sy-pulse = start measurement *)
	xTP_MMD_SynchDO(IN:= IN_SY.bMMD_SynchDO_TC1[1], PT:= REAL_TO_TIME(rGCB_On_TimeMax)); 
		
	(* read phase current and GCB On status when Synch pulse is detected *)
	IF EDGEPOS(IN_SY.bMMD_SynchDO_TC1[1]) THEN
		rI_L1_bSync 	:= 	IN_SY.tI_L1_TC1[1].Unfilt;
		rI_L2_bSync 	:= 	IN_SY.tI_L2_TC1[1].Unfilt;
		rI_L3_bSync 	:= 	IN_SY.tI_L3_TC1[1].Unfilt;
		bGCB_On_bSync	:=	IN_SY.tGCB_On.Di;		
	END_IF;
	
	(* start counter when synch pulse is detected *)
	IF xTP_MMD_SynchDO.Q THEN rCnt := rCnt + 1;
	                     ELSE rCnt := 0;
	END_IF;
	IF rCnt > 100000 THEN rCnt := 0;
	END_IF;

	(* gcb closed detection *)
	IF xTP_MMD_SynchDO.Q AND NOT bGCB_On_bSync THEN 
		IF 	(ABS(IN_SY.tI_L1_TC1[1].Unfilt - rI_L1_bSync) > (Para.rI_GenNom[1] * 0.02)) OR
		 	(ABS(IN_SY.tI_L2_TC1[1].Unfilt - rI_L2_bSync) > (Para.rI_GenNom[1] * 0.02)) OR
			(ABS(IN_SY.tI_L3_TC1[1].Unfilt - rI_L3_bSync) > (Para.rI_GenNom[1] * 0.02))
		THEN
			bGCB_OnI := TRUE; (* hold status *)
		END_IF;
	ELSE
		bGCB_OnI := FALSE;
	END_IF;

	xR_TRIG_GCB_OnI(CLK:= (rCnt >=40) AND bGCB_OnI);
	xR_TRIG_Timeout(CLK:= (rCnt = rGCB_On_TimeMax) AND NOT bGCB_OnI);
	IF NOT bGCB_On_bSync AND (xR_TRIG_GCB_OnI.Q OR xR_TRIG_Timeout.Q) THEN
		rGCBctOld := rGCBct;
		rGCBct    := rCnt; (* ms *)
	END_IF;

	(* failure detection *)
	IF ((ABS(Para.rTi_SynchSwitchDel[1] - rGCBct   ) >= 20) AND (rCnt >=40))
		AND(ABS(Para.rTi_SynchSwitchDel[1] - rGCBctOld) >= 20)	THEN bGCBctd := TRUE; (* GCB closing time deviation *)
	END_IF;

	(* reset *)
	IF bGCBctd AND bResetWarning THEN 
		bGCBctd   := FALSE;
		rGCBctOld := Para.rTi_SynchSwitchDel[1];
	END_IF;

	(* MM2VIS *)
	MM2VIS.tiGCB_ClosTime    := REAL_TO_TIME(rGCBct);
	MM2VIS.tiGCB_ClosTimeOld := REAL_TO_TIME(rGCBctOld);

ELSE

	bGCBctd := FALSE;	
	rGCBctOld := Para.rTi_SynchSwitchDel[1];
	rGCBct    := Para.rTi_SynchSwitchDel[1];

	(* MM2VIS *)
	MM2VIS.tiGCB_ClosTime    := REAL_TO_TIME(rGCBct);
	MM2VIS.tiGCB_ClosTimeOld := REAL_TO_TIME(rGCBctOld);

END_IF;

END_PROGRAM
