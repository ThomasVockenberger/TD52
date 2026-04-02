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
V0.00.0	24.04.2012	lettenb.	new
V3.90.0 27.11.2012	lettenb.	missing Di's added
V4.04.0	04.10.2016				tScavFanFC_Rdy added
V4.13.0 19.10.2023	Heim Markus	add BurstingDisk1_Ok and BurstingDisk2_Ok
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	IN_EX.tEG_ByVaOpened.Di		:=	IN_EX.tEG_ByVaOpened.Di		OR	NOT IN_EX.tEG_ByVaOpened.GoodQual;
	IN_EX.tEG_BoVaOpened.Di		:=	IN_EX.tEG_BoVaOpened.Di		OR	NOT IN_EX.tEG_BoVaOpened.GoodQual;
	IN_EX.tEG_ByVaFailure.Di	:=	IN_EX.tEG_ByVaFailure.Di	OR	NOT IN_EX.tEG_ByVaFailure.GoodQual;
	IN_EX.tEG_BoVaFailure.Di	:=	IN_EX.tEG_BoVaFailure.Di	OR	NOT IN_EX.tEG_BoVaFailure.GoodQual;
	IN_EX.tScavFanCB_trip.Di	:=	IN_EX.tScavFanCB_trip.Di	OR	NOT IN_EX.tScavFanCB_trip.GoodQual;
	IN_EX.tScavVaFailure.Di		:=	IN_EX.tScavVaFailure.Di		OR	NOT IN_EX.tScavVaFailure.GoodQual;
	IN_EX.tPr_N2_Lo.Di			:=	IN_EX.tPr_N2_Lo.Di			OR	NOT IN_EX.tPr_N2_Lo.GoodQual;
	IN_EX.tPr_N2_Hi.Di			:=	IN_EX.tPr_N2_Hi.Di			OR	NOT IN_EX.tPr_N2_Hi.GoodQual;
	IN_EX.tAuxV_Eng_ok.Di		:=	IN_EX.tAuxV_Eng_ok.Di		OR	NOT IN_EX.tAuxV_Eng_ok.GoodQual;
	IN_EX.tCO2_DevFailure.Di	:=	IN_EX.tCO2_DevFailure.Di	OR	NOT IN_EX.tCO2_DevFailure.GoodQual;
	IN_EX.tCO2_FanFailure.Di	:=	IN_EX.tCO2_FanFailure.Di	OR	NOT IN_EX.tCO2_FanFailure.GoodQual;
	IN_EX.tCO2_VaFailure.Di		:=	IN_EX.tCO2_VaFailure.Di		OR	NOT IN_EX.tCO2_VaFailure.GoodQual;
	IN_EX.tPr_EG_Hi.Di			:=	IN_EX.tPr_EG_Hi.Di			OR	NOT IN_EX.tPr_EG_Hi.GoodQual;
	IN_EX.tScavFanFC_Rdy.Di		:=	IN_EX.tScavFanFC_Rdy.Di		OR	NOT IN_EX.tScavFanFC_Rdy.GoodQual;
	IN_EX.tBurstingDisk1_Ok.Di	:=	IN_EX.tBurstingDisk1_Ok.Di	OR	NOT IN_EX.tBurstingDisk1_Ok.GoodQual;
	IN_EX.tBurstingDisk2_Ok.Di	:=	IN_EX.tBurstingDisk2_Ok.Di	OR	NOT IN_EX.tBurstingDisk2_Ok.GoodQual;

END_PROGRAM
