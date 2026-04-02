(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: UniAna_in
 * File: UniAnaFilterR.st
 * Author: froehlichw
 * Created: November 30, 2011
 ********************************************************************
 * Implementation COPIED OF FROM function block HALioFilterR
 *
 * History:
 * 14.12.2011  V0.00.0 froehlichw
 *      (new)  created
 *******************************************************************)

FUNCTION_BLOCK xUniAnaFilterR

	(* avoid division by 0 *)
	IF (Filter = 0) THEN
		Filter:= 1;
	END_IF;
	mw:= mw + In - Out;
	Out:= mw/UINT_TO_REAL(Filter);

END_FUNCTION_BLOCK