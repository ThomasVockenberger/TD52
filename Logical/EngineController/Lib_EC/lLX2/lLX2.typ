TYPE


   tLX2_CTR_DBUG : STRUCT 
        rCtrlError : REAL; (*Error between NOx,set and NOx,act_filt [ppm]*)
        rPr_offset_Ctrl : REAL; (*Output of I-Controler [bar]*)
        rPr_LX2_offset_preSat : REAL; (*LX2 delta_p2s_LX2 before Saturation [bar]*)
        bLX2_inSaturation : BOOL; (*true, if LX2 is in Saturation*)
        rNOx_act_filt : REAL; (*filtered NOx signal [ppm]*)
        rPr_Ctrl_LowerLim_act : REAL; (*Controler Output - Lower Limit actuel [bar]*)
        rPr_Ctrl_UpperLim_act : REAL; (*Controler Output - Upper Limit actuel [bar]*)
        rPr_offset_BPOC_all : REAL; (*interpolated delta_p2s from BPOC_Gas 1-4 [bar]*)
        rPr_y0_Ctrl : REAL; (*initial conditions of controler [bar]*)
        rLX2_inLimit_Timer : REAL; (*Timer, LX2 in Limit [sec]*)
        bLX2_inLimit_NoDelay : BOOL; (*true, if LX2 control limit is reached*)
    END_STRUCT;

   tLX2_DBUG : STRUCT 
        Stm : tLX2_STM_DBUG; (*debugging state machine*)
        Ctr : tLX2_CTR_DBUG; (*debugging controller*)
        Gas1 : tLX2_GAS_DBUG; (*debugging BPOC Gas 1*)
        Gas2 : tLX2_GAS_DBUG; (*debugging BPOC Gas 2*)
        Gas3 : tLX2_GAS_DBUG; (*debugging BPOC Gas 3*)
        Gas4 : tLX2_GAS_DBUG; (*debugging BPOC Gas 4*)
        rLX2_BPOC_internal : ARRAY[0..10] OF REAL; (*LX2 BPOC - delta p2s at all node points - internal [bar]*)
        bLX2_BPOC_measured_internal : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - internal [true->measured]*)
        rBPOC_Lp_all : ARRAY[0..2] OF REAL; (*position of Leanox points (b,a,c) at BPOC_all [0...1]*)
    END_STRUCT;

   tLX2_GAS_DBUG : STRUCT 
        bBPOC_enable : BOOL; (*true, if BPOC is used to generate delta_p2s*)
        bBPOC_save_enable : BOOL; (*BPOC will be updated, [true->learning=on]*)
        bBPOC_measured_map_IN : ARRAY[0..10] OF BOOL; (*Input of BPOC manipulation algorithm, measered nodes [bool]*)
        rBPOC_offset_map_IN : ARRAY[0..10] OF REAL; (*Input of BPOC manipulation algorithm, p2s offsets [bar]*)
        rPr_BPOC_offset_IN : REAL; (*Input of BPOC manipulation algorithm, desired p2s_offsets [bar]*)
        bBPOC_measured_map_OUT : ARRAY[0..10] OF BOOL; (*Output of BPOC_Gas manipulation algorithm, measered nodes [bool]*)
        rBPOC_offset_map_OUT : ARRAY[0..10] OF REAL; (*Output of BPOC manipulation algorithm, p2s offsets [bar]*)
        rPr_BPOC_offset_OUT : REAL; (*Output, interpolated delta_p2s from BPOC [bar]*)
        rP_act_Norm_Filt : REAL; (*Power setpoint related to rP_Nom [0...1]*)
        rLX2_BPOC_Error : REAL; (*Error between BPOC and new p2s [bar]*)
        rLX2_Lp : ARRAY[0..2] OF REAL; (*position of Leanox Points (b,a,c) [%-EngPower]*)
        rBPOC_DBUG_a : ARRAY[0..1] OF REAL; (*weighting factors due to leverage function [0...1]*)
        rBPOC_DBUG_b : ARRAY[0..1] OF REAL; (*indices of affected node points due to new measurement value [1...11]*)
        rBPOC_DBUG_Lp : ARRAY[0..3] OF REAL; (*position of Leanox points (0kW,b,a,c) at BPOC [0...1]*)
        rBPOC_DBUG_s : ARRAY[0..2] OF REAL; (*calculated slope between two affected nodes due to leverage function; Gas [0...1]*)
    END_STRUCT;

   tLX2_IN : STRUCT 
        bLX2_active : BOOL; (*LX2 active*)
        rNOx_act : REAL; (*Actual NOx value [ppm]*)
        rNOx_set : REAL; (*NOx reference value [ppm]*)
        bNOx_valid : BOOL; (*NOx signal valid*)
        rP_Set_Norm : REAL; (*Power setpoint related to rP_Nom [0...1]*)
        rP_Lp_b : ARRAY[0..4] OF REAL; (*P at Leanox point b (half Load) - Gas 1/2/3/4 [kW]*)
        rP_Lp_a : ARRAY[0..4] OF REAL; (*P at Leanox point a (full Load) - Gas 1/2/3/4[kW]*)
        rP_Lp_c : ARRAY[0..4] OF REAL; (*P at Leanox point c (~25% Load) - Gas 1/2/3/4 [kW]*)
        bLp_c_ena : BOOL; (*Leanox point c enabled [true->enabled]*)
        rP_Nom : ARRAY[0..4] OF REAL; (*Engine Power Output Nominell - Gas 1/2/3/4 [kW]*)
        bESC_active : BOOL; (*ESC control active [true->ESC on]*)
        bBPOC_reset : BOOL; (*Reset BPOC [true->for one cycle]*)
        bLeanox_Engine_Man : BOOL; (*Leanox mode [true->manual]*)
        bLeanox_Adjust : BOOL; (*Leanox save - confirm button [true->for one cycle]*)
        rKnock_level : REAL; (*max. Knockintegrator value of all Zylinder [0...1]*)
        rMisfire_level : REAL; (*misfire integrator value - detection via power fluctuation [0...1]*)
        rGT_QualMix_1_2 : REAL; (*gas mixing ratio Gas1/Gas2 [0...1] (0=>100% Gas 1)*)
        rGT_RatioMix : REAL; (*gas mixing ratio Gas0/Gas3 [0...1] (0=>100% Gas 0)*)
        iIdx_Gtyp_Dem : UINT; (*Gastype [0...4] (0=Gasmixing, 1=Gas 1, 2=Gas 2, 3=Gas 3, 4=Gas 4)*)
        rLX2_BPOC_Gas1 : ARRAY[0..10] OF REAL; (*actual BPOC from Permanent Storage - Gas 1 [bar]*)
        bLX2_BPOC_measured_Gas1 : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - Gas 1 [true->measured]*)
        rLX2_BPOC_Gas2 : ARRAY[0..10] OF REAL; (*actual BPOC from Permanent Storage - Gas 1 [bar]*)
        bLX2_BPOC_measured_Gas2 : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - Gas 2 [true->measured]*)
        rLX2_BPOC_Gas3 : ARRAY[0..10] OF REAL; (*actual BPOC from Permanent Storage - Gas 2 [bar]*)
        bLX2_BPOC_measured_Gas3 : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - Gas 3 [true->measured]*)
        rLX2_BPOC_Gas4 : ARRAY[0..10] OF REAL; (*actual BPOC from Permanent Storage - Gas 3 [bar]*)
        bLX2_BPOC_measured_Gas4 : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - Gas 4 [true->measured]*)
        rPr_Leanox_Dev : REAL; (*Leanox controller deviation [mbar]*)
        bExt_SteadyState_Loss : BOOL; (*External interface signal for steady state loss [true->no steady state]*)
        bExt_BPOC_learning_Stop : BOOL; (*External interface signal for BPOC learning stop [true->no BPOC learning]*)
        bLX2_fastRamp : BOOL; (*Fast ramp request [true->fast ramp on]*)
        rLX2_fastRampMult : REAL; (*Fast ramp multiplier, applied to default rate limit if requested*)
    END_STRUCT;

   tLX2_OUT : STRUCT 
        rPr_LX2_offset : REAL; (*LX2 boost pressure offset - delta p2s_LX2 [bar]*)
        bLX2_save : ARRAY[0..4] OF BOOL; (*save LX2 data, Gas 1-4, [true->save]*)
        rPr_LX2_offset_Lp_b : ARRAY[0..4] OF REAL; (*LX2 - delta p2s at Leanox point b (half load), Gas 1-4, [bar]*)
        rPr_LX2_offset_Lp_a : ARRAY[0..4] OF REAL; (*LX2 - delta p2s at Leanox point a (full load), Gas 1-4,  [bar]*)
        rPr_LX2_offset_Lp_c : ARRAY[0..4] OF REAL; (*LX2 - delta p2s at Leanox point c (~25% load), Gas 1-4,  [bar]*)
        rLX2_BPOC_Gas1 : ARRAY[0..10] OF REAL; (*LX2 BPOC - delta p2s at all node points - Gas 1[bar]*)
        bLX2_BPOC_measured_Gas1 : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - Gas 1 [true->measured]*)
        rLX2_BPOC_Gas2 : ARRAY[0..10] OF REAL; (*LX2 BPOC - delta p2s at all node points - Gas 2 [bar]*)
        bLX2_BPOC_measured_Gas2 : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - Gas 2 [true->measured]*)
        rLX2_BPOC_Gas3 : ARRAY[0..10] OF REAL; (*LX2 BPOC - delta p2s at all node points - Gas 3 [bar]*)
        bLX2_BPOC_measured_Gas3 : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - Gas 3 [true->measured]*)
        rLX2_BPOC_Gas4 : ARRAY[0..10] OF REAL; (*LX2 BPOC - delta p2s at all node points - Gas 4 [bar]*)
        bLX2_BPOC_measured_Gas4 : ARRAY[0..10] OF BOOL; (*LX2 BPOC - binary map of already measured points - Gas 4 [true->measured]*)
        rLX2_BPOC : ARRAY[0..10] OF REAL; (*LX2 BPOC,act (all Gases combined) - delta p2s at all node points [bar]*)
        bLX2_BPOC_measured : ARRAY[0..10] OF BOOL; (*LX2 BPOC,measured (all Gases combined) - binary map of already measured points [true->measured]*)
        bBPOC_enable : BOOL; (*FOR VISU: true, if one out of 4 BPOCs is used to generate delta_p2s, Gas 1-4, [0/1]*)
        bBPOC_save_enable : BOOL; (*FOR VISU: if true; one out of 4 BPOCs will be updated, [true->learning=on], Gas 1-4, [0/1]*)
        bLX2_inLimit : BOOL; (*FOR Warning: if true; LX2 is in Limit and Warning shall appear[true->in Limit], [0/1]*)
    END_STRUCT;

   tLX2_PARA : STRUCT 
        bLX2_enable : BOOL; (*enable LX2*)
        rLX2_Ctrl_Tn : REAL; (*Ctrl Integrator time constant [sec]*)
        rFilterConst_NOx : REAL; (*Filter coefficient PT1 - NOx act [sec]*)
        rPr_LX2_OffsetLimit : REAL; (*LX2 charge pressure offset limit [mbar]*)
        rLX2_SteadyStateFactor : REAL; (*Steady state factor for LX2*)
    END_STRUCT;

   tLX2_PERM : STRUCT 
        iWeight_Lp_0kW : UINT; (*weighting of Leanox point 0kW [0..65535]*)
        iWeight_Lp_b : UINT; (*weighting of Leanox point b (half load), UserDefine [0..65535]*)
        iWeight_Lp_a : UINT; (*weighting of Leanox point a (full load) [0..65535]*)
        iWeight_Lp_c : UINT; (*weighting of Leanox point c (~25% load) [0..65535]*)
        rThreshold_knock : REAL; (*Knocking Threshold - LX2 knows about knocking [0...1]*)
        rThreshold_misfire : REAL; (*Misfire Threshold - LX2 knows about misfire [0...1]*)
        iCtrl_RateLimit_TraceBack : UINT; (*Rate limit for tracing Controler back to zero; mbar/sec [0..65535]*)
        iFilterConst_P_set : UINT; (*Filter coefficient PT1 - P_set [sec]*)
        rThreshold_save2map : ARRAY[0..1] OF REAL; (*Threshold at which amount of gas the map will be updated [0...1]*)
        rLX2_inLimitSetup_Time : REAL; (*tolerated rTime_inSaturation [0...x sec]*)
        iTiUpdate_BPOC : UINT; (*Update Time of BPOC [sec]*)
        iTiDelay_SteadyState : UINT; (*Delay timer for LX2 steady state [sec]*)
        iFiltConst_LeanoxDev_SteadyState : UINT; (*Filter coefficient PT1 - Leanox deviation for LX2 steady state [sec]*)
        iFiltConst_P_set_SteadyState : UINT; (*Filter coefficient PT1 - norm. power setpoint for LX2 steady state [sec]*)
        rThreshold_LeanoxDev_SteadyState : REAL; (*Threshold leanox deviation for LX2 steady state [mbar]*)
        rThreshold_P_set_SteadyState : REAL; (*Threshold norm. power setpoint steady for LX2 steady state [0...1]*)
        rCtrlError_Limit : REAL; (*Saturation limit for error between NOx_set and NOx_act_filt [ppm]*)
    END_STRUCT;

   tLX2_STM_DBUG : STRUCT 
        rP_act_Norm_Filt : REAL; (*Power setpoint filtered related to rP_Nom [0...100]*)
        bBPOC_enable : ARRAY[0..3] OF BOOL; (*true, if BPOC is used to generate delta_p2s, Gas 1-4, [0/1]*)
        bBPOC_save_enable : ARRAY[0..3] OF BOOL; (*if true; BPOC will be updated, [true->learning=on], Gas 1-4, [0/1]*)
        rSplitfactor_Gas : ARRAY[0..3] OF REAL; (*indicates how much of each gas is taking part on combustion, Gas 1-4 [0...1]*)
        bCtrl_enable : BOOL; (*true, if Controler is enabled*)
        bCtrl_freeze : BOOL; (*true, if Controler is frozen*)
        bEng_knock : BOOL; (*true, if engine is knocking due to LX2 rules*)
        bEng_misfire : BOOL; (*true, if engine is misfiring due to LX2 rules*)
        bBPOC_reset : BOOL; (*if true; BPOC will be reset, [0/1]*)
        iTimer_save : UINT; (*Timer of Save Logic [sec]*)
        bLX2_SteadyState : BOOL; (*true, if engine in steady state operation as per LX2 definition*)
        bLX2_SteadyState_noDelay : BOOL; (*true, if engine in steady state operation as per LX2 definition without delay timer*)
        bLX2_LeanoxDev_Steady : BOOL; (*true, if leanox deviation within limit as per LX2 steady state definition*)
        bLX2_P_Set_Steady : BOOL; (*true, if power setpoint steady as per LX2 steady state definition*)
    END_STRUCT;
