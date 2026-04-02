(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: HALioBase
 * File: HALioFilterR.st
 * Author: froehlichw
 * Created: November 30, 2011
 ********************************************************************
 * Implementation of function block HALioFilterR
 *
 * History:
 * 14.12.2011  V0.00.0 froehlichw
 *      (new)  created
 * 17.01.2013  V0.12.1 froehlichw
 *      (fix)  warning 1292: Implicit conversion from ....
 * 02.02.2022  V0.21.0 Schmid
 *    (added)  Reset
 * 25.01.2023  V0.22.0 Perktold
 *    (change) Filter datatype UINT to REAL
 *******************************************************************)

FUNCTION_BLOCK HALioFilterR

	(* avoid division by 0 and NaN *)
	IF (Filter < 1) THEN
		Filter:= 1;
	END_IF;
	
	IF Reset THEN
		mw:= REAL_TO_LREAL(In * Filter);
	ELSE
		mw:= mw + In - Out;
	END_IF;
	
	Out:= LREAL_TO_REAL(mw/REAL_TO_LREAL(Filter));

END_FUNCTION_BLOCK