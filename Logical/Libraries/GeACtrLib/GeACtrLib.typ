
TYPE
	_tGeACtrPara : 	STRUCT 
		W_set : REAL;
		W_set2 : REAL;
		W_min : REAL;
		W_max : REAL;
		dW_up : REAL;
		dW_down : REAL;
		deadband : REAL;
		Y_min : REAL;
		Y_max : REAL;
		dY_max : REAL;
		Y_block : REAL;
		invert : BOOL;
		Kp : REAL;
		Tn : REAL;
		Tv : REAL;
		Kp_GainScheduling : REAL;
		Tn_GainScheduling : REAL;
		Tv_GainScheduling : REAL;
		t_min_pulse_up : REAL;
		t_period_up : REAL;
		t_min_pulse_down : REAL;
		t_period_down : REAL;
	END_STRUCT;
	_tGeACtrIn : 	STRUCT 
		enable : BOOL;
		W_set2_Active : BOOL; (*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
		W_ext_Active : BOOL;
		W_ext : REAL;
		Y_man_Active : BOOL;
		Y_man : REAL;
		Y_set_Active : BOOL;
		Y_set : REAL;
		X : REAL;
		X_min : REAL;
		X_max : REAL;
		Retrigger : BOOL; (*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		GainScheduling : REAL; (*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
		Y_min_cust : REAL; (*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
		Y_max_cust : REAL; (*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
		Tune_quality : INT;
		Tune_PI : BOOL;
		Tune_PID : BOOL;
		Tune_start : BOOL;
		Tune_stop : BOOL;
		Tune_takeover : BOOL;
		A : REAL;
		AlwaysUseYRamp : BOOL; (*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
		KeepYManAtBlock : BOOL; (*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
		StepperMode : BOOL; (* TRUE = use PWM-Mode (standard mode until 4.10) | FALSE = use continuous servo drive *)
	END_STRUCT;
	_tGeACtrOut : 	STRUCT 
		Active : BOOL;
		Y : REAL;
		Y_min_act : REAL;
		Y_max_act : REAL;
		Step_up : BOOL;
		Step_down : BOOL;
		status : UINT;
		W : REAL;
		e : REAL;
		Kp_tune : REAL;
		Tn_tune : REAL;
		Tv_tune : REAL;
		Kp_act : REAL;
		Tn_act : REAL;
		Tv_act : REAL;
		Yp : REAL;
		Yi : REAL;
		Yd : REAL;
		BlockAutoTune : BOOL;
		Show_PID_act : BOOL;
	END_STRUCT;
END_TYPE
