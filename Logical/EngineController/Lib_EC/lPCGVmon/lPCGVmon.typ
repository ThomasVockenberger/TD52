

TYPE
	tPCGVmon_DBG :  STRUCT   
		bPCGVstick :  ARRAY[0..24] OF BOOL; (*PCGVstickingevent(-)*)  
		rTexh_median_diff_grad :  ARRAY[0..24] OF REAL; (**)  
		rStdDev :  REAL; (**)  
		detectionLim :  REAL; (**)  
		rTexh_median_filt :  REAL; (**)  
		rU_Ign_Act_Filt :  ARRAY[0..24] OF REAL; (**)  
		rTexhMedDeviat :  ARRAY[0..24] OF REAL; (**)  
		count1_stick :  ARRAY[0..24] OF REAL; (**)  
		count2_stickLong :  ARRAY[0..24] OF REAL; (**)  
		unstickDet :  ARRAY[0..24] OF REAL; (**)  
		multStickDur :  ARRAY[0..24] OF REAL; (**)  
		tiStickDurAll :  ARRAY[0..24] OF REAL; (**)  
		bPCGVstickALL :  ARRAY[0..24] OF BOOL; (*PCGVstickingevent(-)*)  
		bTexhInRange_out :  ARRAY[0..24] OF BOOL; (*EGTwithinlimit/range(-)*)  
	END_STRUCT;

	tPCGVmon_IN :  STRUCT   
		rU_Ign_Act :  ARRAY[0..24] OF REAL; (*Actualcylinderignitionvoltage(kV)*)  
		MSAGT :  ARRAY[0..24] OF BOOL; (*Cylinderexhaustgastemperaturesensorfailure(-)*)  
		rT_EPU_EG :  ARRAY[0..24] OF REAL; (*Cylinderexhaustgastemperature(°C)*)  
		tGCB_On_Di :  BOOL; (*Generatorcircuitbreakerclosed(-)*)  
		ucNumCyl :  USINT; (*Totalnumberofcylinders(-)*)  
		iCnt_PCGV_class1_MM2VIS :  ARRAY[0..24] OF UINT; (*Permclass1counter(MM2VIS)*)  
		iCnt_PCGV_class2_MM2VIS :  ARRAY[0..24] OF UINT; (*Permclass2counter(MM2VIS)*)  
		iCnt_PCGV_class3_MM2VIS :  ARRAY[0..24] OF UINT; (*Permclass3counter(MM2VIS)*)  
		iCnt_PCGV_class4_MM2VIS :  ARRAY[0..24] OF UINT; (*Permclass4counter(MM2VIS)*)  
	END_STRUCT;

	tPCGVmon_OUT :  STRUCT   
		iCnt_PCGV_class1 :  ARRAY[0..24] OF UINT; (*Class1counter:stickingduration1-10s*)  
		iCnt_PCGV_class2 :  ARRAY[0..24] OF UINT; (*Class2counter:stickingduration10-60s*)  
		iCnt_PCGV_class3 :  ARRAY[0..24] OF UINT; (*Class3counter:stickingduration60-300s*)  
		iCnt_PCGV_class4 :  ARRAY[0..24] OF UINT; (*Class3counter:stickingduration300-3600s*)  
		rTi_PCGV_LastStickDur :  REAL; (*Laststickingduration(s)*)  
		rTi_PCGV_MeanLastStickEvts :  REAL; (*Stickingdurationoflaststickingevents(s)*)  
	END_STRUCT;

	tPCGVmon_PERM :  STRUCT   
		bPCGVmon_Act :  BOOL; (*ActivationofPCGVmonitoringandclasscoutnerreset(-)*)  
		rU_Ign_DetLim :  REAL; (*MaximumignitionvoltagedroptostillconsiderEGTtemperaturedropasPCGVsticking(kV)*)  
		rU_Ign_CylActThresh :  REAL; (*CylinderEGTbelowthisparametertimesignitionvoltagemedianexcludedfrommonitoring(-)*)  
		rT_recoverLim :  REAL; (*CylinderEGTrecoverthreshold(°C)*)  
		rTi_Uign_MonActDelay :  REAL; (*Activationdelayforignitionvoltageconsiderationinmonitoringfunction(s)*)  
		rTmedian_StartThresh :  REAL; (*EGT(median)tobereachedforactivationofignitionvoltageconsideration(°C)*)  
		rTi_GCBon_Delay :  REAL; (*ActivationdelayafterGCBclosed(s)*)  
		rTi_EGT_ss_ActDelay :  REAL; (*ActivationdelayafterEGTissteadystate(s)*)  
		rOffset_EGTgradient_trans :  REAL; (*EGTgradientdetectionlimitoffsetfortransients(-)*)  
		rOffset_EGTgradient_ss :  REAL; (*EGTgradientdetectionlimitoffsetforsteadystate(-)*)  
		rGradient_LimSwitch :  REAL; (*Switchdetectionlimit(-)*)  
		iCnt_PCGV_class1 :  ARRAY[0..24] OF UINT; (*Permclass1counter:stickingduration1-10s*)  
		iCnt_PCGV_class2 :  ARRAY[0..24] OF UINT; (*Permclass2counter:stickingduration10-60s*)  
		iCnt_PCGV_class3 :  ARRAY[0..24] OF UINT; (*Permclass3counter:stickingduration60-300s*)  
		iCnt_PCGV_class4 :  ARRAY[0..24] OF UINT; (*Permclass4counter:stickingduration300-3600s*)  
		iTi_PCGV_class1_border :  UINT; (*Permclass1border*)  
		iTi_PCGV_class2_border :  UINT; (*Permclass2border*)  
		iTi_PCGV_class3_border :  UINT; (*Permclass3border*)  
		iTi_PCGV_class4_border :  UINT; (*Permclass4border*)  
	END_STRUCT;

