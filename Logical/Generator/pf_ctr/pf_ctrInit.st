(*******************************************************************************
pf_ctr  Initialization

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------


********************************************************************)
PROGRAM _INIT

	ssPowRedFrqMin := 1.000;
	
	(* PVs not yet used *)
	PF_Out1;
	ssP_mains_scale1;
	PF_Out2;
	ssQ_mains_scale1;
	ssP_mains_scale2;
	bMI_MMU;
	ssQ_mains_scale2;
	bMIPCont_SPext;
	bPF_LIM_Temp;
	ssQ_mainsOffset;
	bMIPCont;
	ssMIRPCont_SP;
	ssMIPCont_SP;
	bMIRPCont_SPext;

END_PROGRAM

