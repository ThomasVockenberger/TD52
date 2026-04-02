FUNCTION_BLOCK fFSync
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        In : tFsync_Inputs; (*Inputs to Fast synch*)
  END_VAR
  VAR_INPUT
        Perm : tFsync_Perm; (**)
  END_VAR
  VAR_INPUT
        Para : tFsync_Para; (*Inputs to Fast synch*)
  END_VAR
 VAR_OUTPUT
        dbg : tFsync_Debug; (**)
  END_VAR
  VAR_OUTPUT
        iSkipCyl : USINT; (**)
  END_VAR
  VAR_OUTPUT
        bEnabled : BOOL := FALSE; (*True..AutoCode running, FALSE..switch to standard controller*)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_FSync : BlockIO_FSync;
	END_VAR
	VAR
		bur_D_Work_FSync : D_Work_FSync;
	END_VAR
	VAR
		bur_ExternalOutputs_FSync : ExternalOutputs_FSync;
	END_VAR
END_FUNCTION_BLOCK