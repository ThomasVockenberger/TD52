(* BERECHNUNG GASMISCHVERHÄLTNIS

.....................___
VER	Datum/Name	Änderung
V170	21.03.02/LH	erstellt
V172	17.09.02/LH	korrigiert für AS 2.2
V173	16.10.02/LH	Filter eingebaut (Robitschko)
V183	14.10.03/LH	angepasst für Gasumschaltung neu
V190	18.06.04/LH	Vermeidung von Rundungsfehlern 
V3.99	21-09-2013	Ganguly/Denk, generated for modular software
*)

PROGRAM _CYCLIC
	
	(* Gas mixing relation *)
	IF GU_TJ THEN		
		xLCRPT1_FA_GMISCH.x     := OUT_GT.rGT_RatioMix;
		xLCRPT1_FA_GMISCH.t		:= 0.2;	
		xLCRPT1_FA_GMISCH();
		OUT_GT.rGasMixingRatio 	:= xLCRPT1_FA_GMISCH.y;	
	END_IF;	

END_PROGRAM
