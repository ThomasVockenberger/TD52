

TYPE
	DAI_Dbg_Bus :  STRUCT   
		rFlow_eng_des :  REAL; (*Desired engine mass flow (kg/s)*)  
		rFlow_eng_act :  REAL; (*Actual engine mass flow (kg/s)*)  
		rCd :  ARRAY[0..1] OF REAL; (*Cd value (-)*)  
		rPos_AirValve :  ARRAY[0..1] OF REAL; (*Position air valve (%)*)  
	END_STRUCT;

	DAI_In_Bus :  STRUCT   
		rPr_P2s_A :  REAL; (*Boost pressure bank A (bar)*)  
		rPr_P2s_B :  REAL; (*Boost pressure bank B (bar)*)  
		rPr_P2s_Avg :  REAL; (*Boost pressure average (bar)*)  
		rPr_P2s_des :  REAL; (*Desired boost pressure (Gen2) (bar)*)  
		rT_T2s :  REAL; (*Intake manifold temperature (degC)*)  
		rPr_DAI_In :  REAL; (*air pressure upstream shut off valve (bar)*)  
		rPr_DAI_A :  REAL; (*air pressure upstream control valve bank A (bar)*)  
		rPr_DAI_B :  REAL; (*air pressure upstream control valve bank B (bar)*)  
		rT_DAI :  REAL; (*air temperature upstream of control valves (degC)*)  
		rN_Eng :  REAL; (*Engine speed (rpm)*)  
		rN_Set_Norm :  REAL; (*Engine speed setpoint normalized (-)*)  
		rV_EngDis :  REAL; (*Engine displacement (m3)*)  
		rVE_Eng :  REAL; (*Volumetric efficiency (-)*)  
		iOpMode :  INT; (*Operation mode (-)*)  
		bP_Set_reached :  BOOL; (*target load reached (-)*)  
		bDAI_ena :  BOOL; (*DAI enabled (-)*)  
		Test :  DAI_Test_Bus; (*Testing inputs (-)*)  
		bAMM_Pr_AirStarter_Tank_Lo :  BOOL; (*warning starter tank pressure low trigger (-)*)  
		rP_GEN2_Norm :  REAL; (*normed Power trajectory from GEN2 (-)*)  
	END_STRUCT;

	DAI_Out_Bus :  STRUCT   
		rPos_DAI_Set_A :  REAL; (*Position air assist control valve bank A (pu)*)  
		rPos_DAI_Set_B :  REAL; (*Position air assist control valve bank B (pu)*)  
		bDAI_V_Dem :  BOOL; (*open (true) DAI slamshut valve (-)*)  
		bDAI_Tank_Pr_Ena :  BOOL; (*starter tank pressure DAI enable (-)*)  
		bDAI_DP_Warn :  BOOL; (*pressure difference DAI warning (-)*)  
		rFlow_DAI_Dem :  REAL; (*demanded DAI air mass flow  (-)*)  
	END_STRUCT;

	DAI_Para_Bus :  STRUCT   
		rN_EngNom :  REAL; (*Nominal engine speed (rpm)*)  
		bDAI_Active :  BOOL; (*Activate intake assist part (-)*)  
		bDAI_Active_Start :  BOOL; (*DAI active during speed ramp (-)*)  
		bDAI_Active_PowRamp :  BOOL; (*DAI active during load ramp (-)*)  
		bDAI_Active_NetP :  BOOL; (*DAI active in grid mode (-)*)  
		bDAI_Active_Island :  BOOL; (*DAI active in isolated mode (-)*)  
		rN_DAI_On :  REAL; (*Engine speed to activate DAI during speed ramp  (rpm)*)  
		rN_DAI_Off :  REAL; (*Engine speed to deactivate DAI during speed ramp  (rpm)*)  
		rGain_DAI_Start :  REAL; (*DAI gain mass flow speed ramp (-)*)  
		rGain_DAI :  REAL; (*DAI gain mass flow (-)*)  
	END_STRUCT;

	DAI_Perm_Bus :  STRUCT   
		rMaxFlow :  REAL; (*Max mass flow request air assist (kg/s)*)  
		rRateLimPos :  REAL; (*Rate limitation of the air mass request, 0 no rate limit (kg/s/s)*)  
		rRateLimNeg :  REAL; (*Rate limitation of the air mass request (kg/s/s)*)  
		rDiam :  REAL; (*Diameter of DAI control valve (m)*)  
		iNumValve :  USINT; (*Number of DAI control valves (-)*)  
		rGainFlow :  REAL; (*Gain at output of valve position request (-)*)  
		rDisBrkPts :  ARRAY[0..10] OF REAL; (*Discharge coeff breakpoints DAI control valve (-)*)  
		rPosBrkPts :  ARRAY[0..10] OF REAL; (*Position breakpoints  DAI control valve (%)*)  
		rFlowActOn :  REAL; (*Mass flow request to enable DAI (kg/s)*)  
		rFlowActHyst :  REAL; (*Mass flow request to enable DAI hysteresis (kg/s)*)  
		rNDiffOff :  REAL; (*Speed deviation request to enable DAI (rpm)*)  
		rNDiffOn :  REAL; (*Speed deviation request to disable DAI (rpm)*)  
		rPrDiffHyst :  REAL; (*pressure difference  to enable DAI hysteresis (bar)*)  
		rPrDiffOn :  REAL; (*pressure difference  to enable DAI (bar)*)  
		rRefValve_x :  ARRAY[0..4] OF REAL; (*Valve Position correction x-value (pu)*)  
		rRefValve_y :  ARRAY[0..4] OF REAL; (*Valve Position correction y-value (pu)*)  
		rNref_ff :  ARRAY[0..2] OF REAL; (*feed forward during speed ramp, speed normalized (x) (pu)*)  
		rFlowRef_ff :  ARRAY[0..4] OF REAL; (*feed forward during speed ramp, flow (y) (kg/s)*)  
		rRefFlowMaxP2s_x :  ARRAY[0..4] OF REAL; (*Maxmum mass flow based on p2s (x) (bar)*)  
		rRefFlowMaxP2s_y :  ARRAY[0..4] OF REAL; (*Maxmum mass flow based on p2s (y) (kg/s)*)  
		rTi_P_Set_reached_delay :  REAL; (*time delay after target load reached (s)*)  
	END_STRUCT;

	DAI_Test_Bus :  STRUCT   
		bManEnable :  BOOL; (*Enable manual mode (-)*)  
		rManMassReq :  REAL; (*Manual air mass request (kg/s)*)  
		bManPosEnable :  BOOL; (*Enable manual position mode (-)*)  
		rManPos :  ARRAY[0..1] OF REAL; (*Manual air assist position (pu)*)  
	END_STRUCT;

