FUNCTION_BLOCK Sim3pCTR
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        Enable : BOOL := FALSE; (**)
  END_VAR
  VAR_INPUT
        SetValue : REAL; (*Set Value*)
  END_VAR
  VAR_INPUT
        HysPos : REAL; (*positive hysteresis for trigger value*)
  END_VAR
  VAR_INPUT
        HysNeg : REAL; (*negative hysteresis for trigger value*)
  END_VAR
  VAR_INPUT
        ActValue : REAL; (*actual value*)
  END_VAR
  VAR_INPUT
        dY_up : REAL; (*positive gradient*)
  END_VAR
  VAR_INPUT
        dY_down : REAL; (*negative gradient*)
  END_VAR
  VAR_INPUT
        CycleTime : REAL; (*cycle time in which FUB is used*)
  END_VAR
  VAR_INPUT
        Reset : BOOL := FALSE; (*reset bit*)
  END_VAR
  VAR_INPUT
        InitValue : REAL; (*initial value when reset bit is set*)
  END_VAR
  VAR_INPUT
        bInverse : BOOL := FALSE; (*Invert actuating direction of controller*)
  END_VAR
  VAR_INPUT
        bRamp_Y_min : BOOL := FALSE; (*ramp output y to minimum*)
  END_VAR
  VAR_INPUT
        bRamp_Y_max : BOOL := FALSE; (*ramp output y to maximum*)
  END_VAR
  VAR_INPUT
        Y_min : REAL; (*minimal Limit for Output Y*)
  END_VAR
  VAR_INPUT
        Y_max : REAL; (*maximal Limit for Output Y*)
  END_VAR
  VAR_OUTPUT
        Y : REAL; (*Controller Output*)
  END_VAR
  VAR_OUTPUT
        bY_min_limit : BOOL := FALSE; (*Y is in minimum limitation*)
  END_VAR
  VAR_OUTPUT
        bY_max_limit : BOOL := FALSE; (*Y is in maximum limitation*)
  END_VAR
  VAR_OUTPUT
        State : INT; (*state::
0: steady
1: decrease
2: increase*)
  END_VAR
	VAR
		bur_Sim3pCTR_DWork : D_Work_Sim3pCTR;
	END_VAR
	VAR
		bur_Sim3pCTR_B : BlockIO_Sim3pCTR;
	END_VAR
END_FUNCTION_BLOCK