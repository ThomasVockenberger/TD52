(*******************************************************************************
NOxSensor: 	 		CAN communication to Horton CAN bus device (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2026

Customized modifications: -
------------------------

History:
-------

V4.16.00.00	06.01.2026	Bencze,  HORTON CAN bus device Cyclic code

Instructions for use:
--------------------

-----------------------------------------------------------------------------------------------------------------------------------------------	*)

PROGRAM _CYCLIC

	// Trigger reception of the data
	TON_1sTick(IN := NOT TON_1sTick.Q, PT := T#800ms);				(* 80ms + 2 times cycle time = 100ms *)

	// CAN communication timeout warning timers 
	FOR DeviceNumber := 0 TO 3 DO
		TON_10sTick_DumpRadiator[DeviceNumber](IN := NOT DumpRadiator_PGN_Message_CS1[DeviceNumber].CommandDone OR NOT DumpRadiator_PGN_Message_CS2[DeviceNumber].CommandDone, PT := T#9800ms);
		TON_10sTick_AirInFan[DeviceNumber](IN := NOT AirInFan_PGN_Message_CS1[DeviceNumber].CommandDone OR NOT AirInFan_PGN_Message_CS2[DeviceNumber].CommandDone, PT := T#9800ms);
	END_FOR;
	
	// DumpRadiator - Connection with Map Services
	DumpRadiator_PGN_Message_CS1[0].MpLink := ADR(Dump_Radiator_1_CS1);
	DumpRadiator_PGN_Message_CS2[0].MpLink := ADR(Dump_Radiator_1_CS2);
	DumpRadiator_PGN_Message_CS1[1].MpLink := ADR(Dump_Radiator_2_CS1);
	DumpRadiator_PGN_Message_CS2[1].MpLink := ADR(Dump_Radiator_2_CS2);
	DumpRadiator_PGN_Message_CS1[2].MpLink := ADR(Dump_Radiator_3_CS1);
	DumpRadiator_PGN_Message_CS2[2].MpLink := ADR(Dump_Radiator_3_CS2);
	DumpRadiator_PGN_Message_CS1[3].MpLink := ADR(Dump_Radiator_4_CS1);
	DumpRadiator_PGN_Message_CS2[3].MpLink := ADR(Dump_Radiator_4_CS2);
	
	// AirInFan - Connection with Map Services
	AirInFan_PGN_Message_CS1[0].MpLink := ADR(Air_Inlet_Fan_1_CS1);
	AirInFan_PGN_Message_CS2[0].MpLink := ADR(Air_Inlet_Fan_1_CS2);
	AirInFan_PGN_Message_CS1[1].MpLink := ADR(Air_Inlet_Fan_2_CS1);
	AirInFan_PGN_Message_CS2[1].MpLink := ADR(Air_Inlet_Fan_2_CS2);
	AirInFan_PGN_Message_CS1[2].MpLink := ADR(Air_Inlet_Fan_3_CS1);
	AirInFan_PGN_Message_CS2[2].MpLink := ADR(Air_Inlet_Fan_3_CS2);
	AirInFan_PGN_Message_CS1[3].MpLink := ADR(Air_Inlet_Fan_4_CS1);
	AirInFan_PGN_Message_CS2[3].MpLink := ADR(Air_Inlet_Fan_4_CS2);
	
	FOR DeviceNumber := 0 TO 3 DO
		// Specific messages 1 (CS1 - Horton documentation)
		DumpRadiator_PGN_Message_CS1[DeviceNumber].Enable := TRUE;
		DumpRadiator_PGN_Message_CS1[DeviceNumber].Receive := TON_1sTick.Q;
		DumpRadiator_PGN_Message_CS1[DeviceNumber].PGN := 65470;
		DumpRadiator_PGN_Message_CS1[DeviceNumber].Priority := 5;
		DumpRadiator_PGN_Message_CS1[DeviceNumber].DataLength := 8;
		DumpRadiator_PGN_Message_CS1[DeviceNumber].Data := ADR(DumpRadiator_CS1_RawData[DeviceNumber]);
		DumpRadiator_PGN_Message_CS1[DeviceNumber]();

		// Specific messages 2 (CS2 - Horton documentation)
		DumpRadiator_PGN_Message_CS2[DeviceNumber].Enable := TRUE;
		DumpRadiator_PGN_Message_CS2[DeviceNumber].Receive := TON_1sTick.Q;
		DumpRadiator_PGN_Message_CS2[DeviceNumber].PGN := 65469;
		DumpRadiator_PGN_Message_CS2[DeviceNumber].Priority := 5;
		DumpRadiator_PGN_Message_CS2[DeviceNumber].DataLength := 8;
		DumpRadiator_PGN_Message_CS2[DeviceNumber].Data := ADR(DumpRadiator_CS2_RawData[DeviceNumber]);
		DumpRadiator_PGN_Message_CS2[DeviceNumber]();
		
		// Specific messages 1 (CS1 - Horton documentation)
		AirInFan_PGN_Message_CS1[DeviceNumber].Enable := TRUE;
		AirInFan_PGN_Message_CS1[DeviceNumber].Receive := TON_1sTick.Q; 	 
		AirInFan_PGN_Message_CS1[DeviceNumber].PGN := 65470;
		AirInFan_PGN_Message_CS1[DeviceNumber].Priority := 5;
		AirInFan_PGN_Message_CS1[DeviceNumber].DataLength := 8;
		AirInFan_PGN_Message_CS1[DeviceNumber].Data := ADR(AirInFan_CS1_RawData[DeviceNumber]);
		AirInFan_PGN_Message_CS1[DeviceNumber]();

		// Specific messages 2 (CS2 - Horton documentation)
		AirInFan_PGN_Message_CS2[DeviceNumber].Enable := TRUE;
		AirInFan_PGN_Message_CS2[DeviceNumber].Receive := TON_1sTick.Q;
		AirInFan_PGN_Message_CS2[DeviceNumber].PGN := 65469;
		AirInFan_PGN_Message_CS2[DeviceNumber].Priority := 5;
		AirInFan_PGN_Message_CS2[DeviceNumber].DataLength := 8;
		AirInFan_PGN_Message_CS2[DeviceNumber].Data := ADR(AirInFan_CS2_RawData[DeviceNumber]);
		AirInFan_PGN_Message_CS2[DeviceNumber]();
	END_FOR;
	

	FOR DeviceNumber := 0 TO 3 DO
		// DumpRadiator - Measured Fan Speed and Speed signal from PLC (AO)
		MM2VIS_ThisPlant.rDumpRadiator_Speed[DeviceNumber] := DumpRadiator_CS1_RawData[DeviceNumber].Data2 + DumpRadiator_CS1_RawData[DeviceNumber].Data3 * 256; // Fan speed to the device
		MM2VIS_ThisPlant.rDumpRadiator_InputSpeed[DeviceNumber] := DumpRadiator_CS1_RawData[DeviceNumber].Data6 + DumpRadiator_CS1_RawData[DeviceNumber].Data7 * 256; // Fan speed measurement coming to PLC
	
		// AirInFan - Measured Fan Speed and Speed signal from PLC (AO)
		MM2VIS_ThisPlant.rAirInFan_Speed[DeviceNumber] := AirInFan_CS1_RawData[DeviceNumber].Data2 + AirInFan_CS1_RawData[DeviceNumber].Data3 * 256; // Fan speed to the device
		MM2VIS_ThisPlant.rAirInFan_InputSpeed[DeviceNumber]  := AirInFan_CS1_RawData[DeviceNumber].Data6 + AirInFan_CS1_RawData[DeviceNumber].Data7 * 256; // Fan speed measurement coming to PLC
	END_FOR;
	
	// Dump Radiators are running
	MM2VIS_ThisPlant.bDumpRadiatorRUN[0] := (MM2VIS_ThisPlant.rDumpRadiator_InputSpeed[0] >= OUT_CU.rCust_SparePara[26]);
	MM2VIS_ThisPlant.bDumpRadiatorRUN[1] := (MM2VIS_ThisPlant.rDumpRadiator_InputSpeed[1] >= OUT_CU.rCust_SparePara[26]);
	MM2VIS_ThisPlant.bDumpRadiatorRUN[2] := (MM2VIS_ThisPlant.rDumpRadiator_InputSpeed[2] >= OUT_CU.rCust_SparePara[26]);
	MM2VIS_ThisPlant.bDumpRadiatorRUN[3] := (MM2VIS_ThisPlant.rDumpRadiator_InputSpeed[3] >= OUT_CU.rCust_SparePara[26]);
	// Air Inlet Fans are running
	MM2VIS_ThisPlant.bAirInFanRUN[0] := (MM2VIS_ThisPlant.rAirInFan_InputSpeed[0] >= OUT_CU.rCust_SparePara[39]);
	MM2VIS_ThisPlant.bAirInFanRUN[1] := (MM2VIS_ThisPlant.rAirInFan_InputSpeed[1] >= OUT_CU.rCust_SparePara[39]);
	MM2VIS_ThisPlant.bAirInFanRUN[2] := (MM2VIS_ThisPlant.rAirInFan_InputSpeed[2] >= OUT_CU.rCust_SparePara[39]);
	MM2VIS_ThisPlant.bAirInFanRUN[3] := (MM2VIS_ThisPlant.rAirInFan_InputSpeed[3] >= OUT_CU.rCust_SparePara[39]);
	
	FOR DeviceNumber := 0 TO 3 DO
		// DumpRadiator - Clutch status 
		MM2VIS_ThisPlant.bDumpRadiator_FanCmdLThanMICS[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data2.3; // Fan command less than MICS (Min Controllable Fan Speed)
		MM2VIS_ThisPlant.bDumpRadiator_FanCmdLThanMITS[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data2.4; // Fan command less than MITS (Min Maintained Fan Speed)
		MM2VIS_ThisPlant.bDumpRadiator_FanCmdGThanMax[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data2.5; // Fan command greater than Max Fan Speed.
		MM2VIS_ThisPlant.bDumpRadiator_InputSpeedGThanM[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data2.6; // Input speed greater than MAOS (Max Allowed Operating Fan Speed)	
		
		MM2VIS_ThisPlant.bDumpRadiator_SPN2978InputFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data4.0; // SPN2978 Input Fault
		MM2VIS_ThisPlant.bDumpRadiator_FanSpeedPinFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data4.1; // Fan Speed Pin Fault
		MM2VIS_ThisPlant.bDumpRadiator_NoFanSpeed[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data4.2; // No Fan Speed
		MM2VIS_ThisPlant.bDumpRadiator_ExcessFanSpeed[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data4.3; // Excess Fan Speed
		MM2VIS_ThisPlant.bDumpRadiator_FanSpeedError[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data4.4; // Fan Speed Error
		MM2VIS_ThisPlant.bDumpRadiator_OutputHWFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data4.5; // Output Hardware Fault (MUST REPLACE CONTROLLER)
		MM2VIS_ThisPlant.bDumpRadiator_APTFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data4.6; // APT Fault
		MM2VIS_ThisPlant.bDumpRadiator_InputSpeedError[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data4.7; // Input Speed Error
		
		MM2VIS_ThisPlant.bDumpRadiator_APPFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data5.3; // APP Fault
		MM2VIS_ThisPlant.bDumpRadiator_EngineRPMFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data5.4; // Engine RPM Fault
		MM2VIS_ThisPlant.bDumpRadiator_ClutchOutputShort[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data5.5; // Fan Clutch Output Short
		MM2VIS_ThisPlant.bDumpRadiator_ClutchOutputOpen[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data5.6; // Fan Clutch Output Open
		MM2VIS_ThisPlant.bDumpRadiator_ClutchOutputFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data5.7; // Fan Clutch Output Fault
		MM2VIS_ThisPlant.bDumpRadiator_InputPowerLow[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data6.0; // Input Power Low
		MM2VIS_ThisPlant.bDumpRadiator_InputPowerHigh[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data6.1; // Input Power High
		MM2VIS_ThisPlant.bDumpRadiator_InputPowerFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data6.2; // Input Power Fault
		MM2VIS_ThisPlant.bDumpRadiator_SensorPowerLow[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data6.3; // Sensor Power Low
		MM2VIS_ThisPlant.bDumpRadiator_SensorPowerHigh[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data6.4; // Sensor Power High
		MM2VIS_ThisPlant.bDumpRadiator_SensorPowerFault[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data6.5; // Sensor Power Fault
		MM2VIS_ThisPlant.bDumpRadiator_EngSpeedLow[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data6.6; // Engagement fault (fan speed low)
		MM2VIS_ThisPlant.bDumpRadiator_DisEngSpeedHigh[DeviceNumber] := DumpRadiator_CS2_RawData[DeviceNumber].Data6.7; // Disengagement fault (fan speed high)

		// DumpRadiator - Warning messages - Status
		MM2VIS_ThisPlant.bDumpRadiator_WarningMsg[DeviceNumber] := 	MM2VIS_ThisPlant.bDumpRadiator_FanCmdLThanMICS[DeviceNumber]	OR MM2VIS_ThisPlant.bDumpRadiator_FanCmdLThanMITS[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bDumpRadiator_FanCmdGThanMax[DeviceNumber] 	OR MM2VIS_ThisPlant.bDumpRadiator_InputSpeedGThanM[DeviceNumber] 	OR		
		MM2VIS_ThisPlant.bDumpRadiator_SPN2978InputFault[DeviceNumber] 	OR MM2VIS_ThisPlant.bDumpRadiator_FanSpeedPinFault[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bDumpRadiator_NoFanSpeed[DeviceNumber] 		OR MM2VIS_ThisPlant.bDumpRadiator_ExcessFanSpeed[DeviceNumber] 		OR
		MM2VIS_ThisPlant.bDumpRadiator_FanSpeedError[DeviceNumber] 		OR MM2VIS_ThisPlant.bDumpRadiator_OutputHWFault[DeviceNumber] 		OR
		MM2VIS_ThisPlant.bDumpRadiator_APTFault[DeviceNumber] 			OR MM2VIS_ThisPlant.bDumpRadiator_InputSpeedError[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bDumpRadiator_APPFault[DeviceNumber] 			OR MM2VIS_ThisPlant.bDumpRadiator_EngineRPMFault[DeviceNumber] 		OR
		MM2VIS_ThisPlant.bDumpRadiator_ClutchOutputShort[DeviceNumber] 	OR MM2VIS_ThisPlant.bDumpRadiator_ClutchOutputOpen[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bDumpRadiator_ClutchOutputFault[DeviceNumber] 	OR MM2VIS_ThisPlant.bDumpRadiator_InputPowerLow[DeviceNumber] 		OR
		MM2VIS_ThisPlant.bDumpRadiator_InputPowerHigh[DeviceNumber] 	OR MM2VIS_ThisPlant.bDumpRadiator_InputPowerFault[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bDumpRadiator_SensorPowerLow[DeviceNumber] 	OR MM2VIS_ThisPlant.bDumpRadiator_SensorPowerHigh[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bDumpRadiator_SensorPowerFault[DeviceNumber] 	OR MM2VIS_ThisPlant.bDumpRadiator_EngSpeedLow[DeviceNumber] 		OR
		MM2VIS_ThisPlant.bDumpRadiator_DisEngSpeedHigh[DeviceNumber];
		
		// AirInFan - Clutch status 
		MM2VIS_ThisPlant.bAirInFan_FanCmdLThanMICS[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data2.3; // Fan command less than MICS (Min Controllable Fan Speed)
		MM2VIS_ThisPlant.bAirInFan_FanCmdLThanMITS[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data2.4; // Fan command less than MITS (Min Maintained Fan Speed)
		MM2VIS_ThisPlant.bAirInFan_FanCmdGThanMax[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data2.5; // Fan command greater than Max Fan Speed.
		MM2VIS_ThisPlant.bAirInFan_InputSpeedGThanM[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data2.6; // Input speed greater than MAOS (Max Allowed Operating Fan Speed)
		
		MM2VIS_ThisPlant.bAirInFan_SPN2978InputFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data4.0; // SPN2978 Input Fault
		MM2VIS_ThisPlant.bAirInFan_FanSpeedPinFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data4.1; // Fan Speed Pin Fault
		MM2VIS_ThisPlant.bAirInFan_NoFanSpeed[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data4.2; // No Fan Speed
		MM2VIS_ThisPlant.bAirInFan_ExcessFanSpeed[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data4.3; // Excess Fan Speed
		MM2VIS_ThisPlant.bAirInFan_FanSpeedError[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data4.4; // Fan Speed Error
		MM2VIS_ThisPlant.bAirInFan_OutputHWFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data4.5; // Output Hardware Fault (MUST REPLACE CONTROLLER)
		MM2VIS_ThisPlant.bAirInFan_APTFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data4.6; // APT Fault
		MM2VIS_ThisPlant.bAirInFan_InputSpeedError[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data4.7; // Input Speed Error
		
		MM2VIS_ThisPlant.bAirInFan_APPFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data5.3; // APP Fault
		MM2VIS_ThisPlant.bAirInFan_EngineRPMFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data5.4; // Engine RPM Fault
		MM2VIS_ThisPlant.bAirInFan_ClutchOutputShort[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data5.5; // Fan Clutch Output Short
		MM2VIS_ThisPlant.bAirInFan_ClutchOutputOpen[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data5.6; // Fan Clutch Output Open
		MM2VIS_ThisPlant.bAirInFan_ClutchOutputFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data5.7; // Fan Clutch Output Fault
		MM2VIS_ThisPlant.bAirInFan_InputPowerLow[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data6.0; // Input Power Low
		MM2VIS_ThisPlant.bAirInFan_InputPowerHigh[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data6.1; // Input Power High
		MM2VIS_ThisPlant.bAirInFan_InputPowerFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data6.2; // Input Power Fault
		MM2VIS_ThisPlant.bAirInFan_SensorPowerLow[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data6.3; // Sensor Power Low
		MM2VIS_ThisPlant.bAirInFan_SensorPowerHigh[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data6.4; // Sensor Power High
		MM2VIS_ThisPlant.bAirInFan_SensorPowerFault[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data6.5; // Sensor Power Fault
		MM2VIS_ThisPlant.bAirInFan_EngSpeedLow[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data6.6; // Engagement fault (fan speed low)
		MM2VIS_ThisPlant.bAirInFan_DisEngSpeedHigh[DeviceNumber] := AirInFan_CS2_RawData[DeviceNumber].Data6.7; // Disengagement fault (fan speed high)
		
		// AirInFan - Warning messages - Status
		MM2VIS_ThisPlant.bAirInFan_WarningMsg[DeviceNumber] := 	MM2VIS_ThisPlant.bAirInFan_FanCmdLThanMICS[DeviceNumber]	OR MM2VIS_ThisPlant.bAirInFan_FanCmdLThanMITS[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bAirInFan_FanCmdGThanMax[DeviceNumber] 	OR MM2VIS_ThisPlant.bAirInFan_InputSpeedGThanM[DeviceNumber] 	OR		
		MM2VIS_ThisPlant.bAirInFan_SPN2978InputFault[DeviceNumber] 	OR MM2VIS_ThisPlant.bAirInFan_FanSpeedPinFault[DeviceNumber]	OR
		MM2VIS_ThisPlant.bAirInFan_NoFanSpeed[DeviceNumber] 		OR MM2VIS_ThisPlant.bAirInFan_ExcessFanSpeed[DeviceNumber]		OR
		MM2VIS_ThisPlant.bAirInFan_FanSpeedError[DeviceNumber] 		OR MM2VIS_ThisPlant.bAirInFan_OutputHWFault[DeviceNumber] OR
		MM2VIS_ThisPlant.bAirInFan_APTFault[DeviceNumber] 			OR MM2VIS_ThisPlant.bAirInFan_InputSpeedError[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bAirInFan_APPFault[DeviceNumber] 			OR MM2VIS_ThisPlant.bAirInFan_EngineRPMFault[DeviceNumber] 		OR
		MM2VIS_ThisPlant.bAirInFan_ClutchOutputShort[DeviceNumber] 	OR MM2VIS_ThisPlant.bAirInFan_ClutchOutputOpen[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bAirInFan_ClutchOutputFault[DeviceNumber] 	OR MM2VIS_ThisPlant.bAirInFan_InputPowerLow[DeviceNumber] 		OR
		MM2VIS_ThisPlant.bAirInFan_InputPowerHigh[DeviceNumber]		OR MM2VIS_ThisPlant.bAirInFan_InputPowerFault[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bAirInFan_SensorPowerLow[DeviceNumber] 	OR MM2VIS_ThisPlant.bAirInFan_SensorPowerHigh[DeviceNumber] 	OR
		MM2VIS_ThisPlant.bAirInFan_SensorPowerFault[DeviceNumber]	OR MM2VIS_ThisPlant.bAirInFan_EngSpeedLow[DeviceNumber] 		OR
		MM2VIS_ThisPlant.bAirInFan_DisEngSpeedHigh[DeviceNumber];
	END_FOR;
	
		
		
	// CAN error - Reset the data
	FOR DeviceNumber := 0 TO 3 DO
		IF TON_10sTick_DumpRadiator[DeviceNumber].Q THEN
			DumpRadiator_CS1_RawData[DeviceNumber].Data0 := 0;
			DumpRadiator_CS1_RawData[DeviceNumber].Data1 := 0;
			DumpRadiator_CS1_RawData[DeviceNumber].Data2 := 0;
			DumpRadiator_CS1_RawData[DeviceNumber].Data3 := 0;
			DumpRadiator_CS1_RawData[DeviceNumber].Data4 := 0;
			DumpRadiator_CS1_RawData[DeviceNumber].Data5 := 0;
			DumpRadiator_CS1_RawData[DeviceNumber].Data6 := 0;
			DumpRadiator_CS1_RawData[DeviceNumber].Data7 := 0;

			DumpRadiator_CS2_RawData[DeviceNumber].Data0 := 0;
			DumpRadiator_CS2_RawData[DeviceNumber].Data1 := 0;
			DumpRadiator_CS2_RawData[DeviceNumber].Data2 := 0;
			DumpRadiator_CS2_RawData[DeviceNumber].Data3 := 0;
			DumpRadiator_CS2_RawData[DeviceNumber].Data4 := 0;
			DumpRadiator_CS2_RawData[DeviceNumber].Data5 := 0;
			DumpRadiator_CS2_RawData[DeviceNumber].Data6 := 0;
			DumpRadiator_CS2_RawData[DeviceNumber].Data7 := 0;
		END_IF;
		
		IF TON_10sTick_AirInFan[DeviceNumber].Q THEN
			AirInFan_CS1_RawData[DeviceNumber].Data0 := 0;
			AirInFan_CS1_RawData[DeviceNumber].Data1 := 0;
			AirInFan_CS1_RawData[DeviceNumber].Data2 := 0;
			AirInFan_CS1_RawData[DeviceNumber].Data3 := 0;
			AirInFan_CS1_RawData[DeviceNumber].Data4 := 0;
			AirInFan_CS1_RawData[DeviceNumber].Data5 := 0;
			AirInFan_CS1_RawData[DeviceNumber].Data6 := 0;
			AirInFan_CS1_RawData[DeviceNumber].Data7 := 0;

			AirInFan_CS2_RawData[DeviceNumber].Data0 := 0;
			AirInFan_CS2_RawData[DeviceNumber].Data1 := 0;
			AirInFan_CS2_RawData[DeviceNumber].Data2 := 0;
			AirInFan_CS2_RawData[DeviceNumber].Data3 := 0;
			AirInFan_CS2_RawData[DeviceNumber].Data4 := 0;
			AirInFan_CS2_RawData[DeviceNumber].Data5 := 0;
			AirInFan_CS2_RawData[DeviceNumber].Data6 := 0;
			AirInFan_CS2_RawData[DeviceNumber].Data7 := 0;
		END_IF;
	END_FOR;
	
	// CAN status to VISU
	FOR DeviceNumber := 0 TO 3 DO
		MM2VIS_ThisPlant.bDumpRadiatorCAN[DeviceNumber] := TON_10sTick_DumpRadiator[DeviceNumber].Q;
		MM2VIS_ThisPlant.bAirInFanCAN[DeviceNumber] := TON_10sTick_AirInFan[DeviceNumber].Q;
	END_FOR;
	
	// CAN Warning messages
	MM2VIS_ThisPlant.bDumpRadiator_CANWarningMsg := 	MM2VIS_ThisPlant.bDumpRadiatorCAN[0] OR MM2VIS_ThisPlant.bDumpRadiatorCAN[1] OR
	MM2VIS_ThisPlant.bDumpRadiatorCAN[2] OR MM2VIS_ThisPlant.bDumpRadiatorCAN[3];									

	MM2VIS_ThisPlant.bAirInFan_CANWarningMsg := 	MM2VIS_ThisPlant.bAirInFanCAN[0] OR MM2VIS_ThisPlant.bAirInFanCAN[1] OR
	MM2VIS_ThisPlant.bAirInFanCAN[2] OR MM2VIS_ThisPlant.bAirInFanCAN[3];

END_PROGRAM


