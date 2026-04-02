(*******************************************************************************
AGGR: selection of the operating state (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company. 
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
- Calculation of actual power in kW and permill
- Filtering of actual power
- Selection of the operating state of the engine in dependence of
  speed (n_ist) generator switch (gen_sch) and mains switch (net_sch)
- Creating of operating message for the alarmmanagement
 
History:
-------
V0.1	13-06-2001	Fahringer, generated from betr_zus V0.2
		20-07-2001	Fahringer, last modification	
V0.2	03-09-2002	Fahringer, clculation of n_ist, p_ist, P_IST_OF,
							   ssPowerEx, P_IST_PROM add
V0.3	26-10-2002	Fahringer, engine speed meassured via ignition system
V0.31	21-11-2003	Fahringer, 100 rpm hystersis between StartM and LeerlM
V0.4	18-04-2004	Fahringer, calculation of speed is done in eng_ctr
V0.5	12-02-2007	Weitzer,   copy DIs for GCB and MCB to existiong PVs
							   replace mA power input by ssPAct from MMUSynch
V0.51	18.01.2008	Lechner,   adapted net_sch for test-bench run
V0.52	30.09.2010	Maier (BuR),	allocation DI_GCB_ON_TC1 to gen_sch deleted 
		30.09.2010	Maier (BuR),	gen_sch replaced with GCB_ON_TC1
		01.10.2010	Maier (BuR), 	net_sch replaced with bPowerMode
		01.10.2010	Maier (BuR),	DI_MCB_ON_TC1 replaced with MCB_ON_TC1

--------------------
V3.99.0	19.10.2011	Graus,		implementation of the module for modular software
V3.99.1	24.10.2012	Graus,		extension of early opening of gas valves
V3.99.2	07.11.2012	Graus,		upgrade opstate machine function
								start state only is activated in transition from stop state
V3.99.3	12.11.2012	Graus,		change PT of xTOF_OpHour to T#10s
					Ze			AND NOT M_ABLOCK; 	 *changed, 4.6.13*
		18.11.2013	Graus,		bugfix FOR possible division BY 0
		17.12.2013	Graus,		bugfix - use case for OMSS and RSS state instead of direct comparisons in logic terms
V3.99.4 29.01.2014 	zengerer	bGV_Start_ScaveBlock Interface
V4.00.0 11.02.2014 	Graus,		change Version TO 4.0
V4.00.1 06.03.2014 	Graus,		change name of bGlowIgnPrevent to bGlowIgnPrevActive
V4.00.2 30.04.2014	Graus, Ze	M_ABLOCK := NOT(
V4.01.0 19.05.2014  Denk		Bugfix. Abstellstörung 1023 wie bei XT4 Pilotanlage
								Blockierung mit N_OP.tDI_Dem_EU_Block.Di
V4.01.1 27.05.2014  Graus		Delay FOR OMSS states like in XT3 (T=1s)
								Bugfix FOR bEng_Bloc
V4.01.2 27.05.2014  Graus		add bLockAckStarter to blocking engine
V4.01.3 02.06.2014	Weitzer		logic of M_ABLOCK corrected
					Denk/Weitzer block engine by EVU corrected
V4.01.4 24.06.2014  Graus		add bEng_Bloc_SGM(M_GM_Ref) to opstate logic
V4.01.5	15.10.2014	Caks,		added glow ignition, blocks module after run
V4.01.6	27.11.2014	Graus,		add submode TO opstate status
V4.02.0	24.02.2015	Graus,		add changes for J920 blocking engine
V4.02.1 13.03.2015	Graus,		bugfix: invert usage of IN_OP.bEng_Bloc_EC for bEng_Bloc
		20.10.2015	Caks,		added counters for: demand, netp and island operation
V4.03BETA 15.12.	Zengerer	new State 32: waiing for next automatic start (for new BR4 start procedure)
V4.03	26.01.2016	Perktold	changed bEng_Block_EVU in case of manual mode
V4.04.00	11.10.2016	Gwiggner	change Version TO 4.04	
			19.10.2016	Gomez Ortiz	Modification of the cooling run phase
			28.10.2016	Gomez Ortiz	Separation between engine operation hour counter and unit op. hour counter
			21.12.2016  Denk		Modification for WinMOD simulation
 
 			02.02.2016	Zengerer	Modification for state 32 waiting for next automatic start 
 			02.02.2017	lettenb.	OUT_OP.bEng_Bloc: ...FC_Rdy included(sky)
V4.05.00	24.04.2017	Denk		SWAT 920 Rel.2, block engine after 5 times W2462  
			10.05.2017	Gomez Ortiz	Changes for Spezifikation_Ölkreislauf_Schnellstart_BR9
			14.06.2017	lettenb.	ZM_M_REL: bRelEngStart_OilSkid added acc.spec.gen.oilskid, xGR_MAXR_OpenGV.Gw:= 80->60 for 920(fahringer)
			26.06.2017	lettenb.	tEng_Aux_Dem_CDR2/3 added for multiple use(grain)
			10.07.2017	Denk		SWAT 920 Rel.3, block engine after 5 times W2465 
			31.07.2017  Denk		SWAT 920, changes after validation. Deflagration protection different function for type 6 and type 9
			07.11.2017  Perktold,	op_state Task changed for houseload requirement
			19.01.2018	Gomez Ortiz	Extension of the early open valve timing for type 9 engines 
			09.02.2018	Perktold	920er FastStart change for OUT_OP.tEng_Aux_Dem_CDR.Do calculation - bFS_Act deleted
V4.05.02	05-04-2018	Perktold,	added IN_OP.bFS_Act for OilSkid Start Release Type 9
V4.05.03	05-09-2018	Gwiggner	BU 01: bugfix function block xTP_OpenGV
V4.06.00	12-06-2018	Perktold	changes for GEN2/FastStart
V4.06.01	18.09.2018	Zengerer	new engine blocking at W1995 Perm Error
			03-10-2018	Hohensinner	Bugfix: Engine ready remote only when synchronization selector switch in position automatic
V4.07.00	25.04.2018	lettenb.	1165,9214 start lockout added, SWAT920/5
			14.01.2019	Schmid		W9249 (deflagration detection) blocks engine restart
V4.07.01	30.01.2019	Hohensinner	Code clean up and Diagnose Interfaces
			03.02.2019	Perktold	tEng_Run.Do geändert (BugFix)
			25.02.2019	lettenb.	bERV_NotRdy added, engine room ventilation not ready - block engine start, PWR-FFI-2018-0637 gem. TA 1100-0110
			13.03.2019	Hohensinner	block engine at low EO/ECW temperatures for type9, block engine at grid code data structure failure
V4.07.04	10.04.2019	Hohensinner	removed UPS DI signals from engine blocked array & cleanup #07
V4.07.05	15.05.2019	Hohensinner	added EngBlock_PlantCtr DI --> Blocks module smooth
			20.05.2019	Hohensinner	EngBlock_PlantCtr DI debugged for smooth shutdown in manual mode
			04.11.2019	Schmidt		BU 01: Type 6 cooldown run duration modified from 0s to 10s
V4.09.00	28.11.2019	lettenb.	bBloc_SY_ProtTest added, protection test(ThJ)
			13.01.2020	Arnold,		time delay for early GV opening changed to 9.8s
			12.02.2020	Zuschnig, 	included B2972 and B2973 - Power Mode on/off
V4.10.00	22.05.2020	lettenb.	bEng_Bloc[29-33] added
			20.10.2020	Zuschnig,	removed activation of module blocked by oil skid only if fast start is active -> always active
			16.10.2020	Weitzer,	release power mode by customer bit bReq_PowMod_Ext
			07.10.2020	Perktold	added fast start counter
			18.01.2021	Perktold	unbundling emergency stop and fire alarm
			18.01.2021	Weitzer		IN_OP.bBloc_SY_Rel_Cust to SY release array added
			27.01.2021  Zuschnig	Ensure TON,TOF,TP are always executed
V4.11.00	22.11.2021	Perktold,	added myPlant remote request/P-setpoint
			14.10.2021	Andre,		added SAFI in operation mode to start up release
			02.02.2022	Schmid,		no start blockade by ECWP_FC_Rdy in case of black start
V4.12.00	08.09.2022	Andre,		added SEMIC in operation mode to start up release
			20.09.2022	Perktold,	Additional delay for ignition deactivation for non-successful starts 
			26.09.2022	Perktold,	Added IN signal to xTOFIgn_Dem in case of a prio 1 trip
			10.01.2023	lettenb.	bReq_Bloc[4]: bOMSS_MAN->(OUT_OP.iIdx_OMSS = 1), bOMSS_MAN is too slow for bumpless switchover MAN -> AUT, #966
			25.01.2023	Tinello		Added engine blocked by charge temperature after TC
V4.13.00	26.09.2023	Farre,		Addition engine blocked by LCB opened (info #37)
			24.08.2023	Zengerer	Add counter correction IN_OP.iCnt_OpHours_Set, iCnt_UnitOpHours_Set, iCnt_FastStarts_Set, iCnt_FastStarts_Set	
			03.11.2023	Zuschnig	Add operating counter low load 
			20.11.2023	Farre,		added "request power mode" interface from CU needed for Microgrid (2023-168)
			04.12.2023	Goenczi		Added Emergency request via Bus coupling - bEng_Dem_EPS_Bus
			04.12.2023	Goenczi		Hand over iIdx_Eng_State to OUT_OP
			17.01.2024	Schmidt		Bugfix deflagration protection: added IN_OP.bIgnDeflPrct_Off to ignition demand logic (issue 1406)
V4.14.00	28.03.2024	Soto/Farre,	Added CAN WG configuration for start up release (2023-174)
			25.10.2024	Farre		include in bEng_Bloc[1] - rel. sync- when GCB position signal failure and enigne stopped (2024-241)
			25.11.2024	Bacci		T6 Start procedure with purge start (2024-219): added waiting time for starter release in state 32 and 7

Instructions for use:
--------------------

Outstandings:
------------

*******************************************************************************)

FUNCTION AND_Array
	memcpy(ADR(Arrayx),Adress,MIN(40,Size) + 1);
	AND_Array	:=	 TRUE;
	FOR i:= 0 TO MIN(40,Size) DO
		AND_Array	:=	AND_Array AND Arrayx[i];
	END_FOR
END_FUNCTION

FUNCTION OR_Array
	memcpy(ADR(Arrayx),Adress,MIN(40,Size) + 1);
	OR_Array	:=	 FALSE;
	FOR i:= 0 TO MIN(40,Size) DO
		OR_Array	:=	OR_Array OR Arrayx[i];
	END_FOR
END_FUNCTION

FUNCTION DINT_INC_CNT
	DINT_INC_CNT	:=	Input + 1;
	IF DINT_INC_CNT >= 1000000000 THEN
		DINT_INC_CNT := DINT_INC_CNT - 1000000000;		(* check upper limit *)
	ELSIF DINT_INC_CNT <= -1000000000 THEN
		DINT_INC_CNT := DINT_INC_CNT + 1000000000;		(* check lower limit *)
	END_IF;
END_FUNCTION

PROGRAM _CYCLIC

(** 1: Execute EngType for Module *)
	xEngType.Motortype := INT_TO_UINT(Para.iEng_Motortype);
	xEngType();

(** 2: Build OMSS and RSS bits for states *)
	xTOF_OFF(IN := OUT_OP.iIdx_OMSS = 0, PT := T#1s);
	xTOF_MAN(IN := OUT_OP.iIdx_OMSS = 1, PT := T#1s);
	xTOF_AUTO(IN := OUT_OP.iIdx_OMSS = 2, PT := T#1s);
	xTOF_TEST(IN := OUT_OP.iIdx_OMSS = 3, PT := T#1s);
	xTOF_SCAV(IN := OUT_OP.iIdx_OMSS = 4, PT := T#1s);
	xTON_Eng_SU_Aut(IN := OUT_OP.bEng_SU_Aut, PT := T#6s);  (*V4.04 -> State 32*)
	
	bOMSS_OFF := xTOF_OFF.Q;
	bOMSS_MAN := xTOF_MAN.Q;
	bOMSS_AUTO := xTOF_AUTO.Q;
	bOMSS_TEST := xTOF_TEST.Q;
	bOMSS_SCAV := xTOF_SCAV.Q;
	
	bRSS_OFF := OUT_OP.iIdx_RSS = 0;
	bRSS_ON  := OUT_OP.iIdx_RSS = 1;
	bRSS_REM := OUT_OP.iIdx_RSS = 2;

	OUT_OP.tOMSS_MAT.Do := bOMSS_MAN OR bOMSS_AUTO OR bOMSS_TEST; 
	
(** 3: Reject to house load type 6 / Fangen im Eigenbedarf Baureihe 6*)
	bTrigger_Island	:= xEngType.Type6 AND Para.bRej2houseload AND xOpMode.NetP AND (IN_OP.rN_EngAct >= rN_Eng_Limit);
	TOF_bTrigger_Island(IN := bTrigger_Island, PT := tOff_Trigger);

(** 4: Powermode *)
	bPowerMode := ((IN_OP.tMCB_On.Di AND NOT TOF_bTrigger_Island.Q) AND (IN_OP.tMnsOk.Di OR NOT IN_OP.bTestBenchModeIsland)) OR IN_OP.bReq_PowMod OR IN_OP.bReq_PowMod_Ext;
	
	IF IN_OP.tGCB_On.Di AND OUT_OP.tEng_Run.Do AND NOT IN_OP.tMCB_On.Di AND NOT IN_OP.bMCB_DemSy AND (IN_OP.bReq_PowMod OR IN_OP.bReq_PowMod_Ext) AND NOT bMsg2973 THEN
		bMsg2972 := TRUE;
	ELSE
		bMsg2972 := FALSE;
	END_IF;
	
	TOF_b2973(IN := EDGENEG (bMsg2972), PT := T#5s);
	bMsg2973 := TOF_b2973.Q;	
		
(** 5: OpMode State machine: condition of engine state in dependence of actual speed, generator switch and mains switch*)
	IF IN_OP.rN_EngAct < 50 THEN							(* condition for engine operating state STOP	*)
		OUT_OP.iSt_OpMode := 16#00010000 * 10;	(* StopM -> 10 *)
	ELSE
		IF xOpMode.Stop THEN (* transition from stop mode *)
			bStop2Start := TRUE;
		END_IF;
		IF (IN_OP.rN_EngAct < Para.rN_Start_Trig) AND bStop2Start THEN			(* condition for engine operating state START	*)
			OUT_OP.iSt_OpMode := 16#00010000 * 30;	(* StartM -> 30 *)
		ELSE
			bStop2Start := FALSE;
			IF IN_OP.tGCB_On.Di AND bPowerMode THEN		(* condition for engine operating in parallel with system	*)
				OUT_OP.iSt_OpMode := 16#00010000 * 50;	(* NetpM -> 50 *)
			ELSE
				IF IN_OP.tGCB_On.Di AND NOT bPowerMode THEN	(* condition for engine operating in isolated mode	*)
					OUT_OP.iSt_OpMode := 16#00010000 * 60;	(* InselM -> 60 *)
				ELSIF IN_OP.rN_EngAct >= Para.rN_Start_Trig THEN
					OUT_OP.iSt_OpMode := 16#00010000 * 40;	(* LeerlM -> 40 *)
				END_IF;
			END_IF;
		END_IF;
	END_IF;

	xOpMode(in := OUT_OP.iSt_OpMode);	

(** 6: Emergency Request *)	
	OUT_OP.bEng_Dem_EPS	:=
							((IN_OP.tEng_Dem_EPS_Ext.Di OR IN_OP.bEng_Dem_EPS_Bus OR IN_OP.bEng_Dem_EPS_Sy) AND NOT IN_OP.bOnly_Island)
						OR 	(IN_OP.bOnly_Island AND NOT IN_OP.bOtherGenParallel);
						
	xTOF_EngDemEPS(IN:= OUT_OP.bEng_Dem_EPS AND NOT IN_OP.tGCB_On.Di, PT:= T#60s);
	bNoMon4BlackStart := xTOF_EngDemEPS.Q AND OUT_OP.bEng_Dem_EPS; //T14

(** 7: Excitation bit *)
	OUT_OP.bEng_SUpE := IN_OP.tEng_SUExc_Rel.Di;

(** 8: Plant control *)
	(** 8.1: W1188 release by station missing *)
	xTP_AT27(IN := NOT IN_OP.tRel_MasCtr.Di, PT := T#300s);
	AT27	:=	NOT xTP_AT27.Q AND IN_OP.tRel_MasCtr.Di;
	
	(** 8.2: Wxxxx block by plant control - smooth *)	
	xTON_Block_PlantCtr(IN:= IN_OP.tEngBlock_PlantCtr.Di AND IN_OP.tEngBlock_PlantCtr.GoodQual, PT:=T#100ms);
	bEng_Block_PlantCtr	:=	xTON_Block_PlantCtr.Q;
	
	IF bEng_Block_PlantCtr AND bOMSS_MAN THEN																	(* set load to zero in manual mode *)
		VIS2MM.rP_set_vis		:=	0;
	END_IF
	IF EDGEPOS(bEng_Block_PlantCtr AND bOMSS_MAN AND (OUT_OP.rP_Act_Norm_Filt < 0.1 OR xOpMode.Island)) THEN	(* stop engine if under 10% load or island mode *)
		OUT_OP.bEng_Stop_Man	:=	TRUE;
	END_IF

(** 9: Engine Blocked Array  *)
	(* Info compared to old SW: 0-7 represents old variable "NOT ZM_M_REL" *)
	bEng_Bloc[0]	:=	NOT ((IN_OP.bMainsReturn AND (IN_OP.bRelMainsConnect OR xOpMode.NetP)) OR IN_OP.bRel_Island OR IN_OP.bRel_IslandAfMITime OR NOT Para.bSyActive);	(* Mains failure *)
	bEng_Bloc[1]	:=	(NOT IN_OP.bRelEngOpFromSy) OR IN_OP.bGCB_psf_EngStop;																								(* Release from Sync missing or gcb position failure when engine stopped *)
	bEng_Bloc[2]	:=	NOT AT27 OR (bEng_Block_PlantCtr AND NOT bEng_StaSpdExc);																							(* W1188 release by station missing *)
	bEng_Bloc[3]	:=	NOT IN_OP.bGasSupplyOk;																																(* Gas supply missing *)
	bEng_Bloc[4]	:=	NOT (	(NOT xEngType.Type9 AND NOT IN_OP.bDeflagrationPrct)																						(* Deflagration protection not Type 9 *)
							OR	(xEngType.Type9 AND ((NOT IN_OP.bDeflagrationPrct AND NOT IN_OP.bPBC_Active) OR IN_OP.bPBC_Active)));										(* Deflagration protection Type 9 *)
	bEng_Bloc[5]	:=	NOT IN_OP.tGV_Rel.Do;																																(* Gas valve release missing *)
	bEng_Bloc[6]	:=	IN_OP.bLockAckStarter;																																(* Starter temperature *)
	bEng_Bloc[7]	:=	xEngType.Type9 AND NOT bEng_StaSpdExc AND NOT IN_OP.bRelEngStart_OilSkid;																			(* Oil skid Type 9 *)
	bEng_Bloc[8]	:=	IN_OP.bEng_Block_Customized;																														(* Customer specific *)
	bEng_Bloc[9]	:=	IN_OP.tMCB_On.Di AND NOT OUT_OP.tEng_Run.Do AND IN_OP.tP_GenC_Bloc.Do;																				(* EU - Power reduction over limit *)
	bEng_Bloc[10]	:=	(IN_OP.bMsg3583 OR 	IN_OP.bMsg3584) AND Para.bGlowIgnPrevActive;																					(* Special gas: Exhaust gas temperatures *)
	bEng_Bloc[11]	:=	IN_OP.bSG_Eng_Block_EGT; 																															(* Special gas: blocked after 30min operation *)
	bEng_Bloc[12]	:=	IN_OP.bEng_Bloc_EC;(* AND Para.bSA_PI_Active;*)																										(* Blocked by Engine Controller*)
	bEng_Bloc[13]	:=	IN_OP.bSAFIPBCConfNotOK AND Para.bSA_PBC_Active;																									(* Blocked by SAFI PBC configuration *)
	bEng_Bloc[14]	:=	(bOMSS_AUTO AND NOT bEng_StaSpdExc AND NOT IN_OP.tScavFanFC_Rdy.Di);																				(* Blocked by FC scavanging fan *)
	bEng_Bloc[15]	:=	(bOMSS_AUTO AND NOT bEng_StaSpdExc AND NOT IN_OP.tECWP_FC_Rdy.Di AND NOT bNoMon4BlackStart);														(* Blocked by FC ECWP *)
	bEng_Bloc[16]	:=	(bOMSS_AUTO AND NOT bEng_StaSpdExc AND NOT IN_OP.tEOP_FC_Rdy.Di);																					(* Blocked by FC EOP *)
	bEng_Bloc[17]	:=	(bOMSS_AUTO AND NOT bEng_StaSpdExc AND NOT IN_OP.tBbBlower_FC_Rdy.Di);																				(* Blocked by FC Byblower *)
	bEng_Bloc[18]	:=	((IN_OP.bAMM_Pr_MGT_a_Filt_BlockStart OR IN_OP.bAMM_Pr_PCGT_a_Filt_BlockStart) AND xEngType.Type9); 												(* 5times MSF in gastrain *)
	bEng_Bloc[19]	:=	(IN_OP.bMsg9214 AND NOT bEng_StaSpdExc AND xEngType.Type9); //SWAT920/5																				(* Engine turn equipment active *)
	bEng_Bloc[20]	:=	(IN_OP.bMsg1165 AND NOT bEng_StaSpdExc AND xEngType.Type9); //SWAT920/5																				(* Exhaust gas scavanging failure *)
	bEng_Bloc[21]	:=	(IN_OP.bMsg1995 AND NOT bEng_StaSpdExc );																											(* Perm failure in stop mode *)
	bEng_Bloc[22]	:=	IN_OP.tMCB_On.Di AND NOT OUT_OP.tEng_Run.Do AND IN_OP.tDI_Dem_EU_Block.Di;																			(* EU - Blocked by DI *)
	bEng_Bloc[23]	:=	IN_OP.tMCB_On.Di AND NOT OUT_OP.tEng_Run.Do AND IN_OP.bEng_Block_EVU;																				(* EU - Blocked by Bus *)
	bEng_Bloc[24]	:=	IN_OP.bMsg9249 AND NOT bEng_StaSpdExc;																												(* Deflagration detection *)
	bEng_Bloc[25]	:=	IN_OP.bERV_NotRdy AND NOT bEng_StaSpdExc;																											(* engine room ventilation not ready *)
	bEng_Bloc[26]	:=	xEngType.Type9 AND bOMSS_MAN AND NOT bEng_StaSpdExc AND IN_OP.bMsg2524;																				(* Type9: EO Temp low *)
	bEng_Bloc[27]	:=	xEngType.Type9 AND bOMSS_MAN AND NOT bEng_StaSpdExc AND bT_ECW_Lo;																					(* Type9: ECW Temp low *)
	bEng_Bloc[28]	:=	IN_OP.bEng_Bloc_GR AND NOT bEng_StaSpdExc;																											(* GR - data structure failure *)
	bEng_Bloc[29]	:=	NOT IN_OP.tScavFanCB_trip.Di AND NOT bEng_StaSpdExc;																								(* Blocked by CB scavenging fan tripped *)
	bEng_Bloc[30]	:=	NOT IN_OP.tGenIF_CB_On.Di AND NOT bEng_StaSpdExc;																									(* Blocked by CB generator interface panel tripped *)
	bEng_Bloc[31]	:=	IN_OP.bAMM_OilSkid_PumpLP_CB AND NOT bEng_StaSpdExc AND xEngType.Type9;																				(* Type9: Blocked by CB oil skid LP oil pump tripped *)
	bEng_Bloc[32]	:=	IN_OP.bAMM_OilSkid_PumpHP_CB AND NOT bEng_StaSpdExc AND xEngType.Type9;																				(* Type9: Blocked by CB oil skid HP oil pump tripped *)
	bEng_Bloc[33]	:=	IN_OP.bAMM_OilSkid_MCB AND NOT bEng_StaSpdExc AND xEngType.Type9;																					(* Type9: Blocked by oil skid main switch auxiliaries opened *)
	bEng_Bloc[34]	:=	NOT IN_OP.tECWP_CB_On.Di AND NOT bEng_StaSpdExc;																									(* Blocked by CB ECWP tripped *)
	bEng_Bloc[35]	:=	IN_OP.bEngBloc_EX AND NOT bEng_StaSpdExc;
	bEng_Bloc[36]	:=	NOT IN_OP.bRelEngStart_Ch_T2 AND NOT bEng_StaSpdExc;																								(* Blocked by charge temperature after TC *)
	bEng_Bloc[37]	:=	NOT IN_OP.tLineCB_On.Di AND IN_OP.tLineCB_On.GoodQual;																								(* Blocked by line circuit breaker open *)
	bEng_Bloc[38]	:=	IN_OP.bBlock_WG_CAN_Conf;																															(* Blocked by wastegate configuration in progress *)
	
	OUT_OP.bEng_Bloc		:=	OR_Array(ADR(bEng_Bloc),50);	(* 1 = engine is blocked *)
	MM2VIS.bEng_Bloc		:=	bEng_Bloc;						(* Array to VIS *)
	MM2VIS.bEng_Bloc_Show	:=	(iIdx_Eng_State = 19);			(* Show Array only on HMI if engine is blocked *)

(** 10: Demand Auxiliaries  *)
	OUT_OP.bEng_Aux_Dem :=	(OUT_OP.bEng_Dem AND (IN_OP.bPurgeER_Rdy OR NOT Para.bPurgecycle_Active) AND (IN_OP.bEGScav_Rdy OR OUT_OP.bEng_Dem_EPS)) OR IN_OP.bGV_On;

(** 11: Release Engine *)
	OUT_OP.bEng_Rel :=	OUT_OP.tOMSS_MAT.Do 
						AND ((NOT (bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3)) OR bDryTestBench)
						AND IN_OP.tPB2MM.bParaSetupOk;

(** 12: Start Up Release - Array for Manual and Automatic Mode *)
	bEng_SU[0]	:=	OUT_OP.bEng_Rel;																		(* Engine released *)
	bEng_SU[1]	:=	NOT bEng_StaSpdExc;																		(* Start speed not exceeded *)
	bEng_SU[2]	:=	IN_OP.bRelEngOp_Aux;																	(* Release from Auxiliaries *)
	bEng_SU[3]	:=	IN_OP.bScavFinished;																	(* Scavanging finished *)
	bEng_SU[4]	:=	(IN_OP.bPurgeER_Rdy AND IN_OP.tRel_ER_PurgeCycle.Di) OR NOT Para.bPurgecycle_Active;	(* Purge finished *)
	bEng_SU[5]	:=	NOT IN_OP.bEng_Bloc_SGM;																(* Special gas mixer calibration routine not active *)
	bEng_SU[6]	:=	IN_OP.bIC_OperationState AND IN_OP.bSA_CfgDone;											(* SEMIC used and in operation state *)
	
	MM2VIS.bEng_SU			:=	bEng_SU;																	(* Array to VIS *)
	MM2VIS.bEng_SU_Show		:=	(iIdx_Eng_State = 32) OR (iIdx_Eng_State = 9) OR (iIdx_Eng_State = 8) OR (iIdx_Eng_State = 6);	(* Show Array only on HMI if in this states *)
	
(** 13: Engine Ready Manual Mode *)
	OUT_OP.bEng_Rdy_Man :=	OUT_OP.bEng_Rel AND bOMSS_MAN AND NOT bEng_StaSpdExc AND NOT OUT_OP.bEng_Bloc; 
				
(** 14: Start Impulse 10s long *)
	xTP_Imp_Start(IN := IN_OP.bEng_Start, PT := T#10s);
	OUT_OP.bImp_Start := xTP_Imp_Start.Q;

(** 15: Delay next manual start for 5s *)	
	xTOF_BlocDelay_ManStart(IN := OUT_OP.bImp_Start OR IN_OP.bEng_Start , PT := T#5s);
	OUT_OP.bBlocDelay_ManStart := xTOF_BlocDelay_ManStart.Q;

(** 16: Blocking demand for 30s after a Start *)	
	xTOF_ANFBLO(IN := bEng_StaSpdExc, PT := T#30s); 
	OUT_OP.bEng_Dem_Bloc := xTOF_ANFBLO.Q;

(** 17: Start Up Failure - Manual Mode *)
	OUT_OP.bEng_Dem_Man_SUpF :=
							(bStart OR ZM_H_ANF OR OUT_OP.bEng_Dem_Aut OR (bOMSS_AUTO AND OUT_OP.bEng_CDR))
						AND OUT_OP.bEng_Rel 
						AND bOMSS_MAN 
						AND NOT OUT_OP.bEng_Stop_Man 
						AND NOT OUT_OP.bEng_Bloc;

	ZM_H_ANF :=				OUT_OP.bEng_Dem_Man_SUpF
						AND (NOT OUT_OP.bEng_Dem_Bloc OR IN_OP.bGV_On OR IN_OP.bEng_Start);

(** 18: Engine Demand - Manual Mode *)
	OUT_OP.bEng_Dem_Man := 
						(NOT bStart OR OUT_OP.bEng_Dem_Man) 
						AND ZM_H_ANF; 
	
(** 19: Start Up Release - Manual Mode *)
	OUT_OP.bEng_SU_Man	:=	AND_Array(ADR(bEng_SU),6) AND OUT_OP.bEng_Dem_Man;			(* 1 = start up *)

(** 19: Engine Start up - Manual Mode *)
	OUT_OP.bEng_Rel_SU	:=	OUT_OP.bEng_SU_Man AND (NOT OUT_OP.bBlocDelay_ManStart OR IN_OP.bEng_Start); 
	
(** 20: Notstrom Anforderung ohne reine Inselanlagen *)
	bRequest_EPS	:=	OUT_OP.bEng_Dem_EPS AND NOT IN_OP.bOnly_Island;				(* EPS *)

(** 21: Engine automatic request *)
	(** 21.1: Engine in Automatic demanded *)
	bReq_Dem[0]		:=	bRSS_ON;																	(* ON *)
	bReq_Dem[1]		:=	bRSS_REM AND VIS2MM.bRemoteReq AND Para.bRemoteReqActive;					(* HMI Button *)
	bReq_Dem[2]		:=	bRSS_REM AND IN_OP.tReq_PeakLoad.Di;										(* DI - Peakload *)
	bReq_Dem[3]		:=	bRSS_REM AND IN_OP.bBus_Dem;												(* BUS *)
	bReq_Dem[4]		:=	bRSS_REM AND IN_OP.bEngDSS_Mains;											(* Mains control *)
	bReq_Dem[5]		:=	bRSS_REM AND IN_OP.bCust_Dem;												(* Demand from Custom Module *)
	bReq_Dem[6]		:=	bRSS_REM AND IN_OP.tDemEngOpExt.Di;											(* DI - ExtDem *)
	bReq_Dem[7]		:=	bRSS_REM AND VIS2MM.bRemoteReq_myPlant AND Para.bRemoteReqMyPlantActive;	(* myPlant *)

	bReq_Remote		:= bReq_Dem[1] OR bReq_Dem[7];													(* Engine Demand via remote (HMI or myPlant) *)

	bRequest_Dem	:=	OR_Array(ADR(bReq_Dem),7);
	MM2VIS.bReq_Dem		:=	bReq_Dem;
	MM2VIS.bReq_Dem_Show:=	TRUE;		(* not used at moment *)

	(** 21.2: Block Automatic Engine demand *)
	bReq_Bloc[0]	:=	IN_OP.bGT_DemRelGasTypSwh; 									(* Gas type switching *)									
	bReq_Bloc[1]	:=	IN_OP.tP_GenC_Bloc.Do;										(* EU load reduction > limit *)		//EVU_BLOCK_INT	Mathias 2.6.2014
	bReq_Bloc[2]	:=	IN_OP.tDI_Dem_EU_Block.Di;									(* EU - DI *)						//DI_EVU_BLOCK  Mathias 2.6.2014
	bReq_Bloc[3]	:=	IN_OP.bEng_Block_EVU;										(* EU - Bus *)
	bReq_Bloc[4]	:=	bRequest_EPS AND (OUT_OP.iIdx_OMSS = 1);					(* EPS & OMSS Man *)
	bReq_Bloc[5]	:=	bRequest_EPS AND IN_OP.bSmoothDischarge;					(* EPS & smooth discharge *)
	bReq_Bloc[6]	:=	bEng_Block_PlantCtr;										(* PlantCtr *)
	
	bRequest_Bloc	:=	OR_Array(ADR(bReq_Bloc),6);
	MM2VIS.bReq_Bloc:=	bReq_Bloc;
	MM2VIS.bReq_Bloc_Show	:=	TRUE;	(* not used at moment *)

	(** 21.3: Request Engine - M_ANF *)
	xTON_T105(IN := bOMSS_TEST AND (xTON_T105.Q OR OUT_OP.tEng_Run.Do), PT := T#300s);	(* Test delay *)
	
	bReq_A[0] 		:=	bRequest_Dem AND NOT bRequest_Bloc;								(* Requested and not blocked *)
	bReq_A[1] 		:=	bRequest_EPS AND NOT IN_OP.bSmoothDischarge AND NOT bOMSS_MAN AND NOT bEng_Block_PlantCtr;	(* EPS request *)
	bReq_A[2] 		:=	bOMSS_MAN AND IN_OP.tGCB_On.Di;									(* OMSS Man and GCB closed *)
	bReq_A[3] 		:=	bOMSS_TEST AND (NOT xTON_T105.Q OR IN_OP.tReq_Test.Di); 		(* OMSS Test and Test Delay / DI *)

	bRequest_A 		:=	OR_Array(ADR(bReq_A),3);
	MM2VIS.bReq_A	:=	bReq_A;
	MM2VIS.bReq_A_Show	:=	bOMSS_AUTO;
	
	M_ANF	:= 	bRequest_A; 	(* rückwärtskompatiblität *)

(** 22: Engine demand start up failure & Engine demand in automatic mode *)
	xGRMinR_KWT(Gw := Para.rT_ECW_LimLo, Hy := Para.rT_ECW_HyLo, In := IN_OP.tT_ECW.Ai);
	xTON_kwtp(IN := xGRMinR_KWT.Q AND IN_OP.tPB2MM.bParaSetupOk, PT := T#2s);
	bT_ECW_Lo := xTON_kwtp.Q;	(* entspricht AN_KTMI - Kühlwassertemperatur minimum *)									//Überprüfen ob in powersel unten benötigt, vllt besser: von HC hermappen

	(* Release automatic start - M_ABLOCK *)
	bEng_Dem_A[0]	:=	NOT bT_ECW_Lo OR OUT_OP.bEng_Dem_EPS; 														(* Engine cooling water temperature not low *)
	bEng_Dem_A[1]	:=	NOT IN_OP.bPr_N2_LoTon OR OUT_OP.tEng_Run.Do OR IN_OP.bGT2_Select OR NOT IN_OP.bRel_ScavN2;	(* N2 scavanging done *)
	bEng_Dem_A[2]	:=	NOT OUT_OP.bEng_Bloc;																		(* Engine not blocked *)
	
	(* Release automatic start - OUT_OP.bEng_Dem_Aut_SUpF *)
	bEng_Dem_A[3]	:=	OUT_OP.bEng_Rel;																			(* Engine released *)
	bEng_Dem_A[4]	:=	bOMSS_AUTO OR bOMSS_TEST;																	(* OMSS Auto or Test *)
	bEng_Dem_A[5]	:=	bRequest_A;																					(* Engine automatic start requested *)

	(* Release automatic start - OUT_OP.bEng_Dem_Aut*)
	bEng_Dem_A[6]	:=	NOT bEng_StaSpdExc OR IN_OP.bGV_On OR IN_OP.bEng_Start;										(* Engine starts / runs *)
	bEng_Dem_A[7]	:=	NOT OUT_OP.bEng_Dem_Bloc OR	OUT_OP.tEng_Run.Do OR OUT_OP.bEng_Dem_Aut;						(* Engine request blocked, before: M_ANFBLO *)
	bEng_Dem_A[8]	:=	NOT IN_OP.tERDF_BLOCK.Do;																	(* ERDF *) 	
	bEng_Dem_A[9]	:=	NOT IN_OP.bOpMsg_Plim_ERDF_ABF_SOnOf;														(* Load reduction over limit *)


	M_ABLOCK					:=	AND_Array(ADR(bEng_Dem_A),2); 	//M_ABLOCK wird nun im array gebildet, bildet sich nur aus 0 bis 2
	OUT_OP.bEng_Dem_Aut_SUpF	:=	AND_Array(ADR(bEng_Dem_A),5);	//OUT_OP.bEng_Dem_Aut_SUpF bildet sich nur aus 0 bis 5
	OUT_OP.bEng_Dem_Aut			:=	AND_Array(ADR(bEng_Dem_A),9);
	MM2VIS.bEng_Dem_A			:=	bEng_Dem_A;
	MM2VIS.bEng_Dem_A_Show		:=	bOMSS_AUTO;


	ZM_M_BERAUT :=			OUT_OP.bEng_Rel 
						AND (bOMSS_AUTO OR (bOMSS_TEST AND OUT_OP.bEng_Dem_EPS)); 

(** 23: Engine ready for automatic mode *)	
	OUT_OP.bEng_Rdy_Aut		:=	ZM_M_BERAUT AND M_ABLOCK; 	(*changed, 4.6.13*)

(** 24: Engine ready for automatic mode - info for exitation system *)
	OUT_OP.bEng_Rdy_Aut_Exc	:=	ZM_M_BERAUT	AND (bRequest_A OR NOT IN_OP.bOnly_Island); 

(** 25: Engine ready for remote operation *)	
	OUT_OP.tEng_Rdy_Rem.Do	:=	OUT_OP.bEng_Rdy_Aut AND bRSS_REM AND IN_OP.iIdx_SyOMSS = 2; 

(** 26: Engine automatic startup *)
	OUT_OP.bEng_SU_Aut		:=	AND_Array(ADR(bEng_SU),6) AND OUT_OP.bEng_Dem_Aut;		(* 1 = start up *)

(** 27: Engine monitoring of after start for 10s *)
	xTOF_T9(IN := IN_OP.bEng_Start, PT := T#10s);
	OUT_OP.bEng_MonOff := xTOF_T9.Q; 

(** 27: Engine stop in manuel mode *)
	OUT_OP.bEng_Stop_Man	:=	(OUT_OP.bEng_Rel AND bOMSS_MAN  AND bStop)	
							OR	(OUT_OP.bEng_Rel AND bOMSS_MAN  AND OUT_OP.bEng_Bloc)
							OR	(OUT_OP.bEng_Rel AND bOMSS_MAN  AND NOT bEng_StaSpdExc AND IN_OP.bMaxPreLubeTime)
							OR	(OUT_OP.bEng_Rel AND bOMSS_AUTO AND IN_OP.bN_EngStartDrop)
							OR	(OUT_OP.bEng_Rel AND bIgn_DemTemp AND OUT_OP.bEng_Stop_Man);						//latch until ignition demand off

(** 28: Demand Ignition *)				
	xTON_T_Z_AUS(IN := IN_OP.bMsg1026, PT := T#10s);

	bIgn_Dem[0]	:=	NOT IN_OP.bMsg1022 OR IN_OP.bIgn2_Sel;							(* A1022 - overspeed (relay)				*)
	bIgn_Dem[1]	:=	NOT bGnlTrip1 OR IN_OP.bIgn2_Sel;								(* Trip1									*)
	bIgn_Dem[2]	:=	NOT xTON_T_Z_AUS.Q;												(* A1026 - Shutdown failure, 10s delayed	*)
	bIgn_Dem[3]	:=	IN_OP.bRel_IgnOn OR bEng_StaSpdExc;								(* Release ignition from starter (AG)		*)
	bIgn_Dem[4]	:=	NOT IN_OP.bN2_ScavCoStarterOn OR NOT IN_OP.bRel_ScavN2;			(* N2 scavanging in progress				*)
	bIgn_Dem[5]	:=	NOT IN_OP.bIgnDeflPrct_Off;										(* Deflagration protection					*)

	bIgn_DemTemp	:=	AND_Array(ADR(bIgn_Dem),5) OR ((IN_OP.b_ST_DemIgn OR IN_OP.rN_EngAct <> 0) AND IN_OP.bSelfTestRunning);
	MM2VIS.bIgn_Dem	:=	bIgn_Dem;
	MM2VIS.bIgn_Dem_Show	:=	TRUE;

	(** 28.1: Demand Ignition off is delayed, only in case of priority 1 trip it is not delayed *)
	IF IN_OP.tAB2OP.bGnlTrip1 THEN						
		OUT_OP.tIgn_Dem.Do := bIgn_DemTemp;
		xTOFIgn_Dem(IN:= bIgn_DemTemp);
	ELSIF NOT IN_OP.tAB2OP.bGnlTrip1 THEN
		IF bEng_StaSpdExc THEN
			xTOFIgn_Dem(IN:= bIgn_DemTemp, PT:= Ign_Dem_DelayTime);
		ELSE
			xTOFIgn_Dem(IN:= bIgn_DemTemp, PT:= Ign_Dem_DelayTime + Ign_Dem_DelayTime2);
		END_IF;
		OUT_OP.tIgn_Dem.Do := xTOFIgn_Dem.Q;
	END_IF;
	OUT_OP.bIgn_Dem	:=	OUT_OP.tIgn_Dem.Do;

(** 29: Demand gas valves *)
	(** 29.1: early opening of gas valves *)	
	IF xEngType.Type9 THEN
		xGR_MAXR_OpenGV.Gw	:=	60;
		xTP_OpenGV.PT		:=	T#9s800ms;		(* Type 9 engine needs approx. 10 seconds for the ignition unit to be ready *)
	ELSE
		xGR_MAXR_OpenGV.Gw	:=	80;
		xTP_OpenGV.PT		:=	T#4s800ms;	(* Other engines need approx. 6 seconds for the ignition unit to be ready *)
    END_IF;
	xGR_MAXR_OpenGV(In := IN_OP.rN_EngAct, Hy := 10);
	xTP_OpenGV(IN:= xGR_MAXR_OpenGV.Q AND IN_OP.bEng_Start AND NOT Para.bGlowIgnPrevActive AND NOT Para.bDeAct_EarlyGV_opening AND (IN_OP.iStartCount = 1));
				
	(* 29.2: Release of gas valves *)
	OUT_OP.bGV_Rel :=		NOT IN_OP.bMsg1031
							AND NOT IN_OP.bMsg1054
							AND NOT IN_OP.bMsg1022
							AND NOT IN_OP.bMsg1026
							AND NOT bGnlTrip1;
	
	(* 29.3: Gas valves open *)	
	bGV_Open[0] :=	OUT_OP.bEng_Rel OR (bGnlTrip3 AND (bOMSS_AUTO OR bOMSS_TEST));
	bGV_Open[1] :=	bIgn_DemTemp;
	bGV_Open[2] :=	IN_OP.bIgn_Run OR xTP_OpenGV.Q;
	bGV_Open[3] :=	NOT xOpMode.Stop;
	bGV_Open[4] :=	NOT OUT_OP.bEng_Stop_Man;
	bGV_Open[5] :=	OUT_OP.bGV_Rel;
	bGV_Open[6] :=	((	IN_OP.tN2_GV1_Closed.Di AND (IN_OP.tN2_GV2_Closed.Di OR NOT Para.bSel_TwoN2Valves) AND IN_OP.tScavVaClosed.Di) OR NOT IN_OP.bRel_ScavN2 OR IN_OP.bGV_On);
	bGV_Open[7] :=	NOT IN_OP.bGV_Start_ScaveBlock;	 (*new:	block gas valves from startup procedure	for scavening start *)

	OUT_OP.bGV_Open_Opstate	:=	AND_Array(ADR(bGV_Open),7);
	MM2VIS.bGV_Open			:=	bGV_Open;
	MM2VIS.bGV_Open_Show	:=	bIgn_DemTemp;

(** 30: Engine demand *)
	OUT_OP.bEng_Dem		:=	OUT_OP.bEng_Dem_Man
						OR	OUT_OP.bEng_Dem_Aut
						OR	OUT_OP.bEng_SUpE;

(** 31: RPS Demand *)
	OUT_OP.bEng_RPSDem	:=	OUT_OP.bEng_Dem
						AND NOT IN_OP.bGT_DemRelGasTypSwh
						AND (NOT bOMSS_TEST OR (bOMSS_TEST AND IN_OP.tReq_Test.Di) OR OUT_OP.bEng_Dem_EPS);

(** 32: Engine Cool down run *)
	ZM_IN_bEng_CDR	:=	OUT_OP.tEng_Run.Do
					AND ( 	((bOMSS_AUTO OR bOMSS_TEST) AND IN_OP.tGCB_On.Di)
						OR	OUT_OP.bEng_Dem_Aut
						);
	
	ZM_RS_bEng_CDR	:=	(NOT bOMSS_AUTO AND NOT bOMSS_TEST)
					OR	bGnlTrip1
					OR	bGnlTrip2
					OR 	OUT_OP.bEng_Bloc;

	IF xEngType.Type6 THEN
		xTOF_R_bEng_CDR(IN := ZM_IN_bEng_CDR, PT := 1000, RS := ZM_RS_bEng_CDR);  (* PT = 1000 -> Delaytime in 10ms steps -> 10s *)
	ELSIF xEngType.Type9 THEN
		xTOF_R_bEng_CDR(IN := ZM_IN_bEng_CDR, PT := 0, RS := ZM_RS_bEng_CDR);  (* PT = 0 -> Delaytime in 10ms steps -> 0s *)
	ELSE
		xTOF_R_bEng_CDR(IN := ZM_IN_bEng_CDR, PT := 6000, RS := ZM_RS_bEng_CDR);  (* PT = 6000 -> Delaytime in 10ms steps -> 6000s *)
	END_IF;

	OUT_OP.bEng_CDR := xTOF_R_bEng_CDR.Q;
	
(** 33: Engine run *)
	xGR_MAXR_bs_15s_rpm_hi(In := IN_OP.rN_EngAct, Gw := Para.rN_BS_Acc_LimHi, Hy := 10);
	bs_15s_rpm_hi := 
					xGR_MAXR_bs_15s_rpm_hi.Q
				AND IN_OP.tPB2MM.bParaSetupOk;
	bs_15s_rel_oper := 
					Para.bBS_Acc_Active
				AND OUT_OP.bEng_Dem_EPS
				AND OUT_OP.bEng_MonOff
				AND (bs_15s_rpm_hi OR bs_15s_rel_oper);	
	
	IF (xOpMode.Idle OR xOpMode.Island OR xOpMode.NetP) AND NOT bN_Eng_Run THEN
		bN_Eng_Run	:= TRUE;
	ELSIF xOpMode.Stop AND bN_Eng_Run THEN
		bN_Eng_Run	:= FALSE;
	END_IF;

	OUT_OP.tEng_Run.Do :=
					OUT_OP.tOMSS_MAT.Do
				AND IN_OP.bGV_On
				AND ((bs_15s_rel_oper OR NOT OUT_OP.bEng_MonOff) OR bN_Eng_Run)	//Änderung >= rN_Start_Trig für Faststart schnellere SY
				AND (OUT_OP.bEng_CDR OR OUT_OP.bEng_Dem_Aut OR (bOMSS_MAN  AND OUT_OP.bEng_Dem_Man));

(** 34: Restart blocking *)
	xTON_RUN(IN := TRUE, PT := T#30s); (* instead RUN bit *)
	ZM_bEng_RSBoc	:=	(NOT OUT_OP.tEng_Run.Do AND xTON_RUN.Q)
					OR	EDGENEG(OUT_OP.tEng_Run.Do);

	xTP_bEng_RSBoc(IN := ZM_bEng_RSBoc, PT := T#2m);	// sinnvoller vieleicht nur auf EDGENEG gehen und das andere vergessen, dann wär es nur mehr bei echten abstellungen... nicht bei kaltstarts
	OUT_OP.bEng_RSBoc := xTP_bEng_RSBoc.Q;

(** 35: Gastypes *)
	OUT_OP.bGasTyp1_Act :=
						NOT IN_OP.bGT_Ipol12Active
					AND	( 
							(IN_OP.bSelGasTyp1 AND (IN_OP.bLeanox_Man OR (NOT IN_OP.bGT_TypSwhActiveHalt AND NOT IN_OP.bGT_TypSwhActive AND NOT IN_OP.tSelGasTyp.Di)))
						OR	(
								((IN_OP.bGT_TypSwhActiveHalt AND NOT IN_OP.bGT2_Select) OR (IN_OP.bGT_TypSwhActive AND IN_OP.bGT_SelGas1) OR (IN_OP.tSelGasTyp.Di AND NOT IN_OP.tSelGasTyp2.Di AND NOT IN_OP.tSelGasTyp3.Di AND NOT IN_OP.tSelGasTyp4.Di))
							AND (NOT IN_OP.bLeanox_Man OR IN_OP.bSelGasTypAut)
							)
						);
						
	OUT_OP.bGasTyp2_Act :=
						(NOT IN_OP.bGT_Ipol12Active AND IN_OP.bSelGasTyp2 AND (IN_OP.bLeanox_Man OR (NOT IN_OP.bGT_TypSwhActiveHalt AND NOT IN_OP.bGT_TypSwhActive AND NOT IN_OP.tSelGasTyp.Di)))
					OR 	(
							((IN_OP.bGT_TypSwhActive AND IN_OP.bGT_SelGas2) OR (IN_OP.tSelGasTyp.Di AND IN_OP.tSelGasTyp2.Di AND NOT IN_OP.tSelGasTyp3.Di AND NOT IN_OP.tSelGasTyp4.Di))
						AND NOT IN_OP.bLeanox_Man
						);
						
	OUT_OP.bGasTyp3_Act :=
						(IN_OP.bSelGasTyp3 AND (IN_OP.bLeanox_Man OR (NOT IN_OP.bGT_TypSwhActiveHalt AND NOT IN_OP.bGT_TypSwhActive AND NOT IN_OP.tSelGasTyp.Di)))
					OR	(
							((IN_OP.bGT_TypSwhActiveHalt AND IN_OP.bGT2_Select) OR (IN_OP.bGT_TypSwhActive AND IN_OP.bGT_SelGas3) OR (IN_OP.tSelGasTyp.Di AND IN_OP.tSelGasTyp3.Di AND NOT IN_OP.tSelGasTyp4.Di))
						AND (NOT IN_OP.bLeanox_Man OR IN_OP.bSelGasTypAut)
						);
						
	OUT_OP.bGasTyp4_Act :=
						(IN_OP.bSelGasTyp4 AND (IN_OP.bLeanox_Man OR (NOT IN_OP.bGT_TypSwhActiveHalt AND NOT IN_OP.bGT_TypSwhActive AND NOT IN_OP.tSelGasTyp.Di)))
					OR	(
							((IN_OP.bGT_TypSwhActive AND IN_OP.bGT_SelGas4) OR (IN_OP.tSelGasTyp.Di AND IN_OP.tSelGasTyp4.Di))
						AND NOT IN_OP.bLeanox_Man
						);
	
	OUT_OP.bGasTypMix1_2_Act :=	IN_OP.bGT_Ipol12Active;

(** 36: start speed exceeded *)
	xGR_MAXR_Eng_StaSpdExc(In := IN_OP.rN_EngAct, Gw := Para.rN_EngStart_LimHi, Hy := Para.rN_EngStart_HyHi);
	xTOF_Eng_StaSpdExc(IN := xGR_MAXR_Eng_StaSpdExc.Q AND IN_OP.tPB2MM.bParaSetupOk, PT := T#10s);
	bEng_StaSpdExc := xTOF_Eng_StaSpdExc.Q;

(** 37: various demands of auxiliaries *)
	xTOF_Eng_Aux_Dem(IN := bEng_StaSpdExc OR OUT_OP.bEng_Aux_Dem, PT := T#300s);
	OUT_OP.bEng_Aux_Dem_TOF := xTOF_Eng_Aux_Dem.Q;
	OUT_OP.tEng_Aux_Dem_CDR.Do := OUT_OP.bEng_Aux_Dem_TOF AND (bEng_StaSpdExc OR (OUT_OP.tOMSS_MAT.Do AND NOT IN_OP.bMsg1031 AND NOT IN_OP.bMsg1054));
	OUT_OP.bEng_Aux_Dem_CDR	:= OUT_OP.tEng_Aux_Dem_CDR2.Do := OUT_OP.tEng_Aux_Dem_CDR3.Do := OUT_OP.tEng_Aux_Dem_CDR.Do;

(** 38: synchronization / load release *)
	xTOF_SoftShutdown(IN := IN_OP.bGV_On AND NOT bGnlTrip2, PT := T#1s);
	xGR_MINR_P_Lo(In:= OUT_OP.rP_Act_Norm, Gw:= Para.rP_LimLo, Hy:= Para.rP_HyLo);
	bP_Lo  := IN_OP.tPB2MM.bParaSetupOk AND xGR_MINR_P_Lo.Q;


	bSync_Rel[0]	:=	OUT_OP.tOMSS_MAT.Do;
	bSync_Rel[1]	:=	((IN_OP.bT_EOP_RelLoad OR NOT xEngType.Type9) AND IN_OP.bT_ECW_RelLoad AND NOT IN_OP.bT_ECW_Hi)
					OR	bOMSS_MAN 
					OR	OUT_OP.bEng_Dem_EPS 
					OR	IN_OP.tGCB_On.Di;
	bSync_Rel[2]	:=	OUT_OP.tEng_Run.Do 
					OR 	(bGnlTrip2 AND xTOF_SoftShutdown.Q AND bOMSS_AUTO) 
					OR 	(OUT_OP.bEng_SUpE  AND NOT bGnlTrip2 AND NOT bGnlTrip3);
	bSync_Rel[3]	:=	xTOF_SoftShutdown.Q OR	OUT_OP.bEng_SUpE;
	bSync_Rel[4]	:=	NOT bP_Lo OR NOT bGnlTrip2;
	bSync_Rel[5]	:=	NOT bGnlTrip1;
	bSync_Rel[6]	:=	NOT bOMSS_TEST
					OR 	(bOMSS_TEST AND IN_OP.tReq_Test.Di)
					OR 	OUT_OP.bEng_Dem_EPS
					OR 	IN_OP.tGCB_On.Di;
	bSync_Rel[7]	:=	NOT IN_OP.bMsg1218;
	bSync_Rel[8]	:=	IN_OP.tGV_Rel.Do;
	bSync_Rel[9]	:=	IN_OP.bsy_lfg_SG;
	bSync_Rel[10]	:=	NOT IN_OP.bBloc_SY_FS;	
	bSync_Rel[11]	:=	NOT IN_OP.bBloc_SY_ProtTest;
	bSync_Rel[12]	:=	NOT IN_OP.bBloc_SY_Rel_Cust;
	bSync_Rel[13]	:=	TRUE;
	bSync_Rel[14]	:=	TRUE;
	bSync_Rel[15]	:=	TRUE;

	OUT_OP.tRel_Sync_Load.Do	:=	AND_Array(ADR(bSync_Rel),15);					(* 1 = sync is released *)
	OUT_OP.bRel_Sync_Load		:=	OUT_OP.tRel_Sync_Load.Do;
	MM2VIS.bSync_Rel			:=	bSync_Rel;						(* Array to VIS *)
	MM2VIS.bSync_Rel_Show		:=	(iIdx_Eng_State = 11) OR (iIdx_Eng_State = 12) OR (iIdx_Eng_State = 15) OR (iIdx_Eng_State = 16);

(** 39: State Machine *)
		(* MODULE BLOCKED *)
	IF 			OUT_OP.bEng_Bloc 
		AND 	NOT bEng_StaSpdExc_old 			THEN
		iIdx_Eng_State := 19; 							
	
		(* ISLAND MODE - POWER MODE *)
	ELSIF 			IN_OP.tGCB_On.Di 
		AND 		OUT_OP.tEng_Run.Do 
		AND 	NOT IN_OP.tMCB_On.Di 
		AND 	NOT IN_OP.bMCB_DemSy 
		AND 		(IN_OP.bReq_PowMod OR IN_OP.bReq_PowMod_Ext)		THEN		
		iIdx_Eng_State := 27; 
	
		(* ISLAND MODE - SPEED MODE *)
	ELSIF 			IN_OP.tGCB_On.Di 
		AND 		OUT_OP.tEng_Run.Do 
		AND 	NOT	IN_OP.tMCB_On.Di 
		AND 	NOT IN_OP.bMCB_DemSy 
		AND 	NOT (IN_OP.bReq_PowMod OR IN_OP.bReq_PowMod_Ext)  	THEN		
		iIdx_Eng_State := 26;	
	
		(* EMERGENCY OPERATION *)		(* can never be used because AND FALSE !!! *)
	ELSIF 			IN_OP.tGCB_On.Di 
		AND 		OUT_OP.tEng_Run.Do 
		AND 		OUT_OP.bEng_Dem_EPS 
		AND 	NOT IN_OP.bMCB_DemSy 
		AND 		FALSE  						THEN
		iIdx_Eng_State := 18;	
	
		(* PEAK LOAD OPERATION *)
	ELSIF 			IN_OP.tGCB_On.Di 
		AND 		OUT_OP.tEng_Run.Do 
		AND 	NOT	IN_OP.bMCB_DemSy 
		AND 		IN_OP.tReq_PeakLoad.Di 
		AND 		bOMSS_AUTO THEN
		iIdx_Eng_State := 23;	
	
		(* GRID MODE *)
	ELSIF 			IN_OP.tGCB_On.Di 
		AND 		OUT_OP.tEng_Run.Do 
		AND 	NOT IN_OP.bMCB_DemSy 			THEN
		iIdx_Eng_State := 17;
		
		(* GRID MODE - WARM UP OPERATION *)
	ELSIF 			IN_OP.tGCB_On.Di 
		AND 		OUT_OP.tEng_Run.Do 
		AND 	NOT IN_OP.bMCB_DemSy 			
		AND			bWarmUpOperation	THEN
		iIdx_Eng_State := 37;
	
		(* BACK SYNCHRONIZATION *)
	ELSIF 			IN_OP.bMCB_DemSy 
		AND 	NOT IN_OP.bBB_dead 		THEN
		iIdx_Eng_State := 16;	
	
		(* SYNCHRONIZATION *)
	ELSIF 			IN_OP.bGCB_DemSy 
		AND 	NOT IN_OP.bBB_dead 		THEN
		iIdx_Eng_State := 15;	
	
		(* AFTER-COOLING *)
	ELSIF 			OUT_OP.bEng_CDR 
		AND 	NOT OUT_OP.bEng_Dem_Man 
		AND 	NOT OUT_OP.bEng_Dem_Aut 
		AND 		OUT_OP.tEng_Run.Do 	THEN
		iIdx_Eng_State := 14;	
	
		(* SHUT DOWN PHASE *)
	ELSIF 		(OUT_OP.bEng_Dem_Bloc OR OUT_OP.bEng_RSBoc OR IN_OP.bJmpPLTime) 
		AND 	NOT OUT_OP.bEng_Dem_Man 
		AND 	NOT OUT_OP.bEng_Dem_Aut
		AND  	NOT IN_OP.bSimWinMOD_FastStart		(* WinMOD *)
		AND 	NOT OUT_OP.tEng_Run.Do 	THEN
		iIdx_Eng_State := 13;	(* ABSTELLPHASE *)
	
		(* IDLE MODE / SY-LFG *)
	ELSIF 			OUT_OP.tRel_Sync_Load.Do 
		AND 		OUT_OP.tEng_Run.Do 	THEN
		iIdx_Eng_State := 12;	
	
		(* TEST *)
	ELSIF 			bOMSS_TEST 
		AND 		OUT_OP.tEng_Run.Do 	THEN
		iIdx_Eng_State := 21;	
	
		(* IDLE MODE / NO SY-LFG *)
	ELSIF 			OUT_OP.tEng_Run.Do 	THEN
		iIdx_Eng_State := 11;	

		(* STANDBY TIME - AUTOMATIC START *)				(* Rev.4.03: new State 32: waiting for next automatic Start (for new BR4 start procedure)*)
	ELSIF 			(xTON_Eng_SU_Aut.Q OR (IN_OP.bSt_RelAuxOff_STT_op AND xEngType.Type6))   	 //	=delayed OUT_OP.bEng_SU_Aut  (Rev.4.04)
		AND 		OUT_OP.bEng_Dem_Aut 	
		AND 	NOT IN_OP.bEng_Start 	THEN
		iIdx_Eng_State := 32;

		(* prolonged normal start message *)				(* Rev.4.04: new State 33: demand automatic Start (for new BR4 start procedure)*)
	ELSIF 			OUT_OP.bEng_SU_Aut 	
		AND 		OUT_OP.bEng_Dem_Aut 	
		AND 	NOT IN_OP.bEng_Start 	THEN
		iIdx_Eng_State := 8;	(* Vorablösung: Wiederverwendung von 8=ENGINE START statt dem neuem iIdx_Eng_State := 33  prolonged normal start message;
		
		(* ENGINE START-UP *)
	ELSIF 			OUT_OP.bEng_Rel 
		AND 	NOT OUT_OP.tEng_Run.Do 
		AND 		IN_OP.bRelEngOp_Aux 
		AND 	   (OUT_OP.bEng_Dem_Man OR OUT_OP.bEng_Dem_Aut) 
		AND 		bEng_StaSpdExc 
		AND 		IN_OP.bGV_On 		THEN
		iIdx_Eng_State := 10;	
	
		(* AUTOMATIC START *)
	ELSIF 			OUT_OP.bEng_SU_Aut 	THEN
		iIdx_Eng_State := 9;	
	
		(* ENGINE START *)
	ELSIF 			OUT_OP.bEng_Rel_SU
					AND NOT (OUT_OP.bEng_Dem_Man AND IN_OP.bSt_RelAuxOff_STT_op AND xEngType.Type6) 	THEN
		iIdx_Eng_State := 8;
		
	
		(* STANDBY TIME - MANUAL START *)
	ELSIF 			(OUT_OP.bEng_SU_Man
		AND 		OUT_OP.bEng_Dem_Man 	
		AND 	NOT OUT_OP.bEng_Rel_SU) OR
					(OUT_OP.bEng_Dem_Man AND IN_OP.bSt_RelAuxOff_STT_op AND xEngType.Type6) 	THEN
		iIdx_Eng_State := 7;
		
		(* PRELIMINARY PHASE *)
	ELSIF 			((OUT_OP.bEng_Aux_Dem AND OUT_OP.tEng_Aux_Dem_CDR.Do) OR IN_OP.bDemScavVa) 
		AND 		(OUT_OP.bEng_Dem_Man OR OUT_OP.bEng_Dem_Aut) 
		THEN
		iIdx_Eng_State := 6;	
		
		(* TEST FINISHED *)
	ELSIF 			bOMSS_TEST 
		AND 		OUT_OP.bEng_Rel 	THEN
		iIdx_Eng_State := 22;	
		
		(* READY FOR AUTOMATIC VERY FAST START *)
	ELSIF 			OUT_OP.bEng_Rdy_Aut AND IN_OP.bReady4VeryFastStart	THEN
		iIdx_Eng_State := 33;
	
		(* READY FOR AUTOMATIC FAST START *)
	ELSIF 			OUT_OP.bEng_Rdy_Aut AND IN_OP.bReady4FastStart	THEN
		iIdx_Eng_State := 34;
	
		(* READY FOR AUTOMATIC START - VERY FAST START PREPERATION RUNNING *)
	ELSIF 			OUT_OP.bEng_Rdy_Aut AND IN_OP.bVeryFastStart_Prep	THEN
		iIdx_Eng_State := 35;
	
		(* READY FOR AUTOMATIC START - FAST START PREPERATION RUNNING *)
	ELSIF 			OUT_OP.bEng_Rdy_Aut AND IN_OP.bFastStart_Prep	THEN
		iIdx_Eng_State := 36;
	
		(* READY FOR AUTOMATIC FAST *)
	ELSIF 			OUT_OP.bEng_Rdy_Aut	THEN
		iIdx_Eng_State := 5;
		
		(* READY FOR MANUAL START *)
	ELSIF 			OUT_OP.bEng_Rdy_Man THEN
		iIdx_Eng_State := 4;
		
		(* OPERATION MODE SELECTOR SWITCH - TEST *)
	ELSIF 			bOMSS_TEST 		THEN
		iIdx_Eng_State := 20;
		
		(* OPERATION MODE SELECTOR SWITCH - AUTOMATIC *)
	ELSIF 			bOMSS_AUTO 		THEN
		iIdx_Eng_State := 3;
		
		(* OPERATION MODE SELECTOR SWITCH - MANUAL *)
	ELSIF 			bOMSS_MAN 		THEN
		iIdx_Eng_State := 2;
		
		(* OPERATION MODE SELECTOR SWITCH - OFF *)
	ELSIF 		NOT OUT_OP.tOMSS_MAT.Do		THEN
		iIdx_Eng_State := 1;	
		
	END_IF;
	
(** 40: Engine operation hour counter *)
	(*This counter may be resetted in order to indicate an engine change*)
	xBH_OpHour(enable := OUT_OP.tEng_Run.Do, BH_adr := ADR(OpHour_Imp.tick));
	xTOF_OpHour(IN := xBH_OpHour.BH_Imp, PT := T#10s); 
	OUT_OP.tImp_OpHour.Do :=  xTOF_OpHour.Q;
	
	IF EDGEPOS(IN_OP.iCnt_OpHours_Set > 0) AND bOpt_AllowCounterCorrection THEN		(*new in V4.13*)
			VIS2MM.iCnt_OpHours := IN_OP.iCnt_OpHours_Set;							(* Set counter intentionaly to database backup value from ParaBase module*)
	END_IF

		
	IF EDGEPOS(OUT_OP.tImp_OpHour.Do) THEN
		VIS2MM.iCnt_OpHours := DINT_INC_CNT(VIS2MM.iCnt_OpHours);						(* increase counter, check limits to +/- 1.000.000.000 *)
	END_IF
	OUT_OP.iCnt_OpHours := VIS2MM.iCnt_OpHours;
	
(** 41: Unit operation hour counter *)
	xBH_UnitOpHour(enable := OUT_OP.tEng_Run.Do, BH_adr := ADR(UnitOpHour_Imp.tick));
	xTOF_UnitOpHour(IN := xBH_UnitOpHour.BH_Imp, PT := T#10s); 
	OUT_OP.bImp_UnitOpHour :=  xTOF_UnitOpHour.Q;
			
	IF EDGEPOS(IN_OP.iCnt_UnitOpHours_Set > 0) AND bOpt_AllowCounterCorrection THEN		(*new in V4.13*)
			VIS2MM.iCnt_UnitOpHours := IN_OP.iCnt_UnitOpHours_Set;						(* Set counter intentionaly to database backup value from ParaBase module*)
	END_IF
	
	IF EDGEPOS(OUT_OP.bImp_UnitOpHour) THEN
		VIS2MM.iCnt_UnitOpHours := DINT_INC_CNT(VIS2MM.iCnt_UnitOpHours);				(* increase counter, check limits to +/- 1.000.000.000 *)
	END_IF
	OUT_OP.iCnt_UnitOpHours := VIS2MM.iCnt_UnitOpHours;

(** 42: demand hour counter *)
	xBH_DemHour(enable := IN_OP.tDemEngOpExt.Di, BH_adr := ADR(DemHour_Imp.tick));
	xTOF_DemHour(IN := xBH_DemHour.BH_Imp, PT := T#10s); 
	IF EDGEPOS(xTOF_DemHour.Q) THEN	(* if a demanded hour is finished *)
		VIS2MM.iCnt_DemHours := (VIS2MM.iCnt_DemHours + 1) MOD 1000000000;	(* increase counter, check limits *)
	END_IF;

(** 43: net parallel operation hour counter *)
	xBH_NetPHour(enable := xOpMode.NetP, BH_adr := ADR(NetPHour_Imp.tick));
	xTOF_NetPHour(IN := xBH_NetPHour.BH_Imp, PT := T#10s); 
	IF EDGEPOS(xTOF_NetPHour.Q) THEN	(* if a mains operation hour is finished *)
		VIS2MM.iCnt_NetPHours := (VIS2MM.iCnt_NetPHours + 1) MOD 1000000000;	(* increase counter, check limits *)
	END_IF;

(** 44: island operation hour counter *)
	xBH_IslandHour(enable := xOpMode.Island, BH_adr := ADR(IslandHour_Imp.tick));
	xTOF_IslandHour(IN := xBH_IslandHour.BH_Imp, PT := T#10s); 
	IF EDGEPOS(xTOF_IslandHour.Q) THEN	(* if an island operation hour is finished *)
		VIS2MM.iCnt_IslandHours := (VIS2MM.iCnt_IslandHours + 1) MOD 1000000000;	(* increase counter, check limits *)
	END_IF;

(** 45: start counter *)
	IF EDGEPOS(IN_OP.iCnt_Starts_Set > 0) AND bOpt_AllowCounterCorrection THEN		(*new in V4.13*)
			VIS2MM.iCnt_Starts := IN_OP.iCnt_Starts_Set;					(* Set counter intentionaly to database backup value from ParaBase module*)
	END_IF	
	IF EDGEPOS(IN_OP.iCnt_FastStarts_Set > 0) AND bOpt_AllowCounterCorrection THEN	(*new in V4.13*)
			VIS2MM.iCnt_FastStarts := IN_OP.iCnt_FastStarts_Set;			(* Set counter intentionaly to database backup value from ParaBase module*)
	END_IF	
				
	IF EDGEPOS(OUT_OP.bImp_Start) THEN
		VIS2MM.iCnt_Starts := DINT_INC_CNT(VIS2MM.iCnt_Starts);					(* increase counter, check limits to +/- 1.000.000.000 *)
		IF (IN_OP.iFastStart = 1) OR (IN_OP.iFastStart = 2) THEN
			VIS2MM.iCnt_FastStarts := DINT_INC_CNT(VIS2MM.iCnt_FastStarts);			(* increase counter, check limits to +/- 1.000.000.000 *)
		END_IF;
	END_IF;
	OUT_OP.iCnt_Starts 		:= VIS2MM.iCnt_Starts;
	OUT_OP.iCnt_FastStarts 	:= VIS2MM.iCnt_FastStarts;

(** 46: Low load operation counter *)
	xTON_OpLowLoadAct(IN := IN_OP.tGCB_On.Di, PT := T#5m);
 	bOpLowLoad := (OUT_OP.rP_Act_Norm_Filt < (Para.rP_Set_Min_Norm - 0.01)) AND xTON_OpLowLoadAct.Q AND M_ANF AND NOT IN_OP.bServiceMode;
	IF NOT bOpLowLoad THEN
		OpLowLoad_Imp.second := 0;
	END_IF;
	xBH_OpLowLoad(enable := bOpLowLoad, BH_adr := ADR(OpLowLoad_Imp.tick));
	xTOF_OpLowLoad(IN := xBH_OpLowLoad.BM_Imp, PT := T#10s);
	IF EDGEPOS(xTOF_OpLowLoad.Q) THEN
		VIS2MM.iCnt_OpLowLoad := DINT_INC_CNT(VIS2MM.iCnt_OpLowLoad);			(* increase counter, check limits to +/- 1.000.000.000 *)
	END_IF;

(** 47: logic war alarm 1108 and warning 2097 *)
	xTON_Rel_P_DevHi(IN:= OUT_OP.tEng_Run.Do AND bOMSS_AUTO AND IN_OP.tGCB_On.Di AND NOT OUT_OP.bEng_Dem_EPS, PT:= T#1200s);
	T99 := xTON_Rel_P_DevHi.Q;
	xGR_MAXR_P_Dev(In:= OUT_OP.rP_Set_Norm - OUT_OP.rP_Act_Norm_Filt, Gw:= Para.rP_Dev_LimHi, Hy:= 0.0);
	bP_DevHi := xGR_MAXR_P_Dev.Q AND IN_OP.tPB2MM.bParaSetupOk;
	xTON_P_DevHi(IN:= OUT_OP.bP_Rmp_Frz OR bP_DevHi, PT:= Para.tiP_Dev_LimHi_Delay);
	AN_PDIFF := xTON_P_DevHi.Q;
	
	UW_PDIFF_A := NOT xEngType.Type6 AND NOT xEngType.Type4 AND NOT Para.bEngTyp3_Prelub_Active;
	
(** 48: add submode to opstate status *)
	OUT_OP.iSt_OpMode := OUT_OP.iSt_OpMode OR 256 * iIdx_Eng_State;
	
(** 49: information operation mode for VISU *)
	xOpMode();
	iSt_OpMode_Main := xOpMode.iMainMode;
	iSt_OpMode_Sub := xOpMode.iSubMode;
	iSt_OpMode_Deg := xOpMode.iDegMode;
	
	bEng_StaSpdExc_old := bEng_StaSpdExc;
	
(** 50: new Out interfaces 4.7 *)
	(** 50.1: execute black out start, signal for customer *)
	IF EDGEPOS(OUT_OP.bEng_Dem_EPS) THEN
		OUT_OP.tExecute_BS.Do	:=	(NOT IN_OP.tAuxV_Eng_ok.Di AND IN_OP.tAuxV_Eng_ok.GoodQual)
								OR	(NOT IN_OP.tAuxV_Aux_ok.Di AND IN_OP.tAuxV_Aux_ok.GoodQual)
								OR	(NOT IN_OP.tAuxV_ModIf_ok.Di AND IN_OP.tAuxV_ModIf_ok.GoodQual)
								OR	(NOT IN_OP.tAuxV_Supply_Ok.Di AND IN_OP.tAuxV_Supply_Ok.GoodQual);
	END_IF
	IF xOpMode.Island OR xOpMode.NetP THEN
		OUT_OP.tExecute_BS.Do	:=	FALSE;
	END_IF

	OUT_OP.iIdx_Eng_State	:=	iIdx_Eng_State;
	
END_PROGRAM



