(*******************************************************************************
Ctr_OutlVentRT		controller engine room temperature with outlet ventilation fan(s)	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.04.0		04.10.2016	Stary			created 
V4.11.0		28.01.2022	Perktold		included plant controller upgrade

Specification       : PID-controller for outlet ventilation fan(s) to ensure a constant room temperature 
		
Instructions for use: Modify release/X/external Y customized when needed
--------------------

Outstandings: 
------------	
(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameter *)
	Para.tCtr_OutlVE_RT.W_set;	
	Para.tCtr_OutlVE_RT.W_set2;	
	Para.tCtr_OutlVE_RT.W_min;
	Para.tCtr_OutlVE_RT.W_max;
	Para.tCtr_OutlVE_RT.dW_up;
	Para.tCtr_OutlVE_RT.dW_down;
	Para.tCtr_OutlVE_RT.deadband;
	Para.tCtr_OutlVE_RT.Y_min;
	Para.tCtr_OutlVE_RT.Y_max;
	Para.tCtr_OutlVE_RT.dY_max;
	Para.tCtr_OutlVE_RT.Y_block;
	Para.tCtr_OutlVE_RT.invert;
	Para.tCtr_OutlVE_RT.Kp;
	Para.tCtr_OutlVE_RT.Tn;
	Para.tCtr_OutlVE_RT.Tv;
	Para.tCtr_OutlVE_RT.Kp_GainScheduling;
	Para.tCtr_OutlVE_RT.Tn_GainScheduling;
	Para.tCtr_OutlVE_RT.Tv_GainScheduling;
	Para.tCtr_OutlVE_RT.t_min_pulse_down;
	Para.tCtr_OutlVE_RT.t_min_pulse_up;
	Para.tCtr_OutlVE_RT.t_period_down;
	Para.tCtr_OutlVE_RT.t_period_up;

	
	(* Input variables *)
	tCtr_OutlVE_RT_In	 		:= VIS2MM.tCtr_OutlVE_RT_In;

	(* Input from module *)
	tCtr_OutlVE_RT_In.enable	:=	IN_VE.tPB2MM.bParaSetupOk		(* enable controller *)
							AND	    Para.bCtr_OutlVE_RT 
							AND     OUT_VE.tRel_ER_FC.Do
							AND	    RTM25 
							AND     OUT_VE.tRel_ER_Fan.Do
							AND NOT MS_LUE 
							AND NOT bCtrER_YFix;
	
	tCtr_OutlVE_RT_In.W_ext_Active	:= tCtr_OutlVE_RT_In.W_ext_Active OR TRUE;	(* select external W *) //from visu 

	IF IN_VE.bEng_Aux_Dem_CDR THEN
		tCtr_OutlVE_RT_In.W_ext :=	 Para.rT_CtrER_WexRun;					(* external W --> same parameter as for inlet fans *)
	ELSE
		tCtr_OutlVE_RT_In.W_ext :=	 Para.rT_CtrER_WexStop;					(* external W --> same parameter as for inlet fans *)	
	END_IF;
	tCtr_OutlVE_RT_In.W_set2_Active		:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_OutlVE_RT_In.GainScheduling	:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_OutlVE_RT_In.Y_min_cust		:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_OutlVE_RT_In.Y_max_cust		:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_OutlVE_RT_In.Retrigger			:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
	tCtr_OutlVE_RT_In.A;								(*optional: feed forward Input*)
	
	IF bCtrER_YFix THEN
		tCtr_OutlVE_RT_In.Y_set_Active  := bCtrER_YFix; 	 				(* select external Y *)
		tCtr_OutlVE_RT_In.Y_set         := 1.0;	
	ELSIF  (NOT tCtr_OutlVE_RT_In.enable 
		AND OUT_VE.tRel_ER_FC.Do 
		AND IN_VE.tManAuxCtr.bER_OutlV_FC_Set) THEN	(* Manual operating auxiliaries control - Handbedienebene *)
		tCtr_OutlVE_RT_In.Y_set_Active  := TRUE;
		tCtr_OutlVE_RT_In.Y_set         := IN_VE.tManAuxCtr.rER_OutlV_FC_Set;
	ELSE
		tCtr_OutlVE_RT_In.Y_set_Active  := FALSE;	
	END_IF;
		
	tCtr_OutlVE_RT_In.X := rT_AirER;			(* select X *)	
	
	(* Input from Visualization via OPC *)
	tCtr_OutlVE_RT_In.Y_man_Active;				
	tCtr_OutlVE_RT_In.Y_man;					
	tCtr_OutlVE_RT_In.X_min; 					
	tCtr_OutlVE_RT_In.X_max; 					
	tCtr_OutlVE_RT_In.Tune_quality;			
	tCtr_OutlVE_RT_In.Tune_PI;					
	tCtr_OutlVE_RT_In.Tune_PID;					
	tCtr_OutlVE_RT_In.Tune_start;				
	tCtr_OutlVE_RT_In.Tune_stop;				
	tCtr_OutlVE_RT_In.Tune_takeover;		
	
	xCtr_OutlVE_RT();

	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_VE.tCtr_OutlVE_RT_Set.Ao 	:= tCtr_OutlVE_RT_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_OutlVE_RT_Out		:= tCtr_OutlVE_RT_Out;	
	VIS2MM.tCtr_OutlVE_RT_In		:= tCtr_OutlVE_RT_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	


	tCtr_OutlVE_RT_Out.Active;
	tCtr_OutlVE_RT_Out.Y;		
	tCtr_OutlVE_RT_Out.W;		
	tCtr_OutlVE_RT_Out.e;		
	tCtr_OutlVE_RT_Out.Kp_tune;	
	tCtr_OutlVE_RT_Out.Tn_tune;	
	tCtr_OutlVE_RT_Out.Tv_tune;	
	tCtr_OutlVE_RT_Out.status;
	tCtr_OutlVE_RT_Out.Step_down;
	tCtr_OutlVE_RT_Out.Step_up;



END_PROGRAM
