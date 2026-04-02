(*******************************************************************************
OilFill: plant auxiliaries oil fill and refilling handling for Fresh Oil + Day Tank 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2024

Customized modifications: -
------------------------
 
History:
-------
V4.14.0.96	11-11-2024 Zengerer   new, based on TKE spec 2023-171 and standard layout example G2 default from Kluckner 	
V4.14.0		19-12-2024 Zengerer   reduced implementation, limited to OPTION 03: customized  	


Instructions for use:
--------------------
For this first reduced implementation in V4.14: ONLY CU MODULE INTERFACES are prepared so far;
All detailed variant implementations have to be done by requisition in a similar way as before in CU module. 
Use new standardised interfaces OUT_CU.bCust_Dem_FreshOilPump and OUT_CU.bCust_Dem_WastehOilPump as replacement of former utilised tCustDigOut[x].Do

Outstandings:
------------
-SPEC V5 NEEDS CLARIFICATION -> Only reduced implementation in V4.14, limited to Para.iOilRefill_Type = 03:
   ->CU module interface active only as default, since no other types are released until now

*******************************************************************************)

		
PROGRAM _CYCLIC	
	(*----------------------------------------------------------------------------------------*)
	(*Added IN Interface V4.14*)
	(*------------------------*)
	(*none*)

	(*Added OUT Interface V4.14*)
	(*-------------------------*)
	OUT_AG.tEO_FreshOilPump_Dem.Do ;	MM2VIS.bEO_FreshOilPump ;	(*P&ID Tag P.03-M-010 OR P.03-M-002 + P.03-M-003  (depending on hardware configuration) *)
	OUT_AG.tEO_WasteOilPump_Dem.Do ;	MM2VIS.bEO_WasteOilPump ;	(*P&ID Tag P.03-M-001 OR P.03-P-020 	(depending on hardware configuration) *)
	
	(*Added Parameter in V4.14*)
	(*-------------------------*)
	Para.tiFreshOilPump_Delay;			(* Para[15065] *)
	Para.tiFreshOilPump_RTC_Time ;		(* existing Para[13308] *)  

	(*Added CU Modul Interface V4.14*)
	(*------------------------------*)
  	IN_AG.bCust_Dem_FreshOilPump ;		(*Customized demand for fresh oil pump*) (*OldName:new V4.14; Cycle:5*)
	IN_AG.bCust_Dem_WasteOilPump ;	 	(*Customized demand for waste oil pump*) (*OldName:new V4.14; Cycle:5*)
	OUT_AG.bAux_OilValve_IsOpen ;		(*Status information (without TOF), to be used for release of customized oil pump controls *)
										(*Replaces removed IN_AG.bCust_Dem_OilFillValve  -> Use OUT_AG.bAux_OilValve_IsOpen information to stop pumps in CU module *)
	

	(*Prepared new Interface for later release*)
	(*------------------------*)

 	VIS2MM.bDem_Oil_Filling ;			(*HMI demand for fresh oil pump*) (*OldName:new V4.14; Cycle:5*)
 	VIS2MM.bDem_Oil_Change ;	 		(*HMI demand for waste oil pump*) (*OldName:new V4.14; Cycle:5*)

// 	IN_AG.tOil_Filling_Req ; 			(*DI opreator switch input for fresh oil pump*) 
// 	IN_AG.tOil_Change_Req ;	 			(*DI opreator switch input for waste oil pump*)
// 	IN_AG.tOil_Change_StopReq ;			(*DI opreator switch input to stop active oil fill pumps and valve*)
	IN_AG.bCust_Dem_OilFillValve ;		(*prepared, function postphoned*)



	(*Prepared new Parameter for later release*)
	(*-------------------------*)
	Para.tiFreshOilPump_Intervall;
	Para.tiFreshOilPump_Pause;
	Para.iOilRefill_Type;
	IF Para.iOilRefill_Type = 0 THEN  Para.iOilRefill_Type := 3; 	END_IF		(*set default CUSTOMIZED IMPLEMENTATION for V4.14, since no other types are released until now *)
	(*Configuration oi refill layout with Para.iOilRefill_Type:*)
	(*Type   1: direct engine refill with valve from fresh oil tank  *)
	(*Type  11: direct engine refill with valve and pump*)
	(*...									*
	(*Type   3: customized implementation of oil refill (using only IN_AG.bCust_Dem_FreshOilPump, IN_AG.bCust_Dem_WasteOilPump, IN_AG.bCust_Dem_OilFillValve, logic implementation in CU)



	(*-----------------------------------------------------------------------------------*)
	(*forward valve signal (without TOF delay) for fresh oil pump release, to avoid pressure peaks*)
	OUT_AG.bAux_OilValve_IsOpen	:= bEOVal_DemOpen;		(*	internal demand for oil refill valve V4.14 WITHOUT TOF, forwarding for pump release *)
	(*forward valve signal wit TON delay for fresh oil pump release, to avoid pressure peaks*)
	TON_EOVal_Open.IN			:= bEOVal_DemOpen;		(*	TON delayed Valve signal for pump demand *)
	TON_EOVal_Open.PT			:= Para.tiFreshOilPump_Delay;			(* Para[15065] *)
	TON_EOVal_Open();


	(*fresh oil pump needs not to open oil pan valve to operate?*)
	bFreshOilPump_WithoutValve	:= FALSE;		(*Only customized implementation with V4.14, so no versions without delay allowed until now*)					//:=	(Para.iOilRefill_Type <> 11) AND (Para.iOilRefill_Type <> 111) ;
	(*waste oil pump needs not to open oil pan valve to operate?*)
	bWasteOilPump_WithoutValve 	:= TRUE;		(*Only customized implementation with V4.14, so no versions with valve as standard implementation prepared*)	//:=	(Para.iOilRefill_Type <> 112);

	(*----------------------------------------------------------------------------------------*)
	(*CUSTOMIZED ONLY logic: *)
	IF Para.iOilRefill_Type = 3 THEN 
		OUT_AG.tEO_FreshOilPump_Dem.Do := 	IN_AG.bCust_Dem_FreshOilPump 				(*Customized demand for fresh oil pump*) (*new V4.14*)
									AND (TON_EOVal_Open.Q OR bFreshOilPump_WithoutValve )
									AND NOT IN_AG.bMsg1056 ; 				
		OUT_AG.tEO_WasteOilPump_Dem.Do := 	IN_AG.bCust_Dem_WasteOilPump 	 			(*Customized demand for waste oil pump*)  (*new V4.14*)
									AND (TON_EOVal_Open.Q OR bWasteOilPump_WithoutValve)
									AND NOT IN_AG.bMsg1056 ;

		OUT_AG.bAux_OilValve_IsOpen ;	
		MM2VIS.bInitialOilFill_DemOpen ; (*REMOVED HERE; use bAux_OilValve_IsOpen!       (*Customized demand for (fresh) oil valve*)  (*new V4.14*)
		RETURN ; 																		(* no further execution of standardised code*)
	END_IF



	(*--------------------------------------------------------------------------------*)
//CODE PART FOR OTHER REFILL TYPES TEMPORARY REMOVED,  spec needs further clarification
												
	(*--------------------------------------------------------------------------------*)		
END_PROGRAM