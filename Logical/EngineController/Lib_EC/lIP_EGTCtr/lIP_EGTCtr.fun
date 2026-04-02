FUNCTION_BLOCK fIP_EGTCtr
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        in : tEGTCtr_In; (**)
  END_VAR
  VAR_INPUT
        perm : tEGTCtr_Perm; (**)
  END_VAR
 VAR_OUTPUT
        out : tEGTCtr_Out; (**)
  END_VAR
	VAR
		bur_BlockIO_IP_EGTCtr : BlockIO_IP_EGTCtr;
	END_VAR
	VAR
		bur_D_Work_IP_EGTCtr : D_Work_IP_EGTCtr;
	END_VAR
END_FUNCTION_BLOCK