(*******************************************************************************
Ctr_OutlLou_RDP		controller for outlet louver(s) to guarantee a constant engine room differential pressure

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.03.0		24.09.2015		Stary		created 
            19.11.2015      Stary       bugfix: line 71
												modified logic FOR the CASE "fire-alarm"
												line 75
												tCtr_OutlLou_RDP_In.Y_set_Active was never resetted
			04.12.2015		Stary		bugfix: line104,105
                                        		writing MM2VIS now with IN_VE.tPos_OutlLou1.Ai & IN_VE.tPos_OutlLou2.Ai
V4.04.0		06.10.2016		Stary       line76: shortened the ELSIF logic cause bMsg1052+bMsg1053+bMsg2705 NOT needed here
V4.04.0		17.10.2016  	Stary       added RTM40 in ctr-release AND external-Y-logic FOR opening louvers at engine standstill TO run ventilation with minimum-speed, bugfix
			15.02.2017	    Stary		external Y: gasalarm prio before RTM40, bugfix
V4.07.0		04.03.2019		lettenb.	IN_VE.bMsg2705 -> OUT_VE.bMsg2705, mapping cleanup 		
V4.11.0		28.01.2022		Perktold	included plant controller upgrade
V4.25.0		26.11.2025	Bacci		Safety Function - Insufficient Ventilation (2024-202): safety plausibility check added

Specification       : PID-controller for outlet louver(s) to ensure a constant room temperature
		
Instructions for use: Modify release/X/external Y customized when needed
                      

Outstandings:
------------	
(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameter *)
	
	Para.tCtr_OutlLou_RDP.W_set;	
	Para.tCtr_OutlLou_RDP.W_set2;	
	Para.tCtr_OutlLou_RDP.W_min;
	Para.tCtr_OutlLou_RDP.W_max;
	Para.tCtr_OutlLou_RDP.dW_up;
	Para.tCtr_OutlLou_RDP.dW_down;
	Para.tCtr_OutlLou_RDP.deadband;
	Para.tCtr_OutlLou_RDP.Y_min;
	Para.tCtr_OutlLou_RDP.Y_max;
	Para.tCtr_OutlLou_RDP.dY_max;
	Para.tCtr_OutlLou_RDP.Y_block;
	Para.tCtr_OutlLou_RDP.invert;
	Para.tCtr_OutlLou_RDP.Kp;
	Para.tCtr_OutlLou_RDP.Tn;
	Para.tCtr_OutlLou_RDP.Tv;
	Para.tCtr_OutlLou_RDP.Kp_GainScheduling;
	Para.tCtr_OutlLou_RDP.Tn_GainScheduling;
	Para.tCtr_OutlLou_RDP.Tv_GainScheduling;
	Para.tCtr_OutlLou_RDP.t_min_pulse_down;
	Para.tCtr_OutlLou_RDP.t_min_pulse_up;
	Para.tCtr_OutlLou_RDP.t_period_down;
	Para.tCtr_OutlLou_RDP.t_period_up;

	
	(* Input variables *)
	tCtr_OutlLou_RDP_In				:= VIS2MM.tCtr_OutlLou_RDP_In;

	(* Input from module *)
	tCtr_OutlLou_RDP_In.enable		:=	IN_VE.tPB2MM.bParaSetupOk		(* enable controller *)
									AND		Para.bCtr_OutlLou_RDP
									AND     IN_VE.bEng_Aux_Dem_CDR
									AND NOT IN_VE.bMsg1052				(* gas pre-alarm *)
									AND NOT IN_VE.bMsg1053      		(* gas alarm *)
									AND NOT IN_VE.bMsg1054      		(* fire alarm *)
									AND NOT OUT_VE.bMsg2705    			(* measuring signal failure room differential pressure *)
									AND NOT RTM40						(* temperature-limit at engine standstill to run ventilation with minimum-speed *)
									AND NOT bERV_SafeCheck_CloseLou		(* safety plausibility check close louvers*)
									AND NOT bERV_SafeCheck_OpenLou;		(* safety plausibility check open louvers*)

	
	tCtr_OutlLou_RDP_In.X			:= IN_VE.tPrDiff_ER.Ai;	
	
	IF IN_VE.bMsg1052 OR IN_VE.bMsg1053 OR (OUT_VE.bMsg2705 AND NOT bERV_SafeCheck_CloseLou) THEN	(* external Y --> totally open the louver(s) at gas-pre-alarm/gas-alarm *)
		tCtr_OutlLou_RDP_In.Y_set_Active := TRUE;
		tCtr_OutlLou_RDP_In.Y_set := 1.0; 
	ELSIF IN_VE.bMsg1054 THEN									(* external Y --> totally close the louver(s) at fire-alarm *)
		tCtr_OutlLou_RDP_In.Y_set_Active := TRUE;
		tCtr_OutlLou_RDP_In.Y_set := 0.0;
	ELSIF bERV_SafeCheck_CloseLou THEN   						
		tCtr_InlLou_In.Y_set_Active := TRUE;
		tCtr_InlLou_In.Y_set := 0.0;
	ELSIF RTM40 OR bERV_SafeCheck_OpenLou THEN
		tCtr_OutlLou_RDP_In.Y_set_Active := TRUE;
		tCtr_OutlLou_RDP_In.Y_set := 1.0;	
	ELSE
		tCtr_OutlLou_RDP_In.Y_set_Active := FALSE;
	END_IF;
	tCtr_OutlLou_RDP_In.W_set2_Active	:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_OutlLou_RDP_In.GainScheduling	:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_OutlLou_RDP_In.Y_min_cust		:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_OutlLou_RDP_In.Y_max_cust		:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_OutlLou_RDP_In.Retrigger		:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
	tCtr_OutlLou_RDP_In.A;								(*optional: feed forward Input*)


	(* Input from Visualization via OPC *)
	tCtr_OutlLou_RDP_In.Y_man_Active;				
	tCtr_OutlLou_RDP_In.Y_man;					
	tCtr_OutlLou_RDP_In.X_min; 					
	tCtr_OutlLou_RDP_In.X_max; 					
	tCtr_OutlLou_RDP_In.Tune_quality;			
	tCtr_OutlLou_RDP_In.Tune_PI;					
	tCtr_OutlLou_RDP_In.Tune_PID;					
	tCtr_OutlLou_RDP_In.Tune_start;				
	tCtr_OutlLou_RDP_In.Tune_stop;				
	tCtr_OutlLou_RDP_In.Tune_takeover;		
	
	xCtr_OutlLou_RDP();

	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_VE.tCtr_OutlLou_RDP_Set.Ao	:= tCtr_OutlLou_RDP_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_OutlLou_RDP_Out	:= tCtr_OutlLou_RDP_Out;
	MM2VIS.rPos_OutlLou1        := IN_VE.tPos_OutlLou1.Ai;
	MM2VIS.rPos_OutlLou2        := IN_VE.tPos_OutlLou2.Ai;
	VIS2MM.tCtr_OutlLou_RDP_In	:= tCtr_OutlLou_RDP_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	


	tCtr_OutlLou_RDP_Out.Active;
	tCtr_OutlLou_RDP_Out.Y;		
	tCtr_OutlLou_RDP_Out.W;		
	tCtr_OutlLou_RDP_Out.e;		
	tCtr_OutlLou_RDP_Out.Kp_tune;	
	tCtr_OutlLou_RDP_Out.Tn_tune;	
	tCtr_OutlLou_RDP_Out.Tv_tune;	
	tCtr_OutlLou_RDP_Out.status;
	tCtr_OutlLou_RDP_Out.Step_down;
	tCtr_OutlLou_RDP_Out.Step_up;

END_PROGRAM
