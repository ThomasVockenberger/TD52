(*******************************************************************************
Cnt_P_Heat		counter for heat power engine heat water circuit

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, OR reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------

History:
-------
V4.03.0		Stary 		created  
			lettenb.	xImp_Cnt_P_Heat: function call brackets missing, bugfix		

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC	

	(* counter heat power engine heat water circuit *) 
	xImp_Cnt_P_Heat(CLK:= IN_HC.tP_Heat_Imp.Di);

	
	(* counter heat power engine heat water circuit *)
	IF xImp_Cnt_P_Heat.Q THEN
		(* increase counter *)
		MM2VIS.iCnt_P_Heat := MM2VIS.iCnt_P_Heat + REAL_TO_INT(Para.rImpVal_Cnt_P_Heat);
		(* check limits *)
		IF MM2VIS.iCnt_P_Heat >= 1000000000 THEN
			MM2VIS.iCnt_P_Heat := MM2VIS.iCnt_P_Heat - 1000000000;		(* check upper limit *)
		ELSIF MM2VIS.iCnt_P_Heat <= -1000000000 THEN
			MM2VIS.iCnt_P_Heat := MM2VIS.iCnt_P_Heat + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	OUT_HC.iCnt_P_Heat	:= MM2VIS.iCnt_P_Heat;		(* MM2VIS = read/write = ausnahme damit vis abwärtskompatibel bleibt!!*)
	
END_PROGRAM
