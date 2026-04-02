TYPE


   tPFPDR_Dbg : STRUCT 
        rT_Sampling : REAL; (*Cycle Time, for which PFPDR was compiled*)
        rCA_IP_aDR : ARRAY[0..24] OF REAL; (*Ignition profile snapshot after duration run [°CA]*)
        rCA_IP_bDR : ARRAY[0..24] OF REAL; (*Ignition profile snapshot before duration run [°CA]*)
        rCA_IP_aDR_Avg : REAL; (*average of ignition profile snapshot after duration run [°CA]*)
        rCA_IP_bDR_Avg : REAL; (*average of ignition profile snapshot before duration run [°CA]*)
        bAbort_DR : ARRAY[0..2] OF BOOL; (*PFPDR Abort conditions*)
    END_STRUCT;

   tPFPDR_In : STRUCT 
        bStartTrigger : BOOL; (*TRUE = starts PFPDR routine if in steady state*)
        rT_EG_Act : ARRAY[0..24] OF REAL; (*Actual exhaust gas temperature [°C]*)
        rCA_IP_Act : ARRAY[0..24] OF REAL; (*Actual ignition point [°CA]*)
        rCA_IP_Set : REAL; (*Ignition setpoint [°CA]*)
        rCA_Knck_Red : ARRAY[0..24] OF REAL; (*Ignition point reduction due knocking [°CA]*)
        iNum_Cyl : USINT; (*Number of cylinders*)
        rT_EG_Avg : REAL; (*Actual average exhaust gas temperature [°C]*)
        bMisfLim : BOOL; (*Misfire Limit reached, goto lambda decrease steps*)
        bManAbort : BOOL; (*Manual Abort PFPDR and EGTSR*)
        bReset : BOOL; (*Resets the Integrators in the Steady State machine*)
        rLam_Act : REAL; (*Actual Lambda of Engine [Lambda]*)
        bPFPDR_Profile : BOOL; (*is the engine currently running a PFPDR Profile? if Yes the engine is old*)
        rPos_CBV : REAL; (*position of compressor by pass [-]*)
        bSteadyState : BOOL; (*TRUE = starts PFPDR routine if in start trigger*)
    END_STRUCT;

   tPFPDR_Out : STRUCT 
        iState : ARRAY[0..1] OF INT; (*Statemachine states [0]: 0=IDLE, 1=PFPDR, 2=EGT; [1]: 0= no Substate, 1=Start, 2=Ignition, 3=Lambda, 4=Save, 5=LamReturn, 6= IgnReturn*)
        rLam_DR_Offs : REAL; (*Lambda offset during detection run [Lambda]*)
        rCA_IP_DR_Offs : REAL; (*Ignition point offset during detection run [°CA]*)
        bLeanox_Man : BOOL; (*Leanox has to be taken in manual mode if TRUE*)
        rCA_IP_DR_Profile : ARRAY[0..24] OF REAL; (*Calculated ignition point offset from detection run [°CA]*)
        rCA_IP_EGT_Profile : ARRAY[0..24] OF REAL; (*Calculated ignition point offset from EGT deviation [°CA]*)
        bPFPDR_act : BOOL; (*PFPDR is active*)
        bEGTSR_act : BOOL; (*EGTSR is active*)
        bZYLOPT_OFF : BOOL; (*force ZYLOPT OFF if true*)
    END_STRUCT;

   tPFPDR_Para : STRUCT 
        rCA_IP_MaxLim : REAL; (*Ignition point maximum limit eg. type4 = 27 [°CA]*)
        rT_EG_DevLim : REAL; (*Exhaust gas temperature deviation limit from average, e.g. 10 [°C]*)
        rCA_IP_EGT : REAL; (*Ignition point offset if exhaust gas deviation occurs eg. 1 [°CA]*)
        rTi_EGT_Delay : REAL; (*Time delay before EGT devation routine starts eg. 180 [s]*)
        rLam_DR_Lim : REAL; (*maximum delta lamba during duration run [lambda]*)
        rLam_DR_SR : REAL; (*lambda slew rate during duration run [lambda/s]*)
        rLam_DR_SR_Return : REAL; (*lambda slew rate after duration run [lambda/s]*)
        rCA_IP_DR_SR : REAL; (*ignition point slew rate during duration run [°CA/s]*)
        rCA_IP_DR_SR_Return : REAL; (*ignition point slew rate after duration run [°CA/s]*)
        rPos_CBV_Opt : REAL; (*optimized position of compressor by pass [-]*)
        rPos_CBV_Hys : REAL; (*hysterese position of compressor by pass [-]*)
        rT_Abort_Delay : REAL; (*delay of abort [s]*)
        rT_Abort_Filter : REAL; (*filter of abort [s]*)
    END_STRUCT;
END_TYPE
TYPE
rtB_TON_AC_PFPDR : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON_AC_PFPDR : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
BlockIO_AC_PFPDR : STRUCT
	BusInput1 : tPFPDR_In;
	BusConversion_InsertedFor_BusOu : tPFPDR_Out;
	BusConversion_InsertedFor_Bus_c : tPFPDR_Dbg;
	BusInput : tPFPDR_Para;
	rT_EG_Act : ARRAY[0..24] OF REAL;
	rCA_IP_Act : ARRAY[0..24] OF REAL;
	rLam_Act : REAL;
	rCA_IP_MaxLim : REAL;
	rT_EG_DevLim : REAL;
	rCA_IP_EGT : REAL;
	Divide : REAL;
	Product : REAL;
	Product1 : REAL;
	Product2 : REAL;
	Product3 : REAL;
	rCA_IP_aDR : ARRAY[0..24] OF REAL;
	rCA_IP_bDR_Avg : REAL;
	rCA_IP_DR_Offs : REAL;
	rLam_DR_Offs : REAL;
	rCA_IP_bDR : ARRAY[0..24] OF REAL;
	rCA_IP_aDR_Max : REAL;
	rCA_IP_EGT_Offs : ARRAY[0..24] OF REAL;
	rCA_IP_aDR_Offs : ARRAY[0..24] OF REAL;
	iState : INT;
	iSubState : INT;
	u4Cylinder : USINT;
	bStartTrigger : BOOL;
	bMisfLim : BOOL;
	bManAbort : BOOL;
	bReset : BOOL;
	bSteadyState : BOOL;
	UnitDelay : BOOL;
	UnitDelay1 : BOOL;
	UnitDelay2 : BOOL;
	bLeanox_Man : BOOL;
	bPFPDR_active : BOOL;
	bEGTSR_active : BOOL;
	TON1 : rtB_TON_AC_PFPDR;
	TON : rtB_TON_AC_PFPDR;
END_STRUCT;
D_Work_AC_PFPDR : STRUCT
	iCnt : REAL;
	rLam_bDR : REAL;
	rCA_IgnP_Act_Filt : ARRAY[0..24] OF REAL;
	rCnt_Filt : REAL;
	UnitDelay_DSTATE : BOOL;
	UnitDelay1_DSTATE : BOOL;
	UnitDelay2_DSTATE : BOOL;
	UnitDelay2_DSTATE_l : BOOL;
	is_active_c6_AC_PFPDR : USINT;
	is_c6_AC_PFPDR : USINT;
	is_DetectionRun : USINT;
	bDR_Done : BOOL;
	bDR_Lam : BOOL;
	bEGT_Done : BOOL;
	TON1 : rtDW_TON_AC_PFPDR;
	TON : rtDW_TON_AC_PFPDR;
END_STRUCT;
END_TYPE