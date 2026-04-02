PROGRAM _INIT

	xCtr_GC.pParameter := ADR(Para.tCtr_GC);
	xCtr_GC.pInput 	:= ADR(tCtr_GC_In);
	xCtr_GC.pOutput	:= ADR(tCtr_GC_Out);

	tCtr_GC_In.AlwaysUseYRamp		:= TRUE;	(*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
	tCtr_GC_In.KeepYManAtBlock		:= TRUE;	(*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
	tCtr_GC_In.Y_min_cust			:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_GC_In.Y_max_cust			:=  1.0;	(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)

END_PROGRAM

