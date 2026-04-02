(* GASUMSCHALTUNG IM STILLSTAND

VER	Datum/Name	Änderung
V170	04.04.02/LH	erstellt
V2071	15.02.05/LH	angepasst für Gasstrecke 2 = Gasart 3
 		03.03.05/LH	neue Variable "OUT_GT.bGT_TypSwhActiveHalt" eingeführt
V220	19.02.07/LH	angepasst für X20-Einführung
V2.60.0	06.10.2009  Lettenb		task activation added
V03.99.00.00	21.09.2013	Denk		generated for modular software
				28.05.2013	lettenb.	bTestEnabled Para -> loc.var
V04.01.00.00	31.07.2014  Denk		Para.bGT_MixActiveEngStop added

Instructions for use:
------------------------------
activate task if used
set connections acc. comment *)


PROGRAM _CYCLIC

(* task activation *)
IF NOT Para.bGT_MixActiveEngStop THEN   	
	RETURN; 								
END_IF;

	(* Anzahl der Gasstrecken > 1 *)
	(* Number of Gas trains > 1 *)
	OUT_GT.bGT_TypSwhActiveHalt := TRUE;
	
	(* Anzahl der Gasarten > 2 *)
	(* Number of Gas type > 2 *)
	ZM  := Para.iIdx_Gastyp > 2;
	
	(* Rückschaltung *)
	(* ????? code revision *)
	ST6 := (OUT_GT.bSelGasTypAut OR NOT OUT_GT.bSelGasTyp3) AND (NOT IN_GT.tGT_TypSwitch.Di OR NOT OUT_GT.bSelGasTypAut) AND AF_GASUM;
	
	IF bTestEnabled THEN xTON_FA_T6.PT:= T#5s;
	ELSE				 xTON_FA_T6.PT:= T#5m;
	END_IF;		
	xTON_FA_T6(IN:= ST6);
	AT6 := ST6 AND (NOT OUT_GT.bGV_On OR xTON_FA_T6.Q);
	
	(* Anforderung Gasumschaltung *)
	(* Demand Gas switch *)
	AF_GASUM := ((OUT_GT.bSelGasTypAut AND (IN_GT.tGT_TypSwitch.Di OR AF_GASUM)) OR OUT_GT.bSelGasTyp3) AND NOT AT6 AND ZM;
	
	(* Anwahl Gasstrecke 2 *)
	(* Select Gas train 2 *)
	OUT_GT.bGT2_Select := (AF_GASUM AND NOT IN_GT.bEng_Dem_Bloc) OR (OUT_GT.bGT2_Select AND 
	                      (IN_GT.bEng_Dem_Bloc OR AF_GASUM));
	
	(* Anforderung Entlastung fur Gasumschaltung *)
	(* Demand unloading for Gas train switch *)
	OUT_GT.bGT_DemRelGasTypSwh := (NOT OUT_GT.bGT2_Select AND AF_GASUM) OR (OUT_GT.bGT2_Select AND NOT AF_GASUM);
	
	(* Gasventile *)
	(* Gas valves *)
	M_GASV1 := NOT OUT_GT.bGT2_Select;
	M_GASV2 := OUT_GT.bGT2_Select;

END_PROGRAM
