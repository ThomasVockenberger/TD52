FUNCTION_BLOCK fPUscuff
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        Para : tPUscuff_PARA; (**)
  END_VAR
  VAR_INPUT
        In : tPUscuff_IN; (**)
  END_VAR
  VAR_OUTPUT
        Out : tPUscuff_OUT; (**)
  END_VAR
  VAR_OUTPUT
        Dbg : tPUscuff_DBG; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT := 0; (**)
  END_VAR
	VAR
		bur_BlockIO_PUscuff : BlockIO_PUscuff;
	END_VAR
	VAR
		bur_ExternalInputs_PUscuff : ExternalInputs_PUscuff;
	END_VAR
	VAR
		bur_ExternalOutputs_PUscuff : ExternalOutputs_PUscuff;
	END_VAR
	VAR
		bur_D_Work_PUscuff : D_Work_PUscuff;
	END_VAR
	VAR
		bur_PUscuff : tag_RTM_PUscuff;
	END_VAR
END_FUNCTION_BLOCK