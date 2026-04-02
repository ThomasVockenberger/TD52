(********************************************************************
VisGC	 			 General issues are handled here 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019


Customized modifications: -
------------------------
 
History:
-------
4.00.0	01.01.2013	ganguly		new
4.00.0	16.05.2014	lettenb.	cleanup
4.04.0	29.06.2016	lettenb.	tGen_T_In2 added, Dig142
4.05.0	30.11.2017	lettenb.	Q-management, unused MM2VIS-var removed
4.07.0	11.10.2018	lettenb.	Di: tU_Gen_Inc/Dec added for diagnosis
		29.04.2019	lettenb.	bU_Gen_Inc/Dec puls elongation for vis added(request requisition, mayer)
4.09.0	02.12.2019	lettenb.	ground failure counter added

Instructions for use: - 
--------------------
			
Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC
	
	MM2VIS.bP_CosPCtr_Red_F_Hi     := OUT_GC.bP_Red_CosPCtr_F_Hi;
	MM2VIS.bP_CosPCtr_Red_F_Lo     := OUT_GC.bP_Red_CosPCtr_F_Lo;
	MM2VIS.bP_CosPCtr_Red_U_Hi     := OUT_GC.bP_Red_CosPCtr_U_Hi;
	MM2VIS.bP_CosPCtr_Red_U_Lo     := OUT_GC.bP_Red_CosPCtr_U_Lo;	
	MM2VIS.rP_Gen_ppt              := rP_Gen_ppt;

	MM2VIS.rPF_CosPCtr_Set_Ctr13   := rPF_CosPCtr_Set_Ctr13;
	MM2VIS.rP_Red_CosPCtr_F        := rP_CosPCtr_F_Red;
	MM2VIS.rP_Red_CosPCtr_U        := rP_CosPCtr_U_Red;
	MM2VIS.rP_Red_CosPCtr_T        := rP_CosPCtr_T_Red;

	MM2VIS.rQ_CosPCtr_Set          := rQ_CosPCtr_Set;

	MM2VIS.rU_Gen_Exc              := OUT_GC.rU_Gen_Exc;
	
	MM2VIS.rT_Gen_Bear_A_Act       := IN_GC.tT_Gen_Bear_A_Act.Ai;
	MM2VIS.rT_Gen_Bear_B_Act       := IN_GC.tT_Gen_Bear_B_Act.Ai;
	MM2VIS.rT_Gen_Wind_Act_L1      := IN_GC.tT_Gen_Wind_Act_L1.Ai;
	MM2VIS.rT_Gen_Wind_Act_L2      := IN_GC.tT_Gen_Wind_Act_L2.Ai;
	MM2VIS.rT_Gen_Wind_Act_L3      := IN_GC.tT_Gen_Wind_Act_L3.Ai;
	MM2VIS.rT_Gen_Wind_Act         := IN_GC.tT_Gen_Wind.Ai;
	
	(* Oilskid *)	
	MM2VIS.bOilSkid_PumpLP_Dem 		:= OUT_GC.tOilSkid_PumpLP.Do;		
	MM2VIS.bOilSkid_PumpHP_Dem		:= OUT_GC.tOilSkid_PumpHP.Do OR OUT_GC.tOilSkid_PumpHP_UPS.Do;					
	MM2VIS.bOilSkid_PumpC_Dem 		:= OUT_GC.tOilSkid_PumpC.Do;						
	MM2VIS.bOilSkid_Fan_Dem 		:= OUT_GC.tOilSkid_Fan.Do; 							
	MM2VIS.bOilSkid_Heater_Dem 		:= OUT_GC.tOilSkid_Heater.Do;						
	MM2VIS.rLev_OilSkid_Tank		:= IN_GC.tLev_OilSkid_Tank.Ai;
	MM2VIS.rT_OilSkid_Tank			:= IN_GC.tT_OilSkid_Tank.Ai;
	MM2VIS.rPr_OilSkid_HP_NDE		:= IN_GC.tPr_OilSkid_HP_NDE.Ai;
	MM2VIS.rPr_OilSkid_HP_DE		:= IN_GC.tPr_OilSkid_HP_DE.Ai;
	MM2VIS.rFlow_OilSkid_DE			:= IN_GC.tFlow_OilSkid_DE.Ai;
	MM2VIS.rFlow_OilSkid_NDE		:= IN_GC.tFlow_OilSkid_NDE.Ai;
	MM2VIS.rT_OilSkid_Supply		:= IN_GC.tT_OilSkid_Supply.Ai;

	
	MM2VIS.rF_GenBear_DE1			:= IN_GC.tF_GenBear_DE1.Ai;
	MM2VIS.rF_GenBear_DE2			:= IN_GC.tF_GenBear_DE2.Ai;
	MM2VIS.rF_GenBear_NDE1			:= IN_GC.tF_GenBear_NDE1.Ai;
	MM2VIS.rF_GenBear_NDE2			:= IN_GC.tF_GenBear_NDE2.Ai;

	MM2VIS.rGen_T_In				:= IN_GC.tGen_T_In.Ai;
	MM2VIS.rGen_T_In2				:= IN_GC.tGen_T_In2.Ai;
	MM2VIS.rT_GenAirOut				:= IN_GC.tT_GenAirOut.Ai;

	xTP_U_Gen_Inc(IN:= EDGEPOS(IN_GC.tU_Gen_Inc.Di OR IN_GC.tU_Adj_Plus.Di), PT:= T#2s);(* DI voltage adjustment external (increasing)*)
	MM2VIS.bU_Gen_Inc				:= xTP_U_Gen_Inc.Q;

	xTP_U_Gen_Dec(IN:= EDGEPOS(IN_GC.tU_Gen_Dec.Di OR IN_GC.tU_Adj_Minus.Di), PT:= T#2s);(* DI voltage adjustment external (decreasing)*)
	MM2VIS.bU_Gen_Dec				:= xTP_U_Gen_Dec.Q;

	MM2VIS.bCntGndFail_Visible 		:= IN_GC.tGndFaultW.GoodQual; (* counter visibility *)
	
END_PROGRAM
