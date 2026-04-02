

TYPE
	GridStatusDetection_DBG_Bus :  STRUCT   
		rProt_norm :  REAL; (*rotational power normalized [-]*)  
		bDetSpeedRise :  BOOL; (*trigger for grid loss detection based on rotational power or absolute speed threshold*)  
		bDetIslandVPN :  BOOL; (*trigger for grid loss detection based on VPN (voltage, power, speed - Lukas Undevall)*)  
		trigger_Nabs :  BOOL; (*trigger for grid loss detection - absolute speed threshold*)  
		trigger_Prot :  BOOL; (*trigger for grid loss detection - rotational power*)  
		trigger_PU :  BOOL; (*trigger for grid loss detection - power AND voltage (VPN)*)  
		trigger_N :  BOOL; (*trigger for grid loss detection - speed (VPN)*)  
		trigger_U :  BOOL; (*trigger for grid loss detection - voltage (VPN)*)  
		trigger_P :  BOOL; (*trigger for grid loss detection - power (VPN)*)  
		trigger_VS :  BOOL; (*trigger for grid loss detection - VectorShift (VPN)*)  
		block_LVRT_VPN :  BOOL; (*trigger for grid loss detection - LVRT (VPN) block bit for detection*)  
		trigger_LVRT_NoDelay :  BOOL; (*trigger for grid loss detection - VectorShift (VPN)*)  
		rCorrFac_rN_set_Norm :  REAL; (*correction factor for engine speed reference (rpm)*)  
		block_LVRT_speedAbs :  BOOL; (*trigger for grid loss detection - LVRT (speedAbs/rot.pow.) block bit for detection*)  
		bDetGridObserver :  BOOL; (*trigger for grid loss detection based on Grid Observer*)  
		ru_obs :  ARRAY[0..8] OF REAL; (*Std Grid Observer input*)  
		ru_obs_strong :  ARRAY[0..8] OF REAL; (*Strong Grid Observer input*)  
		ru_obs3 :  ARRAY[0..8] OF REAL; (*3rd model Grid Observer input*)  
		ry_obs :  ARRAY[0..1] OF REAL; (*Grid Observer output*)  
		rx_obs :  ARRAY[0..4] OF REAL; (*Std Grid Observer state*)  
		rx_obs_strong :  ARRAY[0..4] OF REAL; (*Strong Grid Observer state*)  
		rx_obs3 :  ARRAY[0..4] OF REAL; (*3rd model Grid Observer state*)  
		rcorr :  ARRAY[0..4] OF REAL; (*Std Grid Observer correction*)  
		rcorr_strong :  ARRAY[0..4] OF REAL; (*Strong Grid Observer correction*)  
		rcorr3 :  ARRAY[0..4] OF REAL; (*3rd model Grid Observer correction*)  
	END_STRUCT;

	GridStatusDetection_IN_Bus :  STRUCT   
		rN_engAct :  REAL; (*engine speed (rpm)*)  
		rU_norm :  REAL; (*normalized voltage ([p.u.])*)  
		rP_norm :  REAL; (*normalized power ([p.u.])*)  
		rQ_norm :  REAL; (*normalized reactive power ([p.u.])*)  
		rUexc_norm :  REAL; (*normalized excitation voltage ([p.u.])*)  
		rF_norm :  REAL; (*normalized frequency ([p.u.])*)  
		rp2s_norm :  REAL; (*normalized boost pressure ([p.u.])*)  
		rN_F_Offset_Norm :  REAL; (*engine speed setpoint offset (-)*)  
		bMCB_On :  BOOL; (*mains circuit breaker feedback (-)*)  
		bGCB_On :  BOOL; (*generator circuit breaker feedback (-)*)  
		bReset :  BOOL; (*Reset filter (-)*)  
		bVectorShift :  BOOL; (*VectorShift protection relays hardware output  (-)*)  
		bLVRT :  BOOL; (*LVRT signal (-)*)  
	END_STRUCT;

	GridStatusDetection_OUT_Bus :  STRUCT   
		rN_F_Offset_Norm_corr :  REAL; (*engine speed setpoint offset, corrected for transition grid parallel to island (-)*)  
		bGridStatus :  BOOL; (*Grid Status bit: True if grid-parallel operation detected, false otherwise (-)*)  
	END_STRUCT;

	GridStatusDetection_PARA_Bus :  STRUCT   
		bEnable :  BOOL; (*Enable the grid status detection function (-)*)  
		rTi_Filt_speed :  REAL; (*filter time constant speed filter for calculation rotational power (s)*)  
		rTi_Filt_factorNoffsetCorr :  REAL; (*filter time constant filter for correction factor of speed ref. offset (s)*)  
		rTi_Tof_MCBfb :  REAL; (*Pulse time TOF for bMCB_fb (s)*)  
		rProt_Norm_limit :  REAL; (*limit  normalized rotational power for grid detection  (-)*)  
		rTi_Tp_DetectActive :  REAL; (*Pulse time Tp for detection (s)*)  
		rThrs_DeltaN_norm :  REAL; (*limit for speed signal deviation for grid detection (p.u.)*)  
		rP_Nom :  REAL; (*nominal engine electrical power (kW)*)  
		rN_Nom :  REAL; (*nominal engine speed  (rpm)*)  
		rJ_Engine :  REAL; (*module inertia (kgm^2)*)  
		iSamples_derivative_PU :  INT; (*time difference for evaluation of power / voltage change (default 20ms = 2) (n Samples)*)  
		iSamples_Tp_detect_VPN :  INT; (*time slot for evalution of violation for power, voltage and speed threshold (default 50ms = 5) (n Samples)*)  
		iSamples_derivative_N :  INT; (*time difference for evaluation of speed change (default 20ms = 2) (n Samples)*)  
		rThrs_U_norm :  REAL; (*threshold for change of normalized voltage per second (1/s)*)  
		rThrs_U_norm_FRTBlock :  REAL; (*threshold for change of normalized voltage per second, after weak FRT blocking was active (1/s)*)  
		iSamples_Tof_U_norm_FRTBlock :  INT; (*time for voltage change threshold rThrs_U_norm_FRTBlock to be active after weak FRT blocking (default 1s = 100) (n Samples)*)  
		rThrs_P_norm :  REAL; (*threshold for change of normalized power per second (1/s)*)  
		rThrs_N_eng :  REAL; (*threshold for change of speed per second (rpm/s)*)  
		rTi_sampleRate :  REAL; (*sample rate of algorithm (default 10ms = 0.01s) (s)*)  
		iDetectMode :  INT; (*selector for detection Method: 1-speedAbs/rot.pow.; 2-VPN detection; 3-combined (-)*)  
		rThrs_LVRT_norm :  REAL; (*voltage threshold to avoid falsely detected positive LVRTs (p.u.)*)  
		iSamples_Tp_LVRT_hold :  INT; (*hold time for LVRT caused blocking (default 3000ms = 300) (n Samples)*)  
		bLimitedTriggerTime :  BOOL; (*limit time slot for evalution of violation for power, voltage and speed threshold to iTi_detect_PandU (-)*)  
		bWeakFRTBlocking :  BOOL; (*blocking of detection only if grid event bit AND voltage below rThrs_LVRT_norm (-)*)  
		bWeakFRTBlocking_VPN :  BOOL; (*blocking of VPN detection only if grid event bit AND voltage below rThrs_LVRT_norm (possibility to block only for VPN) (-)*)  
		bWeakFRTBlocking_speedAbs :  BOOL; (*blocking of speedAbs/rot.pow. detection only if grid event bit AND voltage below rThrs_LVRT_norm (possibility to block only for speedAbs/rot.pow.) (-)*)  
		iSensitivity_WeakBlocking :  INT; (*Sensitivity weak blocking strategy (-)*)  
		bN_BypassFRTBlocking :  BOOL; (*Bypass FRT blocking if absolute speed deviation above threshold (-)*)  
		bN_BypassFRTBlocking_VPN :  BOOL; (*Bypass FRT blocking of VPN detection if absolute speed deviation above threshold (possibility to block only for VPN) (-)*)  
		bN_BypassFRTBlocking_speedAbs :  BOOL; (*Bypass FRT blocking of speedAbs/rot.pow. detection if absolute speed deviation above threshold (possibility to block only for speedAbs/rot.pow.) (-)*)  
		bEnable_SmoothDetection :  BOOL; (*Enable grid observer algorithm for detection of smooth islanding events (-)*)  
		iSensitivity_SmoothDetection :  INT; (*Sensitivity of grid observer algorithm for detection of smooth islanding events (-)*)  
	END_STRUCT;

	GridStatusDetection_PERM_Bus :  STRUCT   
		dummy :  REAL; (**)  
	END_STRUCT;

