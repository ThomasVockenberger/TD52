(***********************************************************************************************************************
AGGR: oil consumption counting and saving data (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2024
																					
- detection of oilcounter impulses
- logging oil volume(ml) and active energy(kwh)

																													
Customized modifications: -
------------------------
 
History:
-------																							
V2.0	26.06.2007	TinelloM 	erstellt																			
V2.1	16.08.2007 	TinelloM 	überarbeitet																	
V2.3	31.03.2008 	TinelloM	überarbeitet für Serie
V3.20	20.07.2010	KoppM		anpassung für BR9 und analogen Füllstandsensor
V3.20.1	08.02.2011	TinelloM	IF ucIndexOil >1...
V3.90.0	06.12.2011	Ganguly		generated from oilcountCyclic.st V3.20.1
V3.90.1	12.03.2012	Denk		review and clean-up
V3.91	03.09.2013	Zengerer 	BUGFIX in nextline copy : OilCounter[i]	:= OilCounter[i+1];	
V3.99.0 04.12.2013	lettenb.	slOilCounterMax,rSumOilVolume,rSumActiveEnergy: conversion dint_to_real added
V4.00.0	03.11.2014	lettenb.	init: DatObjCreate_01.MemType:= doSYSROM --> doUSRROM (vis kann bei update nicht in SYSROM schreiben)
		28.04.2015				set rAvgVolumeEnergy:=0 IF no averaging is selected, bugfix
V4.03.0	03.11.2015	lettenb.	calc. rAvgVolumeEnergy corr., bugfix
		11.01.2016				MM2VIS oil counter interfaces moved from Vis_AG -> Cnt_EO(to enable scroll function of settings)bugfix
		15.02.2016  waldhart	datenpunkte für HMI aus der IF-schleife entfernt(P19 test)
V4.05.0	14.12.2017	lettenb.	IN_AG.rP_Act_Norm_Filt -> IN_AG.rP_Act_Norm_Filt_TC2, mapping cleanup
		27.12.2017				bReset_Bh added, to reset oil counter memory after engine change(iCnt_OpHours -> 0)
V4.06.0 005 11.09.2018 Zengerer	beta: OUT_AG.tAG2PB.bPermSetupOk... new: transmit perm status info in InitUp 
V4.07				Zengerer	Do not allow old data file lengt in init, to force rebuild with latest file format !
V4.09.0	09.10.2019	Schmid		BU1: reduced number of perm file write cycles (max every 10min)
V4.10.0	03.12.2020	Perktold,	added oil and coolant management
		25.01.2021	Schmid		bugfix oil refill blockade after iCnt_OpHours reset (engine exchange)
		11.03.2021	lettenb.	9004->9048, Msg# already used, bugfix
V4.11.0	19.01.2022	Schmid		option for oil sampling interval from oil quality sensor
V4.12.0	29.03.2023	Tinello		bugfix #1092 oil counter reset 
V4.13.0	13.02.2024	Tinello		oil refill monitoring
																							
Instructions for use:
--------------------
The parameter are stored in a data module which is stored on flash memory.
At start up the parameter will be readed from the flash memory and copied to

Outstandings:
------------																											
-																												
***********************************************************************************************************************)

PROGRAM _CYCLIC

(* getting time of the controller *)
	DTGetTime_RPS.enable := TRUE;							(* getting *)
	DTGetTime_RPS();										
	DT_TO_DTStructure(DTGetTime_RPS.DT1, ADR(tRealTime));	(* change format *)
	DTGetTime_RPS.status;
	

	(* oil counter is active *)
	IF Para.b_OilActive THEN
			
		(* oilcounter impulse detection *)
		xR_TRIG_OilCounterImpulse(CLK := IN_AG.tCnt_OilPulse.Di);
		IF xR_TRIG_OilCounterImpulse.Q THEN  slOilCounterImpulse := slOilCounterImpulse + 1;	END_IF

		(* reset *)
		IF ucResetRegister1 = 0	THEN slOilCounterImpulse := 0;	END_IF

		
		(* oilcounter impulse detection for X20DC2395 --> Reset not possible *)
		IF REAL_TO_UINT(IN_AG.tCnt_Oil_DC2395.Ai) >= usOilCounterStart	THEN				
			slOilCounterCircle	:= (REAL_TO_DINT(IN_AG.tCnt_Oil_DC2395.Ai) - usOilCounterStart) / 2;
		ELSE
			slOilCounterCircle	:= (REAL_TO_DINT(IN_AG.tCnt_Oil_DC2395.Ai) - usOilCounterStart + 65535) / 2;
		END_IF
			
		
		(* generate second based clock pulse *)
		xTON_SecondTick(IN := NOT xTON_SecondTick.Q, PT := T#980ms);		(* 980ms + 2 times cycle time = 1 sec.*)

		IF xTON_SecondTick.Q THEN				
	
			(* reset *)
			bErrMsOilCounter	:= FALSE;						
			b_OilRefillBlocked	:= FALSE;

			FOR i:=0 TO 19 BY 1 DO
				IF IN_AG.iCnt_OpHours > 0 AND IN_AG.iCnt_OpHours + 10000 < OilCounter[i].Bh THEN bReset_Bh := TRUE; (* reset OpHours(engine change)*)
				END_IF;
			END_FOR;
				
			(* Delete circular puffer array of oil measurements *)
			IF bReset_Bh THEN									
				FOR i:=0 TO 19 BY 1 DO
					OilCounter[i].oil_volume		:= 0;
					OilCounter[i].delta_kwh 		:= 0;
					OilCounter[i].day 				:= 0;
					OilCounter[i].month 			:= 0;
					OilCounter[i].year 				:= 0;
					OilCounter[i].hour 				:= 0;
					OilCounter[i].minute 			:= 0;
					OilCounter[i].averaging			:= 0;
					OilCounter[i].Bh				:= 0;
					OilCounter[i].rOC_Consum		:= 0;
					OilCounter[i].rOC_DeltaOpHour	:= 0;
					OilCounter[i].rP_OC_Avg			:= 0;
				END_FOR

				ucIndexOil 	:= 0;										(* reset circular puffer index	*)
				bReset_Bh	:= FALSE;
			END_IF


			(* Identification of active oil counter input *)
			slOilCounterMax	:= MAX(slOilCounterCircle, slOilCounterImpulse);
			slOilCounterMax	:= REAL_TO_DINT(MAX(DINT_TO_REAL(slOilCounterMax), IN_AG.tCnt_Oil_NC150.Ai));
	
			slOilCounter	:= slOilCounterMax * 					(* maximum number of oil counter impulses 		*)	
						   	   Para.iNum_OilPulse;					(* 1 impulse e.g.=2ml, -> 500 impulses/liter	*)

		
			(* Oil refill monitoring *)
			rVol_OilRefill_Max		:= (Para.rVol_OilRefill_Pct_EO_Level * 1000)	  *		(* oil refill volume [ml] per % oil level *)
									   (Para.r_OV_LimClose - Para.r_OV_LimOpen) * 100 *		(* % oil level between open- and closing of valve *)
									   (1.0 + Para.rPc_OilRefill_VolTolerance);				(* Tolerance *)

			bAMM_Vol_OilRefill_Hi	:= (slOilCounter > REAL_TO_DINT(rVol_OilRefill_Max)) AND Para.bOilRefill_MonAct AND Para.bEO_Level_Active;		(* W9378 *)


			(* calculation of kilowatt hour *)
			IF (IN_AG.rP_Act_Norm_Filt_TC2 * IN_AG.rP_Nom) > 50	THEN 									
				kwh	:= kwh + ((IN_AG.rP_Act_Norm_Filt_TC2 * IN_AG.rP_Nom) / 3600 );
			END_IF


			(* When Oilrefillvalve is closed, data will be saved *)
		 	xF_TRIG_OilRefillValve(CLK := OUT_AG.tEOVal_DemOpen.Do);					

		 	IF 	xF_TRIG_OilRefillValve.Q	THEN				
				(* monitoring measurement signal oil counter *)
				IF slOilCounter < 20 THEN	bErrMsOilCounter := TRUE;	END_IF
		   
				(* Save oil data *)
				IF ucIndexOil >= 20 THEN
					(*----------------------------------------------------------------------------------*)
					(* After 20 measurements the data will be copied, so that the actual measurement	*)
					(* is allways shown in the last line.	 											*)
					(*----------------------------------------------------------------------------------*)
					FOR i:=0 TO 18 BY 1 DO
						OilCounter[i]			 		:= OilCounter[i+1];					
//						OilCounter[i].oil_volume 		:= OilCounter[i+1].oil_volume;
//						OilCounter[i].delta_kwh			:= OilCounter[i+1].delta_kwh;
//						OilCounter[i].day				:= OilCounter[i+1].day;
//						OilCounter[i].month				:= OilCounter[i+1].month;
//						OilCounter[i].year				:= OilCounter[i+1].year;
//						OilCounter[i].hour				:= OilCounter[i+1].hour;
//						OilCounter[i].minute			:= OilCounter[i+1].minute;
//						OilCounter[i].averaging			:= OilCounter[i+1].averaging;
//						OilCounter[i].Bh				:= OilCounter[i+1].Bh;
					END_FOR

					OilCounter[19].oil_volume 			:= slOilCounter;		(* Save	actual measurement	*)
					OilCounter[19].delta_kwh			:= REAL_TO_DINT(kwh);
					OilCounter[19].day					:= USINT_TO_INT(tRealTime.day);
					OilCounter[19].month				:= USINT_TO_INT(tRealTime.month);
					OilCounter[19].year					:= UINT_TO_INT(tRealTime.year);
					OilCounter[19].hour 				:= USINT_TO_INT(tRealTime.hour);
					OilCounter[19].minute    			:= USINT_TO_INT(tRealTime.minute);
					OilCounter[19].averaging			:= TRUE;
					OilCounter[19].Bh					:= IN_AG.iCnt_OpHours;
				ELSE
					OilCounter[ucIndexOil].oil_volume 	:= slOilCounter;		(* Save	actual measurement	*)
					OilCounter[ucIndexOil].delta_kwh	:= REAL_TO_DINT(kwh);
					OilCounter[ucIndexOil].day			:= USINT_TO_INT(tRealTime.day);
					OilCounter[ucIndexOil].month		:= USINT_TO_INT(tRealTime.month);
					OilCounter[ucIndexOil].year			:= UINT_TO_INT(tRealTime.year);
					OilCounter[ucIndexOil].hour	 		:= USINT_TO_INT(tRealTime.hour);
					OilCounter[ucIndexOil].minute		:= USINT_TO_INT(tRealTime.minute);
					OilCounter[ucIndexOil].averaging	:= TRUE;
					OilCounter[ucIndexOil].Bh			:= IN_AG.iCnt_OpHours;

					ucIndexOil 	:= ucIndexOil + 1;								(* increase Index	*)
				END_IF

				(* reset kwh and oil counter	*)
				kwh 				:= 0;										(* reset kwh *)
				ucResetRegister1	:= 0;										(* Reset Counter(NC150)	*)
				usOilCounterStart 	:= REAL_TO_UINT(IN_AG.tCnt_Oil_DC2395.Ai);	(* initial Value *)

			ELSE
				ucResetRegister1	:= 128; 									(* binär 10000000 *)
	
				(* get oil counter settings from vis *)
				FOR i:=0 TO 19 BY 1 DO
					OilCounter[i].averaging	:= MM2VIS.tEO_Counter[i].averaging;
				END_FOR;


			END_IF


			(* oil counter values to vis *)
			FOR i:=0 TO 19 BY 1 DO
					MM2VIS.tEO_Counter[i].oil_volume		:= OilCounter[i].oil_volume;
					MM2VIS.tEO_Counter[i].delta_kwh 		:= OilCounter[i].delta_kwh;
					MM2VIS.tEO_Counter[i].day 				:= OilCounter[i].day;
					MM2VIS.tEO_Counter[i].month 			:= OilCounter[i].month;	
					MM2VIS.tEO_Counter[i].year 				:= OilCounter[i].year;
					MM2VIS.tEO_Counter[i].hour 				:= OilCounter[i].hour;	
					MM2VIS.tEO_Counter[i].minute 			:= OilCounter[i].minute;	
					MM2VIS.tEO_Counter[i].Bh				:= OilCounter[i].Bh;
					MM2VIS.tEO_Counter[i].rOC_DeltaOpHour	:= OilCounter[i].rOC_DeltaOpHour;
					MM2VIS.tEO_Counter[i].rP_OC_Avg			:= OilCounter[i].rP_OC_Avg;
					MM2VIS.tEO_Counter[i].rOC_Consum		:= OilCounter[i].rOC_Consum;
	
					MM2VIS.tEO_Counter[i].averaging			:= OilCounter[i].averaging;		
			END_FOR;



			(* averaging *)
			rSumOilVolume		:= 0;											(* reset sum of oil volume		*)
			rSumActiveEnergy	:= 0;											(* reset sum of active energy	*)
			rSumVolumeEnergy	:= 0;											(* reset sum of active volume/energy	*)
			ssAveragingNumber	:= 0;											(* reset averaging number		*)

			FOR i:=0 TO 19 BY 1	DO
				IF OilCounter[i].averaging	THEN							
					rSumOilVolume		:= rSumOilVolume     + DINT_TO_REAL(OilCounter[i].oil_volume);	(* sum of oil volume	*)
					rSumActiveEnergy 	:= rSumActiveEnergy  + DINT_TO_REAL(OilCounter[i].delta_kwh);	(* sum of active energy	*)
					rSumVolumeEnergy 	:= rSumVolumeEnergy  + OilCounter[i].rOC_Consum;				(* sum of active consumption *)
					ssAveragingNumber	:= ssAveragingNumber + 1;										(* averaging number	*)
				END_IF
			END_FOR
			
	
			IF ssAveragingNumber = 0	THEN										(* DIVISION by zero *)
				rAvgOilVolume		:= 0;											(* No averaging	*)
				rAvgActiveEnergy  	:= 0;											(* No averaging	*)
				rAvgVolumeEnergy  	:= 0;											(* No averaging	*)
			ELSE
				rAvgOilVolume 		:= rSumOilVolume	/ ssAveragingNumber;		(* average over oil volume		*)
				rAvgActiveEnergy	:= rSumActiveEnergy / ssAveragingNumber;		(* average over active energy	*)
				IF rAvgActiveEnergy > 0.0 THEN
					rAvgVolumeEnergy	:= rAvgOilVolume * 0.89 / rAvgActiveEnergy; (* average over active oil volume / energy *)	
				END_IF;
			END_IF;

			(* last measurement oil data for DIA.NE VIS trend and array for DIA.NE VIS picture OilCounter *)
			IF ucIndexOil = 0	THEN
				rVol_OC			:= DINT_TO_REAL(OilCounter[0].oil_volume);		(* oil volume during the last measurement 			*)
				rP_OC_Energy 	:= DINT_TO_REAL(OilCounter[0].delta_kwh);		(* active energy during the last measurement 		*)
				slOilRefill_Bh	:= OilCounter[0].Bh;							(* operating hour up to the time of last oil refill	*)
				rOC_DeltaOpHour:= 0;											(* operating hours during the last measurement		*)
				rP_OC_Avg		:= 0;											(* average power during the last measurement		*)

				IF 	OilCounter[0].delta_kwh = 0 THEN									(* DIVISION by zero *)
					rOC_Consum	:= 0;
				ELSE	
					rOC_Consum	:= DINT_TO_REAL(OilCounter[0].oil_volume) * 0.89 / 		(* oil consumption during 	*)
								   DINT_TO_REAL(OilCounter[0].delta_kwh);				(* the last measurement		*)
				END_IF
				OilCounter[0].rOC_Consum := rOC_Consum;									(* operating hours during last measurement for VIS picture *)
			ELSE
				rVol_OC			:= DINT_TO_REAL(OilCounter[ucIndexOil-1].oil_volume);	(* oil volume during the last measurement 	*)
				rP_OC_Energy	:= DINT_TO_REAL(OilCounter[ucIndexOil-1].delta_kwh);	(* active energy during last measurement 	*)
				slOilRefill_Bh	:= OilCounter[ucIndexOil-1].Bh;							(* operating hour up to the last oil refill	*)
				IF ucIndexOil >1 THEN 
					rOC_DeltaOpHour		:= DINT_TO_REAL(OilCounter[ucIndexOil-1].Bh -	(* operating hours during last measurement	*)
								       	   OilCounter[ucIndexOil-2].Bh);
					OilCounter[ucIndexOil-1].rOC_DeltaOpHour := rOC_DeltaOpHour;		(* operating hours during last measurement for VIS picture *)
				END_IF
				
				IF rOC_DeltaOpHour = 0 THEN									(* DIVISION by zero *)
					rP_OC_Avg	:= 0;
				ELSE
					rP_OC_Avg	:= rP_OC_Energy / rOC_DeltaOpHour;			(* Average power during last measurement *)
				END_IF
				OilCounter[ucIndexOil-1].rP_OC_Avg	:= rP_OC_Avg;			(* Average power during last measurement for VIS picture *)
				
				IF 	OilCounter[ucIndexOil-1].delta_kwh = 0 THEN				(* DIVISION by zero *)
					rOC_Consum	:= 0;
				ELSE
					rOC_Consum	:= DINT_TO_REAL(OilCounter[ucIndexOil-1].oil_volume) * 0.89 /
								   DINT_TO_REAL(OilCounter[ucIndexOil-1].delta_kwh);		
				END_IF
				OilCounter[ucIndexOil-1].rOC_Consum	:= rOC_Consum;			(* operating hours during last measurement for VIS picture *)
			END_IF
	

			(* Blocking oil refill for X operating hours *)
			xCTU_OilRefillBlocked(CU:= (IN_AG.iCnt_OpHours = iOpH_OilRefillBlockPulse + 1), RESET:= xF_TRIG_OilRefillValve.Q, PV:= DINT_TO_UINT(Para.i_OilRefillBlocked));
			iOpH_OilRefillBlockPulse := IN_AG.iCnt_OpHours;
			IF IN_AG.iCnt_OpHours < (slOilRefill_Bh + Para.i_OilRefillBlocked) AND NOT xCTU_OilRefillBlocked.Q AND IN_AG.tEO_Level_Lo_TC2.Di AND NOT bEO_Level_Lo THEN
				b_OilRefillBlocked	:= TRUE; 
			END_IF

			(* calculated oil counter values to vis *)
			MM2VIS.rVol_OC_Avg			:= rAvgOilVolume;
			MM2VIS.rOC_Energy_Avg		:= rAvgActiveEnergy;
			MM2VIS.rP_OC_Energy			:= rP_OC_Energy;
			MM2VIS.rP_OC_Avg			:= rP_OC_Avg;
			MM2VIS.rOC_DeltaOpHour		:= rOC_DeltaOpHour;
			MM2VIS.rOC_Consum			:= rOC_Consum; 
			MM2VIS.rVol_OC				:= rVol_OC;	
			MM2VIS.rOC_Consum_Avg		:= rAvgVolumeEnergy;
		
		END_IF
		
	


		(*----------------------------------------------------------------------------------------*)
		(* save oil counter values in permanent memory *)
	
		(* 10 seconds timer *)
		xTON_WritePMEM(IN := NOT xTON_WritePMEM.Q, PT:= T#10s);
		xTON_BlockMinFileAge(IN := bBlock_MinFileAge, PT:= T#10m);
		IF xTON_BlockMinFileAge.Q THEN	bBlock_MinFileAge := FALSE; END_IF;
	
		(* every 10 seconds or at write once the parameter values are copied to the structure pm *)
		IF xTON_WritePMEM.Q OR write_once THEN
	
			(* ------------- V1.10 ---------------- *)
			pmOil.kwh				:= kwh;				(* copy parameter value to structure pm *)								
			pmOil.ucIndexOil		:= ucIndexOil;		(* ----------------- " ---------------- *)
			pmOil.OilCounter		:= OilCounter;				
		
	
		END_IF;
	
		(* cyclic calcualtion of parameter checksum	*)
		IF xTON_WritePMEM.Q THEN
			ulChecksum := 0;
	
			FOR ulPMPointer := ADR(pmOil) TO (ADR(pmOil) + pm_len - SIZEOF(ulChkValue)) DO
				memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));
				ulChecksum := (ulChecksum XOR ulChkValue)+ulChkValue;
			END_FOR;
	
			IF ulChecksumOld <> ulChecksum THEN					(* if checksum has changed 		*)
				ulChecksumOld := ulChecksum;					(* save last cheksum value		*)
				bWriteDataObj := TRUE;							(* set flag for write checksum	*)
			END_IF;
	
		END_IF
	
	
		(* write structure pm to the permanent memory module *)
		IF ( (bWriteDataObj AND NOT bBlock_MinFileAge) OR write_once ) THEN
	
			DatObjWrite_01();									(* run data object write fub 					*)
	
			IF DatObjWrite_01.status <> ERR_FUB_BUSY THEN		(* wait if data object write fub is busy 		*)
				bWriteDataObj 	:= FALSE;						(* reset data object write flag					*)
				write_once 		:= FALSE;						(* reset write_once flag 						*)
				iPM_WriteCnt 	:= iPM_WriteCnt + 1;			(* counter for done data object module writes	*)
	
					
				IF OUT_AG.tAG2PB.iPermStatus >=0 THEN 												(* new V4.06: if not already on error state, then transmit this perm status info *)
					OUT_AG.tAG2PB.iPermStatus := LIMIT(2, OUT_AG.tAG2PB.iPermStatus + 1, 999);		(* new V4.06: transmit OK= positive perm status info *)
					IF OUT_AG.tAG2PB.iPermStatus = 999 THEN OUT_AG.tAG2PB.iPermStatus := 2; END_IF;	(* new V4.06: transmit OK= positive perm status info *)
					OUT_AG.tAG2PB.bPermSetupOk := TRUE;												(* new V4.06: transmit perm status info *)
				END_IF;
				
				IF DatObjWrite_01.status = ERR_NOERROR THEN		(* if status = NO ERROR -> block further write requests for 10min to avoid CF wear down	*)
					bBlock_MinFileAge := TRUE;
				ELSE											(* if error status not no error 				*)
					pm_Error := 1005;  //:= 4;					(* set data object write error state			*)
				END_IF;
			END_IF;
	
		END_IF;
	


	ELSE
		(* Reset *)
		bErrMsOilCounter		:= FALSE;						
		b_OilRefillBlocked		:= FALSE;
		bAMM_Vol_OilRefill_Hi	:= FALSE;
	END_IF;

	(* set RPS warning if no access to SysRom file is possible *)	
	TON_WarnDelay(IN := pm_Error > 0 , PT:= T#15s);
	IF TON_WarnDelay.Q AND (OUT_AG.tAG2PB.iPermStatus >= 0) THEN 	OUT_AG.tAG2PB.iPermStatus := LIMIT(-999999,-UINT_TO_DINT(pm_Error) ,-1)	;	END_IF	(* new V4.06: transmit error as negative perm status info *)
	IF (OUT_AG.tAG2PB.iPermStatus < 0) THEN 	OUT_AG.tAG2PB.bPermSetupOk := FALSE	;	END_IF		(* No reset of error bit - every error needs reboot *)		(* new V4.06: transmit perm status info *)
	

(*Start Oil & Coolant Management*)
	IF IN_AG.tPB2MM.bParaSetupOk AND (Para.bEO_Management_Active OR Para.bCW_Management_Active) THEN
		xTP_OilExchange.IN			:= FALSE;													(*Reset TP FUB Input*)
		xTP_OilSample.IN			:= FALSE;													(*Reset TP FUB Input*)
		xTP_CWExchange.IN			:= FALSE;													(*Reset TP FUB Input*)
		xTP_CWSample.IN				:= FALSE;													(*Reset TP FUB Input*)

(*Oil-Part*)
		IF Para.bEO_Management_Active THEN														(*if the oil management function is active then*)

			IF (IN_AG.iCnt_OpHours = (iCnt_OpHours_old + 1)) THEN								(*if engine Oh increase by 1 then*)
				MM2VIS.iCnt_OilOh 			:= MM2VIS.iCnt_OilOh + 1;							(*increase oil operating hour counter by one*)
				MM2VIS.iCnt_OilSampleOh		:= MM2VIS.iCnt_OilSampleOh - 1;						(*decrease oil sample counter by one*)
			END_IF;

			IF VIS2MM.bOilExchange THEN															(*if Button "Oil exchanged" pressed on HMI then*)
				MM2VIS.tLastOilExchange.Oh_fluid	:= MM2VIS.iCnt_OilOh;						(*Save oil operation hours at exchange*)
				MM2VIS.tLastOilExchange.Oh_engine	:= IN_AG.iCnt_OpHours;						(*Save engine operation hours at exchange*)
				MM2VIS.tLastOilExchange.day			:= USINT_TO_INT(tRealTime.day);				(*Save date at exchange*)
				MM2VIS.tLastOilExchange.month		:= USINT_TO_INT(tRealTime.month);			(*Save date at exchange*)
				MM2VIS.tLastOilExchange.year		:= UINT_TO_INT(tRealTime.year);				(*Save date at exchange*)
				MM2VIS.iCnt_OilOh					:= 0;										(*Reset oil counter to zero*)
				IF VIS2MM.bOQS_OilSampleOh_Man THEN
					MM2VIS.iCnt_OilSampleOh			:= VIS2MM.iOilSampleOh;						(*Reset oil sample counter - Manual interval*)
				ELSE
					MM2VIS.iCnt_OilSampleOh			:= MM2VIS.iOQS_OilSampleOh;					(*Reset oil sample counter - Automatic interval from oil quality sensor*)
				END_IF;
				xTP_OilExchange.IN					:= TRUE;									(*Trigger operation message "Oil exchanged"*)
				VIS2MM.bOilExchange 				:= FALSE;									(*Reset Button "Oil exchanged" on HMI*)
			END_IF;

			xTP_OilExchange();																	(*Execute FUB for operatin message*)

			IF VIS2MM.bOilSample THEN
				IF VIS2MM.bOQS_OilSampleOh_Man THEN
					MM2VIS.iCnt_OilSampleOh			:= VIS2MM.iOilSampleOh;						(*Reset oil sample counter - Manual interval*)
				ELSE
					MM2VIS.iCnt_OilSampleOh			:= MM2VIS.iOQS_OilSampleOh;					(*Reset oil sample counter - Automatic interval from oil quality sensor*)
				END_IF;
				MM2VIS.tLastOilSample.Oh_fluid		:= MM2VIS.iCnt_OilOh;						(*Save oil operation hours when sample was taken*)
				MM2VIS.tLastOilSample.Oh_engine		:= IN_AG.iCnt_OpHours;						(*Save engine operation hours when sample was taken*)
				MM2VIS.tLastOilSample.day			:= USINT_TO_INT(tRealTime.day);				(*Save date when sample was taken*)
				MM2VIS.tLastOilSample.month			:= USINT_TO_INT(tRealTime.month);			(*Save date when sample was taken*)
				MM2VIS.tLastOilSample.year			:= UINT_TO_INT(tRealTime.year);				(*Save date when sample was taken*)
				xTP_OilSample.IN					:= TRUE;									(*Trigger operation message "Oil sample taken"*)
				VIS2MM.bOilSample 					:= FALSE;									(*Reset Button "Oil sample taken" on HMI"*)
			END_IF;

			xTP_OilSample();																	(*Execute FUB for operating message*)

			bMsg9332_set		:= (MM2VIS.iCnt_OilSampleOh < 1) AND (IN_AG.iCnt_OpHours > 0);	(*set warning to take oil sample*)

			IF VIS2MM.iOilSampleOh = 0 THEN VIS2MM.iOilSampleOh := 150; END_IF;					(*initialize oil sample intervall in case value is zero*)

		ELSE																					(*if the oil management function is NOT active then*)

			xTP_OilExchange();																	(*Execute FUB for operatin message*)
			xTP_OilSample();																	(*Execute FUB for operating message*)
			bMsg9332_set			:= FALSE;													(*Reset warning "take oil sample"*)
			VIS2MM.bOilExchange 	:= FALSE;													(*Reset HMI button "oil exchanged"*)
			VIS2MM.bOilSample 		:= FALSE;													(*Reset HMI button "oil sample taken"*)
		END_IF;
(*Coolant-Part*)
		IF Para.bCW_Management_Active THEN														(*if the coolant management function is active then*)

			IF (IN_AG.iCnt_OpHours = (iCnt_OpHours_old + 1)) THEN								(*if engine Oh increase by 1 then*)
				MM2VIS.iCnt_CWOh 			:= MM2VIS.iCnt_CWOh + 1;							(*increase cooling water operating hour counter by one*)
				MM2VIS.iCnt_CWSampleOh		:= MM2VIS.iCnt_CWSampleOh - 1;						(*decrease cooling water sample counter by one*)
			END_IF;

			IF VIS2MM.bCWExchange THEN															(*Button "Cooling water exchanged" pressed on HMI *)
				MM2VIS.tLastCWExchange.Oh_fluid		:= MM2VIS.iCnt_CWOh;						(*Save cooling water operation hours at exchange*)
				MM2VIS.tLastCWExchange.Oh_engine	:= IN_AG.iCnt_OpHours;						(*Save engine operation hours at exchange*)
				MM2VIS.tLastCWExchange.day			:= USINT_TO_INT(tRealTime.day);				(*Save date at exchange*)
				MM2VIS.tLastCWExchange.month		:= USINT_TO_INT(tRealTime.month);			(*Save date at exchange*)
				MM2VIS.tLastCWExchange.year			:= UINT_TO_INT(tRealTime.year);				(*Save date at exchange*)
				MM2VIS.iCnt_CWOh					:= 0;										(*Reset cooling water counter to zero*)
				MM2VIS.iCnt_CWSampleOh				:= VIS2MM.iCWSampleOh;						(*Reset cooling water sample counter*)
				xTP_CWExchange.IN					:= TRUE;									(*Trigger operation message "Cooling water exchanged"*)
				VIS2MM.bCWExchange 					:= FALSE;									(*Reset Button "Cooling water exchanged" on HMI*)
			END_IF;

			xTP_CWExchange();																	(*Execute FUB for operatin message*)

			IF VIS2MM.bCWSample THEN
				MM2VIS.iCnt_CWSampleOh				:= VIS2MM.iCWSampleOh;						(*Reset cooling water sample counter*)
				MM2VIS.tLastCWSample.Oh_fluid		:= MM2VIS.iCnt_CWOh;						(*Save cooling water operation hours when sample was taken*)
				MM2VIS.tLastCWSample.Oh_engine		:= IN_AG.iCnt_OpHours;						(*Save engine operation hours when sample was taken*)
				MM2VIS.tLastCWSample.day			:= USINT_TO_INT(tRealTime.day);				(*Save date when sample was taken*)
				MM2VIS.tLastCWSample.month			:= USINT_TO_INT(tRealTime.month);			(*Save date when sample was taken*)
				MM2VIS.tLastCWSample.year			:= UINT_TO_INT(tRealTime.year);				(*Save date when sample was taken*)
				xTP_CWSample.IN						:= TRUE;									(*Trigger operation message "Cooling water sample taken"*)
				VIS2MM.bCWSample 					:= FALSE;									(*Reset Button "Cooling water sample taken" on HMI"*)
			END_IF;

			xTP_CWSample();																		(*Execute FUB for operating message*)

			bMsg9333_set		:= (MM2VIS.iCnt_CWSampleOh < 1) AND (IN_AG.iCnt_OpHours > 0);	(*set warning to take cooling water sample*)

			IF VIS2MM.iCWSampleOh = 0 THEN VIS2MM.iCWSampleOh := 2000; END_IF;					(*initialize cooling water sample intervall in case value is zero*)

		ELSE																					(*if the coolant management function is NOT active then*)

			xTP_CWExchange();																	(*Execute FUB for operatin message*)
			xTP_CWSample();																		(*Execute FUB for operating message*)
			bMsg9333_set			:= FALSE;													(*Reset warning "take coolant sample"*)
			VIS2MM.bCWExchange	 	:= FALSE;													(*Reset HMI button "coolant exchanged"*)
			VIS2MM.bCWSample 		:= FALSE;													(*Reset HMI button "coolant sample taken"*)
		END_IF;
(*Oil & Coolant*)
		iCnt_OpHours_old		:= IN_AG.iCnt_OpHours;											(*save engine Oh for next cycle*)

	ELSE																						(*if both functions (oil & coolant management) are NOT active*)

		iCnt_OpHours_old		:= IN_AG.iCnt_OpHours;											(*save engine Oh for next cycle*)
		bMsg9332_set			:= FALSE;														(*Reset warning "take oil sample"*)
		VIS2MM.bOilExchange 	:= FALSE;														(*Reset HMI button "oil exchanged"*)
		VIS2MM.bOilSample 		:= FALSE;														(*Reset HMI button "oil sample taken"*)

		bMsg9333_set			:= FALSE;														(*Reset warning "take coolant sample"*)
		VIS2MM.bCWExchange	 	:= FALSE;														(*Reset HMI button "coolant exchanged"*)
		VIS2MM.bCWSample 		:= FALSE;														(*Reset HMI button "coolant sample taken"*)

		xTP_OilExchange(IN:= FALSE);															(*Reset TP FUB Input*)
		xTP_OilSample(IN:= FALSE);																(*Reset TP FUB Input*)
		xTP_CWExchange(IN:= FALSE);																(*Reset TP FUB Input*)
		xTP_CWSample(IN:= FALSE);																(*Reset TP FUB Input*)

	END_IF;

	xTON_OilExchange.IN			:= xTP_OilExchange.Q;											(*delay 1.11s to ensure that the correct additional infos get stored with the operating message*)
	xTON_OilExchange();
	xTON_OilSample.IN			:= xTP_OilSample.Q;
	xTON_OilSample();
	
	bMsg9002_set				:= xTON_OilExchange.Q;											(*set B9002 Oil exchanged*)
	bMsg9001_set				:= xTON_OilSample.Q;											(*set B9001 Oil sample taken*)

	xTON_CWExchange.IN			:= xTP_CWExchange.Q;											(*delay 1.11s to ensure that the correct additional infos get stored with the operating message*)
	xTON_CWExchange();
	xTON_CWSample.IN			:= xTP_CWSample.Q;
	xTON_CWSample();
	
	bMsg9048_set				:= xTON_CWExchange.Q;											(*set B9048 Coolant exchanged*)
	bMsg9003_set				:= xTON_CWSample.Q;												(*set B9003 Coolant sample taken*)

(*End Oil & Coolant Management*)


		
END_PROGRAM

