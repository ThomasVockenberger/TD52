(*******************************************************************************
CUSTOMIZED: c_fc 			customized frequency control

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V4.04.0 13.06.2016 Gwiggner   new
V4.04.2 30.06.2017 Gwiggner	  update test function	
V4.05.0 18.06.2018 Gwiggner	  Bugfix: power setpoint for Next-Box hardwire	
V4.07.0 25.03.2019 Zuschnig	  Frequency filter, Testfunction	
V4.07.0 01.10.2019 Gwiggner	  avoiding division by 0
V4.09.0 28.11.2019 lettenb.   FSM man.test function, change of frequency via setable ramp (gridcode/lukas)
		09.03.2019 lettenb.	  man.test function also activ for FSM without LFSM(lukas)
V4.11.0 29.09.2021 lettenb.   xTP_Set_FC_Test_1.PT:= T#90m -> T#180m, to do Test1 complete, bugfix
                              tF_FSM_Simulated.Ao added
                              execute xRAMP_F_x always to avoid long settling time with test activation

Instructions for use:
--------------------
Use this task to configure Frequency Control (Grid Code) and ECU Power Limitation

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC	
	


	(*-----------------------------------------------------------------------------*)
	
	(* metered values *)
	(*------------------------Moving Average---------------------------------------*)
	FreqIst_ind[fmw_zaehler]  := IN_CU.tF_MMD_BusBar[1].Ai;	
	fmw_zaehler := fmw_zaehler + 1;

	IF fmw_zaehler >15 THEN
		fmw_zaehler := 1;
	END_IF;

	rF_MMD_FC_Avg := (FreqIst_ind[1]  + FreqIst_ind[2]  + FreqIst_ind[3] + FreqIst_ind[4]  + FreqIst_ind[5]		// Frequency for FSM/LFSM functions - moving average
					 +FreqIst_ind[6]  + FreqIst_ind[7]  + FreqIst_ind[8] + FreqIst_ind[9]  + FreqIst_ind[10]
					 +FreqIst_ind[11] + FreqIst_ind[12] +FreqIst_ind[13] + FreqIst_ind[14] + FreqIst_ind[15])/15;
	(*-----------------------------------------------------------------------------*)

	(*------------------------Lowpassfilter with Deadband--------------------------*)	
	xFilter_R_MMD_GR(In	:= IN_CU.tF_MMD_BusBar[1].Ai, Filter :=	Para.iT_FreqFilt_TB * 10);					// Lowpassfilter for Frequency for FSM/LFSM functions
	rF_Delta_BB_PT1 := IN_CU.tF_MMD_BusBar[1].Ai - xFilter_R_MMD_GR.Out;
	
	IF rF_Delta_BB_PT1 > Para.rF_Deadband_TB THEN   														// Deadband for Frequency for FSM/LFSM functions	
		rF_Deadband_OUT := rF_Delta_BB_PT1 - Para.rF_Deadband_TB;
	ELSIF rF_Delta_BB_PT1 < - Para.rF_Deadband_TB THEN
		rF_Deadband_OUT := rF_Delta_BB_PT1 + Para.rF_Deadband_TB;
	ELSE
		rF_Deadband_OUT := 0;
	END_IF;

	rF_Summ_DB_PT1 := rF_Deadband_OUT  + xFilter_R_MMD_GR.Out;												
	(*-----------------------------------------------------------------------------*)

	IF Para.iT_FreqFilt_TB = 0 THEN																			// If TB of Filter is zero moving average is used
		rF_MMD_FC := rF_MMD_FC_Avg;
	ELSE
		rF_MMD_FC := rF_Summ_DB_PT1;
	END_IF;
	
	OUT_CU.rF_MMD_FC := rF_MMD_FC; 
	(*------------------------End of Frequency Filter------------------------------*)
	
	(* Inputs Bus E2M *)
		
	bSet_FC_COn_Bus;																// activation of frequency control (Bus)
	bSet_FC_COf_Bus;																// de-activation of frequency control (Bus)
	iP_FC_RMC_pos_Bus;																// reserve power [kW] for PRL pos (Bus)					
	iP_FC_RMC_neg_Bus;																// reserve power [kW] for PRL neg (Bus)
	
	
	(* Outputs Bus E2M *)
	
	rP_Act_FC_Bus := rP_Act_Filt;													// actual power frequency control FC
	rF_Set_FC_Bus := Para.rFNom_LFSM_Ref;											// frequency setpoint FC
	rF_Act_FC_Bus := rF_MMD_FC;														// acutal frequency FC
	rP_PRLCont_FC_Bus := IN_CU.rP_FC_ContOutput;									// controller output FC
	IN_CU.bFC_SOn_Bus;																// feedback signal: FC switched on
	IN_CU.bFC_SOf_Bus;																// feedback signal: FC switched off


 	(* Inputs hardwire E2M *)
	
	OUT_CU.bFC_SetCOn;																// activation of frequency control (DI)
	OUT_CU.bFC_SetCOf;																// de-activation of frequency control (DI)
	IN_CU.tP_FC_RMC_pos.Ai;															// reserve power [%] for PRL pos (AI)
	IN_CU.tP_FC_RMC_neg.Ai;															// reserve power [%] for PRL neg (AI)
	
	
	(* Outputs hardwire E2M *)
	
	OUT_CU.tP_Act_FC.Ao := rP_Act_Filt;												// power setpoint for frequency control FC
	OUT_CU.tF_Set_FC.Ao := Para.rFNom_LFSM_Ref;										// frequency setpoint FC
	OUT_CU.tF_Act_FC.Ao := rF_MMD_FC;												// acutal frequency FC
	OUT_CU.tP_PRLCont_FC.Ao := IN_CU.rP_FC_ContOutput;								// controller output FC			
	IN_CU.tFC_SOn.Do;																// feedback signal: FC switched on
	IN_CU.tFC_SOf.Do;																// feedback signal: FC switched off
	
	
	(* Inputs Bus next-Box *)
	
	bSet_FC_COn_Bus;																// activation of frequency control (Bus)
	bSet_FC_COf_Bus;																// de-activation of frequency control (Bus)
	iP_Set_FC_Bus;																	// power setpoint [kW]

		
	(* Outputs Bus next-Box *)
	
	rF_Act_FC_Bus := rF_MMD_FC;														// acutal frequency FC (Bus)
	IN_CU.bFC_SOn_Bus;																// feedback signal: FC switched on
	IN_CU.bFC_SOf_Bus;																// feedback signal: FC switched off
	

	(* Inputs hardwire next-Box *)
	
	OUT_CU.bFC_SetCOn;																// activation of frequency control (DI)
	OUT_CU.bFC_SetCOf;																// de-activation of frequency control (DI)	
	IN_CU.tP_Set_FC.Ai;																// power setpoint [%]


	(* Outputs hardwire next-Box *)
	
	OUT_CU.tF_Act_FC.Ao := rF_MMD_FC;												// acutal frequency FC (AO)
	IN_CU.tFC_SOn.Do;																// feedback signal: FC switched on
	IN_CU.tFC_SOf.Do;																// feedback signal: FC switched off

	(* Inputs external FSM/LFSM test function *)
	OUT_CU.bSet_LFSM_Test_COn	 	:= FALSE;
	OUT_CU.bLFSM_Test_Enabled 		:= FALSE;
	OUT_CU.rF_Act_FSM_Test_Ext;
	
	(* Limitation of inputs *)

	iP_FC_RMC_pos_Bus := LIMIT (0, iP_FC_RMC_pos_Bus, REAL_TO_INT(IN_CU.rP_Nom - IN_CU.rP_Set_Min));								// limitation of positiv margin with engine nominal power
	iP_FC_RMC_neg_Bus := LIMIT (0, iP_FC_RMC_neg_Bus, REAL_TO_INT(IN_CU.rP_Nom - IN_CU.rP_Set_Min) - iP_FC_RMC_pos_Bus);			// limitation of negativ margin with engine nominal power and positiv margin

	IF IN_CU.rP_Nom <> 0 THEN
		IN_CU.tP_FC_RMC_pos.Ai := LIMIT (0, IN_CU.tP_FC_RMC_pos.Ai, (1.0 - IN_CU.rP_Set_Min/IN_CU.rP_Nom));								// limitation of positiv margin (AI)
		IN_CU.tP_FC_RMC_neg.Ai := LIMIT (0, IN_CU.tP_FC_RMC_neg.Ai, ((1.0 - IN_CU.rP_Set_Min/IN_CU.rP_Nom) - IN_CU.tP_FC_RMC_pos.Ai));	// limitation of negativ margin (AI)														// reserve power [%] for PRL neg (AI)

		iP_Set_FC_Bus := LIMIT (REAL_TO_INT(IN_CU.rP_Set_Min), iP_Set_FC_Bus, REAL_TO_INT(IN_CU.rP_Nom)); 								// limitation of power setpoint with minimal and nominal power

		IN_CU.tP_Set_FC.Ai := LIMIT (IN_CU.rP_Set_Min/IN_CU.rP_Nom, IN_CU.tP_Set_FC.Ai, 1.0);											// limitation of power setpoint with minimal and nominal power
	END_IF

	

	(* function *)
 
	rF_FC_Delta := IN_CU.tGR2CU.rFNom_LFSM_Ref - IN_CU.tF_MMD_BusBar[1].Ai; 		// frequency deviation
	
	IF Para.bSet_FC_Input = 0 THEN													// internal Input
		OUT_CU.rP_RMC_FC_pos := IN_CU.rP_Nom * IN_CU.tGR2CU.rMarg_GrC_FSM_Pos;		// Positive reserve power for PRL - FC via parameter [%]
		OUT_CU.rP_RMC_FC_neg := IN_CU.rP_Nom * IN_CU.tGR2CU.rMarg_GrC_FSM_Neg;		// Negative reserve power for PRL - FC via parameter [%]
		OUT_CU.rDroop_FC_pos := IN_CU.tGR2CU.rDroop_GrC_FSMU * 100;					// positive droop via parameter
		OUT_CU.rDroop_FC_neg := IN_CU.tGR2CU.rDroop_GrC_FSMO * 100;					// negative droop via parameter
	END_IF;

		
	IF Para.bSet_FC_Input = 1 THEN													// external Input
		CASE Para.iSet_FC_ExtInp OF 
			1: (* e2m over Bus *)
				IF bSet_FC_COn_Bus THEN												
					OUT_CU.rP_RMC_FC_pos := INT_TO_REAL(iP_FC_RMC_pos_Bus);			// Positive reserve power for PRL - FC (e2m) via BUS [kW]	
					OUT_CU.rP_RMC_FC_neg := INT_TO_REAL(iP_FC_RMC_neg_Bus);			// Negative reserve power for PRL - FC (e2m) via BUS [kW]
				ELSE
					OUT_CU.rP_RMC_FC_pos := 0.0;											
					OUT_CU.rP_RMC_FC_neg := 0.0;											
				END_IF;
							
				IF bSet_FC_COn_Bus AND Para.rFNom_LFSM_Ref  <> 0 THEN				// Droop calculation
					IF iP_FC_RMC_pos_Bus > 0 AND iP_FC_RMC_neg_Bus > 0 THEN 
						OUT_CU.rDroop_FC_pos := (Para.rF_FC_Dlt_pos - IN_CU.tGR2CU.rFSMU_GRC_DB) * IN_CU.rP_Nom / iP_FC_RMC_pos_Bus / Para.rFNom_LFSM_Ref  *100;				
						OUT_CU.rDroop_FC_neg := (Para.rF_FC_Dlt_neg - IN_CU.tGR2CU.rFSMU_GRC_DB) * IN_CU.rP_Nom / iP_FC_RMC_neg_Bus / Para.rFNom_LFSM_Ref  *100;			
					ELSIF iP_FC_RMC_pos_Bus > 0 AND iP_FC_RMC_neg_Bus = 0 THEN
						OUT_CU.rDroop_FC_pos := (Para.rF_FC_Dlt_pos - IN_CU.tGR2CU.rFSMU_GRC_DB) * IN_CU.rP_Nom / iP_FC_RMC_pos_Bus / Para.rFNom_LFSM_Ref  *100;				
						OUT_CU.rDroop_FC_neg := 0.0;
					ELSIF iP_FC_RMC_neg_Bus > 0 AND iP_FC_RMC_pos_Bus = 0 THEN
						OUT_CU.rDroop_FC_pos := 0.0;
						OUT_CU.rDroop_FC_neg := (Para.rF_FC_Dlt_pos - IN_CU.tGR2CU.rFSMU_GRC_DB) * IN_CU.rP_Nom / iP_FC_RMC_neg_Bus / Para.rFNom_LFSM_Ref  *100;				
					ELSE	
						OUT_CU.rDroop_FC_pos := 0.0;
						OUT_CU.rDroop_FC_neg := 0.0;
					END_IF;
				END_IF
				OUT_CU.bSet_FC_COn_Bus := bSet_FC_COn_Bus;						
				OUT_CU.bSet_FC_COf_Bus := bSet_FC_COf_Bus;
			
						
			2: (* e2m over hardwire *)
				IF OUT_CU.bFC_SetCOn THEN												
					OUT_CU.rP_RMC_FC_pos := IN_CU.tP_FC_RMC_pos.Ai * IN_CU.rP_Nom;	// Positive reserve power for PRL - FC (e2m) via hardwire [kW]
					OUT_CU.rP_RMC_FC_neg := IN_CU.tP_FC_RMC_neg.Ai * IN_CU.rP_Nom;	// Negative reserve power for PRL - FC (e2m) via hardwire [kW]
				ELSE
					OUT_CU.rP_RMC_FC_pos := 0.0;											
					OUT_CU.rP_RMC_FC_neg := 0.0;											
				END_IF;
							
				IF OUT_CU.bFC_SetCOn AND Para.rFNom_LFSM_Ref <> 0 THEN				// Droop caclulation
					IF IN_CU.tP_FC_RMC_pos.Ai > 0 AND IN_CU.tP_FC_RMC_neg.Ai > 0 THEN 
						OUT_CU.rDroop_FC_pos := (Para.rF_FC_Dlt_pos - IN_CU.tGR2CU.rFSMU_GRC_DB) / IN_CU.tP_FC_RMC_pos.Ai / Para.rFNom_LFSM_Ref *100;				
						OUT_CU.rDroop_FC_neg := (Para.rF_FC_Dlt_neg - IN_CU.tGR2CU.rFSMU_GRC_DB) / IN_CU.tP_FC_RMC_neg.Ai / Para.rFNom_LFSM_Ref *100;			
					ELSIF IN_CU.tP_FC_RMC_pos.Ai > 0 AND IN_CU.tP_FC_RMC_neg.Ai = 0 THEN
						OUT_CU.rDroop_FC_pos := (Para.rF_FC_Dlt_pos - IN_CU.tGR2CU.rFSMU_GRC_DB) / IN_CU.tP_FC_RMC_pos.Ai /Para.rFNom_LFSM_Ref *100;				
						OUT_CU.rDroop_FC_neg := 0.0;
					ELSIF IN_CU.tP_FC_RMC_neg.Ai > 0 AND IN_CU.tP_FC_RMC_pos.Ai = 0 THEN
						OUT_CU.rDroop_FC_pos := 0.0;
						OUT_CU.rDroop_FC_neg := (Para.rF_FC_Dlt_pos - IN_CU.tGR2CU.rFSMU_GRC_DB) / IN_CU.tP_FC_RMC_neg.Ai / Para.rFNom_LFSM_Ref *100;				
					ELSE	
						OUT_CU.rDroop_FC_pos := 0.0;
						OUT_CU.rDroop_FC_neg := 0.0;
					END_IF;
				ELSE
					OUT_CU.rDroop_FC_pos := 0.0;
					OUT_CU.rDroop_FC_neg := 0.0;
				END_IF
				OUT_CU.bFC_SetCOn := IN_CU.tSet_FC_COn.Di;							
				OUT_CU.bFC_SetCOf := IN_CU.tSet_FC_COf.Di;						

			
			3: (* next-Box over BUS *)
				IF bSet_FC_COn_Bus THEN												
					OUT_CU.rP_RMC_FC_pos := 0.0;											
					OUT_CU.rP_RMC_FC_neg := 0.0;
					OUT_CU.rDroop_FC_pos := 0.0;
					OUT_CU.rDroop_FC_neg := 0.0;
				END_IF;
		
				OUT_CU.bSet_FC_COn_Bus := bSet_FC_COn_Bus;						
				OUT_CU.bSet_FC_COf_Bus := bSet_FC_COf_Bus;				
				OUT_CU.rP_Set_FC := INT_TO_REAL (iP_Set_FC_Bus);
			
			
			4: (* next-Box over hardwire *)
				IF OUT_CU.bFC_SetCOn THEN												
					OUT_CU.rP_RMC_FC_pos := 0.0;											
					OUT_CU.rP_RMC_FC_neg := 0.0;
					OUT_CU.rDroop_FC_pos := 0.0;
					OUT_CU.rDroop_FC_neg := 0.0;
				END_IF;
		
				OUT_CU.bFC_SetCOn := IN_CU.tSet_FC_COn.Di;												
				OUT_CU.bFC_SetCOf := IN_CU.tSet_FC_COf.Di;											
				OUT_CU.rP_Set_FC := IN_CU.tP_Set_FC.Ai * IN_CU.rP_Nom;
	
		END_CASE;		
	END_IF			
		
		
		(* Timer for acitvation of frequency control (VKW) *) 
	             
//	TON_Simulation.IN := (OUT_CU.bSet_FC_COn_Bus OR OUT_CU.bFC_SetCOn OR (Para.iSet_GrC_FSM = 1 AND NOT Para.bSet_FC_Input)) AND ((OUT_CU.rP_RMC_FC_pos > 0.0) OR (OUT_CU.rP_RMC_FC_neg > 0.0));
//		TON_Simulation.PT := T#500ms;													
//		TON_Simulation();																
//		bact_VKW := TON_Simulation.Q;			
		
		(* Test *)

	IF NOT IN_CU.tGR2CU.bLFSM_Test_On THEN
		i_Simu_Counter :=0;																
		i_Simu_Counter_Min :=0;	
	END_IF
		
	i_FC_Test_var := IN_CU.tGR2CU.iSet_FC_Testmode;							//test option	[0=no Test / 1=AUTO Default via frequency set value / 2=MAN Input via frequency set value / 3=AUTO Default via frequency current value / 4=MAN Input via frequency current value]
	rF_FC_Test_man_fn := IN_CU.tGR2CU.rFNom_FSM_ManualTest;					//man. Test - adjusting f_nom [Hz]
	rF_FC_Test_man_fist := IN_CU.tGR2CU.rFAct_FSM_ManualTest;				//man. Test - adjusting f_act [Hz]
	OUT_CU.tCU2GR.bLFSM_TestStop := FALSE;

	rF_Act	:= rF_MMD_FC;
	rF_Ref	:= IN_CU.tGR2CU.rFNom_LFSM_Ref;

	IF i_FC_Test_var = 1 THEN
		bSet_FC_Test_1 := TRUE;
	ELSE
		bSet_FC_Test_1 := FALSE;
	END_IF
		
	IF IN_CU.tGR2CU.bLFSM_Test_On THEN
		xTP_Set_FC_Test_1(IN:=bSet_FC_Test_1, PT:= T#180m);
	ELSIF xTP_Set_FC_Test_1.Q AND NOT IN_CU.tGR2CU.bLFSM_Test_On THEN
		xTP_Set_FC_Test_1(IN:=FALSE, PT:= T#0m);
	END_IF;
	
		
		IF i_FC_Test_var = 3 THEN
			bSet_FC_Test_3 := TRUE;
		ELSE
			bSet_FC_Test_3 := FALSE;
		END_IF
	
	IF IN_CU.tGR2CU.bLFSM_Test_On THEN 
		xTP_Set_FC_Test_3(IN:=bSet_FC_Test_3, PT:= T#90m);
	ELSIF xTP_Set_FC_Test_3.Q AND NOT IN_CU.tGR2CU.bLFSM_Test_On THEN
		xTP_Set_FC_Test_3(IN:=FALSE, PT:= T#0m);
	END_IF;

	IF TRUE (*IN_CU.bP_Set_FC_Enable (*AND bact_VKW*) THEN												//VKW active						
			
			//  ------------------- start TEST ---------------------
		IF xTP_Set_FC_Test_1.Q AND IN_CU.tGR2CU.bLFSM_Test_On AND NOT xTP_Set_FC_Test_3.Q THEN	//test option	[1=AUTO Default via frequency set value / 2=MAN Input via frequency set value / 3=AUTO Default via frequency current value / 4=MAN Input via frequency current value]
	
				rF_Act  := rF_MMD_FC;   												//Actual Frequency [Hz]
				rF_Ref;																	//Reference Frequency [Hz] - simulated via "Hoeckerverlauf"
	
				i_Simu_Counter := i_Simu_Counter + i_Simu_Counter_Inc;					//internal counter, z_wert = 1 (z.B. increase for simulation to 60 -> 15min "Hoecker" will speed up to a 15s "Hoecker") 
				IF i_Simu_Counter >= 600 THEN											
					i_Simu_Counter_Min := i_Simu_Counter_Min + 1;						//minute counter
					i_Simu_Counter := 0;												
				END_IF;																	
	
				CASE i_Simu_Counter_Min OF												
					0:	IF i_Simu_Counter > 0 THEN 										
							rF_Ref := Para.rFNom_LFSM_Ref + 0.2; 										
						END_IF;																		
					1..14:		rF_Ref := Para.rFNom_LFSM_Ref + 0.2;										
					15..29:		rF_Ref := Para.rFNom_LFSM_Ref + 0;											
					30..44:		rF_Ref := Para.rFNom_LFSM_Ref + 0.2;									
					45..59:		rF_Ref := Para.rFNom_LFSM_Ref + 0;										
					60..64:		rF_Ref := Para.rFNom_LFSM_Ref + 0.1;									
					65..74:		rF_Ref := Para.rFNom_LFSM_Ref + 0.2;								
					75..89:		rF_Ref := Para.rFNom_LFSM_Ref + 0;				
					90..104:	rF_Ref := Para.rFNom_LFSM_Ref - 0.2;						
					105..119:	rF_Ref := Para.rFNom_LFSM_Ref - 0;										
					120..134:	rF_Ref := Para.rFNom_LFSM_Ref - 0.2;											
					135..149:	rF_Ref := Para.rFNom_LFSM_Ref - 0;										
					150..154:	rF_Ref := Para.rFNom_LFSM_Ref - 0.1;									
					155..164:	rF_Ref := Para.rFNom_LFSM_Ref - 0.2;									
					165..179:	rF_Ref := Para.rFNom_LFSM_Ref - 0;									
					180:		rF_Ref := Para.rFNom_LFSM_Ref; 	
						i_Simu_Counter :=0;																
						i_Simu_Counter_Min :=0;																
					OUT_CU.tCU2GR.bLFSM_TestStop := TRUE;					
			END_CASE;																		
	
	
		ELSIF i_FC_Test_var = 2 AND IN_CU.tGR2CU.bLFSM_Test_On THEN						//test option	[2=MAN Input via frequency set value]
				(* selectable frequency ramp rate for test *)//LE_a 27.11.2019
				xRAMP_F_Ref(enable:= VIS2MM.bLFSM_TestFRamp_Active, In:= rF_FC_Test_man_fn, Rise:= VIS2MM.rLFSM_TestFRampRate, Sink:= VIS2MM.rLFSM_TestFRampRate, TC_Time:= 100);(* 0.007: 100->50% ca.35" *)

				rF_Act  := rF_MMD_FC;													//Actual Frequency [Hz]
				rF_Ref  := xRAMP_F_Ref.Out;// rF_FC_Test_man_fn;//LE_e					//man. Test - adjusting f_nom	[Hz]

				i_Simu_Counter :=0; i_Simu_Counter_Min :=0;														
		
		ELSIF xTP_Set_FC_Test_3.Q AND IN_CU.tGR2CU.bLFSM_Test_On AND NOT xTP_Set_FC_Test_1.Q THEN	//test option	[3=AUTO Default via frequency current value]
	
				rF_Ref  := Para.rFNom_LFSM_Ref;	
				rF_Act;																	//Actual Frequency [Hz] - simulated via "Hoeckerverlauf"
	
				i_Simu_Counter := i_Simu_Counter + i_Simu_Counter_Inc;					//internal counter, z_wert = 1 (z.B. increase for simulation to 60 -> 15min "Hoecker" will speed up to a 15s "Hoecker")
				IF i_Simu_Counter >= 600 THEN															
					i_Simu_Counter_Min := i_Simu_Counter_Min + 1;						//min counter
					i_Simu_Counter := 0;																
				END_IF;																	
	
				CASE i_Simu_Counter_Min OF																										
					0:			IF i_Simu_Counter > 0 THEN 											
								rF_Act := Para.rFNom_LFSM_Ref; 												
						END_IF;																						
						1..14:		rF_Act := Para.rFNom_LFSM_Ref - 0.2;								
						15..29:		rF_Act := Para.rFNom_LFSM_Ref - 0;									
						30..44:		rF_Act := Para.rFNom_LFSM_Ref - 0.2;								
						45..59:		rF_Act := Para.rFNom_LFSM_Ref - 0;									
						60..74:		rF_Act := Para.rFNom_LFSM_Ref - 0.2;								
						75..89:		rF_Act := Para.rFNom_LFSM_Ref - 0;									
						90    :		rF_Act := Para.rFNom_LFSM_Ref;																		
						i_Simu_Counter :=0;											
						i_Simu_Counter_Min :=0;										
					OUT_CU.tCU2GR.bLFSM_TestStop := TRUE;
			END_CASE;															
		
		ELSIF i_FC_Test_var = 4 AND IN_CU.tGR2CU.bLFSM_Test_On THEN						//test option	[4=MAN Input via frequency current value]	
			xRAMP_F_Act(enable:= TRUE, In:= rF_FC_Test_man_fist, Rise:= VIS2MM.rLFSM_TestFRampRate, Sink:= VIS2MM.rLFSM_TestFRampRate, TC_Time:= 100);(* 0.007: 100->50% ca.35" *)
			IF VIS2MM.bLFSM_TestFRamp_Active THEN	rF_Act  := xRAMP_F_Act.Out; 		//man. Test - adjusting f_act [Hz] frequency ramp rate for test *)//LE 27.11.2019
			ELSE									rF_Act  := rF_FC_Test_man_fist;		//man. Test - adjusting f_act [Hz] no ramp
			END_IF;
			rF_Ref  := Para.rFNom_LFSM_Ref;

			i_Simu_Counter :=0; i_Simu_Counter_Min :=0;						
			//  ------------------- end TEST ---------------------------	

		ELSIF i_FC_Test_var = 5 THEN													//test option 5 --> earlier test option 3	[5=AUTO Default via frequency current value]
												
				rF_Ref  := Para.rFNom_LFSM_Ref;	
				rF_Act;																	//Actual Frequency [Hz] - simulated via "Hoeckerverlauf"
	
				i_Simu_Counter := i_Simu_Counter + i_Simu_Counter_Inc;					//internal counter, z_wert = 1 (z.B. increase for simulation to 60 -> 15min "Hoecker" will speed up to a 15s "Hoecker")
				IF i_Simu_Counter >= 600 THEN															
					i_Simu_Counter_Min := i_Simu_Counter_Min + 1;						//min counter
					i_Simu_Counter := 0;																
				END_IF;																	
	
				CASE i_Simu_Counter_Min OF																										
					0:			IF i_Simu_Counter > 0 THEN 											
							rF_Act := Para.rFNom_LFSM_Ref + 0.2; 												
					END_IF;																						
					1..14:		rF_Act := Para.rFNom_LFSM_Ref - 0.2;								
					15..29:		rF_Act := Para.rFNom_LFSM_Ref - 0;									
					30..44:		rF_Act := Para.rFNom_LFSM_Ref - 0.2;								
					45..59:		rF_Act := Para.rFNom_LFSM_Ref - 0;									
					60..64:		rF_Act := Para.rFNom_LFSM_Ref - 0.1;								
					65..74:		rF_Act := Para.rFNom_LFSM_Ref - 0.2;								
					75..89:		rF_Act := Para.rFNom_LFSM_Ref - 0;									
					90..104:	rF_Act := Para.rFNom_LFSM_Ref + 0.2;								
					105..119:	rF_Act := Para.rFNom_LFSM_Ref + 0;									
					120..134:	rF_Act := Para.rFNom_LFSM_Ref + 0.2;										
					135..149:	rF_Act := Para.rFNom_LFSM_Ref + 0;									
					150..154:	rF_Act := Para.rFNom_LFSM_Ref + 0.1;								
				155..164:	rF_Act := Para.rFNom_LFSM_Ref + 0.2;								
					165..179:	rF_Act := Para.rFNom_LFSM_Ref + 0;									
					180:		rF_Act := Para.rFNom_LFSM_Ref;											
						i_Simu_Counter :=0;											
						i_Simu_Counter_Min :=0;										
				END_CASE;						
		ELSE
			(* execute xRAMP_F_x always to avoid long settling time with test activation *)
			xRAMP_F_Ref(enable:= FALSE, In:= Para.rFNom_LFSM_Ref, Rise:= VIS2MM.rLFSM_TestFRampRate, Sink:= VIS2MM.rLFSM_TestFRampRate, TC_Time:= 100);(* 0.007: 100->50% ca.35" *)
			xRAMP_F_Act(enable:= FALSE, In:= Para.rFNom_LFSM_Ref, Rise:= VIS2MM.rLFSM_TestFRampRate, Sink:= VIS2MM.rLFSM_TestFRampRate, TC_Time:= 100);(* 0.007: 100->50% ca.35" *)
																		
			rF_Act := rF_MMD_FC;													//Actual Frequency [Hz]
			rF_Ref := IN_CU.tGR2CU.rFNom_LFSM_Ref;									//Reference Frequency / Nominal Frequency [Hz]
			i_Simu_Counter     := 0; 
			i_Simu_Counter_Min := 0;																	
		END_IF;								
		(*-----------------------------------------------------------------------------*)	
	END_IF;

	OUT_CU.tF_FSM_Simulated.Ao := MM2VIS.rF_MMD_FC := OUT_CU.rF_Act := rF_Act;
	                                                  OUT_CU.rF_Ref := rF_Ref;


	(* visualization *)
	
	MM2VIS.rF_FC_Deadband_pos := IN_CU.tGR2CU.rFNom_LFSM_Ref + IN_CU.tGR2CU.rFSMU_GRC_DB;  
	MM2VIS.rF_FC_Deadband_neg := IN_CU.tGR2CU.rFNom_LFSM_Ref - IN_CU.tGR2CU.rFSMO_GRC_DB; 
	MM2VIS.rF_FC_Dlt_pos := IN_CU.tGR2CU.rFNom_LFSM_Ref + Para.rF_FC_Dlt_pos;  
	MM2VIS.rF_FC_Dlt_neg := IN_CU.tGR2CU.rFNom_LFSM_Ref - Para.rF_FC_Dlt_neg; 

	IF NOT Para.bSet_FC_Input THEN
		MM2VIS.bFC_SOn := IN_CU.tGR2CU.bSet_GrC_FSM;
		MM2VIS.rF_FC_Delta := rF_FC_Delta;
		MM2VIS.rF_MMD_FC := rF_Act; 
		MM2VIS.rF_Ref := rF_Ref;
		MM2VIS.rP_Act_Filt := rP_Act_Filt;
		MM2VIS.rP_Set_FC := IN_CU.rP_Set_FC_Norm * IN_CU.rP_Nom;
		MM2VIS.rP_RMC_FC_pos := IN_CU.tGR2CU.rMarg_GrC_FSM_Pos * IN_CU.rP_Nom;				(* Positive reserve power *)
		MM2VIS.rP_RMC_FC_neg := IN_CU.tGR2CU.rMarg_GrC_FSM_Neg * IN_CU.rP_Nom;				(* Negative reserve power *) 
	END_IF


	IF Para.bSet_FC_Input THEN
		CASE Para.iSet_FC_ExtInp OF  
		1,2 : (* GEJ internal calculation / Energy2Market *)
			MM2VIS.bFC_SOn := IN_CU.bFC_SOn_Bus OR IN_CU.tFC_SOn.Do;
			MM2VIS.rP_FC_ContOutput:= IN_CU.rP_FC_ContOutput;			(* PRL Controller Output *)
			MM2VIS.rP_RMC_FC_pos := OUT_CU.rP_RMC_FC_pos;				(* Positive reserve power *)
			MM2VIS.rP_RMC_FC_neg := OUT_CU.rP_RMC_FC_neg;				(* Negative reserve power *)
			MM2VIS.i_FC_Test_var := i_FC_Test_var;
			MM2VIS.rF_FC_Delta := rF_FC_Delta;
			MM2VIS.rF_MMD_FC := rF_MMD_FC; 
			MM2VIS.rF_Ref := rF_Ref;
			MM2VIS.rP_Act_Filt := rP_Act_Filt;
			MM2VIS.rP_Set_FC := IN_CU.rP_Set_FC_Norm * IN_CU.rP_Nom; 			

		3,4 : (* external power demand / Next-Box *)
			MM2VIS.bFC_SOn := IN_CU.bFC_SOn_Bus OR IN_CU.tFC_SOn.Do;
			MM2VIS.rF_MMD_FC := rF_MMD_FC; 
			MM2VIS.rF_Ref := rF_Ref;
			MM2VIS.rP_Act_Filt := rP_Act_Filt;
			MM2VIS.rP_Set_FC := OUT_CU.rP_Set_FC;

		END_CASE
	END_IF

END_PROGRAM
