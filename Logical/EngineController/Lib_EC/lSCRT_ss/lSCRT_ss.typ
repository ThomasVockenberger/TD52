
TYPE
	SCRT_ss_DBG_Bus : 	STRUCT 
		bss_LXdev : BOOL; (* ()*)
		bss_P : BOOL; (* ()*)
		bss_noDelay : BOOL; (* ()*)
	END_STRUCT;
	SCRT_ss_IN_Bus : 	STRUCT 
		rP_Set_Norm : REAL; (*Reset filter (p.u.)*)
		rPr_Leanox_Dev : REAL; (*Leanox controller deviaition (bar)*)
		bEna : BOOL; (*Enable Feature ()*)
	END_STRUCT;
	SCRT_ss_OUT_Bus : 	STRUCT 
		bSCRT_ss : BOOL; (*steady state ()*)
	END_STRUCT;
	SCRT_ss_PERM_Bus : 	STRUCT 
		rTi_Filt_Pset : REAL; (*Filter time constant for power setpoint (sec)*)
		rTi_Filt_LXdev : REAL; (*Filter teime constatn for leanox deviation (sec)*)
		rThreshold_Pset_ss : REAL; (*steady state threshold Pset (p.u.)*)
		rThreshold_LXdev_ss : REAL; (*steady state threshold leanox deviation (bar)*)
		rTi_Delay_ss : REAL; (*steady state threshold leanox deviation (sec)*)
	END_STRUCT;
	BlockIO_SCRT_ss : 	STRUCT 
		BusInput1 : SCRT_ss_PERM_Bus;
		BusInput2 : SCRT_ss_IN_Bus;
		BusConversion_InsertedFor_BusOu : SCRT_ss_OUT_Bus;
		BusConversion_InsertedFor_Bus_d : SCRT_ss_DBG_Bus;
		UnitDelay : UDINT;
	END_STRUCT;
	D_Work_SCRT_ss : 	STRUCT 
		DiscreteTimeIntegrator_DSTATE : REAL;
		DiscreteTimeIntegrator_DSTATE_e : REAL;
		DiscreteTimeIntegrator_DSTATE_f : REAL;
		UnitDelay_DSTATE : UDINT;
		DiscreteTimeIntegrator_PrevRese : SINT;
		DiscreteTimeIntegrator_PrevRe_g : SINT;
		DiscreteTimeIntegrator_PrevRe_c : SINT;
		DiscreteTimeIntegrator_IC_LOADI : USINT;
	END_STRUCT;
	ExternalInputs_SCRT_ss : 	STRUCT 
		In : SCRT_ss_IN_Bus;
		Perm : SCRT_ss_PERM_Bus;
	END_STRUCT;
	ExternalOutputs_SCRT_ss : 	STRUCT 
		Out : SCRT_ss_OUT_Bus;
		dbg : SCRT_ss_DBG_Bus;
	END_STRUCT;
	tag_RTM_SCRT_ss : 	STRUCT 
		errorStatus : REFERENCE TO USINT;
		blockIO : REFERENCE TO BlockIO_SCRT_ss;
		inputs : REFERENCE TO ExternalInputs_SCRT_ss;
		outputs : REFERENCE TO ExternalOutputs_SCRT_ss;
		dwork : REFERENCE TO D_Work_SCRT_ss;
	END_STRUCT;
	RT_MODEL_SCRT_ss :tag_RTM_SCRT_ss;
END_TYPE
