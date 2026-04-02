(*******************************************************************************
vis			visualization

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
Customized modifications: -
------------------------
 
History:
-------
V3.40.0	21.02.2013	lettenb.	tT_HW_Re_LT added
V3.99.0	24.04.2012	lettenb.	new
		25.09.2012				bEC_Dem added for diane_vis
V4.00.0 15.12.2014				tT_HW_Re_LT --> rT_HW_Re_LT, bugfix
								tPr_ECWaEng,tT_ECWbEng added
V4.03.0 06.07.2015				920 ECW + EO module signals added(TCA redesign)
        29.07.2015	plattner	heat circuit temperature added
        05.08.2015  Stary       primary/secondary temperatures added
 		07.08.2015  Denk		Manual operating auxiliaries control functionality added
V4.04.0 04.05.2016	lettenb.	rT_ECW_bChC_HT, rT_ECW_bOilC, rT_ECW_bECWC added
		21.10.2016				MM2VIS.bEC_On,MM2VIS.bChC_On added(stary)
V4.07.0	09.08.2018	Schmid		2nd low temperature charge cooling circuit added
V4.14.0 08.11.2024	Bacci		MM2VIS.bECW_ShutOffVal_Dem (exist), MM2VIS.bValHeater_Dem (exist), MM2VIS.bFanRingHeater_Dem (exist) added
V4.25.0	10.07.2025	Tinello		SafetyPLC: Added heating water supply temperature unit

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	MM2VIS.rT_AirOutdoor	:=	IN_HC.tT_AirOutdoor.Ai;
	MM2VIS.bECW_DemBpP		:=	bECW_DemBpP;
	MM2VIS.bEC_Stage1		:=	K_ST1 OR K_ST1_ManAuxCtr;
	MM2VIS.bEC_Stage2		:=	K_ST2 OR K_ST2_ManAuxCtr;
	MM2VIS.bEC_Dem			:=	K_ST1 OR K_ST2 OR K_ST1_ManAuxCtr OR K_ST2_ManAuxCtr;
	MM2VIS.iSumChC_Stages	:=	iSumChC_Stages;
	MM2VIS.iSumEC_Stages	:=	iSumEC_Stages;

	MM2VIS.rT_HW_ReBeEng	:=	IN_HC.tT_HW_ReBeEng.Ai;
	MM2VIS.rT_HW_ReAfEC		:=	IN_HC.tT_HW_ReAfEC.Ai;
	MM2VIS.rT_HW_Re			:=	IN_HC.tT_HW_Re.Ai;
	MM2VIS.rT_HW_Su			:=	IN_HC.tT_HW_Su.Ai;
	MM2VIS.rPr_ECW			:=	IN_HC.tPr_ECW.Ai;
	MM2VIS.rPr_ECWaEng		:=	IN_HC.tPr_ECWaEng.Ai;
	MM2VIS.rT_ECW			:=	IN_HC.tT_ECW.Ai;
	MM2VIS.rP_Red_T_HWR_Norm:=	OUT_HC.rP_Red_T_HWR_Norm;
	MM2VIS.rP_Red_T_ECW_Norm:=	OUT_HC.rP_Red_T_ECW_Norm;
	MM2VIS.rT_HW_Su_LT		:=	IN_HC.tT_HW_Su_LT.Ai;
	MM2VIS.rT_HW_Re_LT		:=	IN_HC.tT_HW_Re_LT.Ai;
	MM2VIS.rT_Su_PriCirc    :=  IN_HC.tT_Su_PriCirc.Ai;
	MM2VIS.rT_Re_PriCirc    :=  IN_HC.tT_Re_PriCirc.Ai;
	MM2VIS.rT_Su_SecCirc    :=  IN_HC.tT_Su_SecCirc.Ai;
	MM2VIS.rT_Re_SecCirc    :=  IN_HC.tT_Re_SecCirc.Ai;
	MM2VIS.rP_Heat          :=  IN_HC.tP_Heat.Ai;
	
	MM2VIS.rT_ECWbEng		:=	IN_HC.tT_ECWbEng.Ai;
	MM2VIS.rT_ECW_AfEng		:=	IN_HC.tT_ECW_AfEng.Ai;

	MM2VIS.rPr_HW_Su_LT		:=	IN_HC.tPr_HW_Su_LT.Ai;
	MM2VIS.rPr_HW_Su_HT		:=	IN_HC.tPr_HW_Su_HT.Ai;

	MM2VIS.rPr_HW_Re_LT         := IN_HC.tPr_HW_Re_LT.Ai;      (*pressure heat water return low temp.circuit M.07-PI-002*)
	MM2VIS.rPr_HW_Re_HT         := IN_HC.tPr_HW_Re_HT.Ai;      (*pressure heat water return high temp.circuit M.06-PI-002*)
	MM2VIS.rPr_HW_Re_PreH_ECW   := IN_HC.tPr_HW_Re_PreH_ECW.Ai;(*pressure heat water return preheating engine cooling water M.04-PI-005*)
	MM2VIS.rPr_HW_Re_PreH_EO    := IN_HC.tPr_HW_Re_PreH_EO.Ai; (*pressure heat water return preheating engine oil M.03-PI-005*)
	MM2VIS.rPr_EO_Mod_Out       := IN_HC.tPr_EO_Mod_Out.Ai;    (*pressure engine oil module outlet M.03-PI-006*) (*OldName:newPv; Cycle:5;*)
	MM2VIS.rT_ECW_Mod_In        := IN_HC.tT_ECW_Mod_In.Ai;     (*temperature engine cooling water, engine cooling water module inlet M.04-TI-003*)
	MM2VIS.rT_ECW_Mod_Out       := IN_HC.tT_ECW_Mod_Out.Ai;    (*temperature engine cooling water, engine cooling water module outlet M.04-TI-004*)
	MM2VIS.rT_EO_Mod_In         := IN_HC.tT_EO_Mod_In.Ai;      (*temperature engine oil, oil module inlet M.03-TI-004*)
	MM2VIS.rT_EO_Mod_Out        := IN_HC.tT_EO_Mod_Out.Ai;     (*temperature engine oil, oil module outlet M.03-TI-003*)
	MM2VIS.rT_HW_Su_PreH_ECW    := IN_HC.tT_HW_Su_PreH_ECW.Ai; (*temperature heat water supply preheating engine cooling water M.04-TI-005*)
	MM2VIS.rT_HW_Re_PreH_ECW    := IN_HC.tT_HW_Re_PreH_ECW.Ai; (*temperature heat water return preheating engine cooling water M.04-TI-006*)
	MM2VIS.rT_HW_Su_PreH_EO     := IN_HC.tT_HW_Su_PreH_EO.Ai;  (*temperature heat water supply preheating engine oil M.03-TI-005*)
	MM2VIS.rT_HW_Re_PreH_EO     := IN_HC.tT_HW_Re_PreH_EO.Ai;  (*temperature heat water return preheating engine oil M.03-TI-006*)
	MM2VIS.rT_ECW_bChC_HT     	:= IN_HC.tT_ECW_bChC_HT.Ai;	   (*temperature engine cooling water high temp.circ.before charge cooler M.06-TI-014*)
	MM2VIS.rT_ECW_bOilC     	:= IN_HC.tT_ECW_bOilC.Ai;	   (*temperature engine cooling water before oil cooler M.06-TI-020*)
	MM2VIS.rT_ECW_bECWC     	:= IN_HC.tT_ECW_bECWC.Ai;	   (*temperature engine cooling water before engine cooling water cooler M.06-TI-030*)
	
	MM2VIS.bEC_DemPump			:= OUT_HC.tEC_DemPump.Do;
	MM2VIS.bChC_DemPump			:= OUT_HC.tChC_DemPump.Do;
	MM2VIS.bEC_On     			:= (MM2VIS.iSumEC_Stages = 1  AND NOT MM2VIS.bMsg2116) OR (MM2VIS.iSumEC_Stages > 1  AND MM2VIS.bMsg2116);
	MM2VIS.bChC_On    			:= (MM2VIS.iSumChC_Stages = 1 AND NOT MM2VIS.bMsg2119) OR (MM2VIS.iSumChC_Stages > 1 AND MM2VIS.bMsg2119);

	MM2VIS.rT_CD_Su					:=	IN_HC.tT_CD_Su.Ai;
	MM2VIS.rT_CD_Re					:=	IN_HC.tT_CD_Re.Ai;
	MM2VIS.bBHV_Dem					:=	OUT_HC.tBHV_Dem.Do AND NOT MM2VIS.bMsg2736;
	MM2VIS.bCDP_Dem					:=	IN_HC.tCDP_Dem.Do AND NOT MM2VIS.bMsg2735;
	MM2VIS.rT_HW_HC_Re				:=	IN_HC.tT_HW_HC_Re.Ai;
	MM2VIS.bHWF_Dem					:=	OUT_HC.tHWF_Dem.Do AND NOT MM2VIS.bMsg2750;
	MM2VIS.bChC_Heating_Dem 		:=  OUT_HC.tChC_Heating.Do;
	MM2VIS.bECW_ShutOffVal_Dem		:=	OUT_HC.tECW_ShutOffVal_Dem.Do;
	MM2VIS.bECW_ShutOffVal_Dem_Exist:=	bECW_ShutOffVal_Dem_Exist;
	MM2VIS.bValHeater_Dem			:=	OUT_HC.tValHeater_Dem.Do;
	MM2VIS.bValHeater_Dem_Exist		:=	bValHeater_Dem_Exist;
	MM2VIS.bFanRingHeater_Dem		:=	OUT_HC.tFanRingHeater_Dem.Do;
	MM2VIS.bFanRingHeater_Dem_Exist	:=	bFanRingHeater_Dem_Exist;

	MM2VIS.bChC2_DemPump		:=	OUT_HC.tChC2_DemPump.Do;
	MM2VIS.iSumChC2_Stages		:=	iSumChC2_Stages;
	MM2VIS.bChC2_On    			:= (MM2VIS.iSumChC2_Stages = 1 AND NOT MM2VIS.bMsg9228) OR (MM2VIS.iSumChC2_Stages > 1 AND MM2VIS.bMsg9228);
	MM2VIS.bChC2_Heating_Dem 	:=  OUT_HC.tChC2_Heating.Do;
	MM2VIS.rT_ChC2_Re_LT		:=  IN_HC.tT_ChC2_Re_LT.Ai;
	MM2VIS.rT_ChC2_Su_LT		:=  IN_HC.tT_ChC2_Su_LT.Ai;

	MM2VIS.rT_HW_Su_Unit		:=	IN_HC.tT_HW_Su_Unit.Ai;		(* SAFETY PLC *)
END_PROGRAM
