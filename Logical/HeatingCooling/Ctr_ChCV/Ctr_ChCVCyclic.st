(*******************************************************************************
Ctr_ChCV		charge temperature cooler ventilation	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0		17.04.2012	lettenb.	Created 
V3.90.0		23.11.2012	lettenb.	write back to IN_struct added (zengerer)	
V3.99.0		21.02.2013	lettenb.	IN_HC.tChCV_DemExt.Di (V3.30)
V4.00.0		15.12.2014	lettenb.	controller interfaces completed like standard
V4.11.0		28.01.2022	Perktold	included plant controller upgrade

Instructions for use:
--------------------

Outstandings:
------------		
(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_ChCV.W_set;	
	Para.tCtr_ChCV.W_set2;	
	Para.tCtr_ChCV.W_min;
	Para.tCtr_ChCV.W_max;
	Para.tCtr_ChCV.dW_up;
	Para.tCtr_ChCV.dW_down;
	Para.tCtr_ChCV.deadband;
	Para.tCtr_ChCV.Y_min;
	Para.tCtr_ChCV.Y_max;
	Para.tCtr_ChCV.dY_max;
	Para.tCtr_ChCV.Y_block;
	Para.tCtr_ChCV.invert;
	Para.tCtr_ChCV.Kp;
	Para.tCtr_ChCV.Tn;
	Para.tCtr_ChCV.Tv;
	Para.tCtr_ChCV.Kp_GainScheduling;
	Para.tCtr_ChCV.Tn_GainScheduling;
	Para.tCtr_ChCV.Tv_GainScheduling;
	Para.tCtr_ChCV.t_min_pulse_down;
	Para.tCtr_ChCV.t_min_pulse_up;
	Para.tCtr_ChCV.t_period_down;
	Para.tCtr_ChCV.t_period_up;

	
	(* Input variables *)
	tCtr_ChCV_In				:= VIS2MM.tCtr_ChCV_In;			(* from vis *)	

	(* Input from module *)
	tCtr_ChCV_In.enable			:=	Para.bCtr_ChCV
								AND	IN_HC.tPB2MM.bParaSetupOk
								AND IN_HC.bEng_Aux_Dem_CDR;
	tCtr_ChCV_In.W_ext_Active	:= tCtr_ChCV_In.W_ext_Active OR TRUE;	(* from vis *) 
	tCtr_ChCV_In.W_ext			:= Para.tCtr_ChCV.W_set - ((Para.rT_T2_Set[1] - IN_HC.rT_ChC_Ctr_Wex) * rChCV_Wex_factor);	
	tCtr_ChCV_In.Y_set_Active	:= FALSE;	 
	tCtr_ChCV_In.Y_set			:= 0.0;
	tCtr_ChCV_In.X				:= IN_HC.rT_Ch_T2s_Avg;
	tCtr_ChCV_In.A				:= 0;
	tCtr_ChCV_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_ChCV_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_ChCV_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_ChCV_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_ChCV_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_ChCV_In.Y_man_Active;				
	tCtr_ChCV_In.Y_man;					
	tCtr_ChCV_In.X_min; 					
	tCtr_ChCV_In.X_max; 					
	tCtr_ChCV_In.Tune_quality;			
	tCtr_ChCV_In.Tune_PI;					
	tCtr_ChCV_In.Tune_PID;					
	tCtr_ChCV_In.Tune_start;				
	tCtr_ChCV_In.Tune_stop;				
	tCtr_ChCV_In.Tune_takeover;		
	
	xCtr_ChCV();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_HC.tCtr_ChCV_Set.Ao 	:= tCtr_ChCV_Out.Y;		(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_ChCV_Out		:= tCtr_ChCV_Out;
	VIS2MM.tCtr_ChCV_In			:= tCtr_ChCV_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_ChCV_Out.Active;
	tCtr_ChCV_Out.Y;		
	tCtr_ChCV_Out.W;		
	tCtr_ChCV_Out.e;		
	tCtr_ChCV_Out.Kp_tune;	
	tCtr_ChCV_Out.Tn_tune;	
	tCtr_ChCV_Out.Tv_tune;	
	tCtr_ChCV_Out.status;

END_PROGRAM
