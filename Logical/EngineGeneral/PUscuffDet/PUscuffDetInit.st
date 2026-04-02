(********************************************************************************************************
PUscuffDet: 	crankcase pressure and knock noise signal based power-unit scuffing detection (init)	

This code is confidential AND proprietary TO the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission OF the INNIO Company.
Copyright, INNIO Company, 2022


Customized modifications: 
------------------------
 
History:
-------
V4.11.00	14.01.2022	Schmidt		created

Outstandings:
------------
-
********************************************************************************************************)

PROGRAM _INIT

	xPUscuff(ssMethodType := 2);
	xPUscuff.ssMethodType := 3;
	 
END_PROGRAM