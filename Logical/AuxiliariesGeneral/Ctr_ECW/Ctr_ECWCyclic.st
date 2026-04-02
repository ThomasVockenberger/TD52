(*******************************************************************************
Ctr_ECW		controller engine cooling water temperature	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V3.90.0		01.10.2012	lettenb.	new for series 9 
			23.11.2012	lettenb.	write back to IN_struct added (zengerer)	
V4.00.0		15.12.2014				work around(920 stapelfeld)
V4.03.0     11.01.2016              temporarily para set after controller start added
V4.03.1		03.10.2016  Fahringer	modified controller and ramp start(GeACtr with AntiWindUp)
									canceled 3 min. Tv after controller start
V4.04.0		23.03.2017	lettenb.	init restored for GeACtr with AntiWindUp
V4.05.0 	20.09.2017	Messner		Active Cooling Program added
V4.07.0		04.04.2019	Fahringer	restart the controller to initiate the setpoint ramp
			20.05.2019	Schmid		bCtrDisable was missing in tCtr_ECW_In.enable
V4.11.0		28.01.2022	Perktold	included plant controller upgrade
V4.12.0		14.12.2022	Perktold	retrigger caused by X >= WMin just once per controller activation

Instructions for use:
--------------------

Outstandings:
------------
(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtr_ECW.W_set;	
	Para.tCtr_ECW.W_set2;
	Para.tCtr_ECW.W_min;
	Para.tCtr_ECW.W_max;
	Para.tCtr_ECW.dW_up;
	Para.tCtr_ECW.dW_down;
	Para.tCtr_ECW.deadband;
	Para.tCtr_ECW.Y_min;
	Para.tCtr_ECW.Y_max;
	Para.tCtr_ECW.dY_max;
	Para.tCtr_ECW.Y_block;
	Para.tCtr_ECW.invert;
	Para.tCtr_ECW.Kp;
	Para.tCtr_ECW.Tn;
	Para.tCtr_ECW.Tv;
	Para.tCtr_ECW.Kp_GainScheduling;
	Para.tCtr_ECW.Tn_GainScheduling;
	Para.tCtr_ECW.Tv_GainScheduling;
	Para.tCtr_ECW.t_min_pulse_down;
	Para.tCtr_ECW.t_min_pulse_up;
	Para.tCtr_ECW.t_period_down;
	Para.tCtr_ECW.t_period_up;

	
	(* Input variables *)
	tCtr_ECW_In	 				:= VIS2MM.tCtr_ECW_In;			(* from vis *)

	(* Input from module *)
	tCtr_ECW_In.enable			:=	IN_AG.tPB2MM.bParaSetupOk
								AND	Para.bCtr_ECW 
								AND IN_AG.bEng_Aux_Dem_CDR
								AND bCtr_ECW_Activation;

	(* start controller when actual value X reached the minimum setpoint W_min *)	
	IF tCtr_ECW_In.X >= Para.tCtr_ECW.W_min THEN
		bCtr_ECW_Activation := TRUE;
	ELSE
		bCtr_ECW_Activation := tCtr_ECW_In.enable;
	END_IF;

	(* Active Cooling Program - valve setpoint *)
	IF IN_AG.bEng_Aux_Dem_CDR THEN
		tCtr_ECW_In.Y_set_Active	:= FALSE;	
		tCtr_ECW_In.Y_set			:= 0.0;
	ELSE	
		tCtr_ECW_In.Y_set_Active	:= bACP_Start AND NOT bACP_ECW_Cmp AND OUT_AG.tECWP1Dem.Do;
		tCtr_ECW_In.Y_set			:= 1.0;	
	END_IF;
	
	tCtr_ECW_In.W_ext_Active	:= tCtr_ECW_In.W_ext_Active;	(* from vis *) 
	tCtr_ECW_In.W_ext			:= 0.0;	
	tCtr_ECW_In.X				:= IN_AG.tT_ECW.Ai; 
	tCtr_ECW_In.A				:= 0;
	tCtr_ECW_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_ECW_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_ECW_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_ECW_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)

	(* retrigger controller when Ctrl.X reached the minimum set point W_min and GCB is closed  OR closure of GCB*)
	tCtr_ECW_In.Retrigger	:= (EDGEPOS(tCtr_ECW_In.X >= Para.tCtr_ECW.W_min) AND NOT bBlockRetrigger) OR EDGEPOS(IN_AG.tGCB_On.Di);
	
	(* block retrigger caused be X >= WMin after one execution until controller is disabled again *)
	IF tCtr_ECW_In.Retrigger AND EDGEPOS(tCtr_ECW_In.X >= Para.tCtr_ECW.W_min) THEN
		bBlockRetrigger	:= TRUE;
	ELSIF bBlockRetrigger AND NOT tCtr_ECW_In.enable THEN
		bBlockRetrigger	:= FALSE;
	END_IF;

	(* Input from Visualization via OPC *)
	tCtr_ECW_In.Y_man_Active;				
	tCtr_ECW_In.Y_man;					
	tCtr_ECW_In.X_min; 					
	tCtr_ECW_In.X_max; 					
	tCtr_ECW_In.Tune_quality;			
	tCtr_ECW_In.Tune_PI;					
	tCtr_ECW_In.Tune_PID;					
	tCtr_ECW_In.Tune_start;				
	tCtr_ECW_In.Tune_stop;				
	tCtr_ECW_In.Tune_takeover;		
	
	xCtr_ECW();
	
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_AG.tCtr_ECW_Set.Ao 	:= tCtr_ECW_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_ECW_Out		:= tCtr_ECW_Out;
	VIS2MM.tCtr_ECW_In		:= tCtr_ECW_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_ECW_Out.Active;
	tCtr_ECW_Out.Y;		
	tCtr_ECW_Out.W;		
	tCtr_ECW_Out.e;		
	tCtr_ECW_Out.Kp_tune;	
	tCtr_ECW_Out.Tn_tune;	
	tCtr_ECW_Out.Tv_tune;	
	tCtr_ECW_Out.status;

END_PROGRAM

