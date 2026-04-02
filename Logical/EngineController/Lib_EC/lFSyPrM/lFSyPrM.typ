

TYPE
	tFSyPrM_DBG :  STRUCT   
		iRetardCounter :  UINT; (* (-)*)  
		rSwitchSurf :  REAL; (* (-)*)  
		Sf1 :  BOOL; (* (-)*)  
		Sf2 :  BOOL; (* (-)*)  
		H3 :  BOOL; (* (-)*)  
		H4 :  BOOL; (* (-)*)  
		rSmodSlid :  REAL; (* (-)*)  
		iCounterSwitch :  UINT; (* (-)*)  
		bEna :  BOOL; (* (-)*)  
		iCtrSel :  SINT; (* (-)*)  
		rN_Set :  REAL; (*Speed set point (rpm)*)  
		rN_Eng :  REAL; (*Actual speed (rpm)*)  
		bSpdSettled :  BOOL; (* (-)*)  
		rN_dot :  REAL; (*Engine speed derivative (rpm/s)*)  
	END_STRUCT;

	tFSyPrM_IN :  STRUCT   
		bGCB_ON :  BOOL; (*Generator circuit breaker closed (-)*)  
		rN_Eng :  REAL; (*Engine speed (rpm)*)  
		rF_MMD :  REAL; (*Generator frequency (Hz)*)  
		rF_MMD_BusBar :  REAL; (*Bus bar frequency (Hz)*)  
		rAng_MMD_Diff :  REAL; (*Electric angle (deg)*)  
		bFastSync :  BOOL; (*Fast synchronization activation (-)*)  
		bReset :  BOOL; (*Reset library (-)*)  
	END_STRUCT;

	tFSyPrM_PARA :  STRUCT   
		rF_Nom :  REAL; (*Nominal generator frequency (Hz)*)  
		rN_EngNom :  REAL; (*Nominal engine speed (rpm)*)  
	END_STRUCT;

	tFSyPrM_PERM :  STRUCT   
		bSpeedSet_ena :  BOOL; (*Select the setpoint (1: constant speed, 0: grid frequency) (-)*)  
		iCtrSel :  SINT; (*Control selection. 1-Std skip firing, 2-Time optimal, 3-Time optimal with constraints, 4-Fuel and time optimal (-)*)  
		rAngleSetDeg :  REAL; (*Electric angle setpoint (deg)*)  
		rRelaxAngleDeg :  REAL; (*Relaxation band for the electric angle setpoint (deg)*)  
		rWeightFuel :  REAL; (*Weighting (high->time, low->fuel) (-)*)  
		rHystOptimal :  REAL; (*Band around switching surface (nonnegative >=0) (-)*)  
		rCA_ITPRetardMax :  REAL; (*Maximum ITP retard angle (<=20) (CAD)*)  
		rCA_ITPRetardMin :  REAL; (*Minimum ITP retard angle (>=0) (CAD)*)  
		rTi_FiltF :  REAL; (*Filter constant for grid frequency (s)*)  
		rTi_Filtn :  REAL; (*Filter constant for engine speed (s)*)  
		rN_enableNorm :  REAL; (*Engine speed normalized to enable fast sync controller (-)*)  
		rN_dot_release :  REAL; (*Engine speed derivation threshold (-)*)  
		rN_SpdSettled :  REAL; (*Engine speed activation threshold (rpm)*)  
		rN_SpdDevMax :  REAL; (*Maximum allowed speed deviation (rpm)*)  
		rTi_FastSync :  REAL; (*Switch over to standard controller after this time (s)*)  
		bF_act_ena :  BOOL; (*Use generator frequency as actual value (-)*)  
	END_STRUCT;

END_TYPE

TYPE
BlockIO_FSyPrM : STRUCT
	BusInput2 : tFSyPrM_PERM;
	BusInput : tFSyPrM_IN;
	BusInput1 : tFSyPrM_PARA;
	UnitDelay : UDINT;
	bEnabled : BOOL;
END_STRUCT;
D_Work_FSyPrM : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE_g : REAL;
	DiscreteTimeIntegrator_DSTATE_k : REAL;
	UnitDelay_DSTATE : UDINT;
	CA_retarded : REAL;
	retardcounter : UINT;
	Count_Switch : UINT;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_h : SINT;
	DiscreteTimeIntegrator_PrevRe_d : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	DiscreteTimeIntegrator_IC_LOA_d : USINT;
	DiscreteTimeIntegrator_IC_LO_dn : USINT;
	ssr : BOOL;
	spd_DevExc : BOOL;
	spd_settled : BOOL;
	CA_retarded_not_empty : BOOL;
END_STRUCT;
ExternalInputs_FSyPrM : STRUCT
	In : tFSyPrM_IN;
	Para : tFSyPrM_PARA;
	Perm : tFSyPrM_PERM;
END_STRUCT;
ExternalOutputs_FSyPrM : STRUCT
	rRetardITP : REAL;
	dbg : tFSyPrM_DBG;
END_STRUCT;
tag_RTM_FSyPrM : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_FSyPrM;
	inputs : REFERENCE TO ExternalInputs_FSyPrM;
	outputs : REFERENCE TO ExternalOutputs_FSyPrM;
	dwork : REFERENCE TO D_Work_FSyPrM;
END_STRUCT;
RT_MODEL_FSyPrM : tag_RTM_FSyPrM;
END_TYPE
TYPE
END_TYPE