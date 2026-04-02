FUNCTION_BLOCK fFSyPrM
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        In : tFSyPrM_IN; (*Inputs to FastSync controller*)
  END_VAR
  VAR_INPUT
        Para : tFSyPrM_PARA; (*Parameters to FastSync controller*)
  END_VAR
  VAR_INPUT
        Perm : tFSyPrM_PERM; (*Perm to FastSync controller*)
  END_VAR
  VAR_OUTPUT
        Dbg : tFSyPrM_DBG; (*Debug from FastSync controller*)
  END_VAR
  VAR_OUTPUT
        bEnabled : BOOL := 0; (*True: Autocode active, False: Switch to standard idle controller*)
  END_VAR
  VAR_OUTPUT
        rRetardITP : REAL := 0; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT := 0; (**)
  END_VAR
	VAR
		bur_BlockIO_FSyPrM : BlockIO_FSyPrM;
	END_VAR
	VAR
		bur_ExternalInputs_FSyPrM : ExternalInputs_FSyPrM;
	END_VAR
	VAR
		bur_ExternalOutputs_FSyPrM : ExternalOutputs_FSyPrM;
	END_VAR
	VAR
		bur_D_Work_FSyPrM : D_Work_FSyPrM;
	END_VAR
	VAR
		bur_FSyPrM : tag_RTM_FSyPrM;
	END_VAR
END_FUNCTION_BLOCK