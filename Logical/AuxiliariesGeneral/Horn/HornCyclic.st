(*******************************************************************************
horn		sound alarm

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
V0.1	03.07.1998 Pa			erstellt
		24.11.1998 Pa			Korrekturlesung
V1.70	14.03.2002 LH			HUPE / SUMMER
V2.073b	26.04.2006 ThJ			Evacuation
V2.33	15.07.2008 ThJ			3-colour signalling
V2.50	12.03.2009 ThJ			3-colour signalling expanded
V2.50.1	06.07.2009 ThJ			EVAC_HORN additionally from not stored signals
V3.10.0	17.02.2010 lettenb.		QUITT_WA -> E_QUITT (remote reset)
V4.10.0	07.12.2020 Schmid		reset horn off button from vis, CO alarm added to Evacuation, Horn_Trip used
						
Instructions for use:
--------------------
Outstandings:
------------
IN_AG.tHornCOf.Di	from visu ?
bLampHornTest		-"-
*******************************************************************************)
PROGRAM _CYCLIC
	
	//Rotating falsh beacon yellow
	Alarm := bGnlTrip OR bGnlWarning;
	
	//Evacuation
	EVACUATION := MM2VIS.bMsg1052 OR  MM2VIS.bMsg1053 OR  MM2VIS.bMsg1054 OR MM2VIS.bMsg3350 OR EVAC_HORN;
	
	//Evacuation - Horn
	xTP_GALV(IN:= NOT IN_AG.tGasPreAlarm.Di, PT:= T#179s950ms);
	xTP_M_GALV(IN:=  MM2VIS.bMsg1052,        PT:= T#179s950ms);
	xTP_GAL(IN:= NOT IN_AG.tGasAlarm.Di,     PT:= T#179s950ms);
	xTP_M_GAL(IN:=  MM2VIS.bMsg1053,         PT:= T#179s950ms);
	xTP_BAL(IN:= NOT IN_AG.tFireAlarm.Di,    PT:= T#179s950ms);
	xTP_M_BAL(IN:=  MM2VIS.bMsg1054,         PT:= T#179s950ms);
	xTP_COAL(IN:= NOT IN_AG.tCO_Alarm.Di,    PT:= T#179s950ms);
	xTP_M_COAL(IN:=  MM2VIS.bMsg3350,        PT:= T#179s950ms);
	
	EVAC_HORN := xTP_GALV.Q OR xTP_M_GALV.Q OR xTP_GAL.Q OR xTP_M_GAL.Q OR xTP_BAL.Q OR xTP_M_BAL.Q OR xTP_COAL.Q OR xTP_M_COAL.Q;
	
	xTOF_EV_TAKT02(IN:= EVACUATION AND EV_TAKT01, PT:= T#350ms);
	EV_TAKT02 := xTOF_EV_TAKT02.Q;
	
	xTON_EV_TAKT01(IN:= EVACUATION AND NOT EV_TAKT02, PT:= T#350ms);
	EV_TAKT01 := xTON_EV_TAKT01.Q;
	
	xTOF_EV_TAKT20(IN:= EVACUATION AND EV_TAKT10, PT:= T#1350ms);
	EV_TAKT20 := xTOF_EV_TAKT20.Q;
	
	xTON_EV_TAKT10(IN:= EVACUATION AND NOT EV_TAKT20, PT:= T#2350ms);
	EV_TAKT10 := xTON_EV_TAKT10.Q;
	
	//OUT_AG.tHorn.Do
	DmndHorn := (Alarm AND NOT M_HUPEAUS) OR (EVAC_HORN AND NOT EV_TAKT02 AND NOT EV_TAKT20);
	
	M_HUPEAUS := Alarm AND (M_HUPEAUS OR VIS2MM.bHornOff OR IN_AG.tAB2AG.bResetWarning OR T_HUPEAUS OR EVAC_HORN);

	// reset horn off button from vis
	IF VIS2MM.bHornOff THEN
		VIS2MM.bHornOff := FALSE;
	END_IF;
		
	// Turn OFF Horn after time
	xTON_HUPEAUS(IN:= OUT_AG.tHorn.Do, PT:= T#5m);
	T_HUPEAUS := xTON_HUPEAUS.Q;
	
	//OUT_AG.tHorn.Do / buzzer
	OUT_AG.tHorn.Do         := DmndHorn OR HornTest;
	OUT_AG.tHorn_Warning.Do := (Alarm AND NOT M_HUPEAUS AND bGnlWarning)	OR HornTest;
	OUT_AG.tHorn_Trip.Do	:= (Alarm AND NOT M_HUPEAUS AND bGnlTrip)		OR HornTest;
	MM2VIS.bHorn_Active		:= xHorn_Active.exist OR xHorn_Warning_Active.exist OR xHorn_Trip_Active.exist;
	
	//Signal RED, flashing output signal
	OUT_AG.tSignalR1.Do := (EVACUATION AND NOT EV_TAKT02 AND NOT EV_TAKT20) OR LampTest;
	OUT_AG.tSignalR2.Do := (EVACUATION AND NOT EV_TAKT02 AND NOT EV_TAKT20) OR LampTest;
	
	//Signal RED, continuous output signal, signal light itself is flashing
	OUT_AG.tSignal1R1.Do := EVACUATION OR LampTest;
	OUT_AG.tSignal1R2.Do :=               LampTest;
	
	//Signal YELLOW, continuous output signal
	OUT_AG.tSignalY1.Do      := Alarm OR LampTest;
	OUT_AG.tSignalY2.Do      := Alarm OR LampTest;
	OUT_AG.tRotatingLight.Do := Alarm OR LampTest;
	
	//Signal GREEN, continuous output signal
	OUT_AG.tSignalG1.Do := IN_AG.tEng_Run.Do OR LampTest;
	OUT_AG.tSignalG2.Do := IN_AG.tEng_Run.Do OR LampTest;
	
	xTP_LampTest(IN:= bLampHornTest, PT:= T#60s);
	LampTest := xTP_LampTest.Q;
	
	xTP_HornTest(IN:= bLampHornTest, PT:= T#5s);
	HornTest := xTP_HornTest.Q;
	
	bLampHornTest := FALSE;
	

END_PROGRAM
