(*******************************************************************************
Pr_EO		

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2024
 
Customized modifications: -
------------------------
 
History:
-------
V3.90.0	20-03-2012	pankajrodey Created initial structured text code from ladder diagram
V3.99   28.02.2013	pankajrodey	Generated for modular software with changes for V3.30
		05.04.2013	lettenb.	oil filter pressure difference maximum alarm --> msg..
		28.05.2013	lettenb.	bTestEnabled Para -> loc.var
V4.04.0	25.10.2016	lettenb.	measuring signal plausibility check (Functional Safety EN 13849)
		07.08.2017	502423184	engine oil pressure after oil filter lowlow added FOR SWAT #3
V4.05.0	22.12.2017	lettenb.	comment added: Safety-related application software source code (EN 13849-1 / 4.6.3)
V4.07.0	25.04.2018	lettenb.	measuring signal plausibility check Pr_EOF_After(Functional Safety EN 13849)//SWAT920/5a
		13.06.2018	lettenb.	xTON_OilPressure added(acc.XT3), bugfix
                                xTON_ODR_AF_A: xTON_OilPressure.Q removed(only relevant for Pr_EngLubOil), bugfix
V4.09.0	22.04.2020	Schmid		corrected activation Z_ODR of A1017 oil pressure minimum due to change in tEng_Run.Do, bugfix
V4.13.0	05.03.2024	Tinello		Oil filter diff pressure monitoring (2023-184) - including issue #1122 and Fracas #3216

Instructions for use:
--------------------

Outstandings:
------------
(*******************************************************************************)

PROGRAM _CYCLIC	

	(* delayed oil pressure signal failure *)
	xTON_OilPressure(IN:= NOT IN_AG.tPr_EngLubOil.GoodQual, PT:= T#0.3s);

	(* engine speed depending oil pressure limits *)
	xGR_MAXR_M_D800(In := IN_AG.rN_EngAct, Gw:= 800.0, Hy := 10.0);
	xTON_ODR_N(IN:= xGR_MAXR_M_D800.Q, PT:= T#10s);

	xSigScal_PrEO(X:= IN_AG.rN_EngAct, X1:= Para.rN_EOP_Lim1, Y1:= Para.rPr_EOP_LimSpeed1, X2:= Para.rN_EOP_Lim2, Y2:= Para.rPr_EOP_LimSpeed2);
	OUT_AG.rPr_EO_CalcLim := xSigScal_PrEO.Y_SCAL;
		
	IF xTON_ODR_N.Q THEN	OUT_AG.rPr_EO_Min := OUT_AG.rPr_EO_CalcLim;
	ELSE					OUT_AG.rPr_EO_Min := Para.rPr_EOP_LimSpeed1;
	END_IF;

	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* engine oil pressure lowlow *)
	xGR_MINR_ODRA(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= OUT_AG.rPr_EO_Min, Hy:= Para.rPr_EOP_HyMin);
	xTON_ODRA(IN:= xGR_MINR_ODRA.Q AND IN_AG.tPB2MM.bParaSetupOk AND NOT xTON_OilPressure.Q, PT:= T#0.5s);
	AN_ODRA := xTON_ODRA.Q;

	(* engine oil pressure after oil filter lowlow *) (* SWAT #3 *)
	xGR_MINR_OD_AF_RA(In:= IN_AG.tPr_EOF_After.Ai, Gw:= OUT_AG.rPr_EO_Min, Hy:= Para.rPr_EOP_HyMin);
	xTON_ODR_AF_A(IN:= xGR_MINR_OD_AF_RA.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#0.5s);
	AN_OD_AF_RA := xTON_ODR_AF_A.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)

		
	(* engine oil pressure low (warning) *) 
	xGR_MINR_ODRW(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_EOP_LimSpeed2 + 0.2, Hy:= Para.rPr_EOP_HyMin);
	xTON_ODRW(IN:= xGR_MINR_ODRW.Q AND IN_AG.tPB2MM.bParaSetupOk AND NOT xTON_OilPressure.Q, PT:= T#0.5s);
	AN_ODRW := xTON_ODRW.Q;

	
	(* prelube pressure 1 (pump) *)
	xGR_MAXR_VSD1(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel1EOP_LimHi, Hy:= Para.rPr_Prel1EOP_HyHi);
	xTON_VSD1(IN:= xGR_MAXR_VSD1.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#2s);
	OUT_AG.bPr_EOP_Prelub1 := xTON_VSD1.Q;

	
	(* prelube pressure 2 (pump) *)
	xGR_MAXR_VSD2(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_Prel2EOP_LimHi, Hy:= Para.rPr_Prel2EOP_HyHi);
	xTON_VSD2(IN:= xGR_MAXR_VSD2.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#2s);
	OUT_AG.bPr_EOP_Prelub2 	:= xTON_VSD2.Q;

	
	(* engine oil pressure limit 1 *)
	xGR_MAXR_PrEO_Hi1(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_EOP_Lim1, Hy:= Para.rPr_EOP_HyLim1);
	xTON_PrEO_Hi1(IN:= xGR_MAXR_PrEO_Hi1.Q AND IN_AG.tPB2MM.bParaSetupOk, PT:= T#2s);
	AN_ODGW1 :=   xTON_PrEO_Hi1.Q;

	
	(* engine oil pressure high *)
	xGR_MAXR_PrEO_Hi(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_EOP_LimMax, Hy:= Para.rPr_EOP_HyMax);
	xTON_PrEO_Hi(IN:= xGR_MAXR_PrEO_Hi.Q AND IN_AG.tPB2MM.bParaSetupOk AND NOT xTON_OilPressure.Q, PT:= T#30s);
	AN_ODR_MAX := xTON_PrEO_Hi.Q;

	
	(* engine oil pressure switch *)
	xGR_MAXR_DR_ODR(In:= IN_AG.rN_EngAct, Gw:= Para.rN_EOP_Lim1, Hy:= 10);
	OUT_AG.bPr_EOP_MonActive := xGR_MAXR_DR_ODR.Q AND IN_AG.tPB2MM.bParaSetupOk;

	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* engine oil pressure low - monitoring *)
	xTON_Z_ODR(IN:= OUT_AG.bPr_EOP_MonActive, PT:= T#3s);
	Z_ODR := xTON_Z_ODR.Q OR (IN_AG.tEng_Run.Do AND NOT IN_AG.bEng_MonOff);

	
	(* engine oil pressure low *)
	xGR_MAXR_ODR(In:= IN_AG.tPr_EngLubOil.Ai, Gw:= Para.rPr_EOP_LimSpeed2, Hy := 0);
	xTON_ODR(IN:= xGR_MAXR_ODR.Q, PT:= T#5s);
	xGR_MINR_DREHZ(In:= IN_AG.rN_EngAct, Gw := (Para.rN_EngNom - 100.0), Hy:= 0);

	xRS_FG_ODRUW(SET:= xTON_ODR.Q, RESET1:= xGR_MINR_DREHZ.Q);
	FG_ODRUW := xRS_FG_ODRUW.Q1;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)
	
	
	(* engine oil pressure high monitoring ON *)
	IF bTestEnabled THEN xTON_UW_ODR_MAX.PT:= T#1s;
	ELSE				 xTON_UW_ODR_MAX.PT:= T#600s;
	END_IF;
	xTON_UW_ODR_MAX(IN:= (xEngType.Type9 OR xEngType.Type6 OR xEngType.Type4 OR Para.bEngTyp3_Prelub_Active) AND M_DREHZ);
	UW_ODR_MAX := xTON_UW_ODR_MAX.Q;


	(*---------------------------------------------------------------------------*)
	(* measuring signal plausibility check - engine oil pressure (Functional Safety EN 13849) *)
	xTON_EngStop(IN:= 	NOT IN_AG.tEng_Run.Do
					AND NOT IN_AG.bEng_Aux_Dem_CDR
					AND NOT OUT_AG.tEOP1DC_Dem.Do
					AND NOT OUT_AG.tEOP1AC_Dem.Do
					AND NOT OUT_AG.tTC_EOP_On.Do, PT:= T#60s);
	xTON_EngRun(IN:= IN_AG.tEng_Run.Do, PT:= T#60s);

	xR_TRIG_StoreStopValue(CLK:= IN_AG.tPB2MM.bSys_Run AND xTON_EngStop.Q);
	xR_TRIG_StoreRunValue (CLK:= IN_AG.tPB2MM.bSys_Run AND xTON_EngRun.Q);

	IF xR_TRIG_StoreStopValue.Q THEN rPr_EO_StopValue := IN_AG.tPr_EngLubOil.Ai;
	END_IF;
	IF xR_TRIG_StoreRunValue.Q  THEN rPr_EO_RunValue  := IN_AG.tPr_EngLubOil.Ai;
	END_IF;
	IF bPr_EO_PcheckFail AND IN_AG.tAB2AG.bResetWarning THEN rPr_EO_StopValue := 0.0; (* reset *)
									                         rPr_EO_RunValue  := 0.0;
	END_IF;

	IF MM2VIS.bMsg2103             THEN				        bPr_EO_PcheckFail := FALSE;
	ELSIF (rPr_EO_StopValue = 0.0) THEN						bPr_EO_PcheckFail := FALSE; (* value not valid *)
	ELSIF (rPr_EO_RunValue  = 0.0) THEN						bPr_EO_PcheckFail := FALSE; (* value not valid *)
	ELSIF (rPr_EO_RunValue <= rPr_EO_StopValue) THEN		bPr_EO_PcheckFail := TRUE;
	ELSE
		IF (rPr_EO_RunValue - rPr_EO_StopValue) < 2.0 THEN	bPr_EO_PcheckFail := TRUE;
		END_IF;
	END_IF; 

	(* measuring signal plausibility check - engine oil pressure after filter (Functional Safety EN 13849) *)//SWAT920/5a begin
	IF xR_TRIG_StoreStopValue.Q THEN rPr_EOaF_StopValue := IN_AG.tPr_EOF_After.Ai;
	END_IF;
	IF xR_TRIG_StoreRunValue.Q  THEN rPr_EOaF_RunValue  := IN_AG.tPr_EOF_After.Ai;
	END_IF;
	IF bPr_EOaF_PcheckFail AND IN_AG.tAB2AG.bResetWarning THEN rPr_EOaF_StopValue := 0.0; (* reset *)
									                           rPr_EOaF_RunValue  := 0.0;
	END_IF;

	IF MM2VIS.bMsg2432               THEN				        bPr_EOaF_PcheckFail := FALSE;
	ELSIF (rPr_EOaF_StopValue = 0.0) THEN						bPr_EOaF_PcheckFail := FALSE; (* value not valid *)
	ELSIF (rPr_EOaF_RunValue  = 0.0) THEN						bPr_EOaF_PcheckFail := FALSE; (* value not valid *)
	ELSIF (rPr_EOaF_RunValue <= rPr_EOaF_StopValue) THEN		bPr_EOaF_PcheckFail := TRUE;
	ELSE
		IF (rPr_EOaF_RunValue - rPr_EOaF_StopValue) < 2.0 THEN	bPr_EOaF_PcheckFail := TRUE;
		END_IF;
	END_IF; 	//SWAT920/5a end



	(*--------------------------------------------------*)
	(* Measurement monitoring - oil pressure 			*)
	(*--------------------------------------------------*)
	bAMM_Pr_bEOF_Ms			:= Para.b_EOF_DiffMonActive		AND NOT IN_AG.tPr_EOF_DiffMon.GoodQual;							(* A2242 *)
	bAMM_Pr_aEOF_Ms			:= Para.bPr_EOF_After_Active	AND NOT IN_AG.tPr_EOF_After.GoodQual;							(* A2260 *)(* W2432 *)
	bAMM_Pr_EngLubOil_Ms	:= 									NOT IN_AG.tPr_EngLubOil.GoodQual;							(* A2260 *)

		bRelMon_Pr_bEOF		:= Para.b_EOF_DiffMonActive  	AND NOT bAMM_Pr_bEOF_Ms;
		bRelMon_Pr_aEOF		:= Para.bPr_EOF_After_Active  	AND NOT bAMM_Pr_aEOF_Ms;
		bRelMon_Pr_EngLubOil:= 									NOT bAMM_Pr_EngLubOil_Ms;

 
	(*--------------------------------------------------*)
	(* Oil filter differential pressure					*)
	(*--------------------------------------------------*)
	IF 	  NOT bRelMon_Pr_bEOF 		THEN rDPr_EOF	:= 0;													(* NO signal before filter available *)
	ELSE
		IF 	  bRelMon_Pr_aEOF 		THEN rDPr_EOF	:= IN_AG.tPr_EOF_DiffMon.Ai - IN_AG.tPr_EOF_After.Ai;	(* before filter - after filter *)
		ELSIF bRelMon_Pr_EngLubOil	THEN rDPr_EOF	:= IN_AG.tPr_EOF_DiffMon.Ai - IN_AG.tPr_EngLubOil.Ai; 	(* before filter - last lubr. point *)
									ELSE rDPr_EOF	:= 0;													(* NO signal after filter available *)
		END_IF
	END_IF

	xGR_MAXR_DPr_EOF_Limit1(In:= rDPr_EOF, Gw:= MAX(0.11, Para.rPr_EOF_DiffMonLimit1), Hy:= 0.1); 	(* 0.11 to avoid error because of wrong para setting *)
	xGR_MAXR_DPr_EOF_Limit2(In:= rDPr_EOF, Gw:= MAX(0.11, Para.rPr_EOF_DiffMonLimit2), Hy:= 0.1); 	(* Hysteresis 0.1 bar *)
	xGR_MAXR_DPr_EOF_Limit3(In:= rDPr_EOF, Gw:= MAX(0.11, Para.rPr_EOF_DiffMonLimit3), Hy:= 0.1);

	bAMM_DPr_EOF_Lim1	:= (IN_AG.tT_EO.Ai > Para.rT_EOF_DiffMonRel) AND NOT MM2VIS.bMsg2102 AND xGR_MAXR_DPr_EOF_Limit1.Q;	(* W3414 *)
	bAMM_DPr_EOF_Lim2	:= (IN_AG.tT_EO.Ai > Para.rT_EOF_DiffMonRel) AND NOT MM2VIS.bMsg2102 AND xGR_MAXR_DPr_EOF_Limit2.Q;	(* W3415 *)
	bAMM_DPr_EOF_Lim3	:= (IN_AG.tT_EO.Ai > Para.rT_EOF_DiffMonRel) AND NOT MM2VIS.bMsg2102 AND xGR_MAXR_DPr_EOF_Limit3.Q;	(* A1059 *)
END_PROGRAM