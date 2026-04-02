(*******************************************************************************
AGGR: intiate CAN communication (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2024

Customized modifications: -
------------------------
 
History:
-------
V0.1	31-08-2001	Fahringer,	generated from caninit.c V0.2
		31-08-2001	Fahringer,	last modification	
V0.21	14-10-2003	Weitzer,	transfer all CAN and CMS FUBs to caninit task
V0.40	14-02-2007  Weitzer,	change to new standard IF (SL1.SS1.IF2)
								delete MMD (multimeasure device)
V0.50	07-09-2007	Weitzer		SAFI added
								main FUB´s moved to canmain program
V0.60	23-02-2010	Weitzer,	SAFI2 (prot injection) added
V3.99.0	07-05-2012	Weitzer		generated for modular software								   
V4.00	14-02-2014	Weitzer,	change version number
V4.10	03-11-2020	Schmid,		engine CAN node position on node P10 as option (Aggreko standard)
V4.11	07-12-2021	Schmid,		flexible CAN interface detection
		22-12-2021	Andre,		avoid potential array index overrun
V4.12	23-02-2023	Weitzer,	add IGN2 CAN interface
V4.22	18-10-2023	Perktold,	added X20CP368xX CAN interfaces
V4.13	17-10-2023	Andre,		Only perform ARwin warm start if the CAN bus off state cannot be quit
V4.14	28-10-2024	Kafka,		SAFI / KLS21 devices of bank B use 2nd card and the rest use 1st one
							   
Instructions for use:
--------------------
-initiate the CAN-Bus communictation controller
-initiate CAN CMS manager

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC
	
	
	(* Dsiplay hardware path of CAN interface _IF1 *)
	
	IF MM2VIS.iCAN_HW_Slot = 0 AND IN_HA.tPB2MM.bParaSetupOk THEN

		IF LEFT(sModSlotSel[iIdxCAN_IGN],3) = LEFT(MM2VIS.sCAN_HW_Slot_X20CP368xX,3) THEN
			IF xEngType.Type9 THEN	(* B&R X20CP368xX J920 *)
				MM2VIS.iCAN_HW_Slot :=	9;
				strcpy(ADR(MM2VIS.sCAN_HW_Slot_X20CP368xX_J920), ADR(sModSlotSel[iIdxCAN_IGN]));
			ELSE					(* B&R X20CP368xX *)
				MM2VIS.iCAN_HW_Slot :=	8;
				strcpy(ADR(MM2VIS.sCAN_HW_Slot_X20CP368xX), ADR(sModSlotSel[iIdxCAN_IGN]));
			END_IF;
		
		ELSIF LEFT(sModSlotSel[iIdxCAN_IGN],3) = LEFT(MM2VIS.sCAN_HW_Slot_IPC_3100,3) THEN
			IF xEngType.Type9 THEN	(* B&R PPC3100 J920 *)
				MM2VIS.iCAN_HW_Slot :=	7;
				strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_3100_J920), ADR(sModSlotSel[iIdxCAN_IGN]));
			ELSE					(* B&R PPC3100 *)
				MM2VIS.iCAN_HW_Slot :=	6;
				strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_3100), ADR(sModSlotSel[iIdxCAN_IGN]));
			END_IF;
			
		ELSIF	LEFT(sModSlotSel[iIdxCAN_IGN],3) = LEFT(MM2VIS.sCAN_HW_Slot_IPC,3) THEN
			IF xEngType.Type9 THEN	(* B&R PPC900 J920 *)
				MM2VIS.iCAN_HW_Slot :=	4;
				strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_J920), ADR(sModSlotSel[iIdxCAN_IGN]));
			ELSE					(* B&R PPC900 *)
				MM2VIS.iCAN_HW_Slot :=	1;
				strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC), ADR(sModSlotSel[iIdxCAN_IGN]));
			END_IF;
			
		ELSIF	LEFT(sModSlotSel[iIdxCAN_IGN],3) = LEFT(MM2VIS.sCAN_HW_Slot_IPC_GE_IP,3) THEN
			IF xEngType.Type9 THEN	(* GE IPC J920 *)
				MM2VIS.iCAN_HW_Slot :=	5;
				strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_GE_IP_J920), ADR(sModSlotSel[iIdxCAN_IGN]));
			ELSE					(* GE IPC *)
				MM2VIS.iCAN_HW_Slot :=	3;
				strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_GE_IP), ADR(sModSlotSel[iIdxCAN_IGN]));
			END_IF;
			
		ELSIF	LEFT(sModSlotSel[iIdxCAN_IGN],3) = LEFT(MM2VIS.sCAN_HW_Slot_IPC_CMaU,3) THEN
			(* B&R IPC CM&U *)
			MM2VIS.iCAN_HW_Slot	:=	2;
			strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_CMaU), ADR(sModSlotSel[iIdxCAN_IGN]));
			
		ELSIF LEN(sModSlotSel[iIdxCAN_IGN]) > 0 THEN
			(* default: B&R PPC3100 *)
			MM2VIS.iCAN_HW_Slot :=	6;
			strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_3100),	ADR(sModSlotSel[iIdxCAN_IGN]));
		END_IF;

	END_IF;
	
		
	(* cyclic call of CAN devices  *)
	
	IF CMSinit_Init.cms_ident <> 0 THEN		(* check if CMS init was successful *)
			
		IF IN_HA.tICxx_CanGo.ECANDevGo <> 0 THEN
			IF CANDevGo_InBuffer[IN_HA.tICxx_CanGo.CANDevGo[1]].ECANDevGo = 0 THEN
				CANDevGo_InBuffer[IN_HA.tICxx_CanGo.CANDevGo[1]] := IN_HA.tICxx_CanGo;
			END_IF;				
		END_IF;
		
		IF IN_HA.tMonic_CanGo.ECANDevGo <> 0 THEN
			IF CANDevGo_InBuffer[IN_HA.tMonic_CanGo.CANDevGo[1]].ECANDevGo = 0 THEN
				CANDevGo_InBuffer[IN_HA.tMonic_CanGo.CANDevGo[1]] := IN_HA.tMonic_CanGo;
			END_IF;	
		END_IF;
		
		IF IN_HA.tSAFI_CanGo.ECANDevGo <> 0 THEN
			IF CANDevGo_InBuffer[IN_HA.tSAFI_CanGo.CANDevGo[1]].ECANDevGo = 0 THEN
				CANDevGo_InBuffer[IN_HA.tSAFI_CanGo.CANDevGo[1]] := IN_HA.tSAFI_CanGo;
			END_IF;	
		END_IF;
		
		IF IN_HA.tKLS98_CanGo.ECANDevGo <> 0 THEN
			IF CANDevGo_InBuffer[IN_HA.tKLS98_CanGo.CANDevGo[1]].ECANDevGo = 0 THEN
				CANDevGo_InBuffer[IN_HA.tKLS98_CanGo.CANDevGo[1]] := IN_HA.tKLS98_CanGo;
			END_IF;	
		END_IF;

