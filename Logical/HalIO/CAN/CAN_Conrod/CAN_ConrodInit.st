(*******************************************************************************
AGGR: intiate CAN communication for conrod bearing system (init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V4.03	23-02-2015	Tinello,	new
		22-10-2015	Weitzer,	add interface for B&R IPC hardware
V4.06	18.09.2018	Denk,		don't execute task if ARsim is active
V4.08	07.02.2019	Schmid,		B&R IPC PPC3100 adaptations (PLC address for CAN device changed)
V4.11	07.12.2021	Schmid,		flexible CAN interface detection
							   
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

	(* initialize the CAN communication controller *)
	xCANopen_CB.enable	 	:= TRUE;							
	xCANopen_CB.baud_rate 	:= 25;								(* set baud rate - 250kB/s *)
	xCANopen_CB.cob_anz		:= 500;								(* set maximum communication objects *)
	xCANopen_CB.error_adr 	:= ADR(iCANopen_CB_Err);			(* description of the interface define error *)
	xCANopen_CB.device	 	:= ADR(sModSlotSel[iIdxCAN_CB]);	(* assign device at B&R PPC3100 hardware *)		
	xCANopen_CB.info		:= 0;								(* info isn´t in use *)
	xCANopen_CB();	
	
	IF xCANopen_CB.status = 0 THEN
		OUT_HA.iCAN_CB_us_ident := xCANopen_CB.us_ident;
	ELSE
		OUT_HA.iCAN_CB_us_ident := 0;
	END_IF;
	
END_PROGRAM

