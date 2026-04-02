(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: HALioBase
 * File: HALioSigscal.st
 * Author: froehlichw
 * Created: November 30, 2011
 ********************************************************************
 * Implementation of function HALioSigscal
 *
 * History:
 * 05.01.2012  V0.00.0 froehlichw
 *      (new)  created
 *******************************************************************)

FUNCTION HALioSigscal

	IF (X1 = X2) OR (Y1 = Y2) THEN
		HALioSigscal:= In;
	ELSE
		HALioSigscal:= (Y2 - Y1)*(In - X1)/(X2 - X1) + Y1;
	END_IF;

END_FUNCTION