(************************************************************************************************************************************
GasMixer: control up to 2 gasmixer positions  (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2021
 
	- convert analog gasmixer position to 1/100 %
	- check gasmixer position measurement signal
	- monitor difference between analog position and stepper position
	- set reference position of stepper motor driver

Customized modifications: -
------------------------
  
History:
-------																							
V03.99.00.00	07.01.2009	Tinello		generated from gasmixer-task V0.32
				19.02.2010	WeitzerT	replace QUITT_WA / _AB by QUITTRPS/ (QUITTRPS AND StopM)
				17.03.2010	WeitzerT	re-config and re-para if module was disconnected
				13.07.2011	lettenb.	line 328 slGM2_MStepSetPos_TC1: bp_y -> bp2_y bugfix for second SM1426
				10.01.2013	Tinello		restructured for Modulare SW
V04.01.00.00	13.06.2014	Weitzer		add bit for special gasmixer trip 1083
V04.04.00.00	21.12.2016	Denk		Modification for WinMOD simulation
V04.05.01.00	20.02.2018	Tinello		Bugfix for measurement signal failure of gasmixer position
V04.07.01.00	17.10.2019	Tinello		bugfix: division by 0
V04.10.00.00	27.01.2021	Tinello  	BugFix: Timer-FuB's

Instructions for use: -
--------------------

Outstandings: -
------------																											
																										
*************************************************************************************************************************************)
PROGRAM _CYCLIC

	xTON_Referencing(IN := NOT xTON_Referencing.Q, PT:= T#9s980ms);				(* timer tick  10 s = 9980ms + 2 task class cycles	*)

	(*--------------------------------------------------*)
	(* RESET of alarms and warnings 					*)
	(*--------------------------------------------------*)
	bErrMsGM_Pos 	:= FALSE;							
	bErrGM_Ctr		:= FALSE;							

	(*--------------------------------------------------*)	
	(* VISU var of module 								*)
	(*--------------------------------------------------*)	
	MM2VIS.rPos_Act_GM1_Norm;
	MM2VIS.rPos_Act_GM2_Norm;
			
			
	
	(********************************************************************************************************************************)
	(* 													gasmixer 1 																	*)
	(********************************************************************************************************************************)
	IF Para.iNum_GM >= 1 AND IN_GM.tPB2MM.bParaSetupOk AND NOT Para.bSGM_Active AND NOT IN_GM.bSimWinMOD_Active THEN

		(*----------------------------------------------*)
		(* READ status from state machine				*)
		(*----------------------------------------------*)
		xWDtoBIT_GM1.Word 		:= IN_GM.iGM1_Status;							
		xWDtoBIT_GM1();

		bGM1_ReadyToSwitchOn	:= xWDtoBIT_GM1.Bit00;				
		bGM1_SwitchedOn			:= xWDtoBIT_GM1.Bit01;
		bGM1_OperationEnable	:= xWDtoBIT_GM1.Bit02;							(* ONLY state where motor movements are executed	*)
		bGM1_Error				:= xWDtoBIT_GM1.Bit03;
		bGM1_SwitchOnDisabled	:= xWDtoBIT_GM1.Bit06;
		bGM1_Warning			:= xWDtoBIT_GM1.Bit07;
		bGM1_TargetReached		:= xWDtoBIT_GM1.Bit10;							(* gets TRUE when an activity is finished 			*)

		
		(*----------------------------------------------*)
		(* CHANGE STATE 								*)
		(*----------------------------------------------*)
		IF    bGM1_SwitchedOn 		THEN 	bGM1_EnableVoltage		:= TRUE;	(* COMMAND: change state to "Operation Enable"		*)
											bGM1_SwitchOn			:= TRUE;
											bGM1_EnableOperation	:= TRUE;
		ELSIF bGM1_ReadyToSwitchOn 	THEN 	bGM1_EnableVoltage		:= TRUE;	(* COMMAND: change state to "Switched On"			*)
											bGM1_SwitchOn			:= TRUE;
											bGM1_EnableOperation	:= FALSE;
		ELSIF bGM1_SwitchOnDisabled THEN 	bGM1_EnableVoltage		:= TRUE;	(* COMMAND: change state to "Ready To Switch On"	*)
											bGM1_SwitchOn			:= FALSE;
											bGM1_EnableOperation	:= FALSE;	END_IF

		(* Acknowledgement *)
		IF IN_GM.tAB2GM.bResetWarning 				   AND bGM1_Warning	THEN  bGM1_ResetWarning	:= TRUE;	END_IF	
		IF IN_GM.tAB2GM.bResetWarning AND xOpMode.Stop AND bGM1_Error	THEN  bGM1_ResetError	:= TRUE; 	END_IF
				

		(*----------------------------------------------*)
		(* WRITE COMMAND to state machine 				*)
		(*----------------------------------------------*)
		xBITtoWD_GM1.Bit00	:= bGM1_SwitchOn;
		xBITtoWD_GM1.Bit01	:= bGM1_EnableVoltage;
		xBITtoWD_GM1.Bit02	:= TRUE;
		xBITtoWD_GM1.Bit03	:= bGM1_EnableOperation;
		xBITtoWD_GM1.Bit07	:= bGM1_ResetError;									(* rising Edge to reset *)
		xBITtoWD_GM1.Bit12	:= bGM1_ResetWarning;								(* rising Edge to reset *)
		xBITtoWD_GM1();
	
		OUT_GM.iGM1_Control	:= xBITtoWD_GM1.Word;
		
		(* Reset Acknowledgement	*)
		bGM1_ResetError		:= FALSE;
		bGM1_ResetWarning	:= FALSE;

		

		(*----------------------------------------------*)
		(* CONVERT actual position from SM1426  		*)
		(*----------------------------------------------*)
		(* traversing range (Verfahrbereich) *)
		rGM1_MStepRange			:= Para.rNum_stepsGM1 / 2 * 256;			(* conversion from half-step to full-step to Microstep	*)
		
		IF rGM1_MStepRange <> 0 THEN
			rPos_Act_GM1_Norm	:= DINT_TO_REAL(IN_GM.iGM1_MStepActPos) / rGM1_MStepRange;	(* normed gasmixer position from SM1426	*)
		END_IF
				
		(*----------------------------------------------*)
		(* ERROR 										*)
		(*----------------------------------------------*)
		(* difference between potentiometer and SM1426 position > 1% for longer than 30 seconds or State Machine = "Fault" *)
		xTON_GM1_Err(IN := ABS(rPos_Act_GM1_Norm - IN_GM.tPos_Act_GM1_Norm.Unfilt) > 0.01, PT:= T#30s);
		bErrGM_Ctr 		:= xTON_GM1_Err.Q OR bGM1_Error;																(* A1083 *)
		
		(* measurement signal failure 	*)
		bErrMsGM_Pos	:= NOT IN_GM.tPos_Act_GM1_Norm.GoodQual;														(* W2086 *)	
		
	

		(*----------------------------------------------*)
		(* SET position									*)
		(*----------------------------------------------*)
		IF 	bGM1_OperationEnable AND 				(* STATE Machine: motor movements are executed *)
			OUT_GM.iGM1_Mode = 1 					(* Position MODE: move to target position if actual position <> set position	*)
		THEN	
			OUT_GM.iGM1_MStepSetPos	:= REAL_TO_DINT( rGM1_MStepRange * IN_GM.rPos_GM_Set_Norm); 
		END_IF


		
		(*----------------------------------------------*)
		(* REFERENCING 									*)
		(*----------------------------------------------*)
		
		(* Calculate position error *)
		rPos_GM1_SumError_Norm	:= rPos_GM1_SumError_Norm + (rPos_Act_GM1_Norm - IN_GM.tPos_Act_GM1_Norm.Unfilt);
		rCnt_GM1_SumError		:= rCnt_GM1_SumError + 1;
		
		(* Set reference if acknowledge *)
		IF IN_GM.tAB2GM.bResetWarning AND xOpMode.Stop 	THEN  bGM1_SetRef	:= TRUE; 	END_IF

	
		IF (NOT IN_GM.bLeanox_Man OR 										(* leanox control not manual  	*)
			NOT xOpMode.Stop 	  OR 										(* engine is running 			*)
			bGM1_SetRef			 	) AND 									(* COMMAND: Set reference 		*)
			bGM1_OperationEnable 											(* STATE Machine: Set of actual position is allowed *)
		THEN		

			IF 	xTON_Referencing.Q THEN										(* release referencing every 10s	*)
						
				(* Calculate normed average position error *)
				rPos_GM1_AvgError_Norm		:= rPos_GM1_SumError_Norm / rCnt_GM1_SumError;
				rPos_GM1_SumError_Norm		:= 0;
				rCnt_GM1_SumError			:= 0;

				(* if positioning error is > 0.2% and < 1.0% or engine stop and error is > 0.1% carry out a reference set *)
				IF 	(ABS(rPos_GM1_AvgError_Norm) > 0.002 AND ABS(rPos_GM1_AvgError_Norm) < 0.01) OR
					(xOpMode.Stop AND ABS(rPos_GM1_AvgError_Norm) > 0.001) 							 
				THEN
					OUT_GM.iGM1_MStepSetPos := IN_GM.iGM1_MStepActPos - (REAL_TO_DINT(rGM1_MStepRange * rPos_GM1_AvgError_Norm) / 2);
					OUT_GM.iGM1_Mode	  	:= -122;						(* MODE: Set actual position  *)				
				END_IF
				
				(* carry out a reference set *)
				IF bGM1_SetRef AND OUT_GM.iGM1_Mode <> -122					
				THEN										
					OUT_GM.iGM1_MStepSetPos	:= REAL_TO_DINT(rGM1_MStepRange * IN_GM.tPos_Act_GM1_Norm.Ai);
					OUT_GM.iGM1_Mode		:= -122;						(* MODE: Set actual position  *)			
				END_IF
				
			ELSIF bGM1_TargetReached AND OUT_GM.iGM1_Mode = -122 
			THEN
				OUT_GM.iGM1_Mode	:= 1;									(* Position MODE: Release for Set positioning	*)
				bGM1_SetRef			:= FALSE;								(* Reset COMMAND: Set reference *)
			END_IF	
		END_IF

		
		(*----------------------------------------------*)
		(* VISU: normed gasmixer position  				*)
		(*----------------------------------------------*)
		IF NOT xOpMode.Stop THEN											(* if engine is running	*)
  			MM2VIS.rPos_Act_GM1_Norm	:= rPos_Act_GM1_Norm;				(* normed gasmixer position from SM1426 module *)
		ELSE
			MM2VIS.rPos_Act_GM1_Norm	:= IN_GM.tPos_Act_GM1_Norm.Ai;		(* filtered and normed gasmixer pos. from potentiometer *)
		END_IF		

	ELSE
		OUT_GM.iGM1_Mode	:= 0;											(* NO MODE	*)
		bGM1_SetRef			:= TRUE;										(* carry out a reference set *)
		xTON_GM1_Err(IN 	:= FALSE);
	END_IF

	
	
	
		

	(********************************************************************************************************************************)
	(* 													gasmixer 2 																	*)
	(********************************************************************************************************************************)
	IF Para.iNum_GM >= 2 AND IN_GM.tPB2MM.bParaSetupOk AND NOT Para.bSGM_Active AND NOT IN_GM.bSimWinMOD_Active THEN

		(*----------------------------------------------*)
		(* READ status from state machine				*)
		(*----------------------------------------------*)
		xWDtoBIT_GM2.Word 		:= IN_GM.iGM2_Status;							
		xWDtoBIT_GM2();

		bGM2_ReadyToSwitchOn	:= xWDtoBIT_GM2.Bit00;				
		bGM2_SwitchedOn			:= xWDtoBIT_GM2.Bit01;
		bGM2_OperationEnable	:= xWDtoBIT_GM2.Bit02;							(* ONLY state where motor movements are executed	*)
		bGM2_Error				:= xWDtoBIT_GM2.Bit03;
		bGM2_SwitchOnDisabled	:= xWDtoBIT_GM2.Bit06;
		bGM2_Warning			:= xWDtoBIT_GM2.Bit07;
		bGM2_TargetReached		:= xWDtoBIT_GM2.Bit10;							(* gets TRUE when an activity is finished 			*)

		
		(*----------------------------------------------*)
		(* CHANGE STATE 								*)
		(*----------------------------------------------*)
		IF    bGM2_SwitchedOn 		THEN 	bGM2_EnableVoltage		:= TRUE;	(* COMMAND: change state to "Operation Enable"		*)
											bGM2_SwitchOn			:= TRUE;
											bGM2_EnableOperation	:= TRUE;
		ELSIF bGM2_ReadyToSwitchOn 	THEN 	bGM2_EnableVoltage		:= TRUE;	(* COMMAND: change state to "Switched On"			*)
											bGM2_SwitchOn			:= TRUE;
											bGM2_EnableOperation	:= FALSE;
		ELSIF bGM2_SwitchOnDisabled THEN 	bGM2_EnableVoltage		:= TRUE;	(* COMMAND: change state to "Ready To Switch On"	*)
											bGM2_SwitchOn			:= FALSE;
											bGM2_EnableOperation	:= FALSE;	END_IF

		(* Acknowledgement *)
		IF IN_GM.tAB2GM.bResetWarning 				   AND bGM2_Warning	THEN  bGM2_ResetWarning	:= TRUE;	END_IF	
		IF IN_GM.tAB2GM.bResetWarning AND xOpMode.Stop AND bGM2_Error	THEN  bGM2_ResetError	:= TRUE; 	END_IF
				

		(*----------------------------------------------*)
		(* WRITE COMMAND to state machine 				*)
		(*----------------------------------------------*)
		xBITtoWD_GM2.Bit00	:= bGM2_SwitchOn;
		xBITtoWD_GM2.Bit01	:= bGM2_EnableVoltage;
		xBITtoWD_GM2.Bit02	:= TRUE;
		xBITtoWD_GM2.Bit03	:= bGM2_EnableOperation;
		xBITtoWD_GM2.Bit07	:= bGM2_ResetError;									(* rising Edge to reset *)
		xBITtoWD_GM2.Bit12	:= bGM2_ResetWarning;								(* rising Edge to reset *)
		xBITtoWD_GM2();
	
		OUT_GM.iGM2_Control	:= xBITtoWD_GM2.Word;
		
		(* Reset Acknowledgement	*)
		bGM2_ResetError		:= FALSE;
		bGM2_ResetWarning	:= FALSE;

		

		(*----------------------------------------------*)
		(* CONVERT actual position from SM1426  		*)
		(*----------------------------------------------*)
		(* traversing range (Verfahrbereich) *)
		rGM2_MStepRange			:= Para.rNum_stepsGM2 / 2 * 256;			(* conversion from half-step to full-step to Microstep	*)

		IF rGM2_MStepRange <> 0 THEN
			rPos_Act_GM2_Norm	:= DINT_TO_REAL(IN_GM.iGM2_MStepActPos) / rGM2_MStepRange;	(* normed gasmixer position from SM1426	*)
		END_IF
				
		(*----------------------------------------------*)
		(* ERROR 										*)
		(*----------------------------------------------*)
		(* difference between potentiometer and SM1426 position > 1% for longer than 30 seconds or State Machine = "Fault" *)
		xTON_GM2_Err(IN := ABS(rPos_Act_GM2_Norm - IN_GM.tPos_Act_GM2_Norm.Unfilt) > 0.01, PT:= T#30s);
		bErrGM_Ctr 		:= xTON_GM2_Err.Q OR bGM2_Error;																(* A1083 *)
		
		(* measurement signal failure 	*)
		bErrMsGM_Pos	:= bErrMsGM_Pos OR NOT IN_GM.tPos_Act_GM2_Norm.GoodQual;										(* W2086 *)	
		
	

		(*----------------------------------------------*)
		(* SET position									*)
		(*----------------------------------------------*)
		IF 	bGM2_OperationEnable AND 				(* STATE Machine: motor movements are executed *)
			OUT_GM.iGM2_Mode = 1 					(* Position MODE: move to target position if actual position <> set position	*)
		THEN	
			OUT_GM.iGM2_MStepSetPos	:= REAL_TO_DINT( rGM2_MStepRange * IN_GM.rPos_GM_Set_Norm); 
		END_IF


		
		(*----------------------------------------------*)
		(* REFERENCING 									*)
		(*----------------------------------------------*)
		
		(* Calculate position error *)
		rPos_GM2_SumError_Norm	:= rPos_GM2_SumError_Norm + (rPos_Act_GM2_Norm - IN_GM.tPos_Act_GM2_Norm.Unfilt);
		rCnt_GM2_SumError		:= rCnt_GM2_SumError + 1;
		
		(* Set reference if acknowledge *)
		IF IN_GM.tAB2GM.bResetWarning AND xOpMode.Stop 	THEN  bGM2_SetRef	:= TRUE; 	END_IF

	
		IF (NOT IN_GM.bLeanox_Man OR 										(* leanox control not manual  	*)
			NOT xOpMode.Stop 	  OR 										(* engine is running 			*)
			bGM2_SetRef			 	) AND 									(* COMMAND: Set reference 		*)
			bGM2_OperationEnable 											(* STATE Machine: Set of actual position is allowed *)
		THEN		

			IF 	xTON_Referencing.Q THEN										(* release referencing every 10s *)
						
				(* Calculate normed average position error *)
				rPos_GM2_AvgError_Norm		:= rPos_GM2_SumError_Norm / rCnt_GM2_SumError;
				rPos_GM2_SumError_Norm		:= 0;
				rCnt_GM2_SumError			:= 0;

				(* if positioning error is > 0.2% and < 1.0% or engine stop and error is > 0.1% carry out a reference set *)
				IF 	(ABS(rPos_GM2_AvgError_Norm) > 0.002 AND ABS(rPos_GM2_AvgError_Norm) < 0.01) OR
					(xOpMode.Stop AND ABS(rPos_GM2_AvgError_Norm) > 0.001) 							 
				THEN
					OUT_GM.iGM2_MStepSetPos := IN_GM.iGM2_MStepActPos - (REAL_TO_DINT(rGM2_MStepRange * rPos_GM2_AvgError_Norm) / 2);
					OUT_GM.iGM2_Mode	  	:= -122;						(* MODE: Set actual position  *)				
				END_IF
				
				(* carry out a reference set *)
				IF bGM2_SetRef AND OUT_GM.iGM2_Mode <> -122					
				THEN										
					OUT_GM.iGM2_MStepSetPos	:= REAL_TO_DINT(rGM2_MStepRange * IN_GM.tPos_Act_GM2_Norm.Ai);
					OUT_GM.iGM2_Mode		:= -122;						(* MODE: Set actual position  *)			
				END_IF
				
			ELSIF bGM2_TargetReached AND OUT_GM.iGM2_Mode = -122 
			THEN
				OUT_GM.iGM2_Mode	:= 1;									(* Position MODE: Release for Set positioning	*)
				bGM2_SetRef			:= FALSE;								(* Reset COMMAND: Set reference *)
			END_IF	
		END_IF

		
		(*----------------------------------------------*)
		(* VISU: normed gasmixer position  				*)
		(*----------------------------------------------*)
		IF NOT xOpMode.Stop THEN											(* if engine is running	*)
  			MM2VIS.rPos_Act_GM2_Norm	:= rPos_Act_GM2_Norm;				(* normed gasmixer position from SM1426 module *)
		ELSE
			MM2VIS.rPos_Act_GM2_Norm	:= IN_GM.tPos_Act_GM2_Norm.Ai;		(* filtered and normed gasmixer pos. from potentiometer *)
		END_IF		

	ELSE
		OUT_GM.iGM2_Mode	:= 0;											(* NO MODE	*)
		bGM2_SetRef			:= TRUE;										(* carry out a reference set *)
		xTON_GM2_Err(IN 	:= FALSE);
	END_IF		
	
	
END_PROGRAM
