FUNCTION_BLOCK fLamStart
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        Perm : tLamStart_PERM; (**)
  END_VAR
  VAR_INPUT
        Para : tLamStart_PARA; (**)
  END_VAR
  VAR_INPUT
        IN : tLamStart_IN; (**)
  END_VAR
 VAR_OUTPUT
        dbg : tLamStart_DBG; (**)
  END_VAR
  VAR_OUTPUT
        rLambda_start_idle : REAL; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_LamStart : BlockIO_LamStart;
	END_VAR
	VAR
		bur_D_Work_LamStart : D_Work_LamStart;
	END_VAR
	VAR
		bur_PrevZCSigStates_LamStart : PrevZCSigStates_LamStart;
	END_VAR
	VAR
		bur_ExternalOutputs_LamStart : ExternalOutputs_LamStart;
	END_VAR
END_FUNCTION_BLOCK