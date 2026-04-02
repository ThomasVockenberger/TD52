(*******************************************************************************
Ctr_ChC		charge temperature (cooler)	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0		17.04.2012	lettenb.	created 
V3.99.0		23.11.2012	lettenb.	write back to IN_struct added (zengerer)	
V4.00.0		15.12.2014	lettenb.	controller interfaces completed like standard
V4.03.0     05.08.2015  Stary		added actual position feedback for regulator valve
V4.04.0		16.01.2017	lettenb.	demand CHC with bN_EngStart(request service eder andreas)
			11.05.2017	lettenb.	freeze ctr in case of bAMM_T_Ch_T2s_Avg(MS), SWAT920/2
V4.05.00.00	25.10.2017	Zengerer	rT_ChC_Ctr_Wex_Cust add V4.5 new interface
V4.05.01.00 25.03.2019	Fahringer	restart the controller to initiate the setpoint ramp 
V4.11.00.00	28.01.2022	Perktold	included plant controller upgrade
V4.12.00.00	14.12.2022	Perktold	retrigger caused by X >= WMin just once per controller activation

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_ChC.W_set;	
	Para.tCtr_ChC.W_set2;	
	Para.tCtr_ChC.W_min;
	Para.tCtr_ChC.W_max;
	Para.tCtr_ChC.dW_up;
	Para.tCtr_ChC.dW_down;
	Para.tCtr_ChC.deadband;
	Para.tCtr_ChC.Y_min;
	Para.tCtr_ChC.Y_max;
	Para.tCtr_ChC.dY_max;
	Para.tCtr_ChC.Y_block;
	Para.tCtr_ChC.invert;
	Para.tCtr_ChC.Kp;
	Para.tCtr_ChC.Tn;
	Para.tCtr_ChC.Tv;
	Para.tCtr_ChC.Kp_GainScheduling;
	Para.tCtr_ChC.Tn_GainScheduling;
	Para.tCtr_ChC.Tv_GainScheduling;
	Para.tCtr_ChC.t_min_pulse_down;
	Para.tCtr_ChC.t_min_pulse_up;
	Para.tCtr_ChC.t_period_down;
	Para.tCtr_ChC.t_period_up;
	
	(* Input variables *)
	tCtr_ChC_In					:= VIS2MM.tCtr_ChC_In;		(* from vis *)	
	

	(* Input from module *)
	tCtr_ChC_In.enable			:=	Para.bCtr_ChC
								AND	IN_HC.tPB2MM.bParaSetupOk
								AND IN_HC.bEng_Aux_Dem_CDR
								AND(bN_EngStart OR tCtr_ChC_In.enable);
	
	tCtr_ChC_In.W_ext_Active	:= VIS2MM.tCtr_ChC_In.W_ext_Active OR TRUE;

	IF IN_HC.bT_ChC_Ctr_Wex_Enable_Cust THEN							(*new V4.5*)
		tCtr_ChC_In.W_ext			:= IN_HC.rT_ChC_Ctr_Wex_Cust;	
	ELSE
		tCtr_ChC_In.W_ext			:= IN_HC.rT_ChC_Ctr_Wex;	
	END_IF
	
	tCtr_ChC_In.Y_set_Active	:= IN_HC.bAMM_T_Ch_T2s_Avg;//FALSE;	  freeze SWAT920/2
	tCtr_ChC_In.Y_set			:= 0.5;//0.0;	         			  freeze SWAT920/2
	tCtr_ChC_In.X				:= IN_HC.rT_Ch_T2s_Avg; 
	tCtr_ChC_In.A				:= 0;
	tCtr_ChC_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_ChC_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_ChC_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_ChC_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
		
	(* retrigger controller when Ctrl.X reached the minimum set point W_min and GCB is closed  OR closure of GCB*)
	tCtr_ChC_In.Retrigger := (EDGEPOS(tCtr_ChC_In.X >= Para.tCtr_ChC.W_min) AND NOT bBlockRetrigger) OR EDGEPOS(IN_HC.tGCB_On.Di);
	
	(* block retrigger caused be X >= WMin after one execution until controller is disabled again *)
	IF tCtr_ChC_In.Retrigger AND EDGEPOS(tCtr_ChC_In.X >= Para.tCtr_ChC.W_min) THEN
		bBlockRetrigger	:= TRUE;
	ELSIF bBlockRetrigger AND NOT tCtr_ChC_In.enable THEN
		bBlockRetrigger	:= FALSE;
	END_IF;			
	(* Input from Visualization via OPC *)
	tCtr_ChC_In.Y_man_Active;				
	tCtr_ChC_In.Y_man;					
	tCtr_ChC_In.X_min; 					
	tCtr_ChC_In.X_max;			
	tCtr_ChC_In.Tune_quality;
	tCtr_ChC_In.Tune_PI;		
	tCtr_ChC_In.Tune_PID;		
	tCtr_ChC_In.Tune_start;
	tCtr_ChC_In.Tune_stop;
	tCtr_ChC_In.Tune_takeover;
	
	xCtr_ChC();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_HC.tCtr_ChC_Set.Ao 		:= tCtr_ChC_Out.Y;			(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_ChC_Out			:= tCtr_ChC_Out;
	MM2VIS.rPos_ChC_Valve     	:= IN_HC.tPos_ChC_Valve.Ai;
	VIS2MM.tCtr_ChC_In			:= tCtr_ChC_In;				(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_ChC_Out.Active;
	tCtr_ChC_Out.Y;		
	tCtr_ChC_Out.W;		
	tCtr_ChC_Out.e;		
	tCtr_ChC_Out.Kp_tune;	
	tCtr_ChC_Out.Tn_tune;	
	tCtr_ChC_Out.Tv_tune;	
	tCtr_ChC_Out.status;

END_PROGRAM
