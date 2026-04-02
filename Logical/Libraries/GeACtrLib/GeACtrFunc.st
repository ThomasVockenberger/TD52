(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: 
 * File: GeACtrFunc.st
 * Author: maierm
 * Created: May 22, 2012
 *******************************************************************)


(* ******************************************************************
 * History:
 * 
 * V0.1.0		22-05-2012	maierm, generated
 *
 *
 *
 *******************************************************************)


(* returns the middle of min and max value *)
FUNCTION xCalMid
	
	xCalMid := rMin + (rMax - rMin) / 2;
	
END_FUNCTION


(* returns TRUE if status is between 0 and 65534  *)
FUNCTION xChkStat
	
	IF (usActStatus <> 0 AND usActStatus <> 65534) THEN	
		xChkStat := TRUE;
	ELSE
		xChkStat := FALSE;
	END_IF

END_FUNCTION


(* switch off the enable if parameter changed *)
FUNCTION xResChg
	
	bEnable ACCESS pEnable;	
	
	IF (rAct <> rOld) THEN	(* check if old value is different to actual value *)
		bEnable := FALSE;	(* reset *)
	END_IF
	
	xResChg;
	
END_FUNCTION


(* reset the enable if an error happened *)
FUNCTION xResErr
	
	bEnable ACCESS pEnable;
	
	IF (usStatus >= 12025 AND usStatus <> 65534) THEN	(* switch off enable *)
		bEnable := FALSE;
	END_IF
	
	xResErr;
	
END_FUNCTION


(* returns the tuning request *)
FUNCTION xTunReq
	
	xTunReq := 0;
	xTunReq := xTunReq + LCRPID_TUNE_REQU_OSCILLATE;	(* oscillation *)
	
	IF (bInvert = TRUE) THEN
		xTunReq := xTunReq + LCRPID_TUNE_REQU_DIR_NEG;		(* negative direction *)
	ELSE
		xTunReq := xTunReq + LCRPID_TUNE_REQU_DIR_POS;		(* positive direction *)
	END_IF
	
	IF (bPI = TRUE) THEN 		
		IF (bPID = TRUE) THEN	(* PID tuning *)
			xTunReq := xTunReq + LCRPID_TUNE_REQU_PID;
		ELSE					(* PI tuning *)
			xTunReq := xTunReq + LCRPID_TUNE_REQU_PI;
		END_IF
	ELSE						(* P tuning *)
		xTunReq := xTunReq + LCRPID_TUNE_REQU_P;	
	END_IF
	
	IF (ssQuality = 0) THEN		(* 1 try - 3 periods *)
		xTunReq := xTunReq + LCRPID_TUNE_REQU_OSC_1 + LCRPID_TUNE_REQU_PER_3;	
	ELSIF (ssQuality = 1) THEN	(* 2 tries - 4 periods *)
		xTunReq := xTunReq + LCRPID_TUNE_REQU_OSC_2 + LCRPID_TUNE_REQU_PER_4;	
	ELSIF (ssQuality = 2) THEN	(* 3 tries - 5 periods *)
		xTunReq := xTunReq + LCRPID_TUNE_REQU_OSC_3 + LCRPID_TUNE_REQU_PER_5;	
	END_IF

END_FUNCTION














