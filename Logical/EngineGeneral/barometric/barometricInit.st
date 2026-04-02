(*******************************************************************************
barometric		barometric pressure  					(INIT)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V04.02.00.00	  28.01.2015  Tinello	NEW specification

Instructions FOR use:
--------------------
*******************************************************************************)
PROGRAM _INIT

	(* ramp settings *)
	xRAMPE_R_Pr_Baro.enable		:= TRUE;
	xRAMPE_R_Pr_Baro.Rise		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_Pr_Baro.Sink		:= 0.010;		(* 10 mbar/s *)
	xRAMPE_R_Pr_Baro.TC_Time	:= TASK_TIME_100MS;

END_PROGRAM