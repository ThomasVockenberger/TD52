(* pb7 

VER	Datum/Name	Änderung
V0.1	26.01.99/Pa	erstellt
V160	04.12.01/LH	Ansteuerung Entlastungsventil verzögert
V161	11.03.02/LH	vkgverd	Ausgang Entlastungsventil umgedreht
V170	12.03.02/LH	Vorkammergasdruckstörungen aufbereitet
V172	11.07.02/LH	überarbeitet
V173	13.11.02/LH	Einlesen des Analogeinganges in pb17 verlegt
V2071	02.02.05/LH	Bezeichnungen überarbeitet
V2071b	28.06.05/LH	Netzwerkkommentare korrigiert
V2071c	20.09.05/LH	Variable "Para.bPr_PCG_GC_Active" eingeführt (für Überwachung in pb10)
V2072	16.11.05/LH	Grenzwert Verdichter EIN: 2,80 bar --> 3,00 bar
 			        Grenzwert Verdichter AUS: 3,80 bar --> 3,70 bar
V190	30.08.04/LH	Grenzwerte einstellbar und auf Standardstörungen
V210	05.01.06/LH	angepasst für V210 
V2201	17.07.07/LH	Erweiterungen für wassergekühlten Verdichter 
 			        Abstellung bei Ölstand minimum
  	    23.07.07/LH	Verlängerung Nachkühlzeit Verdichter auf 30s (lt. Hersteller)
V3.99.0		21-09-2013	Ganguly/Denk 	generated for modular software 
V3.99.1		22.02.2013	Denk 			HM_GDMI1 changed to modul global variable 	
V3.99.2 	25.02.2013	Denk			Temp_gastrain_4_lines added 
V04.04.00	21.07.2016	Denk			Bugfix, Display on Visu
V04.05.00	31.07.2017  Denk			SWAT 920, changes after validation. Deflagration protection different function for type 6 and type 9
*)


