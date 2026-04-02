(*******************************************************************************
c_mns		 customizable mains demand controller  (derived from anf_nb 	customized engine demand depending of griddemand power setpoints)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2025

Customized modifications: -
------------------------
 
History:
-------
V4.04.1 14.11.2016 Zengerer			New task according to new spec. from Schwab Christoph, TPE (based on task anf_nb V4.03.0, 05.07.2013 pankayrodney)	
V4.04.2 23.05.2017 Zengerer			Connect IN Interfaces to Hal tP_Mns_AnaIn, tDem_Ctr_Mns
V4.05.0 05.09.2017 zengerer			Nachziehen der Netzbezugsregler Änderungen von Schwab Christoph / Caks Michael aus File Bugs&Solution_MnsCtrl.zip
V4.05.1 30.11.2017 zengerer			50 + removed according to Basisupdate 4.4.0.6
V4.05.2 12.03.2018 zengerer			comments updated
V4.05.3 18.04.2018 Schwab Christoph bMsg2302_Enable-- bMsg2418_Enable Version
V4.05.4 20.04.2018 Zengerer			Timer Reset Button FUNCTION INVERTED; SOME UNTESTED CHANGES FROM V4.5.3 REVERTED
		25.04.2018 Zengerer			MM2VIS.rPmns_DemGenerate_Lim_On rPmns_DemGenerate_Lim_Off
V4.07.1 13.05.2019 Zengerer		 	Change of y_Min Y_Max strategy per option selection, ShadowPara_tCtr_Mns to prevent para writing; +activation Para
V4.11.0	24.02.2022 Perktold			impemented plant controller upgrade
V4.14.0	13.03.2025 Zengerer 		moved mains import controller activation bit


		
Instructions for use:
--------------------
 TASK REPLACES the task anf_nb. Do not activate anf_nb any more.


Outstandings:
------------
ADOPT ACCORDING TO PLANT SPECIFIC NEEDS 
	
	-Testing for IN_CU.tP_Act[2].Ai has to be done
	-remove SparePara[73] V4.07 option here after testing phase
*******************************************************************************)
PROGRAM _CYCLIC
	
	(* IN INTERFACE: new V4.4.0,  2016 *)
	IN_CU.tDem_Ctr_Mns.Di	;				(*activation bit input (default value in case of not using interface moved to c_modIF) *)
	bDem_Ctr_Mns := IN_CU.tDem_Ctr_Mns.Di;  (*connect DI mns controller activation interface to hardware *)
	IN_CU.tP_Mns_AnaIn.Ai  ; 				(*AnaIn		Mains power Actual value over mA Signal *)
	IN_CU.tP_Mns_AnaIn.GoodQual ;			(*AnaIn		Mains power Actual value over mA Signal *)
	IN_CU.tP_Act[2].Ai;						(* P [kW] 	Mains power Actual value over MMU	*)

	IN_CU.rP_Nom;							(*Nominal power at selected gas type *)
	
	VIS2MM.tCtr_Mns_In;
