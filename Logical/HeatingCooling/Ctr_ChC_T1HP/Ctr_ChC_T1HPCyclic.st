(*******************************************************************************
Ctr_ChC_T1HP	charge temperature before high-pressure turbo charger (cooler)	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0		09.08.2018	Schmid		created 
V4.07.0		09.08.2018	Schmid		copy of Ctr_ChC, adapted to control T1-HP
			05.10.2018	Schmid		parameter OF ctr struct used FOR setpoint W_set (removed separate parameter)
V4.11.0		28.01.2022	Perktold	included plant controller upgrade

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_ChC_T1HP.W_set;	
	Para.tCtr_ChC_T1HP.W_set2;	
	Para.tCtr_ChC_T1HP.W_min;
	Para.tCtr_ChC_T1HP.W_max;
	Para.tCtr_ChC_T1HP.dW_up;
	Para.tCtr_ChC_T1HP.dW_down;
	Para.tCtr_ChC_T1HP.deadband;
	Para.tCtr_ChC_T1HP.Y_min;
	Para.tCtr_ChC_T1HP.Y_max;
	Para.tCtr_ChC_T1HP.dY_max;
	Para.tCtr_ChC_T1HP.Y_block;
	Para.tCtr_ChC_T1HP.invert;
	Para.tCtr_ChC_T1HP.Kp;
	Para.tCtr_ChC_T1HP.Tn;
	Para.tCtr_ChC_T1HP.Tv;
	Para.tCtr_ChC_T1HP.Kp_GainScheduling;
	Para.tCtr_ChC_T1HP.Tn_GainScheduling;
	Para.tCtr_ChC_T1HP.Tv_GainScheduling;
	Para.tCtr_ChC_T1HP.t_min_pulse_down;
	Para.tCtr_ChC_T1HP.t_min_pulse_up;
	Para.tCtr_ChC_T1HP.t_period_down;
	Para.tCtr_ChC_T1HP.t_period_up;
	
	(* Input variables *)
	tCtr_ChC_T1HP_In			:= VIS2MM.tCtr_ChC_T1HP_In;		(* from vis *)	
	

	(* Input from module *)
	tCtr_ChC_T1HP_In.enable			:=	Para.bCtr_ChC_T1HP
									AND	IN_HC.tPB2MM.bParaSetupOk
									AND IN_HC.bEng_Aux_Dem_CDR
									AND(bN_EngStart OR tCtr_ChC_T1HP_In.enable);
	tCtr_ChC_T1HP_In.W_ext_Active	:= VIS2MM.tCtr_ChC_T1HP_In.W_ext_Active OR TRUE;
	tCtr_ChC_T1HP_In.W_ext			:= Para.tCtr_ChC_T1HP.W_set;
	tCtr_ChC_T1HP_In.Y_set_Active	:= IN_HC.bAMM_T_Ch_T1HP_Avg;//FALSE;	  freeze SWAT920/2
	tCtr_ChC_T1HP_In.Y_set			:= 0.5;//0.0;		         			  freeze SWAT920/2
	tCtr_ChC_T1HP_In.X				:= IN_HC.rT_Ch_T1HP_Avg; 
	tCtr_ChC_T1HP_In.A				:= 0;
	tCtr_ChC_T1HP_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_ChC_T1HP_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_ChC_T1HP_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_ChC_T1HP_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_ChC_T1HP_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_ChC_T1HP_In.Y_man_Active;				
	tCtr_ChC_T1HP_In.Y_man;					
	tCtr_ChC_T1HP_In.X_min; 					
	tCtr_ChC_T1HP_In.X_max;			
	tCtr_ChC_T1HP_In.Tune_quality;
	tCtr_ChC_T1HP_In.Tune_PI;		
	tCtr_ChC_T1HP_In.Tune_PID;		
	tCtr_ChC_T1HP_In.Tune_start;
	tCtr_ChC_T1HP_In.Tune_stop;
	tCtr_ChC_T1HP_In.Tune_takeover;
	
	xCtr_ChC_T1HP();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_HC.tCtr_ChC2_Valve_Set.Ao	:= tCtr_ChC_T1HP_Out.Y;			(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_ChC_T1HP_Out	:= tCtr_ChC_T1HP_Out;
	MM2VIS.rPos_ChC2_Valve		:= IN_HC.tPos_ChC2_Valve.Ai;
	VIS2MM.tCtr_ChC_T1HP_In		:= tCtr_ChC_T1HP_In;				(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_ChC_T1HP_Out.Active;
	tCtr_ChC_T1HP_Out.Y;		
	tCtr_ChC_T1HP_Out.W;		
	tCtr_ChC_T1HP_Out.e;		
	tCtr_ChC_T1HP_Out.Kp_tune;	
	tCtr_ChC_T1HP_Out.Tn_tune;	
	tCtr_ChC_T1HP_Out.Tv_tune;	
	tCtr_ChC_T1HP_Out.status;

END_PROGRAM
