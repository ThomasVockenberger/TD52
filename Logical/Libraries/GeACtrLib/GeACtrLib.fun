
FUNCTION_BLOCK GeACtr
	VAR_INPUT
		pParameter : UDINT; (*adress from parameter structure of the user*)
		pInput : UDINT; (*adress from input structure of the user*)
		pOutput : UDINT; (*adress from output structure of the user*)
	END_VAR
	VAR
		tParameter : REFERENCE TO _tGeACtrPara; (*pointer to parameter structure of the user*)
		tInput : REFERENCE TO _tGeACtrIn; (*pointer to input structure of the user*)
		tOutput : REFERENCE TO _tGeACtrOut; (*pointer to output structure of the user*)
		tProcPar : REFERENCE TO lcrpid_procPar_typ; (*pointer to the parameter structure of LCRPIDTune*)
		pYi1 : REFERENCE TO LREAL; (*pointer to the internal I - component of LCRPIDTune*)
		xLCRPWM_up : LCRPWM; (*LCRPWM fub for Step_up*)
		xLCRPWM_down : LCRPWM; (*LCRPWM fub for Step_down*)
		xLCRPIDTune : LCRPIDTune; (*LCRPIDTune fub*)
		xLCRPID : LCRPID; (*LCRPID fub*)
		xLCRRamp_WSet : LCRRamp; (*LCRRamp fub*)
		xLCRRamp_Y : LCRRamp; (*LCRRamp fub*)
		tAddPar : lcrpid_tune_addpar_typ; (*addition parameter to LCRPIDTune*)
		rW : REAL; (*actual W value*)
		rWSet : REAL; (*internal W depending on W_ext_Active*)
		rY : REAL; (*actual Y value*)
		bPWM_up_enable : BOOL; (*enable LCRPWM fub for Step_up*)
		bPWM_down_enable : BOOL; (*enable LCRPWM fub for Step_down*)
		bTune_enable : BOOL; (*enable LCRPIDTune fub*)
		usPWM_status : UINT; (*status of LCRPWM up and LCRPWM down fub*)
		usTune_status : UINT; (*status of the tuning (see status list)*)
		usPID_status : UINT; (*status of LCRPID fub*)
		bTune_active : BOOL; (*TRUE: tuning active*)
		bTune_save : BOOL; (*TRUE: tuning finished and parameters can be saved*)
		bAuto : BOOL; (*TRUE: automatic mode*)
		bMan : BOOL; (*TRUE: manual mode*)
		bSafe1 : BOOL; (*TRUE: Y_block active*)
		bSafe2 : BOOL; (*TRUE: Y_set active*)
		rWOld : REAL; (*temp. variable to reset usTune_status*)
		rKpOld : REAL; (*temp. variable to reset usTune_status*)
		rTnOld : REAL; (*temp. variable to reset usTune_status*)
		rTvOld : REAL; (*temp. variable to reset usTune_status*)
		rYMax : REAL; (*internal y max*)
		rYMin : REAL; (*internal y min*)
		rYOld : REAL; (*set y to y  old after stop of the tuning*)
		rYMinOld : REAL; (*temp. variable to reset usTune_status*)
		rYMaxOld : REAL; (*temp. variable to reset usTune_status*)
		rYMinintOld : REAL; (*temp. variable to reset usTune_status*)
		rYMaxintOld : REAL; (*temp. variable to reset usTune_status*)
		rXMinOld : REAL; (*temp. variable to reset usTune_status*)
		rXMaxOld : REAL; (*temp. variable to reset usTune_status*)
		rDeadbandOld : REAL; (*temp. variable to reset usTune_status*)
		rDYMaxOld : REAL; (*temp. variable to reset usTune_status*)
		bTunePIDOld : BOOL; (*temp. variable to reset usTune_status*)
		bTunePIOld : BOOL; (*temp. variable to reset usTune_status*)
		zzEdge00000 : BOOL; (*temp. edge variable*)
		zzEdge00001 : BOOL; (*temp. edge variable*)
		zzEdge00002 : BOOL; (*temp. edge variable*)
		zzEdge00003 : BOOL; (*temp. edge variable*)
		zzEdge00004 : BOOL; (*temp. edge variable*)
		xR_TRIG_Retrigger : R_TRIG;
		xR_TRIG_enable : R_TRIG;
		xLCRContinServo : LCRContinServo;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION xChkStat : BOOL (* returns TRUE if status is between 0 and 65534  *)
	VAR_INPUT
		usActStatus : UINT; (*status*)
	END_VAR
END_FUNCTION

FUNCTION xResErr : BOOL (*reset the enable if an error happened*)
	VAR_INPUT
		pEnable : UDINT; (*adress: enable*)
		usStatus : UINT; (*status*)
	END_VAR
	VAR
		bEnable : REFERENCE TO BOOL; (*pointer*)
	END_VAR
END_FUNCTION

FUNCTION xResChg : BOOL (*reset the enable if parameter changed*)
	VAR_INPUT
		pEnable : UDINT; (*adress: enable*)
		rAct : REAL; (*actual value*)
		rOld : REAL; (*old value*)
	END_VAR
	VAR
		bEnable : REFERENCE TO BOOL; (*pointer*)
	END_VAR
END_FUNCTION

FUNCTION xCalMid : REAL (*returns the middle of min and max value*)
	VAR_INPUT
		rMin : REAL; (*minimum value*)
		rMax : REAL; (*maximum value*)
	END_VAR
END_FUNCTION

FUNCTION xTunReq : UDINT (*returns the tuning request*)
	VAR_INPUT
		bPI : BOOL; (*PI byte*)
		bPID : BOOL; (*PID byte*)
		ssQuality : INT; (*tuning quality*)
		bInvert : BOOL; (*invert variable*)
	END_VAR
END_FUNCTION
