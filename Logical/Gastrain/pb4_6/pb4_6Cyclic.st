(* pb4_6	BR6: auxiliaries control 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V01		06.07.98/Pa	erstellt
 		24.11.98/Pa	korrekturlesung
V06		24.03.00/Pa	FRG Kühlwasserdrucküberwachung
 		28.03.00/Pa	wieder raus damit
V11		04.07.00/Pa	Eigener Baustein für BR6
V160	30.11.01/LH	Ansteuerung Motorkühlwasserpumpe und Vorwärmpumpe geändert!
V170	03.04.02/LH	Aktivierung Öldrucküberwachung in pb10 verlegt
V172	19.09.02/LH	Kontaktplanfehler behoben
V181	06.06.03/LH	Ansteuerung Vorwärmheizung richtiggestellt
 				    Minimumlaufzeit 5 min für Turboladernachschmierung
 					(NOT-AUS nicht mehr aktiv)
 					Nachkühlzeit 20 min --> 40 min
V182	02.10.03/LH	Nachkühlzeit 40 min --> 20 min (Entwicklung!)
 					Nachkühlung auch bei Leistungsdifferenz maximum 
 					und Ölstand minimum wenn Level wieder überschritten
V207	23.09.04/LH	Variante Turbolader mit Wasserkühlung
V2071	07.02.05/LH	Verzögerung Freigabe Ölnachfüllventil
 					Umschaltung Spannung für Hilfsbetriebe
 		02.02.05/LH	Analogwert Vorkammerdifferenzdruck eingeführt
V2071b	28.06.05/LH	TW_ZUEND_PUFF ... 500ms --> 200ms
V210	18.04.05/LH	Deaktivierung Verpuffungsschutz nur bei XT
V220	19.02.07/LH	angepasst für X20-Einführung 
 		10.05.07/LH	Abschaltmöglichkeit Vorwärmheizung bei überwachter Vorwärmpumpe 
V230	15.01.08/LH	Einstellung ATL_H2O --> settings
 		19.03.08/TM	NW8 bBlockOel_Bh hinzu
 		31.03.08/TM	NW8 variable name changed to bBlockOil_Bh
V2.50.0	28.01.2009  lettenb.	calm: TW_T117 removed, different time for BRx
                    T85 logic changed, VSP_24 logic changed
        23.02.2009	FA_T85 removed
V3.20.0	15.09.2010 /MM (BuR)	PRELUBE_IgnST included
	.	07.12.2010 lettenb.	ton_T117: PRELUBE_IgnST added
	.	30.09.2010 /MM (BuR)	gen_sch replaced with GCB_ON_TC1
	.	01.10.2010 /MM (BuR)	net_sch replaced with MCB_ON
	.	21.10.2010 lettenb.	624TSTC: NKUEHL_OIL_H2O added
	.	08.11.2010 ZM_OMAX moved to alarms10xx, DI_AuxV_Eng_ok, DI_FS_ECW added
	.	09.03.2011 QUITT_AB substituted by reset_alarm[1094] for alarm bypass

V3.99.00	21.09.2013	Ganguly/Denk	generated for modular software
V3.99.01	28.02.2013	Denk			inserted task "dp_PClim" with version V3.30.0 from 14.09.2011	
			23.04.2013	lettenb.		mp_a[0].w and mp_a[1].w interfaces added	
										difference pressure pre chamber - limit calculation
			31.01.2014					rLDR_PDIF_P2: calc. P2 for all selectable gas types,bugfix/V350
V4.03.00	23.06.2015	Graus			type 6 island mode controller AND load rejection
			29.10.2015  Denk			Function changed for 624 on "pre chamber gas differential pressure maximum"
V4.04.00	04.08.2016	Denk			Bugfix, Filterung charge pressure
V4.05.00	10.07.2017	Denk			SWAT 920, if sensor failure Pr_PC, then take Pr_PCGT_Out as input for xGR_MAXR_VKDR_MX								
			31.07.2017  Denk			SWAT 920, changes after validation. Deflagration protection different function for type 6 and type 9
			01.02.2018	Denk			Bugfix, IN_GT.rPumpQuotient datatyp changed from USINT --> REAL 
V4.07.00	02.04.2018	Denk			Type6 without prechamber, OUT_GT.bDeflagrationPrct := FALSE;
			30.04.2018	Denk	 		SWAT Rel.5, A1085 delay time for type 9 changed to 3s
V4.14.00	09.07.2024	Schmidt			T6L version during load acceptance: reduce limit difference pressure prechamber minimum
			25.11.2024	Abe				Added pre chamber gas bypas valve monitoring function to detect stuck bypass valves

Instructions for use:
--------------------
vorschmierung
TL benötigen generell keine vorschmierung, 
d.h. die schmierung erfolgt mit der mechanischen ölpumpe bei motoranlauf 

nachkühlung
ölgekühlter TL:	nachkühlung TL mit vorschmierpumpe [VSP_400, VSP_24)
.		nachkühlung = gleichzeitig nachschmierung

wassergekühlter TL:nachkühlung TL mit kühlwasserumwälzpume(=vorwärmpumpe) [A_VORW)
.		und motorkühlwasserpumpe
.		keine nachschmierung!!!

Berechnung vorkammerdifferenzdruck :
vorkammerdifferenzdruck = vorkammergasdruck - ladedruck

funktion verpuffungsschutz:
mit detektion vorkammerdifferenzdruck max. erfolgt zuendung AUS / motor AUS.
nach abstellung ist motor wieder bereit.
werden durchvorkammerdifferenzdruck max. 3 abstellungen innerhalb einer stunde 
verursacht, erfolgt alarm A1094 verpuffungsschutz, PRIO 3

               Vorkammerdiff.druck 
               ^                          
               |
 GW_PDIF_MX_P1 |-----+--------------------+---- max. GW_PDIF_MX_P2
               |     *
 GW_PDIF_MN_P1 |-----+                    * Soll_Diff.druck                    
               |                +
               |                          +---- min. GW_PDIF_MN_P2
               |                          
               |
               +-----+--------------------+------> ladedruck 
                     P1                   P2
                     0 mbar(a)         	  interpolierter wert mp_a[0].P von leanox (gasart1-4)
                                          bei volllast (P1)  

für ladedruck < P1: GW_PDIF_MX = GW_PDIF_MX_P1 = konst.
                    GW_PDIF_MN = GW_PDIF_MN_P1 = konst.
für ladedruck > P2: GW_PDIF_MX = GW_PDIF_MX_P2 = konst.
                    GW_PDIF_MN = GW_PDIF_MN_P2 = konst.
					
actual calculated limits are visible in the parameter manager!					


Outstandings:
------------
xGR_MAXR_PDIFF_MX: substitute values with calc.limits

*******************************************************************************)

