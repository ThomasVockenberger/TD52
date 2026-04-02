(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: Ctr_TR_4
 * File: Ctr_TR_4Init.st
 * Author: 105051626
 * Created: November 08, 2013
 ********************************************************************
 * Implementation of program Ctr_TR_4
 ********************************************************************)

PROGRAM _INIT

	tCtrTR_Heater_In.W_ext_Active := FALSE;	// Thermal Reactor Heater controller in programmed to used internal set point.
	                                     	// It uses X_Set (internal set points) inputs
	
	Para.tCtrTR_Heater.Y_block := 0.0;  	// Force output to 0,0 when controller disabled.
		
	tCtrTR_Heater_In.AlwaysUseYRamp		:= TRUE;	(*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
	tCtrTR_Heater_In.KeepYManAtBlock	:= TRUE;	(*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
	tCtrTR_Heater_In.Y_min_cust			:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtrTR_Heater_In.Y_max_cust			:=  1.0;	(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtrTR_Heater_In.StepperMode		:= TRUE;	(* TRUE = use PWM-Mode (standard mode until 4.10) | FALSE = use continuous servo drive *)


	xCtrTR_Heater.pParameter := ADR(Para.tCtrTR_Heater);
	xCtrTR_Heater.pInput     := ADR(tCtrTR_Heater_In);
	xCtrTR_Heater.pOutput    := ADR(tCtrTR_Heater_Out);

END_PROGRAM

