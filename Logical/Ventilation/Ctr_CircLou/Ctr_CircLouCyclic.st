(*******************************************************************************
Ctr_CircLou		controller for circulation louver(s) to guarantee a constant engine intake air temperature

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.03.0		03.08.2015		Stary		created
			04.12.2015		Stary		bugfix: line92,93
                                        		writing MM2VIS now with IN_VE.tPos_CircLou1.Ai & IN_VE.tPos_CircLou2.Ai
V4.11.0		28.01.2022		Perktold	included plant controller upgrade
						
Specification       : PID-controller to ensure a constant engine intake air temperature
		
Instructions for use: Modify release/X/external Y customized when needed

Outstandings:
------------	
(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameter *)
	
	Para.tCtr_CircLou.W_set;	
	Para.tCtr_CircLou.W_set2;	
	Para.tCtr_CircLou.W_min;
	Para.tCtr_CircLou.W_max;
	Para.tCtr_CircLou.dW_up;
	Para.tCtr_CircLou.dW_down;
	Para.tCtr_CircLou.deadband;
	Para.tCtr_CircLou.Y_min;
	Para.tCtr_CircLou.Y_max;
	Para.tCtr_CircLou.dY_max;
	Para.tCtr_CircLou.Y_block;
	Para.tCtr_CircLou.invert;
	Para.tCtr_CircLou.Kp;
	Para.tCtr_CircLou.Tn;
	Para.tCtr_CircLou.Tv;
	Para.tCtr_CircLou.Kp_GainScheduling;
	Para.tCtr_CircLou.Tn_GainScheduling;
	Para.tCtr_CircLou.Tv_GainScheduling;
	Para.tCtr_CircLou.t_min_pulse_down;
	Para.tCtr_CircLou.t_min_pulse_up;
	Para.tCtr_CircLou.t_period_down;
	Para.tCtr_CircLou.t_period_up;

	
	(* Input variables *)
	tCtr_CircLou_In 				:= VIS2MM.tCtr_CircLou_In;

	(* Input from module *)
	
	xGR_MINR_CircLou(In := IN_VE.rT_Ch_T1LP_Avg, Gw := Para.rT_InAirER_Rel_CircOp, Hy := Para.rT_InAirER_Rel_CircOp_Hy);	(* release of circulation operation regarding engine air intake temp. *) 
    bRel_CircOp := xGR_MINR_CircLou.Q;
		
	tCtr_CircLou_In.enable		:=	IN_VE.tPB2MM.bParaSetupOk		(* enable controller *)
										AND		Para.bCtr_CircLou
										AND     bRel_CircOp
										AND NOT IN_VE.bMsg1052		(* gas pre-alarm *)
										AND NOT IN_VE.bMsg1053      (* gas alarm *)
										AND NOT IN_VE.bMsg1054;     (* fire alarm *)
		
	tCtr_CircLou_In.X            :=  IN_VE.rT_Ch_T1LP_Avg;          (* select X *)		
	
	tCtr_CircLou_In.Y_set_Active := IN_VE.bMsg1052 OR IN_VE.bMsg1053 OR IN_VE.bMsg1054 OR NOT bRel_CircOp;	(* external Y at gas pre-alarm/gas alarm/fire-alarm/no release circ. OP *)
	tCtr_CircLou_In.Y_set 			:= 0.0;			   				
	tCtr_CircLou_In.W_set2_Active	:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_CircLou_In.GainScheduling	:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_CircLou_In.Y_min_cust		:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_CircLou_In.Y_max_cust		:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_CircLou_In.Retrigger		:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
	tCtr_CircLou_In.A;								(*optional: feed forward Input*)
		
	(* Input from Visualization via OPC *)
	tCtr_CircLou_In.Y_man_Active;				
	tCtr_CircLou_In.Y_man;					
	tCtr_CircLou_In.X_min; 					
	tCtr_CircLou_In.X_max; 					
	tCtr_CircLou_In.Tune_quality;			
	tCtr_CircLou_In.Tune_PI;					
	tCtr_CircLou_In.Tune_PID;					
	tCtr_CircLou_In.Tune_start;				
	tCtr_CircLou_In.Tune_stop;				
	tCtr_CircLou_In.Tune_takeover;		
	
	xCtr_CircLou();

	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_VE.tCtr_CircLou_Set.Ao	:= tCtr_CircLou_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_CircLou_Out		:= tCtr_CircLou_Out;
	MM2VIS.rPos_CircLou1            := IN_VE.tPos_CircLou1.Ai;
	MM2VIS.rPos_CircLou2		:= IN_VE.tPos_CircLou2.Ai;
	VIS2MM.tCtr_CircLou_In		:= tCtr_CircLou_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	


	tCtr_CircLou_Out.Active;
	tCtr_CircLou_Out.Y;		
	tCtr_CircLou_Out.W;		
	tCtr_CircLou_Out.e;		
	tCtr_CircLou_Out.Kp_tune;	
	tCtr_CircLou_Out.Tn_tune;	
	tCtr_CircLou_Out.Tv_tune;	
	tCtr_CircLou_Out.status;
	tCtr_CircLou_Out.Step_down;
	tCtr_CircLou_Out.Step_up;

END_PROGRAM
