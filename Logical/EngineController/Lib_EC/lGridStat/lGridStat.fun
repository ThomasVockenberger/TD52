FUNCTION_BLOCK fGridStat
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        Para : GridStatusDetection_PARA_Bus; (**)
  END_VAR
  VAR_INPUT
        In : GridStatusDetection_IN_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Out : GridStatusDetection_OUT_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Dbg : GridStatusDetection_DBG_Bus; (**)
  END_VAR
  VAR_INPUT
        Perm : GridStatusDetection_PERM_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT := 0; (**)
  END_VAR
	VAR
		bur_BlockIO_GridStat : BlockIO_GridStat;
	END_VAR
	VAR
		bur_PrevZCSigStates_GridStat : PrevZCSigStates_GridStat;
	END_VAR
	VAR
		bur_ExternalOutputs_GridStat : ExternalOutputs_GridStat;
	END_VAR
	VAR
		bur_D_Work_GridStat : D_Work_GridStat;
	END_VAR
	VAR
		bur_GridStat : tag_RTM_GridStat;
	END_VAR
END_FUNCTION_BLOCK