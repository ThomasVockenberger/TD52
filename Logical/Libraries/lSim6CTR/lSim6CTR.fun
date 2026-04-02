FUNCTION_BLOCK Sim6CTR
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        CycleTime : REAL := 0.0099999998; (*Proportional Gain*)
  END_VAR
  VAR_INPUT
        Ts_downSampling_speed : REAL := 0.5000000000; (*DownSampling Time for negative Speed Detection*)
  END_VAR
  VAR_INPUT
        u_min_CBP : REAL; (*minimum value for compressor bypass valve*)
  END_VAR
  VAR_INPUT
        rP_drop_limit : REAL := -500.0000000000; (*Load Drop Trigger value*)
  END_VAR
  VAR_INPUT
        rP_el_LockTV : REAL := 1000.0000000000; (*Lock ThrottleValve hysteresies value*)
  END_VAR
  VAR_INPUT
        rP_el_ReleaseTV : REAL := 900.0000000000; (*Release ThrottleValve hysteresies value*)
  END_VAR
  VAR_INPUT
        rN_ok_offset : REAL := 10.0000000000; (*Engine Speed tolerance offset for load drops*)
  END_VAR
  VAR_INPUT
        u_man_TV : REAL := 90.0000000000; (*manual set value for throttle valve*)
  END_VAR
  VAR_INPUT
        u_max_TV : REAL := 1000.0000000000; (*maximum value for throttle valve*)
  END_VAR
  VAR_INPUT
        u_min_TV : REAL; (*minimum value for throttle valve*)
  END_VAR
  VAR_INPUT
        u_max_CBP : REAL := 1000.0000000000; (*maximum value for compressor bypass valve*)
  END_VAR
  VAR_INPUT
        bInit : BOOL := FALSE; (*Init CTR in Tracking Mode*)
  END_VAR
  VAR_INPUT
        Init_Value_CBP : REAL; (*init value compressor bypass*)
  END_VAR
  VAR_INPUT
        w_set : REAL; (*set value*)
  END_VAR
  VAR_INPUT
        x_act : REAL; (*actual value*)
  END_VAR
  VAR_INPUT
        P_CBP : REAL; (*P gain of compressor bypass*)
  END_VAR
  VAR_INPUT
        D_CBP : REAL; (*D gain of compressor bypass*)
  END_VAR
  VAR_OUTPUT
        rPos_CBP : REAL; (*Controller Output*)
  END_VAR
  VAR_INPUT
        rN_act : REAL; (*engine speed actual value*)
  END_VAR
  VAR_INPUT
        rN_set : REAL; (*engine speed set value*)
  END_VAR
  VAR_INPUT
        rP_el : REAL; (*electrical power*)
  END_VAR
  VAR_INPUT
        Init_Value_TV : REAL; (*init value throttle bypass*)
  END_VAR
  VAR_INPUT
        P_TV : REAL; (*P gain of throttle valve*)
  END_VAR
  VAR_INPUT
        D_TV : REAL; (*D gain of throttle valve*)
  END_VAR
  VAR_OUTPUT
        rPos_TV : REAL; (*Controller Output*)
  END_VAR
  VAR_OUTPUT
        rN_act_Diff : REAL; (*test output*)
  END_VAR
  VAR_OUTPUT
        bOpen4CBP : BOOL := FALSE; (*open compressor bypass valve 3 and 4*)
  END_VAR
  VAR_OUTPUT
        bLoadDrop : BOOL := FALSE; (*indication of a load drop*)
  END_VAR
  VAR_OUTPUT
        Control_State : INT; (*indication of a load drop*)
  END_VAR
  VAR_OUTPUT
        bLock_TV : BOOL := FALSE; (*freeze throttle valve to constant value*)
  END_VAR
  VAR_OUTPUT
        bN_ok : BOOL := FALSE; (*test output*)
  END_VAR
  VAR_OUTPUT
        bN_rate_neg : BOOL := FALSE; (*test output*)
  END_VAR
  VAR_OUTPUT
        bP_drop : BOOL := FALSE; (*test output*)
  END_VAR
  VAR_OUTPUT
        rP_grad : REAL; (*test output*)
  END_VAR
  VAR_OUTPUT
        rN_act_DS : REAL; (*test output*)
  END_VAR
  VAR_INPUT
        I_CBP : REAL; (*I gain of compressor bypass*)
  END_VAR
  VAR_INPUT
        I_TV : REAL; (*I gain of throttle valve*)
  END_VAR
	VAR
		bur_Sim6CTR_DWork : D_Work_Sim6CTR;
	END_VAR
	VAR
		bur_Sim6CTR_B : BlockIO_Sim6CTR;
	END_VAR
END_FUNCTION_BLOCK