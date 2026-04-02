(*******************************************************************************
DefaultEM		value set

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V4.05.0	05.04.2017	Tinello		new
V4.07.0	23.01.2019	Tinello		add Customer DI's
																																		
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* SCR *)
	IN_EM.tFS_SCR_EMLine1_Lo.Di				:= IN_EM.tFS_SCR_EMLine1_Lo.Di				OR NOT IN_EM.tFS_SCR_EMLine1_Lo.GoodQual;
	IN_EM.tFS_SCR_EMLine2_Lo.Di				:= IN_EM.tFS_SCR_EMLine2_Lo.Di				OR NOT IN_EM.tFS_SCR_EMLine2_Lo.GoodQual;
	IN_EM.tLev_SCR_UreaDosingCabinet_Hi.Di	:= IN_EM.tLev_SCR_UreaDosingCabinet_Hi.Di	OR NOT IN_EM.tLev_SCR_UreaDosingCabinet_Hi.GoodQual;
	IN_EM.tLev_SCR_UreaTank_Lo.Di			:= IN_EM.tLev_SCR_UreaTank_Lo.Di			OR NOT IN_EM.tLev_SCR_UreaTank_Lo.GoodQual;
	IN_EM.tSCR_AirCompressor_Rdy.Di			:= IN_EM.tSCR_AirCompressor_Rdy.Di			OR NOT IN_EM.tSCR_AirCompressor_Rdy.GoodQual;	
	IN_EM.tSCR_ComprAirValve_Rdy.Di			:= IN_EM.tSCR_ComprAirValve_Rdy.Di			OR NOT IN_EM.tSCR_ComprAirValve_Rdy.GoodQual;	
	IN_EM.tSCR_EMCooler_Rdy.Di				:= IN_EM.tSCR_EMCooler_Rdy.Di				OR NOT IN_EM.tSCR_EMCooler_Rdy.GoodQual;
	IN_EM.tSCR_EMPump1_Rdy.Di				:= IN_EM.tSCR_EMPump1_Rdy.Di				OR NOT IN_EM.tSCR_EMPump1_Rdy.GoodQual;
	IN_EM.tSCR_EMPump2_Rdy.Di				:= IN_EM.tSCR_EMPump2_Rdy.Di				OR NOT IN_EM.tSCR_EMPump2_Rdy.GoodQual;
	IN_EM.tSCR_UreaDosingPump_Rdy.Di		:= IN_EM.tSCR_UreaDosingPump_Rdy.Di			OR NOT IN_EM.tSCR_UreaDosingPump_Rdy.GoodQual;
	IN_EM.tSCR_UreaDosingPump2_Rdy.Di		:= IN_EM.tSCR_UreaDosingPump2_Rdy.Di		OR NOT IN_EM.tSCR_UreaDosingPump2_Rdy.GoodQual;
	IN_EM.tSCR_UreaSupplyPump_Op.Di			:= IN_EM.tSCR_UreaSupplyPump_Op.Di			OR NOT IN_EM.tSCR_UreaSupplyPump_Op.GoodQual;
	IN_EM.tSCR_ValvePowerSupply_Ok.Di		:= IN_EM.tSCR_ValvePowerSupply_Ok.Di		OR NOT IN_EM.tSCR_ValvePowerSupply_Ok.GoodQual;	
	IN_EM.tSCR_InjectValve_Opened.Di		:= IN_EM.tSCR_InjectValve_Opened.Di			OR NOT IN_EM.tSCR_InjectValve_Opened.GoodQual;
	IN_EM.tSCR_Catalyst_Rdy.Di				:= IN_EM.tSCR_Catalyst_Rdy.Di				OR NOT IN_EM.tSCR_Catalyst_Rdy.GoodQual;
	IN_EM.tT_SCR_Cat_HiHi.Di				:= IN_EM.tT_SCR_Cat_HiHi.Di					OR NOT IN_EM.tT_SCR_Cat_HiHi.GoodQual;
END_PROGRAM
