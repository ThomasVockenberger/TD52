(*******************************************************************************
TransP_red	Powerreduction cause of transformer warning

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V4.03.00	24.07.2015	Plattner Johannes
V4.04.00	23.09.2016	lettenb.	OUT_AG.rP_Red_TransformerWarning_Norm: /100 removed, bugfix
			08.05.2017				Pred logic corr., bugfix

Instructions for use:
--------------------

Power reduction from Transformer Warning. 
Activates with parameter:		AuxiliariesGeneral::AsGlobalPV.bP_Red_TransformerWarning
Power setpoint with parameter:	AuxiliariesGeneral::AsGlobalPV.rP_Red_TransformerWarning_Rate

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	
	(* Transformer power reduction aktive*)
	(*----------------------------------------------------------------------------*)
	IF Para.bP_Red_TransformerWarning_Sel AND NOT IN_AG.tTransformerWarning.Di THEN
		
		OUT_AG.rP_Red_TransformerWarning_Norm	:= LIMIT(0.5, Para.rP_Red_TransformerWarning_Rate,1.0);
		OUT_AG.bP_Red_TransformerWarning_Sel	:= TRUE;
	(*----------------------------------------------------------------------------*)
		
	(* Transformer power reduction inaktive*)
	(*----------------------------------------------------------------------------*)
	ELSE
		
		OUT_AG.bP_Red_TransformerWarning_Sel	:= FALSE;
		OUT_AG.rP_Red_TransformerWarning_Norm	:= 1.0;
		
	END_IF;
	(*----------------------------------------------------------------------------*)
	
END_PROGRAM
