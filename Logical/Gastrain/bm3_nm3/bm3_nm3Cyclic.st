(* BERECHNUNG NORMKUBIKMETER-GASVERBRAUCH

VER	Datum/Name	Änderung
V170	21.03.02/LH	erstellt
V172	31.07.02/LH	Gaszähler-Impuls aus pb7 übernommen
					Berechnung Zustandszahl eliminiert => neuer task
		17.09.02/LH	korrigiert für AS 2.2
V173	11.11.02/LH	Vergleich korrigiert
V181	23.04.03/LH	Zähler-Beschaltung richtiggestellt
V190	18.06.04/LH	Vermeidung von Rundungsfehlern
V03.99.00	21.09.2013	Ganguly/Denk 	Generated for modular software
V04.00.02	02.06.2014  Denk			Gas counter to MM2VIS added	
V04.01.00	01.07.2014  Denk			Gas counter parameters added and additional OUT-Interfaces
V04.01.01	18.03.2015	lettenb.		increase counter with NORM_IMP, xR_TRIG_FA_BTRB_IMP.Q only for 1 cycle
V04.03.00	02.06.2015	Denk			Bugfix, gas counter reset when PLC coldstart. Connected to Perm struct.
V04.04.00	18.10.2016	Denk			Gas counter writable from Visu
V04.07.00	10.04.2019	Zengerer		Gas counter prescaler for requisition demanded version V4.07, chapter 5
V04.07.01	11.04.2019	Zengerer		xTOF_FA_BTRB_M3.PT := ...tiGCPulse_Duration_min 
V04.07.02	05.06.2019	Zengerer		cleanup, disabeled xCTD_FA_GAS_IMP removed

Instructions FOR use:
--------------------
 -

Outstandings:
------------
rGasImp_Prescaling < 1.0 ..  //TODO:Release after pilot engines in V4.09

**********************************************)

