	(*******************************************************************************
	v_ctr		voltage control and matching for synchronisation (cyclic)
				Offset signal for dig. generator controller for voltage matching
					
	This code is confidential and proprietary to the INNIO Company.
	It may not be used in any form, or reproduced in any manner, without the express
	written permission of the INNIO Company.
	Copyright, INNIO Company, 2021
	
	Customized modifications: -
	------------------------
	 
	History:
	-------
	V0.10	16-07-2007	Wasserer, 	generated
	V3.20.0	11.11.2010	lettenb. 	v_match included into v_ctr for standardization
			07.12.2010	lettenb.	u_adj_speed_a  	:= FALSE = default
	V3.30.0	28.10.2011	Tinello		parameter "nominal frequency" was increased by factor 10
			22.11.2011	Wasserer, 	Auswahl SY mit externe +/- Befehle oder über MMU Berechnung eingefügt					
	V4.00.1 21.05.2014	lettenb.	scaling to V, mA changed, cleanup
	V4.00.2 27.05.2014	lettenb.	workaround, definition of new parameters
			02.07.2014				xSigScal_uoffset_f: Y1:= -0.10, Y2:= 0.10 setted, bugfix
	V4.00.3 29.07.2014				IN_GC.tU_DI_Gen_Inc.Di,IN_GC.tU_DI_Gen_Dec.Di removed(war mit einführung xt4 doppelt angelegt)
	V4.00.4 29.07.2014				bU_plus_MMU,bU_minus_MMU: Eng_Run added(relais taktet ständig bei motorstillstand)(cornee)
	V4.00.5 28.01.2015				voltage adjustment from pb8 included
	V4.03.0 03.08.2015	lettenb.	LIMIT(Para.rU_adj_max_down: -vorzeichen entfernt, bugfix(kirchler peter)
	V4.04.0 31.10.2016				xSigScal_u_offset_V.X1/2, xSigScal_u_offset_mA.X1/2	corr., bugfix(wasserer/rosenheim)
	V4.05.0 13.12.2017				rU_Gen_Diff_Match added for Ctr_Q, write parameter removed(code guide line)		
	V4.05.7 10.10.2018	lettenb.	voltage matching puls duration depending on voltage differenz(kirchmair)
			19.12.2018	Hohensinner	added voltage droop and offset for island mode
	V4.07.0	03.04.2019	Hohensinner replaced voltage set point with actual voltage on HMI working point
	V4.07.1	03.06.2019	Hohensinner deactivated generator controller reset if in droop mode or external voltage setpoint active
	V4.09.0 06.08.2019	lettenb.	OUT_GC.tGenCtrResetSp.Do: IN_GC.tGCB_DVM.Di added, reset unitrol for RSY voltage matching with MSY, bugfix
	V4.11.0 29.09.2021	lettenb.	release voltage control by customer bit IN_GC.bN_U_Set_Ext_On added, bugfix
			11.10.2021	Hohensinner	added reactive power setpoint for voltage droop mode
			21.01.2022	MayerR      External voltage and reactive power for droop mode setpoint with corresponding parameter selection added
	V4.13.0 07.03.2024	Farre,		issue #890, #1089: delete scaling analog input signals and shifted to HalIO

	Instructions for use:
	--------------------

	Outstandings:
	------------

    Description: 
    ==================================================================
    Matching the generator voltage by the analog signal (Offset-Signal) to the digital Generator controller
	Additional offset in "voltage regulated operation:

    Voltage Adjustment:
	Nominal voltage generator from multi measurement unit - PAR
    Generator voltage - Setpoint at 0% PN from PAR
    Generator voltage - Setpoint at 100% PN aus PAR
    Factor for Voltage adjustment speed from PAR 
    Maximum Adjustment range (+/- 10%) from PAR
    
	- during SY Voltage setpoint is increased/decreased
	- Deviation of the Voltage setpoint from nominal voltage is Uoffset
    - Limit the deviation according to the maximum adjustment range
	- Re-calculate the Uoffset to units of the device (mV or mA)

	Beschreibung:	
	===================================================================
	Anpassung der Generatorspannung mithilfe des Analogsignals (Offset-Signal) an den dig. Generatorregler
	Verwendung des Signales aus pf_ctr, pf_cust (diane cos-phi-controller)
	zusätzlicher Offset im "spannungsgeregelten Betrieb"
	
	Spannungsverstellung:
	Nennspannung Generator aus Multimessumformer-PAR
	Soll-Generatorspannung bei 0% PN aus PAR
	Soll-Generatorspannung bei 100% PN aus PAR
	Faktor für Spannungsverstellgeschwindigkeit aus PAR
	max. Verstellbereich ( +/- 10% ) aus PAR
	
	- während SY wird die Sollspannung erhöht/verringert
	- Abweichung der Sollspannung zur Nennspannung entspricht dem Uoffset
	- Limitierung der Abweichung gemäß max. Verstellbereich
	- Umrechnung des Uoffset auf Einheiten der Karte (in mV oder mA)

	Impulsdauer: Anpassung an die Spannungsabweichung, je größer die Abweichung desto länger der Impuls. 
	Maximalwert ist 1500ms was 1,5% entspricht, Minimalwert 150ms was 0,15% entsprich.
	Dadurch hat der Unitrol dann noch 500ms um sich auszuregeln, bevor wir den nächsten Takt freigaben.
	Je weiter wir uns dem Sollwert nähern, desto kürzer wird dann der Impuls.(kirchmair)
			
	*********************************************************************************)
PROGRAM _CYCLIC	

	IF IN_GC.bN_U_Set_Ext_On THEN		(*release voltage control by customer bit(AB energy)*)
		iSrc_U_OffsSet := 2;
	ELSE
		iSrc_U_OffsSet := Para.iSource_U_OffsSet;
	END_IF;
	MM2VIS.iSource_U_OffsSet := iSrc_U_OffsSet;

	(* generator voltage adjustment from Di *)
	OUT_GC.tU_MidPos.Do :=	NOT IN_GC.bGCB_DemSy
						AND NOT IN_GC.bMCB_DemSy
						AND NOT IN_GC.tGCB_DVM.Di
						AND 	Para.bSyActive;
	
	OUT_GC.tU_Plus.Do :=   (IN_GC.bGCB_DemSy OR IN_GC.bMCB_DemSy OR IN_GC.tGCB_DVM.Di OR NOT Para.bSyActive)
						AND(bU_plus_MMU OR IN_GC.tU_Adj_Plus.Di);

	OUT_GC.tU_Minus.Do:=   (IN_GC.bGCB_DemSy OR IN_GC.bMCB_DemSy OR IN_GC.tGCB_DVM.Di OR NOT Para.bSyActive)
						AND(bU_minus_MMU OR IN_GC.tU_Adj_Minus.Di);
	
	
	(* generator controller reset set point (UNITROL), reset voltage offset for island operation *)
	OUT_GC.tGenCtrResetSp.Do :=	IN_GC.tGCB_On.Di
						AND NOT IN_GC.tGCB_DVM.Di 				(* reset unitrol for RSY voltage matching *)
						AND     IN_GC.tEng_Run.Do  
						AND NOT IN_GC.tMCB_On.Di 
						AND NOT IN_GC.bMCB_DemSy
						AND NOT OUT_GC.tPF_CosPCtr_Ena.Do
						AND iSrc_U_OffsSet = 0;		(* disable, if in droop mode or external setpoint active *)


	(* ============================================================================= *)
	(* ============================================================================= *)
	(* Scaling external U - Setpoint (Island operation) - Hardware*)
	IF (Para.iU_Isl_SetX = 5) THEN
		(* Generierung Messsignalstörung *)
		IF Para.rU_SetExtAI_SetI1 >= 4.0 AND Para.rU_SetExtAI_SetI2 >= 4.0 AND IN_GC.tU_SetExtAI_Norm.GoodQual AND Para.bRelFreeze_Uset_Isl THEN
			rBuffer_U_SetExt[x_U_SetExt] := IN_GC.tU_SetExtAI_Norm.Ai;
			x_U_SetExt := x_U_SetExt + 1;
			IF x_U_SetExt > 9 THEN
				x_U_SetExt := 0;
				bBuffer_U_SetExt := TRUE;
			END_IF;
		END_IF;
		
		IF NOT bBuffer_U_SetExt THEN
			rLCRLimScal_U_SetExt_old := 0.00;
		END_IF;

		xTON_GoodQual_U_SetExt(IN := IN_GC.tU_SetExtAI_Norm.GoodQual, PT := tiGoodQual);
		
		IF Para.rU_SetExtAI_SetI1 >= 4.0 AND Para.rU_SetExtAI_SetI2 >= 4.0 AND NOT xTON_GoodQual_U_SetExt.Q THEN
			bMsg9285 := TRUE;
			IF Para.bRelFreeze_Uset_Isl AND bBuffer_U_SetExt  THEN	
				rU_setExt := rLCRLimScal_U_SetExt_old;
			END_IF;
		ELSE
			bMsg9285 := FALSE;
			rU_setExt := IN_GC.tU_SetExtAI_Norm.Ai;
	
			IF Para.bRelFreeze_Uset_Isl THEN	
				z_U_SetExt := x_U_SetExt - 8;
				IF bBuffer_U_SetExt THEN
					IF z_U_SetExt >= 0 THEN
						rLCRLimScal_U_SetExt_old := rBuffer_U_SetExt[z_U_SetExt];
					ELSE
						rLCRLimScal_U_SetExt_old := rBuffer_U_SetExt[z_U_SetExt + 9];
					END_IF;
				ELSE
					rLCRLimScal_U_SetExt_old := 0.00;
				END_IF;
			END_IF;
		END_IF;	

	ELSE
		rU_setExt := 0.00;
		bMsg9285  := FALSE;
	END_IF;

	(**********************************************************)
	(* Selection of external U - Setpoint (Island operation)  *)
	(**********************************************************)
	rUset_Isl := 0.0;
	bUset_Isl := FALSE;

	(* Choice for reactive power functions *)
	CASE Para.iU_Isl_SetX OF    
	0:  (* NOT USED *)
		bUset_Isl := FALSE;
	1:  (* INTERN *)
		rUset_Isl := Para.rU_Isl_SetInt;
		bUset_Isl := TRUE;
	2:  (* EXTERN DI - spare *)
		rUset_Isl := Para.rU_Isl_SetAct_BU;
		bUset_Isl := FALSE;
	3:  (* EXTERN BUS *)
		IF (Para.bComm1_Ena OR Para.bComm2_Ena) AND NOT IN_GC.bMsg1147 THEN	(* Bus active and without communication failure *)
			rUset_Isl := IN_GC.rUset_Isl_Bus;
		ELSE
			rUset_Isl := Para.rU_Isl_SetAct_BU;
		END_IF;
		bUset_Isl := TRUE;
	4:  (* CUSTOM - prepared for project specific use *)
		IF TRUE THEN
			rUset_Isl := IN_GC.rU_Set_Norm_Cust;
		ELSE
			rUset_Isl := Para.rU_Isl_SetAct_BU;
		END_IF;		
		bUset_Isl := TRUE;
	5:  (* EXTERN AI *)
		IF IN_GC.bExtCtrOk THEN (* External input is able to be read if external activations or HMI activation *)
			IF NOT bMsg9285 OR Para.bRelFreeze_Uset_Isl THEN
				rUset_Isl := rU_setExt;
			ELSE 
				rUset_Isl := Para.rU_Isl_SetAct_BU;
			END_IF;
		ELSE
			rUset_Isl := Para.rU_Isl_SetAct_BU;
		END_IF;
		bUset_Isl := TRUE;
	ELSE
		bUset_Isl := FALSE;
	END_CASE;	

	(**********************************************************)
	(* RESULTS - External U - Setpoint (Island operation) 	  *)
	(**********************************************************)
	rUset_Isl;
	bUset_Isl;

	(* ============================================================================= *)
	(* Scaling external reactive power setpoint for frequency droop mode - Hardware*)
	IF (Para.iQ_Droop_SetX = 5) THEN	
		(* Generierung Messsignalstörung *)
		IF Para.rQ_Droop_Set_SetI1 >= 4.0 AND Para.rQ_Droop_Set_SetI2 >= 4.0 AND IN_GC.tQ_Droop_Set.GoodQual AND Para.bRelFreeze_Qset_Droop THEN
			rBuffer_Q_Droop_Set[x_Q_Droop_Set] := IN_GC.tQ_Droop_Set.Ai;
			x_Q_Droop_Set := x_Q_Droop_Set + 1;
			IF x_Q_Droop_Set > 9 THEN
				x_Q_Droop_Set := 0;
				bBuffer_Q_Droop_Set := TRUE;
			END_IF;
		END_IF;
		
		IF NOT bBuffer_Q_Droop_Set THEN
			rLCRLimScal_Q_Droop_Set_old := 0.00;
		END_IF;		

		xTON_GoodQual_Q_Droop_Set(IN := IN_GC.tQ_Droop_Set.GoodQual, PT := tiGoodQual);
		
		IF Para.rQ_Droop_Set_SetI1 >= 4.0 AND Para.rQ_Droop_Set_SetI2 >= 4.0 AND NOT xTON_GoodQual_Q_Droop_Set.Q THEN
			bMsg9351 := TRUE;
			IF Para.bRelFreeze_Qset_Droop AND bBuffer_Q_Droop_Set  THEN	
				rQset_Droop := rLCRLimScal_Q_Droop_Set_old;
			END_IF;
		ELSE
			bMsg9351 := FALSE;
			rQ_Droop_SetExt	:= IN_GC.tQ_Droop_Set.Ai;
	
			IF Para.bRelFreeze_Qset_Droop THEN	
				z_Q_Droop_Set := x_Q_Droop_Set - 8;
				IF bBuffer_Q_Droop_Set THEN
					IF z_Q_Droop_Set >= 0 THEN
						rLCRLimScal_Q_Droop_Set_old := rBuffer_Q_Droop_Set[z_Q_Droop_Set];
					ELSE
						rLCRLimScal_Q_Droop_Set_old := rBuffer_Q_Droop_Set[z_Q_Droop_Set + 9];
					END_IF;
				ELSE
					rLCRLimScal_Q_Droop_Set_old := 0.00;
				END_IF;
			END_IF;
		END_IF;	

	ELSE
		rQ_Droop_SetExt	:= 0.00;
		bMsg9351		:= FALSE;
	END_IF;

	(***************************************************************************)
	(* Selection of external reactive power setpoint for frequency droop mode  *)
	(***************************************************************************)
	rQset_Droop	:= 0.0;
	bQset_Droop	:= FALSE;

	(* Choice for reactive power functions *)
	CASE Para.iQ_Droop_SetX OF
	0:  (* NOT USED *)
		bQset_Droop	:= FALSE;
		MM2VIS.iIdx_Q_Droop_Offs := 0;
	1:  (* INTERN *)
		rQset_Droop	:= Para.rQ_Droop_SetInt / MAX(1, Para.rS_Nom);
		bQset_Droop	:= TRUE;
	2:  (* EXTERN DI - spare *)
		rQset_Droop	:= Para.rQ_Droop_SetAct_BU / MAX(1, Para.rS_Nom);
		bQset_Droop	:= FALSE;
	3:  (* EXTERN BUS *)
		IF (Para.bComm1_Ena OR Para.bComm2_Ena) AND NOT IN_GC.bMsg1147 THEN (* Bus active and without communication failure *)
			rQset_Droop	:= IN_GC.rQset_Droop_Bus;
		ELSE
			rQset_Droop	:= Para.rQ_Droop_SetAct_BU / MAX(1, Para.rS_Nom);
		END_IF;
		bQset_Droop	:= TRUE;
		MM2VIS.iIdx_Q_Droop_Offs := 2;
	4:  (* CUSTOM - prepared for project specific use *)
		IF TRUE THEN
			rQset_Droop; // := Connectanything;
		ELSE
			rQset_Droop := Para.rQ_Droop_SetAct_BU / MAX(1, Para.rS_Nom);
		END_IF;		
		bQset_Droop	:= TRUE;
	5:  (* EXTERN AI *)
		IF IN_GC.bExtCtrOk THEN (* External input is able to be read if external activations or HMI activation *)
			IF NOT bMsg9351 OR Para.bRelFreeze_Qset_Droop THEN
				rQset_Droop	:= rQ_Droop_SetExt;
			ELSE 
				rQset_Droop	:= Para.rQ_Droop_SetAct_BU / MAX(1, Para.rS_Nom);
			END_IF;
		ELSE
			rQset_Droop	:= Para.rQ_Droop_SetAct_BU / MAX(1, Para.rS_Nom);
		END_IF;
		bQset_Droop	:= TRUE;
		MM2VIS.iIdx_Q_Droop_Offs := 1;
	ELSE
		bQset_Droop	:= FALSE;
	END_CASE;	

	(******************************)
	(* RESULTS - External reactive power setpoint for frequency droop mode 	  *)
	(******************************)
	rQset_Droop;
	bQset_Droop;

	(* ============================================================================= *)
	(* voltage controller *)
	
	(* generate rate signal for voltage adjustment*)
	xTON_U_TAKT(IN := NOT xTON_U_TAKT.Q, PT := T#2s);
	xTON_U_TAKT_P(IN := xTON_U_TAKT.Q, PT := T#500ms);
	U_TAKT := xTON_U_TAKT.Q;
	
	(* MMU Synch 1 *)
	(* ============================================================================= *)
	(* controller deadband 0,5% and voltage difference*)
	IF NOT IN_GC.bSyncSlipMode[2] THEN
		rU_SY_span := 0.005 * Para.rU_SyncNom[1];
		rU_SY_diff := IN_GC.tU_MMD_Synch2[1].Ai - IN_GC.tU_MMD_Synch1[1].Ai;
	ELSE
		rU_SY_span := 0.005 * Para.rU_SyncNom[2];
		rU_SY_diff := IN_GC.tU_MMD_Synch2[1].Ai - IN_GC.tU_MMD_Synch1[2].Ai;
	END_IF;
	
	(* pulse duration depending on voltage difference *)
	IF Para.rU_SyncNom[1] > 0 THEN											(*avoid division by zero*)
		rU_diff_percent := ABS(rU_SY_diff / Para.rU_SyncNom[1] * 100);		(*voltage difference in %*)
		tiPuls := (REAL_TO_TIME(LIMIT(150, rU_diff_percent * 1000, 1500)));	(*calc.pulse duration, min=150ms/max=1500ms*)
	END_IF;

	(* negative deviation => generator voltage to high *)
	bU_SyD_Dec := (rU_SY_diff < 0) AND (ABS(rU_SY_diff) > rU_SY_span);
	
	(* positive deviation => generator voltage to low *)
	bU_SyD_Inc := (rU_SY_diff > 0) AND (ABS(rU_SY_diff) > rU_SY_span);
	
	(* voltage adjustment down *)
	xTP_U_DOWN(IN:= bU_SyD_Dec AND EDGEPOS(U_TAKT), PT := tiPuls);
	bU_minus_MMU := IN_GC.tEng_Run.Do AND xTP_U_DOWN.Q;
		
	(* voltage adjustment up *)
	xTP_U_UP  (IN:= bU_SyD_Inc AND EDGEPOS(U_TAKT), PT := tiPuls);
	bU_plus_MMU	 := IN_GC.tEng_Run.Do AND xTP_U_UP.Q;
	
			

	(* voltage matching *)	
	(* ============================================================================= *)
	(* Eingangskopplung *)
	(* ============================================================================= *)
	IN_GC.tU_Gen_Dec.Di;			(* Verstellbefehl -U von extern *) 		(* adjustment command -U External *)
	IN_GC.tU_Gen_Inc.Di;			(* Verstellbefehl +U von extern *)		(* adjustment command +U External *)

	Para.rU_Gen_Nom[1];				(* Nennspannung *)						(* nominal voltage *)
	Para.rF_Nom[1];					(* Nennfrequenz *)						(* nominal frequency *)
	IN_GC.tF_MMD[1].Ai;				(* IST-Frequenz *)						(* actual frequency *)
	
	(* Parameteranbindung *)
	Para.bU_Gen_Mns_Match;			(* Funktion Voltage matching über Analogsignal aktiv *)		(* Function voltage matching using analog signal active *)
	Para.rU_adj_max_up;		 		(* max.Verstellbereich Generatorspannung nach oben  +10% *)	(* max.adjustment generator voltage up   *)
	Para.rU_adj_max_down;		 	(* max.Verstellbereich Generatorspannung nach unten -10% *)	(* max.adjustment generator voltage down *)

	Para.rU_Gen_Rmp_Inc;		 	(* Rampe Spannungsverstellung %Un/s nach oben  +10% *)		(* max.adjustment generator voltage up   *)
	Para.rU_Gen_Rmp_Dec;		 	(* Rampe Spannungsverstellung %Un/s nach unten -10% *)		(* max.adjustment generator voltage down *)			
	
	Para.rU_Gen_Diff_Idle;			(* U Offset im Leerlauf,   % UN *) 							(* U Offset in idle,      % UN *)
	Para.rU_Gen_Diff_Pn;			(* U Offset bei 100% Last, % UN *) 							(* U offset at 100% Load, % UN *)
									(* Vorbereitung für Inselbetrieb *)	

	(* ex settings *)
	Para.bU_adj_gcb_mmd_calc_a;		(* U-verstellung synch.GCB mit MMU-Berechung aktiv *)
	Para.bU_adj_mcb_mmd_calc_a;		(* U-verstellung synch.MCB mit MMU-Berechung aktiv *)

	Para.bU_adj_gcb_ext_hilo_a;		(* U-verstellung synch.GCB mit externen höher/tiefer Verstellbefehlen aktiv *)
	Para.bU_adj_mcb_ext_hilo_a;		(* U-verstellung synch.MCB mit externen höher/tiefer Verstellbefehlen aktiv *)

	Para.bU_Gen_spd_match;			(* U-verstellung drehzahlabhängig aktiv - Spannungsknie im Inselbetrieb *)	(* U-adjustment speed dependent active - Voltage knee in Island operation *)
	Para.bU_Gen_P_Ena;				(* U-verstellung leistungsabhängig aktiv - "Statik" im Inselbetrieb *)		(* U-adjustment power dependent active - "Static" in Island mode *)
	Para.rU_Gen_match_delta;		(* U-verstellung pro Impuls z.B. 5 Promille UN / s *)						(* U-voltage per impulse e.g. 5 ppm UN/s *)
 	(* ============================================================================= *)

	Para.rF_Gen_Match_Min;			(* max.Verstellbereich Generatorfrequenz nach unten 5% *)	(* max.adjustment generator voltage up *)
	Para.rF_Gen_Match_Max;			(* max.Verstellbereich Generatorfrequenz nach oben  5% *)	(* max.adjustment generator voltage up *)
	(* ============================================================================= *)

	OUT_GC.bU_SyD_match :=	IN_GC.tEng_Run.Do		(* Anforderung Spannungsverstellung während SY *)	(* Demand Voltage adjustment during SY *)
					AND	NOT xOpMode.NetP
					AND    (IN_GC.tGCB_DVM.Di OR IN_GC.bGen_SyD_Dem);
	

	IF Para.bU_Gen_Mns_Match THEN
		(* ============================================================================= *)
		(* Spannungverstellung *)		(* Voltage adjustment *)
		(* ============================================================================= *)
		
		u_plus 		:= (IN_GC.bGCB_DemSy  AND Para.bU_adj_gcb_mmd_calc_a AND bU_plus_MMU)
					OR (IN_GC.bGCB_DemSy  AND Para.bU_adj_gcb_ext_hilo_a AND IN_GC.tU_Gen_Inc.Di)
					OR (IN_GC.bMCB_DemSy  AND Para.bU_adj_mcb_mmd_calc_a AND bU_plus_MMU)
					OR (IN_GC.tGCB_DVM.Di AND Para.bU_adj_mcb_ext_hilo_a AND IN_GC.tU_Gen_Inc.Di);
						
		u_minus 	:= (IN_GC.bGCB_DemSy  AND Para.bU_adj_gcb_mmd_calc_a AND bU_minus_MMU)
					OR (IN_GC.bGCB_DemSy  AND Para.bU_adj_gcb_ext_hilo_a AND IN_GC.tU_Gen_Dec.Di)
					OR (IN_GC.bMCB_DemSy  AND Para.bU_adj_mcb_mmd_calc_a AND bU_minus_MMU)
					OR (IN_GC.tGCB_DVM.Di AND Para.bU_adj_mcb_ext_hilo_a AND IN_GC.tU_Gen_Dec.Di);
		
		(* SY + Beruhigungszeit nach dem zuschalten *)(* SY + Relaxation time after switching ON *)
		xTOF_Synch(IN := OUT_GC.bU_SyD_match, PT := T#5s);
			
		(* Spannungsverstellung während SY *)(* Voltage adjustment during synchronization *)
		xR_TRIG_u_plus (CLK := u_plus);
		xR_TRIG_u_minus(CLK := u_minus);
		IF xTOF_Synch.Q THEN
			IF xR_TRIG_u_plus.Q THEN
				rU_Gen_Diff_Match_sy := rU_Gen_Diff_Match_sy + Para.rU_Gen_match_delta;		
			END_IF;
			IF xR_TRIG_u_minus.Q THEN
				rU_Gen_Diff_Match_sy := rU_Gen_Diff_Match_sy - Para.rU_Gen_match_delta;		
			END_IF;
		ELSE
			rU_Gen_Diff_Match_sy := 0.0;	(* "Return"-Funktion *)
		END_IF;						
		
		
		rU_Gen_Diff_Match_sy :=  LIMIT(2 * Para.rU_adj_max_down, rU_Gen_Diff_Match_sy, 2 * Para.rU_adj_max_up);	(* Limitierung *)
		xRAMPE_rU_Gen_Diff_Match_sy(enable:= IN_GC.bEng_Dem OR M_HDREHZ, In:= rU_Gen_Diff_Match_sy, Rise:= Para.rU_Gen_Rmp_Inc, Sink:= Para.rU_Gen_Rmp_Dec, TC_Time:= 100);
	    rU_Gen_sy_match := xRAMPE_rU_Gen_Diff_Match_sy.Out;


		(* Spannungsverstellung leistungsabhängig - "Statik" im Inselbetrieb *)(* Voltage adjustment power dependent - "Static" in Island mode operation *)
		bU_Gen_P_match :=  Para.bU_Gen_P_Ena AND xOpMode.Island;
		IF bU_Gen_P_match THEN
			xSigScal_uoffset_p(X:= IN_GC.rP_Act_Norm_Filt, X1:= 0.000, Y1:= LIMIT(Para.rU_adj_max_down, Para.rU_Gen_Diff_Idle, Para.rU_adj_max_up), 
			                                               X2:= 1.000, Y2:= LIMIT(Para.rU_adj_max_down, Para.rU_Gen_Diff_Pn,   Para.rU_adj_max_up));
			rU_Gen_Diff_Match_p := xSigScal_uoffset_p.Y_SCAL;
		ELSE
			rU_Gen_Diff_Match_p := 0;
		END_IF;			
		rU_Gen_Diff_Match_p := LIMIT(2 * Para.rU_adj_max_down, rU_Gen_Diff_Match_p, 2 * Para.rU_adj_max_up);		(* Limitierung *)
		xRAMPE_rU_Gen_Diff_Match_p(enable:= IN_GC.bEng_Dem OR M_HDREHZ, In:= rU_Gen_Diff_Match_p, Rise:= Para.rU_Gen_Rmp_Inc, Sink:= Para.rU_Gen_Rmp_Dec, TC_Time:= 100);
		rU_Gen_P_match := xRAMPE_rU_Gen_Diff_Match_p.Out;
		
	
		(* Spannungsverstellung drehzahlabhängig - Spannungsknie im Inselbetrieb *)	
		(* Voltage adjustment speed dependent - Voltage knee in Island mode operation *)
		OUT_GC.bU_Gen_match_isolated := Para.bU_Gen_spd_match 
		                      	AND		xOpMode.Island 
		                        AND    (IN_GC.rP_Act_Norm_Filt > 0.10) 	(* Werte für Freigabe bei Leistungsgrenze xx anpassen ! *)
		                        AND	NOT	IN_GC.tGen_Exc_Off.Di;
		
		IF OUT_GC.bU_Gen_match_isolated THEN			
			IF Para.rF_Nom[1] > 0 THEN				
				rF_Act_norm := IN_GC.tF_MMD[1].Ai / Para.rF_Nom[1];
			END_IF;			
			xSigScal_uoffset_f(X:= rF_Act_norm, X1:= Para.rF_Gen_Match_Min, Y1:= -0.10, X2:= Para.rF_Gen_Match_Max, Y2:= 0.10);   (* Werte für Skalierung anpassen : 5% f-Abweichung -> 10% U-Abweichung *)
			u_offset_f := xSigScal_uoffset_f.Y_SCAL;
		ELSE
			u_offset_f := 0.0;
		END_IF;
		
		u_offset_f := LIMIT(2 * Para.rU_adj_max_down , u_offset_f, 2 * Para.rU_adj_max_up );		(* Limitierung *)
		xRAMPE_u_offset_f(enable := FALSE, In:= u_offset_f, Rise:= Para.rU_Gen_Rmp_Inc, Sink:= Para.rU_Gen_Rmp_Dec, TC_Time:= 100);	//rampe nicht aktiv
		rU_Gen_f_match := xRAMPE_u_offset_f.Out;	
		
	
		(* neuer Spannungs-Offset*)
		(* New Voltage - Offset *)
		u_offset := rU_Gen_P_match + rU_Gen_sy_match + rU_Gen_f_match;
		u_offset := LIMIT(Para.rU_adj_max_down , u_offset, Para.rU_adj_max_up);			(* Limitierung der gesamten Spannungsverstellung *)

		rU_Gen_Diff_Match := u_offset;

		(* Scaling for mA
		   Basler DM110: Voltage regulation 4-20mA = -15% to +15% Usetpoint
		   Normal Setpoint => 12mA
		   ==> Offset-Signal: -8mA to +8mA = -15% to +15% *)
		xSigScal_u_offset_mA.X  := u_offset;
		xSigScal_u_offset_mA.X1 := -0.15;
		xSigScal_u_offset_mA.X2 := +0.15;
		xSigScal_u_offset_mA.Y1 := -8.0;		(* -8mA *)
		xSigScal_u_offset_mA.Y2 := +8.0;		(* +8mA *)
		xSigScal_u_offset_mA();
		
		rU_Gen_Diff_Match_I := xSigScal_u_offset_mA.Y_SCAL;			(* Ausgangssignal siehe task: pf_cust *)	
		
	
		(* Scaling for V
		   Basler DEC100: Voltage regulation -3V to +3V = -30% to +30% Usetpoint
		   Normal Setpoint => 0V
		   ==> Offset-Signal: -3V to +3V = -30% to +30%	*)
		xSigScal_u_offset_V.X  := u_offset;
		xSigScal_u_offset_V.X1 := -0.30;
		xSigScal_u_offset_V.X2 := +0.30;
		xSigScal_u_offset_V.Y1 := -3.0;			(* -3V *)
		xSigScal_u_offset_V.Y2 := +3.0;			(* +3V *)
		xSigScal_u_offset_V();
	 	
		rU_Gen_Diff_Match_U  := xSigScal_u_offset_V.Y_SCAL;	(* Ausgangssignal siehe task: pf_cust *)
													        (* Output signal see task: pf_cust *)                         

	ELSE
		rU_Gen_Diff_Match_I := 0;
		rU_Gen_Diff_Match_U := 0;
		rU_Gen_Diff_Match   := 0;
	END_IF;

	(** U: Voltage static *)

	(** U.1.0: calculate rQ_Nom *)
	IF Para.rEta_Gen_PF08 <> 0 AND Para.rEta_Gen_PF1 <> 0 THEN
		rP_Nom_PF08	:= IN_GC.rP_Nom / Para.rEta_Gen_PF1 * Para.rEta_Gen_PF08;
	ELSE	
		rP_Nom_PF08	:= IN_GC.rP_Nom;
	END_IF;
	IF (Para.rS_Nom ** 2) - (rP_Nom_PF08 ** 2) > 0 THEN
		rQ_Nom := ((Para.rS_Nom ** 2) - (rP_Nom_PF08 ** 2))**(0.5);
	ELSE
		rQ_Nom := 0.0;	
	END_IF;
	
	(** U.1.3: set source and visualization *)
	IF VIS2MM.bQ_Droop_Set_Man THEN			(* Droop Offset manual via HMI *)
		rQ_Offs_Input := VIS2MM.rQ_Droop_Set_Man;
		MM2VIS.iIdx_Q_Droop_Offs := 3;
	ELSE 									(* Droop Offset from other sources - see Selection of external reactive power setpoint for frequency droop mode (above) *)
		rQ_Offs_Input := rQset_Droop;
	END_IF;
	
	rQ_Droop_Offs := LIMIT(Para.rQ_UnderExc_Lim * Para.rS_Nom, rQ_Offs_Input * Para.rS_Nom, Para.rQ_OverExc_Lim * Para.rS_Nom);	(* limit input *)
	
	VIS2MM.rQ_Droop_Set_Man	:= rQ_Droop_Offs / MAX(1.0,Para.rS_Nom);	(* set current setpoint to manual input, for smooth transition *)
	MM2VIS.rQ_Droop_Offs	:= rQ_Droop_Offs / MAX(1.0,Para.rS_Nom);
	
	(** U.1.4: calculate from Q offset to U offset *)
	rU_Droop_Offs := rQ_Droop_Offs / MAX(1.0,Para.rS_Nom) * Para.rU_StCtr_Grad;
	
	(** U.2: scale block for voltage droop *)	
	xLCRScal_U_WPt.x  := IN_GC.tQ_Act[1].Ai;
	xLCRScal_U_WPt.x1 := -Para.rS_Nom;
	xLCRScal_U_WPt.x2 := Para.rS_Nom;
	xLCRScal_U_WPt.y1 := 1.0 + Para.rU_StCtr_Grad + rU_Droop_Offs;
	xLCRScal_U_WPt.y2 := 1.0 - Para.rU_StCtr_Grad + rU_Droop_Offs;
	xLCRScal_U_WPt();

	(** U.3: choose setpoint *)
	CASE iSrc_U_OffsSet OF
		0: xLCRRamp_U_Set_Norm.x := 1.0;					(* deactivated *)
		1: xLCRRamp_U_Set_Norm.x := xLCRScal_U_WPt.y;		(* Reactive power setpoint for droop curve *)
		2: xLCRRamp_U_Set_Norm.x := rUset_Isl;				(* Voltage setpoint *)
	END_CASE
	
	(** U.4: set point ramp 1%/s *)
	xLCRRamp_U_Set_Norm.enable	:= TRUE;
	xLCRRamp_U_Set_Norm.set		:= FALSE; 				(* always activate *)
	xLCRRamp_U_Set_Norm.y_set	:= 1.0;					(* if deactivated set to 100% *)
	xLCRRamp_U_Set_Norm.dy_up	:= 0.01;				(* ramp speed 1%/s *)
	xLCRRamp_U_Set_Norm.dy_down	:= 0.01;				(* ramp speed 1%/s *)
	xLCRRamp_U_Set_Norm.y_max	:= 1.10; 				(* max limit: 110%Unom *)
	xLCRRamp_U_Set_Norm.y_min	:= 0.90;				(* min limit:  90%Unom *)
	xLCRRamp_U_Set_Norm();
	IF NOT xOpMode.Island AND IN_GC.bU_Set_NP_Rel THEN	(* switch over setpoint without ramp for fast reaction *)
		OUT_GC.tU_Set_Norm.Ao := IN_GC.rU_Set_NP; 		(* mains parallel operation *)
	ELSE
		OUT_GC.tU_Set_Norm.Ao := xLCRRamp_U_Set_Norm.y;	(* island operation *)
	END_IF;
	
	(** U.5: Window size *)
	rQ_Win	:=	INT_TO_REAL(REAL_TO_INT(Para.rS_Nom) - (REAL_TO_INT(Para.rS_Nom) MOD 100) + 100);
	x_Win[0] :=	-rQ_Win;
	x_Win[1] :=	rQ_Win;
	MM2VIS.tU_Stat.tWin.x    := x_Win;
	MM2VIS.tU_Stat.tWin.y[0] := Para.rU_Gen_Nom[1] * 0.875;
	MM2VIS.tU_Stat.tWin.y[1] := Para.rU_Gen_Nom[1] * 1.125;
	
	(** U.6: Green line: Unom *)
	MM2VIS.tU_Stat.tLn_Nom.x	:= x_Win;
	MM2VIS.tU_Stat.tLn_Nom.y[0]	:= Para.rU_Gen_Nom[1];
	MM2VIS.tU_Stat.tLn_Nom.y[1]	:= Para.rU_Gen_Nom[1];
	
	(** U.7: Blue line: Uset *)
	MM2VIS.tU_Stat.tLn_Set.x[0]	:= -Para.rS_Nom;
	MM2VIS.tU_Stat.tLn_Set.x[1]	:= Para.rS_Nom;
	
	CASE iSrc_U_OffsSet OF
		0: 	MM2VIS.tU_Stat.tLn_Set.y[0]	:= Para.rU_Gen_Nom[1];
			MM2VIS.tU_Stat.tLn_Set.y[1]	:= Para.rU_Gen_Nom[1];

		1:	MM2VIS.tU_Stat.tLn_Set.y[0]	:= Para.rU_Gen_Nom[1] * (1.0 - MM2VIS.tU_Stat.tLn_Set.x[0] / MAX(1.0,Para.rS_Nom) * Para.rU_StCtr_Grad + rU_Droop_Offs);
			MM2VIS.tU_Stat.tLn_Set.y[1]	:= Para.rU_Gen_Nom[1] * (1.0 - MM2VIS.tU_Stat.tLn_Set.x[1] / MAX(1.0,Para.rS_Nom) * Para.rU_StCtr_Grad + rU_Droop_Offs);

		2:	MM2VIS.tU_Stat.tLn_Set.y[0]	:= Para.rU_Gen_Nom[1] * LIMIT(xLCRRamp_U_Set_Norm.y, 0.9, 1.1);
			MM2VIS.tU_Stat.tLn_Set.y[1]	:= Para.rU_Gen_Nom[1] * LIMIT(xLCRRamp_U_Set_Norm.y, 0.9, 1.1);
	END_CASE
	
	(** U.8: Brown point: Working point *)	
	MM2VIS.tU_Stat.tWPt.x := LIMIT(IN_GC.tQ_Act[1].Ai, -rQ_Win, rQ_Win);
	MM2VIS.tU_Stat.tWPt.y := IN_GC.tU_Avg[1].Ai;
	
	
END_PROGRAM