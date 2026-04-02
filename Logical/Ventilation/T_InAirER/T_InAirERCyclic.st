(*******************************************************************************
T_InAirER		temperature inlet air engine room

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V190	12.08.2004	LH			erstellt
V220	01.03.2007	LH			Erweiterung auf Pt100
 		10.04.2007	LH			Korrektur Messignalüberwachung, Zuweisung für Pt100 
V2201	23.07.2007	LH			Messignalüberwachung: UGR -20°C --> -50°C
V3.99.0	22.02.2013	lettenb.	a_lt renamed to T_InAirER, p_limitVE included
		26.04.2013				xGRMAX_T_InAirER_LimHi: Hy 10.0 --> 1.0 bugfix
		02.10.2013				rP_Red_T_InAirER_Lim  := 0.0; bugfix 
V4.04	02.11.2016	Tinello		monitoring "bT_InAirER_Hi" deleted, Para.bT_InAirER_Active removed --> moved to modul CH

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC
	
	(*---------------------------------------------------------------------------*)
	(* engine room inlet air temperature high (open inlet louvers) *)
	IN_VE.rT_Ch_T1LP_Avg;	(* value(from CH) = 0 in case of no sensor is active or signal failure *)

	xGRMAX_T_InAirER_LimHi_Lou(Gw:= Para.rT_InAirER_LimHi_Lou, Hy:= Para.rT_Lou_InAirER_HyHi, In:= IN_VE.rT_Ch_T1LP_Avg);
	bT_InAirER_LimHi_Lou := IN_VE.tPB2MM.bParaSetupOk AND xGRMAX_T_InAirER_LimHi_Lou.Q;

	(*---------------------------------------------------------------------------*)
	(* engine room inlet air temperature high (start fan *)
	xGRMAX_T_InAirER_LimHi_Fan(Gw:= Para.rT_InAirER_LimHi_Fan, Hy:= Para.rT_Fan_InAirER_HyHi, In:= IN_VE.rT_Ch_T1LP_Avg);
	bT_InAirER_LimHi_Fan := IN_VE.tPB2MM.bParaSetupOk AND xGRMAX_T_InAirER_LimHi_Fan.Q;

	
	(*===========================================================================*)
	(* power limitation by engine room air inlet temperature high from engine nominal power *)
	IF Para.bPred_T_InAirER_Active THEN
		IF Para.rT_Pred_InAirER_Start2 > Para.rT_Pred_InAirER_Start THEN	(* parameter plausibility check *)
			rT_Pred_InAirER_Start1	:=	Para.rT_Pred_InAirER_Start;			(* copy to local pv *)
			rT_Pred_InAirER_Rate1	:=	Para.rT_Pred_InAirER_Rate;
			rT_Pred_InAirER_Start2	:=	Para.rT_Pred_InAirER_Start2;
			rT_Pred_InAirER_Rate2	:=	Para.rT_Pred_InAirER_Rate2;
		ELSIF Para.rT_Pred_InAirER_Start2 < Para.rT_Pred_InAirER_Start THEN
			rT_Pred_InAirER_Start1	:=	Para.rT_Pred_InAirER_Start2;
			rT_Pred_InAirER_Rate1	:=	Para.rT_Pred_InAirER_Rate2;
			rT_Pred_InAirER_Start2	:=	Para.rT_Pred_InAirER_Start;
			rT_Pred_InAirER_Rate2	:=	Para.rT_Pred_InAirER_Rate;		
		ELSIF Para.rT_Pred_InAirER_Start2 = Para.rT_Pred_InAirER_Start THEN
			rT_Pred_InAirER_Start1	:=	Para.rT_Pred_InAirER_Start2;
			rT_Pred_InAirER_Rate1	:=	Para.rT_Pred_InAirER_Rate2;
			rT_Pred_InAirER_Start2	:=	Para.rT_Pred_InAirER_Start;
			rT_Pred_InAirER_Rate2	:=	Para.rT_Pred_InAirER_Rate;		
			IF Para.rT_Pred_InAirER_Rate > Para.rT_Pred_InAirER_Rate2 THEN	(* higher reduction is active *)
				rT_Pred_InAirER_Rate1	:=	Para.rT_Pred_InAirER_Rate;
				rT_Pred_InAirER_Rate2	:=	Para.rT_Pred_InAirER_Rate;
			ELSE
				rT_Pred_InAirER_Rate1	:=	Para.rT_Pred_InAirER_Rate2;
				rT_Pred_InAirER_Rate2	:=	Para.rT_Pred_InAirER_Rate2;
			END_IF;
		END_IF;			
			
		IF IN_VE.rT_Ch_T1LP_Avg > rT_Pred_InAirER_Start2 THEN
			rP_Red_T_InAirER_Lim1 := (rT_Pred_InAirER_Start2 - rT_Pred_InAirER_Start1) * rT_Pred_InAirER_Rate1;
			rP_Red_T_InAirER_Lim2 := (IN_VE.rT_Ch_T1LP_Avg    - rT_Pred_InAirER_Start2) * rT_Pred_InAirER_Rate2;
			rP_Red_T_InAirER_Lim  :=  rP_Red_T_InAirER_Lim1  + rP_Red_T_InAirER_Lim2;
		ELSIF IN_VE.rT_Ch_T1LP_Avg > rT_Pred_InAirER_Start1 THEN
			rP_Red_T_InAirER_Lim  := ((IN_VE.rT_Ch_T1LP_Avg   - rT_Pred_InAirER_Start1) * rT_Pred_InAirER_Rate1);
		ELSE
			rP_Red_T_InAirER_Lim  := 0.0;
		END_IF;
		
		OUT_VE.rP_Red_T_InAirER_Norm := LIMIT(0.5, 1.0 - rP_Red_T_InAirER_Lim, 1.0);
	ELSE
		OUT_VE.rP_Red_T_InAirER_Norm := 1.0;
	END_IF;
	
	
	
END_PROGRAM