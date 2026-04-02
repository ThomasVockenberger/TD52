(*******************************************************************************
vis			visualization

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.99.0	24.04.2012	lettenb.	new
V4.00.0	02.06.2014				MM2VIS.bRel_ER_Fan: OUT_VE.tRel_ER_Fan.Do -> OUT_VE.tRel_ER_FC.Do, bugfix
V4.03.0 19.11.2015  Stary       added MM2VIS.rPrDiff_ER :=  IN_VE.tPrDiff_ER.Ai;
V4.04.0 21.10.2016  Stary       added MM2VIS.bCtrER_YFix :=  bCtrER_YFix; for visualization of BOP on HMI
V4.04.0 22.10.2016  Stary       added status-messages of fire-protection flaps
		07.11.2016	lettenb.	MM2VIS.rP_Red_T_InAirER_Norm removed(see:OpState)
V4.04.0 09.01.2017  Stary       correction of line 43 (was written on status of fire prot flap outlet air 1 too)
V4.05.1 01.03.2018	lettenb.	Pos_InlLou1_OK, Pos_InlLou2_OK, Pos_OutlLou1_OK added(kluckner), bugfix

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	MM2VIS.rT_AirER							:=	rT_AirER;
	MM2VIS.rPrDiff_ER           			:=  IN_VE.tPrDiff_ER.Ai;

	MM2VIS.bInAirER_Lou1Opened				:=	IN_VE.tInAirER_Lou1Opened.Di OR Pos_InlLou1_OK;
	MM2VIS.bInAirER_Lou2Opened				:=	IN_VE.tInAirER_Lou2Opened.Di OR Pos_InlLou2_OK;
	MM2VIS.bOutAirER_LouOpened				:=	IN_VE.tOutAirER_LouOpened.Di OR Pos_OutlLou1_OK OR Pos_OutlLou2_OK;
	MM2VIS.bInAirER_Fan1DemOn				:=	OUT_VE.tInAirER_Fan1DemOn.Do;
	MM2VIS.bInAirER_Fan2DemOn				:=	OUT_VE.tInAirER_Fan2DemOn.Do;
	MM2VIS.bInAirER_FanSet100				:=	IN_VE.bInAirER_FanSet100;
	MM2VIS.bRel_ER_Fan						:=	OUT_VE.tRel_ER_FC.Do;
	MM2VIS.bCtrER_YFix						:=  bCtrER_YFix;
	MM2VIS.bFireProtFlap1_InlAir_Opened 	:=  IN_VE.tFireProtFlap1_InlAir_Opened.Di AND NOT IN_VE.tFireProtFlap1_InlAir_Closed.Di;
	MM2VIS.bFireProtFlap2_InlAir_Opened 	:=  IN_VE.tFireProtFlap2_InlAir_Opened.Di AND NOT IN_VE.tFireProtFlap2_InlAir_Closed.Di;
	MM2VIS.bFireProtFlap1_OutlAir_Opened 	:=  IN_VE.tFireProtFlap1_OutlAir_Opened.Di AND NOT IN_VE.tFireProtFlap1_OutlAir_Closed.Di;
	MM2VIS.bFireProtFlap2_OutlAir_Opened 	:=  IN_VE.tFireProtFlap2_OutlAir_Opened.Di AND NOT IN_VE.tFireProtFlap2_OutlAir_Closed.Di;

END_PROGRAM
