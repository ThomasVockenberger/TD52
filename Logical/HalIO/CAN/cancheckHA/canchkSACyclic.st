(*******************************************************************************
AGGR: check CAN communication (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019  

- read lokal counter values
- save maximum counter value
- error phase detection
- minute average

Customized modifications: -
------------------------
 
History:
-------
V4.05.00	27.07.2017	Messner		generated for modular software	

							 
Instructions for use:
--------------------
- 
							
Outstandings:
------------
-
*******************************************************************************)

PROGRAM _CYCLIC
		
	(* Engine motortype *)
	xEngType.Motortype 	:= INT_TO_UINT(Para.iEng_Motortype);
	xEngType();
	
	
	IF xEngType.NumberOfCylinder <> 0 AND NOT OUT_HA.bSimWinMOD_Active THEN 
	
		(*=========================================================================*)
		(* Save maximum Event Value                                                *)  
		(*=========================================================================*)	

		(* TecJet - save maximum event value *)
		ucTecJetCommErrEventMax := 0;
		
		FOR ucLoopCnt := 1 TO 4 DO
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[0]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[1]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[2]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[3]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[4]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[5]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[6]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[7]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Conf[8]);
			ucTecJetCommErrEventMax := MAX(ucTecJetCommErrEventMax, IN_HA.tE_TEC[ucLoopCnt].Status[0]);
		END_FOR;
		
		
		(*------------------------------------------------------------------------*)
		(* KLS98 - save maximum event value *)
		ucKLS98CommErrEventMax := 0;
		
		FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
			
			ucKLS98CommErrEventMax		:= MAX(ucKLS98CommErrEventMax, IN_HA.tE_KLS[ucLoopCnt].conf[99]*BOOL_TO_USINT(IN_HA.tE_KLS[ucLoopCnt].conf[99] = ucKLS98EventOld[ucLoopCnt]));
			ucKLS98EventOld[ucLoopCnt]	:= IN_HA.tE_KLS[ucLoopCnt].conf[99];	(* check if event is for 2 cycle times at the same value *)
			
			(* start counting with value 2 because of wrong counting mode in kls98 task *)
			IF IN_HA.iKLS98CommErrCount[ucLoopCnt] > 1 THEN
				ucKLS98CommErrCountDelayed[ucLoopCnt] := IN_HA.iKLS98CommErrCount[ucLoopCnt];
			ELSE
				ucKLS98CommErrCountDelayed[ucLoopCnt] := 0;
			END_IF;
		END_FOR;
		
		
		(*------------------------------------------------------------------------*)
		(* SAFI - save maximum event value *)	
		ucSAFICommErrEventMax := 0;
		
		FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder/2 DO
			ucSAFICommErrEventMax := MAX(ucSAFICommErrEventMax, IN_HA.tE_SAFI[ucLoopCnt].sdata[1]);
		END_FOR;	
	
		
		(*------------------------------------------------------------------------*)
		(* reset max value for making new current value *)
		ucKLS98CommErrMaxCur	:= 0;		
		usTecJetCommErrMaxCur	:= 0;		
		usSAFICommErrMaxCur		:= 0;	
	
		(* save maximum counter value *)
		ucIC900CommErrMax := MAX(ucIC900CommErrMax, IN_HA.iIC900CommErrCount);
		ucMonicCommErrMax := MAX(ucMonicCommErrMax, IN_HA.iMonicCommErrCount);
		
		ucTecJetCommErrSlowMax	:= MAX(ucTecJetCommErrSlowMax, IN_HA.iTecJetCommErrCount);
		usTecJetCommErrMaxAll	:= MAX(usTecJetCommErrMaxAll , IN_HA.iTecJetCommErrCount);
		usTecJetCommErrMaxCur	:= MAX(usTecJetCommErrMaxCur , IN_HA.iTecJetCommErrCount);

		FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
			
			(* TecJet - maximum counter value *)
			IF ucLoopCnt <= 4 THEN
				usTecJetCommErrFastMax[ucLoopCnt] := MAX(usTecJetCommErrFastMax[ucLoopCnt], IN_HA.iTecErrCntMax[ucLoopCnt]);
				usTecJetCommErrMaxAll			  := MAX(usTecJetCommErrMaxAll			  , IN_HA.iTecErrCntMax[ucLoopCnt]);
				usTecJetCommErrMaxCur			  := MAX(usTecJetCommErrMaxCur			  , IN_HA.iTecErrCnt[ucLoopCnt]);
			END_IF;
			
			(* KLS98 - maximum counter value *)
			ucKLS98CommErrMax[ucLoopCnt] := MAX(ucKLS98CommErrMax[ucLoopCnt], ucKLS98CommErrCountDelayed[ucLoopCnt]);
			ucKLS98CommErrMaxAll		 := MAX(ucKLS98CommErrMaxAll		, ucKLS98CommErrCountDelayed[ucLoopCnt]);
			ucKLS98CommErrMaxCur		 := MAX(ucKLS98CommErrMaxCur		, ucKLS98CommErrCountDelayed[ucLoopCnt]);
			
			(* SAFI - maximum counter value *)
			IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN
				usSAFICommErrMax[ucLoopCnt]	:= MAX(usSAFICommErrMax[ucLoopCnt], UDINT_TO_UINT(IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100));
				usSAFICommErrMaxAll			:= MAX(usSAFICommErrMaxAll		  , UDINT_TO_UINT(IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100));
				usSAFICommErrMaxCur			:= MAX(usSAFICommErrMaxCur		  , UDINT_TO_UINT(IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100));
			END_IF;
			
		END_FOR;
				
		
		(*=========================================================================*)
		(* Error Phase Detection                                                   *)  
		(*=========================================================================*)		
		
		(* Ignition - phase detection *)
		IF IN_HA.iIC900CommErrCount > ucCanErrLevSlowHi AND NOT bIC900PhaseDetected THEN
			bIC900PhaseDetected	:= TRUE;
			usIC900PhaseCnt		:= usIC900PhaseCnt + 1;
		END_IF;
		
		xTON_IC900Phase.IN := IN_HA.iIC900CommErrCount < ucCanErrLevSlowLo;
		xTON_IC900Phase.PT := T#25s;
		xTON_IC900Phase();
		
		IF xTON_IC900Phase.Q THEN
			bIC900PhaseDetected := FALSE;
		END_IF;
		
		
		(*------------------------------------------------------------------------*)
		(* Monic - phase detection *)
		IF IN_HA.iMonicCommErrCount > ucCanErrLevSlowHi AND NOT bMonicPhaseDetected THEN
			bMonicPhaseDetected	:= TRUE;
			usMonicPhaseCnt		:= usMonicPhaseCnt + 1;
		END_IF;
		
		xTON_MonicPhase.IN := IN_HA.iMonicCommErrCount < ucCanErrLevSlowLo;
		xTON_MonicPhase.PT := T#25s;
		xTON_MonicPhase();
		
		IF xTON_MonicPhase.Q THEN
			bMonicPhaseDetected := FALSE;
		END_IF;
		
		
		(*------------------------------------------------------------------------*)
		(* Tecjet - phase detection *)
		(* Tecjet slow communication phase detection *)
		IF IN_HA.iTecJetCommErrCount > ucCanErrLevSlowHi AND NOT bTecJetSlowPhaseDetected THEN
			bTecJetSlowPhaseDetected := TRUE;
			usTecJetSlowPhaseCnt	 := usTecJetSlowPhaseCnt + 1;
		END_IF;
		
		xTON_TecJetSlowPhase.IN := IN_HA.iTecJetCommErrCount < ucCanErrLevSlowLo;
		xTON_TecJetSlowPhase.PT := T#25s;
		xTON_TecJetSlowPhase();
		
		IF xTON_TecJetSlowPhase.Q THEN
			bTecJetSlowPhaseDetected := FALSE;
		END_IF;
		
		(* Tecjet fast communication phase detection *)
		FOR ucLoopCnt := 1 TO 4 DO
			
			IF IN_HA.iTecErrCnt[ucLoopCnt] > ucCanErrLevFastHi AND NOT bTecJetFastPhaseDetected[ucLoopCnt] THEN
				bTecJetFastPhaseDetected[ucLoopCnt]	:= TRUE;
				usTecJetFastPhaseCnt[ucLoopCnt]		:= usTecJetFastPhaseCnt[ucLoopCnt] + 1;
			END_IF;
			
			xTON_TecJetFastPhase[ucLoopCnt].IN := IN_HA.iTecErrCnt[ucLoopCnt] < ucCanErrLevFastLo;
			xTON_TecJetFastPhase[ucLoopCnt].PT := T#25s;
			xTON_TecJetFastPhase[ucLoopCnt]();
			
			IF xTON_TecJetFastPhase[ucLoopCnt].Q THEN
				bTecJetFastPhaseDetected[ucLoopCnt] := FALSE;
			END_IF;
			
			usTecJetFastPhaseCntMax := MAX(usTecJetFastPhaseCntMax, usTecJetFastPhaseCnt[ucLoopCnt]);
			
		END_FOR;
		
		(* Tecjet phase detection maximum *)
		usTecJetPhaseCntMax := MAX(usTecJetFastPhaseCntMax, usTecJetSlowPhaseCnt);					
		
		
		(*------------------------------------------------------------------------*)
		(* KLS-98 - phase detection *)
		FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
			
			IF ucKLS98CommErrCountDelayed[ucLoopCnt] > ucCanErrLevSlowHi AND NOT bKLS98PhaseDetected[ucLoopCnt] THEN
				bKLS98PhaseDetected[ucLoopCnt]	:= TRUE;
				usKLS98PhaseCnt[ucLoopCnt]		:= usKLS98PhaseCnt[ucLoopCnt] + 1;
			END_IF;
			
			xTON_KLS98Phase[ucLoopCnt].IN := ucKLS98CommErrCountDelayed[ucLoopCnt] < ucCanErrLevSlowLo;
			xTON_KLS98Phase[ucLoopCnt].PT := T#25s;
			xTON_KLS98Phase[ucLoopCnt]();
			
			IF xTON_KLS98Phase[ucLoopCnt].Q THEN
				bKLS98PhaseDetected[ucLoopCnt] := FALSE;
			END_IF;
			
			usKLS98PhaseCntMax := MAX(usKLS98PhaseCntMax, usKLS98PhaseCnt[ucLoopCnt]);
			
		END_FOR;
		
		
		(*------------------------------------------------------------------------*)
		(* SAFI - phase detection *)
		FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder / 2 DO
			
			IF DINT_TO_UINT(IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100) > ucCanErrLevSlowHi AND NOT bSAFIPhaseDetected[ucLoopCnt] THEN
				bSAFIPhaseDetected[ucLoopCnt]	:= TRUE;
				usSAFIPhaseCnt[ucLoopCnt]		:= usSAFIPhaseCnt[ucLoopCnt] + 1;
			END_IF;
			
			xTON_SAFIPhase[ucLoopCnt].IN := DINT_TO_UINT(IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100) < ucCanErrLevSlowLo;
			xTON_SAFIPhase[ucLoopCnt].PT := T#25s;
			xTON_SAFIPhase[ucLoopCnt]();
			
			IF xTON_SAFIPhase[ucLoopCnt].Q THEN
				bSAFIPhaseDetected[ucLoopCnt] := FALSE;
			END_IF;
			
			usSAFIPhaseCntMax := MAX(usSAFIPhaseCntMax, usSAFIPhaseCnt[ucLoopCnt]);
			
		END_FOR
			
		
		(*=========================================================================*)
		(* Hour Average of Error Counter                                           *)  
		(*=========================================================================*)

		(* IC900 - counter increase *)
		(* count changings of counter pv´s *)
		IF ucIC900CommErrCount_Old	<> IN_HA.iIC900CommErrCount THEN
			usIC900CommErrAvgCnt	:= usIC900CommErrAvgCnt + BOOL_TO_USINT(IN_HA.iIC900CommErrCount <> 0);
			ucIC900CommErrCount_Old	:= IN_HA.iIC900CommErrCount;
		END_IF;
		
		(* Monic - counter increase *)
		IF ucMonicCommErrCount_Old	<> IN_HA.iMonicCommErrCount THEN
			usMonicCommErrAvgCnt 	:= usMonicCommErrAvgCnt + BOOL_TO_USINT(IN_HA.iMonicCommErrCount <> 0);
			ucMonicCommErrCount_Old := IN_HA.iMonicCommErrCount;
		END_IF;
		
		(* TecJet - counter increase *)
		IF ucTecJetCommErrCount_Old		<> IN_HA.iTecJetCommErrCount THEN
			usTecJetCommErrSlowAvgCnt	:= usTecJetCommErrSlowAvgCnt + BOOL_TO_USINT(IN_HA.iTecJetCommErrCount <> 0);
			usTecJetCommErrAvgMaxCnt	:= MAX(usTecJetCommErrAvgMaxCnt, usTecJetCommErrSlowAvgCnt);
			ucTecJetCommErrCount_Old	:= IN_HA.iTecJetCommErrCount;
		END_IF;
		
		FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
		
			(* TecJet - counter increase *)
			IF ucLoopCnt <= 4 THEN
				IF usTecErrCnt_Old[ucLoopCnt] <> IN_HA.iTecErrCnt[ucLoopCnt] THEN
					usTecJetCommErrFastAvgCnt[ucLoopCnt] := usTecJetCommErrFastAvgCnt[ucLoopCnt] + ABS(IN_HA.iTecErrCnt[ucLoopCnt] - usTecErrCnt_Old[ucLoopCnt]);
					usTecJetCommErrAvgMaxCnt			 := MAX(usTecJetCommErrAvgMaxCnt, usTecJetCommErrFastAvgCnt[ucLoopCnt]);
					usTecErrCnt_Old[ucLoopCnt]			 := IN_HA.iTecErrCnt[ucLoopCnt];
				END_IF;
			END_IF;
			
			(* KLS98 - counter increase *)
			IF ucKLS98CommErrCount_Old[ucLoopCnt] <> ucKLS98CommErrCountDelayed[ucLoopCnt] THEN
				IF ucKLS98CommErrCountDelayed[ucLoopCnt] <> 0 THEN
					usKLS98CommErrAvgCnt[ucLoopCnt] := usKLS98CommErrAvgCnt[ucLoopCnt] + UINT_TO_USINT(ucKLS98CommErrCountDelayed[ucLoopCnt] - ucKLS98CommErrCount_Old[ucLoopCnt]);
				END_IF;
				
				usKLS98CommErrAvgMaxCnt 			:= MAX(usKLS98CommErrAvgMaxCnt, usKLS98CommErrAvgCnt[ucLoopCnt]);
				ucKLS98CommErrCount_Old[ucLoopCnt]	:= ucKLS98CommErrCountDelayed[ucLoopCnt];
			END_IF
			
			(* SAFI - counter increase *)
			IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN
				IF usSAFIComErrCnt_Old[ucLoopCnt] <> DINT_TO_UINT(IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100) THEN
					usSAFICommErrAvgCnt[ucLoopCnt]	:= usSAFICommErrAvgCnt[ucLoopCnt] + BOOL_TO_USINT((IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100) <> 0);
					usSAFICommErrAvgMaxCnt			:= MAX(usSAFICommErrAvgMaxCnt, usSAFICommErrAvgCnt[ucLoopCnt]);
					usSAFIComErrCnt_Old[ucLoopCnt]	:= UDINT_TO_UINT(IN_HA.iCnt_SA_ComErr[ucLoopCnt] / 100);
				END_IF;
			END_IF;	
		END_FOR;

		
		(*------------------------------------------------------------------------*)
		(* 1 hour max average storing *)
		usIC900CommErrAvg		:= MAX(usIC900CommErrAvg     , usIC900CommErrAvgCnt);
		usMonicCommErrAvg		:= MAX(usMonicCommErrAvg     , usMonicCommErrAvgCnt);
		usTecJetCommErrSlowAvg	:= MAX(usTecJetCommErrSlowAvg, usTecJetCommErrSlowAvgCnt);
		usTecJetCommErrAvgMax	:= MAX(usTecJetCommErrAvgMax , usTecJetCommErrAvgMaxCnt);
		
		FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
			
			(* TecJet - hour average *)
			IF ucLoopCnt <= 4 THEN
				usTecJetCommErrFastAvg[ucLoopCnt] := MAX(usTecJetCommErrFastAvg[ucLoopCnt],usTecJetCommErrFastAvgCnt[ucLoopCnt]);
			END_IF;
			
			(* KLS98 - hour average *)
			usKLS98CommErrAvg[ucLoopCnt] := MAX(usKLS98CommErrAvg[ucLoopCnt], usKLS98CommErrAvgCnt[ucLoopCnt]);

			(* SAFI - hour average *)
			IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN
				usSAFICommErrAvg[ucLoopCnt] := MAX(usSAFICommErrAvg[ucLoopCnt], usSAFICommErrAvgCnt[ucLoopCnt]);
			END_IF;	
			
		END_FOR;
		
		usKLS98CommErrAvgMax	:= MAX(usKLS98CommErrAvgMax	, usKLS98CommErrAvgMaxCnt);
		usSAFICommErrAvgMax		:= MAX(usSAFICommErrAvgMax	, usSAFICommErrAvgMaxCnt);
		
		
		(*=========================================================================*)
		(* Reset Error Counter                                                     *)  
		(*=========================================================================*)
		
		(* reset average counter with ervery new hour *)
		IF iCnt_OpHours_old <> IN_HA.iCnt_OpHours THEN
			
			usIC900CommErrAvgCnt		:= 0;
			usTecJetCommErrSlowAvgCnt	:= 0;
			usTecJetCommErrAvgMaxCnt	:= 0;
			
			FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
				
				IF ucLoopCnt <= 4 THEN
					usTecJetCommErrFastAvgCnt[ucLoopCnt] := 0;
				END_IF;
				
				usKLS98CommErrAvgCnt[ucLoopCnt] := 0;
				
				IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN
					usSAFICommErrAvgCnt[ucLoopCnt] := 0;
				END_IF;	
				
			END_FOR;
			
			usKLS98CommErrAvgMaxCnt	:= 0;
			usMonicCommErrAvgCnt	:= 0;
			usSAFICommErrAvgMax		:= 0;
			iCnt_OpHours_old		:= IN_HA.iCnt_OpHours;
			
		END_IF;
		
		
		(*------------------------------------------------------------------------*)
		(* reset error max and phase values *)
		xTOF_CANReset.IN := VIS2MM.bCANCntReset;
		xTOF_CANReset.PT := T#1s;
		xTOF_CANReset();
		
		VIS2MM.bCANCntReset := FALSE;
		OUT_HA.bCANCntReset := xTOF_CANReset.Q;
		
		IF xTOF_CANReset.Q THEN

			(*------------------------------------------------------------------------*)
			(* reset "ERROR NUMBER" and "DEVICE GO ID" *)
			CANopen_error 					:= 0;
			IN_HA.tSAFI_CanGo.CANDevGo[1]	:= 0;
	
			(*------------------------------------------------------------------------*)
			(* reset maximum values *)
			ucIC900CommErrMax		:= 0;
			ucTecJetCommErrSlowMax	:= 0;
			usTecJetCommErrMax		:= 0;
			usTecJetCommErrMaxAll	:= 0;
			
			FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
				
				IF ucLoopCnt <= 4 THEN
					IN_HA.iTecErrCnt[ucLoopCnt]			:= 0;		(* reset current value *)
					IN_HA.iTecErrCntMax[ucLoopCnt]		:= 0;		(* reset max value in task gas_flow *)
					usTecJetCommErrFastMax[ucLoopCnt]	:= 0;
				END_IF;
				
				ucKLS98CommErrMax[ucLoopCnt] := 0;
				
				IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN
					usSAFICommErrMax[ucLoopCnt] := 0;
				END_IF;
				
			END_FOR;
			
			ucKLS98CommErrMaxAll	:= 0;
			ucMonicCommErrMax		:= 0;
			usSAFICommErrMaxAll		:= 0;
				
			(*------------------------------------------------------------------------*)
			(* reset phase counter *)
			usIC900PhaseCnt			:= 0;
			usTecJetSlowPhaseCnt	:= 0;
			
			FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
				
				IF ucLoopCnt <= 4 THEN
					usTecJetFastPhaseCnt[ucLoopCnt] := 0;
				END_IF;
				
				usKLS98PhaseCnt[ucLoopCnt] := 0;
				
				IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN	
					usSAFIPhaseCnt[ucLoopCnt] := 0;
				END_IF;	
				
			END_FOR;
			
			usTecJetFastPhaseCntMax	:= 0;
			usKLS98PhaseCntMax		:= 0;
			usMonicPhaseCnt			:= 0;
			usSAFIPhaseCntMax		:= 0;
			
			(*------------------------------------------------------------------------*)
			(* reset phase detection bits *)
			bIC900PhaseDetected		 := FALSE;
			bTecJetSlowPhaseDetected := FALSE;
			
			FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
				
				IF ucLoopCnt <= 4 THEN
					bTecJetFastPhaseDetected[ucLoopCnt] := FALSE;
				END_IF;
				
				bKLS98PhaseDetected[ucLoopCnt] := FALSE;
				
				IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN
					bSAFIPhaseDetected[ucLoopCnt] := FALSE;
				END_IF;	
				
			END_FOR;
			
			bMonicPhaseDetected 	 := FALSE;
	
			(*------------------------------------------------------------------------*)
			(* reset average max (1h max) values *)
			usIC900CommErrAvg		:= 0;
			usTecJetCommErrSlowAvg	:= 0;
			usTecJetCommErrAvgMax	:= 0;
			
			FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
				
				IF ucLoopCnt <= 4 THEN
					usTecJetCommErrFastAvg[ucLoopCnt] := 0;
				END_IF;
				
				usKLS98CommErrAvg[ucLoopCnt] := 0;
				
				IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN
					usSAFICommErrAvg[ucLoopCnt] := 0;
				END_IF;	
				
			END_FOR;
			
			usKLS98CommErrAvgMax	:= 0;
			usMonicCommErrAvg		:= 0;
			usSAFICommErrAvgMax		:= 0;
			
			(*------------------------------------------------------------------------*)
			(* reset average counter values *)
			usIC900CommErrAvgCnt		:= 0;
			usTecJetCommErrSlowAvgCnt	:= 0;
			usTecJetCommErrAvgMaxCnt	:= 0;
			
			FOR ucLoopCnt := 1 TO xEngType.NumberOfCylinder DO
				
				IF ucLoopCnt <= 4 THEN
					usTecJetCommErrFastAvgCnt[ucLoopCnt] := 0;
				END_IF;
				
				usKLS98CommErrAvgCnt[ucLoopCnt] := 0;
				
				IF ucLoopCnt <= xEngType.NumberOfCylinder/2 THEN
					usSAFICommErrAvgCnt[ucLoopCnt] := 0;	
				END_IF;	
				
			END_FOR;
			
			usKLS98CommErrAvgMaxCnt	:= 0;
			usSAFICommErrAvgMaxCnt	:= 0;
			usMonicCommErrAvgCnt	:= 0;
			iCnt_OpHours_old		:= IN_HA.iCnt_OpHours;
	
		END_IF;
	END_IF;	
		
END_PROGRAM
