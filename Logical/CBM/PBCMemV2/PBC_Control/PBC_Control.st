(*******************************************************************************
AGGR: read and write DIA.NE XT parameter to flash memory	(cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019


Customized modifications: -
------------------------
 
History:
-------
V3.50		06-06-2014	Caks,		generated
V3.50.1		04-09-2014	Caks,		added: ucPBCBits
V3.50.2		23-10-2014	Caks,		added: auto enable
V3.50.3		05-11-2014	Caks,		added: many new variables
			03-12-2014	Caks,		added: Rod and Main bearing temperature
			05-12-2014	Caks,		added: Time to Structure and File
V3.50.4		12-12-2014	Perktold,   changed activation
V3.50.5		08-01-2015	Perktold,	Änderung Dateinamen
V4.02.0		09-03-2015	Caks,		converted to XT4 CBM module, added some variables
			14-04-2015	Caks,		save Header when triggered
			26-05-2015	Caks,		buffering enabled at 100rpm, write trigger enabled at min 200rpm and added lastcycle bugfix at low rpms
			21-10-2015	Caks,		added SFIKW Event Trigger
V4.02.2		21-08-2017	502423184	Extended version, see spec
V4.06.0		24-04-2018	502423184	new easy way setting up triggers in one line
			30-07-2018	502423184	Bugfix if engine trips in ramp up

Instructions for use:
--------------------

To add ECBMem Triggers --> go to Section 4.3

10ms Task class 1 --> saves every 80ms/120ms the data

Outstandings:
------------
*******************************************************************************)
PROGRAM	_INIT
(** A: ATD Buffer Stopping *)
	TON_MSTOP_10s.PT := T#10s;

END_PROGRAM

PROGRAM _CYCLIC

(** 1: Enable ECBMem on Type 9 Engines or Parameter settings *)
TON_PBCMem_Ena(IN := (NOT(bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3) AND IN_CB.tPB2MM.bParaSetupOk), PT := T#1m);
IF TON_PBCMem_Ena.Q THEN
	bPBC_Mem_Ena	:=	Para.bECBMem_Ena OR xEngType.Type9;
END_IF
		
(** 2: If enabled do *)
IF bPBC_Mem_Ena THEN

(** 3: ATD Buffer Stopping *)
	TON_MSTOP_10s.IN := xOpMode.Stop;
	TON_MSTOP_10s();
	(*hold the buffer during engine stop to avoid cycle time violation *)
	IF EDGEPOS(bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3) AND NOT bPBC_Write AND NOT xOpMode.Stop THEN
		 bPBC_Write_RStop := TRUE;
	ELSIF TON_MSTOP_10s.Q  THEN
		 bPBC_Write_RStop := FALSE;
	END_IF

(** 4: Triggers *)
(** 4.1: SFIKW & LHE Events *)
	bSFIKW_Event	:=	FALSE;
	FOR i:=1 TO USINT_TO_INT(xEngType.NumberOfCylinder) DO
		bSFIKW_Event	:=	MAX(bSFIKW_Event, IN_CB.bPBCSlowDriftCheck[i]) ;
	END_FOR

(** 4.2: Manual Trigger *)
	IF bPBC_Write OR (VIS2MM.ECB.bTrig AND xOpMode.Stop) OR NOT bPBC_Record THEN						(* disable trigger, if write is performing or in stop mode or not buffering *)
		VIS2MM.ECB.bTrig	:=	FALSE;
	END_IF
	iManCyc	:=	LIMIT(REAL_TO_INT(VIS2MM.ECB.rRemain), -900, 100);

(** 4.3: All Triggers *)
	(* Trigger Name in File 				Remaining cycles after trigger			Trigger bit, on EDGEPOS the trigger is activated, priority from 1 to max *)
	Buffer.TrigMode[1].Name := 'Trip';		Buffer.TrigMode[1].iRemain	:= 0;		Buffer.TrigMode[1].bEvent := Para.bECB_Trig_Alarm AND (bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3);
	Buffer.TrigMode[2].Name := 'LVRT';		Buffer.TrigMode[2].iRemain	:= -300;	Buffer.TrigMode[2].bEvent := Para.bECB_Trig_GC AND IN_CB.bPBC_Event_GC;
	Buffer.TrigMode[3].Name := 'Man';		Buffer.TrigMode[3].iRemain	:= iManCyc;	Buffer.TrigMode[3].bEvent := VIS2MM.ECB.bTrig;
	Buffer.TrigMode[4].Name := 'Misf';		Buffer.TrigMode[4].iRemain	:= 0;		Buffer.TrigMode[4].bEvent := Para.bECB_Trig_Misf AND IN_CB.bPBC_Event_Misf;
	Buffer.TrigMode[5].Name	:= 'SFKW';		Buffer.TrigMode[5].iRemain	:= 0;		Buffer.TrigMode[5].bEvent := Para.bECB_Trig_SFKW AND bSFIKW_Event; 
	Buffer.TrigMode[6].Name	:= 'LGM_Ramp';	Buffer.TrigMode[6].iRemain	:= -300;	Buffer.TrigMode[6].bEvent := Para.bECB_Trig_LGM AND bLGM_Event_Ramp;
	Buffer.TrigMode[7].Name	:= 'LGM';		Buffer.TrigMode[7].iRemain	:= -300;	Buffer.TrigMode[7].bEvent := Para.bECB_Trig_LGM AND bLGM_Event;
	Buffer.TrigMode[8].Name := 'IMEP';		Buffer.TrigMode[8].iRemain	:= 0;		Buffer.TrigMode[8].bEvent := FALSE;
	(* Triggers can be here added, don't forget to increase trigger constant --> iECB_MaxTrig *)
	Buffer.TrigMode[9].Name := 'Spare';		Buffer.TrigMode[9].iRemain	:= 0;		Buffer.TrigMode[9].bEvent := FALSE;
	Buffer.TrigMode[10].Name:= 'Spare';		Buffer.TrigMode[10].iRemain	:= 0;		Buffer.TrigMode[10].bEvent:= FALSE;

(** 4.4: Trigger evaluation *)
	bECB_Trigger	:= FALSE;
	FOR i:=1 TO iECB_MaxTrig DO
		IF NOT bECB_Trigger AND Buffer.TrigMode[i].bEvent THEN
			iECB_Trigger	:=	INT_TO_UINT(i);
		END_IF
		bECB_Trigger	:=	bECB_Trigger OR Buffer.TrigMode[i].bEvent;
	END_FOR

(** 5: Action on Trigger Event *)
	IF EDGEPOS(bECB_Trigger) AND NOT bPBC_Write AND NOT xOpMode.Stop AND bPBC_Record THEN
(** 5.1: start last cycles to record *)
		bLast_Cycles	:=	TRUE;
		bPBC_Write		:=	TRUE;
		iPBC_Trigger	:=	iECB_Trigger;
		iLast_Cycles	:=	Buffer.TrigMode[iECB_Trigger].iRemain;

(** 5.2: get Alarms and Warnings *)
		szPBC_Trip_IDs 	:= 	'';	
		iCnt_Trip		:=	0;
		szPBC_Warn_IDs 	:= 	'';	
		iCnt_Warn		:=	0;
		FOR i:=1001 TO 3999 BY 1 DO												(* go through all relevant error *)
			IF IN_CB.iMsg[i] > 0 AND IN_CB.iMsg[i] < 4 THEN							(* find the active trips *)
				iCnt_Trip	:=	iCnt_Trip + 1;											(* count trips *)
				IF iCnt_Trip < 7 THEN														(* save only 6 nummers = 29 chars *)
					IF iCnt_Trip > 1 THEN 	strcat(ADR(szPBC_Trip_IDs), ADR(';')); END_IF;	(* put between the numbers a ';' *)
	  				itoa(i,ADR(szTemp));	strcat(ADR(szPBC_Trip_IDs), ADR(szTemp));		(* the alarm id's will be saved *)
				END_IF
			END_IF
			IF IN_CB.iMsg[i] = 4 THEN												(* find the active warnings *)
				iCnt_Warn	:=	iCnt_Warn + 1;											(* count warnings *)
				IF iCnt_Warn < 7 THEN														(* save only 6 nummers = 29 chars *)
					IF iCnt_Warn > 1 THEN 	strcat(ADR(szPBC_Warn_IDs), ADR(';')); 	END_IF;	(* put between the numbers a ';' *)
	  				itoa(i,ADR(szTemp));	strcat(ADR(szPBC_Warn_IDs), ADR(szTemp));		(* the warning id's will be saved *)
				END_IF
			END_IF	
		END_FOR	

(** 5.3: collect header information *)
		iCnt_Header :=	0;
		Buffer.HeaderS[iCnt_Header].Name	:=	'Trigger Delay';
		itoa(100 - iLast_Cycles,ADR(Buffer.HeaderS[iCnt_Header].Value));

		iCnt_Header 						:=	MIN(iCnt_Header + 1, iHS_Max);
		Buffer.HeaderS[iCnt_Header].Name	:=	'Warnings';
		Buffer.HeaderS[iCnt_Header].Value	:=	'';
		Buffer.HeaderS[iCnt_Header].Value	:=	szPBC_Warn_IDs;

		IF bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3  THEN
			iCnt_Header 						:=	MIN(iCnt_Header + 1, iHS_Max);
			Buffer.HeaderS[iCnt_Header].Name	:=	'Trips';
			Buffer.HeaderS[iCnt_Header].Value	:=	'';
			Buffer.HeaderS[iCnt_Header].Value	:=	szPBC_Trip_IDs;
		END_IF

		iCnt_Header 						:=	MIN(iCnt_Header + 1, iHS_Max);
		Buffer.HeaderS[iCnt_Header].Name	:=	'Operation Mode';
		IF xOpMode_old.Idle THEN 			Buffer.HeaderS[iCnt_Header].Value	:=	'Idle';
		ELSIF xOpMode_old.NetP THEN 		Buffer.HeaderS[iCnt_Header].Value	:=	'NetP';	
		ELSIF xOpMode_old.Island THEN 		Buffer.HeaderS[iCnt_Header].Value	:=	'Island';	
		END_IF

		Buffer.iCnt_HS						:=	iCnt_Header;	//return used size

		//Header 12 Array
		IF Para.bSA_Ign_Active THEN

			iCnt_Header :=	0;
			Buffer.Header12[iCnt_Header].Name	:=	'T_SAFI';
			Buffer.Header12[iCnt_Header].Unit	:=	'degC';
			Buffer.Header12[iCnt_Header].Value	:=	IN_CB.rT_SA_ElecTemp;
			Buffer.Header12[iCnt_Header].Co		:=	1;
	
			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH12_Max);
			Buffer.Header12[iCnt_Header].Name	:=	'SA_SW_Vers';
			Buffer.Header12[iCnt_Header].Unit	:=	'';
			Buffer.Header12[iCnt_Header].Value	:=	IN_CB.rSA_SW_Vers;
			Buffer.Header12[iCnt_Header].Co		:=	2;
	
			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH12_Max);
			Buffer.Header12[iCnt_Header].Name	:=	'SA_FiltVers';
			Buffer.Header12[iCnt_Header].Unit	:=	'';
			Buffer.Header12[iCnt_Header].Value	:=	IN_CB.rSA_FiltVers;
			Buffer.Header12[iCnt_Header].Co		:=	2;

			IF Para.bSA_PBC_Active THEN	
				iCnt_Header 						:=	MIN(iCnt_Header + 1, iH12_Max);
				Buffer.Header12[iCnt_Header].Name	:=	'Sensor_Sensitivity';
				Buffer.Header12[iCnt_Header].Unit	:=	'mV/bar';
				Buffer.Header12[iCnt_Header].Value	:=	IN_CB.rSA_PBC_Sens;
				Buffer.Header12[iCnt_Header].Co		:=	0;
			END_IF
			Buffer.iCnt_H12						:=	iCnt_Header;	//return used size
		ELSE
			iCnt_Header :=	0;
			Buffer.Header12[iCnt_Header].Name	:=	'no SAFI';
			Buffer.Header12[iCnt_Header].Unit	:=	'';
			Buffer.Header12[iCnt_Header].Value;
			Buffer.Header12[iCnt_Header].Co		:=	1;
			Buffer.iCnt_H12						:=	0;	//return used size	
		END_IF

		//Header
		iCnt_Header :=	0;
		Buffer.Header[iCnt_Header].Name		:=	'T_Eng_Oil';
		Buffer.Header[iCnt_Header].Unit		:=	'degC';
		Buffer.Header[iCnt_Header].Value	:=	IN_CB.tT_EO.Unfilt;
		Buffer.Header[iCnt_Header].Co		:=	1;
			
		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'T_Eng_Water';
		Buffer.Header[iCnt_Header].Unit		:=	'degC';
		Buffer.Header[iCnt_Header].Value	:=	IN_CB.tT_ECW.Unfilt;
		Buffer.Header[iCnt_Header].Co		:=	1;

		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'T_Amb';
		Buffer.Header[iCnt_Header].Unit		:=	'degC';
		Buffer.Header[iCnt_Header].Value	:=	IN_CB.rT_Ch_T1LP_Avg;
		Buffer.Header[iCnt_Header].Co		:=	1;
		
		IF IN_CB.tT_GR.Exist THEN
			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
			Buffer.Header[iCnt_Header].Name		:=	'T_Gas';
			Buffer.Header[iCnt_Header].Unit		:=	'degC';
			Buffer.Header[iCnt_Header].Value	:=	IN_CB.tT_GR.Unfilt;			
			Buffer.Header[iCnt_Header].Co		:=	1;
		END_IF
			
		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'Operating Time';
		Buffer.Header[iCnt_Header].Unit		:=	'h';
		Buffer.Header[iCnt_Header].Value	:=	DINT_TO_REAL(IN_CB.iCnt_OpHours);
		Buffer.Header[iCnt_Header].Co		:=	1;
		
		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'Engine Starts';
		Buffer.Header[iCnt_Header].Unit		:=	'';
		Buffer.Header[iCnt_Header].Value	:=	DINT_TO_REAL(IN_CB.iCnt_Starts);
		Buffer.Header[iCnt_Header].Co		:=	0;
		
		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'P_Nom';
		Buffer.Header[iCnt_Header].Unit		:=	'kW';
		Buffer.Header[iCnt_Header].Value	:=	IN_CB.rP_Nom;
		Buffer.Header[iCnt_Header].Co		:=	0;
	
		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'N_Nom';
		Buffer.Header[iCnt_Header].Unit		:=	'rpm';
		Buffer.Header[iCnt_Header].Value	:=	Para.rN_EngNom;;
		Buffer.Header[iCnt_Header].Co		:=	0;
	
		IF IN_CB.tPr_Baro.Exist THEN	
			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
			Buffer.Header[iCnt_Header].Name		:=	'Pr_Baro';
			Buffer.Header[iCnt_Header].Unit		:=	'bar';
			Buffer.Header[iCnt_Header].Value	:=	IN_CB.tPr_Baro.Unfilt;
			Buffer.Header[iCnt_Header].Co		:=	3;
		END_IF
	
		IF IN_CB.tHumidity_AirIn.Exist THEN
			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
			Buffer.Header[iCnt_Header].Name		:=	'Humidity';
			Buffer.Header[iCnt_Header].Unit		:=	'';
			Buffer.Header[iCnt_Header].Value	:=	IN_CB.tHumidity_AirIn.Unfilt;
			Buffer.Header[iCnt_Header].Co		:=	3;
		END_IF

		IF xEngType.Type9 THEN	
			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
			Buffer.Header[iCnt_Header].Name		:=	'Bal_Coef_a';
			Buffer.Header[iCnt_Header].Unit		:=	'';
			Buffer.Header[iCnt_Header].Value	:=	IN_CB.rPmax_Offset_Coef_a;
			Buffer.Header[iCnt_Header].Co		:=	1;

			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
			Buffer.Header[iCnt_Header].Name		:=	'Bal_Coef_b';
			Buffer.Header[iCnt_Header].Unit		:=	'';
			Buffer.Header[iCnt_Header].Value	:=	IN_CB.rPmax_Offset_Coef_b;
			Buffer.Header[iCnt_Header].Co		:=	1;
		END_IF

		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'F_Nom';
		Buffer.Header[iCnt_Header].Unit		:=	'Hz';
		Buffer.Header[iCnt_Header].Value	:=	Para.rF_Nom[1];
		Buffer.Header[iCnt_Header].Co		:=	1;

		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'I_Nom';
		Buffer.Header[iCnt_Header].Unit		:=	'A';
		Buffer.Header[iCnt_Header].Value	:=	Para.rI_GenNom[1];
		Buffer.Header[iCnt_Header].Co		:=	0;

		iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
		Buffer.Header[iCnt_Header].Name		:=	'U_Nom';
		Buffer.Header[iCnt_Header].Unit		:=	'V';
		Buffer.Header[iCnt_Header].Value	:=	Para.rU_Gen_Nom[1];
		Buffer.Header[iCnt_Header].Co		:=	0;

		IF xEngType.Type9 THEN	
			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
			Buffer.Header[iCnt_Header].Name		:=	'Eta_Gen';
			Buffer.Header[iCnt_Header].Unit		:=	'%';
			Buffer.Header[iCnt_Header].Value	:=	IN_CB.rEta_Gen * 100;
			Buffer.Header[iCnt_Header].Co		:=	2;

			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
			Buffer.Header[iCnt_Header].Name		:=	'Eta_Mot';
			Buffer.Header[iCnt_Header].Unit		:=	'%';
			Buffer.Header[iCnt_Header].Value	:=	IN_CB.rEta_Eng * 100;
			Buffer.Header[iCnt_Header].Co		:=	2;

			iCnt_Header 						:=	MIN(iCnt_Header + 1, iH_Max);
			Buffer.Header[iCnt_Header].Name		:=	'Eta_Vol';
			Buffer.Header[iCnt_Header].Unit		:=	'%';
			Buffer.Header[iCnt_Header].Value	:=	IN_CB.rVE_Eng * 100;
			Buffer.Header[iCnt_Header].Co		:=	2;
		END_IF

		Buffer.iCnt_H						:=	iCnt_Header;	//return used size
			
	END_IF
	
(** 6: Record state machine *)
	IF NOT bPBC_Write AND NOT bPBC_Write_RStop THEN		//start and stop recording when engine turns and during no write event
		bPBC_Record		:=	NOT xOpMode.Stop;
	END_IF
	IF bPBC_Record THEN									//if recorder is activated
		IF bPBC_NewData AND bLast_Cycles THEN				// increase counter if new data is available
			iLast_Cycles := iLast_Cycles + 1;
		END_IF
		IF bLast_Cycles AND (iLast_Cycles >= 100 OR rN_Eng < 1) THEN		// count to 100 and then stop with recording
			bPBC_Record		:=	FALSE;
			bLast_Cycles	:=	FALSE;
			iLast_Cycles	:=	0;
		END_IF
	ELSE
		bLast_Cycles	:=	FALSE;
		iLast_Cycles	:=	0;
	END_IF

(** 7: Clear data from ECBMem buffer in Stop mode *)
	IF EDGEPOS(xOpMode.Stop) THEN
		bClear_Wait		:=	TRUE;
		iSlowDown		:=	0;
	END_IF

	xTON_Clear(IN:= bClear_Wait, PT:=T#40s);	//wait for ATD

	IF xTON_Clear.Q AND NOT bPBC_Record AND NOT bPBC_Write THEN
		(* Reset actual dataset position *)
		iCnt_Cycle		:=	0;
		IF iSlowDown >= 0 AND iSlowDown <= iBufferSize THEN
			iLines := LIMIT(0, iSlowDown, iBufferSize);
			(* Clear Timestamps *)
			Buffer.timer[iLines]							:=	0;
			(* Clear Bits *)
			FOR iData := 0 TO iBits_Max DO
				Buffer.Bits[iData].ucData[iLines]			:=	0;
			END_FOR
			(* Clear Bit Patterns *)
			FOR iData := 0 TO iPC_Max DO
				Buffer.pattern[iData].BitPattern[iLines]	:=	0;
			END_FOR
			(* Clear Engine Cycle Data *)
			FOR iData := 0 TO iEC_Max DO
				Buffer.ui16[iData].Data[iLines]				:=	0;
			END_FOR
			(* Clear Task Cycle Data *)
			FOR iData := 0 TO iTC_Max DO
				Buffer.ui16_H[iData].Hi[iLines]				:=	0;
				Buffer.ui16_H[iData].Lo[iLines]				:=	0;
			END_FOR
		ELSIF iSlowDown > iBufferSize AND iSlowDown <= iBufferSize + iBufferSize10 +1  THEN
			iLines := LIMIT(0, iSlowDown - iBufferSize- 1, iBufferSize10);
			(* Clear Slow Cycle Data *)
			FOR iData := 0 TO iSC_Max DO
				Buffer.ui16_low[iData].Data[iLines] 		:=	0;
			END_FOR
		ELSE
			(* Fertig *)
			bClear_Wait		:=	FALSE;
		END_IF

		(* increase line counter *)
		iSlowDown		:=	iSlowDown + 1;
	END_IF

END_IF

xOpMode_old	:=	xOpMode;

END_PROGRAM