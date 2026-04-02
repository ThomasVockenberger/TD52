FUNCTION_BLOCK fTExhMon
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        Para : tTExhMon_PARA; (**)
  END_VAR
  VAR_INPUT
        In : tTExhMon_IN; (**)
  END_VAR
 VAR_OUTPUT
        Out : tTExhMon_OUT; (**)
  END_VAR
 VAR_OUTPUT
        Dbg : tTExhMon_DBG; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_TExhMon : BlockIO_TExhMon;
	END_VAR
	VAR
		bur_D_Work_TExhMon : D_Work_TExhMon;
	END_VAR
	VAR
		bur_PrevZCSigStates_TExhMon : PrevZCSigStates_TExhMon;
	END_VAR
	VAR
		bur_ExternalOutputs_TExhMon : ExternalOutputs_TExhMon;
	END_VAR
END_FUNCTION_BLOCK