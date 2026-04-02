(***************************************************************************
gasum			GASUMSCHALTUNG/GASMISCHBETRIEB MIT KLAPPEN/VENTILEN BZW. TECJET  

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, OR reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	03.07.98/Pa		erstellt
        24.11.98/Pa		korrekturlesung
V170	06.04.02/LH		überarbeitet
V180	21.01.03/LH		Fehler bei Umschaltung im Stillstand ausgebessert
V183	18.09.03/LH		Kontaktplan --> strukturierten Text
 		02.10.03/LH		Gasmischbetrieb
V2071	22.11.04/LH		Schliessen der entsprechenden Gasstrecke bei Erreichen einer Endlage
                   		Blockierung Mischgasstart
		07.02.05/LH		Gasstrecke nicht mehr anwählbar wenn gestört
		03.03.05/LH		neue Variable "GASUM" eingeführt
V2071b	28.06.05/LH		Task überarbeitet
V210	18.10.04/LH		neu: Mischgasverhältnis manuell einstellbar
V220	28.03.07/LH		Task überarbeitet
V2201	08.08.07/LH		Leistung absenken vor Öffnen der 2. Gasstrecke bei TecJet
V230	16.01.08/LH		Hinweis für Leistungsabsenkung
V2311a	13.05.08/LH		Leistungsabsenkung aus Mischgas wenn Gasmischverhältnis aus Endlage geht
V2.50.0	25.03.2009 		Lettenb.	ssPowerSetpointLimit2 was ssPowerSetpointLimit1 (gasmix->res.2)
V2.50.1 08.07.2009 		Lett./LH Fehler bei Schritt30, bCrossOver und P_FUG ausgebessert	 
V2.60.0	06.10.2009 		Lettenb	task activation added
V2.60.1	20.01.2010 		lettenb.	INIT: M_GASV1 preset TRUE was FALSE, init vars reduced
V3.20.0	30.09.2010 		Maier(BuR)	M_GSEIN replaced with GCB_ON
V3.99	21-09-2013		Denk 	       	generated for modular software
V3.99.1	14-03-2013		Denk 	       	rFeedbFlap1,rFeedbFlap2,rGT_RatioMix_Set changed from Para to IN-structure
V4.00.00 25-02-2014		Denk/Zengerer  	new interface IN_GT.bGT_SelectRatioMix for DI 'MISCH', FA_M_GASV1, V2 parameter limitation
V4.03.00 29-05-2015		Denk	       	Bugfix, FA_M_GASV2.Hy soll immer 0 sein. Wie bei XT3.
		 02-07-2015		Denk 			Bugfix, 3321 NOT activ when gastrain 2 is active. NOT was missing --> NOT MM2VIS.bMsg1028
		 								Warnings FOR 4 gaslines bMsg2694-2696 added
V4.04.00 06.02.2017		Denk			Bugfix, IN_GT.bIdx_Leanox_Act deleted, changed to IN_GT.bLeanox_Active 
V4.05.00 12-10-2017		Zengerer  		Prepare vor standard with tCustAnaIn[1] or IN_GT.rGT_RatioMix_Set, to select the customized setpoint value for ssRatioMix  [0-1] 
V4.11.00 17-03-2022		Zuschnig	Use standard label from customized modul for gasmixing setpoint	
		 18-03-2022		Zuschnig	Removed fixed spare parameter and customized analog input	
V4.13.00 20-06-2023		Zuschnig  	Added standardized AI input for gas mixing ratio	
		 20-12-2023		Zuschnig	Prevent division by zero

	 
Instructions for use:
--------------------
activate task if used with Parameter


Outstandings:
------------

****************************************************************************)

(* Übersicht Gasumschaltung *)

(*
           +---------------------------------+                              Umschaltung mit Klappen/Ventilen
           !                                 !                              ohne Rückmeld. und guter Gasqualität
           V                                 V
    +-------------+   +-------------+   +-------------+   +-------------+   Umschaltung mit Klappen/Ventilen
    ! GAS1_2|GAS1 !<->!    GAS2     !<->!    GAS4     !<->!    GAS3     !   ohne Rückmeldung und
    +-------------+   +-------------+   +-------------+   +-------------+   schlechter Gasqualität
           A                                                      A         
           !          +-------------------------------+           !         Umschaltung bzw. Gasmischbetrieb mit
           +--------->!           GAS1_3              !<----------+         Klappen/Ventilen mit Rückmeldung
                      +-------------------------------+                     oder mit TecJet

****************************************************************************)
PROGRAM _CYCLIC

(*task activation *)
IF NOT Para.bGT_MixActive THEN   
	RETURN;
