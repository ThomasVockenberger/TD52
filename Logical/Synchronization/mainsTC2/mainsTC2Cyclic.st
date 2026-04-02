(*******************************************************************************
mainsTC2 			mains 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V4.04.0	07.10.2016	lettenb.	new for fast detection of frequency changes, dyn.gridcode III(thaler)			
V4.05.0	03.01.2018	lettenb.	bF_BB_AfMnsF_ClosCond added, grid code logic(thaler)
								IN_SY.tF_MMD_Synch2[1].Ai -> IN_SY.tF_MMD_BusBar[1].Ai

Instructions for use:
--------------------
IN_SY.tF_MMD_Synch2 mapping to Cyclic#2

Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC
 bF_BB_ClosCond_ZW_on  := FALSE;
 bF_BB_ClosCond_ZW_off := FALSE;

(* closing condition bus bar frequency *)
	IF 	   (IN_SY.tF_MMD_BusBar[1].Ai >= (Para.rF_BB_ClosCond_LimLo + Para.rF_BB_ClosCond_Hy))
		AND(IN_SY.tF_MMD_BusBar[1].Ai <= (Para.rF_BB_ClosCond_LimHi - Para.rF_BB_ClosCond_Hy)) THEN
		bF_BB_ClosCond_ZW_on  := TRUE;		
	ELSIF  (IN_SY.tF_MMD_BusBar[1].Ai > Para.rF_BB_ClosCond_LimHi)
		OR (IN_SY.tF_MMD_BusBar[1].Ai < Para.rF_BB_ClosCond_LimLo) THEN
		bF_BB_ClosCond_ZW_off := TRUE;
	END_IF;
	
	(* Verzögerung für kurzen Wischer Messsignal *)
	xTON_F_BB_ClosCond_ZW_on (IN:= bF_BB_ClosCond_ZW_on,  PT:= T#1s);
	xTON_F_BB_ClosCond_ZW_off(IN:= bF_BB_ClosCond_ZW_off, PT:= T#80ms);
	
	IF    xTON_F_BB_ClosCond_ZW_on.Q THEN
		bF_BB_ClosCond := TRUE;
	ELSIF xTON_F_BB_ClosCond_ZW_off.Q THEN
		bF_BB_ClosCond := FALSE;
	END_IF;


(*-------------------------------------------------------------------------------------------------------------*)	
 bF_BB_AfMnsF_ClosCond_ZW_on  := FALSE;
 bF_BB_AfMnsF_ClosCond_ZW_off := FALSE;
 
(* closing condition bus bar frequency - after mains failure *)
	IF 	   (IN_SY.tF_MMD_BusBar[1].Ai >= (Para.rF_BB_AfMnsF_ClosCond_LimLo + Para.rF_BB_AfMnsF_ClosCond_Hy))
		AND(IN_SY.tF_MMD_BusBar[1].Ai <= (Para.rF_BB_AfMnsF_ClosCond_LimHi - Para.rF_BB_AfMnsF_ClosCond_Hy)) THEN
		bF_BB_AfMnsF_ClosCond_ZW_on  := TRUE;		
	ELSIF  (IN_SY.tF_MMD_BusBar[1].Ai > Para.rF_BB_AfMnsF_ClosCond_LimHi)
		OR (IN_SY.tF_MMD_BusBar[1].Ai < Para.rF_BB_AfMnsF_ClosCond_LimLo) THEN
		bF_BB_AfMnsF_ClosCond_ZW_off := TRUE;
	END_IF;
	
	(* Verzögerung für kurzen Wischer Messsignal *)
	xTON_F_BB_AfMnsF_ClosCond_ZW_on (IN:= bF_BB_AfMnsF_ClosCond_ZW_on,  PT:= T#1s);
	xTON_F_BB_AfMnsF_ClosCond_ZW_off(IN:= bF_BB_AfMnsF_ClosCond_ZW_off, PT:= T#80ms);
	
	IF    xTON_F_BB_AfMnsF_ClosCond_ZW_on.Q THEN
		bF_BB_AfMnsF_ClosCond := TRUE;
	ELSIF xTON_F_BB_AfMnsF_ClosCond_ZW_off.Q THEN
		bF_BB_AfMnsF_ClosCond := FALSE;
	END_IF;	
	
	

END_PROGRAM