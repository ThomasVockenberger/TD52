
TYPE
	IN_IC_Struct : 	STRUCT 
		tAB2IC : AmmBase2MM; (*AMM base to ICxx data transfer*) (*OldName:new PV; Cycle:2;*)
		tAB2IC_TC2 : AmmBase2MM; (*AMM base to ICxx data transfer*) (*OldName:new PV; Cycle:2;*)
		tPB2MM : ParaBase2MM_type; (*Data exchange structure to ParaBase*) (*OldName:new PV; Cycle:5;*)
		bIgn_SelfTest : BOOL; (*switch ignition system to selftest *) (*OldName:GoSelftest; Cycle:5;*)
		bEng_Dem : BOOL; (*module demanded*) (*OldName:M_AGFD; Cycle:5;*)
		iCANIdent : UDINT; (*ID number to check if CAN comm. start up was succesful*) (*OldName:ulCANIdent; Cycle:2;*)
		iCANIdent_TC8 : UDINT; (*ID number to check if CAN comm. start up was succesful*) (*OldName:ulCANIdent; Cycle:2;*)
		iSt_OpMode : UDINT; (*engine operation mode*) (*OldName:StartM,StopM; Cycle:5;*)
		iIdx_OMSS : INT; (*Index of operation mode selector switch 0  OFF, 1  MANUAL, 2  AUTOMATIC, 3 Test (Optional)*) (*OldName:BWS_HA,PROBE; Cycle:5;*)
		rCA_IgnP_Set_TC2 : REAL; (* actual ignition timing setpoint *) (*OldName:W_ZZP ; Cycle:5;*)
		rCA_IgnP_Set : REAL; (* actual ignition timing setpoint *) (*OldName:W_ZZP ; Cycle:5;*)
		rCA_Ign_Act_TC2 : ARRAY[0..24]OF REAL; (* actual cylinder igniton point *) (*OldName:ZZPCyl ; Cycle:5;*)
		rCA_Ign_Act : ARRAY[0..24]OF REAL; (* actual cylinder igniton point *) (*OldName:ZZPCyl ; Cycle:5;*)
		bIgn_Dem : BOOL; (*demand ignition*) (*OldName:ZUEND; Cycle:2;*)
		iMisfCyl : UDINT; (*cylinder misfire parameter *) (*OldName:MissfCyl; Cycle:2 *)
		bSimWinMOD_Active : BOOL; (* WinMode simulation active *) (* OldName:new PV; Cycle:5*)
		rP_Act_Norm_Filt : REAL; (*Actual power related to rP_Nom filtered T=1s*) (*OldName:W_ZZP ; Cycle:5;*)
	END_STRUCT;
	OUT_IC_Struct : 	STRUCT 
		tIC2PB : MM2ParaBase_type; (*Data exchange structure to ParaBase*) (*OldName:new PV; Cycle:5;*)
		tIC2AB : MM2AmmBase; (*ICxx module to AMM base data transfer*) (*OldName:new PV; Cycle:5;*)
		tICxx_CanGo : CanDeviceGo; (*Start / Stop CAN communication*) (*OldName:CANDevGo; Cycle:5;*)
		rN_IgnIC_Act : REAL; (*Engine speed measured by ignition IC*) (*OldName:ZDGSpeed; Cycle:1;*)
		b_IgnIC_SelfTestBack : BOOL; (*Feedback: Ignition system is in selftest mode*) (*OldName:GoSelftest; Cycle:5;*)
		iIC900CommErrCount : USINT; (* comm. error counter *)
		iE_IgnStat : USINT; (* events igniton system status *)
		bIC_OperationState : BOOL; (*IC operation state*)
		bIC_IgnEngergy_Hi : BOOL; (*IC Warning Maximum Energy Exceeded*)
		bIC_Ign_Run_CAN : BOOL; (*IC Output ignition active from CAN*)
	END_STRUCT;
	CanDeviceGo : 	STRUCT 
		CANDevGo : ARRAY[0..1]OF USINT;
		ECANDevGo : USINT;
	END_STRUCT;
	MM2VIS_Struct : 	STRUCT 
		bMsg3310 : BOOL; (*3310 Ignition output spare cylinder xx*) (*OldName:ZDGAUS_A; Cycle:;*)
		bMsg3240 : BOOL; (*3240 Ignition output monitoring cylinder xx *) (*OldName:ZDGAUS_B; Cycle:;*)
		bMsg3410 : BOOL; (*3410 Ignition output spare cylinder xx *) (*OldName:ZDGAUS_W; Cycle:;*)
		iMsg3240 : INT; (*3240 Ignition output spare cylinder xx, cylinder info number*) (*OldName:ucZylZAus; Cycle:;*)
		bMsg3027 : BOOL; (* 3027 Ignition CAM pickup missing *) (*OldName:ZDGCAM; Cycle:;*)
		bMsg3031 : BOOL; (* 3031 Ignition CAN communication failure *) (*OldName:ZDGCAN; Cycle:;*)
		bMsg3029 : BOOL; (* 3029 Ignition CPU failure *) (*OldName:ZDGCPU; Cycle:;*)
		bMsg3052 : BOOL; (* 3052 Wrong type of ignition system *) (*OldName:ZDGFALSCH; Cycle:;*)
		bMsg3209 : BOOL; (* 3209 Ignition setting is forbidden during the engine is running *) (*OldName:ZDGPAR; Cycle:;*)
		bMsg3030 : BOOL; (* 3030 Ignition parameter failure *) (*OldName:ZDGPARAM; Cycle:;*)
		bMsg3026 : BOOL; (* 3026 Ignition reset pickup missing *) (*OldName:ZDGRST; Cycle:;*)
		bMsg3025 : BOOL; (* 3025 Ignition trigger pickup missing *) (*OldName:ZDGTRI; Cycle:;*)
		bMsg3028 : BOOL; (* 3028 Ignition shutoff overspeed *) (*OldName:ZDGUEDZ; Cycle:;*)
		bIgnIC_CylOutFail : ARRAY[0..24]OF BOOL; (* Ignition system cylinder output failure *) (*OldName:IgnOFail; Cycle:;*)
		iIgnIC_VersionSW : INT; (* Ignition system software version *) (*OldName:IgnVers; Cycle:;*)
		iIgnIC_SysTypeHW : INT; (* Hardware type of ignition system  *) (*OldName:usIgnSystem; Cycle:;*)
		rEnergLev : REAL; (*Ignition system energy level % *)
		iCMSinit_IC900_status : INT; (* Ignition Module CMS Init Status *)
		iCMSmain_IC900_status : INT; (* Ignition Module Main CMS Status *)
		iNum_OutFailRate : USINT; (*Ignition controller output failure rate*)
		iTi_IgnOph : UINT; (*Ignition controller operating hours [h]*)
		iNum_SNYear : USINT; (*Serial number: year*)
		iNum_SNWeek : USINT; (*Serial number: week*)
		iNum_SNCnt : USINT; (*Serial number: counter*)
		rU_IC_Trig1 : REAL; (*Trigger 1 pickup peak voltage [V]*)
		rU_IC_Trig2 : REAL; (*Trigger 2 pickup peak voltage [V]*)
		rU_IC_Reset : REAL; (*Reset pickup peak voltage [V]*)
		bMsg9339 : BOOL; (*9339 Wrong ignition controller firmware*)
		bMsg9340 : BOOL; (*9340 Ignition failure trigger pickup*)
		bMsg9341 : BOOL; (*9341 Ignition failure reset pickup*)
		bMsg9342 : BOOL; (*9342 Ignition failure cam pickup*)
		bMsg9343 : BOOL; (*9343 Pickup degradation*)
		bMsg9049 : BOOL; (*9049 Ignition failure trigger pickup*)
		iMsg9049 : INT; (*9049 Ignition failure trigger pickup - info*)
		bMsg9315 : BOOL; (*9315 Ignition controller input voltage too low*)
		bMsg2363 : BOOL; (*2363 Ignition controller hardware failure*)
		bMsg2764 : BOOL; (*2764 Ignition controller temperature too high*)
		bMsg2767 : BOOL; (*2767 Wrong pickup polarity*)
		bIC_UnkEngAppCode : BOOL; (*Unknown engine application code*)
		bIC_CfgOoRange : BOOL; (*Configuration out of range*)
		bIC_UnkITP_ELvl : BOOL; (*Unknown global timing or energy level*)
		bIC_ITP_ELvlOoRange : BOOL; (*Global, individual timing or energy level out of range*)
		bIC_E2PROMErr : BOOL; (*E2PROM checksum error*)
		bIC_HwErr : BOOL; (*Hardware error*)
		bIC_OutHarnessErr : BOOL; (*Output harness error*)
		bIC_Overtemp : BOOL; (*Overtemperature*)
		bIC_DOFail : BOOL; (*Digital output failure*)
		rT_IC : REAL; (*Ignition controller temperature [degC]*)
		iE_PrimEnergy : ARRAY[0..24]OF UINT; (*Primary energy demand [mJ]*)
		iE_PrimEnergy_Min : UINT; (*Minimum primary energy demand [mJ]*)
		iE_PrimEnergy_Max : UINT; (*Maximum primary energy demand [mJ]*)
		iE_PrimEnergy_Avg : UINT; (*Average primary energy demand [mJ]*)
		iNum_PUMode : USINT; (*Pickup mode detected by SEMIC*)
		iNum_IC_NrTeethErr : UINT; (*Number of teeth at pickup error*)
		rNum_IcUpdProgress : REAL; (*IC updater progress bar*)
		rNum_SemicFw : REAL; (*SEMIC firmware available for download*)
		bIC_U_PuRes_Lo : BOOL; (*Reset pickup signal too low*)
		bIC_U_PuTrg1_Lo : BOOL; (*Trigger 1 pickup signal too low*)
		bIC_IgnEnaFail : BOOL; (*Ignition enable failure*)
		bIC_U_PuTrg2_Lo : BOOL; (*Trigger 2 pickup signal too low*)
		bIC_PolTrg1 : BOOL; (*Wrong polarity trigger 1 pickup signal*)
		bIC_PolTrg2 : BOOL; (*Wrong polarity trigger 2 pickup signal*)
		bIC_PolRes : BOOL; (*Wrong polarity reset pickup signal*)
		bMsg2367 : BOOL; (*2367 - Wrong or missing ignition coil*)
		bMsg9073 : BOOL; (*9073 - Wrong or missing ignition coil*)
		iMsg9073 : INT; (*9073 - Wrong or missing ignition coil - Cylinder info number*)
		bMsg2375 : BOOL; (*2375 - Ignition coil or wiring failure*)
	END_STRUCT;
	VIS2MM_Struct : 	STRUCT 
		bIC_UpdStart : BOOL; (*IC updater start/stop button*)
	END_STRUCT;
	tZDGSpeed : 	STRUCT 
		ICSpdAvg : UINT; (*Average engine speed from ignition controller [rpm]*)
		ICSpd16Teeth : UINT; (*16-teeth engine speed from ignition controller [rpm]*)
		ICSpdSPAx : UINT; (*SPAx engine speed from ignition controller [rpm * 10]*)
		ICSpd4Teeth : UINT; (*4-teeth engine speed from ignition controller [rpm]*)
	END_STRUCT;
	IC_FiringDist : 	STRUCT 
		DistOddToEven : UINT; (*Firing distance odd to even output [degCA*10]*)
		DistEvenToOdd : UINT; (*Firing distance even to odd output [degCA*10]*)
	END_STRUCT;
	IC_Curr : 	STRUCT 
		Current : UINT; (*Ignition pulse step current [%]*)
		Duration : UINT; (*Ignition pulse step duration*)
	END_STRUCT;
	IC_CoilPara : 	STRUCT 
		TimeToPeak : UINT; (*Time to peak voltage [us]*)
		CoilCurrMax : USINT; (*Maximum primary coil current [A]*)
		IgnEnergyMax : UINT; (*Maximum energy for firing event [mJ]*)
	END_STRUCT;
	IC_SpDur : 	STRUCT 
		SpDur : UINT; (*Spark duration [us]*)
		SpDurMin : USINT; (*Minimum spark duration [%]*)
	END_STRUCT;
	IC_SpdST : 	STRUCT 
		Spd_SelfTest : UINT; (*Speed for self-test [rpm]*)
		TiSTSpdRamp : UINT; (*Selft-test speed ramp-up / down time [s*10]*)
	END_STRUCT;
	IC_U_Pickups : 	STRUCT 
		U_Trigger1 : UINT; (*Trigger 1 pickup peak voltage [V*10]*)
		U_Trigger2 : UINT; (*Trigger 2 pickup peak voltage [V*10]*)
		U_Reset : UINT; (*Reset pickup peak voltage [V*10]*)
	END_STRUCT;
	IC_SpInfo : 	STRUCT 
		Voltage : UINT; (*Spark voltage [kV*10]*)
		PrimEnergy : UINT; (*Primary energy demand [mJ]*)
	END_STRUCT;
	IC_PUNoiseRate : 	STRUCT 
		Trigger1 : USINT; (*Trigger 1 pickup noise rate [1/s]*)
		Trigger2 : USINT; (*Trigger 2 pickup noise rate [1/s]*)
		Reset : USINT; (*Reset pickup noise rate [1/s]*)
		Cam : USINT; (*CAM pickup noise rate [1/s]*)
		TRIGGER : USINT; (*TRG pickup noise rate [1/s]*)
		CAMRESET : USINT; (*C/R pickup noise rate [1/s]*)
	END_STRUCT;
	IC_PrimEnergyStat : 	STRUCT 
		PrimEnergyMin : UINT; (*Minimum primary energy demand [mJ]*)
		PrimEnergyAvg : UINT; (*Avergae primary energy demand [mJ]*)
		PrimEnergyMax : UINT; (*Maximum primary energy demand [mJ]*)
	END_STRUCT;
	CoilParam : 	STRUCT 
		data1 : USINT;
		data2 : USINT;
		data3 : USINT;
		data4 : USINT;
		data5 : USINT;
		data6 : USINT;
	END_STRUCT;
	CoilParam5 : 	STRUCT 
		data1 : USINT;
		data2 : USINT;
		data3 : USINT;
		data4 : USINT;
		data5 : USINT;
	END_STRUCT;
	CoilParam6 : 	STRUCT 
		data1 : USINT;
		data2 : USINT;
	END_STRUCT;
	IC_CurrPmmReal : 	STRUCT 
		Current : REAL;
		Time : REAL;
	END_STRUCT;
END_TYPE
