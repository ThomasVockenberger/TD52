(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: op_state
 * File: op_state.fun
 * Author: 502423184
 * Created: December 4, 2018
 *******************************************************************)

FUNCTION AND_Array : BOOL
	VAR_INPUT
		Adress : UDINT;
		Size : USINT;
	END_VAR
	VAR
		i : USINT;
		Arrayx : ARRAY[0..40] OF BOOL;
	END_VAR
END_FUNCTION

FUNCTION OR_Array : BOOL
	VAR_INPUT
		Adress : UDINT;
		Size : USINT;
	END_VAR
	VAR
		i : USINT;
		Arrayx : ARRAY[0..40] OF BOOL;
	END_VAR
END_FUNCTION

FUNCTION DINT_INC_CNT : DINT
	VAR_INPUT
		Input : DINT;
	END_VAR
END_FUNCTION
