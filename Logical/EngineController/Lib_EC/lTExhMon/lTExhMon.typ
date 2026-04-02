TYPE


   tTExhMon_DBG : STRUCT 
        rP_Act_Norm_Filt_dbg : REAL; (*Normalized power (-)*)
        rdT2Ref : ARRAY[0..24] OF REAL; (*Reference exhaust gas temperature (T_EPU - T_median) (°C)*)
        rT_EPU_EG_Cyl_Vect : ARRAY[0..24] OF REAL; (*Engine power unit exhaust gas temperature considering valid cylinders (°C)*)
        rCA_Ign_Act_Vect : ARRAY[0..24] OF REAL; (*Actual ignition timing point considering valid cylinders (°CA)*)
        rdT_Ref_Max_Cyl : ARRAY[0..24] OF REAL; (*Threshold depending on narrowed temperature monitoring (°C)*)
        bValidCyl : ARRAY[0..24] OF BOOL; (*Vector indicating valid cylinders for monitoring (-)*)
        bEGTSignalJump : ARRAY[0..24] OF BOOL; (*Vector indicating exhaust gas temperature signal jumps (-)*)
    END_STRUCT;

   tTExhMon_IN : STRUCT 
        ucNumCyl : USINT; (*Total number of cylinders (-)*)
        bTExh_Mon_UseNarrowWindow : ARRAY[0..24] OF BOOL; (*narrower threshold activation for exhaust temperature monitoring (-)*)
        tGCB_On_Di : BOOL; (*generator circuit breaker closed (-)*)
        rT_EPU_EG : ARRAY[0..24] OF REAL; (*Exhaust Temperature per cylinder (°C)*)
        rP_Act_Norm_Filt : REAL; (*Actual power (-)*)
        rCA_Ign_Act : ARRAY[0..24] OF REAL; (*actual cylinder ignition point (°CA)*)
        rCA_IgnP_Set : REAL; (*ignition timing setpoint (°CA)*)
        rdTExh_Misfire : REAL; (*delta temperature from reference to misfire limit (°C)*)
        rT_dTExhMon_ITPComp : REAL; (*TExh compensation at later ITP values (positive values for increasing temp. at retarding) (K/°CA)*)
        MSAGT : ARRAY[0..24] OF BOOL; (*TExh sensor failure (-)*)
        rTs_task : REAL; (*Task sampling time (-)*)
    END_STRUCT;

   tTExhMon_OUT : STRUCT 
        bdTExhMonTrip : ARRAY[0..24] OF BOOL; (*TRUE = TExhMon trip detected for cylinder (-)*)
        rT_Exh_Exp : ARRAY[0..24] OF REAL; (*expected temperature per cylinder (°C)*)
        rT_EG_Lim_dTExhMon : ARRAY[0..24] OF REAL; (*Trip Limit per cylinder (°C)*)
        rdT2Limit : ARRAY[0..24] OF REAL; (*current deviation from expected value per cylinder (°C)*)
        rdT2Limit_Max : ARRAY[0..24] OF REAL; (*MAX deviation since last engine start per cylinder (°C)*)
        rdT2Limit_Min : ARRAY[0..24] OF REAL; (*MIN deviation since last engine start per cylinder (°C)*)
        bdTExhMonTrip_all : BOOL; (*collection of alarm activation for all cylinders (-)*)
        bdTExhMon_Act : BOOL; (*TRUE = dTExhMon activated and running (-)*)
        rTExh_median : REAL; (*Exh Temp median (°C)*)
    END_STRUCT;

   tTExhMon_PARA : STRUCT 
        tDelay_dTExhMon_Act : REAL; (*delay for activation of dTExhMon after GCB_ON (s)*)
        rdT_Ref_Max : REAL; (*distance from expected temperature to trip (normal) (°C)*)
        rFiltTau_Texh : REAL; (*constant for reference value filtering (s)*)
        rdT2Exp_Max : REAL; (*Max distance from expected value to trip limit (°C)*)
        tDelay_dTExhMon_Act_P : REAL; (*delay for re-activation after low power operation (s)*)
        bTExhMon_Release : BOOL; (*parameter that activates this function (s)*)
        rTExhBound_SensScal : REAL; (*Sensitivity scaling factor for the exhaust gas temperature tolerance boundary/range (-)*)
    END_STRUCT;
END_TYPE
TYPE
rtB_TON_TExhMon_Act_GCB_ON_TExh : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON_TExhMon_Act_GCB_ON_TEx : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_TON_InBound_TExhMon : STRUCT
	LogicalOperator3 : ARRAY[0..24] OF BOOL;
END_STRUCT;
rtDW_TON_InBound_TExhMon : STRUCT
	DiscreteTimeIntegrator_DSTATE : ARRAY[0..24] OF REAL;
	DiscreteTimeIntegrator_PrevRese : ARRAY[0..24] OF SINT;
END_STRUCT;
BlockIO_TExhMon : STRUCT
	BusInput : tTExhMon_IN;
	BusInput1 : tTExhMon_PARA;
	UnitDelay : UDINT;
	TON_OutBound : rtB_TON_InBound_TExhMon;
	TON_InBound : rtB_TON_InBound_TExhMon;
	xTON_bdTExhMon_Act_P : rtB_TON_TExhMon_Act_GCB_ON_TExh;
	TON_TExhMon_Act_GCB_ON : rtB_TON_TExhMon_Act_GCB_ON_TExh;
END_STRUCT;
D_Work_TExhMon : STRUCT
	Delay_DSTATE : ARRAY[0..24] OF REAL;
	Delay1_DSTATE : ARRAY[0..24] OF REAL;
	Delay2_DSTATE : ARRAY[0..24] OF REAL;
	DiscreteTimeIntegrator_DSTATE : ARRAY[0..24] OF REAL;
	UnitDelay_DSTATE : UDINT;
	rdT2Ref_1 : ARRAY[0..24] OF REAL;
	rCA_ITPOffset_1 : ARRAY[0..24] OF REAL;
	UnitDelay_DSTATE_i : ARRAY[0..24] OF BOOL;
	DelayInput1_DSTATE : ARRAY[0..24] OF BOOL;
	DiscreteTimeIntegrator_PrevRese : ARRAY[0..24] OF SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	Memory_PreviousInput : BOOL;
	Memory_PreviousInput_o : BOOL;
	rdT2Ref_1_not_empty : BOOL;
	rCA_ITPOffset_1_not_empty : BOOL;
	bReset_1 : BOOL;
	TexhJump : ARRAY[0..24] OF BOOL;
	TON_OutBound : rtDW_TON_InBound_TExhMon;
	TON_InBound : rtDW_TON_InBound_TExhMon;
	xTON_bdTExhMon_Act_P : rtDW_TON_TExhMon_Act_GCB_ON_TEx;
	TON_TExhMon_Act_GCB_ON : rtDW_TON_TExhMon_Act_GCB_ON_TEx;
END_STRUCT;
PrevZCSigStates_TExhMon : STRUCT
	Delay1_Reset_ZCE : USINT;
	Delay2_Reset_ZCE : USINT;
END_STRUCT;
ConstParam_TExhMon : STRUCT
	pooled12 : ARRAY[0..15] OF BOOL;
END_STRUCT;
ExternalInputs_TExhMon : STRUCT
	In_TExhMon : tTExhMon_IN;
	Para_TExhMon : tTExhMon_PARA;
END_STRUCT;
ExternalOutputs_TExhMon : STRUCT
	Out : tTExhMon_OUT;
	Dbg : tTExhMon_DBG;
END_STRUCT;
END_TYPE