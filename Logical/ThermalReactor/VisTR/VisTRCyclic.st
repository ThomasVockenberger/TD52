(*******************************************************************************
VisTR	 			 Visualization signal to/from Thermal reactor module

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V04.00.00	04-04-2014	Denk/Ganguly
V04.03.00	25-09-2014	Denk	Bugfix, OUT_TR.rP_ThR_EH / 1000; 
									Adjust MM2VIS structure for VIS picture
V04.05.00	02-10-2017	Denk	Bugfix, MM2VIS.bThR_GT_COn1 and MM2VIS.bThR_GT_COn2 visibility with AND operation
V04.13.00	28-11-2023	Maran	Added auxiliary gas injection monitoring inputs
V04.14.00	27-11-2024	Maran	Added MM2VIS variables for el. heating status and auxiliary gas solenoid valve for ThR2
														
Instructions FOR use:
--------------------

			
Outstandings: - 
------------

(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Module 2 VISU *)
	MM2VIS.b_ThR_Val_Air	:= OUT_TR.tThR_Val_Air.Do;
	MM2VIS.bThR_GT_COn1		:= OUT_TR.tThR_GT_COn1.Do AND OUT_TR.bThR_Val_SetOut;
	MM2VIS.bThR_GT_COn2		:= OUT_TR.tThR_GT_COn2.Do AND OUT_TR.bThR_Val_SetIn;
	MM2VIS.rP_ThR_EH		:= OUT_TR.rP_ThR_EH / 1000;
	MM2VIS.rT_ThR_Chamber	:= TK_moduleTR;
	MM2VIS.bThR_RelHeat		:= FG_HEIZG_moduleTR;
	MM2VIS.bThR_RelGas		:= OUT_TR.bThR_RelGas;
	MM2VIS.bThR_Val_SetIn	:= OUT_TR.bThR_Val_SetIn;
	MM2VIS.bThR_Val_SetOut	:= OUT_TR.bThR_Val_SetOut;
	
	IF Para.bThR2_Ena THEN //Thermal reactor 2
		// el. heating group - display of operating status for each of the five total groups
		IF OUT_TR.tThR2_EH_group1_Dem.Do	THEN	MM2VIS.iThR2_EH_group1_status := _iThR2_EH_Group_ON;
		ELSIF bThR2_EH_gr1_T_blocked		THEN	MM2VIS.iThR2_EH_group1_status := _iThR2_EH_Group_BLOCKED;
		ELSE MM2VIS.iThR2_EH_group1_status := _iThR2_EH_Group_OFF;
		END_IF
		IF OUT_TR.tThR2_EH_group2_Dem.Do	THEN	MM2VIS.iThR2_EH_group2_status := _iThR2_EH_Group_ON;
		ELSIF bThR2_EH_gr2_T_blocked		THEN	MM2VIS.iThR2_EH_group2_status := _iThR2_EH_Group_BLOCKED;
		ELSE MM2VIS.iThR2_EH_group2_status := _iThR2_EH_Group_OFF;
		END_IF
		IF OUT_TR.tThR2_EH_group3_Dem.Do	THEN	MM2VIS.iThR2_EH_group3_status := _iThR2_EH_Group_ON;
		ELSIF bThR2_EH_gr3_T_blocked		THEN	MM2VIS.iThR2_EH_group3_status := _iThR2_EH_Group_BLOCKED;
		ELSE MM2VIS.iThR2_EH_group3_status := _iThR2_EH_Group_OFF;
		END_IF
		IF OUT_TR.tThR2_EH_group4_Dem.Do	THEN	MM2VIS.iThR2_EH_group4_status := _iThR2_EH_Group_ON;
		ELSIF bThR2_EH_gr4_T_blocked		THEN	MM2VIS.iThR2_EH_group4_status := _iThR2_EH_Group_BLOCKED;
		ELSE MM2VIS.iThR2_EH_group4_status := _iThR2_EH_Group_OFF;
		END_IF
		IF OUT_TR.tThR2_EH_group5_Dem.Do	THEN	MM2VIS.iThR2_EH_group5_status := _iThR2_EH_Group_ON;
		ELSIF bThR2_EH_gr5_T_blocked		THEN	MM2VIS.iThR2_EH_group5_status := _iThR2_EH_Group_BLOCKED;
		ELSE MM2VIS.iThR2_EH_group5_status := _iThR2_EH_Group_OFF;
		END_IF
		
		// auxiliary gas solenoid valve - ThR2
		MM2VIS.bThR2_AuxGasShutOffValve_Dem := OUT_TR.tThR2_AuxGasShutOffValve_Dem.Do;
	END_IF
	(* from HalIO *)
	MM2VIS.rT_ThR_Chamber1_1		:= IN_TR.tT_ThR_Chamber1_1.Ai;
	MM2VIS.rT_ThR_Chamber1_2		:= IN_TR.tT_ThR_Chamber1_2.Ai;
	MM2VIS.rT_ThR_Chamber2_1		:= IN_TR.tT_ThR_Chamber2_1.Ai;
	MM2VIS.rT_ThR_Chamber2_2		:= IN_TR.tT_ThR_Chamber2_2.Ai;
	MM2VIS.rT_ThR_Comp				:= IN_TR.tT_ThR_Comp.Ai;
	MM2VIS.rT_ThR_In				:= IN_TR.tT_ThR_In.Ai;
	MM2VIS.rT_ThR_Out				:= IN_TR.tT_ThR_Out.Ai;
	MM2VIS.bPos_ThR_Val_In1			:= IN_TR.tPos_ThR_Val_In1.Di;
	MM2VIS.bPos_ThR_Val_In2			:= IN_TR.tPos_ThR_Val_In2.Di;
	MM2VIS.bPos_ThR_Val_Mid			:= IN_TR.tPos_ThR_Val_Mid.Di;
	MM2VIS.bPos_ThR_Val_Out1		:= IN_TR.tPos_ThR_Val_Out1.Di;
	MM2VIS.bPos_ThR_Val_Out2		:= IN_TR.tPos_ThR_Val_Out2.Di;
	MM2VIS.rPos_ThR_AuxGasCV_Act := IN_TR.tPos_ThR_AuxGasCV_Act.Ai;
	MM2VIS.rPr_ThR_AuxGasBeforeCV := IN_TR.tPr_ThR_AuxGasBeforeCV.Ai;
	MM2VIS.rPr_ThR_AuxGasAfterCV := IN_TR.tPr_ThR_AuxGasAfterCV.Ai;
	MM2VIS.rPr_ThR2_Inlet			:= IN_TR.tPr_ThR2_Inlet.Ai;
	MM2VIS.rPr_ThR2_Outlet			:= IN_TR.tPr_ThR2_Outlet.Ai;
	MM2VIS.rT_ThR2_LeftChamber		:= IN_TR.tT_ThR2_LeftChamber.Ai;
	MM2VIS.rT_ThR2_RightChamber		:= IN_TR.tT_ThR2_RightChamber.Ai;
	MM2VIS.rT_ThR2_Downstream		:= IN_TR.tT_ThR2_Downstream.Ai;
	MM2VIS.bThR2_T_fault_LeftCh		:= NOT IN_TR.tThR2_T_UnitOk_LeftCh.Di;
	MM2VIS.bThR2_T_fault_RightCh	:= NOT IN_TR.tThR2_T_UnitOk_RightCh.Di;
	MM2VIS.bThR2_T_fault_Downstream	:= NOT IN_TR.tThR2_T_UnitOk_Downstream.Di;
	MM2VIS.rT_ThR2_EH_group1		:= IN_TR.tT_ThR2_EH_group1.Ai;
	MM2VIS.rT_ThR2_EH_group2		:= IN_TR.tT_ThR2_EH_group2.Ai;
	MM2VIS.rT_ThR2_EH_group3		:= IN_TR.tT_ThR2_EH_group3.Ai;
	MM2VIS.rT_ThR2_EH_group4		:= IN_TR.tT_ThR2_EH_group4.Ai;
	MM2VIS.rT_ThR2_EH_group5		:= IN_TR.tT_ThR2_EH_group5.Ai;
	MM2VIS.bThR_LeftChamber_inlet	:= RM_KL_END_AUS;
	MM2VIS.bThR_RightChamber_inlet	:= RM_KL_END_EIN;
	
	(* VIS to module *)
	(*  ------  *)
	
	(* Controller *)
	tCtrTR_Heater_In			:= VIS2MM.tCtrTR_Heater_In;
	MM2VIS.tCtrTR_Heater_Out	:= tCtrTR_Heater_Out;
	
	(* For Debugging *)
	OUT_TR.rT_ThR_In			:= IN_TR.tT_ThR_In.Ai;
	OUT_TR.rT_ThR_Out			:= IN_TR.tT_ThR_Out.Ai;
	OUT_TR.rT_ThR_Chamber		:= TK_moduleTR;
	OUT_TR.rT_ThR_Chamber1_1	:= IN_TR.tT_ThR_Chamber1_1.Ai;
	OUT_TR.rT_ThR_Chamber1_2	:= IN_TR.tT_ThR_Chamber1_2.Ai;
	OUT_TR.rT_ThR_Chamber2_1	:= IN_TR.tT_ThR_Chamber2_1.Ai;
	OUT_TR.rT_ThR_Chamber2_2	:= IN_TR.tT_ThR_Chamber2_2.Ai;
	OUT_TR.rT_ThR_Comp			:= IN_TR.tT_ThR_Comp.Ai;
	
END_PROGRAM
