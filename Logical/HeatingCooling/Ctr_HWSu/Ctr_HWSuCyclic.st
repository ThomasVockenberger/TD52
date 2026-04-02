(*******************************************************************************
Ctr_HWSu		controller heat water supply temperature	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0		17.04.2012	lettenb.	Created 
V3.99.0		23.11.2012	lettenb.	write back to IN_struct added (zengerer)	
									tCtr_HWSu_In.Y_set := 100.0 -> 1.0, bugfix
V4.00.0		15.12.2014	lettenb.	controller interfaces completed like standard
V4.11.0		28.01.2022	Perktold	included plant controller upgrade

Instructions for use:
--------------------

Outstandings:
------------		
(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_HWSu.W_set;	
	Para.tCtr_HWSu.W_set2;	
	Para.tCtr_HWSu.W_min;
	Para.tCtr_HWSu.W_max;
	Para.tCtr_HWSu.dW_up;
	Para.tCtr_HWSu.dW_down;
	Para.tCtr_HWSu.deadband;
	Para.tCtr_HWSu.Y_min;
	Para.tCtr_HWSu.Y_max;
	Para.tCtr_HWSu.dY_max;
	Para.tCtr_HWSu.Y_block;
	Para.tCtr_HWSu.invert;
	Para.tCtr_HWSu.Kp;
	Para.tCtr_HWSu.Tn;
	Para.tCtr_HWSu.Tv;
	Para.tCtr_HWSu.Kp_GainScheduling;
	Para.tCtr_HWSu.Tn_GainScheduling;
	Para.tCtr_HWSu.Tv_GainScheduling;
	Para.tCtr_HWSu.t_min_pulse_down;
	Para.tCtr_HWSu.t_min_pulse_up;
	Para.tCtr_HWSu.t_period_down;
	Para.tCtr_HWSu.t_period_up;

	
	(* Input variables *)
	tCtr_HWSu_In				:= VIS2MM.tCtr_HWSu_In;			(* from vis *)	

	(* Input from module *)
	tCtr_HWSu_In.enable			:=	Para.bCtr_HWSu
								AND	IN_HC.tPB2MM.bParaSetupOk
								AND IN_HC.bEng_Aux_Dem_CDR
								AND IN_HC.tT_HW_Su.GoodQual;
	tCtr_HWSu_In.W_ext_Active	:= tCtr_HWSu_In.W_ext_Active;	(* from vis *) 
	tCtr_HWSu_In.W_ext			:= 0.0;	
	tCtr_HWSu_In.Y_set_Active	:= NOT IN_HC.tT_HW_Su.GoodQual;	 
	tCtr_HWSu_In.Y_set			:= 1.0;
	tCtr_HWSu_In.X				:= IN_HC.tT_HW_Su.Ai; 
	tCtr_HWSu_In.A				:= 0;
	tCtr_HWSu_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_HWSu_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_HWSu_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_HWSu_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_HWSu_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_HWSu_In.Y_man_Active;				
	tCtr_HWSu_In.Y_man;					
	tCtr_HWSu_In.X_min; 					
	tCtr_HWSu_In.X_max; 					
	tCtr_HWSu_In.Tune_quality;			
	tCtr_HWSu_In.Tune_PI;					
	tCtr_HWSu_In.Tune_PID;					
	tCtr_HWSu_In.Tune_start;				
	tCtr_HWSu_In.Tune_stop;				
	tCtr_HWSu_In.Tune_takeover;		
	
	xCtr_HWSu();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_HC.tCtr_HWSu_Set.Ao 	:= tCtr_HWSu_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_HWSu_Out		:= tCtr_HWSu_Out;
	VIS2MM.tCtr_HWSu_In			:= tCtr_HWSu_In;	(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_HWSu_Out.Active;
	tCtr_HWSu_Out.Y;		
	tCtr_HWSu_Out.W;		
	tCtr_HWSu_Out.e;		
	tCtr_HWSu_Out.Kp_tune;	
	tCtr_HWSu_Out.Tn_tune;	
	tCtr_HWSu_Out.Tv_tune;	
	tCtr_HWSu_Out.status;

END_PROGRAM
