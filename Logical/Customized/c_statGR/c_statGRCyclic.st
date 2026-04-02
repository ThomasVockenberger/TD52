(*********************************************************************************************
AGGR: static GridCode - custom task (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- Auftragsspzifische Anpassungen für das stat. GridCode Paket

Customized modifications: -
------------------------
 
History:
-------
V3.40.0	14-02-2013	Perktold,  generated
V3.40.1	12-06-2013	Perktold,  user-friendliness-upgrade
V4.00.0 22-08-2013  Maxhera,   implementation of the module for modular software
V4.03.0 13-01-2016	Perktold,  changed for use in MM Customized
V4.04.0	06-10-2016	Perktold,  changed ERDF/DEIE - Activation now via Parameter
V4.04.0	02-11-2016	Gwiggner,  added frequency control
V4.05.0 01-12-2017  Farre, 	   added/modified Q functions, Point of control/reference, P(U) 
V4.05.0 04-12-2017	lettenb.   GR: custom measurement POC(point of control)added
                               tProtectionTest[x].Do added, grid code logic	
V4.06.0 06-08-2018  Zuschnig   added signal loss function for P_Set, P_Lim, COSPHI_Set, Q_Set, Q_Lim and U_Set
V4.07.0 15-01-2019	Zuschnig,  Added Parameter von AI oder BUS	
V4.09.0 28.11.2019	lettenb.   protection test moved to separate task
V4.13.0	12.10.2023	Farre,	   added ILF (de)activating HW, Bus and feedback signals

Instructions for use:
--------------------
- 
Outstandings:
-------------
*********************************************************************************************)

PROGRAM _CYCLIC
(********************************************************************************************)
(* TASKAUFBAU: ==>	 TASK STRUCTURE															*)
(*																							*)
(* A) BLINDLEISTUNG ==>	  REACTIVE POWER													*)
(*	o cos(phi) - Sollwertvorgabe ==> cos(phi) Setpoint										*)
(*	o Q - Sollwertvorgabe																	*)
(*	o Q - Limitierung																		*)
(*	o cos(phi) = f(P)																		*)
(*	o U - Sollwert (für Q(U) & cos(phi)=f(U) notwendig)	/ U control  						*)
(*	o Q(U)																					*)
(*	o cos(phi) = f(U)																		*)
(*	o Q = f(P)																				*)
(*	o Priorisierung der Funktionen (notwendig wenn mehr als eine verwendet werden)			*)
(*	o Analogausgänge																		*)
(*	o Point of reference - Customized														*)
(*	o Point of control - Customized													    	*)
(*	o Reactive Power control function - Customized											*)
(*																							*)
(* B) WIRKLEISTUNG																			*)
(*	o Sollwertvorgabe																		*)
(*	o Leistungslimitierung																	*)
(*	o PFC - PrimaryFrequencyControl															*)
(*	o RMC - RegulatingMarginControl															*)
(*																							*)
(*	o P(U) - Österreich																		*)
(********************************************************************************************)

(********************************************************************************************)
(*************** B L I N D L E I S T U N G ** / ** R E A C T I V E   P O W E R **************)
(********************************************************************************************)
	