//	VIS2MM.rPmns_setpoint ;					(* = p_MainsImport Setpoint *)
	IN_CU.tCtr_Mns_Anain_Setp_W_ext.Ai;		 (*AnaIn	Setpoint over mA Signal *)	//replaces:  = 	OUT_CU.rCustAnaIn[1] /100.0 ;	
	IN_CU.tCtr_Mns_Anain_Setp_W_ext.GoodQual;(*AnaIn	Setpoint over mA Signal *)	//replaces:  = 	OUT_CU.rCustAnaIn[1] /100.0 ;	
	
	Para.bCtr_Mns_Enable;				(*Parameter)	general activation bit for mns controller *)
	
	Para.tCtr_Mns.W_set;				(*Parameter	W(setpoint) start  Var.1:	internal setpoint *)
	Para.tCtr_Mns.W_min;				(*Parameter	W(setpoint) minimum *)
	Para.tCtr_Mns.W_max;				(*Parameter	W(setpoint) maximum *)
	Para.bCtr_Mns_AnaIn_Setp_Enable;	(*Parameter 	setpoint over mA aktiv Var.2: analog in setpoint *)
	Para.bCtr_Mns_Setp_Set4mA;			(*Parameter 	scaling 4-20 mA aktiv *)
	Para.rCtr_Mns_Setp_ScalMin;			(*Parameter 	scale minimum *)
	Para.rCtr_Mns_Setp_ScalMax;			(*Parameter 	scale maximum *)
	
	Para.bP_Mns_MMU_Enable;				(*Parameter 	TRUE = use MMU2 measurement reading, FALSE = use Analog Input reading from customer messurement euipment *)
	Para.bP_Mns_AnaIn_Enable := NOT Para.bP_Mns_MMU_Enable;		(*INTERNAL GENERATED HERE, necessary because bP_Mns_AnaIn_Enable is not a parameter on VIS anymore*)

	Para.bP_Mns_AnaIn_Set4mA;			(*Parameter 	value scaling 4-20 mA aktiv *)
	Para.rP_Mns_AnaIn_ScalMin;			(*Parameter 	scale minimum *)
	Para.rP_Mns_AnaIn_ScalMax;			(*Parameter 	scale maximum *)
	
	Para.bLimOnOff_aktiv;				(*Parameter)	TRUE = use mns-ctr output to perform engine demand on/off *)
	Para.rMainsImport_max;				(*Parameter)	Mains Import maximum warning limit	*)
	Para.rMainsImport_max_trip;			(*Parameter)	Mains Import maximum alarm limit *)
	Para.rMainsExport_max;				(*Parameter)	Mains Export maximum warning limit	*)
	Para.rMainsExport_max_trip;			(*Parameter)	Mains Export maximum alarm limit *)
	
	Para.rDemGenerate_Lim_On;			(*Parameter)	Grenzwert Einschaltung (% von PN Generator) *)
	Para.rTime_Dem_On_delay;			(*Parameter)	Delay time until engine demand on [sec] *)
	Para.rDemGenerate_Lim_Off;			(*Parameter)	Grenzwert Abschaltung (% von PN Generator) *)
	Para.rTime_Dem_Off_delay;			(*Parameter)	Delay time until engine demand off [sec]*)
	Para.tCtr_Mns.W_set;				(*Parameter)	W(setpoint) start *)

	(* OUT INTERFACE *)
	OUT_CU.bEngDSS_Mains  ;								(* == ANF_NB *)
	OUT_CU.rP_MainsImport ;				(* rP_MainsImport Interface to MM syncronising: +=grid to plant power value in [KW] *)
	OUT_CU.rP_Set_Mns_Norm;				(* engine power setpoint from grid controller out   *)

	MM2VIS.bEngDSS_Mains ;	// := OUT_CU.bEngDSS_Mains;	(* == ANF_NB *)
	MM2VIS.rPcsm_act ;					(* Consumer Power = p_MainsImport + rP_Act_Norm_Filt *)
	MM2VIS.rPmns_act ;		//:= OUT_CU.rP_MainsImport ;					(* p_MainsImport t (= OUT_CU.rP_MainsImpor) *)
	MM2VIS.rPmns_setpoint ;				(* selected p_MainsImport Setpoint, with ramps... *)
	MM2VIS.tCtr_Mns_Out;				(*Controler output structure for VIS*)
	MM2VIS.tCtr_Mns_Out.Active;			(*Controler output active*)
	MM2VIS.tCtr_Mns_Out.Y;				(* engine power etpoint from grid controller out   *)

	OUT_CU.tCtr_Mns_Out ;				(*Controler output structure *)
	OUT_CU.tCtr_Mns_In;					(*Copy of controler input structure for reuse in other modules *)
	
	
	
	(****************************************************************************************************)
	(*Calculation of power values*)
	//Mains Power set point import controller
	IF 	(*Para.bP_Mns_AnaIn_Enable*)Para.bCtr_Mns_AnaIn_Setp_Enable  AND IN_CU.tCtr_Mns_Anain_Setp_W_ext.GoodQual THEN // Schwab Ch. Falscher Parameter Angebunden	(*Parameter setpoint over mA aktiv Var.2:	Der Sollwert wird mittels externen mA Signal, welches über Parameter angepasst werden kann*)
		rP_Mains_Set := IN_CU.tCtr_Mns_Anain_Setp_W_ext.Ai;		(*AnaIn		Setpoint over mA Signal *)

	ELSE  
	//	rP_Mains_Set := MM2VIS.tCtr_Mns_Out.W;			NEIN, GEHT hier SO NICHT mehr!	(* rP_GenerateSet		alt: 	soll_netz := REG1.w;*)  
		rP_Mains_Set := Para.tCtr_Mns.W_set;  		(* rP_GenerateSet from Vis manual input	*)  
	END_IF
	
	//Verbraucherleistung (= Netzbezugsleistung + Generatorleistung)
	rP_Consumption := rP_MainsImport + (IN_CU.rP_Act_Norm_Filt * IN_CU.rP_Nom);			(* verbrauch == rP_Consumption					alt: verbrauch := netzbezug + );*)

	(*Schwab Ch. => rP_DemGenerate wird immer berechnet! Keine IF Funktion benötigt*)
	rP_DemGenerate := rP_Consumption - rP_Mains_Set;
	MM2VIS.rPmns_DemGenerate := rP_DemGenerate;		(*new V4.5 beta *)

	(* P_MainsImport: measured absolute power from mains to plant in [KW] (+=grid to plant power, -=plant to grid*)	 //=Netzbezugsleistung
	IF 	Para.bP_Mns_MMU_Enable THEN 							(*Parameter TRUE = ISTwert Netzbezug über MMU gemessen (Var.2), 	FALSE = über mA Signal (Var.1)*) 
		//FEHLT NOCH: NB- Leistung von eigenem MMU
		rP_MainsImport := 	IN_CU.tP_Act[2].Ai;					(* P [kW] Mains power Actual value over MMU	  := 98765.4321;		//FEHLT NOCH:  test  *)
		
	ELSIF  IN_CU.tP_Mns_AnaIn.GoodQual THEN 				(*AnaIn	Actual value mA Signal Quality Check*)
		rP_MainsImport := 	IN_CU.tP_Mns_AnaIn.Ai;		(*AnaIn	Istwert = über mA Signal (Var.1):	Der Istwert wird mittels mA Signal geliefert, welches über Parameter angepasst werden kann	 	alt: netzbezug := REAL_TO_INT(OUT_CU.rCustAnaIn[1]);	*)
	ELSE
		rP_MainsImport :=	(-rP_MainsImport_max) ;				(* failsafe value = no engine demand *)
	END_IF
	
	IF 	Para.bCtr_Mns_Enable AND bDem_Ctr_Mns THEN 	 (* TASK ACTIVATION by (Parameter)	Regler Aktivierung *)	 
		
		(* P_MainsImport_max limit parameter*)	//maximal erlaubte Netzbezugsleistung
	//	rP_MainsImport_max := DINT_TO_REAL(Para.rCust_SparePara[1]);		(*:= SPS_REZP1;				alt:netzbezug_max := INT_TO_UDINT(Para.rCust_SparePara[1]); *)
		rP_MainsImport_max :=  			Para.rMainsImport_max;				(*Parameter)	Mains Import maximum	alt:netzbezug_max := INT_TO_UDINT(Para.rCust_SparePara[1]); *) 
						// old:			Para.rMainsImport_max_trip;			(*Parameter)	Mains Import maximum Abstellend True/False *)
		
		//Grenzwert [0-1 NOM Pnenn (früher %Pnenn!)] Anforderung EIN
		rP_DemGenerate_Lim_On :=		Para.rDemGenerate_Lim_On;			(*Parameter)	Grenzwert Einschaltung (% von PN Generator)  alt: p_ein_proz := INT_TO_UDINT( SPS_REZP1); *)

		//Grenzwert [0-1 NOM Pnenn (früher %Pnenn!)] Anforderung AUS
		rP_DemGenerate_Lim_Off :=		Para.rDemGenerate_Lim_Off;			(*Parameter)	Grenzwert Abschaltung (% von PN Generator) 	alt: p_aus_proz := INT_TO_UDINT( SPS_REZP2);*) 	
		
		//Nennleistung bei aktiver Gasart
		rP_Nom := (IN_CU.rP_Nom);					(*Nennleistung bei aktiver Gasart)  alt: zm := REAL_TO_INT(IN_CU.P_Nom);*)
		
		//Freigabe Netzbezugsregler
		//bDem_Ctr_Mns :=  ?  := bRSS_Rem AND IN_CU.bMCB_On AND IN_CU.GCB_ON AND IN_CU.AN_PGW1;		(*kann bRSS_Rem ersetzt werden durch bRSS_Rem? - nein *)
		OUT_CU.bEngDSS_Mains_Rel := IN_CU.bOMSS_Aut
								AND bRSS_Rem		
								AND	IN_CU.bMCB_On 
								AND Para.bCtr_Mns_Enable
								//	IN_CU.bGCB_On AND  NICHT einbinden, Regler kann sonst den motor nicht mehr starten!
								AND bDem_Ctr_Mns 	(*DI Customer Demand Input*)
								AND	(IN_CU.tP_Mns_AnaIn.GoodQual OR IN_CU.tP_Act[2].GoodQual);		(*lt. Schwab, 2017-11-28*)

		(*OUT_CU.bEngDSS_Mains_Block aktuell nicht in Verwendung => Wird über A2302 abgedeckt /  Schwab Ch.*)
		//		//Notabschaltung durch Überschreitung der erlaubten Rückspeiseleistung ins Netz (pb7/M_BLOCK)
