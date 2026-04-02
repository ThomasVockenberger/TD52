(*******************************************************************************
AGGR: IN CBM

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
History:
-------
V4.06.01 	30-07-2018 	502423184		header added, added rCA_MFBxx
			13-11-2018	502423184		added new times stamp to replace clock_ms()
V4.12.00	08-09-2022	Andre			Select the engine speed from the ICxx module also if SEMIC is active


Instructions FOR use:
--------------------
- use in a 10ms cycle time

Outstandings:
------------
-

*******************************************************************************)
PROGRAM _INIT
(** A: GE Prop info *)
	strGEProp			:=	'';
	strcat(ADR(strGEProp),ADR('The information contained in this document and any documents attached hereto is privileged or confidential.$n'));
	strcat(ADR(strGEProp),ADR('It is the property of INNIO Company and shall not be used, disclosed to others,$n'));
	strcat(ADR(strGEProp),ADR('or reproduced without the express written consent of INNIO Company.$n'));
	strLine				:=	'$n';
(** B: HMI Speed *)
	tiHMI_Delay			:=	T#10m; 		//Depends on HMI Version

END_PROGRAM

PROGRAM _CYCLIC

(** 0: test development *)
	IF bTEST THEN
		IN_CB.iSt_OpMode	:=	50 * 65536;	//NetP
		rN_Eng				:=	1000;		//Speed
		bGnlTrip			:=	FALSE;
		bGnlTrip1			:=	FALSE;
		bGnlTrip2			:=	FALSE;
		bGnlTrip3			:=	FALSE;
		TON_PBC_Man_Trig.IN	:=	NOT VIS2MM.ECB.bTrig AND NOT bPBC_Write AND NOT xOpMode.Stop;
		TON_PBC_Man_Trig.PT	:=	T#15m;
		TON_PBC_Man_Trig();
		IF EDGEPOS(TON_PBC_Man_Trig.Q) THEN
			VIS2MM.ECB.bTrig	:= bTest2;
		END_IF
	END_IF

(** 1: get engine type *)
	xEngType.Motortype := Para.iEng_Motortype;
	xEngType();

(** 2: get operation mode *)
	xOpMode.in			:=	IN_CB.iSt_OpMode;
	xOpMode();

(** 3: Engine speed measured 1/min *)
	IF Para.b_IgnIC_900Active OR Para.bSEMIC_Active THEN		
		rN_Eng := IN_CB.rN_IgnIC_Act;
	ELSIF Para.bSA_Ign_Active THEN	
		rN_Eng := IN_CB.rN_IgnSAFI_Act;
	END_IF;

(** 4: set engine cycle bit *) //bit is TRUE when engine is in a new cycle
	rCnt_N				:=	rCnt_N + rN_Eng / 60 / 100; (* convert rpm to rounds per 10ms *)
	IF rCnt_N >= 2.0 THEN	(* 4 stroke engine *)
		bNewEngCycle	:=	TRUE;
		rCnt_N			:=	rCnt_N - 2.0;
		bPBC_NewData	:=	TRUE;	(* trigger new data for pbc buffering *)
	ELSE
		bNewEngCycle	:=	FALSE;
	END_IF

(** 5: get time *)
	DTGetTime_RPS(enable:=1);	
	DT_TO_DTStructure(DTGetTime_RPS.DT1, ADR(tRealTime));
	tTimeStamp.Year		:=	UINT_TO_USINT(tRealTime.year MOD 100);
	tTimeStamp.Month	:=	tRealTime.month;
	tTimeStamp.Day		:=	tRealTime.day;
	tTimeStamp.Hour		:=	tRealTime.hour;
	tTimeStamp.Minute	:=	tRealTime.minute;
	IF tTimeStamp.Second <> tRealTime.second THEN
		iMilliSec	:=	0;
	ELSE
		iMilliSec	:=	MIN(iMilliSec + 10,990); 
	END_IF
	tTimeStamp.Second	:=	tRealTime.second;

	iSec	:=	USINT_TO_UDINT(tRealTime.second);
	iMin	:=	USINT_TO_UDINT(tRealTime.minute);
	iHour	:=	USINT_TO_UDINT(tRealTime.hour);

	iSec	:=	iSec MOD 60;
	iMin	:=	iMin MOD 60;
	iHour	:=	iHour MOD 24;

	tiStamp	:=	UDINT_TO_TIME(
					iHour	* 60 * 60 * 1000 +
					iMin	* 60 * 1000 +
					iSec	* 1000 +
					iMilliSec
				);
	IF tiStamp = T#0ms THEN
		tiStamp	:=	T#24h;
	END_IF


(** 6: convert data from SAFI *)
	FOR iIdx_Cyl:= 1 TO xEngType.NumberOfCylinder/2 DO
		IF Para.bSA_PBC_Active THEN
			(* speed measuring with DMR function*)
			IF IN_CB.tMS_PBC0[iIdx_Cyl].data1 <> 16#7FFF THEN rN_SAFI[iIdx_Cyl * 2 - 1]		:= UINT_TO_REAL(IN_CB.tMS_PBC0[iIdx_Cyl].data1)/10; END_IF	
			IF IN_CB.tMS_PBC1[iIdx_Cyl].data1 <> 16#7FFF THEN rN_SAFI[iIdx_Cyl * 2]			:= UINT_TO_REAL(IN_CB.tMS_PBC1[iIdx_Cyl].data1)/10; END_IF
			(* PBC14 and PBC15 *)		(* data2 *)
			rCA_MFB10[iIdx_Cyl * 2 - 1]		:= INT_TO_REAL(UINT_TO_INT(IN_CB.tMS_PBC14[iIdx_Cyl].data2))/10;		(*convert from 0.1CA to 1CA*)
			rCA_MFB10[iIdx_Cyl * 2]			:= INT_TO_REAL(UINT_TO_INT(IN_CB.tMS_PBC15[iIdx_Cyl].data2))/10;
			(* PBC14 and PBC15 *)		(* data3 *)
			rCA_MFB90[iIdx_Cyl * 2 - 1]		:= INT_TO_REAL(UINT_TO_INT(IN_CB.tMS_PBC14[iIdx_Cyl].data3))/10;		(*convert from 0.1CA to 1CA*)
			rCA_MFB90[iIdx_Cyl * 2]			:= INT_TO_REAL(UINT_TO_INT(IN_CB.tMS_PBC15[iIdx_Cyl].data3))/10;
		ELSE
			(* speed measuring with KLS function*)
			IF IN_CB.KLS_md00[iIdx_Cyl].data1 <> 16#7FFF THEN rN_SAFI[iIdx_Cyl * 2 - 1]	 	:= UINT_TO_REAL(IN_CB.KLS_md00[iIdx_Cyl].data1)/10; END_IF
			IF IN_CB.KLS_md01[iIdx_Cyl].data1 <> 16#7FFF THEN rN_SAFI[iIdx_Cyl * 2]			:= UINT_TO_REAL(IN_CB.KLS_md01[iIdx_Cyl].data1)/10; END_IF
		END_IF
	END_FOR

END_PROGRAM
