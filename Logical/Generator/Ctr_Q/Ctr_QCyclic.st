(********************************************************************
Ctr_Q		reactive power controller 

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022


Customized modifications: -
------------------------
 
History:
-------
V4.05.0	21.11.2017 	lettenb.	new, GR redesign, PF control -> Q control
V4.09.0	19.11.2019	lettenb.	ctr freeze conditions added
		03.02.2020	lettenb.	autotune enabled, bugfix
V4.10.0 18.01.2021	Weitzer		OUT_GC.tCtr_Q_Out interface for Customized added - AB specific
V4.11.0	28.01.2022	Perktold	included plant controller upgrade

Instructions for use: - 
--------------------
			
Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameter reactive power controller 33 *)
	Para.tCtr_Q.W_set;
	Para.tCtr_Q.W_set2;
	Para.tCtr_Q.W_min;
	Para.tCtr_Q.W_max;
	Para.tCtr_Q.dW_up;
	Para.tCtr_Q.dW_down;
	Para.tCtr_Q.deadband;
	Para.tCtr_Q.Y_min;
	Para.tCtr_Q.Y_max;
	Para.tCtr_Q.dY_max;
	Para.tCtr_Q.Y_block;
	Para.tCtr_Q.invert;
	Para.tCtr_Q.Kp;
	Para.tCtr_Q.Tn;
	Para.tCtr_Q.Tv;
	Para.tCtr_Q.Kp_GainScheduling;
	Para.tCtr_Q.Tn_GainScheduling;
	Para.tCtr_Q.Tv_GainScheduling;
	Para.tCtr_Q.t_min_pulse_down;
	Para.tCtr_Q.t_min_pulse_up;
	Para.tCtr_Q.t_period_down;
	Para.tCtr_Q.t_period_up;

	(* Input variable *)
	tCtr_Q_In := VIS2MM.tCtr_Q_In;	(* from vis *)

	(* Input from module *)
	tCtr_Q_In.enable	 	:=  Para.bPF_CosPCtr_Ena
						AND		Para.bCtr_Q
						AND NOT(Para.iQ_GrC_PointCtrl = 3)				(* direct control *)
						AND NOT OUT_GC.bPF_CosPCtr_block
						AND 	IN_GC.tPB2MM.bParaSetupOk;
	tCtr_Q_In.W_ext_Active	:=	tCtr_Q_In.W_ext_Active OR TRUE;			(* no changeover to internal *)
	tCtr_Q_In.W_ext		 	:=	rQ_Set_Lim;

	IF Para.bPF_CosPCtr_Ena AND OUT_GC.bPF_CosPCtr_block THEN			(* depending on operating mode *)
		tCtr_Q_In.Y_set_Active	:=  TRUE;
		tCtr_Q_In.Y_set		 	:=	OUT_GC.rPF_CosPCtr_block;
	ELSIF IN_GC.bMsg2831 												(* freeze ctr depending on FRT event *)
	  OR (IN_GC.tU_Avg[1].Ai < (Para.rU_Gen_Nom[1] * 0.85))				(* measured voltage of MMU is below 85% *)
	  OR (MM2VIS.rQ_AVR_Set_Norm >= Para.rQ_UnderExc_Lim)				(* Q_AVR_Set = limit *)// AVR_Lim grenzen erhöhen um reglerhub an den grenzen zu ermöglichen - lukas?
	  OR (MM2VIS.rQ_AVR_Set_Norm <= Para.rQ_OverExc_Lim) THEN                                  // AVR_Lim grenzen erhöhen um reglerhub an den grenzen zu ermöglichen - lukas?
		tCtr_Q_In.Y_set_Active	:=  TRUE;
		tCtr_Q_In.Y_set		 	:=	tCtr_Q_Out.Y;						(* freeze actual y *)
	ELSE
		tCtr_Q_In.Y_set_Active	:=  FALSE;
	END_IF;

	(* calculation Qact from voltage POC *)
	(* Qact[%] = ( Uact[V] * 100 / Unom_par.11696[V] ) - 100; *)
	IF Para.rU_GrC_SetEU_Nom > 0 THEN
		rQ_POC_Act_CalcV := 2.0 * ((rU_POC_Act / Para.rU_GrC_SetEU_Nom) - 1); (* 2.0 = factor to get higher controller deviation *)
	END_IF;
	
	IF xOpMode.NetP THEN 
		IF Para.iQ_GrC_CtrlFun = 7 THEN	tCtr_Q_In.X := rQ_POC_Act_CalcV;(* V control *)
		ELSE			                tCtr_Q_In.X := rQ_POC_Act_Norm;	(* Q control *)
		END_IF;
	ELSE
		tCtr_Q_In.X := 0.0;
	END_IF;

	tCtr_Q_In.X; 							(* Q process value (actual) *)		
	tCtr_Q_In.A			 	:=	0.0;
	tCtr_Q_In.W_set2_Active	:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_Q_In.GainScheduling:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_Q_In.Y_min_cust	:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_Q_In.Y_max_cust	:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_Q_In.Retrigger		:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		
	(* Input from Visualization via OPC *)
	tCtr_Q_In.Y_man_Active;
	tCtr_Q_In.Y_man;
	tCtr_Q_In.X_min;
	tCtr_Q_In.X_max;
	tCtr_Q_In.Tune_quality;
	tCtr_Q_In.Tune_PI;
	tCtr_Q_In.Tune_PID;
	tCtr_Q_In.Tune_start;
	tCtr_Q_In.Tune_stop;
	tCtr_Q_In.Tune_takeover;
		
	xCtr_Q();
	
	(* Output variables function block *)
	(* Output to module(s) *)
	OUT_GC.rCtr_Q_Set := tCtr_Q_Out.Y;	(* controller out -1,0..0..+1,0 = -100%Qnom..0..+100%Qnom *)
	OUT_GC.tCtr_Q_Out := tCtr_Q_Out;	(* Interface for Customized - AB Specific *)
	
	(* Output to Visualization via OPC *)
	MM2VIS.tCtr_Q_Out := tCtr_Q_Out;
	VIS2MM.tCtr_Q_In  := tCtr_Q_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	
		
	tCtr_Q_Out.Active;
	tCtr_Q_Out.Y;
	tCtr_Q_Out.W;
	tCtr_Q_Out.e;
	tCtr_Q_Out.Kp_tune;
	tCtr_Q_Out.Tn_tune;
	tCtr_Q_Out.Tv_tune;
	tCtr_Q_Out.status;

END_PROGRAM
