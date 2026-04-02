(*******************************************************************************
ChC_Seq			charge cooler sequence for 16 stages 

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, OR reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------

History:
-------
V0.1 	31-01-2003	Thaler, generated
     	21-03-2003	Thaler, last modification	
V1.82	06-10-2003	LH, bits für Anzeige auf VISU, 
						Variable für XT-Anzeige
V2.071a	31-03-2005	LH, Variable für Freigabe XT-Anzeige
V2.30	24-01-2008	LH, Variable für Freigabe XT-Anzeige gelöscht (Parameter!)
V3.99.0	21.02.2013	lettenb.	gkv_seq -> ChC_Seq renamed
V4.03.0 07.08.2015  Denk		Manual operating auxiliaries control functionality added
V4.07.0	09.08.2018	Schmid		2nd low temperature charge cooling circuit added

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC	

	GK_Var := INT_TO_USINT(LIMIT(0, Para.iChC_OpMode, 2));
	GK2_Var := INT_TO_USINT(LIMIT(0, Para.iChC2_OpMode, 22));

	(* Manual operating auxiliaries control - Handbedienebene *)
	FOR i:= 1 TO Para.iChC_NumStages BY 1 DO	
		IF 	(GK_Var < 3) THEN
			GK_ST1_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST2_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST3_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST4_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST5_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST6_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST7_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST8_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST9_ManAuxCtr:=  IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST10_ManAuxCtr:= IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST11_ManAuxCtr:= IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST12_ManAuxCtr:= IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST13_ManAuxCtr:= IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST14_ManAuxCtr:= IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST15_ManAuxCtr:= IN_HC.tManAuxCtr.bChC_DemFan;
			GK_ST16_ManAuxCtr:= IN_HC.tManAuxCtr.bChC_DemFan;
			
			IF IN_HC.tManAuxCtr.bChC_DemFan = TRUE THEN
				iSumChC_Stages_ManAuxCtr := Para.iChC_NumStages;
			ELSE
				iSumChC_Stages_ManAuxCtr := 0;
			END_IF;				
		END_IF;
	END_FOR;
	
	(* connection of in-/outputs *)
	EN[1]  := GK_ST_1;
	EN[2]  := GK_ST_2;
	EN[3]  := GK_ST_3;
	EN[4]  := GK_ST_4;
	EN[5]  := GK_ST_5;
	EN[6]  := GK_ST_6;
	EN[7]  := GK_ST_7;
	EN[8]  := GK_ST_8;
	EN[9]  := GK_ST_9;
	EN[10] := GK_ST_10;
	EN[11] := GK_ST_11;
	EN[12] := GK_ST_12;
	EN[13] := GK_ST_13;
	EN[14] := GK_ST_14;
	EN[15] := GK_ST_15;
	EN[16] := GK_ST_16;
	
	IN[1]  := GK_ST1;
	IN[2]  := GK_ST2;
	IN[3]  := GK_ST3;
	IN[4]  := GK_ST4;
	IN[5]  := GK_ST5;
	IN[6]  := GK_ST6;
	IN[7]  := GK_ST7;
	IN[8]  := GK_ST8;
	IN[9]  := GK_ST9;
	IN[10] := GK_ST10;
	IN[11] := GK_ST11;
	IN[12] := GK_ST12;
	IN[13] := GK_ST13;
	IN[14] := GK_ST14;
	IN[15] := GK_ST15;
	IN[16] := GK_ST16;

	(* Para.iChC2_OpMode = 11, 12:	combi cooler for LT cooling water circuits
	   -> activate cooler stage IF request from one OF the circuits
	   -> deactivate cooler stage only IF request from both circuits *)
	IF Para.bAuxChC2_Visible AND GK2_Var/10 = 1 THEN
		IN[1]  := IN[1] OR GK2_ST1;
		IN[2]  := IN[2] OR GK2_ST2;
		IN[3]  := IN[3] OR GK2_ST3;
		IN[4]  := IN[4] OR GK2_ST4;
		IN[5]  := IN[5] OR GK2_ST5;
		IN[6]  := IN[6] OR GK2_ST6;
		IN[7]  := IN[7] OR GK2_ST7;
		IN[8]  := IN[8] OR GK2_ST8;
		IN[9]  := IN[9] OR GK2_ST9;
		IN[10] := IN[10] OR GK2_ST10;
		IN[11] := IN[11] OR GK2_ST11;
		IN[12] := IN[12] OR GK2_ST12;
		IN[13] := IN[13] OR GK2_ST13;
		IN[14] := IN[14] OR GK2_ST14;
		IN[15] := IN[15] OR GK2_ST15;
		IN[16] := IN[16] OR GK2_ST16;
	END_IF;
	
	OUT_HC.tChC_DemFan1.Do := Q[1] OR GK_ST1_ManAuxCtr;
	OUT_HC.tChC_DemFan2.Do := Q[2] OR GK_ST2_ManAuxCtr;
	OUT_HC.tChC_DemFan3.Do := Q[3] OR GK_ST3_ManAuxCtr;
	OUT_HC.tChC_DemFan4.Do := Q[4] OR GK_ST4_ManAuxCtr;
	OUT_HC.tChC_DemFan5.Do := Q[5] OR GK_ST5_ManAuxCtr;
	OUT_HC.tChC_DemFan6.Do := Q[6] OR GK_ST6_ManAuxCtr;
	OUT_HC.tChC_DemFan7.Do := Q[7] OR GK_ST7_ManAuxCtr;
	OUT_HC.tChC_DemFan8.Do := Q[8] OR GK_ST8_ManAuxCtr;
	OUT_HC.tChC_DemFan9.Do := Q[9] OR GK_ST9_ManAuxCtr;
	OUT_HC.tChC_DemFan10.Do := Q[10] OR GK_ST10_ManAuxCtr;
	OUT_HC.tChC_DemFan11.Do := Q[11] OR GK_ST11_ManAuxCtr;
	OUT_HC.tChC_DemFan12.Do := Q[12] OR GK_ST12_ManAuxCtr;
	OUT_HC.tChC_DemFan13.Do := Q[13] OR GK_ST13_ManAuxCtr;
	OUT_HC.tChC_DemFan14.Do := Q[14] OR GK_ST14_ManAuxCtr;
	OUT_HC.tChC_DemFan15.Do := Q[15] OR GK_ST15_ManAuxCtr;
	OUT_HC.tChC_DemFan16.Do := Q[16] OR GK_ST16_ManAuxCtr;
	
	(******************************************************************************)
	
	and_16b (ADR(EN), ADR(Q), ADR(Q));		(* switch off "Q" if "EN" is FALSE:   "Q" := "EN" AND "Q" *)
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
	
	
	(* bits für Anzeige auf VISU *)
	
	summe := 0;
	FOR i:= 1 TO 16 BY 1 DO
		summe := summe + Q[i];
	END_FOR;

	GK_byte1 := FALSE;
	GK_byte2 := FALSE;

	GK_bit10 := FALSE;
	GK_bit11 := FALSE;
	GK_bit12 := FALSE;

	GK_bit20 := FALSE;
	GK_bit21 := FALSE;
	GK_bit22 := FALSE;	
	
	IF	(summe > 0) AND (summe < 9) THEN
		GK_byte1 := TRUE;
	END_IF;

	IF	((summe = 2) OR (summe = 4) OR (summe = 6) OR (summe = 8)) THEN 
		GK_bit10 := TRUE;
	END_IF;

	IF	((summe = 3) OR (summe = 4) OR (summe = 7) OR (summe = 8)) THEN
		GK_bit11 := TRUE;
	END_IF;

	IF	((summe = 5) OR (summe = 6) OR (summe = 7) OR (summe = 8)) THEN
		GK_bit12 := TRUE;
	END_IF;

	IF	(summe > 8) THEN
		GK_byte2 := TRUE;
	END_IF;

	IF	((summe = 10) OR (summe = 12) OR (summe = 14) OR (summe = 16)) THEN
		GK_bit20 := TRUE;
	END_IF;

	IF	((summe = 11) OR (summe = 12) OR (summe = 15) OR (summe = 16)) THEN
		GK_bit21 := TRUE;
	END_IF;

	IF	((summe = 13) OR (summe = 14) OR (summe = 15) OR (summe = 16)) THEN
		GK_bit22 := TRUE;
	END_IF;
	
	IF iSumChC_Stages_ManAuxCtr > 0 THEN				
		iSumChC_Stages := iSumChC_Stages_ManAuxCtr; 	(* Manual operating auxiliaries control - Handbedienebene to vis *)
	ELSE
		iSumChC_Stages := summe;						(* to vis *)
	END_IF;


	(******************************************************************************)
	(* charge cooler 2 stage sequence control 
	   Para.iChC2_OpMode = 21, 22:	2 separate LT charge cooling water circuits, 2 coolers
									-> independent cooler stage control *)
	IF GK2_Var > 20 AND Para.bAuxChC2_Visible THEN
		(* Manual operating auxiliaries control - Handbedienebene *)
		GK2_ST1_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST2_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST3_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST4_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST5_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST6_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST7_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST8_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST9_ManAuxCtr	:=  IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST10_ManAuxCtr	:=	IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST11_ManAuxCtr	:=	IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST12_ManAuxCtr	:=	IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST13_ManAuxCtr	:=	IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST14_ManAuxCtr	:=	IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST15_ManAuxCtr	:=	IN_HC.tManAuxCtr.bChC2_DemFan;
		GK2_ST16_ManAuxCtr	:=	IN_HC.tManAuxCtr.bChC2_DemFan;
			
		IF IN_HC.tManAuxCtr.bChC2_DemFan THEN
			iSumChC2_Stages_ManAuxCtr := Para.iChC2_NumStages;
		ELSE
			iSumChC2_Stages_ManAuxCtr := 0;
		END_IF;				
	
		
		(* connection of in-/outputs *)
		EN2[1]  := GK2_ST_1;
		EN2[2]  := GK2_ST_2;
		EN2[3]  := GK2_ST_3;
		EN2[4]  := GK2_ST_4;
		EN2[5]  := GK2_ST_5;
		EN2[6]  := GK2_ST_6;
		EN2[7]  := GK2_ST_7;
		EN2[8]  := GK2_ST_8;
		EN2[9]  := GK2_ST_9;
		EN2[10] := GK2_ST_10;
		EN2[11] := GK2_ST_11;
		EN2[12] := GK2_ST_12;
		EN2[13] := GK2_ST_13;
		EN2[14] := GK2_ST_14;
		EN2[15] := GK2_ST_15;
		EN2[16] := GK2_ST_16;
		
		IN2[1]  := GK2_ST1;
		IN2[2]  := GK2_ST2;
		IN2[3]  := GK2_ST3;
		IN2[4]  := GK2_ST4;
		IN2[5]  := GK2_ST5;
		IN2[6]  := GK2_ST6;
		IN2[7]  := GK2_ST7;
		IN2[8]  := GK2_ST8;
		IN2[9]  := GK2_ST9;
		IN2[10] := GK2_ST10;
		IN2[11] := GK2_ST11;
		IN2[12] := GK2_ST12;
		IN2[13] := GK2_ST13;
		IN2[14] := GK2_ST14;
		IN2[15] := GK2_ST15;
		IN2[16] := GK2_ST16;
		
		OUT_HC.tChC2_DemFan1.Do		:= Q2[1]	OR GK2_ST1_ManAuxCtr;
		OUT_HC.tChC2_DemFan2.Do 	:= Q2[2]	OR GK2_ST2_ManAuxCtr;
		OUT_HC.tChC2_DemFan3.Do 	:= Q2[3]	OR GK2_ST3_ManAuxCtr;
		OUT_HC.tChC2_DemFan4.Do 	:= Q2[4]	OR GK2_ST4_ManAuxCtr;
		OUT_HC.tChC2_DemFan5.Do 	:= Q2[5]	OR GK2_ST5_ManAuxCtr;
		OUT_HC.tChC2_DemFan6.Do 	:= Q2[6]	OR GK2_ST6_ManAuxCtr;
		OUT_HC.tChC2_DemFan7.Do 	:= Q2[7]	OR GK2_ST7_ManAuxCtr;
		OUT_HC.tChC2_DemFan8.Do 	:= Q2[8]	OR GK2_ST8_ManAuxCtr;
		OUT_HC.tChC2_DemFan9.Do 	:= Q2[9]	OR GK2_ST9_ManAuxCtr;
		OUT_HC.tChC2_DemFan10.Do	:= Q2[10]	OR GK2_ST10_ManAuxCtr;
		OUT_HC.tChC2_DemFan11.Do 	:= Q2[11]	OR GK2_ST11_ManAuxCtr;
		OUT_HC.tChC2_DemFan12.Do 	:= Q2[12]	OR GK2_ST12_ManAuxCtr;
		OUT_HC.tChC2_DemFan13.Do	:= Q2[13]	OR GK2_ST13_ManAuxCtr;
		OUT_HC.tChC2_DemFan14.Do	:= Q2[14]	OR GK2_ST14_ManAuxCtr;
		OUT_HC.tChC2_DemFan15.Do	:= Q2[15]	OR GK2_ST15_ManAuxCtr;
		OUT_HC.tChC2_DemFan16.Do	:= Q2[16]	OR GK2_ST16_ManAuxCtr;
		
		(******************************************************************************)
		
		and_16b (ADR(EN2), ADR(Q2), ADR(Q2));		(* switch off "Q2" if "EN2" is FALSE:   "Q2" := "EN2" AND "Q2" *)
		andnt_16b (ADR(EN2), ADR(Q2), ADR(RDY2));	(* enabled outputs with status FALSE: "RDY2" := "EN2" AND NOT "Q2" *)
		
		
		(* SEQU_C2 = stage number for stage numbers > iPriorityStage2 *)
		FOR i := (iPriorityStage2 + 1) TO 16 BY 1 DO
			SEQU_C2[i] := i;
		END_FOR;
		
		(* SEQU_C2 = stage number + 100 for stage numbers <= iPriorityStage2 *)
		FOR i := iPriorityStage2 TO 1 BY -1 DO
			 SEQU_C2[i] := i + 100;
		END_FOR;
		
		min_16di (ADR(RDY2), ADR(SEQU_C2), ADR(NEXT_ON2));	(* stage for next on  as BOOL *)
		min_16di (ADR(Q2), ADR(SEQU_C2), ADR(NEXT_OFF2)); 	(* stage for next off as BOOL *)
		
		iNextOn2   := max_i_16b (ADR(NEXT_ON2)); 			(* stage for next on  as INT  *)
		iNextOff2  := max_i_16b (ADR(NEXT_OFF2));			(* stage for next off as INT  *)
		
		iIN2 := max_i_16b (ADR(IN2));						(* input : number of stages as INT *)
		iQ2  := sum_16b (ADR(Q2));   						(* output: number of stages as INT *)
		
		IF (iIN2 > iQ2) THEN
			Q2[iNextOn2] := TRUE;
			iPriorityStage2 := iNextOn2;
		END_IF;
		
		IF (iIN2 < iQ2) THEN
			Q2[iNextOff2] := FALSE;
		END_IF;
		
		(******************************************************************************)
		
		
		(* Anzeige auf VISU *)
		
		summe2 := 0;
		FOR i:= 1 TO 16 BY 1 DO
			summe2 := summe2 + Q2[i];
		END_FOR;
		
		IF iSumChC2_Stages_ManAuxCtr > 0 THEN				
			iSumChC2_Stages := iSumChC2_Stages_ManAuxCtr; 	(* Manual operating auxiliaries control - Handbedienebene to vis *)
		ELSE
			iSumChC2_Stages := summe2;						(* to vis *)
		END_IF;
	END_IF;

	
END_PROGRAM
