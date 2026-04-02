

TYPE
	ExternalInputs_AC_SS :  STRUCT   
		IN :      tSS_In;   
	END_STRUCT;

	ExternalInputs_AC_SS_Cust :  STRUCT   
		in :    tSS_In_Cust;   
	END_STRUCT;

	tSS_In :  STRUCT   
		P2s :    tSS_into; (*Charge pressure*)  
		T2s :    tSS_into; (*Charge temperature*)  
		T_EG :    tSS_into; (*Exhaust gas temperature*)  
		P_Norm :    tSS_into; (*Actual normalized power*)  
		Lam :    tSS_into; (*Lambda*)  
		N_Norm :    tSS_into; (*Normalized Speed*)  
		P_d_Norm :    tSS_into; (*Desired normalized power*)  
		IP :    tSS_into; (*Ignition Point*)  
		bReset :    BOOL; (*Reset all integrators to zero*)  
	END_STRUCT;

	tSS_Out :  STRUCT   
		P2s :    tSS_outo; (*Charge pressure*)  
		T2s :    tSS_outo; (*Charge temperature*)  
		T_EG :    tSS_outo; (*Exhaust gas temperature*)  
		P_Norm :    tSS_outo; (*Actual normalized power*)  
		Lam :    tSS_outo; (*Lambda*)  
		N_Norm :    tSS_outo; (*Normalized speed*)  
		P_d_Norm :    tSS_outo; (*Desired normalized power*)  
		IP :    tSS_outo; (*Ignition Point*)  
	END_STRUCT;

	tSS_into :  STRUCT   
		rAct :    REAL; (*actual value*)  
		rSet :    REAL; (*target value*)  
		rAbsLim :    REAL; (*allowed absolute deviation*)  
		rTi_Filt :    REAL; (*Filter time constant for slew rate [s]*)  
		rRelLim :    REAL; (*allowed relative deviation*)  
	END_STRUCT;

	tSS_outo :  STRUCT   
		bAbs :    BOOL; (*actual value is within allowed absolute deviation*)  
		bRel :    BOOL; (*actual value is within allowed relative deviation*)  
	END_STRUCT;

	rtB_Filter_AC_SS :  STRUCT   
		DiscreteTimeIntegrator :   REAL;   
	END_STRUCT;

	rtDW_Filter_AC_SS :  STRUCT   
		DiscreteTimeIntegrator_DSTATE :   REAL;   
		DiscreteTimeIntegrator_PrevRese :   SINT;   
	END_STRUCT;

	BlockIO_AC_SS :  STRUCT   
		BusInput :   tSS_In;   
		Filter_c :   rtB_Filter_AC_SS;   
		Filter_n :   rtB_Filter_AC_SS;   
		Filter_f :   rtB_Filter_AC_SS;   
		Filter :   rtB_Filter_AC_SS;   
		Filter_h :   rtB_Filter_AC_SS;   
		Filter_e :   rtB_Filter_AC_SS;   
		Filter_a :   rtB_Filter_AC_SS;   
		Filter_o :   rtB_Filter_AC_SS;   
	END_STRUCT;

	D_Work_AC_SS :  STRUCT   
		Filter_c :   rtDW_Filter_AC_SS;   
		Filter_n :   rtDW_Filter_AC_SS;   
		Filter_f :   rtDW_Filter_AC_SS;   
		Filter :   rtDW_Filter_AC_SS;   
		Filter_h :   rtDW_Filter_AC_SS;   
		Filter_e :   rtDW_Filter_AC_SS;   
		Filter_a :   rtDW_Filter_AC_SS;   
		Filter_o :   rtDW_Filter_AC_SS;   
	END_STRUCT;

	rtC_Filter_AC_SS :  STRUCT   
		Conversion :   REAL;   
	END_STRUCT;

	ConstBlockIO_AC_SS :  STRUCT   
		Constant :   REAL;   
		Constant_d :   REAL;   
		Constant_j :   REAL;   
		Constant_h :   REAL;   
		Constant_g :   REAL;   
		Constant_hq :   REAL;   
		Constant_b :   REAL;   
		Constant_f :   REAL;   
		Filter_c :   rtC_Filter_AC_SS;   
		Filter_n :   rtC_Filter_AC_SS;   
		Filter_f :   rtC_Filter_AC_SS;   
		Filter :   rtC_Filter_AC_SS;   
		Filter_h :   rtC_Filter_AC_SS;   
		Filter_e :   rtC_Filter_AC_SS;   
		Filter_a :   rtC_Filter_AC_SS;   
		Filter_o :   rtC_Filter_AC_SS;   
	END_STRUCT;

	ConstParam_AC_SS :  STRUCT   
		pooled4 :   ARRAY[0..7] OF USINT;   
	END_STRUCT;

	ExternalOutputs_AC_SS :  STRUCT   
		iAbs :   USINT;   
		iRel :   USINT;   
		dbg :   tSS_Out;   
	END_STRUCT;

	tag_RTM_AC_SS :  STRUCT   
		errorStatus :   REFERENCE TO USINT;   
	END_STRUCT;

	tSS_In_Cust :  STRUCT   
		rTi_Del :   REAL; (*Time interval engine values must be under abs/rel limits to reach steady state*)  
		iSelectAbs :   USINT; (*Absolute Steady State for (p2s, T2s, EGT, P_Norm, Lambda, N_Norm, P_d_Norm, IP)*)  
		iSelectRel :   USINT; (*Relative Steady State for (p2s, T2s, EGT, P_Norm, Lambda, N_Norm, P_d_Norm, IP)*)  
		iAbs :   USINT; (*binary data absolute deviation in limits*)  
		iRel :   USINT; (*binary data relative deviation in limits*)  
	END_STRUCT;

	tSS_Out_Cust :  STRUCT   
		bSS :   BOOL; (*Selected actual and relative values are within allowed limits*)  
		bSS_Del :   BOOL; (*Selected actual and relative values are within allowed limits for ime interval rTi_Del*)  
		rET :   REAL; (*Elapsed time*)  
	END_STRUCT;

	BlockIO_AC_SS_Cust :  STRUCT   
		BusInput :  tSS_In_Cust;   
	END_STRUCT;

	D_Work_AC_SS_Cust :  STRUCT   
		DiscreteTimeIntegrator_DSTATE :  REAL;   
		DiscreteTimeIntegrator_PrevRese :  SINT;   
	END_STRUCT;

	ExternalOutputs_AC_SS_Cust :  STRUCT   
		out :  tSS_Out_Cust;   
	END_STRUCT;

	tag_RTM_AC_SS_Cust :  STRUCT   
		errorStatus :  REFERENCE TO USINT;   
	END_STRUCT;

END_TYPE