END_TYPE

TYPE
rtB_TofLvrtWeakBlk1_GridStat : STRUCT
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TofLvrtWeakBlk1_GridStat : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_TpDetNabsProtTrigger_GridSt : STRUCT
	Merge : REAL;
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TpDetNabsProtTrigger_GridS : STRUCT
	DelayInput2_DSTATE : REAL;
	UnitDelay2_DSTATE : BOOL;
END_STRUCT;
BlockIO_GridStat : STRUCT
	BusConversion_InsertedFor_BusOu : GridStatusDetection_DBG_Bus;
	BusInput : GridStatusDetection_PARA_Bus;
	BusInput2 : GridStatusDetection_IN_Bus;
	BusInput1 : GridStatusDetection_PERM_Bus;
	UnitDelay : UDINT;
	TpUTrigger : rtB_TpDetNabsProtTrigger_GridSt;
	TpPTrigger : rtB_TpDetNabsProtTrigger_GridSt;
	TpNTrigger : rtB_TpDetNabsProtTrigger_GridSt;
	TpLvrtTrigHold2 : rtB_TpDetNabsProtTrigger_GridSt;
	TpLvrtBlockHold2 : rtB_TpDetNabsProtTrigger_GridSt;
	TpDetVPNTrigger : rtB_TpDetNabsProtTrigger_GridSt;
	TofLvrtWeakBlk2 : rtB_TofLvrtWeakBlk1_GridStat;
	TofAfterFRT : rtB_TofLvrtWeakBlk1_GridStat;
	TP_PU_trigger : rtB_TpDetNabsProtTrigger_GridSt;
	TofReset : rtB_TofLvrtWeakBlk1_GridStat;
	TofMcbFb : rtB_TofLvrtWeakBlk1_GridStat;
	TpProtTrigger : rtB_TpDetNabsProtTrigger_GridSt;
	TpNabsTrigger : rtB_TpDetNabsProtTrigger_GridSt;
	TpLvrtTrigHold1 : rtB_TpDetNabsProtTrigger_GridSt;
	TpLvrtBlockHold1 : rtB_TpDetNabsProtTrigger_GridSt;
	TpDetNabsProtTrigger : rtB_TpDetNabsProtTrigger_GridSt;
	TofLvrtWeakBlk1 : rtB_TofLvrtWeakBlk1_GridStat;