END_TYPE
TYPE
rtB_BoostPressureOffsetCurve_LX : STRUCT
	OUT_offset : ARRAY[0..10] OF REAL;
	e : REAL;
	DBUG_a : ARRAY[0..1] OF REAL;
	DBUG_b : ARRAY[0..1] OF REAL;
	DBUG_Lp : ARRAY[0..3] OF REAL;
	DBUG_s : ARRAY[0..2] OF REAL;
	OUT_measured : ARRAY[0..10] OF BOOL;
END_STRUCT;
rtB_TON_LX2 : STRUCT
	DiscreteTimeIntegrator : REAL;
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON_LX2 : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_Filter1_LX2 : STRUCT
	Switch : REAL;
END_STRUCT;
rtDW_Filter1_LX2 : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
BlockIO_LX2 : STRUCT
	BusInput : tLX2_IN;
	BusInput1 : tLX2_PERM;
	BusInput2 : tLX2_PARA;
	UnitDelay : UDINT;
	TON_p : rtB_TON_LX2;
	Filter1 : rtB_Filter1_LX2;
	Filter : rtB_Filter1_LX2;
	Filter1_i : rtB_Filter1_LX2;
	TON_b : rtB_TON_LX2;
	sf_BoostPressureOffsetCurve_a : rtB_BoostPressureOffsetCurve_LX;
	sf_BoostPressureOffsetCurve_d : rtB_BoostPressureOffsetCurve_LX;
	sf_BoostPressureOffsetCurve_f : rtB_BoostPressureOffsetCurve_LX;
	sf_BoostPressureOffsetCurve : rtB_BoostPressureOffsetCurve_LX;
