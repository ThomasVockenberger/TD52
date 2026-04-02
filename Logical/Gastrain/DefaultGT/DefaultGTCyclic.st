(*******************************************************************************
DefaultGT		value set

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
Customized modifications: -
------------------------
 
History:
-------
V3.99.0		18.09.2012	Denk	new
V04.03.00	02.07.2015	Denk 	Backfire device for 4 gaslines and prechamber
V04.04.00	02.12.2016	Denk 	IN_GT.tSIFA_BOV.Di added
V04.07.00   04.04.2019	Zengerer ParaFactoryDefaults in Init, against missing values at upgrade engines
V04.07.01   06.06.2019	Zengerer ParaFactoryDefaults in Init
V04.25.00	17.12.2025	Theobald With SafetyPLC the gas safety device signals will not be set
																																		
Instructions for use:
--------------------
- Default TRUE setting for not existing Di's

Outstandings:
------------


*******************************************************************************)

PROGRAM _CYCLIC

	(* Default TRUE setting for not existing Di's *)
	IN_GT.tDiffPrct_TC2.Di			:= IN_GT.tDiffPrct_TC2.Di 			OR NOT IN_GT.tDiffPrct_TC2.GoodQual;		
	IN_GT.tGndFailure_TC2.Di		:= IN_GT.tGndFailure_TC2.Di 		OR NOT IN_GT.tGndFailure_TC2.GoodQual;		
	IN_GT.tGT1_SafeDevOK.Di			:=(IN_GT.tGT1_SafeDevOK.Di 			OR NOT IN_GT.tGT1_SafeDevOK.GoodQual) AND NOT IN_GT.bSafetyPLC_Active; 	(* SAFETY PLC *)
	IN_GT.tGT2_SafeDevOK.Di			:=(IN_GT.tGT2_SafeDevOK.Di 			OR NOT IN_GT.tGT2_SafeDevOK.GoodQual) AND NOT IN_GT.bSafetyPLC_Active;	(* SAFETY PLC *)
	IN_GT.tFlairRdy.Di				:= IN_GT.tFlairRdy.Di 				OR NOT IN_GT.tFlairRdy.GoodQual;		
	IN_GT.tRelGasPlant.Di			:= IN_GT.tRelGasPlant.Di 			OR NOT IN_GT.tRelGasPlant.GoodQual;			
	IN_GT.tPr_GT_MinBefCompr.Di		:= IN_GT.tPr_GT_MinBefCompr.Di 		OR NOT IN_GT.tPr_GT_MinBefCompr.GoodQual;
	IN_GT.tT_GT_Ok.Di				:= IN_GT.tT_GT_Ok.Di 				OR NOT IN_GT.tT_GT_Ok.GoodQual;				
	IN_GT.tGT_GC_Fail.Di			:= IN_GT.tGT_GC_Fail.Di 			OR NOT IN_GT.tGT_GC_Fail.GoodQual;			
	IN_GT.tGT_FlairFail.Di			:= IN_GT.tGT_FlairFail.Di 			OR NOT IN_GT.tGT_FlairFail.GoodQual;
	IN_GT.tGT_FlareOpMod.Di			:= IN_GT.tGT_FlareOpMod.Di 			OR NOT IN_GT.tGT_FlareOpMod.GoodQual;		
	IN_GT.tPr_PCG_Min.Di			:= IN_GT.tPr_PCG_Min.Di 			OR NOT IN_GT.tPr_PCG_Min.GoodQual;	
	IN_GT.tOlShortCirc_TC2.Di		:= IN_GT.tOlShortCirc_TC2.Di 		OR NOT IN_GT.tOlShortCirc_TC2.GoodQual;	
	IN_GT.tGenPrctTrip_TC2.Di		:= IN_GT.tGenPrctTrip_TC2.Di 		OR NOT IN_GT.tGenPrctTrip_TC2.GoodQual;	
	IN_GT.tPr_GT1_Min.Di			:= IN_GT.tPr_GT1_Min.Di 			OR NOT IN_GT.tPr_GT1_Min.GoodQual;	
	IN_GT.tPr_GT2_Min.Di			:= IN_GT.tPr_GT2_Min.Di 			OR NOT IN_GT.tPr_GT2_Min.GoodQual;	
	IN_GT.tPr_GT1_Max.Di			:= IN_GT.tPr_GT1_Max.Di 			OR NOT IN_GT.tPr_GT1_Max.GoodQual;	
	IN_GT.tPr_GT2_Max.Di			:= IN_GT.tPr_GT2_Max.Di 			OR NOT IN_GT.tPr_GT2_Max.GoodQual;
	IN_GT.tSafetyLoop_Eng.Di		:= IN_GT.tSafetyLoop_Eng.Di 		OR NOT IN_GT.tSafetyLoop_Eng.GoodQual;
	IN_GT.tP_GT_Max_Backfire.Di		:= IN_GT.tP_GT_Max_Backfire.Di 		OR NOT IN_GT.tP_GT_Max_Backfire.GoodQual;
	IN_GT.tPCG_GC_Fail.Di			:= IN_GT.tPCG_GC_Fail.Di 			OR NOT IN_GT.tPCG_GC_Fail.GoodQual;
	IN_GT.tPCG_GC_Oil_Min.Di		:= IN_GT.tPCG_GC_Oil_Min.Di 		OR NOT IN_GT.tPCG_GC_Oil_Min.GoodQual;
	IN_GT.tGT_BackFireDev.Di		:= IN_GT.tGT_BackFireDev.Di 		OR NOT IN_GT.tGT_BackFireDev.GoodQual;
	IN_GT.tGT1_1_BackFireDev.Di		:= IN_GT.tGT1_1_BackFireDev.Di 		OR NOT IN_GT.tGT1_1_BackFireDev.GoodQual;
	IN_GT.tGT1_2_BackFireDev.Di		:= IN_GT.tGT1_2_BackFireDev.Di 		OR NOT IN_GT.tGT1_2_BackFireDev.GoodQual;
	IN_GT.tGT1_3_BackFireDev.Di		:= IN_GT.tGT1_3_BackFireDev.Di 		OR NOT IN_GT.tGT1_3_BackFireDev.GoodQual;
	IN_GT.tGT1_4_BackFireDev.Di		:= IN_GT.tGT1_4_BackFireDev.Di 		OR NOT IN_GT.tGT1_4_BackFireDev.GoodQual;
	IN_GT.tPCbComp_BackFireDev.Di 	:= IN_GT.tPCbComp_BackFireDev.Di 	OR NOT IN_GT.tPCbComp_BackFireDev.GoodQual;
	IN_GT.tPCaComp_BackFireDev.Di	:= IN_GT.tPCaComp_BackFireDev.Di 	OR NOT IN_GT.tPCaComp_BackFireDev.GoodQual;
	IN_GT.tRelMainGVext.Di			:= IN_GT.tRelMainGVext.Di 			OR NOT IN_GT.tRelMainGVext.GoodQual;
	IN_GT.tPr_PCGBefComp_Lo.Di		:= IN_GT.tPr_PCGBefComp_Lo.Di 		OR NOT IN_GT.tPr_PCGBefComp_Lo.GoodQual;
	IN_GT.tT_PCGAfComp_Hi.Di		:= IN_GT.tT_PCGAfComp_Hi.Di 		OR NOT IN_GT.tT_PCGAfComp_Hi.GoodQual;
	IN_GT.tGT_AirSupply_LoLo.Di		:= IN_GT.tGT_AirSupply_LoLo.Di		OR NOT IN_GT.tGT_AirSupply_LoLo.GoodQual;
	IN_GT.tPr_GT1_1_Max.Di			:= IN_GT.tPr_GT1_1_Max.Di 			OR NOT IN_GT.tPr_GT1_1_Max.GoodQual;
	IN_GT.tPr_GT1_2_Max.Di			:= IN_GT.tPr_GT1_2_Max.Di 			OR NOT IN_GT.tPr_GT1_2_Max.GoodQual;
	IN_GT.tPr_GT1_3_Max.Di			:= IN_GT.tPr_GT1_3_Max.Di 			OR NOT IN_GT.tPr_GT1_3_Max.GoodQual;
	IN_GT.tPr_GT1_4_Max.Di			:= IN_GT.tPr_GT1_4_Max.Di 			OR NOT IN_GT.tPr_GT1_4_Max.GoodQual;
	IN_GT.tPr_GT1_1_Min.Di			:= IN_GT.tPr_GT1_1_Min.Di 			OR NOT IN_GT.tPr_GT1_1_Min.GoodQual;
	IN_GT.tPr_GT1_2_Min.Di			:= IN_GT.tPr_GT1_2_Min.Di 			OR NOT IN_GT.tPr_GT1_2_Min.GoodQual;
	IN_GT.tPr_GT1_3_Min.Di			:= IN_GT.tPr_GT1_3_Min.Di 			OR NOT IN_GT.tPr_GT1_3_Min.GoodQual;
	IN_GT.tPr_GT1_4_Min.Di			:= IN_GT.tPr_GT1_4_Min.Di 			OR NOT IN_GT.tPr_GT1_4_Min.GoodQual;
	IN_GT.tSIFA_BOV.Di              := IN_GT.tSIFA_BOV.Di       		OR NOT IN_GT.tSIFA_BOV.GoodQual;   
	
END_PROGRAM

