FUNCTION_BLOCK fSAFI_VCD
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR
  VAR_INPUT
        In : tSAFI_VCD_IN; (**)
  END_VAR
  VAR_INPUT
        Para : tSAFI_VCD_PARA; (**)
  END_VAR
  VAR_OUTPUT
        dbg : tSAFI_VCD_DBG; (**)
  END_VAR
  VAR_OUTPUT
        Out : tSAFI_VCD_OUT; (**)
  END_VAR
  VAR_OUTPUT
        Version : UDINT; (**)
  END_VAR
	VAR
		bur_BlockIO_SAFI_VCD : BlockIO_SAFI_VCD;
	END_VAR
	VAR
		bur_ExternalInputs_SAFI_VCD : ExternalInputs_SAFI_VCD;
	END_VAR
	VAR
		bur_ExternalOutputs_SAFI_VCD : ExternalOutputs_SAFI_VCD;
	END_VAR
	VAR
		bur_D_Work_SAFI_VCD : D_Work_SAFI_VCD;
	END_VAR
	VAR
		bur_SAFI_VCD : tag_RTM_SAFI_VCD;
	END_VAR
END_FUNCTION_BLOCK