END_TYPE

TYPE
rtB_setZero_PCGVmon : STRUCT
	y : ARRAY[0..24] OF REAL;
END_STRUCT;
rtB_TON_PCGVmon : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON_PCGVmon : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_MATLABFunction_PCGVmon : STRUCT
	y : REAL;
END_STRUCT;
BlockIO_PCGVmon : STRUCT
	BusConversion_InsertedFor_BusOu : tPCGVmon_DBG;
	BusInput : tPCGVmon_IN;
	BusInput1 : tPCGVmon_PERM;
	BusConversion_InsertedFor_Bus_d : tPCGVmon_OUT;
	UnitDelay : UDINT;
	sf_MATLABFunction9 : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction8 : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction7 : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction6 : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction5 : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction4 : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction3_o : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction2_o : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction10 : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction1_p : rtB_MATLABFunction_PCGVmon;
	sf_MATLABFunction : rtB_MATLABFunction_PCGVmon;
	sf_setZero_m : rtB_setZero_PCGVmon;
	TON2 : rtB_TON_PCGVmon;
	TON1 : rtB_TON_PCGVmon;
	TON : rtB_TON_PCGVmon;
	sf_setZero1 : rtB_setZero_PCGVmon;
	sf_setZero : rtB_setZero_PCGVmon;