END_TYPE

TYPE
rtB_Hystersis_DAI : STRUCT
	Out : BOOL;
END_STRUCT;
rtDW_Hystersis_DAI : STRUCT
	Inter : BOOL;
END_STRUCT;
BlockIO_DAI : STRUCT
	BusInput2 : DAI_Perm_Bus;
	BusInput3 : DAI_In_Bus;
	BusInput1 : DAI_Para_Bus;
	BusCreator1 : DAI_Dbg_Bus;
	BusCreator : DAI_Out_Bus;
	UnitDelay : UDINT;
	sf_Hystersis2 : rtB_Hystersis_DAI;
	sf_Hystersis : rtB_Hystersis_DAI;
END_STRUCT;
D_Work_DAI : STRUCT
	UD_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE : REAL;
	DelayInput2_DSTATE : REAL;
	UnitDelay_DSTATE : UDINT;
	DiscreteTimeIntegrator_PrevRese : SINT;
	bStart2Idle : BOOL;
	Inter : BOOL;
	Inter_n : BOOL;
	sf_Hystersis2 : rtDW_Hystersis_DAI;
	sf_Hystersis : rtDW_Hystersis_DAI;
END_STRUCT;
ConstBlockIO_DAI : STRUCT
	DataTypeConversion3 : UDINT;
	Conversion : REAL;
END_STRUCT;
tag_RTM_DAI : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_DAI;
	dwork : REFERENCE TO D_Work_DAI;
END_STRUCT;
RT_MODEL_DAI : tag_RTM_DAI;
END_TYPE
TYPE
END_TYPE