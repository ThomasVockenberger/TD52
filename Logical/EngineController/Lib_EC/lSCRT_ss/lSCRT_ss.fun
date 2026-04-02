FUNCTION_BLOCK fSCRT_ss
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        In : SCRT_ss_IN_Bus; (**)
  END_VAR
  VAR_INPUT
        Perm : SCRT_ss_PERM_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Out : SCRT_ss_OUT_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Dbg : SCRT_ss_DBG_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_SCRT_ss : BlockIO_SCRT_ss;
	END_VAR
	VAR
		bur_ExternalInputs_SCRT_ss : ExternalInputs_SCRT_ss;
	END_VAR
	VAR
		bur_ExternalOutputs_SCRT_ss : ExternalOutputs_SCRT_ss;
	END_VAR
	VAR
		bur_D_Work_SCRT_ss : D_Work_SCRT_ss;
	END_VAR
	VAR
		bur_SCRT_ss : tag_RTM_SCRT_ss;
	END_VAR
END_FUNCTION_BLOCK