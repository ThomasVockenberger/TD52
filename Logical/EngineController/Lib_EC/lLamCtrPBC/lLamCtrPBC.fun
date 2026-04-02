FUNCTION_BLOCK fLamCtrPBC
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        In : LamCtrPBC_IN_Bus; (**)
  END_VAR
  VAR_INPUT
        Para : LamCtrPBC_PARA_Bus; (**)
  END_VAR
  VAR_INPUT
        Perm : LamCtrPBC_PERM_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Out : LamCtrPBC_OUT_Bus; (**)
  END_VAR
  VAR_OUTPUT
        dbg : LamCtrPBC_DBG_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT := 0; (**)
  END_VAR
	VAR
		bur_BlockIO_LamCtrPBC : BlockIO_LamCtrPBC;
	END_VAR
	VAR
		bur_PrevZCSigStates_LamCtrPBC : PrevZCSigStates_LamCtrPBC;
	END_VAR
	VAR
		bur_ExternalInputs_LamCtrPBC : ExternalInputs_LamCtrPBC;
	END_VAR
	VAR
		bur_ExternalOutputs_LamCtrPBC : ExternalOutputs_LamCtrPBC;
	END_VAR
	VAR
		bur_D_Work_LamCtrPBC : D_Work_LamCtrPBC;
	END_VAR
	VAR
		bur_LamCtrPBC : tag_RTM_LamCtrPBC;
	END_VAR
END_FUNCTION_BLOCK