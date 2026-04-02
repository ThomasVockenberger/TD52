
TYPE
	IN_MO_Struct : 	STRUCT 
		tPB2MM : ParaBase2MM_type; (*Data exchange structure to ParaBase*) (*OldName:new PV; Cycle:5;*)
		iCANIdent : UDINT; (*CAN identifier from HalIO*) (*OldName:new PV; Cycle:2;*)
		bMisfCOn : BOOL; (*Misfire Command On *) (*OldName: MissfCmd; Cycle:5; *)
		tAB2MO : AmmBase2MM; (*AMM base to Monic data transfer*) (*OldName:QUITT_WA; Cycle:2;*)
	END_STRUCT;
	OUT_MO_Struct : 	STRUCT 
		tMO2PB : MM2ParaBase_type; (*Data exchange structure to ParaBase*) (*OldName:new PV; Cycle:5;*)
		tMO2AB : MM2AmmBase; (*Monic module to AMM base data transfer*) (*OldName:new PV; Cycle:5;*)
		rU_IgnMon_Max : REAL; (*maximum ignition voltage *) (*OldName:MaxVolt; Cycle:5;*)
		rU_IgnMon_Min : REAL; (*minimum ignition voltage *) (*OldName:MinVolt; Cycle:5;*)
		iNum_IgnMon_Ver : INT; (*monic software version *) (*OldName:MonStatus; Cycle:5;*)
		rU_IgnMon_Cyl : ARRAY[0..24]OF REAL; (*ignition voltage for each cylinder *) (*OldName:V_Zyl; Cycle:5;*)
		tMonic_CanGo : CanDeviceGo; (*Start / Stop CAN communication*) (*OldName:new PV; Cycle:5;*)
		iMonicCommErrCount : USINT; (* counter comunication error monic *)
		iEMonStatus : USINT; (* event monic status *)
	END_STRUCT;
	_tMonicLimitREAL : 	STRUCT 
		limit : REAL;
		kind : REAL;
		delay : REAL;
	END_STRUCT;
	_tMonicLimit : 	STRUCT 
		limit : INT;
		kind : INT;
		delay : INT;
	END_STRUCT;
	CanDeviceGo : 	STRUCT 
		CANDevGo : ARRAY[0..1]OF USINT; (*Start CAN communication and ID*)
		ECANDevGo : USINT; (*Wvent PV for start/stop communication*)
	END_STRUCT;
	MM2VIS_Struct : 	STRUCT 
		rNum_IgnMon_Ver : REAL; (*Version of the firmware *) (*OldName:MonicVers; Cycle:;*)
		bMsg3201 : BOOL; (*W3201 MONIC CAN communication failure *) (*OldName:MONCAN; Cycle:;*)
		bMsg3202 : BOOL; (*W3202 MONIC CPU failure *) (*OldName:MONCPU; Cycle:;*)
		bMsg3203 : BOOL; (*W3203 MONIC wiring failure *) (*OldName:MONDRA; Cycle:;*)
		bMsg3181 : BOOL; (*W3203 MONIC AIC offset failure cylinder 1 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3182 : BOOL; (*W3203 MONIC AIC offset failure cylinder 2 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3183 : BOOL; (*W3203 MONIC AIC offset failure cylinder 3 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3184 : BOOL; (*W3203 MONIC AIC offset failure cylinder 4 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3185 : BOOL; (*W3203 MONIC AIC offset failure cylinder 5 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3186 : BOOL; (*W3203 MONIC AIC offset failure cylinder 6 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3187 : BOOL; (*W3203 MONIC AIC offset failure cylinder 7 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3188 : BOOL; (*W3203 MONIC AIC offset failure cylinder 8 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3189 : BOOL; (*W3203 MONIC AIC offset failure cylinder 9 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3190 : BOOL; (*W3203 MONIC AIC offset failure cylinder 10 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3191 : BOOL; (*W3203 MONIC AIC offset failure cylinder 11 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3192 : BOOL; (*W3203 MONIC AIC offset failure cylinder 12 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3193 : BOOL; (*W3203 MONIC AIC offset failure cylinder 13 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3194 : BOOL; (*W3203 MONIC AIC offset failure cylinder 14 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3195 : BOOL; (*W3203 MONIC AIC offset failure cylinder 15 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3196 : BOOL; (*W3203 MONIC AIC offset failure cylinder 16 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3197 : BOOL; (*W3203 MONIC AIC offset failure cylinder 17 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3198 : BOOL; (*W3203 MONIC AIC offset failure cylinder 18 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3199 : BOOL; (*W3203 MONIC AIC offset failure cylinder 19 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3200 : BOOL; (*W3203 MONIC AIC offset failure cylinder 20 *) (*OldName:MONOFF; Cycle:;*)
		bMsg3204 : BOOL; (*W3204 MONIC parametering is running *) (*OldName:MONPAR; Cycle:;*)
		bMsg3208 : BOOL; (*W3208 MONIC firing voltage difference too high *) (*OldName:MONZ_D; Cycle:;*)
		bMsg3206 : BOOL; (*W3206 MONIC firing voltage too high *) (*OldName:MONZ_H; Cycle:;*)
		bMsg3207 : BOOL; (*W3207 MONIC average firing voltage too high *) (*OldName:MONZ_M; Cycle:;*)
		bMsg3205 : BOOL; (*W3205 MONIC firing voltage too low *) (*OldName:MONZ_N; Cycle:;*)
		iCMSinit_Monic_status : INT; (* Monic Module CMS Init Status *)
		iCMSmain_Monic_status : INT; (* Monic Module Main CMS Status *)
	END_STRUCT;
END_TYPE
