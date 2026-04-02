TYPE


   tFsync_Debug : STRUCT 
        iSkipCounter : UINT; (**)
        rSwitchSurf : REAL; (**)
        Sf1 : BOOL; (**)
        Sf2 : BOOL; (**)
        H3 : BOOL; (**)
        H4 : BOOL; (**)
        rSmodSlid : REAL; (**)
        iCounterSwitch : UINT; (**)
        bEna : BOOL; (**)
        iNskip_init : USINT; (**)
        iCtrSel : SINT; (**)
        iNumSkipCyl_P : SINT; (*P-part*)
        rN_Set : REAL; (*Speed set poinnt*)
        rN_Eng : REAL; (*Actual speed*)
    END_STRUCT;

   tFsync_Inputs : STRUCT 
        bGCB_ON : BOOL; (*Generator circuit breaker closed*)
        rN_Eng : REAL; (*Engine speed in rpm*)
        rF_MMD : REAL; (*Generator frequency [Hz]*)
        rAng_MMD_Diff : REAL; (*Electric angle in deg.*)
        rF_MMD_BusBar : REAL; (*Bus bar frequency in Hz*)
        rT_EO : REAL; (**)
        iIdx_SyOMSS : INT; (*synchronization operating mode selection
0..OFF
1..MAN
2..AUTO*)
        bReset : BOOL; (*reset library*)
    END_STRUCT;

   tFsync_Para : STRUCT 
        rN_Offs_Sync : REAL; (**)
        rF_Nom : REAL; (**)
        rN_EngNom : REAL; (**)
        bFastSync : BOOL; (**)
    END_STRUCT;

   tFsync_Perm : STRUCT 
        bSpeedSet_ena : BOOL; (*Select the setpoint (1: constant speed, 0: grid frequency)*)
        iCtrSel : SINT; (*Control selection. 1-Std skip firing. 2-Time optimal 3-Time optimal with constraints. 4-Fuel and time optimal. 5-Modified skip f*)
        rN_SetTol : REAL; (*Speed band for speed regulation (rpm, valid only for standard approach)*)
        iSkipCounterLimit : UINT; (*Dwell time for skip firing (in number of 10ms, valid only for the standard approach)*)
        rAngleSetDeg : REAL; (*Electric angle setpoint (in deg, tuning parameter)*)
        rRelaxAngleDeg : REAL; (*Relaxation band for the electric angle setpoint (in deg, tuning parameter)*)
        rWeightFuel : REAL; (*Weighting (high->time, low->fuel)*)
        rHystOptimal : REAL; (*Band around switching surface (nonnegative >=0)*)
        iNum_SkipMax : USINT; (*Maximum cylinders skipped (<=20)*)
        iNum_SkipMin : USINT; (*Minimum number of cylinders (>=0)*)
        rTi_FiltF : REAL; (*Filter constant for grid frequency [s]*)
        rN_enableNorm : REAL; (*Engine speed normalized to enable fast sync controller [-]*)
        rN_idleNorm : REAL; (*Engine speed normalized to enable fast sync controller [-]*)
        rTi_FastSync : REAL; (*switch over to standard controller after this time [s]*)
        bF_act_ena : BOOL; (*use generator frequency as actual value*)
        rT_Cold : REAL; (**)
        rT_Warm : REAL; (**)
        iNum_SkipCyl_Cold : USINT; (*Init skipped cyl at T_Cold*)
        iNum_SkipCyl_Warm : USINT; (*Init skipped cyl at T_Warm*)
        rGain_P : REAL; (*Gain for P-part [NumSkippedCyl/rpm]*)
        iNum_SkipCylLim_P : SINT; (*Limit for P-part [NumSkippedCyl]*)
        bStdCtrl : BOOL; (*Standard controller enabled in AutoCode*)
    END_STRUCT;
END_TYPE
TYPE
BlockIO_FSync : STRUCT
	BusInput1 : tFsync_Perm;
	BusInput : tFsync_Inputs;
	BusInput2 : tFsync_Para;
	UnitDelay : UDINT;
	bEnabled : BOOL;
END_STRUCT;
D_Work_FSync : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	UnitDelay_DSTATE : UDINT;
	rN_Set_old : REAL;
	skipcounter : UINT;
	Count_Switch : UINT;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	cyl_skipped : USINT;
	ssr : BOOL;
	ssr_Set : BOOL;
	cyl_skipped_not_empty : BOOL;
	bSkipDrehz_O : BOOL;
	bSkipDrehz_U : BOOL;
	No_Access : BOOL;
END_STRUCT;
ExternalInputs_FSync : STRUCT
	In : tFsync_Inputs;
	Para : tFsync_Para;
	Perm : tFsync_Perm;
END_STRUCT;
ExternalOutputs_FSync : STRUCT
	SkipCyl : USINT;
	dbg : tFsync_Debug;
END_STRUCT;
END_TYPE