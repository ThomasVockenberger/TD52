(*******************************************************************************
Ctr_InlLou		controller inlet louver(s) to guarantee a constant engine room temperature

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.03.0	03.08.2015	Stary		created 
        19.11.2015  Stary       modified logic for the case "fire-alarm", tCtr_InlLou_In.Y_set_Active, bugfix
		04.12.2015	Stary		writing MM2VIS now with IN_VE.tPos_InlLou1.Ai & IN_VE.tPos_InlLou2.Ai, bugfix
		11.04.2016	stary/lett.	tCtr_InlLou_In.Y_set_Active, tCtr_InlLou_In.Y_set: RTM40 added, bugfix
V4.04.0 17.10.2016  Stary       added RTM40 in ctr-release and external-Y-logic for opening louvers at engine standstill to run ventilation with minimum-speed, bugfix
		26.01.2017	lettenb.	external Y: gasalarm prio before RTM40, bugfix
V4.05.0 20.09.2017	Messner		Active Cooling Program added
V4.11.0	28.01.2022	Perktold	included plant controller upgrade
V4.13.0	05.12.2023	Bacci		Added ventilation demand before starting the ingition selftest and exhaust scavenging
V4.14.0 25.11.2024	Bacci		T6 Start procedure with purge start (2024-219): added ventilation demand before purge cranking cycle during fast start preparation 
V4.25.0 26.11.2025	Bacci		Safety Function - Insufficient Ventilation (2024-202): safety plausibility check added

Specification       : PID-controller to ensure a constant room temperature.
		
Instructions for use: Modify release/X/external Y customized when needed

Outstandings:
------------	
(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameter *)
	
	Para.tCtr_InlLou.W_set;	
	Para.tCtr_InlLou.W_set2;	
	Para.tCtr_InlLou.W_min;
	Para.tCtr_InlLou.W_max;
	Para.tCtr_InlLou.dW_up;
	Para.tCtr_InlLou.dW_down;
	Para.tCtr_InlLou.deadband;
	Para.tCtr_InlLou.Y_min;
	Para.tCtr_InlLou.Y_max;
	Para.tCtr_InlLou.dY_max;
	Para.tCtr_InlLou.Y_block;
	Para.tCtr_InlLou.invert;
	Para.tCtr_InlLou.Kp;
	Para.tCtr_InlLou.Tn;
	Para.tCtr_InlLou.Tv;
	Para.tCtr_InlLou.Kp_GainScheduling;
	Para.tCtr_InlLou.Tn_GainScheduling;
	Para.tCtr_InlLou.Tv_GainScheduling;
	Para.tCtr_InlLou.t_min_pulse_down;
	Para.tCtr_InlLou.t_min_pulse_up;
	Para.tCtr_InlLou.t_period_down;
	Para.tCtr_InlLou.t_period_up;

	
	(* Input variables *)
	tCtr_InlLou_In 				:=	VIS2MM.tCtr_InlLou_In;

	(* Input from module *)
	tCtr_InlLou_In.enable		:=	IN_VE.tPB2MM.bParaSetupOk	(* enable controller *)
							AND		Para.bCtr_InlLou
							AND		(IN_VE.bEng_Aux_Dem_CDR OR IN_VE.bACP_AirER_Dem)
							AND NOT IN_VE.bMsg1052				(* gas pre-alarm *)
							AND NOT IN_VE.bMsg1053      		(* gas alarm *)
							AND NOT IN_VE.bMsg1054      		(* fire alarm *)
							AND NOT MS_LUE    					(* measuring signal failure room temperature --> W3152 *)
							AND NOT RTM40						(* temperature-limit at engine standstill to run ventilation with minimum-speed *)
							AND NOT IN_VE.bInLouDemIgn 			(* ignition self test *)
							AND NOT IN_VE.bInLouDemEX			(* exhaust scavenging *)
							AND NOT IN_VE.bInLouDemAG			(* purge cycle during fast start preparation *)
							AND NOT bERV_SafeCheck_CloseLou		(* safety plausibility check close louvers*)
							AND NOT bERV_SafeCheck_OpenLou;		(* safety plausibility check open louvers*)
	
	tCtr_InlLou_In.X            :=  rT_AirER;                   (* select X *)		
	
	IF IN_VE.bMsg1052 OR IN_VE.bMsg1053 THEN 					(* external Y at gas pre-alarm/gas alarm/measuring signal failure room temperature *)
		tCtr_InlLou_In.Y_set_Active := TRUE;
		tCtr_InlLou_In.Y_set := 1.0;	
	ELSIF IN_VE.bMsg1054 THEN   								(* external Y at fire alarm *)
		tCtr_InlLou_In.Y_set_Active := TRUE;
		tCtr_InlLou_In.Y_set := 0.0;
	ELSIF bERV_SafeCheck_CloseLou THEN   						
		tCtr_InlLou_In.Y_set_Active := TRUE;
		tCtr_InlLou_In.Y_set := 0.0;
	ELSIF MS_LUE OR RTM40 OR IN_VE.bInLouDemIgn OR IN_VE.bInLouDemEX OR IN_VE.bInLouDemAG OR bERV_SafeCheck_OpenLou THEN
		tCtr_InlLou_In.Y_set_Active := TRUE;
		tCtr_InlLou_In.Y_set := 1.0;
	ELSE
		tCtr_InlLou_In.Y_set_Active := FALSE;
	END_IF;	
	
	IF IN_VE.bACP_AirER_Dem THEN
		tCtr_InlLou_In.W_ext_Active	:= TRUE;
		tCtr_InlLou_In.W_ext		:= Para.rT_ACP_AirER_sp;
	ELSE
		tCtr_InlLou_In.W_ext_Active	:= FALSE;		
	END_IF;
	tCtr_InlLou_In.W_set2_Active	:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_InlLou_In.GainScheduling	:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_InlLou_In.Y_min_cust		:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_InlLou_In.Y_max_cust		:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_InlLou_In.Retrigger		:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
	tCtr_InlLou_In.A;								(*optional: feed forward Input*)
	
	(* Input from Visualization via OPC *)
	tCtr_InlLou_In.Y_man_Active;				
	tCtr_InlLou_In.Y_man;					
	tCtr_InlLou_In.X_min; 					
	tCtr_InlLou_In.X_max; 					
	tCtr_InlLou_In.Tune_quality;			
	tCtr_InlLou_In.Tune_PI;					
	tCtr_InlLou_In.Tune_PID;					
	tCtr_InlLou_In.Tune_start;				
	tCtr_InlLou_In.Tune_stop;				
	tCtr_InlLou_In.Tune_takeover;		
	
	xCtr_InlLou();

	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_VE.tCtr_InlLou_Set.Ao	:= tCtr_InlLou_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_InlLou_Out		:= tCtr_InlLou_Out;	
	MM2VIS.rPos_InlLou1         := IN_VE.tPos_InlLou1.Ai;
	MM2VIS.rPos_InlLou2			:= IN_VE.tPos_InlLou2.Ai;
	VIS2MM.tCtr_InlLou_In		:= tCtr_InlLou_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	


	tCtr_InlLou_Out.Active;
	tCtr_InlLou_Out.Y;		
	tCtr_InlLou_Out.W;		
	tCtr_InlLou_Out.e;		
	tCtr_InlLou_Out.Kp_tune;	
	tCtr_InlLou_Out.Tn_tune;	
	tCtr_InlLou_Out.Tv_tune;	
	tCtr_InlLou_Out.status;
	tCtr_InlLou_Out.Step_down;
	tCtr_InlLou_Out.Step_up;

END_PROGRAM
