(********************************************************************
This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------

History:
-------
V4.07.00	08.01.2019	Schmid		created redundant pump control FUB
			29.01.2019	Schmid		defective pump can be reactivated BY acknowledging warning /
									if FUB is disabled -> use pump 1 without monitoring (for commissioning)
			18.03.2019	Schmid		pump DEACTIVATED if FUB disabled

Instructions FOR use:
--------------------

Outstandings: - 
------------
*******************************************************************************)

FUNCTION_BLOCK RedPump
		
	IF Enable THEN		
		(* detect new pump demand -> increase pump counter *)
		xR_TRIG_DemGnl(CLK:= bDemGnl);
		IF xR_TRIG_DemGnl.Q THEN
			iActive_Pump := iActive_Pump + 1;
		END_IF;

		IF bDemGnl AND ((iActive_Pump = 0) OR (iActive_Pump > 2)) THEN
			iActive_Pump := 1;
		END_IF;

		IF bReadMsg_noFB THEN
			(* if malfunctioning pump was detected use other pump *)
			CASE iReadPumpIdx_noFB OF
				1 :		iActive_Pump := 2;
				2 :		iActive_Pump := 1;
				ELSE	iActive_Pump := 0;	(* iReadPumpIdx_noFB = 3		-> switch off both pumps *)
			END_CASE;
			
			(* allow warning to be acknowledged as soon as malfunctioning pump is not demanded *)
			bSetMsg_noFB := FALSE;
		END_IF;

		(* demand pump *)
		CASE iActive_Pump OF
			1 :		bPump1_Dem		:= bDemGnl;
					bPump2_Dem		:= FALSE;
					xTON_noFB.IN	:= bDemGnl AND NOT bPump1_Op;
			2 :		bPump1_Dem		:= FALSE;
					bPump2_Dem		:= bDemGnl;
					xTON_noFB.IN	:= bDemGnl AND NOT bPump2_Op;
			ELSE	bPump1_Dem		:= FALSE;
					bPump2_Dem		:= FALSE;
					xTON_noFB.IN	:= FALSE;
		END_CASE;

		(* detect inoperative/malfunctioning pump and switch to other pump *)
		xTON_noFB.PT	:= tiNoFB_Timeout;
		xTON_noFB();
		xR_TRIG_noFB(CLK:= xTON_noFB.Q AND bMonActive);
		IF xR_TRIG_noFB.Q THEN
			bSetMsg_noFB := TRUE;
			IF iReadPumpIdx_noFB = 0 THEN
				iSetPumpIdx_noFB := USINT_TO_INT(iActive_Pump);
			ELSE
				iSetPumpIdx_noFB := 3;	(* both pumps malfunctioning *)
			END_IF;
			xTON_noFB(IN:= FALSE);		(* reset TON for next pump *)
			iActive_Pump := iActive_Pump + 1;
		END_IF;

		(* reactivate malfunctioning pump by acknowledging warning *)
		xF_TRIG_ReadMsg_noFB(CLK:= bReadMsg_noFB);
		IF xF_TRIG_ReadMsg_noFB.Q THEN
			iSetPumpIdx_noFB	:= 0;
		END_IF;
		
	ELSE
		(* default pump demand if FUB is disabled *)
		bPump1_Dem			:= FALSE;
		bPump2_Dem			:= FALSE;

		(* reset outputs/ID of malfunctioning pump *)
		iActive_Pump		:= 0;
		bSetMsg_noFB		:= FALSE;
		iSetPumpIdx_noFB	:= 0;
	END_IF;

END_FUNCTION_BLOCK