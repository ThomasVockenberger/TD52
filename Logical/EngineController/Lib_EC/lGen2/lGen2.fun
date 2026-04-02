FUNCTION_BLOCK Gen2
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        IN : tGen2In; (**)
  END_VAR
  VAR_INPUT
        Para : tGen2Parameter; (*Gen2 parameter structure*)
  END_VAR
  VAR_OUTPUT
        dbgOut : tGen2Debug; (**)
  END_VAR
  VAR_OUTPUT
        OUT : tGen2Out; (**)
  END_VAR
  VAR_INPUT
        rLam_BrakeEffEst : REAL := 1.4; (*lambda used for estimate of brake eff generation*)
  END_VAR
  VAR_OUTPUT
        rEtaBrakeEst : REAL := 0; (*estimate of break efficiency*)
  END_VAR
  VAR_OUTPUT
        Version : UDINT := 0; (*Version number*)
  END_VAR
	VAR
		bur_BlockIO_Gen2_ref : BlockIO_Gen2_ref;
	END_VAR
	VAR
		bur_PrevZCSigStates_Gen2_ref : PrevZCSigStates_Gen2_ref;
	END_VAR
	VAR
		bur_ExternalOutputs_Gen2_ref : ExternalOutputs_Gen2_ref;
	END_VAR
	VAR
		bur_D_Work_Gen2_ref : D_Work_Gen2_ref;
	END_VAR
	VAR
		bur_Gen2_ref : tag_RTM_Gen2_ref;
	END_VAR
END_FUNCTION_BLOCK