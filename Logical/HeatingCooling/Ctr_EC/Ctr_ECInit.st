PROGRAM _INIT

	xCtr_EC.pParameter 	:= ADR(Para.tCtr_EC);
	xCtr_EC.pInput 		:= ADR(tCtr_EC_In);
	xCtr_EC.pOutput	 	:= ADR(tCtr_EC_Out);

	tCtr_EC_In.AlwaysUseYRamp		:= TRUE;	(*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
	tCtr_EC_In.KeepYManAtBlock		:= TRUE;	(*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
	tCtr_EC_In.Y_min_cust			:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_EC_In.Y_max_cust			:=  1.0;	(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_EC_In.StepperMode			:= FALSE;	(* TRUE = use PWM-Mode (standard mode until 4.10) | FALSE = use continuous servo drive *)

END_PROGRAM