//		xTOF_FA_BLOCK_NB.IN := (-rP_MainsImport) > rP_MainsImport_max;				(*shut down engine, if power to grid (=-MainsImport) exceeds allowed limt *)
//		xTOF_FA_BLOCK_NB.PT := REAL_TO_TIME(Para.rTime_Dem_Off_delay) * 1000;			(*Parameter)	[SEC] Zeitwert Verzögerung Abforderung alt: T#1m; *)
//		xTOF_FA_BLOCK_NB();
//		
//		OUT_CU.bEngDSS_Mains_Block := xTOF_FA_BLOCK_NB.Q;
				
		//geforderte Generatorleistung (= Verbraucherleistung - Netzbezugsollwert)
//		IF bDem_Ctr_Mns THEN 
//			rP_DemGenerate := MM2VIS.tCtr_Mns_Out.Y * rP_Nom; //Funktion doppelt? ->sonst TESTEN!
//		ELSE
//			rP_DemGenerate := rP_Consumption - rP_Mains_Set;					(*	soll_gen ==  rP_DemGenerate		alt: soll_gen := verbrauch - soll_netz; *)
//		END_IF
		
		//Berechnung Anforderungsleistung
//		zm1 := rP_DemGenerate_Lim_On * rP_Nom;				//Schwab remove: 50 + rP_DemGenerate_Lim_On * rP_Nom
////	zm1 := zm1/100;
//		p_ein := (zm1);												(*UDINT_TO_INT(zm1);*)
		p_ein := rP_DemGenerate_Lim_On * rP_Nom;			//Schwab remove: 50 + rP_DemGenerate_Lim_On * rP_Nom
		MM2VIS.rPmns_DemGenerate_Lim_On := p_ein;		(*new V4.5 beta *)
		
		//Berechnung Abwahlleistung
