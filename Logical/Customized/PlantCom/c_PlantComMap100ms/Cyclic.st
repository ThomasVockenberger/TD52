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
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+32].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+32].GoodQual;

		(* Reserve Signal 2 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+33].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+33].GoodQual;

		(* Reserve Signal 3 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+34].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+34].GoodQual;

		(* Reserve Signal 4 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+35].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+35].GoodQual;

		(* Reserve Signal 5 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+36].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+36].GoodQual;

		(* Reserve Signal 6 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+37].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+37].GoodQual;

		(* Reserve Signal 7 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+38].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+38].GoodQual;

		(* Reserve Signal 8 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+39].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+39].GoodQual;

		(* Reserve Signal 9 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+40].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+40].GoodQual;

		(* Reserve Signal 10 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+41].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+41].GoodQual;

		(* Reserve Signal 11 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+42].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+42].GoodQual;

		(* Reserve Signal 12 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+43].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+43].GoodQual;

		(* Reserve Signal 13 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+44].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+44].GoodQual;

		(* Reserve Signal 14 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+45].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+45].GoodQual;

		(* Reserve Signal 15 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+46].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+46].GoodQual;

		(* Reserve Signal 16 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+47].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+47].GoodQual;

		(* Reserve Signal 17 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+48].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+48].GoodQual;

		(* Reserve Signal 18 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+49].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+49].GoodQual;

		(* Reserve Signal 19 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+50].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+50].GoodQual;

		(* Reserve Signal 20 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+51].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+51].GoodQual;

		(* Reserve Signal 21 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+52].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+52].GoodQual;

		(* Reserve Signal 22 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+53].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+53].GoodQual;

		(* Reserve Signal 23 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+54].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+54].GoodQual;

		(* Reserve Signal 24 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+55].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+55].GoodQual;

		(* Reserve Signal 25 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+56].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+56].GoodQual;

		(* Reserve Signal 26 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+57].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+57].GoodQual;

		(* Reserve Signal 27 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+58].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+58].GoodQual;

		(* Reserve Signal 28 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+59].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+59].GoodQual;

		(* Reserve Signal 29 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+60].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+60].GoodQual;

		(* Reserve Signal 30 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+61].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+61].GoodQual;

		(* Reserve Signal 31 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+62].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+62].GoodQual;

		(* Reserve Signal 32 *)
		bPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+63].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[digOffset+63].GoodQual;
		
		(**********************)
		(*** Analog Signals ***)
		(**********************)
		
		(* Reserve Signal 1 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+16].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+16].GoodQual;

		(* Reserve Signal 2 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+17].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+17].GoodQual;

		(* Reserve Signal 3 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+18].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+18].GoodQual;

		(* Reserve Signal 4 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+19].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+19].GoodQual;

		(* Reserve Signal 5 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+20].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+20].GoodQual;

		(* Reserve Signal 6 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+21].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+21].GoodQual;

		(* Reserve Signal 7 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+22].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+22].GoodQual;

		(* Reserve Signal 8 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+23].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+23].GoodQual;

		(* Reserve Signal 9 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+24].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+24].GoodQual;

		(* Reserve Signal 10 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+25].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+25].GoodQual;

		(* Reserve Signal 11 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+26].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+26].GoodQual;

		(* Reserve Signal 12 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+27].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+27].GoodQual;

		(* Reserve Signal 13 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+28].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+28].GoodQual;

		(* Reserve Signal 14 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+29].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+29].GoodQual;

		(* Reserve Signal 15 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+30].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+30].GoodQual;

		(* Reserve Signal 16 *)
		rPlaceHolderCustomSignal[x]             := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+31].Value;
		bPlaceHolderCustomSignalGoodQual[x]     := IN_CU.tPlantCom_M2E_In_Cust100ms[x].analogSignals[anaOffset+31].GoodQual;
	END_FOR
	
	(*** Customized Outputs to the master controls  ***)
	FOR x:=Para.tPlantComm.iMas_Num_Min TO Para.tPlantComm.iMas_Num_Max DO
		(***********************)
		(*** Digital Signals ***)
		(***********************)
		bPlaceHolderCustomSignal[x] := FALSE;
		(* Reserve Signal 1 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+32].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+32].GoodQual       := TRUE;

		(* Reserve Signal 2 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+33].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+33].GoodQual       := TRUE;

		(* Reserve Signal 3 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+34].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+34].GoodQual       := TRUE;

		(* Reserve Signal 4 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+35].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+35].GoodQual       := TRUE;

		(* Reserve Signal 5 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+36].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+36].GoodQual       := TRUE;

		(* Reserve Signal 6 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+37].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+37].GoodQual       := TRUE;

		(* Reserve Signal 7 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+38].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+38].GoodQual       := TRUE;

		(* Reserve Signal 8 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+39].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+39].GoodQual       := TRUE;

		(* Reserve Signal 9 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+40].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+40].GoodQual       := TRUE;

		(* Reserve Signal 10 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+41].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+41].GoodQual       := TRUE;

		(* Reserve Signal 11 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+42].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+42].GoodQual       := TRUE;

		(* Reserve Signal 12 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+43].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+43].GoodQual       := TRUE;

		(* Reserve Signal 13 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+44].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+44].GoodQual       := TRUE;

		(* Reserve Signal 14 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+45].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+45].GoodQual       := TRUE;

		(* Reserve Signal 15 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+46].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+46].GoodQual       := TRUE;

		(* Reserve Signal 16 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+47].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+47].GoodQual       := TRUE;

		(* Reserve Signal 17 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+48].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+48].GoodQual       := TRUE;

		(* Reserve Signal 18 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+49].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+49].GoodQual       := TRUE;

		(* Reserve Signal 19 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+50].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+50].GoodQual       := TRUE;

		(* Reserve Signal 20 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+51].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+51].GoodQual       := TRUE;

		(* Reserve Signal 21 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+52].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+52].GoodQual       := TRUE;

		(* Reserve Signal 22 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+53].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+53].GoodQual       := TRUE;

		(* Reserve Signal 23 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+54].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+54].GoodQual       := TRUE;

		(* Reserve Signal 24 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+55].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+55].GoodQual       := TRUE;

		(* Reserve Signal 25 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+56].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+56].GoodQual       := TRUE;

		(* Reserve Signal 26 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+57].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+57].GoodQual       := TRUE;

		(* Reserve Signal 27 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+58].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+58].GoodQual       := TRUE;

		(* Reserve Signal 28 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+59].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+59].GoodQual       := TRUE;

		(* Reserve Signal 29 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+60].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+60].GoodQual       := TRUE;

		(* Reserve Signal 30 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+61].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+61].GoodQual       := TRUE;

		(* Reserve Signal 31 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+62].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+62].GoodQual       := TRUE;

		(* Reserve Signal 32 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+63].Value          := bPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[digOffset+63].GoodQual       := TRUE;
		
		(**********************)
		(*** Analog Signals ***)
		(**********************)
		rPlaceHolderCustomSignal[x] := 0.0;
		(* Reserve Signal 1 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+16].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+16].GoodQual       := TRUE;

		(* Reserve Signal 2 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+17].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+17].GoodQual       := TRUE;

		(* Reserve Signal 3 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+18].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+18].GoodQual       := TRUE;

		(* Reserve Signal 4 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+19].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+19].GoodQual       := TRUE;

		(* Reserve Signal 5 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+20].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+20].GoodQual       := TRUE;

		(* Reserve Signal 6 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+21].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+21].GoodQual       := TRUE;

		(* Reserve Signal 7 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+22].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+22].GoodQual       := TRUE;

		(* Reserve Signal 8 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+23].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+23].GoodQual       := TRUE;

		(* Reserve Signal 9 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+24].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+24].GoodQual       := TRUE;

		(* Reserve Signal 10 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+25].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+25].GoodQual       := TRUE;

		(* Reserve Signal 11 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+26].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+26].GoodQual       := TRUE;

		(* Reserve Signal 12 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+27].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+27].GoodQual       := TRUE;

		(* Reserve Signal 13 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+28].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+28].GoodQual       := TRUE;

		(* Reserve Signal 14 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+29].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+29].GoodQual       := TRUE;

		(* Reserve Signal 15 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+30].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+30].GoodQual       := TRUE;

		(* Reserve Signal 16 *)
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+31].Value          := rPlaceHolderCustomSignal[x];
		OUT_CU.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[anaOffset+31].GoodQual       := TRUE;
	END_FOR
	
	(*** Customized Inputs from the other engines ***)
	FOR x:=Para.tPlantComm.iEng_Num_Min TO Para.tPlantComm.iEng_Num_Max DO
		(***********************)
		(*** Digital Signals ***)
		(***********************)
		
		(* Reserve Signal 1 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+32].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+32].GoodQual;

		(* Reserve Signal 2 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+33].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+33].GoodQual;

		(* Reserve Signal 3 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+34].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+34].GoodQual;

		(* Reserve Signal 4 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+35].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+35].GoodQual;

		(* Reserve Signal 5 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+36].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+36].GoodQual;

		(* Reserve Signal 6 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+37].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+37].GoodQual;

		(* Reserve Signal 7 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+38].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+38].GoodQual;

		(* Reserve Signal 8 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+39].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+39].GoodQual;

		(* Reserve Signal 9 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+40].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+40].GoodQual;

		(* Reserve Signal 10 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+41].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+41].GoodQual;

		(* Reserve Signal 11 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+42].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+42].GoodQual;

		(* Reserve Signal 12 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+43].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+43].GoodQual;

		(* Reserve Signal 13 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+44].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+44].GoodQual;

		(* Reserve Signal 14 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+45].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+45].GoodQual;

		(* Reserve Signal 15 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+46].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+46].GoodQual;

		(* Reserve Signal 16 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+47].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+47].GoodQual;

		(* Reserve Signal 17 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+48].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+48].GoodQual;

		(* Reserve Signal 18 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+49].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+49].GoodQual;

		(* Reserve Signal 19 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+50].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+50].GoodQual;

		(* Reserve Signal 20 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+51].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+51].GoodQual;

		(* Reserve Signal 21 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+52].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+52].GoodQual;

		(* Reserve Signal 22 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+53].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+53].GoodQual;

		(* Reserve Signal 23 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+54].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+54].GoodQual;

		(* Reserve Signal 24 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+55].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+55].GoodQual;

		(* Reserve Signal 25 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+56].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+56].GoodQual;

		(* Reserve Signal 26 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+57].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+57].GoodQual;

		(* Reserve Signal 27 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+58].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+58].GoodQual;

		(* Reserve Signal 28 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+59].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+59].GoodQual;

		(* Reserve Signal 29 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+60].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+60].GoodQual;

		(* Reserve Signal 30 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+61].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+61].GoodQual;

		(* Reserve Signal 31 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+62].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+62].GoodQual;

		(* Reserve Signal 32 *)
		bPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+63].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[digOffset+63].GoodQual;
		
		(**********************)
		(*** Analog Signals ***)
		(**********************)
		
		(* Reserve Signal 1 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+16].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+16].GoodQual;

		(* Reserve Signal 2 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+17].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+17].GoodQual;

		(* Reserve Signal 3 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+18].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+18].GoodQual;

		(* Reserve Signal 4 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+19].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+19].GoodQual;

		(* Reserve Signal 5 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+20].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+20].GoodQual;

		(* Reserve Signal 6 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+21].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+21].GoodQual;

		(* Reserve Signal 7 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+22].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+22].GoodQual;

		(* Reserve Signal 8 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+23].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+23].GoodQual;

		(* Reserve Signal 9 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+24].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+24].GoodQual;

		(* Reserve Signal 10 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+25].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+25].GoodQual;

		(* Reserve Signal 11 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+26].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+26].GoodQual;

		(* Reserve Signal 12 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+27].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+27].GoodQual;

		(* Reserve Signal 13 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+28].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+28].GoodQual;

		(* Reserve Signal 14 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+29].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+29].GoodQual;

		(* Reserve Signal 15 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+30].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+30].GoodQual;

		(* Reserve Signal 16 *)
		rPlaceHolderCustomSignal[x]                     := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+31].Value;
		bPlaceHolderCustomSignalGoodQual[x]             := IN_CU.tPlantCom_E2E_In_Cust100ms[x].analogSignals[anaOffset+31].GoodQual;
	END_FOR
	
	(*** Customized Outputs to the other engines ***)
	
	(***********************)
	(*** Digital Signals ***)
	(***********************)
	bPlaceHolderCustomSignal[0] := FALSE;
	
	(* Reserve Signal 1 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+32].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+32].GoodQual 		:= TRUE;

	(* Reserve Signal 2 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+33].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+33].GoodQual 		:= TRUE;

	(* Reserve Signal 3 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+34].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+34].GoodQual 		:= TRUE;

	(* Reserve Signal 4 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+35].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+35].GoodQual 		:= TRUE;

	(* Reserve Signal 5 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+36].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+36].GoodQual 		:= TRUE;

	(* Reserve Signal 6 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+37].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+37].GoodQual 		:= TRUE;

	(* Reserve Signal 7 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+38].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+38].GoodQual 		:= TRUE;

	(* Reserve Signal 8 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+39].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+39].GoodQual 		:= TRUE;

	(* Reserve Signal 9 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+40].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+40].GoodQual 		:= TRUE;

	(* Reserve Signal 10 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+41].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+41].GoodQual 		:= TRUE;

	(* Reserve Signal 11 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+42].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+42].GoodQual 		:= TRUE;

	(* Reserve Signal 12 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+43].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+43].GoodQual 		:= TRUE;

	(* Reserve Signal 13 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+44].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+44].GoodQual 		:= TRUE;

	(* Reserve Signal 14 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+45].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+45].GoodQual 		:= TRUE;

	(* Reserve Signal 15 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+46].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+46].GoodQual 		:= TRUE;

	(* Reserve Signal 16 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+47].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+47].GoodQual 		:= TRUE;
	
	(* Reserve Signal 17 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+48].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+48].GoodQual 		:= TRUE;
	
	(* Reserve Signal 18 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+49].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+49].GoodQual 		:= TRUE;
	
	(* Reserve Signal 19 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+50].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+50].GoodQual 		:= TRUE;

	(* Reserve Signal 20 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+51].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+51].GoodQual 		:= TRUE;

	(* Reserve Signal 21 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+52].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+52].GoodQual 		:= TRUE;

	(* Reserve Signal 22 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+53].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+53].GoodQual 		:= TRUE;

	(* Reserve Signal 23 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+54].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+54].GoodQual 		:= TRUE;

	(* Reserve Signal 24 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+55].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+55].GoodQual 		:= TRUE;

	(* Reserve Signal 25 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+56].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+56].GoodQual 		:= TRUE;

	(* Reserve Signal 26 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+57].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+57].GoodQual 		:= TRUE;

	(* Reserve Signal 27 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+58].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+58].GoodQual 		:= TRUE;

	(* Reserve Signal 28 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+59].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+59].GoodQual 		:= TRUE;

	(* Reserve Signal 29 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+60].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+60].GoodQual 		:= TRUE;

	(* Reserve Signal 30 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+61].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+61].GoodQual 		:= TRUE;

	(* Reserve Signal 31 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+62].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+62].GoodQual 		:= TRUE;

	(* Reserve Signal 32 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+63].Value 			:= bPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.digitalSignals[digOffset+63].GoodQual 		:= TRUE;
	
	(**********************)
	(*** Analog Signals ***)
	(**********************)
	
	rPlaceHolderCustomSignal[0] := 0.0;
	
	(* Reserve Signal 1 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+16].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+16].GoodQual 		:= TRUE;

	(* Reserve Signal 2 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+17].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+17].GoodQual 		:= TRUE;

	(* Reserve Signal 3 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+18].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+18].GoodQual 		:= TRUE;

	(* Reserve Signal 4 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+19].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+19].GoodQual 		:= TRUE;

	(* Reserve Signal 5 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+20].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+20].GoodQual 		:= TRUE;

	(* Reserve Signal 6 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+21].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+21].GoodQual 		:= TRUE;

	(* Reserve Signal 7 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+22].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+22].GoodQual 		:= TRUE;

	(* Reserve Signal 8 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+23].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+23].GoodQual 		:= TRUE;
	
	(* Reserve Signal 9 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+24].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+24].GoodQual 		:= TRUE;

	(* Reserve Signal 10 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+25].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+25].GoodQual 		:= TRUE;

	(* Reserve Signal 11 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+26].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+26].GoodQual 		:= TRUE;

	(* Reserve Signal 12 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+27].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+27].GoodQual 		:= TRUE;

	(* Reserve Signal 13 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+28].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+28].GoodQual 		:= TRUE;
	(* Reserve Signal 14 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+29].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+29].GoodQual 		:= TRUE;

	(* Reserve Signal 15 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+30].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+30].GoodQual 		:= TRUE;
	(* Reserve Signal 16 *)
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+31].Value 			:= rPlaceHolderCustomSignal[0];
	OUT_CU.tPlantCom_E2E_Out_Cust100ms.analogSignals[anaOffset+31].GoodQual 		:= TRUE;
	
END_PROGRAM
