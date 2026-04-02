(* MONITORING AND CONTROLING OF SPECIAL GAS ENGINES

variables (limit switches) for customized use:
 	GD_MAX	gas pressure maximum
 	GT_MAX	gas temperature maximum
 	GT_MIN	gas temperature minimum 
 	SD_MAX	suction pressure maximum
 	SD_MIN	suction pressure minimum

MS_CV calorific value measuring signal failure
CV_MIN_A calorific value low
CV_MIN_W calorific value low
CV_RED reduction by calorific value active
OUT_GT.rP_Red_CV_Norm reduction value by calorific value

output variables to standard software:

BOOL:	CH4_MIN_A	--> A1086
 	CH4_MIN_W	--> W3154
 	FGGAS		--> W3153
 	GD_MIN_W	--> W3221
 	MS_CH4		--> W3155
 	MS_GD		--> W3156
 	MS_GM		--> W3160
 	MS_GT		--> W3159
 	MS_O2_A 	--> A1088
 	MS_O2_W 	--> W3158
 	MS_SD		--> W3157
 	O2_MAX		--> A1087

............................
VER	Datum/Name	Änderung
V180	19.11.02/LH	erstellt
V181	10.04.03/Th.	Korrekturen bei Typprüfung: OUT_GT.bGasSupplyOk
 	    11.04.03/Th.	Korrekturen bei Typprüfung: MS_O2_W, MS_O2_A
 	    17.04.03/Th.	Korrekturen bei Typprüfung: SD_MIN, SD_MAX
V183	16.10.03/LH	Messignal CH4-Gehalt erst aktiv mit IN_GT.bParaSetupOk
V184	07.01.04/ThJ	Messignalstörungen erst aktiv mit IN_GT.bParaSetupOk; 
 			Reset CH4_MIN, MS_GM, MS_O2_A, MS_O2_W wenn nicht aktiviert. 
 			Kommentare.
 			Zeitverz. für CH4_MIN 2 --> 5s.
V2071	30.11.04/LH	Korrektur Gasqualitätsberechnung
 	    03.02.05/LH	Überwachung Gasdruck minimum angepasst für V2071
 	    03.03.05/LH	Anpassung Saugdruck min/max
V2072	16.11.05/LH	CH4 min. / Gasdr. min. / Freigabe aus Gasstation lt. letzten Erkenntnissen angepasst
 			     Anforderung Entlastung eliminiert (wird nicht benötigt)
V190	19.03.04/LH	Interpolation GAS1_2 über Rezept einstellbar
 		    	 Leistungsreduktionen --> p_soll(classic)/powersel(XT) 
 			     Umrechnungen --> ana_umr(classic)/ana_calc(XT)
V220	19.02.07/LH	angepasst für X20-Einführung
 	    01.03.07/LH	Erweiterung auf Pt100
 	    10.04.07/LH	Zuweisung für Pt100
V2.32	14.07.08/ThJ Heizwert/calorific value added
V2.34.0 04.12.2008 Lett./ThJ set GAS1_2 in case of Para.bGT_CVIpol12Active=true
V2.50.0	02.02.2009 lett. HW_WE -> AI_CV(for standard) 
V03.99.00.00	21.09.2013	Ganguly	generated for modular software
V03.99.01.00	21.02.2013	Denk	Integration of V3.30 in modular software
									HM_GDMI1, HM_GDMI2 changed to modul global variable
V04.00.02.00	15.05.2014	Denk	Bugfix, FGGAS 
V04.00.02.00	17.05.2014	Denk	Bugfix, Interpolations-Umschaltung, 4x Skalierung falsch 100% --> 1.0%
V04.01.00.00	17.07.2014	Denk	Bugfix, Measurement signal failure reset CH4 and CV signal
									Bugfix, Deactivation power reduction (CH4,GD,SD) via standard DI's
									Bugfix, CH4,CV: Para.rGT_CH4Mix1,Para.rGT_CH4Mix2 and Para.bGT_CVIpol12Active
V04.01.01.00	24.08.2014	Denk	Bugfix, Interpolation deactivation 
V04.01.02.00	14.10.2014	Denk	Bugfix, Message activation O2 max.
V04.03.00.00	31.03.2015	Denk	Improvement, additional LABELS for tPr_GT1_1_Min and tPr_GT1_1_Max
				02.07.2015	Denk 	Bugfix, 3221 not activ when gastrain 2 is active. NOT was missing. NOT MM2VIS.bMsg1028
									Warnings for 4 gaslines bMsg2694-2696 added			
V04.10.0.00		08.12.2020	Denk	Bugfix, xTON_GDMA2() changed to xTON_GDMA2_VISA()
         		10.12.2020	Zuschnig	Included power reduction for Tecjet differential pressure
				21.01.2020	Zuschnig	Bugfix, Power reduction suction pressure (swap X1<->X2)
V04.11.0.00		02.03.2022	Zuschnig	Include CH4 signal via Bus from customize modul
V04.12.0.00		22.01.2023	Zuschnig	Include H2 signal processing, power reduction and limit detection
V04.13.0.00		26.05.2023	Zuschnig	Include measuring signal failure setpoint - Gas mixing 
*)
PROGRAM _INIT
	(*Parameter*)
	SimPID_deltaP_TJ.P 			:= 0.001;
	SimPID_deltaP_TJ.I 			:= 0;
	SimPID_deltaP_TJ.D			:= 0;
	SimPID_deltaP_TJ.N			:= 0;
	SimPID_deltaP_TJ.wxmax		:= 0.2; (* maximum 200mbar delta P *)
	SimPID_deltaP_TJ.wxmin		:= 0;
	SimPID_deltaP_TJ.umax 		:= 0;
	SimPID_deltaP_TJ.umin 		:= -0.5; (* maximum power reduction 50% *)
	SimPID_deltaP_TJ.Kt			:= 1;
	SimPID_deltaP_TJ.deadband 	:= 0.001; (* 1mbar deadband *)
	SimPID_deltaP_TJ.invert 	:= TRUE;	
	
	(*Input*)
	SimPID_deltaP_TJ.u_man		:=	0;
	SimPID_deltaP_TJ.a			:= 	0;
	SimPID_deltaP_TJ.reset		:=  FALSE;
	SimPID_deltaP_TJ.I0			:=  0;
	SimPID_deltaP_TJ.D0			:=  0;
	SimPID_deltaP_TJ.fbk_mode	:=  2;
	SimPID_deltaP_TJ.u_fbk		:=  0;
END_PROGRAM

