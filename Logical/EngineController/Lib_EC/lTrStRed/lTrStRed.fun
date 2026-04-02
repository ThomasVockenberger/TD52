FUNCTION_BLOCK fTrStRed
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        Perm : TrStRed_PERM_Bus; (**)
  END_VAR
  VAR_INPUT
        In : TrStRed_IN_Bus; (**)
  END_VAR
  VAR_INPUT
        Para : TrStRed_PARA_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Out : TrStRed_OUT_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Dbg : TrStRed_DBG_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT := 0; (**)
  END_VAR
	VAR
		bur_BlockIO_TrStRed : BlockIO_TrStRed;
	END_VAR
	VAR
		bur_PrevZCSigStates_TrStRed : PrevZCSigStates_TrStRed;
	END_VAR
	VAR
		bur_ExternalInputs_TrStRed : ExternalInputs_TrStRed;
	END_VAR
	VAR
		bur_ExternalOutputs_TrStRed : ExternalOutputs_TrStRed;
	END_VAR
	VAR
		bur_D_Work_TrStRed : D_Work_TrStRed;
	END_VAR
	VAR
		bur_TrStRed : tag_RTM_TrStRed;
	END_VAR
END_FUNCTION_BLOCK