END_STRUCT;
D_Work_LX2 : STRUCT
	UnitDelay3_DSTATE : REAL;
	Delay2_DSTATE : ARRAY[0..10] OF REAL;
	UnitDelay2_DSTATE : REAL;
	Delay2_DSTATE_j : ARRAY[0..10] OF REAL;
	Delay2_DSTATE_b : ARRAY[0..10] OF REAL;
	Delay2_DSTATE_d : ARRAY[0..10] OF REAL;
	UnitDelay5_DSTATE : REAL;
	UnitDelay6_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE : REAL;
	UnitDelay4_DSTATE : REAL;
	Delay_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE_n : REAL;
	UnitDelay_DSTATE : UDINT;
	y0_1 : REAL;
	DiscreteTimeIntegrator_DSTATE_l : UINT;
	UnitDelay1_DSTATE : BOOL;
	UnitDelay1_DSTATE_l : BOOL;
	UnitDelay_DSTATE_l : BOOL;
	Delay1_DSTATE : ARRAY[0..10] OF BOOL;
	Delay1_DSTATE_l : ARRAY[0..10] OF BOOL;
	Delay1_DSTATE_o : ARRAY[0..10] OF BOOL;
	Delay1_DSTATE_g : ARRAY[0..10] OF BOOL;
	DelayInput1_DSTATE : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_m : SINT;
	DiscreteTimeIntegrator_PrevRe_a : SINT;
	icLoad : USINT;
	icLoad_o : USINT;
	icLoad_or : USINT;
	icLoad_oj : USINT;
	icLoad_p : USINT;
	icLoad_d : USINT;
	icLoad_f : USINT;
	icLoad_c : USINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	icLoad_i : USINT;
	DiscreteTimeIntegrator_IC_LOA_l : USINT;
	TON_p : rtDW_TON_LX2;
	Filter1 : rtDW_Filter1_LX2;
	Filter : rtDW_Filter1_LX2;
	Filter1_i : rtDW_Filter1_LX2;
	TON_b : rtDW_TON_LX2;
END_STRUCT;
PrevZCSigStates_LX2 : STRUCT
	Delay2_Reset_ZCE : USINT;
	Delay1_Reset_ZCE : USINT;
	Delay2_Reset_ZCE_o : USINT;
	Delay1_Reset_ZCE_n : USINT;
	Delay2_Reset_ZCE_or : USINT;
	Delay1_Reset_ZCE_e : USINT;
	Delay2_Reset_ZCE_k : USINT;
	Delay1_Reset_ZCE_k : USINT;
	Delay_Reset_ZCE : USINT;
END_STRUCT;
ConstParam_LX2 : STRUCT
	pooled14 : ARRAY[0..10] OF REAL;
END_STRUCT;
ExternalInputs_LX2 : STRUCT
	tLX2_IN_e : tLX2_IN;
	tLX2_PERM_m : tLX2_PERM;
	tLX2_PARA_c : tLX2_PARA;
END_STRUCT;
ExternalOutputs_LX2 : STRUCT
	tLX2_OUT_c : tLX2_OUT;
	tLX2_DBUG_j : tLX2_DBUG;
END_STRUCT;
tag_RTM_LX2 : STRUCT
	errorStatus : REFERENCE TO USINT;
END_STRUCT;
END_TYPE