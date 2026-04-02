(*******************************************************************************
c_mns INIT		 customizable mains demand controller  

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

*******************************************************************************)
PROGRAM _INIT
	IF rP_MainsImport_max = 0 THEN rP_MainsImport_max := 999999; END_IF
	

	
	
	Para.bCtr_Mns_Enable;		(*Parameter)	Regler Aktivierung *)
	Para.tCtr_Mns.W_set;		(*Parameter	W(setpoint) start  Var.1:	Der Sollwert wird mittels wird über einen internen Parameter (Setpoint) realisiert *)
	Para.tCtr_Mns.W_min;		(*Parameter	W(setpoint) minimum *)
	Para.tCtr_Mns.W_max;		(*Parameter	W(setpoint) maximum *)

	Para.bCtr_Mns_AnaIn_Setp_Enable;(*Parameter 	setpoint over mA aktiv Var.2:	Der Sollwert wird mittels externen mA Signal, welches über Parameter angepasst werden kann*)
	Para.bCtr_Mns_Setp_Set4mA;		(*Parameter 	scaling 4-20 mA aktiv *)
	Para.rCtr_Mns_Setp_ScalMin;		(*Parameter 	scale minimum *)
	Para.rCtr_Mns_Setp_ScalMax;		(*Parameter 	scale maximum *)

	Para.bP_Mns_MMU_Enable;			(*Parameter 	FALSE = über mA Signal Var.1:	Der Istwert wird mittels mA Signal, welches über Parameter angepasst werden kann *)
	Para.bP_Mns_AnaIn_Set4mA;		(*Parameter 	scaling 4-20 mA aktiv *)
	Para.rP_Mns_AnaIn_ScalMin;		(*Parameter 	scale minimum *)
	Para.rP_Mns_AnaIn_ScalMax;		(*Parameter 	scale maximum *)

	Para.bLimOnOff_aktiv;			(*Parameter)	Regler Aktivierung		*)
	Para.rMainsImport_max;			(*Parameter)	Mains Import maximum	*)
	Para.rMainsImport_max_trip;		(*Parameter)	Mains Import maximum Abstellend True/False *)
	Para.rMainsExport_max;			(*Parameter)	Mains Export maximum	*)
	Para.rMainsExport_max_trip;		(*Parameter)	Mains Export maximum Abstellend True/False *)
	Para.rDemGenerate_Lim_On;		(*Parameter)	Grenzwert Einschaltung (% von PN Generator) *)
	Para.rTime_Dem_On_delay;		(*Parameter)	Zeitwert Verzögerung Anforderung *)
	Para.rDemGenerate_Lim_Off;		(*Parameter)	Grenzwert Abschaltung (% von PN Generator) *)
	Para.rTime_Dem_Off_delay;		(*Parameter)	Zeitwert Verzögerung Abforderung *)


	Para.rTime_Trip_MainsImort;		(*ALT! Parameter)	Verzögerung Abstellung bei Überschreitung *)
	Para.rTime_Trip_MainsExport;	(*ALT! Parameter)	Verzögerung Abstellung bei Überschreitung *)

	
	(*Supply defaults for missing/not used VIS parameter*)
	ParaFactoryDefault.tCtr_Mns.W_set := 123.4;
	ParaFactoryDefault.tCtr_Mns.W_min := 0.0;
	ParaFactoryDefault.tCtr_Mns.W_max := 88888.8;
	ParaFactoryDefault.tCtr_Mns.dW_up := 0.1;
	ParaFactoryDefault.tCtr_Mns.dW_down := 0.1;
	ParaFactoryDefault.tCtr_Mns.deadband := 3.0;
	ParaFactoryDefault.tCtr_Mns.Y_min := 0.5;
	ParaFactoryDefault.tCtr_Mns.Y_max := 1.0;
	ParaFactoryDefault.tCtr_Mns.Y_block  := 1.0;				
	ParaFactoryDefault.tCtr_Mns.Kp := 0.01;
	ParaFactoryDefault.tCtr_Mns.Tn := 150.0;
	ParaFactoryDefault.tCtr_Mns.Tv := 0.0;
	
	ParaFactoryDefault.tCtr_Mns.t_min_pulse_up := 0.20;
	ParaFactoryDefault.tCtr_Mns.t_period_up := 1.0;
	ParaFactoryDefault.tCtr_Mns.t_min_pulse_down := 0.2;
	ParaFactoryDefault.tCtr_Mns.t_period_down := 1.0;
	ParaFactoryDefault.tCtr_Mns.invert := TRUE ;
	

	
	(* configure and asign structures for mains input controller *)
//	xGeACtr_Mns(pParameter := ADR(Para.tCtr_Mns), 		pInput := ADR(VIS2MM.tCtr_Mns_In), pOutput := ADR(MM2VIS.tCtr_Mns_Out));
	xGeACtr_Mns(pParameter := ADR(ShadowPara_tCtr_Mns),	pInput := ADR(VIS2MM.tCtr_Mns_In), pOutput := ADR(MM2VIS.tCtr_Mns_Out));  (* V4.07 *)

	VIS2MM.tCtr_Mns_In.AlwaysUseYRamp		:= TRUE;	(*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
	VIS2MM.tCtr_Mns_In.KeepYManAtBlock		:= TRUE;	(*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
	VIS2MM.tCtr_Mns_In.Y_min_cust			:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	VIS2MM.tCtr_Mns_In.Y_max_cust			:=  1.0;	(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	VIS2MM.tCtr_Mns_In.StepperMode			:= FALSE;	(* TRUE = use PWM-Mode (standard mode until 4.10) | FALSE = use continuous servo drive *)

END_PROGRAM

