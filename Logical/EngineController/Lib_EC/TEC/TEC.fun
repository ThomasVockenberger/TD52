(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: TEC
 * File: TEC.fun
 * Author: CaksM
 * Created: Dezember 09, 2015
 ********************************************************************
 * Functions and function blocks of library TEC
 ********************************************************************)

FUNCTION TIME_TO_SEC : REAL (* Returns the Time value in seconds*)
	VAR_INPUT
		in : TIME;
	END_VAR
END_FUNCTION

FUNCTION Bank_AB : REAL
	VAR_INPUT
		A : REAL;
		B : REAL;
		bA : BOOL;
		bB : BOOL;
	END_VAR
END_FUNCTION

FUNCTION Bank_A : REAL
	VAR_INPUT
		A : REAL;
		B : REAL;
		bA : BOOL;
		bB : BOOL;
	END_VAR
END_FUNCTION

FUNCTION Bank_B : REAL
	VAR_INPUT
		A : REAL;
		B : REAL;
		bA : BOOL;
		bB : BOOL;
	END_VAR
END_FUNCTION