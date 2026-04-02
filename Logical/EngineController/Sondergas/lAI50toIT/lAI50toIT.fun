FUNCTION_BLOCK AI50toIT
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        mode : INT := 3; (**)
  END_VAR
  VAR_INPUT
        reset : BOOL := FALSE; (**)
  END_VAR
  VAR_INPUT
        umin : REAL := -3.0000000000; (**)
  END_VAR
  VAR_INPUT
        umax : REAL := 3.0000000000; (**)
  END_VAR
  VAR_INPUT
        T_filt_AI50 : REAL := 8.0000000000; (**)
  END_VAR
  VAR_INPUT
        invert : BOOL := TRUE; (**)
  END_VAR
  VAR_INPUT
        kp : REAL := 1.0000000000; (**)
  END_VAR
  VAR_INPUT
        ki : REAL := 1.0000000000; (**)
  END_VAR
  VAR_INPUT
        kd : REAL; (**)
  END_VAR
  VAR_INPUT
        N : REAL; (**)
  END_VAR
  VAR_INPUT
        Kt : REAL; (**)
  END_VAR
  VAR_INPUT
        deadband : REAL; (**)
  END_VAR
  VAR_INPUT
        uman : ARRAY[0..24] OF REAL; (*Reference Value*)
  END_VAR
  VAR_INPUT
        AI50ref : REAL; (*Reference Value*)
  END_VAR
  VAR_INPUT
        AI50offset : ARRAY[0..24] OF REAL; (*Reference Value*)
  END_VAR
  VAR_INPUT
        AI50offset_knck : ARRAY[0..24] OF REAL; (*Reference Value*)
  END_VAR
  VAR_INPUT
        K_knck : REAL := 1.0000000000; (*Gain for knocking IT offset*)
  END_VAR
  VAR_OUTPUT
        ITsat : ARRAY[0..24] OF REAL; (*IT saturation [°CA]*)
  END_VAR
  VAR_OUTPUT
        AI50err : ARRAY[0..24] OF REAL; (*AI50 error [°CA]*)
  END_VAR
  VAR_OUTPUT
        IToffset : ARRAY[0..24] OF REAL; (*IT offset [°CA]*)
  END_VAR
  VAR_OUTPUT
        DB_AI50_f : ARRAY[0..24] OF REAL; (*AI50 filtered*)
  END_VAR
  VAR_INPUT
        AI50_max : REAL := 30.0000000000; (*AI50 saturation max*)
  END_VAR
  VAR_INPUT
        AI50act : ARRAY[0..24] OF REAL; (*Reference Value*)
  END_VAR
  VAR_INPUT
        AI50_min : REAL; (*AI50 saturation min*)
  END_VAR
  VAR_OUTPUT
        dbg1 : ARRAY[0..5] OF REAL; (*u, utr, up, ui, ud, e*)
  END_VAR
  VAR_OUTPUT
        DB_Ts : LREAL; (**)
  END_VAR
	VAR
		bur_BlockIO_AI50toIT_mdl : BlockIO_AI50toIT_mdl;
	END_VAR
	VAR
		bur_D_Work_AI50toIT_mdl : D_Work_AI50toIT_mdl;
	END_VAR
	VAR
		bur_ExternalInputs_AI50toIT_mdl : ExternalInputs_AI50toIT_mdl;
	END_VAR
	VAR
		bur_ExternalOutputs_AI50toIT_md : ExternalOutputs_AI50toIT_mdl;
	END_VAR
END_FUNCTION_BLOCK