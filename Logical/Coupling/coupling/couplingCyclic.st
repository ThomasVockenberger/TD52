(*******************************************************************************
Coupling:    coupling task for communication to external PLS

This code is confidential and proprietary to INNIO.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V03.99.00	17.07.2012	froehlichw	new
V03.99.01	03.01.2014  Denk  		Profibus slave adress adjustment with parameter
V04.00.02	22.07.2014	Denk		Profibus Big/Little endian changeable
V04.01.01	30.07.2015	Denk		MODBUS_TCP_MAX_SEND constant changed to 192
V04.03.00	09.12.2015	Denk		I/0 module adress handling
V04.04.00	04.07.2016	Denk		Coupling2. Bugfix: Para.iComm1_SlaveID changed to Para.iComm2_SlaveID. Bugfix: Stopbit logic 
			07.07.2016	Denk		IP adress setting for GE and B&R IPC via Parameter
			26.10.2016	Denk		Profibus, Profinet, Modbus TCP can be active with Link 2 
									coupling task in 10ms
									Bugfix, Modbus TCP PLC in Service Mode when changing type OF coupling
			25.11.2016	Denk		Clean-up, DW41-54 deleted. Implemented twice.
V04.05.00	26.05.2017	Denk		InData1SIM[], OutDataSIM[] for WinMOD bus test
			27.11.2017	Denk		Avoid OutData toggling in watch for Profibus, Profinet
V04.07.00	22.01.2019	Denk		Bus diagnosis and test on HMI
			26.03.2019	Denk		local variables bPB_MSB_Out and bPB_MSB_In replaced with Para.bComm_MSB_LSB
V04.09.00	27.01.2020	Denk		Bugfix, Profibus DP old: BIG/LITTLE endian OutData-Array swapping
V04.10.00	27.01.2021  Denk		Bus diagnosis arrays enlarged to 600 (send) and 32 (receive). Specification: 2020_42_CouplingBustester
			10.03.2021	Denk		Bugfix, Bus diagnosis screen, integer value input not synchronized with bit register values (GitHub issue #62)
V04.11.00   13.02.2022  Denk		Bugfix, bBC_Test_Recv_Reg_Forced datatyp change to MAX_IN_DATA_ARRAY
V04.12.00	07.02.2023	Denk		Improvement, Add 2nd Modbus TCP communication
V04.13.00	14.12.2023	Denk		Bugfix, Modbus InData register overwritten with Aggreko extended OutData
			31.01.2024	Denk		Second customer bus coupling Modbus TCP  

Instructions for use:
--------------------


Outstandings:
------------


(*******************************************************************************)

PROGRAM _CYCLIC
	
	(*---------------------------------------------------------------------------
	/* I/0 module adress handling
	/*-------------------------------------------------------------------------*)	
	(*-------------------------------
	/* Modbus RTU
	/*-----------------------------*)
	szInterface01:= IN_CP.szMBRTU_DeviceName;

	(*-------------------------------
	/* Modbus TCP
	/*-----------------------------*)
	
	(* Select Hardware for ModbusTCP Couplings *)
	IF (Para.iIdx_Comm1_type = comMODBUS_TCP AND Para.iIdx_Comm2_type = comMODBUS_TCP) THEN
		IF (IN_CP.szMBTCP1_DeviceName <> '' AND IN_CP.szMBTCP2_DeviceName <> '') THEN
			szComm_Device_TCP := IN_CP.szMBTCP1_DeviceName; // SS1 for CP1
			szComm_Device2_TCP := IN_CP.szMBTCP2_DeviceName; // SS2 for CP2
		ELSE
			szComm_Device_TCP := 'Modbus Error';
			szComm_Device2_TCP := 'Modbus Error';
		END_IF
	ELSIF (Para.iIdx_Comm1_type = comMODBUS_TCP AND Para.iIdx_Comm2_type <> comMODBUS_TCP) THEN
		IF (IN_CP.szMBTCP1_DeviceName <> '') THEN
			szComm_Device_TCP := IN_CP.szMBTCP1_DeviceName; // SS1 for CP1
		ELSIF (IN_CP.szMBTCP2_DeviceName <> '') THEN
			szComm_Device_TCP := IN_CP.szMBTCP2_DeviceName; // SS2 for CP1
		ELSIF (IN_CP.szMBTCP3_DeviceName <> '') THEN
			szComm_Device_TCP := IN_CP.szMBTCP3_DeviceName; // SS3 for CP1
		ELSIF (IN_CP.szMBTCP_DeviceName <> '') THEN
			szComm_Device_TCP := IN_CP.szMBTCP_DeviceName; // ST22 (external hardware HB8815) for CP1
		ELSE
			szComm_Device_TCP := 'no modbus hardware';
		END_IF
	ELSIF (Para.iIdx_Comm1_type <> comMODBUS_TCP AND Para.iIdx_Comm2_type = comMODBUS_TCP) THEN
		IF (IN_CP.szMBTCP1_DeviceName <> '') THEN
			szComm_Device2_TCP := IN_CP.szMBTCP1_DeviceName; // SS1 for CP1
		ELSIF (IN_CP.szMBTCP2_DeviceName <> '') THEN
			szComm_Device2_TCP := IN_CP.szMBTCP2_DeviceName; // SS2 for CP1
		ELSIF (IN_CP.szMBTCP3_DeviceName <> '') THEN
			szComm_Device2_TCP := IN_CP.szMBTCP3_DeviceName; // SS3 for CP1
		ELSIF (IN_CP.szMBTCP_DeviceName <> '') THEN
			szComm_Device2_TCP := IN_CP.szMBTCP_DeviceName; // ST22 (external hardware HB8815) for CP1
		ELSE
			szComm_Device2_TCP := 'no modbus hardware';
		END_IF
	END_IF
	
	IF (IN_CP.szMBTCP3_DeviceName <> '') THEN	
		szComm_Device3_TCP := IN_CP.szMBTCP3_DeviceName; // SS3 for Modbus Master
	ELSE
		szComm_Device3_TCP := 'no modbus hardware';
	END_IF;
	
	(*-------------------------------
	/* Profibus DP
	/*-----------------------------*)
	szInterface01_Comm1:= IN_CP.szPB1_DeviceName;
	szInterface02_Comm1:= IN_CP.szPB2_DeviceName;

	(*-------------------------------
	/* Profinet
	/*-----------------------------*)
	szInterface01_Comm1_PN:= IN_CP.szPN_DeviceName;

	(*---------------------------------------------------------------------------
	/* END: I/0 module adress handling
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* Bus diagnosis on HMI
	/*-------------------------------------------------------------------------*)
		(*-------------------------------
		/* Coupling 1
		/*-----------------------------*)
		IF Para.iIdx_Comm1_type <> iIdx_Comm1_type_old THEN
			iIdx_Comm1_type_old := Para.iIdx_Comm1_type;
			FOR k:=0 TO 4 DO
				 MM2VIS.sBC_HW_Adr_Comm1[k] := '';
			END_FOR;
		END_IF;

		CASE Para.iIdx_Comm1_type OF
			comNO_LINK: 
					;		
			comMODBUS_RTU:
				MM2VIS.sBC_HW_Adr_Comm1[0] := IN_CP.szMBRTU_DeviceName;
			comMODBUS_TCP:
				MM2VIS.sBC_HW_Adr_Comm1[1] := szComm_Device_TCP;
			comPROFIBUS_DP:
				MM2VIS.sBC_HW_Adr_Comm1[2] := IN_CP.szPB1_DeviceName;
				MM2VIS.sBC_HW_Adr_Comm1[3] := IN_CP.szPB2_DeviceName;
			comPROFIBUS_DPold:
				MM2VIS.sBC_HW_Adr_Comm1[2] := IN_CP.szPB1_DeviceName;
			comPROFINET:
				MM2VIS.sBC_HW_Adr_Comm1[4] := IN_CP.szPN_DeviceName;
		END_CASE;
					
		(*-------------------------------
		/* Coupling 2
		/*-----------------------------*)
		IF Para.iIdx_Comm2_type <> iIdx_Comm2_type_old THEN
			iIdx_Comm2_type_old := Para.iIdx_Comm2_type;
			FOR k:=0 TO 4 DO
				 MM2VIS.sBC_HW_Adr_Comm2[k] := '';
			END_FOR;
		END_IF;

		CASE Para.iIdx_Comm2_type OF
			comNO_LINK: 
					;		
			comMODBUS_RTU:
				MM2VIS.sBC_HW_Adr_Comm2[0] := IN_CP.szMBRTU_DeviceName;
			comMODBUS_TCP:
				MM2VIS.sBC_HW_Adr_Comm2[1] := szComm_Device2_TCP;
			comPROFIBUS_DP:
				MM2VIS.sBC_HW_Adr_Comm2[2] := IN_CP.szPB1_DeviceName;
				MM2VIS.sBC_HW_Adr_Comm2[3] := IN_CP.szPB2_DeviceName;
			comPROFIBUS_DPold:
				MM2VIS.sBC_HW_Adr_Comm2[2] := IN_CP.szPB1_DeviceName;
			comPROFINET:
				MM2VIS.sBC_HW_Adr_Comm2[4] := IN_CP.szPN_DeviceName;
		END_CASE;
	(*---------------------------------------------------------------------------
	/* END: Bus diagnosis on HMI
	/*-------------------------------------------------------------------------*)			

	(*---------------------------------------------------------------------------
	/* Bus test on HMI
	/*-------------------------------------------------------------------------*)
	(* Bus coupling 1 send and receive *)
	(* Bit creation for differentiation dataword/register *)
	IF EDGEPOS(VIS2MM.bBC1_Test_Active) OR (Para.iIdx_Comm1_type <> iIdx_Comm1_type_old) THEN
		VIS2MM.bBC2_Test_Active := FALSE;
		IF (	(Para.iIdx_Comm1_type = comPROFIBUS_DP) 
			OR 	(Para.iIdx_Comm1_type = comPROFINET) 
			OR 	(Para.iIdx_Comm1_type = comPROFIBUS_DPold)) THEN
			bBC_Test_Send_DW := TRUE;
			iBC_Test_Send_DW := 1;
			bBC_Test_Recv_DW := TRUE;
			iBC_Test_Recv_DW := 1;
			VIS2MM.iBC_Test_Send_Start_Reg := 1;
			VIS2MM.iBC_Test_Recv_Start_Reg := 1; 
		ELSE
			bBC_Test_Send_DW := FALSE;
			iBC_Test_Send_DW := 0;
			bBC_Test_Recv_DW := FALSE;
			iBC_Test_Recv_DW := 0;
			VIS2MM.iBC_Test_Send_Start_Reg := 0;
			VIS2MM.iBC_Test_Recv_Start_Reg := 0; 
		END_IF;
	END_IF;
	iIdx_Comm1_type_old := Para.iIdx_Comm1_type;
	
	(* Reset HMI Word/INT variables *)	
	IF EDGEPOS(VIS2MM.bBC1_Test_Active) OR EDGENEG(VIS2MM.bBC_Test_Send_Reg_AllForced) OR EDGENEG(VIS2MM.bBC_Test_Recv_Reg_AllForced) THEN
		FOR i := 0 TO 15 DO
			VIS2MM.iBC_Test_Send_Reg[i] := 0;
			VIS2MM.iBC_Test_Recv_Reg[i] := 0;
		END_FOR;
	END_IF;
	
	(* Bus coupling 2 send and receive *)
	(* Bit creation for differentiation dataword/register *)
	IF EDGEPOS(VIS2MM.bBC2_Test_Active) OR (Para.iIdx_Comm2_type <> iIdx_Comm2_type_old) THEN
		VIS2MM.bBC1_Test_Active := FALSE;
		IF (	(Para.iIdx_Comm2_type = comPROFIBUS_DP) 
			OR 	(Para.iIdx_Comm2_type = comPROFINET) 
			OR 	(Para.iIdx_Comm2_type = comPROFIBUS_DPold)) THEN
			bBC_Test_Send_DW := TRUE;
			iBC_Test_Send_DW := 1;
			bBC_Test_Recv_DW := TRUE;
			iBC_Test_Recv_DW := 1;
			VIS2MM.iBC_Test_Send_Start_Reg := 1;
			VIS2MM.iBC_Test_Recv_Start_Reg := 1;			
		ELSE 
			bBC_Test_Send_DW := FALSE;
			iBC_Test_Send_DW := 0;
			bBC_Test_Recv_DW := FALSE;
			iBC_Test_Recv_DW := 0;
			VIS2MM.iBC_Test_Send_Start_Reg := 0;
			VIS2MM.iBC_Test_Recv_Start_Reg := 0; 
		END_IF;
	END_IF;
	iIdx_Comm2_type_old := Para.iIdx_Comm2_type;
	
	(* Reset HMI Word/INT variables *)	
	IF EDGEPOS(VIS2MM.bBC2_Test_Active) OR EDGENEG(VIS2MM.bBC_Test_Send_Reg_AllForced) OR EDGENEG(VIS2MM.bBC_Test_Recv_Reg_AllForced) THEN
		FOR i := 0 TO 15 DO
			VIS2MM.iBC_Test_Send_Reg[i] := 0;
			VIS2MM.iBC_Test_Recv_Reg[i] := 0;
		END_FOR;
	END_IF;
		
	(* Bus coupling send *)
	(* Dataword or register convention for start register. HMI dialog minimum and maximum limit *) 
	IF bBC_Test_Send_DW = TRUE THEN
		MM2VIS.iBC_Test_Send_Reg_Min := 1;
		MM2VIS.iBC_Test_Send_Reg_Max := MAX_OUT_DATA;
	ELSE
		MM2VIS.iBC_Test_Send_Reg_Min := 0;
		MM2VIS.iBC_Test_Send_Reg_Max := MAX_OUT_DATA - 1;
	END_IF;
						
	(* Reset register/dataword view on HMI when first register is changed *)
	iStartSendReg := VIS2MM.iBC_Test_Send_Start_Reg;
	VIS2MM.iBC_Test_Send_Start_Reg := iStartSendReg;		
	IF iStartSendReg <> iStartSendReg_old THEN     		
		iStartSendReg_old := iStartSendReg;
		memcpy(ADR(VIS2MM.iBC_Test_Send_Reg[0]), ADR(OutDataSW[iStartSendReg - iBC_Test_Send_DW]), 32);	
	END_IF;
			
	(* Bus coupling 1 maximum register to show on HMI screen *) 
	IF VIS2MM.bBC1_Test_Active THEN
		IF (	(Para.iIdx_Comm1_type = comPROFIBUS_DP) 
			OR 	(Para.iIdx_Comm1_type = comPROFINET) 
			OR 	(Para.iIdx_Comm1_type = comPROFIBUS_DPold)) THEN
			MM2VIS.iNumBC_Test_Send_Reg_Max := LIMIT(1, MAX_OUT_DATA - (VIS2MM.iBC_Test_Send_Start_Reg - 1), 16);
		ELSE 
			MM2VIS.iNumBC_Test_Send_Reg_Max := LIMIT(1, (MAX_OUT_DATA - 1) - (VIS2MM.iBC_Test_Send_Start_Reg - 1), 16);
		END_IF;
	END_IF;
					
	(* Bus coupling 2 maximum register to show on HMI screen *)
	IF VIS2MM.bBC2_Test_Active THEN
		IF (	(Para.iIdx_Comm2_type = comPROFIBUS_DP) 
			OR 	(Para.iIdx_Comm2_type = comPROFINET) 
			OR 	(Para.iIdx_Comm2_type = comPROFIBUS_DPold)) THEN
			MM2VIS.iNumBC_Test_Send_Reg_Max := LIMIT(1, MAX_OUT_DATA - (VIS2MM.iBC_Test_Send_Start_Reg - 1), 16);
		ELSE 
			MM2VIS.iNumBC_Test_Send_Reg_Max := LIMIT(1, (MAX_OUT_DATA - 1) - (VIS2MM.iBC_Test_Send_Start_Reg - 1), 16);
		END_IF;
	END_IF;
			
	(* Force time *)
	xTON_BC_Test_Force_Active(IN:= VIS2MM.bBC_Test_Force_Active, PT:= Para.tiBC_Test_Force);
	MM2VIS.tiBC_Test_Force_Remain := Para.tiBC_Test_Force - xTON_BC_Test_Force_Active.ET;
	IF xTON_BC_Test_Force_Active.Q THEN
		VIS2MM.bBC_Test_Force_Active := FALSE;
	END_IF;
			
	(* Register number visibility on HMI *)
	FOR t := 0 TO 15 DO
		MM2VIS.iNumBC_Test_Send_Reg[t] := iStartSendReg + t;
	END_FOR;
				 
	IF VIS2MM.bBC_Test_Force_Active THEN
		(* INTEGER input on HMI bustest screen, write to "OutDataSW" *)	 
		FOR i := 0 TO 15 DO
			IF VIS2MM.iBC_Test_Send_Reg[i] <> iBC_Test_Send_Reg_old[iStartSendReg - iBC_Test_Send_DW + i] AND VIS2MM.bBC_Test_Send_Reg_Forced[i] THEN
				memcpy(ADR(OutDataSW[iStartSendReg - iBC_Test_Send_DW + i]), ADR(VIS2MM.iBC_Test_Send_Reg[i]), 2); 								
				memcpy(ADR(iBC_Test_Send_Reg_old[iStartSendReg - iBC_Test_Send_DW + i]), ADR(VIS2MM.iBC_Test_Send_Reg[i]), 2);	
			END_IF;
		END_FOR;
				
		(* BOOLEAN input on HMI bustest screen, write to "OutDataSW" *)
		FOR m := 0 TO (SIZEOF(VIS2MM.bBC_Test_Send_Reg) - 1) DO
			IF (VIS2MM.bBC_Test_Send_Reg[m] XOR bBC_Test_Send_Reg_old[m]) THEN
				RegOffset_Send := (m / 16);	
				srcAdr:= ADR(VIS2MM.bBC_Test_Send_Reg[RegOffset_Send  * 16]);
				dstAdr:= ADR(OutDataSW);
				idxMin:= iStartSendReg - iBC_Test_Send_DW + RegOffset_Send ;
				idxMax:= iStartSendReg - iBC_Test_Send_DW + RegOffset_Send;
				BusTest_BOOL_TO_INT;
				memcpy(ADR(bBC_Test_Send_Reg_old), ADR(VIS2MM.bBC_Test_Send_Reg), SIZEOF(bBC_Test_Send_Reg_old));
			END_IF;
		END_FOR;
				
		(* Force all *)
		IF EDGEPOS(VIS2MM.bBC_Test_Send_Reg_AllForced) THEN
			bBC_Test_Send_Reg_AllForced := TRUE;
		END_IF;
		IF (bBC_Test_Send_Reg_AllForced) THEN
			FOR r := 0 TO ((SIZEOF(OutDataSW)/2) - 1) DO					
				bBC_Test_Send_Reg_Forced[r] := TRUE;							
			END_FOR;
		END_IF;
	END_IF;
		
	(* Unforce all *)
	IF EDGENEG(VIS2MM.bBC_Test_Send_Reg_AllForced) OR NOT VIS2MM.bBC_Test_Force_Active OR EDGEPOS(VIS2MM.bBC1_Test_Active) OR EDGEPOS(VIS2MM.bBC2_Test_Active) THEN
		VIS2MM.bBC_Test_Send_Reg_AllForced := FALSE;		
		bBC_Test_Send_Reg_AllUnforced := TRUE;
	END_IF;
	IF bBC_Test_Send_Reg_AllUnforced OR NOT VIS2MM.bBC_Test_Force_Active OR EDGEPOS(bBC_Test_Send_DW) OR EDGENEG(bBC_Test_Send_DW) THEN
		FOR p := 0 TO ((SIZEOF(OutDataSW)/2)-1) DO
			bBC_Test_Send_Reg_Forced[p] := FALSE;								
		END_FOR;
	END_IF;
		
	(* Force checkbox. Handle Start register change, Force all, Unforce all *)
	IF (VIS2MM.iBC_Test_Send_Start_Reg <> iBC_Test_Send_Start_Reg_old) OR bBC_Test_Send_Reg_AllForced OR bBC_Test_Send_Reg_AllUnforced THEN
		FOR b := 0 TO 15 DO
			VIS2MM.bBC_Test_Send_Reg_Forced[b] := bBC_Test_Send_Reg_Forced[b + iStartSendReg - iBC_Test_Send_DW];
		END_FOR;
		iBC_Test_Send_Start_Reg_old := VIS2MM.iBC_Test_Send_Start_Reg;
	END_IF;
	bBC_Test_Send_Reg_AllUnforced 	:= FALSE;
	bBC_Test_Send_Reg_AllForced 	:= FALSE;
	
	(* Force checkbox. Store state in local variable *)		
	FOR n := 0 TO 15 DO	
		IF VIS2MM.bBC_Test_Send_Reg_Forced[n] <> bBC_Test_Send_Reg_Forced_old[n] THEN
			IF (VIS2MM.bBC_Test_Send_Reg_Forced[n] = TRUE) AND VIS2MM.bBC_Test_Force_Active THEN
				bBC_Test_Send_Reg_Forced[n + iStartSendReg - iBC_Test_Send_DW] := TRUE;
			END_IF;
			IF (VIS2MM.bBC_Test_Send_Reg_Forced[n] = FALSE) THEN
				bBC_Test_Send_Reg_Forced[n + iStartSendReg - iBC_Test_Send_DW] := FALSE;	
			END_IF;
			bBC_Test_Send_Reg_Forced_old[n] := VIS2MM.bBC_Test_Send_Reg_Forced[n];
		END_IF;
	END_FOR;
		
	(* Write unforced values to modul global OutDataSW array *)
	FOR x := 0 TO ((SIZEOF(OutDataSW)/2) - 1) DO
		IF (bBC_Test_Send_Reg_Forced[x] = FALSE) THEN
			OutDataSW[x] := OutData[x];	
		END_IF;
	END_FOR;
	
	(* Write forced values to modul global OutData array, take HMI Input when forced *)
	FOR x := 0 TO ((SIZEOF(OutData)/2) - 1) DO
		IF (bBC_Test_Send_Reg_Forced[x] = TRUE) THEN
			OutData[x] := OutDataSW[x];	
		END_IF;
	END_FOR;	
	
	(* Forced register, write latest value to HMI Bool buttons *)
	FOR v := 0 TO 15 DO	
		IF VIS2MM.bBC_Test_Send_Reg_Forced[v] THEN
			dstAdr:= ADR(VIS2MM.bBC_Test_Send_Reg);					
			srcAdr:= ADR(OutData[0]);
			idxMin:= (iStartSendReg - iBC_Test_Send_DW);
			idxMax:= (iStartSendReg - iBC_Test_Send_DW) + 16;
			BusTest_INT_TO_BOOL;
		END_IF;
	END_FOR;
	
	(* Forced register, write latest value to HMI Word/Integer field *)
	memcpy(ADR(VIS2MM.iBC_Test_Send_Reg[0]), ADR(OutData[iStartSendReg - iBC_Test_Send_DW]), 32);
	
	(* Unforced register, write latest value to HMI Bool buttons *)
	FOR w := 0 TO 15 DO	
		IF NOT VIS2MM.bBC_Test_Send_Reg_Forced[w] THEN
			dstAdr:= ADR(VIS2MM.bBC_Test_Send_Reg);					
			srcAdr:= ADR(OutData[0]);
			idxMin:= (iStartSendReg - iBC_Test_Send_DW);
			idxMax:= (iStartSendReg - iBC_Test_Send_DW) + 16;
			BusTest_INT_TO_BOOL;
		END_IF;
	END_FOR;
	
	(* Unforced register, write latest value to HMI Word/Integer field *)
	memcpy(ADR(VIS2MM.iBC_Test_Send_Reg[0]), ADR(OutData[iStartSendReg - iBC_Test_Send_DW]), 32);			
		
	(*---------------------------------------------------------------------------
	/* END: Bus test on HMI
	/*-------------------------------------------------------------------------*)
	
	(*---------------------------------------------------------------------------
	/* data handling - general copying of send data
	/*-------------------------------------------------------------------------*)
	IF ucTeilerLauf > ucTeiler THEN
		(*-------------------------------
		/* modbus - RTU
		/*-----------------------------*)
		IF (Para.iIdx_Comm1_type = comMODBUS_RTU) THEN
			memcpy(ADR(MBR_4_1[0]), ADR(OutData[0]), MODBUS_RTU_MAX_SEND*2);
		END_IF;
		IF (Para.iIdx_Comm2_type = comMODBUS_RTU) THEN
			memcpy(ADR(MBR_4_2[0]), ADR(OutData[0]), MODBUS_RTU_MAX_SEND*2);
		END_IF;

		(*-------------------------------
		/* modbus - TCP
		/*-----------------------------*)
		IF (Para.iIdx_Comm1_type = comMODBUS_TCP) THEN
			memcpy(ADR(MBT_4_1[0]), ADR(OutData[0]), MODBUS_TCP_MAX_SEND*2);
			memcpy(ADR(MBT_4_1[208]), ADR(OutData[192]), 408*2);	(* Aggreko serial solution, with extended OutData *)
		END_IF;
		IF (Para.iIdx_Comm2_type = comMODBUS_TCP) THEN
			memcpy(ADR(MBT_4_2[0]), ADR(OutData[0]), MODBUS_TCP_MAX_SEND*2);
			memcpy(ADR(MBT_4_2[208]), ADR(OutData[192]), 408*2);	(* Aggreko serial solution, with extended OutData *)
		END_IF;

		(*-------------------------------
		/* profibus DP
		/*-----------------------------*)
		IF ((Para.iIdx_Comm1_type = comPROFIBUS_DP) OR (Para.iIdx_Comm2_type = comPROFIBUS_DP)) THEN
			;  (* nothing to copy, use OutData *)
		END_IF;

		(*-------------------------------
		/* profibus DP old
		/*-----------------------------*)
		IF ((Para.iIdx_Comm1_type = comPROFIBUS_DPold) OR (Para.iIdx_Comm2_type = comPROFIBUS_DPold)) THEN
			(* DW1-16 *)
			FOR idx:= 0 TO 15 DO
				OutData_DPold[idx]:= OutData[idx];
			END_FOR;
			(* DW17-19 *)
			FOR idx:= 16 TO 18 DO
				OutData_DPold[idx]:= OutData[idx+5];
			END_FOR;
			(* DW20-21 *)
			FOR idx:= 19 TO 20 DO
				OutData_DPold[idx]:= OutData[idx+13];
			END_FOR;
			(* DW22-30 *)
			FOR idx:= 21 TO 29 DO
				OutData_DPold[idx]:= OutData[idx+14];
			END_FOR;
			(* DW31 *)
			OutData_DPold[30]:= OutData[30];
			(* DW32 *)
			OutData_DPold[31]:= OutData[31];
			(* DW33-35 *)
			FOR idx:= 32 TO 34 DO
				OutData_DPold[idx]:= OutData[idx+12];
			END_FOR;
			(* DW36 *)
			OutData_DPold[35]:= OutData[47] AND 2#0001_1111_1111_1111;
			(* DW37 *)
			OutData_DPold[36]:= OutData[52];
			(* DW38-39 *)
			FOR idx:= 37 TO 38 DO
				OutData_DPold[idx]:= OutData[idx+21];
			END_FOR;
			(* DW40 *)
			OutData_DPold[39]:= OutData[62];
			(* DW41-54 *)
			FOR idx:= 40 TO 53 DO
				OutData_DPold[idx]:= OutData[idx+25];
			END_FOR;
			(* DW55-83 *)
			FOR idx:= 54 TO 82 DO
				OutData_DPold[idx]:= OutData[idx+26];
			END_FOR;
			(* DW84-112 *)
			FOR idx:= 83 TO 111 DO
				OutData_DPold[idx]:= OutData[idx+29];
			END_FOR;
			(* DW113-120 *)
			FOR idx:= 112 TO 119 DO
				OutData_DPold[idx]:= OutData[idx+72];
			END_FOR;
		END_IF;

		(*-------------------------------
		/* profinet
		/*-----------------------------*)
		IF ((Para.iIdx_Comm1_type = comPROFINET) OR (Para.iIdx_Comm2_type = comPROFINET)) THEN
			;  (* nothing to copy, use OutData *)
		END_IF;
		
		(*-------------------------------
		/* Simulation WinMOD
		/*-----------------------------*)
		IF IN_CP.bSimWinMOD_Active THEN
			memcpy(ADR(OutDataSIM), ADR(OutData), SIZEOF(OutData));
		END_IF;

		(*---------------------------------------------------------------------------
		/* Profibus DB, Profinet: BIG/LITTLE endian OutData-Array swapping
		/*-------------------------------------------------------------------------*)
		IF (	(Para.iIdx_Comm1_type = comPROFIBUS_DP) 
			OR 	(Para.iIdx_Comm2_type = comPROFIBUS_DP)
			OR 	(Para.iIdx_Comm1_type = comPROFINET) 
			OR 	(Para.iIdx_Comm2_type = comPROFINET)) THEN
			IF Para.bComm_MSB_LSB THEN
				memcpy(ADR(OutDataSwap[0]), ADR(OutData[0]), PROFIBUS_MAX_SEND_2SLAVES*2);
				FOR ArrayCntOut := 0 TO (PROFIBUS_MAX_SEND_2SLAVES - 1) BY 1 DO
					OutData[ArrayCntOut] := swapINT(OutDataSwap[ArrayCntOut]);
				END_FOR;
			END_IF;  
		END_IF;
		
		(*---------------------------------------------------------------------------
		/* Profibus DP old: BIG/LITTLE endian OutData-Array swapping
		/*-------------------------------------------------------------------------*)
		IF (	(Para.iIdx_Comm1_type = comPROFIBUS_DPold) 
			OR 	(Para.iIdx_Comm2_type = comPROFIBUS_DPold)) THEN
			IF Para.bComm_MSB_LSB THEN
				memcpy(ADR(OutDataOldSwap[0]), ADR(OutData_DPold[0]), SIZEOF(OutDataOldSwap));
				FOR ArrayCntOut := 0 TO (PROFIBUS_MAX_SEND - 1) BY 1 DO
					OutData_DPold[ArrayCntOut] := swapINT(OutDataOldSwap[ArrayCntOut]);
				END_FOR;
			END_IF;  
		END_IF;
	END_IF;
	
	(*---------------------------------------------------------------------------
	/* END: data handling
	/*-------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------
/* coupling 1
/*----------------------------------------------------------------------------------------*)
	
	(*---------------------------------------------------------------------------
	/* check for changes in the configuration and close interfaces connections
	/*-------------------------------------------------------------------------*)
	IF OUT_CP.tCP2PB.bMyParaSetupOk THEN
		CASE siComm1_type OF
		(*-------------------------------
		/* no link
		/*-----------------------------*)
			comNO_LINK:
				(* select coupling type to initalise *)
				CASE Para.iIdx_Comm1_type OF
					comNO_LINK: ;
					comMODBUS_RTU: bMBinit[0]:= TRUE;      (* init modbus RTU *)
					comMODBUS_TCP: bMBtcpinit[0]:= TRUE;   (* init modbus TCP *)
					comPROFIBUS_DP: ;
					comPROFIBUS_DPold: ;
					comPROFINET: ;
				END_CASE;

		(*-------------------------------
		/* modbus - RTU
		/*-----------------------------*)
			comMODBUS_RTU:
				IF ((ucINIT[0] = 1) OR
					(siComm1_type <> Para.iIdx_Comm1_type) OR
					(siComm1_SlaveID <> Para.iComm1_SlaveID) OR
					(siComm1_Baud <> Para.iComm1_Baud) OR
					(siComm1_Parity <> Para.iComm1_Parity) OR
					(siComm1_Stopbit <> Para.iComm1_Stopbit) OR
					(siComm1_Interface <> Para.iIdx_Comm1_Interface)) THEN

					MBinitOK[0]:= FALSE;

					IF ucINIT[0] <> 1 THEN
						MBSClose_Var[0].enable:= TRUE;
						MBSClose_Var[0].ident:= MBSOpen_Var[0].ident;
						(* call FUB MBSClose *)
						MBSClose_Var[0]();
					END_IF;

					IF MBSClose_Var[0].status = 0 THEN
						(* refreshing the temporary parameters *)
						siComm1_SlaveID:= Para.iComm1_SlaveID;
						siComm1_Baud:= Para.iComm1_Baud;
						siComm1_Parity:= Para.iComm1_Parity;
						siComm1_Stopbit:= Para.iComm1_Stopbit;
						siComm1_Interface:= Para.iIdx_Comm1_Interface;
						ucINIT[0]:= 0;

						(* select coupling type to initalise *)
						CASE Para.iIdx_Comm1_type OF
							comNO_LINK: ;
							comMODBUS_RTU: bMBinit[0]:= TRUE;      (* init modbus RTU *)
							comMODBUS_TCP: bMBtcpinit[0]:= TRUE;   (* init modbus TCP *)
							comPROFIBUS_DP: ;
							comPROFIBUS_DPold: ;
							comPROFINET: ;
						END_CASE;
					END_IF;

				END_IF;

		(*-------------------------------
		/* modbus - TCP
		/*-----------------------------*)
			comMODBUS_TCP:
				IF ((ucINIT[0] = 1) OR	
					((fMBTSOpen_Var.udiIdent <> 0) 
					AND (   (siComm1_type <> Para.iIdx_Comm1_type)
					OR (siComm_SlaveID_TCP <> Para.iComm_SlaveID_TCP) 
					OR (siComm_PortID_TCP <> Para.iComm_PortID_TCP)))) THEN
			  				
					MBtcpInitOK[0]:= FALSE;
				
					(* Close Modbus TCP connection *)
					IF ucINIT[0] <> 1 THEN
						fMBTSClose_Var.bEnable:= TRUE;
						fMBTSClose_Var.udiIdent:= fMBTSOpen_Var.udiIdent ;
						(* call FUB fMBTSClose *)
						fMBTSClose_Var();
					END_IF;
				
					IF (fMBTSClose_Var.uiStatus = 0) OR (fMBTSClose_Var.uiStatus = 65535) THEN
						(* refreshing the temporary parameters *)
						siComm_SlaveID_TCP:= Para.iComm_SlaveID_TCP;
						siComm_PortID_TCP:= Para.iComm_PortID_TCP;
						ucINIT[0]:= 0;

						(* select coupling type to initalise *)
						CASE Para.iIdx_Comm1_type OF
							comNO_LINK: ;
							comMODBUS_RTU: bMBinit[0]:= TRUE;      (* init modbus RTU *)
							comMODBUS_TCP: bMBtcpinit[0]:= TRUE;   (* init modbus TCP *)
							comPROFIBUS_DP: ;
							comPROFIBUS_DPold: ;
							comPROFINET: ;
						END_CASE;
					END_IF;

				END_IF;

		(*-------------------------------
		/* profibus DP
		/*-----------------------------*)
			comPROFIBUS_DP:
				(* select coupling type to initalise *)
				CASE Para.iIdx_Comm1_type OF
					comNO_LINK: ;
					comMODBUS_RTU: bMBinit[0]:= TRUE;      (* init modbus RTU *)
					comMODBUS_TCP: bMBtcpinit[0]:= TRUE;   (* init modbus TCP *)
					comPROFIBUS_DP: ;
					comPROFIBUS_DPold: ;
					comPROFINET: ;
				END_CASE;

		(*-------------------------------
		/* profibus DP old
		/*-----------------------------*)
			comPROFIBUS_DPold:
				(* select coupling type to initalise *)
				CASE Para.iIdx_Comm1_type OF
					comNO_LINK: ;
					comMODBUS_RTU: bMBinit[0]:= TRUE;      (* init modbus RTU *)
					comMODBUS_TCP: bMBtcpinit[0]:= TRUE;   (* init modbus TCP *)
					comPROFIBUS_DP: ;
					comPROFIBUS_DPold: ;
					comPROFINET: ;
				END_CASE;

		(*-------------------------------
		/* profinet
		/*-----------------------------*)
			comPROFINET:
				(* select coupling type to initalise *)
				CASE Para.iIdx_Comm1_type OF
					comNO_LINK: ;
					comMODBUS_RTU: bMBinit[0]:= TRUE;      (* init modbus RTU *)
					comMODBUS_TCP: bMBtcpinit[0]:= TRUE;   (* init modbus TCP *)
					comPROFIBUS_DP: ;
					comPROFIBUS_DPold: ;
					comPROFINET: ;
				END_CASE;

		END_CASE;
	END_IF;			
	siComm1_type:= Para.iIdx_Comm1_type;
	(*---------------------------------------------------------------------------
	/* END: check for changes in the configuration and close interfaces connections
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* initialise new coupling
	/*-------------------------------------------------------------------------*)
	IF bMBinit[0] OR (bMBtcpinit[0] AND (MBSClose_Var[0].status = 0)) THEN
		szDevice1:= '';
		szMode1:= '';
		szHilf1:= '';
	
		CASE Para.iIdx_Comm1_type OF
			(*-------------------------------
			/* modbus - RTU
			/*-----------------------------*)
			comMODBUS_RTU:
				(* get device parameter *)
				CASE Para.iIdx_Comm1_Interface OF
					1:	szDevice1:= szInterface01;
					2:	szDevice1:= szInterface02;
					3:	szDevice1:= szInterface03;
					4:	szDevice1:= szInterface04;
					5:	szDevice1:= szInterface05;
				END_CASE;
	
				(* get interface parameters *)
				CASE Para.iIdx_Comm1_Interface OF
					1:	strcpy(ADR(szMode1), ADR('/PHY=RS485 '));
					2:	strcpy(ADR(szMode1), ADR('/PHY=RS422 '));
					3:	strcpy(ADR(szMode1), ADR('/PHY=RS485 '));
					4:	strcpy(ADR(szMode1), ADR('/PHY=RS485 '));
					5:	strcpy(ADR(szMode1), ADR('/PHY=RS485 '));
				END_CASE;

				(* adjust parity *)
				CASE Para.iComm1_Parity OF		(* 0=even, 1=odd, 2=none *)
					0:	strcat(ADR(szMode1), ADR('/PA=E /DB=8 '));
					1:	strcat(ADR(szMode1), ADR('/PA=O /DB=8 '));
					2:	strcat(ADR(szMode1), ADR('/PA=N /DB=8 '));
				END_CASE;

				(* adjust stop bits *)
				IF Para.iComm1_Stopbit = 1 THEN		(* 1= 1 stop bit, 2= 2 stop bits *)
					strcat(ADR(szMode1), ADR('/SB=1 '));
				ELSE
					strcat(ADR(szMode1), ADR('/SB=2 '));
				END_IF;

				(* adjust baud rate *)
				strcat(ADR(szMode1), ADR('/BD='));
				ITOA(Para.iComm1_Baud, szHilf1);
				strcat(ADR(szMode1), ADR(szHilf1));

				(* opening modbus RTU *)
				MBSOpen_Var[0].enable:= TRUE;                          (* enable *)
				MBSOpen_Var[0].pDevice:= ADR(szDevice1);               (* position of the interface *)
				MBSOpen_Var[0].pMode:= ADR(szMode1);                   (* mode of the interface *)
				MBSOpen_Var[0].pHoldingReg:= ADR('coupling:MBR_4_1');      (* PV name for FC 03, 06 and 16 *)
				MBSOpen_Var[0].own_ID:= INT_TO_USINT(Para.iComm1_SlaveID); (* MODBUS - ID *)
				MBSOpen_Var[0].timeout:= 1000;                         (* timeout 1 second *)

				(* call FUB MBSOpen *)
				MBSOpen_Var[0]();
	
				IF MBSOpen_Var[0].status = 0 THEN
					CP1:= FALSE;                                         (* reset error bit *)
					MBinitOK[0]:= TRUE;                                  (* coupling 1 modbus RTU ready *)
					MBSlave_Var[0].enable:= TRUE;                        (* activate server *)
					MBSlave_Var[0].ident:= MBSOpen_Var[0].ident;         (* set Ident *)
					bMBinit[0]:= FALSE;                                  (* initialising coupling 1 done *)
				ELSE
					CP1:= TRUE;                                          (* set error bit *)
					usStatus_CP1_CP2:= MBSOpen_Var[0].status;		     (* status info for AMM *)
				END_IF;
				(* modbus RTU - end *)

			(*-------------------------------
			/* modbus - TCP
			/*-----------------------------*)
			comMODBUS_TCP:
				IF (ucINIT_IP_addr_TCP = 1) THEN	
					(* Copy slave IP adress from parameter to local string variable *)
					szComm_IPaddr_TCP_temp:= '';
					szIPAddr1:= '';
					szIPAddr2:= '';
					szIPAddr3:= '';
					szIPAddr4:= '';
					ITOA(Para.iComm_IPaddr_first_TCP, szIPAddr1);
					ITOA(Para.iComm_IPaddr_second_TCP, szIPAddr2);
					ITOA(Para.iComm_IPaddr_third_TCP, szIPAddr3);
					ITOA(Para.iComm_IPaddr_fourth_TCP, szIPAddr4);
					strcat(ADR(szComm_IPaddr_TCP_temp), ADR(szIPAddr1));
					strcat(ADR(szComm_IPaddr_TCP_temp), ADR('.'));
					strcat(ADR(szComm_IPaddr_TCP_temp), ADR(szIPAddr2));
					strcat(ADR(szComm_IPaddr_TCP_temp), ADR('.'));
					strcat(ADR(szComm_IPaddr_TCP_temp), ADR(szIPAddr3));
					strcat(ADR(szComm_IPaddr_TCP_temp), ADR('.'));
					strcat(ADR(szComm_IPaddr_TCP_temp), ADR(szIPAddr4));
					memcpy(ADR(szComm_IPaddr_TCP), ADR(szComm_IPaddr_TCP_temp), 15);
					
					(* Copy slave Subnet mask from parameter to local string variable *)
					szComm_SubMask_TCP_temp:= '';
					szSubMask1:= '';
					szSubMask2:= '';
					szSubMask3:= '';
					szSubMask4:= '';
					ITOA(Para.iComm_SubMask_first_TCP, szSubMask1);
					ITOA(Para.iComm_SubMask_second_TCP, szSubMask2);
					ITOA(Para.iComm_SubMask_third_TCP, szSubMask3);
					ITOA(Para.iComm_SubMask_fourth_TCP, szSubMask4);
					strcat(ADR(szComm_SubMask_TCP_temp), ADR(szSubMask1));
					strcat(ADR(szComm_SubMask_TCP_temp), ADR('.'));
					strcat(ADR(szComm_SubMask_TCP_temp), ADR(szSubMask2));
					strcat(ADR(szComm_SubMask_TCP_temp), ADR('.'));
					strcat(ADR(szComm_SubMask_TCP_temp), ADR(szSubMask3));
					strcat(ADR(szComm_SubMask_TCP_temp), ADR('.'));
					strcat(ADR(szComm_SubMask_TCP_temp), ADR(szSubMask4));
					memcpy(ADR(szComm_SubMask_TCP), ADR(szComm_SubMask_TCP_temp), 15);
					
					ucINIT_IP_addr_TCP:= 0; 
					(* Start condition to set slave IP address and Subnet mask *)
					IP_ModTCP:= 1;
					
				END_IF;

				CASE IP_ModTCP OF
					(* Set slave IP adress IF4.ETH *)
					IP_IF4_SET:							
						CfgSetIPAddr_01(enable := TRUE, pDevice := iComm_Device_TCP, pIPAddr := iComm_IPaddr_TCP);
						IF CfgSetIPAddr_01.status = 0 THEN
							CfgSetIPAddr_01(enable := FALSE, pDevice := iComm_Device_TCP, pIPAddr := iComm_IPaddr_TCP);
							IP_ModTCP := SUBMASK_IF4_SET;
						ELSIF CfgSetIPAddr_01.status <> 65535 THEN
							IP_ModTCP := IF4_ERR;
						END_IF;

					(* Set subnet mask IF4.ETH *)
					SUBMASK_IF4_SET:
						CfgSetSubnetMask_01(enable := TRUE, pDevice := iComm_Device_TCP, pSubnetMask := iComm_SubMask_TCP);
						IF CfgSetSubnetMask_01.status = 0 THEN
							CfgSetSubnetMask_01(enable := FALSE, pDevice := iComm_Device_TCP, pSubnetMask := iComm_SubMask_TCP);
							IP_ModTCP := IF4_OK;
						ELSIF CfgSetSubnetMask_01.status <> 65535 THEN
							IP_ModTCP := IF4_ERR;
						END_IF;
	
					(* IF4 setting OK *)
					IF4_OK:
						IP_ModTCP := OPEN_MODTCP;
			
					(* Opening modbus TCP  *)
					OPEN_MODTCP:
						fMBTSOpen_Var.bEnable:= TRUE;                          (* enable *)
						fMBTSOpen_Var.uiPort:= Para.iComm_PortID_TCP;          (* TCP port number *)
						fMBTSOpen_Var.uiNbrUnits:= 1;                          (* number of modbus units *)
						fMBTSOpen_Var.uiOffsetUnits:= Para.iComm_SlaveID_TCP ; (* offset of modbus units *)
						fMBTSOpen_Var.pbCoil:= 0;                              (* coil mapping *)
						fMBTSOpen_Var.uiNbrCoils:= 0;                          (* number of read/write coils *)
						fMBTSOpen_Var.pbDInp:= 0;                              (* discrete input mapping *)
						fMBTSOpen_Var.uiNbrDiscreteInputs:= 0;                 (* number of read-only discrete inputs *)
						fMBTSOpen_Var.puiIReg:=0;                              (* input register mapping *)
						fMBTSOpen_Var.uiNbrInputRegs:= 0;                      (* number of read-only input registers *)
						fMBTSOpen_Var.puiHReg:= ADR(MBT_4_1);                  (* holding register mapping *)
						fMBTSOpen_Var.uiNbrHoldingRegs:= SIZEOF(MBT_4_1)/SIZEOF(MBT_4_1[0]);  (* number of read/write holding registers *)
						(* call FUB fMBTSOpen *)
						fMBTSOpen_Var();
		
						IF fMBTSOpen_Var.uiStatus = 0 THEN
							CP1:= FALSE;                                         (* reset error bit *)
							MBtcpInitOK[0]:= TRUE;                               (* coupling 1 modbus TCP ready *)
							fMBTSlave_Var.bEnable:= TRUE;                        (* activate server *)
							fMBTSlave_Var.udiIdent:= fMBTSOpen_Var.udiIdent;     (* set Ident *)
							fMBTSlave_Var.tiRecvDelay:= T#10s;                   (* set receive delay *)
							bMBtcpinit[0]:= FALSE;                               (* initialising coupling 1 done *)
						ELSE
							CP1:= TRUE;                                          (* set error bit *)
							usStatus_CP1_CP2:= fMBTSOpen_Var.uiStatus;		     (* status info for AMM *)
							IP_ModTCP := IF4_ERR;
						END_IF;

					(* Error handling *)
					IF4_ERR:
						AsArLogWrite_TCP(enable:= TRUE, ident:= AsArLogGetInfo_TCP.ident, logLevel:= arlogLEVEL_WARNING, errornr:= 52101, mem:= 0, len:= 0, asciiString:= ADR(logErrorStringModTCP));
						IF (AsArLogWrite_TCP.status <> 0) THEN
							IP_ModTCP := IF4_IDLE;                 
						END_IF;
				END_CASE;		
				(* modbus TCP - end *)
		END_CASE;
	END_IF;

		(*----------------------------------------------
		/* Profibus DP - Slave 1 - Link 1 and Link 2
		/*---------------------------------------------*)
		(* Check if slave adress gets changed *)
		IF  (Para.iComm1_PB_SlaveID1 <> iComm1_PB_SlaveID1_old) AND IN_CP.tPB2MM.bParaSetupOk AND (Para.iIdx_Comm1_type = 4 OR Para.iIdx_Comm1_type = 5) THEN	//Mathias 3.10.16
			iComm1_PB_SlaveID1_old := Para.iComm1_PB_SlaveID1;
			iComm_PB_SlaveID1 := Para.iComm1_PB_SlaveID1;
			Start_PB_Slave1:= 1;
		END_IF;
		IF  (Para.iComm2_PB_SlaveID1 <> iComm2_PB_SlaveID1_old) AND IN_CP.tPB2MM.bParaSetupOk AND (Para.iIdx_Comm2_type = 4 OR Para.iIdx_Comm2_type = 5) THEN	//Mathias 3.10.16
			iComm2_PB_SlaveID1_old := Para.iComm2_PB_SlaveID1;
			iComm_PB_SlaveID1 := Para.iComm2_PB_SlaveID1;
			Start_PB_Slave1:= 1;
		END_IF;
	
		(* Set slave address and start communication*)
		CASE Start_PB_Slave1 OF
			
			SET_SLAVE1_ADDR:	
				(*Set Profibus slave adress *)
				nxdpsSetAdr_01(enable:= TRUE, pDevice:= iInterface01_Comm1, address:= iComm_PB_SlaveID1);
				IF nxdpsSetAdr_01.status = 0 THEN
					nxdpsSetAdr_01(enable:= FALSE, pDevice:= iInterface01_Comm1, address:= iComm_PB_SlaveID1);
					Start_PB_Slave1:= 2;
				ELSIF nxdpsSetAdr_01.status <> 65535 THEN
					Start_PB_Slave1:= 4;
				END_IF
	
			START_SLAVE1_COMM:
	 			nxdpsStartBusComm_01(enable:= TRUE, pDevice:= iInterface01_Comm1);
				IF nxdpsStartBusComm_01.status = 0 THEN
					nxdpsStartBusComm_01(enable:= FALSE, pDevice:= iInterface01_Comm1);
					Start_PB_Slave1:= 3;
				ELSIF nxdpsStartBusComm_01.status <> 65535 THEN
					Start_PB_Slave1:= 4;
				END_IF;
	
			SLAVE1_COMM_OK:
				Start_PB_Slave1:= 0;
	
			SLAVE1_COMM_ERR:
				AsArLogWrite_PB_01(enable:= TRUE, ident:= AsArLogGetInfo_PB_01.ident, logLevel:= arlogLEVEL_WARNING, errornr:= 52100, mem:= 0, len:= 0, asciiString:= ADR(logErrorString1));
				IF (AsArLogWrite_PB_01.status <> 0) THEN
					Start_PB_Slave1:= 0;                 
				END_IF;
		END_CASE;
		
		(*----------------------------------------------
		/* Profibus DP - Slave 2 - Link 1 and Link 2
		/*---------------------------------------------*)
		(* Check if slave adress gets changed *)
		IF  (Para.iComm1_PB_SlaveID2 <> iComm1_PB_SlaveID2_old) AND IN_CP.tPB2MM.bParaSetupOk AND (Para.iIdx_Comm1_type = 4 OR Para.iIdx_Comm1_type = 5) THEN	//Mathias 3.10.16
			iComm1_PB_SlaveID2_old:= Para.iComm1_PB_SlaveID2;
			iComm_PB_SlaveID2 := Para.iComm1_PB_SlaveID2;
			Start_PB_Slave2:= 1;
		END_IF;
		IF  (Para.iComm2_PB_SlaveID2 <> iComm2_PB_SlaveID2_old) AND IN_CP.tPB2MM.bParaSetupOk AND (Para.iIdx_Comm2_type = 4 OR Para.iIdx_Comm2_type = 5) THEN	//Mathias 3.10.16
			iComm2_PB_SlaveID2_old:= Para.iComm2_PB_SlaveID2;
			iComm_PB_SlaveID2 := Para.iComm2_PB_SlaveID2;
			Start_PB_Slave2:= 1;
		END_IF
	
		(* Set slave address and start communication*)
		CASE Start_PB_Slave2 OF
			
			SET_SLAVE2_ADDR:	
				(*Set Profibus slave adress *)
				nxdpsSetAdr_02(enable:= TRUE, pDevice:= iInterface02_Comm1, address:= iComm_PB_SlaveID2);
				IF nxdpsSetAdr_02.status = 0 THEN
					nxdpsSetAdr_02(enable:= FALSE, pDevice:= iInterface02_Comm1, address:= iComm_PB_SlaveID2);
					Start_PB_Slave2:= 2;
				ELSIF nxdpsSetAdr_02.status <> 65535 THEN
					Start_PB_Slave2:= 4;
				END_IF
	
			START_SLAVE2_COMM:
	 			nxdpsStartBusComm_02(enable:= TRUE, pDevice:= iInterface02_Comm1);
				IF nxdpsStartBusComm_02.status = 0 THEN
					nxdpsStartBusComm_02(enable:= FALSE, pDevice:= iInterface02_Comm1);
					Start_PB_Slave2:= 3;
				ELSIF nxdpsStartBusComm_02.status <> 65535 THEN
					Start_PB_Slave2:= 4;
				END_IF;
	
			SLAVE2_COMM_OK:
				Start_PB_Slave2:= 0;
	
			SLAVE2_COMM_ERR:
				AsArLogWrite_PB_02(enable:= TRUE, ident:= AsArLogGetInfo_PB_02.ident, logLevel:= arlogLEVEL_WARNING, errornr:= 52002, mem:= 0, len:= 0, asciiString:= ADR(logErrorString2));
				IF (AsArLogWrite_PB_02.status <> 0) THEN
					Start_PB_Slave2:= 0;                 
				END_IF;
		END_CASE;

		(*--------------------------------------------
		/* Profinet - Slave 1 - Link 1 and Link 2
		/*-------------------------------------------*)
		(* Check if slave adress gets changed *)
		IF  (Para.iComm1_PN_SlaveID1 <> iComm1_PN_SlaveID1_old) AND OUT_CP.tCP2PB.bMyParaSetupOk AND (Para.iIdx_Comm1_type = 6) THEN
			iComm1_PN_SlaveID1_old:= Para.iComm1_PN_SlaveID1;
			iComm_PN_SlaveID1:= Para.iComm1_PN_SlaveID1;
			Start_PN_Slave1:= 1;
		END_IF;
		IF  (Para.iComm2_PN_SlaveID1 <> iComm2_PN_SlaveID1_old) AND OUT_CP.tCP2PB.bMyParaSetupOk AND (Para.iIdx_Comm2_type = 6) THEN
			iComm2_PN_SlaveID1_old:= Para.iComm2_PN_SlaveID1;
			iComm_PN_SlaveID1:= Para.iComm2_PN_SlaveID1;
			Start_PN_Slave1:= 1;
		END_IF;

		(* Set slave name and start communication*)
		CASE Start_PN_Slave1 OF
			
			SET_PN_SLAVE1_ADDR:	
				(*Set Profinet slave name *)
				StationName1  := 'gejenbacher';
				itoa(INT_TO_DINT(iComm_PN_SlaveID1), ADR(StationNumber));
				Station := strcat(ADR(StationName1), ADR(StationNumber));
				nxpnsSetName_01(enable:= TRUE, pDevice:= iInterface01_Comm1_PN, pName:= ADR(StationName1));
				IF nxpnsSetName_01.status = 0 THEN
					nxpnsSetName_01(enable:= FALSE, pDevice:= iInterface01_Comm1_PN, pName:= ADR(StationName1));
					Start_PN_Slave1:= 2;
				ELSIF nxpnsSetName_01.status = 65535 THEN
					Start_PN_Slave1:= 1;
				ELSIF nxpnsSetName_01.status <> 65535 THEN
					Start_PN_Slave1:= 4;
				END_IF
	
			START_PN_SLAVE1_COMM:
	 			nxpnsStartBusComm_01(enable:= TRUE, pDevice:= iInterface01_Comm1_PN);
				IF nxpnsStartBusComm_01.status = 0 THEN
					nxpnsStartBusComm_01(enable:= FALSE, pDevice:= iInterface01_Comm1_PN);
					Start_PN_Slave1:= 3;
				ELSIF nxpnsStartBusComm_01.status <> 65535 THEN
					Start_PN_Slave1:= 4;
				END_IF;
	
			SLAVE1_PN_COMM_OK:
				Start_PN_Slave1:= 0;
	
			SLAVE1_PN_COMM_ERR:
				AsArLogWrite_PN_01(enable:= TRUE, ident:= AsArLogGetInfo_PN_01.ident, logLevel:= arlogLEVEL_WARNING, errornr:= 52002, mem:= 0, len:= 0, asciiString:= ADR(logErrorStringPN));
				IF (AsArLogWrite_PN_01.status <> 0) THEN
					Start_PN_Slave1:= 0;                 
				END_IF;
		END_CASE;

	(*---------------------------------------------------------------------------
	/* END: initialise new coupling
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* call server
	/*-------------------------------------------------------------------------*)
	(* start splitter *)
	IF ucTeilerLauf > ucTeiler THEN
		CASE Para.iIdx_Comm1_type OF
			(*-------------------------------
			/* modbus - RTU
			/*-----------------------------*)
			comMODBUS_RTU:
				IF MBinitOK[0] THEN	      (* check init O.K. *)
					(* call FUB MBSlave *)
					MBSlave_Var[0]();
				END_IF;

			(*-------------------------------
			/* modbus - TCP
			/*-----------------------------*)
			comMODBUS_TCP:
				IF MBtcpInitOK[0] THEN    (* check init O.K. *)
					(* call FUB fMBTSlave *)
					fMBTSlave_Var();	   
				END_IF;
		END_CASE;
	END_IF;  (* stop splitter *)
	(*---------------------------------------------------------------------------
	/* END: call server
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* copying receive data from the input variables into data area
	/*-------------------------------------------------------------------------*)
	(* start splitter *)
	IF ucTeilerLauf > ucTeiler THEN
		(* receive data enabled? *)
		IF bKopl1EmpfFrg = TRUE THEN
	 		CASE Para.iIdx_Comm1_type OF
				(*-------------------------------
				/* modbus - RTU
				/*-----------------------------*)
				comMODBUS_RTU:
					memcpy(ADR(OUT_CP.InData1[0]), ADR(MBR_4_1[MODBUS_RTU_MAX_SEND]), MODBUS_RTU_MAX_RECV*2);

				(*-------------------------------
				/* modbus - TCP
				/*-----------------------------*)
				comMODBUS_TCP:
					memcpy(ADR(OUT_CP.InData1[0]), ADR(MBT_4_1[MODBUS_TCP_MAX_SEND]), MODBUS_TCP_MAX_RECV*2);
	
				(*-------------------------------
				/* profibus DP
				/*-----------------------------*)
				comPROFIBUS_DP:
					memcpy(ADR(OUT_CP.InData1[0]), ADR(InData1[0]), PROFIBUS_MAX_RECV*2);
					(*---------------------------------------------------------------------------
					/* Profibus BIG/LITTLE endian InData-Array swapping
					/*-------------------------------------------------------------------------*)
					IF Para.bComm_MSB_LSB THEN
						memcpy(ADR(InDataSwap[0]), ADR(OUT_CP.InData1[0]), PROFIBUS_MAX_RECV_2SLAVES*2);
						FOR ArrayCntIn := 0 TO (PROFIBUS_MAX_RECV_2SLAVES - 1) BY 1 DO
							 OUT_CP.InData1[ArrayCntIn] := swapINT(InDataSwap[ArrayCntIn]);
						END_FOR;
					END_IF;

				(*-------------------------------
				/* profibus DP old
				/*-----------------------------*)
				comPROFIBUS_DPold:
					memcpy(ADR(OUT_CP.InData1[0]), ADR(InData1[0]), PROFIBUS_MAX_RECV*2);
					(*---------------------------------------------------------------------------
					/* Profibus old BIG/LITTLE endian InData-Array swapping
					/*-------------------------------------------------------------------------*)
					IF Para.bComm_MSB_LSB THEN
						memcpy(ADR(InDataSwap[0]), ADR(OUT_CP.InData1[0]), PROFIBUS_MAX_RECV_2SLAVES*2);
						FOR ArrayCntIn := 0 TO (PROFIBUS_MAX_RECV_2SLAVES - 1) BY 1 DO
							 OUT_CP.InData1[ArrayCntIn] := swapINT(InDataSwap[ArrayCntIn]);
						END_FOR;
					END_IF;

				(*-------------------------------
				/* profinet
				/*-----------------------------*)
				comPROFINET:
					memcpy(ADR(OUT_CP.InData1[0]), ADR(InData1PN[0]), PROFINET_MAX_RECV*2);
					(*---------------------------------------------------------------------------
					/* Profinet BIG/LITTLE endian InData-Array swapping
					/*-------------------------------------------------------------------------*)
					IF Para.bComm_MSB_LSB THEN
						memcpy(ADR(InDataSwap[0]), ADR(OUT_CP.InData1[0]), PROFINET_MAX_RECV*2);
						FOR ArrayCntIn := 0 TO (PROFINET_MAX_RECV - 1) BY 1 DO
							OUT_CP.InData1[ArrayCntIn] := swapINT(InDataSwap[ArrayCntIn]);
						END_FOR;
					END_IF;

			END_CASE;
			
			(*-------------------------------
			/* Simulation WinMOD
			/*-----------------------------*)
			IF IN_CP.bSimWinMOD_Active THEN
				memcpy(ADR(OUT_CP.InData1), ADR(InData1SIM), SIZEOF(OUT_CP.InData1));
			END_IF;
				
		END_IF;  (* end receive data enabled? *)
	END_IF;  (* stop splitter *)
	(*---------------------------------------------------------------------------
	/* END: copying receive data from the input variables into data area
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* error handling
	/*-------------------------------------------------------------------------*)
	CASE Para.iIdx_Comm1_type OF
		(*-------------------------------
		/* no link
		/*-----------------------------*)
		comNO_LINK:
			CP1 := FALSE;     (* reset error bit *)
			RK1 := FALSE;     (* reset error bit *)

		(*-------------------------------
		/* modbus - RTU
		/*-----------------------------*)
		comMODBUS_RTU:
			IF ((MBSlave_Var[0].status <> 0) AND
			   (MBSlave_Var[0].status <> mbERR_NODE_TOUT) AND
			   (MBSlave_Var[0].status <> ERR_FUB_BUSY)) THEN
				RK1:= TRUE;     (* set error bit *)
				usStatus_RK1_RK2:= MBSlave_Var[0].status;	  (* status info for AMM *)
			ELSE
				RK1:= FALSE;     (* reset error bit *)
			END_IF;

		(*-------------------------------
		/* modbus - TCP
		/*-----------------------------*)
		comMODBUS_TCP:
			IF ((fMBTSlave_Var.uiStatus <>0) AND
			   (fMBTSlave_Var.uiStatus <> mbtERR_TIMEOUT) AND
			   (fMBTSlave_Var.uiStatus <> ERR_FUB_BUSY)) THEN
				RK1:= TRUE;     (* set error bit *)
				usStatus_RK1_RK2:= fMBTSlave_Var.uiStatus;	(* status info for AMM *)
			ELSE
				RK1:= FALSE;     (* reset error bit *)
			END_IF;

		(*-------------------------------
		/* profibus DP
		/*-----------------------------*)
		comPROFIBUS_DP:
			CP1 := FALSE;     (* reset error bit *)
			RK1 := FALSE;     (* reset error bit *)

		(*-------------------------------
		/* profibus DP old
		/*-----------------------------*)
		comPROFIBUS_DPold:
			CP1 := FALSE;     (* reset error bit *)
			RK1 := FALSE;     (* reset error bit *)

		(*-------------------------------
		/* profinet
		/*-----------------------------*)
		comPROFINET:
			CP1 := FALSE;     (* reset error bit *)
			RK1 := FALSE;     (* reset error bit *)

	END_CASE;
	(*---------------------------------------------------------------------------
	/* END: error handling
	/*-------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------
/* END: coupling 1
/*----------------------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------
/* coupling 2
/*----------------------------------------------------------------------------------------*)
	
	(*---------------------------------------------------------------------------
	/* check for changes in the configuration and close interfaces connections
	/*-------------------------------------------------------------------------*)
	IF OUT_CP.tCP2PB.bMyParaSetupOk THEN
	CASE siComm2_type OF
		(*-------------------------------
		/* no link
		/*-----------------------------*)
		comNO_LINK:
			(* select coupling type to initalise *)
			CASE Para.iIdx_Comm2_type OF
				comNO_LINK: ;
				comMODBUS_RTU: bMBinit[1]:= TRUE;     (* init modbus RTU *)
				comMODBUS_TCP: bMBtcpinit[1]:= TRUE;  (* init modbus TCP *)
				comPROFIBUS_DP: ;
				comPROFIBUS_DPold: ;
				comPROFINET: ;
			END_CASE;

		(*-------------------------------
		/* modbus - RTU
		/*-----------------------------*)
		comMODBUS_RTU:
			IF ((ucINIT[1] = 1) OR
			   (siComm2_type <> Para.iIdx_Comm2_type) OR
				 (siComm2_SlaveID <> Para.iComm2_SlaveID) OR
				 (siComm2_Baud <> Para.iComm2_Baud) OR
				 (siComm2_Parity <> Para.iComm2_Parity) OR
				 (siComm2_Stopbit <> Para.iComm2_Stopbit) OR
				 (siComm2_Interface <> Para.iIdx_Comm2_Interface)) THEN

				MBinitOK[1]:= FALSE;

				IF ucINIT[1] <> 1 THEN
					MBSClose_Var[1].enable:= TRUE;
					MBSClose_Var[1].ident:= MBSOpen_Var[1].ident;
					(* call FUB MBSClose *)
					MBSClose_Var[1]();
				END_IF;

				IF MBSClose_Var[1].status = 0 THEN
					(* refreshing the temporary parameters *)
					siComm2_SlaveID:= Para.iComm2_SlaveID;
					siComm2_Baud:= Para.iComm2_Baud;
					siComm2_Parity:= Para.iComm2_Parity;
					siComm2_Stopbit:= Para.iComm2_Stopbit;
					siComm2_Interface:= Para.iIdx_Comm2_Interface;
					ucINIT[1]:= 0;

					(* select coupling type to initalise *)
					CASE Para.iIdx_Comm2_type OF
						comNO_LINK: ;
						comMODBUS_RTU: bMBinit[1]:= TRUE;     (* init modbus RTU *)
						comMODBUS_TCP: bMBtcpinit[1]:= TRUE;  (* init modbus TCP *)
						comPROFIBUS_DP: ;
						comPROFIBUS_DPold: ;
						comPROFINET: ;
					END_CASE;
				END_IF;
			END_IF;

		(*-------------------------------
		/* modbus - TCP
		/*-----------------------------*)
		comMODBUS_TCP:
			IF ((ucINIT[1] = 1) OR
			    ((fMBTSOpen2_Var.udiIdent <> 0)
				 AND (   (siComm2_type <> Para.iIdx_Comm2_type)
				 	  OR (siComm2_SlaveID_TCP <> Para.iComm2_SlaveID_TCP)
				 	  OR (siComm2_PortID_TCP <> Para.iComm2_PortID_TCP)))) THEN
			
				MBtcpInitOK[1]:= FALSE;

				IF ucINIT[1] <> 1 THEN
					fMBTSClose2_Var.bEnable:= TRUE;
					fMBTSClose2_Var.udiIdent:= fMBTSOpen2_Var.udiIdent ;
					(* call FUB fMBTSClose *)
					fMBTSClose2_Var();
				END_IF;

				IF (fMBTSClose2_Var.uiStatus = 0) OR (fMBTSClose2_Var.uiStatus = 65535) THEN
					(* refreshing the temporary parameters *)
					siComm2_SlaveID_TCP:= Para.iComm2_SlaveID_TCP;
					siComm2_PortID_TCP:= Para.iComm2_PortID_TCP;
					ucINIT[1]:= 0;

					(* select coupling type to initalise *)
					CASE Para.iIdx_Comm2_type OF
						comNO_LINK: ;
						comMODBUS_RTU: bMBinit[1]:= TRUE;     (* init modbus RTU *)
						comMODBUS_TCP: bMBtcpinit[1]:= TRUE;  (* init modbus TCP *)
						comPROFIBUS_DP: ;
						comPROFIBUS_DPold: ;
						comPROFINET: ;
					END_CASE;
				END_IF;

			END_IF;

		(*-------------------------------
		/* profibus DP
		/*-----------------------------*)
		comPROFIBUS_DP:
			(* select coupling type to initalise *)
			CASE Para.iIdx_Comm1_type OF
				comNO_LINK: ;
				comMODBUS_RTU: bMBinit[1]:= TRUE;     (* init modbus RTU *)
				comMODBUS_TCP: bMBtcpinit[1]:= TRUE;  (* init modbus TCP *)
				comPROFIBUS_DP: ;
				comPROFIBUS_DPold: ;
				comPROFINET: ;
			END_CASE;

		(*-------------------------------
		/* profibus DP old
		/*-----------------------------*)
		comPROFIBUS_DPold:
			(* select coupling type to initalise *)
			CASE Para.iIdx_Comm1_type OF
				comNO_LINK: ;
				comMODBUS_RTU: bMBinit[1]:= TRUE;     (* init modbus RTU *)
				comMODBUS_TCP: bMBtcpinit[1]:= TRUE;  (* init modbus TCP *)
				comPROFIBUS_DP: ;
				comPROFIBUS_DPold: ;
				comPROFINET: ;
			END_CASE;

		(*-------------------------------
		/* profinet
		/*-----------------------------*)
		comPROFINET:
			(* select coupling type to initalise *)
			CASE Para.iIdx_Comm1_type OF
				comNO_LINK: ;
				comMODBUS_RTU: bMBinit[1]:= TRUE;     (* init modbus RTU *)
				comMODBUS_TCP: bMBtcpinit[1]:= TRUE;  (* init modbus TCP *)

				comPROFIBUS_DP: ;
				comPROFIBUS_DPold: ;
				comPROFINET: ;
			END_CASE;

	END_CASE;
	END_IF;
	siComm2_type:= Para.iIdx_Comm2_type;
	(*---------------------------------------------------------------------------
	/* END: check for changes in the configuration and close interfaces connections
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* initialise new coupling
	/*-------------------------------------------------------------------------*)
	IF bMBinit[1] OR bMBtcpinit[1] THEN
		szDevice1:= '';
		szMode1:= '';
		szHilf1:= '';
	
		CASE Para.iIdx_Comm2_type OF
			(*-------------------------------
			/* modbus - RTU
			/*-----------------------------*)
			comMODBUS_RTU:
				(* get device parameter *)
				CASE Para.iIdx_Comm2_Interface OF
					1:	szDevice1:= szInterface01;
					2:	szDevice1:= szInterface02;
					3:	szDevice1:= szInterface03;
					4:	szDevice1:= szInterface04;
					5:	szDevice1:= szInterface05;
				END_CASE;
	
				(* get interface parameters *)
				CASE Para.iIdx_Comm2_Interface OF
					1:	strcpy(ADR(szMode1), ADR('/PHY=RS485 '));
					2:	strcpy(ADR(szMode1), ADR('/PHY=RS422 '));
					3:	strcpy(ADR(szMode1), ADR('/PHY=RS485 '));
					4:	strcpy(ADR(szMode1), ADR('/PHY=RS485 '));
					5:	strcpy(ADR(szMode1), ADR('/PHY=RS485 '));
				END_CASE;

				(* adjust parity *)
				CASE Para.iComm2_Parity OF		(* 0=even, 1=odd, 2=none *)
					0:	strcat(ADR(szMode1), ADR('/PA=E /DB=8 '));
					1:	strcat(ADR(szMode1), ADR('/PA=O /DB=8 '));
					2:	strcat(ADR(szMode1), ADR('/PA=N /DB=8 '));
				END_CASE;

				(* adjust stop bits *)
				IF Para.iComm2_Stopbit = 1 THEN		(* 1= 1 stop bit, 2= 2 stop bits *)
					strcat(ADR(szMode1), ADR('/SB=1 '));
				ELSE
					strcat(ADR(szMode1), ADR('/SB=2 '));
				END_IF;

				(* adjust baud rate *)
				strcat(ADR(szMode1), ADR('/BD='));
				ITOA(Para.iComm2_Baud, szHilf1);
				strcat(ADR(szMode1), ADR(szHilf1));

				(* opening modbus RTU  *)
				MBSOpen_Var[1].enable:= TRUE;                          (* enable *)
				MBSOpen_Var[1].pDevice:= ADR(szDevice1);               (* position of the interface *)
				MBSOpen_Var[1].pMode:= ADR(szMode1);                   (* mode of the interface *)
				MBSOpen_Var[1].pHoldingReg:= ADR('coupling:MBR_4_2');      (* PV name for FC 03, 06 and 16 *)
				MBSOpen_Var[1].own_ID:= INT_TO_USINT(Para.iComm2_SlaveID); (* MODBUS - ID *)
				MBSOpen_Var[1].timeout:= 1000;                         (* timeout 1 second *)

				(* call FUB MBSOpen *)
				MBSOpen_Var[1]();
	
				IF MBSOpen_Var[1].status = 0 THEN
					CP2:= FALSE;                                         (* reset error bit *)
					MBinitOK[1]:= TRUE;                                  (* coupling 2 modubus RTU ready *)
					MBSlave_Var[1].enable:= TRUE;                        (* activate server *)
					MBSlave_Var[1].ident:= MBSOpen_Var[1].ident;         (* set Ident *)
					bMBinit[1]:= FALSE;                                  (* initialising coupling 2 done *)
				ELSE
					CP2:= TRUE;                                          (* set error bit *)
					usStatus_CP1_CP2:= MBSOpen_Var[1].status;		         (* status info for AMM *)
				END_IF;
				(* modbus RTU - end *)

			(*-------------------------------
			/* modbus - TCP
			/*-----------------------------*)
			comMODBUS_TCP:
				IF (ucINIT_IP_addr_TCP2 = 1) THEN	
					(* Copy slave IP adress from parameter to local string variable *)
					szComm2_IPaddr_TCP_temp:= '';
					szComm2_IPAddr1:= '';
					szComm2_IPAddr2:= '';
					szComm2_IPAddr3:= '';
					szComm2_IPAddr4:= '';
					ITOA(Para.iComm2_IPaddr_first_TCP, szComm2_IPAddr1);
					ITOA(Para.iComm2_IPaddr_second_TCP, szComm2_IPAddr2);
					ITOA(Para.iComm2_IPaddr_third_TCP, szComm2_IPAddr3);
					ITOA(Para.iComm2_IPaddr_fourth_TCP, szComm2_IPAddr4);
					strcat(ADR(szComm2_IPaddr_TCP_temp), ADR(szComm2_IPAddr1));
					strcat(ADR(szComm2_IPaddr_TCP_temp), ADR('.'));
					strcat(ADR(szComm2_IPaddr_TCP_temp), ADR(szComm2_IPAddr2));
					strcat(ADR(szComm2_IPaddr_TCP_temp), ADR('.'));
					strcat(ADR(szComm2_IPaddr_TCP_temp), ADR(szComm2_IPAddr3));
					strcat(ADR(szComm2_IPaddr_TCP_temp), ADR('.'));
					strcat(ADR(szComm2_IPaddr_TCP_temp), ADR(szComm2_IPAddr4));
					memcpy(ADR(szComm2_IPaddr_TCP), ADR(szComm2_IPaddr_TCP_temp), 15);
					
					(* Copy slave Subnet mask from parameter to local string variable *)
					szComm2_SubMask_TCP_temp:= '';
					szComm2_SubMask1:= '';
					szComm2_SubMask2:= '';
					szComm2_SubMask3:= '';
					szComm2_SubMask4:= '';
					ITOA(Para.iComm2_SubMask_first_TCP, szComm2_SubMask1);
					ITOA(Para.iComm2_SubMask_second_TCP, szComm2_SubMask2);
					ITOA(Para.iComm2_SubMask_third_TCP, szComm2_SubMask3);
					ITOA(Para.iComm2_SubMask_fourth_TCP, szComm2_SubMask4);
					strcat(ADR(szComm2_SubMask_TCP_temp), ADR(szComm2_SubMask1));
					strcat(ADR(szComm2_SubMask_TCP_temp), ADR('.'));
					strcat(ADR(szComm2_SubMask_TCP_temp), ADR(szComm2_SubMask2));
					strcat(ADR(szComm2_SubMask_TCP_temp), ADR('.'));
					strcat(ADR(szComm2_SubMask_TCP_temp), ADR(szComm2_SubMask3));
					strcat(ADR(szComm2_SubMask_TCP_temp), ADR('.'));
					strcat(ADR(szComm2_SubMask_TCP_temp), ADR(szComm2_SubMask4));
					memcpy(ADR(szComm2_SubMask_TCP), ADR(szComm2_SubMask_TCP_temp), 15);
					
					ucINIT_IP_addr_TCP2:= 0; 
					(* Start condition to set slave IP address and Subnet mask *)
					IP_ModTCP2:= 1;
					
				END_IF;

				CASE IP_ModTCP2 OF
					(* Set slave IP adress IF4.ETH *)
					IP_IF4_SET:							
						CfgSetIPAddr_02(enable := TRUE, pDevice := iComm2_Device_TCP, pIPAddr := iComm2_IPaddr_TCP);
						IF CfgSetIPAddr_02.status = 0 THEN
							CfgSetIPAddr_02(enable := FALSE, pDevice := iComm2_Device_TCP, pIPAddr := iComm2_IPaddr_TCP);
							IP_ModTCP2 := SUBMASK_IF4_SET;
						ELSIF CfgSetIPAddr_02.status <> 65535 THEN
							IP_ModTCP2 := IF4_ERR;
						END_IF;

					(* Set subnet mask IF4.ETH *)
					SUBMASK_IF4_SET:
						CfgSetSubnetMask_02(enable := TRUE, pDevice := iComm2_Device_TCP, pSubnetMask := iComm2_SubMask_TCP);
						IF CfgSetSubnetMask_02.status = 0 THEN
							CfgSetSubnetMask_02(enable := FALSE, pDevice := iComm2_Device_TCP, pSubnetMask := iComm2_SubMask_TCP);
							IP_ModTCP2 := IF4_OK;
						ELSIF CfgSetSubnetMask_02.status <> 65535 THEN
							IP_ModTCP2 := IF4_ERR;
						END_IF;
	
					(* IF4 setting OK *)
					IF4_OK:
						IP_ModTCP2 := OPEN_MODTCP;
			
					(* Opening modbus TCP  *)
					OPEN_MODTCP:	
						fMBTSOpen2_Var.bEnable:= TRUE;                          (* enable *)
						fMBTSOpen2_Var.uiPort:= Para.iComm2_PortID_TCP;          (* TCP port number *)
						fMBTSOpen2_Var.uiNbrUnits:= 1;                          (* number of modbus units *)
						fMBTSOpen2_Var.uiOffsetUnits:= Para.iComm2_SlaveID_TCP ; (* offset of modbus units *)
						fMBTSOpen2_Var.pbCoil:= 0;                              (* coil mapping *)
						fMBTSOpen2_Var.uiNbrCoils:= 0;                          (* number of read/write coils *)
						fMBTSOpen2_Var.pbDInp:= 0;                              (* discrete input mapping *)
						fMBTSOpen2_Var.uiNbrDiscreteInputs:= 0;                 (* number of read-only discrete inputs *)
						fMBTSOpen2_Var.puiIReg:=0;                              (* input register mapping *)
						fMBTSOpen2_Var.uiNbrInputRegs:= 0;                      (* number of read-only input registers *)
						fMBTSOpen2_Var.puiHReg:= ADR(MBT_4_2);                  (* holding register mapping *)
						fMBTSOpen2_Var.uiNbrHoldingRegs:= SIZEOF(MBT_4_2)/SIZEOF(MBT_4_2[0]);  (* number of read/write holding registers *)
						(* call FUB fMBTSOpen *)
						fMBTSOpen2_Var();

						IF fMBTSOpen2_Var.uiStatus = 0 THEN
							CP2:= FALSE;                                         (* reset error bit *)
							MBtcpInitOK[1]:= TRUE;                               (* coupling 2 modbus TCP ready *)
							fMBTSlave2_Var.bEnable:= TRUE;                        (* activate server *)
							fMBTSlave2_Var.udiIdent:= fMBTSOpen2_Var.udiIdent;     (* set Ident *)
							fMBTSlave2_Var.tiRecvDelay:= T#10s;                   (* set receive delay *)
							bMBtcpinit[1]:= FALSE;                               (* initialising coupling 2 done *)
						ELSE
							CP2:= TRUE;                                          (* set error bit *)
							usStatus_CP1_CP2:= fMBTSOpen2_Var.uiStatus;		     (* status info for AMM *)
						END_IF;
				END_CASE;
			(* modbus TCP - end *)
		END_CASE;
	END_IF;
	(*---------------------------------------------------------------------------
	/* END: initialise new coupling
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* call server
	/*-------------------------------------------------------------------------*)
	(* start splitter *)
	IF ucTeilerLauf > ucTeiler THEN
		CASE Para.iIdx_Comm2_type OF
			(*-------------------------------
			/* modbus - RTU
			/*-----------------------------*)
			comMODBUS_RTU:
				IF MBinitOK[1] THEN       (* check init O.K. *)
					(* call FUB MBSlave *)
					MBSlave_Var[1]();
				END_IF;

			(*-------------------------------
			/* modbus - TCP
			/*-----------------------------*)
			comMODBUS_TCP:
				IF MBtcpInitOK[1] THEN    (* check init O.K. *)
					(* call FUB fMBTSlave *)
					fMBTSlave2_Var();	   
				END_IF;
		END_CASE;
	END_IF;  (* stop splitter *)
	(*---------------------------------------------------------------------------
	/* END: call server
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* copying receive data from the input variables into data area
	/*-------------------------------------------------------------------------*)
	(* start splitter *)
	IF ucTeilerLauf > ucTeiler THEN
		(* receive data enabled? *)
		IF bKopl2EmpfFrg = TRUE THEN
			CASE Para.iIdx_Comm2_type OF
				(*-------------------------------
				/* modbus - RTU
				/*-----------------------------*)
				comMODBUS_RTU:
					IF (Para.iIdx_Comm1_type <> comNO_LINK) THEN
						memcpy(ADR(OUT_CP.InData2[0]), ADR(MBR_4_2[MODBUS_RTU_MAX_SEND]), MODBUS_RTU_MAX_RECV*2);
					ELSE
						memcpy(ADR(OUT_CP.InData1[0]), ADR(MBR_4_2[MODBUS_RTU_MAX_SEND]), MODBUS_RTU_MAX_RECV*2);
					END_IF;

				(*-------------------------------
				/* modbus - TCP
				/*-----------------------------*)
				comMODBUS_TCP:	
					IF (Para.iIdx_Comm1_type <> comNO_LINK) THEN
						memcpy(ADR(OUT_CP.InData2[0]), ADR(MBT_4_2[MODBUS_TCP_MAX_SEND]), MODBUS_TCP_MAX_RECV*2);
					ELSE
						memcpy(ADR(OUT_CP.InData1[0]), ADR(MBT_4_2[MODBUS_TCP_MAX_SEND]), MODBUS_TCP_MAX_RECV*2);
					END_IF;

				(*-------------------------------
				/* profibus DP
				/*-----------------------------*)
				comPROFIBUS_DP:
					IF (Para.iIdx_Comm1_type <> comNO_LINK) THEN
						memcpy(ADR(OUT_CP.InData2[0]), ADR(InData1[0]), PROFIBUS_MAX_RECV*2);			//Mathias 3.10.16
						(*---------------------------------------------------------------------------
						/* Profibus BIG/LITTLE endian InData-Array swapping
						/*-------------------------------------------------------------------------*)
						IF Para.bComm_MSB_LSB THEN
							memcpy(ADR(InDataSwap[0]), ADR(OUT_CP.InData1[0]), PROFIBUS_MAX_RECV_2SLAVES*2);
							FOR ArrayCntIn := 0 TO (PROFIBUS_MAX_RECV_2SLAVES - 1) BY 1 DO
								OUT_CP.InData1[ArrayCntIn] := swapINT(InDataSwap[ArrayCntIn]);
							END_FOR;
						END_IF;
					ELSE
						memcpy(ADR(OUT_CP.InData1[0]), ADR(InData1[0]), PROFIBUS_MAX_RECV*2);
					END_IF;

				(*-------------------------------
				/* profibus DP old
				/*-----------------------------*)
				comPROFIBUS_DPold:
					IF (Para.iIdx_Comm1_type <> comNO_LINK) THEN
						memcpy(ADR(OUT_CP.InData2[0]), ADR(InData1[0]), PROFIBUS_MAX_RECV*2);
						(*---------------------------------------------------------------------------
						/* Profibus old BIG/LITTLE endian InData-Array swapping
						/*-------------------------------------------------------------------------*)
						IF Para.bComm_MSB_LSB THEN
							memcpy(ADR(InDataSwap[0]), ADR(OUT_CP.InData1[0]), PROFIBUS_MAX_RECV_2SLAVES*2);
							FOR ArrayCntIn := 0 TO (PROFIBUS_MAX_RECV_2SLAVES - 1) BY 1 DO
								OUT_CP.InData1[ArrayCntIn] := swapINT(InDataSwap[ArrayCntIn]);
							END_FOR;
						END_IF;
					ELSE
						memcpy(ADR(OUT_CP.InData1[0]), ADR(InData1[0]), PROFIBUS_MAX_RECV*2);
					END_IF;

				(*-------------------------------
				/* profinet
				/*-----------------------------*)
				comPROFINET:
					IF (Para.iIdx_Comm1_type <> comNO_LINK) THEN
						memcpy(ADR(OUT_CP.InData2[0]), ADR(InData1PN[0]), PROFINET_MAX_RECV*2);
						IF Para.bComm_MSB_LSB THEN
							memcpy(ADR(InDataSwap[0]), ADR(OUT_CP.InData1[0]), PROFINET_MAX_RECV*2);
							FOR ArrayCntIn := 0 TO (PROFINET_MAX_RECV - 1) BY 1 DO
								OUT_CP.InData1[ArrayCntIn] := swapINT(InDataSwap[ArrayCntIn]);
							END_FOR;
						END_IF;
					ELSE
						memcpy(ADR(OUT_CP.InData1[0]), ADR(InData1PN[0]), PROFINET_MAX_RECV*2);
					END_IF;

			END_CASE;
		END_IF;  (* end receive data enabled? *)
	END_IF;  (* stop splitter *)
	(*---------------------------------------------------------------------------
	/* END: copying receive data from the input variables into data area
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* error handling
	/*-------------------------------------------------------------------------*)
	CASE Para.iIdx_Comm2_type OF
		(*-------------------------------
		/* no link
		/*-----------------------------*)
		comNO_LINK:
			CP2 := FALSE;     (* reset error bit *)
			RK2 := FALSE;     (* reset error bit *)

		(*-------------------------------
		/* modbus - RTU
		/*-----------------------------*)
		comMODBUS_RTU:
			IF ((MBSlave_Var[1].status <> 0) AND
			   (MBSlave_Var[1].status <> mbERR_NODE_TOUT) AND
			   (MBSlave_Var[1].status <> ERR_FUB_BUSY)) THEN
				RK2:= TRUE;     (* set error bit *)
				usStatus_RK1_RK2:= MBSlave_Var[0].status;	  (* status info for AMM *)
			ELSE
				RK2:= FALSE;     (* reset error bit *)
			END_IF;

		(*-------------------------------
		/* modbus - TCP
		/*-----------------------------*)
		comMODBUS_TCP:
			IF ((fMBTSlave2_Var.uiStatus <>0) AND
			   (fMBTSlave2_Var.uiStatus <> mbtERR_TIMEOUT) AND
			   (fMBTSlave2_Var.uiStatus <> ERR_FUB_BUSY)) THEN
				RK2:= TRUE;     (* set error bit *)
				usStatus_RK1_RK2:= fMBTSlave_Var.uiStatus;	(* status info for AMM *)
			ELSE
				RK2:= FALSE;     (* reset error bit *)
			END_IF;

		(*-------------------------------
		/* profibus DP
		/*-----------------------------*)
		comPROFIBUS_DP:
			CP2 := FALSE;     (* reset error bit *)
			RK2 := FALSE;     (* reset error bit *)

		(*-------------------------------
		/* profibus DP old
		/*-----------------------------*)
		comPROFIBUS_DPold:
			CP2 := FALSE;     (* reset error bit *)
			RK2 := FALSE;     (* reset error bit *)

		(*-------------------------------
		/* profinet
		/*-----------------------------*)
		comPROFINET:
			CP2 := FALSE;     (* reset error bit *)
			RK2 := FALSE;     (* reset error bit *)

	END_CASE;
	(*---------------------------------------------------------------------------
	/* END: error handling
	/*-------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------
/* END: coupling 2
/*----------------------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* Bus test on HMI
	/*-------------------------------------------------------------------------*)
	(* Bus coupling receive *)
	(* Dataword or register convention for start register. HMI dialog minimum and maximum limit *) 
	IF bBC_Test_Recv_DW = TRUE THEN
		MM2VIS.iBC_Test_Recv_Reg_Min := 1;
		MM2VIS.iBC_Test_Recv_Reg_Max := MAX_IN_DATA;
	ELSE
		MM2VIS.iBC_Test_Recv_Reg_Min := 0;
		MM2VIS.iBC_Test_Recv_Reg_Max := MAX_IN_DATA - 1;
	END_IF;	
		
	(* Reset register/dataword view on HMI when first register is changed *)
	iStartRecvReg := VIS2MM.iBC_Test_Recv_Start_Reg;
	VIS2MM.iBC_Test_Recv_Start_Reg := iStartRecvReg;				
	IF iStartRecvReg <> iStartRecvReg_old THEN
		iStartRecvReg_old := iStartRecvReg;
		memcpy(ADR(VIS2MM.iBC_Test_Recv_Reg[0]), ADR(InData1SW[iStartRecvReg - iBC_Test_Send_DW]), 32);
	END_IF;
				
	(* Bus coupling 1 maximum register to show on HMI screen *) 
	IF VIS2MM.bBC1_Test_Active THEN
		IF (	(Para.iIdx_Comm1_type = comPROFIBUS_DP) 
			OR 	(Para.iIdx_Comm1_type = comPROFINET) 
			OR 	(Para.iIdx_Comm1_type = comPROFIBUS_DPold)) THEN
			MM2VIS.iNumBC_Test_Recv_Reg_Max := LIMIT(1, MAX_IN_DATA - (VIS2MM.iBC_Test_Recv_Start_Reg - 1), 16);
		ELSE 
			MM2VIS.iNumBC_Test_Recv_Reg_Max := LIMIT(1, (MAX_IN_DATA - 1) - (VIS2MM.iBC_Test_Recv_Start_Reg - 1), 16);
		END_IF;
	END_IF;
						
	(* Bus coupling 2 maximum register to show on HMI screen *)
	IF VIS2MM.bBC2_Test_Active THEN
		IF (	(Para.iIdx_Comm2_type = comPROFIBUS_DP) 
			OR 	(Para.iIdx_Comm2_type = comPROFINET) 
			OR 	(Para.iIdx_Comm2_type = comPROFIBUS_DPold)) THEN
			MM2VIS.iNumBC_Test_Recv_Reg_Max := LIMIT(1, MAX_IN_DATA - (VIS2MM.iBC_Test_Recv_Start_Reg - 1), 16);
		ELSE 
			MM2VIS.iNumBC_Test_Recv_Reg_Max := LIMIT(1, (MAX_IN_DATA - 1) - (VIS2MM.iBC_Test_Recv_Start_Reg - 1), 16);
		END_IF;
	END_IF;
	
	(* Register number visibility on HMI *)
	FOR t := 0 TO 15 DO
		MM2VIS.iNumBC_Test_Recv_Reg[t] := iStartRecvReg + t;
	END_FOR;
	
	IF VIS2MM.bBC_Test_Force_Active THEN
		(* INTEGER input on HMI bustest screen, write to "InData1SW" *)
		FOR i := 0 TO 15 DO
			IF VIS2MM.iBC_Test_Recv_Reg[i] <> iBC_Test_Recv_Reg_old[iStartRecvReg - iBC_Test_Recv_DW + i] AND VIS2MM.bBC_Test_Recv_Reg_Forced[i] THEN
				memcpy(ADR(InData1SW[iStartRecvReg - iBC_Test_Recv_DW + i]), ADR(VIS2MM.iBC_Test_Recv_Reg[i]), 2); 								
				memcpy(ADR(iBC_Test_Recv_Reg_old[iStartRecvReg - iBC_Test_Recv_DW + i]), ADR(VIS2MM.iBC_Test_Recv_Reg[i]), 2);	
			END_IF;
		END_FOR;
					
		(* BOOLEAN input on HMI bustest screen, write to "InData1SW" *)
		FOR m := 0 TO (SIZEOF(VIS2MM.bBC_Test_Recv_Reg) - 20) DO
			IF (VIS2MM.bBC_Test_Recv_Reg[m] XOR bBC_Test_Recv_Reg_old[m]) THEN
				RegOffset_Recv := (m / 16);	
				srcAdr:= ADR(VIS2MM.bBC_Test_Recv_Reg[RegOffset_Recv * 16]);
				dstAdr:= ADR(InData1SW);
				idxMin:= iStartRecvReg - iBC_Test_Recv_DW + RegOffset_Recv;
				idxMax:= iStartRecvReg - iBC_Test_Recv_DW + RegOffset_Recv;
				BusTest_BOOL_TO_INT;
				memcpy(ADR(bBC_Test_Recv_Reg_old), ADR(VIS2MM.bBC_Test_Recv_Reg), SIZEOF(bBC_Test_Recv_Reg_old));
			END_IF;
		END_FOR;
					
		(* Force all *)
		IF EDGEPOS(VIS2MM.bBC_Test_Recv_Reg_AllForced) THEN
			bBC_Test_Recv_Reg_AllForced := TRUE;
		END_IF;
		IF bBC_Test_Recv_Reg_AllForced THEN													
			FOR r := 0 TO ((SIZEOF(InData1SW)/2) - 1) DO					
				bBC_Test_Recv_Reg_Forced[r] := TRUE;							
			END_FOR;
		END_IF;
	END_IF;
		
	(* Unforce all *)
	IF EDGENEG(VIS2MM.bBC_Test_Recv_Reg_AllForced) OR NOT VIS2MM.bBC_Test_Force_Active OR EDGEPOS(VIS2MM.bBC1_Test_Active) OR EDGEPOS(VIS2MM.bBC2_Test_Active) THEN
		VIS2MM.bBC_Test_Recv_Reg_AllForced := FALSE;
		bBC_Test_Recv_Reg_AllUnforced := TRUE;
	END_IF;
	IF bBC_Test_Recv_Reg_AllUnforced OR NOT VIS2MM.bBC_Test_Force_Active OR EDGEPOS(bBC_Test_Recv_DW) OR EDGENEG(bBC_Test_Recv_DW) THEN
		FOR p := 0 TO ((SIZEOF(InData1SW)/2)-1) DO
			bBC_Test_Recv_Reg_Forced[p] := FALSE;								
		END_FOR;
	END_IF;
			
	(* Force checkbox. Handle Start register change, Force all, Unforce all *)
	IF (VIS2MM.iBC_Test_Recv_Start_Reg <> iBC_Test_Recv_Start_Reg_old) OR bBC_Test_Recv_Reg_AllForced OR bBC_Test_Recv_Reg_AllUnforced THEN
		FOR b := 0 TO 15 DO
			VIS2MM.bBC_Test_Recv_Reg_Forced[b] := bBC_Test_Recv_Reg_Forced[b + iStartRecvReg - iBC_Test_Recv_DW];
		END_FOR;
		iBC_Test_Recv_Start_Reg_old := VIS2MM.iBC_Test_Recv_Start_Reg;
	END_IF;
	bBC_Test_Recv_Reg_AllUnforced 	:= FALSE;			
	bBC_Test_Recv_Reg_AllForced 	:= FALSE;	
	
	(* Force checkbox. Store state in local variable *)			
	FOR n := 0 TO 15 DO	
		IF VIS2MM.bBC_Test_Recv_Reg_Forced[n] <> bBC_Test_Recv_Reg_Forced_old[n] THEN
			IF (VIS2MM.bBC_Test_Recv_Reg_Forced[n] = TRUE) AND VIS2MM.bBC_Test_Force_Active THEN
				bBC_Test_Recv_Reg_Forced[n + iStartRecvReg - iBC_Test_Recv_DW] := TRUE;
			END_IF;
			IF (VIS2MM.bBC_Test_Recv_Reg_Forced[n] = FALSE) THEN
				bBC_Test_Recv_Reg_Forced[n + iStartRecvReg - iBC_Test_Recv_DW] := FALSE;	
			END_IF;
			bBC_Test_Recv_Reg_Forced_old[n] := VIS2MM.bBC_Test_Recv_Reg_Forced[n];
		END_IF;
	END_FOR;
			
	(* Auto toggle alive bit *)
	xTON_AutoToggle1(IN := NOT xTON_AutoToggle2.Q, PT := T#10s);
	xTON_AutoToggle2(IN :=     xTON_AutoToggle1.Q, PT := T#10s);
	IF (VIS2MM.bBC_Test_Recv_Pulse AND VIS2MM.bBC_Test_Force_Active) AND NOT (EDGEPOS(VIS2MM.bBC1_Test_Active) OR EDGEPOS(VIS2MM.bBC2_Test_Active)) THEN
		OUT_CP.InData1[0].7 := xTON_AutoToggle1.Q;
		InData1SW[0].7 		:= xTON_AutoToggle1.Q;
	ELSE
		VIS2MM.bBC_Test_Recv_Pulse := FALSE;
	END_IF;
		
	(* Custom toggle register *)
	xTON_CustomToggle1(IN := NOT xTON_CustomToggle2.Q, PT := VIS2MM.tiBC_Test_Recv_Cust1_Toggle);
	xTON_CustomToggle2(IN :=     xTON_CustomToggle1.Q, PT := VIS2MM.tiBC_Test_Recv_Cust1_Toggle);
	IF VIS2MM.bBC_Test_Recv_Cust1_Toggle AND VIS2MM.bBC_Test_Force_Active AND NOT (EDGEPOS(VIS2MM.bBC1_Test_Active) OR EDGEPOS(VIS2MM.bBC2_Test_Active)) THEN
		IF xTON_CustomToggle1.Q THEN	
			OUT_CP.InData1[VIS2MM.iBC_Test_Recv_Cust1_Toggle_Reg - iBC_Test_Recv_DW] := VIS2MM.iBC_Test_Recv_Cust1_Toggle_Val1;
		ELSE
			OUT_CP.InData1[VIS2MM.iBC_Test_Recv_Cust1_Toggle_Reg - iBC_Test_Recv_DW] := VIS2MM.iBC_Test_Recv_Cust1_Toggle_Val2;
		END_IF;
	ELSIF VIS2MM.bBC_Test_Recv_Reg_AllForced AND VIS2MM.bBC_Test_Force_Active THEN
		VIS2MM.bBC_Test_Recv_Reg_Forced[VIS2MM.iBC_Test_Recv_Cust1_Toggle_Reg] := TRUE;
	ELSE
		VIS2MM.bBC_Test_Recv_Reg_Forced[VIS2MM.iBC_Test_Recv_Cust1_Toggle_Reg] := FALSE;
		VIS2MM.bBC_Test_Recv_Cust1_Toggle := FALSE;	
	END_IF;	
	
	(* Write unforced values to modul global InData array *)
	FOR y := 0 TO ((SIZEOF(InData1)/2) - 1) DO
		IF (bBC_Test_Recv_Reg_Forced[y] = FALSE) THEN
			InData1SW[y] := OUT_CP.InData1[y];	
		END_IF;
	END_FOR;	
	(* Write forced values to modul global InData array *)
	FOR y := 0 TO ((SIZEOF(InData1)/2) - 1) DO
		IF (bBC_Test_Recv_Reg_Forced[y] = TRUE) AND NOT IN_CP.bSimWinMOD_withoutBus_Active THEN
			OUT_CP.InData1[y] := InData1SW[y];	
		END_IF;
	END_FOR;
	
	(* Forced register, write latest value to HMI Bool buttons *)
	FOR v := 0 TO 15 DO	
		IF VIS2MM.bBC_Test_Recv_Reg_Forced[v] THEN
			dstAdr:= ADR(VIS2MM.bBC_Test_Recv_Reg);					
			srcAdr:= ADR(OUT_CP.InData1[0]);
			idxMin:= iStartRecvReg - iBC_Test_Recv_DW;
			idxMax:= iStartRecvReg - iBC_Test_Recv_DW + 16;
			BusTest_INT_TO_BOOL;				
		END_IF;
	END_FOR;
	
	(* Forced register, write latest value to HMI Word/Integer field *)
	memcpy(ADR(VIS2MM.iBC_Test_Recv_Reg[0]), ADR(OUT_CP.InData1[iStartRecvReg - iBC_Test_Recv_DW]), 32);	
		
	(* Unforced register, write latest value to HMI Bool buttons *)
	FOR w := 0 TO 15 DO	
		IF NOT VIS2MM.bBC_Test_Recv_Reg_Forced[w] THEN
			dstAdr:= ADR(VIS2MM.bBC_Test_Recv_Reg);					
			srcAdr:= ADR(InData1SW[0]);
			idxMin:= iStartRecvReg - iBC_Test_Recv_DW;
			idxMax:= iStartRecvReg - iBC_Test_Recv_DW + 16;
			BusTest_INT_TO_BOOL;
		END_IF;
	END_FOR;
	
	(* Unforced register, write latest value to HMI Word/Integer field *)
	memcpy(ADR(VIS2MM.iBC_Test_Recv_Reg[0]), ADR(InData1SW[iStartRecvReg - iBC_Test_Recv_DW]), 32);

	(*---------------------------------------------------------------------------
	/* END: Bus test on HMI
	/*-------------------------------------------------------------------------*)

	(*---------------------------------------------------------------------------
	/* Bus diagnosis on HMI
	/*-------------------------------------------------------------------------*)
	(*-------------------------------
	/* Profibus DP
	/*-----------------------------*)
	MM2VIS.bBC_PB1_SlaveAdr := (nxdpsSetAdr_01.status = 65534);
	MM2VIS.iBC_PB1_SlaveAdr := nxdpsSetAdr_01.address;
	MM2VIS.iBC_PB1_SlaveAdr_Status := nxdpsSetAdr_01.status;
	MM2VIS.bBC_PB1_Open := (nxdpsStartBusComm_01.status = 65534);
	MM2VIS.iBC_PB1_Open_Status:= nxdpsStartBusComm_01.status;
	MM2VIS.iBC_PB1_Comm_ChangeState;	(* see X20IF1063_1_P17_01b *)
	MM2VIS.iBC_PB1_Comm_State;			(* see X20IF1063_1_P17_01b *)
	MM2VIS.iBC_PB1_Comm_Error; 			(* see X20IF1063_1_P17_01b *)
	MM2VIS.iCnt_BC_PB1_Comm_Error; 		(* see X20IF1063_1_P17_01b *)

	MM2VIS.bBC_PB2_SlaveAdr := (nxdpsSetAdr_02.status = 65534);
	MM2VIS.iBC_PB2_SlaveAdr := nxdpsSetAdr_02.address;
	MM2VIS.iBC_PB2_SlaveAdr_Status := nxdpsSetAdr_02.status;
	MM2VIS.bBC_PB2_Open := (nxdpsStartBusComm_02.status = 65534);
	MM2VIS.iBC_PB2_Open_Status := nxdpsStartBusComm_01.status;
	MM2VIS.iBC_PB2_Comm_ChangeState;	(* see X20IF1063_1_P17_01c *)
	MM2VIS.iBC_PB2_Comm_State;			(* see X20IF1063_1_P17_01c *)
	MM2VIS.iBC_PB2_Comm_Error; 			(* see X20IF1063_1_P17_01c *)
	MM2VIS.iCnt_BC_PB2_Comm_Error; 		(* see X20IF1063_1_P17_01c *)

	(*-------------------------------
	/* Profinet
	/*-----------------------------*)
	MM2VIS.bBC_PN1_SlaveAdr	:= (nxpnsSetName_01.status = 65534);
	MM2VIS.sBC_PN1_SlaveAdr	:= StationName1;
	MM2VIS.iBC_PN1_SlaveAdr_Status := nxpnsSetName_01.status;
	MM2VIS.bBC_PN1_Open	:= (nxpnsStartBusComm_01.status = 65534);
	MM2VIS.iBC_PN1_Open_Status := nxpnsStartBusComm_01.status;
	MM2VIS.iBC_PN1_Comm_ChangeState;	(* see X20IF10E3_1_P18_01b *)
	MM2VIS.iBC_PN1_Comm_State;			(* see X20IF10E3_1_P18_01b *)
	MM2VIS.iBC_PN1_Comm_Error;			(* see X20IF10E3_1_P18_01b *)	
	MM2VIS.iCnt_BC_PN1_Comm_Error;		(* see X20IF10E3_1_P18_01b *)	

	(*-------------------------------
	/* Modbus RTU
	/*-----------------------------*)
	IF (Para.iIdx_Comm1_type = comMODBUS_RTU) THEN
		MM2VIS.bBC_MBRTU_Open :=		MBSOpen_Var[0].status = 0;
		MM2VIS.iBC_MBRTU_Open_Status := MBSOpen_Var[0].status;
		MM2VIS.iBC_MBRTU_SlaveID := MBSOpen_Var[0].own_ID;
		MM2VIS.sBC_MBRTU_Comm_Para := szMode1;	
		MM2VIS.iBC_MBRTU_Comm_Status := MBSlave_Var[0].status;
		MM2VIS.iCnt_BC_MBRTU_SendRecv:= MBSlave_Var[0].exec;   	
	END_IF;
	IF (Para.iIdx_Comm2_type = comMODBUS_RTU) THEN
		MM2VIS.bBC_MBRTU_Open :=		MBSOpen_Var[1].status = 0;
		MM2VIS.iBC_MBRTU_Open_Status := MBSOpen_Var[1].status;
		MM2VIS.iBC_MBRTU_SlaveID := MBSOpen_Var[1].own_ID;
		MM2VIS.sBC_MBRTU_Comm_Para := szMode1;
		MM2VIS.iBC_MBRTU_Comm_Status := MBSlave_Var[1].status;
		MM2VIS.iCnt_BC_MBRTU_SendRecv:= MBSlave_Var[1].exec;   	
	END_IF;

	(*-------------------------------
	/* Modbus TCP
	/*-----------------------------*)
	IF (Para.iIdx_Comm1_type = comMODBUS_TCP) THEN (* Coupling 1 *)
		MM2VIS.bBC_MBTCP_IPadr				:= 		(CfgSetIPAddr_01.status = 65534);
		MM2VIS.iBC_MBTCP_IPadr_Status		:= 		CfgSetIPAddr_01.status;
		MM2VIS.sBC_MBTCP_IPadr				:= 		szComm_IPaddr_TCP;
		MM2VIS.bBC_MBTCP_SubMask			:= 		(CfgSetSubnetMask_01.status = 65534) AND (IP_ModTCP <> 5);
		MM2VIS.iBC_MBTCP_SubMask_Status		:= 		CfgSetSubnetMask_01.status;
		MM2VIS.sBC_MBTCP_SubMask			:= 		szComm_SubMask_TCP;
		MM2VIS.bBC_MBTCP_Open				:= 		(fMBTSOpen_Var.uiStatus = 0) AND MM2VIS.bBC_MBTCP_SubMask AND MM2VIS.bBC_MBTCP_IPadr AND (IP_ModTCP <> 5);
		MM2VIS.iBC_MBTCP_Open_Status		:= 		fMBTSOpen_Var.uiStatus;
		MM2VIS.iNum_BC_MBTCP_Client			:= 		fMBTSlave_Var.usiClientNbr;
		MM2VIS.iNum_BC_MBTCP_ClientServed	:= 		fMBTSlave_Var.usiClientServed;
		MM2VIS.tiBC_MBTCP_RecvElapsed		:=		fMBTSlave_Var.tiRecvElapsed;
		MM2VIS.sBC_MBTCP_Client_IPaddr		:=		fMBTSlave_Var.usiClientIP;
		MM2VIS.iBC_MBTCP_FunctionCode		:=		fMBTSlave_Var.usiMBFuncCode;
		MM2VIS.sBC_MBTCP_Slave_Debug		:=		fMBTSlave_Var.szMsg;
		MM2VIS.iBC_MBTCP_Slave_Status		:=		fMBTSlave_Var.stTcpServerStatus;	
		MM2VIS.iCnt_BC_MBTCP_Recv			:=		fMBTSlave_Var.udiRecvCnt;
		MM2VIS.iCnt_BC_MBTCP_Send			:=		fMBTSlave_Var.udiSendCnt;
		MM2VIS.iBC_MBTCP_PortOpenRetries	:=		fMBTSlave_Var.usiOpenRetries;
		MM2VIS.iBC_MBTCP_FuB_Step			:=		fMBTSlave_Var.uiStep;
		MM2VIS.iBC_MBTCP_FuB_Status			:=		fMBTSlave_Var.uiStatus;
		MM2VIS.iBC_MBTCP_Client1_Port		:=		fMBTSlave_Var.CltInfo[0].usiPort;
		MM2VIS.sBC_MBTCP_Client1_IPaddr		:=		fMBTSlave_Var.CltInfo[0].szIp_addr;
		MM2VIS.sBC_MBTCP_Client1_Msg		:=		fMBTSlave_Var.CltInfo[0].szMsg;
		MM2VIS.iBC_MBTCP_Client2_Port		:=		fMBTSlave_Var.CltInfo[1].usiPort;
		MM2VIS.sBC_MBTCP_Client2_IPaddr		:=		fMBTSlave_Var.CltInfo[1].szIp_addr;
		MM2VIS.sBC_MBTCP_Client2_Msg		:=		fMBTSlave_Var.CltInfo[1].szMsg;
		MM2VIS.iBC_MBTCP_Client3_Port		:=		fMBTSlave_Var.CltInfo[2].usiPort;
		MM2VIS.sBC_MBTCP_Client3_IPaddr		:=		fMBTSlave_Var.CltInfo[2].szIp_addr;
		MM2VIS.sBC_MBTCP_Client3_Msg		:=		fMBTSlave_Var.CltInfo[2].szMsg;
		MM2VIS.iBC_MBTCP_Client4_Port		:=		fMBTSlave_Var.CltInfo[3].usiPort;
		MM2VIS.sBC_MBTCP_Client4_IPaddr		:=		fMBTSlave_Var.CltInfo[3].szIp_addr;
		MM2VIS.sBC_MBTCP_Client4_Msg		:=		fMBTSlave_Var.CltInfo[3].szMsg;
		MM2VIS.iBC_MBTCP_Client5_Port		:=		fMBTSlave_Var.CltInfo[4].usiPort;
		MM2VIS.sBC_MBTCP_Client5_IPaddr		:=		fMBTSlave_Var.CltInfo[4].szIp_addr;
		MM2VIS.sBC_MBTCP_Client5_Msg		:=		fMBTSlave_Var.CltInfo[4].szMsg;
	END_IF;
	IF (Para.iIdx_Comm2_type = comMODBUS_TCP) THEN (* Coupling 2 *)
		MM2VIS.bBC_MBTCP2_IPadr				:= 		(CfgSetIPAddr_02.status = 65534);
		MM2VIS.iBC_MBTCP2_IPadr_Status		:= 		CfgSetIPAddr_02.status;
		MM2VIS.sBC_MBTCP2_IPadr				:= 		szComm2_IPaddr_TCP;
		MM2VIS.bBC_MBTCP2_SubMask			:= 		(CfgSetSubnetMask_02.status = 65534) AND (IP_ModTCP2 <> 5);
		MM2VIS.iBC_MBTCP2_SubMask_Status	:= 		CfgSetSubnetMask_02.status;
		MM2VIS.sBC_MBTCP2_SubMask			:= 		szComm2_SubMask_TCP;
		MM2VIS.bBC_MBTCP2_Open				:= 		(fMBTSOpen2_Var.uiStatus = 0) AND 
													MM2VIS.bBC_MBTCP2_SubMask AND 
													MM2VIS.bBC_MBTCP2_IPadr AND 
													(IP_ModTCP2 <> 5);
		MM2VIS.iBC_MBTCP2_Open_Status		:= 		fMBTSOpen2_Var.uiStatus;
		MM2VIS.iNum_BC_MBTCP2_Client		:= 		fMBTSlave2_Var.usiClientNbr;
		MM2VIS.iNum_BC_MBTCP2_ClientServed	:= 		fMBTSlave2_Var.usiClientServed;
		MM2VIS.tiBC_MBTCP2_RecvElapsed		:=		fMBTSlave2_Var.tiRecvElapsed;
		MM2VIS.sBC_MBTCP2_Client_IPaddr		:=		fMBTSlave2_Var.usiClientIP;
		MM2VIS.iBC_MBTCP2_FunctionCode		:=		fMBTSlave2_Var.usiMBFuncCode;
		MM2VIS.sBC_MBTCP2_Slave_Debug		:=		fMBTSlave2_Var.szMsg;
		MM2VIS.iBC_MBTCP2_Slave_Status		:=		fMBTSlave2_Var.stTcpServerStatus;	
		MM2VIS.iCnt_BC_MBTCP2_Recv			:=		fMBTSlave2_Var.udiRecvCnt;
		MM2VIS.iCnt_BC_MBTCP2_Send			:=		fMBTSlave2_Var.udiSendCnt;
		MM2VIS.iBC_MBTCP2_PortOpenRetries	:=		fMBTSlave2_Var.usiOpenRetries;
		MM2VIS.iBC_MBTCP2_FuB_Step			:=		fMBTSlave2_Var.uiStep;
		MM2VIS.iBC_MBTCP2_FuB_Status		:=		fMBTSlave2_Var.uiStatus;
		MM2VIS.iBC_MBTCP2_Client1_Port		:=		fMBTSlave2_Var.CltInfo[0].usiPort;
		MM2VIS.sBC_MBTCP2_Client1_IPaddr	:=		fMBTSlave2_Var.CltInfo[0].szIp_addr;
		MM2VIS.sBC_MBTCP2_Client1_Msg		:=		fMBTSlave2_Var.CltInfo[0].szMsg;
		MM2VIS.iBC_MBTCP2_Client2_Port		:=		fMBTSlave2_Var.CltInfo[1].usiPort;
		MM2VIS.sBC_MBTCP2_Client2_IPaddr	:=		fMBTSlave2_Var.CltInfo[1].szIp_addr;
		MM2VIS.sBC_MBTCP2_Client2_Msg		:=		fMBTSlave2_Var.CltInfo[1].szMsg;
		MM2VIS.iBC_MBTCP2_Client3_Port		:=		fMBTSlave2_Var.CltInfo[2].usiPort;
		MM2VIS.sBC_MBTCP2_Client3_IPaddr	:=		fMBTSlave2_Var.CltInfo[2].szIp_addr;
		MM2VIS.sBC_MBTCP2_Client3_Msg		:=		fMBTSlave2_Var.CltInfo[2].szMsg;
		MM2VIS.iBC_MBTCP2_Client4_Port		:=		fMBTSlave2_Var.CltInfo[3].usiPort;
		MM2VIS.sBC_MBTCP2_Client4_IPaddr	:=		fMBTSlave2_Var.CltInfo[3].szIp_addr;
		MM2VIS.sBC_MBTCP2_Client4_Msg		:=		fMBTSlave2_Var.CltInfo[3].szMsg;
		MM2VIS.iBC_MBTCP2_Client5_Port		:=		fMBTSlave2_Var.CltInfo[4].usiPort;
		MM2VIS.sBC_MBTCP2_Client5_IPaddr	:=		fMBTSlave2_Var.CltInfo[4].szIp_addr;
		MM2VIS.sBC_MBTCP2_Client5_Msg		:=		fMBTSlave2_Var.CltInfo[4].szMsg;
	END_IF;
	(*---------------------------------------------------------------------------
	/* END: Bus diagnosis on HMI
	/*-------------------------------------------------------------------------*)

	IF ucTeilerLauf > ucTeiler THEN
		ucTeilerLauf:= 0;
	END_IF;
	ucTeilerLauf:= ucTeilerLauf + 1;                  

END_PROGRAM
