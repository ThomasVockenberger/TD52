(*******************************************************************************
Ctr_GC		gas compressor

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V04.00.00.00		11.04.2014	Denk		created 
V4.11.0				28.01.2022	Perktold	included plant controller upgrade
V4.12.0				13.01.2023	Zuschnig	bugfix - set value for flare operation

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_GC.W_set;	
	Para.tCtr_GC.W_set2;	
	Para.tCtr_GC.W_min;
	Para.tCtr_GC.W_max;
	Para.tCtr_GC.dW_up;
	Para.tCtr_GC.dW_down;
	Para.tCtr_GC.deadband;
	Para.tCtr_GC.Y_min;
	Para.tCtr_GC.Y_max;
	Para.tCtr_GC.dY_max;
	Para.tCtr_GC.Y_block;
	Para.tCtr_GC.invert;
	Para.tCtr_GC.Kp;
	Para.tCtr_GC.Tn;
	Para.tCtr_GC.Tv;
	Para.tCtr_GC.Kp_GainScheduling;
	Para.tCtr_GC.Tn_GainScheduling;
	Para.tCtr_GC.Tv_GainScheduling;

	
	(* Input variables *)
	tCtr_GC_In					:= VIS2MM.tCtr_GC_In;		(* from vis *)	
	

	(* Input from module *)
	tCtr_GC_In.enable			:= Para.bCtr_GC
								   AND IN_GT.tPB2MM.bParaSetupOk
								   AND OUT_GT.tGT_GC_Dem.Do;
	tCtr_GC_In.W_ext_Active		:= VIS2MM.tCtr_GC_In.W_ext_Active;
	tCtr_GC_In.W_ext			:= 0.0;
	tCtr_GC_In.Y_set_Active		:= FALSE;	 
	tCtr_GC_In.Y_set			:= 0.0;
	tCtr_GC_In.X				:= IN_GT.tPr_GT_Gas.Ai;
	tCtr_GC_In.A				:= 0;
	tCtr_GC_In.W_set2_Active	:= OUT_GT.tGT_RelFlair.Do;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_GC_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_GC_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_GC_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_GC_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_GC_In.Y_man_Active;				
	tCtr_GC_In.Y_man;					
	tCtr_GC_In.X_min; 					
	tCtr_GC_In.X_max;			
	tCtr_GC_In.Tune_quality;
	tCtr_GC_In.Tune_PI;		
	tCtr_GC_In.Tune_PID;		
	tCtr_GC_In.Tune_start;
	tCtr_GC_In.Tune_stop;
	tCtr_GC_In.Tune_takeover;
	
	xCtr_GC();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_GT.tCtr_GC_Set.Ao 		:= tCtr_GC_Out.Y;			(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_GC_Out			:= tCtr_GC_Out;
	VIS2MM.tCtr_GC_In			:= tCtr_GC_In;				(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_GC_Out.Active;
	tCtr_GC_Out.Y;		
	tCtr_GC_Out.W;		
	tCtr_GC_Out.e;		
	tCtr_GC_Out.Kp_tune;	
	tCtr_GC_Out.Tn_tune;	
	tCtr_GC_Out.Tv_tune;	
	tCtr_GC_Out.status;

END_PROGRAM
