(********************************************************************************************************************************************
SCR_MBSlave			 IN/OUT data register Modbus

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V04.04.00.00	02.08.2016	Pfanzagl		new
V04.04.01.00	02.06.2017	Denk			Adapted FOR SCR Modbus RTU Master
V04.05.00.00	28.07.2017	Tinello			Cleanup and connect of SCR variables
V04.09.00.00	27.11.2019	Tinello			Workaround if "urea/air injection valve - urea opened" - feedback is not available
V04.11.00.00	11.01.2022	Tinello			Bugfix: avoid negative urea flow rate signal
V04.13.00.00	21.11.2023	Tinello			Bugfix: Good quality only if para exist

*********************************************************************************************************************************************)
PROGRAM _CYCLIC

	(* Watchdog / generate ALIVE signal *)
	xTON_AliveBit_1(IN := NOT xTON_AliveBit_2.Q, PT := T#1s);
	xTON_AliveBit_2(IN :=     xTON_AliveBit_1.Q, PT := T#1s);


	(* ------------------------------------------------------------------------------------------------------------------------------------	*)
	(* ##################################################    OutData Register   ###########################################################	*)
	(* ------------------------------------------------------------------------------------------------------------------------------------	*)

	(* Register 1 *)
	OUT_EM.iModbus_SCR[1].0		:= OUT_EM.tSCR_ComprAirValve_Dem.Do;												(* air supply on *)
	OUT_EM.iModbus_SCR[1].1 	:= xTON_AliveBit_1.Q;																(* Alive *)
	OUT_EM.iModbus_SCR[1].2		:= 	   OUT_EM.tSCR_InjectValve_Urea_Dem.Do;											(* 3/2 - inject *)
	OUT_EM.iModbus_SCR[1].3		:= NOT OUT_EM.tSCR_InjectValve_Urea_Dem.Do;											(* 3/2 - purge *)
	OUT_EM.iModbus_SCR[1].4		:= bRel_Dosing OR (OUT_EM.tSCR_InjectValve_Urea_Dem.Do AND VIS2MM.bSCR_Man);		(* Injection enable	*)
	OUT_EM.iModbus_SCR[1].5		:= FALSE;																			(* Spare1_05 *)
	OUT_EM.iModbus_SCR[1].6		:= FALSE;																			(* Spare1_06 *)
	OUT_EM.iModbus_SCR[1].7		:= FALSE;																			(* Spare1_07 *)
	OUT_EM.iModbus_SCR[1].8		:= FALSE;																			(* Spare1_08 *)
	OUT_EM.iModbus_SCR[1].9		:= FALSE;																			(* Spare1_09 *)
	OUT_EM.iModbus_SCR[1].10	:= FALSE;																			(* Spare1_10 *)
	OUT_EM.iModbus_SCR[1].11	:= FALSE;																			(* Spare1_11 *)
	OUT_EM.iModbus_SCR[1].12	:= FALSE;																			(* Spare1_12 *)
	OUT_EM.iModbus_SCR[1].13	:= FALSE;																			(* Spare1_13 *)
	OUT_EM.iModbus_SCR[1].14	:= FALSE;																			(* Spare1_14 *)
	OUT_EM.iModbus_SCR[1].15	:= FALSE;																			(* Spare1_15 *)

	(* Register 2 - 10 *)
	OUT_EM.iModbus_SCR[2]		:= 0;    																			(* Spare_2 *)
	OUT_EM.iModbus_SCR[3]		:= REAL_TO_UINT(LIMIT(0, VIS2MM.rFlow_SCR_UreaDosingUnit_spMan 	* 100, 				(* Setpoint *)
														   Para.rFlow_SCR_UreaDosingUnit_Hi 	* 100 ));
	OUT_EM.iModbus_SCR[4]		:= REAL_TO_UINT(  		   Para.rFlow_SCR_UreaDosingUnit_Hi 	* 100);				(* Max. Flowrate *)
	OUT_EM.iModbus_SCR[5]		:= REAL_TO_UINT(Para.rPc_SCR_UreaSolution * 1000);									(* Urea water solultion *)
	OUT_EM.iModbus_SCR[6]		:= 0;    																			(* Spare_6 *)
	OUT_EM.iModbus_SCR[7]		:= 0;    																			(* Spare_7 *)
	OUT_EM.iModbus_SCR[8]		:= 0;    																			(* Spare_8 *)
	OUT_EM.iModbus_SCR[9]		:= 0;    																			(* Spare_9 *)
	OUT_EM.iModbus_SCR[10]		:= 0;   																			(* Spare_10 *)





	(* ------------------------------------------------------------------------------------------------------------------------------------	*)
	(* ##################################################    InData Register   ############################################################	*)
	(* ------------------------------------------------------------------------------------------------------------------------------------	*)
	MM2VIS.bSCR_SDB_Err[0] 			:= NOT IN_EM.iModbus_SCR_UINT[65].0;					(* On *)

		(* Check ALIVE signal *)
		xTON_AliveCheck_0(IN		:= NOT IN_EM.iModbus_SCR_UINT[65].1, PT:= T#5s);		(* Alive *)
		xTON_AliveCheck_1(IN		:= 	   IN_EM.iModbus_SCR_UINT[65].1, PT:= T#5s);

		bErr_SCR_BUS 				:= (xTON_AliveCheck_0.Q OR xTON_AliveCheck_1.Q) AND Para.bSCR_BUS_Exist;

	tInternSCR_InjectValve_Urea.Di 	:= 	   IN_EM.iModbus_SCR_UINT[65].2;					(* 3/2 - Position injection *)
	tInternSCR_InjectValve_Air.Di	:= 	   IN_EM.iModbus_SCR_UINT[65].3;					(* 3/2 - Position purging *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].4;					(* Door open *)
	OUT_EM.bSCR_SDB_EmStop 			:= NOT IN_EM.iModbus_SCR_UINT[65].5 AND		 			(* Emergency stop switch *)
										   Para.bSCR_BUS_Exist			AND
									   NOT (xTON_AliveCheck_0.Q OR xTON_AliveCheck_1.Q);
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].6;					(* Spare1_6 *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].7;					(* Spare1_7 *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].8;					(* Spare1_8 *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].9;					(* Spare1_9 *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].10;					(* Spare1_10 *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].11;					(* Spare1_11 *)
	bConnectYourVariableHere 		:=	   IN_EM.iModbus_SCR_UINT[65].12;					(* Spare1_12 *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].13;					(* Spare1_13 *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].14;					(* Spare1_14 *)
	bConnectYourVariableHere 		:= 	   IN_EM.iModbus_SCR_UINT[65].15;					(* Spare1_15 *)


	(*-------------------------------------------------------------------------------------------------------------------------------------	*)
	(* Register 66 *)
	iSCR_SDB_Status 				:= INT_TO_USINT(IN_EM.iModbus_SCR_UINT[66] / 256);		(* Status *)
	iConnectYourVariableHere1 		:= INT_TO_USINT(IN_EM.iModbus_SCR_UINT[66] MOD 256);	(* Spare66_1 *)


	(*-------------------------------------------------------------------------------------------------------------------------------------	*)
	(* Register 67 *)
	MM2VIS.bSCR_SDB_Err[1] 		:= IN_EM.iModbus_SCR_UINT[67].0;		(* Alarm 1:  Communication error to ECI *)
	MM2VIS.bSCR_SDB_Err[2] 		:= IN_EM.iModbus_SCR_UINT[67].1;		(* Alarm 2:  Emergency Stop active Smart Dosing Box *)
	MM2VIS.bSCR_SDB_Err[3] 		:= IN_EM.iModbus_SCR_UINT[67].2;		(* Alarm 3:  Hardware fault RS485 interface not connected *)
	MM2VIS.bSCR_SDB_Err[4] 		:= IN_EM.iModbus_SCR_UINT[67].3;		(* Alarm 4:  Hardware fault Analog input card not connected *)
	MM2VIS.bSCR_SDB_Err[5] 		:= IN_EM.iModbus_SCR_UINT[67].4;		(* Alarm 5:  Spare *)
	MM2VIS.bSCR_SDB_Err[6] 		:= IN_EM.iModbus_SCR_UINT[67].5;		(* Alarm 6:  DO Injection drive ON, short circuit or feedback voltage *)
	MM2VIS.bSCR_SDB_Err[7] 		:= IN_EM.iModbus_SCR_UINT[67].6;		(* Alarm 7:  DO air valve, short circuit or feedback voltage *)
	MM2VIS.bSCR_SDB_Err[8] 		:= IN_EM.iModbus_SCR_UINT[67].7;		(* Alarm 8:  DO Injection drive direction short circuit or feedb. volt.*)
	MM2VIS.bSCR_SDB_Err[9] 		:= IN_EM.iModbus_SCR_UINT[67].8;		(* Alarm 9:  DO Tact valve short circuit or feedback voltage *)
	MM2VIS.bSCR_SDB_Err[10] 	:= IN_EM.iModbus_SCR_UINT[67].9;		(* Alarm 10: Spare *)
	MM2VIS.bSCR_SDB_Err[11] 	:= IN_EM.iModbus_SCR_UINT[67].10;		(* Alarm 11: Analog Input 1: short circuit or out of range high *)
	MM2VIS.bSCR_SDB_Err[12] 	:= IN_EM.iModbus_SCR_UINT[67].11;		(* Alarm 12: Analog Input 1: cable break or out of range low *)
	MM2VIS.bSCR_SDB_Err[13] 	:= IN_EM.iModbus_SCR_UINT[67].12;		(* Alarm 13: Analog Input 2: short circuit or out of range high *)
	MM2VIS.bSCR_SDB_Err[14] 	:= IN_EM.iModbus_SCR_UINT[67].13;		(* Alarm 14: Analog Input 2: cable break or out of range low *)
	MM2VIS.bSCR_SDB_Err[15] 	:= IN_EM.iModbus_SCR_UINT[67].14;		(* Alarm 15: Analog Input 3: short circuit or out of range high *)
	MM2VIS.bSCR_SDB_Err[16] 	:= IN_EM.iModbus_SCR_UINT[67].15;		(* Alarm 16: Analog Input 3: cable break or out of range low *)


	(*-------------------------------------------------------------------------------------------------------------------------------------	*)
	(* Register 68 *)
	MM2VIS.bSCR_SDB_Err[17] 	:= IN_EM.iModbus_SCR_UINT[68].0;		(* Alarm 17: Spare *)
	MM2VIS.bSCR_SDB_Err[18] 	:= IN_EM.iModbus_SCR_UINT[68].1;		(* Alarm 18: Spare *)
	MM2VIS.bSCR_SDB_Err[19] 	:= IN_EM.iModbus_SCR_UINT[68].2;		(* Alarm 19: Spare *)
	MM2VIS.bSCR_SDB_Err[20] 	:= IN_EM.iModbus_SCR_UINT[68].3;		(* Alarm 20: Spare *)
	MM2VIS.bSCR_SDB_Err[21] 	:= IN_EM.iModbus_SCR_UINT[68].4;		(* Alarm 21: Spare *)
	MM2VIS.bSCR_SDB_Err[22] 	:= IN_EM.iModbus_SCR_UINT[68].5;		(* Alarm 22: Spare *)
	MM2VIS.bSCR_SDB_Err[23] 	:= IN_EM.iModbus_SCR_UINT[68].6;		(* Alarm 23: Spare *)
	MM2VIS.bSCR_SDB_Err[24] 	:= IN_EM.iModbus_SCR_UINT[68].7;		(* Alarm 24: Spare *)
	MM2VIS.bSCR_SDB_Err[25] 	:= IN_EM.iModbus_SCR_UINT[68].8;		(* Alarm 25: Internal CPU fault, memory fault, temperature fault *)
	MM2VIS.bSCR_SDB_Err[26] 	:= IN_EM.iModbus_SCR_UINT[68].9;		(* Warning 26: Spare *)
	MM2VIS.bSCR_SDB_Err[27] 	:= IN_EM.iModbus_SCR_UINT[68].10;		(* Warning 27: Spare *)
	MM2VIS.bSCR_SDB_Err[28] 	:= IN_EM.iModbus_SCR_UINT[68].11;		(* Warning 28: Reactant supply pressure to low *)
	MM2VIS.bSCR_SDB_Err[29] 	:= IN_EM.iModbus_SCR_UINT[68].12;		(* Warning 29: Reactant supply pressure to high *)
	MM2VIS.bSCR_SDB_Err[30] 	:= IN_EM.iModbus_SCR_UINT[68].13;		(* Warning 30: Spare *)
	MM2VIS.bSCR_SDB_Err[31] 	:= IN_EM.iModbus_SCR_UINT[68].14;		(* Warning 31: Actual flow dosing valve not ok *)
	MM2VIS.bSCR_SDB_Err[32] 	:= IN_EM.iModbus_SCR_UINT[68].15;		(* Warning 32: Actual position Injection valve "blow out" not valid *)


	(*-------------------------------------------------------------------------------------------------------------------------------------	*)
	(* Register 69 *)
	MM2VIS.bSCR_SDB_Err[33] 	:= IN_EM.iModbus_SCR_UINT[69].0;		(* Warning 33: Actual position Inection valve "Inject" not valid *)
	MM2VIS.bSCR_SDB_Err[34] 	:= IN_EM.iModbus_SCR_UINT[69].1;		(* Warning 34: Injection air pressure too low, cooling nozzel not ok *)
	MM2VIS.bSCR_SDB_Err[35] 	:= IN_EM.iModbus_SCR_UINT[69].2;		(* Warning 35: Injection air pressure too low for dosing *)
	MM2VIS.bSCR_SDB_Err[36] 	:= IN_EM.iModbus_SCR_UINT[69].3;		(* Warning 36: Injection air pressure too high *)
	MM2VIS.bSCR_SDB_Err[37] 	:= IN_EM.iModbus_SCR_UINT[69].4;		(* Warning 37: Spare *)
	MM2VIS.bSCR_SDB_Err[38] 	:= IN_EM.iModbus_SCR_UINT[69].5;		(* Warning 38: Spare *)
	MM2VIS.bSCR_SDB_Err[39] 	:= IN_EM.iModbus_SCR_UINT[69].6;		(* Warning 39: Spare *)
	MM2VIS.bSCR_SDB_Err[40] 	:= IN_EM.iModbus_SCR_UINT[69].7;		(* Warning 40: Spare *)
	MM2VIS.bSCR_SDB_Err[41] 	:= IN_EM.iModbus_SCR_UINT[69].8;		(* Warning 41: Spare *)
	MM2VIS.bSCR_SDB_Err[42] 	:= IN_EM.iModbus_SCR_UINT[69].9;		(* Warning 42: Spare *)
	MM2VIS.bSCR_SDB_Err[43] 	:= IN_EM.iModbus_SCR_UINT[69].10;		(* Warning 43: Spare *)
	MM2VIS.bSCR_SDB_Err[44] 	:= IN_EM.iModbus_SCR_UINT[69].11;		(* Warning 44: Spare *)
	MM2VIS.bSCR_SDB_Err[45] 	:= IN_EM.iModbus_SCR_UINT[69].12;		(* Warning 45: System not entirely purged or power loss dosing *)
	MM2VIS.bSCR_SDB_Err[46] 	:= IN_EM.iModbus_SCR_UINT[69].13;		(* Warning 46: Spare *)
	MM2VIS.bSCR_SDB_Err[47] 	:= IN_EM.iModbus_SCR_UINT[69].14;		(* Warning 47: Spare *)
	MM2VIS.bSCR_SDB_Err[48] 	:= IN_EM.iModbus_SCR_UINT[69].15;		(* Warning 48: Spare *)


	(*-------------------------------------------------------------------------------------------------------------------------------------	*)
	(* Register 70 - 84 *)
	iConnectYourVariableHere  				:= IN_EM.iModbus_SCR_UINT[70];						(* Spare70 *)

	tInternFlow_SCR_UreaDosingOut.Ai		:= UINT_TO_REAL(IN_EM.iModbus_SCR_UINT[71]) / 100;	(* Reactant - Flowrate *)
	tInternFlow_SCR_UreaDosingOut.Unfilt	:= UINT_TO_REAL(IN_EM.iModbus_SCR_UINT[71]) / 100;
	tInternFlow_SCR_UreaDosingOut.GoodQual	:= Para.bFlow_SCR_UreaDosingOut_Exist;

	iConnectYourVariableHere	  			:= IN_EM.iModbus_SCR_UINT[72];						(* Reactant - Max. Flowrate *)

	tInternPr_SCR_UreaDosingIn.Ai 			:= INT_TO_REAL(IN_EM.iModbus_SCR_INT[73]) / 1000;	(* Reactant - Feeding pressure *)
	tInternPr_SCR_UreaDosingIn.Unfilt 		:= INT_TO_REAL(IN_EM.iModbus_SCR_INT[73]) / 1000;
	tInternPr_SCR_UreaDosingIn.GoodQual		:= NOT MM2VIS.bSCR_SDB_Err[11] AND
											   NOT MM2VIS.bSCR_SDB_Err[12];
	
	tInternPr_SCR_UreaDosingOut.Ai 			:= INT_TO_REAL(IN_EM.iModbus_SCR_INT[74]) / 1000;	(* Reactant - Discharge pressure *)
	tInternPr_SCR_UreaDosingOut.Unfilt 		:= INT_TO_REAL(IN_EM.iModbus_SCR_INT[74]) / 1000;
	tInternPr_SCR_UreaDosingOut.GoodQual	:= NOT MM2VIS.bSCR_SDB_Err[13] AND
											   NOT MM2VIS.bSCR_SDB_Err[14];

	tInternPr_SCR_ComprAirSupply.Ai 		:= INT_TO_REAL(IN_EM.iModbus_SCR_INT[75]) / 1000;	(* Air - Pressure *)	
	tInternPr_SCR_ComprAirSupply.Unfilt		:= INT_TO_REAL(IN_EM.iModbus_SCR_INT[75]) / 1000;
	tInternPr_SCR_ComprAirSupply.GoodQual	:= NOT MM2VIS.bSCR_SDB_Err[15] AND
										  	   NOT MM2VIS.bSCR_SDB_Err[16];

	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[76];						(* Spare12 *)
	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[77];						(* Spare13 *)
	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[78];						(* Spare14 *)
	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[79];						(* Spare15 *)
	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[80];						(* Spare16 *)
	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[81];						(* Spare17 *)
	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[82];						(* Spare18 *)
	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[83];						(* Spare19 *)
	iConnectYourVariableHere 				:= IN_EM.iModbus_SCR_UINT[84];						(* Spare20 *)



	(* ------------------------------------------------------------------------------------------------------------------------------------	*)
	(* ################################################   Inputs via Hardware   ###########################################################	*)
	(* ------------------------------------------------------------------------------------------------------------------------------------	*)
	IF NOT Para.bSCR_BUS_Exist THEN
		tInternSCR_InjectValve_Air			:= IN_EM.tSCR_InjectValve_Air;
		tInternFlow_SCR_UreaDosingOut		:= IN_EM.tFlow_SCR_UreaDosingOut;
		tInternPr_SCR_UreaDosingIn			:= IN_EM.tPr_SCR_UreaDosingIn;
		tInternPr_SCR_UreaDosingOut			:= IN_EM.tPr_SCR_UreaDosingOut;
		tInternPr_SCR_ComprAirSupply		:= IN_EM.tPr_SCR_ComprAirSupply;


		IF NOT IN_EM.tSCR_InjectValve_Urea.GoodQual THEN
			IF IN_EM.tSCR_InjectValve_Air.GoodQual 
			THEN
				tInternSCR_InjectValve_Urea.Di 			:= NOT IN_EM.tSCR_InjectValve_Air.Di;
				tInternSCR_InjectValve_Urea.GoodQual	:=	   IN_EM.tSCR_InjectValve_Air.GoodQual;
			ELSE
				tInternSCR_InjectValve_Urea.Di 			:= FALSE;
				tInternSCR_InjectValve_Urea.GoodQual	:= FALSE;
			END_IF
		ELSE
			tInternSCR_InjectValve_Urea					:= IN_EM.tSCR_InjectValve_Urea;
		END_IF
	END_IF


	(* To avoid negative signal *)
	tInternFlow_SCR_UreaDosingOut.Ai		:= MAX(tInternFlow_SCR_UreaDosingOut.Ai, 	 0.001);
	tInternFlow_SCR_UreaDosingOut.Unfilt	:= MAX(tInternFlow_SCR_UreaDosingOut.Unfilt, 0.001);

END_PROGRAM