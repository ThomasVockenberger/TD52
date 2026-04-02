(*******************************************************************************
pf_cust 		Q-setpoint scaling for AVR
				
This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V2.50.1	12.06.2009	Wasserer.	new
V2.60.0	12.08.2009	lettenb.	setpoint Umschaltung über kontakte transfered to pf_ctr		
								(new parameter structure)
								task: reg_8gen(V2.50.2) included
					Tinello.	Changed reg8 into reg13		
		27.10.2009	lettenb		bPF_AO_mA, AO_PF_gen removed
								separated outputs: OUT_GC.tPF_AO_PF_I, OUT_GC.rPF_AO_PF_U new
		30.11.2009	lettenb.	REG13.y := yBlock; ( ohne Rampe bei Block2 ) added 
								(vermeidung von spannungsüberhöhungen bei umschaltung auf spgs.regler)
V3.20.0	24.03.2010	lettenb.	OUT_GC.rT_AO_Gen_T_In	added (UNITROL internal gen.power limitation)
		07.12.2010				u_offset_mA,u_offset_V added for v_matching
V3.99.9 13.02.2014  ganguly	    changed:
									 1. tPF_AO_PF_U to rPF_AO_PF_U
 									 2. tPF_AO_PF_I to rPF_AO_PF_I
									 3.	tCtrGenPF_Set to rCtrGenPF_Set
								These signals will be used as input to grid module and set from there 
								because Grid module has priority over the AVR setpoint.
V4.01.0	14.05.2014	Denk		Bugfix, Intake air temp. for generator controller 
					lettenb.	missing scaling added(acc.a_v3500) for user spec.signal correction	
								missing rU_Gen_Diff_Match_U added(acc.a_v3500)
V4.01.1 06.03.2015	lettenb.	920, Para.bT_GenAirIn_Active added
V4.03.0	02.05.2016				xSigScal_PF.Y1: -0.700 -> +0.700, bugfix
V4.04.0	29.06.2016				tGen_T_In2.Ai, rP_Red_T_GenAirIn_Norm added, Dig142
        25.07.2016				tQ_AVR_Set_U.Ao: Q-vorgabe -> UNITROL, 
								CtrGenPF: y-range 0-100% = 0,9kap. - 1 - 0,7ind. => 0,0kap. - 1 - 0,0ind.
		27.10.2016				rFactorU_Match removed, bugfix
		07.04.2017				rQ_AVR_Set: limitation FOR rPFSoll_lin_AVR added, TAN(ACOS(2-2) darf nicht 0 werden -> + unendlich, bugfix 
V4.05.0 30.11.2017	lettenb.	GR redesign, PF control -> Q control
V4.05.1	15.03.2018				yBlock: fix 10 -> 2% Q, lastrampe bis aktivierung Q-controller, request vogl lukas
V4.07.0	03.06.2019	lettenb.	calc.rPF_POC_Set related to S_Nom(Lukas), set rPF_POC_Set := 1.0 in case of yBlock for PF control(DM110), bugfix
V4.12.0	05.12.2022	lettenb.	DIG142 Generator Air Inlet Temperature Power Reduction from: Tmax -> Tavg value of 2 sensors(QC1807)

Instructions for use:
--------------------

 
FUNCTION DIAGRAM:

+------------------------------------------------------------+
| Pred(U<>), Pred(f<>), Pred(Twind) ----------------------------------------> opstate
| PF_lim(Twind)                                              |
| Q_lim(PWA) polar wheel angel                               |
| PF_Timetable -------------------------------------------------------------> GR
+------------------------------------------------------------+
                              |
                              V
+------------------------------------------------------------+
| calculation PF_lim(Twind) -> QLim_Twind                    |
|                                                            |                GR
| depending on P_Act                                         |              +--------------------------------------------------+
|                                  IN_GC.rQSoll_filt_GR2GC[%] <---------------- OUT_GR.rQSoll_filt_GR2GC[%]                    |
|                                  IN_GC.rQSoll_lim_GR2GC [%] <---------------- OUT_GR.rQSoll_lim_GR2GC [%]                    |
|                                                            |              |   including limitation of Q(U) and QLim_External |
+------------------------------------------------------------+              +--------------------------------------------------+
                              | rQSoll_filt_GR2GC                                                
                              V
                    +-------------------+
rQ_Lim_T_GenWind -->|      LIMITER      |
rQ_Lim_PWA       -->|                   |
rQ_Lim_PF        -->+-------------------+
                              |
                              V                                                             
                              |                                             +------------------------------------------------------+ 
                              |                                             | Block_CtrGenPF:                      (task: pf_cust) |
                              |                                             | - engine operation state(bPF_CosPCtr_block)          |
   +--------------------------+                                             |   rPF_CosPCtr_block                                  | 
   |                                                                        +------------------------------------------------------+ 
   |                                                                        | U control(idle mode/synchroniz., rU_Gen_Diff_Match_U |
   |                                                                        +------------------------------------------------------+ 
   |          +-------------------------------------------------------+          |
   |          |   Ctr_Q(Reg33)                              direct    |          |                    
   v          |  +-----------+                              control   |          +
   rQ_Set_Lim-+--|\ W        |                                 \      v +         \     
                 | )        Y|-------------------------------+  o---->0---------+  o--------------------- Q_AVR_Set_U.Ao
rQ_POC_Act_Norm -|/ X        | tCtr_Q_Out.Y                         +   rQ_Set_sum        rQ_AVR_Set
                 +-----------+                      
                            
   Q_Set                      y       Q 
    -1.0%(=-100%)          -1.0% = -100%                                             81.0 % Qnom = +8.16 V = cosphi 0.7  ind.
     0.0%(=   0%)           0.0% =    0%                                             60.0 % Qnom = +6.00 V = cosphi 0.8  ind.
    +1.0%(=+100%)          +1.0% = +100%                        overexcited          38.7 % Qnom = +3.87 V = cosphi 0.9  ind.
                                                               -------------------    0.0 % Qnom =  0.00 V = cosphi 1.0      
                                                                underexcited        -26.3 % Qnom = -2.63 V = cosphi 0.95 cap.



												 +---------------------------------------+
												 | calculation rQ_AVR_Set -> rPF_POC_Set |
												 +---------------------------------------+			    
                                                                     |															   
                                                                     |  +------------+       
                                                                     +--| scal. AO_V |-------PF_AO_PF_U  => AVR cosphi_setpoint +/-10V
                                                                     |  +------------+
                                                                     |                                 cosphi 0.0 ind. = +10.0 V                                      
                                                                     |                                 cosphi 0.7 ind. =  +3.0 V = 20.0 mA 
                                                                     |             overexcited         cosphi 0.8 ind. =  +2.0 V = 17.3 mA                     
                                                                     |             ------------------- cosphi 1.0      =   0.0 V = 12.0 mA 
                                                                     |             underexcited        cosphi 0.95cap. =  -0.5 V = 10.6 mA
                                                                     |                                 cosphi 0.9 cap. =  -1.0 V =  9.3 mA 
                                                                     |                                 cosphi 0.0 cap. = -10.0 V    
                                                                     |  +------------+
                                                                     +--| scal. AO_mA|-------PF_AO_PF_I => AVR cosphi_setpoint 4/20mA
                                                                        +------------+ 
 
 
Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC
	
// bestand:
	(* MMU values:     Werte von -0.0 .. -0.999 (untererregt) und 1.000 .. 0.00 (uebererregt) zulässig *) (* = 0,0 cap. .. 1 .. 0,0 ind. MMU values   *)
	(* PF lineariezed: Werte von  2.0 ..  1.001 (untererregt) und 1.000 .. 0.00 (uebererregt) zulässig *) (* = 0,0 cap. .. 1 .. 0,0 ind. LINEARISIERT *)

	(* linearization typical values *)
	(*  MMU    .. PF_lin .. PF                    *)
	(*  0.0    .. 0.0    .. 0.0  uebererregt(ind) *)
	(*  0.8    .. 0.8    .. 0.8  uebererregt(ind) *)
	(*  1.0    .. 1.0    .. 1.0                   *)
	(* -0.95   .. 1.05   .. 0,95 untererregt(cap) *)
	(*  0.0    .. 2.00   .. 0,0  untererregt(cap) *)


	(* ================================================================================================== *)
	(* linearisierung *)
	(*   y    .. PF_lin .. PF                   *)
	(*   0 %  .. 2.00   .. 0,0 untererregt(cap) *) 
	(*  45 %  .. 1.10   .. 0,9 untererregt(cap) *)
	(*  50 %  .. 1.00   .. 1,0                  *)
	(*  80 %  .. 0.80   .. 0,8 uebererregt(ind) *)
	(* 100 %  .. 0.0    .. 0,0 uebererregt(ind) *)

	(* setting für mA or V -output *)
	(* mA for controller type BASLER DM110, NEWAGE RCI, AVK QPF *)	(* PF-Range mA Standard: -0,7 .. +0,7 =  4-20mA     *)
	(*  V for controller type BASLER DECS 100, ABB Unitrol,.... *)	(* PF-Range  V Standard: -0,7 .. +0,7 = -3V ... +3V *)
	(* ================================================================================================== *)

	(* P-limit for PF-controller with fixed values *) (* e.g. setpoint for cosphi 0,8 after sy *)	
	GW_P_pfctr_fix := 0.250;	(* %P_Nom *)
	HY_P_pfctr_fix := 0.050;	(* %P_Nom *)
	
	(* PF-value for fixed PF-controller *)
	PF_1_fix := 1.000;		(* cosphi 1,0 *)
	PF_2_fix := 0.800;		(* cosphi 0,8 *)

	(* value for range without PF-controller *)
	U_fix := 1.000;
	
	(* ================================================================================================== *)
	(* PF-controller y fixed values *)
	(* P-limit *)	
	xGR_MIN_PF_STELL(In := IN_GC.rP_Act_Norm_Filt, Gw := GW_P_pfctr_fix, Hy := HY_P_pfctr_fix);
	bPF_CosPCtr_Hold := xGR_MIN_PF_STELL.Q;
	
	(* controller stati *)
	IF Para.bPF_CosPCtr_Ena (*AND Para.iPF_CosPCtr_Choice > 0*) THEN
		IF NOT OUT_GC.tPF_CosPCtr_Ena.Do THEN 							
			yBlock  := 0.0;							(* 0% Q für cosphi 1.0 settings for idle run/engine stop [U-BEREICH] *)			
			bBlock  := TRUE;						(* ohne Rampe bei Block2 *)
		ELSIF bPF_CosPCtr_Hold AND IN_GC.bEng_Dem THEN
			yBlock  := 0.02;						(* fix 2% Q, lastrampe bis aktivierung Q-controller *)			
			bBlock  := TRUE;        				(* ohne Rampe bei Block2 *)
		ELSIF bPF_CosPCtr_Hold AND NOT IN_GC.bEng_Dem THEN
			yBlock  := 0.0;							(* cosphi 1.0 settings for deloading for engine stop *)			
			bBlock  := TRUE;
		ELSE
			yBlock  := 0.0;							(* Spare *)
			bBlock  := FALSE;						(* controller modus [PF_Bereich] *)
		END_IF;     
	ELSE
			yBlock  := 0.0;							(* without PF controller [U-BEREICH] *)			
			bBlock  := TRUE;						(* ohne Rampe bei Block2 *)
	END_IF;

	
	//	(* Rangierung auf Regler *)
	OUT_GC.rPF_CosPCtr_block := yBlock;
	OUT_GC.bPF_CosPCtr_block := bBlock;
	
	
	(*------------------------------------------------------------------------------------------------------*)
	(* summation                                                                                            *)
	(*------------------------------------------------------------------------------------------------------*)
	rQ_Set_Lim;		(* from pf_ctr *)
	tCtr_Q_Out.Y;	(* ctr op.point: y = -1,0..0..+1,0  = -100%Qnom..0..+100%Qnom  *)

	CASE Para.iQ_GrC_PointCtrl OF
	0:	rQ_Set_Sum := rQ_Set_Lim + tCtr_Q_Out.Y;(* customer signal *)
	1:	rQ_Set_Sum := rQ_Set_Lim + tCtr_Q_Out.Y;(* MMD1 generator *)
	2:	rQ_Set_Sum := rQ_Set_Lim + tCtr_Q_Out.Y;(* MMD2 mains *)
	3:	rQ_Set_Sum := rQ_Set_Lim;               (* direct control without controller *)
	ELSE
		rQ_Set_Sum := rQ_Set_Lim + tCtr_Q_Out.Y;
	END_CASE;

		
	(*------------------------------------------------------------------------------------------------------*)
	OUT_GC.tPF_CosPCtr_Ena.Do;	 		 (* release gen.controller *)	
	MM2VIS.bSel_AVR_Set := OUT_GC.tPF_CosPCtr_Ena.Do AND NOT bBlock;

	
	(*------------------------------------------------------------------------------------------------------*)
	(* Q_Set selection depending on engine operation status *)
	IF MM2VIS.bSel_AVR_Set THEN	rQ_AVR_Set := rQ_Set_Sum;	                                (* controller value -> AVR *)
    ELSE                        rQ_AVR_Set := OUT_GC.rPF_CosPCtr_block + rU_Gen_Diff_Match; (* engine operation depending set value *)				
	END_IF;
	
	rQ_AVR_Set := LIMIT(Para.rQ_UnderExc_Lim, rQ_AVR_Set, Para.rQ_OverExc_Lim);
	
	MM2VIS.rQ_AVR_Set_Norm := rQ_AVR_Set;//display15	
	
	
	(*======================================================================================================*)
	(* calculation rPF_POC_Set from rQ_Set_Sum (P_Act related to S_Nom!) *)
	IF    bBlock                    THEN rPF_POC_Set := 1.0;//yBlock for PF control;
	ELSIF Para.iQ_GrC_PointCtrl = 2 THEN
		IF	Para.rS_Nom > 0            THEN rPF_POC_Set := COS(ATAN(rQ_Set_Sum /(IN_GC.tP_Act[2].Ai/Para.rS_Nom)));(* erg.ohne vorzeichen! *)
		END_IF;
		IF rQ_Set_Sum < 0.0			   THEN rPF_POC_Set := rPF_POC_Set * (-1);	
		END_IF;
	ELSE  														(* 1 or 3(direct control: P_Act[1]) *)
		IF	Para.rS_Nom > 0            THEN rPF_POC_Set := COS(ATAN(rQ_Set_Sum /(IN_GC.tP_Act[1].Ai/Para.rS_Nom)));(* erg.ohne vorzeichen! *)
		END_IF;	
		IF rQ_Set_Sum < 0.0			   THEN rPF_POC_Set := rPF_POC_Set * (-1);	
		END_IF;	
	END_IF;

	(* linearization rPF_POC_Act *)
	(* +0,7(ind/overexc.)..1,0..-0,7(cap/underexc.) ==> 0,70 .. 1,00 .. 1,30 *)	
	IF rPF_POC_Set >= 0 THEN rPF_POC_Set_lin := rPF_POC_Set;
	ELSE					 rPF_POC_Set_lin := rPF_POC_Set + 2.000;
	END_IF;
	
	(*------------------------------------------------------------------------------------------------------*)
	(* Werte für mA Ausgang*)
	(* PF setpoint y = 0.0 to 1.0 to 2.0 = 0.0ind. to 1.0 to 0.0cap. *)
	(* calculation voltage value for PF_lin = 1.30 = cosphi 0.7cap =  4.0mA *)
	(* calculation voltage value for PF_lin = 1.10 = cosphi 0.9cap =  9.3mA *)
	(* calculation voltage value for PF_lin = 0.70 = cosphi 0.7ind = 20.0mA *)
	xSigScal_PF_I(X := rPF_POC_Set_lin, X1 := 1.30, Y1 := 4.0, X2 := 0.70 , Y2 := 20.0);

	(* Output current restricted between 9.3mA to 20mA this corresponds to *)
    (* Restricted output range based on checklist 9.3mA TO 20.0mA *)
	OUT_GC.tPF_AO_PF_I.Ao := LIMIT(9.3, xSigScal_PF_I.Y_SCAL + rU_Gen_Diff_Match_I, 20.0);	

	(*------------------------------------------------------------------------------------------------------*)
	(* Werte für V Ausgang*)
	(* PF setpoint y = 0.0 to 1.0 to 2.0 = 0.0ind. to 1.0 to 0.0cap. *)
	(* calculation voltage value for PF_lin = 0.00 = cosphi 0.0cap = -10V *)
	(* calculation voltage value for PF_lin = 1.00 = cosphi 1.0    =   0V *)	
	(* calculation voltage value for PF_lin = 2.00 = cosphi 0.0ind = +10V *)
	xSigScal_PF_U(X := rPF_POC_Set_lin, X1 := 0.000, Y1 := 10.0, X2 := 2.000 , Y2 := -10.0);

	(* Output voltage restricted between -1.0V to +3.0V  this corresponds to *)
 	(* Restricted output range based on checklist -0.5V TO +2.5V *)
	OUT_GC.tPF_AO_PF_U.Ao := LIMIT (-0.5, xSigScal_PF_U.Y_SCAL + rU_Gen_Diff_Match_U, 2.5);          



	(*-------------------------------------------------------------------------------------------------------*)
	(* Q set to AVR *)
	(*-------------------------------------------------------------------------------------------------------*)
	(* controller output    y = -1,0..0..+1.0% = -100%..0..+100%Qnom = cosphi 0.0cap .. 1.0 .. 0.0ind. *)
	(* Output voltage:  -2.7V =  -27%Qnom = cosphi -0.95 untererregt *)
	(*                   0.0V =    0%Qnom = cosphi  1.00             *)
    (*                  +6.0V =   60%Qnom = cosphi +0.80 uebererregt *)
	OUT_GC.tQ_AVR_Set_U.Ao := rQ_AVR_Set * 10; 

	


	(*----------------------------------------------------------------------------------*)
	Para.iQ_GrC_CtrlFun;		(* selection Q function  	                        	*)
	Para.iQ_GrC_PointCtrl;		(* selection point of control (POC)                    	*)
	Para.bPF_CosPCtr_Ena;		(* generator controller active                          *)

	OUT_GC.tPF_CosPCtr_Ena.Do;	(* demand cosphi from limit Pgen, gcb_on, mcb_on		*)
	OUT_GC.bPF_CosPCtr_block;	(* demand y_BLOCK2										*)
	OUT_GC.rPF_CosPCtr_block;	(* set value y_block 									*)
	OUT_GC.rPF_AO_PF_I;	        (* AO=mA: controller value to generator controller(AVR)	*)
	OUT_GC.rPF_AO_PF_U;	        (* AO=V:  controller value to generator controller(AVR) *)
	OUT_GC.tQ_AVR_Set_U.Ao;     (* AO=V:  Qset value to generator controller(AVR) 		*)
	(*----------------------------------------------------------------------------------*)

	
	(*-------------------------------------------------------------------------------------------------------*)
	(* generator air inlet temperature to generator controller - for UNITROL internal power limitation *)
	IF Para.bT_GenAirIn_Active AND Para.bT_GenAirIn2_Active THEN	
		IF    MM2VIS.bMsg2555 AND MM2VIS.bMsg3468 THEN OUT_GC.tT_AO_Gen_T_In.Ao :=  0;
		ELSIF MM2VIS.bMsg2555                     THEN OUT_GC.tT_AO_Gen_T_In.Ao :=  IN_GC.tGen_T_In2.Ai;
		ELSIF MM2VIS.bMsg3468                     THEN OUT_GC.tT_AO_Gen_T_In.Ao :=  IN_GC.tGen_T_In.Ai;
		ELSE                                           OUT_GC.tT_AO_Gen_T_In.Ao := (IN_GC.tGen_T_In.Ai + IN_GC.tGen_T_In2.Ai)/2; (* average *)
		END_IF;
	ELSIF Para.bT_GenAirIn_Active THEN	
		IF MM2VIS.bMsg2555 THEN OUT_GC.tT_AO_Gen_T_In.Ao := 0;
		ELSE					OUT_GC.tT_AO_Gen_T_In.Ao := IN_GC.tGen_T_In.Ai;
		END_IF;
	ELSE
		IF IN_GC.bAMM_T_Ch_T1LP_Avg  THEN 	OUT_GC.tT_AO_Gen_T_In.Ao := 0;
		ELSE							    OUT_GC.tT_AO_Gen_T_In.Ao := IN_GC.rT_Ch_T1LP_Avg;
		END_IF;
	END_IF;

	(* power reduction according high generator air in temperature *)
	IF Para.bT_GenAirIn_Active OR Para.bT_GenAirIn2_Active THEN
		IF MM2VIS.bMsg2555 AND MM2VIS.bMsg3468 THEN
			OUT_GC.rP_Red_T_GenAirIn_Norm := 1;
		ELSE
			OUT_GC.rP_Red_T_GenAirIn_Norm := LIMIT(0.5, (1 - ((OUT_GC.tT_AO_Gen_T_In.Ao - Para.rT_Pred_GenAirIn_Start) * Para.rT_Pred_GenAirIn_Rate)), 1.0);
		END_IF;
	ELSE
		OUT_GC.rP_Red_T_GenAirIn_Norm := 1;
	END_IF;

	(*-------------------------------------------------------------------------------*)
	(* Release for Unitrol *)
	OUT_GC.tGCB_On_ReturnSign.Do := IN_GC.tGCB_On.Di;
	
	(*------------------------------------------------------------------*)
END_PROGRAM
