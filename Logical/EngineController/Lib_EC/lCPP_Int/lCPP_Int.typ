TYPE


   tCPPI_DBUG : STRUCT 
        tiInt_NonEmpty : REAL; (*Integrator Non Empty elapsed time [s]*)
        rCPP_Err : REAL; (*Cylinder Peak Pressure Error [%]*)
        bECPG : BOOL; (*Engine Cycle Puls Generator*)
        bFCPG : BOOL; (*Filter Cycle Puls Generator*)
    END_STRUCT;

   tCPPI_IN : STRUCT 
        bReset : BOOL; (*Reset CPP Integrator*)
        rPr_CPP : REAL; (*Cylinder Peak Pressure [bar]*)
        rN_Eng : REAL; (*Engine Actual Speed [1/min]*)
        bSensorErr : BOOL; (*Sensor Error active*)
        bLimpHomeExt : BOOL; (*Limp Home Extended Mode active*)
        tiSample : REAL; (*Function Block  Sampletime [s]*)
    END_STRUCT;

   tCPPI_OUT : STRUCT 
        rPr_CPP_Filt : REAL; (*Cycle Peak Pressure filtered [bar]*)
        rPI_Dur_Offset : REAL; (*Port Injection Duration reduction offset [%]*)
        rCA_Ign_Offset : REAL; (*Ignition Point Timing reduction offset [°CA]*)
        rNum_CPP_Int : REAL; (*Integrator Level [%]*)
        bCPP_AbsLim : BOOL; (*Absolut Limit Integrator Level at 100%*)
        bCPP_AbsLim_LHE : BOOL; (*Absolut Limit Integrator Level at 100% for Extended Limp Home Mode*)
        bSkipCyl : BOOL; (*Skip Cylinder Ignition on Engine Shutdown*)
    END_STRUCT;

   tCPPI_PARA : STRUCT 
        rPr_AbsLimHi : REAL; (*Peak Pressure Limit High High [bar]*)
        rPr_AbsLim : REAL; (*Peak Pressure Limit High [bar]*)
        rPr_AbsLimHi_LHE : REAL; (*Peak Pressure for Extended Limp Home Mode Limit High High [bar]*)
        rPr_AbsLim_LHE : REAL; (*Peak Pressure  for Extended Limp Home Mode Limit High [bar]*)
        rPI_Dur_Offset_Max : REAL; (*Port Injection Duration Reduction Offset maximum [%]*)
        rCA_Ign_Offset_Max : REAL; (*Ignition Point Timing Reduction Offset maximum [°CA]*)
    END_STRUCT;

   tCPPI_PERM : STRUCT 
        rInt_Dec : REAL; (*Integrator Decent per Cycle Factor [%/Cycle]*)
        rInt_Power : REAL; (*Integrator Weighting Function Power Factor*)
        tiSensorFilter : REAL; (*Sensor Error Filtertime [s]*)
        tiInt_NonEmpty : REAL; (*Integrator Nonempty Time until Shutdown [s]*)
        rPI_Dur_IntLimLo : REAL; (*Integrator Level Limit for Port Injection Duration reduction Low [%]*)
        rPI_Dur_IntLimHi : REAL; (*Integrator Level Limit for Port Injection Duration reduction High [%]*)
        rIgn_IntLimLo : REAL; (*Integrator Level Limit for Ignition Point Timing reduction Low [%]*)
        rIgn_IntLimHi : REAL; (*Integrator Level Limit for Ignition Point Timing reduction High [%]*)
    END_STRUCT;
END_TYPE
TYPE
BlockIO_CPP_Int : STRUCT
	BusInput2 : tCPPI_PERM;
	BusInput : tCPPI_IN;
	BusInput1 : tCPPI_PARA;
	EnableOutput : REAL;
	EnableOutput_m : REAL;
	Saturadition : REAL;
	SensorErrorFilter : REAL;
	Divide3 : REAL;
	UnitDelay : UDINT;
END_STRUCT;
D_Work_CPP_Int : STRUCT
	DelayInput1_DSTATE : REAL;
	DiscreteTimeAccumulator_DSTATE : REAL;
	ResettableDelay_DSTATE : REAL;
	UnitDelay_DSTATE : UDINT;
	EngineCycleCounter_DSTATE : UINT;
	FilterCycleCounter_DSTATE : UINT;
	UnitDelay2_DSTATE : BOOL;
	UnitDelay1_DSTATE : BOOL;
	DelayInput1_DSTATE_c : BOOL;
	DelayInput1_DSTATE_f : BOOL;
	DiscreteTimeAccumulator_PrevRes : SINT;
END_STRUCT;
PrevZCSigStates_CPP_Int : STRUCT
	IgnitionPointandPIDurationOffse : USINT;
	CylinderPeakPressureIntegrator_ : USINT;
	ResettableDelay_Reset_ZCE : USINT;
	CylinderPeakPressureErrorCalcul : USINT;
END_STRUCT;
ExternalInputs_CPP_Int : STRUCT
	tCPPI_IN_o : tCPPI_IN;
	tCPPI_PARA_e : tCPPI_PARA;
	tCPPI_PERM_n : tCPPI_PERM;
END_STRUCT;
ExternalOutputs_CPP_Int : STRUCT
	tCPPI_OUT_c : tCPPI_OUT;
	tCPPI_DBUG_o : tCPPI_DBUG;
END_STRUCT;
END_TYPE