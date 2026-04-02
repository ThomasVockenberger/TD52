(*******************************************************************************
VibMonEG: Vigration monitoring engine / generator (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021     

- monitoring of vibration values incl. frequency bands
- determine max velocity and frequencay at maximum

Customized modifications: -
------------------------

History:
-------
V4.11	25-05-2021	Weitzer, 	generated

Instructions FOR use:
--------------------
Sensor 1: Generator horizontal
Sensor 2: Generator vetical
Sensor 3: Engine horizontal
Sensor 4: Engine vetical

Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC

	(* code is only executed if function is activated by parameter and if system has completed the start up *)
	IF Para.bVibSens_Act AND IN_EG.tPB2MM.bSys_Run THEN
		
		(* mapping of data points from 4 vibration sensors *)
		FOR usCount := 0 TO 3 DO
		
			(* check if vibraton sensore wire break detected and engine speed is below start limit *)
			IF bVibSens_BrokenWire[usCount+1] OR IN_EG.rN_EngAct < Para.rN_EngStart_LimHi THEN
				(* vibration sensor live RMS values [mm/s]*)	
				MM2VIS.rVel_VibSens[usCount+9] := 0;
				(* vibration sensor live frequency band [mm/s] *)
				MM2VIS.rVel_VibSens_Band1[usCount+9] := 0;
				MM2VIS.rVel_VibSens_Band2[usCount+9] := 0;
				MM2VIS.rVel_VibSens_Band3[usCount+9] := 0;
				MM2VIS.rVel_VibSens_Band4[usCount+9] := 0;
				MM2VIS.rVel_VibSens_Band5[usCount+9] := 0;
				MM2VIS.rVel_VibSens_Band6[usCount+9] := 0;
				MM2VIS.rVel_VibSens_Band7[usCount+9] := 0;
				MM2VIS.rVel_VibSens_Band8[usCount+9] := 0;
				(* vibration sensor max values *)
				MM2VIS.rVel_VibSens_Max[usCount+9] := 0;
				MM2VIS.rF_VibSens_Max[usCount+9]   := 0;
			(* check if no vibraton sensore overflow detected *)
			ELSIF NOT bVibSens_Overflow[usCount+1] THEN
				(* vibration sensor live RMS values [mm/s]*)
				MM2VIS.rVel_VibSens[usCount+9] := rVel_VibSens[usCount+1];					(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
				(* vibration sensor live frequency band [mm/s] *)
				MM2VIS.rVel_VibSens_Band1[usCount+9] := rVel_VibSens_Band[usCount*8+1];		(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
				MM2VIS.rVel_VibSens_Band2[usCount+9] := rVel_VibSens_Band[usCount*8+2];		(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
				MM2VIS.rVel_VibSens_Band3[usCount+9] := rVel_VibSens_Band[usCount*8+3];		(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
				MM2VIS.rVel_VibSens_Band4[usCount+9] := rVel_VibSens_Band[usCount*8+4];		(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
				MM2VIS.rVel_VibSens_Band5[usCount+9] := rVel_VibSens_Band[usCount*8+5];		(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
				MM2VIS.rVel_VibSens_Band6[usCount+9] := rVel_VibSens_Band[usCount*8+6];		(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
				MM2VIS.rVel_VibSens_Band7[usCount+9] := rVel_VibSens_Band[usCount*8+7];		(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
				MM2VIS.rVel_VibSens_Band8[usCount+9] := rVel_VibSens_Band[usCount*8+8];		(* mapping directly from IO mapping, no HALIO used for vibration mesarurement *)
			END_IF;		
			
		END_FOR;
		
		
		(* read buffer data *)
		
		(* generate time interval for reading buffer *)
		xTON_ReadCycle(IN := NOT xTON_ReadCycle.Q, PT :=  tiCM4810_ReadBuffer);
		
		(* generate start reading trigger *)
		IF IN_EG.tEng_Run.Do AND stpCM4810 = stpWaitStart AND xTON_ReadCycle.Q THEN
			iNum_VibSens := iNum_VibSens + 1;
			IF iNum_VibSens > 4 THEN
				iNum_VibSens := 1;
			END_IF;
			bStartBufferUpload 					   := TRUE;
			xCM4810.paramBufferUpload.moduleBuffer := 66 + (iNum_VibSens-1) * 4;
		END_IF;	
		
		
		(* state engine to read of data buffer *)
		
		CASE stpCM4810 OF
			//---------------------------------------------
			// wait for init done
			//---------------------------------------------
			stpInitDone:
				xCM4810.requestBufferLock := FALSE;
				xCM4810.uploadBuffer	  := FALSE;
				IF xCM4810.initDone AND xCM4810.moduleCfgUploadDone THEN
					stpCM4810 := stpWaitStart;
				END_IF;

			//---------------------------------------------
			// wait for start uplaod buffer
			//---------------------------------------------
			stpWaitStart:
				xCM4810.requestBufferLock := FALSE;
				xCM4810.uploadBuffer	  := FALSE;
				(* wait for start *)
				IF bStartBufferUpload THEN
					stpCM4810 := stpReqLockBuffer;
				END_IF;

			//---------------------------------------------
			// request lock buffer and wait until valid
			//---------------------------------------------
			stpReqLockBuffer:
				xCM4810.requestBufferLock := TRUE;
				bStartBufferUpload		  := FALSE; (* reset command start *)
				IF xCM4810.bufferLockValid THEN
					xCM4810.uploadBuffer := TRUE;
					stpCM4810			 := stpUploadBuffer;
				END_IF;

			//---------------------------------------------
			// upload buffer
			//---------------------------------------------
			stpUploadBuffer:
				IF xCM4810.bufferUploadDone THEN
					stpCM4810 := stpReqUnlockBuffer;
				END_IF;
				IF xCM4810.status <> ERR_FUB_BUSY AND xCM4810.status <> ERR_OK THEN
					stpCM4810 := stpError;
				END_IF
		
			//---------------------------------------------
			// unlock buffer and wait until valid
			//---------------------------------------------
			stpReqUnlockBuffer:
				xCM4810.requestBufferLock := FALSE;
				xCM4810.uploadBuffer	  := FALSE;
				IF NOT xCM4810.bufferLockValid THEN
					bGetFrequencyMax := TRUE;
					stpCM4810		 := stpWaitStart;
				END_IF;
					
			//---------------------------------------------
			// error
			//---------------------------------------------
			stpError:
			// no action!		
	
		END_CASE; 

		xCM4810.paramMain.pModulePath			  := ADR(sCM4810Addr);
		xCM4810.paramBufferUpload.pArrayXaxis	  := ADR(rData_x_Axis);
		xCM4810.paramBufferUpload.pArrayYaxis	  := ADR(rData_y_Axis);

		xCM4810(); (* call FUB exactly once per cycle *)
		
		
		(* get value & frequency max *)
		
		IF bGetFrequencyMax THEN
			
			MM2VIS.rF_VibSens_Max[iNum_VibSens+8]   := 0.0;		(* reset x(y max) max *)
			rVel_y_Axis_Max := 0.0;										(* reset y max *)
			usMaxIndex := 0;
			FOR usCount := 1 TO AxisArrayMaxIndex DO
				(* Upper limit for max value search at 500 Hz *)
				IF rData_x_Axis[usCount] > 500.0 THEN
					EXIT;
				END_IF	
				(*find max signal value *)
				IF rData_y_Axis[usCount] > rVel_y_Axis_Max THEN	
					rVel_y_Axis_Max := rData_y_Axis[usCount];		(* max virbration value *)
					MM2VIS.rF_VibSens_Max[iNum_VibSens+8]   := rData_x_Axis[usCount];		(* frequency at max virbration value *)
					usMaxIndex := usCount;
				END_IF	
			END_FOR;
			
			(* correction of buffer value *)
			IF usMaxIndex > 1 AND usMaxIndex < (AxisArrayMaxIndex-2) THEN
				MM2VIS.rVel_VibSens_Max[iNum_VibSens+8] := 2.0/SQRT(3.0/2.0)*SQRT(0.5*(EXPT(rData_y_Axis[usMaxIndex-2],2)+EXPT(rData_y_Axis[usMaxIndex-1],2)+EXPT(rData_y_Axis[usMaxIndex],2)+EXPT(rData_y_Axis[usMaxIndex+1],2)+EXPT(rData_y_Axis[usMaxIndex+2],2)));
			ELSE	
				MM2VIS.rVel_VibSens_Max[iNum_VibSens+8] := 0.0;		
			END_IF;
			
			bGetFrequencyMax := FALSE;
		END_IF;
		
		
		(* calculate and display center frequency at the HMI *)
		
//		MM2VIS.rF_VibSens_CenterBand1 := Para.rN_EngNom/60.0*Para.rIdx_VibSens_BandOrder1;
//		MM2VIS.rF_VibSens_CenterBand2 := Para.rN_EngNom/60.0*Para.rIdx_VibSens_BandOrder2;
//		MM2VIS.rF_VibSens_CenterBand3 := Para.rN_EngNom/60.0*Para.rIdx_VibSens_BandOrder3;
//		MM2VIS.rF_VibSens_CenterBand4 := Para.rN_EngNom/60.0*Para.rIdx_VibSens_BandOrder4;
//		MM2VIS.rF_VibSens_CenterBand5 := Para.rN_EngNom/60.0*Para.rIdx_VibSens_BandOrder5;
//		MM2VIS.rF_VibSens_CenterBand6 := Para.rN_EngNom/60.0*Para.rIdx_VibSens_BandOrder6;
//		MM2VIS.rF_VibSens_CenterBand7 := Para.rN_EngNom/60.0*Para.rIdx_VibSens_BandOrder7;
//		MM2VIS.rF_VibSens_CenterBand8 := Para.rN_EngNom/60.0*Para.rIdx_VibSens_BandOrder8;
		
		
		(* check if band upper and lower frequency limit has to be set *)

		IF NOT bWrite THEN
			
			IF ucWriteBandCnt = 0 THEN
				
				IF Para.rIdx_VibSens_BandWidth <> rIdx_VibSens_BandWidtOld THEN
					rIdx_VibSens_BandWidtOld := Para.rIdx_VibSens_BandWidth;
					rCenterBandOld1			 := 0.0;
					rCenterBandOld2			 := 0.0;
					rCenterBandOld3			 := 0.0;
					rCenterBandOld4			 := 0.0;
					rCenterBandOld5			 := 0.0;
					rCenterBandOld6			 := 0.0;
					rCenterBandOld7			 := 0.0;
					rCenterBandOld8			 := 0.0;
				ELSIF MM2VIS.rF_VibSens_CenterBand1 <> rCenterBandOld1 THEN
					rCenterBandOld1 := MM2VIS.rF_VibSens_CenterBand1;
					ucWriteBandCnt  := 1;
				ELSIF MM2VIS.rF_VibSens_CenterBand2 <> rCenterBandOld2 THEN
					rCenterBandOld2 := MM2VIS.rF_VibSens_CenterBand2;
					ucWriteBandCnt  := 9;
				ELSIF MM2VIS.rF_VibSens_CenterBand3 <> rCenterBandOld3 THEN
					rCenterBandOld3 := MM2VIS.rF_VibSens_CenterBand3;
					ucWriteBandCnt  := 17;					
				ELSIF MM2VIS.rF_VibSens_CenterBand4 <> rCenterBandOld4 THEN
					rCenterBandOld4 := MM2VIS.rF_VibSens_CenterBand4;
					ucWriteBandCnt  := 25;					
				ELSIF MM2VIS.rF_VibSens_CenterBand5 <> rCenterBandOld5 THEN
					rCenterBandOld5 := MM2VIS.rF_VibSens_CenterBand5;
					ucWriteBandCnt  := 33;					
				ELSIF MM2VIS.rF_VibSens_CenterBand6 <> rCenterBandOld6 THEN
					rCenterBandOld6 := MM2VIS.rF_VibSens_CenterBand6;
					ucWriteBandCnt  := 41;					
				ELSIF MM2VIS.rF_VibSens_CenterBand7 <> rCenterBandOld7 THEN
					rCenterBandOld7 := MM2VIS.rF_VibSens_CenterBand7;
					ucWriteBandCnt  := 49;					
				ELSIF MM2VIS.rF_VibSens_CenterBand8 <> rCenterBandOld8 THEN
					rCenterBandOld8 := MM2VIS.rF_VibSens_CenterBand8;
					ucWriteBandCnt  := 57;					
				END_IF;

			END_IF;
			
			(* writing of the single band limit registers *)
			CASE ucWriteBandCnt OF
			
				(* Band 1 - Sensor 1 *)
				1:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand01LowerFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand1 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 2;
				2:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand01UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand1 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 3;		
				(* Band 1 - Sensor 2 *)
				3:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand09LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand1 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 4;
				4:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand09UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand1 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 5;		
				(* Band 1 - Sensor 3 *)
				5:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand17LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand1 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 6;
				6:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand17UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand1 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 7;	
				(* Band 1 - Sensor 4 *)
				7:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand25LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand1 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 8;
				8:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand25UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand1 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 0;						

					(* Band 2 - Sensor 1 *)
				9:  bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand02LowerFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand2 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 10;
				10: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand02UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand2 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 11;		
					(* Band 2 - Sensor 2 *)
				11: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand10LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand2 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 12;
				12: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand10UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand2 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 13;		
					(* Band 2 - Sensor 3 *)
				13: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand18LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand2 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 14;
				14: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand18UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand2 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 15;	
					(* Band 2 - Sensor 4 *)
				15: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand26LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand2 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 16;
				16: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand26UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand2 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 0;						
					
					(* Band 3 - Sensor 1 *)
				17: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand03LowerFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand3 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 18;
				18: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand03UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand3 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 19;		
					(* Band 3 - Sensor 2 *)
				19: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand11LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand3 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 20;
				20: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand11UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand3 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 21;		
					(* Band 3 - Sensor 3 *)
				21: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand19LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand3 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 22;
				22: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand19UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand3 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 23;	
					(* Band 3 - Sensor 4 *)
				23: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand27LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand3 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 24;
				24: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand27UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand3 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 0;	
		
					(* Band 4 - Sensor 1 *)
				25: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand04LowerFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand4 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 26;
				26: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand04UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand4 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 27;		
					(* Band 4 - Sensor 2 *)
				27: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand12LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand4 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 28;
				28: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand12UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand4 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 29;		
					(* Band 4 - Sensor 3 *)
				29: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand20LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand4 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 30;
				30: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand20UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand4 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 31;	
					(* Band 4 - Sensor 4 *)
				31: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand28LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand4 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 32;
				32: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand28UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand4 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 0;						
					
					(* Band 5 - Sensor 1 *)
				33: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand05LowerFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand5 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 34;
				34: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand05UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand5 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 35;		
					(* Band 5 - Sensor 2 *)
				35: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand13LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand5 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 36;
				36: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand13UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand5 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 37;		
					(* Band 5 - Sensor 3 *)
				37: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand21LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand5 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 38;
				38: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand21UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand5 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 39;	
					(* Band 5 - Sensor 4 *)
				39: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand29LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand5 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 40;
				40: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand29UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand5 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 0;	
										
					(* Band 6 - Sensor 1 *)
				41: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand06LowerFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand6 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 42;
				42: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand06UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand6 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 43;		
					(* Band 6 - Sensor 2 *)
				43: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand14LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand6 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 44;
				44: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand14UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand6 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 45;		
					(* Band 6 - Sensor 3 *)
				45: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand22LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand6 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 46;
				46: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand22UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand6 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 47;	
					(* Band 6 - Sensor 4 *)
				47: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand30LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand6 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 48;
				48: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand30UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand6 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 0;						
					
					(* Band 7 - Sensor 1 *)
				49: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand07LowerFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand7 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 50;
				50: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand07UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand7 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 51;		
					(* Band 7 - Sensor 2 *)
				51: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand15LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand7 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 52;
				52: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand15UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand7 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 53;		
					(* Band 7 - Sensor 3 *)
				53: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand23LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand7 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 54;
				54: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand23UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand7 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 55;	
					(* Band 7 - Sensor 4 *)
				55: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand31LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand7 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 56;
				56: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand31UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand7 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 0;				
					
					(* Band 8 - Sensor 1 *)
				57: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand08LowerFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand8 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 58;
				58: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand08UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand8 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 59;		
					(* Band 8 - Sensor 2 *)
				59: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand16LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand8 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 60;
				60: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand16UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand8 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 61;		
					(* Band 8 - Sensor 3 *)
				61: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand24LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand8 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 62;
				62: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand24UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand8 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 63;	
					(* Band 8 - Sensor 4 *)
				63: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand32LowerFrequency';		
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand8 - Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 64;
				64: bWrite		 		 := TRUE;
					szWriteConfig		 := 'FrequencyBand32UpperFrequency';
					xAsIOAccWrite1.value := LIMIT(1,REAL_TO_UDINT(4.0*(MM2VIS.rF_VibSens_CenterBand8 + Para.rIdx_VibSens_BandWidth/2)),40000);
					ucWriteBandCnt		 := 0;					
			
			END_CASE;
			
		END_IF;		

		
		(* read & write X204810 registers *)
		
		(* write band configuration and miscellaneous values *)
		IF bWrite THEN														(* set bWrite to TRUE to write a register on the CM48810 X20 module *)
			xAsIOAccWrite1.enable	    := TRUE;
			xAsIOAccWrite1.pDeviceName  := xCM4810.paramMain.pModulePath;
//			xAsIOAccWrite1.value	    := 0;								(* set value to write at this attribute of the function block *)
			xAsIOAccWrite1.pChannelName	:= ADR(szWriteConfig);				(* set name of register to write at string pv szWriteConfig *)
			xAsIOAccWrite1();
			
			IF xAsIOAccWrite1.status = 0 THEN
				bWrite := FALSE;
			END_IF;		
		END_IF;
	
	
		(* read miscellaneous values *)
		IF bRead THEN														(* set bRead to TRUE to read a register from the CM48810 X20 module *)
			xAsIOAccRead1.enable	   := TRUE;
			xAsIOAccRead1.pDeviceName  := xCM4810.paramMain.pModulePath;
//			xAsIOAccRead1.value;											(* here the read valure can be found *)
			xAsIOAccRead1.pChannelName := ADR(szReadConfig);				(* set name of register to read at string pv szReadConfig *)
			xAsIOAccRead1();
		
			IF xAsIOAccRead1.status = 0 THEN
				bRead := FALSE;
			END_IF;	
		END_IF;
		
	END_IF;		

END_PROGRAM


