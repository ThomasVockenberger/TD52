(********************************************************************

This code is confidential and proprietary to the INNIO Jenbacher Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Jenbacher Company.
Copyright, INNIO Jenbacher, 2019

Customized modifications: -
------------------------

History:
-------
V4.07.0	29-01-2019	502423184,  new
		19-02-2019	Perktold,	changed Function name acc. to coding guideline
V4.09.0	03-02-2020	Zuschnig,	TOF always active
		12-02-2020	Zuschnig,	included ParaSetupOk plus 2 sec to enable power reductions				

Instructions for use:
--------------------
  
Outstandings: - 
------------

*******************************************************************************)

FUNCTION_BLOCK PRed

	IF bEna AND bParaSetupOk_2s THEN
		memcpy(ADR(rP_Set_Max),iAdr_P_Set_Max,4);
		memcpy(ADR(rP_Set_Act),iAdr_P_Set,4);
		memcpy(ADR(iType_Act),iAdr_P_Type,2);
	
		IF rP_Set_Act > rP_Red	THEN
			rP_Set_Act	:= rP_Red;
			iType_Act	:= iType;
			xTOF.IN		:=	TRUE;
		ELSE
			xTOF.IN		:=	FALSE;
		END_IF

		rP_Set_Max	:=	MIN(rP_Set_Max, rP_Red);

		memcpy(iAdr_P_Set_Max,ADR(rP_Set_Max),4);	
		memcpy(iAdr_P_Set,ADR(rP_Set_Act),4);
		memcpy(iAdr_P_Type,ADR(iType_Act),2);
	ELSE
		xTOF.IN	:=	FALSE;
	END_IF

	xTOF.PT	:=	PT;
	xTOF();
	Q	:=	xTOF.Q;

END_FUNCTION_BLOCK
