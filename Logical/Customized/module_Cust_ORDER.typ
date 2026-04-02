(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: Customized_Pkg
 * File: module_Cust_ORDER.typ
 * Author: Zengerer
 * Created: Oct. 30, 2012
 ********************************************************************
 * DECLARE PLANT SPECIFIC DATA TYPES HERE, for package Customized_Pkg
 *     (ADD ELEMENTS FOR USE ON ONLY THIS SPECIFIC PLANT HERE)
 ********************************************************************)

TYPE
	IN_Cust_Plant_Struct : 	STRUCT 
		ReplaceMeWithYourVariableName : BOOL;
	END_STRUCT;
	OUT_Cust_Plant_Struct : 	STRUCT 
		ReplaceMeWithYourVariableName : BOOL;
	END_STRUCT;
	PARA_Cust_Plant_Struct : 	STRUCT 
		ReplaceMeWithYourVariableName : BOOL;
	END_STRUCT;
	Vis2MM_Plant_Struct : 	STRUCT 
		ReplaceMeWithYourVariableName : BOOL;
	END_STRUCT;
	MM2Vis_Plant_Struct : 	STRUCT 
		ReplaceMeWithYourVariableName : BOOL;
		bAirInFan_OutputHWFault : ARRAY[0..3]OF BOOL;
		rAirInFan_Speed : ARRAY[0..3]OF REAL;
		rAirInFan_InputSpeed : ARRAY[0..3]OF REAL;
		rDumpRadiator_Speed : ARRAY[0..3]OF REAL;
		rDumpRadiator_InputSpeed : ARRAY[0..3]OF REAL;
		bAirInFan_DisEngSpeedHigh : ARRAY[0..3]OF BOOL;
		bAirInFan_EngSpeedLow : ARRAY[0..3]OF BOOL;
		bAirInFan_SensorPowerFault : ARRAY[0..3]OF BOOL;
		bAirInFan_SensorPowerHigh : ARRAY[0..3]OF BOOL;
		bAirInFan_SensorPowerLow : ARRAY[0..3]OF BOOL;
		bAirInFan_InputPowerFault : ARRAY[0..3]OF BOOL;
		bAirInFan_InputPowerHigh : ARRAY[0..3]OF BOOL;
		bAirInFan_InputPowerLow : ARRAY[0..3]OF BOOL;
		bAirInFan_ClutchOutputFault : ARRAY[0..3]OF BOOL;
		bAirInFan_ClutchOutputOpen : ARRAY[0..3]OF BOOL;
		bAirInFan_ClutchOutputShort : ARRAY[0..3]OF BOOL;
		bAirInFan_EngineRPMFault : ARRAY[0..3]OF BOOL;
		bAirInFan_APPFault : ARRAY[0..3]OF BOOL;
		bAirInFan_InputSpeedError : ARRAY[0..3]OF BOOL;
		bAirInFan_APTFault : ARRAY[0..3]OF BOOL;
		bAirInFan_OutHardwareFault : ARRAY[0..3]OF BOOL;
		bAirInFan_FanSpeedError : ARRAY[0..3]OF BOOL;
		bAirInFan_ExcessFanSpeed : ARRAY[0..3]OF BOOL;
		bAirInFan_NoFanSpeed : ARRAY[0..3]OF BOOL;
		bAirInFan_FanSpeedPinFault : ARRAY[0..3]OF BOOL;
		bAirInFan_SPN2978InputFault : ARRAY[0..3]OF BOOL;
		bAirInFan_InputSpeedGThanM : ARRAY[0..3]OF BOOL;
		bAirInFan_FanCmdGThanMax : ARRAY[0..3]OF BOOL;
		bAirInFan_FanCmdLThanMITS : ARRAY[0..3]OF BOOL;
		bAirInFan_FanCmdLThanMICS : ARRAY[0..3]OF BOOL;
		bDumpRadiator_OutputHWFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_DisEngSpeedHigh : ARRAY[0..3]OF BOOL;
		bDumpRadiator_EngSpeedLow : ARRAY[0..3]OF BOOL;
		bDumpRadiator_SensorPowerFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_SensorPowerHigh : ARRAY[0..3]OF BOOL;
		bDumpRadiator_SensorPowerLow : ARRAY[0..3]OF BOOL;
		bDumpRadiator_InputPowerFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_InputPowerHigh : ARRAY[0..3]OF BOOL;
		bDumpRadiator_InputPowerLow : ARRAY[0..3]OF BOOL;
		bDumpRadiator_ClutchOutputFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_ClutchOutputOpen : ARRAY[0..3]OF BOOL;
		bDumpRadiator_ClutchOutputShort : ARRAY[0..3]OF BOOL;
		bDumpRadiator_EngineRPMFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_APPFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_InputSpeedError : ARRAY[0..3]OF BOOL;
		bDumpRadiator_APTFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_OutHardwareFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_FanSpeedError : ARRAY[0..3]OF BOOL;
		bDumpRadiator_ExcessFanSpeed : ARRAY[0..3]OF BOOL;
		bDumpRadiator_NoFanSpeed : ARRAY[0..3]OF BOOL;
		bDumpRadiator_FanSpeedPinFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_SPN2978InputFault : ARRAY[0..3]OF BOOL;
		bDumpRadiator_InputSpeedGThanM : ARRAY[0..3]OF BOOL;
		bDumpRadiator_FanCmdGThanMax : ARRAY[0..3]OF BOOL;
		bDumpRadiator_FanCmdLThanMITS : ARRAY[0..3]OF BOOL;
		bDumpRadiator_FanCmdLThanMICS : ARRAY[0..3]OF BOOL;
		bDumpRadiator_WarningMsg : ARRAY[0..3]OF BOOL;
		bAirInFan_WarningMsg : ARRAY[0..3]OF BOOL;
		bDumpRadiatorCAN : ARRAY[0..3]OF BOOL;
		bAirInFanCAN : ARRAY[0..3]OF BOOL;
		bAirInFanRUN : ARRAY[0..3]OF BOOL;
		bDumpRadiatorRUN : ARRAY[0..3]OF BOOL;
		bDumpRadiator_CANWarningMsg : BOOL;
		bAirInFan_CANWarningMsg : BOOL;
	END_STRUCT;
END_TYPE
