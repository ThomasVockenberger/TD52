(*******************************************************************************
reac_set	THERMOREACTOR SETTINGS

This code is confidential AND proprietary TO the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission OF the INNIO Company.
Copyright, INNIO Company, 2019
					
Customized modifications: -
------------------------
					 
History:
-------
V3.20.0 16-12-2010  Thaler, generated
        16-12-2010	Thaler, last modification,
                            compatible with XT Version from V2.2x upwards.
   	
V04.00.00	04-04-2014  Ganguly, converted to modular software


Instructions for use:
--------------------
description interface --> Task "reactor" ( BOOL, where NOT otherwise stated ):
 
(* UM_E_NEU_moduleTR:       type of position switches 4-way-flap: TRUE = 3 end positions (5 switches)
sel_NatGas:     select gas injection natural gas (spare)
sel_woGas:      select w/o gas injection
TK_w_woGas:     TK_moduleTR setpoint without gas injection  ( 0,1 °C   )
PT_KL_Pinc:     flap switching interval load incr. ( 1,0 sec. )
set_PT_KL_Pinc: set flap interval load increase
		
		
Outstandings: - 
------------
*******************************************************************************)

PROGRAM _CYCLIC

IF Para.bThR_woGas THEN
    (* thermal reactor - TK_moduleTR setpoint without gas injection *)
  	(* --> check/choose Reserve Parameter No. plant specific ! *)
    (* Old Parameter: TK_w_woGas. Default 720.0°C *)
    Para.rT_ThR_SetwoGas := LIMIT (700.0, Para.rT_ThR_SetwoGas, 780.0); (* 0,1°C *)
        
    (* thermal reactor - limit value for load increase within the time slot *)
	(* --> check/choose Reserve Parameter No. plant specific ! *)
	Limit_Pinc := LIMIT (20.0, Para.rT_ThR_LimPInc, 80.0); (* 0,1 % *)
        
    (* thermal reactor - time slot for monitoring any load increase *)
	(* --> check/choose Reserve Parameter No. plant specific ! *)
    TimeSlot_Pinc := LIMIT (T#600s, Para.ti_ThR_TimePInc, T#1000s); (* 1,0 sec *)       
        
	No_ScanIntervals := LIMIT (6, (TIME_TO_INT(TimeSlot_Pinc)/ 10), 100);

		
    (* thermal reactor - duration for set the flap switching interval on load increase value *)
	(* --> check/choose Reserve Parameter No. plant specific ! *)
	// Old Parameter PTOF_KL_Pinc_i. Para.ti_ThR_ValDurationPInc = T#600s (default)
    Para.ti_ThR_ValDurationPInc := LIMIT (T#60s, Para.ti_ThR_ValDurationPInc, T#3600s); (* 1,0 sec *)        			

    (* thermal reactor - flap switching interval: load increase value *)
	(* --> check/choose Reserve Parameter No. plant specific ! *)
    // Old Parameter PT_KL_Pinc. Para.ti_ThR_ValIntervalPInc = T#210s (default)
    Para.ti_ThR_ValIntervalPInc := LIMIT (T#100s, Para.ti_ThR_ValIntervalPInc, T#600s); (* 1,0 sec *)
		
END_IF;

(* Takt 1 sec. *)
xTOF_TAKT02(IN:= xTON_TAKT01.Q, PT:= T#350ms);
xTON_TAKT01(IN:= NOT xTOF_TAKT02.Q, PT:= T#350ms);
xR_TRIG_TAKT1(CLK:= xTON_TAKT01.Q);
TAKT1 := xR_TRIG_TAKT1.Q;
(* Takt 10 sec. *)
xTOF_TAKT102(IN:= xTON_TAKT101.Q, PT:= T#9s350ms);
xTON_TAKT101(IN:= NOT xTOF_TAKT102.Q, PT:= T#350ms);
xR_TRIG_TAKT10(CLK:= xTON_TAKT101.Q);
TAKT10 := xR_TRIG_TAKT10.Q;

(* Ringbuffer *)
IF TAKT10 = TRUE THEN (* scan interval *)
    Delta_P := IN_TR.rP_Act_Norm_Filt - P_old; (* load delta within scan interval, 0,1 % *)
    P_old   := IN_TR.rP_Act_Norm_Filt;
    IF (FG_HEIZG_moduleTR = TRUE OR IN_TR.tGCB_On.Di) THEN
        DeltaP[i1] := Delta_P; (* 0,1 % *)
    ELSE
        DeltaP[i1] := 0; (* 0,1 % *)
    END_IF;
    i1 := i1 +1;
    IF i1 > (No_ScanIntervals - 1) THEN
        i1 := 0;
    END_IF;
END_IF;

a := 0;
FOR i := 0 TO (No_ScanIntervals - 1) BY 1 DO
    a := a + DeltaP[i];
END_FOR;
DeltaP_t := a; (* load delta within time slot, 0,1 % *)

(* set the flap switching interval on load increase value. Old signal PTOF_KL_Pinc*)
xTOF_KL_Pinc(IN:= (DeltaP_t >= Limit_Pinc), PT:= Para.ti_ThR_ValDurationPInc);

(* interface --> Task "reactor" *)
set_PT_KL_Pinc := xTOF_KL_Pinc.Q;


(* end of settings *)
(******************************************************************************)
END_PROGRAM