END_STRUCT;
D_Work_PCGVmon : STRUCT
	Delay_DSTATE : ARRAY[0..74] OF REAL;
	Delay1_DSTATE : ARRAY[0..24] OF REAL;
	UnitDelay2_DSTATE : ARRAY[0..24] OF REAL;
	DelayInput1_DSTATE : REAL;
	UnitDelay13_DSTATE : REAL;
	UnitDelay3_DSTATE : REAL;
	UnitDelay4_DSTATE : REAL;
	UnitDelay5_DSTATE : REAL;
	UnitDelay6_DSTATE : REAL;
	UnitDelay7_DSTATE : REAL;
	UnitDelay8_DSTATE : REAL;
	UnitDelay9_DSTATE : REAL;
	UnitDelay10_DSTATE : REAL;
	UnitDelay11_DSTATE : REAL;
	UnitDelay12_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE_d : ARRAY[0..24] OF REAL;
	DiscreteTimeIntegrator_DSTATE_b : REAL;
	DiscreteTimeIntegrator_DSTATE_m : ARRAY[0..24] OF REAL;
	UnitDelay_DSTATE : UDINT;
	PrevY : REAL;
	PrevY_a : REAL;
	Cnt1OldDely : ARRAY[0..24] OF REAL;
	Cnt2Old : ARRAY[0..24] OF REAL;
	lastStickDurTmp : ARRAY[0..24] OF REAL;
	count1 : ARRAY[0..24] OF REAL;
	count2 : ARRAY[0..24] OF REAL;
	tiStickDur : ARRAY[0..24] OF REAL;
	tiMultStick : ARRAY[0..24] OF REAL;
	tiStickDurAll : ARRAY[0..24] OF REAL;
	count1Old : ARRAY[0..24] OF REAL;
	iCnt_class1 : ARRAY[0..24] OF UINT;
	iCnt_class2 : ARRAY[0..24] OF UINT;
	iCnt_class3 : ARRAY[0..24] OF UINT;
	iCnt_class4 : ARRAY[0..24] OF UINT;
	iCnt_class1Old : ARRAY[0..24] OF UINT;
	iCnt_class2Old : ARRAY[0..24] OF UINT;
	iCnt_class3Old : ARRAY[0..24] OF UINT;
	iCnt_class4Old : ARRAY[0..24] OF UINT;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_a : SINT;
	DiscreteTimeIntegrator_PrevRe_p : SINT;
	DiscreteTimeIntegrator_PrevRe_l : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	DiscreteTimeIntegrator_IC_LOA_b : USINT;
	DiscreteTimeIntegrator_IC_LOA_l : USINT;
	DiscreteTimeIntegrator_IC_LOA_o : USINT;
	Relay1_Mode : ARRAY[0..24] OF BOOL;
	bPCGVstickTexhGradOld : ARRAY[0..24] OF BOOL;
	bPCGVstick_temp : ARRAY[0..24] OF BOOL;
	bPCGVstickOld : ARRAY[0..24] OF BOOL;
	switch1 : ARRAY[0..24] OF BOOL;
	switch2 : ARRAY[0..24] OF BOOL;
	switch3 : ARRAY[0..24] OF BOOL;
	bTexhInRangeOld : ARRAY[0..24] OF BOOL;
	bTexhInRange : ARRAY[0..24] OF BOOL;
	GCBold : BOOL;
	TON2 : rtDW_TON_PCGVmon;
	TON1 : rtDW_TON_PCGVmon;
	TON : rtDW_TON_PCGVmon;
END_STRUCT;
ExternalInputs_PCGVmon : STRUCT
	In : tPCGVmon_IN;
	Perm : tPCGVmon_PERM;
END_STRUCT;
ExternalOutputs_PCGVmon : STRUCT
	Out : tPCGVmon_OUT;
	Dbg : tPCGVmon_DBG;
END_STRUCT;
tag_RTM_PCGVmon : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_PCGVmon;
	inputs : REFERENCE TO ExternalInputs_PCGVmon;
	outputs : REFERENCE TO ExternalOutputs_PCGVmon;
	dwork : REFERENCE TO D_Work_PCGVmon;
END_STRUCT;
emxArray_int32_T_25_PCGVmon : emxArray_int32_T_25;
RT_MODEL_PCGVmon : tag_RTM_PCGVmon;
END_TYPE
TYPE
emxArray_int32_T_25 : STRUCT
	data : ARRAY[0..24] OF DINT;
	size : DINT;
END_STRUCT;
END_TYPE