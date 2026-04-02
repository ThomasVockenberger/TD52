FUNCTION_BLOCK fCPP_Int
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        In : tCPPI_IN; (**)
  END_VAR
  VAR_INPUT
        Para : tCPPI_PARA; (**)
  END_VAR
  VAR_INPUT
        Perm : tCPPI_PERM; (**)
  END_VAR
 VAR_OUTPUT
        Out : tCPPI_OUT; (**)
  END_VAR
 VAR_OUTPUT
        Dbg : tCPPI_DBUG; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_CPP_Int : BlockIO_CPP_Int;
	END_VAR
	VAR
		bur_D_Work_CPP_Int : D_Work_CPP_Int;
	END_VAR
	VAR
		bur_PrevZCSigStates_CPP_Int : PrevZCSigStates_CPP_Int;
	END_VAR
	VAR
		bur_ExternalOutputs_CPP_Int : ExternalOutputs_CPP_Int;
	END_VAR
END_FUNCTION_BLOCK