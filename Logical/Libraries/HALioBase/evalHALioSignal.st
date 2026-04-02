(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: HALioBase
 * File: evalHALioSignal.st
 * Author: froehlichw
 * Created: November 30, 2011
 ********************************************************************
 * Implementation of function evalHALioSignal
 *
 * History:
 *******************************************************************)

FUNCTION evalHALioSignal
	evalHALioSignal := 0;

	IF (ActNumIoChannels <> 0) THEN
		FOR idx:= 0 TO (ActNumIoChannels - 1) DO
				
			xHALioSignal[idx].ParOK := ParOK;
			xHALioSignal[idx].HwOK  := HwOK;
			xHALioSignal[idx].CycleTimeMs := CycleTimeMs;
			xHALioSignal[idx]();
				
			IF (xHALioSignal[idx].status <> halERR_NO_ERROR) THEN
				SignalError		:= xHALioSignal[idx].status;
				SignalErrorIdx	:= idx;
			ELSE
				IF (SignalErrorIdx = idx) THEN
					SignalError	:= 0;
				END_IF;
			END_IF;
			
		END_FOR;
	END_IF;

END_FUNCTION