//		zm0 := rP_DemGenerate_Lim_Off * rP_Nom;				//Schwab remove: 50 + rP_DemGenerate_Lim_Off * rP_Nom
////	zm0 := zm0/100;
//		p_aus := (zm0);												(*UDINT_TO_INT(zm0);*)
		p_aus := rP_DemGenerate_Lim_Off * rP_Nom;			//Schwab remove: 50 + rP_DemGenerate_Lim_Off * rP_Nom
		MM2VIS.rPmns_DemGenerate_Lim_Off := p_aus;		(*new V4. beta5 *)
		
		//Anforderung EIN
		IF AUS AND NOT bDisplayTimerHelper THEN 
			TON_R_MnsDemandOn.PT := REAL_TO_UDINT(Para.rTime_Dem_On_delay) * 100; 
		END_IF
		TON_R_MnsDemandOn(IN := (rP_DemGenerate >= p_ein));				(*caution, RS will NOT WORK here as intended! *)
	//	TON_R_MnsDemandOn(IN := (rP_DemGenerate >= p_ein), PT := 	(Para.tiTime_Dem_On_delay) * 1000, RS := VIS2MM.bTime_Dem_On_delay_Reset);
		IF VIS2MM.bTime_Dem_On_delay_Reset	THEN		(*IF VIS Timer Reset Button is pressed*)
			VIS2MM.bTime_Dem_On_delay_Reset := FALSE;	(*clear button*)
			TON_R_MnsDemandOn( PT := 0 );				(*runout timer*)
			TON_R_MnsDemandOff( PT := 0 );				(*runout timer*)
			bDisplayTimerHelper := TRUE;				(*Visu helper bit for TON_R_MnsDemandOn display*)
		END_IF
		IF (IN_CU.rN_EngAct > 450) AND (IN_CU.rN_EngAct < 750) THEN 	bDisplayTimerHelper := FALSE; END_IF			(*Reset Visu helper bit for TON_R_MnsDemandOn display*)

		EIN := TON_R_MnsDemandOn.Q;
		MM2VIS.rTime_Dem_On_CntDn := UDINT_TO_REAL(TON_R_MnsDemandOn.PT - TON_R_MnsDemandOn.ET) /100 ;		(* Display start count down *)
	//	MM2VIS.tiTime_Dem_On_CntDn := 			  (TON_R_MnsDemandOn.PT - TON_R_MnsDemandOn.ET) /1000 ;		(* Display start count down *)
				
		//Anforderung AUS
		IF EIN AND NOT bDisplayTimerHelper THEN 
			TON_R_MnsDemandOff.PT := REAL_TO_UDINT(Para.rTime_Dem_Off_delay) * 100; 	(*Parameter)	Delay time until engine demand off [sec]*)
			MM2VIS.rTime_Dem_On_CntDn := UDINT_TO_REAL(TON_R_MnsDemandOff.PT - TON_R_MnsDemandOff.ET) /100 ;		(* Display start count down *)
		END_IF
		TON_R_MnsDemandOff(IN := (rP_DemGenerate <= p_aus));		(* PREPARED for AUS := soll_gen <= p_aus;*)
		AUS := 	TON_R_MnsDemandOff.Q;
	//	AUS := rP_DemGenerate <= p_aus;								(* := soll_gen <= p_aus;*)

		//Anforderung
		OUT_CU.bEngDSS_Mains := (EIN OR OUT_CU.bEngDSS_Mains)
							AND NOT AUS			(* OUT_CU.bEngDSS_Mains == ANF_NB *)
							AND Para.bLimOnOff_aktiv;
		
		(*Connection failure bit for message set*)
		(* A2302 mains export power limit: Shut down engine, if NEGATIVE Mains Import (= power export to the grid) is exceeding (<) the allowed limit (-Limit value)  *)
		bMsg2302_Enable	:=	Para.bCtr_Mns_Enable 
