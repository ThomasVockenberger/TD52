(*******************************************************************************
AGGR: thermal reactor  (init)

This code is confidential AND proprietary TO the INNIO Company.
It may NOT be used in any form, OR reproduced in any manner, without the express
written permission OF the INNIO Company.
Copyright, INNIO Company, 2022

- initialize values used in main thermal reactor task

Customized modifications: -
------------------------
 
History:
-------
V4.12.0 12-05-2022	Maran	Initialization of values for fixed temperature thresholds
V4.13.0 27-03-2023	Maran	included operating temperature init, updated init values for max. temp. difference for W3503
V4.14.0 27-11-2024	Maran	added var. initializations for el. heating system and auxiliary gas solenoid valve for ThR2

Instructions FOR use:
--------------------

Outstandings:
------------
*******************************************************************************)

PROGRAM _INIT

// Th.Reactor maximum temperature warning - hysteresis and delay
TKx_y_HI_Hy			:=  20.0;  (* 0,1°C *)
ti_TKx_y_HI_PTHI	:= T#2s;

// Th.Reactor maximum temperature difference between TK1/TK2 warning - threshold, hysteresis and delay
rT_ThR_ChamberDiff		:=  50.0;  (* 0,1°C; Standard: 50,0 °C *)
rT_ThR_ChamberDiffHy :=  10.0;  (* 0,1°C *)
ti_ThR_ChamberDiff		:= T#60s;
rT_ThR_ChDiff_switch :=  20.0;
rT_ThR_ChDiff_switchHy :=  1.0;

// Th.Reactor electrical heating system - hysteresis for parameter limits
rT_ThR_EH_Lim75Hy		:= 20.0;        (* 0,1°C *)
rT_ThR_EH_Lim50Hy		:= 20.0;        (* 0,1°C *)
rT_ThR_EH_Lim25Hy		:= 20.0;        (* 0,1°C *)
rT_ThR_EH_Lim00Hy		:= 20.0;        (* 0,1°C *)
rT_ThR2_EH_PwLevHy		:= 20.0;

// Th.Reactor electrical heating system ThR2 - element group temperature monitoring threshold and hysteresis
rT_ThR2_EH_thres_GroupHi		:= 800;
rT_ThR2_EH_thres_GroupHi_Hy		:= 20;
tiTON_ThR2_EH_gr_T_GoodQual		:= T#30s;	// timer for monitoring temperature good quality signal

// Th.Reactor electrical heating system ThR2 - ramp rate for heating power increase/decrease
xRamp_ThR2_EH_PwLev.enable 		:=	TRUE;
xRamp_ThR2_EH_PwLev.Rise		:=	0.0333;			// 0.033 "In"/s
xRamp_ThR2_EH_PwLev.Sink		:=	100.0;			// 100 "In"/s, immediate decrease
xRamp_ThR2_EH_PwLev.TC_Time		:=	100;			// cycle Time 100ms

// Th.Reactor operating temperature - margin from setpoint and hysteresis
rT_ThR_OperTemp_rel		:=  -5.0;
rT_ThR_OperTempHy		:=  10.0;

// Th.Reactor auxiliary gas stop due to sufficient temperature - minimum margin above setpoint and timers
rT_Thr_AuxGasStopT_rel			:= 3.0;
tiTON_Thr_AuxGasStopT_set		:= T#12m;
tiTON_Thr_AuxGasStopT_reset		:= T#10s;
tiTP_NFRG_GASREG				:= T#180s;
rPos_ThR_GasCV_AuxGasStop_max	:= 0.03;

// Th.Reactor auxiliary gas solenoid valve ThR2 - timer for closing valve before flap switching
tiThR2_AuxGasValve_Block	:= T#5s;

END_PROGRAM
