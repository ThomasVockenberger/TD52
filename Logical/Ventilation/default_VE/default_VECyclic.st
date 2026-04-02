(*******************************************************************************
default		value set

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.99.0		24.04.2012	lettenb.	new
V4.00.01	26.03.2014	lettenb.	tER_DoorClosed.Di added
V4.03.00	30.09.2015	lettenb.	tAuxV_Aux_ok and tAuxV_ModIf_ok added
V4.04.00	01.06.2016	Tinello		tDPr_InAirFiltERV_Hi added
V4.04.00    27.09.2016  Stary       added tER_InlAir_Ext_Err, tER_OutlAir_Ext_Err, tERV_InlAir_Op, tERV_OutlAir_Op
									moved default TRUE-settings for louvers to Vent_ER
V4.07.00    25.02.2019	Stary/lett. bAuxRel_FireProtFlaps: FireProtFlap feedback signals included in aux.release, safety case
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	IN_VE.tER_Ext_Err.Di			:=	IN_VE.tER_Ext_Err.Di			OR	NOT IN_VE.tER_Ext_Err.GoodQual;
	IN_VE.tER_InlAir_Ext_Err.Di		:=	IN_VE.tER_InlAir_Ext_Err.Di		OR	NOT IN_VE.tER_InlAir_Ext_Err.GoodQual;
	IN_VE.tER_OutlAir_Ext_Err.Di	:=	IN_VE.tER_OutlAir_Ext_Err.Di	OR	NOT IN_VE.tER_OutlAir_Ext_Err.GoodQual;
	IN_VE.tT_AirER_Ext_Hi.Di		:=	IN_VE.tT_AirER_Ext_Hi.Di		OR	NOT IN_VE.tT_AirER_Ext_Hi.GoodQual;
	IN_VE.tAuxV_Supply_Ok.Di		:=	IN_VE.tAuxV_Supply_Ok.Di		OR	NOT IN_VE.tAuxV_Supply_Ok.GoodQual;
	IN_VE.tAuxV_ModIf_ok.Di			:=	IN_VE.tAuxV_ModIf_ok.Di			OR	NOT IN_VE.tAuxV_ModIf_ok.GoodQual;				(*PJ*)
	IN_VE.tAuxV_Aux_ok.Di			:=	IN_VE.tAuxV_Aux_ok.Di			OR	NOT IN_VE.tAuxV_Aux_ok.GoodQual;			(*PJ*)
	IN_VE.tRel_ER_PurgeCycle.Di		:=	IN_VE.tRel_ER_PurgeCycle.Di		OR	NOT IN_VE.tRel_ER_PurgeCycle.GoodQual; 
	IN_VE.tERV_Op.Di				:=	IN_VE.tERV_Op.Di				OR	NOT IN_VE.tERV_Op.GoodQual;
	IN_VE.tERV_InlAir_Op.Di         :=  IN_VE.tERV_InlAir_Op.Di         OR  NOT IN_VE.tERV_InlAir_Op.GoodQual;
	IN_VE.tERV_OutlAir_Op.Di        :=  IN_VE.tERV_OutlAir_Op.Di        OR  NOT IN_VE.tERV_OutlAir_Op.GoodQual;
	IN_VE.tER_DoorClosed.Di			:=	IN_VE.tER_DoorClosed.Di			OR	NOT IN_VE.tER_DoorClosed.GoodQual; 
	IN_VE.tDPr_InAirFiltERV_Hi.Di 	:= 	IN_VE.tDPr_InAirFiltERV_Hi.Di 	OR	NOT IN_VE.tDPr_InAirFiltERV_Hi.GoodQual;	(* old: E_FILTER *)

	IN_VE.tFireProtFlap1_InlAir_Opened.Di  := IN_VE.tFireProtFlap1_InlAir_Opened.Di  OR NOT IN_VE.tFireProtFlap1_InlAir_Opened.GoodQual;
	IN_VE.tFireProtFlap2_InlAir_Opened.Di  := IN_VE.tFireProtFlap2_InlAir_Opened.Di  OR NOT IN_VE.tFireProtFlap2_InlAir_Opened.GoodQual;
	IN_VE.tFireProtFlap1_OutlAir_Opened.Di := IN_VE.tFireProtFlap1_OutlAir_Opened.Di OR NOT IN_VE.tFireProtFlap1_OutlAir_Opened.GoodQual;
	IN_VE.tFireProtFlap2_OutlAir_Opened.Di := IN_VE.tFireProtFlap2_OutlAir_Opened.Di OR NOT IN_VE.tFireProtFlap2_OutlAir_Opened.GoodQual;
	IN_VE.tFireProtFlap1_InlAir_Closed.Di  := IN_VE.tFireProtFlap1_InlAir_Closed.Di  OR NOT IN_VE.tFireProtFlap1_InlAir_Closed.GoodQual;
	IN_VE.tFireProtFlap2_InlAir_Closed.Di  := IN_VE.tFireProtFlap2_InlAir_Closed.Di  OR NOT IN_VE.tFireProtFlap2_InlAir_Closed.GoodQual;
	IN_VE.tFireProtFlap1_OutlAir_Closed.Di := IN_VE.tFireProtFlap1_OutlAir_Closed.Di OR NOT IN_VE.tFireProtFlap1_OutlAir_Closed.GoodQual;
	IN_VE.tFireProtFlap2_OutlAir_Closed.Di := IN_VE.tFireProtFlap2_OutlAir_Closed.Di OR NOT IN_VE.tFireProtFlap2_OutlAir_Closed.GoodQual;
	
END_PROGRAM
