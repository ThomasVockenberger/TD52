(*******************************************************************************
Ctr_OutlVentRDP		controller engine room differential pressure with outlet ventilation fan(s)	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.04.0		06.10.2016	Stary			created
			02.11.2016	lettenb.		% scaling corr., cleanup
			15.11.2016  Stary		    added manual operation aux-control for outlet-ventilation
			04.01.2017  Stary           correction of task after test on simulator
V4.11.0		28.01.2022	Perktold		included plant controller upgrade

Specification       : PID-controller for outlet ventilation fan(s) to ensure a constant room differential pressure
		
Instructions for use: Modify release/X/external Y customized when needed
--------------------

Outstandings: 
------------	
(*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameter *)
	Para.tCtr_OutlVE_RDP.W_set;	
	Para.tCtr_OutlVE_RDP.W_set2;	
	Para.tCtr_OutlVE_RDP.W_min;
	Para.tCtr_OutlVE_RDP.W_max;
	Para.tCtr_OutlVE_RDP.dW_up;
	Para.tCtr_OutlVE_RDP.dW_down;
	Para.tCtr_OutlVE_RDP.deadband;
	Para.tCtr_OutlVE_RDP.Y_min;
	Para.tCtr_OutlVE_RDP.Y_max;
	Para.tCtr_OutlVE_RDP.dY_max;
	Para.tCtr_OutlVE_RDP.Y_block;
	Para.tCtr_OutlVE_RDP.invert;
	Para.tCtr_OutlVE_RDP.Kp;
	Para.tCtr_OutlVE_RDP.Tn;
	Para.tCtr_OutlVE_RDP.Tv;
	Para.tCtr_OutlVE_RDP.Kp_GainScheduling;
	Para.tCtr_OutlVE_RDP.Tn_GainScheduling;
	Para.tCtr_OutlVE_RDP.Tv_GainScheduling;
	Para.tCtr_OutlVE_RDP.t_min_pulse_down;
	Para.tCtr_OutlVE_RDP.t_min_pulse_up;
	Para.tCtr_OutlVE_RDP.t_period_down;
	Para.tCtr_OutlVE_RDP.t_period_up;

	(* Time delay door-contact, to wait for correct measuring value room differential pressure after MSF --> avoid jump of Y *)
	TON_DC(IN := IN_VE.tER_DoorClosed.Di , PT := T#5s); 
	bTON_DoorContact := TON_DC.Q;
	
	(* Input variables *)
	tCtr_OutlVE_RDP_In	 		:= VIS2MM.tCtr_OutlVE_RDP_In;

	(* Input from module *)
	tCtr_OutlVE_RDP_In.enable	:=	IN_VE.tPB2MM.bParaSetupOk		(* enable controller *)
							AND	    Para.bCtr_OutlVE_RDP 
							AND     OUT_VE.tRel_ER_FC.Do
							AND	    RTM25 
							AND     OUT_VE.tRel_ER_Fan.Do
							AND		bTON_DoorContact
							AND NOT MM2VIS.bMsg3367
							AND NOT MM2VIS.bMsg2705
							AND NOT bCtrER_YFix;
	
	tCtr_OutlVE_RDP_In.W_ext_Active		:= FALSE;		(* select external W *) //from visu 
	tCtr_OutlVE_RDP_In.W_ext        	:= 0;
	tCtr_OutlVE_RDP_In.W_set2_Active	:= FALSE;		(*Input to define which internal setpoint will be used TRUE = use the 2nd set point | FALSE use the normal "1st" one*)
	tCtr_OutlVE_RDP_In.GainScheduling	:= 0.0;			(*Input for Gain Scheduling: 0.0 = use 100% of the Standard PID-Parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between*)
	tCtr_OutlVE_RDP_In.Y_min_cust		:= -1.0;		(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	tCtr_OutlVE_RDP_In.Y_max_cust		:= 1.0;			(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	tCtr_OutlVE_RDP_In.Retrigger		:= FALSE;		(*a rising edge on this input signals the controller to retrigger - set W on X and force the Integrator to the current Y*)
	tCtr_OutlVE_RDP_In.A;								(*optional: feed forward Input*)
	
	(* Special operation-modes of PID-controller *)
	
		// Gas-pre-alarm/gas-alarm:
		    (* use of external Yset --> totally open the louver(s) *)
				IF IN_VE.bMsg1052 OR IN_VE.bMsg1053 THEN				
					tCtr_OutlVE_RDP_In.Y_set_Active := TRUE;
					tCtr_OutlVE_RDP_In.Y_set := 1.0; 
					RAMPE_Y_set_intern := FALSE;
					
		// Fire-alarm:
			(* use of external Yset --> totally close the louver(s) *)
				ELSIF IN_VE.bMsg1054 THEN								
					tCtr_OutlVE_RDP_In.Y_set_Active := TRUE;
					tCtr_OutlVE_RDP_In.Y_set := 0.0;
					RAMPE_Y_set_intern := FALSE;
					
		// Engine room door-sensors tripped: 
			(* use of internal Yset = last setpoint when ctr was active + slow PID-ramp *)
				ELSIF NOT bTON_DoorContact THEN							
					tCtr_OutlVE_RDP_In.Y_set_Active := TRUE;
					Y_set_intern := rCtr_OutlVe_RDP_Y_old;  (* guilty for max. 15s, if doors are longer open then shutdown with bMsg3367 *)
					RAMPE_Y_set_intern := TRUE;
				
		// Measuring signal failure room differential pressure:
			(* use of internal Yset = ctr-signal from inlet ventilation + offset-para [13586] + slow PID-ramp *)
				ELSIF MM2VIS.bMsg2705 THEN								
					tCtr_OutlVE_RDP_In.Y_set_Active := TRUE;
					Y_set_intern := tCtr_ER_Out.Y + (Para.rVent_SpeedDif);
					RAMPE_Y_set_intern := TRUE;
							
		// Manual operating auxiliaries control - Handbedienebene 
				ELSIF (NOT tCtr_OutlVE_RDP_In.enable AND OUT_VE.tRel_ER_FC.Do AND IN_VE.tManAuxCtr.bER_OutlV_FC_Set) THEN	
					tCtr_OutlVE_RDP_In.Y_set_Active  := TRUE;
					tCtr_OutlVE_RDP_In.Y_set         := IN_VE.tManAuxCtr.rER_OutlV_FC_Set;	
					RAMPE_Y_set_intern := FALSE;	
						
		// normal PID mode
				ELSE
					tCtr_OutlVE_RDP_In.Y_set_Active := FALSE;
					RAMPE_Y_set_intern := FALSE;
					Y_set_intern := tCtr_OutlVE_RDP_Out.Y;
				END_IF;	
	
	(* slow PID-ramp *)
		RAMPE_R_0(enable := TRUE, In := Y_set_intern, Rise := 0.01, Sink := 0.01, TC_Time := 100);
	
		IF RAMPE_Y_set_intern THEN
			tCtr_OutlVE_RDP_In.Y_set := RAMPE_R_0.Out;
		END_IF
	
		
	tCtr_OutlVE_RDP_In.X := IN_VE.tPrDiff_ER.Ai;				(* select X *)
	
	(* add offset to Y *)	
	xSigScal_R_CtrRDP_CtrER.X  := tCtr_ER_Out.Y;				(* scaling from setpoint ctr engine room to offset for use in outlet ventilation ctr *)
	xSigScal_R_CtrRDP_CtrER.X1 := Para.rScal_CtrInlVentER_Set_Min;
	xSigScal_R_CtrRDP_CtrER.X2 := Para.rScal_CtrInlVentER_Set_Max;
	xSigScal_R_CtrRDP_CtrER.Y1 := Para.rScal_OffSetMin_CtrOutlVent;
	xSigScal_R_CtrRDP_CtrER.Y2 := Para.rScal_OffSetMax_CtrOutlVent;
	xSigScal_R_CtrRDP_CtrER();
	
	xSigScal_R_CtrRDP_EngP.X  := IN_VE.rP_Act_Norm_Filt;		(* scaling from actual engine power to offset for use in outlet ventilation ctr *)
	xSigScal_R_CtrRDP_EngP.X1 := Para.rScal_PminEl;
	xSigScal_R_CtrRDP_EngP.X2 := Para.rScal_PmaxEl;
	xSigScal_R_CtrRDP_EngP.Y1 := Para.rScal_OffSetMin_Pel;
	xSigScal_R_CtrRDP_EngP.Y2 := Para.rScal_OffSetMax_Pel;
	xSigScal_R_CtrRDP_EngP();
		
			
	(* Input from Visualization via OPC *)
	tCtr_OutlVE_RDP_In.Y_man_Active;				
	tCtr_OutlVE_RDP_In.Y_man;					
	tCtr_OutlVE_RDP_In.X_min; 					
	tCtr_OutlVE_RDP_In.X_max; 					
	tCtr_OutlVE_RDP_In.Tune_quality;			
	tCtr_OutlVE_RDP_In.Tune_PI;					
	tCtr_OutlVE_RDP_In.Tune_PID;					
	tCtr_OutlVE_RDP_In.Tune_start;				
	tCtr_OutlVE_RDP_In.Tune_stop;				
	tCtr_OutlVE_RDP_In.Tune_takeover;		
	
	xCtr_OutlVE_RDP();
	
	(* Writing of actual Y on internal variable *)
	
	IF bTON_DoorContact THEN
		rCtr_OutlVe_RDP_Y_old	        := tCtr_OutlVE_RDP_Out.Y;	(* used as setpoint if engine room door-sensors have tripped *)
	END_IF;	
		
		
	(* Output variables function block *)
	(* Output to module(s) *)
	
		// Control of outlet ventilation speed depending on ctr-signal inlet ventilation:
		// --> activation with parameter [13846]
			IF tCtr_OutlVE_RDP_In.enable AND Para.bCtr_RDP_OutlVE_Dep_InlVent AND NOT Para.bCtr_RDP_OutlVE_Dep_EngP THEN
				OUT_VE.tCtr_OutlVE_RDP_Set.Ao := LIMIT(0.0, tCtr_OutlVE_RDP_Out.Y + xSigScal_R_CtrRDP_CtrER.Y_SCAL, 1.0); (* analog out *)
		
		// Control of outlet ventilation speed depending on actual engine power:
		// --> activation with parameter [13847] 
			ELSIF tCtr_OutlVE_RDP_In.enable AND Para.bCtr_RDP_OutlVE_Dep_EngP AND NOT Para.bCtr_RDP_OutlVE_Dep_InlVent THEN						
				OUT_VE.tCtr_OutlVE_RDP_Set.Ao := LIMIT(0.0, tCtr_OutlVE_RDP_Out.Y + xSigScal_R_CtrRDP_EngP.Y_SCAL, 1.0); (* analog out *)		
	
		// Control of outlet ventilation speed depending on inlet ventilation and actual engine power:
		// --> activation with parameter [1346+13847]		
			ELSIF tCtr_OutlVE_RDP_In.enable AND Para.bCtr_RDP_OutlVE_Dep_InlVent AND Para.bCtr_RDP_OutlVE_Dep_EngP THEN 
				OUT_VE.tCtr_OutlVE_RDP_Set.Ao := LIMIT(0.0, tCtr_OutlVE_RDP_Out.Y + xSigScal_R_CtrRDP_CtrER.Y_SCAL + xSigScal_R_CtrRDP_EngP.Y_SCAL, 1.0); (* analog out *)
		
			ELSE
				OUT_VE.tCtr_OutlVE_RDP_Set.Ao   := tCtr_OutlVE_RDP_Out.Y;		(* analog out *)
			END_IF;	
	
	(* Output to Visualization via OPC *)	
	MM2VIS.tCtr_OutlVE_RDP_Out		:= tCtr_OutlVE_RDP_Out;
	MM2VIS.rCtr_OutlVE_RDP_Set      := OUT_VE.tCtr_OutlVE_RDP_Set.Ao;
	VIS2MM.tCtr_OutlVE_RDP_In		:= tCtr_OutlVE_RDP_In;		(* write back to IN_struct for reset: Tune_takeover, X-display, ...!*)	


	tCtr_OutlVE_RDP_Out.Active;
	tCtr_OutlVE_RDP_Out.Y;		
	tCtr_OutlVE_RDP_Out.W;		
	tCtr_OutlVE_RDP_Out.e;		
	tCtr_OutlVE_RDP_Out.Kp_tune;	
	tCtr_OutlVE_RDP_Out.Tn_tune;	
	tCtr_OutlVE_RDP_Out.Tv_tune;	
	tCtr_OutlVE_RDP_Out.status;
	tCtr_OutlVE_RDP_Out.Step_down;
	tCtr_OutlVE_RDP_Out.Step_up;



END_PROGRAM
