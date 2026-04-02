(*******************************************************************************
Ctr_HWRe		heat water return temperature 	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0		17.04.2012  lettenbichler	Created 
V3.99.0		23.11.2012	lettenbichler	write back to IN_struct added (zengerer)	
V4.00.0		15.12.2014	lettenb.		controller interfaces completed like standard
V4.03.0     05.08.2015  Stary			added actual position feedback for regulator valve
V4.04.0		28.09.2016	lettenb.		tCtr_HWRe_In.X writing depending on parameter (kluckner)
V4.04.1		03.04.2019	Fahringer		restart the controller to initiate the setpoint ramp
V4.11.0		28.01.2022	Perktold		included plant controller upgrade
V4.12.0		14.12.2022	Perktold		retrigger caused by X >= WMin just once per controller activation

Instructions for use:
--------------------

Outstandings:
------------		
(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameter *)
	Para.tCtr_HWRe.W_set;	
	Para.tCtr_HWRe.W_set2;	
	Para.tCtr_HWRe.W_min;
	Para.tCtr_HWRe.W_max;
	Para.tCtr_HWRe.dW_up;
	Para.tCtr_HWRe.dW_down;
	Para.tCtr_HWRe.deadband;
	Para.tCtr_HWRe.Y_min;
	Para.tCtr_HWRe.Y_max;
	Para.tCtr_HWRe.dY_max;
	Para.tCtr_HWRe.Y_block;
	Para.tCtr_HWRe.invert;
	Para.tCtr_HWRe.Kp;
	Para.tCtr_HWRe.Tn;
	Para.tCtr_HWRe.Tv;
//	Para.tCtr_HWRe.Kp_manualAdjust;
//	Para.tCtr_HWRe.Tn_manualAdjust;
//	Para.tCtr_HWRe.Tv_manualAdjust;
	Para.tCtr_HWRe.t_min_pulse_down;
	Para.tCtr_HWRe.t_min_pulse_up;
	Para.tCtr_HWRe.t_period_down;
	Para.tCtr_HWRe.t_period_up;

	
	(* Input variables *)
	tCtr_HWRe_In				:= VIS2MM.tCtr_HWRe_In;			(* from vis *)	

	(* Input from module *)
	tCtr_HWRe_In.enable			:=	Para.bCtr_HWRe 
								AND IN_HC.tPB2MM.bParaSetupOk
								AND IN_HC.bEng_Aux_Dem_CDR;
	
	tCtr_HWRe_In.W_ext_Active	:= tCtr_HWRe_In.W_ext_Active;	(* from vis *) 
	tCtr_HWRe_In.W_ext			:= 0.0;	
	tCtr_HWRe_In.Y_set_Active	:= FALSE;	 
	tCtr_HWRe_In.Y_set			:= 0.0;
	IF Para.bT_HW_Re_Active THEN tCtr_HWRe_In.X	:= IN_HC.tT_HW_Re.Ai;
	ELSE						 tCtr_HWRe_In.X	:= IN_HC.tT_HW_ReBeEng.Ai;
	END_IF;
	tCtr_HWRe_In.A				:= 0;
	tCtr_HWRe_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_HWRe_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_HWRe_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_HWRe_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	
	(* retrigger controller when Ctrl.X reached the minimum set point W_min and GCB is closed  OR closure of GCB*)
	tCtr_HWRe_In.Retrigger := (EDGEPOS(tCtr_HWRe_In.X >= Para.tCtr_HWRe.W_min) AND NOT bBlockRetrigger) OR EDGEPOS(IN_HC.tGCB_On.Di);
	
	(* block retrigger caused be X >= WMin after one execution until controller is disabled again *)
	IF tCtr_HWRe_In.Retrigger AND EDGEPOS(tCtr_HWRe_In.X >= Para.tCtr_HWRe.W_min) THEN
		bBlockRetrigger	:= TRUE;
	ELSIF bBlockRetrigger AND NOT tCtr_HWRe_In.enable THEN
		bBlockRetrigger	:= FALSE;
	END_IF;
	
	(* Input from Visualization via OPC *)
	tCtr_HWRe_In.Y_man_Active;				
	tCtr_HWRe_In.Y_man;					
	tCtr_HWRe_In.X_min; 					
	tCtr_HWRe_In.X_max; 					
	tCtr_HWRe_In.Tune_quality;			
	tCtr_HWRe_In.Tune_PI;					
	tCtr_HWRe_In.Tune_PID;					
	tCtr_HWRe_In.Tune_start;				
	tCtr_HWRe_In.Tune_stop;				
	tCtr_HWRe_In.Tune_takeover;		
	
	xCtr_HWRe();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_HC.tCtr_HWRe_Set.Ao 	:= tCtr_HWRe_Out.Y;		(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_HWRe_Out		:= tCtr_HWRe_Out;
	MM2VIS.rPos_HW_ReValve      := IN_HC.tPos_HW_ReValve.Ai;
	VIS2MM.tCtr_HWRe_In			:= tCtr_HWRe_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_HWRe_Out.Active;
	tCtr_HWRe_Out.Y;		
	tCtr_HWRe_Out.W;		
	tCtr_HWRe_Out.e;		
	tCtr_HWRe_Out.Kp_tune;	
	tCtr_HWRe_Out.Tn_tune;	
	tCtr_HWRe_Out.Tv_tune;	
	tCtr_HWRe_Out.status;

END_PROGRAM
