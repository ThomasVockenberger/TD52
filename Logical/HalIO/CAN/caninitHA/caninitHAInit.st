(*******************************************************************************
AGGR: intiate CAN communication (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V0.1	31-08-2001	Fahringer,	generated from caninit.c V0.2
		31-08-2001	Fahringer,	last modification	
V0.21	14-10-2003	Weitzer,	transfer all CAN and CMS FUBs to caninit task
V0.40	14-02-2007  Weitzer,	change to new standard IF (SL1.SS1.IF2)
								delete MMD (multimeasure device)
V0.50	07-09-2007	Weitzer,	SAFI added
								main FUB´s moved to canmain program
V9.99	22-10-2007	Tinello,	Anpassung Device auf SL1.SS1.IF1
								MMDSynch
V0.60	23-02-2010	Weitzer,	SAFI2 (prot injection) added
		25-06-2010	Weitzer,	activate IF787 CAN interface, if IF787 is not available
V3.99.0	07-05-2012	Weitzer,	generated for modular software																   							   
V4.00	14-02-2014	Weitzer,	change version number
V4.03	17-03-2015	Weitzer,	add CAN open fub for J920 interface card
		22-10-2015	Weitzer,	add CAN open fub for B&R IPC hardware
V4.05	27.07.2017	Messner,	CAN Diagnosis Picture added
V4.06	18.09.2018	Denk,		don't execute task if ARsim is active
V4.08	07.02.2019	Schmid,		B&R IPC PPC3100 adaptations (PLC address for CAN device changed)
V4.10	03.11.2020	Schmid,		engine CAN node position on node P10 as option (Aggreko standard)
V4.11	07.12.2021	Schmid,		flexible CAN interface detection
V4.12	24.02.2023	Weitzer,	add IGN2 CAN interface
V4.13	17.10.2023	Andre,		moved CANbusoff check in the cyclic taks
V4.14	18.06.2024	Soto,		added CAN interface for Low NOx sensor IF3 (2023-183)
							   
Instructions for use:
--------------------
-initiate the CAN-Bus communictation controller
-initiate CAN CMS manager

Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT

	(* Don't execute task if ARsim is active *)
	IF DiagCpuIsSimulated() THEN
		strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC), ADR('Simulation active'));		(* If ARsim is active, then it's shown in CAN diagnosis picture on HMI *)
		RETURN;
	END_IF;
	
	
	(*============ GATHER CAN INTERFACE INFORMATION =============*)
	(* ********************************************************* *)
	(*	reset variables											 *)
	(* ********************************************************* *)		
	memset(ADR(sLabelInfo),	 	0, SIZEOF(sLabelInfo));
	memset(ADR(sModSlotSel),	0, SIZEOF(sModSlotSel));
	memset(ADR(iModPos), 		0, SIZEOF(iModPos));

	(* ********************************************************* *)
	(*	get information about configured modules				 *)
	(* ********************************************************* *)
	xDiagCreateInfo_CAN.enable		:= TRUE;
	xDiagCreateInfo_CAN.infoKind	:= asdiagCONFIGURED;
	xDiagCreateInfo_CAN();
	
	IF (xDiagCreateInfo_CAN.status = 0) THEN
		iIdent 		:= xDiagCreateInfo_CAN.ident;
		iNrEntries	:= xDiagCreateInfo_CAN.nrEntries;
	END_IF;

	(* ********************************************************* *)
	(*	get name and path of configured CAN modules in Physical	 *)
	(* ********************************************************* *)		
	FOR iIndex := 0 TO iNrEntries - 1 DO
		xDiagGetStrInfo_CAN.enable		:= TRUE;
		xDiagGetStrInfo_CAN.ident		:= iIdent;
		xDiagGetStrInfo_CAN.index		:= iIndex;
		xDiagGetStrInfo_CAN.infoCode	:= asdiagHARDWARE_MODULE_NAME;
		xDiagGetStrInfo_CAN.pBuffer		:= ADR(sLabelInfo);
		xDiagGetStrInfo_CAN.bufferLen	:= SIZEOF(sLabelInfo) - 1;
		xDiagGetStrInfo_CAN();
		
		iIdxCAN_IF[1]	:=	0;
		iIdxCAN_IF[2]	:=	0;
		iPosCAN[1]		:=	0;
		iPosCAN[2]		:=	0;
		iIdxPosCAN		:=	1;
		
		IF (xDiagGetStrInfo_CAN.status = 0) THEN
			(* find CAN modules *)
			IF (FIND(sLabelInfo, 'X20CS1070') <> 0) OR (FIND(sLabelInfo, 'X20CS2770') <> 0) THEN				
				IF	FIND(sLabelInfo, sCAN_IGN_ident) <> 0		THEN
					iModPos[iIdxCAN_IGN]		:=	iIndex;
					iIdxCAN_IF[iIdxPosCAN]		:=	iIdxCAN_IGN;
					iPosCAN[iIdxPosCAN]			:=	FIND(sLabelInfo, sCAN_IGN_ident);
					iIdxPosCAN					:=	iIdxPosCAN + 1;
				END_IF;
				IF	FIND(sLabelInfo, sCAN_NOxS_IF1_ident) <> 0	THEN
					iModPos[iIdxCAN_NOxS_IF1]	:=	iIndex;
					iIdxCAN_IF[iIdxPosCAN]		:=	iIdxCAN_NOxS_IF1;
					iPosCAN[iIdxPosCAN]			:=	FIND(sLabelInfo, sCAN_NOxS_IF1_ident);
					iIdxPosCAN					:=	iIdxPosCAN + 1;
				END_IF;
				IF	FIND(sLabelInfo, sCAN_NOxS_IF2_ident) <> 0	THEN
					iModPos[iIdxCAN_NOxS_IF2]	:=	iIndex;
					iIdxCAN_IF[iIdxPosCAN]		:=	iIdxCAN_NOxS_IF2;
					iPosCAN[iIdxPosCAN]			:=	FIND(sLabelInfo, sCAN_NOxS_IF2_ident);
					iIdxPosCAN					:=	iIdxPosCAN + 1;
				END_IF;
				IF	FIND(sLabelInfo, sCAN_NOxS_IF3_ident) <> 0	THEN
					iModPos[iIdxCAN_NOxS_IF3]	:=	iIndex;
					iIdxCAN_IF[iIdxPosCAN]		:=	iIdxCAN_NOxS_IF3;
					iPosCAN[iIdxPosCAN]			:=	FIND(sLabelInfo, sCAN_NOxS_IF3_ident);
					iIdxPosCAN					:=	iIdxPosCAN + 1;
				END_IF;
				IF	FIND(sLabelInfo, sCAN_CB_ident) <> 0		THEN
					iModPos[iIdxCAN_CB]			:=	iIndex;
					iIdxCAN_IF[iIdxPosCAN]		:=	iIdxCAN_CB;
					iPosCAN[iIdxPosCAN]			:=	FIND(sLabelInfo, sCAN_CB_ident);
					iIdxPosCAN					:=	iIdxPosCAN + 1;
				END_IF;
				IF	FIND(sLabelInfo, sCAN_OQS_ident) <> 0		THEN
					iModPos[iIdxCAN_OQS]		:=	iIndex;
					iIdxCAN_IF[iIdxPosCAN]		:=	iIdxCAN_OQS;
					iPosCAN[iIdxPosCAN]			:=	FIND(sLabelInfo, sCAN_OQS_ident);
					iIdxPosCAN					:=	iIdxPosCAN + 1;
				END_IF;
				IF	FIND(sLabelInfo, sCAN_IGN2_ident) <> 0		THEN
					iModPos[iIdxCAN_IGN2]		:=	iIndex;
					iIdxCAN_IF[iIdxPosCAN]		:=	iIdxCAN_IGN2;
					iPosCAN[iIdxPosCAN]			:=	FIND(sLabelInfo, sCAN_IGN2_ident);
					iIdxPosCAN					:=	iIdxPosCAN + 1;
				END_IF;
				
				IF (iPosCAN[1] > iPosCAN[2]) AND (iPosCAN[2] <> 0) THEN
					iIdxPosCAN		:=	iIdxCAN_IF[1];	// reuse iIdxPosCAN as temporary storage variable
					iIdxCAN_IF[1]	:=	iIdxCAN_IF[2];
					iIdxCAN_IF[2]	:=	iIdxPosCAN;
				END_IF;
			END_IF;
		END_IF;
		
		(* ********************************************************* *)
		(*	get path of CAN modules									 *)
		(* ********************************************************* *)
		IF iIdxCAN_IF[1] <> 0 THEN
			xDiagGetStrInfo_CAN.infoCode	:= asdiagPATH;
			xDiagGetStrInfo_CAN.pBuffer		:= ADR(sAddrInfo);
			xDiagGetStrInfo_CAN.bufferLen	:= SIZEOF(sAddrInfo) - 1;
			xDiagGetStrInfo_CAN();
			
			IF (xDiagGetStrInfo_CAN.status = 0) THEN
				sCANAddr	:=	CONCAT(sAddrInfo,'.IF1');
				memcpy(ADR(sModSlotSel[iIdxCAN_IF[1]]), ADR(sCANAddr), SIZEOF(sModSlotSel[0])-1);
			END_IF;
			IF iIdxCAN_IF[2] <> 0 THEN
				sCANAddr	:=	CONCAT(sAddrInfo,'.IF2');
				memcpy(ADR(sModSlotSel[iIdxCAN_IF[2]]), ADR(sCANAddr), SIZEOF(sModSlotSel[0])-1);
			END_IF;
		END_IF;
	END_FOR;
	
	(* ********************************************************* *)
	(*	free ressources of AsIODiag								 *)
	(* ********************************************************* *)
	xDiagDisposeInfo_CAN.enable := TRUE;	
	xDiagDisposeInfo_CAN.ident  := iIdent;
	xDiagDisposeInfo_CAN();
	(*===========================================================*)
	
	
	(* initialize the CAN communication controller *)
	
	(* enable	 := 1 						enable the functionblock CANopen      *)
	(* baud_rate := 25 						set Baud_rate - 250KB/s				  *)
	(* cob_anz	 := 500 					set maximum CMS communication objects *)
	(* error_adr := ADR(error_var)			define error - PV					  *)
	(* device	 := ADR('SL1.SS1.IF1')		Description of the interface		  *)
	(* info		 := 0						info isn't in use					  *)

	CANopen_CMS.enable		:=	1;
	CANopen_CMS.baud_rate	:=	25;
	CANopen_CMS.cob_anz		:=	500;
	CANopen_CMS.error_adr	:=	ADR(CANopen_error);
	CANopen_CMS.device		:=	ADR(sModSlotSel[iIdxCAN_IGN]);
	CANopen_CMS.info		:=	0;
	
	(* Default Slot Configuration - CAN Modules *)
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_X20CP368xX),		ADR('IF3.ST32.IF1.ST2.IF1'));		(* B&R X20CP368xX *)
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_X20CP368xX_J920),ADR('IF3.ST35.IF1.ST2.IF1'));		(* B&R X20CP368xX J920 *)
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_3100),		ADR('SL2.IF1.ST32.IF1.ST2.IF1'));	(* B&R PPC3100 *)
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_3100_J920),	ADR('SL2.IF1.ST35.IF1.ST2.IF1'));	(* B&R PPC3100 J920 *)
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC), 			ADR('SS2.IF1.ST32.IF1.ST2.IF1'));	(* B&R PPC900 *)
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_J920), 		ADR('SS2.IF1.ST35.IF1.ST2.IF1'));	(* B&R PPC900 J920 *)
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_CMaU), 		ADR('SS1.IF1'));					(* B&R IPC CM&U *)
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_GE_IP), 		ADR('IF4.ST32.IF1.ST2.IF1'));		(* GE IPC *)	
	strcpy(ADR(MM2VIS.sCAN_HW_Slot_IPC_GE_IP_J920), ADR('IF4.ST35.IF1.ST2.IF1'));		(* GE IPC J920 *)
	
	CANopen_CMS();
		
	OUT_HA.iCANIdent := CANopen_CMS.us_ident;
	
	
	(* initiate CMS manager *)
	
	(* enable    := 1 						enable the functionblock CANopen     *)
	(* us_ident  := CANopen_01.us_ident 	application ident  (from CANopen)    *)
	(* user_type := 0						0 ... client, 1 ... server           *)
	(* queue_cnt := 0						isn´t in use 						 *)
	(* modul_name:= ADR('cmsinit'))			name of data module with CMS objects *)
	
	IF CANopen_CMS.status = 0 THEN		(* check if CAN open was successful *)
	
		(* initiate CMS manager general *)
		CMSinit_Init(enable:=1, us_ident:=CANopen_CMS.us_ident, user_type:=0, queue_cnt:=0, modul_name:=ADR('cmsinit'));
		(* initiate CMS main function for send and receive CAN messages *)
		CMSmain_Init.enable    := TRUE;
		CMSmain_Init.cms_ident := CMSinit_Init.cms_ident;
		CMSmain_Init.cms_mode  := 2;
	ELSE
		MM2VIS.iCAN_HW_Slot := 0;
	END_IF;
	
		
	(* initialize the CAN communication controller IGN2 *)
	
	IF iModPos[iIdxCAN_IGN2] <> 0 THEN

		(* enable	 := 1 						enable the functionblock CANopen      *)
		(* baud_rate := 25 						set Baud_rate - 250KB/s				  *)
		(* cob_anz	 := 500 					set maximum CMS communication objects *)
		(* error_adr := ADR(error_var)			define error - PV					  *)
		(* device	 := ADR('SL1.SS1.IF1')		Description of the interface		  *)
		(* info		 := 0						info isn't in use					  *)
		
		CANopen_CMS.enable		:=	1;
		CANopen_CMS.baud_rate	:=	25;
		CANopen_CMS.cob_anz		:=	500;
		CANopen_CMS.error_adr	:=	ADR(CANopen_error);
		CANopen_CMS.device		:=	ADR(sModSlotSel[iIdxCAN_IGN2]);
		CANopen_CMS.info		:=	0;
	
		CANopen_CMS();
	
		OUT_HA.iCANIdentIGN2 := CANopen_CMS.us_ident;
	
	
		(* initiate CMS manager IGN2 *)
		
		(* enable    := 1 						enable the functionblock CANopen     *)
		(* us_ident  := CANopen_01.us_ident 	application ident  (from CANopen)    *)
		(* user_type := 0						0 ... client, 1 ... server           *)
		(* queue_cnt := 0						isn´t in use 						 *)
		(* modul_name:= ADR('cmsinit'))			name of data module with CMS objects *)
		
		IF CANopen_CMS.status = 0 THEN		(* check if CAN open was successful *)
		
			(* initiate CMS manager general *)
			CMSinit_Init(enable:=1, us_ident:=CANopen_CMS.us_ident, user_type:=0, queue_cnt:=0, modul_name:=ADR('cmsinit'));
			(* initiate CMS main function for send and receive CAN messages *)
			CMSmain_Init2.enable    := TRUE;
			CMSmain_Init2.cms_ident := CMSinit_Init.cms_ident;
			CMSmain_Init2.cms_mode  := 2;
		ELSE
			MM2VIS.iCAN_HW_Slot := 0;
		END_IF;
				
	END_IF;
	
END_PROGRAM
