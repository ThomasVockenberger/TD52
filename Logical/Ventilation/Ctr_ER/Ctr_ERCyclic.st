(*******************************************************************************
Ctr_ER		controller engine room temperature	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0		17.04.2012	lettenbichler	created 
			23.11.2012	lettenbichler	write back to IN_struct added (zengerer)	
V3.99.0		24.06.2013	lettenbichler	tCtr_ER_In.Y_set := 100.0 -> 1.0, bugfix
V4.00.0		22.05.2015					tCtr_ER_In.X: Para.bT_InAirER_Active added(room vent.to 100% if no sensor active)
V4.03.0 	07.08.2015  Denk			Manual operating auxiliaries control functionality added
V4.05.0 	20.09.2017	Messner			Active Cooling Program added
V4.11.0		28.01.2022	Perktold		included plant controller upgrade

Instructions for use:
--------------------

Outstandings:
------------	
(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameter *)
	Para.tCtr_ER.W_set;	
	Para.tCtr_ER.W_set2;	
	Para.tCtr_ER.W_min;
	Para.tCtr_ER.W_max;
	Para.tCtr_ER.dW_up;
	Para.tCtr_ER.dW_down;
	Para.tCtr_ER.deadband;
	Para.tCtr_ER.Y_min;
	Para.tCtr_ER.Y_max;
	Para.tCtr_ER.dY_max;
	Para.tCtr_ER.Y_block;
	Para.tCtr_ER.invert;
	Para.tCtr_ER.Kp;
	Para.tCtr_ER.Tn;
	Para.tCtr_ER.Tv;
	Para.tCtr_ER.Kp_GainScheduling;
	Para.tCtr_ER.Tn_GainScheduling;
	Para.tCtr_ER.Tv_GainScheduling;
	Para.tCtr_ER.t_min_pulse_down;
	Para.tCtr_ER.t_min_pulse_up;
	Para.tCtr_ER.t_period_down;
	Para.tCtr_ER.t_period_up;

	
	(* Input variables *)
	tCtr_ER_In	 				:= VIS2MM.tCtr_ER_In;

	(* Input from module *)
	tCtr_ER_In.enable			:=	IN_VE.tPB2MM.bParaSetupOk		(* enable controller *)
							AND		Para.bCtr_ER 
							AND 	OUT_VE.tRel_ER_FC.Do
							AND	  ((RTM25 AND OUT_VE.tRel_ER_Fan.Do) OR (Para.bER_VentColdCountryMode AND NOT OUT_VE.tSet_ER_Fan_Min.Do))
							AND NOT MS_LUE 
							AND NOT bCtrER_YFix;
	
	tCtr_ER_In.W_ext_Active	:= tCtr_ER_In.W_ext_Active OR TRUE;		(* select external W *) //from visu 

	IF IN_VE.bEng_Aux_Dem_CDR THEN
		tCtr_ER_In.W_ext :=	 Para.rT_CtrER_WexRun;					(* external W *)
	ELSIF IN_VE.bACP_AirER_Dem THEN
		tCtr_ER_In.W_ext :=	 Para.rT_ACP_AirER_sp;					(* ACP  Room Temperature set point *)
	ELSE
		tCtr_ER_In.W_ext :=	 Para.rT_CtrER_WexStop;		
	END_IF;
	tCtr_ER_In.W_set2_Active	:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_ER_In.GainScheduling	:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_ER_In.Y_min_cust		:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_ER_In.Y_max_cust		:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_ER_In.Retrigger		:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
	tCtr_ER_In.A;								(*optional: feed forward Input*)
		
	IF bCtrER_YFix = TRUE THEN
		tCtr_ER_In.Y_set_Active	:= bCtrER_YFix; 	 				(* select external Y *)
		tCtr_ER_In.Y_set		:= 1.0;	
	ELSIF (	NOT tCtr_ER_In.enable 									(* Manual operating auxiliaries control - Handbedienebene *)
			AND OUT_VE.tRel_ER_FC.Do 
			AND IN_VE.tManAuxCtr.bER_FC_Set) THEN  					
		tCtr_ER_In.Y_set_Active := TRUE;
		tCtr_ER_In.Y_set		:= IN_VE.tManAuxCtr.rER_FC_Set;
	ELSE
		tCtr_ER_In.Y_set_Active	:= FALSE;	
	END_IF;

	IF Para.bER_VentColdCountryMode AND IN_VE.bEng_Aux_Dem_CDR (*AND Para.bT_InAirER_Active*) THEN
		tCtr_ER_In.X :=	MAX(rT_AirER, IN_VE.rT_Ch_T1LP_Avg);		(* select X *)	
	ELSE	
		tCtr_ER_In.X :=	    rT_AirER;
	END_IF;
	tCtr_ER_In.A := 0;
		
	(* Input from Visualization via OPC *)
	tCtr_ER_In.Y_man_Active;				
	tCtr_ER_In.Y_man;					
	tCtr_ER_In.X_min; 					
	tCtr_ER_In.X_max; 					
	tCtr_ER_In.Tune_quality;			
	tCtr_ER_In.Tune_PI;					
	tCtr_ER_In.Tune_PID;					
	tCtr_ER_In.Tune_start;				
	tCtr_ER_In.Tune_stop;				
	tCtr_ER_In.Tune_takeover;		
	
	xCtr_ER();

	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_VE.tER_FC_Set.Ao 	:= tCtr_ER_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_ER_Out		:= tCtr_ER_Out;	
	VIS2MM.tCtr_ER_In		:= tCtr_ER_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	


	tCtr_ER_Out.Active;
	tCtr_ER_Out.Y;		
	tCtr_ER_Out.W;		
	tCtr_ER_Out.e;		
	tCtr_ER_Out.Kp_tune;	
	tCtr_ER_Out.Tn_tune;	
	tCtr_ER_Out.Tv_tune;	
	tCtr_ER_Out.status;
	tCtr_ER_Out.Step_down;
	tCtr_ER_Out.Step_up;



END_PROGRAM
