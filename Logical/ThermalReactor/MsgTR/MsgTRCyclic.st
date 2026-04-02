(*******************************************************************************
Msg_TR	 			 alarms generation MM_thermal reactor

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2020

Customized modifications: -
------------------------
 
History:
-------
V04.00.00.00	02-11-2011	denk/ganguly	new
V04.09.00.00	20-02-2020	Denk 			Thermalreactor failure added					
V04.10.00.00	24.11.2020	lettenb.		2356,2357,2358 added
V04.13.00.00	28.11.2023	Maran			warnings 9374, 9375, 9376, 9377, 9381 added
V04.14.00.00	27.11.2024	Maran			warnings 9501, 9502, 9396, 9397, 9398, 9503, 9500 for ThR2 added
											 disabled warnings 3498 and 3503 with ThR2
				27.11.2024	Maran			warnings 9504, 9505 for ThR2 added

Instructions for use:
--------------------
1) declare alarm with function block "Alm"
	declare buffert alarm bit MM2VIS.bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	MM2VIS.bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	


3)  expand INIT

3)	include datapoint into OPC configuration for vis

			
Outstandings: -
------------

(*******************************************************************************)


PROGRAM _CYCLIC

	(* reset general trip *)
	OUT_TR.tTR2AB.bGnlTrip1		:=	FALSE;
	OUT_TR.tTR2AB.bGnlTrip2		:=	FALSE;
	OUT_TR.tTR2AB.bGnlTrip3		:=	FALSE;
	OUT_TR.tTR2AB.bGnlWarning	:=	FALSE;
	OUT_TR.tTR2AB.bTriptype1	:=	FALSE;
	OUT_TR.tTR2AB.bTriptype2	:=	FALSE;
	OUT_TR.tTR2AB.bTriptype3	:=	FALSE;

	(* A2356 Earth fault auxiliaries power supply thermal reactor panel *)
	IN_TR.tTR_AuxPS_GndFault.Di := IN_TR.tTR_AuxPS_GndFault.Di OR NOT IN_TR.tTR_AuxPS_GndFault.GoodQual;

	xMsg2356.Enable		:=	TRUE;
	xMsg2356.Set		:=	NOT IN_TR.tTR_AuxPS_GndFault.Di;
	xMsg2356.PT			:=	T#0s;
	xMsg2356.Prio		:=	2;
	xMsg2356.RiskClass	:=	4;
	xMsg2356.Reset		:=	FALSE;
	xMsg2356();
	MM2VIS.bMsg2356		:=	xMsg2356.Q;

	(* A2357 Auxiliaries power supply circuit breaker thermal reactor panel tripped *)
	IN_TR.tTR_AuxPS_CB_Trip.Di := IN_TR.tTR_AuxPS_CB_Trip.Di OR NOT IN_TR.tTR_AuxPS_CB_Trip.GoodQual;

	xMsg2357.Enable		:=	TRUE;
	xMsg2357.Set		:=	NOT IN_TR.tTR_AuxPS_CB_Trip.Di;
	xMsg2357.PT			:=	T#0s;
	xMsg2357.Prio		:=	2;
	xMsg2357.RiskClass	:=	4;
	xMsg2357.Reset		:=	FALSE;
	xMsg2357();
	MM2VIS.bMsg2357		:=	xMsg2357.Q;

	(* A2358 Auxiliaries power supply circuit breaker thermal reactor panel opened *)
	IN_TR.tTR_AuxPS_CB_On.Di := IN_TR.tTR_AuxPS_CB_On.Di OR NOT IN_TR.tTR_AuxPS_CB_On.GoodQual;

	xMsg2358.Enable		:=	TRUE;
	xMsg2358.Set		:=	NOT IN_TR.tTR_AuxPS_CB_On.Di;
	xMsg2358.PT			:=	T#0s;
	xMsg2358.Prio		:=	2;
	xMsg2358.RiskClass	:=	4;
	xMsg2358.Reset		:=	FALSE;
	xMsg2358();
	MM2VIS.bMsg2358		:=	xMsg2358.Q;

	(* bMsg 3306 Alarm - Disturbance exhaust valve middle position *)
	xMsg3306.Enable		:=	Para.bThR_Active;
	xMsg3306.Set		:=	xTRA01.Q1;
	xMsg3306.PT			:=	T#0s;
	xMsg3306.Prio		:=	2;
	xMsg3306.RiskClass	:=	4;
	xMsg3306.Reset		:=	FALSE;
	xMsg3306();
	MM2VIS.bMsg3306		:=	xMsg3306.Q;
			
	(* bMsg 3307 Alarm - Safety loop thermal reactor, active only with RIO *)
	xMsg3307.Enable		:=	Para.bThR_Active;
	xMsg3307.Set		:=	xTRA02.Q1;
	xMsg3307.PT			:=	T#0s;
	xMsg3307.Prio		:=	2;
	xMsg3307.RiskClass	:=	4;
	xMsg3307.Reset		:=	FALSE;
	xMsg3307();
	MM2VIS.bMsg3307		:=	xMsg3307.Q;
			
	(* bMsg 3498 Warning - Sensor failure *)
	xMsg3498.Enable		:=	Para.bThR_Active AND NOT Para.bThR2_Ena;
	xMsg3498.Set		:=	xTRW01.Q1;
	xMsg3498.PT			:=	T#0s;
	xMsg3498.Prio		:=	4;
	xMsg3498.RiskClass	:=	4;
	xMsg3498.Reset		:=	FALSE;
	xMsg3498();
	MM2VIS.bMsg3498		:=	xMsg3498.Q;

	(* bMsg 9501 Warning - Measuring signal failure thermal reactor temperature right side - ThR2 *)
	xMsg9501.Enable		:=	Para.bThR_Active AND Para.bThR2_Ena AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9501.Set		:=	NOT IN_TR.tThR2_T_UnitOk_RightCh.Di OR NOT IN_TR.tT_ThR2_RightChamber.GoodQual;
	xMsg9501.PT			:=	T#0s;
	xMsg9501.Prio		:=	4;
	xMsg9501.RiskClass	:=	4;
	xMsg9501.Reset		:=	FALSE;
	xMsg9501();
	MM2VIS.bMsg9501		:=	xMsg9501.Q;
	
	(* bMsg 9502 Warning - Measuring signal failure thermal reactor temperature left side - ThR2 *)
	xMsg9502.Enable		:=	Para.bThR_Active AND Para.bThR2_Ena AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9502.Set		:=	NOT IN_TR.tThR2_T_UnitOk_LeftCh.Di OR NOT IN_TR.tT_ThR2_LeftChamber.GoodQual;
	xMsg9502.PT			:=	T#0s;
	xMsg9502.Prio		:=	4;
	xMsg9502.RiskClass	:=	4;
	xMsg9502.Reset		:=	FALSE;
	xMsg9502();
	MM2VIS.bMsg9502		:=	xMsg9502.Q;
	
	(* bMsg 3499 Warning - Disturbance in pressurized air supply *)
	xMsg3499.Enable		:=	Para.bThR_Active;
	xMsg3499.Set		:=	xTRW02.Q1;
	xMsg3499.PT			:=	T#0s;
	xMsg3499.Prio		:=	4;
	xMsg3499.RiskClass	:=	4;
	xMsg3499.Reset		:=	FALSE;
	xMsg3499();
	MM2VIS.bMsg3499		:=	xMsg3499.Q;
	
	(* bMsg 3500 Warning - Disturbance in exhaust valve end position *)
	xMsg3500.Enable		:=	Para.bThR_Active;
	xMsg3500.Set		:=	xTRW03.Q1;
	xMsg3500.PT			:=	T#0s;
	xMsg3500.Prio		:=	4;
	xMsg3500.RiskClass	:=	4;
	xMsg3500.Reset		:=	FALSE;
	xMsg3500();
	MM2VIS.bMsg3500		:=	xMsg3500.Q;
			
	(* bMsg 3501 Warning - Heating time exceeded *)
	xMsg3501.Enable		:=	Para.bThR_Active;
	xMsg3501.Set		:=	xTRW04.Q1;
	xMsg3501.PT			:=	T#0s;
	xMsg3501.Prio		:=	4;
	xMsg3501.RiskClass	:=	4;
	xMsg3501.Reset		:=	FALSE;
	xMsg3501();
	MM2VIS.bMsg3501		:=	xMsg3501.Q;
			
			
	(* bMsg 3502 Warning - Control panel temperature too high *)
	xMsg3502.Enable		:=	Para.bThR_Active;
	xMsg3502.Set		:=	xTRW05.Q1;
	xMsg3502.PT			:=	T#0s;
	xMsg3502.Prio		:=	4;
	xMsg3502.RiskClass	:=	4;
	xMsg3502.Reset		:=	FALSE;
	xMsg3502();
	MM2VIS.bMsg3502		:=	xMsg3502.Q;
			
			
	(* bMsg 3503 Warning - Temperature difference between TK1/TK2 over allowed maximum *)
	xMsg3503.Enable		:=	Para.bThR_Active AND NOT Para.bThR2_Ena;
	xMsg3503.Set		:=	xTRW06.Q1;
	xMsg3503.PT			:=	T#0s;
	xMsg3503.Prio		:=	4;
	xMsg3503.RiskClass	:=	4;
	xMsg3503.Reset		:=	FALSE;
	xMsg3503();
	MM2VIS.bMsg3503		:=	xMsg3503.Q;
			

	(* bMsg 3504 Warning - Reactor temperature TK1/TK2 maximum *)
	xMsg3504.Enable		:=	Para.bThR_Active;
	xMsg3504.Set		:=	xTRW07.Q1;
	xMsg3504.PT			:=	T#0s;
	xMsg3504.Prio		:=	4;
	xMsg3504.RiskClass	:=	4;
	xMsg3504.Reset		:=	FALSE;
	xMsg3504();
	MM2VIS.bMsg3504		:=	xMsg3504.Q;
			
			
	(* bMsg 3505 Warning - Reactor temperature minimum *)
	xMsg3505.Enable		:=	Para.bThR_Active;
	xMsg3505.Set		:=	xTRW08.Q1;
	xMsg3505.PT			:=	T#0s;
	xMsg3505.Prio		:=	4;
	xMsg3505.RiskClass	:=	4;
	xMsg3505.Reset		:=	FALSE;
	xMsg3505();
	MM2VIS.bMsg3505		:=	xMsg3505.Q;
		
	(* bMsg 9374 Warning - Measuring signal failure auxiliary gas control valve position *)
	xMsg9374.Enable		:=	Para.bThR_Active AND Para.bThR_auxGasMonitor AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9374.Set		:=	NOT IN_TR.tPos_ThR_AuxGasCV_Act.GoodQual;
	xMsg9374.PT			:=	T#0s;
	xMsg9374.Prio		:=	4;
	xMsg9374.RiskClass	:=	4;
	xMsg9374.Reset		:=	FALSE;
	xMsg9374();
	MM2VIS.bMsg9374		:=	xMsg9374.Q;

	(* bMsg 9375 Warning - Measuring signal failure auxiliary gas pressure before control valve *)
	xMsg9375.Enable		:=	Para.bThR_Active AND Para.bThR_auxGasMonitor AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9375.Set		:=	NOT IN_TR.tPr_ThR_AuxGasBeforeCV.GoodQual;
	xMsg9375.PT			:=	T#0s;
	xMsg9375.Prio		:=	4;
	xMsg9375.RiskClass	:=	4;
	xMsg9375.Reset		:=	FALSE;
	xMsg9375();
	MM2VIS.bMsg9375		:=	xMsg9375.Q;

	(* bMsg 9376 Warning - Measuring signal failure auxiliary gas pressure after control valve *)
	xMsg9376.Enable		:=	Para.bThR_Active AND Para.bThR_auxGasMonitor AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9376.Set		:=	NOT IN_TR.tPr_ThR_AuxGasAfterCV.GoodQual;
	xMsg9376.PT			:=	T#0s;
	xMsg9376.Prio		:=	4;
	xMsg9376.RiskClass	:=	4;
	xMsg9376.Reset		:=	FALSE;
	xMsg9376();
	MM2VIS.bMsg9376		:=	xMsg9376.Q;

	(* bMsg 9377 Warning - Thermal reactor auxiliary gas compressor fault, low pressure before control valve *)
	xMsg9377.Enable		:=	Para.bThR_Active AND Para.bThR_auxGasMonitor;
	xMsg9377.Set		:=	bThr_AuxGasCompressor_Fault;
	xMsg9377.PT			:=	T#0s;
	xMsg9377.Prio		:=	4;
	xMsg9377.RiskClass	:=	4;
	xMsg9377.Reset		:=	FALSE;
	xMsg9377();
	MM2VIS.bMsg9377		:=	xMsg9377.Q;

	(* bMsg 9381 Warning - Thermal reactor implausible auxiliary gas pressure before/after control valve *)
	xMsg9381.Enable		:=	Para.bThR_Active AND Para.bThR_auxGasMonitor;
	xMsg9381.Set		:=	bThr_AuxGasPr_PcheckFail;
	xMsg9381.PT			:=	T#0s;
	xMsg9381.Prio		:=	4;
	xMsg9381.RiskClass	:=	4;
	xMsg9381.Reset		:=	FALSE;
	xMsg9381();
	MM2VIS.bMsg9381		:=	xMsg9381.Q;

	(* bMsg 9396 Warning - Thermal reactor: differential pressure maximum - ThR2 *)
	xMsg9396.Enable		:=	Para.bThR_Active AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9396.Set		:=	bThR2_DPr_Hi;
	xMsg9396.PT			:=	T#0s;
	xMsg9396.Prio		:=	4;
	xMsg9396.RiskClass	:=	4;
	xMsg9396.Reset		:=	FALSE;
	xMsg9396();
	MM2VIS.bMsg9396		:=	xMsg9396.Q;

	(* bMsg 9397 Warning - Measuring signal failure thermal reactor inlet pressure - ThR2 *)
	xMsg9397.Enable		:=	Para.bThR_Active AND Para.bThR2_Ena AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9397.Set		:=	NOT IN_TR.tPr_ThR2_Inlet.GoodQual;
	xMsg9397.PT			:=	T#0s;
	xMsg9397.Prio		:=	4;
	xMsg9397.RiskClass	:=	4;
	xMsg9397.Reset		:=	FALSE;
	xMsg9397();
	MM2VIS.bMsg9397		:=	xMsg9397.Q;
	
	(* bMsg 9398 Warning - Measuring signal failure thermal reactor outlet pressure - ThR2 *)
	xMsg9398.Enable		:=	Para.bThR_Active AND Para.bThR2_Ena AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9398.Set		:=	NOT IN_TR.tPr_ThR2_Outlet.GoodQual;
	xMsg9398.PT			:=	T#0s;
	xMsg9398.Prio		:=	4;
	xMsg9398.RiskClass	:=	4;
	xMsg9398.Reset		:=	FALSE;
	xMsg9398();
	MM2VIS.bMsg9398		:=	xMsg9398.Q;

	(* bMsg 9503 Warning - Measuring signal failure thermal reactor downstream temperature - ThR2 *)
	xMsg9503.Enable		:=	Para.bThR_Active AND Para.bThR2_Ena AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9503.Set		:=	NOT IN_TR.tThR2_T_UnitOk_Downstream.Di OR NOT IN_TR.tT_ThR2_Downstream.GoodQual;
	xMsg9503.PT			:=	T#0s;
	xMsg9503.Prio		:=	4;
	xMsg9503.RiskClass	:=	4;
	xMsg9503.Reset		:=	FALSE;
	xMsg9503();
	MM2VIS.bMsg9503		:=	xMsg9503.Q;
	
	(* bMsg 9500 Warning - Measuring signal failure electrical heating monitoring temperature sensors - ThR2 *)
	xMsg9500.Enable		:=	Para.bThR_Active AND Para.bThR2_Ena AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9500.Set		:=	NOT IN_TR.tT_ThR2_EH_group1.GoodQual OR NOT IN_TR.tT_ThR2_EH_group2.GoodQual OR NOT IN_TR.tT_ThR2_EH_group3.GoodQual OR NOT IN_TR.tT_ThR2_EH_group4.GoodQual OR NOT IN_TR.tT_ThR2_EH_group5.GoodQual;
	xMsg9500.PT			:=	T#0s;
	xMsg9500.Prio		:=	4;
	xMsg9500.RiskClass	:=	4;
	xMsg9500.Reset		:=	FALSE;
	xMsg9500();
	MM2VIS.bMsg9500		:=	xMsg9500.Q;
	
	(* bMsg 9504 Warning - Thermal reactor auxiliary gas injection solenoid valve fault - ThR2 *)
	xMsg9504.Enable		:=	Para.bThR_Active AND Para.bThR2_Ena;
	xMsg9504.Set		:=	bThr2_AuxGasValve_fault;
	xMsg9504.PT			:=	T#0s;
	xMsg9504.Prio		:=	4;
	xMsg9504.RiskClass	:=	4;
	xMsg9504.Reset		:=	FALSE;
	xMsg9504();
	MM2VIS.bMsg9504		:=	xMsg9504.Q;
	
	(* bMsg 9505 Warning - Exhaust aftertreatment: Thermal reactor outlet/SCR inlet high differential pressure - ThR2 *)
	xMsg9505.Enable		:=	Para.bThR_Active AND Para.bThR2_Ena AND (Para.bSCR_Active OR Para.bSCR_Cust_Active) AND IN_TR.tPB2MM.bParaSetupOk;
	xMsg9505.Set		:=	bThR2out_SCRin_DPr_Hi;
	xMsg9505.PT			:=	T#0s;
	xMsg9505.Prio		:=	4;
	xMsg9505.RiskClass	:=	4;
	xMsg9505.Reset		:=	FALSE;
	xMsg9505();
	MM2VIS.bMsg9505		:=	xMsg9505.Q;
	
	(* bMsg 9309  Warning - Thermo reactor failure / not in operation *)
	xMsg9309.Enable		:=	TRUE;
	xMsg9309.Set		:=	bThR_Failure;
	xMsg9309.PT			:=	T#0s;
	xMsg9309.Prio		:=	4;
	xMsg9309.RiskClass	:=	4;
	xMsg9309.Reset		:=	FALSE;
	xMsg9309();
	MM2VIS.bMsg9309		:=	xMsg9309.Q;
	
	
	(* B9042 Thermal reactor: operating switch OFF *)
	xMsg9042.Enable		:=	TRUE;
	xMsg9042.Set		:=	OUT_TR.bThR_Active AND NOT IN_TR.tThR_Swth_On.Di;
	xMsg9042.Reset		:=	TRUE;
	xMsg9042();
	MM2VIS.bMsg9042		:=	xMsg9042.Q;
	
	
	(* B9043 Thermal reactor: operating switch ON *)
	xMsg9043.Enable		:=	TRUE;
	xMsg9043.Set		:=	OUT_TR.bThR_Active AND IN_TR.tThR_Swth_On.Di;
	xMsg9043.Reset		:=	TRUE;
	xMsg9043();
	MM2VIS.bMsg9043		:=	xMsg9043.Q;
	
	
	(*--------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1	:= OUT_TR.tTR2AB.bGnlTrip1   OR IN_TR.tAB2TR.bGnlTrip1;
	bGnlTrip2	:= OUT_TR.tTR2AB.bGnlTrip2   OR IN_TR.tAB2TR.bGnlTrip2;
	bGnlTrip3	:= OUT_TR.tTR2AB.bGnlTrip3   OR IN_TR.tAB2TR.bGnlTrip3;
	bGnlWarning	:= OUT_TR.tTR2AB.bGnlWarning OR IN_TR.tAB2TR.bGnlWarning;
	
	bGnlTrip	:=	bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
	(*******************************************************************************)
END_PROGRAM
