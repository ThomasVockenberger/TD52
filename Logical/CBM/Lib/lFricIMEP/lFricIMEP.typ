TYPE


   LookupData_3P : STRUCT 
        Sig : ARRAY[0..2] OF REAL; (*interpolation point*)
        Comp : ARRAY[0..2] OF REAL; (*interpolation point*)
    END_STRUCT;

   LookupData_EO : STRUCT 
        TEO : ARRAY[0..2] OF REAL; (*engine oil temperature*)
        Comp : ARRAY[0..2] OF REAL; (*interpolation point*)
    END_STRUCT;

   LookupData_PMEP : STRUCT 
        P2_IP : ARRAY[0..9] OF REAL; (*interpolation point*)
        PMEP_IP : ARRAY[0..9] OF REAL; (*interpolation point*)
    END_STRUCT;

   LookupData_WG : STRUCT 
        WG_Pos : ARRAY[0..2] OF REAL; (*interpolation point*)
        Comp : ARRAY[0..2] OF REAL; (*interpolation point*)
    END_STRUCT;

   tFMEPDebug : STRUCT 
        Pfric : REAL; (*friction power [kW]*)
        P_kin : REAL; (*kinetic power [kW]*)
        omega_dot : REAL; (**)
        Power : REAL; (*filtered actual electrical power [kW]*)
        FD_Param_Diff : ARRAY[0..1] OF REAL; (**)
        FD_Param_Abs : ARRAY[0..1] OF REAL; (**)
        BMEP : REAL; (*brake mean effective pressure [bar]*)
        PMEP : REAL; (*pump mean effective pressure [bar]*)
        IMEP_avg : REAL; (*average of the IMEP values [bar]*)
        Pmech : REAL; (*mechanical power output [kW]*)
        Condition_ON : BOOL; (*monitoring is active*)
        Pind : REAL; (*indicated power [kW]*)
        FMEP : REAL; (*friction mean effective pressure [bar]*)
        Pact : REAL; (*actual electrical power [kW]*)
        Speed : REAL; (*actual engine speed [rpm]*)
        Condition_dbg : ARRAY[0..6] OF BOOL; (*monitoring is active*)
    END_STRUCT;

   tFMEPIn : STRUCT 
        bVltg_reset : BOOL; (*reset bit for the voltage monitoring part*)
        U_L1L2 : REAL; (*concatenated voltage L1L2 [V]*)
        U_L2L3 : REAL; (*concatenated voltage L2L3 [V]*)
        U_L3L1 : REAL; (*concatenated voltage L1L2 [V]*)
        Reset_fastfilt : BOOL; (*Reset for friction power filter  - fast filtering*)
        Reset_slowfilt : BOOL; (*Reset for friction power filter  - slow filtering*)
        WGM_reset : BOOL; (*reset bit for the wastegate monitoring part*)
        PF_Act : REAL; (*actual power factor*)
        T_EO : REAL; (*engine oil temperature [°C]*)
        bExt_dist : REAL; (*external disturbens*)
        rPos_Set_WG_Norm : REAL; (*normed position setpoint for wastegate [p.u.]*)
        bReset_P_kin : BOOL; (*Reset integrator of P_kin*)
        Man_Cond_On : BOOL; (*manual override to set the condition to ON*)
        bGCBON : BOOL; (*generator circuit breaker closed information*)
        bMCBON : BOOL; (*main circuit breaker closed information*)
        Pact : REAL; (*actual power [kW]*)
        bPBCSensErr : ARRAY[0..24] OF BOOL; (*information regarding sensor error*)
        rPrIMEP : ARRAY[0..24] OF REAL; (*indicated mean effectiv pressure [bar]*)
        Speed : REAL; (*engine speed [rpm]*)
        rPrChP2s : REAL; (*unfiltered Average charge pressure p2' (after throttle valve) [bar] (rPr_Ch_P2s_Avg_UF)*)
        I_L1 : REAL; (*current L1 [A]*)
        I_L2 : REAL; (*current L2 [A]*)
        I_L3 : REAL; (*current L3 [A]*)
        bLimpHomeCylG2 : ARRAY[0..24] OF BOOL; (*cylinder in limp home G2 mode*)
        bLimpHomeCyl : ARRAY[0..24] OF BOOL; (*cylinder in limp home*)
        bLimpHomeCylExt : ARRAY[0..24] OF BOOL; (*cylinder in limp home extended*)
    END_STRUCT;

   tFMEPOut : STRUCT 
        Fault_Abs : BOOL; (*Fault_Absolute*)
        Fault_Diff : BOOL; (*Fault_Difference*)
    END_STRUCT;

   tFMEPParameter : STRUCT 
        PFComp_CC : LookupData_3P; (**)
        PFComp_G_CC : LookupData_3P; (**)
        WGM_FaultThrsh : REAL; (*wastegate monitoring fault threshold*)
        WGM_Tconst : REAL; (*wastegate monitoring time constant [sec]*)
        WGM_y0 : REAL; (*wastegate monitoring initial condition*)
        WGM_TDly : REAL; (*wastegate monitoring time delay [sec]*)
        ExtDist_TDly : REAL; (*time delay after a external disturbtion*)
        WGComp_CC : LookupData_WG; (*wastegate compensation characteristic curve*)
        TEOComp_CC : LookupData_EO; (*engine oil compensation characteristic curve*)
        PMEP_CC : LookupData_PMEP; (*PMEP characteristic curve*)
        rP_Nom : REAL; (*nominal electric power [kW], depends on gastype*)
        rIC_Power_filt : REAL; (**)
        rInertia : REAL; (*Inertia of engine plus generator [kgm2]*)
        Speedrange : REAL; (*speed range for load step detection (+/-) [rpm]*)
        rTconst_Power_Filt : REAL; (*time constant for Power filter*)
        rTconst_fricflt_fastfilt : REAL; (*Time constant of friction power filter  - fast filtering*)
        rTconst_fricflt_slowfilt : REAL; (*Time constant of friction power filter  - slow filtering*)
        Abs_Thrsh : REAL; (*Threshold set to compare the absolute value of friction power for fault detection*)
        Diff_Thrsh : REAL; (*Threshold set to compare the friction power difference value of fast and slow filter for fault detection*)
        rPower_Thrsh : REAL; (*Power threshold to switch on fault detection algorithm [kW]*)
        rEngine_Vd : REAL; (*Engine displacement volume [m³]*)
        NumberOfCylinder : REAL; (*Number of cylinder*)
        rD_P_kin : REAL; (*Derivative gain*)
        rN_P_kin : REAL; (*Derivative filter*)
        rD0_init : REAL; (*Init value for derivative filter*)
        rNEngNom : REAL; (*nominal engine speed [rpm]*)
        LoadStep_TDly : REAL; (*time delay after a detected load step [sec]*)
        Vltg_FaultThrsh : REAL; (*voltage monitoring fault threshold*)
        Vltg_Tconst : REAL; (*voltage monitoring time constant [sec]*)
        Vltg_y0 : REAL; (*voltage monitoring initial condition*)
        Vltg_TDly : REAL; (*voltage monitoring time delay [sec]*)
        IMEPVali_Fac : REAL; (*factor for the imep validation layer*)
    END_STRUCT;
END_TYPE
TYPE
B_TON_J920_fric : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
DW_TON_J920_fric : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
B_J920_fric : STRUCT
	BusInput : tFMEPParameter;
	BusInput1 : tFMEPIn;
	UnitDelay : UDINT;
	TON_n : B_TON_J920_fric;
	TON_e : B_TON_J920_fric;
	TON_i : B_TON_J920_fric;
	TON : B_TON_J920_fric;
END_STRUCT;
DW_J920_fric : STRUCT
	y_1 : LREAL;
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE_a : REAL;
	DiscreteTimeIntegrator_DSTATE_h : REAL;
	DiscreteTimeIntegrator_DSTATE_f : REAL;
	DiscreteTimeIntegrator_DSTATE_o : REAL;
	Filter1_DSTATE : REAL;
	Delay_DSTATE : ARRAY[0..1] OF REAL;
	DiscreteTimeIntegrator_DSTATE_e : REAL;
	DiscreteTimeIntegrator_DSTATE_g : REAL;
	DiscreteTimeIntegrator_DSTATE_p : REAL;
	UnitDelay_DSTATE : UDINT;
	DelayInput1_DSTATE : BOOL;
	DelayInput1_DSTATE_k : BOOL;
	DelayInput1_DSTATE_h : BOOL;
	DelayInput1_DSTATE_c : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_f : SINT;
	DiscreteTimeIntegrator_PrevRe_j : SINT;
	DiscreteTimeIntegrator_PrevRe_p : SINT;
	DiscreteTimeIntegrator_PrevRe_d : SINT;
	DiscreteTimeIntegrator_PrevRe_k : SINT;
	DiscreteTimeIntegrator_PrevR_dw : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	DiscreteTimeIntegrator_IC_LOA_m : USINT;
	DiscreteTimeIntegrator_IC_LOA_l : USINT;
	DiscreteTimeIntegrator_IC_LOA_b : USINT;
	DiscreteTimeIntegrator_IC_LOA_e : USINT;
	Filter1_IC_LOADING : USINT;
	DiscreteTimeIntegrator_IC_LOA_j : USINT;
	DiscreteTimeIntegrator_IC_LO_el : USINT;
	DiscreteTimeIntegrator_IC_LO_jk : USINT;
	TON_n : DW_TON_J920_fric;
	TON_e : DW_TON_J920_fric;
	TON_i : DW_TON_J920_fric;
	TON : DW_TON_J920_fric;
END_STRUCT;
ExtU_J920_fric : STRUCT
	IN : tFMEPIn;
	para : tFMEPParameter;
END_STRUCT;
ExtY_J920_fric : STRUCT
	OUT : tFMEPOut;
	dbg : tFMEPDebug;
END_STRUCT;
END_TYPE