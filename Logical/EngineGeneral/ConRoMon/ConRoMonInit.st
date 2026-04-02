(*******************************************************************************
ConRoMon: Conrod bearing temperature CANopen Sensor (init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.1	27-05-2009	Kröll,Waldhart,Weigl generated
V0.11	22-03-2010	Waldhart,  enhanced FOR 24 cylinder 
V0.13	27.03.2013	Tinello, restructured FOR modular SW
V0.14	14.01.2015	Tinello	 restructured FOR XT4

Instructions FOR use:
--------------------

Outstandings:
------------
*******************************************************************************)
PROGRAM _INIT

	(* send parameters to kongsberg system *)
	iCnt_Para				:= 0;
	iSt_Para				:= 0;
	iCntCB_Para				:= 1;
		
END_PROGRAM

