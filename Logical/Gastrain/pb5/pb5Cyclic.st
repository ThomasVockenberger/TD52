(********************************************************************************
pb5 			gas train testing

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2025

Customized modifications: -
------------------------
 
History:
-------
V0.1	06.07.98/Pa	erstellt
 	    24.11.98/Pa	korrekturlesung
V2071	07.07.05/LH	Prüfzeiten für DK2F angepasst
    	03.03.05/LH	Anzahl Gasstrecken < 2
V220	19.02.07/LH	angepasst für X20-Einführung
V3.20.0	04.11.2010  lettenb.	Para.bPurgecycle_Active added (test gas train before start)
V03.99.00	21.09.2013	Ganguly 	generated for modular software
V03.99.01	20.02.2013	Denk		V3.30 changes inserted	
			22.11.2013	lettenb.	V3.50 test gas train with exh.gas scavenging added	
			20.02.2014	lettenb.	bugfix gas train check for BR2,3,4
V04.01.00	15.07.2014	Denk		bugfix M_STGAS1
			12.09.2014	lettenb.	M_DREHZ added(purge cycle: to avoid tight check during eng.operation)
V04.03.00	05.10.2015	Denk		Prechamber gas train safety device
			01.06.2016  lettenb.	xTP_TP_vorStart2 added for BR234 with purgecycle, bugfix
V04.04.00	13.10.2016	Denk		bMsg1027 setting function when remote reset
V04.06.00	25.06.2018	Perktold	IN_GT.bGT_Check4FastStart, OUT_GT.bGT2_SafeDevOK and OUT_GT.bPCGT_SafeDevOK implemented
V04.07.00 	24.09.2018	Denk		Avoid second start of gas safety device (DPFR-20180821-0202)
V04.07.01 	04.04.2019	Zengerer	requisition variants selection: chapter 5-configuration gas leakage MGV, LIMIT(T#600ms, Para.tiGT_TestDuration 
V04.09.00	25.10.2019	Zengerer	release option 4 MEGAGas- Demand compressor option
			26.11.2019	Zengerer	xF_trig_GK, xR_trig_PO removed for better readability, NO functional change
			16.01.2020	Zengerer	release option 4 MEGAGas- delayed valve check demand bDelay_GDKG_GCStarting, option 1 and 2 covered with Megagas ELSE, OUT_GT.tGT1_SafeDevice.Do := (corr.Jan2020)
			05.03.2020	Denk		Testing time gas train 1 and 2 increased to 130 sec. Mandatory for new MegaGas valves function
V04.14.00	23.02.2025	Tinello		Gas leakage check moved to SafetyPLC
V04.25.00	30.12.2025	Tinello		Logic modified because of SafetyPLC

Instructions for use:
--------------------

Outstandings:
------------  
Para.iGasTrain_Type  TODO: VALIDATION FOR OPTION 4, TO ALLOW PARA VALUE>2 
********************************************************************************)

PROGRAM _CYCLIC

	Para.iGasTrain_Type := LIMIT(1 , Para.iGasTrain_Type, 4);	(* TODO: VALIDATION FOR OPTION 4, TO ALLOW PARA VALUE>2 *) 
	Para.iGasTrain_Upstream_Type;								(* V4.07 new  *)
	
	(*Customisation Interface from Module Customized: *)
	IN_GT.tCU2GT.tiGT_TestDuration := LIMIT(T#1s , IN_GT.tCU2GT.tiGT_TestDuration, T#5m);		(* optional prepared customizable interface  *)
	IN_GT.tCU2GT.tiGCPulse_Duration_min;			(* optional prepared customizable interface  *)
	IN_GT.tCU2GT.tiGV_Feedback_Delay_max;			(* optional prepared customizable interface   *)
	IN_GT.tCU2GT.iGC_Select_Option ;				(* optional prepared customizable interface   *)
	IN_GT.tCU2GT.tiGV_Feedback_Delay_max := LIMIT(T#200ms , IN_GT.tCU2GT.tiGV_Feedback_Delay_max , T#240s);	(* optional prepared customizable interface  *)
	
	(* Acknowledgement Quiescent current loop OK *)
	xTON_FA_T94.IN := IN_GT.tSafetyLoop_Eng.Di;
	xTON_FA_T94.PT := T#5s;
	xTON_FA_T94();
	T94 := xTON_FA_T94.Q;

	
	(********************************************************************************************************************
	Safety-related application software source code: BEGIN
	Gas safety device must be triggered with Scavenging
	*********************************************************************************************************************)
	(* initiate gas train test *)
	xTOF_SafetyCheck_Run(IN:= EDGENEG(OUT_GT.tGT1_SafeDevice.Do), PT:= xTON_FA_T88.PT);
	xSR_GT_SafetyDevice2ndStartBlock(SET1 := EDGENEG(OUT_GT.tGT1_SafeDevice.Do), RESET := EDGENEG(IN_GT.bDemScavVa));
	
	(* initiate gas train test *)
	xTP_TP_vorStart.IN :=  (NOT M_DREHZ AND IN_GT.bDemScavVa AND NOT xSR_GT_SafetyDevice2ndStartBlock.Q1) OR (NOT M_DREHZ AND IN_GT.bGT_Check4FastStart AND (xTON_FA_T88.ET = xTON_FA_T88.PT OR xTON_FA_T88.ET = T#0s)) 
						OR (NOT M_DREHZ AND NOT Para.bEGScav_Active AND NOT xEngType.Type6 AND NOT xEngType.Type9);
	xTP_TP_vorStart.PT := T#1s;
	xTP_TP_vorStart();
	
	xTP_TP_vorStart2.IN := (NOT M_DREHZ AND Para.bPurgecycle_Active AND IN_GT.bEng_Dem); (* BR234 with purgecycle *)
	xTP_TP_vorStart2.PT := T#1s;
	xTP_TP_vorStart2();


	(* Gas train 1 test (DUNGS) *)
	xTP_FA_87.IN :=	NOT xTP_TP_vorStart.Q
				AND NOT xTP_TP_vorStart2.Q
				AND 	(T94 AND NOT MM2VIS.bMsg1027 AND NOT MM2VIS.bMsg3359 AND NOT MM2VIS.bMsg3360 AND NOT MM2VIS.bMsg3361)
				AND 	(bOMSS_MAT OR OUT_GT.bGT1_Check);
	xTP_FA_87.PT := T#1s;
	xTP_FA_87();
	T87 := xTP_FA_87.Q;

		
	IF Para.iGasTrain_Type = 1 THEN							(***option bit0 = '1' == STANDARD Gas Train (e.g. type Dungs)   ***)
		(*	option 1: no more special handling defined -> handled in ELSE from option 4	*)
	END_IF
	

	IF Para.iGasTrain_Type = 2 THEN 					  	(***option bit1 = '2'== Single Gas Valve Gas Train *)
		(*	option 2: no more special handling defined -> handled in ELSE from option 4	*)
	END_IF
	
	
		bMEGA_GasTrain :=  (Para.iGasTrain_Type = 4);	 	(***option bit2 = '4' == MEGA Gas Train, for wide pipe dimensions with 2 separate valves 	(V4.07	Requisition- supplied code parts included for MGV) *)
	IF 	bMEGA_GasTrain THEN  						 		(* bMEGA_GasTrain = Type = '4' == MEGA Gas Train , V4.07	 *)
	
		IN_GT.tCU2GT.tiGT_TestDuration;  							(*variable gas checking time parameter for bDelayForGascheck *)
		

		xTOF_RESET.IN := EDGEPOS(M_DREHZ);							(*TOF 5 sec extended 'engine in operation' trigger *)
		xTOF_RESET.PT := T#5s; 
		xTOF_RESET();
		
		RS_GK.SET	 :=  EDGENEG(IN_GT.tAB2GT.bGnlTrip1  			(*memorize 'critical alarm' flag, triggered by critical alarm *)
							  OR IN_GT.tAB2GT.bGnlTrip2);
		RS_GK.RESET1 := M_DREHZ; 
		RS_GK();

		xTOF_Shutdown.IN := EDGENEG(M_DREHZ);						(*TOF 2 sec after NOT 'engine in operation' trigger *)
		xTOF_Shutdown.PT := T#5s; 
		xTOF_Shutdown();

		OUT_GT.tGT1_SafeDevice.Do := bDem_SafeDevice  AND (NOT bDelayGDKG_GCStarting);	(*(delayed) leakage check demand, to allow gas compressor generate sufficient pressure (corr.Jan2020)*)		
		bDem_SafeDevice1 :=	(OUT_GT.tGT_GC_Dem.Do AND RS_GK.Q1) 	;					(*demand leakage check after critical alarm *)  //old Anf_GDKG is now ModuleGlobal, for task Biogas 
		bDem_SafeDevice2 :=	(NOT T87 AND IN_GT.bEng_Aux_Dem_CDR) 	;					(*demand leakage check after normal engine operation *)
		bDem_SafeDevice3 :=	(IN_GT.tGT1_SafeDevOK.Di AND NOT xTOF_Shutdown.Q);			(*hold signal and surpress new leakage check at stopped engine after test ok *) 
		bDem_SafeDevice	 :=	(bDem_SafeDevice1 OR bDem_SafeDevice2 OR bDem_SafeDevice3)
							AND NOT IN_GT.bSafetyPLC_Active;							(* SAFETY PLC *)

		xTON_GC_T100.IN := bDem_SafeDevice ; 
		xTON_GC_T100.PT := LIMIT(T#600ms, IN_GT.tCU2GT.tiGT_TestDuration, T#240s);  	(*variable gas checking time parameter for bDelayForGascheck *)
		xTON_GC_T100();
		
		bDelayForGascheck := xTON_GC_T100.Q;
	ELSE
		
		OUT_GT.tGT1_SafeDevice.Do := NOT T87 AND NOT IN_GT.bSafetyPLC_Active;			(* SAFETY PLC *)
				
	END_IF
	(********************************************************************************************************************
	Safety-related application software source code: END
	Gas safety device must be triggered with Scavenging
	*********************************************************************************************************************)
	
	(* Testing time gas train 1 *)
	xTON_FA_T88.IN 	:=	OUT_GT.tGT1_SafeDevice.Do 
						AND T94 
						AND (bOMSS_MAT OR 
							(OUT_GT.bGT1_Check AND NOT MM2VIS.bMsg1027 AND NOT MM2VIS.bMsg3359 AND NOT MM2VIS.bMsg3360 AND NOT MM2VIS.bMsg3361));
	
	IF bTestEnabled THEN		//for module test
		xTON_FA_T88.PT := T#1s;		
	ELSE		
		xTON_FA_T88.PT := T#130s;	// changed from := T#100s; (according to email 26.2.2020)
	END_IF;
	xTON_FA_T88();

	OUT_GT.bGT1_Check := xTON_FA_T88.Q;	

	M_STPch		:=	OUT_GT.tGT1_SafeDevice.Do 		
					AND OUT_GT.bGT1_Check 
					AND NOT OUT_GT.bGT1_CheckOK 
					AND NOT IN_GT.tPCGT_SafeDevOK.Di
					AND Para.bPCGT_SafeDevice_Exist;
						 
	M_STGAS1	:=	OUT_GT.tGT1_SafeDevice.Do 		
					AND OUT_GT.bGT1_Check 
					AND NOT OUT_GT.bGT1_CheckOK 
					AND ((NOT IN_GT.tGT1_SafeDevOK.Di AND NOT AKT_Gastrecke1_2) OR 
						 (NOT IN_GT.tGT1_1_SafeDevOK.Di AND AKT_Gastrecke1_2));

	M_STGAS1_2	:=	OUT_GT.tGT1_SafeDevice.Do 
					AND OUT_GT.bGT1_Check 
					AND NOT OUT_GT.bGT1_CheckOK  
					AND NOT IN_GT.tGT1_2_SafeDevOK.Di 
					AND AKT_Gastrecke1_2;
	
	M_STGAS1_3	:=	OUT_GT.tGT1_SafeDevice.Do 
					AND OUT_GT.bGT1_Check 
					AND NOT OUT_GT.bGT1_CheckOK  
					AND NOT IN_GT.tGT1_3_SafeDevOK.Di 
					AND AKT_Gastrecke1_3;

	M_STGAS1_4	:=	OUT_GT.tGT1_SafeDevice.Do 
					AND OUT_GT.bGT1_Check 
					AND NOT OUT_GT.bGT1_CheckOK  
					AND NOT IN_GT.tGT1_4_SafeDevOK.Di 
					AND AKT_Gastrecke1_4;	

	OUT_GT.bGT1_CheckOK   := OUT_GT.tGT1_SafeDevice.Do AND OUT_GT.bGT1_Check;
	
	IF Para.iNum_GT1_Lines < 2 THEN   				
		OUT_GT.bGT1_SafeDevOK := IN_GT.tGT1_SafeDevOK.Di OR IN_GT.bSafeOUT_GT1_SafeDevOK;	//Release from gastrain 1, no gasline 1-4 		(* SAFETY PLC *)
	ELSE
		OUT_GT.bGT1_SafeDevOK := bGT1_SafeDevOK 		 OR IN_GT.bSafeOUT_GT1_SafeDevOK;	//Release from gastrain 1, with gasline 1-4 	(* SAFETY PLC *)									
	END_IF;
		
	
	(* if number of gastrains is < 2 *)
	IF (NOT OUT_GT.bGT_TypSwhActive AND NOT OUT_GT.bGT_TypSwhActiveHalt) THEN
		OUT_GT.bGT2_Check   := TRUE;
		OUT_GT.bGT2_CheckOK := TRUE;
		M_STGAS2 			:= FALSE;	
	ELSE
		xTP_FA_T89.IN := NOT xTP_TP_vorStart.Q 
					 AND NOT xTP_TP_vorStart2.Q
					 AND     T94 
					 AND   ((OUT_GT.bGT2_Check AND NOT MM2VIS.bMsg1029) OR bOMSS_MAT);
		xTP_FA_T89.PT := T#1s;
		xTP_FA_T89();
	    T89 := xTP_FA_T89.Q;
		OUT_GT.tGT2_SafeDevice.Do := NOT T89 AND NOT IN_GT.bSafetyPLC_Active;			(* SAFETY PLC *)
		
		(* Testing time gas train 2 *)
		xTON_FA_T90.IN := OUT_GT.tGT2_SafeDevice.Do AND T94 AND ((OUT_GT.bGT2_Check AND NOT MM2VIS.bMsg1029) OR bOMSS_MAT);
		IF bTestEnabled THEN	
			xTON_FA_T90.PT := T#1s;
		ELSE
			xTON_FA_T90.PT := T#130s;
		END_IF;
		xTON_FA_T90();
		OUT_GT.bGT2_Check := xTON_FA_T90.Q;
		
		M_STGAS2            := OUT_GT.tGT2_SafeDevice.Do AND OUT_GT.bGT2_Check AND NOT OUT_GT.bGT2_CheckOK AND NOT IN_GT.tGT2_SafeDevOK.Di; 
		OUT_GT.bGT2_CheckOK := OUT_GT.tGT2_SafeDevice.Do AND OUT_GT.bGT2_Check;		
	END_IF;

	OUT_GT.bGT2_SafeDevOK := IN_GT.tGT2_SafeDevOK.Di OR IN_GT.bSafeOUT_GT2_SafeDevOK;														(* SAFETY PLC *)

	(* Gas safety device Prechamber *)
	OUT_GT.tPCGT_SafeDevice.Do	:= OUT_GT.tGT1_SafeDevice.Do AND Para.bPCGT_SafeDevice_Exist;

	OUT_GT.bPCGT_SafeDevOK		:= IN_GT.tPCGT_SafeDevOK.Di OR NOT Para.bPCGT_SafeDevice_Exist;


END_PROGRAM
