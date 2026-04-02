(*******************************************************************************
ChC 			charge cooler

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, OR reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V2.30	24.01.2008	LH			erstellt (Kopie von kv_schr)
 		06.02.2008	LH			angepasst an Auto-Tune Regler
V3.10.0	17.02.2010	lettenb.	corr.demand fan stage 1,2  step10: AND NOT FA_PLUS.Q --> AND FA_PLUS.Q
								corr. Anz_GK_anfhbt LIMIT(1->0,...)  	fehlerbehebung(robert mayer)
V3.99.0	21.02.2013	lettenb.	parts from pb3 included
		24.06.2013	lettenb.	xGRMin_Ventpos: Hy:= 1->0.01, bugfix
V4.00.0	03.03.2015	lettenb.	GK_frg (IN_HC.bChC_Rel) moved TO MM_CU
V4.03.0 07.08.2015  Denk		Manual operating auxiliaries control functionality added
        30.09.2015  Plattner	charge cooling pre heating OUT_HC.tChC_Heating.Do added
V4.07.0	09.08.2018	Schmid		2nd low temperature charge cooling circuit added
		08.01.2019	Schmid		redundant pump control
		22.02.2019	Schmid		Charge cooler heating bugfix

Instructions for use:
--------------------

Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC	
	//parameter definitions see settingsInit.st	
	(* charge cooler 1st LT cooling circuit *)
	GK_var 			:= INT_TO_USINT(LIMIT(0, Para.iChC_OpMode,    2));		(* cooler mode (0-2)
																			0 = no cooler 
																			1 = cooler level dependent on valve position supply water temperature controller
																			2 = cooler level dependent on charge (supply water) temperature *)
	GK_anz			:= INT_TO_USINT(LIMIT(1, Para.iChC_NumStages, 16));		(* number stages total (1-16)*)
	Anz_GK_anfhbt	:= INT_TO_USINT(LIMIT(0, Para.iChC_NumDemAux, GK_anz));	(* number stages with demand auxiliaries (0-16)*)
	GK_reg			:= INT_TO_USINT(LIMIT(1, Para.iChC_CtrNum, 9));			(* number controller for y for 3-way valve (1-9) (mode 1) *) 
																			(* 1-8 = Ctr_Cust	plant controller - custom		*)
																			(*   9 = Ctr_ChC	charge temperature (t2') controller	*)

	(* charge cooler 2nd LT cooling circuit *)
	GK2_var 		:= INT_TO_USINT(LIMIT(0, Para.iChC2_OpMode,    22));	 (* cooler 2 fan operation mode (0-22)
																			 0	= LT circuits are connected, cooler fan controlled by 1st circuit (t2'), cooler 2 fan not connected
																			 11	= separate LT circuits, combi-cooler, cooler fan stage control for 2nd circuit dependent
																				  on temperature-control-valve position, cooler 2 fan not connected
																			 12	= separate LT circuits, combi-cooler, cooler fan stage control FOR 2nd circuit dependent
																				  on charge temperature (T1-HP), cooler 2 fan not connected
																			 21 = separate LT circuits, separate cooler fans, stage control dependent
																				  on temperature-control-valve position
																			 22 = separate LT circuits, separate cooler fans, stage control dependent
																				  on charge temperature (T1-HP) *)
	IF GK2_var > 20 THEN	(* separate 2nd charge cooler *)
		GK2_anz			:= INT_TO_USINT(LIMIT(1, Para.iChC2_NumStages, 16));	 	(* number stages total (1-16)*)
		Anz_GK2_anfhbt	:= INT_TO_USINT(LIMIT(0, Para.iChC2_NumDemAux, GK2_anz));	(* number stages with demand auxiliaries (0-16)*)
	ELSE					(* no 2nd charge cooler or combi-cooler *)
		GK2_anz			:= GK_anz;
		Anz_GK2_anfhbt	:= Anz_GK_anfhbt;
	END_IF;
	GK2_reg			:= INT_TO_USINT(LIMIT(1, Para.iChC2_CtrNum, 34));		 (* number controller for y for 3-way valve (1-8, 34)*) 
																			 (* 1-8 = Ctr_Cust		plant controller - custom		*)
																			 (*  34 = Ctr_ChC_T1HP	charge temperature before high-pressure turbo charger (T1-HP) controller	*)
												
	(*------------------------------------------------------------------------------------------*)		
	(* charge cooler pump *)
	OUT_HC.tChC_DemPump.Do		:= IN_HC.bEng_Aux_Dem_CDR 
								OR IN_HC.tManAuxCtr.bChC_DemPump;	(* Manual operating auxiliaries control - Handbedienebene *)
	OUT_HC.bCCWP_Dem			:= OUT_HC.tChC_DemPump.Do;
	
	(* charge cooler 2 pump *)
	OUT_HC.tChC2_DemPump.Do		:= IN_HC.bEng_Aux_Dem_CDR
								OR IN_HC.tManAuxCtr.bChC2_DemPump;	(* Manual operating auxiliaries control - Handbedienebene *)
	OUT_HC.bCC2WP_Dem			:= OUT_HC.tChC2_DemPump.Do;


	(* release charge cooler from monitoring (remove not applicable parts) *)
	IN_HC.bChC_Rel;
	IN_HC.bChC2_Rel;
	
	(*==========================================================================================*)
	(* charge cooler control - stepper version *)	
	IF GK_var > 0 THEN
		(* cooler stages ON/OFF according charge cooler mode *)
		(* if necessary change with limit value charge cooler water temperature *) 			
		bChC_Up   :=     bT_Ch_Hi2;
		bChC_Down := NOT bT_Ch_Hi1;	
		
		(*------------------------------------------------------------------------------------------*)
		IF GK_var > 1 THEN
			Temp_KuehlerAustritt := 1;
		ELSE
			Temp_KuehlerAustritt := 0;
		END_IF;
	
		GK_vent			:=	0;
		GK_temp			:=	0;
		IF Temp_KuehlerAustritt THEN
			GK_temp		:=	1;
		ELSIF Para.bCtr_ChC THEN
			GK_vent		:=	1;
		END_IF;
	
		IF	Anz_GK_anfhbt > 0 THEN
			GK_anfhbt	:=	1;
		ELSE
			GK_anfhbt	:=	0;
		END_IF;
	
		FOR	i:=	1 TO 16 BY 1 DO
			gk_anfhbt[i] :=	0;
		END_FOR;
		FOR	i:=	1 TO Anz_GK_anfhbt BY 1	DO
			gk_anfhbt[i] :=	1;
		END_FOR;
	
	
		(* number stages effective *)
		Anz_GK_st		:=	MIN(GK_anz - (MAX(Anz_GK_anfhbt, 1) - 1), 16);
	
		zw := 1;
		FOR i:=	1 TO Anz_GK_st BY 1	DO
			zw := zw * 2;
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
		Anz_GK_vent		:=	MIN(GK_anz, 16);
	
		zw := 1;
		FOR	i:=	1 TO Anz_GK_vent BY 1 DO
			zw := zw * 2;
		END_FOR;
	
		FA_INIT_2.Word	:=	UDINT_TO_UINT(zw - 1);
		FA_INIT_2;
		GK_ST_1			:=	FA_INIT_2.Bit00;
		GK_ST_2			:=	FA_INIT_2.Bit01;
		GK_ST_3			:=	FA_INIT_2.Bit02;
		GK_ST_4			:=	FA_INIT_2.Bit03;
		GK_ST_5			:=	FA_INIT_2.Bit04;
		GK_ST_6			:=	FA_INIT_2.Bit05;
		GK_ST_7			:=	FA_INIT_2.Bit06;
		GK_ST_8			:=	FA_INIT_2.Bit07;
		GK_ST_9			:=	FA_INIT_2.Bit08;
		GK_ST_10		:=	FA_INIT_2.Bit09;
		GK_ST_11		:=	FA_INIT_2.Bit10;
		GK_ST_12		:=	FA_INIT_2.Bit11;
		GK_ST_13		:=	FA_INIT_2.Bit12;
		GK_ST_14		:=	FA_INIT_2.Bit13;
		GK_ST_15		:=	FA_INIT_2.Bit14;
		GK_ST_16		:=	FA_INIT_2.Bit15;
	
	
	//	(* 3-way cooler valve *)
		CASE GK_reg OF										(* selection plant ctr # for 3-way valve (1-11) (cooler mode 1/3) *)
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
		xGRMax_Ventpos(Gw:= Para.rChC_ValPosLimHi_On, Hy:= Para.rChC_ValPosHyHi_On, In:= rValvePos);
	
		xTOF_GK_AUS.IN	:=	GK_vent AND xGRMax_Ventpos.Q AND IN_HC.tPB2MM.bParaSetupOk AND USINT_TO_BOOL(F_SPSR) OR
							GK_temp AND ((bChC_Up OR GK_EIN AND NOT bChC_Down) OR GK_EIN AND M_GKV2);
		xTOF_GK_AUS.PT 	:=  Para.tiChC_DelayOff; 
	    xTOF_GK_AUS();
	    
	    GK_EIN			:=	(xTOF_GK_AUS.Q OR GK_anfhbt) AND IN_HC.bEng_Aux_Dem_CDR AND IN_HC.bChC_Rel;
	                           
	    (*---------------------------------------------------------------------------*)
		(* cooler stages plus *)
		xGRMax_Ventpos2(Gw:= Para.rChC_ValPosLimStageUp, Hy:= 0.01, In:= rValvePos);
	    
		GK_PLUS			:= (GK_vent AND xGRMax_Ventpos2.Q AND IN_HC.tPB2MM.bParaSetupOk)
						OR (GK_temp AND bChC_Up);
	
	    (*---------------------------------------------------------------------------*)
		(* cooler stages minus *)
		xGRMin_Ventpos(Gw := Para.rChC_ValPosLimStageDown, Hy := 0.01, In := rValvePos);
	    
		GK_MINUS		:=((xGRMin_Ventpos.Q AND IN_HC.tPB2MM.bParaSetupOk AND GK_vent) OR (GK_temp AND bChC_Down))
					AND NOT GK_PLUS;    
	
	    (*---------------------------------------------------------------------------*)
		(* delay between stages ON *)
		xTOF_PLUS(IN:= plus, PT:= Para.tiChC_DelayStageUp);
		xR_TRIG_PLUS(CLK:= GK_PLUS AND NOT xTOF_PLUS.Q);
	
	    (*---------------------------------------------------------------------------*)
		(* delay between stages OFF *)
		xTOF_MINUS(IN:= minus, PT:= Para.tiChC_DelayStageDown);
		xR_TRIG_MINUS(CLK:=	GK_MINUS AND NOT xTOF_MINUS.Q);
	
	    (*---------------------------------------------------------------------------*)
		(* reset stage maschine *)
		IF	NOT GK_EIN	THEN
			schritt	:=	0;
		END_IF;
	
	
		(* state maschine *)
		CASE schritt OF	00:	(* cooler stopped *)
			FA_INIT_3.Word	:=	0;
			FA_INIT_3;
			M_GKV1			:=	FA_INIT_3.Bit00;
			M_GKV2			:=	FA_INIT_3.Bit01;
			M_GKV3			:=	FA_INIT_3.Bit02;
			M_GKV4			:=	FA_INIT_3.Bit03;
			M_GKV5			:=	FA_INIT_3.Bit04;
			M_GKV6			:=	FA_INIT_3.Bit05;
			M_GKV7			:=	FA_INIT_3.Bit06;
			M_GKV8			:=	FA_INIT_3.Bit07;
			M_GKV9			:=	FA_INIT_3.Bit08;
			M_GKV10			:=	FA_INIT_3.Bit09;
			M_GKV11			:=	FA_INIT_3.Bit10;
			M_GKV12			:=	FA_INIT_3.Bit11;
			M_GKV13			:=	FA_INIT_3.Bit12;
			M_GKV14			:=	FA_INIT_3.Bit13;
			M_GKV15			:=	FA_INIT_3.Bit14;
			M_GKV16			:=	FA_INIT_3.Bit15;
	
			(* ON 1.stage *)
			IF	GK_EIN	THEN
				schritt		:=	10;
			END_IF;
	
		10:	(* cooler stage 1 *)
			M_GKV1			:=	1;
			M_GKV2			:=	0;
			(* ON 2.stage *)
			IF	GK_PLUS AND(   (GK_temp AND bChC_Up AND xR_TRIG_PLUS.Q)
				            OR (GK_vent AND xGRMax_Ventpos2.Q)) THEN
				schritt		:=	20;
			END_IF;
	
		20:	(* cooler stage 2 *)
			M_GKV2			:=	1;
			M_GKV3			:=	0;
			(* ON 3.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_3	THEN
				schritt		:=	30;
			END_IF;
			(* OFF 3.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_3) THEN
				schritt		:=	10;
			END_IF;
	
		30:	(* cooler stage 3 *)
			M_GKV3			:=	1;
			M_GKV4			:=	0;
			(* ON 4.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_4	THEN
				schritt		:=	40;
			END_IF;
			(* OFF 3.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_4)	THEN
				schritt		:=	20;
			END_IF;
	
		40:	(* cooler stage 4 *)
			M_GKV4			:=	1;
			M_GKV5			:=	0;
			(* ON 5.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_5	THEN
				schritt		:=	50;
			END_IF;
			(* OFF 4.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_5) THEN
				schritt		:=	30;
			END_IF;
	
		50:	(* cooler stage 5 *)
			M_GKV5			:=	1;
			M_GKV6			:=	0;
			(* ON 6.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_6	THEN
				schritt		:=	60;
			END_IF;
			(* OFF 5.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_6) THEN
				schritt		:=	40;
			END_IF;
	
		60:	(* cooler stage 6 *)
			M_GKV6			:=	1;
			M_GKV7			:=	0;
			(* ON 7.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_7	THEN
				schritt		:=	70;
			END_IF;
			(* OFF 6.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_7) THEN
				schritt		:=	50;
			END_IF;
	
		70:	(* cooler stage 7 *)
			M_GKV7			:=	1;
			M_GKV8			:=	0;
			(* ON 8.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_8	THEN
				schritt		:=	80;
			END_IF;
			(* OFF 7.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_8) THEN
				schritt		:=	60;
			END_IF;
	
		80:	(* cooler stage 8 *)
			M_GKV8			:=	1;
			M_GKV9			:=	0;
			(* ON 9.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_9	THEN
				schritt		:=	90;
			END_IF;
			(* OFF 8.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_9) THEN
				schritt		:=	70;
			END_IF;
	
		90:	(* cooler stage 9 *)
			M_GKV9			:=	1;
			M_GKV10			:=	0;
			(* ON 10.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_10 THEN
				schritt		:=	100;
			END_IF;
			(* OFF 9.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_10)	THEN
				schritt		:=	80;
			END_IF;
	
		100:(* cooler stage 10 *)
			M_GKV10			:=	1;
			M_GKV11			:=	0;
			(* ON 11.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_11 THEN
				schritt		:=	110;
			END_IF;
			(* OFF 10.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_11)	THEN
				schritt		:=	90;
			END_IF;
	
		110:(* cooler stage 11 *)
			M_GKV11			:=	1;
			M_GKV12			:=	0;
			(* ON 12.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_12 THEN
				schritt		:=	120;
			END_IF;
			(* OFF 11.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_12)	THEN
				schritt		:=	100;
			END_IF;
	
		120:(* cooler stage 12 *)
			M_GKV12			:=	1;
			M_GKV13			:=	0;
			(* ON 13.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_13 THEN
				schritt		:=	130;
			END_IF;
			(* OFF 12.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_13)	THEN
				schritt		:=	110;
			END_IF;
	
		130:(* cooler stage 13 *)
			M_GKV13			:=	1;
			M_GKV14			:=	0;
			(* ON 14.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_14 THEN
				schritt		:=	140;
			END_IF;
			(* OFF 13.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_14)	THEN
				schritt		:=	120;
			END_IF;
	
		140:(* cooler stage 14 *)
			M_GKV14			:=	1;
			M_GKV15			:=	0;
			(* ON 15.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_15 THEN
				schritt		:=	150;
			END_IF;
			(* OFF 14.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_15)	THEN
				schritt		:=	130;
			END_IF;
	
		150:(* cooler stage 15 *)
			M_GKV15			:=	1;
			M_GKV16			:=	0;
			(* ON 16.stage *)
			IF	GK_PLUS AND xR_TRIG_PLUS.Q AND ST_16 THEN
				schritt		:=	160;
			END_IF;
			(* OFF 15.stage *)
			IF	GK_MINUS AND (xR_TRIG_MINUS.Q OR NOT ST_16)	THEN
				schritt		:=	140;
			END_IF;
	
		160:(* cooler stage 16 *)
			M_GKV16			:=	1;
			(* OFF 16.stage *)
			IF	GK_MINUS THEN
				schritt		:=	150;
			END_IF;
		END_CASE;
	
	
		(* charge cooler pump
		GKP_EIN				:=	M_GKV1; *)
	
	
		(* connection cooler stages to sequencing *)
		GK_ST1		:=	M_GKV1;
	
		GK_ST2		:=	M_GKV1 AND gk_anfhbt[2] OR
						M_GKV2;
	
		GK_ST3		:=	M_GKV1 AND gk_anfhbt[3] OR
						M_GKV2 AND gk_anfhbt[2] OR
						M_GKV3;
	
		GK_ST4		:=	M_GKV1 AND gk_anfhbt[4] OR
						M_GKV2 AND gk_anfhbt[3] OR
						M_GKV3 AND gk_anfhbt[2] OR
						M_GKV4;
	
		GK_ST5		:=	M_GKV1 AND gk_anfhbt[5] OR
						M_GKV2 AND gk_anfhbt[4] OR
						M_GKV3 AND gk_anfhbt[3] OR
						M_GKV4 AND gk_anfhbt[2] OR
						M_GKV5;
	
		GK_ST6		:=	M_GKV1 AND gk_anfhbt[6] OR
						M_GKV2 AND gk_anfhbt[5] OR
						M_GKV3 AND gk_anfhbt[4] OR
						M_GKV4 AND gk_anfhbt[3] OR
						M_GKV5 AND gk_anfhbt[2] OR
						M_GKV6;
	
		GK_ST7		:=	M_GKV1 AND gk_anfhbt[7] OR
						M_GKV2 AND gk_anfhbt[6] OR
						M_GKV3 AND gk_anfhbt[5] OR
						M_GKV4 AND gk_anfhbt[4] OR
						M_GKV5 AND gk_anfhbt[3] OR
						M_GKV6 AND gk_anfhbt[2] OR
						M_GKV7;
	
		GK_ST8		:=	M_GKV1 AND gk_anfhbt[8] OR
						M_GKV2 AND gk_anfhbt[7] OR
						M_GKV3 AND gk_anfhbt[6] OR
						M_GKV4 AND gk_anfhbt[5] OR
						M_GKV5 AND gk_anfhbt[4] OR
						M_GKV6 AND gk_anfhbt[3] OR
						M_GKV7 AND gk_anfhbt[2] OR
						M_GKV8;
	
		GK_ST9		:=	M_GKV1 AND gk_anfhbt[9] OR
						M_GKV2 AND gk_anfhbt[8] OR
						M_GKV3 AND gk_anfhbt[7] OR
						M_GKV4 AND gk_anfhbt[6] OR
						M_GKV5 AND gk_anfhbt[5] OR
						M_GKV6 AND gk_anfhbt[4] OR
						M_GKV7 AND gk_anfhbt[3] OR
						M_GKV8 AND gk_anfhbt[2] OR
						M_GKV9;
	
		GK_ST10		:=	M_GKV1 AND gk_anfhbt[10] OR
						M_GKV2 AND gk_anfhbt[9]  OR
						M_GKV3 AND gk_anfhbt[8]  OR
						M_GKV4 AND gk_anfhbt[7]  OR
						M_GKV5 AND gk_anfhbt[6]  OR
						M_GKV6 AND gk_anfhbt[5]  OR
						M_GKV7 AND gk_anfhbt[4]  OR
						M_GKV8 AND gk_anfhbt[3]  OR
						M_GKV9 AND gk_anfhbt[2]  OR
						M_GKV10;
	
		GK_ST11		:=	M_GKV1  AND gk_anfhbt[11] OR
						M_GKV2  AND gk_anfhbt[10] OR
						M_GKV3  AND gk_anfhbt[9]  OR
						M_GKV4  AND gk_anfhbt[8]  OR
						M_GKV5  AND gk_anfhbt[7]  OR
						M_GKV6  AND gk_anfhbt[6]  OR
						M_GKV7  AND gk_anfhbt[5]  OR
						M_GKV8  AND gk_anfhbt[4]  OR
						M_GKV9  AND gk_anfhbt[3]  OR
						M_GKV10 AND gk_anfhbt[2]  OR
						M_GKV11;
	
		GK_ST12		:=	M_GKV1  AND gk_anfhbt[12] OR
						M_GKV2  AND gk_anfhbt[11] OR
						M_GKV3  AND gk_anfhbt[10] OR
						M_GKV4  AND gk_anfhbt[9]  OR
						M_GKV5  AND gk_anfhbt[8]  OR
						M_GKV6  AND gk_anfhbt[7]  OR
						M_GKV7  AND gk_anfhbt[6]  OR
						M_GKV8  AND gk_anfhbt[5]  OR
						M_GKV9  AND gk_anfhbt[4]  OR
						M_GKV10 AND gk_anfhbt[3]  OR
						M_GKV11 AND gk_anfhbt[2]  OR
						M_GKV12;
	
		GK_ST13		:=	M_GKV1  AND gk_anfhbt[13] OR
						M_GKV2  AND gk_anfhbt[12] OR
						M_GKV3  AND gk_anfhbt[11] OR
						M_GKV4  AND gk_anfhbt[10] OR
						M_GKV5  AND gk_anfhbt[9]  OR
						M_GKV6  AND gk_anfhbt[8]  OR
						M_GKV7  AND gk_anfhbt[7]  OR
						M_GKV8  AND gk_anfhbt[6]  OR
						M_GKV9  AND gk_anfhbt[5]  OR
						M_GKV10 AND gk_anfhbt[4]  OR
						M_GKV11 AND gk_anfhbt[3]  OR
						M_GKV12 AND gk_anfhbt[2]  OR
						M_GKV13;
	
		GK_ST14		:=	M_GKV1  AND gk_anfhbt[14] OR
						M_GKV2  AND gk_anfhbt[13] OR
						M_GKV3  AND gk_anfhbt[12] OR
						M_GKV4  AND gk_anfhbt[11] OR
						M_GKV5  AND gk_anfhbt[10] OR
						M_GKV6  AND gk_anfhbt[9]  OR
						M_GKV7  AND gk_anfhbt[8]  OR
						M_GKV8  AND gk_anfhbt[7]  OR
						M_GKV9  AND gk_anfhbt[6]  OR
						M_GKV10 AND gk_anfhbt[5]  OR
						M_GKV11 AND gk_anfhbt[4]  OR
						M_GKV12 AND gk_anfhbt[3]  OR
						M_GKV13 AND gk_anfhbt[2]  OR
						M_GKV14;
	
		GK_ST15		:=	M_GKV1  AND gk_anfhbt[15] OR
						M_GKV2  AND gk_anfhbt[14] OR
						M_GKV3  AND gk_anfhbt[13] OR
						M_GKV4  AND gk_anfhbt[12] OR
						M_GKV5  AND gk_anfhbt[11] OR
						M_GKV6  AND gk_anfhbt[10] OR
						M_GKV7  AND gk_anfhbt[9]  OR
						M_GKV8  AND gk_anfhbt[8]  OR
						M_GKV9  AND gk_anfhbt[7]  OR
						M_GKV10 AND gk_anfhbt[6]  OR
						M_GKV11 AND gk_anfhbt[5]  OR
						M_GKV12 AND gk_anfhbt[4]  OR
						M_GKV13 AND gk_anfhbt[3]  OR
						M_GKV14 AND gk_anfhbt[2]  OR
						M_GKV15;
	
		GK_ST16		:=	M_GKV1  AND gk_anfhbt[16] OR
						M_GKV2  AND gk_anfhbt[15] OR
						M_GKV3  AND gk_anfhbt[14] OR
						M_GKV4  AND gk_anfhbt[13] OR
						M_GKV5  AND gk_anfhbt[12] OR
						M_GKV6  AND gk_anfhbt[11] OR
						M_GKV7  AND gk_anfhbt[10] OR
						M_GKV8  AND gk_anfhbt[9]  OR
						M_GKV9  AND gk_anfhbt[8]  OR
						M_GKV10 AND gk_anfhbt[7]  OR
						M_GKV11 AND gk_anfhbt[6]  OR
						M_GKV12 AND gk_anfhbt[5]  OR
						M_GKV13 AND gk_anfhbt[4]  OR
						M_GKV14 AND gk_anfhbt[3]  OR
						M_GKV15 AND gk_anfhbt[2]  OR
						M_GKV16;
	
	
		(* copy for summation *)
		GKST[1]		:=	BOOL_TO_USINT(M_GKV1);
		GKST[2]		:=	BOOL_TO_USINT(M_GKV2);
		GKST[3]		:=	BOOL_TO_USINT(M_GKV3);
		GKST[4]		:=	BOOL_TO_USINT(M_GKV4);
		GKST[5]		:=	BOOL_TO_USINT(M_GKV5);
		GKST[6]		:=	BOOL_TO_USINT(M_GKV6);
		GKST[7]		:=	BOOL_TO_USINT(M_GKV7);
		GKST[8]		:=	BOOL_TO_USINT(M_GKV8);
		GKST[9]		:=	BOOL_TO_USINT(M_GKV9);
		GKST[10]	:=	BOOL_TO_USINT(M_GKV10);
		GKST[11]	:=	BOOL_TO_USINT(M_GKV11);
		GKST[12]	:=	BOOL_TO_USINT(M_GKV12);
		GKST[13]	:=	BOOL_TO_USINT(M_GKV13);
		GKST[14]	:=	BOOL_TO_USINT(M_GKV14);
		GKST[15]	:=	BOOL_TO_USINT(M_GKV15);
		GKST[16]	:=	BOOL_TO_USINT(M_GKV16);
	
	
		(* ON/OFF coolerstage *)
		summe := 0;
		FOR i:=	1 TO 16 BY 1 DO
			summe := summe + GKST[i];
		END_FOR;
	
		plus :=	0;
		IF summe > summe_old THEN
			plus := 1;
		END_IF;
	
		minus := 0;
		IF summe < summe_old THEN
			minus := 1;
		END_IF;
	
		summe_old := summe;
	
	
	END_IF;


	(*==========================================================================================*)
	(* charge cooler 2 control - stepper version *)	
	IF GK2_var > 0 THEN
		(* cooler stages ON/OFF according charge cooler 2 mode *)
		(* if necessary change with limit value charge cooler 2 water temperature *) 			
		bChC2_Up   :=     bT_Ch2_Hi2;
		bChC2_Down := NOT bT_Ch2_Hi1;	
		
		(*------------------------------------------------------------------------------------------*)
		(* charge cooler 2 stage control mode *)
		GK2_vent			:=	0;
		GK2_temp			:=	0;
		IF (GK2_var MOD 10) = 2 THEN	(* via charge temperature T1-HP limits *)
			GK2_temp		:=	1;
		ELSIF (GK2_var MOD 10) = 1 AND Para.bCtr_ChC_T1HP THEN	(* via temperature-control-valve position *)
			GK2_vent		:=	1;
		END_IF;
	
		IF	Anz_GK2_anfhbt > 0 THEN
			GK2_anfhbt	:=	1;
		ELSE
			GK2_anfhbt	:=	0;
		END_IF;
	
		FOR	i:=	1 TO 16 DO
			IF i <= Anz_GK2_anfhbt THEN
				gk2_anfhbt[i] :=	1;
			ELSE
				gk2_anfhbt[i] :=	0;
			END_IF;
		END_FOR;
	
		(* number stages effective - charge cooler 2*)
		Anz_GK2_st		:=	MIN(GK2_anz - (MAX(Anz_GK2_anfhbt, 1) - 1), 16);
	
		zw := 1;
		FOR i:=	1 TO Anz_GK2_st BY 1	DO
			zw := zw * 2;
		END_FOR;
	
		FA2_INIT_1.Word	:=	UDINT_TO_UINT(zw - 1);
		FA2_INIT_1;
		ST2_1			:=	FA2_INIT_1.Bit00;
		ST2_2			:=	FA2_INIT_1.Bit01;
		ST2_3			:=	FA2_INIT_1.Bit02;
		ST2_4			:=	FA2_INIT_1.Bit03;
		ST2_5			:=	FA2_INIT_1.Bit04;
		ST2_6			:=	FA2_INIT_1.Bit05;
		ST2_7			:=	FA2_INIT_1.Bit06;
		ST2_8			:=	FA2_INIT_1.Bit07;
		ST2_9			:=	FA2_INIT_1.Bit08;
		ST2_10			:=	FA2_INIT_1.Bit09;
		ST2_11			:=	FA2_INIT_1.Bit10;
		ST2_12			:=	FA2_INIT_1.Bit11;
		ST2_13			:=	FA2_INIT_1.Bit12;
		ST2_14			:=	FA2_INIT_1.Bit13;
		ST2_15			:=	FA2_INIT_1.Bit14;
		ST2_16			:=	FA2_INIT_1.Bit15;
	
	
		(* enable cooler stages - charge cooler 2 *)
		Anz_GK2_vent		:=	MIN(GK2_anz, 16);
	
		zw := 1;
		FOR	i:=	1 TO Anz_GK2_vent BY 1 DO
			zw := zw * 2;
		END_FOR;
	
		FA2_INIT_2.Word	:=	UDINT_TO_UINT(zw - 1);
		FA2_INIT_2;
		GK2_ST_1			:=	FA2_INIT_2.Bit00;
		GK2_ST_2			:=	FA2_INIT_2.Bit01;
		GK2_ST_3			:=	FA2_INIT_2.Bit02;
		GK2_ST_4			:=	FA2_INIT_2.Bit03;
		GK2_ST_5			:=	FA2_INIT_2.Bit04;
		GK2_ST_6			:=	FA2_INIT_2.Bit05;
		GK2_ST_7			:=	FA2_INIT_2.Bit06;
		GK2_ST_8			:=	FA2_INIT_2.Bit07;
		GK2_ST_9			:=	FA2_INIT_2.Bit08;
		GK2_ST_10			:=	FA2_INIT_2.Bit09;
		GK2_ST_11			:=	FA2_INIT_2.Bit10;
		GK2_ST_12			:=	FA2_INIT_2.Bit11;
		GK2_ST_13			:=	FA2_INIT_2.Bit12;
		GK2_ST_14			:=	FA2_INIT_2.Bit13;
		GK2_ST_15			:=	FA2_INIT_2.Bit14;
		GK2_ST_16			:=	FA2_INIT_2.Bit15;
	
	
	//	(* 3-way cooler valve - charge cooler 2 *)
		CASE GK2_reg OF										(* selection plant ctr # for 3-way valve (1-11) (cooler mode 1/3) *)
			1:	F2_SPSR		:=	IN_HC.tCtr_Cust1_In.enable;	(* 1-8 = custom plant ctr - device temperature *)
				rValvePos2	:=	IN_HC.tCtr_Cust1_Out.Y;
				REG2_INVERT	:=	Para.tCtr_Cust1.invert;	
			2:	F2_SPSR		:=	IN_HC.tCtr_Cust2_In.enable;
				rValvePos2	:=	IN_HC.tCtr_Cust2_Out.Y;
				REG2_INVERT	:=	Para.tCtr_Cust2.invert;			
			3:	F2_SPSR		:=	IN_HC.tCtr_Cust3_In.enable;
				rValvePos2	:=	IN_HC.tCtr_Cust3_Out.Y;
				REG2_INVERT	:=	Para.tCtr_Cust3.invert;			
			4:	F2_SPSR		:=	IN_HC.tCtr_Cust4_In.enable;
				rValvePos2	:=	IN_HC.tCtr_Cust4_Out.Y;
				REG2_INVERT	:=	Para.tCtr_Cust4.invert;	
			5:	F2_SPSR		:=	IN_HC.tCtr_Cust5_In.enable;
				rValvePos2	:=	IN_HC.tCtr_Cust5_Out.Y;
				REG2_INVERT	:=	Para.tCtr_Cust5.invert;			
			6:	F2_SPSR		:=	IN_HC.tCtr_Cust6_In.enable;
				rValvePos2	:=	IN_HC.tCtr_Cust6_Out.Y;
				REG2_INVERT	:=	Para.tCtr_Cust6.invert;			
			7:	F2_SPSR		:=	IN_HC.tCtr_Cust7_In.enable;
				rValvePos2	:=	IN_HC.tCtr_Cust7_Out.Y;
				REG2_INVERT	:=	Para.tCtr_Cust7.invert;	
			8:	F2_SPSR		:=	IN_HC.tCtr_Cust8_In.enable;
				rValvePos2	:=	IN_HC.tCtr_Cust8_Out.Y;
				REG2_INVERT	:=	Para.tCtr_Cust8.invert;			
			34:	F2_SPSR		:=	tCtr_ChC_T1HP_In.enable;		(* 34   = charge temperature before high-pressure turbo charger (T1HP) controller *)
				rValvePos2	:=	tCtr_ChC_T1HP_Out.Y;
				REG2_INVERT	:=	Para.tCtr_ChC_T1HP.invert;				
			ELSE
				F2_SPSR		:=	FALSE;
				rValvePos2	:=	0.0;
				REG2_INVERT	:=	FALSE;			
		END_CASE;
			
		IF	NOT REG2_INVERT	THEN
			rValvePos2	:=	1.0 - rValvePos2;
		END_IF;
	
	    
	    (*---------------------------------------------------------------------------*)
		(* cooler 2 ON *)
		xGRMax2_Ventpos(Gw:= Para.rChC2_ValPosLimHi_On, Hy:= Para.rChC2_ValPosHyHi_On, In:= rValvePos2);
	
		xTOF_GK2_AUS.IN	:=	GK2_vent AND xGRMax2_Ventpos.Q AND IN_HC.tPB2MM.bParaSetupOk AND USINT_TO_BOOL(F2_SPSR) OR
							GK2_temp AND ((bChC2_Up OR GK2_EIN AND NOT bChC2_Down) OR GK2_EIN AND M_GK2V2);
		xTOF_GK2_AUS.PT :=  Para.tiChC2_DelayOff; 
	    xTOF_GK2_AUS();
	    
	    GK2_EIN			:=	(xTOF_GK2_AUS.Q OR GK2_anfhbt) AND IN_HC.bEng_Aux_Dem_CDR AND IN_HC.bChC2_Rel;
	                           
	    (*---------------------------------------------------------------------------*)
		(* cooler 2 stages plus *)
		xGRMax2_Ventpos2(Gw:= Para.rChC2_ValPosLimStageUp, Hy:= 0.01, In:= rValvePos2);
	    
		GK2_PLUS		:= (GK2_vent AND xGRMax2_Ventpos2.Q AND IN_HC.tPB2MM.bParaSetupOk)
						OR (GK2_temp AND bChC2_Up);
	
	    (*---------------------------------------------------------------------------*)
		(* cooler 2 stages minus *)
		xGRMin2_Ventpos(Gw := Para.rChC2_ValPosLimStageDown, Hy := 0.01, In := rValvePos2);
	    
		GK2_MINUS		:=((GK2_vent AND xGRMin2_Ventpos.Q AND IN_HC.tPB2MM.bParaSetupOk) OR (GK2_temp AND bChC2_Down))
					AND NOT GK2_PLUS;    
	
	    (*---------------------------------------------------------------------------*)
		(* delay between stages ON - charge cooler 2 *)
		xTOF_PLUS2(IN:= plus2, PT:= Para.tiChC2_DelayStageUp);
		xR_TRIG_PLUS2(CLK:= GK2_PLUS AND NOT xTOF_PLUS2.Q);
	
	    (*---------------------------------------------------------------------------*)
		(* delay between stages OFF - charge cooler 2 *)
		xTOF_MINUS2(IN:= minus2, PT:= Para.tiChC2_DelayStageDown);
		xR_TRIG_MINUS2(CLK:= GK2_MINUS AND NOT xTOF_MINUS2.Q);
	
	    (*---------------------------------------------------------------------------*)
		(* reset stage maschine - charge cooler 2 *)
		IF	NOT GK2_EIN	THEN
			schritt2	:=	0;
		END_IF;
	
	
		(* stage maschine - charge cooler 2 *)
		CASE schritt2 OF 00:	(* cooler 2 stopped *)
			FA2_INIT_3.Word	:=	0;
			FA2_INIT_3;
			M_GK2V1			:=	FA2_INIT_3.Bit00;
			M_GK2V2			:=	FA2_INIT_3.Bit01;
			M_GK2V3			:=	FA2_INIT_3.Bit02;
			M_GK2V4			:=	FA2_INIT_3.Bit03;
			M_GK2V5			:=	FA2_INIT_3.Bit04;
			M_GK2V6			:=	FA2_INIT_3.Bit05;
			M_GK2V7			:=	FA2_INIT_3.Bit06;
			M_GK2V8			:=	FA2_INIT_3.Bit07;
			M_GK2V9			:=	FA2_INIT_3.Bit08;
			M_GK2V10		:=	FA2_INIT_3.Bit09;
			M_GK2V11		:=	FA2_INIT_3.Bit10;
			M_GK2V12		:=	FA2_INIT_3.Bit11;
			M_GK2V13		:=	FA2_INIT_3.Bit12;
			M_GK2V14		:=	FA2_INIT_3.Bit13;
			M_GK2V15		:=	FA2_INIT_3.Bit14;
			M_GK2V16		:=	FA2_INIT_3.Bit15;
	
			(* ON 1.stage *)
			IF	GK2_EIN	THEN
				schritt2	:=	10;
			END_IF;
	
		10:	(* cooler 2 stage 1 *)
			M_GK2V1			:=	1;
			M_GK2V2			:=	0;
			(* ON 2.stage *)
			IF	GK2_PLUS AND(   (GK2_temp AND bChC2_Up AND xR_TRIG_PLUS2.Q)
				            OR (GK2_vent AND xGRMax2_Ventpos2.Q)) THEN
				schritt2	:=	20;
			END_IF;
	
		20:	(* cooler 2 stage 2 *)
			M_GK2V2			:=	1;
			M_GK2V3			:=	0;
			(* ON 3.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_3	THEN
				schritt2	:=	30;
			END_IF;
			(* OFF 3.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_3) THEN
				schritt2	:=	10;
			END_IF;
	
		30:	(* cooler 2 stage 3 *)
			M_GK2V3			:=	1;
			M_GK2V4			:=	0;
			(* ON 4.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_4	THEN
				schritt2	:=	40;
			END_IF;
			(* OFF 3.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_4)	THEN
				schritt2	:=	20;
			END_IF;
	
		40:	(* cooler 2 stage 4 *)
			M_GK2V4			:=	1;
			M_GK2V5			:=	0;
			(* ON 5.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_5	THEN
				schritt2	:=	50;
			END_IF;
			(* OFF 4.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_5) THEN
				schritt2	:=	30;
			END_IF;
	
		50:	(* cooler 2 stage 5 *)
			M_GK2V5			:=	1;
			M_GK2V6			:=	0;
			(* ON 6.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_6	THEN
				schritt2	:=	60;
			END_IF;
			(* OFF 5.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_6) THEN
				schritt2	:=	40;
			END_IF;
	
		60:	(* cooler 2 stage 6 *)
			M_GK2V6			:=	1;
			M_GK2V7			:=	0;
			(* ON 7.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_7	THEN
				schritt2	:=	70;
			END_IF;
			(* OFF 6.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_7) THEN
				schritt2	:=	50;
			END_IF;
	
		70:	(* cooler 2 stage 7 *)
			M_GK2V7			:=	1;
			M_GK2V8			:=	0;
			(* ON 8.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_8	THEN
				schritt2	:=	80;
			END_IF;
			(* OFF 7.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_8) THEN
				schritt2	:=	60;
			END_IF;
	
		80:	(* cooler 2 stage 8 *)
			M_GK2V8			:=	1;
			M_GK2V9			:=	0;
			(* ON 9.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_9	THEN
				schritt2	:=	90;
			END_IF;
			(* OFF 8.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_9) THEN
				schritt2	:=	70;
			END_IF;
	
		90:	(* cooler 2 stage 9 *)
			M_GK2V9			:=	1;
			M_GK2V10		:=	0;
			(* ON 10.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_10 THEN
				schritt2	:=	100;
			END_IF;
			(* OFF 9.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_10)	THEN
				schritt2	:=	80;
			END_IF;
	
		100:(* cooler 2 stage 10 *)
			M_GK2V10		:=	1;
			M_GK2V11		:=	0;
			(* ON 11.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_11 THEN
				schritt2	:=	110;
			END_IF;
			(* OFF 10.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_11)	THEN
				schritt2	:=	90;
			END_IF;
	
		110:(* cooler 2 stage 11 *)
			M_GK2V11		:=	1;
			M_GK2V12		:=	0;
			(* ON 12.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_12 THEN
				schritt2	:=	120;
			END_IF;
			(* OFF 11.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_12)	THEN
				schritt2	:=	100;
			END_IF;
	
		120:(* cooler 2 stage 12 *)
			M_GK2V12		:=	1;
			M_GK2V13		:=	0;
			(* ON 13.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_13 THEN
				schritt2	:=	130;
			END_IF;
			(* OFF 12.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_13)	THEN
				schritt2	:=	110;
			END_IF;
	
		130:(* cooler 2 stage 13 *)
			M_GK2V13		:=	1;
			M_GK2V14		:=	0;
			(* ON 14.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_14 THEN
				schritt2	:=	140;
			END_IF;
			(* OFF 13.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_14)	THEN
				schritt2	:=	120;
			END_IF;
	
		140:(* cooler 2 stage 14 *)
			M_GK2V14		:=	1;
			M_GK2V15		:=	0;
			(* ON 15.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_15 THEN
				schritt2	:=	150;
			END_IF;
			(* OFF 14.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_15)	THEN
				schritt2	:=	130;
			END_IF;
	
		150:(* cooler 2 stage 15 *)
			M_GK2V15		:=	1;
			M_GK2V16		:=	0;
			(* ON 16.stage *)
			IF	GK2_PLUS AND xR_TRIG_PLUS2.Q AND ST2_16 THEN
				schritt2	:=	160;
			END_IF;
			(* OFF 15.stage *)
			IF	GK2_MINUS AND (xR_TRIG_MINUS2.Q OR NOT ST2_16)	THEN
				schritt2	:=	140;
			END_IF;
	
		160:(* cooler 2 stage 16 *)
			M_GK2V16		:=	1;
			(* OFF 16.stage *)
			IF	GK2_MINUS THEN
				schritt2	:=	150;
			END_IF;
		END_CASE;
	
	
		(* charge cooler 2 pump
		GK2P_EIN			:=	M_GK2V1; *)
	
	
		(* connection cooler stages to sequencing - charge cooler 2 *)
		GK2_ST1		:=	M_GK2V1;
	
		GK2_ST2		:=	M_GK2V1 AND gk2_anfhbt[2] OR
						M_GK2V2;
	
		GK2_ST3		:=	M_GK2V1 AND gk2_anfhbt[3] OR
						M_GK2V2 AND gk2_anfhbt[2] OR
						M_GK2V3;
	
		GK2_ST4		:=	M_GK2V1 AND gk2_anfhbt[4] OR
						M_GK2V2 AND gk2_anfhbt[3] OR
						M_GK2V3 AND gk2_anfhbt[2] OR
						M_GK2V4;
	
		GK2_ST5		:=	M_GK2V1 AND gk2_anfhbt[5] OR
						M_GK2V2 AND gk2_anfhbt[4] OR
						M_GK2V3 AND gk2_anfhbt[3] OR
						M_GK2V4 AND gk2_anfhbt[2] OR
						M_GK2V5;
	
		GK2_ST6		:=	M_GK2V1 AND gk2_anfhbt[6] OR
						M_GK2V2 AND gk2_anfhbt[5] OR
						M_GK2V3 AND gk2_anfhbt[4] OR
						M_GK2V4 AND gk2_anfhbt[3] OR
						M_GK2V5 AND gk2_anfhbt[2] OR
						M_GK2V6;
	
		GK2_ST7		:=	M_GK2V1 AND gk2_anfhbt[7] OR
						M_GK2V2 AND gk2_anfhbt[6] OR
						M_GK2V3 AND gk2_anfhbt[5] OR
						M_GK2V4 AND gk2_anfhbt[4] OR
						M_GK2V5 AND gk2_anfhbt[3] OR
						M_GK2V6 AND gk2_anfhbt[2] OR
						M_GK2V7;
	
		GK2_ST8		:=	M_GK2V1 AND gk2_anfhbt[8] OR
						M_GK2V2 AND gk2_anfhbt[7] OR
						M_GK2V3 AND gk2_anfhbt[6] OR
						M_GK2V4 AND gk2_anfhbt[5] OR
						M_GK2V5 AND gk2_anfhbt[4] OR
						M_GK2V6 AND gk2_anfhbt[3] OR
						M_GK2V7 AND gk2_anfhbt[2] OR
						M_GK2V8;
	
		GK2_ST9		:=	M_GK2V1 AND gk2_anfhbt[9] OR
						M_GK2V2 AND gk2_anfhbt[8] OR
						M_GK2V3 AND gk2_anfhbt[7] OR
						M_GK2V4 AND gk2_anfhbt[6] OR
						M_GK2V5 AND gk2_anfhbt[5] OR
						M_GK2V6 AND gk2_anfhbt[4] OR
						M_GK2V7 AND gk2_anfhbt[3] OR
						M_GK2V8 AND gk2_anfhbt[2] OR
						M_GK2V9;
	
		GK2_ST10	:=	M_GK2V1 AND gk2_anfhbt[10] OR
						M_GK2V2 AND gk2_anfhbt[9]  OR
						M_GK2V3 AND gk2_anfhbt[8]  OR
						M_GK2V4 AND gk2_anfhbt[7]  OR
						M_GK2V5 AND gk2_anfhbt[6]  OR
						M_GK2V6 AND gk2_anfhbt[5]  OR
						M_GK2V7 AND gk2_anfhbt[4]  OR
						M_GK2V8 AND gk2_anfhbt[3]  OR
						M_GK2V9 AND gk2_anfhbt[2]  OR
						M_GK2V10;
	
		GK2_ST11	:=	M_GK2V1  AND gk2_anfhbt[11] OR
						M_GK2V2  AND gk2_anfhbt[10] OR
						M_GK2V3  AND gk2_anfhbt[9]  OR
						M_GK2V4  AND gk2_anfhbt[8]  OR
						M_GK2V5  AND gk2_anfhbt[7]  OR
						M_GK2V6  AND gk2_anfhbt[6]  OR
						M_GK2V7  AND gk2_anfhbt[5]  OR
						M_GK2V8  AND gk2_anfhbt[4]  OR
						M_GK2V9  AND gk2_anfhbt[3]  OR
						M_GK2V10 AND gk2_anfhbt[2]  OR
						M_GK2V11;
	
		GK2_ST12	:=	M_GK2V1  AND gk2_anfhbt[12] OR
						M_GK2V2  AND gk2_anfhbt[11] OR
						M_GK2V3  AND gk2_anfhbt[10] OR
						M_GK2V4  AND gk2_anfhbt[9]  OR
						M_GK2V5  AND gk2_anfhbt[8]  OR
						M_GK2V6  AND gk2_anfhbt[7]  OR
						M_GK2V7  AND gk2_anfhbt[6]  OR
						M_GK2V8  AND gk2_anfhbt[5]  OR
						M_GK2V9  AND gk2_anfhbt[4]  OR
						M_GK2V10 AND gk2_anfhbt[3]  OR
						M_GK2V11 AND gk2_anfhbt[2]  OR
						M_GK2V12;
	
		GK2_ST13	:=	M_GK2V1  AND gk2_anfhbt[13] OR
						M_GK2V2  AND gk2_anfhbt[12] OR
						M_GK2V3  AND gk2_anfhbt[11] OR
						M_GK2V4  AND gk2_anfhbt[10] OR
						M_GK2V5  AND gk2_anfhbt[9]  OR
						M_GK2V6  AND gk2_anfhbt[8]  OR
						M_GK2V7  AND gk2_anfhbt[7]  OR
						M_GK2V8  AND gk2_anfhbt[6]  OR
						M_GK2V9  AND gk2_anfhbt[5]  OR
						M_GK2V10 AND gk2_anfhbt[4]  OR
						M_GK2V11 AND gk2_anfhbt[3]  OR
						M_GK2V12 AND gk2_anfhbt[2]  OR
						M_GK2V13;
	
		GK2_ST14	:=	M_GK2V1  AND gk2_anfhbt[14] OR
						M_GK2V2  AND gk2_anfhbt[13] OR
						M_GK2V3  AND gk2_anfhbt[12] OR
						M_GK2V4  AND gk2_anfhbt[11] OR
						M_GK2V5  AND gk2_anfhbt[10] OR
						M_GK2V6  AND gk2_anfhbt[9]  OR
						M_GK2V7  AND gk2_anfhbt[8]  OR
						M_GK2V8  AND gk2_anfhbt[7]  OR
						M_GK2V9  AND gk2_anfhbt[6]  OR
						M_GK2V10 AND gk2_anfhbt[5]  OR
						M_GK2V11 AND gk2_anfhbt[4]  OR
						M_GK2V12 AND gk2_anfhbt[3]  OR
						M_GK2V13 AND gk2_anfhbt[2]  OR
						M_GK2V14;
	
		GK2_ST15	:=	M_GK2V1  AND gk2_anfhbt[15] OR
						M_GK2V2  AND gk2_anfhbt[14] OR
						M_GK2V3  AND gk2_anfhbt[13] OR
						M_GK2V4  AND gk2_anfhbt[12] OR
						M_GK2V5  AND gk2_anfhbt[11] OR
						M_GK2V6  AND gk2_anfhbt[10] OR
						M_GK2V7  AND gk2_anfhbt[9]  OR
						M_GK2V8  AND gk2_anfhbt[8]  OR
						M_GK2V9  AND gk2_anfhbt[7]  OR
						M_GK2V10 AND gk2_anfhbt[6]  OR
						M_GK2V11 AND gk2_anfhbt[5]  OR
						M_GK2V12 AND gk2_anfhbt[4]  OR
						M_GK2V13 AND gk2_anfhbt[3]  OR
						M_GK2V14 AND gk2_anfhbt[2]  OR
						M_GK2V15;
	
		GK2_ST16	:=	M_GK2V1  AND gk2_anfhbt[16] OR
						M_GK2V2  AND gk2_anfhbt[15] OR
						M_GK2V3  AND gk2_anfhbt[14] OR
						M_GK2V4  AND gk2_anfhbt[13] OR
						M_GK2V5  AND gk2_anfhbt[12] OR
						M_GK2V6  AND gk2_anfhbt[11] OR
						M_GK2V7  AND gk2_anfhbt[10] OR
						M_GK2V8  AND gk2_anfhbt[9]  OR
						M_GK2V9  AND gk2_anfhbt[8]  OR
						M_GK2V10 AND gk2_anfhbt[7]  OR
						M_GK2V11 AND gk2_anfhbt[6]  OR
						M_GK2V12 AND gk2_anfhbt[5]  OR
						M_GK2V13 AND gk2_anfhbt[4]  OR
						M_GK2V14 AND gk2_anfhbt[3]  OR
						M_GK2V15 AND gk2_anfhbt[2]  OR
						M_GK2V16;
	
	
		(* copy for summation - charge cooler 2 *)
		GK2ST[1]	:=	BOOL_TO_USINT(M_GK2V1);
		GK2ST[2]	:=	BOOL_TO_USINT(M_GK2V2);
		GK2ST[3]	:=	BOOL_TO_USINT(M_GK2V3);
		GK2ST[4]	:=	BOOL_TO_USINT(M_GK2V4);
		GK2ST[5]	:=	BOOL_TO_USINT(M_GK2V5);
		GK2ST[6]	:=	BOOL_TO_USINT(M_GK2V6);
		GK2ST[7]	:=	BOOL_TO_USINT(M_GK2V7);
		GK2ST[8]	:=	BOOL_TO_USINT(M_GK2V8);
		GK2ST[9]	:=	BOOL_TO_USINT(M_GK2V9);
		GK2ST[10]	:=	BOOL_TO_USINT(M_GK2V10);
		GK2ST[11]	:=	BOOL_TO_USINT(M_GK2V11);
		GK2ST[12]	:=	BOOL_TO_USINT(M_GK2V12);
		GK2ST[13]	:=	BOOL_TO_USINT(M_GK2V13);
		GK2ST[14]	:=	BOOL_TO_USINT(M_GK2V14);
		GK2ST[15]	:=	BOOL_TO_USINT(M_GK2V15);
		GK2ST[16]	:=	BOOL_TO_USINT(M_GK2V16);
	
	
		(* ON/OFF coolerstage *)
		summe2 := 0;
		FOR i:=	1 TO 16 BY 1 DO
			summe2 := summe2 + GK2ST[i];
		END_FOR;
	
		plus2 :=	0;
		IF summe2 > summe2_old THEN
			plus2 := 1;
		END_IF;
	
		minus2 := 0;
		IF summe2 < summe2_old THEN
			minus2 := 1;
		END_IF;
	
		summe2_old := summe2;
	
	
	END_IF;


	(*----------------------------------------------------------------------------*)
	(* BEL Standard *)
	(* demand heating charge cooler ventilation  *)
	OUT_HC.tChC_Heating.Do := ((NOT bT_AirOutdoor_Hi1 AND Para.bT_AirOutdoor_Active)
								 OR IN_HC.tManAuxCtr.bChC_Heating)		(* Manual operating auxiliaries control - Handbedienebene *)
							AND	NOT IN_HC.bMsg1031
							AND NOT IN_HC.bMsg1053
							AND NOT IN_HC.bMsg1054;

	OUT_HC.tChC2_Heating.Do :=((NOT bT_AirOutdoor_Hi1 AND Para.bT_AirOutdoor_Active)
								 OR IN_HC.tManAuxCtr.bChC2_Heating)	(* Manual operating auxiliaries control - Handbedienebene *)
							AND	NOT IN_HC.bMsg1031
							AND NOT IN_HC.bMsg1053
							AND NOT IN_HC.bMsg1054;
	(*----------------------------------------------------------------------------*)
	
END_PROGRAM
