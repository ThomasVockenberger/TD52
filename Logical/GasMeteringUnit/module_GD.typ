(*******************************************************************************
	module_GMU : Type definitions for the GMU module
	
	This code is confidential and proprietary to the INNIO Company.
	It may not be used in any form, or reproduced in any manner, without the express
	written permission of the INNIO Company.
	Copyright, INNIO Company, 2019
	
	- calcualtion of different gas inject valve concerning parameters for gas sort 0
	- send parameter to gas inject valve
	- handling gas inject valve communication problem
	- read software version, operating hours, and gas inject valve status
	- check gas inject valve software version
	
	Customized modifications: -
	------------------------
	 
	History:
	-------

	V3.99.0 07-04-2012  pankajrodey	,  Added new version for Modular software
	V3.99.1 28-08-2012  pankajrodey	,  Added structures for MM2VIS ans VIS2MM
								
	Instructions for use:
	--------------------
	
	
	Outstandings:
	------------
	*******************************************************************************)

TYPE
	IN_GD_struct : 	STRUCT 
		tPB2MM : ParaBase2MM_type; (*parameter setup ok*) (*OldName: FGDRPS; Cycle: 5*)
		tGV1_Open : HALioDo_Type; (*DO: open gas valve 1*) (*OldName: GASV1; Cycle: 5*)
		tAB2GD : AmmBase2MM;
		tGV2_Open : HALioDo_Type; (*DO: open gas valve 2*) (*OldName: GASV2; Cycle: 5*)
		rP_Act_Norm_Filt : REAL; (*actual power related to rP_Nom [%] filtered T=1s*) (*OldName: P_IST_PROM; Cycle: 5*)
		iCANIdent : UDINT; (*CAN open status from CAN module*) (*OldName: new; Cycle: 5*)
		iSt_OpMode : UDINT; (* engine operation mode *) (*OldName: new; Cycle: 5*)
		ulGasFlowN : ARRAY[0..4]OF UDINT; (* setpoint gasflow one gas inject v *) (*OldName: ulGasFlowN; Cycle: 5*)
		iIdx_Gtyp_Dem : INT; (* actual gassort 1..4 *)
		bSimWinMOD_Active : BOOL;
		ulMonGasFlow : ARRAY[0..4]OF UDINT; (* minimum flow for monitoring *) (* OldName: ulMonGasFlow; Cycle: 2 *)
		bDualTJ : BOOL; (*Gas mixing with two TecJet´s*) (*OldName: bDualTJ; Cycle:5*)
		bDualTJ_TC2 : BOOL; (*Gas mixing with two TecJet´s*) (*OldName: bDualTJ; Cycle:2*)
		bLR_GasStop : BOOL; (*close gas valve to react on a load rejection by the GCB and force  actuators (open CBP, close TV)*)
		rGT_QualMix_1_2 : REAL; (*Mixture ratio between gas 1 and 2 [%]*) (*OldName: 	ssMisch1_2; Cycle: ; *)
		bCANCntReset : BOOL; (* CAN error counter value reset *) (*OldName: bCANCounterReset; Cycle:5;*)
		usGasDensN : ARRAY[0..4]OF UINT; (*Nominal gas density for usGasDensN*)
	END_STRUCT;
	OUT_GD_struct : 	STRUCT 
		rGMU_Pr_DiffGas : ARRAY[0..4]OF REAL; (*Differential Pressure over device [mbar*10]*) (*OldName: ulGasFlowN; Cycle: 5*)
		rGMU_Pos_Valve_Rad : ARRAY[0..4]OF REAL; (*Valve Position [rad *10]*) (*OldName: ssValvePos; Cycle: 5*)
		rGMU_Pos_Valve_Prom : ARRAY[0..4]OF REAL; (*Valve Position [%o]*) (*OldName: ssTJPos; Cycle: 5*)
		rGMU_Pr_FuelGas : ARRAY[0..4]OF REAL; (*Fuel Gas Pressure at device inlet [mbar*10]*) (*OldName: ssGasPress; Cycle: 5*)
		rGMU_T_FuelGas : ARRAY[0..4]OF REAL; (*Fuel Gas Temperature at device inlet [°C *10]*) (*OldName: ssGasTemp; Cycle: 5*)
		rGMU_Q_FuelGas : ARRAY[0..4]OF REAL; (*Fuel Gas Amount denormalized [l/s*1000]*) (*OldName: slGasFlow; Cycle: 5*)
		rGMU_D_FuelGas : ARRAY[0..4]OF REAL; (*Fuel Gas Density denormalized [kg/m3*1000]*) (*OldName: ssGasDens; Cycle: 5*)
		rGMU_N_RunningHours : ARRAY[0..4]OF REAL; (*Running hours of device [hours]*) (*OldName: usRHourTJ; Cycle: 5*)
		rGMU_S_Status : ARRAY[0..4]OF REAL; (*Status of device [-]*) (*OldName: usStateTJ; Cycle: 5*)
		tGD2AB : MM2AmmBase; (* *) (*OldName: new; Cycle: 5*)
		rGMU_Vers_SW : ARRAY[0..4]OF REAL; (*Firmware version*) (*OldName: usSWTecJet; Cycle: 5*)
		tGasMeteringUnit_CanGo : CanDeviceGo; (* *) (*OldName: new; Cycle: 5*)
		tGD2PB : MM2ParaBase_type; (* *) (*OldName: new; Cycle: 5*)
		iTecErrCntMax : ARRAY[0..4]OF USINT; (* max value for wrong gas flow trans *)
		iTecErrCnt : ARRAY[0..4]OF USINT; (* counter for wrong gas flow transm. *)
		iTecJetCommErrCount : USINT; (* timeout counter for comm. error *)
		tE_TEC : ARRAY[0..4]OF _tEventTEC; (* CAN events gas inject valve param. *)
		sGMU_Num_HWP : ARRAY[0..4]OF STRING[10]; (*Hardware part number of device*) (*OldName: new; Cycle: 5*)
		iGMU_Num_Ser : ARRAY[0..4]OF UDINT; (*serial number of device*) (*OldName: new; Cycle: 5*)
	END_STRUCT;
	Para_struct : 	STRUCT 
		iN_GMU_CAN : INT; (*Para: CAN node number of first device*) (*OldName: TecJet_Node; Cycle: 5*)
		iN_GMU_Devices : INT; (*PARA [11352]: Number of installed gas metering devices*) (*OldName: ucNrOfTJ; Cycle: 5*)
		usGasDensN : ARRAY[0..4]OF INT; (*Para: Nominal gas density *) (*OldName: usGasDensN; Cycle: 5*)
		rConst_GMU_Gas : REAL; (*Para: gas constant (default:=1300)*) (*OldName: usWobbeRef; Cycle: 5*)
		bGMU_ResetRunningHours : BOOL; (*Para: TRUE = reset running hours*) (*OldName: bReRunHour; Cycle: 5*)
		rPr_GMU_DiffMinimum : REAL; (*Para: Minimal allowed delta pressure over device [mbar] (default:= -20)*) (*OldName: ssMinDP; Cycle: 5*)
		rPr_GMU_DiffMaximum : REAL; (*Para: Maximal allowed delta pressure over device [mbar] (default:= 500)*) (*OldName: ssMaxDP; Cycle: 5*)
		rPr_GMU_Minimum : REAL; (*Para : Minimal allowed inlet fuel gas pressure [mbar] (default:= 500)*) (*OldName: ssMinPress; Cycle: 5*)
		rPr_GMU_Maximum : REAL; (*Para: Maximal allowed inelt fuel gas pressure [mbar] (default:= 1600)*) (*OldName: ssMaxPress; Cycle: 5*)
		rT_GMU_Minimum : REAL; (*Para: Minimal allowed fuel gas temperature [°C] (default:= -20)*) (*OldName: ssTempMin; Cycle: 5*)
		rT_GMU_Maximum : REAL; (*Para: Maximal allowed fuel gas temperature [°C] (default:= 90)*) (*OldName: ssTempMax; Cycle: 5*)
		iEng_Motortype : INT;
		bEng_Act_H2 : BOOL; (* PARA [tbd]: H2 engine active *)
	END_STRUCT;
	MM2VIS_struct : 	STRUCT 
		bMsg3093 : BOOL; (*3093*) (*OldName: TJ_Can; Cycle: 5*)
		bMsg3241 : BOOL; (*3241: Operating message tecjet CAN failure*) (*OldName: TJ_CAN_B; Cycle: 5*)
		iMsg3241 : INT; (*Error number tecjet CAN failure*) (*OldName: ucTJ_CAN; Cycle: 5*)
		bMsg3094 : BOOL; (*3094*) (*OldName: TJ_Softw; Cycle: 5*)
		bMsg3242 : BOOL; (*Operating message wrong Software version*) (*OldName: TJ_SOFTW_B; Cycle: 5*)
		iMsg3242 : INT; (*Error number wrong Software version*) (*OldName: ucTJ_SOFTW; Cycle: 5*)
		bMsg3095 : BOOL; (*3095*) (*OldName : TJ_GasT; Cycle : 5*)
		bMsg3243 : BOOL; (*Operating message : Gas temperature*) (*OldName : TJ_GAST_B; Cycle : 5*)
		iMsg3243 : INT; (*Error number : Gas Temperature*) (*OldName : ucTJ_GAST; Cycle : 5*)
		bMsg3096 : BOOL; (*3096*) (*OldName: TJ_GasD; Cycle: 5*)
		bMsg3244 : BOOL; (*Operating message : Gas differential pressure*) (*OldName : TJ_GASD_B; Cycle : 5*)
		iMsg3244 : INT; (*Error number : Gas differential pressure*) (*OldName : ucTJ_GASD; Cycle : 5*)
		bMsg3097 : BOOL; (*3097*) (*OldName: TJ_Int; Cycle: 5*)
		bMsg3245 : BOOL; (*Operating message : TECJET internal error*) (*OldName : TJ_INT_B; Cycle : 5*)
		iMsg3245 : INT; (*Error nmber : TECJET internal error*) (*OldName : ucTJ_INT; Cycle : 5*)
		bMsg3098 : BOOL; (*3098*) (*OldName: TJ_Mech; Cycle: 5*)
		bMsg3246 : BOOL; (*Operating message : TECTET Mechanical failure*) (*OldName : TJ_MECH_B; Cycle : 5*)
		iMsg3246 : INT; (*Error number : TECTET Mechanical failure*) (*OldName : ucTJ_MECH; Cycle : 5*)
		bMsg3213 : BOOL; (*3213*) (*OldName: TJ_GasN; Cycle: 5*)
		bMsg3249 : BOOL; (*Operating message : check gas inject valve gas flow not reached*) (*OldNmae : TJ_GASN_B; Cyclic : 5*)
		iMsg3249 : INT; (*Error number : check gas inject valve gas flow not reached*) (*OldName : ucTJ_GASN; Cyclic : 5*)
		rGMU_Pr_DiffGas : ARRAY[0..4]OF REAL; (*Differential Pressure over device [mbar*10]*) (*OldName: ssDPress; Cycle: 5*)
		rGMU_Pos_Valve_Rad : ARRAY[0..4]OF REAL; (*Valve Position [rad *10]*) (*OldName: ssValvePos; Cycle: 5*)
		rGMU_Pos_Valve_Prom : ARRAY[0..4]OF REAL; (*Valve Position [%o]*) (*OldName: ssTJPos; Cycle: 5*)
		rGMU_Pr_FuelGas : ARRAY[0..4]OF REAL; (*Fuel Gas Pressure at device inlet [mbar*10]*) (*OldName: ssGasPress; Cycle: 5*)
		rGMU_T_FuelGas : ARRAY[0..4]OF REAL; (*Fuel Gas Temperature at device inlet [°C *10]*) (*OldName: ssGasTemp; Cycle: 5*)
		rGMU_Q_FuelGas : ARRAY[0..4]OF REAL; (*Fuel Gas Amount denormalized [l/s*1000]*) (*OldName: slGasFlow; Cycle: 5*)
		rGMU_D_FuelGas : ARRAY[0..4]OF REAL; (*Fuel Gas Density denormalized [kg/m3*1000]*) (* OldName: ssGasDens; Cycle: 5*)
		rGMU_N_RunningHours : ARRAY[0..4]OF REAL; (*Running hours of device [hours]*) (*OldName: usRHourTJ; Cycle: 5*)
		rGMU_S_Status : ARRAY[0..4]OF REAL; (*Status of device [-]*) (*OldName: usStateTJ; Cycle: 5*)
		rGMU_Vers_SW : ARRAY[0..4]OF REAL; (*Firmware version*) (*OldName: usSWTecJet; Cycle: 5*)
		iCMSmain_TecJet_status : INT; (* TecJet CAN Module Main CMS Status *)
		iCMSinit_TecJet_status : INT; (* TecJet CAN Module CMS Init Status *)
		bFlow_GMU_Down : ARRAY[0..4]OF BOOL; (* zero flow detected *)
		bPr_Diff_GMU_Down : ARRAY[0..4]OF BOOL; (* zero flow detected *)
		bT_EU_GMU_HiHi : ARRAY[0..4]OF BOOL; (* Electronics temperature high *)
		bPos_GMU_Err : ARRAY[0..4]OF BOOL; (* Valve position error *)
		bFlow_GMU_Min : ARRAY[0..4]OF BOOL; (* flow not reached *)
		bValS_GMU_Ok : ARRAY[0..4]OF BOOL; (* Overall status ok *)
		bPr_GMU_HiHi : ARRAY[0..4]OF BOOL; (* fuel gas pressure high limit *)
		bPr_Diff_GMU_HiHi : ARRAY[0..4]OF BOOL; (* delta pressure high limit *)
		bT_GMU_HiHi : ARRAY[0..4]OF BOOL; (* fuel gas temp. high limit *)
		bU_GMU_HiHi : ARRAY[0..4]OF BOOL; (* Input voltage high limit *)
		bPr_GMU_LoLo : ARRAY[0..4]OF BOOL; (* fuel gas pressure low limit *)
		bPr_Diff_GMU_LoLo : ARRAY[0..4]OF BOOL; (* delta pressure low limit *)
		bT_GMU_LoLo : ARRAY[0..4]OF BOOL; (* fuel gas temp. low limit	*)
		bU_GMU_LoLo : ARRAY[0..4]OF BOOL; (* Input voltage low limit *)
		bInt_GMU_Err : ARRAY[0..4]OF BOOL; (* gas inject internal failure *)
		bMech_GMU_Err : ARRAY[0..4]OF BOOL; (* gas inject closed due to error - malfunction	*)
		bFlow_GMU_SetErr : ARRAY[0..4]OF BOOL; (* CAN flow demand failed *)
		sGMU_Num_HWP : ARRAY[0..4]OF STRING[10]; (* Tecjet hardware number*) (*OldName: usRHourTJ; Cycle: 5*)
		iGMU_Num_Ser : ARRAY[0..4]OF UDINT; (* Tecjet serial number*) (*OldName: usRHourTJ; Cycle: 5*)
		bGMU_SelfDiagnosis_ena : BOOL; (* Show Self Diagnosis Table on HMI *)
	END_STRUCT;
	CanDeviceGo : 	STRUCT 
		CANDevGo : ARRAY[0..1]OF USINT;
		ECANDevGo : USINT;
	END_STRUCT;
	_tEventTEC : 	STRUCT 
		Conf : ARRAY[0..8]OF USINT;
		Data : ARRAY[0..5]OF USINT;
		Contr : ARRAY[0..1]OF USINT;
		Status : ARRAY[0..5]OF USINT;
	END_STRUCT;
	_TecJetError : 	STRUCT 
		ucError : ARRAY[0..7]OF USINT;
	END_STRUCT;
END_TYPE