END_IF

 					
	IF	NOT Para.bTJ_Exist	THEN
		T_GAS1;										(* Klappen-Umschaltzeit [sec], Parameter Eingabe in sec *)
		T_GAS2;										(* Klappen-Umschaltzeit [sec], Parameter Eingabe in sec *)
		T_GAS3;										(* Klappen-Umschaltzeit [sec], Parameter Eingabe in sec *)
		T_GAS4;										(* Klappen-Umschaltzeit [sec], Parameter Eingabe in sec *)
		T_GAS1_4;									(* Klappen-Umschaltzeit [sec], Parameter Eingabe in sec *)
		T_GAS4_1;									(* Klappen-Umschaltzeit [sec], Parameter Eingabe in sec *)
		T_IMPULS;									(* Stellimpuls Klappen  [sec], Parameter Eingabe in sec *)
		T_PAUSE;									(* Pausenzeit Klappen   [sec], Parameter Eingabe in sec *)
	
		FA_GAS1_2.In		:=	X_GMISCH_2;			(* Gas quality [0-1 = 0-100%] *)
		FA_GAS1_2.Gw		:=	0;					(* GW hohe Qual. [0-1 = 0-100%], Parameter Eingabe in 0-100% *)
		FA_GAS1_2.Hy		:=	0;					(* HY hohe Qual. [0-1 = 0-100%], Parameter Eingabe in 0-100% *)
		FA_GAS1_2;
		GAS1_2_HQ			:=	FA_GAS1_2.Q;		(* GAS1_2 mit hoher Qualität *)
	
		mit_RM				:=	FALSE;				(* Rückmeldung von Klappen/Ventilen vorhanden *)
		RM_KL1				:=	0;					(* RM Klappe/Ventil Gasstrecke 1 *)
		RM_KL2				:=	0;					(* RM Klappe/Ventil Gasstrecke 2 *)

	END_IF;
	(* bis hier eventuell löschen ------------------------------------------------------------------------------------------------------- *)

	(* Gas mixing setpoint from MM Customized, or directliy connected here with Customized AI[x]  *)
	IF  IN_GT.bOptGT_RatioMix_Set THEN
		X_SOLLW			:=	REAL_TO_INT(LIMIT(0.0, IN_GT.rGT_RatioMix_Set, 1.0) * 1000);	(* Ratio mix from customized module -> 0 - 1 = 0 - 100% *)	
	ELSE
		X_SOLLW			:=	REAL_TO_INT(LIMIT(0.0, IN_GT.tGT_RatioMix_Set.Ai, 1.0) * 1000); (* Ratio mix from AI standard label -> 0 - 1 = 0 - 100% *)
	END_IF

	MISCH				:=  IN_GT.tGT_SelectRatioMix.Di;									(* Digital input to select gas mixing (1-3 or 1_2-3) *)
	GUMSCH 				:= 	IN_GT.tGT_TypSwitch.Di;											(* Digital input to select gas type switching *)

	FA_M_GASV1.In		:=	REAL_TO_INT(OUT_GT.rGT_RatioMix * 1000);						(* MAX-Grenzwert Mischrate *)
	FA_M_GASV1.Gw		:=	1000;															(* GW Mischrate [0-1000 = 100%], Parameter Eingabe in 0-100% *)
	FA_M_GASV1.Hy		:=	5;																(* HY Mischrate [0-1000 = 100%], Parameter Eingabe in 0-100% *)
	FA_M_GASV1;																				(* --> Schliessen Gasventil 1 *)
	
	FA_M_GASV2.In		:=	REAL_TO_INT(OUT_GT.rGT_RatioMix * 1000);						(* MIN-Grenzwert Mischrate *)
	FA_M_GASV2.Gw		:=	0;																(* GW Mischrate [0-1000 = 100%], Parameter Eingabe in 0-100% *)
	FA_M_GASV2.Hy		:=	5;																(* HY Mischrate [0-1000 = 100%], Parameter Eingabe in 0-100% *)
	FA_M_GASV2;																				(* --> Schliessen Gasventil 2 *)
	
	
	(* Copy of input variables to local *)			//!!! new 
	ssRatioMix 			:= REAL_TO_INT(OUT_GT.rGT_RatioMix * 1000);	
	M_BTRB 				:= IN_GT.tEng_Run.Do;
	GCB_ON 				:= IN_GT.tGCB_On.Di;
	M_GASV 				:= OUT_GT.bGV_On;
	AUTGAS				:= OUT_GT.bSelGasTypAut;
	GAS1_2_MAN			:= OUT_GT.bSelGasTyp0;
	GAS1_3_MAN			:= OUT_GT.bSelGasTypMix;
	GAS1				:= OUT_GT.bSelGasTyp1;
	GAS2				:= OUT_GT.bSelGasTyp2;
	GAS3				:= OUT_GT.bSelGasTyp3;
	GAS4				:= OUT_GT.bSelGasTyp4;
	bLeanoxActive		:= IN_GT.bLeanox_Active;
	l_einst_a			:= IN_GT.bLeanox_Man;
	M_NANF				:= IN_GT.bEng_Dem_EPS;
	M_GDMI1W			:= MM2VIS.bMsg3221;
	M_GDMI1_1W			:= MM2VIS.bMsg2694;
	M_GDMI1_2W			:= MM2VIS.bMsg2695;
	M_GDMI1_3W			:= MM2VIS.bMsg2696;
	M_GDMI2W			:= MM2VIS.bMsg3222;
	anz_gasart			:= INT_TO_USINT(Para.iIdx_Gastyp);
	bTecJetOn			:= Para.bTJ_Exist;
	GASV1				:= OUT_GT.tGV1_Open.Do;
	GASV2				:= OUT_GT.tGV2_Open.Do;
	p_ist				:= REAL_TO_INT(IN_GT.rP_Act_Norm_Filt * IN_GT.rP_Nom);
	bSetMix_Man			:= bGT_RatioMix_Man_Set;						// From Visu
	bMisch1_2_Man		:= bGT_QualMix_Man_Set;							// From Visu
	ssSetMix_Man		:= REAL_TO_INT((rGT_RatioMix_Man_Set) * 1000);	// From Visu
	KL1_AUF				:= IN_GT.tGT_Flap1_Opened.Di;					//will be no IN in future
	KL1_ZU				:= IN_GT.tGT_Flap1_Closed.Di;					//will be no IN in future
	KL2_AUF				:= IN_GT.tGT_Flap2_Opened.Di;					//will be no IN in future
	KL2_ZU				:= IN_GT.tGT_Flap2_Closed.Di;					//will be no IN in future
	GAS1_2				:= OUT_GT.bGT_Ipol12Active;						
	
	
	//There will be NO spare power reduction in future. One standard for gasmixing 
	//--> required setpoint will be setted via OUT_GT.rP_Red_GasSwitch in %
	sel_PowerSetpointLimit := 1;												    				(*Auswahl Reserve-Red: 1 = P-Red Reserve 1
																										 					2 = P-Red Reserve 2
																															3 = P-Red Reserve 3 *)
	ssPowerSetpointLimit:=  4000; 																	(* Text: P_401 !     *)(* Reduktionsleistung für Öffnen 2. Gasstr.[kW] *)
																									(* P_40 Text2! *)
																				
