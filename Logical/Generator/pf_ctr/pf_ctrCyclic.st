(*******************************************************************************
pf_ctr - power factor control
		 power reduction due to voltage or frequency deviation

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
0.10	30-05-2008	Gfˆller,	generated
		10-02-2009	Gfˆller,	calculation for Q- limit rQ_LIM added
		11-02-2009	Gfˆller,	calculation of limit added
		07-04-2009	Gfˆller,	correction of scale of external limit
2.50.1	23-06-2009  Wasserer+Le	redesign, var7 customized connection, correction of limitations 
		01-07-2009	lettenb.	f_deltaU_PROM added (bewertung U-abweichung) 
2.60.0 12.08.2009	lettenb.	pf_contr rename to pf_ctr, task QP_red included into pf_ctr
								PFSollext, ssPFext1-3fix, selPFext1-3fix added (from pf_cust)
					Tinello		delete Para.rPF_CosPCtr_Ext_Pnt1 and ssPf_P2 from Init / changed reg8 into reg13
					lettenb.	power reduction by winding temperature: calc.error corr.
		14.10.2009				OUT_GC.rPF_GenCtr_Act:=1000 if IN_GC.gcb=off for controller X display 
3.20.0	30.09.2010	Maier(BuR)	GS_EIN replaced with IN_GC.bGCB_On
3.30.0  10.10.2011	lettenb.	ssPowRedGenTemp: not active in case of M_MSGWT(sensor failure)
		28.10.2011	Tinello		usFreqNenn[1] / 10 --> parameter "nominal frequency" was increased by factor 10
		04.11.2011	lettenb.	M_MS_PFset added (limit PFset in case of MS)
4.02.0	14.05.2014	lettenb.	xTON_ErregAusf: Para.tiPF_CosPCtr_del --> Para.rTi_Q_MinDel, visu new version!
4.02.1	19.05.2014	lettenb.	control mode 4: scaling changed, bugfix
		27.05.2014	lettenb.	2156, 2157: MM2VIS.bMsg215x -> bMsg215x, moved TO MsgGC	
		12.06.2014				set PFSoll_lin TO cosphi 1.0 in CASE OF MS failure, bugfix
		26.09.2014				ramp FOR u/f/T-gen.Pred changed acc.xt3 behavior
4.02.2  28.10.2014	lettenb.	rT_Gen_Wind_Max: > --> >= reduction interrupts IF 2 gen.wind.temp.are equal
		03.11.2014				cap.PF reduction, limitation PF reduction, bugfix
4.04.0	01.08.2016				cosphi limits removed -> 0.0 underexcited - 1 - 0.0 overexcited, Q_Set_AVR -> UNITROL (//LE)
4.05.0  30.11.2017	lettenb.	GR redesign, PF control -> Q control, write parameter removed(code guide line)
4.07.0	17.12.2018	lettenb.	Qlimitation by under voltage added
		22.05.2019	lettenb.	Qlimitation by gen.wind.temp.high, enable manuell settings with active rQ_Lim_T_GenWind, bugfix
4.09.0	18.11.2019	lettenb.	rU_Gen_Nom_2 substituted by  rU_Gen_Nom[1], rU_Gen_Nom_2 removed, (gridcode/lukas)
4.14.0	29.11.2024	Farre,		calculation of power reduction due to CosPhi <1, from OP to GC (issue #1700)

Instructions for use:
--------------------


Description:
------------
Q-control:
pf_ctr:
power reduction by under- or over voltage enabled
power reduction by under- or over frequency
power reduction by winding temperature high
power factor limitation by winding temperature high
power factor limitation by polar wheel angel
calculation of reactive power limit for loss of excitation(A1109)
selection point of control
pf_set from timetable GC -> GR: OUT_GC.rPF_Set_TimeTable
limiter out: rQ_Set_Lim -> pf_cust

pf_cust:
summation Q_set + Ctr_Q_out.y
generation operation status depending setpoints (idle mode, synch-mode, island volt.control)
operation status depending selection of setpoint 
scaling for V/mA AO for old AVR (PF_set signal)
scaling for V    AO for UNITROL (Q_set)

Outstandings:
------------
*********************************************************************************)
PROGRAM _CYCLIC
	
	(* begin program - QP reduction *)
	
	(* calculation of nominal power in parts per thousand *)
	rP_Gen_ppt	:= 1.000;
	
	(* power reduction by under- or over voltage enabled *)
	IF xOpMode.NetP AND Para.bPF_CosPCtr_U_Ena THEN
		
		(* calculation of voltage in parts per thousand HIGHER RESOLUTION FOR LOW VOLTAGE *)
		IF Para.rU_Gen_Nom[1] <> 0.0 AND Para.rU_Gen_Nom[1] <= 1000 THEN
			rU_AI_Gen_Avg_ppt	:= IN_GC.tU_Avg[1].Ai / Para.rU_Gen_Nom[1];
		
			(* scaling low voltage *)
			xSigScal_SpgRedLow(X:= rU_AI_Gen_Avg_ppt, X1:= Para.rPF_CosPCtr_U_Lo_End, Y1:= Para.rP_CosPCtr_U_Lo, X2:= Para.rPF_CosPCtr_U_Lo_Start, Y2:= 1.00);
			(* scaling high voltage *)
			xSigScal_SpgRedHigh(X:= rU_AI_Gen_Avg_ppt, X1:= Para.rPF_CosPCtr_U_Hi_Start, Y1:= 1.00,	X2:= Para.rPF_CosPCtr_U_Hi_End, Y2:= Para.rP_CosPCtr_U_Hi);
	
		END_IF;

		(* calculation of voltage in parts per thousand *)
		IF Para.rU_Gen_Nom[1] <> 0.0 AND Para.rU_Gen_Nom[1] > 1000 THEN
			rU_AI_Gen_Avg_ppt	:= IN_GC.tU_Avg[1].Ai / Para.rU_Gen_Nom[1];
		
			(* scaling low voltage *)
			xSigScal_SpgRedLow(X:= rU_AI_Gen_Avg_ppt, X1:= Para.rPF_CosPCtr_U_Lo_End, Y1:= Para.rP_CosPCtr_U_Lo, X2:= Para.rPF_CosPCtr_U_Lo_Start, Y2:= 1.00);
			(* scaling high voltage *)
			xSigScal_SpgRedHigh(X:= rU_AI_Gen_Avg_ppt, X1:= Para.rPF_CosPCtr_U_Hi_Start, Y1:= 1.00,	X2:= Para.rPF_CosPCtr_U_Hi_End,	Y2:= Para.rP_CosPCtr_U_Hi);

		END_IF;

		(* reduction active *)	
		IF xSigScal_SpgRedLow.Y_SCAL < 1.00 THEN			(* power reduction by low voltage *)
			rP_CosPCtr_U_Red           := xSigScal_SpgRedLow.Y_SCAL;
			OUT_GC.bP_Red_CosPCtr_U_Lo := TRUE;
		ELSIF xSigScal_SpgRedHigh.Y_SCAL < 1.00 THEN		(* power reduction by high voltage *)
			rP_CosPCtr_U_Red           := xSigScal_SpgRedHigh.Y_SCAL;
			OUT_GC.bP_Red_CosPCtr_U_Hi := TRUE;
		ELSE
			rP_CosPCtr_U_Red	       := 1.00;
			OUT_GC.bP_Red_CosPCtr_U_Lo := FALSE;
			OUT_GC.bP_Red_CosPCtr_U_Hi := FALSE;			
		END_IF;	
	ELSE
		rP_CosPCtr_U_Red	       := 1.00;
		OUT_GC.bP_Red_CosPCtr_U_Lo := FALSE;
		OUT_GC.bP_Red_CosPCtr_U_Hi := FALSE;
 	END_IF;	


	
	(* power reduction by under- or over frequency enabled *)
	IF (xOpMode.NetP) THEN	(* function for frequency too low always enabled *)

		(* calculation of frequency in parts per thousand *)
		IF Para.rF_Nom[1] > 0.0 THEN
			rF_Gen_ppt	:= IN_GC.tF_MMD[1].Ai / Para.rF_Nom[1];
		END_IF;

		(* frequency too low *) 
		xSigScal_FrqRedLow(X:= rF_Gen_ppt, X1:= Para.rPF_CosPCtr_F_Lo_End, Y1:= Para.rP_CosPCtr_F_Lo, X2:= Para.rPF_CosPCtr_F_Lo_Start, Y2:= 1.00);
		(* frequency too high *) 
		IF Para.bPF_CosPCtr_F_Ena THEN		(* function for frequency too high enabled by parameter *)
			xSigScal_FrqRedHigh(X:= rF_Gen_ppt, X1:= Para.rPF_CosPCtr_F_Hi_Start, Y1:= 1.00, X2:= Para.rPF_CosPCtr_F_Hi_End, Y2:= Para.rP_CosPCtr_F_Hi);
		END_IF;

		(* reduction active *)	
		IF xSigScal_FrqRedLow.Y_SCAL < rP_Gen_ppt THEN								        (* power reduction by low frequency *)
			rP_CosPCtr_F_Red           := xSigScal_FrqRedLow.Y_SCAL;
			OUT_GC.bP_Red_CosPCtr_F_Lo := TRUE;
		ELSIF Para.bPF_CosPCtr_F_Ena AND xSigScal_FrqRedHigh.Y_SCAL < rP_Gen_ppt THEN		(* power reduction by high frequency *)
			rP_CosPCtr_F_Red           := xSigScal_FrqRedHigh.Y_SCAL;
			OUT_GC.bP_Red_CosPCtr_F_Hi := TRUE;
		ELSE
			rP_CosPCtr_F_Red    := 1.00;
			OUT_GC.bP_Red_CosPCtr_F_Lo := FALSE;
			OUT_GC.bP_Red_CosPCtr_F_Hi := FALSE;
		END_IF;	

		(* hysteresis window for over frequency *)
		IF ((IN_GC.tF_MMD[1].Ai > Para.rF_Nom[1]) AND Para.bPF_CosPCtr_F_Ena) THEN	(* frequency higher than nominal frequency *)
  			IF rF_Gen_ppt > Para.rPF_CosPCtr_F_Hi_Start THEN		(* frequency higher than limit for over frequency *)
				IF rP_CosPCtr_F_Red < ssPowRedFrqMin THEN
					ssPowRedFrqMin := rP_CosPCtr_F_Red;		(* remember minimum power *)
				END_IF
			END_IF

			IF rF_Gen_ppt < Para.rPF_CosPCtr_F_ret THEN		(* frequency returns to normal frequency *)
	  			ssPowRedFrqMin := 1.00;
			END_IF
			
			rP_CosPCtr_F_Red := ssPowRedFrqMin;
		END_IF
	ELSE
		rP_CosPCtr_F_Red	       := 1.00;
		OUT_GC.bP_Red_CosPCtr_F_Lo := FALSE;
		OUT_GC.bP_Red_CosPCtr_F_Hi := FALSE;
 	END_IF;


	(* power factor limitation by winding temperature high *)
	IF Para.bT_Gen_Wind_Ena THEN		(* monitoring only when PT100 for winding temperature are used *)
		(* determination of maximum winding temperature *)
		IF 		((IN_GC.tT_Gen_Wind_Act_L1.Ai >= IN_GC.tT_Gen_Wind_Act_L2.Ai) 
			AND  (IN_GC.tT_Gen_Wind_Act_L1.Ai >= IN_GC.tT_Gen_Wind_Act_L3.Ai) 
			AND   IN_GC.tT_Gen_Wind_Act_L1.GoodQual) THEN
  			rT_Gen_Wind_Max := IN_GC.tT_Gen_Wind_Act_L1.Ai;
		ELSIF  ((IN_GC.tT_Gen_Wind_Act_L2.Ai >= IN_GC.tT_Gen_Wind_Act_L1.Ai) 
			AND (IN_GC.tT_Gen_Wind_Act_L2.Ai >= IN_GC.tT_Gen_Wind_Act_L3.Ai)
			AND  IN_GC.tT_Gen_Wind_Act_L2.GoodQual) THEN
  			rT_Gen_Wind_Max := IN_GC.tT_Gen_Wind_Act_L2.Ai;
		ELSIF  ((IN_GC.tT_Gen_Wind_Act_L3.Ai >= IN_GC.tT_Gen_Wind_Act_L1.Ai)
			AND (IN_GC.tT_Gen_Wind_Act_L3.Ai >= IN_GC.tT_Gen_Wind_Act_L2.Ai)
			AND IN_GC.tT_Gen_Wind_Act_L3.GoodQual) THEN
			rT_Gen_Wind_Max := IN_GC.tT_Gen_Wind_Act_L3.Ai;
		ELSE	
			rT_Gen_Wind_Max := 0.0;
		END_IF
		
		IF Para.bPF_CosPCtr_Ena THEN		(* if power factor controller is enabled *)		
			(* reduction of power factor by winding temperature *)
			IF rT_Gen_Wind_Max  >= Para.rPF_CosPCtr_T_max AND Para.rPF_CosPCtr_T_red > 0.0 THEN
				IF NOT bPF_Once THEN
					ssPF_Begin	:= IN_GC.tPF_Act[1].Ai; (* value: -0.7 bis -1.0 = cap., 0.7 bis 1.0 = ind *) 
	   				bPF_Once := TRUE;
				END_IF;
			
				IF ssPF_Begin >= 0 THEN	(* ind *) 
					rPF_CosPCtr_T_Lim := ssPF_Begin + ((rT_Gen_Wind_Max - Para.rPF_CosPCtr_T_max) * Para.rPF_CosPCtr_T_red);
					IF rPF_CosPCtr_T_Lim > 1.0 THEN	rPF_CosPCtr_T_Lim := 1.0;(* limit calculation to PF = 1 *)
					END_IF;
				ELSE	                (* cap *) 
					rPF_CosPCtr_T_Lim := ssPF_Begin - ((rT_Gen_Wind_Max - Para.rPF_CosPCtr_T_max) * Para.rPF_CosPCtr_T_red); 
					IF rPF_CosPCtr_T_Lim < -1.0 THEN rPF_CosPCtr_T_Lim := 1.0;(* limit calculation to PF = 1 *)
					END_IF;
				END_IF;
					
			ELSE
				bPF_Once := FALSE;
				IF IN_GC.tPF_Act[1].Ai > 0.0 THEN rPF_CosPCtr_T_Lim :=  0.001; (* no limit for PF *)//LE
				ELSE                              rPF_CosPCtr_T_Lim := -0.001;
				END_IF;
			END_IF;
		ELSE
			IF IN_GC.tPF_Act[1].Ai > 0.0 THEN rPF_CosPCtr_T_Lim :=  0.001; (* no limit for PF *)//LE
			ELSE                              rPF_CosPCtr_T_Lim := -0.001;
			END_IF;
		END_IF;

		(* power reduction by winding temperature *)	
		IF rT_Gen_Wind_Max >= Para.rP_CosPCtr_T_Hi AND rT_Gen_Wind_Max  <> 0 THEN
			rP_CosPCtr_T_Red := 1.00 - ((rT_Gen_Wind_Max - Para.rP_CosPCtr_T_Hi) * Para.rPF_CosPCtr_T_wind); 
		ELSE
			rP_CosPCtr_T_Red := 1.00;
		END_IF	
	ELSE
		rP_CosPCtr_T_Red := 1.00;
	END_IF

	
	rP_CosPCtr_U_Red := LIMIT(0.50, rP_CosPCtr_U_Red, 1.00);
	rP_CosPCtr_F_Red := LIMIT(0.50, rP_CosPCtr_F_Red, 1.00);
	rP_CosPCtr_T_Red := LIMIT(0.50, rP_CosPCtr_T_Red, 1.00);

	(* calculation of power reduction *)	
	IF IN_GC.rP_Nom <> 0.0 THEN
		
		(* generator voltage *)
		IF rP_CosPCtr_U_Red < 1.00 THEN
	 		rP_CosPCtr_U_Red := (IN_GC.rP_Nom - ((1.00-rP_CosPCtr_U_Red) * IN_GC.rP_Nom / 1.00)) / IN_GC.rP_Nom;
		ELSE
			rP_CosPCtr_U_Red := IN_GC.rP_Nom / IN_GC.rP_Nom;
		END_IF;
			
		(* generator frequency *)
		IF rP_CosPCtr_F_Red < 1.00 THEN
	 		rP_CosPCtr_F_Red := (IN_GC.rP_Nom - ((1.00-rP_CosPCtr_F_Red) * IN_GC.rP_Nom / 1.00)) / IN_GC.rP_Nom;
		ELSE
			rP_CosPCtr_F_Red := IN_GC.rP_Nom / IN_GC.rP_Nom;
		END_IF;
	
		(* generator winding temperature *)
		IF rP_CosPCtr_T_Red < 1.00 THEN
	 		rP_CosPCtr_T_Red := (IN_GC.rP_Nom - ((1.00-rP_CosPCtr_T_Red) * IN_GC.rP_Nom / 1.00))/ IN_GC.rP_Nom;
		ELSE
			rP_CosPCtr_T_Red := IN_GC.rP_Nom / IN_GC.rP_Nom;
		END_IF;
		
	ELSE
		(* Set lowest value in case of a rP_Nom value is zero *)
		rP_CosPCtr_T_Red := 0.5;
		rP_CosPCtr_F_Red := 0.5;
		rP_CosPCtr_U_Red := 0.5;
	END_IF;
		

	(* smoother transition *)
	xRAMPE_RedGenSpg(enable:= IN_GC.tGCB_On.Di, In:= rP_CosPCtr_U_Red, Rise:= 0.007, Sink:= 0.007, TC_Time:= 100);(* 0.007: 100->50% ca.35" *)
	xRAMPE_RedGenSpg();
	rP_CosPCtr_U_Red	:= xRAMPE_RedGenSpg.Out;
	
	xRAMPE_RedGenFrq(enable:= IN_GC.tGCB_On.Di, In:= rP_CosPCtr_F_Red, Rise:= 0.007, Sink:= 0.007, TC_Time:= 100);
	xRAMPE_RedGenFrq();
	rP_CosPCtr_F_Red  := xRAMPE_RedGenFrq.Out;
	
	xRAMPE_RedGenTemp(enable:= IN_GC.tGCB_On.Di, In:= rP_CosPCtr_T_Red, Rise:= 0.007, Sink:= 0.007, TC_Time:= 100);
	xRAMPE_RedGenTemp();
	rP_CosPCtr_T_Red	:= xRAMPE_RedGenTemp.Out;


(*-----------------------------------------------------------------------------------*)
	(* CALCULATION OF REACTIVE POWER LIMIT - polar wheel angle                       *)
	(* calculation of auxiliary variables for reactive power *)	
	bU_Gen_Norm := IN_GC.tEng_Run.Do AND IN_GC.tGCB_On.Di AND NOT IN_GC.tGen_Exc_Off.Di;
	IF bU_Gen_Norm AND NOT (IN_GC.bTP_GrC_Event AND (IN_GC.tU_Avg[1].Ai < (Para.rU_Gen_Nom[1] * 0.5))) THEN
		rFact1	:= IN_GC.tU_Avg[1].Ai * IN_GC.tU_Avg[1].Ai * Para.rS_Nom;		
	ELSE
		rFact1	:= Para.rU_Gen_Nom[1] * Para.rU_Gen_Nom[1] * Para.rS_Nom;
 	END_IF;			
	rFact2	:= Para.rU_Gen_Nom[1] * Para.rU_Gen_Nom[1];


	(* calculation of reactive power limitation of polar wheel angle (Polradwinkel)  *)
	rDeltaRAD	:= Para.rAng_CosPCtr_Lim / (180.0 / rCnst_PI);	(* conversion in radian measure (Bogenmaﬂ) *)
	IF 	TAN(rDeltaRAD) <> 0 AND (Para.rxd_CosPCtr * rFact2) <> 0 THEN	(* avoid zero division *)
		rAng_CosPCtr_LimCalc := IN_GC.tP_Act[1].Ai / TAN(rDeltaRAD) - rFact1 / (Para.rxd_CosPCtr * rFact2);	
		
		rPF_CosPCtr_MinCalc1 := 0.0 / TAN(rDeltaRAD) - rFact1 / (Para.rxd_CosPCtr * rFact2);		
		rPF_CosPCtr_MinCalc2 := IN_GC.rP_Nom / TAN(rDeltaRAD) - rFact1 / (Para.rxd_CosPCtr * rFact2);
	END_IF;
	
	(* calculation of reactive power limitation for LOSS OF EXCITATION  *)
	rDelta_TripRAD	:= Para.rAng_CosPCtr_Min / (180.0 / rCnst_PI);	(* conversion in radian measure (Bogenmaﬂ) *)
	IF 	TAN(rDelta_TripRAD) <> 0 AND (Para.rxd_CosPCtr * rFact2) <> 0 THEN	(* avoid zero division *)
		rAng_CosPCtr_MinCalc := IN_GC.tP_Act[1].Ai  / TAN(rDelta_TripRAD) - rFact1 / (Para.rxd_CosPCtr * rFact2);
		
		rPF_CosPCtr_LimCalc1 := 0.0 / TAN(rDelta_TripRAD) - rFact1 / (Para.rxd_CosPCtr * rFact2);
		rPF_CosPCtr_LimCalc2 := IN_GC.rP_Nom / TAN(rDelta_TripRAD) - rFact1 / (Para.rxd_CosPCtr * rFact2);		
	END_IF;

	IF rAng_CosPCtr_LimCalc <= rAng_CosPCtr_MinCalc THEN
 		rAng_CosPCtr_LimCalc :=	rAng_CosPCtr_MinCalc;
	END_IF;
	

	(* LOSS OF EXCITATION AMM 1109 *)
	xTON_ErregAusf.IN := (IN_GC.tQ_Act[1].Ai  < rAng_CosPCtr_MinCalc) AND IN_GC.tPB2MM.bParaSetupOk; (* generator reactive power > limit value *)
	xTON_ErregAusf.PT := REAL_TO_TIME(Para.rTi_Q_MinDel[1] *1000); (* 0.1sec * 1000 = ms *)
	xTON_ErregAusf();

	bPF_CosPCtr_Trip	:= xTON_ErregAusf.Q; (* delay loss of excitation *)
	

	(* END CALCULATION OF REACTIVE POWER LIMIT 			END CALCULATION OF REACTIVE POWER LIMIT  *)
	(* ==================================================================================================== *)		

	(*-----------------------------------------------------------------------------------*)
	(* CALCULATION OF REACTIVE POWER LIMIT by under voltage *)
	(* calculation of auxiliary variables for reactive power *)
//			Para.bQ_UnderExc_Ena
//	Uact	IN_GC.tU_Avg[1].Ai			[V]
//	Qmin1	Para.rQ_UnderExc_Lim 	-27	[%]
//	Umin1	Para.rQ_UnderExc_Start	95	[%]
//	Umin2	Para.rQ_UnderExc_Stop	90	[%]
//	Qmin2	Para.rQ_UnderExc_Lim2	0	[%]  Qmin2 have to be higher then Qmin
	IF Para.rU_Gen_Nom[1] > 0.0 THEN rUact := IN_GC.tU_Avg[1].Ai / Para.rU_Gen_Nom[1];
	END_IF;

	IF    rUact > Para.rQ_UnderExc_Start THEN rQmin_U := Para.rQ_UnderExc_Lim;
	ELSIF rUact < Para.rQ_UnderExc_Stop  THEN rQmin_U := MAX(Para.rQ_UnderExc_Lim2, Para.rQ_UnderExc_Lim);(* Qmin2 have to be higher then Qmin *)
	ELSE  xSigScal_Qlim_Ulow(X:= rUact, X1:= Para.rQ_UnderExc_Start, Y1:= Para.rQ_UnderExc_Lim, X2:= Para.rQ_UnderExc_Stop, Y2:= MAX(Para.rQ_UnderExc_Lim2, Para.rQ_UnderExc_Lim));
		  rQmin_U := xSigScal_Qlim_Ulow.Y_SCAL;(* U too low *) 
//		  rUact_Umin2 := rUact - Para.rQ_UnderExc_Stop;(* for testing *)
//		  rUmin1_Umin2 := ABS(Para.rQ_UnderExc_Start) - ABS(Para.rQ_UnderExc_Stop);
//		  rQmin2_Qmin1 := ABS(Para.rQ_UnderExc_Lim2) - ABS(Para.rQ_UnderExc_Lim);
//		  rQmin_U := (rUact_Umin2 * (rQmin2_Qmin1 / rUmin1_Umin2)) + Para.rQ_UnderExc_Lim2; (*[%]*)		
	END_IF;



//	(* END CALCULATION OF REACTIVE POWER LIMIT 			END CALCULATION OF REACTIVE POWER LIMIT  *)
//	(* ==================================================================================================== *)		

	
		
	(* ==================================================================================================== *)		
	(* SELECTION POINT OF CONTROL                                                                           *)
       (* defines the point of control for Q, PF or U *)
	(*  0:	customized AI *)		  
	(*  1:	MMU1 generator *)
	(*	2:	MMU2 point of connection *)
	(*  3:  direct control *)

		CASE Para.iQ_GrC_PointCtrl OF
			0:	rS_POC_Act  := IN_GC.rS_POC_Act_Cust;	(* customized/c_statGR *)
				rP_POC_Act  := IN_GC.rP_POC_Act_Cust;
				rQ_POC_Act  := IN_GC.rQ_POC_Act_Cust;
				rPF_POC_Act	:= IN_GC.rPF_POC_Act_Cust;
				rU_POC_Act  := 0;						(* not used *)

			1:	rS_POC_Act  := IN_GC.tS_Act[1].Ai;		(* MMU1/generator *)
				rP_POC_Act  := IN_GC.tP_Act[1].Ai;
				rQ_POC_Act  := IN_GC.tQ_Act[1].Ai;
				rPF_POC_Act	:= IN_GC.tPF_Act[1].Ai;
				rU_POC_Act  := IN_GC.tU_Avg[1].Ai; 
				
			2:	rS_POC_Act  := IN_GC.tS_Act[2].Ai;		(* MMU2/point of connection *)
				rP_POC_Act  := IN_GC.tP_Act[2].Ai;
				rQ_POC_Act  := IN_GC.tQ_Act[2].Ai;
				rPF_POC_Act	:= IN_GC.tPF_Act[1].Ai;
				rU_POC_Act  := IN_GC.tU_Avg[2].Ai; 

		    3:	rS_POC_Act  := IN_GC.tS_Act[1].Ai;		(* MMU1/generator *)
				rP_POC_Act  := IN_GC.tP_Act[1].Ai;
				rQ_POC_Act  := IN_GC.tQ_Act[1].Ai;
				rPF_POC_Act	:= IN_GC.tPF_Act[1].Ai;
				rU_POC_Act  := IN_GC.tU_Avg[1].Ai; 
		
				ELSE
				rS_POC_Act  := 0;
				rP_POC_Act  := 0;
				rQ_POC_Act  := 0;
				rPF_POC_Act	:= 1;
				rU_POC_Act  := 0;
		END_CASE;

				
		IF xOpMode.NetP AND Para.rS_Nom > 0 AND IN_GC.rP_Nom > 0 AND Para.rS_Nom > IN_GC.rP_Nom THEN
			rS_POC_Act_Norm := rS_POC_Act / Para.rS_Nom;
			rP_POC_Act_Norm := rP_POC_Act / IN_GC.rP_Nom;
			rQ_POC_Act_Norm := rQ_POC_Act / Para.rS_Nom;
		END_IF;


		(* linearization rPF_POC_Act *)
		(* +0,7(ind/overexc.)..1,0..-0,7(cap/underexc.) ==> 0,70 .. 1,00 .. 1,30 *)	
		//Filterung des Cos(PHI) Signals
		IF rPF_POC_Act >= 0 THEN rPF_Act_lin := rPF_POC_Act;
		ELSE					 rPF_Act_lin := rPF_POC_Act + 2.000;
		END_IF;
		xFILTER_PF(In := rPF_Act_lin, Filter := 10);
	
		MM2VIS.rPF_POC_Act_lin	:= xFILTER_PF.Out;


		(* diagram Y(graph)-value point of control (POC)*)
		IF Para.rS_Nom > 0 THEN
			MM2VIS.rQS_POC := rQ_POC_Act / Para.rS_Nom;
		END_IF;
				
		
		(* ==================================================================================================== *)		
		(* selection of set point by time table from parameters -> GR *)
		(*
		time frame 1		begin- hour 1/ begin- minute 1	till	stop- hour 1/ stop- minute 1
							stop- hour 2/ stop- minute 2 := begin- hour 1/ begin- minute 1
		time frame 2		begin- hour 2/ begin- minute 2	till	stop- hour 2/ stop- minute 2
							stop- hour 3/ stop- minute 3 := begin- hour 2/ begin- minute 2
	.
		. *)
		(* getting time of the controller *)
		DTGetTime_RPS.enable := TRUE;							(* getting *)
		DTGetTime_RPS();										
		DT_TO_DTStructure(DTGetTime_RPS.DT1, ADR(tRealTime));	(* change format *)
		DTGetTime_RPS.status;
			
									
		IF  tRealTime.hour >= REAL_TO_USINT(Para.rPF_CosPCtr_h[0]) AND tRealTime.minute >= REAL_TO_USINT(Para.rPF_CosPCtr_m[0]) THEN
			rPF_TimeAct := Para.rPF_CosPCtr_Tme_Set[0];
		END_IF
		IF  tRealTime.hour >= REAL_TO_USINT(Para.rPF_CosPCtr_h[1]) AND tRealTime.minute >= REAL_TO_USINT(Para.rPF_CosPCtr_m[1]) THEN
			rPF_TimeAct := Para.rPF_CosPCtr_Tme_Set[1];
		END_IF
		IF  tRealTime.hour >= REAL_TO_USINT(Para.rPF_CosPCtr_h[2]) AND tRealTime.minute >= REAL_TO_USINT(Para.rPF_CosPCtr_m[2]) THEN
			rPF_TimeAct := Para.rPF_CosPCtr_Tme_Set[2];
		END_IF
		IF  tRealTime.hour >= REAL_TO_USINT(Para.rPF_CosPCtr_h[3]) AND tRealTime.minute >= REAL_TO_USINT(Para.rPF_CosPCtr_m[3]) THEN
			rPF_TimeAct := Para.rPF_CosPCtr_Tme_Set[3];
		END_IF
		IF  tRealTime.hour >= REAL_TO_USINT(Para.rPF_CosPCtr_h[4]) AND tRealTime.minute >= REAL_TO_USINT(Para.rPF_CosPCtr_m[4]) THEN
			rPF_TimeAct := Para.rPF_CosPCtr_Tme_Set[4];
		END_IF
		IF  tRealTime.hour >= REAL_TO_USINT(Para.rPF_CosPCtr_h[5]) AND tRealTime.minute >= REAL_TO_USINT(Para.rPF_CosPCtr_m[5]) THEN
			rPF_TimeAct := Para.rPF_CosPCtr_Tme_Set[5];
		END_IF

		OUT_GC.rPF_Set_TimeTable := rPF_TimeAct;	(* GC -> GR *)(* + = overexited/ind., - = underexited/cap. *)


		(* Limited rQSoll_Lim_GR2GC from GR -> GC *)
		IN_GC.rQSoll_Lim_GR2GC;		(* including limitation from Q(U) and QLim_Ext *)

		
		
	(* ==================================================================================================== *)		
	(* Q limit by winding temperature *)
		(* umrechnung rPF_CosPCtr_T_Lim -> rQ_Lim_T_GenWind[%] *)		
		IF Para.bT_Gen_Wind_Ena AND Para.bPF_CosPCtr_Ena AND xOpMode.NetP AND IN_GC.rP_Act_Norm_Filt > 0.10 AND rPF_CosPCtr_T_Lim <> 0.000 THEN	
			IF    rPF_CosPCtr_T_Lim > 0.000 THEN rQ_Lim_T_GenWind :=        IN_GC.rP_Act_Norm_Filt * 0.8 * (SQRT(1 / (rPF_CosPCtr_T_Lim * rPF_CosPCtr_T_Lim) -1));
			ELSIF rPF_CosPCtr_T_Lim < 0.000 THEN rQ_Lim_T_GenWind := (-1) * IN_GC.rP_Act_Norm_Filt * 0.8 * (SQRT(1 / (rPF_CosPCtr_T_Lim * rPF_CosPCtr_T_Lim) -1));		
			END_IF;
		ELSE 
			IF IN_GC.rQSoll_Lim_GR2GC >= 0.0 THEN rQ_Lim_T_GenWind :=  1.0;
			ELSE                                  rQ_Lim_T_GenWind := -1.0;
			END_IF;
		END_IF;
		
		
		(*------------------------------------------------------------------------------------------------------*)	
		(* Q-limit by polar wheel angle *)
		(* umrechnung Q_Lim_PWA[kVAr] -> rQ_Lim_PWA[%] *)
		IF Para.rS_Nom > 0 AND xOpMode.NetP AND IN_GC.rP_Act_Norm_Filt > 0.10 THEN
			rQ_Lim_PWA := rAng_CosPCtr_LimCalc / Para.rS_Nom;                      (* pos. = uebererregt = ind.Q-abgabe/plant *)
 		ELSE																	   (* neg. = untererregt = kap.Q-abgabe/plant *)
			rQ_Lim_PWA := -1.0;
		END_IF;		

		
		(*------------------------------------------------------------------------------------------------------*)	
		(* Q-limit by under voltage (under excitation) *)
		IF Para.bQ_UnderExc_Ena AND xOpMode.NetP AND IN_GC.rP_Act_Norm_Filt > 0.10 THEN
			rQ_Lim_U := rQmin_U;(* [%] *)
 		ELSE																	   (* neg. = untererregt = kap.Q-abgabe/plant *)
			rQ_Lim_U := -1.0;
		END_IF;	
		(*------------------------------------------------------------------------------------------------------*)
		(* LIMITER *)
		rQ_Set_Lim        := IN_GC.rQSoll_Lim_GR2GC; (* limiter in *)

		IF    bPF_Once AND ABS(IN_GC.rQSoll_Lim_GR2GC) > ABS(rQ_Lim_T_GenWind) THEN rQ_Set_Lim := rQ_Lim_T_GenWind;(* ind./overexcited/+kVAr *)
			bMsg2156   := TRUE; 		   (* B2156 Q-limit by gen.wind.temp.*)
		ELSIF bPF_Once AND ABS(IN_GC.rQSoll_Lim_GR2GC) < ABS(rQ_Lim_T_GenWind) THEN rQ_Set_Lim := IN_GC.rQSoll_Lim_GR2GC;
			bMsg2156   := TRUE; 		   (* B2156 Q-limit by gen.wind.temp.*)
		ELSE  					                                          bMsg2156   := FALSE;	
		END_IF;		
	
		
		IF IN_GC.tPF_Act[1].Ai < 0.0 AND IN_GC.rQSoll_Lim_GR2GC < rQ_Lim_PWA AND rQ_Set_Lim < rQ_Lim_PWA
																	 THEN rQ_Set_Lim := rQ_Lim_PWA;      (* cap./underexcited/-kVAr *)				
																		  bMsg2157   := TRUE;            (* B2157 Q-limit by polar wheel angel *)
		ELSE		                                                      bMsg2157   := FALSE;
		END_IF;
		

		IF IN_GC.tPF_Act[1].Ai < 0.0 AND IN_GC.rQSoll_Lim_GR2GC < rQ_Lim_U AND rQ_Set_Lim < rQ_Lim_U
																	 THEN rQ_Set_Lim := rQ_Lim_U;        (* cap./underexcited/-kVAr *)				
																		  bMsg2998   := TRUE;            (* B2998 Q-limit by under voltage *)
		ELSE		                                                      bMsg2998   := FALSE;
		END_IF;



		rQ_Set_Lim;	(* limiter out -> pf_Cust *)
			
		MM2VIS.bQ_Lim_On := MM2VIS.bSel_AVR_Set AND    (IN_GC.bQSetLim	(*GR*)
		                							OR  bMsg2156	    (*GC*)
		                							OR  bMsg2157	    (*GC*)
		                							OR  bMsg2998);	    (*GC*)
	

		(*------------------------------------------------------------------------------------------------------*)
		(*** GC-> OP: Power Reduction CosPhi < 1 ***)
			IF IN_GC.tPF_Act[1].Ai < 0.98 AND IN_GC.tPF_Act[1].Ai > 0 AND IN_GC.rP_Act_Norm_Filt > 0.25 AND IN_GC.tPB2MM.bParaSetupOk AND Para.rEta_Gen_PF08 < Para.rEta_Gen_PF1 AND IN_GC.tGCB_On.Di THEN
				IF Para.rEta_Gen_PF1 <> 0 THEN
					rP_Red_Eta_Gen_Norm_int :=	(IN_GC.tPF_Act[1].Ai - 0.8) / (0.98 - 0.8)
										*	(1.0 - Para.rEta_Gen_PF08 / Para.rEta_Gen_PF1)
										+	Para.rEta_Gen_PF08 / Para.rEta_Gen_PF1;
		
				ELSE
					rP_Red_Eta_Gen_Norm_int := 1.0;	
				END_IF	
			ELSE
				rP_Red_Eta_Gen_Norm_int 	:= 1.0;
			END_IF
			
			xTON_rPRed(IN := (rP_Red_Eta_Gen_Norm_int < 1.0), PT := tDelayPRed);
			IF xTON_rPRed.Q THEN
				OUT_GC.rP_Red_Eta_Gen_Norm 	:= rP_Red_Eta_Gen_Norm_int;
			ELSE
				OUT_GC.rP_Red_Eta_Gen_Norm 	:= 1.0;		
			END_IF;
		(*------------------------------------------------------------------------------------------------------*)

				
	(* ==================================================================================================== *)		
	(* Werte f¸r Regler und Anzeigen *)
	(* ==================================================================================================== *)		
	
	RPS_s_oldQPF_XT := USINT_TO_UINT(tRealTime.second);
	
	OUT_GC.rP_Red_CosPCtr_F_Norm := rP_CosPCtr_F_Red;
	OUT_GC.rP_Red_CosPCtr_T_Norm := rP_CosPCtr_T_Red;
	OUT_GC.rP_Red_CosPCtr_U_Norm := rP_CosPCtr_U_Red;
	
	
END_PROGRAM
