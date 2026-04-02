(*******************************************************************************
CUSTOMIZED: c_scal 		reserve scaling blocks (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V4.00	29.09.2021	Heim Markus	generated, new
V4.11.0	07.12.2021	Zengerer	integrate initial version 
		
Instructions FOR use:
--------------------
-
Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC

	(* customizable scaling block n
	*Input*
	IN_CU.rScalBlock_X[n]			:=	rReplaceMeWithVarname; 				* input variable TO get scaling 
	*Parameter*
	xScalBlock[n].Type				:=	Para.iCust_ScalingBlock_Typ[n];		* 0 = deactivated | 1 = scaling with limits | 2 = scaling without limits 
	xScalBlock[n].X1				:=	Para.rCust_ScalingBlock_X1[n];		* change to scaling parameter; initial default value is 0.0
	xScalBlock[n].X2				:=	Para.rCust_ScalingBlock_X2[n];		* change to scaling parameter; initial default value is 1.0
	xScalBlock[n].Y1				:=	Para.rCust_ScalingBlock_Y1[n];		* change to scaling parameter; initial default value is 0.0
	xScalBlock[n].Y2				:=	Para.rCust_ScalingBlock_Y2[n];		* change to scaling parameter; initial default value is 1.0
	*Visu*
	MM2VIS.rCustScalingBlock_X[n]	:=	xScalBlock[n].X;					* Visu
	MM2VIS.rCustScalingBlock_Y[n]	:=	xScalBlock[n].Y;					* Visu
	*Output*
	rReplaceMeWithVarname			:=	xScalBlock[n].Y;					* optional scaled output variable connector 
	bReplaceMeWithVarname			:=	xScalBlock[n].Err;					* optional error Flag connector; connect alarm messaging only if need occures 
		

	(*******************************************************************************************************************************)	
	(* customizable scaling block 1*)
	(*Input*)
	IN_CU.rScalBlock_X[1];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[1];		(* option to connect output variable here *)
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[1];	(* connect optional error Flag if needed *)

	(*******************************************************************************************************************************)
	(* customizable scaling block 2*)
	(*Input*)
	IN_CU.rScalBlock_X[2];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[2];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[2];

	(*******************************************************************************************************************************)
	(* customizable scaling block 3*)
	(*Input*)
	IN_CU.rScalBlock_X[3];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[3];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[3];

	(*******************************************************************************************************************************)
	(* customizable scaling block 4*)
	(*Input*)
	IN_CU.rScalBlock_X[4];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[4];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[4];

	(*******************************************************************************************************************************)
	(* customizable scaling block 5*)
	(*Input*)
	IN_CU.rScalBlock_X[5];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[5];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[5];

	(*******************************************************************************************************************************)
	(* customizable scaling block 6*)					
	(*Input*)
	IN_CU.rScalBlock_X[6];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[6];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[6];	

	(*******************************************************************************************************************************)
	(* customizable scaling block 7*)					
	(*Input*)
	IN_CU.rScalBlock_X[7];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[7];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[7];

	(*******************************************************************************************************************************)
	(* customizable scaling block 8*)					
	(*Input*)
	IN_CU.rScalBlock_X[8];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[8];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[8];	

	(*******************************************************************************************************************************)
	(* customizable scaling block 9*)					
	(*Input*)
	IN_CU.rScalBlock_X[9];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[9];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[9];

	(*******************************************************************************************************************************)
	(* customizable scaling block 10*)					
	(*Input*)
	IN_CU.rScalBlock_X[10];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[10];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[10];

	(*** DEFAULT CONFIG END ********************************************************************************************************)
	(*** DEFAULT CONFIG END  - ADD VIS EXTENTION PACKAGE to use more than the default number of channels ***************************)
	(*** DEFAULT CONFIG END ********************************************************************************************************)
	
	(*******************************************************************************************************************************)
	(* customizable scaling block 11*)		
	(*Input*)
	IN_CU.rScalBlock_X[11];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[11];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[11];
	
	(*******************************************************************************************************************************)
	(* customizable scaling block 12*)					
	(*Input*)
	IN_CU.rScalBlock_X[12];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[12];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[12];

	(*******************************************************************************************************************************)
	(* customizable scaling block 13*)					
	(*Input*)
	IN_CU.rScalBlock_X[13];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[13];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[13];

	(*******************************************************************************************************************************)
	(* customizable scaling block 14*)					
	(*Input*)
	IN_CU.rScalBlock_X[14];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[14];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[14];

	(*******************************************************************************************************************************)
	(* customizable scaling block 15*)					
	(*Input*)
	IN_CU.rScalBlock_X[15];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[15];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[15];

	(*******************************************************************************************************************************)
	(* customizable scaling block 16*)					
	(*Input*)
	IN_CU.rScalBlock_X[16];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[16];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[16];

	(*******************************************************************************************************************************)
	(* customizable scaling block 17*)					
	(*Input*)
	IN_CU.rScalBlock_X[17];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[17];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[17];

	(*******************************************************************************************************************************)
	(* customizable scaling block 18*)					
	(*Input*)
	IN_CU.rScalBlock_X[18];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[18];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[18];

	(*******************************************************************************************************************************)
	(* customizable scaling block 19*)					
	(*Input*)
	IN_CU.rScalBlock_X[19];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[19];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[19];

	(*******************************************************************************************************************************)
	(* customizable scaling block 20*)					
	(*Input*)
	IN_CU.rScalBlock_X[20];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[20];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[20];

	(*******************************************************************************************************************************)
	(* customizable scaling block 21*)					
	(*Input*)
	IN_CU.rScalBlock_X[21];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[21];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[21];

	(*******************************************************************************************************************************)
	(* customizable scaling block 22*)					
	(*Input*)
	IN_CU.rScalBlock_X[22];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[22];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[22];

	(*******************************************************************************************************************************)
	(* customizable scaling block 23*)					
	(*Input*)
	IN_CU.rScalBlock_X[23];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[23];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[23];

	(*******************************************************************************************************************************)
	(* customizable scaling block 24*)					
	(*Input*)
	IN_CU.rScalBlock_X[24];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[24];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[24];

	(*******************************************************************************************************************************)
	(* customizable scaling block 25*)					
	(*Input*)
	IN_CU.rScalBlock_X[25];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[25];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[25];

	(*******************************************************************************************************************************)
	(* customizable scaling block 26*)					
	(*Input*)
	IN_CU.rScalBlock_X[26];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[26];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[26];

	(*******************************************************************************************************************************)
	(* customizable scaling block 27*)					
	(*Input*)
	IN_CU.rScalBlock_X[27];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[27];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[27];

	(*******************************************************************************************************************************)
	(* customizable scaling block 28*)					
	(*Input*)
	IN_CU.rScalBlock_X[28];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[28];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[28];

	(*******************************************************************************************************************************)
	(* customizable scaling block 29*)					
	(*Input*)
	IN_CU.rScalBlock_X[29];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[29];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[29];

	(*******************************************************************************************************************************)
	(* customizable scaling block 30*)					
	(*Input*)
	IN_CU.rScalBlock_X[30];											(* connect input variable here *)
	(*Output*)
	rReplaceMeWithVarname			:=	OUT_CU.rScalBlock_Y[30];
	bReplaceMeWithVarname			:=	OUT_CU.bScalBlock_Err[30];

	
	
	(*******************************************************************************************************************************)
	(*	END OF CONFIGURATION AREA; no changes necessary below this line *)
	(******************************************************************************************************************************)
	(*parameter assignment and function call for scaling blocks*)
	FOR n := 1 TO 30 BY 1 DO
		(*Parameter*)
		xScalBlock[n].Type			:=	Para.iCust_ScalingBlock_Typ[n];		(* 0 = deactivated | 1 = scaling with limits | 2 = scaling without limits *)
		xScalBlock[n].X				:=	IN_CU.rScalBlock_X[n];				(* input variable connector *)
		xScalBlock[n].X1			:=	Para.rCust_ScalingBlock_X1[n];
		xScalBlock[n].X2			:=	Para.rCust_ScalingBlock_X2[n];
		xScalBlock[n].Y1			:=	Para.rCust_ScalingBlock_Y1[n];
		xScalBlock[n].Y2			:=	Para.rCust_ScalingBlock_Y2[n];
		xScalBlock[n]();	(*function call*)
		(*Output*)
		OUT_CU.rScalBlock_Y[n]		:=	xScalBlock[n].Y;					(* output variable connector *)
		OUT_CU.bScalBlock_Err[n]	:=	xScalBlock[n].Err;					(* optional error Flag connector, if needed *)
		(*Visu*)
		MM2VIS.rCustScalingBlock_X[n]	:=	xScalBlock[n].X;
		MM2VIS.rCustScalingBlock_Y[n]	:=	xScalBlock[n].Y;
	END_FOR
	

END_PROGRAM
