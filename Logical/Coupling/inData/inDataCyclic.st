(*******************************************************************************
inData        copy data from InData

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2020

Customized modifications: -
------------------------
 
History:
-------
V3.90.0			17.07.2012	Denk	new
V3.90.1 		21.11.2013	Denk	InData1 modifications
V04.03.00.00	04.05.2015	Denk	Para.bOPC_Rcv_Ena, VIS2MM for OPC added
V04.06.00.00	05.07.2018	Perktold,InData2.Bit14 AND 15 used FOR (very) fast start preparation
V04.10.00.00	14.10.2020	Weitezr, add bBusPulse to OUT_CP structure for AB
V04.13.00.00	08.12.2023	Denk	 Customer bus coupling with OPC UA, new interface OUT_CP.bBus_failure

Instructions FOR use:
--------------------

Outstandings:
------------


(*******************************************************************************)

PROGRAM _CYCLIC

	(*----------------------------------------------------------------------------------------*)	
	(* InData[0] *)
	xWDtoBIT_InData1.Word := INT_TO_UINT(OUT_CP.InData1[0]);
	xWDtoBIT_InData1;

	bBus_Dem 				:= xWDtoBIT_InData1.Bit00;			(* Demand module from bus system *)
	bBusPulse				:= xWDtoBIT_InData1.Bit07;			(* Bus pulse signal from customer *)

	(* NOTE: xWDtoBIT_InData1.Bit03 until xWDtoBIT_InData1.Bit06 to use in Customized module task c_coupl *)
	
	IF Para.bOPC_Rcv_Ena THEN
		bBus_Dem := VIS2MM.bOPC_Dem;			(* Demand module from OPC *)
		bBusPulse:=	VIS2MM.bOPC_SetClock;		(* Bus pulse signal from customer OPC *)
		(* NOTE: Other VIS2MM OPC variables to use in Customized module task c_coupl *)			 
	END_IF;	

	IF Para.bComm_OpcUa_Active THEN
		bBus_Dem := IN_CP.bBus_Dem_OpcUa;		(* Demand module from OPC UA *)
		bBusPulse:=	IN_CP.bBusPulse_OpcUa;		(* Bus pulse signal from customer OPC UA *)
		(* NOTE: Other OPC variables to use in Customized module task c_coupl *)			 
	END_IF;	
	
	(*----------------------------------------------------------------------------------------*)	
	(* InData[1] *)
	xWDtoBIT_InData2.Word		:= INT_TO_UINT(OUT_CP.InData1[1]);
	xWDtoBIT_InData2;
	(* NOTE: xWDtoBIT_InData2.Bit00 until xWDtoBIT_InData2.Bit13 to use in Customized module task c_coupl *)

	bFastStartReq_Bus 		:= xWDtoBIT_InData2.Bit14;			(* IF731 Demand preparation for fast start *)
	bVeryFastStartReq_Bus	:= xWDtoBIT_InData2.Bit15;			(* IF732 Demand preparation for very fast start *)


	(*----------------------------------------------------------------------------------------*)	
	(* InData[2] *)
	iP_Set_Bus:= OUT_CP.InData1[2];				(* Power setpoint from bus system *)

	IF Para.bOPC_Rcv_Ena THEN
		rP_Set_OPC := VIS2MM.rP_OPC_Set;		(* Power setpoint from OPC *)			 
	END_IF;
	
	IF Para.bComm_OpcUa_Active THEN
		rP_Set_OPC := IN_CP.rP_Set_OpcUa;		(* Power setpoint from OPC UA *)
		(* NOTE: Other OPC variables to use in Customized module task c_coupl *)			 
	END_IF;	

	(*----------------------------------------------------------------------------------------*)	
	(* InData[3] - InData[15]*)
	(* NOTE: InData[3] until InData[15] to use in Customized module task c_coupl *)


	(*----------------------------------------------------------------------------------------*)
	(* Demand from bus system *)											
	OUT_CP.bBus_Dem					:= bBus_Dem AND NOT bBus_failure;
	OUT_CP.bFastStartReq_Bus		:= bFastStartReq_Bus AND NOT bBus_failure;
	OUT_CP.bVeryFastStartReq_Bus	:= bVeryFastStartReq_Bus AND NOT bBus_failure;
	OUT_CP.bBusPulse				:= bBusPulse AND NOT bBus_failure;
	OUT_CP.bBus_failure				:= bBus_failure;

	(* Interface IF708: Bus observation *)									
	EMPF1:= bKopl1EmpfFrg AND (Para.iIdx_Comm1_type <> 0); 
	EMPF2:= bKopl2EmpfFrg AND (Para.iIdx_Comm2_type <> 0); 

	(* Interface IF708: Bus failure *)										
	xTONBusFail_0(IN:= NOT bBusPulse, PT:= T#65s);
	xTONBusFail_1(IN:= bBusPulse, PT:= T#65s);
	bBus_failure := (xTONBusFail_0.Q OR xTONBusFail_1.Q) AND (EMPF1 OR EMPF2 OR Para.bOPC_Rcv_Ena OR Para.bComm_OpcUa_Active); 

	(*----------------------------------------------------------------------------------------*)
	(* OutData communication, Coupling --> Customized *)
	OUT_CP.InData1;
	OUT_CP.InData2;

END_PROGRAM
