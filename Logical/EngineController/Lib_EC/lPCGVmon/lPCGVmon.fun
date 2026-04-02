FUNCTION_BLOCK fPCGVmon
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        Input : tPCGVmon_IN; (*PCGV monitoring bus inputs*)
  END_VAR
  VAR_INPUT
        Perm : tPCGVmon_PERM; (*PCGV monitoring bus perms*)
  END_VAR
  VAR_OUTPUT
        Debug : tPCGVmon_DBG; (*PCGV monitoring bus debug*)
  END_VAR
  VAR_OUTPUT
        Output : tPCGVmon_OUT; (*PCGV monitoring bus outputs*)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_PCGVmon : BlockIO_PCGVmon;
	END_VAR
	VAR
		bur_ExternalInputs_PCGVmon : ExternalInputs_PCGVmon;
	END_VAR
	VAR
		bur_ExternalOutputs_PCGVmon : ExternalOutputs_PCGVmon;
	END_VAR
	VAR
		bur_D_Work_PCGVmon : D_Work_PCGVmon;
	END_VAR
	VAR
		bur_PCGVmon : tag_RTM_PCGVmon;
	END_VAR
END_FUNCTION_BLOCK