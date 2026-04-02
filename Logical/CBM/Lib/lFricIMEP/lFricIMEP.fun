FUNCTION_BLOCK fFricIMEP
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        In : tFMEPIn; (**)
  END_VAR
  VAR_INPUT
        Para : tFMEPParameter; (**)
  END_VAR
 VAR_OUTPUT
        Out : tFMEPOut; (**)
  END_VAR
 VAR_OUTPUT
        dbgOut : tFMEPDebug; (**)
  END_VAR
  VAR_OUTPUT
        Info : UDINT; (*Model information*)
  END_VAR
	VAR
		bur_B_J920_fric : B_J920_fric;
	END_VAR
	VAR
		bur_DW_J920_fric : DW_J920_fric;
	END_VAR
	VAR
		bur_ExtY_J920_fric : ExtY_J920_fric;
	END_VAR
END_FUNCTION_BLOCK