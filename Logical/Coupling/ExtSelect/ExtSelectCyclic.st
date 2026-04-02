(*******************************************************************************
External		External setpoints

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.90.0			17.09.2012 Denk		Created
V04.03.00.00	04.05.2015 Denk		Para.bOPC_Rcv_Ena for OPC added
V04.13.00.00	08.12.2023 Denk		Customer bus coupling with OPC UA
		
														
Instructions for use:
--------------------
			
Outstandings:
------------


(*******************************************************************************)

PROGRAM _CYCLIC

	(* selection external power setpoint from bus system *)			
	IF (IN_CP.iIdx_OMSS = 2) AND (IN_CP.iIdx_RSS = 2) THEN
		IF EMPF1 OR EMPF2 THEN  					
			OUT_CP.bP_Set_ExtBus_Enable:= TRUE;
			OUT_CP.rP_Set_ExtBus_Norm:= INT_TO_REAL(iP_Set_Bus)/1000; 
		END_IF;
		IF Para.bOPC_Rcv_Ena OR Para.bComm_OpcUa_Active THEN
  			OUT_CP.bP_Set_ExtBus_Enable:= TRUE;
			OUT_CP.rP_Set_ExtBus_Norm:= rP_Set_OPC; 
		END_IF;
	ELSE
		OUT_CP.bP_Set_ExtBus_Enable := FALSE;
	END_IF;
 
	(* selection external speed setpoint from bus system  *)			
	OUT_CP.rN_Set_ExtBus_Norm:= 1.0;				(* ACHTUNG : Customized connection in 0 - 1% of Nnom *)
	OUT_CP.bN_Set_ExtBus_Enable:= (IN_CP.iIdx_OMSS = 2) AND (IN_CP.iIdx_RSS = 2) AND FALSE;

	(* selection external power reduction from bus system *)			
	OUT_CP.rP_Red_ExtBus_Norm:= 1.0;				(* ACHTUNG : Customized connection in 0 - 1% of Pnom *)

END_PROGRAM
