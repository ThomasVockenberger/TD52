FUNCTION_BLOCK fLX2
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        IN : tLX2_IN; (**)
  END_VAR
  VAR_INPUT
        PERM : tLX2_PERM; (**)
  END_VAR
  VAR_INPUT
        PARA : tLX2_PARA; (**)
  END_VAR
 VAR_OUTPUT
        Output : tLX2_OUT; (**)
  END_VAR
 VAR_OUTPUT
        DBUG : tLX2_DBUG; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_LX2 : BlockIO_LX2;
	END_VAR
	VAR
		bur_D_Work_LX2 : D_Work_LX2;
	END_VAR
	VAR
		bur_ExternalInputs_LX2 : ExternalInputs_LX2;
	END_VAR
	VAR
		bur_ExternalOutputs_LX2 : ExternalOutputs_LX2;
	END_VAR
	VAR
		bur_LX2 : tag_RTM_LX2;
	END_VAR
END_FUNCTION_BLOCK