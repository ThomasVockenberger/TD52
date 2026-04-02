PROGRAM _INIT

	xCtr_EOVal_LT.pParameter 	:= ADR(Para.tCtr_EOVal_LT);
	xCtr_EOVal_LT.pInput 		:= ADR(tCtr_EOVal_LT_In);
	xCtr_EOVal_LT.pOutput	 	:= ADR(tCtr_EOVal_LT_Out);

	tCtr_EOVal_LT_In.AlwaysUseYRamp		:= TRUE;	(*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
	tCtr_EOVal_LT_In.KeepYManAtBlock	:= TRUE;	(*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
	tCtr_EOVal_LT_In.Y_min_cust			:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_EOVal_LT_In.Y_max_cust			:=  1.0;	(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_EOVal_LT_In.StepperMode		:= FALSE;	(* TRUE = use PWM-Mode (standard mode until 4.10) | FALSE = use continuous servo drive *)

END_PROGRAM

