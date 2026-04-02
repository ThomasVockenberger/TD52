(*******************************************************************************
AGGR: static GridCode - voltage control (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2023

- alle Funktionen welche im Rahmen des statischen GridCodes auf die Blindleistung/cos phi einwirken

Customized modifications: -
------------------------
 
History:
-------
V3.40.0	14-02-2013	Perktold,  	generated
V3.40.1	27-03-2013	Perktold,  	Freigabe aus HW & BUS gleichwertig für PFset und Qset Funktion
							   	DO Generierung korrigiert für PFset und Qset
							   	PF Rampenbaustein wird wenn keine stat. GC Funktion aktiv ist auf dem PF-Istwert gehalten
V3.40.2	14-06-2013	Perktold,  	Allgemeine Freigabebedingungen AUTO & P>50% für Qlim nicht mehr notwendig - NetpM reicht
V4.00.0 22-08-2013  Maxhera,    implementation of the module for modular software
V4.03.0	15-12-2015	Perktold, 	diverse Korrekturen nach Validierung am 412er TC
V4.04.0	06-10-2016	Perktold	changed ERDF to DEIE
V4.05.0 07-12-2017  Farre,      Q functions, Q customized, Q Time Table, U control, Arbitration Q func, Q limit based Q(U), filter ramp
V4.06.0 06-08-2018  Zuschnig,   added signal loss function for COSPHI_Set, Q_Set, Q_Lim and U_Set
V4.09.0	18.11.2019	lettenb.	Para.iQPF_GrC_SetEUCOn: 2:DI, 5:AI splitted, Para.bPF_GrC_SetEUAct removed
								Para.iQ_GrC_SetX:       2:DI, 5:AI splitted, Para.bQ_GrC_SetEUCOn  removed
								Para.iU_GrC_SetX:       2:DI, 5:AI splitted, Para.bU_GrC_SetEUCOn  removed
		03.02.2020	lettenb.	Limitation QSet_QULim only in PFset or Qset mode(OUT_GR.iGCQ_Fun_Act)
		22.05.2020	lettenb.	bQ_GenC_ExtRel for Qset from bus, bugfix
V4.10.0	16.11.2020	lettenb.	selectable PT2 behavior for reactive power ramp(VDE4120) added
        14.12.2020	lettenb.	TON,TOF reset added to avoid time overrun, cleanup
		22.01.2021	lettenb.	USetExt bus (Para.iQ_GrC_CtrlFun = 3) OR (Para.iQ_GrC_CtrlFun = 4) added, bugfix
V4.11.0	26.01.2022	lettenb.	bU_Set_NP_Rel, rU_Set_NP added for voltage control
V4.12.0	03.01.2023	lettenb.	rGCQ_USetExt := 1.0, unit mismatch if Para.iU_GrC_SetX=0, bugfix
V4.13.0	10.10.1023	Farre,		AOs for MMU shall be independent from PF Controller (issue #1227)
		07.03.2024	Farre,		issue #890, #1089: delete scaling analog input signals and shifted to HalIO

Instructions for use:
--------------------- 

Outstandings:
------------
-

*******************************************************************************)
PROGRAM _CYCLIC
	
xOpMode(in 	:= IN_GR.iSt_OpMode);	(* call function for the state machine *)
	
IF Para.bPF_CosPCtr_Ena THEN
	(************************************************)
	(****** FUNCTION # 0 - Q customer ***************)
	(************************************************)
	(* Enable Q customer - Bus *)
	xSR_BC_QCust(SET1 := IN_GR.bGenC_QCustBC_SetCOn, RESET := IN_GR.bGenC_QCustBC_SetCOf);
	bGenC_QCustBC_ExtRel	:= xSR_BC_PF.Q1;
		
	IF bGenC_QCustBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 0) THEN
		rQ_Cust_Set := IN_GR.rQ_Cust;
	ELSE
		rQ_Cust_Set := 0.0;		
	END_IF;
		
	IF (Para.rS_Nom <> 0) THEN
		rQ_Cust_Set_pu := rQ_Cust_Set/ Para.rS_Nom; (* Q/S - p.u.*)
	END_IF;
		
		
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
	
	MM2VIS.rQ_CUST_set := rQ_Cust_Set_pu;
	
	(*******************************************************************************)
	(****** FUNCTION # 1 - (COS PHI) setpoint generator power factor ***************)
	(*******************************************************************************)

	(* Enable external power factor cos(phi)requirement EU - Hardware*)
	xSR_PF(SET1 := IN_GR.bPF_GenC_SetEUCOn, RESET := IN_GR.bPF_GenC_SetEUCOf);
	bPF_GenC_ExtRel	:= xSR_PF.Q1;

	(* Enable external power factor requirement EU - Bus *)
	xSR_BC_PF(SET1 := IN_GR.bGenC_PFBC_SetCOn, RESET := IN_GR.bGenC_PFBC_SetCOf);
	bGenC_PFBC_ExtRel	:= xSR_BC_PF.Q1;
	
	(* Scaling external power factor cos(phi)requirement EU - Hardware*)
	IF (Para.iQPF_GrC_SetEUCOn = 5) THEN
			
			(* Generation measurement signal interference error *)
			IF Para.rPF_GrC_SetEUI1 >= 4.0 AND Para.rPF_GrC_SetEUI2 >= 4.0 AND IN_GR.tPF_GenC_SetEU.GoodQual AND Para.bRelFreeze_PF_EU THEN
				rBuffer_PF_EU[x_PF] := IN_GR.tPF_GenC_SetEU.Ai;
				x_PF := x_PF + 1;
				IF x_PF > 9 THEN
					x_PF := 0;
					bBuffer_PF_EU := TRUE;
				END_IF
			END_IF
			
			IF NOT bBuffer_PF_EU THEN
				rLCRLimScal_PF_old := 1.00;
			END_IF;		

			TON_GoodQual_PF_EU(IN := IN_GR.tPF_GenC_SetEU.GoodQual, PT := tGoodQual);

			IF Para.rPF_GrC_SetEUI1 >= 4.0 AND Para.rPF_GrC_SetEUI2 >= 4.0 AND NOT TON_GoodQual_PF_EU.Q THEN
			bMsg3593 := TRUE;
			IF Para.bRelFreeze_PF_EU  AND bBuffer_PF_EU THEN	
				IF rLCRLimScal_PF_old > 1.0 THEN
					rGCQ_PF			:= (rLCRLimScal_PF_old - 2) ;
				ELSE
					rGCQ_PF			:= (rLCRLimScal_PF_old) ;
				END_IF;
			END_IF
		ELSE
			bMsg3593	:= FALSE;	
			IF IN_GR.tPF_GenC_SetEU.Ai > 1.0 THEN
				rGCQ_PF			:= (IN_GR.tPF_GenC_SetEU.Ai - 2);
				rGCQ_PF_AI		:= (IN_GR.tPF_GenC_SetEU.Ai - 2);//LE
			ELSE
				rGCQ_PF			:= (IN_GR.tPF_GenC_SetEU.Ai);
				rGCQ_PF_AI		:= (IN_GR.tPF_GenC_SetEU.Ai);//LE
			END_IF;
			IF Para.bRelFreeze_PF_EU THEN	
				z_PF := x_PF - 8;
				IF bBuffer_PF_EU THEN
					IF z_PF >= 0 THEN
						rLCRLimScal_PF_old := rBuffer_PF_EU[z_PF];
					ELSE
						rLCRLimScal_PF_old := rBuffer_PF_EU[z_PF + 9];
					END_IF
				ELSE
					rLCRLimScal_PF_old := 1.00;
				END_IF
			END_IF
		END_IF;	

	ELSE
		TON_GoodQual_PF_EU(IN:= FALSE, PT:= T#0s);
		rGCQ_PF			:= 1.00;
		rGCQ_PF_AI		:= 1.00;
		bMsg3593	:= FALSE;
	END_IF;

	(**************************************************)
	(* COSPHI selection of external setpoint utility  *)
	(**************************************************)
	
	rGCQ_PFSetExt	:= 1.00;
	bGCQ_PFSetExt	:= FALSE;
	
	CASE Para.iQPF_GrC_SetEUCOn  OF
		0:  (* NOT USED *)
			bGCQ_PFSetExt	:= FALSE;
		1:  (* INTERN *)
			rGCQ_PFSetExt	:= Para.rPF_GrC_SetEU;
			bGCQ_PFSetExt	:= TRUE;
		2:  (* EXTERN DI *)
			IF (bPF_GenC_ExtRel OR bGenC_PFBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 1)) THEN (* External input is able to be read if external activations or HMI activation *)
				IF IN_GR.PF_GenC_SetFix5 THEN
					rGCQ_PFSetExt	:= Para.rPF_GrC_Ext5FixEU;
				ELSIF IN_GR.PF_GenC_SetFix4 THEN
					rGCQ_PFSetExt	:= Para.rPF_GrC_Ext4FixEU;
				ELSIF IN_GR.PF_GenC_SetFix3 THEN
					rGCQ_PFSetExt	:= Para.rPF_GrC_Ext3FixEU;
				ELSIF IN_GR.PF_GenC_SetFix2 THEN
					rGCQ_PFSetExt	:= Para.rPF_GrC_Ext2FixEU;
				ELSIF IN_GR.PF_GenC_SetFix1 THEN
					rGCQ_PFSetExt	:= Para.rPF_GrC_Ext1FixEU;
				ELSE 
					rGCQ_PFSetExt	:= Para.rPF_GrC_SetEUAct_BU;
				END_IF;
			ELSE
				rGCQ_PFSetExt	:= Para.rPF_GrC_SetEUAct_BU;
			END_IF;
			bGCQ_PFSetExt	:= TRUE;
		3:  (* EXTERN BUS *)
			IF (bPF_GenC_ExtRel OR bGenC_PFBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 1)) AND NOT IN_GR.bPFBC_GenC_SetErrBC THEN (* External input is able to be read if external activations or HMI activation *)
				rGCQ_PFSetExt	:= IN_GR.rGenC_PFBC;
			ELSE
				rGCQ_PFSetExt	:= Para.rPF_GrC_SetEUAct_BU;
			END_IF;
			bGCQ_PFSetExt	:= TRUE;
		4:  (* CUSTOM *)
			IF IN_GR.tPF_CUSTGenC.GoodQual  THEN		
				rGCQ_PFSetExt	:= IN_GR.tPF_CUSTGenC.Ai;
			ELSE
				rGCQ_PFSetExt	:= Para.rPF_GrC_SetEUAct_BU; 
			END_IF;		
			bGCQ_PFSetExt	:= TRUE;
		5:  (* EXTERN AI *)
			IF (bPF_GenC_ExtRel OR bGenC_PFBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 1)) THEN (* External input is able to be read if external activations or HMI activation *)
				IF NOT MM2VIS.bMsg3593 OR Para.bRelFreeze_PF_EU THEN
					rGCQ_PFSetExt	:= rGCQ_PF;
				ELSE 
					rGCQ_PFSetExt	:= Para.rPF_GrC_SetEUAct_BU;
				END_IF;
			ELSE
				rGCQ_PFSetExt	:= Para.rPF_GrC_SetEUAct_BU;
			END_IF;
			bGCQ_PFSetExt	:= TRUE;
		ELSE
			bGCQ_PFSetExt	:= FALSE;
	END_CASE;	
	
		(*Q calculation p.u. from Cosphi set*)
		IF bGCQ_PFSetExt THEN
			IF (rGCQ_PFSetExt <> 0) AND (Para.rS_Nom <> 0) THEN
				rGCQ_PFSetExt_pu := TAN(ACOS(rGCQ_PFSetExt)) * rPAct_GCFilt / Para.rS_Nom; (*Q/S - p.u.*)
			END_IF;
		END_IF;
	
	(******************************)
	(* RESULTS - COSPHI setpoint  *)
	(******************************)
    	rGCQ_PFSetExt_pu;
		bGCQ_PFSetExt;

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

		MM2VIS.rPF_set := rGCQ_PFSetExt;

//		MM2VIS.rGCQ_PFSetExt		:= rGCQ_PFSetExt; 
//		MM2VIS.rGCQ_PF				:= rGCQ_PF;
		MM2VIS.rGCQ_PF_AI			:= rGCQ_PF_AI;
//		MM2VIS.rGenC_PFBC			:= IN_GR.rGenC_PFBC;
//		MM2VIS.bPF_GenC_ExtRel		:= bPF_GenC_ExtRel;
//		MM2VIS.bGenC_PFBC_ExtRel	:= bGenC_PFBC_ExtRel;
//		MM2VIS.tPF_GenC_Fix1SOn		:= OUT_GR.tPF_GenC_Fix1SOn.Do;
//		MM2VIS.tPF_GenC_Fix2SOn		:= OUT_GR.tPF_GenC_Fix2SOn.Do;
//		MM2VIS.tPF_GenC_Fix3SOn		:= OUT_GR.tPF_GenC_Fix3SOn.Do;
//		MM2VIS.tPF_GenC_Fix4SOn		:= OUT_GR.tPF_GenC_Fix4SOn.Do;
//		MM2VIS.tPF_GenC_Fix5SOn		:= OUT_GR.tPF_GenC_Fix5SOn.Do;

	(******************************************************************************)
	(********* FUNCTION # 2 - SETPOINT Cos(phi) = F(P)   **************************)
	(******************************************************************************)
	(*  Enable external power factor from digital inputs *)
	xSR_PFP(SET1 := IN_GR.bQPC_GenC_SetEUCOn, RESET := IN_GR.bQPC_GenC_SetEUCOf);
	bGCQ_PFP	:= xSR_PFP.Q1;

	(*  Enable external power factor from bus *)
	xSR_BC_PFP(SET1 := IN_GR.bGenC_QPCBC_SetCOn, RESET := IN_GR.bGenC_QPCBC_SetCOf);
	bBC_GCQ_PFP	:= xSR_BC_PFP.Q1;

	IF (bGCQ_PFP OR bBC_GCQ_PFP) AND bstatGC_rel THEN
		OUT_GR.bPFP_Aktiv	:= TRUE;
	ELSE
		OUT_GR.bPFP_Aktiv	:= FALSE;
	END_IF;	

	(************************)
	(* RESULTS - COSPHI (P) *)
	(************************)
	rQP_PF_Set;
		
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

//	MM2VIS.bGCQ_PFP			:= bGCQ_PFP;
//	MM2VIS.bBC_GCQ_PFP		:= bBC_GCQ_PFP;

		
	(****************************************************************)
	(**** FUNCTION #3 - SETPOINT Cos(phi) = F(U)*********************)
	(****************************************************************)
	(* setpoint reactive power characteristics COS(phi)=f(U) from DIs -on/off *)
	xSR_PFU(SET1 := IN_GR.bPFUC_GenC_SetEUCOn, RESET := IN_GR.bPFUC_GenC_SetEUCOf);
	bGCQ_PFU	:= xSR_PFU.Q1;
	
	(* setpoint reactive power characteristics COS(phi)=f(U) from bus -on/off *)
	xSR_BC_PFU(SET1 := IN_GR.bGenC_PFUCBC_SetCOn, RESET := IN_GR.bGenC_PFUCBC_SetCOf);
	bBC_GCQ_PFU	:= xSR_BC_PFU.Q1;

	(*PFU is active from DIs or bus and general release *)
	IF (bGCQ_PFU OR bBC_GCQ_PFU) AND bstatGC_rel THEN
		OUT_GR.bPFU_Aktiv	:= TRUE;
	ELSE
		OUT_GR.bPFU_Aktiv	:= FALSE;
	END_IF;	

	(************************)
	(* RESULTS - COSPHI (U) *)
	(************************)
	rQU_PF_Set;		
		
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

//	MM2VIS.bGCQ_PFU			:= bGCQ_PFU;
//	MM2VIS.bBC_GCQ_PFU		:= bBC_GCQ_PFU;
		
	(****************************************************************)
	(****** FUNCTION #4 - Q = F(U) **********************************)
	(****************************************************************)
	(* setpoint reactive power characteristics Q=f(U) from DIs -on/off *)
	xSR_QU(SET1 := IN_GR.bQUC_GenC_SetEUCOn, RESET := IN_GR.bQUC_GenC_SetEUCOf);
	bGCQ_QU	:= xSR_QU.Q1;

	(* setpoint reactive power characteristics Q=f(U) from bus -on/off *)
	xSR_BC_QU(SET1 := IN_GR.bGenC_QUCBC_SetCOn, RESET := IN_GR.bGenC_QUCBC_SetCOf);
	bBC_GCQ_QU	:= xSR_BC_QU.Q1;

	(*QU is active from DIs or bus and geleral release*)
	IF (bGCQ_QU OR bBC_GCQ_QU) AND bstatGC_rel	THEN
		OUT_GR.bQU_Aktiv	:= TRUE;
	ELSE
		OUT_GR.bQU_Aktiv	:= FALSE;
	END_IF;	

	(******************)
	(* RESULTS - Q(U) *)
	(******************)
	rQU_Set_Norm;
		
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

//	MM2VIS.bGCQ_QU			:= bGCQ_QU;
//	MM2VIS.bBC_GCQ_QU		:= bBC_GCQ_QU;
		
	(****************************************************************)
	(****** FUNCTION #5 - Q = F(P) **********************************)
	(****************************************************************)
	(* setpoint reactive power characteristics Q=f(P) from DIs -on/off *)
	xSR_QP(SET1 := IN_GR.bQP_GenC_SetEUCOn, RESET := IN_GR.bQP_GenC_SetEUCOf);
	bGCQ_QP	:= xSR_QP.Q1;

	(* setpoint reactive power characteristics Q=f(P) from bus -on/off *)
	xSR_BC_QP(SET1 := IN_GR.bGenC_QPBC_SetCOn, RESET := IN_GR.bGenC_QPBC_SetCOf);
	bBC_GCQ_QP	:= xSR_BC_QP.Q1;

	(*QP is active from DIs or bus and geleral release*)
	IF (bGCQ_QP OR bBC_GCQ_QP) AND bstatGC_rel	THEN
		OUT_GR.bQP_Aktiv	:= TRUE;
	ELSE
		OUT_GR.bQP_Aktiv	:= FALSE;
	END_IF;	

	(******************)
	(* RESULTS - Q(P) *)
	(******************)
	rQP_Setlin;
	
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)

//	MM2VIS.bGCQ_QP			:= bGCQ_QP;
//	MM2VIS.bBC_GCQ_QP		:= bBC_GCQ_QP;	
		
	(****************************************************************)
	(****** FUNCTION #6 - Q   S E T P O I N T S *********************)
	(****************************************************************)
		
	(* enable setpoint reactive power characteristic (Q) from digital inputs *)
		xSR_Q(SET1 := IN_GR.bQ_GenC_SetEUCOn, RESET := IN_GR.bQ_GenC_SetEUCOf);
		bQ_GenC_ExtRel	:= xSR_Q.Q1;

	(* enable setpoint reactive power characteristic (Q) from bus *)
		xSR_BC_Q(SET1 := IN_GR.bGenC_QBC_SetCOn, RESET := IN_GR.bGenC_QBC_SetCOf);
		bGenC_QBC_ExtRel	:= xSR_BC_Q.Q1;

	(* Scaling external reative power Q requirement EU - Hardware*)
	IF (Para.iQ_GrC_SetX = 5) THEN

		(* Generierung Messsignalstoerung *)
		IF Para.rQ_GrC_SetEUI1 >= 4.0 AND Para.rQ_GrC_SetEUI2 >= 4.0 AND IN_GR.tQ_GenC_SetEU.GoodQual AND Para.bRelFreeze_Qset_EU THEN
			rBuffer_Qset_EU[x_Qset] := IN_GR.tQ_GenC_SetEU.Ai;
			x_Qset := x_Qset + 1;
			IF x_Qset > 9 THEN
				x_Qset := 0;
				bBuffer_Qset_EU := TRUE;
			END_IF
		END_IF
		
		IF NOT bBuffer_Qset_EU THEN
			rLCRLimScal_QAct_old := 0.00;
		END_IF;		

		TON_GoodQual_Qset_EU(IN := IN_GR.tQ_GenC_SetEU.GoodQual, PT := tGoodQual);
		
		IF Para.rQ_GrC_SetEUI1 >= 4.0 AND Para.rQ_GrC_SetEUI2 >= 4.0 AND NOT TON_GoodQual_Qset_EU.Q THEN
			bMsg3594	:= TRUE;
			IF Para.bRelFreeze_Qset_EU AND bBuffer_Qset_EU  THEN	
				rGCQ_Q := rLCRLimScal_QAct_old;
			END_IF
		ELSE
			bMsg3594	:= FALSE;		
			rGCQ_Q		:= IN_GR.tQ_GenC_SetEU.Ai;
	
			IF Para.bRelFreeze_Qset_EU THEN	
				z_Qset := x_Qset - 8;
				IF bBuffer_Qset_EU THEN
					IF z_Qset >= 0 THEN
						rLCRLimScal_QAct_old := rBuffer_Qset_EU[z_Qset];
					ELSE
						rLCRLimScal_QAct_old := rBuffer_Qset_EU[z_Qset + 9];
					END_IF
				ELSE
					rLCRLimScal_QAct_old := 0.00;
				END_IF
			END_IF
		END_IF;	

	ELSE
		TON_GoodQual_Qset_EU(IN:= FALSE, PT:= T#0s);
		rGCQ_Q		:= 0.00;
		bMsg3594	:= FALSE;
	END_IF;
	
	
	(***********************************************)
	(* Selection of external Q - Setpoint utility  *)
	(***********************************************)
	
		rGCQ_QSetExt	:= 0.0;
		bGCQ_QSetExt	:= FALSE;

		(* Choice for reactive power functions *)
		CASE Para.iQ_GrC_SetX OF    
			0:  (* NOT USED *)
			bGCQ_QSetExt	:= FALSE;
		1:  (* INTERN *)
			rGCQ_QSetExt	:= Para.rQ_GrC_SetInt;
			bGCQ_QSetExt	:= TRUE;
		2:  (* EXTERN DI *)
			IF (bQ_GenC_ExtRel OR bGenC_QBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 6)) THEN (* External input is able to be read if external activations or HMI activation *)
				IF IN_GR.Q_GenC_SetFix5 THEN
					rGCQ_QSetExt	:= Para.rQ_GrC_SetEUFix5;
				ELSIF IN_GR.Q_GenC_SetFix4 THEN
					rGCQ_QSetExt	:= Para.rQ_GrC_SetEUFix4;
				ELSIF IN_GR.Q_GenC_SetFix3 THEN
					rGCQ_QSetExt	:= Para.rQ_GrC_SetEUFix3;
				ELSIF IN_GR.Q_GenC_SetFix2 THEN
					rGCQ_QSetExt	:= Para.rQ_GrC_SetEUFix2;
				ELSIF IN_GR.Q_GenC_SetFix1 THEN
					rGCQ_QSetExt	:= Para.rQ_GrC_SetEUFix1;
				ELSE 
					rGCQ_QSetExt	:= Para.rQ_GrC_SetAct_BU;
				END_IF;
			ELSE
				rGCQ_QSetExt	:= Para.rQ_GrC_SetAct_BU;
			END_IF;
			bGCQ_QSetExt	:= TRUE;
		3:  (* EXTERN BUS *)
			IF (bQ_GenC_ExtRel OR bGenC_QBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 6)) AND NOT IN_GR.bQ_GenC_SetErrBC THEN (* External input is able to be read if external activations or HMI activation *)
				rGCQ_QSetExt	:= IN_GR.rGenC_QBC;
			ELSE
				rGCQ_QSetExt	:= Para.rQ_GrC_SetAct_BU;
			END_IF;
			bGCQ_QSetExt	:= TRUE;
		4:  (* CUSTOM *)
			IF IN_GR.tQ_GenC_CUST.GoodQual THEN		
				rGCQ_QSetExt	:= IN_GR.tQ_GenC_CUST.Ai;
			ELSE
				rGCQ_QSetExt	:= Para.rQ_GrC_SetAct_BU;
			END_IF;		
			bGCQ_QSetExt	:= TRUE;
		5:  (* EXTERN AI *)
			IF (bQ_GenC_ExtRel OR bGenC_QBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 6)) THEN (* External input is able to be read if external activations or HMI activation *)
				IF NOT MM2VIS.bMsg3594 OR Para.bRelFreeze_Qset_EU THEN
					rGCQ_QSetExt	:= rGCQ_Q;
				ELSE 
					rGCQ_QSetExt	:= Para.rQ_GrC_SetAct_BU;
				END_IF;
			ELSE
				rGCQ_QSetExt	:= Para.rQ_GrC_SetAct_BU;
			END_IF;
			bGCQ_QSetExt	:= TRUE;
		ELSE
			bGCQ_QSetExt	:= FALSE;
		END_CASE;	
	
		(* Calculate the Q setpoint per unit *)
	IF bGCQ_QSetExt THEN
			IF (Para.rS_Nom <> 0) THEN
				rQ_QSet_pu := rGCQ_QSetExt/ Para.rS_Nom; (* Q/S - p.u.*)
		END_IF;
	END_IF;
	
	(******************************)
	(* RESULTS - Q - Setpoint 	  *)
	(******************************)
	rQ_QSet_pu;
	bGCQ_QSetExt;

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
		MM2VIS.rQ_set_KVAr			:= rGCQ_QSetExt;
		
//		MM2VIS.rGCQ_QSetExt			:= rGCQ_QSetExt;
//		MM2VIS.rGCQ_Q				:= rGCQ_Q;
		MM2VIS.rGCQ_Q_AI			:= IN_GR.tQ_GenC_SetEU.Ai;
//		MM2VIS.rGenC_QBC			:= IN_GR.rGenC_QBC;
//		MM2VIS.rPF_QSet				:= rPF_QSet;
//		MM2VIS.bQ_GenC_ExtRel		:= bQ_GenC_ExtRel;
//		MM2VIS.bGenC_QBC_ExtRel		:= bGenC_QBC_ExtRel;
//		MM2VIS.bQ_GenC_Fix1SOn		:= OUT_GR.tQ_GenC_Fix1SOn.Do;
//		MM2VIS.bQ_GenC_Fix2SOn		:= OUT_GR.tQ_GenC_Fix2SOn.Do;
//		MM2VIS.bQ_GenC_Fix3SOn		:= OUT_GR.tQ_GenC_Fix3SOn.Do;
//		MM2VIS.bQ_GenC_Fix4SOn		:= OUT_GR.tQ_GenC_Fix4SOn.Do;
//		MM2VIS.bQ_GenC_Fix5SOn		:= OUT_GR.tQ_GenC_Fix5SOn.Do;

	(**********************************************************************************)
	(*****FUNCTION #7 - U SETPOINT FOR Q / SAME USED FOR PF (U) and Q (U)) ************)
	(**********************************************************************************)

	(* Enable U sepoint for PF(U) and Q(U) from bus *)	
	xSR_BC_UQ(SET1 := IN_GR.bGenC_UQBC_SetCOn, RESET := IN_GR.bGenC_UQBC_SetCOf);
	bGenC_UQBC_ExtRel	:= xSR_BC_UQ.Q1;
		
	(* Enable setpoint voltage for Q control from digital inputs *)
	xSR_U(SET1 := IN_GR.bU_GenC_SetEUCOn, RESET := IN_GR.bU_GenC_SetEUCOf);
	bU_GenC_ExtRel	:= xSR_U.Q1;

	(* Enable setpoint voltage for Q control from bus *)
	xSR_BC_U(SET1 := IN_GR.bGenC_UBC_SetCOn, RESET := IN_GR.bGenC_UBC_SetCOf);
	bGenC_UBC_ExtRel	:= xSR_BC_U.Q1;
		
		
	(* External setpoint scaling U FOR PF (U) and Q (U) or U for Q control - Hardware *)
	IF (Para.iU_GrC_SetX = 5) THEN
		(* Generation measurement signal interference *)
		IF Para.rU_GrC_SetEUI1 >= 4.0 AND Para.rU_GrC_SetEUI2 >= 4.0 AND IN_GR.tQU_GenC_Set.GoodQual AND Para.bRelFreeze_Uset_EU  THEN
			rBuffer_Uset_EU[x_Uset] := IN_GR.tQU_GenC_Set.Ai;
			x_Uset := x_Uset + 1;
			IF x_Uset > 9 THEN
				x_Uset := 0;
				bBuffer_Uset_EU := TRUE;
			END_IF
		END_IF

		IF NOT bBuffer_Uset_EU THEN
			rLCRLimScal_UAct_old := 1.0;
		END_IF;	
		
		TON_GoodQual_Uset_EU(IN := IN_GR.tQU_GenC_Set.GoodQual, PT := tGoodQual);

		IF Para.rU_GrC_SetEUI1 >= 4.0 AND Para.rU_GrC_SetEUI2 >= 4.0 AND NOT TON_GoodQual_Uset_EU.Q THEN
			bMsg3596	:= TRUE;
			IF Para.bRelFreeze_Uset_EU AND bBuffer_Uset_EU THEN	
				rGCQ_USet := rLCRLimScal_UAct_old;
			END_IF
		ELSE
			bMsg3596	:= FALSE;		
			rGCQ_USet	:= IN_GR.tQU_GenC_Set.Ai ;
			IF Para.bRelFreeze_Uset_EU THEN	
				z_Uset := x_Uset - 8;
				IF bBuffer_Uset_EU THEN
					IF z_Uset >= 0 THEN
						rLCRLimScal_UAct_old := rBuffer_Uset_EU[z_Uset];
					ELSE
						rLCRLimScal_UAct_old := rBuffer_Uset_EU[z_Uset + 9];
					END_IF
				ELSE
					rLCRLimScal_UAct_old := 1.0;
				END_IF
			END_IF
		END_IF;	

	ELSE
		TON_GoodQual_Uset_EU(IN:= FALSE, PT:= T#0s);
		rGCQ_USet		:= 1.0;
		bMsg3596		:= FALSE;
	END_IF;
	
	(**************************************************)
	(* Selection of external U - Setpoint utility EU  *)
	(**************************************************)
	
	rGCQ_USetExt	:= 1.0;
	bGCQ_USetExt	:= FALSE;

	CASE Para.iU_GrC_SetX OF
		0:  (* NOT USED *)
			bGCQ_USetExt	:= FALSE;
		1:  (* INTERN *)
			rGCQ_USetExt	:= Para.rU_GrC_SetInt;(* % *)
			bGCQ_USetExt	:= TRUE;
		2:  (* EXTERN DI - spare *)
			rGCQ_USetExt	:= Para.rU_GrC_Set_Act_BU;
			bGCQ_USetExt	:= FALSE;
		3:  (* EXTERN BUS *)
			IF (bGenC_UQBC_ExtRel OR bU_GenC_ExtRel OR bGenC_UBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 3) OR (Para.iQ_GrC_CtrlFun = 4) OR (Para.iQ_GrC_CtrlFun = 7)) AND NOT IN_GR.bU_GenC_SetErrBC THEN
				rGCQ_USetExt	:= IN_GR.rGenC_UQBC;
			ELSE
				rGCQ_USetExt	:= Para.rU_GrC_Set_Act_BU;
			END_IF;
			bGCQ_USetExt	:= TRUE;
		4:  (* CUSTOM *)
			IF IN_GR.tU_GenC_SetCUST.GoodQual THEN
				rGCQ_USetExt	:= IN_GR.tU_GenC_SetCUST.Ai; (* % *)
			ELSE
				rGCQ_USetExt	:= Para.rU_GrC_Set_Act_BU;
			END_IF;		
			bGCQ_USetExt	:= TRUE;
		5:  (* EXTERN AI *)
			IF NOT MM2VIS.bMsg3596 OR Para.bRelFreeze_Uset_EU  THEN
					rGCQ_USetExt	:= rGCQ_USet;
			ELSE 
					rGCQ_USetExt	:= Para.rU_GrC_Set_Act_BU;
			END_IF;
			bGCQ_USetExt	:= TRUE;
		ELSE
			bGCQ_USetExt	:= FALSE;
	END_CASE;
		
		rGCQ_USet1 := rGCQ_USetExt;
		
		IF bU_GenC_ExtRel OR bGenC_UBC_ExtRel OR (Para.iQ_GrC_CtrlFun = 7) THEN	
			IF (Para.rS_Nom <> 0) THEN
				rQ_act1 := IN_GR.tQ_Act[iQPointCtrl].Ai / Para.rS_Nom; (*Q/S - p.u.*)
			END_IF;
			rGCQ_USet2 := (rGCQ_USet1 + (rQ_act1 * rDroop_GrC_U));
			OUT_GR.rU_Set_NP := rGCQ_USet2;       (* Uset -> GC/v_ctr = U control *)
			rQ_USet_pu := 2.0 * (rGCQ_USet2 - 1); (* Qset -> GC/Ctr_Q = Q control (old) *)
			OUT_GR.bU_Set_NP_Rel := TRUE;
		ELSE
			OUT_GR.bU_Set_NP_Rel := FALSE;
		END_IF;
	
	(*************************************)
	(* RESULTS - U - Setpoint utility EU *)
	(*************************************)
	rGCQ_USetExt;
	rQ_USet_pu;	
	bGCQ_USetExt;
	rURefV	:= rGCQ_USetExt;

	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
	MM2VIS.rU_set := rGCQ_USetExt;
	MM2VIS.rQ_Uctrl := rQ_USet_pu;
	
	MM2VIS.rGCQ_USet			:= rGCQ_USet;
	MM2VIS.rGCQ_USet_AI			:= IN_GR.tQU_GenC_Set.Ai;
//	MM2VIS.rGenC_UQBC			:= IN_GR.rGenC_UQBC;
//	MM2VIS.rGCQ_USetExt			:= rGCQ_USetExt;
//	MM2VIS.bGenC_PFBC_ExtRel	:= bGenC_UQBC_ExtRel;
		
	(******************************************)
	(*****FUNCTION #8 - TIME TABLE ************)
	(******************************************)	
	
		IF (Para.iQ_GrC_CtrlFun = 8) THEN
			rPF_TT := IN_GR.rPF_Set_TimeTable;
			IF (rPF_TT <> 0) AND (Para.rS_Nom <> 0) THEN
				rGCQ_PFSet_TT_pu := TAN(ACOS(rPF_TT)) * rPAct_GCFilt / Para.rS_Nom; (*Q/S - p.u.*)
			END_IF;
		END_IF;
	
	(******************************)
	(***** Interfaces to HMI  *****)
	(******************************)
		MM2VIS.rPF_set_tab := rPF_TT;
		MM2VIS.rQ_PFset_tab := rGCQ_PFSet_TT_pu;
			
			
		(****************************************************************)
		(********* prioritization****************************************)
		(****************************************************************)
//		Following priorities apply:
//			1: cosphi set --> rGCQ_PFSetExt_pu
//			2: cosphi(P)  --> rQP_PF_Set
//			3: cosphi(U)  --> rQU_PF_Set
//			4: Q(U)		  --> rQU_Set_Norm
//			5: Q(P)		  --> rQP_Setlin
//			6: Q set      --> rQ_QSet_pu
//			7: U control  --> rQ_USet_pu
//			8: time table --> rGCQ_PFSet_TT_pu
//			0: customer   --> rQ_Cust_Set_pu		

		OUT_GR.iGCQ_Fun_Act	:= 0;
		IF (Para.rS_Nom <> 0) THEN
			rQ_EU := IN_GR.tQ_Act[1].Ai / Para.rS_Nom; (*Q/S - p.u.*)
		END_IF;
		iPrio_Akt		:= 1000;
		(*Cosphi setpoint*)
		IF (bPF_GenC_ExtRel OR bGenC_PFBC_ExtRel) AND bstatGC_rel THEN
			OUT_GR.iGCQ_Fun_Act	:= 1;
			iPrio_Akt 		:= IN_GR.iGenC_PrioPF;
			rQ_EU 			:= rGCQ_PFSetExt_pu;
		END_IF;		
		(*Cosphi(P)*)
		IF OUT_GR.bPFP_Aktiv AND (IN_GR.iGenC_PrioPFPC < iPrio_Akt) THEN
			OUT_GR.iGCQ_Fun_Act	:= 2;	
			iPrio_Akt 		:= IN_GR.iGenC_PrioPFPC;
			rQ_EU			:= rQP_PF_Set;
		ELSE
			OUT_GR.bPFP_Aktiv	:= FALSE;
		END_IF;	
		(*Cosphi(U)*)		
		IF 	OUT_GR.bPFU_Aktiv AND (IN_GR.iGenC_PrioPFUC < iPrio_Akt) THEN
			OUT_GR.iGCQ_Fun_Act	:= 3;	
			iPrio_Akt		:= IN_GR.iGenC_PrioPFUC;
			rQ_EU			:= rQU_PF_Set;
		ELSE
			OUT_GR.bPFU_Aktiv	:= FALSE;
		END_IF;	
		(*Q(U)*)
		IF OUT_GR.bQU_Aktiv AND (IN_GR.iGenC_PrioQUC < iPrio_Akt) THEN
			OUT_GR.iGCQ_Fun_Act	:= 4;	
			iPrio_Akt		:= IN_GR.iGenC_PrioQUC;
			rQ_EU			:= rQU_Set_Norm;
		ELSE
			OUT_GR.bQU_Aktiv	:= FALSE;
		END_IF;	
		(*Q(P)*)
		IF OUT_GR.bQP_Aktiv AND (IN_GR.iGenC_PrioQP < iPrio_Akt) THEN
			OUT_GR.iGCQ_Fun_Act	:= 5;	
			iPrio_Akt		:= IN_GR.iGenC_PrioQP;
			rQ_EU			:= rQP_Setlin;
		ELSE
			OUT_GR.bQP_Aktiv	:= FALSE;
		END_IF;
		(*Q setpoint*)	
		IF (bQ_GenC_ExtRel OR bGenC_QBC_ExtRel) AND (IN_GR.iGenC_PrioQ < iPrio_Akt) AND bstatGC_rel THEN
			OUT_GR.iGCQ_Fun_Act	:= 6;	
			iPrio_Akt		:= IN_GR.iGenC_PrioQ;
			rQ_EU			:= rQ_QSet_pu;
		END_IF;
		(*U control*)
		IF (bU_GenC_ExtRel OR bGenC_UBC_ExtRel) AND (IN_GR.iGenC_PrioQUset < iPrio_Akt) AND bstatGC_rel THEN
			OUT_GR.iGCQ_Fun_Act	:= 7;	
			iPrio_Akt		:= IN_GR.iGenC_PrioQUset;
			rQ_EU			:= rQ_USet_pu;
		END_IF;
		(*Q setpoint customer*)
		IF (bGenC_QCustBC_ExtRel) AND (IN_GR.iGenC_PrioQCustSet < iPrio_Akt) AND bstatGC_rel THEN
			OUT_GR.iGCQ_Fun_Act	:= 0;	
			iPrio_Akt		:= IN_GR.iGenC_PrioQCustSet;
			rQ_EU			:= rQ_Cust_Set_pu;
		END_IF;
		(*HMI Parameter activations*)
		IF (OUT_GR.iGCQ_Fun_Act = 0) AND bstatGC_rel AND (NOT bGenC_QCustBC_ExtRel) THEN
			OUT_GR.iGCQ_Fun_Act	:= Para.iQ_GrC_CtrlFun;
			iPrio_Akt			:= Para.iQ_GrC_CtrlFun;
			CASE Para.iQ_GrC_CtrlFun OF
				0: (* CUSTOM *)
					rQ_EU := rQ_Cust_Set_pu;
					iPrio_Akt := 9;
				1: (* cosphi set *)
					rQ_EU := rGCQ_PFSetExt_pu;
				2: (* cosphi(P) *)
					rQ_EU := rQP_PF_Set;
				3: (* cosphi(U) *)
					rQ_EU := rQU_PF_Set;
				4: (* Q(U) *)
					rQ_EU := rQU_Set_Norm;
				5: (* Q(P) *)
					rQ_EU := rQP_Setlin;
				6: (* Q set *)
					rQ_EU := rQ_QSet_pu;
				7: (* U control *)
					rQ_EU := rQ_USet_pu;
				8: (* Time Table*)
					rQ_EU := rGCQ_PFSet_TT_pu;
			END_CASE;
		END_IF;
				
		(******************************)
		(***** Interfaces to HMI  *****)
		(******************************)
		MM2VIS.rQ_set := rQ_EU;
		
		(*Visualisation active function - when grid mode then active function, otherwise parameter selected*)
		IF bstatGC_rel THEN
			MM2VIS.iGCQ_Fun_Act	:= OUT_GR.iGCQ_Fun_Act;
		ELSE
			MM2VIS.iGCQ_Fun_Act := Para.iQ_GrC_CtrlFun;
		END_IF;
		(****************************************************)
		(***** RAMP FUNCTION FOR REACTIVE POWER CHANGES *****)
		(****************************************************)
		
		tiQ_Ramp  := Para.tiQ_Ramp;

		(* PT1 Filter behaviour acc.VDE4110 *)
		ti_AVR 	  := T#0.5s; (* settling time of the AVR control loop *)
		rTAU	  := (TIME_TO_REAL(Para.tiQ_Ramp) - TIME_TO_REAL(ti_AVR)) / (1000 * 3);

		xLCRPT1_Qset.enable := TRUE;
		xLCRPT1_Qset.t		:= rTAU;
		xLCRPT1_Qset.x		:= rQ_EU_QULim;//LE limitation have to be done with ramp acc.VDE4110
		xLCRPT1_Qset();
		
		(* PT2 Filter behaviour acc.VDE4120 *)
		rkT := 3;
		rD 	:= 0.8;
		xFILTER_PT2_QSet(In := rQ_EU_QULim, T := MAX(0.1, TIME_TO_REAL(Para.tiQ_Ramp) / MAX(1, rkT) / 1000), D := rD, Tsample := 0.1);

		IF Para.bQ_SetFilt_PT2 THEN rQ_EU_SetFilt := xFILTER_PT2_QSet.Out;	(* PT2 acc. VDE4120 *)
		ELSE						rQ_EU_SetFilt := xLCRPT1_Qset.y;		(* PT1 acc. VDE4110 *)
		END_IF;		

		(******************************)
		(***** Interfaces to HMI  *****)
		(******************************)
		MM2VIS.tiQ_RampFilt := Para.tiQ_Ramp;
		MM2VIS.rQ_set_filt := rQ_EU_SetFilt;
		
				
		(****************************************************************)
		(****** Q LIMITATION ********************************************)
		(****************************************************************)
		(*  release setpoint reactive power limitation (Qlim) from digital inputs *)
		xSR_QLim(SET1 := IN_GR.bQLim_GenC_SetEUCOn, RESET := IN_GR.bQLim_GenC_SetEUCOf);
		bGenC_QLim_ExtRel	:= xSR_QLim.Q1;

		(*  release setpoint reactive power limitation (Qlim) from bus *)
		xSR_BC_QLim(SET1 := IN_GR.bGenC_QLimBC_SetCOn, RESET := IN_GR.bGenC_QLimBC_SetCOf);
		bGenC_QLimBC_ExtRel	:= xSR_BC_QLim.Q1;

		IF Para.bDEIE_Active AND IN_GR.tP0_BLOCK_DEIE.Di THEN
			bGenC_QLim_ExtRel	:= FALSE;
			bGenC_QLimBC_ExtRel	:= FALSE;
		END_IF;

		(* Scaling external Q limitation EU - Hardware *)
		IF Para.bQ_GrC_SetEUCOn_Lim THEN
			(* Generation measurement signal interference *)
			IF Para.rQ_GrC_SetEUI1_Lim >= 4.0 AND Para.rQ_GrC_SetEUI2_Lim >= 4.0 AND IN_GR.tQLim_GenC_SetEU.GoodQual AND Para.bRelFreeze_QLim_EU THEN
				rBuffer_QLim_EU[x_QLim] := IN_GR.tQLim_GenC_SetEU.Ai;	
				x_QLim := x_QLim + 1;
				IF x_QLim > 9 THEN
					x_QLim := 0;
				bBuffer_QLim_EU := TRUE;
			END_IF
		END_IF
		
		IF NOT bBuffer_QLim_EU THEN
			rLCRLimScal_QLim_old := 100000;
		END_IF;	

		TON_GoodQual_QLim_EU(IN := IN_GR.tQLim_GenC_SetEU.GoodQual, PT := tGoodQual);

		IF Para.rQ_GrC_SetEUI1_Lim >= 4.0 AND Para.rQ_GrC_SetEUI2_Lim >= 4.0 AND NOT TON_GoodQual_QLim_EU.Q THEN
				bMsg3595	:= TRUE;
			IF Para.bRelFreeze_QLim_EU AND bBuffer_QLim_EU THEN	
				rGCQ_QLim := rLCRLimScal_QLim_old;
			END_IF
			ELSE
				bMsg3595	:= FALSE;		
				rGCQ_QLim	:= IN_GR.tQLim_GenC_SetEU.Ai;
			IF Para.bRelFreeze_QLim_EU THEN	
				z_QLim := x_QLim - 8;
				IF bBuffer_QLim_EU THEN
					IF z_QLim >= 0 THEN
						rLCRLimScal_QLim_old := rBuffer_QLim_EU[z_QLim];
					ELSE
						rLCRLimScal_QLim_old := rBuffer_QLim_EU[z_QLim + 9];
					END_IF
				ELSE
					rLCRLimScal_QLim_old := 100000;
				END_IF
			END_IF
			END_IF;	

		ELSE
			TON_GoodQual_QLim_EU(IN:= FALSE, PT:= T#0s);
			rGCQ_QLim		:= 100000;
			bMsg3595		:= FALSE;
		END_IF;

		Para.rQ_GrC_SetAct_Lim_BU;

		(****************************************)
		(* Selecting external Q - Limitation EU *)
		(****************************************)
	
		rGCQ_QLimExt	:= 100000;
		bGCQ_QLimExt	:= FALSE;

		IF bGenC_QLim_ExtRel THEN
			IF Para.bQ_GrC_SetEUCOn_Lim AND (NOT MM2VIS.bMsg3595 OR Para.bRelFreeze_QLim_EU) THEN
				rGCQ_QLimExt	:= MIN(rGCQ_QLimExt, rGCQ_QLim);
				bGCQ_QLimExt	:= TRUE;
			ELSE
				rGCQ_QLimExt	:= MIN(rGCQ_QLimExt, Para.rQ_GrC_SetAct_Lim_BU);
				bGCQ_QLimExt	:= TRUE;
			END_IF;
		ELSIF bGenC_QLimBC_ExtRel THEN
			IF NOT MM2VIS.bMsg3595 THEN
				rGCQ_QLimExt	:= MIN(rGCQ_QLimExt, IN_GR.rGenC_QLimBC);
				bGCQ_QLimExt	:= TRUE;
			ELSE
				rGCQ_QLimExt	:= MIN(rGCQ_QLimExt, Para.rQ_GrC_SetAct_Lim_BU);
				bGCQ_QLimExt	:= TRUE;
			END_IF;
		ELSE
			rGCQ_QLimExt	:= MIN(rGCQ_QLimExt, Para.rQ_GrC_SetAct_Lim_BU);
			bGCQ_QLimExt	:= TRUE;		
		END_IF;
		
		//	17.06.2014
		IF ((bGenC_QLim_ExtRel OR bGenC_QLimBC_ExtRel)AND xOpMode.NetP) THEN
			IF (NOT IN_GR.tP0_BLOCK_DEIE.Di  OR NOT Para.bDEIE_Active) THEN  (*nur aktiv wenn ERDF nicht aktiv oder Customer Switch nicht aktiv ist *)
				OUT_GR.bQLim_Aktiv	:= TRUE;
			ELSE
				OUT_GR.bQLim_Aktiv	:= FALSE;
			END_IF
		ELSE
			OUT_GR.bQLim_Aktiv	:= FALSE;
		END_IF;
		
		(* Calculate the Q setpoint per unit *)
		IF bGCQ_QLimExt THEN
			IF (Para.rS_Nom <> 0) THEN
				rQ_QLim_pu := rGCQ_QLimExt / Para.rS_Nom; (* Q/S - p.u.*)
			END_IF;
		END_IF;	

		(******************************)
		(* RESULTS - Q - LIMIT		  *)
		(******************************)
		rQ_QLim_pu;
		rPF_QLim;
		bGCQ_QLimExt;	
		
		(******************************)
		(***** Interfaces to HMI  *****)
		(******************************)

		MM2VIS.rGCQ_QLim			:= rGCQ_QLim;
		MM2VIS.rGenC_QLimBC			:= IN_GR.rGenC_QLimBC;
		MM2VIS.rGCQ_QLimExt			:= rGCQ_QLimExt;
		MM2VIS.rPF_QLim				:= rPF_QLim;
		MM2VIS.bGenC_QLim_ExtRel	:= bGenC_QLim_ExtRel;
		MM2VIS.bGenC_QLimBC_ExtRel	:= bGenC_QLimBC_ExtRel;
		MM2VIS.bP0_BLOCK_DEIE		:= IN_GR.tP0_BLOCK_DEIE.Di;
		MM2VIS.rGCQ_QLim_AI			:= IN_GR.tQLim_GenC_SetEU.Ai;				(*// for diagnosis*)

		(* TEIL I - EINGRIFF / ÜBERSCHREIBEN des COSPHI-Sollwerts durch die stat. GR Funktionen - START *)
//		IF OUT_GR.iGCQ_Fun_Act <> 0 THEN
//			OUT_GR.rPFSoll_lin_GR2GC	:= rPF_EU; (*rPF_EU;*)			(* Übergabe der PF Vorgabe durch EVU Funktionen  *)
//		ELSE		
//			OUT_GR.rPFSoll_lin_GR2GC	:= IN_GR.rPFSoll_lin_GC2GR; 	(* keine EVU Funktion --> Rückgabe des eingelesenen Wertes *)
//		END_IF;	
		
		OUT_GR.rQSoll_filt_GR2GC	:= rQ_EU_SetFilt; (* rQ_EU after ramp filter *)
		
		(* TEIL I - EINGRIFF / ÜBERSCHREIBEN des COSPHI-Sollwerts durch die stat. GR Funktionen - ENDE *)
		
		
		(*Apply external Q Limitation to the final Q setpoint*)
		bQLim_Greift := FALSE;
		OUT_GR.rQSoll_Lim_GR2GC := OUT_GR.rQSoll_filt_GR2GC;
		IF OUT_GR.bQLim_Aktiv THEN
			(* Limit Q NEGATIV - Erlaubter Bereich, POSITIV oder NEGATIV wenn <= Limit*)
			IF (rQ_QLim_pu < 0.0) AND (OUT_GR.rQSoll_filt_GR2GC < 0.0) AND (OUT_GR.rQSoll_filt_GR2GC <= rQ_QLim_pu) THEN
				OUT_GR.rQSoll_Lim_GR2GC 		:= rQ_QLim_pu;			(* Rückgabe des limitierten Wertes *)
				bQLim_Greift	:= TRUE;
				(* Limit Q POSITIV - Erlaubter Bereich, NEGATIV oder POSITIV wenn >= Limit*)
			ELSIF (rQ_QLim_pu > 0.0) AND (OUT_GR.rQSoll_filt_GR2GC > 0.0) AND (OUT_GR.rQSoll_filt_GR2GC >= rQ_QLim_pu) THEN
				OUT_GR.rQSoll_Lim_GR2GC 		:= rQ_QLim_pu;			(* Rückgabe des limitierten Wertes *)
				bQLim_Greift	:= TRUE;
				(* Qlim exakt 0kVAr --> Q wird auf 0.000 fixiert *)
			ELSIF (rQ_QLim_pu = 0.0) AND (OUT_GR.rQSoll_filt_GR2GC <> 0.0) THEN
				OUT_GR.rQSoll_Lim_GR2GC 		:= rQ_QLim_pu;			(* Rückgabe des limitierten Wertes *)
				bQLim_Greift	:= TRUE;				
			ELSE
				bQLim_Greift := FALSE;
			END_IF;
		END_IF;	

		(* Feedback signals *)
		IF MM2VIS.bMsg2863 THEN
			OUT_GR.tQLim_GenC_SOn.Do	:= TRUE;
			OUT_GR.tQLim_GenC_SOf.Do	:= FALSE;
		ELSE
			OUT_GR.tQLim_GenC_SOn.Do	:= FALSE;
			OUT_GR.tQLim_GenC_SOf.Do	:= TRUE;
		END_IF;
	
		OUT_GR.tQLim_GenC_Act.Do	:= MM2VIS.bMsg2862;
		
		(* Q-Limitierung - ENDE *)
		
		(*******************************************************)
		(***** Limitation Q set based on Q(U) (Bayernwerk) *****)
		(*******************************************************)
		bQ_Lim_QU_Rel := (rQ_Set_ToLim <> rQSet_QULim);
		IF Para.bQLim_QU_active AND(OUT_GR.iGCQ_Fun_Act = 1 OR OUT_GR.iGCQ_Fun_Act = 6) THEN//LE separate QLim curve added
			IF bTestQLim THEN
				rQ_Set_ToLim := rQSetTest;
			ELSE
				rQ_Set_ToLim := rQ_EU;//LE limitation have to be done with ramp acc.VDE4110
			END_IF;
			rQ_EU_QULim := rQSet_QULim;//LE
		ELSE
			rQ_EU_QULim := rQ_EU;//LE
		END_IF;
		
		(*send signal that indicates that any of the two limitation functions are activated*)
		OUT_GR.bQSetLim := (bQLim_Greift) OR (bQ_Lim_QU_Rel);
		
	(****************************************************************)
	(***** Generate event messages **********************************)
	(****************************************************************)
	(* Generate hardware signals *)
	OUT_GR.tQPC_GenC_SOn.Do	:= OUT_GR.bPFP_Aktiv;
	OUT_GR.tQPC_GenC_SOf.Do	:= NOT OUT_GR.bPFP_Aktiv;
	
	(* Generate hardware signals *)
	OUT_GR.tPFUC_GenC_SOn.Do	:= 	OUT_GR.bPFU_Aktiv;
	OUT_GR.tPFUC_GenC_SOf.Do	:= NOT 	OUT_GR.bPFU_Aktiv;

	(* Generate hardware signals *)
	OUT_GR.tQUC_GenC_SOn.Do	:= OUT_GR.bQU_Aktiv;
	OUT_GR.tQUC_GenC_SOf.Do	:= NOT OUT_GR.bQU_Aktiv;

	(* Generate hardware signals *)
		OUT_GR.tQP_GenC_SOn.Do	:= OUT_GR.bQP_Aktiv;
		OUT_GR.tQP_GenC_SOf.Do	:= NOT OUT_GR.bQP_Aktiv;

		(* Generate hardware signals *)
	IF MM2VIS.bMsg2858 THEN
		OUT_GR.tPF_GenC_SOn.Do	:= TRUE;
		OUT_GR.tPF_GenC_SOf.Do	:= FALSE;
	ELSE
		OUT_GR.tPF_GenC_SOn.Do	:= FALSE;
		OUT_GR.tPF_GenC_SOf.Do	:= TRUE;
	END_IF;

	(* Generate hardware signals *)
	IF 	MM2VIS.bMsg2860 THEN
		OUT_GR.tQ_GenC_SOn.Do	:= TRUE;
		OUT_GR.tQ_GenC_SOf.Do	:= FALSE;
	ELSE
		OUT_GR.tQ_GenC_SOn.Do	:= FALSE;
		OUT_GR.tQ_GenC_SOf.Do	:= TRUE;		
	END_IF;
	
	(****************************************************************)
	(************** FEEDBACK TO GENERATE ****************************)
	(****************************************************************)

	(* COSPHI - fixed value *)
	OUT_GR.tPF_GenC_Fix1SOn.Do	:= FALSE;
	OUT_GR.tPF_GenC_Fix2SOn.Do	:= FALSE;
	OUT_GR.tPF_GenC_Fix3SOn.Do	:= FALSE;
	OUT_GR.tPF_GenC_Fix4SOn.Do	:= FALSE;
	OUT_GR.tPF_GenC_Fix5SOn.Do	:= FALSE;

	IF (OUT_GR.iGCQ_Fun_Act = 1) AND (Para.iQPF_GrC_SetEUCOn = 2) THEN
		xTON_PFEU5(IN := IN_GR.PF_GenC_SetFix5 , PT := T#10s); 
		xTON_PFEU4(IN := IN_GR.PF_GenC_SetFix4 , PT := T#10s);
		xTON_PFEU3(IN := IN_GR.PF_GenC_SetFix3 , PT := T#10s);
		xTON_PFEU2(IN := IN_GR.PF_GenC_SetFix2 , PT := T#10s);
		xTON_PFEU1(IN := IN_GR.PF_GenC_SetFix1 , PT := T#10s);
		IF IN_GR.PF_GenC_SetFix5 THEN
			OUT_GR.tPF_GenC_Fix5SOn.Do	:= xTON_PFEU5.Q;	
		ELSIF IN_GR.PF_GenC_SetFix4 THEN
			OUT_GR.tPF_GenC_Fix4SOn.Do	:= xTON_PFEU4.Q;	
		ELSIF IN_GR.PF_GenC_SetFix3 THEN
			OUT_GR.tPF_GenC_Fix3SOn.Do	:= xTON_PFEU3.Q;	
		ELSIF IN_GR.PF_GenC_SetFix2 THEN
			OUT_GR.tPF_GenC_Fix2SOn.Do	:= xTON_PFEU2.Q;	
		ELSIF IN_GR.PF_GenC_SetFix1 THEN
			OUT_GR.tPF_GenC_Fix1SOn.Do	:= xTON_PFEU1.Q;	
		END_IF;
	ELSE
		xTON_PFEU5(IN:= FALSE, PT:= T#0s);
		xTON_PFEU4(IN:= FALSE, PT:= T#0s);
		xTON_PFEU3(IN:= FALSE, PT:= T#0s);
		xTON_PFEU2(IN:= FALSE, PT:= T#0s);
		xTON_PFEU1(IN:= FALSE, PT:= T#0s);
	END_IF;

	(* Q - fixed value *)
	OUT_GR.tQ_GenC_Fix1SOn.Do	:= FALSE;
	OUT_GR.tQ_GenC_Fix2SOn.Do	:= FALSE;
	OUT_GR.tQ_GenC_Fix3SOn.Do	:= FALSE;
	OUT_GR.tQ_GenC_Fix4SOn.Do	:= FALSE;
	OUT_GR.tQ_GenC_Fix5SOn.Do	:= FALSE;

	IF (OUT_GR.iGCQ_Fun_Act = 6) AND (Para.iQ_GrC_SetX = 2) THEN
		xTON_QEU5(IN := IN_GR.Q_GenC_SetFix5, PT := T#10s);
		xTON_QEU4(IN := IN_GR.Q_GenC_SetFix4, PT := T#10s);
		xTON_QEU3(IN := IN_GR.Q_GenC_SetFix3, PT := T#10s);
		xTON_QEU2(IN := IN_GR.Q_GenC_SetFix2, PT := T#10s);
		xTON_QEU1(IN := IN_GR.Q_GenC_SetFix1, PT := T#10s);
		IF IN_GR.Q_GenC_SetFix5 THEN
			OUT_GR.tQ_GenC_Fix5SOn.Do	:= xTON_QEU5.Q;	
		ELSIF IN_GR.Q_GenC_SetFix4 THEN
			OUT_GR.tQ_GenC_Fix4SOn.Do	:= xTON_QEU4.Q;	
		ELSIF IN_GR.Q_GenC_SetFix3 THEN
			OUT_GR.tQ_GenC_Fix3SOn.Do	:= xTON_QEU3.Q;	
		ELSIF IN_GR.Q_GenC_SetFix2 THEN
			OUT_GR.tQ_GenC_Fix2SOn.Do	:= xTON_QEU2.Q;	
		ELSIF IN_GR.Q_GenC_SetFix1 THEN
			OUT_GR.tQ_GenC_Fix1SOn.Do	:= xTON_QEU1.Q;	
		END_IF;
	ELSE
		xTON_QEU5(IN:= FALSE, PT:= T#0s);
		xTON_QEU4(IN:= FALSE, PT:= T#0s);
		xTON_QEU3(IN:= FALSE, PT:= T#0s);
		xTON_QEU2(IN:= FALSE, PT:= T#0s);
		xTON_QEU1(IN:= FALSE, PT:= T#0s);
	END_IF;	

ELSE
	TON_GoodQual_PF_EU(IN:= FALSE, PT:= T#0s);
	TON_GoodQual_Qset_EU(IN:= FALSE, PT:= T#0s);
	TON_GoodQual_Uset_EU(IN:= FALSE, PT:= T#0s);
	TON_GoodQual_QLim_EU(IN:= FALSE, PT:= T#0s);
	xTON_PFEU5(IN:= FALSE, PT:= T#0s);
	xTON_PFEU4(IN:= FALSE, PT:= T#0s);
	xTON_PFEU3(IN:= FALSE, PT:= T#0s);
	xTON_PFEU2(IN:= FALSE, PT:= T#0s);
	xTON_PFEU1(IN:= FALSE, PT:= T#0s);
	xTON_QEU5(IN:= FALSE, PT:= T#0s);
	xTON_QEU4(IN:= FALSE, PT:= T#0s);
	xTON_QEU3(IN:= FALSE, PT:= T#0s);
	xTON_QEU2(IN:= FALSE, PT:= T#0s);
	xTON_QEU1(IN:= FALSE, PT:= T#0s);

	OUT_GR.bU_Set_NP_Rel := FALSE;
END_IF;
	
(*********************************************************************************************************)
(************* AO - SCALE VALUES FOR THE MOMENT   ********************************************************)
(*********************************************************************************************************)

(* Scaling AO - Q - Feedback [kvar] *) (**GFL: TO reference to point of control**)
rQAct := IN_GR.tQ_Act[1].Ai;
IF Para.bQAO_GrC_SetCOn THEN
	xLCRLimScal_QAct(x := rQAct, x1 := Para.rQAO_GrC_SetP1, y1 := 0.2, x2 :=  Para.rQAO_GrC_SetP2, y2 := 1);
ELSE
	xLCRLimScal_QAct(x := rQAct, x1 := Para.rQAO_GrC_SetP1, y1 := 0.0, x2 := Para.rQAO_GrC_SetP2, y2 := 1);
END_IF;
OUT_GR.tQ_GenC_Act.Ao := xLCRLimScal_QAct.y;

(* Scaling AO - cos(phi) - Feedback *)
IF IN_GR.tPF_Act[1].Ai < 0 THEN
	rPFact := IN_GR.tPF_Act[1].Ai + 2;
ELSE
	rPFact := IN_GR.tPF_Act[1].Ai;
END_IF;

IF Para.rPFAO_GrC_SetP1 < 0 THEN 
	xLCRLimScal_PFAct.x1 := Para.rPFAO_GrC_SetP1 + 2; (* add 2 for the linearisation of a negative power factor *)
ELSE
	xLCRLimScal_PFAct.x1 := Para.rPFAO_GrC_SetP1;
END_IF;

IF Para.rPFAO_GrC_SetP2 < 0 THEN
	xLCRLimScal_PFAct.x2 := Para.rPFAO_GrC_SetP2 + 2; (* add 2 for the linearisation of a negative power factor *)
ELSE
	xLCRLimScal_PFAct.x2 := Para.rPFAO_GrC_SetP2;
END_IF;	

IF Para.bPFAO_GrC_Set4mA THEN
	xLCRLimScal_PFAct(x := rPFact, y1 := 0.2, y2 := 1);
ELSE
	xLCRLimScal_PFAct(x := rPFact, y1 := 0.0, y2 := 1);
END_IF;

OUT_GR.tPF_GenC_Act.Ao := xLCRLimScal_PFAct.y;

END_PROGRAM
