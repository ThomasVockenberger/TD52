PROGRAM _INIT

	xCtr_OutlVE_RT.pParameter 	:= ADR(Para.tCtr_OutlVE_RT); 
	xCtr_OutlVE_RT.pInput 	 	:= ADR(tCtr_OutlVE_RT_In); 
	xCtr_OutlVE_RT.pOutput	 	:= ADR(tCtr_OutlVE_RT_Out); 

	tCtr_OutlVE_RT_In.AlwaysUseYRamp		:= TRUE;	(*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
	tCtr_OutlVE_RT_In.KeepYManAtBlock		:= TRUE;	(*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
	tCtr_OutlVE_RT_In.Y_min_cust			:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_OutlVE_RT_In.Y_max_cust			:=  1.0;	(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_OutlVE_RT_In.StepperMode			:= FALSE;	(* TRUE = use PWM-Mode (standard mode until 4.10) | FALSE = use continuous servo drive *)

END_PROGRAM

