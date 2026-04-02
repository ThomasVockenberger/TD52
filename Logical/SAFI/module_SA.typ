
TYPE
	tVIS2MM : 	STRUCT 
		bPI_SelfTest : BOOL; (* Switch port injection to selftest *) (* OldName:bSAFIPITest; Cycle: *)
		bCanUpDevSel : ARRAY[0..12]OF BOOL; (* CAN updater device selection *) (* OldName:new PV; Cycle: *)
		bCanUpStart : BOOL; (* CAN updater start/stop button *) (* OldName:new PV; Cycle: *)
		iCanUpFwVersSel : INT; (* CAN updater firmware version selection *) (* OldName:new PV; Cycle: *)
		bSAFI_SL_Check : BOOL; (* SAFI safty loop testing button *) (* OldName:bSAFI_SL_Check; Cycle: *)
		bSAFI_ValveLashSet : ARRAY[0..24]OF BOOL; (*Valve lash adjusted*)
		bSAFI_ValveLashSetAll : BOOL; (*Valve lash adjusted all*)
		bCanUpDevSelAll : BOOL; (*Update all button*)
	END_STRUCT;
	tMM2VIS : 	STRUCT 
		iCnt_SA_ComErr : ARRAY[0..12]OF DINT; (* SAFI communication error counter *) (* OldName:usSAFIComErrCnt; Cycle:  *)
		iTi_PI_DurationAvg : INT; (* port injection duration average *) (* OldName:usDurationAvg; Cycle: *)
		iTi_PI_DurationMax : INT; (* port injection duration maximum *) (* OldName:usDurationMax; Cycle: *)
		iTi_PI_DurationMin : INT; (* port injection duration minimum *) (* OldName:usDurationMin; Cycle: *)
		tSA_HW_Vers : ARRAY[0..12]OF _tSAFIHardwareINT; (* SAFI hardware version *) (* OldName:usSAFIHW; Cycle: *)
		rSA_SW_Vers : ARRAY[0..12]OF REAL; (* SAFI software version *) (* OldName:usSAFIVers; Cycle: *)
		rTi_SA_OpHours : ARRAY[0..12]OF REAL; (* SAFI operating hours *) (* OldName:ulSAFArbH; Cycle: *)
		iSA_SerialNr : ARRAY[0..12]OF DINT; (* SAFI serial number *) (* OldName:ulSAFSerNr; Cycle: *)
		tSA_ProdDate : ARRAY[0..12]OF _tSAFIProdDateINT; (* SAFI production date *) (* OldName:ulProdDate; Cycle: *)
		rT_SA_ElecTemp : ARRAY[0..12]OF REAL; (* SAFI electronic temperature *) (* OldName:ssSAFITemp; Cycle: *)
		iSA_ErrToothNr : ARRAY[0..12]OF INT; (* SAFI Error tooth number *) (* OldName:usErrZahnz; Cycle: *)
		rSA_FiltVers : ARRAY[0..12]OF REAL; (* SAFI KLS filter version *) (* OldName:usSAFFiltV; Cycle: *)
		bMsg3337 : BOOL; (* Message number 3337 *) (* OldName:bACamSign; Cycle: *)
		bMsg3335 : BOOL; (* Message number 3335 *) (* OldName:bAOverspeedErr; Cycle: *)
		bMsg3333 : BOOL; (* Message number 3333 *) (* OldName:bAParameter; Cycle: *)
		bMsg2256 : BOOL; (* Message number 2256 *) (* OldName:bAPICloseErr; Cycle: *)
		bMsg2253 : BOOL; (* Message number 2253 (prepared V4.05.00*) (* OldName:Port injetion duration error; Cycle: *)
		bMsg2254 : BOOL; (* Message number 2254 *) (* OldName:bAPIHardwareErr; Cycle: *)
		bMsg2255 : BOOL; (* Message number 2255 *) (* OldName:bAPIOpenErr; Cycle: *)
		bMsg2281 : BOOL; (* Message number 2281 *) (* OldName:bAPBCMemBurst; Cycle: *)
		bMsg3331 : BOOL; (* Message number 3331 *) (* OldName:bASAFIComErr; Cycle: *)
		bMsg3336 : BOOL; (* Message number 3336 *) (* OldName:bATriggerSign; Cycle: *)
		bMsg3330 : BOOL; (* Message number 3330 *) (* OldName:bASAFIHwErr; Cycle: *)
		bMsg3332 : BOOL; (* Message number 3332 *) (* OldName:bASAFIWrongVers; Cycle: *)
		bMsg3334 : BOOL; (* Message number 3334 *) (* OldName:bAIPDeviation; Cycle: *)
		bMsg3338 : BOOL; (* Message number 3338 *) (* OldName:bAOutputErr; Cycle: *)
		bMsg3343 : BOOL; (* Message number 3343 *) (* OldName:bAMORISErr; Cycle: *)
		bMsg3344 : BOOL; (* Message number 3344 *) (* OldName:bIgnPowerFail; Cycle: *)
		bMsg3345 : BOOL; (* Message number 3345 *) (* OldName:bSAFISafetyLoop; Cycle: *)
		bMsg3277 : BOOL; (* Message number 3277 *) (* OldName:bBCamSign; Cycle: *)
		bMsg3292 : BOOL; (* Message number 3292 *) (* OldName:bBCanErrRate; Cycle: *)
		bMsg3291 : BOOL; (* Message number 3291 *) (* OldName:bBConfigErr; Cycle: *)
		bMsg3293 : BOOL; (* Message number 3293 *) (* OldName:bBElectrTemp; Cycle: *)
		bMsg3294 : BOOL; (* Message number 3294 *) (* OldName:bBIgnPwrLim; Cycle: *)
		bMsg2824 : BOOL; (* not used at the moment!? *) (* OldName:bBIGNShutOff; Cycle: *)
		bMsg3288 : BOOL; (* Message number 3288 *) (* OldName:bBIgnVoltMax; Cycle: *)
		bMsg3287 : BOOL; (* Message number 3287 *) (* OldName:bBIgnVoltMin; Cycle: *)
		bMsg3286 : BOOL; (* Message number 3286 *) (* OldName:bBOffsetErr; Cycle: *)
		bMsg3278 : BOOL; (* Message number 3278 *) (* OldName:bBOutputErr; Cycle: *)
		bMsg3275 : BOOL; (* Message number 3275 *) (* OldName:bBOverspeedErr; Cycle: *)
		bMsg3273 : BOOL; (* Message number 3273 *) (* OldName:bBParameter; Cycle: *)
		bMsg2820 : BOOL; (* not used at the moment!? *) (* OldName:bBPICloseErr; Cycle: *)
		bMsg2818 : BOOL; (* not used at the moment!? *) (* OldName:bBPIHardwareErr; Cycle: *)
		bMsg2819 : BOOL; (* not used at the moment!? *) (* OldName:bBPIOpenErr; Cycle: *)
		bMsg2823 : BOOL; (* not used at the moment!? *) (* OldName:bBPIShutOff; Cycle: *)
		bMsg3271 : BOOL; (* Message number 3271 cylinder info value *) (* OldName:bBSAFIComErr; Cycle: *)
		bMsg3276 : BOOL; (* Message number 3276 cylinder info value *) (* OldName:bBTriggerSign; Cycle: *)
		bMsg3270 : BOOL; (* Message number 3270 cylinder info value *) (* OldName:bBSAFIHwErr; Cycle: *)
		bMsg3283 : BOOL; (* Message number 3283 cylinder info value *) (* OldName:bBMORISErr; Cycle: *)
		bMsg3284 : BOOL; (* Message number 3284 cylinder info value *) (* OldName:bBSAFIFwErr; Cycle: *)
		bMsg3272 : BOOL; (* Message number 3272 cylinder info value *) (* OldName:bBSAFIWrongVers; Cycle: *)
		bMsg3274 : BOOL; (* Message number 3274 cylinder info value *) (* OldName:bBIPDeviation; Cycle: *)
		bMsg2816 : BOOL; (* Message number 2816 cylinder info value *) (* OldName:bPIOpen; Cycle: *)
		bMsg2817 : BOOL; (* Message number 2817 cylinder info value *) (* OldName:bPIOpen; Cycle: *)
		bMsg3536 : BOOL; (* Message number 3536 cylinder info value *) (* OldName:bWCamSign; Cycle: *)
		bMsg3531 : BOOL; (* Message number 3531 cylinder info value *) (* OldName:bWCanErrRate; Cycle: *)
		bMsg3535 : BOOL; (* Message number 3535 cylinder info value *) (* OldName:bWConfigErr; Cycle: *)
		bMsg3539 : BOOL; (* Message number 3539 cylinder info value *) (* OldName:bWElectrTemp; Cycle: *)
		bMsg3551 : BOOL; (* Message number 3551 cylinder info value *) (* OldName:bWIgnPwrLim; Cycle: *)
		bMsg3549 : BOOL; (* Message number 3549 cylinder info value *) (* OldName:bWIgnVoltAvg; Cycle: *)
		bMsg3550 : BOOL; (* Message number 3550 cylinder info value *) (* OldName:bWIgnVoltDev; Cycle: *)
		bMsg3548 : BOOL; (* Message number 3548 cylinder info value *) (* OldName:bWIgnVoltMax; Cycle: *)
		bMsg3547 : BOOL; (* Message number 3547 cylinder info value *) (* OldName:bWIgnVoltMin; Cycle: *)
		bMsg3546 : BOOL; (* Message number 3546 cylinder info value *) (* OldName:bWOffsetErr; Cycle: *)
		bMsg3545 : BOOL; (* Message number 3545 cylinder info value *) (* OldName:bWOutputErr; Cycle: *)
		bMsg2585 : BOOL; (* Message number 2585 cylinder info value *) (* OldName:bWPIHardwareErr; Cycle: *)
		bMsg3530 : BOOL; (* Message number 3530 cylinder info value *) (* OldName:bWSAFIComErr; Cycle: *)
		bMsg3537 : BOOL; (* Message number 3537 cylinder info value *) (* OldName:bWTriggerSign; Cycle: *)
		bMsg3533 : BOOL; (* Message number 3533 cylinder info value *) (* OldName:bWSAFIFwErr; Cycle: *)
		bMsg3544 : BOOL; (* Message number 3544 cylinder info value *) (* OldName:bWMORISErr; Cycle: *)
		iMsg3277 : INT; (* Message number 3277 cylinder info value *) (* OldName:ucCamSign; Cycle: *)
		iMsg3275 : INT; (* Message number 3275 cylinder info value *) (* OldName:ucOverspeedErr; Cycle: *)
		iMsg3273 : INT; (* Message number 3273 cylinder info value *) (* OldName:ucParameter; Cycle: *)
		iMsg2820 : INT; (* Message number 2820 cylinder info value *) (* OldName:ucPICloseErr; Cycle: *)
		iMsg2819 : INT; (* Message number 2819 cylinder info value *) (* OldName:ucPIOpenErr; Cycle: *)
		iMsg3271 : INT; (* Message number 3271 cylinder info value *) (* OldName:ucSAFIComErr; Cycle: *)
		iMsg3276 : INT; (* Message number 3276 cylinder info value *) (* OldName:ucTriggerSign; Cycle: *)
		iMsg3270 : INT; (* Message number 3270 cylinder info value *) (* OldName:ucSAFIHwErr; Cycle: *)
		iMsg3272 : INT; (* Message number 3272 cylinder info value *) (* OldName:ucSAFIWrongVers; Cycle: *)
		iMsg3274 : INT; (* Message number 3274 cylinder info value *) (* OldName:ucIPDeviation; Cycle: *)
		iMsg3278 : INT; (* Message number 3278 cylinder info value *) (* OldName:ucOutputErr; Cycle: *)
		iMsg3283 : INT; (* Message number 3283 cylinder info value *) (* OldName:ucMORISErr; Cycle: *)
		iMsg3292 : INT; (* Message number 3292 cylinder info value *) (* OldName:ucCanErrRate; Cycle: *)
		iMsg3291 : INT; (* Message number 3291 cylinder info value *) (* OldName:ucConfigErr; Cycle: *)
		iMsg3293 : INT; (* Message number 3293 cylinder info value *) (* OldName:ucElectrTemp; Cycle: *)
		iMsg3294 : INT; (* Message number 3294 cylinder info value *) (* OldName:ucIgnPwrLim; Cycle: *)
		iMsg3288 : INT; (* Message number 3288 cylinder info value *) (* OldName:ucIgnVoltMax; Cycle: *)
		iMsg3287 : INT; (* Message number 3287 cylinder info value *) (* OldName:ucIgnVoltMin; Cycle: *)
		iMsg3286 : INT; (* Message number 3286 cylinder info value *) (* OldName:ucOffsetErr; Cycle: *)
		iMsg2818 : INT; (* Message number 2818 cylinder info value *) (* OldName:ucPIHardwareErr; Cycle: *)
		iMsg3284 : INT; (* Message number 3284 cylinder info value *) (* OldName:ucSAFIFwErr; Cycle: *)
		bMsg3532 : BOOL; (* not used at the moment!? *) (* OldName:SAFI wrong type of software; Cycle: *)
		bMsg3534 : BOOL; (* not used at the moment!? *) (* OldName:SAFI  parameter failure; Cycle: *)
		bMsg3538 : BOOL; (* not used at the moment!? *) (* OldName:SAFI hardware failure; Cycle: *)
		bMsg3543 : BOOL; (* not used at the moment!? *) (* OldName:Ignition point deviation too high; Cycle: *)
		bMsg3552 : BOOL; (* SAFI ignition power module overload *) (* OldName:Ignition power supply overload; Cycle: *)
		bMsg3553 : BOOL; (* Message number 3553 *) (* OldName:bWPBCConfNotOK; Cycle: *)
		bMsg3554 : BOOL; (* Message number 3554 *) (* OldName:bWPBCInvalidPar; Cycle: *)
		bMsg2214 : BOOL; (* Message number 2214 *) (* OldName:bAPBCSigErr; Cycle: *)
		bMsg2297 : BOOL; (* PI correct current control rate message *) (* OldName:new PV; Cycle: *)
		bMsg2800 : BOOL; (* PI correct current control warning message *) (* OldName:new PV; Cycle: *)
		bMsg2906 : BOOL; (* PI correct current control warning message *) (* OldName:new PV; Cycle: *)
		iMsg2906 : INT; (* PI correct current control warning message *) (* OldName:new PV; Cycle: *)
		bMsg2298 : BOOL; (* PI demagnetisation failure message *) (* OldName:new PV; Cycle: *)
		bMsg2907 : BOOL; (* PI demagnetisation failure message *) (* OldName:new PV; Cycle: *)
		iMsg2907 : INT; (* PI demagnetisation failure message *) (* OldName:new PV; Cycle: *)
		iSA_ERZuV : ARRAY[0..24]OF INT; (* Error Rate for spark delay  *) (* OldName:ucERZuV; Cycle: *)
		iSA_ERDurTol : ARRAY[0..24]OF INT; (* Error Rate for Duration Tolerance  *) (* OldName:ucERDurTol; Cycle: *)
		rCanUpProgress : REAL; (* CAN updater progress bar *) (* OldName:new PV; Cycle: *)
		rCanUpFwVers : ARRAY[0..5]OF REAL; (* CAN updater firmware versions *) (* OldName:new PV; Cycle: *)
		bSAFI2 : BOOL; (* CAN updater SAFI2 detected *) (* OldName:new PV; Cycle: *)
		iSA_PICurGrad : ARRAY[0..24]OF INT; (* port injection close current gradient *) (* OldName:new PV; Cycle: *)
		iSA_PICurGradAvg : INT; (* port injection close current gradient average *) (* OldName:new PV; Cycle: *)
		iSA_PICurGradMax : INT; (* port injection close current gradient maximum *) (* OldName:new PV; Cycle: *)
		iSA_PICurGradMin : INT; (* port injection close current gradient minimum *) (* OldName:new PV; Cycle: *)
		bMsg2299 : BOOL; (* alarm A2299 cylinder pressure saturation replaced with warning W9318 if RKS enabled *) (* OldName:new PV; Cycle: *)
		bMsg9318 : BOOL; (* W9318 Cylinder pressure sensor saturation *) (* OldName:new PV; Cycle: *)
		bMsg2898 : BOOL; (* Message number 2898 cylinder info value *) (* OldName:new PV; Cycle: *)
		iMsg2898 : INT; (* Message number 2818 cylinder info value *) (* OldName:new PV; Cycle: *)
		bMsg2910 : BOOL; (* Message number 2910 cylinder info value *) (* OldName:new PV; Cycle: *)
		iMsg2910 : INT; (* Message number 2910 MPM info value *) (* OldName:new PV; Cycle: *)
		iMsg3344 : INT; (* Message number 3344 MPM  info value *) (* OldName:new PV; Cycle: *)
		iCMSmain_SAFI_status : INT; (* SAFI Module Main CMS Status *)
		iCMSinit_SAFI_status : INT; (* SAFI Module CMS Init Status *)
		bMsg2476 : BOOL; (*Message number 2476 SPAx CAM deviation monitoring*)
		iU_SAFI_Win3 : ARRAY[0..24]OF UINT; (*Outlet valve closure noise*)
		iU_SAFI_Win3_Min : UINT; (*Outlet valve closure noise min*)
		iU_SAFI_Win3_Max : UINT; (*Outlet valve closure noise max*)
		iU_SAFI_Win3_Avg : UINT; (*Outlet valve closure noise average*)
		iU_SAFI_Win4 : ARRAY[0..24]OF UINT; (*Inlet valve closure noise*)
		iU_SAFI_Win4_Min : UINT; (*Inlet valve closure noise min*)
		iU_SAFI_Win4_Max : UINT; (*Inlet valve closure noise max*)
		iU_SAFI_Win4_Avg : UINT; (*Inlet valve closure noise average*)
		iCA_SAFI_Win3 : ARRAY[0..24]OF UINT; (*Outlet valve closure timing*)
		iCA_SAFI_Win3_Min : UINT; (*Outlet valve closure timing min*)
		iCA_SAFI_Win3_Max : UINT; (*Outlet valve closure timing max*)
		iCA_SAFI_Win3_Avg : UINT; (*Outlet valve closure timing average*)
		iCA_SAFI_Win4 : ARRAY[0..24]OF UINT; (*Inlet valve closure timing*)
		iCA_SAFI_Win4_Min : UINT; (*Inlet valve closure timing min*)
		iCA_SAFI_Win4_Max : UINT; (*Inlet valve closure timing max*)
		iCA_SAFI_Win4_Avg : UINT; (*Inlet valve closure timing average*)
		bMsg2334 : BOOL; (*Alarm 2334 Outlet valve closure noise high*)
		bMsg9027 : BOOL; (*Operating message 9027 Outlet valve closure noise high*)
		iMsg9027 : UINT; (*Operating message 9027 Outlet valve closure noise high - Cylinder info*)
		bMsg2335 : BOOL; (*Alarm 2335 Outlet valve closure noise high*)
		bMsg9028 : BOOL; (*Operating message 9028 Outlet valve closure noise high*)
		iMsg9028 : UINT; (*Operating message 9028 Outlet valve closure noise high - Cylinder info*)
		bSA_VCD_Active : BOOL; (*Enable visualization of VCD parameters for legacy versions*)
		bMsg9320 : BOOL; (*Warning 9320 Exhaust valve unbalance*)
		bMsg9045 : BOOL; (*Operating message 9045 Exhaust valve unbalance*)
		iMsg9045 : UINT; (*Operating message 9045 Exhaust valve unbalance - Cylinder info*)
		bMsg9321 : BOOL; (*Warning 9321 Intake valve unbalance*)
		bMsg9046 : BOOL; (*Operating message 9046 Intake valve unbalance*)
		iMsg9046 : UINT; (*Operating message 9046 Intake valve unbalance - Cylinder info*)
		bMsg2493 : BOOL; (*Warning 2493 - SAFI measurements frozen or alternating*)
		bMsg2939 : BOOL; (*Operating message 2939 - SAFI measurements frozen or alternating*)
		iMsg2939 : UINT; (*Operating message 2939 - SAFI measurements frozen or alternating - Cylinder info*)
		bP_Red_SAErr_Bar : BOOL; (*Bit to activate the SAFI power reduction bar in the HMI*)
		bMsg9066 : BOOL; (*Operating message 9066 Cylinder pressure sensor measuring signal failure*)
		iMsg9066 : UINT; (*Operating message 9066 Cylinder pressure sensor measuring signal failure - Cylinder info*)
		bMsg9350 : BOOL; (*W9350 - KLS21 ignition monitoring not available*)
		bMsg9050 : BOOL; (*B9050 - KLS21 ignition monitoring not available*)
		iMsg9050 : UINT; (*B9050 - KLS21 ignition monitoring not available - cylinder number*)
		iNum_SafiType : ARRAY[0..12]OF USINT; (*Type of device. Unknown: 0. SAFI1: 1. SAFI2 KLS: 2. SAFI2 DMR: 3. SAFI3: 4. KLS21: 5.*)
		iNum_SafiUpdBlock : USINT; (*Block the CAN update procedure*)
		bSAFI3 : BOOL; (*All installed devices are not SAFI1*)
	END_STRUCT;
	_tSAFISpeed : 	STRUCT 
		InCan : UINT;
		In : UINT;
		ValOK : UINT;
		Time : UDINT;
	END_STRUCT;
	_tSAFIProdDateINT : 	STRUCT 
		YYYY : INT;
		MM : INT;
		DD : INT;
	END_STRUCT;
	_tSAFIProdDate : 	STRUCT 
		YYYY : UINT;
		MM : USINT;
		DD : USINT;
	END_STRUCT;
	_tSAFICurrPmmREAL : 	STRUCT 
		Current : REAL;
		Time : REAL;
	END_STRUCT;
	_tSAFICurrPmm : 	STRUCT 
		Current : USINT;
		Time : UINT;
	END_STRUCT;
	_tSAFICurr : 	STRUCT 
		Current_Low : USINT;
		Current_High : USINT;
		Time_Low : UINT;
		Time_High : UINT;
	END_STRUCT;
	_SAFIError : 	STRUCT 
		Error : ARRAY[0..5]OF USINT;
	END_STRUCT;
	_tSAFImdatas : 	STRUCT 
		data1 : UINT;
		data2 : UINT;
		data3 : UINT;
	END_STRUCT;
	_tSAFImdatasExtend : 	STRUCT 
		data1 : UINT;
		data2 : UINT;
		data3 : UINT;
		data4 : USINT;
	END_STRUCT;
	_tSAFIHardwareINT : 	STRUCT 
		HW_OPTION : INT;
		HW_VERSION : INT;
	END_STRUCT;
	_tSAFIHardware : 	STRUCT 
		HW_OPTION : USINT;
		HW_VERSION : USINT;
	END_STRUCT;
	tE_SAFI : 	STRUCT 
		Error : ARRAY[0..1]OF USINT;
		pdata : ARRAY[0..41]OF USINT;
		runstop : ARRAY[0..2]OF USINT;
		smdata : ARRAY[0..9]OF USINT;
	END_STRUCT;
	_tEventSAFI : 	STRUCT 
		conf : ARRAY[0..35]OF USINT;
		zuend : ARRAY[0..1]OF USINT;
		error : USINT;
		sdata : ARRAY[0..4]OF USINT;
		idata : ARRAY[0..30]OF USINT;
		kdata : ARRAY[0..30]OF USINT;
		ddata : ARRAY[0..53]OF USINT;
		dmdata1 : ARRAY[0..5]OF USINT;
		kmdata : ARRAY[0..7]OF USINT;
		dmdata2 : ARRAY[0..15]OF USINT;
		smdata : ARRAY[0..9]OF USINT;
		status : ARRAY[0..11]OF USINT;
		bez : USINT;
		ref : USINT;
		cur : USINT;
		diag : ARRAY[0..18]OF USINT;
	END_STRUCT;
	tPIcurrentREAL : 	STRUCT 
		current : REAL;
		duration : REAL;
	END_STRUCT;
	tPIrecoveryREAL : 	STRUCT 
		delay : REAL;
		current : REAL;
		duration : REAL;
	END_STRUCT;
	tPIpulldet1REAL : 	STRUCT 
		level : REAL;
		st_time : REAL;
	END_STRUCT;
	tPIopdet1REAL : 	STRUCT 
		st_time : REAL;
		duration : REAL;
	END_STRUCT;
	tPIopdet2REAL : 	STRUCT 
		grad_ul : REAL;
		grad_ll : REAL;
		rate : REAL;
	END_STRUCT;
	tPIclosdet1REAL : 	STRUCT 
		set_current : REAL;
		set_duration : REAL;
	END_STRUCT;
	tPIclosdet2REAL : 	STRUCT 
		duration : REAL;
		grad_curr : REAL;
		grad_curr_var : REAL;
	END_STRUCT;
	tPIaverageREAL : 	STRUCT 
		average_MUX_6_7 : REAL;
		average_MUX_8_9 : REAL;
	END_STRUCT;
	CanDeviceGo : 	STRUCT 
		CANDevGo : ARRAY[0..1]OF USINT;
		ECANDevGo : USINT;
	END_STRUCT;
	_tMonicLimitREAL : 	STRUCT 
		limit : REAL;
		kind : REAL;
		delay : REAL;
	END_STRUCT;
	_tMonicLimit : 	STRUCT 
		limit : USINT;
		kind : USINT;
		delay : USINT;
	END_STRUCT;
	IN_SA_struct : 	STRUCT 
		iIdx_OMSS : INT; (* operationg mode selection switch *) (* OldName:BWS_HA; Cycle:5 *)
		iIdx_OMSS_TC2 : INT; (* operationg mode selection switch *) (* OldName:BWS_HA; Cycle:5 *)
		bEng_Dem_TC2 : BOOL; (* module demanded *) (* OldName:M_AGFD; Cycle:2 *)
		bEng_Dem : BOOL; (* module demanded *) (* OldName:M_AGFD; Cycle:5 *)
		iSt_OpMode : UDINT; (* engine operation mode *) (* OldName:StopM; Cycle:5 *)
		rCA_Ign_Act : ARRAY[0..24]OF REAL; (* actual cylinder ignition point *) (* OldName:ZZPCyl ; Cycle:2 *)
		bIgn_Dem_TC1 : BOOL; (* demand ignition *) (* OldName:ZUEND; Cycle:1 *)
		bIgn_Dem_TC2 : BOOL; (* demand ignition *) (* OldName:ZUEND; Cycle:2 *)
		bIgn_Dem : BOOL; (* demand ignition *) (* OldName:ZUEND; Cycle:5 *)
		bGV_On : BOOL; (* command open gas valves *) (* OldName:M_GASV; Cycle:2 *)
		tPIopenH : ARRAY[0..12]OF tPIopen; (* PI open point and open duration for high cylinder *) (* OldName:SAFI.tPI.tPIopenH; Cycle:2 *)
		tPIopenL : ARRAY[0..12]OF tPIopen; (* PI open point and open duration for low cylinder *) (* OldName:SAFI.tPI.tPIopenL; Cycle:2 *)
		bEng_Start_TC2 : BOOL; (*engine start*) (*OldName:M_STRT; Cycle:5*)
		bEng_Start : BOOL; (*engine start*) (*OldName:M_STRT; Cycle:5*)
		bIgn_SelfTest : BOOL; (* Switch ignition system to selftest  *) (* OldName:GoSelftest; Cycle:5 *)
		tAB2SA_TC2 : AmmBase2MM; (* AMM base to SAFI data transfer *) (* OldName:QUITT_WA; Cycle:2 *)
		tAB2SA : AmmBase2MM; (* AMM base to SAFI data transfer *) (* OldName:QUITT_WA; Cycle:5 *)
		iCANIdent : UDINT; (* CAN identifier from HalIO *) (* OldName:new PV; Cycle:7 *)
		iCANIdent_TC8 : UDINT; (* CAN identifier from HalIO *) (* OldName:new PV; Cycle:8 *)
		iCANIdentIGN2 : UDINT; (* CAN identifier of the 2nd CAN card from HalIO *) (* OldName:new PV; Cycle:8 *)
		iCANIdentIGN2_TC8 : UDINT; (* CAN identifier of the 2nd CAN card from HalIO *) (* OldName:new PV; Cycle:8 *)
		iMisfCyl : UDINT; (* cylinder misfire parameter *) (* OldName:MissfCyl; Cycle:2 *)
		iMisfCyl_TC2 : UDINT; (* cylinder misfire parameter *) (* OldName:MissfCyl; Cycle:2 *)
		tPB2MM : ParaBase2MM_type; (* Data exchange structure to ParaBase *) (* OldName:new PV; Cycle:5 *)
		tMO_PwrReply_TC5 : HALioDi_Type; (* DI: MORIS Ignition Power Module On *) (* OldName:DI_IgnPwrReply; Cycle:2 *)
		tMO_PwrReply : HALioDi_Type; (* DI: MORIS Ignition Power Module On *) (* OldName:DI_IgnPwrReply; Cycle:5 *)
		tMO_PwrReply2 : HALioDi_Type; (* DI: MORIS Ignition Power Module On *) (* OldName:new PV; Cycle:5 *)
		tMO_PwrReply3 : HALioDi_Type; (* DI: MORIS Ignition Power Module On *) (* OldName:new PV; Cycle:5 *)
		tMO_PwrReply4 : HALioDi_Type; (* DI: MORIS Ignition Power Module On *) (* OldName:new PV; Cycle:5 *)
		tMO_SaftyLoop_TC2 : HALioDi_Type; (* DI: MORIS Savety loop closed *) (* OldName:DI_MO_SL_OK; Cycle:2 *)
		tMO_SaftyLoop : HALioDi_Type; (* DI: MORIS Savety loop closed *) (* OldName:DI_MO_SL_OK; Cycle:5 *)
		tSafetyLoop_Eng_TC2 : HALioDi_Type; (* DI: Safety Loop closed *) (* OldName:RUHE; Cycle:2 *)
		tSafetyLoop_Eng : HALioDi_Type; (* DI: Safety Loop closed *) (* OldName:RUHE; Cycle:5 *)
		tMO_PowerOverload : HALioDi_Type; (* DI: SAFI ignition power module overload *) (* OldName:DI_IgnPowerOverload; Cycle:5 *)
		tMO_PowerOverload2 : HALioDi_Type; (* DI: SAFI ignition power module overload *) (* OldName:new PV; Cycle:5 *)
		tMO_PowerOverload3 : HALioDi_Type; (* DI: SAFI ignition power module overload *) (* OldName:new PV; Cycle:5 *)
		tMO_PowerOverload4 : HALioDi_Type; (* DI: SAFI ignition power module overload *) (* OldName:new PV; Cycle:5 *)
		tSafetyLoop_EmStop : HALioDi_Type; (* DI safety loop - emergency stop *) (* OldName:DI_SIS; Cycle:5 *)
		tGCB_On : HALioDi_Type; (*DI: generator circuit breaker closed *) (*OldName:GCB_ON; Cycle:2;*)
		tGCB_On_TC5 : HALioDi_Type; (*DI: generator circuit breaker closed *) (*OldName:GCB_ON; Cycle:2;*)
		iECanDevGo : USINT; (* event status CAN device go *) (* OldName:new PV; Cycle:2 *)
		bSimWinMOD_Active : BOOL; (* WinMode simulation active *) (* OldName:new PV; Cycle:2*)
		rP_Act_Norm_Filt : REAL; (* actual power related to rP_Nom filtered T=1s *) (*OldName:P_IST; Cycle:2*)
		rP_Act_Norm_Filt_TC5 : REAL; (* actual power related to rP_Nom filtered T=1s *) (*OldName:P_IST; Cycle:5*)
		iIdx_Gtyp_Dem : INT; (* actual gassort 1..4 *) (* OldName: gasart; Cycle:5; *)
		bLimpHomeCyl : ARRAY[0..24]OF BOOL; (* limp home if PBC in-cylinder pressure sensor failure *) (* OldName: bLimpHomeCyl; Cycle:2; *)
		bCUp_Man : ARRAY[0..24]OF BOOL; (* SAFI curve upload manuel selection *) (* OldName: ManualUpload; Cycle:2; *)
		rLam_Eng_LL_Set : REAL; (* Leanox Lambda set point *) (* OldName: ssPosGasmixerNominal; Cycle:2; *)
		rPr_Ch_P2s_Avg_TC2 : REAL; (* actual charge pressure before throttle valve (P2s) *) (* OldName: new PV; Cycle:2; *)
		rPr_Ch_P2s_Avg : REAL; (* actual charge pressure before throttle valve (P2s) *) (* OldName: new PV; Cycle:5; *)
		rT_Ch_T2s_Avg_TC2 : REAL; (* actual charge temperature (T2s) *) (* OldName: new PV; Cycle:2; *)
		rT_Ch_T2s_Avg : REAL; (* actual charge temperature (T2s) *) (* OldName: new PV; Cycle:5; *)
		bTrip_IPC_MSF : BOOL; (* Trip: A2214 Cylinder pressure sensor measuring signal failure Prio2*) (* OldName: bAKnockSigErr_DMR; Cycle:5; *)
		STP_STRT : BOOL; (*  tooth to tooth --> air starter off *) (* OldName: new PV; Cycle:5; *) (*V04.04.00.00*)
		bGridCode_ON : BOOL; (*any dyn. GridCode function activated*)
		bFastStart_ready_running : BOOL; (*Engine ready for fast start (engine stopped) OR fast start in action (until target load reached for the first time) *)
		bCANCntReset : BOOL; (* CAN error counter value reset *) (*OldName: bCANCounterReset; Cycle:5;*)
		tSPAx_CamDev : HALioDi_Type; (*DI: SPAx CAM deviation monitoring*) (* OldName: new PV; Cycle:5; *)
		bP_Red_SAErr : BOOL; (*Trigger SAFI power reduction*)
		bIC_IgnEngergy_Hi : BOOL; (*IC Warning Maximum Energy Exceeded*)
	END_STRUCT;
	OUT_SA_struct : 	STRUCT 
		rN_IgnSAFI_Act : REAL; (* Engine speed measured by ignition SAFI *) (* OldName:ZDGSpeed; Cycle:2 *)
		bIgnOperating : BOOL; (* Ignition in Operation *) (* OldName:ZIB; Cycle:2 *)
		rT_EG_Cyl : ARRAY[0..24]OF REAL; (* cylinder exhaust gas temperatures *) (* OldName:t_zyl; Cycle:5 *)
		iU_SAFI_Win1 : ARRAY[0..24]OF INT; (* cylinder values of KLS window 1 *) (* OldName:Fenst1; Cycle:5 *)
		iU_SAFI_Win2 : ARRAY[0..24]OF INT; (* cylinder values of KLS window 2 *) (* OldName:Fenst2; Cycle:5 *)
		iU_SAFI_Win3 : ARRAY[0..24]OF INT; (* cylinder values of KLS window 3 *) (* OldName:Fenst3; Cycle:5 *)
		iU_SAFI_Win4 : ARRAY[0..24]OF INT; (* cylinder values of KLS window 4 *) (* OldName:Fenst4; Cycle:5 *)
		tMS_PBC0 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 0 *) (* OldName:DMR_md0; Cycle:5 *)
		tMS_PBC1 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 1 *) (* OldName:DMR_md1; Cycle:5 *)
		tMS_PBC2 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 2 *) (* OldName:DMR_md2; Cycle:5 *)
		tMS_PBC3 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 3 *) (* OldName:DMR_md3; Cycle:5 *)
		tMS_PBC4 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 4 *) (* OldName:DMR_md4; Cycle:5 *)
		tMS_PBC5 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 5 *) (* OldName:DMR_md5; Cycle:5 *)
		tMS_PBC6 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 6 *) (* OldName:DMR_md6; Cycle:5 *)
		tMS_PBC7 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 7 *) (* OldName:DMR_md7; Cycle:5 *)
		tMS_PBC8 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 8 *) (* OldName:DMR_md8; Cycle:5 *)
		tMS_PBC9 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 9 *) (* OldName:DMR_md9; Cycle:5 *)
		tMS_PBC10 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 10 *) (* OldName:DMR_md10; Cycle:5 *)
		tMS_PBC11 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 11 *) (* OldName:DMR_md11; Cycle:5 *)
		tMS_PBC12 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 12 *) (* OldName:DMR_md12; Cycle:5 *)
		tMS_PBC13 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 13 *) (* OldName:DMR_md13; Cycle:5 *)
		tMS_PBC14 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 14 *) (* OldName:DMR_md14; Cycle:5 *)
		tMS_PBC15 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 15 *) (* OldName:DMR_md15; Cycle:5 *)
		tMS_PBC16 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 16 *) (* OldName:DMR_md16; Cycle:5 *)
		tMS_PBC17 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 17 *) (* OldName:DMR_md17; Cycle:5 *)
		tMS_PBC18 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 18 *) (* OldName:DMR_md18; Cycle:5 *)
		tMS_PBC19 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 19 *) (* OldName:DMR_md19; Cycle:5 *)
		tMS_PBC20 : ARRAY[0..12]OF _tSAFImdatasExtend; (* Pressure based control measuring data 20*)
		tMS_PBC21 : ARRAY[0..12]OF _tSAFImdatasExtend; (* Pressure based control measuring data 21*)
		b_IgnSAFI_SelfTestBack : BOOL; (* Feedback: Ignition system SAFI is in selftest mode *) (* OldName:bSAFISelfTest; Cycle:5 *)
		rU_IgnSAFI_Max : REAL; (* maximum ignition voltage  *) (* OldName:MaxVolt; Cycle:5 *)
		rU_IgnSAFI_Min : REAL; (* minimum ignition voltage  *) (* OldName:MinVolt; Cycle:5 *)
		rU_IgnSAFI_Cyl : ARRAY[0..24]OF REAL; (* ignition voltage for each cylinder  *) (* OldName:V_Zyl; Cycle:5 *)
		rU_IgnSAFI_Avg : REAL; (* ignition voltage average *) (* OldName:AvgVolt; Cycle:5 *)
		tSAFI_CanGo : CanDeviceGo; (* Start / Stop CAN communication *) (* OldName:CANDevGo; Cycle:5 *)
		rN_IgnSAFI_LastValOK : REAL; (* last sent speed value from one of the SAFI devices *) (* OldName:n_lastValOK; Cycle:2 *)
		tSA2AB : MM2AmmBase; (* SAFI module to AMM base data transfer *) (* OldName:new PV; Cycle:2 *)
		tSA2PB : MM2ParaBase_type; (* Data exchange structure to ParaBase *) (* OldName:new PV; Cycle:5 *)
		tMO_PwrRequest : HALioDo_Type; (* DO: MORIS Ignition Power Module Request *) (* OldName:DO_IgnPwrRequest; Cycle:5 *)
		tMO_PwrRequest2 : HALioDo_Type; (* DO: MORIS Ignition Power Module Request *) (* OldName:new PV; Cycle:5 *)
		tMO_PwrRequest3 : HALioDo_Type; (* DO: MORIS Ignition Power Module Request *) (* OldName:new PV; Cycle:5 *)
		tMO_PwrRequest4 : HALioDo_Type; (* DO: MORIS Ignition Power Module Request *) (* OldName:new PV; Cycle:5 *)
		bPBCSensErr : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName:bZM_PBCSensErr; Cycle:5 *)
		bPBCCompLineCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName:bPBCCompLineCheck; Cycle:5 *)
		bPBCNegVoltCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName:bPBCNegVoltCheck; Cycle:5 *)
		bPBCNegPresCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName:bPBCNegPresCheck; Cycle:5 *)
		bPBCPresSlopeCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName:bPBCPresSlopeCheck; Cycle:5 *)
		bPBCSlowDriftCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName:bPBCSlowDriftCheck; Cycle:5 *)
		bPBCConfNotOK : ARRAY[0..12]OF BOOL; (* error info for PBC *) (* OldName:bPBCConfNotOK; Cycle:5 *)
		bPBCMemBurst : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName:bPBCMemBurst; Cycle:5 *)
		bSAFIPBCConfNotOK : BOOL; (* blocking of start because SAFI PBC parameter are not valid *) (* OldName:bSAFIPBCConfNotOK; Cycle:2 *)
		tCUp : ARRAY[0..24]OF tCup_Perm; (* SAFI curve upload data *) (* OldName:tCup; Cycle:2 *)
		iCUpStack : ARRAY[0..23]OF USINT; (* SAFI curve upload stack *) (* OldName:Stack; Cycle:2 *)
		bPBCInvalidPar : ARRAY[0..12]OF BOOL; (* SAFI invalid PBC parameter *) (* OldName:bPBCInvalidPar; Cycle:2 *)
		rSA_SW_Vers : ARRAY[0..12]OF REAL; (* SAFI software version *) (* OldName:usSAFIVers; Cycle: *)
		rSA_FiltVers : ARRAY[0..12]OF REAL; (* SAFI KLS filter version *) (* OldName:usSAFFiltV; Cycle: *)
		rT_SA_ElecTemp : ARRAY[0..12]OF REAL; (* SAFI electronic temperature *) (* OldName:ssSAFITemp; Cycle: *)
		rSA_PBC_Sens : ARRAY[0..12]OF REAL; (* PBC sensor sensitivity [mV/bar] *) (* new PV; Cycle: 2*)
		bPBCCPSSat : ARRAY[0..24]OF BOOL; (* Cylinder pressure sensor saturation flag for cyl X *) (* new PV; Cycle: 2*)
		tE_SAFI : ARRAY[0..12]OF _tEventSAFI; (* SAFI CAN Events *)
		iCnt_SA_ComErr : ARRAY[0..12]OF DINT; (* SAFI communication error counter *) (* OldName:usSAFIComErrCnt; Cycle:  *)
		iSA_ERZuV : ARRAY[0..24]OF INT; (* Error Rate for spark delay  *) (* OldName:ucERZuV; Cycle: *)
		iSA_ERDurTol : ARRAY[0..24]OF INT; (* Error Rate for Duration Tolerance  *) (* OldName:ucERDurTol; Cycle: *)
		bSA_PBCFrozenAltern : ARRAY[0..24]OF BOOL; (*DMR knock signal or IMEP frozen or alternating*)
		bSA_Win1FrozenAltern : ARRAY[0..24]OF BOOL; (*Knock noise signal frozen or alternating*)
		iT_EG_CylFault : ARRAY[0..24]OF UINT; (*0 = No fault / bit0 = SAFI re-para active / bit1 = Exhaust gas temperature signal frozen or alternating*)
		rP_Red_SAErr_Norm : REAL; (* Power reduction by CAN communication failure for half or more SAFI or too many SAFI reboots*)
		bSA_CfgDone : BOOL; (*All SAFI in operation mode*)
		rIHR : ARRAY[0..24]OF REAL; (*Integrated heat release [kJ/m2]*)
		rU_Ign_Max_LimHi : REAL; (* Maximum ignition voltage high limit *)
		bMsg9318_Set : BOOL; (* W9318 cylinder pressure sensor saturation is set *)
	END_STRUCT;
	tPIclosgrad : 	STRUCT 
		PICurGrad : INT;
		PCICurGrad : INT;
	END_STRUCT;
	tPIMode : 	STRUCT 
		EnabRun : BOOL;
		PIself : BOOL;
		PCIself : BOOL;
		PIclose : BOOL;
		PCIclose : BOOL;
		MAct_6_7 : BOOL;
		MAct_8_9 : BOOL;
		Bit08 : BOOL;
		Bit09 : BOOL;
		Bit10 : BOOL;
		Bit11 : BOOL;
		Bit12 : BOOL;
		Bit13 : BOOL;
		Bit14 : BOOL;
		Bit15 : BOOL;
		Bit16 : BOOL;
	END_STRUCT;
	tPIopen : 	STRUCT 
		timing : UINT;
		duration : UINT;
	END_STRUCT;
	tPIcurrent : 	STRUCT 
		current : USINT;
		duration : UINT;
	END_STRUCT;
	tPIrecovery : 	STRUCT 
		delay : UINT;
		current : SINT;
		duration : UINT;
	END_STRUCT;
	tPIaverage : 	STRUCT 
		average_MUX_6_7 : USINT;
		average_MUX_8_9 : USINT;
	END_STRUCT;
	tPICurGrad : 	STRUCT 
		ssFiFo : ARRAY[0..10]OF INT;
		slSum : DINT;
		ssAvg : INT;
	END_STRUCT;
	tPI : 	STRUCT 
		Mode : UINT;
		tPIopenH : tPIopen;
		tPIopenL : tPIopen;
		tPIcurr1 : tPIcurrent;
		tPIcurr2 : tPIcurrent;
		tPIcurr3 : tPIcurrent;
		PIcurr4 : USINT;
		tPIrecov : tPIrecovery;
		tPIpudet1 : tPIpulldet1;
		tPIpudet2 : tPIpulldet2;
		tPIpudet3 : tPIpulldet3;
		tPIopdet1 : tPIopdet1;
		tPIopdet2 : tPIopdet2;
		tPIopdet3 : tPIopdet3;
		tPIopdet4 : tPIopdet4;
		PIclotim : UINT;
		tPIclodet0 : tPIclosdet0;
		tPIclodet1 : tPIclosdet1;
		tPIclodet2 : tPIclosdet2;
		tPIclodet3 : tPIclosdet3;
		tPIclodet4 : tPIclosdet4;
		tPIclodet5 : tPIclosdet5;
		tPCopenH : tPCopen;
		tPCopenL : tPCopen;
		tPCcurr1 : tPCcurrent;
		tPCcurr2 : tPCcurrent;
		tPCcurr3 : tPCcurrent;
		PCcurr4 : USINT;
		tPCrecov : tPCrecovery;
		tPCpudet1 : tPCpulldet1;
		tPCpudet2 : tPCpulldet2;
		tPCopdet1 : tPCopdet1;
		tPCopdet2 : tPCopdet2;
		tPCopdet3 : tPCopdet3;
		tPCfree : tPCfree;
		PCclodet1 : UINT;
		tPCclodet2 : tPCclosdet2;
		tPCclodet3 : tPCclosdet3;
		ShOffRate : USINT;
		tAverage : tPIaverage;
		tPIdemagL : tPIdemag;
		tPIdemagH : tPIdemag;
		tPIcurrCtrL : tPIcurrCtrL;
		tPIcurrCtrH : tPIcurrCtrH;
		ucValveON : USINT;
		tVaOpenL : _tSAFImdatas;
		tVaOpenH : _tSAFImdatas;
		tCurrGradL : tPIclosgrad;
		tCurrGradH : tPIclosgrad;
	END_STRUCT;
	tSAFI : 	STRUCT 
		tPI : tPI;
		tError : ARRAY[0..1]OF _SAFIError;
		E_SAFI : tE_SAFI;
	END_STRUCT;
	tPIpulldet1 : 	STRUCT 
		level_L : UINT;
		level_H : UINT;
	END_STRUCT;
	tPIpulldet2 : 	STRUCT 
		st_time_L : UINT;
		st_time_H : UINT;
	END_STRUCT;
	tPIpulldet3 : 	STRUCT 
		duration_L : UINT;
		duration_H : UINT;
		rate : USINT;
	END_STRUCT;
	tPIopdet1 : 	STRUCT 
		st_time_L : UINT;
		st_time_H : UINT;
	END_STRUCT;
	tPIopdet2 : 	STRUCT 
		duration_L : UINT;
		duration_H : UINT;
	END_STRUCT;
	tPIopdet3 : 	STRUCT 
		up_level_L : UINT;
		up_level_H : UINT;
	END_STRUCT;
	tPIopdet4 : 	STRUCT 
		lo_level_L : UINT;
		lo_level_H : UINT;
		rate : USINT;
	END_STRUCT;
	tPIclosdet0 : 	STRUCT 
		FailR_L : UINT;
		FailR_H : UINT;
	END_STRUCT;
	tPIclosdet1 : 	STRUCT 
		st_time_L : UINT;
		st_time_H : UINT;
	END_STRUCT;
	tPIclosdet2 : 	STRUCT 
		set_current_L : USINT;
		set_current_H : USINT;
	END_STRUCT;
	tPIclosdet3 : 	STRUCT 
		set_duration_L : UINT;
		set_duration_H : UINT;
	END_STRUCT;
	tPIclosdet4 : 	STRUCT 
		duration_L : UINT;
		duration_H : UINT;
		cur_gradient_L : INT;
	END_STRUCT;
	tPIclosdet5 : 	STRUCT 
		cur_gradient_H : INT;
		var_limit_L : UINT;
		var_limit_H : UINT;
	END_STRUCT;
	tPCopen : 	STRUCT 
		timing : UINT;
		duration : UINT;
	END_STRUCT;
	tPCcurrent : 	STRUCT 
		current : USINT;
		duration : UINT;
	END_STRUCT;
	tPCrecovery : 	STRUCT 
		delay : UINT;
		current : SINT;
		duration : UINT;
	END_STRUCT;
	tPCpulldet1 : 	STRUCT 
		level : UINT;
		st_time : UINT;
	END_STRUCT;
	tPCpulldet2 : 	STRUCT 
		duration : UINT;
		current : UINT;
		rate : USINT;
	END_STRUCT;
	tPCopdet1 : 	STRUCT 
		st_time : UINT;
		duration : UINT;
	END_STRUCT;
	tPCopdet2 : 	STRUCT 
		upper_lvl : UINT;
		lower_lvl : UINT;
		rate : USINT;
	END_STRUCT;
	tPCopdet3 : 	STRUCT 
		min_curr : UINT;
		rate : USINT;
	END_STRUCT;
	tPCfree : 	STRUCT 
		free : UINT;
	END_STRUCT;
	tPCclosdet2 : 	STRUCT 
		set_current : USINT;
		set_duration : UINT;
	END_STRUCT;
	tPCclosdet3 : 	STRUCT 
		duration : UINT;
		grad_curr : INT;
		grad_curr_var : UINT;
	END_STRUCT;
	tDMR_ref : 	STRUCT 
		boost_pr : INT;
		mix_temp : INT;
	END_STRUCT;
	Pressure : 	STRUCT 
		Low : ARRAY[0..719]OF UINT;
		LowCA : ARRAY[0..719]OF UINT;
		High : ARRAY[0..719]OF UINT;
		HighCA : ARRAY[0..719]OF UINT;
	END_STRUCT;
	tCup_Pm : 	STRUCT 
		Perm : ARRAY[0..24]OF tCup_Perm;
	END_STRUCT;
	tCup_Perm : 	STRUCT 
		Press : ARRAY[0..719]OF UINT;
		day : UINT;
		month : UINT;
		year : UINT;
		hour : UINT;
		minute : UINT;
		millisec : UDINT;
		rLam_Eng_LL_Set : REAL;
		rPr_Eng_P2s : REAL;
		rT_Eng_T2s : REAL;
		rP_Act_Norm_Filt : REAL;
	END_STRUCT;
	rtctime_typ : 	STRUCT 
		year : UINT;
		month : USINT;
		day : USINT;
		reserve : USINT;
		hour : USINT;
		minute : USINT;
		second : USINT;
		millisec : UINT;
		microsec : UINT;
	END_STRUCT;
	tPIdemag : 	STRUCT 
		delay : UINT;
		duration : UINT;
		up_limit : USINT;
	END_STRUCT;
	tPIcurrCtrL : 	STRUCT 
		delay : UINT;
		duration : UINT;
		level : USINT;
	END_STRUCT;
	tPIcurrCtrH : 	STRUCT 
		delay : UINT;
		duration : UINT;
		level : USINT;
		rate : USINT;
	END_STRUCT;
	tDiag : 	STRUCT 
		ParaFail : tParaFail;
	END_STRUCT;
	tParaFail : 	STRUCT 
		Id : UINT;
		Mux : USINT;
		Nr : USINT;
	END_STRUCT;
END_TYPE
