(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: CtrGenPF
 * File: CtrGenPFInit.st
 * Author: 105051626
 * Created: January 08, 2013
 ********************************************************************
 * Implementation of program CtrGenPF
 ********************************************************************)

PROGRAM _INIT

	(*Parameter FACTORY DEFAULT VALUES *)
	(*for missing/new/not visualized parameter*)
	Para.tCtrGenPF.t_min_pulse_down  := 10;
	Para.tCtrGenPF.t_min_pulse_up	 := 10;	
	Para.tCtrGenPF.t_period_down	 := 100;
	Para.tCtrGenPF.t_period_up	     := 100;
	VIS2MM.tCtrGenPF_In.W_ext_Active := TRUE;  // Generator controller is programmed to use the W_Set (external set point) input
											   // It does not use the X_Set (internal set points) inputs
	
	Para.tCtrGenPF.Y_block          := 0.25;   // Force output to 0,25 from controller when disabled.

	tCtrGenPF_In.AlwaysUseYRamp		:= TRUE;	(*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
	tCtrGenPF_In.KeepYManAtBlock	:= TRUE;	(*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
	tCtrGenPF_In.Y_min_cust			:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtrGenPF_In.Y_max_cust			:=  1.0;	(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtrGenPF_In.StepperMode		:= FALSE;	(* TRUE = use PWM-Mode (standard mode until 4.10) | FALSE = use continuous servo drive *)
		
	xCtrGenPF.pParameter := ADR(Para.tCtrGenPF);
	xCtrGenPF.pInput     := ADR(tCtrGenPF_In);
	xCtrGenPF.pOutput    := ADR(tCtrGenPF_Out);
	
END_PROGRAM

