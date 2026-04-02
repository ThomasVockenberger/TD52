(********************************************************************
This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------

History:
-------
V4.11.00	29.09.2021	Heim Markus	created Scaling Bock FUB

Instructions FOR use:
--------------------

Outstandings: - 
------------
*******************************************************************************)

FUNCTION_BLOCK ScalBlock
		
	IF 		Type = 0 THEN  		(* 0 = deactivated *)
		Y	:=	0.0;
	ELSIF	Type = 1 THEN		(* 1 = scaling with limits *)
		IF X1 = X2 THEN			(*Error Flag with X1 = X2*)
			Err :=	TRUE;
			Y   := 0.0;
		ELSE
			xLCRLimScal.x	:=	X;
			xLCRLimScal.x1	:=	X1;
			xLCRLimScal.x2	:=	X2;
			xLCRLimScal.y1	:=	Y1;
			xLCRLimScal.y2	:=	Y2;
			xLCRLimScal();
			Y	:=	xLCRLimScal.y;
		END_IF
	ELSIF	Type = 2 THEN		(* 2 = scaling without limits *)
		IF X1 = X2 THEN			(*Error Flag with X1 = X2*)
			Err :=	TRUE;
			Y   := 0.0;
		ELSE
			xLCRScal.x		:=	X;
			xLCRScal.x1		:=	X1;
			xLCRScal.x2		:=	X2;
			xLCRScal.y1		:=	Y1;
			xLCRScal.y2		:=	Y2;
			xLCRScal();
			Y	:=	xLCRScal.y;
		END_IF
	ELSIF	Type = 3 THEN		(* 3 = Y value = X value *)
		Y	:=	X;
	ELSE
		Err :=	TRUE; 			(*Error Flag with undefined stat*)
		Y   := 0.0;
	END_IF

END_FUNCTION_BLOCK