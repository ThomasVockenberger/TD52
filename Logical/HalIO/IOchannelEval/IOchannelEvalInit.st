(*******************************************************************************
AGGR: read AND write IO channels	(init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2023

- read out data module with IO configuration
- call fubs TO copy IO data from IN AND TO OUT structures

Customized modifications: -
------------------------
 
History:
-------
V4.12.0	25.01.2023	Perktold	generated new, out of parts of IOchannel

Instructions FOR use:
--------------------
- 

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT
	
	rtInfo.enable := TRUE;
	REPEAT
		rtInfo();
		UNTIL rtInfo.status <> ERR_FUB_BUSY
	END_REPEAT
	
	TaskClass := rtInfo.task_class;
	CycleTimeMs := UDINT_TO_REAL(rtInfo.cycle_time) / 1000;
	
END_PROGRAM
