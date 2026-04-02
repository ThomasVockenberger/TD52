(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: blackstart
 * File: blackstart.fun
 * Author: 212426533
 * Created: November 29, 2023
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
