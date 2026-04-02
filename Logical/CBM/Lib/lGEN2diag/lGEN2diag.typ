TYPE


   DiagActiveBus : STRUCT 
        DiagOn : BOOL; (**)
        DiagOnInTransient : BOOL; (**)
        LEANOXErrSettled : BOOL; (**)
        NoTooStrongWGMove : BOOL; (**)
        NoTransient : BOOL; (**)
        NoExtDist : BOOL; (**)
        NoVoltTrans : BOOL; (**)
        GCBMCBsettled : BOOL; (**)
        GridP : BOOL; (**)
        DiagBitmask : DINT; (**)
        NoMinLoad : BOOL; (**)
        TexhSettledAfterRamp : BOOL; (**)
        NoGasMixingTrans : BOOL; (**)
    END_STRUCT;

   tGEN2FDebug : STRUCT 
        LambdaCmd : REAL; (*lambda command [-]*)
        y_f : REAL; (*filtered value of y*)
        Residual : REAL; (*high pass filtered lambda (= gradient)*)
        Thrsh : REAL; (*the actual threshold (after scaling)*)
        DiagActive : BOOL; (*diagnosis activated*)
        FaultLambdaOnly : BOOL; (*fault detected based only on lambda gradient (WITHOUT deactivation logic)*)
        ResLambdaOnly : REAL; (*high pass filtered lambda signal (after lambda has been lowpass filtered)*)
        ResLambdaITP : REAL; (*high pass filtered lambda signal due to ITP change (after lambda est. has been lowpass filtered)*)
        ResLambdaEst : REAL; (*high pass filtered estimated lambda signal (after lambda est. has been lowpass filtered)*)
        LambdaEst : REAL; (*estimated lambda (via lookup table) dependent on p2s*)
        LEANOXErr : REAL; (*internally calculated LEANOX error [bar]*)
        TexhAvg : REAL; (*exhaust temperature [°C] (avg.) calculated via the mean value*)
        TexhMin : REAL; (*exhaust temperature [°C] (min.)*)
        GasMixing_RatioHP : REAL; (*high pass filtered gas mixing ratio*)
        DeltaTexhAllowed : REAL; (*max. allowed rise in avg. exhaust temp. [°C] used for fault detection (after scaling)*)
        tDiagActiveBus : DiagActiveBus; (*struct to check which component of the activation logic is on*)
    END_STRUCT;

   tGEN2FIn : STRUCT 
        LambdaCmd : REAL; (*lambda command [-]*)
        Lambda_ss : REAL; (*steady state lambda [-]*)
        Reset : BOOL; (*reset of filter blocks*)
        Pset_WR_norm : REAL; (*power reference without a ramp [p.u.]*)
        Pset_norm : REAL; (*power reference trajectory [p.u.]*)
        bExt_dist : BOOL; (*TRUE --> external disturbance*)
        Texh : ARRAY[0..24] OF REAL; (*exhaust temperatures (cylinder specific)*)
        p2s : REAL; (*p2s [bar]*)
        p2sCmd : REAL; (*p2s command (LEANOX) [bar]*)
        posWG_norm : REAL; (*waste-gate position [p.u.] 0...1*)
        WGM_reset : BOOL; (*reset bit for the wastegate monitoring part*)
        LEANOXErrorFiltReset : BOOL; (*reset bit for the lowpass used to filter p2s in the LEANOX error settling detection*)
        bVltg_reset : BOOL; (*reset bit for the voltage monitoring part*)
        U_L1L2_norm : REAL; (*concatenated voltage L1L2 [p.u.]*)
        U_L2L3_norm : REAL; (*concatenated voltage L2L3 [p.u.]*)
        U_L3L1_norm : REAL; (*concatenated voltage L1L2 [p.u.]*)
        Man_Cond_On : BOOL; (*manual override to set the diagnosis to ON*)
        bGCBON : BOOL; (*generator circuit breaker closed information*)
        bMCBON : BOOL; (*main circuit breaker closed information*)
        bPTransDetReset : BOOL; (*reset bit for the transient monitoring part*)
        bAllowDetInTrans : BOOL; (*allow detection during ramps (if LEANOX error is small enough)*)
        bTexhSettled_reset : BOOL; (*reset bit for Texh settled detection (after power ramps)*)
        rGasMixing_Ratio : REAL; (*gas mixing ratio [0 - 100 percent]*)
        bGasMixing_reset : BOOL; (*reset bit for gas mixing settled detection*)
        bFileOnlyInTrans : BOOL; (*write files only during power ramps (only if detection is allowed during ramps)*)
        rITPmean : REAL; (*mean ignition timing point [°CA]*)
    END_STRUCT;

   tGEN2FOut : STRUCT 
        FrictionFault : BOOL; (*fault detected based on (negative) lambda gradient and (positive) exh. temp. gradient*)
        FrictionFaultInTransient : BOOL; (*fault detected based on (negative) lambda gradient and (positive) exh. temp. gradient; fault in transient detected (only for writing files at the moment!)*)
    END_STRUCT;

   tGEN2FParameter : STRUCT 
        TrshPsetDev : REAL; (*threshold value for power set point deviation [p.u.]*)
        TrshPsetStat : REAL; (*threshold value for steady state detection [p.u.]*)
        TconstPsetStat : REAL; (*timeconstant for steady state detection*)
        TrshLoad : REAL; (*threshold value for load level (related to the set power point) [p.u.]*)
        TConstLP : REAL; (*time constant [s] for the lambda lowpass filter*)
        TConstHP : REAL; (*time constant [s] for the lambda highpass filter (situated after the lowpass)*)
        ITPmeanScaling : REAL; (*scaling for the mean ITP to estimate a lambda change*)
        FaultThrshLambda : REAL; (*threshold value for lambda fault detection*)
        ThrshScale : REAL; (*scaling of the threshold value for lambda fault detection [p.u.]*)
        TPulseLambdaFault : REAL; (*minimum time [s] a lambda fault pulse is provided for further detection (exh. temp.)*)
        NCyl : DINT; (*number of cylinders*)
        DeltaTexhAllowed : REAL; (*max. allowed rise in avg. exhaust temp. used for fault detection*)
        TexhPlausibleMin : REAL; (*min. exhaust temperature which is considered plausible (to exclude faulty sensors)*)
        TexhPlausibleMax : REAL; (*max. exhaust temperature which is considered plausible (to exclude faulty sensors)*)
        WGM_FaultThrsh : REAL; (*wastegate monitoring fault threshold*)
        WGM_Tconst : REAL; (*wastegate monitoring time constant [sec]*)
        LEANOXErrorTconst : REAL; (*time constant [s] for filtering p2s in LEANOX error calculation*)
        LEANOXErrorThrsh : REAL; (*threshold for leanox error (diagnosis gets active if the error is smaller than this threshold)*)
        Vltg_FaultThrsh : REAL; (*voltage monitoring fault threshold*)
        Vltg_Tconst : REAL; (*voltage monitoring time constant [sec]*)
        MonitoringDelay : REAL; (*global monitoring time delay (used for all activation logic pars) [sec]*)
        TexhSettledThrsh : REAL; (*threshold for exhaust temperature settled detection*)
        TexhSettledTConstLP : REAL; (*time constant [s] for the Texh lowpass filter -> settled detection*)
        TexhSettledTConstHP : REAL; (*time constant [s] for the Texh highpass filter (situated after the lowpass) -> settled detection*)
        TexhSettledMaxTD : REAL; (*max. time [s] after a power ramp after which the exhaust temperature is considered settled (even if the filter does not suggest this!)*)
        bGasMixingEnDet : BOOL; (*enable gas mixing transient detection*)
        GasMixingThrsh : REAL; (*threshold for gas mixing transient detection*)
        GasMixingTconstLP : REAL; (*time constant [s] for gas mixing transient detection lowpass*)
        GasMixingTconstHP : REAL; (*time constant [s] for gas mixing transient detection highpass*)
    END_STRUCT;
