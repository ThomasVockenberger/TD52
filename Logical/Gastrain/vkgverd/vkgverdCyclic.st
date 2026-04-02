(* Vorkammergasverdichter

.....................___
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
V03.99.00.00	21.09.2013	Ganguly	generated for modular software 
V04.00.01.00 	17.05.14	Denk	NOT MM2VIS.bMsg3315;
V04.01.01.00 	07.10.14	Denk	Adicom Pre-chamber gas compressor logic added
*)	

PROGRAM _CYCLIC
	
	IF Para.bPr_PCG_GC_Active THEN
	
		(* Set point pressure pre-chamber gas compressor minimum *)
		xGR_MINR_FA_AN_VKMIN.In := IN_GT.tPr_PCG.Ai;
		xGR_MINR_FA_AN_VKMIN.Gw := Para.rPr_PCG_GC_LimMin;
		xGR_MINR_FA_AN_VKMIN.Hy := Para.rPr_PCG_GC_HyMin;
		xGR_MINR_FA_AN_VKMIN();
		AN_VKMIN := xGR_MINR_FA_AN_VKMIN.Q AND IN_GT.tPB2MM.bParaSetupOk;
			
		(* Set point pre-chamber gas compressor ON *)
		xGR_MINR_FA_AN_VKEIN.In := IN_GT.tPr_PCG.Ai;
		xGR_MINR_FA_AN_VKEIN.Gw := Para.rPr_PCG_GC_LimOff;
		xGR_MINR_FA_AN_VKEIN.Hy := 0.1;						//#4 old code: 1000 --> 10.00 bar, #6 FA_AN_VKEIN.Hy old code 10 --> 0.1 bar
		xGR_MINR_FA_AN_VKEIN();
		AN_VKEIN := xGR_MINR_FA_AN_VKEIN.Q AND IN_GT.tPB2MM.bParaSetupOk;
		
		(* Set point pre chamber gas compressor - OFF *)
		xGR_MAXR_FA_AN_VKAUS.In := IN_GT.tPr_PCG.Ai;
		xGR_MAXR_FA_AN_VKAUS.Gw := Para.rPr_PCG_GC_LimOn;
		xGR_MAXR_FA_AN_VKAUS.Hy := 0.1;
		xGR_MAXR_FA_AN_VKAUS();
		AN_VKAUS := xGR_MAXR_FA_AN_VKAUS.Q AND IN_GT.tPB2MM.bParaSetupOk;
		
		(* Set point Pressure pre chamber gas compressor maximum *)
		xGR_MAXR_FA_AN_VKMAX.In := IN_GT.tPr_PCG.Ai;
		xGR_MAXR_FA_AN_VKMAX.Gw := Para.rPr_PCG_GC_LimMax;
		xGR_MAXR_FA_AN_VKMAX.Hy := Para.rPr_PCG_GC_HyMax;
		xGR_MAXR_FA_AN_VKMAX();
		AN_VKMAX := xGR_MAXR_FA_AN_VKMAX.Q AND IN_GT.tPB2MM.bParaSetupOk;
		
	ELSE    
		AN_VKMIN := FALSE;
		AN_VKMAX := FALSE;
		AN_VKEIN := FALSE;
		AN_VKAUS := FALSE;	
	END_IF;
	
	(* Release monitoring pressure prechamber gas compressor *)
	xTON_FA_UW_VKGD.IN := OUT_GT.tPr_PCG_GC_Dem.Do ;
	xTON_FA_UW_VKGD.PT := T#1m;
	xTON_FA_UW_VKGD();
	UW_VKGD := xTON_FA_UW_VKGD.Q;
	
	(* Pressure Pre-chamber gas compressor minimum *)
	VKGD_MIN :=  (UW_VKGD OR IN_GT.tEng_Run.Do) AND AN_VKMIN AND IN_GT.tPr_PCG.GoodQual;
	
	(* Pressure Pre-chamber gas compressor maximum *) 
	VKGD_MAX := AN_VKMAX;
	
	(* Stop gas compressor because of: *)
	(* - Emergency-OFF, Gas alarm, Gas pre-alarm, Fire alarm, .... *)
	STOER := NOT IN_GT.bMsg1054 AND NOT IN_GT.bMsg1052 AND NOT IN_GT.bMsg1053 AND NOT IN_GT.bMsg1031;
	(* - Pre-chamber gas pressure minimum, pressure pre chamber gas compressor maximum, measure signal failure
	pre-chamber gas compressor pressure *)
	STOER := STOER AND NOT MM2VIS.bMsg1095 AND NOT MM2VIS.bMsg3309 AND NOT MM2VIS.bMsg3308;
	(* - Oil level minimum pre chamber gas compressor *)
	STOER := STOER AND NOT MM2VIS.bMsg3315;
	
	(* Pre-chamber gas compressor *)
	IF Para.bPr_PCG_GC_Active THEN			(* demand pre chamber gas compressor - control and monitoring by GEJ *)	
		OUT_GT.tPr_PCG_GC_Dem.Do := STOER 
								    AND (AN_VKEIN OR (NOT AN_VKAUS AND OUT_GT.tPr_PCG_GC_Dem.Do)) 
									AND (IN_GT.bEng_Dem OR M_DREHZ);
	ELSE									(* demand pre chamber gas compressor -  compressor package*)
		OUT_GT.tPr_PCG_GC_Dem.Do := STOER 						
									AND (IN_GT.bEng_Dem OR M_DREHZ);
	END_IF;

	(* Switch-ON unloading valve *)
	xTOF_FA_ENTLV.IN := NOT OUT_GT.tPr_PCG_GC_Dem.Do ;
	xTOF_FA_ENTLV.PT := T#0.5s;
	xTOF_FA_ENTLV();
	ENTLV := xTOF_FA_ENTLV.Q;
	
	xTON_FA_ENTL_V.IN := ENTLV;
	xTON_FA_ENTL_V.PT := T#0.5s;
	xTON_FA_ENTL_V();
	OUT_GT.tPCG_DemReliefValve.Do := NOT xTON_FA_ENTL_V.Q;
	
	(* Auxilliary compressor *)
	xTOF_FA_HBT_VERD.IN := OUT_GT.tPr_PCG_GC_Dem.Do ;
	xTOF_FA_HBT_VERD.PT := T#30s;
	xTOF_FA_HBT_VERD();
	
	OUT_GT.tPCG_DemValCW.Do   := xTOF_FA_HBT_VERD.Q;
	OUT_GT.tPCG_DemCoolFan.Do := xTOF_FA_HBT_VERD.Q;

END_PROGRAM
