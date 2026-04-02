FUNCTION_BLOCK fMeNoiAL
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        Para : tMeNoiAL_PARA; (**)
  END_VAR
  VAR_INPUT
        In : tMeNoiAL_IN; (**)
  END_VAR
 VAR_OUTPUT
        Out : tMeNoiAL_OUT; (**)
  END_VAR
 VAR_OUTPUT
        Dbg : tMeNoiAL_DBG; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_MeNoiAL : BlockIO_MeNoiAL;
	END_VAR
	VAR
		bur_D_Work_MeNoiAL : D_Work_MeNoiAL;
	END_VAR
	VAR
		bur_ExternalOutputs_MeNoiAL : ExternalOutputs_MeNoiAL;
	END_VAR
END_FUNCTION_BLOCK