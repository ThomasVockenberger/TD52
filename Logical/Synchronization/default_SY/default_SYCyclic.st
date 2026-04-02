(*******************************************************************************
default		values

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0	24.04.2012	lettenb.	new
V3.90.0	27.11.2012	lettenb.	corr.for P3 startup
V3.99.0	25.02.2012	lettenb.	3329,3352,3575,3576,3577 added (integration V3.30-V3.40)
V4.00.0 11.06.2014	lettenb.	tOnly_Island, tEngDemIsland added
		18.06.2014				tBB_Alive.Di removed, bugfix
V4.03.0	22.07.2015				2692,2693,2801 new, dyn.gridcode III(thaler)
		14.08.2015				IN_SY.tOnly_Island.Di init removed (see TBMode: OUT_SY.bOnly_Island	logic FOR standard mode corr. removed) (bugfix/pfanzagl)
V4.05.0	03.01.2018	lettenb.	tMnsOk_AfMnsF_ClosCond_Ok added, grid code logic(thaler)
V4.07.0	31.10.2018	lettenb.	tMidVoltCB_Failure added
V4.10.0	23.11.2020	lettenb.	tGndFault_BB added

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	(* note: existing but not used Di's if necessary have to be setted to TRUE by hardware *)
	IN_SY.tGCB_Rac.Di			:=	IN_SY.tGCB_Rac.Di			OR	NOT IN_SY.tGCB_Rac.GoodQual;
	IN_SY.tGCB_Rdy.Di			:=	IN_SY.tGCB_Rdy.Di			OR	NOT IN_SY.tGCB_Rdy.GoodQual;
	IN_SY.tGCB_MRC.Di			:=	IN_SY.tGCB_MRC.Di			OR	NOT IN_SY.tGCB_MRC.GoodQual;
	IN_SY.tGCB_AGO.Di			:=	IN_SY.tGCB_AGO.Di			OR	NOT IN_SY.tGCB_AGO.GoodQual;
	IN_SY.tGCB_RI.Di			:=	IN_SY.tGCB_RI.Di			OR	NOT IN_SY.tGCB_RI.GoodQual;

	IN_SY.tRel_I.Di				:=	IN_SY.tRel_I.Di				OR	NOT IN_SY.tRel_I.GoodQual;
	IN_SY.tRel_BS.Di			:=	IN_SY.tRel_BS.Di			OR	NOT IN_SY.tRel_BS.GoodQual;
	IN_SY.tRel_LS.Di			:=	IN_SY.tRel_LS.Di			OR	NOT IN_SY.tRel_LS.GoodQual;

	IN_SY.tMCB_Rac.Di			:=	IN_SY.tMCB_Rac.Di			OR	NOT IN_SY.tMCB_Rac.GoodQual;
	IN_SY.tMCB_Rdy.Di			:=	IN_SY.tMCB_Rdy.Di			OR	NOT IN_SY.tMCB_Rdy.GoodQual;
	IN_SY.tMCB_OL.Di			:=	IN_SY.tMCB_OL.Di			OR	NOT IN_SY.tMCB_OL.GoodQual;
	IN_SY.tMCB_Rem.Di			:=	IN_SY.tMCB_Rem.Di			OR	NOT IN_SY.tMCB_Rem.GoodQual;

	IN_SY.tMnsOk.Di				:=	IN_SY.tMnsOk.Di				OR	NOT IN_SY.tMnsOk.GoodQual;
	IN_SY.tMns_MDF.Di			:=	IN_SY.tMns_MDF.Di			OR	NOT IN_SY.tMns_MDF.GoodQual;

	IN_SY.tC_CB_Off.Di			:=	IN_SY.tC_CB_Off.Di			OR	NOT IN_SY.tC_CB_Off.GoodQual;
	IN_SY.tC_CB_ESL.Di			:=	IN_SY.tC_CB_ESL.Di			OR	NOT IN_SY.tC_CB_ESL.GoodQual;

	IN_SY.tLineCB_On.Di			:=	IN_SY.tLineCB_On.Di			OR	NOT IN_SY.tLineCB_On.GoodQual;

	IN_SY.tEngDemIsland.Di		:=	IN_SY.tEngDemIsland.Di		OR	NOT IN_SY.tEngDemIsland.GoodQual;
	(*------------------------------------------------------------------------------------*)

	IN_SY.tEarthCB_Off.Di		:=	IN_SY.tEarthCB_Off.Di		OR	NOT IN_SY.tEarthCB_Off.GoodQual;
	IN_SY.tIsoCB_Off.Di			:=	IN_SY.tIsoCB_Off.Di			OR	NOT IN_SY.tIsoCB_Off.GoodQual;
	IN_SY.tMnsOk_GTE.Di			:=	IN_SY.tMnsOk_GTE.Di			OR	NOT IN_SY.tMnsOk_GTE.GoodQual;
	IN_SY.tMnsOk_TGS.Di			:=	IN_SY.tMnsOk_TGS.Di			OR	NOT IN_SY.tMnsOk_TGS.GoodQual;
	IN_SY.tMnsOk_C13100.Di		:=	IN_SY.tMnsOk_C13100.Di		OR	NOT IN_SY.tMnsOk_C13100.GoodQual;
	
	IN_SY.tMCB_OpF_Ext.Di		:=	IN_SY.tMCB_OpF_Ext.Di		OR	NOT IN_SY.tMCB_OpF_Ext.GoodQual;
	IN_SY.tGCB_OpF_Ext.Di		:=	IN_SY.tGCB_OpF_Ext.Di		OR	NOT IN_SY.tGCB_OpF_Ext.GoodQual;
	(*------------------------------------------------------------------------------------*)

	IN_SY.tMnsOk_ClosCond_Ok.Di	:=	IN_SY.tMnsOk_ClosCond_Ok.Di	OR	NOT IN_SY.tMnsOk_ClosCond_Ok.GoodQual;
	IN_SY.tAfMnsF_ClosCond_Ok.Di := IN_SY.tAfMnsF_ClosCond_Ok.Di OR NOT IN_SY.tAfMnsF_ClosCond_Ok.GoodQual;

	IN_SY.tMidVoltCB_Failure.Di := IN_SY.tMidVoltCB_Failure.Di	OR NOT IN_SY.tMidVoltCB_Failure.GoodQual;
	IN_SY.tGndFault_BB.Di		:= IN_SY.tGndFault_BB.Di		OR NOT IN_SY.tGndFault_BB.GoodQual;


END_PROGRAM

