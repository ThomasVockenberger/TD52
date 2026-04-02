FUNCTION_BLOCK fUDC
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        Para : tUD_PARA; (**)
  END_VAR
  VAR_INPUT
        In : tUD_IN; (**)
  END_VAR
  VAR_INPUT
        Perm : tUD_PERM; (**)
  END_VAR
 VAR_OUTPUT
        dbg : tUD_DBG; (**)
  END_VAR
 VAR_OUTPUT
        Out : tUD_OUT; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_UDC : BlockIO_UDC;
	END_VAR
	VAR
		bur_D_Work_UDC : D_Work_UDC;
	END_VAR
	VAR
		bur_ExternalInputs_UDC : ExternalInputs_UDC;
	END_VAR
	VAR
		bur_ExternalOutputs_UDC : ExternalOutputs_UDC;
	END_VAR
	VAR
		bur_UDC : tag_RTM_UDC;
	END_VAR
END_FUNCTION_BLOCK