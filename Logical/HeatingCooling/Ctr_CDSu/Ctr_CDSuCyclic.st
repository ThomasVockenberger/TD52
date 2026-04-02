(*******************************************************************************
Ctr_CDSu		controller condensor circuit supply temperature	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.03.0		27.07.2015	Plattner	task creation
V4.11.0		28.01.2022	Perktold	included plant controller upgrade

Instructions for use:
--------------------

Outstandings:
------------		
(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_CDSu.W_set;	
	Para.tCtr_CDSu.W_set2;	
	Para.tCtr_CDSu.W_min;
	Para.tCtr_CDSu.W_max;
	Para.tCtr_CDSu.dW_up;
	Para.tCtr_CDSu.dW_down;
	Para.tCtr_CDSu.deadband;
	Para.tCtr_CDSu.Y_min;
	Para.tCtr_CDSu.Y_max;
	Para.tCtr_CDSu.dY_max;
	Para.tCtr_CDSu.Y_block;
	Para.tCtr_CDSu.invert;
	Para.tCtr_CDSu.Kp;
	Para.tCtr_CDSu.Tn;
	Para.tCtr_CDSu.Tv;
	Para.tCtr_CDSu.Kp_GainScheduling;
	Para.tCtr_CDSu.Tn_GainScheduling;
	Para.tCtr_CDSu.Tv_GainScheduling;
	Para.tCtr_CDSu.t_min_pulse_down;
	Para.tCtr_CDSu.t_min_pulse_up;
	Para.tCtr_CDSu.t_period_down;
	Para.tCtr_CDSu.t_period_up;

	
	(* Input variables *)
	tCtr_CDSu_In				:= VIS2MM.tCtr_CDSu_In;			(* from vis *)	

	(* Input from module *)
	tCtr_CDSu_In.enable			:=	Para.bCtr_CDSu
								AND	IN_HC.tPB2MM.bParaSetupOk
								AND IN_HC.bEng_Aux_Dem_CDR
								AND IN_HC.tT_CD_Su.GoodQual;
	tCtr_CDSu_In.W_ext_Active	:= tCtr_CDSu_In.W_ext_Active;	(* from vis *) 
	tCtr_CDSu_In.W_ext			:= 0.0;	
	tCtr_CDSu_In.Y_set_Active	:= NOT IN_HC.tT_CD_Su.GoodQual;	 
	tCtr_CDSu_In.Y_set			:= 1.0;
	tCtr_CDSu_In.X				:= IN_HC.tT_CD_Su.Ai; 
	tCtr_CDSu_In.A				:= 0;
	tCtr_CDSu_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_CDSu_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_CDSu_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_CDSu_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_CDSu_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_CDSu_In.Y_man_Active;				
	tCtr_CDSu_In.Y_man;					
	tCtr_CDSu_In.X_min; 					
	tCtr_CDSu_In.X_max; 					
	tCtr_CDSu_In.Tune_quality;			
	tCtr_CDSu_In.Tune_PI;					
	tCtr_CDSu_In.Tune_PID;					
	tCtr_CDSu_In.Tune_start;				
	tCtr_CDSu_In.Tune_stop;				
	tCtr_CDSu_In.Tune_takeover;		
	
	xCtr_CDSu();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_HC.tCtr_CDSu_Set.Ao 	:= tCtr_CDSu_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_CDSu_Out		:= tCtr_CDSu_Out;
	VIS2MM.tCtr_CDSu_In			:= tCtr_CDSu_In;	(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_CDSu_Out.Active;
	tCtr_CDSu_Out.Y;		
	tCtr_CDSu_Out.W;		
	tCtr_CDSu_Out.e;		
	tCtr_CDSu_Out.Kp_tune;	
	tCtr_CDSu_Out.Tn_tune;	
	tCtr_CDSu_Out.Tv_tune;	
	tCtr_CDSu_Out.status;

END_PROGRAM
