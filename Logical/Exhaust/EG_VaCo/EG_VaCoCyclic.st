(*******************************************************************************
EG_VaCo			 exhaust gas valve control

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	03.07.1998	Pa			erstellt
		24.11.1998	Pa			korrekturlesung
V180	29.01.2003	LH			erweitert für ROTORK-Klappen
V2073	04.04.2006	LH			Abgasklappensteuerung erweitert für Bypass-/Kesselklappen-Kombination
V220	19.02.2007	LH			ROTORK --> EINS
V2600	06.08.2009	lettenb.	task activation added; task: pb2_reg included
V3.99.0	20.03.2013	lettenb.	pb2 --> EG_VaCo renamed
V4.00.1	10.04.2014				xTON_Valves_24h: NCC T91 added(gruber robert: Kombiklappe und Rückmeldung für Bypassklappe und Kesselklappe: nach 24h bleiben die Klappen ständig auf)
		23.06.2014				Para.bSel_EGVa_Combi: overwrite IN_EX.tEG_BoVaOpened.Di/IN_EX.tEG_ByVaOpened.Di removed, bugfix
V4.00.2	12.11.2014				bB_BK_ZU_2C: IN_EX.tEG_BoVaClosedTo.Di -> IN_EX.tEG_ByVaClosedTo.Di, bugfix
								OUT_EX.bEG_ByVaOpened, OUT_EX.bEG_BoVaOpened added, for rel.eng.oper.in heat-regulat. mode
 		07.08.2015  Denk		Manual operating auxiliaries control functionality added
V4.04.0	05.07.2016	lettenb.	xTON_CmdBypassValve_Open.PT: 60s -> 0,5s, bugfix
        20.09.2016				AF_KKAUF: VIS2MM interfaces added for plan(BOP)pictures(mayer robert)
        02.08.2017	lettenb.	INIT added, AF_KKAUF logic changed(validation mayer robert)bu03
																																		
Instructions FOR use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _INIT
	VIS2MM.bEGValve_Remote := TRUE;
END_PROGRAM

PROGRAM _CYCLIC

	(* Rung 2 *)
	IF Para.bEGValveEnable THEN
		(* Rung 3 *)
		(*----------------------------------------------------------------------------------------*)
		IF NOT Para.bEGValveRegulation THEN  (* exhaust gas valves open/close control *) 
			
			(* DREH_MOM := TRUE AND NOT ROTORK; *)
			DREH_MOM := NOT Para.bSel_EGVa_ROTORK;
			
			IF Para.bSel_EGVa_Combi THEN (* only bypass valve feedback signales *)
				BYPASS := IN_EX.tEG_ByVaOpened.Di;(* Position Bypass *)
				KESSEL := IN_EX.tEG_ByVaClosed.Di;(* Position Boiler *)
			ELSE
				BYPASS := IN_EX.tEG_BoVaClosed.Di;(* Position Bypass *)
				KESSEL := IN_EX.tEG_ByVaClosed.Di;(* Position Boiler *)
			END_IF;
			
			(* Demand Boiler valve open *)
			AF_KKAUF := IN_EX.tEng_Run.Do 
				AND   ((NOT IN_EX.tEG_BypassDemand.Di AND     VIS2MM.bEGValve_Remote)
					OR (NOT VIS2MM.bBypassDemand      AND NOT VIS2MM.bEGValve_Remote));
			
			(* Control signal Bypass valve AUF *)
			bB_BKAUF_1 := NOT M_KLST_Exh AND NOT B_BKZU AND NOT B_KKAUF; 
			bB_BKAUF_2 :=(NOT IN_EX.tEG_ByVaOpened.Di AND NOT Para.bSel_EGVa_Combi) OR (NOT BYPASS AND Para.bSel_EGVa_Combi);
			bB_BKAUF_3 := bB_BKAUF_2 AND (NOT AF_KKAUF  OR T91);
			B_BKAUF    := bB_BKAUF_1 AND bB_BKAUF_3;
		
			(* Control signal Bypass Valve Close *)
			bB_BK_ZU_1  := NOT M_KLST_Exh AND NOT B_BKAUF AND NOT B_KKZU;
			bB_BK_ZU_2A := NOT IN_EX.tEG_ByVaClosed.Di AND NOT Para.bSel_EGVa_Combi;
			bB_BK_ZU_2B := NOT KESSEL AND Para.bSel_EGVa_Combi;
			bB_BK_ZU_2C := IN_EX.tEG_ByVaClosedTo.Di AND DREH_MOM;
			bB_BK_ZU_2  := bB_BK_ZU_2A OR bB_BK_ZU_2B OR bB_BK_ZU_2C;
			bB_BK_ZU_3  := AF_KKAUF AND NOT T91 AND (IN_EX.tEG_BoVaOpened.Di OR Para.bSel_EGVa_Combi);
			B_BKZU      := bB_BK_ZU_1 AND bB_BK_ZU_2 AND bB_BK_ZU_3;		
			 	
			(* Control Signal Boiler valve open *)
			bB_KKAUF_1 := NOT M_KLST_Exh AND NOT B_KKZU AND NOT B_BKAUF;
			bB_KKAUF_2 :=(NOT IN_EX.tEG_BoVaOpened.Di AND NOT Para.bSel_EGVa_Combi) OR (NOT KESSEL AND Para.bSel_EGVa_Combi);
			bB_KKAUF_3 := AF_KKAUF OR T91;
			B_KKAUF    := bB_KKAUF_1 AND bB_KKAUF_2 AND bB_KKAUF_3;       
		
			(* Control signal Boiler valve Close *)
			bB_KKZU_1  := NOT M_KLST_Exh AND NOT B_KKAUF AND NOT B_BKZU;
			bB_KKZU_2A := NOT IN_EX.tEG_BoVaClosed.Di AND NOT Para.bSel_EGVa_Combi;
			bB_KKZU_2B := NOT BYPASS AND Para.bSel_EGVa_Combi;
			bB_KKZU_2C := IN_EX.tEG_BoVaClosedTo.Di AND DREH_MOM;
			bB_KKZU_2  := bB_KKZU_2A OR bB_KKZU_2B OR bB_KKZU_2C;
			bB_KKZU_3  := NOT AF_KKAUF AND NOT T91 AND (IN_EX.tEG_ByVaOpened.Di OR Para.bSel_EGVa_Combi);
			B_KKZU     := bB_KKZU_1 AND bB_KKZU_2 AND bB_KKZU_3;
		
			(* open valves after 24 hours  *)
			IF Para.bSel_EGVa_Combi THEN bZM_1 := KESSEL OR BYPASS;
			ELSE                         bZM_1 := IN_EX.tEG_BoVaClosed.Di OR IN_EX.tEG_ByVaClosed.Di;
			END_IF;
			xTON_Valves_24h(IN:= bZM_1 AND NOT T91, PT:= T#24h);
			xTOF_Valve_5s(IN:= xTON_Valves_24h.Q, PT:= T#5s);	(* open for 5 seconds *)
			T91		:= xTOF_Valve_5s.Q;
		
			(* Command Open Boiler valve *)
			xTON_BoilerValve_Open(IN:= B_KKAUF AND NOT OUT_EX.tEG_BoVaCoClose.Do, PT:= T#0.5s);
			OUT_EX.tEG_BoVaCoOpen.Do := xTON_BoilerValve_Open.Q
										OR IN_EX.tManAuxCtr.bEG_BoVaCoOpen;		(* Manual operating auxiliaries control - Handbedienebene *)
		
			(* Command Boiler Timer Values for Open/Close *)
			IF (Para.bSel_EGVa_ROTORK) THEN
				xTOF_BoilerValve_Close.PT    := T#2s; (* Boiler Valve *)
				xTOF_CmdBypassValve_Close.PT := T#2s; (* Bypass Valve *)
			ELSE
				xTOF_BoilerValve_Close.PT    := T#0s;  (* Boiler Valve *)
				xTOF_CmdBypassValve_Close.PT := T#0s;  (* Bypass Valve *)
			END_IF;
		
			(* Command Boiler valve Close *)
			xTON_BoilerValve_Close(IN:= B_KKZU, PT:= T#0.5s);
			xTOF_BoilerValve_Close.IN := xTON_BoilerValve_Close.Q; 						         
			IF M_KLST_Exh OR B_KKAUF THEN
				xTOF_BoilerValve_Close(IN := FALSE, PT := T#0s);
			ELSE	
				xTOF_BoilerValve_Close();							 	
			END_IF;				
			OUT_EX.tEG_BoVaCoClose.Do :=   xTOF_BoilerValve_Close.Q
										OR IN_EX.tManAuxCtr.bEG_BoVaCoClose;	(* Manual operating auxiliaries control - Handbedienebene *)
		
			(* Command Bypass valve open *)
			xTON_CmdBypassValve_Open(IN:= B_BKAUF AND NOT OUT_EX.tEG_ByVaCoClose.Do, PT:= T#0.5s);
			OUT_EX.tEG_ByVaCoOpen.Do :=    xTON_CmdBypassValve_Open.Q	
										OR IN_EX.tManAuxCtr.bEG_ByVaCoOpen;		(* Manual operating auxiliaries control - Handbedienebene *)
		
			(* Command Bypass valve Close *)
			xTON_CmdBypassValve_Close(IN:= B_BKZU, PT:= T#0.5s);			
			xTOF_CmdBypassValve_Close.IN := xTON_CmdBypassValve_Close.Q;						
			IF M_KLST_Exh AND B_BKAUF THEN
				xTOF_CmdBypassValve_Close(IN := FALSE, PT := T#0s);
			ELSE
				xTOF_CmdBypassValve_Close();									
			END_IF;			
			OUT_EX.tEG_ByVaCoClose.Do :=   xTOF_CmdBypassValve_Close.Q
										OR IN_EX.tManAuxCtr.bEG_ByVaCoClose;	(* Manual operating auxiliaries control - Handbedienebene *)    
		
		
			(* Overwrite Notification/Command with Bypass/boiler valve combination *)
			(* Rung 26 *)
		
		    IF Para.bSel_EGVa_Combi THEN
				(* Overwrite Open Notification Boiler valve *)
	//			IN_EX.tEG_BoVaOpened.Di   := NOT BYPASS;
				
				(* Overwrite Open Notification Bypass valve *)
	//			IN_EX.tEG_ByVaOpened.Di   := NOT KESSEL;
		
				(* Overwrite Command for Boiler Operation *)
				AF_KESSEL                 := OUT_EX.tEG_BoVaCoOpen.Do OR OUT_EX.tEG_ByVaCoClose.Do;
				OUT_EX.tEG_BoVaCoOpen.Do  := AF_KESSEL;
				OUT_EX.tEG_ByVaCoClose.Do := AF_KESSEL;
		
				(* Overwrite command for Bypass Operation *)
				AF_BYPASS                 := OUT_EX.tEG_BoVaCoClose.Do OR OUT_EX.tEG_ByVaCoOpen.Do;
				OUT_EX.tEG_BoVaCoClose.Do := AF_BYPASS;
				OUT_EX.tEG_ByVaCoOpen.Do  := AF_BYPASS;		

				OUT_EX.bEG_ByVaOpened := NOT KESSEL;	
				OUT_EX.bEG_BoVaOpened := NOT BYPASS;
			ELSE
				OUT_EX.bEG_ByVaOpened := IN_EX.tEG_ByVaOpened.Di;	
				OUT_EX.bEG_BoVaOpened := IN_EX.tEG_BoVaOpened.Di;
			END_IF;	
		(*----------------------------------------------------------------------------------------*)
		ELSE 	(* exhaust gas valves open/close regulation *)
	
			(* Request Boiler valve Open *)
			FG_REG := IN_EX.tEng_Run.Do;
		
			(* Request increase/decrease heat output - interface from MM_CU/plant controller *)
			KL_PLUS  := IN_EX.bEGValCtr_HeatOutputUp; 
			KL_MINUS := IN_EX.bEGValCtr_HeatOutputDown;
			// Commented out for test case 16 written directly 
		
			(* Control signal Bypass Valve Open *)
			B_BKAUF_1 := NOT FG_REG OR (IN_EX.tEng_Run.Do AND KL_MINUS);
			B_BKAUF   := NOT M_KLST_Exh AND B_BKAUF_1 AND NOT IN_EX.tEG_ByVaOpened.Di AND NOT B_BKZU;
		
			(* Control signal Bypass valve Close *)
			bB_BKZU_1 := NOT M_KLST_Exh AND IN_EX.tEng_Run.Do AND KL_PLUS;
			bB_BKZU_2 := IN_EX.tEG_BoVaOpened.Di AND NOT IN_EX.tEG_ByVaClosed.Di AND NOT B_BKAUF;
			B_BKZU    := bB_BKZU_1 AND bB_BKZU_2;
		
			(* Control signal Boiler valve Open *)
			b_B_KKAUF_1 := NOT M_KLST_Exh AND IN_EX.tEng_Run.Do AND KL_PLUS;
			b_B_KKAUF_2 := NOT IN_EX.tEG_BoVaOpened.Di AND NOT B_KKZU;
			B_KKAUF     := b_B_KKAUF_1 AND b_B_KKAUF_2;
		
			(* Control signal Boiler valve Close  *)
			b_B_KKZU_1 := IN_EX.tEG_ByVaOpened.Di AND NOT IN_EX.tEG_BoVaOpened.Di AND B_KKAUF;
			b_B_KKZU_2 := NOT FG_REG OR (IN_EX.tEng_Run.Do AND KL_MINUS);
			B_KKZU     := NOT M_KLST_Exh AND b_B_KKZU_1 AND b_B_KKZU_2;
		
			(* Command Boiler valve Open *)
			OUT_EX.tEG_BoVaCoOpen.Do  := B_KKAUF;
		
			(* Command Boiler valve Close *)
			OUT_EX.tEG_BoVaCoClose.Do := B_KKZU;
		
			(* Command Bypass valve Open *)
			OUT_EX.tEG_ByVaCoOpen.Do  := B_BKAUF;
		
			(* Command Bypass valve Close *)
			OUT_EX.tEG_ByVaCoClose.Do := B_BKZU; 		
	
			(* release engine operation from EG valves *)
			OUT_EX.bEG_ByVaOpened := IN_EX.tEG_ByVaOpened.Di;	
			OUT_EX.bEG_BoVaOpened := IN_EX.tEG_BoVaOpened.Di;
			
		END_IF;
	ELSE
		(* release engine operation from EG valves *)
		OUT_EX.bEG_ByVaOpened := TRUE;
		OUT_EX.bEG_BoVaOpened := TRUE;
	END_IF;
	
END_PROGRAM
