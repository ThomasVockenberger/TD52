(*******************************************************************************
IO Interface from/to variables to/from Plant Communication

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
New signals for the plant communication can be added in this task.
IMPORTANT: The GoodQual Value for the outputs always has to be true by default. 
Otherwise the goodqual logic has to be implemented in the correspondig softwaremodule where the variable is coming from.
The GoodQual Value for the inputs is always true by default if the communication is working without interruptions, it is reset to false if the communication stops working.

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC
	(* Exit if configuration fails or not active *)
	IF (NOT MM2VIS.tPlantComm.bCfg_OK OR NOT Para.tPlantComm.bActive) THEN
		RETURN;
	END_IF;

	(***********************)
	(* Inputs from Masters *)
	(***********************)
	
	(*** 32 Fast Digital Inputs ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		(* Demand generator excitation off *)
		IF (NOT tDemGenExcOff.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[64]) THEN
			tDemGenExcOff.Di 		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[64].Value;
			tDemGenExcOff.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[64].GoodQual;
			tDemGenExcOff.Exist 	:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[64] := TRUE;
		END_IF
		(* Other generator breakers open *)
		IF (NOT tGCB_AGO.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[65]) THEN
			tGCB_AGO.Di				:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[65].Value;
			tGCB_AGO.GoodQual		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[65].GoodQual;
			tGCB_AGO.Exist 			:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[65] := TRUE;
		END_IF
		(* Generator breaker closed and demanded *)
		IF (NOT tGCB_OGP.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[66]) THEN
			tGCB_OGP.Di				:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[66].Value;
			tGCB_OGP.GoodQual		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[66].GoodQual;
			tGCB_OGP.Exist			:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[66] := TRUE;
		END_IF
		(* Demand island mode *)
		IF (NOT tEngDemIsland.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[67]) THEN
			tEngDemIsland.Di		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[67].Value;
			tEngDemIsland.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[67].GoodQual;
			tEngDemIsland.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[67] := TRUE;
		END_IF
		(*
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[68].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[68].GoodQual;
	
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[69].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[69].GoodQual;
	
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[70].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[70].GoodQual;
	
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[71].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[71].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[72].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[72].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[73].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[73].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[74].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[74].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[75].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[75].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[76].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[76].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[77].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[77].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[78].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[78].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[79].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[79].GoodQual;
		*)
		
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[0].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[80].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[0].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[80].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[1].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[81].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[1].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[81].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[2].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[82].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[2].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[82].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[3].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[83].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[3].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[83].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[4].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[84].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[4].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[84].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[5].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[85].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[5].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[85].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[6].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[86].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[6].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[86].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[7].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[87].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[7].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[87].GoodQual;
		
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[8].Value 		:= tPlantCom_M2E_In_Plc[x].digitalSignals[88].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[8].GoodQual 		:= tPlantCom_M2E_In_Plc[x].digitalSignals[88].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[9].Value			:= tPlantCom_M2E_In_Plc[x].digitalSignals[89].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[9].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[89].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[10].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[90].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[10].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[90].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[11].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[91].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[11].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[91].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[12].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[92].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[12].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[92].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[13].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[93].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[13].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[93].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[14].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[94].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[14].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[94].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[15].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[95].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].digitalSignals[15].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[95].GoodQual;
	END_FOR
	
	(*** 16 Fast Analog Inputs ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		;
		(*
		:= tPlantCom_M2E_In_Plc[x].analogSignals[32].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[32].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[33].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[33].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[34].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[34].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[35].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[35].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[36].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[36].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[37].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[37].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[38].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[38].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[39].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[39].GoodQual;
		*)
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[0].Value 			:= tPlantCom_M2E_In_Plc[x].analogSignals[40].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[0].GoodQual		:= tPlantCom_M2E_In_Plc[x].analogSignals[40].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[1].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[41].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[1].GoodQual		:= tPlantCom_M2E_In_Plc[x].analogSignals[41].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[2].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[42].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[2].GoodQual		:= tPlantCom_M2E_In_Plc[x].analogSignals[42].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[3].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[43].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[3].GoodQual		:= tPlantCom_M2E_In_Plc[x].analogSignals[43].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[4].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[44].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[4].GoodQual		:= tPlantCom_M2E_In_Plc[x].analogSignals[44].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[5].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[45].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[5].GoodQual		:= tPlantCom_M2E_In_Plc[x].analogSignals[45].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[6].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[46].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[6].GoodQual		:= tPlantCom_M2E_In_Plc[x].analogSignals[46].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[7].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[47].Value;
		OUT_HA.tPlantCom_M2E_In_Cust10ms[x].analogSignals[7].GoodQual		:= tPlantCom_M2E_In_Plc[x].analogSignals[47].GoodQual;
	END_FOR
		
	(***********************)
	(* Inputs from Engines *)
	(***********************)

	(*** 32 Fast Digital Inputs ***)
	FOR x:=iEngNumMin TO iEngNumMax DO
		(* 
		:=	tPlantCom_E2E_In_Plc[x].digitalSignals[64].Value;
		:=	tPlantCom_E2E_In_Plc[x].digitalSignals[64].GoodQual;
	
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[65].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[65].GoodQual;
	
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[66].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[66].GoodQual;
	
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[67].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[67].GoodQual;
	
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[68].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[68].GoodQual;
	
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[69].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[69].GoodQual;
	
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[70].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[70].GoodQual;
	
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[71].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[71].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[72].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[72].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[73].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[73].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[74].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[74].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[75].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[75].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[76].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[76].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[77].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[77].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[78].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[78].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[79].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[79].GoodQual;
		*)
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[0].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[80].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[0].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[80].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[1].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[81].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[1].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[81].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[2].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[82].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[2].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[82].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[3].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[83].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[3].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[83].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[4].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[84].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[4].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[84].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[5].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[85].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[5].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[85].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[6].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[86].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[6].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[86].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[7].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[87].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[7].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[87].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[8].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[88].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[8].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[88].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[9].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[89].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[9].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[89].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[10].Value		:= tPlantCom_E2E_In_Plc[x].digitalSignals[90].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[10].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[90].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[11].Value		:= tPlantCom_E2E_In_Plc[x].digitalSignals[91].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[11].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[91].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[12].Value		:= tPlantCom_E2E_In_Plc[x].digitalSignals[92].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[12].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[92].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[13].Value		:= tPlantCom_E2E_In_Plc[x].digitalSignals[93].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[13].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[93].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[14].Value		:= tPlantCom_E2E_In_Plc[x].digitalSignals[94].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[14].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[94].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[15].Value		:= tPlantCom_E2E_In_Plc[x].digitalSignals[95].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].digitalSignals[15].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[95].GoodQual;
	END_FOR

	(***16 Fast Analog Inputs ***)
	FOR x:=iEngNumMin TO iEngNumMax DO
		(* Loadsharing line *)
		IF (TRUE) THEN
			// Software implementation to be done
			tPlantCom_E2E_In_Plc[x].analogSignals[32].Value;
			tPlantCom_E2E_In_Plc[x].analogSignals[32].GoodQual;
			tLSL_In;
		END_IF
		(*
		:= tPlantCom_E2E_In_Plc[x].analogSignals[33].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[33].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[34].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[34].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[35].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[35].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[36].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[36].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[37].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[37].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[38].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[38].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[39].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[39].GoodQual;
		*)
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[0].Value			:= tPlantCom_E2E_In_Plc[x].analogSignals[40].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[0].GoodQual		:= tPlantCom_E2E_In_Plc[x].analogSignals[40].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[1].Value			:= tPlantCom_E2E_In_Plc[x].analogSignals[41].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[1].GoodQual		:= tPlantCom_E2E_In_Plc[x].analogSignals[41].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[2].Value			:= tPlantCom_E2E_In_Plc[x].analogSignals[42].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[2].GoodQual		:= tPlantCom_E2E_In_Plc[x].analogSignals[42].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[3].Value			:= tPlantCom_E2E_In_Plc[x].analogSignals[43].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[3].GoodQual		:= tPlantCom_E2E_In_Plc[x].analogSignals[43].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[4].Value			:= tPlantCom_E2E_In_Plc[x].analogSignals[44].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[4].GoodQual		:= tPlantCom_E2E_In_Plc[x].analogSignals[44].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[5].Value			:= tPlantCom_E2E_In_Plc[x].analogSignals[45].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[5].GoodQual		:= tPlantCom_E2E_In_Plc[x].analogSignals[45].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[6].Value			:= tPlantCom_E2E_In_Plc[x].analogSignals[46].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[6].GoodQual		:= tPlantCom_E2E_In_Plc[x].analogSignals[46].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[7].Value			:= tPlantCom_E2E_In_Plc[x].analogSignals[47].Value;
		OUT_HA.tPlantCom_E2E_In_Cust10ms[x].analogSignals[7].GoodQual		:= tPlantCom_E2E_In_Plc[x].analogSignals[47].GoodQual;
	END_FOR
	
	(**********************)
	(* Outputs to Masters *)
	(**********************)

	(*** 32 Fast Digital Outputs ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		(* Generator circuit breaker closed *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[64].Value 		:= tGCB_On.Di;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[64].GoodQual 	:= TRUE;
		
		(* Generator circuit breaker switch off fault *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[65].Value		:= tGCB_OpF.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[65].GoodQual	:= TRUE;

		(* Generator excitement off *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[66].Value		:= tGenExcOff.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[66].GoodQual	:= TRUE;
		
		(*
		tPlantCom_E2M_Out_Plc[x].digitalSignals[67].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[67].GoodQual		:= TRUE;
	
		tPlantCom_E2M_Out_Plc[x].digitalSignals[68].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[68].GoodQual		:= TRUE;
	
		tPlantCom_E2M_Out_Plc[x].digitalSignals[69].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[69].GoodQual		:= TRUE;
	
		tPlantCom_E2M_Out_Plc[x].digitalSignals[70].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[70].GoodQual		:= TRUE;
	
		tPlantCom_E2M_Out_Plc[x].digitalSignals[71].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[71].GoodQual		:= TRUE;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[72].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[72].GoodQual		:= TRUE;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[73].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[73].GoodQual		:= TRUE;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[74].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[74].GoodQual		:= TRUE;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[75].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[75].GoodQual		:= TRUE;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[76].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[76].GoodQual		:= TRUE;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[77].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[77].GoodQual		:= TRUE;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[78].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[78].GoodQual		:= TRUE;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[79].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[79].GoodQual		:= TRUE;
		*)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[80].Value			:= 	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[0].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[80].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[0].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[81].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[1].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[81].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[1].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[82].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[2].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[82].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[2].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[83].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[3].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[83].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[3].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[84].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[4].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[84].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[4].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[85].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[5].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[85].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[5].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[86].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[6].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[86].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[6].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[87].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[7].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[87].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[7].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[88].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[8].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[88].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[8].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[89].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[9].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[89].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[9].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[90].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[10].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[90].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[10].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[91].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[11].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[91].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[11].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[92].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[12].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[92].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[12].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[93].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[13].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[93].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[13].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[94].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[14].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[94].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[14].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[95].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[15].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[95].GoodQual		:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].digitalSignals[15].GoodQual;		
	END_FOR
	(*** 16 Fast Analog Outputs ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		(*
		tPlantCom_E2M_Out_Plc[x].analogSignals[32].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[32].GoodQual		:= TRUE;
		
	    tPlantCom_E2M_Out_Plc[x].analogSignals[33].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[33].GoodQual		:= TRUE;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[34].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[34].GoodQual		:= TRUE;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[35].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[35].GoodQual		:= TRUE;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[36].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[36].GoodQual		:= TRUE;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[37].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[37].GoodQual		:= TRUE;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[38].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[38].GoodQual		:= TRUE;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[39].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[39].GoodQual		:= TRUE;
		*)
	    tPlantCom_E2M_Out_Plc[x].analogSignals[40].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[0].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[40].GoodQual			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[0].GoodQual;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[41].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[1].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[41].GoodQual			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[1].GoodQual;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[42].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[2].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[42].GoodQual			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[2].GoodQual;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[43].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[3].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[43].GoodQual			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[3].GoodQual;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[44].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[4].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[44].GoodQual			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[4].GoodQual;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[45].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[5].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[45].GoodQual			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[5].GoodQual;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[46].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[6].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[46].GoodQual			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[6].GoodQual;

	    tPlantCom_E2M_Out_Plc[x].analogSignals[47].Value			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[7].Value;
	    tPlantCom_E2M_Out_Plc[x].analogSignals[47].GoodQual			:=	IN_HA.tPlantCom_E2M_Out_Cust10ms[x].analogSignals[7].GoodQual;
	END_FOR
						
	(*********************)
	(* Output to Engines *)
	(*********************)

	(*** 32 Fast Digital Outputs ***)
	(*
	tPlantCom_E2E_Out_Plc.digitalSignals[64].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[64].GoodQual		:= TRUE;
	
	tPlantCom_E2E_Out_Plc.digitalSignals[65].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[65].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[66].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[66].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[67].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[67].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[68].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[68].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[69].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[69].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[70].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[70].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[71].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[71].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[72].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[72].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[73].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[73].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[74].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[74].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[75].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[75].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[76].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[76].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[77].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[77].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[78].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[78].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.digitalSignals[79].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[79].GoodQual		:= TRUE;
	*)
	tPlantCom_E2E_Out_Plc.digitalSignals[80].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[0].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[80].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[0].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[81].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[1].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[81].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[1].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[82].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[2].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[82].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[2].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[83].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[3].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[83].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[3].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[84].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[4].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[84].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[4].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[85].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[5].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[85].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[5].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[86].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[6].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[86].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[6].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[87].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[7].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[87].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[7].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[88].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[8].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[88].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[8].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[89].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[9].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[89].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[9].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[90].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[10].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[90].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[10].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[91].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[11].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[91].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[11].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[92].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[12].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[92].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[12].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[93].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[13].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[93].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[13].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[94].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[14].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[94].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[14].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[95].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[15].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[95].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.digitalSignals[15].GoodQual;
	
	(*** 16 Fast Analog Outputs ***)
	(* Loadsharing Line *)
	(* Info: Software implementation required *)
	tLSL_Out;
	tPlantCom_E2E_Out_Plc.analogSignals[32].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[32].GoodQual;
	(*
	tPlantCom_E2E_Out_Plc.analogSignals[33].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[33].GoodQual		:= TRUE;
	
	tPlantCom_E2E_Out_Plc.analogSignals[34].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[34].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.analogSignals[35].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[35].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.analogSignals[36].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[36].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.analogSignals[37].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[37].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.analogSignals[38].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[38].GoodQual		:= TRUE;

	tPlantCom_E2E_Out_Plc.analogSignals[39].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[39].GoodQual		:= TRUE;
	*)
	tPlantCom_E2E_Out_Plc.analogSignals[40].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[0].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[40].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[0].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[41].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[1].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[41].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[1].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[42].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[2].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[42].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[2].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[43].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[3].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[43].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[3].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[44].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[4].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[44].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[4].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[45].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[5].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[45].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[5].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[46].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[6].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[46].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[6].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[47].Value			:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[7].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[47].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust10ms.analogSignals[7].GoodQual;
	
END_PROGRAM
