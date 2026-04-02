(*******************************************************************************
Ctr_ChCHP		charge temperature cooler high pressure	

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
V4.00.0		15.12.2014	lettenb.	controller interfaces completed like standard
V4.11.0		28.01.2022	Perktold	included plant controller upgrade

Instructions for use:
--------------------

Outstandings:
------------		
(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_ChCHP.W_set;	
	Para.tCtr_ChCHP.W_set2;	
	Para.tCtr_ChCHP.W_min;
	Para.tCtr_ChCHP.W_max;
	Para.tCtr_ChCHP.dW_up;
	Para.tCtr_ChCHP.dW_down;
	Para.tCtr_ChCHP.deadband;
	Para.tCtr_ChCHP.Y_min;
	Para.tCtr_ChCHP.Y_max;
	Para.tCtr_ChCHP.dY_max;
	Para.tCtr_ChCHP.Y_block;
	Para.tCtr_ChCHP.invert;
	Para.tCtr_ChCHP.Kp;
	Para.tCtr_ChCHP.Tn;
	Para.tCtr_ChCHP.Tv;
	Para.tCtr_ChCHP.Kp_GainScheduling;
	Para.tCtr_ChCHP.Tn_GainScheduling;
	Para.tCtr_ChCHP.Tv_GainScheduling;
	Para.tCtr_ChCHP.t_min_pulse_down;
	Para.tCtr_ChCHP.t_min_pulse_up;
	Para.tCtr_ChCHP.t_period_down;
	Para.tCtr_ChCHP.t_period_up;

	
	(* Input variables *)
	tCtr_ChCHP_In				:= VIS2MM.tCtr_ChCHP_In;		(* from vis *)	

	(* Input from module *)
	tCtr_ChCHP_In.enable		:=	Para.bCtr_ChCHP
								AND	IN_HC.tPB2MM.bParaSetupOk
								AND(IN_HC.bEng_Aux_Dem_CDR OR bN_EngStart);
	tCtr_ChCHP_In.W_ext_Active	:= tCtr_ChCHP_In.W_ext_Active;	(* from vis *) 
	tCtr_ChCHP_In.W_ext			:= 0.0;	
	tCtr_ChCHP_In.Y_set_Active	:= FALSE;	 
	tCtr_ChCHP_In.Y_set			:= 0.0;
	tCtr_ChCHP_In.X				:= IN_HC.rT_Ch_T2s_Avg; 
	tCtr_ChCHP_In.A				:= 0;
	tCtr_ChCHP_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_ChCHP_In.GainScheduling:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_ChCHP_In.Y_min_cust	:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_ChCHP_In.Y_max_cust	:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_ChCHP_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_ChCHP_In.Y_man_Active;				
	tCtr_ChCHP_In.Y_man;					
	tCtr_ChCHP_In.X_min; 					
	tCtr_ChCHP_In.X_max; 					
	tCtr_ChCHP_In.Tune_quality;			
	tCtr_ChCHP_In.Tune_PI;					
	tCtr_ChCHP_In.Tune_PID;					
	tCtr_ChCHP_In.Tune_start;				
	tCtr_ChCHP_In.Tune_stop;				
	tCtr_ChCHP_In.Tune_takeover;		
	
	xCtr_ChCHP();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_HC.tCtr_ChCHP_Set.Ao 	:= tCtr_ChCHP_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_ChCHP_Out		:= tCtr_ChCHP_Out;
	VIS2MM.tCtr_ChCHP_In		:= tCtr_ChCHP_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_ChCHP_Out.Active;
	tCtr_ChCHP_Out.Y;		
	tCtr_ChCHP_Out.W;		
	tCtr_ChCHP_Out.e;		
	tCtr_ChCHP_Out.Kp_tune;	
	tCtr_ChCHP_Out.Tn_tune;	
	tCtr_ChCHP_Out.Tv_tune;	
	tCtr_ChCHP_Out.status;

END_PROGRAM
