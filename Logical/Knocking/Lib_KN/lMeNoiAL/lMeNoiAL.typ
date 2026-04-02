TYPE


   tMeNoiAL_DBG : STRUCT 
        uMeNoi_Cnt : ARRAY[0..24] OF USINT; (*Counter (-)*)
        rFenst2_Vect : ARRAY[0..24] OF REAL; (*Mechanical noise of valid cylinders (mV)*)
        bValidCyl : ARRAY[0..24] OF BOOL; (*Vector indicating valid cylinders for monitoring (-)*)
        rFiltTau_Lim : REAL; (*Parameter limitation: Mechanical noise filter factor (-)*)
        rFiltGain_Lim : REAL; (*Parameter limitation: Mechanical noise filter gain (-)*)
        rMargTexhAct_Lim : REAL; (*Parameter limitation: Threshold where Texh Monitoring uses narrow margin (-)*)
        rOffMeNoi_Lim : REAL; (*Parameter limitation: Mechanical noise filter offset factor (-)*)
        rFenst2LiMx_Lim : REAL; (*Parameter limitation: Max Limit for Mechanical Noise detection (mV)*)
        rFenst2LiMn_Lim : REAL; (*Parameter limitation: Limit for measuring signal failure (mV)*)
        uAdapLim_MeNoi_Cyl : ARRAY[0..24] OF REAL; (*Cylinder individual adaptive mechanical noise limit (mV)*)
        uAdapLim_Marg : REAL; (*Mechanical noise average based limit (mV)*)
    END_STRUCT;

   tMeNoiAL_IN : STRUCT 
        ucNumCyl : USINT; (*Total number of cylinders (-)*)
        bKnockSig : ARRAY[0..24] OF BOOL; (*Measurement signal error (-)*)
        bGCB_On_TC2_Di : BOOL; (*GCB closed (-)*)
        uFenst2 : ARRAY[0..24] OF UINT; (*Mechanical noise per cylinder (mV)*)
    END_STRUCT;

   tMeNoiAL_OUT : STRUCT 
        bTExh_Mon_UseNarrowWindow : ARRAY[0..24] OF BOOL; (*narrower threshold activation for exhaust temperature monitoring (-)*)
        bValve : ARRAY[0..24] OF BOOL; (*mech noise cyl individual alarm activation (-)*)
        uFenst2_Av : UINT; (*mechanical noise average (-)*)
        uFenst2_Mx : UINT; (*maximum mechanical noise (-)*)
        uFenst2_Mn : UINT; (*minimum mechanical noise (-)*)
    END_STRUCT;

   tMeNoiAL_PARA : STRUCT 
        rFenst2LiMx : REAL; (*Max Limit for Mechanical Noise detection (mV)*)
        rFenst2LiMn : REAL; (*Limit for measuring signal failure (mV)*)
        rFiltTau_MeNoi : REAL; (*Mechanical Noise filter factor (-)*)
        rMargTExh_Active : REAL; (*Threshold where Texh Monitoring uses narrow margin (-)*)
        bMeNoi_Active : BOOL; (*Mechanical Noise Adaptive Limit Active (-)*)
    END_STRUCT;
END_TYPE
TYPE
BlockIO_MeNoiAL : STRUCT
	BusInput : tMeNoiAL_IN;
	BusInput1 : tMeNoiAL_PARA;
	UnitDelay : UDINT;
END_STRUCT;
D_Work_MeNoiAL : STRUCT
	Delay_DSTATE : ARRAY[0..24] OF REAL;
	DiscreteTimeIntegrator_DSTATE : ARRAY[0..24] OF REAL;
	UnitDelay_DSTATE : UDINT;
	Delay_DSTATE_c : ARRAY[0..24] OF USINT;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
ConstBlockIO_MeNoiAL : STRUCT
	DataTypeConversion : ARRAY[0..24] OF REAL;
END_STRUCT;
ExternalInputs_MeNoiAL : STRUCT
	In_MeNnoiAL : tMeNoiAL_IN;
	Para_MeNoiAL : tMeNoiAL_PARA;
END_STRUCT;
ExternalOutputs_MeNoiAL : STRUCT
	Out_MeNoiAL : tMeNoiAL_OUT;
	Dbg_MeNoiAL : tMeNoiAL_DBG;
END_STRUCT;
END_TYPE