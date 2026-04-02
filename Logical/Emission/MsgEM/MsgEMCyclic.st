(*******************************************************************************
Msg_EM	 			 alarms generation MM_emission

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V0.01.0	02.11.2011	lettenb.	new
		27.05.2013	lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
V4.0.0  02-10-2013  Maxhera,    implementation of the module for modular software
V4.05.0	22.05.2017	Tinello		SCR added, 2276 deleted
		29.01.2018	Tinello		NOx warnings added
V4.05.1	19.02.2018	Tinello		9212 aktiviert, Verzögerung für MS-Sto von 60s auf 10s
V4.07.0	23.04.2019	Tinello		Neue Warnungen für NOx-Selbstdiagnose / Dosierung gestoppt / externe SCR Systeme / NOx lifetime reached
								Warning 2451, 2453 and 3456 can only be acknowledged if blocking of valve/pump is no longer present
								W3482, W3483 und A3380 deleted
V4.07.1	31.10.2019	Tinello		new parameter for lifetime monitoring / measurement signal error delay changed from 10s to 60s
V4.09.0	24.02.2020	Tinello		bugfix -> operating message was too short for HMI / SCR customer input always active
		01.07.2020	Tinello		bugfix -> Message only active if urea dosing controller is active
V4.11.0	11.04.2022	Tinello		CAT temp min monitoring added / W9252 delay from 0->5s
V4.13.0	21.11.2023	Tinello		New operating messages and warnings added
V4.14.0	18.06.2024	Soto	  	Low NOx sensor with CAN communication IF3 considered in W2609 (2023-183)
														
Instructions for use:
--------------------
1) declare alarm with function block "Alm"
	declare buffert alarm bit bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	


3)  expand INIT

