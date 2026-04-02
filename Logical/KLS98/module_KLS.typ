(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: Heating_Cooling_Pkg
 * File: module_Heat_Cool.typ
 * Author: 320003156
 * Created: July 06, 2011
 ********************************************************************
 * Data types of package Heating_Cooling_Pkg
 ********************************************************************)

TYPE
	CanDeviceGo : 	STRUCT 
		CANDevGo : ARRAY[0..1]OF USINT;
		ECANDevGo : USINT;
	END_STRUCT;
	IN_KLS_Struct : 	STRUCT 
		tAB2KL : AmmBase2MM; (* *) (*OldName:new; Cycle: 5*)
		tPB2MM : ParaBase2MM_type; (* *) (*OldName:FGDRPS; Cycle: 5*)
		iIdx_OMSS : INT; (*Operating mode manual*) (*OldName:BWS_HA; Cycle: 5*)
		rN_EngAct : REAL; (*Engine speed 1/min*) (*OldName:n_ist; Cycle: 5*)
		iCANIdent : UDINT; (* CAN identifier from HalIO *) (* OldName:new PV; Cycle:5 *)
		bSimWinMOD_Active : BOOL;
		iECanDevGo : USINT; (* event status CAN device go *) (* OldName:new PV; Cycle:5 *)
		rP_Act_Norm_Filt : REAL; (*actual power related to rP_Nom filtered T=1s*) (*OldName:P_IST; Cycle:5*)
	END_STRUCT;
	OUT_KLS_Struct : 	STRUCT 
		rKLS98_X_Window1 : ARRAY[0..24]OF REAL; (* cylinder values of KLS98 window 1 *) (*OldName:Fenst1; Cycle: 5*)
		rKLS98_X_Window2 : ARRAY[0..24]OF REAL; (* cylinder values of KLS98 window 2 *) (*OldName:Fenst2; Cycle: 5*)
		rKLS98_X_Window3 : ARRAY[0..24]OF REAL; (* cylinder values of KLS98 window 3 *) (*OldName:Fenst3; Cycle: 5*)
		rKLS98_X_Window4 : ARRAY[0..24]OF REAL; (* cylinder values of KLS98 window 4 *) (*OldName:Fenst4; Cycle: 5*)
		rKLS98_N_RunningHours : ARRAY[0..24]OF REAL; (* operating hours KLS98 device *) (*OldName:usKLSBetrH; Cycle: 5*)
		rKLS98_Vers_SW : ARRAY[0..24]OF REAL; (*kls98 version*) (*OldName:usKLSVers; Cycle: 5*)
		tKL2AB : MM2AmmBase; (* *) (*OldName:new; Cycle: 5*)
		tKL2PB : MM2ParaBase_type; (* *) (*OldName:new; Cycle: 5*)
		tKLS98_CanGo : CanDeviceGo; (* Start / Stop CAN communication *) (* OldName:CANDevGo; Cycle:5 *)
		bKLS98_Fault : ARRAY[0..24] OF BOOL; (* TRUE= faulty cyl. knocking signal *) (*OldName:bKLS98Fault; Cycle: 5*)
		bKLS98_Signal : ARRAY[0..24] OF BOOL; (* KLS Measurement Signal Knock Sensor *) (*OldName:KLSMS; Cycle: 5*)
		tE_KLS : ARRAY[0..24] OF _tEventKLS; (* CAN events KLS98 *)
		iKLS98CommErrCount : ARRAY[0..24] OF USINT;
	END_STRUCT;
	PARA_KLS_Struct : 	STRUCT 
		rKLS98_PosResImp : REAL; (*Position CAMSHAFT Reset*) (*OldName:PosResImp; Cycle: 5*)
		rCA_Win1_B : REAL; (*Window 1 - Start*) (*OldName:WMF1_B; Cycle: 5*)
		rCA_Win1_D : REAL; (*Window 1 - End*) (*OldName:WMF1_D; Cycle: 5*)
		rCA_Win2_B : REAL; (*Window 2 - Start*) (*OldName:WMF2_B; Cycle: 5*)
		rCA_Win2_D : REAL; (*Window 2 - End*) (*OldName:WMF2_D; Cycle: 5*)
		rKLS98_W2_Limit : REAL; (*Window 2 - Limit*) (*OldName:Fenst2LiMn; Cycle: 5*)
		rKLS98_MS_Limit : REAL; (*Measuring Signal failure Fenst2LiMn*) (*OldName:Fenst2LiMx; Cycle: 5*)
		iEng_Motortype : INT; (*Select engine type*) (*OldName:new; Cycle: 5*)
		bKLS98_Active : BOOL; (*Activate KLS*) (*OldName:kls98_vis; Cycle: 5*)
		iKlS_KnckValue_Limit : INT; (*Window 2 - Limit*) (*OldName:Fenst2LiMn; Cycle: 5*)
		iKlS_MSFailure_Limit : INT; (*Measuring Signal failure Fenst2LiMn*) (*OldName:Fenst2LiMx; Cycle: 5*)
	END_STRUCT;
	_tEventKLS : 	STRUCT 
		conf : ARRAY[0..99]OF USINT;
	END_STRUCT;
	MM2VIS_Struct : 	STRUCT 
		bMsg3131 : BOOL; (*3131*) (*OldName:KLS_CAN[1];Cycle: 5*)
		bMsg3132 : BOOL; (*3132*) (*OldName:KLS_CAN[2];Cycle: 5*)
		bMsg3133 : BOOL; (*3133*) (*OldName:KLS_CAN[3];Cycle: 5*)
		bMsg3134 : BOOL; (*3134*) (*OldName:KLS_CAN[4];Cycle: 5*)
		bMsg3135 : BOOL; (*3135*) (*OldName:KLS_CAN[5];Cycle: 5*)
		bMsg3136 : BOOL; (*3136*) (*OldName:KLS_CAN[6];Cycle: 5*)
		bMsg3137 : BOOL; (*3137*) (*OldName:KLS_CAN[7];Cycle: 5*)
		bMsg3138 : BOOL; (*3138*) (*OldName:KLS_CAN[8];Cycle: 5*)
		bMsg3139 : BOOL; (*3139*) (*OldName:KLS_CAN[9];Cycle: 5*)
		bMsg3140 : BOOL; (*3140*) (*OldName:KLS_CAN[10];Cycle: 5*)
		bMsg3151 : BOOL; (*3151*) (*OldName:KLSSOFTV;Cycle: 5*)
		bMsg3002 : BOOL; (*3002*) (*OldName:KLSFALSOF;Cycle: 5*)
		bMsg3210 : BOOL; (*3210*) (*OldName:KLSZAHN;Cycle: 5*)
		bMsg3211 : BOOL; (*3211*) (*OldName:KLSPAR;Cycle: 5*)
		bMsg3121 : BOOL; (*3121*) (*OldName:KLSCAM[1];Cycle: 5*)
		bMsg3122 : BOOL; (*3122*) (*OldName:KLSCAM[2];Cycle: 5*)
		bMsg3123 : BOOL; (*3123*) (*OldName:KLSCAM[3];Cycle: 5*)
		bMsg3124 : BOOL; (*3124*) (*OldName:KLSCAM[4];Cycle: 5*)
		bMsg3125 : BOOL; (*3125*) (*OldName:KLSCAM[5];Cycle: 5*)
		bMsg3126 : BOOL; (*3126*) (*OldName:KLSCAM[6];Cycle: 5*)
		bMsg3127 : BOOL; (*3127*) (*OldName:KLSCAM[7];Cycle: 5*)
		bMsg3128 : BOOL; (*3128*) (*OldName:KLSCAM[8];Cycle: 5*)
		bMsg3129 : BOOL; (*3129*) (*OldName:KLSCAM[9];Cycle: 5*)
		bMsg3130 : BOOL; (*3130*) (*OldName:KLSCAM[10];Cycle: 5*)
		bMsg3141 : BOOL; (*3141*) (*OldName:KLSTRI[1];Cycle: 5*)
		bMsg3142 : BOOL; (*3142*) (*OldName:KLSTRI[2];Cycle: 5*)
		bMsg3143 : BOOL; (*3143*) (*OldName:KLSTRI[3];Cycle: 5*)
		bMsg3144 : BOOL; (*3144*) (*OldName:KLSTRI[4];Cycle: 5*)
		bMsg3145 : BOOL; (*3145*) (*OldName:KLSTRI[5];Cycle: 5*)
		bMsg3146 : BOOL; (*3146*) (*OldName:KLSTRI[6];Cycle: 5*)
		bMsg3147 : BOOL; (*3147*) (*OldName:KLSTRI[7];Cycle: 5*)
		bMsg3148 : BOOL; (*3148*) (*OldName:KLSTRI[8];Cycle: 5*)
		bMsg3149 : BOOL; (*3149*) (*OldName:KLSTRI[9];Cycle: 5*)
		bMsg3150 : BOOL; (*3150*) (*OldName:KLSTRI[10];Cycle: 5*)
		bMsg3161 : BOOL; (*3161*)
		bMsg3162 : BOOL; (*3162*)
		bMsg3163 : BOOL; (*3163*)
		bMsg3164 : BOOL; (*3164*)
		bMsg3165 : BOOL; (*3165*)
		bMsg3166 : BOOL; (*3166*)
		bMsg3167 : BOOL; (*3167*)
		bMsg3168 : BOOL; (*3168*)
		bMsg3169 : BOOL; (*3169*)
		bMsg3170 : BOOL; (*3170*)
		bMsg3171 : BOOL; (*3171*)
		bMsg3172 : BOOL; (*3172*)
		bMsg3173 : BOOL; (*3173*)
		bMsg3174 : BOOL; (*3174*)
		bMsg3175 : BOOL; (*3175*)
		bMsg3176 : BOOL; (*3176*)
		bMsg3177 : BOOL; (*3177*)
		bMsg3178 : BOOL; (*3178*)
		bMsg3179 : BOOL; (*3179*)
		bMsg3180 : BOOL; (*3180*)
		bMsg3001 : BOOL; (*3001*) (*OldName:KLSSTOER;Cycle: 5*)
		bKLS98_Active : BOOL; (*Activate (*OldName:kls98_vis;Cycle: 5*)
		rKLS98_X_Window2 : ARRAY[0..24]OF REAL; (* cylinder values of KLS98 window 2 *) (*OldName:Fenst2;Cycle: 5*)
		rKLS98_Vers_SW : REAL; (*kls98 version*) (*OldName:usKLSVers; Cycle: 5*)
		iCMSinit_KLS98_status : INT; (* KLS98 Module CMS Init Status *)
		iCMSmain_KLS98_status : INT; (* KLS98 Module Main CMS Status *)
	END_STRUCT;
END_TYPE
