(********************************************************************
Ctr_GenPF	 			 Generator cosphi controller 

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022


Customized modifications: -
------------------------
 
History:
-------
4.00.00	01.01.2013	ganguly		new
4.00.01	16.05.2014	lettenb.	controller release-bugfix, cleanup
4.00.02	21.05.2014	lettenb.	controller y.set, bugfix
		04.06.2014				controller .Y_set_Active IF gridcode is active, bugfix	
4.00.03 28.01.2015 	lettenb.	task renamed: Ctr_Gen_13 -> Ctr_GenPF
V4.09.0	03.02.2020	lettenb.	autotune enabled, bugfix
V4.11.0	28.01.2022	Perktold	included plant controller upgrade

Instructions for use: - 
--------------------
			
Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC
	
IF Para.bCtrGenPF_Active THEN

	(* Parameter Generator controller 13 *)
	Para.tCtrGenPF.W_set;
	Para.tCtrGenPF.W_set2;
	Para.tCtrGenPF.W_min;
	Para.tCtrGenPF.W_max;
	Para.tCtrGenPF.dW_up;
	Para.tCtrGenPF.dW_down;
	Para.tCtrGenPF.deadband;
	Para.tCtrGenPF.Y_min;
	Para.tCtrGenPF.Y_max;
	Para.tCtrGenPF.dY_max;
	Para.tCtrGenPF.Y_block;
	Para.tCtrGenPF.invert;
	Para.tCtrGenPF.Kp;
	Para.tCtrGenPF.Tn;
	Para.tCtrGenPF.Tv;
	Para.tCtrGenPF.Kp_GainScheduling;
	Para.tCtrGenPF.Tn_GainScheduling;
	Para.tCtrGenPF.Tv_GainScheduling;
	Para.tCtrGenPF.t_min_pulse_down;
	Para.tCtrGenPF.t_min_pulse_up;
	Para.tCtrGenPF.t_period_down;
	Para.tCtrGenPF.t_period_up;

	(* Input variable *)
	tCtrGenPF_In := VIS2MM.tCtrGenPF_In;	(* from vis *)

	(* Input from module *)
	tCtrGenPF_In.enable		  	:= 	Para.bPF_CosPCtr_Ena
							AND NOT OUT_GC.bPF_CosPCtr_block 
							AND 	IN_GC.tPB2MM.bParaSetupOk;	
	tCtrGenPF_In.W_ext_Active	:=	tCtrGenPF_In.W_ext_Active OR TRUE;	(* no changeover to internal *)
	tCtrGenPF_In.W_ext		 	:=	PFSoll_lin;  						(* linearised PF_Soll_value  *)	
	tCtrGenPF_In.Y_set_Active	:= (IN_GC.bGCQ_Fun_Act OR Para.bPF_CosPCtr_Ena)
								AND OUT_GC.bPF_CosPCtr_block;			(* depending on operating mode *)	 
	tCtrGenPF_In.Y_set		 	:=	OUT_GC.rPF_CosPCtr_block;			(* depending on operating mode *)
	IF xOpMode.NetP THEN
		tCtrGenPF_In.X			:=	PF_Ist_lin; 						(* linearised PF_Ist_value, power factor process value (actual)*)
	ELSE
		tCtrGenPF_In.X			:=	1.0; 								(* freeze linearised PF_Ist_value for visu, power factor process value (actual)*)
	END_IF;		
	tCtrGenPF_In.A			 	:=	0.0;		
	tCtrGenPF_In.W_set2_Active	:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtrGenPF_In.GainScheduling	:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtrGenPF_In.Y_min_cust		:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtrGenPF_In.Y_max_cust		:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtrGenPF_In.Retrigger		:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtrGenPF_In.Y_man_Active;
	tCtrGenPF_In.Y_man;
	tCtrGenPF_In.X_min;
	tCtrGenPF_In.X_max;
	tCtrGenPF_In.Tune_quality;
	tCtrGenPF_In.Tune_PI;
	tCtrGenPF_In.Tune_PID;
	tCtrGenPF_In.Tune_start;
	tCtrGenPF_In.Tune_stop;
	tCtrGenPF_In.Tune_takeover;
		
	xCtrGenPF();
	
	(* Output variables  Generator controller 13 function block *)
	(* Output to module(s) *)	
	OUT_GC.rCtrGenPF_Set := tCtrGenPF_Out.Y;			//Analog OUT (-100..100%) 
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtrGenPF_Out := tCtrGenPF_Out;
	VIS2MM.tCtrGenPF_In  := tCtrGenPF_In;	
		
	tCtrGenPF_Out.Active;
	tCtrGenPF_Out.Y;
	tCtrGenPF_Out.W;
	tCtrGenPF_Out.e;
	tCtrGenPF_Out.Kp_tune;
	tCtrGenPF_Out.Tn_tune;
	tCtrGenPF_Out.Tv_tune;
	tCtrGenPF_Out.status;
	
ELSE
	(* Set OUT values to 0 in case of Controller is not active *)

	OUT_GC.rCtrGenPF_Set   	       := Para.tCtrGenPF.Y_block;
		
	tCtrGenPF_Out.Active;
	tCtrGenPF_Out.Y;
	tCtrGenPF_Out.W;
	tCtrGenPF_Out.e;
	tCtrGenPF_Out.Kp_tune;
	tCtrGenPF_Out.Tn_tune;
	tCtrGenPF_Out.Tv_tune;	
	tCtrGenPF_Out.status;
	
END_IF;

END_PROGRAM
