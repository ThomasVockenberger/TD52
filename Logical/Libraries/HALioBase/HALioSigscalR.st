(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: HALioBase
 * File: HALioSigscalR.st
 * Author: froehlichw
 * Created: November 30, 2011
 ********************************************************************
 * Implementation of function HALioSigscalR
 *
 * History:
 * 05.01.2012  V0.00.0 froehlichw
 *      (new)  created
 * 17.01.2013  V0.12.1 froehlichw
 *      (fix)  warning 1292: Implicit conversion from ....
 *******************************************************************)

FUNCTION HALioSigscalR

	IF (X1 = X2) OR (Y1 = Y2) THEN
		HALioSigscalR:= DINT_TO_REAL(In);
	ELSE
		HALioSigscalR:= (Y2 - Y1)/DINT_TO_REAL(X2 - X1)*DINT_TO_REAL(In - X1) + Y1;
	END_IF;

END_FUNCTION