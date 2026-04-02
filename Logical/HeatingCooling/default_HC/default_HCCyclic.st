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
V3.99.0	24.04.2012	lettenb.	new
V4.00.0 14.04.2015				tChC_FanRdy added
V4.03.0 30.09.2015	plattner	tHWF_Fail, tAuxV_Aux_Ok, tAuxV_ModIf_ok, tCDP_Op added
V4.07.0	09.08.2018	Schmid		2nd low temperature charge cooling circuit added
V4.11.0	28.01.2022	Schmid		tECWP_Op added
																																	
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	IN_HC.tFlow_HW_Lo.Di			:=	IN_HC.tFlow_HW_Lo.Di			OR	NOT IN_HC.tFlow_HW_Lo.GoodQual;
	IN_HC.tPr_ChC_Lo.Di				:=	IN_HC.tPr_ChC_Lo.Di				OR	NOT IN_HC.tPr_ChC_Lo.GoodQual;
	IN_HC.tPr_ChC2_Lo.Di			:=	IN_HC.tPr_ChC2_Lo.Di			OR	NOT IN_HC.tPr_ChC2_Lo.GoodQual;
	IN_HC.tEC_Failure.Di			:=	IN_HC.tEC_Failure.Di			OR	NOT IN_HC.tEC_Failure.GoodQual;
	IN_HC.tChC_Failure.Di			:=	IN_HC.tChC_Failure.Di			OR	NOT IN_HC.tChC_Failure.GoodQual;
	IN_HC.tChC2_Failure.Di			:=	IN_HC.tChC2_Failure.Di			OR	NOT IN_HC.tChC2_Failure.GoodQual;
	IN_HC.tPr_CCircuit_Lo.Di		:=	IN_HC.tPr_CCircuit_Lo.Di		OR	NOT IN_HC.tPr_CCircuit_Lo.GoodQual;
	IN_HC.tT_ChCW_Hi.Di				:=	IN_HC.tT_ChCW_Hi.Di				OR	NOT IN_HC.tT_ChCW_Hi.GoodQual;
	IN_HC.tT_ChC2W_Hi.Di			:=	IN_HC.tT_ChC2W_Hi.Di			OR	NOT IN_HC.tT_ChC2W_Hi.GoodQual;
	IN_HC.tChC_FanRdy.Di			:=	IN_HC.tChC_FanRdy.Di			OR	NOT IN_HC.tChC_FanRdy.GoodQual;
	IN_HC.tChC2_FanRdy.Di			:=	IN_HC.tChC2_FanRdy.Di			OR	NOT IN_HC.tChC2_FanRdy.GoodQual;
	IN_HC.tAuxV_Aux_ok.Di			:=	IN_HC.tAuxV_Aux_ok.Di			OR	NOT IN_HC.tAuxV_Aux_ok.GoodQual;
	IN_HC.tAuxV_ModIf_ok.Di			:=	IN_HC.tAuxV_ModIf_ok.Di			OR	NOT IN_HC.tAuxV_ModIf_ok.GoodQual;
	IN_HC.tHWF_Fail.Di				:=	IN_HC.tHWF_Fail.Di				OR	NOT IN_HC.tHWF_Fail.GoodQual;
	IN_HC.tCDP_Op.Di				:=	IN_HC.tCDP_Op.Di				OR	NOT IN_HC.tCDP_Op.GoodQual;
	IN_HC.tECWP_Op.Di				:=	IN_HC.tECWP_Op.Di				OR	NOT IN_HC.tECWP_Op.GoodQual;

	//	IN_HC.x.Di		:=	IN_HC.x.Di		OR	NOT IN_HC.x.GoodQual;

END_PROGRAM
