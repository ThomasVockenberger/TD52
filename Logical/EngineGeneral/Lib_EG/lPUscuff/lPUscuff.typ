

TYPE
	tPUscuff_DBG :  STRUCT   
		rP2s_filt_fast :  REAL; (**)  
		rP2s_filt_slow :  REAL; (**)  
		tPr_CC_Ai :  REAL; (**)  
		bLearnEna_cont :  BOOL; (**)  
		bLearnEna_cyclic :  BOOL; (**)  
		rKnockNoise :  ARRAY[0..24] OF REAL; (**)  
		rYprobability :  ARRAY[0..24] OF REAL; (**)  
		rKnockNoise_median :  REAL; (**)  
		rKnockNoise_stdDev :  REAL; (**)  
		bTripPccANDknock :  BOOL; (**)  
		bLearnReactAfterKnock :  BOOL; (**)  
		rP2s_filt_contLearn :  REAL; (**)  
	END_STRUCT;

	tPUscuff_IN :  STRUCT   
		iNumCyl :  USINT; (*Total number of cylinders (-)*)  
		tGCB_On_Di :  BOOL; (*Generator circuit breaker closed (-)*)  
		rP2s :  REAL; (*Charge pressure (bar)*)  
		rP_Act_Norm :  REAL; (*Normalized power (p.u.)*)  
		tPr_CC_Ai :  REAL; (*Crankcase pressure (bar)*)  
		tPr_CC_GoodQual :  BOOL; (*Crankcase pressure measuring signal failure (-)*)  
		rKnockNoise :  ARRAY[0..24] OF REAL; (*Cylinder knock noise (mV)*)  
		bKnockSig :  ARRAY[0..24] OF BOOL; (*Knock noise measuring signal failure (-)*)  
	END_STRUCT;

	tPUscuff_Map :  STRUCT   
		rP2s_x_pt1 :  REAL; (**)  
		rP2s_x_pt2 :  REAL; (**)  
		rP2s_x_pt3 :  REAL; (**)  
		rP2s_x_pt4 :  REAL; (**)  
		rP2s_x_pt5 :  REAL; (**)  
		rP2s_x_pt6 :  REAL; (**)  
		rP2s_x_pt7 :  REAL; (**)  
		rP2s_x_pt8 :  REAL; (**)  
		rP2s_x_pt9 :  REAL; (**)  
		rP2s_x_pt10 :  REAL; (**)  
		rP2s_x_pt11 :  REAL; (**)  
		rP2s_x_pt12 :  REAL; (**)  
		rP2s_x_pt13 :  REAL; (**)  
		rP2s_x_pt14 :  REAL; (**)  
		rPrCC_y_pt1 :  REAL; (**)  
		rPrCC_y_pt2 :  REAL; (**)  
		rPrCC_y_pt3 :  REAL; (**)  
		rPrCC_y_pt4 :  REAL; (**)  
		rPrCC_y_pt5 :  REAL; (**)  
		rPrCC_y_pt6 :  REAL; (**)  
		rPrCC_y_pt7 :  REAL; (**)  
		rPrCC_y_pt8 :  REAL; (**)  
		rPrCC_y_pt9 :  REAL; (**)  
		rPrCC_y_pt10 :  REAL; (**)  
		rPrCC_y_pt11 :  REAL; (**)  
		rPrCC_y_pt12 :  REAL; (**)  
		rPrCC_y_pt13 :  REAL; (**)  
		rPrCC_y_pt14 :  REAL; (**)  
	END_STRUCT;

	tPUscuff_OUT :  STRUCT   
		rPr_CC_pred :  REAL; (**)  
		bPUscf_LearnEna :  BOOL; (**)  
		bYpredict :  ARRAY[0..24] OF BOOL; (**)  
		bPUscf_RelTrip :  BOOL; (**)  
		bPUscf_TripALL :  BOOL; (**)  
		tPUscuff_Map :  tPUscuff_Map; (**)  
	END_STRUCT;

	tPUscuff_PARA :  STRUCT   
		bPUscf_Ena :  BOOL; (*Activation of PU scuffing and CR bearing failure detection (-)*)  
		rPUscf_Eps_scale :  REAL; (*Threshold scaling for knocking anomaly detection (-)*)  
		rTiPUscf_EnaDelay :  REAL; (*Monitoring activation delay after GCB close (s)*)  
		rPr_CC_PUscf_Dev_HiHi :  REAL; (*Trip limit Pr_CC vs. Pr_CC predicted (mbar)*)  
		rTiPUscf_LearnReactDelay :  REAL; (*Learning reactivation delay after knocking anomaly (s)*)  
		rPUscf_LearnScale :  REAL; (*P2s threshold scaling for activation of continuous learning (bar)*)  
	END_STRUCT;

END_TYPE

TYPE
rtB_Filter2_PUscuff : STRUCT
	DiscreteTimeIntegrator : REAL;
END_STRUCT;
rtDW_Filter2_PUscuff : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_TON1_PUscuff : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON1_PUscuff : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_MATLABFunction11_PUscuff : STRUCT
	y : BOOL;
