(*******************************************************************************
AGGR: intiate CAN communication for oil quality sensor (init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V4.11	05.11.2021	Schmid,		new CAN interface for oil quality sensor
							   
Instructions FOR use:
--------------------
-initiate the CAN-Bus communictation controller

Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT

	(* Don't execute task if ARsim is active *)
	IF DiagCpuIsSimulated() THEN
		RETURN;
	END_IF;

	(* initialize the CAN OQS OC communication controller *)
	xCANopen_OQS_OC.enable	 	:= TRUE;							
	xCANopen_OQS_OC.baud_rate 	:= 12;								(* set baud rate - 125kB/s *)
	xCANopen_OQS_OC.cob_anz		:= 500;								(* set maximum communication objects *)
	xCANopen_OQS_OC.error_adr 	:= ADR(iCANopen_OQS_OC_Err);		(* description of the interface define error *)
	xCANopen_OQS_OC.device	 	:= ADR(sModSlotSel[iIdxCAN_OQS]);	(* assign device at B&R PPC3100 hardware *)		
	xCANopen_OQS_OC.info		:= 0;								(* info isn´t in use *)
	xCANopen_OQS_OC();	
	
	IF xCANopen_OQS_OC.status = 0 THEN
		OUT_HA.iCAN_OQS_OC_us_ident := xCANopen_OQS_OC.us_ident;
	ELSE
		OUT_HA.iCAN_OQS_OC_us_ident := 0;
	END_IF;
		
END_PROGRAM

