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

						
Instructions for use: -
--------------------

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC
	(* Exit if configuration fails or not active *)
	IF (NOT MM2VIS.tPlantComm.bCfg_OK OR NOT Para.tPlantComm.bActive) THEN
		RETURN;
	END_IF

	(***********************)
	(* Inputs from Masters *)
	(***********************)
	
	(*** 64 Slow Digital Inputs ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		(* Demand engine operation *)
		IF (NOT tDemEngOpExt.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[0]) THEN
			tDemEngOpExt.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[0].Value;
			tDemEngOpExt.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[0].GoodQual;
			tDemEngOpExt.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[0] := TRUE;
		END_IF
		(* Demand engine power regulation *)
		IF (NOT tReq_PowMod.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[1]) THEN
			tReq_PowMod.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[1].Value;
			tReq_PowMod.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[1].GoodQual;
			tReq_PowMod.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[1] := TRUE;
		END_IF
		(* Demand engine additional blocking *)
		IF (NOT tEngBlock_PlantCtr.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[2]) THEN
			tEngBlock_PlantCtr.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[2].Value;
			tEngBlock_PlantCtr.GoodQual		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[2].GoodQual;
			tEngBlock_PlantCtr.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[2] := TRUE;
		END_IF
		(* Demand engine synchronization *)
		IF (NOT tGCB_DSY.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[3]) THEN
			tGCB_DSY.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[3].Value;
			tGCB_DSY.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[3].GoodQual;
			tGCB_DSY.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[3] := TRUE;
		END_IF
		(* Block generator circuit breaker *)
		IF (NOT tGCB_MDL.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[4]) THEN
			tGCB_MDL.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[4].Value;
			tGCB_MDL.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[4].GoodQual;
			tGCB_MDL.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[4] := TRUE;
		END_IF
		(* Enable generator breaker switch on *)
		IF (NOT tGCB_MRC.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[5]) THEN
			tGCB_MRC.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[5].Value;
			tGCB_MRC.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[5].GoodQual;
			tGCB_MRC.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[5] := TRUE;
		END_IF
		(* Release island mode *)
		IF (NOT tGCB_RI.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[6]) THEN
			tGCB_RI.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[6].Value;
			tGCB_RI.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[6].GoodQual;
			tGCB_RI.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[6] := TRUE;
		END_IF
		(* Selection voltage adjustment *)
		IF (NOT tGCB_DVM.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[7]) THEN
			tGCB_DVM.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[7].Value;
			tGCB_DVM.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[7].GoodQual;
			tGCB_DVM.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[7] := TRUE;
		END_IF
		(* Demand power limitation *)
		IF (NOT tPLim_GenC_SetEUCOn.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[8]) THEN
			tPLim_GenC_SetEUCOn.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[8].Value;
			tPLim_GenC_SetEUCOn.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[8].GoodQual;
			tPLim_GenC_SetEUCOn.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[8] := TRUE;
		END_IF
		(* Demand reactive power setpoint *)
		IF (NOT tQ_GenC_SetEUCOn.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[9]) THEN
			tQ_GenC_SetEUCOn.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[9].Value;
			tQ_GenC_SetEUCOn.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[9].GoodQual;
			tQ_GenC_SetEUCOn.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[9] := TRUE;
		END_IF
		(* Demand block energy provider *)
		IF (NOT tDI_Dem_EU_Block.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[10]) THEN
			tDI_Dem_EU_Block.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[10].Value;
			tDI_Dem_EU_Block.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[10].GoodQual;
			tDI_Dem_EU_Block.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[10] := TRUE;
		END_IF
		(* Demand block mains connection energy provider *)
		IF (NOT tDI_Dem_EU_MnsConBlock.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[11]) THEN
			tDI_Dem_EU_MnsConBlock.Di			:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[11].Value;
			tDI_Dem_EU_MnsConBlock.GoodQual		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[11].GoodQual;
			tDI_Dem_EU_MnsConBlock.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[11] := TRUE;
		END_IF
		(* F_N_DI_Inc  -  Speed increase impulse *)
		IF (NOT tF_N_DI_Inc.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[12]) THEN
			tF_N_DI_Inc.Di		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[12].Value;
			tF_N_DI_Inc.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[12].GoodQual;
			tF_N_DI_Inc.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[12] := TRUE;
		END_IF
		(* F_N_DI_Dec   -  Speed decrease impulse *)
		IF (NOT tF_N_DI_Dec.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[13]) THEN
			tF_N_DI_Dec.Di		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[13].Value;
			tF_N_DI_Dec.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[13].GoodQual;
			tF_N_DI_Dec.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[13] := TRUE;
		END_IF
		(* U_Adj_Plus  -  Voltage increase impulse *)
		IF (NOT tU_Adj_Plus.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[14]) THEN
			tU_Adj_Plus.Di		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[14].Value;
			tU_Adj_Plus.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[14].GoodQual;
			tU_Adj_Plus.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[14] := TRUE;
		END_IF
		(* U_Adj_Minus  -  Voltage decrease impulse *)
		IF (NOT tU_Adj_Minus.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[15]) THEN
			tU_Adj_Minus.Di		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[15].Value;
			tU_Adj_Minus.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[15].GoodQual;
			tU_Adj_Minus.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[15] := TRUE;
		END_IF
		(* Only_Island  -  Only island *)
		IF (NOT tOnly_Island.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[16]) THEN
			tOnly_Island.Di		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[16].Value;
			tOnly_Island.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[16].GoodQual;
			tOnly_Island.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[16] := TRUE;
		END_IF
		(* EG_BypassDemand  -  Demand exhaust gas bypass *)
		IF (NOT tEG_BypassDemand.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[17]) THEN
			tEG_BypassDemand.Di		:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[17].Value;
			tEG_BypassDemand.GoodQual	:= tPlantCom_M2E_In_Plc[iSelectedMaster].digitalSignals[17].GoodQual;
			tEG_BypassDemand.Exist		:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].digitalSignalActive[17] := TRUE;
		END_IF
		(*
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[18].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[18].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[19].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[19].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[20].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[20].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[21].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[21].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[22].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[22].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[23].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[23].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[24].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[24].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[25].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[25].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[26].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[26].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[27].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[27].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[28].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[28].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[29].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[29].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[30].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[30].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].digitalSignals[31].Value;
		:= tPlantCom_M2E_In_Plc[x].digitalSignals[31].GoodQual;
		*)
		
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[0].Value		:= 	tPlantCom_M2E_In_Plc[x].digitalSignals[32].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[0].GoodQual		:= 	tPlantCom_M2E_In_Plc[x].digitalSignals[32].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[1].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[33].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[1].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[33].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[2].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[34].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[2].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[34].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[3].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[35].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[3].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[35].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[4].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[36].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[4].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[36].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[5].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[37].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[5].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[37].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[6].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[38].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[6].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[38].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[7].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[39].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[7].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[39].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[8].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[40].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[8].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[40].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[9].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[41].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[9].GoodQual		:= tPlantCom_M2E_In_Plc[x].digitalSignals[41].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[10].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[42].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[10].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[42].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[11].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[43].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[11].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[43].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[12].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[44].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[12].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[44].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[13].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[45].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[13].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[45].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[14].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[46].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[14].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[46].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[15].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[47].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[15].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[47].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[16].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[48].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[16].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[48].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[17].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[49].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[17].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[49].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[18].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[50].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[18].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[50].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[19].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[51].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[19].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[51].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[20].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[52].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[20].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[52].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[21].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[53].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[21].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[53].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[22].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[54].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[22].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[54].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[23].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[55].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[23].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[55].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[24].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[56].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[24].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[56].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[25].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[57].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[25].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[57].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[26].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[58].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[26].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[58].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[27].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[59].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[27].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[59].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[28].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[60].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[28].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[60].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[29].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[61].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[29].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[61].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[30].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[62].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[30].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[62].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[31].Value		:= tPlantCom_M2E_In_Plc[x].digitalSignals[63].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].digitalSignals[31].GoodQual	:= tPlantCom_M2E_In_Plc[x].digitalSignals[63].GoodQual;
	END_FOR
	
	(*** 32 Slow Analog Inputs ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		(* Generator active power setpoint *)
		IF (NOT tP_Set_ExtAI_Norm.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].analogSignalActive[0]) THEN
			tP_Set_ExtAI_Norm.Ai			:= tPlantCom_M2E_In_Plc[iSelectedMaster].analogSignals[0].Value * IN_HA.rP_Nom;
			tP_Set_ExtAI_Norm.GoodQual		:= tPlantCom_M2E_In_Plc[iSelectedMaster].analogSignals[0].GoodQual;
			tP_Set_ExtAI_Norm.Exist			:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].analogSignalActive[0] := TRUE;
		END_IF
		(* Generator reactive power setpoint *)
		IF (NOT tQ_GenC_SetEU.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].analogSignalActive[1]) THEN
			tQ_GenC_SetEU.Ai				:= Para.rQ_GrC_SetEUP1 + (tPlantCom_M2E_In_Plc[iSelectedMaster].analogSignals[1].Value * (Para.rQ_GrC_SetEUP2 - Para.rQ_GrC_SetEUP1));	
			tQ_GenC_SetEU.GoodQual			:= tPlantCom_M2E_In_Plc[iSelectedMaster].analogSignals[1].GoodQual;
			tQ_GenC_SetEU.Exist				:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].analogSignalActive[1] := TRUE;
		END_IF
		(* Generator active power setpoint limit *)
		IF (NOT tPLim_GenC_SetEU.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].analogSignalActive[2]) THEN
			tPLim_GenC_SetEU.Ai				:= Para.rP_GrC_SetEUP1_Lim + (tPlantCom_M2E_In_Plc[iSelectedMaster].analogSignals[2].Value *(Para.rP_GrC_SetEUP2_Lim - Para.rP_GrC_SetEUP1_Lim));
			tPLim_GenC_SetEU.GoodQual		:= tPlantCom_M2E_In_Plc[iSelectedMaster].analogSignals[2].GoodQual;
			tPLim_GenC_SetEU.Exist			:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].analogSignalActive[2] := TRUE;
		END_IF
		(* Voltage generator setpoint *)
		IF (NOT tU_SetExtAI_Norm.Exist OR tPlantCom_M2E_In_Active[iSelectedMaster].analogSignalActive[3]) THEN
			tU_SetExtAI_Norm.Ai				:= tPlantCom_M2E_In_Plc[iSelectedMaster].analogSignals[3].Value;
			tU_SetExtAI_Norm.GoodQual		:= tPlantCom_M2E_In_Plc[iSelectedMaster].analogSignals[3].GoodQual;
			tU_SetExtAI_Norm.Exist			:= TRUE;
			tPlantCom_M2E_In_Active[iSelectedMaster].analogSignalActive[3] := TRUE;
		END_IF

		(*
		:= tPlantCom_M2E_In_Plc[x].analogSignals[4].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[4].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[5].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[5].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[6].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[6].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[7].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[7].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[8].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[8].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[9].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[9].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[10].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[10].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[11].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[11].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[12].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[12].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[13].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[13].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[14].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[14].GoodQual;

		:= tPlantCom_M2E_In_Plc[x].analogSignals[15].Value;
		:= tPlantCom_M2E_In_Plc[x].analogSignals[15].GoodQual;
		*)
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[0].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[16].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[0].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[16].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[1].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[17].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[1].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[17].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[2].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[18].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[2].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[18].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[3].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[19].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[3].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[19].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[4].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[20].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[4].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[20].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[5].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[21].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[5].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[21].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[6].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[22].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[6].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[22].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[7].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[23].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[7].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[23].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[8].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[24].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[8].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[24].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[9].Value				:= tPlantCom_M2E_In_Plc[x].analogSignals[25].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[9].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[25].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[10].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[26].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[10].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[26].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[11].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[27].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[11].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[27].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[12].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[28].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[12].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[28].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[13].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[29].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[13].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[29].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[14].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[30].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[14].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[30].GoodQual;

		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[15].Value			:= tPlantCom_M2E_In_Plc[x].analogSignals[31].Value;
		OUT_HA.tPlantCom_M2E_In_Cust100ms[x].analogSignals[15].GoodQual			:= tPlantCom_M2E_In_Plc[x].analogSignals[31].GoodQual;	
	END_FOR
		
	(***********************)
	(* Inputs from Engines *)
	(***********************)
	
	(*** 64 Slow Digital Inputs ***)
	FOR x:=iEngNumMin TO iEngNumMax DO
		;
		(*
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[0].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[0].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[1].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[1].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[2].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[2].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[3].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[3].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[4].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[4].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[5].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[5].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[6].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[6].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[7].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[7].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[8].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[8].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[9].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[9].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[10].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[10].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[11].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[11].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[12].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[12].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[13].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[13].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[14].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[14].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[15].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[15].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[16].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[16].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[17].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[17].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[18].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[18].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[19].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[19].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[20].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[20].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[21].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[21].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[22].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[22].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[23].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[23].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[24].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[24].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[25].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[25].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[26].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[26].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[27].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[27].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[28].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[28].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[29].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[29].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[30].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[30].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].digitalSignals[31].Value;
		:= tPlantCom_E2E_In_Plc[x].digitalSignals[31].GoodQual;
		*)
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[0].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[32].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[0].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[32].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[1].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[33].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[1].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[33].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[2].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[34].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[2].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[34].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[3].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[35].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[3].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[35].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[4].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[36].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[4].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[36].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[5].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[37].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[5].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[37].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[6].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[38].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[6].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[38].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[7].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[39].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[7].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[39].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[8].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[40].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[8].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[40].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[9].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[41].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[9].GoodQual			:= tPlantCom_E2E_In_Plc[x].digitalSignals[41].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[10].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[42].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[10].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[42].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[11].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[43].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[11].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[43].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[12].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[44].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[12].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[44].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[13].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[45].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[13].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[45].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[14].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[46].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[14].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[46].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[15].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[47].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[15].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[47].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[16].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[48].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[16].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[48].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[17].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[49].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[17].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[49].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[18].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[50].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[18].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[50].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[19].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[51].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[19].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[51].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[20].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[52].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[20].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[52].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[21].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[53].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[21].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[53].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[22].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[54].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[22].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[54].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[23].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[55].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[23].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[55].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[24].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[56].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[24].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[56].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[25].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[57].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[25].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[57].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[26].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[58].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[26].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[58].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[27].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[59].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[27].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[59].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[28].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[60].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[28].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[60].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[29].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[61].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[29].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[61].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[30].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[62].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[30].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[62].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[31].Value			:= tPlantCom_E2E_In_Plc[x].digitalSignals[63].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].digitalSignals[31].GoodQual		:= tPlantCom_E2E_In_Plc[x].digitalSignals[63].GoodQual;
			
	END_FOR

	(*** 32 Slow Analog Inputs ***)
	FOR x:=iEngNumMin TO iEngNumMax DO
		;
	(*
		:= tPlantCom_E2E_In_Plc[x].analogSignals[0].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[0].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[1].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[1].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[2].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[2].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[3].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[3].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[4].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[4].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[5].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[5].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[6].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[6].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[7].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[7].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[8].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[8].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[9].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[9].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[10].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[10].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[11].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[11].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[12].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[12].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[13].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[13].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[14].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[14].GoodQual;

		:= tPlantCom_E2E_In_Plc[x].analogSignals[15].Value;
		:= tPlantCom_E2E_In_Plc[x].analogSignals[15].GoodQual;
		*)
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[0].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[16].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[0].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[16].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[1].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[17].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[1].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[17].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[2].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[18].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[2].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[18].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[3].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[19].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[3].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[19].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[4].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[20].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[4].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[20].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[5].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[21].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[5].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[21].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[6].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[22].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[6].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[22].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[7].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[23].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[7].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[23].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[8].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[24].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[8].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[24].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[9].Value					:= tPlantCom_E2E_In_Plc[x].analogSignals[25].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[9].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[25].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[10].Value				:= tPlantCom_E2E_In_Plc[x].analogSignals[26].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[10].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[26].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[11].Value				:= tPlantCom_E2E_In_Plc[x].analogSignals[27].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[11].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[27].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[12].Value				:= tPlantCom_E2E_In_Plc[x].analogSignals[28].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[12].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[28].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[13].Value				:= tPlantCom_E2E_In_Plc[x].analogSignals[29].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[13].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[29].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[14].Value				:= tPlantCom_E2E_In_Plc[x].analogSignals[30].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[14].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[30].GoodQual;

		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[15].Value				:= tPlantCom_E2E_In_Plc[x].analogSignals[31].Value;
		OUT_HA.tPlantCom_E2E_In_Cust100ms[x].analogSignals[15].GoodQual				:= tPlantCom_E2E_In_Plc[x].analogSignals[31].GoodQual;
	END_FOR
	
	(**********************)
	(* Outputs to Masters *)
	(**********************)
	
	(*** 64 Slow Digital Outputs ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		(* Module ready for automatic mode *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[0].Value		:= tRdy_MSy.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[0].GoodQual 	:= TRUE;

		(* Status engine running *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[1].Value		:= tEng_Run_Sy.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[1].GoodQual 	:= TRUE;

		(* Module ready for remote automatic demand mains parallel operation *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[2].Value		:= tEng_Rdy_Rem.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[2].GoodQual 	:= TRUE;

		(* Operating hours impulse *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[3].Value		:= tImp_OpHour.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[3].GoodQual 	:= TRUE;

		(* Engine operation *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[4].Value		:= tEng_Run.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[4].GoodQual 	:= TRUE;

		(* Module demanded *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[5].Value		:= tEng_Dem.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[5].GoodQual 	:= TRUE;

		(* Enable mains switch switch-on on voltage-free rail *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[6].Value		:= tGCB_ESL.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[6].GoodQual 	:= TRUE;

		(* Block other breakers *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[7].Value		:= tGCB_EDC.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[7].GoodQual 	:= TRUE;
		
		(* SyOMSS_Man  -  Synchronization operation mode selection switch manual *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[8].Value		:= tSyOMSS_Man.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[8].GoodQual		:= TRUE;
		
		(* SyOMSS_Aut  -  Synchronization operation mode selection switch auto *)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[9].Value		:= tSyOMSS_Aut.Do;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[9].GoodQual		:= TRUE;
		
		(*
		tPlantCom_E2M_Out_Plc[x].digitalSignals[10].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[10].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[11].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[11].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[12].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[12].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[13].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[13].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[14].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[14].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[15].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[15].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[16].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[16].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[17].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[17].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[18].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[18].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[19].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[19].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[20].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[20].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[21].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[21].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[22].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[22].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[23].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[23].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[24].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[24].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[25].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[25].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[26].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[26].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[27].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[27].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[28].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[28].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[29].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[29].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[30].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[30].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[31].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[31].GoodQual;
		*)
		tPlantCom_E2M_Out_Plc[x].digitalSignals[32].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[0].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[32].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[0].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[33].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[1].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[33].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[1].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[34].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[2].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[34].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[2].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[35].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[3].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[35].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[3].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[36].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[4].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[36].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[4].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[37].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[5].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[37].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[5].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[38].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[6].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[38].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[6].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[39].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[7].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[39].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[7].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[40].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[8].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[40].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[8].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[41].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[9].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[41].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[9].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[42].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[10].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[42].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[10].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[43].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[11].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[43].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[11].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[44].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[12].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[44].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[12].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[45].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[13].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[45].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[13].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[46].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[14].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[46].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[14].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[47].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[15].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[47].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[15].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[48].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[16].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[48].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[16].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[49].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[17].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[49].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[17].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[50].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[18].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[50].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[18].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[51].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[19].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[51].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[19].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[52].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[20].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[52].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[20].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[53].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[21].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[53].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[21].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[54].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[22].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[54].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[22].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[55].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[23].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[55].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[23].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[56].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[24].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[56].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[24].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[57].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[25].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[57].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[25].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[58].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[26].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[58].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[26].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[59].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[27].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[59].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[27].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[60].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[28].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[60].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[28].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[61].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[29].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[61].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[29].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[62].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[30].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[62].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[30].GoodQual;

		tPlantCom_E2M_Out_Plc[x].digitalSignals[63].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[31].Value;
		tPlantCom_E2M_Out_Plc[x].digitalSignals[63].GoodQual		:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].digitalSignals[31].GoodQual;
	END_FOR
	
	(*** 32 Slow Analog Outputs ***)
	FOR x:=iMasNumMin TO iMasNumMax DO
		(* Generator active power *)
		tPlantCom_E2M_Out_Plc[x].analogSignals[0].Value			:= tP_Act_AO.Ao;
		tPlantCom_E2M_Out_Plc[x].analogSignals[0].GoodQual 		:= TRUE;

		(* Max power available *)
		tPlantCom_E2M_Out_Plc[x].analogSignals[1].Value			:= tP_max_LSL.Ao;
		tPlantCom_E2M_Out_Plc[x].analogSignals[1].GoodQual 		:= TRUE;

		(* Generator reactive power setpoint *)
		tPlantCom_E2M_Out_Plc[x].analogSignals[2].Value			:= tQ_GenC_Act.Ao;
		tPlantCom_E2M_Out_Plc[x].analogSignals[2].GoodQual 		:= TRUE;
		(*
		tPlantCom_E2M_Out_Plc[x].analogSignals[3].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[3].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[4].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[4].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[5].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[5].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[6].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[6].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[7].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[7].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[8].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[8].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[9].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[9].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[10].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[10].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[11].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[11].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[12].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[12].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[13].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[13].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[14].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[14].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[15].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[15].GoodQual;
		*)
		tPlantCom_E2M_Out_Plc[x].analogSignals[16].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[0].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[16].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[0].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[17].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[1].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[17].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[1].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[18].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[2].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[18].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[2].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[19].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[3].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[19].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[3].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[20].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[4].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[20].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[4].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[21].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[5].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[21].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[5].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[22].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[6].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[22].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[6].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[23].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[7].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[23].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[7].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[24].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[8].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[24].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[8].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[25].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[9].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[25].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[9].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[26].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[10].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[26].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[10].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[27].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[11].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[27].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[11].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[28].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[12].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[28].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[12].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[29].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[13].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[29].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[13].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[30].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[14].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[30].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[14].GoodQual;

		tPlantCom_E2M_Out_Plc[x].analogSignals[31].Value			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[15].Value;
		tPlantCom_E2M_Out_Plc[x].analogSignals[31].GoodQual			:= IN_HA.tPlantCom_E2M_Out_Cust100ms[x].analogSignals[15].GoodQual;
	END_FOR
						
	(*********************)
	(* Output to Engines *)
	(*********************)
	
	(***64 Slow Digital Outputs ***)
	tPlantCom_E2E_Out_Plc.digitalSignals[0].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[0].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[1].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[1].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[2].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[2].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[3].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[3].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[4].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[4].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[5].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[5].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[6].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[6].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[7].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[7].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[8].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[8].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[9].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[9].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[10].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[10].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[11].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[11].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[12].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[12].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[13].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[13].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[14].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[14].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[15].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[15].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[16].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[16].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[17].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[17].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[18].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[18].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[19].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[19].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[20].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[20].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[21].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[21].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[22].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[22].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[23].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[23].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[24].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[24].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[25].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[25].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[26].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[26].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[27].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[27].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[28].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[28].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[29].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[29].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[30].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[30].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[31].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[31].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[32].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[0].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[32].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[0].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[33].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[1].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[33].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[1].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[34].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[2].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[34].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[2].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[35].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[3].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[35].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[3].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[36].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[4].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[36].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[4].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[37].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[5].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[37].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[5].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[38].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[6].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[38].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[6].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[39].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[7].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[39].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[7].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[40].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[8].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[40].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[8].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[41].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[9].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[41].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[9].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[42].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[10].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[42].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[10].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[43].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[11].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[43].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[11].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[44].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[12].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[44].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[12].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[45].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[13].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[45].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[13].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[46].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[14].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[46].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[14].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[47].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[15].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[47].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[15].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[48].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[16].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[48].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[16].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[49].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[17].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[49].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[17].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[50].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[18].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[50].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[18].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[51].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[19].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[51].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[19].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[52].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[20].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[52].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[20].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[53].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[21].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[53].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[21].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[54].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[22].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[54].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[22].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[55].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[23].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[55].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[23].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[56].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[24].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[56].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[24].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[57].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[25].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[57].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[25].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[58].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[26].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[58].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[26].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[59].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[27].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[59].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[27].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[60].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[28].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[60].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[28].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[61].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[29].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[61].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[29].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[62].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[30].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[62].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[30].GoodQual;

	tPlantCom_E2E_Out_Plc.digitalSignals[63].Value				:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[31].Value;
	tPlantCom_E2E_Out_Plc.digitalSignals[63].GoodQual			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.digitalSignals[31].GoodQual;
													
	(***32 Slow Analog Outputs ***)
	
	tPlantCom_E2E_Out_Plc.analogSignals[0].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[0].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[1].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[1].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[2].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[2].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[3].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[3].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[4].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[4].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[5].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[5].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[6].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[6].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[7].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[7].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[8].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[8].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[9].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[9].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[10].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[10].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[11].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[11].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[12].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[12].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[13].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[13].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[14].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[14].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[15].Value;			
	tPlantCom_E2E_Out_Plc.analogSignals[15].GoodQual;		

	tPlantCom_E2E_Out_Plc.analogSignals[16].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[0].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[16].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[0].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[17].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[1].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[17].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[1].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[18].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[2].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[18].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[2].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[19].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[3].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[19].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[3].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[20].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[4].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[20].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[4].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[21].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[5].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[21].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[5].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[22].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[6].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[22].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[6].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[23].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[7].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[23].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[7].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[24].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[8].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[24].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[8].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[25].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[9].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[25].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[9].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[26].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[10].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[26].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[10].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[27].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[11].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[27].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[11].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[28].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[12].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[28].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[12].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[29].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[13].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[29].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[13].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[30].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[14].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[30].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[14].GoodQual;

	tPlantCom_E2E_Out_Plc.analogSignals[31].Value			:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[15].Value;
	tPlantCom_E2E_Out_Plc.analogSignals[31].GoodQual		:= IN_HA.tPlantCom_E2E_Out_Cust100ms.analogSignals[15].GoodQual;
													
END_PROGRAM
