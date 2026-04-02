(*******************************************************************************
EC_Seq 			emergency cooler - sequence for 16 stages

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.1 	31-01-2003	Thaler		generated
     	21-03-2003	Thaler		last modification	
V1.81	16-06-2003	LH			bits für Anzeige auf VISU 		
V1.82	16-09-2003	LH			Variable für XT-Anzeige
V2.07.1a31-03-2005	LH			Variable für Freigabe XT-Anzeige
V2.30	24-01-2008	LH			Variable für Freigabe XT-Anzeige gelöscht (Parameter!)
V3.99.0	21.02.2013	lettenb.	kv_seq -> EC_Seq renamed
V4.03.0 07.08.2015  Denk		Manual operating auxiliaries control functionality added

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC	
	
	(* Manual operating auxiliaries control - Handbedienebene *)
	K_Var := LIMIT(0, Para.iEC_OpMode, 3);
	FOR i:= 1 TO Para.iEC_NumStages BY 1 DO	
		IF 	(K_Var > 0 AND K_Var < 4) THEN
			K_ST1_ManAuxCtr  := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST2_ManAuxCtr  :=	IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST3_ManAuxCtr  :=	IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST4_ManAuxCtr  := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST5_ManAuxCtr  := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST6_ManAuxCtr  := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST7_ManAuxCtr  := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST8_ManAuxCtr  := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST9_ManAuxCtr  := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST10_ManAuxCtr := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST11_ManAuxCtr := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST12_ManAuxCtr := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST13_ManAuxCtr := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST14_ManAuxCtr := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST15_ManAuxCtr := IN_HC.tManAuxCtr.bEC_DemFan;
			K_ST16_ManAuxCtr := IN_HC.tManAuxCtr.bEC_DemFan;
			
			IF IN_HC.tManAuxCtr.bEC_DemFan = TRUE THEN
				iSumEC_Stages_ManAuxCtr := Para.iEC_NumStages;
			ELSE
				iSumEC_Stages_ManAuxCtr := 0;
			END_IF;				
		END_IF;
	END_FOR;
	
	(* connection of in-/outputs *)
	EN[1]  := K_ST_1;
	EN[2]  := K_ST_2;
	EN[3]  := K_ST_3;
	EN[4]  := K_ST_4;
	EN[5]  := K_ST_5;
	EN[6]  := K_ST_6;
	EN[7]  := K_ST_7;
	EN[8]  := K_ST_8;
	EN[9]  := K_ST_9;
	EN[10] := K_ST_10;
	EN[11] := K_ST_11;
	EN[12] := K_ST_12;
	EN[13] := K_ST_13;
	EN[14] := K_ST_14;
	EN[15] := K_ST_15;
	EN[16] := K_ST_16;
	
	IN[1]  := K_ST1;
	IN[2]  := K_ST2;
	IN[3]  := K_ST3;
	IN[4]  := K_ST4;
	IN[5]  := K_ST5;
	IN[6]  := K_ST6;
	IN[7]  := K_ST7;
	IN[8]  := K_ST8;
	IN[9]  := K_ST9;
	IN[10] := K_ST10;
	IN[11] := K_ST11;
	IN[12] := K_ST12;
	IN[13] := K_ST13;
	IN[14] := K_ST14;
	IN[15] := K_ST15;
	IN[16] := K_ST16;	
									  			
	OUT_HC.tEC_DemFan1.Do := Q[1] OR K_ST1_ManAuxCtr;
	OUT_HC.tEC_DemFan2.Do := Q[2] OR K_ST2_ManAuxCtr;
	OUT_HC.tEC_DemFan3.Do := Q[3] OR K_ST3_ManAuxCtr;
	OUT_HC.tEC_DemFan4.Do := Q[4] OR K_ST4_ManAuxCtr;
	OUT_HC.tEC_DemFan5.Do := Q[5] OR K_ST5_ManAuxCtr;
	OUT_HC.tEC_DemFan6.Do := Q[6] OR K_ST6_ManAuxCtr;
	OUT_HC.tEC_DemFan7.Do := Q[7] OR K_ST7_ManAuxCtr;
	OUT_HC.tEC_DemFan8.Do := Q[8] OR K_ST8_ManAuxCtr;
	OUT_HC.tEC_DemFan9.Do := Q[9] OR K_ST9_ManAuxCtr;
	OUT_HC.tEC_DemFan10.Do := Q[10] OR K_ST10_ManAuxCtr;
	OUT_HC.tEC_DemFan11.Do := Q[11] OR K_ST11_ManAuxCtr;
	OUT_HC.tEC_DemFan12.Do := Q[12] OR K_ST12_ManAuxCtr;
	OUT_HC.tEC_DemFan13.Do := Q[13] OR K_ST13_ManAuxCtr;
	OUT_HC.tEC_DemFan14.Do := Q[14] OR K_ST14_ManAuxCtr;
	OUT_HC.tEC_DemFan15.Do := Q[15] OR K_ST15_ManAuxCtr;
	OUT_HC.tEC_DemFan16.Do := Q[16] OR K_ST16_ManAuxCtr;
	
	(******************************************************************************)
	
	and_16b   (ADR(EN), ADR(Q), ADR(Q));	(* switch off "Q" if "EN" is FALSE:	"Q" := "EN" AND "Q" *)
	andnt_16b (ADR(EN), ADR(Q), ADR(RDY));	(* enabled outputs with status FALSE: "RDY" := "EN" AND NOT "Q" *)

	
	(* SEQU_C = stage number for stage numbers > iPriorityStage *)
	FOR i := (iPriorityStage + 1) TO 16 BY 1 DO
		SEQU_C[i] := i;
	END_FOR;
	
	(* SEQU_C = stage number + 100 for stage numbers <= iPriorityStage *)
	FOR i := iPriorityStage TO 1 BY -1 DO
		 SEQU_C[i] := i + 100;
	END_FOR;
	
	min_16di (ADR(RDY), ADR(SEQU_C), ADR(NEXT_ON));	(* stage for next on  as BOOL *)
	min_16di (ADR(Q), ADR(SEQU_C), ADR(NEXT_OFF)); 	(* stage for next off as BOOL *)
	
	iNextOn   := max_i_16b (ADR(NEXT_ON)); 			(* stage for next on  as INT  *)
	iNextOff  := max_i_16b (ADR(NEXT_OFF));			(* stage for next off as INT  *)
	
	iIN := max_i_16b (ADR(IN));						(* input : number of stages as INT *)
	iQ  := sum_16b (ADR(Q));   						(* output: number of stages as INT *)
	
	IF (iIN > iQ) THEN
		Q[iNextOn] := TRUE;
		iPriorityStage := iNextOn;
	END_IF;
	
	IF (iIN < iQ) THEN
		Q[iNextOff] := FALSE;
	END_IF;
	
	(******************************************************************************)
	
	(* bits for visu *)
	summe := 0;
	FOR i:= 1 TO 16 BY 1 DO
		summe := summe + Q[i];
	END_FOR;

	K_byte1	:= FALSE;
	K_byte2	:= FALSE;

	K_bit10	:= FALSE;
	K_bit11	:= FALSE;
	K_bit12	:= FALSE;

	K_bit20	:= FALSE;
	K_bit21	:= FALSE;
	K_bit22	:= FALSE;

	IF	(summe > 0) AND (summe < 9) THEN
		K_byte1	:= TRUE;
	END_IF;

	IF	((summe = 2) OR (summe = 4) OR (summe = 6) OR (summe = 8)) THEN
		K_bit10	:= TRUE;
	END_IF;

	IF	((summe = 3) OR (summe = 4) OR (summe = 7) OR (summe = 8)) THEN
		K_bit11	:= TRUE;
	END_IF;

	IF	((summe = 5) OR (summe = 6) OR (summe = 7) OR (summe = 8)) THEN
		K_bit12	:= TRUE;
	END_IF;

	IF	(summe > 8) THEN
		K_byte2	:= TRUE;
	END_IF;

	IF	((summe = 10) OR (summe = 12) OR (summe = 14) OR (summe = 16)) THEN
		K_bit20	:= TRUE;
	END_IF;

	IF	((summe = 11) OR (summe = 12) OR (summe = 15) OR (summe = 16)) THEN
		K_bit21	:= TRUE;
	END_IF;

	IF	((summe = 13) OR (summe = 14) OR (summe = 15) OR (summe = 16)) THEN
		K_bit22	:= TRUE;
	END_IF;
	
	IF iSumEC_Stages_ManAuxCtr > 0 THEN				
		iSumEC_Stages := iSumEC_Stages_ManAuxCtr; 	(* Manual operating auxiliaries control - Handbedienebene to vis *)
	ELSE
		iSumEC_Stages := summe;						(* to vis *)
	END_IF;	
	
END_PROGRAM
