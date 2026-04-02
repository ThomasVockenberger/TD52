

TYPE
	TrStRed_DBG_Bus :  STRUCT   
		rT_CtrlError :  REAL; (*Error between target and actual EG max temperature (degC)*)  
		rCA_IP_Lim_preSat :  REAL; (*relative ITP upper limit before saturation (degCA)*)  
		bInternalLimitAct :  BOOL; (*true, if TrStRed internal saturation limitation active ()*)  
		rCtrl_Int_InputPreGain :  REAL; (*control integrator input before integral gain (degC)*)  
		rPr_Leanox_Dev_filt :  REAL; (*filtered Leanox controller deviation (mbar)*)  
		rIgnVolt_Max_filt :  REAL; (*filtered maximum ignition voltage (kV)*)  
		rCtrl_IntegrInput :  REAL; (*actual control integrator input (degCA/s)*)  
		bSteadyState :  BOOL; (*true, if engine power steady as per TrStRed definition ()*)  
		rCA_LowLimit_Act :  REAL; (*actual control limit TrStRed function - relative ITP (degCA)*)  
	END_STRUCT;

	TrStRed_IN_Bus :  STRUCT   
		bTrStRed_active :  BOOL; (*TrStRed function activation conditions ()*)  
		rP_Norm :  REAL; (*normalized and filtered actual power (%)*)  
		rP_Set_Norm :  REAL; (*normalized power setpoint (%)*)  
		rPr_Leanox_Dev :  REAL; (*Leanox controller deviation (mbar)*)  
		rT_EG_CylMax :  REAL; (*cylinder temperature maximal value (degC)*)  
		rT_EG_MaxLimit :  REAL; (*exhaust gas temperature maximum limit (degC)*)  
		rT_EG_CylAvg :  REAL; (*cylinder temperature average (degC)*)  
		rMisfire_level :  REAL; (*misfire integrator value (%)*)  
		rIgnVolt_Max :  REAL; (*maximum ignition voltage (kV)*)  
		rCA_Ign_UpLim :  REAL; (*highest relative ITP of all cylinders (degCA)*)  
		rCA_IgnP_relAw :  REAL; (*relative ITP feedback (degCA)*)  
		rT_EGbTC :  REAL; (*exhaust gas temperature before turbo charger T3 (degC)*)  
		bThR_RelGas :  BOOL; (*Thermal Reactor auxiliary gas injection ()*)  
		bReset :  BOOL; (*Reset TrStRed function ()*)  
		bCycleReset :  BOOL; (*Reset TrStRed operating cycle ()*)  
	END_STRUCT;

	TrStRed_OUT_Bus :  STRUCT   
		rCA_IP_Lim :  REAL; (*relative ITP upper limit (degCA)*)  
		bCycleStarted :  BOOL; (*TrStRed operating cycle started ()*)  
		bCycleCompleted :  BOOL; (*TrStRed operating cycle completed ()*)  
		bTrStRed_Stop :  BOOL; (*TrStRed function stop mode ()*)  
	END_STRUCT;

	TrStRed_PARA_Bus :  STRUCT   
		rT_EG_Avg_HiLim :  REAL; (*cylinder temperature average high limit (degC)*)  
		rT_EG_Max_LimMarg :  REAL; (*margin from max. cyl. temperature for controller setpoint (degC)*)  
		rIgnVoltMax_Lim :  REAL; (*maximum ignition voltage (kV)*)  
		rT_EGbTC_HiLim :  REAL; (*turbocharger inlet temperature high warning (degC)*)  
		rCA_TrStRed_LowLimit :  REAL; (*control limit TrStRed function - relative ITP (degCA)*)  
		rGain_TrStRed_halfLoadLim :  REAL; (*half load factor for TrStRed function control limit (%)*)  
	END_STRUCT;

	TrStRed_PERM_Bus :  STRUCT   
		rCA_RateLimit :  REAL; (*TrStRed function output rate limiter (degCA/s)*)  
		rMisfire_Lim :  REAL; (*misfire threshold - function internal limitations (%)*)  
		rPr_LxDev_Lim :  REAL; (*Leanox deviation max. threshold - function internal limitations (mbar)*)  
		rFiltConst_LxDev :  REAL; (*filter coefficient PT1 - Leanox deviation - function internal limitations (s)*)  
		rFiltConst_IgnVolt :  REAL; (*filter coefficient PT1 - ignition voltage - function internal limitations (s)*)  
		rIgnVolt_LimMarg :  REAL; (*ignition voltage max exceedance from warning limit - function internal limitations (kV)*)  
		rT_EG_Avg_LimMarg :  REAL; (*cylinder temperature average margin from high limit - function internal limitations (degC)*)  
		rT_EGbTC_LimMarg :  REAL; (*turbocharger inlet temperature margin from high warning - function internal limitations (degC)*)  
		iTimerDelay_Steady :  UINT; (*delay timer for TrStRed steady state (s)*)  
		rP_diffThres_Steady :  REAL; (*normalized power setpoint/actual difference for TrStRed steady state (%)*)  
		rCtrl_ki :  REAL; (*ctrl integral gain (degCA/degC/s)*)  
		iStopTimer :  UINT; (*time delay for TrStRed function stop at reactor temperature target (s)*)  
		rCtrl_kAw :  REAL; (*ctrl antiwind-up gain for integrator (degC/degCA)*)  
		rLimitsReleaseFactor :  REAL; (*factor for releasing internal protection limitations referred to main rate limiter ()*)  
		rT_EG_Max_LimOffset :  REAL; (*offset to max. cyl. temperature referred to limit value - function internal limitations (degC)*)  
		rT_CtrlError_UpLim :  REAL; (*Upper saturation limit for control error (degC)*)  
		rT_CtrlError_LowLim :  REAL; (*Lower saturation limit for control error (degC)*)  
	END_STRUCT;

