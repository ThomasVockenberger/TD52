(*******************************************************************************
AGGR: intiate CAN communication for NOx sensor and WG actuators (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V3.99.0	07-05-2012	Weitzer,	generated FOR modular software																   							   
V4.00	14-02-2014	Weitzer,	change version number
V4.03	22-10-2015	Weitzer,	add interface for B&R IPC hardware
V4.05	02-08-2017	Tinello,	add interface for two sensors
V4.06	18.09.2018	Denk,		don't execute task if ARsim is active
V4.07	04.04.2019	Tinello,	two fixed CAN adresses for NOx
V4.08	07.02.2019	Schmid,		B&R IPC PPC3100 adaptations (PLC address for CAN device changed)
V4.09	01.12.2019	Tinello,	added variables for CANopen HMI overview
V4.10	03.11.2020	Schmid,		engine NOx CAN node position on node P21 as option
V4.11	07.12.2021	Schmid,		flexible CAN interface detection
V4.14	28.03.2024	Soto/Farre,	change task name, CAN NOx IF1 shared with Wastegate, interfaces duplicated (2023-174)
		18.06.2024	Soto,		added CAN interface for Low NOx sensor IF3 (2023-183)
							   
*******************************************************************************)

PROGRAM _INIT

	(* Do not execute task if ARsim is active *)
	IF DiagCpuIsSimulated() THEN
		RETURN;
	END_IF;

	(* initialize the CAN communication for NOx-sensors *)
	MM2VIS.sCAN_HW_NOxS_IF1 := CONCAT(sModSlotSel[iIdxCAN_NOxS_IF1],' /EX=1');	(* Address of CAN interface 1 *)

	xCANopen_NOxS_IF1.enable	:= 1;										(* enable the functionblock CANopen *)
	xCANopen_NOxS_IF1.baud_rate := 25;										(* set baut rate - 250kB/s *)
	xCANopen_NOxS_IF1.cob_anz	:= 50;										(* set maximum communication objects *)
	xCANopen_NOxS_IF1.error_adr	:= ADR(iCANopen_NOxS_Err_IF1);				(* description of the error *)
	xCANopen_NOxS_IF1.device	:= ADR(MM2VIS.sCAN_HW_NOxS_IF1);			(* assign device at BR hardware *)
	xCANopen_NOxS_IF1.info	  	:= 0;							  	  		(* info is not in use *)
	xCANopen_NOxS_IF1;														(* execute of the CANopen *)

	IF xCANopen_NOxS_IF1.status <> 0 THEN
		strcpy(ADR(MM2VIS.sCAN_HW_NOxS_IF1), ADR('INTERFACE NOT FOUND'));	(* node not configured or no identifier label *)
	ELSE
		OUT_HA.iCAN_NOxS_IF1_us_ident	:= xCANopen_NOxS_IF1.us_ident;
	END_IF;


	(* initialize the CAN communication for NOx-sensors with different CAN devices *)
	MM2VIS.sCAN_HW_NOxS_IF2 := CONCAT(sModSlotSel[iIdxCAN_NOxS_IF2],' /EX=1');	(* Address of CAN interface 2 *)

	xCANopen_NOxS_IF2.enable	:= 1;										(* enable the functionblock CANopen *)
	xCANopen_NOxS_IF2.baud_rate := 25;										(* set baut rate - 250kB/s *)
	xCANopen_NOxS_IF2.cob_anz  	:= 50;										(* set maximum communication objects *)
	xCANopen_NOxS_IF2.error_adr := ADR(iCANopen_NOxS_Err_IF2);				(* description of the error *)
	xCANopen_NOxS_IF2.device    := ADR(MM2VIS.sCAN_HW_NOxS_IF2);			(* assign device at BR hardware *)
	xCANopen_NOxS_IF2.info	  	:= 0;							  	  		(* info is not in use *)
	xCANopen_NOxS_IF2;														(* execute of the CANopen *)

	IF xCANopen_NOxS_IF2.status <> 0 THEN
		strcpy(ADR(MM2VIS.sCAN_HW_NOxS_IF2), ADR('INTERFACE NOT FOUND'));	(* node not configured or no identifier label *)
	ELSE
		OUT_HA.iCAN_NOxS_IF2_us_ident	:= xCANopen_NOxS_IF2.us_ident;
	END_IF;

	(* initialize the CAN communication for NOx-sensors with different CAN devices *)
	MM2VIS.sCAN_HW_NOxS_IF3 := CONCAT(sModSlotSel[iIdxCAN_NOxS_IF3],' /EX=0');		(* Address of CAN interface 3 *)

	xCANopen_NOxS_IF3.enable	:= 1;										(* enable the functionblock CANopen *)
	xCANopen_NOxS_IF3.baud_rate := 50;										(* set baut rate - 500kB/s *)
	xCANopen_NOxS_IF3.cob_anz  	:= 50;										(* set maximum communication objects *)
	xCANopen_NOxS_IF3.error_adr := ADR(iCANopen_NOxS_Err_IF3);				(* description of the error *)
	xCANopen_NOxS_IF3.device    := ADR(MM2VIS.sCAN_HW_NOxS_IF3);			(* assign device at BR hardware *)
	xCANopen_NOxS_IF3.info	  	:= 0;							  	  		(* info is not in use *)
	xCANopen_NOxS_IF3;														(* execute of the CANopen *)

	IF xCANopen_NOxS_IF3.status <> 0 THEN
		strcpy(ADR(MM2VIS.sCAN_HW_NOxS_IF3), ADR('INTERFACE NOT FOUND'));	(* node not configured or no identifier label *)
	ELSE
		OUT_HA.iCAN_NOxS_IF3_us_ident	:= xCANopen_NOxS_IF3.us_ident;
	END_IF;

	MM2VIS.iCANopen_NOxS_IF1_status		:= xCANopen_NOxS_IF1.status;
	MM2VIS.iCANopen_NOxS_IF2_status		:= xCANopen_NOxS_IF2.status;
	MM2VIS.iCANopen_NOxS_IF3_status		:= xCANopen_NOxS_IF3.status;	

	(* CAN Wastegate - duplicate interface from NOx shared interface IF1 *)
	OUT_HA.iCAN_WG_us_ident 	:= OUT_HA.iCAN_NOxS_IF1_us_ident; 			(* CAN WG identifier *)
	MM2VIS.sCAN_HW_WG			:= MM2VIS.sCAN_HW_NOxS_IF1;					(* BR Adress of CAN interface 1 *)
	MM2VIS.iCANopen_WG_status	:= MM2VIS.iCANopen_NOxS_IF1_status;			(* CAN WG status *)
	
END_PROGRAM