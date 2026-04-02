(*******************************************************************************
Coupling:    coupling task for communication to external PLS

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0		17.07.2012	froehlichw	new
V4.03.0 	04.08.2014	Zengerer	USE SLOT INTERFACE SL1.IF1, if available on B&R Hardware (replacing IF4.) 
V4.07.00 	22.01.2019	Denk		Bus diagnosis and test on HMI
V4.13.00 	05.03.2024	Astner		Added second customer bus coupling with Modbus TCP
Instructions for use:
--------------------

Outstandings:
------------

(*******************************************************************************)

PROGRAM _INIT

//	B&R hardware

	(* define and copy strings for routing to different interfaces for Modbus RTU *)
	szInterface01:= '';
	szInterface02:= '';

	(* set init values *)
	ucINIT[0]:= 1;
	ucINIT[1]:= 1;

	(* define and copy interfaces for Profibus DP*)
	szInterface01_Comm1:= '';
	szInterface02_Comm1:= '';
	iInterface01_Comm1:= ADR(szInterface01_Comm1);
	iInterface02_Comm1:= ADR(szInterface02_Comm1);
	szInterface01_Comm2;
	szInterface02_Comm2;
	
	(* Logger info creation *)
	AsArLogGetInfo_PB_01(enable:= TRUE, pName:= arlogBASE_USER_LOG_IDENT);
	AsArLogGetInfo_PB_02(enable:= TRUE, pName:= arlogBASE_USER_LOG_IDENT);
	AsArLogGetInfo_PN_01(enable:= TRUE, pName:= arlogBASE_USER_LOG_IDENT);
	AsArLogGetInfo_TCP(enable:= TRUE, pName:= arlogBASE_USER_LOG_IDENT);
	
	(* define and copy interfaces for Profinet*)
	szInterface01_Comm1_PN:= '';
	iInterface01_Comm1_PN:= ADR(szInterface01_Comm1_PN);
	szInterface01_Comm2_PN;

	(* define and copy interfaces for MODBUS TCP *)
	ucINIT_IP_addr_TCP:= 1;
	szComm_Device_TCP := '';
	szComm_IPaddr_TCP := '';
	szComm_SubMask_TCP := '';
	iComm_Device_TCP  := ADR(szComm_Device_TCP);
	iComm_IPaddr_TCP  := ADR(szComm_IPaddr_TCP);
	iComm_SubMask_TCP := ADR(szComm_SubMask_TCP);
	ucINIT_IP_addr_TCP2 := 1;
	szComm_Device2_TCP := '';
	szComm2_IPaddr_TCP := '';
	szComm2_SubMask_TCP := '';
	iComm2_Device_TCP  := ADR(szComm_Device2_TCP);
	iComm2_IPaddr_TCP  := ADR(szComm2_IPaddr_TCP);
	iComm2_SubMask_TCP := ADR(szComm2_SubMask_TCP);
	
	(* Bus test on HMI *)
	VIS2MM.bBC1_Test_Active := TRUE;
	VIS2MM.iBC_Test_Recv_Cust1_Toggle_Reg := 10;
	VIS2MM.tiBC_Test_Recv_Cust1_Toggle := T#5s;
	VIS2MM.iBC_Test_Recv_Cust1_Toggle_Val1 := 0;
	VIS2MM.iBC_Test_Recv_Cust1_Toggle_Val1 := 1;
	
	(* Define InData2PN *)
	InData2PN;
	
END_PROGRAM
