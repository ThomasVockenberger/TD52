(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: PBC_MFile
 * File: PBC_MFile.fun
 * Author: 502293141
 * Created: October 27, 2014
 ********************************************************************
 * Functions and function blocks of program PBC_MFile
 ********************************************************************)

FUNCTION_BLOCK PBC_Lim
	VAR_INPUT
		reset : BOOL;
		In : REAL; (*Input*)
		Name : STRING[NameSize]; (*Name max 21 Characters*)
		Store : USINT; (*Determines storage*)
		Unit : STRING[UnitSize]; (*Unit max 5 Characters*)
		Co : REAL; (*Conversion factor 1 = no conversion*)
	END_VAR
	VAR_OUTPUT
		Hi : REAL; (*High*)
		Lo : REAL; (*Low*)
	END_VAR
	VAR
		LCRMinMax_Intern : LCRMinMax;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK PBC_In
	VAR_INPUT
		In : REAL; (*Input*)
		Name : STRING[NameSize]; (*Name max 21 Characters*)
		Store : USINT; (*Determines storage*)
		Unit : STRING[UnitSize]; (*Unit max 5 Characters*)
		Co : REAL; (*Conversion factor 1 = no conversion*)
	END_VAR
	VAR_OUTPUT
		Out : REAL; (*Out*)
	END_VAR
END_FUNCTION_BLOCK
