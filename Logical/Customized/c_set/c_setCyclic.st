(*******************************************************************************
c_set 			customized power SETPOINTS

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
								History cleanup, Version based on V4.02.1	04.03.2015: prepared interface FOR different PI timing (->Caks Michael)
V4.03.0	12.11.2015 Zengerer		P_Set_ExtAI_Norm  changed fallback logic; REACTIVETED DI POWER SETPOINT LOGIC AND PARAMETER HERE! (since code IN GRID CODE task statGR HAS GOT A DIFFERENT FUNCTIONALITY  
		22.12.2015 Ze/Caks		Para.bCA_IgnP_CylOffset_Active
V4.04.1 05.09.2017 zengerer		Nachziehen der Netzbezugsregler Änderungen von Schwab Christoph / Caks Michael aus File Bugs&Solution_MnsCtrl.zip
V4.04.5 10.10.2017 Zengerer		Update with interfaces from BASISUPDATE 4.04.00.05 iIdx_Pred_Type State
V4.05.0 10.10.2017 zengerer		prepared interface for adopted gasmixing setpoint at testbench or for customized applications 
V4.05.1 07.03.2018 zengerer		cleanup
		30.01.2019 Hohensinner	added new interfaces to OP and GC
		20.03.2019 Hohensinner	Added external controller interface
V4.07.1	03.04.2019 Hohensinner	Added Parameter Info for new interfaces and comments
V4.09.0 22.01.2020 zengerer		avoid P setpoint switching with 0mA Value:	(IN_CU.tP_Set_ExtAI_Norm.GoodQual OR Para.rI_P_Set_ExtAI_NormScalMin < 0.004)
V4.10.0	16.10.2020 Weitzer 		Release of custom GCB synchronization demand OUT_CU.bCust_Dem_Sy and MCB re-synchronization demand OUT_CU.bCust_Dem_RSy added
		19.01.2021 Weitzer		Custom synchronization blocking added (OUT_CU.bBloc_SY_Rel_Cust)
		27.01.2021 Zengerer		TOF_N_Set_ExtAI_Norm_GoodQual T#12s delay,
		28.01.2021 Zengerer		power setpoint range limitation min #53
		12.03.2021 Zengerer		#262- Conditions internal or bus speed setpoint active for speed offset:	AND	(IN_CU.iMsg[2136]>0 OR IN_CU.iMsg[2137]>0) 
V4.10.1	xx.08.2021 Ze, GruberK.	Issue #530 ...need N_Offset and not external setpoint; limit value to parameter values
V4.11.0	16.08.2021 Keller		External Droop Power setpoint (AI, Bus), iSource_F_N_OffsSet
V4.11.0	16.08.2021 Weitzer 		Delete W_XXmA constant variables
		21.01.2022 MayerR	    AI scaling and signal source selection for OUT_CU.rUset_Isl moved to GC module(v_ctr) and Bus interfaces (OUT_CU.rUset_Isl_Bus and OUT_CU.rQset_Droop_Bus) added 
V4.11.1 31.05.2022 lettenb.		default setting OUT_CU.bCust_Dem_RSy := TRUE -> FALSE(RSy only in case of customer demand), bugfix
V4.12.0 22.01.2023 Zuschnig		H2 content via bus added
V4.13.0	25.05.2023 Zengerer 	Speed Setpoint limitation #1106 
		24.08.2023 Zengerer		IN_CU.bMsg[xxxx] introduced
		16.10.2023 Bachler  	add OUT_CU.bOtherGeneratorsInLSL for bumpless transition to LSL
		20.11.2023 Farre		interfaces to SY, OP, GC, GR needed for Microgrid applications (2023-168)
		29.11.2023 Goenczi		add new interfaces to SY and OP

		
Instructions for use:
--------------------
connect var's for customized power setpoints   

! ALL SETPOINTS HAVE TO BE NORMED FROM 0 to 1 EQUALS 0 to P nominal

Outstandings:
------------
TODO: CHECK NEW CUSTOMISED PARA vvm/addPLCtag 

  adopt this task according customer needs

! Be aware, that several setpoints are also influenced from GRID CODE MODULE, if this is engaged !

*******************************************************************************)



PROGRAM _CYCLIC	
	
	(*----------------------------------------------------------------------------------*)
	(* external DI request power setpoints *) (*REACTIVETED SETPOINT LOGIC AND PARAMETER HERE! (since code IN GRID CODE task statGR HAS GOT A NEW FUNCTIONALITY *)
	(*----------------------------------------------------------------------------------*)
	(* power setpoint according external request digital inputs *)
	IF    IN_CU.tP_GenC_SetFix5EU.Di	THEN									
		OUT_CU.rP_Set_ExtDI_Cust_Norm	:=	LIMIT(0.4, Para.rP_Set5_ExtDI_Norm, 1.0); 	(*OldName: AW_EXPSH_DI; Cycle: 5;*)
	ELSIF IN_CU.tP_GenC_SetFix4EU.Di	THEN									
		OUT_CU.rP_Set_ExtDI_Cust_Norm	:=	LIMIT(0.4, Para.rP_Set4_ExtDI_Norm, 1.0);
	ELSIF IN_CU.tP_GenC_SetFix3EU.Di	THEN									
		OUT_CU.rP_Set_ExtDI_Cust_Norm	:=	LIMIT(0.4, Para.rP_Set3_ExtDI_Norm, 1.0);
	ELSIF IN_CU.tP_GenC_SetFix2EU.Di	THEN
		OUT_CU.rP_Set_ExtDI_Cust_Norm	:=	LIMIT(0.4, Para.rP_Set2_ExtDI_Norm, 1.0);
	ELSIF IN_CU.tP_GenC_SetFix1EU.Di	THEN
		OUT_CU.rP_Set_ExtDI_Cust_Norm	:=	LIMIT(0.4, Para.rP_Set1_ExtDI_Norm, 1.0);
	ELSE			
		OUT_CU.rP_Set_ExtDI_Cust_Norm	:=	1.0;										(* replacement for rP_Set_ExtDI_Norm *)
	END_IF;


	OUT_CU.bP_Set_ExtDI_Enable := 	IN_CU.tP_GenC_SetFix1EU.Di OR
									IN_CU.tP_GenC_SetFix2EU.Di OR
									IN_CU.tP_GenC_SetFix3EU.Di OR
									IN_CU.tP_GenC_SetFix4EU.Di OR
									IN_CU.tP_GenC_SetFix5EU.Di;		(* or connect customized?*)


	
	(* power setpoint *)
	(******************)
	IF Para.bCtr_Mns_Enable AND IN_CU.tDem_Ctr_Mns.Di THEN
		rP_Set_ExtAI_Norm := OUT_CU.rP_Set_Mns_Norm;				(*old compatibility version, only for EngineController without rP_Set_Ctr_Mns_Norm*)
		OUT_CU.rP_Set_Ctr_Mns_Norm := OUT_CU.rP_Set_Mns_Norm;	(*new Interface V4.5, (in use for Ctr_Mns from V4.5 on)*)
		OUT_CU.bP_Set_Ctr_Mns_Enable := TRUE;					(*new Interface V4.5, (in use for Ctr_Mns from V4.5 on)*)
	ELSIF	IN_CU.rP_Nom > 0 THEN 
		rP_Set_ExtAI_Norm := IN_CU.tP_Set_ExtAI_Norm.Ai / IN_CU.rP_Nom;		(* parameter are entered in KW, so convert Setpoint to Norm    *)
		OUT_CU.rP_Set_Ctr_Mns_Norm := rP_Set_ExtAI_Norm;	
		OUT_CU.bP_Set_Ctr_Mns_Enable := FALSE;				
	ELSE
		rP_Set_ExtAI_Norm := 1.0;
		OUT_CU.rP_Set_Ctr_Mns_Norm := rP_Set_ExtAI_Norm;	
		OUT_CU.bP_Set_Ctr_Mns_Enable := FALSE;				
	END_IF
			(* scaling (DISABELED HERE! NO additional scaling here, allready done in the HAL (with this customized parameter) *)		
				Para.rI_P_Set_ExtAI_NormScalMin;	Para.rI_P_Set_ExtAI_NormScalMax;
				Para.rP_Set_ExtAI_NormScalMin;		Para.rP_Set_ExtAI_NormScalMax;

	IF 	(IN_CU.iIdx_OMSS = 2) AND 										(* =operating switch AUTO *)
		(IN_CU.iIdx_RSS = 2) AND 										(* =remote service selected *)
		(IN_CU.tP_Set_ExtAI_Norm.GoodQual								(* =analog input signal is ok *)
		  OR Para.rI_P_Set_ExtAI_NormScalMin < 0.004) 
	THEN 																(* BWS_A AND Remote AND signal check is ok AND <deleted> *)
		OUT_CU.rP_Set_ExtAI_Norm := LIMIT(0.4,rP_Set_ExtAI_Norm, 1.0);	(*= analog power setpoint range limitation (V4.10 changed min)*)	
		OUT_CU.bP_Set_ExtAI_Enable := TRUE ; 	 						(*OldName: AW_EXPSH_AI; Cycle: 5;*)
	ELSE
		OUT_CU.rP_Set_ExtAI_Norm := 0.50;								(*V4.03: changed fallback logic to standard min. load point*)
		OUT_CU.bP_Set_ExtAI_Enable := FALSE; 							(*OldName: AW_EXPSH_AI; Cycle: 5;*)
	END_IF
	
	(* speed setpoint *) 
	(******************)
	IF Para.rN_EngNom > 0 THEN  
		rN_Set_ExtAI_Norm := IN_CU.tN_Set_ExtAI_Norm.Ai / Para.rN_EngNom;		(* parameter are entered in KW, so convert Setpoint to Norm    *)
	ELSE
		rN_Set_ExtAI_Norm := 1.0;
	END_IF
			(* scaling (DISABELED HERE! No additional scaling here, allready done in the HAL (with this customized parameter) *)		
			Para.rI_N_Set_ExtAI_NormScalMin;	Para.rI_N_Set_ExtAI_NormScalMax;		
			Para.rN_Set_ExtAI_NormScalMin; 		Para.rN_Set_ExtAI_NormScalMax;		

	TOF_N_Set_ExtAI_Norm_GoodQual(IN := IN_CU.tN_Set_ExtAI_Norm.GoodQual, PT := T#12s);		(*V4.10 delay*)
	IF  (IN_CU.iIdx_OMSS = 2) AND 
		(IN_CU.iIdx_RSS = 2) AND
		TOF_N_Set_ExtAI_Norm_GoodQual.Q AND NOT
		(OUT_CU.iSource_F_N_OffsSet = 2) 			// typicaly needed N_Offset, not the external setpoint of previous default													(*V4.10 delay*)
//		IN_CU.tN_Set_ExtAI_Norm.GoodQual 
// 		AND (Para.rI_N_Set_ExtAI_NormScalMin >0.004) 
	THEN
		OUT_CU.rN_Set_ExtAI_Norm := LIMIT(0.9, rN_Set_ExtAI_Norm, 1.05);	(*= analog speed offset limitation  Limits adopted acc. issue #1106, 2023*)	
		OUT_CU.bN_Set_ExtAI_Enable := TRUE ; (* *) 					(*OldName: AW_EX?SH_AI; Cycle: 5;*)
	ELSE
		OUT_CU.rN_Set_ExtAI_Norm := 1.0;
//		OUT_CU.bN_Set_ExtAI_Enable := FALSE ; (* *) 				(*OldName: AW_EX?SH_AI; Cycle: 5;*)
		OUT_CU.bN_Set_ExtAI_Enable := xOpMode.Island AND (Para.rI_N_Set_ExtAI_NormScalMin >0.004) AND TOF_N_Set_ExtAI_Norm_GoodQual.Q AND (OUT_CU.iSource_F_N_OffsSet = 2);  // Gruber K. - we need N_Offset and not external setpoint
		
	END_IF	
				IN_CU.iMsg[2136]	;	(*display response: B2136 internal speed setpoint *)
 				IN_CU.iMsg[2137]	;	(*display response: B2137 external speed setpoint(bus) *)
				IN_CU.iMsg[2138]	;	(*display response: B2138 external speed setpoint(analoge) *)	
	
	
	(******************************************************)
	(* Leistungsgrenzwert 1 - Customized z.b. ?Anforderung Lastabwurf? *)
	(*FEHLT NOCH:	GW_PGW1	   := DINT_TO_INT((INT_TO_DINT(PN_GASART) * Z_GW_PGW1  + 500) / 1000); *)
	Para.rP_Custom1_Norm_LimHi;		(* rP_Lim_Custom1_Norm == Z_GW_PGW1 = Para-Leistung-Grenzwerte-GRENZWERT 1 *)
	Para.rP_Custom1_Norm_HyHi;		(*FEHLT NOCH: 	HY_PGW1 ? Vorschlag  *)
		
(*FEHLT NOCH:	LAST_ABW :=  ( M_GSEIN AND NOT NS_EIN AND GW_PGW1 ) OR BL_OUT; *)	(*aus task pb8 -> wohin damit?*)
	


	(******************************************************)
	(* forwarding the parameter for different ignition timing on individual cylinders at testbench or for customized applications *)
	FOR ucCylinderCount := 1 TO 24 DO    (* bSetIndivTim can be used for tests                      *)
	       OUT_CU.rCA_IgnP_CylOffset[ucCylinderCount] := Para.rCA_IgnP_CylOffset[ucCylinderCount] * BOOL_TO_REAL(Para.bCA_IgnP_CylOffset_Active);     
	END_FOR



	(******************************************************)
	(* prepared interface for different PI timing on individual cylinders at testbench or for customized applications *)
     	OUT_CU.rCA_PI_Dur_COffset[1] := 0; 		(* custom PI duration offset cyl.1  *) (* OldName: ssTestBenchOffset *)
     	OUT_CU.rCA_PI_Dur_COffset[24] := 0; 	(* custom PI duration offset cyl.24 *) (* OldName: ssTestBenchOffset *)


	(******************************************************)
	(* prepared interface for adopted gasmixing setpoint *)
		OUT_CU.bOptGT_RatioMix_Set 	:= FALSE;   //:= TRUE; 		
 		OUT_CU.rGT_RatioMix_Set;				(* Fuel blending setpoint -> 0 - 1 = 0 - 100% )

	(******************************************************)


	(*** Enable bit for external speed / voltage controller ***)
	OUT_CU.bExtCtrOk := NOT IN_CU.tExtCtrOk.GoodQual OR IN_CU.tExtCtrOk.Di;		(* DI for use with ComAp or another external speed / voltage controller *)

	(*** Reactive power setpoint for voltage droop mode ***)
	(* Conversion:		1.0					100%Snom		*)
	(* Value range:		-1.0 to 1.0		-100% to 100%Snom	*)
	(* Build in Ramp:	0.01/s				1%Unom/s   		*)
	(* Enable:			Parameter 14298 must be set to 1	*)
	(* Droop gradient:	Parameter 14299						*)
	OUT_CU.rQset_Droop_Bus;									(* External reactive power setpoint for frequency droop mode over Bus - for project specific usage *)
	
	(* Voltage setpoint in Isolated operation, 0= no setpoint, 1= Droop, 2= External *)
	OUT_CU.rUset_Isl_Bus;									(* External Voltage setpoint (Island operation) over Bus - for project specific usage *)
	
	(*** Speed offset setpoint in Isolated operation ***)
	(* Conversion:		1.0					1 rpm			*)
	(* Value range:		-50	to +50			-50 to +50 rpm	*)
	(* Enable:			Parameter 14300 must be set to 2	*)
	IF IN_CU.tN_Set_ExtAI_Norm.GoodQual AND OUT_CU.bExtCtrOk THEN
		(* Check if value --> -50 to +50, Parameter 11781 should be -50 rpm & 11780 should be +50 rpm  *)
		IF		Para.rN_Set_ExtAI_NormScalMax < 150.0 
			AND	Para.rN_Set_ExtAI_NormScalMin > -150.0
			//AND	(IN_CU.iMsg[2136]>0 OR IN_CU.iMsg[2137]>0)	// Gruber K. - will not work with this line included		(*V4.10: Offset allowed only at internal(2136) or bus(2137) speed setpoint, to avoid duplicate speed reduction in case of alternative input use *)  
			AND NOT(IN_CU.tN_Set_ExtAI_Norm.Ai < -rN_Set_ExtAI_Limit OR IN_CU.tN_Set_ExtAI_Norm.Ai > rN_Set_ExtAI_Limit)(*V4.11: plausibility check *)
			THEN
				OUT_CU.rN_Offs_Cust		:=	LIMIT(Para.rN_Set_ExtAI_NormScalMin, IN_CU.tN_Set_ExtAI_Norm.Ai, Para.rN_Set_ExtAI_NormScalMax); (*Gruber K. - limit vlaue to parameter values*)
			(* Check if value --> 1450 to 1550, Parameter 11781 should be 0 or 1450 rpm & 11780 should be 1550 rpm *)
		ELSIF Para.rN_Set_ExtAI_NormScalMax > Para.rN_EngNom * 0.9 AND Para.rN_Set_ExtAI_NormScalMin < Para.rN_EngNom
			AND NOT(IN_CU.tN_Set_ExtAI_Norm.Ai < Para.rN_EngNom-rN_Set_ExtAI_Limit OR IN_CU.tN_Set_ExtAI_Norm.Ai > Para.rN_EngNom+rN_Set_ExtAI_Limit)(*V4.11: plausibility check *)
			THEN
			OUT_CU.rN_Offs_Cust		:=	IN_CU.tN_Set_ExtAI_Norm.Ai - Para.rN_EngNom;
			(* or implement your own solution *)							(* modify here if customer needs special scaling *)
		ELSE															(* modify here if customer needs special scaling *)
			OUT_CU.rN_Offs_Cust		:=	0.0;							(* modify here if customer needs special scaling *)
		END_IF
	ELSIF FALSE (*bN_OffsExt_Bus*) THEN									(* modify here if customer needs signal over bus *)
		OUT_CU.rN_Offs_Cust		:=	0.0;	(*rN_OffsExt_Bus*)			(* modify here if customer needs signal over bus *)
	ELSE
		OUT_CU.rN_Offs_Cust		:=	0.0;
	END_IF	

	(*** Power setpoint for speed/frequency droop mode ***)
	(* Conversion:		1.0					100%Pnom		*)
	(* Value range:		0.0	to 1.0			0% to 100%Pnom	*)
	(* Build in Ramp:	Parameter 12095 & 13373	in %Pnom/s	*)
	(* Enable:			Parameter 14300 must be set to 1	*)
	(* Droop gradient:	Parameter 12109						*)
	OUT_CU.bP_Droop_Set_Bus;									(* Enable Droop power setpoint by Bus (if both true: has priority over AI)*)
	OUT_CU.bP_Droop_Set_AI; 									(* Enable Droop power setpoint by Analog input *)
	
	(** Fallback for power setpoint **)
	(* fallback if bP_Droop_Set_Bus = TRUE AND bus communication not OK *)
	(* fallback if bP_Droop_Set_AI = TRUE AND tP_Droop_Set.GoodQual = FALSE *)	
	(* selection fallback mode, 0: default Para, 1: freeze last value*)
	OUT_CU.iIdx_Droop_SetDefaultCase 	:= Para.iIdx_Droop_SetDefaultCase;
	OUT_CU.rP_Set_Default_Norm 			:= Para.rP_Set_Default_Norm;
	
	(* Bus *)
	OUT_CU.rP_Droop_Set_Bus_Norm;(* HERE: implementation Droop setpoint bus interface *)
	IF NOT(IN_CU.bMsg[1147] OR IN_CU.bMsg[1099]) AND NOT(OUT_CU.rP_Droop_Set_Bus_Norm < -0.1 OR OUT_CU.rP_Droop_Set_Bus_Norm > 1.5) THEN
		rP_Droop_Set_Bus_old_Norm 		:= OUT_CU.rP_Droop_Set_Bus_Norm; 		(* save last valid setpoint *)
	ELSIF OUT_CU.iIdx_Droop_SetDefaultCase = 0 THEN
		OUT_CU.rP_Droop_Set_Bus_Norm	:= OUT_CU.rP_Set_Default_Norm;			(* 0: fallback, default parameter *)
	ELSIF OUT_CU.iIdx_Droop_SetDefaultCase = 1 THEN
		OUT_CU.rP_Droop_Set_Bus_Norm	:= rP_Droop_Set_Bus_old_Norm;			(* 1: fallback, freeze last valid setpoint *)
	ELSE
		OUT_CU.rP_Droop_Set_Bus_Norm	:= OUT_CU.rP_Set_Default_Norm;
	END_IF;
	
	(* Analog input *)
	IF IN_CU.tP_Droop_Set.GoodQual AND NOT(IN_CU.tP_Droop_Set.Ai < -0.1 OR IN_CU.tP_Droop_Set.Ai > 1.5) THEN
		OUT_CU.rP_Droop_Set_AI_Norm 	:= IN_CU.tP_Droop_Set.Ai;
		rP_Droop_Set_AI_old_Norm		:= OUT_CU.rP_Droop_Set_AI_Norm;  		(* save last valid setpoint *)
	ELSIF OUT_CU.iIdx_Droop_SetDefaultCase = 0 THEN
		OUT_CU.rP_Droop_Set_AI_Norm		:= OUT_CU.rP_Set_Default_Norm;			(* 0: fallback, default parameter *)
	ELSIF OUT_CU.iIdx_Droop_SetDefaultCase = 1 THEN
		OUT_CU.rP_Droop_Set_AI_Norm		:= rP_Droop_Set_AI_old_Norm;			(* 1: fallback, freeze last valid setpoint *)
	ELSE
		OUT_CU.rP_Droop_Set_AI_Norm 	:= OUT_CU.rP_Set_Default_Norm;
	END_IF;
	
	(* Load Sharing Mode, 0= no setpoint, 1= Droop, 2= External, 3= LSL *)
	OUT_CU.iSource_F_N_OffsSet := Para.iSource_F_N_OffsSet;
	MM2VIS.iSource_F_N_OffsSet := OUT_CU.iSource_F_N_OffsSet;
	
	(* Other Generators In Load Sharing Line *)
	(* If TRUE: 		Other engines are participating in the load sharing line *)
	(* Info: 			If this input is not provided a non smooth transition between LSL and the other load sharing modes will happen *)
	OUT_CU.bOtherGeneratorsInLSL;

	(*** Custom Engine demand ***)
	(* If TRUE:			Engine is demanded in AUTO & REMOTE	*)	
	(* Info:			Add an Operating message why the engine is being demanded *)
	OUT_CU.bCust_Dem;

	(*** Custom Engine blocked ***)
	(* If TRUE:			Engine is blocked					*)	
	(* Info:			If you want to block engine only in Stop mode use: 'bYourBit AND NOT bEng_StaSpdExc' *)
	OUT_CU.bEng_Block_Customized;

	(*Custom Emergency Power Supply release/demand*)

	(*** Release Island bit via Bus coupling ***)
	(* If FALSE:		Release island is blocked						*)	
	(* Info:			Default value must be TRUE *)
	OUT_CU.bRel_I_Bus := TRUE;
	
	(*** Custom Release Island bit ***)
	(* If FALSE:		Release island is blocked						*)	
	(* Info:			Default value must be TRUE *)
	OUT_CU.bCust_Rel_I := TRUE;
	
	(*** Custom Release Island operation busbar condition (if FALSE, mains cut-off with gcb) ***)
	(* If TRUE:			VKE10 condition TRUE					*)	
	(* Info:			DO NOT CONFUSE WITH bRel_I Release island external bit!!! --- Default value must be FALSE *)
	OUT_CU.bCust_RelI_BB := FALSE;
	
	(*** Custom Emergency Power supply demand SY modul ***)
	(* If TRUE:			Additional demand condition to change to EPS mode in SY/sy_out task				*)	
	(* Info:			Default value must be TRUE *)
	OUT_CU.bCust_Dem_EPS_Sy := TRUE;

	(*** External Emergency Power supply demand from Bus ***)
	(* If TRUE:			Emergency Power supply ON				*)	
	(* Info:			Default value must be FALSE *)
	OUT_CU.bEng_Dem_EPS_Bus := FALSE;
	
	(*** Smooth engine discharge in multi engines island mode ***)
	(* If TRUE:			Engine is not demanded for island, request auto blocked, but release island is still active - 
						engine runs until P_Lo reached and GCB opens - other genset has to be demanded and on (GCB_OGP) to take load + on site load shedding device					*)	
	(* Info:			For single engine it is FALSE as EngDemIsland label does not exist, *)
	OUT_CU.bSmoothDischarge_CU := NOT bOMSS_Man	AND NOT IN_CU.tEngDemIsland.Di;
	
	(* CH4 signal from BUS system *)
	(* If TRUE:			CH4 signal is sent via bus if parameter [11364] is active 				*)	
	OUT_CU.bCH4_Bus_Active;	
	(* Info:			CH4 signal - 1.0 = 100%													*)	
	OUT_CU.rCH4_Bus;

	(* H2 signal from BUS system *)
	(* If TRUE:			H2 signal is sent via bus if parameter [14901] is active 				*)	
	OUT_CU.bH2_Bus_Active;	
	(* Info:			H2 signal - 1.0 = 100%													*)	
	OUT_CU.rH2_Bus;	
	(* If FALSE:		Measurement signal failure H2 content if OUT_CU.bH2_Bus_Active active	*)	
	OUT_CU.bH2_Bus_MSF;

	(* CV signal from BUS system *)	
	(* If TRUE:			CV signal is sent via bus if parameter [11367] is active 				*)
	OUT_CU.bCV_Bus_Active;		
	(* Info:			CV signal in [kWh/Nm3]													*)
	OUT_CU.rCV_Bus;

	(* Info:			Calibration signal from bus or IN_GT.tGT_CalibrateActive.Di can be used *)				
	OUT_CU.bGT_CalibrateActive_Bus;

	(* Release gas plant signal from BUS system *)
	(* If TRUE:			Release gas plant signal is sent via bus 				 				*)	
	OUT_CU.bRelGasPlant_Bus_Active;
	(* If FALSE:			Release from gas plant missing										*)	
	OUT_CU.bRelGasPlant_Bus;
	
	(* External Synchroniszation by Customer *)
	
	(*** Custom GCB synchronization demand     ***)
	(* If TRUE:			GCB Sync is released	 *)	
	(* Info:									 *)
	OUT_CU.bCust_Dem_Sy := TRUE;
	
	(*** Custom MCB re-synchronization demand  ***)
	(* If TRUE:			MCB Re-Sync is released  *)	
	(* Info:			 						 *)
	OUT_CU.bCust_Dem_RSy := FALSE;
		
	(*** Custom synchronization blocking         ***)
	(* If TRUE:			synchronisation is blocked *)	
	(* Info:			 						   *)
	OUT_CU.bBloc_SY_Rel_Cust := FALSE;
	
	(*** Microgrid Interfaces to SY, GC, GR, OP   ***)
	(* Bypass MCB status - dead busbar *)
	OUT_CU.bBypassMCB_deadBB 	:= FALSE;
	(* Bypass MCB status - soft energisation *)
	OUT_CU.bSoftEnergDem	 	:= FALSE;
	OUT_CU.bBypassMCB_SoftStart := FALSE;
	(* Bypass MCB status - load shedding *)
	OUT_CU.bBypassMCB_LoadShed	:= FALSE;
	(* Bypass MCB status - Cos Phi Ctrl *)
	OUT_CU.bBypassMCB_CosPhi	:= FALSE;
	(* Bypass MCB status - FSM *)
	OUT_CU.bBypassMCB_FSM		:= FALSE;
	(* Dead band definition for FSM/LFSM *)
	OUT_CU.bDroopDB_Active	    := FALSE;
	OUT_CU.rDB_FSM_LFSM			:= 0.5; //standard value
	(* request power mode *)
	OUT_CU.bReq_PowMod := IN_CU.tReq_PowMod.Di;
	(* extended power operation range *)
	OUT_CU.bExtendedOpRangeRel	:= FALSE;
	OUT_CU.rP_Set_Min_Norm_Ext	:= 0.5; (* !! rP_Set_Min_Norm internally limited to 10% !!*)

	(* Engine calibration TO EC - PVcheckNEW - ONLY USE AFTER AGREEMENT WITH SYSTEM OWNER EC!!! *)
	OUT_CU.iAggrekoEngineVersion 	:= 0;				(* Aggreko egine version: 1 = J420B, 2 = J420C, 3 = J420E *)
	OUT_CU.iAggrekoTCConfig		:= 0;				(* Aggreko CBV configuration: 1 = TA40, 2 = TA45, 3 = TA65 *)
	
END_PROGRAM

