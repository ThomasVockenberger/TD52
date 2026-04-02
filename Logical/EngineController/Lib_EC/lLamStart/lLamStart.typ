TYPE


   tLamStart_DBG : STRUCT 
        rLambda_start : REAL; (**)
        rLambda_idle : REAL; (**)
        rLambda_start_raw : REAL; (**)
        rLamLim : REAL; (**)
    END_STRUCT;

   tLamStart_IN : STRUCT 
        rN_Eng : REAL; (*Engine speed [rpm]*)
        rT_EO : REAL; (**)
        bGCB_ON : BOOL; (*Generator curcuit breaker ON [-]*)
        bReset : BOOL; (*Reset Filters [-]*)
    END_STRUCT;

   tLamStart_PARA : STRUCT 
        rN_EngNom : REAL; (*Nominal engine speed [rpm]*)
        rLam_Start_Offs : REAL; (**)
    END_STRUCT;

   tLamStart_PERM : STRUCT 
        rLamSlewRate : REAL; (*slew rate to ramp back to zero offset [1/s]*)
        rTi_idle : REAL; (*ramp back to zero offset after X sec in idle mode [s]*)
        rLamLoLim_N_x : ARRAY[0..2] OF REAL; (*Lower lambda limit lookup depending on engine speed [rpm]*)
        rLamLoLim_N_y : ARRAY[0..2] OF REAL; (*Lower lambda limit lookup depending on engine speed [-]*)
        rLowerOilTemp : REAL; (**)
        rHigherOilTemp : REAL; (**)
        rLowerOilLambda : REAL; (**)
        rHigherOilLambda : REAL; (**)
        refPoint_Lam_N_Offs_x : ARRAY[0..2] OF REAL; (**)
        refPoint_Lam_N_Offs_y : ARRAY[0..2] OF REAL; (**)
    END_STRUCT;
END_TYPE
TYPE
BlockIO_LamStart : STRUCT
	BusInput2 : tLamStart_PERM;
	BusInput : tLamStart_IN;
	BusConversion_InsertedFor_BusOu : tLamStart_DBG;
	BusInput1 : tLamStart_PARA;
	UnitDelay : UDINT;
END_STRUCT;
D_Work_LamStart : STRUCT
	Delay_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE : REAL;
	UnitDelay_DSTATE : UDINT;
	UnitDelay2_DSTATE : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	icLoad : USINT;
END_STRUCT;
PrevZCSigStates_LamStart : STRUCT
	Delay_Reset_ZCE : USINT;
END_STRUCT;
ExternalInputs_LamStart : STRUCT
	IN : tLamStart_IN;
	PARA : tLamStart_PARA;
	PERM : tLamStart_PERM;
END_STRUCT;
ExternalOutputs_LamStart : STRUCT
	rLambda_start_idle : REAL;
	dbg : tLamStart_DBG;
END_STRUCT;
END_TYPE