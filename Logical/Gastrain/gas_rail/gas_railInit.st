(*******************************************************************************
gas_rail		gas rail  					(INIT)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V04.03.00.00  20.01.2015  Denk 		Porting J920 FOR XT4 
V04.12.00.00  23.08.2022  Zuschnig	Initialize standard value for power redcution gas rail pressure		

Instructions FOR use:
--------------------
*******************************************************************************)
PROGRAM _INIT

	(* check gas pressure sensor deviation *)
	LCRMAF_PGR_Deviation.enable	:= TRUE;	(* *)
	LCRMAF_PGR_Deviation.base	:= 5;		(* *)
	
	(* Initialize standard value fr power redcution gas rail pressure *)
	IF Perm2.rDPr_limit_pgr_Pred = 0 THEN	Perm2.rDPr_limit_pgr_Pred := 0.7;	END_IF; 
	
END_PROGRAM
