(*******************************************************************************
AGGR: read AND write IO channels	(init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2025

- read out data module with IO configuration
- call fubs TO copy IO data from IN AND TO OUT structures

Customized modifications: -
------------------------
 
History:
-------
V3.99	27-01-2014	Weitzer, generated FOR modular software
V4.00	14-02-2014	Weitzer, change version number
		17-04-2014	Weitzer, add IO channels	
		17-04-2014	Weitzer, add IO channels
V4.01	22-07-2014	Weitzer, change version number
						   , add IO channels
V4.03	14.01.2015	Weitzer, new IOs added for J920	
		29.07.2015	plattner/lettenb., new IOs added for NLD/BEL
		01.06.2016	lettenb. LOS_Dem added, bugfix
V4.04.0	09.05.2016	lettenb. new IOs added for J920
V4.04.0 27.09.2016  Stary,   added IOs for new functions
		06-10-2016	Perktold,changed ERDF to DEIE
		22.10.2016  Stary,   added IO's for fire-protection flap
		05.12.2016	lettenb. IO's added
V4.05.0 05.04.2017	lettenb. IO's added
		04.12.2017	Weitzer	 SAFI MPM monitoring and SPAX cam monitoring added
		11.12.2017	lettenb. gridcode logic added
V4.05.1 14.02.2018	Weitzer, EOP_BWS2 added
V4.05.2 26.03.2018	Farre, 	 Signals removed (PF_CosPCtr_PF1_Ena, PF_CosPCtr_PF2_Ena, PF_CosPCtr_PF3_Ena, PF_CosPCtr_PF4_Ena, PF_CosPCtr_PF5_Ena)
V4.06.0 01.03.2018	Perktold, I/Os for (very)fast start added
V4.07.0	12.07.2018	Hohensinner,	Added G2 Signals
		09.08.2018	Schmid	 2nd low temperature charge cooling circuit added
		04.09.2018	Denk		Pr_GasRail deleted, never used 	
		20.09.2018	Schmid	 unused IOs deleted
		31.10.2018	lettenb. MidVoltCB_Failure new 
		17.12.2018	Schmid	 IOs for hydraulic ECW pre-heating for type 3+4 added
		21.12.2018	Arnold	 IOs for single flow wastegate
		08.01.2019	Schmid	 IOs for redundant pump control added
		10.01.2019	Schmid	 IOs for boiler failure and seismic alarm added
		14.01.2019	Schmid	 Pr_EG_Deflag_Fast (deflagration detection) fully replaces Pr_OXIcat_In_Fast
		23.01.2019 	Tinello, SCR: 2 DI's from customer added
		20.03.2019	Hohensinner,	DI: external controller okay signal added (e.g. ComAp)
V4.07.1 29.03.2019	Hohensinner,	Added IO: Execute_BS, removed IOs: P_Limit<x>Son_Gh
V4.09.0 27.06.2019	Denk, 	 		Added IO's: T_GT_NG, Pr_GT_NG, Vol_GT_NG
V4.10.0	20.07.2020	Schmid	 Added IO's: T_HW_EGHE_Hi, T_HW_EGCD_Hi, Cust_HW_Ext_Trip
		12.11.2020	lettenb.		IOs for GR added
V4.10.1 10.05.2021	Weitzer	 System cyclic time viaolation monitoring added, Exception tasks Except151-155 deleted
V4.11.0	16.08.2021	Weitzer	 add UR20 IO system	
V4.11.0	29.11.2021	lettenb. IOs for GR added
V4.12.0 29.06.2022	lettenb. new IO added
		17.11.2022	Zengerer new IO added
		22.01.2023  Zuschnig Added H2 content AI	
		25.01.2025	shifted some parts to new tasks in slower cyclics
V4.13.0 04.07.2023	Perktold	added positive zero crossings for generator voltage
		27.08.2023	Bacci		removed IO: OQS_Conduct, OQS_Dielect, OQS_Temp, OQS_Visco
		19.10.2023	Heim Markus add DI BurstingDisk1_Ok and BurstingDisk2_Ok
		20.11.2023	Bacci		new IOs added: U_Starter_engage1, U_Starter_engage2, U_Starter_engage3
		21.11.2023	Tinello		added urea tank level
		28.11.2023	Maran		added IOs for thermal reactor auxiliary gas injection monitoring
		30.11.2023	Farre, 	 	Added ILF (de)activation bits
V4.14.0	08.11.2024	Bacci		new IOs added: ECW_ShutOffVal_Dem, ValHeater_Dem, FanRingHeater_Dem
		21.11.2024	Farre		additional moisture sensor in air line CEMS (2023-183)
		22.11.2024	Schmidt, 	added IO for pre chamber gas bypass valve: PCG_BPV_Open
		27.11.2024	Maran 	 	added IOs for thermal reactor 2
		29.11.2024 	Zengerer 	add OilFill EO_FreshOilPump... 
		06.12.2024	Zuschnig	added IOs for hydrogen gas train
		03.02.2025	Tinello		added SafetyPLC
V4.25.0 26.11.2025	Bacci		Safety Function - Insufficient Ventilation (2024-202): ERV digital feedback added
		17.12.2025	Tinello		added SafetyPLC Phase II 

Instructions FOR use:
--------------------
- 

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT
	
	(* set INIT values *)
//	bDebugNoEventLog := TRUE;		//PPC900 Bugfix - Enable for PPC900   - FEHLT NOCH

	cfgModName		 := 'IOcfg';
			
	adrHALioSignal	 := ADR(xHALioSignal[0]);
	appModName		 := 'HalIO';
	MaxNumIoChannels := UDINT_TO_UINT(SIZEOF(xHALioSignal)/SIZEOF(xHALioSignal[0]));
	callHALioCfg	 := TRUE;

	xHALioCfg.enable			:= TRUE;
	xHALioCfg.pCfgModDevice		:= 0;
	xHALioCfg.pCfgModName		:= ADR(cfgModName);
	xHALioCfg.pAppModName		:= ADR(appModName);
	xHALioCfg.pHALioSignal		:= adrHALioSignal;
	xHALioCfg.MaxNumIoChannels	:= MaxNumIoChannels;
	REPEAT
		xHALioCfg();
		UNTIL xHALioCfg.status <> halERR_FUB_BUSY
	END_REPEAT;
	
	ParOK				:= xHALioCfg.ParOK;
	ActNumIoChannels	:= xHALioCfg.ActNumIoChannels;
	statusHALioCfg		:= xHALioCfg.status;
	
	IF ActNumIoChannels > 0 THEN
		FOR idx := 0 TO (ActNumIoChannels - 1) DO
			curTaskClass := xHALioSignal[idx].TaskClass;
			xHALioSignals[curTaskClass, xHALioSignalsCount[curTaskClass]] := xHALioSignal[idx];
			xHALioSignalsCount[curTaskClass] := xHALioSignalsCount[curTaskClass] + 1;
		END_FOR
	END_IF
	
	ErrInfo1 ACCESS xHALioCfg.pErrInfo1;
	ErrInfo2 ACCESS xHALioCfg.pErrInfo2;
	ErrInfo3 ACCESS xHALioCfg.pErrInfo3;

	callHALioSignal		:= TRUE;
	
	
	(* mA analog signal values *)
	
	(* general *)
	W_0mA;
	
	(* X20 *)
	W_2mA;
	W_3mA;
	W_4mA;
	W_20mA;
	
	(* UR20 *)
	W_2mA_UR20;
	W_3mA_UR20;
	W_4mA_UR20;
	W_20mA_UR20;
	W_20_5mA_UR20;		
		
	(* list of available IO channels *)				
					
	(* PLANT CONTROL PANEL *)				
					
	(**AmmBase**)				
	ResetWarning;			tResetWarning;
	ResetTrip;				tResetTrip;
	MonitoringOn;			tMonitoringOn;
	GnlTrip;				tGnlTrip;
	GnlWarning;				tGnlWarning;
					
	(**Grid**)				
	PF_GenC_SOn;			tPF_GenC_SOn;
	PF_GenC_SOf;			tPF_GenC_SOf;
	PF_GenC_Fix1SOn;		tPF_GenC_Fix1SOn;
	PF_GenC_Fix2SOn;		tPF_GenC_Fix2SOn;
	PF_GenC_Fix3SOn;		tPF_GenC_Fix3SOn;
	PF_GenC_Fix4SOn;		tPF_GenC_Fix4SOn;
	PF_GenC_Fix5SOn;		tPF_GenC_Fix5SOn;
	Q_GenC_SOn;				tQ_GenC_SOn;
	Q_GenC_SOf;				tQ_GenC_SOf;
	Q_GenC_Fix1SOn;			tQ_GenC_Fix1SOn;
	Q_GenC_Fix2SOn;			tQ_GenC_Fix2SOn;
	Q_GenC_Fix3SOn;			tQ_GenC_Fix3SOn;
	Q_GenC_Fix4SOn;			tQ_GenC_Fix4SOn;
	Q_GenC_Fix5SOn;			tQ_GenC_Fix5SOn;
	QLim_GenC_SOn;			tQLim_GenC_SOn;
	QLim_GenC_SOf;			tQLim_GenC_SOf;
	QLim_GenC_Act;			tQLim_GenC_Act;
	QPC_GenC_SOn;			tQPC_GenC_SOn;
	QPC_GenC_SOf;			tQPC_GenC_SOf;
	QUC_GenC_SOn;			tQUC_GenC_SOn;
	QUC_GenC_SOf;			tQUC_GenC_SOf;
	PFUC_GenC_SOn;			tPFUC_GenC_SOn;
	PFUC_GenC_SOf;			tPFUC_GenC_SOf;
	QP_GenC_SOn;			tQP_GenC_SOn;
	QP_GenC_SOf;			tQP_GenC_SOf;
	P_GenC_SOn;				tP_GenC_SOn;
	P_GenC_SOf;				tP_GenC_SOf;
	P_GenC_Fix0SOn;			tP_GenC_Fix0SOn;
	P_GenC_Fix1SOn;			tP_GenC_Fix1SOn;
	P_GenC_Fix2SOn;			tP_GenC_Fix2SOn;
	P_GenC_Fix3SOn;			tP_GenC_Fix3SOn;
	P_GenC_Fix4SOn;			tP_GenC_Fix4SOn;
	P_GenC_Fix5SOn;			tP_GenC_Fix5SOn;
	PLim_GenC_SOn;			tPLim_GenC_SOn;
	PLim_GenC_SOf;			tPLim_GenC_SOf;
	PLim_GenC_Act;			tPLim_GenC_Act;
	PFC_SOn;				tPFC_SOn;
	PFC_SOf;				tPFC_SOf;
	RMC_SOn;				tRMC_SOn;
	RMC_SOf;				tRMC_SOf;
	EU_RM_BLOCK;			tEU_RM_BLOCK;
	Q_GenC_Act;				tQ_GenC_Act;
	PF_GenC_Act;			tPF_GenC_Act;
	PF_AO_PF_U;				tPF_AO_PF_U;
	P_GenC_Bloc;			tP_GenC_Bloc;
					
	(**Emission**)				
					
	(**Ventilation**)				
	Rel_ER_Fan;				tRel_ER_Fan;
	Set_ER_Fan_Min;			tSet_ER_Fan_Min;
	DemPurgeER;				tDemPurgeER;
	Rel_ER_FC;				tRel_ER_FC;
	InAirER_Fan1DemOn;		tInAirER_Fan1DemOn;
	InAirER_Fan2DemOn;		tInAirER_Fan2DemOn;
	OutAirER_LouDemOpen;	tOutAirER_LouDemOpen;
	InAirER_Lou2DemOpen;	tInAirER_Lou2DemOpen;
	InAirER_Lou1DemOpen;	tInAirER_Lou1DemOpen;
	DemERVentInLou_Cust;	tDemERVentInLou_Cust;
	ER_FC_Set;				tER_FC_Set;
	ER_DoorClosed;			tER_DoorClosed;
					
	(**HeatingCooling**)				
	ExCo_Rel;				tExCo_Rel;
	ChC_DemPump;			tChC_DemPump;
	ChC_DemFan1;			tChC_DemFan1;
	ChC_DemFan2;			tChC_DemFan2;
	ChC_DemFan3;			tChC_DemFan3;
	ChC_DemFan4;			tChC_DemFan4;
	ChC_DemFan5;			tChC_DemFan5;
	ChC_DemFan6;			tChC_DemFan6;
	ChC_DemFan7;			tChC_DemFan7;
	ChC_DemFan8;			tChC_DemFan8;
	ChC_DemFan9;			tChC_DemFan9;
	ChC_DemFan10;			tChC_DemFan10;
	ChC_DemFan11;			tChC_DemFan11;
	ChC_DemFan12;			tChC_DemFan12;
	ChC_DemFan13;			tChC_DemFan13;
	ChC_DemFan14;			tChC_DemFan14;
	ChC_DemFan15;			tChC_DemFan15;
	ChC_DemFan16;			tChC_DemFan16;
	EC_DemPump;				tEC_DemPump;
	EC_DemFan1;				tEC_DemFan1;
	EC_DemFan2;				tEC_DemFan2;
	EC_DemFan3;				tEC_DemFan3;
	EC_DemFan4;				tEC_DemFan4;
	EC_DemFan5;				tEC_DemFan5;
	EC_DemFan6;				tEC_DemFan6;
	EC_DemFan7;				tEC_DemFan7;
	EC_DemFan8;				tEC_DemFan8;
	EC_DemFan9;				tEC_DemFan9;
	EC_DemFan10;			tEC_DemFan10;
	EC_DemFan11;			tEC_DemFan11;
	EC_DemFan12;			tEC_DemFan12;
	EC_DemFan13;			tEC_DemFan13;
	EC_DemFan14;			tEC_DemFan14;
	EC_DemFan15;			tEC_DemFan15;
	EC_DemFan16;			tEC_DemFan16;
	ECW_DemBpP;				tECW_DemBpP;
	ECW_DemBpV;				tECW_DemBpV;
	Ctr_ChC_Set;			tCtr_ChC_Set;
	Ctr_HWRe_Set;			tCtr_HWRe_Set;
	Ctr_EC_Set;				tCtr_EC_Set;
	Ctr_HWSu_Set;			tCtr_HWSu_Set;
	Ctr_ChCV_Set;			tCtr_ChCV_Set;
	Ctr_ChCHP_Set;			tCtr_ChCHP_Set;
	Pr_EO_Mod_Out;			tPr_EO_Mod_Out;
	Pr_HW_Re_PreH_EO;		tPr_HW_Re_PreH_EO;
	Pr_HW_Re_LT;			tPr_HW_Re_LT;
	Pr_HW_Re_HT;			tPr_HW_Re_HT;
	Pr_HW_Re_PreH_ECW;		tPr_HW_Re_PreH_ECW;
	Pr_HW_Re_PreH_ECW;		tPr_HW_Re_PreH_ECW;
	Pr_HW_Re_PreH_ECW;		tPr_HW_Re_PreH_ECW;
	T_ECW_Mod_In;			tT_ECW_Mod_In;
	T_ECW_Mod_Out;			tT_ECW_Mod_Out;
	T_EO_Mod_In;			tT_EO_Mod_In;
	T_EO_Mod_Out;			tT_EO_Mod_Out;
	T_HW_Su_PreH_ECW;		tT_HW_Su_PreH_ECW;
	T_HW_Re_PreH_ECW;		tT_HW_Re_PreH_ECW;
	T_HW_Su_PreH_EO;		tT_HW_Su_PreH_EO;
	T_HW_Re_PreH_EO;		tT_HW_Re_PreH_EO;
	T_ECW_bChC_HT;			tT_ECW_bChC_HT;
	T_ECW_bOilC;			tT_ECW_bOilC;
	T_ECW_bECWC;			tT_ECW_bECWC;
	ChC2_DemPump;			tChC2_DemPump;
	ChC2_DemFan1;			tChC2_DemFan1;
	ChC2_DemFan2;			tChC2_DemFan2;
	ChC2_DemFan3;			tChC2_DemFan3;
	ChC2_DemFan4;			tChC2_DemFan4;
	ChC2_DemFan5;			tChC2_DemFan5;
	ChC2_DemFan6;			tChC2_DemFan6;
	ChC2_DemFan7;			tChC2_DemFan7;
	ChC2_DemFan8;			tChC2_DemFan8;
	ChC2_DemFan9;			tChC2_DemFan9;
	ChC2_DemFan10;			tChC2_DemFan10;
	ChC2_DemFan11;			tChC2_DemFan11;
	ChC2_DemFan12;			tChC2_DemFan12;
	ChC2_DemFan13;			tChC2_DemFan13;
	ChC2_DemFan14;			tChC2_DemFan14;
	ChC2_DemFan15;			tChC2_DemFan15;
	ChC2_DemFan16;			tChC2_DemFan16;
	Ctr_ChC2_Valve_Set;		tCtr_ChC2_Valve_Set;
	ChC2_FanRdy;			tChC2_FanRdy;
	ChC2_Failure;			tChC2_Failure;
	T_ChC2_Re_LT;			tT_ChC2_Re_LT;
	T_ChC2_Su_LT;			tT_ChC2_Su_LT;
	T_ChC2W_Hi;				tT_ChC2W_Hi;
	ChC2_Heating;			tChC2_Heating;
					
	(**Exhaust**)				
	EG_ByVaCoOpen;			tEG_ByVaCoOpen;
	EG_ByVaCoClose;			tEG_ByVaCoClose;
	EG_BoVaCoOpen;			tEG_BoVaCoOpen;
	EG_BoVaCoClose;			tEG_BoVaCoClose;
	ScavVaCoOpen;			tScavVaCoOpen;
	ScavVaCoClose;			tScavVaCoClose;
	ScavFanCoOn;			tScavFanCoOn;
	ScavFan_Sp;				tScavFan_Sp;
	N2_ScavGV_CoOpen;		tN2_ScavGV_CoOpen;
	N2_ScavSigLampOn;		tN2_ScavSigLampOn;
	CO2_DemCodinox;			tCO2_DemCodinox;
	CO2_FanCoOn;			tCO2_FanCoOn;
	CO2_Rdy;				tCO2_Rdy;
	CO2_MPMode;				tCO2_MPMode;
	CO2_WD;					tCO2_WD;
	CO2_Alarm;				tCO2_Alarm;
	CO2_VaCoOpen;			tCO2_VaCoOpen;
	CO2_VaCoClose;			tCO2_VaCoClose;
	T_bScavValve;			tT_bScavValve;
	T_EGbCat;				tT_EGbCat;
	T_EGaCat;				tT_EGaCat;
	Pr_OXIcat_In;			tPr_OXIcat_In;
	Pr_OXIcat_Out;			tPr_OXIcat_Out;
	Pr_EG_Deflag_Fast;		tPr_EG_Deflag_Fast;
	BurstingDisk1_Ok;		tBurstingDisk1_Ok;
	BurstingDisk2_Ok;		tBurstingDisk2_Ok;
					
	(**Oil**)				
					
	(**ThermalReactor**)				
	ThR_Contactor;			tThR_Contactor;
	ThR_CV_CDec;			tThR_CV_CDec;
	ThR_CV_CInc;			tThR_CV_CInc;
	ThR_EH11;				tThR_EH11;
	ThR_EH12;				tThR_EH12;
	ThR_EH13;				tThR_EH13;
	ThR_EH21;				tThR_EH21;
	ThR_EH22;				tThR_EH22;
	ThR_EH23;				tThR_EH23;
	ThR_EH31;				tThR_EH31;
	ThR_EH32;				tThR_EH32;
	ThR_EH33;				tThR_EH33;
	ThR_ErrLamp;			tThR_ErrLamp;
	ThR_GT_COn1;			tThR_GT_COn1;
	ThR_GT_COn2;			tThR_GT_COn2;
	ThR_RunLamp;			tThR_RunLamp;
	CtrTR_Heater_Set;		tCtrTR_Heater_Set;
	ThR_Val_Air;			tThR_Val_Air;
	ThR_Val_CCylIn;			tThR_Val_CCylIn;
	ThR_Val_CCylOut;		tThR_Val_CCylOut;
	Pos_ThR_AuxGasCV_Act;	tPos_ThR_AuxGasCV_Act;
	Pr_ThR_AuxGasBeforeCV;	tPr_ThR_AuxGasBeforeCV;
	Pr_ThR_AuxGasAfterCV;	tPr_ThR_AuxGasAfterCV;
	ThR2_EH_group1_Dem;				tThR2_EH_group1_Dem;
	ThR2_EH_group2_Dem;				tThR2_EH_group2_Dem;
	ThR2_EH_group3_Dem;				tThR2_EH_group3_Dem;
	ThR2_EH_group4_Dem;				tThR2_EH_group4_Dem;
	ThR2_EH_group5_Dem;				tThR2_EH_group5_Dem;
	ThR2_AuxGasShutOffValve_Dem;	tThR2_AuxGasShutOffValve_Dem;
	Pr_ThR2_Inlet;					tPr_ThR2_Inlet;
	Pr_ThR2_Outlet;					tPr_ThR2_Outlet;
	T_ThR2_EH_group1;				tT_ThR2_EH_group1;
	T_ThR2_EH_group2;				tT_ThR2_EH_group2;
	T_ThR2_EH_group3;				tT_ThR2_EH_group3;
	T_ThR2_EH_group4;				tT_ThR2_EH_group4;
	T_ThR2_EH_group5;				tT_ThR2_EH_group5;
	T_ThR2_LeftChamber;				tT_ThR2_LeftChamber;
	T_ThR2_RightChamber;			tT_ThR2_RightChamber;
	T_ThR2_Downstream;				tT_ThR2_Downstream;
	ThR2_T_UnitOk_LeftCh;			tThR2_T_UnitOk_LeftCh;
	ThR2_T_UnitOk_RightCh;			tThR2_T_UnitOk_RightCh;
	ThR2_T_UnitOk_Downstream;		tThR2_T_UnitOk_Downstream;
					
	(**Generator**)				
	Gen_PreHDem;			tGen_PreHDem;
	Ctr_Gen_Set;			tCtr_Gen_Set;
	CtrGenPF_Set;			tCtrGenPF_Set;
	GCB_On_ReturnSign;		tGCB_On_ReturnSign;
	LOS_Dem;				tLOS_Dem;
	LeroySomer_AuxContactor;tLeroySomer_AuxContactor;
	PF_AO_PF_I;				tPF_AO_PF_I;
	PF_AO_PF_U;				tPF_AO_PF_U;
	PF_CosPCtr_Ena;			tPF_CosPCtr_Ena;
	T_AO_Gen_T_In;			tT_AO_Gen_T_In;
	U_MidPos;				tU_MidPos;
	U_Minus;				tU_Minus;
	U_Plus;					tU_Plus;
	P_GenRev_Ext;			tP_GenRev_Ext; 
	GenLossExc_Ext;			tGenLossExc_Ext; 
	U_GenAsy_Ext;			tU_GenAsy_Ext;
	I_GenAsy_Ext;			tI_GenAsy_Ext;
	Q_AVR_Set_U;			tQ_AVR_Set_U;

					
	(**Customized**)				
	DO_P_Red_EVU_Stage0;	tDO_P_Red_EVU_Stage0;
	DO_P_Red_EVU_Stage1;	tDO_P_Red_EVU_Stage1;
	DO_P_Red_EVU_Stage2;	tDO_P_Red_EVU_Stage2;
	DO_P_Red_EVU_Stage3;	tDO_P_Red_EVU_Stage3;
	DO_P_Red_EVU_Stage4;	tDO_P_Red_EVU_Stage4;
	DO_P_Red_EVU_Stage5;	tDO_P_Red_EVU_Stage5;
	DO_Eng_Block_EVU;		tDO_Eng_Block_EVU;
	Gen_DVM;				tGen_DVM;
					
	(**Monic**)				
					
	(**ICxx**)				
					
	(**Ignition**)				
	CA_IgnP_Set;			tCA_IgnP_Set;
					
	(**Synchronization**)				
	GCB_RUC;				tGCB_RUC;
	GCB_COf;				tGCB_COf;
	MCB_COf;				tMCB_COf;
	DemandBB;				tDemandBB;
	Eng_Dem;				tEng_Dem;
	Eng_Run_Sy;				tEng_Run_Sy;
	GCB_COn;				tGCB_COn;
	GCB_DVS;				tGCB_DVS;
	GCB_EDC;				tGCB_EDC;
	GCB_ESL;				tGCB_ESL;
	GCB_OpF;				tGCB_OpF;
	GCB_Rel;				tGCB_Rel;
	GCB_RSP;				tGCB_RSP;
	GCB_RT;					tGCB_RT;
	Lock_C_MCB;				tLock_C_MCB;
	MCB_COn;				tMCB_COn;
	MCB_DVS;				tMCB_DVS;
	MCB_RSP;				tMCB_RSP;
	MCB_RT;					tMCB_RT;
	PulseMainsOk;			tPulseMainsOk;
	Rdy_MSy;				tRdy_MSy;
	GenDeexitDem;			tGenDeexitDem;
	P_Lo;					tP_Lo;
	N_EngStart;				tN_EngStart;
	LS_Dem;					tLS_Dem;
	MnsOk_ClosCond_Ok;		tMnsOk_ClosCond_Ok; 
	GenOverExc;				tGenOverExc;
	GenRotorEarthFault;		tGenRotorEarthFault;
	Q_GenUnderVoltProt;		tQ_GenUnderVoltProt;
	MCB_OpF_Ext;			tMCB_OpF_Ext;
	GCB_OpF_Ext;			tGCB_OpF_Ext;
	LockEng_ClosCond;		tLockEng_ClosCond;
	OMSS_Man;				tOMSS_Man;		
	OMSS_Aut;				tOMSS_Aut;		
					
	(**Coupling**)				
					
	
	(**EngineController**)				
	Actuator_Rel;			tActuator_Rel;
	Actuator2_Rel;			tActuator2_Rel;
	Pos_TV;					tPos_TV;
	Pos_TV_A1;				tPos_TV_A1;
	Pos_TV_A2;				tPos_TV_A2;
	Pos_TV_B1;				tPos_TV_B1;
	Pos_TV_B2;				tPos_TV_B2;
	Pos_CBV;				tPos_CBV;
	Pos_CBV34;				tPos_CBV34;
	Pos_CBV_A1;				tPos_CBV_A1;
	Pos_CBV_A2;				tPos_CBV_A2;
	Pos_CBV_B1;				tPos_CBV_B1;
	Pos_CBV_B2;				tPos_CBV_B2;
	WG_Dem;					tWG_Dem;
	WG_A_Dem;				tWG_A_Dem;
	WG_B_Dem;				tWG_B_Dem;
	Pos_Set_WG;				tPos_Set_WG;
	Pos_Set_WG_A;			tPos_Set_WG_A;
	Pos_Set_WG_B;			tPos_Set_WG_B;
					
	(**EngineGeneral**)				
					
	(**Knocking**)				
	FastAO_KN_A;			tFastAO_KN_A;
	FastAO_KN_B;			tFastAO_KN_B;
					
	(**ChargingUnit**)				
	Pr_Ch_P2bFA;			tPr_Ch_P2bFA;
	Pr_Ch_P2HP;				tPr_Ch_P2HP;
	Pr_Ch_P2HP_A;			tPr_Ch_P2HP_A;
	Pr_Ch_P2HP_B;			tPr_Ch_P2HP_B;

	Pr_Ch_P2LP; 			tPr_Ch_P2LP;
	Pr_Ch_P2LP_A; 			tPr_Ch_P2LP_A;
	Pr_Ch_P2LP_B; 			tPr_Ch_P2LP_B;
			
	(**Gastrain**)				
	GV1_1_Open;				tGV1_1_Open;
	GV1_2_Open;				tGV1_2_Open;
	PCG_GV_Open;			tPCG_GV_Open;
	PCG_BPV_Open;			tPCG_BPV_Open;
	PCG_GV_DelOpen;			tPCG_GV_DelOpen;
	GV_Rel;					tGV_Rel;
	GT1_4_SafeDevice;		tGT1_4_SafeDevice;
	GT1_3_SafeDevice;		tGT1_3_SafeDevice;
	GT1_2_SafeDevice;		tGT1_2_SafeDevice;
	GT1_1_SafeDevice;		tGT1_1_SafeDevice;
	GT1_SafeDevice;			tGT1_SafeDevice;
	GT2_SafeDevice;			tGT2_SafeDevice;
	PCG_DemReliefValve;		tPCG_DemReliefValve;
	GV1_Open;				tGV1_Open;
	GV2_Open;				tGV2_Open;
	PCG_DemCoolFan;			tPCG_DemCoolFan;
	PCG_DemValCW;			tPCG_DemValCW;
	GT_RelFlair;			tGT_RelFlair;
	GT_GC_Dem;				tGT_GC_Dem;
	Pr_PCG_GC_Dem;			tPr_PCG_GC_Dem;
	GT_Flap1_Open;			tGT_Flap1_Open;
	GT_Flap2_Open;			tGT_Flap2_Open;
	GT_Flap1_Close;			tGT_Flap1_Close;
	GT_Flap2_Close;			tGT_Flap2_Close;
	GV1Mega_Open;			tGV1Mega_Open;
	GV2Mega_Open;			tGV2Mega_Open;
	Pr_MGT_sp;				tPr_MGT_sp;
	Pr_PCGT_sp;				tPr_PCGT_sp;
	GT_RatioMix_Set;		tGT_RatioMix_Set;
	Pr_GT_b_Reg;			tPr_GT_b_Reg;
	Pr_GT_a_Reg;			tPr_GT_a_Reg;
	Pr_N2_GT;				tPr_N2_GT;
	GV_N2_Open;				tGV_N2_Open;
	
	(**AuxiliariesGeneral**)				
	AuxPoSuMains;			tAuxPoSuMains;
	AuxPoSuUPS;				tAuxPoSuUPS;
	ChargeOff_Dem;			tChargeOff_Dem;
	ECW_PreH_Dem;			tECW_PreH_Dem;
	ECW_PreH1Dem;			tECW_PreH1Dem;
	ECW_PreH2Dem;			tECW_PreH2Dem;
	ECW_PreH3Dem;			tECW_PreH3Dem;
	ECWP_PreH_Dem;			tECWP_PreH_Dem;
	ECWP1Dem;				tECWP1Dem;
	ECWP2Dem;				tECWP2Dem;
	ECW_PreHV_CoClose;		tECW_PreHV_CoClose;
	ECW_PreHV_CoOpen;		tECW_PreHV_CoOpen;
	EleStarter_Dem;			tEleStarter_Dem;
	EOP1AC_Dem;				tEOP1AC_Dem;
	EOP1DC_Dem;				tEOP1DC_Dem;
	EOVal_DemOpen;			tEOVal_DemOpen;
	Horn;					tHorn;
	Horn_Trip;				tHorn_Trip;
	Horn_Warning;			tHorn_Warning;
	HWP_Dem;				tHWP_Dem;
	MainGV_Rel;				tMainGV_Rel;
	MainsStartDevDem;		tMainsStartDevDem;
	N_ECWP_Set;				tN_ECWP_Set;
	RotatingLight;			tRotatingLight;
	Signal1R1;				tSignal1R1;
	Signal1R2;				tSignal1R2;
	SignalG1;				tSignalG1;
	SignalG2;				tSignalG2;
	SignalR1;				tSignalR1;
	SignalR2;				tSignalR2;
	SignalY1;				tSignalY1;
	SignalY2;				tSignalY2;
	StUpSpeed;				tStUpSpeed;
	TurnRel;				tTurnRel;
	Ctr_ECW_Set;			tCtr_ECW_Set;
	TC_EOP_On;				tTC_EOP_On;
	TC_EOP_OnUSV;			tTC_EOP_OnUSV;
	EOP_On;					tEOP_On;
	EO_Preheat1;			tEO_Preheat1;
	EO_Preheat2;			tEO_Preheat2;
	EO_Preheat3;			tEO_Preheat3;
	EOP_FC_Set;				tEOP_FC_Set;
	OV_Ctrl_Set;			tOV_Ctrl_Set;
	EOF_PreheatRel;			tEOF_PreheatRel;
	FreshOilPump_RTC;		tFreshOilPump_RTC;
	CV_GENI_Ok;				tCV_GENI_Ok;
	CV_ENGIB_Ok;			tCV_ENGIB_Ok;
	CV_TCMI_Ok;				tCV_TCMI_Ok;
	CV_TCUS_Ok;				tCV_TCUS_Ok;
	CV_JWMI_Ok;				tCV_JWMI_Ok;
	CV_OILMI_Ok;			tCV_OILMI_Ok;
	CV_M_Ok;				tCV_M_Ok;
	CV_A_Ok;				tCV_A_Ok;
	CV_AUX_Ok;				tCV_AUX_Ok;
	PS_EOaP_HiHi;			tPS_EOaP_HiHi;
	Pr_EOaP;				tPr_EOaP;
	OFUP_Centrifuge;		tOFUP_Centrifuge;
	OFUP_Filter;			tOFUP_Filter;
	Pr_OFUbFilt;			tPr_OFUbFilt;
	Pr_OFUaFilt;			tPr_OFUaFilt;
	OFUP_Filter_CB;			tOFUP_Filter_CB;
	OFUP_Centrifuge_CB;		tOFUP_Centrifuge_CB;
	Pr_OFUbCentrifuge;		tPr_OFUbCentrifuge;
	ACP_AirER_Dem;			tACP_AirER_Dem;
	ACP_HT_Dem;				tACP_HT_Dem;	
	ECW_HydrPreH_Pump_Dem;	tECW_HydrPreH_Pump_Dem;
	ECW_HydrPreH_Val_DemOpen;		tECW_HydrPreH_Val_DemOpen;
	HWP1_Dem;				tHWP1_Dem;
	HWP1_Op;				tHWP1_Op;
	HWP2_Dem;				tHWP2_Dem;
	HWP2_Op;				tHWP2_Op;
	CCWP1_Dem;				tCCWP1_Dem;
	CCWP1_Op;				tCCWP1_Op;
	CCWP2_Dem;				tCCWP2_Dem;
	CCWP2_Op;				tCCWP2_Op;
	CC2WP1_Dem;				tCC2WP1_Dem;
	CC2WP1_Op;				tCC2WP1_Op;
	CC2WP2_Dem;				tCC2WP2_Dem;
	CC2WP2_Op;				tCC2WP2_Op;
	EmCWP_Op;				tEmCWP_Op;
	EmCWP1_Dem;				tEmCWP1_Dem;
	EmCWP1_Op;				tEmCWP1_Op;
	EmCWP2_Dem;				tEmCWP2_Dem;
	EmCWP2_Op;				tEmCWP2_Op;
	BoilerFailure;			tBoilerFailure;
	SeismicAlarm;			tSeismicAlarm;
	Pr_AirST_Engage;		tPr_AirST_Engage;
	AirST_ValEngage;		tAirST_ValEngage;
	AirST_ValStart;			tAirST_ValStart;
	Pr_ECWaP1;				tPr_ECWaP1;
	Pr_ECWaP2;				tPr_ECWaP2;
	ECWP_CB_On;				tECWP_CB_On;
	L_FreshOilTank_LoLo;	tL_FreshOilTank_LoLo;
	L_DayOilTank_Lo;		tL_DayOilTank_Lo;
	L_DayOilTank_LoLo;		tL_DayOilTank_LoLo;
	OF_DayOilTank;			tOF_DayOilTank;
	L_WasteOilDayTank_Hi;	tL_WasteOilDayTank_Hi;
	OF_WasteOilDayTank;		tOF_WasteOilDayTank;
	PS_FreshOilPump_Hi;		tPS_FreshOilPump_Hi;
	FreshOilPump_Block;		tFreshOilPump_Block;
	U_BufferBat1;			tU_BufferBat1;
	U_BufferBat2;			tU_BufferBat2;
	BufferBat1_Disconnect;	tBufferBat1_Disconnect;
	BufferBat2_Disconnect;	tBufferBat2_Disconnect;
	BufferBat1_ConnectLoad;	tBufferBat1_ConnectLoad;
	BufferBat2_ConnectLoad;	tBufferBat2_ConnectLoad;
	StarterBat_ConnectLoad;	tStarterBat_ConnectLoad;
	BatChargeDev_Ok;		tBatChargeDev_Ok;	
	Leak_OilExtensionTank1;	tLeak_OilExtensionTank1;
	Leak_OilExtensionTank2;	tLeak_OilExtensionTank2;
	Leak_OilExtensionTank3;	tLeak_OilExtensionTank3;
	U_CtrlBat;				tU_CtrlBat;
	CtrlBat_ChargeDev_Ok;	tCtrlBat_ChargeDev_Ok;
	CtrlBat_Disconnect;		tCtrlBat_Disconnect;
	CtrlBat_ConnectLoad;	tCtrlBat_ConnectLoad;
				
	(**Opstate**)				
	OMSS_MAT;				tOMSS_MAT;
	Eng_Aux_Dem_CDR;		tEng_Aux_Dem_CDR;
	Eng_Aux_Dem_CDR2;		tEng_Aux_Dem_CDR2;
	Eng_Aux_Dem_CDR3;		tEng_Aux_Dem_CDR3;
	Rel_Sync_Load;			tRel_Sync_Load;
	LSL_Out;				tLSL_Out;
	P_Red_Active;			tP_Red_Active;
	Eng_Run;				tEng_Run;
	Ign_Dem;				tIgn_Dem;
	Eng_Rdy_Rem;			tEng_Rdy_Rem;
	P_Red_Norm;				tP_Red_Norm;
	P_Act_AO;				tP_Act_AO;
	Imp_OpHour;				tImp_OpHour;
					
	(**SAFI**)				
	MO_PwrRequest;			tMO_PwrRequest;
	MO_PwrRequest2;			tMO_PwrRequest2;
	MO_PwrRequest3;			tMO_PwrRequest3;
	MO_PwrRequest4;			tMO_PwrRequest4;
					
	(**Gasmixer**)				
					
	(**GasMeteringUnit**)				
					
	(**KLS98**)				
					
	(**TestBench**)				
					
	(**ParaBase**)				
	Sys_Run;				tSys_Run;
	Sys_Run1;				tSys_Run1;
	Sys_Run2;				tSys_Run2;
	Sys_Run3;				tSys_Run3;
	Sys_Run4;				tSys_Run4;
	Sys_Run5;				tSys_Run5;
	Sys_Run6;				tSys_Run6;
					
	(**Visu**)				
					
	(**HalIO**)				
	ResetRemoteExt;			tResetRemoteExt;
	GCB_On;					tGCB_On;
	SafetyLoop_Eng;			tSafetyLoop_Eng;
	PF_CUSTGenC;			tPF_CUSTGenC;
	Q_GenC_CUST;			tQ_GenC_CUST;
	U_GenC_SetCUST;			tU_GenC_SetCUST;
	PF_GenC_SetEUCOn;		tPF_GenC_SetEUCOn;
	PF_GenC_SetEUCOf;		tPF_GenC_SetEUCOf;
	PF_GenC_SetFix1EU;		tPF_GenC_SetFix1EU;
	PF_GenC_SetFix2EU;		tPF_GenC_SetFix2EU;
	PF_GenC_SetFix3EU;		tPF_GenC_SetFix3EU;
	PF_GenC_SetFix4EU;		tPF_GenC_SetFix4EU;
	PF_GenC_SetFix5EU;		tPF_GenC_SetFix5EU;
	Q_GenC_SetEUCOn;		tQ_GenC_SetEUCOn;
	Q_GenC_SetEUCOf;		tQ_GenC_SetEUCOf;
	Q_GenC_SetFix1EU;		tQ_GenC_SetFix1EU;
	Q_GenC_SetFix2EU;		tQ_GenC_SetFix2EU;
	Q_GenC_SetFix3EU;		tQ_GenC_SetFix3EU;
	Q_GenC_SetFix4EU;		tQ_GenC_SetFix4EU;
	Q_GenC_SetFix5EU;		tQ_GenC_SetFix5EU;
	QLim_GenC_SetEUCOn;		tQLim_GenC_SetEUCOn;
	QLim_GenC_SetEUCOf;		tQLim_GenC_SetEUCOf;
	QPC_GenC_SetEUCOn;		tQPC_GenC_SetEUCOn;
	QPC_GenC_SetEUCOf;		tQPC_GenC_SetEUCOf;
	QUC_GenC_SetEUCOn;		tQUC_GenC_SetEUCOn;
	QUC_GenC_SetEUCOf;		tQUC_GenC_SetEUCOf;
	PFUC_GenC_SetEUCOn;		tPFUC_GenC_SetEUCOn;
	PFUC_GenC_SetEUCOf;		tPFUC_GenC_SetEUCOf;
	QP_GenC_SetEUCOn;		tQP_GenC_SetEUCOn;
	QP_GenC_SetEUCOf;		tQP_GenC_SetEUCOf;
	P_GenC_SetEUCOn;		tP_GenC_SetEUCOn;
	P_GenC_SetEUCOf;		tP_GenC_SetEUCOf;
	P_GenC_SetFix1EU;		tP_GenC_SetFix1EU;
	P_GenC_SetFix2EU;		tP_GenC_SetFix2EU;
	P_GenC_SetFix3EU;		tP_GenC_SetFix3EU;
	P_GenC_SetFix4EU;		tP_GenC_SetFix4EU;
	P_GenC_SetFix5EU;		tP_GenC_SetFix5EU;
	PLim_GenC_SetEUCOn;		tPLim_GenC_SetEUCOn;
	PLim_GenC_SetEUCOf;		tPLim_GenC_SetEUCOf;
	PLim_GenC_SetEUPFix1;	tPLim_GenC_SetEUPFix1;
	PLim_GenC_SetEUPFix2;	tPLim_GenC_SetEUPFix2;
	PLim_GenC_SetEUPFix3;	tPLim_GenC_SetEUPFix3;
	PLim_GenC_SetEUPFix4;	tPLim_GenC_SetEUPFix4;
	PLim_GenC_SetEUPFix5;	tPLim_GenC_SetEUPFix5;
	PFC_SetCOn;				tPFC_SetCOn;
	PFC_SetCOf;				tPFC_SetCOf;
	RMC_SetCOn;				tRMC_SetCOn;
	RMC_SetCOf;				tRMC_SetCOf;
	PF_GenC_SetEU;			tPF_GenC_SetEU;
	Q_GenC_SetEU;			tQ_GenC_SetEU;
	QLim_GenC_SetEU;		tQLim_GenC_SetEU;
	QU_GenC_Set;			tQU_GenC_Set;
	P_GenC_SetEU;			tP_GenC_SetEU;
	PLim_GenC_SetEU;		tPLim_GenC_SetEU;
	U_MMD_Synch1;			tU_MMD_Synch1;
	U_MMD_Synch2;			tU_MMD_Synch2;
	U_L1L2;					tU_L1L2;
	U_L1N;					tU_L1N;
	U_L2L3;					tU_L2L3;
	U_L2N;					tU_L2N;
	U_L3L1;					tU_L3L1;
	U_L3N;					tU_L3N;
	U_Avg;					tU_Avg;
	P_Act;					tP_Act;
	Q_Act;					tQ_Act;
	S_Act;					tS_Act;
	F_MMD;					tF_MMD;
	PF_Act;					tPF_Act;
	DI_Dem_EU_Block;		tDI_Dem_EU_Block;
							tDI_Dem_EU_MnsConBlock; (* Only with plant communication *)
	MCB_On;					tMCB_On;
	MnsOk;					tMnsOk;
	ERV_Op;					tERV_Op;
	ERV_InlAir_Op;          tERV_InlAir_Op;
	ERV_OutlAir_Op;         tERV_OutlAir_Op;
	T_AirER_Ext_Hi1;		tT_AirER_Ext_Hi1;
	T_AirER_Ext_Hi;			tT_AirER_Ext_Hi;
	T_AirER_Ext_Hi3;		tT_AirER_Ext_Hi3;
	T_AirER_Ext_Hi2;		tT_AirER_Ext_Hi2;
	ER_Ext_Err;				tER_Ext_Err;
	ER_InlAir_Ext_Err;		tER_InlAir_Ext_Err;
	ER_OutlAir_Ext_Err;		tER_OutlAir_Ext_Err;
	AirER_FS;				tAirER_FS;
	Rel_ER_PurgeCycle;		tRel_ER_PurgeCycle;
	InAirER_Lou1Opened;		tInAirER_Lou1Opened;
	InAirER_Lou2Opened;		tInAirER_Lou2Opened;
	OutAirER_LouOpened;		tOutAirER_LouOpened;
	AuxV_Supply_Ok;			tAuxV_Supply_Ok;
	T_Ch_T1LP;				tT_Ch_T1LP;
	T_Ch_T1LP_A;			tT_Ch_T1LP_A;
	T_Ch_T1LP_B;			tT_Ch_T1LP_B;
	T_Ch_T1HP;				tT_Ch_T1HP;
	T_Ch_T1HP_A;			tT_Ch_T1HP_A;
	T_Ch_T1HP_B;			tT_Ch_T1HP_B;
	T_Ch_T2LP;				tT_Ch_T2LP;
	T_Ch_T2LP_A;			tT_Ch_T2LP_A;
	T_Ch_T2LP_B;			tT_Ch_T2LP_B;
	T_Ch_T2HP;				tT_Ch_T2HP;
	T_Ch_T2HP_A;			tT_Ch_T2HP_A;
	T_Ch_T2HP_B;			tT_Ch_T2HP_B;
	T_Ch_T2s;				tT_Ch_T2s;
	T_Ch_T2s_A;				tT_Ch_T2s_A;
	T_Ch_T2s_B;				tT_Ch_T2s_B;
	T_AirER;				tT_AirER;
	T_ECW_Ext_Hi;			tT_ECW_Ext_Hi;
	EC_Failure;				tEC_Failure;
	ChC_Failure;			tChC_Failure;
	Pr_CCircuit_Lo;			tPr_CCircuit_Lo;
	Pr_HW_Lo;				tPr_HW_Lo;
	Pr_ChC_Lo;				tPr_ChC_Lo;
	Pr_ChC2_Lo;				tPr_ChC2_Lo;
	T_AirOutdoor;			tT_AirOutdoor;
	Pr_ECW;					tPr_ECW;
	T_ECW;					tT_ECW;
	T_HW_ReBeEng;			tT_HW_ReBeEng;
	T_HW_ReAfEC;			tT_HW_ReAfEC;
	T_HW_Re;				tT_HW_Re;
	T_HW_Su;				tT_HW_Su;
	T_EO;					tT_EO;
	Pr_HW_Hi1;				tPr_HW_Hi1;
	Pr_HW_Hi;				tPr_HW_Hi;
	T_HW_Hi1;				tT_HW_Hi1;
	T_HW_Hi;				tT_HW_Hi;
	Flow_HW_Lo;				tFlow_HW_Lo;
	T_ChCW_Hi;				tT_ChCW_Hi;
	T_HW_Su_LT;				tT_HW_Su_LT;
	T_ECW_AfEng;			tT_ECW_AfEng;
	T_HW_Re_LT;				tT_HW_Re_LT;
	T_Su_PriCirc;           tT_Su_PriCirc;
	T_Re_PriCirc;           tT_Re_PriCirc;
	T_Su_SecCirc;           tT_Su_SecCirc;
	T_Re_SecCirc;           tT_Re_SecCirc;
	ChC_FanRdy;				tChC_FanRdy;
	ScavFanCB_trip;			tScavFanCB_trip;
	ScavFanFC_P_Lo;			tScavFanFC_P_Lo;
	ScavFanOp;				tScavFanOp;
	ScavFanFC_Rdy;			tScavFanFC_Rdy;
	T_EGaTC;				tT_EGaTC;
	T_EGaHE;				tT_EGaHE;
	T_PlateHE;				tT_PlateHE;
	T_Cat;					tT_Cat;
	T_EGbTC;				tT_EGbTC;
	EG_BypassDemand;		tEG_BypassDemand;
	EG_ByVaOpened;			tEG_ByVaOpened;
	EG_ByVaClosed;			tEG_ByVaClosed;
	EG_ByVaClosedTo;		tEG_ByVaClosedTo;
	EG_ByVaFailure;			tEG_ByVaFailure;
	EG_BoVaFailure;			tEG_BoVaFailure;
	EG_BoVaOpened;			tEG_BoVaOpened;
	EG_BoVaClosed;			tEG_BoVaClosed;
	EG_BoVaClosedTo;		tEG_BoVaClosedTo;
	EGScavStart_Ext;		tEGScavStart_Ext;
	ScavVaOpened;			tScavVaOpened;
	ScavVaClosed;			tScavVaClosed;
	ScavVaFailure;			tScavVaFailure;
	Pr_N2_Lo;				tPr_N2_Lo;
	Pr_N2_Hi;				tPr_N2_Hi;
	N2_GV1_Closed;			tN2_GV1_Closed;
	N2_GV2_Closed;			tN2_GV2_Closed;
	AuxV_Eng_ok;			tAuxV_Eng_ok;
	T_CO2_Hi;				tT_CO2_Hi;
	CO2_Demand;				tCO2_Demand;
	CO2_VaOpened;			tCO2_VaOpened;
	CO2_VaClosed;			tCO2_VaClosed;
	CO2_VaFailure;			tCO2_VaFailure;
	CO2_DevFailure;			tCO2_DevFailure;
	CO2_FanFailure;			tCO2_FanFailure;
	Codinox_Rdy;			tCodinox_Rdy;
	CO2_VaLockout;			tCO2_VaLockout;
	T_EGaHE1;				tT_EGaHE1;
	T_EGaHE2;				tT_EGaHE2;
	Pr_EngLubOil;			tPr_EngLubOil;
	T_EGaLPTC_A;			tT_EGaLPTC_A;
	T_EGaLPTC_B;			tT_EGaLPTC_B;
	Pr_EG_Hi;				tPr_EG_Hi;
	Pr_PC;					tPr_PC;
	ThR_LampTest;			tThR_LampTest;
	ThR_SL;					tThR_SL;
	ThR_Swth_On;			tThR_Swth_On;
	Pos_ThR_Val_In1;		tPos_ThR_Val_In1;
	Pos_ThR_Val_In2;		tPos_ThR_Val_In2;
	Pos_ThR_Val_Mid;		tPos_ThR_Val_Mid;
	Pos_ThR_Val_Out1;		tPos_ThR_Val_Out1;
	Pos_ThR_Val_Out2;		tPos_ThR_Val_Out2;
	Pr_ThR_AirLo;			tPr_ThR_AirLo;
	T_ThR_ChamberLo;		tT_ThR_ChamberLo;
	T_ThR_Swg_Hi;			tT_ThR_Swg_Hi;
	T_ThR_Chamber1_1;		tT_ThR_Chamber1_1;
	T_ThR_Chamber1_2;		tT_ThR_Chamber1_2;
	T_ThR_Chamber2_1;		tT_ThR_Chamber2_1;
	T_ThR_Chamber2_2;		tT_ThR_Chamber2_2;
	T_ThR_Comp;				tT_ThR_Comp;
	T_ThR_In;				tT_ThR_In;
	T_ThR_Out;				tT_ThR_Out;
	U_Gen_Dec;				tU_Gen_Dec;
	U_Gen_Inc;				tU_Gen_Inc;
	DiffPrct;				tDiffPrct;
	Eng_SUExc_Rel;			tEng_SUExc_Rel;
	F_MMD_LimHi;			tF_MMD_LimHi;
	F_MMD_LimLo;			tF_MMD_LimLo;
	Flow_Gen_Lube;			tFlow_Gen_Lube;
	GCB_DVM;				tGCB_DVM;
	Gen_Exc_Off;			tGen_Exc_Off;
	Gen_T_In;				tGen_T_In;
	Gen_T_In2;				tGen_T_In2;
	GndFailure;				tGndFailure;
	I_Diff;					tI_Diff;
	I_MMD_Asy;				tI_MMD_Asy;
	I_MMD_LimHi;			tI_MMD_LimHi;
	I_MMD_Neutr_LimHi;		tI_MMD_Neutr_LimHi;
	P_Act;					tP_Act;
	Q_Act;					tQ_Act;
	Rel_U_Sel_LS_Gen;		tRel_U_Sel_LS_Gen;
	Req_PowMod;				tReq_PowMod;
	T_Gen_Bear_A_Act;		tT_Gen_Bear_A_Act;
	T_Gen_Bear_B_Act;		tT_Gen_Bear_B_Act;
	T_Gen_Wind;				tT_Gen_Wind;
	T_Gen_Wind_Act_L1;		tT_Gen_Wind_Act_L1;
	T_Gen_Wind_Act_L2;		tT_Gen_Wind_Act_L2;
	T_Gen_Wind_Act_L3;		tT_Gen_Wind_Act_L3;
	U_Adj_Minus;			tU_Adj_Minus;
	U_Adj_Plus;				tU_Adj_Plus;
	U_Avg;					tU_Avg;
	U_Gen_Contr_Fail;		tU_Gen_Contr_Fail;
	U_Gen_Exc;				tU_Gen_Exc;
	U_Gen_LimHi;			tU_Gen_LimHi;
	U_Gen_LimLo2;			tU_Gen_LimLo2;
	U_Gen_LimLo;			tU_Gen_LimLo;
	U_GenDiode_Fail;		tU_GenDiode_Fail;
	U_GenOverVolt;			tU_GenOverVolt;
	Gen_LO_CoolingSys_Fail;	tGen_LO_CoolingSys_Fail;
	GenCtr_CktBkr_Trip;		tGenCtr_CktBkr_Trip;
	U_MMD_Asy;				tU_MMD_Asy;
	T_EGafHeEx1;			tT_EGafHeEx1;
	T_EGafHeEx2;			tT_EGafHeEx2;
	AI_UniAi;				tAI_UniAi;
	CustAnaIn;				tCustAnaIn;
	CustDigIn;				tCustDigIn;
	DI_Dem_P_Red_EVU_Stage1;tDI_Dem_P_Red_EVU_Stage1;
	DI_Dem_P_Red_EVU_Stage2;tDI_Dem_P_Red_EVU_Stage2;
	DI_Dem_P_Red_EVU_Stage3;tDI_Dem_P_Red_EVU_Stage3;
	DI_Dem_P_Red_EVU_Stage4;tDI_Dem_P_Red_EVU_Stage4;
	DI_Dem_P_Red_EVU_Stage5;tDI_Dem_P_Red_EVU_Stage5;
	DI_UniDi;				tDI_UniDi;
	EO_Level;				tEO_Level;
	GT_CH4;					tGT_CH4;
	GT_H2;					tGT_H2;
	GT_O2;					tGT_O2;
	I_Avg;					tI_Avg;
	N_Set_ExtAI_Norm;		tN_Set_ExtAI_Norm;
	P_Red_AI_Norm;			tP_Red_AI_Norm;
	P_Set_ExtAI_Norm;		tP_Set_ExtAI_Norm;
	Pr_GT_Gas;				tPr_GT_Gas;
	Pr_GT_Suct;				tPr_GT_Suct;
	Pr_PC_Diff;				tPr_PC_Diff;
	Pr_PCG;					tPr_PCG;
	SafetyLoop_EmStop;		tSafetyLoop_EmStop;
	T_GT;					tT_GT;
	Vol_GT;					tVol_GT;
	Pr_CC;					tPr_CC;
	Ign_Run_Hal;			tIgn_Run_Hal;
	Ign2_Run_Hal;			tIgn2_Run_Hal;
	Ign_OverspeedRelay;		tIgn_OverspeedRelay;
	TBMode;					tTBMode;
	BB_Alive;				tBB_Alive;
	BB_Dead_MMD;			tBB_Dead_MMD;
	C_CB_EDC;				tC_CB_EDC;
	C_CB_ESL;				tC_CB_ESL;
	C_CB_Off;				tC_CB_Off;
	C_CB_On;				tC_CB_On;
	EngDemIsland;			tEngDemIsland;
	GCB_AGO;				tGCB_AGO;
	GCB_DSY;				tGCB_DSY;
	GCB_MDL;				tGCB_MDL;
	GCB_MRC;				tGCB_MRC;
	GCB_OGP;				tGCB_OGP;
	GCB_Rac;				tGCB_Rac;
	GCB_Rdy;				tGCB_Rdy;
	GCB_RI;					tGCB_RI;
	GCB_SM1;				tGCB_SM1;
	GCB_SM2;				tGCB_SM2;
	GCB_Off;				tGCB_Off;
	GCB_Earth;				tGCB_Earth;
	MCB_OL;					tMCB_OL;
	MCB_Off;				tMCB_Off;
	MCB_Rac;				tMCB_Rac;
	MCB_Rdy;				tMCB_Rdy;
	MCB_Rem;				tMCB_Rem;
	MCB_SM;					tMCB_SM;
	Mns_MDF;				tMns_MDF;
	MnsOk;					tMnsOk;
	MnsOk;					tMnsOk;
	Only_Island;			tOnly_Island;
	Rel_BS;					tRel_BS;
	Rel_I;					tRel_I;
	Rel_LS;					tRel_LS;
	GCB_DRM;				tGCB_DRM;
	Gen_RVM;				tGen_RVM;
	Sy_N_Up;				tSy_N_Up;
	Sy_N_Down;				tSy_N_Down;
	LineCB_On;				tLineCB_On;
	RelEngOpFromGSy;		tRelEngOpFromGSy;
	EarthCB_Off;			tEarthCB_Off;
	IsoCB_Off;				tIsoCB_Off;
	MnsOk_GTE;				tMnsOk_GTE;
	MnsOk_TGS;				tMnsOk_TGS;
	MnsOk_C13100;			tMnsOk_C13100;
	Actuator_Ok;			tActuator_Ok;
	Actuator_Ok_TV1A;		tActuator_Ok_TV1A;
	Actuator_Ok_TV1B;		tActuator_Ok_TV1B;
	Actuator_Ok_TV2A;		tActuator_Ok_TV2A;
	Actuator_Ok_TV2B;		tActuator_Ok_TV2B;
	Pr_Ch_P2;				tPr_Ch_P2;
	T_EG_Cyl;				tT_EG_Cyl;
	Actuator_Ok_CBV1;		tActuator_Ok_CBV1;
	Actuator_Ok_CBV2;		tActuator_Ok_CBV2;
	T_EO;					tT_EO;
	Pos_Act_WG;				tPos_Act_WG;
	Pos_Act_WG_A;			tPos_Act_WG_A;
	Pos_Act_WG_B;			tPos_Act_WG_B;
	I_L1;					tI_L1;
	I_L2;					tI_L2;
	I_L3;					tI_L3;
	U_L1L2;					tU_L1L2;
	U_L2L3;					tU_L2L3;
	U_L3L1;					tU_L3L1;
	U_L1N;					tU_L1N;
	U_L2N;					tU_L2N;
	U_L3N;					tU_L3N;
	Pr_Ch_P1HP;				tPr_Ch_P1HP;
	N_TCHP;					tN_TCHP;
	N_TCLP;					tN_TCLP;
	T_EGaTC;				tT_EGaTC;
	T_EGbTC;				tT_EGbTC;
	Lam_Act;				tLam_Act;
	KLS90_1;				tKLS90_1;
	KLS90_2;				tKLS90_2;

	Pr_Ch_P2s;				tPr_Ch_P2s;
	Pr_Ch_P2s_A;			tPr_Ch_P2s_A;
	Pr_Ch_P2s_B;			tPr_Ch_P2s_B;
	Pr_Ch_P2;				tPr_Ch_P2;
	Pr_Ch_P2_A;				tPr_Ch_P2_A;
	Pr_Ch_P2_B;				tPr_Ch_P2_B;
	Pr_Ch_P1HP_A;			tPr_Ch_P1HP_A;
	Pr_Ch_P1HP_B;			tPr_Ch_P1HP_B;
	Pr_Ch_P1LP_A;			tPr_Ch_P1LP_A;
	Pr_Ch_P1LP_B;			tPr_Ch_P1LP_B;
	DPr_AirFilt;			tDPr_AirFilt;
	DPr_AirFilt_A;			tDPr_AirFilt_A;
	DPr_AirFilt_B;			tDPr_AirFilt_B;
	DPr_InAirFiltERV_Hi;	tDPr_InAirFiltERV_Hi;
	N_TCHP_A;				tN_TCHP_A;
	N_TCHP_B;				tN_TCHP_B;
	N_TCLP_A;				tN_TCLP_A;
	N_TCLP_B;				tN_TCLP_B;
	GT_Flap1_Opened;		tGT_Flap1_Opened;
	GT_Flap2_Opened;		tGT_Flap2_Opened;
	GT_Flap1_Closed;		tGT_Flap1_Closed;
	GT_Flap2_Closed;		tGT_Flap2_Closed;
	P_GT_Max_Backfire;		tP_GT_Max_Backfire;
	PCG_GC_Fail;			tPCG_GC_Fail;
	PCG_GC_Oil_Min;			tPCG_GC_Oil_Min;
	GT_BackFireDev;			tGT_BackFireDev;
	tRelMainGVext;			tRelMainGVext;
	DemFlair;				tDemFlair;
	DiffPrct;				tDiffPrct;
	GndFailure;				tGndFailure;
	GT1_1_SafeDevOK;		tGT1_1_SafeDevOK;
	GT1_2_SafeDevOK;		tGT1_2_SafeDevOK;
	GT1_3_SafeDevOK;		tGT1_3_SafeDevOK;
	GT1_4_SafeDevOK;		tGT1_4_SafeDevOK;
	GT1_SafeDevOK;			tGT1_SafeDevOK;
	GT2_SafeDevOK;			tGT2_SafeDevOK;
	FlairRdy;				tFlairRdy;
	RelGasPlant;			tRelGasPlant;
	Cnt_GasImp;				tCnt_GasImp;
	Pr_GT_MinBefCompr;		tPr_GT_MinBefCompr;
	T_GT_Ok;				tT_GT_Ok;
	GT_CV;					tGT_CV;
	GT_GC_Fail;				tGT_GC_Fail;
	GT_FlairFail;			tGT_FlairFail;
	GT_FlareOpMod;			tGT_FlareOpMod;
	Pr_PCG_Min;				tPr_PCG_Min;
	Pr_GT1;					tPr_GT1;
	Pr_PCGT;				tPr_PCGT;
	Pr_Baro;				tPr_Baro;
	T_PCGT;					tT_PCGT;
	OlShortCirc;			tOlShortCirc;
	GenPrctTrip;			tGenPrctTrip;
	GT_TypSwitch;			tGT_TypSwitch;
	Pr_GT1_1_Min;			tPr_GT1_1_Min;
	Pr_GT1_2_Min;			tPr_GT1_2_Min;
	Pr_GT1_3_Min;			tPr_GT1_3_Min;
	Pr_GT1_4_Min;			tPr_GT1_4_Min;
	Pr_GT1_Min;				tPr_GT1_Min;
	Pr_GT2_Min;				tPr_GT2_Min;
	Pr_GT1_1_Max;			tPr_GT1_1_Max;
	Pr_GT1_2_Max;			tPr_GT1_2_Max;
	Pr_GT1_3_Max;			tPr_GT1_3_Max;
	Pr_GT1_4_Max;			tPr_GT1_4_Max;
	Pr_GT1_Max;				tPr_GT1_Max;
	Pr_GT2_Max;				tPr_GT2_Max;
	GT_CalibrateActive;		tGT_CalibrateActive;
	Pr_PCGBefComp_Lo;		tPr_PCGBefComp_Lo;
	T_PCGAfComp_Hi;			tT_PCGAfComp_Hi;
	T_PCGAfCo;				tT_PCGAfCo;
	CCWP_Op;				tCCWP_Op;
	ECWPrehV_Opened;		tECWPrehV_Opened;
	ECWP_FC_Rdy;			tECWP_FC_Rdy;
	ECWP_Op;				tECWP_Op;
	EngTurn;				tEngTurn;
	EO_Level_Hi;			tEO_Level_Hi;
	EO_Level_Lo;			tEO_Level_Lo;
	EO_Refill;				tEO_Refill;
	EOP_DemExt;				tEOP_DemExt;
	EOP_Op;					tEOP_Op;
	EOP1AC_CB_trip;			tEOP1AC_CB_trip;
	FireAlarm;				tFireAlarm;
	FS_ECW;					tFS_ECW;
	GasAlarm;				tGasAlarm;
	GasPreAlarm;			tGasPreAlarm;
	HWP_Op;					tHWP_Op;
	MainsStartDevFail;		tMainsStartDevFail;
	MainsStartDevOk;		tMainsStartDevOk;
	RelAux;					tRelAux;
	RelAuxNoMon;			tRelAuxNoMon;
	RelMainGVext;			tRelMainGVext;
	T_ECW_PreH_Hi;			tT_ECW_PreH_Hi;
	T_ECW_PreH_HiHi;		tT_ECW_PreH_HiHi;
	TCOP_Op;				tTCOP_Op;
	U_StarterBat_Lo;		tU_StarterBat_Lo;
	U_Starter_engage1;		tU_Starter_engage1;
	U_Starter_engage2;		tU_Starter_engage2;
	U_Starter_engage3;		tU_Starter_engage3;
	AuxFail;				tAuxFail;
	ECW_PreHV_Closed;		tECW_PreHV_Closed;
	ECW_PreHV_Opened;		tECW_PreHV_Opened;
	L_ECW_Lo;				tL_ECW_Lo;
	L_ECW_LoLo;				tL_ECW_LoLo;
	EngStartFailure;		tEngStartFailure;
	TransformerWarning;		tTransformerWarning;
	TransformerTrip;		tTransformerTrip;
	CP_CBTrip;				tCP_CBTrip;
	IFCP_CBTrip;			tIFCP_CBTrip;
	MCP_CBTrip;				tMCP_CBTrip;
	SafetyLoop_Gas;			tSafetyLoop_Gas;
	L_FreshOilTank_Lo;		tL_FreshOilTank_Lo;
	L_WasteOilTank_Hi;		tL_WasteOilTank_Hi;
	AuxOverVoltProt_Ok;		tAuxOverVoltProt_Ok;
	UPS_Ok;					tUPS_Ok;
	SafetyLoop_HWC;			tSafetyLoop_HWC;
	T_AirIFCP_Hi;			tT_AirIFCP_Hi;
	Pr_TC_EOF_After;		tPr_TC_EOF_After;
	EOF_DiffMax;			tEOF_DiffMax;
	Pr_TCOF_EOF_DiffMax;	tPr_TCOF_EOF_DiffMax;
	Pr_EO_Gear_Min;			tPr_EO_Gear_Min;
	T_EO_Gear_Max;			tT_EO_Gear_Max;
	EO_Supply_Fail;			tEO_Supply_Fail;
	T_MBearing;				tT_MBearing;
	Pr_EOF_DiffMon;			tPr_EOF_DiffMon;
	Pr_EOF_After;			tPr_EOF_After;
	EO_Quality;				tEO_Quality;
	Pr_TC_EOF_Before;		tPr_TC_EOF_Before;
	Cnt_Oil_NC150;			tCnt_Oil_NC150;
	Cnt_Oil_DC2395;			tCnt_Oil_DC2395;
	T_EO_Preheating;		tT_EO_Preheating;
	T_EOP_After;			tT_EOP_After;
	Cnt_OilPulse;			tCnt_OilPulse;
	EOP_FC_Rdy;				tEOP_FC_Rdy;
	L_OilSumpHi;			tL_OilSumpHi;
	L_OilSump2Hi;			tL_OilSump2Hi;
	L_OilSump3Hi;			tL_OilSump3Hi;
	CO_Alarm;				tCO_Alarm;
	CO_PreAlarm;			tCO_PreAlarm;
	AuxErrWarn;				tAuxErrWarn;
	ActFiltAlarm;			tActFiltAlarm;
	ActFiltWarn;			tActFiltWarn;
	L_InMa_NotHi;			tL_InMa_NotHi;
	L_InMa_Hi;				tL_InMa_Hi;
	MCB_On;					tMCB_On;
	Req_PowMod;				tReq_PowMod;
	Req_PeakLoad;			tReq_PeakLoad;
	Req_Test;				tReq_Test;
	LSL_In;					tLSL_In;
	F_N_DI_Inc;				tF_N_DI_Inc;
	F_N_DI_Dec;				tF_N_DI_Dec;
	F_MMD_Synch1;			tF_MMD_Synch1;
	F_MMD_Synch2;			tF_MMD_Synch2;
	ScavVaClosed;			tScavVaClosed;
	N2_GV2_Closed;			tN2_GV2_Closed;
	N2_GV1_Closed;			tN2_GV1_Closed;
	Eng_Dem_EPS_Ext;		tEng_Dem_EPS_Ext;
	DemEngOpExt;			tDemEngOpExt;
	SelGasTyp;				tSelGasTyp;
	SelGasTyp2;				tSelGasTyp2;
	SelGasTyp3;				tSelGasTyp3;
	SelGasTyp4;				tSelGasTyp4;
	Rel_MasCtr;				tRel_MasCtr;
	EVU_PowerSet3Dem;		tEVU_PowerSet3Dem;
	T_ECW;					tT_ECW;
	MO_PwrReply;			tMO_PwrReply;
	MO_PwrReply2;			tMO_PwrReply2;
	MO_PwrReply3;			tMO_PwrReply3;
	MO_PwrReply4;			tMO_PwrReply4;
	MO_SaftyLoop;			tMO_SaftyLoop;
	MO_PowerOverload;		tMO_PowerOverload;
	MO_PowerOverload2;		tMO_PowerOverload2;
	MO_PowerOverload3;		tMO_PowerOverload3;
	MO_PowerOverload4;		tMO_PowerOverload4;	
	Pos_Act_GM1_Norm;		tPos_Act_GM1_Norm;
	Pos_Act_GM2_Norm;		tPos_Act_GM2_Norm;
	ResetRemExt;			tResetRemExt;
	U_StarterBat;			tU_StarterBat;
	EOP_BWS;				tEOP_BWS;
	EOP_BWS2;				tEOP_BWS2;
	CC2WP_Op;				tCC2WP_Op;
	Pr_DAI_A;				tPr_DAI_A;
	Pr_DAI_B;				tPr_DAI_B;
	Pr_DAI_In;				tPr_DAI_In;
	T_DAI;					tT_DAI;
	DAI_V_Dem;				tDAI_V_Dem;
	DAI_V_Opened;			tDAI_V_Opened;
	DAI_V_Closed;			tDAI_V_Closed;
	DAI_Dem; 				tDAI_Dem;
	Pos_DAI_Set_A;			tPos_DAI_Set_A;
	Pos_DAI_Act_A;			tPos_DAI_Act_A;
	Pos_DAI_Set_B;			tPos_DAI_Set_B;
	Pos_DAI_Act_B;			tPos_DAI_Act_B;
	DAI_CB_On;				tDAI_CB_On;
	Actuator_Ok_DAI_A;		tActuator_Ok_DAI_A;
	Actuator_Ok_DAI_B;		tActuator_Ok_DAI_B;		
	
	(* SCR *)
	tFlow_SCR_UreaDosingOut;		Flow_SCR_UreaDosingOut;
	tFS_SCR_EMLine1_Lo;				FS_SCR_EMLine1_Lo;
	tFS_SCR_EMLine2_Lo;				FS_SCR_EMLine2_Lo;
	tLev_SCR_EMLine1_Hi;			Lev_SCR_EMLine1_Hi;
	tLev_SCR_EMLine2_Hi;			Lev_SCR_EMLine2_Hi;
	tLev_SCR_EMAir_Hi;				Lev_SCR_EMAir_Hi;
	tLev_SCR_UreaTank_Lo;			Lev_SCR_UreaTank_Lo;
	tLev_SCR_UreaDosingCabinet_Hi;	Lev_SCR_UreaDosingCabinet_Hi;
	tNO_SCR_EMLine1;				NO_SCR_EMLine1;
	tNO2_SCR_EMLine1;				NO2_SCR_EMLine1;
	tCO_SCR_EMLine1;				CO_SCR_EMLine1;
	tO2_SCR_EMLine1;				O2_SCR_EMLine1;
	tNO_SCR_EMLine2;				NO_SCR_EMLine2;
	tNO2_SCR_EMLine2;				NO2_SCR_EMLine2;
	tPc_SCR_UreaDosingPump_Set;		Pc_SCR_UreaDosingPump_Set;
	tPos_SCR_UreaDosingValve_Set;	Pos_SCR_UreaDosingValve_Set;
	tPos_SCR_UreaDosingValve2_Set;	Pos_SCR_UreaDosingValve2_Set;
	tPr_SCR_CatIn;					Pr_SCR_CatIn;
	tPr_SCR_CatOut;					Pr_SCR_CatOut;
	tPr_SCR_ComprAirSupply;			Pr_SCR_ComprAirSupply;
	tPr_SCR_UreaDosingIn;			Pr_SCR_UreaDosingIn;
	tPr_SCR_UreaDosingOut;			Pr_SCR_UreaDosingOut;
	tSCR_AirCompressor_Dem;			SCR_AirCompressor_Dem;
	tSCR_AirCompressor_Rdy;			SCR_AirCompressor_Rdy;
	tSCR_Aux_Dem;					SCR_Aux_Dem;
	tSCR_ComprAirValve_Dem;			SCR_ComprAirValve_Dem;
	tSCR_ComprAirValve_Rdy;			SCR_ComprAirValve_Rdy;
	tSCR_EMCooler_Rdy;				SCR_EMCooler_Rdy;
	tSCR_EMPump1_Dem;				SCR_EMPump1_Dem;
	tSCR_EMPump1_Rdy;				SCR_EMPump1_Rdy;
	tSCR_EMPump2_Dem;				SCR_EMPump2_Dem;
	tSCR_EMPump2_Rdy;				SCR_EMPump2_Rdy;
	tSCR_EMValve1_SGbOxi_Dem;		SCR_EMValve1_SGbOxi_Dem;
	tSCR_EMValve1_SGbCat_Dem;		SCR_EMValve1_SGbCat_Dem;
	tSCR_EMValve1_SG_Dem;			SCR_EMValve1_SG_Dem;
	tSCR_EMValve2_SG_Dem;			SCR_EMValve2_SG_Dem;
	tSCR_EMValve1_CG_Dem;			SCR_EMValve1_CG_Dem;
	tSCR_EMValve2_CG_Dem;			SCR_EMValve2_CG_Dem;
	tSCR_IndicatorLight;			SCR_IndicatorLight;
	tSCR_InjectValve_Air;			SCR_InjectValve_Air;
	tSCR_InjectValve_Opened;		SCR_InjectValve_Opened;
	tSCR_InjectValve_Open_Dem;		SCR_InjectValve_Open_Dem;
	tSCR_InjectValve_Urea;			SCR_InjectValve_Urea;
	tSCR_InjectValve_Urea_Dem;		SCR_InjectValve_Urea_Dem;
	tSCR_UreaDosingPump_Dem;		SCR_UreaDosingPump_Dem;
	tSCR_UreaDosingPump_Rdy;		SCR_UreaDosingPump_Rdy;
	tSCR_UreaDosingPump_Reset;		SCR_UreaDosingPump_Reset;
	tSCR_UreaDosingPump2_Dem;		SCR_UreaDosingPump2_Dem;
	tSCR_UreaDosingPump2_Rdy;		SCR_UreaDosingPump2_Rdy;
	tSCR_UreaDosingValve_Dem;		SCR_UreaDosingValve_Dem;
	tSCR_UreaDosingValve2_Dem;		SCR_UreaDosingValve2_Dem;
	tSCR_UreaSupplyPump_Dem;		SCR_UreaSupplyPump_Dem;
	tSCR_UreaSupplyPump_Op;			SCR_UreaSupplyPump_Op;
	tSCR_ValvePowerSupply_Ok;		SCR_ValvePowerSupply_Ok;
	tT_SCR_CatIn;					T_SCR_CatIn;
	tT_SCR_CatOut;					T_SCR_CatOut;
	tSCR_Catalyst_Rdy; 				SCR_Catalyst_Rdy;
	tT_SCR_Cat_HiHi;				T_SCR_Cat_HiHi;
	tSCR_DosingExt_On;				SCR_DosingExt_On;
	tLev_SCR_UreaTank;				Lev_SCR_UreaTank;
		
	(* Manuell *)
	Humidity_AirIn;			tHumidity_AirIn; 
	CustAnaOut;				tCustAnaOut;
	Ctr_CustOut;			tCtr_CustOut;
	CustDigOut;				tCustDigOut;
	GenCtrResetSp;			tGenCtrResetSp;
	GrC_DCon;				tGrC_DCon;
	T_AirIn;				tT_AirIn;
	Pos_Act_CBV_A1;			tPos_Act_CBV_A1;
	Pos_Act_CBV_A2;			tPos_Act_CBV_A2;
	Pos_Act_CBV_B1;			tPos_Act_CBV_B1;
	Pos_Act_CBV_B2;			tPos_Act_CBV_B2;
	Pos_Act_TV;				tPos_Act_TV;
	Pos_Act_TV_A1;			tPos_Act_TV_A1;
	Pos_Act_TV_A2;			tPos_Act_TV_A2;
	Pos_Act_TV_B1;			tPos_Act_TV_B1;
	Pos_Act_TV_B2;			tPos_Act_TV_B2;
	GT_SelectRatioMix;		tGT_SelectRatioMix;
	Ctr_GC_Set;				tCtr_GC_Set;
	MCB_Dcp_SetEUCOn;		tMCB_Dcp_SetEUCOn;
	MCB_Dcp_SetEUCOf;		tMCB_Dcp_SetEUCOf;
	MCB_Rel_Sync;			tMCB_Rel_Sync;
	MCB_DcpQu_SetEUCOn;		tMCB_DcpQu_SetEUCOn;
	MCB_DcpQu_SetEUCOf;		tMCB_DcpQu_SetEUCOf;
	RSE_SetEUCOn;			tRSE_SetEUCOn;
	RSE_SetEUCOf;			tRSE_SetEUCOf;
	P0_BLOCK_DEIE;			tP0_BLOCK_DEIE;
	P_DEIE;					tP_DEIE;
	MCB_SOn;				tMCB_SOn;
	MCB_Rel_Sync_SOn;		tMCB_Rel_Sync_SOn;
	Eng_Ready;				tEng_Ready;
	MCB_EDF_SOn;			tMCB_EDF_SOn;
	RSE_SOn;				tRSE_SOn;
	GCB_SOn;				tGCB_SOn;
	Pos_SGM_Enc1;			tPos_SGM_Enc1;
	Pos_SGM_Enc2;			tPos_SGM_Enc2;
	Pos_SGM_Enc3;			tPos_SGM_Enc3;
	SGM_DirStepper1;		tSGM_DirStepper1;
	SGM_EnabStepper1;		tSGM_EnabStepper1;
	SGM_DirStepper2;		tSGM_DirStepper2;
	SGM_EnabStepper2;		tSGM_EnabStepper2;
	SGM_DirStepper3;		tSGM_DirStepper3;
	SGM_EnabStepper3;		tSGM_EnabStepper3;
	P_Red_CH4Active;		tP_Red_CH4Active;
	P_Red_GasPrActive;		tP_Red_GasPrActive;
	P_Red_SuctPrActive;		tP_Red_SuctPrActive;
	ERDF_BLOCK;				tERDF_BLOCK;
	Pr_HW_Su_LT;			tPr_HW_Su_LT;
	Pr_HW_Su_HT;			tPr_HW_Su_HT;
	Pr_MGT_a_Filt;			tPr_MGT_a_Filt;
	Pr_PCGT_Out;			tPr_PCGT_Out;
	GT_AirSupply_LoLo;		tGT_AirSupply_LoLo;
	MGT_BOV;				tMGT_BOV;
	MGT_DBOV;				tMGT_DBOV;
	ChUnit3_CB_On;			tChUnit3_CB_On;
	ChUnit4_CB_On;			tChUnit4_CB_On;
	CV_Eng_Low;				tCV_Eng_Low;
	T_CBearing_Hi;			tT_CBearing_Hi;
	T_CBearing_HiHi;		tT_CBearing_HiHi;
	PS400V_ENGIA_CB_On;		tPS400V_ENGIA_CB_On;
	Pr_GR_I;				tPr_GR_I;
	Pr_GR_II;				tPr_GR_II;
	Pr_MGT_sp;				tPr_MGT_sp;
	MGT_BOV;				tMGT_BOV;
	Pr_PCGT_sp;				tPr_PCGT_sp;
	Pr_OilSkid_HP_DE;		tPr_OilSkid_HP_DE;
	Pr_OilSkid_HP_NDE;		tPr_OilSkid_HP_NDE;
	T_OilSkid_Supply;		tT_OilSkid_Supply;
	F_GenBear_DE1;			tF_GenBear_DE1;
	F_GenBear_DE2;			tF_GenBear_DE2;
	F_GenBear_NDE1;			tF_GenBear_NDE1;
	F_GenBear_NDE2;			tF_GenBear_NDE2;
	Flow_OilSkid_DE;		tFlow_OilSkid_DE;
	Flow_OilSkid_NDE;		tFlow_OilSkid_NDE;
	T_OilSkid_Tank;			tT_OilSkid_Tank;
	Lev_OilSkid_Tank;		tLev_OilSkid_Tank;
	T_GenAirOut;			tT_GenAirOut;
	OilSkid_MCB;			tOilSkid_MCB;
	OilSkid_AuxV_Ok;		tOilSkid_AuxV_Ok;
	OilSkid_PumpHP_DemOff;	tOilSkid_PumpHP_DemOff;
	OilSkid_PumpHP_DemOn;	tOilSkid_PumpHP_DemOn;
	OilSkid_Heater_CBOk;	tOilSkid_Heater_CBOk;
	OilSkid_PumpLP_CBOk;	tOilSkid_PumpLP_CBOk;
	OilSkid_Fan_CBOk;		tOilSkid_Fan_CBOk;
	OilSkid_PumpC_CBOk;		tOilSkid_PumpC_CBOk;
	OilSkid_PumpHP_CBOk;	tOilSkid_PumpHP_CBOk;
	Lev_OilSkid_Sump_Hi;	tLev_OilSkid_Sump_Hi;
	DPr_OilSkid_FiltLP_Hi;	tDPr_OilSkid_FiltLP_Hi;	
	DPr_OilSkid_FiltHP_DE_Hi;tDPr_OilSkid_FiltHP_DE_Hi;
	DPr_OilSkid_FiltHP_NDE_Hi;tDPr_OilSkid_FiltHP_NDE_Hi;
	OilSkid_PumpLP;			tOilSkid_PumpLP;
	OilSkid_Fan;			tOilSkid_Fan;
	OilSkid_PumpC;			tOilSkid_PumpC;
	OilSkid_PumpHP;			tOilSkid_PumpHP;
	OilSkid_Heater;			tOilSkid_Heater;
	T_EGbHPTC_A;			tT_EGbHPTC_A;
	T_EGaHPTC_A;			tT_EGaHPTC_A;
	T_EGbHPTC_B;			tT_EGbHPTC_B;
	T_EGaHPTC_B;			tT_EGaHPTC_B;
	Pr_EGbHPTC_A;			tPr_EGbHPTC_A;
	Pr_EGbHPTC_B;			tPr_EGbHPTC_B;
	Pr_EGaHPTC_A;			tPr_EGaHPTC_A;
	Pr_EGaLPTC_A;			tPr_EGaLPTC_A;
	Pr_Oil_LPTC_In_A;		tPr_Oil_LPTC_In_A;
	Pr_EGaHPTC_B;			tPr_EGaHPTC_B;
	Pr_EGaLPTC_A;			tPr_EGaLPTC_A;
	Pr_ECWaEng;				tPr_ECWaEng;
	Pr_PCGT_Out;			tPr_PCGT_Out;
	T_ECWbEng;				tT_ECWbEng;
	EOVal_LT_Set;			tEOVal_LT_Set;
	ECWP_Service_CB_On;		tECWP_Service_CB_On;
	ECWP_Service_COn;		tECWP_Service_COn;
	ECWV_Fail;				tECWV_Fail;
	GT_AirSupply_LoLo;		tGT_AirSupply_LoLo;
	ECWP_PreH_CB_On;		tECWP_PreH_CB_On;
	TCOP_CB_On;				tTCOP_CB_On;
	CV_TCA_Low;				tCV_TCA_Low;
	TCOP_Grid;				tTCOP_Grid;
	TCOP_GridOk;			tTCOP_GridOk;
	T_EO_PreH_HiHi;			tT_EO_PreH_HiHi;
	T_EO_PreH_Hi;			tT_EO_PreH_Hi;
	EngTurn2;				tEngTurn2;
	ChUnit2_CB_On;			tChUnit2_CB_On;
	ChUnit1_CB_On;			tChUnit1_CB_On;
	UPS_CB_On;				tUPS_CB_On;
	GenIF_CB_On;			tGenIF_CB_On;
	ENGIA_UPS_CB_On;		tENGIA_UPS_CB_On;
	TCOP_UPS_CB_On;			tTCOP_UPS_CB_On;
	ECWP_Service;			tECWP_Service;
	Pr_Oil_LPTC_In_B;		tPr_Oil_LPTC_In_B;
	Pr_EGaLPTC_B;			tPr_EGaLPTC_B;
	Pr_EGbHPTC_B;			tPr_EGbHPTC_B;
	T_EGbHPTC_A;			tT_EGbHPTC_A;
	T_EGbHPTC_B;			tT_EGbHPTC_B;
	T_EGaHPTC_A;			tT_EGaHPTC_A;
	T_EGaHPTC_B;			tT_EGaHPTC_B;
	F_GenBear_DE1;			tF_GenBear_DE1;
	F_GenBear_DE2;			tF_GenBear_DE2;
	F_GenBear_NDE1;			tF_GenBear_NDE1;
	F_GenBear_NDE2;			tF_GenBear_NDE2;
	Pr_Oil_LPTC_In_A;		tPr_Oil_LPTC_In_A;
	Pr_Oil_LPTC_In_B;		tPr_Oil_LPTC_In_B;
	T_EO_Pan;				tT_EO_Pan;
	GenHeat_CB_On;			tGenHeat_CB_On;
	T_GR;					tT_GR;
	GV1_line1_Open;			tGV1_line1_Open;
	GV1_line2_Open;			tGV1_line2_Open;
	GV1_line3_Open;			tGV1_line3_Open;
	GV1_line4_Open;			tGV1_line4_Open;
	PS_EI_CB_On;			tPS_EI_CB_On;
	STT_CB_On;				tSTT_CB_On;
	CV_MCP_Low;				tCV_MCP_Low;
	ENGIA_CB_On;			tENGIA_CB_On;
	FastStartReq;			tFastStartReq;
	VeryFastStartReq;		tVeryFastStartReq;
	U_GenDiode_Trip;		tU_GenDiode_Trip;
	Lev_OilSkid_Sump_Hi;	tLev_OilSkid_Sump_Hi;
	OilSkid_PumpLP_CBOk;	tOilSkid_PumpLP_CBOk;
	DPr_OilSkid_FiltLP_Hi;	tDPr_OilSkid_FiltLP_Hi;
	OilSkid_PumpHP_DemOn;	tOilSkid_PumpHP_DemOn;
	OilSkid_PumpHP_DemOff;	tOilSkid_PumpHP_DemOff;
	OilSkid_PumpHP_CBOk;	tOilSkid_PumpHP_CBOk;
	OilSkid_PumpHP_CBOk_UPS;tOilSkid_PumpHP_CBOk_UPS;
	OilSkid_Heater_CBOk;	tOilSkid_Heater_CBOk;
	DPr_OilSkid_FiltHP_DE_Hi;tDPr_OilSkid_FiltHP_DE_Hi;
	OilSkid_Fan_CBOk;		tOilSkid_Fan_CBOk;
	OilSkid_MCB;			tOilSkid_MCB;
	OilSkid_AuxV_Ok;		tOilSkid_AuxV_Ok;
	OilSkid_AuxV_Ok_UPS;	tOilSkid_AuxV_Ok_UPS;
	OilSkid_PumpC_CBOk;		tOilSkid_PumpC_CBOk;
	DPr_OilSkid_FiltHP_NDE_Hi;tDPr_OilSkid_FiltHP_NDE_Hi;	
	T_OilSkid_Supply;		tT_OilSkid_Supply;
	T_OilSkid_Tank;			tT_OilSkid_Tank;
	Lev_OilSkid_Tank;		tLev_OilSkid_Tank;
	Flow_OilSkid_DE;		tFlow_OilSkid_DE;
	Flow_OilSkid_NDE;		tFlow_OilSkid_NDE;
	Pr_OilSkid_HP_DE;		tPr_OilSkid_HP_DE;
	Pr_OilSkid_HP_NDE;		tPr_OilSkid_HP_NDE;
	OilSkid_PumpHP;			tOilSkid_PumpHP;
	OilSkid_PumpLP;			tOilSkid_PumpLP;	
	OilSkid_PumpHP_UPS;		tOilSkid_PumpHP_UPS;
	OilSkid_PumpHP_Soft;	tOilSkid_PumpHP_Soft;
	OilSkid_PumpC;			tOilSkid_PumpC;
	OilSkid_Fan;			tOilSkid_Fan;
	OilSkid_Heater;			tOilSkid_Heater;
	BbBlower_FC_Rdy;		tBbBlower_FC_Rdy;
	Pr_CC;					tPr_CC;
	Pr_f_BbFilt;			tPr_f_BbFilt;
	Pr_a_BbFilt;			tPr_a_BbFilt;
	Pr_f_BbFilt_A;			tPr_f_BbFilt_A;
	Pr_a_BbFilt_A;			tPr_a_BbFilt_A;
	Pr_f_BbFilt_B;			tPr_f_BbFilt_B;
	Pr_a_BbFilt_B;			tPr_a_BbFilt_B;
	BbBlower_y;				tBbBlower_y;
	BbBlower;				tBbBlower;
	Pr_AirStarter_Tank;		tPr_AirStarter_Tank;
	Pr_AirStarter_Supply;	tPr_AirStarter_Supply;
	Cnt_N_AirStarter;		tCnt_N_AirStarter;
	Actuator_Ok_CBV_A;		tActuator_Ok_CBV_A;
	Actuator_Ok_CBV_B;		tActuator_Ok_CBV_B;
	GT1_1_BackFireDev;		tGT1_1_BackFireDev;
	GT1_2_BackFireDev;		tGT1_2_BackFireDev;
	GT1_3_BackFireDev;		tGT1_3_BackFireDev;
	GT1_4_BackFireDev;		tGT1_4_BackFireDev;
	PCbComp_BackFireDev;	tPCbComp_BackFireDev;
	PCaComp_BackFireDev;	tPCaComp_BackFireDev;
	TempMax_GenCB;			tTempMax_GenCB;
	CDP_Dem;				tCDP_Dem;
	CDP_Op;					tCDP_Op;
	Ctr_CDSu_Set;			tCtr_CDSu_Set;
	T_CD_Su;				tT_CD_Su;
	T_CD_Re;				tT_CD_Re;
	Demnd_BHV;				tDemnd_BHV;
	BHV_Op;					tBHV_Op;
	BHV_Dem;				tBHV_Dem;
	AuxV_ModIf_ok;			tAuxV_ModIf_ok;
	AuxV_Aux_ok;			tAuxV_Aux_ok;
	EmStop_CoolRun;			tEmStop_CoolRun;
	L_DayOilTank_Hi;		tL_DayOilTank_Hi;
	DayOilTank_Leck;		tDayOilTank_Leck;
	L_DayOilSump_Hi;		tL_DayOilSump_Hi;
	FOP_Op;					tFOP_Op;
	MCB_COf_GCB_OpF;		tMCB_COf_GCB_OpF;
	Pr_Diff_ExGFilter;		tPr_Diff_ExGFilter;
	Pr_Diff_ExGCooler;		tPr_Diff_ExGCooler;
	HWF_Fail;				tHWF_Fail;
	HWF_Dem;				tHWF_Dem;
	T_HW_HC_Re;				tT_HW_HC_Re;
	Parallel_Op;			tParallel_Op;
	Island_Op;				tIsland_Op;
	ChC_Heating;			tChC_Heating;
	P_max_LSL;				tP_max_LSL;
	Pos_InlLou1;            tPos_InlLou1;
	Pos_InlLou2;            tPos_InlLou2;
	Pos_OutlLou1;           tPos_OutlLou1;
	Pos_OutlLou2;           tPos_OutlLou2;
	Pos_CircLou1;           tPos_CircLou1;
	Pos_CircLou2;           tPos_CircLou2;
	Pos_HW_ReValve;         tPos_HW_ReValve;
	Pos_HW_EC_ReValve;      tPos_HW_EC_ReValve;
	Pos_ChC_Valve;          tPos_ChC_Valve;
	P_Heat;                	tP_Heat;
	P_Heat_Imp;             tP_Heat_Imp;
	Ctr_InlLou_Set;         tCtr_InlLou_Set;
	Ctr_OutlLou_RT_Set;     tCtr_OutlLou_RT_Set;
	Ctr_OutlVE_RT_Set;		tCtr_OutlVE_RT_Set;
	Ctr_OutlLou_RDP_Set;    tCtr_OutlLou_RDP_Set;
	Ctr_OutlVE_RDP_Set;     tCtr_OutlVE_RDP_Set;
	Ctr_CircLou_Set;        tCtr_CircLou_Set;
	PrDiff_ER;              tPrDiff_ER;
	L_FreshOilTank_Hi;		tL_FreshOilTank_Hi;
	Leak_FreshOilPump;		tLeak_FreshOilPump;
	Leak_FreshOilTank;		tLeak_FreshOilTank;
	Leak_WasteOilPump;		tLeak_WasteOilPump;
	Leak_WasteOilTank;		tLeak_WasteOilTank;
	GF_OilSystem;			tGF_OilSystem;
	OF_FreshOilTank;		tOF_FreshOilTank;
	OF_WasteOilTank;		tOF_WasteOilTank;
	PCGT_SafeDevOK;			tPCGT_SafeDevOK;
	PCGT_SafeDevice;		tPCGT_SafeDevice;
	P_LimitSon_Gh;			tP_LimitSon_Gh;
	Actuator_Ok_WG;		tActuator_Ok_WG;
	Actuator_Ok_WG_A;		tActuator_Ok_WG_A;
	Actuator_Ok_WG_B;		tActuator_Ok_WG_B;
	GearPump_Dem;			tGearPump_Dem;	
	F_MMD_BusBar;			tF_MMD_BusBar;
	SIFA_BOV;				tSIFA_BOV;
	FireProtFlap1_InlAir_Closed; tFireProtFlap1_InlAir_Closed;
	FireProtFlap1_InlAir_Opened; tFireProtFlap1_InlAir_Opened;
	FireProtFlap2_InlAir_Closed; tFireProtFlap2_InlAir_Closed;
	FireProtFlap2_InlAir_Opened; tFireProtFlap2_InlAir_Opened;
	FireProtFlap1_OutlAir_Closed; tFireProtFlap1_OutlAir_Closed;
	FireProtFlap1_OutlAir_Opened; tFireProtFlap1_OutlAir_Opened;
	FireProtFlap2_OutlAir_Closed; tFireProtFlap2_OutlAir_Closed;
	FireProtFlap2_OutlAir_Opened; tFireProtFlap2_OutlAir_Opened;
	Pos_ChC2_Valve;			tPos_ChC2_Valve;
	ECW_ShutOffVal_Dem;				tECW_ShutOffVal_Dem;
	ValHeater_Dem;					tValHeater_Dem;
	FanRingHeater_Dem;				tFanRingHeater_Dem;

	EmStop_MC;				tEmStop_MC;
	EmStop_M;				tEmStop_M;
	EmStop_ST;				tEmStop_ST;
	EmStop_IS;				tEmStop_IS;
	EmStop_TS;				tEmStop_TS;
	EmStop_GENI;			tEmStop_GENI;
	EmStop_ENGIA;			tEmStop_ENGIA;
	EmStop_TCMI;			tEmStop_TCMI;
	EmStop_JWMI;			tEmStop_JWMI;
	EmStop_OILMI;			tEmStop_OILMI;
	EmStop_SCR;				tEmStop_SCR;
	EmStop_TCMSCAV;			tEmStop_TCMSCAV;
	Set_FC_COn;				tSet_FC_COn;
	Set_FC_COf;				tSet_FC_COf;
	Set_ILF_COn;			tSet_ILF_COn;
	Set_ILF_COf;			tSet_ILF_COf;
	Set_PU_COn;				tSet_PU_COn;
	Set_PU_COf;				tSet_PU_COf;
	P_FC_RMC_pos;			tP_FC_RMC_pos;
	P_FC_RMC_neg;			tP_FC_RMC_neg;
	P_Set_FC;				tP_Set_FC;
	FC_SOn;					tFC_SOn;
	FC_SOf;					tFC_SOf;
	ILF_SOn;				tILF_SOn;
	ILF_SOf;				tILF_SOf;
	PU_SOn;					tPU_SOn;
	PU_SOf;					tPU_SOf;
	F_Act_FC;				tF_Act_FC;
	P_Act_FC;				tP_Act_FC;
	F_Set_FC;				tF_Set_FC;		
	P_PRLCont_FC;			tP_PRLCont_FC;
	Pr_TCO;					tPr_TCO;
	TCOV_CoClose;			tTCOV_CoClose;

	Set_LFSMO_DB_COn;		tSet_LFSMO_DB_COn;
	Set_LFSMO_DB_COf;		tSet_LFSMO_DB_COf;
	F_LFSMO_DB;				tF_LFSMO_DB;
	Set_LFSMU_DB_COn;		tSet_LFSMU_DB_COn;
	Set_LFSMU_DB_COf;		tSet_LFSMU_DB_COf;
	F_LFSMU_DB;				tF_LFSMU_DB;
	Set_LFSMO_Droop_COn;	tSet_LFSMO_Droop_COn;
	Set_LFSMO_Droop_COf;	tSet_LFSMO_Droop_COf;
	F_LFSMO_Droop;			tF_LFSMO_Droop;
	Set_LFSMU_Droop_COn;	tSet_LFSMU_Droop_COn;
	Set_LFSMU_Droop_COf;	tSet_LFSMU_Droop_COf;
	F_LFSMU_Droop;			tF_LFSMU_Droop;
	Set_FSMU_Droop_COn;		tSet_FSMU_Droop_COn;
	Set_FSMU_Droop_COf;		tSet_FSMU_Droop_COf;
	F_FSMU_Droop;			tF_FSMU_Droop;
	Set_FSMO_Droop_COn;		tSet_FSMO_Droop_COn;
	Set_FSMO_Droop_COf;		tSet_FSMO_Droop_COf;
	F_FSMO_Droop;			tF_FSMO_Droop;
	Set_FSMU_DB_COn;		tSet_FSMU_DB_COn;
	Set_FSMU_DB_COf;		tSet_FSMU_DB_COf;
	F_FSMU_DB;				tF_FSMU_DB;
	Set_FSMO_DB_COn;		tSet_FSMO_DB_COn;
	Set_FSMO_DB_COf;		tSet_FSMO_DB_COf;
	F_FSMO_DB;				tF_FSMO_DB;
	Set_FSM_RMC_Up_COn;		tSet_FSM_RMC_Up_COn;
	Set_FSM_RMC_Up_COf;		tSet_FSM_RMC_Up_COf;
	P_FSM_RMC_Up;			tP_FSM_RMC_Up;
	Set_FSM_RMC_Down_COn;	tSet_FSM_RMC_Down_COn;
	Set_FSM_RMC_Down_COf;	tSet_FSM_RMC_Down_COf;
	P_FSM_RMC_Down;			tP_FSM_RMC_Down;
	Set_U_Droop_COn;		tSet_U_Droop_COn;
	Set_U_Droop_COf;		tSet_U_Droop_COf;
	U_Droop;				tU_Droop;
	Set_FSM_Rmp_COn;		tSet_FSM_Rmp_COn;
	Set_FSM_Rmp_COf;		tSet_FSM_Rmp_COf;
	FSM_Rmp_Up;				tFSM_Rmp_Up;
	FSM_Rmp_Down;			tFSM_Rmp_Down;
	Set_F_Ref_FSM_COn;		tSet_F_Ref_FSM_COn;
	Set_F_Ref_FSM_COf;		tSet_F_Ref_FSM_COf;
	F_Ref_FSM;				tF_Ref_FSM;
	JunctionBox_GnlAlm; tJunctionBox_GnlAlm;

	Dem_Ctr_Mns;			tDem_Ctr_Mns;					(*	V4.4 Basisupdate 01	 	 *)
	P_Mns_AnaIn;			tP_Mns_AnaIn;					(*	V4.4 Basisupdate 01	 	 *)
	Ctr_Mns_Anain_Setp_W_ext; tCtr_Mns_Anain_Setp_W_ext;	(*	V4.4 Basisupdate 01	 	 *)

	SPAx_CamDev;			tSPAx_CamDev;

	DI_OMS_Auto;		tDI_OMS_Auto;
	DI_OMS_Man;			tDI_OMS_Man;
	DI_RMS_On;			tDI_RMS_On;
	DI_RMS_Remote;		tDI_RMS_Remote;
	DI_SyOMS_Auto;		tDI_SyOMS_Auto;
	DI_SyOMS_Man;		tDI_SyOMS_Man;
	
	AfMnsF_ClosCond_Ok;			tAfMnsF_ClosCond_Ok;
	MnsOk_ClosCond_Skip;		tMnsOk_ClosCond_Skip;
	AfMnsF_ClosCond_Skip;		tAfMnsF_ClosCond_Skip;
	AfMnsF_LockEng_ClosCond;	tAfMnsF_LockEng_ClosCond;
	ClosCond;					tClosCond;
	AfMnsF_ClosCond;			tAfMnsF_ClosCond;
	ProtectionTest;				tProtectionTest;
	
	U_Bus_L1_2;				tU_Bus_L1_2;
	U_Bus_L2_3;				tU_Bus_L2_3;
	U_Bus_L3_1;				tU_Bus_L3_1;
	U_Bus_L1N;				tU_Bus_L1N;
	U_Bus_L2N;				tU_Bus_L2N;
	U_Bus_L3N;				tU_Bus_L3N;
	
	Ready4FastStart;		tReady4FastStart;
	Ready4VeryFastStart;	tReady4VeryFastStart;
	InAirER_Lou1Closed;		tInAirER_Lou1Closed;
	InAirER_Lou2Closed;		tInAirER_Lou2Closed;
	OutAirER_LouClosed;		tOutAirER_LouClosed;

	MidVoltCB_Failure;		tMidVoltCB_Failure;

	(* Opstate 4.7 addons *)
	P_Avail_Norm;			tP_Avail_Norm;
	P_Red_EU_Norm;			tP_Red_EU_Norm;

	OpMode_NetP;			tOpMode_NetP;
	OpMode_Island;			tOpMode_Island;
	OpMode_Idle;			tOpMode_Idle;
	Execute_BS;				tExecute_BS;

	U_Set_Norm;				tU_Set_Norm;
	U_SetExtAI_Norm;		tU_SetExtAI_Norm;
	ExtCtrOk;				tExtCtrOk;

	P_Droop_Set;			tP_Droop_Set;
	
	EngBlock_PlantCtr;		tEngBlock_PlantCtr;
	
	(*Gastrain V4.07 AddOn*)
	GV1_Opened;				tGV1_Opened;			(* NewPV  V4.07		*)
	GV1_Closed;				tGV1_Closed;			(* NewPV  V4.07		*)
	GV2_Opened;				tGV2_Opened;			(* NewPV  V4.07		*)
	GV2_Closed;				tGV2_Closed;			(* NewPV  V4.07		*)
	GV_Upstream_Opened;		tGV_Upstream_Opened;	(* NewPV  V4.07		*)
	GV_Upstream_Closed;		tGV_Upstream_Closed;	(* NewPV  V4.07		*)
	
	GV_Upstream_Open;		tGV_Upstream_Open;		(*DO open External Customer Gasvalve	 	OldName: NewPV  V4.07 	*)
	GV_Upstream_Release;	tGV_Upstream_Release;	(*DO release External Customer Gasvalve	 	OldName: NewPV  V4.07 	*)

	(* new with v4.09 *)
	T_GT_NG;				tT_GT_NG;
	Pr_GT_NG;				tPr_GT_NG;
	Vol_GT_NG;				tVol_GT_NG;
	T_EG_PrReliefVa1;		tT_EG_PrReliefVa1;
	T_EG_PrReliefVa2;		tT_EG_PrReliefVa2;
	GndFaultW;				tGndFaultW;	

	(* new with v4.10 *)	
	T_HW_EGHE_Hi;			tT_HW_EGHE_Hi;
	T_HW_EGCD_Hi;			tT_HW_EGCD_Hi;
	Cust_HW_Ext_Trip;		tCust_HW_Ext_Trip;

	Dem_EU_Block2;			tDem_EU_Block2;
	Dem_EU_Block3;			tDem_EU_Block3;
	EU_RM_BLOCK2;			tEU_RM_BLOCK2;
	EU_RM_BLOCK3;			tEU_RM_BLOCK3;
	MCP_AuxPS_CB_Trip;		tMCP_AuxPS_CB_Trip;
	MCP_AuxPS_CB_On;		tMCP_AuxPS_CB_On;
	MCP_AuxPS_GndFault;		tMCP_AuxPS_GndFault;
	MCP_FC_GndFault;		tMCP_FC_GndFault;
	MIP_FC_GndFault;		tMIP_FC_GndFault;
	AuxCP_FC_GndFault;		tAuxCP_FC_GndFault;
	AuxCP_AuxPS_GndFault;	tAuxCP_AuxPS_GndFault;
	AuxCP_AuxPS_CB_Trip;	tAuxCP_AuxPS_CB_Trip;
	AuxCP_AuxPS_CB_On;		tAuxCP_AuxPS_CB_On;
	GndFault_BB;			tGndFault_BB;
	TR_AuxPS_GndFault;		tTR_AuxPS_GndFault;
	TR_AuxPS_CB_Trip;		tTR_AuxPS_CB_Trip;
	TR_AuxPS_CB_On;			tTR_AuxPS_CB_On;

	(* new with v4.11 *)	
	F_FSM_Simulated;		tF_FSM_Simulated;
  	Q_Droop_Set;			tQ_Droop_Set;

	(* new with v4.12 *)	
	DemGenExcOff;			tDemGenExcOff;
	GenExcOff;				tGenExcOff;
	SyOMSS_Man;				tSyOMSS_Man;
	SyOMSS_Aut;				tSyOMSS_Aut;
	GenBearGreasSys2DE;		tGenBearGreasSys2DE;
	GenBearGreasSys4DE;		tGenBearGreasSys4DE;
	GenBearGreasSys2NDE;	tGenBearGreasSys2NDE;
	GenBearGreasSys4NDE;	tGenBearGreasSys4NDE;

	L_FreshOilTank;			tL_FreshOilTank;	(*V4.12 Spec 2022-112*)
	L_WasteOilTank;			tL_WasteOilTank;	(*V4.12 Spec 2022-112*)	
	L_DayOilTank;			tL_DayOilTank;		(*V4.12 Spec 2022-112*)

	DI_TestBench_TripPrio2;	tDI_TestBench_TripPrio2; 	(*Don't use - testbench only*)
	DI_TestBench_TripPrio3;	tDI_TestBench_TripPrio3;	(*Don't use - testbench only*)
	DI_TestBench_Warning;	tDI_TestBench_Warning;		(*Don't use - testbench only*)

	(* new with v4.13 *)	
	iTimeStamp_PosZeroCrossing_UGen1;
	iTimeStamp_PosZeroCrossing_UGen2;
	iTimeStamp_PosZeroCrossing_UGen3;

	(*new with V4.14 Oil Fill *)
	EO_FreshOilPump_Dem ;	tEO_FreshOilPump_Dem ; (*DO Aux FreshOilPump V4.14*)
	EO_WasteOilPump_Dem ;	tEO_WasteOilPump_Dem ; (*DO Aux WasteOilPump V4.14*)

//	Oil_Filling_Req ;		tOil_Filling_Req ; 		(*Operator button DI for Aux FreshOilPump V4.15x?*)
//	Oil_Change_StopReq;		tOil_Change_Req ;		(*Operator button DI to stop FreshOilPump/ WasteOilPump / Valve V4.15x?*)
//	Oil_Change_Req ;		tOil_Change_Req ; 		(*Operator button DI for Aux WaseOilPump V4.15x?*)

	(*new with V4.14 SafetyPlc *)
	GT3_SafeDevOK;				tGT3_SafeDevOK;							(* SAFETY PLC *)
	GT4_SafeDevOK;				tGT4_SafeDevOK;							(* SAFETY PLC *)
	GV3_Open;					tGV3_Open;								(* SAFETY PLC *)
	GV4_Open;					tGV4_Open;								(* SAFETY PLC *)
	GT1_GV1_Open;				tGT1_GV1_Open;							(* SAFETY PLC *)
	GT1_GV2_Open;				tGT1_GV2_Open;							(* SAFETY PLC *)
	GT2_GV1_Open;				tGT2_GV1_Open;							(* SAFETY PLC *)
	GT2_GV2_Open;				tGT2_GV2_Open;							(* SAFETY PLC *)
	GT3_GV1_Open;				tGT3_GV1_Open;							(* SAFETY PLC *)
	GT3_GV2_Open;				tGT3_GV2_Open;							(* SAFETY PLC *)
	GT4_GV1_Open;				tGT4_GV1_Open;							(* SAFETY PLC *)
	GT4_GV2_Open;				tGT4_GV2_Open;							(* SAFETY PLC *)


	(* new with v4.25 *)
	FireSysErr;			tFireSysErr;									(* SAFETY PLC *)
	GasSysErr;			tGasSysErr;										(* SAFETY PLC *)
	SL_TS_ECW;			tSL_TS_ECW;										(* SAFETY PLC *)
	SL_TS_HW_Su_Unit;	tSL_TS_HW_Su_Unit;								(* SAFETY PLC *)
	T_HW_Su_Unit;		tT_HW_Su_Unit;									(* SAFETY PLC *)
	EmStop_ER1;			tEmStop_ER1;									(* SAFETY PLC *)
	EmStop_ER2;			tEmStop_ER2;									(* SAFETY PLC *)
	EmStop_ER3;			tEmStop_ER3;									(* SAFETY PLC *)
	EmStop_ER4;			tEmStop_ER4;									(* SAFETY PLC *)
	EmStop_EXT;			tEmStop_EXT;									(* SAFETY PLC *)
	EmStop_TR;			tEmStop_TR;										(* SAFETY PLC *)
	EmStop_IP;			tEmStop_IP;										(* SAFETY PLC *)
	EmStop_MCP;			tEmStop_MCP;									(* SAFETY PLC *)
	EmStop_EGAT;		tEmStop_EGAT;									(* SAFETY PLC *)
	EmStop_PCGC;		tEmStop_PCGC;									(* SAFETY PLC *)
	EmStop_AUX;			tEmStop_AUX;									(* SAFETY PLC *)

	DCGA_GV_Open;		tDCGA_GV_Open;									(* SAFETY PLC *)
	DCGA_GV1_Open;		tDCGA_GV1_Open;									(* SAFETY PLC *)
	DCGA_GV2_Open;		tDCGA_GV2_Open;									(* SAFETY PLC *)

	ERV_INL1_Lou_OP;	tERV_INL1_Lou_OP;
	ERV_INL2_Lou_OP;	tERV_INL2_Lou_OP;
	ERV_INL3_Lou_OP;	tERV_INL3_Lou_OP;
	ERV_INL4_Lou_OP;	tERV_INL4_Lou_OP;
	ERV_INL5_Lou_OP;	tERV_INL5_Lou_OP;
	ERV_INL6_Lou_OP;	tERV_INL6_Lou_OP;

	ERV_INL1_Lou_CL;	tERV_INL1_Lou_CL;
	ERV_INL2_Lou_CL;	tERV_INL2_Lou_CL;
	ERV_INL3_Lou_CL;	tERV_INL3_Lou_CL;
	ERV_INL4_Lou_CL;	tERV_INL4_Lou_CL;
	ERV_INL5_Lou_CL;	tERV_INL5_Lou_CL;
	ERV_INL6_Lou_CL;	tERV_INL6_Lou_CL;

	ERV_OTL1_Lou_OP;	tERV_OTL1_Lou_OP;
	ERV_OTL2_Lou_OP;	tERV_OTL2_Lou_OP;
	ERV_OTL3_Lou_OP;	tERV_OTL3_Lou_OP;
	ERV_OTL4_Lou_OP;	tERV_OTL4_Lou_OP;
	ERV_OTL5_Lou_OP;	tERV_OTL5_Lou_OP;
	ERV_OTL6_Lou_OP;	tERV_OTL6_Lou_OP;

	ERV_OTL1_Lou_CL;	tERV_OTL1_Lou_CL;
	ERV_OTL2_Lou_CL;	tERV_OTL2_Lou_CL;
	ERV_OTL3_Lou_CL;	tERV_OTL3_Lou_CL;
	ERV_OTL4_Lou_CL;	tERV_OTL4_Lou_CL;
	ERV_OTL5_Lou_CL;	tERV_OTL5_Lou_CL;
	ERV_OTL6_Lou_CL;	tERV_OTL6_Lou_CL;

	ERV_INL1_Fan_Run;	tERV_INL1_Fan_Run;
	ERV_INL2_Fan_Run;	tERV_INL2_Fan_Run;
	ERV_INL3_Fan_Run;	tERV_INL3_Fan_Run;
	ERV_INL4_Fan_Run;	tERV_INL4_Fan_Run;
	ERV_INL5_Fan_Run;	tERV_INL5_Fan_Run;
	ERV_INL6_Fan_Run;	tERV_INL6_Fan_Run;


	(* System cyclic time violation monitoring *)	
	
	(* access USER Log *)
	ArEventLogGetIdent_0.Execute := TRUE;
	ArEventLogGetIdent_0.Name	 := '$$arlogusr';
	REPEAT												//Bugfix- disable line for PPC900 
		ArEventLogGetIdent_0();							//Bugfix- disable line for PPC900 
		UNTIL											//Bugfix- disable line for PPC900 
		ArEventLogGetIdent_0.Done = TRUE				//Bugfix- disable line for PPC900 
	END_REPEAT;											//Bugfix- disable line for PPC900 
	
	(* prepare logger entry *)
	ArEventLogWrite_0.Ident			 := ArEventLogGetIdent_0.Ident;
	ArEventLogWrite_0.OriginRecordID := 0;
	ArEventLogWrite_0.ObjectID		 := 'DIA.NE XT4';
	ArEventLogWrite_0.AddDataSize	 := SIZEOF(AddData);
	ArEventLogWrite_0.AddDataFormat	 := arEVENTLOG_ADDFORMAT_TEXT;
	ArEventLogWrite_0.AddData		 := ADR(AddData);
	ArEventLogWrite_0.TimeStamp		 := 0;
	ArEventLogWrite_0.EventID		 := ArEventLogMakeEventID(Severity:= arEVENTLOG_SEVERITY_WARNING, Facility:= 0, ErrorCode:= 9124);	//Bugfix- disable line for PPC900 
	
	(* set value for 1st call in cylic part *)
	iSysTime_DiffMax := 10000;
	
END_PROGRAM
