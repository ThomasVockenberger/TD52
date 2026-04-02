(*******************************************************************************
Ctr_EOVal		engine oil temperature control		

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V3.90.0	20.03.2012	denk 		Created initial structured text code
V3.99.0	04.04.2013	lettenb.	task renamed, typ/var file removed
		03.05.2013				ctr input var's from vis added
V4.00.0	15.12.2014				work around TCV6 (920 stapelfeld)(ohne abkühlprogramm)
V4.03.0	06.07.2015				tT_EO_Mod_Out.Ai added (920 oil module, tca-redesign)
        11.01.2016              temporarily para set after controller start added
V4.03.1	08.11.2016              temporarily para set after controller start removed(GeACtr with AntiWindUp)
V4.04.0	23.03.2017	lettenb.	init restored for GeACtr with AntiWindUp
V4.05.0 20.09.2017	Messner		Active Cooling Program added
V4.11.0	28.01.2022	Perktold	included plant controller upgrade, retrigger added
V4.12.0	14.12.2022	Perktold	retrigger caused by X >= WMin just once per controller activation

Instructions for use:
--------------------

Outstandings:
------------
(*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter Oil valve controller *)
	Para.tCtr_EOVal.W_set;	
	Para.tCtr_EOVal.W_set2;	
	Para.tCtr_EOVal.W_min;
	Para.tCtr_EOVal.W_max;
	Para.tCtr_EOVal.dW_up;
	Para.tCtr_EOVal.dW_down;
	Para.tCtr_EOVal.deadband;
	Para.tCtr_EOVal.Y_min;
	Para.tCtr_EOVal.Y_max;
	Para.tCtr_EOVal.dY_max;
	Para.tCtr_EOVal.Y_block;
	Para.tCtr_EOVal.invert;
	Para.tCtr_EOVal.Kp;
	Para.tCtr_EOVal.Tn;
	Para.tCtr_EOVal.Tv;
	Para.tCtr_EOVal.Kp_GainScheduling;
	Para.tCtr_EOVal.Tn_GainScheduling;
	Para.tCtr_EOVal.Tv_GainScheduling;
	Para.tCtr_EOVal.t_min_pulse_down;
	Para.tCtr_EOVal.t_min_pulse_up;
	Para.tCtr_EOVal.t_period_down;
	Para.tCtr_EOVal.t_period_up;

	
	(* Input variables *)
	tCtr_EOVal_In	 			:= VIS2MM.tCtr_EOVal_In;			(* from Vis *)

	(* Input from module *)
	tCtr_EOVal_In.enable		:=  IN_AG.tPB2MM.bParaSetupOk
								AND Para.bCtr_EOVal_Active 
								AND(IN_AG.bEng_Aux_Dem_CDR OR M_DREHZ OR bTC_CoolDownRun)
								AND bCtr_EOVal_Activation;

	(* start controller when actual value X reached the minimum setpoint W_min *)	
	IF tCtr_EOVal_In.X >= Para.tCtr_EOVal.W_min THEN
		bCtr_EOVal_Activation := TRUE;
	ELSE
		bCtr_EOVal_Activation := tCtr_EOVal_In.enable;
	END_IF;

	(* Active Cooling Program - valve setpoint *)
	IF IN_AG.bEng_Aux_Dem_CDR THEN
		tCtr_EOVal_In.Y_set_Active	:= FALSE;
		tCtr_EOVal_In.Y_set			:= 0.0;
	ELSE	
		tCtr_EOVal_In.Y_set_Active	:= bACP_Start AND NOT bACP_EO_Cmp AND OUT_AG.tEOP1AC_Dem.Do;	 	
		tCtr_EOVal_In.Y_set			:= 1.0;												
	END_IF;
	
	tCtr_EOVal_In.W_ext_Active	:= tCtr_EOVal_In.W_ext_Active;
	tCtr_EOVal_In.W_ext			:= 0.0;
//	IF IN_AG.tT_EO_Mod_Out.GoodQual THEN tCtr_EOVal_In.X := IN_AG.tT_EO_Mod_Out.Ai; (* oil module *)
//	ELSE                                 tCtr_EOVal_In.X := IN_AG.tT_EO.Ai;         (* engine *)
//	END_IF;
	tCtr_EOVal_In.X 			:= IN_AG.tT_EO.Ai;
	tCtr_EOVal_In.A				:= 0.0;
	tCtr_EOVal_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_EOVal_In.GainScheduling:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_EOVal_In.Y_min_cust	:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_EOVal_In.Y_max_cust	:= 1.0;		(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	
	(* retrigger controller when Ctrl.X reached the minimum set point W_min OR closure of GCB*)
	tCtr_EOVal_In.Retrigger		:= (EDGEPOS(tCtr_EOVal_In.X >= Para.tCtr_EOVal.W_min) AND NOT bBlockRetrigger) OR EDGEPOS(IN_AG.tGCB_On.Di);
	
	(* block retrigger caused be X >= WMin after one execution until controller is disabled again *)
	IF tCtr_EOVal_In.Retrigger AND EDGEPOS(tCtr_EOVal_In.X >= Para.tCtr_EOVal.W_min) THEN
		bBlockRetrigger	:= TRUE;
	ELSIF bBlockRetrigger AND NOT tCtr_EOVal_In.enable THEN
		bBlockRetrigger	:= FALSE;
	END_IF;
	
	(* Input from Visualization via OPC *)
	tCtr_EOVal_In.Y_man_Active;
	tCtr_EOVal_In.Y_man;
	tCtr_EOVal_In.X_min;
	tCtr_EOVal_In.X_max;
	tCtr_EOVal_In.Tune_quality;
	tCtr_EOVal_In.Tune_PI;
	tCtr_EOVal_In.Tune_PID;
	tCtr_EOVal_In.Tune_start;
	tCtr_EOVal_In.Tune_stop;
	tCtr_EOVal_In.Tune_takeover;

	xCtr_EOVal();
	
	
	(* Output variables  Oil valve controller function block *)
	(* Output to module(s) *)
	OUT_AG.tOV_Ctrl_Set.Ao 		:= tCtr_EOVal_Out.Y;	(* analog out *)
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_EOVal_Out		:= tCtr_EOVal_Out;
	VIS2MM.tCtr_EOVal_In		:= tCtr_EOVal_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	

	tCtr_EOVal_Out.Active;
	tCtr_EOVal_Out.Y;		
	tCtr_EOVal_Out.W;		
	tCtr_EOVal_Out.e;		
	tCtr_EOVal_Out.Kp_tune;	
	tCtr_EOVal_Out.Tn_tune;	
	tCtr_EOVal_Out.Tv_tune;	
	tCtr_EOVal_Out.status;
	
END_PROGRAM
