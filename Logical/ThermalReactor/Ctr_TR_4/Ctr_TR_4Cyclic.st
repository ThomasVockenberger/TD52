(*******************************************************************************
Ctr_TR_4		Controller Heater

This code is confidential AND proprietary TO the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission OF the INNIO Company.
Copyright, INNIO Company, 2022
					
Customized modifications: -
------------------------
					 
History:
-------
V04.00.00	04-04-2014  Ganguly 		converted to modular software
V04.03.00	25-09-2014  Denk 			adjust step controller for Thermal reactor
V04.07.00	28-05-2019	Hohensinner 	new interfaces for CU Module (AB Energy like projects and so on)
V04.11.00	28-01-2022	Perktold		included plant controller upgrade
V04.12.00	18-05-2022	Maran			removed unused impulse time selection for step controller
V04.14.00	27-11-2024	Maran			update for thermal reactor 2nd generation (ThR2): blocked gas heater controller if aux. gas solenoid valve is closed

Instructions FOR use:
--------------------
				
Outstandings: - 
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(* Parameter *)
	Para.tCtrTR_Heater.W_set;
	Para.tCtrTR_Heater.W_set2;
	Para.tCtrTR_Heater.W_min;
	Para.tCtrTR_Heater.W_max;
	Para.tCtrTR_Heater.dW_up;
	Para.tCtrTR_Heater.dW_down;
	Para.tCtrTR_Heater.deadband;
	Para.tCtrTR_Heater.Y_min;
	Para.tCtrTR_Heater.Y_max;
	Para.tCtrTR_Heater.dY_max;
	Para.tCtrTR_Heater.Y_block;
	Para.tCtrTR_Heater.invert;
	Para.tCtrTR_Heater.Kp;
	Para.tCtrTR_Heater.Tn;
	Para.tCtrTR_Heater.Tv;
	Para.tCtrTR_Heater.Kp_GainScheduling;
	Para.tCtrTR_Heater.Tn_GainScheduling;
	Para.tCtrTR_Heater.Tv_GainScheduling;
	Para.tCtrTR_Heater.t_min_pulse_down;
	Para.tCtrTR_Heater.t_min_pulse_up;
	Para.tCtrTR_Heater.t_period_down;
	Para.tCtrTR_Heater.t_period_up;
	

	(* Input variables *)
	tCtrTR_Heater_In 				:= VIS2MM.tCtrTR_Heater_In;		(* from vis *)

	(* Input from module *)
	tCtrTR_Heater_In.enable       	:= 	Para.bThR_Active 
									   	AND Para.bCtrThR_Heater_Active 
										AND OUT_TR.bThR_RelGas
										AND NOT bThr2_AuxGasValve_CtrlBlock
										AND IN_TR.tPB2MM.bParaSetupOk;
	tCtrTR_Heater_In.W_ext_Active 	:= FALSE;                     
	tCtrTR_Heater_In.W_ext		  	:= 0.0;                   
	tCtrTR_Heater_In.Y_set_Active 	:= FALSE;	 
	tCtrTR_Heater_In.Y_set		  	:= 0.0;	
	tCtrTR_Heater_In.X				:= TK_moduleTR;               
	tCtrTR_Heater_In.A				:= 0.0;                             
	tCtrTR_Heater_In.W_set2_Active	:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtrTR_Heater_In.GainScheduling	:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtrTR_Heater_In.Y_min_cust		:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtrTR_Heater_In.Y_max_cust		:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtrTR_Heater_In.Retrigger		:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)

	IF bThr2_AuxGasValve_CtrlBlock THEN
		tCtrTR_Heater_In.Y_set_Active 	:= TRUE;
		tCtrTR_Heater_In.Y_set		  	:= tCtrTR_Heater_Out.Y;
	END_IF
	
	(* Input from Visualization via OPC *)
	tCtrTR_Heater_In.Y_man_Active;				
	tCtrTR_Heater_In.Y_man;		  			
	tCtrTR_Heater_In.X_min;         	 				
	tCtrTR_Heater_In.X_max;         					
	tCtrTR_Heater_In.Tune_quality;  
	tCtrTR_Heater_In.Tune_PI;      				
	tCtrTR_Heater_In.Tune_PID;      								
	tCtrTR_Heater_In.Tune_start;    				
	tCtrTR_Heater_In.Tune_stop;    			
	tCtrTR_Heater_In.Tune_takeover;	

	xCtrTR_Heater();


	(* Output variables function block *)
	(* Output to module(s) *)	
	OUT_TR.tCtrTR_Heater_Set.Ao 	:= tCtrTR_Heater_Out.Y;		

	OUT_TR.tCtrTR_Heater_Out		:=	tCtrTR_Heater_Out;

	(* Output to Visualization via OPC *)	
	MM2VIS.tCtrTR_Heater_Out 		:= tCtrTR_Heater_Out;
	VIS2MM.tCtrTR_Heater_In  		:= tCtrTR_Heater_In;	
	
	MM2VIS.tCtrTR_Heater_Out.Active;
	MM2VIS.tCtrTR_Heater_Out.Y;       		
	MM2VIS.tCtrTR_Heater_Out.W;       		
	MM2VIS.tCtrTR_Heater_Out.e;        	
	MM2VIS.tCtrTR_Heater_Out.Kp_tune;   	
	MM2VIS.tCtrTR_Heater_Out.Tn_tune;   	
	MM2VIS.tCtrTR_Heater_Out.Tv_tune;  	
	MM2VIS.tCtrTR_Heater_Out.status;   
	MM2VIS.tCtrTR_Heater_Out.Step_down; 
	MM2VIS.tCtrTR_Heater_Out.Step_up;   


	(***********************************************************************************)
	(* Adjust step controller for Thermal reactor *)
	(* old plc_ctr4 #433 - 447 *)
	REG4_STELL 	:= FALSE;
	REG4_POS 	:= FALSE;
	REG4_NEG	:= FALSE;

	IF tCtrTR_Heater_Out.Y > 0.0 THEN						(* increasing the output value *)
		REG4_STELL 	:= TRUE;
		REG4_POS 	:= TRUE;
	END_IF
	
	IF tCtrTR_Heater_Out.Y < 0 THEN							(* decreasing the output value *)
		REG4_STELL 	:= TRUE;
		REG4_NEG 	:= TRUE;
	END_IF

	Y_absolut := (ABS(tCtrTR_Heater_Out.Y));				(* absolute value of the output *)

	(* Period duration (standard 10s), old NW46 *)
	xTOF_FA_T_REG4_1(IN := REG4_STELL AND NOT xTOF_FA_T_REG4_1.Q, PT := REAL_TO_TIME(Para.tCtrTR_Heater.t_period_up));
	T_REG4_1 := xTOF_FA_T_REG4_1.Q;

	tiImpulseTime := T#1s;
	(* Regulating time and regulating impulse for Step up, Teilweise NW48, NW50 *)
	xTP_FA_T_REG4_2_PLUS(IN := T_REG4_1, PT := tiImpulseTime/2);	(* Step up time control signal divided by 2*)
	T_REG4_2_PLUS := xTP_FA_T_REG4_2_PLUS.Q;

	(* Regulating time and regulating impulse for Step down, Teilweise NW49, NW50 *)
	xTP_FA_T_REG4_2_MINUS(IN := T_REG4_1, PT := tiImpulseTime);
	T_REG4_2_MINUS := xTP_FA_T_REG4_2_MINUS.Q;

	(* Control command Step up, NW52 *)
	Step_up 	:= Para.bThR_Active AND T_REG4_1 AND T_REG4_2_PLUS AND REG4_STELL AND REG4_POS;

	(* Control command Step down, NW54 *)
	Step_down 	:= Para.bThR_Active AND T_REG4_1 AND T_REG4_2_MINUS AND REG4_STELL AND REG4_NEG;


	(*********************************************************)
	(* Set control signal only when Y is constant increasing *)
	IF (tCtrTR_Heater_Out.Y > CntUp_old OR (tCtrTR_Heater_Out.Y > 0.999 AND tCtrTR_Heater_Out.Y < 1.001)) AND NOT bThr2_AuxGasValve_CtrlBlock THEN
		bCtrl_ThR_CInc := Step_up;				(* INFO: for standard controller step output insert here: tCtrTR_Heater_Out.Step_up *)
	ELSE 
		bCtrl_ThR_CInc := FALSE;
	END_IF;
	CntUp_old := tCtrTR_Heater_Out.Y;
	
	(* Set control signal only when Y is constant decreasing *)
	IF (tCtrTR_Heater_Out.Y < CntDown_old OR (tCtrTR_Heater_Out.Y < -0.999 AND tCtrTR_Heater_Out.Y > -1.001)) AND NOT bThr2_AuxGasValve_CtrlBlock THEN
		bCtrl_ThR_CDec := Step_down;			(* INFO: for standard controller step output insert here: tCtrTR_Heater_Out.Step_down *)
	ELSE 
		bCtrl_ThR_CDec := FALSE;
	END_IF;
	CntDown_old := tCtrTR_Heater_Out.Y;	
		
END_PROGRAM
