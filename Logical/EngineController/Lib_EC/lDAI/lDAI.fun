FUNCTION_BLOCK fDAI
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        In : DAI_In_Bus; (**)
  END_VAR
  VAR_INPUT
        Para : DAI_Para_Bus; (**)
  END_VAR
  VAR_INPUT
        Perm : DAI_Perm_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Out : DAI_Out_Bus; (**)
  END_VAR
  VAR_OUTPUT
        dbg : DAI_Dbg_Bus; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT := 0; (**)
  END_VAR
	VAR
		bur_BlockIO_DAI : BlockIO_DAI;
	END_VAR
	VAR
		bur_D_Work_DAI : D_Work_DAI;
	END_VAR
	VAR
		bur_DAI : tag_RTM_DAI;
	END_VAR
END_FUNCTION_BLOCK