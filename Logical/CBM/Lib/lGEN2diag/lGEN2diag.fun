FUNCTION_BLOCK fGEN2diag
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        In : tGEN2FIn; (**)
  END_VAR
  VAR_INPUT
        Para : tGEN2FParameter; (**)
  END_VAR
 VAR_OUTPUT
        Out : tGEN2FOut; (**)
  END_VAR
 VAR_OUTPUT
        dbgOut : tGEN2FDebug; (**)
  END_VAR
  VAR_OUTPUT
        Info : UDINT; (*Model information*)
  END_VAR
	VAR
		bur_BlockIO_G2Fdiag : BlockIO_G2Fdiag;
	END_VAR
	VAR
		bur_D_Work_G2Fdiag : D_Work_G2Fdiag;
	END_VAR
	VAR
		bur_ExternalInputs_G2Fdiag : ExternalInputs_G2Fdiag;
	END_VAR
	VAR
		bur_ExternalOutputs_G2Fdiag : ExternalOutputs_G2Fdiag;
	END_VAR
END_FUNCTION_BLOCK