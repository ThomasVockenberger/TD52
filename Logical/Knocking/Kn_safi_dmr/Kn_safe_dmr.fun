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

FUNCTION SCALE : REAL
	VAR_INPUT
		x : REAL;
		x0 : REAL;
		x1 : REAL;
		y0 : REAL;
		y1 : REAL;
	END_VAR
END_FUNCTION

FUNCTION TIME_TO_SEC : REAL (* Returns the Time value in seconds*)
	VAR_INPUT
		in : TIME;
	END_VAR
END_FUNCTION
