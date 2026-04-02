(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: HALioBase
 * File: HALioFilter.st
 * Author: froehlichw
 * Created: November 30, 2011
 ********************************************************************
 * Implementation of function block HALioFilter
 *
 * History:
 * 14.12.2011  V0.00.0 froehlichw
 *      (new)  created
 * 02.02.2022  V0.21.0 Schmid
 *    (added)  Reset
 *******************************************************************)

FUNCTION_BLOCK HALioFilter

	(* avoid division by 0 *)
	IF (Filter = 0) THEN
		Filter:= 1;
	END_IF;
	
	IF Reset THEN
		mw:= In * UINT_TO_DINT(Filter);
	ELSE
		mw:= mw + In - Out;
	END_IF;
	
	Out:= mw/UINT_TO_DINT(Filter);

END_FUNCTION_BLOCK