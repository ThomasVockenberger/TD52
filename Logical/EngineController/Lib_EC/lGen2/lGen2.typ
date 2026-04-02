

TYPE
	tGen2AirAssist :  STRUCT   
		rp_air_int_us :  REAL; (*air pressure upstream of valve - intake side [bar]*)  
		rp_air_int_ds :  REAL; (*air pressure downstream of valve - intake side (=boost pr.) [bar]*)  
		rTair_int :  REAL; (*air temperature upstream of valve intake side [&#xFFFD;C]*)  
		rTair_exh :  REAL; (*air temperature upstream of valve exhaust side [&#xFFFD;C]*)  
		rm_air_int :  REAL; (*air massflow into intake system [kg/s]*)  
		rp_air_exh_us :  REAL; (*air pressure upstream of orifice - exhaust side [bar]*)  
		rp_air_exh_ds :  REAL; (*air pressure downstream of orifice - exhaust side [bar]*)  
		rm_air_exh :  REAL; (*air massflow into exhaust system [kg/s]*)  
	END_STRUCT;

	tGen2BDCtrajAbs :  STRUCT   
		ref_P2_FF_CBV :  LREAL; (**)  
		ref_P2s_FF :  LREAL; (**)  
		ref_P2_FF :  LREAL; (**)  
		ref_P2s_FB_TV :  LREAL; (**)  
		ref_P2_FB_CBV :  LREAL; (**)  
		ref_P2s_FF_TV :  LREAL; (**)  
		d_dt_ref_P2s_FF_TV :  LREAL; (**)  
		d_dt_ref_P2_FF_CBV :  LREAL; (**)  
		d_dt_ref_P2s_FF :  LREAL; (**)  
	END_STRUCT;

	tGen2DbgBdc :  STRUCT   
		Misc :  tGen2DbgBdcMisc; (*debug HLC Motion Planing grid mode*)  
		tv :  tGen2DbgBdcTv; (*debug BDC TV controller*)  
		cbv :  tGen2DbgBdcCbv; (*debug BDC CBV controller*)  
		SP :  tGen2DbgBdcSP; (*debug BDC surge prevention function*)  
		MP :  tGen2DbgBdcMP; (*debug BDC motion planning*)  
		RL :  tGen2DbgBdcRL; (*debug BDC rate limiter island mode*)  
		traj :  tGen2BDCtrajAbs; (*reference trajectory output*)  
		FF :  tGen2DbgBdcFF; (*debug BDC feedforward*)  
	END_STRUCT;

	tGen2DbgBdcCbv :  STRUCT   
		ff_cbv :  REAL; (**)  
		ff_cbv_unsat :  REAL; (**)  
		up_cbv :  REAL; (**)  
		ui_cbv :  REAL; (**)  
		fb_cbv :  REAL; (**)  
		uaw_cbv :  REAL; (**)  
		i0_cbv :  REAL; (**)  
	END_STRUCT;

	tGen2DbgBdcFF :  STRUCT   
		me :  REAL; (*engine massflow estimate*)  
		me_d :  REAL; (*desired engine massflow*)  
		me_cbv_d :  REAL; (*desired bypass massflow*)  
		CBV_cd :  REAL; (*desired discharge coefficient cbv*)  
		TV_me_d :  REAL; (*desired throttle valve massflow*)  
		TV_cd :  REAL; (*desired discharge coefficient tv*)  
		wg_me :  REAL; (*engine massflow estimate*)  
		wg_me_d :  REAL; (*desired engine massflow*)  
		wg_m_d :  REAL; (*desired wastegate massflow*)  
		wg_cd :  REAL; (*desired discharge coefficient wgv*)  
		u_ff_cbv :  REAL; (*feedforward cbv*)  
		u_tv_ff :  REAL; (*feedforward tv*)  
		dbg_cbvTracking_PI :  REAL; (*debug cbvTracking  PI proportion*)  
		dbg_cbvTracking_P :  REAL; (*debug cbvTracking P proportion*)  
		dbg_cbvTracking_I :  REAL; (*debug cbvTracking I proportion*)  
	END_STRUCT;

	tGen2DbgBdcMP :  STRUCT   
		u :  REAL; (*reference p2' for TV control*)  
		u_ff :  REAL; (*reference p2' for TV feedforward control*)  
		u0 :  REAL; (*reference p2' for TV control*)  
		u0_ff :  REAL; (*reference p2' for TV feedforward control*)  
		TVdp :  REAL; (*throttle delta P command*)  
		TVdpFF :  REAL; (*throttle delta P command for feedforward signals.*)  
		offset :  REAL; (*correction for steady state tracking of p2' if TV is open.*)  
		offset_in :  REAL; (*input to correction *)  
	END_STRUCT;

	tGen2DbgBdcMisc :  STRUCT   
		PI_tv :  REAL; (*Pressure ratio across TV*)  
		PI_LP :  REAL; (*Pressure ratio across LP compressor*)  
		PI_HP :  REAL; (*Pressure ratio across HP compressor*)  
		PI_total :  REAL; (*Pressure ratio total*)  
	END_STRUCT;

	tGen2DbgBdcRL :  STRUCT   
		RLp2s_d :  REAL; (**)  
		RLp2s_d_ff :  REAL; (**)  
		RLp2s_d_ff_z :  REAL; (**)  
		RLact :  REAL; (**)  
		RL :  REAL; (**)  
		RLthrsh :  REAL; (**)  
		Rlrequ :  REAL; (**)  
		RLp2s_d_RL :  REAL; (**)  
		RLp2s_d_ff_RL :  REAL; (**)  
		Rlreset :  REAL; (**)  
	END_STRUCT;

	tGen2DbgBdcSP :  STRUCT   
		rCBV_Min :  REAL; (*Lower SatLimit CBV pos. Surge Protection*)  
		rTV_Min :  REAL; (*Lower SatLimit TV pos. Surge Protection*)  
		rMdot_mixture_cyl :  REAL; (*mass flow rate of cylinders*)  
		rMdot_mixture_Bypass :  REAL; (*mass flow rate through the bypass valves*)  
		rPrR_TC_Surge :  REAL; (*surge pressure ratio of compressor*)  
		mdot_corr :  REAL; (*corrected mass flow rate of compressor*)  
	END_STRUCT;

	tGen2DbgBdcTv :  STRUCT   
		ff :  REAL; (**)  
		ff_unsat :  REAL; (**)  
		up :  REAL; (**)  
		ui :  REAL; (**)  
		fb :  REAL; (**)  
		uaw :  REAL; (**)  
		i0 :  REAL; (**)  
		bTVCtrl_ON :  BOOL; (**)  
	END_STRUCT;

	tGen2DbgFdc :  STRUCT   
		dbgFDC_Filtering :  tGen2dbgFDC_Filtering; (*debug FDC input filters*)  
		dbgFDC_GasArt1and2 :  tGen2dbgFDC_GasArt1and2; (*debug FDC gas art 1 and 2*)  
		dbgFDC_GasArt3 :  tGen2dbgFDC_GasArt3; (*debug FDC gas art 3*)  
	END_STRUCT;

	tGen2DbgGQC :  STRUCT   
		bActGasQualImprov :  BOOL; (**)  
		bDetSatLambda :  BOOL; (**)  
		bDetKnock :  BOOL; (**)  
		bDetSatActuators :  BOOL; (**)  
		bMisfDet :  BOOL; (**)  
	END_STRUCT;

	tGen2DbgHlc :  STRUCT   
		Gen2DbgHlcTraj :  tGen2DbgHlcTraj; (*debug HLC Motion Planing grid mode*)  
		BGen2DbgHlcPowCtrl :  tGen2DbgHlcPowCtrl; (*debug HLC Power Controller*)  
		dbgHLCPowCtrlGQC :  tGen2DbgHlcPowCtrl; (*debug HLC Power Controller: p2s offset from gas qual. Change*)  
	END_STRUCT;

	tGen2DbgHlcPowCtrl :  STRUCT   
		ff :  REAL; (**)  
		up :  REAL; (**)  
		ui :  REAL; (**)  
		ud :  REAL; (**)  
		aw :  REAL; (**)  
		aw_ext :  REAL; (**)  
		aw_aux :  REAL; (**)  
		u_unsat :  REAL; (**)  
		u :  REAL; (**)  
	END_STRUCT;

	tGen2DbgHlcTraj :  STRUCT   
		rp2s_leanox :  REAL; (**)  
		rP_Set_Delta_FSM :  REAL; (*[kW] power setpoint delta FSM D-part*)  
	END_STRUCT;

	tGen2DbgHlci :  STRUCT   
		FF :  tGen2DbgHlciFF; (*debug HLC island feed forward*)  
		LR :  tGen2DbgHlciLR; (*debug HLC LR island*)  
		Prot :  tGen2DbgHlciProt; (*debug HLC rotational power calculation*)  
		SkipF :  tGen2DbgHlciSkipF; (*debug HLC skipfire*)  
		LQR :  tGen2DbgHlciLQR; (*debug HLC LQR based speed controller island*)  
	END_STRUCT;

	tGen2DbgHlciFF :  STRUCT   
		rPest_FF :  REAL; (*Power estimation feed forward*)  
		rP2s_FF :  REAL; (*boost pressure feed forward*)  
		P_est_vFilt :  REAL; (**)  
		LineVol_nPower :  REAL; (**)  
		LineVol_vPower :  REAL; (**)  
		rFactLSL :  REAL; (*factor for p2s reference based on speed deviation*)  
		rLSLff_p :  REAL; (*P term LSLff ; rFactLSL_unlimit = 1 + rLSLff_p + rLSLff_d*)  
		rLSLff_d :  REAL; (*D term LSLff ; rFactLSL_unlimit = 1 + rLSLff_p + rLSLff_d*)  
	END_STRUCT;

	tGen2DbgHlciLQR :  STRUCT   
		x_ref :  ARRAY[0..2] OF REAL; (*reference for states for LQR*)  
		x_sp :  ARRAY[0..2] OF REAL; (*reference for states for LQR corrected for steady state tracking*)  
		x_k :  ARRAY[0..2] OF REAL; (*feedback of states for LQR*)  
		u_k :  ARRAY[0..3] OF REAL; (*control outputs of LQR (p2s_ref, lambda_ref, IT, Nskip)*)  
		x_KF :  ARRAY[0..2] OF REAL; (*kalman filter states*)  
		x_dist_KF :  ARRAY[0..2] OF REAL; (*kalman filter disturbance states*)  
		x_dist1_map :  REAL; (*kalman filter map value of first disturbance state*)  
		x_sp_KF :  ARRAY[0..2] OF REAL; (*kalman filter corrected setpoints for the states (considering dist.)*)  
		u_sp_KF :  ARRAY[0..1] OF REAL; (*kalman filter corrected setpoints for the inputs (considering dist.)*)  
		err_KF :  ARRAY[0..2] OF REAL; (*kalman filter estimation error*)  
		K_KF :  ARRAY[0..17] OF REAL; (*kalman filter gain matrix [11;21;31;41;51;61...;13;23;33;43;53;63]*)  
		P_KF :  ARRAY[0..35] OF REAL; (*kalman filter step solution [11;21;31;41;51;61...;16;26;36;46;56;66]*)  
		err_cont :  ARRAY[0..2] OF REAL; (*control error (states)*)  
		Ke_calc :  REAL; (*Ke calculated*)  
		Ke :  REAL; (*Ke (including gain scheduling)*)  
		Ke0 :  REAL; (*Ke (excluding gain scheduling)*)  
		eOmRef :  REAL; (*state of integrator for speed tracking*)  
		bTrigDPr_limit :  BOOL; (*pressure change trigger for out of window*)  
		bOutOfNWindow :  BOOL; (*detection for out of speed window*)  
		omega_dot :  REAL; (*estimated gradient of speed [rad/s]*)  
		bLamSat :  BOOL; (*true if lambda is saturated in lower or upper limit.*)  
		Phi :  ARRAY[0..8] OF REAL; (*linearized system matrix of system model [11;21;31;...;13;23;33]*)  
		H :  ARRAY[0..11] OF REAL; (*linearized input matrix of system model [11;21;31;...;14;24;34]*)  
		x_k_pred :  ARRAY[0..2] OF REAL; (*predicted states*)  
		K_LQR :  ARRAY[0..11] OF REAL; (*LQR gain matrix [11;21;31;...;13;23;33]*)  
		P_LQR :  ARRAY[0..8] OF REAL; (*LQR - solution of Riccati equation [11;21;31;...;13;23;33]*)  
		Ke_act_map :  REAL; (*actual Ke from p2s-map*)  
		bAdaptReleased :  BOOL; (*Ke map update released*)  
		bResKeEst :  BOOL; (*Ke estimator update reset*)  
		bKeEstTransDet :  BOOL; (*Ke estimator transient detection*)  
		Ke_est :  REAL; (*Ke estimated [1e5*m^3] isolated operation*)  
		delta_IT_Acc :  REAL; (*[&#xFFFD;CA] ignition timing offset for load acceptance*)  
		dPr_P2s_RefSatLam :  REAL; (*[bar] p2s setpoint offset from Lambda Max. saturation*)  
	END_STRUCT;

	tGen2DbgHlciLR :  STRUCT   
		bLR_GasStop :  BOOL; (*Enable GasStop*)  
		bIgnOff :  BOOL; (*Misfire command (number of cylinders)*)  
		bLR_ActSat_CBV :  BOOL; (*CBV Saturation during load rejection*)  
		bLR_ActSat_TV :  BOOL; (*TV Saturation during load rejection*)  
		bLR_IGN_Retard_Trig :  BOOL; (*Ign. Retard command*)  
		rP_Rot_Corr_Norm :  REAL; (*corrected rotational power [p.u.]*)  
		IGN_retard_interpol :  REAL; (*interpolated value of ignition retard [&#xFFFD;CA BTDC]*)  
		IGN_retard_active :  REAL; (*chosen value of ignition retard [&#xFFFD;CA BTDC]*)  
		delta_IGN_Retard :  REAL; (*actuated value of ignition retard [&#xFFFD;CA BTDC]*)  
		rFactCompLR :  REAL; (*compensation factor gasflow for large load rejections*)  
		bLR_SatActuators :  BOOL; (*LR: TV minimum and CBV maximum*)  
	END_STRUCT;

	tGen2DbgHlciProt :  STRUCT   
		omega :  REAL; (*engine speed *)  
		omega_filt :  REAL; (*filtered engine speed*)  
		omega_dot :  REAL; (*deviation of speed*)  
		rProt :  REAL; (*Rotational power*)  
	END_STRUCT;

	tGen2DbgHlciSkipF :  STRUCT   
		rSkipfire_PI :  REAL; (*Port injection skipfire*)  
		rLam_skip :  REAL; (*deltaN skip lambda for port injection skipfire*)  
		bDemand_Skip :  BOOL; (*LR skipfire demand on*)  
		rSkip_level :  REAL; (*PD filtered overspeed for triggering LR skipfire*)  
		rSkipfire :  REAL; (*number of skipped cylinders for LR*)  
		bSkip_pulse_on :  BOOL; (*0: ignition ; 1: skipfire*)  
		rN_diff :  REAL; (*Difference reference speed - actual speed [rpm]*)  
	END_STRUCT;

	tGen2DbgItc :  STRUCT   
		IT_off_start :  REAL; (**)  
		IT_off_island34 :  REAL; (**)  
		IT_off_island6 :  REAL; (**)  
	END_STRUCT;

	tGen2DbgKeEstNetP :  STRUCT   
		Ke_calc :  REAL; (*Ke calc from dbgHLCi*)  
		KeEstNetP :  REAL; (*Ke estimate in netp mode from P,n,p2s,lambda [1e5*m^3]*)  
	END_STRUCT;

	tGen2DbgLamLim :  STRUCT   
		extOffset :  REAL; (*extenal offset*)  
		AutoOffset :  REAL; (*Auto Offset computed internally*)  
		ScaledOffsetUpLim :  REAL; (*offset by scaling leaning out*)  
		ScaledOffsetLoLim :  REAL; (*offset by scaling enrichment*)  
		offsetUpLim :  REAL; (*total offset UpLim*)  
		offsetLoLim :  REAL; (*total offset LoLim*)  
		LamLoLim :  REAL; (*LoLim before Map logic*)  
		LamUpLim :  REAL; (*UpLim before Map logic*)  
		LamSteadyState :  REAL; (*steady state lambda estimate*)  
		rLamOffsInit :  REAL; (*initialization for Lambda Auto offset: lambda idle = lambda_min*)  
		bInitLamOffs :  BOOL; (*true: lambda auto offset is reset to rLamOffsInit*)  
		bPminSSadaptReached_Hys :  BOOL; (*true: P > PminSSadapt w. hysteresis: stays true for ramp down*)  
	END_STRUCT;

	tGen2DbgLxWgCmp :  STRUCT   
		CDSet :  REAL; (*Setpoint of CD*)  
		CDAct :  REAL; (*Actual value of CD*)  
		DeltaCD_aux :  REAL; (*Discharge coefficient CD an auxiliary quantity *)  
		DeltaP2s_set :  REAL; (*Boost pressure difference setpoint*)  
		DeltaP2s_Comp_WGV :  REAL; (*boost pressure difference WGV compensation in mbar*)  
	END_STRUCT;

	tGen2DbgSkipF :  STRUCT   
		NskipPow :  REAL; (**)  
		NskipMax :  REAL; (**)  
		Nskip34 :  REAL; (**)  
		Nskip6 :  REAL; (**)  
	END_STRUCT;

	tGen2Debug :  STRUCT   
		HLCi :  tGen2DbgHlci; (*debug HLC island*)  
		HLC :  tGen2DbgHlc; (*debug HLC grid mode*)  
		FDC :  tGen2DbgFdc; (*debug Fuel Dynamic Control*)  
		BDC :  tGen2DbgBdc; (*debug Boost Dynamic Control*)  
		ITC :  tGen2DbgItc; (*debug Ignition Timing Control*)  
		SkipF :  tGen2DbgSkipF; (*debug Skipfire Control*)  
		LamLim :  tGen2DbgLamLim; (*debug Lambda Limits*)  
		LxWgvCmp :  tGen2DbgLxWgCmp; (*debug Leanox compensation wastegate*)  
		KeEstNetP :  tGen2DbgKeEstNetP; (*debug Ke estimator in net parallel mode*)  
		GQC :  tGen2DbgGQC; (*debug gas quality change functions*)  
	END_STRUCT;

	tGen2In :  STRUCT   
		tPr :  tGen2Pr; (**)  
		tT :  tGen2Temp; (**)  
		tLvrt :  tGen2Lvrt; (**)  
		rP_Set :  REAL; (*Power setpoint defined by the user (incl. reductions) [kW]*)  
		rP_Set_unred :  REAL; (*Power setpoint without reduction [kW]*)  
		rP_Act :  REAL; (*Generator Active Power [kW]*)  
		rCA_Ign_Avg :  REAL; (*Ignition timing [CA]*)  
		rCA_Ign_OP_Power :  REAL; (*Ignition timing with knock monitoring net parallel [&#xFFFD;CA]*)  
		rN_Set :  REAL; (*reference engine speed [rpm]*)  
		rN_Eng :  REAL; (*high resolution speed signal [rpm]*)  
		rN_TC_LP :  REAL; (*Low pressure turbocharger speed [rpm]*)  
		rN_TC_HP :  REAL; (*High pressure turbocharger speed [rpm]*)  
		rU_Gen_Norm :  REAL; (*Generator Line-to-Line Voltage [pu]*)  
		rU_Gen_Avg :  REAL; (*Generator Line-to-Line Voltage average [V]*)  
		bActive_p2sMan :  BOOL; (*Boost pressure command Active (Leanox manual)*)  
		rPr_p2sMan :  REAL; (*Boost pressure comand [bar]*)  
		rAW_EGT_ext :  REAL; (*Additional external windup input Exhaust gas temperature*)  
		bResetGlobal :  BOOL; (*Global filter reset*)  
		bEng_Dem :  BOOL; (*Engine Demand ON*)  
		iOpMode :  INT; (*Operation Mode*)  
		bGen2_NetP_ena :  BOOL; (*Enable Gen2 for NetP mode*)  
		bGen2_island_ena :  BOOL; (*Enable Gen2 for island mode*)  
		bSs :  BOOL; (*Engine in steady state*)  
		tAirAssist :  tGen2AirAssist; (**)  
		tLEANOXin :  tGen2LEANOXin; (**)  
		rOffsetLamLimit :  REAL; (*external offset for lambda limits and lambda reference*)  
		IN_EC_rGT_RatioMix_TC2 :  REAL; (*Gas mixture rate after ramp fub [%], e.g. 0.5 = 50%*)  
		bResetTraj :  BOOL; (*Reset Trajectory Generator*)  
		rLam_idle :  REAL; (*idle lambda *)  
		rDeltaLamSync :  REAL; (*delta lambda for synchronization*)  
		rMisfire_level :  REAL; (*Misfire level*)  
		rKnock_level :  REAL; (*knocking level*)  
		rN_Eng_LRskipF :  REAL; (*speed [rpm] for calculation skipfire for load rejection*)  
		iN_Skip_Ext :  INT; (*external command of skip fire amount*)  
	END_STRUCT;

	tGen2LEANOXin :  STRUCT   
		bZylAusfall :  BOOL; (*indicator of 1 misfiring cylinder to correct LEANOX*)  
		rHiCtr_Leanox_Corr :  REAL; (*factor LEANOX ref to compensate skip- and misfire [-]*)  
		rLEANOXoffset :  REAL; (*generic offset LEANOX reference - for ESC, island [mbar]*)  
		rLEANOX_fact_BC :  REAL; (*factor LEANOX ref before compensations*)  
	END_STRUCT;

	tGen2Lvrt :  STRUCT   
		bLvrtFlg :  BOOL; (*Flag set after detection of LVRT event. It remains high for 5 sec after detection *)  
		rTvPosFb :  REAL; (*Feed back of throttle valve position*)  
		rCbvPosFb :  REAL; (*Feed back of compressor by pass valve position*)  
		rWgPosFb :  REAL; (*Feed back of waste gate valve position*)  
	END_STRUCT;

	tGen2Out :  STRUCT   
		rmdot_gas :  REAL; (*Gas mass flow [kg/s]*)  
		rmdot_gas_M :  REAL; (*Gas mass flow of gas art 3 [kg/s]*)  
		rLamGen2 :  REAL; (*Lambda value from Gen2*)  
		rPos_TV :  REAL; (*TV position [pu]*)  
		rPos_CBV :  REAL; (*CBV position [pu]*)  
		rPos_WGV :  REAL; (*WGV position [pu]*)  
		rPr_p2s_des :  REAL; (*control reference for boost pressure [bar]*)  
		rPrP2sLEANOXref :  REAL; (*LEANOX reference for boost pressure [bar]*)  
		iNskip :  INT; (*Skip Fire Command*)  
		rdeltaIT :  REAL; (*offset in ignition timing for transient to avoid knock*)  
		rLamLimUp :  REAL; (*Upper lambda limit*)  
		rLamLimLo :  REAL; (*Lower lambda limit*)  
		rLamss :  REAL; (*Lambda in steady state*)  
		rP_des :  REAL; (*Power trajectory [kW]*)  
		rLamMap :  ARRAY[0..9] OF REAL; (*Adapted steady state lambda map*)  
		rState_Dist1Map :  ARRAY[0..12] OF REAL; (*LQR disturbance estimate d1, boost pressure dependent map*)  
		rKengMap :  ARRAY[0..12] OF REAL; (*Engine gain map adapted during island mode*)  
		rKengMap_P :  ARRAY[0..6] OF REAL; (*Engine gain map adapted during island  (f. skipfire operation)*)  
		rPos_CBV2 :  REAL; (*CBV position 2nd compressor bypass valve [pu]*)  
		rPos_CBV3 :  REAL; (*CBV position 3rd compressor bypass valve [pu]*)  
		bAirAssistIntake :  BOOL; (*open (true) slamshut valve air assist on intake side *)  
		bAirAssistExhaust :  BOOL; (*open (true) slamshut valve air assist on exhaust side *)  
		rPos_AAV_Intake :  REAL; (*AAV position air assist valve intake [pu]*)  
		rPos_AAV_Exhaust :  REAL; (*AAV position air assist valve exhaust [pu]*)  
		TJ_GasO :  ARRAY[0..4] OF BOOL; (* TJ gas flow maximum error *)  
		TJ_GasM :  ARRAY[0..4] OF BOOL; (* TJ gas flow change error *)  
		bSS :  BOOL; (*steady state detectet*)  
		Ptraj_SpeedCtrl :  REAL; (*Power trajectory [kW] for Speed Controlled Engine (Droop+NetP)*)  
		rLHV_est :  REAL; (*estimation of lower heating value J/kg, unfiltered (based on Ke)*)  
	END_STRUCT;

	tGen2Para_EGTLim :  STRUCT   
		bActive :  BOOL; (*limt Texh in power control*)  
		rT_max :  LREAL; (*max Exhaust temperature [&#xFFFD;C]*)  
		rT_CR_hard :  LREAL; (*Distance to ExTLim - hard limit [&#xFFFD;C]*)  
		rT_CR_soft :  LREAL; (*Distance to ExTLim - soft limit [&#xFFFD;C]*)  
		rKaw_hard :  LREAL; (*anti wind up gain for Texh above upper limit*)  
		rKaw_soft :  LREAL; (*anti wind up gain for Texh below upper limit*)  
	END_STRUCT;

	tGen2Para_Eff :  STRUCT   
		bActive_EtaVolExt :  BOOL; (*Use external volumetric efficiency*)  
		rEtaVolExt :  LREAL; (*Volumetric efficiency external [pu]*)  
		bActive_EtaBrakeExt :  BOOL; (*Use external  engine Brake efficiency*)  
		rEtaBrakeExt :  LREAL; (*Engine Brake efficiency external [pu]*)  
	END_STRUCT;

	tGen2Para_GQC :  STRUCT   
		bEnableFuncQGC :  BOOL; (*enable functions for gas qual. Changes: p2s offset, lambda external*)  
		rTON_LamSat :  LREAL; (*time [sec] delay for lambda saturation condition*)  
		rThrshLamSat :  LREAL; (*threshold for lambda saturation: abs(lam-lam_lim)<thrsh*)  
		rTOF_KnockMisfDet :  LREAL; (*[s] TOF for detection knocking and misfire*)  
		rTOF_DetSat :  LREAL; (*[s] TOF for detection of CBV/TV saturation*)  
		bActKnockDetGQC :  BOOL; (*activation IT delta based knock detection*)  
		rThreshold_knock :  LREAL; (*knocking level*)  
		rThreshold_misfire :  LREAL; (*misfire level*)  
	END_STRUCT;

	tGen2Para_ITC :  STRUCT   
		rKp :  LREAL; (*Ignition timing proportional controller gain*)  
		rITCoffsetP2s_x :  ARRAY[0..4] OF LREAL; (*boost pressure vect [bar]*)  
		rITCoffsetP2s_y :  ARRAY[0..4] OF LREAL; (*ignition retard (offset) depending on boost pressure*)  
		rITCdeltaMAX :  LREAL; (*max. value for advancing ignition timing*)  
		rITCdeltaMIN :  LREAL; (*max. value for retarding ignition timing*)  
		rITCtransDPthrsh :  LREAL; (*boost pressure difference thrshold to trigger ITC reaction in island operation [bar]*)  
		rITCtransTON :  LREAL; (*minimum time of transient ignition timing reaction before ramp back can occur [s]*)  
		rITCtransNthrsh :  LREAL; (*speed offset from reference to decide to ramp back ignition timing after transient [rpm]*)  
		rITCtransDeltaAcc_x :  ARRAY[0..4] OF LREAL; (*vector of boost pressure break points for commanded ignition timing offset during transient [bar]*)  
		rITCtransDeltaAcc_y :  ARRAY[0..4] OF LREAL; (*vector of commanded ignition timing offset during transient (pos.: retard, neg.: advance, 0=no reaction)*)  
		rITCtransSRback :  LREAL; (*slew rate to ramp back the igniton timing to nominal after transinet*)  
		rITCtransDelay :  LREAL; (*delay before transient ignition timing reaction is active after detection of step [s]*)  
	END_STRUCT;

	tGen2Para_KeEstNetP :  STRUCT   
		bActKeEstNetP :  BOOL; (*activate Ke Estimator in NetP mode*)  
	END_STRUCT;

	tGen2Para_LR :  STRUCT   
		rLCRCurve_DK_min_Lup_x :  ARRAY[0..7] OF LREAL; (*Surge protection depending on boost pressure*)  
		rLCRCurve_DK_min_Lup_y :  ARRAY[0..7] OF LREAL; (*Surge protection depending on boost pressure*)  
		rCBV_lim_byTV_Lup_x :  ARRAY[0..4] OF LREAL; (*Surge protection depending on tv position*)  
		rCBV_lim_byTV_Lup_y :  ARRAY[0..4] OF LREAL; (*Surge protection depending on tv position*)  
		rP_LR_Trig_GasStop :  LREAL; (*Power trigger for GasStop function*)  
		rTi_LR_GasStop :  LREAL; (*Activation time for GasStop function in ms*)  
		bTiTOF_GasSTop :  BOOL; (*switch between TP (FALSE) and TOF (TRUE) for gasstop*)  
		rP_LR_Trig_GasStop_HL :  LREAL; (*Rot. power trigger for GasStop function*)  
		rN_LR_Trig_GasStop :  LREAL; (*Speed trigger for GasStop function*)  
		bSwitch_Surge_CBV_Min :  BOOL; (*Switch on surge protection based on boost pressure*)  
		bSwitch_Surge_TV_Min :  BOOL; (*Switch on surge protection based on throttle pos.*)  
		rP_LR_Trig_ActSat_CBV :  LREAL; (*Activate CBV saturation during GasStop*)  
		rTi_LR_ActSat_CBV :  LREAL; (*Activation time of CBV saturation during GasStop in ms*)  
		rP_LR_Trig_ActSat_TV :  LREAL; (*Activate TV saturation during GasStop*)  
		rTi_LR_ActSat_TV :  LREAL; (*Activation time of TV saturation during GasStop in ms*)  
		bP_LoadReject_Active :  BOOL; (*Activate Load rejection function*)  
		rP_LR_Trig_Misf :  LREAL; (*Misfire trigger Type 6*)  
		rN_Misf_2_Trig :  LREAL; (*Speed trigger Misfire Type 6*)  
		iTime_Eng_Cyc :  LREAL; (*Engine cycle time in ms*)  
		iCyc_Ign_Max_Off :  LREAL; (*Number of cycles with deactivated ignition*)  
		iCyc_Ign_Min_On :  LREAL; (*Number of cycles with activated ignition*)  
		rTiAvoidTrigMisf :  LREAL; (*Time in which the first trigger of misfire is not allowed [s]*)  
		bLR_ActSat_CBV :  BOOL; (*Activate CBV Saturation during LR*)  
		bLR_ActSat_TV :  BOOL; (*Activate TV Saturation during LR*)  
		rP_LR_Trig_IGN_Retard :  LREAL; (*Trigger for Ign. retard function type 6*)  
		rTi_LR_IGN_Retard_MAX :  LREAL; (*Activation time of Ign. retard function type 6 in ms*)  
		rLR_IGN_Retard_IT :  LREAL; (*Ignition retard maximum when Ign. retard is active*)  
		rLR_IGN_Retard_IT_min :  LREAL; (*Ignition retard minimum when Ign. retard is active*)  
		rProt_IGN_Retard_max :  LREAL; (*rotational power where maximum Ign. retard is active*)  
		rProt_IGN_Retard_min :  LREAL; (*rotational power where minimum Ign. retard is active*)  
		rN_trig_cbv_lim :  LREAL; (*threshold to activate limit of CBV dep. on TV*)  
		iNum_steady_state :  INT; (*defines delay until steady state is reached*)  
		xLCRCurve_R_Rot_Correction_X :  ARRAY[0..8] OF LREAL; (*scaling of estimated rotational power X*)  
		xLCRCurve_R_Rot_Correction_Y :  ARRAY[0..8] OF LREAL; (*scaling of estimated rotational power X*)  
		rLCRCurve_DK_min_Lup_offset :  LREAL; (*tuning factor for min throttle position*)  
		rN_LR_IGN_Retard_ON :  LREAL; (*speed dependency of ignition retard*)  
		bLIM_TVbyP2s_OFFatLargeRej :  BOOL; (*activate to turn off surge protection for large rejections*)  
		rP_Trig_TVbyP2S_OFF :  LREAL; (*Trigger Rot Power for turning off surge protection [p.u.]*)  
		rN_LR_HardLim_norm :  LREAL; (*max speed where surge protection is turned off*)  
		rN_LIM_TVbyPOS_ON :  LREAL; (*speed where surge protection is activated again.*)  
		rTi_LR_LIM_TV_OFF :  LREAL; (*minimum time where surge protection is off [ms]*)  
		rRateITadvance :  LREAL; (*rate to change ignition timing back to nominal*)  
		bActGasFlowSatComp :  BOOL; (*activation of LR gas flow compensation if TV and CBV saturated*)  
		rRL_GasFlowSatCompUp :  LREAL; (*rate limit positive for LR gas flow comensation factor*)  
		rGainGasFlowSatComp :  LREAL; (*gain for LR gas flow compensation if TV and CBV saturated*)  
		bGS_GasFlowSatComp_active :  BOOL; (*activate gain-scheduling for LR gas flow compensation gain*)  
		bGS_GasFlowSatComp_UseProt :  BOOL; (*use Prot instead of p2s for GF LuT*)  
		rGainGasFlowSatComp_GS_x :  ARRAY[0..7] OF LREAL; (*x gain-scheduling for LR gas flow compensation gain*)  
		rGainGasFlowSatComp_GS_y :  ARRAY[0..7] OF LREAL; (*y gain-scheduling for LR gas flow compensation gain*)  
		rN_GasFlowSatComp_diffLo :  LREAL; (*[rpm] lower speed diff limit for LR gas flow compensation if TV and CBV saturated*)  
		rN_GasFlowSatComp_diffUp :  LREAL; (*[rpm] upper speed diff limit for LR gas flow compensation if TV and CBV saturated*)  
		rTi_GasFlowSatComp_TP2psSettle :  LREAL; (*[s] pulse time to hold the p2s settle bit*)  
		rP2s_GasFlowSatComp_SettleLim :  LREAL; (*[bar] limit to stop gas flow compensation factor depending on p2s*)  
		rP_GasFlowSatComp_RotLim :  LREAL; (*[-] Prot limit to activate gas flow correction*)  
		rTi_GasFlowSatComp_ProtTP :  LREAL; (*[s] TP time to activate gas flow correction when Prot limit exceeded*)  
		bAct_CompActSatOnly :  BOOL; (*correct gas dosage only when TV and CBV in saturation*)  
	END_STRUCT;

	tGen2Para_LamLim :  STRUCT   
		rPr_p2s_Lup_in :  ARRAY[0..9] OF LREAL; (**)  
		rLam_max :  LREAL; (*max lambda setpoint absolute*)  
		rLam_min :  LREAL; (*min lambda setpoint absolute*)  
		rLamMapBase :  ARRAY[0..9] OF REAL; (*Steady state lambda map initial condition (500mg Nox)*)  
		rLamMapBase250mg :  ARRAY[0..9] OF REAL; (*Steady state lambda map initial condition (250mg Nox)*)  
		bNOx250mg :  BOOL; (*decide which baseline calibration (TRUE: 250mg NOx, FALSE 500mg NOx)*)  
		rTiSSfilter :  LREAL; (*filter time constant for steady state detection*)  
		rTiSSsampling :  LREAL; (*sample intervals to check steady state*)  
		rThrshSSPow :  LREAL; (*threshold to accept steady state [kW]*)  
		rThrshSSspeed :  LREAL; (*threshold to accept steady state [rpm]*)  
		rThrshSSboost :  LREAL; (*threshold to accept steady state [mbar]*)  
		bAutomaticOffsetON :  BOOL; (*compute global lambda limit offset*)  
		rThrshSpdSwTbdc :  LREAL; (*threshold to accept steady state [rpm]*)  
		rThrshBoostSwTbdc :  LREAL; (*threshold to accept steady state [mbar]*)  
		rPminSSadapt :  LREAL; (*normalized power threshold to start lambda map adaption*)  
		rTiFiltLambdaOffset :  LREAL; (*filter time constant for computation of lambda offset*)  
		bActLambdaOffsetNotSteady :  BOOL; (*activation of lambda auto offset if no steady state*)  
		rFactTiFiltLamOffsNotSteady :  LREAL; (*factor for filter time constant when not in steady state*)  
		rLamOffsetLimInit :  LREAL; (*initial value for lambda limit offset*)  
		refPoint_LamLoLim_ABS_x :  ARRAY[0..5] OF LREAL; (*lower lambda limit map - x -boost pressure [bar]*)  
		refPoint_LamLoLim_ABS_y :  ARRAY[0..5] OF LREAL; (*lower lambda limit map - y*)  
		refPoint_LamUpLim_ABS_x :  ARRAY[0..5] OF LREAL; (*upper lambda limit map - x -boost pressure [bar]*)  
		refPoint_LamUpLim_ABS_y :  ARRAY[0..5] OF LREAL; (*upper lambda limit map - y*)  
		rFactEnrich :  LREAL; (*factor to define lambda limits: 1 - full enrichment; 0 - no enrichment*)  
		rFactLean :  LREAL; (*factor to define lambda limits: 1 - full lean out 0 - no lean ouot*)  
		rThrshLamSatOn :  LREAL; (*threshold to detect saturation of lambda [-]*)  
		rThrshLamSatOff :  LREAL; (*threshold to reset detection saturation of lambda [-]*)  
		bLamOffsInitPerm :  BOOL; (*on: lambda auto offset init w. idle lambda (instead using Perm value)*)  
		bActLamLim_GQCimprovement :  BOOL; (*activation of lambda limit adaptions for start w. gas quality change*)  
	END_STRUCT;

	tGen2Para_LoadEst :  STRUCT   
		rNu :  LREAL; (*load type: resistive = 2 (nu in P_L = P_g * u^nu)*)  
		rTiF_PowEst :  LREAL; (*filter time constant*)  
		bFilterOFF :  BOOL; (*turn off filter for power estimation*)  
		rTiFCorrUnom :  LREAL; (*filter time constant correction of nominal voltage*)  
		bCorrUnom :  BOOL; (*turn on correction of nominal voltage.*)  
	END_STRUCT;

	tGen2Para_PowCtrl :  STRUCT   
		rKp :  LREAL; (*Proportional gain power control*)  
		rKi :  LREAL; (*Intagrator gain power control*)  
		rKd :  LREAL; (*Derivative gain power control*)  
		rN :  LREAL; (*Filter constant power control*)  
		rLam_Start :  LREAL; (*power control initial condition*)  
		rKaw :  LREAL; (*Anti windup gain power control*)  
		rLam_Sr_Pos :  LREAL; (*upper rate limit for reference lambda (same as in safety layer of AS software)*)  
		rLam_Sr_Neg :  LREAL; (*Lower rate limit for reference lambda (same as in safety layer of AS software)*)  
		rLam_ff :  LREAL; (*Lambda feed forward*)  
		bActive_MbcFF :  BOOL; (*model based feed forward active*)  
	END_STRUCT;

	tGen2Para_PowCtrlGQCp2s :  STRUCT   
		rKp :  LREAL; (*Proportional gain power control*)  
		rKi :  LREAL; (*Intagrator gain power control*)  
		rKd :  LREAL; (*Derivative gain power control*)  
		rN :  LREAL; (*Filter constant power control*)  
		rLam_Start :  LREAL; (*power control initial condition*)  
		rKaw :  LREAL; (*Anti windup gain power control*)  
		rLam_Sr_Pos :  LREAL; (*upper rate limit for reference lambda (same as in safety layer of AS software)*)  
		rLam_Sr_Neg :  LREAL; (*Lower rate limit for reference lambda (same as in safety layer of AS software)*)  
		rLam_ff :  LREAL; (*Lambda feed forward*)  
		bActive_MbcFF :  BOOL; (*model based feed forward active*)  
		rPrP2sOffs_max_x :  ARRAY[0..5] OF LREAL; (*maximal boost pressure offset x: norm. Power [-]*)  
		rPrP2sOffs_max_y :  ARRAY[0..5] OF LREAL; (*maximal boost pressure offset y: [mbar]*)  
		rFactAW_aux :  LREAL; (*AW gain if boost pressure offset deactivated*)  
	END_STRUCT;

	tGen2Para_SkipF :  STRUCT   
		rNum_P0 :  LREAL; (*max. number of skipped cylinders*)  
		rP_0 :  LREAL; (*min engine power [kW]*)  
		rP_1 :  LREAL; (*engine power [kW] at which 0 cylinder skipping is reached *)  
		rN_Active_Lim :  LREAL; (*Level when skipfire starts [rpm]*)  
		rKp :  LREAL; (*proportional gain skipfire [Cyl/rpm]*)  
		rKp_lowN :  LREAL; (*proportional gain skipfire - low speed [Cyl/rpm]*)  
		rNum_reserve :  INT; (*number of cylinders as transient reserve*)  
		rTiF_Lam :  LREAL; (*time constant for control of lambda reference by skipfire*)  
		rP_max_0 :  LREAL; (*power at which full skipfire can be used [kW]*)  
		rP_max_1 :  LREAL; (*power at which skipfire should be stopped [kW]*)  
		rNum_max_P0 :  LREAL; (*max number of skipped cylinders at Max_N_skip_P0*)  
		rNum_max_P1 :  LREAL; (*max number of skipped cylinders at Max_N_skip_P1*)  
		rNum_max :  LREAL; (*max. number of skipped cylinders at low power to control speed*)  
		rTiF_Num :  LREAL; (*filter for skipfire (avoid chattering) [s]*)  
		rHy_eps :  LREAL; (*relay - deadband for skipfire [0.5 ... 0.99]*)  
		rTiF_stat :  LREAL; (*time const to estimate gradient of load [s]*)  
		rN_LevelNskip :  LREAL; (*deadband to activate skipfire +/- [rpm]*)  
		rN_LevelNskip_lowN :  LREAL; (*deadband to activate skipfire underspeed [rpm]*)  
		rLamRefSkip :  ARRAY[0..1] OF LREAL; (*lambda reference for skipfire control island*)  
		rPrefSkipNorm :  ARRAY[0..1] OF LREAL; (*normalized engine power below which lambda is controlled by skipfire*)  
		rKpTrackLam :  LREAL; (*proportional gain skipfire to track lamba command*)  
		bSFroundFB_ON :  BOOL; (*rounding function for feedback at overspeed*)  
		bSFroundFB_ON_lowN :  BOOL; (*rounding function for feedback at underspeed*)  
		rKiTrackLam :  LREAL; (*integral gain skipfire to track lamba command*)  
		bSF_ON :  BOOL; (*turn on skipfire control island mode (interaction with bSF_OFF_iLQR)*)  
		rThrsh_PulseGenerator_trigger :  LREAL; (*threshold for generating a skip pulse*)  
		rThrsh_PulseGenerator_reset :  LREAL; (*threshold for resetting the pulse generator*)  
		iNr_cycles_ignON :  INT; (*number of cycles ignition on between skip pulses*)  
		iNr_cycles_ignOFF :  INT; (*number of cycles ignition off*)  
		rKp_skiplevel :  LREAL; (*P gain for calculation of the skip level*)  
		rKd_skiplevel :  LREAL; (*D gain for calculation of the skip level*)  
		bSkipfire_pulse_active :  BOOL; (*Activation of pulsed skipfired*)  
		rN_limit_skip_off :  LREAL; (*lower bound for overspeed, if below: skipfire off*)  
		rN_limit_skip_on :  LREAL; (*upper bound for overspeed, if above: skipfire on*)  
		rProt_limit_skip_on :  LREAL; (*upper bound for rotational power, if above: skipfire on*)  
		rTi_StatSkipF_FiltP :  LREAL; (*[s] filter time constant power signal for static skipfire calculation*)  
		bStatSkipF_FiltP_active :  BOOL; (*activation power filter for static skipfire calculation*)  
	END_STRUCT;

	tGen2Para_SpeedCtrl :  STRUCT   
		bSwitch_SurgeLine_LIMIT :  BOOL; (*Switch on surge protection by surge line*)  
		rK_SurgeLine_LP :  LREAL; (*Gradient of LP compressor surge line*)  
		rA_SurgeLine_LP :  LREAL; (*Intercept of LP compressor surge line*)  
		rTi_CBV_SurgeProtec :  LREAL; (*filter constant for CBV position in the surge protection function*)  
		rTi_Prot :  LREAL; (*time constant for rotational power*)  
		rFactProt :  LREAL; (*factor to multiply Prot estimate to be used for LEANOX error*)  
		b2ndOrdFilt_N_Prot :  BOOL; (*switch 2nd order filter (true) vs. 1st order filter (false) for input signal*)  
		r2ndOrdFiltOmega_N_Prot :  LREAL; (*speed filter: constant - natural frequency*)  
		r2ndOrdFiltD_N_Prot :  LREAL; (*speed filter: constant - damping ratio*)  
		rTi_p2s_LEANOX :  LREAL; (*time constant for leanox reference*)  
		rFactKe_iLQR :  LREAL; (*iLQR engine gain correction factor [-]*)  
		rDeltaZZP_min_iLQR :  LREAL; (*iLQR max. offset ignition timing [&#xFFFD;]*)  
		rDeltaZZP_max_iLQR :  LREAL; (*iLQR min. offset ignition timing [&#xFFFD;]*)  
		bSF_OFF_iLQR :  BOOL; (*iLQR switch off skip fire*)  
		rThrsh_ss_int_iLQR :  LREAL; (*iLQR speed thrshold to activate tracking control [rpm]*)  
		rGain_ss_speed_iLQR :  LREAL; (*iLQR gain speed tracking control*)  
		rGain_ss_speed2boost_iLQR :  LREAL; (*iLQR gain speed tracking control using boost pressure ref*)  
		rGain_ss_boost_iLQR :  LREAL; (*iLQR gain boost tracking control*)  
		rGain_ss_Nskip_iLQR :  LREAL; (*iLQR gain skipfire tracking control*)  
		rGain_ss_LEANOX_iLQR :  LREAL; (*iLQR gain boost tracking - lambda Actuation*)  
		rGain_LEANOX_AW_iLQR :  LREAL; (*iLQR anti wind up - lambda Actuation *)  
		rN_DB_Lambda_act :  LREAL; (*dead band for lambda actuation [rpm]*)  
		rR_iLQR :  ARRAY[0..3] OF LREAL; (*iLQR spur of R matrix *)  
		rQ_iLQR :  ARRAY[0..2] OF LREAL; (*iLQR spur of Q matrix*)  
		iNiter_iLQR :  INT; (*iLQR number of iterations*)  
		iNiterRediLQR :  INT; (*iLQR number of iterations after first initialization*)  
		rK_it2_iLQR :  LREAL; (*iLQR gain ignition timing effect on torque [1/&#xFFFD;]*)  
		rK_slope_iLQR :  LREAL; (*iLQR boost dependency of slope [bar/s / bar]*)  
		rK_skip_iLQR :  LREAL; (*iLQR gain for skipfire actuation*)  
		bDelayON_iLQR :  BOOL; (*iLQR predictor feedback on*)  
		rKappa0_iLQR_x :  ARRAY[0..4] OF LREAL; (*boost pressure vect [bar]*)  
		rKappa0_iLQR_y :  ARRAY[0..4] OF LREAL; (*estimated slope of boost pressure [bar/s]*)  
		rInitSpeedCtrl_iLQR :  LREAL; (*initial value of integrator after transient*)  
		rTi_BDC_iLQR :  LREAL; (*time constant reference trajectory for speed controller FBL*)  
		rTi_Lam_iLQR :  LREAL; (*time constant estimate for lambda dynamic [s]*)  
		rD_iLQR :  LREAL; (*iLQR delay estimate [s]*)  
		rFactInertiaLQR :  LREAL; (*factor to multiply inertia parameter to tune response of LQR*)  
		bUseFilteredFeedback :  BOOL; (*switch to filtered feedback signals for speed control*)  
		bGS_Ke_iLQR :  BOOL; (*switch on gain scheduling for iLQR - engine gain*)  
		bGS_Kspeed_iLQR :  BOOL; (*switch on gain scheduling for iLQR - speed reference correction*)  
		bGS_T_Lam_iLQR :  BOOL; (*switch on gain scheduling for iLQR - lambda time constant*)  
		refPoint_iLQR_Kspeed_x :  ARRAY[0..6] OF LREAL; (*GainScheduling Reference X - speed gain iLQR*)  
		refPoint_iLQR_Keng_x :  ARRAY[0..12] OF LREAL; (*GainScheduling Reference X - engine gain iLQR*)  
		refPoint_iLQR_KengPOW_x :  ARRAY[0..6] OF LREAL; (*GainScheduling Reference X - engine gain iLQR (power dependent)*)  
		refPoint_iLQR_Tlam_x :  ARRAY[0..6] OF LREAL; (*GainScheduling Reference X - Tlambda iLQR*)  
		refPoint_iLQR_Kspeed_y :  ARRAY[0..6] OF LREAL; (*GainScheduling Reference Y - speed gain iLQR*)  
		refPoint_iLQR_Keng_y :  ARRAY[0..12] OF LREAL; (*GainScheduling Reference Y - engine gain iLQR*)  
		refPoint_iLQR_KengPOW_y :  ARRAY[0..6] OF LREAL; (*GainScheduling Reference Y - engine gain iLQR (power dependent)*)  
		refPoint_iLQR_Tlam_y :  ARRAY[0..6] OF LREAL; (*GainScheduling Reference Y - Tlambda iLQR*)  
		rMinPow_p2sGSC :  LREAL; (*switch between gain scheduling dependent on power and dependent on boost pressure*)  
		rDPr_Limit :  LREAL; (*boost pressure level difference (ref - act) to detect oad step [bar]*)  
		tOutOfNWindow :  LREAL; (*time for which gains of iLQR steady state tracking integrator are set to 0 and integrator is reset [s]*)  
		rOutOfNWindow :  LREAL; (*speed threshold to activate integrator reset [rpm]*)  
		rGain_ss_speed_iLQR_back :  LREAL; (*gain that is active to regulate speed whenever speed is between rOutOfNWindow and rThrsh_ss_int_iLQR*)  
		rPosValvethrshAW :  LREAL; (*threshold to activate AW for LEANOX in iLQR*)  
		bAW_iLQR_LEANOX :  BOOL; (*enable anti wind up for LEANOX in iLQR*)  
		rOutOfNWinHys :  LREAL; (*introduce hysteresis when choosing to reset integrators.*)  
		rTi_DPr_Limit :  LREAL; (*time constant to compute decay of locking reset after change of boost pressure reference. *)  
		rDPr_Limit_Thrsh :  LREAL; (*Threshold to lock bOutofNWindow - if boost pressure is close to reference.*)  
		rTi_LamCmd_iLQR :  LREAL; (*filter time constant for lambda command in steady state*)  
		rN_thrshFiltLam :  LREAL; (*threshold on Speed [rpm] to activate filtering of lambda command *)  
		bAddTi_Tlam :  BOOL; (*switch to add the filter time constant from lambda output to the time constant for lambda estimation.*)  
		rR_KF :  ARRAY[0..2] OF LREAL; (*kalman filter covariance spur of R*)  
		rQ_KF :  ARRAY[0..5] OF LREAL; (*kalman filter covariance spur of Q*)  
		rBd_KF :  ARRAY[0..2] OF LREAL; (*kalman filter gain spur of input disturbances*)  
		iNb_dist_KF :  INT; (*kalman filter number of disturbance states (possible: 1, 2, or 3)*)  
		bKF_p2s_dyn_SP_shift :  BOOL; (*use dynamic boost pressure setpoint shift, depending on boost pressure disturbance state*)  
		bKF_Lam_dyn_SP_shift :  BOOL; (*use dynamic lambda setpoint shift, depending on lambda disturbance state*)  
		bKF_GS_xdist1 :  BOOL; (*use gain scheduling for first disturbance state*)  
		bKF_x_dist1_AdaptON :  BOOL; (*adaption of  first disturbance state map: ON/OFF*)  
		refPoint_KF_x_dist1_x :  ARRAY[0..12] OF LREAL; (*GainScheduling Reference X - first disturbance state of kalman filter [bar]*)  
		refPoint_KF_x_dist1_y :  ARRAY[0..12] OF LREAL; (*GainScheduling Reference Y - first disturbance state of kalman filter*)  
		rT_x_dist1_map_update :  LREAL; (*periodic time between map update of first disturbance state during SS [s]*)  
		bKF_act :  BOOL; (*activate kalman filter method for steady state tracking (disturbance estimation)*)  
		bKF_calc :  BOOL; (*calculate the kalman filter to have the states available for debugging (override via bKF_act = true)*)  
		bKF_use_states :  BOOL; (*use the estimated kalman filter states for control (only valid if bKF_act = true)*)  
		bKF_constr_handling :  BOOL; (*constraint handling of lambda limits to ensure speed steady state accuracy*)  
		bKF_constr_handlLR :  BOOL; (*constraint handling lambda limits active during LR*)  
		bKF_KeNskip_Obs :  BOOL; (*use Nskip correction for Ke in observer only*)  
		bKF_use_Pg :  BOOL; (*use actual generator power for kalman filter prediction (instead of load estimation)*)  
		bPredFB_usePg :  BOOL; (*use actual generator power for LQR prediction feedback (instead of load estimation)*)  
		bKF_KeLearn_boost :  BOOL; (*activate Ke learning using  KF state 1, p2s-dependent*)  
		bKF_KeLearn_power :  BOOL; (*activate Ke learning using  KF state 1, power-dependent*)  
		bComModeLQR :  BOOL; (*activate comissioning mode for LQR*)  
		bComModeLQR_boost :  BOOL; (*reset integrator for boost pressure tracking*)  
		bTrackNbyLambda :  BOOL; (*use offset in lambda reference for speed tracking*)  
		bTrackNbyKe :  BOOL; (*use offset in Ke - estimate for speed tracking*)  
		rNdbLambdaKp :  LREAL; (*dead band for additive lambda proportional control  [rpm]*)  
		rGainLambdaKp :  LREAL; (*gain for additive lambda proportional control *)  
		rTiLambdaKp :  LREAL; (*time constant for additive lambda proportional control *)  
		bExternalOffsetON :  BOOL; (*use external lambda limit offset in LQR reference*)  
		bKeAdaptON :  BOOL; (*adaption of Ke map: ON/OFF*)  
		rKeAdaptEps :  LREAL; (*adaption of Ke map: update factor *)  
		rKeAdaptTon :  LREAL; (*adaption of Ke map: activation delay*)  
		rKeAdaptGain :  LREAL; (*adaption of Ke map: gain*)  
		rKeAdaptRL :  LREAL; (*adaption of Ke map: rate limit*)  
		refPoint_iLQR_RQT_x :  ARRAY[0..5] OF LREAL; (*boost reference gain scheduling Q0, R1; TBDC within LQR controller [bar]*)  
		refPoint_iLQR_R1_y :  ARRAY[0..5] OF LREAL; (*gain scheduling R1*)  
		bGS_iLQR_R1 :  BOOL; (*activate gain scheduling R1*)  
		refPoint_iLQR_Q0_y :  ARRAY[0..5] OF LREAL; (*gain scheduling Q0*)  
		bGS_iLQR_Q0 :  BOOL; (*activate gain scheduling Q0*)  
		refPoint_TBDC_y :  ARRAY[0..5] OF LREAL; (*gain scheduling TBDC within LQR*)  
		bGS_iLQR_TBDC :  BOOL; (*activate gain scheduling TBDC within LQR*)  
		refPoint_addKpLam_Kp_x :  ARRAY[0..5] OF LREAL; (*boost reference gain scheduling proportional gain additional enrichment [bar]*)  
		refPoint_addKpLam_Kp_y :  ARRAY[0..5] OF LREAL; (*gain scheduling proportional gain additional enrichment - Kp*)  
		refPoint_addKpLam_Ti_y :  ARRAY[0..5] OF LREAL; (*gain scheduling additional enrichment - Ti (time constant)*)  
		bGS_iLQR_addKpLam :  BOOL; (*activate gain scheduling additional enrichment*)  
		bAWLam_iLQR :  BOOL; (*activate anti wind up for Lambda limit*)  
		bAWLam_iLQR_uplim :  BOOL; (*activate anti wind up for upper Lambda limit*)  
		rGainLamUplim2boost :  LREAL; (*gain to move boost pressure reference in case of *)  
		bScaleLeanoxErrorEnrichment :  BOOL; (*switch on scaling of LEANOX error during enrichment to avoid shutdown.*)  
		rLSLff2load :  LREAL; (*gain for feedforward option from n_ref to load reference (load sharing line)*)  
		rLSLff2load_d :  LREAL; (*gain derivative term for n_ref to load reference*)  
		rTiF_LSLff_d :  LREAL; (*[s] filter time constant in derivative calculation n_ref to load reference*)  
		bLSLdeactNref :  BOOL; (*use n_nominal instead of n_ref *)  
		bSwitchOutputSampleSS :  BOOL; (*switch to sampled output only in steady state (TRUE: iOutputSample used if bSS. FALSE: iOutputSample always used).*)  
		iOutputSample :  INT; (*define zero order hold for in number of sample steps for LQR ouput*)  
		bSepEmisCtrl :  BOOL; (*separated emission control and Feedforward control in LQR*)  
		bRefSpeedLEANOX :  BOOL; (*use reference speed command instead of nominal for LEANOX*)  
		rff2load_Ext :  LREAL; (*factor for feedforward of load in GEN2 island*)  
		bffRefDroopMeasSpeed :  BOOL; (*switch to use measured speed instead of nominal speed to compute feedforward.*)  
		rLSLff2load_lim :  LREAL; (*limit for LSLfactor s.t. 1-lim <= rLSLff2load < 1+lim*)  
		bActKeEst2Dof :  BOOL; (*activate steady state estimator for Ke, 2DoF (map + estimator)*)  
		rTiFKeEst :  LREAL; (*Filter time constant for output of Ke estimator*)  
		bMeasPowKeEst :  BOOL; (*TRUE: measured power for Ke estimator; FALSE: power reference.*)  
		bffRefDroopFiltMeasSpd :  BOOL; (*if true: use filtered speed for feedforward of droop setpoint to load*)  
		rTiF_SpeedffRefDroop :  LREAL; (*filter time constant for speed in feedforward of droop setpoint to load [s]*)  
		bAddLSLfac :  BOOL; (*load sharing factor is added to Pest instead of multiplication*)  
		bActKeEstMapUpdate :  BOOL; (*Activate Keng Map update with steady state Ke estimate*)  
		rTiF_KeEstDiffMapUpdate :  LREAL; (*Filter time const. for Ke_est - Ke_map to update Map*)  
		rT_KeEstIncreaseTiF :  LREAL; (*duration [s] to increase rTiF_KeEstDiffMapUpdate by rTiF_KeEstIncrAfterTrans*)  
		rTiF_KeEstIncrAfterTrans :  LREAL; (*increase [s] of rTiFKeEstDiffMapUpdate after transients*)  
		rTp_KeEst_reset :  LREAL; (*[s] TP time for Ke Est Update to be reset when bOutOfNWindow is detected*)  
		bKeEstreset_TP :  BOOL; (*activate reset of Ke Estimator by TP*)  
		bKeEstResetOFF :  BOOL; (*Deactivate Ke estimator reset from transient detection*)  
		bKeEstIncreaseTiFOFF :  BOOL; (*Deactive Ke estimator update filter time increase from transient detection*)  
		bKeEstPause_SkipF :  BOOL; (*Ke Estimator update paused if cylinders skipped*)  
		rTof_KeEstPause_SkipF :  LREAL; (*[s] Tof time Ke estimator pause if iNskip > 0*)  
		bReset_LVRT_inputFilter :  BOOL; (*if true: the LP-filter to release input signals after LVRT event is on reset.*)  
		rFactorRilqr :  LREAL; (*factor multiplication of ilqr weighting matrix R, high: more robustness*)  
		bKeMap4KF :  BOOL; (*use Ke map w/o adaptation for kalman filter*)  
		bUseRgasEst :  BOOL; (*use Rgas estimation for Ke calculation*)  
		bGS_D_iLQR :  BOOL; (*use load dependent gain-scheduling for gas dosage delay*)  
		refPoint_iLQR_D_x :  ARRAY[0..5] OF LREAL; (*gas dosage delay, x-values: norm. Filtered power*)  
		refPoint_iLQR_D_y :  ARRAY[0..5] OF LREAL; (*gas dosage delay, y-values: delay in seconds*)  
	END_STRUCT;

	tGen2Para_bdcCbv :  STRUCT   
		rKp_Lup :  ARRAY[0..9] OF LREAL; (*CBV kp lookup table*)  
		rKp_island_Lup :  ARRAY[0..9] OF LREAL; (*CBV kp lookup table island mode*)  
		rKi_Lup :  ARRAY[0..9] OF LREAL; (*CBV ki lookup table*)  
		rKi_island_Lup :  ARRAY[0..9] OF LREAL; (*CBV ki lookup table island mode*)  
		rKi_island_reject_Lup :  ARRAY[0..9] OF LREAL; (*CBV ki lookup table island mode*)  
		bKi_island_reject :  BOOL; (*activate separate gains at overspeed for ki*)  
		rKaw :  LREAL; (*CBV anti wind-up gain [-]*)  
		rPos_min :  LREAL; (*Minimum CBV position [pu]*)  
		rPos_max :  LREAL; (*Maximum CBV position [pu]*)  
		bActive_ff :  BOOL; (*Activate feed forward*)  
		rPos_Start :  LREAL; (*initial condition*)  
		rDref :  LREAL; (*reference diameter of valve*)  
		rCd_vect_x :  ARRAY[0..10] OF LREAL; (*discharge coefficient x (opening angle)*)  
		rCd_vect_y :  ARRAY[0..10] OF LREAL; (*discharge coefficient y (Cd)*)  
		rRefCBVres_x :  ARRAY[0..4] OF LREAL; (*reference fraction massflow through compressor bypass x (boost pressure, [bar])*)  
		rRefCBVres_y :  ARRAY[0..4] OF LREAL; (*reference fraction massflow through compressor bypass y  [0-1]*)  
		bFFonly :  BOOL; (*Activate feedforward only for all CBV*)  
		bFFonly_2nd_CBV :  BOOL; (*Activate feedforward only for 2nd independent CBV*)  
		bFFonly_3rd_CBV :  BOOL; (*Activate feedforward only for 3rd independent CBV*)  
		rAW_lim_rej :  LREAL; (*limit o AW to avoid too agressefve reaction*)  
		bDynFFcbv_ON :  BOOL; (*turn on to use the filling dynamic part in feedforward*)  
		rRefCBVconvert_x :  ARRAY[0..4] OF LREAL; (*correction of position *)  
		rRefCBVconvert_y :  ARRAY[0..4] OF LREAL; (*correction of position *)  
		rGainMultRej_x :  ARRAY[0..4] OF LREAL; (*CBV gain scheduling for load rejections - x*)  
		rGainMultRej_y :  ARRAY[0..4] OF LREAL; (*CBV gain scheduling for load rejections - x*)  
		rKp_island_offset :  LREAL; (*global proportional gain offset*)  
		rKi_island_offset :  LREAL; (*global integral gain offset*)  
		rKp_grid_offset :  LREAL; (*global proportional gain offset*)  
		rKi_grid_offset :  LREAL; (*global integral gain offset*)  
		bFF_low_boost :  BOOL; (*enable feedforward for low boost pressure*)  
		bFF_overspeed :  BOOL; (*enable feeforward for overspeed*)  
		bCBVtracking2nd3rdCBV :  BOOL; (*track position of CBV (bTransWGctrl_FF MUST BE TRUE!)*)  
		rKiCBVtracking :  LREAL; (*gain for CBV tracking*)  
		rMaxErrCBVtracking :  LREAL; (*max. control error for CBV tracking [p.u.]*)  
		rRefCBVtracking :  LREAL; (*reference for CBV tracking [p.u.]*)  
	END_STRUCT;

	tGen2Para_bdcMisc :  STRUCT   
		rPr_Lup_in :  ARRAY[0..9] OF LREAL; (*x values for BDC lookup table [bar]*)  
		rTiF_Pr_p2s :  LREAL; (*Filter constant for p2s lookup [s]*)  
		bReset_Filter :  BOOL; (*Reset BDC Filter*)  
		bActive_BDC :  BOOL; (*Activate BDC*)  
		rKpSurgeProtectSL :  LREAL; (*proportional gain for surge avoidance (surge line approach)*)  
		rKiSurgeProtectSL :  LREAL; (*integral gain for surge avoidance (surge line approach)*)  
		rIntDischargeSurgeCtrl :  LREAL; (*constant to ramp down integrator after surge avoidance*)  
		rRefGainScheduleSL :  LREAL; (*Ref for linear ramp down of surge protection reaction with boost pressure [bar]. This value defines gain = 1*)  
		rMinLimSurgeline :  LREAL; (*set lower limit for surge protection [bar]*)  
		rPrSwitchFFmethod :  LREAL; (*activation level for FF Method 1 at TV and CBV. BELOW: Method 2. [bar]*)  
		rPrSwitchFFmethod_hys :  LREAL; (*hysteresis for activation level for FF Method 1/2 at TV and CBV. [bar]*)  
		rKpMin :  LREAL; (*minimum for Kp gains CBV and TV*)  
		rKpMax :  LREAL; (*maximum for Kp gains CBV and TV*)  
		rKiMin :  LREAL; (*minimum for Ki gains CBV and TV*)  
		rKiMax :  LREAL; (*maximum for Ki gains CBV and TV*)  
		bUnfilteredFeedback :  BOOL; (*switch to Un-filtered feedback signals for BDC*)  
		bSwitchOutputSampleSS :  BOOL; (*switch to sampled output only in steady state (TRUE: iOutputSample used if bSS. FALSE: iOutputSample always used).*)  
		iOutputSample :  INT; (*define zero order hold for in number of sample steps for BDC ouput*)  
		bUseNsetBDC :  BOOL; (*use speed setpoint instead of nominal speed for BDC*)  
	END_STRUCT;

	tGen2Para_bdcTv :  STRUCT   
		rKp_Lup :  ARRAY[0..9] OF LREAL; (*TV kp lookup table*)  
		rKp_island_Lup :  ARRAY[0..9] OF LREAL; (*TV kp lookup table island mode*)  
		rKi_Lup :  ARRAY[0..9] OF LREAL; (*TV ki lookup table*)  
		rKi_island_Lup :  ARRAY[0..9] OF LREAL; (*TV ki lookup table island mode*)  
		rKi_island_reject_Lup :  ARRAY[0..9] OF LREAL; (*TV ki lookup table island mode*)  
		bKi_island_reject :  BOOL; (*activate separate gains at overspeed for ki*)  
		rKaw :  LREAL; (*TV anti wind-up gain [-]*)  
		rPos_min :  LREAL; (*Minimum TV position [pu]*)  
		rPos_max :  LREAL; (*Maximum TV position [pu]*)  
		bActive_ff :  BOOL; (*Activate feed forward*)  
		rPos_Start :  LREAL; (*initial condition*)  
		rDref :  LREAL; (*reference diameter of valve*)  
		rCd_vect_x :  ARRAY[0..10] OF LREAL; (*discharge coefficient x (opening angle)*)  
		rCd_vect_y :  ARRAY[0..10] OF LREAL; (*discharge coefficient y (Cd)*)  
		bDynFFtv_ON :  BOOL; (*turn on to use the filling dynamic part in feedforward*)  
		rPosTv_Lin_x :  ARRAY[0..9] OF LREAL; (*throttle valve linearization x*)  
		rPosTv_Lin_y :  ARRAY[0..9] OF LREAL; (*throttle valve linearization y*)  
		rGainMultRej_x :  ARRAY[0..4] OF LREAL; (*TV gain scheduling for load rejections - x*)  
		rGainMultRej_y :  ARRAY[0..4] OF LREAL; (*TV gain scheduling for load rejections - x*)  
		rKp_island_offset :  LREAL; (*global proportional gain offset*)  
		rKi_island_offset :  LREAL; (*global integral gain offset*)  
		rKp_grid_offset :  LREAL; (*global proportional gain offset*)  
		rKi_grid_offset :  LREAL; (*global integral gain offset*)  
	END_STRUCT;

	tGen2Para_bdcWgv :  STRUCT   
		rKp :  LREAL; (*WGV controller proportional gain [-]*)  
		rKi :  LREAL; (*WGV controller integrator gain [-]*)  
		rKaw :  LREAL; (*WGV anti wind-up gain [-]*)  
		rPos_min :  LREAL; (*Minimum WGV position [pu]*)  
		rPos_max :  LREAL; (*Maximum WGV position [pu]*)  
		rDref :  LREAL; (*reference diameter of valve*)  
		rCd_vect_x :  ARRAY[0..10] OF LREAL; (*discharge coefficient x (opening angle)*)  
		rCd_vect_y :  ARRAY[0..10] OF LREAL; (*discharge coefficient y (Cd)*)  
		rRefWGVres_x :  ARRAY[0..4] OF LREAL; (*reference fraction massflow through wastegate x (boost pressure, [bar])*)  
		rRefWGVres_y :  ARRAY[0..4] OF LREAL; (*reference fraction massflow through wastegate y  [0-1]*)  
		bTransWGctrl_FF :  BOOL; (*turn on transient wastegate control feedforward*)  
		bWgvTcOvrspdCtrl :  BOOL; (*turn on TC overspeed avoidance by wastegate*)  
		rKpWgvTcOvrspdCtrl :  LREAL; (*proportional gain for TC overspeed avoidance*)  
		rKiWgvTcOvrspdCtrl :  LREAL; (*integral gain for TC overspeed avoidance*)  
		rIntDischargeTcOvrspedCtrl :  LREAL; (*constant to ramp down integrator to zero*)  
		rTcMaxSpeed :  LREAL; (*limit for turbocharger speed*)  
		bDynFFwgv_ON :  BOOL; (*turn on to use the filling dynamic part in feedforward*)  
		bCBVtracking :  BOOL; (*track position of CBV (bTransWGctrl_FF MUST BE TRUE!)*)  
		rKiCBVtracking :  LREAL; (*gain for CBV tracking*)  
		rKpCBVtracking :  LREAL; (*Kp for CBV tracking *)  
		rTi_TP_CBVtracking :  LREAL; (*time constant TP for CBV tracking [seconds]*)  
		rLimit_p2s_CBVtracking :  LREAL; (*Limit difference p2s and p2s_d [bar]*)  
		rMaxErrCBVtracking :  LREAL; (*max. control error for CBV tracking [p.u.]*)  
		rRefCBVtracking :  LREAL; (*reference for CBV tracking [p.u.]*)  
		bSensorP3 :  LREAL; (*is sensor for p3 available?*)  
	END_STRUCT;

	tGen2Para_eng :  STRUCT   
		rP_Nom :  LREAL; (*Rated Engine Power [kW]*)  
		rN_Nom :  LREAL; (*nominal engine speed*)  
		rP_Start_Norm :  LREAL; (*initial Power [pu]*)  
		rNum_Cyl_Eng :  LREAL; (*number of cylinders*)  
		rJ_Eng :  LREAL; (*Inertia Generator + Crankshaft*)  
		rVol_Hub_Eng :  LREAL; (*displacement volume (whole engine) [m3]*)  
		rVol_GM :  LREAL; (*Volume gas mixer and compressor [m3]*)  
		rVol_IC_LP :  LREAL; (*Volume intercooler LP [m3]*)  
		rVol_IC_HP :  LREAL; (*Volume intercooler HP [m3]*)  
		rVol_im :  LREAL; (*Engine intake manifold volume [m3]*)  
		rRho_gas :  LREAL; (*Standard gas density [kg/m3]*)  
		rRho_gas_M :  LREAL; (*Standard gas density  of gas art 3 [kg/m3]*)  
		rMin_Air_Ratio :  LREAL; (*Fuel stocheometric ratio [lit/lit]*)  
		rMin_Air_Ratio_M :  LREAL; (*Stocheometric ratio of gas art 3  [lit/lit]*)  
		rMin_Air_Ratio_kg :  LREAL; (*Fuel stocheometric ratio [kg/kg]*)  
		rMin_Air_Ratio_M_kg :  LREAL; (*Stocheometric ratio of gas art 3 [kg/kg]*)  
		rLHV :  LREAL; (*lower heating value [J/kg]*)  
		rLHV_M :  LREAL; (*lower heating value of gas art 3 [J/kg]*)  
		Ts :  LREAL; (*Sampling time controller [s]*)  
		bPI_engine :  BOOL; (*Port injection engine*)  
		bActive_MisfCtrl :  BOOL; (*Misfire controller ON for premixed engines*)  
		rNum_CBV :  LREAL; (*number of compressor bypass valves*)  
		rNum_TV :  LREAL; (*number of compressor throttle valve*)  
		rNum_WGV :  LREAL; (*number of compressor wastegate valve*)  
		rNum_TCperStage :  LREAL; (*number of parallel turbochargers per stage*)  
	END_STRUCT;

	tGen2Para_fdc :  STRUCT   
		bActive_dyn :  BOOL; (*FDC dynamic part enable*)  
		TiF_Pr_p1 :  LREAL; (*Time constant filter p1*)  
		TiF_Pr_p2_LP :  LREAL; (*Time constant filter p2 LP*)  
		TiF_Pr_p2_HP :  LREAL; (*Time constant filter p2 HP*)  
		TiF_Pr_p2s :  LREAL; (*Time constant filter p2s*)  
		rCF :  ARRAY[0..3] OF LREAL; (*Correction factor*)  
		bFiltdPresGasFlow :  BOOL; (*turn on filter for pressure signal in gas flow*)  
		bFiltdSpeedGasFlow :  BOOL; (*turn on filter for speed signal in gas flow*)  
		rTiF_Pr_p2s_GF :  LREAL; (*filter time constant for p2' in gas flow*)  
		rTiF_N_GF :  LREAL; (*filter time constant for rN_eng in gas flow*)  
		bActive_GasFlowStepLimit :  BOOL; (*limit step change of gas flow gas train active *)  
		r2ndOrdFiltOmegaSpeed :  LREAL; (*speed filter: constant - natural frequency*)  
		r2ndOrdFiltDSpeed :  LREAL; (*speed filter: constant - damping ratio*)  
		r2ndOrdFiltOmegaPressure :  LREAL; (*pressure filter: constant - natural frequency*)  
		r2ndOrdFiltDPressure :  LREAL; (*pressure filter: constant - damping ratio*)  
		bEnable2ndOrdFiltInputs :  BOOL; (*switch 2nd order filter (true) vs. 1st order filter (false) for input signal*)  
		bEnable2ndOrdFiltDerivative :  BOOL; (*switch 2nd order filter (true) vs. 1st order filter (false) for derivative computation*)  
		bEnableTransSwFilt :  BOOL; (*switch to 1st order filter during transient, otherwise 2nd order filter*)  
		rThrshSwTransFilt :  LREAL; (*threshold to swithc to first order filter during transient [bar]*)  
		bSwitchOutputSampleSS :  BOOL; (*switch to sampled output only in steady state (TRUE: iOutputSample used if bSS. FALSE: iOutputSample always used).*)  
		iOutputSample :  INT; (*define zero order hold for in number of sample steps for FDC ouput*)  
	END_STRUCT;

	tGen2Para_inFilt :  STRUCT   
		rTiF_Pr :  LREAL; (*Filter time constant pressure [s]*)  
		rTiF_T :  LREAL; (*Filter time constant temperature [s]*)  
		rTiF_P :  LREAL; (*Filter time constant power [s]*)  
		rTiF_V :  LREAL; (*Filter time constant voltage [s]*)  
		rTiF_N :  LREAL; (*Filter time constant speed [s]*)  
		rTiF_Ign :  LREAL; (*Filter time constant ignition [s]*)  
		rTiF_OUT :  LREAL; (*Filter time constant for outputs [s]*)  
		bFiltOutput :  BOOL; (*activate output filter for steady state*)  
	END_STRUCT;

	tGen2Para_leanox :  STRUCT   
		rPr_mbar_0 :  LREAL; (*Leanox line point 0 [mbar]*)  
		rPr_mbar_c :  LREAL; (*Leanox line point c [mbar]*)  
		rPr_mbar_1 :  LREAL; (*Leanox line point 1 [mbar]*)  
		rPr_mbar_2 :  LREAL; (*Leanox line point 2 [mbar]*)  
		rP_c :  LREAL; (*Leanox line point c [kW]*)  
		rP_1 :  LREAL; (*Leanox line point 1 [kW]*)  
		rP_2 :  LREAL; (*Leanox line point 2 [kW]*)  
		rT_c :  LREAL; (*Leanox line point c [K]*)  
		rT_1 :  LREAL; (*Leanox line point 1 [K]*)  
		rT_2 :  LREAL; (*Leanox line point 2 [K]*)  
		rN_c :  LREAL; (*Leanox line point c [rpm]*)  
		rN_1 :  LREAL; (*Leanox line point 1 [rpm]*)  
		rN_2 :  LREAL; (*Leanox line point 2 [rpm]*)  
		rP_Eng_Frict :  LREAL; (*Engine friction power [kW]*)  
		bZZPKorr :  BOOL; (*Leanox setpoint compensation ignition timing ON [-]*)  
		Comp_IgnP_x :  ARRAY[0..1] OF LREAL; (*Leanox setpoint compensation ignition timing x [kW]*)  
		Comp_IgnP_y :  ARRAY[0..1] OF LREAL; (*Leanox setpoint compensation ignition timing y [mbar/&#xFFFD;CA]*)  
		rP_P2sRedIP_SP_Norm :  LREAL; (*Leanox setpoint compensation ignition start power [pu]*)  
		bt2Korr :  BOOL; (*Leanox setpoint compensation t2s ON [-]*)  
		Comp_ChTmp_x :  ARRAY[0..1] OF LREAL; (*Leanox setpoint compensation t2s x [kW]*)  
		Comp_ChTmp_y :  ARRAY[0..1] OF LREAL; (*Leanox setpoint compensation t2s y [mbar/&#xFFFD;C]*)  
		rP2s_Comp_Act_SP :  LREAL; (*Leanox setpoint compensation t2s start power [pu]*)  
		bHum_Act :  BOOL; (*Humidity Leanox setpoint compensation ON [-]*)  
		rP2s_Comp_HumOffset :  LREAL; (*Humidity Leanox setpoint compensation [mbar]*)  
		rPr_Offset_Island :  LREAL; (*Leanox setpoint island offset [mbar]*)  
		bMeasuredSpeed :  BOOL; (*Measured speed feed into LEANOX*)  
		bWGKorr :  BOOL; (*Leanox setpoint compensation waste gate ON [-]*)  
		rTiF_WG :  LREAL; (*Filter constant of WG postion filter*)  
		Comp_WG_1_x :  ARRAY[0..9] OF LREAL; (*Leanox setpoint compensation WG x [-]*)  
		Comp_WG_1_y :  ARRAY[0..9] OF LREAL; (*Leanox setpoint compensation WG y [mbar]*)  
		Comp_WG_2_x :  ARRAY[0..9] OF LREAL; (*Leanox setpoint compensation WG x [-]*)  
		Comp_WG_2_y :  ARRAY[0..9] OF LREAL; (*Leanox setpoint compensation WG y [mbar]*)  
		rWG_1 :  LREAL; (*Leanox line point 1 [%]*)  
		rWG_2 :  LREAL; (*Leanox line point 2 [%]*)  
		bLp_c_Ena :  BOOL; (*LEANOX point at low load enabling switch parameter*)  
	END_STRUCT;

	tGen2Para_traj :  STRUCT   
		rPrR_TC_LP_min :  LREAL; (*Minimum total LP compression ratio*)  
		rPrR_TV_min :  LREAL; (*Minimal TV pressure ratio*)  
		rTiF_PrR_der :  LREAL; (*filter derivatives to BDC*)  
		rP_Ramp_IncGrad_Norm :  LREAL; (*gradient for increase of power ramp in grid mode  [pu/s]*)  
		rP_Ramp_DecGrad_Norm :  LREAL; (*gradient for decrease of power ramp in grid mode  [pu/s]*)  
		rP_Diff_Max_Norm :  LREAL; (*Maximum power ahead [pu]*)  
		rPr_p2s_Sr_Man :  LREAL; (*ramp rate p2s man [bar/s]*)  
		rTiF_Pr_p2s_Man :  LREAL; (*time const filter p2s man [s]*)  
		rTiFpowtraj :  LREAL; (*filter time constant power trajectory [s]*)  
		rTiF_P :  LREAL; (*filter time constant power [s]*)  
		rTiLEANOXman :  LREAL; (*time for transition between LEANOX manual <-> automatic *)  
		rPr_p2s_max :  LREAL; (*maximum allowed boost pressure [bar]*)  
		rPr_p2s_min :  LREAL; (*minimum allowed boost pressure [bar] at 0 load*)  
		rTVRes_EnableLimit :  LREAL; (*throttle valve power reserve enable limit depending on boost pressure*)  
		rTVRes_EnableHyst :  LREAL; (*throttle valve power reserve enable limit hysteresis depending on boost pressure*)  
		rTi_BDC :  LREAL; (*time constant reference trajectory*)  
		rTi_BDC_up :  LREAL; (*time constant reference trajectory rising [s]*)  
		rThrshSwTbdcUp :  LREAL; (*threshold to swithc to fast rTi_BDC_up [bar]*)  
		rPrR_delta_p2s :  LREAL; (*allowed offset for reference above p2' [bar]*)  
		rPr_delta_p2s_resetTVdp :  LREAL; (*allowed offset to trigger reset of throttle delta P in transients.*)  
		rPrR_deltaP_TV_x :  ARRAY[0..4] OF LREAL; (*reference pressure drop TV - X [bar]*)  
		rPrR_deltaP_TV_y :  ARRAY[0..4] OF LREAL; (*reference pressure drop TV - Y [bar]*)  
		rRateLimTVdpctrl :  ARRAY[0..4] OF LREAL; (*rate limit for reference of TVdp [bar/s]*)  
		rT_TON_TVdpCtrl :  LREAL; (*delay time before activation of TVdp ctrl [s]*)  
		rN_ssTVdpCtrl :  LREAL; (*speed steady state limit for TVdp ctrl [rpm]*)  
		rDPp2sCompON :  LREAL; (*thrshold to activate p2s compensation for steady state tracking [bar]*)  
		rTiFp2sComp :  LREAL; (*time constant to compensate the boost pressure reference [s]*)  
		bUseUnFilterComp :  BOOL; (*use un-filtered signal of difference between p2' and p2'_d to correct boost trajectory.*)  
		bResetCompTrans :  BOOL; (*activate reset of pressure compensation during transinet*)  
		rGainP2sComp :  LREAL; (*gain of integrator to correct boost pressure refrence when thottle is open.*)  
		rFactTi_BDC_CBV :  LREAL; (*factor of time contant for CBV ref (determines TV reaction for rejection)*)  
		rTi_RateLimRej :  LREAL; (*time to ramp down boost pressure reference at rejection [s]*)  
		rTi_RateLimRejCBV :  LREAL; (*time to ramp down boost pressure reference at rejection for CBV [s]*)  
		rPrDeltaMinRateLimRej :  LREAL; (*minimum pressure difference within specified rampdown time [bar]*)  
		rPrDeltaMinRateLimRejFF :  LREAL; (*minimum pressure difference within specified rampdown time for FF [bar]*)  
		bRateLimRejStepSizeDep :  BOOL; (*turn on rate limit with step size dependency*)  
		bRateLimRejON :  BOOL; (*turn on rate limit of ramp down during rejection*)  
		bRateLimRejCBV :  BOOL; (*turn on rate limit of ramp down during rejection for CBV*)  
		rNmaxRateLimRejON :  LREAL; (*max speed where rate limit of ramp down during rejection is active [rpm]*)  
		rPrTriggerRateLimRej :  LREAL; (*trigger to detect load rejection to switch on slew rate limit*)  
		rPrMinRefp2ff :  LREAL; (*minimum reference for p2 feedforward [bar]*)  
		bCBVrefFFonly :  BOOL; (*turn of speed control part for CBV (use only TV to control speed!)*)  
		rPrTriggerLargeRej :  LREAL; (*trigger to detect large load rejection to switch BDC time constant for CBV*)  
		rTi_BDC_rej_CBV :  LREAL; (*BDC time constant for CBV during large load rejection *)  
		rMinCbvAwTvDpCmp :  LREAL; (*threshold to activate anti wind up for integrator of p2s tracking with CBV*)  
		rMindpdtTvDpCmp :  LREAL; (*threshold to activate integrator of p2s tracking with CBV during transient (grid mode)*)  
		rOffs_WS_Actuators :  LREAL; (*Offset Worksplit Actuators*)  
		rRateResetTVdpctrl :  LREAL; (*slope to unload offset for throttle delta P during transient*)  
		bFactInitResetTVdp :  BOOL; (*choose initialization after reset*)  
		bLimitFFcmdTV :  BOOL; (*limit the throttle valve feedforward reference from below by load estimate*)  
		bLimitFFcmdCBV :  BOOL; (*limit the bypass valve feedforward reference from below by load estimate*)  
		bUseSpeedCtrlPd :  BOOL; (*Calculation of Pd outside HLCgrid to make Pd available for SpeedCtrl*)  
		rK_FSM_WO :  LREAL; (*FSM D-part: gain for washout filter step function (K=0: disabled)*)  
		rTi_FSM_WO_1 :  LREAL; (*FSM D-part: time constant [sec] for washout filter (derivative)*)  
		rTi_FSM_WO_2 :  LREAL; (*FSM D-part: time constant [sec] for washout filter (fade out)*)  
	END_STRUCT;

	tGen2Parameter :  STRUCT   
		eng :  tGen2Para_eng; (**)  
		leanox :  tGen2Para_leanox; (**)  
		traj :  tGen2Para_traj; (**)  
		EGTLim :  tGen2Para_EGTLim; (**)  
		ITC :  tGen2Para_ITC; (**)  
		SkipF :  tGen2Para_SkipF; (**)  
		LamLim :  tGen2Para_LamLim; (**)  
		bdcTv :  tGen2Para_bdcTv; (**)  
		bdcCbv :  tGen2Para_bdcCbv; (**)  
		bdcWgv :  tGen2Para_bdcWgv; (**)  
		bdcMisc :  tGen2Para_bdcMisc; (**)  
		PowCtrl :  tGen2Para_PowCtrl; (**)  
		PowCtrlGQCp2s :  tGen2Para_PowCtrlGQCp2s; (**)  
		fdc :  tGen2Para_fdc; (**)  
		SpeedCtrl :  tGen2Para_SpeedCtrl; (**)  
		LR :  tGen2Para_LR; (**)  
		LoadEst :  tGen2Para_LoadEst; (**)  
		inFilt :  tGen2Para_inFilt; (**)  
		Eff :  tGen2Para_Eff; (**)  
		KeEstNetP :  tGen2Para_KeEstNetP; (**)  
		GQC :  tGen2Para_GQC; (**)  
	END_STRUCT;

	tGen2Pr :  STRUCT   
		rp1LP :  REAL; (*LP compressor inlet pressure [bar]*)  
		rp1HP :  REAL; (*HP compressor inlet pressure [bar]*)  
		rp2HP :  REAL; (*HP intercooler outlet pressure (p2nGmk) [bar]*)  
		rp2s :  REAL; (*Intake manifold pressure [bar]*)  
		rp3HP :  REAL; (*HP turbine inlet pressure [bar]*)  
		rp3LP :  REAL; (*LP turbine inlet pressure [bar]*)  
		rp4LP :  REAL; (*LP turbine outlet pressure [bar]*)  
	END_STRUCT;

	tGen2Temp :  STRUCT   
		rT1LP :  REAL; (*LP compressor inlet temperature [&#xFFFD;C]*)  
		rT1HP :  REAL; (*HP compressor inlet temperature [&#xFFFD;C]*)  
		rT2HP :  REAL; (*HP compressor outlet temperature [&#xFFFD;C]*)  
		rT2s :  REAL; (*Intake manifold temperature [&#xFFFD;C]*)  
		rT3HP :  REAL; (*HP turbine inlet temperature [&#xFFFD;C]*)  
		rT3LP :  REAL; (*LP turbine inlet temperature [&#xFFFD;C]*)  
		rT4LP :  REAL; (*LP turbine outlet temperature [&#xFFFD;C]*)  
		rTcylMax :  REAL; (*Highest actual exhaust temperature among all cylinders [&#xFFFD;C]*)  
		rTcylAvg :  REAL; (*Average exhaust temperature among all cylinders [&#xFFFD;C]*)  
	END_STRUCT;

	tGen2dbgFDC_Filtering :  STRUCT   
		p2s_raw :  REAL; (**)  
		p2s_1stOrd :  REAL; (**)  
		p2s_2ndOrd :  REAL; (**)  
		ne_raw :  REAL; (**)  
		ne_1stOrd :  REAL; (**)  
		ne_2ndOrd :  REAL; (**)  
		p2s_in :  REAL; (**)  
		ne_in :  REAL; (**)  
		Ratio1stOrd :  REAL; (**)  
		Ratio2ndOrd :  REAL; (**)  
	END_STRUCT;

	tGen2dbgFDC_GasArt1and2 :  STRUCT   
		rdpdt :  ARRAY[0..3] OF REAL; (**)  
		rmdot_mix_dyn :  ARRAY[0..3] OF REAL; (**)  
		mdot_dyn :  REAL; (**)  
		mdot_set :  REAL; (**)  
		mdot_ss :  REAL; (**)  
		rFactCompLR :  REAL; (*compensation factor gasflow for large load rejections*)  
		Rgas12 :  REAL; (**)  
	END_STRUCT;

	tGen2dbgFDC_GasArt3 :  STRUCT   
		rmdot_mix_dyn_M :  ARRAY[0..3] OF REAL; (**)  
		mdot_dyn_M :  REAL; (**)  
		mdot_set_M :  REAL; (**)  
		mdot_ss_M :  REAL; (**)  
		Rgas3 :  REAL; (**)  
	END_STRUCT;

END_TYPE

TYPE
rtB_Filter1_Gen2_ref : STRUCT
	Switch1 : LREAL;
END_STRUCT;
rtDW_Filter1_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_TON_1_Gen2_ref : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON_1_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_Filter3_Gen2_ref : STRUCT
	Switch : LREAL;
END_STRUCT;
rtDW_Filter3_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_MATLABFunction_Gen2_ref : STRUCT
	y : LREAL;
END_STRUCT;
rtDW_MATLABFunction_Gen2_ref : STRUCT
	out : LREAL;
END_STRUCT;
rtB_enginemassflow_Gen2_ref : STRUCT
	dm_e : LREAL;
END_STRUCT;
rtB_IntegerZOH_Gen2_ref : STRUCT
	y : LREAL;
END_STRUCT;
rtDW_IntegerZOH_Gen2_ref : STRUCT
	count : LREAL;
	u_z : LREAL;
	count_not_empty : BOOL;
END_STRUCT;
rtB_lam2cg1_Gen2_ref : STRUCT
	Divide : LREAL;
END_STRUCT;
rtB_enginemassflow2_Gen2_ref : STRUCT
	dm_e : LREAL;
END_STRUCT;
rtB_Inverse_Linearization4_Gen2 : STRUCT
	LCRScal_Lam_EOT1 : LREAL;
END_STRUCT;
rtB_N_TC_HP_filt_Gen2_ref : STRUCT
	Switch : LREAL;
END_STRUCT;
rtDW_N_TC_HP_filt_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_Mg_Gen2_ref : STRUCT
	Bias : LREAL;
END_STRUCT;
rtB_lam2cg1_Gen2_ref_i : STRUCT
	Divide : LREAL;
END_STRUCT;
rtB_FILTERnodelay_Gen2_ref : STRUCT
	y : LREAL;
	d_dt : LREAL;
END_STRUCT;
rtDW_FILTERnodelay_Gen2_ref : STRUCT
	x : LREAL;
	x_not_empty : BOOL;
END_STRUCT;
rtB_undOrderFilter_Gen2_ref : STRUCT
	Switch1 : LREAL;
END_STRUCT;
rtDW_undOrderFilter_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator1_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator1_PrevRes : SINT;
	DiscreteTimeIntegrator1_IC_LOAD : USINT;
END_STRUCT;
rtB_undOrderFilter3_Gen2_ref : STRUCT
	Switch : LREAL;
	Switch1 : LREAL;
END_STRUCT;
rtDW_undOrderFilter3_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator1_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator1_PrevRes : SINT;
	DiscreteTimeIntegrator1_IC_LOAD : USINT;
END_STRUCT;
rtB_TOF_Gen2_ref : STRUCT
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TOF_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_upointinterpolationwithextr : STRUCT
	y : LREAL;
END_STRUCT;
rtB_MATLABFunction_Gen2_ref_k : STRUCT
	Y0Out : LREAL;
	ireset : BOOL;
END_STRUCT;
rtDW_MATLABFunction_Gen2_ref_f : STRUCT
	Y0OutTemp : LREAL;
	Y0OutTemp_not_empty : BOOL;
END_STRUCT;
rtB_MATLABFunction1_Gen2_ref : STRUCT
	LamOut : LREAL;
END_STRUCT;
rtDW_MATLABFunction1_Gen2_ref : STRUCT
	LamFix : LREAL;
	LamFix_not_empty : BOOL;
END_STRUCT;
rtB_Pd_filt_Gen2_ref : STRUCT
	Switch : LREAL;
END_STRUCT;
rtDW_Pd_filt_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_TP_Gen2_ref : STRUCT
	Merge : LREAL;
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TP_Gen2_ref : STRUCT
	DelayInput2_DSTATE : LREAL;
	UnitDelay2_DSTATE : BOOL;
END_STRUCT;
rtB_TOF_Gen2_ref_j : STRUCT
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TOF_Gen2_ref_f : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_TP_ActSat_CBV_Gen2_ref : STRUCT
	Merge : LREAL;
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TP_ActSat_CBV_Gen2_ref : STRUCT
	DelayInput2_DSTATE : LREAL;
	UnitDelay2_DSTATE : BOOL;
END_STRUCT;
rtB_MATLABFunction_Gen2_ref_o : STRUCT
	y : LREAL;
END_STRUCT;
rtDW_MATLABFunction_Gen2_ref_k : STRUCT
	y_z : LREAL;
END_STRUCT;
rtB_Filter_Gen2_ref : STRUCT
	Switch : LREAL;
END_STRUCT;
rtDW_Filter_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_KeMapUpdate_Gen2_ref : STRUCT
	Sum1 : LREAL;
END_STRUCT;
rtDW_KeMapUpdate_Gen2_ref : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_MATLABFunction1_Gen2_ref_h : STRUCT
	y_map_new : ARRAY[0..12] OF LREAL;
END_STRUCT;
rtDW_MATLABFunction1_Gen2_ref_c : STRUCT
	y_map : ARRAY[0..12] OF LREAL;
	x_map : ARRAY[0..12] OF LREAL;
	y_map_not_empty : BOOL;
END_STRUCT;
BlockIO_Gen2_ref : STRUCT
	BusInput3 : tGen2Parameter;
	BusInput : tGen2In;
	In1 : LREAL;
	Sum : LREAL;
	Merge : LREAL;
	UnitDelay : UDINT;
	Input1 : REAL;
	DataTypeConversion1 : REAL;
	TON2 : rtB_TON_1_Gen2_ref;
	TON1_n : rtB_TON_1_Gen2_ref;
	TON_l : rtB_TON_1_Gen2_ref;
	Filter3_f : rtB_Filter3_Gen2_ref;
	Filter2_o : rtB_Filter3_Gen2_ref;
	Filter1_ny : rtB_Filter3_Gen2_ref;
	Filter_f : rtB_Filter3_Gen2_ref;
	sf_MATLABFunction_i : rtB_MATLABFunction_Gen2_ref_o;
	Filter1_l : rtB_Filter3_Gen2_ref;
	Filter_mn : rtB_Filter3_Gen2_ref;
	Pd_filt_p : rtB_Pd_filt_Gen2_ref;
	Filter1_fj : rtB_N_TC_HP_filt_Gen2_ref;
	Filter_l : rtB_Pd_filt_Gen2_ref;
	TP1_l : rtB_TP_Gen2_ref;
	TP_g : rtB_TP_Gen2_ref;
	TON1_m : rtB_TON_1_Gen2_ref;
	TOF_n : rtB_TOF_Gen2_ref;
	sf_MATLABFunction1_l : rtB_MATLABFunction1_Gen2_ref_h;
	KeMapUpdate_h : rtB_KeMapUpdate_Gen2_ref;
	Filter1_n : rtB_N_TC_HP_filt_Gen2_ref;
	Filter1_p : rtB_Filter3_Gen2_ref;
	Filter_kj : rtB_Pd_filt_Gen2_ref;
	p2sfilt_l : rtB_N_TC_HP_filt_Gen2_ref;
	sf_2pointinterpolationwithex_je : rtB_upointinterpolationwithextr;
	sf_2pointinterpolationwithext_a : rtB_upointinterpolationwithextr;
	TON_d : rtB_TON_1_Gen2_ref;
	Filter_bd : rtB_Pd_filt_Gen2_ref;
	TON_j : rtB_TON_1_Gen2_ref;
	TON_m : rtB_TON_1_Gen2_ref;
	TON_o : rtB_TON_1_Gen2_ref;
	Filter_m : rtB_Filter_Gen2_ref;
	TON_c : rtB_TON_1_Gen2_ref;
	DelayRetard : rtB_TON_1_Gen2_ref;
	sf_MATLABFunction_kd : rtB_MATLABFunction_Gen2_ref_o;
	Filter_pj : rtB_Filter3_Gen2_ref;
	TP1_c : rtB_TP_Gen2_ref;
	TP_p2 : rtB_TP_Gen2_ref;
	TON1 : rtB_TON_1_Gen2_ref;
	TOF_g : rtB_TOF_Gen2_ref;
	sf_MATLABFunction1_m : rtB_MATLABFunction1_Gen2_ref_h;
	KeMapUpdate : rtB_KeMapUpdate_Gen2_ref;
	Filter_nk : rtB_Filter_Gen2_ref;
	Filter_b : rtB_Filter3_Gen2_ref;
	sf_FILTERnodelay_b : rtB_FILTERnodelay_Gen2_ref;
	Filter1_o : rtB_N_TC_HP_filt_Gen2_ref;
	sf_MATLABFunction1_e : rtB_MATLABFunction_Gen2_ref_o;
	sf_MATLABFunction_k : rtB_MATLABFunction_Gen2_ref_o;
	SkipPulseWaitTP : rtB_TP_Gen2_ref;
	sf_MATLABFunction_n : rtB_MATLABFunction_Gen2_ref_o;
	Filter1_fg : rtB_N_TC_HP_filt_Gen2_ref;
	Filter_n : rtB_Filter3_Gen2_ref;
	TP_Misfire_ON_2ndtime : rtB_TP_ActSat_CBV_Gen2_ref;
	TP_Misfire_ON : rtB_TP_ActSat_CBV_Gen2_ref;
	TP_Misfire_OFF2 : rtB_TP_ActSat_CBV_Gen2_ref;
	TP_Misfire_OFF1 : rtB_TP_ActSat_CBV_Gen2_ref;
	TP_Misfire_OFF : rtB_TP_ActSat_CBV_Gen2_ref;
	TP_Ignretard : rtB_TP_ActSat_CBV_Gen2_ref;
	TP_ActSat_TV : rtB_TP_ActSat_CBV_Gen2_ref;
	TP_ActSat_CBV : rtB_TP_ActSat_CBV_Gen2_ref;
	TP_p : rtB_TP_Gen2_ref;
	TOF3 : rtB_TOF_Gen2_ref;
	TOF2_d : rtB_TOF_Gen2_ref_j;
	TOF1_o : rtB_TOF_Gen2_ref;
	TOF_c : rtB_TOF_Gen2_ref_j;
	TP1 : rtB_TP_Gen2_ref;
	TP : rtB_TP_Gen2_ref;
	TOF_h : rtB_TOF_Gen2_ref;
	speedFilter : rtB_N_TC_HP_filt_Gen2_ref;
	Filter1_f : rtB_Filter1_Gen2_ref;
	sf_2pointinterpolationwithext_o : rtB_upointinterpolationwithextr;
	sf_2pointinterpolationwithext_j : rtB_upointinterpolationwithextr;
	sf_IntegerZOH_g : rtB_IntegerZOH_Gen2_ref;
	Filter_k : rtB_Pd_filt_Gen2_ref;
	undOrderFilter_j : rtB_undOrderFilter3_Gen2_ref;
	p2sfilt_b : rtB_N_TC_HP_filt_Gen2_ref;
	p2sfilt : rtB_N_TC_HP_filt_Gen2_ref;
	WO2 : rtB_Filter3_Gen2_ref;
	WO1 : rtB_Filter1_Gen2_ref;
	Pd_filt : rtB_Pd_filt_Gen2_ref;
	sf_MATLABFunction1_ep : rtB_MATLABFunction1_Gen2_ref;
	sf_MATLABFunction_a : rtB_MATLABFunction_Gen2_ref_k;
	sf_MATLABFunction1_h : rtB_MATLABFunction1_Gen2_ref;
	sf_MATLABFunction_g : rtB_MATLABFunction_Gen2_ref_k;
	sf_2pointinterpolationwithext_d : rtB_upointinterpolationwithextr;
	sf_2pointinterpolationwithextra : rtB_upointinterpolationwithextr;
	TON : rtB_TON_1_Gen2_ref;
	TOF2 : rtB_TOF_Gen2_ref;
	TOF1 : rtB_TOF_Gen2_ref;
	TOF : rtB_TOF_Gen2_ref;
	undOrderFilter3 : rtB_undOrderFilter3_Gen2_ref;
	undOrderFilter2 : rtB_undOrderFilter_Gen2_ref;
	undOrderFilter1 : rtB_undOrderFilter_Gen2_ref;
	undOrderFilter : rtB_undOrderFilter_Gen2_ref;
	sf_FILTERnodelay5 : rtB_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay4 : rtB_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay3 : rtB_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay2 : rtB_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay1 : rtB_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay : rtB_FILTERnodelay_Gen2_ref;
	sf_IntegerZOH1_n : rtB_IntegerZOH_Gen2_ref;
	sf_IntegerZOH_f : rtB_IntegerZOH_Gen2_ref;
	lam2cg1_i : rtB_lam2cg1_Gen2_ref_i;
	lam2cg_i : rtB_lam2cg1_Gen2_ref;
	Mg_l : rtB_Mg_Gen2_ref;
	lam2cg1_a : rtB_lam2cg1_Gen2_ref_i;
	lam2cg : rtB_lam2cg1_Gen2_ref;
	Mg : rtB_Mg_Gen2_ref;
	p4LP_filt : rtB_N_TC_HP_filt_Gen2_ref;
	p3LP_filt_e : rtB_N_TC_HP_filt_Gen2_ref;
	p2s_filt : rtB_N_TC_HP_filt_Gen2_ref;
	p2HP_filt : rtB_N_TC_HP_filt_Gen2_ref;
	p1HP_filt : rtB_N_TC_HP_filt_Gen2_ref;
	Volt_filt : rtB_N_TC_HP_filt_Gen2_ref;
	T2s_filt : rtB_N_TC_HP_filt_Gen2_ref;
	T1LP_filt : rtB_N_TC_HP_filt_Gen2_ref;
	T1HP_filt : rtB_N_TC_HP_filt_Gen2_ref;
	Pel_filt : rtB_N_TC_HP_filt_Gen2_ref;
	N_TC_LP_filt_f : rtB_N_TC_HP_filt_Gen2_ref;
	N_TC_LP_filt : rtB_N_TC_HP_filt_Gen2_ref;
	N_TC_HP_filt : rtB_N_TC_HP_filt_Gen2_ref;
	sf_enginemassflow1_e : rtB_enginemassflow2_Gen2_ref;
	sf_enginemassflow_h : rtB_enginemassflow_Gen2_ref;
	Inverse_Linearization2 : rtB_Inverse_Linearization4_Gen2;
	Inverse_Linearization3 : rtB_Inverse_Linearization4_Gen2;
	Inverse_Linearization1 : rtB_Inverse_Linearization4_Gen2;
	Inverse_Linearization4 : rtB_Inverse_Linearization4_Gen2;
	sf_enginemassflow2 : rtB_enginemassflow2_Gen2_ref;
	lam2cg1 : rtB_lam2cg1_Gen2_ref;
	Filter : rtB_Filter3_Gen2_ref;
	sf_IntegerZOH2 : rtB_IntegerZOH_Gen2_ref;
	sf_IntegerZOH : rtB_IntegerZOH_Gen2_ref;
	sf_enginemassflow : rtB_enginemassflow_Gen2_ref;
	sf_MATLABFunction_e : rtB_MATLABFunction_Gen2_ref;
	sf_MATLABFunction_f : rtB_MATLABFunction_Gen2_ref;
	Filter3 : rtB_Filter3_Gen2_ref;
	TON_1 : rtB_TON_1_Gen2_ref;
	Filter4 : rtB_Filter1_Gen2_ref;
	Filter2 : rtB_Filter1_Gen2_ref;
	Filter1 : rtB_Filter1_Gen2_ref;
END_STRUCT;
D_Work_Gen2_ref : STRUCT
	Delay_DSTATE : ARRAY[0..29] OF LREAL;
	Delay_DSTATE_o : ARRAY[0..5] OF LREAL;
	DiscreteTimeIntegrator_DSTATE : LREAL;
	Delay_DSTATE_n : LREAL;
	Delay_DSTATE_oh : LREAL;
	Delay_DSTATE_g : LREAL;
	ResettableDelay_DSTATE : LREAL;
	Delay4_DSTATE : LREAL;
	Delay3_DSTATE : LREAL;
	Delay1_DSTATE : ARRAY[0..2] OF LREAL;
	Delay2_DSTATE : LREAL;
	UnitDelay1_DSTATE : LREAL;
	DiscreteTimeIntegrator_DSTATE_h : LREAL;
	Delay_DSTATE_b : LREAL;
	UnitDelay2_DSTATE : LREAL;
	DiscreteTimeIntegrator_DSTATE_m : LREAL;
	DiscreteTimeIntegrator_DSTATE_p : LREAL;
	DiscreteTimeIntegrator_DSTATE_d : LREAL;
	ResettableDelay2_DSTATE : LREAL;
	ResettableDelay_DSTATE_l : LREAL;
	UnitDelay_DSTATE : LREAL;
	DiscreteTimeIntegrator_DSTATE_c : LREAL;
	DiscreteTimeIntegrator_DSTATE_k : LREAL;
	DiscreteTimeIntegrator4_DSTATE : LREAL;
	DiscreteTimeIntegrator1_DSTATE : LREAL;
	ResettableDelay_DSTATE_i : LREAL;
	VariableIntegerDelay_DSTATE : ARRAY[0..199] OF LREAL;
	UnitDelay1_DSTATE_a : LREAL;
	Delay_DSTATE_k : LREAL;
	ResettableDelay_DSTATE_a : ARRAY[0..12] OF LREAL;
	UnitDelay1_DSTATE_e : LREAL;
	ResettableDelay1_DSTATE : ARRAY[0..12] OF LREAL;
	ResettableDelay_DSTATE_m : ARRAY[0..12] OF LREAL;
	DiscreteTimeIntegrator_DSTATE_l : LREAL;
	ResettableDelay1_DSTATE_e : ARRAY[0..6] OF LREAL;
	ResettableDelay_DSTATE_e : ARRAY[0..6] OF LREAL;
	DiscreteTimeIntegrator_DSTATE_e : LREAL;
	DiscreteTimeIntegrator3_DSTATE : LREAL;
	DiscreteTimeIntegrator2_DSTATE : LREAL;
	Delay_DSTATE_ba : ARRAY[0..3] OF LREAL;
	DiscreteTimeIntegrator_DSTAT_h5 : LREAL;
	UnitDelay_DSTATE_f : LREAL;
	UnitDelay2_DSTATE_m : LREAL;
	UnitDelay1_DSTATE_f : ARRAY[0..12] OF LREAL;
	UnitDelay3_DSTATE : LREAL;
	UnitDelay4_DSTATE : LREAL;
	UnitDelay1_DSTATE_ek : LREAL;
	UnitDelay2_DSTATE_h : ARRAY[0..3] OF LREAL;
	DiscreteTimeIntegrator_DSTATE_a : LREAL;
	VariableIntegerDelay_DSTATE_b : ARRAY[0..299] OF LREAL;
	UnitDelay_DSTATE_e : LREAL;
	Delay_DSTATE_ko : LREAL;
	Delay_DSTATE_j : LREAL;
	Delay_DSTATE_m : LREAL;
	Delay_DSTATE_d : LREAL;
	VariableIntegerDelay_DSTATE_e : ARRAY[0..299] OF LREAL;
	UnitDelay_DSTATE_d : LREAL;
	Delay_DSTATE_g2 : LREAL;
	Delay_DSTATE_dm : LREAL;
	Delay_DSTATE_jl : LREAL;
	Delay_DSTATE_h : LREAL;
	Delay_DSTATE_c : LREAL;
	Delay_DSTATE_i : LREAL;
	DiscreteTimeIntegrator_DSTAT_ac : LREAL;
	DiscreteTimeIntegrator_DSTATE_g : LREAL;
	UnitDelay1_DSTATE_ed : LREAL;
	Delay_DSTATE_cn : LREAL;
	Delay1_DSTATE_l : LREAL;
	Delay_DSTATE_gp : LREAL;
	DiscreteTimeIntegrator1_DSTAT_n : LREAL;
	UnitDelay5_DSTATE : LREAL;
	UnitDelay_DSTATE_i : LREAL;
	DiscreteTimeIntegrator_DSTATE_j : LREAL;
	UnitDelay6_DSTATE : LREAL;
	UnitDelay1_DSTATE_c : LREAL;
	Delay_DSTATE_hq : LREAL;
	Delay_DSTATE_ow : LREAL;
	DiscreteTimeIntegrator_DSTAT_ja : LREAL;
	UnitDelay2_DSTATE_d : LREAL;
	UnitDelay3_DSTATE_g : LREAL;
	UnitDelay_DSTATE_b : LREAL;
	Delay_DSTATE_f : LREAL;
	DiscreteTimeIntegrator_DSTATE_i : LREAL;
	Delay_DSTATE_l : LREAL;
	UnitDelay6_DSTATE_m : LREAL;
	Delay_DSTATE_p : LREAL;
	Delay_DSTATE_i4 : LREAL;
	ResettableDelay_DSTATE_k : ARRAY[0..12] OF LREAL;
	UnitDelay1_DSTATE_n : LREAL;
	UnitDelay1_DSTATE_eq : LREAL;
	UnitDelay2_DSTATE_di : LREAL;
	UnitDelay_DSTATE_dk : LREAL;
	UnitDelay1_DSTATE_b : LREAL;
	UnitDelay2_DSTATE_k : LREAL;
	UnitDelay3_DSTATE_m : LREAL;
	UnitDelay_DSTATE_m : LREAL;
	UnitDelay1_DSTATE_c2 : LREAL;
	UnitDelay2_DSTATE_p : LREAL;
	UnitDelay3_DSTATE_h : LREAL;
	UnitDelay_DSTATE_fm : LREAL;
	DiscreteTimeIntegrator_DSTATE_n : LREAL;
	DiscreteTimeIntegrator_DSTAT_gl : ARRAY[0..5] OF LREAL;
	DiscreteTimeIntegrator_DSTAT_eh : LREAL;
	DiscreteTimeIntegrator_DSTATE_b : LREAL;
	Delay_DSTATE_h4 : LREAL;
	DiscreteTimeIntegrator1_DSTAT_m : LREAL;
	Delay2_DSTATE_h : LREAL;
	DiscreteTimeIntegrator_DSTAT_hn : LREAL;
	Delay_DSTATE_fo : LREAL;
	DiscreteTimeIntegrator1_DSTA_nh : LREAL;
	Delay2_DSTATE_o : LREAL;
	DiscreteTimeIntegrator_DSTATE_f : LREAL;
	Delay_DSTATE_dj : LREAL;
	DiscreteTimeIntegrator_DSTAT_ic : LREAL;
	DiscreteTimeIntegrator1_DSTAT_h : LREAL;
	DiscreteTimeIntegrator_DSTAT_gw : LREAL;
	DelayInput2_DSTATE : LREAL;
	DiscreteTimeIntegrator_DSTAT_iq : LREAL;
	Memory_PreviousInput : LREAL;
	PFix : LREAL;
	x : ARRAY[0..7] OF LREAL;
	x_h : LREAL;
	x_d : LREAL;
	y_map : ARRAY[0..12] OF LREAL;
	x_map : ARRAY[0..12] OF LREAL;
	y_map_i : ARRAY[0..6] OF LREAL;
	x_map_c : ARRAY[0..6] OF LREAL;
	y_map_f : ARRAY[0..12] OF LREAL;
	x_map_n : ARRAY[0..12] OF LREAL;
	P : ARRAY[0..8] OF LREAL;
	P_2inp_aug : ARRAY[0..35] OF LREAL;
	u2_past : ARRAY[0..99] OF LREAL;
	count : LREAL;
	x_KF : ARRAY[0..5] OF LREAL;
	P_KF : ARRAY[0..35] OF LREAL;
	y_z : LREAL;
	PFix_g : LREAL;
	err_1 : LREAL;
	count_p : LREAL;
	u_z : ARRAY[0..2] OF LREAL;
	err_1_a : LREAL;
	x0 : LREAL;
	x1 : LREAL;
	x2 : LREAL;
	x3 : LREAL;
	x4 : LREAL;
	x_e : LREAL;
	UnitDelay_DSTATE_mg : REAL;
	UnitDelay_DSTATE_j : UDINT;
	CircBufIdx : UINT;
	TOF_state : BOOL;
	Delay6_DSTATE : BOOL;
	UnitDelay4_DSTATE_d : BOOL;
	UnitDelay_DSTATE_k : BOOL;
	ResettableDelay3_DSTATE : BOOL;
	UnitDelay2_DSTATE_d2 : BOOL;
	UnitDelay2_DSTATE_n : BOOL;
	UnitDelay1_DSTATE_o : BOOL;
	UnitDelay1_DSTATE_j : BOOL;
	UnitDelay_DSTATE_ma : BOOL;
	Delaytoavoidalgloop_DSTATE : BOOL;
	TP_state : BOOL;
	DelayInput1_DSTATE : BOOL;
	DelayInput1_DSTATE_n : BOOL;
	UnitDelay3_DSTATE_go : BOOL;
	UD_DSTATE : BOOL;
	UnitDelay4_DSTATE_k : BOOL;
	Delay_DSTATE_lv : BOOL;
	UnitDelay4_DSTATE_o : BOOL;
	UnitDelay3_DSTATE_gf : BOOL;
	UnitDelay1_DSTATE_m : BOOL;
	DelayInput1_DSTATE_f : BOOL;
	Delay2_DSTATE_f : BOOL;
	UnitDelay_DSTATE_je : BOOL;
	DelayInput1_DSTATE_fv : BOOL;
	Delay2_DSTATE_k : BOOL;
	UnitDelay2_DSTATE_j : BOOL;
	TOF_2_state : BOOL;
	UnitDelay3_DSTATE_h5 : BOOL;
	UnitDelay2_DSTATE_hh : BOOL;
	UnitDelay_DSTATE_kx : BOOL;
	UnitDelay_DSTATE_n : BOOL;
	UnitDelay2_DSTATE_i : BOOL;
	Delay_DSTATE_n2 : BOOL;
	Delay_DSTATE_cnq : BOOL;
	Delay_DSTATE_a : BOOL;
	Delay_DSTATE_ng : BOOL;
	UnitDelay_DSTATE_o : BOOL;
	UnitDelay2_DSTATE_b : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_i : SINT;
	DiscreteTimeIntegrator_PrevRe_k : SINT;
	DiscreteTimeIntegrator_PrevRe_p : SINT;
	DiscreteTimeIntegrator_PrevR_ka : SINT;
	DiscreteTimeIntegrator_PrevRe_j : SINT;
	DiscreteTimeIntegrator4_PrevRes : SINT;
	DiscreteTimeIntegrator1_PrevRes : SINT;
	DiscreteTimeIntegrator_PrevRe_o : SINT;
	DiscreteTimeIntegrator_PrevRe_n : SINT;
	DiscreteTimeIntegrator3_PrevRes : SINT;
	DiscreteTimeIntegrator2_PrevRes : SINT;
	DiscreteTimeIntegrator_PrevRe_m : SINT;
	DiscreteTimeIntegrator_PrevR_oa : SINT;
	DiscreteTimeIntegrator_PrevRe_l : SINT;
	DiscreteTimeIntegrator1_PrevR_k : SINT;
	DiscreteTimeIntegrator_PrevR_no : SINT;
	DiscreteTimeIntegrator_PrevRe_c : SINT;
	DiscreteTimeIntegrator_PrevR_jc : SINT;
	DiscreteTimeIntegrator_PrevR_kx : SINT;
	DiscreteTimeIntegrator_PrevR_cs : SINT;
	DiscreteTimeIntegrator_PrevRe_g : SINT;
	DiscreteTimeIntegrator_PrevR_ly : SINT;
	DiscreteTimeIntegrator1_Prev_ko : SINT;
	DiscreteTimeIntegrator_PrevRe_b : SINT;
	DiscreteTimeIntegrator1_PrevR_l : SINT;
	DiscreteTimeIntegrator_PrevR_o3 : SINT;
	DiscreteTimeIntegrator_PrevR_i3 : SINT;
	DiscreteTimeIntegrator1_Prev_ks : SINT;
	DiscreteTimeIntegrator_PrevRe_a : SINT;
	DiscreteTimeIntegrator_PrevR_lh : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	DiscreteTimeIntegrator1_IC_LOAD : USINT;
	DiscreteTimeIntegrator_IC_LOA_l : USINT;
	DiscreteTimeIntegrator_IC_LOA_m : USINT;
	DiscreteTimeIntegrator_IC_LOA_p : USINT;
	DiscreteTimeIntegrator_IC_LOA_f : USINT;
	DiscreteTimeIntegrator_IC_LOA_c : USINT;
	DiscreteTimeIntegrator_IC_LOA_g : USINT;
	DiscreteTimeIntegrator1_IC_LO_n : USINT;
	icLoad : BOOL;
	icLoad_n : BOOL;
	icLoad_m : BOOL;
	icLoad_k : BOOL;
	icLoad_nl : BOOL;
	icLoad_e : BOOL;
	icLoad_h : BOOL;
	icLoad_l : BOOL;
	icLoad_i : BOOL;
	icLoad_f : BOOL;
	icLoad_ef : BOOL;
	icLoad_b : BOOL;
	icLoad_i0 : BOOL;
	icLoad_np : BOOL;
	icLoad_j : BOOL;
	icLoad_a : BOOL;
	icLoad_m3 : BOOL;
	icLoad_b3 : BOOL;
	icLoad_ev : BOOL;
	icLoad_d : BOOL;
	icLoad_es : BOOL;
	icLoad_evr : BOOL;
	icLoad_fg : BOOL;
	icLoad_c : BOOL;
	icLoad_eu : BOOL;
	icLoad_ee : BOOL;
	icLoad_ki : BOOL;
	icLoad_h3 : BOOL;
	icLoad_g : BOOL;
	icLoad_c1 : BOOL;
	icLoad_eh : BOOL;
	icLoad_kq : BOOL;
	icLoad_ir : BOOL;
	icLoad_nv : BOOL;
	icLoad_dk : BOOL;
	icLoad_iv : BOOL;
	icLoad_ix : BOOL;
	LVRTFlgRise : BOOL;
	x_not_empty : BOOL;
	SR_LoadStep : BOOL;
	x_not_empty_i : BOOL;
	y_map_not_empty : BOOL;
	y_map_not_empty_f : BOOL;
	y_map_not_empty_d : BOOL;
	P_not_empty : BOOL;
	red_comp : BOOL;
	icLoad_mu : BOOL;
	icLoad_ht : BOOL;
	icLoad_nq : BOOL;
	LVRTFlgRise_e : BOOL;
	err_1_not_empty : BOOL;
	count_not_empty : BOOL;
	err_1_not_empty_d : BOOL;
	x_not_empty_n : BOOL;
	x_i : BOOL;
	TON2 : rtDW_TON_1_Gen2_ref;
	TON1_n : rtDW_TON_1_Gen2_ref;
	TON_l : rtDW_TON_1_Gen2_ref;
	Filter3_f : rtDW_Filter3_Gen2_ref;
	Filter2_o : rtDW_Filter3_Gen2_ref;
	Filter1_ny : rtDW_Filter3_Gen2_ref;
	Filter_f : rtDW_Filter3_Gen2_ref;
	sf_MATLABFunction_i : rtDW_MATLABFunction_Gen2_ref_k;
	Filter1_l : rtDW_Filter3_Gen2_ref;
	Filter_mn : rtDW_Filter3_Gen2_ref;
	Pd_filt_p : rtDW_Pd_filt_Gen2_ref;
	Filter1_fj : rtDW_N_TC_HP_filt_Gen2_ref;
	Filter_l : rtDW_Pd_filt_Gen2_ref;
	TP1_l : rtDW_TP_Gen2_ref;
	TP_g : rtDW_TP_Gen2_ref;
	TON1_m : rtDW_TON_1_Gen2_ref;
	TOF_n : rtDW_TOF_Gen2_ref;
	sf_MATLABFunction1_l : rtDW_MATLABFunction1_Gen2_ref_c;
	KeMapUpdate_h : rtDW_KeMapUpdate_Gen2_ref;
	Filter1_n : rtDW_N_TC_HP_filt_Gen2_ref;
	Filter1_p : rtDW_Filter3_Gen2_ref;
	Filter_kj : rtDW_Pd_filt_Gen2_ref;
	p2sfilt_l : rtDW_N_TC_HP_filt_Gen2_ref;
	TON_d : rtDW_TON_1_Gen2_ref;
	Filter_bd : rtDW_Pd_filt_Gen2_ref;
	TON_j : rtDW_TON_1_Gen2_ref;
	TON_m : rtDW_TON_1_Gen2_ref;
	TON_o : rtDW_TON_1_Gen2_ref;
	Filter_m : rtDW_Filter_Gen2_ref;
	TON_c : rtDW_TON_1_Gen2_ref;
	DelayRetard : rtDW_TON_1_Gen2_ref;
	sf_MATLABFunction_kd : rtDW_MATLABFunction_Gen2_ref_k;
	Filter_pj : rtDW_Filter3_Gen2_ref;
	TP1_c : rtDW_TP_Gen2_ref;
	TP_p2 : rtDW_TP_Gen2_ref;
	TON1 : rtDW_TON_1_Gen2_ref;
	TOF_g : rtDW_TOF_Gen2_ref;
	sf_MATLABFunction1_m : rtDW_MATLABFunction1_Gen2_ref_c;
	KeMapUpdate : rtDW_KeMapUpdate_Gen2_ref;
	Filter_nk : rtDW_Filter_Gen2_ref;
	Filter_b : rtDW_Filter3_Gen2_ref;
	sf_FILTERnodelay_b : rtDW_FILTERnodelay_Gen2_ref;
	Filter1_o : rtDW_N_TC_HP_filt_Gen2_ref;
	sf_MATLABFunction1_e : rtDW_MATLABFunction_Gen2_ref_k;
	sf_MATLABFunction_k : rtDW_MATLABFunction_Gen2_ref_k;
	SkipPulseWaitTP : rtDW_TP_Gen2_ref;
	sf_MATLABFunction_n : rtDW_MATLABFunction_Gen2_ref_k;
	Filter1_fg : rtDW_N_TC_HP_filt_Gen2_ref;
	Filter_n : rtDW_Filter3_Gen2_ref;
	TP_Misfire_ON_2ndtime : rtDW_TP_ActSat_CBV_Gen2_ref;
	TP_Misfire_ON : rtDW_TP_ActSat_CBV_Gen2_ref;
	TP_Misfire_OFF2 : rtDW_TP_ActSat_CBV_Gen2_ref;
	TP_Misfire_OFF1 : rtDW_TP_ActSat_CBV_Gen2_ref;
	TP_Misfire_OFF : rtDW_TP_ActSat_CBV_Gen2_ref;
	TP_Ignretard : rtDW_TP_ActSat_CBV_Gen2_ref;
	TP_ActSat_TV : rtDW_TP_ActSat_CBV_Gen2_ref;
	TP_ActSat_CBV : rtDW_TP_ActSat_CBV_Gen2_ref;
	TP_p : rtDW_TP_Gen2_ref;
	TOF3 : rtDW_TOF_Gen2_ref;
	TOF2_d : rtDW_TOF_Gen2_ref_f;
	TOF1_o : rtDW_TOF_Gen2_ref;
	TOF_c : rtDW_TOF_Gen2_ref_f;
	TP1 : rtDW_TP_Gen2_ref;
	TP : rtDW_TP_Gen2_ref;
	TOF_h : rtDW_TOF_Gen2_ref;
	speedFilter : rtDW_N_TC_HP_filt_Gen2_ref;
	Filter1_f : rtDW_Filter1_Gen2_ref;
	sf_IntegerZOH_g : rtDW_IntegerZOH_Gen2_ref;
	Filter_k : rtDW_Pd_filt_Gen2_ref;
	undOrderFilter_j : rtDW_undOrderFilter3_Gen2_ref;
	p2sfilt_b : rtDW_N_TC_HP_filt_Gen2_ref;
	p2sfilt : rtDW_N_TC_HP_filt_Gen2_ref;
	WO2 : rtDW_Filter3_Gen2_ref;
	WO1 : rtDW_Filter1_Gen2_ref;
	Pd_filt : rtDW_Pd_filt_Gen2_ref;
	sf_MATLABFunction1_ep : rtDW_MATLABFunction1_Gen2_ref;
	sf_MATLABFunction_a : rtDW_MATLABFunction_Gen2_ref_f;
	sf_MATLABFunction1_h : rtDW_MATLABFunction1_Gen2_ref;
	sf_MATLABFunction_g : rtDW_MATLABFunction_Gen2_ref_f;
	TON : rtDW_TON_1_Gen2_ref;
	TOF2 : rtDW_TOF_Gen2_ref;
	TOF1 : rtDW_TOF_Gen2_ref;
	TOF : rtDW_TOF_Gen2_ref;
	undOrderFilter3 : rtDW_undOrderFilter3_Gen2_ref;
	undOrderFilter2 : rtDW_undOrderFilter_Gen2_ref;
	undOrderFilter1 : rtDW_undOrderFilter_Gen2_ref;
	undOrderFilter : rtDW_undOrderFilter_Gen2_ref;
	sf_FILTERnodelay5 : rtDW_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay4 : rtDW_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay3 : rtDW_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay2 : rtDW_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay1 : rtDW_FILTERnodelay_Gen2_ref;
	sf_FILTERnodelay : rtDW_FILTERnodelay_Gen2_ref;
	sf_IntegerZOH1_n : rtDW_IntegerZOH_Gen2_ref;
	sf_IntegerZOH_f : rtDW_IntegerZOH_Gen2_ref;
	p4LP_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	p3LP_filt_e : rtDW_N_TC_HP_filt_Gen2_ref;
	p2s_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	p2HP_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	p1HP_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	Volt_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	T2s_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	T1LP_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	T1HP_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	Pel_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	N_TC_LP_filt_f : rtDW_N_TC_HP_filt_Gen2_ref;
	N_TC_LP_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	N_TC_HP_filt : rtDW_N_TC_HP_filt_Gen2_ref;
	Filter : rtDW_Filter3_Gen2_ref;
	sf_IntegerZOH2 : rtDW_IntegerZOH_Gen2_ref;
	sf_IntegerZOH : rtDW_IntegerZOH_Gen2_ref;
	sf_MATLABFunction_e : rtDW_MATLABFunction_Gen2_ref;
	sf_MATLABFunction_f : rtDW_MATLABFunction_Gen2_ref;
	Filter3 : rtDW_Filter3_Gen2_ref;
	TON_1 : rtDW_TON_1_Gen2_ref;
	Filter4 : rtDW_Filter1_Gen2_ref;
	Filter2 : rtDW_Filter1_Gen2_ref;
	Filter1 : rtDW_Filter1_Gen2_ref;
END_STRUCT;
PrevZCSigStates_Gen2_ref : STRUCT
	Delay_Reset_ZCE : USINT;
	Delay_Reset_ZCE_k : USINT;
	Delay_Reset_ZCE_b : USINT;
	Delay_Reset_ZCE_n : USINT;
	ResettableDelay_Reset_ZCE : USINT;
	Delay2_Reset_ZCE : USINT;
	Delay_Reset_ZCE_m : USINT;
	ResettableDelay_Reset_ZCE_j : USINT;
	ResettableDelay3_Reset_ZCE : USINT;
	ResettableDelay_Reset_ZCE_m : USINT;
	VariableIntegerDelay_Reset_ZCE : USINT;
	ResettableDelay_Reset_ZCE_a : USINT;
	ResettableDelay1_Reset_ZCE : USINT;
	ResettableDelay_Reset_ZCE_e : USINT;
	ResettableDelay1_Reset_ZCE_g : USINT;
	ResettableDelay_Reset_ZCE_b : USINT;
	VariableIntegerDelay_Reset_ZC_i : USINT;
	Delay_Reset_ZCE_d : USINT;
	Delay_Reset_ZCE_l : USINT;
	Delay_Reset_ZCE_i : USINT;
	Delay_Reset_ZCE_mu : USINT;
	VariableIntegerDelay_Reset_ZC_o : USINT;
	Delay_Reset_ZCE_d3 : USINT;
	Delay_Reset_ZCE_c : USINT;
	Delay_Reset_ZCE_p : USINT;
	Delay_Reset_ZCE_ih : USINT;
	Delay_Reset_ZCE_k2 : USINT;
	Delay_Reset_ZCE_a : USINT;
	Delay_Reset_ZCE_o : USINT;
	Delay_Reset_ZCE_kk : USINT;
	Delay_Reset_ZCE_bc : USINT;
	Delay_Reset_ZCE_j : USINT;
	Delay_Reset_ZCE_h : USINT;
	Delay_Reset_ZCE_bi : USINT;
	ResettableDelay_Reset_ZCE_k : USINT;
	Delay_Reset_ZCE_mt : USINT;
	Delay_Reset_ZCE_e : USINT;
	Delay_Reset_ZCE_at : USINT;
END_STRUCT;
rtC_undOrderFilter_Gen2_ref : STRUCT
	Constant : LREAL;
END_STRUCT;
rtC_undOrderFilter3_Gen2_ref : STRUCT
	Constant : LREAL;
END_STRUCT;
rtC_Filter_Gen2_ref : STRUCT
	Abs : LREAL;
	Switch : LREAL;
	RelationalOperator : BOOL;
	RelationalOperator_g : BOOL;
	LogicalOperator1 : BOOL;
END_STRUCT;
rtC_KeMapUpdate_Gen2_ref : STRUCT
	Constant1 : LREAL;
END_STRUCT;
ConstBlockIO_Gen2_ref : STRUCT
	Constant11 : LREAL;
	u : LREAL;
	tde1 : LREAL;
	Constant2 : LREAL;
	Constant3 : LREAL;
	Constant1_g : LREAL;
	x0_f : LREAL;
	T_filt1 : LREAL;
	KeMapUpdate_h : rtC_KeMapUpdate_Gen2_ref;
	Filter_m : rtC_Filter_Gen2_ref;
	KeMapUpdate : rtC_KeMapUpdate_Gen2_ref;
	Filter_nk : rtC_Filter_Gen2_ref;
	undOrderFilter_j : rtC_undOrderFilter3_Gen2_ref;
	undOrderFilter3 : rtC_undOrderFilter3_Gen2_ref;
	undOrderFilter2 : rtC_undOrderFilter_Gen2_ref;
	undOrderFilter1 : rtC_undOrderFilter_Gen2_ref;
	undOrderFilter : rtC_undOrderFilter_Gen2_ref;
END_STRUCT;
ConstParam_Gen2_ref : STRUCT
	LT2deg_tableData : ARRAY[0..3] OF LREAL;
	LT2deg_bp01Data : ARRAY[0..3] OF LREAL;
END_STRUCT;
ExternalOutputs_Gen2_ref : STRUCT
	out : tGen2Out;
	dbg : tGen2Debug;
END_STRUCT;
tag_RTM_Gen2_ref : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_Gen2_ref;
	prevZCSigState : REFERENCE TO PrevZCSigStates_Gen2_ref;
	outputs : REFERENCE TO ExternalOutputs_Gen2_ref;
	dwork : REFERENCE TO D_Work_Gen2_ref;
END_STRUCT;
RT_MODEL_Gen2_ref : tag_RTM_Gen2_ref;
END_TYPE
TYPE
END_TYPE