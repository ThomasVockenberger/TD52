(*******************************************************************************
AGGR: Modbus RTU connection to LV GCB  (init)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V4.13	21-11-2023	Hohensinner	created
							   
Instructions for use:
--------------------
Caution!
- X20CS1030_xxx_xx_GCB should not be in "cyclic stream" mode, instead it should be set to "stream".
- Also the modules name must be ending with "_GCB" to be found in the init part.

Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT
	(** 1: Don't execute task if ARsim is active *)
	IF DiagCpuIsSimulated() THEN
		RETURN;
	END_IF
	
	(** 2: get name and path of configured X20CS1030_xxx_xx_GCB module *)
	(** 2.1: get information about configured modules *)
	xDiagCreateInfo.enable		:= TRUE;
	xDiagCreateInfo.infoKind	:= asdiagCONFIGURED;
	xDiagCreateInfo();
	
	IF (xDiagCreateInfo.status = 0) THEN
		iIdent 		:= xDiagCreateInfo.ident;
		iNrEntries	:= xDiagCreateInfo.nrEntries;
	END_IF;

	(** 2.2: search names and get correct path of configured X20CS1030_xxx_xx_GCB module *)
	memset(ADR(sLabelInfo),	 	0, SIZEOF(sLabelInfo));
	FOR iIndex := 0 TO iNrEntries - 1 DO
		xDiagGetStrInfo.enable		:= TRUE;
		xDiagGetStrInfo.ident		:= iIdent;
		xDiagGetStrInfo.index		:= iIndex;
		xDiagGetStrInfo.infoCode	:= asdiagHARDWARE_MODULE_NAME;
		xDiagGetStrInfo.pBuffer		:= ADR(sLabelInfo);
		xDiagGetStrInfo.bufferLen	:= SIZEOF(sLabelInfo) - 1;
		xDiagGetStrInfo();
		
		IF xDiagGetStrInfo.status = 0 THEN
			IF FIND(sLabelInfo, 'X20CS1030') <> 0 THEN				
				IF FIND(sLabelInfo, 'GCB') <> 0 THEN
					xDiagGetStrInfo.infoCode	:= asdiagPATH;
					xDiagGetStrInfo.pBuffer		:= ADR(sAddrInfo);
					xDiagGetStrInfo.bufferLen	:= SIZEOF(sAddrInfo) - 1;
					xDiagGetStrInfo();
					IF (xDiagGetStrInfo.status = 0) THEN
						sRTUAddr	:=	CONCAT(sAddrInfo,'.IF1');
					END_IF
					EXIT;		
				END_IF
			END_IF
		END_IF	
	END_FOR
	
	(** 2.3: free ressources of AsIODiag *)
	xDiagDisposeInfo.enable := TRUE;	
	xDiagDisposeInfo.ident  := iIdent;
	xDiagDisposeInfo();
	
	(** 3: If no Address was found deactivate task and end init now *)
	IF sRTUAddr = '' THEN
		bDeactivate_Task := TRUE;
		RETURN;
	ELSE
		MM2VIS.tGCB[1].bEna	:=	TRUE;
	END_IF
	
	(** 4: Global initialization of master *)
	//Physical properties	/PHY	RS232|RS422|RS485| TTY|RS422BUS
	//Parity				/PA		N|E|O|H|L
	//Data bits				/DB		7|8
	//Stop bits				/SB		1|2
	//Baud rate				/BD		300-115200
	//possible to increase the amount of masters
	xMBDO_Master[0].bEnable				:=	TRUE;
	xMBDO_Master[0].pName_Module		:=	ADR('Synchronization');	//Name of this Module
	xMBDO_Master[0].pName_Task			:=	ADR('LV_GCB');			//Name of this Task
	xMBDO_Master[0].iMemType			:=	doUSRRAM;				//Memory where the Modbus data object should be created
	xMBDO_Master[0].pCmd				:=	ADR(tCmd[0]);			//Pointer to Master command structure
	xMBDO_Master[0].tCfg.sMode			:=	'/PHY=RS485 /PA=E /DB=8 /SB=1 /BD=19200'; //see above
	xMBDO_Master[0].tCfg.iTimeOut		:=	300;					//Timeout in ms (value must be a multiple of 10)
	xMBDO_Master[0].tCfg.bASCII			:=	FALSE;					//ModBus mode (0 = RTU / 1 = ASCII)
	xMBDO_Master[0].tCfg.iID			:=	1;						//ID of Master (Zero not accepted)
	xMBDO_Master[0].tSlave				:=	ADR(tSlave);			//Pointer to Slave structure
	tCmd[0].bOpen						:=	TRUE;					//open communication

	
	(** 5: Local initialization of masters *)
	(** 5.1: Local initialization of master #1 *)
	xMBDO_Master[0].tCfg.sDevice	:=	sRTUAddr;		//Address of X20CS1030 
	xMBDO_Master[0].tCfg.sFile		:=	'CFG_GCB';		//Data object name

	(** 6: Local initialization of slaves*)
	//Master that is connected to this slave	iMaster
	//Slaves name								sName
	//Slaves address on ModBus					iAdr
	//Additional info e.g. cubicle number		iInfo
	
	(** 6.1: Slaves *)
	tSlave[0].iMaster	:=	1;
	tSlave[0].sName		:=	'ABB EMAX 2';
	tSlave[0].iAdr		:=	247;				//ABB: default
	tSlave[0].iInfo		:=	1;					//not needed at moment
	
	tSlave[1].iMaster	:=	1;
	tSlave[1].sName		:=	'Schneider MTZ';
	tSlave[1].iAdr		:=	17;					//SE: must be set on IFM
	tSlave[1].iInfo		:=	1;					//not needed at moment
	
	//Modbus Function Code					iFC
	//Modbus Register Length				iLen
	//Modbus Register Offset				iOffs
	//Word offset in extra Memory array		iWordOffs
	//Bit offset in extra Memory array		iBitOffs
	
	(** 6.2: Command lines for each slave *)

	tSlave[0].tLine[0].tDef.iFC				:=	4;
	tSlave[0].tLine[0].tDef.iLen			:=	4;
	tSlave[0].tLine[0].tDef.iOffs			:=	20;			//Contact wear

	tSlave[0].tLine[1].tDef.iFC				:=	4;
	tSlave[0].tLine[1].tDef.iLen			:=	1;
	tSlave[0].tLine[1].tDef.iOffs			:=	30;			//read programming failure codes
	
	tSlave[0].tLine[2].tDef.iFC				:=	4;
	tSlave[0].tLine[2].tDef.iLen			:=	6;
	tSlave[0].tLine[2].tDef.iOffs			:=	100;		//read Current measures

	tSlave[0].tLine[3].tDef.iFC				:=	4;
	tSlave[0].tLine[3].tDef.iLen			:=	3;
	tSlave[0].tLine[3].tDef.iOffs			:=	154;		//read Voltage measures
	
	tSlave[0].tLine[4].tDef.iFC				:=	4;
	tSlave[0].tLine[4].tDef.iLen			:=	1;
	tSlave[0].tLine[4].tDef.iOffs			:=	652;		//read Primary Voltage	
	
	tSlave[0].tLine[6].tDef.iFC				:=	4;
	tSlave[0].tLine[6].tDef.iLen			:=	8;
	tSlave[0].tLine[6].tDef.iOffs			:=	700;		//read L (ANSI 49)
	
	tSlave[0].tLine[7].tDef.iFC				:=	4;
	tSlave[0].tLine[7].tDef.iLen			:=	9;
	tSlave[0].tLine[7].tDef.iOffs			:=	710;		//read S (ANSI 50TD, 68, 51N)
	
	tSlave[0].tLine[8].tDef.iFC				:=	4;
	tSlave[0].tLine[8].tDef.iLen			:=	4;
	tSlave[0].tLine[8].tDef.iOffs			:=	720;		//read I (ANSI 50)

	tSlave[0].tLine[9].tDef.iFC				:=	16;
	tSlave[0].tLine[9].tDef.iLen			:=	2;
	tSlave[0].tLine[9].tDef.iOffs			:=	711;		//write S (ANSI 50TD, 68, 51N)
	
	tSlave[0].tLine[10].tDef.iFC			:=	6;
	tSlave[0].tLine[10].tDef.iLen			:=	1;
	tSlave[0].tLine[10].tDef.iOffs			:=	721;		//write I (ANSI 50)
	
	tSlave[0].tLine[11].tDef.iFC			:=	4;
	tSlave[0].tLine[11].tDef.iLen			:=	1;
	tSlave[0].tLine[11].tDef.iOffs			:=	40;			//read Information
	
	tSlave[0].tLine[12].tDef.iFC			:=	4;
	tSlave[0].tLine[12].tDef.iLen			:=	1;
	tSlave[0].tLine[12].tDef.iOffs			:=	504;		//read Nom Current
	
	tSlave[0].tLine[13].tDef.iFC			:=	16;
	tSlave[0].tLine[13].tDef.iLen			:=	2;
	tSlave[0].tLine[13].tDef.iOffs			:=	0;			//write Commands
	
	tSlave[0].tLine[14].tDef.iFC			:=	16;
	tSlave[0].tLine[14].tDef.iLen			:=	2;
	tSlave[0].tLine[14].tDef.iOffs			:=	701;		//write L (ANSI 49)
	
	//Schneider MTZ:
	tSlave[1].tLine[0].tDef.iFC				:=	4;
	tSlave[1].tLine[0].tDef.iLen			:=	4;
	tSlave[1].tLine[0].tDef.iOffs			:=	35204-1;	//Op cnt + Trip counter in uint32
	
	tSlave[1].tLine[1].tDef.iFC				:=	4;
	tSlave[1].tLine[1].tDef.iLen			:=	2;		
	tSlave[1].tLine[1].tDef.iOffs			:=	32000-1;	//0 = closed, 1= tripped
	
	tSlave[1].tLine[2].tDef.iFC				:=	4;
	tSlave[1].tLine[2].tDef.iLen			:=	6;
	tSlave[1].tLine[2].tDef.iOffs			:=	32028-1;	//real time current L1-L3 float 32bit
	
	tSlave[1].tLine[3].tDef.iFC				:=	4;
	tSlave[1].tLine[3].tDef.iLen			:=	2;
	tSlave[1].tLine[3].tDef.iOffs			:=	21013-1;	//real time avg voltage float 32bit
	
	tSlave[1].tLine[4].tDef.iFC				:=	4;
	tSlave[1].tLine[4].tDef.iLen			:=	4;
	tSlave[1].tLine[4].tDef.iOffs			:=	8153-1;		//nom voltage and current in 32bit float
	
	tSlave[1].tLine[5].tDef.iFC				:=	4;
	tSlave[1].tLine[5].tDef.iLen			:=	2;
	tSlave[1].tLine[5].tDef.iOffs			:=	24001-1;	//contact wear in 32bit float

	tSlave[1].tLine[6].tDef.iFC				:=	4;
	tSlave[1].tLine[6].tDef.iLen			:=	4;
	tSlave[1].tLine[6].tDef.iOffs			:=	45025-1;	//long time overcurrent in 32bit float
	
	tSlave[1].tLine[7].tDef.iFC				:=	4;
	tSlave[1].tLine[7].tDef.iLen			:=	4;
	tSlave[1].tLine[7].tDef.iOffs			:=	45035-1;	//short time overcurrent in 32bit float

	tSlave[1].tLine[8].tDef.iFC				:=	4;
	tSlave[1].tLine[8].tDef.iLen			:=	3;
	tSlave[1].tLine[8].tDef.iOffs			:=	45044-1;	//instantaneous overcurrent in 32bit float
	
	tSlave[1].tLine[9].tDef.iFC				:=	4;
	tSlave[1].tLine[9].tDef.iLen			:=	1;
	tSlave[1].tLine[9].tDef.iOffs			:=	15330-1;	// TBD
	
	tSlave[1].tLine[10].tDef.iFC			:=	16;
	tSlave[1].tLine[10].tDef.iLen			:=	14;
	tSlave[1].tLine[10].tDef.iOffs			:=	8000-1;			//write Commands

	tSlave[1].tLine[11].tDef.iFC			:=	4;
	tSlave[1].tLine[11].tDef.iLen			:=	5;
	tSlave[1].tLine[11].tDef.iOffs			:=	8020-1;			//check write Commands
	
	(** 7: check complete configuration *)
	bError_Conf	:=	MSC_MB_DataCheck(ADR(tSlave)) > 0;
	
	(** 8: Special modbus commands for Schneider *)
	//	User profile Default password
	//	Administrator ‘0000’ = 0x30303030 => 12336 & 12336
	//	Services ‘1111’ = 0x31313131
	//	Engineer ‘2222’ = 0x32323232
	//	Operator ‘3333’ = 0x33333333
	
	(** 8.1: Open Setup Session *)
	tIF_Session_Open.bExec		:=	TRUE;
	tIF_Session_Open.iData[0]	:=	1930;
	tIF_Session_Open.iData[1]	:=	10;				
	tIF_Session_Open.iData[2]	:=	5377;	
	tIF_Session_Open.iData[3]	:=	1;	
	tIF_Session_Open.iData[4]	:=	12336;	
	tIF_Session_Open.iData[5]	:=	12336;
	
	(** 8.2: Close Setup Session *)
	tIF_Session_Close.bExec		:=	TRUE;
	tIF_Session_Close.iData[0]	:=	1933;
	tIF_Session_Close.iData[1]	:=	14;				
	tIF_Session_Close.iData[2]	:=	5377;	
	tIF_Session_Close.iData[3]	:=	1;	
	tIF_Session_Close.iData[4]	:=	12336;	
	tIF_Session_Close.iData[5]	:=	12336;	

	(** 8.3: Apply Settings *)
	tIF_Session_Apply.bExec		:=	TRUE;
	tIF_Session_Apply.iData[0]	:=	1932;
	tIF_Session_Apply.iData[1]	:=	14;				
	tIF_Session_Apply.iData[2]	:=	5377;	
	tIF_Session_Apply.iData[3]	:=	1;	
	tIF_Session_Apply.iData[4]	:=	12336;	
	tIF_Session_Apply.iData[5]	:=	12336;
	
	(** 8.4: Submit Long Time Over Current Protection Settings *)
	tIF_Session_Change1.bExec		:=	TRUE;
	tIF_Session_Change1.iData[0]	:=	51593;
	tIF_Session_Change1.iData[1]	:=	26;				
	tIF_Session_Change1.iData[2]	:=	5377;	
	tIF_Session_Change1.iData[3]	:=	1;	
	tIF_Session_Change1.iData[4]	:=	12336;	
	tIF_Session_Change1.iData[5]	:=	12336;	
	// 6&7: SessionKey		
	tIF_Session_Change1.iData[8]	:=	1;		// Group A = 1
	tIF_Session_Change1.iData[9]	:=	65535;	// Reserved
	// 10&11: Range - / Step 0.1A
	// 12&13: Range 0.5 - 24.0 / Step 0.5s
	
	(** 8.5: Submit Short Time Over Current Protection Settings *)
	tIF_Session_Change2.bExec		:=	TRUE;
	tIF_Session_Change2.iData[0]	:=	51594;
	tIF_Session_Change2.iData[1]	:=	26;				
	tIF_Session_Change2.iData[2]	:=	5377;	
	tIF_Session_Change2.iData[3]	:=	1;	
	tIF_Session_Change2.iData[4]	:=	12336;	
	tIF_Session_Change2.iData[5]	:=	12336;	
	// 6&7: SessionKey		
	tIF_Session_Change2.iData[8]	:=	1;	// Group A = 1
	tIF_Session_Change2.iData[9]	:=	0;	// I²t = On, 0: I²t = Off
	// 10&11: Range 1.5 - 10.0 / Step 0.1
	// 12&13: Range 0.0 - 0.4 / Step 0.1s
	
	(** 8.6: Submit Instantaneous Protection Settings *)
	tIF_Session_Change3.bExec		:=	TRUE;
	tIF_Session_Change3.iData[0]	:=	51595;
	tIF_Session_Change3.iData[1]	:=	22;				
	tIF_Session_Change3.iData[2]	:=	5377;	
	tIF_Session_Change3.iData[3]	:=	1;	
	tIF_Session_Change3.iData[4]	:=	12336;	
	tIF_Session_Change3.iData[5]	:=	12336;	
	// 6&7: SessionKey	
	tIF_Session_Change3.iData[8]	:=	16#0101;	//MSB: 1 = On	// LSB: Group A = 1	
	// 9&10: Range 2.0 - 15.0 / Step 0.1
	tIF_Session_Change3.iData[11]	:=	1;	//  0 = Standart, 1 = Fast

	(** 9: Special modbus commands for ABB *)	
	(** 9.1: ABB Command open program session *)
	tIF_ABB_Open.bExec		:=	TRUE;
	tIF_ABB_Open.iData[0]	:=	4;
	tIF_ABB_Open.iData[1]	:=	0;
	
	(** 9.2: ABB Command close program session	*)
	tIF_ABB_Close.bExec		:=	TRUE;
	tIF_ABB_Close.iData[0]	:=	6;
	tIF_ABB_Close.iData[1]	:=	0;
	
END_PROGRAM