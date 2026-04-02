(*******************************************************************************
VisGT	 			 VISU variables 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2025

Customized modifications: -
------------------------
 
History:
-------
V04.00.00	19.06.2012	Denk	 	new
V04.00.01	21.02.2014	Zengerer	iIdx_SelGasTyp TESTBENCH MODIFICATION because of OPC UA troubles
V04.00.01	12.03.2014	Zengerer	Bugfix version
V04.00.02	13.05.2014	Denk		MM2VIS.rPr_PCGT added
V04.03.00  	13.11.2014  Mari 		Porting J920 for XT4
			11.02.2015	Denk		MM2VIS.rT_PCGT, MM2VIS.rPr_PCGT_a_Filt added 
			01.04.2015	Denk		MM2VIS.rT_GR := IN_GT.tT_GR.Ai; added 
			02.06.2015  Denk		MM2VIS.rPr_PCGT_sp, MM2VIS.rPr_MGT_sp now in gas_train task
V04.05.00   29.08.2017  Denk		MM2VIS.rT_PCGAfCo added
V04.06.00   20.09.2018  Perktold	MM2VIS.bGT_FS_Release added
V04.07.00	15.02.2019	Denk		Bugfix, when parameter 11363 is TRUE, AutGas was not active after PLC warmstart. 
V04.09.00	27.06.2019	Denk		Additional measurements in natural gas train (T_GT_NG, Pr_GT_NG, Vol_GT_NG)
V04.12.00	22.01.2023	Zuschnig	Add filtered H2 content
V04.25.00	30.12.2025	Tinello		Logic modified because of SafetyPLC
									
Instructions for use:
--------------------
			
Outstandings:
------------

(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Module 2 VISU *)
	MM2VIS.bGasMixingActive 	:= OUT_GT.bGasMixingActive;
	MM2VIS.bGT1_SafeDevice  	:= OUT_GT.tGT1_SafeDevice.Do OR IN_GT.bSafeOUT_GT1_SD_Dem_PS;		(* SAFETY PLC *)
	MM2VIS.bGT2_SafeDevice  	:= OUT_GT.tGT2_SafeDevice.Do OR IN_GT.bSafeOUT_GT2_SD_Dem_PS;		(* SAFETY PLC *)
	MM2VIS.rGT_QualMix_1_2   	:= OUT_GT.rGT_QualMix_1_2;	
	MM2VIS.rP_Red_CH4_Norm   	:= OUT_GT.rP_Red_CH4_Norm;	
	MM2VIS.rP_Red_CV_Norm    	:= OUT_GT.rP_Red_CV_Norm;	
	MM2VIS.rP_Red_GasPr_Norm 	:= OUT_GT.rP_Red_GasPr_Norm;
	MM2VIS.bGT1_FailureTest		:= M_STGAS1;
	MM2VIS.bGT2_FailureTest		:= M_STGAS2;
	MM2VIS.bGV1_Open			:= OUT_GT.tGV1_Open.Do;
	MM2VIS.bGV2_Open			:= OUT_GT.tGV2_Open.Do;
	MM2VIS.bPCG_GV_Open			:= OUT_GT.tPCG_GV_Open.Do;
	MM2VIS.bPCG_BPV_Open		:= OUT_GT.tPCG_BPV_Open.Do;
	MM2VIS.bGT1_CheckOK			:= OUT_GT.bGT1_CheckOK;
	MM2VIS.bGT2_CheckOK			:= OUT_GT.bGT2_CheckOK;
	MM2VIS.bGT_FS_Release		:= OUT_GT.bGT1_SafeDevOK AND OUT_GT.bGT2_SafeDevOK AND OUT_GT.bPCGT_SafeDevOK;
	MM2VIS.rGT_RatioMix			:= OUT_GT.rGT_RatioMix;
	MM2VIS.rP_Red_Pr_PCGT_Norm	:= OUT_GT.rP_Red_Pr_PCGT_Norm;
	MM2VIS.bSelGasTyp1			:= OUT_GT.bSelGasTyp1;
	MM2VIS.bSelGasTyp2			:= OUT_GT.bSelGasTyp2;
	MM2VIS.bSelGasTyp3			:= OUT_GT.bSelGasTyp3;
	MM2VIS.bSelGasTyp4			:= OUT_GT.bSelGasTyp4;
	MM2VIS.bSelGasTyp0			:= OUT_GT.bSelGasTyp0;
	MM2VIS.bSelGasTypAut 		:= OUT_GT.bSelGasTypAut;
	MM2VIS.bSelGasTypMix		:= OUT_GT.bSelGasTypMix;
	IF OUT_GT.iIdx_Gtyp_Dem > 0 THEN 						
		MM2VIS.iIdx_Gtyp_Dem	:= OUT_GT.iIdx_Gtyp_Dem;
	ELSE
		IF bCrossOver THEN 
			MM2VIS.iIdx_Gtyp_Dem := 5; 
			IF OUT_GT.bGT_Ipol12Active THEN 
				MM2VIS.iIdx_Gtyp_Dem := 6; 
			END_IF
		END_IF
	END_IF
	MM2VIS.bGV_On				:= (OUT_GT.bGV_On 			AND NOT IN_GT.bSafetyPLC_Active) OR 	(* SAFETY PLC *)
								   (IN_GT.bSafeOUT_GV_Open	AND		IN_GT.bSafetyPLC_Active);		(* SAFETY PLC *)
	MM2VIS.rPr_PC_Diff			:= ANA_PDIFF;
	MM2VIS.rPr_PCGT				:= IN_GT.tPr_PCGT.Ai;
	MM2VIS.rPr_PCGT_a_Filt		:= IN_GT.tPr_PCGT.Ai;
	MM2VIS.rDPr_PCGT_SetAct		:= rDPr_PCGT_SetAct;
	MM2VIS.rDPr_MGT_SetAct 		:= rDPr_MGT_SetAct; 
	MM2VIS.rPr_MGT_Out_Calc		:= rPr_MGT_Out_Calc; 
	MM2VIS.rPr_GR_Avg			:= rPr_GR_Avg; 
	MM2VIS.rPr_PCGT_Out			:= IN_GT.tPr_PCGT_Out.Ai; 		
	MM2VIS.rPr_MGT_a_Filt		:= IN_GT.tPr_MGT_a_Filt.Ai;
	MM2VIS.bMGT_BOV				:= OUT_GT.tMGT_BOV.Do;
	MM2VIS.rPr_MGT_Diff			:= rPr_MGT_Diff;
	MM2VIS.rT_PCGAfCo   		:= IN_GT.tT_PCGAfCo.Ai;
	MM2VIS.rGT_H2 				:= xLCRPT1_H2.y;
	
	(* from HalIO *)	
	MM2VIS.rGT_CH4 			:= rGT_CH4;
	MM2VIS.rGT_CV  			:= rGT_CV; 	
	MM2VIS.rGT_O2 			:= IN_GT.tGT_O2.Ai;
	MM2VIS.rPr_PCG 			:= IN_GT.tPr_PCG.Ai;
	MM2VIS.rT_GT 			:= IN_GT.tT_GT.Ai;
	MM2VIS.rVol_GT 			:= IN_GT.tVol_GT.Ai;
  	MM2VIS.rPr_GT_Gas       := IN_GT.tPr_GT_Gas.Ai;
	MM2VIS.rPr_GT_Suct      := IN_GT.tPr_GT_Suct.Ai;
	MM2VIS.rPr_PC			:= IN_GT.tPr_PC.Ai;
	MM2VIS.rT_PCGT			:= IN_GT.tT_PCGT.Ai;
	MM2VIS.rT_GR 			:= IN_GT.tT_GR.Ai;	
	MM2VIS.rT_GT_NG			:= IN_GT.tT_GT_NG.Ai;
	MM2VIS.rPr_GT_NG		:= IN_GT.tPr_GT_NG.Ai;
	MM2VIS.rVol_GT_NG		:= IN_GT.tVol_GT_NG.Ai;
	
	(* VISU 2 Module *)
	IF EDGEPOS(Para.bGT_AutGas_Ena) THEN	(* Presetting of AutGas when parameter 11363 is TRUE *)		
		VIS2MM.iIdx_SelGasTyp := 7;																		
 	END_IF;
	iIdx_SelGasTyp       	:= VIS2MM.iIdx_SelGasTyp;	
	bGT_MixingEna        	:= VIS2MM.bGT_MixingEna;
	bGT_QualMix_Man_Set  	:= VIS2MM.bGT_QualMix_Man_Set;
	bGT_RatioMix_Man_Set 	:= VIS2MM.bGT_RatioMix_Man_Set;
	rGT_QualMix_Man_Set  	:= VIS2MM.rGT_QualMix_Man_Set;
	rGT_RatioMix_Man_Set 	:= VIS2MM.rGT_RatioMix_Man_Set;	

END_PROGRAM
