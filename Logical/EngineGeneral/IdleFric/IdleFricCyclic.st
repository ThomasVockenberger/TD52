(*******************************************************************************
MainBearing: idle friction monitoring (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021     

- check throttle position, boost pressure and speed to prevent engine damage

Customized modifications: -
------------------------

History:
-------
V4.4	28-01-2016	Weitzer, 	generated
		05-12-2016	Weitzer, 	add activation with service button for 10 op hours
V4.4.1	07-03-2017	Weitzer,	correct funktion according to spec
V4.4.2	19-07-2017	Weitzer,    change boost pressure limit to 0.70 bar
V4.10	27.01.2021	Tinello,  	BugFix: Timer-FuB's

Instructions FOR use:
--------------------

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC
		
	(* activation of function *)
		
	(* activate monitoring with service button *)
	IF Para.bIdleFrictionMon THEN
		
		(* increase counter *)
		iCntOpH := MIN(iCntOpH + BOOL_TO_UINT(EDGEPOS(IN_EG.tImp_OpHour.Do)), 10000);
		(* counter reset *)	
		IF EDGEPOS(IN_EG.bServiceMode) THEN
			iCntOpH := 0;					
		END_IF;
		
		bServiceMon := iCntOpH <= 10;
	ELSE
		bServiceMon := FALSE;
	END_IF;	
	
	(* service button was activated within the last 10 operating hours *)
	IF bServiceMon THEN
		
		(* activate monitoring *)
																			
//		bMonitoringAct :=	(IN_EG.rN_EngAct > (Para.rN_EngNom - rN_Hys) AND IN_EG.rP_Act_Norm < 0.01)  OR 
//							(xTON_Monitoring.Q AND (IN_EG.tEng_Run.Do AND NOT IN_EG.tGCB_On.Di));		
//		
//		xTON_Monitoring.IN := bMonitoringAct;
//		xTON_Monitoring.PT := T#5s;
//		xTON_Monitoring;
//	
//				
//		(* monitoring *)
//
//		IF bMonitoringAct THEN
//			IF IN_EG.rPos_TV < rPos_TV_HiHi OR xTON_Monitoring.Q THEN
//				IF IN_EG.rPos_TV >= rPos_TV_HiHi OR IN_EG.rPr_Ch_P2s_Avg > rPr_Ch_P2s_HiHi OR IN_EG.rN_EngAct < (Para.rN_EngNom - rN_Hys) THEN
//					bAMM_IdleFriction_HiHi := TRUE;
//				END_IF;	
//			END_IF;
//		ELSE
//			bAMM_IdleFriction_HiHi := FALSE;
//		END_IF;				

				
		(* activate monitoring *)
		
		xTON_Monitoring.IN := IN_EG.rN_EngAct > (Para.rN_EngNom - rN_Hys) AND IN_EG.rP_Act_Norm < 0.01 AND IN_EG.tEng_Run.Do AND NOT IN_EG.tGCB_On.Di;
		xTON_Monitoring.PT := T#8s;
		xTON_Monitoring;
	
		bMonitoringAct := 	xTON_Monitoring.Q OR	
							(
								IN_EG.rN_EngAct > (Para.rN_EngNom - rN_Hys) 
							AND IN_EG.rP_Act_Norm < 0.01 AND IN_EG.tEng_Run.Do AND NOT IN_EG.tGCB_On.Di
							AND IN_EG.rPos_TV < rPos_TV_HiHi
							AND IN_EG.rPr_Ch_P2s_Avg < rPr_Ch_P2s_HiHi 
							);		
		
				
		(* monitoring *)

		IF bMonitoringAct THEN
			IF IN_EG.rPos_TV >= rPos_TV_HiHi OR IN_EG.rPr_Ch_P2s_Avg > rPr_Ch_P2s_HiHi OR IN_EG.rN_EngAct < (Para.rN_EngNom - rN_Hys) THEN
				bAMM_IdleFriction_HiHi := TRUE;
			END_IF;
		ELSE
			bAMM_IdleFriction_HiHi := FALSE;
		END_IF;				
		
				
	ELSE
		bAMM_IdleFriction_HiHi := FALSE;
		xTON_Monitoring(IN	   := FALSE);
	END_IF;
	
END_PROGRAM
