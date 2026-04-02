(*******************************************************************************
AGGR: read and write IO channels	(cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2023

- read out data module with IO configuration
- call fubs to copy IO data from IN and to OUT structures

Customized modifications: -
------------------------
 
History:
-------
V4.12.0	25.01.2023	Perktold	generated new, out of parts of IOchannel

Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC
	
	IF (callHALioSignal AND IN_HA.tPB2MM.bSys_Run) THEN
		pHALioSignal ACCESS ADR(xHALioSignals[TaskClass, 0]);
		evalHALioSignal(ParOK, HwOK, xHALioSignalsCount[TaskClass], CycleTimeMs, pHALioSignal, SignalError, SignalErrorIdx);
	END_IF;
	
END_PROGRAM

