(*******************************************************************************
AGGR: read and write IO channels	(cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2025

- read out data module with IO configuration
- call fubs to copy IO data from IN and to OUT structures

Customized modifications: -
------------------------
 
History:
-------
V3.99	05-07-2012	Weitzer, generated for modular software	
V3.99.1	20-11-2013  zengerer new customized controller 21-28
V4.00	14-02-2014	Weitzer, change version number
V4.01	22-07-2014	Weitzer, change version number
V4.01.1 10-10-2014	Weitzer, set HW OK bit TRUE --> write outputs in case of HW problems
V4.03	14-01-2015	Weitzer, new IOs added for J920
V4.03.1	04-03-2015  zengerer outputs scaling on customized controller AO
V4.03.2 18-01-2016	Weitzer, correction of rOQS_Conduct & rOQS_Dielect ScalMin/Max
V4.03.3 03-03-2016	Weitzer, set F to 0 Hz when no voltage and engine speed > 600
V4.04.0 20-06-2016	Weitzer, add CustAnaOut[17..50]
		06-10-2016	Perktold,added xPLim_DEIE
		24-10-2016	Weitzer, set F to 0 Hz when no voltage and engine speed < 500
V4.05.0	05-04-2017  lettenb. faststart
V4.05.0 16-05-2017  Denk	 tPr_PCGT_a_Filt.Ai := tPr_PCGT.Ai; switching
		17-11-2017	Arnold	 added angle diff for fast synchronization
		04-12.2017	Messner	 old CAT: T_EGbCat, T_EGaCat scalling added
							 new OXIcat: xPr_OXIcat_In, xPr_OXIcat_Out, xPr_OXIcat_In_Fast added
V4.05.1 14.02.2018	Weitzer, EOP_BWS2 added
V4.05.2 26.03.2018	Farre, 	 Signals removed (PF_CosPCtr_PF1_Ena, PF_CosPCtr_PF2_Ena, PF_CosPCtr_PF3_Ena, PF_CosPCtr_PF4_Ena, PF_CosPCtr_PF5_Ena)
V4.07.0	12.07.2018	Hohensinner,	Added G2 Signals
		09.08.2018	Schmid	 2nd low temperature charge cooling circuit added
		20.09.2018	Schmid	 unused IOs deleted
		17.12.2018	Schmid	 IOs FOR hydraulic ECW pre-heating FOR type 3+4 added
		08.01.2019	Schmid	 IOs for redundant pump control added
		10.01.2019	Schmid	 IOs for boiler failure and seismic alarm added
		14.01.2019	Schmid	 Pr_EG_Deflag_Fast (deflagration detection) fully replaces Pr_OXIcat_In_Fast
		13.03.2019	Hohensinner, 	Added custom filter time constant for LSL_In signal
V4.07.2	15.05.2019	Schmid	 coding guidelines: changed Para.rTi_Filt_LSL_In (datatype REAL) to Para.tiFilt_LSL_In (datatype TIME)
V4.09.0 27.06.2019	Denk	 Added parameter scaling for IO's: T_GT_NG, Pr_GT_NG, Vol_GT_NG
V4.09.1	16.04.2020	Schmid	 bugfix: spare analog input (CustAnaIn) scaling corrected to allow falling slope
V4.10.0	26.05.2020	Schmid	 new IOs XT4 v4.10
V4.10.1 10.05.2021	Weitzer	 System cyclic time viaolation monitoring added	
V4.10.2	06.12.2021 	Zengerer ArEventLogWrite_0.  //Bugfix- disable line for PPC900
V4.11.0	16.08.2021	Weitzer	 add UR20 IO systemV4.10.2	06.12.2021 	Zengerer ArEventLogWrite_0.  //Bugfix- disable line for PPC900 
V4.11.0	17.12.2021 	Schmid	 IOs for control battery check added
		02-02-2022	Zengerer add CustAnaOut[51..60]
V4.12.0	18.11.2022 	Zengerer add L_FreshOilTank, L_WasteOilTank, L_DayOilTank
		22.01.2023 	Zuschnig Added scaling via parameter for H2 signal
		25.01.2025	shifted some parts to new tasks in slower cyclics
V4.13.0	05.03.2024	Bacci	 Added hardware bypass digital twin - T3 adaptive cranking time
V4.14.0	26.02.2025	Tinello	 added SafetyPLC
V4.25.0 26.11.2025	Bacci	 Safety Function - Insufficient Ventilation (2024-202): ERV digital feedback added
		17.12.2025	Tinello	 added SafetyPLC Phase II 
						
Instructions for use:
--------------------
- IO channels are configured in the IOcgf.dat data module

Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC

	(* Set F to 0 Hz when engine; calculate angle *)
	FOR ucCount := 1 TO 2 DO
		IF tU_L1N[ucCount].Ai = 0 AND tU_L2N[ucCount].Ai = 0 AND tU_L3N[ucCount].Ai = 0 AND IN_HA.rN_EngAct < 500 THEN
			F_MMD[ucCount] := 0;
		END_IF;			
		IF ssSynchAngleDeviation[ucCount] > 1800 THEN 	(* angle deviation synchronization  +180° - -180° *)		
			OUT_HA.rAng_MMD_Diff[ucCount] 	:= INT_TO_REAL(ssSynchAngleDeviation[ucCount]-3600)/10; 
		ELSE
			OUT_HA.rAng_MMD_Diff[ucCount] 	:= INT_TO_REAL(ssSynchAngleDeviation[ucCount])/10; 			
		END_IF;
	END_FOR;
	
	//	HwOK := bAllModulesOK;
	HwOK := TRUE;
	bAllCfgDataOK := ParOK;


	(* actual power output *)
	tP_Act_AO.Ao := tP_Act[1].Ai;
	
	
	(* Gas pressure pre chamber gas train after filter, variable switch *)
	tPr_PCGT_a_Filt.Ai 			:= tPr_PCGT.Ai;
	tPr_PCGT_a_Filt.Unfilt 		:= tPr_PCGT.Unfilt;
	tPr_PCGT_a_Filt.GoodQual 	:= tPr_PCGT.GoodQual;
	Pr_PCGT_a_Filt;

	(* AI und DI for Gricode *)
	tHA2CU.tSet_LFSMO_DB_COn		:= tSet_LFSMO_DB_COn;
	tHA2CU.tSet_LFSMO_DB_COf		:= tSet_LFSMO_DB_COf;
	tHA2GR.tF_LFSMO_DB				:= tF_LFSMO_DB;
	tHA2CU.tSet_LFSMU_DB_COn		:= tSet_LFSMU_DB_COn;
	tHA2CU.tSet_LFSMU_DB_COf		:= tSet_LFSMU_DB_COf;
	tHA2GR.tF_LFSMU_DB				:= tF_LFSMU_DB;
	tHA2CU.tSet_LFSMO_Droop_COn		:= tSet_LFSMO_Droop_COn;
	tHA2CU.tSet_LFSMO_Droop_COf		:= tSet_LFSMO_Droop_COf;
	tHA2GR.tF_LFSMO_Droop			:= tF_LFSMO_Droop;
	tHA2CU.tSet_LFSMU_Droop_COn		:= tSet_LFSMU_Droop_COn;
	tHA2CU.tSet_LFSMU_Droop_COf		:= tSet_LFSMU_Droop_COf;
	tHA2GR.tF_LFSMU_Droop			:= tF_LFSMU_Droop;
	tHA2CU.tSet_FSMU_Droop_COn		:= tSet_FSMU_Droop_COn;
	tHA2CU.tSet_FSMU_Droop_COf		:= tSet_FSMU_Droop_COf;
	tHA2GR.tF_FSMU_Droop			:= tF_FSMU_Droop;
	tHA2CU.tSet_FSMO_Droop_COn		:=	tSet_FSMO_Droop_COn;
	tHA2CU.tSet_FSMO_Droop_COf		:= tSet_FSMO_Droop_COf;
	tHA2GR.tF_FSMO_Droop			:= tF_FSMO_Droop;
	tHA2CU.tSet_FSMU_DB_COn			:= tSet_FSMU_DB_COn;	
	tHA2CU.tSet_FSMU_DB_COf			:= tSet_FSMU_DB_COf;
	tHA2GR.tF_FSMU_DB				:= tF_FSMU_DB;
	tHA2CU.tSet_FSMO_DB_COn			:= tSet_FSMO_DB_COn;
	tHA2CU.tSet_FSMO_DB_COf			:= tSet_FSMO_DB_COf;
	tHA2GR.tF_FSMO_DB				:= tF_FSMO_DB;
	tHA2CU.tSet_FSM_RMC_Up_COn		:=	tSet_FSM_RMC_Up_COn;
	tHA2CU.tSet_FSM_RMC_Up_COf		:= tSet_FSM_RMC_Up_COf;
	tHA2GR.tP_FSM_RMC_Up			:= tP_FSM_RMC_Up;
	tHA2CU.tSet_FSM_RMC_Down_COn	:=	tSet_FSM_RMC_Down_COn;
	tHA2CU.tSet_FSM_RMC_Down_COf	:= tSet_FSM_RMC_Down_COf;
	tHA2GR.tP_FSM_RMC_Down			:= tP_FSM_RMC_Down;
	tHA2CU.tSet_U_Droop_COn			:= tSet_U_Droop_COn;
	tHA2CU.tSet_U_Droop_COf			:= tSet_U_Droop_COf;
	tHA2GR.tU_Droop					:= tU_Droop;
	tHA2CU.tSet_FSM_Rmp_COn			:=	tSet_FSM_Rmp_COn;
	tHA2CU.tSet_FSM_Rmp_COf			:= tSet_FSM_Rmp_COf;
	tHA2GR.tFSM_Rmp_Up				:= tFSM_Rmp_Up;
	tHA2GR.tFSM_Rmp_Down			:= tFSM_Rmp_Down;
	tHA2CU.tSet_F_Ref_FSM_COn		:= tSet_F_Ref_FSM_COn;	
	tHA2CU.tSet_F_Ref_FSM_COf		:= tSet_F_Ref_FSM_COf;
	tHA2GR.tF_Ref_FSM				:= tF_Ref_FSM; 
	tHA2GR.tJunctionBox_GnlAlm		:= tJunctionBox_GnlAlm;
	tHA2GR.bCheck_HA2GR				:= TRUE;
	tHA2CU.bCheck_HA2CU				:= TRUE;


	(* Opstate 4.7 DO addons *)
	xOpMode(in:= IN_HA.iSt_OpMode);
	tOpMode_NetP.Do		:=	xOpMode.NetP;
	tOpMode_Island.Do	:=	xOpMode.Island;
	tOpMode_Idle.Do		:=	xOpMode.Idle;


		
	L_FreshOilTank;			tL_FreshOilTank;	xL_FreshOilTank;	(*V4.12 Spec 2022-112*)			
	L_WasteOilTank;			tL_WasteOilTank;	xL_WasteOilTank;	(*V4.12 Spec 2022-112*)	
	L_DayOilTank;			tL_DayOilTank;		xL_DayOilTank;		(*V4.12 Spec 2022-112*)	
			
	(* V4.12 Spec 2022-112 END *)
	

	(*new with V4.14 SafetyPlc *)
	tGT1_GV1_Open	:= tGV1_Open;									(* SAFETY PLC *)
	tGT1_GV2_Open	:= tGV1_Open;									(* SAFETY PLC *)
	tGT2_GV1_Open	:= tGV2_Open;									(* SAFETY PLC *)
	tGT2_GV2_Open	:= tGV2_Open;									(* SAFETY PLC *)
	tGT3_GV1_Open	:= tGV3_Open;									(* SAFETY PLC *)
	tGT3_GV2_Open	:= tGV3_Open;									(* SAFETY PLC *)
	tGT4_GV1_Open	:= tGV4_Open;									(* SAFETY PLC *)
	tGT4_GV2_Open	:= tGV4_Open;									(* SAFETY PLC *)

	(*new with V4.25 SafetyPlc *)
	tDCGA_GV1_Open	:= tDCGA_GV_Open;								(* SAFETY PLC *)
	tDCGA_GV2_Open	:= tDCGA_GV_Open;								(* SAFETY PLC *)


(**************************************************)

	(* adjust Analog input filter time constant with a parameter, using .Unfilt and .Ai *)
	xFILTER_R_LSL_In.In		:=	tLSL_In.Unfilt;
	xFILTER_R_LSL_In.Filter	:=	TIME_TO_UINT(Para.tiFilt_LSL_In);
	xFILTER_R_LSL_In();
	tLSL_In.Ai	 			:= 	xFILTER_R_LSL_In.Out;

	(* Hardware bypass digital twin - T3 adaptive cranking time *)
	xTOF_HwBypassDigitalTwin(IN := NOT tGV1_Open.Do AND NOT tGV2_Open.Do AND tEleStarter_Dem.Do, PT := T#6s);
	OUT_HA.bTOF_HwBypassDigitalTwin := xTOF_HwBypassDigitalTwin.Q;


	(* Error information strings *)

	szHalIOErrInfo1 := ErrInfo1;
	szHalIOErrInfo2 := ErrInfo2;
	szHalIOErrInfo3 := ErrInfo3;
	
	
	(* System cyclic time viaolation monitoring *)	
	
	(* measure real time execution of code *)
	iSysTime_Diff	 := OUT_HA.iSystemTime - iSysTime_Old;		(* current value *)
	iSysTime_Old	 := OUT_HA.iSystemTime;

	(* generate 1 second tick: prevention of too many Logger entries *)
	TON_SecondTick(IN := (NOT TON_SecondTick.Q AND iSysTime_Diff < 2000), PT := T#998ms);		(* 998ms + 2 times cycle time = 1 sec.*)
	
	(* start new Logger entry *)
	IF iSysTime_Diff > 2000 AND iSysTime_Diff > iSysTime_DiffMax THEN
	
		(* increase cycle time violation counter *)
		MM2VIS.iNum_CyleTimeViolCnt := MM2VIS.iNum_CyleTimeViolCnt + 1;

			(* write logger entry *)
			memset(ADR(AddData),0,SIZEOF(AddData));
			nextAdr:= brsstrcpy(ADR(AddData), ADR('Cycle time violation in TC#1 | Event count: '));
			strLen:= brsitoa(MM2VIS.iNum_CyleTimeViolCnt, nextAdr);
			nextAdr:= strcat(ADR(AddData),ADR(' | Execution time: '));
			strLen:= brsitoa((iSysTime_Diff/1000), nextAdr);
			nextAdr:= strcat(ADR(AddData),ADR('ms'));
			ArEventLogWrite_0.Execute:= TRUE;		//Bugfix- disable line for PPC900 	
			ArEventLogWrite_0();					//Bugfix- disable line for PPC900 
			ArEventLogWrite_0.Execute:= FALSE;		//Bugfix- disable line for PPC900 
			ArEventLogWrite_0();					//Bugfix- disable line for PPC900 

		(* set bit for other functions *)
		bCycleTimeViolTriggered := TRUE;				
		
		(* save last diff compare value *)
		iSysTime_DiffMax := iSysTime_Diff;
				
	ELSE
		
		(* reset max values for next event *)
		IF TON_SecondTick.Q THEN
			iSysTime_DiffMax := MIN(iSysTime_Diff,iSysTime_DiffMax);	(* min value *)
		END_IF;
			
	END_IF;

(**************************************************)
	(* Ventilation mapping *)
	(* inlet louvers open (TRUE = opened / FALSE = no longer opened) *)
	tERV_INL1_Lou_OP.Di;	tERV_INL1_Lou_OP.GoodQual;
	tERV_INL2_Lou_OP.Di;	tERV_INL2_Lou_OP.GoodQual;
	tERV_INL3_Lou_OP.Di;	tERV_INL3_Lou_OP.GoodQual;
	tERV_INL4_Lou_OP.Di;	tERV_INL4_Lou_OP.GoodQual;
	tERV_INL5_Lou_OP.Di;	tERV_INL5_Lou_OP.GoodQual;
	tERV_INL6_Lou_OP.Di;	tERV_INL6_Lou_OP.GoodQual;

	(* inlet louvers close (TRUE = closed / FALSE = no longer closed) *)
	tERV_INL1_Lou_CL.Di;	tERV_INL1_Lou_CL.GoodQual;
	tERV_INL2_Lou_CL.Di;	tERV_INL2_Lou_CL.GoodQual;
	tERV_INL3_Lou_CL.Di;	tERV_INL3_Lou_CL.GoodQual;
	tERV_INL4_Lou_CL.Di;	tERV_INL4_Lou_CL.GoodQual;
	tERV_INL5_Lou_CL.Di;	tERV_INL5_Lou_CL.GoodQual;
	tERV_INL6_Lou_CL.Di;	tERV_INL6_Lou_CL.GoodQual;

	(* outlet louvers open (TRUE = opened / FALSE = no longer opened) *)
	tERV_OTL1_Lou_OP.Di;	tERV_OTL1_Lou_OP.GoodQual;
	tERV_OTL2_Lou_OP.Di;	tERV_OTL2_Lou_OP.GoodQual;
	tERV_OTL3_Lou_OP.Di;	tERV_OTL3_Lou_OP.GoodQual;
	tERV_OTL4_Lou_OP.Di;	tERV_OTL4_Lou_OP.GoodQual;
	tERV_OTL5_Lou_OP.Di;	tERV_OTL5_Lou_OP.GoodQual;
	tERV_OTL6_Lou_OP.Di;	tERV_OTL6_Lou_OP.GoodQual;

	(* outlet louvers close (TRUE = closed / FALSE = no longer closed) *)
	tERV_OTL1_Lou_CL.Di;	tERV_OTL1_Lou_CL.GoodQual;
	tERV_OTL2_Lou_CL.Di;	tERV_OTL2_Lou_CL.GoodQual;
	tERV_OTL3_Lou_CL.Di;	tERV_OTL3_Lou_CL.GoodQual;
	tERV_OTL4_Lou_CL.Di;	tERV_OTL4_Lou_CL.GoodQual;
	tERV_OTL5_Lou_CL.Di;	tERV_OTL5_Lou_CL.GoodQual;
	tERV_OTL6_Lou_CL.Di;	tERV_OTL6_Lou_CL.GoodQual;

	(* Fans in operation (TRUE = in operation / FALSE = not in operation)*)
	tERV_INL1_Fan_Run.Di;	tERV_INL1_Fan_Run.GoodQual;
	tERV_INL2_Fan_Run.Di;	tERV_INL2_Fan_Run.GoodQual;
	tERV_INL3_Fan_Run.Di;	tERV_INL3_Fan_Run.GoodQual;
	tERV_INL4_Fan_Run.Di;	tERV_INL4_Fan_Run.GoodQual;
	tERV_INL5_Fan_Run.Di;	tERV_INL5_Fan_Run.GoodQual;
	tERV_INL6_Fan_Run.Di;	tERV_INL6_Fan_Run.GoodQual;


IF IN_HA.bSafetyPLC_Active OR OUT_HA.bSimWinMOD_Active THEN
	(* Inlet Louvers *)
	(* First group of inlet louver connected to stage 1 *)
	IF tERV_INL1_Lou_OP.GoodQual THEN
		tInAirER_Lou1Opened.Di := tERV_INL1_Lou_OP.Di;
		tInAirER_Lou1Opened.GoodQual := tERV_INL1_Lou_OP.GoodQual;
	END_IF;
	IF tERV_INL1_Lou_CL.GoodQual THEN
		tInAirER_Lou1Closed.Di := tERV_INL1_Lou_CL.Di;
		tInAirER_Lou1Closed.GoodQual := tERV_INL1_Lou_CL.GoodQual;
	END_IF;

	(* Second group of inlet louver connected to stage 2*)
	IF tERV_INL2_Lou_OP.GoodQual THEN
		tInAirER_Lou2Opened.Di := tERV_INL2_Lou_OP.Di;
		tInAirER_Lou2Opened.GoodQual := tERV_INL2_Lou_OP.GoodQual;
	END_IF;
	IF tERV_INL2_Lou_CL.GoodQual THEN 
		tInAirER_Lou2Closed.Di := tERV_INL2_Lou_CL.Di;
		tInAirER_Lou2Closed.GoodQual := tERV_INL2_Lou_CL.GoodQual;
	END_IF;

	(* Third group of inlet louver connected to stage 1*)
	IF tERV_INL3_Lou_OP.GoodQual THEN
		tInAirER_Lou1Opened.Di := tInAirER_Lou1Opened.Di AND tERV_INL3_Lou_OP.Di;
	END_IF;
	IF tERV_INL3_Lou_CL.GoodQual THEN
		tInAirER_Lou1Closed.Di := tInAirER_Lou1Closed.Di AND tERV_INL3_Lou_CL.Di;
	END_IF;

	(* Fourth group of inlet louver connected to stage 2*)
	IF tERV_INL4_Lou_OP.GoodQual THEN
		tInAirER_Lou2Opened.Di := tInAirER_Lou2Opened.Di AND tERV_INL4_Lou_OP.Di;
	END_IF;
	IF tERV_INL4_Lou_CL.GoodQual THEN
		tInAirER_Lou2Closed.Di := tInAirER_Lou2Closed.Di AND tERV_INL4_Lou_CL.Di;
	END_IF;

	(* Firth group of inlet louver connected to stage 1*)
	IF tERV_INL5_Lou_OP.GoodQual THEN
		tInAirER_Lou1Opened.Di := tInAirER_Lou1Opened.Di AND tERV_INL5_Lou_OP.Di;
	END_IF;
	IF tERV_INL5_Lou_CL.GoodQual THEN
		tInAirER_Lou1Closed.Di := tInAirER_Lou1Closed.Di AND tERV_INL5_Lou_CL.Di;
	END_IF;

	(* Sixth group of inlet louver connected to stage 2*)
	IF tERV_INL6_Lou_OP.GoodQual THEN
		tInAirER_Lou2Opened.Di := tInAirER_Lou2Opened.Di AND tERV_INL6_Lou_OP.Di;
	END_IF;
	IF tERV_INL6_Lou_CL.GoodQual THEN
		tInAirER_Lou2Closed.Di := tInAirER_Lou2Closed.Di AND tERV_INL6_Lou_CL.Di;
	END_IF;


	(* Outlet Louvers *)
	(* First group of outlet louver *)
	IF tERV_OTL1_Lou_OP.GoodQual THEN
		tOutAirER_LouOpened.Di := tERV_OTL1_Lou_OP.Di;
		tOutAirER_LouOpened.GoodQual := tERV_OTL1_Lou_OP.GoodQual;
	END_IF;
	IF tERV_OTL1_Lou_CL.GoodQual THEN
		tOutAirER_LouClosed.Di := tERV_OTL1_Lou_CL.Di;
		tOutAirER_LouClosed.GoodQual := tERV_OTL1_Lou_CL.GoodQual;
	END_IF;

	(* Second group of outlet louver *)
	IF tERV_OTL2_Lou_OP.GoodQual THEN
		tOutAirER_LouOpened.Di := tOutAirER_LouOpened.Di AND tERV_OTL2_Lou_OP.Di;
	END_IF;
	IF tERV_OTL2_Lou_CL.GoodQual THEN
		tOutAirER_LouClosed.Di := tOutAirER_LouClosed.Di AND tERV_OTL2_Lou_CL.Di;
	END_IF;

	(* Third group of outlet louver *)
	IF tERV_OTL3_Lou_OP.GoodQual THEN
		tOutAirER_LouOpened.Di := tOutAirER_LouOpened.Di AND tERV_OTL3_Lou_OP.Di;
	END_IF;
	IF tERV_OTL3_Lou_CL.GoodQual THEN
		tOutAirER_LouClosed.Di := tOutAirER_LouClosed.Di AND tERV_OTL3_Lou_CL.Di;
	END_IF;

	(* Fourth group of outlet louver *)
	IF tERV_OTL4_Lou_OP.GoodQual THEN
		tOutAirER_LouOpened.Di := tOutAirER_LouOpened.Di AND tERV_OTL4_Lou_OP.Di;
	END_IF;
	IF tERV_OTL4_Lou_CL.GoodQual THEN
		tOutAirER_LouClosed.Di := tOutAirER_LouClosed.Di AND tERV_OTL4_Lou_CL.Di;
	END_IF;

	(* Fifth group of outlet louver *)
	IF tERV_OTL5_Lou_OP.GoodQual THEN
		tOutAirER_LouOpened.Di := tOutAirER_LouOpened.Di AND tERV_OTL5_Lou_OP.Di;
	END_IF;
	IF tERV_OTL5_Lou_CL.GoodQual THEN
		tOutAirER_LouClosed.Di := tOutAirER_LouClosed.Di AND tERV_OTL5_Lou_CL.Di;
	END_IF;

	(* Sixth group of outlet louver *)
	IF tERV_OTL6_Lou_OP.GoodQual THEN
		tOutAirER_LouOpened.Di := tOutAirER_LouOpened.Di AND tERV_OTL6_Lou_OP.Di;
	END_IF;
	IF tERV_OTL6_Lou_CL.GoodQual THEN
		tOutAirER_LouClosed.Di := tOutAirER_LouClosed.Di AND tERV_OTL6_Lou_CL.Di;
	END_IF;
END_IF;

IF IN_HA.bSafetyPLC_Active THEN
	(* Safety loop from SAFETY PLC *)
	tSafetyLoop_EmStop.Di		:= IN_HA.bSafeOUT_SafetyLoop_EmStop;
	tSafetyLoop_EmStop.GoodQual	:= TRUE;

	tSafetyLoop_Eng.Di			:= IN_HA.bSafeOUT_SafetyLoop_Eng;
	tSafetyLoop_Eng.GoodQual	:= TRUE;
END_IF;

(**************************************************)

END_PROGRAM