END_TYPE

TYPE
rtB_Filter_TrStRed : STRUCT
	Switch : REAL;
END_STRUCT;
rtDW_Filter_TrStRed : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_TON_TrStRed : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON_TrStRed : STRUCT
	DiscreteTimeIntegrator_DSTATE : UINT;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
BlockIO_TrStRed : STRUCT
	BusInput1 : TrStRed_PERM_Bus;
	BusInput2 : TrStRed_IN_Bus;
	BusInput : TrStRed_PARA_Bus;
	UnitDelay : UDINT;
	TON_k : rtB_TON_TrStRed;
	TON : rtB_TON_TrStRed;
	Filter1 : rtB_Filter_TrStRed;
	Filter : rtB_Filter_TrStRed;
END_STRUCT;
D_Work_TrStRed : STRUCT
	ITCtrUi : REAL;
	Delay_DSTATE : REAL;
	Delay_DSTATE_b : REAL;
	UnitDelay1_DSTATE : REAL;
	UnitDelay_DSTATE : UDINT;
	UnitDelay_DSTATE_j : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	icLoad : USINT;
	icLoad_l : USINT;
	Memory_PreviousInput : BOOL;
	Memory_PreviousInput_o : BOOL;
	Memory_PreviousInput_l : BOOL;
	TON_k : rtDW_TON_TrStRed;
	TON : rtDW_TON_TrStRed;
	Filter1 : rtDW_Filter_TrStRed;
	Filter : rtDW_Filter_TrStRed;
END_STRUCT;
PrevZCSigStates_TrStRed : STRUCT
	Delay_Reset_ZCE : USINT;
	Delay_Reset_ZCE_l : USINT;
END_STRUCT;
rtC_Filter_TrStRed : STRUCT
	Conversion : REAL;
END_STRUCT;
ConstBlockIO_TrStRed : STRUCT
	Filter1 : rtC_Filter_TrStRed;
	Filter : rtC_Filter_TrStRed;
END_STRUCT;
ConstParam_TrStRed : STRUCT
	pooled10 : ARRAY[0..15] OF BOOL;
END_STRUCT;
ExternalInputs_TrStRed : STRUCT
	In : TrStRed_IN_Bus;
	Para : TrStRed_PARA_Bus;
	Perm : TrStRed_PERM_Bus;
END_STRUCT;
ExternalOutputs_TrStRed : STRUCT
	Out : TrStRed_OUT_Bus;
	dbg : TrStRed_DBG_Bus;
END_STRUCT;
tag_RTM_TrStRed : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_TrStRed;
	prevZCSigState : REFERENCE TO PrevZCSigStates_TrStRed;
	inputs : REFERENCE TO ExternalInputs_TrStRed;
	outputs : REFERENCE TO ExternalOutputs_TrStRed;
	dwork : REFERENCE TO D_Work_TrStRed;
END_STRUCT;
RT_MODEL_TrStRed : tag_RTM_TrStRed;

END_TYPE
TYPE
END_TYPE