END_STRUCT;
D_Work_GridStat : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	TappedDelay_X : ARRAY[0..9] OF REAL;
	TappedDelay1_X : ARRAY[0..9] OF REAL;
	TappedDelay2_X : ARRAY[0..9] OF REAL;
	TappedDelay_X_l : ARRAY[0..9] OF REAL;
	TappedDelay2_X_b : ARRAY[0..9] OF REAL;
	TappedDelay3_X : ARRAY[0..9] OF REAL;
	TappedDelay5_X : ARRAY[0..9] OF REAL;
	TappedDelay4_X : ARRAY[0..9] OF REAL;
	TappedDelay1_X_m : ARRAY[0..9] OF REAL;
	DiscreteTimeIntegrator_DSTATE_j : REAL;
	UnitDelay_DSTATE : UDINT;
	U_past : ARRAY[0..999] OF REAL;
	err_past : ARRAY[0..999] OF REAL;
	err_min : REAL;
	err_act : REAL;
	err_max : REAL;
	err_act_temp : ARRAY[0..4] OF REAL;
	err_past_Q : ARRAY[0..999] OF REAL;
	err_min_Q : REAL;
	err_act_Q : REAL;
	err_max_Q : REAL;
	err_act_temp_Q : ARRAY[0..4] OF REAL;
	ctr_U : INT;
	ctr_err : INT;
	ctr_acterr : INT;
	ctr_release : INT;
	ctr_err_Q : INT;
	ctr_acterr_Q : INT;
	ctr_release_Q : INT;
	IslandDetected_DSTATE : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_g : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	icLoad : BOOL;
	U_past_not_empty : BOOL;
	err_past_not_empty : BOOL;
	flag_window : BOOL;
	err_past_Q_not_empty : BOOL;
	flag_window_Q : BOOL;
	TpUTrigger : rtDW_TpDetNabsProtTrigger_GridS;
	TpPTrigger : rtDW_TpDetNabsProtTrigger_GridS;
	TpNTrigger : rtDW_TpDetNabsProtTrigger_GridS;
	TpLvrtTrigHold2 : rtDW_TpDetNabsProtTrigger_GridS;
	TpLvrtBlockHold2 : rtDW_TpDetNabsProtTrigger_GridS;
	TpDetVPNTrigger : rtDW_TpDetNabsProtTrigger_GridS;
	TofLvrtWeakBlk2 : rtDW_TofLvrtWeakBlk1_GridStat;
	TofAfterFRT : rtDW_TofLvrtWeakBlk1_GridStat;
	TP_PU_trigger : rtDW_TpDetNabsProtTrigger_GridS;
	TofReset : rtDW_TofLvrtWeakBlk1_GridStat;
	TofMcbFb : rtDW_TofLvrtWeakBlk1_GridStat;
	TpProtTrigger : rtDW_TpDetNabsProtTrigger_GridS;
	TpNabsTrigger : rtDW_TpDetNabsProtTrigger_GridS;
	TpLvrtTrigHold1 : rtDW_TpDetNabsProtTrigger_GridS;
	TpLvrtBlockHold1 : rtDW_TpDetNabsProtTrigger_GridS;
	TpDetNabsProtTrigger : rtDW_TpDetNabsProtTrigger_GridS;
	TofLvrtWeakBlk1 : rtDW_TofLvrtWeakBlk1_GridStat;
END_STRUCT;
PrevZCSigStates_GridStat : STRUCT
	IslandDetected_Reset_ZCE : USINT;
END_STRUCT;
ExternalOutputs_GridStat : STRUCT
	Out : GridStatusDetection_OUT_Bus;
	dbg : GridStatusDetection_DBG_Bus;
END_STRUCT;
tag_RTM_GridStat : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_GridStat;
	prevZCSigState : REFERENCE TO PrevZCSigStates_GridStat;
	outputs : REFERENCE TO ExternalOutputs_GridStat;
	dwork : REFERENCE TO D_Work_GridStat;
END_STRUCT;
RT_MODEL_GridStat : tag_RTM_GridStat;
END_TYPE
TYPE
END_TYPE