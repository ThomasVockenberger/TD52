(********************************************************************
MMUEarthFault	 			 Earth Fault Detection via MMU Signals

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023


Customized modifications: -
------------------------
 
History:
-------
4.13.0	29.06.2023	Perktold	new

Instructions for use: - 
--------------------
			
Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC

IF Para.rU_Gen_Nom[1] <> 0 THEN

	//Activate monitoring 2s after at least one Ph-Ph-Voltage exceeds 50% nominal voltage
	xTON_MonAct(IN := (MAX(IN_GC.tU_L1L2[1].Ai, IN_GC.tU_L2L3[1].Ai, IN_GC.tU_L3L1[1].Ai) > (Para.rU_Gen_Nom[1] * 0.5)), PT := T#2s);

	IF xTON_MonAct.Q THEN
	
		//Read pos. zero crossing time stamps and convert to [ms]
		rTimeStamp_PosZeroCrossing_UGen1 := DINT_TO_REAL(IN_GC.iTimeStamp_PosZeroCrossing_UGen1) / 4096000;	(* [ms] *)
		rTimeStamp_PosZeroCrossing_UGen2 := DINT_TO_REAL(IN_GC.iTimeStamp_PosZeroCrossing_UGen2) / 4096000;	(* [ms] *)
		rTimeStamp_PosZeroCrossing_UGen3 := DINT_TO_REAL(IN_GC.iTimeStamp_PosZeroCrossing_UGen3) / 4096000;	(* [ms] *)
	
		//Correct values for easy comparison if values overrun the DINT the negatve values get corrected by 1048.5759ms (total DINT range)
		iNumNeg	:= 0;
		IF ABS(rTimeStamp_PosZeroCrossing_UGen1) > 200 AND ABS(rTimeStamp_PosZeroCrossing_UGen2) > 200 AND ABS(rTimeStamp_PosZeroCrossing_UGen3) > 200 THEN
			IF rTimeStamp_PosZeroCrossing_UGen1 < 0.0 THEN	iNumNeg	:= iNumNeg + 1;	END_IF;
			IF rTimeStamp_PosZeroCrossing_UGen2 < 0.0 THEN	iNumNeg	:= iNumNeg + 1;	END_IF;
			IF rTimeStamp_PosZeroCrossing_UGen3 < 0.0 THEN	iNumNeg	:= iNumNeg + 1;	END_IF;
			
			IF (iNumNeg = 1) OR (iNumNeg = 2) THEN
				IF rTimeStamp_PosZeroCrossing_UGen1 < 0.0 THEN
					rTimeStamp_Calc_UGen1	:= rTimeStamp_PosZeroCrossing_UGen1 + 1048.57599975586;	(* [ms] *)
				ELSE
					rTimeStamp_Calc_UGen1	:= rTimeStamp_PosZeroCrossing_UGen1;					(* [ms] *)
				END_IF;
			
				IF rTimeStamp_PosZeroCrossing_UGen2 < 0.0 THEN
					rTimeStamp_Calc_UGen2	:= rTimeStamp_PosZeroCrossing_UGen2 + 1048.57599975586;	(* [ms] *)
				ELSE
					rTimeStamp_Calc_UGen2	:= rTimeStamp_PosZeroCrossing_UGen2;					(* [ms] *)
				END_IF;
			
				IF rTimeStamp_PosZeroCrossing_UGen3 < 0.0 THEN
					rTimeStamp_Calc_UGen3	:= rTimeStamp_PosZeroCrossing_UGen3 + 1048.57599975586;	(* [ms] *)
				ELSE
					rTimeStamp_Calc_UGen3	:= rTimeStamp_PosZeroCrossing_UGen3;					(* [ms] *)
				END_IF;
			ELSE
				rTimeStamp_Calc_UGen1	:= rTimeStamp_PosZeroCrossing_UGen1;						(* [ms] *)
				rTimeStamp_Calc_UGen2	:= rTimeStamp_PosZeroCrossing_UGen2;						(* [ms] *)
				rTimeStamp_Calc_UGen3	:= rTimeStamp_PosZeroCrossing_UGen3;						(* [ms] *)
			END_IF;
		ELSE
			rTimeStamp_Calc_UGen1	:= rTimeStamp_PosZeroCrossing_UGen1;							(* [ms] *)
			rTimeStamp_Calc_UGen2	:= rTimeStamp_PosZeroCrossing_UGen2;							(* [ms] *)
			rTimeStamp_Calc_UGen3	:= rTimeStamp_PosZeroCrossing_UGen3;							(* [ms] *)
		END_IF;
		
		//get the three values in the right order
		rTimeStamp_max	:= MAX(rTimeStamp_Calc_UGen1, rTimeStamp_Calc_UGen2, rTimeStamp_Calc_UGen3);
		rTimeStamp_min	:= MIN(rTimeStamp_Calc_UGen1, rTimeStamp_Calc_UGen2, rTimeStamp_Calc_UGen3);
		
		IF (rTimeStamp_Calc_UGen1 <> rTimeStamp_max) AND (rTimeStamp_Calc_UGen1 <> rTimeStamp_min) THEN
			rTimeStamp_mid	:= rTimeStamp_Calc_UGen1;
		ELSIF (rTimeStamp_Calc_UGen2 <> rTimeStamp_max) AND (rTimeStamp_Calc_UGen2 <> rTimeStamp_min) THEN
			rTimeStamp_mid	:= rTimeStamp_Calc_UGen2;
		ELSE
			rTimeStamp_mid	:= rTimeStamp_Calc_UGen3;
		END_IF;
	
		//Calculate time difference beween the time stamps
		rDelta_1 := rTimeStamp_mid - rTimeStamp_min;							(* [ms] *)
		rDelta_2 := rTimeStamp_max - rTimeStamp_mid;							(* [ms] *)
		
		rTPeriodTime	:= 1.0 / LIMIT(0.1, IN_GC.tF_MMD[1].Ai, 70.0) * 1000;	(* [ms] *)
		//convert to angle difference
		rDAng_1			:= rDelta_1 / rTPeriodTime * 360.0;						(* [Deg] *)
		rDAng_2			:= rDelta_2 / rTPeriodTime * 360.0;						(* [Deg] *)
		
		//Check if the values are 120[Deg] +- rDAng_Dev
		IF (rDAng_1 > (120.0 - rDAng_Dev)) AND (rDAng_1 < (120.0 + rDAng_Dev)) THEN
			bDANg_1_ok	:= TRUE;
		ELSE
			bDANg_1_ok	:= FALSE;
		END_IF
			
		IF (rDAng_2 > (120.0 - rDAng_Dev)) AND (rDAng_2 < (120.0 + rDAng_Dev)) THEN
			bDANg_2_ok	:= TRUE;
		ELSE
			bDANg_2_ok	:= FALSE;
		END_IF
		
		//trigger warning and trip if at least on value stays out of range for a vertain time 
		xTON_warning(IN := ((NOT bDANg_1_ok OR NOT bDANg_2_ok) AND Para.bMMDGroundFaultMonAct AND (Para.tTi_MMDGroundFaultWarning > T#0ms)), PT := Para.tTi_MMDGroundFaultWarning);
		xTON_trip(IN 	:= ((NOT bDANg_1_ok OR NOT bDANg_2_ok) AND Para.bMMDGroundFaultMonAct AND (Para.tTi_MMDGroundFaultTrip > T#0ms)), PT := Para.tTi_MMDGroundFaultTrip);
		
		bMsg9372_set			:= xTON_warning.Q;		(*W9372 Multi measurement device: Earth failure generator*)
		bMsg2373_set			:= xTON_trip.Q;			(*A2373 Multi measurement device: Earth failure generator*)
	ELSE
		bMsg9372_set			:= FALSE;
		bMsg2373_set			:= FALSE;
		xTON_warning(IN := FALSE, PT := Para.tTi_MMDGroundFaultWarning);
		xTON_trip(IN 	:= FALSE, PT := Para.tTi_MMDGroundFaultTrip);
	END_IF;
ELSE
	bMsg9372_set	:= FALSE;
	bMsg2373_set	:= FALSE;
	xTON_warning(IN	:= FALSE, PT := Para.tTi_MMDGroundFaultWarning);
	xTON_trip(IN 	:= FALSE, PT := Para.tTi_MMDGroundFaultTrip);
	xTON_MonAct(IN 	:= FALSE, PT := T#2s);
END_IF;

END_PROGRAM
