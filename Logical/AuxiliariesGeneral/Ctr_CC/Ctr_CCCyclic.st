(*******************************************************************************
Ctr_CC			

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.x.x		14.01.2015	Walid Mari  	copied from Ctr_ECW 	
V4.00.1		25.06.2015	lettenbichler	twice declared par.removed
V4.11.0		28.01.2022	Perktold		included plant controller upgrade

Instructions for use:
--------------------

Outstandings:
------------		
(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *) 
	Para.tCtr_CC.W_set;	
	Para.tCtr_CC.W_set2;
	Para.tCtr_CC.W_min;
	Para.tCtr_CC.W_max;
	Para.tCtr_CC.dW_up;
	Para.tCtr_CC.dW_down;
	Para.tCtr_CC.deadband;
	Para.tCtr_CC.Y_min;
	Para.tCtr_CC.Y_max;
	Para.tCtr_CC.dY_max;
	Para.tCtr_CC.Y_block;
	Para.tCtr_CC.invert;
	Para.tCtr_CC.Kp;
	Para.tCtr_CC.Tn;
	Para.tCtr_CC.Tv;
	Para.tCtr_CC.Kp_GainScheduling;
	Para.tCtr_CC.Tn_GainScheduling;
	Para.tCtr_CC.Tv_GainScheduling;


	(* Input variables *)
	tCtr_CC_In	 				:= VIS2MM.tCtr_CC_In;			(* from vis *)

	(* Input from module *)
	tCtr_CC_In.enable			:= OUT_AG.tBbBlower.Do		AND
								   Para.bCtr_CC 			AND
								   Para.bPr_CC_MS_Exist		AND
								   IN_AG.tPB2MM.bParaSetupOk;
									
	tCtr_CC_In.W_ext_Active		:= tCtr_CC_In.W_ext_Active;		(* from vis *) 
	tCtr_CC_In.W_ext			:= 0.0;	
	tCtr_CC_In.Y_set_Active		:= FALSE;	 
	tCtr_CC_In.Y_set			:= 0.0;
	tCtr_CC_In.X				:= IN_AG.tPr_CC.Ai; 
	tCtr_CC_In.A				:= 0;
	tCtr_CC_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_CC_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_CC_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_CC_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_CC_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
	
	(* Input from Visualization via OPC *)
	tCtr_CC_In.Y_man_Active;				
	tCtr_CC_In.Y_man;					
	tCtr_CC_In.X_min; 					
	tCtr_CC_In.X_max; 					
	tCtr_CC_In.Tune_quality;			
	tCtr_CC_In.Tune_PI;					
	tCtr_CC_In.Tune_PID;					
	tCtr_CC_In.Tune_start;				
	tCtr_CC_In.Tune_stop;				
	tCtr_CC_In.Tune_takeover;		

	xCtr_CC(); 
	
	(* Output variables function block *)
	(* Output to module(s) *)
	rPc_BbBlower 				:= tCtr_CC_Out.Y;	(* analog out *) 
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_CC_Out			:= tCtr_CC_Out;
	VIS2MM.tCtr_CC_In			:= tCtr_CC_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_CC_Out.Active;
	tCtr_CC_Out.Y;		
	tCtr_CC_Out.W;		
	tCtr_CC_Out.e;		
	tCtr_CC_Out.Kp_tune;	
	tCtr_CC_Out.Tn_tune;	
	tCtr_CC_Out.Tv_tune;	
	tCtr_CC_Out.status;

END_PROGRAM

