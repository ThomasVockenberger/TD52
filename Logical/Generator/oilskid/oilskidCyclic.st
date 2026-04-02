(*******************************************************************************
OilSkid	 				Oil Skid (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------

History:
-------
V3.50	07.01.2014	Tinello 	created
		14.11.2014	Tinello		update TO NEW spezi
V4.x	05.12.2014	Walid Mari 	ported into XT4 
V4.03.0	24.06.2015	lettenb.	bT_RelOilSkidPumpC: hy for oiltemp.limit circulation pump added
		18.09.2015				demand oilskid for N2 scavenging + ignition selftest added
		21.10.2015				xTOF_PrelubeDem: lag run time added
V4.05.0	04.04.2017	lettenb.	fast start added
V4.05.1	04.04.2018				bRelEngStart_OilSkid interface prepared for series
V4.05.2	25.04.2018	lettenb.	IN_GC.bOilskidDemSTFS demand for slowturn removed, SWAT920/5
V4.07.0 29.11.2018	lettenb.	preheating temp.limits 30/40->40/50°C
		12.02.2019	lettenb.	2505,3428,3431 depending on oil tank temp. OR oil supply temp.
								2508,3446 enable at engine shutdown
V4.07.1 08.04.2019				OUT_GC.tOilSkid_Heater.Do: bN_EngAct_IsZero removed, heater is active until set temp.is reached(krainz, alessio)
		30.07.2019	lettenb.	error condition for OilSkid: 1031 added, corr.for iCnt_OilSkid_HP_PrErr(safety request, doujak andreas) bu01
V4.10.0	03.08.2020	lettenb.	OUT_interfaces for op_state(bEng_Bloc) added
		14.12.2020	lettenb.	TON,TOF reset added to avoid time overrun, cleanup

Instructions FOR use:
--------------------

Description:
------------

Outstandings:
------------

(*******************************************************************************)
PROGRAM _CYCLIC	

	(*----------------------------------------------*)
	(* RESET of alarms and warnings 				*)
	(*----------------------------------------------*)
	bAMM_Lev_OilSkid_Sump_Hi		:= FALSE;

	bAMM_Lev_OilSkid_Tank_Ms 		:= FALSE;
	bAMM_Lev_OilSkid_Tank_Lo 		:= FALSE;
	bAMM_Lev_OilSkid_Tank_LoLo 		:= FALSE;

	bAMM_T_OilSkid_Tank_Ms 			:= FALSE;
	bAMM_T_OilSkid_Tank_Lo 			:= FALSE;

	bAMM_T_OilSkid_Supply_Ms 		:= FALSE;
	bAMM_T_OilSkid_Supply_Lo 		:= FALSE;
	bAMM_T_OilSkid_Supply_Hi 		:= FALSE;

	bAMM_Flow_OilSkid_DE_Ms 		:= FALSE;
	bAMM_Flow_OilSkid_DE_Lo 		:= FALSE;
	bAMM_Flow_OilSkid_DE_Hi 		:= FALSE;

	bAMM_Flow_OilSkid_NDE_Ms 		:= FALSE;
	bAMM_Flow_OilSkid_NDE_Lo 		:= FALSE;
	bAMM_Flow_OilSkid_NDE_Hi 		:= FALSE;

	bAMM_Pr_OilSkid_HP_DE_Ms		:= FALSE;
	bAMM_Pr_OilSkid_HP_DE_Lo 		:= FALSE;

	bAMM_Pr_OilSkid_HP_NDE_Ms		:= FALSE;
	bAMM_Pr_OilSkid_HP_NDE_Lo 		:= FALSE;

	bAMM_OilSkid_PumpC_CB			:= FALSE;
	bAMM_DPr_OilSkid_FiltLP_Hi 		:= FALSE;
	bAMM_DPr_OilSkid_FiltHP_DE_Hi 	:= FALSE;
	bAMM_DPr_OilSkid_FiltHP_NDE_Hi 	:= FALSE;

	bAMM_OilSkid_PumpLP_CB 			:= FALSE;
	bAMM_OilSkid_PumpHP_CB 			:= FALSE;
	bAMM_OilSkid_PumpHP_CB_UPS 		:= FALSE;
	bAMM_OilSkid_Fan_CB 			:= FALSE;
	bAMM_OilSkid_Heater_CB 			:= FALSE;

	bAMM_OilSkid_MCB 				:= FALSE;
	bAMM_OilSkid_AuxV 				:= FALSE;
	bAMM_OilSkid_AuxV_UPS 			:= FALSE;


	(*----------------------------------------------*)
	(* RESET of IO's								*)
	(*----------------------------------------------*)
	OUT_GC.tOilSkid_Fan.Do			:= FALSE;
	OUT_GC.tOilSkid_Heater.Do		:= FALSE;						
	OUT_GC.tOilSkid_PumpLP.Do		:= FALSE;						
	OUT_GC.tOilSkid_PumpHP.Do		:= FALSE;					
	OUT_GC.tOilSkid_PumpHP_UPS.Do	:= FALSE;					
	OUT_GC.tOilSkid_PumpHP_Soft.Do	:= FALSE;					
	OUT_GC.tOilSkid_PumpC.Do		:= FALSE;						


	IF Para.bOilSkid_Exist AND IN_GC.tPB2MM.bParaSetupOk  THEN
		(****************************************************************************************************************************************)
		(* monitoring																															*)
		(****************************************************************************************************************************************)
		xTON_PumpLP_10s(IN:= MM2VIS.bOilSkid_PumpLP_Dem, PT:= T#10s); 								(* LP pump runs for 10 seconds *)
		xTON_PumpHP_5s(IN := MM2VIS.bOilSkid_PumpHP_Dem, PT:= T#5s); 								(* HP pump runs for 5 seconds *)


		(*----------------------------------------------*)	
		(* error by DI									*)
		(*----------------------------------------------*)	
		bAMM_Lev_OilSkid_Sump_Hi		:=  NOT IN_GC.tLev_OilSkid_Sump_Hi.Di; 										(* G.03-LS-001  *)	(* W3418 *)
		bAMM_DPr_OilSkid_FiltLP_Hi 		:=  NOT IN_GC.tDPr_OilSkid_FiltLP_Hi.Di										(* G.03-PDS-001 *)	(* W2505 *)
										AND 	xTON_PumpLP_10s.Q
										AND   ((bRelMon_T_Supply AND IN_GC.tT_OilSkid_Supply.Ai > 55) OR (bRelMon_T_Tank AND IN_GC.tT_OilSkid_Tank.Ai > 55));

		IF (IN_GC.rN_EngAct < 500 AND IN_GC.rN_EngAct > 100 AND NOT IN_GC.bEng_RPSDem) THEN
			bAMM_DPr_OilSkid_FiltHP_DE_Hi  := NOT IN_GC.tDPr_OilSkid_FiltHP_DE_Hi.Di  AND MM2VIS.bOilSkid_PumpHP_Dem;(* G.03-PDS-002 *) (* W2508 *) 
			bAMM_DPr_OilSkid_FiltHP_NDE_Hi := NOT IN_GC.tDPr_OilSkid_FiltHP_NDE_Hi.Di AND MM2VIS.bOilSkid_PumpHP_Dem;(* G.03-PDS-003 *) (* W3446 *)
		END_IF;

		bAMM_OilSkid_PumpLP_CB 			:= NOT IN_GC.tOilSkid_PumpLP_CBOk.Di;															(* W3426 *)
		bAMM_OilSkid_PumpHP_CB 			:= NOT IN_GC.tOilSkid_PumpHP_CBOk.Di;															(* W3433 *)
		bAMM_OilSkid_PumpHP_CB_UPS 		:= NOT IN_GC.tOilSkid_PumpHP_CBOk_UPS.Di;														(* W3434 *)
		bAMM_OilSkid_Fan_CB 			:= NOT IN_GC.tOilSkid_Fan_CBOk.Di; 																(* W3437 *)
		bAMM_OilSkid_Heater_CB 			:= NOT IN_GC.tOilSkid_Heater_CBOk.Di;															(* W3438 *)
		bAMM_OilSkid_PumpC_CB			:= NOT IN_GC.tOilSkid_PumpC_CBOk.Di;															(* W3447 *)

		bAMM_OilSkid_MCB 				:= NOT IN_GC.tOilSkid_MCB.Di;																	(* W3439 *)
		bAMM_OilSkid_AuxV 				:= NOT IN_GC.tOilSkid_AuxV_Ok.Di		AND NOT bAMM_OilSkid_PumpHP_CB  						(* W3440 *)
																				AND NOT bAMM_OilSkid_MCB;
		bAMM_OilSkid_AuxV_UPS 			:= NOT IN_GC.tOilSkid_AuxV_Ok_UPS.Di	AND NOT bAMM_OilSkid_PumpHP_CB_UPS;						(* W3441 *)
	
			bErr_OilSkid_NoVoltage		:= bAMM_OilSkid_MCB OR bAMM_OilSkid_AuxV;

		(*----------------------------------------------*)	
		(* error by measurement signal failure 			*)
		(*----------------------------------------------*)	
		bAMM_Lev_OilSkid_Tank_Ms	:= Para.bLev_OilSkid_Tank_Exist 	AND NOT IN_GC.tLev_OilSkid_Tank.GoodQual;						(* W3419 *)
		bAMM_T_OilSkid_Tank_Ms		:= Para.bT_OilSkid_Tank_Exist 		AND NOT IN_GC.tT_OilSkid_Tank.GoodQual;							(* W3421 *)
		bAMM_T_OilSkid_Supply_Ms	:= Para.bT_OilSkid_Supply_Exist 	AND NOT IN_GC.tT_OilSkid_Supply.GoodQual;						(* W3423 *)
		bAMM_Flow_OilSkid_DE_Ms		:= Para.bFlow_OilSkid_DE_Exist 		AND NOT IN_GC.tFlow_OilSkid_DE.GoodQual;						(* W3427 *)
		bAMM_Flow_OilSkid_NDE_Ms	:= Para.bFlow_OilSkid_NDE_Exist 	AND NOT IN_GC.tFlow_OilSkid_NDE.GoodQual;						(* W3430 *)
		bAMM_Pr_OilSkid_HP_DE_Ms	:= Para.bPr_OilSkid_HP_DE_Exist 	AND NOT IN_GC.tPr_OilSkid_HP_DE.GoodQual;						(* W3435 *)
		bAMM_Pr_OilSkid_HP_NDE_Ms	:= Para.bPr_OilSkid_HP_NDE_Exist 	AND NOT IN_GC.tPr_OilSkid_HP_NDE.GoodQual;						(* W3442 *)


			(* Release monitoring	*)
			xTOF_AMM_Lev_Tank_Ms(IN := bAMM_Lev_OilSkid_Tank_Ms, 	PT:= T#10s);	(* TOF because of filtered signals *)	
			xTOF_AMM_T_Tank_Ms(IN 	:= bAMM_T_OilSkid_Tank_Ms, 	 	PT:= T#10s);
			xTOF_AMM_T_Supply_Ms(IN := bAMM_T_OilSkid_Supply_Ms, 	PT:= T#10s);
			xTOF_AMM_Flow_DE_Ms(IN 	:= bAMM_Flow_OilSkid_DE_Ms, 	PT:= T#10s);
			xTOF_AMM_Flow_NDE_Ms(IN := bAMM_Flow_OilSkid_NDE_Ms, 	PT:= T#10s);
			xTOF_Pr_HP_DE_Ms(IN 	:= bAMM_Pr_OilSkid_HP_DE_Ms,	PT:= T#10s);
			xTOF_Pr_HP_NDE_Ms(IN 	:= bAMM_Pr_OilSkid_HP_NDE_Ms,	PT:= T#10s);
	
			bRelMon_Lev_Tank		:= Para.bLev_OilSkid_Tank_Exist		AND NOT xTOF_AMM_Lev_Tank_Ms.Q;
			bRelMon_T_Tank			:= Para.bT_OilSkid_Tank_Exist		AND NOT xTOF_AMM_T_Tank_Ms.Q;
			bRelMon_T_Supply		:= Para.bT_OilSkid_Supply_Exist		AND NOT xTOF_AMM_T_Supply_Ms.Q;
			bRelMon_Flow_DE			:= Para.bFlow_OilSkid_DE_Exist		AND NOT xTOF_AMM_Flow_DE_Ms.Q;
			bRelMon_Flow_NDE		:= Para.bFlow_OilSkid_NDE_Exist		AND NOT xTOF_AMM_Flow_NDE_Ms.Q;
			bRelMon_Pr_HP_DE		:= Para.bPr_OilSkid_HP_DE_Exist		AND NOT xTOF_Pr_HP_DE_Ms.Q;
			bRelMon_Pr_HP_NDE		:= Para.bPr_OilSkid_HP_NDE_Exist	AND NOT xTOF_Pr_HP_NDE_Ms.Q;


		(*----------------------------------------------*)	
		(* error by level 		 						*)
		(*----------------------------------------------*)	
		xGR_MINR_Lev_OilSkid_Tank(In:= IN_GC.tLev_OilSkid_Tank.Ai, Gw:= Para.rLev_OilSkid_Tank_LoLo, Hy:= 0.05);	(* 5% hysteresis *)

		bAMM_Lev_OilSkid_Tank_LoLo	:= xGR_MINR_Lev_OilSkid_Tank.Q 								AND bRelMon_Lev_Tank;					(* A2208 *)
		bAMM_Lev_OilSkid_Tank_Lo	:= (IN_GC.tLev_OilSkid_Tank.Ai < Para.rLev_OilSkid_Tank_Lo) AND bRelMon_Lev_Tank;					(* W3420 *)


		(*----------------------------------------------*)	
		(* error by temperature	 						*)
		(*----------------------------------------------*)	
		bAMM_T_OilSkid_Tank_Lo 		:= (IN_GC.tT_OilSkid_Tank.Ai   < 20) AND bOMSS_MAT AND bRelMon_T_Tank;								(* W3422 *)

		bAMM_T_OilSkid_Supply_Lo	:= (IN_GC.tT_OilSkid_Supply.Ai < Para.rT_OilSkid_Supply_Lo)	AND bRelMon_T_Supply					(* W3424 *)
																								AND MM2VIS.bOilSkid_PumpLP_Dem 
																								AND bEng_Run_30m;

		bAMM_T_OilSkid_Supply_Hi	:= (IN_GC.tT_OilSkid_Supply.Ai > Para.rT_OilSkid_Supply_Hi)	AND bRelMon_T_Supply
																								AND MM2VIS.bOilSkid_PumpLP_Dem;			(* W3425 *)

		(*----------------------------------------------*)	
		(* error by flow		 						*)
		(*----------------------------------------------*)	
		IF (bRelMon_T_Supply AND IN_GC.tT_OilSkid_Supply.Ai > 55) OR 			(* tank   temperature > 55°C *)
		   (bRelMon_T_Tank   AND IN_GC.tT_OilSkid_Tank.Ai   > 55) THEN 			(* supply temperature > 55°C *)
			bErr_Flow_OilSkid_DE_Lo		:= (IN_GC.tFlow_OilSkid_DE.Ai  < Para.rFlow_OilSkid_DE_Lo);
			bErr_Flow_OilSkid_NDE_Lo	:= (IN_GC.tFlow_OilSkid_NDE.Ai < Para.rFlow_OilSkid_NDE_Lo);
		ELSE
			bErr_Flow_OilSkid_DE_Lo		:= (IN_GC.tFlow_OilSkid_DE.Ai  < 4);	(* 4 l/min *)
			bErr_Flow_OilSkid_NDE_Lo	:= (IN_GC.tFlow_OilSkid_NDE.Ai < 4);	(* 4 l/min *)
		END_IF;

		bAMM_Flow_OilSkid_DE_Lo		:= bErr_Flow_OilSkid_DE_Lo	AND xTON_PumpLP_10s.Q			AND bRelMon_Flow_DE;					(* W3428 *)
		bAMM_Flow_OilSkid_NDE_Lo	:= bErr_Flow_OilSkid_NDE_Lo	AND xTON_PumpLP_10s.Q			AND bRelMon_Flow_NDE;					(* W3431 *)

		bAMM_Flow_OilSkid_DE_Hi		:= (IN_GC.tFlow_OilSkid_DE.Ai  > Para.rFlow_OilSkid_DE_Hi)	AND bRelMon_Flow_DE;					(* W3429 *)
		bAMM_Flow_OilSkid_NDE_Hi	:= (IN_GC.tFlow_OilSkid_NDE.Ai > Para.rFlow_OilSkid_NDE_Hi)	AND bRelMon_Flow_NDE;					(* W3432 *)


		(*----------------------------------------------*)	
		(* error by pressure	 						*)
		(*----------------------------------------------*)	
			(* oil pressure in high pressure circuit OK *)
			bPr_OilSkid_HP_DE_Ok	:= IN_GC.tPr_OilSkid_HP_DE.Ai  > Para.rPr_OilSkid_HP_Lo;
			bPr_OilSkid_HP_NDE_Ok	:= IN_GC.tPr_OilSkid_HP_NDE.Ai > Para.rPr_OilSkid_HP_Lo;
	
			(* release by stable oil pressure *)
			xTON_PressOK_2s(IN:= ((bPr_OilSkid_HP_DE_Ok  AND bRelMon_Pr_HP_DE)  OR NOT Para.bPr_OilSkid_HP_DE_Exist ) AND
								 ((bPr_OilSkid_HP_NDE_Ok AND bRelMon_Pr_HP_NDE) OR NOT Para.bPr_OilSkid_HP_NDE_Exist) AND
								 (Para.bPr_OilSkid_HP_DE_Exist OR Para.bPr_OilSkid_HP_NDE_Exist),		(* at least on sensor exist *)	
							PT:= T#2s); 	
			bRel_OilSkid_Pr	  := xTON_PressOK_2s.Q;

		bAMM_Pr_OilSkid_HP_DE_Lo 	:= NOT bPr_OilSkid_HP_DE_Ok	 AND xTON_PumpHP_5s.Q AND bRelMon_Pr_HP_DE;								(* W3436 *)
		bAMM_Pr_OilSkid_HP_NDE_Lo 	:= NOT bPr_OilSkid_HP_NDE_Ok AND xTON_PumpHP_5s.Q AND bRelMon_Pr_HP_NDE;							(* W3443 *)



		(****************************************************************************************************************************************)
		(* control																																*)
		(****************************************************************************************************************************************)
		xTOF_NoSpeed_30s(IN:= NOT bN_EngAct_IsZero, PT:= T#30s);							(* engine is running *)

			(*----------------------------------------------*)	
			(* preheating		 							*)
			(*----------------------------------------------*)	
			IF bRelMon_T_Tank AND bOMSS_MAT THEN
				IF 		IN_GC.tT_OilSkid_Tank.Ai >= 50 	THEN   bOilSkid_Heater	:= FALSE;
				ELSIF 	IN_GC.tT_OilSkid_Tank.Ai <  40 	THEN   bOilSkid_Heater	:= TRUE; 	END_IF;

				OUT_GC.tOilSkid_Heater.Do	:=	bOilSkid_Heater
										AND NOT bAMM_OilSkid_Heater_CB
										AND NOT bErr_OilSkid_NoVoltage
										AND NOT IN_GC.bMsg1031
										AND NOT IN_GC.bMsg1054;
			END_IF;


			(*----------------------------------------------*)	
			(* Service										*)
			(*----------------------------------------------*)	
			IF 		NOT M_DREHZ							(* engine is not running *)
				AND NOT bAMM_Lev_OilSkid_Sump_Hi 		
				AND NOT IN_GC.bEng_RPSDem				(* engine is not demanded *)
				AND    (IN_GC.tT_OilSkid_Tank.Ai >= 20) (* oil temperature OK *)	
				AND     bRelMon_T_Tank  THEN
		 
				(* oilskid oil high pressure pump runtime *)
				xTON_PumpHP_DemOn(IN:= bPumpHP_DemService, PT:= Para.tiOilSkid_PumpHP_Run);

				IF 	IN_GC.tOilSkid_PumpHP_DemOn.Di AND NOT xTOF_NoSpeed_30s.Q			THEN bPumpHP_DemService	:= TRUE; 	END_IF;
				IF (IN_GC.tOilSkid_PumpHP_DemOff.Di OR xTON_PumpHP_DemOn.Q) 			THEN bPumpHP_DemService	:= FALSE;	END_IF;

				(* reset if pump isn't running *)
				IF (xTON_PumpHP_DemOn.ET > T#5s) AND NOT MM2VIS.bOilSkid_PumpHP_Dem 	THEN bPumpHP_DemService	:= FALSE;	END_IF;


				(* demand oilskid oil high pressure pump for N2 or IgnSelfTest *)//SWAT920/5
				xTOF_PrelubeDem(IN:= IN_GC.bN2_ScavCoPrelubeOn OR IN_GC.bEO_PrelubeDemIgn, PT:= T#60s);(* lag run time / until engine stand still *)//SWAT920/5
				bPumpHP_DemN2Ign := xTOF_PrelubeDem.Q;	

			ELSE
				xTON_PumpHP_DemOn(IN:= FALSE, PT:= T#0s);
				xTOF_PrelubeDem  (IN:= FALSE, PT:= T#0s);

				bPumpHP_DemService 	:= FALSE;
				bPumpHP_DemN2Ign	:= FALSE;
			END_IF;

			OUT_GC.bRelEngTurn_OilSkid	:= bRel_OilSkid_Pr AND(bPumpHP_DemService OR bPumpHP_DemN2Ign);	(* release engine turn *)


			(*----------------------------------------------*)	
			(* release engine operation						*)
			(*----------------------------------------------*)	
			IF    IN_GC.bEng_RPSDem AND (IN_GC.tT_OilSkid_Tank.Ai >= 20)
			THEN	
				bPumpHP_DemEngOp			:= (IN_GC.rN_EngAct < 500);
				OUT_GC.tOilSkid_PumpLP.Do	:= (IN_GC.rN_EngAct > 200)
										AND NOT bAMM_OilSkid_PumpLP_CB
										AND NOT bErr_OilSkid_NoVoltage
										AND NOT IN_GC.bMsg1031
										AND NOT IN_GC.bMsg1054;
			ELSE
				bPumpHP_DemEngOp 		:= FALSE;
			END_IF;
		
			OUT_GC.bRelEngOp_OilSkid	:= bRel_OilSkid_Pr AND bPumpHP_DemEngOp;	(* release engine operation *)
			OUT_GC.bRelEngStart_OilSkid	:= NOT bAMM_T_OilSkid_Tank_Lo AND NOT bAMM_Lev_OilSkid_Tank_LoLo; (* oilskid ready for fast start *)
							   
			(*----------------------------------------------*)	
			(* cooling										*)
			(*----------------------------------------------*)	
			IF NOT bN_EngAct_IsZero THEN

				IF 	bRelMon_T_Tank THEN 
					IF 	  IN_GC.tT_OilSkid_Tank.Ai   >  Para.rT_OilSkid_Tank_Set 		THEN  bOilSkid_Fan	:= TRUE; 
					ELSIF IN_GC.tT_OilSkid_Tank.Ai   < (Para.rT_OilSkid_Tank_Set - 5)	THEN  bOilSkid_Fan	:= FALSE; 	END_IF;
		
				ELSIF bRelMon_T_Supply 	THEN				(* switch to supply temperature in case of tank temp. error *)
					IF 	  IN_GC.tT_OilSkid_Supply.Ai >  Para.rT_OilSkid_Tank_Set 		THEN  bOilSkid_Fan	:= TRUE; 
					ELSIF IN_GC.tT_OilSkid_Supply.Ai < (Para.rT_OilSkid_Tank_Set - 5) 	THEN  bOilSkid_Fan	:= FALSE; 	END_IF;
				END_IF;
	
				OUT_GC.tOilSkid_Fan.Do	:=	bOilSkid_Fan
									AND NOT bAMM_OilSkid_Fan_CB
									AND NOT bErr_OilSkid_NoVoltage
									AND NOT IN_GC.bMsg1031
									AND NOT IN_GC.bMsg1054;
			END_IF;


			(*----------------------------------------------*)	
			(* circulation pump								*)
			(*----------------------------------------------*)	
			IF 	  IN_GC.tT_OilSkid_Tank.Ai >= 22.0 THEN bT_RelOilSkidPumpC := TRUE; 
			ELSIF IN_GC.tT_OilSkid_Tank.Ai <  20.0 THEN bT_RelOilSkidPumpC := FALSE; END_IF;

			OUT_GC.tOilSkid_PumpC.Do :=   ((MM2VIS.bOilSkid_Heater_Dem AND bT_RelOilSkidPumpC) OR (IN_GC.rN_EngAct > 200)) 	(* Heater is running *) 	 
									AND	NOT bAMM_OilSkid_PumpC_CB  
									AND NOT bErr_OilSkid_NoVoltage
									AND NOT IN_GC.bMsg1031
									AND NOT IN_GC.bMsg1054;


			(*----------------------------------------------*)	
			(* engine stop									*)
			(*----------------------------------------------*)	
			IF 	NOT IN_GC.bEng_RPSDem AND xTOF_NoSpeed_30s.Q THEN
				bPumpHP_DemEngStop			:= (IN_GC.rN_EngAct < 500);
				OUT_GC.tOilSkid_PumpLP.Do	:=	NOT bRel_OilSkid_Pr
											AND NOT bAMM_OilSkid_PumpLP_CB
											AND NOT bErr_OilSkid_NoVoltage
											AND NOT IN_GC.bMsg1031
											AND NOT IN_GC.bMsg1054;
				xTON_PumpHP_Dem_5s(IN := bPumpHP_DemEngStop, PT:= T#5s);	 			(* HP pump demand for 5 seconds *)

				IF  NOT bRel_OilSkid_Pr AND	EDGEPOS(xTON_PumpHP_Dem_5s.Q) THEN	
					VIS2MM.iCnt_OilSkid_HP_PrErr := VIS2MM.iCnt_OilSkid_HP_PrErr + 1; 	(* Perm: error counter for high pressure *) 
				END_IF;
			ELSE
				xTON_PumpHP_Dem_5s(IN:= FALSE, PT:= T#0s);
				bPumpHP_DemEngStop := FALSE;
			END_IF;

			(*----------------------------------------------*)	
			(* engine faststart								*)
			(*----------------------------------------------*)	
			xTON_FS(IN:= (IN_GC.rN_EngAct > 0), PT:= T#4s);
			IF 	IN_GC.bEng_Start THEN
				IF  NOT bRel_OilSkid_Pr AND	EDGEPOS(xTON_FS.Q) THEN	
					VIS2MM.iCnt_OilSkid_HP_PrErr := VIS2MM.iCnt_OilSkid_HP_PrErr + 1; 	(* Perm: error counter for high pressure *) 
				END_IF;
			END_IF;

			(*----------------------------------------------*)	
			(* high pressure pump / UPS						*)
			(*----------------------------------------------*)
			xTOF_PumpHP_Dem(IN:= bPumpHP_DemService OR bPumpHP_DemN2Ign OR bPumpHP_DemEngOp OR bPumpHP_DemEngStop, PT:= T#1s);

			OUT_GC.tOilSkid_PumpHP_Soft.Do	:= xTOF_PumpHP_Dem.Q AND NOT IN_GC.bMsg1031
																 AND NOT IN_GC.bMsg1054;

			OUT_GC.tOilSkid_PumpHP.Do		:= xTOF_PumpHP_Dem.Q AND NOT xTOF_PumpHP_UPS.Q 
																 AND NOT bAMM_OilSkid_PumpHP_CB 
																 AND NOT bErr_OilSkid_NoVoltage
																 AND NOT IN_GC.bMsg1031
																 AND NOT IN_GC.bMsg1054;
			
			xTOF_PumpHP(IN:= OUT_GC.tOilSkid_PumpHP.Do, PT:= T#1s);

			OUT_GC.tOilSkid_PumpHP_UPS.Do	:= xTOF_PumpHP_Dem.Q AND NOT xTOF_PumpHP.Q 
																 AND NOT bAMM_OilSkid_PumpHP_CB_UPS 
																 AND NOT bAMM_OilSkid_AuxV_UPS 
																 AND     xTOF_NoSpeed_30s.Q			(* demand only if shutdown *)
																 AND NOT IN_GC.bMsg1031
																 AND NOT IN_GC.bMsg1054;
			xTOF_PumpHP_UPS(IN:= OUT_GC.tOilSkid_PumpHP_UPS.Do, PT:= T#1s);

		IF 		IN_GC.bMsg1031  													(* A1031 emergency stop *)
			OR  IN_GC.bMsg1054  													(* A1054 fire alarm *)
			OR (MM2VIS.bMsg2208  AND NOT bMsg2208_Test) 							(* A2208 oilskid tank level minimum *)
			OR (bAMM_OilSkid_MCB AND     bN_EngAct_IsZero) THEN						(* W3439 Oilskid main switch auxiliaries opened *)

			bPumpHP_DemService 			:= FALSE;									(* NO demand of high pressure pump 	 *)
			bPumpHP_DemN2Ign			:= FALSE;									(* NO demand of high pressure pump 	 *)
			bPumpHP_DemEngOp			:= FALSE;									(* NO demand of high pressure pump 	 *)
			OUT_GC.bRelEngOp_OilSkid 	:= FALSE;									(* NO release of engine operation 	 *)
			OUT_GC.bRelEngTurn_OilSkid	:= FALSE;									(* NO release of engine barring gear *)
			OUT_GC.bRelEngStart_OilSkid	:= FALSE; 									(* NO oilskid ready for fast start   *)
		END_IF;

	ELSE (* inactive OilSkid *)
		xTON_PumpLP_10s(IN:= FALSE, PT:= T#0s);
		xTON_PumpHP_5s(IN:= FALSE, PT:= T#0s);
		xTON_PressOK_2s(IN:= FALSE, PT:= T#0s);
		xTON_PumpHP_DemOn(IN:= FALSE, PT:= T#0s);
		xTON_PumpHP_Dem_5s(IN:= FALSE, PT:= T#0s);
		xTON_FS(IN:= FALSE, PT:= T#0s);

		xTOF_NoSpeed_30s(IN:= FALSE, PT:= T#0s);
		xTOF_PrelubeDem(IN:= FALSE, PT:= T#0s);
		xTOF_PumpHP_UPS(IN:= FALSE, PT:= T#0s);
		xTOF_PumpHP(IN:= FALSE, PT:= T#0s);

		bPumpHP_DemService			:= FALSE;										(* NO demand of high pressure pump 	 *)
		bPumpHP_DemN2Ign			:= FALSE;										(* NO demand of high pressure pump 	 *)
		bPumpHP_DemEngOp			:= FALSE;										(* NO demand of high pressure pump 	 *)
		bPumpHP_DemEngStop			:= FALSE;										(* NO demand of high pressure pump 	 *)
		OUT_GC.bRelEngOp_OilSkid 	:= TRUE;										(*    release engine operation  	 *)
		OUT_GC.bRelEngTurn_OilSkid	:= TRUE;										(*    release engine barring gear	 *)
		OUT_GC.bRelEngStart_OilSkid	:= TRUE; 										(*    oilskid ready for fast start   *)
	END_IF;

	OUT_GC.bAMM_OilSkid_PumpLP_CB := bAMM_OilSkid_PumpLP_CB;						(* bEng_Bloc *)
	OUT_GC.bAMM_OilSkid_PumpHP_CB := bAMM_OilSkid_PumpHP_CB;						(* bEng_Bloc *)
	OUT_GC.bAMM_OilSkid_MCB       := bAMM_OilSkid_MCB;								(* bEng_Bloc *)
	
END_PROGRAM