END_STRUCT;
rtB_Filter1_PUscuff : STRUCT
	DiscreteTimeIntegrator : REAL;
END_STRUCT;
rtDW_Filter1_PUscuff : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
BlockIO_PUscuff : STRUCT
	BusConversion_InsertedFor_BusOu : tPUscuff_DBG;
	BusInput : tPUscuff_IN;
	BusConversion_InsertedFor_Bus_b : tPUscuff_OUT;
	BusInput1 : tPUscuff_PARA;
	UnitDelay : UDINT;
	TON4 : rtB_TON1_PUscuff;
	Filter3 : rtB_Filter2_PUscuff;
	Filter1_a : rtB_Filter2_PUscuff;
	TON5 : rtB_TON1_PUscuff;
	TON2_d : rtB_TON1_PUscuff;
	TON1_n : rtB_TON1_PUscuff;
	sf_MATLABFunction1 : rtB_MATLABFunction11_PUscuff;
	Filter9 : rtB_Filter1_PUscuff;
	Filter4 : rtB_Filter1_PUscuff;
	Filter1 : rtB_Filter1_PUscuff;
	sf_MATLABFunction11 : rtB_MATLABFunction11_PUscuff;
	TON2 : rtB_TON1_PUscuff;
	TON1 : rtB_TON1_PUscuff;
	Filter2 : rtB_Filter2_PUscuff;
END_STRUCT;
D_Work_PUscuff : STRUCT
	UnitDelay3_DSTATE : REAL;
	UnitDelay1_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator2_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE_a : ARRAY[0..24] OF REAL;
	DiscreteTimeIntegrator_DSTATE_n : ARRAY[0..24] OF REAL;
	DiscreteTimeIntegrator_DSTATE_m : REAL;
	UnitDelay_DSTATE : UDINT;
	LUT_P2s_PrCC : ARRAY[0..27] OF REAL;
	rLearnTmp : REAL;
	UnitDelay2_DSTATE : BOOL;
	DelayInput1_DSTATE : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_n : ARRAY[0..24] OF SINT;
	DiscreteTimeIntegrator_PrevRe_f : SINT;
	DiscreteTimeIntegrator_PrevRe_e : SINT;
	DiscreteTimeIntegrator2_IC_LOAD : USINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	DiscreteTimeIntegrator_IC_LOA_b : USINT;
	LUT_P2s_PrCC_not_empty : BOOL;
	TON4 : rtDW_TON1_PUscuff;
	Filter3 : rtDW_Filter2_PUscuff;
	Filter1_a : rtDW_Filter2_PUscuff;
	TON5 : rtDW_TON1_PUscuff;
	TON2_d : rtDW_TON1_PUscuff;
	TON1_n : rtDW_TON1_PUscuff;
	Filter9 : rtDW_Filter1_PUscuff;
	Filter4 : rtDW_Filter1_PUscuff;
	Filter1 : rtDW_Filter1_PUscuff;
	TON2 : rtDW_TON1_PUscuff;
	TON1 : rtDW_TON1_PUscuff;
	Filter2 : rtDW_Filter2_PUscuff;
END_STRUCT;
rtC_Filter2_PUscuff : STRUCT
	Conversion : REAL;
END_STRUCT;
rtC_Filter1_PUscuff : STRUCT
	Abs : REAL;
	Conversion : REAL;
	Switch : REAL;
	RelationalOperator : BOOL;
END_STRUCT;
ConstBlockIO_PUscuff : STRUCT
	Filter3 : rtC_Filter2_PUscuff;
	Filter1_a : rtC_Filter2_PUscuff;
	Filter9 : rtC_Filter1_PUscuff;
	Filter4 : rtC_Filter1_PUscuff;
	Filter1 : rtC_Filter1_PUscuff;
	Filter2 : rtC_Filter2_PUscuff;
END_STRUCT;
ExternalInputs_PUscuff : STRUCT
	In : tPUscuff_IN;
	Para : tPUscuff_PARA;
END_STRUCT;
ExternalOutputs_PUscuff : STRUCT
	Out : tPUscuff_OUT;
	Dbg : tPUscuff_DBG;
END_STRUCT;
tag_RTM_PUscuff : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_PUscuff;
	inputs : REFERENCE TO ExternalInputs_PUscuff;
	outputs : REFERENCE TO ExternalOutputs_PUscuff;
	dwork : REFERENCE TO D_Work_PUscuff;
END_STRUCT;
RT_MODEL_PUscuff : tag_RTM_PUscuff;
END_TYPE
TYPE
tPUscuff_PARA_LIM : STRUCT
	rPUscf_Eps_scale_Lim : REAL;
	rTiPUscf_EnaDelay_Lim : REAL;
	rPr_CC_PUscf_Dev_HiHi_Lim : REAL;
	rTiPUscf_LearnReactDelay_Lim : REAL;
	rPUscf_LearnScale_Lim : REAL;
END_STRUCT;
END_TYPE