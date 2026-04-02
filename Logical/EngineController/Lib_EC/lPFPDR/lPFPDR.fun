FUNCTION_BLOCK PFPDR
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        in : tPFPDR_In; (**)
  END_VAR
  VAR_INPUT
        par : tPFPDR_Para; (**)
  END_VAR
 VAR_OUTPUT
        out : tPFPDR_Out; (**)
  END_VAR
 VAR_OUTPUT
        dbg : tPFPDR_Dbg; (**)
  END_VAR
	VAR
		bur_BlockIO_AC_PFPDR : BlockIO_AC_PFPDR;
	END_VAR
	VAR
		bur_D_Work_AC_PFPDR : D_Work_AC_PFPDR;
	END_VAR
END_FUNCTION_BLOCK