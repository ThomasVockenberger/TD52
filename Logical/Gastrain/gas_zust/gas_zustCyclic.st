(* BERECHNUNG GAS-ZUSTANDSZAHL
....................._
VER	Datum/Name	Änderung
V172	27.06.02/LH	erstellt
 	    17.09.02/LH	korrigiert für AS 2.2
V190	18.06.04/LH	Vermeidung von Rundungsfehlern 
V2201	08.08.07/LH	Pakistan-Standard: Normaltemp. = 15°C
 			        Anbindung an "spec_gas"-Werte 
V3.99	21-09-2013	Ganguly/Denk, generated for modular software*)


PROGRAM _CYCLIC
	
    (* Filtering turbo boost pressure *)
	xLCRPT1_PressP2.x := IN_GT.rPr_Ch_P2s_Avg_UF;
	xLCRPT1_PressP2();
	pl_ist := xLCRPT1_PressP2.y;

	(* Determining the normal temperature for conversion *)
	IF (Para.iCountry = iPakistan) THEN
		Tn_ls := 288.15;
	ELSE
		Tn_ls := Tn;   // Tn = 273.15 K is stored as a constant
	END_IF;

	(* Operating temperature 0.01°K => Temperature in Kelvin = Temperature in Celsius + (273.15 OR 288.15) *)
	(* Calculating  the temperature relation *)
	VT := Tn_ls/(IN_GT.tT_GT.Ai + Tn);

	(*-----------------------------------------------------------*)
	(* Detecting the air pressure *)
	IF NOT IN_GT.bEng_Aux_Dem_CDR THEN
	    (* Air pressure *)
		p_luft := pl_ist;
	ELSE
	    (* Actual boost pressure *)
		p_luft := p_luft;  
	END_IF;
			
	(* Assigning Gas pressure depending on whether absolute gas pressure measurement is active or not *)
	IF NOT Para.bPr_GasPrAbsActive THEN
		GAS_PB := p_luft + IN_GT.tPr_GT_Gas.Ai ;
	ELSE
		GAS_PB := 0.0 + IN_GT.tPr_GT_Gas.Ai ;
	END_IF;
	
	(* Calculation of the pressure relation *)
	Vp := GAS_PB/pn;

	(*-----------------------------------------------------------*)
	(* Berechnung Zustandzahl (ZSZ(x1000)=(Vt*Vp)/1000°K) *)
	(* Calculation Gas volume correction factor K = adjustment factor = ( 1/gas law deviation factor) *)
	ZSZ := VT * Vp * K;

END_PROGRAM
