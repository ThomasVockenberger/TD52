(*******************************************************************************
MainBearing: idle friction monitoring (init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019     

- check throttle position, boost pressure AND speed TO prevent engine damage

Customized modifications: -
------------------------

History:
-------
V4.4	28-01-2016	Weitzer, 	generated
V4.4.2	19-07-2017	Weitzer,    change boost pressure limit to 0.70 bar
			   
Instructions FOR use:
--------------------

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT

	(* define limits *)
	rN_Hys 			:= 20.0;	(* speed *)
	rPos_TV_HiHi	:= 0.15;	(* throttle valve position *)
	rPr_Ch_P2s_HiHi := 0.70;	(* boost pressure *)

	(* deactivate function after restart of the PLC system *)	
	IF iCntOpH = 0 THEN
		iCntOpH := 11;
	END_IF;	

END_PROGRAM

