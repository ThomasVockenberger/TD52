(*******************************************************************************
Visualisation grid

This code is confidential AND proprietary TO the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission OF the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------

History:
-------
V4.10.0	16.11.2020  lettenb.	from msy to adapt for +A
V4.11.0 17.01.2022	lettenb.	MM2VIS.bDI_Dem_EU_Block: IN_GR.bEng_Block_EVU added, bugfix

Instructions FOR use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

//MM2VIS.bTestGR 						:= OUT_GR.bTestGR;

MM2VIS.bDI_Dem_EU_Block				:= IN_GR.tDI_Dem_EU_Block.Di OR IN_GR.bEng_Block_EVU;
MM2VIS.bDI_Dem_EU_MnsConBlock;(*	:= IN_GR.tDI_Dem_EU_MnsConBlock.Di; 	(* for future - lock mains connection   1=locked *)
MM2VIS.bLockPlantBC_SetEUCOn; (* 	:= IN_GR.bLockPlantBC_SetEUCOn; 		(* for future - lock plant(all modules) 1=locked *)
MM2VIS.bLockMnsConBC_SetEUCOn;(*	:= IN_GR.bLockMnsConBC_SetEUCOn; 		(* for future - lock mains connection   1=locked *)

MM2VIS.bP_GenC_SetEUCOn				:= IN_GR.bP_GenC_SetEUCOn;
MM2VIS.bP_GenC_SetEUCOf				:= IN_GR.bP_GenC_SetEUCOf;
MM2VIS.rGCP_P;
MM2VIS.bGenC_PBC_SetCOn				:= IN_GR.bGenC_PBC_SetCOn;
MM2VIS.bGenC_PBC_SetCOf				:= IN_GR.bGenC_PBC_SetCOf;
MM2VIS.rGenC_PBC					:= IN_GR.rGenC_PBC;

MM2VIS.bPF_GenC_SetEUCOn			:= IN_GR.bPF_GenC_SetEUCOn;
MM2VIS.bPF_GenC_SetEUCOf 			:= IN_GR.bPF_GenC_SetEUCOf;
MM2VIS.rGCQ_PF;
MM2VIS.bGenC_PFBC_SetCOn			:= IN_GR.bGenC_PFBC_SetCOn;
MM2VIS.bGenC_PFBC_SetCOf			:= IN_GR.bGenC_PFBC_SetCOf;
MM2VIS.rGenC_PFBC					:= IN_GR.rGenC_PFBC;

MM2VIS.bQ_GenC_SetEUCOn				:= IN_GR.bQ_GenC_SetEUCOn;
MM2VIS.bQ_GenC_SetEUCOf 			:= IN_GR.bQ_GenC_SetEUCOf;
MM2VIS.rGCQ_Q;
MM2VIS.bGenC_QBC_SetCOn				:= IN_GR.bGenC_QBC_SetCOn;
MM2VIS.bGenC_QBC_SetCOf				:= IN_GR.bGenC_QBC_SetCOf;
MM2VIS.rGenC_QBC					:= IN_GR.rGenC_QBC;

MM2VIS.bU_GenC_SetEUCOn				:= IN_GR.bU_GenC_SetEUCOn;
MM2VIS.bU_GenC_SetEUCOf				:= IN_GR.bU_GenC_SetEUCOf;
MM2VIS.rGCQ_USet;
MM2VIS.bGenC_UBC_SetCOn				:= IN_GR.bGenC_UBC_SetCOn;
MM2VIS.bGenC_UBC_SetCOf				:= IN_GR.bGenC_UBC_SetCOf;
MM2VIS.rGenC_UQBC					:= IN_GR.rGenC_UQBC;

MM2VIS.bPLim_GenC_SetEUCOn			:= IN_GR.bPLim_GenC_SetEUCOn;
MM2VIS.bPLim_GenC_SetEUCOf			:= IN_GR.bPLim_GenC_SetEUCOf;
MM2VIS.rGCP_PLim_AI;
MM2VIS.bGenC_PLimBC_SetCOn			:= IN_GR.bGenC_PLimBC_SetCOn;
MM2VIS.bGenC_PLimBC_SetCOf			:= IN_GR.bGenC_PLimBC_SetCOf;
MM2VIS.rGenC_PLimBC					:= IN_GR.rGenC_PLimBC;

MM2VIS.bQLim_GenC_SetEUCOn			:= IN_GR.bQLim_GenC_SetEUCOn;
MM2VIS.bQLim_GenC_SetEUCOf			:= IN_GR.bQLim_GenC_SetEUCOf;
MM2VIS.rGCQ_QLim_AI;
MM2VIS.bGenC_QLimBC_SetCOn			:= IN_GR.bGenC_QLimBC_SetCOn;
MM2VIS.bGenC_QLimBC_SetCOf			:= IN_GR.bGenC_QLimBC_SetCOf;
MM2VIS.rGenC_QLimBC;

//MM2VIS.bLFSMO_SetEUCOn				:= IN_GR.bLFSMO_SetEUCOn;	(*TF 3.2.3, plant category C*)
//MM2VIS.bLFSMO_SetEUCOf				:= IN_GR.bLFSMO_SetEUCOf;
//MM2VIS.bLFSMU_SetEUCOn				:= IN_GR.bLFSMU_SetEUCOn;
//MM2VIS.bLFSMU_SetEUCOf				:= IN_GR.bLFSMU_SetEUCOf;
//MM2VIS.bLFSMO_SetEUCOn_BC			:= IN_GR.bLFSMO_SetEUCOn_BC;
//MM2VIS.bLFSMO_SetEUCOf_BC			:= IN_GR.bLFSMO_SetEUCOf_BC;
//MM2VIS.bLFSMU_SetEUCOn_BC			:= IN_GR.bLFSMU_SetEUCOn_BC;
//MM2VIS.bLFSMU_SetEUCOf_BC			:= IN_GR.bLFSMU_SetEUCOf_BC;

MM2VIS.bPRampExt_SetEUCOn			:= IN_GR.tCU2GR.bFSM_Rmp_AI_COn;
MM2VIS.bPRampExtBC_SetEUCOn			:= IN_GR.tCU2GR.bFSM_Rmp_BC_COn;
MM2VIS.rPRampExtBC_SetEU_Up			:= IN_GR.tCU2GR.rP_FSM_Rmp_Up_BC;
MM2VIS.rPRampExtAi_SetEU_Up			:= IN_GR.tHA2GR.tFSM_Rmp_Up.Ai;
MM2VIS.rPRampExtBC_SetEU_Down		:= IN_GR.tCU2GR.rP_FSM_Rmp_Down_BC;
MM2VIS.rPRampExtAi_SetEU_Down		:= IN_GR.tHA2GR.tFSM_Rmp_Down.Ai;

MM2VIS.rU_droopBC					:= IN_GR.tCU2GR.rU_Droop_BC;
MM2VIS.rU_droopAI					:= IN_GR.tHA2GR.tU_Droop.Ai;

MM2VIS.rF_FC_Deadband_posBC			:= IN_GR.tCU2GR.rF_FSMO_DB_BC;
MM2VIS.rF_FC_Deadband_posAi			:= IN_GR.tHA2GR.tF_FSMO_DB.Ai;
MM2VIS.rDroop_FC_posBC				:= IN_GR.tCU2GR.rP_FSMO_Droop_BC;
MM2VIS.rDroop_FC_posAi				:= IN_GR.tHA2GR.tF_FSMO_Droop.Ai;
MM2VIS.rF_FC_Deadband_negBC			:= IN_GR.tCU2GR.rF_FSMU_DB_BC;
MM2VIS.rF_FC_Deadband_negAi			:= IN_GR.tHA2GR.tF_FSMU_DB.Ai;
MM2VIS.rDroop_FC_negBC				:= IN_GR.tCU2GR.rP_FSMU_Droop_BC;
MM2VIS.rDroop_FC_negAi				:= IN_GR.tHA2GR.tF_FSMU_Droop.Ai;

MM2VIS.rF_LFSMU_GrC_DeadBand_negBC	:= IN_GR.tCU2GR.rF_LFSMU_DB_BC;
MM2VIS.rF_LFSMU_GrC_DeadBand_negAi	:= IN_GR.tHA2GR.tF_LFSMU_DB.Ai;
MM2VIS.rDroop_GrC_LFSMU_negBC		:= IN_GR.tCU2GR.rP_LFSMU_Droop_BC;
MM2VIS.rDroop_GrC_LFSMU_negAi		:= IN_GR.tHA2GR.tF_LFSMU_Droop.Ai;
MM2VIS.rF_LFSMO_GrC_DeadBand_posBC	:= IN_GR.tCU2GR.rF_LFSMO_DB_BC;
MM2VIS.rF_LFSMO_GrC_DeadBand_posAi	:= IN_GR.tHA2GR.tF_LFSMO_DB.Ai;
MM2VIS.rDroop_GrC_LFSMO_posBC		:= IN_GR.tCU2GR.rP_LFSMO_Droop_BC;
MM2VIS.rDroop_GrC_LFSMO_posAi		:= IN_GR.tHA2GR.tF_LFSMO_Droop.Ai;

MM2VIS.bFC_SetCOn					:= IN_GR.bFC_SetCOn;
MM2VIS.bFC_SetCOf					:= IN_GR.bFC_SetCOf;
MM2VIS.bSet_FC_COn_Bus				:= IN_GR.bSet_FC_COn_Bus;
MM2VIS.bSet_FC_COf_Bus				:= IN_GR.bSet_FC_COf_Bus;
	
MM2VIS.bILF_SetCOn					:= IN_GR.bILF_SetCOn;
MM2VIS.bILF_SetCOf					:= IN_GR.bILF_SetCOf;
MM2VIS.bSet_ILF_COn_Bus				:= IN_GR.bSet_ILF_COn_Bus;
MM2VIS.bSet_ILF_COf_Bus				:= IN_GR.bSet_ILF_COf_Bus;	

//MM2VIS.rQmns_pv_1					:= IN_GR.tQ_Act[1].Ai;
//MM2VIS.rQmns_sp_1					:= MM2VIS.rQ_set * Para.rS_Nom * (-1);(* change sign for VZS*)
//MM2VIS.rUmns_pv_1					:= IN_GR.tU_Avg[1].Ai;
//MM2VIS.rUmns_sp_1					:= MM2VIS.rU_set * Para.rU_GrC_SetEU_Nom;
//MM2VIS.rPFmns_pv_1					:= IN_GR.tPF_Act[1].Ai;
//MM2VIS.rPFmns_sp_1					:= rPF_EU;

END_PROGRAM
