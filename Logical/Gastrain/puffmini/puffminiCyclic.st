(* Verpuffungsminimierung, Freigabe Gasventile

VER	Date/Name	New
V0.10	29.06.07/Wa	generated
V0.20	20.02.08/LH	implemented into X20-system 
V0.20.1	25.03.08/LH	renamed task from "puffmini_tc1" to "puffmini", 
 			        name has to be maximum 8 characters!
V2.32.0	16.06.2008	lettenbichler	RUHE_M, RUHE_A removed, PILZ-SIGMA=standard
V2.33.0	17.07.2008	lettenbichler	GASV1_1, GASV1_2 added
V2.34.0	14.10.2008	lettenbichler	ZM_FG3_GASV: AB_NS, IN_GT.bRel_Island added
.					FG1_GASV: DI_GEN_PT added
V2.50.0	29.01.2009 	lettenb.		DI_GEN_PT -> IN_GT.tGenPrctTrip_TC2
.	    10.02.2009	puff_mini removed	
V3.20.0	01.07.2010	lettenb.		port injection added
.			        maier (BuR)	DI_GCB_ON_TC1 replaced with GCB_ON_TC1
.			        maier (BuR)	DI_MCB_ON_TC1 replaced with IN_GT.tMCB_On_TC2
.	    21.10.2010  lettenb.    OUT_GT.tPCG_GV_DelOpen added
V3.99.0	21-09-2013	Ganguly/Denk	generated for modular software 
V3.99.1 20.02.2013	Denk	V3.30 changes inserted 
V3.99.2	20.02.2013	Denk 	Bugfix IN_GT.bMnsOK added in (IN_GT.tMnsOk_TC2.Di AND IN_GT.bMnsOk)

V04.03.00	13.11.2014	Denk		Bugfix, OUT_GT.tGV1_line1_Open.Do - OUT_GT.tGV1_line4_Open.Do added 
			08.01.2015	Denk		Porting J920 to XT4
			31.03.2015	Denk 		Bugfix, assignment of OUT_GT.tGV1_line3_Open.Do, OUT_GT.tGV1_line4_Open.Do
V4.04.00	19.09.2016	Perktold	Bypass für FG-Gasventile bei Öffnen des GCB durch "tGrC_DCon.Do"
V4.05.00	08.01.2018	Denk		J-Maps finding, IN_GT.bEng_Start changed to IN_GT.bEng_Start_TC2
V4.12.00	10.03.2023	Perktold 	Bugfix - Bypass für FG-Gasventile bei Öffnen des GCB durch "tGrC_DCon.Do"
V4.13.00	30.11.2023	Goenczi 	Hold gas valve open in special cases, e.g. GCB at Customer
V4.14.00	22.11.2024	Schmidt 	Added pre chamber gas bypass valve logic (load acceptance improvements)
			09.04.2025	Perktold	Added GV3_Open and GV4_Open for SafetyPLC inputs
V4.25.00	14.01.2026	Tinello		Added DCGA output for SafetyPLC
*)

