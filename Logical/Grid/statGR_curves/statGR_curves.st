	(*******************************************************************************
AGGR: charactaristic curves for static GridCode (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021

- Generelle Freigabebedingungen stat. GC Funktionen
- einlesen der Kennlinien aus den jeweiligen Datenobjekten
 o cos(phi) = f(P)
 o PFC/RMC
 o Q = f(U)
 o cos(phi) = f(U)
 
Customized modifications: -
------------------------
 
History:
-------
V3.40.0	14-02-2013	Perktold,  	generated
V4.00.0 22-08-2013  Maxhera,  	implementation of the module for modular software
V4.02.0	10-06-2015	Caks,		added simulation test cases
		15.06.2015	Caks,		changed names
V4.03.0 24-11-2015	Perktold,	iPFCRMCmax_Cur auf 4 geändert (von 2), PFC Testmode integriert
V4.04.0 02-11-2016  Gwiggner,   add frequency control function
V4.04.1	09-11-2016	Perktold, 	bugfix PF(U) function - reading out of library + Data to HMI
V4.05.0 07-12-2017  Farre,		test FUNCTION Q(U) & PF(U), mofifications curve FOR PF(U), Q(U), PF(P), addition Q(P) 
					Farre,		modification PFC to new LFSMO and LFSMU, Q limitation based on Q(U), Point of Control & Point of Ref
V4.05.1	15-03-2018	Farre,		correction voltage reference shift
V4.07.0 25-03-2019  Zuschnig,	calculation of points for FSM/LFSM picture
		09.10.2019	lettenb.	div.by zero bugfix, bu01
V4.09.0 25-03-2019  lettenb.	entry/exit LFSM-mode with time delay(parameter) for power set
		18.12.2019	lettenb.	iCnt_QU_PFUSimuMax: 5 -> 15min., longer time for test function
		03.01.2020	lettenb.	Q Limitation based Q(U) curve tQLim_Points[0].x/y substituted by Para.rQLimU_GrC_UpointX/Y[0], separate QLim curve added
		25.02.2020	lettenb.	MM2VIS.rQ_Ux/y[i]: write vis data items from tQLim_Points[0] only in case of PF_set or Q_set
V4.11.0	25.05.2021	lettenb.	rDeltaF_LFSM calc.modif., to avoid calc.error caused by REAL
       	26.05.2021	lettenb.	REAL compare operations changed to INT, for proper function at deadband borders, bugfix
								bPFC_TestEnable: avoid LFSM_TestStop by autoreset iPassLevel, bugfix
V4.13.0 02.08.2023	Farre,		FSM delta P limitation: adapted VIS FSM Curve
		20.11.2023	Farre,		Replaced Para.rP_Set_Min_Norm by IN_GR.rP_Set_Min_Norm interface coming from OP. (2023-168)
		30.11.2023	Goenczi		Add FSM test interfaces via BUS initiation
		20.12.2023	Farre,		issue 1350: visu LFSM curve with no static FSM deadband when Pset in FSM margin zone
V4.14.0	29.11.2024	Farre,		issue 1596: Q Limitation based Q(U) curve needs Voltage reference offset shift

Instructions for use:
--------------------
- 

Outstandings:
-------------

*******************************************************************************)
	
PROGRAM _INIT

	iPFP_GrC_SetCurOlV		:= 16#FFFF;		(* old power characteristics COS(phi)=f(P) curve value *)
	iPFCRMC_GrC_SetCurOlV	:= 16#FFFF;     (* old PFC/RMC curve value							   *)	
	iQU_GrC_SetCurOlV		:= 16#FFFF;  	(* old Q = f(U) curve value						   *)
	iPFU_GrC_SetCurOlV		:= 16#FFFF;		(* old PF= f(U) curve value							   *)
	iPFilt					:= 20;			(* filter constant for power						   *)
	iUFilt					:= 25;			(* filter constant for voltage						   *)
	rP_Time_Delay_Filt		:= 10.0;		(* Time constants, delay time. Units: Seconds 		   *)
	rP_Set_Val      		:= 100.;		(* Preset value for active power					   *)

	i_PFC_Test_var			:=	0;			(* deactivate simulation *)
	bLoad_Para				:=	FALSE;		(* initialize frequencies *)
	iCnt_Simu_Inc			:=	1;			(* set to 60: 15min --> 15s *)

END_PROGRAM

PROGRAM _CYCLIC
	(* call function for the state machine *)
	xOpMode(in 	:= IN_GR.iSt_OpMode);	
	bEZA_Cont	:=	FALSE;
	(* Begin Simulation PFC test cases *******************************************************************************)

	IF NOT bLoad_Para AND IN_GR.tPB2MM.bParaSetupOk THEN	(* load initial setting *)
		bLoad_Para			:=	TRUE;
		rF_PFC_Simu_Man_Act	:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		rF_PFC_Simu_Man_Ref	:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref;
	END_IF

	iCnt_Simu := iCnt_Simu + iCnt_Simu_Inc;		//interner zähler, z_wert = 1 (z.B. für simulation auf 60 erhöhen -> 15min Höcker werden 15s Höcker) 
	IF iCnt_Simu >= 600 THEN											
		iCnt_Simu_Min := iCnt_Simu_Min + 1;		//minutenzähler
		iCnt_Simu := 0;												
	END_IF;	

	IF i_PFC_Test_var = 1 OR i_PFC_Test_var = 3 THEN
		CASE iCnt_Simu_Min OF												
			0:			IF iCnt_Simu > 0 THEN 										
					rF_Simu_dlt := 0.2; 										
				END_IF;																		
			1..14:		rF_Simu_dlt 	:= 0.2;										
			15..29:		rF_Simu_dlt 	:= 0;											
			30..44:		rF_Simu_dlt 	:= 0.2;									
			45..59:		rF_Simu_dlt 	:= 0;										
			60..64:		rF_Simu_dlt 	:= 0.1;									
			65..74:		rF_Simu_dlt 	:= 0.2;								
			75..89:		rF_Simu_dlt 	:= 0;				
			90..104:	rF_Simu_dlt 	:= - 0.2;						
			105..119:	rF_Simu_dlt 	:= 0;										
			120..134:	rF_Simu_dlt 	:= - 0.2;											
			135..149:	rF_Simu_dlt 	:= 0;										
			150..154:	rF_Simu_dlt 	:= - 0.1;									
			155..164:	rF_Simu_dlt 	:= - 0.2;									
			165..179:	rF_Simu_dlt 	:= 0;										
			180:		i_PFC_Test_var 	:= 0;											
				iCnt_Simu 		:= 0;																
				iCnt_Simu_Min 	:= 0;																
		END_CASE;
	ELSE
		iCnt_Simu 		:=	0;
		iCnt_Simu_Min 	:=	0;
	END_IF
	//Testvariante	[0=kein Test / 1=AUTO Höcker über FrequenzSollwert / 2=MAN über FrequenzSollwert / 3=AUTO Höcker über FrequenzIstwert / 4=MAN über FrequenzIstwert]
	CASE i_PFC_Test_var OF
		1:	rF_Simu_Act		:=	IN_GR.tF_MMD_BusBar[1].Ai;		//Aktuelle Sammelschienen-Frequenz [Hz] 
			rF_Simu_Ref		:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_Simu_dlt;	//BezugsFrequenz / Nennfrequenz [Hz] 		- Simulierter Höckerverlauf

		2:	rF_Simu_Act		:=	IN_GR.tF_MMD_BusBar[1].Ai;		//Aktuelle Sammelschienen-Frequenz [Hz] 
		rF_Simu_Ref		:=	rF_PFC_Simu_Man_Ref;			//BezugsFrequenz / Nennfrequenz [Hz] 		- man. Test, über Verstellung

		3:	rF_Simu_Act  	:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref - rF_Simu_dlt;	//Aktuelle Frequenz [Hz] 					- Simulierter Höckerverlauf:
		rF_Simu_Ref  	:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref;					//BezugsFrequenz / Nennfrequenz [Hz]
	
		4:	rF_Simu_Act		:=	rF_PFC_Simu_Man_Act;			//Aktuelle Frequenz [Hz]			 		- man. Test, über Verstellung
			rF_Simu_Ref		:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref;					//BezugsFrequenz / Nennfrequenz [Hz]
		ELSE
			i_PFC_Test_var		:=	0;
			iCnt_Simu 			:=	0;																
			iCnt_Simu_Min 		:=	0;
	END_CASE	

	(* End Simulation PFC test cases *******************************************************************************)

	(*Test Button HMI for PFC*)
	VIS2MM.bPFC_TestStart;		VIS2MM.bPFC_TestStop;
	MM2VIS.iPFC_TestRestTime;	MM2VIS.rF_PFC_NomSim;

	iCnt_PFCSimuMax	:= (8*60*10);	(* 8min * 60sec * 10 Taskaufrufe / sec*)

	IF 	IN_GR.iPassLevel >= 30 OR (iCnt_PFCSimu > 0) THEN//Le avoid LFSM_TestStop during test by autoreset iPassLevel
		bPFC_TestEnable	 				:= TRUE;
	ELSE
		VIS2MM.bPFC_TestStart			:= FALSE;
		VIS2MM.bPFC_TestStop			:= TRUE;
		bPFC_TestEnable 				:= FALSE;		
	END_IF;

	IF iCnt_PFCSimu > iCnt_PFCSimuMax THEN		//Test wird beendet
		iCnt_PFCSimu			:= 0;
		VIS2MM.bPFC_TestStart	:= FALSE;
		VIS2MM.bPFC_TestStop	:= TRUE;
	ELSIF iCnt_PFCSimu > 0 THEN					//Test läuft
		iCnt_PFCSimu	:= iCnt_PFCSimu + 1;
		bSimu_HMI				:= TRUE;
		VIS2MM.bPFC_TestStart	:= TRUE;
	ELSIF iCnt_PFCSimu = 0 THEN					//Test ist gestoppt
		bSimu_HMI				:= FALSE;
	END_IF;

	R_TRIG_Start(CLK := VIS2MM.bPFC_TestStart AND bPFC_TestEnable);
	IF R_TRIG_Start.Q THEN
		iCnt_PFCSimu			:= 1;
		VIS2MM.bPFC_TestStop	:= FALSE;
	END_IF;
	R_TRIG_Stop(CLK := VIS2MM.bPFC_TestStop);
	IF R_TRIG_Stop.Q THEN
		iCnt_PFCSimu			:= 0;
		VIS2MM.bPFC_TestStart	:= FALSE;
		VIS2MM.bPFC_TestStop	:= TRUE;
	END_IF;

	CASE iCnt_PFCSimu OF
		1..600:		rF_Nom_sim_HMI		:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		601..1200:	rF_Nom_sim_HMI		:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref - 0.25;
		1201..1800:	rF_Nom_sim_HMI		:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref - 0.70;
		1801..2400: rF_Nom_sim_HMI		:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref - 1.10;
		2401..4800: rF_Nom_sim_HMI		:=	OUT_GR.tGR2CU.rFNom_LFSM_Ref - 1.60;
		ELSE
			rF_Nom_sim_HMI 					:= OUT_GR.tGR2CU.rFNom_LFSM_Ref;
	END_CASE;

	//Übergabe an VIS
	IF iCnt_PFCSimu > 0 THEN
		MM2VIS.iPFC_TestRestTime	:= DINT_TO_INT((iCnt_PFCSimuMax - iCnt_PFCSimu) / 10);
	ELSE
		MM2VIS.iPFC_TestRestTime	:= 0;	
	END_IF;

	MM2VIS.rF_PFC_NomSim	:= rF_Nom_sim_HMI;
	(**)	

	(*Test Button HMI for QU and PFU*)
	
	VIS2MM.bQU_PFU_TestStart;
	VIS2MM.bQU_PFU_TestStop;
	rUAct_Pro_URef := VIS2MM.rU_Act_sim_HMI;
	
	iCnt_QU_PFUSimuMax	:= (15*60*10);	(* 15min * 60sec * 10 Taskaufrufe / sec*)

	IF 	IN_GR.iPassLevel >= 30 THEN
		bQU_PFU_TestEnable	 			:= TRUE;
	ELSE
		VIS2MM.bQU_PFU_TestStart		:= FALSE;
		VIS2MM.bQU_PFU_TestStop			:= TRUE;
		bQU_PFU_TestEnable 				:= FALSE;		
	END_IF;

	IF iCnt_QU_PFUSimu > iCnt_QU_PFUSimuMax THEN		//Test wird beendet
		iCnt_QU_PFUSimu			:= 0;
		VIS2MM.bQU_PFU_TestStart	:= FALSE;
		VIS2MM.bQU_PFU_TestStop		:= TRUE;
	ELSIF iCnt_QU_PFUSimu > 0 THEN					//Test läuft
		iCnt_QU_PFUSimu	:= iCnt_QU_PFUSimu + 1;
		bSimu_QU_PFU_HMI			:= TRUE;
		VIS2MM.bQU_PFU_TestStart	:= TRUE;
	ELSIF iCnt_QU_PFUSimu = 0 THEN					//Test ist gestoppt
		bSimu_QU_PFU_HMI			:= FALSE;
	END_IF;

	R_TRIG_Start_PFU_QU(CLK := VIS2MM.bQU_PFU_TestStart AND bQU_PFU_TestEnable);
	IF R_TRIG_Start_PFU_QU.Q THEN
		iCnt_QU_PFUSimu			:= 1;
		VIS2MM.bQU_PFU_TestStop	:= FALSE;
	END_IF;
	R_TRIG_Stop_PFU_QU(CLK := VIS2MM.bQU_PFU_TestStop);
	IF R_TRIG_Stop_PFU_QU.Q THEN
		iCnt_QU_PFUSimu			:= 0;
		VIS2MM.bQU_PFU_TestStart:= FALSE;
		VIS2MM.bQU_PFU_TestStop	:= TRUE;
	END_IF;

//	//Übergabe an VIS
//	IF iCnt_QU_PFUSimu > 0 THEN
//		MM2VIS.iQU_PFU_TestRestTime	:= DINT_TO_INT((iCnt_QU_PFUSimuMax - iCnt_QU_PFUSimu) / 10);
//	ELSE
//		MM2VIS.iQU_PFU_TestRestTime	:= 0;	
//	END_IF;

	MM2VIS.rU_QU_PFU_NomSim	:= Para.rU_Act_sim_HMI;
//	MM2VIS.iQU_PFU_TestRestTime;	(*Maximum time of 5 min*)
	
	(*****************************************************)
	bSimu_Test;
	(*******************************************************)
	(* General enabling conditions for  stat. GC functions *)
	(*******************************************************)
	(* 1. Parallel operation *)
	xOpMode.NetP;
	(* 2. Automatikbetrieb *)
	IN_GR.iIdx_OMSS; (*=2*)
	(* 3. Wirkleistung  > 50% (GR_MAX - mit Grenzwert 50% und 5% Hyserese) *)
	(* 3. active power  > 50% (GR_MAX - with limit 50% and 5% hysteresis) *)
	//xGR_MAXR_statGC(In := IN_GR.rP_Act_Norm_Filt , Gw := MAX(0.1, Para.rP_Set_Min_Norm), Hy := 0.05);
	IF xOpMode.NetP OR bEZA_Cont  THEN
		bstatGC_rel	:= TRUE;
	ELSE
		bstatGC_rel	:= FALSE;
	END_IF;
	MM2VIS.bstatGC_rel	:= bstatGC_rel;
	
	(********************************************)
	(* Selection Point of reference MMU1 or MMU2 *)
	(********************************************)	
	iQPointRef:= Para.iQ_GrC_PointRef;
	CASE Para.iQ_GrC_PointRef OF
		2: 	(*MMU2*)
			IF (Para.bMMD2_Act) THEN
				iQPointRef := Para.iQ_GrC_PointRef;
			ELSE
				iQPointRef := 1;
			END_IF;
	END_CASE;
	
	iQPointCtrl:= Para.iQ_GrC_PointCtrl;
	CASE Para.iQ_GrC_PointCtrl OF
		2: 	(*MMU2*)
			IF (Para.bMMD2_Act) THEN
				iQPointCtrl := Para.iQ_GrC_PointCtrl;
			ELSE
				iQPointCtrl := 1;
			END_IF;
		3: (*Direct control loop*)
			iQPointCtrl := 1;
	END_CASE;
	
	(*HMI Interface*)
	MM2VIS.iQPointRef := iQPointRef;
	
	(*************************************************************)
	(***** Input signals to Q(P), Q(U), Cosphi(P), Cosphi(U) *****)
	(*************************************************************)
	
	(* Cosphi(P), Q(P) - Filter Actual Power *)
	IF (iQPointRef = 0) THEN
		rP_Act_Ref := IN_GR.rP_POR_Act_Cust; (*actual power defined by the customer*)
	ELSE
		rP_Act_Ref := IN_GR.tP_Act[iQPointRef].Unfilt;
	END_IF;
	
	FILTER_R_P_Act(In := rP_Act_Ref, Filter := iTFilt_P);
	IF IN_GR.rP_Nom <> 0 THEN
		rP_Act_Norm_Filt_PFP	:= FILTER_R_P_Act.Out / IN_GR.rP_Nom;
	END_IF;
	
	(* PF(U), PF(P), PFset, PF Time Table to Q calculation - Actual Power Point of Control PT1 Filter*)
	(* init program, Parameters for low pass *)
	xLCRPT1_PAct.enable := TRUE; 				 (* This function block is only executed if enable = TRUE *)
	xLCRPT1_PAct.t		:= rP_Time_Delay_Filt; 	 (* Time constants, delay time. Units: Seconds *)
	xLCRPT1_PAct.y_set	:= rP_Set_Val;			 (* Preset value for y *)
	xLCRPT1_PAct.set	:= FALSE;                (* Set default value *)
	
	(*Customized Point of Control Active P*)
	IF (Para.iQ_GrC_PointCtrl = 0) THEN
		rP_Act_PFSet := IN_GR.rP_POC_Act_Cust;
	ELSE
		rP_Act_PFSet := IN_GR.tP_Act[iQPointCtrl].Ai;
	END_IF;
	
	(* Low pass *)
	xLCRPT1_PAct.x	:= rP_Act_PFSet;
	xLCRPT1_PAct();

	rPAct_GCFilt	:= xLCRPT1_PAct.y; (*in kW - used for conversion equations*)
	
	(* Q(U), Cosphi(U) - Voltage Value Reading - INPUT *)	
	IF (iQPointRef = 0) THEN
		rU_ActV := IN_GR.rU_POR_Act_Cust; (*input voltage from customer definition*)
	ELSE
		IF IN_GR.bUist_max AND NOT Para.bPU_GrC_SetCOn THEN
			rUphase_Max := MAX(IN_GR.tU_L1L2[iQPointRef].Ai, IN_GR.tU_L2L3[iQPointRef].Ai);	
			rUphase_Max := MAX(rUphase_Max, IN_GR.tU_L3L1[iQPointRef].Ai);	
			rU_ActV		:= rUphase_Max;
		ELSE
			rU_ActV	:= IN_GR.tU_Avg[iQPointRef].Ai;
		END_IF;
	END_IF;
	(*INPUT in % *)
	rUAct_to_URef_Pro_UF	:= rU_ActV;
			

	(*Actual Voltage Moving Average Filter*)
	xLCRMovAvgFlt_UAct_to_URef(enable := ((NOT xOpMode.Stop)OR bEZA_Cont), x :=rUAct_to_URef_Pro_UF, base := iUFilt);
		
	IF Para.rU_GrC_SetEU_Nom <> 0 THEN (* division durch NULL vermeiden *)
		rUAct_to_URef_Pro	:= xLCRMovAvgFlt_UAct_to_URef.y / Para.rU_GrC_SetEU_Nom; (*Reference Voltage Unom #11696*)
		rUAct_to_URef_ProX[0] := rUAct_to_URef_Pro;

		IF i >= 10 THEN i := 0;
		ELSE		    rUAct_to_URef_ProX[i+1] := rUAct_to_URef_ProX[i];
						i := i + 1;
		END_IF;
	END_IF;
	
	IF bOffTest THEN
		rUAct_to_URef_Pro := rU_ActV / Para.rU_GrC_SetEU_Nom;
	END_IF;	
	
	(*U Reference shift from nominal*)
	IF (Para.rU_GrC_SetEU_Nom <> 0) THEN (* division durch NULL vermeinden *)
		rU_RefNom_Shift := (rURefV - 1.0); /// Para.rU_GrC_SetEU_Nom; (*Reference Voltage Unom #11696*)
	END_IF;
	
	(*U at the point of control for U control -> Q*)
	IF iQPointCtrl = 0 THEN
		rU_Ctrl_QSet := IN_GR.tU_Avg[1].Ai;
	ELSE
		rU_Ctrl_QSet := IN_GR.tU_Avg[iQPointCtrl].Ai;
	END_IF;
	
	(*Actual Voltage Moving Average Filter*)
	xLCRMovAvgFlt_UCtrl_to_URef(enable := ((NOT xOpMode.Stop)OR bEZA_Cont), x :=rU_Ctrl_QSet, base := iUFilt);
		
	IF Para.rU_GrC_SetEU_Nom <> 0 THEN (* division durch NULL vermeinden *)
		rUCtrl_to_URef	:= xLCRMovAvgFlt_UCtrl_to_URef.y / Para.rU_GrC_SetEU_Nom; (*Reference Voltage Unom #11696*)
	END_IF;
	
	(*HMI Interfaces*)
	MM2VIS.rP_act			:= rP_Act_Norm_Filt_PFP; (*p.u.*)
	IF bSimu_QU_PFU_HMI THEN
		MM2VIS.rU_act			:= rUAct_Pro_URef;
	ELSE
		MM2VIS.rU_act 			:= rUAct_to_URef_Pro; (*p.u.*)
	END_IF;
	
	(*****************************************)
	(* Read characteristic - cos(phi) = f(P) *)
	(*****************************************)

	IF (Para.iQ_GrC_CtrlFun = 2) OR OUT_GR.bPFP_Aktiv THEN
		(*Load PFP Table from Parameters*)
		iCnt_GrC_CnP := Para.iPFP_GrC_DataPoints;
		iPFP_NoOfPoints	:= Para.iPFP_GrC_DataPoints;
		FOR iLoopTable := 0 TO iCnt_GrC_CnP - 1 DO
			tcosphi_P_Points[iLoopTable].x  := Para.rPFP_GrC_PpointX[iLoopTable];
			tcosphi_P_Points2[iLoopTable].x := 0.0;
			tcosphi_P_Points2[iLoopTable].y := 0.0;
			IF (Para.rPFP_GrC_PFpointY[iLoopTable] > -0.5) AND (Para.rPFP_GrC_PFpointY[iLoopTable] < 0.5) THEN
				tcosphi_P_Points[iLoopTable].y := 1.0;
			ELSIF (Para.rPFP_GrC_PFpointY[iLoopTable] <= -0.5) THEN
				tcosphi_P_Points[iLoopTable].y  := Para.rPFP_GrC_PFpointY[iLoopTable] + 2.0;
			ELSE
				tcosphi_P_Points[iLoopTable].y  := Para.rPFP_GrC_PFpointY[iLoopTable];
			END_IF;
			tcosphi_P_Points2[iLoopTable].y := 0.0;
		END_FOR;
		FOR iLoopTable := iCnt_GrC_CnP TO 7 DO
			tcosphi_P_Points[iLoopTable].x := 0.0;
			tcosphi_P_Points[iLoopTable].y := 0.0;
			tcosphi_P_Points2[iLoopTable].x := 0.0;
			tcosphi_P_Points2[iLoopTable].y := 0.0;
		END_FOR;
		(*remove repetitive values*)
		FOR iLoopCnP := 0 TO iCnt_GrC_CnP - 2 DO
			rTempX := tcosphi_P_Points[iLoopCnP].x;
			FOR iShift := iLoopCnP + 1 TO iCnt_GrC_CnP - 1 DO
				IF (rTempX = tcosphi_P_Points[iShift].x) THEN
					tcosphi_P_Points[iShift].x := 0.0;
				END_IF;
			END_FOR;
		END_FOR;
		FOR iLoopCnP := 0 TO iCnt_GrC_CnP - 1 DO
			IF (tcosphi_P_Points[iLoopCnP].x = 0) THEN
				FOR iShift := iLoopCnP TO iCnt_GrC_CnP - 1 DO	
					IF (iShift = iCnt_GrC_CnP - 1) THEN
						tcosphi_P_Points[iShift].x := 0.0;
						tcosphi_P_Points[iShift].y := 0.0;
					ELSE
						tcosphi_P_Points[iShift].x := tcosphi_P_Points[iShift + 1].x;
						tcosphi_P_Points[iShift].y := tcosphi_P_Points[iShift + 1].y;
					END_IF;
				END_FOR;
				iLoopCnP := iLoopCnP - 1;	
				iCnt_GrC_CnP := iCnt_GrC_CnP - 1;	
			END_IF; 
		END_FOR;
		iPFP_NoOfPoints	:= iCnt_GrC_CnP;
		(*oder PFP Table - curve 1*)
		rPF_Min	:= 2.0;
		rPF_Max	:= -2.0;
		rTempX := 0.0;
		rTempY := 0.0;
		FOR iLoopCnP := 0 TO iPFP_NoOfPoints - 2 DO
			rP_Min := tcosphi_P_Points[iLoopCnP].x;
			iP_IdxMin := iLoopCnP;
			FOR iIdxMin := iLoopCnP + 1 TO iPFP_NoOfPoints - 1 DO
				IF (tcosphi_P_Points[iIdxMin].x < rP_Min) AND (tcosphi_P_Points[iIdxMin].x <> 0) THEN
					rP_Min := tcosphi_P_Points[iIdxMin].x;
					iP_IdxMin := iIdxMin;
				END_IF;			
			END_FOR;
			rTempX := tcosphi_P_Points[iLoopCnP].x;
			rTempY := tcosphi_P_Points[iLoopCnP].y;
			tcosphi_P_Points[iLoopCnP].x := rP_Min;
			tcosphi_P_Points[iLoopCnP].y := tcosphi_P_Points[iP_IdxMin].y;
			tcosphi_P_Points[iP_IdxMin].x  := rTempX;
			tcosphi_P_Points[iP_IdxMin].y  := rTempY;
			rTempX := tcosphi_P_Points[iLoopCnP].x;
		END_FOR;						
		(*Create Curve 2 hysteresis*)
		FOR iLoopCnP:=0 TO iPFP_NoOfPoints - 1 DO
			tcosphi_P_Points2[iLoopCnP].x := tcosphi_P_Points[iLoopCnP].x + Para.rQP_PFP_GrC_Hyst;
			tcosphi_P_Points2[iLoopCnP].y := tcosphi_P_Points[iLoopCnP].y;
			rPF_Min	:= MIN(rPF_Min, tcosphi_P_Points[iLoopCnP].y);
			rPF_Min	:= MIN(rPF_Min, tcosphi_P_Points2[iLoopCnP].y);
			rPF_Max	:= MAX(rPF_Max, tcosphi_P_Points[iLoopCnP].y);
			rPF_Max	:= MAX(rPF_Max, tcosphi_P_Points2[iLoopCnP].y);
		END_FOR;
		
		tcosphi_P_Cur.NoOfPoints := iPFP_NoOfPoints;
		tcosphi_P_Cur.ptr_table  := ADR(tcosphi_P_Points);
		tcosphi_P_Cur2.NoOfPoints := iPFP_NoOfPoints;
		tcosphi_P_Cur2.ptr_table  := ADR(tcosphi_P_Points2);

		IF bSimu_Test THEN
			tcosphi_P_Cur.x	:= rPAct_Prozent;
			tcosphi_P_Cur2.x	:= rPAct_Prozent;
		ELSE
			tcosphi_P_Cur.x	:= rP_Act_Norm_Filt_PFP;
			tcosphi_P_Cur2.x	:= rP_Act_Norm_Filt_PFP;
		END_IF;
		tcosphi_P_Cur();
		tcosphi_P_Cur2();
	
		rPFP_Min 	:= LIMIT(rPF_Min, MIN(tcosphi_P_Cur.y, tcosphi_P_Cur2.y), rPF_Max);
		rPFP_Max 	:= LIMIT(rPF_Min, MAX(tcosphi_P_Cur.y, tcosphi_P_Cur2.y), rPF_Max);	
		rCosPhi_P_Setlin	:= LIMIT(rPFP_Min, rCosPhi_P_Setlin, rPFP_Max);
		(*Bring PFP back to values between -1..1*)
		IF rCosPhi_P_Setlin > 1.0 THEN
			rCosPhi_P_Set 	:= rCosPhi_P_Setlin - 2.0;
		ELSE
			rCosPhi_P_Set 	:= rCosPhi_P_Setlin;
		END_IF;
		
		(*Q calculation in p.u. from PF(P)*)
		IF (rCosPhi_P_Set <> 0) AND (Para.rS_Nom <> 0) THEN
			rQP_PF_Set := TAN(ACOS(rCosPhi_P_Set)) * rPAct_GCFilt / Para.rS_Nom; (*p.u.*)
		END_IF;
	ELSE
		rCosPhi_P_Set := 1.0;
		rQP_PF_Set := 0.0; 
	END_IF;
	
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
	MM2VIS.rPF_P_set		:= rCosPhi_P_Set; //[-]
	(*curves*)
	FOR iLoopCnP:=0 TO iPFP_NoOfPoints - 1 DO
		MM2VIS.rPF_Px[iLoopCnP] := tcosphi_P_Points[iLoopCnP].x;
		MM2VIS.rPF_Py[iLoopCnP] := tcosphi_P_Points[iLoopCnP].y;
		MM2VIS.rPF2_Px[iLoopCnP] := tcosphi_P_Points2[iLoopCnP].x;
		MM2VIS.rPF2_Py[iLoopCnP] := tcosphi_P_Points2[iLoopCnP].y;
	END_FOR;
	(*number of points*)
	MM2VIS.iPFP_Points := iPFP_NoOfPoints;

	(*****************************************)
	(* Read characteristic - Q = f(P) *)
	(*****************************************)
		
	IF (Para.iQ_GrC_CtrlFun = 5) OR OUT_GR.bQP_Aktiv THEN
		(*Load QP Table from Parameters*)
		iCnt_GrC_CnP := Para.iQP_GrC_DataPoints;
		iQP_NoOfPoints	:= Para.iQP_GrC_DataPoints;
		FOR iLoopTable := 0 TO iCnt_GrC_CnP - 1 DO
			tQP_Points[iLoopTable].x  := Para.rQP_GrC_PpointX[iLoopTable];
			tQP_Points2[iLoopTable].x := 0.0;
			tQP_Points[iLoopTable].y  := Para.rQP_GrC_QpointY[iLoopTable];
			tQP_Points2[iLoopTable].y := 0.0;
		END_FOR;
		FOR iLoopTable := iCnt_GrC_CnP TO 7 DO
			tQP_Points[iLoopTable].x := 0.0;
			tQP_Points[iLoopTable].y := 0.0;
			tQP_Points2[iLoopTable].x := 0.0;
			tQP_Points2[iLoopTable].y := 0.0;
		END_FOR;
		(*remove repetitive values*)
		FOR iLoopCnP := 0 TO iCnt_GrC_CnP - 2 DO
			rTempX := tQP_Points[iLoopCnP].x;
			FOR iShift := iLoopCnP + 1 TO iCnt_GrC_CnP - 1 DO
				IF (rTempX = tQP_Points[iShift].x) THEN
					tQP_Points[iShift].x := 0.0;
				END_IF;
			END_FOR;
		END_FOR;
		FOR iLoopCnP := 0 TO iCnt_GrC_CnP - 1 DO
			IF (tQP_Points[iLoopCnP].x = 0) THEN
				FOR iShift := iLoopCnP TO iCnt_GrC_CnP - 1 DO	
					IF (iShift = iCnt_GrC_CnP - 1) THEN
						tQP_Points[iShift].x := 0.0;
						tQP_Points[iShift].y := 0.0;
					ELSE
						tQP_Points[iShift].x := tQP_Points[iShift + 1].x;
						tQP_Points[iShift].y := tQP_Points[iShift + 1].y;
					END_IF;
				END_FOR;
				iLoopCnP := iLoopCnP - 1;	
				iCnt_GrC_CnP := iCnt_GrC_CnP - 1;	
			END_IF;
		END_FOR;
		iQP_NoOfPoints := iCnt_GrC_CnP;
		(*order QP Table - curve 1*)
		rQMin := 2.0;
		rQMax := -2.0;
		rTempX := 0.0;
		rTempY := 0.0;
		FOR iLoopCnP := 0 TO iQP_NoOfPoints - 2 DO
			rP_Min := tQP_Points[iLoopCnP].x;
			iP_IdxMin := iLoopCnP;
			FOR iIdxMin := iLoopCnP + 1 TO iQP_NoOfPoints - 1 DO
				IF (tQP_Points[iIdxMin].x < rP_Min) AND (tQP_Points[iIdxMin].x <> 0) THEN
					rP_Min := tQP_Points[iIdxMin].x;
					iP_IdxMin := iIdxMin;
				END_IF;			
			END_FOR;
			rTempX := tQP_Points[iLoopCnP].x;
			rTempY := tQP_Points[iLoopCnP].y;
			tQP_Points[iLoopCnP].x := rP_Min;
			tQP_Points[iLoopCnP].y := tQP_Points[iP_IdxMin].y;
			tQP_Points[iP_IdxMin].x  := rTempX;
			tQP_Points[iP_IdxMin].y  := rTempY;
			rTempX := tQP_Points[iLoopCnP].x;
		END_FOR;						
		(*Create Curve 2 hysteresis*)
		FOR iLoopCnP:=0 TO iQP_NoOfPoints - 1 DO
			tQP_Points2[iLoopCnP].x := tQP_Points[iLoopCnP].x + Para.rQP_PFP_GrC_Hyst;
			tQP_Points2[iLoopCnP].y := tQP_Points[iLoopCnP].y;
			rQMin	:= MIN(rQMin, tQP_Points[iLoopCnP].y);
			rQMin	:= MIN(rQMin, tQP_Points2[iLoopCnP].y);
			rQMax	:= MAX(rQMax, tQP_Points[iLoopCnP].y);
			rQMax	:= MAX(rQMax, tQP_Points2[iLoopCnP].y);
		END_FOR;
		tQP_Cur.NoOfPoints := iQP_NoOfPoints;
		tQP_Cur.ptr_table  := ADR(tQP_Points);
		tQP_Cur2.NoOfPoints := iQP_NoOfPoints;
		tQP_Cur2.ptr_table  := ADR(tQP_Points2);

		IF bSimu_Test THEN
			tQP_Cur.x	:= rPAct_Prozent;
			tQP_Cur2.x	:= rPAct_Prozent;
		ELSE
			tQP_Cur.x	:= rP_Act_Norm_Filt_PFP;
			tQP_Cur2.x	:= rP_Act_Norm_Filt_PFP;
		END_IF;
		tQP_Cur();
		tQP_Cur2();
	
		rQP_Min 	:= LIMIT(rQMin, MIN(tQP_Cur.y, tQP_Cur2.y), rQMax);
		rQP_Max 	:= LIMIT(rQMin, MAX(tQP_Cur.y, tQP_Cur2.y), rQMax);	
		rQP_Setlin	:= LIMIT(rQP_Min, rQP_Setlin, rQP_Max);
		rQP_Set := rQP_Setlin * Para.rS_Nom; (*kVAr*)
	ELSE
		rQP_Setlin := 0.0;	
		rQP_Set := 0.0;
	END_IF;	
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
	(*curves*)
	FOR iLoopCnP:=0 TO iQP_NoOfPoints - 1 DO
		MM2VIS.rQ_Px[iLoopCnP] := tQP_Points[iLoopCnP].x;
		MM2VIS.rQ_Py[iLoopCnP] := tQP_Points[iLoopCnP].y;
		MM2VIS.rQ2_Px[iLoopCnP] := tQP_Points2[iLoopCnP].x;
		MM2VIS.rQ2_Py[iLoopCnP] := tQP_Points2[iLoopCnP].y;
	END_FOR;
	(*number of points*)
	MM2VIS.iQP_Points := iQP_NoOfPoints;
	
	MM2VIS.rQ_P_set := rQP_Setlin;
	(******************************************************)
	(* Read characteristic - LFSMU/LFSMO (old PFC/RMC)    *)
	(******************************************************)
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	(* Parameter *)
	
	Para.bSet_GrC_LFSMO_COn;
	Para.bSet_GrC_LFSMU_COn;
	Para.rDroop_GrC_LFSMO_pos;
	Para.rDroop_GrC_LFSMU_neg;
	Para.rF_LFSMO_GrC_DeadBand_pos;
	Para.rF_LFSMU_GrC_DeadBand_neg;
	Para.bLFSM_GrC_Pref;
	Para.bHyst_GrC_COn;
	Para.rHyst_GrC_DeadBand;
	
	(*Delta frequency calculation*)
	IF bTest_f_force THEN
		rF_LFSM_Act 	:= rftest_PFC; (* fforce *)
		rF_LFSM_Ref		:= OUT_GR.tGR2CU.rFNom_LFSM_Ref; (* fref *)		
	ELSIF i_PFC_Test_var <> 0 THEN
		rF_LFSM_Act		:= rF_Simu_Act; (* fsimu_ist *)
		rF_LFSM_Ref		:= rF_Simu_Ref; (* fsimu_ref *)
	ELSIF bSimu_Test2 THEN  
		rF_LFSM_Act		:= IN_GR.tF_MMD_BusBar[1].Ai; (* fist *)
		rF_LFSM_Ref		:= rF_Nom_sim; (* fref *)
	ELSIF bSimu_HMI THEN
		rF_LFSM_Act		:= IN_GR.tF_MMD_BusBar[1].Ai; (* fist *)
		rF_LFSM_Ref		:= rF_Nom_sim_HMI; (* fref *)
	ELSIF VIS2MM.iSet_FC_Testmode = 2 AND VIS2MM.bLFSM_TestStart THEN
		rF_LFSM_Act		:= IN_GR.tF_MMD_BusBar[1].Ai; (* fist *)
		rF_LFSM_Ref		:= VIS2MM.rFNom_FSM_ManualTest; (* fref *)
	ELSIF VIS2MM.iSet_FC_Testmode = 4 AND (VIS2MM.bLFSM_TestStart OR IN_GR.bSet_LFSM_Test_COn) THEN
		rF_LFSM_Act		:= IN_GR.rF_Act; (* fist *)
		rF_LFSM_Ref		:= OUT_GR.tGR2CU.rFNom_LFSM_Ref; (* fref *)
	ELSE
		rF_LFSM_Act		:= IN_GR.tF_MMD_BusBar[1].Ai; (* fist *)
		rF_LFSM_Ref		:= OUT_GR.tGR2CU.rFNom_LFSM_Ref; (* fref *)
	END_IF;
	
	IF bSimu_Test THEN
		rDeltaF_LFSM		:= rF_Delta_PFCTest; 
		rDeltaF_LFSM_Hyst   := rF_Delta_PFCTest;
	ELSE
		iF_LFSM_Act    		:= REAL_TO_INT(rF_LFSM_Act * 100);//Le//change to INT
		iF_LFSM_Ref    		:= REAL_TO_INT(rF_LFSM_Ref * 100);
		rDeltaF_LFSM		:= (INT_TO_REAL(iF_LFSM_Act - iF_LFSM_Ref)) / 100;//remove all digits lower then 2 to avoid calc.error caused by REAL
		rDeltaF_LFSM_Hyst	:= (INT_TO_REAL(iF_LFSM_Act - iF_LFSM_Ref)) / 100;//for proper compare to zero operation
	END_IF;

	IF NOT bSimu_Test2 THEN
		rF_Nom_sim 		:= OUT_GR.tGR2CU.rFNom_LFSM_Ref;	
	END_IF;
		

	//PFC - Test mode fixed end on the falling edge of parallel operation
	//to prevent that is forgotten to stop the test operation
	xF_TRIG_NetpM(CLK := xOpMode.NetP);
	IF xF_TRIG_NetpM.Q THEN
		bTest_f_force	:= FALSE;
		//		bSimu_Test2	:= FALSE;
	END_IF;	

	(*DeltaP Calculation*)
	(*LFSMO TEIL*)
	IF Para.bSet_GrC_LFSMO_COn AND (rDeltaF_LFSM > rF_LFSMO_GrC_DB_pos) THEN
		(*Hysteresis curve calculation*)
		IF (rDeltaF_LFSM < rDeltaF_LFSM_Old) AND Para.bHyst_GrC_COn THEN
			IF (rDeltaF_LFSM >= Para.rHyst_GrC_DeadBand) THEN (*This part is kept in case the hyst dead-band is bigger than the LFSMO deadband*)
				rP_LFSM_Delta_c;
				bPistHyst := TRUE;
				bPistCurve := FALSE;
			ELSE
				IF (OUT_GR.tGR2CU.rFNom_LFSM_Ref <> 0) AND (rDroop_GrC_LFSMO_pos <> 0) THEN
					rP_LFSM_Delta_c := -(rDeltaF_LFSM - rF_LFSMO_GrC_DB_pos) / OUT_GR.tGR2CU.rFNom_LFSM_Ref / rDroop_GrC_LFSMO_pos;
				END_IF;
				rDeltaF_LFSM_Old := rDeltaF_LFSM;
				bPistHyst := FALSE;
				bPistCurve := TRUE;
				(*power set released from PFC*)
			END_IF;
		(*calculation during ramp down LFSMO*)
		ELSIF (OUT_GR.tGR2CU.rFNom_LFSM_Ref <> 0) AND (rDroop_GrC_LFSMO_pos <> 0) THEN
			rP_LFSM_Delta_c := -(rDeltaF_LFSM - rF_LFSMO_GrC_DB_pos) / OUT_GR.tGR2CU.rFNom_LFSM_Ref / rDroop_GrC_LFSMO_pos;
			rDeltaF_LFSM_Old := rDeltaF_LFSM;
			bPistHyst := FALSE;
			bPistCurve := TRUE;
		END_IF;

	ELSIF Para.bSet_GrC_LFSMU_COn AND ((rDeltaF_LFSM < rF_LFSMU_GrC_DB_neg)) THEN
		IF (OUT_GR.tGR2CU.rFNom_LFSM_Ref <> 0) AND (rDroop_GrC_LFSMU_neg <> 0) THEN
			rP_LFSM_Delta_c := (ABS(rDeltaF_LFSM) - ABS(rF_LFSMU_GrC_DB_neg)) / OUT_GR.tGR2CU.rFNom_LFSM_Ref / rDroop_GrC_LFSMU_neg;
		END_IF;
		rDeltaF_LFSM_Old := rDeltaF_LFSM;
		bPistHyst := FALSE;
		bPistCurve := FALSE;
		
	ELSIF bPistHyst OR bPistCurve THEN
		IF (rDeltaF_LFSM < rDeltaF_LFSM_Old) AND Para.bHyst_GrC_COn THEN
			IF (rDeltaF_LFSM >= Para.rHyst_GrC_DeadBand) THEN
				rP_LFSM_Delta;
				bPistHyst := TRUE;
				bPistCurve := FALSE;
			ELSE
				rP_LFSM_Delta_c := 0;
				rP_LFSM_Delta := 0;
				rDeltaF_LFSM_Old := 0.0;
				bPistHyst := FALSE;
				bPistCurve := FALSE;
				(*power set released from PFC*)
			END_IF;
		ELSE
			rP_LFSM_Delta_c := 0;
			rP_LFSM_Delta := 0;
			rDeltaF_LFSM_Old := 0.0;
			bPistHyst := FALSE;
			bPistCurve := FALSE;
		END_IF;
	ELSE
		rP_LFSM_Delta_c := 0;
		rP_LFSM_Delta := 0;
		rDeltaF_LFSM_Old := 0.0;	
		(*power set released from PFC*)
	END_IF;

	
	(* entry/exit LFSM-mode with time delay *)// delay only for P-handover, not for P-calculation!//LE 27.11.2019
	xTON_LFSMO_GrC_Entry(IN:= Para.bSet_GrC_LFSMO_COn AND (rDeltaF_LFSM > rF_LFSMO_GrC_DB_pos), PT:= Para.tiLFSM_GrC_Entry);
	xTON_LFSMU_GrC_Entry(IN:= Para.bSet_GrC_LFSMU_COn AND (rDeltaF_LFSM < rF_LFSMU_GrC_DB_neg), PT:= Para.tiLFSM_GrC_Entry);
	xTOF_LFSM_GrC_Exit(IN:= xTON_LFSMO_GrC_Entry.Q OR xTON_LFSMU_GrC_Entry.Q, PT:= Para.tiLFSM_GrC_Exit);

	IF    xTON_LFSMO_GrC_Entry.Q THEN rP_LFSM_Delta := rP_LFSM_DeltaOld := rP_LFSM_Delta_c;
	ELSIF xTON_LFSMU_GrC_Entry.Q THEN rP_LFSM_Delta := rP_LFSM_DeltaOld := rP_LFSM_Delta_c;
	ELSIF xTOF_LFSM_GrC_Exit.Q   THEN rP_LFSM_Delta := rP_LFSM_DeltaOld;
	ELSE                              rP_LFSM_Delta;
	END_IF;//LE_e
	
	
	(*****************************************)
	(* Read characteristic - Q =f(U)         *)
	(*****************************************)
	
	IF (Para.iQ_GrC_CtrlFun = 4) OR (Para.iQ_GrC_CtrlFun = 6) OR OUT_GR.bQU_Aktiv OR bQ_Lim_QU_Rel THEN//LE also "6" needs values from tQU_Points[]
		(*Load QU Table from Parameters*)
		iCnt_GrC_CnP := Para.iQU_GrC_DataPoints;
		iQU_NoOfPoints	:= Para.iQU_GrC_DataPoints;
		FOR iLoopTable := 0 TO iCnt_GrC_CnP - 1 DO
			tQU_Points[iLoopTable].x  := Para.rQU_GrC_UpointX[iLoopTable] + rU_RefNom_Shift;
			tQU_Points2[iLoopTable].x := 0.0;
			tQU_Points[iLoopTable].y  := Para.rQU_GrC_QpointY[iLoopTable];
			tQU_Points2[iLoopTable].y := 0.0;
		END_FOR;
		FOR iLoopTable := iCnt_GrC_CnP TO 7 DO
			tQU_Points[iLoopTable].x := 0.0;
			tQU_Points[iLoopTable].y := 0.0;
			tQU_Points2[iLoopTable].x := 0.0;
			tQU_Points2[iLoopTable].y := 0.0;
		END_FOR;
		(*remove repetitive values*)
		FOR iLoopCnP := 0 TO iCnt_GrC_CnP - 2 DO
			rTempX := tQU_Points[iLoopCnP].x;
			FOR iShift := iLoopCnP + 1 TO iCnt_GrC_CnP - 1 DO
				IF (rTempX = tQU_Points[iShift].x) THEN
					tQU_Points[iShift].x := 0.0;
				END_IF;
			END_FOR;
		END_FOR;
		FOR iLoopCnP := 0 TO iCnt_GrC_CnP - 1 DO
			IF (tQU_Points[iLoopCnP].x = 0) THEN
				FOR iShift := iLoopCnP TO iCnt_GrC_CnP - 1 DO	
					IF (iShift = iCnt_GrC_CnP - 1) THEN
						tQU_Points[iShift].x := 0.0;
						tQU_Points[iShift].y := 0.0;
					ELSE
						tQU_Points[iShift].x := tQU_Points[iShift + 1].x;
						tQU_Points[iShift].y := tQU_Points[iShift + 1].y;
					END_IF;
				END_FOR;
				iLoopCnP := iLoopCnP - 1;	
				iCnt_GrC_CnP := iCnt_GrC_CnP - 1;	
			END_IF; 
		END_FOR;
		iQU_NoOfPoints	:= iCnt_GrC_CnP;
		(*oder QU Table - curve 1*)
		rQ_Min := 0.6;
		rQ_Max := -0.6;
		rTempX := 0.0;
		rTempY := 0.0;
		FOR iLoopCnP := 0 TO iQU_NoOfPoints - 2 DO
			rU_Min := tQU_Points[iLoopCnP].x;
			iU_IdxMin := iLoopCnP;
			FOR iIdxMin := iLoopCnP + 1 TO iQU_NoOfPoints - 1 DO
				IF (tQU_Points[iIdxMin].x < rU_Min) AND (tQU_Points[iIdxMin].x <> 0) THEN
					rU_Min := tQU_Points[iIdxMin].x;
					iU_IdxMin := iIdxMin;
				END_IF;			
			END_FOR;
			rTempX := tQU_Points[iLoopCnP].x;
			rTempY := tQU_Points[iLoopCnP].y;
			tQU_Points[iLoopCnP].x := rU_Min;
			tQU_Points[iLoopCnP].y := tQU_Points[iU_IdxMin].y;
			tQU_Points[iU_IdxMin].x  := rTempX;
			tQU_Points[iU_IdxMin].y  := rTempY;
			rTempX := tQU_Points[iLoopCnP].x;
		END_FOR;						
		
		IF (NOT bQ_Lim_QU_Rel) THEN
			(*Create Curve 2 hysteresis*)
			FOR iLoopCnP:=0 TO iQU_NoOfPoints - 1 DO
				tQU_Points2[iLoopCnP].x := tQU_Points[iLoopCnP].x + Para.rQU_PFU_GrC_Hyst;
				tQU_Points2[iLoopCnP].y := tQU_Points[iLoopCnP].y;
				rQ_Min	:= MIN(rQ_Min, tQU_Points[iLoopCnP].y);
				rQ_Min	:= MIN(rQ_Min, tQU_Points2[iLoopCnP].y);
				rQ_Max	:= MAX(rQ_Max, tQU_Points[iLoopCnP].y);
				rQ_Max	:= MAX(rQ_Max, tQU_Points2[iLoopCnP].y);
			END_FOR;
			tQU_Cur.NoOfPoints := iQU_NoOfPoints;
			tQU_Cur.ptr_table  := ADR(tQU_Points);
			tQU_Cur2.NoOfPoints := iQU_NoOfPoints;
			tQU_Cur2.ptr_table  := ADR(tQU_Points2);
	
			(*Deadband for Uact*)	
			IF bSimu_Test OR bSimu_QU_PFU_HMI THEN
				IF Para.rU_GrC_DeadBand <= 0 THEN
					tQU_Cur.x		:= rUAct_Pro_URef; 
					tQU_Cur2.x		:= rUAct_Pro_URef;
				ELSE
					IF ABS(rUAct_Pro_URef - rUAct_Pro_URefOld) > Para.rU_GrC_DeadBand THEN
						tQU_Cur.x		:= rUAct_Pro_URef; 
						tQU_Cur2.x		:= rUAct_Pro_URef;
						rUAct_Pro_URefOld	:= rUAct_Pro_URef;
					END_IF;	
				END_IF;
			ELSE
				IF Para.rU_GrC_DeadBand <= 0 THEN
					tQU_Cur.x		:= rUAct_to_URef_Pro;
					tQU_Cur2.x		:= rUAct_to_URef_Pro;
				ELSE
					IF ABS(rUAct_to_URef_ProX[3] - rUAct_Pro_URefOld) >  Para.rU_GrC_DeadBand THEN (* use [x]cycles old value *)
						tQU_Cur.x			:= rUAct_to_URef_Pro;
						tQU_Cur2.x			:= rUAct_to_URef_Pro;
						rUAct_Pro_URefOld	:= rUAct_to_URef_Pro;
					END_IF;	
				END_IF;
			END_IF;
			
			(*call QU table function*)
			tQU_Cur();
			tQU_Cur2();
			rQU_Min := LIMIT(rQ_Min, MIN(tQU_Cur.y, tQU_Cur2.y), rQ_Max);
			rQU_Max := LIMIT(rQ_Min, MAX(tQU_Cur.y, tQU_Cur2.y), rQ_Max);	
			rQU_Set_Norm := LIMIT(rQU_Min, rQU_Set_Norm, rQU_Max);
			rQU_Set := rQU_Set_Norm * Para.rS_Nom; (*kVAr*)
		ELSE
			rQU_Set_Norm := 0.0;
			rQU_Set := 0.0;
		END_IF;
	ELSE
		rQU_Set_Norm := 0.0;
		rQU_Set := 0.0;
	END_IF;
	
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
	(*curves*)
	MM2VIS.rQ_U_set := rQU_Set_Norm;
	
	IF Para.bQLim_QU_active AND (OUT_GR.iGCQ_Fun_Act = 1 OR OUT_GR.iGCQ_Fun_Act = 6) THEN
		MM2VIS.rQ_Ux[0]  := tQLim_Points[0].x;
		MM2VIS.rQ_Ux[1]  := tQLim_Points[1].x;
		MM2VIS.rQ_Ux[2]  := tQLim_Points2[1].x;
		MM2VIS.rQ_Uy[0]  := tQLim_Points[0].y;
		MM2VIS.rQ_Uy[1]  := tQLim_Points[1].y;
		MM2VIS.rQ_Uy[2]  := tQLim_Points2[1].y;
		MM2VIS.rQ2_Ux[0] := tQLim_Points[0].x;
		MM2VIS.rQ2_Ux[1] := tQLim_Points2[0].x;
		MM2VIS.rQ2_Ux[2] := tQLim_Points2[1].x;
		MM2VIS.rQ2_Uy[0] := tQLim_Points[0].y;
		MM2VIS.rQ2_Uy[1] := tQLim_Points2[0].y;
		MM2VIS.rQ2_Uy[2] := tQLim_Points2[1].y;
		(*number of points*)
		MM2VIS.iQU_Points := 3;
	ELSE	
		FOR iLoopCnP:=0 TO iQU_NoOfPoints - 1 DO
			MM2VIS.rQ_Ux[iLoopCnP] := tQU_Points[iLoopCnP].x;
			MM2VIS.rQ_Uy[iLoopCnP] := tQU_Points[iLoopCnP].y;
			MM2VIS.rQ2_Ux[iLoopCnP] := tQU_Points2[iLoopCnP].x;
			MM2VIS.rQ2_Uy[iLoopCnP]	:= tQU_Points2[iLoopCnP].y;
		END_FOR;
	(*number of points*)
		MM2VIS.iQU_Points := iQU_NoOfPoints;
	END_IF;	
		
	(*************************************)
	(* 	  Read PF(U) characteristic      *)
	(*************************************)
	IF (Para.iQ_GrC_CtrlFun = 3) OR OUT_GR.bPFU_Aktiv THEN
		(*Load PFU Table from Parameters*)
		iCnt_GrC_CnP := Para.iPFU_GrC_DataPoints;
		iPFU_NoOfPoints	:= Para.iPFU_GrC_DataPoints;
		FOR iLoopTable := 0 TO iCnt_GrC_CnP - 1 DO
			tPFU_Points[iLoopTable].x  := Para.rPFU_GrC_UpointX[iLoopTable] + rU_RefNom_Shift;
			tPFU_Points2[iLoopTable].x := 0.0;
			tPFU_Points2[iLoopTable].y := 0.0;
			IF (Para.rPFU_GrC_PFpointY[iLoopTable] > -0.5) AND (Para.rPFU_GrC_PFpointY[iLoopTable] < 0.5) THEN
				tPFU_Points[iLoopTable].y := 1.0;
			ELSIF (Para.rPFU_GrC_PFpointY[iLoopTable] <= -0.5) THEN
				tPFU_Points[iLoopTable].y  := Para.rPFU_GrC_PFpointY[iLoopTable] + 2.0;
			ELSE
				tPFU_Points[iLoopTable].y  := Para.rPFU_GrC_PFpointY[iLoopTable];
			END_IF;
			tPFU_Points2[iLoopTable].y := 0.0;
		END_FOR;
		FOR iLoopTable := iCnt_GrC_CnP TO 7 DO
			tPFU_Points[iLoopTable].x := 0.0;
			tPFU_Points[iLoopTable].y := 0.0;
			tPFU_Points2[iLoopTable].x := 0.0;
			tPFU_Points2[iLoopTable].y := 0.0;
		END_FOR;
		(*remove repetitive values*)
		FOR iLoopCnP := 0 TO iCnt_GrC_CnP - 2 DO
			rTempX := tPFU_Points[iLoopCnP].x;
			FOR iShift := iLoopCnP + 1 TO iCnt_GrC_CnP - 1 DO
				IF (rTempX = tPFU_Points[iShift].x) THEN
					tPFU_Points[iShift].x := 0.0;
				END_IF;
			END_FOR;
		END_FOR;
		FOR iLoopCnP := 0 TO iCnt_GrC_CnP - 1 DO
			IF (tPFU_Points[iLoopCnP].x = 0) THEN
				FOR iShift := iLoopCnP TO iCnt_GrC_CnP - 1 DO	
					IF (iShift = iCnt_GrC_CnP - 1) THEN
						tPFU_Points[iShift].x := 0.0;
						tPFU_Points[iShift].y := 0.0;
					ELSE
						tPFU_Points[iShift].x := tPFU_Points[iShift + 1].x;
						tPFU_Points[iShift].y := tPFU_Points[iShift + 1].y;
					END_IF;
				END_FOR;
				iLoopCnP := iLoopCnP - 1;	
				iCnt_GrC_CnP := iCnt_GrC_CnP - 1;	
			END_IF; 
		END_FOR;
		iPFU_NoOfPoints	:= iCnt_GrC_CnP;
		(*oder PFU Table - curve 1*)
		rMinPFU	:= 2.0;
		rMaxPFU	:= -2.0;
		rTempX := 0.0;
		rTempY := 0.0;
		FOR iLoopCnP := 0 TO iPFU_NoOfPoints - 2 DO
			rU_Min := tPFU_Points[iLoopCnP].x;
			iU_IdxMin := iLoopCnP;
			FOR iIdxMin := iLoopCnP + 1 TO iPFU_NoOfPoints - 1 DO
				IF (tPFU_Points[iIdxMin].x < rU_Min) AND (tPFU_Points[iIdxMin].x <> 0) THEN
					rU_Min := tPFU_Points[iIdxMin].x;
					iU_IdxMin := iIdxMin;
				END_IF;			
			END_FOR;
			rTempX := tPFU_Points[iLoopCnP].x;
			rTempY := tPFU_Points[iLoopCnP].y;
			tPFU_Points[iLoopCnP].x := rU_Min;
			tPFU_Points[iLoopCnP].y := tPFU_Points[iU_IdxMin].y;
			tPFU_Points[iU_IdxMin].x  := rTempX;
			tPFU_Points[iU_IdxMin].y  := rTempY;
			rTempX := tPFU_Points[iLoopCnP].x;
		END_FOR;						
		(*Create Curve 2 hysteresis*)
		FOR iLoopCnP:=0 TO iPFU_NoOfPoints - 1 DO
			tPFU_Points2[iLoopCnP].x := tPFU_Points[iLoopCnP].x + Para.rQU_PFU_GrC_Hyst;
			tPFU_Points2[iLoopCnP].y := tPFU_Points[iLoopCnP].y;
			rMinPFU	:= MIN(rMinPFU, tPFU_Points[iLoopCnP].y);
			rMinPFU	:= MIN(rMinPFU, tPFU_Points2[iLoopCnP].y);
			rMaxPFU	:= MAX(rMaxPFU, tPFU_Points[iLoopCnP].y);
			rMaxPFU	:= MAX(rMaxPFU, tPFU_Points2[iLoopCnP].y);
		END_FOR;
		tPFU_Cur.NoOfPoints := iPFU_NoOfPoints;
		tPFU_Cur.ptr_table  := ADR(tPFU_Points);
		tPFU_Cur2.NoOfPoints := iPFU_NoOfPoints;
		tPFU_Cur2.ptr_table  := ADR(tPFU_Points2);
	
		(*Deadband for Uact*)	
		IF bSimu_Test OR bSimu_QU_PFU_HMI THEN
			IF Para.rU_GrC_DeadBand <= 0 THEN
				tPFU_Cur.x	:= rUAct_Pro_URef; 
				tPFU_Cur2.x	:= rUAct_Pro_URef;
			ELSE
				IF ABS(rUAct_Pro_URef - rUAct_Pro_URefOld) > Para.rU_GrC_DeadBand THEN
					tPFU_Cur.x		:= rUAct_Pro_URef; 
					tPFU_Cur2.x		:= rUAct_Pro_URef;
					rUAct_Pro_URefOld	:= rUAct_Pro_URef;
				END_IF;	
			END_IF;
		ELSE
			IF Para.rU_GrC_DeadBand <= 0 THEN
				tPFU_Cur.x	:= rUAct_to_URef_Pro;
				tPFU_Cur2.x	:= rUAct_to_URef_Pro;
			ELSE
				IF ABS(rUAct_to_URef_Pro - rUAct_Pro_URefOld) >  Para.rU_GrC_DeadBand THEN
					tPFU_Cur.x			:= rUAct_to_URef_Pro;
					tPFU_Cur2.x			:= rUAct_to_URef_Pro;
					rUAct_Pro_URefOld	:= rUAct_to_URef_Pro;
				END_IF;	
			END_IF;
		END_IF;

		tPFU_Cur();
		tPFU_Cur2();
		rPFU_Min 	:= LIMIT(rMinPFU, MIN(tPFU_Cur.y, tPFU_Cur2.y), rMaxPFU);
		rPFU_Max 	:= LIMIT(rMinPFU, MAX(tPFU_Cur.y, tPFU_Cur2.y), rMaxPFU);	
		rPFU_Setlin	:= LIMIT(rPFU_Min, rPFU_Setlin, rPFU_Max);
		(*Bring PFU back to values between -1..1*)
		IF rPFU_Setlin > 1 THEN
			rPF_U_Set 	:= rPFU_Setlin - 2;
		ELSE
			rPF_U_Set 	:= rPFU_Setlin;
		END_IF;	
		
		(*Q calculation in p.u. from PF(U)*)
		IF (rPF_U_Set <> 0) AND (Para.rS_Nom <> 0) THEN
			rQU_PF_Set := TAN(ACOS(rPF_U_Set)) * rPAct_GCFilt / Para.rS_Nom; (*p.u.*)
		END_IF;
	ELSE
		rPF_U_Set := 1.0;
		rQU_PF_Set := 0.0;
	END_IF;	
	
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
	MM2VIS.rPF_U_set		:= rPF_U_Set;

	(*curves*)
	FOR iLoopCnP:=0 TO iPFU_NoOfPoints - 1 DO
		MM2VIS.rPF_Ux[iLoopCnP] := tPFU_Points[iLoopCnP].x;
		MM2VIS.rPF_Uy[iLoopCnP] := tPFU_Points[iLoopCnP].y;
		MM2VIS.rPF2_Ux[iLoopCnP] := tPFU_Points2[iLoopCnP].x;
		MM2VIS.rPF2_Uy[iLoopCnP] := tPFU_Points2[iLoopCnP].y;
	END_FOR;
	(*number of points*)
	MM2VIS.iPFU_Points := iPFU_NoOfPoints;
	
	(***************************************)
	(******* Q Limitation based Q(U) *******)
	(***************************************)
	
	IF		 Para.bQLim_QU_active
		AND (OUT_GR.iGCQ_Fun_Act = 1 OR OUT_GR.iGCQ_Fun_Act = 6)  (* use priority depending active operating modes *)
		AND (Para.rQLimU_GrC_QpointY[0] > Para.rQLimU_GrC_QpointY[3])
		AND((Para.rQLimU_GrC_QpointY[1] - Para.rQLimU_GrC_QpointY[0]) <> 0) 		(* avoid /0 *)
		AND((Para.rQLimU_GrC_QpointY[3] - Para.rQLimU_GrC_QpointY[2]) <> 0) THEN	(* avoid /0 *)
		(* Limitation curve definition *)
		(*curve 1*)
		tQLim_Points[0].x := Para.rQLimU_GrC_UpointX[0] + rU_RefNom_Shift;
		tQLim_Points[0].y := Para.rQLimU_GrC_QpointY[0];
		tQLim_Points[1].x := Para.rQLimU_GrC_UpointX[1] + (Para.rQLimU_GrC_UpointX[1] - Para.rQLimU_GrC_UpointX[0]) * (ABS(Para.rQLimU_GrC_QpointY[3] - Para.rQLimU_GrC_QpointY[1]) / ABS(Para.rQLimU_GrC_QpointY[1] - Para.rQLimU_GrC_QpointY[0])) + rU_RefNom_Shift;
		tQLim_Points[1].y := Para.rQLimU_GrC_QpointY[3];
		rQLim_Min := MIN(tQLim_Points[0].y, tQLim_Points[1].y);
		rQLim_Max := MAX(tQLim_Points[0].y, tQLim_Points[1].y);
		tQLim_Cur.NoOfPoints := 2;
		tQLim_Cur.ptr_table  := ADR(tQLim_Points);
		(*curve 2*)
		tQLim_Points2[0].x := Para.rQLimU_GrC_UpointX[2] - (Para.rQLimU_GrC_UpointX[3] - Para.rQLimU_GrC_UpointX[2]) * (ABS(Para.rQLimU_GrC_QpointY[2] - Para.rQLimU_GrC_QpointY[0]) / ABS(Para.rQLimU_GrC_QpointY[3] - Para.rQLimU_GrC_QpointY[2])) + rU_RefNom_Shift;
		tQLim_Points2[0].y := Para.rQLimU_GrC_QpointY[0];
		tQLim_Points2[1].x := Para.rQLimU_GrC_UpointX[3] + rU_RefNom_Shift;
		tQLim_Points2[1].y := Para.rQLimU_GrC_QpointY[3];
		rQLim_Min2 := MIN(tQLim_Points2[0].y, tQLim_Points2[1].y);
		rQLim_Max2 := MAX(tQLim_Points2[0].y, tQLim_Points2[1].y);
		tQLim_Cur2.NoOfPoints := 2;
		tQLim_Cur2.ptr_table  := ADR(tQLim_Points2);
		(*call curve*)
		IF bSimu_QU_PFU_HMI THEN
			tQLim_Cur.x		:= rUAct_Pro_URef;
			tQLim_Cur2.x	:= rUAct_Pro_URef;
		ELSE
			tQLim_Cur.x		:= rUAct_to_URef_Pro;
			tQLim_Cur2.x	:= rUAct_to_URef_Pro;
		END_IF;
		tQLim_Cur();
		tQLim_Cur2();
		(*Limitations*)
		r[1] := MAX(tQLim_Cur.y, rQ_Set_ToLim);//LE pos.= overexcited
		r[2] := MIN(r[1], tQLim_Cur2.y);//LE
		r[3] := LIMIT(MIN(rQLim_Min,rQLim_Min2), r[2], MAX(rQLim_Max,rQLim_Max2));//LE
		rQSet_QULim := r[3];//LE
	ELSE
		rQSet_QULim := rQ_Set_ToLim;
	END_IF;
	
	(*************************************)
	(* 	  Range for figure FSM/LFSM  *)
	(*************************************)

	IF VIS2MM.bFSM_Zoom THEN															(* Change scaling of X-Y axis with Zoom button on HMI *)
		MM2VIS.rF_FSM_Range_Delta_x[0] := -0.2 + OUT_GR.tGR2CU.rFNom_LFSM_Ref; 	
		MM2VIS.rF_FSM_Range_Delta_x[1] := 0.2 + OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		MM2VIS.rP_FSM_Range_Delta_y[0] := -10;
		MM2VIS.rP_FSM_Range_Delta_y[1] := 10;
	ELSE
		MM2VIS.rF_FSM_Range_Delta_x[0] := -2 + OUT_GR.tGR2CU.rFNom_LFSM_Ref; 	
		MM2VIS.rF_FSM_Range_Delta_x[1] := 2 + OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		MM2VIS.rP_FSM_Range_Delta_y[0] := -100;
		MM2VIS.rP_FSM_Range_Delta_y[1] := 100;
	END_IF;

	IF VIS2MM.iSet_FC_Testmode = 4 AND OUT_GR.tGR2CU.bLFSM_Test_On AND NOT IN_GR.bSet_LFSM_Test_COn THEN					(* If testmode is set to 4 use manual input of frequency *)
		rF_LFSM_curve := VIS2MM.rFAct_FSM_ManualTest;
	ELSIF VIS2MM.iSet_FC_Testmode = 4 AND OUT_GR.tGR2CU.bLFSM_Test_On AND IN_GR.bSet_LFSM_Test_COn THEN						(* If testmode is set to 4 and test start via Bus, use frequency input from Bus *)
		rF_LFSM_curve := IN_GR.rF_Act_FSM_Test_Ext; 
	ELSE
		rF_LFSM_curve := IN_GR.rF_Act;													(* Use Busbar frequency or simulated frequency of testmode *) 
	END_IF;	

	IF (rF_LFSM_curve < (OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMO_GrC_DB_pos) AND MM2VIS.bLFSMO_active) THEN		(* Freeze Set power when exceeding deadband of LFSMO *) 	
		rP_Set_Unred_Freeze_FSM := IN_GR.rP_Set_Unred_Norm_ohne_FC;
	END_IF;
	
	IF OUT_GR.tGR2CU.rFSMU_GRC_DB <  rF_LFSMU_GrC_DB_neg THEN							(* Frequency Deadband of LFSMU mus be bigger then Deadband of FSMU - otherwise equalize  *)
		rF_LFSMU_GrC_DB_neg := OUT_GR.tGR2CU.rFSMO_GRC_DB;
	END_IF;
	
	IF OUT_GR.tGR2CU.rFSMO_GRC_DB > rF_LFSMO_GrC_DB_pos THEN							(* Frequency Deadband of LFSMO mus be bigger then Deadband of FSMO - otherwise equalize *)
		rF_LFSMO_GrC_DB_pos := OUT_GR.tGR2CU.rFSMO_GRC_DB;
	END_IF;

	iF_LFSM_curve := REAL_TO_INT(rF_LFSM_curve * 100);//Le								(* use INT for proper compare operations *)
	iFNom_LFSM_Ref := REAL_TO_INT(OUT_GR.tGR2CU.rFNom_LFSM_Ref * 100);//Le
	iF_LFSMU_GrC_DB_neg := REAL_TO_INT(rF_LFSMU_GrC_DB_neg * 100);//Le
	iF_LFSMO_GrC_DB_pos := REAL_TO_INT(rF_LFSMO_GrC_DB_pos * 100);//Le
	(*************************************)
	(* 	  Visualization figure FSM  *)
	(*************************************)
 
	IF      OUT_GR.tGR2CU.bSet_GrC_FSM 		 											(* Calculate points of FSM-curve if function is switched on *)
		AND ((OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref) <> 0)
        AND ((OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref) <> 0) THEN
				
		IF NOT Para.bSet_GrC_LFSMU_COn THEN												(* First point of FSM-curve depends on wether if LFSMU is switched ON or OFF *)				
			tFSMPoints[0].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref - 2;
		ELSE
			tFSMPoints[0].x := tLFSMUPoints[0].x;
		END_IF;
		(* X-Point 1 dependant on FSM Limit positive*)
		IF rP_FC_Delta_MxPos <> 1.0 THEN
			IF NOT Para.bSet_FC_StepOn THEN
				tFSMPoints[1].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref - (rP_FC_Delta_MxPos * OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref + OUT_GR.tGR2CU.rFSMU_GRC_DB);
			ELSE
				tFSMPoints[1].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref - (rP_FC_Delta_MxPos * OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref);
			END_IF;
			
			IF Para.bSet_GrC_LFSMU_COn THEN
				tFSMPoints[1].x := MAX(OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMU_GrC_DB_neg, tFSMPoints[1].x);
			END_IF;
		ELSE
			tFSMPoints[1].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref - OUT_GR.tGR2CU.rFSMU_GRC_DB; 
		END_IF;
		tFSMPoints[2].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref - OUT_GR.tGR2CU.rFSMU_GRC_DB;
		tFSMPoints[3].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref - OUT_GR.tGR2CU.rFSMU_GRC_DB;
		tFSMPoints[4].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		tFSMPoints[5].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + OUT_GR.tGR2CU.rFSMO_GRC_DB;
		tFSMPoints[6].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + OUT_GR.tGR2CU.rFSMO_GRC_DB;
		(* X-Point 7 dependant on FSM Limit negative*)
		IF rP_FC_Delta_MxNeg <> -1.0 THEN
			IF NOT Para.bSet_FC_StepOn THEN
				tFSMPoints[7].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + (-rP_FC_Delta_MxNeg * OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref + OUT_GR.tGR2CU.rFSMO_GRC_DB);
			ELSE
				tFSMPoints[7].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + (-rP_FC_Delta_MxNeg * OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref);
			END_IF;
			
			IF Para.bSet_GrC_LFSMO_COn THEN
				tFSMPoints[7].x := MIN(tFSMPoints[7].x, OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMO_GrC_DB_pos);
			END_IF;
		ELSE
			tFSMPoints[7].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + OUT_GR.tGR2CU.rFSMO_GRC_DB;
		END_IF;
		
		IF NOT Para.bSet_GrC_LFSMO_COn THEN												(* Last point of FSM-curve depends on wether if LFSMO is switched ON or OFF *)	
			tFSMPoints[8].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + 2;
		ELSIF Para.bSet_GrC_LFSMO_COn THEN
			tFSMPoints[8].x := tLFSMOPoints[0].x;
		END_IF;
		
		IF NOT Para.bSet_FC_StepOn THEN													(* Calculate FSM points if Power step recovery is deactived *)
			IF NOT Para.bSet_GrC_LFSMU_COn THEN
				tFSMPoints[0].y := (((2 * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100) - (((OUT_GR.tGR2CU.rFSMU_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);			
			ELSIF Para.bSet_GrC_LFSMU_COn THEN
				tFSMPoints[0].y := (((-rF_LFSMU_GrC_DB_neg * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) *100) - (((OUT_GR.tGR2CU.rFSMU_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);
			END_IF;
			(* Y-Points 0 and 1 limited to FSM Lim pos and neg *)
			tFSMPoints[0].y := LIMIT(rP_FC_Delta_MxNeg * 100, tFSMPoints[0].y, rP_FC_Delta_MxPos * 100);
			IF rP_FC_Delta_MxPos <> 1.0 THEN
				tFSMPoints[1].y := MIN(rP_FC_Delta_MxPos * 100, tFSMPoints[0].y);
			ELSE
				tFSMPoints[1].y := 0.0;
			END_IF;
			tFSMPoints[2].y := 0;
			tFSMPoints[3].y := 0;
			tFSMPoints[4].y := 0;
			tFSMPoints[5].y := 0;
			tFSMPoints[6].y := 0;
			
			IF NOT Para.bSet_GrC_LFSMO_COn THEN
				tFSMPoints[8].y := (((-2 * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100) + (((OUT_GR.tGR2CU.rFSMO_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);
			ELSIF Para.bSet_GrC_LFSMO_COn THEN
				tFSMPoints[8].y := (((-rF_LFSMO_GrC_DB_pos * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) *100) + (((OUT_GR.tGR2CU.rFSMO_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);
			END_IF;
			(* Y-Points 7 and 8 limited to FSM Lim pos and neg *)
			tFSMPoints[8].y := LIMIT(rP_FC_Delta_MxNeg * 100, tFSMPoints[8].y, rP_FC_Delta_MxPos * 100);
			IF rP_FC_Delta_MxNeg <> -1.0 THEN
				tFSMPoints[7].y := MAX(rP_FC_Delta_MxNeg * 100,tFSMPoints[8].y);
			ELSE
				tFSMPoints[7].y := 0.0;
			END_IF;
			
		ELSIF Para.bSet_FC_StepOn THEN													(* Calculate FSM points if Power step recovery is actived *)
			IF NOT Para.bSet_GrC_LFSMU_COn THEN
				tFSMPoints[0].y := ((2 * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) *100;
			ELSIF Para.bSet_GrC_LFSMU_COn THEN
				tFSMPoints[0].y := ((-rF_LFSMU_GrC_DB_neg * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100;
			END_IF;
			(* Y-Points 0 and 1 limited to FSM Lim pos and neg *)
			tFSMPoints[0].y := LIMIT(rP_FC_Delta_MxNeg * 100, tFSMPoints[0].y, rP_FC_Delta_MxPos * 100);
			IF rP_FC_Delta_MxPos <> 1.0 THEN
				tFSMPoints[1].y := MIN(rP_FC_Delta_MxPos * 100, tFSMPoints[0].y);
			ELSE
			tFSMPoints[1].y := ((OUT_GR.tGR2CU.rFSMU_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100;
			END_IF;
			tFSMPoints[2].y := ((OUT_GR.tGR2CU.rFSMU_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100;
			tFSMPoints[2].y := LIMIT(rP_FC_Delta_MxNeg * 100, tFSMPoints[2].y, rP_FC_Delta_MxPos * 100);
			tFSMPoints[3].y := 0;
			tFSMPoints[4].y := 0;
			tFSMPoints[5].y := 0;
			tFSMPoints[6].y := ((-OUT_GR.tGR2CU.rFSMO_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100;
			tFSMPoints[6].y := LIMIT(rP_FC_Delta_MxNeg * 100, tFSMPoints[6].y, rP_FC_Delta_MxPos * 100);

			IF NOT Para.bSet_GrC_LFSMO_COn THEN
				tFSMPoints[8].y := ((-2 * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) *100;
			ELSIF Para.bSet_GrC_LFSMO_COn THEN
				tFSMPoints[8].y := ((-rF_LFSMO_GrC_DB_pos * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100;
			END_IF;
			(* Y-Points 7 and 8 limited to FSM Lim pos and neg *)
			tFSMPoints[8].y := LIMIT(rP_FC_Delta_MxNeg * 100, tFSMPoints[8].y, rP_FC_Delta_MxPos * 100);
			IF rP_FC_Delta_MxNeg <> -1.0 THEN
				tFSMPoints[7].y := MAX(rP_FC_Delta_MxNeg * 100,tFSMPoints[8].y);
			ELSE
				tFSMPoints[7].y := ((-OUT_GR.tGR2CU.rFSMO_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100;
			END_IF;
			tFSMPoints[7].y := LIMIT(rP_FC_Delta_MxNeg * 100, tFSMPoints[7].y, rP_FC_Delta_MxPos * 100);
		END_IF;
	ELSE
		FOR iLoopCnP:=0 TO 8 DO															(* Set points of FSM-curve to zero if FSM function is deactivated *)	
			tFSMPoints[iLoopCnP].x := 0;
			tFSMPoints[iLoopCnP].y := 0;
		END_FOR;
	END_IF;

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

	(*curves*)

	FOR iLoopCnP:=0 TO 8 DO																(* Hand over points of FSM-curve to VIS *)
		MM2VIS.rF_FSMPoints_x[iLoopCnP] := tFSMPoints[iLoopCnP].x;
		MM2VIS.rP_FSMPoints_y[iLoopCnP] := tFSMPoints[iLoopCnP].y;
	END_FOR;
    		

	(*************************************)
	(* 	  Visualization figure LFSMO  *)
	(*************************************)

	IF 		Para.bSet_GrC_LFSMO_COn 													(* Calculate points of LFSMO-curve if function is switched on *)
   		AND ((OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref) <> 0)
        AND ((OUT_GR.tGR2CU.rFNom_LFSM_Ref  * rDroop_GrC_LFSMO_pos)         <> 0) THEN

		IF NOT OUT_GR.tGR2CU.bSet_GrC_FSM THEN											(* First point of LFSMO-curve depends on wether if FSM is switched ON or OFF *)
			tLFSMOPoints[0].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		ELSE 
			tLFSMOPoints[0].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMO_GrC_DB_pos;
		END_IF;
		tLFSMOPoints[1].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMO_GrC_DB_pos;
		tLFSMOPoints[2].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + 2;
		(* Y-Points 0 and 1 limited to FSM Lim pos and neg *)
		IF OUT_GR.tGR2CU.bSet_GrC_FSM AND NOT Para.bSet_FC_StepOn THEN					(* Calculate LFSMO points if FSM is activated and Power step recovery is deactived *)				
			tLFSMOPoints[0].y := (((-rF_LFSMO_GrC_DB_pos * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref))*100) + (((OUT_GR.tGR2CU.rFSMO_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100); 
			tLFSMOPoints[0].y := LIMIT(rP_FC_Delta_MxNeg * 100, tLFSMOPoints[0].y, rP_FC_Delta_MxPos * 100);
			tLFSMOPoints[1].y := (((-rF_LFSMO_GrC_DB_pos * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref))*100) + (((OUT_GR.tGR2CU.rFSMO_GRC_DB * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);
			tLFSMOPoints[1].y := LIMIT(rP_FC_Delta_MxNeg * 100, tLFSMOPoints[1].y, rP_FC_Delta_MxPos * 100);
			IF Para.bLFSM_GrC_Pref THEN
				tLFSMOPoints[2].y := tLFSMOPoints[1].y - (1 * ((ABS(2 - rF_LFSMO_GrC_DB_pos) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMO_pos)));	
			ELSE
				tLFSMOPoints[2].y := tLFSMOPoints[1].y - (rP_Set_Unred_Freeze * ((ABS(2 - rF_LFSMO_GrC_DB_pos) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMO_pos)));
			END_IF;
		ELSIF OUT_GR.tGR2CU.bSet_GrC_FSM AND Para.bSet_FC_StepOn THEN					(* Calculate LFSMO points if FSM is activated and Power step recovery is actived *)
			tLFSMOPoints[0].y := (((-rF_LFSMO_GrC_DB_pos * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref))*100); 
			tLFSMOPoints[0].y := LIMIT(rP_FC_Delta_MxNeg * 100, tLFSMOPoints[0].y, rP_FC_Delta_MxPos * 100);
			tLFSMOPoints[1].y := (((-rF_LFSMO_GrC_DB_pos * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMO * OUT_GR.tGR2CU.rFNom_LFSM_Ref))*100);
			tLFSMOPoints[1].y := LIMIT(rP_FC_Delta_MxNeg * 100, tLFSMOPoints[1].y, rP_FC_Delta_MxPos * 100);
			IF Para.bLFSM_GrC_Pref THEN
				tLFSMOPoints[2].y := tLFSMOPoints[1].y - (1 * ((ABS(2 - rF_LFSMO_GrC_DB_pos) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMO_pos)));
			ELSIF NOT Para.bLFSM_GrC_Pref THEN
				IF (rF_LFSM_curve > (OUT_GR.tGR2CU.rFNom_LFSM_Ref + rDroop_GrC_LFSMO_pos)) THEN
					tLFSMOPoints[2].y := tLFSMOPoints[1].y - (rP_Set_Unred_Freeze * ((ABS(2 - rF_LFSMO_GrC_DB_pos) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMO_pos)));
				ELSE 
					tLFSMOPoints[2].y := tLFSMOPoints[1].y - (1 * ((ABS(2 - rF_LFSMO_GrC_DB_pos) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMO_pos)));
				END_IF;
			END_IF;
		ELSIF NOT OUT_GR.tGR2CU.bSet_GrC_FSM THEN										(* Calculate LFSMO points if FSM is deactivated *)
			tLFSMOPoints[0].y := 0; 
			tLFSMOPoints[1].y := 0;
			IF Para.bLFSM_GrC_Pref THEN
				tLFSMOPoints[2].y := - (1 * ((ABS(2 - rF_LFSMO_GrC_DB_pos) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMO_pos)));
			ELSE	
				tLFSMOPoints[2].y := - (rP_Set_Unred_Freeze * ((ABS(2 - rF_LFSMO_GrC_DB_pos) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMO_pos)));
			END_IF;
		END_IF;
	ELSE	
		FOR iLoopCnP:=0 TO 2 DO															(* Set points of LFSMO-curve to zero if LFSMO function is deactivated *)
			tLFSMOPoints[iLoopCnP].x := 0;
			tLFSMOPoints[iLoopCnP].y := 0;
		END_FOR;
	END_IF;


	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

	(*curves*)
	FOR iLoopCnP:=0 TO 2 DO																(* Hand over points of LFSMO-curve to VIS *)
		IF Para.bSet_GrC_LFSMO_COn THEN
		MM2VIS.rF_LFSMOPoints_x[iLoopCnP] := tLFSMOPoints[iLoopCnP].x;
			(* Calculate Offset of LFSMO-curve in dependency of power margin *)
			IF IN_GR.rP_Set_Unred_Norm_ohne_FC > (1 - OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos) AND (rF_LFSM_curve > (OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMO_GrC_DB_pos)) AND OUT_GR.tGR2CU.bSet_GrC_FSM THEN
				rP_Offset_LFSMO_Marg := (IN_GR.rP_Set_Unred_Norm_ohne_FC - (1 - OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos)) * 100;
			ELSIF IN_GR.rP_Set_Unred_Norm_ohne_FC < (IN_GR.rP_Set_Min_Norm + OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg) AND (rF_LFSM_curve > (OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMO_GrC_DB_pos)) AND OUT_GR.tGR2CU.bSet_GrC_FSM THEN
			   	rP_Offset_LFSMO_Marg := (IN_GR.rP_Set_Unred_Norm_ohne_FC - (IN_GR.rP_Set_Min_Norm + OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg)) * 100;
			ELSE 
				rP_Offset_LFSMO_Marg := 0;
			END_IF;
			
			IF (iF_LFSM_curve > (iFNom_LFSM_Ref + iF_LFSMO_GrC_DB_pos)) AND NOT Para.bLFSM_StaticFSMDeadband THEN//Le
				MM2VIS.rP_LFSMOPoints_y[iLoopCnP] := tLFSMOPoints[iLoopCnP].y - (tFSMPoints[8].y + rP_Offset_LFSM_Pref) + rP_Offset_LFSMO_Marg;
			ELSE	
				MM2VIS.rP_LFSMOPoints_y[iLoopCnP] := tLFSMOPoints[iLoopCnP].y;
			END_IF;		
		ELSE		
			MM2VIS.rF_LFSMOPoints_x[iLoopCnP] := 0;
			MM2VIS.rP_LFSMOPoints_y[iLoopCnP] := 0;
		END_IF;
	END_FOR;

	(*************************************)
	(* 	  Visualization figure LFSM-U  *)
	(*************************************)

	IF		Para.bSet_GrC_LFSMU_COn 													(* Calculate points of LFSMU-curve if function is switched on *)	
		AND ((OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref) <> 0)
        AND ((OUT_GR.tGR2CU.rFNom_LFSM_Ref  * rDroop_GrC_LFSMU_neg)         <> 0) THEN

		IF NOT OUT_GR.tGR2CU.bSet_GrC_FSM THEN											(* First point of LFSMU-curve depends on wether if FSM is switched ON or OFF *)
			tLFSMUPoints[0].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref;
		ELSE
			tLFSMUPoints[0].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMU_GrC_DB_neg;
		END_IF;	
		tLFSMUPoints[1].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMU_GrC_DB_neg;
		tLFSMUPoints[2].x := OUT_GR.tGR2CU.rFNom_LFSM_Ref - 2;
		(* Y-Points 0 and 1 limited to FSM Lim pos and neg *)
		IF OUT_GR.tGR2CU.bSet_GrC_FSM AND NOT Para.bSet_FC_StepOn THEN 					(* Calculate LFSMU points if FSM is activated and Power step recovery is deactived *)
			tLFSMUPoints[0].y := (((-rF_LFSMU_GrC_DB_neg * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) *100) - (((OUT_GR.tGR2CU.rFSMU_GRC_DB *1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);
			tLFSMUPoints[0].y := LIMIT(rP_FC_Delta_MxNeg * 100, tLFSMUPoints[0].y, rP_FC_Delta_MxPos * 100);
			tLFSMUPoints[1].y := (((-rF_LFSMU_GrC_DB_neg * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) *100) - (((OUT_GR.tGR2CU.rFSMU_GRC_DB *1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);
			tLFSMUPoints[1].y := LIMIT(rP_FC_Delta_MxNeg * 100, tLFSMUPoints[1].y, rP_FC_Delta_MxPos * 100);
			tLFSMUPoints[2].y := (1 * ((ABS(-2 - rF_LFSMU_GrC_DB_neg) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMU_neg))) + tLFSMUPoints[1].y;
			
		ELSIF OUT_GR.tGR2CU.bSet_GrC_FSM AND Para.bSet_FC_StepOn THEN					(* Calculate LFSMU points if FSM is activated and Power step recovery is actived *)
			tLFSMUPoints[0].y := (((-rF_LFSMU_GrC_DB_neg * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);
			tLFSMUPoints[0].y := LIMIT(rP_FC_Delta_MxNeg * 100, tLFSMUPoints[0].y, rP_FC_Delta_MxPos * 100);
			tLFSMUPoints[1].y := (((-rF_LFSMU_GrC_DB_neg * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100);
			tLFSMUPoints[1].y := LIMIT(rP_FC_Delta_MxNeg * 100, tLFSMUPoints[1].y, rP_FC_Delta_MxPos * 100);
			tLFSMUPoints[2].y := (1 * ((ABS(-2 -rF_LFSMU_GrC_DB_neg) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMU_neg)) +  (((-rF_LFSMU_GrC_DB_neg * 1) / (OUT_GR.tGR2CU.rDroop_GrC_FSMU * OUT_GR.tGR2CU.rFNom_LFSM_Ref)) * 100));
			tLFSMUPoints[2].y := (1 * ((ABS(-2 -rF_LFSMU_GrC_DB_neg) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMU_neg)) +  tLFSMUPoints[1].y);
		ELSIF NOT OUT_GR.tGR2CU.bSet_GrC_FSM THEN										(* Calculate LFSMU points if FSM is deactivated *)
			tLFSMUPoints[0].y := 0;
			tLFSMUPoints[1].y := 0;
			tLFSMUPoints[2].y := (1 * ((ABS(- 2 - rF_LFSMU_GrC_DB_neg) * 100) / (OUT_GR.tGR2CU.rFNom_LFSM_Ref * rDroop_GrC_LFSMU_neg)));
		END_IF;
	ELSE
		FOR iLoopCnP:=0 TO 2 DO															(* Set points of LFSMU-curve to zero if LFSMO function is deactivated *)
			tLFSMUPoints[iLoopCnP].x := 0;
			tLFSMUPoints[iLoopCnP].y := 0;
		END_FOR;
	END_IF;

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

	(*curves*)
	FOR iLoopCnP:=0 TO 2 DO																(* Hand over points of LFSMO-curve to VIS *)
		IF Para.bSet_GrC_LFSMU_COn THEN
			MM2VIS.rF_LFSMUPoints_x[iLoopCnP] := tLFSMUPoints[iLoopCnP].x;	
			(* Calculate Offset of LFSMU-curve in dependency of power margin *)
			IF IN_GR.rP_Set_Unred_Norm_ohne_FC > (1 - OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos) AND (rF_LFSM_curve < (OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMU_GrC_DB_neg)) AND OUT_GR.tGR2CU.bSet_GrC_FSM THEN
				rP_Offset_LFSMU_Marg := (IN_GR.rP_Set_Unred_Norm_ohne_FC - (1 - OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos)) * 100;
			ELSIF IN_GR.rP_Set_Unred_Norm_ohne_FC < (IN_GR.rP_Set_Min_Norm + OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg) AND (rF_LFSM_curve < (OUT_GR.tGR2CU.rFNom_LFSM_Ref + rF_LFSMU_GrC_DB_neg)) AND OUT_GR.tGR2CU.bSet_GrC_FSM THEN
				rP_Offset_LFSMU_Marg := (IN_GR.rP_Set_Unred_Norm_ohne_FC - (IN_GR.rP_Set_Min_Norm + OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg)) * 100;
			ELSE 
				rP_Offset_LFSMU_Marg := 0;
			END_IF;
			
			IF (iF_LFSM_curve < (iFNom_LFSM_Ref + iF_LFSMU_GrC_DB_neg)) AND NOT Para.bLFSM_StaticFSMDeadband THEN//Le
				MM2VIS.rP_LFSMUPoints_y[iLoopCnP] := tLFSMUPoints[iLoopCnP].y - (tFSMPoints[0].y + rP_Offset_LFSM_Pref) + rP_Offset_LFSMU_Marg;
			ELSE	
				MM2VIS.rP_LFSMUPoints_y[iLoopCnP] := tLFSMUPoints[iLoopCnP].y;
			END_IF;	
		ELSE
			MM2VIS.rF_LFSMUPoints_x[iLoopCnP] := 0;
			MM2VIS.rP_LFSMUPoints_y[iLoopCnP] := 0;
		END_IF;
	END_FOR;

	(*************************************)
	(* 	  Actual operation point  *)
	(*************************************)

	IF 	VIS2MM.bLFSM_TestStart AND NOT IN_GR.bSet_LFSM_Test_COn AND VIS2MM.iSet_FC_Testmode = 4 THEN							(* Set frequency of operation point *)
		MM2VIS.rF_FSMLFSM_Act_x := VIS2MM.rFAct_FSM_ManualTest;
	ELSIF IN_GR.bSet_LFSM_Test_COn AND VIS2MM.iSet_FC_Testmode = 4 THEN
		MM2VIS.rF_FSMLFSM_Act_x := IN_GR.rF_Act_FSM_Test_Ext;
	ELSE
		MM2VIS.rF_FSMLFSM_Act_x := IN_GR.rF_Act;
	END_IF;
	(* Calculate offset of operation point if margin is active *)	
	IF (rF_LFSM_curve < (OUT_GR.tGR2CU.rFNom_LFSM_Ref + OUT_GR.tGR2CU.rFSMO_GRC_DB) AND rF_LFSM_curve > (OUT_GR.tGR2CU.rFNom_LFSM_Ref - OUT_GR.tGR2CU.rFSMU_GRC_DB)) AND OUT_GR.tGR2CU.bSet_GrC_FSM	THEN
		IF IN_GR.rP_Set_Unred_Norm_ohne_FC > (1 - OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos) THEN
			rP_Offset_FSM_Marg := IN_GR.rP_Set_Unred_Norm_ohne_FC - IN_GR.rP_Act_Norm_Filt;
		ELSIF IN_GR.rP_Set_Unred_Norm_ohne_FC < (IN_GR.rP_Set_Min_Norm + OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg) THEN
			rP_Offset_FSM_Marg := IN_GR.rP_Set_Unred_Norm_ohne_FC - IN_GR.rP_Act_Norm_Filt;
		ELSE 
			rP_Offset_FSM_Marg := 0;
		END_IF;
	ELSIF (rF_LFSM_curve > (OUT_GR.tGR2CU.rFNom_LFSM_Ref + OUT_GR.tGR2CU.rFSMO_GRC_DB) OR rF_LFSM_curve < (OUT_GR.tGR2CU.rFNom_LFSM_Ref - OUT_GR.tGR2CU.rFSMU_GRC_DB)) AND OUT_GR.tGR2CU.bSet_GrC_FSM THEN
		IF IN_GR.rP_Set_Unred_Norm_ohne_FC > (1 - OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos) THEN
			rP_Offset_FSM_Marg := IN_GR.rP_Set_Unred_Norm_ohne_FC - (1 - OUT_GR.tGR2CU.rMarg_GrC_FSM_Pos);	
		ELSIF IN_GR.rP_Set_Unred_Norm_ohne_FC < (IN_GR.rP_Set_Min_Norm + OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg) THEN
			rP_Offset_FSM_Marg := IN_GR.rP_Set_Unred_Norm_ohne_FC - (IN_GR.rP_Set_Min_Norm + OUT_GR.tGR2CU.rMarg_GrC_FSM_Neg);
		ELSE 
			rP_Offset_FSM_Marg := 0;
		END_IF;
	ELSE 
			rP_Offset_FSM_Marg := 0;
	END_IF;		
	(* Calculate offset of operation point in when the frequency leaves the FSM  range *)
	IF (iF_LFSM_curve > (iFNom_LFSM_Ref + iF_LFSMO_GrC_DB_pos)) OR (iF_LFSM_curve < (iFNom_LFSM_Ref + iF_LFSMU_GrC_DB_neg)) THEN//Le
		rP_Offset_LFSM_Pref := (rP_Set_Unred_Freeze_FSM - rP_Set_Unred_Freeze) * 100;
	ELSE
		rP_Offset_LFSM_Pref := 0;
	END_IF;

	IF (iF_LFSM_curve > (iFNom_LFSM_Ref + iF_LFSMO_GrC_DB_pos)) AND NOT Para.bLFSM_StaticFSMDeadband THEN //Le
		rP_Offset_FSMLFSM := MM2VIS.rP_LFSMOPoints_y[0];
	ELSIF (iF_LFSM_curve < (iFNom_LFSM_Ref + iF_LFSMU_GrC_DB_neg)) AND NOT Para.bLFSM_StaticFSMDeadband THEN //Le
		rP_Offset_FSMLFSM := MM2VIS.rP_LFSMUPoints_y[0];
	ELSE 
		rP_Offset_FSMLFSM := 0;
	END_IF;
	
	IF IN_GR.tGCB_On.Di THEN						(* Display operation point only when GCB is closed *)
		IF (iF_LFSM_curve > (iFNom_LFSM_Ref + iF_LFSMO_GrC_DB_pos)) AND Para.bSet_GrC_LFSMO_COn THEN //Le
			MM2VIS.rP_FSMLFSM_Act_y := (IN_GR.rP_Act_Norm_Filt - rP_Set_Unred_Freeze) * 100 + rP_Offset_FSMLFSM;
		ELSIF (iF_LFSM_curve < (iFNom_LFSM_Ref + iF_LFSMU_GrC_DB_neg)) AND Para.bSet_GrC_LFSMU_COn THEN //Le
			MM2VIS.rP_FSMLFSM_Act_y := (IN_GR.rP_Act_Norm_Filt - rP_Set_Unred_Freeze) * 100 + rP_Offset_FSMLFSM;
		ELSE
			MM2VIS.rP_FSMLFSM_Act_y := (IN_GR.rP_Act_Norm_Filt - IN_GR.rP_Set_Unred_Norm_ohne_FC + rP_Offset_FSM_Marg) * 100;
		END_IF;
	ELSE 
		MM2VIS.rP_FSMLFSM_Act_y := 0;
	END_IF;
	
	IF NOT IN_GR.tGCB_On.Di THEN
		MM2VIS.rF_FSMLFSM_Act_x := 0;
		MM2VIS.rP_FSMLFSM_Act_y := 0;
	ELSIF NOT OUT_GR.tGR2CU.bSet_GrC_FSM AND NOT Para.bSet_GrC_LFSMO_COn AND NOT Para.bSet_GrC_LFSMU_COn THEN
		MM2VIS.rF_FSMLFSM_Act_x := 0;
		MM2VIS.rP_FSMLFSM_Act_y := 0;
	END_IF;
	
	(*********************)
	(* 	  VISUALISATION  *)
	(*********************)
		
	//	MM2VIS.rPFP_Set			:= rCosPhi_P_Set;
	//	MM2VIS.tPFP_Points		:= tcosphi_P_Points;	
	//	MM2VIS.rPFP_x			:= tcosphi_P_Cur.x;
	//	MM2VIS.iPFP_NoOfPoints	:= iPFP_NoOfPoints;
	//
	//	MM2VIS.rPFC_Set			:= rPFC_Set;
	//	MM2VIS.tPFC_Points		:= tPFC_Points;	
	//	MM2VIS.tPFC_Points2		:= tPFC_Points2;	
	//	MM2VIS.rPFC_x			:= tPFC_Cur.x;
	//	MM2VIS.iPFC_NoOfPoints	:= iPFC_NoOfPoints;
	//
	//	MM2VIS.rQU_Set			:= rQU_Set;
	//	MM2VIS.tQU_Points		:= tQU_Points;	
	//	MM2VIS.tQU_Points2		:= tQU_Points2;	
	//	MM2VIS.rQU_x			:= tQU_Cur.x;
	//	MM2VIS.rU_ActV			:= rU_ActV;
	//	MM2VIS.iQU_NoOfPoints	:= iQU_NoOfPoints;
	//
	//	MM2VIS.rPF_Q_U_Set		:= rPF_Q_U_Set;
	//	MM2VIS.rPF_U_Set		:= rPF_U_Set;
	//	MM2VIS.tPFU_Points		:= tPFU_Points;	
	//	MM2VIS.tPFU_Points2		:= tPFU_Points2;	
	//	MM2VIS.rPFU_x			:= tPFU_Cur.x;
	//	MM2VIS.iPFU_NoOfPoints	:= iPFU_NoOfPoints;

	(***************************************************)
	(***** (B E T W E E N) -   R E S U L T S  **********)
	(***************************************************)
	(* cos(phi) = f(P) *)
	rQP_PF_Set;
	(*cos(phi) = f(U) *)
	rQU_PF_Set;
	(* Q(U) *)
	rQU_Set;
	(* Q(P) *)
	rQP_Set;
	(* PFC/RMC *)
	rP_LFSM_Delta;
END_PROGRAM