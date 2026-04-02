(********************************************************************
This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------

History:
-------
V4.03.00	21.07.2015	Denk	new

Instructions FOR use:
--------------------

Outstandings: - 
------------
*******************************************************************************)

FUNCTION_BLOCK ManAuxCtr
		
	xR_TRIG(CLK := VisuCmdButton OR (VisuCmdSetpoint > 0.0001));
	xF_TRIG(CLK := VisuCmdButton OR (VisuCmdSetpoint > 0.0001));
 	xTOF(IN := xR_TRIG.Q, PT := MaxCmdTime);
	xRS.SET1 := GnlRel AND xR_TRIG.Q;
 	xRS.RESET := NOT GnlRel OR NOT xTOF.Q OR (xF_TRIG.Q AND xRS.Q1);
	xRS();
	COn := xRS.Q1;
	COf := xRS.Q1;
	xLCRPT1(enable := TRUE, x := VisuCmdSetpoint, t := 0.8); 
	SetVal := MUX(BOOL_TO_INT(xRS.Q1), 0.0, xLCRPT1.y);


END_FUNCTION_BLOCK