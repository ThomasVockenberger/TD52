(*******************************************************************************
AGGR: counter.st - connection and processing of counters (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2016

- preparation of the RPS time (if necessary for compatibility)
- prepare evaluation of the impulses 
- evaluation of the maintenance counter 
- evaluation reserve counter  

Customized modifications: 
------------------------
 
History:
-------
V3.90	05.07.2012 Zengerer	NEW SEPARATED PART for MM_Customized, derived from V3.20	03-11-2010	Weitzer
V3.91	08.08.2012 Zengerer iCnt_OpHours replaces start_z (rCnt_OpHours), iCnt_Starts replaces betrieb_h (rCnt_Starts)
V3.92	07.09.2012 Zengerer bRPM_Count.. replaces RPMZ..
V3.93	12.11.2012 Zengerer	Counter moved to IN_CU.iCount.. to allow user input
V3.94	05.12.2012 Zengerer	expanded to 10 counters
V4.02	07.10.2015 Zengerer	bOpt_100msTakClock to activate msec counter function with iCount10 
V4.04	20.06.2016 Weitzer	add reserve counter 11..20
V4.07	11.10.2018 Zengerer task moved  to 10ms TC#2 to handle inputs down to minimum frequency <49Hz
							new IN_CU.tCustDigIn_TC2[1].Di for task input bits in 10ms TC#2 VVM, to handle 5Hz to <=49Hz inputs!
V4.07.03 10.09.2019 Zen		Mind changed Perm Storage Handling for reduced file write cycle in task Perm_CU
V4.10.90BETA .2020 Zengerer	Remove example connection 
V4.10 	03.12.2020 Zengerer MaintenanceCount reset interlock to IN_CU.iCnt_Starts 
V4.11	17.02.2022 Zengerer extended counter items 11- ONLY FOR USE WITH HMI Extension Package import


Instructions for use:
--------------------
- connect (or replace) bConnectYourBitToCountHere,  according customer needs
- connect IN_CU.bRPM_Count1...IN_CU.bRPM_Count16,  according customer needs in other Modules or 
			replace <bConnectYourBitToStartTimeHere> with local variable
- optional set bOpt_10msTaskClock = TRUE TO activate msec counter FUNCTION with iCount20 
  
Outstandings:
------------
V4.07: watch out to copy your task input bit in 10ms TC#2 VVM, to handle 5Hz to <=49Hz inputs!


*********************************************************************************)

PROGRAM _CYCLIC

	(* reserve counter 1 *)
	xImp_Count_1.CLK 	:= bConnectYourBitToCountHere1 ;	// := IN_CU.tCustDigCnt_TC2[1].Di;		(* change customized; !Watch out to copy your task input bit in 10ms TC#2 VVM, to handle >5Hz to <=49Hz inputs! *)
	xImp_Count_1;	(* call FUB R_TRIG *)
	
	(* reserve counter 2 *)
	xImp_Count_2.CLK 	:= bConnectYourBitToCountHere2; 			(* change customized (old: zaehl_2)  *)
	xImp_Count_2;	(* call FUB R_TRIG *)
	
	(* reserve counter 3 *)
	xImp_Count_3.CLK 	:= bConnectYourBitToCountHere3;				(* change customized  (old: zaehl_3) *)
	xImp_Count_3;	(* call FUB R_TRIG *)
	
	(* reserve counter 4 *)
	xImp_Count_4.CLK 	:= bConnectYourBitToCountHere4;  			(* change customized   (old: zaehl_4) *)
	xImp_Count_4;	(* call FUB R_TRIG *)

	(* reserve counter 5 *)
	xImp_Count_5.CLK 	:=  bConnectYourBitToCountHere;					(* change customized *)
	xImp_Count_5;	(* call FUB R_TRIG *)
	
	(* reserve counter 6 *)
	xImp_Count_6.CLK 	:= bConnectYourBitToCountHere; 					(* change customized *)
	xImp_Count_6;	(* call FUB R_TRIG *)
	
	(* reserve counter 7 *)
	xImp_Count_7.CLK 	:= bConnectYourBitToCountHere;					(* change customized *)
	xImp_Count_7;	(* call FUB R_TRIG *)
	
	(* reserve counter 8 *)
	xImp_Count_8.CLK 	:= bConnectYourBitToCountHere;  				(* change customized *)
	xImp_Count_8;	(* call FUB R_TRIG *)

	(* reserve counter 9 *)
	xImp_Count_9.CLK 	:=  bConnectYourBitToCountHere;					(* change customized *)
	xImp_Count_9;	(* call FUB R_TRIG *)
	
	(* reserve counter 10 *)
	xImp_Count_10.CLK 	:=  bConnectYourBitToCountHere1;					(* change customized *)
	xImp_Count_10;	(* call FUB R_TRIG *)

	(***********************************************************************)
	(* extended counter items 11- ONLY FOR USE WITH HMI Extension Package! *)
	(***********************************************************************)

	(* reserve counter 11 *)
	xImp_Count_11.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *) 
	xImp_Count_11;	(* call FUB R_TRIG *)
	
	(* reserve counter 12 *)
	xImp_Count_12.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *)
	xImp_Count_12;	(* call FUB R_TRIG *)
	
	(* reserve counter 13 *)
	xImp_Count_13.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *)
	xImp_Count_13;	(* call FUB R_TRIG *)
	
	(* reserve counter 14 *)
	xImp_Count_14.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *)
	xImp_Count_14;	(* call FUB R_TRIG *)
	
	(* reserve counter 15 *)
	xImp_Count_15.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *)
	xImp_Count_15;	(* call FUB R_TRIG *)
	
	(* reserve counter 16 *)
	xImp_Count_16.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *)
	xImp_Count_16;	(* call FUB R_TRIG *)
	
	(* reserve counter 17 *)
	xImp_Count_17.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *)
	xImp_Count_17;	(* call FUB R_TRIG *)
	
	(* reserve counter 18 *)
	xImp_Count_18.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *)
	xImp_Count_18;	(* call FUB R_TRIG *)
	
	(* reserve counter 19 *)
	xImp_Count_19.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *)
	xImp_Count_19;	(* call FUB R_TRIG *)
	
	(* reserve counter 20 *)
	//	bOpt_10msTaskClock := TRUE;								(* to activate the msec counter function with iCount20 *)
	xImp_Count_20.CLK 	:=  bConnectYourBitToCountHere;			(* change customized *) (* default prepared for speeed measurement msec counter; can be reused for other tasks, if necessary *)
	xImp_Count_20;	(* call FUB R_TRIG *)
	(*10msTaskClock on iCount20, prepared for transmission speeed measurements; can be reused at any time for other tasks on customer engines *)
	IF bOpt_10msTaskClock THEN
		VIS2MM.iCount20 := VIS2MM.iCount20 + 10;  (*in TC#2*) 	(* cycle counter as msec counter function with bOpt_10msTaskClock *)
		IF (tRealTime.hour = 23 AND  tRealTime.minute = 59) THEN	VIS2MM.iCount10 := 0;	END_IF		(* reset daily at midnight *)	
	END_IF	

	(* display operating hour counter - for local display needs only, NOT CHANGEABLE HERE *)
	IN_CU.tImp_OpHour.Do;
	IN_CU.iCnt_OpHours;
	
	(* display start counter - for local needs only, NOT CHANGEABLE HERE  *)
	IN_CU.bImp_Start ;
	IN_CU.iCnt_Starts;


	OUT_CU.bRPM_Count1	:= IN_CU.tImp_OpHour.Do;  (* := bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count1_Act;		(* change customized *)
	OUT_CU.bRPM_Count2	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count2_Act;		(* change customized *)
	OUT_CU.bRPM_Count3	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count3_Act;		(* change customized *)
	OUT_CU.bRPM_Count4	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count4_Act;		(* change customized *)
	OUT_CU.bRPM_Count5	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count5_Act;		(* change customized *)
	OUT_CU.bRPM_Count6	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count6_Act;		(* change customized *)
	OUT_CU.bRPM_Count7	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count7_Act;		(* change customized *)
	OUT_CU.bRPM_Count8	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count8_Act;		(* change customized *)
	OUT_CU.bRPM_Count9	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count9_Act;		(* change customized *)
	OUT_CU.bRPM_Count10	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count10_Act;		(* change customized *)
	OUT_CU.bRPM_Count11	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count11_Act;		(* change customized *)
	OUT_CU.bRPM_Count12	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count12_Act;		(* change customized *)
	OUT_CU.bRPM_Count13	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count13_Act;		(* change customized *)
	OUT_CU.bRPM_Count14	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count14_Act;		(* change customized *)
	OUT_CU.bRPM_Count15	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count15_Act;		(* change customized *)
	OUT_CU.bRPM_Count16	:= bConnectYourBitToStartTimeHere OR IN_CU.bRPM_Count16_Act;		(* change customized *)


	(**********************************************)
	(*****      END OF CONFIGURATION AREA     *****)
	(**********************************************)
	
	(* evaluation operating hour impulse *)
	h_imp(CLK := IN_CU.tImp_OpHour.Do );		
	IF h_imp.Q THEN	(* if an operation hour is finished *)
	

	(* Allow user inputs to the counter values*)
//	IF NOT bBlockCounter_UserInput THEN 
//		IF VIS2MM.iCount1 <> iCount_InputDetect[1] THEN Perm.iCount1 := VIS2MM.iCount1; END_IF		(*detect and process user inputs *)
//		IF VIS2MM.iCount2 <> iCount_InputDetect[2] THEN Perm.iCount2 := VIS2MM.iCount2; END_IF		(*detect and process user inputs *)
//		IF VIS2MM.iCount3 <> iCount_InputDetect[3] THEN Perm.iCount3 := VIS2MM.iCount3; END_IF		(*detect and process user inputs *)
//		IF VIS2MM.iCount4 <> iCount_InputDetect[4] THEN Perm.iCount4 := VIS2MM.iCount4; END_IF		(*detect and process user inputs *)
//	
//	
//		IF VIS2MM.iMaintenanceCount1 <> iMaintenanceCount_InputDetect[1] THEN Perm.iMaintenanceCount1 := VIS2MM.iMaintenanceCount1; END_IF		(*detect and process user inputs *)
//		IF VIS2MM.iMaintenanceCount2 <> iMaintenanceCount_InputDetect[2] THEN Perm.iMaintenanceCount2 := VIS2MM.iMaintenanceCount2; END_IF		(*detect and process user inputs *)
//		IF VIS2MM.iMaintenanceCount3 <> iMaintenanceCount_InputDetect[3] THEN Perm.iMaintenanceCount3 := VIS2MM.iMaintenanceCount3; END_IF		(*detect and process user inputs *)
//		IF VIS2MM.iMaintenanceCount4 <> iMaintenanceCount_InputDetect[4] THEN Perm.iMaintenanceCount4 := VIS2MM.iMaintenanceCount4; END_IF		(*detect and process user inputs *)
//	END_IF


		(* maintenance counter 1 *)
		VIS2MM.iMaintenanceCount1   := VIS2MM.iMaintenanceCount1 - 1;		(* decrease counter *)
		(* check limits *)
		IF VIS2MM.iMaintenanceCount1 >= 1000000000 THEN
			VIS2MM.iMaintenanceCount1 := VIS2MM.iMaintenanceCount1 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iMaintenanceCount1 <= -1000000000 THEN
			VIS2MM.iMaintenanceCount1 := VIS2MM.iMaintenanceCount1 + 1000000000;		(* check lower limit *)
		END_IF;
//		IF 	OUT_CU.iMaintenanceCount1 <> VIS2MM.iMaintenanceCount1 THEN		(*detect counter change*)
			OUT_CU.iMaintenanceCount1		 := VIS2MM.iMaintenanceCount1;
			MM2VIS.iMaintenanceCount1		 := VIS2MM.iMaintenanceCount1;
//			iMaintenanceCount_InputDetect[1] := VIS2MM.iMaintenanceCount1;
//		END_IF
	

		(* maintenance counter 2 *)
		VIS2MM.iMaintenanceCount2   := VIS2MM.iMaintenanceCount2 - 1;		(* decrease counter *)
		(* check limits *)
		IF VIS2MM.iMaintenanceCount2 >= 1000000000 THEN
			VIS2MM.iMaintenanceCount2 := VIS2MM.iMaintenanceCount2 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iMaintenanceCount2 <= -1000000000 THEN
			VIS2MM.iMaintenanceCount2 := VIS2MM.iMaintenanceCount2 + 1000000000;		(* check lower limit *)
		END_IF;
//		IF 	OUT_CU.iMaintenanceCount2 <> VIS2MM.iMaintenanceCount2 THEN		(*detect counter change*)
			OUT_CU.iMaintenanceCount2		 := VIS2MM.iMaintenanceCount2;
			MM2VIS.iMaintenanceCount2		 := VIS2MM.iMaintenanceCount2;
//			iMaintenanceCount_InputDetect[2] := VIS2MM.iMaintenanceCount2;
//		END_IF
	

		(* maintenance counter 3 *)
		VIS2MM.iMaintenanceCount3   := VIS2MM.iMaintenanceCount3 - 1;		(* decrease counter *)
		(* check limits *)
		IF VIS2MM.iMaintenanceCount3 >= 1000000000 THEN
			VIS2MM.iMaintenanceCount3 := VIS2MM.iMaintenanceCount3 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iMaintenanceCount3 <= -1000000000 THEN
			VIS2MM.iMaintenanceCount3 := VIS2MM.iMaintenanceCount3 + 1000000000;		(* check lower limit *)
		END_IF;
//		IF 	OUT_CU.iMaintenanceCount3 <> VIS2MM.iMaintenanceCount3 THEN		(*detect counter change*)
			OUT_CU.iMaintenanceCount3		 := VIS2MM.iMaintenanceCount3;
			MM2VIS.iMaintenanceCount3		 := VIS2MM.iMaintenanceCount3;
//			iMaintenanceCount_InputDetect[3] := VIS2MM.iMaintenanceCount3;
//		END_IF

	
		(* maintenance counter 4 *)
		VIS2MM.iMaintenanceCount4   := VIS2MM.iMaintenanceCount4 - 1;		(* decrease counter *)
		(* check limits *)
		IF VIS2MM.iMaintenanceCount4 >= 1000000000 THEN
			VIS2MM.iMaintenanceCount4 := VIS2MM.iMaintenanceCount4 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iMaintenanceCount4 <= -1000000000 THEN
			VIS2MM.iMaintenanceCount4 := VIS2MM.iMaintenanceCount4 + 1000000000;		(* check lower limit *)
		END_IF;
//		IF 	OUT_CU.iMaintenanceCount4 <> VIS2MM.iMaintenanceCount4 THEN		(*detect counter change*)
			OUT_CU.iMaintenanceCount4		 := VIS2MM.iMaintenanceCount4;
			MM2VIS.iMaintenanceCount4		 := VIS2MM.iMaintenanceCount4;
//			iMaintenanceCount_InputDetect[4] := VIS2MM.iMaintenanceCount4;
//		END_IF

		(* maintenance counter 5 *)
		VIS2MM.iMaintenanceCount5   := VIS2MM.iMaintenanceCount5 - 1;		(* decrease counter *)
		(* check limits *)
		IF VIS2MM.iMaintenanceCount5 >= 1000000000 THEN
			VIS2MM.iMaintenanceCount5 := VIS2MM.iMaintenanceCount5 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iMaintenanceCount5 <= -1000000000 THEN
			VIS2MM.iMaintenanceCount5 := VIS2MM.iMaintenanceCount5 + 1000000000;		(* check lower limit *)
		END_IF;
		OUT_CU.iMaintenanceCount5		 := VIS2MM.iMaintenanceCount5;
		MM2VIS.iMaintenanceCount5		 := VIS2MM.iMaintenanceCount5;

		(* maintenance counter 6 *)
		VIS2MM.iMaintenanceCount6   := VIS2MM.iMaintenanceCount6 - 1;		(* decrease counter *)
		(* check limits *)
		IF VIS2MM.iMaintenanceCount6 >= 1000000000 THEN
			VIS2MM.iMaintenanceCount6 := VIS2MM.iMaintenanceCount6 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iMaintenanceCount6 <= -1000000000 THEN
			VIS2MM.iMaintenanceCount6 := VIS2MM.iMaintenanceCount6 + 1000000000;		(* check lower limit *)
		END_IF;
		OUT_CU.iMaintenanceCount6		 := VIS2MM.iMaintenanceCount6;
		MM2VIS.iMaintenanceCount6		 := VIS2MM.iMaintenanceCount6;
		
		(* maintenance counter 7 *)
		VIS2MM.iMaintenanceCount7   := VIS2MM.iMaintenanceCount7 - 1;		(* decrease counter *)
		(* check limits *)
		IF VIS2MM.iMaintenanceCount7 >= 1000000000 THEN
			VIS2MM.iMaintenanceCount7 := VIS2MM.iMaintenanceCount7 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iMaintenanceCount7 <= -1000000000 THEN
			VIS2MM.iMaintenanceCount7 := VIS2MM.iMaintenanceCount7 + 1000000000;		(* check lower limit *)
		END_IF;
		OUT_CU.iMaintenanceCount7		 := VIS2MM.iMaintenanceCount7;
		MM2VIS.iMaintenanceCount7		 := VIS2MM.iMaintenanceCount7;
		
		(* maintenance counter 8 *)
		VIS2MM.iMaintenanceCount8   := VIS2MM.iMaintenanceCount8 - 1;		(* decrease counter *)
		(* check limits *)
		IF VIS2MM.iMaintenanceCount8 >= 1000000000 THEN
			VIS2MM.iMaintenanceCount8 := VIS2MM.iMaintenanceCount8 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iMaintenanceCount8 <= -1000000000 THEN
			VIS2MM.iMaintenanceCount8 := VIS2MM.iMaintenanceCount8 + 1000000000;		(* check lower limit *)
		END_IF;
		OUT_CU.iMaintenanceCount8		 := VIS2MM.iMaintenanceCount8;
		MM2VIS.iMaintenanceCount8		 := VIS2MM.iMaintenanceCount8;		
	
	END_IF;
	
	
	(* evaluation of the maintenance counter *)
	
	WART := FALSE;	(* prepare evaluation *)
	IF VIS2MM.iMaintenanceCount1 < 1 THEN
		WART := TRUE;		(* group message because of maintenance counter 1 *)
	END_IF;
	IF VIS2MM.iMaintenanceCount2 < 1 THEN
		WART := TRUE;		(* group message because of maintenance counter 2 *)
	END_IF;
	IF VIS2MM.iMaintenanceCount3 < 1 THEN
		WART := TRUE;		(* group message because of maintenance counter 3 *)
	END_IF;
	IF VIS2MM.iMaintenanceCount4 < 1 THEN
		WART := TRUE;		(* group message because of maintenance counter 4 *)
	END_IF;

	IF VIS2MM.iMaintenanceCount5 < 1 THEN
		WART := TRUE;		(* group message because of maintenance counter 51 *)
	END_IF;
	IF VIS2MM.iMaintenanceCount6 < 1 THEN
		WART := TRUE;		(* group message because of maintenance counter 6 *)
	END_IF;
	IF VIS2MM.iMaintenanceCount7 < 1 THEN
		WART := TRUE;		(* group message because of maintenance counter 7 *)
	END_IF;
	IF VIS2MM.iMaintenanceCount8 < 1 THEN
		WART := TRUE;		(* group message because of maintenance counter 8 *)
	END_IF;
		
	OUT_CU.bReqMaintenance := WART;	(*connect new MM Output bit to trigger warning in MM op_state*)

	
	(*Predefinition of new added maintenance counters 5-8*)
	IF 	VIS2MM.iMaintenanceCount5 = 0 AND
		VIS2MM.iMaintenanceCount6 = 0 AND
		VIS2MM.iMaintenanceCount7 = 0 AND
		VIS2MM.iMaintenanceCount8 = 0 AND
		IN_CU.iCnt_OpHours 		<= 10 AND					(*V4.10*)
		IN_CU.iCnt_Starts 		<= 10 AND					(*V4.10*)		
		IN_CU.tPB2MM.bParaSetupOk
	THEN
		VIS2MM.iMaintenanceCount5 := 500000;
		VIS2MM.iMaintenanceCount6 := 600000;
		VIS2MM.iMaintenanceCount7 := 700000;
		VIS2MM.iMaintenanceCount8 := 800000;						
	END_IF
	
	(* evaluation reserve counter *)

	(* reserve counter 1 *)
	IF xImp_Count_1.Q THEN
		(* increase counter *)
		VIS2MM.iCount1 := VIS2MM.iCount1 + 1;
		(* check limits *)
		IF VIS2MM.iCount1 >= 1000000000 THEN
			VIS2MM.iCount1 := VIS2MM.iCount1 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount1 <= -1000000000 THEN
			VIS2MM.iCount1 := VIS2MM.iCount1 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount1			:= VIS2MM.iCount1;
	MM2VIS.iCount1			:= VIS2MM.iCount1;

	
	(* reserve counter 2 *)
	IF xImp_Count_2.Q THEN
		(* increase counter *)
		VIS2MM.iCount2 := VIS2MM.iCount2 + 1;
		(* check limits *)
		IF VIS2MM.iCount2 >= 1000000000 THEN
			VIS2MM.iCount2 := VIS2MM.iCount2 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount2 <= -1000000000 THEN
			VIS2MM.iCount2 := VIS2MM.iCount2 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount2			:= VIS2MM.iCount2;
	MM2VIS.iCount2			:= VIS2MM.iCount2;


	(* reserve counter 3 *)
	IF xImp_Count_3.Q THEN
		(* increase counter *)
		VIS2MM.iCount3 := VIS2MM.iCount3 + 1;
		(* check limits *)
		IF VIS2MM.iCount3 >= 1000000000 THEN
			VIS2MM.iCount3 := VIS2MM.iCount3 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount3 <= -1000000000 THEN
			VIS2MM.iCount3 := VIS2MM.iCount3 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount3			:= VIS2MM.iCount3;
	MM2VIS.iCount3			:= VIS2MM.iCount3;

	
	(* reserve counter 4 *)
	IF xImp_Count_4.Q THEN
		VIS2MM.iCount4 := VIS2MM.iCount4 + 1;
		(* check limits *)
		IF VIS2MM.iCount4 >= 1000000000 THEN
			VIS2MM.iCount4 := VIS2MM.iCount4 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount4 <= -1000000000 THEN
			VIS2MM.iCount4 := VIS2MM.iCount4 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount4			:= VIS2MM.iCount4;
	MM2VIS.iCount4			:= VIS2MM.iCount4;


	(* reserve counter 5 *)
	IF xImp_Count_5.Q THEN
		(* increase counter *)
		VIS2MM.iCount5 := VIS2MM.iCount5 + 1;
		(* check limits *)
		IF VIS2MM.iCount5 >= 1000000000 THEN
			VIS2MM.iCount5 := VIS2MM.iCount5 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount5 <= -1000000000 THEN
			VIS2MM.iCount5 := VIS2MM.iCount5 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount5			:= VIS2MM.iCount5;
	MM2VIS.iCount5			:= VIS2MM.iCount5;

	(* reserve counter 6 *)
	IF xImp_Count_6.Q THEN
		(* increase counter *)
		VIS2MM.iCount6 := VIS2MM.iCount6 + 1;
		(* check limits *)
		IF VIS2MM.iCount6 >= 1000000000 THEN
			VIS2MM.iCount6 := VIS2MM.iCount6 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount6 <= -1000000000 THEN
			VIS2MM.iCount6 := VIS2MM.iCount6 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount6			:= VIS2MM.iCount6;
	MM2VIS.iCount6			:= VIS2MM.iCount6;
	
	(* reserve counter 7 *)
	IF xImp_Count_7.Q THEN
		(* increase counter *)
		VIS2MM.iCount7 := VIS2MM.iCount7 + 1;
		(* check limits *)
		IF VIS2MM.iCount7 >= 1000000000 THEN
			VIS2MM.iCount7 := VIS2MM.iCount7 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount7 <= -1000000000 THEN
			VIS2MM.iCount7 := VIS2MM.iCount7 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount7			:= VIS2MM.iCount7;
	MM2VIS.iCount7			:= VIS2MM.iCount7;

	(* reserve counter 8 *)
	IF xImp_Count_8.Q THEN
		(* increase counter *)
		VIS2MM.iCount8 := VIS2MM.iCount8 + 1;
		(* check limits *)
		IF VIS2MM.iCount8 >= 1000000000 THEN
			VIS2MM.iCount8 := VIS2MM.iCount8 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount8 <= -1000000000 THEN
			VIS2MM.iCount8 := VIS2MM.iCount8 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount8			:= VIS2MM.iCount8;
	MM2VIS.iCount8			:= VIS2MM.iCount8;
	
	
	(* reserve counter 9 *)
	IF xImp_Count_9.Q THEN
		(* increase counter *)
		VIS2MM.iCount9 := VIS2MM.iCount9 + 1;
		(* check limits *)
		IF VIS2MM.iCount9 >= 1000000000 THEN
			VIS2MM.iCount9 := VIS2MM.iCount9 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount9 <= -1000000000 THEN
			VIS2MM.iCount9 := VIS2MM.iCount9 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount9			:= VIS2MM.iCount9;
	MM2VIS.iCount9			:= VIS2MM.iCount9;

	(* reserve counter 10 *)
	IF xImp_Count_10.Q THEN
		(* increase counter *)
		VIS2MM.iCount10 := VIS2MM.iCount10 + 1;
		(* check limits *)
		IF VIS2MM.iCount10 >= 1000000000 THEN
			VIS2MM.iCount10 := VIS2MM.iCount10 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount10 <= -1000000000 THEN
			VIS2MM.iCount10 := VIS2MM.iCount10 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount10			:= VIS2MM.iCount10;
	MM2VIS.iCount10			:= VIS2MM.iCount10;
		

	(* reserve counter 11 *)
	IF xImp_Count_11.Q THEN
		(* increase counter *)
		VIS2MM.iCount11 := VIS2MM.iCount11 + 1;
		(* check limits *)
		IF VIS2MM.iCount11 >= 1000000000 THEN
			VIS2MM.iCount11 := VIS2MM.iCount11 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount11 <= -1000000000 THEN
			VIS2MM.iCount11 := VIS2MM.iCount11 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount11			:= VIS2MM.iCount11;
	MM2VIS.iCount11			:= VIS2MM.iCount11;
	
	(* reserve counter 12 *)
	IF xImp_Count_12.Q THEN
		(* increase counter *)
		VIS2MM.iCount12 := VIS2MM.iCount12 + 1;
		(* check limits *)
		IF VIS2MM.iCount12 >= 1000000000 THEN
			VIS2MM.iCount12 := VIS2MM.iCount12 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount12 <= -1000000000 THEN
			VIS2MM.iCount12 := VIS2MM.iCount12 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount12			:= VIS2MM.iCount12;
	MM2VIS.iCount12			:= VIS2MM.iCount12;
	
	(* reserve counter 13 *)
	IF xImp_Count_13.Q THEN
		(* increase counter *)
		VIS2MM.iCount13 := VIS2MM.iCount13 + 1;
		(* check limits *)
		IF VIS2MM.iCount13 >= 1000000000 THEN
			VIS2MM.iCount13 := VIS2MM.iCount13 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount13 <= -1000000000 THEN
			VIS2MM.iCount13 := VIS2MM.iCount13 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount13			:= VIS2MM.iCount13;
	MM2VIS.iCount13			:= VIS2MM.iCount13;
	
	(* reserve counter 14 *)
	IF xImp_Count_14.Q THEN
		(* increase counter *)
		VIS2MM.iCount14 := VIS2MM.iCount14 + 1;
		(* check limits *)
		IF VIS2MM.iCount14 >= 1000000000 THEN
			VIS2MM.iCount14 := VIS2MM.iCount14 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount14 <= -1000000000 THEN
			VIS2MM.iCount14 := VIS2MM.iCount14 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount14			:= VIS2MM.iCount14;
	MM2VIS.iCount14			:= VIS2MM.iCount14;
	
	(* reserve counter 15 *)
	IF xImp_Count_15.Q THEN
		(* increase counter *)
		VIS2MM.iCount15 := VIS2MM.iCount15 + 1;
		(* check limits *)
		IF VIS2MM.iCount15 >= 1000000000 THEN
			VIS2MM.iCount15 := VIS2MM.iCount15 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount15 <= -1000000000 THEN
			VIS2MM.iCount15 := VIS2MM.iCount15 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount15			:= VIS2MM.iCount15;
	MM2VIS.iCount15			:= VIS2MM.iCount15;
	
	(* reserve counter 16 *)
	IF xImp_Count_16.Q THEN
		(* increase counter *)
		VIS2MM.iCount16 := VIS2MM.iCount16 + 1;
		(* check limits *)
		IF VIS2MM.iCount16 >= 1000000000 THEN
			VIS2MM.iCount16 := VIS2MM.iCount16 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount16 <= -1000000000 THEN
			VIS2MM.iCount16 := VIS2MM.iCount16 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount16			:= VIS2MM.iCount16;
	MM2VIS.iCount16			:= VIS2MM.iCount16;
	
	(* reserve counter 17 *)
	IF xImp_Count_17.Q THEN
		(* increase counter *)
		VIS2MM.iCount17 := VIS2MM.iCount17 + 1;
		(* check limits *)
		IF VIS2MM.iCount17 >= 1000000000 THEN
			VIS2MM.iCount17 := VIS2MM.iCount17 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount17 <= -1000000000 THEN
			VIS2MM.iCount17 := VIS2MM.iCount17 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount17			:= VIS2MM.iCount17;
	MM2VIS.iCount17			:= VIS2MM.iCount17;
	
	(* reserve counter 18 *)
	IF xImp_Count_18.Q THEN
		(* increase counter *)
		VIS2MM.iCount18 := VIS2MM.iCount18 + 1;
		(* check limits *)
		IF VIS2MM.iCount18 >= 1000000000 THEN
			VIS2MM.iCount18 := VIS2MM.iCount18 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount18 <= -1000000000 THEN
			VIS2MM.iCount18 := VIS2MM.iCount18 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount18			:= VIS2MM.iCount18;
	MM2VIS.iCount18			:= VIS2MM.iCount18;
	
	(* reserve counter 19 *)
	IF xImp_Count_19.Q THEN
		(* increase counter *)
		VIS2MM.iCount19 := VIS2MM.iCount19 + 1;
		(* check limits *)
		IF VIS2MM.iCount19 >= 1000000000 THEN
			VIS2MM.iCount19 := VIS2MM.iCount19 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount19 <= -1000000000 THEN
			VIS2MM.iCount19 := VIS2MM.iCount19 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount19			:= VIS2MM.iCount19;
	MM2VIS.iCount19			:= VIS2MM.iCount19;
	
	(* reserve counter 20 *)
	IF xImp_Count_20.Q THEN
		(* increase counter *)
		VIS2MM.iCount20 := VIS2MM.iCount20 + 1;
		(* check limits *)
		IF VIS2MM.iCount20 >= 1000000000 THEN
			VIS2MM.iCount20 := VIS2MM.iCount20 - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCount20 <= -1000000000 THEN
			VIS2MM.iCount20 := VIS2MM.iCount20 + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_CU.iCount20			:= VIS2MM.iCount20;
	MM2VIS.iCount20			:= VIS2MM.iCount20;
	
	
	
	
	
	(* evaluation of the RPM counter *)
	
	IF tRealTime.second <> real_old THEN	(* duration once every second *)
		real_old := tRealTime.second;
	
		IF OUT_CU.iRPS_h = 0 THEN  		(* at 00:00 (RPS) reset of the counters *)
			IF OUT_CU.iRPS_m = 0 THEN
				reset := TRUE;
			END_IF;
		ELSE
			reset := FALSE;
		END_IF;
	
		(* time step 10 sec *)
		treset.IN := reset;
		treset.PT := t#10s;
	
		treset;  (* call FUB TP *)
	
		resetrpm := treset.Q;
		tresetrpm.CLK := resetrpm;
	
		tresetrpm; (* call FUB R_TRIG *)
	
		IF tresetrpm.Q THEN (* reset counters *)
			MM2VIS.tRPM_Count1.count  := 0;
			MM2VIS.tRPM_Count2.count  := 0;
			MM2VIS.tRPM_Count3.count  := 0;
			MM2VIS.tRPM_Count4.count  := 0;
			MM2VIS.tRPM_Count5.count  := 0;
			MM2VIS.tRPM_Count6.count  := 0;
			MM2VIS.tRPM_Count7.count  := 0;
			MM2VIS.tRPM_Count8.count  := 0;
			MM2VIS.tRPM_Count9.count  := 0;
			MM2VIS.tRPM_Count10.count := 0;
			MM2VIS.tRPM_Count11.count := 0;
			MM2VIS.tRPM_Count12.count := 0;
			MM2VIS.tRPM_Count13.count := 0;
			MM2VIS.tRPM_Count14.count := 0;
			MM2VIS.tRPM_Count15.count := 0;
			MM2VIS.tRPM_Count16.count := 0;
		END_IF;
	
		IF OUT_CU.bRPM_Count1 THEN		(* report time measuring 1 *)
			MM2VIS.tRPM_Count1.count := MM2VIS.tRPM_Count1.count + 1;
			IF  NOT resetrpm THEN
				MM2VIS.tRPM_Count1.h := DINT_TO_INT(MM2VIS.tRPM_Count1.count / 3600);
				MM2VIS.tRPM_Count1.m := DINT_TO_INT((MM2VIS.tRPM_Count1.count MOD 3600) / 60);
				MM2VIS.tRPM_Count1.s := DINT_TO_INT(MM2VIS.tRPM_Count1.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count2 THEN		(* report time measuring 2 *)
			MM2VIS.tRPM_Count2.count := MM2VIS.tRPM_Count2.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count2.h := DINT_TO_INT(MM2VIS.tRPM_Count2.count / 3600);
				MM2VIS.tRPM_Count2.m := DINT_TO_INT((MM2VIS.tRPM_Count2.count MOD 3600) / 60);
				MM2VIS.tRPM_Count2.s := DINT_TO_INT(MM2VIS.tRPM_Count2.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count3 THEN		(* report time measuring 3 *)
			MM2VIS.tRPM_Count3.count := MM2VIS.tRPM_Count3.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count3.h := DINT_TO_INT(MM2VIS.tRPM_Count3.count / 3600);
				MM2VIS.tRPM_Count3.m := DINT_TO_INT((MM2VIS.tRPM_Count3.count MOD 3600) / 60);
				MM2VIS.tRPM_Count3.s := DINT_TO_INT(MM2VIS.tRPM_Count3.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count4 THEN		(* report time measuring 4 *)
			MM2VIS.tRPM_Count4.count := MM2VIS.tRPM_Count4.count + 1;
			IF  NOT resetrpm  THEN
				MM2VIS.tRPM_Count4.h := DINT_TO_INT(MM2VIS.tRPM_Count4.count / 3600);
				MM2VIS.tRPM_Count4.m := DINT_TO_INT((MM2VIS.tRPM_Count4.count MOD 3600) / 60);
				MM2VIS.tRPM_Count4.s := DINT_TO_INT(MM2VIS.tRPM_Count4.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count5 THEN		(* report time measuring 5 *)
			MM2VIS.tRPM_Count5.count := MM2VIS.tRPM_Count5.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count5.h := DINT_TO_INT(MM2VIS.tRPM_Count5.count / 3600);
				MM2VIS.tRPM_Count5.m := DINT_TO_INT((MM2VIS.tRPM_Count5.count MOD 3600) / 60);
				MM2VIS.tRPM_Count5.s := DINT_TO_INT(MM2VIS.tRPM_Count5.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count6 THEN		(* report time measuring 6 *)
			MM2VIS.tRPM_Count6.count := MM2VIS.tRPM_Count6.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count6.h := DINT_TO_INT(MM2VIS.tRPM_Count6.count / 3600);
				MM2VIS.tRPM_Count6.m := DINT_TO_INT((MM2VIS.tRPM_Count6.count MOD 3600) / 60);
				MM2VIS.tRPM_Count6.s := DINT_TO_INT(MM2VIS.tRPM_Count6.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count7 THEN		(* report time measuring 7 *)
			MM2VIS.tRPM_Count7.count := MM2VIS.tRPM_Count7.count + 1;
			IF  NOT resetrpm THEN
				MM2VIS.tRPM_Count7.h := DINT_TO_INT(MM2VIS.tRPM_Count7.count / 3600);
				MM2VIS.tRPM_Count7.m := DINT_TO_INT((MM2VIS.tRPM_Count7.count MOD 3600) / 60);
				MM2VIS.tRPM_Count7.s := DINT_TO_INT(MM2VIS.tRPM_Count7.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count8 THEN		(* report time measuring 8 *)
			MM2VIS.tRPM_Count8.count := MM2VIS.tRPM_Count8.count + 1;
			IF  NOT resetrpm THEN
				MM2VIS.tRPM_Count8.h := DINT_TO_INT(MM2VIS.tRPM_Count8.count / 3600);
				MM2VIS.tRPM_Count8.m := DINT_TO_INT((MM2VIS.tRPM_Count8.count MOD 3600) / 60);
				MM2VIS.tRPM_Count8.s := DINT_TO_INT(MM2VIS.tRPM_Count8.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count9 THEN		(* report time measuring 9 *)
			MM2VIS.tRPM_Count9.count := MM2VIS.tRPM_Count9.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count9.h := DINT_TO_INT(MM2VIS.tRPM_Count9.count / 3600);
				MM2VIS.tRPM_Count9.m := DINT_TO_INT((MM2VIS.tRPM_Count9.count MOD 3600) / 60);
				MM2VIS.tRPM_Count9.s := DINT_TO_INT(MM2VIS.tRPM_Count9.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count10 THEN		(* report time measuring 10 *)
			MM2VIS.tRPM_Count10.count := MM2VIS.tRPM_Count10.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count10.h := DINT_TO_INT(MM2VIS.tRPM_Count10.count / 3600);
				MM2VIS.tRPM_Count10.m := DINT_TO_INT((MM2VIS.tRPM_Count10.count MOD 3600) / 60);
				MM2VIS.tRPM_Count10.s := DINT_TO_INT(MM2VIS.tRPM_Count10.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count11 THEN		(* report time measuring 11 *)
			MM2VIS.tRPM_Count11.count := MM2VIS.tRPM_Count11.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count11.h := DINT_TO_INT(MM2VIS.tRPM_Count11.count / 3600);
				MM2VIS.tRPM_Count11.m := DINT_TO_INT((MM2VIS.tRPM_Count11.count MOD 3600) / 60);
				MM2VIS.tRPM_Count11.s := DINT_TO_INT(MM2VIS.tRPM_Count11.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count12 THEN		(* report time measuring 12 *)
			MM2VIS.tRPM_Count12.count := MM2VIS.tRPM_Count12.count + 1;
			IF  NOT resetrpm THEN
				MM2VIS.tRPM_Count12.h := DINT_TO_INT(MM2VIS.tRPM_Count12.count / 3600);
				MM2VIS.tRPM_Count12.m := DINT_TO_INT((MM2VIS.tRPM_Count12.count MOD 3600) / 60);
				MM2VIS.tRPM_Count12.s := DINT_TO_INT(MM2VIS.tRPM_Count12.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count13 THEN		(* report time measuring 13 *)
			MM2VIS.tRPM_Count13.count := MM2VIS.tRPM_Count13.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count13.h := DINT_TO_INT(MM2VIS.tRPM_Count13.count / 3600);
				MM2VIS.tRPM_Count13.m := DINT_TO_INT((MM2VIS.tRPM_Count13.count MOD 3600) / 60);
				MM2VIS.tRPM_Count13.s := DINT_TO_INT(MM2VIS.tRPM_Count13.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count14 THEN		(* report time measuring 14 *)
			MM2VIS.tRPM_Count14.count := MM2VIS.tRPM_Count14.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count14.h := DINT_TO_INT(MM2VIS.tRPM_Count14.count / 3600);
				MM2VIS.tRPM_Count14.m := DINT_TO_INT((MM2VIS.tRPM_Count14.count MOD 3600) / 60);
				MM2VIS.tRPM_Count14.s := DINT_TO_INT(MM2VIS.tRPM_Count14.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count15 THEN		(* report time measuring 15 *)
			MM2VIS.tRPM_Count15.count := MM2VIS.tRPM_Count15.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count15.h := DINT_TO_INT(MM2VIS.tRPM_Count15.count / 3600);
				MM2VIS.tRPM_Count15.m := DINT_TO_INT((MM2VIS.tRPM_Count15.count MOD 3600) / 60);
				MM2VIS.tRPM_Count15.s := DINT_TO_INT(MM2VIS.tRPM_Count15.count MOD 60);
			END_IF;
		END_IF;
	
		IF OUT_CU.bRPM_Count16 THEN		(* report time measuring 16 *)
			MM2VIS.tRPM_Count16.count := MM2VIS.tRPM_Count16.count + 1;
			IF NOT resetrpm THEN
				MM2VIS.tRPM_Count16.h := DINT_TO_INT(MM2VIS.tRPM_Count16.count / 3600);
				MM2VIS.tRPM_Count16.m := DINT_TO_INT((MM2VIS.tRPM_Count16.count MOD 3600) / 60);
				MM2VIS.tRPM_Count16.s := DINT_TO_INT(MM2VIS.tRPM_Count16.count MOD 60);
			END_IF;
		END_IF;
	
	END_IF;
	
	
	
	(********************************************************************************)
	(* setting date and time														*)
	(* The visual display system sets the new time and date						    *)
	(* At the transition of bSetClock form TRUE to FALSE the real time clock of the *)
	(* PLC is set to the date and time form the visual display system				*)
	
// TIME SET NICHT MEHR NOTWENDIG?
//	F_TRIG_GetTime(CLK:=bGetWinClock);			(* trigger to falling edge of dia.ne win time set *)
//	IF bSetClock OR (F_TRIG_GetTime.Q AND NOT bWinFail) THEN
//
//		IF bSetClock THEN
//			tSetTime.year := 2000 + RPS_JAHR2;
//			RPS_JAHR      := tSetTime.year;
//		ELSE
//			tSetTime.year := RPS_JAHR;
//			RPS_JAHR2     := tSetTime.year - 2000;
//		END_IF;
//		tSetTime.month 	:= UINT_TO_USINT(OUT_CU.iRPS_Month);
//		tSetTime.day	:= UINT_TO_USINT(OUT_CU.iRPS_Day);
//		tSetTime.hour	:= UINT_TO_USINT(OUT_CU.iRPS_h);
//		tSetTime.minute	:= UINT_TO_USINT(OUT_CU.iRPS_m);
//		tSetTime.second	:= UINT_TO_USINT(OUT_CU.iRPS_s);
//	
//		(* setting time of the controller *)
//		DTExSetTime_RPS.DT1 := DTStructure_TO_DT(ADR(tSetTime));	(* change format *)
//		DTExSetTime_RPS(enable:=1, DT1:=DTExSetTime_RPS.DT1, Option:= timEXSETTIME_NO_LOGENTRY); (* setting *)
//	
//	END_IF;
	bWinFail := FALSE;		(* reset WIN failure bit *)
	
	
	(* getting time of the controller *)
	
	DTGetTime_RPS(enable:=1);		(* getting *)
	DT_TO_DTStructure(DTGetTime_RPS.DT1, ADR(tRealTime));		(* change format *)
	
	
	(* generate one tick for each second and one tick for each minute 	*)
	(* tick duration is one cycle of task class 3 (= 100 ms)			*)
	IF tRealTime.second <> ucLastSecond THEN		(* second tick *)
		ucLastSecond := tRealTime.second;
		bSecondTick := TRUE;
		IF tRealTime.minute <> ucLastMinute THEN	(* minute tick *)
			ucLastMinute := tRealTime.minute;
			bMinuteTick := TRUE;
		ELSE
			bMinuteTick := FALSE;
		END_IF;
	ELSE
		bSecondTick := FALSE;
	END_IF;
	
	
//	(* get clock from DIA.NE WIN every minute *)
//	
//	IF bWinServerOn AND OUT_CU.iRPS_s = 30 THEN
//		bGetWinClock  := TRUE;
//	END_IF;
//	
//	TON_WinAlive.IN := bGetWinClock OR usSetWinClock = usWinSetValue;
//	TON_WinAlive.PT := T#5s;
//	TON_WinAlive;
//	IF TON_WinAlive.Q THEN
//		bGetWinClock  := FALSE;
//		usSetWinClock := 0;
//		bWinFail      := TRUE;		(* no time change because WIN did not answer within 5 seconds *)
//	END_IF;
	
	
//	(* setting DIA.NE WIN clock if pannel clock will be set *)
//	
//	IF EDGENEG(bSetClock) THEN
//		usSetWinClock := usWinSetValue;
//	END_IF;
	
	
	(* read clock from panel controller *)
	
//	IF bSecondTick AND NOT bSetClock AND usSetWinClock <> usWinSetValue AND NOT bGetWinClock THEN		(* processing every one second *)
//	
//		(* preparation of the RPS time *)
//		RPS_JAHR	:= tRealTime.year;
//		RPS_JAHR2   := RPS_JAHR - 2000; (* for visualising only last 2 digits on the display*)
//		OUT_CU.iRPS_Month		:= tRealTime.month;
//		OUT_CU.iRPS_Day		:= tRealTime.day;
//		RPS_WOTAG	:= tRealTime.reserve;
//		OUT_CU.iRPS_h		:= tRealTime.hour;
//		OUT_CU.iRPS_m		:= tRealTime.minute;
//		OUT_CU.iRPS_s		:= tRealTime.second;
//	
//	END_IF; 		(* end of processing every one second *)
	
	
//	(* preparation of the RPS time *)
//	
//	ulRPSTime := ADR(ucRPSTime);
		
	
	(* end program *)
	
	(* Task outputs *)
		OUT_CU.iCount1;
		OUT_CU.iCount2;
		OUT_CU.iCount3;
		OUT_CU.iCount4;
	
		OUT_CU.iCount5;
		OUT_CU.iCount6;
		OUT_CU.iCount7;
		OUT_CU.iCount8;
		OUT_CU.iCount9;
		OUT_CU.iCount10;
	
		OUT_CU.iCount11;
		OUT_CU.iCount12;
		OUT_CU.iCount13;
		OUT_CU.iCount14;
		OUT_CU.iCount15;
		OUT_CU.iCount16;
		OUT_CU.iCount17;
		OUT_CU.iCount18;
		OUT_CU.iCount19;
		OUT_CU.iCount20;
	
	
		OUT_CU.iMaintenanceCount1;
		OUT_CU.iMaintenanceCount2;
		OUT_CU.iMaintenanceCount3;
		OUT_CU.iMaintenanceCount4;
	
		OUT_CU.iMaintenanceCount5;
		OUT_CU.iMaintenanceCount6;
		OUT_CU.iMaintenanceCount7;
		OUT_CU.iMaintenanceCount8;
	
		OUT_CU.iRPS_Month;		(*obsolete?*)
		OUT_CU.iRPS_Day;		(*obsolete?*)	
		OUT_CU.iRPS_h	;		(*obsolete?*)
		OUT_CU.iRPS_m	;		(*obsolete?*)
		OUT_CU.iRPS_s	;		(*obsolete?*)

END_PROGRAM