3)	include datapoint into OPC configuration for vis

			
Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC	
	
	(* reset general trip *)
	OUT_EM.tEM2AB.bGnlTrip1		:=	FALSE;
	OUT_EM.tEM2AB.bGnlTrip2		:=	FALSE;
	OUT_EM.tEM2AB.bGnlTrip3		:=	FALSE;
	OUT_EM.tEM2AB.bGnlWarning	:=	FALSE;
	OUT_EM.tEM2AB.bTriptype1	:=	FALSE;
	OUT_EM.tEM2AB.bTriptype2	:=	FALSE;
	OUT_EM.tEM2AB.bTriptype3	:=	FALSE;	

	
	(* A2276 NOx deviation *) 					(* --> NOT USED *)
	xMsg2276.Enable	   	:= FALSE;
	xMsg2276.Set	   	:= FALSE;
	xMsg2276.PT		   	:= T#0s;
	xMsg2276.Prio 	   	:= 3;
	xMsg2276.RiskClass 	:= 4;
	xMsg2276.Reset		:= FALSE;
	xMsg2276();
	MM2VIS.bMsg2276   	:= xMsg2276.Q;

	
	(* W2446 SCR BUS communication interrupted *)
	xMsg2446.Enable		:= TRUE;
	xMsg2446.Set		:= bAMM_2446;
	xMsg2446.PT			:= T#10s;
	xMsg2446.Prio		:= 4;
	xMsg2446.RiskClass	:= 4;
	xMsg2446.Reset		:= FALSE;
	xMsg2446();
	MM2VIS.bMsg2446		:= xMsg2446.Q;


	(* W2447 SCR Measuring signal failure urea pressure before dosing *)
	xMsg2447.Enable		:= TRUE;
	xMsg2447.Set		:= bAMM_2447;
	xMsg2447.PT			:= T#10s;
	xMsg2447.Prio		:= 4;
	xMsg2447.RiskClass	:= 4;
	xMsg2447.Reset		:= FALSE;
	xMsg2447();
	MM2VIS.bMsg2447		:= xMsg2447.Q;


	(* W2448 SCR Urea pressure before dosing minimum *)
	xMsg2448.Enable		:= TRUE;
	xMsg2448.Set		:= bAMM_2448;
	xMsg2448.PT			:= T#60s;
	xMsg2448.Prio		:= 4;
	xMsg2448.RiskClass	:= 4;
	xMsg2448.Reset		:= FALSE;
	xMsg2448();
	MM2VIS.bMsg2448		:= xMsg2448.Q;


	(* W2449 SCR Urea pressure before dosing maximum *)
	xMsg2449.Enable		:= TRUE;
	xMsg2449.Set		:= bAMM_2449;
	xMsg2449.PT			:= T#60s;
	xMsg2449.Prio		:= 4;
	xMsg2449.RiskClass	:= 4;
	xMsg2449.Reset		:= FALSE;
	xMsg2449();
	MM2VIS.bMsg2449		:= xMsg2449.Q;


	(* W2450 SCR Leakage in urea dosing cabinet *)
	xMsg2450.Enable		:= Para.bSCR_Active OR Para.bSCR_Cust_Active;
	xMsg2450.Set		:= NOT IN_EM.tLev_SCR_UreaDosingCabinet_Hi.Di;
	xMsg2450.PT			:= T#30s;
	xMsg2450.Prio		:= 4;
	xMsg2450.RiskClass	:= 4;
	xMsg2450.Reset		:= FALSE;
	xMsg2450();
	MM2VIS.bMsg2450		:= xMsg2450.Q;


	(* W2451 SCR Urea dosing valve - error *)
	xMsg2451.Enable		:= TRUE;
	xMsg2451.Set		:= bAMM_2451 OR (MM2VIS.bMsg2451 AND (VIS2MM.bSCR_UreaDosingUnit_Blocked OR 
															  VIS2MM.bSCR_UreaDosingUnit2_Blocked  ));
	xMsg2451.PT			:= T#1s;
	xMsg2451.Prio		:= 4;
	xMsg2451.RiskClass	:= 4;
	xMsg2451.Reset		:= FALSE;
	xMsg2451();
	MM2VIS.bMsg2451		:= xMsg2451.Q;


	(* W2452 SCR Measuring signal failure urea flow rate after dosing *)
	xMsg2452.Enable		:= TRUE;
	xMsg2452.Set		:= bAMM_2452;
	xMsg2452.PT			:= T#10s;
	xMsg2452.Prio		:= 4;
	xMsg2452.RiskClass	:= 4;
	xMsg2452.Reset		:= FALSE;
	xMsg2452();
	MM2VIS.bMsg2452		:= xMsg2452.Q;


	(* W2453 SCR Urea flow rate - valve characteristic deviating maximum *)
	xMsg2453.Enable		:= TRUE;
	xMsg2453.Set		:= bAMM_2453 OR (MM2VIS.bMsg2453 AND (VIS2MM.bSCR_UreaDosingUnit_Blocked OR 
															  VIS2MM.bSCR_UreaDosingUnit2_Blocked  ));
	xMsg2453.PT			:= T#1s;
	xMsg2453.Prio		:= 4;
	xMsg2453.RiskClass	:= 4;
	xMsg2453.Reset		:= FALSE;
	xMsg2453();
	MM2VIS.bMsg2453		:= xMsg2453.Q;


	(* W2454 SCR Compressed air supply pressure urea injection maximum *)
	xMsg2454.Enable		:= TRUE;
	xMsg2454.Set		:= bAMM_2454;
	xMsg2454.PT			:= T#60s;
	xMsg2454.Prio		:= 4;
	xMsg2454.RiskClass	:= 4;
	xMsg2454.Reset		:= FALSE;
	xMsg2454();
	MM2VIS.bMsg2454		:= xMsg2454.Q;


	(* W2455 SCR Deviation to continous emission monitoring system maximum *)
	xMsg2455.Enable		:= TRUE;
	xMsg2455.Set		:= (EDGEPOS(bAMM_2455_CO) OR EDGEPOS(bAMM_2455_NOx) OR EDGEPOS(bAMM_2455_NOxS)) AND xTON_bRel_SCR_UDC_5m.Q;
	xMsg2455.PT			:= T#0s;
	xMsg2455.Prio		:= 4;
	xMsg2455.RiskClass	:= 4;
	xMsg2455.Reset		:= FALSE;
	xMsg2455();
	MM2VIS.bMsg2455		:= xMsg2455.Q;


	(* W2456 SCR Emission measurement line 1 - O2 maximum *)
	xMsg2456.Enable		:= TRUE;
	xMsg2456.Set		:= bAMM_2456;
	xMsg2456.PT			:= T#60s;
	xMsg2456.Prio		:= 4;
	xMsg2456.RiskClass	:= 4;
	xMsg2456.Reset		:= FALSE;
	xMsg2456();
	MM2VIS.bMsg2456		:= xMsg2456.Q;


	(* W2457 SCR Measuring signal failure emission measurement line 1 - O2 sensor *)
	xMsg2457.Enable		:= TRUE;
	xMsg2457.Set		:= bAMM_2457;
	xMsg2457.PT			:= T#10s;
	xMsg2457.Prio		:= 4;
	xMsg2457.RiskClass	:= 4;
	xMsg2457.Reset		:= FALSE;
	xMsg2457();
	MM2VIS.bMsg2457		:= xMsg2457.Q;


	(* W2458 SCR Measuring signal failure emission measurement line 2 - NO2 sensor *)
	xMsg2458.Enable		:= TRUE;
	xMsg2458.Set		:= bAMM_2458;
	xMsg2458.PT			:= T#10s;
	xMsg2458.Prio		:= 4;
	xMsg2458.RiskClass	:= 4;
	xMsg2458.Reset		:= FALSE;
	xMsg2458();
	MM2VIS.bMsg2458		:= xMsg2458.Q;


	(* W2464 SCR Urea dosing unit (external) - error *)
	xMsg2464.Enable		:= TRUE;
	xMsg2464.Set		:= bAMM_2464;
	xMsg2464.PT			:= T#5s;
	xMsg2464.Prio		:= 4;
	xMsg2464.RiskClass	:= 4;
	xMsg2464.Reset		:= FALSE;
	xMsg2464();
	MM2VIS.bMsg2464		:= xMsg2464.Q;


	(* W2607 CAN failure - NOx sensor CAN interface 1 *)
	xMsg2607.Enable	   	:= TRUE;
	xMsg2607.Set	   	:= bAMM_NOxS_CAN_IF1;
	xMsg2607.PT		   	:= T#10s;
	xMsg2607.Prio 	   	:= 4;
	xMsg2607.RiskClass 	:= 4;
	xMsg2607();
	MM2VIS.bMsg2607    	:= xMsg2607.Q;

		
	(* W2609 CAN failure - NOx sensor CAN interface 2 or 3 *)
	xMsg2609.Enable	   	:= TRUE;
	xMsg2609.Set	   	:= bAMM_NOxS_CAN_IF2 OR bAMM_NOxS_CAN_IF3;
	xMsg2609.PT		   	:= T#10s;
	xMsg2609.Prio 	   	:= 4;
	xMsg2609.RiskClass 	:= 4;
	xMsg2609();
	MM2VIS.bMsg2609    	:= xMsg2609.Q;
	

	(* W2610 No connection to the sensor - NOx sensor engine out *)
	xMsg2610.Enable	   	:= TRUE;
	xMsg2610.Set	   	:= bAMM_NOxS_CAN_EngOut;
	xMsg2610.PT		   	:= T#1s;
	xMsg2610.Prio 	   	:= 4;
	xMsg2610.RiskClass 	:= 4;
	xMsg2610();
	MM2VIS.bMsg2610   	:= xMsg2610.Q;


	(* W2697 SCR Urea dosing unit - maintenance needed *)
	xMsg2697.Enable		:= TRUE;
	xMsg2697.Set		:= bAMM_2697;
	xMsg2697.PT			:= T#0s;
	xMsg2697.Prio		:= 4;
	xMsg2697.RiskClass	:= 4;
	xMsg2697.Reset		:= FALSE;
	xMsg2697();
	MM2VIS.bMsg2697		:= xMsg2697.Q;


	(* W2766 Catalyst temperature minimum *)
	xMsg2766.Enable		:= TRUE;
	xMsg2766.Set		:= bAMM_2766;
	xMsg2766.PT			:= T#10s;
	xMsg2766.Prio		:= 4;
	xMsg2766.RiskClass	:= 4;
	xMsg2766.Reset		:= FALSE;
	xMsg2766();
	MM2VIS.bMsg2766		:= xMsg2766.Q;
	
	
	(* W2769 SCR Emission measurement air line - moisture maximum *)
	xMsg2769.Enable		:= TRUE;
	xMsg2769.Set		:= bAMM_2769;
	xMsg2769.PT			:= T#0s;
	xMsg2769.Prio		:= 4;
	xMsg2769.RiskClass	:= 4;
	xMsg2769.Reset		:= FALSE;
	xMsg2769();
	MM2VIS.bMsg2769		:= xMsg2769.Q;


	(* A3379 SCR Exhaust temperatures CAT maximum *)
		xTON_T_SCR_Cat3(IN:= NOT IN_EM.tT_SCR_Cat_HiHi.Di, PT:= T#1s);
	
	xMsg3379.Enable		:= TRUE;
	xMsg3379.Set		:= bAMM_3379 OR xTON_T_SCR_Cat3.Q;
	xMsg3379.PT			:= T#0s;
	xMsg3379.Prio		:= 3;
	xMsg3379.RiskClass	:= 4;
	xMsg3379.Reset		:= FALSE;
	xMsg3379();
	MM2VIS.bMsg3379		:= xMsg3379.Q;


	(* A3380 SCR CO emission average maximum *)			(* --> NOT USED *)
	xMsg3380.Enable		:= FALSE;
	xMsg3380.Set		:= FALSE;
	xMsg3380.PT			:= T#0s;
	xMsg3380.Prio		:= 3;
	xMsg3380.RiskClass	:= 4;
	xMsg3380.Reset		:= FALSE;
	xMsg3380();
	MM2VIS.bMsg3380		:= xMsg3380.Q;


	(* A3381 NOx emissions - short-term average high *)
	xMsg3381.Enable		:= TRUE;
	xMsg3381.Set		:= bAMM_3381;
	xMsg3381.PT			:= T#0s;
	xMsg3381.Prio		:= 3;
	xMsg3381.RiskClass	:= 4;
	xMsg3381.Reset		:= FALSE;
	xMsg3381();	
	MM2VIS.bMsg3381		:= xMsg3381.Q;


	(* A3383 SCR Measuring signal failure exhaust temperatures CAT *)
	xMsg3383.Enable		:= TRUE;
	xMsg3383.Set		:= bAMM_3383;
	xMsg3383.PT			:= T#300s;
	xMsg3383.Prio		:= 3;
	xMsg3383.RiskClass	:= 4;
	xMsg3383.Reset		:= FALSE;
	xMsg3383();
	MM2VIS.bMsg3383		:= xMsg3383.Q;
	
	
	(*	W3450 SCR Group alarm - exhaust after treatment system *)	(* --> NOT USED *)
	xMsg3450.Enable 	:= FALSE;
	xMsg3450.Set 		:= FALSE;
	xMsg3450.PT			:= T#0s;
	xMsg3450.Prio		:= 4;
	xMsg3450.RiskClass	:= 4;	
	xMsg3450();	
	MM2VIS.bMsg3450		:= xMsg3450.Q;


	(* W3451 SCR Power supply to the valves interrupted *)
	xMsg3451.Enable		:= TRUE;
	xMsg3451.Set		:= bAMM_3451;
	xMsg3451.PT			:= T#10s;
	xMsg3451.Prio		:= 4;
	xMsg3451.RiskClass	:= 4;
	xMsg3451.Reset		:= FALSE;
	xMsg3451();	
	MM2VIS.bMsg3451		:= xMsg3451.Q;


	(* W3452 SCR Measuring signal failure urea pressure after dosing *)
	xMsg3452.Enable		:= TRUE;
	xMsg3452.Set		:= bAMM_3452;
	xMsg3452.PT			:= T#10s;
	xMsg3452.Prio		:= 4;
	xMsg3452.RiskClass	:= 4;
	xMsg3452.Reset		:= FALSE;
	xMsg3452();
	MM2VIS.bMsg3452		:= xMsg3452.Q;


	(* W3453 SCR Urea pressure after dosing maximum *)
	xMsg3453.Enable		:= TRUE;
	xMsg3453.Set		:= bAMM_3453;
	xMsg3453.PT			:= T#0s;
	xMsg3453.Prio		:= 4;
	xMsg3453.RiskClass	:= 4;
	xMsg3453.Reset		:= FALSE;
	xMsg3453();
	MM2VIS.bMsg3453		:= xMsg3453.Q;


	(* W3454 SCR Urea pressure after dosing minimum *)
	xMsg3454.Enable		:= TRUE;
	xMsg3454.Set		:= bAMM_3454;
	xMsg3454.PT			:= T#60s;
	xMsg3454.Prio		:= 4;
	xMsg3454.RiskClass	:= 4;
	xMsg3454.Reset		:= FALSE;
	xMsg3454();
	MM2VIS.bMsg3454		:= xMsg3454.Q;


	(* W3455 SCR Urea flow rate after dosing maximum *)
	xMsg3455.Enable		:= TRUE;
	xMsg3455.Set		:= bAMM_3455;
	xMsg3455.PT			:= T#600s;
	xMsg3455.Prio		:= 4;
	xMsg3455.RiskClass	:= 4;
	xMsg3455.Reset		:= FALSE;
	xMsg3455();
	MM2VIS.bMsg3455		:= xMsg3455.Q;


	(* W3456 SCR Urea dosing pump - error *)
	xMsg3456.Enable		:= TRUE;
	xMsg3456.Set		:= bAMM_3456 OR (MM2VIS.bMsg3456 AND (VIS2MM.bSCR_UreaDosingUnit_Blocked OR 
															  VIS2MM.bSCR_UreaDosingUnit2_Blocked  ));
	xMsg3456.PT			:= T#1s;
	xMsg3456.Prio		:= 4;
	xMsg3456.RiskClass	:= 4;
	xMsg3456.Reset		:= FALSE;
	xMsg3456();
	MM2VIS.bMsg3456		:= xMsg3456.Q;


	(* W3457 SCR Urea-air valve blocked *)
	xMsg3457.Enable		:= TRUE;
	xMsg3457.Set		:= bAMM_3457;
	xMsg3457.PT			:= T#45s;
	xMsg3457.Prio		:= 4;
	xMsg3457.RiskClass	:= 4;
	xMsg3457.Reset		:= FALSE;
	xMsg3457();
	MM2VIS.bMsg3457		:= xMsg3457.Q;


	(* W3458 SCR Urea tank level minimum *)
	xMsg3458.Enable		:= Para.bSCR_Active OR Para.bSCR_Cust_Active;
	xMsg3458.Set		:= NOT IN_EM.tLev_SCR_UreaTank_Lo.Di OR (Para.bLev_SCR_UreaTank_Exist AND NOT bAMM_9379 AND IN_EM.tLev_SCR_UreaTank.Ai < Para.rLev_SCR_UreaTank_Lo);
	xMsg3458.PT			:= T#300s;
	xMsg3458.Prio		:= 4;
	xMsg3458.RiskClass	:= 4;
	xMsg3458.Reset		:= FALSE;
	xMsg3458();
	MM2VIS.bMsg3458		:= xMsg3458.Q;


	(* W3459 SCR Urea tank level minimum - dosing deactivated *)
	xMsg3459.Enable		:= TRUE;
	xMsg3459.Set		:= bAMM_3459;
	xMsg3459.PT			:= T#0s;
	xMsg3459.Prio		:= 4;
	xMsg3459.RiskClass	:= 4;
	xMsg3459.Reset		:= FALSE;
	xMsg3459();
	MM2VIS.bMsg3459		:= xMsg3459.Q;


	(* W3460 SCR Urea supply pump not operating *)
	xMsg3460.Enable		:= TRUE;
	xMsg3460.Set		:= bAMM_3460;
	xMsg3460.PT			:= T#30s;
	xMsg3460.Prio		:= 4;
	xMsg3460.RiskClass	:= 4;
	xMsg3460.Reset		:= FALSE;
	xMsg3460();
	MM2VIS.bMsg3460		:= xMsg3460.Q;


	(* W3461 SCR Measuring signal failure compressed air supply pressure urea injection *)
	xMsg3461.Enable		:= TRUE;
	xMsg3461.Set		:= bAMM_3461;
	xMsg3461.PT			:= T#10s;
	xMsg3461.Prio		:= 4;
	xMsg3461.RiskClass	:= 4;
	xMsg3461.Reset		:= FALSE;
	xMsg3461();
	MM2VIS.bMsg3461		:= xMsg3461.Q;


	(* W3462 SCR Compressed air supply pressure urea injection minimum *)
	xMsg3462.Enable		:= TRUE;
	xMsg3462.Set		:= bAMM_3462;
	xMsg3462.PT			:= T#60s;
	xMsg3462.Prio		:= 4;
	xMsg3462.RiskClass	:= 4;
	xMsg3462.Reset		:= FALSE;
	xMsg3462();
	MM2VIS.bMsg3462		:= xMsg3462.Q;


	(* W3463 SCR Compressed air urea injection power supply interrupted *)
	xMsg3463.Enable		:= TRUE;
	xMsg3463.Set		:= bAMM_3463;
	xMsg3463.PT			:= T#10s;
	xMsg3463.Prio		:= 4;
	xMsg3463.RiskClass	:= 4;
	xMsg3463.Reset		:= FALSE;
	xMsg3463();
	MM2VIS.bMsg3463		:= xMsg3463.Q;


	(* W3464 SCR Measuring signal failure exhaust pressure CAT inlet *)
	xMsg3464.Enable		:= TRUE;
	xMsg3464.Set		:= bAMM_3464;
	xMsg3464.PT			:= T#10s;
	xMsg3464.Prio		:= 4;
	xMsg3464.RiskClass	:= 4;
	xMsg3464.Reset		:= FALSE;
	xMsg3464();
	MM2VIS.bMsg3464		:= xMsg3464.Q;


	(* W3465 SCR Measuring signal failure exhaust pressure CAT outlet *)
	xMsg3465.Enable		:= TRUE;
	xMsg3465.Set		:= bAMM_3465;
	xMsg3465.PT			:= T#10s;
	xMsg3465.Prio		:= 4;
	xMsg3465.RiskClass	:= 4;
	xMsg3465.Reset		:= FALSE;
	xMsg3465();
	MM2VIS.bMsg3465		:= xMsg3465.Q;


	(* W3466 SCR Measuring signal failure exhaust temperature CAT inlet *)
	xMsg3466.Enable		:= TRUE;
	xMsg3466.Set		:= bAMM_3466;
	xMsg3466.PT			:= T#10s;
	xMsg3466.Prio		:= 4;
	xMsg3466.RiskClass	:= 4;
	xMsg3466.Reset		:= FALSE;
	xMsg3466();
	MM2VIS.bMsg3466		:= xMsg3466.Q;


	(* W3467 SCR Measuring signal failure exhaust temperature CAT outlet *)
	xMsg3467.Enable		:= TRUE;
	xMsg3467.Set		:= bAMM_3467;
	xMsg3467.PT			:= T#10s;
	xMsg3467.Prio		:= 4;
	xMsg3467.RiskClass	:= 4;
	xMsg3467.Reset		:= FALSE;
	xMsg3467();
	MM2VIS.bMsg3467		:= xMsg3467.Q;


	(* W3469 SCR Exhaust differential pressure CAT maximum *)
	xMsg3469.Enable		:= TRUE;
	xMsg3469.Set		:= bAMM_3469;
	xMsg3469.PT			:= T#300s;
	xMsg3469.Prio		:= 4;
	xMsg3469.RiskClass	:= 4;
	xMsg3469.Reset		:= FALSE;
	xMsg3469();
	MM2VIS.bMsg3469		:= xMsg3469.Q;


	(* W3470 SCR Emission measurement sample gas cooler - error *)
	xMsg3470.Enable		:= TRUE;
	xMsg3470.Set		:= bAMM_3470;
	xMsg3470.PT			:= T#60s;
	xMsg3470.Prio		:= 4;
	xMsg3470.RiskClass	:= 4;
	xMsg3470.Reset		:= FALSE;
	xMsg3470();
	MM2VIS.bMsg3470		:= xMsg3470.Q;


	(* W3471 SCR Emission measurement line 1 - sample gas pump not ready *)
	xMsg3471.Enable		:= TRUE;
	xMsg3471.Set		:= bAMM_3471;
	xMsg3471.PT			:= T#10s;
	xMsg3471.Prio		:= 4;
	xMsg3471.RiskClass	:= 4;
	xMsg3471.Reset		:= FALSE;
	xMsg3471();
	MM2VIS.bMsg3471		:= xMsg3471.Q;


	(* W3472 SCR Emission measurement line 2 - sample gas pump not operating *)
	xMsg3472.Enable		:= TRUE;
	xMsg3472.Set		:= bAMM_3472;
	xMsg3472.PT			:= T#10s;
	xMsg3472.Prio		:= 4;
	xMsg3472.RiskClass	:= 4;
	xMsg3472.Reset		:= FALSE;
	xMsg3472();
	MM2VIS.bMsg3472		:= xMsg3472.Q;


	(* W3473 SCR Emission measurement line 1 - moisture maximum *)
	xMsg3473.Enable		:= TRUE;
	xMsg3473.Set		:= bAMM_3473;
	xMsg3473.PT			:= T#10s;
	xMsg3473.Prio		:= 4;
	xMsg3473.RiskClass	:= 4;
	xMsg3473.Reset		:= FALSE;
	xMsg3473();
	MM2VIS.bMsg3473		:= xMsg3473.Q;


	(* W3474 SCR Emission measurement line 2 - moisture maximum *)
	xMsg3474.Enable		:= TRUE;
	xMsg3474.Set		:= bAMM_3474;
	xMsg3474.PT			:= T#10s;
	xMsg3474.Prio		:= 4;
	xMsg3474.RiskClass	:= 4;
	xMsg3474.Reset		:= FALSE;
	xMsg3474();
	MM2VIS.bMsg3474		:= xMsg3474.Q;


	(* W3475 SCR Emission measurement line 1 - flow rate minimum *)
	xMsg3475.Enable		:= TRUE;
	xMsg3475.Set		:= bAMM_3475;
	xMsg3475.PT			:= T#10s;
	xMsg3475.Prio		:= 4;
	xMsg3475.RiskClass	:= 4;
	xMsg3475.Reset		:= FALSE;
	xMsg3475();
	MM2VIS.bMsg3475		:= xMsg3475.Q;


	(* W3476 SCR Emission measurement line 2 - flow rate minimum *)
	xMsg3476.Enable		:= TRUE;
	xMsg3476.Set		:= bAMM_3476;
	xMsg3476.PT			:= T#10s;
	xMsg3476.Prio		:= 4;
	xMsg3476.RiskClass	:= 4;
	xMsg3476.Reset		:= FALSE;
	xMsg3476();
	MM2VIS.bMsg3476		:= xMsg3476.Q;


	(* W3477 SCR Measuring signal failure emission measurement line 2 - NO sensor *)
	xMsg3477.Enable		:= TRUE;
	xMsg3477.Set		:= bAMM_3477;
	xMsg3477.PT			:= T#10s;
	xMsg3477.Prio		:= 4;
	xMsg3477.RiskClass	:= 4;
	xMsg3477.Reset		:= FALSE;
	xMsg3477();
	MM2VIS.bMsg3477		:= xMsg3477.Q;


	(* W3478 SCR Measuring signal failure emission measurement line 1 - NO sensor *)
	xMsg3478.Enable		:= TRUE;
	xMsg3478.Set		:= bAMM_3478;
	xMsg3478.PT			:= T#10s;
	xMsg3478.Prio		:= 4;
	xMsg3478.RiskClass	:= 4;
	xMsg3478.Reset		:= FALSE;
	xMsg3478();
	MM2VIS.bMsg3478		:= xMsg3478.Q;


	(* W3479 SCR Measuring signal failure emission measurement line 1 - NO2 sensor *)
	xMsg3479.Enable		:= TRUE;
	xMsg3479.Set		:= bAMM_3479;
	xMsg3479.PT			:= T#10s;
	xMsg3479.Prio		:= 4;
	xMsg3479.RiskClass	:= 4;
	xMsg3479.Reset		:= FALSE;
	xMsg3479();
	MM2VIS.bMsg3479		:= xMsg3479.Q;


	(* W3480 SCR NH3 slip detection deactivated *)
	xMsg3480.Enable		:= TRUE;
	xMsg3480.Set		:= bAMM_3480;
	xMsg3480.PT			:= T#0s;
	xMsg3480.Prio		:= 4;
	xMsg3480.RiskClass	:= 4;
	xMsg3480.Reset		:= FALSE;
	xMsg3480();
	MM2VIS.bMsg3480		:= xMsg3480.Q;


	(* W3481 SCR Measuring signal failure emission measurement line 1 - CO sensor *)
	xMsg3481.Enable		:= TRUE;
	xMsg3481.Set		:= bAMM_3481;
	xMsg3481.PT			:= T#10s;
	xMsg3481.Prio		:= 4;
	xMsg3481.RiskClass	:= 4;
	xMsg3481.Reset		:= FALSE;
	xMsg3481();
	MM2VIS.bMsg3481		:= xMsg3481.Q;


	(* W3482 SCR NOx emission to check *)				(* --> NOT USED *)
	xMsg3482.Enable		:= FALSE;
	xMsg3482.Set		:= FALSE;
	xMsg3482.PT			:= T#0s;
	xMsg3482.Prio		:= 4;
	xMsg3482.RiskClass	:= 4;
	xMsg3482.Reset		:= FALSE;
	xMsg3482();
	MM2VIS.bMsg3482		:= xMsg3482.Q;


	(* W3483 SCR CO emission to check *)				(* --> NOT USED *)
	xMsg3483.Enable		:= FALSE;
	xMsg3483.Set		:= FALSE;
	xMsg3483.PT			:= T#0s;
	xMsg3483.Prio		:= 4;
	xMsg3483.RiskClass	:= 4;
	xMsg3483.Reset		:= FALSE;
	xMsg3483();
	MM2VIS.bMsg3483		:= xMsg3483.Q;


	(* W3484 CO emissions - short-term average high *)
	xMsg3484.Enable		:= TRUE;
	xMsg3484.Set		:= bAMM_3484;
	xMsg3484.PT			:= T#0s;
	xMsg3484.Prio		:= 4;
	xMsg3484.RiskClass	:= 4;
	xMsg3484.Reset		:= FALSE;
	xMsg3484();
	MM2VIS.bMsg3484		:= xMsg3484.Q;


	(* W3485 NOx emissions - short-term average high *)
	xMsg3485.Enable		:= TRUE;
	xMsg3485.Set		:= bAMM_3485;
	xMsg3485.PT			:= T#0s;
	xMsg3485.Prio		:= 4;
	xMsg3485.RiskClass	:= 4;
	xMsg3485.Reset		:= FALSE;
	xMsg3485();
	MM2VIS.bMsg3485		:= xMsg3485.Q;


	(* W3486 SCR Urea flow rate after dosing minimum *)
	xMsg3486.Enable		:= TRUE;
	xMsg3486.Set		:= bAMM_3486;
	xMsg3486.PT			:= T#600s;
	xMsg3486.Prio		:= 4;
	xMsg3486.RiskClass	:= 4;
	xMsg3486.Reset		:= FALSE;
	xMsg3486();
	MM2VIS.bMsg3486		:= xMsg3486.Q;


	(* W3487 SCR Exhaust temperature CAT inlet maximum *)
	xMsg3487.Enable		:= TRUE;
	xMsg3487.Set		:= bAMM_3487;
	xMsg3487.PT			:= T#10s;
	xMsg3487.Prio		:= 4;
	xMsg3487.RiskClass	:= 4;
	xMsg3487.Reset		:= FALSE;
	xMsg3487();
	MM2VIS.bMsg3487		:= xMsg3487.Q;


	(* W3488 SCR Exhaust temperature CAT outlet maximum *)
	xMsg3488.Enable		:= TRUE;
	xMsg3488.Set		:= bAMM_3488;
	xMsg3488.PT			:= T#10s;
	xMsg3488.Prio		:= 4;
	xMsg3488.RiskClass	:= 4;
	xMsg3488.Reset		:= FALSE;
	xMsg3488();
	MM2VIS.bMsg3488		:= xMsg3488.Q;


	(* W3489 SCR Emergency Stop SCR control cabinet *)		(* --> NOT USED	*)	
	xMsg3489.Enable 	:= FALSE;
	xMsg3489.Set 		:= FALSE;
	xMsg3489.PT			:= T#0s;
	xMsg3489.Prio		:= 4;
	xMsg3489.RiskClass	:= 4;	
	xMsg3489.Reset		:= FALSE;
	xMsg3489();
	MM2VIS.bMsg3489		:= xMsg3489.Q;

	
	(* W9201 Measuring signal failure O2, NOx sensor engine out *)
	xMsg9201.Enable 	:= TRUE;
	xMsg9201.Set 		:= bAMM_O2_NOxS_EngOut_Ms;
	xMsg9201.PT			:= T#60s;
	xMsg9201.Prio		:= 4;
	xMsg9201.RiskClass	:= 4;	
	xMsg9201.Reset		:= FALSE;
	xMsg9201();
	MM2VIS.bMsg9201		:= xMsg9201.Q;	


	(* W9202 Measuring signal failure NOx, NOx sensor engine out *)
	xMsg9202.Enable 	:= TRUE;
	xMsg9202.Set 		:= bAMM_NOx_NOxS_EngOut_Ms;
	xMsg9202.PT			:= T#60s;
	xMsg9202.Prio		:= 4;
	xMsg9202.RiskClass	:= 4;	
	xMsg9202.Reset		:= FALSE;
	xMsg9202();
	MM2VIS.bMsg9202		:= xMsg9202.Q;


	(* W9203 No connection to the sensor - NOx sensor engine out A *)
	xMsg9203.Enable 	:= TRUE;
	xMsg9203.Set 		:= bAMM_NOxS_CAN_EngOut_A;
	xMsg9203.PT			:= T#1s;
	xMsg9203.Prio		:= 4;
	xMsg9203.RiskClass	:= 4;	
	xMsg9203.Reset		:= FALSE;
	xMsg9203();
	MM2VIS.bMsg9203		:= xMsg9203.Q;


	(* W9204 Measuring signal failure O2, NOx sensor engine out – bank A *)
	xMsg9204.Enable 	:= TRUE;
	xMsg9204.Set 		:= bAMM_O2_NOxS_EngOut_A_Ms;
	xMsg9204.PT			:= T#60s;
	xMsg9204.Prio		:= 4;
	xMsg9204.RiskClass	:= 4;	
	xMsg9204.Reset		:= FALSE;
	xMsg9204();
	MM2VIS.bMsg9204		:= xMsg9204.Q;


	(* W9205 Measuring signal failure NOx, NOx sensor engine out – bank A *)
	xMsg9205.Enable 	:= TRUE;
	xMsg9205.Set 		:= bAMM_NOx_NOxS_EngOut_A_Ms;
	xMsg9205.PT			:= T#60s;
	xMsg9205.Prio		:= 4;
	xMsg9205.RiskClass	:= 4;	
	xMsg9205.Reset		:= FALSE;
	xMsg9205();
	MM2VIS.bMsg9205		:= xMsg9205.Q;


	(* W9206 No connection to the sensor - NOx sensor engine out B *)
	xMsg9206.Enable 	:= TRUE;
	xMsg9206.Set 		:= bAMM_NOxS_CAN_EngOut_B;
	xMsg9206.PT			:= T#1s;
	xMsg9206.Prio		:= 4;
	xMsg9206.RiskClass	:= 4;	
	xMsg9206.Reset		:= FALSE;
	xMsg9206();
	MM2VIS.bMsg9206		:= xMsg9206.Q;


	(* W9207 Measuring signal failure O2, NOx sensor engine out – bank B *)
	xMsg9207.Enable 	:= TRUE;
	xMsg9207.Set 		:= bAMM_O2_NOxS_EngOut_B_Ms;
	xMsg9207.PT			:= T#60s;
	xMsg9207.Prio		:= 4;
	xMsg9207.RiskClass	:= 4;	
	xMsg9207.Reset		:= FALSE;
	xMsg9207();
	MM2VIS.bMsg9207		:= xMsg9207.Q;


	(* W9208 Measuring signal failure NOx, NOx sensor engine out – bank B *)
	xMsg9208.Enable 	:= TRUE;
	xMsg9208.Set 		:= bAMM_NOx_NOxS_EngOut_B_Ms;
	xMsg9208.PT			:= T#60s;
	xMsg9208.Prio		:= 4;
	xMsg9208.RiskClass	:= 4;	
	xMsg9208.Reset		:= FALSE;
	xMsg9208();
	MM2VIS.bMsg9208		:= xMsg9208.Q;


	(* W9209 No connection to the sensor - NOx sensor CAT out *)
	xMsg9209.Enable 	:= TRUE;
	xMsg9209.Set 		:= bAMM_NOxS_CAN_CatOut;
	xMsg9209.PT			:= T#1s;
	xMsg9209.Prio		:= 4;
	xMsg9209.RiskClass	:= 4;	
	xMsg9209.Reset		:= FALSE;
	xMsg9209();
	MM2VIS.bMsg9209		:= xMsg9209.Q;


	(* W9210 Measuring signal failure O2, NOx sensor CAT out *)
	xMsg9210.Enable 	:= TRUE;
	xMsg9210.Set 		:= bAMM_O2_NOxS_CatOut_Ms;
	xMsg9210.PT			:= T#60s;
	xMsg9210.Prio		:= 4;
	xMsg9210.RiskClass	:= 4;	
	xMsg9210.Reset		:= FALSE;
	xMsg9210();
	MM2VIS.bMsg9210		:= xMsg9210.Q;


	(* W9211 Measuring signal failure NOx, NOx sensor CAT out *)
	xMsg9211.Enable 	:= TRUE;
	xMsg9211.Set 		:= bAMM_NOx_NOxS_CatOut_Ms;
	xMsg9211.PT			:= T#60s;
	xMsg9211.Prio		:= 4;
	xMsg9211.RiskClass	:= 4;	
	xMsg9211.Reset		:= FALSE;
	xMsg9211();
	MM2VIS.bMsg9211		:= xMsg9211.Q;


	(* W9212 SCR Air compressor - maintenance needed  *)
	xMsg9212.Enable 	:= TRUE;
	xMsg9212.Set 		:= bAMM_9212;
	xMsg9212.PT			:= T#0s;
	xMsg9212.Prio		:= 4;
	xMsg9212.RiskClass	:= 4;	
	xMsg9212.Reset		:= FALSE;
	xMsg9212();
	MM2VIS.bMsg9212		:= xMsg9212.Q;


	(* W9233 Lifetime reached - NOx sensor engine out *)
	xMsg9233.Enable 	:= TRUE;
	xMsg9233.Set 		:= bNOxS_EngOut_Exist 	AND MM2VIS.iNOxS_EngOut_OpHours   >= Para.iNOxS_Lifetime;
	xMsg9233.PT			:= T#0s;
	xMsg9233.Prio		:= 4;
	xMsg9233.RiskClass	:= 4;	
	xMsg9233.Reset		:= FALSE;
	xMsg9233();
	MM2VIS.bMsg9233		:= xMsg9233.Q;


	(* W9234 Lifetime reached - NOx sensor engine out A *)
	xMsg9234.Enable 	:= TRUE;
	xMsg9234.Set 		:= bNOxS_EngOut_A_Exist AND MM2VIS.iNOxS_EngOut_A_OpHours >= Para.iNOxS_Lifetime;
	xMsg9234.PT			:= T#0s;
	xMsg9234.Prio		:= 4;
	xMsg9234.RiskClass	:= 4;	
	xMsg9234.Reset		:= FALSE;
	xMsg9234();
	MM2VIS.bMsg9234		:= xMsg9234.Q;


	(* W9235 Lifetime reached - NOx sensor engine out B *)
	xMsg9235.Enable 	:= TRUE;
	xMsg9235.Set 		:= bNOxS_EngOut_B_Exist	AND MM2VIS.iNOxS_EngOut_B_OpHours >= Para.iNOxS_Lifetime;
	xMsg9235.PT			:= T#0s;
	xMsg9235.Prio		:= 4;
	xMsg9235.RiskClass	:= 4;	
	xMsg9235.Reset		:= FALSE;
	xMsg9235();
	MM2VIS.bMsg9235		:= xMsg9235.Q;


	(* W9236 Lifetime reached - NOx sensor CAT out *)
	xMsg9236.Enable 	:= TRUE;
	xMsg9236.Set 		:= bNOxS_CatOut_Exist 	AND MM2VIS.iNOxS_CatOut_OpHours   >= Para.iNOxS_Lifetime;
	xMsg9236.PT			:= T#0s;
	xMsg9236.Prio		:= 4;
	xMsg9236.RiskClass	:= 4;	
	xMsg9236.Reset		:= FALSE;
	xMsg9236();
	MM2VIS.bMsg9236		:= xMsg9236.Q;


	(* W9250 O2 deviation bank A/B maximum - NOx sensor engine out *)
	xMsg9250.Enable 	:= TRUE;
	xMsg9250.Set 		:= bAMM_O2_NOxS_EngOut_Dev_Hi;
	xMsg9250.PT			:= T#0s;
	xMsg9250.Prio		:= 4;
	xMsg9250.RiskClass	:= 4;	
	xMsg9250.Reset		:= FALSE;
	xMsg9250();
	MM2VIS.bMsg9250		:= xMsg9250.Q;


	(* W9251 NOx deviation bank A/B maximum - NOx sensor engine out *)
	xMsg9251.Enable 	:= TRUE;
	xMsg9251.Set 		:= bAMM_NOx_NOxS_EngOut_Dev_Hi;
	xMsg9251.PT			:= T#0s;
	xMsg9251.Prio		:= 4;
	xMsg9251.RiskClass	:= 4;	
	xMsg9251.Reset		:= FALSE;
	xMsg9251();
	MM2VIS.bMsg9251		:= xMsg9251.Q;


	(* W9252 NOx emissions - daily average high *)
	xMsg9252.Enable 	:= TRUE;
	xMsg9252.Set 		:= bAMM_NOx_Em_AvgDaily_Hi;
	xMsg9252.PT			:= T#5s;
	xMsg9252.Prio		:= 4;
	xMsg9252.RiskClass	:= 4;	
	xMsg9252.Reset		:= FALSE;
	xMsg9252();
	MM2VIS.bMsg9252		:= xMsg9252.Q;


	(* W9277 SCR Urea dosing stopped - error *)
	xMsg9277.Enable 	:= TRUE;
	xMsg9277.Set 		:= bAMM_9277;
	xMsg9277.PT			:= T#0s;
	xMsg9277.Prio		:= 4;
	xMsg9277.RiskClass	:= 4;	
	xMsg9277.Reset		:= FALSE;
	xMsg9277();
	MM2VIS.bMsg9277		:= xMsg9277.Q;


	(* W9278 SCR Catalyst - failure (DI from customer) *)
	xMsg9278.Enable 	:= TRUE;
	xMsg9278.Set 		:= NOT IN_EM.tSCR_Catalyst_Rdy.Di;
	xMsg9278.PT			:= T#1s;
	xMsg9278.Prio		:= 4;
	xMsg9278.RiskClass	:= 4;	
	xMsg9278.Reset		:= FALSE;
	xMsg9278();
	MM2VIS.bMsg9278		:= xMsg9278.Q;

	(* W9379 SCR Measuring signal failure urea tank level *)
	xMsg9379.Enable 	:= TRUE;
	xMsg9379.Set 		:= bAMM_9379;
	xMsg9379.PT			:= T#10s;
	xMsg9379.Prio		:= 4;
	xMsg9379.RiskClass	:= 4;	
	xMsg9379.Reset		:= FALSE;
	xMsg9379();
	MM2VIS.bMsg9379		:= xMsg9379.Q;

	(* W9380 SCR Urea flow dosing error *)
	xMsg9380.Enable 	:= TRUE;
	xMsg9380.Set 		:= bAMM_9380;
	xMsg9380.PT			:= T#0s;
	xMsg9380.Prio		:= 4;
	xMsg9380.RiskClass	:= 4;	
	xMsg9380.Reset		:= FALSE;
	xMsg9380();
	MM2VIS.bMsg9380		:= xMsg9380.Q;


	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)
	
	(* B2877 SCR Exhaust after treatment deactivated *)	(* --> NOT USED *)
	xMsg2877.Enable 	:= FALSE;
	xMsg2877.Set 		:= FALSE; 	
	xMsg2877.Reset     	:= TRUE;
	xMsg2877();
	MM2VIS.bMsg2877		:= xMsg2877.Q;

	(* B2878 SCR Urea dosing activated *)			
	xMsg2878.Enable		:= TRUE;	
	xMsg2878.Set		:= bOpM_2878;	
	xMsg2878.Reset		:= TRUE;	
	xMsg2878();			
	MM2VIS.bMsg2878		:= xMsg2878.Q;	
				
	(* B2879 SCR Urea dosing deactivated *)			
	xMsg2879.Enable		:= TRUE;	
	xMsg2879.Set		:= bOpM_2879;	
	xMsg2879.Reset		:= TRUE;	
	xMsg2879();			
	MM2VIS.bMsg2879		:= xMsg2879.Q;	
				
	(* B2884 SCR Manual mode on *)			
	xMsg2884.Enable		:= TRUE;	
	xMsg2884.Set		:= bOpM_2884;	
	xMsg2884.Reset		:= TRUE;	
	xMsg2884();			
	MM2VIS.bMsg2884		:= xMsg2884.Q;	
				
	(* B2885 SCR Manual mode off *)			
	xMsg2885.Enable		:= TRUE;	
	xMsg2885.Set		:= bOpM_2885;
	xMsg2885.Reset		:= TRUE;	
	xMsg2885();			
	MM2VIS.bMsg2885		:= xMsg2885.Q;	
				
	(* B2923 SCR NH3 slip detection started *)			
	xMsg2923.Enable		:= TRUE;	
	xMsg2923.Set		:= bOpM_2923;
	xMsg2923.Reset		:= TRUE;	
	xMsg2923();			
	MM2VIS.bMsg2923		:= xMsg2923.Q;	
				
	(* B2924 SCR NH3 slip detection completed *)			
	xMsg2924.Enable		:= TRUE;	
	xMsg2924.Set		:= bOpM_2924;
	xMsg2924.Reset		:= TRUE;	
	xMsg2924();			
	MM2VIS.bMsg2924		:= xMsg2924.Q;	

	(* B2971 Error during self-diagnosis - NOx sensor engine out *)
	xTOF_EngOut_DiagErr(IN 	:= bOpM_NOxS_EngOut_DiagErr, 	PT := T#1s);		(* increase message time from 100ms to 1s for HMI *)

	xMsg2971.Enable			:= TRUE;
	xMsg2971.Set			:= xTOF_EngOut_DiagErr.Q;
	xMsg2971.Reset			:= TRUE;
	xMsg2971();
	MM2VIS.bMsg2971			:= xMsg2971.Q;

	(* B2974 Error during self-diagnosis - NOx sensor engine out A *)
	xTOF_EngOut_A_DiagErr(IN:= bOpM_NOxS_EngOut_A_DiagErr, 	PT := T#1s);		(* increase message time from 100ms to 1s for HMI *)

	xMsg2974.Enable			:= TRUE;
	xMsg2974.Set			:= xTOF_EngOut_A_DiagErr.Q;
	xMsg2974.Reset			:= TRUE;
	xMsg2974();
	MM2VIS.bMsg2974			:= xMsg2974.Q;

	(* B2977 Error during self-diagnosis - NOx sensor engine out B *)
	xTOF_EngOut_B_DiagErr(IN:= bOpM_NOxS_EngOut_B_DiagErr, 	PT := T#1s);		(* increase message time from 100ms to 1s for HMI *)

	xMsg2977.Enable			:= TRUE;
	xMsg2977.Set			:= xTOF_EngOut_B_DiagErr.Q;
	xMsg2977.Reset			:= TRUE;
	xMsg2977();
	MM2VIS.bMsg2977			:= xMsg2977.Q;

	(* B2980 Error during self-diagnosis - NOx sensor CAT out *)
	xTOF_CatOut_DiagErr(IN 	:= bOpM_NOxS_CatOut_DiagErr, 	PT := T#1s);		(* increase message time from 100ms to 1s for HMI *)

	xMsg2980.Enable			:= TRUE;
	xMsg2980.Set			:= xTOF_CatOut_DiagErr.Q;
	xMsg2980.Reset			:= TRUE;
	xMsg2980();
	MM2VIS.bMsg2980			:= xMsg2980.Q;

	(* B9077 SCR NH3 slip detection interrupted *)
	xMsg9077.Enable			:= TRUE;
	xMsg9077.Set			:= bOpM_9077;
	xMsg9077.Reset			:= TRUE;
	xMsg9077();
	MM2VIS.bMsg9077			:= xMsg9077.Q;

	(* B9079 SCR Urea dosing - dosing conditions reached *)
	xMsg9079.Enable			:= TRUE;
	xMsg9079.Set			:= bOpM_9079;
	xMsg9079.Reset			:= TRUE;
	xMsg9079();
	MM2VIS.bMsg9079			:= xMsg9079.Q;

	(* B9080 SCR Urea dosing - dosing conditions ended *)
	xMsg9080.Enable			:= TRUE;
	xMsg9080.Set			:= bOpM_9080;
	xMsg9080.Reset			:= TRUE;
	xMsg9080();
	MM2VIS.bMsg9080			:= xMsg9080.Q;

	(* B9081 SCR Urea dosing - requested *)
	xMsg9081.Enable			:= TRUE;
	xMsg9081.Set			:= bOpM_9081;
	xMsg9081.Reset			:= TRUE;
	xMsg9081();
	MM2VIS.bMsg9081			:= xMsg9081.Q;

	(* B9082 SCR Urea dosing - unrequested *)
	xMsg9082.Enable			:= TRUE;
	xMsg9082.Set			:= bOpM_9082;
	xMsg9082.Reset			:= TRUE;
	xMsg9082();
	MM2VIS.bMsg9082			:= xMsg9082.Q;

	
	(*--------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1	:= OUT_EM.tEM2AB.bGnlTrip1   OR IN_EM.tAB2EM.bGnlTrip1;
	bGnlTrip2	:= OUT_EM.tEM2AB.bGnlTrip2   OR IN_EM.tAB2EM.bGnlTrip2;
	bGnlTrip3	:= OUT_EM.tEM2AB.bGnlTrip3   OR IN_EM.tAB2EM.bGnlTrip3;
	bGnlWarning	:= OUT_EM.tEM2AB.bGnlWarning OR IN_EM.tAB2EM.bGnlWarning;

	bGnlTrip	:=	bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;

	(*******************************************************************************)
END_PROGRAM
