(*******************************************************************************
Ctr_EC		controller heat water return temperature after emergency cooler	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0		17.04.2012 	lettenb.	Created 
V3.99.0		23.11.2012	lettenb.	write back to IN_struct added (zengerer)	
V4.00.0		15.12.2014	lettenb.	controller interfaces completed like standard
V4.03.0     05.08.2015  Stary		added actual position feedback for regulator valve
V4.11.0		28.01.2022	Perktold	included plant controller upgrade

Instructions for use:
--------------------

Outstandings:
------------		
(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_EC.W_set;	
	Para.tCtr_EC.W_set2;	
	Para.tCtr_EC.W_min;
	Para.tCtr_EC.W_max;
	Para.tCtr_EC.dW_up;
	Para.tCtr_EC.dW_down;
	Para.tCtr_EC.deadband;
	Para.tCtr_EC.Y_min;
	Para.tCtr_EC.Y_max;
	Para.tCtr_EC.dY_max;
	Para.tCtr_EC.Y_block;
	Para.tCtr_EC.invert;
	Para.tCtr_EC.Kp;
	Para.tCtr_EC.Tn;
	Para.tCtr_EC.Tv;
	Para.tCtr_EC.Kp_GainScheduling;
	Para.tCtr_EC.Tn_GainScheduling;
	Para.tCtr_EC.Tv_GainScheduling;
	Para.tCtr_EC.t_min_pulse_down;
	Para.tCtr_EC.t_min_pulse_up;
	Para.tCtr_EC.t_period_down;
	Para.tCtr_EC.t_period_up;

	
	(* Input variables *)
	tCtr_EC_In					:= VIS2MM.tCtr_EC_In;		(* from vis *)	

	(* Input from module *)
	tCtr_EC_In.enable			:=	Para.bCtr_EC 
								AND IN_HC.tPB2MM.bParaSetupOk
								AND IN_HC.bEng_Aux_Dem_CDR;	
	tCtr_EC_In.W_ext_Active		:= tCtr_EC_In.W_ext_Active;	(* from vis *) 
	tCtr_EC_In.W_ext			:= 0.0;	
	tCtr_EC_In.Y_set_Active		:= FALSE;	 
	tCtr_EC_In.Y_set			:= 0.0;
	tCtr_EC_In.X				:= IN_HC.tT_HW_ReAfEC.Ai; 
	tCtr_EC_In.A				:= 0;
	tCtr_EC_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_EC_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_EC_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_EC_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_EC_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_EC_In.Y_man_Active;				
	tCtr_EC_In.Y_man;					
	tCtr_EC_In.X_min; 					
	tCtr_EC_In.X_max; 					
	tCtr_EC_In.Tune_quality;			
	tCtr_EC_In.Tune_PI;					
	tCtr_EC_In.Tune_PID;					
	tCtr_EC_In.Tune_start;				
	tCtr_EC_In.Tune_stop;				
	tCtr_EC_In.Tune_takeover;		
	
	xCtr_EC();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_HC.tCtr_EC_Set.Ao 		:= tCtr_EC_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_EC_Out			:= tCtr_EC_Out;
	MM2VIS.rPos_HW_EC_ReValve   := IN_HC.tPos_HW_EC_ReValve.Ai;
	VIS2MM.tCtr_EC_In			:= tCtr_EC_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_EC_Out.Active;
	tCtr_EC_Out.Y;		
	tCtr_EC_Out.W;		
	tCtr_EC_Out.e;		
	tCtr_EC_Out.Kp_tune;	
	tCtr_EC_Out.Tn_tune;	
	tCtr_EC_Out.Tv_tune;	
	tCtr_EC_Out.status;

END_PROGRAM

