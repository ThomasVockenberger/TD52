
TYPE
	IN_CB_Struct : 	STRUCT 
		tPB2MM : ParaBase2MM_type; (*Data exchange structure to ParaBase*) (*OldName:new PV; Cycle:5;*)
		tAB2CB : AmmBase2MM; (*AMM structure*) (*OldName:QUITT_WA; Cycle:2;*)
		tP_Act : ARRAY[0..2]OF HALioAi_Type; (* actual electric power [kW] *) (* OldName: P_IST_OF; Cycle:2; *)
		tQ_Act : ARRAY[0..2]OF HALioAi_Type; (*actual reactive power [kVar] *) (*OldName:ssPReac;Cycle:2*)
		tI_L1 : ARRAY[0..2]OF HALioAi_Type; (*Phase current generator I1 *) (*OldName:ssIL1_fast ; Cycle:2; *)
		tI_L2 : ARRAY[0..2]OF HALioAi_Type; (*Phase current generator I2 *) (*OldName:ssIL2_fast ; Cycle:2; *)
		tI_L3 : ARRAY[0..2]OF HALioAi_Type; (*Phase current generator I3 *) (*OldName:ssIL3_fast ; Cycle:2; *)
		tF_MMD : ARRAY[0..2]OF HALioAi_Type; (*actuel generator frequence *) (* OldName:usFreq_TC1; Cycle:2; 	*)
		tU_L1L2 : ARRAY[0..2]OF HALioAi_Type; (*generator voltage phase 1_2 [V] *) (*OldName:ssUL1L2 ; Cycle:2; *)
		tU_L2L3 : ARRAY[0..2]OF HALioAi_Type; (*generator voltage phase 2_3 [V] *) (*OldName: ssUL2L3 ; Cycle:2; *)
		tU_L3L1 : ARRAY[0..2]OF HALioAi_Type; (*generator voltage phase 3_1 [V] *) (*OldName:ssUL3L1 ; Cycle:2; *)
		tPF_Act : ARRAY[0..2]OF HALioAi_Type; (* actual cos phi value TC1*) (*ssCosPhi_TC1; Cycle:2; *)
		tPos_Act_TV_A1 : HALioAi_Type; (* throttle valve position A1 *) (* OldName: AI_Drkl_y_Ist_A1; Cycle:2; *)
		tPos_Act_TV_A2 : HALioAi_Type; (* throttle valve position A2 *) (* OldName: AI_Drkl_y_Ist_A2; Cycle:2; *)
		tPos_Act_TV_B1 : HALioAi_Type; (* throttle valve position B1 *) (* OldName: AI_Drkl_y_Ist_B1; Cycle:2; *)
		tPos_Act_TV_B2 : HALioAi_Type; (* throttle valve position B2 *) (* OldName: AI_Drkl_y_Ist_B2; Cycle:2; *)
		tPos_Act_CBV_A1 : HALioAi_Type; (* compressor bypass valve position A1 *) (* OldName: AI_Turbo_y_Ist_A1; Cycle:2; *)
		tPos_Act_CBV_A2 : HALioAi_Type; (* compressor bypass valve position A2 *) (* OldName: AI_Turbo_y_Ist_A2; Cycle:2; *)
		tPos_Act_CBV_B1 : HALioAi_Type; (* compressor bypass valve position B1 *) (* OldName: AI_Turbo_y_Ist_B1; Cycle:2; *)
		tPos_Act_CBV_B2 : HALioAi_Type; (* compressor bypass valve position B2 *) (* OldName: AI_Turbo_y_Ist_B2; Cycle:2; *)
		tGCB_On : HALioDi_Type; (* DI generator circuit breaker closed *) (* OldName: GCB_ON ; Cycle:2; *)
		tPr_Ch_P2 : HALioAi_Type; (* actual charge pressure before throttle valve *) (* OldName: P2 ; Cycle:2; *)
		tT_EO : HALioAi_Type; (* AI: Engine oil temperature *) (* OldName: OTP_WE; Cycle:2; *)
		rT_Ch_T1LP_Avg : REAL; (*average charge temperature before low-pressure turbocharger (= engine intake air) [°C]*) (*OldName:ssIATemp,ANA_ZLTP,rT_InAirER; Cycle:5;*) (* V04.04.00.00 *)
		tT_InAirER : HALioAi_Type; (* AI intake air engine room temperature[C] *) (* OldName: ANA_ZLTP; Cycle:2; *)
		tT_ECW : HALioAi_Type; (* cooling water temperature *) (*OldName:ANA.KWT;Cycle:2;*)
		tPr_PCGT_sp : HALioAo_Type; (*AO main gas train pressure - set point with Offset considered*) (*OldName: AO_p_PC_sp; Cycle:2;*)
		tPr_MGT_sp : HALioAo_Type; (*AO pressure gas rail set point with Offset considered*) (*OldName: AO_p_GR_sp; Cycle:2;*)
		tPr_PC : HALioAi_Type; (*AI	 Pressure prechamber*) (* OldName: PDIFF_WE; Cyclic: ; *)
		tPr_MGT_a_Filt : HALioAi_Type; (*AI main gas train pressure after filter [bar]*) (* OldName: AI_p_GT1; Cyclic: 2; *)
		tT_EG_Cyl : ARRAY[0..24]OF HALioAi_Type; (* AI cylinder exhaust gas temperatures *) (* OldName: t_zyl; Cycle:2; *)
		tN_TCHP_A : HALioAi_Type; (*high pressure turbocharger speed A [rpm]*) (*OldName: ssTurboSpdA_WE, TRB1_WE, ssTurboSpdA; Cycle: 2;*)
		tN_TCHP_B : HALioAi_Type; (*high pressure turbocharger speed B [rpm]*) (*OldName: ssTurboSpdB_WE, TRB2_WE, ssTurboSpdB; Cycle: 2;*)
		tN_TCLP_A : HALioAi_Type; (*low pressure turbocharger speed A [rpm]*) (*OldName: ssTurboSpd_LP_A_WE, AI_TurboSpd_LP_A, ssTurboSpd_LP_A; Cycle: 2;*)
		tN_TCLP_B : HALioAi_Type; (*low pressure turbocharger speed B [rpm]*) (*OldName: ssTurboSpd_LP_B_WE, AI_TurboSpd_LP_B, ssTurboSpd_LP_B; Cycle: 2;*)
		tPr_EGbHPTC_A : HALioAi_Type; (* AI: Exhaust gas pressure before high-pressure turbocharger A (M.02-PI-152) *) (* OldName: AI_M_02_PI_152	; Cyclic: 2; *)
		tPr_EGbHPTC_B : HALioAi_Type; (* AI: Exhaust gas pressure before high-pressure turbocharger B (M.02-PI-252) *) (* OldName: AI_M_02_PI_252	; Cyclic: 2; *)
		tPr_EGaHPTC_A : HALioAi_Type; (* AI: Exhaust gas pressure after high-pressure turbocharger A  (M.02-PI-153) *) (* OldName: AI_M_02_PI_153	; Cyclic: 2; *)
		tPr_EGaHPTC_B : HALioAi_Type; (* AI: Exhaust gas pressure after high-pressure turbocharger B  (M.02-PI-253) *) (* OldName: AI_M_02_PI_253	; Cyclic: 2; *)
		tPr_EGaLPTC_A : HALioAi_Type; (* AI: Exhaust gas pressure after low-pressure turbocharger A  (M.02-PI-154) *) (* OldName: AI_M_02_PI_154	; Cyclic: 2; *)
		tPr_EGaLPTC_B : HALioAi_Type; (* AI: Exhaust gas pressure after low-pressure turbocharger B  (M.02-PI-254) *) (* OldName: AI_M_02_PI_254	; Cyclic: 2; *)
		tT_EGbHPTC_A : HALioAi_Type; (* AI: Exhaust gas temperature before high-pressure turbocharger A  (M.02-TI-166) *) (* OldName: AI_M_02_TI_166	; Cyclic: 2; *)
		tT_EGbHPTC_B : HALioAi_Type; (* AI: Exhaust gas temperature before high-pressure turbocharger B  (M.02-TI-266) *) (* OldName: AI_M_02_TI_266	; Cyclic: 2; *)
		tT_EGaHPTC_A : HALioAi_Type; (* AI: Exhaust gas temperatur after high-pressure turbocharger A  (M.02-TI-167) *) (* OldName: AI_M_02_TI_167	; Cyclic: 2; *)
		tT_EGaHPTC_B : HALioAi_Type; (* AI: Exhaust gas temperatur after high-pressure turbocharger A  (M.02-TI-267) *) (* OldName: AI_M_02_TI_267	; Cyclic: 2; *)
		tPr_CC : HALioAi_Type; (* AI pressure crank case [bar] *) (*OldName:AI_KGD; Cycle:2*)
		bPBCSensErr : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName: bPBCSensErr; Cycle:2; *)
		bPBCCompLineCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName: bPBCCompLineCheck; Cycle:2; *)
		bPBCNegVoltCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName: bPBCNegVoltCheck; Cycle:2; *)
		bPBCNegPresCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName: bPBCNegPresCheck; Cycle:2; *)
		bPBCPresSlopeCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName: bPBCPresSlopeCheck; Cycle:2; *)
		bPBCSlowDriftCheck : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName: bPBCSlowDriftCheck; Cycle:2; *)
		bPBCMemBurst : ARRAY[0..24]OF BOOL; (* error info for PBC *) (* OldName: bPBCMemBurst; Cycle:2; *)
		bPBCCPSSat : ARRAY[0..24]OF BOOL; (*error info for PBC*)
		rN_IgnSAFI_Act : REAL; (* Engine speed measured by ignition SAFI *) (* OldName: ZDGSpeed; Cycle:2; *)
		rT_SA_ElecTemp : ARRAY[0..12]OF REAL; (* SAFI electronic temperature *) (* OldName:ssSAFITemp; Cycle: *)
		rSA_SW_Vers : ARRAY[0..12]OF REAL; (* SAFI software version *) (* OldName:usSAFIVers; Cycle: *)
		rSA_FiltVers : ARRAY[0..12]OF REAL; (* SAFI KLS filter version *) (* OldName:usSAFFiltV; Cycle: *)
		rU_IgnSAFI_Cyl : ARRAY[0..24]OF REAL; (* ignition voltage for each cylinder  *) (* OldName:V_Zyl; Cycle:2 *)
		rPr_GR_UF : REAL; (*unfiltered Average gas rail pressure [bar]*) (* OldName: new PV ; Cycle: 2 *)
		rGMU_Pos_Valve_Prom : ARRAY[0..4]OF REAL; (*Valve Position [%o]*) (*OldName: ssTJPos; Cycle: 5*)
		rGMU_Pr_DiffGas : ARRAY[0..4]OF REAL; (*Differential Pressure over device [mbar*10]*) (*OldName: ulGasFlowN; Cycle: 5*)
		rPr_MGT_sp : REAL; (*main gas train pressure - set point [bar]*) (* OldName: p_GR_sp*)
		rPr_PCGT_sp : REAL; (*	pre chamber gas train pressure - set point [bar]*) (* OldName: p_PC_sp*)
		rT_CBearing : ARRAY[0..24]OF REAL; (*conrod bearing temperature [°C]*) (* OldName: new PV ; Cycle: 2 *)
		rT_MBearing : ARRAY[0..11]OF REAL; (*filtered main bearing temperature [°C]*) (* OldName: new PV ; Cycle: 2 *)
		iSt_OpMode : UDINT; (* engine operation mode *) (*OldName: new PV; Cycle:2; *)
		rP_Set_Norm : REAL; (* power setpoint related to rP_Nom *) (* OldName: new PV; Cycle:2; *)
		rT_Ch_T2s_Avg_UF : REAL; (*unfiltered Average charge temperature t2' (after throttle valve) [°C]*) (* OldName: new PV ; Cycle: 2 *)
		rPr_Ch_P2s_Avg_UF : REAL; (*unfiltered Average charge pressure p2' (after throttle valve) [bar]*) (* OldName: new PV ; Cycle: 2 *)
		rPr_Ch_P2s_A_UF : REAL; (*unfiltered Average charge pressure p2' bank A (after throttle valve) [bar]*) (* OldName: new PV ; Cycle: 2 *)
		rPr_Ch_P2s_B_UF : REAL; (*unfiltered Average charge pressure p2' bank B (after throttle valve) [bar]*) (* OldName: new PV ; Cycle: 2 *)
		rN_IgnIC_Act : REAL; (* Engine speed measured by ignition IC *) (* OldName: ZDGSpeed; Cycle:2; *)
		rPr_CPP : ARRAY[0..24]OF REAL; (* cylinder peak pressure *) (* OldName: DruckMax; Cycle: 2 *)
		rPr_49afTDC : ARRAY[0..24]OF REAL; (* cylinder pressure 49° afterTDC *) (* OldName: rP_49afTDC; Cycle: 2 *)
		rPr_49bfTDC : ARRAY[0..24]OF REAL; (* cylinder pressure 49° before TDC *) (* OldName: rP_49bfTDC; Cycle: 2 *)
		rPr_Knck : ARRAY[0..24]OF REAL; (* knock pressure *) (* OldName: Klopfen; Cycle: 2 *)
		rPr_IMEP : ARRAY[0..24]OF REAL; (* Indicated Mean Effective Pressure *) (* OldName: IndiMitDr; Cycle: 2 *)
		rCA_MFBvar : ARRAY[0..24]OF REAL; (* 50% of fuel mass burned *) (* OldName: UmsatzpunktL; Cycle: 2 *)
		rCA_PI_Dur : ARRAY[0..24]OF REAL; (* PI duration *) (* OldName: new PV ; Cycle: 2 *)
		bGlowIgn : ARRAY[0..24]OF BOOL; (* glow ignition *) (* OldName: Gluehzuend; Cycle: 2 *)
		bMisf_I : ARRAY[0..24]OF BOOL; (* missfire detection 10° after TDC *) (* OldName: Aussetzer; Cycle: 2 *)
		bMisf_II : ARRAY[0..24]OF BOOL; (* missfire detection 40° after TDC *) (* OldName: Misf_II; Cycle: 2 *)
		rPr_Leanox_Set : REAL; (* Setpoint boost pressure *) (* Oldname: pl_soll; Cycle: 2*)
		rLam_Eng_LL_Set : REAL; (* Leanox Lambda set point *) (* OldName: ssPosGasmixerNominal; Cycle:2; *)
		iMisfCyl : UDINT; (* cylinder misfire parameter *) (* OldName: MissfCyl; Cycle:2; *)
		rPos_TV : REAL; (* throttle valve position *) (* OldName: drkl_y; Cycle:2; *)
		rPos_CBV : REAL; (* compressor bypass valve position *) (* OldName: turbo_y; Cycle:2; *)
		bPBC_Event_GC : BOOL; (* PBCMem trigger for GridCode event *) (* OldName: new PV; Cycle:2; *)
		bPBC_Event_Misf : BOOL; (* PBCMem trigger for Misfire event *) (* OldName: new PV; Cycle:2; *)
		rCA_Ign_Act : ARRAY[0..24]OF REAL; (*  actual cylinder ignition point  *) (* OldName: ActTiming / ZZPCyl; Cycle:2; *)
		ulGasFlowN : ARRAY[0..4]OF UDINT; (* setpoint gasflow one gas inject v *) (*OldName: ulGasFlowN; Cycle: 2*)
		rSDT : REAL; (* recent aligned slow down time (from 95% engine speed to 5% engine speed)*)
		rT_EG_Cyl : ARRAY[0..24]OF REAL; (* cylinder exhaust gas temperatures *) (* OldName:t_zyl; Cycle:2 *)
		tPr_Ch_P1HP_A : HALioAi_Type; (*charge pressure p1 before high pressure TC A [bar]*) (*OldName: ; Cycle: 2;*)
		tPr_Ch_P1HP_B : HALioAi_Type; (*charge pressure p1 before high pressure TC B [bar]*) (*OldName: ; Cycle: 2;*)
		bLimpHomeCyl : ARRAY[0..24]OF BOOL; (* Cylinder in Limp Home *) (* OldName: bLimpHomeCyl; Cycle: 2 *)
		bGrC_VoltageLow : BOOL; (* TRUE if voltage is below limit *) (* OldName: bGridCodeVoltageLow; Cycle:5; *)
		bGrC_CurrentChange : BOOL; (* TRUE if generator current change is above limit *) (* OldName: bGridCodeCurrentChange; Cycle:2; *)
		bGrC_SpeedChange : BOOL; (* TRUE if Grid Code event speed change is detected *) (* OldName: bGridCodeSpeedChange; Cycle:2; *)
		rSA_PBC_Sens : ARRAY[0..12]OF REAL; (* PBC sensor sensitivity [mV/bar] *) (* new PV; Cycle: 2*)
		tT_GR : HALioAi_Type; (* gas rail temperature *) (* OldName: AI_GRTP; Cycle:2; *)
		rP_Nom : REAL; (* nominal electric power [kW], depends on gastype *) (* OldName: PN_GASART; Cycle:2; *)
		iCnt_Starts : DINT; (* start counter *) (*OldName:start_z;Cycle:2;*)
		iCnt_OpHours : DINT; (* operating hours counter *) (*OldName:betrieb_h;Cycle:2;*)
		tHumidity_AirIn : HALioAi_Type; (* AI: intake air relative humiidty of humidity sensor, normed value [0...1]*) (* OldName: FEUCHTE_WE; Cycle:2; *)
		tPr_Baro : HALioAi_Type; (*AI Barometric pressure *) (* OldName: 	AI_p_Baro	; Cyclic: ; *) (*V04.02.00.00*)
		rDur_Map_Offs : ARRAY[0..24]OF REAL; (* Duration Map offset *) (* OldName: new PV; Cycle: 2 *)
		rDur_PID_Offs : ARRAY[0..24]OF REAL; (* Duration controller offset *) (* OldName: new PV; Cycle: 2 *)
		szOrderID : STRING[17]; (*Para: application ID string*) (*OldName:szApplication; Cycle: *)
		iEngID : DINT; (*Para: engine ID number*) (*OldName:new PV; Cycle: *)
		bEng_Dem : BOOL; (* demand engine *) (*OldName:M_AGFD;Cycle:2;*)
		iIdx_OMSS : INT; (* inex of operation mode selector switch - 0..OFF, 1..MAN, 2..AUTO, 3..TEST, 4..SCAVENGING *) (*OldName:new PV;Cycle:2;*)
		iIdx_RSS : INT; (* inex of request selector switch - 0..OFF, 1..ON, 2..REMOTE *) (*OldName:new PV;Cycle:2;*)
		iIdx_ContGen : INT; (*Controller generation 1=Standard / 2=NTI *) (* Oldname: ucContGen; Cycle: 2;*)
		rP_Set_Unred_Norm : REAL; (* unreduzed power setpoint related to rP_Nom *) (* OldName: P_UNRED; Cycle:2; *)
		bIgn_Run : BOOL; (* Ignition in Operation *) (*OldName:ZIB;Cycle:2;*)
		rP_Ramp_IncGrad_All_Norm : REAL; (*gradient for increase of power ramp in grid mode [1/s]*) (*OldName:t_upALL; Cycle:2;*)
		bLeanox_Active : BOOL; (* TRUE = leanox controller is active *) (* OldName: bLeanoxActive; Cycle:2; *)
		rP_GEN2_Norm : REAL; (* power trajectory SimSo P_d/1000/IN_EC.rP_Nom *) (* Oldname: P_d; Cycle: *)
		tPr_AirStarter_Tank : HALioAi_Type; (*AI air starter tank pressure [bar]*) (* Oldname:new PV , Cycle:2 *)
		tPr_AirStarter_Supply : HALioAi_Type; (*Air starter supply pressure [bar]*) (* Oldname:new PV , Cycle:2 *)
		bEng_Start : BOOL; (*engine start*) (*OldName:M_STRT; Cycle:5*)
		bDSyLine : BOOL; (* demand synchline *) (* OldName: M_SYL ; Cycle:2; *)
		bSlowturn_Active : BOOL; (*slowturn start*) (*Oldname: newPV, Cycle:5 *)
		iMsg : ARRAY[0..9999]OF USINT; (*provides data from all alarms*) (*OldName:newPv; Cycle:2;*)
		rPr_Knck_Lim : ARRAY[0..24]OF REAL; (* knock limit*) (* OldName: knockFilt; Cycle: 2 *)
		rPr_Knck_Filt : ARRAY[0..24]OF REAL; (* filtred knock pressure Containment  V2*) (* OldName: knockFilt; Cycle: 2 *)
		rCQ_Max : ARRAY[0..24]OF REAL; (* Combustion Quality*) (* OldName: new PV; Cycle: 2 *)
		rPmax_Offset_Coef_a : REAL; (* coefficient for the pmax offset calculation*)
		rPmax_Offset_Coef_b : REAL; (* coefficient for the pmax offset calculation*)
		tPr_ECW : HALioAi_Type; (*AI pressure engine cooling water*) (*OldName:ANA.KWD; Cycle:5;*)
		tPr_EngLubOil : HALioAi_Type; (* AI pressure engine lube oil [bar] *) (*OldName:ODR_WE; Cycle:5*)
		rKnck_Intgr : ARRAY[0..24]OF REAL; (* integrated cylinder knock values *) (* OldName: IntKlopf ; Cycle: 2 *)
		iIdx_PI_Bal_State : USINT; (* State of Balancer *) (* OldName: ucBal_State; Cycle: 2 *)
		rDur_BAL_SumCor : REAL; (* Balancer: sum correction of PI Duration in [°CA]*) (* OldName: new PV; Cycle: 2 *)
		rPr_PMaxOffs_BAL_SumCor : REAL; (* Balancer: sum correction of PMax Offset in [%]*) (* OldName: new PV; Cycle: 2 *)
		bFreezeOptiCyl : ARRAY[0..24]OF BOOL; (* optimizer frozen *) (* OldName: new PV; Cycle: 2 *)
		bPBC_Mon_Active : BOOL; (* monitoring for sensor failure active? *) (* OldName: new PV; Cycle: 2 *)
		bPBC_SensF : ARRAY[0..24]OF BOOL; (* Sensor failure *) (* OldName: new PV; Cycle: 2 *)
		bHiContrCyl : ARRAY[0..24]OF BOOL; (* HiCtr interference on cylinder *) (* OldName: bHiContrCyl; Cycle: 2 *)
		bPBCConfNotOK : ARRAY[0..12]OF BOOL; (* error info for PBC *) (* OldName: bPBCConfNotOK; Cycle:2; *)
		bPBCInvalidPar : ARRAY[0..12]OF BOOL; (* error info for PBC *) (* OldName: bPBCInvalidPar; Cycle:2; *)
		rT_EG_LimMax : REAL; (* exhaust gas temperature limit *) (* OldName: new PV; Cycle: 2 *)
		rPr_CPP_Filt : ARRAY[0..24]OF REAL; (* filtred cylinder peak pressure containment V3 *) (* OldName: newPV; Cycle: 2;*)
		tEOP1AC_Dem : HALioDo_Type; (*DO engine oil pump 1 AC *) (*OldName:DO_EOP1AC; Cycle:5*)
		tEOP1DC_Dem : HALioDo_Type; (*DO engine oil pump 1 DC *) (*OldName:DO_EOP1DC; Cycle:5*)
		bPreLube_EngStaRel : BOOL; (* Engine Start Release Prelube *) (*OldName:newPV; Cycle:5*)
		bScavFinished : BOOL; (* scavenging cycle finished  *) (*OldName:SPUEL_AB;Cycle:5;*)
		bEGScav_Rdy : BOOL; (*release delayed demand auxiliaries from exhaust gas scavenging*) (*OldName:T_VERZ_ANF;Cycle:5*)
		tScavVaOpened : HALioDi_Type; (*DI scavenging valve opened*) (*OldName:SPK_AUF;Cycle:5*)
		tScavVaClosed : HALioDi_Type; (*DI scavenging valve closed*) (*OldName:SPK_ZU;Cycle:5*)
		tGT1_SafeDevOK : HALioDi_Type; (*DI	 Gassafety device 1 *) (* OldName: F_GAS1	; Cyclic:5; *)
		tGT1_SafeDevice : HALioDo_Type; (*DO	 Gas safety device 1 *) (* OldName: A_GAS1	; Cyclic:5; *)
		bTripCyl : ARRAY[0..24]OF BOOL; (* Cylinder Trip Information *) (* OldName: newPV; Cycle: 2 *)
		bSkipCylAct : ARRAY[0..24]OF BOOL; (* Cylinder Skip Information *) (* OldName: newPV; Cycle: 2 *)
		rPos_Set_WG_Norm : REAL; (* normed position setpoint for wastegate *) (* OldName: ssPos_WG; Cycle: 2 *)
		tPos_Act_WG_A : HALioAi_Type; (* waste gate valve position A *) (* OldName: AI_WasteGate_y_Ist_A; Cycle:2; *)
		tPos_Act_WG_B : HALioAi_Type; (* waste gate valve position B *) (* OldName: AI_WasteGate_y_Ist_A; Cycle:2; *)
		bLimpHomeCylTrip : ARRAY[0..24]OF BOOL; (* Cylinder Trip because Limp Home *) (* OldName: bLimpHomeCylTrip; Cycle: 2 *)
		bSteadyState_Bal : BOOL;
		bLimpHomeCylRKS : ARRAY[0..24]OF BOOL; (* Cylinders in LimpHome *) (* OldName: newPV; Cycle: 2;*)
		bLimpHomeCylRKS_TC5 : ARRAY[0..24]OF BOOL; (* Cylinders in LimpHome *) (* OldName: newPV; Cycle: 5;*)
		rCA_IP_StartOffs : REAL; (* FS IP Offset *) (* OldName: newPV; Cycle: 2;*)
		rCA_IP_EGTCtr_Offs : REAL; (* FS IP Offset from EGTCtr *) (* OldName: newPV; Cycle: 2;*)
		bFS_IP_Offs_Trip : BOOL; (* fast start IP Offset trips because of EGT *) (* OldName: newPV; Cycle: 2;*)
		rCA_IP_Set_Raw : REAL; (* ignitoin timing set point raw (without 0.5°/s ramp)*) (* OldName: newPV ; Cycle:2; *)
		rCA_IgnP_Set : REAL; (* ignitoin timing set point *) (* OldName: W_ZZP ; Cycle:2; *)
		rCust_SparePara : ARRAY[0..200]OF REAL; (*SPS_REZP1 to SPS_REZP70	*) (*OldName: SPS_REZP1, SPS_REZP2, SPS_REZP3, SPS_REZP16 ; Cycle: 5;*)
		bMsg2831 : BOOL; (* B2831 Low Voltage Ride Through Event *)
		bLeanox_Man : BOOL; (* TRUE = leanox controller in manual *) (* OldName: l_einst_a ; Cycle:2; *)
		bPIOptiChange : BOOL; (* time pulse after a change of the PI optimizer *) (* OldName: newPV ; Cycle:2; *)
		tGrC_DCon : HALioDo_Type; (* DO: FALSE = Disconnect from Grid due to GridCode Event*) (* OldName: bDO_GRIDCODE_DCON_TC1; Cycle:2; *)
		bServiceMode : BOOL; (*service mode*) (*OldName:bServiceBegin; Cycle:5;*)
		rP_Set_GEN2_Norm : REAL; (* power setpoint for GEN2 *) (*OldName:ssSetpointPowerkW_BDC; Cycle:2;*)
		rEta_Gen : REAL; (* eta generator *) (* OldName: rEta_Gen; Cycle: 2 *)
		rEta_Eng : REAL; (* eta engine *) (* OldName: rEta_Eng; Cycle: 2 *)
		rVE_Eng : REAL; (* Volumetric Efficiency *) (* OldName: rLieferGMotor; Cycle: 2 *)
		iPassLevel : INT; (*pass level actual*) (*OldName:ucPassLevel; Cycle:5;*)
		tT_CnrdBearing_SplOil : ARRAY[0..10]OF HALioAi_Type; (* AI Splashoil temperature *) (*OldName:newPV; Cycle:5*)
		rPr_PCGT_Out : REAL; (*Warning measuring signal failure - gas pressure after pre chamber gas pressure regulator*) (* OldName: *)
		iSA_PICurGrad : ARRAY[0..24]OF INT; (* port injection close current gradient *) (* OldName:new PV; Cycle: *)
		tMCB_On : HALioDi_Type; (* DI mains circuit breaker closed *) (*OldName:MCB_ON; Cycle:5*)
		tMS_PBC14 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 14 *) (* OldName:DMR_md14; Cycle:2 *)
		tMS_PBC15 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 15 *) (* OldName:DMR_md15; Cycle:2 *)
		rNOx_NOxS_EngOut : REAL; (*NOx sensor at engine outlet - actual NOx value with offset [ppm]*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		rNOx_NOxS_EngOut_A : REAL; (*NOx sensor at engine outlet bank A - actual NOx value with offset [ppm]*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		rNOx_NOxS_EngOut_B : REAL; (*NOx sensor at engine outlet bank B - actual NOx value with offset [ppm]*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		rNOx_NOxS_CatOut : REAL; (*NOx sensor at catalyst outlet - actual NOx value with offset [ppm]*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		rO2_NOxS_EngOut : REAL; (*NOx sensor at engine outlet - actual O2 value with offset [Vol%]*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		rO2_NOxS_EngOut_A : REAL; (*NOx sensor at engine outlet bank A - actual O2 value with offset [Vol%]*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		rO2_NOxS_EngOut_B : REAL; (*NOx sensor at engine outlet bank B - actual O2 value with offset [Vol%]*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		rO2_NOxS_CatOut : REAL; (*NOx sensor at catalyst outlet - actual O2 value with offset [Vol%]*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		iNum_CPP_Int : ARRAY[0..24]OF INT; (*Cylinder peak pressure integrator level*) (* OldName:new PV; Cycle: *)
		tPr_GR_II : HALioAi_Type; (*AI Gas Pressure in Gas Rail number 2 [bar]*) (* OldName: AIPressGasRail2_TC1; Cyclic: 1; *)
		tPr_GR_I : HALioAi_Type; (*AI Gas Pressure in Gas Rail number 1 [bar] *) (* OldName: AIPressGasRail	; Cyclic: 1; *)
		tPr_PCGT_Out : HALioAi_Type; (*AI Warning measuring signal failure - gas pressure after pre chamber gas pressure regulator*) (* OldName: AI_p_PCGT_Out; Cyclic: 2; *)
		tPr_Ch_P2s_A : HALioAi_Type; (*charge pressure p2' after throttle valve A [bar]*) (*OldName: AI_PressP2s_A_TC1, AIPressP2s_A, ssPressP2s_A, rPressP2s_A; Cycle: 1;*)
		tPr_Ch_P2s_B : HALioAi_Type; (*charge pressure p2' after throttle valve B [bar]*) (*OldName: AI_PressP2s_B_TC1, AIPressP2s_B, ssPressP2s_B, rPressP2s_B; Cycle: 1;*)
		tPr_Ch_P2s : HALioAi_Type; (*charge pressure p2' after throttle valve [bar]*) (*OldName: AI_PressP2_TC1, ssPressP2WE, pl_ist, LDRIST, ANA.LDRIST; Cycle: 1;*)
		rHiCtr_Misf_Int : ARRAY[0..24]OF REAL; (* High Controller Misfire integrator *) (* OldName: newPV; Cycle: 2;*)
		szEng_Motorversion : STRING[17]; (* Para: Engine version *) (* OldName:newPv; Cycle: *)
		r_PhaseAng : REAL; (*mechanical phase angle in degree*) (*OldName: fPhaseAngle;*)
		r_PhaseAng_Stat : REAL; (* statischer Polradwinkel [°el] *) (* OldName: r_PolarWheelAng_GC; Cycle: 2 *)
		tMS_PBC0 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 0 *) (* OldName:DMR_md14; Cycle:2 *)
		tMS_PBC1 : ARRAY[0..12]OF _tSAFImdatas; (* Pressure based control measuring data 1 *) (* OldName:DMR_md15; Cycle:2 *)
		KLS_md00 : ARRAY[0..12]OF _tSAFImdatas; (* KLS mdatas 0 *)
		KLS_md01 : ARRAY[0..12]OF _tSAFImdatas; (* KLS mdatas 1 *)
		rLamSteadyState : REAL; (* Steady State Lambda - Ausgang GEN2 *)
		rVNValue : ARRAY[0..24]OF REAL; (* cylinder values for valve noise *) (* OldName: Fenst2; Cycle: 0 *)
		rKnck_Noise : ARRAY[0..24]OF REAL; (* cylinder value for knocking noise *) (* OldName: Fenst1; Cycle: 0 *)
		bGen2_NetP_ena : BOOL; (* GEN2 controller for grid mode activated *)
		rGT_RatioMix_TC2 : REAL; (*Gas mixture rate after ramp fub [%], e.g. 0.5 = 50%*) (* OldName: 	ssRatioMix	; Cyclic:2; *)
		bRelEngOp_Aux : BOOL; (* release engine operation from auxiliaries with dropout delay *) (*OldName:T6; Cycle:5*)
		rKnck_Intgr_Max : REAL; (* maximum integrated knock value *) (* OldName: IntKlopfMx ; Cycle: 2 *)
		rMisf_Intgr : REAL; (* integrator electrical misfires [0..1] *) (* OldName: ssMisfInt; Cycle: 2 *)
		iFastStart : USINT; (* Type of Start: 0=normal start, 1=fast start, 2=very fast start, 5=5min start *)
		rCA_IgnP_Avg : REAL; (*Average ITP [°/KW]*)
		bZylAusfallTP : BOOL; (* 1s long pulse if a cylinder starts burning again *)
		tPr_PCG_GC_Dem : HALioDo_Type; (*DO	 Demand pre champer gas compressor *) (* OldName: 	A_VKGV	; Cyclic: ; *)
		bGen2_island_ena : BOOL; (*Enables Gen2 in Island mode*)
		xGen2_LQR_x_sp0 : REAL;
		xGen2_LQR_x_sp1 : REAL;
		xGen2_LQR_x_sp2 : REAL;
		xGen2_LQR_x_k0 : REAL;
		xGen2_LQR_x_k1 : REAL;
		xGen2_LQR_x_k2 : REAL;
		xGen2_LQR_Ke : REAL;
		xGen2_LQR_Ke0 : REAL;
		xGen2_LQR_K_LQR0 : REAL;
		xGen2_LQR_K_LQR1 : REAL;
		xGen2_LQR_K_LQR4 : REAL;
		xGen2_LQR_K_LQR5 : REAL;
		xGen2_LQR_K_LQR8 : REAL;
		xGen2_LQR_K_LQR9 : REAL;
		xGen2_LQR_Phi3 : REAL;
		xGen2_LQR_Phi6 : REAL;
		xGen2_LQR_H6 : REAL;
		xGen2_LQR_H9 : REAL;
		tPos_Act_TV : HALioAi_Type; (*AI: throttle valve bypass valve position*)
		iU_SAFI_Win3 : ARRAY[0..24]OF INT; (* Outlet valve closure noise *) (* OldName: newPV; Cycle:6; *)
		iU_SAFI_Win4 : ARRAY[0..24]OF INT; (* Inlet valve closure noise *) (* OldName: newPV; Cycle:6; *)
		iCA_SAFI_Win3 : ARRAY[0..24]OF UINT; (* Outlet valve closure timing *) (* OldName: newPV; Cycle:6; *)
		iCA_SAFI_Win4 : ARRAY[0..24]OF UINT; (* Inlet valve closure timing *) (* OldName: newPV; Cycle:6; *)
		bLX2_LGM_block : BOOL; (*Block LGM bit from LX2*)
		rPr_P2sGen2_GasQualOffs : REAL; (* GEN2: boost pressure offset gas quality change [bar]*)
		rIHR : ARRAY[0..24]OF REAL; (* integral heat release from SAFI *)
		rLam_PBC : REAL; (* lambda determined by the in cylinder pressure sensor *)
		rLam_LamCtrPBC_ref : REAL; (* lambda reference from lambda controller PBC *)
		tU_Bus_L3_1 : ARRAY[0..2]OF HALioAi_Type; (* Line voltage bus bar 3 1 *) (*OldName:ssBusVoltPh3_1; Cycle:5*)
		tU_Bus_L2_3 : ARRAY[0..2]OF HALioAi_Type; (* Line voltage bus bar 2 3 *) (*OldName:ssBusVoltPh2_3; Cycle:5*)
		tU_Bus_L1_2 : ARRAY[0..2]OF HALioAi_Type; (* Line voltage bus bar 1 2 *) (*OldName:ssBusVoltPh1_2; Cycle:5*)
		iCyl_CombAnomaly : USINT; (* Cylinder no. with combustion anomaly detection *)		
		bGridStat_GridLoss : BOOL; (* Grid status detection: grid loss detected *)
		tU_Gen_Exc : HALioAi_Type; (*actual excitation voltage signal, filtered and scaled*)
		tPr_EG_Deflag_Fast_TC2 : HALioAi_Type; (*Exhaust gas pressure fast (deflagration detection) (P.02-PI-010)*) (*Cycle: 2*)
		bEleStarter_Dem_PurgeCrkCyl : BOOL; (*starter demand during purge cranking cycle*)
		bSt_RelAuxOff_STT_op : BOOL; (*Starter temperature release off for CBM*)
	END_STRUCT;
	OUT_CB_Struct : 	STRUCT 
		tCB2PB : MM2ParaBase_type; (*Data exchange structure to ParaBase*) (*OldName:new PV; Cycle:5;*)
		tCB2AB : MM2AmmBase; (*AMM structure*) (*OldName:new PV; Cycle:5;*)
		bFrictIMEP_Condition_On : BOOL; (* TRUE --> IMEP based friction monitoring is active *)
	END_STRUCT;
	MM2VIS_Struct : 	STRUCT  (*OPC variables from module to VIS*)
		rTi_Prep : ARRAY[0..2]OF REAL;
		rTi_Speedup : ARRAY[0..2]OF REAL;
		rTi_Load : ARRAY[0..2]OF REAL;
		rTi_Start : ARRAY[0..2]OF REAL;
		rTi_Sync : ARRAY[0..2]OF REAL;
		iCnt_Starts : INT;
		rStartReli : REAL;
		bSync : BOOL;
		bNOx : BOOL;
		bLoad : BOOL;
		rTi_SumSync : REAL;
		rTi_SumNOx : REAL;
		rTi_SumLoad : REAL;
		rE_SinceStart : REAL;
		iDays_SinceStart : INT; (* Counter for Days*)
		rHours_SinceStart : REAL; (* Counter for Hours*)
		rTi_Stat_Max : REAL;
		rP_Ramp_Set : REAL;
		rP_Ramp_Act : REAL;
		rP_Targ_LastStart : REAL;
		bShowStartBar : BOOL;
		iColor_Scav : INT;
		iColor_PreLube : INT;
		iColor_GasLeak : INT;
		iColor_SlowTurn : INT;
		iColor_SpeedUp : INT;
		iColor_Idle : INT;
		iColor_GCB : INT;
		iIdx_CylColor : ARRAY[0..24]OF INT; (* Colormap for J920 engine health*)
		bScreen_Stat : BOOL;
		bScreen_CBM : BOOL;
		iATD_Info1 : USINT; (* ATD Info line *)
		iATD_Info2 : USINT; (* ATD Info line *)
		bMsg2308 : BOOL; (* Trip: IMEP based friction monitoring *) (* OldName: new PV; Cycle: 0 *)
		bFrictIMEP_Condition_On : BOOL; (* TRUE --> IMEP based friction monitoring is active *)
		bMsg2926 : BOOL := 0; (*B2926 additional information form ATD available*)
		bMsg2293 : BOOL := 0; (*A2293 GEN2 Lambda monitoring: gradient exceeded *)
		bMsg9223 : BOOL := 0; (*W9223 GEN2 Lambda monitoring: gradient exceeded *)
		iCnt_Knock_Int : ARRAY[0..24]OF UDINT; (* Error counter for knock integrator exceed limit *) (* OldName: new PV; Cycle: 2 *)
		iCnt_Knock_Lim : ARRAY[0..24]OF UDINT; (* Error counter for knock signal exceed limit *) (* OldName: new PV; Cycle: 2 *)
		iCnt_Knock_Lim_Filt : ARRAY[0..24]OF UDINT; (* Error counter for filtered knock signal exceed limit *) (* OldName: new PV; Cycle: 2 *)
		iCnt_Misf_I : ARRAY[0..24]OF UDINT; (* Error counter for misfire 10° after firing top dead centre *) (* OldName: new PV; Cycle: 2 *)
		iCnt_Misf_II : ARRAY[0..24]OF UDINT; (* Error counter for misfire 40° after firing top dead centre *) (* OldName: new PV; Cycle: 2 *)
		iCnt_GlowIgn : ARRAY[0..24]OF UDINT; (* Error counter for glowignition *) (* OldName: new PV; Cycle: 2 *)
		iCnt_SensErr : ARRAY[0..24]OF UDINT; (* Error counter for sum of any incylinder pressure sensor failure *) (* OldName: new PV; Cycle: 2 *)
		iCnt_SensFailure : ARRAY[0..24]OF UDINT; (* Error counter for incylinder pressure sensor measurement signal failure *) (* OldName: new PV; Cycle: 2 *)
		iCnt_MemBurst : ARRAY[0..24]OF UDINT; (* Error counter for membran burst *) (* OldName: new PV; Cycle: 2 *)
		iCnt_CompLineCheck : ARRAY[0..24]OF UDINT; (* Error counter for compression line check *) (* OldName: new PV; Cycle: 2 *)
		iCnt_NegPresCheck : ARRAY[0..24]OF UDINT; (* Error counter for negative pressure check *) (* OldName: new PV; Cycle: 2 *)
		iCnt_PresSlopeCheck : ARRAY[0..24]OF UDINT; (* Error counter for pressure slope check *) (* OldName: new PV; Cycle: 2 *)
		iCnt_SlowDriftCheck : ARRAY[0..24]OF UDINT; (* Error counter for slow drift check *) (* OldName: new PV; Cycle: 2 *)
		iCnt_PmaxLimReached : ARRAY[0..24]OF UDINT; (* Error counter for pmax limit of hirachy controller exceed *) (* OldName: new PV; Cycle: 2 *)
		iCnt_NegVoltCheck : ARRAY[0..24]OF UDINT; (* Error counter for negative voltage check *) (* OldName: new PV; Cycle: 2 *)
		iCnt_ConfNotOK : ARRAY[0..24]OF UDINT; (* Error counter for configuration not okay *) (* OldName: new PV; Cycle: 2 *)
		iCnt_InvalidPar : ARRAY[0..24]OF UDINT; (* Error counter for invalid parameter *) (* OldName: new PV; Cycle: 2 *)
		iCnt_LimpHome : ARRAY[0..24]OF UDINT; (* Error counter for limp home *) (* OldName: new PV; Cycle: 2 *)
		iCnt_OptiFreeze : ARRAY[0..24]OF UDINT; (* Error counter for optimizer freeze *) (* OldName: new PV; Cycle: 2 *)
		iCnt_CPSSat : ARRAY[0..24]OF UDINT; (* Error counter for cylinder pressure sensor saturation *) (* OldName: new PV; Cycle: 2 *)
		rTi_Starter : ARRAY[0..2]OF REAL;
		rN_Starter : ARRAY[0..2]OF REAL;
		rUnknown : REAL;
		rCold : REAL;
		rWarm : REAL;
		rHot : REAL;
		TCB : MM2VIS_CBM;
		ECB : MM2VIS_CBM;
		Stat : MM2VIS_CBM;
		ErrCnt : MM2VIS_CBM;
		bLam_Mon_DiagAct : BOOL;
		rLam_Mon_Grad : REAL;
		rLam_Mon_TexhMin : REAL;
		rLam_Mon_TexhAvg : REAL;
		rCA_MFB10 : ARRAY[0..24]OF REAL; (* 10% of fuel mass burned *) (* OldName: usUmstzpkt10P; Cycle: 2 *)
		rCA_MFB90 : ARRAY[0..24]OF REAL; (* 90% of fuel mass burned *) (* OldName: usUmstzpkt90P; Cycle: 2 *)
		bECBMem_isCreated : BOOL; (* bit is set when new ECBMMem is created *)
		bTCBMem_isCreated : BOOL; (* bit is set when new TCBMMem is created *)
		bStat_isCreated : BOOL; (* bit is set when new Statistic File is created *)
	END_STRUCT;
	MM2VIS_CBM : 	STRUCT 
		bWarn : BOOL; (* something went wrong, only TCB and ECB *)
		bBuff : BOOL; (* is buffering? only TCB and ECB *)
		bScreen : BOOL; (* Displayes screen for function *)
		bSave : BOOL; (* Displayes the save progress *)
		rSave : REAL; (* Save progress 0 to 1 *)
		bLock : BOOL; (* Locks the write Trigger *)
		iStep : INT; (* State Machine index *)
	END_STRUCT;
	VIS2MM_Struct : 	STRUCT  (*OPC variables from module to VIS*)
		iPassLevel : INT; (*Actual DIA.NE VIS user level*) (*OldName:ucPassLevel; Cycle:;*)
		bATD_Ackn : BOOL; (* ATD acknowledge button *)
		TCB : VIS2MM_CBM;
		ECB : VIS2MM_CBM;
		Stat : VIS2MM_CBM;
		ErrCnt : VIS2MM_CBM;
		iStatShow : INT;
		bECBMem_isRead : BOOL; (* bit is set when new ECBMMem is read by HMI *)
		bTCBMem_isRead : BOOL; (* bit is set when new TCBMMem is read by HMI *)
		bStat_isRead : BOOL; (* bit is set when new Statistic File is read by HMI *)
	END_STRUCT;
	VIS2MM_CBM : 	STRUCT 
		bTrig : BOOL; (* set trigger *)
		rRemain : REAL; (* set trigger offset: cycles or time, only ECB and TCB *)
		bReset : BOOL; (* resets the data, only Stat and ErrCnt*)
	END_STRUCT;
	PARA_CB_Struct : 	STRUCT 
		iEng_Motortype : INT; (* Para: engine type *) (* OldName: 0; Cycle: 2 *)
		b_IgnIC_900Active : BOOL; (* Para: TRUE = CAN ignition system is used *) (* OldName: 0; Cycle: 0 *)
		bTJ_Exist : BOOL; (* TRUE=gas inject valves are active *) (* OldName: bTecJetOn ; Cycle: 2 *)
		iN_GMU_Devices : INT; (*Para: Number of installed gas metering devices*) (*OldName: ucNrOfTJ; Cycle: 5*)
		iIdx_NOxS_Config : INT; (*PARA: NOx  Sensor configuration*) (*OldName: new PV; Cycle:5*) (*V04.05.00.00*)
		bTSTC_Exist : BOOL; (* TRUE = two stage turbo charger is assembled *) (* OldName: 0; Cycle: 2 *)
		bSA_PBC_Active : BOOL; (* Para: TRUE = SAFI PBC function is enabled/active  *) (* OldName: bSAFIDMR_Act; Cycle: 2 *)
		bSA_PI_Active : BOOL; (* Para: TRUE = SAFI port injection is enabled/active  *) (* OldName: bSAFIPI_Act; Cycle: 2 *)
		bSA_Ign_Active : BOOL; (* Para: TRUE = SAFI ignition function is enabled/active *) (* OldName: bSAFIIgn_Act; Cycle: 2 *)
		rN_EngNom : REAL; (* Para: nominal engine speed *) (* OldName: n_nenn ; Cycle: 2 *)
		bMFB50Contr_Ena : BOOL; (* Para: Enables MFB50 Controller *) (*OldName: new PV; Cycle:2*)
		rKno_IP_Red_StP : REAL; (* Para: start point for ignition point reduction for knocking *) (* OldName: kl_dz_li; Cycle: 2 *)
		rPr_PBC_Knck_Lim : REAL; (* Para: Knock Limit Pressure *) (* OldName: KlopfLimitDMR; Cycle: 2 *)
		bExistWasteGate : BOOL; (* activation flag for static wastegate control *) (* OldName: bExistWasteGate; Cycle: 2 *) (**GEN2_Diag**)
		mp_a : ARRAY[0..4]OF _tMeasurePoint; (* leanox line meassure point 1 *) (* OldName: mp_a; Cycle: 2 *)
		mp_b : ARRAY[0..4]OF _tMeasurePoint; (* leanox line meassure point 2 *) (* OldName: mp_b; Cycle: 2 *)
		rCA_Ign_OP_Start : ARRAY[0..4]OF REAL; (*  ingnition point for start mode *) (* OldName: zzp_start ; Cycle: 2 *)
		rCA_Ign_OP_Power : ARRAY[0..4]OF REAL; (* ingnition point for power mode *) (* OldName: zzp ; Cycle: 2 *)
		rCA_Ign_OP_Speed : ARRAY[0..4]OF REAL; (* ingnition point for speed mode *) (* OldName: zzp_insel ; Cycle: 2 *)
		tLeanox_Comp_IgnP : _tRLinear; (* Para: leanox setpoint compenstation because of ignition point changes  *) (* OldName: ScaleDZZP; Cycle: 2 *)
		bZZPKorr : BOOL; (* TRUE = timing point controller on *) (* OldName: 0; Cycle: 2 *)
		bt2Korr : BOOL; (*  TRUE = mixture temp. comp. On *) (* OldName: 0; Cycle: 2 *)
		bDrehzkorr : BOOL; (* TRUE=speed compensation on *) (* OldName: bDrehzkorr ; Cycle: 2 *)
		tLeanox_Comp_ChTmp : _tRLinear; (* Para: leanox setpoint compenstation because of charge temperature *) (* OldName: ScaleDPT; Cycle: 2 *)
		rP_Eng_Frict : REAL; (* engine friction power *) (* OldName: ssPreib ; Cycle: 2 *)
		rP_Nom_Gastype : ARRAY[0..4]OF REAL; (* engine nominal power *) (* OldName: p_nenn ; Cycle: 2 *)
		rGen_Inertia : REAL; (* generator inertia *) (* OldName: JGenerator ; Cycle: 2 *)
		rF_Nom : ARRAY[0..2]OF REAL; (* Para: nominal frequency [48..62Hz] *) (* OldName: usFreqNenn[1]; Cycle: 2 *)
		rI_GenNom : ARRAY[0..2]OF REAL; (* Para: nominal current generator [0..65kA] *) (* OldName:usINennGen; Cycle: 2 *)
		rU_Gen_Nom : ARRAY[0..2]OF REAL; (* Para: nominal voltage generator [70V..65kV] *) (* OldName:usUNennGen; Cycle: 2 *)
		bFMEP_enable : BOOL; (* Para: TRUE = IMEP based friction monitoring is enabled *) (* OldName: new PV ; Cycle: 2 *)
		bMMD2_Act : BOOL; (* Para: Activation of 2nd MMD device *) (* OldName:bMMU2Act; Cycle: *)
		rF_DiffMin : ARRAY[0..2]OF REAL; (* Para: maximum frequence difference (negative) [-0,49..0,00Hz] *) (* OldName:ssFreqDiffMin; Cycle: *)
		rF_DiffMax : ARRAY[0..2]OF REAL; (* Para: maximum frequence difference (positive) [0,02..0,49Hz] *) (* OldName:usFreqDiffMax; Cycle: *)
		rU_DiffMax : ARRAY[0..2]OF REAL; (* Para: maximum voltage difference [0,1% - 30% usUNennSync] *) (* OldName:usUDiffMax; Cycle: *)
		rAng_DiffMax : ARRAY[0..2]OF REAL; (* Para: maximum phase shift [0..60°] *) (* OldName:usPhiDiffMax; Cycle: *)
		bTCBMem_Ena : BOOL; (* TCBMem aktiv *) (* OldName: 0; Cycle: 2 *)
		bECBMem_Ena : BOOL; (* ECBMem aktiv *) (* OldName: 0; Cycle: 2 *)
		bSStat_Ena : BOOL; (* Start Statistik aktiv *) (* OldName: 0; Cycle: 2 *)
		iDailyTrigger_Ena : INT; (* Daily Trigger *) (* OldName: 0; Cycle: 2 *)
		bLam_Mon_Act : BOOL; (* Para: activation OF Lambda monitoring trip*)
		rScal_Lam_Mon_Limit : REAL; (* Para: GEN2 Scaling of Lambda monitoring Trip Threshold *)
		rScal_Lam_Mon_Delay : REAL; (* Para: GEN2 Lambda monitoring activation delay *)
		bSA_KLS_Active : BOOL; (* Para: TRUE = SAFI KLS function is enabled/active *) (* OldName:bSAFIKLS_Act; Cycle: *)
		bLam_Mon_Act_Ramps : BOOL; (* Para: GEN2 Lambda monitoring activated during power ramps *)
		rPr_P2s_Set_LX_0kW : ARRAY[0..4]OF REAL; (* Para: Charging pressure setpoint at 0kW *) (*OldName: ssResPara198; Cycle:2*)
		usGasDensN : ARRAY[0..4]OF INT; (*Para: Nominal gas density *) (*OldName: usGasDensN; Cycle: 5*)
		rMin_Air_Ratio : ARRAY[0..4]OF REAL; (* min. required air rate of gassort  *) (* OldName: uslmin ; Cycle: 2 *)
		usHu : ARRAY[0..4]OF UINT; (* caloric value of gassort *) (* OldName: usHu; Cycle: 2 *)
		bECB_Trig_Alarm : BOOL; (* Para: Enable ECB Trigger: Alarm Prio 1-3 *)
		bECB_Trig_GC : BOOL; (* Para: Enable ECB Trigger: Gridcode event *)
		bECB_Trig_LGM : BOOL; (* Para: Enable ECB Trigger: Lambda Gradient Monitor event *)
		bECB_Trig_Misf : BOOL; (* Para: Enable ECB Trigger: Misfire event *)
		bECB_Trig_SFKW : BOOL; (* Para: Enable ECB Trigger: Sensor Failure in Knocking Window event *)
		bTCB_Trig_Alarm : BOOL; (* Para: Enable TCB Trigger: Alarm Prio 1-3 *)
		bTCB_Trig_GC : BOOL; (* Para: Enable TCB Trigger: Gridcode event *)
		bTCB_Trig_LGM : BOOL; (* Para: Enable TCB Trigger: Lambda Gradient Monitor event *)
		bTCB_Trig_MCB : BOOL; (* Para: Enable TCB Trigger: Mains circuit breaker open/close *)
		bTCB_Trig_GCB : BOOL; (* Para: Enable TCB Trigger: Generator circuit breaker open/close *)
		bLam_Mon_ECBTCB_Ramps : BOOL; (* Para: GEN2 Lambda monitoring: write files only (don't initiate a trip) during power ramps (only if detection is allowed during ramps) *)
		bSEMIC_Active : BOOL; (*PARA[14519]: Ignition controller SEMIC*)
		bTCB_Trig_GSD : BOOL; (* Para [15014]: Enable TCB Trigger: Grid status detection event *)
		bPr_OXIcat_In_Fast_Exist : BOOL; (*PARA [14132]: OXIcat Exhaust gas inlet pressure fast active*)
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
	MM2ACE_Struct : 	STRUCT  (* OPC variables from module to analytics and controller extension *)
		bDummy_MM2ACE : BOOL;
		iDummy_MM2ACE : INT;
		RDummy_MM2ACE : REAL;
		bCBM_1_Run : BOOL; (* PH_CBM_1 Task is running *)
		bCBM_2_Run : BOOL; (* PH_CBM_2 Task is running *)
		bCBM_3_Run : BOOL; (* PH_CBM_3 Task is running *)
		bCBM_4_Run : BOOL; (* PH_CBM_4 Task is running *)
	END_STRUCT;
	ACE2MM_Struct : 	STRUCT  (* OPC variables from analytics and controller extension to module *)
		bDummy_ACE2MM : BOOL;
		iDummy_ACE2MM : INT;
		RDummy_ACE2MM : REAL;
		iACE_Taskmode_Cmd : UINT; (* set the taskmode from analytics and controller extention  *)
	END_STRUCT;
	_tMeasurePoint : 	STRUCT 
		P : INT;
		t : REAL;
		w : INT;
		n : INT;
	END_STRUCT;
	_tRLinear : 	STRUCT 
		x1 : REAL;
		y1 : REAL;
		x2 : REAL;
		y2 : REAL;
	END_STRUCT;
	_tSAFImdatas : 	STRUCT 
		data1 : UINT;
		data2 : UINT;
		data3 : UINT;
	END_STRUCT;
	Perm_CBM_Struct : 	STRUCT 
		bFMEP_Fault_Dtct_Save : BOOL; (*service mode counter operating hours*)
		bSpare_2 : BOOL; (*Spare*)
		bSpare_3 : BOOL; (*Spare*)
		bSpare_4 : BOOL; (*Spare*)
		bSpare_5 : BOOL; (*Spare*)
		iSpare_1 : UDINT; (*Spare*)
		iSpare_2 : UDINT; (*Spare*)
		iSpare_3 : UDINT; (*Spare*)
		iSpare_4 : UDINT; (*Spare*)
		iSpare_5 : UDINT; (*Spare*)
		rSpare_1 : REAL; (*Spare*)
		rSpare_2 : REAL; (*Spare*)
		rSpare_3 : REAL; (*Spare*)
		rSpare_4 : REAL; (*Spare*)
		rSpare_5 : REAL; (*Spare*)
	END_STRUCT;
END_TYPE
