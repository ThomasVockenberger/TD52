(*******************************************************************************
default		value set

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0	21.11.2012	Ganguly.		new
V3.99.0	11.03.2013	lettenbichler	preset for tGen_LO_CoolingSys_Fail added
									preset for tU_Gen_LimLo2[1] added
V4.00.0 28.01.2015	lettenb.		920 added(stapelfeld)
V4.03.0	22.07.2015	lettenb.		dyn.gridcode III(thaler)
V4.09.0	02.12.2019	lettenb.		ground fault warning added(thaler)
V4.12.0	21.11.2022	lettenb.		automatic generator greasing system

 ********************************************************************)

PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	IN_GC.tOlShortCirc.Di      			:=  IN_GC.tOlShortCirc.Di 				OR NOT IN_GC.tOlShortCirc.GoodQual;
	IN_GC.tF_MMD_LimHi[0].Di      		:=  IN_GC.tF_MMD_LimHi[0].Di 			OR NOT IN_GC.tF_MMD_LimHi[0].GoodQual;
	IN_GC.tF_MMD_LimHi[1].Di       		:=  IN_GC.tF_MMD_LimHi[1].Di 			OR NOT IN_GC.tF_MMD_LimHi[1].GoodQual;
	IN_GC.tF_MMD_LimHi[2].Di       		:=  IN_GC.tF_MMD_LimHi[2].Di 			OR NOT IN_GC.tF_MMD_LimHi[2].GoodQual;
	IN_GC.tF_MMD_LimLo[0].Di       		:=  IN_GC.tF_MMD_LimLo[0].Di 			OR NOT IN_GC.tF_MMD_LimLo[0].GoodQual;
	IN_GC.tF_MMD_LimLo[1].Di       		:=  IN_GC.tF_MMD_LimLo[1].Di 			OR NOT IN_GC.tF_MMD_LimLo[1].GoodQual;
	IN_GC.tF_MMD_LimLo[2].Di      		:=  IN_GC.tF_MMD_LimLo[2].Di 			OR NOT IN_GC.tF_MMD_LimLo[2].GoodQual;
	IN_GC.tI_MMD_Neutr_LimHi[0].Di 		:=  IN_GC.tI_MMD_Neutr_LimHi[0].Di 		OR NOT IN_GC.tI_MMD_Neutr_LimHi[0].GoodQual;
	IN_GC.tI_MMD_Neutr_LimHi[1].Di 		:=  IN_GC.tI_MMD_Neutr_LimHi[1].Di 		OR NOT IN_GC.tI_MMD_Neutr_LimHi[1].GoodQual;
	IN_GC.tI_MMD_Neutr_LimHi[2].Di 		:=  IN_GC.tI_MMD_Neutr_LimHi[2].Di 		OR NOT IN_GC.tI_MMD_Neutr_LimHi[2].GoodQual;
	IN_GC.tU_Gen_LimLo[0].Di       		:=  IN_GC.tU_Gen_LimLo[0].Di 			OR NOT IN_GC.tU_Gen_LimLo[0].GoodQual;
	IN_GC.tU_Gen_LimLo[1].Di       		:=  IN_GC.tU_Gen_LimLo[1].Di 			OR NOT IN_GC.tU_Gen_LimLo[1].GoodQual;
	IN_GC.tU_Gen_LimLo[2].Di       		:=  IN_GC.tU_Gen_LimLo[2].Di 			OR NOT IN_GC.tU_Gen_LimLo[2].GoodQual;
	IN_GC.tU_Gen_LimHi[0].Di       		:=  IN_GC.tU_Gen_LimHi[0].Di 			OR NOT IN_GC.tU_Gen_LimHi[0].GoodQual;
	IN_GC.tU_Gen_LimHi[1].Di       		:=  IN_GC.tU_Gen_LimHi[1].Di 			OR NOT IN_GC.tU_Gen_LimHi[1].GoodQual;
	IN_GC.tU_Gen_LimHi[2].Di       		:=  IN_GC.tU_Gen_LimHi[2].Di 			OR NOT IN_GC.tU_Gen_LimHi[2].GoodQual;
	
	IN_GC.tU_Gen_LimLo2[1].Di			:=	IN_GC.tU_Gen_LimLo2[1].Di			OR NOT IN_GC.tU_Gen_LimLo2[1].GoodQual;
	IN_GC.tI_MMD_Asy[0].Di				:=  IN_GC.tI_MMD_Asy[0].Di 				OR NOT IN_GC.tI_MMD_Asy[0].GoodQual;
	IN_GC.tI_MMD_Asy[1].Di				:=  IN_GC.tI_MMD_Asy[1].Di				OR NOT IN_GC.tI_MMD_Asy[1].GoodQual;
	IN_GC.tI_MMD_Asy[2].Di				:=  IN_GC.tI_MMD_Asy[2].Di				OR NOT IN_GC.tI_MMD_Asy[2].GoodQual;
	IN_GC.tU_MMD_Asy[0].Di				:=  IN_GC.tU_MMD_Asy[0].Di				OR NOT IN_GC.tU_MMD_Asy[0].GoodQual;
	IN_GC.tU_MMD_Asy[1].Di				:=  IN_GC.tU_MMD_Asy[1].Di				OR NOT IN_GC.tU_MMD_Asy[1].GoodQual;
	IN_GC.tU_MMD_Asy[2].Di				:=  IN_GC.tU_MMD_Asy[2].Di				OR NOT IN_GC.tU_MMD_Asy[2].GoodQual;
	IN_GC.tI_Diff.Di               		:=  IN_GC.tI_Diff.Di 					OR NOT IN_GC.tI_Diff.GoodQual;
	IN_GC.tU_GenOverVolt.Di       		:=  IN_GC.tU_GenOverVolt.Di 			OR NOT IN_GC.tU_GenOverVolt.GoodQual;
	IN_GC.tFlow_Gen_Lube.Di        		:=  IN_GC.tFlow_Gen_Lube.Di 			OR NOT IN_GC.tFlow_Gen_Lube.GoodQual;
	IN_GC.tI_MMD_LimHi.Di          		:=  IN_GC.tI_MMD_LimHi.Di 				OR NOT IN_GC.tI_MMD_LimHi.GoodQual;
	IN_GC.tDiffPrct.Di         			:=  IN_GC.tDiffPrct.Di					OR NOT IN_GC.tDiffPrct.GoodQual;
	IN_GC.tGndFailure.Di       			:=  IN_GC.tGndFailure.Di				OR NOT IN_GC.tGndFailure.GoodQual;
	IN_GC.tGenPrctTrip.Di     	 		:=  IN_GC.tGenPrctTrip.Di 				OR NOT IN_GC.tGenPrctTrip.GoodQual;
	IN_GC.tGen_LO_CoolingSys_Fail.Di	:=	IN_GC.tGen_LO_CoolingSys_Fail.Di 	OR NOT IN_GC.tGen_LO_CoolingSys_Fail.GoodQual;
	IN_GC.tGenCtr_CktBkr_Trip.Di		:=	IN_GC.tGenCtr_CktBkr_Trip.Di		OR NOT IN_GC.tGenCtr_CktBkr_Trip.GoodQual;
	IN_GC.tGenIF_CB_On.Di				:=	IN_GC.tGenIF_CB_On.Di				OR NOT IN_GC.tGenIF_CB_On.GoodQual;
	IN_GC.tGenHeat_CB_On.Di				:=	IN_GC.tGenHeat_CB_On.Di				OR NOT IN_GC.tGenHeat_CB_On.GoodQual;

	IN_GC.tLev_OilSkid_Sump_Hi.Di		:=	IN_GC.tLev_OilSkid_Sump_Hi.Di		OR NOT IN_GC.tLev_OilSkid_Sump_Hi.GoodQual;
	IN_GC.tDPr_OilSkid_FiltLP_Hi.Di		:=	IN_GC.tDPr_OilSkid_FiltLP_Hi.Di		OR NOT IN_GC.tDPr_OilSkid_FiltLP_Hi.GoodQual;
	IN_GC.tDPr_OilSkid_FiltHP_DE_Hi.Di	:=	IN_GC.tDPr_OilSkid_FiltHP_DE_Hi.Di	OR NOT IN_GC.tDPr_OilSkid_FiltHP_DE_Hi.GoodQual;
	IN_GC.tDPr_OilSkid_FiltHP_NDE_Hi.Di	:=	IN_GC.tDPr_OilSkid_FiltHP_NDE_Hi.Di	OR NOT IN_GC.tDPr_OilSkid_FiltHP_NDE_Hi.GoodQual;
	IN_GC.tOilSkid_PumpLP_CBOk.Di		:=	IN_GC.tOilSkid_PumpLP_CBOk.Di		OR NOT IN_GC.tOilSkid_PumpLP_CBOk.GoodQual;
	IN_GC.tOilSkid_PumpHP_CBOk.Di		:=	IN_GC.tOilSkid_PumpHP_CBOk.Di		OR NOT IN_GC.tOilSkid_PumpHP_CBOk.GoodQual;
	IN_GC.tOilSkid_PumpHP_CBOk_UPS.Di	:=	IN_GC.tOilSkid_PumpHP_CBOk_UPS.Di	OR NOT IN_GC.tOilSkid_PumpHP_CBOk_UPS.GoodQual;
	IN_GC.tOilSkid_Fan_CBOk.Di			:=	IN_GC.tOilSkid_Fan_CBOk.Di			OR NOT IN_GC.tOilSkid_Fan_CBOk.GoodQual;
	IN_GC.tOilSkid_Heater_CBOk.Di		:=	IN_GC.tOilSkid_Heater_CBOk.Di		OR NOT IN_GC.tOilSkid_Heater_CBOk.GoodQual;
	IN_GC.tOilSkid_MCB.Di				:=	IN_GC.tOilSkid_MCB.Di				OR NOT IN_GC.tOilSkid_MCB.GoodQual;
	IN_GC.tOilSkid_AuxV_Ok.Di			:=	IN_GC.tOilSkid_AuxV_Ok.Di			OR NOT IN_GC.tOilSkid_AuxV_Ok.GoodQual;
	IN_GC.tOilSkid_AuxV_Ok_UPS.Di		:=	IN_GC.tOilSkid_AuxV_Ok_UPS.Di		OR NOT IN_GC.tOilSkid_AuxV_Ok_UPS.GoodQual;
	IN_GC.tOilSkid_PumpC_CBOk.Di		:=	IN_GC.tOilSkid_PumpC_CBOk.Di		OR NOT IN_GC.tOilSkid_PumpC_CBOk.GoodQual;
	
	IN_GC.tP_GenRev_Ext.Di				:=	IN_GC.tP_GenRev_Ext.Di				OR	NOT IN_GC.tP_GenRev_Ext.GoodQual;
	IN_GC.tGenLossExc_Ext.Di			:=	IN_GC.tGenLossExc_Ext.Di			OR	NOT IN_GC.tGenLossExc_Ext.GoodQual;
	IN_GC.tU_GenAsy_Ext.Di				:=	IN_GC.tU_GenAsy_Ext.Di				OR	NOT IN_GC.tU_GenAsy_Ext.GoodQual;
	IN_GC.tI_GenAsy_Ext.Di				:=	IN_GC.tI_GenAsy_Ext.Di				OR	NOT IN_GC.tI_GenAsy_Ext.GoodQual;
	IN_GC.tGenOverExc.Di				:=	IN_GC.tGenOverExc.Di				OR	NOT IN_GC.tGenOverExc.GoodQual;
	IN_GC.tGenRotorEarthFault.Di		:=	IN_GC.tGenRotorEarthFault.Di		OR	NOT IN_GC.tGenRotorEarthFault.GoodQual;	
	IN_GC.tQ_GenUnderVoltProt.Di		:=	IN_GC.tQ_GenUnderVoltProt.Di		OR	NOT IN_GC.tQ_GenUnderVoltProt.GoodQual;
	IN_GC.tGndFaultW.Di					:=	IN_GC.tGndFaultW.Di					OR	NOT IN_GC.tGndFaultW.GoodQual;
	IN_GC.tGenBearGreasSys2DE.Di		:=	IN_GC.tGenBearGreasSys2DE.Di		OR	NOT IN_GC.tGenBearGreasSys2DE.GoodQual;
	IN_GC.tGenBearGreasSys2NDE.Di		:=	IN_GC.tGenBearGreasSys2NDE.Di		OR	NOT IN_GC.tGenBearGreasSys2NDE.GoodQual;

END_PROGRAM