(********************************************************************************************)
(********************** COS (PHI) - S E T P O I N T  S E L E C T I O N **********************)
(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    			         			*)
	OUT_CU.bPF_GenC_SetEUCOn 	:= IN_CU.tPF_GenC_SetEUCOn.Di; 			(*DI:setpoint genetaror power factor(COS PHI)from EU - on(activate)   *) 
	OUT_CU.bPF_GenC_SetEUCOf 	:= IN_CU.tPF_GenC_SetEUCOf.Di := TRUE; 	(*DI:setpoint genetaror power factor(COS PHI)from EU - off(deactivate)*)

	(* Marshalling DI: COSPHI-fixed values to the individual steps       		        		*)
	OUT_CU.PF_GenC_SetFix1	:= IN_CU.tPF_GenC_SetFix1EU.Di;	(*DI: setpoint genetaror power factor(COS PHI) - Fixvalue 1 from EU *)
	OUT_CU.PF_GenC_SetFix2	:= IN_CU.tPF_GenC_SetFix2EU.Di;	(*DI: setpoint genetaror power factor(COS PHI) - Fixvalue 2 from EU *)
	OUT_CU.PF_GenC_SetFix3	:= IN_CU.tPF_GenC_SetFix3EU.Di;	(*DI: setpoint genetaror power factor(COS PHI) - Fixvalue 3 from EU *)
	OUT_CU.PF_GenC_SetFix4	:= IN_CU.tPF_GenC_SetFix4EU.Di;	(*DI: setpoint genetaror power factor(COS PHI) - Fixvalue 4 from EU *)
	OUT_CU.PF_GenC_SetFix5	:= IN_CU.tPF_GenC_SetFix5EU.Di;	(*DI: setpoint genetaror power factor(COS PHI) - Fixvalue 5 from EU *)
	
	(*(DE)activation - bus          		         					                        *)
	OUT_CU.bGenC_PFBC_SetCOn;				(*bus: setpoint  genetaror power factor (COS PHI) from EU - on (activate)*)
	OUT_CU.bGenC_PFBC_SetCOf 	:= TRUE;	(*bus: setpoint  genetaror power factor (COS PHI) from EU - off (deactivate)*)
	
	(* connection bus signal - COS(PHI) set value from EU                                       *)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.rGenC_PFBC              				 		                    *)
	(* - bPFBC_GenC_SetErrBC generate - if TRUE it will be used Backupvale (Parameter)          *)
	OUT_CU.rGenC_PFBC;			(*bus: signal value genetaror power factor (COS PHI) from EU [-]*)
	OUT_CU.bPFBC_GenC_SetErrBC;	(*bus: setpoint generator power factor (COS PHI) from EU error - use backupvalue*)
	
	(*- - - - - - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - -  *)
	IN_CU.tPF_GenC_SOn.Do;      (* generator power factor (COS PHI) from EU is on               *)
	IN_CU.tPF_GenC_SOf.Do;      (* generator power factor (COS PHI) from EU is off              *)
	IN_CU.tPF_GenC_Fix1SOn.Do;	(* genetaror power factor (COS PHI) - fixvalue 1 from EU is on  *)
	IN_CU.tPF_GenC_Fix2SOn.Do;	(* genetaror power factor (COS PHI) - fixvalue 2 from EU is on  *)
	IN_CU.tPF_GenC_Fix3SOn.Do;	(* genetaror power factor (COS PHI) - fixvalue 3 from EU is on  *)
	IN_CU.tPF_GenC_Fix4SOn.Do;	(* genetaror power factor (COS PHI) - fixvalue 4 from EU is on  *)
	IN_CU.tPF_GenC_Fix5SOn.Do;	(* genetaror power factor (COS PHI) - fixvalue 5 from EU is on  *)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(************************** Q - S E T P O I N T  S E L E C T I O N **************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         			    *)
	OUT_CU.bQ_GenC_SetEUCOn		:= IN_CU.tQ_GenC_SetEUCOn.Di;		(*DI: setpoint reactive power characteristic (Q) from EU - on (activate)   *)
	OUT_CU.bQ_GenC_SetEUCOf 	:= IN_CU.tQ_GenC_SetEUCOf.Di:=TRUE;	(*DI: setpoint reactive power characteristic (Q) from EU - off (deactivate)*)
	
	(*Marshalling DI: Q fixed values to the individual steps									*)
	OUT_CU.Q_GenC_SetFix1		:= IN_CU.tQ_GenC_SetFix1EU.Di;	(*DI: reactive power (Q) - Q-fixvalue 1 from EU	*)
	OUT_CU.Q_GenC_SetFix2		:= IN_CU.tQ_GenC_SetFix2EU.Di;	(*DI: reactive power (Q) - Q-fixvalue 2 from EU	*)
	OUT_CU.Q_GenC_SetFix3		:= IN_CU.tQ_GenC_SetFix3EU.Di;	(*DI: reactive power (Q) - Q-fixvalue 3 from EU	*)
	OUT_CU.Q_GenC_SetFix4		:= IN_CU.tQ_GenC_SetFix4EU.Di;	(*DI: reactive power (Q) - Q-fixvalue 4 from EU	*)
	OUT_CU.Q_GenC_SetFix5		:= IN_CU.tQ_GenC_SetFix5EU.Di;	(*DI: reactive power (Q) - Q-fixvalue 5 from EU	*)

	(*(DE)Activating  - bus          		         					                       	*)
	OUT_CU.bGenC_QBC_SetCOn;			(* bus: setpoint reactive power (Q) from EU - on (activate)	       *)
	OUT_CU.bGenC_QBC_SetCOf	:= TRUE;	(* bus: setpoint reactive power (Q) from EU - off (deactivate)	   *)
	
	(* BUSSIGANAL connection  - Q set value from EU                                             *)
	(* to do:																					*)
	(* - BusSetpoint OUT_CU.rGenC_QBC              				 		                    	*)
	(*  - OUT_CU.bQ_GenC_SetErrBC generieren - falls TRUE wird der Backupwert (Parameter) verwendet		*)
	OUT_CU.rGenC_QBC;       	(* bus: scaling value reactive power (Q) from EU [kVAr]					*)
	OUT_CU.bQ_GenC_SetErrBC;	(* bus: Q setpoint BUS EU error - use backupvalue						*)

	(*- - - - - - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - -  *)
	IN_CU.tQ_GenC_SOn.Do;     (* reactive power characteristic (Q) from EU is on  *)
	IN_CU.tQ_GenC_SOf.Do;     (* reactive power characteristic (Q) from EU is off *)
	IN_CU.tQ_GenC_Fix1SOn.Do; (* reactive power (Q) - Q-fixvalue 1 from EU on     *)
	IN_CU.tQ_GenC_Fix2SOn.Do; (* reactive power (Q) - Q-fixvalue 2 from EU on     *)
	IN_CU.tQ_GenC_Fix3SOn.Do; (* reactive power (Q) - Q-fixvalue 3 from EU on     *)
	IN_CU.tQ_GenC_Fix4SOn.Do; (* reactive power (Q) - Q-fixvalue 4 from EU on     *)
	IN_CU.tQ_GenC_Fix5SOn.Do; (* reactive power (Q) - Q-fixvalue 5 from EU on     *)
	(********************************************************************************************)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(****************************** Q - L I M I T I N G *****************************************)
	(********************************************************************************************)
	(* Q - LIMITING 																			*)
	(*																							*)
	(*(DE)Activating  - HW --> To connection or to set fix value    		         		   	*)
	OUT_CU.bQLim_GenC_SetEUCOn	:= IN_CU.tQLim_GenC_SetEUCOn.Di;		(* DI: setpoint reactive power limitation (QLim) from EU - on (activate)   *)
	OUT_CU.bQLim_GenC_SetEUCOf	:= IN_CU.tQLim_GenC_SetEUCOf.Di;		(* DI: setpoint reactive power limitation (QLim) from EU - off (deactivate)*)

	(*(DE)Activating - BUS																		*)
	OUT_CU.bGenC_QLimBC_SetCOn; 				(* bus: setpoint reactive power limitation (QLim) from EU - on (activate)    *)
	OUT_CU.bGenC_QLimBC_SetCOf;			 		(* bus: setpoint reactive power limitation (QLim) from EU - off (deactivate) *)
	(*	
	(* BUSSIGANAL connect  - Q Limiting EU          											*)
	(* to do:																					*)
	(* - BusSetpoint OUT_CU.rGenC_QLimBC              				 		                    *)
	(*  - OUT_CU.bGenC_QLimSetErrBC generieren - falls TRUE wird der Backupwert (Parameter) verwendet	 *)
	OUT_CU.rGenC_QLimBC;    	(* bus: scaling value for reactive power limitation for EVA BUS[kVAr]    *)
	OUT_CU.bGenC_QLimSetErrBC;	(* bus: setpoint reactive power limitation from EU error - use backupvalue*)

	(*- - - - - - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - -  *)
	(* use the following variables as DO in the I/O configuration if needed 					*)
	(* QLim_GenC_SOn; (*  reactive power limiting (QLim)  is on                     			*)
	(* QLim_GenC_SOf; (*  reactive power limiting (QLim)  is off	                    		*)
	(* QLim_GenC_Act; (*  reactive power limiting (Plim) from EU is aktiv            			*)
	(********************************************************************************************)
	

	(********************************************************************************************)
	(*********************************** COS (PHI) - f(P) ***************************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         				*)
	OUT_CU.bQPC_GenC_SetEUCOn	:= IN_CU.tQPC_GenC_SetEUCOn.Di;  			(*DI: setpoint reactive power characteristics COS(phi)=f(P) from EU - on (activate)    *)
	OUT_CU.bQPC_GenC_SetEUCOf	:= IN_CU.tQPC_GenC_SetEUCOf.Di := TRUE;  	(*DI: setpoint reactive power characteristics COS(phi)=f(P) from EU - off (deactivate) *)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_QPCBC_SetCOn; 				(* bus: setpoint reactive power characteristics COS(phi)=f(P) from EU - on (activate)	*)
	OUT_CU.bGenC_QPCBC_SetCOf	:= TRUE; 	(* bus: setpoint reactive power characteristics COS(phi)=f(P) from - off (deactivate)	*)
	(********************************************************************************************)
	
	(*- - - - - - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - -  *)
	IN_CU.tQPC_GenC_SOn.Do; (*  reactive power characteristics COS(phi)=f(P) from EU is on		*)
	IN_CU.tQPC_GenC_SOf.Do; (*  reactive power characteristics COS(phi)=f(P) from EU is on		*)
	
	(********************************************************************************************)
	(********************************* U - S E T   V A L U E ************************************)
	(********************************************************************************************)
	(*																							*)
	OUT_CU.bUist_max 			:= FALSE;	(* TRUE = Uist für Q(U) & cosphi(U) ist max. Generatorspannung    *)
	(* Ph-Ph, FALSE = durchschnittliche Generatorspannung Ph-Ph 								*)
	(* Activation U setpoint for PF(U), Q(U) functions											*)
	OUT_CU.bGenC_UQBC_SetCOn;(* bus: setpoint generator voltage for rective power - on (activate)    *)
	OUT_CU.bGenC_UQBC_SetCOf	:= TRUE;	(* bus: setpoint generator voltage FOR rective power - off (deactivate)*)
	(* Activation U setpoint for U control														*)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         				*)
	OUT_CU.bU_GenC_SetEUCOn; (*DI: setpoint generator voltage FOR voltage control - on (activate)    *)
	OUT_CU.bU_GenC_SetEUCOf := TRUE; (*DI: setpoint generator voltage FOR voltage control - off (deactivate)    *)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_UBC_SetCOn; (*bus: setpoint generator voltage FOR voltage control - on (activate)    *)
	OUT_CU.bGenC_UBC_SetCOf := TRUE; (*bus: setpoint generator voltage FOR voltage control - off (deactivate)
	(*																						    *)
	(* BUSSIGANAL connect  - Q Limiting EU          											*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.rGenC_UQBC              				 		                    *)
	(* - OUT_CU.bU_GenC_SetErrBC generieren - falls TRUE wird der Backupwert (Parameter) verwendet	 		*)
	OUT_CU.rGenC_UQBC;    		(* bus: scaling value generator voltage for reactive power (Q) [1.00] = 100% from Nominal Value for Setpoint (Parameter 11696) *)
	OUT_CU.bU_GenC_SetErrBC;	(* bus: setpoint voltage from EU error - use backupvalue		*)
	
	(********************************************************************************************)
	(***************************************** Q(U) *********************************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To bind or to set fix value    		         					*)
	OUT_CU.bQUC_GenC_SetEUCOn	:= IN_CU.tQUC_GenC_SetEUCOn.Di;			(* DI: setpoint reactive power characteristics Q=f(U) from EU -on (activate)   *)
	OUT_CU.bQUC_GenC_SetEUCOf	:= IN_CU.tQUC_GenC_SetEUCOf.Di := TRUE;	(* DI: setpoint reactive power characteristics Q=f(U) from EU -off (deactivate)*)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_QUCBC_SetCOn; 				(* bus: setpoint reactive power characteristics Q=f(U) from EU -on (activate)   *)
	OUT_CU.bGenC_QUCBC_SetCOf	:= TRUE;	(* bus: setpoint reactive power characteristics Q=f(U) from EU -off (deactivate)*)
	(********************************************************************************************)
	
	(*- - - - - - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - -  *)
	IN_CU.tQUC_GenC_SOn.Do;     (*  reactive power characteristics Q=f(U) from EU is on       	*)
	IN_CU.tQUC_GenC_SOf.Do;     (*  reactive power characteristics Q=f(U) from EU is off       	*)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(*********************************** COS (PHI) - f(U) ***************************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To bind or to set fix value    		         					*)
	OUT_CU.bPFUC_GenC_SetEUCOn	:= IN_CU.tPFUC_GenC_SetEUCOn.Di; 		(* DI: setpoint reactive power characteristics COS(phi)=f(U) von EU -on (active)    		 *)
	OUT_CU.bPFUC_GenC_SetEUCOf	:= IN_CU.tPFUC_GenC_SetEUCOf.Di:=TRUE; 	(* DI: setpoint reactive power characteristics COS(phi)=f(U) von EU -off (deactive) *)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_PFUCBC_SetCOn;					 (* bus: setpoint reactive power characteristics COS(phi)=f(U) from EU -on (active)   *)
	OUT_CU.bGenC_PFUCBC_SetCOf	:= TRUE;		 (* bus: setpoint reactive power characteristics COS(phi)=f(U) from EU -off (deactive)*)
	
	(*- - - - - - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - -  *)
	IN_CU.tPFUC_GenC_SOn.Do;	   (*  reactive power characteristics COS(phi)=f(P) from EU is on  *)
	IN_CU.tPFUC_GenC_SOf.Do;       (*  reactive power characteristics COS(phi)=f(P) from EU is off *)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(*********************************** Q - f(P) ***********************************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To bind or to set fix value    		         					*)
	OUT_CU.bQP_GenC_SetEUCOn := IN_CU.tQP_GenC_SetEUCOn.Di; 		(* DI: setpoint reactive power characteristics Q=f(P) von EU -on (active)    		 *)
	OUT_CU.bQP_GenC_SetEUCOf := IN_CU.tQP_GenC_SetEUCOf.Di:= TRUE; 	(* DI: setpoint reactive power characteristics Q=f(P) von EU -off (deactive) *)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_QPBC_SetCOn;			 (* bus: setpoint reactive power characteristics Q=f(P) from EU -on (active)   *)
	OUT_CU.bGenC_QPBC_SetCOf	:= TRUE; (* bus: setpoint reactive power characteristics Q=f(P) from EU -off (deactive)*)
	
	(*- - - - - - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - -  *)
	IN_CU.tQP_GenC_SOn.Do;	   (*  reactive power characteristics Q=f(P) from EU is on  *)
	IN_CU.tQP_GenC_SOf.Do;       (*  reactive power characteristics Q=f(P) from EU is off *)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(*************** P R I O R I T I Z A T I O N  T H E  F U N C T I O N S **********************)
	(********************************************************************************************)
	(* Prioritization the EU Functions for voltage controling									*)
	(* the smaller number the greater priority													*)
	(* SEVERAL FUNCTIONS AT THE SAME TIME SPORTS - "WINNING" THE ONE WITH PRIORITY           	*)
	OUT_CU.iGenC_PrioQCustSet := 9;		(* Prioritet  reactive power Q customized						*)
	OUT_CU.iGenC_PrioQUset   := 7;		(* Prioritet  reactive power U control(Q) -                     *)
	OUT_CU.iGenC_PrioQ   	 := 6;		(* Prioritet  reactive power (Q) - fixvalue                     *)
	OUT_CU.iGenC_PrioQP		 := 5;		(* Prioritet  reactive power characteristic Q=f(P)              *)
	OUT_CU.iGenC_PrioQUC     := 4;		(* Prioritet  reactive power characteristic Q=f(U)              *)
	OUT_CU.iGenC_PrioPFUC    := 3;		(* Prioritet  reactive power characteristic COS(phi)=f(U)       *)
	OUT_CU.iGenC_PrioPFPC    := 2;		(* Prioritet  reactive power characteristic COS(phi)=f(P)       *)
	OUT_CU.iGenC_PrioPF      := 1;		(* Prioritet  genetaror power factor (COS(phi)) - fixvalue      *)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(*************** POINT OF REFERENCE (POR) - CUSTOMIZED **************************************)
	(********************************************************************************************)
	(* To do if customized point of reference is selected   									*)
	(* Para.iQ_GrC_PointRef = 0																	*)
	(* - provide actual active power  OUT_CU.rP_POR_Act_Cust								        *)
	(* - provide actual voltage OUT_CU.rU_POR_Act_Cust		     		      				        *)
	
	OUT_CU.rP_POR_Act_Cust; (* actual active power used as point of reference [kW] - connect spare AI e.g IN_CU.tCustAnaIn[1].Ai*)
	OUT_CU.rU_POR_Act_Cust;	(* actual voltage used as point of reference [V] - connect spare AI e.g IN_CU.tCustAnaIn[1].Ai*)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(*************** POINT OF CONTROL (POC)- CUSTOMIZED ********************************************)
	(********************************************************************************************)
	(* To do if customized point of control is selected   										*)
	(* Para.iQ_GrC_PointCtrl = 0																*)
	(*(AI)Activating  - HW --> To connect spare AI                      		         		*)
	OUT_CU.rS_POC_Act_Cust;(*  := IN_CU.tCustAnaIn[1].Ai; (* AI: apparent power custom measurement [kVA] *)
	OUT_CU.rP_POC_Act_Cust;(*  := IN_CU.tCustAnaIn[2].Ai; (* AI: active   power custom measurement [kW]	 *)
	OUT_CU.rQ_POC_Act_Cust;(*  := IN_CU.tCustAnaIn[3].Ai; (* AI: reactive power custom measurement [kVAr]*)
	OUT_CU.rPF_POC_Act_Cust;(* := IN_CU.tCustAnaIn[4].Ai; (* AI: power factor   custom measurement       *)

	(*rS_POC_Act_Cust calculation if value is not available - - - - - - - - - - - - - - - - - - - - *)(*
	OUT_CU.rS_POC_Act_Cust  := SQRT(OUT_CU.rP_POC_Act_Cust * OUT_CU.rP_POC_Act_Cust + OUT_CU.rQ_POC_Act_Cust * OUT_CU.rQ_POC_Act_Cust);
	
	(*rPF_POC_Act_Cust calculation if value is not available - - - - - - - - - - - - - - - - - - - - *)(*
	IF OUT_CU.rS_POC_Act_Cust > 0 THEN 
		OUT_CU.rPF_POC_Act := OUT_CU.rP_POC_Act_Cust / OUT_CU.rS_POC_Act_Cust;
	END_IF;
	(********************************************************************************************)
	
	(********************************************************************************************)
	(*************** Q FUNCTION #0 - CUSTOMIZED  ************************************************)
	(********************************************************************************************)
	(* (DE)activation - bus          		         					        	            *)
	OUT_CU.bGenC_QCustBC_SetCOn;			(*bus: Customized Q setpoint		 - on (activate)*)
	OUT_CU.bGenC_QCustBC_SetCOf	:= TRUE;	(*bus: Customized Q setpoint	  - off (deactivate)*)
	
	(* to do:																		        	*)
	(* - Q setpoint	 OUT_CU.rQ_Cust		              				 		                    *)
	OUT_CU.rQ_Cust;				(* Customized Q setpoint [kVAr]- connect spare AI e.g IN_CU.tCustAnaIn[1].Ai*)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(********************************************************************************************)
	(*************** W I R K L E I S T U N G ** / ** A C T I V E   P O W E R ********************)
	(********************************************************************************************)
	(********************************************************************************************)

	(********************************************************************************************)
	(*************************** P - S E T   V A L U E ******************************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         		  	    *)
	OUT_CU.bP_GenC_SetEUCOn := IN_CU.tP_GenC_SetEUCOn.Di;  (* DI: request power value from EU - on (activate)	        *)
	OUT_CU.bP_GenC_SetEUCOf := IN_CU.tP_GenC_SetEUCOf.Di:=TRUE;	(* DI: request power value from EU - off (deactivate)   *)

	(*Digitalinputs for power fixvalue - in I/O list bind if needed	                			*)
	OUT_CU.P_GenC_SetFix1 := IN_CU.tP_GenC_SetFix1EU.Di; (* DI: power value - P- fixvalue 1 from EU  *)
	OUT_CU.P_GenC_SetFix2 := IN_CU.tP_GenC_SetFix2EU.Di; (* DI: power value - P- fixvalue 2 from EU  *)
	OUT_CU.P_GenC_SetFix3 := IN_CU.tP_GenC_SetFix3EU.Di; (* DI: power value - P- fixvalue 3 from EU  *)
	OUT_CU.P_GenC_SetFix4 := IN_CU.tP_GenC_SetFix4EU.Di; (* DI: power value - P- fixvalue 4 from EU  *)
	OUT_CU.P_GenC_SetFix5 := IN_CU.tP_GenC_SetFix5EU.Di; (* DI: power value - P- fixvalue 5 from EU  *)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_PBC_SetCOn; 			(* bus: setpoint power P from EU -on (activate) 	    *)
	OUT_CU.bGenC_PBC_SetCOf	:= TRUE; 	(* bus: setpoint power P from EU -off (deactivate) 		*)
	(*
	(* BUSSIGNAL connection  - P Set value from EU         										*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.rGenC_PBC	              				 		                    *)
	(* - OUT_CU.bP_GenC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.rGenC_PBC;        (* bus: scaling value for power P from EU 	[kW]					*)
	OUT_CU.bP_GenC_SetErr;   (* Generator power setpoint measuring signal failure 				*)
	
	(*- - - - - - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - -  *)
	IN_CU.tP_GenC_SOn.Do; (*  power value fon EU is on  	 *)
	IN_CU.tP_GenC_SOf.Do; (*  power value fon EU is off      *)
	(********************************************************************************************)

	
	(********************************************************************************************)
	(****************************** P - L I M I T I N G *****************************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         				*)
	IF NOT Para.bDEIE_Active THEN
		OUT_CU.bPLim_GenC_SetEUCOn := IN_CU.tPLim_GenC_SetEUCOn.Di := TRUE; (* DI: setpoint power limitation (Plim) from EU - on (activate)    	*)
		OUT_CU.bPLim_GenC_SetEUCOf := IN_CU.tPLim_GenC_SetEUCOf.Di := TRUE; (* DI: setpoint power limitation (Plim) from EU - off (deactivate) 	*)
	ELSE
		OUT_CU.bPLim_GenC_SetEUCOn := IN_CU.tPLim_GenC_SetEUCOn.Di;(*<-- DON'T change - just for ERDF / DEIE*)
		OUT_CU.bPLim_GenC_SetEUCOf := IN_CU.tPLim_GenC_SetEUCOf.Di;(*<-- DON'T change - just for ERDF / DEIE*)
	END_IF;
	(*																							*)
	(* Marshalling DI: P - Limiting/reduction fixed value for singel-steps		     		    *)
	OUT_CU.PLim_GenC_SetEUPFix1 := IN_CU.tPLim_GenC_SetEUPFix1.Di;(* DI: power limitation fixvalue 1 *)
	OUT_CU.PLim_GenC_SetEUPFix2 := IN_CU.tPLim_GenC_SetEUPFix2.Di;(* DI: power limitation fixvalue 2 *)
	OUT_CU.PLim_GenC_SetEUPFix3 := IN_CU.tPLim_GenC_SetEUPFix3.Di;(* DI: power limitation fixvalue 2 *)
	OUT_CU.PLim_GenC_SetEUPFix4 := IN_CU.tPLim_GenC_SetEUPFix4.Di;(* DI: power limitation fixvalue 3 *)
	OUT_CU.PLim_GenC_SetEUPFix5 := IN_CU.tPLim_GenC_SetEUPFix5.Di;(* DI: power limitation fixvalue 5 *)
	(*(DE)Activating - bus																	   	*)
	OUT_CU.bGenC_PLimBC_SetCOn;				(* bus: power limition from  EU - on (activate)     *)
	OUT_CU.bGenC_PLimBC_SetCOf	:= TRUE;	(* bus: power limition from  EU - off (deactivate)  *)

	(* BUSSIGANAL connect - power limiting EU                                                   *)
	(* to do:																		          	*)
	(* - BusSetpoint OUT_CU.rGenC_PLimBC	              				 		                *)
	(* - OUT_CU.bP_GenC_SetErrPlim generieren - falls TRUE wird der Backupwert (Parameter) verwendet *)
	OUT_CU.rGenC_PLimBC;		(* bus: scaling value power limitation from EU [kW]           	*)
	OUT_CU.bP_GenC_SetErrPlim;	(* power limitation BUS EU error - use backupvalue			    *)

	(*- - - - - - - - - - - - -  F E E D B A C K  S I G N A L S  - - - - - - - - - - - - - - -  *)
	IN_CU.tPLim_GenC_SOn.Do;  (*  power limitation (PLim) from EU is on							*)
	IN_CU.tPLim_GenC_SOf.Do;  (*  power limitation (Plim) from EU is off						*)
	IN_CU.tPLim_GenC_Act.Do;  (*  power limitation (Plim) from EU is aktiv						*)
	IN_CU.tP_GenC_Fix0SOn.Do; (*  no limiting power value - P- fixvalue 0 from EU is on			*)
	IN_CU.tP_GenC_Fix1SOn.Do; (*  power value - P- fixvalue 1 from EU is on						*)
	IN_CU.tP_GenC_Fix2SOn.Do; (*  power value - P- fixvalue 2 from EU is on						*)
	IN_CU.tP_GenC_Fix3SOn.Do; (*  power value - P- fixvalue 3 from EU is on						*)
	IN_CU.tP_GenC_Fix4SOn.Do; (*  power value - P- fixvalue 4 from EU is on						*)
	IN_CU.tP_GenC_Fix5SOn.Do; (*  power value - P- fixvalue 5 from EU is on						*)
	IN_CU.tEU_RM_BLOCK.Do;	  (*  Separate unit of utility and of active network              	*)
	(********************************************************************************************)

	(********************************************************************************************)
	(************** PFC - P r i m a r y F r e q u e n c y C o n t r o l *************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         			    *)
	OUT_CU.bPFC_SetCOn	:= IN_CU.tPFC_SetCOn.Di; 		(* DI:primary frequency control - on (activate)	*)
	OUT_CU.bPFC_SetCOf	:= IN_CU.tPFC_SetCOf.Di :=TRUE; (* DI:primary frequency control - off (deactivate)	*)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_PFCBC_SetCOn; 				(* bus: primary frequency control - on (activate)	*)
	OUT_CU.bGenC_PFCBC_SetCOf	:= TRUE; 	(* bus: primary frequency control - off (deactivate)*)

	(*- - - - - - - - - - - F E E D B A C K  S I G N A L S  - - - - - - - - - - - - - -- - - -  *)
	IN_CU.tPFC_SOn.Do;		(*  primary frequency control is on									*)
	IN_CU.tPFC_SOf.Do;    	(*  primary frequency control is off								*)
	(********************************************************************************************)

	(********************************************************************************************)
	(************** RMC - R e g u l a t i n g M a r g i n C o n t r o l *************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         			    *)
	OUT_CU.bRMC_SetCOn	:= IN_CU.tRMC_SetCOn.Di; (* DI:regulation margin control -on (activate)	*)
	OUT_CU.bRMC_SetCOf	:= IN_CU.tRMC_SetCOf.Di :=TRUE; (* DI:regulation margin control -off (deactivate) *)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_RMCBC_SetCOn; 				(* bus: regulation margin control -on (activate)	*)
	OUT_CU.bGenC_RMCBC_SetCOf	:= TRUE; 	(* bus: regulation margin control -off (deactivate)	*)

	(*- - - - - - - - - - - F E E D B A C K  S I G N A L S  - - - - - - - - - - - - - -- - - -  *)
	IN_CU.tRMC_SOn.Do; 		(*  regulation margin control is on									*)
	IN_CU.tRMC_SOf.Do;		(*  regulation margin control is off								*)
	(********************************************************************************************)


	(********************************************************************************************)
	(************************** E R D F *********************************************************)
	(********************************************************************************************)
	(* Enable the functionality for the ERDF customers now via Parameter *)
	(* electrical / grid / static grid code *)
	(********************************************************************************************)

	(********************************************************************************************)
	(************** FSM - F r e q u e n c y C o n t r o l *************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         			    *)
	OUT_CU.bFC_SetCOn	:= IN_CU.tSet_FC_COn.Di; 		(* DI: frequency control - on (activate)	*)
	OUT_CU.bFC_SetCOf	:= IN_CU.tSet_FC_COf.Di :=TRUE; (* DI: frequency control - off (deactivate)	*)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bSet_FC_COn_Bus; 				(* bus: primary frequency control - on (activate)	*)
	OUT_CU.bSet_FC_COf_Bus	:= TRUE; 		(* bus: primary frequency control - off (deactivate)*)
	
	(*- - - - - - - - - - - F E E D B A C K  S I G N A L S  - - - - - - - - - - - - - -- - - -  *)
	IN_CU.tFC_SOn.Do;		(*  primary frequency control is on								*)
	IN_CU.tFC_SOf.Do;    	(*  primary frequency control is off								*)
	(********************************************************************************************)
	
	(********************************************************************************************)
	(************************* P(U) - ÖSTERREICH*************************************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         			    *)
	OUT_CU.bPU_SetCOn	:= IN_CU.tSet_PU_COn.Di; 		(* DI: frequency control - on (activate)	*)
	OUT_CU.bPU_SetCOf	:= IN_CU.tSet_PU_COf.Di :=TRUE; (* DI: frequency control - off (deactivate)	*)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bGenC_PUBC_SetCOn; 				(* bus: P(U) - Österreich - on (activate)	*)
	OUT_CU.bGenC_PUBC_SetCOf := TRUE; 		(* bus: P(U) - Österreich - off (deactivate)*)
	
	(*- - - - - - - - - - - F E E D B A C K  S I G N A L S  - - - - - - - - - - - - - -- - - -  *)
	IN_CU.tPU_SOn.Do;		(*  P(U) Österreich is on								*)
	IN_CU.tPU_SOn.Do;    	(*  P(U) Österreich is off								*)
	(********************************************************************************************)

	(********************************************************************************************)
	(************************* Parameter External************************************************)
	(********************************************************************************************)
	(************************* Frequency Deadband LFSMO******************************************)
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bLFSMO_DB_AI_COn := IN_CU.tHA2CU.tSet_LFSMO_DB_COn.Di;
	OUT_CU.tCU2GR.bLFSMO_DB_AI_COf := IN_CU.tHA2CU.tSet_LFSMO_DB_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bLFSMO_DB_BC_COn;
	OUT_CU.tCU2GR.bLFSMO_DB_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Frequency Limit LFSMO from EU            						*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rF_LFSMO_DB_BC      				 		                    *)
	(* - OUT_CU.tCU2GR.bLFSMO_DB_BC_SetErr - falls TRUE wird der Backupwert (Parameter) verwendet  *)
	OUT_CU.tCU2GR.rF_LFSMO_DB_BC;        (* bus: scaling value for Frequency Deadband LFSMO from EU [Hz] *)
	OUT_CU.tCU2GR.bLFSMO_DB_BC_SetErr;   (* Frequency Limit LFSMO measuring signal failure   	*)
	(********************************************************************************************)	
	(************************* Frequency Deadband LFSMU******************************************)
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bLFSMU_DB_AI_COn := IN_CU.tHA2CU.tSet_LFSMU_DB_COn.Di;
	OUT_CU.tCU2GR.bLFSMU_DB_AI_COf := IN_CU.tHA2CU.tSet_LFSMU_DB_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bLFSMU_DB_BC_COn;
	OUT_CU.tCU2GR.bLFSMU_DB_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Frequency Limit LFSMU from EU            						*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rF_LFSMU_DB_BC      				 		                    *)
	(* - OUT_CU.tCU2GR.bLFSMU_DB_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rF_LFSMU_DB_BC;        (* bus: scaling value for Frequency Limit LFSMU from EU [Hz] *)
	OUT_CU.tCU2GR.bLFSMU_DB_BC_SetErr;   (* Frequency Limit LFSMU measuring signal failure  	*)
	(********************************************************************************************)
	(************************* Positive Droop LFSMO**********************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bLFSMO_Droop_AI_COn := IN_CU.tHA2CU.tSet_LFSMO_Droop_COn.Di;
	OUT_CU.tCU2GR.bLFSMO_Droop_AI_COf := IN_CU.tHA2CU.tSet_LFSMO_Droop_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bLFSMO_Droop_BC_COn;
	OUT_CU.tCU2GR.bLFSMO_Droop_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Positive Droop LFSMO from EU             						*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rP_LFSMO_Droop_BC	              				 		                    *)
	(* - OUT_CU.tCU2GR.bLFSMO_Droop_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rP_LFSMO_Droop_BC;        (* bus: scaling value for Positive Droop LFSMO from EU [%] *)
	OUT_CU.tCU2GR.bLFSMO_Droop_BC_SetErr;   (* Positive Droop LFSMO measuring signal failure	*)
	(********************************************************************************************)
	(************************* Negative Droop LFSMU**********************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bLFSMU_Droop_AI_COn := IN_CU.tHA2CU.tSet_LFSMU_Droop_COn.Di;
	OUT_CU.tCU2GR.bLFSMU_Droop_AI_COf := IN_CU.tHA2CU.tSet_LFSMU_Droop_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bLFSMU_Droop_BC_COn;
	OUT_CU.tCU2GR.bLFSMU_Droop_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Negative droop LFSMU from EU         		    				*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rP_LFSMU_Droop_BC   				 		                    *)
	(* - OUT_CU.tCU2GR.bLFSMU_Droop_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rP_LFSMU_Droop_BC;        (* bus: scaling value for Negative Droop LFSMU from EU [%] *)
	OUT_CU.tCU2GR.bLFSMU_Droop_BC_SetErr;   (* Negative Droop LFSMU measuring signal failure    *)
	(********************************************************************************************)
	(************************* Droop FSMU********************************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bFSMU_Droop_AI_COn := IN_CU.tHA2CU.tSet_FSMU_Droop_COn.Di;
	OUT_CU.tCU2GR.bFSMU_Droop_AI_COf := IN_CU.tHA2CU.tSet_FSMU_Droop_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bFSMU_Droop_BC_COn;
	OUT_CU.tCU2GR.bFSMU_Droop_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Droop FSMU from EU				         						*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rP_FSMU_Droop_BC	              				 		        *)
	(* - OUT_CU.tCU2GR.bFSMU_Droop_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rP_FSMU_Droop_BC;        (* bus: scaling value for Droop FSMU from EU	[%]		*)
	OUT_CU.tCU2GR.bFSMU_Droop_BC_SetErr;   (* Droop FSMU measuring signal failure	            *)
	(********************************************************************************************)
	(************************* Droop FSMO********************************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bFSMO_Droop_AI_COn := IN_CU.tHA2CU.tSet_FSMO_Droop_COn.Di;
	OUT_CU.tCU2GR.bFSMO_Droop_AI_COf := IN_CU.tHA2CU.tSet_FSMO_Droop_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bFSMO_Droop_BC_COn;
	OUT_CU.tCU2GR.bFSMO_Droop_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Droop FSMO from EU                       						*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rP_FSMO_Droop_BC    				 		                    *)
	(* - OUT_CU.tCU2GR.bFSMO_Droop_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rP_FSMO_Droop_BC;        (* bus: scaling value for Droop FSMO from EU [%]  	*)
	OUT_CU.tCU2GR.bFSMO_Droop_BC_SetErr;   (* Droop FSMO measuring signal failure               *)
	(********************************************************************************************)
	(************************* Deadband FSMU*****************************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bFSMU_DB_AI_COn := IN_CU.tHA2CU.tSet_FSMU_DB_COn.Di;
	OUT_CU.tCU2GR.bFSMU_DB_AI_COf := IN_CU.tHA2CU.tSet_FSMU_DB_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bFSMU_DB_BC_COn;
	OUT_CU.tCU2GR.bFSMU_DB_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  -Deadband FSMU from EU				         						*)
	(* to do:																		        	*)
	(* - OUT_CU.tCU2GR.rF_FSMU_DB_BC	              				 		                    *)
	(* - OUT_CU.tCU2GR.bFSMU_DB_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rF_FSMU_DB_BC;           (* bus: scaling value for Deadband FSMU from EU [Hz] *)
	OUT_CU.tCU2GR.bFSMU_DB_BC_SetErr;      (* Deadband FSMU measuring signal failure	    	*)
	(********************************************************************************************)
	(************************* Deadband FSMO*****************************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bFSMO_DB_AI_COn := IN_CU.tHA2CU.tSet_FSMO_DB_COn.Di;
	OUT_CU.tCU2GR.bFSMO_DB_AI_COf := IN_CU.tHA2CU.tSet_FSMO_DB_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bFSMO_DB_BC_COn;
	OUT_CU.tCU2GR.bFSMO_DB_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Deadband FSMO from EU         			            			*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rF_FSMO_DB_BC       				 		                    *)
	(* - OUT_CU.tCU2GR.bFSMO_DB_BC_SetErr - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rF_FSMO_DB_BC;        (* bus: scaling value for Deadband FSMO from EU [Hz]    *)
	OUT_CU.tCU2GR.bFSMO_DB_BC_SetErr;  	(* Deadband FSMO measuring signal failure	            *)
	(********************************************************************************************)
	(************************* Positive Margin FSM***********************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bFSM_RMC_Up_AI_COn := IN_CU.tHA2CU.tSet_FSM_RMC_Up_COn.Di;
	OUT_CU.tCU2GR.bFSM_RMC_Up_AI_COf := IN_CU.tHA2CU.tSet_FSM_RMC_Up_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bFSM_RMC_Up_BC_COn;
	OUT_CU.tCU2GR.bFSM_RMC_Up_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Positive Margin FSM from EU                 						*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rP_FSM_RMC_Up_BC    				 		                    *)
	(* - OUT_CU.tCU2GR.bFSM_RMC_Up_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rP_FSM_RMC_Up_BC;       (* bus: scaling value for Positive Margin FSM from EU [%Pn] *)
	OUT_CU.tCU2GR.bFSM_RMC_Up_BC_SetErr;  (* Positive Margin FSM measuring signal failure       *)
	(********************************************************************************************)
	(************************* Negative Margin FSM***********************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bFSM_RMC_Down_AI_COn := IN_CU.tHA2CU.tSet_FSM_RMC_Down_COn.Di;
	OUT_CU.tCU2GR.bFSM_RMC_Down_AI_COf := IN_CU.tHA2CU.tSet_FSM_RMC_Down_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bFSM_RMC_Down_BC_COn;
	OUT_CU.tCU2GR.bFSM_RMC_Down_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Negative Margin FSM from EU         					        	*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rP_FSM_RMC_Down_BC  				 		                    *)
	(* - OUT_CU.tCU2GR.bFSM_RMC_Down_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rP_FSM_RMC_Down_BC;        (* bus: scaling value for Negative Margin FSM from EU [%Pn] *)
	OUT_CU.tCU2GR.bFSM_RMC_Down_BC_SetErr;   (* Negative Margin FSM measuring signal failure    *)
	(********************************************************************************************)
	(************************* Droop U***********************************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bU_Droop_AI_COn := IN_CU.tHA2CU.tSet_U_Droop_COn.Di;
	OUT_CU.tCU2GR.bU_Droop_AI_COf := IN_CU.tHA2CU.tSet_U_Droop_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bU_Droop_BC_COn;
	OUT_CU.tCU2GR.bU_Droop_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Droop U from EU         					                    	*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rU_Droop_BC         				 		                    *)
	(* - OUT_CU.tCU2GR.bU_Droop_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rU_Droop_BC;          (* bus: scaling value for Droop U from EU [%]           *)
	OUT_CU.tCU2GR.bU_Droop_BC_SetErr;   (* Droop U measuring signal failure                     *)
	(********************************************************************************************)
	(************************* Rampe rate********************************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bFSM_Rmp_AI_COn := IN_CU.tHA2CU.tSet_FSM_Rmp_COn.Di;			
	OUT_CU.tCU2GR.bFSM_Rmp_AI_COf := IN_CU.tHA2CU.tSet_FSM_Rmp_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bFSM_Rmp_BC_COn;
	OUT_CU.tCU2GR.bFSM_Rmp_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Rampe rate UP from EU         					            	*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rP_FSM_Rmp_Up_BC and OUT_CU.tCU2GR.rP_FSM_Rmp_Down_BC        *)
	(* - OUT_CU.tCU2GR.bFSM_Rmp_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rP_FSM_Rmp_Up_BC;      (* bus: scaling value for Rampe rate UP from EU [%Pnom/s]	    *)
	OUT_CU.tCU2GR.rP_FSM_Rmp_Down_BC;    (* bus: scaling value for Rampe rate DOWN from EU [%Pnom/s]	    *)
	OUT_CU.tCU2GR.bFSM_Rmp_BC_SetErr;    (* Rampe rate measuring signal failure                 *)
	(********************************************************************************************)
	(************************* Reference Frequency FSM/LFSM**************************************)	
	(*Activating - HW --> To connect or to set fix value    		         			   		*)
	OUT_CU.tCU2GR.bF_Ref_FSM_AI_COn := IN_CU.tHA2CU.tSet_F_Ref_FSM_COn.Di;
	OUT_CU.tCU2GR.bF_Ref_FSM_AI_COf := IN_CU.tHA2CU.tSet_F_Ref_FSM_COf.Di := TRUE;	
	(*
	(*Activating - via Bus signal																*)
	OUT_CU.tCU2GR.bF_Ref_FSM_BC_COn;
	OUT_CU.tCU2GR.bF_Ref_FSM_BC_COf := TRUE;
	(*																							*)
	(* BUSSIGNAL connection  - Reference Frequency FSM/LFSM from EU         	            	*)
	(* to do:																		        	*)
	(* - BusSetpoint OUT_CU.tCU2GR.rF_Ref_FSM_BC       				 		                    *)
	(* - OUT_CU.tCU2GR.bF_Ref_FSM_BC_SetErr generieren - falls TRUE wird der Backupwert (Parameter) verwendet*)
	OUT_CU.tCU2GR.rF_Ref_FSM_BC;      (* bus: scaling value for Reference Frequency FSM/LFSM from EU [%]	*)
	OUT_CU.tCU2GR.bF_Ref_FSM_BC_SetErr;   (* Reference Frequency FSM/LFSM measuring signal failure*)
	(********************************************************************************************)
	(************************* Control bit for blocking module***********************************)	
	OUT_CU.tCU2GR.bCheck_CU2GR := IN_CU.tHA2CU.bCheck_HA2CU AND IN_CU.tGR2CU.bCheck_GR2CU;
	(********************************************************************************************)		
	(********************************************************************************************)
	
	(********************************************************************************************)
	(************** ILF - I n t e g r a l  L o c a l  F r e q u e n c y *************************)
	(********************************************************************************************)
	(*(DE)Activating  - HW --> To connect or to set fix value    		         			    *)
	OUT_CU.bILF_SetCOn	:= IN_CU.tSet_ILF_COn.Di; 					(* DI: ILF - on (activate)	*)
	OUT_CU.bILF_SetCOf	:= IN_CU.tSet_ILF_COf.Di := TRUE; 		 (* DI: ILF - off (deactivate)	*)
	(*																							*)
	(*(DE)Activating - bus																		*)
	OUT_CU.bSet_ILF_COn_Bus; 									   (* bus: ILF - on (activate)	*)
	OUT_CU.bSet_ILF_COf_Bus	:= TRUE; 						    (* bus: ILF - off (deactivate)  *)
	
	(*- - - - - - - - - - - F E E D B A C K  S I G N A L S  - - - - - - - - - - - - - -- - - -  *)
	IN_CU.tILF_SOn.Do;								(*  ILF is on								*)
	IN_CU.tILF_SOf.Do;    							(*  ILF is off								*)
	(********************************************************************************************)

END_PROGRAM
