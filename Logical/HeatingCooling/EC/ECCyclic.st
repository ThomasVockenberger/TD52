(*******************************************************************************
EC 			emergency cooler

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V0.1	03.07.1998	Pa			erstellt
 		24.11.1998	Pa			korrekturlesung
V172	20.08.2002	LH			überarbeitet
V173	27.09.2002	LH			Fehler in Abschaltung Stufe 7 korrigiert
V180	25.02.2003	LH			nkv_schr --> kv_schr, Ausgangsvariablen umbenannt, Grenzwerte über Rezept
		07.03.2003	LH			Freigabe Kühler umgebaut für Service
V181	05.06.2003	LH			Kontaktplan --> strukturierten Text
V183	16.09.2003	LH			Korrektur Vorzeichen P-Anteil
		12.12.2003	LH			Variante Kombikühler
V2071	03.01.2005	LH			Korrektur Start Kühler durch Temperaturgrenzwerte,
								Ansteuerung Notkühlpumpe nur über Ventilstellung
V2071b	28.06.2005	LH			Korrektur Start Kühler über Ventilstellung
V190	08.09.2004	LH			Erweiterung auf 11 Regler für XT
V2102	22.11.2006	LH			Korrektur Ansteuerung Notkühlpumpe für ausgebundenen Notkühlkreis und Kombikühler
V230	24.01.2008	LH			Abarbeitung nur wenn Kühler vorhanden ist (Para.iEC_OpMode <> 0)
		06.02.2008	LH			angepasst an Auto-Tune Regler
V2.34.0 23.10.2008	lettenb.	OUT_HC.bEC_Stage1-16:(FA_K_EIN.Q OR Kombi_K) added(fan only if OUT_HC.bEC_DemP)
V3.10.0 17.02.2010	lettenb. 	corr.demand fan stage 1,2 (brackets)	fehlerbehebung(robert mayer)
V3.20.0	11.11.2010	lettenb. 	Anz_anfhbt, K_Var, K_Anz, K_reg -> parameters
V3.99.0	21.02.2013	lettenb.	parts from pb3 included
		24.06.2013				GRMin_Ventpos2,xGRMax_Ventpos2,GRMax_Ventpos4: Hy:= 1->0.01, bugfix
V4.00.0	03.03.2015	lettenb.	K_frg (IN_HC.bEC_Rel) moved to MM_CU
V4.03.0 07.08.2015  Denk		Manual operating auxiliaries control functionality added
V4.07.0	08.01.2019	Schmid		redundant pump control
V4.10.0	02.02.2021	lettenb.	OUT_HC.tEC_DemPump.Do only when	auxiliaries demanded(bEng_Aux_Dem_CDR)
								for safety purposes: otherwise pump starts immediately when y-limit is reached(or setted manually)
								OUT_HC.bEmCWP_Dem for K_Var > 0 prepared for reduntant pumps, bugfix
		
Instructions for use:
--------------------

Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC

	(*------------------------------------------------------------------------------------------*)
	(* parameters *)
	K_Var 		:= 				LIMIT(0, Para.iEC_OpMode, 3);			(* cooler type
																			0 = cooler simple version
																			1 = cooler level dependent on valve position
																			2 = cooler level dependent on temperature
																			3 = combined cooler (type 1 and 2) *)
	K_Anz 		:= INT_TO_USINT(LIMIT(1, Para.iEC_NumStages, 16));		(* number cooler stages *)
	Anz_anfhbt	:= INT_TO_USINT(LIMIT(0, Para.iEC_NumDemAux, K_Anz));	(* number cooler stages with demand auxiliaries *)
	K_reg		:= INT_TO_USINT(LIMIT(1, Para.iEC_NumCtr, 11));			(* number controller for y *) 
	K_nmp		:= 						 Para.bEC_St1onlyP;				(* selection first stage without fan (only pump)*)
																		(* only IF setting FOR number cooler stages with demand auxiliaries = 0 ! *)
																		(* this option reduces effective cooler fan stages by 1 step ! *) 
	
	(*------------------------------------------------------------------------------------------*)
	(* release emergency cooler from monitoring (from MM_CU) *)
	IN_HC.bEC_Rel;

	(*------------------------------------------------------------------------------------------*)	
	(* release for external cooler *)
	OUT_HC.tExCo_Rel.Do	:=	IN_HC.bEng_Aux_Dem_CDR 
						AND(bT_HW_Re_Hi OR bT_HW_ReBeEng_Hi);	

	
	(*==========================================================================================*)
	(* emergency cooler control - simple version *)		
	IF K_Var = 0 THEN

		OUT_HC.tEC_DemPump.Do	:= (IN_HC.bEC_Rel
								AND IN_HC.bEng_Aux_Dem_CDR AND (bT_AirOutdoor_Hi1 OR NOT Para.bT_AirOutdoor_Active))
								OR IN_HC.tManAuxCtr.bEC_DemPump;	(* Manual operating auxiliaries control - Handbedienebene *)
		OUT_HC.bEmCWP_Dem		:= OUT_HC.tEC_DemPump.Do;
		
		(* stage 1 *)
		K_ST1	:=  IN_HC.bEC_Rel
				AND	IN_HC.bEng_Aux_Dem_CDR 
				AND(bT_AirOutdoor_Hi1 OR NOT Para.bT_AirOutdoor_Active);
		   
		(* stage 2 *)	
		K_ST2	:=	IN_HC.bEC_Rel 
				AND K_ST1
				AND	IN_HC.bEng_Aux_Dem_CDR 
				AND(bT_AirOutdoor_Hi2 OR NOT Para.bT_AirOutdoor_Active);
		   
		(* stage 3 *)
		K_ST3	:=	IN_HC.bEC_Rel 
				AND K_ST2
				AND((IN_HC.bEng_Aux_Dem_CDR AND bT_AirOutdoor_Hi3) OR (bT_ECW_Hi1 AND NOT Para.bT_AirOutdoor_Active));
	
		(* stage 4 *)
		K_ST4	:=	IN_HC.bEC_Rel 
				AND K_ST3
				AND((IN_HC.bEng_Aux_Dem_CDR AND bT_AirOutdoor_Hi4) OR (bT_ECW_Hi2 AND NOT Para.bT_AirOutdoor_Active));

	END_IF;


	(*==========================================================================================*)
	(* emergency cooler control - stepper version *)	

	IF K_Var > 0 THEN		
	(* cooler stages ON/OFF (cooler type 2/3)*)   
		bEC_Up   :=     bT_ECW_Hi2 OR      bT_Ch_Hi2 OR      bT_EO_Hi2;
		bEC_Down := NOT bT_ECW_Hi1 AND NOT bT_Ch_Hi1 AND NOT bT_EO_Hi1;	
		
		
		(*---------------------------------------------------------------------------------------*)	
		FA_INIT_0.Word	:=	INT_TO_UINT(K_Var);
		FA_INIT_0;	
		K_vent			:=	FA_INIT_0.Bit00;
		K_temp			:=	FA_INIT_0.Bit01;
		muell			:=	FA_INIT_0.Bit02;
		muell			:=	FA_INIT_0.Bit03;
		muell			:=	FA_INIT_0.Bit04;
		muell			:=	FA_INIT_0.Bit05;
		muell			:=	FA_INIT_0.Bit06;
		muell			:=	FA_INIT_0.Bit07;
		muell			:=	FA_INIT_0.Bit08;
		muell			:=	FA_INIT_0.Bit09;
		muell			:=	FA_INIT_0.Bit10;
		muell			:=	FA_INIT_0.Bit11;
		muell			:=	FA_INIT_0.Bit12;
		muell			:=	FA_INIT_0.Bit13;
		muell			:=	FA_INIT_0.Bit14;
		muell			:=	FA_INIT_0.Bit15;

		IF	K_vent AND K_temp	THEN
			Kombi_K		:=	1;
		ELSE				
			Kombi_K		:=	0;
		END_IF;

		IF	Anz_anfhbt > 0	THEN
			K_nmp		:=	0;
			K_anfhbt	:=	1;
		ELSE
			K_anfhbt	:=	0;
		END_IF;

		FOR	i			:=	1 TO 16 BY 1 DO
			anfhbt[i]	:=	0;
		END_FOR;
		FOR	i			:=	1 TO Anz_anfhbt BY 1 DO
			anfhbt[i]	:=	1;
		END_FOR;


		(* number effective cooler stages *)
		Anz_st			:=	MIN(K_Anz - (MAX(Anz_anfhbt, 1) - 1) + BOOL_TO_USINT(K_nmp), 16);

		zw				:=	1;
		FOR i			:=	1 TO Anz_st BY 1	DO
			zw			:=	zw * 2;
		END_FOR;

		FA_INIT_1.Word	:=	UDINT_TO_UINT(zw - 1);
		FA_INIT_1;
		ST_1			:=	FA_INIT_1.Bit00;
		ST_2			:=	FA_INIT_1.Bit01;
		ST_3			:=	FA_INIT_1.Bit02;
		ST_4			:=	FA_INIT_1.Bit03;
		ST_5			:=	FA_INIT_1.Bit04;
		ST_6			:=	FA_INIT_1.Bit05;
		ST_7			:=	FA_INIT_1.Bit06;
		ST_8			:=	FA_INIT_1.Bit07;
		ST_9			:=	FA_INIT_1.Bit08;
		ST_10			:=	FA_INIT_1.Bit09;
		ST_11			:=	FA_INIT_1.Bit10;
		ST_12			:=	FA_INIT_1.Bit11;
		ST_13			:=	FA_INIT_1.Bit12;
		ST_14			:=	FA_INIT_1.Bit13;
		ST_15			:=	FA_INIT_1.Bit14;
		ST_16			:=	FA_INIT_1.Bit15;


		(* activation cooler stages *)
		Anz_vent		:=	MIN(K_Anz, 16 - BOOL_TO_USINT(K_nmp));

		zw				:=	1;
		FOR	i			:=	1 TO Anz_vent BY 1	DO
			zw			:=	zw * 2;
		END_FOR;

		FA_INIT_2.Word	:=	UDINT_TO_UINT(zw - 1);
		FA_INIT_2;
		K_ST_1			:=	FA_INIT_2.Bit00;
		K_ST_2			:=	FA_INIT_2.Bit01;
		K_ST_3			:=	FA_INIT_2.Bit02;
		K_ST_4			:=	FA_INIT_2.Bit03;
		K_ST_5			:=	FA_INIT_2.Bit04;
		K_ST_6			:=	FA_INIT_2.Bit05;
		K_ST_7			:=	FA_INIT_2.Bit06;
		K_ST_8			:=	FA_INIT_2.Bit07;
		K_ST_9			:=	FA_INIT_2.Bit08;
		K_ST_10			:=	FA_INIT_2.Bit09;
		K_ST_11			:=	FA_INIT_2.Bit10;
		K_ST_12			:=	FA_INIT_2.Bit11;
		K_ST_13			:=	FA_INIT_2.Bit12;
		K_ST_14			:=	FA_INIT_2.Bit13;
		K_ST_15			:=	FA_INIT_2.Bit14;
		K_ST_16			:=	FA_INIT_2.Bit15;


		(* 3-way cooler valve *)
		CASE K_reg OF							(* selection plant ctr # for 3-way valve (1-11) (cooler type 1/3) *)
		1:	F_SPSR		:=	IN_HC.tCtr_Cust1_In.enable;	(* 1-8 = custom plant ctr - device temperature *)
			rValvePos	:=	IN_HC.tCtr_Cust1_Out.Y;
			REG_INVERT	:=	Para.tCtr_Cust1.invert;	
		2:	F_SPSR		:=	IN_HC.tCtr_Cust2_In.enable;
			rValvePos	:=	IN_HC.tCtr_Cust2_Out.Y;
			REG_INVERT	:=	Para.tCtr_Cust2.invert;			
		3:	F_SPSR		:=	IN_HC.tCtr_Cust3_In.enable;
			rValvePos	:=	IN_HC.tCtr_Cust3_Out.Y;
			REG_INVERT	:=	Para.tCtr_Cust3.invert;			
		4:	F_SPSR		:=	IN_HC.tCtr_Cust4_In.enable;
			rValvePos	:=	IN_HC.tCtr_Cust4_Out.Y;
			REG_INVERT	:=	Para.tCtr_Cust4.invert;	
		5:	F_SPSR		:=	IN_HC.tCtr_Cust5_In.enable;
			rValvePos	:=	IN_HC.tCtr_Cust5_Out.Y;
			REG_INVERT	:=	Para.tCtr_Cust5.invert;			
		6:	F_SPSR		:=	IN_HC.tCtr_Cust6_In.enable;
			rValvePos	:=	IN_HC.tCtr_Cust6_Out.Y;
			REG_INVERT	:=	Para.tCtr_Cust6.invert;			
		7:	F_SPSR		:=	IN_HC.tCtr_Cust7_In.enable;
			rValvePos	:=	IN_HC.tCtr_Cust7_Out.Y;
			REG_INVERT	:=	Para.tCtr_Cust7.invert;	
		8:	F_SPSR		:=	IN_HC.tCtr_Cust8_In.enable;
			rValvePos	:=	IN_HC.tCtr_Cust8_Out.Y;
			REG_INVERT	:=	Para.tCtr_Cust8.invert;			
		9:	F_SPSR		:=	tCtr_ChC_In.enable;			(* 9   = charge temperature controller *)
			rValvePos	:=	tCtr_ChC_Out.Y;
			REG_INVERT	:=	Para.tCtr_ChC.invert;			
		10:	F_SPSR		:=	tCtr_HWRe_In.enable;		(* 10  =  heat water return temperature controller *)
			rValvePos	:=	tCtr_HWRe_Out.Y;
			REG_INVERT	:=	Para.tCtr_HWRe.invert;	
		11:	F_SPSR		:=	tCtr_EC_In.enable;			(* 11  =  heat water return temperature after cooler controller *)
			rValvePos	:=	tCtr_EC_Out.Y;
			REG_INVERT	:=	Para.tCtr_EC.invert;			
		ELSE
			F_SPSR		:=	FALSE;
			rValvePos	:=	0.0;
			REG_INVERT	:=	FALSE;			
		END_CASE;
		
		IF	NOT REG_INVERT	THEN
			rValvePos	:=	1.0 - rValvePos;
		END_IF;


	    (*---------------------------------------------------------------------------*)
		(* cooler ON *)
		xGRMax_Ventpos5(Gw:= Para.rEC_ValPosLimHi_On, Hy:= Para.rEC_ValPosHyHi_On, In:= rValvePos);
	
	    (*---------------------------------------------------------------------------*)
		xTOF_K_AUS.IN	:= (K_vent AND xGRMax_Ventpos5.Q AND IN_HC.tPB2MM.bParaSetupOk AND USINT_TO_BOOL(F_SPSR))
						OR (K_temp AND ((bEC_Up OR K_EIN AND NOT bEC_Down) OR K_EIN AND M_KV2));
		xTOF_K_AUS.PT	:=	Para.tiEC_DelayOff;
		xTOF_K_AUS;

		K_EIN			:=	(xTOF_K_AUS.Q OR K_anfhbt) AND IN_HC.bEng_Aux_Dem_CDR AND IN_HC.bEC_Rel;


	    (*---------------------------------------------------------------------------*)
		(* cooler stage plus *)
		xGRMax_Ventpos4(Gw:= Para.rEC_ValPosLimStageUp, Hy:= 0.01, In:= rValvePos);
	
	    (*---------------------------------------------------------------------------*)
		K_PLUS			:= (K_vent AND xGRMax_Ventpos4.Q AND IN_HC.tPB2MM.bParaSetupOk)
						OR (K_temp AND bEC_Up);

	    (*---------------------------------------------------------------------------*)
		(* cooler stage minus *)
		xGRMin_Ventpos2(Gw:= Para.rEC_ValPosLimStageDown, Hy:= 0.01, In:= rValvePos);
	
	    (*---------------------------------------------------------------------------*)

		IF	Kombi_K	THEN
			K_MINUS		:= (xGRMin_Ventpos2.Q AND IN_HC.tPB2MM.bParaSetupOk AND bEC_Down) AND NOT K_PLUS;
		ELSE			
			K_MINUS		:= (xGRMin_Ventpos2.Q AND IN_HC.tPB2MM.bParaSetupOk AND K_vent OR bEC_Down AND K_temp) AND NOT K_PLUS;
		END_IF;

	    (*---------------------------------------------------------------------------*)
		(* delay between ON *)
		xTOF_PLUS(IN:=	plus, PT:= Para.tiEC_DelayStageUp);
		xR_TRIG_PLUS(CLK:= K_PLUS AND NOT xTOF_PLUS.Q);

	    (*---------------------------------------------------------------------------*)
		(* delay between OFF *)
		xTOF_MINUS(IN:= minus, PT:= Para.tiEC_DelayStageDown);
		xR_TRIG_MINUS(CLK:= K_MINUS AND NOT xTOF_MINUS.Q);

	    (*---------------------------------------------------------------------------*)
		(* reset state maschine *)
		IF	NOT K_EIN	THEN
			schritt		:=	0;
		END_IF;


		(* state maschine *)
		CASE schritt OF	00:	(* cooler stopped *)
			FA_INIT_3.Word	:=	0;
			FA_INIT_3;
			M_KV1			:=	FA_INIT_3.Bit00;
			M_KV2			:=	FA_INIT_3.Bit01;
			M_KV3			:=	FA_INIT_3.Bit02;
			M_KV4			:=	FA_INIT_3.Bit03;
			M_KV5			:=	FA_INIT_3.Bit04;
			M_KV6			:=	FA_INIT_3.Bit05;
			M_KV7			:=	FA_INIT_3.Bit06;
			M_KV8			:=	FA_INIT_3.Bit07;
			M_KV9			:=	FA_INIT_3.Bit08;
			M_KV10			:=	FA_INIT_3.Bit09;
			M_KV11			:=	FA_INIT_3.Bit10;
			M_KV12			:=	FA_INIT_3.Bit11;
			M_KV13			:=	FA_INIT_3.Bit12;
			M_KV14			:=	FA_INIT_3.Bit13;
			M_KV15			:=	FA_INIT_3.Bit14;
			M_KV16			:=	FA_INIT_3.Bit15;

			(* ON 1.stage *)
			IF	K_EIN	THEN
				schritt		:=	10;
			END_IF;

		10:	(* cooler stage 1 *)
			M_KV1			:=	1;
			M_KV2			:=	0;
			(* ON 2.stage *)
			IF	K_PLUS AND (   (K_temp AND bEC_Up AND xR_TRIG_PLUS.Q)
						    OR (K_vent AND xGRMax_Ventpos4.Q)) THEN
				schritt		:=	20;
			END_IF;

		20:	(* cooler stage 2 *)
			M_KV2			:=	1;
			M_KV3			:=	0;
			(* ON 3.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_3 THEN
				schritt		:=	30;
			END_IF;
			(* OFF 3.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_3) THEN
				schritt		:=	10;
			END_IF;

		30:	(* cooler stage 3 *)
			M_KV3			:=	1;
			M_KV4			:=	0;
			(* ON 4.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_4 THEN
				schritt		:=	40;
			END_IF;
			(* OFF 3.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_4) THEN
				schritt		:=	20;
			END_IF;

		40:	(* cooler stage 4 *)
			M_KV4			:=	1;
			M_KV5			:=	0;
			(* ON 5.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_5 THEN
				schritt		:=	50;
			END_IF;
			(* OFF 4.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_5) THEN
				schritt		:=	30;
			END_IF;

		50:	(* cooler stage 5 *)
			M_KV5			:=	1;
			M_KV6			:=	0;
			(* ON 6.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_6 THEN
				schritt		:=	60;
			END_IF;
			(* OFF 5.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_6) THEN
				schritt		:=	40;
			END_IF;

		60:	(* cooler stage 6 *)
			M_KV6			:=	1;
			M_KV7			:=	0;
			(* ON 7.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_7 THEN
				schritt		:=	70;
			END_IF;
			(* OFF 6.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_7) THEN
				schritt		:=	50;
			END_IF;

		70:	(* cooler stage 7 *)
			M_KV7			:=	1;
			M_KV8			:=	0;
			(* ON 8.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_8 THEN
				schritt		:=	80;
			END_IF;
			(* OFF 7.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_8) THEN
				schritt		:=	60;
			END_IF;

		80:	(* cooler stage 8 *)
			M_KV8			:=	1;
			M_KV9			:=	0;
			(* ON 9.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_9 THEN
				schritt		:=	90;
			END_IF;
			(* OFF 8.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_9) THEN
				schritt		:=	70;
			END_IF;

		90:	(* cooler stage 9 *)
			M_KV9			:=	1;
			M_KV10			:=	0;
			(* ON 10.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_10 THEN
				schritt		:=	100;
			END_IF;
			(* OFF 9.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_10) THEN
				schritt		:=	80;
			END_IF;

		100:(* cooler stage 10 *)
			M_KV10			:=	1;
			M_KV11			:=	0;
			(* ON 11.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_11 THEN
				schritt		:=	110;
			END_IF;
			(* OFF 10.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_11) THEN
				schritt		:=	90;
			END_IF;

		110:(* cooler stage 11 *)
			M_KV11			:=	1;
			M_KV12			:=	0;
			(* ON 12.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_12 THEN
				schritt		:=	120;
			END_IF;
			(* OFF 11.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_12) THEN
				schritt		:=	100;
			END_IF;

		120:(* cooler stage 12 *)
			M_KV12			:=	1;
			M_KV13			:=	0;
			(* ON 13.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_13 THEN
				schritt		:=	130;
			END_IF;
			(* OFF 12.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_13) THEN
				schritt		:=	110;
			END_IF;

		130:(* cooler stage 13 *)
			M_KV13			:=	1;
			M_KV14			:=	0;
			(* ON 14.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_14 THEN
				schritt		:=	140;
			END_IF;
			(* OFF 13.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_14) THEN
				schritt		:=	120;
			END_IF;

		140:(* cooler stage 14 *)
			M_KV14			:=	1;
			M_KV15			:=	0;
			(* ON 15.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_15 THEN
				schritt		:=	150;
			END_IF;
			(* OFF 14.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_15) THEN
				schritt		:=	130;
			END_IF;

		150:(* cooler stage 15 *)
			M_KV15			:=	1;
			M_KV16			:=	0;
			(* ON 16.stage *)
			IF	K_PLUS AND xR_TRIG_PLUS.Q AND ST_16 THEN
				schritt		:=	160;
			END_IF;
			(* OFF 15.stage *)
			IF	K_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_16) THEN
				schritt		:=	140;
			END_IF;

		160:(* cooler stage 16 *)
			M_KV16			:=	1;
			(* OFF 16.stage *)
			IF	K_MINUS	THEN
				schritt		:=	150;
			END_IF;
		END_CASE;


		(* dump radiator pump *)
		OUT_HC.tEC_DemPump.Do	:= (IN_HC.bEng_Aux_Dem_CDR AND(((M_KV1  OR  xGRMax_Ventpos5.Q)AND NOT Kombi_K)
															  OR(M_KV1  AND xGRMax_Ventpos5.Q)))
								 OR IN_HC.tManAuxCtr.bEC_DemPump;	(* Manual operating auxiliaries control - Handbedienebene *)
		OUT_HC.bEmCWP_Dem		:= OUT_HC.tEC_DemPump.Do;

		(* connection steps to sequencing *)
		K_ST1	:= (xGRMax_Ventpos5.Q	OR 	NOT Kombi_K)
				AND(   (M_KV1  	AND NOT K_nmp)	
					OR	M_KV2);

		K_ST2	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)
				AND(   (M_KV1  	AND 	anfhbt[2])
					OR (M_KV2  	AND NOT K_nmp)
					OR	M_KV3);

		K_ST3	:= (xGRMax_Ventpos5.Q	OR 	NOT Kombi_K)
				AND(   (M_KV1  	AND 	anfhbt[3])
					OR (M_KV2  	AND 	anfhbt[2])
					OR (M_KV3  	AND NOT K_nmp)
					OR	M_KV4);

		K_ST4	:= (xGRMax_Ventpos5.Q	OR 	NOT Kombi_K)
				AND(   (M_KV1  	AND 	anfhbt[4])
					OR (M_KV2  	AND 	anfhbt[3])
					OR (M_KV3  	AND 	anfhbt[2])
					OR (M_KV4  	AND NOT K_nmp)
					OR	M_KV5);

		K_ST5	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)
				AND(   (M_KV1  	AND 	anfhbt[5])
					OR (M_KV2  	AND 	anfhbt[4])
					OR (M_KV3  	AND 	anfhbt[3])
					OR (M_KV4  	AND 	anfhbt[2])
					OR (M_KV5  	AND NOT K_nmp)
					OR	M_KV6);

		K_ST6	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1	AND 	anfhbt[6])
					OR (M_KV2  	AND 	anfhbt[5])
					OR (M_KV3  	AND 	anfhbt[4])
					OR (M_KV4  	AND 	anfhbt[3])
					OR (M_KV5  	AND 	anfhbt[2])
					OR (M_KV6  	AND NOT K_nmp)
					OR  M_KV7);

		K_ST7	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)		
				AND(   (M_KV1  	AND 	anfhbt[7])
					OR (M_KV2  	AND 	anfhbt[6])
					OR (M_KV3  	AND 	anfhbt[5])
					OR (M_KV4  	AND 	anfhbt[4])
					OR (M_KV5  	AND 	anfhbt[3])
					OR (M_KV6  	AND 	anfhbt[2])
					OR (M_KV7  	AND NOT K_nmp)
					OR  M_KV8);

		K_ST8	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[8])
					OR (M_KV2  	AND 	anfhbt[7])
					OR (M_KV3  	AND 	anfhbt[6])
					OR (M_KV4  	AND 	anfhbt[5])
					OR (M_KV5  	AND 	anfhbt[4])
					OR (M_KV6  	AND 	anfhbt[3])
					OR (M_KV7  	AND 	anfhbt[2])
					OR (M_KV8  	AND NOT K_nmp)
					OR  M_KV9);

		K_ST9	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[9])
					OR (M_KV2  	AND 	anfhbt[8])
					OR (M_KV3  	AND 	anfhbt[7])
					OR (M_KV4  	AND 	anfhbt[6])
					OR (M_KV5  	AND 	anfhbt[5])
					OR (M_KV6  	AND 	anfhbt[4])
					OR (M_KV7  	AND 	anfhbt[3])
					OR (M_KV8  	AND 	anfhbt[2])
					OR (M_KV9  	AND NOT K_nmp)
					OR  M_KV10);

		K_ST10	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[10])
					OR (M_KV2  	AND 	anfhbt[9])
					OR (M_KV3  	AND 	anfhbt[8])
					OR (M_KV4  	AND 	anfhbt[7])
					OR (M_KV5  	AND 	anfhbt[6])
					OR (M_KV6  	AND 	anfhbt[5])
					OR (M_KV7  	AND 	anfhbt[4])
					OR (M_KV8  	AND 	anfhbt[3])
					OR (M_KV9  	AND 	anfhbt[2])
					OR (M_KV10 	AND NOT K_nmp)
					OR  M_KV11);

		K_ST11	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[11])
					OR (M_KV2  	AND 	anfhbt[10])
					OR (M_KV3  	AND 	anfhbt[9])
					OR (M_KV4  	AND 	anfhbt[8])
					OR (M_KV5  	AND 	anfhbt[7])
					OR (M_KV6  	AND 	anfhbt[6])
					OR (M_KV7  	AND 	anfhbt[5])
					OR (M_KV8  	AND 	anfhbt[4])
					OR (M_KV9  	AND 	anfhbt[3])
					OR (M_KV10 	AND 	anfhbt[2])
					OR (M_KV11 	AND NOT K_nmp)
					OR  M_KV12);

		K_ST12	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[12])
					OR (M_KV2  	AND 	anfhbt[11])
					OR (M_KV3  	AND 	anfhbt[10])
					OR (M_KV4  	AND 	anfhbt[9])
					OR (M_KV5  	AND 	anfhbt[8])
					OR (M_KV6  	AND 	anfhbt[7])
					OR (M_KV7  	AND 	anfhbt[6])
					OR (M_KV8  	AND 	anfhbt[5])
					OR (M_KV9  	AND 	anfhbt[4])
					OR (M_KV10 	AND 	anfhbt[3])
					OR (M_KV11 	AND 	anfhbt[2])
					OR (M_KV12 	AND NOT K_nmp)
					OR  M_KV13);

		K_ST13	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[13])
					OR (M_KV2  	AND 	anfhbt[12])
					OR (M_KV3  	AND 	anfhbt[11])
					OR (M_KV4  	AND 	anfhbt[10])
					OR (M_KV5  	AND 	anfhbt[9])
					OR (M_KV6  	AND 	anfhbt[8])
					OR (M_KV7  	AND 	anfhbt[7])
					OR (M_KV8  	AND 	anfhbt[6])
					OR (M_KV9  	AND 	anfhbt[5])
					OR (M_KV10 	AND 	anfhbt[4])
					OR (M_KV11 	AND 	anfhbt[3])
					OR (M_KV12 	AND 	anfhbt[2])
					OR (M_KV13 	AND NOT K_nmp)
					OR  M_KV14);

		K_ST14	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[14])
					OR (M_KV2  	AND 	anfhbt[13])
					OR (M_KV3  	AND 	anfhbt[12])
					OR (M_KV4  	AND 	anfhbt[11])
					OR (M_KV5  	AND 	anfhbt[10])
					OR (M_KV6  	AND 	anfhbt[9])
					OR (M_KV7  	AND 	anfhbt[8])
					OR (M_KV8  	AND 	anfhbt[7])
					OR (M_KV9  	AND 	anfhbt[6])
					OR (M_KV10 	AND 	anfhbt[5])
					OR (M_KV11 	AND 	anfhbt[4])
					OR (M_KV12 	AND 	anfhbt[3])
					OR (M_KV13 	AND 	anfhbt[2])
					OR (M_KV14 	AND NOT K_nmp)
					OR  M_KV15);

		K_ST15	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[15])
					OR (M_KV2  	AND 	anfhbt[14])
					OR (M_KV3  	AND 	anfhbt[13])
					OR (M_KV4  	AND 	anfhbt[12])
					OR (M_KV5  	AND 	anfhbt[11])
					OR (M_KV6  	AND 	anfhbt[10])
					OR (M_KV7  	AND 	anfhbt[9])
					OR (M_KV8  	AND 	anfhbt[8])
					OR (M_KV9  	AND 	anfhbt[7])
					OR (M_KV10 	AND 	anfhbt[6])
					OR (M_KV11 	AND 	anfhbt[5])
					OR (M_KV12 	AND 	anfhbt[4])
					OR (M_KV13 	AND 	anfhbt[3])
					OR (M_KV14 	AND 	anfhbt[2])
					OR (M_KV15 	AND NOT K_nmp)
					OR  M_KV16);

		K_ST16	:= (xGRMax_Ventpos5.Q 	OR 	NOT Kombi_K)	
				AND(   (M_KV1  	AND 	anfhbt[16])
					OR (M_KV2  	AND 	anfhbt[15])
					OR (M_KV3  	AND 	anfhbt[14])
					OR (M_KV4  	AND 	anfhbt[13])
					OR (M_KV5  	AND 	anfhbt[12])
					OR (M_KV6  	AND 	anfhbt[11])
					OR (M_KV7  	AND 	anfhbt[10])
					OR (M_KV8  	AND 	anfhbt[9])
					OR (M_KV9  	AND 	anfhbt[8])
					OR (M_KV10 	AND 	anfhbt[7])
					OR (M_KV11 	AND 	anfhbt[6])
					OR (M_KV12 	AND 	anfhbt[5])
					OR (M_KV13 	AND 	anfhbt[4])
					OR (M_KV14 	AND 	anfhbt[3])
					OR (M_KV15 	AND 	anfhbt[2])
					OR (M_KV16 	AND NOT K_nmp));


		(* copy for summation *)
		KST[1]	:=	BOOL_TO_USINT(M_KV1);
		KST[2]	:=	BOOL_TO_USINT(M_KV2);
		KST[3]	:=	BOOL_TO_USINT(M_KV3);
		KST[4]	:=	BOOL_TO_USINT(M_KV4);
		KST[5]	:=	BOOL_TO_USINT(M_KV5);
		KST[6]	:=	BOOL_TO_USINT(M_KV6);
		KST[7]	:=	BOOL_TO_USINT(M_KV7);
		KST[8]	:=	BOOL_TO_USINT(M_KV8);
		KST[9]	:=	BOOL_TO_USINT(M_KV9);
		KST[10]	:=	BOOL_TO_USINT(M_KV10);
		KST[11]	:=	BOOL_TO_USINT(M_KV11);
		KST[12]	:=	BOOL_TO_USINT(M_KV12);
		KST[13]	:=	BOOL_TO_USINT(M_KV13);
		KST[14]	:=	BOOL_TO_USINT(M_KV14);
		KST[15]	:=	BOOL_TO_USINT(M_KV15);
		KST[16]	:=	BOOL_TO_USINT(M_KV16);


		(* ON / OFF cooler stages *)
		summe := 0;
		FOR i:= 1 TO 16 BY 1 DO
			summe := summe + KST[i];
		END_FOR;

		plus := 0;
		IF (summe > summe_old) THEN
			plus :=	1;
		END_IF;

		minus := 0;
		IF (summe < summe_old) THEN
			minus := 1;
		END_IF;

		summe_old := summe;

	END_IF;
	(*------------------------------------------------------------------------------------------*)
	
END_PROGRAM
