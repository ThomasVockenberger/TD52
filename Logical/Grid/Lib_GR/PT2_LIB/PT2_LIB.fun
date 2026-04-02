(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: PT2_LIB
 * File: PT2_LIB.fun
 * Author: Perktold
 * Created: June 18, 2020
 ********************************************************************
 * Functions and function blocks of library PT2_LIB
 ********************************************************************)

FUNCTION_BLOCK FILTER_PT2
	VAR_INPUT
		In : REAL;
		T : REAL; (* Filterzeitkonstante [s] *)
		D : REAL; (* Daempfung *)
		Tsample : REAL; (* Samplingzeit in [s] *)
	END_VAR
	VAR_OUTPUT
		Out : REAL;
	END_VAR
	VAR
		x_minus1 : LREAL;
		y_minus1 : LREAL;
	END_VAR
END_FUNCTION_BLOCK
