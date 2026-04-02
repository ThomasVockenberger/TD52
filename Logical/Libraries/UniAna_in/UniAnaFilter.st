(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: UniAna_in
 * File: UniAnaFilter.st
 * Author: froehlichw
 * Created: November 30, 2011
 ********************************************************************
 * Implementation COPIED FROM THE function block HALioFilter
 *
 * History:
 * 14.12.2011  V0.00.0 froehlichw
 *      (new)  created
 *******************************************************************)

FUNCTION_BLOCK xUniAnaFilter

	(* avoid division by 0 *)
	IF (Filter = 0) THEN
		Filter:= 1;
	END_IF;
	mw:= mw + In - Out;
	Out:= mw/UINT_TO_DINT(Filter);

END_FUNCTION_BLOCK