PROGRAM _CYCLIC

	
IF xEngType.Type6 OR xEngType.Type9 THEN
	
	IF Para.bPr_PC_Active THEN
		(* SP pre chamber pressure maximum *)
		IF xEngType.Type6 THEN
			xGR_MAXR_VKDR_MX(In:= IN_GT.tPr_PC.Ai, Gw:= Para.rPr_PC_LimHi, Hy:= Para.rPr_PC_HyHi);
		END_IF;
		IF xEngType.Type9 THEN
			IF IN_GT.tPr_PC.GoodQual THEN	(* SWAT Rel.3 *)	
				rPr_PC := IN_GT.tPr_PC.Ai;
	 		ELSE 
				rPr_PC := IN_GT.tPr_PCGT_Out.Ai + IN_GT.rPr_Baro_Internal;
			END_IF;
			xGR_MAXR_VKDR_MX(In:= rPr_PC, Gw:= Para.rPr_PC_LimHi, Hy:= Para.rPr_PC_HyHi);
		END_IF;
		IF xEngType.Type9 THEN	(* SWAT Rel.5 *)
			tiVKDR_MX:= T#3s;
		END_IF;
		IF xEngType.Type6 THEN
			tiVKDR_MX:= T#200ms;
		END_IF;	
		xTON_VKDR_MX(IN:= xGR_MAXR_VKDR_MX.Q AND IN_GT.tPB2MM.bParaSetupOk, PT:= tiVKDR_MX);
		AN_VKDR_MX := xTON_VKDR_MX.Q;
		
		(* T6L version during load acceptance: reduce limit difference pressure prechamber minimum at BoostPressure point P1 *)
		IF (IN_GT.rP_Act_Norm - IN_GT.rP_Act_Norm_Filt) > rP_DiffPC_LimLo_Switch THEN
			xTP_DiffPC_LimLo_Switch.IN := TRUE;
		ELSE
			xTP_DiffPC_LimLo_Switch.IN := FALSE;
		END_IF;
		xTP_DiffPC_LimLo_Switch();
		
		IF IN_GT.bType6L_GEN1_Island THEN
			IF xTP_DiffPC_LimLo_Switch.Q THEN
				rPr_DiffPC_LimLo_Offset := -0.3;
			ELSE
				rPr_DiffPC_LimLo_Offset := 0.0;
			END_IF;
		ELSE
			rPr_DiffPC_LimLo_Offset := 0.0;
		END_IF;
		
		(* difference pressure pre chamber - limit calculation *)
		(* input variables *)
		Para.rPr_DiffPC_LimHi_P1; 		(*Para: Limit difference pressure prechamber maximum at BoostPressure point P1 [bar]*) 
		Para.rPr_DiffPC_LimHi_P2;		(*Para: Limit difference pressure prechamber maximum at BoostPressure point P2 [bar]*)
		Para.rPr_DiffPC_LimLo_P1;		(*Para: Limit difference pressure prechamber minimum at BoostPressure point P1 [bar]*)
		Para.rPr_DiffPC_LimLo_P2;		(*Para: Limit difference pressure prechamber minimum at BoostPressure point P2 [bar]*)
	
		rLDR_PDIF_P1	:=	0.0;		(* [bar] *)
		rLDR_PDIF_P2 :=	INT_TO_REAL(IN_GT.mp_a[OUT_GT.iIdx_Gtyp_Dem].w)/1000;  (* [mbar] ladedruck von leanox (gasart 0-4) bei volllast(leanox-P1)*)


		(* charge pressure depending limit calculation *)
		xSigScal_0(X:= xFILTER_R_P2s_200ms.Out, X1:= rLDR_PDIF_P1, Y1:= Para.rPr_DiffPC_LimHi_P1, X2:= rLDR_PDIF_P2, Y2:= Para.rPr_DiffPC_LimHi_P2);
		rGW_PDIF_MX := xSigScal_0.Y_SCAL;	(* [bar] limit high *)
	
		xSigScal_1(X:= xFILTER_R_P2s_200ms.Out, X1:= rLDR_PDIF_P1, Y1:= (Para.rPr_DiffPC_LimLo_P1 + rPr_DiffPC_LimLo_Offset), X2:= rLDR_PDIF_P2, Y2:= Para.rPr_DiffPC_LimLo_P2);
		rGW_PDIF_MN := xSigScal_1.Y_SCAL;	(* [bar] limit low *)


		(* Calculation pre chamber differential pressure (= Difference of pre chamber gas pressure and charge pressure *)
		ANA_PDIFF := IN_GT.tPr_PC.Ai - xFILTER_R_P2s_200ms.Out;
		   
		(* SP pre chamber gas differential pressure minimum *)
		xGR_MINR_PDIFF_MN(In:= ANA_PDIFF, Hy:= Para.rPr_DiffPC_HyLo, Gw:= rGW_PDIF_MN);
		xTON_FDIFF_MN(IN:= IN_GT.tPB2MM.bParaSetupOk AND xGR_MINR_PDIFF_MN.Q, PT:= T#200ms);
		AN_PDIFF_MN := xTON_FDIFF_MN.Q;
		
		IN_GT.rPumpQuotient	:= 0.0; (*Bis auf weiteres deaktiviert - Perktold 11-10-2018*)
		(* SP pre chamber gas differential pressure maximum *)
		xGR_MAXR_PDIFF_MX(In:= ANA_PDIFF, Hy := Para.rPr_DiffPC_HyHi, Gw:= rGW_PDIF_MX (*0.3*));
		xTP_Pump_Active2(IN:= EDGEPOS(IN_GT.rPumpQuotient < -0.4) AND xTP_Pump_Active.Q, PT:= T#1s);
		xTP_Pump_Active(IN:= IN_GT.rPumpQuotient < -0.4 AND Para.iEng_Motortype = 624, PT:= T#1s);
        	
		(* Start of Pre chamber gas bypass valve monitoring function *)
		(* Charge pressure dependent calculation for maximum differential pre chamber gas pressure with bypass valve *) 
		xSigScal_PCG_BPV(X:= xFILTER_R_P2s_200ms.Out, X1:= rLDR_PDIF_P1, Y1:= Para.rPr_DiffPC_LimHi_P1 + rOffset_PCG_BPV_P1, X2:= rLDR_PDIF_P2, Y2:= Para.rPr_DiffPC_LimHi_P2 + rOffset_PCG_BPV_P2);
		rThr_PDIF_PCG_BPV_MX := xSigScal_PCG_BPV.Y_SCAL; (* Upper allowed limit for pre chamber diff pressure in Island mode *)
		(* Use TON to check if pressure is exceeded for > 10s *)
		xTON_PCG_BPV_MX(IN := ANA_PDIFF > rThr_PDIF_PCG_BPV_MX, PT := tPT_PCG_BPV);
		
		(* BPV active and type 6 and GCB closed and PCG train open and power above minimum threshold *)
		IF Para.bPCG_BPV_Active AND xEngType.Type6 AND IN_GT.tGCB_On_TC2.Di AND OUT_GT.tPCG_GV_Open.Do AND IN_GT.rP_Act_Norm > rThr_PCG_BPV_P_MN THEN
			(* Trigger message if pressure has been exceeded for sufficiently long *)
			bMsg9509_Set := xTON_PCG_BPV_MX.Q;
		ELSE
			bMsg9509_Set := FALSE;
		END_IF		
		(* End of Pre chamber gas bypass valve monitoring function *)
		
		IF xTP_Pump_Active.Q OR xTP_Pump_Active2.Q     THEN  xTON_FDIFF_MX.PT     := T#1000ms;
		ELSE  xTON_FDIFF_MX.PT    := T#200ms; END_IF

		xTON_FDIFF_MX(IN:= IN_GT.tPB2MM.bParaSetupOk AND xGR_MAXR_PDIFF_MX.Q);
		P_DIFF := NOT xTON_FDIFF_MX.Q;
	
	ELSIF NOT Para.bPr_PC_Active THEN

		AN_VKDR_MX  := FALSE;
		AN_PDIFF_MN := FALSE;
		
		xTP_DiffPC_LimLo_Switch();
	
	END_IF;
	
	(* Verpuffungsschutz *)
	(* Deflagration protection *)
	W_P_DIFF := NOT IN_GT.tMCB_On.Di AND IN_GT.tGCB_On_TC2.Di AND TRUE;

	xTON_FA_Z_PUFF.IN := NOT P_DIFF AND NOT W_P_DIFF;	//Zweig classic: in pb4_6 #46
	xTON_FA_Z_PUFF.PT := T#200ms;
	xTON_FA_Z_PUFF();
	Z_PUFF := xTON_FA_Z_PUFF.Q;
		
	xTOF_FA_T_FGPUFF.IN := AN_FGPUFF;
	xTOF_FA_T_FGPUFF.PT := T#4s;
	xTOF_FA_T_FGPUFF();	
	T_FGPUFF := xTOF_FA_T_FGPUFF.Q;
		
	xTOF_bLR_GasStop(IN := IN_GT.bLR_GasStop, PT := T#10s);
	OUT_GT.bDeflagrationPrct := M_DREHZ AND ((T_FGPUFF AND Z_PUFF) OR OUT_GT.bDeflagrationPrct) AND NOT xTOF_bLR_GasStop.Q;
		
	IF NOT Para.bPr_PC_Active THEN					(* Type6 without prechamber *)
		OUT_GT.bDeflagrationPrct := FALSE;
	END_IF;
			
	IF xTOF_bLR_GasStop.Q THEN
		bBlowOff_PrHi_Err := (ANA_PDIFF > Para.rPr_BlowOff_LimHi);
	ELSE
		bBlowOff_PrHi_Err := FALSE;
	END_IF;
		
	xTON_FA_ZUEND_PUFF.IN := OUT_GT.bDeflagrationPrct;
	xTON_FA_ZUEND_PUFF.PT := T#200ms;
	xTON_FA_ZUEND_PUFF();
	IF xEngType.Type9 THEN 		(* SWAT Rel.3 *)
		OUT_GT.bIgnDeflPrct_Off := xTON_FA_ZUEND_PUFF.Q AND NOT IN_GT.bPBC_Active;
	ELSE
		OUT_GT.bIgnDeflPrct_Off := xTON_FA_ZUEND_PUFF.Q;
	END_IF;
		
	(* Turn Off PUFF *)
	xR_TRIG_FA_FL_PUFF.CLK := OUT_GT.bDeflagrationPrct;
	xR_TRIG_FA_FL_PUFF();
	xRS_FL_PUFF.SET := xR_TRIG_FA_FL_PUFF.Q;
	xRS_FL_PUFF();	
	FL_PUFF := xR_TRIG_FA_FL_PUFF.Q;	
			
	xTP_R_FA_T_PUFF_1.IN := FL_PUFF AND NOT T_PUFF_1;
	// Shortened timer for testing	
	IF bTestEnabled THEN
		xTP_R_FA_T_PUFF_1.PT := 60000;   // 60 secconds
	ELSE
		xTP_R_FA_T_PUFF_1.PT := 360000;
	END_IF;		
	xTP_R_FA_T_PUFF_1.RS := MM2VIS.bMsg1094 OR MM2VIS.bMsg2467;
	xTP_R_FA_T_PUFF_1();
	T_PUFF_1 := xTP_R_FA_T_PUFF_1.Q;
		
	(*****************************************************)	
	xR_TRIG_FA_FL_Z_PUFF_1.CLK := T_PUFF_1;
	xR_TRIG_FA_FL_Z_PUFF_1();
	xRS_FL_PUFF.RESET1 := xR_TRIG_FA_FL_Z_PUFF_1.Q;
	xRS_FL_PUFF();
	FL_PUFF := 	xRS_FL_PUFF.Q1;
		 
	xTP_R_FA_T_PUFF_2.IN := FL_PUFF AND NOT T_PUFF_2;
	// Shortened timer for testing	
	IF bTestEnabled THEN
		xTP_R_FA_T_PUFF_2.PT := 60000;   // 60 secconds
	ELSE
		xTP_R_FA_T_PUFF_2.PT := 360000;
	END_IF;	
	xTP_R_FA_T_PUFF_2.RS := MM2VIS.bMsg1094 OR MM2VIS.bMsg2467; // reset_alarm 1094
	xTP_R_FA_T_PUFF_2();
	T_PUFF_2 := xTP_R_FA_T_PUFF_2.Q;
		
	(*****************************************************)	
	xR_TRIG_FA_FL_Z_PUFF_2.CLK := T_PUFF_2;
	xR_TRIG_FA_FL_Z_PUFF_2();
	IF (xR_TRIG_FA_FL_Z_PUFF_2.Q = FALSE) THEN
		xRS_FL_PUFF.SET := FALSE;
	END_IF;
	xRS_FL_PUFF.RESET1 := xR_TRIG_FA_FL_Z_PUFF_2.Q;
	xRS_FL_PUFF();
	FL_PUFF := xRS_FL_PUFF.Q1;	
		 
	xTP_R_FA_T_PUFF_3.IN := FL_PUFF AND NOT T_PUFF_3;
	// Shortened timer for testing
	IF bTestEnabled THEN
		xTP_R_FA_T_PUFF_3.PT := 60000;   // 60 secconds
	ELSE
		xTP_R_FA_T_PUFF_3.PT := 360000;
	END_IF;
	xTP_R_FA_T_PUFF_3.RS := MM2VIS.bMsg1094 OR MM2VIS.bMsg2467; // reset_alarm 1094
	xTP_R_FA_T_PUFF_3();
	T_PUFF_3 := xTP_R_FA_T_PUFF_3.Q;
		
	(*****************************************************)		
	xR_TRIG_FA_FL_Z_PUFF_3.CLK := T_PUFF_3;
	xR_TRIG_FA_FL_Z_PUFF_3();
	IF (xR_TRIG_FA_FL_Z_PUFF_3.Q = FALSE) THEN
		xRS_FL_PUFF.SET := FALSE;
	END_IF;	 	 
	xRS_FL_PUFF.RESET1 := xR_TRIG_FA_FL_Z_PUFF_3.Q;
	xRS_FL_PUFF();		
	FL_PUFF := xRS_FL_PUFF.Q1;	
			
ELSE 
	OUT_GT.bDeflagrationPrct := FALSE;	
END_IF;

END_PROGRAM