PROGRAM _CYCLIC
	
	(* release pre chamber gas valves *)
	xGR_MAXR_DREHZ1(In := IN_GT.rN_EngAct , Gw := Para.rN_PCG_EngStart_LimHi , Hy := Para.rN_PCG_EngStart_HyHi);
	DREHZ1_hi := xGR_MAXR_DREHZ1.Q;
	
	(* Logic for gastrain with up to 4 lines *)
	Temp_gastrain_4_lines	:=	(NOT AKT_Gastrecke1_2 OR NOT HM_GDMI1_2) AND
								(NOT AKT_Gastrecke1_3 OR NOT HM_GDMI1_3) AND
								(NOT AKT_Gastrecke1_4 OR NOT HM_GDMI1_4); 	

	(* Gas valves on *)
	IF xEngType.Type6 THEN
		VKGV_TC3			:= IN_GT.bGV_Open_Opstate 
						   	AND ((IN_GT.iIdx_OMSS = 1) OR IN_GT.bEng_CDR OR IN_GT.bEng_Dem_Aut) 
						    AND (NOT M_DREHZ OR OUT_GT.bGV_On OR IN_GT.bEng_Start) 
							AND NOT OUT_GT.bDeflagrationPrct; 		
	ELSIF xEngType.Type9 THEN
		VKGV_TC3			:= IN_GT.bGV_Open_Opstate 
							AND ((IN_GT.iIdx_OMSS = 1) OR IN_GT.bEng_CDR OR IN_GT.bEng_Dem_Aut) 
							AND (NOT M_DREHZ OR OUT_GT.bGV_On OR IN_GT.bEng_Start) 
							AND ((NOT OUT_GT.bDeflagrationPrct AND NOT IN_GT.bPBC_Active) OR IN_GT.bPBC_Active)		(* SWAT Rel.3 *)
							AND DREHZ1_hi; 		
	END_IF;
	
	IF NOT xEngType.Type9 THEN
		OUT_GT.bGV_On          	:= IN_GT.bGV_Open_Opstate 
		                       	AND ((IN_GT.iIdx_OMSS = 1) OR IN_GT.bEng_CDR OR IN_GT.bEng_Dem_Aut) 					    
							   	AND (NOT M_DREHZ OR OUT_GT.bGV_On OR IN_GT.bEng_Start)            
							  	AND NOT OUT_GT.bDeflagrationPrct;			 
					
		GASV1_TC3			  	:=  IN_GT.bGV_Open_Opstate 
		                       	AND ((IN_GT.iIdx_OMSS = 1) OR IN_GT.bEng_CDR OR IN_GT.bEng_Dem_Aut) 						
								AND (NOT M_DREHZ OR OUT_GT.bGV_On OR IN_GT.bEng_Start)            
								AND NOT OUT_GT.bDeflagrationPrct 
								AND (M_GASV1 AND ((NOT HM_GDMI1 AND Temp_gastrain_4_lines) OR OUT_GT.tGV1_Open.Do));
		
		GASV2_TC3    			:= IN_GT.bGV_Open_Opstate 
		                       	AND ((IN_GT.iIdx_OMSS = 1) OR IN_GT.bEng_CDR OR IN_GT.bEng_Dem_Aut) 					   
							   	AND (NOT M_DREHZ OR OUT_GT.bGV_On OR IN_GT.bEng_Start)            
							   	AND NOT OUT_GT.bDeflagrationPrct 
							   	AND (M_GASV2 AND (NOT HM_GDMI2 OR OUT_GT.tGV2_Open.Do));
	END_IF;
						 
	IF xEngType.Type9 THEN		(* SWAT Rel.3 *)
		OUT_GT.bGV_On          	:= IN_GT.bGV_Open_Opstate 
								AND ((IN_GT.iIdx_OMSS = 1) OR IN_GT.bEng_CDR OR IN_GT.bEng_Dem_Aut) 					    
								AND (NOT M_DREHZ OR OUT_GT.bGV_On OR IN_GT.bEng_Start)            
								AND ((NOT OUT_GT.bDeflagrationPrct AND NOT IN_GT.bPBC_Active) OR IN_GT.bPBC_Active);			 
											
		GASV1_TC3			  	:=  IN_GT.bGV_Open_Opstate 
								AND ((IN_GT.iIdx_OMSS = 1) OR IN_GT.bEng_CDR OR IN_GT.bEng_Dem_Aut) 						
								AND (NOT M_DREHZ OR OUT_GT.bGV_On OR IN_GT.bEng_Start)            
								AND ((NOT OUT_GT.bDeflagrationPrct AND NOT IN_GT.bPBC_Active) OR IN_GT.bPBC_Active)
								AND (M_GASV1 AND ((NOT HM_GDMI1 AND Temp_gastrain_4_lines) OR OUT_GT.tGV1_Open.Do));
								
		GASV2_TC3    			:= IN_GT.bGV_Open_Opstate 
								AND ((IN_GT.iIdx_OMSS = 1) OR IN_GT.bEng_CDR OR IN_GT.bEng_Dem_Aut) 					   
								AND (NOT M_DREHZ OR OUT_GT.bGV_On OR IN_GT.bEng_Start)            
								AND ((NOT OUT_GT.bDeflagrationPrct AND NOT IN_GT.bPBC_Active) OR IN_GT.bPBC_Active)
								AND (M_GASV2 AND (NOT HM_GDMI2 OR OUT_GT.tGV2_Open.Do));
	END_IF;
	
	(* MEGA-Gas valve 1 *)				 
	xTP_MGASV1.IN := OUT_GT.tGV1_Open.Do;
	xTP_MGASV1.PT := T#2s;
	xTP_MGASV1();
	OUT_GT.tGV1Mega_Open.Do := xTP_MGASV1.Q;
	
	(* MEGA-Gas valve 2 *)				 				 
	xTP_MGASV2.IN := OUT_GT.tGV2_Open.Do;
	xTP_MGASV2.PT := T#2s;
	xTP_MGASV2();
	OUT_GT.tGV2Mega_Open.Do := xTP_MGASV2.Q;
	
	(* Reset manual presetting Mixed gas ratio *)
	IF 	(OUT_GT.bSelGasTypMix AND NOT IN_GT.tEng_Run.Do) THEN
		OUT_GT.bSelGasTypMix := FALSE; 
		OUT_GT.bSelGasTyp3   := IN_GT.tGT_TypSwitch.Di;
		OUT_GT.bSelGasTyp1   := NOT IN_GT.tGT_TypSwitch.Di AND NOT OUT_GT.bGT_Ipol12Active;
		OUT_GT.bSelGasTyp0   := NOT IN_GT.tGT_TypSwitch.Di AND     OUT_GT.bGT_Ipol12Active;	
	END_IF;	
	
	(* Selection Automatic Gas switching (VISU-button) *)
	CASE iIdx_SelGasTyp OF
		0: (* M_GAS1_2 = Gas type 0 *)
		   OUT_GT.bSelGasTyp0   := OUT_GT.bGT_Ipol12Active;
		   OUT_GT.bSelGasTyp1   := FALSE;
		   OUT_GT.bSelGasTyp2   := FALSE;
		   OUT_GT.bSelGasTyp3   := FALSE;
		   OUT_GT.bSelGasTyp4   := FALSE;	   
		   OUT_GT.bSelGasTypMix := FALSE;
		   OUT_GT.bSelGasTypAut := FALSE;
		
		1: (* M_GAS1  = Gas type 1 *)
		   OUT_GT.bSelGasTyp0   := FALSE;
		   OUT_GT.bSelGasTyp1   := TRUE;
		   OUT_GT.bSelGasTyp2   := FALSE;
		   OUT_GT.bSelGasTyp3   := FALSE;
		   OUT_GT.bSelGasTyp4   := FALSE;	   
		   OUT_GT.bSelGasTypMix := FALSE;
		   OUT_GT.bSelGasTypAut := FALSE;	  	
		
		2: (* M_GAS2 = Gas type 2 *)
		   OUT_GT.bSelGasTyp0   := FALSE;
		   OUT_GT.bSelGasTyp1   := FALSE;
		   OUT_GT.bSelGasTyp2   := TRUE;
		   OUT_GT.bSelGasTyp3   := FALSE;
		   OUT_GT.bSelGasTyp4   := FALSE;	   
		   OUT_GT.bSelGasTypMix := FALSE;
		   OUT_GT.bSelGasTypAut := FALSE;
		
		3: (* M_GAS3 = Gas type 3 *)
		   OUT_GT.bSelGasTyp0   := FALSE;
		   OUT_GT.bSelGasTyp1   := FALSE;
		   OUT_GT.bSelGasTyp2   := FALSE;
		   OUT_GT.bSelGasTyp3   := TRUE;
		   OUT_GT.bSelGasTyp4   := FALSE;	   
		   OUT_GT.bSelGasTypMix := FALSE;
		   OUT_GT.bSelGasTypAut := FALSE; 
		
		4: (* M_GAS4 = Gas type 4 *)
		   OUT_GT.bSelGasTyp0   := FALSE;
		   OUT_GT.bSelGasTyp1   := FALSE;
		   OUT_GT.bSelGasTyp2   := FALSE;
		   OUT_GT.bSelGasTyp3   := FALSE;
		   OUT_GT.bSelGasTyp4   := TRUE;	   
		   OUT_GT.bSelGasTypMix := FALSE;
		   OUT_GT.bSelGasTypAut := FALSE; 
		   
		5,6: (* M_GAS1_3 = Mixed gas 5 , M_GAS1_2_3 = Mixed gas 6 *)
		   OUT_GT.bSelGasTyp0   := FALSE;
		   OUT_GT.bSelGasTyp1   := FALSE;
		   OUT_GT.bSelGasTyp2   := FALSE;
		   OUT_GT.bSelGasTyp3   := FALSE;
		   OUT_GT.bSelGasTyp4   := FALSE;	   
		   // OUT_GT.bSelGasTypMix := ((M_GAS1_3 AND NOT GAS1_2) OR (M_GAS1_2_3 AND GAS1_2)) AND bGT_MixingEna;
		   OUT_GT.bSelGasTypMix := (((iIdx_SelGasTyp = 5) AND NOT OUT_GT.bGT_Ipol12Active) OR 
		   							((iIdx_SelGasTyp = 6) AND OUT_GT.bGT_Ipol12Active)) AND bGT_MixingEna;
		   OUT_GT.bSelGasTypAut := FALSE; 
		
		7: (* M_AUTGAS *)
		   OUT_GT.bSelGasTyp1   := FALSE;
		   OUT_GT.bSelGasTyp2   := FALSE;
		   OUT_GT.bSelGasTyp3   := FALSE;
		   OUT_GT.bSelGasTyp4   := FALSE;
		   OUT_GT.bSelGasTyp0   := FALSE;
		   OUT_GT.bSelGasTypMix := FALSE;			
		   OUT_GT.bSelGasTypAut := TRUE;
		 
		 ELSE 
		 	(* Default case when iIdx_SelGasTyp is not assigned a value *)
			(* Preset gas type after Power ON *)
			bZM := NOT OUT_GT.bSelGasTypAut AND NOT OUT_GT.bSelGasTyp1 AND NOT OUT_GT.bSelGasTyp2 AND
			       NOT OUT_GT.bSelGasTyp3   AND NOT OUT_GT.bSelGasTyp4 AND NOT OUT_GT.bSelGasTyp0 AND 
				   NOT OUT_GT.bSelGasTypMix;
			
			IF bZM THEN
				OUT_GT.bSelGasTyp1   := NOT OUT_GT.bGT_TypSwhActive AND NOT OUT_GT.bGT_TypSwhActiveHalt;			  
				OUT_GT.bSelGasTypAut := (OUT_GT.bGT_TypSwhActive OR OUT_GT.bGT_TypSwhActiveHalt);			  		
			END_IF;	    
				
			(* Resetting manual preselection mixed gas relation *)
			(* IF 	(OUT_GT.bSelGasTypMix AND NOT IN_GT.tEng_Run.Do) THEN
				OUT_GT.bSelGasTypMix := FALSE; 
				OUT_GT.bSelGasTyp3   := IN_GT.tGT_TypSwitch.Di;
				OUT_GT.bSelGasTyp1   := NOT IN_GT.tGT_TypSwitch.Di AND NOT OUT_GT.bGT_Ipol12Active;
				OUT_GT.bSelGasTyp0   := NOT IN_GT.tGT_TypSwitch.Di AND     OUT_GT.bGT_Ipol12Active;	
			END_IF;	*)			
				
	END_CASE
	
	(* Selection Gas type 0 *)
	// xR_TRIG_FA_AUTGAS.CLK := M_GAS1_2 AND GAS1_2;
	// xRS_GAS1_2_MAN.SET    := xR_TRIG_FA_AUTGAS.Q;
	
	(* Selection Mixed gas *)
	// xR_TRIG_FA_AUTGAS.CLK := (((M_GAS1_3 AND NOT GAS1_2) OR (M_GAS1_2_3 AND GAS1_2)) AND bGasMixture;
	// xRS_GAS1_3_MAN.SET    := xR_TRIG_FA_AUTGAS.Q;
	
	// (* Presetting Gas type after Voltage high *)
	// ZM := NOT OUT_GT.bSelGasTypAut AND NOT OUT_GT.bSelGasTyp1 AND NOT OUT_GT.bSelGasTyp2 AND
	//	  NOT OUT_GT.bSelGasTyp3   AND NOT OUT_GT.bSelGasTyp4 AND NOT OUT_GT.bSelGasTyp0 AND
	//	  NOT OUT_GT.bSelGasTypMix;
		  
	// OUT_GT.bSelGasTyp1   := ZM AND (NOT OUT_GT.bGT_TypSwhActive AND NOT OUT_GT.bGT_TypSwhActiveHalt);
	// OUT_GT.bSelGasTypAut := ZM AND (OUT_GT.bGT_TypSwhActive OR OUT_GT.bGT_TypSwhActiveHalt);    
			
	(* Percentagage GAS2 for Gas quality of GAS1_2 (Task "spec_gas") *)
	xLCRPT1_FA_SPEC_GAS.enable 	:= TRUE;					
	xLCRPT1_FA_SPEC_GAS.x     	:= X_GMISCH_2;			
	xLCRPT1_FA_SPEC_GAS.t		:= 25.5;
	xLCRPT1_FA_SPEC_GAS();
		
	xRAMPE_FA_GMISCH_2.enable  := IN_GT.tSys_Run.Do;
	xRAMPE_FA_GMISCH_2.In      := rGT_QualMix_Man_Set; 		
	xRAMPE_FA_GMISCH_2.Rise    := 10.0;
	xRAMPE_FA_GMISCH_2.Sink    := 10.0;
	xRAMPE_FA_GMISCH_2.TC_Time := 100;
	xRAMPE_FA_GMISCH_2();

	IF bGT_QualMix_Man_Set THEN
		OUT_GT.rGT_QualMix_1_2 := xRAMPE_FA_GMISCH_2.Out;
	ELSE
	 	OUT_GT.rGT_QualMix_1_2 := xLCRPT1_FA_SPEC_GAS.y;
	END_IF;
		
	(* Set point for Gas mix relation *)							
	IF (OUT_GT.iIdx_Gtyp_Dem = 3) THEN
		rGT_MixSet_local := 1.0;
	ELSE
		rGT_MixSet_local := 0.0;
	END_IF;
	
	IF NOT bGT_MixingEna THEN
		OUT_GT.rGT_MixSet := rGT_MixSet_local;
	ELSE
		OUT_GT.rGT_MixSet := OUT_GT.rGT_MixSet;
	END_IF;

END_PROGRAM
