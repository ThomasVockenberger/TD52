FUNCTION_BLOCK TCB_In
	VAR_INPUT
		rI : REAL; (*Input*)
		iI : UDINT; (*Input*)
		N : STRING[NameSize]; (*Name max 21 Characters*)
		F : USINT; (*Determines storage*)
		U : STRING[UnitSize]; (*Unit max 5 Characters*)
		C : REAL; (*Conversion factor 1 = no conversion*)
	END_VAR
	VAR_OUTPUT
		O : REAL; (*Out*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK TCB_Cnt
	VAR_INPUT
		E : BOOL; (*Counter ++*)
		bDEL : BOOL; (*Reset*)
		iMAX : UINT;
	END_VAR
	VAR_OUTPUT
		O : UINT; (*Out*)
		V : INT; (*Variables*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK TCB_Header
	VAR_INPUT
		aI : UDINT;	(* Address Real Array Input *)
		H : UDINT;	(* Header Address *)
		L : USINT;	(* Real Array Input length *)
		P : USINT;	(* Precision *)
		E : BOOL;	(* Exist *)
		N : STRING[NameSize]; (*Name max 21 Characters*)
		U : STRING[UnitSize]; (*Unit max 5 Characters*)
	END_VAR
	VAR
		iCnt : USINT;
		temp : ARRAY[0..24] OF REAL;
	END_VAR
END_FUNCTION_BLOCK