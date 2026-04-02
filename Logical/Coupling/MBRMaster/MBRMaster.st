(*******************************************************************************
Coupling:    Modbus RTU Master

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V04.05.00	22.07.2017	Denk		new 
V04.12.00	29.03.2023	Denk		Device adress changed  	

Instructions for use:
--------------------
Modbus RTU Master <--> SCR HUG Smart Dosing Box Slave
SCR logic in Emission module
Possible Slave#2 prepared

Outstandings:
------------


(*******************************************************************************)

PROGRAM _INIT

	(* EDIT: Adress *)	
	device:= 'SL2.IF1.ST66.IF1.ST2.IF1';
	
	(* EDIT: PHY = Physical | PA = Parity | SB = Stopbit | BD = Baudrate *)
	mode:= '/PHY=RS485 /PA=N /DB=8 /SB=1 /BD=9600';						

	(* EDIT: Config file for slave adress,register, function code, ... *)
	config:= 'cfg_mbus';
	
	timeout:= 300;

	stepMbMaster:= stpMbM_WAIT;
	cmdMbMOpen:= TRUE;	

	(* EDIT: IN/OUT data register *)
	MBM_SCR_Register[0];				(* Slave SCR *)
//	MBM_FieldDevice1_Register[0];		(* Slave 2, CEMS*)

	
	(* EDIT: IN/OUT data interfaces *)
	OUT_CP.iModbus_SCR_UINT;			(* Slave SCR *)
	OUT_CP.iModbus_SCR_INT;		 		(* Slave SCR, for INT register 73,74,75*)
	IN_CP.iModbus_SCR;					(* Slave SCR *)
//	OUT_CP.iMBM_FieldDevice1_Receive;	(* Slave 2, CEMS *)
//	IN_CP.iMBM_FieldDevice1_Send;		(* Slave 2, CEMS *)	

END_PROGRAM


PROGRAM _CYCLIC
IF ucTeilerLauf > ucTeilerMaster THEN
	CASE stepMbMaster OF
	  (*----------------------------------------------------------
	  /* wait
	  /*---------------------------------------------------------*)  
		stpMbM_WAIT:
			IF cmdMbMOpen THEN
				cmdMbMOpen:= FALSE;
				stepMbMaster:= stpMbM_OPEN;
			END_IF;

	  (*----------------------------------------------------------
	  /* open device
	  /*---------------------------------------------------------*)  
		stpMbM_OPEN:
			MBMOpen_0.enable:= TRUE;
			MBMOpen_0.pDevice:= ADR(device);
			MBMOpen_0.pMode:= ADR(mode);
			MBMOpen_0.pConfig:= ADR(config);
			MBMOpen_0.timeout:= timeout;
			MBMOpen_0.ascii:= 0;
			MBMOpen_0();
			IF (MBMOpen_0.status <> ERR_FUB_BUSY) THEN
				IF (MBMOpen_0.status = ERR_OK) THEN
					MBMaster_0.enable:= TRUE;
					MBMaster_0.ident:= MBMOpen_0.ident;
					stepMbMaster:= stpMbM_RUN;
				ELSE
					stepMbMaster:= stpMbM_ERROR;
				END_IF;
			END_IF;

	  (*----------------------------------------------------------
	  /* run master
	  /*---------------------------------------------------------*)  
		stpMbM_RUN:
			IF cmdMbMClose THEN
				cmdMbMClose:= FALSE;
				MBMaster_0.enable:= FALSE;
				MBMClose_0.enable:= TRUE;
				MBMClose_0.ident:= MBMOpen_0.ident;
				stepMbMaster:= stpMbM_CLOSE;
			END_IF;

			MBMaster_0();
			
			(* Slave SCR *)
			memcpy(ADR(MBM_SCR_Register_swapped[65]), ADR(MBM_SCR_Register[65]), 16);	 		//Register Offset Anpassung hier: MBM_SCR_Register[xx]
			FOR ArrayCntOut := 65 TO 69 BY 1 DO
				OUT_CP.iModbus_SCR_UINT[ArrayCntOut] := (*swapINT*)(MBM_SCR_Register_swapped[ArrayCntOut]);	
			END_FOR;
			FOR ArrayCntOut := 70 TO 72 BY 1 DO
				OUT_CP.iModbus_SCR_UINT[ArrayCntOut] := (*swapINT*)(MBM_SCR_Register_swapped[ArrayCntOut]);	
			END_FOR;
						
			memcpy(ADR(MBM_SCR_Register_swapped73[73]), ADR(MBM_SCR_Register[73]), 6);			
			FOR ArrayCntOut := 73 TO 75 BY 1 DO
				OUT_CP.iModbus_SCR_INT[ArrayCntOut] := (*swapINT*)(MBM_SCR_Register_swapped73[ArrayCntOut]);	
			END_FOR;
			
			memcpy(ADR(MBM_SCR_Register_swapped[76]), ADR(MBM_SCR_Register[76]), 18);			
			FOR ArrayCntOut := 76 TO 84 BY 1 DO
				OUT_CP.iModbus_SCR_UINT[ArrayCntOut] := (*swapINT*)(MBM_SCR_Register_swapped[ArrayCntOut]);	
			END_FOR;
				
			memcpy(ADR(MBM_SCR_Register_swapped[1]), ADR(IN_CP.iModbus_SCR[1]), 1);
			FOR ArrayCntIn := 1 TO 1 BY 1 DO
				MBM_SCR_Register[ArrayCntIn] := (*swapINT*)(MBM_SCR_Register_swapped[ArrayCntIn]);		
			END_FOR;
			
			memcpy(ADR(MBM_SCR_Register_swapped[2]), ADR(IN_CP.iModbus_SCR[2]), 19);
			FOR ArrayCntIn := 2 TO 20 BY 1 DO
				MBM_SCR_Register[ArrayCntIn] := (*swapINT*)(MBM_SCR_Register_swapped[ArrayCntIn]);
			END_FOR;
			
//			(* Slave 2, CEMS *)
//			memcpy(ADR(OUT_CP.iMBM_FieldDevice1_Receive[0]), ADR(MBM_FieldDevice1_Register[0]), MODBUS_RTU_MASTER_MAX_ARRAY);
//			memcpy(ADR(MBM_FieldDevice1_Register[200]), ADR(IN_CP.iMBM_FieldDevice1_Send[0]), MODBUS_RTU_MASTER_MAX_ARRAY);

			
			(* cyclic read and write *)
			(* function code 03 read holding registers *)
			(* function code 16 write multiple registers *)
			(* Slave SCR *)
			IF Para.bSCR_BUS_Exist THEN			
				EvReadMBR_SCR := TRUE;
			END_IF;
			IF Para.bSCR_BUS_Exist THEN		
				EvWriteMBR_SCR := TRUE;
			END_IF;
				
//			(* Slave 2, CEMS *)
//			IF (EvReadMBR_4_1_1 = FALSE) THEN		
//				EvReadMBR_4_1_1 := TRUE;
//			END_IF;
//			IF (EvWriteMBR_4_1 = FALSE) THEN	
//				EvWriteMBR_4_1 := TRUE;
//			END_IF;
		
	  (*----------------------------------------------------------
	  /* close device
	  /*---------------------------------------------------------*)  
		stpMbM_CLOSE:
			MBMClose_0();
			IF (MBMClose_0.status <> ERR_FUB_BUSY) THEN
				IF (MBMClose_0.status = ERR_OK) THEN
					stepMbMaster:= stpMbM_WAIT;
				ELSE
					stepMbMaster:= stpMbM_ERROR;
				END_IF;
			END_IF;

	  (*----------------------------------------------------------
	  /* error
	  /*---------------------------------------------------------*)  
		stpMbM_ERROR:
			IF cmdMbMQuitError THEN
				cmdMbMQuitError:= FALSE;
				stepMbMaster:= stpMbM_WAIT;
			END_IF;

	END_CASE;
		
END_IF;

IF ucTeilerLauf > ucTeilerMaster THEN
	ucTeilerLauf:= 0;
END_IF;
ucTeilerLauf:= ucTeilerLauf + 1;
	
END_PROGRAM