PROGRAM _CYCLIC

	xGR_MAXR_M_DR_ODR.In := IN_GT.rN_EngAct;
	xGR_MAXR_M_DR_ODR.Gw := Para.rN_EOP_Lim1;	
	xGR_MAXR_M_DR_ODR.Hy := 10.0;
	xGR_MAXR_M_DR_ODR();	
	M_DR_ODR := IN_GT.tPB2MM.bParaSetupOk AND xGR_MAXR_M_DR_ODR.Q;
		
	xGR_MAXR_FA_AN_FGPUFF.In := IN_GT.rP_Act_Norm_Filt;
	xGR_MAXR_FA_AN_FGPUFF.Hy := Para.rP_DeflagPrct_Hy;
	xGR_MAXR_FA_AN_FGPUFF.Gw := Para.rDeflagPrct_Lim;
	xGR_MAXR_FA_AN_FGPUFF();
	AN_FGPUFF := xGR_MAXR_FA_AN_FGPUFF.Q AND IN_GT.tPB2MM.bParaSetupOk;

	(* speed limit *)
	xGR_MAXR_D1400(In:= IN_GT.rN_EngAct, Gw:= (Para.rN_EngNom - 100.0), Hy:= 10.0);
	M_D1400	:= xGR_MAXR_D1400.Q AND IN_GT.tPB2MM.bParaSetupOk;

	(* differential protection monitoring release *)
	xSR_FG_DIFFUW(SET1  := M_D1400,
				  RESET := IN_GT.bEng_Start_TC2 OR (NOT M_D1400 AND NOT OUT_GT.bGV_On AND NOT IN_GT.bEng_Dem AND NOT IN_GT.tGCB_On.Di));	

	(* release gas valves by gcb monitoring:
	differential protection, earth failure, overload/short circuit/Kurzschluss, gen.protection trip(onsite) *)
	FG1_GASV :=(IN_GT.tDiffPrct_TC2.Di OR (NOT xSR_FG_DIFFUW.Q1 AND Para.bPF_CosPCtr_Diff_Ena))    
			AND IN_GT.tGndFailure_TC2.Di
			AND IN_GT.tOlShortCirc_TC2.Di
			AND IN_GT.tGenPrctTrip_TC2.Di;
	
	(* Release gas valve with Main OK (depending on installation) *) 
	FG2_GASV := ((IN_GT.tMnsOk_TC2.Di AND IN_GT.bMnsOk) OR IN_GT.bRel_Island OR IN_GT.bRel_IslandAfMITime OR NOT Para.bSyActive OR Para.bMIF_Enable) 
				AND IN_GT.bRelEngOpFromSy;
	
	(* Detect external switch GS or external switch off mains circuit breaker ( depending on installation) *)
	xF_TRIG_FA_GSAUS.CLK := IN_GT.tGCB_On_TC2.Di;
	xF_TRIG_FA_GSAUS();
	
	xF_TRIG_FA_NSAUS.CLK := IN_GT.tMCB_On_TC2.Di;
	xF_TRIG_FA_NSAUS();
	
	xTP_GrC(IN := NOT IN_GT.tGrC_DCon.Do, PT := tGrC_Bypass);

	(*GCB opening by Customer without GCB command off from DiaNe - GCB control at Customer*)
	IF IN_GT.bGCB_by_Customer AND xF_TRIG_FA_GSAUS.Q THEN
		IF (NOT IN_GT.tP_Lo.Do AND (IN_GT.rP_Act_Norm_Filt < 0.15))		//Power below GCB opening limit
			OR ((xEngType.Type < 6) AND Para.bMisfCont)					//Type 2/3/4 engine with activated Misfire Control
			OR ((xEngType.Type = 6) AND Para.bP_LoadReject_Active)		//Type 6 engine with activated LoadRejection package incl. blow off valve
		THEN
			bHOLD_FG3_GASV	:= 	TRUE;
		ELSE
			bHOLD_FG3_GASV	:= 	FALSE;
		END_IF;
	ELSE
		bHOLD_FG3_GASV	:= 	FALSE;
	END_IF;
	ZM_FG3_GASV := (((xF_TRIG_FA_GSAUS.Q AND NOT xTP_GrC.Q) AND IN_GT.tGCB_COf.Do) AND NOT bHOLD_FG3_GASV) OR
	               (xF_TRIG_FA_NSAUS.Q AND IN_GT.tMCB_COf.Do AND NOT IN_GT.bRel_Island);
				   
	FG3_GASV := NOT ZM_FG3_GASV;
	
	(* Release gas valve (--> Blocking module ) *)
	xTON_FA_FG_GASV.IN := FG1_GASV AND FG2_GASV AND FG3_GASV;
	xTON_FA_FG_GASV.PT := T#1s;
	xTON_FA_FG_GASV();
	OUT_GT.tGV_Rel.Do  := xTON_FA_FG_GASV.Q;
	
	(* Release port injection *)
	OUT_GT.bPortInject_Rel := (GASV1_TC3 OR GASV2_TC3) AND OUT_GT.tGV_Rel.Do;		
	
	(* Close gas valves with Speed < parameter and release gas valves for port injection *)		//Porting J920 to XT4, with XT3: 20.11.2014 Tinello GR_MAX_GASV removed
