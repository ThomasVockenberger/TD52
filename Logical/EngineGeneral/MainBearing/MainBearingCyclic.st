(*******************************************************************************
MainBearing: main bearing temperature monitoring (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019    

- reading main bearing temperature values 
- sensor check 
- warning main bearing temperature maximum monitoring
- error main bearing temperature maximum monitoring

Customized modifications: -
------------------------

History:
-------
V3.2		17-03-2010	Tinello, 	generated
V3.20.1		09-03-2011	Zengerer	eleminate temp to 0 in case of signal failure	
			10-03-2011	Tinello		MS-Sto set to 140°C 
V3.3		27.03.2013	Tinello 	restructured for modular SW
									add median monitoring
V3.59		14.01.2015	Tinello		restructured for XT4
V4.3		20.01.2016	Tinello		MIN, MAX AND AVG FOR temperature AND strength signal
V4.4		06.10.2016	Tinello		message "main bearing temperature MEDIAN deviation maximum" (with bearing position) added
V4.05.01.00	08.03.2018	Tinello		Specification (f)
V4.05.03.00	12.09.2018	Tinello		Bugfix: Alarm bypass, bu
			   
Instructions for use:
--------------------

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC

	(*--------------------------------------------------*)
	(* RESET 						 					*)
	(*--------------------------------------------------*)
	xMEDIAN_Temp.anzahl	:= 0;

	rT_MBearing_Min		:= 10000;
	rT_MBearing_Max		:= 0;
	rT_MBearing_Sum		:= 0;


	(************************************************************************************************************************)
	(************************              Monitoring of main bearing temperature		           **************************)
	(************************************************************************************************************************)
	FOR iCntMB := 1 TO 11 BY 1 DO																	(* 11 main bearings *)
						
		rT_MBearing[iCntMB]			:= IN_EG.tT_MBearing[iCntMB].Ai;	 						

		(* error monitoring	*)
			(* TOF because of filtered signals *)
			xTOF_MBTempMs[iCntMB](IN:= NOT IN_EG.tT_MBearing[iCntMB].GoodQual, PT:= T#10s);			
	
		bErrMBTemp_Ms[iCntMB] 		:= Para.bT_MBearing_Exist AND xTOF_MBTempMs[iCntMB].Q;			(* Ms error *)
										
		bErrMBTemp_Hi[iCntMB] 		:= (rT_MBearing[iCntMB] > Para.rT_MBearing_Hi) 	 AND 			(* Maximum warning *)
									   Para.bT_MBearing_Exist AND IN_EG.tT_MBearing[iCntMB].GoodQual;
										
		bErrMBTemp_HiHi[iCntMB] 	:= (rT_MBearing[iCntMB] > Para.rT_MBearing_HiHi) AND 			(* Maximum error *)
									   Para.bT_MBearing_Exist AND IN_EG.tT_MBearing[iCntMB].GoodQual;

		IF NOT bErrMBTemp_Ms[iCntMB] THEN
			xMEDIAN_Temp.anzahl						:= xMEDIAN_Temp.anzahl + 1;
			xMEDIAN_Temp.in[xMEDIAN_Temp.anzahl]	:= rT_MBearing[iCntMB];							(* median calculation *)
		END_IF
		
		bErrMBTempMDev_Lo[iCntMB]	:= (rT_MBearing[iCntMB] < (xMEDIAN_Temp.median - 				(* Negative deviation *)
										 						Para.rT_MBearing_MDev_HiHi)) AND
									    Para.bT_MBearing_Exist AND NOT bErrMBTemp_Ms[iCntMB];

		bErrMBTempMDev_HiHi[iCntMB]	:= (rT_MBearing[iCntMB] > (xMEDIAN_Temp.median + 				(* Positive deviation *)
										 						Para.rT_MBearing_MDev_HiHi)) AND
									    Para.bT_MBearing_Exist AND NOT bErrMBTemp_Ms[iCntMB];
	END_FOR
	

	(* Create MEDIAN *)
	xMEDIAN_Temp();



	(************************************************************************************************************************)
	(************************              			 AMM sequencer	 	             	           **************************)
	(************************************************************************************************************************)
	xTON_SecondTick(IN	:= NOT xTON_SecondTick.Q, PT:= T#800ms);							(* 800ms + 2x cycle time = 1 sec.*)
	xTON_ReleaseMDev(IN	:= IN_EG.rN_EngAct > 400, PT:= T#60s);								(* monitoring delay *)


	(* ERROR   main bearing temperature measuring signal failure  *)
	xAmmSeq_TempMs.Enable			:= NOT IN_EG.tAB2EG.bResetTrip AND bRelModul_ParaSetupOk;
	xAmmSeq_TempMs.ClockPulse		:= xTON_SecondTick.Q; 
	xAmmSeq_TempMs.NrOfBits			:= 12;	
	xAmmSeq_TempMs.BitArray			:= ADR(bErrMBTemp_Ms);
	xAmmSeq_TempMs();

	bAMM_T_MBearing_Ms				:= xAmmSeq_TempMs.Alarm1;														(* W9217 *)
	bOpM_T_MBearing_Ms				:= xAmmSeq_TempMs.Alarm2;														(* B2804 *)
	iNum_T_MBearing_Ms				:= xAmmSeq_TempMs.ErrorNr;				
	
	
	(* WARNING main bearing temperature maximum  *)
	xAmmSeq_TempHi.Enable			:= NOT IN_EG.tAB2EG.bResetWarning; 
	xAmmSeq_TempHi.ClockPulse		:= xTON_SecondTick.Q; 
	xAmmSeq_TempHi.NrOfBits			:= 12;	
	xAmmSeq_TempHi.BitArray			:= ADR(bErrMBTemp_Hi);
	xAmmSeq_TempHi();	
	
	bAMM_T_MBearing_Hi				:= xAmmSeq_TempHi.Alarm1;														(* W2542 *)
	bOpM_T_MBearing_Hi				:= xAmmSeq_TempHi.Alarm2;														(* B2805 *)
	iNum_T_MBearing_Hi				:= xAmmSeq_TempHi.ErrorNr;				


	(* ERROR   main bearing temperature maximum  *)
	xAmmSeq_TempHiHi.Enable			:= NOT IN_EG.tAB2EG.bResetTrip; 
	xAmmSeq_TempHiHi.ClockPulse		:= xTON_SecondTick.Q; 
	xAmmSeq_TempHiHi.NrOfBits		:= 12;	
	xAmmSeq_TempHiHi.BitArray		:= ADR(bErrMBTemp_HiHi);
	xAmmSeq_TempHiHi();	
	
	bAMM_T_MBearing_HiHi			:= xAmmSeq_TempHiHi.Alarm1;														(* A2228 *)


	(* WARNING   main bearing temperature - negative MEDIAN deviation maximum  *)
	xAmmSeq_TempMDevLo.Enable		:= NOT IN_EG.tAB2EG.bResetWarning AND xTON_ReleaseMDev.Q;
	xAmmSeq_TempMDevLo.ClockPulse	:= xTON_SecondTick.Q; 
	xAmmSeq_TempMDevLo.NrOfBits		:= 12;	
	xAmmSeq_TempMDevLo.BitArray		:= ADR(bErrMBTempMDev_Lo);
	xAmmSeq_TempMDevLo();	
	
	bAMM_T_MBearing_MDev_Lo			:= xAmmSeq_TempMDevLo.Alarm1;													(* W9218 *)
	bOpM_T_MBearing_MDev_Lo			:= xAmmSeq_TempMDevLo.Alarm2;													(* B2958 *)
	iNum_T_MBearing_MDev_Lo			:= xAmmSeq_TempMDevLo.ErrorNr;				


	(* ERROR   main bearing temperature - positive MEDIAN deviation maximum  *)
	xAmmSeq_TempMDevHiHi.Enable		:= NOT (IN_EG.tAB2EG.bResetTrip OR (IN_EG.tAB2EG.bResetWarning AND bMsg2285_Test)) AND 
									   xTON_ReleaseMDev.Q;
	xAmmSeq_TempMDevHiHi.ClockPulse	:= xTON_SecondTick.Q; 
	xAmmSeq_TempMDevHiHi.NrOfBits	:= 12;	
	xAmmSeq_TempMDevHiHi.BitArray	:= ADR(bErrMBTempMDev_HiHi);
	xAmmSeq_TempMDevHiHi();	
	
	bAMM_T_MBearing_MDev_HiHi		:= xAmmSeq_TempMDevHiHi.Alarm1;													(* A2285 *)
	bOpM_T_MBearing_MDev_HiHi		:= xAmmSeq_TempMDevHiHi.Alarm2;													(* B2904 *)
	iNum_T_MBearing_MDev_HiHi		:= xAmmSeq_TempMDevHiHi.ErrorNr;				



	(************************************************************************************************************************)
	(************************              					VISU	 	             	           **************************)
	(************************************************************************************************************************)
	FOR iCntMB := 1 TO 11 BY 1 DO
		MM2VIS.rT_MBearing[iCntMB]	:= rT_MBearing[iCntMB];		
		OUT_EG.rT_MBearing[iCntMB]	:= rT_MBearing[iCntMB];			(* OUT interface - For other modules *)

		(* search for the bearing temperature - MIN,MAX,AVG *)
		rT_MBearing_Min				:= MIN(rT_MBearing_Min, rT_MBearing[iCntMB]);		
		rT_MBearing_Max 			:= MAX(rT_MBearing_Max, rT_MBearing[iCntMB]);		
		rT_MBearing_Sum				:= rT_MBearing_Sum + rT_MBearing[iCntMB];
	END_FOR

	MM2VIS.rT_MBearing_Min			:= rT_MBearing_Min;		
	MM2VIS.rT_MBearing_Max			:= rT_MBearing_Max;
	MM2VIS.rT_MBearing_Avg			:= rT_MBearing_Sum / 11;

	MM2VIS.iNum_T_MBearing_MsMs		:= iNum_T_MBearing_Ms;
	MM2VIS.iNum_T_MBearing_Hi		:= iNum_T_MBearing_Hi;
	MM2VIS.iNum_T_MBearing_MDev_Lo	:= iNum_T_MBearing_MDev_Lo;
	MM2VIS.iNum_T_MBearing_MDev_HiHi:= iNum_T_MBearing_MDev_HiHi;

END_PROGRAM		