//	TOF_FUGITIV.PT 		:= 	INT_TO_UDINT(LIMIT(5, SPS_REZP1, 5))*100;								//existing code																			
	TOF_FUGITIV.PT 		:= 	500;	    															(* Verweilzeit auf Reduktionleistung [sec], Parameter Eingabe in sec *)
	TON_P_FUG.PT		:=	200;																	(* Beruhigungzeit bei Erreichen von Pred [0,01sec] *)
	
	T_TJ				:=	10;																		(* Änderungsgeschwindigkeit Mischrate [promill/sec] *)

	GU_TJ				:=	bTecJetOn;																(* Gasumschaltung mit TecJet *)
	GASUM				:=	TRUE;																	(* Freigabe Gasumschaltung *)
	GAS1_3				:=	GU_TJ OR mit_RM;														(* Freigabe Gasmischung *)
	bGasMixture			:=	GU_TJ AND GASUM;														(* Freigabe Mischgas für VISU (Vers. > 2.10 --> "engine data") *)
	
	
						(* Auswahl Treibgasart *)
	
	FG_MIX				:=	M_BTRB AND (GCB_ON OR FG_MIX);						(* Freigabe Mischgasbetrieb *)
	
	IF	NOT FG_MIX	THEN
						MISCH				:=	0;
						IF	M_GASV	THEN										(* Gasart fixieren! *)
											GUMSCH				:=	GUMSCH_OLD;
						ELSE				GUMSCH_OLD			:=	GUMSCH;
						END_IF;
	END_IF;
	
	MISCHGAS			:=	(AUTGAS AND     MISCH OR GAS1_3_MAN)AND(GAS1_3 OR   bLeanoxActive) AND NOT l_einst_a AND NOT M_NANF AND FG_MIX ;

	GASSTR_1			:=	(AUTGAS AND NOT MISCH AND NOT GUMSCH OR(GAS1       AND NOT GAS1_2)
	                                                             OR(GAS1_2_MAN AND     GAS1_2))AND NOT l_einst_a AND NOT M_NANF;
	GASSTR_2			:=	(AUTGAS AND NOT MISCH AND     GUMSCH OR GAS3                      )AND NOT l_einst_a      OR M_NANF;
	
	IF	(M_GDMI1W OR M_GDMI1_1W OR M_GDMI1_2W OR M_GDMI1_3W) AND ANW_GST2	THEN	(* Gasstrecke 1 nicht anwählbar! *)
						MISCHGAS			:=	0;
						GASSTR_1			:=	0;
						GASSTR_2			:=	1;
	END_IF;
	
	IF	M_GDMI2W AND NOT UW_GST2 OR NOT(anz_gasart > 2)	THEN						(* Gasstrecke 2 nicht anwählbar! *)
						MISCHGAS			:=	0;
						GASSTR_1			:=	1;
						GASSTR_2			:=	0;
	END_IF;
	
	
						(* Schrittkette *)
	
	CASE	step OF	00:	(* Initialisierung (GUI_0) *)
						IF	 ssRatioMix = 0 AND bTecJetOn OR KL1_AUF AND KL2_AUF	THEN
											step				:=	10;			(* 10 = GAS1 / 20 = GAS3 *)
	(* bis hier bearbeiten -------------------------------------------------------------------------------------------------------------- *)
											IF	bTecJetOn	THEN
																step				:=	10;
											END_IF;
											GUI_7				:=	1;			(* Initialisierung abgeschlossen ! *)
						END_IF;
	
					10:	(* Treibgas 1 (GU2_7) *)
						IF	 (GASSTR_2 OR MISCHGAS) AND GAS1_3	THEN
											step				:=	11;
						ELSIF GASSTR_2 AND NOT GAS1_3	THEN
											step				:=	12;
						END_IF;
						IF	  GASSTR_2 AND M_NANF AND NOT GCB_ON AND KL2_AUF AND NOT GU_TJ	THEN
											step				:=	20;
						END_IF;
	
					11:	(* Treibgas 1 --> Mischgas (GU13_0) *)
						IF	(KL2_ZU AND NOT GU_TJ) OR NOT M_GASV OR P_FUG	THEN
											step				:=	30;
						END_IF;
	
					12:	(* Schliessen Klappe 2 (GU1_0) *)
						IF	KL2_ZU OR NOT M_GASV	THEN
											step				:=	13;
						END_IF;
	
					13:	(* Gasart 1 (GU1_1) *)
						IF	(T_GAS1_OK AND NOT GAS1_2_HQ) OR NOT M_GASV	THEN
											step				:=	14;
						END_IF;
						IF	(T_GAS1_4_OK AND GAS1_2_HQ) OR KL2_AUF	THEN
											step				:=	15;
						END_IF;
	
					14:	(* Gasart 2 (GU1_2) *)
						IF	KL2_AUF OR (T_GAS1_4_OK AND GAS1_2_HQ)	THEN
											step				:=	15;
						ELSIF NOT T_GAS1_4_OK AND GAS1_2_HQ	THEN
											step				:=	13;
						END_IF;
	
					15:	(* Gasart 4 (GU1_3) *)
						IF	T_GAS4_OK OR NOT M_GASV	THEN
											step				:=	16;
						ELSIF NOT KL2_AUF AND NOT GAS1_2_HQ	THEN
											step				:=	14;
						END_IF;
	
					16:	(* Gasart 3 (GU1_4) *)
						IF	KL1_ZU OR NOT M_GASV	THEN
											step				:=	20;
						END_IF;
	
					17:	(* Öffnen Klappe 2 (GU31_0) *)
						IF	KL2_AUF OR GU_TJ	THEN
											step				:=	18;
						END_IF;
	
					18:	(* Schliessen Klappe 1 (GU31_1) *)
						IF	KL1_ZU OR NOT M_GASV OR GU_TJ	THEN
											step				:=	19;
						END_IF;
	
					19:	(* Mischgas --> Treibgas 2 (GU31_2) *)
						IF	ssRatioMix = 1000 OR NOT GU_TJ	THEN
											step				:=	20;
						ELSIF	MISCHGAS OR GASSTR_1	THEN
											step				:=	30;
						END_IF;
	
					20:	(* Treibgas 2 (GU1_7) *)
						IF	 (MISCHGAS OR GASSTR_1) AND GAS1_3	THEN
											step				:=	21;
						ELSIF GASSTR_1 AND NOT GAS1_3	THEN
											step				:=	22;
						END_IF;
	
					21:	(* Treibgas 2 --> Mischgas (GU23_0) *)
						IF	KL1_ZU AND NOT GU_TJ OR NOT M_GASV OR P_FUG	THEN
											step				:=	30;
						END_IF;
	
					22:	(* Schliessen Klappe 1 (GU2_0) *)
						IF	KL1_ZU OR NOT M_GASV	THEN
											step				:=	23;
						END_IF;
	
					23:	(* Gasart 3 (GU2_1) *)
						IF	T_GAS3_OK OR NOT M_GASV OR KL1_AUF	THEN
											step				:=	24;
						END_IF;
	
					24:	(* Gasart 4 (GU2_2) *)
						IF	KL1_AUF	THEN
											IF	NOT GAS1_2_HQ	THEN
																step				:=	25;
											ELSIF	T_GAS4_1_OK OR NOT M_GASV	THEN
																step				:=	26;
											END_IF;
						END_IF;
	
					25:	(* Gasart 2 (GU2_3) *)
						IF	T_GAS2_OK OR (T_GAS4_1_OK AND GAS1_2_HQ) OR NOT M_GASV	THEN
											step				:=	26;
						ELSIF NOT T_GAS4_1_OK AND GAS1_2_HQ	THEN
											step				:=	24;
						END_IF;
	
					26:	(* Gasart 1 (GU2_4) *)
						IF	KL2_ZU OR NOT M_GASV	THEN
											step				:=	10;
						ELSIF NOT T_GAS2_OK AND NOT GAS1_2_HQ	THEN
											step				:=	25;
						END_IF;
	
					27:	(* Öffnen Klappe 1 (GU32_0) *)
						IF	KL1_AUF OR GU_TJ	THEN
											step				:=	28;
						END_IF;
	
					28:	(* Schliessen Klappe 2 (GU32_1) *)
						IF	KL2_ZU OR NOT M_GASV OR GU_TJ	THEN
											step				:=	29;
						END_IF;
	
					29:	(* Mischgas --> Treibgas 1 (GU32_2) *)
						IF	ssRatioMix = 0 OR NOT GU_TJ	THEN
											step				:=	10;
						ELSIF	GASSTR_2 OR MISCHGAS	THEN
											step				:=	30;
						END_IF;
	
					30:	(* Mischgas (GU3_7) *)
						IF		GASSTR_2	THEN
											step				:=	17;
						ELSIF	GASSTR_1	THEN
											step				:=	27;
						END_IF;
						IF	(X_SOLLW > (FA_M_GASV2.Gw + FA_M_GASV2.Hy)) AND NOT GASV2 AND M_GASV AND NOT P_FUG AND GU_TJ	THEN
											step				:=	11;
						END_IF;
						IF	(X_SOLLW < (FA_M_GASV1.Gw - FA_M_GASV1.Hy)) AND NOT GASV1 AND M_GASV AND NOT P_FUG AND GU_TJ	THEN
											step				:=	21;
						END_IF;
	
	END_CASE;
	
	
						(* Schrittkettenmerker *)
	
	zw					:= 1;
	FOR	i				:= 1 TO step	BY 1 DO
						zw				:=	zw * 2;
	END_FOR;
	FA_CONV_1.Word		:= UDINT_TO_UINT(zw);
	FA_CONV_1;
	
	zw					:= 1;
	FOR i				:= 17 TO step	BY 1 DO
						zw				:=	zw * 2;
	END_FOR;
	IF	step < 16 THEN	zw				:=	0;
	END_IF;
	FA_CONV_2.Word		:= UDINT_TO_UINT(zw);
	FA_CONV_2;
	
	GUI_0				:= FA_CONV_1.Bit00;										(* Initialisierung *)
	GUI_1				:= FA_CONV_1.Bit01;										(* Initialisierung *)
	GUI_2				:= FA_CONV_1.Bit02;										(* Initialisierung *)
	GUI_3				:= FA_CONV_1.Bit03;										(* Initialisierung *)
	GUI_4				:= FA_CONV_1.Bit04;										(* Initialisierung *)
	GUI_5				:= FA_CONV_1.Bit05;										(* Initialisierung *)
	GUI_6				:= FA_CONV_1.Bit06;										(* Initialisierung *)
	muell				:= FA_CONV_1.Bit07;
	muell				:= FA_CONV_1.Bit08;
	muell				:= FA_CONV_1.Bit09;
	GU2_7				:= FA_CONV_1.Bit10;										(* Treibgas 1 *)
	GU13_0				:= FA_CONV_1.Bit11;										(* Treibgas 1 --> Mischgas *)
	GU1_0				:= FA_CONV_1.Bit12;										(* Schliessen Klappe/Ventil 2 *)
	GU1_1				:= FA_CONV_1.Bit13;										(* Gasart 1 / Gasart 1_2 *)
	GU1_2				:= FA_CONV_1.Bit14;										(* Gasart 2 *)
	GU1_3				:= FA_CONV_1.Bit15;										(* Gasart 4 *)
	GU1_4				:= FA_CONV_2.Bit00;										(* Gasart 3 *)
	GU31_0				:= FA_CONV_2.Bit01;										(* Öffnenen Klappe/Ventil 2 *)
	GU31_1				:= FA_CONV_2.Bit02;										(* Schliessen Klappe/Ventil 1 *)
	GU31_2				:= FA_CONV_2.Bit03;										(* Mischgas --> Treibgas 2 *)
	GU1_7				:= FA_CONV_2.Bit04;										(* Treibgas 2 *)
	GU23_0				:= FA_CONV_2.Bit05;										(* Treibgas 2 --> Mischgas *)
	GU2_0				:= FA_CONV_2.Bit06;										(* Schliessen Klappe/Ventil 2 *)
	GU2_1				:= FA_CONV_2.Bit07;										(* Gasart 3 *)
	GU2_2				:= FA_CONV_2.Bit08;										(* Gasart 4 *)
	GU2_3				:= FA_CONV_2.Bit09;										(* Gasart 2 *)
	GU2_4				:= FA_CONV_2.Bit10;										(* Gasart 1 / Gasart 1_2 *)
	GU32_0				:= FA_CONV_2.Bit11;										(* Öffnenen Klappe/Ventil 1 *)
	GU32_1				:= FA_CONV_2.Bit12;										(* Schliessen Klappe/Ventil 2 *)
	GU32_2				:= FA_CONV_2.Bit13;										(* Mischgas --> Treibgas 1 *)
	GU3_7				:= FA_CONV_2.Bit14;										(* Mischgas *)
	muell				:= FA_CONV_2.Bit15;
	
	
						(* Setzen der Steuerbefehle *)
	
	FG_GST				:=	GUI_7 AND(GU2_7 OR GU1_7 OR M_BTRB OR GU3_7 AND GAS1_3);(* Freigabe Gasstrecke (pb6!) *)
	
	FG_MISCH			:=	GU3_7;												(* Freigabe Gasmischregler (reg_in!)*)
	
	V_GVD				:=	GU23_0;												(* Vorhalte Gasverdichter *)
	
	ANW_GST2			:=	GU1_7 OR GU23_0 OR GU2_0;							(* Anwahl Gasstrecke 2 *)
	UW_GST2				:=	NOT(GU2_7 OR GU13_0 OR GU1_0);						(* Überwachung Gasstrecke 2 *)
	
	M_GASV1				:=	NOT ANW_GST2 AND(									(* Anwahl Gasventil 1 *)
							GU_TJ OR NOT KL1_ZU)AND(NOT
							GU_TJ OR NOT FA_M_GASV1.Q);
	M_GASV2				:=	UW_GST2 AND(										(* Anwahl Gasventil 2 *)
							GU_TJ OR NOT KL2_ZU)AND(NOT
							GU_TJ OR NOT FA_M_GASV2.Q);
	
	bCrossOver			:=	GASV1 AND GASV2 AND bTecJetOn;						(* Gasmischung aktiv für TecJet's *)
	
	M_AWGAS1			:=	(GU1_1 OR GU2_4 OR NOT M_GASV2)AND NOT GAS1_2;		(* Anwahl Gas1 *)
	M_AWGAS1_2			:=	(GU1_1 OR GU2_4 OR NOT M_GASV2)AND     GAS1_2;		(* Anwahl Interpolation *)
	M_AWGAS1_3			:=	(GU3_7 OR GU31_2 OR GU32_2)AND bCrossOver OR(		(* Anwahl Mischgas *)
							GU31_0 OR GU31_1 OR
							GU32_0 OR GU32_1)AND NOT bTecJetOn;

	M_AWGAS1			:=	M_AWGAS1 OR M_AWGAS1_2 OR M_AWGAS1_3;				(* Anwahl Gas1 *)
	M_AWGAS2			:=	(GU1_2 OR GU2_3);									(* Anwahl Gas2 *)
	M_AWGAS3			:=	(GU1_4 OR GU2_1 OR NOT M_GASV1);					(* Anwahl Gas3 *)
	M_AWGAS4			:=	(GU1_3 OR GU2_2);									(* Anwahl Gas4 *)
	
	IF	M_GASV AND (GU13_0 OR GU23_0) AND NOT bCrossOver AND bTecJetOn	THEN(* Entlasten für Öffnen anderen Gasstrecke *)
						FUGITIV				:=	1;								(* Anforderung Leistungsreduktion *)
	ELSE				FUGITIV				:=	0;
	END_IF;

	TOF_FUGITIV.IN := FUGITIV;
	TOF_FUGITIV.PT := MAX(TOF_FUGITIV.PT, ((MAX((1000 - (FA_M_GASV1.Gw - FA_M_GASV1.Hy)), ((FA_M_GASV2.Gw + FA_M_GASV2.Hy) - 0))/MAX(1, T_TJ))*100));
	TOF_FUGITIV();
	sel_PowerSetpointLimit := LIMIT(0, sel_PowerSetpointLimit, 3);
	bPowerSetpointLimit    :=((p_ist > ssPowerSetpointLimit) OR bPowerSetpointLimit) AND TOF_FUGITIV.Q AND (sel_PowerSetpointLimit > 0);

	TON_P_FUG.IN := ((p_ist <= ssPowerSetpointLimit) OR TON_P_FUG.IN) AND
					((p_ist - ssPowerSetpointLimit) < ssPowerSetpointLimit/50);
	TON_P_FUG();

	IF	TON_P_FUG.Q AND FUGITIV	THEN
						P_FUG				:=	1;								(* Reduktionsleistung erreicht *)
	ELSE				P_FUG				:=	0;
	END_IF;

	IF		GASSTR_1 OR GU32_2 OR GUI_0	THEN									(* Gasmischverhältnis für GAS1 *)
						X_SOLLW				:=	0;
	ELSIF	GASSTR_2 OR GU31_2	THEN											(* Gasmischverhältnis für GAS3 *)
						X_SOLLW				:=	1000;
	ELSE				X_SOLLW				:=	MUX(BOOL_TO_SINT(bSetMix_Man),	(* Gasmischverhältnis für Mischbetrieb *)		
												X_SOLLW, ssSetMix_Man);
	END_IF;
	
	IF	M_GASV AND (l_einst_a OR GU13_0 OR GU23_0)	THEN						(* Gasmischverhältnis fixieren! *)
						X_SOLLW				:=	X_SOLLW_OLD;
	ELSE				X_SOLLW_OLD			:=	X_SOLLW;
	END_IF;
	
	IF	NOT M_GASV OR (GU31_2 AND M_NANF AND NOT GCB_ON)	THEN				(* disable ramp fub *)
						RAMPE_X_SOLLW.enable := FALSE;
	ELSE				RAMPE_X_SOLLW.enable := TRUE;							(* enable ramp fub *)
						RAMPE_X_SOLLW.Rise	 := INT_TO_UINT(					(* pos. change of gas mixture 0,1%/sec *)
												LIMIT(0,T_TJ*BOOL_TO_INT(NOT l_einst_a),10));
						RAMPE_X_SOLLW.Sink	 := INT_TO_UINT(					(* neg. change of gas mixture 0,1%/sec *)
												LIMIT(0,T_TJ*BOOL_TO_INT(NOT l_einst_a),10));
	END_IF;
	RAMPE_X_SOLLW.TC_Time:= 100;												(* FUB is working in 100ms task		*)
	RAMPE_X_SOLLW.In	 := X_SOLLW;
	RAMPE_X_SOLLW();
	
	OUT_GT.rGT_MixSet	:= 	INT_TO_REAL(LIMIT(0, RAMPE_X_SOLLW.Out, 1000)) / 1000;	(* Sollwert für Gasmischverhältnis *)
//	ssSetMix			:=	LIMIT(0, RAMPE_X_SOLLW.Out, 1000);						(* Sollwert für Gasmischverhältnis *)		//Existing code

	
						(* Steuerbefehle für Klappen/Ventile *)
	
	KL1AUF_1			:=	GUI_0 AND NOT GU_TJ;								(* Initialisierung *)
	KL1ZU_1				:=	GUI_0 AND NOT GU_TJ AND NULL;						(* Initialisierung *)
	KL2AUF_1			:=	GUI_0 AND NOT GU_TJ;								(* Initialisierung *)
	KL2ZU_1				:=	GUI_0 AND NOT GU_TJ AND NULL;						(* Initialisierung *)
	
	KL1AUF_2			:=	(GU2_1 OR GU2_2 AND NOT KL1_AUF)					(* Treibgas 2 --> Treibgas 1 (getaktet) *)
							AND NOT l_einst_a;
	KL1ZU_2				:=	(GU1_3 AND KL2_AUF OR GU1_4)						(* Treibgas 1 --> Treibgas 2 (getaktet) *)
							AND NOT l_einst_a;
	KL2AUF_2			:=	(GU1_1 OR GU1_2 OR GU1_3 AND NOT KL2_AUF)			(* Treibgas 1 --> Treibgas 2 (getaktet) *)
							AND NOT l_einst_a;
	KL2ZU_2				:=	(GU2_2 AND KL1_AUF AND GAS1_2_HQ OR GU2_3 OR GU2_4)	(* Treibgas 2 --> Treibgas 1 (getaktet) *)
							AND NOT l_einst_a;
	
	KL1AUF_3			:=	GU32_0 AND NOT GU_TJ AND NOT l_einst_a;				(* Mischgas --> Treibgas 1 (getaktet) *)
	KL1ZU_3				:=	GU31_1 AND NOT GU_TJ AND NOT l_einst_a;				(* Mischgas --> Treibgas 2 (getaktet) *)
	KL2AUF_3			:=	GU31_0 AND NOT GU_TJ AND NOT l_einst_a;				(* Mischgas --> Treibgas 2 (getaktet) *)
	KL2ZU_3				:=	GU32_1 AND NOT GU_TJ AND NOT l_einst_a;				(* Mischgas --> Treibgas 1 (getaktet) *)
	
	KL1AUF_4			:=	KL1AUF_2 AND NOT M_GASV OR							(* Treibgas 2 --> Treibgas 1 (direkt) *)
							GU32_0 AND NOT M_GASV AND NOT GU_TJ;				(* Mischgas --> Treibgas 1 (direkt) *)
	
	KL1ZU_4				:=	KL1ZU_2 AND NOT M_GASV OR							(* Treibgas 1 --> Treibgas 2 (direkt) *)
							GU31_1 AND NOT M_GASV AND NOT GU_TJ OR				(* Mischgas --> Treibgas 2 (direkt) *)
							GU1_7 AND NOT KL1_ZU AND NOT GU_TJ OR				(* Treibgas 2 (direkt) *)
							GU23_0 AND M_GASV AND NOT GU_TJ OR					(* Treibgas 2 --> Mischgas (direkt) *)
							GU2_0;												(* Treibgas 2 --> Treibgas 1 (direkt) *)
	
	KL2AUF_4			:=	KL2AUF_2 AND NOT M_GASV OR							(* Treibgas 1 --> Treibgas 2 (direkt) *)
							GU31_0 AND NOT M_GASV AND NOT GU_TJ OR				(* Mischgas --> Treibgas 2 (direkt) *)
							GU2_7 AND NOT KL2_AUF AND NOT GU_TJ;				(* Treibgas 1 (direkt) *)
	
	KL2ZU_4				:=	GU13_0 AND M_GASV AND NOT GU_TJ OR					(* Treibgas 1 --> Mischgas (direkt) *)
							GU1_0;												(* Treibgas 1 --> Treibgas 2 (direkt) *)
	
	KL1AUF_5			:=	GU3_7 AND NOT l_einst_a;							(* Gasmischbetrieb (Schrittregler!) *)
	KL1ZU_5				:=	GU3_7 AND NOT l_einst_a AND KL2_AUF;				(* Gasmischbetrieb (Schrittregler!) *)
	KL2AUF_5			:=	GU3_7 AND NOT l_einst_a;							(* Gasmischbetrieb (Schrittregler!) *)
	KL2ZU_5				:=	GU3_7 AND NOT l_einst_a AND KL1_AUF;				(* Gasmischbetrieb (Schrittregler!) *)
	
	IF	GU2_7 OR GU1_7 OR (KL1_AUF AND KL2_AUF)	THEN	
						count				:=	0;
	END_IF;
	IF		(GU1_1 OR GU1_2)	THEN
						IF	count > (MIN(T_GAS1, T_GAS1_4) * 10)	THEN		(* Zeit Gasart 1 *)
											T_GAS1_OK			:=	1;
						END_IF;
						IF	count > (MAX(T_GAS1_4, T_GAS1) * 10)	THEN		(* Zeit Gasart 1 mit hoher Qualität *)
											T_GAS1_4_OK			:=	1;
						END_IF;
						count				:=	count + BOOL_TO_INT(KL2AUF_2);
	END_IF;
	IF	GU1_3 AND KL2_AUF 	THEN
						IF	count > (T_GAS4 * 10)	THEN						(* Zeit Gasart 4 (Treibgas 1 --> Treibgas 2) *)
											T_GAS4_OK			:=	1;
						END_IF;
						count				:=	count + BOOL_TO_INT(KL1ZU_2);
	END_IF;
	IF	GU2_1	THEN
						IF	count > (T_GAS3 * 10)	THEN						(* Zeit Gasart 3 *)
											T_GAS3_OK			:=	1;
						END_IF;
						count				:=	count + BOOL_TO_INT(KL1AUF_2);
	END_IF;
	IF	GU2_2 AND KL1_AUF OR GU2_3 OR GU2_4	THEN
						IF	count > (MIN(T_GAS4_1, T_GAS2) * 10)	THEN		(* Zeit Gasart 4 (Treibgas 2 --> Treibgas 1) *)
											T_GAS4_1_OK			:=	1;
						END_IF;
						IF	count > (MAX(T_GAS2, T_GAS4_1) * 10)	THEN		(* Zeit Gasart 2 *)
											T_GAS2_OK			:=	1;
						END_IF;
						count				:=	count + BOOL_TO_INT(KL2ZU_2);
	END_IF;
	IF	GU2_7 OR GU1_7	THEN
						T_GAS1_OK			:=	0;
						T_GAS1_4_OK			:=	0;
						T_GAS4_OK			:=	0;
						T_GAS3_OK			:=	0;
						T_GAS4_1_OK			:=	0;
						T_GAS2_OK			:=	0;
	END_IF;
	
	
						(* Taktgenerierung für Stellbefehle *)
	
	IMPULS				:=	T_IMPULS * 10;
	PAUSE				:=	T_PAUSE * 10;
	IF	count_st > (IMPULS + PAUSE)	THEN
						count_st			:=	0;
	END_IF;
	IF	count_st > 0	THEN
						STELL				:=	1;
	END_IF;
	IF	count_st > IMPULS	THEN
						STELL				:=	0;
	END_IF;
	count_st			:=	count_st + 1;
	
	
						(* Stellbefehle Klappen/Ventile *)
	
	KL1AUF				:=	(((KL1AUF_2 OR KL1AUF_3) AND STELL) OR (KL1AUF_5 AND GAS2_MIN) OR KL1AUF_4 OR KL1AUF_1) AND NOT KL1_AUF;
	KL1ZU				:=	(((KL1ZU_2  OR KL1ZU_3)  AND STELL) OR (KL1ZU_5  AND GAS2_PLU) OR KL1ZU_4  OR KL1ZU_1)  AND NOT KL1_ZU;
	KL2AUF				:=	(((KL2AUF_2 OR KL2AUF_3) AND STELL) OR (KL2AUF_5 AND GAS2_PLU) OR KL2AUF_4 OR KL2AUF_1) AND NOT KL2_AUF;
	KL2ZU				:=	(((KL2ZU_2  OR KL2ZU_3)  AND STELL) OR (KL2ZU_5  AND GAS2_MIN) OR KL2ZU_4  OR KL2ZU_1)  AND NOT KL2_ZU;
	
	
						(* Ventilstellwerte (mA-Vorgabe) *)
	
	IF	KL1AUF	THEN	count1				:=	count1 + 1;
	END_IF;
	IF	KL1ZU	THEN	count1				:=	count1 - 1;
	END_IF;
	IF	KL2AUF	THEN	count2				:=	count2 + 1;
	END_IF;
	IF	KL2ZU	THEN	count2				:=	count2 - 1;
	END_IF;
	count1				:=	LIMIT(0, count1, 1000);
	count2				:=	LIMIT(0, count2, 1000);
	SW_KL1				:=	count1;
	SW_KL2				:=	count2;
	
	
						(* Rückmeldungen Ventilendstellungen *)
	
	IF	NOT mit_RM	THEN
						RM_KL1				:=	SW_KL1;
						RM_KL2				:=	SW_KL2;
						IF	RM_KL1 < 1		THEN
											KL1_ZU				:=	1;
						ELSE				KL1_ZU				:=	0;
						END_IF;
						IF	RM_KL1 > 999	THEN
											KL1_AUF				:=	1;
						ELSE				KL1_AUF				:=	0;
						END_IF;
						IF	RM_KL2 < 1		THEN
											KL2_ZU				:=	1;
						ELSE				KL2_ZU				:=	0;
						END_IF;
						IF	RM_KL2 > 999	THEN
											KL2_AUF				:=	1;
						ELSE				KL2_AUF				:=	0;
						END_IF;
	END_IF;
	
	
						(* Gasverbräuche (gmv_ber) *)
	
	GAS1_VB	:=	BOOL_TO_INT(GASV1) * ( 
							BOOL_TO_INT(NOT GU_TJ)*(RM_KL1 + 1000-RM_KL2*BOOL_TO_INT(GASV2)) + 
							BOOL_TO_INT(GU_TJ)*(1000 - ssRatioMix));
	GAS2_VB	:=	BOOL_TO_INT(GASV2) * (
							BOOL_TO_INT(NOT GU_TJ)*(RM_KL2 + 1000-RM_KL1*BOOL_TO_INT(GASV1)) +
							BOOL_TO_INT(GU_TJ)*ssRatioMix);

					
	(* Leistungsreduktionen *)										
	(* Power reduction gas switching for opening second gastrain *)					
	IF (ssPowerSetpointLimit <= 0.0) OR (IN_GT.rP_Act_Norm_Filt = 0.0) OR (IN_GT.rP_Nom = 0.0) THEN			//new
		OUT_GT.rP_Red_GasSwitch := 0.0;			
	ELSE
		OUT_GT.rP_Red_GasSwitch := 1 - LIMIT(0.0, (Para.rP_GT_SetLim / (IN_GT.rP_Act_Norm_Filt * IN_GT.rP_Nom)), 0.5);
	END_IF;
	
	
(* Copy local output variables to global *)
	bGT_MixingEna 				:= bGasMixture;				(* Visu *)
	OUT_GT.bGT2_Select 			:= ANW_GST2;
	OUT_GT.bGT_Rel 				:= FG_GST;
	OUT_GT.bGT_RelMixing		:= FG_MISCH;
	OUT_GT.bGasMixingActive		:= bCrossOver;	
	OUT_GT.bGT_SelGas1			:= M_AWGAS1;				
	OUT_GT.bGT_SelGas2			:= M_AWGAS2;
	OUT_GT.bGT_SelGas3			:= M_AWGAS3;
	OUT_GT.bGT_SelGas4			:= M_AWGAS4;							
    OUT_GT.tGT_Flap1_Open.Do 	:= KL1AUF;			//will be no Out in future
	OUT_GT.tGT_Flap1_Close.Do	:= KL1ZU;			//will be no Out in future
	OUT_GT.tGT_Flap2_Open.Do	:= KL2AUF;			//will be no Out in future
	OUT_GT.tGT_Flap2_Close.Do	:= KL2ZU;			//will be no Out in future
	OUT_GT.bGT_TypSwhActive		:= GASUM;
		
END_PROGRAM