//	xGR_MAXR_GASV.In := IN_GT.rN_EngAct;
//	xGR_MAXR_GASV.Gw := Para.rN_GV_CloseLimMin;
//	xGR_MAXR_GASV.Hy := 10;
//	xGR_MAXR_GASV();
	FG_GASV_PI       := OUT_GT.bPortInject_Rel;													//Porting J920 to XT4, with XT3: 20.11.2014 Tinello GR_MAX_GASV removed
	
	(* Arrange open outputs *)
	(* Gas valve 1 *)
	OUT_GT.tGV1_Open.Do 	:= GASV1_TC3 AND ((OUT_GT.tGV_Rel.Do AND NOT xEngType.Type9) OR (FG_GASV_PI AND xEngType.Type9 ));
	OUT_GT.tGV1_1_Open.Do 	:= GASV1_TC3 AND ((OUT_GT.tGV_Rel.Do AND NOT xEngType.Type9) OR (FG_GASV_PI AND xEngType.Type9)) AND IN_GT.bSCO_Rel_GV1;
	OUT_GT.tGV1_2_Open.Do 	:= GASV1_TC3 AND ((OUT_GT.tGV_Rel.Do AND NOT xEngType.Type9) OR (FG_GASV_PI AND xEngType.Type9)) AND IN_GT.bSCO_Rel_GV2 AND M_DR_ODR;
	(* Gas valve 1 - lines 1-4 *)
	OUT_GT.tGV1_line1_Open.Do 	:= OUT_GT.tGV1_Open.Do;
	OUT_GT.tGV1_line2_Open.Do 	:= OUT_GT.tGV1_Open.Do AND AKT_Gastrecke1_2;
	OUT_GT.tGV1_line3_Open.Do 	:= OUT_GT.tGV1_Open.Do AND AKT_Gastrecke1_3;
	OUT_GT.tGV1_line4_Open.Do 	:= OUT_GT.tGV1_Open.Do AND AKT_Gastrecke1_4;
	(* Gas valve 2 *)
	OUT_GT.tGV2_Open.Do 	:= GASV2_TC3 AND ((OUT_GT.tGV_Rel.Do AND NOT xEngType.Type9) OR (FG_GASV_PI AND xEngType.Type9));

	(* Gas velve 3/4 - prepared for SafetyPLC input but not used*)
	OUT_GT.tGV3_Open.Do 	:= FALSE;
	OUT_GT.tGV4_Open.Do 	:= FALSE;
	OUT_GT.tDCGA_GV_Open.Do := FALSE;									(* SAFETY PLC *)

	(* Pre chamber gas valve  *)
	OUT_GT.tPCG_GV_Open.Do := VKGV_TC3 AND OUT_GT.tGV_Rel.Do;
	
	(* Pre chamber gas valve stepped power on (in-rush current) *)
	xTON_VKGK2.IN := VKGV_TC3 AND OUT_GT.tGV_Rel.Do;
	xTON_VKGK2.PT := T#0.5s;
	xTON_VKGK2();
	OUT_GT.tPCG_GV_DelOpen.Do := xTON_VKGK2.Q;
	
	(* Pre chamber gas bypass valve - START *)
	(* First-order low-pass filter of measured power *)
	xLCRPT1_P_Act_Filt.enable		:= TRUE;
	xLCRPT1_P_Act_Filt.x			:= IN_GT.tP_Act[1].Unfilt;
	xLCRPT1_P_Act_Filt.t			:= MAX(0.0001, rTau_P_Act_Filt);
	xLCRPT1_P_Act_Filt.y_set 		:= IN_GT.tP_Act[1].Unfilt;
	xLCRPT1_P_Act_Filt.set 			:= NOT IN_GT.tGCB_On_TC2.Di;
	xLCRPT1_P_Act_Filt();
	
	(* Check if the charge pressure is below the barometric pressure *)
	xGR_MINR_p2s_pbaro(In := IN_GT.rPr_Ch_P2s_Avg_UF, Gw := IN_GT.rPr_Baro_Internal, Hy := rHyst_GR_MINR_p2s_pbaro);
	(* Compare filtered and unfiltered power to detect a load acceptance *)
	xR_TRIG_P_Compare(CLK := ((IN_GT.tP_Act[1].Unfilt / MAX(0.0001, IN_GT.rP_Nom)) - (xLCRPT1_P_Act_Filt.y / MAX(0.0001, IN_GT.rP_Nom))) > rP_Norm_Act_Filt_Thresh);
	xTP_P_Compare(IN := xR_TRIG_P_Compare.Q, PT := tP_Compare);
	
	(* If the charge pressure is below the barometric pressure and a load acceptance is detected, the pre chamber gas bypass valve shall be opened. 
	   The pre chamber gas bypass valve shall be closed after the load acceptance, once the volume change in the V-room is reduced again or if the boost pressure exceeds the barometric pressure *)
	IF Para.bPCG_BPV_Active AND xEngType.Type6 AND xOpMode.Island AND IN_GT.tGCB_On_TC2.Di AND OUT_GT.tPCG_GV_Open.Do AND xGR_MINR_p2s_pbaro.Q THEN
		IF xTP_P_Compare.Q THEN
			OUT_GT.tPCG_BPV_Open.Do := TRUE;
		ELSIF OUT_GT.tPCG_BPV_Open.Do AND (IN_GT.rFlow_VR_TJ < rFlow_VR_Thresh) THEN
			OUT_GT.tPCG_BPV_Open.Do := FALSE;
		END_IF;
	ELSE
		OUT_GT.tPCG_BPV_Open.Do := FALSE;
	END_IF;
	(* Pre chamber gas bypass valve - END *)
	
END_PROGRAM