PROGRAM _CYCLIC

    (* Reset Nm3-Impulse *)
	NORM_IMP := FALSE;

	(* Gas counter - impulse *)   

	IF IN_GT.tCU2GT.iGC_Select_Option.7  THEN 					// Bit 7 sets task input back to behavior of former task version <4.07
		xR_TRIG_FA_GAS_IMP_CD.CLK := IN_GT.tCnt_GasImp.Di;		// Direct DI input like in former task version <4.07
	ELSE
		xR_TRIG_FA_GAS_IMP_CD.CLK := bGasImp_Prescaled;			// Pulse prescaler for IN_GT.tCnt_GasImp.Di gets handled in TC2		
	END_IF
	xR_TRIG_FA_GAS_IMP_CD();
	IF NOT IN_GT.tCnt_GasImp.Di THEN bGasImp_Prescaled := FALSE; END_IF	(* Do not clear the artificial generated pulse, until the real pulse is gone, to keep similar pulse duration behavior *) 


	BTRB_IMP   := xR_TRIG_FA_GAS_IMP_CD.Q AND ANLAUF;

	ANLAUF := TRUE;											// Setting local flag to TRUE , it is initially FALSE

	(* Bm3-Impulse *)
	xTOF_FA_BTRB_M3.IN := BTRB_IMP;
	xTOF_FA_BTRB_M3.PT := IN_GT.tCU2GT.tiGCPulse_Duration_min ;   		// := T#1s;
	xTOF_FA_BTRB_M3();
	BTRB_M3 := xTOF_FA_BTRB_M3.Q;

	(* Edge triggered Gas count impulse *)
	xR_TRIG_FA_BTRB_IMP.CLK := BTRB_M3;
	xR_TRIG_FA_BTRB_IMP();

	IMP_W := LIMIT(1000, Para.rGasImp_Prescaling * 1000, 50000);		 (*NEW parameter from V4.07: (Impulswertigkeit (Caution: formerly Constant value 1000 removed, but 1000 has to be FIXED LOWER LIMIT to cooperate with prescaler!)  *)

	IF xR_TRIG_FA_BTRB_IMP.Q THEN
		IMP_B := IMP_W;
	ELSE
		IMP_B := 0;
	END_IF;

	(* L10-L12 Summe *)
	IMP_N := ZSZ * IMP_B;

	(* Sum up impulses *)
	IMP_S := LIMIT(0, (IMP_S + IMP_N) ,4294967295);

	(* Block new impulse *)
	xTOF_FA_T_NORM_M3.IN := NORM_M3;
	xTOF_FA_T_NORM_M3.PT := IN_GT.tCU2GT.tiGCPulse_Duration_min ;   		// := T#1s;
	xTOF_FA_T_NORM_M3();
	T_NORM_M3 := xTOF_FA_T_NORM_M3.Q;

	(* Sum greater than impulse "wertigkeit" & release new impulse *)
	IF ((IMP_S >= IMP_W) AND NOT T_NORM_M3) THEN
		(* Set Nm3 impulse *)
		NORM_IMP := TRUE;
		(* Reduce sum by impulse "wertigkeit *)
		IMP_S := IMP_S - IMP_W;
	END_IF;

	(* Nm3 impulse *)
	xTOF_FA_NORM_M3.IN := NORM_IMP;
	xTOF_FA_NORM_M3.PT := IN_GT.tCU2GT.tiGCPulse_Duration_min ;   		// := T#1s;
	xTOF_FA_NORM_M3();
	NORM_M3 := xTOF_FA_NORM_M3.Q;

	(* Counter *)
	IF Para.bCnt_Gas_NormM3 THEN
		(* Gas counter Norm_M3 *)	
		IF NORM_IMP THEN
			(* increase counter *)
			MM2VIS.iCnt_Gas_NormM3 := MM2VIS.iCnt_Gas_NormM3 + REAL_TO_DINT(MAX(1, Para.rGasImp_Prescaling));  // + 1; 	 Changed V4.07   
			(* check limits *)
		ELSIF MM2VIS.iCnt_Gas_NormM3 >= 1000000000 THEN
			MM2VIS.iCnt_Gas_NormM3 := MM2VIS.iCnt_Gas_NormM3 - 1000000000;    (* check upper limit *)
		ELSIF MM2VIS.iCnt_Gas_NormM3 <= -1000000000 THEN
			MM2VIS.iCnt_Gas_NormM3 := MM2VIS.iCnt_Gas_NormM3 + 1000000000;    (* check lower limit *)
		END_IF;
	END_IF;
	
	IF Para.bCnt_Gas_OpM3 THEN
		(* Gas counter Op_M3 *)                      
		IF xR_TRIG_FA_BTRB_IMP.Q THEN
			(* increase counter *)
			MM2VIS.iCnt_Gas_OpM3 := MM2VIS.iCnt_Gas_OpM3 + REAL_TO_DINT(MAX(1, Para.rGasImp_Prescaling));  // + 1; 	 Changed V4.07   
			(* check limits *)
		ELSIF MM2VIS.iCnt_Gas_OpM3 >= 1000000000 THEN
			MM2VIS.iCnt_Gas_OpM3 := MM2VIS.iCnt_Gas_OpM3 - 1000000000;        (* check upper limit *)
		ELSIF MM2VIS.iCnt_Gas_OpM3 <= -1000000000 THEN
			MM2VIS.iCnt_Gas_OpM3 := MM2VIS.iCnt_Gas_OpM3  + 1000000000;       (* check lower limit *)
		END_IF;	
	END_IF;
	
	(* Assignement to OUT/MM2VIS-Interfaces *)
	OUT_GT.iCnt_Gas_OpM3   	:= MM2VIS.iCnt_Gas_OpM3;				
	OUT_GT.iCnt_Gas_NormM3 	:= MM2VIS.iCnt_Gas_NormM3;
	OUT_GT.bCnt_Gas_OpM3   	:= BTRB_M3;											
	OUT_GT.bCnt_Gas_NormM3 	:= NORM_M3;							

END_PROGRAM