//		Not used at the moment		
//		IF IN_HA.tGasMeteringUnit_CanGo.ECANDevGo <> 0 THEN
//			CANDevGo_InBuffer[IN_HA.tGasMeteringUnit_CanGo.CANDevGo[1]] := IN_HA.tGasMeteringUnit_CanGo;
//		END_IF;
		
		FOR ucDevSequencer := 1 TO 32 DO

			IF CANDevGo_InBuffer[ucDevSequencer].ECANDevGo = 128 THEN
				CANDevGo_InBuffer[ucDevSequencer].ECANDevGo := 0;
				IF ucDevSequencer < 32 THEN
					ucDevSequencer := ucDevSequencer + 1;
				END_IF;
			END_IF;	
						
			IF CANDevGo_InBuffer[ucDevSequencer].ECANDevGo = 64 THEN
				IF ECANDevGo = 0 THEN
					CANDevGo_InBuffer[ucDevSequencer].ECANDevGo := 0;
					IF ucDevSequencer < 32 THEN
						ucDevSequencer := ucDevSequencer + 1;
					END_IF;
				ELSE
					CANDevGo_InBuffer[ucDevSequencer].ECANDevGo := 128;	
				END_IF;
			END_IF;			
						
			IF CANDevGo_InBuffer[ucDevSequencer].ECANDevGo = 1 THEN
				CANDevGo[0] := CANDevGo_InBuffer[ucDevSequencer].CANDevGo[0];
				CANDevGo[1] := ucDevSequencer;
				ECANDevGo   := 1;
				(* If only one CAN bus card was detected, all devices use it *)
				IF OUT_HA.iCANIdentIGN2 = 0 THEN
					CMSmain_Init; 		(* Cyclic starting of the CAN-manager to intitiate CAN-devices *)
				(* If 2 CAN bus cards were detected AND SAFI is active AND PI AND ignition are active, SAFI / KLS21 devices of bank B use 2nd card and the rest use 1st one *)
				ELSIF Para.bSA_Active AND Para.bSA_Ign_Active AND Para.bSA_PI_Active THEN
					IF ucDevSequencer > (9 + xEngType.NumberOfCylinder / 4) AND ucDevSequencer < (10 + xEngType.NumberOfCylinder / 2) THEN
						CMSmain_Init2; 	(* Cyclic starting of the CAN-manager to intitiate CAN-devices of 2nd CAN card *)
					ELSE
						CMSmain_Init; 	(* Cyclic starting of the CAN-manager to intitiate CAN-devices *)
					END_IF;
				(* Else all SAFI / KLS21 use the 2nd CAN bus card and the rest use the 1st one *)
				ELSE
					IF ucDevSequencer > 9 AND ucDevSequencer < 22 THEN
						CMSmain_Init2; 	(* Cyclic starting of the CAN-manager to intitiate CAN-devices of 2nd CAN card *)
					ELSE
						CMSmain_Init; 	(* Cyclic starting of the CAN-manager to intitiate CAN-devices *)
					END_IF;
				END_IF;
				CANDevGo_InBuffer[ucDevSequencer].ECANDevGo := 64;
				EXIT;
			END_IF;	
		
		END_FOR;
		
	
		(* Copy feedback info to Out structure *)
		OUT_HA.iECanDevGo := ECANDevGo;
		
	END_IF;
	
	(* Check if CAN card started without bus off issue - if so, try to quit it. If not possible, a warm start of system is executed. *)
	xTON_SysRun(IN := TRUE, PT := T#1m);
	xTON_CANbusoff(IN := ((bCANbusoff AND bQuitCANbusoff) OR (bCANbusoff2 AND bQuitCANbusoff2)), PT := T#1s);
	IF NOT xTON_SysRun.Q THEN (* Only check during the first minute after PLC start *)
		IF bCANbusoff THEN
			bQuitCANbusoff := TRUE;
		END_IF;
		IF bCANbusoff2 THEN
			bQuitCANbusoff2 := TRUE;
		END_IF;
		IF xTON_CANbusoff.Q THEN
			SYSreset(1, 1);
		END_IF;
	END_IF;

END_PROGRAM

PROGRAM _EXIT

	(* RESET CMS TABELS *)
	CMSexit_Init(enable := TRUE, cms_ident := CMSmain_Init.cms_ident);
	CMSexit_Init(enable := TRUE, cms_ident := CMSmain_Init2.cms_ident);
	
END_PROGRAM