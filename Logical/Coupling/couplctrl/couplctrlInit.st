(*******************************************************************************
Coupling:    computer link control

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0		17.07.2012	froehlichw	new
V04.03.00	09.12.2015	Denk		ucTeiler changed to 7, before 10
V04.05.00	04.12.2017	Denk		ucTeiler changed to 0, task coupling moved to Cyclic#5

Instructions for use:
--------------------
make settings according interface

Outstandings:
------------

(*******************************************************************************)

PROGRAM _INIT

	(*--------------------------------------------------------------------*)

	(* link 1: type *)
	Para.iIdx_Comm1_type;
	                    (* comNO_LINK        = no link
	                       comMODBUS_RTU     = modbus RTU
	                       comMODBUS_TCP     = modbus TCP
	                       comPROFIBUS_DP    = profibus DP
	                       comPROFIBUS_DPold = profibus DP old style ( > set size send/receive data arrays)
	                       comPROFINET       = profinet *)
	(* link 1: interface hardware *)
	Para.iIdx_Comm1_Interface;
	                          (*1* = X20CS1030 RS422
	                            2* = X20CS1030 RS422
	                            3* = reserve
	                            4* = reserve
	                            5* = reserve
	                             * ..insert IF-hardware into physical view!*)
	(*--------------------------------------------------------------------*)

	(* link 2: typ *)
	Para.iIdx_Comm2_type;
	                    (* comNO_LINK        = no link
	                       comMODBUS_RTU     = modbus RTU
	                       comMODBUS_TCP     = modbus TCP
	                       comPROFIBUS_DP    = profibus DP
	                       comPROFIBUS_DPold = profibus DP old style ( > set size send/receive data arrays)
	                       comPROFINET       = profinet *)
	(* link 2: interface hardware *)
	Para.iIdx_Comm2_Interface;
	                          (*1* = X20CS1030 RS422
	                            2* = X20CS1030 RS422
	                            3* = reserve
	                            4* = reserve
	                            5* = reserve
	                             * ..insert IF-hardware into physical view!*)
	(*--------------------------------------------------------------------*)

	(* modbus RTU - link 1: baud rate *)
	Para.iComm1_Baud;
	                (* 9600 (standard)
	                   19200 *)
	(* modbus RTU - link 1: parity *)
	Para.iComm1_Parity;
	                  (* 0 = even
	                     1 = odd
	                     2 = no parity (standard)*)
	(* modbus RTU - link 1: stop bits *)
	Para.iComm1_Stopbit;
	                   (* 1 = 1 stop bit (standard)
	                      2 = 2 stop bits *)
	(* modbus RTU - link 1: slave-ID *)	
	Para.iComm1_SlaveID; (* parameter *)
	(*------------------------------------------------------------------*)

	(* modbus RTU - link 2: baud rate *)
	Para.iComm2_Baud;
	                (* 9600 (standard)
	                   19200 *)
	(* modbus RTU - link 2: parity *)
	Para.iComm2_Parity;
	                  (* 0 = even
	                     1 = odd
	                     2 = no parity (standard)*)
	(* modbus RTU - link 2: stop bits *)
	Para.iComm2_Stopbit;
	                   (* 1 = 1 stop bit (standard)
	                      2 = 2 stop bits *)
	(* modbus RTU - link 2: slave-ID *)	
	Para.iComm2_SlaveID; (* parameter *)
	(*--------------------------------------------------------------------*)

	(* modbus TCP - link: TCP port number *)
	Para.iComm_PortID_TCP;
	                (* 502 (standard) *)
	(* modbus TCP - link: slave-ID *)
	Para.iComm_SlaveID_TCP; (* parameter *)
	(*------------------------------------------------------------------*)

END_PROGRAM
