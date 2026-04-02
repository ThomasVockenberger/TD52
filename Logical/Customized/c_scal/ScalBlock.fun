
FUNCTION_BLOCK ScalBlock
	VAR_INPUT
		Type : INT; (*Type of scaling*)
		X : REAL; (*X input value*)
		X1 : REAL; (*X1 input Parameter*)
		X2 : REAL; (*X2 input Parameter*)
		Y1 : REAL; (*Y1 input Parameter*)
		Y2 : REAL; (*Y2 input Parameter*)
	END_VAR
	VAR_OUTPUT
		Y : REAL; (*Y output value*)
		Err : BOOL; (*Error Flag*)
	END_VAR
	VAR
		xLCRLimScal : LCRLimScal; (*scaling with limitation*)
		xLCRScal : LCRScal; (*scaling without limitation*)
	END_VAR
END_FUNCTION_BLOCK