PROGRAM _CYCLIC
	(* H2 measurement *) 
	(* Hand over filtered H2 value *)
	OUT_GT.rH2		:= xLCRPT1_H2.y;
	(* H2 value for H2 compensation of ITP and boost pressure *)
	xGR_MAXR_H2_Comp(In:= OUT_GT.rH2, Gw:= rGwH2_Comp, Hy:= rHyH2_Comp);
	IF xGR_MAXR_H2_Comp.Q THEN		
		OUT_GT.rH2_Comp := MAX(0.02, MIN(0.25, OUT_GT.rH2));
	ELSE 
		OUT_GT.rH2_Comp := 0;	
	END_IF;	

	IF Para.bGT_H2Active THEN
		(* Power reduction H2 content *)
		(* Power reduction measurement signal failure H2 content *)		
		IF bS_MSF_H2 THEN	
			rReductionPowerH2_MSF := Para.rP_Red_H2_MSF;
		ELSE
			rReductionPowerH2_MSF := 1.00;			
		END_IF;	
		
		(* Power reduction H2 content high *)		
		IF OUT_GT.rH2 > Para.rP_Red_H2Start THEN
			rReductionPowerH2 := 1.00 - ((OUT_GT.rH2 - Para.rP_Red_H2Start) * Para.rP_Red_H2_Rate * 100);
		ELSE
			rReductionPowerH2 := 1.00;
		END_IF;	

		OUT_GT.rP_Red_H2_Norm := MIN(rReductionPowerH2_MSF, rReductionPowerH2);		
	
		(* H2 content maximum warning *)		
		xGR_MAXR_FA_H2_MAX_W.In := OUT_GT.rH2;
		xGR_MAXR_FA_H2_MAX_W.Gw	:= Para.rGT_H2WarnLimMax;	
		xGR_MAXR_FA_H2_MAX_W.Hy := 0;
		xGR_MAXR_FA_H2_MAX_W();
		
		bH2_MAX_W	:= xGR_MAXR_FA_H2_MAX_W.Q AND IN_GT.tPB2MM.bParaSetupOk;
	
		(* H2 content maximum alarm *)		
		xGR_MAXR_FA_H2_MAX_A.In := OUT_GT.rH2;
		xGR_MAXR_FA_H2_MAX_A.Gw	:= Para.rGT_H2TripLimMax;	
		xGR_MAXR_FA_H2_MAX_A.Hy := 0;
		xGR_MAXR_FA_H2_MAX_A();
	
		bH2_MAX_A	:=	xGR_MAXR_FA_H2_MAX_A.Q AND IN_GT.tPB2MM.bParaSetupOk;	
	ELSE
		OUT_GT.rP_Red_H2_Norm	:= 1.00;
		rReductionPowerH2_MSF 	:= 1.00;
		rReductionPowerH2 		:= 1.00;
		bH2_MAX_W				:= FALSE;
		bH2_MAX_A				:= FALSE;
	END_IF;

	(*************************************************************************************************************)	
	(* CH4 measurement *) 

	IF Para.bGT_CH4Active THEN
		(* Measurement signal failure CH4 content  W3155 !!!!! Alarm not is list *)
		MS_CH4 := NOT IN_GT.tGT_CH4.GoodQual AND IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.bCH4_Bus_Active;

		(* Messignalstörung *)
		(* Measurement signal failure *)
		S_MS_CH4 := MS_CH4 OR (S_MS_CH4 AND NOT IN_GT.tAB2GT.bResetWarning );

		(* Hold analog value during calibration *)
		IF IN_GT.tGT_CalibrateActive.Di OR IN_GT.bGT_CalibrateActive_Bus THEN
			rGT_CH4 := rGT_CH4;	
		ELSIF NOT IN_GT.bCH4_Bus_Active THEN
			rGT_CH4 := IN_GT.tGT_CH4.Ai;
		ELSE
			rGT_CH4 := IN_GT.rCH4_Bus;
		END_IF;

		(* Reduction due to CH4 content *)
		RED_CH4_a := Para.bP_Red_CH4Active AND NOT MS_CH4 AND NOT IN_GT.tP_Red_CH4Active.Di AND IN_GT.tPB2MM.bParaSetupOk;

		IF RED_CH4_a THEN
			xSigScalR_FA_CH4_RED.X  := rGT_CH4;
			xSigScalR_FA_CH4_RED.X1 := Para.rP_Red_CH4HalfLoad;
			xSigScalR_FA_CH4_RED.Y1 := 0.50;
			xSigScalR_FA_CH4_RED.X2 := Para.rP_Red_CH4Start;
			xSigScalR_FA_CH4_RED.Y2 := 1.00;
			xSigScalR_FA_CH4_RED();
			OUT_GT.rP_Red_CH4_Norm := LIMIT(0.50,xSigScalR_FA_CH4_RED.Y_SCAL,1.000);
		ELSE
			OUT_GT.rP_Red_CH4_Norm := 1.0;
		END_IF;

		(* CH4-Gehalt minimum Warnung/Blockierung (W3154) *)
		CH4_MIN_W_a := Para.bGT_CH4WarnActive AND NOT MS_CH4;

		xGR_MINR_FA_CH4_MIN_W.In := rGT_CH4;
		xGR_MINR_FA_CH4_MIN_W.Gw := Para.rGT_CH4WarnLimMin;
		xGR_MINR_FA_CH4_MIN_W.Hy := Para.rGT_CH4WarnHyMin;
		xGR_MINR_FA_CH4_MIN_W();
		xTON_FA_T_CH4_W.IN := xGR_MINR_FA_CH4_MIN_W.Q AND IN_GT.tPB2MM.bParaSetupOk;
		xTON_FA_T_CH4_W.PT := T#5s;
		xTON_FA_T_CH4_W();
		CH4_MIN := xTON_FA_T_CH4_W.Q AND CH4_MIN_W_a;

		xTON_FA_CH4_MIN.IN := (IN_GT.bEng_Aux_Dem OR CH4_MIN_W) AND NOT OUT_GT.bGT2_Select AND CH4_MIN AND (IN_GT.iIdx_OMSS = 2);
		IF bTestEnabled THEN
			xTON_FA_CH4_MIN.PT := T#3s;
		ELSE		
			xTON_FA_CH4_MIN.PT := T#300s;
		END_IF;	
		xTON_FA_CH4_MIN();

		CH4_MIN_W_1 := CH4_MIN AND (IN_GT.iIdx_OMSS = 2) AND xTON_FA_CH4_MIN.Q;
		CH4_MIN_W   := (IN_GT.bEng_Aux_Dem OR CH4_MIN_W) AND NOT OUT_GT.bGT2_Select AND (CH4_MIN OR CH4_MIN_W_1);

		(* CH4-Gehalt minimum Abstellung (A1086) *)
		(* CH4-content minimum Trip A1086 *)
		xGR_MINR_FA_CH4_MIN_A.In := rGT_CH4;
		xGR_MINR_FA_CH4_MIN_A.Gw := Para.rGT_CH4TripLimMin;
		xGR_MINR_FA_CH4_MIN_A.Hy := Para.rGT_CH4TripHyMin;
		xGR_MINR_FA_CH4_MIN_A();
		xTON_FA_T_CH4_A.IN := xGR_MINR_FA_CH4_MIN_A.Q AND IN_GT.tPB2MM.bParaSetupOk;
		xTON_FA_T_CH4_A.PT := T#0.5s;
		xTON_FA_T_CH4_A();
		CH4_MIN_A := xTON_FA_T_CH4_A.Q AND Para.bGT_CH4TripActive;
	ELSE
		MS_CH4 	  := FALSE;
		S_MS_CH4  := FALSE;		
		CH4_MIN   := FALSE;
		CH4_MIN_W := FALSE;
		CH4_MIN_A := FALSE;
		OUT_GT.rP_Red_CH4_Norm := 1.0;	
	END_IF;

	(*************************************************************************************************************)	
	(* Heating value *) 
	// L20,21 shifted out to HAL IO
	IF Para.bGT_CVActive THEN	
		(* Measuring signal failure of heating value *)
		MS_CV   := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tGT_CV.GoodQual AND NOT IN_GT.bCV_Bus_Active; 
		S_MS_CV := MS_CV OR (S_MS_CV AND NOT IN_GT.tAB2GT.bResetWarning );
		
		(* Hold analog value during calibration *)
		IF IN_GT.tGT_CalibrateActive.Di OR IN_GT.bGT_CalibrateActive_Bus THEN
			rGT_CV := rGT_CV;
		ELSIF NOT IN_GT.bCV_Bus_Active THEN
			rGT_CV := IN_GT.tGT_CV.Ai;
		ELSE
			rGT_CV := IN_GT.rCV_Bus;
		END_IF;
		
		(* Power reduction due to heat value L25 *)
		RED_CV_a := Para.bP_Red_CVActive AND NOT MS_CV AND NOT CVRED_0 AND IN_GT.tPB2MM.bParaSetupOk;	
		
		xSigScal_FA_CV_RED.X  := rGT_CV;
		xSigScal_FA_CV_RED.X1 := Para.rP_Red_CVHalfLoad;
		xSigScal_FA_CV_RED.Y1 := 0.50;
		xSigScal_FA_CV_RED.X2 := Para.rP_Red_CVStart;
		xSigScal_FA_CV_RED.Y2 := 1.00;
		xSigScal_FA_CV_RED();
		
		IF RED_CV_a THEN
			OUT_GT.rP_Red_CV_Norm := LIMIT(0.00,xSigScal_FA_CV_RED.Y_SCAL,1.00);
		ELSE
			OUT_GT.rP_Red_CV_Norm := 1.0;
		END_IF;
		
		(* Heizwert minimum Warnung/Blockierung (Wxxxx) *)
		(* Calorific value Warning/Blocking (Wxxxx) *)
		CV_MIN_W_a := Para.bGT_CVWarnActive AND NOT MS_CV;
		
		xGR_MINR_FA_CV_MIN_W.In := IN_GT.tGT_CV.Ai;
		xGR_MINR_FA_CV_MIN_W.Gw := Para.rGT_CVWarnLimMin;
		xGR_MINR_FA_CV_MIN_W.Hy := Para.rGT_CVWarnHyMin;
		xGR_MINR_FA_CV_MIN_W();
		xTON_FA_T_CV_W.IN := xGR_MINR_FA_CV_MIN_W.Q AND IN_GT.tPB2MM.bParaSetupOk;
		xTON_FA_T_CV_W.PT := T#5s;
		xTON_FA_T_CV_W();
		CV_MIN := xTON_FA_T_CV_W.Q AND CV_MIN_W_a;
			
		xTON_FA_CV_MIN.IN := (IN_GT.bEng_Aux_Dem OR bMsg_Dummy_Warn_CV) AND NOT OUT_GT.bGT2_Select AND CV_MIN AND (IN_GT.iIdx_OMSS = 2);
		IF bTestEnabled THEN
			xTON_FA_CV_MIN.PT := T#3s;	
		ELSE
			xTON_FA_CV_MIN.PT := T#300s;	
		END_IF;	
		xTON_FA_CV_MIN();
		
		// CV_MIN_W -> Warning: calorific value minimum 
		bMsg_Dummy_Warn_CV := xTON_FA_CV_MIN.Q OR (CV_MIN AND NOT OUT_GT.bGT2_Select AND (IN_GT.bEng_Aux_Dem OR bMsg_Dummy_Warn_CV));
		
		(* Heizwert minimum Abstellung (Axxxx) *)	
		(* Calorific value minimum Trip (Axxx) *)	
		xGR_MINR_FA_CV_MIN_A.In := IN_GT.tGT_CV.Ai;
		xGR_MINR_FA_CV_MIN_A.Gw := Para.rGT_CVTripLimMin;
		xGR_MINR_FA_CV_MIN_A.Hy := Para.rGT_CVTripHyMin;
		xGR_MINR_FA_CV_MIN_A();
		xTON_FA_T_CV_A.IN := xGR_MINR_FA_CV_MIN_A.Q AND IN_GT.tPB2MM.bParaSetupOk;
		xTON_FA_T_CV_A.PT := T#0.5s;
		xTON_FA_T_CV_A();
		// CV_MIN_A -> Trip: calorific value minimum
		bMsg_Dummy_Trip_CV := xTON_FA_T_CV_A.Q AND Para.bGT_CVTripActive;
		
	ELSIF NOT Para.bGT_CVActive THEN				
		MS_CV                 := FALSE;
		S_MS_CV               := FALSE;
		CV_MIN                := FALSE;
		bMsg_Dummy_Warn_CV    := FALSE;
		bMsg_Dummy_Trip_CV    := FALSE;
		OUT_GT.rP_Red_CV_Norm := 1.0;	
		rP_Red_CV_Norm        := 1.0;		
	END_IF;
		
	(*****************************************************************************************************************)	
	(* 	activate interpolation gas1 & gas2 (set: GAS1_2 = parameter interpolation gas1 & 2 active):
	if:
	Para.bGT_CVActive        = true: parameter calorific value active, (interpolation from CV is priority)
	and Para.bGT_SpecGasActive = true: parameter special gas active 
	and Para.bGT_CVIpol12Active   = true: parameter interpolation active from CV  *)

	OUT_GT.bGT_Ipol12Active := FALSE;

	IF 	(NOT Para.bGT_CVActive OR NOT Para.bGT_SpecGasActive) THEN			//old code: weiter0 Bedingung erfüllt
		IF ((NOT Para.bGT_Ipol12Active_Para OR NOT Para.bGT_CH4Active ) AND 
			(NOT Para.bGT_CVIpol12Active OR NOT Para.bGT_CVActive) OR  
			NOT Para.bGT_SpecGasActive) THEN
			// weiter0:
			X_GMISCH_2 := 0.0;												//old code: weiter1 Bedingung erfüllt
		ELSE
			IF (Para.bGT_CVIpol12Active AND Para.bGT_CVActive) THEN
				// L043
				// X_GMISCH_2_CalVal
				xSigScal_R_FA_CalVal_GMV.X  := LIMIT(Para.rGT_CV4Mix1, rGT_CV, Para.rGT_CV4Mix2);
				xSigScal_R_FA_CalVal_GMV.X1 := Para.rGT_CV4Mix1;
				xSigScal_R_FA_CalVal_GMV.Y1 := 0.0;
				xSigScal_R_FA_CalVal_GMV.X2 := Para.rGT_CV4Mix2;
				xSigScal_R_FA_CalVal_GMV.Y2 := 1.0;
				xSigScal_R_FA_CalVal_GMV();
				Y_SCAL_CalVal := xSigScal_R_FA_CalVal_GMV.Y_SCAL;
				
				IF (NOT Para.bGT_CVActive OR S_MS_CV) THEN
					X_GMISCH_2 := Para.rGT_CV_Mix_DefVal;
				ELSE
					X_GMISCH_2 := Y_SCAL_CalVal;
				END_IF;	
	
				OUT_GT.bGT_Ipol12Active := Para.bGT_CVIpol12Active;
		
			ELSE
				// L040
				// Mixed gas relation from CH4-content
				xSigScalR_FA_CH4_GMV.X  := LIMIT(Para.rGT_CH4Mix1,rGT_CH4,Para.rGT_CH4Mix2);
				xSigScalR_FA_CH4_GMV.X1 := Para.rGT_CH4Mix1;
				xSigScalR_FA_CH4_GMV.Y1 := 0.0;
				xSigScalR_FA_CH4_GMV.X2 := Para.rGT_CH4Mix2;
				xSigScalR_FA_CH4_GMV.Y2 := 1.0;
				xSigScalR_FA_CH4_GMV();
				
				IF (NOT Para.bGT_CH4Active OR S_MS_CH4) THEN
					X_GMISCH_2 := Para.rGT_CH4_Mix_DefVal;
				ELSE	
					X_GMISCH_2 := xSigScalR_FA_CH4_GMV.Y_SCAL;
				END_IF;	
				
				OUT_GT.bGT_Ipol12Active := Para.bGT_Ipol12Active_Para;	
		
			END_IF;
		END_IF;
	ELSE 
		IF ((NOT Para.bGT_Ipol12Active_Para OR NOT Para.bGT_CH4Active) AND 
			(NOT Para.bGT_CVIpol12Active OR NOT Para.bGT_CVActive) OR  
			NOT Para.bGT_SpecGasActive) THEN
			// weiter0:
			X_GMISCH_2 := 0.0;												//old code: weiter1 Bedingung erfüllt											
		ELSE	
			IF (Para.bGT_CVIpol12Active AND Para.bGT_CVActive) THEN
				// L043
				// X_GMISCH_2_CalVal
				xSigScal_R_FA_CalVal_GMV.X  := LIMIT(Para.rGT_CV4Mix1, rGT_CV, Para.rGT_CV4Mix2);
				xSigScal_R_FA_CalVal_GMV.X1 := Para.rGT_CV4Mix1;
				xSigScal_R_FA_CalVal_GMV.Y1 := 0.0;
				xSigScal_R_FA_CalVal_GMV.X2 := Para.rGT_CV4Mix2;
				xSigScal_R_FA_CalVal_GMV.Y2 := 1.0;
				xSigScal_R_FA_CalVal_GMV();
				Y_SCAL_CalVal := xSigScal_R_FA_CalVal_GMV.Y_SCAL;
				
				IF (NOT Para.bGT_CVActive OR S_MS_CV) THEN
					X_GMISCH_2 := Para.rGT_CV_Mix_DefVal;
				ELSE
					X_GMISCH_2 := Y_SCAL_CalVal;
				END_IF;			
	
				OUT_GT.bGT_Ipol12Active := Para.bGT_CVIpol12Active;

			ELSE
				// L040
				// Mixed gas relation from CH4-content
				xSigScalR_FA_CH4_GMV.X  := LIMIT(Para.rGT_CH4Mix1,rGT_CH4,Para.rGT_CH4Mix2);
				xSigScalR_FA_CH4_GMV.X1 := Para.rGT_CH4Mix1;
				xSigScalR_FA_CH4_GMV.Y1 := 0.0;
				xSigScalR_FA_CH4_GMV.X2 := Para.rGT_CH4Mix2;
				xSigScalR_FA_CH4_GMV.Y2 := 1.0;
				xSigScalR_FA_CH4_GMV();
				
				IF (NOT Para.bGT_CH4Active OR S_MS_CH4) THEN
					X_GMISCH_2 := Para.rGT_CH4_Mix_DefVal;
				ELSE	
					X_GMISCH_2 := xSigScalR_FA_CH4_GMV.Y_SCAL;
				END_IF;

				OUT_GT.bGT_Ipol12Active := Para.bGT_Ipol12Active_Para;
				
			END_IF;	
		END_IF;
	END_IF;	

	MM2VIS.bGT_Ipol12Active := OUT_GT.bGT_Ipol12Active;		
	
	(* Gas pressure *) 
	IF Para.bPr_GT_GasPrActive THEN 
		MS_GD := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tPr_GT_Gas.GoodQual; 
		RED_GD_a := Para.bP_Red_GasPrActive AND NOT MS_GD AND NOT IN_GT.tP_Red_GasPrActive.Di AND IN_GT.tPB2MM.bParaSetupOk;
		
		IF RED_GD_a THEN
			xSigScalR_FA_GD_RED.X  := IN_GT.tPr_GT_Gas.Ai;
			xSigScalR_FA_GD_RED.X1 := Para.rP_Red_GasPrStart; 
			xSigScalR_FA_GD_RED.Y1 := 1.00;
			xSigScalR_FA_GD_RED.X2 := Para.rP_Red_GasPrHalfLoad;
			xSigScalR_FA_GD_RED.Y2 := 0.50;
			xSigScalR_FA_GD_RED();
			OUT_GT.rP_Red_GasPr_Norm := xSigScalR_FA_GD_RED.Y_SCAL;	
		ELSE
			OUT_GT.rP_Red_GasPr_Norm := 1.0;	
		END_IF;
		
		(* W3221 Gas pressure minimum warning/blocking gas train 1 *)
		GD_MIN_a := Para.bPr_GT_MinActive AND IN_GT.tPr_GT_Gas.GoodQual;
		
		xGR_MIN_FA_GD_MIN.In := IN_GT.tPr_GT_Gas.Ai;
		xGR_MIN_FA_GD_MIN.Gw := Para.rPr_GT_LimMin;
		xGR_MIN_FA_GD_MIN.Hy := Para.rPr_GT_HyMin;
		xGR_MIN_FA_GD_MIN();
		GD_MIN := xGR_MIN_FA_GD_MIN.Q AND GD_MIN_a;
		
		ZM := (FG_GDRUW OR (GD_MIN_W AND NOT Para.bGCActive)) AND
		NOT OUT_GT.bGT2_Select AND 
		(T_GDRUW OR NOT Para.bGCActive);
			  
		xTP_FA_GD_MIN_W.IN := ZM AND GD_MIN AND (IN_GT.iIdx_OMSS = 2);
		// Timer duration modified for testing 
		IF bTestEnabled THEN
			xTP_FA_GD_MIN_W.PT := T#3s;	
		ELSE
			xTP_FA_GD_MIN_W.PT := T#300s;		
		END_IF;			
		xTP_FA_GD_MIN_W();
		GD_MIN_W := xTP_FA_GD_MIN_W.Q OR (ZM AND GD_MIN);
	
		bMsg3221_Set := GD_MIN_W OR 
		(HM_GDMI1 AND NOT MM2VIS.bMsg1028 AND NOT Para.bGCActive AND 
		(OUT_GT.bGT_TypSwhActive OR OUT_GT.bGT_TypSwhActiveHalt));
	
		(* W2694 Gas pressure minimum warning/blocking gas train 1 line 2 *)
		bMsg2694_Set := HM_GDMI1_2 AND NOT MM2VIS.bMsg1028 AND NOT Para.bGCActive AND 
		(OUT_GT.bGT_TypSwhActive OR OUT_GT.bGT_TypSwhActiveHalt);

		(* W2695 Gas pressure minimum warning/blocking gas train 1 line 3 *)
		bMsg2695_Set := HM_GDMI1_3 AND NOT MM2VIS.bMsg1028 AND NOT Para.bGCActive AND 
		(OUT_GT.bGT_TypSwhActive OR OUT_GT.bGT_TypSwhActiveHalt);

		(* W2696 Gas pressure minimum warning/blocking gas train 1 line 4 *)
		bMsg2696_Set := HM_GDMI1_4 AND NOT MM2VIS.bMsg1028 AND NOT Para.bGCActive AND 
		(OUT_GT.bGT_TypSwhActive OR OUT_GT.bGT_TypSwhActiveHalt);

		(* W3222 Gas pressure minimum gas train 2 *)
		bMsg3222_Set := HM_GDMI2 AND NOT MM2VIS.bMsg1030;	
			
		(* Gas pressure maximum *)
		GD_MAX_a := Para.bPr_GT_MaxActive AND IN_GT.tPr_GT_Gas.GoodQual;
		
		xGR_MAX_FA_GD_MAX.In := IN_GT.tPr_GT_Gas.Ai;
		xGR_MAX_FA_GD_MAX.Gw := Para.rPr_GT_LimMax;
		xGR_MAX_FA_GD_MAX.Hy := Para.rPr_GT_HyMax;
		xGR_MAX_FA_GD_MAX();
	 		
		xTON_FA_T_GD_MAX.IN := IN_GT.tPB2MM.bParaSetupOk AND xGR_MAX_FA_GD_MAX.Q;
		xTON_FA_T_GD_MAX.PT := T#2s;
		xTON_FA_T_GD_MAX();
		
		GD_MAX := GD_MAX_a AND xTON_FA_T_GD_MAX.Q;	
	ELSE	
		MS_GD	 := FALSE;
		GD_MIN	 := FALSE;
		GD_MIN_W := FALSE;
		GD_MAX	 := FALSE;
		OUT_GT.rP_Red_GasPr_Norm := 1.0;		
	END_IF;

	(* Tecjet differential pressure *) 
	IF (Para.iTJ_DPress_PowRed_Mode = 1 OR Para.iTJ_DPress_PowRed_Mode = 2) AND IN_GT.rP_Act_Norm_Filt >= 0.4 AND IN_GT.iN_GMU_Devices <> 0 AND Para.bTJ_Exist THEN
		rGMU_Pr_DiffGas_min := 1.00;  

		FOR i := 1 TO IN_GT.iN_GMU_Devices BY 1 DO					(* select the minimum delta P of all Tecjet valves *)
			IF rGMU_Pr_DiffGas_min > IN_GT.rGMU_Pr_DiffGas[i] AND IN_GT.rGMU_Pos_Valve_Prom[i] > 0.005 THEN
					rGMU_Pr_DiffGas_min := IN_GT.rGMU_Pr_DiffGas[i];
			END_IF;
		END_FOR
		xTON_TJdeltaP_min(IN := rGMU_Pr_DiffGas_min < Para.rTJ_DPress_Min, PT := Para.tiTJ_DPress_Min_Delay);
		bPr_TecJetDP_Min	   	:= 	xTON_TJdeltaP_min.Q;		(* stop the motor with priority 3 *)
	ELSE
		xTON_TJdeltaP_min(IN  := FALSE, PT :=  Para.tiTJ_DPress_Min_Delay);
		bPr_TecJetDP_Min 		:= FALSE;
	END_IF;	
	
	IF 	Para.iTJ_DPress_PowRed_Mode = 2 AND IN_GT.rP_Act_Norm_Filt >= 0.4 AND IN_GT.iN_GMU_Devices <> 0 AND Para.bTJ_Exist THEN (* Gas supply pressure measurement activated and function of power reduction based on delta P of Tecjet activated*)
		SimPID_deltaP_TJ.ssMethodType		:=	3;							 (* Controller Mode 3 --> Automatic mode *)
		SimPID_deltaP_TJ.w					:=  Para.rTJ_DPress_P_Red_Start; (* 0.02bar is the mimimum for this parameter *)		
		SimPID_deltaP_TJ.x					:=	rGMU_Pr_DiffGas_min;
		SimPID_deltaP_TJ.P 					:=  Para.rCtr_TJ_DPress_kp;
		SimPID_deltaP_TJ.I 					:=  Para.rCtr_TJ_DPress_ki; 	
		SimPID_deltaP_TJ.umin       		:=  MAX(IN_GT.rP_Set_Min_Norm, 0.4) - LIMIT(MAX(IN_GT.rP_Set_Min_Norm, 0.4), IN_GT.rP_Set_Unred_Norm, 1);		
	
		SimPID_deltaP_TJ();

		IF SimPID_deltaP_TJ.u < 0 THEN 
			OUT_GT.rP_Red_TJDiffPr_Norm := LIMIT(MAX(IN_GT.rP_Set_Min_Norm, 0.4), SimPID_deltaP_TJ.u + rP_Set_Unred_Norm_GT, 1); //Start reduction from actual power
			bPr_TecJetDP_P_Red := TRUE;
		ELSE
			OUT_GT.rP_Red_TJDiffPr_Norm := 1;
			rP_Set_Unred_Norm_GT := IN_GT.rP_Set_Unred_Norm;
			bPr_TecJetDP_P_Red := FALSE;
		END_IF;
	ELSE
		OUT_GT.rP_Red_TJDiffPr_Norm := 1;
		bPr_TecJetDP_P_Red := FALSE;
	END_IF;
	(************************************************************************************************************)	
	(* Suction pressure *)
	IF Para.bP_GT_SuctPrActive THEN		
		(* Suction pressure measurement signal failure *)
		MS_SD := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tPr_GT_Suct.GoodQual;
			
		(* Reduction due to Suction pressure *)
		RED_SD_a := Para.bP_Red_SuctPrActive AND NOT MS_SD AND NOT IN_GT.tP_Red_SuctPrActive.Di AND IN_GT.tPB2MM.bParaSetupOk;
		xSigScalR_FA_SD_RED.X  := IN_GT.tPr_GT_Suct.Ai;
		xSigScalR_FA_SD_RED.X1 := Para.rP_Red_SuctPrStart;
		xSigScalR_FA_SD_RED.Y1 := 1.00;
		xSigScalR_FA_SD_RED.X2 := Para.rP_Red_SuctPrHalfLoad;
		xSigScalR_FA_SD_RED.Y2 := 0.50;
		xSigScalR_FA_SD_RED();	
		IF RED_SD_a THEN
			OUT_GT.rP_Red_SuctPr_Norm := LIMIT(0,xSigScalR_FA_SD_RED.Y_SCAL,1.00);
		ELSE
			OUT_GT.rP_Red_SuctPr_Norm := 1.0;
		END_IF;	
		
		(* Suction pressure minimum *)
		xGR_MINR_FA_SDMIN.In := ABS(IN_GT.tPr_GT_Suct.Ai);
		xGR_MINR_FA_SDMIN.Hy := Para.rPr_GT_SuctPrHyMin;
		xGR_MINR_FA_SDMIN.Gw := ABS(Para.rPr_GT_SuctPrLimMin);
		xGR_MINR_FA_SDMIN();
		xTON_FA_T_SD_MIN.IN  := xGR_MINR_FA_SDMIN.Q AND IN_GT.tPB2MM.bParaSetupOk;
		xTON_FA_T_SD_MIN.PT  := T#2s;
		xTON_FA_T_SD_MIN();	
		bMsgDummy_Min_SuctPr := xTON_FA_T_SD_MIN.Q;	// formerly SD_MIN
		
		(* Suction pressure maximum *)
		xGR_MAXR_FA_SDMAX.In := ABS(IN_GT.tPr_GT_Suct.Ai);
		xGR_MAXR_FA_SDMAX.Hy := Para.rPr_GT_SuctPrHyMax;
		xGR_MAXR_FA_SDMAX.Gw := ABS(Para.rPr_GT_SuctPrLimMax);
		xGR_MAXR_FA_SDMAX();
		xTON_FA_T_SD_MAX.IN  := xGR_MAXR_FA_SDMAX.Q AND IN_GT.tPB2MM.bParaSetupOk;
		xTON_FA_T_SD_MAX.PT  := T#2s;
		xTON_FA_T_SD_MAX();		
		bMsgDummy_Max_SuctPr := xTON_FA_T_SD_MAX.Q;  // formerly SD_MAX		
	ELSE
		MS_SD 				 := FALSE;
		bMsgDummy_Min_SuctPr := FALSE;
		bMsgDummy_Max_SuctPr := FALSE;
		OUT_GT.rP_Red_SuctPr_Norm := 1.0;	
	END_IF;	

	(************************************************************************************************************)	
	(* O2_MAX A1087 O2 content high *)
	IF Para.bGT_O2Active THEN
		(* O2 content measurement signal error *)
		MS_O2   := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tGT_O2.GoodQual;
		MS_O2_W := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tGT_O2.GoodQual AND NOT Para.bGT_O2MaxTripActive;
		MS_O2_A := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tGT_O2.GoodQual AND Para.bGT_O2MaxTripActive;
	
		(* O2 content maximum  *)		
		xGR_MAX_FA_O2_MAX.In := IN_GT.tGT_O2.Ai;
		xGR_MAX_FA_O2_MAX.Hy := Para.rGT_O2HyMax;
		xGR_MAX_FA_O2_MAX.Gw := Para.rGT_O2LimMax;
		xGR_MAX_FA_O2_MAX();
		xTON_FA_T_O2_MAX.IN := xGR_MAX_FA_O2_MAX.Q AND IN_GT.tPB2MM.bParaSetupOk;
		xTON_FA_T_O2_MAX.PT := T#2s;
		xTON_FA_T_O2_MAX();
		O2_MAX := xTON_FA_T_O2_MAX.Q AND Para.bGT_O2MaxTripActive;	
	ELSE	
		MS_O2	:= FALSE;
		MS_O2_W := FALSE;
		MS_O2_A := FALSE;
		O2_MAX  := FALSE;	
	END_IF;	
	
	(************************************************************************************************************)	
	(* Gas temperature L089 *)
	IF Para.bT_GT_Active THEN

		(* Gas temperature measurement signal error *)
		MS_GT  := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tT_GT.GoodQual;
		
		(* Gas temperature minimum *)
		xGR_MIN_FA_GT_MIN.In := IN_GT.tT_GT.Ai;
		xGR_MIN_FA_GT_MIN.Hy := Para.rT_GT_HyMin;
		xGR_MIN_FA_GT_MIN.Gw := Para.rT_GT_LimMin;
		xGR_MIN_FA_GT_MIN(); 
		xTON_FA_T_GT_MIN.IN := IN_GT.tPB2MM.bParaSetupOk AND xGR_MIN_FA_GT_MIN.Q;
		xTON_FA_T_GT_MIN.PT := T#2s;
		xTON_FA_T_GT_MIN();
		GT_MIN := xTON_FA_T_GT_MIN.Q;	
		
		(* Gas temperature maximum *)
		xGR_MAX_FA_GT_MAX.In := IN_GT.tT_GT.Ai;
		xGR_MAX_FA_GT_MAX.Hy := Para.rT_GT_HyMax;
		xGR_MAX_FA_GT_MAX.Gw := Para.rT_GT_LimMax;
		xGR_MAX_FA_GT_MAX();
		xTON_FA_T_GT_MAX.IN := IN_GT.tPB2MM.bParaSetupOk AND xGR_MAX_FA_GT_MAX.Q;
		xTON_FA_T_GT_MAX.PT := T#2s;
		xTON_FA_T_GT_MAX();	
		GT_MAX := xTON_FA_T_GT_MAX.Q;
	ELSE
		MS_GT 	:= FALSE;
		GT_MIN	:= FALSE;
		GT_MAX	:= FALSE;
	END_IF;	
		
	(************************************************************************************************************)
	(* Gas quantity  L105 *)   
	IF Para.bVol_GT_Active THEN
		MS_GM := IN_GT.tPB2MM.bParaSetupOk AND NOT IN_GT.tVol_GT.GoodQual;
	ELSE
		MS_GM := FALSE;
	END_IF;
	

	(************************************************************************************************************)
	(* Freigabe aus Gasstation (W3153) *)
	IF IN_GT.bRelGasPlant_Bus_Active THEN
		xTOF_FA_T_FG_GAS.IN := IN_GT.bRelGasPlant_Bus;
	ELSE
		xTOF_FA_T_FG_GAS.IN := IN_GT.tRelGasPlant.Di; 			
	END_IF;
	
	xTOF_FA_T_FG_GAS.PT := T#2s;
	xTOF_FA_T_FG_GAS();
	T_FG_GAS := xTOF_FA_T_FG_GAS.Q;
	
	xTP_FA_FG_GAS.IN := ((IN_GT.bEng_Aux_Dem OR NOT FGGAS) AND NOT OUT_GT.bGT2_Select) AND NOT T_FG_GAS;
	IF bTestEnabled THEN
		xTP_FA_FG_GAS.PT := T#3s;
	ELSE
		xTP_FA_FG_GAS.PT := T#300s;
	END_IF;		
	xTP_FA_FG_GAS();
	FGGAS := NOT ((IN_GT.bEng_Aux_Dem OR NOT FGGAS) AND NOT OUT_GT.bGT2_Select AND
	(xTP_FA_FG_GAS.Q OR NOT T_FG_GAS));
	
	(* 	Blockierung Modul (pb7/M_BLOCK)  *)
	OUT_GT.bGasSupplyOk := OUT_GT.bGT2_Select OR (NOT CH4_MIN_W AND NOT MM2VIS.bMsg_Dummy_Warn_CV AND NOT GD_MIN_W AND FGGAS);
	
	
	(************************************************************************************************************)
	(* Alarms *)
	(* 1028 gas pressure low gas train 1 *)
	xTON_GDMI1(IN := (NOT IN_GT.tPr_GT1_Min.Di OR NOT IN_GT.tPr_GT1_1_Min.Di OR IN_GT.bPr_GT1_Min_Cust), PT := T#2s);
	HM_GDMI1 := xTON_GDMI1.Q;
	
	ZM_GDMI1 := ((HM_GDMI1 AND NOT Para.bPurgecycle_Active) OR ((NOT IN_GT.tPr_GT1_Min.Di OR NOT IN_GT.tPr_GT1_1_Min.Di OR IN_GT.bPr_GT1_Min_Cust) AND Para.bPurgecycle_Active)) AND 
	(FG_GDRUW OR (ZM_GDMI1 AND NOT Para.bGCActive)) AND 
	NOT OUT_GT.bGT2_Select AND 
	(T_GDRUW OR NOT Para.bGCActive);
	
	bMsg1028_Set := (ZM_GDMI1 AND NOT Para.bVISA) OR (HM_GDMI1 AND Para.bVISA);
	
		
	(* 1030 Gas pressure low gas train 2 *)
	xTON_GDMI2(IN := NOT IN_GT.tPr_GT2_Min.Di, PT := T#2s);
	HM_GDMI2 := xTON_GDMI2.Q;
	
	ZM_GDMI2 := ((HM_GDMI2 AND NOT Para.bPurgecycle_Active) OR (NOT IN_GT.tPr_GT2_Min.Di AND Para.bPurgecycle_Active)) AND
	(FG_GDRUW OR ZM_GDMI2) AND (OUT_GT.bGT2_Select OR UW_GST2);			 
	
	bMsg1030_Set := (ZM_GDMI2 AND NOT Para.bVISA)  OR (HM_GDMI2 AND Para.bVISA);
	
	
	(* 1057 gas train 1 gas pressure high *)
	(* flag for deactivating gas pressure monitoring (V1.70.1) *)
	xTOF_N2_GASV(IN:= IN_GT.tN2_ScavGV_CoOpen.Do, PT := T#5s);		// before realised in N2spueleung #41 
	T_N2_GASV := xTOF_N2_GASV.Q;
	
	xTON_GDMA1.IN := (NOT T_N2_GASV OR NOT IN_GT.bRel_ScavN2) AND (NOT IN_GT.tPr_GT1_Max.Di OR NOT IN_GT.tPr_GT1_1_Max.Di OR IN_GT.bPr_GT1_Max_Cust);
	xTON_GDMA1.PT := T#4s;
	xTON_GDMA1();
	
	ZM_GDMA1 := IN_GT.tEng_Run.Do AND M_GASV1 AND 
	((Para.bPurgecycle_Active AND xTON_GDMA1.IN AND FG_GDRUW) OR
	(NOT Para.bPurgecycle_Active AND xTON_GDMA1.Q));
				 
	xTON_GDMA1_VISA.IN := (NOT IN_GT.tPr_GT1_Max.Di OR NOT IN_GT.tPr_GT1_1_Max.Di OR IN_GT.bPr_GT1_Max_Cust); 
	xTON_GDMA1_VISA.PT := T#3s;
	xTON_GDMA1_VISA();
	
	bMsg1057_Set := (ZM_GDMA1 AND NOT Para.bVISA) OR (xTON_GDMA1_VISA.Q AND Para.bVISA);


	(* 1058 gas pressure high gas train 2 *)	
	xTON_GDMA2.IN := (NOT T_N2_GASV OR NOT IN_GT.bRel_ScavN2) AND NOT IN_GT.tPr_GT2_Max.Di;
	xTON_GDMA2.PT := T#4s;
	xTON_GDMA2();
	
	ZM_GDMA2 := IN_GT.tEng_Run.Do AND M_GASV2 AND 
	((NOT Para.bPurgecycle_Active AND xTON_GDMA2.Q) OR 
	(Para.bPurgecycle_Active AND xTON_GDMA2.IN AND FG_GDRUW));
	
	xTON_GDMA2_VISA.IN := NOT IN_GT.tPr_GT2_Max.Di;
	xTON_GDMA2_VISA.PT := T#3s;
	xTON_GDMA2_VISA();
	
	bMsg1058_Set := (ZM_GDMA2 AND NOT Para.bVISA) OR (xTON_GDMA2_VISA.Q AND Para.bVISA);
	
	
	(* 3353 gas pressure low gas train 1 - line 2 *)
	xTON_GDMI1_2(IN := NOT IN_GT.tPr_GT1_2_Min.Di, PT := T#2s);
	HM_GDMI1_2 	:= AKT_Gastrecke1_2 AND xTON_GDMI1_2.Q;
	
	ZM_GDMI1_2 	:= 	((xTON_GDMI1_2.Q AND NOT Para.bPurgecycle_Active) OR (NOT IN_GT.tPr_GT1_2_Min.Di AND Para.bPurgecycle_Active)) AND
	(FG_GDRUW OR (ZM_GDMI1_2 AND NOT Para.bGCActive)) AND
	NOT OUT_GT.bGT2_Select AND
	(T_GDRUW OR NOT Para.bGCActive);	
	
	bMsg3353_Set :=	AKT_Gastrecke1_2 AND
	((ZM_GDMI1_2 AND NOT Para.bVISA) OR (xTON_GDMI1_2.Q AND Para.bVISA));
	
	
	(* 3354 gas pressure low gas train 1 - line 3 *)
	xTON_GDMI1_3(IN := NOT IN_GT.tPr_GT1_3_Min.Di, PT := T#2s);
	HM_GDMI1_3 	:= AKT_Gastrecke1_3 AND xTON_GDMI1_3.Q;
	
	ZM_GDMI1_3 	:= 	((xTON_GDMI1_3.Q AND NOT Para.bPurgecycle_Active) OR (NOT IN_GT.tPr_GT1_3_Min.Di AND Para.bPurgecycle_Active)) AND
	(FG_GDRUW OR (ZM_GDMI1_3 AND NOT Para.bGCActive)) AND
	NOT OUT_GT.bGT2_Select AND
	(T_GDRUW OR NOT Para.bGCActive);	
	
	bMsg3354_Set :=	AKT_Gastrecke1_3 AND		
	((ZM_GDMI1_3 AND NOT Para.bVISA) OR (xTON_GDMI1_3.Q AND Para.bVISA));
	
			
	(* 3355 gas pressure low gas train 1 - line 4 *)
	xTON_GDMI1_4(IN := NOT IN_GT.tPr_GT1_4_Min.Di, PT := T#2s);
	HM_GDMI1_4 	:= AKT_Gastrecke1_4 AND xTON_GDMI1_4.Q;
	
	ZM_GDMI1_4 	:= 	((xTON_GDMI1_4.Q AND NOT Para.bPurgecycle_Active) OR (NOT IN_GT.tPr_GT1_4_Min.Di AND Para.bPurgecycle_Active)) AND
	(FG_GDRUW OR (ZM_GDMI1_4 AND NOT Para.bGCActive)) AND
	NOT OUT_GT.bGT2_Select AND
	(T_GDRUW OR NOT Para.bGCActive);	
	
	bMsg3355_Set :=	AKT_Gastrecke1_4 AND		
	((ZM_GDMI1_4 AND NOT Para.bVISA) OR (xTON_GDMI1_4.Q AND Para.bVISA));
	
	
	(* 3356 gas train 1 gas pressure high - line 2 *)
	xTON_GDMIA1_2(IN := (NOT T_N2_GASV OR NOT IN_GT.bRel_ScavN2) AND NOT IN_GT.tPr_GT1_2_Max.Di, PT := T#4s);
	ZM_GDMA1_2	:= ((NOT Para.bPurgecycle_Active AND xTON_GDMIA1_2.Q) OR
	(Para.bPurgecycle_Active AND xTON_GDMIA1_2.IN AND FG_GDRUW)) AND
	M_GASV1 AND IN_GT.tEng_Run.Do;
				
	xTON_GDMA1_2_VISA(IN := NOT IN_GT.tPr_GT1_2_Max.Di, PT := T#3s);				
	bMsg3356_Set := AKT_Gastrecke1_2 AND
	(ZM_GDMA1_2 AND NOT Para.bVISA) OR (xTON_GDMA1_2_VISA.Q AND Para.bVISA);				
			
	
	(* 3357 gas train 1 gas pressure high - line 3 *)
	xTON_GDMIA1_3(IN := (NOT T_N2_GASV OR NOT IN_GT.bRel_ScavN2) AND NOT IN_GT.tPr_GT1_3_Max.Di, PT := T#4s);
	ZM_GDMA1_3 	:= ((NOT Para.bPurgecycle_Active AND xTON_GDMIA1_3.Q) OR 
	(Para.bPurgecycle_Active AND xTON_GDMIA1_3.IN AND FG_GDRUW)) AND
	M_GASV1 AND IN_GT.tEng_Run.Do;
				
	xTON_GDMA1_3_VISA(IN := NOT IN_GT.tPr_GT1_3_Max.Di, PT := T#3s);				
	bMsg3357_Set := AKT_Gastrecke1_3 AND
	(ZM_GDMA1_3 AND NOT Para.bVISA) OR (xTON_GDMA1_3_VISA.Q AND Para.bVISA);			
				
	
	(* 3358 gas train 1 gas pressure high - line 4 *)
	xTON_GDMIA1_4(IN := (NOT T_N2_GASV OR NOT IN_GT.bRel_ScavN2) AND NOT IN_GT.tPr_GT1_4_Max.Di, PT := T#4s);
	ZM_GDMA1_4 	:= ((NOT Para.bPurgecycle_Active AND xTON_GDMIA1_4.Q) OR 
	(Para.bPurgecycle_Active AND xTON_GDMIA1_4.IN AND FG_GDRUW)) AND
	M_GASV1 AND IN_GT.tEng_Run.Do;
				
	xTON_GDMA1_4_VISA(IN := NOT IN_GT.tPr_GT1_4_Max.Di, PT := T#3s);				
	bMsg3358_Set := AKT_Gastrecke1_4 AND
	(ZM_GDMA1_4 AND NOT Para.bVISA) OR (xTON_GDMA1_4_VISA.Q AND Para.bVISA);	

	(* 9371 Measuring signal failure setpoint - Gas mixing *)
	IF IN_GT.tGT_RatioMix_Set.Exist AND NOT IN_GT.tGT_RatioMix_Set.GoodQual THEN
		bMsg9371_Set := TRUE;
	ELSE
		bMsg9371_Set := FALSE;
	END_IF;	

END_PROGRAM
