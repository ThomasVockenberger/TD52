(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: HALioBase
 * File: HALioSigscalRInv.st
 * Author: froehlichw
 * Created: November 30, 2011
 ********************************************************************
 * Implementation of function HALioSigscalRInv
 *
 * History:
 * 05.01.2012  V0.00.0 froehlichw
 *      (new)  created
 * 17.01.2013  V0.12.1 froehlichw
 *      (fix)  warning 1292: Implicit conversion from ....
 *******************************************************************)

FUNCTION HALioSigscalRInv

	IF (X1 = X2) OR (Y1 = Y2) THEN
		HALioSigscalRInv:= REAL_TO_DINT(In);
	ELSE
		HALioSigscalRInv:= REAL_TO_DINT(DINT_TO_REAL(Y2 - Y1)/(X2 - X1)*(In - X1)) + Y1;
	END_IF;

END_FUNCTION