//						AND Para.bLimOnOff_aktiv 				// gehört nicht zu dieser Funktion / Schwab Ch.
						AND ((*IN_CU.tDem_Ctr_Mns.Di*)bDem_Ctr_Mns OR Para.iCtr_Mns_Options.2);
	
		bMsg2302_Set	:=	OUT_CU.rP_MainsImport < (-Para.rMainsExport_max_trip);
	
		(* A2303 mains import controller limit 2  ??? Why shut down the engine, if too few power is available  ???	*)
		bMsg2303_Enable	:=	Para.bCtr_Mns_Enable
//						AND Para.bLimOnOff_aktiv 				// gehört nicht zu dieser Funktion / Schwab Ch.						AND Para.bLimOnOff_aktiv 
						AND (*IN_CU.tDem_Ctr_Mns.Di*)bDem_Ctr_Mns 
						AND ((*IN_CU.tDem_Ctr_Mns.Di*)bDem_Ctr_Mns OR Para.iCtr_Mns_Options.3) 			(*Change 2018 Ze: Alarm only active in Ctr_Mns mode (using option bit 3 and 4 of INTERNAL parameter, ->NORMALY SWITCHED TO FALSE*)
						AND Para.iCtr_Mns_Options.4
						AND FALSE;	// Funktion muss nochmals mit betroffene Personen diskutiert werden / Schwab Ch.
	
		bMsg2303_Set	:= OUT_CU.rP_MainsImport > Para.rMainsImport_max_trip;

		(* W2415 mains import controller: Messsignalstörung Netzbezugs- Sollwert 	*)
		bMsg2415_Enable	:=	Para.bCtr_Mns_Enable 
						AND Para.bCtr_Mns_AnaIn_Setp_Enable
						AND (IN_CU.tDem_Ctr_Mns.Di OR Para.iCtr_Mns_Options.5);	(*Change 2018 Ze: Alarm only active in Ctr_Mns mode (using option bit 5 and 4 of INTERNAL parameter, ->NORMALY SWITCHED TO FALSE*)
	
		bMsg2415_Set	:= NOT IN_CU.tCtr_Mns_Anain_Setp_W_ext.GoodQual;

		(* W2416 mains import controller: Messsignalstörung Netzbezugs- Istwert	*)	
		bMsg2416_Enable	:=	Para.bCtr_Mns_Enable 
						AND	bDem_Ctr_Mns
						AND Para.bP_Mns_AnaIn_Enable 
						AND Para.bP_Mns_AnaIn_Set4mA
						AND ((*IN_CU.tDem_Ctr_Mns.Di*)bDem_Ctr_Mns OR (NOT Para.iCtr_Mns_Options.6));
		
		bMsg2416_Set	:= NOT IN_CU.tP_Mns_AnaIn.GoodQual;

		(* W2417 mains export power limit: Warning, if NEGATIVE Mains Import (= power export to the grid) is exceeding (<) the allowed limit (-Limit value)  *)	
		bMsg2417_Enable	:=	Para.bCtr_Mns_Enable  					//AND Para.bLimOnOff_aktiv;	
						AND bDem_Ctr_Mns				
						AND ((*IN_CU.tDem_Ctr_Mns.Di*)bDem_Ctr_Mns OR (NOT Para.iCtr_Mns_Options.7));	

		bMsg2417_Set	:= OUT_CU.rP_MainsImport < (-Para.rMainsExport_max) ;

		(* W2418  mains import controller limit 2:  Warning if positive Mains Import (= power drawn from the grid) is exceeding (>) the allowed limit (+Limit value)*)	
		bMsg2418_Enable	:=	Para.bCtr_Mns_Enable 					//AND Para.bLimOnOff_aktiv AND FALSE;
						AND bDem_Ctr_Mns
						AND ((*IN_CU.tDem_Ctr_Mns.Di*) bDem_Ctr_Mns OR Para.iCtr_Mns_Options.8);	

		bMsg2418_Set	:= OUT_CU.rP_MainsImport > Para.rMainsImport_max;

	ELSE
		//Task disabeled, keine Anforderung 
		bMsg2302_Enable		 		:= FALSE;
		bMsg2302_Set		 		:= FALSE;
		bMsg2303_Enable		 		:= FALSE;
		bMsg2303_Set		 		:= FALSE;
		bMsg2415_Enable		 		:= FALSE;
		bMsg2415_Set		 		:= FALSE;
		bMsg2416_Enable		 		:= FALSE;
		bMsg2416_Set		 		:= FALSE;
		bMsg2417_Enable		 		:= FALSE;
		bMsg2417_Set		 		:= FALSE;
		bMsg2418_Enable		 		:= FALSE;
		bMsg2418_Set		 		:= FALSE;	
		OUT_CU.bEngDSS_Mains 		:= FALSE;
		OUT_CU.bEngDSS_Mains_Rel	:= FALSE;
		
	END_IF
	
	(******************************************************************************)
	(* MAINS POWER IMPORT/EXPORT CONTROLLER [kW] (System 1 from Lettenbichler- Plant Control) *)
//	IF 	Para.bCtr_Mns_Enable  THEN 	 (* ACTIVATION by (Parameter)  V4.07:  integratet in .enable *)
		(* PlantOperMode = 1 *)
		VIS2MM.tCtr_Mns_In.enable   	:= 	OUT_CU.bEngDSS_Mains_Rel AND Para.bCtr_Mns_Enable ; //bDem_Ctr_Mns ;		(*(Schnittstelle)	Aktivierung über Kundenschnittstelle *)
		VIS2MM.tCtr_Mns_In.W_ext    	:=  rP_Mains_Set;  				(*	Setpoint over mA Signal  FEHLT NOCH: .w_ref    := MAX (IN_MC.ENG_nom[1].Pgen, Pgen_dmnd_nom);(* reference value, units like "x" *) 
		VIS2MM.tCtr_Mns_In.W_ext_Active := 	Para.bCtr_Mns_AnaIn_Setp_Enable ;		(* setpoint activation,  old: Para.Pmns_sp;  *)

		VIS2MM.tCtr_Mns_In.W_set2_Active	:= FALSE;	(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
		VIS2MM.tCtr_Mns_In.GainScheduling	:= 0.0;		(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
		VIS2MM.tCtr_Mns_In.Y_min_cust;					(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
		VIS2MM.tCtr_Mns_In.Y_max_cust;					(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
		VIS2MM.tCtr_Mns_In.Retrigger;					(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
		VIS2MM.tCtr_Mns_In.A;							(*feed forward Input*)


		VIS2MM.tCtr_Mns_In.X			:= rP_MainsImport;				(* actual value, "PV Name" of "x" *)

		//	VIS2MM.tCtr_Mns_In.mode     	:= 1;   	     		     	(* 1: dy=Ki*(w-x/w_ref), 0: dy=Ki *)

		Para.tCtr_Mns.deadband	;  // 	:= 10.0;				(* dead band, units like "x" *)
		IF Para.tCtr_Mns.Tn = 0 THEN Para.tCtr_Mns.Tn := 110; END_IF // VIS2MM.tCtr_Mns_In.Ki_plus  := Speed_P_Ad/10;	(* units "In"/100ms=task class *)
									 Para.tCtr_Mns.Tn  ; 			 // VIS2MM.tCtr_Mns_In.Ki_minus := Speed_P_Ad/10;	(* units "In"/100ms=task class *)
		IF Para.tCtr_Mns.dY_max = 0 THEN Para.tCtr_Mns.dY_max := 0.1;	END_IF			(*  *)
		Para.tCtr_Mns.Y_block  	;	//:= 1.0;				(* % *)
	
		Para.tCtr_Mns.invert   ; 		//  := TRUE;			 	(* FALSE: x>w: decrease y, TRUE: x>w: increase y *)

		(*Beginn V4.07 change *)
		ShadowPara_tCtr_Mns			:= Para.tCtr_Mns;	(* controler internal derouting of para *)

		rY_min	:= LIMIT( (IN_CU.rP_Act_Norm_Filt - 0.03), (IN_CU.rP_Set_Min_Norm -0.03), 1.0);
		rY_max	:= LIMIT( (IN_CU.rP_Act_Norm_Filt + 0.03),  IN_CU.rP_Set_Min_Norm       , 1.0);
		bOptParaChangeAllowed := Para.rCust_SparePara[73] > 0;		(*V4.07 Bugfix disabeling, to allow temporary switch back to V4.05 behavior  *)
		IF bOptParaChangeAllowed  AND Para.bCtr_Mns_Enable THEN		(*V4.07 Change of y_Min Y_Max strategy per option selection, to prevent para writing *)
			Para.tCtr_Mns.Y_min	:= 	rY_min;		(* change, this is not allways possible! Caution, watch this LIMIT(Mn, IN, MX) para order to used functions priority handling of MN *)
			Para.tCtr_Mns.Y_max	:= 	rY_max;
		END_IF
//			VIS2MM.tCtr_Mns_In.Y_set := LIMIT(0.5,( LIMIT(rY_min, OUT_CU.tCtr_Mns_Out.Y, rY_max) ), 1.0);				(*test: Y limit without para change*)
//			VIS2MM.tCtr_Mns_In.Y_set_Active := (rY_min > OUT_CU.tCtr_Mns_Out.Y) OR (rY_max < OUT_CU.tCtr_Mns_Out.Y); 	(*test: Y limit without para change*)
			IF NOT VIS2MM.tCtr_Mns_In.enable THEN 			(* IF stopped controller THEN move internal y limit following actual set power (ELSE use Para. values) *)
				ShadowPara_tCtr_Mns.Y_min	:= rY_min; //:=	LIMIT(0.5, rY_min, 1);	(* controler internal derouting of para *)
				ShadowPara_tCtr_Mns.Y_max	:= rY_max; //:=	LIMIT(0.5, rY_max, 1);	(* controler internal derouting of para *)
			END_IF
		
		(*End V4.07 change *)
		
		
		OUT_CU.tCtr_Mns_In	:=	VIS2MM.tCtr_Mns_In;
		OUT_CU.tCtr_Mns_Out	:=	MM2VIS.tCtr_Mns_Out;
	
	
			xGeACtr_Mns;		(*Controller- FUNCTION CALL*)	  
	
			
	//	rP_DemGenerate 			:= MM2VIS.tCtr_Mns_Out.Y;	 	//Funktion doppelt? ->sonst TESTEN! (* "PV Name" of "y", % *)
		OUT_CU.rP_MainsImport :=	rP_MainsImport;					(*Interface to MM syncronising: +=grid to plant power value in [KW], -=plant to grid power*)
		OUT_CU.rP_Set_Mns_Norm	:= MM2VIS.tCtr_Mns_Out.Y;
		MM2VIS.rP_DemGenerate := rP_DemGenerate;
		MM2VIS.bEngDSS_Mains := OUT_CU.bEngDSS_Mains;	(* == ANF_NB *)
		MM2VIS.rPcsm_act := rP_Consumption;				(* Consumer Power = p_MainsImport + rP_Act_Norm_Filt *)
		MM2VIS.rPmns_act := OUT_CU.rP_MainsImport ;		(* p_MainsImport t (= OUT_CU.rP_MainsImpor) *)
		MM2VIS.rPmns_setpoint := rP_Mains_Set;			(*Actual main import power set point*)
		
//	END_IF
	
	
	
	
	//<outdated variants removed>

			
END_PROGRAM

