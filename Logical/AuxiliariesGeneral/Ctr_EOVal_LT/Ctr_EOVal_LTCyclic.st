(*******************************************************************************
Ctr_EOVal_LT		engine oil temperature control LT circuit		

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V3.90.0	20.03.2012	denk 		Created initial structured text code
V3.99.0	04.04.2013	lettenb.	task renamed, typ/var file removed
		03.05.2013				ctr input var's from vis added
V4.00.0	15.12.2014				work around TCV1 (920 stapelfeld)(ohne abkühlprogramm)
V4.03.0	06.07.2015				tT_EO_Mod_Out.Ai added (920 ECW-modul)
		14.03.2016				tCtr_EOVal_In.X -> tCtr_EOVal_LT_In.X, bugfix
V4.04.0	23.03.2017	lettenb.	tCtr_EOVal_LT_In.X according Ctr_EOVal
V4.11.0	28.01.2022	Perktold	included plant controller upgrade

(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter Oil valve controller *)
	Para.tCtr_EOVal_LT.W_set;	
	Para.tCtr_EOVal_LT.W_set2;	
	Para.tCtr_EOVal_LT.W_min;
	Para.tCtr_EOVal_LT.W_max;
	Para.tCtr_EOVal_LT.dW_up;
	Para.tCtr_EOVal_LT.dW_down;
	Para.tCtr_EOVal_LT.deadband;
	Para.tCtr_EOVal_LT.Y_min;
	Para.tCtr_EOVal_LT.Y_max;
	Para.tCtr_EOVal_LT.dY_max;
	Para.tCtr_EOVal_LT.Y_block;
	Para.tCtr_EOVal_LT.invert;
	Para.tCtr_EOVal_LT.Kp;
	Para.tCtr_EOVal_LT.Tn;
	Para.tCtr_EOVal_LT.Tv;
	Para.tCtr_EOVal_LT.Kp_GainScheduling;
	Para.tCtr_EOVal_LT.Tn_GainScheduling;
	Para.tCtr_EOVal_LT.Tv_GainScheduling;
	Para.tCtr_EOVal_LT.t_min_pulse_down;
	Para.tCtr_EOVal_LT.t_min_pulse_up;
	Para.tCtr_EOVal_LT.t_period_down;
	Para.tCtr_EOVal_LT.t_period_up;

	
	(* Input variables *)
	tCtr_EOVal_LT_In	 			:= VIS2MM.tCtr_EOVal_LT_In;			(* from Vis *)

	(* Input from module *)
	tCtr_EOVal_LT_In.enable		:=  IN_AG.tPB2MM.bParaSetupOk
								AND Para.bCtr_EOVal_LT_Active 
								AND(IN_AG.bEng_Aux_Dem_CDR OR bPreLubeDem OR bTC_CoolDownRun);
	tCtr_EOVal_LT_In.W_ext_Active	:= tCtr_EOVal_LT_In.W_ext_Active;
	tCtr_EOVal_LT_In.W_ext			:= 50.0;	
	tCtr_EOVal_LT_In.Y_set_Active	:= OUT_AG.bMsg2102;	 
	tCtr_EOVal_LT_In.Y_set 			:= 0.5;
//	IF IN_AG.tT_EO_Mod_Out.GoodQual THEN tCtr_EOVal_LT_In.X := IN_AG.tT_EO_Mod_Out.Ai; (* 920 ECW-module *)
//	ELSE                                 tCtr_EOVal_LT_In.X := IN_AG.tT_EO.Ai; 
//	END_IF;
	tCtr_EOVal_LT_In.X 				:= IN_AG.tT_EO.Ai;
	tCtr_EOVal_LT_In.A				:= 0.0;
	tCtr_EOVal_LT_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_EOVal_LT_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_EOVal_LT_In.Y_min_cust		:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_EOVal_LT_In.Y_max_cust		:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_EOVal_LT_In.Retrigger		:= FALSE;	(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_EOVal_LT_In.Y_man_Active;
	tCtr_EOVal_LT_In.Y_man;
	tCtr_EOVal_LT_In.X_min;
	tCtr_EOVal_LT_In.X_max;
	tCtr_EOVal_LT_In.Tune_quality;
	tCtr_EOVal_LT_In.Tune_PI;
	tCtr_EOVal_LT_In.Tune_PID;
	tCtr_EOVal_LT_In.Tune_start;
	tCtr_EOVal_LT_In.Tune_stop;
	tCtr_EOVal_LT_In.Tune_takeover;
	
	xCtr_EOVal_LT();
	
	
	(* Output variables  Oil valve controller function block *)
	(* Output to module(s) *)
	OUT_AG.tEOVal_LT_Set.Ao 	:= tCtr_EOVal_LT_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_EOVal_LT_Out	:= tCtr_EOVal_LT_Out;
	VIS2MM.tCtr_EOVal_LT_In		:= tCtr_EOVal_LT_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_EOVal_LT_Out.Active;
	tCtr_EOVal_LT_Out.Y;		
	tCtr_EOVal_LT_Out.W;		
	tCtr_EOVal_LT_Out.e;		
	tCtr_EOVal_LT_Out.Kp_tune;	
	tCtr_EOVal_LT_Out.Tn_tune;	
	tCtr_EOVal_LT_Out.Tv_tune;	
	tCtr_EOVal_LT_Out.status;
	
END_PROGRAM
