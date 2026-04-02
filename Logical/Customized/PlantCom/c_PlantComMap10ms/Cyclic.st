(*******************************************************************************
Customized Variable mapping for the plant communication

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2024

Customized modifications: -
------------------------
 
History:
-------
V4.14.0	26.11.2024	Astner	Created Task

						
Instructions for use: 
--------------------
Replace the bPlaceholderCustomSignal[x] variable with the variable you want to add to the plant communication.
The GoodQual Value of the Output variables must be always true by default, if additional logic is needed this 
has to be implemented in the software module where the variable is coming from. 
The GoodQual Value of the inputs is set by the communication participant.

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC
	(* Do not exeucte mapping if plant communication is not configured *)
	IF (NOT IN_CU.bPlantComCfgOk) THEN
		RETURN;
	END_IF
	(***************************************************)
	(*** Customized Inputs from the master controls  ***)
	(***************************************************)
	FOR x:=Para.tPlantComm.iMas_Num_Min TO Para.tPlantComm.iMas_Num_Max DO
		(***********************)
		(*** Digital Signals ***)
		(***********************)
		
		(* Reserve Signal 1 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+80].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+80].GoodQual;

		(* Reserve Signal 2 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+81].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+81].GoodQual;

		(* Reserve Signal 3 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+82].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+82].GoodQual;

		(* Reserve Signal 4 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+83].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+83].GoodQual;

		(* Reserve Signal 5 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+84].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+84].GoodQual;

		(* Reserve Signal 6 *)
		bPlaceHolderCustomSignal[x]				:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+85].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+85].GoodQual;

		(* Reserve Signal 7 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+86].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+86].GoodQual;

		(* Reserve Signal 8 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+87].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+87].GoodQual;

		(* Reserve Signal 9 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+88].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+88].GoodQual;

		(* Reserve Signal 10 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+89].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+89].GoodQual;

		(* Reserve Signal 11 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+90].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+90].GoodQual;

		(* Reserve Signal 12 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+91].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+91].GoodQual;

		(* Reserve Signal 13 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+92].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+92].GoodQual;

		(* Reserve Signal 14 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+93].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+93].GoodQual;

		(* Reserve Signal 15 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+94].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+94].GoodQual;

		(* Reserve Signal 16 *)
		bPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+95].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[digOffset+95].GoodQual;
		
		(**********************)
		(*** Analog Signals ***)
		(**********************)
		
		(* Reserve Signal 1 *)
		rPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+40].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+40].GoodQual;

		(* Reserve Signal 2 *)
		rPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+41].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+41].GoodQual;

		(* Reserve Signal 3 *)
		rPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+42].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+42].GoodQual;

		(* Reserve Signal 4 *)
		rPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+43].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+43].GoodQual;

		(* Reserve Signal 5 *)
		rPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+44].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+44].GoodQual;

		(* Reserve Signal 6 *)
		rPlaceHolderCustomSignal[x]	 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+45].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+45].GoodQual;

		(* Reserve Signal 7 *)
		rPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+46].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+46].GoodQual;

		(* Reserve Signal 8 *)
		rPlaceHolderCustomSignal[x] 			:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+47].Value;
		bPlaceHolderCustomSignalGoodQual[x] 	:= IN_CU.tPlantCom_M2E_In_Cust10ms[x].analogSignals[anaOffset+47].GoodQual;
	END_FOR
	
	(*** Customized Outputs to the master controls  ***)
	FOR x:=Para.tPlantComm.iMas_Num_Min TO Para.tPlantComm.iMas_Num_Max DO
		(***********************)
		(*** Digital Signals ***)
		(***********************)
		bPlaceHolderCustomSignal[x] := FALSE;
		(* Reserve Signal 1 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+80].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+80].GoodQual		:= TRUE;

		(* Reserve Signal 2 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+81].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+81].GoodQual		:= TRUE;

		(* Reserve Signal 3 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+82].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+82].GoodQual		:= TRUE;

		(* Reserve Signal 4 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+83].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+83].GoodQual		:= TRUE;

		(* Reserve Signal 5 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+84].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+84].GoodQual		:= TRUE;

		(* Reserve Signal 6 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+85].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+85].GoodQual		:= TRUE;

		(* Reserve Signal 7 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+86].Value			:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+86].GoodQual		:= TRUE;

		(* Reserve Signal 8 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+87].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+87].GoodQual		:= TRUE;

		(* Reserve Signal 9 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+88].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+88].GoodQual		:= TRUE;

		(* Reserve Signal 10 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+89].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+89].GoodQual		:= TRUE;

		(* Reserve Signal 11 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+90].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+90].GoodQual		:= TRUE;

		(* Reserve Signal 12 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+91].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+91].GoodQual		:= TRUE;

		(* Reserve Signal 13 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+92].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+92].GoodQual		:= TRUE;

		(* Reserve Signal 14 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+93].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+93].GoodQual		:= TRUE;

		(* Reserve Signal 15 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+94].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+94].GoodQual		:= TRUE;

		(* Reserve Signal 16 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+95].Value 		:= bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[digOffset+95].GoodQual		:= TRUE;
		
		(**********************)
		(*** Analog Signals ***)
		(**********************)
		rPlaceHolderCustomSignal[x] := 0.0;
		(* Reserve Signal 1 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+40].Value 		:= rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+40].GoodQual	:= TRUE;

		(* Reserve Signal 2 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+41].Value 		:= rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+41].GoodQual	:= TRUE;

		(* Reserve Signal 3 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+42].Value 		:= rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+42].GoodQual	:= TRUE;

		(* Reserve Signal 4 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+43].Value 		:= rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+43].GoodQual	:= TRUE;

		(* Reserve Signal 5 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+44].Value 		:= rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+44].GoodQual	:= TRUE;

		(* Reserve Signal 6 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+45].Value 		:= rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+45].GoodQual	:= TRUE;

		(* Reserve Signal 7 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+46].Value 		:= rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+46].GoodQual	:= TRUE;

		(* Reserve Signal 8 *)
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+47].Value 		:= rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[anaOffset+47].GoodQual	:= TRUE;
	END_FOR
	
	(*** Customized Inputs from the other engines ***)
	FOR x:=Para.tPlantComm.iEng_Num_Min TO Para.tPlantComm.iEng_Num_Max DO
		(***********************)
		(*** Digital Signals ***)
		(***********************)
		
		(* Reserve Signal 1 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+80].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+80].GoodQual;

		(* Reserve Signal 2 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+81].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+81].GoodQual;

		(* Reserve Signal 3 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+82].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+82].GoodQual;

		(* Reserve Signal 4 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+83].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+83].GoodQual;

		(* Reserve Signal 5 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+84].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+84].GoodQual;

		(* Reserve Signal 6 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+85].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+85].GoodQual;

		(* Reserve Signal 7 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+86].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+86].GoodQual;

		(* Reserve Signal 8 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+87].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+87].GoodQual;

		(* Reserve Signal 9 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+88].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+88].GoodQual;

		(* Reserve Signal 10 *)
		bPlaceHolderCustomSignal[x] 				:=	IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+89].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+89].GoodQual;

		(* Reserve Signal 11 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+90].Value;
		bPlaceHolderCustomSignalGoodQual[x]			:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+90].GoodQual;

		(* Reserve Signal 12 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+91].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+91].GoodQual;

		(* Reserve Signal 13 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+92].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+92].GoodQual;

		(* Reserve Signal 14 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+93].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+93].GoodQual;

		(* Reserve Signal 15 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+94].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+94].GoodQual;

		(* Reserve Signal 16 *)
		bPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+95].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[digOffset+95].GoodQual;
		
		(**********************)
		(*** Analog Signals ***)
		(**********************)
		
		(* Reserve Signal 1 *)
		rPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+40].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+40].GoodQual;

		(* Reserve Signal 2 *)
		rPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+41].Value;
		bPlaceHolderCustomSignalGoodQual[x]			:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+41].GoodQual;

		(* Reserve Signal 3 *)
		rPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+42].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+42].GoodQual;

		(* Reserve Signal 4 *)
		rPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+43].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+43].GoodQual;

		(* Reserve Signal 5 *)
		rPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+44].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+44].GoodQual;

		(* Reserve Signal 6 *)
		rPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+45].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+45].GoodQual;

		(* Reserve Signal 7 *)
		rPlaceHolderCustomSignal[x] 				:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+46].Value;
		bPlaceHolderCustomSignalGoodQual[x]			:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+46].GoodQual;

		(* Reserve Signal 8 *)
		rPlaceHolderCustomSignal[x]					:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+47].Value;
		bPlaceHolderCustomSignalGoodQual[x] 		:= IN_CU.tPlantCom_E2E_In_Cust10ms[x].analogSignals[anaOffset+47].GoodQual;
	END_FOR
	
	(*** Customized Outputs to the other engines ***)
	
	(***********************)
	(*** Digital Signals ***)
	(***********************)
	bPlaceHolderCustomSignal[0] := FALSE;
	(* Reserve Signal 1 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+80].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+80].GoodQual 		:= TRUE;

	(* Reserve Signal 2 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+81].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+81].GoodQual 		:= TRUE;

	(* Reserve Signal 3 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+82].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+82].GoodQual 		:= TRUE;

	(* Reserve Signal 4 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+83].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+83].GoodQual 		:= TRUE;

	(* Reserve Signal 5 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+84].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+84].GoodQual 		:= TRUE;

	(* Reserve Signal 6 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+85].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+85].GoodQual 		:= TRUE;

	(* Reserve Signal 7 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+86].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+86].GoodQual 		:= TRUE;

	(* Reserve Signal 8 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+87].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+87].GoodQual 		:= TRUE;

	(* Reserve Signal 9 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+88].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+88].GoodQual 		:= TRUE;

	(* Reserve Signal 10 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+89].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+89].GoodQual 		:= TRUE;

	(* Reserve Signal 11 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+90].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+90].GoodQual 		:= TRUE;

	(* Reserve Signal 12 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+91].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+91].GoodQual 		:= TRUE;

	(* Reserve Signal 13 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+92].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+92].GoodQual 		:= TRUE;

	(* Reserve Signal 14 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+93].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+93].GoodQual 		:= TRUE;

	(* Reserve Signal 15 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+94].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+94].GoodQual 		:= TRUE;

	(* Reserve Signal 16 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+95].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.digitalSignals[digOffset+95].GoodQual 		:= TRUE;
	
	(**********************)
	(*** Analog Signals ***)
	(**********************)
	rPlaceHolderCustomSignal[0] := 0.00;
	(* Reserve Signal 1 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+40].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+40].GoodQual 			:= TRUE;

	(* Reserve Signal 2 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+41].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+41].GoodQual 			:= TRUE;

	(* Reserve Signal 3 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+42].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+42].GoodQual 			:= TRUE;

	(* Reserve Signal 4 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+43].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+43].GoodQual 			:= TRUE;

	(* Reserve Signal 5 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+44].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+44].GoodQual 			:= TRUE;

	(* Reserve Signal 6 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+45].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+45].GoodQual 			:= TRUE;

	(* Reserve Signal 7 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+46].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+46].GoodQual 			:= TRUE;

	(* Reserve Signal 8 *)
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+47].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust10ms.analogSignals[anaOffset+47].GoodQual 			:= TRUE;
	
END_PROGRAM
