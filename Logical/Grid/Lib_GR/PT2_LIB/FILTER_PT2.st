(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: FILTER_PT2
 * File: FILTER_PT2.st
 * Author: Perktold
 * Created: June 18, 2020
 ********************************************************************
 * Implementation of FILTER_PT2 Function of library PT2_LIB
 ********************************************************************)

FUNCTION_BLOCK FILTER_PT2
	Out 		:= LREAL_TO_REAL(Out + Tsample/T * x_minus1);
	x_minus1	:= x_minus1 + Tsample/T * (In - y_minus1 - 2 * D * x_minus1);
	y_minus1	:= Out;
END_FUNCTION_BLOCK