END_TYPE
TYPE
rtB_TOF_G2Fdiag : STRUCT
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TOF_G2Fdiag : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_TON_G2Fdiag : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON_G2Fdiag : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_TP_G2Fdiag : STRUCT
	Merge : LREAL;
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TP_G2Fdiag : STRUCT
	DelayInput2_DSTATE : LREAL;
	UnitDelay2_DSTATE : BOOL;
END_STRUCT;
BlockIO_G2Fdiag : STRUCT
	BusInput1 : tGEN2FIn;
	BusInput : tGEN2FParameter;
	UnitDelay : UDINT;
	TP1 : rtB_TP_G2Fdiag;
	TP : rtB_TP_G2Fdiag;
	TON_n : rtB_TON_G2Fdiag;
	TON_i : rtB_TON_G2Fdiag;
	TON1 : rtB_TON_G2Fdiag;
	TON_e : rtB_TON_G2Fdiag;
	TOF_o : rtB_TOF_G2Fdiag;
	TOF_h : rtB_TOF_G2Fdiag;
	TON : rtB_TON_G2Fdiag;
	TON_j : rtB_TON_G2Fdiag;
	TON_k : rtB_TON_G2Fdiag;
	TOF : rtB_TOF_G2Fdiag;
END_STRUCT;
D_Work_G2Fdiag : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE_k : REAL;
	DiscreteTimeIntegrator_DSTATE_h : REAL;
	DiscreteTimeIntegrator_DSTATE_c : REAL;
	DiscreteTimeIntegrator_DSTATE_p : REAL;
	DiscreteTimeIntegrator_DSTATE_e : REAL;
	DiscreteTimeIntegrator_DSTAT_hv : REAL;
	DiscreteTimeIntegrator_DSTATE_j : REAL;
	DiscreteTimeIntegrator_DSTATE_n : REAL;
	DiscreteTimeIntegrator_DSTATE_o : ARRAY[0..2] OF REAL;
	DiscreteTimeIntegrator_DSTAT_jn : ARRAY[0..2] OF REAL;
	DiscreteTimeIntegrator_DSTATE_a : ARRAY[0..2] OF REAL;
	DiscreteTimeIntegrator_DSTATE_d : ARRAY[0..2] OF REAL;
	DiscreteTimeIntegrator_DSTATE_i : REAL;
	UnitDelay_DSTATE : UDINT;
	Texh_scalar_1 : REAL;
	Texh_min_1 : REAL;
	Texh_scalar_1_f : REAL;
	Texh_min_1_p : REAL;
	DelayInput1_DSTATE : BOOL;
	DelayInput1_DSTATE_e : BOOL;
	DelayInput1_DSTATE_m : BOOL;
	DelayInput1_DSTATE_l : BOOL;
	Delay_DSTATE : BOOL;
	DelayInput1_DSTATE_i : BOOL;
	DelayInput1_DSTATE_n : BOOL;
	DelayInput1_DSTATE_p : BOOL;
	DelayInput1_DSTATE_p3 : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_e : SINT;
	DiscreteTimeIntegrator_PrevRe_j : SINT;
	DiscreteTimeIntegrator_PrevRe_f : SINT;
	DiscreteTimeIntegrator_PrevRe_p : SINT;
	DiscreteTimeIntegrator_PrevR_jm : SINT;
	DiscreteTimeIntegrator_PrevRe_n : SINT;
	DiscreteTimeIntegrator_PrevR_ji : SINT;
	DiscreteTimeIntegrator_PrevR_nv : SINT;
	DiscreteTimeIntegrator_PrevRe_d : SINT;
	DiscreteTimeIntegrator_PrevR_do : SINT;
	DiscreteTimeIntegrator_PrevRe_m : SINT;
	DiscreteTimeIntegrator_PrevRe_a : SINT;
	DiscreteTimeIntegrator_PrevR_ah : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	DiscreteTimeIntegrator_IC_LOA_c : USINT;
	DiscreteTimeIntegrator_IC_LOA_b : USINT;
	DiscreteTimeIntegrator_IC_LOA_g : USINT;
	DiscreteTimeIntegrator_IC_LOA_p : USINT;
	DiscreteTimeIntegrator_IC_LOA_o : USINT;
	DiscreteTimeIntegrator_IC_LO_cl : USINT;
	DiscreteTimeIntegrator_IC_LO_ps : USINT;
	DiscreteTimeIntegrator_IC_LOA_h : USINT;
	DiscreteTimeIntegrator_IC_LO_pk : USINT;
	DiscreteTimeIntegrator_IC_LO_c0 : USINT;
	DiscreteTimeIntegrator_IC_LOA_j : USINT;
	DiscreteTimeIntegrator_IC_LOA_e : USINT;
	DiscreteTimeIntegrator_IC_LO_gt : USINT;
	Texh_scalar_1_not_empty : BOOL;
	Texh_scalar_1_not_empty_d : BOOL;
	bSettlingPhase : BOOL;
	TexhSettledAfterRamp_persistent : BOOL;
	TP1 : rtDW_TP_G2Fdiag;
	TP : rtDW_TP_G2Fdiag;
	TON_n : rtDW_TON_G2Fdiag;
	TON_i : rtDW_TON_G2Fdiag;
	TON1 : rtDW_TON_G2Fdiag;
	TON_e : rtDW_TON_G2Fdiag;
	TOF_o : rtDW_TOF_G2Fdiag;
	TOF_h : rtDW_TOF_G2Fdiag;
	TON : rtDW_TON_G2Fdiag;
	TON_j : rtDW_TON_G2Fdiag;
	TON_k : rtDW_TON_G2Fdiag;
	TOF : rtDW_TOF_G2Fdiag;
END_STRUCT;
ExternalInputs_G2Fdiag : STRUCT
	IN : tGEN2FIn;
	para : tGEN2FParameter;
END_STRUCT;
ExternalOutputs_G2Fdiag : STRUCT
	OUT : tGEN2FOut;
	dbg : tGEN2FDebug;
END_STRUCT;
END_TYPE