
FUNCTION_BLOCK ManAuxCtr
	VAR_INPUT
		VisuCmdButton : BOOL;
		VisuCmdSetpoint : REAL;
		MaxCmdTime : TIME;
		GnlRel : BOOL;
	END_VAR
	VAR_OUTPUT
		COn : BOOL;
		COf : BOOL;
		SetVal : REAL;
	END_VAR
	VAR
		xRS : SR;
		xTOF : TOF;
		xR_TRIG : R_TRIG;
		xF_TRIG : F_TRIG;
		xLCRPT1 : LCRPT1;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK RedPump
	VAR_INPUT
		Enable : BOOL; (*enable redundant pump control*)
		bDemGnl : BOOL; (*general pump demand*)
		bPump1_Op : BOOL; (*pump 1 operating feedback*)
		bPump2_Op : BOOL; (*pump 2 operating feedback*)
		bMonActive : BOOL; (*monitoring active*)
		tiNoFB_Timeout : TIME; (*timeout of feedback for pump operation*)
		bReadMsg_noFB : BOOL; (*read redundant pump failure*)
		iReadPumpIdx_noFB : INT; (*read index of defective/irresponsive pump*)
	END_VAR
	VAR_OUTPUT
		bPump1_Dem : BOOL; (*demand for redundant pump 1*)
		bPump2_Dem : BOOL; (*demand for redundant pump 2*)
		bSetMsg_noFB : BOOL; (*trigger redundant pump failure*)
		iSetPumpIdx_noFB : INT; (*set index of defective/irresponsive pump*)
	END_VAR
	VAR
		iActive_Pump : USINT; (*currently demanded pump: 0->no pump demanded*)
		xTON_noFB : TON; (*TON no pump operation feedback*)
		xR_TRIG_DemGnl : R_TRIG; (*rising edge general demand*)
		xR_TRIG_noFB : R_TRIG; (*rising edge no operation feedback*)
		xF_TRIG_ReadMsg_noFB : F_TRIG; (*falling edge acknowledged warning*)
	END_VAR
END_FUNCTION_BLOCK
